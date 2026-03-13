Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A917105F7A2
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 12:36:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C824C6B0005; Fri, 13 Mar 2026 08:36:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C370A6B0088; Fri, 13 Mar 2026 08:36:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0F3F6B0089; Fri, 13 Mar 2026 08:36:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9BD556B0005
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 08:36:42 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 45D251A006F
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 12:36:42 +0000 (UTC)
X-FDA: 84540988644.21.EBF7372
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf18.hostedemail.com (Postfix) with ESMTP id B05A01C000B
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 12:36:38 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=q5Szq2SQ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=NXETMeAD;
	spf=pass (imf18.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773405398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gKODIvxFLKAns6kx3bm8okUvgdvfmYNk/fj7efwhB2k=;
	b=M8JMJ9tf0INUC95Cqa9l/GrPkAfZK2mTfYZEd6WWWqZeECBW9PmYUpT4Ha6Lf9eKvXeDnQ
	uKHvZKNpu0ufe7U0qH5Ouga6a6oQDQkx3P9ZUQmt9QV3pJJJUrVUf//JwoDUH8cNqb8g5t
	fRW6/L1ugzr5KcKQudLTn4wfeFkzUOM=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=q5Szq2SQ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=NXETMeAD;
	spf=pass (imf18.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773405398; a=rsa-sha256;
	cv=pass;
	b=Sv5Ej2p7TYic6CZ76e4F1nrtQ/6bRZEiSoJ/BWwkgp65OVOqMXUfi4zlXNiPQi7JAkKLXC
	0NZzR5jDJQLFhdEDsaGA9ePhCQyeMdN2ZgWBeMOO7sLz/jBrho57xfzboGL6RESWYQIu0K
	X+Yc8gU/Au3LumdV4ndyYUKoyLarzSo=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62D9Grgf3206500;
	Fri, 13 Mar 2026 12:36:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=gKODIvxFLKAns6kx3b
	m8okUvgdvfmYNk/fj7efwhB2k=; b=q5Szq2SQHV69yk0hrZHT2M1hTu7PUgM7oJ
	ejy/mzHJmLCW3KGNdbcz/GpfCQ8IuPesp+wdtIrbfgROJHfjSvY8BcBicsVy85RG
	PbIPXgpePEQFCMVi2RZLuweyM+sJKzOMwq7aQua8A2hDMMv0EqjmyRpNpEw9j88G
	2bv9XGsYIa6Q+/Sd3xEPA+qypMP0dOWr6hxJHlQ9AXNBuXaN/rbwdKIZKFhKEg3l
	aABHDkH5Avu9G4hadUXunYBdDQezNfJl4J66IRUSRbOg8+hy7PetJdmC1JN/GZmh
	Q4g6Rsuzi9YD2r4+kExQPPxAXJXxgvvIiOdicKLsMR5tIP3s01UQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cuh4kjref-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Mar 2026 12:36:34 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62DCT9o5024518;
	Fri, 13 Mar 2026 12:36:33 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011041.outbound.protection.outlook.com [40.93.194.41])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cuh5v4ya0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Mar 2026 12:36:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WFx3rUqTF7tV3M2CzJof2FWE4RyCF0iKOidhut3UmCGKuBo64ea+61lWyGJNOHMCwlrg4S77F9fMbMuYG9a+c018TyabQHUopvJY54DGaUMcdEuVAit6qxDUnvjuCoGFvFqYDPe9KYeROl0EXZZsH+W0Ny/Oeq9wltTTfqu++FtcNnyzz1vseiGLhRDO0Lu9HkMmElmqd61Ie4kfmYd92XSxtYC7wqosxlghOYo8aZOIpKiYU33tDWb2N+UshyFF+3wrkVvACCsfQr4MiJB7qKhxIcUeVXtyThzsOoEVdQ/yROBKc3N0Zg9VDkG5gnqP1FYdgwdx3H2plAphoPrWxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gKODIvxFLKAns6kx3bm8okUvgdvfmYNk/fj7efwhB2k=;
 b=WYwSK2Y4VE2y88HAYBfzAYlIheV0NoZGm/w/9oDIsLuV1bNG6F55YHUF8zZe/mnwl71gPzZBckMXKwg6g55ZJrBiJHI2Rmd3fGrtL6pEBghifjZATYMGgtT0oKANl6M6WrKPlWR/qtsdI4uLc1C86LW+juUCU5mCDUXptC2qcNsEXIgtfluLilHInUkIX7+Oi+lIhFRZQkBamB22TH1NOcJzOVk95LMGUtTYCseBeH8MdfNVkhLxKBKrPyPCPzTMgFpgb7Hu334/Pz1i+PFaJcVrwF/UumW/Lkw4edjc17O037hHwaPKFxKwEtZQ869i6FKaQoeNYYr1WewaHOKEBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gKODIvxFLKAns6kx3bm8okUvgdvfmYNk/fj7efwhB2k=;
 b=NXETMeADEbyjA9nHwe1sG3oMPTNlII8kUOmsbHCCtvD3agsbIc/LQj/PzD2ZF9hwfp1N0eqKlSWjhXA6pSCesIz9bo1zxUam3UFxwbx7i+vx8C5hLUVuPaVO2gXTHCoe0ikhbHyqBmwn6Y+7G56G/TO8BiwDq0TIgfnWLPn/7QA=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by DS3PR10MB997700.namprd10.prod.outlook.com (2603:10b6:8:347::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.18; Fri, 13 Mar
 2026 12:36:31 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9700.017; Fri, 13 Mar 2026
 12:36:30 +0000
Date: Fri, 13 Mar 2026 21:36:22 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Hao Li <hao.li@linux.dev>
Cc: vbabka@suse.cz, cl@gentwo.org, rientjes@google.com,
        roman.gushchin@linux.dev, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slub: clarify kmem_cache_refill_sheaf() failure behavior
Message-ID: <abQExi4z2mhCzKPw@hyeyoo>
References: <20260312114309.213731-1-hao.li@linux.dev>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260312114309.213731-1-hao.li@linux.dev>
X-ClientProxiedBy: SE2P216CA0054.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:115::19) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|DS3PR10MB997700:EE_
X-MS-Office365-Filtering-Correlation-Id: 301e57ea-bca0-4afc-4828-08de80fd2708
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|18002099003|22082099003|56012099003|7053199007;
X-Microsoft-Antispam-Message-Info:
	WTcCpjIuSCxow3CEVDMVjnjgqcHK+s8NKeYIgP1H65w9shCj+FF9juDHpkulC0ILvp14Z3Yk8fTZFQPn4faC270ZwuZRSThVY7x94ila546zAocKa0Zi63pflc9hzAxKC7O64Q7qMzttguDHVEMRuMJqZVSFu+ksMPDU15U2arTFWLMpI3E1aFc1nPnl5up1jM8QOV63nQAQNDQJXDsFGfEwuTfgUD/3LQpOKoHKF9I3xyf4YQ4o85ClysLOF7kmn4JAiIY1ErukP+6LY/oGP28dXUDB1Bpp4lV45ww0DydR/uBWckRI1TzJwQEYrK7rRMgVRizepTI7FzYJ2L8a0wCmdj6PnDB2UtgsgPHN6BeVadWNGMDa59DM2y2iLZhRhgRkSSZAuNczqUsZEFPJ+pa9dEni62PmLw2nhcz5Em2laOiYZXSDYDAEEbTNvRxw+wxl7SjbEHCeXb146B5vZ0KoFGhNncdsTewZeeh/CHZTRFXQjk0oS1p6EqLehkNK64QlRqK+NLnL4vpB1eMPJrZ+tGPgtHHnnko2KXVlEtDcOvj4QauyxV3/VToV2nX3ykxgWvDGbn1I4k6dX50Y8NgjxSvVxsIWbs5x2exIe1jnjHGOo8Ix0t5Scjw4RF0o7FNFOVdhKdGmmTedEd2tnX/Ar5uFfxBqQwLjy0Jl1q1NVp9xCK6GjA9Ch466DBfiQMIo9OQJaA87KY7fADqMCBDwAGKCUEUZlu+et4HASw0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(18002099003)(22082099003)(56012099003)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xrwdjK8gj8IakR3nJTi/h3lqydFIQVzGDMDhsElr8f+mHzKOKYaTozl6ql8l?=
 =?us-ascii?Q?mSEVFe4YVuWlHFzl1JqriWg5Or5+uIUpu/3410/2IikRLO4P3QMWaiuU5M+E?=
 =?us-ascii?Q?FRJRVsJkG6WOccYFmfTvKK/S2fvubV+ZA9+cqLbHMkdbbRq6c9hksjNJrJd1?=
 =?us-ascii?Q?Ti84cWL6tpgVm8r48cF01j6UAbMM0Y5W5MakgXaA1FAIwzkiVSNy+HmIzQbt?=
 =?us-ascii?Q?F+MKOpQ8PGR2OylFCsrT2Axuuh1K7EAjT1lhugWroxrELKOfMyPGXEYvL4WB?=
 =?us-ascii?Q?rEpolMyLycpEnnijO2tyJQua7FDAMkth7PDFqaYUoJgkfdGDP6JSuXCsp1pv?=
 =?us-ascii?Q?9zpk90YOWbFD4s2+/znqZ3XddZUEen17idsS7pISYaPA/0Xlvw4W4S8vgwIe?=
 =?us-ascii?Q?ztLVp0br1D5BUwHkuEOV9SO5NRzzrD4W31t55pgDOsEm5mqHQu92AjH9RpB4?=
 =?us-ascii?Q?gTlg99gIi7hQt+HgooAbUGUS98nil30Afu4gzk10kF+SsOoZiHD6uKyv13eu?=
 =?us-ascii?Q?F8dK2I157kYvy2Plb4mvxKKDFhDKzmuLMZKr3atSAMJCuhiXCorF7wJHAAhb?=
 =?us-ascii?Q?HFj3co3reMW+UYyvcrsgOV79a5DHMcWdsIN33KiXgV4lsihwjfSyBGH6beWn?=
 =?us-ascii?Q?GWo5GVkCKu4NUiSO12dVKktFAQpBZYepuUqVZiAMATtTkcWNUV59l3pNhgDp?=
 =?us-ascii?Q?Y1ux74tAlU+eE6Ezjf8x2z/IfSnIymktFk2FoIp/58rmDei8Ztfui/J48gxL?=
 =?us-ascii?Q?Jk1U5XMr18QhoP4tF7sm8wHEktUTG5wxrFzEgvkEguQgDzoRRc/YO8WghB8r?=
 =?us-ascii?Q?h3zi0LYG7PiWIo8jYeovLfgafrS6TTvKaFi+T4kfUnohs0iEjEV+eb2EFEWf?=
 =?us-ascii?Q?Q/ajgVn2cQhguE0u+BktOcn3L6NmU5/0FaAh8KiRm5h+0vrdLeHmvwk70TlB?=
 =?us-ascii?Q?+KhlLk094fiDMnyLnUDe5CC3PlS4T+rvkvZhCfREUzuRBrXGWNiZ8tRaPaLz?=
 =?us-ascii?Q?6D8ILkhjtAFhzrwRaMZB5a5F6VJYqXod+17itW8lMMD12aIQZ6EfZH16g75a?=
 =?us-ascii?Q?KcvnOZvhmoSknruRIarpwTqpRKaTmxpiQbiBP3r/5vdOGLyl+vfU1GDSK0Cy?=
 =?us-ascii?Q?r6AQnqS86ym7QVLWmdITmltwOVdsB4jBtQooMh3uhaAhoq9vx0lS/oFp3uyt?=
 =?us-ascii?Q?T3kVjyWV/2wYSXvtLbwHek1Rm49eiVzSPbgg6aADTEr+Lyn9EAPANqJEIAnn?=
 =?us-ascii?Q?j59X5+lJn48YtWPRLNI5aL0p+BUNeHjwcTAx4pgdUaimYjK3lIR4EvKI42lp?=
 =?us-ascii?Q?/mYuLoBPjkMHMRi2IFdWiQSfWTYgUfeAVxrHipPbhOPJubssujZbqtkhHrxl?=
 =?us-ascii?Q?yCWTBjFGuWHbry0Kk0my/O/gzqFHdS+zXGpDc8txfPbMnOjCkuCKdkQ4/o4k?=
 =?us-ascii?Q?Vhg51B4c4jqilr+mKqbCqkprfFs8sPrpqV7MqiMrTNDj139jK36fepn9fcTg?=
 =?us-ascii?Q?I36FYcrskYCCNsxdDSZY73uKYYNYTy/YkPvkY4oYvrULK4MCHWrbLve8CvCx?=
 =?us-ascii?Q?2nfirNcTKBWFV3tB2B7P9q0jrKmtiAgLcow2VlXLLnKSTJCRLxfO0yh0ExGM?=
 =?us-ascii?Q?EZHZpa8AHfhyeV8x9c6nBA4AEM4MHXmjVBe3eg1pgT3HxdB7ydBDAhtNtA0r?=
 =?us-ascii?Q?1ckIK5fPtnatBTmt9QjLLXTbYlCifLnCKxrqWuXJW5PZVRRQvotX6EHDZdQ4?=
 =?us-ascii?Q?McSrZXCz5Q=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	fT+Ie77OdKAAv3z1dyonhH/kyzvPuUGFtBs8RdwuhfZyEcKYJ/USdckRi2PDmea4vxDNZTLuu400sIfI/TvDuDji0vhzIDSnFBXG8qUl49FnIJt3SG5K7LnWhN0PnVg98DZkwcISbkMta98csWS3Hm6/Wmowbs7L2/M4wFZnGiZaKzqckysUEZ0yU5yAFi5VHqVyIBNXdtrBQCDhhH+XJyGJdu89EXIfWEXKvUrK0D0lc+lVkxtcmaw+nw/cdCBuiTrQH7SKIqMP7KCto2f5rFlDwTwI8cEFOyKeeEL9C7vFLNZMbEArqTcbu1qAJo+U1XLE4Z9WnB0lUTksVMTy2A==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Dz2uURJDdC8Mp6YQM3RD21wiCx0JqIdT3CUM8ojjlBZ9HUUJU0aftkDa9wVZ/ByFOFI6W5ddPzrGVQk7SZMONIGMe9v52+9kER43khohHGijoMq/QV2y78JASLbArwFJw5neufzJBlCZyGuhjSj+W2s8U+woe6WQTNGHHdUNEvkVLwPVUn8kc8RzQngmuglkotyWpPdDtWn4OowJn/VvZp2IiqQTuhW9Cmw/zy6w8kvlMLkTSWzROhMYTf/hsS5Iaz5b4nwj6Q7NorPwNVVbI4D6Tx3vT1kXFgA2antDn1h4z+IejuPPvsNIVF+wJuGxo3lXZcntEczjg42k+8arW0WIUv+ByZTYYT+YeE+fylYYr3cDX5O3ZV3pAZDNmoDYJdTG/KpXIGEYzM39gkjZIzqcpR3pXlebHpPESUdsBZOJdQyiFyXLvivaaPNAxFEnxqhBV22WZfzomCEAvTd7TxpmhOsNXZLwcDU6lRE7PT/q1kY8kYdKXJ1bNY7Rui903OPRDMZ+yRQDy4yk6MlstSXAbGHT819tdHvwXNIgHOEroAAauIJym74Ft2Aso36luLlkGw4GaXAhPDgh7M1fNvM5xMXE2Iw/83Fp7Mtq/9Q=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 301e57ea-bca0-4afc-4828-08de80fd2708
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2026 12:36:30.7082
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Psk7LRBb3LTjz6K/fYrLBO6oxFVI1BtF842EWrJxG8bzd4geN514kTUSnP9X+9fyyN6YCloCRzUnUXKT/31+rw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS3PR10MB997700
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-13_02,2026-03-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 mlxlogscore=999 adultscore=0 mlxscore=0 suspectscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2603050001 definitions=main-2603130099
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEzMDA5OSBTYWx0ZWRfXxkL8NlCGmVzO
 bHGZF8CTwmpYvwbPblg8DBHyoiJOaqsSVl7yEzdTI5jNbBDsk/+EMRFKCxRQKpvf18/EGMxI1F/
 eRfx0G1XyeKm2IdKAWMCWBrhmnozHm1xsBJb3J9gfhP283ZR1bmxlQh0bY+YkHJpxuTxwNhugc1
 908PSKLSRR1Sx8Xm+aN5qpm5WTy6Zr8kECKN28XaCugGA/OPONAAHQxRJn8pOpJ9+YgyB2XuYUv
 EsVeZbgym2QsUCRlY5tenwIcOS59kthOHl+NdBp9qaRfcYYCFpxoXLPnWLPgySeN0rkA7o+UZFa
 abdXDYBuq72srN45BcZdFTi5U6y81EPXFAjdGr/XXzKCkVGtH7mVBkdnLJfIowNERKdRn/cCcSn
 fVnbPMwfVK3OVVbMZXpbyRlVrbf2jX/kfIOma+IUstTbChwGhsoI1LtZ1IBdBsgC90M9tNgw9v0
 xPogjFGWcOYQrjxOmHEWSTD06sIc27ZzAnPFz5Yo=
X-Proofpoint-GUID: DoQ1Dq8aGPF8KPykAieCYVmGtFTDgUiQ
X-Proofpoint-ORIG-GUID: DoQ1Dq8aGPF8KPykAieCYVmGtFTDgUiQ
X-Authority-Analysis: v=2.4 cv=Ob2VzxTY c=1 sm=1 tr=0 ts=69b404d2 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=HXwCAZRjpOx8DXHGftkA:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13824
X-Rspamd-Queue-Id: B05A01C000B
X-Stat-Signature: ekdwzraep39i3xho13hx1uqcm1omejcr
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773405398-496767
X-HE-Meta: U2FsdGVkX19RfWVpgjwDDRTP464bpO1uwSw5UkTgQxC6A8eFb9gG4yMyqh75ayU+GfDk3wYW9FqVK5cEoFBjC6FL2y+qV+dokdsJkdTRujw7bh1pU12upoINinkZPsMibPzv/F4GzZISaHeh82ldVJMu4x7/SSUU1cz1ExXH38R3a5Mjc97ksvU0C3+Biogwgh4J4ktvEMJ1uykQ3iHF1BgkU6xRyqySFFqjMSyRDJYhw3JmtR5j1liOnh7z8VfhQjFQTRYYwf/1/cnm0TQuHWdI49OOIeOps+4rgnX7feTcnG2F9LBvPBRIRQPW6/sHs0x/KhXKPm2Ug6wpn94i07mo0S+woJ3sSN8gdSXuCBgw9l8pfkRkgxGYnhh7iP0UaJ3PMvJO4oSbzL5Zs6F8FsN8dp8nAtpcb619m9l0Sl8LQmGgVQwd6YLy0vsuEVhMliqJZr/5VKaF9gxUCwfucbcitgswtz/GSwK5Jx2LkskT4ehQ7+IGMn+My2l79Mo9B89jay5gRloyvIMt4hSJtAJBo2bOPAEwmiTanuXpF0dBywvBOty5ASYuTESyoSiz/GNrn+Hu7ynKlG8La/QuQu/nYty2ko8XW0qpmULqsfxv1Se4agEf4AelT8A8Z+R3JqcDtJ1u0hp16a/FXsNVn3OhwM0TxYM7sz5bstL+W1KlWwgG9Zfv2dRVtSI1qlBidWuE1VCI1ifcMAlMeIGluzLGvJuu4WhkWCpul00+oowblL6MHXrQwl5ErPYhwSyAwwF218nkNOsU2atrzJ5B/1rFai0KAM1qzTDRyU9Bfwql2hJZBEkoXqDEO+Zu+1LlpD9OlMuzalMPv/o8gMJisNneRv1Zxxgy4bvaGtYmozhWo+B9/kg5p8sRGUeCgrSiIWSNFDKcqtAwH7dLNuwiZCyLinYLi4tGA7Kvrg8chmllBYUNJufZyp3E0QPmpr5UEyju+RgrxGCb5t68ZhM
 LhcjOItt
 qjT/5zBTI5j1m/r2HaLbJFur/krX8nUBpDEhCAqmiPA2DwQ4SpJrDjxf9no/P6NTApK5nUwNMNkVYu/EP+5OvqEL5BdMzAnEYTC/BYKI3OZdXBk+Z7Tiu63v5ij0AM3A7b90PFmbxYcBuZ5DN1yi+O7sI8nATs2JQ/aIphKT247xAGlDIHL56QMx9oYRuoXAH5i5u0WxfxlynJ9/7j7wBGXa+boFoSAy+m5xWoGYgEt10bgYxMOHkb9aO4IBgsBTWPZ4Jq+Eln1SLVKx6No0y2tGBxpmdSlTKqzmg8X0ZtakZ0+SqwQ8HWflqFedaSZ5G1mCqsCVf37KkT0OsRaeQOXaiYQuYUxCF9/IcrVc7IkKR4wW4MUV3K6mTUfwAyM24IVSM4KwifWE9yi8OajD5jjhoKXC1WQOdSd3PSxMZVoroKC8FsG56OMNU0fUksicDcw9me/UvzHmZlJ4wX2HmsseD0eEgywG3j8w3KSUF2Le+dupXnbfSPAodpyiwwkREZQppHBkLTHZM6smkFio35tVsDj7gxJCELXDsJFMe1DuNqC4jaEzW4hVWx88WFkuC6xB5rje+NUD2t2LeiRhS0f7WG8GWMdq2Qg6+j4+elH3rR7oWkxG8CNT8dp0I9hgzYbEtSLzq7lfHHh2ZumCUKkP6iZrdiy9iQ3uBpe7OJ1svZbh/QWaU12RvgeCOehQGnCfYyKf7fjLVNUU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 12, 2026 at 07:42:25PM +0800, Hao Li wrote:
> kmem_cache_refill_sheaf() can fail in two slightly different ways.
> During an in-place refill, some objects may already have been added
> before the function returns -ENOMEM. On the other hand, if allocation of
> a larger replacement sheaf fails, the original sheaf remains unchanged.
> 
> Update the comment to spell out both cases explicitly for clarity.
> 
> Signed-off-by: Hao Li <hao.li@linux.dev>
> ---
>
>  mm/slub.c | 21 +++++++++++++++------
>  1 file changed, 15 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 11a99bd06ac7..8ae248b5b384 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -5005,14 +5005,23 @@ void kmem_cache_return_sheaf(struct kmem_cache *s, gfp_t gfp,
>  }
>  
>  /*
> - * refill a sheaf previously returned by kmem_cache_prefill_sheaf to at least
> - * the given size
> + * Refill a sheaf previously returned by kmem_cache_prefill_sheaf to at least
> + * the given size.
>   *
> - * the sheaf might be replaced by a new one when requesting more than
> - * s->sheaf_capacity objects if such replacement is necessary, but the refill
> - * fails (returning -ENOMEM), the existing sheaf is left intact
> + * On success, the sheaf will contain at least @size objects.
>   *
> - * In practice we always refill to full sheaf's capacity.
> + * On failure, there are two cases:
> + *
> + *     1. If the requested size fits within the current sheaf's capacity, the
> + *     refill is done in place. In that case, a failed refill may still fill
> + *     some additional objects into the existing sheaf before returning -ENOMEM.
> + *
> + *     2. If the requested size exceeds the current sheaf's capacity, a new
> + *     larger sheaf may be allocated to replace the original one. In that case,
> + *     if allocation of the replacement sheaf fails, the original sheaf is left
> + *     unchanged.

This is correct, but users of this API probably don't need to know the
implementation in detail.

I think it's fine to simply say the sheaf may have additional objects even
on failure?

> + *
> + * In practice we usually refill to the sheaf's full capacity.
>   */
>  int kmem_cache_refill_sheaf(struct kmem_cache *s, gfp_t gfp,
>  			    struct slab_sheaf **sheafp, unsigned int size)
> -- 
> 2.50.1
> 

-- 
Cheers,
Harry / Hyeonggon

