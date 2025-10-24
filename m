Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C106CCD1BF
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 00:41:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89F5A8E001F; Thu, 23 Oct 2025 20:41:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 850298E0002; Thu, 23 Oct 2025 20:41:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F0CF8E001F; Thu, 23 Oct 2025 20:41:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 50F148E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 20:41:23 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DAE964941C
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 00:41:22 +0000 (UTC)
X-FDA: 84031154004.27.23B975F
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf17.hostedemail.com (Postfix) with ESMTP id 77C1040010
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 00:41:19 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=VBcQA+Fp;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=zDyH7MjO;
	spf=pass (imf17.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761266479;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MywmuUfeDRIXmBNckhGdSlJdwXWxWfqoDbH3C4OpKYA=;
	b=VbbRz3BYq4vnKehJjV6eoGIucuWlBDW55bYz7JeFTPw82Oo9CqAPRuZk88G40yhul5egox
	VBDlQpuJhPZAVznSI8Lph+yQS2O/KD6UqWSy/h5q5/EQGQ5b3GSODnTIIXQaJhtREhLFPO
	Gua/VfUU/PZgxg1JIjOkNG+2y2PhV74=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=VBcQA+Fp;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=zDyH7MjO;
	spf=pass (imf17.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761266479; a=rsa-sha256;
	cv=pass;
	b=5dPDrbfr7U6otwLz3Dq7ecOW4u4kiyD3It/l4C4DWnu11P8m4g9wLXoirWFlhDzzOc1jwy
	6i/K1lMVo5GJOOklyfgE2i3VnpHPYT39aWeUx+fbRdl2L4/LC4OSLCJbV5pCWKgXx1YmC9
	3M7sVwdMEcgUN2y45yIh2kSJweMrHvQ=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59NLNMDb000737;
	Fri, 24 Oct 2025 00:41:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=MywmuUfeDRIXmBNckh
	GdSlJdwXWxWfqoDbH3C4OpKYA=; b=VBcQA+FpL+Bghx5oKN3ukoAJonmONcdpb7
	emBSMokd6yhB5worUiGcU2LiTmWLsmZsmSQnpX+aNQs+Rq8/GsXuZxtmL5u/3SfM
	hAu2/cu7KXKR3w0gFnIbaIoGF4vMIWbXy2bzlnOOV7Aj/gXNM11P+BzliRISKGXN
	cE+Jeq/+gJMDycffg2R9iVrQVQycRZ29zBdH8bLgHCw7EJ+B5uMaDZWQzslluKJa
	CISvzOjG8Q2SZfIQN+T6fui/WRFExgGENiJ7eh+XWIc0m1LtWcJjLKeAFs/8+f5j
	ZtphUpBd+mIQJfJQClYmfAIRMxXAG7HQFkGiP4D13GZAvSZDGHpw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49xv3kupu7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Oct 2025 00:41:09 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59NMP14e022309;
	Fri, 24 Oct 2025 00:41:09 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011071.outbound.protection.outlook.com [52.101.52.71])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bga4jx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Oct 2025 00:41:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VBbAvCTTamHfwWnIZymfTMOSQzUq2v66iJY1pfOUojOBSPvBjMub70Av2pYx3ftLSadob68CPtKEzM9GNacA8ZuJJueE/LMWCRJCebU8mjejp5MgX+2V58fYSCLRyfsPVICh1HOSkHXiQYEN/8yVr7MuH7P70WqwukPtXeFjuymR5JVaf0TpimFqg023Bv1u8sDUWhmw6sAAY685ZXe/+YJs4zjvBqreM3dyXttlKtiQGsRKDNHSaK9dq3mcnFP9CQcTuUSNhmzNXFKVHEzVw2WxAS6yQH7ja3v5djueR9kEnjSEsXbMC9lLP5tjvKKiLli8esne+G/m8IfF/ckIlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MywmuUfeDRIXmBNckhGdSlJdwXWxWfqoDbH3C4OpKYA=;
 b=wMIK01CGhOY2g3NPUPWbRAFtLkb4dDdpc5g+Fy4TAw4rKor7psC6Nn4R3QeYnAIZYAJNpb9qbPgDGYZkh21XwcoFdqfsoeLniNuac9yUBrVFJMn0IHNCizvG+dSsoG4f01jF3CfCtDxhL8RcFlgrmVIE1H0bafI6rdTpt3Lpvgv3Yfi0CB4yuZeA0pMlJthfU9RFOJCCwGEjs24E0eg59k4vOVCyK1qEyV7jdf2sfyyIe9JAV62oHRsndFgd6wWxfzI+OHyTAeS16YMJ8v1v2e4dgE/ayEg3qkCpDgeZQGZFNUTpdMqgRj9ahEugdhw1RV40SacA74WEwhLfHTORdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MywmuUfeDRIXmBNckhGdSlJdwXWxWfqoDbH3C4OpKYA=;
 b=zDyH7MjOQsVaBV0IMBUlT5qvW8lw6tmtZD0fFnuDBTYYI1N4ujy3VQykk55AqJV97Ed4mF8jwyO+glPBjnMAqUQVPg43zCy5SY1DFU9kzfne9KN7v6eW/01lJHdr8dW2ogy/gXktac/qPDJ9124mP+UPbwPerWpwzAYEEGswdZU=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by PH0PR10MB5561.namprd10.prod.outlook.com (2603:10b6:510:f0::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.13; Fri, 24 Oct
 2025 00:41:05 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%5]) with mapi id 15.20.9253.011; Fri, 24 Oct 2025
 00:41:05 +0000
Date: Fri, 24 Oct 2025 09:40:55 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: David Rientjes <rientjes@google.com>,
        Alexander Potapenko <glider@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Feng Tang <feng.79.tang@gmail.com>, Christoph Lameter <cl@gentwo.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Andrey Konovalov <andreyknvl@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] mm/slab: ensure all metadata in slab object are
 word-aligned
Message-ID: <aPrLF0OUK651M4dk@hyeyoo>
References: <20251023131600.1103431-1-harry.yoo@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251023131600.1103431-1-harry.yoo@oracle.com>
X-ClientProxiedBy: SL2P216CA0152.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:35::11) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|PH0PR10MB5561:EE_
X-MS-Office365-Filtering-Correlation-Id: d705c3f8-1290-4e5d-958f-08de129603a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?P73H5aaBoGMeGXnZGq3YA/Pm9tiNCYUyIouE6u/dQ7jmkQTmB8fTlgz5x/e9?=
 =?us-ascii?Q?6/s5renXbx6lm0DjlZs7yRViOLO5mNIOOHdrybY8jNdKi2EBNxOir3v2uB6T?=
 =?us-ascii?Q?czjMm5nmLW8rzuP3XKA2iPkkKjvOIbaXNH4ueGjslU7L4kFYYChAtkgLMslI?=
 =?us-ascii?Q?vhC3NYgyMFSHILN476sjUGvsQyqqYZ2fAPaN+xCjxNfh8aEcb1z5Q2BvA9xs?=
 =?us-ascii?Q?pR6/rVqY6BUAHKCb75AGFaGnGyY6AjL+pVNoU/HB3vMRgLYxiGvzR6BM9sYt?=
 =?us-ascii?Q?HHKJnbt2m267eM6uLmT8+te6Sitw44x29Bt1GQHSK5fFnJEmGXuhhw2py2+Y?=
 =?us-ascii?Q?/BWv2EU5seI7i31rjTwmJoZvDc6hNVCSB6eL+tq6sEjjGU6EEQQU0ReJouJ9?=
 =?us-ascii?Q?JOoev/OVV2KSlN0RBUOFIm4NCqXBfqMzu9I1W/djCSvEwp9K6XqeSw9+00k9?=
 =?us-ascii?Q?9NNvXL8Zx6AxGzBTkBGfEHgVAuHYi42XqF7UBNQv6PR8F4aT/s/ocksy09bC?=
 =?us-ascii?Q?18/PJZIs4N1AAZmJbdjbLn6gBwwQz3eNkYhvQdxGS02lDBk3RNTzpeWLikK8?=
 =?us-ascii?Q?ravyvD3KGqyDeu2yWgdafYqXbK5GmQhxPGQtyd1Kiudzm+czdwFexIqfGTkX?=
 =?us-ascii?Q?AlnlJJzswuJ9JUV7erzJNha4BBfyood6rFZJU9uf540rZ6spNVef+3+DgSPM?=
 =?us-ascii?Q?Ql58McGlKFnegaVAD5/IXMLKezQJzbU8qo4wpUz88u//WRzq1gFkYDjKiU6R?=
 =?us-ascii?Q?z/EDvhV+y7gWMtDR2+KoAVTLQRYp9sx7Uv926ss4aG9eDST9q2243G5zel6y?=
 =?us-ascii?Q?QeAue+dT1/G0UTfos4Ek4GzLmZ04IPL2a7Ku3qWpP3/bZAfkJggAjFL4q1be?=
 =?us-ascii?Q?hHjLyf+i7O4kC2k60mdGkXfmIPonYKaozWD2yQyYoyIeRTg+uuGt/jnFwrwQ?=
 =?us-ascii?Q?bYrWUCkW1IQBG2FOopGgKwaExG333qg80LKGkLAkROZdW17YgHqPepi6/Eth?=
 =?us-ascii?Q?ct2j+dMRz5wuidEvhsaIsX4QTy6QScEZw7JBEPjQfHSlBZhwBB3ymvr6lawG?=
 =?us-ascii?Q?NeqiZqY/VC82Oosxsj/KGS/8JJV5ocRsgSx49G7n/JBGtpiClYvURB/C8Y++?=
 =?us-ascii?Q?by3Y6jAgSkTw1VzQYUXONwl2OYpJrdZUml/1grhm+UKd1n+kS89n1OPmB/ZP?=
 =?us-ascii?Q?mje1vFCEq7tc8cjn4+743rOg0jQYSrh5pXbHBFQDT3Fdd6TXzILTQZRZS3a+?=
 =?us-ascii?Q?5wMPfWNm+54BpzxGCR6tKE6NIb3G7V0ZM4wqmpyQN1wycd5pGp75jumX0dKH?=
 =?us-ascii?Q?ZXA8pQ1lrQtuGKDBQlEDDzlQpo6uEaxH9JFHpQxcbiSC3Zb3b2d/rN038lAD?=
 =?us-ascii?Q?VLZ8VK2+8Zc5ExLFT+IXM9VTQw6kNLctTB9fSbDbWeqUMiAncKdv4dzIFRBL?=
 =?us-ascii?Q?UpHgz1iEBCobmuztblRO3lrdvL5OPF8C?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4vso5SNnvslR8teIDWIgAqDL71RdPunQqG3aLtga0NZkWPqg103LgGKzkCxa?=
 =?us-ascii?Q?yzC9tvzolsOd3dN5ipslIc4gAVDDVSdcfCqmQJSBSEAstj8v2/cPOKFpWhAW?=
 =?us-ascii?Q?SEWcjCQeLvW6yGLZNqJE1D7M93fXux5Bv5weQo6RMS8fc6G/wcQXVJ4S1Mx9?=
 =?us-ascii?Q?+fK1rRVS8VsTCLF+gpSnLMAA9To/3+lxX1fPRv2uUPVG2PuXYaNnd/oIleFM?=
 =?us-ascii?Q?zBWZL4iAL7BUHrD0tiHpbmCB6uk9lJiX8A9pX9SAMe8Z9XxLo86fP7MQB/Wd?=
 =?us-ascii?Q?iglVrkBt0qYPvtxsP7hESv4F4lzW09z9cTJDonjTTmPKw0bDHrUYZ1Eo4fYv?=
 =?us-ascii?Q?7hrvH5NY3wFQvIWGS+Y+xQp2YejtXgy+VuV9HgU1qiZuM7hWM8aImm3GwO2Y?=
 =?us-ascii?Q?VnUKzpN1wAJuOZVUNOKZWrrIS1p6K2bzdCrzMStKiclf3zauMJcNl3BJX4UX?=
 =?us-ascii?Q?CgHx4FizuqfneKqZlwlkd7vPCc3eqAa7L8o/CuXKK37LDiOVb2dx+eTiTnyb?=
 =?us-ascii?Q?iURkeb7DBl4y+CBfoMKqwBiS+SOAFYM17uFqNTcYWicaFd4oQHTZ4GrAbzsg?=
 =?us-ascii?Q?tPv0Ai4ZH2D5JNMjqqkf/p0PZ9nrn+eBK+dn5pdtwpsc9DHcidmlUdGCipL+?=
 =?us-ascii?Q?eaIZWi5dwgixR7AaLnOfK3geGnm0KATQJakgnR/WZ91FLf8lgvcH5VyoNypE?=
 =?us-ascii?Q?gL3i4aC80WYyjzlv85I+kTuSJm0BPrIPW3cRmj5U3dYCC8jWdeQMMzJTq5C0?=
 =?us-ascii?Q?isiDJvU99etrPGuBFV6B839tkaRV6T8aBX1BW9ec59ZNmWVN8kobGZoP/qPe?=
 =?us-ascii?Q?m4EBxSmXZhUyduBMLgAggpmwdtfNIKy80TjANAnbz2RHYwXPzocybrqOxlNQ?=
 =?us-ascii?Q?EIItPRki4yfyB3PIy77KFJWpFa3VrJoS1OjxOIYyy20jwGSXTt+59MLpOzxH?=
 =?us-ascii?Q?9a3ghSkMwlj5B7RUkiGEfAVFz1FlyHAO0mbLBDBts+KCMlvJwPSB4jvDM30R?=
 =?us-ascii?Q?t7Jp+El8ceoQbtbEvJb5IodeJkFTcymHwXgdUH2+9wmq/e0egyTNKzSsYVDt?=
 =?us-ascii?Q?EhF74eAOgl1av7gwz6YAFFmS38lSXqCfBaX7JeyYYXx3fhBOSANmV8BsqKwE?=
 =?us-ascii?Q?4GMl0rcTIBNTWaa7lAQ6YTUIs7sdqJllDOfa0qkFXkth1foGBOTQZSqB7oKE?=
 =?us-ascii?Q?+ghjd6QjhdSoshn6byv+BIhUzKevhI3MwLTzXahLslMtadFjoDuRA49DZqg7?=
 =?us-ascii?Q?w7SBGbXgT0QSTujXL+k/ww4iPjOvDPdok2JOdu2Wz+a9eiok1VjKYB7y1cbp?=
 =?us-ascii?Q?CBS92qAMHcyDEN1jaUFzrscnjdx0FwlWc9vU/R3wdSZVwVU1WDUafqrl3Gs9?=
 =?us-ascii?Q?QOlGasLWA3q3/l/zgwOBEqd+xxSxnkKgdPE6P8oM/Vytumo55uboRlZTNuzt?=
 =?us-ascii?Q?tt2MGPccq2yXtR+JVn4a3brDKsjjPteyxnpqVjsUwZO40Yyl2iYY5vata3ct?=
 =?us-ascii?Q?is6RqRNsM99r4GuufCAgbLYpr+gXIV3/4h5yBv6U3r6+3D7Ho8kJH5zcDdP/?=
 =?us-ascii?Q?w6D7hi1vH3KCz6HSVgDZ2VoS/RW3ej3/MwJAs0fz?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	SmCaHrBM5xMzi6vqMXCuxzUJdC8uV4CSDeiBcllEqi2LUonEZ8ctYZsnir0mVv0of6Gh6FhICr1LovDJJ/Nu1Xm3glIFJvCdNJZBzf5nQbu8j4SkM33j4H3YTqL+7LPTvnvz6HjmVqrmgmxnAsJGZshiwya/Em3oI5pymfBTXRpYD0q7Zxf1kNAETGSDySoJFzn9sXNq6ymAw0cPdaZb4uxxsTX45dX+DCCG75ppGCQBonnqKaE6ZCKcTUVsp1EtDPJZoaxILkd8LSmq7WYD48JM3INyzZXplvf2POKHqbINaE3XcamyBmMRyrmcX9OlzWfE1UcT6KKd4+1+VsA14PW8HNtsACRy+0APdCHZCHcqUIeH4J06MpAGDZM2ikQHKQ8XUM1oNM8F+Egr253OZiWtzFulOw3oCewvMFVt8tj9xJ1RB0bcZ9i1pfRI21cD8cp6MkAEeqUobNutrRyR87wIUv2Aa3TbQOaVwxFzvTyRuQGl4n+37EMLAw302AG2im3ElrBio5uRsdEhj7LDAbXEVkmM6rql/TfGwqvFv9d91dB5o9iOowB3zsVaqjSysQlAyWwoY3do1hoVVkNDGXX4xCrTXjb9fhhbTUTCmEM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d705c3f8-1290-4e5d-958f-08de129603a3
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2025 00:41:05.0879
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tqSjEIH48VVifhnsaCBJXFJr5FrdEYNVBFOINsqy2YL5sug+HQEajvFHbFldlyz9Gw4aV+L1nGBxzjTHHmO+Pg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5561
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-23_03,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 mlxscore=0 adultscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510240003
X-Authority-Analysis: v=2.4 cv=acVsXBot c=1 sm=1 tr=0 ts=68facb25 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=E5bhC2EWAOX4NgbMq8sA:9 a=CjuIK1q_8ugA:10
 cc=ntf awl=host:13624
X-Proofpoint-ORIG-GUID: mI_pofx02limYJ3CJ4Eti7izr48nJbT0
X-Proofpoint-GUID: mI_pofx02limYJ3CJ4Eti7izr48nJbT0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDIyMDA3MSBTYWx0ZWRfXyjpkTdjHr92Q
 MUbAUtV5vzguRT7S+GapbWEjM7/H6bdAl4005NPuIf9IUNUziu/CARpcRJUGxeYPhh5lLEYJh0I
 6IaPas2puSiHLDFwz3bOAhEFEYMqAJCezYvVgQ1EqKzvXx4w071erYL+911NRHBnCIx592Hw8YV
 1zlwiPLqTbAMOLVdW8pUEGP5QvGrnegYCxVa1JwJK5ridnvKSfAfO62V/jU5+t51cI9cIS0F0S7
 5cfjJOeaHHpPzfSwY9DWB4liWPR/Jsc0dKFVlZEnrkBlMoMQZB+1P+HNfyeqsFi7euxfBniDcM5
 ADiIUhmSdb0vMSv8lOAk+R+O7i6YOpUwe2qnSvPOkr3zS0FLVgOUu9Gv/P25bKMzOsO47AgLqWe
 nDFYhQJVMnAEdlNWkfFy1G0rAkqQ8G2FOo6QA0nJdOWn7NPhHeY=
X-Stat-Signature: bwjz3ocztwdcgyfefu9bzd6cqitu64xm
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 77C1040010
X-HE-Tag: 1761266479-636659
X-HE-Meta: U2FsdGVkX19ma8RN6D1/duXXr+OjpHKH5fuYpz2r0CHHZRo7u+HztfGMukWxL7eYaby1ELlPbsRno4DCevPtaSHxbWjrF9C9+PfddMbU7eleJiCaJDACn89JzENEtUNxQF4a199fuBtt3Q3+DHZ2z+q2tFueoPMX5DpN2jt4m3kPG+D6BX3uH24YYrTBTa7NuM35Ifohb59I8Naxzfs57q3A05HvzZczRtJyDfFusmA+HH295+8ZEOPHlkUzabPDXU3tzKUzLBm0ySHe6HPdn3GmhcNLujHaMIwXIwZkC9WNKujaoKXHbzEH110ezp3Rg+rNArA0AeKV8nXdUtr+lJH9wHEGsfuQXuztbx1vuvZVhUYcl9sDwkN7fWvz2JbVBHvxJ9Gg+8UqR8mTS7wcRY7JWxIyFfefU6GlN8uToAGm7JmMzvZ96IA5mqMlMeqO9rSEMDZ/lvAdTWvuaBiKjW9zxymu4lGXgQcGx2uK1R8FYIGLdrzOn60wQra7l1dThWfqdgeCqfIyT2zp8S5dSwZ5KHKk9XkRUlzWkz8aBj+PXseGOGeY8PcY4teRfz4/oeypRycOunGKrqcSuw3UlW/6Tn4JoaCgmWRulQHmMSURvckUVqZvQPVx5dlqPwCsWqehOaV3scfN08z6apRidcAqBtt8G89hMDMqC+sE0ySqreXZOjceQ2xP2ohQSuFbMs1uIqRgB3yTfsFQcs7Wa8N5+jKvXlBnU9EVdGQqPHZFza6Y4KPDdD6Xma0H3KPVjgGYQWKpoaC+Sn8D7GDOiKiXwy27LR23IBc4g+SzO8wbzoaBKSrIx34ZPfVbMQFs21txwZ4Oy+UmUDulZJiXcOwcgMHs6AfYiJXAqs6rJzX6zam/9nlfU9JW/afAuZCRioK5O2VTmFI2ZjA2pwjMxHT/cf64f1tvD8ZRE4m3Sxa1pw9kj/EiFfgsJfZtbvRhl1cphFz7uFSMT/Vo1Mm
 V9/0Emys
 p2i1kGQ5YGuVt4noQeRQDKylwdNSItIb3rIHATRyKDNiJ7A3R8R+KlhOVCfDa3Wkgo8KIz8UaMK/P6vL7a0RCFPqzj2FJjrcH2y9kBCqLDPK1LTA4pVD4E4pCTZoG3uzj4KF+UV+nzkXFoJpVH5mJuTCsdWsmMqDgop5N/tPPeXbLa+kgzSNk02FVfg0w+QGYUeIfFB5cELVrhFp4VHyDXZS2d0YVfLn+o3R67sleDhw8InJS5T+UNtkfiLzvPy/yM5jWccGz0K7GsPqqXz5zEVoNdefpvBPftFxBGOXdyEIuSXrE7S1FSo81pI4lAM7SN1n6WOee1dQLetmDLn89tTdTaW22gxLPGb0LuQUJdD2q+23ZOyGKFgy6Bkn/tsauAkkl65Ll1ezROikl8vdOd/xm1nvWEYO6puduZ+/PamVw2lS8BZXr5syHkH6DH/DDRgGlJNHqh22lbZokGJasrxVtLGuZYYqm+rJ2BBU79A8b4uJyRlIbRx4DAcuhqwj+SgTfzv2MsKifNeR9d8gUjKH2mFBAxEjpwCFsQoApGxTIU4VNb2TiGrWnEUUZFdoau735YLpjOM/OBnoH4eZq/AT5H1skXsC32swVlA41u2dphDHuxbxAXd51NcOy4rGUOdmOoGyHnHmgb+8zhVX2gAXVbF8BJgYHCkXkwIROF4dcaVBYj78dGrrm8VQbGp2aIUte/Fed/HJ9ZxYbDx4NwYD8EhWnmBiCfVj7552aJDTzngrCssluc9FC4ho3yWv9wpEoFEOcqOFU/SkU5E1lUlO51Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 23, 2025 at 10:16:00PM +0900, Harry Yoo wrote:
> When the SLAB_STORE_USER debug flag is used, any metadata placed after
> the original kmalloc request size (orig_size) is not properly aligned
> on 64-bit architectures because its type is unsigned int. When both KASAN
> and SLAB_STORE_USER are enabled, kasan_alloc_meta is misaligned.
> 
> Because not all architectures support unaligned memory accesses,
> ensure that all metadata (track, orig_size, kasan_{alloc,free}_meta)
> in a slab object are word-aligned. struct track, kasan_{alloc,free}_meta
> are aligned by adding __aligned(sizeof(unsigned long)).
> 
> For orig_size, use ALIGN(sizeof(unsigned int), sizeof(unsigned long)) to
> make clear that its size remains unsigned int but it must be aligned to
> a word boundary. On 64-bit architectures, this reserves 8 bytes for
> orig_size, which is acceptable since kmalloc's original request size
> tracking is intended for debugging rather than production use.
> 
> Cc: <stable@vger.kernel.org>
> Fixes: 6edf2576a6cc ("mm/slub: enable debugging memory wasting of kmalloc")
> Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
> ---

Adding more details on how I discovered this and why I care:

I was developing a feature that uses unused bytes in s->size as the
slabobj_ext metadata. Unlike other metadata where slab disables KASAN
when accessing it, this should be unpoisoned to avoid adding complexity
and overhead when accessing it.

So I wrote a code snippet to unpoison the metdata on slab allocation,
and then encountered a warning from KASAN:

[    4.951021] WARNING: CPU: 0 PID: 1 at mm/kasan/shadow.c:174 kasan_unpoison+0x6d/0x80
[    4.952021] Modules linked in:
[    4.953021] CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Tainted: G        W           6.17.0-rc3-slab-memopt-debug+ #22 PREEMPT(voluntary)
[    4.954021] Tainted: [W]=WARN
[    4.954495] Hardware name: QEMU Ubuntu 24.04 PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[    4.955021] RIP: 0010:kasan_unpoison+0x6d/0x80
[    4.955724] Code: 84 02 4c 89 e0 83 e0 07 74 0b 4c 01 e3 48 c1 eb 03 42 88 04 2b 5b 41 5c 41 5d 5d 31 c0 31 d2 31 c9 31 f6 31 ff c3 cc cc cc cc <0f> 0b 31 c0 31 d20
[    4.956021] RSP: 0018:ffff888007c57a90 EFLAGS: 00010202
[    4.957021] RAX: 0000000000000000 RBX: 0000000000000074 RCX: 0000000000000080
[    4.958021] RDX: 0000000000000000 RSI: 0000000000000008 RDI: ffff888007d7ae74
[    4.959021] RBP: ffff888007c57a98 R08: 0000000000000000 R09: 0000000000000000
[    4.960021] R10: ffffed1000faf400 R11: 0000000000000000 R12: ffffea00001f5e80
[    4.961021] R13: ffff888007466dc0 R14: ffff888007d7ae00 R15: ffff888007d7ae74
[    4.962023] FS:  0000000000000000(0000) GS:ffff8880e1a15000(0000) knlGS:0000000000000000
[    4.963021] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    4.964021] CR2: ffff888007201000 CR3: 00000000056a0000 CR4: 00000000000006f0
[    4.965023] Call Trace:
[    4.965413]  <TASK>
[    4.966021]  ? __kasan_unpoison_range+0x26/0x50
[    4.966759]  alloc_slab_obj_exts_early.constprop.0+0x136/0x240
[    4.967021]  allocate_slab+0x107/0x4b0
[    4.968021]  ___slab_alloc+0x8f6/0xec0
[    4.969021]  ? kstrdup_const+0x2c/0x40
[    4.969615]  ? __xa_alloc+0x227/0x320
[    4.970021]  __slab_alloc.isra.0+0x35/0x90
[    4.970663]  __kmalloc_node_track_caller_noprof+0x4e2/0x7a0
[    4.971021]  ? kstrdup_const+0x2c/0x40
[    4.972021]  kstrdup+0x48/0xf0
[    4.972505]  ? kstrdup+0x48/0xf0
[    4.973021]  kstrdup_const+0x2c/0x40
[    4.973589]  alloc_vfsmnt+0xd5/0x680
[    4.974021]  vfs_create_mount.part.0+0x42/0x3e0
[    4.975021]  vfs_kern_mount.part.0+0x10c/0x150
[    4.975722]  vfs_kern_mount+0x13/0x40
[    4.976021]  devtmpfs_init+0xa8/0x430
[    4.977021]  ? __percpu_counter_init_many+0x199/0x360
[    4.977812]  ? __pfx_devtmpfs_init+0x10/0x10
[    4.978021]  ? page_offline_thaw+0x5/0x20
[    4.979021]  ? __kasan_check_write+0x14/0x30
[    4.979694]  driver_init+0x1a/0x60
[    4.980021]  kernel_init_freeable+0x7de/0xeb0
[    4.981021]  ? __pfx_kernel_init+0x10/0x10
[    4.981667]  kernel_init+0x1f/0x220
[    4.982021]  ? __pfx_kernel_init+0x10/0x10
[    4.983021]  ret_from_fork+0x2b8/0x3b0
[    4.983618]  ? __pfx_kernel_init+0x10/0x10
[    4.984021]  ret_from_fork_asm+0x1a/0x30
[    4.984639] RIP: 2e66:0x0
[    4.985021] Code: Unable to access opcode bytes at 0xffffffffffffffd6.
[    4.986021] RSP: 0084:0000000000000000 EFLAGS: 841f0f2e660000 ORIG_RAX: 2e66000000000084
[    4.987021] RAX: 0000000000000000 RBX: 2e66000000000084 RCX: 0000000000841f0f
[    4.988021] RDX: 000000841f0f2e66 RSI: 00841f0f2e660000 RDI: 1f0f2e6600000000
[    4.989021] RBP: 1f0f2e6600000000 R08: 1f0f2e6600000000 R09: 00841f0f2e660000
[    4.990021] R10: 000000841f0f2e66 R11: 0000000000841f0f R12: 00841f0f2e660000
[    4.991021] R13: 000000841f0f2e66 R14: 0000000000841f0f R15: 2e66000000000084
[    4.992022]  </TASK>
[    4.992372] ---[ end trace 0000000000000000 ]---

This warning is from kasan_unpoison():
	if (WARN_ON((unsigned long)addr & KASAN_GRANULE_MASK))
                return;

on x86_64, the address passed to kasan_{poison,unpoison}() should be at
least aligned with 8 bytes.

After manual investigation it turns out when the SLAB_STORE_USER flag is
specified, any metadata after the original kmalloc request size is
misaligned.

Questions:
- Could it cause any issues other than the one described above?
- Does KASAN even support architectures that have issues with unaligned
  accesses?
- How come we haven't seen any issues regarding this so far? :/

>  mm/kasan/kasan.h |  4 ++--
>  mm/slub.c        | 16 +++++++++++-----
>  2 files changed, 13 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/kasan/kasan.h b/mm/kasan/kasan.h
> index 129178be5e64..d4ea7ecc20c3 100644
> --- a/mm/kasan/kasan.h
> +++ b/mm/kasan/kasan.h
> @@ -265,7 +265,7 @@ struct kasan_alloc_meta {
>  	struct kasan_track alloc_track;
>  	/* Free track is stored in kasan_free_meta. */
>  	depot_stack_handle_t aux_stack[2];
> -};
> +} __aligned(sizeof(unsigned long));
>  
>  struct qlist_node {
>  	struct qlist_node *next;
> @@ -289,7 +289,7 @@ struct qlist_node {
>  struct kasan_free_meta {
>  	struct qlist_node quarantine_link;
>  	struct kasan_track free_track;
> -};
> +} __aligned(sizeof(unsigned long));
>  
>  #endif /* CONFIG_KASAN_GENERIC */
>  
> diff --git a/mm/slub.c b/mm/slub.c
> index a585d0ac45d4..b921f91723c2 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -344,7 +344,7 @@ struct track {
>  	int cpu;		/* Was running on cpu */
>  	int pid;		/* Pid context */
>  	unsigned long when;	/* When did the operation occur */
> -};
> +} __aligned(sizeof(unsigned long));
>  
>  enum track_item { TRACK_ALLOC, TRACK_FREE };
>  
> @@ -1196,7 +1196,7 @@ static void print_trailer(struct kmem_cache *s, struct slab *slab, u8 *p)
>  		off += 2 * sizeof(struct track);
>  
>  	if (slub_debug_orig_size(s))
> -		off += sizeof(unsigned int);
> +		off += ALIGN(sizeof(unsigned int), sizeof(unsigned long));
>  
>  	off += kasan_metadata_size(s, false);
>  
> @@ -1392,7 +1392,8 @@ static int check_pad_bytes(struct kmem_cache *s, struct slab *slab, u8 *p)
>  		off += 2 * sizeof(struct track);
>  
>  		if (s->flags & SLAB_KMALLOC)
> -			off += sizeof(unsigned int);
> +			off += ALIGN(sizeof(unsigned int),
> +				     sizeof(unsigned long));
>  	}
>  
>  	off += kasan_metadata_size(s, false);
> @@ -7820,9 +7821,14 @@ static int calculate_sizes(struct kmem_cache_args *args, struct kmem_cache *s)
>  		 */
>  		size += 2 * sizeof(struct track);
>  
> -		/* Save the original kmalloc request size */
> +		/*
> +		 * Save the original kmalloc request size.
> +		 * Although the request size is an unsigned int,
> +		 * make sure that is aligned to word boundary.
> +		 */
>  		if (flags & SLAB_KMALLOC)
> -			size += sizeof(unsigned int);
> +			size += ALIGN(sizeof(unsigned int),
> +				      sizeof(unsigned long));
>  	}
>  #endif
>  
> -- 
> 2.43.0
> 

-- 
Cheers,
Harry / Hyeonggon

