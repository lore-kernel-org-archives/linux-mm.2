Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EAC6D1950D
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 17:37:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85EBC6B0092; Mon, 26 Jan 2026 12:37:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 840576B0095; Mon, 26 Jan 2026 12:37:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EE656B0096; Mon, 26 Jan 2026 12:37:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5A3666B0092
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 12:37:37 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F034C8C5C5
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 17:37:36 +0000 (UTC)
X-FDA: 84374822112.16.B7C9DDF
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7EC234000E
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 17:37:33 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=i4DdWi1D;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=LOAE9EBV;
	spf=pass (imf27.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769449053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dc0WeDPRM87LNXvHSdEgBezXKYiA00X0/T3zEZgb67Q=;
	b=nIKNcaN0VXUsRAGC8ec6Cb3wOlUuNwtvjLweBSUd6az/smEwduhl8qZbWTBAxgGM6aern0
	QXaWrTYX2rx2cmIKcbTwA5ue98S7cHYnSJxqU0BqvNYCnZ6fI2khRcG+9shZuOyR2qVUo0
	dn2/8X3QkkO2TZodDcWorY0TJCDRKuk=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=i4DdWi1D;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=LOAE9EBV;
	spf=pass (imf27.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769449053; a=rsa-sha256;
	cv=pass;
	b=iJM+P3dLRKzTOuZqcpo20ilF4PSAxRTOAWamEJGKCgsjvxQomvg9gwDJFWVzvEYV1Zq8wK
	hFcHlMAbrWyyc5L5HG44GeBNjRdNdD+tjR80XdxKaN9nK/RX0IgRhjpRQoaGp+xfgyMEXB
	zOGQ0yuLqm65CsfTjjFK0RBDrH6iJ/8=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60QHSsPK522655;
	Mon, 26 Jan 2026 17:37:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=dc0WeDPRM87LNXvHSd
	EgBezXKYiA00X0/T3zEZgb67Q=; b=i4DdWi1D8BCchJcDz1E6HYQ0Dx/6eLYXPw
	uPv1vZlZrrQBKPx2DuUhJOo8dUf0+ajxaNJS55jtlecZprPSDN6jqriqYJQvg8xC
	UYKsb5jsUbvO+Hya94fOTjnLYLL0u6st+8jESK9Ku0tC5RiD+RageN0MTsjgsGkL
	mGhB6KzVr2PaP+Na93inuP8WFnfst5Q8bWZBbKnq/jFU3FqGdo/LViTrNq5kQR85
	nRucS6sjBXrmhS9Dus629MZ3tHDMFnppL94vze9YzhZLnqtE5Q2rLDB8/V+BNO0q
	qf113/4LpZCnhIp63Np3iTg7Ps2nMpdhzxBPXpkgQolLpSQlQplw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bvn09jfqq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Jan 2026 17:37:18 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60QGHbV8036070;
	Mon, 26 Jan 2026 17:37:17 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010022.outbound.protection.outlook.com [52.101.201.22])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmhmgqja-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Jan 2026 17:37:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VpiuF36XtHBu7JXQNXSnanZTEf5seMKcpAluRVFLKZYlVk6xkXMT1qRaxD/rNMx9JyFO5LJSZ8bmpcAaV4/2PTWOptQEkWwhNeTvE/f2ib4RztMQRvYudtw0Dhi6iwnuZHOrX09ZvuUxewej0Xc+vYlCi7bEy5BlB9R+nwlvRTeN8Jyn2S2ZfEYYMR/RXvtgRqHVlMPsSIHZDXeyuPAG8zWPHg/kgWZ4aC9edL9Nc9ROUuk3Yru1qTeYwgDOJ7Mbb+Kp0ZHH+zAkkj2GaNZVhXlkrjSeQ41jnPN5/kC/0GYV3qpg3vFN/zQOjb4HN29nOoM12v/qACwraLv1stGUnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dc0WeDPRM87LNXvHSdEgBezXKYiA00X0/T3zEZgb67Q=;
 b=PxQdPsTRGtOQzwgpW9mA4n73JZuVUsatDYLln0CpSGBAgbgqNjlRr23LWwVoZZheXzfpPT3Wy72lmu26FkKXE5qLLVeSnLg5E+OvfzZsBhg/u+JSISuWv3on7vBS2vnMXmr/PPRVBG9stlACe7C/GB2AV5aB+Cb11ARXESRXW3Cv21YWX6E3fnBJShvDJ4XoZS+Xpw3S7yqIt3UhRQgr7F/swcDxPfFjRTrxJxoo7HlKF0YJhnKCuUxUC9thTMQwwkTbqfeGki2AMIa9hNw28M0e5JjSmavRwZVkahxXqqWE8nKH/rucVnJC/xr/JqD/jpLV8JjfL7NQAD+Qi9Z6TA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dc0WeDPRM87LNXvHSdEgBezXKYiA00X0/T3zEZgb67Q=;
 b=LOAE9EBVWUliepaEzYGVp3M7MfyDwF5pju8eTmzeOsf0uEwGhpHS10w2enVdQlq0BCaksIMVvmiNrxBZhmfIN4mRLk/NHxI5xIvnrMpyr4q8pCiszfoSOOADtafRCKwlYtpl6iRLX2oZGmI6DOxgHWNhcAqxcCc6xHVw9ly/EUU=
Received: from CH3PR10MB8215.namprd10.prod.outlook.com (2603:10b6:610:1f5::7)
 by SA1PR10MB7710.namprd10.prod.outlook.com (2603:10b6:806:3a7::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Mon, 26 Jan
 2026 17:37:02 +0000
Received: from CH3PR10MB8215.namprd10.prod.outlook.com
 ([fe80::4ef1:fa49:5a08:c1d9]) by CH3PR10MB8215.namprd10.prod.outlook.com
 ([fe80::4ef1:fa49:5a08:c1d9%6]) with mapi id 15.20.9499.005; Mon, 26 Jan 2026
 17:37:09 +0000
Date: Mon, 26 Jan 2026 17:37:08 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-rt-devel@lists.linux.dev, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>, Waiman Long <longman@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <clrkwllms@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v4 09/10] mm/vma: update vma_assert_locked() to use
 lockdep
Message-ID: <7c4b722e-604b-4b20-8e33-03d2f8d55407@lucifer.local>
References: <cover.1769198904.git.lorenzo.stoakes@oracle.com>
 <538762f079cc4fa76ff8bf30a8a9525a09961451.1769198904.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <538762f079cc4fa76ff8bf30a8a9525a09961451.1769198904.git.lorenzo.stoakes@oracle.com>
X-ClientProxiedBy: LO2P265CA0397.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:f::25) To CH3PR10MB8215.namprd10.prod.outlook.com
 (2603:10b6:610:1f5::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB8215:EE_|SA1PR10MB7710:EE_
X-MS-Office365-Filtering-Correlation-Id: 2bd88c4f-4dd6-45d0-6608-08de5d018856
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FphIElyFL48ZgWMJtrzlVN3bQnmLTCtWSzkJPkcQArKDQaNQDMO4yrw0ZNND?=
 =?us-ascii?Q?MSeIFBIwM9ZPuGfQNyHc/S+9OKaJmT+P5XLxGbo8Xvb7wl5wz8a8BQ5dTBZQ?=
 =?us-ascii?Q?FWqrOcCX2bVYmpr8//kQ/szYU1vAF/cCWcb5/94xH5a7BFaig30M6j7FzMVl?=
 =?us-ascii?Q?4s5T3PUaBdM0Hu+2qYAAKJ1gZ3hXx6iptGaAP+8zDkENY7v34e8vFdvOZb8E?=
 =?us-ascii?Q?3w3ABKZ+Z92f/IDQ+cMyIwkRViMGlafSURdEA5iT2t5foTFRmqUnRI0GAJ3p?=
 =?us-ascii?Q?SzEsYQQUhqZMbmE4MFJgPOtyV8m2HvoH+by88Ftd4ohfJwXhe3OCMO9Ofs8o?=
 =?us-ascii?Q?kNcQGdU1aVHBjx5ZHK48wIVWgh434szzt2n2t1WH6uUS7h6EaLWif6yI9C+l?=
 =?us-ascii?Q?u0sURbn62GY6gCx3p1yW/6QFMjBw3x1ZqvCb3SPo1Y7ZetlHh0iiqpgfwv/k?=
 =?us-ascii?Q?PNrPyTQwe9pCyd7/MZ+WDrypuDp1sRIGyQKyYBUrxx2wPX9TeJNxSq2v+gl+?=
 =?us-ascii?Q?Qua/HElmP4rd6IfzHpjTNSFieg5AWdNc7cVZrUpK3VzMWNEhv+w6nVXmfNLg?=
 =?us-ascii?Q?03SaDhkapMJK8hi/9zTPfyIqg9aPVsbvuU5Px6A8o5wKdSvKHRktxMWaOeBD?=
 =?us-ascii?Q?nFeHDgoE+yh2xrWGAHY9OxeeVeZC8OX7AmMzAmhuFKINiB9nPp90xjlWqmds?=
 =?us-ascii?Q?YzBnoMzLxUme5LXzLTItu5fhV0hwFPIgkpKjcbYl7MGeNQAelseTC070nK63?=
 =?us-ascii?Q?LhnZYtwgCRJJ5UXMCOQRPFkuSKHS+CghHoeOAD+WOle6FsToKslpdb3DPqqU?=
 =?us-ascii?Q?2NhWpLVrRyS2FdEzvFhBKSCwXIr7tBG4+jnS+biK5xh/5BYJDyGJp/a5I8So?=
 =?us-ascii?Q?sy+J5EN1hSiIIpngiY1cIXFQMY10bY1Xw+s9h7fCdWJ8V3pQzBQPqizQX+h2?=
 =?us-ascii?Q?4KXrjhkmcXDCdgZ3zQzdJ7FmQhlDaxACIu7nQ5JUwXYeeZGXrQAzuR7+iCCW?=
 =?us-ascii?Q?0vrazvMHpCG3I1S4uRdgE2RlziXs6yaB49hJkruZBRJuBM6qM6AvngGT7xSI?=
 =?us-ascii?Q?yTkieHVqGnr4tJIdVxpfqOIkbZOasJzED31N5cSmwukYECdMGl7ouMedoChb?=
 =?us-ascii?Q?udi1tMHf0zAcR0g2+TD5mYrvHEwZy8l6Js8s0AoC9mr96Lti7D6CcQ6U+++L?=
 =?us-ascii?Q?bPGHXru2UNvhgCDuroiMMxxxjVZvl/fudQczvBBJ4P2UpcOtkES/ix8i3BKt?=
 =?us-ascii?Q?Esa/4dNjLubRXu5mbkrbKOaiQxTbhFRpF4cEn+Psm4aEKmuYdx46PjmVBSFW?=
 =?us-ascii?Q?doBKw4KkbEkLztvzANgMwsMWVTtNOzxwKu6gTj0INw6C+fmIgG/GzS2PkoCC?=
 =?us-ascii?Q?76HdCrOKLQClMhnB0o21GoQc/yWonmIWty7/x7ELn1dDQaUMtpOKN/81AyzL?=
 =?us-ascii?Q?HT/xUA38JPaYPbxebklZ9iEVOI30Sm5OvCDbRfjrkJM1q1hwG2TiJ2RUoRq7?=
 =?us-ascii?Q?4MbR6+1UUerZBqipRMVaA56bfhGoONDm+rzF+J+kJGE9lMTD9M1k3jgq8KiS?=
 =?us-ascii?Q?AxIyz/eUqpGXouGjl24=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB8215.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Li3deHsuaSEKVh3ABU//cH1POdV0sX6cTvSAQJPwgrk9HiUr1me3Ve+lSNS8?=
 =?us-ascii?Q?seSEJMRupRabvLA0NGrCujmvHtHe4PeqWGk+zOyaqVqdVCDAU1xOGwb8Wb4A?=
 =?us-ascii?Q?Q36b3ZCHql1zeCTciAlFPjI/JKVaB7LH9GJKXfNxwLekc+F/BonwAKaAGGH2?=
 =?us-ascii?Q?svRu6UJFKiW02QBWv9cxQJBGrerrDKVb4d7sLU+2Pn948fy7P/7MmfLKBBqU?=
 =?us-ascii?Q?SVB7BcYe0WQ9qLa9/wj6l4v/XUTvRU3eqJgejcNdzzl2s4spGwCNkmNTRNJ6?=
 =?us-ascii?Q?iArdIrV0qBvC5Kb4TD0jCINExv3t283ljhHA8L1T+Ibe6dWYXr9hxfCZ7Nd0?=
 =?us-ascii?Q?OY9CU4kfulz4ZRohfVd3zU2YDyzxb4uftRu5B+Lhtjag74vvU/djPHC1CPJB?=
 =?us-ascii?Q?dH7dpEbNGWhiWksLitFoBI01xPONGeWak6yu31rCsunkhjzIgwnn19gZDQfq?=
 =?us-ascii?Q?+gwOe9n29mFXv3Q6LIg6mUDAEpOfms19Xv+nawzYbAUpepGaqAIxqYMXYozQ?=
 =?us-ascii?Q?sMC3gjWJCcUW0fIxIEMw3o23RBmKSgZA2HfE0D9qWECcf25XJHJ9LOZTpNMF?=
 =?us-ascii?Q?K2Rjlxz4P6PUZD9lTLF4s6B/jT4TFcj9NK8W4/NogqJnnxHQQ9rLYBLILmKu?=
 =?us-ascii?Q?FqotfPFDkB0FQ+lFdfVhJRltBmoXdbsNd05MTB5mVw6wjA/JmbAHbuE++r8h?=
 =?us-ascii?Q?IsC2ajTfv2YNmPrwgkkQDNo8Jr+KG4EdbsbOcVZJ4jRy2UV/8uIMvm1+xZ4R?=
 =?us-ascii?Q?IFNfX9kPvLpFC539dh0581Aqx9KIDujLPxAVQ7waJBARzCOy8exLWTplODmQ?=
 =?us-ascii?Q?Lm++IFoYjeEaF+s5OUE3PHnu3zrsu9IBfIygA7yiPIECoBvN0Ds7kzKd/Djj?=
 =?us-ascii?Q?45PKHV2rc5R6TFLA1HD919I0EJoE5P5ZGz8RQGc1gB65D8sru5LqLHqaRuNS?=
 =?us-ascii?Q?V1j5kCIjxkkJ7nes8xa/JzdVV2EouDTrKnooTGQWaJvw/2vk9REjz0BLRpBI?=
 =?us-ascii?Q?Klbh74SbPViX/ITUAo6c/QtUzf40ycleyajjKGvY3iXoWUFtiFXqm6Soy1hq?=
 =?us-ascii?Q?t1LgYIlfzMbDb7lTST0FV49Y5XcuJ+kTvgqZP7h1XG2AheZvSg6vWQRc1E/H?=
 =?us-ascii?Q?17+pBtolFDDJvGBWRkKkAdwKNWjF5f4+JPw0MYXL9bstaufGGj8CAJI+1exC?=
 =?us-ascii?Q?glTSU396Pd8b/JH/VYOPCqIb9lW6wy7TnWLWI/XkYZYK7z31wY+7t0UGJb9d?=
 =?us-ascii?Q?okFW8isRaPg0sdVnB8VHB/6EyFpnV/Xii7NclTxa8VjK766cyrGGrjjpOOC2?=
 =?us-ascii?Q?WWk6J4mVh8k1sKGmmtTB18C7O1bfFWPGzb1H4ivFld8s2aBMEnFyzeYFowmQ?=
 =?us-ascii?Q?KtonWLLpOMiMMRSvaUhcxqqWxCqDygoKcT5Hu+4M8+cLo4Kz6S6rGmEG8xj/?=
 =?us-ascii?Q?UGPYCzCKqzFYIZyVbXR9kSd8e8iWzLbq0yLlKhAfjkew1YkKJMX1RBGO78GY?=
 =?us-ascii?Q?pW0oycvXSMNwoAzU0GvJ0orENUWsfB0EGEm3soz6N0HFshsOERMhPFDm7KNq?=
 =?us-ascii?Q?rZU9jDASYkBtkbeZfDA+iecnJ87OGBLhFhXXtK1P4dPxrDWi2ir5dr2chm+x?=
 =?us-ascii?Q?qM6vb3unaHtk/QYqf+7NUolACqGfnt7XAeh7PDy6TLAJ+HWIyXmoqkbKLGwH?=
 =?us-ascii?Q?2AdityExUxYCa3DkNbEnAgawcxLcLd864RlrpaxQvAFYMIhRYDjjtOC1uXD8?=
 =?us-ascii?Q?BLXcsIKOv5m7JYz0fVvlC95t/REgLZg=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	rkhwK6C9PAX2p4Aru982/672p0So9ZlyHPsLecpmbxNTLTTN8gP7FiTlLy5vin+phCBQ7C7VMRH9n4YL0JEEKpkySvWbUZ0aiiPr+Wi4TxN303TbBbrgBdnx1ZaAT2rNVNJK2D0nHI4YdjGNoK9J+9at+2Wvy/5klWGvJbnPQGyURx6fdoPcBs79DdNuD5ct4lXL0GpIv4Nx2GyXsKUPvHUrGnKK+v/8lfvgPO1S2lbZV1e+S++FnCe4IBbMs3VJ/o+qFsawXBEX6TMOVpM/XYfitnClzSZ5VVZ+RKWvcp/69v4AGArWpPUThlN++/FrqUaohAhJ0uJn0+Sik/Nx8Auo7zO+8LHwpL4eWXQNrc+s/CgVxUc6TvXGHOkxihk8ApV9NhoR1Dj3kZHMvqGNyjdA7RtOY1i9vlaeUZX9JfnbjrvARUQP8IZ/cebPosuCvR/kMBB1wTMfKtcSHjHau4MOz2q+hkQSzcqcC87gMq/8YhlwaXqTT0CB9ojokQBy1LfJHnxq6fZFTosPVcBerCP+aIZx3T1PJUQJVRUQb+bJdwUKXlN0Ncm45W1RxM8S8SBMr3Ojlil9ViQDmW0sg/l5VHy+alV3LbVMOJMTbdY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bd88c4f-4dd6-45d0-6608-08de5d018856
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB8215.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2026 17:37:09.9019
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Lp5XmYwQPalSa35E/pMX+/1KRy0GVLQtrLepzTaJjJ7Yh9iEXjlox0LqWCiRlM1VitbsmkpWzwinPNx0XuN9zFzHAWcCDUOyo/uzigWTGzU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7710
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-26_04,2026-01-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 mlxscore=0 mlxlogscore=999 phishscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601260150
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI2MDE1MCBTYWx0ZWRfXzl8Rs4SVNVxX
 pixX7shPlZ0M3VeNvcmw9t/upxJJTmRS0DJBPrBFAuUtTzxkntrWg2JS7d6txibQ/Af+l9n/dOp
 mbAjDM+gHfIEm3ARIccqb8PFrJc7bxuKitoiwAAQCT1jUYdb0YeDpmCPli56pX+7KN/wgfBuwkR
 ndf+dzVdrfKJ5iewrOCo47sJ49CH1z4vJdUEoIPL+LEBeMjgi/FL0cHAYGIzFA/BDWITwv5Or7s
 YJB2vIaZPtbCETTeYa13CULCkt9UWLPjso0DSxKuEjKk92shEDg7VV4X4UVEkoZRNHqoAryh7gT
 zNGPveDmza9trbU+H/jMG3tEENyR5lWJ3LpgK6rn30y53wyg/4UD8HddDVRllx3lJsMVLYhDTBa
 KG0bN6ulbLx+c5zBztSu97euuFcnASsz0kI0ylMsz/05j59ERIDfALNR/atWQmbQLwfMkq8RiR9
 WvegFPi8u6odxccD2EAStmQD7Ndwe9+9Crq2tzSI=
X-Proofpoint-ORIG-GUID: UPV8SwrEYpDLFdUhd7JLjAhVzXXe5dEe
X-Authority-Analysis: v=2.4 cv=Rp7I7SmK c=1 sm=1 tr=0 ts=6977a64e b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=IiReWDGCM6YsTN0pUd4A:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:12104
X-Proofpoint-GUID: UPV8SwrEYpDLFdUhd7JLjAhVzXXe5dEe
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7EC234000E
X-Stat-Signature: ppe7c3nnrxndcug63dm1ucroxp9pw1b1
X-Rspam-User: 
X-HE-Tag: 1769449053-293299
X-HE-Meta: U2FsdGVkX1+VZRmh6LyviQ+sQh5N6G9i8FdHI5PdIfR0k88vZTnAOPH05Pn0cADijDk3v9RKT5xuRUUhIRL9TgB4RTwOA52a3iH51RlzfthcDWzUh/8TnNM6hMX+bqZusaC8TrNUC9QGpm6MNr9QeMc5mZ4/w5FkqJaKyWdquxH2sXEihiJrLlh/utcJJWjJXAs6sm1zNBk1ve6trK3NG691aiLI+1av+NYIP/F+Lk87f0EarUNCbGjXAxTFgJCqCezn1gBdWGHnzPLdcJujv8KtEGM+p0uGLrF0MbFADqEN2Atm1+AjMtPk14lS09+LGBs9fxWFdj+v2+YqjPp6KspWQG2Qr/0lFwMmu5y5kJDwp4UMGoyDBuLD5sxJ71eyQdJoKCVELLvZP/8Tz3RMXAVDec7jYQChKVuB+8/UoYlz/McoiecZ2jqENa3zGNTPgIOkebMoGIhGLur0TLNLmzS6tXH1prrk7KhVnTkiB/0lrry2WTp9AM+MEUquG93W+tBZpt0IosfNd7nNvS+xUS+r0+FEMaRBUYqBj8TKPrcLteAvGywqHBJdJqy8PQoFRBYZUzua/YA8zyTygFolwSREEyEf8vBNWmc4SBakdYJUYNhlhqqWp9ttSEU81noJMSwp8EBeBG9cwTETYS/2gui8JRnFPhE14Xxqp73iZ/zdzewlHNXYUoddO4fTV/A+LCjRVZZnqJAzut6gTqZFKr6xgbqIca1ZUNaUdQhiMPDzI4ITc0Lg2dThUlvN1q11OpMHCo96FmjYUjVVntqBpT4ATeRLaxX+hUUxJJSukRWlYZKKiZ2sfIFADlIBaU385DTU75EtrEN1/ZLxMQ9C86FG+rLzpuOYTHC1VMDELLSGr5CajTi/UmcAgaNx7wj8DIxn/OJ3z1uWc1aS/vWSyrtxNGfPvT6PeHWE56VB6YEQmbGz21YMV55btAc3JLfCZuuvPtT+aNTW+aKRq0e
 9S6q0A4r
 CBtHMlVMsJqd18rk1NIgnMcRPEf8ROL7QTOyo9mrIhA3qsGlyWCrnfWuCbW7szwlzd0yt/6mJL1IvVInOu1m/UqNB2XU4FDYuiKzwHniXZVkEt16bnxHyPhr3DI/wD/jBjsVcVg12W7h7yi+RJS0hQ2qG2UVDqJscfvIiYG97V3Dfcr0BBm/myjKfVUshaJBKirDOSWTbu4lDSj6ZSeqrSX9GYMIO2hNdrPs2GUCJfbNGf29x/ruPheEbgV6wSsxEOffNOtDtFNyYZfvNCxfzVoMHtSbmFSDv5abVuNwHMnnlpO/eBCDIpuvfiE7ynsLWmsuZxWzpo04NpjkVtianmwM6y/tfQ1/KnVbTGueu07U7c2QHrlpMqDBOCZZr1aB3vzeT9ZFWTQq8lqZ5RIvC5/g2vu7flyKE3ZO9YYu4mM+Rkqre4f5CRy0iBdSl8KzFJLW0upuM5xQQ/Unp9IaNGAzRNBYu8jdFkUScVxwNWXhQk3v6kjcz+tKOOn6GHtsEOBYRovawHEYK+7pJclDn6mZTfpOl70YaY8ZLcqV89/yz0Oa3dUj5/RSfRglIJpRvhi6ClDA5EhBEvdL/SAnXqvD/ezGVrP0teL9rFRw4kLp3/o9BCPRIXokjoU7FP2dWX2uK7imDdhw30VpG5SdDibNvFJHfmVNEFxgHwQLT+YUaquMykx1Xgj9lxI2N/sEGo30zXxPHrMuZ0S8qO6/SO85yR6w+FqZ46+BG/XkTwBXDtAY7Cx9vPP/UxRwsynBIlyFyDqDYJIR6GsvH9Qzt1kWOFKS6jntjw50ECTBtW1VlgMw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,

Could you apply the attached fix-patch to apply Vlasta's suggestion, and to
avoid unnecessary ifdeffery.

Could you also adjust the original commit message to append the below?
Thanks!

-->
Additionally, abstract references to vma->vmlock_dep_map by introducing a
macro helper __vma_lockdep_map() which accesses this field if lockdep is
enabled.

Since lock_is_held() is specified as an extern function if lockdep is
disabled, we can simply have __vma_lockdep_map() defined as NULL in this
case, and then use IS_ENABLED(CONFIG_LOCKDEP) to avoid ugly ifdeffery.
<--

Cheers, Lorenzo


----8<----
From 9fb6dbe821c87759b269ddc926343d1f9c26db2a Mon Sep 17 00:00:00 2001
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Date: Mon, 26 Jan 2026 16:40:34 +0000
Subject: [PATCH] fix

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 include/linux/mmap_lock.h | 29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
index 4a0aafc66c5d..160c572c1798 100644
--- a/include/linux/mmap_lock.h
+++ b/include/linux/mmap_lock.h
@@ -78,6 +78,12 @@ static inline void mmap_assert_write_locked(const struct mm_struct *mm)

 #ifdef CONFIG_PER_VMA_LOCK

+#ifdef CONFIG_LOCKDEP
+#define __vma_lockdep_map(vma) (&vma->vmlock_dep_map)
+#else
+#define __vma_lockdep_map(vma) NULL
+#endif
+
 /*
  * VMA locks do not behave like most ordinary locks found in the kernel, so we
  * cannot quite have full lockdep tracking in the way we would ideally prefer.
@@ -98,16 +104,16 @@ static inline void mmap_assert_write_locked(const struct mm_struct *mm)
  * so we utilise lockdep to do so.
  */
 #define __vma_lockdep_acquire_read(vma) \
-	lock_acquire_shared(&vma->vmlock_dep_map, 0, 1, NULL, _RET_IP_)
+	lock_acquire_shared(__vma_lockdep_map(vma), 0, 1, NULL, _RET_IP_)
 #define __vma_lockdep_release_read(vma) \
-	lock_release(&vma->vmlock_dep_map, _RET_IP_)
+	lock_release(__vma_lockdep_map(vma), _RET_IP_)
 #define __vma_lockdep_acquire_exclusive(vma) \
-	lock_acquire_exclusive(&vma->vmlock_dep_map, 0, 0, NULL, _RET_IP_)
+	lock_acquire_exclusive(__vma_lockdep_map(vma), 0, 0, NULL, _RET_IP_)
 #define __vma_lockdep_release_exclusive(vma) \
-	lock_release(&vma->vmlock_dep_map, _RET_IP_)
+	lock_release(__vma_lockdep_map(vma), _RET_IP_)
 /* Only meaningful if CONFIG_LOCK_STAT is defined. */
 #define __vma_lockdep_stat_mark_acquired(vma) \
-	lock_acquired(&vma->vmlock_dep_map, _RET_IP_)
+	lock_acquired(__vma_lockdep_map(vma), _RET_IP_)

 static inline void mm_lock_seqcount_init(struct mm_struct *mm)
 {
@@ -146,7 +152,7 @@ static inline void vma_lock_init(struct vm_area_struct *vma, bool reset_refcnt)
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	static struct lock_class_key lockdep_key;

-	lockdep_init_map(&vma->vmlock_dep_map, "vm_lock", &lockdep_key, 0);
+	lockdep_init_map(__vma_lockdep_map(vma), "vm_lock", &lockdep_key, 0);
 #endif
 	if (reset_refcnt)
 		refcount_set(&vma->vm_refcnt, 0);
@@ -340,14 +346,11 @@ static inline void vma_assert_locked(struct vm_area_struct *vma)
 {
 	unsigned int refcnt;

-	/*
-	* If read-locked or currently excluding readers, then the VMA is
-	* locked.
-	*/
-#ifdef CONFIG_LOCKDEP
-	if (lock_is_held(&vma->vmlock_dep_map))
+	if (IS_ENABLED(CONFIG_LOCKDEP)) {
+		if (!lock_is_held(__vma_lockdep_map(vma)))
+			vma_assert_write_locked(vma);
 		return;
-#endif
+	}

 	/*
 	* See the comment describing the vm_area_struct->vm_refcnt field for
--
2.52.0

