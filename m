Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B43D3C44500
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 06:41:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 181336B00F3; Thu, 22 Jan 2026 01:41:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1598F6B00F5; Thu, 22 Jan 2026 01:41:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 030F66B00F6; Thu, 22 Jan 2026 01:41:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E5B446B00F3
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 01:41:24 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 77E8D1AF1A8
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 06:41:24 +0000 (UTC)
X-FDA: 84358653288.10.03C98E9
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf25.hostedemail.com (Postfix) with ESMTP id 07D23A0007
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 06:41:20 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="DA/glrpy";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=k6Zg4h8K;
	spf=pass (imf25.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769064081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G6YhzHmG4XIOaQKFZgk0Dwtr6Ce9szCA6LpNvKQZsR4=;
	b=dVczpHJET5QyW/4y145fTMlySy6Dwo+oG1JfRKX4eSD2/oY/j52LXdM67eZpvM7wMoKNAD
	34+ChsycHSK2Wj+bBWboB7rTlY0XYM5qLEt2cHHo6BpXRrR++aNRBRXG+zZMzLRlrw7+ro
	222nh/RniPPt1chjwoA0+hW4l3ZFHdA=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="DA/glrpy";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=k6Zg4h8K;
	spf=pass (imf25.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769064081; a=rsa-sha256;
	cv=pass;
	b=GDA+1bT+NhptVVN01QIxGjHGGUL1OJVfcg7MfHTs1egsNCZpkZ+vIlxjAiyJAessPm4tW3
	qMCbHXe44t/NH2XVwt2FT9gcdqpwwIZwAEAgqn7wmYeNbXUgCefcKkUycZ6h+uHkiYC57n
	VGPKWwYREVKY7byLgjFifn3dG637DX0=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60M1IqOt3264903;
	Thu, 22 Jan 2026 06:41:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=G6YhzHmG4XIOaQKFZg
	k0Dwtr6Ce9szCA6LpNvKQZsR4=; b=DA/glrpyMVerNk+LwxOEau1hmNCw9qO3c+
	s2vV315ZS5f0eXV+d1PobpeL/HPZQbUfZmVhYpJeNd2dEx1eTnMXforPMvwwRe0U
	K5V84HKEc6igMZwxAqAKSr11FKMPrYNhvUasrfHw1g5dKkxG3hmj6jumzW2xBtE1
	UBphUL7D/fAYJQ1KCESVXZvFS8mewBLoVxNJv+coLyIqn9tJQvN38O1SmDLHwFMG
	0ZiBrRk1Hhqhlse1eUfvz3t5uNevepLeUAlPkAEart9/vxDV0TOQ0a0MtTV0MRsT
	etdicKa2Pww300DFGE+no3y3CJ7DPt2CPyl+5KKInuHPIjdLlP/A==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br1b8f8mr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Jan 2026 06:41:11 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60M5HYKi018032;
	Thu, 22 Jan 2026 06:41:11 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013039.outbound.protection.outlook.com [40.107.201.39])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vcdug1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Jan 2026 06:41:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KQJgjVdORGYIrRFSz8Y49+IL2cZX4eWxuFY4+Ls+Rk2GpMQyn7Al9MbEZxjfTnGgnp/wzX5zbIbDREI1NpV3XO8b5gXm24xpUjlZhW6c3xCd3EIxdJxRnjrxmLOkyq3fBcioV5vp1hnknSB7vZfOY2JVs2cpKpL3kEdHpJjrb6dor5OC/8EpW+V2FZ+UxUzGeTSaUJ/Kbbvhp+S0PImysEy8aZeIs4C2k4gC1Ucg/+TYjcTprWKd5qpp7UKqLcfQ3uMYshSmjeTJKXKbCFak3cwosf9imlhqj1IZzzVpTMxyf31ajf+MYxq+qU91p/CZ+S4alSz8i93r5/nMgUdoTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G6YhzHmG4XIOaQKFZgk0Dwtr6Ce9szCA6LpNvKQZsR4=;
 b=qk/1pdtBbEV1xQt8tpnmmIlcGzNdjezxKn9GjrmnDMldiVjJYYIazouxb1Bq1eP2e3Qz91FllhCCedd9euhvMFyj4/To73TM+by/6mjArDgnaeP1b2EDBu22ICm9d+BtCAkfrsf0TDoMUw5rrOna6o1Jrq7UFQGs4kbpyISbcqEh+GTnpOFAx1zQIWOOdY2bUZ9ZP8GX0VCyyQNEBVsu/uS40Ydv/sK8OsUY/HnFQBj1OZXbrWvV/QPXXsD3Cl2izwPahmLbQudZQauoXKcbx4Jm5Z/m1MtRFmX2Y6Ez3oGXdIHja37tkpdZyseIEYM5BVgsaNJpLFI4kb0Espt3rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G6YhzHmG4XIOaQKFZgk0Dwtr6Ce9szCA6LpNvKQZsR4=;
 b=k6Zg4h8K4Ko6c3SVn5D+ZtNXMt8+1qYolhbAlr+zZEBSe7Hh5RROuSJUegmv3/ZdsVUq9AdL95cHGbi396PP3N6H9XFMQ7JH9SPErAjT+GeiGlCjCueJ/Ohyse48c40cBAlfKA/fWtR3upyyIn1LTrBP4V/lzhFCLsoTg9iq3gM=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by DM3PPF5F5663669.namprd10.prod.outlook.com (2603:10b6:f:fc00::c2b) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Thu, 22 Jan
 2026 06:41:08 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9542.009; Thu, 22 Jan 2026
 06:41:08 +0000
Date: Thu, 22 Jan 2026 15:41:00 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Petr Tesarik <ptesarik@suse.com>, Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>,
        Uladzislau Rezki <urezki@gmail.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
        bpf@vger.kernel.org, kasan-dev@googlegroups.com
Subject: Re: [PATCH v3 18/21] slab: update overview comments
Message-ID: <aXHGfLV6FdlNPc14@hyeyoo>
References: <20260116-sheaves-for-all-v3-0-5595cb000772@suse.cz>
 <20260116-sheaves-for-all-v3-18-5595cb000772@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260116-sheaves-for-all-v3-18-5595cb000772@suse.cz>
X-ClientProxiedBy: SEWP216CA0080.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2bc::16) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|DM3PPF5F5663669:EE_
X-MS-Office365-Filtering-Correlation-Id: 5cb20472-b010-4f70-db9f-08de5981390f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?AX31u6ZG5tCpSD//PW3RBG6gwavAAzPYmLDiqg/aoXB4hAc7CgMMz54N2Ttd?=
 =?us-ascii?Q?nUHF/1tlabc36YlqVDPoYlZbaGqHGPrWMUL20m0jJX3gT7cI3tU2CQJugffx?=
 =?us-ascii?Q?1noVzjZDpSEYL5dZ/WqX+AHBOhms7FVHeL9q8ETZhMtOErmcEuw5NuiqKCZ+?=
 =?us-ascii?Q?YkPdkSrReRBoEsMrOqED0IJlWuIh8xO6Itg0jUZ3eXEdD7LbdIFmSQkXwzmJ?=
 =?us-ascii?Q?9MlEpatOv+P0YqjG5dAQg+wFeOaE/K2P7W6KdF1PjENjbKX3xkQwS4urC0U6?=
 =?us-ascii?Q?n7GHi0bEMOxNdr1wvpL9sKHoLmX1D/Z7UtV/Gpmefdzb1hzvs8OzlBlGofut?=
 =?us-ascii?Q?EYLx0YeIgKIzMnWzInC8nUT96S58/Z1RFPvscOnem/bZoknExQa9Ub+bH9lw?=
 =?us-ascii?Q?suiKPO7X+BiajK4pPiAKRnoVxr46s9hTpoKPlbtMDLG7GXiYuJweYzh4SkF6?=
 =?us-ascii?Q?yUoNEafQDAvGi1AlCvmh23x6I8uLpj6mrOSkCzEVrMNd7d2JhsUVCiotYJlr?=
 =?us-ascii?Q?1Jz6YDAjSD5JdqDbtHfTHHGCOZypWg1dRp0/3YyqID87t8z+ELeHtDVkzSzO?=
 =?us-ascii?Q?EvkukBmM/fGitR6g1cAX7yODPd4ARMq/LZdqxjWoE3AqG4YbbjXJb/oEsfIa?=
 =?us-ascii?Q?T9cN0iU5jkGIWEGbITLlm5oJ0ykzMUfUTzyMd5X/QcaLhLuoG1w1n2IRCiU2?=
 =?us-ascii?Q?vLdHnjE7MzRpx+DUMKxKsW6g+LXkwcJc8CeXHS3TTxAlgHHG1FCTgHCY0IQl?=
 =?us-ascii?Q?dI0zku0q5A1rEevV9M5P14Zi8xqjNp9e4e1hL8JQG7nZwNoN3kqn0meEVFZv?=
 =?us-ascii?Q?26QLYPR793tDk2e4HFdNnw/xZNzmqpYx23t3G/hfANpVk6oZynigmx1AMoAN?=
 =?us-ascii?Q?pDUcKCTBAn7GTprfFcTSmCWHfmdsHndwqWuiAUq+5Vs0R8lnPPLcEHSk09Ot?=
 =?us-ascii?Q?11C5EfaH+tq0aN77SbtQukvKIkGIb0gcBnEya6bnfar787efIM0jpZlsq4RZ?=
 =?us-ascii?Q?KYyJENqIi0QepDQb9Z4U15zeJP5TImz0Z4TIUYXNoT9inxULng17L2+66Sxu?=
 =?us-ascii?Q?HVL6vxWugGCempbtRaRH4q6YJ/MUhI/ERFUOvB9zhNJMiBLT5+/KV6SHH9yG?=
 =?us-ascii?Q?URzjJrx7ywM5Mwvp8vSx86wtApCN8UNOR6g8kvQ8QCevR+CP4AURMja0CddK?=
 =?us-ascii?Q?v4P+ZSygg0oTEzdkCLDO8y2rtsl3HlDxQ8dBWDmXv/SS+Acif9Kem7JZM9P0?=
 =?us-ascii?Q?kL+NkjH6S9O/Sb7DfFpVyMZfzf9ve3z6vMx3WlslgShp93483dF2jfi2Cw0F?=
 =?us-ascii?Q?A8kvcIwicxHvxjftojuGSVqgFE0spXpH1e3zUWHAoIdtxtNoxu0ODPODtU1W?=
 =?us-ascii?Q?5cF95xWCRLTUXpgwnMlxcI1cC4Z2r2DqUFIjXNewwMho/bSfnJZt3THpztUN?=
 =?us-ascii?Q?oZVlWXbY5j4aLFNBJQGnzoL+emo8f53bv4RpOG+82Ga/Bq6HOn5H2a96IKdm?=
 =?us-ascii?Q?yVqfHWUv3+bjYIke0Pa32uYkV80Zbvzv64XWdmkK17OtGx/2mJv3gq/VZI5y?=
 =?us-ascii?Q?EbbvtinuQZYQ/eyiR0k=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3ZY3yuaT4KFHjZ6SQ69oxW53gz5np0HMDbpPXyztbhYgiDGQUETmqsTQkf+j?=
 =?us-ascii?Q?sWXS3DJ9uxV8O5ZoAiyeWlZ8SeeEif8Ic2Skopbxyee6+oQHYccjklW4sd4A?=
 =?us-ascii?Q?rdU1Dl1PrRNjKqFg77bmkihTt/Zf1qAbnlj+Rn8HD6mzNstR4rso2vl9Garj?=
 =?us-ascii?Q?qqoSQPTvG4F7k+cTVTp+K9XIiL4bzeA4U/aPAS5Mb/7V2aPiapqNFF+6zH6t?=
 =?us-ascii?Q?hmHr+FnMmb7s14dRmFa92t0m1f8nJik3rEmuPg+mFYVqYVvm4HPvHiKuADWf?=
 =?us-ascii?Q?/AKHk+ktc4H6F9n3YlF486nvOMAxQjbQQZKrAFbjHigRGqJcGm2iixfDPN+0?=
 =?us-ascii?Q?bM2QgxKD1433OWlG4FoxpNcq/0nxlyOWzKZp1M8XCwf1oQ69dZk7sKUlVK9c?=
 =?us-ascii?Q?1WYNlMEY8CKXR+sJMZBdJqLlFzk85fgC62Hb33J0brsWoa6WxvQpc8aqxeFf?=
 =?us-ascii?Q?TzYBxJPpsGVZlJDbkjEybRGiTmSU1GE1HTJZ0zSOaibKpNDwFj+Y+s4WTFkr?=
 =?us-ascii?Q?T2jZu+9Apt3C8h1hDKZH2iXDS3FJwQjs/RE44AwTHLQWyCWZsF9cvP9kFma5?=
 =?us-ascii?Q?kfsL+0/h/3i+Gy2oOt4OargsWKcUngU/j5S+cqsheynw5zdmoe1SwwVHJ6g/?=
 =?us-ascii?Q?/Mc3Mm64OmOlW0ewvIZEBtw2hVTgPdPJBzSPYXvkQlq7F1/QFLryTBAhW4rV?=
 =?us-ascii?Q?02TfFtlGiJ84UH+cOpOL/V/+tnV13sckn1T/yxLa534KyUto+mv6IQ4Iv48P?=
 =?us-ascii?Q?HXU1JlPjq1lBd+ZRI6k9+jqqqn5ykon/K4d4aO0sIitVZKuywSHLFfkZkHUf?=
 =?us-ascii?Q?gBiMd7dNQfdibV17vu4prAaqwoRV5lh/el7/ff6mVuyGBz3nBqwiaC/R8OtV?=
 =?us-ascii?Q?5E+kj1r2gong9aeIsXb9jrccB42jS09d59CoBHiFiq5g4XqFO0uwyyxO3VZl?=
 =?us-ascii?Q?ujWqvouJUZcDvu1Rd7as84oAx99h8waFzpqqWrmzslUOt0J2MiiGFRa9aVf/?=
 =?us-ascii?Q?9660IgVtcCFvECn/OlpIEcVKQ2Gvehe/i0a+e5Byj7gR/hqdCnRhWhJtvL9b?=
 =?us-ascii?Q?qNgkkve3osqLiUFML80ZDV1dgm/AA4jhYyEo6k0g6c7K/Ne4oEaklF9Rv5vk?=
 =?us-ascii?Q?Qtq/lVz9sRjErmEtEQ/Xn5vRe9VQeHN1dPiB8dkV3gP6mpYYiZx0BUOA7BUj?=
 =?us-ascii?Q?caicvtpgpK/rib6RdHe3enB925w1K9xXqLT29dVnkBMDSO3+jDgXRvmncNH1?=
 =?us-ascii?Q?5oxOBxrpaXdJRctjUKbbdrjX0/GqhkE5ZHHFbdo4OudhVjP+yZ67nup1UMhS?=
 =?us-ascii?Q?EdekdDdJdEVrB2hjqCWNt82wVpPt8x3J7YsxW7Nd25o/uF6GsKF5BwrZfLbU?=
 =?us-ascii?Q?7J54ghXNXIrdEu4QqpSBjrCZiEWC1IdV0JTdd+WlICxrvMdOPwh4JYIQlCco?=
 =?us-ascii?Q?C/zMjpgQeDdfeKCDTREZuQNt2AzjENgiHzTe40kqHVZb/6XLIVhiQYlc25GV?=
 =?us-ascii?Q?81zfjH0tqV27kedqUYvZIrfhFL423x1PW6W3ffPUMG9w+Q9qZNhOs2ZnalpJ?=
 =?us-ascii?Q?Ty+isrLPOeggahXbkVUL0aP3rFLrjSroSUeTGqH2//oa6tezVhyomxtF7vb6?=
 =?us-ascii?Q?cRFziSIB7mEYSSyj80pRZPDbufa38e9Y8IhPE6ybibrNwfwTewzgD2aPYOfd?=
 =?us-ascii?Q?s+vAx+ejxVSVeFgONRiuNpLIE1DJrK680VYaFyhUct6sU+UVC9hYcV6FEcVL?=
 =?us-ascii?Q?uU7LBwBbWA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	AzEJWQSfcU7WuRvzaJGmSib1DVCSWhzJEBEqFg9OoR7K5uvI/jrYS9x2qSzCwUQFgIDmT9gjKKtfo+cfBXdmZiVOAdq9GM9f5hgHqrifYABxviW9jjxwNvZbhOsVqCWhWrZLSRgl+4a4FOjBpkTENh+aRSoP2rL/uKwtO6co+aFZmQ8HGqihUIEP21VDccav4Z4OCEcDQXzG6rXik+TgTack0OrAwQ0X4Upo6vXUKFYQQGWw26HyB+79Y6Ud2hDRTD2rT8XE+W7XpaqqurD7b9k/ndokv5ihlYFKYuOLwAT3x0EuyukpR0EsY5LrAyIQlxLj0mhiHFFJbTIoPbVXFr+4zz6mcBER5W8zdXqSlyfFLpaGf8bOunvte6AGhmPAaSjInt38qDrHMbTtD19hq1Hwmd6uNoCWJJ6NH3c8qZHRZnHlTeVM7BegAJ5nKwg4wWXPhzz/6eiFpDnENQ+zTge3Xq2vF4Lb9SIgSWRayRMXVu8XFJY0dctjZMrCYnfkBbvdvB6FA44ZnUkUUoIclGCNmAluwU442oXi+LGmVUeC7QYkVCUgo0maG8FDTv4KW/S5X4N2vsM1q4jzQb+1+pN6XUohJqGJTxDoeA730wA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cb20472-b010-4f70-db9f-08de5981390f
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2026 06:41:07.9641
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ad1GbZI1ADeFXWABZfcL5bzlyTYhR7dKC/Iq2UOM3+WpaSQkwpPo+SZgFnuhUSlArsMBBacuuYO91OEL7q2OZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF5F5663669
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-21_04,2026-01-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 adultscore=0
 phishscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601220041
X-Authority-Analysis: v=2.4 cv=WbcBqkhX c=1 sm=1 tr=0 ts=6971c688 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=1XWaLZrsAAAA:8 a=yPCof4ZbAAAA:8 a=inOo-CydEO0l5Do93jIA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIyMDA0MiBTYWx0ZWRfX5rOnEMmpzUcF
 uFITeOL3f6mceVCSoFBuF0TUD6/jIfaSLxP/ugiq+EfTm+Aj0WckTcnYaVghxH9lT10lQHS6lP6
 GIz0188bFUTPxkffQyXYcLmxARJxI3+fO5w3YgseAM47bDoiLrAgwi+T/bBxo+MHdZHqCZex0QV
 55qbLngB6cQhgdVvdyPw1NSbFvUezFKM1E8fScPRXljbB4Z0MTDSEVjgBggORnxRsG28grwvkhr
 VavlP0PJ65Z/B2oOp+uYRbKIj5GrcvblhKZfrfbqqd1P2FdRhUn1vtG3sopc8c0Ne16SGAD+j6W
 /dgaD/t9MRxMAXw+FxuHA5cq0ucIuPLlVIHJm753nHZjmm8n9TrWw1/QXEySDdeOj9l9n6E57sp
 LxWJZHTeNt7W93Wv/mkft0YGC21K7xE5yUO1NTuhSl7rsOBNhyQLiL+5KXOEPNgJa8A7Jzksw7l
 eX+ScJSAOOWwnOjaGvw==
X-Proofpoint-ORIG-GUID: 9pLVWzg9bTltSnoja2dfmhO8iVkdB279
X-Proofpoint-GUID: 9pLVWzg9bTltSnoja2dfmhO8iVkdB279
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 07D23A0007
X-Stat-Signature: 6zt4mf3mt9f3xt5tcea45x7k19oe5kzc
X-Rspam-User: 
X-HE-Tag: 1769064080-667527
X-HE-Meta: U2FsdGVkX18ZFD6cTd+OzERDrtojaRFpRri6Vds+542tu2LDSFFgynmhMNK27sHYKoH0duTKZyG+b+WXJBj4UouWOXrIQI0iyu0qzjzMdW94W4DcS6LpBlC45qMaoeJNPOH8XQUDaf35/Ihv2OFeWxH/9t3lAvD5IyLVMcVCg0P4PJ72FIJHCiXKSxH5Yda3zvkHKyktzpF+ZpIpKGpS2NQBPRG6xvzDp4eLzt3ZFoRerpzwFgnlHQ21rVYesksiIXV3UBVrzU5ZTT+1CTIzzipMXbtC0a9kixgWq0Ku/NxGI5WmZT4P9cR5g2WzcvZNrKQYac34vuIrg1VHc681A2JV7Y6/T+BetL/Di5l5EKAewq+1uC5KVK+uukxTwd/sKfk2P+JyZj9BR7MhKsFUcZFB2geGM0ZUBjOVYW51BWbvutaA3itCDWccus2SH0doskieiNlXTcJGjpk3MF63tALQrf/5EmeOH7Q8gzlCOvSw9ors3bLfQgiQ+SeIbSK7PZ1TREuWky1n2w+lXMf5bQYelJUFYr8Q37mI+ezAURJwkVkVbUNHeXagfJ7vYpDc6lAPU2NpYqZKU/00eaFYdlu2v9dzWDdXmQcsxNfaPGXX251e79eXI6HK4ohoPG7ShLsmYCb0Ybxk6vPXnCCgjqdKulg7hGXr2MJfdwUeVJqmZUP0ooI3H9VM1xdKqLkaJgR40yT+CQuzx0FzkP5UWekYVnvHQ17hVZXSfxkOHH0gT9hqmYEp9iarUlaI0u6ynjo5BdUqA3ZysicG23h15nTBVhlfB7BF2WKmO5D8ZVjYa6bIJtjcs9GYpvnuT0hSlqmnBBVhNnPQBJjomyuDrL3AskndoajLFzjQjTaZj1aPb7mtRMv+byIY3nfsRVdNtkC0BRK3/fis2xl5xQkBElHAr5EpwzYXtgBgddKCK2rKv8p4bbbTHFW6jDMiSeu7ff/NqejT2UE+qBea9cg
 2O5l6+Du
 ee/2tbrS8oWqogvM7xtY3/Q1SQflvSTg+MPPIr6av99N87vMbqU6fnn/TISiByhjIPjJZm2izg0ilkIWQGs14TqCV7Im2jPXSfhv9xocaLmKyYM3J+P1N2kydrNHMeOtetzisw/OLwBHrks1OuaVMUVG4RY30Ik7buG8Vw91MJPyOvePCT/vLbqUPgSqju8mDqBffRgaRipBnHUFwz11ZKh5ZLQlgvTTRdsKDxjBw3Fmai+3ioGGR8CkD818XsWWJsLxSG4jmX2Azxci9AdbdcL4jcKG3CHedqBhIMTPH0FSkOPxZKZSFiE1JFLNZ+LKkq4d3uM6EJOOOJT0uMJD+CWJhzFw/LoI0CiE5ImVCdSOne4oOfj7rvBd/jzvmdLrSv14VuxCkRYSnOX08526mnqwPV+jX8hHg/dZowwaSKEm7uS3RrPYUGbALQA7/vWs/4KQUI885nEmhB+EDv8rIeYG3lEVOn8do0rUQ33bBmp3M4pS3gUubgoA1ZcQ3DS6THbR820X0+bBkOtG1VoIcETC9vixkPvFA/uDnuH6o+j5xlJxsm6tMJd3eJpJaM/Ztr5melWNHKM+hnDDvcQ4YwU5fRZ/4LWtpPMv9KtfuTNOMEBr4EaxaQOzhhAnBRl/k0eta38QdbAalhK84jw2EiL9vnvMJLN8CiISqzFGtMtoU48A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 03:40:38PM +0100, Vlastimil Babka wrote:
> The changes related to sheaves made the description of locking and other
> details outdated. Update it to reflect current state.
> 
> Also add a new copyright line due to major changes.
> 
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
> @@ -112,47 +123,46 @@
> + *   node->barn->lock (spinlock)
>   *
> - *   lockless fastpaths
> + *   Lockless freeing
> + *
> + *   Objects may have to be freed to their slabs when they are from a remote
> + *   node (where we want to avoid filling local sheaves with remote objects)
> + *   or when there are too many full sheaves. On architectures supporting
> + *   cmpxchg_double this is done by a lockless update of slab's freelist and
> + *   counters, otherwise slab_lock is taken. This only needs to take the
> + *   list_lock if it's a first free to a full slab, or when there are too many
> + *   fully free slabs and some need to be discarded.

nit: "or when a slab becomes empty after the free"?
because we don't check nr_partial before acquiring list_lock.

With that addressed,
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

-- 
Cheers,
Harry / Hyeonggon

