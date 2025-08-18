Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42C52CA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 15:37:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CADEB8E001C; Mon, 18 Aug 2025 11:37:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5E748E000F; Mon, 18 Aug 2025 11:37:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD7BD8E001C; Mon, 18 Aug 2025 11:37:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 932B78E000F
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 11:37:16 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 450531609A2
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 15:37:16 +0000 (UTC)
X-FDA: 83790282072.14.7CBE935
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf05.hostedemail.com (Postfix) with ESMTP id E8B0E10000F
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 15:37:12 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=KB3dzEQR;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=GI8GrGeL;
	spf=pass (imf05.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755531433;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K5+vNMObHDnhJxEmMylAOMOK9YkcfKY/PXAI+pobRZo=;
	b=q23jsrQA7ZC5hXgxuSyeRWFtVzajsu1MYfDQ1blud+o5KhitSwMqJsUVxZcHa0G9NSDCCb
	R+GF0MNao5cm1FNHC5153gLqmZfcSimBjq2fxtys44T0PPERw7TJ+Ooj5c/FBvoxM19aIk
	uy+ovTpONkLTDzVHUOwRvmGe42a7b+w=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=KB3dzEQR;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=GI8GrGeL;
	spf=pass (imf05.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755531433; a=rsa-sha256;
	cv=pass;
	b=RBHZr0DgeAH7bTNzYGscEEFsbXrdxdAq+9pQiVgF5wbm04e3nzNBqMG1VSvymZzBCwzEeo
	7xZy2w3TvtdO/hsA33zQ7GHYGonlfqdU/lgdHWQ67x2YAyPpjJzqupIgBVTcxB9AZ7379V
	jbTjDOFXxNhJdndN9iB7HSTz+UucILM=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57IEuINn030565;
	Mon, 18 Aug 2025 15:36:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=K5+vNMObHDnhJxEmMy
	lAOMOK9YkcfKY/PXAI+pobRZo=; b=KB3dzEQRK91BAVHD+rIkQ2XDIge09b4NZb
	fu7TYEDURrvC4HTqs/pA34rmlKSy1d7GNfOlV3iiOfFc8HUURu2HRhGc5/AHmEEV
	pSzDb+KEhOivfbqwUTkEUBDbEoy2Mg8deiEJNK1gWIjdIG11U4lgzPFXTNupcSBR
	2JZp2M20cXXQ4JsSUAHWBUrUIWnTjrYofwvI3BDeKmNMWnP2Q+EWvDQf2ze6F5vC
	g1lmdXNAbb9d22QvHJVmKboQmpt6Ri5Hoz+ghVuvSaA0q8rv20BaHnwfs2XhyjTu
	O2KewMbU0sBShkywLP6/4oXrdObazYnh7KgCupNSuhInm9W9PJNA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48jj1e3d5k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 18 Aug 2025 15:36:51 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57IEwouB016983;
	Mon, 18 Aug 2025 15:36:50 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11on2061.outbound.protection.outlook.com [40.107.223.61])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48jge95b6w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 18 Aug 2025 15:36:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sIA5oPqiMC+aVtaGQ9ywGRJuLkxs6PmVwQMoSFJzjaaZkud+9OOmdhZpA9Z8VT2kXfZ6UnTaOeq/U7ijKIQLF/K6qtse1b5EAl9Duk1K5JYqOm1UTY1oaEv95FuXkPxi+onKLpuTGoIuIBe+ZuAVG1n6XKsI8aPUTLpCkFLhf1pp5PEplQDXwWtmA4GnktbSiNPoNdV297TRBVB5vzpG5WBRgsWnrBuea2DL+sLef15Nd2QDJ1j9uiExivqAJHds1nZYAQ0XmDe8BS0kPD+1j3ZqDlWDuCaldNm5YkssFJYNVbqdKom0TZBXogO9Ash275gpr3sjaoQd2H0fEQKB5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K5+vNMObHDnhJxEmMylAOMOK9YkcfKY/PXAI+pobRZo=;
 b=vSWvZ9BGwSoghiT0QJk1Mgs/wPglKx4FuxGmfHeQiaNJuvzx0ZQ8NKBrKKDeRsn5J3TUH7iwqQ8cDwoUOjLhMVpc2j8dtp1SQDsj6lkYfP7v0pJta5fIY6jNP46m7m0tLhvxEkU3jDwekEKidkvuh4t8/5GyBFrhpcf3sJu9BdUvSL+o9zRNyLlvoQ5jYRi6zIy/sYXnckoRDmEYtCPibV5clWlcn+Yd/Gv3dC76pAnl3p59MbPLh+mGJ1Q7bG2CGyMYpiGrtOJRJEuoPxXLYSO+MrYpodwXPXeYHn4yy6pm6OvoPYvpYe8DYrHgSP1FL00HgyUpVX5sR8RO6c5pVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K5+vNMObHDnhJxEmMylAOMOK9YkcfKY/PXAI+pobRZo=;
 b=GI8GrGeLDNKw38lYQZ1qJIH8VcAuTPlP68MMc/fqc4SsLDtccdU3YCsecV4xQrlRX4mIbsiJNQcjRRFTo40gMPK0dvCQG1++2i640xCLNuuFzt1uqfUVbBrqEU+Ujtlh9LOEPHOdXP1PQyCDBuDFQHAisktl7QCbCRroAok3I5Q=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by IA4PR10MB8753.namprd10.prod.outlook.com (2603:10b6:208:55c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Mon, 18 Aug
 2025 15:36:47 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9031.023; Mon, 18 Aug 2025
 15:36:47 +0000
Date: Mon, 18 Aug 2025 16:36:45 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: David Hildenbrand <david@redhat.com>, maple-tree@lists.infradead.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        Charan Teja Kalla <quic_charante@quicinc.com>,
        shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com,
        bhe@redhat.com, baohua@kernel.org, chrisl@kernel.org,
        Matthew Wilcox <willy@infradead.org>
Subject: Re: [RFC PATCH 4/6] mm/memory: Add tree limit to free_pgtables()
Message-ID: <c8f402b1-386e-4dbc-9d4d-3e5464d2ed61@lucifer.local>
References: <20250815191031.3769540-1-Liam.Howlett@oracle.com>
 <20250815191031.3769540-5-Liam.Howlett@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250815191031.3769540-5-Liam.Howlett@oracle.com>
X-ClientProxiedBy: LO4P265CA0040.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ac::9) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|IA4PR10MB8753:EE_
X-MS-Office365-Filtering-Correlation-Id: 16e464b2-25c3-4534-ef7b-08ddde6d0b0b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?bXZ9fvXiTXOjJ7P8XMovvl0z2z4ph2Ch/ZIDH7+ZwHLEediNYY1R4syCelFG?=
 =?us-ascii?Q?dU8Xj540BVOoJ6k2lTGrXYXVLHynUomekI3NDcIXSIVDMjFAVCxMksCn0C/n?=
 =?us-ascii?Q?JmD2M+CV2ABibyd4+TL13XxCjVw6wt+BTj801QCEp3uIJMnZCIRgufBxzs7x?=
 =?us-ascii?Q?QxTlmmjMNEreJdM68zeBQCquLCuAJABmwmk2LslwUAUziL6Go8XrGRB67W4t?=
 =?us-ascii?Q?9UeKGG1esg2w+GlVTFTpgF+61hqnY0ElmwxbD/eF+kplovmh8wjkF7MUyZA6?=
 =?us-ascii?Q?nobHXGcrFsCAQRLAsh1CB7gKMWXWU1U5+2nGllgou3QqA0htFkLXWNbZ5KKa?=
 =?us-ascii?Q?jxNowAWKuaYKRcQHvxSWcGhMnU8zKOt8pc5qOOyOBRCpf5LmRJ6klGmihCgQ?=
 =?us-ascii?Q?39kt10pTv5pItZoTGRF1Mpo5zqnA1lRTeaOg7MIXMaRpUfzr/+Mbz4VE/B67?=
 =?us-ascii?Q?g1/wC9dH42lQIUeGKpRDLV9LkYvKM5++uI7P1IOcDADC3xxQRQioxR6v4qpf?=
 =?us-ascii?Q?OkgRj3WlYrbqmvac3r7McqCqtFaj50sPY8MMYQsdkT9MQ+FNEUXJK0DiXEM9?=
 =?us-ascii?Q?K2yPtNesEm/SqZyiP6kpOhTaRp9AYPr1XSvM9eyIAMWMOjRDjOYjz9eN9p0l?=
 =?us-ascii?Q?s/8rnKqcNkon1fEyZMkkpo8eKBuuUzczSgqlOHRGORioQNHMzLsBlBWburrp?=
 =?us-ascii?Q?1vBjxtOqq7ocX0hcXFjS3h4Pd5FnF9wRaBTgko1EnQmHGcEws1gVkYl+jScs?=
 =?us-ascii?Q?q4A7ZZ0EYaiA1WD7jBs4RRw4vXtHriwZ5Sri9wzl5/X+t5KAeFFBYuTfDXkA?=
 =?us-ascii?Q?zeNWH24APaNdnVLabGHYEslzLnSzIMGU0S9nknylo39OpAq0x08pYTUVZGLC?=
 =?us-ascii?Q?zgw++dOSBTqv9v/caUeDxk9E5c5/vQhqmpV+uf553z0Bwt3HkjcisZAQsL5h?=
 =?us-ascii?Q?gi6MZUdSiatSEwCGnq/DxpFl4FSFv4hi69AFbB+V4g4P6GXYviTN0VUhKvIY?=
 =?us-ascii?Q?PK9zJohVyhZOC1qkOzR5EWQci7b+Oc7vlVgzi3svNB8juvU0PSgorZrpdLKp?=
 =?us-ascii?Q?dNXEHLtHjrXbmHbGfPw0M5W33CcUBuytnG9Zz+WKqsLfFut/050rxpOjkSBN?=
 =?us-ascii?Q?hMWOPZ6KLdNfw/1TWehevn90zWjuSVMvxpq+/OcLIW9TV6Eustb7yWuXl6oI?=
 =?us-ascii?Q?G5/xFalXgRQpA0ksacLY5bOaMGLnsN3MhQMDwe+Mf3mLtKR2QV+aZ89aA1N/?=
 =?us-ascii?Q?IMfseht87rsTlNUFEoTwQ455B+A4BNf7o9epKjkOHhbY+2ewyhibfkLNke+K?=
 =?us-ascii?Q?mnNK5ou9da9kINuJk8mz7wdcS7jqaxgKaCRsXPQdJdQiCeTd9/hOu7QeldmY?=
 =?us-ascii?Q?VUdRtJvu75yiEGx9MZsxP3ZlopoenxqiNwVZqIYl3y1INfU6xwFcz8R5tVwv?=
 =?us-ascii?Q?cRt8vcR7yfo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5NygOBSM8guJAW20TNLPsVdwsAVmiVZnsDVUVoJ6gGQjozXI/mXE5VXb/Yeg?=
 =?us-ascii?Q?7p/bZDedA/hjzv6AKpKGQGME5yJvXBQzqjuyj6fMVc+/UdTifRN80KFzv8ze?=
 =?us-ascii?Q?JntrYa4LZY44iaI7uCt5daJuuxJ/rMftiNwouV/jgcQHoVK/15TWuhw3lLCW?=
 =?us-ascii?Q?olJC0cSI2Hg+Db5RFYqVbPRnzEcF2ZiyRxVm1hYelvRCKEIPFL1bZbUJeh7O?=
 =?us-ascii?Q?Xya3wEFiwUuxP2E1fGIeVXaP9HG5/+hOArEP4Py3uZYC0hqcGzYuthJMCqdI?=
 =?us-ascii?Q?83ZPoiOzDKQkqYyz73DLlsohV8XTbjsZNZj2kM0sZW9RpJKK4EKhN6Q6pmes?=
 =?us-ascii?Q?9SMvkQGYABSn69Idq3ijtmOKp5Iq9okV3wR63oOkGxRKyqBZXjZ2g/QIPfjY?=
 =?us-ascii?Q?K4L6LinicQC+FPNejT7xZSMRZlmKyEuW8QpoLMh/gR2/FI7P4KYUEEk600IC?=
 =?us-ascii?Q?LxAL++h8c6Ci/ORNCT531J+M8Do8BiG9p+BJzdniU8LSHVwVbOwb1k1F/XxW?=
 =?us-ascii?Q?1CXI6naJwko5cxCxKKChmdCV0mtEgsW4+hfwbVPRYDxnIeQxewQRcOkwLvIa?=
 =?us-ascii?Q?I+LjMpUCWSTXp4qPgABuHrJ/Yj71baRHj6vx6NMXWCySv2VRDaypAqVzGevM?=
 =?us-ascii?Q?UAH9gDEba4WYfe7f83IIcnS0uv9aGAMcVuDto4PSNw9Etv/9jF6RSmVKF/EL?=
 =?us-ascii?Q?D1VbF4ZtWswabyRuFzigMPU6cw/K+xMKopQJTH4YRjXFL+L+DY+UNFuRqQRc?=
 =?us-ascii?Q?iahKWlv9wfEhTBum1EuYL/pvMknpziaoUifo3MkXYu5CkT+IAT0vP33Ng8fG?=
 =?us-ascii?Q?UP4iCG+/vlrqqRIPqnLg4eZqKB6l1djJP7otwdlXCpFDdCnRh70A5IqdOdT0?=
 =?us-ascii?Q?lLlXEDCvhYjKv9CLj8NGm5Q8DGEOAJkQYG0qYO5Iu102JJpVLnnqWHzbWKPb?=
 =?us-ascii?Q?fLMh8SFn4gHNa/w2zp6mBxTL6+KbPOhrMaIyaLrkYklcf5u71DE0gWeeG2BG?=
 =?us-ascii?Q?di32qMHV8TDbZ7rxkaiXiP7DOx0sC7IhN41IALKDT+t6x7Vb2WzT+sl028uY?=
 =?us-ascii?Q?dO5YohF8+YwGwa0tIPtmPagOw79CoZ30eXpA3blJ1yUdC7Q70LgTxgTmR8jC?=
 =?us-ascii?Q?MyTp/ObTA3s/WANDG9kcKphITkjmsjLpwdAv2Qad3AiU48S+uFfzfSOdOY2Z?=
 =?us-ascii?Q?ty4VrZWvMoVzkRKbnD5h0biYxl74B1POL1UjJNFn5KGp4zufXVKnyU5b+O6r?=
 =?us-ascii?Q?rSaFpkYPyaP18+nCnFgespaRiRCNoyVz8YCDYrsk+1YIKTZQc1JCVMN2kMqR?=
 =?us-ascii?Q?7A3yXEOSON5GOVppz2f+3OgH0HlfZ7bLQjiCQiNfI80MBOLU+wMVigPK2zMd?=
 =?us-ascii?Q?MnEFM21/W9QybWIYBj2foaF4XKe6Lu5le/5HQIl9dPT6p6vZ6dMW4aT7auCA?=
 =?us-ascii?Q?YA546pGfWdy6mesfl1edk3G9yVORgm8AhJioYRaDiZo+Iv9SsIGyDIAXSqYo?=
 =?us-ascii?Q?KQAP1TrOltCVfrJcWrj/tueICE2aIhcdGw88duwMnEkLv3QFjohobr+thPGO?=
 =?us-ascii?Q?2VPhUMZ4zv6avNoxgM4ardhQCTvbmCfMYBMySN3VfoLAGWdoaVc6fdGwvom+?=
 =?us-ascii?Q?aw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	zajELsrMH9ER0W654paOp0APcmGPWKJ4vM54SoWrQ2palgRwJDabFr8ZkXktELZCol8x6j8Fi9hURF6+clotw+zbu3CtjVvvX6ZwoprLmZIyAAr7qt4rUIA181ma9rjjTJYCvxeC8vlgN8Gv1Gktd2cIFvkOQ52py3NQZUbxnVOldbHoJPNiHdAINmO2f4nXxsLf1x1UzhF4ghu7g0ZuYWf8tI+ejvWnge+Slj7GsFPDnSBBArxe6aE+lUz9HtFjZsG0+ZFdWBhri8qiQzHoCwocCv3/n5LTYQwhqrBeiWDzyPaGzIo99CiccJ+J3bYqTSeMYdGVAb2aO2vqPTGOqeUTDUMCkk4IZaoPqxgpQcn9Xsatk9ZmQ0syaezGxS7HoPd1IKFRMeldapjer39vSMhIaX07kJfG6Vf3WUPLTC4Yv7Vsu2HTH8dYE6FZ+QCcSxZLIQQtIgjw9RBai8r7r8qFoGTnq4Qs/7XvF8Q76yYyUKABva6u1SfLp8PEZPfFThpbK/hSZIBXQSiqablkPE/KEbZs/u/r/qAui0L7xJ5RGyEnGyyYBPRQkmVpSy4hkSc9OpTVSZsaN0xyaVMMemBLzXUV6EeRtBLHEF30P4A=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16e464b2-25c3-4534-ef7b-08ddde6d0b0b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2025 15:36:47.5258
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uUpZfPDFVI7k3zvBsoHX1WNQ4Qr/YUTQgj8haKYkzPSdos4PS9A8OUlfr0LxFW8nFK0rPs9UmCyxqsNW55MW2XtO7LzqoJvwZUFvFXnEojo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR10MB8753
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-18_05,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 phishscore=0 suspectscore=0 mlxscore=0 bulkscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508180146
X-Proofpoint-GUID: rWuQrBV2CRfntMM-p1TPkZxx5wFE_G_a
X-Authority-Analysis: v=2.4 cv=dN2mmPZb c=1 sm=1 tr=0 ts=68a34893 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=-SeA9mL_BQxDqygC5f8A:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE4MDE0NiBTYWx0ZWRfXx0AQC4Pv+75A
 EWTh3NdXnOKknkzGLutsxxi8F2MKNLDNwdxr68PDzwviWOiDoI3CI5uOQ0VMww2sAjaCvW0iH6u
 k2+9SsnF8i49gaO+UwgtEs2BAZ9RGQdALAeG6E8XoU5xJ6EuTMzzotMo0KFIPEJbiClvF2HlDhl
 /XopYbG8KyfuUbKiRMtL+dgtY0pwbbJRv+7RtEHUm9EJMlDkYhYZ8DD2UEale4B3ze4Ea1KbGom
 l+QnUM6qTvOxrYJdohZCSvVuCuLOCKxanJfmBR6gprXuaDltlzCdh/W1AdMKisnNm4yL7+CAwtK
 ZzWnRtHoBsZscKKqb4sGVMkosTzys11yxt9bu1tojLmmW+JRIvBKJxINuknIgEgLcxgu3TElrqY
 wFs66WYbUaHd9z5qPCJh9grHZxARmKQg6TuE262OupL432TMbmm3lDjpgxhjqycEFn43ULr7
X-Proofpoint-ORIG-GUID: rWuQrBV2CRfntMM-p1TPkZxx5wFE_G_a
X-Rspamd-Queue-Id: E8B0E10000F
X-Rspam-User: 
X-Stat-Signature: eijektoiywwotip76g6yr9oqizz4onz5
X-Rspamd-Server: rspam09
X-HE-Tag: 1755531432-468036
X-HE-Meta: U2FsdGVkX1/dBBSmdrxYhIn+0IRSOWMhYc0xzPJxxERhmHL0b3HSqtx+blmXSh83dUE/1MPnIsUejElwYJDuj0SPyuGzgNqLsEubY7wEUZFE6Cm0/Qt13DblSmX+XrKfs2Tcd2OJnOfRKtQ0yaucUD+mxo76EsIf86Nyy21u2d4Qt9hm43ri8iCQBaBJDlx70KdpwP9QycYY/bwrbQ+wDHhN5TbXfib6mQQixjUREC/g/2yT8nGvl324jm6LK8TKL0gb1a9w50XC/unoQokCnmAF+rN6Awpr4LEiRhDYqv8OvTZufyHRC7Qt3Njjnh3XgMiQeG1M2M4Ee/yg6d9j7R/IqLHWzRJPO61JAEvfWq6qMftqnl0ACyShYoNvZlnk431zaMdgyE63cEub3R57BXrNIgXDbsMJr0t3YnJmf+Fj+RdiojhQZZwQhNsG2uTNZ9zzbX0u2eF7Kh1KKH4q8diYCzCRxyAPPdv+/KyWE+aBmNH8oFHTP+uG2av1aP410ehxsv80tsgT04gWbWkqKheHt5Lm5UrT+M14SJe4MF/pRxhqpUUnhPF8ebPNqDdrwrCKWk5sAY/8M1eF9iBIofFhM9YLUyg2jOaH6wb8T3waAo9jITxE9Fl3CwPxNnDZHjP99EEl0C3h3n8v6c+po2d8wpx0nvz7hemlxVHOZUCzwzIyPU6Oz+MJoG+q/ZgGicITGgfMmJm9+SCBwITbFbskkn6X9yB5NXjmUSZBy6hP+1cdUMzu6wLCrs1YCpfKf+8BUmvjCtCGaEaIA5G2Hp4bOPzsHo0C/v4HlKXl0TqqWipLmlProY8N7j6wSIhbfTxFPwTJ+rt95tBPbcSEXMBjJXoRm3FuZ3uLDPKa5XZoVaTSM2P9EVlO2DPX0FlaiyHabXLPvFai2/ii/Hrb1Pjhbn/xDX6aZ6MxAia6SQFHQG0DxHwNhJBf4r35MPS9l2JggpZ6j4awJsm2/lZ
 A9Jlbk6f
 tRpP45AH2qhpS+VSThsa+p6PcoFqrqGqdzgysf0DlsieL8YowMEZ/par1T2EZH8tcGNppaTBkTyFsXMw7dejRjNxHlkJREyeQBlU15vm1GM8oORCfzBasLfeHweAY4A31JvmmxXYXXuQz/oPhHko/XwTLSe3FxEBLlTPSCa8+1hBTbOKtHo9mi8MRajKTtYdcGl6yTbFsNCdV+x/nisU8ZQlKNvj9KmkSMoTCjRj5YCwLZCz9GQ8etMJZe9Ldlf9nYpjdQ3pH4XoAUe2suv5AIFPGmyBOWHclkwQ5UKtosulUDxu/0ScFmxjmr5EcRG/LqshrB1OCAIGkiguQTMlH9NU67g1luUbvNmbJag8wfEJ2O0uJxGk/6x9IYp2cmNgZwTj6flVT7yXIeVrl5HXlKcif3BxlJwAcDAR/+dJ8QKRJ9ExAV9YCfcMeKRkoWa6rJ2Jq5fL37xZZOi7F/ftQWpYtTocxfDonYfaiKXcqMYCtXFECE77QTjRly7FUYFligyla2P9xZ99EDPzLIWjL+ZYAbX1Npo0Io2PvI9EYhP23uH6tnyVz2W9Dh0VCOElxYQXIl3b/awethrP9UcdpCHM4VjVV88TRsx7VVFBufdit5CZXp+nqdnlC/LF9xQ0J+9L5h/nHc8tnMLWPZTH0dTZ+PdImKgusUtVuc5ZqLIQGwMcTQjqB4IrVISVdZ0ELWMKNr7AwhJjwisVg9j6fNiPY1QtRwvxKim0JE2CoYUCP5Jfce0hXRcahwzHl/USe8zLXJalhIHdun5vyHAPHjRNtJg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I know this is an RFC but to be mildly annoying, you need to also update
tools/testing/vma/vma_internal.h to reflect this as this causes those tests
to break.

On Fri, Aug 15, 2025 at 03:10:29PM -0400, Liam R. Howlett wrote:
> The ceiling and tree search limit need to be different arguments for the
> future change in the failed fork attempt.
>
> No functional changes intended.
>
> Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> ---
>  mm/internal.h | 4 +++-
>  mm/memory.c   | 7 ++++---
>  mm/mmap.c     | 2 +-
>  mm/vma.c      | 3 ++-
>  4 files changed, 10 insertions(+), 6 deletions(-)
>
> diff --git a/mm/internal.h b/mm/internal.h
> index 45b725c3dc030..f9a278ac76d83 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -444,7 +444,9 @@ void folio_activate(struct folio *folio);
>
>  void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
>  		   struct vm_area_struct *start_vma, unsigned long floor,
> -		   unsigned long ceiling, bool mm_wr_locked);
> +		   unsigned long ceiling, unsigned long tree_max,
> +		   bool mm_wr_locked);
> +
>  void pmd_install(struct mm_struct *mm, pmd_t *pmd, pgtable_t *pte);
>
>  struct zap_details;
> diff --git a/mm/memory.c b/mm/memory.c
> index 0ba4f6b718471..3346514562bba 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -371,7 +371,8 @@ void free_pgd_range(struct mmu_gather *tlb,
>
>  void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
>  		   struct vm_area_struct *vma, unsigned long floor,
> -		   unsigned long ceiling, bool mm_wr_locked)
> +		   unsigned long ceiling, unsigned long tree_max,
> +		   bool mm_wr_locked)
>  {
>  	struct unlink_vma_file_batch vb;
>
> @@ -385,7 +386,7 @@ void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
>  		 * Note: USER_PGTABLES_CEILING may be passed as ceiling and may
>  		 * be 0.  This will underflow and is okay.
>  		 */
> -		next = mas_find(mas, ceiling - 1);
> +		next = mas_find(mas, tree_max - 1);
>  		if (unlikely(xa_is_zero(next)))
>  			next = NULL;
>
> @@ -405,7 +406,7 @@ void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
>  		 */
>  		while (next && next->vm_start <= vma->vm_end + PMD_SIZE) {
>  			vma = next;
> -			next = mas_find(mas, ceiling - 1);
> +			next = mas_find(mas, tree_max - 1);
>  			if (unlikely(xa_is_zero(next)))
>  				next = NULL;
>  			if (mm_wr_locked)
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 0995a48b46d59..eba2bc81bc749 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1311,7 +1311,7 @@ void exit_mmap(struct mm_struct *mm)
>  	mt_clear_in_rcu(&mm->mm_mt);
>  	vma_iter_set(&vmi, vma->vm_end);
>  	free_pgtables(&tlb, &vmi.mas, vma, FIRST_USER_ADDRESS,
> -		      USER_PGTABLES_CEILING, true);
> +		      USER_PGTABLES_CEILING, USER_PGTABLES_CEILING, true);
>  	tlb_finish_mmu(&tlb);
>
>  	/*
> diff --git a/mm/vma.c b/mm/vma.c
> index fd270345c25d3..aa75ca8618609 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -486,6 +486,7 @@ void unmap_region(struct ma_state *mas, struct vm_area_struct *vma,
>  		   /* mm_wr_locked = */ true);
>  	mas_set(mas, vma->vm_end);
>  	free_pgtables(&tlb, mas, vma, prev ? prev->vm_end : FIRST_USER_ADDRESS,
> +		      next ? next->vm_start : USER_PGTABLES_CEILING,
>  		      next ? next->vm_start : USER_PGTABLES_CEILING,
>  		      /* mm_wr_locked = */ true);
>  	tlb_finish_mmu(&tlb);
> @@ -1232,7 +1233,7 @@ static inline void vms_clear_ptes(struct vma_munmap_struct *vms,
>  	mas_set(mas_detach, 1);
>  	/* start and end may be different if there is no prev or next vma. */
>  	free_pgtables(&tlb, mas_detach, vms->vma, vms->unmap_start,
> -		      vms->unmap_end, mm_wr_locked);
> +		      vms->unmap_end, vms->unmap_end, mm_wr_locked);
>  	tlb_finish_mmu(&tlb);
>  	vms->clear_ptes = false;
>  }
> --
> 2.47.2
>

