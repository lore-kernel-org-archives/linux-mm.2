Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E61B2CCD184
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 01:21:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D60748E0005; Sun, 12 Oct 2025 21:21:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D115E8E0002; Sun, 12 Oct 2025 21:21:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD8DE8E0005; Sun, 12 Oct 2025 21:21:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A880B8E0002
	for <linux-mm@kvack.org>; Sun, 12 Oct 2025 21:21:57 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2444085EB5
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 01:21:57 +0000 (UTC)
X-FDA: 83991339474.21.406D597
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf15.hostedemail.com (Postfix) with ESMTP id A2C3EA0008
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 01:21:53 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Lqn2y+XI;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Z8ojp4Zo;
	spf=pass (imf15.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760318513;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EezXqBigUNt6xNZa3fdUrMi455TZqbdzzh2DgZvTqiY=;
	b=Od9ssHcgE6KOTJvBSx9g4oI5terdW7U/5d8poRnWKynynNnGDB4XcoOq6VXn34ISP3N1O0
	0ZViBj+3i31bzVAOvUOPbFH0WYe3T51cwN4c1CShGe18/dO7IVLipNMouqw/fOBUA+Bmnf
	INIfFwkrz10m8Uab1GgQdP2s8kqMwQA=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Lqn2y+XI;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Z8ojp4Zo;
	spf=pass (imf15.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760318513; a=rsa-sha256;
	cv=pass;
	b=kBX/frkyHtkAnA3XADL9Sgt5x4MlNkTK7T9x54/Y0CthDbPsYPJf5lx4zJgZwv70GqIoa1
	/RtksxacXkq1puH3+HFIigf8BOChuzUqQrDQuYs4jsZEOdmm3CxNdlUxcyjIc8qSozlmME
	2TxESHJ3MWhPtLd2d05+3RXhUNCo+2o=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59D09SEe026849;
	Mon, 13 Oct 2025 01:21:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=EezXqBigUNt6xNZa3f
	dUrMi455TZqbdzzh2DgZvTqiY=; b=Lqn2y+XIHZUoBXQbScPDP5+8F9Fhhl+R5A
	DODO+W1Rzyowysi9YilzOaoQgTjmMEeO/oFdsosCWsLoRZXicl9W7QDKKUriU3HT
	Bu/cwO2sBG3wkutNLAdIqUCSSWIzEJsamElpIpcv1fjwL6mwamUeU5QTrP9axoOT
	qn/IR930NuSl5tGl+Ao02H6NIVGyf5c+l7QSn9WzQpOcIFzZ58SJszX7l+PwEcru
	oVWBSUPbKaiggwteNIfp8fGPlqP8chmaX6nMojDMFwdCUG3gr3wLZmY+UBq3Ahgp
	6bEmHn0FdPMrcG3iuAEP5IjqFj+CgHU7AtM9UH9jd4byKyxF6WxQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49qdtyhc7q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Oct 2025 01:21:50 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59CMKTpo027279;
	Mon, 13 Oct 2025 01:21:49 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010065.outbound.protection.outlook.com [52.101.56.65])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49qdp6pc1t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Oct 2025 01:21:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YU/zchX61VXKfUR/TDdwVqpI+3qRR6PIlbYzy1xej2yS76A/r6rup+8fv6Y9D7llKEAJaxgrVrQcSW2LYaBgtrMvycYpxbgB7d/+22bsPwsQeEGLYZ6ec7FdJhND+HTFf8n4xMlCICJH7QhlJcVEiYErsuVVIpq+RqRxqi2u+6nZBsrWw6fT+ncOGAtqSQvJ37RIzdZkHIybzmv78sKKQfn5AMf4XQtZusVy//DoDrpPMjKmVPvoxYjroYLBN/7mVTLxprfLp93NWShSwWjO1bFJLIDnHRY4x5hp886bTRD5drm8T2fJGMUvfTR3Q8Cq94UTcix+4jJfnaYuHqK1OA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EezXqBigUNt6xNZa3fdUrMi455TZqbdzzh2DgZvTqiY=;
 b=LhYKEAOedVibWbgwTbg7nk5sQFqrtv5Y8JXHd4Vr0qH98LsUA97Pc+3z/G6qj7gUtlEVvNB1HuBBR/Ac8fjBlLYkzs2sQGXiFKep+BfTCQYLsT1U1ryay8Kz5PT/uECFT6M4TWH1zAvIwBaf5uRbJxhk6/welAKk5KOaOjrw5e3ez6iXQ3p/jIjRbAJeByeKEfyQfwOi5Zvnk06tRvA7HcFTupmEHNtLgkci4z2PfcDyzH3rLoR3ssvm3ntnLRB1eAqGeXTYVB8t873JagjR3kxWzuuz3FUjKAM1K+ocoyz2zd9lAXaSsVy14RE4gBCqVO2ITIZgLfsu4JBVfFJ8jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EezXqBigUNt6xNZa3fdUrMi455TZqbdzzh2DgZvTqiY=;
 b=Z8ojp4Zo6zWcgWc/6haVVI/48HrvbPaCSdDVy9IdM5OtKelQehg9FAy3XnNuswFofc2l+wLnuDlU0EqbW6hdt9CVXwNymgQ1KIkwPKEjbceSbZhvIh51wf6JG6//aj9z1xu3Y+h4C9bGos1zX9AHqikRObOPA5tKy+k3ZCw5Z8g=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by PH7PR10MB5772.namprd10.prod.outlook.com (2603:10b6:510:130::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.12; Mon, 13 Oct
 2025 01:21:46 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%4]) with mapi id 15.20.9203.009; Mon, 13 Oct 2025
 01:21:46 +0000
Date: Mon, 13 Oct 2025 10:21:36 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Phil Auld <pauld@redhat.com>
Subject: Re: [PATCH] slab: fix barn NULL pointer dereference on memoryless
 nodes
Message-ID: <aOxUIDOuOSI743sR@hyeyoo>
References: <20251011-null-barn-fix-v1-1-5fe5af5b8fd8@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251011-null-barn-fix-v1-1-5fe5af5b8fd8@suse.cz>
X-ClientProxiedBy: SL2PR03CA0021.apcprd03.prod.outlook.com
 (2603:1096:100:55::33) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|PH7PR10MB5772:EE_
X-MS-Office365-Filtering-Correlation-Id: 065c9a9b-dd77-464e-1ff4-08de09f6dfd6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Xw62JzEHbebIZY3AiNelb800v8+a1n0Hdw35rA2YECNW5r1iln4NRbPB41Il?=
 =?us-ascii?Q?aZrJFvga8oRULxRg4vg/XQjF6xqJMumCa3h1cWTMfT8XTzUkzQxigr9qkcBR?=
 =?us-ascii?Q?Fnyl5Emhbhs/F1gG/9WOSieZMN5emEEbcmLndp1LxdaamfUTK06iy4FDA/PC?=
 =?us-ascii?Q?waatTB+3TIDVt2IJpDf3v46UHk8ecrTzUR08Vohaczcx3dy+bitigBQ9yqKA?=
 =?us-ascii?Q?wHrreavOsQDh3fMdxBSqyJOs3LDZ8z28vSCnNwEQbO8VTsi43i38MaSfzY9v?=
 =?us-ascii?Q?k3KJxN+mWP8fntyhsfLDp0BHL8HZD1ve1pT9qoiE/WGEEheA80pdp+YgyTnj?=
 =?us-ascii?Q?0HjQIieTPkvDimYPP2hbPP+HirgMzW+z/fq4OaeE6rNFbhmmax/cZ9VfK52w?=
 =?us-ascii?Q?LQWVWxxPdIPk+5PqTlykaGxMbeG/uAaJrneM0GXRIGtlpfoRKuI+/Kx3jpFm?=
 =?us-ascii?Q?XG/f8UIxMhinPO5q10gqoVn71A2FjUhoiqGAB3ZExk3DvuFREMpgLWNExBFO?=
 =?us-ascii?Q?6pWpf+iujqk2uLMrfTAx5APOUacxOUzaEgcEjyuafaSBpvCZ00THrJm2vA08?=
 =?us-ascii?Q?rlPx4udjk/Oy8KHvgTC3NK6oHu5If99EwBSKO2pjNPJUdiDtg3oeOta6ioO+?=
 =?us-ascii?Q?uGFyUuS/fOtRS/Jr8alXA5RPPyTaFZF2R6AQUmquXz+1vFV8eLn5NEZqVEt8?=
 =?us-ascii?Q?LYSGtN+Nlda46kP0aNA9nCYwzCoRhHx32Uc2cn2pV0iNCGpPiX1UXOFZlVHZ?=
 =?us-ascii?Q?dyhemGWSVgnEjFZAU8tB6ONrSXS5K4zajQfV5WOtvsFsq9gEkFDsmbgWSpMf?=
 =?us-ascii?Q?uO6mhmGRPdimP6uM9pZEbp1sXFqIaOVDPNXz5ffduwSxxRQutS3BgNjPMYrx?=
 =?us-ascii?Q?Qxv9TlnLmwvvoup9cyQeqcdk12hkrj9FX6Xi0weFx6trCYg2CymxRfLOfLGr?=
 =?us-ascii?Q?3ZX9rHzOoD7Ermg9zd3KZH94Grekc3b7i5Iw1+hsE9rMNE3P2nXpgeDT6SEc?=
 =?us-ascii?Q?GwseS0nZVtn9qu7d75lpmFflqLfdDj77yFOQhI7XQAmIbQO8IZztnH+Qcd+6?=
 =?us-ascii?Q?ebzDORPur7hkSxUnq7F+F+fjYhrBuErww3gGuKupqL3cAqvBiXEQhC6WcugD?=
 =?us-ascii?Q?x5EwvWcJxyHduuLIPPxRZ4ARPx37R77xbJyrserAvwdmSr4Y329m7RjcVF2x?=
 =?us-ascii?Q?Dbci+JV+7X17SQiyGIjPzZboacWpVwAbyDjLbCnh2wMFGo262qYRFudL6mm6?=
 =?us-ascii?Q?JXbGHD5KtAE64NiTl1H84EFYSkg3zWQyscp5a91dcBMD8P4McUQ2y0h7D07r?=
 =?us-ascii?Q?0yYGu6bDQgKtt0BGm3anK6Dla6sf+o9JSxoVruCPa0oY7QvwW1OcrJxXTMJJ?=
 =?us-ascii?Q?uV190GRRSjlXvT+0QwGVTNCrjzuK029lwu3CCU6dQXm/4eIM3siesaiDhl12?=
 =?us-ascii?Q?b/6tq8bkSEC5aUlT3LhGR2Mdc40r3WUvvcV8wVHHQDm5HLc3ilip3g=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?L+UBmaVd7e1a/De0XBr1LqK9w3V1T7J/j+kaqj+dIla2ixZETSysVcUNTlMp?=
 =?us-ascii?Q?dXtH57Mx7j8Sg721RpkUrz16XONFnZNdwIfD+qu/k4aaOrK4nrEiZsMDH8Lm?=
 =?us-ascii?Q?fjrmgdLjrwfNdrBsnNhZv4/UczfwI4elVxCDCFkhjtPAScytlW69LmSMb2Vu?=
 =?us-ascii?Q?vow2fCwVg7S81JV4DyVRrhJ3vfudOvTMrJQX7oRvvwTn66a3CYXeDYcSU6mm?=
 =?us-ascii?Q?la09AypQ96vzzSeF2FNtxyWYYYFRXA4LXL2egH2BDF5L2oi6TXYawzBb+Avf?=
 =?us-ascii?Q?1UD+WUjTiU1tPDlWw3iea2WrZLZtL3YP5Cw44lxHKeHUBiTgi5KgsJjnLZvP?=
 =?us-ascii?Q?Hwrd+CPVnEklrwslAjOvVP+jsksPqe/1u9EycgsbJtAqbuddZtveB/PoT3oB?=
 =?us-ascii?Q?Zu4Zhj24U83kh04b2uY+2lRBmCHWFB2Ab5PD6qYIDwwevHR7ifyp6rhSMLgI?=
 =?us-ascii?Q?xjRpC7myrbIEAL2wCGd1emP45Z2thVwnUYluFUmjzRJedOnWQ7u3WViidJuy?=
 =?us-ascii?Q?59mITwikAvWC5Cw3ORPi846Q7w1waH34cRze0DuOEeGcxz6YjSJQ8i3Q61GL?=
 =?us-ascii?Q?+tLHqtulsXcU6tkAECD5+AbpsLKSyR0jdEB/+jFdbQhpxqncy4vVe6R/Qklb?=
 =?us-ascii?Q?2INX+5UBFZEGLI3yR5kGN4HEtlQanGQbMYCkJIdiJNItG+ABQFC2OH9j9m8c?=
 =?us-ascii?Q?2uNO1uVoQ0xl0uYf7fcTpLhk3qiYPBtuIS4eNqp8bMgi4kNbvG9zIgj7Q/gH?=
 =?us-ascii?Q?Zwk904/VI23MpMi69N3i9Dl+nI9y0tE7IZQvuifoOSCGEzu2ClUzX8c2xKc8?=
 =?us-ascii?Q?lSlA8LHEf1ZtX4cVL2HEz5HQItSQuskolosFNQdu04tUByIGgltmHd8j0v3a?=
 =?us-ascii?Q?FMjLtIhC9AexmJHO21WrwIjkdYvoYPcw7s+0pWLC0TYMQUgJarSKiupIeaQG?=
 =?us-ascii?Q?G8z7eNb5eYFik8/lJ98CuTrQu4YLXAJoRHVsj364apv62rEQ8zcFgBp/y3EA?=
 =?us-ascii?Q?JpOpnayv3Jc9xCOJjQdD4boIJDWMz1sVW1EAVLvS+9f8Z/08y3PinrPG87kQ?=
 =?us-ascii?Q?ECfMNoFLXavsObPs7JOgYTJYkYChBmgF5qYWWI4LtsIUwWCPHDp8pS7I4nI7?=
 =?us-ascii?Q?q3yjx5x2RKMQEOvIwQ9XVMluKUBQh8/alGAxXtx6znGyQvHyTuk/udb+J3Ij?=
 =?us-ascii?Q?faybcpk/HqeKYanfgsSLfJ9DRaJb0XQEYEa8FwtPxC6Ysm1xXcSQL98oRfjr?=
 =?us-ascii?Q?N0Jhojg2tbhjO1nUmp/+avxV+Z03odtb9mkXWiFL8spwW8OLUm9WQgxh8DDq?=
 =?us-ascii?Q?wB6G8Ek8N29WQY6pFzJDr9hglF23rM5/r/IFdwEUNBwLcYtE/peQg65RPSu8?=
 =?us-ascii?Q?9k+vRsC9je7nd7VrmFN0Yict0SnaJLmB9O864ou8gNhb9NmWcoJ8c6SMXqv0?=
 =?us-ascii?Q?dsH/cjw5/lawTZ9ijhMhyT81P3T+Q5eagkbLv7xL2pRmWGb35kCSlSVuSG+N?=
 =?us-ascii?Q?njKQqhTWr0ICOQmv5sNHBfmuN8khYtY+l7rFTmSjQ6/JdNlfqYjO405CoqBZ?=
 =?us-ascii?Q?P1nrQ8aDYOsOWEoEYBAmCU8ZOTf9/9Fd+q8aJNqD?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	g74+/Zl6m7m0dai19rqDnqvVKtL73hOe0trOYfSMMX1z7JxPE4xmJd4m2m4TWCQ1CmuyxW/XNhpF0mlKSfi1iuhMMv5XbLXS1XJZUrUc0cdRJVMS8btTHZSCJzomoiiTptP3x2kbjzOIWby4X5fMifKNxVrYr/zPjpcKzG0Y760VaUggNhduL0eRcAHco4POrdZoHH19WFkvZH+124hzh52hApwvKTqsjOwKBPQ+loUYVZ/nKVn83XE9Jv5WGxfXXfLD9rYyZH83AFKpqzjGEQ5MQWOsPAIXbki9wuYht/bYeV0Pc9V/dqZ02gp9d7JVa1+Vky4iHR6Ml6TgJZ9SBvU4cUSre+21LtKGwkaswpuqLT1KInM4rUvGDs1/bHnVBRclTciuofkzSGhYTNN8lwWhJra7GkyMqzWRhr37M6OnzXd8nWc6lzZso3EIb84C+DbUIyWxE3Xim8H5DQEAchLemYnTPbpW4+UQ854oSts1nINAYL4LuexPT3DDIykYn+8VGq+KktZEvm9smLmziCZ/zLCiwaDqG8gvg40iNNp00yPzRKs6GnfqRbn6hSqcojLBXCJbegt9qTTACby4f0D4U04CZoQS4UeUZ81ndPY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 065c9a9b-dd77-464e-1ff4-08de09f6dfd6
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2025 01:21:45.9092
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RSBCMX1jwnwl18nxGAHep2a/RMlRuTkay8MYsIOaB6nMiF/UIYeGu5L03uMUUP1oKQN+YjSLNt1AmHMMb38jIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5772
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-13_01,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 phishscore=0 mlxlogscore=999 spamscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510130004
X-Proofpoint-GUID: Va40xJt6yDDEWlNLy662xflJPcGHTr_Q
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDExMDAwNyBTYWx0ZWRfX0tmyZoiMWxK/
 gxdugjvntrjVelVFKGRgGjSNNXJNgmCLJrFmRxAIIaBsi0nvlsbBj5jfm8/VzsKG4xmAAq8pYio
 qPYeXtmdBjKOld6Rz+Ud3mz13WO8r3RaH2NFuCGqhyW9Yf1OdkCec467pxrJL6X5UDUIzvzuL80
 OVflTB+goV44rzdoGX9CIsx4zaZ7RywRj6rxnznwnTjbd9QIN2ECniMAs+2BNwc0VnI+D2ftfeh
 4w0nfngx3iEe3ScwX7q0fI8nlEoWTwD+6XqIvXqdzTl/4RloECPD81ogQ8yB1QWEPZWL7c1UCXf
 Eam7jHOJ4glS5zUbOSbH2YCDpO3h4IpFrD5NFrCmq39fQMJPvKbSrhdz5DWJA3HK/mDl3d6vt7q
 jnZV1pVW5WTDe8yVD09kOXekFQXAV6gwkiqONgRcFGXAEP7UplQ=
X-Authority-Analysis: v=2.4 cv=OolCCi/t c=1 sm=1 tr=0 ts=68ec542e b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8
 a=20KFwNOVAAAA:8 a=Z4Rwk6OoAAAA:8 a=yPCof4ZbAAAA:8 a=xkoXuRbA0vtoeeWqcK4A:9
 a=CjuIK1q_8ugA:10 a=HkZW87K1Qel5hWWM3VKY:22 cc=ntf awl=host:13624
X-Proofpoint-ORIG-GUID: Va40xJt6yDDEWlNLy662xflJPcGHTr_Q
X-Stat-Signature: sfza5ko55z5igrou8751iz4rntma4txn
X-Rspamd-Queue-Id: A2C3EA0008
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760318513-352982
X-HE-Meta: U2FsdGVkX18VDcbmwAirag8wXEsCEbwaySryYvS2G0+PoynVAXCrw57IWhERZMXfJNZAcBSGX1urzc9iPEENVCZW6aCu9Jjx0wS0mbiRr6HjBUJwIfLBGq+66yu1kHQm8oDj/2m7Dorr0sz5Dfw4euN5Vj01P7FxSycmDT90CxoHqX0KX8SUovsPH1pWEE+9q7ATDoIrmlaF+SrmuEEutsWKgknmtjVmtsda+7TYB2GdCzImlYyfmpGjT+IjZymebjamQgfjYrPqsevzZSPDQOPRu/DH3OlfwMVLcMME7cKO5vbfHEJz8qZsgvQoZEJB+4gmmiiurZil8dr3aaBzB0P39j6qF3ImEHVKmtuC5SBu/BDd1RTmH1oPC1GnbBPs1JzI8O/Lpe/nb7U+5VPfwRkSHS9L3W+2j221/oJPbQE1JaoA55opIRfzkbXQD2Mrlq+tiMLrkfaWn1J0IFTQvcIriT/jH6V+Ayx/ADkbuAplHyj/oXJvb0tdyVITbgLFbE5TSLemQQFVAGdQ4Pctjt2VbypbO497hYtM3g7G6Hw3foT01Auf7uOMK+tKFHc9KNYuhxyi1gl7T5+hG2b8biMo9Vw6IErqVSBzRC/jkuewyz9KAXKZT3PlLH1zcEGdC8C9iGWLlTAS6Zi+oUoOvuVFtz10kjjAFh90rrE7Klwtz/zcJGlwS45WHxj9gZ5MWZ356d/7LSeJ/5F99jP2I18jbepD5UiXod/kwIh7jouhb0s94lXSAB4sVhpD0ImzPUkjKwz2oVFCT429wjsm2hxItyF+Inuv/idY/bq7bqLU4EMeVIq9oTT99oc03PQkajCGPs2iTyELN9Zot53roeoUeKiBBaUvam0O3bq7GENyb299Q7uNielxyeL9GW6Bdr+gn2WqbTn3uRzhczBHVe+gUwbD0oBvw8+Gfd2eBI4DBI7A1A0aOymG9UZBUyGx+yj82DcZSGbrb8o5wTV
 srvD2lZc
 5ZFC6JwyfxyOpTZGSEV3yrlnBEWIR11flrsgORiF9Qne7dQ8sRtLsaI8WIJ0+Vblf7JmW9OJsvQPuRpq7ndkRS2TWR7BsLJQCd1ZFDZzBRg4S0oafsw7E6/nmALk3/Nl2nffixvAqCZiWI04J1512qjDUCxosM3pURlI/qfT9zf597R0LL5JBMorMirJbqDxvNSB/DhpwS2MGrcUmCYyAEmUcTkBptwvkrVPYqq7PK2QMQdVqnjOslgcP/I27WPZfyGX5KmYVcCYc90YIsGTnWclTwcHUj8mvCoGWiQDv+vaAMoil5sp/CKPZL1kHLrQNvqjisht+gHuNVvSd51i90N3HWjTAKQ2yFbWogCDuSwf09HAMfLBYNUAIoKgbXGkkDbe+H+Egxs3alvkEoVMRiH7NoT9UsnGD7gzQYMaZy+TKGnhplGLnMVwF8YXsr+Zpf60BbVpT9/gT6zSqXeg9t2j1/mFmwNbAkoxsEXb1+SJQazrB3iYrAv7wE6TA6qAuTMNa7oMq9Vi9EqFlSFbu4Usu+oVyt44ubzQb4MqePXa5E28Fr9rZOUDc0Us7uK2RKUqrOGjtuV+yqTxWp79IX6nKutHKRasP1HCLqDuAjgSt5C0K7aQh/eFLHw/ho7dQPRn7iKDylrDlCSJIqfb95cmUyCpYq1VnS4TPuI5SHWuCswu17pn/8CsdPyjCZJQBA2O+DDMD/glXZbKG/MmsXFqLv5MV/kb/4wM96tpxprOK7Q+blVa/HYusBguOvTNr4MXFV0+9EVgj2f15Eu5+zTWdlU9D2K/vftijEM2IoO+s+7nQwig0Xwix5A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 11, 2025 at 10:45:41AM +0200, Vlastimil Babka wrote:
> Phil reported a boot failure once sheaves become used in commits
> 59faa4da7cd4 ("maple_tree: use percpu sheaves for maple_node_cache") and
> 3accabda4da1 ("mm, vma: use percpu sheaves for vm_area_struct cache"):
> 
>  BUG: kernel NULL pointer dereference, address: 0000000000000040
>  #PF: supervisor read access in kernel mode
>  #PF: error_code(0x0000) - not-present page
>  PGD 0 P4D 0
>  Oops: Oops: 0000 [#1] SMP NOPTI
>  CPU: 21 UID: 0 PID: 818 Comm: kworker/u398:0 Not tainted 6.17.0-rc3.slab+ #5 PREEMPT(voluntary)
>  Hardware name: Dell Inc. PowerEdge R7425/02MJ3T, BIOS 1.26.0 07/30/2025
>  RIP: 0010:__pcs_replace_empty_main+0x44/0x1d0
>  Code: ec 08 48 8b 46 10 48 8b 76 08 48 85 c0 74 0b 8b 48 18 85 c9 0f 85 e5 00 00 00 65 48 63 05 e4 ee 50 02 49 8b 84 c6 e0 00 00 00 <4c> 8b 68 40 4c 89 ef e8 b0 81 ff ff 48 89 c5 48 85 c0 74 1d 48 89
>  RSP: 0018:ffffd2d10950bdb0 EFLAGS: 00010246
>  RAX: 0000000000000000 RBX: ffff8a775dab74b0 RCX: 00000000ffffffff
>  RDX: 0000000000000cc0 RSI: ffff8a6800804000 RDI: ffff8a680004e300
>  RBP: ffffd2d10950be40 R08: 0000000000000060 R09: ffffffffb9367388
>  R10: 00000000000149e8 R11: ffff8a6f87a38000 R12: 0000000000000cc0
>  R13: 0000000000000cc0 R14: ffff8a680004e300 R15: 00000000000000c0
>  FS:  0000000000000000(0000) GS:ffff8a77a3541000(0000) knlGS:0000000000000000
>  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  CR2: 0000000000000040 CR3: 0000000e1aa24000 CR4: 00000000003506f0
>  Call Trace:
>   <TASK>
>   ? srso_return_thunk+0x5/0x5f
>   ? vm_area_alloc+0x1e/0x60
>   kmem_cache_alloc_noprof+0x4ec/0x5b0
>   vm_area_alloc+0x1e/0x60
>   create_init_stack_vma+0x26/0x210
>   alloc_bprm+0x139/0x200
>   kernel_execve+0x4a/0x140
>   call_usermodehelper_exec_async+0xd0/0x190
>   ? __pfx_call_usermodehelper_exec_async+0x10/0x10
>   ret_from_fork+0xf0/0x110
>   ? __pfx_call_usermodehelper_exec_async+0x10/0x10
>   ret_from_fork_asm+0x1a/0x30
>   </TASK>
>  Modules linked in:
>  CR2: 0000000000000040
>  ---[ end trace 0000000000000000 ]---
>  RIP: 0010:__pcs_replace_empty_main+0x44/0x1d0
>  Code: ec 08 48 8b 46 10 48 8b 76 08 48 85 c0 74 0b 8b 48 18 85 c9 0f 85 e5 00 00 00 65 48 63 05 e4 ee 50 02 49 8b 84 c6 e0 00 00 00 <4c> 8b 68 40 4c 89 ef e8 b0 81 ff ff 48 89 c5 48 85 c0 74 1d 48 89
>  RSP: 0018:ffffd2d10950bdb0 EFLAGS: 00010246
>  RAX: 0000000000000000 RBX: ffff8a775dab74b0 RCX: 00000000ffffffff
>  RDX: 0000000000000cc0 RSI: ffff8a6800804000 RDI: ffff8a680004e300
>  RBP: ffffd2d10950be40 R08: 0000000000000060 R09: ffffffffb9367388
>  R10: 00000000000149e8 R11: ffff8a6f87a38000 R12: 0000000000000cc0
>  R13: 0000000000000cc0 R14: ffff8a680004e300 R15: 00000000000000c0
>  FS:  0000000000000000(0000) GS:ffff8a77a3541000(0000) knlGS:0000000000000000
>  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  CR2: 0000000000000040 CR3: 0000000e1aa24000 CR4: 00000000003506f0
>  Kernel panic - not syncing: Fatal exception
>  Kernel Offset: 0x36a00000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
>  ---[ end Kernel panic - not syncing: Fatal exception ]---
> 
> And noted "this is an AMD EPYC 7401 with 8 NUMA nodes configured such
> that memory is only on 2 of them."
> 
>  # numactl --hardware
>  available: 8 nodes (0-7)
>  node 0 cpus: 0 8 16 24 32 40 48 56 64 72 80 88
>  node 0 size: 0 MB
>  node 0 free: 0 MB
>  node 1 cpus: 2 10 18 26 34 42 50 58 66 74 82 90
>  node 1 size: 31584 MB
>  node 1 free: 30397 MB
>  node 2 cpus: 4 12 20 28 36 44 52 60 68 76 84 92
>  node 2 size: 0 MB
>  node 2 free: 0 MB
>  node 3 cpus: 6 14 22 30 38 46 54 62 70 78 86 94
>  node 3 size: 0 MB
>  node 3 free: 0 MB
>  node 4 cpus: 1 9 17 25 33 41 49 57 65 73 81 89
>  node 4 size: 0 MB
>  node 4 free: 0 MB
>  node 5 cpus: 3 11 19 27 35 43 51 59 67 75 83 91
>  node 5 size: 32214 MB
>  node 5 free: 31625 MB
>  node 6 cpus: 5 13 21 29 37 45 53 61 69 77 85 93
>  node 6 size: 0 MB
>  node 6 free: 0 MB
>  node 7 cpus: 7 15 23 31 39 47 55 63 71 79 87 95
>  node 7 size: 0 MB
>  node 7 free: 0 MB
> 
> Linus decoded the stacktrace to get_barn() and get_node() and determined
> that kmem_cache->node[numa_mem_id()] is NULL.
> 
> The problem is due to a wrong assumption that memoryless nodes only
> exist on systems with CONFIG_HAVE_MEMORYLESS_NODES, where numa_mem_id()
> points to the nearest node that has memory. SLUB has been allocating its
> kmem_cache_node structures only on nodes with memory and so it does with
> struct node_barn.

Right, even without CONFIG_HAVE_MEMORYLESS_NODES, some nodes may not
have N_MEMORY state (and thus no s->node[nid] allocated) if there's
no memory attached to them.

> For kmem_cache_node, get_partial_node() checks if get_node() result is
> not NULL, which I assumed was for protection from a bogus node id passed
> to kmalloc_node() but apparently it's also for systems where
> numa_mem_id() (used when no specific node is given) might return a
> memoryless node.
> 
> Fix the sheaves code the same way by checking the result of get_node()
> and bailing out if it's NULL. Note that cpus on such memoryless nodes
> will have degraded sheaves performance, which can be improved later,
> preferably by making numa_mem_id() work properly on such systems.
>
> Fixes: 2d517aa09bbc ("slab: add opt-in caching layer of percpu sheaves")
> Reported-and-tested-by: Phil Auld <pauld@redhat.com>
> Closes: https://lore.kernel.org/all/20251010151116.GA436967@pauld.westford.csb/
> Analyzed-by: Linus Torvalds <torvalds@linux-foundation.org>
> Link: https://lore.kernel.org/all/CAHk-*3Dwg1xK*2BBr*3DFJ5QipVhzCvq7uQVPt5Prze6HDhQQ*3DQD_BcQ@mail.gmail.com/
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---

Looks good to me,
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

-- 
Cheers,
Harry / Hyeonggon

