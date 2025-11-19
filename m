Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DE17CF31AF
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 11:54:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA94F6B0011; Wed, 19 Nov 2025 06:54:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C80FA6B00A8; Wed, 19 Nov 2025 06:54:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B20636B00AA; Wed, 19 Nov 2025 06:54:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 99F006B0011
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 06:54:45 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BA4E91A046D
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 11:54:40 +0000 (UTC)
X-FDA: 84127199520.09.E3238ED
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3FEFA180008
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 11:54:37 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=dNKBvrJW;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=j2X+WVxJ;
	spf=pass (imf06.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763553277;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VlsBcORjtSbeMOwTKsaRpv4GbRVCxj2AzA7qKCKKnmc=;
	b=c+17OYnDHEsnzjD6F4c3ref14rN3tBAULP8vkmanhcUaxYL0uCwVFbWdFp9vqABHHVzlSl
	pyWROsAjh6MBtu0mBvz1eomDKiUCsppzPUD2HLW/CcwQeaPdvrTsZMFxpOV0Zz8ywYEY8x
	OwtAQyyv8Wm2sWVKB0Cu7jUhx3KLTyY=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=dNKBvrJW;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=j2X+WVxJ;
	spf=pass (imf06.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763553277; a=rsa-sha256;
	cv=pass;
	b=TC9aLCjrTHVCQp7Sa5+gzTWFD34wb2E10jX+4Ay6du/Zli+/GE8btRAu/8tMvZIbpedVPi
	7RDbdtPTsW/Q1YaCshOPxbBva7kiYQ6GEJv1qnc8puN7RY5YRNXkBD7r2Nfjn20LpMJ/5G
	BOUQUunmDaTPy70dxOsjhqwAwSRwBxc=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AJB5rDP032537;
	Wed, 19 Nov 2025 11:53:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=VlsBcORjtSbeMOwTKs
	aRpv4GbRVCxj2AzA7qKCKKnmc=; b=dNKBvrJWRbCA5Cf5UtbK5OX1qV5GXUwcR6
	XQPKjvUBoBpwcj9uH0BL5uxCQ0+i7wcnoKhgaXexxT+9TUG1hj2z+FK7LEZ+C5Dm
	ukUtf4+L+DZCtNoje6wm7sYtCXwyAX49px2NDY4L8qSsnkvAC1aKQcYw9RxJyC8r
	/jnJv3v7s5Xn9nEcDNu2hUJGAyGewQmz6s/cJE3Rs7OTePl8MmM7t2z3nMJ5SYs/
	TFHspT/JJSbwidhJzD2d4w1azWG4hHtzomoeO1ezYLNF7u02ws8AOOBBwldOtFuU
	lxciRhREoACGVvw91do/iF+LscHleS0Gvm0oAXBdDOGDyCJjNSiw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aejbpxts1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Nov 2025 11:53:25 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AJADqb1005110;
	Wed, 19 Nov 2025 11:53:24 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010024.outbound.protection.outlook.com [52.101.193.24])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4aefya7vsv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Nov 2025 11:53:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ez3j+n6Rw2dtq9LUPD7CUyEhq/cDLUFgWI34sn4GMzV1iWWYNowYgmI7oZYi0kA41q8gF8oyVB0i8utxFgT/Qt4QY5Vht1kkTkvKp0QIQMxdMcoHdBttL/SqNV6DnvjM2dAHj7dnNa/xqX42Uxda/A1lRoHznmMDmw1EZfC4jS7l/nQ2OHvEcZ3f4Eq1DT8xKSCtndUmzBOweGo9IW6y89x8Ykv3O4+K/9+AKFsvNH22djuQ1Mut2U89Thv4FjLigc336T7HbauhYAyXncASaViItlM5IpiRRQco68xYtofaS7clER2/xB6FXlHaucO5IKuEk+lX5ZEkqWHa34ZVdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VlsBcORjtSbeMOwTKsaRpv4GbRVCxj2AzA7qKCKKnmc=;
 b=p4+u9KBXMgqNteZ70qxpPJssKRga+Iz1k6FVurF3PF4aL0PsEMwowhMhP0qSJZbQIH1xIycG2QUaPqJc9yRIgy8op+VTxUiSVoRyM+ZgRAlK5YceR+uKDIdfcMzCm1s9sJiqsISo7KJ50vz/Qbq2rRhsLzoFjpvkhUOfqR70cBU9VPblqKQM8TvfXuCwPTrsKDabeKTnndwJm/iX9mRFkqX/zXFUMMm9Dfge6/iXy5HRAAl8M/+IfNmkahjcZWH+n9WM2scjcIOivPyT4xC572qYgamYcFBes6Jmclb+oDWj/OiW+5MzHn1U+scwuoNTjy/zBj4bs/egXeQsXzlcbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VlsBcORjtSbeMOwTKsaRpv4GbRVCxj2AzA7qKCKKnmc=;
 b=j2X+WVxJvu3/jDV9MofVi6rD+6dH1MEfp4Jz2VJe8IokI6yTThEpOegNtfdIVcT9jrMbXf0c+T3sdJVh8xwLyOmTQuIw+NdZ/6erE5LVMqU6m2t/rqZQPNnTtyLwvQdIBWyMUGQ5v9WwrCFYFPvb780Dy8Bg9lUvPK7G8eq0iVc=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SJ2PR10MB7707.namprd10.prod.outlook.com (2603:10b6:a03:578::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.22; Wed, 19 Nov
 2025 11:53:19 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9343.009; Wed, 19 Nov 2025
 11:53:19 +0000
Date: Wed, 19 Nov 2025 11:53:16 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Nico Pache <npache@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-doc@vger.kernel.org, david@redhat.com,
        ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
        ryan.roberts@arm.com, dev.jain@arm.com, corbet@lwn.net,
        rostedt@goodmis.org, mhiramat@kernel.org,
        mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
        baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
        wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
        sunnanyong@huawei.com, vishal.moola@gmail.com,
        thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
        kas@kernel.org, aarcange@redhat.com, raquini@redhat.com,
        anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de,
        will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz,
        cl@gentwo.org, jglisse@google.com, surenb@google.com,
        zokeefe@google.com, hannes@cmpxchg.org, rientjes@google.com,
        mhocko@suse.com, rdunlap@infradead.org, hughd@google.com,
        richard.weiyang@gmail.com, lance.yang@linux.dev, vbabka@suse.cz,
        rppt@kernel.org, jannh@google.com, pfalcato@suse.de
Subject: Re: [PATCH v12 mm-new 12/15] khugepaged: Introduce mTHP collapse
 support
Message-ID: <d03e079f-35c0-4fc1-8856-44fe33fabb2f@lucifer.local>
References: <20251022183717.70829-1-npache@redhat.com>
 <20251022183717.70829-13-npache@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251022183717.70829-13-npache@redhat.com>
X-ClientProxiedBy: LO4P123CA0325.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18c::6) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SJ2PR10MB7707:EE_
X-MS-Office365-Filtering-Correlation-Id: f350d6f6-90f3-455b-13d3-08de27623baa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4woMv4k+/oGkH32SmYe7embDmSvQ7iX4Afu2k/drd0NON01k1OqkMz8iMyyd?=
 =?us-ascii?Q?cZCn2nrc7iFWhbrlAxQzK4RfgmvZ/DXv50VuLSW14cO4Ik/TaAIjECJyPI2f?=
 =?us-ascii?Q?f6FTMxTCEc36MSd8fCkstNYwB6Z7ipaUjmO1mqqtXID/tfWL2XAyXNnQAalP?=
 =?us-ascii?Q?45OdNuBS78HUI/oQ0Ux9wF7TSXrmO78pERwxPkaqtLEZEawJozQfRp0sg55d?=
 =?us-ascii?Q?2E0kcKQUr/lh7+9Nd11z+9pf05eq1jDB/OhGcAgxyvcPbNRXJPzF7lUize0x?=
 =?us-ascii?Q?ITbiH1EQsLk5a6iGJviaEbMSak9p/iwHGnQD3wKBOb0qlGFjcnHngLrUZKp+?=
 =?us-ascii?Q?wOyskMxYl7xMfBzrdmldBtlKg03TjHESdcXX9qrlyDQ12L9DuBJNYsurihIk?=
 =?us-ascii?Q?JC63tI7rhZpRaA9ZID2fmqRKThd1sWCA/lDePOYqpnmPmBtlRrzebLkOnR5c?=
 =?us-ascii?Q?E/TIyrmPnBKt57czmBVGAehObCqgIZuz6xtsbu9emjXTF7YwuggB5v2pqjjD?=
 =?us-ascii?Q?2+qN5AijxW8BV4v51kSs7nBfnhBFYFLws1LM9ZG/Fysp0etdoYrrSNW3eMl+?=
 =?us-ascii?Q?LeDvSp2TqMWPBHv0NXbC0fF+I6lRZDCywk6TtvC/eWrT7kwV9WFpxBqPeGw6?=
 =?us-ascii?Q?K74Et3Q3LShSHsXXb3XQShaI5ctkJ2cMqY+tOYBpmu5RcCsrCO7CArx5hUlv?=
 =?us-ascii?Q?TmJW2lsNFK2Zn1rVlevcjEnhJYRZLHnINNjdx9txEDt9p5VPas+tXI2PgYiY?=
 =?us-ascii?Q?ZhX0BlACA6gSmUrRngTe3RA3mN8QrONVb/3zpFRUvmfubUk+MV4th7xpJ/S+?=
 =?us-ascii?Q?lWGswteYenEZcgmHOcCZEmVHoKwdZ5bdyWlnJkJuA/BM1ADXX4FCAFBfnXuk?=
 =?us-ascii?Q?k2yAFLWbV9lmWJuWK/pyyhZ4pep3NZUEviTU7khS28hLBL3Z6Bhyu+f1r7xX?=
 =?us-ascii?Q?JzlaSjlA5EhAAAbLVHLwV6he8O/zZJksiPqxFqmmf15/AyPuf01vvjDhjDh/?=
 =?us-ascii?Q?eRfxU0pjFLtCh4nlsL7IgXX0duITjeeg9atRMFySu7hs4FPS0e2P/qT58B+T?=
 =?us-ascii?Q?eKn/J0J8bP3cJDY88hpB2xUGN1szk6af0fqItR/CSCaSmD+1u4SlFD2Ck2P5?=
 =?us-ascii?Q?p5uu5DULumqsjdsXJgygy/+mhAeFJcesqrWQbVhJGoRAMshb/Or9Gx432LF5?=
 =?us-ascii?Q?0ABl6ZGmLnwnJS7AuGvHr7BhLZwZh/JN+qRmJuKTG8nRGETWG+S4zHuYGZic?=
 =?us-ascii?Q?K6QWnTLLPiOOLRMJeMeCqdC0fTjGFMQm1xnSVMXOZtBxTEjFWv7Br4tV6RQM?=
 =?us-ascii?Q?v3tuLxvBbRVRsxm6uGZ3kSpetlGCuDPOeNfFwE9F3gG6sm27xug+6/0xFCT1?=
 =?us-ascii?Q?/la1vkQq2UpC5sflcD8eKM6qK6V2M0IDgSo5RC7t02HHl0UMlLCdb1FEoLXa?=
 =?us-ascii?Q?CFUYKKnwbQxDMSG3FTtl3TO4AWNpQwJN?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FKeU4M7ZKPx2AL5MhoLcg2/X6Ew/M4BHLr72YW7iSAslbkagu3595rhkWmFY?=
 =?us-ascii?Q?/CzU52sojduKZjJuGVh5JEIr/Bc3S0V17xyWKWo1RxOtGfI/kIie5kvByeHS?=
 =?us-ascii?Q?Q5H9zHTNP9NwDQSuKh+pKUIB01wHtSSVZcFkwH9ZkBh2w7ayRcy8/UrH6UgI?=
 =?us-ascii?Q?/ATTqCHhzcKCZ6gtsqcTYhYuF54afjvopNcGHm7qFAKXZKShePhtbEmbFuK4?=
 =?us-ascii?Q?TccqPhNCviEb+Gm3C85TIxm6g0RaOvLY4NorNNqlfon1u4GECs7AEEuh8E42?=
 =?us-ascii?Q?Ex1cVl8VHWebvAQSe+OP/FLgkZkm2PrZG/45JIvq6uO9aRj8Gc44wu1Snvw8?=
 =?us-ascii?Q?I/2Lm+y2QG1BWNPp0UZGYbgIHON8UcczsBNoFmjVcdKFHAPKwhPh4cwAB1qr?=
 =?us-ascii?Q?kXFhjmEBXZU2QOgNX81tdBa5LzDjaTZADnKf3Wzzg9wJfoFNfud0zTAeZ63n?=
 =?us-ascii?Q?AtOZinKd0kulyAFvFFOh7flPa2uNzNwVQxajCP+fTsLtyqg676cBE94LI7pR?=
 =?us-ascii?Q?mg66wJ0dPmUnZu1rdTylkIsjhhlwpost77JBtBkmtMhkN9af3d6yu5VLeP/z?=
 =?us-ascii?Q?Q0xX6gNmFfPkCUxH9wH/YR3PWuWmFHy+acLkaRZE/H0zHKl30WDXj7Lu2VGI?=
 =?us-ascii?Q?5/0zBEwNXtLrNA8JdJlH3Uqei2v2GtpzkEAwgkPAkXKRlVgKY8AXY81dohcx?=
 =?us-ascii?Q?d92mPVL9Kjl1GnB3LBMXKsY0zwaMr3UtVS9kWgaXkq0Rwl86BuDWuLkTfMZQ?=
 =?us-ascii?Q?ojmK7ogvcolfAbQ9nGNu0OtbGAcKfzs1z9krTy75dfCw9vvjG939tC8Gwvw0?=
 =?us-ascii?Q?jcRioqaDaDT+vKqVIOVPq0sDgG5HGP5t1poVR9a07UuT7Kx1Q3CLRNh7/Vln?=
 =?us-ascii?Q?nI2Zz854oMavDkqPasfk3G9YioI8sW2vX/8cSSBygJi58lIEq3xzueuPdR56?=
 =?us-ascii?Q?CtxLqfpj8l4pCJWa07H7JtTskYNKm0pKzSJOYHXcGEwfatctu04//smMG0IS?=
 =?us-ascii?Q?voL73uPQfWKHD3CJ/YOW2SzHdFnNJcx78bNWezY65UMlbS3TPBujnGIKdVOh?=
 =?us-ascii?Q?A/9TRfDsDyYKYluzR9LNptl8lmKXDIQ5wCxDrz6ziMDlJRyYSE+DwLhItWkD?=
 =?us-ascii?Q?q0TbsiA6XGkflvMq0kNLE2kaNYOsoolo2yFoHMM5m53950sFRqRWL11ywJOb?=
 =?us-ascii?Q?U+Fv/qZYY/tFT2SWEe76GV2j4d8gtAkXHjgFMbfhe1dxEzxlnX1S2NMOLpw+?=
 =?us-ascii?Q?K8nUw/x7BM1uPO0UoT9XU/eCmyAC36spMM7UBA7k2U21vXGrsVV2q5BX5+Es?=
 =?us-ascii?Q?8ThrEpCICG42DvaMFTYW7tInnchmx+qYKoiEZ5GPQBAbbbS7o3aI/viQjJVm?=
 =?us-ascii?Q?On+xghlRxdim6U8wjoFCnq0aA4Eul2IfvK5HqpD1hhVeYwKcNczxQusHHtf+?=
 =?us-ascii?Q?6jGCjvTxsgjOYGCOEQTtnCYSkZzsY6qdpBpDXaqyMJI1ToWxAbI5vZ9Rc0+b?=
 =?us-ascii?Q?GESrMqlFp8TA2uFkiFCFyQyxqlskpX073bMK/i7pinmmIpuoP5bEJX4EGo44?=
 =?us-ascii?Q?Z1eUvF3dtR4xQHshEYDzin6JHIR/SG9gPwuuH2BpobN5T817kIKhOV69VZ1R?=
 =?us-ascii?Q?dA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	xwzi/93TB+2p537Wn0wAh+tXtzd4Rd8wYA3o4LKvf9umiarre+x6/oaDYzKzAnKKZtDO5wbiBUvElY0vI49fg2dG/CqEYcXksH3CGj2gIpgPPZzJN2qlnFOiwWmgJGwDuMa36MNEPLvRhYGd/3IBoiD4Y6z7Ena7B1wWQBUTyzydqcENYVeXinAh6Q8Y8a+uYDMRJPSqsLYN4jPMlMDr5UdgAfEZ9Ux4p6q79lvo8aifpcpFouAK0pDYdPbMpPmqINIBa9UQT+dp1PWKXEDLOB4jaLwxVPYSkwsBXJ5LecAjfogpnfp1+ea17Jxo87MVKLFRkRhASZ5bhew8Fc+txt1PgoUiRMo8eAD3tyZ2ZCbgEoDY3mpJ8UxBgxBhZUI/d3KqaKdQLaU+eiHb3BpTYWd0LZ9prT4DN4OC/ez7VwoaTKOR0IW4G/HoQy8Q9GFYq9F7j8XAGoNuJFG96MLrRxV2rHyK2A+BJWrwJDzzAqn3n3UxHaOmzKm0OwsD7mJuRsVWPR4ino9fIVfKZgLZYRitGJb2PEGqaeC9PhC7ISTKAmbBZIuxDFQvjK010GlmI3fRQe5XAcDaKi+Wxu8Gdzo8HMseMvJvtNR0dPcLDbY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f350d6f6-90f3-455b-13d3-08de27623baa
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2025 11:53:19.6692
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vU0xufwgivVSzTJGyjoZDkhYaVXFem9WnXtW//ET20blxvKywCjBZpZ9Agy4g9GzW0onglmvGFfEJX7b4PIHyAaBIbeTu3yP3cIrX4UCKx0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7707
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-19_03,2025-11-18_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 suspectscore=0 malwarescore=0 mlxscore=0 bulkscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511190094
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMSBTYWx0ZWRfX9334d/j0jjGn
 Yv0z19uWs91QiBoEaiSVevSV/ii8i4qB/z/R4WBSBZwq8v8FT7X2YYn7lsUdv+6A5/nEBIrvj8k
 jAx8CQ9oS5ySqtjDnB7ExqgrZh9buN3TOnZx8aUofNaIfueB1YQBMvlVfp2I744wEiE0O1hUBx/
 4NIQbTUcHQSQ2cx9KHsJB0HVw4J7pbat20W0pUth5dO3PntGmT4uGBe8wZSD90M8lI67qh5Pcmf
 /c6QKKnGLHRJ2gtF+PXlpfOe9AkFO8Bw2dpj1GrzqWvEWMXfOJT6ECoWWc4SM/6dKUJ//QrnHER
 QnxZmmneXsglpv/r6l/Rjpu3I2aKlHw27+YZ0N1LRtSkjRs2y8RFRSsG9N+bKkiJgaG4ulEXWvu
 rkFaoRdfIXsZ4bnj5n2yeXOxc6e/9Q==
X-Proofpoint-ORIG-GUID: Goo9wZ0wvnszyBHW4kGHHVbyjOg39lsM
X-Proofpoint-GUID: Goo9wZ0wvnszyBHW4kGHHVbyjOg39lsM
X-Authority-Analysis: v=2.4 cv=a+o9NESF c=1 sm=1 tr=0 ts=691dafb5 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=20KFwNOVAAAA:8 a=Bxz4-NTzvSCNQYjI4K0A:9 a=CjuIK1q_8ugA:10
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3FEFA180008
X-Stat-Signature: s663e6fauwpgh6js8ik5xry7t58yom17
X-Rspam-User: 
X-HE-Tag: 1763553277-499210
X-HE-Meta: U2FsdGVkX18+tcPaFlyDe5HejTZJ74KWAzGQzL0GhYPHUXtljcc8Nhu5JCQjCpJ7fEx0b3GJ1l3b7isbewQLJUpLY3ymv6ZRMnAdnWtNldufp7NPhpHdCt4L/Dubp+b0BSOVxaWjMlLjwTUC1Ssk+7nXiuE/jNl2SCrfGPrz/FLcsh9rIbj/SaiTJ+d2zXNnRUGzBDH4kqZ95Rb386PKj2c35tzEKVGwoggj9yZIg2gARfFLA6TfXsPW4/q5UsaVti9UD7AGJcd9UV6E9I57WSfud0XBW/+cns9EsfjhiOuA51NzxFhFV5OU5CkmbdV/ocdDTZgAJbrJiCrlSgkN0/OvigjAexmCji0eYnDwavU5MfBugshZVLCgExNsvxhetMzGECa69OGVovG15nuYR6An9RC03EF3tl4MjgRhbLa1Zl9mSlFhVwUOj9LtqhCa9IQB+ENqu4lLUlIQnuBvht02GarnEPgpEd7QLHj9Oh/3vVdgNvpHJMbj+Q9aKfqp48A9Ht0PUyJ88EkR+/DnDviL3UF2O5O2JIc3ceapsQLTHw8uvoUk/I6Ni8RIGW93cbIGG0Cv/GNTgn/eOx+vVDYDxZNBFBu7muVWVNl2N6h+EGM3V2tHkiOs4Ta99UX6FhlLzhVH2BCVjB1asJAN3ifr3JxTNbktLdXsU9kEcMjomgCSO1CrcvspuCiySyxCDe0G+KGanUK0ZWWxTxYeXm/71CXSzNMFGbd7ULa1clSENZwdEEjyQfJqSmxxhcAGDZog3P0dzDtCvZSUEJlz2FIqH+9XPtpm1lXhXxu2t686sEiHhV5nI0MvAi6kGW1pOJKYJS+aFT0xxWBQd+FGH2lYhfurSQx90pogZjejLTUZir0UFAMDEi+VqyhtjsFt8iLQrMQSs8cKm3ciYc8bJ02LZcURIJfy2NugzKi/wYfaen691VcpHK5rDk3KWdmGvXvpkowDP7TgJIB2KJM
 B9t68cUX
 XW9X29/8OYCFGec5Pt2Xh/NhhjvC2EEQFe9CF1bG/lGm/PlIP6kNDaDK73TiD6HlC4KHOyLm4t0N/yjGv15JSUEJWHefhmDtRsg2HWuOEd0ul4Dvr2mHk+/koZcqAGGS0nE3jVssFwOVrTejKWB0rrFmPmlxpE6IKl8ugnfoaBp1dJe+ZnPrAjCybuT7jPcbg1eZMgSKd2UlFikj/Z64cUOJt5CMsQ0dJgOiYVMgMVpggY7y42IwpcyCW3f7VoB4+4u0cfg+G9Z8SzAgP7TFTU2jBZPtxP8Wct77tWJVWxBktkQLQmP94UsTLGmhLi6Bv9gzMEiOD+D9EkZ0gLl2i/HO7fR1AhTrFdlR6Jo3hdQFpzNrKMcE2EciWPTrfRTRAzuqi5Bup1xRVH7RSXzJMzXcXvovcMyLa/NdQDPjsSBv/Ii0EIGoXdT9YhEKpzkfsy7dDfbUUOd1+qoB+pZr5XtfkPs33VvElTfc1nX5ZLk1xBrUDeEhMnTbfwNx5BoJ/ed3NKkRKNuMSQtthLVxv4HpssK3/n/toBTj/ZORdXAyMtsokgNo6nU4jEeRJ9UzqVAKsxu2UzWUVmPNUJ9ToXTIClGMzrrsAn0pQr+IsamAHtUMt8N7HcK/OLb6y1RJxaNTVDvCM7MX/YCMPlJZA+P3ZTazKcuHxKu9gAZcpryZ6J3ax4z22wlZqgA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 22, 2025 at 12:37:14PM -0600, Nico Pache wrote:
> During PMD range scanning, track occupied pages in a bitmap. If mTHPs are
> enabled we remove the restriction of max_ptes_none during the scan phase
> to avoid missing potential mTHP candidates.

It's a bit odd to open the commit message with a very specific
implementation detail, I think we should instead open with a broad
description of what we intend here, e.g. to permit mTHP collapse, before:

- Discussing the algorithm used (in more detail than below!)
- How and under what circumstances this algorithm is invoked
- (Mention MADV_COLLAPSE not supporting mTHP as of yet)
- THEN super-specific details like this.

>
> Implement collapse_scan_bitmap() to perform binary recursion on the bitmap
> and determine the best eligible order for the collapse. A stack struct is
> used instead of traditional recursion. The algorithm splits the bitmap
> into smaller chunks to find the best fit mTHP.  max_ptes_none is scaled by
> the attempted collapse order to determine how "full" an order must be
> before being considered for collapse.

I feel this is a _very_ brief description of a complicated algorithm. I
think we should go into a lot more detail here. 'Binary recursion' is pretty
hand-wavey, and you go from hand waving that to being super-specific about
max_ptes_none before handwaving about 'fullness' of an order.

All in all I find it super confusing - so I think you need to take a step
back and 'explain it to me like I'm 5' here :)

>
> Once we determine what mTHP sizes fits best in that PMD range a collapse
> is attempted. A minimum collapse order of 2 is used as this is the lowest
> order supported by anon memory.

I don't know what 'lowest order supported by anon memory' means?

I guess really this is the minimum order contptes support for arm64 right?

>
> mTHP collapses reject regions containing swapped out or shared pages.
> This is because adding new entries can lead to new none pages, and these
> may lead to constant promotion into a higher order (m)THP. A similar
> issue can occur with "max_ptes_none > HPAGE_PMD_NR/2" due to a collapse
> introducing at least 2x the number of pages, and on a future scan will
> satisfy the promotion condition once again. This issue is prevented via
> the collapse_allowable_orders() function.

Obviously this has been discussed to death, but you should update this to
reflect the decided upon course (0, 511 + warning, etc.).

>
> Currently madv_collapse is not supported and will only attempt PMD
> collapse.

Good to highlight this.

>
> We can also remove the check for is_khugepaged inside the PMD scan as
> the collapse_max_ptes_none() function handles this logic now.

Again we're kind of leaping from mega handwaving to super-specific details
:) let's make it all a lot more specific + clear, and then put the really
niche details like this at the end of the commit msg (I mean this one is
fine where it is ofc as a result :)

>
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---
>  include/linux/khugepaged.h |   2 +
>  mm/khugepaged.c            | 128 ++++++++++++++++++++++++++++++++++---
>  2 files changed, 122 insertions(+), 8 deletions(-)
>
> diff --git a/include/linux/khugepaged.h b/include/linux/khugepaged.h
> index eb1946a70cff..179ce716e769 100644
> --- a/include/linux/khugepaged.h
> +++ b/include/linux/khugepaged.h
> @@ -1,6 +1,8 @@
>  /* SPDX-License-Identifier: GPL-2.0 */
>  #ifndef _LINUX_KHUGEPAGED_H
>  #define _LINUX_KHUGEPAGED_H
> +#define KHUGEPAGED_MIN_MTHP_ORDER	2
> +#define MAX_MTHP_BITMAP_STACK	(1UL << (ilog2(MAX_PTRS_PER_PTE) - KHUGEPAGED_MIN_MTHP_ORDER))

This is an internal implementation detail, I don't think we need this in a
header do we? I think this define should be in khugepaged.c.

Also this is a really fiddly and confusing value, I don't think it's a good idea
to just put this here without explanation.

It's not even clear what it is. I'd probably rename it to MTHP_STACK_SIZE?

We need a comment that explains how you're deriving this, something like:

/*
 * In order to determine mTHP order, we consider every possible mTHP size
 * starting with MAX_PTRS_PER_PTE PTE entries and stopping at
 * 2^KHUGEPAGED_MIN_THP_ORDER.
 *
 * We store (offset, order) pairs on the stack to do so, each describing a
 * candidate mTHP collapse.
 *
 * For each (offset, order) candidate mTHP range that we consider, we must
 * also consider candiate mTHPs at (offset, order - 1), and (offset + (1 <<
 * order), order - 1).
 *
 *
 * This is because each order can be split into two (an order expresses the
 * power-of-two size), so we examine each half of the next lower order
 * mTHP:
 *
 *                offset   mid_offset
 *                  .          |
 *                  .          v
 *  |---------------.-------------------|
 *  |           PTE page table          |
 *  |---------------.-------------------|
 *                   <--------><-------->
 *                     order-1   order-1
 *
 * Given we must consider the range of KHUGEPAGED_MIN_MTHP_ORDER to
 * MAX_PTRS_PER_PTE number of PTE entries, this is the same as saying we
 * must consider KHUGEPAGED_MIN_MTHP_ORDER to lg2(MAX_PTRS_PER_PTE) mTHP
 * orders.
 *
 * As we must consider 2 possible mTHP ranges for each order, this requires
 * our stack to be 2^n, where n is the number of orders we must consider.
 *
 * And thus MTHP_STACK_SIZE is 2^(lg2(MAX_PTRS_PER_PTE) -
 * KHUGEPAGED_MIN_MTHP_ORDER).
 */

This may seem (very) long-winded, but this is all really non-obvious.

You can additionally rephrase this and utilise it in the commit message,
description of the iterative recursion function and possibly elsewhere to
describe the algorithm more clearly.

In fact, since this should really be declared in khugepaged.c, and since
you can place it just before the mthp collapse function, you could expand
this to describe the algorithm as a whole and simply put the define and the
function immediately next to each other after the comment?

>
>  #include <linux/mm.h>
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 89a105124790..e2319bfd0065 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -93,6 +93,11 @@ static DEFINE_READ_MOSTLY_HASHTABLE(mm_slots_hash, MM_SLOTS_HASH_BITS);
>
>  static struct kmem_cache *mm_slot_cache __ro_after_init;
>
> +struct scan_bit_state {

Scan bit state is a bit of a weird name. Scanning what? What bit? State is
kind of implied?

struct order_offset_pair?

struct mthp_range?

> +	u8 order;
> +	u16 offset;

Real mega nit, but feels more natural to put offset first here. As
(position, size) seems more naturally the way to view this than (size,
position).

> +};
> +

Also needs comments...? Order of what? Offset in what?

>  struct collapse_control {
>  	bool is_khugepaged;
>
> @@ -101,6 +106,13 @@ struct collapse_control {
>
>  	/* nodemask for allocation fallback */
>  	nodemask_t alloc_nmask;
> +
> +	/*
> +	 * bitmap used to collapse mTHP sizes.
> +	 */

Nit but this should be on one line /* Bitmap used to collapse mTHP sizes */.

But we're not storing sizes though are we? And we're declaring two bitmaps?

> +	 DECLARE_BITMAP(mthp_bitmap, HPAGE_PMD_NR);

Really this is more of a PTE table bitmap but probably fine to call it this.

> +	 DECLARE_BITMAP(mthp_bitmap_mask, HPAGE_PMD_NR);

You've added random whitespace after the tab twice here? [tab][space]DECLARE_...

> +	struct scan_bit_state mthp_bitmap_stack[MAX_MTHP_BITMAP_STACK];
>  };
>
>  /**
> @@ -1357,6 +1369,85 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long pmd_address,
>  	return result;
>  }
>
> +static void push_mthp_bitmap_stack(struct collapse_control *cc, int *top,
> +				   u8 order, u16 offset)

Not sure we need to say mthp_bitmap_stack everywhere. This is a local
static function we can be a little more succinct.

mthp_stack_push()?

> +{
> +	cc->mthp_bitmap_stack[++*top] = (struct scan_bit_state)
> +		{ order, offset };

This feels rather difficult to read, cc->mthp_bitmap_stack[++*top] in
particular is rather too succinct.

This would be better more broken out, e.g.:

static void mthp_stack_push(struct collapse_control *cc, int *sizep,
	    u8 order, u16 offset)
{
	const int size = *sizep;
	struct scan_bit_state *stack = &cc->mthp_bitmap_stack[size];

	VM_WARN_ON_ONCE(idx >= MAX_MTHP_BITMAP_STACK);
	stack->order = order;
	stack->offset = offset;
	*sizep++;
}

(Note this requires the change I suggest below re: not defaulting top to -1
but instead renaming it to stack_size and starting at 0, see below).

Re: below comment having pop as a helper too, that can be:

static struct scan_bit_state mthp_stack_pop(struct collapse_control *cc,
		int *sizep)
{
	const int size = *sizep;

	VM_WARN_ON_ONCE(size <= 0);
	*sizep--;
	return cc->mthp_bitmap_stack[size - 1];
}

> +}
> +
> +/*
> + * collapse_scan_bitmap() consumes the bitmap that is generated during
> + * collapse_scan_pmd() to determine what regions and mTHP orders fit best.
> + *
> + * Each bit in the bitmap represents a single occupied (!none/zero) page.

In which bitmap? There are 2 that are declared. Be specific - cc->mthp_bitmap.

> + * A stack structure cc->mthp_bitmap_stack is used to check different regions

> + * of the bitmap for collapse eligibility. We start at the PMD order and
> + * check if it is eligible for collapse; if not, we add two entries to the

I questioned this since you start at HPAGE_PMD_ORDER -
KHUGEPAGED_MIN_MTHP_ORDER, but then realised you're intentionally
offsetting like that.

See comments below about changing this.

> + * stack at a lower order to represent the left and right halves of the region.
> + *
> + * For each region, we calculate the number of set bits and compare it
> + * against a threshold derived from collapse_max_ptes_none(). A region is
> + * eligible if the number of set bits exceeds this threshold.
> + */

I think we could be clearer here. Something like:

...
 * stack at a lower order to represent the left and right halves of the
 * portion of the PTE page table we are examining.
 *

 * For each of these, we determine how many PTE entries are occupied in the
 * range of PTE entries we propose to collapse, then compare this to the
 * number of PTE entries which would need to be set for a collapse to be
 * permitted at that order (accounting for max_ptes_none).
 *
 * If a collapse is permissible, we attempt to perform one. We do so for
 * every possible mTHP in the PTE page table.
 */

> +static int collapse_scan_bitmap(struct mm_struct *mm, unsigned long address,

Really inconsistent naming going on here, we're collapsing and scanning and
what's the bitmap?

How about mthp_collapse()?

> +		int referenced, int unmapped, struct collapse_control *cc,
> +		bool *mmap_locked, unsigned long enabled_orders)
> +{
> +	u8 order, next_order;
> +	u16 offset, mid_offset;
> +	int num_chunks;
> +	int bits_set, threshold_bits;
> +	int top = -1;

This seems unnecessary and confusing. Just start at 0 and treat this as the
exclusive end of the stack.

You can rename this stack_size to make that clear. Have commented above
about adjustments to push function and introducing pop helper.


> +	int collapsed = 0;
> +	int ret;
> +	struct scan_bit_state state;
> +	unsigned int max_none_ptes;

Everywhere else we say max_ptes_none, let's maintain that convention here
please.

> +
> +	push_mthp_bitmap_stack(cc, &top, HPAGE_PMD_ORDER - KHUGEPAGED_MIN_MTHP_ORDER, 0);

See below re: order here, we should change this.

> +
> +	while (top >= 0) {
> +		state = cc->mthp_bitmap_stack[top--];

I hate that we have a push helper but then do pop manually. See above.

> +		order = state.order + KHUGEPAGED_MIN_MTHP_ORDER;

OK so now the order isn't state.order but is instead state.order +
KHUGEPAGED_MIN_MTHP_ORDER? :/ this is extremely confusing.

We shouldn't call this field order if you're doing a hack where state.order
isn't the order but instead is order - KHUGEPAGED_MIN_MTHP_ORDER.

Just have state.order be the actual order? And change the below condition
as mentioned there.

> +		offset = state.offset;
> +		num_chunks = 1UL << order;

What's a chunk? You do need to clarify these things. This is a new term not
used elsewhere in THP code as far as I can tell?

This is the number of pte entries no?

nr_entries? nr_pte_entries?

> +
> +		/* Skip mTHP orders that are not enabled */

Note we're also considering PMD here :) Probably we can just delete this
comment, the code below makes it clear what you're doing.

> +		if (!test_bit(order, &enabled_orders))
> +			goto next_order;
> +
> +		max_none_ptes = collapse_max_ptes_none(order, !cc->is_khugepaged);

OK so this is going to be scaled to order.

> +
> +		/* Calculate weight of the range */

What's the weight of a range? This isn't a very helpful comment. You're
counting the Hamming weight or much more clearly - the number of set bits.

So it seems you're simply counting the number of bits you have accumulated
so far in cc->mthp_bitmap, adding in the latest offset.

So I'd say add a comment saying something like:

/*
 * Determine how many PTE entries are populated in the range in which we
 * propose to collapse this mTHP.
 */

> +		bitmap_zero(cc->mthp_bitmap_mask, HPAGE_PMD_NR);
> +		bitmap_set(cc->mthp_bitmap_mask, offset, num_chunks);
> +		bits_set = bitmap_weight_and(cc->mthp_bitmap,

I think this variable name is pretty horrible, we don't care that it's the
number of bits set, we care about what it _means_ - that is the number of
PTE occupied entries.

So nr_occupied_pte_entries? Or nr_occupied_ptes?

> +					     cc->mthp_bitmap_mask, HPAGE_PMD_NR);

Frustrating there isn't a bitmap_weight_offset() or something, as you could
do that in one go then...

I think this could be made clearer by separating out the gnarly bitmap
stuff into a helper function:

static int mthp_nr_occupied_pte_entries(struct collapse_control *cc,
		struct scan_bit_state state)
{
	const int nr_pte_entries = 1 << state.order;

	/* Setup cc->mthp_bitmap_mask to contain mask for candidate mTHP. */
	bitmap_zero(cc->mthp_bitmap_mask, HPAGE_PMD_NR);
	bitmap_set(cc->mthp_bitmap_mask, state.offset, nr_pte_entries);
	/* Mask against actually occupied PTE entries in PTE table. */
	return bitmap_weight_and(cc->mthp_bitmap,
				 cc->mthp_bitmap_mask, HPAGE_PMD_NR);
}

> +
> +		threshold_bits = (1UL << order) - max_none_ptes - 1;

We defined num_chunks to 1UL << order then don't use here? :)

I'm not sure we need this to be a separate value, and I don't think we need
the -1 either, which only confuses matter more.

How about just changing the below conditional to (assuming we've renamed
num_chunks to something sensible like nr_pte_entries and bits_set to
nr_occupied_pte_entries):

if (nr_occupied_pte_entries >= nr_pte_entries - max_none_ptes) {
	...
}

> +
> +		/* Check if the region is eligible based on the threshold */

Probalby don't need this comment with the change above.

> +		if (bits_set > threshold_bits) {
> +			ret = collapse_huge_page(mm, address, referenced,
> +						 unmapped, cc, mmap_locked,
> +						 order, offset);

We declare ret at the top of the function scope, then only use it
here. That's confusing and unnecessary, just declare it in block scope
here.

> +			if (ret == SCAN_SUCCEED) {
> +				collapsed += 1UL << order;

Again we have defined num_chunks or rather nr_pte_entries but then
open-code 1UL << order, let's just use the value we declared here.

> +				continue;

This is kinda subtle, we don't bother considering lower orders any longer
*in this range*, but do continue to consider mTHP collapse in other
portions of the PTE page table.

This shouldn't just be a 'continue' :) we need a comment here to explain
that.

E.g.:

	/*
	 * We have collapsed an mTHP in this range at the maximum order we
	 * could, so we do not push lower orders on to the stack.
	 */
	 continue;


> +			}
> +		}
> +
> +next_order:
> +		if (state.order > 0) {

This is a great example of how this is confusing by making state.order not
actually be the order but the order - KHUGEPAGED_MIN_MTHP_ORDER.

Just make the order correct and change this to > KHUGEPAGED_MIN_MTHP_ORDER.

> +			next_order = state.order - 1;

Not sure we should have a label and a variable be the same thing.

Also why are we decl'ing next_order at the top of the function but only using here?

Just declare this here, like:

	if (state.order > KHUGEPAGED_MIN_MTHP_ORDER) {
		const u16 new_order = state.order - 1;

		...
	}

> +			mid_offset = offset + (num_chunks / 2);
> +			push_mthp_bitmap_stack(cc, &top, next_order, mid_offset);
> +			push_mthp_bitmap_stack(cc, &top, next_order, offset);

I guess one subtlety that wouldn't be obvious at first glance is that
num_chunks (oh so badly needs a rename :) is a power-of-2 so we never get
weird 'what if num_chunks is odd' scenarios to worry about.

Probably doesn't really need a comment though. But this _does_ badly needs
an ASCII diagram :):

	/*
	 * The next lowest mTHP order possesses half the number of PTE
	 * entries of the current one. We therefore must consider both
	 * halves of the current mTHP:
	 *
	 *                offset   mid_offset
	 *                  .          |
	 *                  .          v
	 *  |---------------.-------------------|
	 *  |           PTE page table          |
	 *  |---------------.-------------------|
	 *                   <--------><-------->
	 *                     order-1   order-1
	 */

Since writing this I copied this above in another suggestion :P so you
could always say 'see comment above for details' or something.

> +		}
> +	}
> +	return collapsed;
> +}

I've commented this function to death here, but a few more things to note.

(BTW - I'm sorry I personally _hate_ repeated iterations of review when
there's stuff you could have commented in prior iterations BUT I think I
may end up having to once we respin due to the subtleties here.)

- I wonder if we could just use a helper struct to make this all a little
  easier. Perhaps as it's realtively short code not so necesary, but a bit
  horrid to pass around all these paramters all the time. Maybe something
  for later THP rework.

- Could we exit early if it's obvious that we won't be able to collapse due
  to max_ptes_none? I mean for one, we could at least check if the next
  lowest order is empty. If max_ptes_none was 511, then we would have
  already collapsed so can surely throw that out?

  I was thinking we could go 'upwards', starting with the lowest order and
  increasing order (essentially reverse things) then not collapsing until
  we can't collapse at a given order (so collapse at next lowest). That
  might be less efficient though.

- Given that we're going to be only permitting max_ptes_none of 0 and 511
  for mTHP to start with, maybe things can be simplified - either all bits
  have to 1 or we don't care what they are we attempt colalpse anyway?

  But then again, maybe it's worth having the generic algorithm in place
  for future flexibility? Thoughts?

- How much have you tested this? This is pretty subtle stuff... it _seems_
  correct to me logically, but this is crying out for some userland testing
  that exhaustively throws every possible permutation of state at this
  function and asserts it's all correct.

- Are we not missing a bunch of stat counts? Didn't we add a bunch but now
  are actually setting them? E.g. if we reject mTHP candidates due to
  pte_max_none?

> +
>  static int collapse_scan_pmd(struct mm_struct *mm,
>  			     struct vm_area_struct *vma,
>  			     unsigned long start_addr, bool *mmap_locked,
> @@ -1364,11 +1455,15 @@ static int collapse_scan_pmd(struct mm_struct *mm,
>  {
>  	pmd_t *pmd;
>  	pte_t *pte, *_pte;
> +	int i;
>  	int result = SCAN_FAIL, referenced = 0;
> -	int none_or_zero = 0, shared = 0;
> +	int none_or_zero = 0, shared = 0, nr_collapsed = 0;
>  	struct page *page = NULL;
> +	unsigned int max_ptes_none;

Correct spelling of this :)

>  	struct folio *folio = NULL;
>  	unsigned long addr;
> +	unsigned long enabled_orders;
> +	bool full_scan = true;
>  	spinlock_t *ptl;
>  	int node = NUMA_NO_NODE, unmapped = 0;
>
> @@ -1378,16 +1473,29 @@ static int collapse_scan_pmd(struct mm_struct *mm,
>  	if (result != SCAN_SUCCEED)
>  		goto out;
>
> +	bitmap_zero(cc->mthp_bitmap, HPAGE_PMD_NR);
>  	memset(cc->node_load, 0, sizeof(cc->node_load));
>  	nodes_clear(cc->alloc_nmask);
> +
> +	enabled_orders = collapse_allowable_orders(vma, vma->vm_flags, cc->is_khugepaged);
> +
> +	/*
> +	 * If PMD is the only enabled order, enforce max_ptes_none, otherwise
> +	 * scan all pages to populate the bitmap for mTHP collapse.
> +	 */

Ugh this is quite ugly. I don't really love that we've converted this from
doing the actual work to _mostly_ just populating the bitmap for the mthp
logic.

Then again it's only a couple places where this is checked, but it's pretty
horrible that what once was _the logic that determines what is being
considered for THP collapse' is now turned into 'the logic that populates a
bitmap'.

> +	if (cc->is_khugepaged && enabled_orders == _BITUL(HPAGE_PMD_ORDER))

I think this should be BIT(HPAGE_PMD_ORDER), I realise I reviewed the
opposite before (or think I did) but as per David we prefer BIT() :)

> +		full_scan = false;
> +	max_ptes_none = collapse_max_ptes_none(HPAGE_PMD_ORDER, full_scan);

Again really quite nasty, this may as well be:

	if (cc->is_khugepaged && enabled_orders == BIT(HPAGE_PMD_ORDER))
		max_ptes_none = khugepaged_max_ptes_none;
	else
		max_ptes_none = HPAGE_PMD_NR - 1;

It makes this hack a lot more obvious.

But also, what if !cc->is_khugepaged? We're going to scan everything even
if we only have PMD? I thought we only considered PMD size for MADV_COLLAPSE?

> +
>  	pte = pte_offset_map_lock(mm, pmd, start_addr, &ptl);
>  	if (!pte) {
>  		result = SCAN_PMD_NULL;
>  		goto out;
>  	}
>
> -	for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
> -	     _pte++, addr += PAGE_SIZE) {
> +	for (i = 0; i < HPAGE_PMD_NR; i++) {
> +		_pte = pte + i;
> +		addr = start_addr + i * PAGE_SIZE;

That's nicer. I still hate _pte...

>  		pte_t pteval = ptep_get(_pte);
>  		if (is_swap_pte(pteval)) {
>  			++unmapped;
> @@ -1412,8 +1520,7 @@ static int collapse_scan_pmd(struct mm_struct *mm,
>  		if (pte_none_or_zero(pteval)) {
>  			++none_or_zero;
>  			if (!userfaultfd_armed(vma) &&
> -			    (!cc->is_khugepaged ||
> -			     none_or_zero <= khugepaged_max_ptes_none)) {
> +			    none_or_zero <= max_ptes_none) {

Why are we dropping !cc->is_khugepaged?

>  				continue;
>  			} else {
>  				result = SCAN_EXCEED_NONE_PTE;
> @@ -1461,6 +1568,8 @@ static int collapse_scan_pmd(struct mm_struct *mm,
>  			}
>  		}
>
> +		/* Set bit for occupied pages */
> +		bitmap_set(cc->mthp_bitmap, i, 1);

Maybe worth highlighting this is now _the entire point_ of the loop.

I wonder if we shouldn't just separate this logic out and name it
apppropriately? As we're into realms of real confusion here.

>  		/*
>  		 * Record which node the original page is from and save this
>  		 * information to cc->node_load[].
> @@ -1517,9 +1626,12 @@ static int collapse_scan_pmd(struct mm_struct *mm,
>  out_unmap:
>  	pte_unmap_unlock(pte, ptl);
>  	if (result == SCAN_SUCCEED) {
> -		result = collapse_huge_page(mm, start_addr, referenced,
> -					    unmapped, cc, mmap_locked,
> -					    HPAGE_PMD_ORDER, 0);

Hmm... what's actually enforcing that MADV_COLLAPSE isn't using this?
You've not done any cc->khugepaged checks afaict?

It seems that you _are_ enabling this for MADV_COLLAPSE unless I've missed
something?

> +		nr_collapsed = collapse_scan_bitmap(mm, start_addr, referenced, unmapped,
> +					      cc, mmap_locked, enabled_orders);
> +		if (nr_collapsed > 0)
> +			result = SCAN_SUCCEED;
> +		else
> +			result = SCAN_FAIL;
>  	}
>  out:
>  	trace_mm_khugepaged_scan_pmd(mm, folio, referenced,
> --
> 2.51.0
>

Thanks, Lorenzo

