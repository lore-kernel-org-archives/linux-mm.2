Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C54FCCF2D1
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 09:26:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68F5D6B0148; Mon, 19 Jan 2026 04:26:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6657F6B0149; Mon, 19 Jan 2026 04:26:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 513626B014A; Mon, 19 Jan 2026 04:26:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4053E6B0148
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 04:26:39 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C250ABA7C4
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 09:26:38 +0000 (UTC)
X-FDA: 84348183276.09.C2135AF
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf01.hostedemail.com (Postfix) with ESMTP id 741B240006
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 09:26:35 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=qzI04lT7;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=T3O+vdQJ;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768814795; a=rsa-sha256;
	cv=pass;
	b=LhBQNAPf7bvpAYcizHgxp3iYAqg9bpCRTMcBraYIac8UxhbUeDTrv7ihQOvVRY40ymT8AD
	BI9qjboOlnUMVFejSs9KzUwQIz+PKnyvBpbUlxkPzmOFhxX/r4S+iOKyCnGO3SfXpKSNis
	/WYq4RUi+DG88QkQkYFiLbkOwq/z5AU=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=qzI04lT7;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=T3O+vdQJ;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768814795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WZMnYZHwqNpjeivb80u3i7pVFbY3Tm7P9ikkJXJOhjI=;
	b=jjDRTKLMR0dryrzPJhExgL/lr8LAJVNHVYcGxtuz1pXFqMUi9rwhsSbab3JkPFCl3Qd0dY
	DMtiYTbu7Lj/BJ8LgtrG6KQUDNAgm6zRwz/XjFv0qsMXxCyiNk0kCanj/NtiMVET0OMZKD
	UQB3hdnv5dc8ww3qy2xgt0qmngwWhGo=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60J3IZer1315939;
	Mon, 19 Jan 2026 09:26:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=WZMnYZHwqNpjeivb80
	u3i7pVFbY3Tm7P9ikkJXJOhjI=; b=qzI04lT7lIo0Oy5EaTeUNo3gipZYcxo/Qf
	0NOqvS9Ea64dAW/mK6ci0/HDQ2+tQa9waY9ZCjPRDFXTpUc6+hjXT661srPgnwHz
	y4FGbAVShfQ7fxf3s4Y3ywFAMe1ifEz9hKnqnZRPgd6O8dm2kkA26SwPdPb48Ulf
	WyihpWCLY6AV+RTWNKu4VjSH50pRjGwVJYyxbyCNIYFGD+hpdLQD/hexPyRiEgw/
	lZnf3CCibghlQniwlyicO0IOhR0SH1cJc34EfVkVlYay5tjbnNR531Ioy3Ca2/NK
	mmSXSELhgppD1SmmzAe+wKCmAS4bTOkVwd4befC5Im6jhvJd31pA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br2fa1yu5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 19 Jan 2026 09:26:10 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60J8KlLx032213;
	Mon, 19 Jan 2026 09:26:09 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010038.outbound.protection.outlook.com [52.101.85.38])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vbw6s0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 19 Jan 2026 09:26:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UebP9wN0IYucad3035tzTdf1EPNHRXTioFNkL9pkQRJu/XJ+LS4JrE8SEq+H265kah9Q0eBDQJmsrPv1nrv6EX8jXD7tmclkBlxSVGLQYoa0UPXJ5dTqS6dhQvLWb0mNpSvKQom0fUj8N75rzqmyyJ1jN1Edd561+atMxqadhaonIyjJr1AgJb40jAZx9yiHabcIO6Hk6t74f/dNeyxG7AGWCNeSh6k23dy90+2uZx/UkUC9b3SSnzMteDTWEO71S3hubusSDyVEKsLqiRvgqrsUkkcZ8QKlhLLC9Rcz9DsX/jaYs+trf9LxMjMCVCCqyt+tM9roLgIoghs1IpkywA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WZMnYZHwqNpjeivb80u3i7pVFbY3Tm7P9ikkJXJOhjI=;
 b=UMpnfdfA4KQjRaPkDhmK2t2gHHD8bGvwIbsFqGLPFy55dTBh/ZeCQPt1Fr2lOAJ1YpiomwzPksY79NLCNO3YcbxnJmYd9aBVUPECeEl+js0qK99oTXTAK0JZXUy57HBm49oA6WTE7U4SLPjeQESrChgNT57UmwDRpLGltbzHQLCISq9VFbFvipfdnjGdnvXUX5LHw+d16r3BxH6n4dRVR4O+G92uA/ramynX7D88hQuv4+OCOAtFRHXP/w5x+/WDptggjroLc43NOnP4/C8KGYVVFuWqAAjrOvuBQizV+lEBTjTZd1Xl6mtTaZ0apqQyafUXVAy+BJiiHX8qOIzxOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WZMnYZHwqNpjeivb80u3i7pVFbY3Tm7P9ikkJXJOhjI=;
 b=T3O+vdQJdB9Lf64lSxM89x/hVeYExfdVKBbqzsBc9hbg3UjU4pbsl6kQ4vl6PMi/WFNczL24JxedoqVfoI/PXZvTqaiQfvf2/XbvpMLKBiT3ZKcoOWTH6Q92sEgQxnKyjzWcpFQS9wttAz+aR+wvsTew1lJFMOyBoewtqP+MI/o=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by CH0PR10MB5020.namprd10.prod.outlook.com (2603:10b6:610:c0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.10; Mon, 19 Jan
 2026 09:26:05 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9520.010; Mon, 19 Jan 2026
 09:26:05 +0000
Date: Mon, 19 Jan 2026 18:25:53 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
        roman.gushchin@linux.dev, shakeel.butt@linux.dev,
        muchun.song@linux.dev, david@kernel.org, lorenzo.stoakes@oracle.com,
        ziy@nvidia.com, yosry.ahmed@linux.dev, imran.f.khan@oracle.com,
        kamalesh.babulal@oracle.com, axelrasmussen@google.com,
        yuanchu@google.com, weixugc@google.com, chenridong@huaweicloud.com,
        mkoutny@suse.com, akpm@linux-foundation.org,
        hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
        lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
        Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v3 14/30] mm: mglru: prevent memory cgroup release in
 mglru
Message-ID: <aW34oXeXcyqrShXF@hyeyoo>
References: <cover.1768389889.git.zhengqi.arch@bytedance.com>
 <2a42effe148a31d308075f9fe72bd76d126b96b8.1768389889.git.zhengqi.arch@bytedance.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2a42effe148a31d308075f9fe72bd76d126b96b8.1768389889.git.zhengqi.arch@bytedance.com>
X-ClientProxiedBy: SL2P216CA0143.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:1::22) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|CH0PR10MB5020:EE_
X-MS-Office365-Filtering-Correlation-Id: 08037d2c-7462-40db-cc93-08de573cc569
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?dKSqeYW6RNY4n1d9Kle1BwvYnef5+DHyyLQVYVkC8Y+yPHSwRqYbf7N9CSKz?=
 =?us-ascii?Q?vZZPE82n0k3L6VZJfAkE2Zv/nBDq50/8QldHHm2pCBAe73UaLjpnbYHUzz7j?=
 =?us-ascii?Q?fdAY8ymmcXuUCXEHdolhwG4B1nYGCB2GuT/bYtu6iT1DTmjBLM+T7vjPbXCU?=
 =?us-ascii?Q?KFtV/2AxA4Gpl+NaJjeJj9Uj2YIbRTmKkoJd+EDe7pGPge5WfB6nKVh5VOTe?=
 =?us-ascii?Q?KiCA226GlkSwUtH/Z0CddqsNIL3J7pFi1ZOUqNng77D/YYFr74QbIjvuNfau?=
 =?us-ascii?Q?O0bTph+803CgwbPm0MijWfAgjHq7jNW1etx3tXCHWZW/SrNzSdcXUNqvToeC?=
 =?us-ascii?Q?WT6BukpGySYxWTOq/QpEI8MzvQrrR+0teVFa4tVKWBYfY137d+BQLEC9XTYO?=
 =?us-ascii?Q?AGKtTgLS8qo0q+fLP2lfYhB2FTZDIUbKWUFI0elCIluPz4a3OvFdhs5tv0I6?=
 =?us-ascii?Q?7sJUEiaulnUE0o/DyFli15Ei5MQe9GnbIxF62GhQVjdRdV1ysuL2J4bwTabG?=
 =?us-ascii?Q?dAzJjblKSXQtMwQEvxk7PWBZfpPiJPsbhP0ySUtCQ2SVHgtYm/icuSh/aM9s?=
 =?us-ascii?Q?6QcsvL9QwfkDlrwEcMn/CqkUCMfLZ/PG+P5UFDpK38uc0L6pyhUrL8od9Rk+?=
 =?us-ascii?Q?xXzmrBm+hgoXtvVOnBWINQ6Hl9EfFW3upMGI7G/eHencvL9J3YBEWaR1MZgd?=
 =?us-ascii?Q?r1weU3DxFsBvGbkNsTY4kbG8aJz5ffSGT2uUvpcBlLy8D83ZP6gwGm4abn+X?=
 =?us-ascii?Q?q2R/lDYCJ+69YcMj3jvCYcpxi0LReBatqUy1GR5imbzXxJEhv1uk9Uc33vlE?=
 =?us-ascii?Q?9FD5Whr2z4VgmEwReAOEl+aHkKLJHDd+wke2+lv/t7ncr0QqQ7n5dmhfUjr/?=
 =?us-ascii?Q?e3tvcAyJ64vqZ3lRlv4+ygx5e1i9hPOUE2LVa26U+D8d5ZGVTmP7L6jbsrth?=
 =?us-ascii?Q?dVEshk6vLr/sEfyn3n6GxeCT6gfDXLdRLxKjTizLpTNpenwMBOiC/B3aIF51?=
 =?us-ascii?Q?XrDbrScwyZEP6Cp/QWX3lOb4kAqSUDcrXIm+1IV3jipq/sLNGYVeUifRPWuw?=
 =?us-ascii?Q?dFHP+++VFtnyn0zLa7Ut2Catyuqq2oWCZlGjBO8iouRi4SLwV2/FYHtzAz1M?=
 =?us-ascii?Q?sBklnq4JJrKwGiwhcU4GcIp3EROE0BuAsGcJg36HKip5OPmEYix83CP61CH0?=
 =?us-ascii?Q?1ACH0OFJqnMHPXQbkdBzDpeU4Jj62QZQusbI9Rg0HLQLNojPwf9eji6EiYka?=
 =?us-ascii?Q?mIpMmRsWpFV5sG+kdi869UdWhXqcKx51z6fdNPju6tbrVjWR0lhTpb3EL6KX?=
 =?us-ascii?Q?FRxSIXMe2BojQKtD3rUCjEW9k6J2jp4I4hWg+xaT/3qQTZk7trBYzOYGxNBl?=
 =?us-ascii?Q?q0ThxAmucYeEQSMJGwblQQty+sgG07eAbzsWCvGy4lrXgYB0l8fTJTs9emfw?=
 =?us-ascii?Q?JyamvmgK4d7wmuUtpcmATQ/eSEgzgfs4IncVyDQ6KfxzlD4uXt/mvMZeKIoO?=
 =?us-ascii?Q?f9BjG8Dd6rFcF1o5tDk8p0b0/ExDarHTAoxBPOB6k84RIU0v7tXsCYWUSjKj?=
 =?us-ascii?Q?bzVelYMDIAaNGhhp+tg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kMbrt3BxUkXC/xWuVd4jPnMTnFE8IAJbjuaMIvYLUN8hyDH6psPZ+EhwGrvL?=
 =?us-ascii?Q?B3SH33mroUVRfHfoYVC0HfW5AhyjE8bCMSVkz3bBE6GepCmsfzyiiVM3uItH?=
 =?us-ascii?Q?l9WSYWVDi9oR+GMt0zDhY4jqo3VdW8A7ofcPgPGwKtZcEAifDprjnh8J/veE?=
 =?us-ascii?Q?DD+4RYvoBRHcrP7OP0EaVW9/l1IzsGBMWoBPvaq10Ek7qFpbznc+g5w8LITx?=
 =?us-ascii?Q?e1wzeAoJOSrHbugJkuIKiLgqT6iVz/ZFgnhBoUmZ47GephzYKRiIcoDFuO4H?=
 =?us-ascii?Q?suuuzku+HQeOh3WYsNvA+IbpegWKNq/uw8WnxLc30Yqb8PgUP44EfguUPXHZ?=
 =?us-ascii?Q?eb41rAn/TRut5LC6oTo2q1zV1EaLjqXtYDbDMo2mGIWTXKNMLRl3H7nB4nxd?=
 =?us-ascii?Q?2q5ywyPEQFNazMr61i0dsu94NFoW9sA4mbnzen8XaLdSYBJlVY1FsJikyY5L?=
 =?us-ascii?Q?sYQQpBMyuggG6+sBvxEx/9JoJie+eLZ+lyh9TLgaTmTfqDBfET47oC30H8uT?=
 =?us-ascii?Q?zBV/yMzRrKTV6r8lDINFB0gXGWjCjUvakyMinHgsOL0qJodaOn3v2Hrpn1Iw?=
 =?us-ascii?Q?y6hn42K8zxagjqpuwBTC05rtLwpkZG9VuT8/0ObDNiZshimd0i6YATLNiTyT?=
 =?us-ascii?Q?bVq6LPDdNaWU2haYUC9CHErieB8fadiQS87jUIFKej/IqGAE5tNiSK/aKws/?=
 =?us-ascii?Q?KQp93AWDlOGYoguTPHajZp1nkaRJ2DOlk4UhbOkzrUOJXM0iX4M4Dl/8nD1C?=
 =?us-ascii?Q?zoTW93iD608AugIy7JwCjVLetgE/Hg9hY6O95M4rMRmJBKaRpWKRyIC0XCn+?=
 =?us-ascii?Q?L/i67V1sw4iYKUuUbfH6bbIShCAmnTGCBtW71nJTNxSsPdphQYjQKq+knKJr?=
 =?us-ascii?Q?djj/l0ZaV2oTWIFzNHkq7XqQWQXSr3tWQi5rJ+AYRXWEGT0wrPYNlPLaglBQ?=
 =?us-ascii?Q?L9U6Aw/m7MfYCDsN8DhBwUA5w4crGpIA2mQVrC52wmZseWtZJVDradp2tGfM?=
 =?us-ascii?Q?WsJYF+kq1ZWHHrKUvM0iX27kxuuZ6qb8na+xFAUrhvC8eX74DJe0LXGTCX6K?=
 =?us-ascii?Q?cCHtXyo4v7x8VIv6uBu/CHlmB9aR7ckbFnZ5zBC/a48pA7taIrpsjcG+nQvB?=
 =?us-ascii?Q?YB3xYMTsZbe5KlNsNilaORAjmxOt6VSll4iOSEic2LftCeJTPS+X7vl1RFfH?=
 =?us-ascii?Q?n/a17gYcElGPcj9/Q/OSWLrpq2OloSQV/jN5i+IMQVUd0yE3PDf1p7j4lRyx?=
 =?us-ascii?Q?Taiw4W6MSCt5s6ILc1WpvGFPp+kq5BuV6t2yskxGhSV4Tm52MF8DsIaAnJUf?=
 =?us-ascii?Q?aPgKg3p7U6gxsRUzFAH6+FglYtd4Eqis+xS6WFlIM3tmRSqYBhVpU6YB4XIM?=
 =?us-ascii?Q?W7nN6gJAF9mn6AwBG7QQVaiIMYZj1Tip1LhkVG5a04KqN08ihi5Ag3d1NTVd?=
 =?us-ascii?Q?JQb2UcHpJVl1fPZMe0UwsvI+G/Re6pPM6sOI8Wl/llvjD/SDGI2CXFZaJMiE?=
 =?us-ascii?Q?nBqyg+0pA/I15CkMT0aBCzCQAwQUne3NhFDwHcGyATZzIgJbqVZiDURdZ0mH?=
 =?us-ascii?Q?jQHgB5nTKQ9eFXqRJwaKCgIChwcnsy7FlreitFt+xd/j9cpblsoWbdXAzGWi?=
 =?us-ascii?Q?XH4BMd19f9O2GJtv5rbCCyMlzDiCOoHjIELqXgUqmLhzoaO8IwO5HgYqt9Ig?=
 =?us-ascii?Q?w4ofDKqmqdKEJJNu7evuZB0Uq9uOEUrYHNEsZmU91GzqMIsoy/hu4dAuCT/E?=
 =?us-ascii?Q?yOyIoTxq/A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	PP8mxe7ag4QtY4SelEyFUyBnqviLUWhsQ/e1wiqFgDpXPHnNjjA/pQVHbMgjMc24Duqh6OMXA3L/2Dlok26g+8vt7PdvKB2lAoVzzi6pY3SoPuzgEWX2Oklt9tJgXWw7rlip0P9B1OwRaR/FdKhafmaNu+QxC6WreScSAjZO6ulNFracDom6QzuxAHq6XB1ikQR5tK0879NpOZyFL5DX2NJi7YFFnnVdgh9NO1tTs/yWj/+k3m2lsM2+6JvWRHOvzsHR4xGI8/OUHDIVz1kngyX+ibOPzmU8Iz5NRgSDYKM+ozhAOe4hbpaQqH07ma2c4AllSEPsdwKPWARLJuTv9wC+q7rqbEJSfMonNaL8UAKRpdrFALW6lot/jArGYiHcE6hd4iLG5IO1zhKtlRokk9wdrd7Vecm7V3Qd3/nv1zKvIsgoSmJ42OLu6svDNVkPVl8U1VHq1PMY7aJJhRuoxed2Uh1r5UaKN5eu7DaHw/qe6s2StLGCshP2OAEMxWXGhag6nutAKUnhz8rKCXheQytUsZivvBKJCDs21GFwGb5GiLigQuKObGKFC75JRCBJRR1cSVMNkQJR48UOuD+fqmlfdh3gMoysj2sFzfOc+XU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08037d2c-7462-40db-cc93-08de573cc569
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2026 09:26:05.6162
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DwVMRh3b9JYWHGBZWPiK4U+5iLnI1O9RO36mr1VLsn3/DtxiifAnQu6ZI1TM6LiY1T8mD3axcvKidRenpDWkHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5020
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-19_01,2026-01-19_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 adultscore=0
 spamscore=0 phishscore=0 mlxscore=0 mlxlogscore=780 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601190077
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE5MDA3NyBTYWx0ZWRfX1TR2nihUjQwF
 SbqAWBmak/1Axer2ER6jAuNYBz+wiB4H4LlCRvaAXLlmKKmI60demtXJjG3Ux8ZIRs5TbdfZEDg
 KvBOKZdfBZyd67Un2uXzD+cCtLR7ukd+pllU++MyIV6cP/AV/ZWfnOKwUT1skvVt7HZ6Yqx8PPy
 YC9AR8LyYSE7xxUSMMKmGJ+BdcVBcBbKjexYHWPNVLgJXA860fDWwbTXlf+VL0ro0ZcGwbuq6Sr
 Ri4qttNfPbfK11osFDtiPDt6NI7oI2uJMwsJzHZBIBYZmlw7ryAn7rqdlRpOdqQgJIaptM9E0cN
 caMH5wOtEBpYdThoDCkYVu7/SNvPzAjJrKHZxv6NWj+KoCVeHxkmManyqiPsmXE1uu0cTteTJiO
 FPX2I3tXMClhsw3giul+yrvfggBMbUc9IN6b2L6YyHo0wjt6ZKEA0wgDSrYJaw03TRaXNYrkykj
 knDj1xIlndG8ao/xfxCfmHRwvz7MJ2rkpeLcjVX0=
X-Authority-Analysis: v=2.4 cv=HvB72kTS c=1 sm=1 tr=0 ts=696df8b2 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=968KyxNXAAAA:8 a=yPCof4ZbAAAA:8 a=WKiVBPBMbvKHMXwaU68A:9 a=CjuIK1q_8ugA:10
 a=ZXulRonScM0A:10 cc=ntf awl=host:13654
X-Proofpoint-ORIG-GUID: tkEl4uu5tvx7W17Qy9RS4q_RbHzqm8DE
X-Proofpoint-GUID: tkEl4uu5tvx7W17Qy9RS4q_RbHzqm8DE
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 741B240006
X-Stat-Signature: xk17tymspddq1qpot6pejz4d77tcz1i3
X-Rspam-User: 
X-HE-Tag: 1768814795-644704
X-HE-Meta: U2FsdGVkX19pEjL+1l/tXRI6w/ZgKaFoF3sfmKv6OX2JSwINNgXhPL2s1eRcA/hIFdAWClJuD9Em0uLJnmNI3sQAiQoBXhu2QmBsyZ1wfovd9+nwIxHZScsH2wsr4s1YRVSKDtB+pmnxBqG/EkT9Zmj8lYaFsrD8Mux15tFJx4bLL5E/kSxux8+64SlZudoXATMy/hdG/HCN0XarKpNt7eU94uxYo4yKyi8qOWX+G9o+zJp3lyhUrLoQ/7eoF1Gu1emrqkvLzw3qsk30wGWA3WaEu2EkeNVWSBKiylNwgI8uL2bYaBlE58AqeqZS/2QXAdgCwKg855wJ9jGg8O8IaQ6ZW/Wbi1XBGhdQgGN5aBKrH3VGDuk4yjCKXDpsb8fl5KJvRs2zIQyuaB0eSlAqRETULvPjEz+e9nrTFZ+5+PUnDKt18uZWnlbX8S3rcqWxGS03f3d3CkWcGeIjMZMNqpfv0GkhWpR6GXUNNuL5otnJFA3ConZIMfrQD2W6QbmM6ctYxZ4LXftpEX/A+cf82kZE8qK8eLqRkjbgzEdGjsqdRvKe40qA0Rji6TxQmwAUrvfPxq35ilJXp/fmQbJ0Sg+8nT4IwjuTQy5QD8EMU8L9yoA5QKK3e8MKqv4vJneS8Jsh0P2hTuK7B5tDG5RrnOB/CipiaJ5zTZ7B18jpRVE0NaCC6uec0cTJeSbZrrEM5g23/l3LVqJM0P0QHr/fBOHyWB47kKIL6jffGnpWbmI2BxcmKjwpI6s2Bf9kCouajMjW+C8iXesjEHjkX3lvVjD9km6QQat2+20xvhmr6sog+yAjnQeox444cGS6a46aTR9cFyxkgKjm7Imf3wXypy3JUcfYDJkHQYyL5Nh+P2iLVNboUtGp4B5yqSyCdA/ngVaR3/fB7FcrOBY6w5s9I0sZkhuZ7ViRc55W/woNdlrt5VAatufXK2HwX4XZNLVeDbb1Y6+p8e+gH9sDDJw
 jUwaD1Pt
 zgjM0X0fCEqEj81N40DxGsWX/ShU+CAS8yEanziaKzeNCKBI5ZgJvU6ObrfQlXoB/GwqcXVEJ2kiwT08O3xvL7Q2WCB9FphuGSI8P4gu6gT5SvYZj4tr2h8toJtGhstvkcMX7Om1MQRfuRNXFW+0wqtc9ab/P08WqqN3+mDp7dYzFsI6DEjEKukJUmk+WvdWTbO4N0VS+XXpY9TYPxXBTrsyVBdQ6Kjk2KvZyUif9EY+BCNK6JVW3oc4POvjMSkdE4bjlHFD0R18Z7L9RrsQ03qjcF005Tl2UGaWDPQGvhsrD0Z1+ID+BEuNeGdWrnXxWMsZrH+EZC2HrkyIQXxr4U8ywyeNyeQYgG5gSlT+B7vtE8A9y68Nh85fkJXaf0SLQoQ6Eio8Ng/bVkEuQrmBwnV5r7h4fI+nt+TTu14Co1d/LzBjK4w2gnLlJJo3HHyY5hW4ZOumpYVmxn7C/KpaV259UPz0S8Ou2lX8RjTdLz+HDIhJLDTUoKkFgHz6sBY3qGnqcyB5fCg2IQqRilJBRwW+62s7HnLjoVUG9fEpE9Wy9lcRvnD+6/h+1H1H61Q+U9kiKrXiXB75BtQugPXsABB7oV9QXdOslV009ddFCPsbfGY6U3lFFOX6gMwYsPsnBegzXSQxcdtFiFGkfAboizud3g7dLXVMTJRN4Kd0pniQejXjBq/yYD7JNJM68vkxaXnKHwDm+BAghzT2cxXrJKXlTF4OrIFBHyrvIbDkVgAW2cgY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 07:32:41PM +0800, Qi Zheng wrote:
> From: Muchun Song <songmuchun@bytedance.com>
> 
> In the near future, a folio will no longer pin its corresponding
> memory cgroup. To ensure safety, it will only be appropriate to
> hold the rcu read lock or acquire a reference to the memory cgroup
> returned by folio_memcg(), thereby preventing it from being released.
> 
> In the current patch, the rcu read lock is employed to safeguard
> against the release of the memory cgroup in mglru.
>
> This serves as a preparatory measure for the reparenting of the
> LRU pages.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> ---

Looks good to me,
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

-- 
Cheers,
Harry / Hyeonggon

