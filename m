Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80755D711A6
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 20:17:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6D676B0088; Thu, 18 Dec 2025 15:17:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF0E56B0089; Thu, 18 Dec 2025 15:17:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7E356B008A; Thu, 18 Dec 2025 15:17:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 91E6A6B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 15:17:12 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 425281402FE
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 20:17:12 +0000 (UTC)
X-FDA: 84233701104.05.EFADD68
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf26.hostedemail.com (Postfix) with ESMTP id C1ADB140013
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 20:17:08 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="ZmBeU/z3";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="Tzi4x/5W";
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766089029; a=rsa-sha256;
	cv=pass;
	b=uBMrsh4Zj46ESFA0eAK8IOzE5Pr9CCcjeZhaaagobRLzMlX4X/AZNd0wuXs9OJ1CHWvihr
	MmBaAqko6r94RsLWqbGn/bziFP5o5nCM/vqVkXcfbaLqsBzD1tW28JnQ24H5IcDLJh1WzH
	OWOq3SGtu9BHpr5mz/MRNd8kl7NTuLA=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="ZmBeU/z3";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="Tzi4x/5W";
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766089029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tJMdgrLAS38pW4LLq1Q00rxA7dOdGMajKP4zKMdTMW8=;
	b=12v0eKT9Gnz1SpUYSpbmOcRm3Nj9CeUEtdAvfpV9AAlIdx7QWakhde+8424cktPzCFyvAC
	ZmXNxGvyHoK/B8bKG+5KYzXMbp08v9ysxCTW7YxBdJ4w4HL3Rk0TLoITciU3+HpyB8TSc5
	C3rKJm7LIkD2NJzsPBtjCwotIL/108o=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BIJkJms2089219;
	Thu, 18 Dec 2025 20:16:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=tJMdgrLAS38pW4LLq1
	Q00rxA7dOdGMajKP4zKMdTMW8=; b=ZmBeU/z3/Qs2+Nhi+E3eyC7PwdYsT4gvvy
	966PWsb2dZm8NUiTpIk76cBgXIwRZVPVu1IIs6VIuShncHvnT8MnSh641dXzyiQa
	mTwupGNMgC9qxm0XrlM/5KQEjyHsllsCf7ktrRcK/aCNABKhooQRWHAec6XO8lAx
	18tFOPwMS5NCVjmKbfqGTn69yPWsjfImD9TIAK9SOt0X08Mzyw3KDLLmxwbUSzlQ
	7YDPMazyfbshccSd59mWwQycHsrRwcVxN3PtD4acbbYVZWNv+X0BHsqec6jsvIza
	RJaYPvcKElRCwwoyYs/Pl7P6DTsTirTQvnrN3BKP6D6Gi2r4JWQA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b4r2a81t4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Dec 2025 20:16:45 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BIJSfUH023418;
	Thu, 18 Dec 2025 20:16:44 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010068.outbound.protection.outlook.com [40.93.198.68])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4b4qta1tjy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Dec 2025 20:16:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zLzHV70Sxa13appHgjsCuOO4R17uQ7Tsfdyxi7qHWsZabA+8xFMy5haY1M6uTWWA57kURyXNN8u0PrOsfqpd6EkFcchYXImEZQkCTVCTnyHUCRXvLMvEhGvxLlWjSQwdynCh1gfxv0cEn4ppVw+TUMtF+V7h31m3qYfPUiRX0AEa2r1inuz04R0bKCF1mZRiY+nKHzbKVw65ilEyh+NW3nRkD9XA2Yq2zpyEqYauuT/l3T6RthBF0PyHhopY+oJ2zOYp3S4QgNVqyaTC4Cu3K9y9ymOgYwNajgfXsJhHh1LnGoGwNn9D7NW3UbEVe+rS3/zECLd6F6O0Q64FOKHcig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tJMdgrLAS38pW4LLq1Q00rxA7dOdGMajKP4zKMdTMW8=;
 b=ymUyNmzNgwWdFmnpqsmXGZWRBcQLt/riLwVKiHL0ubEzCsogrcYAHfekCZ0a7dJu8kHMWE28e58eWIV9IIJUozjU+yMDMSMekBGQo91JuUTI/2gV5dNf70aASBwYhdw4dEexBscsPJ1ZwE9dTX3+DVeN9zZ0YW+Ui3A9qdx5URmRLCWN95U3xeLK3bBuCKvPVF/ggeITx3xEzsVPxYF36RYsJulCOCH8Y2PDyN61lQZbvlJT8ULMbAzadxx+LaRKkfRSRZDiRdR0O1rfyCw+gO6ByZV7kSJCB3s0xz60GwqHjg8fsLzftlj8QMiaBkJaBALYa80gYXpkfc6LcSJ5hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tJMdgrLAS38pW4LLq1Q00rxA7dOdGMajKP4zKMdTMW8=;
 b=Tzi4x/5WX2wzDAJlJmXNXNIrOnvhQYixC8JpcCVo3yLSTLi99/nqlbNxsZsa2+IazYuqe+SQ+j2y+9j5RhTfbfiiDm6/YBWBD2jmRIN0w4aS0W+JaGAJSEzMZZ7YrukwGgnhSMBV33KYFNkwKSm9sn62NuhkDBQP+FpRk5BNuR4=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by DS7PR10MB7252.namprd10.prod.outlook.com (2603:10b6:8:ee::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Thu, 18 Dec
 2025 20:16:40 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9434.001; Thu, 18 Dec 2025
 20:16:40 +0000
References: <20251215204922.475324-1-ankur.a.arora@oracle.com>
 <20251215204922.475324-8-ankur.a.arora@oracle.com>
 <9ad1ad81-67e2-4274-afe3-5b9bfb5c7ad1@kernel.org>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Ankur Arora <ankur.a.arora@oracle.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, x86@kernel.org, akpm@linux-foundation.org,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        mingo@redhat.com, mjguzik@gmail.com, luto@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, willy@infradead.org,
        raghavendra.kt@amd.com, chleroy@kernel.org, ioworker0@gmail.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
Subject: Re: [PATCH v10 7/8] mm, folio_zero_user: support clearing page ranges
In-reply-to: <9ad1ad81-67e2-4274-afe3-5b9bfb5c7ad1@kernel.org>
Date: Thu, 18 Dec 2025 12:16:38 -0800
Message-ID: <87qzsrwno9.fsf@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0066.namprd04.prod.outlook.com
 (2603:10b6:303:6b::11) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|DS7PR10MB7252:EE_
X-MS-Office365-Filtering-Correlation-Id: 8d09f70e-c64d-4b03-7a23-08de3e725a62
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xdazL5IcJLAH3o9CPNcUHpsNPFMMAFuMl6i6Ty6PLdqaMH8p7NwR3elpVAGR?=
 =?us-ascii?Q?LgR5X9L/K1AV9oz8EXAq5Yf2i2fb90/4e3PyQ3sQHd24PGwfnJQee0Ur/DBd?=
 =?us-ascii?Q?eFXapeiNADNNFs3699lprrsj3CUN2ueAPb9UlzY6AJtenUvCXmfoa/NmvL1E?=
 =?us-ascii?Q?BCVPkQsDfdAaOHZyM4iTZz74et3+499AaPWxIn2Bm0Vo8vGpBAfCtyR0xX41?=
 =?us-ascii?Q?taTlAFT0TJgYAx3aIs2kpPIdTK++Sm57GaCRLMtwzP8LIc2xfhmtpZ0/A4i5?=
 =?us-ascii?Q?n7pdusjaTS4flVf8Cr5M7u2QckcTVUcvhSU2XNqVmspFyAwcQjpUEX8CNfqr?=
 =?us-ascii?Q?4ByDzdnfeWIby2nr9kjJsP1lRm5a06gQu9NC0R+oArYbMRAWgVaaqoCr3Wim?=
 =?us-ascii?Q?Hzdh/0Ftiyj3QGqeiwAdW0Nj9Pewc4289uRrN7fdZJ3rbwCdTz9Ewuy/vW2r?=
 =?us-ascii?Q?wRFuRmBOlAw31JW0HuOV6i400jxnlKPfjPIYJnrteVSswjCMHv6NLxiwZlT/?=
 =?us-ascii?Q?AoQhzFKQoXY6GO/qpG0Rk8oVyaza0jQmZdk9C8UgKtQogJDBF3v9vYNrC4w4?=
 =?us-ascii?Q?znnR8QTtrlBAHurekPbepsFE44IJSuqk/SSMoQ5T6yUY+6OrET0ZZNdXCEq3?=
 =?us-ascii?Q?GeUIZ0CywLxYfon3wkvmyi4XmbdZEydUKFu90T22p4MJzU2RnXYrxb72yHqe?=
 =?us-ascii?Q?xRa4tdsSSrHWrk7gxR6dTCv6Z9k+4Q1LN7zwn7aaGNezMT7n4kFvzRr3tbX0?=
 =?us-ascii?Q?TgUWflgphGMPxGW28JQxLUwtL5LCPZe30L/Ej9+KgJRCkDjk3gUbwi/KMRX+?=
 =?us-ascii?Q?zfDuGiaKsj76jWF4PXbiHtjqrSUl0YUWR+cqz6EQ8LmjSA+a58UejtHzIyv3?=
 =?us-ascii?Q?WM6gR2MOKF5nUEs566NONuyfFCrdffuUzXvFr9+uT1b4o1yOyQwDX8W+fzSy?=
 =?us-ascii?Q?rnUfV8FouF/fWaYCD/sx0mSPfz2xLki+UEujM2tjPi9N+dP/zYsd4gRXV0gu?=
 =?us-ascii?Q?3QBlV65h686JzEKYjs1VKyB6bEZgm+Rnpa065aFfr53ROawD9p6yUJ2dmHQ5?=
 =?us-ascii?Q?RYJQLP/Q2sT01zni+rI0jXBSIV5yHhowOw+JnHMkWkOQnKqkQ9qRNQRUNZqy?=
 =?us-ascii?Q?gbrIWOgan5T9luGLB2UaelGVvjoHGSuZkIkJlXoL1sDpe3F3tO1qkgoZZcwG?=
 =?us-ascii?Q?ng/dDqcQMaI/zlXM2O7dSlAHmlQRMCyHKmlHESlcoVNrvyea36vv4AyqfC1o?=
 =?us-ascii?Q?TWlQFJyRYGRULxhyeXPcn2Qw8K4KL4ZseD7hdHx/kkBY4qZHtEuU/2gEk5uz?=
 =?us-ascii?Q?3Ej1OO0oLnxazfdsY2oiUKUvIMhzpiG/h/QxhSlPxuhuvObH+pB0oek7qzOu?=
 =?us-ascii?Q?3Kt1qB/NYH0AmswKJXBo5cwF55tvBb+rN2YZe3k/1YvCYWiy+4bLPiJq/UfL?=
 =?us-ascii?Q?UjZD2A1OJ8zSIVXoTyVnLgIuwlL7Snpt?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?EiiDAwVkkpf5bzq1JoqWBdczQUT3riRshLzUUPEw9A4GPXxTHUzOR/biylXC?=
 =?us-ascii?Q?u1iKOkkSYkjWK9k4+hONWy62w94NIdKRC2Zpx8bOXZRbPMaksILvk7G+Gc7v?=
 =?us-ascii?Q?kGmz5puBNwn6rpqaAAxHBaXhxElRNoE9wGmf2P6D0PZ+PYPB3DMtR/Z+kZm2?=
 =?us-ascii?Q?afmvgyxQxgiGSFrlfaNTiV4Z76dR3OhyF0+cgW4arVUS85dX4uJyEmhFJ6K+?=
 =?us-ascii?Q?b0yduHSuaLO/YOtR01Q40I5Xu95ycuVZCM8zxFGNnonYj38xOqJoXYrIk1e8?=
 =?us-ascii?Q?jriogy4YyF5yYOKG8bvHmuNI/rqO08481ubsFp1HC21VKE6HGi/NP1/46UAp?=
 =?us-ascii?Q?1WTKrnL3R0KsyVm3EJsMgsU3D5Awx8rElW17vLCQ36Pchd8Hrf13dm/BmhsZ?=
 =?us-ascii?Q?ocpfDJFvSe5/7BSPp44qvb2plVE/AAzl+UWLu6C2HIon4O2zzQXL9qU0eSMc?=
 =?us-ascii?Q?mOq0rV/tXola2RXEyvJxNHG6ZJp2NWXBRjm2Ij5deVWtPPakv3kAMH07pUCe?=
 =?us-ascii?Q?VpCZXERU0TBbV+qoZx+WGhT8q8ophLPcjpKP/3WjN1Kmv0sgkP4bdbqkpioP?=
 =?us-ascii?Q?E/yXn3n1FIeolMznx8oa0OszllBULA6sHnn/ehFiwpUBVNdOw31qj2GPxZzS?=
 =?us-ascii?Q?jhF6M8vZHosPWQU4vbiBQT0HcQAWFZktNdq5Ua1t7mMRQgZFkuPCV0T8ehdu?=
 =?us-ascii?Q?PJasJtCBj18J8v6EGXTU+B659ir4zFYdfLXA7UCu+siyuhKonHU8ypkJptmK?=
 =?us-ascii?Q?rhFA0bmSYUBQxZekA2d1he0s+vFEIovmDvajXryANgpzhFgVy1BN26eQbVv2?=
 =?us-ascii?Q?e6jWMVCQUBydDXB4E7wN2lRGAwG5UbvwEC6E/v/XLF4dS3+pAgyFVe7BLhEW?=
 =?us-ascii?Q?6vNMihw+SSecbbAQVMgBUOz1rZquch9J6BVkFtr8XsFylPXD5M4J0bjXx3TU?=
 =?us-ascii?Q?sw36nm8K/oVUPzrQ6bLXVXtBhmEsXQcjSuht396nYJcRLXFWpKzePACYjNrN?=
 =?us-ascii?Q?h5TMa5RBYBLh2SvTbqX8nu4LL4+c6aF4d1fPNqR3ybiAhk26GQ1MaaSOPnfv?=
 =?us-ascii?Q?RZac9cUoJiDfOm24YjGIL3Wviy02vvhDdXGkvQp6zjffL/cuCG0m0JiupxLL?=
 =?us-ascii?Q?mhI48V+q63AKF1oA8tUXeS7BuO5AuBYBfinhiQEd5QHYoYTyq9boQl11PNul?=
 =?us-ascii?Q?8RmWCm49vaQNpMGkqH90uiVZj9KjgrKOaNLoZYXx5SQTYmaeE20XlsjV9yb0?=
 =?us-ascii?Q?2Gam+CWdL4mUoFePUBitSO6r2pTqjAV5EqqlXtm6qWnmofh7BcUVjP6JEQH1?=
 =?us-ascii?Q?dZstYFlD3v8A1mVajTYOBKwOw4ZYnJ0WBCPWN0LElfR+y/BsiQDY3xTmq6F+?=
 =?us-ascii?Q?5UTlwlctsItSqShXsOiI4DZAr8cx1pGtI8xydZfLoP+SrfdAMqPlnMuazEjo?=
 =?us-ascii?Q?Otif9P/iNyO31yQBxibLNa0yed3clxIlqaIpopmfVv6hjPM/dcyMpmHHPJXi?=
 =?us-ascii?Q?w63Hev2GCkL2gOlCIoFqi5u5Cu+EVFIiJBX69Aq2BjiR34wY+9ZuvNPbhCvY?=
 =?us-ascii?Q?n2QOOo84CBqMm5RtvS7lCpjRYXYfNmV4Aa6jqBKdGi3nML5TXM0SVXvtzLIE?=
 =?us-ascii?Q?bg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	O66Df4tJANhY8T3JjWLIdX8ake4m28eVUUXzhMaJfkgXmlbYslGtvd4Lg9OqTRP0UaHOPOD/yBRluOmNwph5Doq3Vte4UzKLKxM9hpf5p5t9sJRdFydVqfXbGRrvV0uSqFK/o1wT4RtsF5vFMz9ba6Wsmd/zPaneVzFSYR1hDNmINn2F7IjZ68fHW5HxOjyOJiS0o9EbBHgeHXshtS+htfBFWs5FCanOkY65YG1TWOFC2LdFo5pCa880wvXCS0waCZzE4EhFlFx/t0qIEJUUHzXtF+lIaYpl6b/IOwy52Jzfs8tR3X6n411x2M1yS6/LKPHFx1xmmoqTg+QpQ4kRWIwzTrSBFA8J/0Vu5b1YIImJbosoiY2RUJ+LCt4BhEiIG4N4k69IizUvO+j5r9qF+WuWgYEUFuVEWnzH5QuGoj5qb/MiZqvCvWhoW8+NxYQqeHAZOCLz5uUenss4lTuRm590b1GF/j0jnfmsecUHnK8gOEoGInFnonQYm8sO4LNaA9708wc/mpKjGiGLqYKTD18YwjD5lEQEfgijXmF6Y9eewx7SgvEGx7iRX+aa8KCY/Of5CkkiatmFrCTkUDQYWGgOdx5snVFw6RXfNkQgjn8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d09f70e-c64d-4b03-7a23-08de3e725a62
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2025 20:16:40.0908
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9tgyUC3FdiESF0hP9Co/YJ6q6yHyAWK+AKo8LXmicach85ofUQvXiPhDN2mH8tshdxhtLDZj5jRPqVOXqfRiGnF3ulb4kA2K0cfpG8W3K48=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7252
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-18_03,2025-12-17_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 adultscore=0
 bulkscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2512180168
X-Proofpoint-GUID: 57BD2XcRoQ3OA-6M01mgbNVsu-DT-Xcc
X-Authority-Analysis: v=2.4 cv=bdVmkePB c=1 sm=1 tr=0 ts=6944612d cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=wP3pNCr1ah4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=zd2uoN0lAAAA:8 a=anxKxsOfyN4J2HsYFOsA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE4MDE2OCBTYWx0ZWRfX+7dhiCXtiBnk
 5IX24IQy68Jb9/xahckXF0G28Le8CLhPX094RkNdQ8GaXWc8I3YLjHT19SSGrFl/oiCGu9ekTz7
 pVTibwOugdNzbtJJACbqSwi7z82niatEUc8PFBjbKqcS1WiGiUKGmst/vpzE/+SZpAyoDLg4mGm
 7X0dKg7KADaGpRcT39nyWSSpzqXP0e0Ni8FCu7P32Mf84DY2udpn6ymk+vtua7CD76KDI69At9Y
 J99b6vEPZ7vdCcCoMhF1wSr+aDg014PdCxIVneP1J0/87o67u2p57onggwIs5YBud6QZnVBR/JO
 rY2ie22yhIdxXQE1J14QvpBhktCoOlDxcrfevx5fEtbd1uYLD+rhc7kZDY0uXqHVi+cObZeepHM
 3/gtX3yWcNd16vPyDlZq1X/Uh3eJfv1E4ebFrkdGaw2gD7b/rI/ASCQ4nTXuz3fBQKTF+b632Yw
 kgEzXpCMleNPrls8boA==
X-Proofpoint-ORIG-GUID: 57BD2XcRoQ3OA-6M01mgbNVsu-DT-Xcc
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C1ADB140013
X-Stat-Signature: 5ezaipaa7uc8dsxh3j6iyutxjbsbxugf
X-HE-Tag: 1766089028-382899
X-HE-Meta: U2FsdGVkX1/eD8Vo1EsHnc6rpKkCtRvL+EbEZ5nsETHLRfJqGDaVPX8+1K/vqf3+lHbLdqzCbPAtC2eoBMFClCbIyTfOrjciRKr1pKZj4bEqANuH9hkfD/x1qjkgDEWhHK7jEcyZ+1w03IpwClamkiu0/ThDIqVmZsOsS2OGxo3nxDU+vahCIkxpYN3mbAv1dB4Z+cFq2r03bK0uV5dLopH+m71qZh+dqGAmSAo864VXmFgrEprsMxVGUmwDIugLiYK3q0xowSBj0C8FFJLbCo5YiH1EPYLT1qZn5RwVauOrhXY5ZKkpGeFt7IVbDobvxw0uSAZe461ZA5/VucBvULTQrGBa9DbvWEPBv2ZT9bauVwU9+dqCc67gAyxrbWARBfOIwJd6wn1k2K8UDHSGabZ5G4kAmjIRZ14AEvXA/LozfOcPbs1kjjxdGMh0JYDl5dUlBc6mF7Kb7fz0Dd2TUwnytgVnl9pya0xP77VT5HySlYnWX1GyfiORDPafQVSoEionAcTAjsNCNTm3NwVHx9jPuQEULIO+j0Cq6GBSSHnWeiVPeIVZrEXIGGkP4r5FzCgyZr+zlhbv1812jFCNmfHilnWvbo0lKpsJCVmoohRLqe9sNp0HGWylP21TxTjxAC80YAE9cp4y9WMcV2K70auvAB+SVWVyUHt9tA9vSAzW+u8HHDZwopi7uKinZwcF2ml4ohC5GHKfC5yxPgSF0hok20zirgIBKy32iIFOsNSW75T666edSQgqDqVvyI2OibbcCQ0TVqooV2JA4+MpFS1Oc3ElxWoqeecZ63B6koc10V5GFYTEDWxkLR78LgvG+Zd4jCSggYhWw8xLMPtVlPnS/8+xA196GIi0g8wwbYFYMyXmiBhV96l3KWv5uJghw6T5gkRqPoWj0jgtO9CWUpyt6As7OEnT+wyQ0bkUy3G4LaaII5NGLWbXQ+6eMQLrn03AbOD1CjlwMjeV8vU
 VMCCQSgZ
 J4LO9TGWJqH0bFfuL5Bkb0dRpT5xyuQAeKpYJjEcUC4Wg5AAGi06k0GRKqwfBBLtgZYNunPRhK47mq8fg0fpMhL4L7RQpaR+e/Ks3b9Ii+I3NU0H2mp4pteZ1Potgwa86LxG17ovJ5bh9oZx9iJ0HcJ3lKrZ8FHvlc4zC7dqxAgugD3wTdg+D4vOUNw1cYUtOzf5Fl5yMs7ymXtkqLoI1a9AMoTpe8a7pYkJcVGzpemtTk6ZrJdw/w2yP8oDUR16OSyZ00wc96/9ZTm7pdXFS3k0FqNZAIUJ59irmSIq1FTTKyI+zbNqqLrYXDKfRDXjF7LJkpS/2x0AjM+kwg17ZBZmaEoXv9+lTSGE3tl4XLSL/PFPPVjQUeLHWjKJJYz6hDw5csdur3cyFQh+YIl4EWOFDZTfTdSN3SRUYy1StijEI2bEW7zy5+Pf2BTkulKa5ZhqDolOcZD24tJIOAebOZpC+8ydY+/voHUefscrz7rTg0rWHcmU+NLzHwmpYQKn7LikLZFsYks6Ifee38YGhgxUVgloK4lkTa53WZDml0bjVydnwEMh0EfHyzajqsRiYp20Qzo62h6yQ9JgN/3IhSCjCwUxDN6q5/plV+W2DeQTyx/v98O/XcDjgtg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


David Hildenbrand (Red Hat) <david@kernel.org> writes:

> On 12/15/25 21:49, Ankur Arora wrote:
>> Clear contiguous page ranges in folio_zero_user() instead of clearing
>> a single page at a time. Exposing larger ranges enables extent based
>> processor optimizations.
>> However, because the underlying clearing primitives do not, or might
>> not be able to check to call cond_resched() to check if preemption
>> is required, limit the worst case preemption latency by doing the
>> clearing in no more than PROCESS_PAGES_NON_PREEMPT_BATCH units.
>> For architectures that define clear_pages(), we assume that the
>> clearing is fast and define PROCESS_PAGES_NON_PREEMPT_BATCH as 8MB
>> worth of pages. This should be large enough to allow the processor
>> to optimize the operation and yet small enough that we see reasonable
>> preemption latency for when this optimization is not possible
>> (ex. slow microarchitectures, memory bandwidth saturation.)
>> Architectures that don't define clear_pages() will continue to use
>> the base value (single page). And, preemptible models don't need
>> invocations of cond_resched() so don't care about the batch size.
>> The resultant performance depends on the kinds of optimizations
>> available to the CPU for the region size being cleared. Two classes
>> of optimizations:
>>    - clearing iteration costs are amortized over a range larger
>>      than a single page.
>>    - cacheline allocation elision (seen on AMD Zen models).
>> Testing a demand fault workload shows an improved baseline from the
>> first optimization and a larger improvement when the region being
>> cleared is large enough for the second optimization.
>> AMD Milan (EPYC 7J13, boost=0, region=64GB on the local NUMA node):
>>    $ perf bench mem mmap -p $pg-sz -f demand -s 64GB -l 5
>>                      page-at-a-time     contiguous clearing      change
>>                    (GB/s  +- %stdev)     (GB/s  +- %stdev)
>>     pg-sz=2MB       12.92  +- 2.55%        17.03  +-  0.70%       + 31.8%
>> preempt=*
>>     pg-sz=1GB       17.14  +- 2.27%        18.04  +-  1.05%       +  5.2%
>> preempt=none|voluntary
>>     pg-sz=1GB       17.26  +- 1.24%        42.17  +-  4.21% [#]   +144.3%	preempt=full|lazy
>>   [#] Notice that we perform much better with preempt=full|lazy. As
>>    mentioned above, preemptible models not needing explicit invocations
>>    of cond_resched() allow clearing of the full extent (1GB) as a
>>    single unit.
>>    In comparison the maximum extent used for preempt=none|voluntary is
>>    PROCESS_PAGES_NON_PREEMPT_BATCH (8MB).
>>    The larger extent allows the processor to elide cacheline
>>    allocation (on Milan the threshold is LLC-size=32MB.)
>> Also as mentioned earlier, the baseline improvement is not specific to
>> AMD Zen platforms. Intel Icelakex (pg-sz=2MB|1GB) sees a similar
>> improvement as the Milan pg-sz=2MB workload above (~30%).
>> Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
>> Reviewed-by: Raghavendra K T <raghavendra.kt@amd.com>
>> Tested-by: Raghavendra K T <raghavendra.kt@amd.com>
>> ---
>>   include/linux/mm.h | 38 +++++++++++++++++++++++++++++++++++++-
>>   mm/memory.c        | 46 +++++++++++++++++++++++++---------------------
>>   2 files changed, 62 insertions(+), 22 deletions(-)
>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>> index 12106ebf1a50..45e5e0ef620c 100644
>> --- a/include/linux/mm.h
>> +++ b/include/linux/mm.h
>> @@ -4194,7 +4194,6 @@ static inline void clear_page_guard(struct zone *zone, struct page *page,
>>   				unsigned int order) {}
>>   #endif	/* CONFIG_DEBUG_PAGEALLOC */
>>   -#ifndef clear_pages
>
> Why is that change part of this patch?
>
> Looks like this should either go into the patch introducing clear_pages() (#3
> ?).

Yeah I think this was a mistake. There was no need to move the ifndef
below the comment as I do here. Will fix.

>>   /**
>>    * clear_pages() - clear a page range for kernel-internal use.
>>    * @addr: start address
>> @@ -4204,7 +4203,18 @@ static inline void clear_page_guard(struct zone *zone, struct page *page,
>>    * mapped to user space.
>>    *
>>    * Does absolutely no exception handling.
>> + *
>> + * Note that even though the clearing operation is preemptible, clear_pages()
>> + * does not (and on architectures where it reduces to a few long-running
>> + * instructions, might not be able to) call cond_resched() to check if
>> + * rescheduling is required.
>> + *
>> + * When running under preemptible models this is fine, since clear_pages(),
>> + * even when reduced to long-running instructions, is preemptible.
>> + * Under cooperatively scheduled models, however, the caller is expected to
>> + * limit @npages to no more than PROCESS_PAGES_NON_PREEMPT_BATCH.
>>    */
>> +#ifndef clear_pages
>>   static inline void clear_pages(void *addr, unsigned int npages)
>>   {
>>   	do {
>> @@ -4214,6 +4224,32 @@ static inline void clear_pages(void *addr, unsigned int npages)
>>   }
>>   #endif
>>   +#ifndef PROCESS_PAGES_NON_PREEMPT_BATCH
>> +#ifdef clear_pages
>> +/*
>> + * The architecture defines clear_pages(), and we assume that it is
>> + * generally "fast". So choose a batch size large enough to allow the processor
>> + * headroom for optimizing the operation and yet small enough that we see
>> + * reasonable preemption latency for when this optimization is not possible
>> + * (ex. slow microarchitectures, memory bandwidth saturation.)
>> + *
>> + * With a value of 8MB and assuming a memory bandwidth of ~10GBps, this should
>> + * result in worst case preemption latency of around 1ms when clearing pages.
>> + *
>> + * (See comment above clear_pages() for why preemption latency is a concern
>> + * here.)
>> + */
>> +#define PROCESS_PAGES_NON_PREEMPT_BATCH		(8 << (20 - PAGE_SHIFT))
>> +#else /* !clear_pages */
>> +/*
>> + * The architecture does not provide a clear_pages() implementation. Assume
>> + * that clear_page() -- which clear_pages() will fallback to -- is relatively
>> + * slow and choose a small value for PROCESS_PAGES_NON_PREEMPT_BATCH.
>> + */
>> +#define PROCESS_PAGES_NON_PREEMPT_BATCH		1
>> +#endif
>> +#endif
>> +
>>   #ifdef __HAVE_ARCH_GATE_AREA
>>   extern struct vm_area_struct *get_gate_vma(struct mm_struct *mm);
>>   extern int in_gate_area_no_mm(unsigned long addr);
>> diff --git a/mm/memory.c b/mm/memory.c
>> index 2a55edc48a65..974c48db6089 100644
>> --- a/mm/memory.c
>> +++ b/mm/memory.c
>> @@ -7237,40 +7237,44 @@ static inline int process_huge_page(
>>   	return 0;
>>   }
>>   -static void clear_gigantic_page(struct folio *folio, unsigned long
>> addr_hint,
>> -				unsigned int nr_pages)
>> +static void clear_contig_highpages(struct page *page, unsigned long addr,
>> +				   unsigned int npages)
>>   {
>> -	unsigned long addr = ALIGN_DOWN(addr_hint, folio_size(folio));
>> -	int i;
>> +	unsigned int i, count, unit;
>>   -	might_sleep();
>> -	for (i = 0; i < nr_pages; i++) {
>> +	/*
>> +	 * When clearing we want to operate on the largest extent possible since
>> +	 * that allows for extent based architecture specific optimizations.
>> +	 *
>> +	 * However, since the clearing interfaces (clear_user_highpages(),
>> +	 * clear_user_pages(), clear_pages()), do not call cond_resched(), we
>> +	 * limit the batch size when running under non-preemptible scheduling
>> +	 * models.
>> +	 */
>> +	unit = preempt_model_preemptible() ? npages : PROCESS_PAGES_NON_PREEMPT_BATCH;
>> +
>> +	for (i = 0; i < npages; i += count) {
>>   		cond_resched();
>> -		clear_user_highpage(folio_page(folio, i), addr + i * PAGE_SIZE);
>> +
>> +		count = min(unit, npages - i);
>> +		clear_user_highpages(page + i,
>> +				     addr + i * PAGE_SIZE, count);
>
> I guess that logic could be pushed down for the
> clear_user_highpages()->clear_pages() implementation (arch or generic)
> to take care of that, so not every user would have to care about that.

You mean the preemptibility unit stuff?

> No strong opinion as we could do that later whenever we actually get more
> clear_pages() users :)

I remember thinking about it early on. And seemed to me that clear_pages(),
clear_user_pages(), clear_user_highpages() all of them are structured
pretty similarly and all of them leave the the responsibility of when to
preempt to the caller.

I guess clear_user_highpages() is special since that's the logical entry
point for user pages.

I'd like to keep it as it for now. And relook at changing once clear_pages()
clear_pages() has a few more users.

>> -
>>   /**
>>    * folio_zero_user - Zero a folio which will be mapped to userspace.
>>    * @folio: The folio to zero.
>> - * @addr_hint: The address will be accessed or the base address if uncelar.
>> + * @addr_hint: The address accessed by the user or the base address.
>> + *
>> + * Uses architectural support to clear page ranges.
>
> I think that comment can be dropped. Implementation detail :)

Ack.

Thanks for the reviews!

--
ankur

