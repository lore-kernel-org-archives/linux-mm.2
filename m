Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1B51E73161
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 11:37:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 674556B00A1; Mon,  2 Feb 2026 06:37:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64BD36B00A4; Mon,  2 Feb 2026 06:37:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 524376B00A7; Mon,  2 Feb 2026 06:37:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 444606B00A1
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 06:37:07 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D614A8CD6A
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 11:37:06 +0000 (UTC)
X-FDA: 84399315252.29.B6E9001
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013041.outbound.protection.outlook.com [40.93.201.41])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0B5B12000E
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 11:37:03 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=qoCuvidE;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf03.hostedemail.com: domain of jniethe@nvidia.com designates 40.93.201.41 as permitted sender) smtp.mailfrom=jniethe@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770032224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FAkI9VxwxIbRZC/CL+/I9Nh8h6L8MkB/RJXfeqjrQbk=;
	b=fdxqzV5ptrAMgi3mH2VVsN32s6jo7L728oyOlfKU9c+xi3nY+RKZZP/af3A3pKgP9AmheW
	fFyCV+hGBttE1g1w4GFbx7Eq5HXugv2ZmVqBz469/k4hD7i9APA6cxGnvYEmLV19cKbNNb
	0Hd3KGmfIlRIZ80vqTGlbhvokGYxiio=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770032224; a=rsa-sha256;
	cv=pass;
	b=6clNj9DQ+bfnsO4xQQbTp4/NvHII73UrGKy8G0vquugSP0u7XpLOnYWSCtiqecKsahCGhV
	jXJrjxXm5WE2G3XHeJ4RDIytsq3Fl8z/ZlMyxpj4WRuL0zQN5PxaImPZrSVpHnZwFQKKgC
	vpKYPHtEym+ba2X6E5EnKKHviw2BlJ0=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=qoCuvidE;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf03.hostedemail.com: domain of jniethe@nvidia.com designates 40.93.201.41 as permitted sender) smtp.mailfrom=jniethe@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IM5pDUrrnhOVCWz9/cxEteEnnwf51s3UU4eqJ6FL0ZllBZ+1U3D9c84JIV0r6QsGmC8rzQVfkuko88fWIiO0rn8NovlgEgHUrf87xzYkfK1HS4Pp0vpfzeVkyxTgJDdHNgwkH19Sbq8Hg9ISFBnPppNwHPICOL/W9Usn3aZKvhFVEP92Xj1M/lWFMBRsaUIbCT6NHNTsEpq2g3alyCRlF2d8cevC+N9r30QZ6hz3MnYTqGM6bMK0uDZjok5whv9A1saSTdqKVJFiQhUnAP5DFgLh+2yl0t9XBC3nx0FtHDtECFukK3nIqSZ7jVhHEWjjzQa1gj2L9UG2SP2LLQQsoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FAkI9VxwxIbRZC/CL+/I9Nh8h6L8MkB/RJXfeqjrQbk=;
 b=BO2N5lAcSDhaedF+Pk2AwnUNq9Zank9ypKiI4jnVrMMSC3/UGXjFJG+UkrGXvW7U8hGExrWTtEI4mp/q60aP8ajPOEkJashCLzrSBxFfZm5nkFSc+0ThuRuDmNpNs4l1iBUoCKYBInSUwnfsVE90GBt26ND/1dlkWypedPMqkl5f82v51IMV9bANoo2B2/MAmrRTUOigw//2/rIZzqegYTHSX+Le1rhympN2Yvl/5uhFo9PszE2dkoJlfL6IRmalTWaNiJlXXCfW0XbFSdkULx9wan0s+1jZ6LHJfSmt5b49o4ZFn1MPiAlYxKBGJ/JaCfq5q4Lj6uX85ccLlwo9gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FAkI9VxwxIbRZC/CL+/I9Nh8h6L8MkB/RJXfeqjrQbk=;
 b=qoCuvidEZaYixDBgP4Hnbc0461ePQ3i1Qfi9hRUzXnLq+q/d31F7zO1e680ap1w7obyhfC0kAnd/i/0ERwd3jXz/gOuBfFWSzD1sVBn1bL/2EtmSDBtq5OBpYTsjJki5qW+iS6orUJDvORKkEo4lBoNo6zQKtgtzJF4T04GJXo+I+AoqEsDiu/z0cxc8yoFG4/J06v02FMI0/Jk+g/52NbcVRuut+6uzxfi4qiunylK1IWMnmaMzbZ1QbP/8y2Gc+nyB2BETsXwIOORE2soGL+usBOHm63JVze6+JzYe15LonGPKmTeApPgbndNrH2DgJ8HGdSUJ+PGGs5i0CfVUqw==
Received: from DM4PR12MB9072.namprd12.prod.outlook.com (2603:10b6:8:be::6) by
 LV9PR12MB9758.namprd12.prod.outlook.com (2603:10b6:408:2bd::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.16; Mon, 2 Feb 2026 11:36:53 +0000
Received: from DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1]) by DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1%5]) with mapi id 15.20.9564.016; Mon, 2 Feb 2026
 11:36:53 +0000
From: Jordan Niethe <jniethe@nvidia.com>
To: linux-mm@kvack.org
Cc: balbirs@nvidia.com,
	matthew.brost@intel.com,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	david@redhat.com,
	ziy@nvidia.com,
	apopple@nvidia.com,
	lorenzo.stoakes@oracle.com,
	lyude@redhat.com,
	dakr@kernel.org,
	airlied@gmail.com,
	simona@ffwll.ch,
	rcampbell@nvidia.com,
	mpenttil@redhat.com,
	jgg@nvidia.com,
	willy@infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	intel-xe@lists.freedesktop.org,
	jgg@ziepe.ca,
	Felix.Kuehling@amd.com,
	jniethe@nvidia.com,
	jhubbard@nvidia.com,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	ying.huang@linux.alibaba.com
Subject: [PATCH v6 02/13] drm/amdkfd: Use migrate pfns internally
Date: Mon,  2 Feb 2026 22:36:31 +1100
Message-Id: <20260202113642.59295-3-jniethe@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260202113642.59295-1-jniethe@nvidia.com>
References: <20260202113642.59295-1-jniethe@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR03CA0003.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::8) To DM4PR12MB9072.namprd12.prod.outlook.com
 (2603:10b6:8:be::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB9072:EE_|LV9PR12MB9758:EE_
X-MS-Office365-Filtering-Correlation-Id: 006fc2c6-ed42-48d9-9a37-08de624f5cf8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?qFcgcVNUs82kFXW9gQfz1/EYnL5540hEr9GvUGzPMKnzrrfDp1jTpN0jsmmx?=
 =?us-ascii?Q?xdb//WK2+OYNMZeAmPQHJtlBS7luvRgTfnhwmFniH+XkTtbY1i2v4NgbEFoL?=
 =?us-ascii?Q?qlLPrUa5PaTLHJaYhQhuFDvykJWaRKgoXbRXPQKwuphz/sEzUgey5ZyQZVUA?=
 =?us-ascii?Q?DNDOureTk6+4OV5xIPwlN63aAnDDsmE/MUqeh7XaKPbtBAv9BCdP4tD4fbtR?=
 =?us-ascii?Q?TR7Qkigp1CFo7e8rpTbh4I6WdffLyZ26CNCATJG5GHhltjCO+07mGz2o42AT?=
 =?us-ascii?Q?qyZad1rAE+56fZBOC/qbYM9yWM/wHn+GhC010hmX5MwsMHi/zAAekUGKfWP/?=
 =?us-ascii?Q?GGfKApY8dDEwCAUAQvxSrhJMIGEGtZvYC9hdLKpWWIz6dZ9IdkMfcAgdfpFU?=
 =?us-ascii?Q?y+eeDiAIZzFJQgBmw+EdgdwMR6qVS5rRutsXYXehpFhVKSDpw4Cks27c3ot/?=
 =?us-ascii?Q?UD6vMcd7npFZMSLB48oaKlS9AoX7SGUBybl4iKfgzzZx3lJh+e80J2ibMHky?=
 =?us-ascii?Q?INBh9zmmiGLrIDfIIKLPEBDoCAK+XhcTCAhWth7E7tLkhF+JdDRjjR8nLV+l?=
 =?us-ascii?Q?CK4YHSEpRnTSOemSz0mhO6JZL2xgmykLFn9qZfGwRD8JIwc2dR1b1XxAljRH?=
 =?us-ascii?Q?/QPureoK8QrYX14j8X6uHMe6eAU++GwG76gClcjopSNhvDFipcfV9koqhQOz?=
 =?us-ascii?Q?+6ksRG5yk7z5xOCS1DmwLx54+BB0IhGiFtI/16pCnwjYd1kkb7uOwTDo53u8?=
 =?us-ascii?Q?2tb3xVZPAms/d50ODGfDt0mMqtv1AfDLIOR1aW7GCc4Feqz90LbaxYy8h/XV?=
 =?us-ascii?Q?3pJyEIexVuZFZsHJkZ9zH/Lz0JqAfw0dmZryNJCqiEXM5Tx/BUqRTu9dVLc1?=
 =?us-ascii?Q?z/QU/9eOLw2JhnDhIUV1SU2QggLogIiwQvOCmGFsxeuKcn13Ix6a0Ptdy7Lr?=
 =?us-ascii?Q?tPq+0EvrNb+VlR3h7ExWq3T+bFAL/pUntda0wr73NE+xZ6m/r5KFpsM35XLs?=
 =?us-ascii?Q?4hqPhL6xxeeZpqQh40jwGmJXDFHN0CYyKl3nI7czy1mhnJA61HLWgS1xHqal?=
 =?us-ascii?Q?Xu4vqfof8MZg8x7tV8TiL3qe+JWwBU3RS7FEzy17OcM2aNZp62L3KoExHnrV?=
 =?us-ascii?Q?SDx39eKJgi/oooBUne9eHjFpeQEV8ZrYeFaTQqBz3KWoiG6f8PSWIphDvH4s?=
 =?us-ascii?Q?vcXS3eaE7j3p7wi+Upf8lNwmS8IB/mQJ0doXjxF4TC1mmx8/A7zUJiFNoCq7?=
 =?us-ascii?Q?/3JDSJEywPouT3kqIvqTNnIvaKwDL5JUjzJ7baqItGxy0Ro24T0hhMDgpujH?=
 =?us-ascii?Q?NIWg8JkxJa/CZ7ep/xoWyD7o5INVjvM1MTPjAkBwpx0P1muT0bQafBCsa/Sv?=
 =?us-ascii?Q?ieZu2euzf16c5GYhe85GB+L2QDZl5dzyh3cUHBWmpD2W96wvH5JIROBSc+Dd?=
 =?us-ascii?Q?lkL0jAfuQKPPjAJRQLWgo3gVczDD8WzQij7WTOrZEzKoqmiqt8VAPdyVQKEV?=
 =?us-ascii?Q?+Y4MqFOa9MzZycn2Pu2xVZixDN8Fdy1N2rdHePjMXvN4B+zYte5bursKb0I2?=
 =?us-ascii?Q?Wq9gnEVcU1CC3v1eURE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB9072.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?tzM5IkgmW/VJR5AjY3JWuh74tx4PSo8nMz2T90dpVuHtt2msk4LVOrK/XltI?=
 =?us-ascii?Q?flVsCgqU0+YCd5nTI0/EPscvcqVvZA9DDjy+1U0zmyydD4JF2B5rDORatxMg?=
 =?us-ascii?Q?JiATOEkxmHcwQudo7IpFz032clwn2SWiSw1u/5O8fvApSNPWovwD91H3cuAy?=
 =?us-ascii?Q?PQKNX0GYVzoyElU6tHIHmiOYoK5RmE1xINNkliRLDZfOP4RRiR4W7ETFpFUD?=
 =?us-ascii?Q?JTs2UWceC/9wWKhMl1yMibhklWbSOIH7Oa3y10cyUWj2mJZ1gnRJUu6Inncl?=
 =?us-ascii?Q?qOlG2OsnVFQHDUqX/+4c8qrkqbi7ieZaL87Pmm05OdAXNKWvQoZv1q4WIjep?=
 =?us-ascii?Q?I0AAWJQ4Qaj98qxTOF5uYQX6OFZaT2au+VhmUNVq6ta73vqt0DdWyfIG0raC?=
 =?us-ascii?Q?2OJCEAuW7zRoksJ/zprKRxUG4RbRCWtsyk6ZY485BKWiqvPF/ue8690s3OnN?=
 =?us-ascii?Q?rIG2A1iaTWb3QN/L1CLBGWgQl7QQAlGVyqyhg0gV6kOYkNBMvL+eskN4ar4G?=
 =?us-ascii?Q?UimTcqNplnP/CEtrcznAUwuxyXa7MlY8SxSs3uZEaUxSaR1liLonXaphOqxA?=
 =?us-ascii?Q?z/iPSz832u1itgYnOGhEn5pFOFCCzgMSRwpY9rGj9gPQr0Cak7a3Lt8E9hp+?=
 =?us-ascii?Q?oY9zvmPXnTedOZYFQ9oBV7QsDAeS4Whx/f+z1I1h51kvFiTpEafFDj1TYM5l?=
 =?us-ascii?Q?J4+dO5Qt/kNtzwWK7wgj0tvlVaJNjX6xKfK2Orl9JRyz/hVCHMhKKQDV9w0r?=
 =?us-ascii?Q?OpvRgq1X7OI9kkuJ+xbYHdxB8cIa7YMZdrYR5hnf08m02rw+pV7URBcI1ZkD?=
 =?us-ascii?Q?z1aB3ABFm5xB36zrcN/nQfgQmA5DwqsI0/IYRQCX+2s3w7DWSTNUX7g09g86?=
 =?us-ascii?Q?U1+074c3tTqbqk9pJvIFb5jJpq46qEFtPPim/SCXy/6Y177cCBBgB3Zai9++?=
 =?us-ascii?Q?w6xYtP1393iNTalxBpJqSWF2vUz7F9l7+ScFP0nxRT15P+qobaQQ2TGx+9xz?=
 =?us-ascii?Q?y5hNt7DZkDbLpm3KBSlFEnN/TmhDiZILCFqstyj1r4CviSkN/H89SJPFdnX2?=
 =?us-ascii?Q?IqMde6r2YrGxoxqmEfjDfg5pjDArwbgnOMV2HSay1S2Pyz/mb30NgYwwkhnZ?=
 =?us-ascii?Q?jvKfsuIieFuTIoI2AUh87wnn7U89nPuvEZYMfLjolN271oJRNww52AB/Rr0K?=
 =?us-ascii?Q?JqO/69ZilZ4yIiqZtO/IZLkL2q5IMoIONqOqC0NA/1h9G0ut2ucPHl6nJvWy?=
 =?us-ascii?Q?XUCcrn077ygJUStbaJy/1xmnfBd1Fqqiq3qT0uzfJ0S5cs/Kfg4XkGiSleGA?=
 =?us-ascii?Q?q6NdFEaGeyGLncPaTQ2L1AiqLVfY5KsuAiTYXRmUc7kwS7rO/NGz+qJG+T/0?=
 =?us-ascii?Q?Ed+bfuaYXSIRjTyMCI3cweabIXDVORAtawAnRijEk5UIx6GLxy43JEqeW3KS?=
 =?us-ascii?Q?k5Gij2dFDs0wUPzS53yOWrHmGCea3aUMPQa4IjjFjhNwjlyd/WQY96AL6TuI?=
 =?us-ascii?Q?34pUOTcFrJWyhWcR7Ql8huCWsbsYnUPQTLPxAxT5qpI1DbUyVk418GaMwZbj?=
 =?us-ascii?Q?+/eFDbue0605J4tFXeXliJ3U3CwPMI/9tFUWkHcvcXmpNYB5nPDh0+K1QUB1?=
 =?us-ascii?Q?cwnC8+NPRnpDuxCeAjY7iH/b7Jrfk9cUoOpKroNyxbnivCYKOoWh9vpbWK2u?=
 =?us-ascii?Q?Dd+/xLo44ccumyPfntz1S7JUFB540NYSsFr9ptOIMXm7pwzpB4RpVnqB7w2x?=
 =?us-ascii?Q?igSaRDn/hg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 006fc2c6-ed42-48d9-9a37-08de624f5cf8
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB9072.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2026 11:36:53.6289
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PA2ulZqwQ8XRd10i/UNVaJCV7M6EM37rKl4RuEMFAK1z5gSbeSweyEK9iaGLb032X9a2IXAMf15kOlcjap7qsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV9PR12MB9758
X-Rspamd-Queue-Id: 0B5B12000E
X-Stat-Signature: f8fgjmkq43ocu76u9pw9yddh9am9obth
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770032223-345494
X-HE-Meta: U2FsdGVkX18F9Lr8a7Aiy0J22cIKAVss4CIBByXsTa9DfP1e1P61L7cTBlNcW0H6OFe4V7QXrRq7gtSRiUS6cCELJekl3STujTyVajpjkxT4Slp1Jt1d8j2/xs4U82HBfbaMbNXW9HVLYKEL07fmRYk8pTiYSMhl3iwqYWzZg8t/I9TrLYZ5hPVx+QGrMOXLSXki/D/YVGYeGk5DAlCbJLZSCUWQuqBbCuQYCmW8gvqv2QPUC9recGpcnAwVZrPzqYJE5UoYNByaVq11UzTjgKGbPI2cCcugom8FD39QvtEV8PHY6ZGpFLzyWNDfLHwkrGeQuwY5F7IcdlDy+ETTZrBPQc8wPBnU99EYMareCvjQcdLbhx5iAOBzb03DPSkB6NoF0DhdD1vFHWnlitxB761DAbl0CozUVm2AONAU/3zE21sNWiGcTjtakn0oMO/LEJzDxB43V7mrVrc7QawAEE5OeT+RJakaPwQArjYvE0XJOrQUrLxIA0VkZS8v8dgTgbPVUwo9ECsd98EdaW7tPzDSRw/GCFFvJOV6ClXIs6Gmm8HF+APZuHKLPYldYxdgxecywe9GxQ7fGJrRZaFd0qfUuoZRn6n0bEFzDjdZKSxvTp1oVCiz7XdvCQVBOtr+8X88iv1W3US4xtTbCRjwi6aUASSBU5263H29GJaDiX60refIQX8DYU85y2twRhBFoetf6vOwRcwFMXXukBi6Qq+yy4/iHyysiUKRyzQ+OD0UyzmpSCWhrC9vOFPDmSiTAikKaTXUbYVjk+tMr63wFW1q/wfSlgH0LcTdZ8EHxQ0Ud/AuHOfEbGWLWiJPcA1wK13BZowWFCwheWDlOsRgpuKnOu6Z2wWqlBwf8UZCCNq48/l1yFjnFD/TlvFPIIeMk05U7jkJJn8al926vrYU9EYU6rEE+SOMDTicyJiX12GgD3rtY6TtuDg75vFg974sNdRGQwtzK52CKVthWvT
 OwQQrMhv
 KDkhgslnggams7Yo+WC6y2qXtjeQiQUCeZ2PwFNvU1ALPugbVqAUnwOeE3XNH34rZa7zkUecGi+shdnELXdm+DWZV6KaCvs2Dc8gGyBgED5B7VvgQ2C+58BrAS91zKJLKiCpnlu0DxHRIerlplWzwYPWAs86YTz9i2JXqGhodbFwm8MoKjSIa4y12Rr5y5n4IWBgB0uiJrz/DG1u8SaiKEKUc+WILQha60U5slwq3TpcQZ+HzeqYfwv+7I+u6BP3uUxrijyNI9oamxIjOGA+sr7JUW68S2c3usnj86l8NUauiYbdBP3T11q2LwWvJdAvO4Ph7uOeJU0tg8YbSTPs6rvJr7zXO3BfoLJ7GhujksZNBQ4XAeTUl7XLO7Z/XTXNterCytpGpIgzFRRkjOxd89n1I5A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A future change will remove device private pages from the physical
address space. This will mean that device private pages no longer have a
pfn.

A MIGRATE_PFN flag will be introduced that distinguishes between mpfns
that contain a pfn vs an offset into device private memory.

Replace usages of pfns and page_to_pfn() with mpfns and
migrate_pfn_to_page() to prepare for handling this distinction. This
will assist in continuing to use the same code paths for both
MEMORY_DEVICE_PRIVATE and MEMORY_DEVICE_COHERENT devices.

Acked-by: Balbir Singh <balbirs@nvidia.com>
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Jordan Niethe <jniethe@nvidia.com>
---
v2:
  - New to series
v3:
  - No change
v4:
  - No change
---
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.c | 15 +++++++--------
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.h |  2 +-
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
index 297fa108ccf9..b6075a2808c2 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
@@ -210,17 +210,17 @@ svm_migrate_copy_done(struct amdgpu_device *adev, struct dma_fence *mfence)
 }
 
 unsigned long
-svm_migrate_addr_to_pfn(struct amdgpu_device *adev, unsigned long addr)
+svm_migrate_addr_to_mpfn(struct amdgpu_device *adev, unsigned long addr)
 {
-	return (addr + adev->kfd.pgmap.range.start) >> PAGE_SHIFT;
+	return migrate_pfn((addr + adev->kfd.pgmap.range.start) >> PAGE_SHIFT);
 }
 
 static void
-svm_migrate_get_vram_page(struct svm_range *prange, unsigned long pfn)
+svm_migrate_get_vram_page(struct svm_range *prange, unsigned long mpfn)
 {
 	struct page *page;
 
-	page = pfn_to_page(pfn);
+	page = migrate_pfn_to_page(mpfn);
 	svm_range_bo_ref(prange->svm_bo);
 	page->zone_device_data = prange->svm_bo;
 	zone_device_page_init(page, page_pgmap(page), 0);
@@ -231,7 +231,7 @@ svm_migrate_put_vram_page(struct amdgpu_device *adev, unsigned long addr)
 {
 	struct page *page;
 
-	page = pfn_to_page(svm_migrate_addr_to_pfn(adev, addr));
+	page = migrate_pfn_to_page(svm_migrate_addr_to_mpfn(adev, addr));
 	unlock_page(page);
 	put_page(page);
 }
@@ -241,7 +241,7 @@ svm_migrate_addr(struct amdgpu_device *adev, struct page *page)
 {
 	unsigned long addr;
 
-	addr = page_to_pfn(page) << PAGE_SHIFT;
+	addr = (migrate_pfn_from_page(page) >> MIGRATE_PFN_SHIFT) << PAGE_SHIFT;
 	return (addr - adev->kfd.pgmap.range.start);
 }
 
@@ -307,9 +307,8 @@ svm_migrate_copy_to_vram(struct kfd_node *node, struct svm_range *prange,
 
 		if (migrate->src[i] & MIGRATE_PFN_MIGRATE) {
 			dst[i] = cursor.start + (j << PAGE_SHIFT);
-			migrate->dst[i] = svm_migrate_addr_to_pfn(adev, dst[i]);
+			migrate->dst[i] = svm_migrate_addr_to_mpfn(adev, dst[i]);
 			svm_migrate_get_vram_page(prange, migrate->dst[i]);
-			migrate->dst[i] = migrate_pfn(migrate->dst[i]);
 			mpages++;
 		}
 		spage = migrate_pfn_to_page(migrate->src[i]);
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.h b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.h
index 2b7fd442d29c..a80b72abe1e0 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.h
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.h
@@ -48,7 +48,7 @@ int svm_migrate_vram_to_ram(struct svm_range *prange, struct mm_struct *mm,
 			    uint32_t trigger, struct page *fault_page);
 
 unsigned long
-svm_migrate_addr_to_pfn(struct amdgpu_device *adev, unsigned long addr);
+svm_migrate_addr_to_mpfn(struct amdgpu_device *adev, unsigned long addr);
 
 #endif /* IS_ENABLED(CONFIG_HSA_AMD_SVM) */
 
-- 
2.34.1


