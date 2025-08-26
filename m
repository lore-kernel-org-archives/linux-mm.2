Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF17DCA0EFA
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 12:54:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C9F58E00D3; Tue, 26 Aug 2025 08:54:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A1738E00A8; Tue, 26 Aug 2025 08:54:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAB8E8E00D3; Tue, 26 Aug 2025 08:54:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D6C338E00A8
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 08:54:00 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 568C41A07EE
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 12:54:00 +0000 (UTC)
X-FDA: 83818901040.12.C0E2092
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf09.hostedemail.com (Postfix) with ESMTP id 318FD140008
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 12:53:57 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=JwoCWYUd;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="m6U/E3jw";
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf09.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756212837; a=rsa-sha256;
	cv=pass;
	b=yD/6Fi1hjb3Nb5Hsz5cwMidU7sryb0Qrob91m9VObB7ot1Sd+wyDiXsj0SGe8GRT2onYCN
	aKEBLLO/paikQrrqStOj+S3d+Apb98gd+w5+a6GysNyWPVVusWzdGQN5B9JOxuYX2mQlIr
	Qx8JqKSHkBxevH30501y3yEjHTXKVJQ=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=JwoCWYUd;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="m6U/E3jw";
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf09.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756212837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c85w10imuLDXfdm1aQGBcIUPBwwwq7L0ZIbUMHkooOg=;
	b=ITIqDnez0sMJ7NoXtXC0ADBv8VHrW1ofPz8F4laEgUNCivuu1YNzgoPPxPF5XM8XxccdFs
	VBkjmHyBl0VTb91UatYKdrIpMo/GZCvHDjFfBBv1nPsbvEuIx3Pvxl40cIHL46yosXLcIG
	TvhDv8qs3mPWeMEyHAv8ctuUMhWmlPQ=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57QCHnLX024588;
	Tue, 26 Aug 2025 12:53:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=c85w10imuLDXfdm1aQ
	GBcIUPBwwwq7L0ZIbUMHkooOg=; b=JwoCWYUd1KMkonNR/ba47JSpTmuHe0ARxn
	iSSVVIKN/yHpsjZN23IO8AIKza7v2CeMB3qr8h85ZRHv9V13XPjlox7+YvpPL1bf
	UkRFKh8ph5Ihy4hchmDNeQuMApiYxLL8nt0ZeU8LuFT3BSiHGtqHn96kFpyoUYc0
	ehgH1po5oNTQ24ZKeMz7wGw5rgCetWt+1C3Mcl6FGaEG+wl+ZU8mjlqAMzU7gg+/
	kIxQi/TnsezPDZC2nH3whE0Zd9x+7npJPfayxDSXiixatYIP1ybf1sCKVPF6gnI3
	9awX9jUfPACtB7oAnADMjklDBTlK2+cXdHUiGIZkU28k/OoLPcBA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q42t46xh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Aug 2025 12:53:49 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57QCZKII014658;
	Tue, 26 Aug 2025 12:53:48 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10on2085.outbound.protection.outlook.com [40.107.92.85])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48q439fy4a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Aug 2025 12:53:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NAO6nOwtD0ALFB5eyxsElvBz1GeBHySKOsRjMaEOvFX44B1lX7IVUtwEIeDDCJ2XXECU5DCPMQ0+71AM27ngw6ld4y5KcVO0WhIRUF0qkec4M0uSa+ErZHSVQQyiqshnH+1LTtDNT69rThe7U7eH3wK+9C2DOqiDNKDUkz5nDxng9Sx6UHaNCy5YPhastCgW8lsCwiiAwqSmZwcnODAnVCju7cMLcdsbNjpx+/ieFFVnroANdL56/TQRL75LB+FnT6WDpeAZeI2xjL4hmT/V+Wp8pIBHsdj0VlzGw48WfZAyHEtfovkImMPZdbiZ5RpxOZWIO1iPwgYPuWn37/iJgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c85w10imuLDXfdm1aQGBcIUPBwwwq7L0ZIbUMHkooOg=;
 b=K0LdS5feCBaoB4Dz67MSZTS/Bjfg7MkGWFQ5prJhHrD4PfYkMGTTBJpIC1bul3JzgIvXbMtCqDqDH/KyfBoavhtqjCzeqKYQJCIW8ZfNpdPKxFm6K3QU55z64xKuwZiHKI0vvszoJwE+ag3Y0nGc9sQm8Rru7QK1frcCVGRc/nQ0KinwG+YXesxkM1e6Sj6mEoQ2v6IHKDeJfBs7zbXfn6XHhZVO3yUAVL2iALawIxu1MnIvALlnAxoWSwXwcXm+u+81gKDe03yGwScUiBTCIwd2XrY3ynvoSV8b53ycvPp5aE320mhLjX4WT/0Yp7CvT/WiUL8DLxPeMXRH5xZOOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c85w10imuLDXfdm1aQGBcIUPBwwwq7L0ZIbUMHkooOg=;
 b=m6U/E3jwxazHbv9yzI3fPicnOca/Ln04YJ41eX3Uj3cgO19ljIxDXhSrRNl7ZTs9gn3z/Y3NIepkaZPThuRqvOyd0paFohGIaN3hrVU3x2yArdgXQogfxPqPxtegeV8YJxYLHmyQ3QETu7nVRHLq5ENMXGivvKmjltwRHro81S4=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH0PR10MB5729.namprd10.prod.outlook.com (2603:10b6:510:146::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.14; Tue, 26 Aug
 2025 12:53:46 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9052.019; Tue, 26 Aug 2025
 12:53:46 +0000
Date: Tue, 26 Aug 2025 13:53:43 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: zhongjinji <zhongjinji@honor.com>
Cc: mhocko@suse.com, rientjes@google.com, shakeel.butt@linux.dev,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        liam.howlett@oracle.com, liulu.liu@honor.com, feng.han@honor.com
Subject: Re: [PATCH v5 2/2] mm/oom_kill: Have the OOM reaper and exit_mmap()
 traverse the maple tree in opposite order
Message-ID: <002da86b-4be7-41a1-bb14-0853297c2828@lucifer.local>
References: <20250825133855.30229-1-zhongjinji@honor.com>
 <20250825133855.30229-3-zhongjinji@honor.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250825133855.30229-3-zhongjinji@honor.com>
X-ClientProxiedBy: MM0P280CA0004.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:a::18) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH0PR10MB5729:EE_
X-MS-Office365-Filtering-Correlation-Id: 634634eb-328b-42da-7603-08dde49f9828
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zhnfMeZp/vzq3qlWDTSjqiF83HZzAG3botdZ7ojxetUmhBNj1rktb+R4dJwb?=
 =?us-ascii?Q?nJhLVdf13TV+UHceDBDb2ujfvNlmliZkJtXD14EGLwicTjPufuJEjCMQGQcw?=
 =?us-ascii?Q?8fTGNgRU6KzeYFmlQUvgmCcgCJ023SP8LxpmNVGiFexrSVOguVMNgnByf6AW?=
 =?us-ascii?Q?G9c5wLuNvo8vVshF19LsaY1NgGLB4CLzl7vxRDRUUy4jol7sNxrmxHldWZin?=
 =?us-ascii?Q?5YCp7E96RxLoiUg1I5DU0RGp1g3Z/ry7h0MUCaZomPkjGlYk1LewYxB2vWLw?=
 =?us-ascii?Q?hPPURa8lJiAJu+zOjVpSBjJx7T4iWhBmI50Kz96JCxH8Zt8Hak3bHZDS698N?=
 =?us-ascii?Q?Z8XysyZRdoBCwqtXxSOjeZtWXHVlLZ2LHLDFQEnZXp3ROsflury7Dq76bK5T?=
 =?us-ascii?Q?+nhwCkTu9wv8auGowiMKtZIPTCmNVWKLsPomh8mFvjzSatlEYLzOQQL89zai?=
 =?us-ascii?Q?019Kx/uLDUlrorwErbeAvJhq/PDsx12Nb/wjxk8UNfDiX6TVjWj6WBZuJMrK?=
 =?us-ascii?Q?6ZA+L+L5A/rygXDAN3YQjC4796OMuwUUQVWxlgq1MMuFkTuY3nPD74XzdJ36?=
 =?us-ascii?Q?4D1aERFsATOedFVKaqFWRyXtbUg0eu60+xDyWw7Cw02wucas5KDwErC7QZHo?=
 =?us-ascii?Q?ENzAy0XbfiF1i1hdwnpUYvczvOxGLLwREVYEj4svLVKM6D9cnu73TVOZ9sF3?=
 =?us-ascii?Q?t76aB1cTQt9ZiKytEBAOr3o5P6hjIZTyCJxqP19aUvQn1Lmiw2gNtRxMDmcM?=
 =?us-ascii?Q?U2QyCUqH9XR+13jfhyzxLBOuemzFA5gdW3NlPZC5CIDfphvdTFU4rK1mWMjj?=
 =?us-ascii?Q?LmH8TLUaLxePVG0wXSf4TtWe87cuX/xI0U+RDcjHq3DTkfkytFmcwfS7OxSS?=
 =?us-ascii?Q?FGzrHeCkfUn55Xzb9oWm/npiufzurWKpYfB7kLbhgSXd842yb70yBmvUVarZ?=
 =?us-ascii?Q?pfQvdrLIXrzXvOFLtY9nA/q6LZmvH0I9qOw4yp0IoXL+kuJPZY/IOgbko/FY?=
 =?us-ascii?Q?n6J8sNTakRd3CPQU/1KgTR/IYKEhcL5PU80VtAyGF2gnw6LAqUlbO2WBXNuQ?=
 =?us-ascii?Q?uTR2dM6TPkBF8bhsyFAjwddvpr41LNPFWrUtAXhX0O9kzNmcjk6kDKOW7xGM?=
 =?us-ascii?Q?xqDXQdVCNEr57TSRm1ABtkXpiEYSPZ2tfkH2GH9MOjDC7vJu9M9Mkz15PBZR?=
 =?us-ascii?Q?ydwGQbJntqLF896LCWiwGoAueL1qzuxkvwRYqFTl81lqfejE4HJVHH8Rgr+m?=
 =?us-ascii?Q?OlLiZSoB4xjUv0AapPVwwML7DoLu3hI3ZP4bNfEaIvdJKVISQsJ5gI3Bf5C5?=
 =?us-ascii?Q?yRu3fZ5vkhqykZwQWNUebBffMg1SjA5R0Zw4RrLzRSw023vbfF1STiCba14z?=
 =?us-ascii?Q?P2s8VR9ya/pzmamHxjeFrLhPgLp8PuwSW12imk8ZubmLtiSrkdAVYiAoQYgo?=
 =?us-ascii?Q?keucZxhxPIk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/uD+numsHOR/VUyMFejNZSc+50+CgDeFRA/Yob1tAmkm2JZKXXtEtf3QeIL0?=
 =?us-ascii?Q?UatYpLErggiBFgXkv2cyctERce5mKtzAUeKgpMKP9cGReEYMBUcgIZV6PoBZ?=
 =?us-ascii?Q?W48BSY+iuIr5ixjddNc4wyVeP/HSHFGQtmSzMo0QdOGxB7Chjj3aV+7pxtgU?=
 =?us-ascii?Q?E/SAYNGfahxT7m17PuhX3Gsxy8On+anScFtdbtCBVlw8NCn+stMn6A7E5LOo?=
 =?us-ascii?Q?7NJ/DY7fp+2RACDmnh6g6odq4/hk2mn7p3BDbsVG/nA7teaRLWfGqLbj8ToH?=
 =?us-ascii?Q?FJCJLj1/A1/9p32bsc3KI3im0yGbsnIXsvdtMajt3VKrYodcpGMb5tG2lQXg?=
 =?us-ascii?Q?FsBIz98426o1V6US8xftAkpOG5ekGIU6jDKSIYoRz12DJCxXJyEDrjNzj273?=
 =?us-ascii?Q?LzkP9QCqYre8VQIIb4rac8ayNeoEEVUKO3/5wY3B9Ho/K9Lefbtsr3AopD/P?=
 =?us-ascii?Q?aiNrW5TPfIbnorrLwUeT4Vi/gmj+hkE39KiMQL6G9cCeK+7tz0hYWriwiHUR?=
 =?us-ascii?Q?wRKLyjuzeVMqttrCXGQnAjRvLZ5J5vAjKv9aJoMGlM0JBXLrdD2kIZlbZ3+K?=
 =?us-ascii?Q?6DnLTpauUtexxNG2oipv41koILutGkj5uIiv22YLytHhr8YNTvgf3afygApA?=
 =?us-ascii?Q?Fhgc+wxKnTTev5SRgG1KSSnyBOn0CKAc6E8dL29y4AprFzeI9fGzVS3jeKk+?=
 =?us-ascii?Q?efI8VRZaXwdKzC8sKB1sNry3ZPc8R4vX0HixJ+RXB4Ev+aVWGt2KXGttlAom?=
 =?us-ascii?Q?7a/IO73xJPSHo8U4ooX3HFPDG78ENgOWbNFdjoUlaKRSdDZsPvOee2zwX0+x?=
 =?us-ascii?Q?YscF/+8sZylUTtskjzJuTCfm1JNzalhLNfHoMPQvovDQ2dyxjCGs44B9eACP?=
 =?us-ascii?Q?JJbqDZ92A8li/AM4uxlX5F84344CtDrj6nz38s3n6ZtkCzDa9jPMv2i6CuFZ?=
 =?us-ascii?Q?PLuzfJ9+m2ehOhGVhRunsgjAvh1qQ3ryhrpQnmYEGJXL/P1+QPoquB8LK9r5?=
 =?us-ascii?Q?dI4FSsFREdsC93XiYTs8AM3R5zWJ0Gt8EhlhLKN8Nm4kuDK7OggY4YNgpPvF?=
 =?us-ascii?Q?y/qNUFwftJyL+Qwm9N9u5P18qZ6VG+Ha2/YeznZGREIks14sDo2J/0k4DTGh?=
 =?us-ascii?Q?rfTheXa3qbKWTuSpzHvkT1VyhcLgvfpreKHRYHN/FAaWK9x4+xuM/PxolNsb?=
 =?us-ascii?Q?W1n+0GpJla4jFxcfl3OBGflYfQZk5cKqCkatxJtkfYw93DR4odcTohE1hDUM?=
 =?us-ascii?Q?vNJNSvSfaUgUXnE+Frl51S9mCeX8+671vuUqHEk/pypBYUTmMROBZUoCVRAL?=
 =?us-ascii?Q?/Tjwd64yfHM7pFE6sEVLlQKn7e519RRNYDrmIP7lgOTDSd+fMcG5o+B/1OiT?=
 =?us-ascii?Q?hRX9Hq1cz8POYZOlvKFiFGS8LTsbb63TzgFqAZRcUZTvDP4wCT6lSXmyvMJ2?=
 =?us-ascii?Q?GnlRx8RPErnl94AlO3/Mj1m20uFYYMDbdEqG6d4r6M2JmSdh39+h3x/Novls?=
 =?us-ascii?Q?4ARX5CreAnTLEbBDfX5byAxDCLric/DyQYbuAtRvoSZuPQXMNy6BZJu8KYkL?=
 =?us-ascii?Q?jw6Gg0GxfA00u49r8WWwpmRlhUdDFU6ufHMlMqRO9rOcAbm0ijbuqKKJ27rr?=
 =?us-ascii?Q?yQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	sdCkhmQJAoMa3wSJpwHOjISCSFd9N0ZMX10olSyZJVLOdBwI0u5Wg8wTjljUmPgdJj7lW7kiiGeJ3L3aX5FL/W0by5xnIJ0SJEJtL51/QvIEbnU5Jb8SwaSh9N2VOnPCbyQtL3n4b4pFKG5KiGJp+SNhhRj7dfhxOhAvDIMqtpBYmNzBhg2li+ovUsMMxQvOarvyOe/+E7k5k0ko/pDJqZNKJxlmFnD+93Ku+QIuw6TdT5Yupi8mOBT5b/94Qk2rbvUm0LPtdn543BkchOZkwtW1TamNdWS5oRv5t9WSWhj/coYZd2am3+yDzlwDQQhtEzDhP6NWSpZYlB/qcNu7o9ZUeF/24uOo+2lgYUy9fPAV5GBS93CtEX0TrU9z/CT5rjLKOVJveQ1QCZ8zO3oFom60qQeDvdUw9D+6iWrL5oG+kWYeDYvXE4T1zFdlpm6wfvoLUFgGZ0BsRnsvTdV02EfREPJVPd7heYB2tpE8J2X5sYrnCFypj/w25Deac+lxcLbtKNbP92RdFhtFSN8C8w/T0AFkDSQAZem4v8cuXs9ltZcTNiONH+JiIlsBFJzXaCBlNe/H2wbJ132HqUSfpY89vo4w+SEhrGwJRTYO8TI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 634634eb-328b-42da-7603-08dde49f9828
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2025 12:53:46.0768
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HhozoxN9XD5s3asb85Q4cTMSbM4oMiFKIVU0Rs4CJPaztUljJDwlVuYhWmnpwEN4xo2SrozvB6oPjp4Drwx2+gpH/oxhvdvbymAJwWfEs68=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5729
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-26_02,2025-08-26_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 mlxscore=0 bulkscore=0 phishscore=0 adultscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508260113
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAxMyBTYWx0ZWRfX8yW7pZpw4Jsx
 Th3KBCrSbvtb2MgCEJaiXWYVX3sY7nXlL3T9DRacdCciqGowZP/XHBU1/r57JM/jrezaaPjdAf0
 /NfsgsfJ204Y0IrGATVNzvj5c4f/ZtGVaD2RgxOOqs4pGgv46Z9/XLXVjfIuw2yGwm1ucHFv1h0
 GTzoDXzIpajUr1F3UeXNRDCiX8rWakDVl8ZR3zG3S7E0MEcCJX61Ty0tGayA//Ns6+aqRHUsKjI
 oUmtGn3d0nZ4OiKT5NSlvXpBclxpaCqc0NWjhsOJs9thKM4kXyj4hQbbWToZEJSuB5R2kqczwhn
 MGx/7ep6N8nvkkC8JSQlQBNxIGr9qtA8hzTAz7J9USsHblHwBzN1QBbffsytJSVKLS7nb8Zk6Gz
 THZ8G2eRUJNxisOF6px50Nc8qgw/RA==
X-Proofpoint-ORIG-GUID: OW23YHSt4gDMzO24GxELsDi1KWmRViX_
X-Authority-Analysis: v=2.4 cv=RqfFLDmK c=1 sm=1 tr=0 ts=68adae5d b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=CvlTB2HrAAAA:8 a=XJ0aUsFo1VkaXKbtmCUA:9
 a=CjuIK1q_8ugA:10 a=67QrwF-mucXG56UA-v15:22 cc=ntf awl=host:13602
X-Proofpoint-GUID: OW23YHSt4gDMzO24GxELsDi1KWmRViX_
X-Rspamd-Queue-Id: 318FD140008
X-Stat-Signature: bq3gtf3sok44e9cp64ppzx963m8q7wtb
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756212837-895369
X-HE-Meta: U2FsdGVkX1+gW938RdPGARpxIChhDez+PzxUkWtO3SaLAioIJg3wkqTr7pHePfBYvSo6mttMNWtgPe4i/PGvX/MwZX9aCWwcTUtJ+mdenUSz6D7NLr0OtUpKt/eaX4zDoANOxFzxO/9Z2MCmGNYexb4zu7XrfG4bs//HRis/x/Xjfn7AGAPahaKiQa3zVvoiKKFEVl8RDoUKiOMaPy29YigHxfuRMw0nInnAlkx6UuOKhP6iVOfSIKAfuWVJHXXsj++gwpkj4h5A2E62j8uADnxaFvKKBmftUscK0+dPpzZGra9Fo1Pf2QPnjr5S0FOmoxjfQ6tCvHCHYFcR1kz9ZNeuSwHXoBOkKlsHbMGqhhkLUeWMiA9b78PofY6oCQpKjxOqnchBa3U+ZRM/nhznWY0BsNcJxCTbav4H4pQ75HdVwPT158lHkOpuQvDLvKnjGOGRQG3OOcjI/esrzM7Oj+cc4dY6v0C8p+JjLQbHF7ZB8KvGwDeAg9nOFDqQQRunci0nOmX2EC46NDFX6APCNkK5h9gxEWD3tABmh34ZV/M7sxL2W6YcmuPuq1tS/C3K1LaoJzd3fj4GFh1SIoey6GU1XCqDDS2rVMVLxz7E2fUzdaAfOtlPh/Xv6DHTFmsWECn5WTbAOIaj9AhU7ju5z1qENMqyMQyevNcno2v9CFVwQNBVBtiyf2wX8smFmUgmB2W+THuv3dcaCxSGc1diULb6uEOQGuo8T9rHfWp0wMwYIu9jdpnQpTwt/b+FYNfmFvJTxeaPrbEaAcjybfR0bDqdN6EXCF6QLV/YaLXiL6Yfm8zH9/OJGPFVhIo0TuPT3C925IDF/uake2g02pXWStflIwKMnelF8JI9STyscD8GNOdx0M/rnvdKpKurrHMIOtAMOjzh3IItPtq2Sow8KdI8UnZ0sCVNzEwWkC5HYp/rsMLGj2YlBHXdu3N5+24s9+3YQ1efkruNKbyF6ry
 ionB/C5A
 v+RHNxSChPcSfPNhRatmThSREvWB98Lab8PpOWMB8SZzUak9qr10DVkDNHcWUqQTbR/86KqRLSuw21cDAaC7UTDLvF1LYzEmXOverVRC0nBsg9j+y+30r1BNDtQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 25, 2025 at 09:38:55PM +0800, zhongjinji wrote:
> When a process is OOM killed without reaper delay, the oom reaper and the
> exit_mmap() thread likely run simultaneously. They traverse the vma's maple
> tree along the same path and may easily unmap the same vma, causing them to
> compete for the pte spinlock.
>
> When a process exits, exit_mmap() traverses the vma's maple tree from low
> to high addresses. To reduce the chance of unmapping the same vma
> simultaneously, the OOM reaper should traverse the vma's tree from high to
> low address.
>
> Signed-off-by: zhongjinji <zhongjinji@honor.com>

I will leave it to Liam to confirm the maple tree bit is ok, but I guess
I'm softening to the idea of doing this - because it should have no impact
on most users, so even if it's some rare edge case that triggers the
situation, then it's worth doing it in reverse just to help you guys out :)

Liam - please confirm this is good from your side, and then I can add a tag!

Cheers, Lorenzo

> ---
>  mm/oom_kill.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 4b4d73b1e00d..a0650da9ec9c 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -516,7 +516,7 @@ static bool __oom_reap_task_mm(struct mm_struct *mm)
>  {
>  	struct vm_area_struct *vma;
>  	bool ret = true;
> -	VMA_ITERATOR(vmi, mm, 0);
> +	MA_STATE(mas, &mm->mm_mt, ULONG_MAX, 0);
>
>  	/*
>  	 * Tell all users of get_user/copy_from_user etc... that the content
> @@ -526,7 +526,12 @@ static bool __oom_reap_task_mm(struct mm_struct *mm)
>  	 */
>  	set_bit(MMF_UNSTABLE, &mm->flags);
>
> -	for_each_vma(vmi, vma) {
> +	/*
> +	 * When two tasks unmap the same vma at the same time, they may contend for the
> +	 * pte spinlock. To reduce the probability of them unmapping the same vma, the
> +	 * oom reaper traverse the vma maple tree in reverse order.
> +	 */
> +	while ((vma = mas_find_rev(&mas, 0)) != NULL) {

It's a pity there isn't a nicer formulation of this but this is probably
the least worst way of doing it.

>  		if (vma->vm_flags & (VM_HUGETLB|VM_PFNMAP))
>  			continue;
>
> --
> 2.17.1
>

