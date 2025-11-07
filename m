Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBA80CCFA05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 01:55:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E7798E0008; Thu,  6 Nov 2025 20:55:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BF0B8E0002; Thu,  6 Nov 2025 20:55:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AE148E0008; Thu,  6 Nov 2025 20:55:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0AA868E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 20:55:35 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A401FB817E
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 01:55:34 +0000 (UTC)
X-FDA: 84082144188.12.078FD4A
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5282C10000B
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 01:55:31 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=e6fM3f9B;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=bLa5Cgoh;
	spf=pass (imf14.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762480531;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dz9YTdqO7UcDiKGFi9pokFvh+2p08AG3TcrntlhgPQA=;
	b=h0J2LSlbAwcS02e+kvjeYfTRiigIt5mHUIE+o3iN5k/ru9MrjNPMGCV6HNtaB0MNOV3Kpx
	N9EFUEc99j96/yyH8qjsBqDySkwEKxwuaD63EYTaCyoB9cwTyLrQeIMGB+9PoJgiq9Bf6s
	fJkB/4er35HvPzyES4BXmdJW8Wutj88=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=e6fM3f9B;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=bLa5Cgoh;
	spf=pass (imf14.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762480531; a=rsa-sha256;
	cv=pass;
	b=SgT7AtJtZZaMR5n3VlEBZpc5K9+dfXak599/JEhL9ZpG4QaGRIT9YXMq9WtZHJ5Y23ptxl
	kphuT8e0kzg4b0rtszDdMcffDon6p9WMJc18g29TkgNP2lYQfChM2xmNnh7DAu3tmKB5gi
	4y6BZeGghobvTiK0tGLMUirpOUw2JXM=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A6LNi2v017685;
	Fri, 7 Nov 2025 01:55:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=dz9YTdqO7UcDiKGFi9
	pokFvh+2p08AG3TcrntlhgPQA=; b=e6fM3f9BpVzTsN60ZKlenyzYT0kis8mzmT
	Ye2Yqi7m3OM3EQ0c4BC+EHpc1PcBsA5OD9RKt4wTRk+h0kjEpWtVwfV3t3JMNjJF
	agEBFq45RatRP2VbD7CSTvCiiZUC5u2OHEL8CKq0+RQbZSQAZgavW4gOkucHE+P+
	EksYI9A+XfCti+24eWZTCRj6ObtV7gU+LsMt+eMCxE39Jr5L7T8Oz3lnX93ofzr8
	wnDbJC+AgvRzKCKmQinCHZmV1dRGRHHBjgnIuYW+yaqegAYBhAYHBx4rUTbdZgKt
	AeCqmFg1EQSE707OfMhqf+lbm6nbUPA9jzHFx52ep9E5cjHAPNaw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a8ytw8v7b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 07 Nov 2025 01:55:20 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A6N06DF035982;
	Fri, 7 Nov 2025 01:55:19 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010005.outbound.protection.outlook.com [40.93.198.5])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a58nq0m71-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 07 Nov 2025 01:55:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ArAB8ZIHqi8oQiM8tM2KTIzWo7wceGDFkYW09I/Y6EL48rQemj+qXYB7zc2R97YCtkrVErQttZ+bb+H7py0S3NGU03D5EzvwE9FAk2LddfsRlQ6uc90iPVzoD1sGpa/wF5OhZEtGA81N9NVa8G3GqzNYeDuvTbPrXCpim7QPqhMicMParpNC5QBbwiIAo30ZXGW+aitUDIJHJKvCUgzUWdQGsOtilpF42J7bV4vsQomkF/83ImA8+Ut1gJMM2rlazBNTOQ9Fvh0p17LAWcNteOeZduW08HhI0m6fttuxVYkk+vaHqo+9k/dkL6lc3yfPVgxTV4uq4HYahNaigioYtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dz9YTdqO7UcDiKGFi9pokFvh+2p08AG3TcrntlhgPQA=;
 b=geg5msIepFQcNGeMLqh6L8YHejzUodjegFTtE1UGczrlIEF+vHKtMr869grn2HIg0GS37qck2GG8/vK4gtSHeONiupXxixI4KkfVawVWd6jmQSoNLsDs5RTBMhZSaW6PPURPUtra15YMPFgtAHDXSnzGDV+Nf30d0mxmLoxJHCF538/M4DybhkxbmXqLRUXwvGBDESa/F0CbR3OuleuX4IR6L1QAdiOi3ZVz5LDKYjHciKf44M/GEI3Z3G1GRoGOh7z06V70Fp163xiIXWUpyDqvzXauvxh0oRKkxuGyjx1Et5f3V1L2ee3DVntBbugUvUgKI5OeNsCz2VU7KYjinQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dz9YTdqO7UcDiKGFi9pokFvh+2p08AG3TcrntlhgPQA=;
 b=bLa5CgohhOnO+uhae3+eeCq6bOFBT801EbqQbolzwgcKmlmG+SUQ/9d6xQObTah1g8Q/FZD1IHl8lzcq81zcyzAXIkU3HA182x/YRNZPxsnay9bF/VIrv6oFMWQl7kx3PpWiVRuNlNhqrianOo9YhJlYnXLMI5SWIt4E1Q1HdwA=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by DM4PR10MB8219.namprd10.prod.outlook.com (2603:10b6:8:1cc::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.12; Fri, 7 Nov
 2025 01:55:17 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%5]) with mapi id 15.20.9298.007; Fri, 7 Nov 2025
 01:55:17 +0000
Date: Fri, 7 Nov 2025 10:55:06 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
        roman.gushchin@linux.dev, shakeel.butt@linux.dev,
        muchun.song@linux.dev, david@redhat.com, lorenzo.stoakes@oracle.com,
        ziy@nvidia.com, imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
        axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Muchun Song <songmuchun@bytedance.com>,
        Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v1 02/26] mm: workingset: use folio_lruvec() in
 workingset_refault()
Message-ID: <aQ1ReoRlI9J25p4c@harry>
References: <cover.1761658310.git.zhengqi.arch@bytedance.com>
 <02536beaa78aeaafcaec40d4fca42ccbbd9f8643.1761658310.git.zhengqi.arch@bytedance.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <02536beaa78aeaafcaec40d4fca42ccbbd9f8643.1761658310.git.zhengqi.arch@bytedance.com>
X-ClientProxiedBy: SE2P216CA0035.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:116::16) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|DM4PR10MB8219:EE_
X-MS-Office365-Filtering-Correlation-Id: d7a6b3ab-f0d9-4887-ab77-08de1da0b309
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|10070799003;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?fFc7rOAo69mIFgcbxEzdpju/g+8V3Y335W4s/Q8ozy8PDqZPHaF7NOzKAboW?=
 =?us-ascii?Q?tkoiVEKH9lbZyMKerxJ8xaWm19f3AhML8TUBc6tqAVSt++6pWsb2eIXczmH/?=
 =?us-ascii?Q?df3v6qKj+gPIqxXpCR17JoQtxO5zktBqk/Ph8mZ8U6XHcx61fo1nOf+cPQWj?=
 =?us-ascii?Q?hKPTinirMDExQRON7FHJxwjOGQBc6qSv6xhpEPwgeiijOWmnPpMoT+TCIe0s?=
 =?us-ascii?Q?Ai0vxMb3IQFpqSJgHwgy9Y2Lde3hgm7VHtb2fozUeMgbYshfrmSjBZWwjSN5?=
 =?us-ascii?Q?LrCzUzx9MqvygE0iT+weGGV04m10u7HwFBmIBnvKedroOFzCsByi43CVV7ia?=
 =?us-ascii?Q?dwWCJPy4NOV7xIyBu/24/b705/Yl6XDJ6J5fkf7gcbXrB8Nl4G4qv5BztUKm?=
 =?us-ascii?Q?Xnt+JS/HZJ5DKD026p+CTTFnGEzgo2GczdD7t0/l78Gk4Qf4mf67mq6GD+Zx?=
 =?us-ascii?Q?ixvV97GlS0UVjw/eeB1gNt54VpFq800KGLRdHGJyXqkJPeBmF6hUFZtD7poC?=
 =?us-ascii?Q?jpIqy20oJ8+3Kl2tqtLFf6dJdD20LZWU1O/IwKDxyMv7DVr6Oydo+7sj2PlO?=
 =?us-ascii?Q?v70DhfpUGP7lXfYZEkD8rwQNX3C75OSi0Wpb6riQjqIIziVUk9DGRygk2a7r?=
 =?us-ascii?Q?HYIQuMW3gLYixlCFTRxxtLhYpo6AYN5NYgoI6fjpNZUe/0ayNJQtOefK0zUd?=
 =?us-ascii?Q?3TIgH0R3ZFNPh0Hqq0X2VRUm54EKThMxGgze38PIR3lzPnaVt76wvoo58tlS?=
 =?us-ascii?Q?WW9+e7w7q7CJWJHfYbdL01ognMe/p8A4kBLGdvwU2zKw/wJzzZPfJag2U13C?=
 =?us-ascii?Q?C+9OuGKmQXuDH1bxr7OLO9WkoxLOymHjBhB0WlFwDWDw2+djbuYRBAZeeL9x?=
 =?us-ascii?Q?/g952j15X32b1BaluipEPMBZXbiOq/B4FQPG9mUvWxvD3231dM1JiekQtYlU?=
 =?us-ascii?Q?D+U1DL6d150PJSBpLNLyxYI/jdbSRwv3/zB6tSQ4D7pgIN+5eSRfUzMvTCdV?=
 =?us-ascii?Q?VH+2i3FQRMXu0MOuOZJdqEluEOZciVPmpILKXQpgwl5RSCD4LI7sPrO2S3n4?=
 =?us-ascii?Q?1JvDqtfxFu9sOSAeyC3M55LDNCZyHs5/0LrVr/WvGAwgHvzlTgnYbU8o4ujR?=
 =?us-ascii?Q?BwVdioHQ2dVb5M3lLwEeaQDYYlwXuwLf7aDz5UCyX05ABeclsIJrqJZpsc6t?=
 =?us-ascii?Q?b7xIy20tvo13bfjnwHeNAxjMoRv859jTa4RdhdJ3bHOEnOQtJTnPo4VQ+WdH?=
 =?us-ascii?Q?StqhHJGDqLuFfhCtxkct2HN6YTUaGulJGETtTc7Y9Dut42mS7jyqT8FaV9V4?=
 =?us-ascii?Q?66oi9WFW8Z6yR9KINnf4ecDVHZ8aW4ap83SdpBvY4NLlCwqHWjcC57AqqKFm?=
 =?us-ascii?Q?9fNTDweRNmyjGSzsi2YGL2jvFlXjBjdTbDKFPeIlPCADmZftKj63Lgrn17Pb?=
 =?us-ascii?Q?NwvbXKKxnMOhun7gDIJtegC6Tm7QxKj7?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(10070799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8Nh+iq9fKAuvkKYablnuurdETl+SnVHxakkSbk6rEE864wWSaNpwA0ccWsCB?=
 =?us-ascii?Q?9RW2wDMKdbahNBUCcBXD+oZ25qfS9y8vzkKHZrowejBETJdwFTInKg/13SoO?=
 =?us-ascii?Q?h6k2sqFnxDa56bVFQ5YURuHmgu1d9jtzCzkjFXB0v1NcHESYLzbXN1f/hQly?=
 =?us-ascii?Q?80h0J+rGqYHPmXbDyGUz7uXlEltf8TsVRmWGqWgdMWIIkFFZ+5R4uhzGix/x?=
 =?us-ascii?Q?+uuwHoqfLZhBaEGH398gdYc0sItPFINTN6uWR48/fJRyvDxDUu+KgEp6kh2w?=
 =?us-ascii?Q?Sat19jnO4kTJaR0P9sUXHP+N/uoJC25MTfmSRHTluBRxkYccHoP3bvgXmZNq?=
 =?us-ascii?Q?o1R/mrORRycwdKpPDKiP25xzk1zofhy6YQ8K1tej3f0nue+HP9v0zvWjMJff?=
 =?us-ascii?Q?sT2YA594gmle+3tSkzNXtk7Ck0ymJ3rQkrHZTny1RKLHksFespNvm48d8F5j?=
 =?us-ascii?Q?ZSp0519kt5C2phAsGAW+6pJySwpqO63GNi3c0zh5PPhN8g5lss/suPwiAqyl?=
 =?us-ascii?Q?UQvOlEclz2nxZiwfxamahjbZG2yQWgLw6Rg6Y1sN3j/HJzksrLublTbB+U/p?=
 =?us-ascii?Q?d3OJSblhc6BvsJ8WpGQGlC3zGXKXQtCp1/+TLvUgCeLlAbw/5IEaK6Eyfc4v?=
 =?us-ascii?Q?+fbhR6ZlnD0vczqXO4Il04n2CJ/j6vP0AijNIIPiJDhnBqYyZx3iE02l5/Ak?=
 =?us-ascii?Q?62NVsO1OsvQeN7uxtT2083tD27VbD1r1p+djuNexlSaeYz0Tqq3Js6ZX+aKj?=
 =?us-ascii?Q?fwV3YogTHPfuDhNxtjZmJnvOUT115/uZEavlVVXNtwnlU23chNy/wrc4tEGz?=
 =?us-ascii?Q?5m6oTMRAYNy4MRFJB1sDTwvw9G6p2ByiLWNR5Ae7UiDfIbLMUPf18mBERXoy?=
 =?us-ascii?Q?rUOANBjXpi2Qf5PjSRLGNjRHQoFsrMckhTjKrzOhnXdDcDm0QNJTuaUJKwS4?=
 =?us-ascii?Q?aABg/sT2YUIMgcWZuCUG/mXcULNLadJtuk1R6yZ6FluJEiiN2EXMieSCbZwf?=
 =?us-ascii?Q?VLGMTWOrubhi4maVh5+b3S890onNfxkejcR78JderNyvgGZUk/5aVliZzPt7?=
 =?us-ascii?Q?+jSPx0T00bXShdvwbSrb0y6GmQJA6XvBBAYZUZfDBaXUB/RK1fgoX/HI1hqN?=
 =?us-ascii?Q?JKbGS2esoF37M2GCpVHlTk8npoZWOuw2szgL3M4voFPmJPFkyZZXkB+szkot?=
 =?us-ascii?Q?sabYXnLy1waE8FdfBrmZs04v1BBowPQfehFSjVYxFCFblouTByDJTD0ZqCkD?=
 =?us-ascii?Q?28zE33QoxhWDXNiONBXW8EWTCqJbOI2530aiGJ6hq85qi3aqIcPacXv9mZsu?=
 =?us-ascii?Q?rZjlNZMtEcvp2+VnRtNjCMdIY0WZUtVbZ7BbQkMQ+AMxLrzmJOzkOdinwWP7?=
 =?us-ascii?Q?CqjvAitwNsXqh/jpumotz9Dn8FZ2+u1BDdEpCx2vRV+FNLM85dnM0AaAS7VE?=
 =?us-ascii?Q?Hluhpm8iae0ohPvW/7YoclhFU/HLOG0z8VedzkiZ3Oc3WqJ8/Bx5v1qe6iT4?=
 =?us-ascii?Q?VxO3KgqUEAr8tGsUfQNPTZyk7/+lO+ELFD5+TvmUYb3eJK0CYJAqzrfpdNGR?=
 =?us-ascii?Q?PXuQdXomoP1rPWwuLoP/oYdum1jKgt9IHdKby/andRnjDSl0VCHNVmEOZxlQ?=
 =?us-ascii?Q?AwLwsNSDOHkYLiZOpNah960gJBQYycINbALAo3oGc19I?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	gHsPiyCshk2uNpVwOSjRzW4V9VvyoYm74GSW/QmwBT7RPW2ms+zjKF+95FWeZa0ZUCj9mlpHNV/VKiKsoplcmwR7GSSe7XgHKtHjy/CUaPmKmPkEkhBzZrhwHhBGR3/+Y02qTiNSAElgH7t9oF87IB7ZVVn5XezK8/WWAZAo8t0fDMkQ7J2bjZHEaymjWKFj2BIEPEqP54ktttYVTbVgUddXFZI96AR0b/nRfjPNiwlZ/VmTaDwSF1FpN5VMUag9XjcqUiB1eWVz4x76GCVws9YjW8Qh4oTdosuvMREPO9w2Y2jNSmHiID9UBKRDmzW6gMuU3+fZ+3ys2Fjh0kz6BTtWF3n8iV+hprQSeIOkozQRz7kWScCmZfD8EePmRGo9n2durWO1ydspr2QAyKVbJCWQx35k0QQ/mZQGpdnp7N2ecoujM1GsamC16BUR5incclTIGWNxqHbJ73nU6OQGXE7HqIWUgXyyLKKzDzBzFmOOTuTLGA3fAQhQHCHPNDe+EhlM3M0A5FJgSTD5QXXMTmtXPwY/IxBYXfZIjUwdSoFdGtV69FEUr3DUiiDzK5mUG2UlxhvZ5S0ObAUAW+NymcCGPkNAd4nvWNyPh42Nyyk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7a6b3ab-f0d9-4887-ab77-08de1da0b309
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2025 01:55:17.0806
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4mqVffWWgU1UdfGsvFsi5wAKu4jGWIfuFMiutpBEyV8TxALUB9hlUbNCUlVU91y/hhLXL8wxnq0KzFKTJrGwng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB8219
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-06_05,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 spamscore=0
 suspectscore=0 mlxscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511070013
X-Authority-Analysis: v=2.4 cv=L/wQguT8 c=1 sm=1 tr=0 ts=690d5188 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=968KyxNXAAAA:8 a=ufHFDILaAAAA:8 a=yPCof4ZbAAAA:8 a=hMMI0poUion4MMAo_soA:9
 a=CjuIK1q_8ugA:10 a=ZmIg1sZ3JBWsdXgziEIF:22 cc=ntf awl=host:12101
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA2MDEzOCBTYWx0ZWRfX+3ZWRHngtWdx
 /ZQi+UBt4pPbi1hdaEKC6B7buW7TroMwEl3MggR+WxQa/qnOwRdpaw0FmIgegeXdf/8od1Fei5Y
 K5yZ2rDHbjrCJwBAgKmdm/5jIWm02Lp2h+PA8YfySfEEvP1um1Dk7UyKNeF8yCZbGm4IhYWjVOX
 PTOudD38tO6/qbTQOM9sHzuShBFviMxHSFX3UNOq7TEHNylGjpjog/sWp5EJa284I82P743ilYM
 gSg8RYTyoTgZSetaoizSVrPID2UdzulMn9N/kbtnksSjVObLZgLv44gkukLmcKPn2yQqvJC1zEW
 8BHx+zrdgpxk/o4adPeScGFylVB8nSnK06zZOHXqbba4GRky02WOJrWj4LYvlD6D2hxA3tH+ToY
 Bth4Gq7XqE5ObrucZw8KKM1PKRurwIfWzKyEL8Lr4y5kD5sSMFo=
X-Proofpoint-ORIG-GUID: sfSqB-cKdgbtqBg-Z5VL8lA4qWAtqy65
X-Proofpoint-GUID: sfSqB-cKdgbtqBg-Z5VL8lA4qWAtqy65
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5282C10000B
X-Stat-Signature: ny9wt1spiatbue5db7yqky1prub779xw
X-Rspam-User: 
X-HE-Tag: 1762480531-580799
X-HE-Meta: U2FsdGVkX1+h/ylLdIIi/XYwANu7aFJbKedK11HXOSMTuoMndghKSXEGUH9UTfK/uCfPVh7oRV8Acmjr4aLcTFCkBRQYQleqOr7vww5tkBaApVD5JhsXmOeVaXT7oyZlXoOBu7zZjoF5cMio7fDHhyzsoLWQd1XkR+ftwNmpVhVrJ4hB3FxiQYDrsfCy2ZXyYgZWhgcMz0IFmAna+Cc/qlpSYFpE0oH3TvMrdPZone+Gfbl9YQuwlmuDj2TETFiSc0YC+4DlzR4v8ekbRFoudGI7MkmwSvTqNHAkDgpV35pCZ4TjyDBzeIbnm32B71aG194/cznG1/fsfAzR8KuF270A3fjw1R0t6mRvc83UGqk3pSIF1PlOGMBv5DSx/cdHX3R6TdZ0mbING1wjemCNOZsOZ4bWQHMp6QV30O4QGh3XwX+Ng5jEbpRWStxR7hV0GqnZIBUqjQ9kK91kNlwj8/6n7eawPP0YUR9WRJk4bW389p8vXUG87ua5SJax2FK2N3bRKORcxz52rtE9cC9wp2JJAQSHxpU2lGLmV3g4fbitrFUSdD4ZZk3rI6vMEFv5P8SoCBgGhJKy+jmOK5XSYZwI5S/Q10qcSNiNmQiS08mGVg2NJw3T3O8vHItzf8cYwR2pEyRkHMQX4LgcmmBQoQLY4g/GvUpnI5vAC6L+923SzVN3wv6272434i0MQVm+qeWz4tN6xfPJGmk2wwE0WsiICudHk84kxpvSno2iHI7FOMDWHbirSofFujF2RRdp8QEuJoTuaTSv3Rry7A/85dYG5Gk0IZgqg3HY4Hpu3ltkHsbIMOI+qR0E7VvzRknT9aJdfZNBkxhfYoEPjVPPbkP1GzQClfSHJoGyF/g0VELIn6GJwQtUs0M+arvIJucXJVavfohTp1MOtXzydQrPf33EC+wx2LmN2G/rIxYbeEf4tQZJYPZWWFvbrxuX/a37tIaehfxZj11MEupg3bI
 JZXf/PEh
 ngZKNC5C9GRJHL7hbXFE9e/n6xvp7iYoWRkEyVtN524LAv8fAmwjFbuQ6crC2wGhldXrJXoiIHLekdO58vcDvVkj8svyfhmNa2v9R0mJZ7OEkhP0jEqTSdDOKiD1Rto8xaDwSTM3i0vuWDkLjPdj5OhlI5DC1Pyu0fs3q8cj/5rFIXyGEfOrN9coGJVHF8Xd2dQYmIbPu0oHuaAVV/6z8QBSN8+vXc6oHsl2Y9qmVwDTl1Tc1YbMH/4T97TfaNWoNrR/7LDLu47yOVQkYEx+D/+65O6Bk6y6edlD2zDb2Xb2TFS6tHLKXGAYgvPyH9WTvvhbF5IAExUM4lwIJ0M+wphtSQO5b4G+aSpI+m8qpWhzCNN9QoS2hDtaoTW0Cxa58+SIu53TneyByAR3bL1NcgfAR9xnwsiW9eZiLa3UddWrEvRMmT51Gx3ZOByoWNGBCy3351/OiGmKTfkphzh+TOPUqILWttWl16MiMS27EL/E9+8d5hxv2lIqya3liUsJ5eoLbTzEuTPEpg68xc8Ej3vmZEPsguAcKP4rm2pnjVxZ1nlQR1cVAYtzpxZ/1isgs0Bggosd95xVb3880AX3M0pAlLH4xg2F+LhowNlkEDFjHWLDw7n95gluPSK06rMKlokC3sEFkjYvFz5vK9WEMJi/oP+RKs8/LdTxwGEmD64NA9EhyJsqEXmvkEJKbFgCdAj7EGbQvJQ5P9h4OSfIpA7j+YYvvLtjr1oI5A7XuMYpVpR00MYsr1oNMmB8TlszeudAsXeqiWk8eR83U0yXTQTnvSmuT714qKR4JmBEYGuHtxBo4pEhteOKJSA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 28, 2025 at 09:58:15PM +0800, Qi Zheng wrote:
> From: Muchun Song <songmuchun@bytedance.com>
> 
> Use folio_lruvec() to simplify the code.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> ---

Looks good to me,
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

-- 
Cheers,
Harry / Hyeonggon

