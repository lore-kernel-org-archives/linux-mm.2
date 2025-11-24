Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC2B9CFD350
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 19:14:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C59B6B0027; Mon, 24 Nov 2025 14:14:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29D056B0028; Mon, 24 Nov 2025 14:14:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 165396B0029; Mon, 24 Nov 2025 14:14:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 022E06B0027
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 14:14:33 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 660DBB9B61
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 19:14:33 +0000 (UTC)
X-FDA: 84146452026.20.0E6EA81
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf23.hostedemail.com (Postfix) with ESMTP id D94AF14001A
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 19:14:29 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=oW+OrS46;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="asVG/hHj";
	spf=pass (imf23.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764011670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sN3eNhCF45fAXJyhhHCDpkHIhn5l6+2sl3rZGyyNKWM=;
	b=1gnaNOsoVMuuOSFKyxh5JmtgW2mWU4v9irvnqYdyBtkzXBQtGCU/9h4d4lE4Us3ucjyQRC
	ovL/Qv8ksdebEsOPDPtROfwtCQZWxlHC/iA3eOnQqeem3ZRvhkh3f48bfgDXsbyUzLHnvj
	Dm5xgG+EzhbnItwBDg9QfPMW+ok4jJk=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=oW+OrS46;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="asVG/hHj";
	spf=pass (imf23.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764011670; a=rsa-sha256;
	cv=pass;
	b=YlqgKsrF84wAWA6uedUyvAhfwNl9u/w8OUO5Se2F51Iu5cThcepSkC8CRE8xstBymI7a9i
	LHi38whkfCqa1UsrGsceGCq4mmauncwd8dJLBCwQAceBoZzMsF7GxlstllycyqVjmdk0eF
	AAr1BfpUwZr8O1n5rzceLKxUzh8b0p8=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AOCVDHN1031956;
	Mon, 24 Nov 2025 19:14:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=sN3eNhCF45fAXJyhhH
	CDpkHIhn5l6+2sl3rZGyyNKWM=; b=oW+OrS46davG1IpCj2+ZQysrttlvY9VASH
	nHdn8dcr1HwWs1kiQrxBDiQ+qpugodDNva4CydYaITbTXDXB8CFZBBdVomXD/h2H
	w60K0LEp0U3JCtEdMHbH8JrZcUFIX0DgyLuOBPjRGPyGUHdUqSBzah45eLJIJ/p4
	16UTbaUmiUk10FW9n+L9/54V6GaKWZZfa3t7uA2AEP+hfL1lS3g0xaHRKINrXv2B
	E1U2pqJ2COrdxj0A5xyrJvNOBhYU1677+Amck4W5M7qhEauSBIRq4PRxcIdb0XUD
	od0ibN46Nc3x35tjuCd/++D8KPoUsKl5/n4zJ25M/BkmtCCeHYFw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ak8fk2pmu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Nov 2025 19:14:20 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AOI29up032866;
	Mon, 24 Nov 2025 19:14:19 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012030.outbound.protection.outlook.com [40.107.200.30])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ak3m8g9c9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Nov 2025 19:14:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yJdPH27SP511l0dQwDa9MfaRvyFxbe9uLBbv5L2tiqWnLu11n0Exa2cq7DwbMsqoqHHDqqUJsdFPZFYdUO2s92XLn4r5m6WrGPV13RZww2zZuoyf4sM6Vlg3VoFqeP3GG6M2vu3tnlbpPOHVcho2KUP8c7ymVx+8P7RPBQZNaN8SS8kHAPJOj30uc+sXbPeypoXORaYBqBFY53woFTw1axO6BhcDzNq6N4yjuSr1WH7IEKvUtzJ5EHCzpidnrkEjclXSCIpL2YOfwSRcJdwMqNvh4dNixXGTUmjoEmReUNSlfg+GlxVGf+Ln05lbexrnUwOLoHrzZfEzMN52DIMjSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sN3eNhCF45fAXJyhhHCDpkHIhn5l6+2sl3rZGyyNKWM=;
 b=NEMTUqcibYy/UxZjB8xmBMC+Pu0upqWU4nI2X20qbJY5gsD/bEEz2jdEUljqCjcWCJpUycWGcCgQXTs2l3mgbZJJ3lu1mO6Vy0lBgxfLDY1Vtxj8nH3v6lCwjifnq+HOtFoUvBp/w1GZ3XIRwbv6WkJG+rPa55XIfgNQmSMZ4qAL0SIS/twGP4V8GdBlsSuPoS/SquMlyCXxbtmho0WhDRADeiRPldmbSfcAHcLicgM/yhKJkWJYJwZiGLBH14SRQ4enhhdDed0KAUw//8Qojn/52aYNZsUTyM+TMfJjzvrEMIZkxcMiZS3YV1vDbtbLoCV8bBSVqpeDLpvIv9YiOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sN3eNhCF45fAXJyhhHCDpkHIhn5l6+2sl3rZGyyNKWM=;
 b=asVG/hHjMy8qHWkm5jn01t/pob9xALz5mhVJfitKICOCicZ3qsgc7qZIGBRyhPj4qFsHzHuQxKWZuyCbke4wy3emZvs//pM6iVed8xAD73GP4PgPBfb/zXInaG6pcbIVhmihN5L9q2e7/x5qtd9VL5kdRja2o5qj/PPxta1BBlo=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by CY5PR10MB6072.namprd10.prod.outlook.com (2603:10b6:930:38::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Mon, 24 Nov
 2025 19:14:13 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%6]) with mapi id 15.20.9343.016; Mon, 24 Nov 2025
 19:14:13 +0000
Date: Tue, 25 Nov 2025 04:14:07 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org
Subject: Re: [PATCH] slab: Remove unnecessary call to compound_head() in
 alloc_from_pcs()
Message-ID: <aSSuf5OG41sOGryI@hyeyoo>
References: <20251124142329.1691780-1-willy@infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251124142329.1691780-1-willy@infradead.org>
X-ClientProxiedBy: SEWP216CA0112.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2bb::19) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|CY5PR10MB6072:EE_
X-MS-Office365-Filtering-Correlation-Id: 0903e63b-9a34-451a-dee8-08de2b8da73a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?sQfw0GG4Gxmli8eCEGw6SZCqTvUVoo3SV9I3DhDCBhP40NJ3TuU1koymp7QP?=
 =?us-ascii?Q?JpJ/yymWV56Nt1ZDLdJ8OuBFGkMOVKtIg11ND+5c7rgtUW/8340NnIqvDgtY?=
 =?us-ascii?Q?xGWFK/W3QUQMPTP/zi7x/fO/JtDPIic7jeE/0xScfG+QKYxpM77mnDQdz0CF?=
 =?us-ascii?Q?x1ji3gPyhvTKVK6KeNKPaIPpd4N97VLpUOkjEoiGfWTn5l4jazj3ZJzbyAMl?=
 =?us-ascii?Q?xA5ZafT+a9KtuVsmib1oTIx9+ZCNBEQ1ndNqVQiYr/BFviRoKo3Edtxm47qd?=
 =?us-ascii?Q?sGQ+niSbmFuqkUvSF8PtA1qoAFZgTVhUOG7/s2kgD+1n+ONQdLsN39yEbMC1?=
 =?us-ascii?Q?ZJGUv0ICPLJcNf17283hClKzgZ0MLUHVP1uDTEnzzB30M2u00hOPaNlBs8wl?=
 =?us-ascii?Q?nWQUDbmrwUvw8RDkZpjf3Vpd+zp3OYz74zNQC49f7WgRqaD933XqTjn6C/hA?=
 =?us-ascii?Q?zvNhPto/Pr0ikQjzO0lY74Pr3odxBHkU1B9B2Bdzsu+0RrJ1TILDkshDAV0D?=
 =?us-ascii?Q?/EecCSdXlAcRvkDY6q2OdU4up8K4GR9qPRMfjUlHonuIhpPsAgIpqjCZbmQY?=
 =?us-ascii?Q?vfMHhAxZpdFzbpbBwooyXpIObndRtgYlmur0huHL++LkfeBqKBNVJIzTArmm?=
 =?us-ascii?Q?wEBx/bf7vVplHxtvL7GZKQrBiQUWCG2kf27/F82JdTTix5zxWrlt/g/xURDF?=
 =?us-ascii?Q?yDFI2CeMHR1hn3ohR8VyZxtveHr36b9+opnEd5uGQf4rZrN0PyQcc2IAHQXl?=
 =?us-ascii?Q?4w5Bej9fTX5JfpSjABBRrbohiGOJ0SisBCtecsWDoBNUH3CxNS98OIoO8XJX?=
 =?us-ascii?Q?+qaYYs3eWdvgxd/KQleiR1yANF7LL+thyjAVMpEo9n35fAANG3PVE8CCpIA/?=
 =?us-ascii?Q?SFMr5JB4qtlIoo0xnrst2uCNMDXaFOHkhen8IQlvKDWrYDsSTircjknsHm0C?=
 =?us-ascii?Q?0GlLEktY2/dTh0Y2LYs+4BxuH36MO+gFuacRFbrsHgx12AHcHu5h0CQXvCSx?=
 =?us-ascii?Q?gzF2FzRjoiRYHTMMlApTjfSFPI1tQZLmQue3RYOHimsKs4BLHk6AkccpR77B?=
 =?us-ascii?Q?i9R2i6B7WoVjUc2tF6VloRysLJCATnsM7PYt3KwBRl1IDDk11NdQ1ssMW89v?=
 =?us-ascii?Q?XlBFX7+QeG26v14ivvWFeKf5bGK14P6Ky7W2LTEXK6MIMGrXqikudZp/5Au+?=
 =?us-ascii?Q?GOwaDl/BSYK3foYExIHLbVHk47gX2/3Pi3V5j92IiZDQkSWBbTvhX5aCnv88?=
 =?us-ascii?Q?cBHosdbDA+bxBC4kzfZ8eUKX02S2L/ProDcIeJ3EoNJshH5M0bdvxvDuLd82?=
 =?us-ascii?Q?s/Ef1rSgdFA/P8v/1vy92AzvttUDhK9eHZDqtElATytvF5cuCippE2HXkyHF?=
 =?us-ascii?Q?3yFUHE3WhAS7X8DT2alASCQ4SO+hqfgzdYplyZssdE2DxXgCpb9nOlIEAb2I?=
 =?us-ascii?Q?Qkrijp8ENogXD7AgiqeK3/r7ZAOfCKjS?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1KqgRWJZ0DPvlvTudsLHvKuV28g2G5aL9C/5q3LuyMX12rGGUGjBK5WMW81F?=
 =?us-ascii?Q?RrW7OwRIFH5MsnoJt+IeeOfu2nTcM3b3OpupHHbDFysvH31z7PypFZujbSuX?=
 =?us-ascii?Q?sNH23IyK84EBntGlQtDfLB+OzmdHPfzREPZDRbijIIfBieQa953wfVLDviMR?=
 =?us-ascii?Q?xReShP5JjXV6925ckipat3x9h41e3Q3irVJ9tK1imrmL+teFRhZy4c+ZL4nI?=
 =?us-ascii?Q?ty/8uXd/jB0MiJHCK5j7hRxPZJSyVrYOW36GJj5rhFWnNWi0Uzt7GtO7oB5w?=
 =?us-ascii?Q?MqAoUrYb4i6YLCqBJGYnpEUQ9nfQm8ODupJ4Sg+CRJMLNLXgREcNe62cANwK?=
 =?us-ascii?Q?PBt3jiH0DxFmnjfjEQ9O5kO4hHJnSvrJT1iFqAgc6TDMQHD5brkHM4u4x3Ur?=
 =?us-ascii?Q?WW8w8xd+yywza+Ho9fSX2q2hKbt091G3x7XOLnEKhxxYWt0x18xRs/fYyY2x?=
 =?us-ascii?Q?EeSmk5YE9v0iCBBzEOiROvSVMNmOE3TF2V6JKq9mwYQsRLFNB5u2cU+ZG/mf?=
 =?us-ascii?Q?ULxvtqjgPp3pB7n4r6NmQsTFmyLZQOZZcHvdDxiFQUXU8vig5BFEY+5Gbl97?=
 =?us-ascii?Q?BC25Npw952++medKnVlxU21KlzBHnSH/Y6+Dxw+3mASdE9fxCw1/PMFZtVYM?=
 =?us-ascii?Q?AecBvxjvphhpsp1/9UpZqLtrWa9ynbwzTK67cUDm0r9Z4h/GtOlXZkS2vLEx?=
 =?us-ascii?Q?31lUUqCFMifru6d1uShUEXWOA/d27/cw4eKWhXzPVqPO3S8sSdbLP7qg9hjw?=
 =?us-ascii?Q?gG5GaByfo1W/9ahZ/fJmpXNmuRpZXpclwpz0eKyhtk8x2/omVmfS2XdGN0d+?=
 =?us-ascii?Q?uAOAVonYQnvINHmtQOsPqqV9C1McU4VqZiTRVtOeUBqm9NYt6dstvLDnKXev?=
 =?us-ascii?Q?PVEABlFLLezgeoiN2YqHmC1h4lloI/yzzlUHOYJyMECFgcUw40J9XL0gzJh+?=
 =?us-ascii?Q?pdExPaAH48wQ/bvaPOMfZ734mKDprekhwZz8ZgX9gfWgixSb9gaXXjVyXGFW?=
 =?us-ascii?Q?+PTr6HHWjitJ8PBMnMxYBvm8Pewr3H2mukmQFxhr+kpI772OEX3yO6Nml7QP?=
 =?us-ascii?Q?ugIo9jfUl6nfbHbVikSzQn0hKyssPGY16k3pIepoccnVs0iEEE7Wi1kuEwf7?=
 =?us-ascii?Q?zqzYZgos/lwVe5A58WtXByr++cfv1nBeTPiQa02xsdm4A4zubJcumcKRdxuu?=
 =?us-ascii?Q?N6tNvSwizvJ/mOJUQkgsVz/VUcS196GC0JAteGeOI8Rfl2rKiu3uhFYiGDoH?=
 =?us-ascii?Q?Ja0MUnBlrMo7HRPUu7g7czR+eIjLZVS0BlDJeKUUUvaVz8oQxnuqs8VjPdxa?=
 =?us-ascii?Q?H8aaCcUAPi1iknJhXuFJQpoXo5ih3eMIk23KMqzdS9CRV4i74ZEBCWgtghhK?=
 =?us-ascii?Q?6YEJE355s3SxuvNFJJnGFQYAOm9+Eru8rexwWlXK0cF8zhH1gVFtlJ1mDAet?=
 =?us-ascii?Q?+YbDYaLC2aitPIuB/1I0wEf4c/tu5jtqsnjuFNOp4fFmX8ha2fFAQMsEOK48?=
 =?us-ascii?Q?xrinwXiVHH6tVxYkMqfA10sHc0dI2bv7XbwVoA2D5JfPt/B0qxUPm4Zz/Fz0?=
 =?us-ascii?Q?DaSEDRNHKSvrsSn2V1SNMyNLDbhbAr3EbGSPz0VT?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ulIBvnv8linm0s4a4qMXIiTe5uJEEXprSjNa0xvts3dfb3yvehwjYtXKl/7MOyGxheKWJFDamQHl3iJL8PqKdpiriDdPPx/0Js8ayRvZZwXCUZ/i5tqxruLp7LZYedX7J3e+Yqo9YJ4R5KfYQIY9PmIAvTGKfQw9y85JXvH6DD+RH1Inn32lh6Js15OCHBAzIfjBoxjvx3fXcz3dplMmGMw/Po8ubTz1pdcq/yVq/ttBB1oK42XYmOmIpz6Bk5/qqHuqv+X1kdZNdJfEJwu5FEGz0Sy5IKBQjuiuOgpYGittuRL5GbsZ/cTH7v9xZ7f1vM8qC14RAj/MKxslqQyl6j/xMFrjA0uU/CPLDfFNh0rQ7zNwFeNSgCDZhjqGTAISUP+08ztMrAmtsia1/LGR1modmwpLoZvtbNtt1EYYeSQyHpxGNh/jhXxjjzMTtGvrQ6w6shr8SNnzoylUr5T8q4TUH1qwH74iyQJelRjPoon3NBNsRySqg6xN6F7PrSovQy4rbhn4RDjfx+UxZJrIlpznArJBS0FWKak5RJbB9KLcp0k2ue4USKRBdC2PEFiCc8S5Fk9LyjzwgqQOJbSjG/ZyEYWXH4/J9NystFL7yFU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0903e63b-9a34-451a-dee8-08de2b8da73a
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2025 19:14:13.2317
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v9tqvModo5WTxDk5c8HG/cUj/Lck2JYYgFLp35MjC3diYOkg5oFJqzDkfDsOmdV3dD7s7eaDDnXtXubTvx/NuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6072
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-24_07,2025-11-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 malwarescore=0 bulkscore=0 phishscore=0 mlxscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511240167
X-Proofpoint-GUID: FPWV3BPRcJ79a2Hi5BZ0L0iaTrEm-GQG
X-Proofpoint-ORIG-GUID: FPWV3BPRcJ79a2Hi5BZ0L0iaTrEm-GQG
X-Authority-Analysis: v=2.4 cv=L+8QguT8 c=1 sm=1 tr=0 ts=6924ae8c cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=JfrnYn6hAAAA:8 a=yPCof4ZbAAAA:8 a=5xFHCqKhxmq1V3X0PhYA:9 a=CjuIK1q_8ugA:10
 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI0MDE2OCBTYWx0ZWRfX7DY0hFq2ihHa
 t9pmqibhWni0vsink9ak4LTEyROTVX8/XtpO28KaZi0CJxrMZlEScJWnQwMEBtBGOjjR1PaAsr/
 rNbDlHHZzu8Mdn0IvyW70Y8DDF3wOseZsRzf3k0VHUKGnLin6uHkH0Juz6JgaL3zZrdyuCY3UkU
 /fwDUpDnzfExDr84XXX1j/+tJ3TNsD4yqpVri6ghQIyKgs6rnJmjNY0KgngoZnaJ562wzFeKNCq
 Se80aXS4YoRc6jbUnRc01oouHV0bbDixt/wGwLIMy12W6aKBgCnkFiS2MrSZUZuRuuNjofAHJga
 /wSzvORKN3wV5+n7lyMa+z43LG1JC3R6G/4ijT7q0U5NkT0N+8JIfqJ1E9NHxI0w0vB4M9qsCdU
 Vl+x6P2Tku1oIddDLjGXuj2QXuNpPA==
X-Rspamd-Queue-Id: D94AF14001A
X-Stat-Signature: b5pydp1hk9tays1mkq7dzojybcemq6gy
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1764011669-354307
X-HE-Meta: U2FsdGVkX18TM5686ir2BpLsIJSYgQ4wZhn1FYcLCZaqhIyHQ9aKKWpxP4P5gCKygyv1F3ntPKPOFNGuB9B492z4fueNvndCIe9Cqky4unYKXjRMFZOyulf7IW4QPyHrI1dAmtY7U3W1bkK67/YMk9+23ceMEds7fEYCUd9MNha0gUWn/WxLuB3/cmO/40N8Zsj0p1S7TnliVoSM347hm7bPssyTLc2tRtnIMf4vtgF+JXBTVvUFupljr8XG9GHGHakgIlIE4VGM215K9wIbR7JrkwLBe93ONGQgjpChOZCoZmzXjsp/ZiPFlyiFKfuHmjzoKBI8Kfe9XHF/jSfq3BqajaB2sADfh0TeFGNCyMQP09x8VxkN09lyZ3h2cpU42y6bq9hTnXLfuwpYgXOSwyp2KEYEdS6alKRa3OF7hPp61dr73FJsP7U9df0Jeg6e+3ob+BZZCt3JBiw2Wv+EB3n0fWYcm8m4C+7yqEUOD2eHF6l+Uag8xzyaepcyi9/t4vD5VmPS47r5FZExPID7MBSJnWbv8/ctJyyKqyjPdM7Iv4c4kzRx0o85kVkrq9Fbm1LtLPYT8LCLLuoLpmMqYbysvrKI63U0cOOvApZgIaiWr/sKifEJ2D80FDaj4Q800fIOxLZE1GMO1OXj7PnFc70PGWu5Q88riCUF9QPE1B+7jziL2cwJiVMk9WgJrcVVNDS9oMumADJ3/x6nHATcfxbCjRc9XWvIXM6iBtY1bKsATxVQQ4v4Y/5z6relxtzgGLiQC2uFHnb5cKP/3nC4YS9QFfATiWrUPfkLv79XziDfyiZzwstdzm0P+DhZ9azW+rIsrdkUx/86T0tl6kxJJiBudJtFLbDIAqvjZYyobPRZAIkbs7NEKW0JgvFKbcJiJGaIqIGX2caUWSowRVz9uuxdiGyxqsckDk2OYTbt/JxyVsMlmVJbu2lhY1dVXBfMgAd0hg+Grre7iw3e19D
 WCksz3kG
 n9rAdXMsgb4/iW1+vsGXUfIkLzz0ky936eUsUIp5WkA9le1j7WBlDASwixq5XjkYLnFbCQo2fo4eopK0DloamE1ThabFEjE7u8NGhEMsP+6C+akeAeriEG794pcAP+Nkh9hQhlY4sXNjHYi2iCOCF/WPsJQEBZjgIU2fp4Ig9ZFGK5LSsMf2bTSFC8gX2zjTbrl+ZjvkNOdnU0sxSPZHlCKGSpcbHcmcEvIH5jURn3HUmUVDpSeD+bUtQtsbU+g9InaqFkGY5n1IpfQ9F72+9bXZTvjjYCyO+3HrtDJfdjShBcxDJFsHnYawCLlGtNfxG1DCJMpwB4cIQYDbQeoa1VXAc95R3DdBs1RccsX/LGgl8rAZY1cQ/CD7HV51Ml3NaoyLcFFZp5AFD/i485S0PAURBL2ESKooCMSTS1K870Jc5Z+CbIwZFk74ac0pUkC4uuurDxCvGvQNtE7ZnN7uoxX/0MZPf/AtMuOafumYVRrQNginMnUTpXdVSac9CGTSAgS9s1LqeoMha0tndMp05ukYARb1tKwPels7MYm9rWWmJAcz3OE/OFpA1BTbZRzHjyflUNKpplaan1N6ff5+xTd9I8Le44xYX6UpoKBtIRUZ9e5HXWhd2XK1F4Rt6MLkgB6P8+NpINbM0ewDXth0hCaCEcPTuffrOy09tratO8MIUYExoaw06JwYxnBFiNhKkVdeVXFzj1kMwVfBLpN5bPL9scXedyYh7yWOUebtR97xhgNHPgHdbUDldNw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 24, 2025 at 02:23:27PM +0000, Matthew Wilcox (Oracle) wrote:
> Each page knows which node it belongs to, so there's no need to
> convert to a folio.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---

Nice observation!

Looks good to me,
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

>  mm/slub.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index e4a02586dacf..e6a330e24145 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -5126,7 +5126,7 @@ void *alloc_from_pcs(struct kmem_cache *s, gfp_t gfp, int node)
>  		 * be false because of cpu migration during an unlocked part of
>  		 * the current allocation or previous freeing process.
>  		 */
> -		if (folio_nid(virt_to_folio(object)) != node) {
> +		if (page_to_nid(virt_to_page(object)) != node) {
>  			local_unlock(&s->cpu_sheaves->lock);
>  			return NULL;
>  		}
> -- 
> 2.47.2
> 

-- 
Cheers,
Harry / Hyeonggon

