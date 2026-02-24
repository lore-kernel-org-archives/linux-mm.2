Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09227F357AD
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 14:26:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AD866B0088; Tue, 24 Feb 2026 09:26:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65B306B008C; Tue, 24 Feb 2026 09:26:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E84F6B0092; Tue, 24 Feb 2026 09:26:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3A8176B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 09:26:36 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BF82D1B5699
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 14:26:35 +0000 (UTC)
X-FDA: 84479575950.24.1DE40D0
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf15.hostedemail.com (Postfix) with ESMTP id 63842A0016
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 14:26:32 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="RPsw5/FD";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=fZRnNOFs;
	spf=pass (imf15.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771943192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cpQa9BJ2p8e8nRBiycis8vNmNY1mqZwx2exeRl0FVX8=;
	b=Rtbcr9fSh9mVeIQTLuFjhQmEqxlY1gV46ens3NIl77jiAAHav07kT7gFss6PQ1xkomHKfi
	2BZz7wnlIBfI6y7UaaDxAVLsZWhHBuj54knyrlr42bXRAB1YQcq+5whXtx5a8wWGekepWn
	V202KvDCpfY6p9pm9MfW0eZwIIEBBPs=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="RPsw5/FD";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=fZRnNOFs;
	spf=pass (imf15.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771943192; a=rsa-sha256;
	cv=pass;
	b=OxFJ4GXKN66VIKQhRaUzDanm/oGJ4vLa45yOrzy35eGkPyy+ID5qcZdyaJD88iM+aIKy/9
	e4NtfuIag+MDw0OEwOU54ihQIR8V7kmsextgINkecDRN9oIJm3lDhndNdypUPrPyETYnax
	M2hRTSItbaZW5sEIKkPeJY6mFrBsxqg=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61OEMpSt087128;
	Tue, 24 Feb 2026 14:26:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=cpQa9BJ2p8e8nRBiyc
	is8vNmNY1mqZwx2exeRl0FVX8=; b=RPsw5/FDhP9kRP8S7uB5iqIGxUmRKqMFLs
	GEEZdmKJN+xGXKW5KTyqIwEWoFpnCetu5OR3xAsLdBtN//g17Q591c+9hlRcQCbl
	Pigs4FDg697S7DY4ZUTDNVyTsILxxPHLfCNb+HcuYb8Sx5229LCUrFR5lBUbcGXU
	i7R7jQiWadvP7PWjNmFzrNhQnSmB+N1+E/PSo+OS3O/bwev7vRO81w/NbtPsZKTO
	z5O61JWmK3HFRMD5J/xUt6Bh3E/zG+uqENXtSudMN5W7ow4+tE84gL76UjTtYtYy
	0hzWI1X7iC6VuuQOibFbrmhxtwREoORjMN1B+sCXIUsfjtXAGXfQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf3g3mbu4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Feb 2026 14:26:25 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61ODjPJu028514;
	Tue, 24 Feb 2026 14:26:25 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013040.outbound.protection.outlook.com [40.93.201.40])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cf359rwy5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Feb 2026 14:26:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mnvF+l1Xmg8Jj5oOI4aofAv/rjFXl0B7Isi0tJjWVQz4iMdJNnl5XYUQJjmS6Q5z8hTcCGck1hiCns307eO+Uiai0CIQSpO+0i8es40FZkjpNgAcrF36iKLixyul2SiFI9fmzV0+1tNL9rLsdykbDEn0I3DZvbqbMfQUepjxUnjQttuKdHo1xR1kdLC9j8yf9b2lTizFYGimUY+n1R2/8CTC/rrrX0lllOeNN/l97zw0bvvrnJHVxBcuUmAQwOJmTKZ7hJdHSMLEUUf7833/tpQ+7bgx3s/PwAPP7KybMcGLw91hiyZNhKAUGUF09y9+EqRhjT1AzWWVb37LjLVs/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cpQa9BJ2p8e8nRBiycis8vNmNY1mqZwx2exeRl0FVX8=;
 b=rme09TvPIDwVH7B6CWM0Sqhz9mEqchOOPyDzLuKl7vsHLPEL1iwzoifzhKr/He9i6P/ViwU17KbhFZd3VvpARe6F32N8a8JzVvOYX9LM2Nd7bLnZt4dQbA068ra6iROHLZsPDrCwapBlPoDpGB8JsGQspzDY2yfS2SqtNxj1qeTyAWJPNkf22GxD/8Cwpl3JdNsb5g0ScVrZADdUGaa7eyMXLF+qvVDUARAOVU3/v3TeFTuNVj7Q24MUQsyZ7VeF5nbf6zPsr4M/IpoUbI+VjFbOVw3JdPMRBFIR23IG5U5feRuRnbPgUC3R5s7nDHq/EoYuuQ2aYrmdHNG+l3fEhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cpQa9BJ2p8e8nRBiycis8vNmNY1mqZwx2exeRl0FVX8=;
 b=fZRnNOFsYmP+vx9jXqqjThcv5WvXjkNoCb0ohLOWjIzWjvKJIc+fi2r6L1ijo59pb3dhW/eHadr6HR5rn4QPFIkOJsKlYO26HQfOyxn3ueOxd3VgMqdxLFBCuNAPzY+HZgZ961kpcmNCuWqyPA1fkvTn9ySK/+q6EsQiP5/p4lw=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by CO1PR10MB4723.namprd10.prod.outlook.com (2603:10b6:303:9c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.17; Tue, 24 Feb
 2026 14:26:21 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9632.017; Tue, 24 Feb 2026
 14:26:21 +0000
Date: Tue, 24 Feb 2026 23:26:16 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: David Wang <00107082@163.com>, Vlastimil Babka <vbabka@suse.com>,
        vbabka@suse.cz, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [7.0-rc1] codetag: kernel warning "alloc_tag was not set" during
 boot
Message-ID: <aZ21CP0d-RRAjUCX@hyeyoo>
References: <20260223155128.3849-1-00107082@163.com>
 <6ca5f70c-43c5-4ba3-bdc4-8c48607dbe7c@suse.com>
 <37bbaa9.1831.19c8d7a2cac.Coremail.00107082@163.com>
 <CAJuCfpEsykCarj6_k5T9EeLDfsA0fFL182g1hQ+tb-7EM=izsw@mail.gmail.com>
 <aZ2yrEz2ZVggT7UL@hyeyoo>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZ2yrEz2ZVggT7UL@hyeyoo>
X-ClientProxiedBy: SEWP216CA0083.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2bc::8) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|CO1PR10MB4723:EE_
X-MS-Office365-Filtering-Correlation-Id: c2138cf1-286c-4eb5-bb0f-08de73b0ae51
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?V6cru307O+BxBo+qvfaVmhSCtfZXljm/zA0Hk40ZT9ay77/3yzwqK73AngnC?=
 =?us-ascii?Q?FSZ6lM+Z+38+0OW0yuzszrXpSIHnkLaCUy1a7H08Rc0j+5NrVjnXmGw0Zc1U?=
 =?us-ascii?Q?+8MtvEvhjGrOOqfXp7xVlrg357pSSwYVbetAR059r1eI3ri+Cel7Adv1Bk9+?=
 =?us-ascii?Q?nf45jGfTesIocdftOr7Gv67oqI/rn23Z2MzdV3sXQA7SRA7RatLhT8ZUef+5?=
 =?us-ascii?Q?HMrKhXGdcBcbwlekhj/9RsYrL3waVRi93sirWlM92UUOzuE/txDNi2k11Cu/?=
 =?us-ascii?Q?JFgD0VzzRrnK5e7NLwM8qaqDEvd2IpU7/s2A7q62IOTQisDNuuhvc+JExOqd?=
 =?us-ascii?Q?PrcI0BIx+RuP5eg9h2f0q0lL4U9rPf8I/XM49l+F6IbL4zzS4Rpxk7jwM029?=
 =?us-ascii?Q?GtXwKBes6Tsqr34o3jbIpgQRL9PRL6eKiPVn5ioB1u+0Sjr/+S9qoJhCzJFZ?=
 =?us-ascii?Q?LJcuV4w74i2aOKYvs2mlpP8oEuPf0wjA9lRpueMD34vMAPi9T9XOn9e2uIPp?=
 =?us-ascii?Q?j7q0h3D2IZS1oTcOuYXeR/V6K0qrOye+pyWO1/ahZDCQYaBgJdQjIPJoVc0y?=
 =?us-ascii?Q?d/iHdlV3lEi91qLl5XqhEBAfC0wOGigZZwQOKfNgK9qHO2Zd9c98pQs6PVfJ?=
 =?us-ascii?Q?cTvCn/BfHWU/FOADZAVwHjVVdCK0uqbJ0pBb5OTawAC90HZkNC0iqf8SQaV+?=
 =?us-ascii?Q?oa8lSPD0QqtRsy8hMFVKNnZYWVQ+/EnbjX2DJyf8MEYsaiHTUhquYUsxsQvL?=
 =?us-ascii?Q?fE9j4jJWEf1jd9r3DD5AUJ6s1l2VSpuh7r8ZvBJUJcct8qUYMq6FN0fnNpc6?=
 =?us-ascii?Q?XNFQjt5VbuzfONUHwx3Or+XoeyjV9tpFvppSNarhFramqI9N9gr0fyhl5PLv?=
 =?us-ascii?Q?EMGtC3FnAPMgK3gZkbUH1fZxZyx+r4FoQAVTg2Nl1dhdy9j6i/QvUkDZpsPy?=
 =?us-ascii?Q?0t5p6sp1yKMYH9hM8u9Qrp5i3+JhifXJIgCavxu8eQvm7673QzC0Y2paP30o?=
 =?us-ascii?Q?cLNq//tfdUu1ev5Mrn17uo0zvrwqtI9DsyqOCbBQyibqhqrkRp0b030g42jG?=
 =?us-ascii?Q?iVUkAtUd442wGG9jj6uKZZE9RLXGtn2yc7045MTBJYHHoQKowFItHX1kZTBj?=
 =?us-ascii?Q?bdBF6CuWno0OpuaI2LZSj0B0jq7DjjAjCt0xKPManIgt+G41QavYHzXju4ez?=
 =?us-ascii?Q?Z3899hYH2bmzFvDxEzYfcTDr27Ojgx9FNi0YekiFqFT5fCMoCnEOT8xlJ9gm?=
 =?us-ascii?Q?4ip6J54k8GDOYThkLVQPTYgPQlaUwhh9bxaCD643S9SFuAtXKO9xPbCrDlvF?=
 =?us-ascii?Q?I68qpShdynHXFPgQ+Y6IyhDv62eR33B24sWwAj7DGvE8hgjJHwjnl+UABy7k?=
 =?us-ascii?Q?pyRUEupJydQYWn72R1C2JuuE97hmQqYQVnEFdayhxwUvVT2p1IrL0TvBF6Dq?=
 =?us-ascii?Q?pwKrAp0MRjBqcoiGCa7JoWSP6J6Df+2NflFMSz5k8WlvJmtdEN+ucNHl4vko?=
 =?us-ascii?Q?Ru3g8Upy4cS4BQpPOcSFJMnb6NUi2hb2RJRSbtI1FbNeHg45WsFY5XMBgQFg?=
 =?us-ascii?Q?fmguh1aaGp2lcH60UeY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?AD7oKOpaEdw9RhlnGloKdiMD14DTlutNz/n9eTlMPrIJb9k3hpBS54ZIlbxi?=
 =?us-ascii?Q?mr7p0Q/ctqaZKuKEMa2l92uC+pDpFO2u11vG3Q0ZgehMiXqMdIyBlJvYv75B?=
 =?us-ascii?Q?LSjncT+b35OnswL0IH4CzfvGiq55eZR6pF3+x4zQ6pzUHIYQDnmrAqwTi2M4?=
 =?us-ascii?Q?JZPGFfuAIypyoLX15F/mWnwVTkIz+oZYB7Pa0CGAdh9cTFXyoPZzF+n4JW+H?=
 =?us-ascii?Q?R26R4yCnjFjvtHoqT+g8oZRk+vVSR2QPlhGWK2VpP1HAFXmdROd8mfbA6hiu?=
 =?us-ascii?Q?hzWtWM9+frYidG09y1X2D3d3jngrhAkjJvjayK7KjOg4Bn5IB1kS+F3ViLik?=
 =?us-ascii?Q?fo5zWO9nGpwYf05qMkZiLe14UaSYZVYTRHiVaggknaIt3+lxlG4aCIUgDItH?=
 =?us-ascii?Q?rJQZ05kYiBWJ0AJez6gh1cQDzwpD4vhg4WBV4OfEfzWJnoZ1eU/5np77e52r?=
 =?us-ascii?Q?iH9EWqx3RYCv7ekjLpPMIeQjJzSv+66Ox9BCrVxUPFXN2WgWkHddVS+9uSU4?=
 =?us-ascii?Q?jVJS1iNKohgbJXZw365qAh+Y/w43t6p8o5tDUBKeHNYMga9VVmqPa7KV6TN6?=
 =?us-ascii?Q?9NNg2qfpxGQn73Bvwi5f3Rfd+fW2Wh4+HP3wCKOuKgIAtPqyNHUA1OKpIv5b?=
 =?us-ascii?Q?pCg7lY/wuKktRZYaM6Pq395yh4bavvdNZ9XfBWIB34Q5pyBX4YAWGwCwf33r?=
 =?us-ascii?Q?GXpI5ThVvPdngM10t4Ykrw327LrvYEesuq2m1Pmd6oaPvEWeDs55SJXL36hy?=
 =?us-ascii?Q?oRsHGVcy9Aq//qh6DwFVv++CZV+oMQtQHz6XbVWopTnGLia/1A03GvbFoXWQ?=
 =?us-ascii?Q?rNdN/UgjLa+3MTQHQZ+eazAh/SEvNq/YVrtYAR8y5gjygWKcTOnxb8wqh1iI?=
 =?us-ascii?Q?7vDRYNwHfX3hxgXbbolUxg2dhr70JIYhDMzPWCsgplfLyVYJIv9dIo2xu4bZ?=
 =?us-ascii?Q?EmLI/jhivM+toLW6yEXCFu3y7suKXe5fIUPel3qM3porAjb37Yk+8/ZqxnzZ?=
 =?us-ascii?Q?PZzbHUweiwKV7OrbjIRwUdYPVAez7sByeaMoYxYIh8fxnTUkq5/lI8oY0YzO?=
 =?us-ascii?Q?dP00RXi9BE231KRBqP49R0KiOCXXHbEUVyvJbcS9J60a2fIwyVMYliUNuFjF?=
 =?us-ascii?Q?wLTMJxM8KWBP2JAMUNv7Tf8E6FndbLVO/c6q0eVqmwpQniSbFq9KLVoN/XyK?=
 =?us-ascii?Q?1z7m3RcndSZmXv8Sbkcf3zkC11oV4Db5x0EQp99a80J32zSutBxUytGZ6144?=
 =?us-ascii?Q?ZaxQ/qM8e2/LbHDRFvvXt/zGcYbVSgE3UakYZtAepjfZ437l8R2eMoIVBEKZ?=
 =?us-ascii?Q?z3OkYqYvDGVnhXR1/P3C4X1dfhvrQDvZoaj1ZK0ERHIQODFkx2Q+RynYxjLj?=
 =?us-ascii?Q?SqqvH4X/eht3KcrRmwcIaL3VkuN8LZNdaYqUoyuDtaOEYXzaOkDXbXpJddf5?=
 =?us-ascii?Q?fyMmaIMlFF6kL/YGyz0Yk4ee8vp3d8jMCrBNzwcq3Ys+fBC2smNqfvLKlz+7?=
 =?us-ascii?Q?uBCdn+qobQu2sjjbUbHqRApjYFhb04t/f8FSfBADTTPvVkltR0SLEi0QUFIF?=
 =?us-ascii?Q?CSw0FIoSoz/QYSn1qStsT5geQnktP2CXB+376vh9CZVyab3oGmhHzBSaaOv3?=
 =?us-ascii?Q?G4EochXoJi68mo0TF97DRgvFxV7218Ul4d1JW+CSsNNbsF6h2LktuCivLac6?=
 =?us-ascii?Q?KAh2RsN/m0/JI8D7Wl+Gq+usWmw5x8Jd3b+/HOSKjUvyrjSEDmJff6jb3Mak?=
 =?us-ascii?Q?wcSMJgFiQA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	r/JaZa2PoIRF/bi7Nxhyk/+Z+TYIkiHt9SfK/IfbNLL4o+eWOPuEXjOji8JC7WkKHrNtlViBMe3r7/ereaZjv9zowXpsNVHYj74LRsRduThBjTHtf7uMm+zwIsFqUSXqZcrhQmqEhPqBATD2Du1sU/y8U+ATsgs1kXMI7HmXI63NvdOHCzAGMFo0aC/YDg8rIEVEj2B1/Dq6y/87TgggZli5rSgJuFDlBO0pni8it04FomERAAOyxe2VpFe58Le5/9Gxw7EnT4b9HhuyK9vSnEWuRNHQCdj/UXOr8EtMYtWLonPSQNE01xkYpT4LPVK/Lyg3GN/dlNTeoxoodtMBj7HPQLjKygNweMKRXDbkPDjk+AF5wFCGZ/s1FmeJjGOJnkANiRLZynUGLq6i44rnJWzKH5w6mOPi7BvUq2nHVm5cLN3s7DQfFiFxLbAoaPstDmtOW0naB4+0oTKJoxCG4bOMiy31k0W0pmtfi1hjbcYvM5wiY4RjzohFzEYMlD8udQ8K5fZKCsDGgLd9YlzoN/gsWkEJh4hNU9PjJImcqKxvRcPJ3C1Wbcc0LCtiCIsLZxHSX73yIJJtAnZx8Fn7b0GhBhA66K98mt3Xx96dIDA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2138cf1-286c-4eb5-bb0f-08de73b0ae51
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2026 14:26:21.0587
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xUTuatQbvxo+jUOuHOY7F6D35ssuCtYnm/MNlS23GaGx0bDIZdwAKk2/IRGdRtWnEXkdO0zy1WoukQ9qoGZLJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4723
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-24_02,2026-02-23_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 malwarescore=0
 mlxscore=0 suspectscore=0 bulkscore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602240118
X-Authority-Analysis: v=2.4 cv=Y6r1cxeN c=1 sm=1 tr=0 ts=699db512 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=kF5L51yoLD6jj29ABkYA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: ZWKloSKwTFMSXgZZGqSsnRUieKPqOnE2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI0MDExOCBTYWx0ZWRfXzqh7LbOQMyOn
 k62hmnBDhahM8jWRRwWO00Wg9Je1Q8Vauj32GgzVsinytpanj+BOYmMWMhkYH0xNuwA3i/XVW5V
 1S32OdlyEpKMi9Q/3dUpvGFS91Rtt3f8Vd+yILISIwA8/ha/RSdkjLUir+zyxbjjagmCgzgHEqL
 RCeqJ5eHK5BTfEWO5SvY3zk9wCR1L3mq4LhXvjlvyWq882z1kpdyqFxS28cM6IHURk9s0rZr6f7
 dCXdP9Qa8cg/IUykrNkhez2YecnbtRO/R9ovByCk7GWP2o9h6x6cqhUodR5AnB7jMJbKHsDO2NB
 suybJmLLjEzA6ylW30zV4qGG5fP0CUcTSR9yb9LJR3NdE3geMjeSW5hW21D4LTRWzxLY8P5DsQT
 /sxocyUK6xSur3UE7Kbk2i/dbowDhOvreaYRnOmxmnN6eJ86mDFLBVijqa5Arf9/tOlhQikAI6n
 rxUkY+bZWqG0yt3v89A==
X-Proofpoint-GUID: ZWKloSKwTFMSXgZZGqSsnRUieKPqOnE2
X-Stat-Signature: njca6sab8pryssdq3kyd3aff6ftfuyr1
X-Rspam-User: 
X-Rspamd-Queue-Id: 63842A0016
X-Rspamd-Server: rspam01
X-HE-Tag: 1771943192-598083
X-HE-Meta: U2FsdGVkX19bRNL5g863ke9T32j9lfmNXAwcnW5MHj97rSvr99hFObnQEfVU01lvBg5qWcCWYjhjJiYCdi+ljGoU6wunDf7Sztsv/QcuxgasxHvGn0SIHHSTPp9asUn8HR6kTKQGLcVoFUqJ4bzBFJtdPNf6MoNfdr0sJVBwpbq+Ppo93pE2NPzgFK6aOh3WQ0e3qB24vO580qW9HCMpmHvitnGBDUMPuw0UiGIuL/AMoVEPQjoiZdQoEBuibV4T1oM2/hSZ9ZbubAgwgEPx2yH2o29ukmt0Zw7BPLnEaX44eTZa7/flEQPbgLizlprQiCRpD0SnG+LjpEDpX3vwaositcN503P0ej3ct8VGIrHRI1Sl0iW/mVVymM3rFvDdQ6PO6T2G0W/XEaH9tFZQkGUNVxWnShw2vS6VBfAGFJE4m5Pyzq+YTfKa+38JYqcvUZ4d/HfF2r6N6VOMwAopuIDwbrmX0l8ReWpLmUohmAJIgkAyyYwyb7HGrfLXS+/SsMKu9Frcan2e/7Vj/dHJi4JDBhLc4J1lnQrEo9SF7nAcmxGTrRAX7y1uOogy37yQfUDncU1/VmHKAJVI6wLgjETZjzoGadL0F77t1iCF8HV/R3SYUTeDZu8OuXpCRZH3euEIFUZlJ+KnVEx56ptKiA4Zwq4TCac7m7hP/iheW6rijnApE46EHi8l8Zu5xOys393xz90S0t+LZj4P2itb2mgYFi61F/vE3ITMw1I6T+pLusWKK2u3M427fL62qlRY6djhodHDrKczvzKYxufMK/xMf7ndB1wJrOhNKi9POjoRm4kTX58ldgtq990VFHhbGAy/tJLgqKv+QuydzxQftzzFNtHIgDilmVk5AMNC3q82oPPu4X4VM8YL8XQAtyaEmpz9O9UUDbb3IF0/eRTKl0W+8MZu63ZlGZfU4mVKryW/bq2Vq+W9Hby9NolYp1B7+fqsVSvvRWBsK7HxAR2
 bs03z1z1
 sorzzBXwSJVn+BDt/5NRafC4UDf6WUFVRMNpkeOIv3h/nhDyVxBjMq5ZyFbn9sWffLzKyBq1yoN7fywvAGoqt9fXGzBaKqoChZ5AmrjkUsLJhazrH9htESrdqgu6GxN/3jqR1A9ldoSOKvfMJIHxvEvEA36cI/3WbT0oYLtTGhO5viM1toDDpNzOEJtFx7RoFNLBu0xgN/3SUOLVGfLOqe1soLWaj753Hk9U/NAS69y5YA+hCBfecrLVU1XWBZZ27GOGFfbdItOSE33fHRIMZXLy/9xuoWMpA3mzs9V2u4j3w3snWc2YnaJ7KpQtXZf7h66e3kBSMUZ9zTvceFGGN+l5oj5Z8G+iHG33ug7twM+LHspkhnlfj/VJgO5+njestXP9MYf/pm1SjcMTB2d5i3V0PbxDjav9puJ23IRw/PuvFJe/db5xJL9twXafSdhqkL+By/eHhbhKp0fWR+6GspEREpVxXiBH5JOfn5DusZJO345y1IDCVaaimP54aE8piLvNjObUP1e+g0TEkZtU9zhoz1DLI4kzTMuxQEmpnNQRwsxcEnPWufwLrZciHz6FKX9ahXcFE/pcb2FUBvUXr4SW9rt2zg1lNY5fl9ahYLzOUZyfY7gs4gXAksAi4va3W7Wqgcc5QMm9yaQ99ovfM0y5KzUN2AA6pWip+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 24, 2026 at 11:16:12PM +0900, Harry Yoo wrote:
> Just sharing updates on this before going to bed...
> 
> I was able to reproduce it on my machine I have a working fix
> (nowhere close to upstream quality, though)
> 
> The reason why we're seeing "alloc_tag not was set" is
> because SLUB allocates empty sheaves for kmalloc
> with __GFP_NO_OBJ_EXT and it doesn't teach memory profiling
> how to handle this when such sheaves are freed.
> 
> When __GFP_NO_OBJ_EXT is used in alloc_slab_obj_exts(), it later
> avoids this "alloc_tag was not set" warning by marking alloc_tags
> empty in free_slab_obj_exts(), just before freeing obj_exts.
> 
> And we don't handle this when allocating freeing sheaves
> that were allocated with __GFP_NO_OBJ_EXT.
> 
> Passing __GFP_NO_OBJ_EXT skips 1) allocation of obj_exts,
> and 2) alloc_tag_add() even when obj_exts is already allocated,
> and this confuses memory profiling later.
> 
> I'm adding the fix I have now. (I guess Suren might have some preference
> on how to solve it though)
> 
>   1. mark obj_exts allocation failure when slab has no obj_exts and
>      gfp flag has __GFP_NO_OBJ_EXT, so that a later obj_exts allocation
>      will mark alloc_tags empty.
> 
>   2. Set alloc_tag when obj_exts is allocated available,
>      even when __GFP_NO_OBJ_EXT is set.
> 
>      Because it's already allocated, we don't have to worry about
>      recursive allocation.

Wait, isn't it much simpler to just do mark_objexts_empty(sheaf);
just before freeing sheaves, if s->flags has SLAB_KMALLOC?

/me goes to bed anyway

-- 
Cheers,
Harry / Hyeonggon

