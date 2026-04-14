Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62D61F9D0EB
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 17:53:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF8216B0089; Tue, 14 Apr 2026 13:53:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCF3A6B0092; Tue, 14 Apr 2026 13:53:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABE656B0093; Tue, 14 Apr 2026 13:53:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9C1F36B0089
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 13:53:26 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 428D01B7023
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 17:53:26 +0000 (UTC)
X-FDA: 84657908412.02.CD13C81
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011042.outbound.protection.outlook.com [40.107.208.42])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4E9A940013
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 17:53:23 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=HS5ey90B;
	spf=pass (imf11.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.42 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776189203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wws4hm5z8JbtRgyTXyebV7dzTK9hEzJ9b98/ENvqhCg=;
	b=vqLnX/jwtRN40XJv6EJ2xWrRMyOUtFR8ojWW8YFhA08+Im/tUG0owGE7wrzt70UQhFZKsj
	BnCFQIW6ZN736/8tyQItwYLH/t868oGCDFe8StF4r7Hjg9+kXphn5SLJ4hdlQHDB8XEFOv
	9E2i4eF34yJXbIdLzoKzO3oG4ZnTJD8=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=HS5ey90B;
	spf=pass (imf11.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.42 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776189203; a=rsa-sha256;
	cv=pass;
	b=ib289Oa+ZLh5HLXuQr13aZ5npboXP7MqaZXHBdcIf/uHrW5GFICbPLVzhwbSZaOBkaTWVX
	rCqrJ8+Pk0RIH0q2Yd4zB8NCMFe7vkUybjHwufYTMwwjIXFmVRUsURQmWrbyt2U6TyAva5
	N/9OBfoJNzq1lZSlxGyRgL23kkMxfbU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k6W3OeOYX0i89PEXHrkC5OGSeuIq7JdTiIS1SPX04odR/RgbUOyubCdSCslTQf3/0/8vjCY5V3U2XPX8KeVq5q+aceki3bbxJHfK/WyMk+/gIPvHmGoso6CLUi6q7NXifJM0fGVK5RCwxYQcHpjYv2D+V3zXInAuadTY9kKUjGiAoDP10S4B+EhU+dyeZcI2ToPGp7FSDrSxq47rhingVO5hIAuJtjjBwJKnc6Lmz6bxTaJlTU+4IShU93ORCpPZEz9yKa62FU+SVWmqjs2xaRZT7HdzmCK0H33YEsA8bz5kH2zE7HWdiwsqWi8YGD1A+5tF9Aiwp/XTq52HnCCiJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wws4hm5z8JbtRgyTXyebV7dzTK9hEzJ9b98/ENvqhCg=;
 b=aZQ4LdAodQmJzWlCt9y1MQuAqxe37v2ehGWCjlTgdmnrUQM6vfSUpDhbMXXPVL61n0a60bZyDqab4kLpc0fnBF8FN0to876IlfeGg5fqbsqOzZTl8tN+DtKLaNuF4uDafJ2Ax5Ze7W4Y9gEmZl1LlkuHt0xVMBfzuZY5IZsEFXglzmDbnck+63dm3hgO0MSL1sE1vrtrtbL9VuxsdsXEyspe+E7EwfKsufUs8XatBqetnCjVKam5A8cRKxxrH12Y6Sr4VdFGwtXAblGmSSWTa3reqLHasQJ4VzmPnI/SyM9hiiyjEMYDlRtztwW4mQGSZSesSqoTs7qWe55Q/QKrrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wws4hm5z8JbtRgyTXyebV7dzTK9hEzJ9b98/ENvqhCg=;
 b=HS5ey90BNFIr7d/A6beJ/FJsj2RTENrJhXVWGI66tUyenJcCKrRHfCdK9eWpi7eaOiIiu7KAyZuHWYtlby2VWLDSJCrV5vrI7REukWgFCA8YLcXXsG1UebNsa6YeUg0xJg9iU9aHHWKzRlCVEjOSFRLWbFsmuIGxuArSYiLngHjaXOG9g0xcbU44hzwyj+o+N0Atsn9uynh4OoqGZyIYie/2j04NtPndvnQ63V6BKaXESU6aYxv2lKpWEAoYnqNNiCkB5N8I2Aki3y0UzZ0n4dp8ERqTr/UkEDFt65vXIYI3+v6OIKa5dRkGuNpQfHwvR/UQxa/Am9jOCfGjsyqguQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SN7PR12MB7130.namprd12.prod.outlook.com (2603:10b6:806:2a2::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.49; Tue, 14 Apr
 2026 17:53:18 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9769.046; Tue, 14 Apr 2026
 17:53:18 +0000
From: Zi Yan <ziy@nvidia.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
 Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 7.2 v2 12/12] selftests/mm: remove READ_ONLY_THP_FOR_FS
 from comments in guard-regions
Date: Tue, 14 Apr 2026 13:53:15 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <6E635E1F-29BA-49E0-8B6D-0DB7FED4DBF9@nvidia.com>
In-Reply-To: <ad57-5Nqd5cci8HQ@casper.infradead.org>
References: <20260413192030.3275825-1-ziy@nvidia.com>
 <20260413192030.3275825-13-ziy@nvidia.com>
 <ad1WTCR5Kld-tiL8@casper.infradead.org>
 <E3268570-18E4-40AF-92E5-931A8ED1C9B5@nvidia.com>
 <ad1uK11f_J8sFN0e@casper.infradead.org>
 <c696705c-4c0a-4e3c-996c-358d2f0b7074@kernel.org>
 <1EBEBA57-E519-4004-899A-CBF21A77ED53@nvidia.com>
 <ad57-5Nqd5cci8HQ@casper.infradead.org>
Content-Type: text/plain
X-ClientProxiedBy: IA1P220CA0022.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:464::11) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SN7PR12MB7130:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f9ac1ec-478b-4688-0a4a-08de9a4eb5ea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	8YbplMmegajzWH1GodMaKAsdVyfAkf5sok4NCG/0dFvKpFf7Ob0oy6Tc4IaoETjyfyKCz9NZkMHSt4RmTFPCNAiha/Jxt/kOATn+mJls/lfBOtygvzXbslrBndCqk0ZKKAxlQi2knMCZpDB9i10XFo0z74H/RKJw96FC6zuPJDKgjw3bJlMDLchwL8JjnX0Jf8IvFy5DHo/EyJClQha9b24EGtuNqchbSNKTmEKkDyXu1UBZyqgMoAzWu2DTOy2oI2I2CqoEWNFrxk8Wx+CCDTh17bCP6sBFwIvKb8aAOJ5KxDit8FCQ/uZrnqHgBKwYkMCmJbTglcVhIDje1Xog5KWYIpTvYJA7zamjYYTyGVNWIXAXeTBD3SlYULPjLayh5IS+9kNEv4f2gDOLiNwEBL2oqp2w6tpp7UsDMiHRMBl0CmY+Qhh32SuGgLsfqFX247jBfynL3SohNKFGF47ukjfA/dZcKOjVnRJfn83hUd8qGTLY8C1dh1iTNAxLwj4Rk5GAo3+owqK7to6i9FxePvR5vKXgN9IK6AR08Cptd8FZiu3Iqf6ywwxVofSNL+0dw9T3vZVmre+98nwO7Ue6L/9g1Q7aEeNwYyTNbdlhZlEbj+l596VOp17vf/1qp1CWEFS3hsmc/sA8DayxZV6Vt4QeXSJQm7ozlZGJybXOjz4oioqw+Zdc06O+0RQyFtTdGgAA7A/cwG7Ewfn7++O9eFwUn9CSQNW3v4xKHI5Sz6s=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Q0b4yiuOW5l2vA5nQcShiqdRht6woMh6isVlc2iychwq1uyJJXvwMf4a7HDM?=
 =?us-ascii?Q?7ClaLeY7Jxk9OYbIl5X3i73bstR/3/yewqIEnjznfzilTwIotCIqSbnytQLn?=
 =?us-ascii?Q?JFmiI73Szy8/gTHLEqRKpENdicgCPvcQmBXaTHcmnJY+OiOHUVQplB/IJxad?=
 =?us-ascii?Q?+CR1trvij5qyhSR3vtGDFw+ZJkgCtWqGoDbSjbr16RfC5ZGPTNWZEdZHeWXz?=
 =?us-ascii?Q?Fr9AUkkT9GAycnzV/evWWpQiKdUrk69eAxKVkJChEFv/ztPInL0Fyj8UxpW3?=
 =?us-ascii?Q?/6ywGQijrzgAUiQPjECy3JOn7Aa/1/VNKXKj8Kz/S6JfED8XPhIqNQBaqDZg?=
 =?us-ascii?Q?dnTdEg944nKTNSduK7pIauUAScBeVsvp7W0qzyQVQ7MP5Cyrkj2rO7qwJudZ?=
 =?us-ascii?Q?R0mSWbyw5cZp/eedElQvm/EaI40xa2PNvN2ABxSi9xWAFTMxP1wwlYzDz5bZ?=
 =?us-ascii?Q?mPIHPbhBUxSouEK1W8Mi/Dd8sPNDq7Q9crvUZQF1XF1ayCEsHc+N9vUxtTP2?=
 =?us-ascii?Q?MOVjTTg0oeCOauVKn0boR1UF68+TYCOxrPq2V3kcKpprX5/MdNaH1NNIy5m4?=
 =?us-ascii?Q?WL4ZjsODTc8AQhVWnSuRo2am/d0dj/0ZspbEsQTOSi3k7Y6K+wyMFkFkOZhI?=
 =?us-ascii?Q?l5Wm0axNVbBB3PX+cCWlelHaMXn8LQ9E9deEOwkfwT9uW8zHFktRRUUrms3d?=
 =?us-ascii?Q?cD80H3J8TTRiEb1pO1pGcOyZIyr9XY+UmAqeFh4L2zEVsKempEyqjG7JW7fd?=
 =?us-ascii?Q?JZTcTPM3XjXGd0saRSwdSmsWgMcvaqhwhe5eP2dvDl7J/XV8/LWHl6n5fBtl?=
 =?us-ascii?Q?LhiBp/WvMfXXW2VzLNp9gSGiEOfSobq/naycmiD9ZbTCaKXwJC8BVxa+LuKV?=
 =?us-ascii?Q?Xy+tHuDfXn9Dyp40pUl6PNQqKJLCNw2EzsYS7LeJWH14BWMBWIpZgqSTmOa2?=
 =?us-ascii?Q?62rBfk9/gRihU6Aw3PRDUJSoUCC793Uk+LO2kZU2+KhK3Ni6NgsiL3PyX6pk?=
 =?us-ascii?Q?rbmutmh/EV4evTpF0GD3oeStAlbsNXrzrrrUW23bDAbz/p2j18kvQtlZIcqC?=
 =?us-ascii?Q?y0Ph14/XXw0h1uJYFrHOrbfUgOlVdodhAA+FbOxSKRQEZvizsWDd7jOI6l2B?=
 =?us-ascii?Q?lIYPlGSqz4hgJa/wnPUkaHUkzOV47aKqh87D/UXFVRyQOVt4yU6MsulVn417?=
 =?us-ascii?Q?RxTDH49nnpkRnTKAtLdOZWws1YJlvI4DxSKyogw04t9/m+3+atAVBhSpMemQ?=
 =?us-ascii?Q?PZd4YVCLSZkDFcJBVqXB2eWfmK+9fbMlojsmim/n/oIx22s9llWI8DShmwNI?=
 =?us-ascii?Q?yvtcr+3yapbksyH39LclUVQuuGDfsEzINPfNmgMH54K4vXSthE8JrYtlxH7q?=
 =?us-ascii?Q?ek4EkNJx4sQOKOnNgQLEFXJtOpeq2iE/Q4cGLGYNyTBxnkAbbzdyIb/9jSNb?=
 =?us-ascii?Q?YzR8ypDprV0uN92muHgGL4ISzfyHvXkzQX3bqz7qOrCxg6UQu2tVceWB7gVz?=
 =?us-ascii?Q?xG9jm1GFP1uWCYWcMXx6s6GNhSL3PIhb/ceJk3GO0fRBIF9a2YSYXG8/UNij?=
 =?us-ascii?Q?TKqbX0o1TsUG8xx1mAA0iUDmnkSDnvOTmLYcqcYFgtZppL+jM83jxRWgMUxz?=
 =?us-ascii?Q?g5KU+TVw7+y4wxr6146klmQc0NUrMccXh+bAqRLRe5ctToFDp1IoR+MusmCC?=
 =?us-ascii?Q?jScwNFis70mOTlCf+1cnVGSHzTFfGnSVt7eQrN4tExnMyn1g6E3HOo1JSicX?=
 =?us-ascii?Q?/8ERZFqJIA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f9ac1ec-478b-4688-0a4a-08de9a4eb5ea
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2026 17:53:18.4275
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rlkUUGw8WPPHHTeCmjc5KQR66993ablEBLMp0i9oaTHgmK9CfHHxVHrvjRJoUJqm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7130
X-Rspamd-Queue-Id: 4E9A940013
X-Stat-Signature: trenc8jezeyyiqtoegeztjnh31mng68i
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1776189203-816481
X-HE-Meta: U2FsdGVkX1/eKxPctfbyrov43xa39hIZ6Zi2jRoxFN+05UmKGW9dzCL0uC1CRUnKnUpiFMRABPc0Oi5yWgG5IEmn3JwzgBojpRlalfmDNCbzrey7g7ow7jjPrY+QaFstNnMC5Q9dVJ7zKG+f0BANoXCtBYIB7W0+xLb5ry3B2g3GiLBw69B5tYGeqYmotmmaIBwGPB4fxYBtGIobyy2kYsrnVbRVvJO+td25klsVgbOfjmKZ9QQdXIlTW1FpD2ItdtnQjOx4gm/7uLUL1o/VzsZkLTUTPpGIpeznwV41wBoGzMqc2o5rz9/zPSFsLqO4FLfCyLZ226+9QNWniH6a12QzUV3W7cM5YXTqpSBX647i7bd24Au+VBY/lnPi5Oh+ebEOi3eietHKqebJ9fhJoQHW3SSHII6tKyx1NM20jzxSGc15cun8HhVcAvntOZwr2cjugu/BmOWU75SYIQtx2/YLYgELzwXCPTGaxJLiGwPUeICfLSupJW666MoBxxah5xNDJkut2VEfpcQd++LCTDUnsyu9Gwetb8i4jwnarI/TXngE68t67W6hnhcWzLdjqDxI8yVzc2tJmR4f8VydbYUSVsaOZRYpLakDT3lxPDTJU/v3dG91KVIm8oGUKVNLoVCep6iNGmCBPfT57cBUZKhItJmC5gABxqE/fnPpgL+vNKJhRDAb34ujJX9Xwyf1PWX9yqdozmoBXKzKJ+OUWpzs4ZS1usfnOYit411BW3zSyxgqE2/28InXhQHuVp1NQk37JGfSFxn9rONdDJ/mta6gO6IK6oL/4pfRBuVobux4XIgkDeMHzVC872QHGXJ1uQ/ZSMewjdjFvom2j+wHIuWXCbWtuzXcJAuVbyowDmtL28Q6Tg2fJOIb71W07iaAzSfwAjQY1IjmMWiSqPygeVjyOOK7F0xd+3jEfHM4qmnsqBBkAQS87ivAyZTUwnqJ94oUb+kXgmvwXqc3U/T
 SL/8m6hA
 u7uVSxPMPY9Jf9zLP3jbmBqnXC/hhb1cAV59orm9gFBdPorzbm/QdFUdeMSdRg7s0KtLWYwlKY2mE8S8dd/NnpgLsNfxmR/9y0Np78Gjl4ZVsG64dITXY5qDbi+ZhSW1sOdOiPy1N4I28vGxexLCtqAIASj4M2YP+75/c9RFQpOoHIgIfvDN9Swid0O19RLtx1cgUGkXCJPnVKV+A64L1ETDOIW/7GVt61XWprb3PkahVxbHEifxcL9ZTQaERcv2KdMqpJkFWOXmTPcRr9O/wrghEoIkixT/ZhgS3GlSxl/yxsKSxRE0XNzs6JvkA2AU+wqOV61Dzx23tcJtQoXgqN0ultvhqQEb/pdoOpoWZRKuzzNTffucBOUVKmw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14 Apr 2026, at 13:40, Matthew Wilcox wrote:

> On Tue, Apr 14, 2026 at 12:45:18PM -0400, Zi Yan wrote:
>> On 14 Apr 2026, at 7:09, David Hildenbrand (Arm) wrote:
>>> On 4/14/26 00:28, Matthew Wilcox wrote:
>>>> That sounds like more code that was added for RO_THP and should be
>>>> deleted?  See commit e6be37b2e7bd
>>>
>>> Sounds like something to implement on top of this patch set?
>>>
>>> But with the added dirty checks in patch #2, maybe it's trivial to do it
>>> in this patchset already.
>>
>> Can you two elaborate? The code from commit e6be37b2e7bd is moved around
>> and replaced by functions like __thp_vma_allowable_orders().
>
> What I was trying to say is that this restriction was added because
> of ROTHP.  Since we're getting rid of ROTHP, we can remove this
> restriction.  No matter where the code has now migrated to.

Got it. Thanks. Will clean this up.

Best Regards,
Yan, Zi

