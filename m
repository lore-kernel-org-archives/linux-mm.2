Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41AEBC5DF66
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 14:37:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 519366B00E0; Mon, 17 Aug 2026 10:37:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F0546B00E1; Mon, 17 Aug 2026 10:37:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DEE86B00E2; Mon, 17 Aug 2026 10:37:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EED1F6B00E0
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 10:37:41 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 810E1A0741
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 14:37:41 +0000 (UTC)
X-FDA: 85111015122.20.C42264A
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013050.outbound.protection.outlook.com [40.107.201.50])
	by imf30.hostedemail.com (Postfix) with ESMTP id 87C4C80011
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 14:37:38 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=aZFI3kfl;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.50 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786977458;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hr9KVv+OxwTYFtiVUzC6gwTabvWBj/QNp1qmEFGuKhI=;
	b=pbtiWdj7sQaytMm0gT8c4Aac1U7yDh1KhXlOEKw9J6hFSA1dAqAlyc0M9Zx63J7JMnrP0p
	etpgKUe0smMVl5FGHUULM+o8FDiPmx0tErN8jDcVqtjR0AcU2fX22AfAv0pOK9J2XSgqt5
	roLQb31a76C+VTZpNLtO49y6o9MIrgk=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=aZFI3kfl;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.50 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786977458;
	b=M9/3V04aRYU7g2Tsh916/7qaDV966BNxYiIowP0W3p5ePGxXXhSfk8Ej1fiZaJLbaLfPYc
	s0VhuieO6+cENeDRRncXdZziSVSm9TB7WBZJRZqfRyNR+OtCRNjxYEJG48b0oqQeO/KUMW
	ml9Zj5ZyAZqEt4mcuaCYQWYUjA2Yncs=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VeLj0ZDZAXjLRNGXHi83dIw/Ik/gX5yLr4CvWEr7Ng8hMVOPQUwadrrPLC+1wEUhtBSfmbXbMDKB8iq6geIkhXGqXNTEDUhCVQQW70LAVTIZtJtjPOnCxHwVpdiVCrVoMvO6pwKKzXvra+lutdljHGlgcYIHxSvG0GWQMlGcQ+LqY3sx6TRwzsW8FRucZfCs2gTF7+WA7Dsj1sR2UV6l9H+7ZFE2aGGNf0hmRSapM9co2PznuoLC4clQd1sugNZXqov2gegoo33ZgcO1kfm3ia/attqgXRuuRd9L+gxFsaxwF+H3iAvSsGFE5W/rYmra650rf9w0tTXUkC4jRCgIWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hr9KVv+OxwTYFtiVUzC6gwTabvWBj/QNp1qmEFGuKhI=;
 b=JWphi66rK2TNosDdEns7I09K/+jzHHcamVqedRDPx4Nb9GXmQGg7MCC0pbBm0A0niQFI8/dnkOvXSWhRUtx35zhu8Fgl/5SIF0uUe5w7j/2Mo0orHw5wWUT5z1UtnoOCDM1f3HN7P3phaBsYGO/Hx+d/O3LotWcRR5PCrwddMeUFtQ47wCThZTbV1XHJfsAGavVXxLja2QNfXTYfJGqQmlsDJMlGvX2zXGNBnIo81Idd8eK7ACEn1haUAVscJYPSovLUCudeYiEQ+C6SsgVULxOmWdx7rJJ0yhru2kn1KLUAN3eEBucoWZHxG1h3mNy9WwlLXfEe++q+++qzaGy95g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hr9KVv+OxwTYFtiVUzC6gwTabvWBj/QNp1qmEFGuKhI=;
 b=aZFI3kflEwq7ON4FXM9IWTYRDhSlLdvTZtsy9luY6Ud5/MXiIX/T8Gnv/L6VKYiG43W6LsF5CF+vIYlohtc/kRJMqnrPRu7CGE8QqujrsGAuv180OEt/p8jdO2MZLdBXIdduqkTDyOjAuSJpY0hnUrijwt9/RK60d3ho+T5364pWaPY2AsEBIsvRwwknRVUFlaWdf0x7+vYOB0mRlBjS+ovSmUdBA8CvdoVGYCgbrvq7NivXFkl4AiFSkmTsdvry4Q2T8NqNBDIMze233XDJn3Sf5/U7CKRnV/6f7UIsAMa5HEOHJMkAx4MhZ/H31FgrvYp/cyaTgsTYJNGqRzvr9g==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by IA0PR12MB7775.namprd12.prod.outlook.com (2603:10b6:208:431::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.17; Mon, 17 Aug
 2026 14:37:31 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0315.016; Mon, 17 Aug 2026
 14:37:31 +0000
From: Zi Yan <ziy@nvidia.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 syzbot <syzbot+805630f1453e490427fa@syzkaller.appspotmail.com>,
 apopple@nvidia.com, byungchul@sk.com, david@kernel.org, gourry@gourry.net,
 joshua.hahnjy@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 matthew.brost@intel.com, rakie.kim@sk.com, syzkaller-bugs@googlegroups.com,
 ying.huang@linux.alibaba.com,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [syzbot] [mm?] WARNING in ep_write_iter
Date: Mon, 17 Aug 2026 10:37:29 -0400
X-Mailer: MailMate (3.0r7024)
Message-ID: <EECC6FB3-7559-4D22-B9DA-33E30E5EC181@nvidia.com>
In-Reply-To: <EDCC14FA-F7D8-4F72-B780-37D09E26D16C@nvidia.com>
References: <6a820ebc.9ebadd4d.20b15e.001b.GAE@google.com>
 <20260816135201.98590b17b526dda8c4ec9105@linux-foundation.org>
 <DKQP5QC9XTDJ.3MI016NP0NPFY@nvidia.com>
 <02c2e5c7-0d78-4763-90ff-75fa87105fcb@rowland.harvard.edu>
 <DKQS9ADYVLN1.246LJPQ9QQYVP@nvidia.com>
 <9787b33b-b30e-4c5e-a0ee-7f14515c7166@rowland.harvard.edu>
 <DKQU9SQUIKDR.2KEZZPONJ1IJ7@nvidia.com>
 <20260816194213.0e813ed338144ebc81ed4050@linux-foundation.org>
 <472add4b-f16a-4b87-bbc3-98c8aa385cf5@rowland.harvard.edu>
 <EDCC14FA-F7D8-4F72-B780-37D09E26D16C@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-MS-Reactions: disallow
X-ClientProxiedBy: LV3P220CA0003.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:408:234::22) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|IA0PR12MB7775:EE_
X-MS-Office365-Filtering-Correlation-Id: be8b0e4c-a499-40f1-596d-08defc6d11c3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|23010399003|376014|366016|6133799003|10067099003|4143699003|11063799006|5023799004|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	E4/obcH0YgN7nPeORpjs5QBGdAMtCDS+KC+PxNLDlshSRdL7ocmhiZzgeoKwrZmZ0O1zocTuRSxRokTWzI6LJnJk3Adiq491HbMtcASDc+FbtJ8J+fohg+jOACGQ2vsCcnJ7cHw6e3rXndlKHvOiy5PcGwoCPtyM9orj0j6sjab4Zd5jsH2vL26TpFDNzLM6hjnCa2/ClFUp7eZsiUVQG5fLYE3jnf7oKwyM4l2t3olyrEugQI8DwZhBFTqVsuV1L0qodea92+89AQaVWgv7FEAekiZpel/RXkR5XZHKkZ36T5Zz0EW3OC5WWpXCDsSEiKH9ncRaUksBKQzC+NjqCbbIovJ5+d/00Op8QqlD6p7Xm0eDmcP+EHJkRK8PjX27sFpBpaxEC76bzgEOQ39PczwNgIIuq1MMH3+obVVOPmLgVWrARXsCEllDQ3kswMBGj8JFi9pCEW2NMYuLyFBUWcBtqB5k/9al/fY81JiMOOTDFbYuWOoclL6eAmY9N+FT3W7IQwuMvEnKiwgqmLfPif0MXxSZVh5rnM8x6ClH7fDFv9/hZHVcuUhha1XW+rGuII61loa/vdpuaFBYO4M+z0PPms5mOuRLV0l1Es2rPS78CobaenNEIszxhUDSKezfG8S076zRXjchbcMIYd5DzbRFhi3Zt8om0YOK41Wql5c=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(23010399003)(376014)(366016)(6133799003)(10067099003)(4143699003)(11063799006)(5023799004)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RWMvRjkvd2RZQ0VNQTdDK3BHc2J6SS9MV1kwK3JhUmZqazU0bnpvOTVidm9l?=
 =?utf-8?B?NUU4WXRjbW13UmFDT1lNdDRWU21TUGFmM0RodnFON1ZhZks5bFpKSmFTamp4?=
 =?utf-8?B?OXNlU2NxSFpwOWhjSStzVElRNEtkd1pPQS95bUw0Z2JiNDlpZnRYTFM0ZWRK?=
 =?utf-8?B?REZYWXgvVFZIK1JtVHdaS0ExSVR0K3pML1Q3SENRZW1oYjk4OVJUVlFhUS84?=
 =?utf-8?B?bUpMeVJ6dUErSTdNendDRlU2aVRmeVd5cG9lQk9pMzUrL2NRQVZqeVYvV0tN?=
 =?utf-8?B?UzEwRlNHZ3J0dURCbnRXeGFBMWtMWnA5cXpuTUYrblQvbTZyVUR2OXFDeVJk?=
 =?utf-8?B?emxadldoMG5WZkhSVUpNTS9sTDJxMS94NjFESFdsaldnOUJaeFNySXZORzRX?=
 =?utf-8?B?SVVDOHhuYk1yZnpCbUQrOEFoWlB0aDdnR201eVVDM1B5VHgyQkIvQVJTMTRC?=
 =?utf-8?B?c2dmS29Bdys2ZTZjc2gwUXJqVmNZbVBoZjBDMFM5VnNOdWROSE5HTVNGSUtI?=
 =?utf-8?B?dGtDOHlwSTAwSU9uNUJ1dFpscU50emY0cUJldEczMlpMUVNiZzByOUgwWG5J?=
 =?utf-8?B?Qmt6QkRZdkV5RkZlSFZPbk1MVTdHZjQ2YmpyQ3lUMmJxRTlqak1ZT2NJb0Zn?=
 =?utf-8?B?YnBQOVB5SGVkUVUxRkJvMHN2UFZDNGJWRC82ZmQ1QWs5Yy95QzV4U2MrKzVw?=
 =?utf-8?B?Q2pxZFB5U09UOGk0RDJYZFJGQzlLRkxtSG5JQ3hYNVcxdi9vNmIxWFV6THd5?=
 =?utf-8?B?cWVBRUluYXMwL1VlcWNiNzZkbm0vUkdIYzBoc1k5Zlg2enFid0dNSVN1Ykx2?=
 =?utf-8?B?dURybFpjTFQwMDRMTkprTE9SNU1lUXphNmpIUmczZmpBZlozS09tMzFxRk5i?=
 =?utf-8?B?S2YwMkpvdUd6eTBJZ2dpbmRsb3haQjFoTHIvZzB5RTlYQTZIU1EyZ01vdytt?=
 =?utf-8?B?TU9DWHJydkJMM1ArMldHR29MangwVUJPWGVCdU5oVXVjZmVabnZROTE0KzBk?=
 =?utf-8?B?c1VHOXJSQ3d2bDBDK2ZyU3FPTUlSSzJmSmVGaUNOb0lSTUg5YkVkVzJVUkQz?=
 =?utf-8?B?c0h6ZjJpWHpDakZQc2pZUjRzdXdmU1hFbEs1bHpZdFdCZmNmcEV4MmlnVlF3?=
 =?utf-8?B?UmQ2MDQ4MlFKenJVWC9lcEtIa2FoYVJYMnFicUJLVjlZUUNpd2Z6NG9BbktZ?=
 =?utf-8?B?K0lGdkFEbUM3RkJ3c2Q2c1BSOWZoeUFUaHYyb0NnaHFsY1RQeWtNUi9LUnBj?=
 =?utf-8?B?VWtrS09DbEZqai9ha1RlRnNCR3ZaOUdPWTBmSVNHT2hsazNDOXY1UzVXQ2Zt?=
 =?utf-8?B?bTBabWJjWnd5WmpmTTUxMXVDWjJOR1JsSWRLQ2FaRTFON3ZWcktDZmlsa241?=
 =?utf-8?B?RzJEMHpkNVByS21URSthQkRXNG1lRytUVFRDTEdpZDh5bkNTN0NPUjJmRnAw?=
 =?utf-8?B?d2dENlVoNzIxcnRRWmpndFZDbTlrSVppcWwrR3c3ZFlVdU1KRkMzcDB1MmI3?=
 =?utf-8?B?czdpYmp0MHNvWWhDNGVnSU90ZTVweVNOaWRMck5FcU44eVFMTGlrNmZhK1Z3?=
 =?utf-8?B?RFNJVzdadWFvRktLTHpZdVBvbjdObHF4MDREMFJzcUJyYXBsTXhtVWVkT25F?=
 =?utf-8?B?NWxUbTkrdllSZm1JaUs5SWRqN1F3djEzOXpaVkpvU0pvWW1jSnJZTlFCMEpN?=
 =?utf-8?B?VHZ6T2pwbFdCN1lNdVRtNktDVEU4QW1kNFdxQk1pTWx4TTJOQndDL1k1cUZ1?=
 =?utf-8?B?cFpPVFBVZ0hMem5zU1BEYkxjNVBQdC9wRXNOL3BxZnZXSWgvNHRJYTYyd1E4?=
 =?utf-8?B?c2Uzc1hXeEdoOTFyT2hIaUZGVHd3cVVoMDZ6MGU1dUMwWHNUWU5IU1V4VFgv?=
 =?utf-8?B?VWp1VjdvYUc4NmdrcU9SMXJvcmdwYit6T3YrdDNGYXkzTEgrL0pDWmh6Z1Ev?=
 =?utf-8?B?ZlZzOEpjV05FSG1TN2o4alJ5Sk8remJSR0V5SWZYUzd4Yi9kVmRtRy9mdmMz?=
 =?utf-8?B?Wi9xRmpVUEZ1WU8zZmtGLzBHd00yY0oxMTl5QjR1QTlCTHNMUnVxY3J0cVhK?=
 =?utf-8?B?SWFaaThjcUNvcTNYNkg5SE11bTBnS3ViaTdtdnJDMkd1QmtJOHdoZEZDNThF?=
 =?utf-8?B?d3pqVk84d2RPdklaQWp6UWVxTFBYZTJaZmw0YytqZ2xFR2YyQnNyY0VjWWRu?=
 =?utf-8?B?M3RWWmZNWHJMSFFMVnFmZUlzZDJKa3ltSU02dFdVUTJaWEg1MlZzRkcxU014?=
 =?utf-8?B?WWUxYkZPYU1jSWdKeFRpOWdEWDU2UWcyWEpjUDBsT3lXUVZLN3d3NDVFY0F0?=
 =?utf-8?Q?lxxzf9yvQPwe7SNdra?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be8b0e4c-a499-40f1-596d-08defc6d11c3
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2026 14:37:31.3940
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o7eDOPtuh12VE1jJ8cA/uVSKWdDaLAEUpfHN/XLwDdKhvINHkhlGksji+oTzx+eN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7775
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 87C4C80011
X-Stat-Signature: b8m4eses3yz6f3pu9c4a5djgzr63rmuo
X-Rspam-User: 
X-HE-Tag: 1786977458-152416
X-HE-Meta: U2FsdGVkX1/eBDkMOn6fKiVNQPbt8A84v+9DtC7quXUsfhe4MV1eLyjEO6dPSX0VkdorV3MKs02tKzPWE0wDcjJ/jtWeF7C/Ig0ylHxjSDLppf03WJkX8D8mLwWqPzCkLqivezFAiqZeUsqFCE73uo4vHgIx0YQgA2DYMl/+6a0oNP42XY7cyYP3iYDXbXXU3mMkqzTCazzz7q//uJfS20gHnaJkU4Z1h7M9+pk6hc+db0nMkD9E1mCrg/2E/Bgas3FTOx60tZDFfyQ/D5QJyX9Ey+S3nPwayK+GwB1xo05a1LNxcLLHHinDraxNKGXJKHAcBF897tscmADCZC1Zengyn+BO/1T61Sm3NRpYdpiQUp1SRzgXtIKPyW7RKCFRx/6vj48K4qVfovU2LmZNPX1dddqDLLbmQxHDbaLztsAf6YiTOFTKqS7VVs7a8R0VZwBMW4Ax6XWdZraCGJjf4Y2X9RzaAX+CpLiUlYY3qZVxgvYOw27OgJ8Z2gdq1Sz2gL/sRsJKDePi2uZCezSnBKoIIqtLjT83L0RNf2qhDPayCAsnkniEJmm4QBzwjXADwQhqT3UhuhlHL5euFR22u6G9728gDVtbDQv8BfzpD8cnFDUqzMFeOYlBiXhMBVaJ27xJdAQtIf+h/TN6/4DG/yaixrG9isfSpHU8mN6iQ6Pm5Zx8SGPX+eIHjBzDvIuYDYtpyDQtqaIHaglPI22bk8iB01geaWRzmUucH/gXtGY+HVD7RGojaf779Iidtb0HzaFlyn3EGCqEOD2eFrExI0FRsgQcgTmF+0M4Rm46WJ+8MbHwjPkzcxxa5IYRSNqmE3Q+e3FkriW3A/R5P8qwrMkU+hYZHu1NZowq3EyTobVu4r7kEr1+p4nEHwiNXpKP2ZqJ9Nz8DIyo+2w7O/NBKcfiDfroEq1hdrg9aVAMlKe87N5K8fCqmREaFyjG2kE7jxGAszZQvnmUPJ9ipxU
 uspaheCs
 DQkRTSPmiZAyNTGepkMVMvn9rv/FVXqZtiVWNS5t7kGbro1C6AC0yUGBggycSDGz8PloJBIVSvvr5g2NDtkWX9Vcf54aIAdybB8pVOQOM5HXOKMiboSaQjv1WF8G0Ejr85kAeSwGD261JeeCdJllnQoYjZkC0ncGD8vZsP/MBtqnZ07MahFMLmfXoK9kCeJpI4+D07oKbvtEXbo1Zy1pU9ScjyD16fZ3K+C16RbU8UkqzCW8ZCt23nhl6DLNpRze90sXvXkuFqjWc+OvN6Xme2thz9GS/nD1MV+5+t4PLT8zY6ijM6kcrY1w96vpPdT1aOC779IsmwBNogqpZq7c2HDoZzubkxZi0McYbLdIopJ5riBPbGx84cWuBtdk5OU8j0Gg1UD61ZbGkNpODGjJ+MovCbyGfajs6b0AkRlGim84Rw9lhY4pzP8J0JhZvb5ABzEfza8jVIgXVLsvMdu8dSgzsULWS0gtXyzRlcfJxW3lAPQrN9IXaaxNfYidMP0YTlPCqzkQkkYZbhEBZKjvegiTEu/E667viUYMuVTv/BMHNgH0/QoNBhkxiay8+AhI4ow6aC4sSaO7OSrr3VdBu4oJGSvEdz9aQhLp2CA1qRbt28v2O/+LVYmMddKiTHqHv0i3FKEJrVUkGI5Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17 Aug 2026, at 10:34, Zi Yan wrote:

> On 17 Aug 2026, at 9:55, Alan Stern wrote:
>
>> On Sun, Aug 16, 2026 at 07:42:13PM -0700, Andrew Morton wrote:
>>> On Sun, 16 Aug 2026 21:47:58 -0400 "Zi Yan" <ziy@nvidia.com> wrote:
>>>
>>>>>
>>>>>>> I prefer Andrew's first suggestion.  If the user asks the kernel to copy
>>>>>>> too much data, just fail -- with no warning.
>>>>>>
>>>>>> __GFP_WARN gets rid of all other warnings, even if user asks for a
>>>>>> reasonable size. Why use such a big hammer?
>>>>>
>>>>> Because on many systems, WARN causes the kernel to crash.  You don't
>>>>> want the entire system to crash just because the user asked for more
>>>>> memory than was available.
>>>>
>>>> User asking for more memory that what is available is pretty common and
>>>> should not trigger a WARN or crash, unless you have panic_on_oom set.
>>>
>>> I assume Alan is referring to panic_on_warn.
>>
>> Yes.
>
> Right. That is why I said “unless you have panic_on_oom set”. So panic_on_warn
> will not crash the kernel if user asks for more memory than what is available.
>
>>
>>> Heaven knows how common panic_on_warn usage is.  Gemini tells me "There
>>> is no exact global headcount or precise user metric for how many people
>>> use panic_on_warn.  However, the setting is widely enabled across a few
>>> billion Android devices and many cloud/server provider host kernels
>>> where automated failover makes a full reboot preferable to running with
>>> an unknown warning state".
>>>
>>> So I do think that WARNs are more serious than we (mm developers) tend
>>> to assume.
>>
>> I do know that Greg KH has pretty strong feelings about this issue.
>
> But the warning here is when kernel user wants buddy allocator to give
> what it cannot allocate, a page order > MAX_PAGE_ORDER. The warning
> tells that kernel user please ask for a reasonably sized memory.
>
>>
>>> So we just shouldn't permit userspace to trivially trigger a
>>> page-allocation WARN.  Especially if the caller is perfectly capable of
>>> handling an ENOMEM allocation failure, as appears to be the case with
>>> usb-gadget.
>>>
>>> (Does usb-gadget actually get used by Android?  Surely not by cloud
>>> providers!)
>>>
>>> (Can this WARN be triggered by unprivileged userspace?  I didn't look,
>>> this matters a lot).
>>
>> I don't think it can.  Regardless, even privileged userspace shouldn't
>> be able to crash the whole system by doing something that ought to
>> return a harmless error.
>
> The issue here is that the inode.c code passes the user input len without
> checking to page allocator code. Capping that is a minimal requirement
> to prevent untrusted userspace input getting into trusted kernel space code
> easily.
>
>>
>>>> You can mmap a virtual address range bigger than your physical memory
>>>> size plus your swap space and try to fault all pages in. That would
>>>> cause OOM and the system should not crash.
>>>
>>> Right.  As long as it doesn't trigger a WARN!
>>>
>>>
>>>
>>>
>>> Perhaps we should revisit this.
>>>
>>> Why are we emitting a WARN if an allocation fails, given that this will
>>> often panic the kernel?  Should we on the core MM side dial that back
>>> to a pr_warn() and a helpful backtrace?
>>
>> I think that would be a very good idea.  Only the caller knows whether
>> an allocation failure will leave the system in an unstable state; the
>> library routine shouldn't try to make this decision on its own.
>
> In this case, the WARN is emitted not because of an allocation failure,
> but an invalid input to buddy allocator (order > MAX_PAGE_ORDER). The
> WARN is for kernel developers, telling them their code is asking too much
> free memory and core MM cannot handle it. Suppressing that means
> code outside MM can abuse page allocator. Code like doing
> alloc_pages(MAX_PAGE_ORDER + 1, __GFP_NOFAIL | __GFP_NOWARN) should not
> exist, instead of just getting pr_warn() and failures.

+other page allocator people

In case I am wrong.

Best Regards,
Yan, Zi

