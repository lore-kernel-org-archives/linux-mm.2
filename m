Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CADCD5B86D
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 20:50:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DAD16B008C; Mon, 15 Dec 2025 15:49:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 223AC6B0096; Mon, 15 Dec 2025 15:49:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09DAB6B0098; Mon, 15 Dec 2025 15:49:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BC90F6B008C
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 15:49:56 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 83513B89E8
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 20:49:56 +0000 (UTC)
X-FDA: 84222897192.20.7E1473D
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf27.hostedemail.com (Postfix) with ESMTP id 257B640006
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 20:49:52 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=E1jGPAI3;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=wpCt4DcG;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765831793; a=rsa-sha256;
	cv=pass;
	b=vAscig8CID/k6dSt2rrlLLc01TqxS7d/n2TYAVycbZ/dvE+QEqos80lVkcSwb2KztPjSCv
	zx7IpTCtx6nE0bOIxkHsXI0/S4SsQEkAumzhzOrgnCePBqB5fr/UHIEpidepjR2JTmkfC4
	TMYCBpHSzo9fpwSsoWMjkBSBlm4X3ko=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=E1jGPAI3;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=wpCt4DcG;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765831793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o266QWawPXuMgw57nfDe7uEF5kENsvQadZc8AxangC0=;
	b=zkmOfYOKGjpS8UBrFvF1G707Z5f0es6aYQVXbtdJag8sP6oSKCbhr8k6YxbLmV3boohaHE
	77oVV+eOAKNr+P4QZb11joE2pzwWvab4WVjITFw9ax2E1fp4dDgrMkjiS7MPoBJ2QBFe6H
	s9I9M+gEbreVJYBMuqtLcr45A5yQPIA=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BFJCJl72788721;
	Mon, 15 Dec 2025 20:49:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=o266QWawPXuMgw57nfDe7uEF5kENsvQadZc8AxangC0=; b=
	E1jGPAI3W89d48i/c4yKgPrjjlOCjhcuXZlxylKyqhKsYoBI+Dd1H0SenlxGSZb5
	CypiNEPRz2A+vbjti9mAp3FHDBvK7kOvSFNXKi5kJzClKmM0RQXablijfR+O/6TT
	/XU8fX/g//878KXidmMunzIyvMYAvv8PGTyFsYVIJAtW24P7zJdlLyBWVKum8Tmj
	dBq2moOq3jxE1314ubvhXnu+dJV9By7nha4kbQAPWteC18q1WJ2hYx5BJkMfSW32
	IkMvg0t0VRyH18FSPvHXFVIgqHk+dhptqu+Mbd+WMWLsClJQsLk/W03Tj2MAoKVu
	FTiFffEaClxCp1eZMGSwHg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b10prjst4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Dec 2025 20:49:36 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BFKAmZa024769;
	Mon, 15 Dec 2025 20:49:35 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010065.outbound.protection.outlook.com [40.93.198.65])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4b0xk9nkv7-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Dec 2025 20:49:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eo/+iuPF7azqVCcgIaa03S4zZp/V7DOVpjk/dlkQaGB6WCEw9kK2kg0hFcKxwWqt0G08bsn/G+xYpxO9ctTWwAITd2Xsf8NN/zF6LhSsnH0ZMw5CH+ce1ba29MZ1fZsEqZr7BRYU+cPr42Tc5wdvtC0//U94MYorbR4fHPHdWceKSLtbVMbRDoLMkvS5y1Oe5X2CTd2DIc9mSfGSw/iut43IXmom+5lCjgJIy7c0zAQIulZIKH+Q59Jjph1/ky2duzW+hpVd6ASJZOLz29gQn9mhwuXwazMByifalME7+b+RP9AI8mMlB+TG6aX24rQqfafZa+toQXZchtr1GrAQlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o266QWawPXuMgw57nfDe7uEF5kENsvQadZc8AxangC0=;
 b=eaMAuEga6R7hBdyTiF0NKqJsOCIBx0XDPL8+ESnKPWbV+3cWUDc/8N+x/SyT18a7z7LVnW5wrTKCLLV84/BFrDc6oketQXLa9MP6GXk4cldPg5khny5Racgvv49xSGFN0ilB5uUuBTQh6zKP59Zepipyb/Chb8NA7fZxWUgd2P4q4peDr9Nj5yW5CD9fWu2Pp3jr1/W85PIC8qNHKM9FmFFNFcyUgjYD62aOoGrWhS1aqNc8BMLzXdt/KNeJ76DtrBEfD4zR7rZ8ab42vNxgkxs8CRERO4usU9Few2TsKcyh1LTkxHQccGSfyBbuR6V9maN9cbbek1tP3dvV5mRrtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o266QWawPXuMgw57nfDe7uEF5kENsvQadZc8AxangC0=;
 b=wpCt4DcGxmTGk6/mDUp9l2HN6iIi7ZWqJ9HqrGXVTfv8yFEaP/Hm/3y4vwi5QZNqhonaqobQL+21wjQJZibriwVS4CHpiSBdL4NLQpYqUFKUH3w4L1xUPMeo+gmwkXtBBCj2NJwe0P65Pf5wmMRJcyaumGNP7xWYKXTdZaCs8Xs=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by CH4PR10MB8049.namprd10.prod.outlook.com (2603:10b6:610:240::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Mon, 15 Dec
 2025 20:49:33 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9412.011; Mon, 15 Dec 2025
 20:49:33 +0000
From: Ankur Arora <ankur.a.arora@oracle.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, david@kernel.org, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
        mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
        tglx@linutronix.de, willy@infradead.org, raghavendra.kt@amd.com,
        chleroy@kernel.org, ioworker0@gmail.com, boris.ostrovsky@oracle.com,
        konrad.wilk@oracle.com, ankur.a.arora@oracle.com
Subject: [PATCH v10 5/8] x86/mm: Simplify clear_page_*
Date: Mon, 15 Dec 2025 12:49:19 -0800
Message-Id: <20251215204922.475324-6-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20251215204922.475324-1-ankur.a.arora@oracle.com>
References: <20251215204922.475324-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0077.namprd04.prod.outlook.com
 (2603:10b6:303:6b::22) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|CH4PR10MB8049:EE_
X-MS-Office365-Filtering-Correlation-Id: dccbb604-4980-418f-8db4-08de3c1b735d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?WcUCmnZSQxkRvvFFmlHQcmwSTFbL1/OFHzKekqp+Xuu19zr25y+11OT1aHaY?=
 =?us-ascii?Q?zaGc9HbbmJujx5dJNuTCPVaJznhK/mCebKw/gX7ty7Ep3E+oChOtzxmAg6S2?=
 =?us-ascii?Q?n5KiPgENl5jMU6sXXUiZ5vGDslTrQ1hKAvF44oQaWrRKr/EYPkqW8oBxchXF?=
 =?us-ascii?Q?sl+VhJ3zdQSP/fM/+cTy8g85txu3ui+YfJHNeI57xpKN/Qhj9TdY77uXzLYY?=
 =?us-ascii?Q?a0vpwJ2hm3quiFeR50iz5Ivt5rPWYWYr8sw2Tbv+FN+T3OS/UL/FniuwBoyH?=
 =?us-ascii?Q?PdJT+PVCFZk8KgwcID2ilWi2Njl2PbnccRB8RlgZimief9nqs6iSqRIdBfmX?=
 =?us-ascii?Q?F2bb6ufluRULMrsv0wAuVgndvAemdKLhur8SZ6stT1E3GKC3cPVHJq2hiJt3?=
 =?us-ascii?Q?41KdmFO1ggmRL4pEQ7eL1bl8HaHkrkpb50DLJSejjeodcWuvr4sZ4cRR3kdG?=
 =?us-ascii?Q?7N0MAWLB1kS01tY4HRjz/dI3myc5gm6X7PTChC9NgP6htiwBr6Pk6DtBATtZ?=
 =?us-ascii?Q?zzHaT/Utn9qRufKlMdqWTRI5gTiHQdZdk/rXEcM5oZ38fu1CNk2pkaF2ZSTJ?=
 =?us-ascii?Q?AuqzbQrNcktaLAdtxsrN+9YiJd48rJNnKZ7rsCKTL+eJOh9EgjS6XIyobFNB?=
 =?us-ascii?Q?ldYve9qILXZ8pdGOWKL8GngwvxApJZ9wa9hnBldw8/MtNd8amCHKL+riwGyS?=
 =?us-ascii?Q?UXr14NBrfT04yg6Cg90xqyuHH1eN8cD+4KxGMIUPOgOj/OCCUPdk8LZKft+7?=
 =?us-ascii?Q?PEjQmUKak2Ny6V/U2AaMJxUVTwgHuZPOwvQElixbGFz3eFOJuRq6BakYhiGn?=
 =?us-ascii?Q?ruFgJIriU0AoWDvwkdJlv9z//Ll+guXbZACUb8RT+vVzLCBw9EU/aOkMguZo?=
 =?us-ascii?Q?elh0dI9hlprt5Vwb10QfQGk4ndyQCwi7VuzZCPlyuDWRBhh+qYPxC61I/X9N?=
 =?us-ascii?Q?CZn1CEmsTJq2gEN3BCpAnrhz7+QjVegTDb2atlp+ibdI4Q2ig9TQUKG9SyfM?=
 =?us-ascii?Q?cLo5XPlEjd83tc0WCjM5s57Dr/KlMZQW+l9O0JBVMjK0Qi1C8OumO9IZ9MiZ?=
 =?us-ascii?Q?EHVqF9fJYdhXN2Im44f+P9yrm6iskBHRaErYhe1R/kXzT2dxDqVoIrqV1kWn?=
 =?us-ascii?Q?sWdbqkJfq18LYR9RgNGSIRoZy2fr1dwgg+R8jlQsBs2FsOzQc74JLjraKo16?=
 =?us-ascii?Q?u9RwYH2SOpPSrojcPdisWnnlQEq7FA+0vrs4hqUZ51rYQOxqRhxpXLbkc89n?=
 =?us-ascii?Q?Xgx/Fe7QWbfYxKAJ7DPFyEMSK9ZUADgp+QppNTuKfoDEJYbZOcEFe2P8k7Ef?=
 =?us-ascii?Q?j9CZZ/kH1KBDc/aUmJ1w8IOHLp5viUMVeXQzV35MTXC81044sN5CxI2tK+xc?=
 =?us-ascii?Q?3tfs42+li5nOx6hNewRvXdx6/SP8qTU/7AEyM04UPK6zCEO3YuU6t66hwxQJ?=
 =?us-ascii?Q?fB5RNG9bdY5B6R7+AS2WavoGhXzeJvZx?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QMuFxebm3XyRcEg9yfPM45Bd9iZ1cQEnsCfvTPFFL8/tcDL17NmpqJ8LGGXe?=
 =?us-ascii?Q?BSVqPVCDRjnHzJQHWgtaD7ISTGSM7RzNa1Z41E3u3gn6fNOeAInHK23jb2RR?=
 =?us-ascii?Q?0z5ByADiYneEgiUfS7nqbhjR/bntRq21VCiN1vLnfoMlVnPh7rj1Sxj61H2R?=
 =?us-ascii?Q?y6uWaS3Ew7QkDIUia7NWx4jmVJAEloXPXa23DgGbKlULNWt6GbTZ0oXuXq4g?=
 =?us-ascii?Q?h2xC2I0piBs9VXR1M2x8geVfsk7gXoWW4DuEsZRs9ymFJC4dEk4Who3Rmc75?=
 =?us-ascii?Q?y4JO9AsyAJGqm3YB43YBLN57RRSWTJUqZgtmbVVE1m/lwz94g4jRTspFpQo5?=
 =?us-ascii?Q?x38iwYKIJd5mmo/nDKRsiaKU5m9MDb7k6rSaSkpNmB7pQ38kPMrqLS9ZGybh?=
 =?us-ascii?Q?QfivYOeAN4Sg/b8FIsug53ZXh6uXzDCDRSHA1inlG3sCYWb+uneORDtB0xkC?=
 =?us-ascii?Q?7eKx3l5q1ImzL/memdOIrbsKXVnuITuFp2QuJmquxNFjb+V5yQzmySOt/5Pu?=
 =?us-ascii?Q?urG41PU9PXxSk5Yj+qjje/QgHO5hdVPtvkDd0EfV8hEQjOjcX+prqRCLmtdJ?=
 =?us-ascii?Q?fJojZxj3oQ0nofjGMOi4V38oxCUhoACOeOZ2EBcqVDvWzDTbSm9gLy5dsOqe?=
 =?us-ascii?Q?04Fuuad5NzuUnenyXVd5+Ty/dNfRtg/ZzhLO7y/q1JrW7jUPE9Ei0x4Vb1+C?=
 =?us-ascii?Q?kTDzfqdtcgHtaVXVLOyNNwSVpV1s4G/teadZMVIvxyqh+wBvZsksXx3QtDQz?=
 =?us-ascii?Q?J53e/dQY5VJm1vDh7WdI63AvVuLgOUJl4Et54zt7BxDIh+KHeb/kd9IfmXGT?=
 =?us-ascii?Q?g4qaD8co8Ui9IgMaiFrkjK0lwjNTdtLVRsoGFjIexMNeHlG87gzinJsaHzYW?=
 =?us-ascii?Q?81nHPiMbROLIa2AY7XHbANXOyxwIq4D3lmfqPg/nYUTLWGyEIcx7VGr3beVf?=
 =?us-ascii?Q?JwT7TlHncm2kjfOkl1xmZC9cEdhC1BTtfUdx4MookTNVfhk2x60mweo+M/hn?=
 =?us-ascii?Q?1/HFadGRxVTOD/E4PYDLkM58IXYebc2Y43qtgKnKBiGkuDhq7JUGSHJUtAdY?=
 =?us-ascii?Q?XEskPeNh4AU3FIG2hXr404rgi4s638OMpg/9yNL7CuZ9JgQIfzIld8YCgEVs?=
 =?us-ascii?Q?X4Htpm+8lcgsWLpg0pApWYgG75UR3AbkJdc+UsuVKElNRz0qLdv+MCa0Svi6?=
 =?us-ascii?Q?lVXjYA+2kTHdy1mEdDszf78yLQzV4dHSLoPcFRVhzvuLnn2e6cnuxCS4cNpD?=
 =?us-ascii?Q?uMha51WYhXCAYnoDn1r84iUJwgDWfLH+eg4v7P1Cq0IB/BS1KKt3F8IB5nI2?=
 =?us-ascii?Q?XPu8hs1+BiO5I4rLminpS9X4hwPGIcSHA3ySmoboPxyRXF6oOk4oO12RBKb4?=
 =?us-ascii?Q?TG4773SDsf+4czr7Iz6pjiv9ulAFaXnrGssINjToNXS/YH/8ayCqMa4CGx+L?=
 =?us-ascii?Q?vGa6Z/gQA2iGoCPAKnjUdoJcFP7k6Fq8plZZNRuTEJOEWxOBsMOsL901sz2I?=
 =?us-ascii?Q?nCGO6f9rZkVHmUQVFfkagzsIymxDFoU3uOT5VAISINK48J33FuNe5Z32f6Ak?=
 =?us-ascii?Q?N4Ecbn6gl20gmJVBCxMKc34PNze2wQCzNL254Tne43EzpPIz0K2FMmGAmaDn?=
 =?us-ascii?Q?UQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	KetgQViei/iNG4d3aufhzqLzUKWNcPafdESjPkaJUJdf8LzAD+XRs4coJes1cSl6TtNUOrYZnsMSkHDNDJkXVh+o+4Maemqh6xGFFnvK5BIvj4a+GlrIBALLmi2IgkqMuw91J1GsvTobG+OcbHRhVGr8pmLHAl9ngvgjzuUf1KdayQyD8dm0EUeGEleIVMzKGP2AJGda5cqxHuC70PFNCBQXc3VeIKlfVJ0KGjQK/jHcJoLvSfDcPmBaewvXhqhKOW42ruU4MjsctPThznIA2y6hKmDK9mR8RR/c0hypI4GXLMG5NOBU68JJ/36Yinbe+TuFOZLPLYfLyV+otSPyJ3QpXURg5QkyOrUEs1dZgRCRCFmXZBUxcP99YS7xRZzn1i6Fe51at75UyUA20wUXH+VEMn08qdt8j0UiSNPlhLzMGD4upeTcpxuXEmzc165BFledlfPuC0wf0srzOKCD19SdG0f3bzb4dJCghNKe1BcrARE09pRH3Q9CXyZAIO3O2kycTKX8srHNHAaY6kKo6yAS4+UvvJQ6XbDiuwy/GH32PYRHrAx/frjzRum/VN66dMnm+VVzOEYvKYB3PfeK2V8azWIMOBmkAZDMxOQM2dA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dccbb604-4980-418f-8db4-08de3c1b735d
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2025 20:49:33.1806
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ki+YWee4skkJfrR9qtyQdtjShJZLKifE3y3CdBain5XMtwapj6pL+lA7CrG1BavWQACywXb0xNkz5MxVZN7uaz2memGgrr9DzPDdPArl8ao=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR10MB8049
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-15_05,2025-12-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 bulkscore=0
 suspectscore=0 phishscore=0 adultscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512150179
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE1MDE3OSBTYWx0ZWRfXzMFc3UyGDs9B
 3H0lhwZlQW8gVLdNZTD00kkiLfj0pcYOjTu0N86cl78GSHw5Vi01FUq9ngQYtYPSMZjwlm2trEy
 hDgDyf1dsP6jwlvGfbQ1P3SZg8Z6jdvJItFe0JwsTZPaXcBlzR4A4oHX4wM3jLvD/exg4atf+C0
 2+ODqJHeomHTZK6aH+6tsjvZYSfudm/QJupjVHCoPc4GbXQ52mtugFSYYYNgNjEw+F1J+7fRzQo
 D2423zl9QNqtzqBMXMDizk1/jsYFRllcfSP46MnAwLe+cUZ6+68KxZjbOxtslwXuJ9NumLOPyUl
 grjBWLvZXh0FyVPMwwv0rwQ38slH9Sygwhisok8MCwZ3Xrs0nDCG6tKGYMYgOnoNkQKBfKyho1q
 Ji188Si4K7hLXs6LrJkIfwMKj43PSg==
X-Proofpoint-GUID: vk25RwwQDNGn19VcRrh_gC35ngazV5Ep
X-Proofpoint-ORIG-GUID: vk25RwwQDNGn19VcRrh_gC35ngazV5Ep
X-Authority-Analysis: v=2.4 cv=dParWeZb c=1 sm=1 tr=0 ts=69407460 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=wP3pNCr1ah4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8 a=zd2uoN0lAAAA:8
 a=EufNLKQd2-G431giCzkA:9
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 257B640006
X-Stat-Signature: c8kb5feydut3fjtmj6u49s7ncbq5whkg
X-HE-Tag: 1765831792-250045
X-HE-Meta: U2FsdGVkX1/Fp+IM0fNp0VGK+DSU2B0G3yOz8N8tneOes0QdEqH6QV7ByQz6tIKhzRy6mesCsizo5t1zpAUOfcTwnZPmCFcUY9kY/GHyU2yFCmIsxXdFVQPZyUmMtwU1tb3EANj58joN17h+JqgwxBVBbj3hVhmpTr7MVZu3a+ap68kHsDEYxbnEkiffSjnF74ond/yEypJ3mLzn2AyQgSd1jIsHO0maxr6MOptw32Lf7q2tkOV98R33J0qD05pvtDTCQEWJmT+CMc6TpSlJQJ6UYoKqaWG2xfFE5qgKiT3GOAg1N2OxfEAyab1PsVD4tBm5Vy0d8tK+xfmyN5Jo1gpGRGkZCE5OfUYc0fwA6opTcp6ugnTFmZ0o4pWkKhN2o+j6fGKzjb/cnqNzOdjq7GOlOH16s0mtTmFUTBb/ykv3p/msH5gx+KVko6KhdttAq7Y2KaiMjfTt+rNZVe6hsvLFOxApW825cPdc/HW4Dz/6ulVFG3wilqIqEeUHopXeyc2wcABo8JYxHrQ0YYR/iiWblaNyzND1/gkO8ByTnBUGcdVoA7d5K1ARig29ZdRtKIpXXBdgaaH2YQ1PI9X8VAqIiLLKmOAFzdCpCmecN2Oqp9zo1hDBHuVz4xekR/K1CL8uBwLn75t1obIae9pBZyq8teM6J71qm3ZUXjd/S/afENAfApn3kwwBUBCJR0iNOs1fBjMxmYxcX2ndBmbLua75Qoj8KVC35eUh+TN4FfzaqsAv97cvcKx2tWJp7uxcHoPwwzQTOBuED6a1bUs6WS36bd1vZ8Qq1ZOLi8BuhxeWVH33v5QANoksavnaetzWaipwQZs2ZAg11yyekKDluwItWwxfEu8qnR06d7I6E/8VxMfffoZ8YLwkANCFeCVDsBhJdX2r979ivimYVk7bVCvhAk91e0WSH5Tf4qovkRN6C3FCrtkkAtUWKT9HZNcqfUVoeEV3DVFJ2Mvwmr4
 fcam3noj
 n34qDShORDNdPZaGuxNdsOmRaHDnPRoli7JAD6Vorrx9Z8ZJorZzD3rRGHCb8LwXj7WFCqqh4D7QGUnMhwCEKR4iZss06xE0HwfalN7bqUaiMQhydqg6cjcOmBHu8WIgvlAkTC1EtNyBfayrB1g59KD6dgSjsgHhTbGPQf0bm8Jh/530uyijdkMN8fJXMIZ9La4g/RXlDUEnlmmCAPQxnKOofBqu911P8qLsmLGDXQ5agDghGYhEj8LuE+WqeQCYqMDwvZ5wawY+qIr6DZHxRAzAvmDDLTtNzxDIEzPim4cbs/kWfYJ/KRAVCPvaxMic9g9agByU7AfFKi5aIOwRJewmSFUmW6LcJrj77y2TT3n4z5msqVZyyjPj7Pzjm9aQbKHB2dDIlgD1qDjRR2s0E0MEXHpuVVqUY4FJ8x1LX5oZp/dTa7H2q66Ra7LHj8M7I9oKF/p1QQ3I9/aAbnEA242tDMvlAamrykgwECwryjptvuivOVDgolkSw6vwt8DzYDGXbyfssrPohR3pptAJtslBfcyv46jijBBRVLHdgovBuma2LFSQ6gaLn83I6BAGTqxZn7++u1vvq+QkQTWwZiTRyDOj1940MQOLSS2nE2T1dUbsET1AAKnfn6iOb2Y51tpBjaoUtcGH6JnJomKtokg0qbXs3SX0KPdKctpfK5W53lFA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

clear_page_rep() and clear_page_erms() are wrappers around "REP; STOS"
variations. Inlining gets rid of an unnecessary CALL/RET (which isn't
free when using RETHUNK speculative execution mitigations.)
Fixup and rename clear_page_orig() to adapt to the changed calling
convention.

Also add a comment from Dave Hansen detailing various clearing mechanisms
used in clear_page().

Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
Tested-by: Raghavendra K T <raghavendra.kt@amd.com>
Reviewed-by: Borislav Petkov (AMD) <bp@alien8.de>
---

Notes:
  - addresses comments from Borislav Petkov and Mateusz Guzik, threshing
    out some of the details in the comments.

 arch/x86/include/asm/page_32.h |  6 +++
 arch/x86/include/asm/page_64.h | 67 ++++++++++++++++++++++++++--------
 arch/x86/lib/clear_page_64.S   | 39 ++++----------------
 3 files changed, 66 insertions(+), 46 deletions(-)

diff --git a/arch/x86/include/asm/page_32.h b/arch/x86/include/asm/page_32.h
index 0c623706cb7e..19fddb002cc9 100644
--- a/arch/x86/include/asm/page_32.h
+++ b/arch/x86/include/asm/page_32.h
@@ -17,6 +17,12 @@ extern unsigned long __phys_addr(unsigned long);
 
 #include <linux/string.h>
 
+/**
+ * clear_page() - clear a page using a kernel virtual address.
+ * @page: address of kernel page
+ *
+ * Does absolutely no exception handling.
+ */
 static inline void clear_page(void *page)
 {
 	memset(page, 0, PAGE_SIZE);
diff --git a/arch/x86/include/asm/page_64.h b/arch/x86/include/asm/page_64.h
index 2f0e47be79a4..ec3307234a17 100644
--- a/arch/x86/include/asm/page_64.h
+++ b/arch/x86/include/asm/page_64.h
@@ -48,26 +48,63 @@ static inline unsigned long __phys_addr_symbol(unsigned long x)
 
 #define __phys_reloc_hide(x)	(x)
 
-void clear_page_orig(void *page);
-void clear_page_rep(void *page);
-void clear_page_erms(void *page);
-KCFI_REFERENCE(clear_page_orig);
-KCFI_REFERENCE(clear_page_rep);
-KCFI_REFERENCE(clear_page_erms);
+void __clear_pages_unrolled(void *page);
+KCFI_REFERENCE(__clear_pages_unrolled);
 
-static inline void clear_page(void *page)
+/**
+ * clear_page() - clear a page using a kernel virtual address.
+ * @addr: address of kernel page
+ *
+ * Switch between three implementations of page clearing based on CPU
+ * capabilities:
+ *
+ *  - __clear_pages_unrolled(): the oldest, slowest and universally
+ *    supported method. Zeroes via 8-byte MOV instructions unrolled 8x
+ *    to write a 64-byte cacheline in each loop iteration.
+ *
+ *  - "REP; STOSQ": really old CPUs had crummy REP implementations.
+ *    Vendor CPU setup code sets 'REP_GOOD' on CPUs where REP can be
+ *    trusted. The instruction writes 8-byte per REP iteration but
+ *    CPUs can internally batch these together and do larger writes.
+ *
+ *  - "REP; STOSB": used on CPUs with "enhanced REP MOVSB/STOSB",
+ *    which enumerate 'ERMS' and provide an implementation which
+ *    unlike "REP; STOSQ" above wasn't overly picky about alignment.
+ *    The instruction writes 1-byte per REP iteration with CPUs
+ *    internally batching these together into larger writes and is
+ *    generally fastest of the three.
+ *
+ * Note that when running as a guest, features exposed by the CPU
+ * might be mediated by the hypervisor. So, the STOSQ variant might
+ * be in active use on some systems even when the hardware enumerates
+ * ERMS.
+ *
+ * Does absolutely no exception handling.
+ */
+static inline void clear_page(void *addr)
 {
+	u64 len = PAGE_SIZE;
 	/*
 	 * Clean up KMSAN metadata for the page being cleared. The assembly call
-	 * below clobbers @page, so we perform unpoisoning before it.
+	 * below clobbers @addr, so perform unpoisoning before it.
 	 */
-	kmsan_unpoison_memory(page, PAGE_SIZE);
-	alternative_call_2(clear_page_orig,
-			   clear_page_rep, X86_FEATURE_REP_GOOD,
-			   clear_page_erms, X86_FEATURE_ERMS,
-			   "=D" (page),
-			   "D" (page),
-			   "cc", "memory", "rax", "rcx");
+	kmsan_unpoison_memory(addr, len);
+
+	/*
+	 * The inline asm embeds a CALL instruction and usually that is a no-no
+	 * due to the compiler not knowing that and thus being unable to track
+	 * callee-clobbered registers.
+	 *
+	 * In this case that is fine because the registers clobbered by
+	 * __clear_pages_unrolled() are part of the inline asm register
+	 * specification.
+	 */
+	asm volatile(ALTERNATIVE_2("call __clear_pages_unrolled",
+				   "shrq $3, %%rcx; rep stosq", X86_FEATURE_REP_GOOD,
+				   "rep stosb", X86_FEATURE_ERMS)
+			: "+c" (len), "+D" (addr), ASM_CALL_CONSTRAINT
+			: "a" (0)
+			: "cc", "memory");
 }
 
 void copy_page(void *to, void *from);
diff --git a/arch/x86/lib/clear_page_64.S b/arch/x86/lib/clear_page_64.S
index a508e4a8c66a..f7f356e7218b 100644
--- a/arch/x86/lib/clear_page_64.S
+++ b/arch/x86/lib/clear_page_64.S
@@ -6,30 +6,15 @@
 #include <asm/asm.h>
 
 /*
- * Most CPUs support enhanced REP MOVSB/STOSB instructions. It is
- * recommended to use this when possible and we do use them by default.
- * If enhanced REP MOVSB/STOSB is not available, try to use fast string.
- * Otherwise, use original.
+ * Zero page aligned region.
+ * %rdi	- dest
+ * %rcx	- length
  */
-
-/*
- * Zero a page.
- * %rdi	- page
- */
-SYM_TYPED_FUNC_START(clear_page_rep)
-	movl $4096/8,%ecx
-	xorl %eax,%eax
-	rep stosq
-	RET
-SYM_FUNC_END(clear_page_rep)
-EXPORT_SYMBOL_GPL(clear_page_rep)
-
-SYM_TYPED_FUNC_START(clear_page_orig)
-	xorl   %eax,%eax
-	movl   $4096/64,%ecx
+SYM_TYPED_FUNC_START(__clear_pages_unrolled)
+	shrq   $6, %rcx
 	.p2align 4
 .Lloop:
-	decl	%ecx
+	decq	%rcx
 #define PUT(x) movq %rax,x*8(%rdi)
 	movq %rax,(%rdi)
 	PUT(1)
@@ -43,16 +28,8 @@ SYM_TYPED_FUNC_START(clear_page_orig)
 	jnz	.Lloop
 	nop
 	RET
-SYM_FUNC_END(clear_page_orig)
-EXPORT_SYMBOL_GPL(clear_page_orig)
-
-SYM_TYPED_FUNC_START(clear_page_erms)
-	movl $4096,%ecx
-	xorl %eax,%eax
-	rep stosb
-	RET
-SYM_FUNC_END(clear_page_erms)
-EXPORT_SYMBOL_GPL(clear_page_erms)
+SYM_FUNC_END(__clear_pages_unrolled)
+EXPORT_SYMBOL_GPL(__clear_pages_unrolled)
 
 /*
  * Default clear user-space.
-- 
2.31.1


