Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46B62C8303F
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 12:05:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 782C38E0006; Thu, 28 Aug 2025 08:05:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75ABF8E0001; Thu, 28 Aug 2025 08:05:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6223B8E0006; Thu, 28 Aug 2025 08:05:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4B4088E0001
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 08:05:00 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 03C7081D70
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 12:04:59 +0000 (UTC)
X-FDA: 83826035160.26.45FF2D4
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf09.hostedemail.com (Postfix) with ESMTP id 52F46140010
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 12:04:56 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=PlGJWxQT;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=lRS4+ulU;
	spf=pass (imf09.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756382696;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=coNWY6ibyhNB3Fq+q+gt/RcYSIDX0R8rxbyizCtGSR8=;
	b=W4vnrDnj4+DCiJ0ko7NE9g9wZyfqBIUQ3TIpb7lnnGULHex3Tknv/2v4heyn6RNjadQtiJ
	ytGjE9scqSVQxQGhJF5V0nTzNh0C9fI1FYkY8v0Zs6hbzCcUSYXSUn8k9vsoWaJkpHUvkK
	vGmVbWzPMeCskDi26qusGxwSi+1m7Xo=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=PlGJWxQT;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=lRS4+ulU;
	spf=pass (imf09.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756382696; a=rsa-sha256;
	cv=pass;
	b=lHdxZ0RKAQoH684ztUmEG1U+5UB4sLOG+vFVO3oWnuIux1szHP6P6kJ9M6lDvR+933Tkh+
	bz9bb2xpuD2TBA61Xkyyi/IJ4f3w9tlkbElZW1wcTYrht2pMbb9S2UTzanJh/QMkghG97R
	moN061uyb2OAQSSlpzs3j2tm5SI0nPQ=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57S8tnVu007151;
	Thu, 28 Aug 2025 12:04:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=coNWY6ibyhNB3Fq+q+gt/RcYSIDX0R8rxbyizCtGSR8=; b=
	PlGJWxQTxzruevzHlzOWeBi5wpXMR7u/03lZ3pzgdQiENMUupPZQ1l3AgZlNubKL
	XmhyH3aHPiY6D8NmLAZF7dYSQS76ouI8iPFU9ev3yYspErcLDmGOi/wDBJUiAkJW
	M0aB3H88wDNlsigNeAdNDZIeUjojp+6RmptWny3wWyBD/icx5d/Y8DNlxC6v6YCU
	chWE/J36iXM07sEECRrFNz6KmRNbukQWKDWI/2EMWQi8D9kre9Sb5pzqycxNyFq0
	QLCRm2+ngpv7FveM+cimS7D3sJhhl/eDcAhIEVHUr6XVQhhVBd4Tm+2DUL7+Ju9v
	xDkkWRnCszspLNO+Vt2XxA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q6790c51-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 12:04:51 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57SAVA2x012229;
	Thu, 28 Aug 2025 12:04:50 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04on2070.outbound.protection.outlook.com [40.107.101.70])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48q43bsafc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 12:04:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fu2dIfZfybe1BDiKmYnFHGMe5kWKaseRprjy8w0tKUE2ksIV/A3WdcQh2mrkM9rqrEPVked0ZSSOfMjPEVEvlWXnB6oJ66dKDtH6+Eh0cV3pzkPCo+58T1tugWxEu+Q+C1VpQOqdO/h34J+29MSF5c9zuUtcwkph/LbYmmiKaacq7h+ha86cAQ4LQ4kAYDu/ByiEoLBNjqiwXtQ5dDSZrqs5qekRUCxMvA3AX8E1gJbDwW2uz1B5CRhqTF6NoeFL+EgAlZKwuBP8FXx9ITFFyC0RlfiYdLBKEVejnlOtrfMaHAyWReBotCPprdmEPXfW2N1mb3M6zWMPRAos9L14JA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=coNWY6ibyhNB3Fq+q+gt/RcYSIDX0R8rxbyizCtGSR8=;
 b=cnddhN614CZ1IgTRfPsbO/p+Vr8sRIu2yc/AP2jheS1cperbLHR1ZQuMzdjA/ZzCyYdpQ5j+Yqb/5Mqx5Sw9ScAsXKrcSd25wYqG20pfGoDhu9YA/pU+jAaoK0lSpHqDBnAFRveXv9LSEF2YQotMVXcnfIe1HB33a22Koc7UVKhmwH0OH4gHi9BmuinwMLJ62gKTqCirBW7ZvLJEsM/kp/yuOy4RoUl+Lzk2b9aIxlV4QMI1NJOltavE1BV7+n8sMZHsSr4zffVs6AFfjgVlT2i7Pp1mIibqkG05EUHzPZiyGL4fYe8tCDauZYwktAPgjoMQPXgFTGpLI7f9PDfJ9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=coNWY6ibyhNB3Fq+q+gt/RcYSIDX0R8rxbyizCtGSR8=;
 b=lRS4+ulUV4MwGFSv3m8zwpvXyfcuXsqVGtYAyORU1Fldw5xoI8iX5QsOi5RPlETjCnBJltnfqDPs0y36mMinePv+w0tT84OWxvy9IDf5EJRfwLe2q8ccN8News5FHfLQKv5OSKpu7Eq2DztixU7C3HEm0Wx5ElK3rCr8eN/R1FA=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by IA1PR10MB6217.namprd10.prod.outlook.com (2603:10b6:208:3a6::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.17; Thu, 28 Aug
 2025 12:04:41 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9052.019; Thu, 28 Aug 2025
 12:04:39 +0000
Date: Thu, 28 Aug 2025 13:04:36 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Harry Yoo <harry.yoo@oracle.com>, Zi Yan <ziy@nvidia.com>,
        Barry Song <21cnbao@gmail.com>,
        "open list:MEMORY MANAGEMENT" <linux-mm@kvack.org>,
        Peter Xu <peterx@redhat.com>, Suren Baghdasaryan <surenb@google.com>,
        Kalesh Singh <kaleshsingh@google.com>,
        android-mm <android-mm@google.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Jann Horn <jannh@google.com>, Rik van Riel <riel@surriel.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: Re: [DISCUSSION] Unconditionally lock folios when calling rmap_walk()
Message-ID: <a0350dd8-748b-41d5-899e-1505bd2b2e80@lucifer.local>
References: <CA+EESO4Z6wtX7ZMdDHQRe5jAAS_bQ-POq5+4aDx5jh2DvY6UHg@mail.gmail.com>
 <dc92aef8-757f-4432-923e-70d92d13fb37@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <dc92aef8-757f-4432-923e-70d92d13fb37@redhat.com>
X-ClientProxiedBy: GV2PEPF0000383A.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:144:1:0:5:0:a) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|IA1PR10MB6217:EE_
X-MS-Office365-Filtering-Correlation-Id: 8aea8be7-73ad-4f89-479f-08dde62b10cb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cDBnV0E5blJoWFd6Rk9ZOHRIcXFQbGNiZkh6S2xmVTI4SWoyeUlNYWZSODlx?=
 =?utf-8?B?MzBjRTZhLzFNdlU4VXNDY1F5S0NMeXVmb2psYmkxSVhhODZyNXRPNk4rTEla?=
 =?utf-8?B?UEM2ODNEcFZ4eHl3SklDeDNZNGRxazlWQ0tCb040aG91L081eTY1STUzbU4y?=
 =?utf-8?B?QUsyTnM3RkNtYU1pVVBaMTR0NVlsVWFRUTFZRFpTdEtBY2tkRFR5RW1TOTFF?=
 =?utf-8?B?cW1lNVNvWFFHblp3bldER3hLeE5IZ2Y1ODdYSFp1TzB3aUQrRU5aajV4SDNs?=
 =?utf-8?B?NnQwRkVJSk5uUmUvZzJRdVBQaVVFQ2hCNzFnTDk0VXhZTk1raU5kNGV0aE85?=
 =?utf-8?B?b3ZhTEM3Y0VQZ2tieXNIOVRlNXUvRHdMSDhvZWZzcmtEYy9yVWVvOUVXL2ht?=
 =?utf-8?B?M09Idlg4bjZoOFJlOGJhS3NVWG1kM2ljN3lCaVJjY2VEMEIrLzlsNmRoWERv?=
 =?utf-8?B?VGROTFlIOTFDdXpTLzVONmlYdW5jbWtPcVhnK0syS2VyaDEwa3VodzQvRkRk?=
 =?utf-8?B?OWhoMlpLM1krNkhHc3k2cjVnWE95K3FlcVBlN0xXV2JCK0NjZzlrbFczT1dr?=
 =?utf-8?B?TDNMM213Ymtia0FYVmlKZU85dStOSGZhSE01SFhTK09RSUlOakwzbE84NFRQ?=
 =?utf-8?B?SDZqeWMvWXNubldCVXBWZytzVUVKa05JUEQ0R0NLTkUva1YzNndwK0dHeWRl?=
 =?utf-8?B?QTNOcy85QVh2cVRscEsyMFdXN1lDQTdtZjJETmsyNFkvbC9UMGlMTTFMZ3JL?=
 =?utf-8?B?dFAxS0p6cHRpMklWeHVhNHN2OEczTjFkTHhITXU1ckI0YllqY0N1c2ZkQlFS?=
 =?utf-8?B?RWFQYUszNDc4VlI4bEJoQy9xcmpEU1oxd3hMbWJmQjBzb2lMYVl0L05aM095?=
 =?utf-8?B?NiswZTd6YjdwMVlSQjAwSzdDMWY4QU9vdkJsS1V4cXQ0UW5RL1U0YUtHbTk5?=
 =?utf-8?B?N25tSzRZYTlmRWRkMkZkSjdlemduUnlRTHBlazUwZE9zZFB5QmFqbTNIbmV6?=
 =?utf-8?B?ME9hR0l6eUFiZDNYQnpHTmJjTXlxZWpFQnVna0hja1lwRjYrY3N1T0ZTc0Q3?=
 =?utf-8?B?YUJjbTdGNmxnaTJNUGVTMFlxbno1MmpFL0twOFp3dFBzbFhjM2JYU0JEQmFW?=
 =?utf-8?B?TGl2alo3d3JST3IxVjRPbFE1MkJNdHJpWnJTVkZlVWdPTTVnWXc3dGRNaGVw?=
 =?utf-8?B?VkRyQXdBTWhVejNYNEdjR0NkRUlRelQzMnNKUmdVb3hyWHprcTBqL1AyV21W?=
 =?utf-8?B?ZTcwWUlKTHN6eGNSbmZjODdQazc3eHdTN1l1NHhqN3FpL25raG1jZlg0RlVt?=
 =?utf-8?B?WHhQSU1HYnFDdHV3ODNLWi9ZM2tpQXYvZW9BQ2NkRGVoOEt5bmtTVmJsZW1v?=
 =?utf-8?B?a1FuMGVGb0VjTk1kcUVCYzFUOWx2UVlKMGNMYVZLSmI1aVU0dHVzd0MyRUc2?=
 =?utf-8?B?cXg2N3hrQ2J4WitDMVVHV2dhMDFTb1lUeElEQ3NNa0hhQUwwM29hVXdCRmM5?=
 =?utf-8?B?RUxOUmRLTFBjU1dKN2NjWGN2VEswQkZQaU5USkZHMHk3L3RLMHd5ZFFjdzg3?=
 =?utf-8?B?Lzd0bzN0RnYwRStaU0pEQ0x1aHJvTzhPM2pSZThyUTk1elVBMGFWaDdHYU9P?=
 =?utf-8?B?RlU0czF5YVJIMjhvUVZ0UThSVHl6K2dHeUVBQjJ3SlJZRnZQR2F1REdLQnFF?=
 =?utf-8?B?Um5IZGd1RWs4NWRXVVhRb0hSSTdKQUNkaFpmU0tWMGNBMHRkZEU1SFRZRFJS?=
 =?utf-8?B?NDl1Q1Ixc0g3SGl5RjNOQys0ZnpBTGhkZFNFR05xaGowd2E4Q2FEQ3h1V09U?=
 =?utf-8?B?a2M0QTUwTzlCdVN2UmVIbjZhdGZXK1ZEOUpsRGRLdmorWFdRK0Y5NmRvdW9m?=
 =?utf-8?B?NGNZL0NKQXkzdkRNM2RJa1JGTWl1YUx4Q0dCNXZzMS9iclFzaXAxbnY1czZ5?=
 =?utf-8?Q?nvSXpyU7xPQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dTNESm1SVlU4WWkyd25yQ1BIbWlxM2twTU5wNGJPU3JjR2wvTWNwb0hEZEg3?=
 =?utf-8?B?SHlDUER1WDcxMTFHVUxsQ0FzcEs5TlYrZCtsVGVwT2lwb20xaTlYb1g0NXE1?=
 =?utf-8?B?Q1YwSUptenM1Sm5XZW9PMXpzT29IbWl5dFAvTERkTFl1V2NWeDVOVHhrOGRw?=
 =?utf-8?B?QmFCTXlxYW5qS3VtNExsYWIrTkNzbWF3TDcvQ0orM0MveWlkS21XdTJ1TkdR?=
 =?utf-8?B?STVKRHhDL296bU1IVmJQZExQaXc4U1RFTmRIeHMvd1dZRFNKTHdoSmFxaTR2?=
 =?utf-8?B?ek5BNDNzR09qV2UwOE9aL0RKNTM3MndTbU1HVnZlNmgycnZMU0UzRVJiSkZZ?=
 =?utf-8?B?WGZzREFDOXk5OFJqVjhJUlNUR3NoMHFjRlBPYjEvRTh0UzNXMDMwcW9GbW0x?=
 =?utf-8?B?aDhScVRPNE1UV1VGWHhTdThFOEZMcTR5NG5uM0xyakpoMjhzN0tZeDMwY1pq?=
 =?utf-8?B?SDF0YVB2OFlzRFlGZTI5WERPRThJODhWN1kzZWVNNEFLNUpKb3htOEhTVStJ?=
 =?utf-8?B?WWRPZHVJY1padFlGZEx5WFYrZ0pjWmNld2d3RDRycGtMakV1cHl3dENWVldN?=
 =?utf-8?B?U3RyR2RkVEZoQzI1cEFYWjZoRGF2TFdUcTJBMWJPREZ0QmZPV1NYejNzbSsv?=
 =?utf-8?B?YVF2Z3A4M01HdHFDNHJJQjI5N25QbndkT2JpRG01YTFtL3E3UDBDU2VlUC9i?=
 =?utf-8?B?cXVOMW1oeG9zVDR0MHM3b0h6SVN2TVVRZGVqOG5zb2JzRHNXTXFtOVlmVWxm?=
 =?utf-8?B?OTJwMDZuMWNDWUpDai9OQWQ0UE4rMnBXZzN1UnJKeDNUNXh4dVRPc1ROQzZ1?=
 =?utf-8?B?dldobDRlMW5YQUtwZFFyaytkN25iT2VzWDNoS2VKRkRJZ3NEU2x6bUJVSS9o?=
 =?utf-8?B?NDArUE11djEvUnJySlRQa3c3a1puKzhhZzFrb3BmWkQzZXQ2QlM4SkIxeEdz?=
 =?utf-8?B?NUNza0hwalZ6UnJML00rNkZyTlF5MlpYVCtIM204LzdSMnB0bTBmQzl6RHZI?=
 =?utf-8?B?VW43bGdjNnRtMkd5SUw0U1U1NVh4ZHVHSTlvaUYwbXZONTcvS0lQUjgzbE9Y?=
 =?utf-8?B?eHo3RkhhTUNlcFl0YjluSFJRWUxQNVVRRVB4U0hiMTFhQVJObUxCTVZzR0JE?=
 =?utf-8?B?Yy9ndGJiMm9MSGNDWi9UMHI3RVBwWnlLaFF5OFpmbytsZGtPeWhyQTdyc3po?=
 =?utf-8?B?L2hGWGhQZXNHNThxRHI2SklDSFBIZkxpYTZwemFDV2hDSjhOTVJqa05CMTJM?=
 =?utf-8?B?YTg1QjdvSTVMdFBtUktsaklzVzBKc1N0MEpKY3d1ZFpyZ0l5aXJ3KzFaT1JQ?=
 =?utf-8?B?WEhnSGVESFMxdlpBUnZya0hFcXlLMmRDRTlSZlkyVDJTWFdERmVveHREaWlr?=
 =?utf-8?B?YVBLVVAzSVdRTlNkQk4rRGxvOURKczV4eUNENWxWeFVoalgvd2hRQ2ZNSWU3?=
 =?utf-8?B?U1FzRmp4VXJmcHJFVVpnQ2lNeURLZXBOYzBzdjROME1HbkRqYWtpSERKN0Zn?=
 =?utf-8?B?UFZSYi9SWGpkVEJaTFExM0xSV3pqRStXeFpnTUMwTDN4RVJucmY5VzFrdTdu?=
 =?utf-8?B?MlZmdUZ6OU9PWExmc0RUdzB3dUlRTGFJUGhLR0I0Z2NINDFCcVZQZEZvcW00?=
 =?utf-8?B?S3lLV3JoZTFDeHJMckMrNTRPZHdBUjZOTEgyZFVLWVpqZFcwbVpRUnRsUUdV?=
 =?utf-8?B?aW5Bd29LVkhBTWs5RTJZci9vYWNncGs0aDQvOHVLSEt4ZVhIODJwM2VnNDdF?=
 =?utf-8?B?Z0lXNVR5d2xoUjVaYmk3ZXJwVjQrRUJURmZnZGRzZVhMTE54M2E0ME9nWURF?=
 =?utf-8?B?NlhxUk1mTkVNZkhsa0FlYmc4TEFDVWdzZVNHV3NMMDdBSEovSFl6azlRMkxL?=
 =?utf-8?B?c0ttOVViWUUzWjdKdlZIZGhOOU8wUnhxUzk5RkloRS85TlNKMGFNdnZ5NGZO?=
 =?utf-8?B?TStKTFk0MUZraEIyaWE2NWFKS0o0R0tRZS9JdXZvaWxPRjFBVFlkeEdnSi9V?=
 =?utf-8?B?bjRuRVgvU2wzc0x5VVZ3V3BPdWd0VUFEWG9BUWdyekNLMnh3dGdVUXg3T0Fq?=
 =?utf-8?B?b3hqZktiMGdxbWlsdERtNWlqbmRSOUxXOVh3TWRhUzd6ZGJwenZSc1F5QzVx?=
 =?utf-8?B?OHQxNDMzNnVMRnNrMG54TmNEOUFWYzdMQ3VrYUo5L0JMRUtYN0hmb3duYkVS?=
 =?utf-8?B?alE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	zLHMItHQqYUlV9QX/L7bztxZh8by/E37jrBoDWaqtKid8DPlARkF2W0864caaFalOkNE8f5VPDkKT4v1nlkfj8fw0X+nfaM7IOW+HnL2nwj2YOK0wczUk83IhTMMckCB318RMiqX+C6erLkijdzvCmGpwCs1s1KzkeBUPoUaNN//mzHDh3bCyUIKjUPrwJ6sEjBIRADUQ+0unDznRYKohP1wbV5IbYloyx7MIFH64lCdR4j827snllS/fYg0jO7llUxCEIKwWrVosrnWwfbM7sHzKAEskL36j9V9OGfVJFC4GolC6+EXJ6P4k5OwPpK8USmJsNTsrSqHd7eU9t0sSCmXJgHs1PcDNIhtGkXMWOa0PyaxPbdKUb7YiByn0OCxEqYtBRM7iWGMkc8APfX4sf89PG9ZWqSoAH1OzIwbbTl5hoN86yTonueHieRjr6SW2URGlr6arw6P4mbzqzkpMEVVJtWBikgu90UpY9KFnsHWPuLq4umONUDAJlaBDKffuIxVr2R3U6944732ZRCk/EpOQSh/RLISxBd1GSMX05VLoVxUYHrsLxXVySrkMz2oho3AaW4JE4lNaYfoGbsQrMGFcVomE5NlgUYLUczKSy4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8aea8be7-73ad-4f89-479f-08dde62b10cb
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 12:04:39.8019
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D5+IXPVq1blGLYYQUdnD60rusFlkUR0IgHfDH6Fzbo4XgaHbrip6YnAsyPpFCvmdLSjQ6cCkBN46RUP/kisarx7gOzdwUaX4YbF/ttQlJ+U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6217
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-28_03,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 spamscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508280101
X-Proofpoint-GUID: gMCAg35lKNjOESre4HteQ__xJWFNQSjj
X-Proofpoint-ORIG-GUID: gMCAg35lKNjOESre4HteQ__xJWFNQSjj
X-Authority-Analysis: v=2.4 cv=NrLRc9dJ c=1 sm=1 tr=0 ts=68b045e3 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=XIiHZLNihtKFslvas5kA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12069
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAzNSBTYWx0ZWRfXwzZlGv4Wrv6A
 FZUUeBfe9FUXI8UGRskiY9r8nq3E2jHDA3waZHIL+FB+1UZpNZAq/BJsd1X+xG/ckExm/+JVGof
 vieIfbyL36Q/MvwIfW5r2OgihyazVbis7we3DDSBxwFL3pWvAstRPOKsOXZuRu89t5Nc/4Eh2y9
 yC/e7DsNbo7zJHpAf1CpRdK8z0pKxKazE439Bk2qFVx5TEjQWNL8Wm99jCLVP2YFrZ4WTW2Z5Rm
 Euf+5k5haHc027CmifJagVwTrzT8Vhf3gfJFFM8H/GJlCHHW2JVj6PnwOZdBfaO2u5WkvQisogj
 m4XinZtHAAkzIiZ6MYonPXXXPQnrlPl8w9grvRJEdqAI1fyEjXQA8/rECOrjYRaLG/Gibg9REye
 wJ635pQrYtjg5LSSsMTEIZMPsYw8Nw==
X-Stat-Signature: z5ian9n9fsmucoqxgp8u4syo98a9r7bw
X-Rspam-User: 
X-Rspamd-Queue-Id: 52F46140010
X-Rspamd-Server: rspam01
X-HE-Tag: 1756382696-724022
X-HE-Meta: U2FsdGVkX1//5o6Lo5ZN/LepfGiFzDmXX5uWNb5TZPpy4O6DVCojR/KBAYHVgYTJqF2eRy0CuFrGFyNYO77ruFIsNQSOZjHefCCXcWyK3R7WtadNNsYuP58wyyFQm/LS1s1adiU/SPo3QndmPCwrOwpPNC2RSJ2Wrgl8+TvHJL31tU14A7CWS4xuiRrBqlR8bER1P4cwopL/BfsxX7MV5oWp3p81wHnEfmfIzXKK+vYp2XSdzn5ZoBAn9jGBYeVZtkzSRPXUx2efWop712+L1+SIq8g6gaLvOjRMq5a4xzdXz3hHKOws7RQ8Ra2y/F4d2tixqE++hFqh99mhxHhUpPNvFg6B2rWXZfdSoSH2EHE+hQjncXebG5a8n/HxKvGan2Jui7nn1FhXndovEDv5aujStCOLa6NPlKoiz6Cq1dBn4NuA3rp3AHwuXYomTKpso5tYQ3xtGBA/aCRapbrvoHRFao1fmyVKtDlVTijtyJVSNfW5+36YSTjQ9MSxNazuT6IvPdKzFbVtIkQOc5XBv1dFxEG8Dmyr4RyExsw2Q/coG8tOSDej5NwwPk970wWfysRu4C79LJVt9+aqn1x6S5MN5LHYnSSbhks2jlPV8Nr4FXG8UNJfTWSq2m4qC2zQ/Pn7ehMcPxCejIqxtFGIme7vUKo/WR3YJgUeQVyrBl+GVWK7TbkePzXTUuNqmYL5reX/eLVpCd0qjK6DpQHdKjQOC9J04R4pNniMF0EcNl2dJN0Jz9ozUVBWvN9ys1tPkVLq2QjVjzCJtLUa/M6IHtVwpfokNr9ck+a9BotCMhZ06KnMs+RK2FtBZaWsiQHQk+fF7nHcIhYN2yg+ydyVwFN8Wxlpqu4a7CTEtzHbCW9XS90/LR65nB3D0Ag4w3PCHAC2TisGggifrLuJIZzyhNu60tpUrTdPkBDG8gmCIg46ZDYooSgCiMbKLOjZJIXtFt/+aLko+KsnA9aPXQj
 QuDWZEpO
 NUjWiqjGZzSy7Rqpbjfsfu9r6oTRJb/NXy3wnQLnEbondWnqV4Ve/IVhldmWLeCxzAPc0CuqKMmEkT/BxIRm5ImFFBCUb6Hz08TkKJPDODAXG23BoF2LI10M3WhAMOi/UEX6FHQcKyia50LFx0XEuz23M0QlfLZhN69QB2jHc8Q3j+5iN907HDjtwSBrZfAZL58tgkLvL4rutVfAyENnzPUFCdgG2hto48theB2ca9HukG/MHKXcizEuVZ+sRwz/ngxfV775oeY1hLKc53/KBlhYFJ2CScTodk8UFlP6Cnmm4znfFggM+3qtvIeFO7nZgQrNJEF61sCK++q+VvmhD/YHGs3nh2D81qriQO3R3oIs3jOlcG7Y86AJyxm0t1k4ZcRJr/LrfSoRsj3FAgRZ47caoEBTleVpvzTNuJbHzhojxkkx21u7QV4C2EJ3yKTkzn7A008uUmXnDfCf6+5ZNujcxNkdlWn/TtcEyS5Mesw49UyGNJKkR542jFvrvfKVToHfSvcZNsfP54YlVPElv2MXxZCZ+094KnUKZmOf0ub1sulTIP/UxwV2Sggzk6BU4h4VFOxx3bh9aLz75YohLG233hSDXUzcyxYEN8IXHQvFsLU16VKCovkeihPtL8bNSt/oTXG7t6X7DEdgWGaUv6U6hvx2GvjQbKX9kr3WXuyNY1zgCBPnpCiY04jE6Gy/iEfRoUSzdbINo9esmZMWL78quHKbdVKJ06vYLsqMqd0pGiPV5oEf02KRNpQT7bD+mp5W917GOUe844qsijvRelW1g5qRWEWZkDVsp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 25, 2025 at 05:19:05PM +0200, David Hildenbrand wrote:
> On 22.08.25 19:29, Lokesh Gidra wrote:
> > Hi all,
> >
> > Currently, some callers of rmap_walk() conditionally avoid try-locking
> > non-ksm anon folios. This necessitates serialization through anon_vma
> > write-lock elsewhere when folio->mapping and/or folio->index (fields
> > involved in rmap_walk()) are to be updated. This hurts scalability due
> > to coarse granularity of the lock. For instance, when multiple threads
> > invoke userfaultfd’s MOVE ioctl simultaneously to move distinct pages
> > from the same src VMA, they all contend for the corresponding
> > anon_vma’s lock. Field traces for arm64 android devices reveal over
> > 30ms of uninterruptible sleep in the main UI thread, leading to janky
> > user interactions.
> >
> > Among all rmap_walk() callers that don’t lock anon folios,
> > folio_referenced() is the most critical (others are
> > page_idle_clear_pte_refs(), damon_folio_young(), and
> > damon_folio_mkold()). The relevant code in folio_referenced() is:
> >
> > if (!is_locked && (!folio_test_anon(folio) || folio_test_ksm(folio))) {
> >          we_locked = folio_trylock(folio);
> >          if (!we_locked)
> >                  return 1;
> > }
> >
> > It’s unclear why locking anon_vma exclusively (when updating
> > folio->mapping, like in uffd MOVE) is beneficial over walking rmap
> > with folio locked. It’s in the reclaim path, so should not be a
> > critical path that necessitates some special treatment, unless I’m
> > missing something.
> >
> > Therefore, I propose simplifying the locking mechanism by ensuring the
> > folio is locked before calling rmap_walk().
>
> Essentially, what you mean is roughly:
>
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 34333ae3bd80f..0800e73c0796e 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -1005,7 +1005,7 @@ int folio_referenced(struct folio *folio, int is_locked,
>         if (!folio_raw_mapping(folio))
>                 return 0;
> -       if (!is_locked && (!folio_test_anon(folio) || folio_test_ksm(folio))) {
> +       if (!is_locked) {
>                 we_locked = folio_trylock(folio);
>                 if (!we_locked)
>                         return 1;
>
>
> The downside of that change is that ordinary (!ksm) folios will observe being locked

Well anon folios, I guess this is what you meant :)

> when we are actually only trying to asses if they were referenced.
>
> Does it matter?

Also another downside is we try lock and abort if we fail, so we've made this
conditional on that.

But surely this is going to impact reclaim performance esp. under heavy memory
pressure? It is at least a trylock.

It's dangerous waters, and I'd really want some detailed data + analysis to
prove the point here, I don't think theorising about it is enough.

>
> I can only speculate that it might have been very relevant before
> 6c287605fd56 ("mm: remember exclusively mapped anonymous pages with PG_anon_exclusive").
>
> Essentially any R/O fault would have resulted in us copying the page, simply because
> there is concurrent folio_referenced() happening.

Fun.

Thing is we now have to consider _every case_ where a contention might cause an
issue.

One thing I _was_ concerned about was:

- uffd move locks folios
- now folio_referenced() 'fails' returning 1

But case 2 is only in shrink_active_list() which uses this as a boolean...

OK so maybe fine for this one.

I really do also hate that any future callers are going to possibly be confused
about how this function works, but I guess it was already 'weird' for
file-backed/KSM.

So the issue remains really - folio lock contention as a result of this.

It's one thing to theorise, but you may be forgetting something... and then
we've changed an absolutely core thing to suit a niche UFFD use case.

I do wonder if we can identify this case and handle things differently.

Perhaps even saying 'try and get the rmap lock, but if there's "too much"
contention, grab the folio lock.

>
> Before 09854ba94c6a ("mm: do_wp_page() simplification") that wasn't an issue, but
> it would have meant that the write fault would be stuck until folio_referenced()
> would be done, which is also suboptimal.
>
> So likely, avoiding grabbing the folio lock was beneficial.
>
>
> Today, this would only affect R/O pages after fork (PageAnonExclusive not set).

Hm probably less of a problem that.

>
>
> Staring at shrink_active_list()->folio_referenced(), we isolate the folio first
> (grabbing reference+clearing LRU), so do_wp_page()->wp_can_reuse_anon_folio()
> would already refuse to reuse immediately, because it would spot a raised reference.
> The folio lock does not make a difference anymore.

folio_check_references() we're good with anyway as folio already locked.

So obviously shrink_active_list() is the only caller we really care about.

That at least reduces this case, but we then have to deal with the fact we're
contending this lock elsewhere.

>
>
> Is there any other anon-specific (!ksm) folio locking? Nothing exciting comes to mind,
> except maybe some folio splitting or khugepaged that maybe would have to wait.
>
> But khugepaged would already also fail to isolate these folios, so probably it's not that
> relevant anymore ...

This is it... there's a lot of possibilities and we need to tread extremely
carefully.

if we could find a way to make uffd deal with this one way or another (or
possibly - detecting heavy anon vma lock contention) maybe that'd be
better... but then adding more complexity obv.

>
> --
> Cheers
>
> David / dhildenb
>

I mean having said all the above and also in other thread - I am open to being
convinced I'm wrong and this is ok.

Obviously removing the complicated special case for anon would _in general_ be
nice, it's just very sensitive stuff :)

Cheers, Lorenzo

