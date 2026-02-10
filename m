Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1481AEE6B73
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 04:47:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F94B6B0089; Mon,  9 Feb 2026 23:47:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A6896B008A; Mon,  9 Feb 2026 23:47:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 528456B008C; Mon,  9 Feb 2026 23:47:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 406246B0089
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 23:47:17 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 090B813AA60
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 04:47:17 +0000 (UTC)
X-FDA: 84427312914.14.A96A715
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf15.hostedemail.com (Postfix) with ESMTP id 85564A0008
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 04:47:13 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=CTyvv6V9;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=TfhB37TK;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770698833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dx64kf0v1t4cqgXA5ArTSFdU5jA/9Nyx4CKiuQ2gZRY=;
	b=UuKLHFIC4eEpc1JfWLLBXej6Vlhuv1igxr7H2h0p6NPkeVp5qRAIHSm/sQFGDhCWnkL7Qy
	Y0ozUVfv7+Ghc5CfPdEJr4Bh/z6BDPCyacqFU/eYYyBj0B/9SVSZEng1jJgnTkYhTB5gXF
	nFCdMTXa10fwpqFj55Hk4MvKhvuBdk8=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770698833; a=rsa-sha256;
	cv=pass;
	b=vXNm7eGJgQeKVj2/WED2SfkNTkfhhnmYdgBFTHHVT/HT7YObsjVifKUxfkaL/z8jPXuRaL
	0HvzoQ/85xB21EDOxGJj5+S52jrJXb0BUOGCVvvC8mKmwm0LsnfmczikUl13hgGFBhRrFq
	9j0X3mrM35aLrYP5Y9guaLHhAdbXrbM=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=CTyvv6V9;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=TfhB37TK;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 619MUn3C1557983;
	Tue, 10 Feb 2026 04:46:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=dx64kf0v1t4cqgXA5ArTSFdU5jA/9Nyx4CKiuQ2gZRY=; b=
	CTyvv6V9nqucTkhIYpAzZDO0k/V7hDQFRCfNxnlFcf7yECWfv0QkFVlF5OZzu+/a
	bbIG/qcBsR//JysGt1eW57zcI59ps2M+fweP/hcSMRka9L4Ujq856fKd5lchal/Q
	U/JDMeqSQo5LL376E0et6w+GlOm5n4La8G9UfkNyK+5+Ez4PJX1o/903WBBkVhod
	8CQk/ihKhAd22K2ESAAcCv8shEmvSvpyyBnOb52b31gS8RpZOP7cKqAD8GyoPvOD
	UNOLr/p7exCz/lhzKFazF99+RPanzj3HwOqWjUBrXnMyzS8hTLzxxbJldyKpDvvt
	s7Su73l9Lz8jtZirvkNadw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c5xhub945-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Feb 2026 04:46:59 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61A0gPVw004845;
	Tue, 10 Feb 2026 04:46:58 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012018.outbound.protection.outlook.com [52.101.43.18])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4c7jnqt6hp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Feb 2026 04:46:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=x3np4pdIbxjWYqLiyKFFSoyNtq1S0vqnPBWkre/bWvSF6kmacI1/634KN0Ru5UgcmjYYPVbtYLYmnPd6qNfYnYf4sEanWhtE+nF5SZ5oWtd3yzK5HMKMSSndLRkP22sTKt/kSPBgR7CvU8LnPM7j+Q/6M15lF2znA32pc6YDYesr2nsWmr7yAdYbZfE4yk4x/XtnXspEbDO6g1l8b8aGxKwdOGd8oH54alW9lB7/Y0at/YlkPk1WQpcN4Q+psavy/1uW/ATkCoaVe83dPxz9I0Oi0+vY1JE6lmrlFVsrZX46V4k/aUmoHZV1NbhnPq+9/og0m0ROPBfE6MHzhI1KYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dx64kf0v1t4cqgXA5ArTSFdU5jA/9Nyx4CKiuQ2gZRY=;
 b=RNUnf2fNYnZ2WPEezTTa/89EiHJUxtx0j/4qm9WXAM4EGnK0KI9Eypy9QRu4KyCEEu+lcKLdi4OxDWBFz8ppO+hF6bsn7jSSZb3Y/u8fZDfl9YXyqoJ3iQi4a502GeAbLmSIU0+AGDlTOXCmgH30yvTlKTxqL+V+1xEzngBQ/YMRTeU24T9VYHM+b8e+BSiQ3YK4a/G/N7UAXRdsE6EZP51rn1XuLYKb2VcYIQsK8lkJBGJrT78hiE+k7rsV6fs0ojQspeO5jE7O613HzDNskUtA1XMwLNa/yZ0knTmO/WqwiBfRqOgXUTURULyrLkyRdLgWyv3yfiQGQ+JvfuDenA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dx64kf0v1t4cqgXA5ArTSFdU5jA/9Nyx4CKiuQ2gZRY=;
 b=TfhB37TKs4zysDhBXsFHdv65TyEeplnlgnLusc4paW/scgNMKKFDYSsZcn+QjrlMu1t8rBvv4heFFhWhAOSs00EkvgqEuV1W51bEwO6lM2cWyb9O5b1BbuIZxpdQjKiikPiLcP6+EWJGaF4QRkZbWjNapPYaPzCgP4QumF25Yh0=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by CH0PR10MB5067.namprd10.prod.outlook.com (2603:10b6:610:da::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.19; Tue, 10 Feb
 2026 04:46:55 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9587.017; Tue, 10 Feb 2026
 04:46:55 +0000
From: Harry Yoo <harry.yoo@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
        Alexei Starovoitov <ast@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Uladzislau Rezki <urezki@gmail.com>,
        Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
        Harry Yoo <harry.yoo@oracle.com>
Subject: [PATCH V2 1/2] mm/slab: allow freeing kmalloc_nolock()'d objects using kfree[_rcu]()
Date: Tue, 10 Feb 2026 13:46:41 +0900
Message-ID: <20260210044642.139482-2-harry.yoo@oracle.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260210044642.139482-1-harry.yoo@oracle.com>
References: <20260210044642.139482-1-harry.yoo@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SEWP216CA0107.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2bb::12) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|CH0PR10MB5067:EE_
X-MS-Office365-Filtering-Correlation-Id: a4e6e851-0979-454f-a178-08de685f6a6a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VsMWwjb9pdlRTno8id6uHyNvnh7aavsJvgrlkcgrd//eBrL4796hbqvhl/oy?=
 =?us-ascii?Q?14liu0LaaghAmJpfkpZ03NQe30qzoPJSQzqnbpdp3Edol51qlGpLWHsF9Dc5?=
 =?us-ascii?Q?uV7e9kLSxcKGsoqlKPSxkyr7gkwMWa0r6k7CPkRLZ5qHvG7nSpuxeXn0ktqe?=
 =?us-ascii?Q?N2lWIa6IbznxdQRFFB3ETk1Ett6Jek/GNBCCpSx+fSlf+IKszGWqY3TKqzMG?=
 =?us-ascii?Q?7oI8Ex8qW++Va7zUiy2bdLU6CEXDcU4Vx8KBwXn2VaAxQUsTlp8TgLUWHIOG?=
 =?us-ascii?Q?2xOMBUT37mPNF+z5xIXPnudm2na9U+IHkBDiTaGo16PmdLWlF2UYZu8a+/6C?=
 =?us-ascii?Q?NiEqxiC57yvYaDO/ecwzySuXhEJYnB5DzyFO14Yt3+Uxwv/UMnCqEOD5HjHt?=
 =?us-ascii?Q?D1yds5rxG/u0qd6bDITeGeRXJ+n6Z2mieEcQOdqa49ZK8PAPfwqsJv2W29EY?=
 =?us-ascii?Q?uuWoj2klU2oRL1gHekQDEZmGLjuUeXL1mfR2YOnhVan5mD3Q9pUI9o2zLuSL?=
 =?us-ascii?Q?U+ZYcfWwkA/p17oRrmlarTaIOGsfZLecPC6k+dlBLsoxcQ0jf4TuEDKZBxSC?=
 =?us-ascii?Q?2AP03qGFIsbf+izOrode0vkW2ehEcndoA8ZFh46NOvqR3hchWG/HChaV7zlS?=
 =?us-ascii?Q?iNhvUkwzViJrCZEcgKlRu3ToULczjhAMS514MvSa1fRvr7PHk+6KLf7v6+1b?=
 =?us-ascii?Q?6ZaRY+MyDfNaLJIvEDsM6MPi5+kbnRcM1tpzIAzjNpvs1qrcAL+w3uobKDWv?=
 =?us-ascii?Q?GtdMabXoAa9Cf2LH6Ulnxn6zL3HY1Uvc4KLiiNmJfJOTK7MfgL6C7TinSgXT?=
 =?us-ascii?Q?4Goby5MTAiaaI9HUHkkIM7S8YprZPCelkawTtlrJ9PNyTH+Lyg1XWB3+Ka8/?=
 =?us-ascii?Q?hVCQTTamxIEw2RLWk2TB2/xgAPOdMmjVEFuWyZyy72kYNHEAJNacaOL4RBWo?=
 =?us-ascii?Q?oKSoJTOmZd+p8DLWU8qxg6/jqEVOq5d+14wcmLx19/G5uBB2kleaM4/ktYtJ?=
 =?us-ascii?Q?gJCbcXlD26UDx4qg3QTN3DHaWGTZCJIlfYQZBm/EnJhYuYkGNhCuvouKtzxW?=
 =?us-ascii?Q?gldMYs3czKjaUveVoExhqXdAf76MkyKM7FLPFk9/WnbriE/pFiSMZuutxKZO?=
 =?us-ascii?Q?oRJVz3A23I3TSXVDqxjfZyXjwogY+sTPc5CvJ15yMmCOeiKV7H+oI1tu6m8l?=
 =?us-ascii?Q?CBUpE66KLXu/1cInFEtge9rANwnVHXwSJspW36FdWcwr3fygUJtnBB3LqmyY?=
 =?us-ascii?Q?yvijYaeIyw+Feu6uxYpNhIlcPpsTeOcXQEL/LUHgCAsaVaUJCxfkD2b8RL6P?=
 =?us-ascii?Q?dxUY18zD3stmNcZDDZdc/XKL29Gb9M5s1V7j0gdeMEumhy6H/rJl3WcFpWU9?=
 =?us-ascii?Q?By0L4btOTz+tXDKHQw4xzLL1If47dftxRmGq2YLw/Xq/j2ybj869JDjBGHQs?=
 =?us-ascii?Q?UQTtmYtgTEr6YWu4Sc9Bs9CM/qUhvetTr6FFXI5IObkO4EfwRt8MYffIQwO7?=
 =?us-ascii?Q?Hzhqs4+LzmV9R6x/c50SjOy/ZQ8aQpcW1jAqX6b2dxKulSQRcG3tpibS/8b7?=
 =?us-ascii?Q?7TuOdeo+Aqfyj4RC4ck=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fVD7Az9jDw1IGey/ofVEj3SpFmsvd1DOgQmjTgeb8dHX1ubATVRUQVxoGtPA?=
 =?us-ascii?Q?qrEv5EiGwgC6Xr0XpCA7mJMjHQWeRolBBWHSkchSpvmncMb/8DWjjDpq9agr?=
 =?us-ascii?Q?8LEdkz37czpIMJ0sKKwP+VYIEgzgErpofWU1M6OqjxaZoolJ5Rja6EOqd4B0?=
 =?us-ascii?Q?4Z/sEn91Yco65plaAOTcLqgtqAtBC22GHaxt9t8wOd6iZy9sRJvRlEP+8Rgc?=
 =?us-ascii?Q?r+c4G+OGETop5O6tITrm9t/6fE/Dc3amaQycp0kP13/+xauyE5FfLtzt3/21?=
 =?us-ascii?Q?e2tuhM4vXkNCE1PPCXfmJP7E7AlCZewB9LTnuE475axq9nUf/UhwBKiNZPH2?=
 =?us-ascii?Q?fa3IJ8E/8/hWAQWMfq5QJkl35Rhvpo89R0Si06yiUXwtGWF6yfX+cqmit2RX?=
 =?us-ascii?Q?QtzMif5Nc09ITpGjTqN2J0odAwWF0QDDXeKjel4q1ADw6CPt39zDCJZzsvKm?=
 =?us-ascii?Q?nu29IE/eC7hvJi4C67nQcNTcUXpbKyghE09CUxyU9H9UzIMhzXkA6GWRVCrJ?=
 =?us-ascii?Q?gRF7Yu8QaJbXmMXeZ9UVR/YRQJigigpIHWtVTaq/sSanw73J7NyAH7G8TRGj?=
 =?us-ascii?Q?zlwhS6/GKnOmA57rfJgq6h6fqfEO3VqFX1VndsgXRUs3GsIFZwPMDdA1aHHv?=
 =?us-ascii?Q?ruoWvgazqk+Ruqnd3xKEXZIS7/Ya0kEUlEoqlZIgZbCMjOEkg6nfZ/GL2LDn?=
 =?us-ascii?Q?21i2bUQ22osj5pSIVBdvfsvry1oWLgdNmZQek/IlNUBi2fTOuqxCvvCyK6Np?=
 =?us-ascii?Q?k4xMzUrc5q8RS9UWccnCEmjLOtZGiQtmEqLRQ1P7LlTwknVlmtLMg5nuBRFz?=
 =?us-ascii?Q?At8Dgb0yRRJyi7WSx6vo7sYqQQzlOa3iu2co8aQSKNKlUqLWbHt+Cbyg75r4?=
 =?us-ascii?Q?pIyF1ff1IJWGMXeMbfOfSt+L8WJvN8sa3LNraUjkIJyMBwGoxGyWon07bVeT?=
 =?us-ascii?Q?0MEID6Vlozgv0DMdTmp5ABLX6NrZSH/mmtg+koTvI+jir16Z5l/aiz4qwXLT?=
 =?us-ascii?Q?ZmeKDiqkPTZrw1DO77j1NlhWh0stYx6LhWKoh7e+J3AMY2iLstHoAHTQeDdL?=
 =?us-ascii?Q?tFd4KVCaUtmPrUAAg1kF9/AEdr/U2JOknu2Fp9q7y79N5gZQqJNqEArj73D8?=
 =?us-ascii?Q?Hs70bYGX5AOg/aM91hIo4K4WdEFqxOmGrgTtDXWeF+itJ1dAzVxveGcMpthK?=
 =?us-ascii?Q?bdCC/+8WnfDSN1dFHjM9Bt09HOqXa8rqtSHXEOvZ088fZp0tC9v25Wiev+PY?=
 =?us-ascii?Q?Ab/OQeUve9Lltajribf+EjfYr4tvk1oA+lm3vsh5IOd/+GBFDy/qUjisSV9b?=
 =?us-ascii?Q?YabJrOjbvndvxXuPtNT/MsNqCJm+WlfwleySX2Bb1iB3n9jo4h5yGYbe7RhQ?=
 =?us-ascii?Q?mkXY8kpiLwZ8YOgsOwlGcax8qY6aImUeBRoLDJg87T7UHYEA8QWTJ14fNXwB?=
 =?us-ascii?Q?0ZiQ6TRVpLcQ7JHfc++sCiqPAYjYzAOzXYuDj3AOW58AzVXrJzMrNhnYELHQ?=
 =?us-ascii?Q?C6c2g572pOjAako2yrMnvPOTd07wmQd/w2aXLw2FLnOcOjbLGGD9u4kwfqRK?=
 =?us-ascii?Q?9BnbmAZRsmm2qImqcUlG9oS+GSv/2yLNQvQegImSNeAnmRgWytH+HnSxJaL9?=
 =?us-ascii?Q?kgf/123zK/ZHqpEOlTYN9jFrHwV/cLEFc9LVAflIJg/likV6kM0zXY2pDekm?=
 =?us-ascii?Q?+lD7N7jsO1vfXXtCqp3l7mando3H0mjd9WiwOnvULLwygsThwjC3mPDdZN1i?=
 =?us-ascii?Q?iXpIvzuo3Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9fnWkz+DB3l3r0CBIhXfIyPBdGP4/qlKfcn98c2UZ3zlj6+OYR4TWS4YxOkHfjHMPlS/kLZ3/dt9a3PiGWWG1rhpmCRos+cd2e2EonjNSlHBEZs17ojmxIX/2hFrxiUKi4vlk7QFZcVJ1dvOlQN+Sb5RIR87CPjRVRmkwaRF5gGtuYQ9uXk/czf2t1+e8h1shbxWpw/cXctGEOVWy5Ki1A4T6rt5iKz/LYDo0kjr7HxN/1GPra972KH4dDpRvyup17k9t5rlFKyLwGurfstq6VZuWq4YybtyofwmCc2W+bYiy9p/4FqL3I/gELeG/KincoW6+6Noei3ookGZKqVtMxzPmXtLt4iiZzPqscjrDL8Hu6MnUutmjgiJDlsidwRH6iMULO9TKEnUT0kr2HPZvyjLQTIXInYUDrvP2fV3p78RtjhJzJngIlwzOLKiTn3ZT4KK/c8laIwaRE/0kqJQgnYS7UnLzFnG3w9Wmj6nffV3SdZWxGTW7CHdLAW9gbPw1dqyAVfokwDrkW0q/OgBYSDmZamv22C4o8vg1AmGva3U5iCpLGiStZhBuyUsmlLbmUubVWqAbvEc6B50CjMBUrzvdvv9TIn7FlWCxRODWvs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4e6e851-0979-454f-a178-08de685f6a6a
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2026 04:46:55.0869
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zisk1U9npxwPbA0gHNQE/YI6gvhl6IGCMlyBWbT5xDYblJhDUXGeSjMH5P/gf9H56ogYspgSRXSrBPeyJamVzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5067
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-09_01,2026-02-09_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 adultscore=0
 spamscore=0 bulkscore=0 suspectscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2602100037
X-Proofpoint-GUID: KiP9Y_IoPgbQYkqbdNiMu7xBKNK4-Adr
X-Authority-Analysis: v=2.4 cv=FIsWBuos c=1 sm=1 tr=0 ts=698ab843 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8 a=7CQSdrXTAAAA:8 a=yPCof4ZbAAAA:8
 a=MQq_-n8oJk3kAu-yCuYA:9 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEwMDAzNyBTYWx0ZWRfXxTY9qCdIBbmQ
 vErLH2hVb9nEY6WKPQIDThtuwoinSZu/M/s7wVZatQ9URDtzlxTCmrfcA9pFBIdfRUXUh1N1MEB
 JtCRtKk/ivMj7LLdfJHMl5dTNV71jau3LetpyPyJgjMS/hw/33rim8b8ezGxyj7PWpWgCK8vw8W
 A4xP7ZjTJhZk+IQcsZaa24s9OklsraqMk0Hp+OqKwJ7ANgw5vrgLYVl7we2MCxO54aTw2YxHVzE
 6xI8PAW+PZRBu27luJh7h1hd/eDq0U/MBvCL9Xbtow24AZYAe1bCX1xu+kAFHK22lqfsfrRLMFE
 pBTeKrjZGREbsej5bGkyFGOZsj3e6P1MvCrcWFIIk08uH2zIPLcX7OTM1jwTssJI966q/abgitI
 D/QqlPVlYyTOpSpQO6b8zM7jmPfFMQhSAXNWowsGgyE/F0slomZfdae5/z6fzuTuN76zS3830Vm
 42zRC+d0lFCdMkQl7Cw==
X-Proofpoint-ORIG-GUID: KiP9Y_IoPgbQYkqbdNiMu7xBKNK4-Adr
X-Rspamd-Queue-Id: 85564A0008
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: fzp6mxpqe31xwddcmbd7regfrbg6numb
X-HE-Tag: 1770698833-180625
X-HE-Meta: U2FsdGVkX1+fnRaCGc+39sXAvqKzbFO7t13dJhJcEKV6tN7FO3DRNJmPpyePIlqCXNeIkfFDf7hGha9saY3+C0f7QgOzWlPr+G9wysYWxchOEVRgAD948BP9XL2gjkSLj2ajQDB5JdVknRHSdCb4SUc6m9Dv0j2scvLFZGgJD3VUxmjp3C5q8EQit/ekj2opz6lVb1YTvPM/dWZ52/ZmdLqgxQ7FSlq2X8VLmGOt4Iw9j6ffptUYypzb743DIkO58/aqpmvn02Njs95RHnDFj4cgPUfSIXDWGErVoL5gbtJw576XpJTzqtdmJRo/1nKl7CdiQenq0Et2BCnCKGcyDzAQXFe8PwuzPxgQEJebY5PG0Y5ktE9rzf/N76Q7PXdL2TYpq0/9rjLGoJ6lLkfGa/LmVjyqU7AAM34XF3b79DbFkCcyf9HmON9eokRdr1J+Fx08yG7+jeVC5DUNtg8xExeShYdYtVuXzBTWsIYhswnsr8Li4uArBPLNLgJHgfppDBybvKYIuYdsdblWGlz5zvURq2pmC+hW6r+PHF4KbdUwj54iQbFP1WAwaWUnBhKc6z7mjpW8LEldpkl+ad6vW9elEzDyOD343GYA0aNAbdZn5vAfG55k+bdSv+9uCLedwLOPu2jJ/n7CBBI+6pcSwgSS74pgvKFHRGMGEo5r3Pu1pWaZPC/kDDfyzUXWCY1aD5Ux1+ZhkcR16ClvR/eZVmyPdk3uCPytIrD7egAfUDK+JiyipfkQ/kojIYxvyuYGM+uYwRdhoh2Y+48eZpJQkmG92YnNdsAo0ObrpHnOe2kebwvP+JOnuUE7E1v0I0PCnuMzMkqiUbc3/wKYFSu3XxLiif5048HSHDudo8bzJrAhJhRLNu3NGP8vKLscYsML6+2njqsekbhz+4IIzEyNFkHC+8rxT0vAIJ7ilJLoKF7Nmm/MPP1hVhBpWWeagvO/Dr5OS/2hC4Fdf4VToSC
 VXqukIrq
 H24EUS/B4VjxvhVb1oml/OO2zZVGUmX2RQH61M0y93Xg6vk1jctqJGVjuhra1kAZfPfGRn1GaJpkYD26INgocwwaEAViS6Fm1Cu468iQtPeSBeOIBs7YNQIOc4H1cY6NAe3KW3h0ahuKKlSeuW2c1U37FGmN7ubedazVHK7p+nvFpOA/l4D9s+E67Akr/OabjL5MGWW2Ozne29h7T4kKW93cKUDyB7NuFPpCi27nzyCcqguFkJXbrP1XANxtfTyGWEvpRzuleskdPU1jzhQCiXWwQETVB5Og/XkgalmtylV9YBRvgfAlWcVOIqqZ0YNcHjtXpa3E4b404PaTaXbKf9a9HTRRJv9dcaSFXIimWroBkyj/Ntu4J3Dy/iZ7kEADhufELxmKRBsb8vWOaAaG36OgC7DE5f5vtztRfYHgmc4ziInordAAIVCltGKZv43e5CkJolyeqCRU1FcM5MHArn8hwSEMLTYAChKF6QMQ33lv81foPAWodsY0TDAODh2Q+PRs3E/ZeTWMrFkELEzBCr/D12ipPF8EK8BL9UAhG5hO2e4rU8GXaqRWA4oiOab+1xE1AjsGK9qid7L59vhYfoNJK3HDBZjI9TaS2NDWzdN6Dbc19ZluiYROg3bOlLon6WR5nQYu8F7SORcB6FZI9iLweIrxgipaVbWH+q+PjHUhL2D5tNNJUXmdxi3bgKH5PRZr2jRspRPh5755viNm6iLiMOgMSE/XVdkxtB+CGIqBfvko=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Slab objects that are allocated with kmalloc_nolock() must be freed
using kfree_nolock() because only a subset of alloc hooks are called,
since kmalloc_nolock() can't spin on a lock during allocation.

This imposes a limitation: such objects cannot be freed with kfree_rcu(),
forcing users to work around this limitation by calling call_rcu()
with a callback that frees the object using kfree_nolock().

Remove this limitation by teaching kmemleak to gracefully ignore cases
when kmemleak_free() or kmemleak_ignore() is called without a prior
kmemleak_alloc().

Unlike kmemleak, kfence already handles this case, because,
due to its design, only a subset of allocations are served from kfence.

With this change, kfree() and kfree_rcu() can be used to free objects
that are allocated using kmalloc_nolock().

Suggested-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
---
 include/linux/rcupdate.h |  4 ++--
 mm/kmemleak.c            | 22 ++++++++++------------
 mm/slub.c                | 21 ++++++++++++++++++++-
 3 files changed, 32 insertions(+), 15 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index c5b30054cd01..72ba681360ad 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -1076,8 +1076,8 @@ static inline void rcu_read_unlock_migrate(void)
  * either fall back to use of call_rcu() or rearrange the structure to
  * position the rcu_head structure into the first 4096 bytes.
  *
- * The object to be freed can be allocated either by kmalloc() or
- * kmem_cache_alloc().
+ * The object to be freed can be allocated either by kmalloc(),
+ * kmalloc_nolock(), or kmem_cache_alloc().
  *
  * Note that the allowable offset might decrease in the future.
  *
diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 1ac56ceb29b6..95ad827fcd69 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -837,13 +837,12 @@ static void delete_object_full(unsigned long ptr, unsigned int objflags)
 	struct kmemleak_object *object;
 
 	object = find_and_remove_object(ptr, 0, objflags);
-	if (!object) {
-#ifdef DEBUG
-		kmemleak_warn("Freeing unknown object at 0x%08lx\n",
-			      ptr);
-#endif
+	if (!object)
+		/*
+		 * kmalloc_nolock() -> kfree() calls kmemleak_free()
+		 * without kmemleak_alloc().
+		 */
 		return;
-	}
 	__delete_object(object);
 }
 
@@ -926,13 +925,12 @@ static void paint_ptr(unsigned long ptr, int color, unsigned int objflags)
 	struct kmemleak_object *object;
 
 	object = __find_and_get_object(ptr, 0, objflags);
-	if (!object) {
-		kmemleak_warn("Trying to color unknown object at 0x%08lx as %s\n",
-			      ptr,
-			      (color == KMEMLEAK_GREY) ? "Grey" :
-			      (color == KMEMLEAK_BLACK) ? "Black" : "Unknown");
+	if (!object)
+		/*
+		 * kmalloc_nolock() -> kfree_rcu() calls kmemleak_ignore()
+		 * without kmemleak_alloc().
+		 */
 		return;
-	}
 	paint_it(object, color);
 	put_object(object);
 }
diff --git a/mm/slub.c b/mm/slub.c
index 11a99bd06ac7..63b03fd62ca7 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2584,6 +2584,24 @@ struct rcu_delayed_free {
  * Returns true if freeing of the object can proceed, false if its reuse
  * was delayed by CONFIG_SLUB_RCU_DEBUG or KASAN quarantine, or it was returned
  * to KFENCE.
+ *
+ * For objects allocated via kmalloc_nolock(), only a subset of alloc hooks
+ * are invoked, so some free hooks must handle asymmetric hook calls.
+ *
+ * Alloc hooks called for kmalloc_nolock():
+ * - kmsan_slab_alloc()
+ * - kasan_slab_alloc()
+ * - memcg_slab_post_alloc_hook()
+ * - alloc_tagging_slab_alloc_hook()
+ *
+ * Free hooks that must handle missing corresponding alloc hooks:
+ * - kmemleak_free_recursive()
+ * - kfence_free()
+ *
+ * Free hooks that have no alloc hook counterpart, and thus safe to call:
+ * - debug_check_no_locks_freed()
+ * - debug_check_no_obj_freed()
+ * - __kcsan_check_access()
  */
 static __always_inline
 bool slab_free_hook(struct kmem_cache *s, void *x, bool init,
@@ -6368,7 +6386,7 @@ void kvfree_rcu_cb(struct rcu_head *head)
 
 /**
  * kfree - free previously allocated memory
- * @object: pointer returned by kmalloc() or kmem_cache_alloc()
+ * @object: pointer returned by kmalloc(), kmalloc_nolock(), or kmem_cache_alloc()
  *
  * If @object is NULL, no operation is performed.
  */
@@ -6387,6 +6405,7 @@ void kfree(const void *object)
 	page = virt_to_page(object);
 	slab = page_slab(page);
 	if (!slab) {
+		/* kmalloc_nolock() doesn't support large kmalloc */
 		free_large_kmalloc(page, (void *)object);
 		return;
 	}
-- 
2.43.0


