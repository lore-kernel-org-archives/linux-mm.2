Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DE85CCF9EE
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 23:32:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BC588E0118; Wed, 29 Oct 2025 19:32:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36CA88E0106; Wed, 29 Oct 2025 19:32:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20D488E0118; Wed, 29 Oct 2025 19:32:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0DBAC8E0106
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 19:32:13 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8519D1A0341
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 23:32:12 +0000 (UTC)
X-FDA: 84052752504.06.2FD8F5B
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5CBC9C000B
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 23:32:09 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ZfW4jmMX;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=lxl0lMCb;
	spf=pass (imf28.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761780729;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5Zso+okdwxZRVDoin2Tw9AELdJfs6YtJq2XRHivv/eQ=;
	b=LykUScxRIu6TZh/IGX8na+Tt7ZUKOqqoG/8TPbe78aIYTpIUP+ajVrsviKIpMh0Zx2dVUA
	rCpOT3EPK4E3MegVcXuiBasIqHD1XCbFZPIfGjLgbVEux5RJ9UQekkiks1MGDPD/Mjbpgp
	zB0uI/1OWArU+N5rjMV+/7FICiBwq8w=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ZfW4jmMX;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=lxl0lMCb;
	spf=pass (imf28.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761780729; a=rsa-sha256;
	cv=pass;
	b=cwTH86H7NHTCdCWIIVr9Zs28ACLC0P7w4+UQNjRkn1T2SdUkv15F6Si3rRG1ztGvQeevQi
	S7kE3vgscZ2krwgfOjtwfbkYqD9EKdilmOi2T3GS8XbBAkvHMIZ/oheCFkogUwPp+aAiSY
	QsC4iwgiyGFMKWwDAN4UA/KRrTS/txI=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59TKKJVX009335;
	Wed, 29 Oct 2025 23:31:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=5Zso+okdwxZRVDoin2
	Tw9AELdJfs6YtJq2XRHivv/eQ=; b=ZfW4jmMX1MVCmodr+NzTkzv52qyQ23+IhI
	rgBJV4SXVDR1CeV2RsAgFt8vHq3Y9FMDwmuy/0bXx96ftOpgnEssLZEFX3/wCSGq
	Z6KJno0Ef7rHousejJM7eoJQz89L/6SpfCr0BpqBivhvH/2fe2A0hQ9+lnulEr8Y
	WBgUfAmGzl8B7cEbrtiweK5tk/2clokogcUJhcL3F90BiRut/ZgapjwTWEYa37mI
	0poxp6O2kXv2E+VowuFWLDg/ba2QzyAwHU+n7Klti+qXj/X83VWWbKZbnn7K/QGI
	H8y53zfHbB5uJYAtFQtaRn1Rji4nbX+5Z8M5tVNwvQiuEZ0BWMiQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a3cv9aek2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Oct 2025 23:31:51 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59TL9glN011137;
	Wed, 29 Oct 2025 23:31:50 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013056.outbound.protection.outlook.com [40.93.196.56])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a33vxvdms-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Oct 2025 23:31:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Zc6N2ITm5qC7op0U98oJHe3JmOxzQ2NOAG9Ce3HMMK6ZXgm6Puf413bjGbyzejDeKZ0JP7GPY97ZEsS0u8aovdtDkieSHLpgq6fhZaCHSTpo0zUkD3opjhtNKRKH/NRkSWISIEW4h79g4xDKmRIIBE1atardpZoCdt55mll6J+lw04pKWNG0DVzBve0dMufGxF3E3B8oM+OLrZBg2e1PgnS7Z74eYrr98Dk9MDa5mfKtWapZ41k28zogorfdBzrhQpb1gjUnN+seB8Al/TWycy1YLJhTmsP7sz2BSkG0EjinJMnKB8cMHVwZwG9fTf4btrWywXFH89Ht00x0X/F24g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5Zso+okdwxZRVDoin2Tw9AELdJfs6YtJq2XRHivv/eQ=;
 b=ZTeDLzuQc9AndPmZknCNSkqWwsmudKbvvLHYWbwNtLPZ0+Kvk0bstJP6CU9Al5eD7U5RJ83LSImk6DuafV7vhRIGIRoetRIAz0Irqnc0EJP8nhL2wl5OGbL2BQx5+EW5ne0FmEPhFUxPy35UipmDqDy6nSkMdd67tC2KCRfCmUjpAO9BpmWYtOUtACLr0Ivns5H3LkXkP19KDaMx9FlIb9NAopK7oc+HJ0SaXqK2Fc4NGiIXgJpSqv5pFsMMwLPkbBup3B33iZnzIr6CTvP8G4HzewYKMdKxu4ewdCdR7XyVcluUh+51QyTMl81IinXtIONe7T2dHKv/m5CAALumHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Zso+okdwxZRVDoin2Tw9AELdJfs6YtJq2XRHivv/eQ=;
 b=lxl0lMCb71FWuG8BztKgaWhAM8EW3CRxGglftG1fNpjekmUxlnGI8gPhdjyQMc0R6hj8qZ+2NrU51Sawn5ioidCL9ek+zv2GDJnDLbynZ4NZjAm6d60m5TWL7e6YUoTskiXiza2hd2cZ1xx7r779G/zobIq+/TiPIAdWtBvqta4=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by CH3PR10MB7562.namprd10.prod.outlook.com (2603:10b6:610:167::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.19; Wed, 29 Oct
 2025 23:31:47 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9275.011; Wed, 29 Oct 2025
 23:31:46 +0000
References: <20251027202109.678022-1-ankur.a.arora@oracle.com>
 <20251027202109.678022-6-ankur.a.arora@oracle.com>
 <20251028135640.GBaQDLmHzCQDegBHd6@fat_crate.local>
 <874iriq2pw.fsf@oracle.com>
 <20251029225714.GIaQKbytWNKuQC5TNu@fat_crate.local>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Ankur Arora <ankur.a.arora@oracle.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, x86@kernel.org, akpm@linux-foundation.org,
        david@redhat.com, dave.hansen@linux.intel.com, hpa@zytor.com,
        mingo@redhat.com, mjguzik@gmail.com, luto@kernel.org,
        peterz@infradead.org, acme@kernel.org, namhyung@kernel.org,
        tglx@linutronix.de, willy@infradead.org, raghavendra.kt@amd.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
Subject: Re: [PATCH v8 5/7] x86/clear_page: Introduce clear_pages()
In-reply-to: <20251029225714.GIaQKbytWNKuQC5TNu@fat_crate.local>
Date: Wed, 29 Oct 2025 16:31:43 -0700
Message-ID: <878qgtgu8w.fsf@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: MW2PR16CA0030.namprd16.prod.outlook.com (2603:10b6:907::43)
 To CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|CH3PR10MB7562:EE_
X-MS-Office365-Filtering-Correlation-Id: 714687c4-a81c-44df-48e2-08de17435343
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+odkLiwao+OAy46SbxsGq02CZqW6G53hv1/zBHxFDNPKVvLiSgvfulQAF/Es?=
 =?us-ascii?Q?kwFeQbdw3bnfXn6tqT6rUW2ow6/eyHm7xglRO/KvLX2XxkZkKYQ5l6QSeyqH?=
 =?us-ascii?Q?iu2BaRRDHZIxE5F+hup29amYeQue7sLCDYtGqhkPLuzX2eh/q/SD3UNn0x4n?=
 =?us-ascii?Q?VT0BjteVUkw0CtnMkR7XSRvpxSXdiIzdDy+1AvcMN8oAa4oxlSPWfU46gwVh?=
 =?us-ascii?Q?+oIwxwpq2cez31CpPK2Ys6EqXud0Mcm39W5nnHtFDh9IiWTJFXaz+l6S4xCD?=
 =?us-ascii?Q?EYW6t81xEXIZjq5b+3mcIseaFAxuTZCCHj2tQnE7m6bu3Qi5al5KQW85U1d0?=
 =?us-ascii?Q?B+9iYsSn4G4anSHQO++7ScWvOD5RvMys6X2Z2mk2mnNLKnzo6WWSJqh+uyhw?=
 =?us-ascii?Q?IvDZinoocyu3jL5enYdsbjYLTDD8MiYyJhbU7eEdIpI02A5NQeqfyWJJGmZA?=
 =?us-ascii?Q?S3bknscyccv3yMNPh3AXD2QkaYIoZXA9rNk4Xp+cCjFyKze09mxNX+8opgvO?=
 =?us-ascii?Q?P5UxQey9a1PqkfN0BpQndW2WTQzoELjUF/Vm9BGnDecCncGdqXaGuQ+Q2wVI?=
 =?us-ascii?Q?OqyH6MZToGPtcZdbZG133aheQU1D/ScMS55Peo3GVQrvF0AkkA2cvw2wR+br?=
 =?us-ascii?Q?pw38APUcmZ3f8aSh28jj0ib3MuqbNpEizXvZpwyb75Q7B4K8Pcsrjy92MIay?=
 =?us-ascii?Q?aHcAqqamGU3mbCP8HoXgztwRAbv3hTTYGm2Bd9s2q1KeduYKKmdpHh4PYuOg?=
 =?us-ascii?Q?8+225qhmg7JMZyziXNZxqcqDTlQh9yX94WFXrIr9+8oTsVCd50UGpyj2wrcL?=
 =?us-ascii?Q?kgJ+CskZaRaPyekAQjUG/xcV9JtvwzJzHf1IiovHnwOkTyyv9B6rlPuUUB6E?=
 =?us-ascii?Q?JhPysRTrnaNdfG8ZXeDqjr6PdvSekEQxZMKRGthAUyq4Pfn+GqsnVp1ZUpjz?=
 =?us-ascii?Q?xPxBEtUIktUkT4C89oY61TBooQd0eSwSyOfOQabGg21m8WviW1EHwo9/8D5b?=
 =?us-ascii?Q?0h/OyiWnyY1R54r4/whgBGzd8lTZeZKZFbcaULe7R/w9O/vQ9/f0wmxjnyc7?=
 =?us-ascii?Q?a7YquSMSxTcdLaxPZ3JEng1nPmDJaqugLAYOBsctD1PArqnYU/k6Yz/NQ79P?=
 =?us-ascii?Q?SnWJr+poWn/KjBLaHBd7p00l2UaJqRld9p7KYCqmBWQkGpX20WkbZyJQQ3D5?=
 =?us-ascii?Q?pJ3FS3ofptoZerVVevXRldEQmK+OwZyt9/I+O7VW0WWSAAZ2ggJ4/yZoIJVo?=
 =?us-ascii?Q?oVaeTyCWNrqHQcvE2rElJ9E2IgQo1oJ9WjdDqsMlBM7OzwIT8YtBUq3KIg6V?=
 =?us-ascii?Q?kTa3/A0MYvdl0uM2sODB0rLyFJNcvW6VpPPUkV2e/k5/SuAB940HQrJeCuro?=
 =?us-ascii?Q?vXZsz+RsqR9DFFB8hVNfeZtM1Uz9JjZ5iyImOzVEwewErzlF2L5EiWQBFCOW?=
 =?us-ascii?Q?GsZFSFKGIAqhZ2qsEC1QQWo2yVHOt/TY?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ibZIDFE8dVa5wfmDU6mGhrBQSPUv2IwJvoIORomS+46UVKFyltrCBnxZG52D?=
 =?us-ascii?Q?EPBswjc4N5UG3qbpJwXPXUKMmbPLGO1ankqQ9m/i8mYeGFXizvaXdhAmR+1z?=
 =?us-ascii?Q?ND7XvScwHLqgs2paeMpnpbE/aDMvrBc6nfNnjtcyhYsHJqPLxo8xRrUwdxa0?=
 =?us-ascii?Q?EnGBH0llAzVRb75Ynlxti57Vz+ceB8fiJQzYkUNAMWu89nCZRO7F27ESrxwh?=
 =?us-ascii?Q?dF9KZRxDbZWz5VRJqTDqiExIzz7IHZ46bAoVZv6xcvrVdTy02XYHZ5eHzeGw?=
 =?us-ascii?Q?dzfy5J9nEnSF3L9Sq2OadYw63HhD42BxkgTVUP/i+zeWbrEs4u6OTrEoDL1y?=
 =?us-ascii?Q?uJkgAPDxUp5knxsQeVZGjTB+akLE3Ic2/4iTBlzC5HWG0SyAAk3+NtuJNe/+?=
 =?us-ascii?Q?3Ct2ey85JY5J1/aAVyHrUpTunaJLF4OClNS2JEXL7c4G8SiqncheRjm8I0bA?=
 =?us-ascii?Q?xm1aafc5UVXagZ0zajUrGDx6oA/AVFNSdUvooiEaGrWVYiV2entE0xeVfJIA?=
 =?us-ascii?Q?sIv17EVHP5S/1Gt//YWBvx3DcgQcBgEr9S9ouzFxI4+Ug8Z3geqGvvsao8oj?=
 =?us-ascii?Q?aMNzRJuW67nxTV6mI8xwjx+SdDfqW8pa8SAE32XVtY5YQVGzJeJblKtvgFi6?=
 =?us-ascii?Q?nf1plybigrrFJt8Q9YsyJHy2j9fyXuGAeqg2wYyLICkMk+u374o9Q8R+p2BE?=
 =?us-ascii?Q?57+g13617eJbL/IS9NMn7MNfUW5eLCIeQFx8Z525Rp0MgKvnCpyTaRLDCzHx?=
 =?us-ascii?Q?2Yaq1SmCG1qaX0LwxIUzDgche4wzjp+GvN/RseI4tkJK3VyXwtwFO0HpDBUm?=
 =?us-ascii?Q?T1maGKZNaIfOs3GVsBmNEWXfz73BKHQXZpavU1MFLFzkZV7w+da5P9f+CUrj?=
 =?us-ascii?Q?Phyp5V0WwBLLz8RrPXIhjWABxoKrUkxjm2RlBQ13gfzErbL5NCJbs6tV0NHl?=
 =?us-ascii?Q?ZMkL5FHJYGWBzY/YTw1Kby1tLzRgk7DMTjmiNn8XkpA7s/nhRr79MiTHLm3P?=
 =?us-ascii?Q?kqvGmmWE1JRGMS+mjKGTt45F8lom3kqhRy1eb68lRKBOUEEyMV92ZRd9uhGm?=
 =?us-ascii?Q?4wxItuCMYN9kBIWcnodeQb1FW8FcOK9YSfn1mjTCi6/h6UTqoh4O1UowEvTI?=
 =?us-ascii?Q?m3T9blMSBu8evhbLBKJs7tplcurSPbGnF6vy/8HLQqMKgfj/1fpkb85UKBNH?=
 =?us-ascii?Q?mFrw5AdCnkVTSy/Qs+MfuEyft/uC6gVsVygAPVYw6UbiMXy9a/zBHG4e8o4r?=
 =?us-ascii?Q?oYzLMlmxNiI2vVxii+CEPShEcJeyvSncJjJsQjw9mdsoQHiEzv6UFeGyhsz7?=
 =?us-ascii?Q?diO5XLoIxKR7XEGVgFFJ1wEIqTgO5Gdi5oE9uJk2CitGHhvAiU1FjCLLIb19?=
 =?us-ascii?Q?Itt0VIier7xMVU6sjlymOVOq4XQFLVdmoyoQzoepYS2yw6Fg/nxsP6C6DWhx?=
 =?us-ascii?Q?Drpp8fxpz0Mem7LtC1O6z3UXEmELi/2ohu7CYJgSUgR951dxgTLjmGc1E0M8?=
 =?us-ascii?Q?sjBKY4rg13AjuD5ZF24LDN4ricPmJEuH+mw1LNJZCQ+VKqBQRxKwvqpsYJWz?=
 =?us-ascii?Q?dGmG5oMNTP54x62Jnfdz6wUA8CYp0+95m4yvna/9H4ulDgEEX0sc3XNg6VJH?=
 =?us-ascii?Q?Yg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	mtoQP+9qriLkdJFhLTkoyT/peLuDMPzsflLYI0I3bJzkWndasoeofOdYCEbAyvVjAz1nOXKQ3TNMhH9QADr0i2ryAAjEoYrjXSn295vLTTJN48UBiZLEMNIwVD+BLjON3adLNLiofYbyIRMaJoN+mUUtc+I0AgBaGNkYq+hPpT4VCGigC7xByf2LaGd+SxPM6GwxC+r4YCcoPk1/2te8bw4t7UHPbwf3PKIzvHDVJbjNQP6XgaqPCB6RyY05CoAf23n28Q7G6tPy6uNDB6EhQSMucYlzmlnhtgcqZEw8MSYznChKQsk9bbtwvyHOrHgVOdfHEaNf1tdYUxlqCa0NaeFPcR4st28Sf+x2+X2T0DJMTX35+WRrmHFU8HBS2RprYuLfqLWW1yUIAZ8j+dMk2qrsefd/TsmUVeVRKrQ/YMRH7Bw/dtycv5y4XH8luHJXEC4zh5JmE2NQEbxToYXxTZdR9Jl/IQh9rjf5G/DVui1FK6OBGXk9zbuZv3dJFFEWgDcKdmVubmX+0AypE6ePEa2/B56DFkNY5it0w0b5R/RG+Z5wHJQ0kGo3lChoV586eGookwdKPfJvAzdB5GZsyHaSMHx+lhLF5nU1eo9DFKk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 714687c4-a81c-44df-48e2-08de17435343
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2025 23:31:46.2434
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V+RaSNoGdUN55jizYeUkfvrFbAyK5fLOOpcd9i6Vdeev/VesxdXad55OJYx+mxA/fR+NHoP315Ku6sCEBFkSd2mpG2jGomGptyCAy/c7/aY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7562
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-10-29_08,2025-10-29_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 bulkscore=0
 mlxscore=0 adultscore=0 suspectscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2510290189
X-Authority-Analysis: v=2.4 cv=NfrrFmD4 c=1 sm=1 tr=0 ts=6902a3e7 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=x6icFKpwvdMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=R5sn_bqk9PoPNMjX8L8A:9
X-Proofpoint-GUID: OIRl-3hn6AbEOXnG5t0h5M-c863XNGl6
X-Proofpoint-ORIG-GUID: OIRl-3hn6AbEOXnG5t0h5M-c863XNGl6
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI5MDAzOSBTYWx0ZWRfX1/1KMI/aUHWv
 7ojCW5XHq8Ya/8CJcAjg2YHicvA3ZoYMVnxTGQ22+QtkHF6p9nnB9juADn0Py5Afbrksxgo/Saq
 vg2iqR+G43wGnknmm6+/SkHdXWoBa+f1c01uCU1K8gcYX6d0n6uITvf/D0YSpErFY42HNKN2Hhr
 UfTGjxDol4DlXk4Kv7+fvxr0NZnoEeIqgM4g21v+asMkClo9rNnLx4Jy5rzFyXOSY3qy12B0riG
 pTxXfxq5EB43Mx4dEyVGd/bEoV8wPq5Bag6gvDHokf7ZXPrJqhf5MKQZH+yFelcekmD6vzPG8eU
 kC763L00pU+nAw95CKfZYPHxYkJh4HK+4ZJnxzXimvCiVltFZnhu07dNci4GkTrSSzkO6GKYqLE
 A9mbfP1KbwtA+vEzMbHy3x+4rG2IfQ==
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5CBC9C000B
X-Stat-Signature: cx3g6hnqouadqm55kmgt7m5n6z5ywhf9
X-Rspam-User: 
X-HE-Tag: 1761780729-174100
X-HE-Meta: U2FsdGVkX18Jw+jffcv3WJxP1a9TpkYKq/Dn6IBsvOomdbdkgvvHjVm6dWesIzG5c+IzGtSM/qi4LTZfZxBDnY6zS8riSxUVRGR1KcildUzVqxTqCcn4Nt+Rj5cVb1Db7bzfIJpVbkNAkyEUZCMBt6Rgjjh0t5mL8yqhYqRmLLHDEm/zIhz6e3nYOCM+xXgoGVZ1Q1GF9HIuCSMCMY22i6aswHV/SIMrfykNPNpC+k5wSxlQTzJ2PVkmxOpQJFZqOdteznCF6iE15ZGJ7+cWGoUtEMjgTiOp1+fBpG6p1P/t9CxiBsNQ8fwOYcGDRBU5jwAmlqjdzOP7yVVveTiOu81DG66m61e8z3gwj7yoMU6QAwj5pcj5Fn7aUg41ASh39Z82mUS/8wptJnoa5nG1m+FU1MitiKez1BNC7GTA/VQqtbXWxavFimfalFmPykS8oSS5rg5aXuZwilMHsuNan3VkmZqzM1BLM0IPLBd0n+Er6Gwq4Pfh2T8wofEFhZGAegcTI4cEvdiMuMGBAkfNrib5jxupYTVtwDQ0lwKqARWgUbafIRh3caludm57iwwgCmz9lo8kJJ0Xs2J1e1IEEpHBRzKpYmPc8ygVbtfZGf6eY1dUwsv3FoYF9NnDCZ8Q4sShGRfEGBUQbPYQ2QHacaHAuZKN8+szF5i7Qjb00Tu72O9ATpRecONARjcVf0U7T49ZcH8WEffmEyt81Wb7Aw4UywRcPs/LYD+++6nAmsYQEAGI7IBQqq/VunybjHtDmT5kJEaih7hKsv/iqVWBVTJeii0C7rtW6YuekFQ/rc/XTlXV5oo2fbbN2FduveF3qUoCruIbGddBdXHM/m+PIBVQrdW1s3r7IZkw+3FMQGqCASZccd5oud+ifennHUbJmPpkTszN+MA+ZCvcqWjfkq2H7jhDxkLJzBqiMZRMXjl+qyScQm145xmhAT2+vioVIFFdSpdzWxtkWo9zTbg
 j7RVkNQs
 foO0TSttivdGkJzCixRek6PIt7r9T6jYJ0QZDa5gUwd9AZWjruR0isyhv3MPwNJKy+ohv10eHeVNQrm7dra2OthVqoc+uGpm/B3ef
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Borislav Petkov <bp@alien8.de> writes:

> On Tue, Oct 28, 2025 at 11:51:39AM -0700, Ankur Arora wrote:
>> The intent was to use a large enough value that enables uarchs which do
>> 'REP; STOS' optimizations, but not too large so we end up with high
>> preemption latency.
>
> How is selecting that number tied to uarches which can do REP; STOSB? I assume
> you mean REP; STOSB where microcode magic glue aggregates larger moves than
> just u64 chunks but only under certain conditions and so on..., and not
> REP_GOOD where the microcode doesn't have problems with REP prefixes...

Yes, to what you say below.

>> > Why isn't this thing determined dynamically during boot or so, instead of
>> > hardcoding it this way and then having to change it again later when bandwidth
>> > increases?
>>
>> I thought of doing that but given that the precise value doesn't matter
>> very much (and there's enough slack in it in either direction) it seemed
>> unnecessary to do at this point.
>>
>> Also, I'm not sure that a boot determined value would really help given
>> that the 'REP; STOS' bandwidth could be high or low based on how
>> saturated the bus is.
>>
>> Clearly some of this detail should have been in my commit message.
>
> So you want to have, say, 8MB of contiguous range - if possible - and let the
> CPU do larger clears. And it depends on the scheduling model. And it depends
> on what the CPU can do wrt length aggregation. Close?

Yeah pretty much that. Just to restate:

 - be large enough so CPUs that can optimize, are able to optimize
 - even in the bad cases (CPUs that don't optimize and/or are generally
   slow at this optimization): should be fast enough that we have
   reasonable preemption latency (which is an issue only for voluntary
   preemption etc)

> Well, I would like, please, for this to be properly documented why it was
> selected this way and what *all* the aspects were to select it this way so
> that we can know why it is there and we can change it in the future if
> needed.
>
> It is very hard to do so if the reasoning behind it has disappeared in the
> bowels of lkml...

Ack. Yeah I should have documented this way better.

Thanks
--
ankur

