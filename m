Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44D19EE2084
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 10:21:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55D376B0005; Fri,  6 Feb 2026 05:21:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 534C76B0092; Fri,  6 Feb 2026 05:21:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E3736B0093; Fri,  6 Feb 2026 05:21:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2AC8F6B0005
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 05:21:47 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AFB7713BAC7
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 10:21:46 +0000 (UTC)
X-FDA: 84413640612.04.CC345B2
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1CC9818000B
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 10:21:42 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=nyYaOJTo;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="gMOA/3bC";
	spf=pass (imf06.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770373303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b4FDjJNHiZLnbeZiI+aEpka/3b1Fh91xvPHmj0I/Bqs=;
	b=4TnZzwMfv5VRhuBNCP4hHZhIlVEjueyibEq1vnzd7g80eWQDNQLYBLUn/fvez94ZMDm0GE
	+nmVJlUzer40QC6UM1NDuruk9GCz2Zs6mSu4gFG18NWqTpnieYjwm28gTwBOCkM0uXj14B
	QLXOpB9X7BFi8bZyR+h2DoPCTPHf0UQ=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=nyYaOJTo;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="gMOA/3bC";
	spf=pass (imf06.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770373303; a=rsa-sha256;
	cv=pass;
	b=srVNhrQ6ONSMsJMXBQ2Xl/EgwvN2SRa0T0R/7ITAIerfd50wI7pybVqR22OYMWvIrOmBSo
	hu5+AqiZ3c1Q2bbv96GvyDTzMepQKACEkhe2jMRwjvaaU8tG74P1+ei9vQFH2g18Tj+D4n
	fNWfzfUl824dA7mFYnh8lPRW3Ll7ogU=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 615IPimw1179782;
	Fri, 6 Feb 2026 10:21:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=b4FDjJNHiZLnbeZiI+
	aEpka/3b1Fh91xvPHmj0I/Bqs=; b=nyYaOJToptYRX0t2d52MAAVXaLQ+BMvfA4
	5yIw6YMlyGI+v0/a6kVEykI7G+IE92VoY9O4zs7Sk/G7CpbT+XCXQJLYT5QSapag
	KOHhYGZjuTL4lhUEK9mqaqEmvdzSYEy6eaRHKXrvPUK1wqM2Zv2h0aAftfQwiqMU
	Fvs6CT2yOtpRLkABU7ClUOTUnmsG7eh2UlD0Rb8RosAz/w40PXGlOC0qVuc95sZ8
	vw+m6UofFbrhbRGw0A0KEIb26YNWktHgoWTkxTbxInTJS/P+6oCPVwPZlM8A2Fnc
	L1rvvvc8TDTO01YTJ25uFtWQYF/l7y362eCCi8m2Yq3ClyyBU8FQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c50fmgy1p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 06 Feb 2026 10:21:39 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 616ADOrG040160;
	Fri, 6 Feb 2026 10:21:38 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010001.outbound.protection.outlook.com [52.101.61.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4c55gbyfej-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 06 Feb 2026 10:21:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ic3FSaha+qwu97FTBsvw93AoPDIQqMgE4N/PE6wjq2udoOQ416V16TFou9aKBvgSX7v3P/c99BfrCDAZlNucCCyQSuI8F9CFbZaG6zuipdoDDc8S/xsNY3qeP4Tav5gjLEXJx1RLWedxtPsW68x4N6y5jWcQ6B6KY9t37Mx2PwzveiLQG1AJO388X1Z4/HA7FYom5GyXtpkw2PYZQdKFIFbo7JCuuxKImTmBe/Zb0WyQYdnr9Ar5xIH1DQCErzde3Hr07vV1aE+1/LecYDrAJt6sVRJa/6Z7sDZ/IeoIz7CBrYeGJKLY294BY85+D+XcsRL2xKabp8PgDMhB3XAgVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b4FDjJNHiZLnbeZiI+aEpka/3b1Fh91xvPHmj0I/Bqs=;
 b=qJ8JXaDV7GH1Dx9ukvf6Z7wqLgcB3gOIjnwolpLN4YwECgA1CtYcOvbBXMN6s9DOKIMuq/i7/lk9Qrfct0gzReWhrhc/jW7Be9Vjky7ZQphLem9uyYeuKcmBDQgsoQzMSRoaf3pwdytA4GpZkJCljXJDGOY4jH+iB5pNRDZFIpt49X3Jl7EEPVPyyqbBVDREqd4jjGuk3fORcWpXMmnNXPmni9Q5HYxwxfwJV8oCsIBuOBWRs4YqB7+1s1Bh+V9FR6uwS1EjXo+7yji2WTULtnNOc/kSJpHS4JRjkUZRHcGjYUaAn1GD18nc5gVThdYLsdHBC75utnS6LrMRItVoNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b4FDjJNHiZLnbeZiI+aEpka/3b1Fh91xvPHmj0I/Bqs=;
 b=gMOA/3bCKRUikZEnv4GJmM12nWyUwl7joX63t9ZxV/rhpjjMIAUhowedXlmtoSk3A7blPqPHQKsBZOwB7kh0XAlCPsEt26iVGxF565wk7P50u+tDd6NN9/lbNHIIK+4Ftzsn/NsMUZnV2bGDFqdxxoMHFUdF9UIYYCaAjMid52k=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by SJ5PPF842B33876.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::7b1) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.15; Fri, 6 Feb
 2026 10:21:36 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9587.013; Fri, 6 Feb 2026
 10:21:35 +0000
Date: Fri, 6 Feb 2026 19:21:29 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Hao Li <hao.li@linux.dev>, akpm@linux-foundation.org, cl@gentwo.org,
        rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slub: let need_slab_obj_exts() return false if
 SLAB_NO_OBJ_EXT is set
Message-ID: <aYXAqQFGfru8aC6M@hyeyoo>
References: <20260205120709.425719-1-hao.li@linux.dev>
 <aYU7l6P2ikKvnrWT@hyeyoo>
 <67ebb9f2-b383-4b68-949e-239d8c7b18f0@suse.cz>
 <aYW732VZACRIzr-r@hyeyoo>
 <e924ce7e-29c8-4853-b1c2-3495b8cf8427@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e924ce7e-29c8-4853-b1c2-3495b8cf8427@suse.cz>
X-ClientProxiedBy: SEWP216CA0150.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2be::15) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|SJ5PPF842B33876:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ea6751f-4887-4efb-6233-08de656981a5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?rF0/xA/N5IzlDaaydzyZ/VzXP0iyTChyUzdWU6JRXSvdd1cTOX6WKQGalcCW?=
 =?us-ascii?Q?da3umVPks0oLp9VGknuEoEbslwmsAqbuxA0+LQbUfbRC0e/LgxjCAiNRY2vh?=
 =?us-ascii?Q?lRSNLvlcb8r1KaIHCVdeaRtm+w23ySODOleO2qZZ5wkHxjwDiVmFKvT+WXoy?=
 =?us-ascii?Q?vTY2QK5y1LSuK7Nq+47n3DX50AFrSOr1j4qF9NfytDGxwN0zXkDh/adIKynk?=
 =?us-ascii?Q?h8UL93KxDptsBWE8C0A1D83U3v6R5FxXKa5EoV+VU5IKiFJZ/adb4KTCAjGE?=
 =?us-ascii?Q?uXc7f49r4rhMk130tY/ge0DPJBnferYJe6Dh1kzkRPtwEPjF2yWGtURmCxCu?=
 =?us-ascii?Q?HFHISJToXz4CIy/xCbSArEPw47NBbb6E0KKVUYUCc6ZAJCzfx7IizHHFYf9q?=
 =?us-ascii?Q?3kH+15zu7EjPKsZPDZ6XM7GzMaD/rKiWiU+dc5HvoOxYzEAHovyvBvw5ZlnB?=
 =?us-ascii?Q?pSNeyCp9fAEXoXQW9Yd05M/gQ9+Xkx7vEVnT3msuqZzZBmhxqst4egFXZp9U?=
 =?us-ascii?Q?vdmFaSmXUs7PMzlE+FsgvYFDht88a+20V9bc3LWvNXRevMJFIZ3eRTaRhAuz?=
 =?us-ascii?Q?9Ean6wSvIc4eD4Kp3Q33ybEya3i7hoIlRTQaw/GaQ+eGPVztRs/Ynhcu45XQ?=
 =?us-ascii?Q?KRWC3lcT2tTIjA+ZDyK6dWTB/3XoccesQ1/WfCrLToYe2oIXUxxgVizb6hpK?=
 =?us-ascii?Q?/9Pf3KoYOU0QY2oLmKojsnYBunCnpoGImtCI3I80TvEexqA5tf/tefpSg1oi?=
 =?us-ascii?Q?S9dqkEk9LnAdBm7PjT4HgbuXZYYnIZnL1sekkuKthhLjYXKJRQAOajtoHP7s?=
 =?us-ascii?Q?KAUnOOykWAXFurIMivQQQOF62GDNQs5sno1NbEZ3/rthI4HQNh4SmTlDCY/O?=
 =?us-ascii?Q?ut+UDuhahhKkm/2mR+tTPU4lw35knBdwP0mbIoDg4W5F9YHosE2lO+uKTjuf?=
 =?us-ascii?Q?u1yOCgeGQzCdS55vF4HUugQzY6TGM/ezvKLeetwI/52w+O7/Qsh6vt4u7K82?=
 =?us-ascii?Q?3oBxO5LWePH3tGxMJ3QQtBpCkwGBplz3R86xNAVb1xtJm47yqsLmT/6uVog6?=
 =?us-ascii?Q?TGGLFAQkqkZhoKGGklr2uNhih76SpA4Ub8Pt+AnLHoF/fnC2WDtm+Qzb0u41?=
 =?us-ascii?Q?cTrPR6+hE7zsHnowEn1IizBwPtf3iGvEtkm4akbwUQGVMKZyDLpqO3SQAgxP?=
 =?us-ascii?Q?cUfNestgrrCNzrGp7nu+XPOKrwAivxuj/BN4ER6Z+rd0fG53ICj89ez2rc0S?=
 =?us-ascii?Q?dsiuWDZkEMQvbvJN8G6UUBqyByGD+4/4MrvSgOYY9/QHZOVLw1YbOTXvz4nM?=
 =?us-ascii?Q?jK+pkWlhUbVqgamlFgYLrN4FvaZC0P4RkHstNCz/+FLzo5EBArExjii/k/PB?=
 =?us-ascii?Q?odlmYQfk7glscRuIvHglT1S028Njy1at9GjIubqmxWGszASMfIyg9/oQaDWk?=
 =?us-ascii?Q?6EmcWWWN2RAO6M1xpRETQDVaz+Bk9L/we3fRvvTHkz6KC9KXRfNZyapP2Yh0?=
 =?us-ascii?Q?h6NCLtaluNJ7Zios0Byj8AqCrANpj8F5iWz4Fc/TxNeing04PE1C9aMKlP5s?=
 =?us-ascii?Q?hj/VfrZwx/aiV4+wqbs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BC011K8Si/Bl6D/w4PoLM908wsLq1Ne3VTbushhjdw/1CRFzcEYaZNIsvu0q?=
 =?us-ascii?Q?uVUV99+QfL8ccdNETiwy4o8IClnyPI6hLclxdjuGgmwRn+4o0AUeqkW0H/4X?=
 =?us-ascii?Q?YO+j0+pUodVJvwnQv/gn28ph7D5FjoFExUrdAGXLdV6iSxzta1QNjc7Dnxqv?=
 =?us-ascii?Q?aBvZHxwWbCHdTPSPpYxmbX00rhPkf3hcl6c7mAZhG71Eo0u9VO97Fd31qOx3?=
 =?us-ascii?Q?RLW83Vn4KzLwZgWjU/TpDwIfYUW3RA/rlbtUV5d0wE5OOFiuXCFlUwBQhuqF?=
 =?us-ascii?Q?lXiKgrkOJPMVEOXGL73kBe2s0dZuRNKf6hIHgXvOBMel7gmMxegrFbqc5hhA?=
 =?us-ascii?Q?cnkwNCa/UxAjYSGSBDKY8O3jl28MATBOEJ4jOLFh8ZKNeH0V/SlCUVbvZ6SJ?=
 =?us-ascii?Q?hV8EOiMFCufM4h6k4tz4PYh60+eQv8Fq5KVBsmdUSVlQ9cj5BLBbO4UNkh8c?=
 =?us-ascii?Q?rKve4gM0FSkP27x07cm/NhbGzoO0CWnQRGMa7elSr7nUWct7Sx1GhlcXn9su?=
 =?us-ascii?Q?zIhgxQ4QvxthD7T0kCaPOQTS4KzpIc7ybDxvgusCPkF7alQEfMXeBUG6qeYb?=
 =?us-ascii?Q?cUbztcwG+ftw3mVGymwNf7t/UXHXXm50fd2FrI42UWxDXQATJMhxBawyV4nK?=
 =?us-ascii?Q?YDRPYxitF0goWzFzXbcT7KEqwIqy1TcC9d6jw12cBPDSoAD+yh0dAMA5jIeE?=
 =?us-ascii?Q?aFfIU+vuWqSwG298th7PpvWAs+7wAHs2D0DnP2ficnOMCMfxYEsRmANFB05b?=
 =?us-ascii?Q?NQVpejmriN2fR2jrW3YNdxuRzXrlHWUEsNGy3G+8TJMhP69hJH+Ct+jPCj0Z?=
 =?us-ascii?Q?an94gdZ6JyuJ18X6jYXwedT+/kUTy/rIKH/evo09QZA6hPHHIsoWLjgiL4OM?=
 =?us-ascii?Q?naFSd9OTU61RwVQe8eR6//qCJ7KMn0q7xHTaOrmUAINtIokzV5rnTCTj5Ukv?=
 =?us-ascii?Q?7mEYTictrFQhIbLB/hwb+r/qiExhv7MDfSGYoRAqf027kU6qtN8TdSvTFAvL?=
 =?us-ascii?Q?Wmi2ZJxEGIz/h8I+D9Ucwi9q8TRMDAen8JOPWEgVZX57jZRbF8gIPCTAEG6I?=
 =?us-ascii?Q?4d6/TXyHhABiojS1+pspg4ItQoIoFDW0JP6+Smpp8ie14mGhEGFziR0b7f3O?=
 =?us-ascii?Q?eeT1bLa0EOh1EWqn0kGOrsxC+udqLIm8qcWSpvwINL5osb+gHL4WfApAnAa7?=
 =?us-ascii?Q?rc4me7a7P9HXOggB1Kh3zrxLeAcKitbzEO+q0bx37K2eI6zWoRo1Xz1xuqSC?=
 =?us-ascii?Q?ZIz6CfuF//ZGBF2XNkBRSj8lnTl+9ZFLFgW/zdldWNAHZvMEc7oUU4Rx8Ylg?=
 =?us-ascii?Q?scoOkPzKnK6ZUl+qJkRf6oHxh9LOcjjAi/iMBphAiWvBKcDVfsea1qMTGLLn?=
 =?us-ascii?Q?QOBDXaCVLoX0iw7nVH2HvOac9rlav9rxNj/uUTrRwZFB0zl/Gk3f2fvCxkJz?=
 =?us-ascii?Q?+k7C9gNjRB7ydfPCvDX3v+U73ehF0vQeAEpWBv/LDbtoGF1m0I2i/hUIUK2Z?=
 =?us-ascii?Q?AZE1V0UhPvUZtZ+JkVU9EWomX5j6dDaaMCOBoytNHoDxfPXpPBtJYcoku/Fn?=
 =?us-ascii?Q?FXG9bBKYLN/hUdfGswGLT6UMfB1+NjZvF5UzZ+lGB0MRE/IEHvqpRA6vWAnO?=
 =?us-ascii?Q?8/ZEf75cO8etrIxOstvTM0eU+1MY5HMBd6npJAumh+MaJnLA5bkPVmJ79QCI?=
 =?us-ascii?Q?rqQ4YY+hTkm1IcspNMLD0DyyOi/JkNcrqoFucbhM0NZkDKy5/DDZ6gGY8/ZU?=
 =?us-ascii?Q?VoNBawQXJw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	4Nk8fne5lUeMJh0zCAX2VsYfNtPzv4EpvRKuvL/I0hLf1zUyoEVY2KXFDmVABsBu+ghGownHnmeuivXwlkE4Mw4AJ9rjEPS8IPV0UdFkMoOvpfrIaG5b8aXmmCt4BwqY5mSncrUm5X9yoQZXm+sF1woW8u1VkPyLzq9Vnoc3HD1abi0SiM4CZbUpWhPCWHgLxwUYFeFgy7Gb3LCRMqV3C5pyTUE3FfJpqVVtoQNVR+07Ye3PVUu5+/d+ndqdOeL8xCiq5LbB5W0Ydxz7kQYUOCZ5rxEAcWqBUcV65Vz7EIkBnzrN11PCWO7pXJFpqVSAF8ipRLT9vqeZbc9g3v3JdclIQW/2OARJmPdg/EfebZmPRzQmQLoNVI06RoU1b2JHQYsKfueHouqAsY1PdJcxw0sHtn/8sSBLeXZNwTRA7PeMLnlxtPONi3oXhO7f5k0XQAaV7IqENodo8ePVtH1VI6qVRES5G0e+2ME2OcR+djJyCY5IiNwH6ausiTmjJXkXllffBCEoIAVKObZhqdDyLQdRzDGTuHlr1FUKdcUFIt8nJXdl9vdPhjWwPZsr7vxKFPEd7Qc+yrhSNl6X/gM1cRsSbzhoPBzdIN+QCR4EnUU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ea6751f-4887-4efb-6233-08de656981a5
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2026 10:21:35.8053
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8E9iGeLC8GTpzZxk+KL9yHnT/sKlVbhIvflrourOu74rgq8Xk4GldLikBvlMI2kWm/RWLfV2q36yFyjXd52k4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF842B33876
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-06_03,2026-02-05_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 phishscore=0
 malwarescore=0 adultscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2602060070
X-Proofpoint-ORIG-GUID: 6etnNLSTrkEpvqsPutik8YzO79E_vYbl
X-Proofpoint-GUID: 6etnNLSTrkEpvqsPutik8YzO79E_vYbl
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA2MDA2OSBTYWx0ZWRfX884Z/qfMqeIx
 zXOikdlOKGdUoKvbG/hwaHSq3wMn2VQof+1GYdN/3YdKIJ4/TZCdHY3LtjGsMkfl4NGbEGesBkR
 6lwNTtsDvDvvhE1WsIgressxNMq8dlqu1tfibzz69YZXktv+ouhrKA2iXcSHTNV51CSm5TcruMv
 pyKNFhRIH2EQgJzJHikvPEKhssXiU1QZpln99T0wNUc3i/y/Lv/LczWsqF94AvtAu+7KYVgoqBW
 Kfnk/FdCX87IAaBpQ14hOEUrqF0gua6ugNM9w8Gn2ZnTxl5jg8wqe9qg/nwZyymSpmq/mQiQRHQ
 SClzCi3qQjUPx6jKzYzKCkO7FWUWJEQr8oUEEijqjMRj5qjUTm1Fg4KHy6+w/kgvUezevw+uJHM
 vCxIkvvEMi2ge1l/kSndMF2AW7DUDE57va3441Et0PnK1PC6G5tK955hFWqTCyHoKAwqqbXm5or
 MmMtQipOOcz6wqA3AKA==
X-Authority-Analysis: v=2.4 cv=BcbVE7t2 c=1 sm=1 tr=0 ts=6985c0b3 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=yPCof4ZbAAAA:8
 a=SoE7BwcI0NR0u3kAfogA:9 a=CjuIK1q_8ugA:10
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1CC9818000B
X-Stat-Signature: 63zg1nebw4pbu4apn8dmjm13u6tbh6xc
X-Rspam-User: 
X-HE-Tag: 1770373302-49071
X-HE-Meta: U2FsdGVkX192Ff41f7OgC9My0kaQeZPNNttspDPQ4YBhcKrih7WYs73OaVBZteKRXB9eUSluHKI+bXV5m5azH7+nG60vAh3TtOXLeuAsCWZ3dD46ikpTEgNWMgf1DBZ6UXcoBVYDoJyA17PIO++zvSYXU8akjUtIIjXb757X7mrwabM0xPiYEGPH9rpmxKPk70C0x9nVDZSSIzTn8dNKcg3Bc331aiv9W8XhenK6cklLJUP4xLBP2tBPTdAoS1Cith2AGF7apUWzriQ6w+6iegH4hyfHGSHQekpZBezrGF/hMKiCAQFycVpkrQtPKCRS8yzV9+g09+zDJhn2DlEKQ07K8S1hK7+6uB/79tvC2VV2eLwTMZm4K6JJ+VgWB+YLrCFqTRRuJpV0bP4diUOYL7ViI9Q530WewXEFga2De537ByHGCU4m93gqsXZrrecZEyiQ1ucYWeNFU1lE+RUoAnVVHfH6jEbtPiqQdThW0FpAoyArFmkVyW6hd6DlPTDD44wmWefQvhhtau0xWQ03IT9rsLv087bXSaYjr/Hx7KLVjYqSReDqBg/d402JBSYNUoScHmMLYBHI1pC7WDNLd3m63EhB+H29kVvoa1p2Z+0JeyctY53DRdMQSpX9nqvwLakRPseBGV09g7+dO7g0jBW9FBn/WBXiV/7Jzli8U4wYjJA7cloakWT7RCKsufRTiADzkJTRLoQQdw6Evrc/LAYPD99IHfD3GD+3maMtWHrrpEMxt7OpIRds8GlYZai33AggBQi0wIyW7kytGIVsO12qJJZm+t4jmNZm8Uo65JO6vrGhJk5kMTwxT2Q0F2tbHslg8nka7WGe3PnitIR7rXFa1vowar46Jx0zoZLZbAd0HYHNwgt6tl4hbRCcgEuPTwEpE5X/c3eNqIkWCAGKVfUUpYDjZ0e0Q1rQV+1Bl5pZ4EMwJVBYnfdzXxhfgZaB0an9tX3acMLuvgDFLsR
 6cjKSqkk
 3NxcW+hY8B4g9WVmkrVKMHo2qe+FCe/IfbudC02kAcI0qNlP17nTKSjJ62J4W1dWwB6ULgjDFn7AbEbY42CJPiyiZReJkS4rqhgtLJ1XrIYYG1JuIbdX63KhTYQM3B2gD2reabHakkLPEKfdHsUDT/+aQWZcv/ayjD+26p7gCORWth1XVVSxO6y3eOcH3VGca2+0qudBncbk5KUfvj3xNmVZDeV/la/j/OaNFpwg9Vhppn4kL3Km9jskVsHOVXnls+Bc0pmHAwLm536xF8vN53ZA0sC4MqhV3s+85fueP8TRV47fn1sgKhiLaU83UdJRUCUecuMdlcLnUxJJglyKVW7un4elVU7nO82F4CEnsuPBNoXw6As3ce1tpG3YTWu1ey/kGBFgmZIcMBLjjXsnt940L4ySERGfAABC8sIZCv0yfZl8W1IWCEMClryl57BV95HgKrV+vMJ5XZKJ2EiwOxIgAZheW9NrRDKM6IWuNb/3HpuTyp26SczAPb4MukStlE6yy2tTLuv3v2bx3tD4VxAptVq7M0GfizDg21Ne6E5zNc7khe9v0knjf0QoYJ/4rXHI3y5+Cjwnjm9OnCOrQcFNxI/qY34xto1khWfArN4BecvnljaiOeNuT+Q9Go6vrxq9TJ+HFw3rTMXaj7HEcQQgklPiQcltbrTwGEpWVwKkee1occg9tcq3j0gHSpSrp3hty
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 06, 2026 at 11:03:08AM +0100, Vlastimil Babka wrote:
> On 2/6/26 11:01, Harry Yoo wrote:
> > On Fri, Feb 06, 2026 at 10:40:54AM +0100, Vlastimil Babka wrote:
> >> On 2/6/26 01:53, Harry Yoo wrote:
> >> > On Thu, Feb 05, 2026 at 08:07:23PM +0800, Hao Li wrote:
> >> >> SLAB_NO_OBJ_EXT is set for boot caches, but need_slab_obj_exts() doesn't
> >> >> check this flag. We should return false unconditionally when
> >> >> SLAB_NO_OBJ_EXT is set.
> >> >> 
> >> >> Signed-off-by: Hao Li <hao.li@linux.dev>
> >> >> ---
> >> > 
> >> > Looks reasonable to me,
> >> > Acked-by: Harry Yoo <harry.yoo@oracle.com>
> >> 
> >> Thanks, added to slab/for-7.0/obj_metadata
> >> I think it doesn't change anything at the moment?
> > 
> > ...unless you enable memory allocation profiling :)
> 
> If I do, would kmem_cache or kmem_cache_node caches gotten obj_exts in
> leftover space?

/me builds and tests a new kernel with mem profiling always enabled...

Yes, but only if merging is disabled.

If you disable slab merging with `slab_nomerge`, kmem_cache gets
obj_exts from SLAB_OBJ_EXTS_IN_OBJ.

When I enable debug feature slab_debug=P (and thus change s->size),
kmem_cache_node gets obj_exts from SLAB_OBJ_EXTS_IN_OBJ.

-- 
Cheers,
Harry / Hyeonggon

