Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69372CA0EF8
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 09:36:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0AE06B00AC; Thu, 21 Aug 2025 05:36:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE2A96B00AD; Thu, 21 Aug 2025 05:36:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAAD86B00AE; Thu, 21 Aug 2025 05:36:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B656E6B00AC
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 05:36:43 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 421BF137B13
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 09:36:43 +0000 (UTC)
X-FDA: 83800259886.09.50E3315
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf03.hostedemail.com (Postfix) with ESMTP id D6A7E20004
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 09:36:39 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=P0SoNE2G;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=cj3APdqZ;
	spf=pass (imf03.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755768999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t7C/ZkePXuHaSSRniUQ6zJrNziJVIJoM0SiGk5Oc5p0=;
	b=CVai8F26gIJWWNChTnao6rZugg94jtADZsmaPWszLiQuDEHY/nkA+M7gm+VguuhNflkJrN
	iEYgGOgTPlJqsPP5VPuyZ3nrH8E4tpv/Mpna3S3OnrL6Esp8UMxM12oJaXU3b79frpEa2L
	69TM2S5+1Hu9DmwO8MyT1at+PkyTySo=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=P0SoNE2G;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=cj3APdqZ;
	spf=pass (imf03.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755768999; a=rsa-sha256;
	cv=pass;
	b=mn1fWZI2oovkuIeqbOvhtmlVBmFUU36YEtwFfvPJ7SRvBQbe2MZjnijQqnzno/xBLIBcRy
	v0+1D6w1f/EjaBhipYga0aqA/K8S0LheFG5RgkpYNAVyEuqFNThGsZzLLcYvGsJPKvu0cH
	UnigDCW5Qpgl7r/jYrOqXD6CV9153B4=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57L8mUUI023006;
	Thu, 21 Aug 2025 09:35:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=t7C/ZkePXuHaSSRniUQ6zJrNziJVIJoM0SiGk5Oc5p0=; b=
	P0SoNE2GxH1Xnm54bJlQ8YzJ0rGz5WlqWYBc81uDsIiqm43J5Aq1SnJnUkwse2tj
	830+VnUJUTnJldEQb65VzfkWCPxrwVXNMsFAiEF9I6MAZcSyb8uhi2GUHzoZPpDw
	URTI2Y0BosdnYmizC4qyj1CLbrWAXoQBRtkSM+S4dgRHlBy1xPD/tkHB/9CKePQL
	99Rix8/d076USNDOCD0ExtcT4FECaBBSSc5Exy77M7HNC6wioN20hoNQU6z51CCr
	5Z32w2XgkKd3fBQa+wCykXizAInW95OH4se5ahJwmp1MENS4A/DbT6fivtnWt/B0
	Z3L/PHCUPiANggjYU4i8iw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48n0tsu2wt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 Aug 2025 09:35:57 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57L8Kavv030293;
	Thu, 21 Aug 2025 09:35:56 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11on2076.outbound.protection.outlook.com [40.107.236.76])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48my3v5cun-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 Aug 2025 09:35:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kIq3a29/hvDvwgAzCg0/XWkggr3gr6hB2jVCY7Hu3++nyAx2OydWvwgv3GINt3NPbzjZ9XHzG5yh8e7EJ2zR6izJxcn1XJREicElYodqM8UzBQ6UIg/Wvgn8X3szKa3aXh2O/xzjllgl9DH3jBAhLJceqrCe47YgiF/o/BLsecOdsiycTcmfxXidEklUq2K3se9v4hurZ2GtK7Eo4AhEa5uQlN/2ono4gHvnJ1QUSOCtFeSBibrFvZ14c/9kTh0wsjETGEkJDTkxAjUBUmwU+9E/LtishjKpiN6HRFrkzI5z7DH1J0Aqv0k9AIcTH9pY+Fr7UG29SsGYppAAmz+MyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t7C/ZkePXuHaSSRniUQ6zJrNziJVIJoM0SiGk5Oc5p0=;
 b=CtHGlOD2s3ELKVNd1/+xtmEjhYx4DLCjRpos2JtZIYFlNx3d1snXmUhope2JN6yIYtYsyq5uQIRO1xHDzOFFjC4qMd1nICkc2fhQsliO60f5oHAaNebyHe459bwe/+5mUddssNSnpUAbtwMiZ3rzu8Vk9uLhRcBCxovBP6yDg47kmVzoZ4ssD7YSYYpjZHzY7lcBxd13Vn0Xytit8De2lAIwlsDLLkt4C91NZCIYoPoiogVXhao43bNb3QU0FEDiTBVvw6+boX/TRQDNYMyk2EnsnpvEzXwN+hjMRrask9+TyAvpEPI4FT1U6E8hE/OlQPSY4YVO68H2U7pl3y3Tbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t7C/ZkePXuHaSSRniUQ6zJrNziJVIJoM0SiGk5Oc5p0=;
 b=cj3APdqZvsCdnTlS8yfU8s7p++nkrDmfA7LZnppT80corUN0aiJg0tTtB3kqAUSM3L4hDuCXbbzDEdvIJ24ePwbGnzG268icqppk5PJ+o1Jk2xgp86uyAi2jlHhSW77Ptoo8MJfw1D9U9gVpnKCRLMqDmgN2BBccO5BgdQyBm40=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by LV3PR10MB8203.namprd10.prod.outlook.com (2603:10b6:408:284::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.14; Thu, 21 Aug
 2025 09:35:54 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.9031.024; Thu, 21 Aug 2025
 09:35:53 +0000
From: Harry Yoo <harry.yoo@oracle.com>
To: harry.yoo@oracle.com
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, andreyknvl@gmail.com,
        aneesh.kumar@linux.ibm.com, anshuman.khandual@arm.com,
        apopple@nvidia.com, ardb@kernel.org, arnd@arndb.de, bp@alien8.de,
        cl@gentwo.org, dave.hansen@linux.intel.com, david@redhat.com,
        dennis@kernel.org, dev.jain@arm.com, dvyukov@google.com,
        glider@google.com, gwan-gyeong.mun@intel.com, hpa@zyccr.com,
        jane.chu@oracle.com, jgross@suse.de, jhubbard@nvidia.com,
        joao.m.martins@oracle.com, joro@8bytes.org, kas@kernel.org,
        kevin.brodsky@arm.com, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        lorenzo.stoakes@oracle.com, luto@kernel.org, maobibo@loongson.cn,
        mhocko@suse.com, mingo@redhat.com, osalvador@suse.de,
        peterx@redhat.com, peterz@infradead.org, rppt@kernel.org,
        ryabinin.a.a@gmail.com, ryan.roberts@arm.com, stable@vger.kernel.org,
        surenb@google.com, tglx@linutronix.de, thuth@redhat.com, tj@kernel.org,
        urezki@gmail.com, vbabka@suse.cz, vincenzo.frascino@arm.com,
        x86@kernel.org, zhengqi.arch@bytedance.com
Subject: [PATCH] mm: fix KASAN build error due to p*d_populate_kernel()
Date: Thu, 21 Aug 2025 18:35:42 +0900
Message-ID: <20250821093542.37844-1-harry.yoo@oracle.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250818020206.4517-3-harry.yoo@oracle.com>
References: <20250818020206.4517-3-harry.yoo@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SL2P216CA0185.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:1a::9) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|LV3PR10MB8203:EE_
X-MS-Office365-Filtering-Correlation-Id: f0023e47-4ccd-4e6d-9ce7-08dde0961f5e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?s+PFx4Rh33wEnFVsKbrGzTds2aQbqZ7ZE9TeaKqe4cRbggVAgOuUvFeTwyoV?=
 =?us-ascii?Q?RWGx47ZPyGXHJhWeDNhI0PyT2Hn/6omue2d79peuFsC0vFeLYrT23EcIgWM+?=
 =?us-ascii?Q?C1ewXlB25xBH275LaZb17hCtO6zYXFKAW8+SPv5F9bI73jXZB1szWugqBsOI?=
 =?us-ascii?Q?8ADv7XaLhb5ysoOGjp1ka4pW/GYTui/A1KsU4J1MHlXQZMqVm5T3wkDTbAZI?=
 =?us-ascii?Q?an9csBjdGYSlS7w2nkzvlLCTbmrpbh4G1vJyqUEs2NbnUEa9I5DHY3vr1okG?=
 =?us-ascii?Q?b1BWOx6gIAuNV6Fgm3nsg2feIYF5PqQ7leRNyZzIe+0G7eb5tUb0xWgyXO1W?=
 =?us-ascii?Q?dOe00PGcJz5+biS7bO8j1MoD42uJf1TiUNlh3BxyDpAKfFw2NSsXUpHE5A4k?=
 =?us-ascii?Q?W9LvIcfvf2i55w2MhuBhKRqoYO6OoWYzDmkRIGX/sReozRiRs+mFaaeAmoBq?=
 =?us-ascii?Q?hb+So4vQMFMQXeb9IM9SHTg1OkHDCtg+wM8ZltNKqbrtdpCEzNXZAammhOfg?=
 =?us-ascii?Q?MoLRGhL1A7H+ew/FveOm7fuotYAtkhLmgPgPCQbPI4v6EEbBBMWU6K+jxrr2?=
 =?us-ascii?Q?OpgkZ701Dth0SQ/Gr8yvw64df0ov10EC+39/sS6zSR9whpUIGvGyfwFQnLTl?=
 =?us-ascii?Q?AFJShwqBuO4+vv1INt2xONEaipTIevRS+zyrPjr9jsCIly5R6Ns3AREPiy6R?=
 =?us-ascii?Q?4NjZjXuyRMMUfvON5dBZh221hbP2W/MCvMV2qNwtN3+lxPeyO8iVtcAa6Xxf?=
 =?us-ascii?Q?mda5ChdLJfu/Fy5vl6dD7Ijh/7vkoAbUA6EHY923W1CUiWblU2V3rFKLvSkc?=
 =?us-ascii?Q?OlnWLwYSNNZ5SBx/Ik+QrfTY5XfxF2+Zbx9h+eqFS5gvDYuaAGMhfPJhZzOB?=
 =?us-ascii?Q?/3f/Kl4CElVCou06DcuMqRA9koPHhCBehQggLAxzsItW+lWi9AvBepsEQcEu?=
 =?us-ascii?Q?PzBF0bjOj6EWOsAe2ADZUH6Ra36V0m6tJyt16i1zn6vgPaswIx86rMlsNr+z?=
 =?us-ascii?Q?+6BcBFfLdy6PsIdpYKQL5G7LYB/NwejPg7fCSj34bTtqJ9a89E0lbewpafQb?=
 =?us-ascii?Q?9pQ2w4l/qCVqN5U38Gq3fS43hhFMcxurhNMoIIFbndDuUnHa6vlFCOPQukYt?=
 =?us-ascii?Q?Reet359taLONfz6VVJLifAwfITxFICCKBLyt7Xl0A14gur7mmfjPCUhtE7Yj?=
 =?us-ascii?Q?+yZiAmpQRQHpxiLaZlDCoM8YHpW4Hx/tO3IyycvTIEvSKZtd9qXsLJz9iYNH?=
 =?us-ascii?Q?rpiSaysxHhvvPEzzvc3QmF5A37UlOgIwOzXWFh67mPBU1L2Sl16ED3auWpTm?=
 =?us-ascii?Q?sGo2fvDA1ToX3KvfU94kF+pk67zDP59IgIs+11a9I5wc4tcS1sXHh/vsz8Ly?=
 =?us-ascii?Q?ruQf/+wCGrlwYb1G/ZcAFwv7hWaguBsDHIJ41d91E6eYBSiPLeI58QUHtBFU?=
 =?us-ascii?Q?8cLiMeYwT88=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4/8kQekAv/ISdzwDyEtu5zxs5mrtg/88pvDibvBU76OOBJBBpZYh3UKRRBRi?=
 =?us-ascii?Q?sxXwgaOxKmzH49L4UZle0DBp5nPDcdfZLpmcIDRNIUMeASUU/Nu6b2GU00u7?=
 =?us-ascii?Q?rtFycLTwiAsBOl9ARezcvyougGWHk0xidB/GWOrV4EXZfdqAUeMh/NfS02Y4?=
 =?us-ascii?Q?HnKNZGHOWJWokloZfnSyvimWtyKIPClpclJfWkeZp/mVPn3rge0id3NigAMk?=
 =?us-ascii?Q?73hwQ35rf4WDMCd4UHi3eVtW8zc6PNgUtveVoPsaBDipK0xnPatBxAYb3BO2?=
 =?us-ascii?Q?pElgqcOYfWl/X95Lw74JB1BA9IOIqkZ2X7b3FlWec8sbJVQWiiKBXDRllXPV?=
 =?us-ascii?Q?gBNtNHc+014vSOl3E9vVvxPSqdO6GoWmA/1+4Z9+a0M5Y15WHD8338PNs9DC?=
 =?us-ascii?Q?AapKWsZ4hVIczFAE6YWJe91GPAEM1ro62tRj3NDZNhayWhAkzT4Qn54SIp+9?=
 =?us-ascii?Q?s6xOWM5X3JeHHwo7yyyznw/6CVVfpakS2Dsidb99mLTXQtfR3iwEODntJvzy?=
 =?us-ascii?Q?S30ciHunw55m492Tc18ZcFPh95VAqzRP6GxZFtt+Y0K8kHqdL1/YGjBVkySr?=
 =?us-ascii?Q?G4ZmvRCusXVCK227Hy8JwCVDfRVcLBCa7u2yN8YEvOCApGqyY440AsSRrD/S?=
 =?us-ascii?Q?euqqbhlIrq9T/sdBBkKd0TgT6jqFvguSotGp75g/iIr828RiBJhBPm93oEO/?=
 =?us-ascii?Q?DDon04JtOeCu1A8EbORhEaALNhx+vc8dxuWaoGn/BviTxxgPfnTTprygEfSs?=
 =?us-ascii?Q?c/0a7Sq5+tQrO874VJZv0xdGl/HBsKAVEalRP989fEQvNpd9AbS6C4Bd7sLe?=
 =?us-ascii?Q?X4TrC5EhT+hG8J4Zy+xTzBGVyQHqCQIcnxfBVg7mRJZ+M+9FCHVk+F2x50sc?=
 =?us-ascii?Q?qcLgeiV4loFQAHfd3rWLbV9PhmacE1Td5M78MoUnfQgsFh/K+3Nnke1M4A4f?=
 =?us-ascii?Q?OcWE0JhIG6khRP9w09Vvbc23LvuPb0jFkS/gv4UdeaXKWJCim4Ij2VRfE3+5?=
 =?us-ascii?Q?c5gapCoEqiFZPD+D1FgG6+ajaMa1UcCok5FNDSU3o1o04fBsSEFA8omzkOp9?=
 =?us-ascii?Q?O0K+5CaM2Bxp/zxmb+VkUeI7Z3zJF0nkMP3Wu2EXNxsTbOA8JPd+iPGwG/IL?=
 =?us-ascii?Q?zN+XaOorZfeWHUnPDe+oBjAMcMO38crnS47VxzRtgD+DFR1pdLykLA8hMgn1?=
 =?us-ascii?Q?rXCHzdJD+lPImPb2MgxWHVxlPFi+wNn3QGJIrlfTllCNLyx3ONDjk7QNUqjy?=
 =?us-ascii?Q?A64qCt6Fo+NJILWjTIUeBF+marVn2u+U3O3ANdQz8SYElMgfupoZAKoMSQ3T?=
 =?us-ascii?Q?YHPiX07MukrQJFzSJwbLhJ0VykhM0UbJlRdaxUMAnQY67Y/0jtbq4ozFIEcB?=
 =?us-ascii?Q?vxGRQmP4IK22OHf/MTZi3eQI7kkHSnggPIKmJbfK1BlS6MXbDiSyF7sFtV07?=
 =?us-ascii?Q?OjfyMc8v1M3vyz2Y9YJ/aZ6zMvSw3Zz+LGnzYrKKPrsU8FJ2goBG2FiAHrvW?=
 =?us-ascii?Q?OJRS/1fk6ReYwT/OSQiSadwNTjXjDv8ohQLJFXXZrqpFKoGfPfLC6l7fwpjR?=
 =?us-ascii?Q?SRgx1HBhIQsjaEldx9HNbNIFuwGuLOxnLqbs101z?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	WAoN6DkpVwtG1oYJz5h2TFepBOsGMroSdy8iboreyQH7jn9i5E9vjG6PvYisgnp2bTJBYRgwmP1POZtDmy7C7VLk7aZithTynvwJnbyNjF+M1zitF2xLIcoQAWlGeT3CnWPZY55H5+qTzsX8SXaNJyTo9OMl0Pq6wfCemrewPKVNz8q4NQbgzkt7lGTWj4uDu5Cs2/+mjRVMnZl2iS5qYlR18mBADcrMJxj/n2b0vqVMfpIExPkXZNFpGSEB5AWRtRiahxBzzx5Jh8yAJioiXEI4dtcY/egxx+YMH6Np1C2Z9H1QqP1wlQYLDek1iTBCoA3f1g/6dgHDCENVtGafLJ+pGb2F7sYKaC+DKY+zGz/yJmjFzD9dM+XPp1Obir0G0IIwvOO+pDkTmQL6xkTAJ1ivHAijLbTh9eEaw0zuThYAIaEDzuI2eGT/zZqoNl1Bk+ilUhmMBxgUaFpRaMJtrRxoLfqEsYS2HaQHWP+e4iIzJgAFcI39iPQa42fHBs9brrB0fYxmWe6MI2pkBwBLnxS9g/hekGN/uAqcGlfd2VJ/BWn3JY4XbxrdUAe2og/zVa85QekRCAOJ5DAbA28o+slsiLkAvTEWMfqQJr1pf0U=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0023e47-4ccd-4e6d-9ce7-08dde0961f5e
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2025 09:35:53.6783
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RZ79UBIHJXOMXf+TSVMDjghZzTu4scIUGUHzPQ2S/fFhTTWNoo0mkI417LqqcRe9EKJyfB3TRCRKCPI/4ZgWeQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB8203
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-21_02,2025-08-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 mlxscore=0 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508210075
X-Proofpoint-GUID: KqArVyz6v0zbYgqzAzbEl6HBZBziUhPK
X-Authority-Analysis: v=2.4 cv=S6eAAIsP c=1 sm=1 tr=0 ts=68a6e87d b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=2OwXVqhp2XgA:10
 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=qG1Prv0osz8Essy9glYA:9
 cc=ntf awl=host:13600
X-Proofpoint-ORIG-GUID: KqArVyz6v0zbYgqzAzbEl6HBZBziUhPK
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE5MDE5NyBTYWx0ZWRfX/T2BVpZcBdJd
 VJ/SnKhNwr8tCnVgatYt1hiwK01nRwxdAXh2oDLPBhiOFV4oseb7MhWKNwQKilSs5AnuwrK6POR
 vxQ0L3qmaaj2JoCGpQ2xuWDC6JrrBBu3IBSYsP+mo8HLFgTw6jgcnb/4vIBddHwlFnCzUUo65X2
 hkV+qBx939nElwHA8i4e9LF+6EZaEvbUvoG4rCtDWUrXk0Le1498XKUU2Q66xuVx+JSGX4M2jc/
 XcrHXE+Eh9a90o29vbmxuilpvXRHARBmLYxp6JuHhG4lzr/+/R7iYmhlfqH8v80FUrU18fkYcYa
 2KR7A/+KXn4t6R69oxUFhkPwTJ4oqcZCbFALJeTKOSVumihrDagjza0mHmDuQoNHT2Tph+Vy5tA
 eVO54R6tTErXiUn1TZSpuAkYd4PZUZr1fTqS42Qv7ZL8bt/mC9I=
X-Stat-Signature: w3ycne1rwtb7bg4xz4mizn8fphdaiftn
X-Rspam-User: 
X-Rspamd-Queue-Id: D6A7E20004
X-Rspamd-Server: rspam05
X-HE-Tag: 1755768999-448578
X-HE-Meta: U2FsdGVkX19S2KsQrSdUVpm0LFwpgdctYeJa5H+1aXAeMqJfs+o7mY9xx6IIGYxszwAWdKtepaozsNRGjGiu3ona4SMHCGngWr38rHnvoIs82rMrpfyFGMFSZc13WMQA2n6fc9ddaM1yD6+P/SLUrtS0T4Ee+tqxTqJrrVQer8m6Wr/BOqD4wjsQgRUC50T36umusRtLxb5w7DNPtiUQowLYDm2oclR/76C09/QdYQeg2jf78fBiySc4xuZfnKl0yJbKZh75mJvelZdXbKo5RwwcpgFNmqjrhFuqkQNX0DdIK+2luHHoCzajCBUA3mSHBzjuI16C62AOdbzhh3m6qTWsnHZLVOMR1BV+ViL5bqzuf3xmTkBpDOpwaT9Ab64m2aYtWlXu3Pb/12rhmTJpJ7kfG7kL3cOLbI3e/cb1L26fl6AwTV0g3obExkA9Cwv1N3KaHyX5VRm7xBCRyWF2Qgqei/Jyd0Gp+u+0gSCtFke6Dm2zchKqp+1YvXadsHMb1lfUJQ7dj7Bqq4vRq1Y3sFEWuVq8I82vqqe76zjzSLJqaHA2+xkDuFBOqmkuig7a1TDFYaRCnVtopnrxfFma+fblKD/Byayy+7eV4zMcBX4fRKC7xlO0FylJVdvINQmK/1uhqmLOmlPNujNwA1v1U6W0ThW1UJkEBzsV2YMLztNCBE/WDVLthas89PVyiHsoKuDSm++1BsYy81nPCJpP2d6EQnVg1Whwkv1o/aQfI//rUjiP+nvf+aasEKH77/YwPM85/nKqdmm8qlF/yjYHE+SP8Fa3YXnQr8b9LKPIYzbMI+RwtiBj8OR3L5qpXSbNB3xEHM43sq5JFyx4kv4pUTZlpyaHbruvYObutjPMjt2odO/QMmU+YQ0984gQMZBoMdCn2ey2jYF4To+RXcCFxzE6vBtnwvo9aKyAOUmrs4MAIZEYcMQgbDh8hxpzOE6pRSjEwDJ8w+6rYJYz0zj
 XURhLk9k
 L3xGnbtmZXrdXgcwRAmUvfyTPbxiFst05nrNA5DtTSzEdhpF8OXEvbiCwoRicK8fC9k1hDyh2NB04T4zVI9sT/06WUEweeifFck81wCpPz4tS5HV/h8cEh98nTWQOPw8+qJMLGFOuiJbFHvIwaRi0YXylqpHRonEHt2u6WT+O8tucDudSciauMIoaQsj7rJObgSzi0NT4CWUp2Jy+IK1S3j2WP0wGN2VM6yEQvHt8VwbMu8px+8/deCgZ9dhbYLZD14ddkMB1DfJ1bERLhtpVEyzI+YmloMhv/qdaDyk+JnMpe29h1GIrE02reWtoNri/N9++9ydg7eMfPC3MEZ9fEczFk8vVtUyu2/OfkFiaAgWy8WsXjhxLNKVeEUd9sgN8zfvdy7DiREXTGf6BHgovQDDiK03qlm36E5BIJ+gZGMlrJ2by2zvCmFJ2FYgDgOwS3C54xd+Q40600/H/WXc+3GERAr/byfaIimsEQQG62aaxYPjbRE0m198LdRFgcfEfDKuMQy93HjXkw/GtCgabjrmEIjBFlAvwYTEVJmyFcSGO7WItpXXP86Mb+XyBvCz4HMUYhkKuqGEhTrxA+1P+7IXfCtr08kFO42wflaJbKUBUqbvbW+mO3EZRn2offnyFU7ZYUAmUX3P1E3SfVZdvQUGOfFaqcpiHy7tA8QH2wbTzxFtYRr+5sCBJl0ttxBQUYfU4QlsMEFQx1fITOG9YRuuvlT1mCJWObh1/FwbOKNIN5IcqAt0fI1WaeSebZnrML1NrZYI3fxGXqzcY9FDret+a4bI7nn4W2+yhx7a9N4zVXS51aoM/m1b4Si5q3X8yA0KleT1k7RnetuOKrEuI7B3IEdLVg1NyAT3qNtjjBF80Q2V2ntgA3N2pLRFuGeVmWPTcKxvNi4uNZ7RT2+7SnpQlfg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

KASAN unconditionally references kasan_early_shadow_{p4d,pud}.
However, these global variables may not exist depending on the number of
page table levels. For example, if CONFIG_PGTABLE_LEVELS=3, both
variables do not exist. Although KASAN may refernce non-existent
variables, it didn't break builds because calls to {pgd,p4d}_populate()
are optimized away at compile time.

However, {pgd,p4d}_populate_kernel() is defined as a function regardless
of the number of page table levels, so the compiler may not optimize
them away. In this case, the following linker error occurs:

ld.lld: error: undefined symbol: kasan_early_shadow_p4d
>>> referenced by init.c:260 (/home/hyeyoo/mm-new/mm/kasan/init.c:260)
>>>               mm/kasan/init.o:(kasan_populate_early_shadow) in archive vmlinux.a
>>> referenced by init.c:260 (/home/hyeyoo/mm-new/mm/kasan/init.c:260)
>>>               mm/kasan/init.o:(kasan_populate_early_shadow) in archive vmlinux.a
>>> did you mean: kasan_early_shadow_pmd
>>> defined in: vmlinux.a(mm/kasan/init.o)

ld.lld: error: undefined symbol: kasan_early_shadow_pud
>>> referenced by init.c:263 (/home/hyeyoo/mm-new/mm/kasan/init.c:263)
>>>               mm/kasan/init.o:(kasan_populate_early_shadow) in archive vmlinux.a
>>> referenced by init.c:263 (/home/hyeyoo/mm-new/mm/kasan/init.c:263)
>>>               mm/kasan/init.o:(kasan_populate_early_shadow) in archive vmlinux.a
>>> referenced by init.c:200 (/home/hyeyoo/mm-new/mm/kasan/init.c:200)
>>>               mm/kasan/init.o:(zero_p4d_populate) in archive vmlinux.a
>>> referenced 1 more times

Therefore, to allow calls to {pgd,p4d}_populate_kernel() to be optimized
out at compile time, define {pgd,p4d}_populate_kernel() as macros.
This way, when pgd_populate() or p4d_populate() are simply empty macros,
the corresponding *_populate_kernel() functions can also be optimized
away.

Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
---

While the description is quite verbose, it is intended to be fold-merged
into patch [1] of the page table sync series V5.

[1] https://lore.kernel.org/linux-mm/20250818020206.4517-3-harry.yoo@oracle.com/

 include/linux/pgalloc.h | 26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/include/linux/pgalloc.h b/include/linux/pgalloc.h
index 290ab864320f..8812f842978f 100644
--- a/include/linux/pgalloc.h
+++ b/include/linux/pgalloc.h
@@ -5,20 +5,18 @@
 #include <linux/pgtable.h>
 #include <asm/pgalloc.h>
 
-static inline void pgd_populate_kernel(unsigned long addr, pgd_t *pgd,
-				       p4d_t *p4d)
-{
-	pgd_populate(&init_mm, pgd, p4d);
-	if (ARCH_PAGE_TABLE_SYNC_MASK & PGTBL_PGD_MODIFIED)
-		arch_sync_kernel_mappings(addr, addr);
-}
+#define pgd_populate_kernel(addr, pgd, p4d)				\
+	do {								\
+		pgd_populate(&init_mm, pgd, p4d);			\
+		if (ARCH_PAGE_TABLE_SYNC_MASK & PGTBL_PGD_MODIFIED)	\
+			arch_sync_kernel_mappings(addr, addr);		\
+	} while (0)
 
-static inline void p4d_populate_kernel(unsigned long addr, p4d_t *p4d,
-				       pud_t *pud)
-{
-	p4d_populate(&init_mm, p4d, pud);
-	if (ARCH_PAGE_TABLE_SYNC_MASK & PGTBL_P4D_MODIFIED)
-		arch_sync_kernel_mappings(addr, addr);
-}
+#define p4d_populate_kernel(addr, p4d, pud)				\
+	do {								\
+		p4d_populate(&init_mm, p4d, pud);			\
+		if (ARCH_PAGE_TABLE_SYNC_MASK & PGTBL_P4D_MODIFIED)	\
+			arch_sync_kernel_mappings(addr, addr);		\
+	} while (0)
 
 #endif /* _LINUX_PGALLOC_H */
-- 
2.43.0


