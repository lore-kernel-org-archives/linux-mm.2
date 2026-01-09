Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CC25D1A623
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 13:55:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F4B56B008A; Fri,  9 Jan 2026 08:55:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8ABB36B008C; Fri,  9 Jan 2026 08:55:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 759A16B0092; Fri,  9 Jan 2026 08:55:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 606D06B008A
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 08:55:25 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 147585B7DC
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 13:55:25 +0000 (UTC)
X-FDA: 84312572610.09.108718F
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8F45820005
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 13:55:21 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=esLV0aU3;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=vlbs6v2P;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767966921; a=rsa-sha256;
	cv=pass;
	b=G4DrMNPKcxZSP2ZhOMMls+JUppNdIrIx6FYKmZ0XAKEK0PGB2uWlsOdTG3q/RvSjAatBGU
	eNkGY7Lcy9LpRAaM3lp57Df/WpzOCPpqbeYTQ81yG3msHHnGBlznd7IqA1dg5wXPgAT4CH
	ARNqFnh80e88M+j3RlDr2qozFLZ95N4=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=esLV0aU3;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=vlbs6v2P;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767966921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=THOArr0oEjNfSoK+7JjRFdNSY11WcxnpzkL6oBvw8ag=;
	b=jpcLA9Uzxiv015TIEGsXpj+SyfqrRyZuMGw9DdMI7SNlqWZobOyoT5+QPeeS0vV06kjo66
	PZH1DJHUE38DLvLHAZnO/+qdoY/WucTV/b7JPyD2EkQp7lFK6IQCRyaT3pZPY8t4Vbdwbq
	jCvF2fIrdQtaI4CCNaia7/XhjsS2i/g=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 609Cfirj2676278;
	Fri, 9 Jan 2026 13:55:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=THOArr0oEjNfSoK+7J
	jRFdNSY11WcxnpzkL6oBvw8ag=; b=esLV0aU38ijnVhP3huRhioOPiBqZSA3OeZ
	VN1sDsB76PuQistiIFaqmEHdC2jBRUMKiCQvPr+8sJjVcYGvvk9H2wUsymUGk3JF
	hbGM4ATjOUND703OrZFqfHOk0wFgj4DabZyJDC26NBvc1kyA+ju1I13oRWN/iuZW
	CIA76DLMf7aNY4hvBMOICIQizPuIq5VEH0i8bNDqaQ636JzjPK+r7nD4SI4tvAqF
	iFkcxSqU74sxlH9Hp0aIQgmXHCZSe5ESYIK4aCmnnS4dCq/Y0Kbu3S0Qw5ixFPRq
	tnjrfGsrHhcyS7CuIUN0Y0lPabAGL7W7pQxtAxYxYXmY2PMRK+DQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bk1w782vf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 09 Jan 2026 13:55:16 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 609CftHo030681;
	Fri, 9 Jan 2026 13:55:15 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011055.outbound.protection.outlook.com [52.101.62.55])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4besjge945-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 09 Jan 2026 13:55:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UhRRaDUPR8empofNyLgFpABtbnkrmX/JKvEx5e2buz9w/pFTzgz0+KTZP2b4AUyiXJIfrPRBhnBaA5gCDRuhJGtRF705+5zKeO1sD5TMrWSh4XL3sbq7klCDP/jiBjsfubbeHLbE0e1+YDBOrvzqS0AGf8PVJx4W+RqKMPaq/IDlK/unuFnhZjq5R6/kaRNtn9TEFJGNj7QiuTsJzA4PsvMzfchGj2MIi1hI0Er1T0i3XsoUAfmUckP9sV3OleoTZh1/sGklWlxbUkJlw2E9pnhCQIF4Tm+BUfdPatKQAeKZo71y7U1BToaNkAuUsgP9TRyYfpbFocygK2+rKu0n8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=THOArr0oEjNfSoK+7JjRFdNSY11WcxnpzkL6oBvw8ag=;
 b=DgJK4yB+ayjvnbSeoQ6Dnfyc/aYYDIHOEvW9N2dH0ujxlLBhVL5Cg1UACmtn66deA1L0FrHTis/U7/C1Hv69fkCH21Pob4hbzUyQ+VNpv/acfW3xKOOHWxA/FchAv6rc7ZFCKaqCvqVXFvCFz+fbsbtcx64/x6vtygqJ7eP3zS5+Ko/CDJpisTyFWQvqqkyyBjUuKl7FuD3TWMBBYnLY7PtzqY0ma45bzJ5BK8HFQXuCr58Ryc/R5Nh/SfcVCEGFr2tVEwlTijPSKfrYdvL14cU7Zq8zNTBB01LYK5JnJWyQW0NnYB8vgOOx7xTP57Og6ea6wvbAQypIfGpp+XgoGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=THOArr0oEjNfSoK+7JjRFdNSY11WcxnpzkL6oBvw8ag=;
 b=vlbs6v2PzxiPFeJJeKxUZ2sfm/V4xKNLsIOVCBN57UKs9y7kQTZ42Tw6AvW5gd6BuaqdMkkNz/rphoyNlqRbpsY1uBQPXZodjN0bU945BjpE5PS8aTIMZhxwym7Bj8O/0TNOe0dZDyw6H8eWOGBNgsiR5Nu/JOZKmQY3UQ2MFTk=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SA1PR10MB6448.namprd10.prod.outlook.com (2603:10b6:806:29e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.5; Fri, 9 Jan
 2026 13:55:12 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9499.004; Fri, 9 Jan 2026
 13:55:12 +0000
Date: Fri, 9 Jan 2026 13:55:12 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: SeongJae Park <sj@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
        David Hildenbrand <david@redhat.com>, amd-gfx@lists.freedesktop.org,
        linux-mm@kvack.org
Subject: Re: Finding mm patches to review before those are pulled into the
 mainline (was "Re: [PATCH v2] fix AMDGPU failure with periodic signal")
Message-ID: <96ae37fa-f8a3-44c2-a7ca-52c751a9e630@lucifer.local>
References: <1c758937-787a-4afa-983d-e5b89578b101@lucifer.local>
 <20260109011830.68325-1-sj@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260109011830.68325-1-sj@kernel.org>
X-ClientProxiedBy: LO4P123CA0305.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:196::22) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SA1PR10MB6448:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b44fb09-c9e0-477a-dbcb-08de4f86b55f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?j6pfXK2v49olQqAILfhuOcwixLDp01trIy2fLHrjjxMhYYYtZEaNMxmWDLYo?=
 =?us-ascii?Q?PlizP1pie6pbky1U4vjpoTNyqPEKD+IlnBmQqJJuMhx9N1XxcOp/WxCj5FHL?=
 =?us-ascii?Q?OJK0E2L+ZwRT01cOxJXrTcT3WAg5hgpfoAet5r+WU3t604AyhK0TZsGF0UXD?=
 =?us-ascii?Q?k916MrpJWapRruZbvx26QXHGGO4282VD1UY8VlwM68BhAN79Qqwvb/FxcUuD?=
 =?us-ascii?Q?uHMaFkdfgMTK1AnKG0I8RThjq1Il1VDMWpTzrtTWuY2dQet0dIgB1W6N9BTp?=
 =?us-ascii?Q?+WbYCJ1YDuoMsioigBn24n1ir/Jv1uj93OPMLLh+hiKDy3Bd6rDGu2XMJ55z?=
 =?us-ascii?Q?/F0ENdSrZG995quZRfZRRM90hTyyioPpYqxS/zsPauR1Hr+eS3Gf14aW08wZ?=
 =?us-ascii?Q?+l9lx2QDBV6mU6HLYoVjvdQ68fk22lLg7BsvyZ8azsFOjXMbVgUba8KIBsVf?=
 =?us-ascii?Q?twIinI1I3PkgbsfUV9163LITRfVR0W/1c2gneU0klxgvzkDDbXtFctYBzakA?=
 =?us-ascii?Q?KnVBP8v/QpLf1KqXA3vvZPdP+nk35Jz/61wEmpb76d1QdEsEOiDf/K/Ol9T0?=
 =?us-ascii?Q?Nw13RMkYUQmIFI8kNYwTqmCI6v5dDg1yBdEm88qHCPYA6ys2WTRJDv/Xtj6w?=
 =?us-ascii?Q?kFtfqzqw8n05afltiBKjpffmqy2V77fcsDL9fgGZHN+eo+EuIor+KeqVVxo4?=
 =?us-ascii?Q?uT3mIpAgqPIM1MnrSgD4RzsZVCETgKY5phro2RE0pmaAyu89zFR4L+wy+aYz?=
 =?us-ascii?Q?vrjgviAIIpvAhygfPwbt2kIH8NptucHnu9u240JALIMRvF21J7qyRPbi1sRN?=
 =?us-ascii?Q?QT72Y6ZM5gK9gZD/q10IaEFohTBmZ21zi4QD/ONgpAF4P8uOO8Zm/7bzhJ2a?=
 =?us-ascii?Q?nUsyGZSGxqucYOA9pFASmXnnt9Hq14UU/Y/kXfXd1Rr13VLG96dvNKQrpnpI?=
 =?us-ascii?Q?yjAgMs/zoF3FQTaj+dRg3TzwBUPZjpsVKdY0ER+ltjDGAGDyNJWy3v9Qr/Re?=
 =?us-ascii?Q?LTEzRXbMRv2AGuJk+3LLcgOjTuQvj/fOdRyQG9cLVKjfysI5TjXiYRvHqbYr?=
 =?us-ascii?Q?HaeL/BbORi4zVgBxHxmuyN2tSk8VWiQz06I+8D37MxSwsL7EUPDD8ExBUNYq?=
 =?us-ascii?Q?IV1IjrthXCpJpSCO3Zh+WbYQOkQ7nvXJEZp5/9aQJ9aXF+X38MuV7mH8mdQV?=
 =?us-ascii?Q?iL9YuVqZBdSHdyeVtw7TWVRb+3YXS4LFi4J+PtQ9TxAyjmDvkr89VNJC9OOT?=
 =?us-ascii?Q?m10qLEpvz01u+sHgioXn+OPt6gaj/IQ7l+kzi7l/gA/PM+4a7dAPLDdu9fJs?=
 =?us-ascii?Q?KOCh4agnWrKVV/0v1zjCIZvo4KJWzH5peulcbt2CvHGX7RUFufVUoSErWUiD?=
 =?us-ascii?Q?1N2nX6FNc6/aHWZMCTztkz9oe9fbkTxTkZUS8kwPP4TuboOT4a5DgOYorF+o?=
 =?us-ascii?Q?6idvQMAn0Gu8xqGx+XWeFT526UvVfEzR?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?AdW/xEfbZPX7r3uOsxQ/OVG6UGglHLOSKK/HPqNZw+qnuecAqoUYxY3427/r?=
 =?us-ascii?Q?F7XzxtRasm4QvOhCTMohgYVm8Ouc8pi6JFZUcegRqu+N4Bfqk2oLmg5RM75y?=
 =?us-ascii?Q?jfm6OACowz7q0RuXmc2HMEPVIcoiWP0dy+P3ezLDtqZDCCZUeMxPuSasAxKz?=
 =?us-ascii?Q?ZkZU6/Dx0j5J4gm8iJkWh1vmim9e69o5lVkVSHE4Z/mai71UmIexv5otpg18?=
 =?us-ascii?Q?mGCcwOS/9S8LgOMOC9yuJIfb16efxzTHo70HOjS8Z9gJGiClcS2jpKAFrlJ0?=
 =?us-ascii?Q?ekFA8dApAkJzD4Ibd37VVhImEYbRUDNaUfG6yU1SVOZD18ZP0aRIUlzrar+r?=
 =?us-ascii?Q?2g7ILaOvFyGnVyqMCwZC95qIUm5OEjkP/pcouMuATLY1VHdE6alCZCZeICCo?=
 =?us-ascii?Q?tfHT/X5nVfPBfHs40OchEXsCOm1/FVj3KTBJGfRNeNy7pKYcwWfPCUZA6WO4?=
 =?us-ascii?Q?56rL95ftManVjGQTDD915Jr6TGs71tOsow7MjLY0N30aadWtmpPiyyTUqW7J?=
 =?us-ascii?Q?LsqaqXgNVuyCBxRNccRDtm4kiXHIowrtvP4inHA/zmQst7HboMKxIWJEVnxx?=
 =?us-ascii?Q?t3c3ZclAXLqdGI+I8VmWyrwTJoFl699ezAfwh9SGr+rkFolEmy1idaZrobut?=
 =?us-ascii?Q?iVXZqlgVW4dG1B1hhI64jBRaxDGoIxocy4mdCEmPLwuGhpU7/wnCBoSaGQh3?=
 =?us-ascii?Q?KV9OD//6a2vFOxl9xdOQb0D+eC/9/QEMGgb3ukGHgcMGZsJblRV2+W7Wm6Bp?=
 =?us-ascii?Q?pKQJ05Cd7HVmI+1d7hGif+zi0hgBZQam9PRTXLxaTPyLL2Yg2gL6x0RvvgQu?=
 =?us-ascii?Q?iuT6Bp9iSVxjABIZYidwP+O1NRuQbvcAWPTLsg8+wpIXZvAbRKza66PizcO/?=
 =?us-ascii?Q?nthPrfOfXUDofamxo9KTd1OR5YUC+sEw+foI6BmjaX0LrV8Wlekgaqs7XaKZ?=
 =?us-ascii?Q?FC72oWKSEwTRqmDwuQfrFficLg5HvhTDXjMFTUn1eobQyjx9kQDFB+lA/RqP?=
 =?us-ascii?Q?VXULlJs4CPs9aFKaCKbU62YMz5ITcUkoqhOr6PQfrcEIPtMKdzqWACFlsBoq?=
 =?us-ascii?Q?8RBlfNQ3lNheKEwwlDB/M6f7974OOGG+fvhee1sVw0gbXI6nFu0Lo/icVW3x?=
 =?us-ascii?Q?7CPdQXLv3fG8Uv2M90VVdxqyGn9QDE14jFv2mOsbuz0yFNhSpKZGWXWMnYlh?=
 =?us-ascii?Q?WgtxQ8KqeVR4BRqPukN7XhIoTLCphATE+/gA31xJpo562ZAycqL+N23ShXwN?=
 =?us-ascii?Q?fxu/AtPVfHpSnfDIkCtycw2pnkx8om0OawKOJ3U/JkhnPwMioZnarXKHej/o?=
 =?us-ascii?Q?qyzC7CRYZx+Xnd5zR3RnuSVbBitLChRcSe+MdewYbO1aSio4PWAkQSU2PKfB?=
 =?us-ascii?Q?+3tc4X83BbaGxvYQkTQgF1I8nB74dJoRzWAr9dGXtgUzmr9wk3oc5DIGezmW?=
 =?us-ascii?Q?O8QXy72d7hhKsLQdEjHRAovUMCBXRumuf8rThaZqTpCc97kIFveCvpsdSiRV?=
 =?us-ascii?Q?lNbrULdcKr1IfVdteUMPqVmDlwP6/aeb4yIVXKNRKTSpLsnkt+WcOCeNqxSe?=
 =?us-ascii?Q?VLvV+ekyYx4la4MOFmONUtFlnB//LconEfHKsxYScPk7OR59RP6hoN3hQQON?=
 =?us-ascii?Q?gTQhTyozjqa6KUkPeDfVEHbhV7Gw0kCnx3qjl6VygoIFuGojSVV2KMnrHqXn?=
 =?us-ascii?Q?r2odtARtqj4CMys5Me8fsoypsM0mbA16erzFjdoAWKhlpeN+JhqZMRXe6vaC?=
 =?us-ascii?Q?TT2MLWX9IKhPDPVoEZsPn6HtTnvqgsA=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	492KN5M2FRVv3NoClc969y/amhk7lcK8+JpMgCUvM3j9NllwAuD/GPBbxXzIVcZjq1nhpgjdIUAjpdJrCNxmnGhArWf7Dqj5FKcEoyr1Hmiik1gMb2uIPT78z6lIVwK1v7yG+cCu3KCuq7jrJ1vWwQJNLxQOjHDMlVpVtFwWx5B4TPVDt4ZkZ3LbkiSu/HwxCj/k/22GUBpiMnyUx7LpqwdS5e1N7lIVX2huGFYg+H2fY1K7X8vq0SvLptJpgwwLI4vI/dpOcm6Xd5DQx+61cQGxZQbXOJB+BUYGrvB2zOhTI3DMKRHviqZU/qicqlDUoM7uxONfI4mxiYFVytcHiLuCn4K75KU7/sB4suq2womhen8PJl0NWs4ITXLMZrlU+4GN3yd/dlpBANW9fjH0tMWRaOU+JHnVhSeIOjLKiEUox3Aku3avvg32DWhzHSRiPH/AupWTX844dDPn4xH0fRPatlNAL8r6OXys9MYpmVaDV6Mr+eRI15PF70sGRjMxkkTil87hS72usHhsH5tTvb9JF9YFUivEeaMN8PGCUN+FQoakPwIhjv7tksKvwB2SuJvsNlQAcKlBmxsQ3pnRC9B2wgG1LeTzi+R0Pj3vSOU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b44fb09-c9e0-477a-dbcb-08de4f86b55f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2026 13:55:12.1954
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AuGUVYJtVEFTdcaOe1xiyslQbPsXonAskKJ/jiuEpPzuRr9J5ettZireFb4YA++ZmSS6ZtunRR7PGQeq05lO/XSUlFCiVAF77WIzeIpZQSI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6448
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-09_04,2026-01-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 adultscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601090103
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA5MDEwMyBTYWx0ZWRfXzhyGgo7dfGeN
 JUOKPlk6yfctugmHLfz1JU6pgaiveyCQ+AmldZfeoWAEW5JcUKTaeWGhrhr4uJ0g2hMHsmwNTsA
 j4Bzj4TKh5C+ntpvSUrEOGoHG+GXkcV5Z4SK+BlgFnh7wUM4sZeoLh/67Og8RMonVv2jL4ftGI8
 VvEUkHNhtoUqr7jh7CzJSYLSKsvJa23Rp6pYUzjvRMcNznQycv/8ohrQFPr/VhhpSDkLEhH57g1
 t8ygGwbI7jYW9TSslIfPhFm3zdoQ4ZD4bbVGOTr2u2b+MA97H/qAJsWu50JViU4mkMdhWQeRBub
 U3j1fHbkCrHy1nmPOxJExcAkVPmXLfNcyiGLLeEvfcMgjA7v0GW5R1xL2YwrxCn2/8LVCsTnVIR
 V/8ZC1elZBlDFo/xjxanVbygD7nSIQ5soIZGhbmKIec3RlNo9XOxzR7n3upHzitWOOX2hxI7idv
 3hb4HVAI/A01w7FXCMaIOcL/G20bqdNvmgjGkSHg=
X-Proofpoint-GUID: L1BU8Q4R7BMgfuaJK53EOFCAVKKK_rsX
X-Authority-Analysis: v=2.4 cv=VoEuwu2n c=1 sm=1 tr=0 ts=696108c5 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=__XdzZj2_yvFMQ2DVkgA:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:13654
X-Proofpoint-ORIG-GUID: L1BU8Q4R7BMgfuaJK53EOFCAVKKK_rsX
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8F45820005
X-Stat-Signature: bqkgmf6hhsp7ax8h4o1qapqdurm8bx69
X-Rspam-User: 
X-HE-Tag: 1767966921-999794
X-HE-Meta: U2FsdGVkX1/YE2SGxM8vith3mO7J8aiYL5L79x220kAydb6kLTT/oeXdHBDCXxjJ9G5vll2mehTLeP6/X5a84wpkmBEqmupIs39ZFmoQ7vgCnZmF+fzFezfxo2EgNCDeFGMlhTEAxSVaWBGGAAUc6rSB20Jl/DKql2h4zWAx2ku5URcG3iK2RnOVzvnWYH7dQUpCcJqUorjC0N5cli9RhqcYevLcD4V09uaRkPlTCR3nIE+Bbmc8YjA3QLcPVeqfeYiE4XG/g7qDHhIRm/df+TGFvCihTgl904zPjPpOW3Zrjy4fMjGigLENrmLMrotfp8UH6gQnzBZSoKhEusDA/guaj7EaMACOFf1APSDljdnQvgrKyL/FCXjkoTsF9tr4IypmOKBUlmjYXlz+T5wMgnhRTP1KQy5v7fZzJiZnkR0/RSGmh2X1XgUicMFTY+cNrkYjJPWxbNsOvCAzYZJ8eW13qc4GniS2opaIaxAEVkVxEH42QoSQctQ5pZTpHVPTHlsyQrvbW+TwEK+YNjg+8XDYKsJRl9l6/GRDjg+8N6T9Oah6G+2BOVY4yuDAo124G7nhRVz6FZcNby76R/H6ujrnWyrk1XzUI+puW9xbVVw5vA/raGcfxT0RsLciB7nq9SX7pceEW1xEYf+O92bvzDJO2LAnl2AH3r23kICpcmXTuTaZlWGNvS89LVZiPP/fHONrZnikewkv8IoA3PpVR4DJZwhoMAURx8E7eBScgjpq27tbmbZtm2f1MIe5iksvtb4uGApBiSorLdSgNd5apiMg7jr8Xjpsqz8iReBnRNCWe0lPTNIuxM4obRdJWKhzXwqZiY0jdolnwsREW3LOZFgncFeKOSvGDTJHJEIs5VKlRutD7Dgs3sjKw3EZuKApBgy5WUBkZ15yLSw28SV3Jct1tQJa8vaLvlJEA2mzWwDeZUhdfEUI+4SkLUpj2NEOdpoH/tvzT69OMsTIANf
 f1usFPAc
 3nBDr4vTF/c/NVNKQyojHeVtFsxPooORFqC7mTTS3lEV5Lyn0nJv4LLbh1KmfqgAJ6nRVZQsDIOapZ3CihQtESl0kIJzZYsIIokKgYVFqxlkLgXC1BGSyuY4NSohhy/AA1y5bSt4v9LumRszsd4pjqBOdSsB2OwQoasFOPUCzfrbgMyHo+GbRsbs8wDOVT9yPtfCID8+CtGTELKCuuPsKftkFoDd3+Mt3pozoQR9ALxBQ5CCaCFy8vbiXTXOKyR01+UPgnAjsO+ab/0tQaKKzMljPMlOtpDMy1fC+qh37E9kiCSI3nC5yH2QVkOsbMCah2ubXfs5M6CbOL5LEWieyr03RxZ2gFXfxJ/Gs4Ep7MlrxqilJi/Xu3MKZdu/AhkBbgUUlN3pbth6vkedVvV9pTigCCYUrSyW/KGCss4xJYBb88ZO3sBDLSoFqQyrtpnqlYZGfD6g6IBHMDmcFFwqQEnCA08aC6a/rsxPY9C++a75nzci/Kzp+U1Tc7FNWwGi3SC0V2mXbkEWqVCe13lSyA53tVvbLqsqak9iQneUEY2mgdwoKLH3IEyEnMgWHO8rBFxCRPRIxVYtyYmPYvIn1CzqmVoW2581LwyMN5bnjCSAFfxKU7zmNXyXsSegWgEGgpUVPy5wTb3WAEng=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 08, 2026 at 05:18:29PM -0800, SeongJae Park wrote:
> On Thu, 8 Jan 2026 09:05:16 +0000 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:
>
> > On Wed, Jan 07, 2026 at 10:26:35PM -0800, SeongJae Park wrote:
> [...]
> > We need to change that in my opinion, but I'm no longer hopeful that we will any
> > time soon.
>
> Thank you for kindly and patiently clarifying the situation and your opinion,
> Lorenzo.  Thanks to that, I now better understand what you are saying, though I
> don't have a good idea to add on here, for now.  I will also take more time on
> thinking and help if I get some ideas later.

Thanks! :)

>
>
> Thanks,
> SJ
>
> [...]

