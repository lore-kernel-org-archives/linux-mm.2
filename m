Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCF29CAC592
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 18:44:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B44318E0005; Fri, 19 Sep 2025 14:44:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF50B8E0001; Fri, 19 Sep 2025 14:44:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BC778E0005; Fri, 19 Sep 2025 14:44:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8A71A8E0001
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 14:44:20 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 365B5590E8
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 18:44:20 +0000 (UTC)
X-FDA: 83906875080.25.E69AD0E
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf13.hostedemail.com (Postfix) with ESMTP id A3CD820010
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 18:44:16 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=cibjwB4f;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=BaHwe9eP;
	spf=pass (imf13.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758307456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MsJ0ouQS/JE/gbUAnZRgK++0noQ1ageXy2lUp3KX6dA=;
	b=ZMPuksBKxe+AoMSBNSAPcEaZdL4JEzztk6sDR2HavgtbAtF+rXban1kx2jLIpRNDvs34yx
	0HlNwEVAPNjpl9jaoT8/v7WDIqNYNw0RIvreObKUgzdEXnx+4/BurQ4tMeyr/dGr+7PmgT
	oneTFa/qoQ3BjLayw0rGi41AcGxgeBM=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=cibjwB4f;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=BaHwe9eP;
	spf=pass (imf13.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758307456; a=rsa-sha256;
	cv=pass;
	b=D6qBdu6L9pCcT1h+k1Gu1CzlTWDMgo/odvJ9D/jmq75m+Pwxdl28W66cCrpVlpQVXUMjeh
	au2oNso0ldH0LTxIxVxX3YYbRS959umWEqGlsBXy6Ajcbqc4HKII8p4dA4+4vs+L9bC9ha
	LXgA5VOui/LACcszVqfc2LakA4v8opc=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58JDuej9010099;
	Fri, 19 Sep 2025 18:44:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=MsJ0ouQS/JE/gbUAnZ
	RgK++0noQ1ageXy2lUp3KX6dA=; b=cibjwB4fzqFGmoaxvin1YDqaZw8NxwyOYk
	j1rL0crrIN0NN6r0QSQSEhTOj31AuKpTVl1PcHHkYexQuwI9KKOce4p+/wNQDgNn
	8vDp9Q4IBr5Sxrpv80VtGyNbw0q61W6Oe+j20uyaNlTjuiuK2nR5zHgnTRkSgQvc
	ROD+X+dudnwY5vXKrwYrsqLNIdQ9pqCdPQ2kbwZiCMSugzHTEJ0lNk8SD6FNrp9D
	r6HhH0Qs8siw3S21YaY0ArKPQiyhTg5EpYQWcvf7I0hmn2SnQCKTTs6aeJ4PTTYD
	HAdIUGKFPeE8mNbeMCG65CWsDshqSYQKjVSE7W4W4MEpGqmpMkNA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 497fxb64qc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 19 Sep 2025 18:44:05 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58JHLJck036750;
	Fri, 19 Sep 2025 18:44:00 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011070.outbound.protection.outlook.com [52.101.52.70])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 494y2gv0bc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 19 Sep 2025 18:44:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u3AFpA64HAMk/fcyTLnEZUQJJVnSUSFJf1KwJuvPnurL14TyXshKuVNnnla6Nqn8K+npA0xWsDSbR2whcjPfixv9pI1Jxnye9vbB9KeAY5g2x6mCOzxRLskSsKfzI+psydwoJNMbJNfzYTQZBsQAvn6w6jxJ3u2UV/ejubKbJBeSHih2MAhR8DfcchW+kBygrTkskJS9deu1pQagOS+RgV+VfcD82ESpTabQ2lkzePOfAmNAK85KlGzKMHbeYf8z4ctwM5hwMFy9oE/RmbAFMou2w8DEoSzSJi/JViYTBxcy38zjTth4qXrFNvP82R1Y8qvsnk5oZ3PogEbF1CEwhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MsJ0ouQS/JE/gbUAnZRgK++0noQ1ageXy2lUp3KX6dA=;
 b=Col68RcvXiVZaTnX4N9GNljlHb7vMFBTuNrUFqkWLTbZSD6DXC2fJOu82V8UN851Y8fX2F0K2y6PfcjygbETDylHtNWGvoenayhSUmJBjgcDF994fvzPB0IaUJTW6pFWnxUjVLsjv+Y6PdQw+eR5QHi0MhBKzYSojNSFJriVIiSZhuynHJoEi32T3l0rmzHIa1F2Y0sIHLNZkfSDEe1jv8Hb/8dRZr5cMJhhcHy7/MFS2uUqxpNCZV3tu/R7QcPgynafrLIFDip9dFWvHNpMllHHCigBPe9BIOqoF1wGLFNNE786cfr9OKa27uvs+PP53tfUQTBIi/U33Vz42eWFXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MsJ0ouQS/JE/gbUAnZRgK++0noQ1ageXy2lUp3KX6dA=;
 b=BaHwe9eP3ZSfclJsZhdA8WWNydZryRSDCfJJQkBzablTFBvmwpTsnAwNxJ88bcRb4MU0lT5ohIsSaZCpHkAVhXwaTLzECPKHPvYZbf1NU8pGAIZ+eSUKzUJKHoZ0NYbgsugKUd1RfOB1yuPB+dWi+7NyZREqZ8ZWRn4if4lhc4Q=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by PH8PR10MB6313.namprd10.prod.outlook.com (2603:10b6:510:1cc::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.23; Fri, 19 Sep
 2025 18:43:57 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9115.022; Fri, 19 Sep 2025
 18:43:57 +0000
Date: Fri, 19 Sep 2025 14:43:54 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Gladyshev Ilya <foxido@foxido.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, maple-tree@lists.infradead.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] maple: fix incorrect rewinding in
 mas_empty_area_rev
Message-ID: <gna74zdgw7ob5sa4jvcrgr35wbrbxibtxum7ysdkqdhetkiyiv@gzvdwxybeb25>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Gladyshev Ilya <foxido@foxido.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	maple-tree@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250918182544.1400748-1-foxido@foxido.dev>
 <4a72mtf5n4mzirudx3z2z6b72ropqs7f4kp2dlezkib4k5em56@hiw63iieahph>
 <76e0b252-ecbe-4d86-b210-79eb803e0fd7@foxido.dev>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <76e0b252-ecbe-4d86-b210-79eb803e0fd7@foxido.dev>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: MW4PR04CA0042.namprd04.prod.outlook.com
 (2603:10b6:303:6a::17) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|PH8PR10MB6313:EE_
X-MS-Office365-Filtering-Correlation-Id: aaf439a9-f004-412f-495e-08ddf7ac7deb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HBRf6xuGtF5ILx9ElXIxQn+rlTvh98iR0yjhfU+CWVT5KRDC39c2qzmUEzVK?=
 =?us-ascii?Q?dENp6n94cqzD91xFvoz3VOTkkc7ee/ROV/7BpH9UuFq4peySpEH3CqTpmw1m?=
 =?us-ascii?Q?wy2DV53w5SecA9VkY5d+8atEl0J4opRgjvyR+lexYP2X7Xqzxrg2Eav4Xh3j?=
 =?us-ascii?Q?qY48EhBdS8iJy9WR8wiQ9CHcP/JPDdzcgC7bc5qgNgYRVq32BhJDC9ZdI9uy?=
 =?us-ascii?Q?wJ1k+yq7xCeKBa4ij2s6S8RTx+VvmSXUnkTw3sdYh+B3BPg6/P6832B+cZ+u?=
 =?us-ascii?Q?hu5zmNkDEbcNJ2sajqR5d0txRjyMQBJG/WV0UoJcbc0nYfuXo7lMs/VKC37i?=
 =?us-ascii?Q?OQpdAvUlFzfPw12deBaBnYw96QfDegRMBMMUI/O1Ere5l76mo0jF+nrcXAkM?=
 =?us-ascii?Q?bQ8DhjLL/ah9hmv0IM9lsbK+yNfkJr8OmOGIS2GzW8hb6pVnkJqjet/G4nG8?=
 =?us-ascii?Q?TOomYW3x7/mrJpNWIhYDpoYMgLFheD0uPMmiIIgtAyx+J+rEgIXqO9AX0YnQ?=
 =?us-ascii?Q?MHdZl8Kgx4HnSacDjdUIyFGQVoXXF5vcrjuS+QL72oWDJ87Km3FDV5F5jNOs?=
 =?us-ascii?Q?QcYlIyO+aAr8DVJm7kYK3ukIXY8MorvzB40fSQHucgppK39TRs/fOPf28Ttp?=
 =?us-ascii?Q?0n68MzNKkpHqv8lB/5OMxXnpPRc2i/Kz0DrYp8Yaq84Ok+cJ0aBRjmmTHHYw?=
 =?us-ascii?Q?oav+0ipghzEzfnTGk4Q3sn+Lh6hBE11v1MlkH6M5RD4ttkigHFnCuCd1jtE2?=
 =?us-ascii?Q?CeBCggNOEjn9xPPdQ6xaUvRzqFQlk5/MQeLex+5q5kWsAZOP56EHFfZlgPBH?=
 =?us-ascii?Q?CvudU7DCRVFzz5IKVtLy6r2oYdTukumBam9uL9r1g4VtFu3Vb9qIRmhikFSh?=
 =?us-ascii?Q?Icm5/rv9wJBt7rrkdCEIeKVxjpm5bJoVnRmGMMCCc5sr4yQmBu/ESco5I8a/?=
 =?us-ascii?Q?cWtWebkJ+Y6Eqqj5RUTfgZNfFSQmSa7dNV5zDCzJQqoNJB0k+M/RwmPP83ix?=
 =?us-ascii?Q?VX7YKlWDE5cr8Q8nY2RpcArQigLN3HW28MQ2UgFxfx1hJUZQg85NCpmHOnZa?=
 =?us-ascii?Q?pEyQdPjplxQoXYJJL2HSDO4syGTGISkf79kDBv+kUcmtrsp/qnbcnQMDHJb6?=
 =?us-ascii?Q?3gXgTyktU8Q8tqK4ouwv28QzMfUEYrgPBK99bnfp3d0EFfXaeyBbiFi765x+?=
 =?us-ascii?Q?akb4tc86k27OLrQ9vc8mipIpUk8cO2lPwD6qAXWxqq9fLbxju/h8YH+LG0+2?=
 =?us-ascii?Q?yd57yvXZEnxhzZ7tNZa3fUmZVzEpaDkKBgtRNyBay4iK2TlD7OVRyES0O0LP?=
 =?us-ascii?Q?Fh9QDr6l7szhP3fRwd/+6V6468nnSPmKa00KepStbkZR2rmduJk8xpv0nP94?=
 =?us-ascii?Q?DT1tZ4ROfaPB8P9r/8Km1Gj5vgHkYcyX/82B/hi0dBK2ffN9Q1P3yaJUG6YB?=
 =?us-ascii?Q?mWZDkwvrE50=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?LJBL4H+bM4d2DMjMhcSiVFiDYvvo+WL3mQllsfyAGv3B3DQW2MEgL0YysSak?=
 =?us-ascii?Q?eE0bp+D3D3L6ptJpAym2+AOJARfVhGz7fzwT5Qm8XDw7BcTYy70Vfpb0FwkS?=
 =?us-ascii?Q?rYPFpyPeQeeiNIWHvz+/EmGx+I/cb0WlzoUFHMA0SbMdjDoIixlpYxuVeiGw?=
 =?us-ascii?Q?NoJ+0xyrXtLkTYW6T4HfEBG5BJ/AePSEsC7zuDTE0GQ8bZAbBo93hS8pZ7+T?=
 =?us-ascii?Q?VHSO7yjIBoNvPhCPj3auUcE1ZANnSqEzF+7yrdKvn7sBez2GtNJKVSAZnPp+?=
 =?us-ascii?Q?cQU8OmG+Ab5k+K9ii5n2hmypXqRwE2ii7DOoKbCQncPBDdNRPRaExhavg2KX?=
 =?us-ascii?Q?0ePudgm9om3/EAer1SKg97QYrdSVLdglgrDBHdVrDZA6t3Sr1e4QwqXA1Nxm?=
 =?us-ascii?Q?tQUdoLCmg6cf/vq3PI6iJq+n9ovXlqvQph4/B6I0XgZ09vq9dGbiNLV6VgiX?=
 =?us-ascii?Q?OCrh6GIPlLw25/+yqPt0DRZ/uCwTsgs69asNnpiX9di65F7iUpDtReBOQwYd?=
 =?us-ascii?Q?LrO0ONSdc4U4rpaeLXmCGO0TnLaMx961UqBMKUrXfpgiq0GCkUIlxyZYjr+7?=
 =?us-ascii?Q?RpEtCzMsfov7fSane5ogBmBK0QFe2jZWFuPr3fJ/h5G2qqQQk7CvtYR5pB+U?=
 =?us-ascii?Q?JXz5DudOufAjhy4ddJhHNHCqXsvYaxiBMZcAgpkyW/sfSRM3nBPcoZS7GHHE?=
 =?us-ascii?Q?lO0ZCrCsKjH9ges1P8NIP6fZqidqwHfV/Z/MP5/midHIwR9/OkUKNz3oMqKu?=
 =?us-ascii?Q?N2aGycF1EMnoqbgTdQMdUInQi5EolN2sZeU2pmH19Q1h0BdwIkdqPjBz8UyV?=
 =?us-ascii?Q?GK/qmZrftihZEh4xCAZd+sF1cSKHKf3mL0g4kVEGOghIhUFbpCpwhWY9LkVg?=
 =?us-ascii?Q?w8uNjJQ1w7FKRKV5tpHwRI6poIl92vr/KuQNoUvMLIbdIUg61lWsXu+kCZrb?=
 =?us-ascii?Q?NEfygCs6SQZKhCoN/dtO9lqTtt7qzZixAiGA8an0cRRVtkiyo24kLdQqsdJb?=
 =?us-ascii?Q?AD5uAvQEDtS3C1PpNXWWHjIXxDoB0XKIGJKLgxJGqRlK4MTBukYr38GXHfNh?=
 =?us-ascii?Q?THKCeTHH6KiykEbdHjNH1TEDsXzAzzdGpR0KTsnbAiwl9IqJ1oytlTI3be9b?=
 =?us-ascii?Q?06kok3+dITt74agZLTZ09P0f/Sd+Ah495sRhQKLMRyBOjXDho7j8ZsNed6xC?=
 =?us-ascii?Q?ThzE/Y9xGmcBOiPwBReZ3LZOzAGjBTwhbzorenL02FtLxmFe0Z/tPvjIRTlx?=
 =?us-ascii?Q?/UOTYPye8rAA5bMXj+UsjXvc82TrHUPwm+Mmq3NNnTDqtclYegNjVTKcF/pS?=
 =?us-ascii?Q?CGrhtjvrnUF+eosECAuLYIaq7ZyDOjuV1I3yYZtgf9xdUZabq2g6xBNC+yfe?=
 =?us-ascii?Q?QGwb/X6Ow+Ks7eSuqcICGb+eBcGopIzDX91LHPms+9iB4WZUSjIZtxTor0Xv?=
 =?us-ascii?Q?l9kJlEmaajR559lRgEGzbr0LThyXYlqYP1m8nXnaSMAVikCa6jHLPcVVABq4?=
 =?us-ascii?Q?ieXVgwuA2znHP+g/0W3JUrrEBd3QLfoyxWOkoelUKuek+Uu5Mxz1sf35chFv?=
 =?us-ascii?Q?9vue/77Esy+Bp5Da3wky1pMAnVXGawBSyZKaB2hd?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	gFabfPhYPx1aPZIIKq2awdUbtRi/KCxbvu+GvQwM/cXRa1oeW92dbQ8uWgN1kSJzSwLV59Dj6CUIpESJkKov7psxHC9PrlE9P6r60v1zD082Mk0RjSoUUavjv7SZqQhJ5tvOJG4tD2ojv+0C/TESkp1VQV+vuP9MSbAslGURKcPe/ZMVtoWCDaafoJSAT2SnKrEyjvhuZJXRujFYtesk4/33LZ2Q8s2SrsYyuapPUTERj6XRf8yOdjQp7UozWeczyfIvW0TgLGq3ngh+0IT3Le8u/7uoboDwDuXRlpQHia/qT3JXY6P2Ob4s7WQVqeR/yxLJzA9FdJiVAB0PYg4bIYfWjU6gwN9GIVy6r74uOfQGE8Xf0g6/yt3moD4o6VNa/tOQabMU1YLZtlLVrLtFQzO/wm1UIjtpQ3+gheRhENhuiZQvVfYST7r2Zd3MJgAb4KWKkqi0p+x1PGh6/tHYEgojKMy7uEMSRBDcYFM8o/HjaNj+aBAx4yIEvHiQphhH2oBDiebCzfEnf3M1/piWJfpyIuXaLGTNK6oazI6I+crnpJDWJoyt7PshOZoRwKEofCmTyAPrwoC+86G41qFk7DIW1U+bb1TJJ29rYq88FyU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aaf439a9-f004-412f-495e-08ddf7ac7deb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2025 18:43:57.7044
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wA2eLPxqb2Etk89rUVjbbz6p7RmrddQP+UG9YAUSirzQZsqeN2RDqT2Iihc42ZGNa4iLgIWKRqC5s+dF0+QIbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6313
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-19_02,2025-09-19_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 adultscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509190175
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwMiBTYWx0ZWRfX95z7DeaVtw0d
 tDzOdNNSBV+UeEjZwZXmauWc9cAVcJuIPyFJlSp3WAKK217v7BEgcRo3FW8cDNFRArrAdxQ7JHs
 Wpm6zynjSBH+IR/5c5608oESvG4Y4cFhIOId8PyrgboNMMFT9rdGYMkeGrInSjHmbtNp1nWcRVq
 bbEWwFCV6r79QY9PJ81gofKXteN7eLdrS3YH9PN4CO6/ya9AzDeORrJv+zEFTsfTt1362NvmAXp
 zuuke46OdYRHCWHXgLIbjdW730tJJ3fIsG3AxE0Pfz60eF1aiqYBpkG03UQyPwBuR+fgGfIiP5B
 Zk+xTZ/r9NG9vZLH9Ew62Yeh9u4WxqiddCGfMm/wIJdhIcjxFoflAk9S2GLDxRbYPbV4nk8nc4Z
 Kg6O9j8EDaQYkZmVbtNumA57p6SrOA==
X-Authority-Analysis: v=2.4 cv=KOJaDEFo c=1 sm=1 tr=0 ts=68cda475 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=Y__Fvv8fOEk4SHzWr8AA:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12084
X-Proofpoint-GUID: mvm6bPJjjjCfpj-u-7aZliuM4LJfBD5y
X-Proofpoint-ORIG-GUID: mvm6bPJjjjCfpj-u-7aZliuM4LJfBD5y
X-Rspamd-Queue-Id: A3CD820010
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: g77f6bbpxzm7zp9nxaynqg6gg99hb11k
X-HE-Tag: 1758307456-260881
X-HE-Meta: U2FsdGVkX1+FD4hk95Dy2otZLXWeOuQaLTSgY+n64eyj1K1Id/qL71+WCNFWKxcbhkR3YMfGu42+E+dEZfo8Oce97Sj0rzbiAbOj+yTlN1WPc2Dp3aA3husEsZ9n4ClNjwuInDGVK47iFSgSfd7DhPMBA27I7ufzf4HxbVM4ck8TOKE5+IfgfzLiuZ2r9FX05nNKlaGmhhk7TfSvFcHsrk4t243kkgqV2X6sUYx0tM5GEEBLOfWYA3V7qYMC/x/DULXUEwKw+E2g2Z+kXvGQ5NedfXSuDPSMWe857FnA85xZy+f8XvTuASVCochBV8ma0eY5xbOSIh7r8KNGLawwD8R9xcsa7KcuZSGOc6FVoVKn0F/Any7F2X3whVlYqTv8NJ1E+F4sIhWK4mucwP2kKeCM1RYznzASR7cqpnz14T0KpnclojiHSfCvaG3KVL2eO+k0BKIVV6WvwXv0FDaABHAgzIt2UQ+6j8pY2qKVRgnYfCfAaMux5n/nV82XMdijsmim3yMHVQi5YJlRhv8Iq2fSqa9ZsZUhE8ZP97mFBq5FbfV2e4QzjuFYnQ+v79X28qX+VUR6QlfLFsso0RCX4TAE8eRe1d4Vebfu/vlH4wFw8OqX7SjdQeMeJF10jZqOwls/F19HThZYEXwUC1tdcKC1UKOockMi4ls/6aoH9LHJ7nXEVZr25gV+VCA/7QgVCXpKYHgiHaPYr96QRjhP/t++Jn7tWOeq01QAUm/1RBA4NGdU8WLpncYvGxjvp+fQySkqfLfbWXZwAVVtlsaNyab1YabKp8y+czysXgioRfq8WL+j0HnJaom5UKZx9pDdpAJsTV2DF+oYlNcKOQUdW1tPMhqwQCydENgfT1VHWUFNLspnm5hoFaLG2bsWWd8oJyAm8zdO62rIxlAIQV4h1D8P3m46+cyjLrBv96hSlrUAA7kH/PEzyqG0jdyCBuMx5QRoGioycGnaLMLrxei
 jm9qLUo8
 x2UnjUbYgIRXfjEimVW/vWjwirZaGQXXBZG1VS6y4wGmchQK3NcdUIaCILQNixptb8+txvvH0/xtnFPXY9hCcq06rLsRqeQInuJd+KvX7MBUcodfxS9pWaVE82BVQ3CYFT51r+ZYWcODxYs7PzuqVDF9NGzclDX4SZTtzugqKU2lvgjwjy771Ns52JQzPAX0T9GvDHIiJPaCrYt82EpqKY/q4tbWP7pQXDdpi1PDHhTYMs3IVzX8cPUtqbjCR7Zja9nzn8taE/myUdz0bwowgLNT2+O05OdEo5cEUrL5iEodkPr9FtQlk82uy3A6Oh2arxeEY9ncTJOoFbXJ8QyMBERaRY/R52RQaTsEO4yvjFbK2Z8PZY/qiDuxfOOknOse+KevjCPmTiwfCIQWziP03Zj4Q1BulqfRP0Qpq7dbxI9nlhhS65gAlOGXOHAqjPoZuKvrW20q47YzB52cvOWATSIRCRP7MHbaRfgTAKsdhcQENCCL/v/pzl3dqHa6RgycmHuVXNBfdFY/RrveFHbx6wTNYM4OwNl2ZSTMEpUUjRHnRHds2zhM9ZCnLxz2Xm2IdhFZuxXv5B7KjFcmjIg93KC+vvp710K3WVatjofQlh9baBKFNT2+YV+Z26dfszbhQSfEma6y1D5nnsndQ7h1UMeuPk0r0e7TdTm7xabGCuBaW6cKxFDSCkEx2yGBM4sgdatw02bx7GlIq+3u21hbLp+l35/Z4Bf2QCK9rZESUo+VNS0utzRVI36+Iw15goub08HUABOH9c9iWv6Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Gladyshev Ilya <foxido@foxido.dev> [250919 13:14]:
> On 9/18/25 23:20, Liam R. Howlett wrote:
> 
> Sorry, I kinda overrushed with this patch and it turned out it wasn't
> complete. I apologize for that

Well, don't expect me to spend much time on this either, then.

Your testcases are wrong.  You are not using the interface correctly and
have broken the tree with this patch to pass an invalid test.

> 
> Below you can find new patch with regression tests. I'll ignore some of your
> comments (and some of them are fixed) for now, so we can find common ground
> about semantics of empty_area* functions and later, if it's really is a bug
> and not my misunderstanding, I will send v2 for review.
> 
> > * Gladyshev Ilya <foxido@foxido.dev> [250918 14:26]:
> >> Previously, mas_empty_area_rev was rewinding to the previous node if
> >> some offset was cached. This could lead to incorrect results because a
> >> useful gap could be skipped. However, this was never triggered in the
> >> kernel because mm subsystem calls mas_empty_area_rev on non cached mas.
> >
> > Can you please produce a test case, ideally in lib/test_maple_tree.c or
> > tools/testing/radix_tree/maple.c that triggers your issue?  I add all
> > new tests to one of these places so the error does not return.
> >
> > You can build maple in tools/testing/radix_tree/ and run it to run the
> > tests.
> >
> > It also helps understand the issue.
> >
> >>
> >> This patch unifies the rewind logic between mas_empty_area_rev and
> >> mas_empty_area, so they both rewind in their correct directions.
> >
> > How are these unified?  They are still different functions..?  What is
> > the correct direction, in your opinion?
> 
> For mas_empty_area we should move towards first slot, for mas_empty_area_rev
> we should move towards last slot. In both cases empty_area function will
> rescan last saved child / gap and won't miss anything.
> From 17707e1117a4d4be23f257c3b911c0a36f55b116 Mon Sep 17 00:00:00 2001
> From: Gladyshev Ilya <foxido@foxido.dev>
> Date: Fri, 19 Sep 2025 20:00:26 +0300
> Subject: [PATCH] maple: fix incorrect rewinding in empty_area functions
> 
> todo: full description
> Signed-off-by: Gladyshev Ilya <foxido@foxido.dev>
> ---
>  lib/maple_tree.c                 | 40 ++++++++++++++--------
>  tools/testing/radix-tree/maple.c | 57 ++++++++++++++++++++++++++++++++
>  2 files changed, 84 insertions(+), 13 deletions(-)
> 
> diff --git a/lib/maple_tree.c b/lib/maple_tree.c
> index b4ee2d29d7a9..3cc1596e231b 100644
> --- a/lib/maple_tree.c
> +++ b/lib/maple_tree.c
> @@ -4985,13 +4985,10 @@ static inline bool mas_rewind_node(struct ma_state
> *mas)
>   */
>  static inline bool mas_skip_node(struct ma_state *mas)
>  {
> -	if (mas_is_err(mas))
> -		return false;
> -
>  	do {
>  		if (mte_is_root(mas->node)) {
>  			if (mas->offset >= mas_data_end(mas)) {
> -				mas_set_err(mas, -EBUSY);
> +				mas->offset = mas_data_end(mas);
>  				return false;
>  			}
>  		} else {
> @@ -5003,6 +5000,22 @@ static inline bool mas_skip_node(struct ma_state
> *mas)
>  	return true;
>  }
> 
> +/*
> + * mas_skip_node_err() - Wraps mas_skip_node and errors if there is no next
> node
> + */
> +static inline bool mas_skip_node_err(struct ma_state *mas)
> +{
> +	if (mas_is_err(mas))
> +		return false;
> +
> +	if (!mas_skip_node(mas)) {
> +		mas_set_err(mas, -EBUSY);
> +		return false;
> +	}
> +
> +	return true;
> +}
> +
>  /*
>   * mas_awalk() - Allocation walk.  Search from low address to high, for a
> gap of
>   * @size
> @@ -5024,7 +5037,7 @@ static inline void mas_awalk(struct ma_state *mas,
> unsigned long size)
>  	 */
>  	while (!mas_is_err(mas) && !mas_anode_descend(mas, size)) {
>  		if (last == mas->node)
> -			mas_skip_node(mas);
> +			mas_skip_node_err(mas);
>  		else
>  			last = mas->node;
>  	}
> @@ -5089,8 +5102,8 @@ int mas_empty_area(struct ma_state *mas, unsigned long
> min,
>  		mas_start(mas);
>  	else if (mas->offset >= 2)
>  		mas->offset -= 2;
> -	else if (!mas_skip_node(mas))
> -		return -EBUSY;
> +	else
> +		mas_rewind_node(mas);
> 
>  	/* Empty set */
>  	if (mas_is_none(mas) || mas_is_ptr(mas))
> @@ -5128,7 +5141,7 @@ EXPORT_SYMBOL_GPL(mas_empty_area);
>  int mas_empty_area_rev(struct ma_state *mas, unsigned long min,
>  		unsigned long max, unsigned long size)
>  {
> -	struct maple_enode *last = mas->node;
> +	struct maple_enode *last;
> 
>  	if (min > max)
>  		return -EINVAL;
> @@ -5138,21 +5151,22 @@ int mas_empty_area_rev(struct ma_state *mas,
> unsigned long min,
> 
>  	if (mas_is_start(mas))
>  		mas_start(mas);
> -	else if ((mas->offset < 2) && (!mas_rewind_node(mas)))
> -		return -EBUSY;
> 
>  	if (unlikely(mas_is_none(mas) || mas_is_ptr(mas)))
>  		return mas_sparse_area(mas, min, max, size, false);
> -	else if (mas->offset >= 2)
> -		mas->offset -= 2;
> -	else
> +	else if (!mas->offset)
>  		mas->offset = mas_data_end(mas);
> +	else if (mas->offset <= mas_data_end(mas) - 2)
> +		mas->offset = mas->offset + 2;
> +	else
> +		mas_skip_node(mas);
> 
> 
>  	/* The start of the window can only be within these values. */
>  	mas->index = min;
>  	mas->last = max;
> 
> +	last = mas->node;
>  	while (!mas_rev_awalk(mas, size, &min, &max)) {
>  		if (last == mas->node) {
>  			if (!mas_rewind_node(mas))
> diff --git a/tools/testing/radix-tree/maple.c
> b/tools/testing/radix-tree/maple.c
> index 172700fb7784..bb424f94de1b 100644
> --- a/tools/testing/radix-tree/maple.c
> +++ b/tools/testing/radix-tree/maple.c
> @@ -36655,9 +36655,66 @@ static void test_spanning_store_regression(void)
>  	__mt_destroy(&tree);
>  }
> 
> +static void test_cached_empty_area_rev_regression(void)
> +{
> +	struct maple_tree tree = MTREE_INIT(&tree, MT_FLAGS_ALLOC_RANGE);
> +	MA_STATE(mas, &tree, 0, 0);
> +	void *const dataptr = (void *)0x13370;
> +
> +	for (int i = 1; i <= 10; ++i) {
> +		unsigned long start = i * 10000;
> +		unsigned long end = start + 1000;
> +		mas_set_range(&mas, start, end);
> +		mas_store_gfp(&mas, dataptr, GFP_KERNEL);
> +	}
> +
> +	/* NOTE: Still looks unneccecarry for me, but without it cached offset in
> mas::offset is too incorrect.
> +	 * Probably couldn't be allowed without disabling caching at all
> +	*/
> +	mas_reset(&mas);
> +
> +	for (int i = 1; i < 10; ++i) {
> +		/* NOTE: Wasn't working here without mas_reset */
> +		// mas_reset(&mas);
> +		mas_empty_area_rev(&mas, 0, 200000, 10);
> +		BUG_ON(mas.index != 199991);
> +	}
> +
> +	/* Cleanup. */
> +	__mt_destroy(&tree);
> +}
> +
> +static void test_cached_empty_area_regression(void)
> +{
> +	struct maple_tree tree = MTREE_INIT(&tree, MT_FLAGS_ALLOC_RANGE);
> +	MA_STATE(mas, &tree, 0, 0);
> +	void *const dataptr = (void *)0x13370;
> +
> +	for (int i = 1; i <= 10; ++i) {
> +		unsigned long start = i * 10000;
> +		unsigned long end = start + 1000;
> +		mas_set_range(&mas, start, end);
> +		mas_store_gfp(&mas, dataptr, GFP_KERNEL);
> +	}
> +
> +	mas_reset(&mas);
> +
> +	for (int i = 1; i < 10; ++i) {
> +		/* NOTE: Wasn't working here without mas_reset */
> +		// mas_reset(&mas);
> +		int res = mas_empty_area(&mas, 0, 200000, 10);
> +		BUG_ON(mas.index != 0);
> +		BUG_ON(res);
> +	}
> +
> +	/* Cleanup. */
> +	__mt_destroy(&tree);
> +}
>  static void regression_tests(void)
>  {
>  	test_spanning_store_regression();
> +	test_cached_empty_area_regression();
> +	test_cached_empty_area_rev_regression();
>  }
> 
>  void maple_tree_tests(void)
> 
> base-commit: cbf658dd09419f1ef9de11b9604e950bdd5c170b
> -- 
> 2.51.0
> 

