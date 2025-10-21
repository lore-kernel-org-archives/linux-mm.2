Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E358CCD1A7
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 15:35:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A21238E0011; Tue, 21 Oct 2025 11:35:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D11B8E0002; Tue, 21 Oct 2025 11:35:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 871FE8E0011; Tue, 21 Oct 2025 11:35:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 71D5F8E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 11:35:40 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1C5BD1405F8
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 15:35:40 +0000 (UTC)
X-FDA: 84022521240.15.C2C7583
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf18.hostedemail.com (Postfix) with ESMTP id 7EFED1C000F
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 15:35:36 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=OYj4Mo2i;
	dkim=fail ("body hash did not verify") header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=GUYMegKr;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf18.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761060936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=94Cl0G9Ly1WF+yJrGwzluYPcnRg6CfeOzivHR47JMjI=;
	b=eSEigWZItgOQkdt8JjMfvt/aIACwUyZNa3Ly4QjRdJxnBlGiNbTH5sl+l8W5jlZRM0eOR7
	/E/99DUEunFuQmKNY/FDTvX0JFJzc7YD123/nwWHAH8tktVGl7SNTxURDIM5kGV9K+19wJ
	qOaSbWPcIAQs/jcIxaEDA+M/ZlEcziM=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761060936; a=rsa-sha256;
	cv=fail;
	b=l0o+gxmrJovgBbAUBZr/pWZ/LZpnw1L28Gb3anGiUCQw/CmEirHDIGJ/jqolkLllVRnbO4
	FhOHuN5bVCFIVt0s0dx12Y9Gb4GujWQmvmplUhaPgB850CbopyYpojhewihd/2vhwwHZxu
	zth0H0pgx2ZF7t+R2qNMQGKw6D1GDFk=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=OYj4Mo2i;
	dkim=fail ("body hash did not verify") header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=GUYMegKr;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf18.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59LEIefH002160;
	Tue, 21 Oct 2025 15:35:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=94Cl0G9Ly1WF+yJrGwzluYPcnRg6CfeOzivHR47JMjI=; b=
	OYj4Mo2iO+bBrrgUNY9VKsvu6VMD935o4g3h0SICjnQpW1yqWGqnojxj6ZzpmfjM
	v25llfshy6ZCmgL8OSe5BiKPlmTqie12eHqLPf0cimauwfGDVlpJXvyb8vZ4pZNn
	jS3BXyrYFSrbwLzlqG64pmtcY5kd3Zp4bOMNQ2+7oPkMYVt5x/QQK1BGCzCX8Ynj
	4Q/ZEAFGSCakopiR6eGAS4MSakUNoqwhjwguNqTkTMrQywSDUBUCZCJFaT2is0K6
	FZaOPCVs8AGiWrATBJmPgI3s8IBPVo9Co6g6iLOrpiB4Hf62JQ3UlP/rrdE6HrY3
	zdnvS+45gAqmg/qyLtL38A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49v31d5q8k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Oct 2025 15:35:25 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59LEU7nB035341;
	Tue, 21 Oct 2025 15:35:24 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010020.outbound.protection.outlook.com [52.101.46.20])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bd1d53-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Oct 2025 15:35:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bLEnVoIk9eOHd5cb7X1oICjVyNdbL7Sho3irlqa9oNjS4cVIPtxTMRe6xVP3XVEuFL/5vFL1dmPNREpu2zvPwANHc8AO7C2QxvYG98GF9kGDQ2TKU3YpB1iHNgR/H2K85XKtk9CA6Z4h5JCm20+ZcPCKYLAdsnkZsAGJYGIDj6at4rAV0RjDk8pALnw+SsYKFwmvaAeTL7rshaF0dFF/gXEZntU8/rIVZ91dZREO1YuW/aytOKZFZ1a8TwFUOuVniWQxsyu2pF+m+qze5TDeV6aETHqp/0imJlDn1g1v6LVmgx2h7acVix+lfcgpkUXAN2DrjLduq5wbp8SJnCUjFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W0Q65jJrYSVu1qHX93d275dZ2O2m8O5ycjODWgcpqnw=;
 b=CrcNE485W+zkMXLTOzcfwhFraLUoJ7FpKMH7XXWPJkZoMCqcnYNtgOUdU3/T8TYScemq6h6EWjbu7u8ajJeI1yZkADNPzMO5L9A+7QNWZvMjaAze95SP/zycIiIbXcZJcVkEh7CF6maj/pZlGGR2zHxSB2Hw5raPUj4II+OwYjSif/albkU7xTuPf2sTWf2HQNtXTCi7Ndr0p2Mh28wd4ibTDVJpPrppV+JxyT9GxoTrfd6uiO7NzdhUn/crr3Jiv6/M5neLAVKZkyanogvKV1WlQvqoChuu+9SZwU8mtqmfwl/Lr4WC1cZHw+LrriGylhnuR1HpLLUHLd9VfYiqkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W0Q65jJrYSVu1qHX93d275dZ2O2m8O5ycjODWgcpqnw=;
 b=GUYMegKrdiHRy7FyMOQZAq6O20tLc4wmDSJhkU9BwXwPI+dkxQX1BEgR+alFXbCkxDnD66PgQAHfz4uQOM2QABpi+e6SVrzLnLCAuOL29nPnmkqN4YLw9MDXu2aIMIvG1C6VQQ3/4Zm2FbHrDssnJTcf68Rhd1Rgi5K8DA8HiTw=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SN4PR10MB5590.namprd10.prod.outlook.com (2603:10b6:806:205::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.17; Tue, 21 Oct
 2025 15:35:21 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9228.016; Tue, 21 Oct 2025
 15:35:21 +0000
Date: Tue, 21 Oct 2025 16:35:19 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
        Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
        Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
        Liam.Howlett@oracle.com, Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: Re: [PATCH v4 4/4] mm: huge_memory: use folio_needs_prot_numa() for
 pmd folio
Message-ID: <667b8d4c-1fc6-497c-b057-12de194e30f6@lucifer.local>
References: <20251020061845.3347258-1-wangkefeng.wang@huawei.com>
 <20251020061845.3347258-5-wangkefeng.wang@huawei.com>
 <4d9b5a05-5e1a-4a99-b8df-bd61b336392f@lucifer.local>
 <a25e1292-1110-4534-b7ee-b3398b955236@redhat.com>
 <2436956a-d5d2-476d-9117-a06fae5d788d@huawei.com>
 <8ffb441a-d9a5-451f-ad39-5689acea13df@huawei.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8ffb441a-d9a5-451f-ad39-5689acea13df@huawei.com>
X-ClientProxiedBy: LNXP265CA0005.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5e::17) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SN4PR10MB5590:EE_
X-MS-Office365-Filtering-Correlation-Id: e4bd82c1-3124-4f9b-d11f-08de10b77218
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?X7X91I/Wowio2lW+nBWwnBR8DQC8+JMmFN2wYdmBiVEkB2B7AGE55upBph?=
 =?iso-8859-1?Q?m8B9K6P4Pm8ZTEXpMHH8iztrIk+kFgJ8cvH0xWnAAwtKE84FS/NBGjdCQ0?=
 =?iso-8859-1?Q?PFz8ePbvEHPjyeUURc6qXv26VaT0xiTw2xf2rJYm5xzwotbbEZ93hmny5O?=
 =?iso-8859-1?Q?nsQW7WdO+hsi2kQpNNEqpUeqmEgoCXmT4izCGmoq+2Cc7/5gdnYN8AKiX8?=
 =?iso-8859-1?Q?euGAPT9wFJWQYh9TdqGKYjQIYjepVg+z5XTb68lWDHOrd5KjV5R6yy1kVK?=
 =?iso-8859-1?Q?6iIyP3fw32bFNfjNoR3jAtSPNEYxRmdU//MjfjMGEoOcM8scj+tQ6Xqab8?=
 =?iso-8859-1?Q?kg9Ozm6xkUE3hswVbCHiH2rNizhSxshI2y12ZACj1wLymgpiSO/PbCPeno?=
 =?iso-8859-1?Q?MKdPA3etI/dLQ08x23vchIciTl5LfECFEHDGqR7bT4o4SsDTTpfYG02dJj?=
 =?iso-8859-1?Q?NuQKmlqKRMAY+Fcz+ms7hTkEZmtys7U85kK5SmscA5xSUW/cmRK/13ibCt?=
 =?iso-8859-1?Q?wkV28Z/aknxNujgjTJ7nYuq79W1+H1Y/ReuooDU5q+Aiqbfy1gH6j+ZfGL?=
 =?iso-8859-1?Q?q0qvYqSUJICoz4/nK1KHlmWT54BkFyi9m1suH8qmNZNaq6W5nf2PjeS2Wd?=
 =?iso-8859-1?Q?NeRycAKc3RzPbQVhreA6pIvAwuG3iY6ItI++uVx9juzl4LxFQ7epJn9SNg?=
 =?iso-8859-1?Q?Qoy0uuuO1hs8he3ZZXBatN1dNLnqr+3u3xoIHx0lj39uL1nVqL+s0vsZdI?=
 =?iso-8859-1?Q?OzimiMXH/uYqmVpctXy1CGDgmrD1LrzDRT3fgb2eyaqEYCPzsqY3ohR0Fq?=
 =?iso-8859-1?Q?qaXpzPnzAkYNIoy9A5PCLmdkJ2dNTmZ9tMxz1rabk2WJC6glJIoGN4iNHq?=
 =?iso-8859-1?Q?QHtjG6W6/2dAG5gwNFxTUn9QNwsBm13L8fQ5+qezHPkXVcUSicn38aOpCH?=
 =?iso-8859-1?Q?C7k2wOw8i1rhkW3KKhIJKEE2gTUo7rlgxClp9pED/P2Kz00F4R9425t3n5?=
 =?iso-8859-1?Q?CJWm2w9Wdm+kTqpjhQkM54WM11YV3rzSK11FeqN6kvLp97A13yTStTAUHB?=
 =?iso-8859-1?Q?xIE1hDXLq0pOJGBw4B2D+BysuajMay+OaB6sK56I22rxxB6A8w+rXgmI0u?=
 =?iso-8859-1?Q?XHIoAJH1iEOEgbXoa8mRPxOeTQOFofsABr/QK1F/sQJy9xlS9YmVitF5J1?=
 =?iso-8859-1?Q?Oe0s5NpJQ5M03NMmujxuKaz65Jik/jhRrN57dmAIA11rPz6LNDAI8CHkXM?=
 =?iso-8859-1?Q?136bhtSyjhvSUCeP8zda/imKIwr8Gi77FrttSRMvPuXEJyC1MHX3od7VLe?=
 =?iso-8859-1?Q?XG5z9dHRRY++tCqJ0Y5W1v2TB/UVRH7ttyb+K/EIBqHTCuXXncmXG+7/ua?=
 =?iso-8859-1?Q?mwQrmGdcKT76b0qDcnIs9jAwjqjW8mLqI64Hejka6ICShVwWhwDjF+A/mH?=
 =?iso-8859-1?Q?78XX/voWp3b/copDL2DSk2SBIfcJfChGMW2AlcUDQBnlLpY0Rxx1IFBNGb?=
 =?iso-8859-1?Q?8Xlhdc/d170xGGzLDARfRA?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?iso-8859-1?Q?XTd7cJtgmVEAH0FISB1dRtHqIwIBJAGt3gZYsZKU2eBGPkP1Ga8pYQRpPW?=
 =?iso-8859-1?Q?8Qmqa40rkFHaO5xrt7tSbtgPVbKX6kUa96RW2YjViZYNhvmgW6b/z+9PV7?=
 =?iso-8859-1?Q?MVxG6/rCB2MPMJ5BfDokofsBRagVVyRCIFN5sa8Wi6DZOn5OT4++Hhsrhr?=
 =?iso-8859-1?Q?8DPYNJZX1Xkaiz2HtAPtgtFCC4Txa3b0ubWKTChYGXgemTzLYKlEM/3Vdc?=
 =?iso-8859-1?Q?ilZgCKFjWktojbaUKo0Ahv2dggBh9Lrj7hnzmxz0szcGXAnwqHiy/rm/VH?=
 =?iso-8859-1?Q?UeBQIZ4vHF4OS8ZBNr89bLsUTlJ7hW3nBxty8agOsOo8JjPW7wrbtb2I+B?=
 =?iso-8859-1?Q?wcWc0xx2H88ko7/sO8GXJpP0p+9aq9+c5gaChmEW39VUnwAHY0kWrPSk/G?=
 =?iso-8859-1?Q?+GuJ2D6uXjp+rBcnx8ZiL/ArV9CDJdcPAzVdiRHWiNxSMpRke0vnZX+sfG?=
 =?iso-8859-1?Q?BRNarV0OJEXLi+cR+aZN87lJ+mAx4x+co/Y+72QiCMdz4Ce2WLyebYqWHC?=
 =?iso-8859-1?Q?aduJeS+ZP/m5vGhedD9cW/BCDRLTjBvcC8MGvvnbQpwEIkGhn8e0/yRZk7?=
 =?iso-8859-1?Q?b+4oys7n5mGZ7rVnD1OYBTz3RGSMKwejYaxOwAQ/lgV6P57X8/RWijTJFT?=
 =?iso-8859-1?Q?8NLDIoV1e0FT5BBVNVlB1SXP96pn3L9WkJr54O4a5op66g9jgYg6B9lCcB?=
 =?iso-8859-1?Q?TPs9WADZzxJcIb9dPqwvUIMu7vWoCH9BRBc+uPulaolliUhH4b/Jl4wM33?=
 =?iso-8859-1?Q?kdHDfmyA5ZMuXw95EHHYzAomK+HDVCLuPYNEfECmq9ZUOA/3Iut1GYz0GU?=
 =?iso-8859-1?Q?tPakSERLe+ZV1YmoEVY9xBglGDTFwe5nAWjFs5n4pFWi7OVPddTgAlWpDj?=
 =?iso-8859-1?Q?EJYEkkxODiD01fvTp+ssZPtoJR8uig9QE7IKbjV3gIlFbdWz/5rVwHnNJl?=
 =?iso-8859-1?Q?5007EMFsvqY9+/8H8JPifKmepUBug7U2SqoJKnTUUFKpmQgE6eYJd8ZB+9?=
 =?iso-8859-1?Q?FOjdTFG0AgyfM8ybIxbLnqkIfDuQE7wG4p3AkP1xh5sXm/oPO+5CM7EUwk?=
 =?iso-8859-1?Q?+01NfueqSE3oefDL1/MbU/N+EHCrazoSLR1l+oTRmRMKb8aBIy3aEbFJIe?=
 =?iso-8859-1?Q?mQtQbKkbAMHoOgVCfU/4JflGkge5HUj5FZy/lcpfwUxArAl3zH1rzr76BZ?=
 =?iso-8859-1?Q?hy5LjoZZYY1oTA+KKo1rSvgc3aG03ra+D2wVuVz1HnnFNiX46HhN7lkUTG?=
 =?iso-8859-1?Q?wd79BT8n11GjBVldsPleRm680j+KuJu0SuE1qpdpIJ8bzP45cGkP/G0zwI?=
 =?iso-8859-1?Q?NlJVN2WCoz4n88Xe3dn/Mf3ZDPf0CU15Rm2E0Bf1Tg2tDwOS5ETgDVTkn1?=
 =?iso-8859-1?Q?sm1uzxTzyWOO7r2ddtI4bIB9bVGvksqCoT4EoJk9bxnJAZMC2luzQ1cL38?=
 =?iso-8859-1?Q?mu+z4FPHzjRkYSYjgr9/0oft7b8oAWPcrBCz1bvrWQPtMKhQAByM03Azf/?=
 =?iso-8859-1?Q?0ceDtHTXeNUb8QHppN8pK1VKEc3GCnol1VqMne/1Ygw7rs9kTPc9ljRNLq?=
 =?iso-8859-1?Q?TlcO5urznI4ZqnPE6gksOLpxIhSa5pZTQUBzticDYZvfRNjJ0yQgmK4isa?=
 =?iso-8859-1?Q?JPsKNX1WYudli9fbw5JOVBhtWv043ZQ+ti8WSQFVzx7nVjWZR/N3L2Eg?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Bom8wKwcJEr8/QSD8XwtPJCJN4IyAXX+I3ppKMGt1/SkVXAvIzGPpBA/0ZiUv2hBNikwzcD7Lm96PkW6R+4YrbqIrImBxZaduVzaTtSnV96OyTd+a9mbqDBUIMnV47uHozzmpS/KTtZyA+rgZS+hvU51bsvNgEvLJ+Tb7QFJBIEnEPsRKho4A8t0qLnDnjfyFG+G4miY56981Yb0nBLRli4ly1ThAUjB1h2tjUK2yo0fc+KpjookFQZWPHm5CSF44b6njn+fJRYlUMdPnLblgeZh5CjQL35Wf/lcVOd7GtB48wLVRu4wCHp7vIa90yam7fxHScxeGOZ+POy5CxWcnKNohzMAPBB3JRAOEC3d92ZXznv12TY47Jskl1I3vlDv7idWRL83ZAW1iQ/OfUGkqoLaMS1nvMYSSoAwydqAoTSYpMpz1gT4uskf/BJU16EtKBxER3YYOL6FfB1s9Qdcyn6sZoeL7zXSvG9uRPmzz0yx+TVAfymEQyjz5EwxINg0D2eAGFF678cm/58AnK/tJYfwhaYSDDrwfaL9FUNDvkAHkxnsetSaWrunXKMLGl+zh07eygN12PAKbBB4qsV430OzGKUQE18lOh/PgJqLsxM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4bd82c1-3124-4f9b-d11f-08de10b77218
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2025 15:35:21.3111
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eIE5E0EIz6D4jU7FgeCoKq+G6wvQu/7e9URiRIBPRbaN9YbGPT9+DCOX+gaKvO5g+Lvn7NgyHZMc3dMtJEehWWIngmO+1HzLUlwgNyv2jjs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5590
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-21_02,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 adultscore=0 bulkscore=0 spamscore=0 suspectscore=0 mlxscore=0
 mlxlogscore=598 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510210122
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMyBTYWx0ZWRfXyY5JAg+OzPQa
 /k5pel+AgvpVkW6TxJM+JBLtYjIdss6XGE2uO9KItDp49q9pRGT98AmLWAdVQo+GARYsfUoNu+p
 NgQWtRbFEE4WZCK+IHjne4AEg3tE+Ml2X0o3suKL+kjwsx08N6Hp9ENbSRRMH0PSKsxzLW6ZbPP
 jEma66NYMdHiLOU0Dzu7Tk7TsNJt3kQYX+hUT7I6d0UXNgFSvHoil/zrElQh/ME0MLvQm6W6MFE
 jYxMXXxxg9db3inr0Gl7z+jeqGoEIRPxfnwEDpgURPS8czPlZ//rGCFZJVkv1pGBhPpS2e0TZR4
 j3P9JI0p/7D22zurLylT+pT8m7/xN1/5zmmHBJtnvFzjlb+CLs2fIKLm9n2HzANI8lypI4UXPMK
 W+QXAaQu4qa21GGhJUIa2x0rO8v0qzIcOWAlw0jzhB4y0Qx5nCc=
X-Proofpoint-GUID: TNgeb-PDUvo54umjBHcwghb79G9_OOu6
X-Authority-Analysis: v=2.4 cv=KoZAGGWN c=1 sm=1 tr=0 ts=68f7a83e b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=8nJEP1OIZ-IA:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=07ucKUJiRKvUAKk56XkA:9 a=3ZKOabzyN94A:10 a=wPNLvfGTeEIA:10 cc=ntf
 awl=host:12091
X-Proofpoint-ORIG-GUID: TNgeb-PDUvo54umjBHcwghb79G9_OOu6
X-Rspam-User: 
X-Rspamd-Queue-Id: 7EFED1C000F
X-Rspamd-Server: rspam02
X-Stat-Signature: qzggj3hd6fn85hze8i67igiem369ahmf
X-HE-Tag: 1761060936-97573
X-HE-Meta: U2FsdGVkX1/SBNwHYEGkL0hWFrV2fWkEsCH4PAw5+iZu7y1NALzPqNVUP0NeII9FonoUkmRKjCz3k8ttzkWg+Xmg5HvnpD2bM2q+MY+GF0spmxziNkguUmi76MG+IPGfrfWpwFWKiMn6eLq+TvQ11ThiRos9REY82KkXqkjdLgVTS1BTUezvYobONk3HurXuR5oUIw3HII69Shs4Ed7LdQsEqC61aNppffZS5GowyprCGUy+/qMbHwlG2H2MftwtB5yksfdH6+HMPt/2OyLh4PbT3V0i36qVA6YJFG46BR/e/TJBruQY7hPBVsa89YCAtea5eyFD5087au/0LHw77tki6Im0Q1foTAVMmpu40djSc5BV60yUiDDSB5//aawOFjnNWZ6rmPkKxFjMWKP2ncDxZ9N6PUGx3pdAq9gLbVnWhfHSnXWIsU0rpZ0InbJWZcLZEoNzszlLrQmL9dg61S34Belw/n93ayt40GgugwXKxGqnaDpLOmSRjE1yumyDRg46LoaNetp4pf/8wsYilVN3reVQArqtNwadIGKUJ7x3Sez6t8NxczDAtHToVEfGWuG4bkCjMomyq5cyeL8TmQNUiwsHzgTyXfLRE/i7POQ/zMPhgAr2S7QCn5TcSPtn0NeliOvawVK/NYsD1ljzo5gFHucpC+ZWU9MZBrcEwd1+Sw91pHvuTZxS6hptDXcMOdlym9vzp4ZagLmr11DHXjAXHrMxDFNtX9iBp9+0X1C6PfBVp0Ng24OjX9i4k27DV9Tyq9B3jvhKjRMCxrdldq0vn0QELiS63YufZiMz+8Uq5/ztymeOA2JHgM+drQidgmuBkvWF24BP7lWcJe3XbRMQg83/mvsJvvGfit3Su4ojEH2ax0+0DxAxEQQBMzcNp8crzFdXa/TjGKD4eu+qctwq4xPHVvPjFzzI5l/K7VU1vVyuLCGPUo67WLI3Dwr65J1eRukxKfaIAw6yTTF
 dCnvrCcn
 kpbAgiwMY2tOyPTsZsx4+jgm5xd5RKdgHhzLtfnXc2tKB4cvn0iqTae08nu+qjNqdNNdG2IYjlP/PgFf4NBZ71dez6QkMtngPX6vVUxe3PArSHsAW4pNjDesLD+nX/qedzGSl7g3M4/YDjLEvxtAY8tuow0znorUytNPLda02ipFHWzFTTTfFrGhrZ6BfUX7NPP/dwwc9M2pTaA3qGLUO769S+hh1jSXi63OZ5ZMom9z3MdHHHW8rQxoMlaiz4LGZyBJA2KM+x6ptNWhUX9ahluWerPT1ORg7Ga4+11HlOxQN9/OYAgZtr6IjIKn0oyrU/jv3fb4DN73keSmYc6390oYWTCFfAKVjn73TtkEMJZAIfwbFrhaIYNfZq3lg6GWBp+Zh6mjv2lUuDo7qnoUJJHkZjAnGF2ArzCd8R6/i3qThnekLR1Ctep5GuzHYIf/od0gGSYkLOAdFfhKLUWTUSP8lKsb5aPzoWWWT6N6AEs6JfuAqfazQFi41ODcjsr6hRKwXIpD+xHhC5Ps+PFOqhJIAI3/icaiRsslg7lpbjBiFAtvN16rMgsOoBaHdd+vdP90V/MC+3m1ISJSd7+R0fugxtt+JApcCBUV5JJpJzgbGUHwpfV8DaeuIMtGiXTZ0v7ERcYCmZUi5KHuTMXBir/t8uLL723K3hdkDcAOg0+wcdSnvYcV1K7eac1GOlVOSN2JD80SWCy0O8LfCgKIQd6SqiZHnarPLmOC3CgExg/5ucDc14sX90rFrjdjkYOtEU3ZVf/vD0H5d36H8WsMzwbhSYJP9lIaO+H3Q/3ZDHlaKA8yL6eoqnXS/dYJ8VZ8UHwPp9AVNqWlMYhEb/tWTONGUwl9djBh3tDPA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 21, 2025 at 09:37:02PM +0800, Kefeng Wang wrote:
>
>
> On 2025/10/20 23:18, Kefeng Wang wrote:
> >
> >
> > On 2025/10/20 21:23, David Hildenbrand wrote:
> > >
> > > > >           /*
> > > > >            * Avoid trapping faults against the zero page. The read-only
> > > > >            * data is likely to be read-cached on the local CPU and
> > > > > @@ -2490,19 +2490,13 @@ int change_huge_pmd(struct
> > > > > mmu_gather *tlb, struct vm_area_struct *vma,
> > > > >           if (pmd_protnone(*pmd))
> > > > >               goto unlock;
> > > > >
> > > > > -        folio = pmd_folio(*pmd);
> > > > > -        toptier = node_is_toptier(folio_nid(folio));
> > > > > -        /*
> > > > > -         * Skip scanning top tier node if normal numa
> > > > > -         * balancing is disabled
> > > > > -         */
> > > > > -        if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_NORMAL) &&
> > > > > -            toptier)
> > > > > -            goto unlock;
> > > > > +        /* Get target node for single threaded private VMAs */
> > > > > +        if (!(vma->vm_flags & VM_SHARED) &&
> > > > > +            atomic_read(&vma->vm_mm->mm_users) == 1)
> > > > > +            target_node = numa_node_id();
> > > >
> > > > This is duplicated in both callers, and only used by
> > > > folio_needs_prot_numa(),
> > > > why not abstract this to the function also?
> > >
> > > There was a discussion on that in v3 I think where I asked the same
> > > question.
> > >
> >
> > Yes, it is in v1, for pte, we could avoid 512 times check and the
> > numa_node_id(), so we leave it as is.
> >
>
> If no objection, I won't change this and will send a new version with

See feedback to your response.

In general - please do leave time for reviewers to get back to you, the
review load in THP is very high and we can't always respond right away.

>
> 1) kerneldoc refresh for folio_need_prot_numa, per Lorenzo

OK you said in the other thread you weren't going to do anything, I guess a
miscommunication as you are saying here that you _are_ going to address at
least this part of my feedback.

We're going to need a long and clear kerneldoc there to clarify things.

> 2) update the changelog of this one, per David

See also my feedback here.

>
> Thanks
>

