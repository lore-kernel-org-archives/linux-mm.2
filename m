Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42486E9A033
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 18:27:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62F076B0088; Tue, 17 Feb 2026 13:27:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B28A6B0089; Tue, 17 Feb 2026 13:27:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43F296B008A; Tue, 17 Feb 2026 13:27:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2A2096B0088
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 13:27:20 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B905A584CE
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 18:27:19 +0000 (UTC)
X-FDA: 84454780998.01.4EB0569
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3861E18000C
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 18:27:16 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=p4xOgisw;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=J5QbXwwo;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf24.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771352836; a=rsa-sha256;
	cv=pass;
	b=1h9V29M2yq6HgPBNzBCk/52AQu+EPWLUoc/Xd7u4pzapeIxe11+2Z+D7nrS6zyhc//zYkk
	MwJirce/jnp0mhiL72d2n4mY97TRagwqBgkpOxc411d1jtdcXPQ5OpHCBPTo7W07eCv1sF
	rX2km6dLcTnZNTJOPR/q8YM2h0oIhjQ=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=p4xOgisw;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=J5QbXwwo;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf24.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771352836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y7XGOpST/2qb2IafhoTaIGdIq9+h+cWXh3MKvoF8hKE=;
	b=DWAatORUTITScBIRQpizWdbAZ1/sxOzmCFvLccwrwQbgRK5WekYqUmUaInrXgSGFXCvMNY
	rJTG7lh2rr6hlBMmeihXfNlwn/kzPG8tb0nCio7vNTMK5dvWJzGggqdTtv90FGnRmXYe4q
	wyVgXLCBA80aWeNkxhtzNWB1NV/eXrs=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61HGNLdD3789037;
	Tue, 17 Feb 2026 18:26:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Y7XGOpST/2qb2Iafho
	TaIGdIq9+h+cWXh3MKvoF8hKE=; b=p4xOgisw/vIOSRkXbcKDpKNocPP90lQsq/
	S3ys9ML9Lkx9hDO8BekAvblMhfYDbh0FR1OCSErVoPGP0LtDcPLFH/aJwc/Pz+66
	Qp/COtpSI78eYj7Lpu70xm3iRbyQ4H+L8d23ZvnfQfdn0b+IpCI5xNmgGwSDztdz
	PCiv5MXdmq2TXGa5EkhhjLJHHj+r2fgfgtF0qxfcdAT2szsyhvUBv7Au8G/EA6ag
	DJBjiiftK0FbrufKC9AFA9P4OHCctmVYRZADOOpReTnSC/ncUg3jnRZ7ioAbONXC
	k14xcHLpKO6Tk8Vswtf+VkmZWaBDBgY2hRgA+rFqSX1rSPe4068A==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4caj5r46p0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 17 Feb 2026 18:26:52 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61HI8o5T022914;
	Tue, 17 Feb 2026 18:26:50 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010026.outbound.protection.outlook.com [52.101.61.26])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ccb2cjyf7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 17 Feb 2026 18:26:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FiFSWdddJDULKaeFcJY1+wbCaWnoDP5oZ5/FoPpv9JqrLZspHWoYGwMgmBl06YeRmj+hBcocXlorn/IobeLFZsfpElhh+/rcbY7njaEhrBjMsRsA+4DPxYjkj3W8mVIlBBPUEyifa9FuyzukY9N/tFNUtUVdv9OkZlZjiGRGr6NSdQj2jKyVgrnKgff4MPaQ5Ts5Rcpf1ESBLx0oVy5ZiEoe3O4vCKLtK5lUo15J2bOlMzG7kHXwnmP10rg9H3BSgtaPq/nZvs3x4kWSY92TuVbiJ+a698g7b0S+jgrF/lOmvwD/MDBkZpGqRVBFS6p44k+cBpXEFDOSeWoDK9YfgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y7XGOpST/2qb2IafhoTaIGdIq9+h+cWXh3MKvoF8hKE=;
 b=qLPFD1MZzPFSdS+yB5p7bVH/3t8rE9AYaQNyDTrdy7O2d3kaM6hy1PyxKixSRB5g9kz/YZJWKv+6ddS/DZbN1C4xi1Q3aENs45JJAV6sFJuvnIOkXcTPhRhkzfH30AuFMH48hkAq/IvdMkbFTNmEAzb2uo0Vyn9TYFUzen892RCdwU0oQwdiLuxqCegKgKbkl5V8tCbnOnY2hjtwd6VARc6s4s6W8yvDKnVeYjSBgiECUd9tcS4IfffGFawwtJrf+/4RILIeR4Cln3l0IvemHrHsuvNBAm4wuqZ6Oq9pCsUgRQ5slHeKIcoKezGjlOkruFqcWVCq6A669zOUqPrxcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y7XGOpST/2qb2IafhoTaIGdIq9+h+cWXh3MKvoF8hKE=;
 b=J5QbXwwowdAV7g2vKUlNl3s2X+R+n8poix5U83loRTsuwCbgcmPa/uGaIuBErpD5oP/O2f3LVzJBj2nXzkoRDoXJOVKwpOkwHoTpUB+OanHOsoPRkg3SzQChwCdGvULrovnoNIWywF80Pnr84skdHYOw6eepn7LOnRH6IRSzgh8=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by DS7PR10MB4863.namprd10.prod.outlook.com (2603:10b6:5:297::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.13; Tue, 17 Feb
 2026 18:26:45 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9611.013; Tue, 17 Feb 2026
 18:26:44 +0000
Date: Tue, 17 Feb 2026 13:26:39 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, willy@infradead.org, david@kernel.org,
        ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
        rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
        ying.huang@linux.alibaba.com, apopple@nvidia.com,
        lorenzo.stoakes@oracle.com, baolin.wang@linux.alibaba.com,
        npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
        baohua@kernel.org, lance.yang@linux.dev, vbabka@suse.cz,
        jannh@google.com, rppt@kernel.org, mhocko@suse.com, pfalcato@suse.de,
        kees@kernel.org, maddy@linux.ibm.com, npiggin@gmail.com,
        mpe@ellerman.id.au, chleroy@kernel.org, borntraeger@linux.ibm.com,
        frankja@linux.ibm.com, imbrenda@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, agordeev@linux.ibm.com, svens@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, linux-mm@kvack.org,
        linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v2 1/3] mm/vma: cleanup error handling path in
 vma_expand()
Message-ID: <hoezvrhluigvmhklz5mn36wghkzzi46migabgqa6ipoefdreyv@ziljtzlif63y>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org, willy@infradead.org, david@kernel.org, 
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, lorenzo.stoakes@oracle.com, 
	baolin.wang@linux.alibaba.com, npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	baohua@kernel.org, lance.yang@linux.dev, vbabka@suse.cz, jannh@google.com, 
	rppt@kernel.org, mhocko@suse.com, pfalcato@suse.de, kees@kernel.org, 
	maddy@linux.ibm.com, npiggin@gmail.com, mpe@ellerman.id.au, chleroy@kernel.org, 
	borntraeger@linux.ibm.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com, hca@linux.ibm.com, 
	gor@linux.ibm.com, agordeev@linux.ibm.com, svens@linux.ibm.com, 
	gerald.schaefer@linux.ibm.com, linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
References: <20260217163250.2326001-1-surenb@google.com>
 <20260217163250.2326001-2-surenb@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260217163250.2326001-2-surenb@google.com>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YT4PR01CA0479.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:d6::19) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|DS7PR10MB4863:EE_
X-MS-Office365-Filtering-Correlation-Id: d4bb5d5d-b821-4a9d-1d7e-08de6e521aa7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?if6iyZ5xLL/g2ZmdjTsuuTNwt2yAu0VkwKolmIRgupZZW0y6AZUpAHvraRgd?=
 =?us-ascii?Q?f455fAbz1jyaGlJ5x9xoVaSrydfnFIeP2waw35zYqSubabY9IVqxih1fVMgS?=
 =?us-ascii?Q?CNAGLx575JotGLVmY1y/StoP4fjss4euW/RD1l2EvddLnGzogPZS/TCrpFTr?=
 =?us-ascii?Q?eO1fxYUmLT4TMGQR+pUkU8nXJTMH9S0bFZRfqenYw7adTfeJ7sxu8bcczoyg?=
 =?us-ascii?Q?i7R8n6x368hOS2V2Jif4fOiwb/fWMXOKMO5adaaJVobOt9wFUJymFerskwcy?=
 =?us-ascii?Q?8bZA7WyEGs9WAFYYE5wI++62G0UMdVedafoM5Y4s2ShYGtxZ5KdtZOUchku3?=
 =?us-ascii?Q?nxe7bdi5aDAGMFzA6f5u4XPdWWkHh/9fgz2Oaht2DetnN7kBFZ5Rn2eL31Xa?=
 =?us-ascii?Q?iez2a2OjGpkxuEyBlpWRYBsX/3E24Jz+qhkA2juDze/lY4uhBHPNJHitTxy3?=
 =?us-ascii?Q?vxq3qXKtKYmgLjJNm+zK312RjC1iWnM4AeAL4q3EGbpswaH92KSP84tmRZGn?=
 =?us-ascii?Q?8ulg7TK85nOoLar8Jm47LZLlOqsngruQcTWNL7fMx/mm+kZ41wxhMq9LZBvm?=
 =?us-ascii?Q?K3AqlFzwcFU+JGX+H+NNxe5P3rFJfA7bjYvG+5PsQ+1Cs2cdZuwrB15UOqWv?=
 =?us-ascii?Q?nCp9fFJjCP7KS6odTsrNEYUewcQWK2wfz649DljvrObhZubgqdATkxk/F+Tb?=
 =?us-ascii?Q?1iQrijsN0r3yuFatfoIxafnlzc05ZNisj8cJPtShdxzlyTvt8OYJ2Jk9KV6S?=
 =?us-ascii?Q?jtYuJxu5EuKCDLy1Mj10ghbOr7g49SIn1Jf4R0DAUaGTD+mDLrVuG+z5VFah?=
 =?us-ascii?Q?c387ZdzpzkKn811cdrNTJcNMC5R+ZlSy3rlvFInkMToYz1ONVWeocLPNudRx?=
 =?us-ascii?Q?C2KN1nqmlWZVvG7A8syNKrGfQmafLdZyfSzIfRS8NJpFBlD4rQVn7rUYv9/c?=
 =?us-ascii?Q?rjEw/8TqrDGBe6ZS43owMwzVfu3A1zxFPqSgOjjm5tepW7slVlXFk8d19hiO?=
 =?us-ascii?Q?uOzZjrRRfD5MFgW3YwV/aagx71pis6iad7IBhBD+z/sW8ECSdPFK6XmFI3xa?=
 =?us-ascii?Q?Kwy0Qmn6VGblnr6a68e3uvoYOUUx/4pzPDkyyqe93CJRqfGsTJaF4gdOpFFz?=
 =?us-ascii?Q?2XzNZFDSczeTt7IiTpL7/GAvciMJL5Ff0HUcmELLcnG2hn63/Z25FqhQV2zi?=
 =?us-ascii?Q?ZezxHPKGyNf1marM+8jIvL3CvXZd+N0SaOzY+TGKZaNkYsuw4Thpsv6TxP97?=
 =?us-ascii?Q?FSN41u/7IBeL2Rk8fq1aUfXoAlOmhG+moyq32PEPAK+KflqfQaHd53FeNp5M?=
 =?us-ascii?Q?D2HkoPeHwP+Ac96RofL5UkyIyVv8gpotmrRynP6lCfb52Rnt/lhcfr9YlA2m?=
 =?us-ascii?Q?Z8IpGN7Et8ghBujt8rNaQb62QLfj5izHlDU3PB2W847NjjYFgNc36Qsb1pqk?=
 =?us-ascii?Q?6wSk6t/QyVd64lzz6u8opFinCfyWPIernawflqJ7hyGfPi6IUmuTebzKD6p2?=
 =?us-ascii?Q?/TAUbf1RhEGDzk0FiqnSo2Uf7PTONe0WY/BT1i4TuJRTNKD/STgjo5QfW+Pq?=
 =?us-ascii?Q?QV9memHL+M66EEePN5k=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?edM7PQ6PrGNv/k6L3OofTJeqkLdKi1xIs1vky6hij5Uof29RLptHtS71NOYZ?=
 =?us-ascii?Q?6bsYCCWpXd/nm1ljxVnNs1o/hK//14Dn8H9nWWBBvF6JQfXpe5DzfwZ4Az6B?=
 =?us-ascii?Q?2FU1hDRweJt4STKAmBX7LrarELQl3y4lBjF6ooWfi2DIYDcJKpKWOcd0xhDp?=
 =?us-ascii?Q?VeRsiKGZGrgVTfddW0SMTIQPbbIUL/Xx8QCimuKbyyQkV3yx81WQKCplvhpG?=
 =?us-ascii?Q?30t38LPdKExNXPSi5OU9gE7byAtut3gewXCAPIQisD2lm6Y4iLf/8rVUZY/D?=
 =?us-ascii?Q?bcYPWq4ckpr1ECRPEH7OMb6tkLIzjgUqarbPutxaIkn9mKbSF5OJCUfjm446?=
 =?us-ascii?Q?Yqi6RUehVkzEqw82k8dKDYmoJaPw0/AkbyXFu1DmJtLxOztDPWbMsgJPJz55?=
 =?us-ascii?Q?vyXOGX6t/g/e07jaFCl/Qt7QOD71eQlfMMsmMHm7dD/jISonk1Fdor4fKkyI?=
 =?us-ascii?Q?Hm/CKnA4k1PCqL0Z6Fu75htOlVDFY/bOpEkVFoFZy7G+bEjTfD9IGZy5cFOt?=
 =?us-ascii?Q?e1mIUDjqqE46MBnbIMFE6rwpAPJHAxxSsy74wh6SpFuKU10/v+u8U4e1PClW?=
 =?us-ascii?Q?JocXL4ORtBOOhN1P0mXbC5RTJGzX2BZHqoXEBdvUrdWQhDJ0Uk/IOaVpyiT7?=
 =?us-ascii?Q?OE+NHNrl646QGZpu9+EJLU9KFg09C9YQioo3Az32Xmy91x4evhcVYH7XPM2B?=
 =?us-ascii?Q?ptuyMmqzctXav2+lJZmQ/2SVwR+9Sr8teDrPYaue9nTNjK6iEvz5ECvo2orZ?=
 =?us-ascii?Q?Oj87HoQVqCPeYFMLSaCusxVNe0iUJQoIh+VjOE+J19zLtGXXuYPXQ7P2hf1b?=
 =?us-ascii?Q?jcLjZACBHsPIACfX3IY0diXKFCeNjcqM2zSyzwoz7BAfA4wxmkHOOS4n36eV?=
 =?us-ascii?Q?EocHjB0HfMO+0NKVl6ti834p0xhHjeiV+gjslWVDzrNZzn8DNwvsLy2qyMfC?=
 =?us-ascii?Q?ExhQhU+FtOH5DJczyFvcXVDoJaXx7OMBDtJhow8sbOpXRWS8TQz5alHNt68P?=
 =?us-ascii?Q?hbwdM/OSIuQn0aNpjBtnaOOfp2l62DDQ7kRD8wbzruQcsIr1T34lw7tQRUOn?=
 =?us-ascii?Q?ZwQq17LMt458qjZJIdnrQi1sMFxoosapOnbWgYHTu1HCfPBKGOWD2RhgWADD?=
 =?us-ascii?Q?CnnqlEolAUa/baLCTHPi2qKW/N/1PAtXQPq2Gq6k/IaP31HAwE9qyU4Ubyc5?=
 =?us-ascii?Q?SdAuQyVOoN69E7APKU+42LTHdF9jIDBjzXuA+T48V/qNfumoeD+1mqgSeH71?=
 =?us-ascii?Q?jVLXBVBW+cejVGBaRfjEUcRHqEML+Q+D66BNcTXeMakCyk2R6xpqJUtTPY3C?=
 =?us-ascii?Q?xwOw4wGcN/g8ngnSndOi3PveUMgtQWDfucOiT5Mls+NuqCDj2kGQFp48H/Tm?=
 =?us-ascii?Q?r9S1rOIOSvOPv4NtG7QVYtgUbQtOPDj46jwqf56Re/b6DyimlaG6L8aenCls?=
 =?us-ascii?Q?225OJsRsyoqMCnmF8o4zI3cVaCTvp6ZfG76VlEypnMun8OLwqQ3MUGWOmtgO?=
 =?us-ascii?Q?y0dxTofLzbP7KSf8+32fw5OCdknvovLzByWG8QhN8ngxUuXOz7Hu4e2dhwI+?=
 =?us-ascii?Q?cXoiWkZNcARGkqBFRYsTf/bI6ABozVyQojGbZvVacZVxBMiVvA/iiNMhrraN?=
 =?us-ascii?Q?xoXk04GeQIRLVwd/u2Er7PBzs5qO+Xuk8V4SfzKyT0eKcbf5ozOjOF+rYtrS?=
 =?us-ascii?Q?EjijqgdI1tBa1P5/wI9gWWEh6WhCL5EfEjLxfSBzZEDqRDDGAixF9bVvLNfs?=
 =?us-ascii?Q?ZVxndt9Wow=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	MDpP9Yi5A2K4TayYT/A2+3h11ARfBSFQqWYWKySZBlReJgTzymRPlB0eSGH7Pdo6v6+IfEexpubJ+aNChHnzDSYbVJWN9OyyJaOp5YwDoHZrA6Cq6pQtd6rDZU5JYlnLDyBYnDVU7Uc5opgScIhNEQ0tS8NnKKKZfsrd/RQxsIwrBaIsZ+HRwHrlAIYkeIvd/7enKgQ6q78W3nx1czkdxKfPsF1sYuHSravpUf+bLFaacFKbUfMflBxwrYG2oiYvl4QKMP7BP6ZV+HiVYoDrZrkbI88qiJzv9mmQEdcwQmIjvK8t8N27G6clOaRf8/yGpt0nFkthAQjn/PdhHCaqoAmVjK+mmiFRJKEnjRK1zwG9WyXTaVHktW0WKylvaf4HmL3EQAXzLMIAtYzn77cAgfFOp4F/Ej+YaHuzWIFJ6Hv0KSxnD9L5dtmwup9b6WLWIpzL9PKRv++XsOFqO8ri1DP60yOcGtN2AJApPT0Kdx2wMqFUfJVHqrvGngor6/zebgtyB420UUz7J5fw0KbxMwlcb3z4Ernw/ADhB+nrYxgn8q4hioj83Ez/AzGfhCsxxzj3qQc2XF5qFV52GDULRH1LSK2zGlV4ppmek9G5X0I=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4bb5d5d-b821-4a9d-1d7e-08de6e521aa7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2026 18:26:44.8278
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LiU2hlZl33imna0qK9/TyAlfuR5jKCS+WCawc0hy+JFvFyLe4OPKRa6XqZRSmTKwUP6iFkOipUVuJQ6qZMbXqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4863
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-17_03,2026-02-16_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 adultscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602170150
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE3MDE1MCBTYWx0ZWRfXyxQKPKLHHUXn
 RcL7ydngSetFLID/WVFy8KbNurAqiP2+PFPuCtfKkspovBNhcACJ5SGMH6ndwFUw893zukMKZUF
 ebv7Y0Bjpa3KNIOp0KK5+Cp1i87RFG7W5A14yIcKPN1KNJEzX2onvR+iPNjTAL4JFvnjhF2mi3b
 T69XPPmT8LNbUyMy2RUhCXGW0Iu4AcQIPtAWtFnNg976EBu9eww+F+zeeOzQGwAeSidq4j3XvzQ
 fxcX2MQtvMrMt8ozkw/OvcmP00ORMenFytDA8ng3GcVPWCnyJn2UucHKEdU+d+97wfB7IFLa7RN
 XkbJooQf0/vQ4M/VPcG/O3jpzD4b4mfdAOgy681+VW5wlFANpCYcmsXiqPttQfzFPpXfvm4/8fl
 KEAuykdGhQq1uF3E+V/+NHLfy/3aCWX7T8cdPYbZYQq+tcebyDVVOMdQczxTBymriOLM9wdPUYP
 FABVhsU6j3wUWOAm7B+zCJBrblOYZT/dxAW5gyPk=
X-Authority-Analysis: v=2.4 cv=Saz6t/Ru c=1 sm=1 tr=0 ts=6994b2ec b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=1XWaLZrsAAAA:8
 a=yPCof4ZbAAAA:8 a=OF6kxwJpqsOYwMMz9xMA:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:12254
X-Proofpoint-GUID: rFW1u1pdhtmWnT4patd4s-6baux_Btus
X-Proofpoint-ORIG-GUID: rFW1u1pdhtmWnT4patd4s-6baux_Btus
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3861E18000C
X-Stat-Signature: wp6a5mmiunj9ezhzw6uejwxan9x8g4cq
X-HE-Tag: 1771352836-306
X-HE-Meta: U2FsdGVkX1//amu/MBNd0z0WnuokSET3afqYBXaZRRybGDra/ssNUGcwcicD2cyuEzfyo5mgpsrOE1lV1DkXrlwarciM92YnhNStrDsHuDIqPUKP4z2M9XeIAVTWiDMCggkT+QH9vrhQe4+0PvYdgO8KNVZ1Yxi6k/eI+/X1m7AL8xr2ffRrQEVyJllAySHn5SP01MjmFwmCfoZeuXcQJ/2aCyC7gRZ5SllyHIbuTVi1367Uj7GMKQrqxNOBM49AUgJo4R7Ph/w3nnFmPAxZx+6TneY0ah9b2MCslnMxD1QtRLGNIsiWwatMjacuFYG+dN6ErN/T80Mq6YnVoE0y02hWoLwqNnu1wB2LYx8ek4IaJGO2Ru3wd6/OGpE5R+hG9oy7QxajrM1FnegEuYZ37gf4s9eVgw6lwctlvZBUnzxtvqe2xF35FXvuH060lBamURpC1BJUYiXystQPPmznz7M1D6CCO9Ps/8CpeP0JGTI8VlcDQ+/D4io1ygjrWshK5BuWp7qBUX4YC1U1ptMhNQNs17+Tnzl4hKDo8p7Q4fUqL4xFyYhWYJkI9CtZ03BXz61+7XfKsOwDQvd02Pz6aDRaxjV4FWOr4ORtxQU42UctTvqHGXYawqSKLH/zB225/Kx4sGHFptEarOoFd6167o5mjNG36ZFGqv3eOrk8NaVuE1njydilzSPYeifZrbLuygp7u/3wbHAOjF7HQbTqs6OZaTl7sck955QMoIEiV/npeKMccQF9nuQdJgZDL+tugT6ps3OEjrokjoOWTGooSzkDK73umlLdiNYGLy92sSi91MgAzTQ4NJ7g7WR8f56rm8V+05S/wKYEqQj9OLhYD6zrD/lsmlX+E4L3qaJlyg4m4gF4LhfEu1hUidLfw/lGfY+bjLzKaiNzfRJ7WOrdKJ8oBdjUGbbzfSsDzgzeOVzzstkFb77HqSo/mcxSNzMY32/yzcKvjM5xoAweLhx
 DgV+1EHx
 qgacj00oZmpJfaAytdVGoDL48h5ETa/dwhC6TAT0HK9XAlGJF1oavM5c7gO1Hom7j4dPn6Pv9pyaML7sFTWyPDBSu7Y0OvnhiTW+R9snVdQxfs6LD4V2rR9Zx1hMQtH4J/T3D1gkvhqFykrIEWhdKk4fht7wsAqMi9tKGSkJeIB8d2ZnFMScvdGWSU3eTGNRbM11ODG+zQkDP/1PxYmMVL31BOVscRS4iYgRsmQLEouJZSL4wkEQ3JWWhykKOCAmCA6MsyEf5xfcwXkwmIjKCJWFwDDXSzrnRdx084Zi0sFY+souKcOxhxiNJNeAPVrk96RvC8ssc/vhNabjUBF7y5ntIqvW1SgImJoOVWRqN/1El197jQk674WfNGcJUrxvtLnIUCyWrYw5kqru9PW0PBLfHre7Wiu9qeSAVW8lnWJua0mpPaAmhabsyBdvXv+Me1a/oDKEmSIiuJrozvYmX1wVXiFAa7prX66aZtAUNCQqoiyjOSzLnZC+V6jaMCJscNBsvWl4IaNGSm4Oj5jmptZQkwTmhr/RhQdF8vSTJuD5e/SiHlsE09pO0xpoP8rwSZmSNe5rJwcLyoRU4X5r7JL2CW/g1d58QYksGLM9CHdXVLGYsyHCQI3JkHwq/Jbo/JbNHxwMANIGwOtth3ER7L2C56KgPGp4LAqnjY95VCr07nAhGq7nEm5oo82gklvJ91tyv5yxPIet0iSsOfaQwg0P0MOmST/XzsjCk2fNvDDC0mdnyeb1HL9CJ6ta99W3UJ3x3QxSRmPQoRzsJ7uUUURZA5kDoWqmHF16q
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Suren Baghdasaryan <surenb@google.com> [260217 11:33]:
> vma_expand() error handling is a bit confusing with "if (ret) return ret;"
> mixed with "if (!ret && ...) ret = ...;". Simplify the code to check
> for errors and return immediately after an operation that might fail.
> This also makes later changes to this function more readable.
> 
> No functional change intended.
> 
> Suggested-by: Jann Horn <jannh@google.com>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>

Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>

> ---
>  mm/vma.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/vma.c b/mm/vma.c
> index be64f781a3aa..bb4d0326fecb 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -1186,12 +1186,16 @@ int vma_expand(struct vma_merge_struct *vmg)
>  	 * Note that, by convention, callers ignore OOM for this case, so
>  	 * we don't need to account for vmg->give_up_on_mm here.
>  	 */
> -	if (remove_next)
> +	if (remove_next) {
>  		ret = dup_anon_vma(target, next, &anon_dup);
> -	if (!ret && vmg->copied_from)
> +		if (ret)
> +			return ret;
> +	}
> +	if (vmg->copied_from) {
>  		ret = dup_anon_vma(target, vmg->copied_from, &anon_dup);
> -	if (ret)
> -		return ret;
> +		if (ret)
> +			return ret;
> +	}
>  
>  	if (remove_next) {
>  		vma_start_write(next);
> -- 
> 2.53.0.273.g2a3d683680-goog
> 

