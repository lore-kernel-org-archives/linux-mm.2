Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 738FCCA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 11:38:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE86F8E0142; Wed, 27 Aug 2025 07:38:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E25F88E0105; Wed, 27 Aug 2025 07:38:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC6518E0142; Wed, 27 Aug 2025 07:38:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B0FFC8E0105
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 07:38:16 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 890161405B1
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 11:38:16 +0000 (UTC)
X-FDA: 83822338992.13.692C777
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3E3C21C0012
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 11:38:13 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=beCezHKn;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=fOENlAox;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756294693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GvPGaxdFxq9DZKhJEvFptWToV1h5vI+MsJbT0P7eM2o=;
	b=rPqBBbuBQOqSmWMxaO32dTiHjHQi497e/bVNk39BTOaosOvThZhjGbTH0a6/qpvPZ2dmcs
	Pjom6m5ZLnQrHEyQ1A6uhtEfoKNRpes1URWy4a0W+ZaKw/vtuDWBznjT4qInAY+YFmwqMA
	+TzcBxLrVuOh9/LhICtDKKtjHNMRhvc=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=beCezHKn;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=fOENlAox;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756294693; a=rsa-sha256;
	cv=pass;
	b=NR4KflZNUhSpTodYsad99VlXSRStQhv5MnwvKThSZLJYyNjBK6E54x/2Kto+0inIW0VhL+
	n2Mpo3kWB+8+nMiZf9TvodBJmD3YnBzudW0AJ/wdxoFf+0OYhSxJ8PUipmKNzMncKNl60y
	5mF1PxDJ6Vn/SIhnw9KytiAYjlTy7G0=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57R7u2I6001346;
	Wed, 27 Aug 2025 11:38:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=GvPGaxdFxq9DZKhJEvFptWToV1h5vI+MsJbT0P7eM2o=; b=
	beCezHKnfZdcDGI2tZpbQzWAB6ignRcGOWY12U12cK+nlVnwJj8+tf8xCjReiD9+
	amVcMgYbMkSV+kyYljdhnxZMcwHNZFp1enGKCPSauIHESCwW3dbPQ4DXEX0alNLk
	ZA7TWc4HJCMYRwHUUSF9DGDog+de6QU4W0M+LGKM10gF4kGn+2U91bsoJ7Euy6wk
	xkknTDJQuml/Q/65/qLrMEXodfqQzoc9C6rO8jPFd045NuB0klPyHj308LKXlVqu
	SsYNk0DCopJcqv0owDFoGYA3EhG7l008AhV5C34OPV6EQOUgUl1oYOEsd0elwwwe
	6lCXWaxs7t3guWd7zilXHQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q4e26b4w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Aug 2025 11:38:04 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57RAvfM2026715;
	Wed, 27 Aug 2025 11:38:03 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10on2042.outbound.protection.outlook.com [40.107.93.42])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48q43ag193-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Aug 2025 11:38:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KNXJ//7jlEWMtSkudXIt/QUu/UkajwIHipThaGPYqG40Y758fL8QCjHMQRTaHipWBn+VgB9Hp8SRmttMuM0ZtHMcJgy/XGJR/LLp9h8Dn87ITzpEky1d598rSQnTrKiHzsNVPKju/4MN9DMivIpD8KGkIcIsq1FS96elgR8aZqrH1jpRB6dHhC6ln4E5gndeb1ozfZq7ZXvsV/w8dCUg+3ZKOQE3htWeMw3ZioPQJwAMnoDPm8bIdka42m/VlbO8ee19lI33NXYfF+y0UyAQ1OiD4C+pNMapW18k/ajN4BFjnGeHbhXh6NopzQ/HTmA4Acxrh/RDmfo9LCtSR9fEWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GvPGaxdFxq9DZKhJEvFptWToV1h5vI+MsJbT0P7eM2o=;
 b=WSAy2zQ6qjamGx2iPgPjMUZFC+DNKn2xjly/U4+vY5Cunvs91eZudy6uladiv/ezoQim5/YutWxjfAnvLMNv52KmCskkwGZeaihh3LUvloVDkT5brpr2E/kePlfOvT9F9GUMUN8Ii1u5aczhzSUskApDyBsfsPVBIAIozWwpRHSX++LEar75FxnaJylp/tHp57fmjH/YyrlZ8XsncHKE6lzRk+b3qDLoMuZ4+CGCsScVu+APm8EtTdbIztuhPW7uLpzLVvSMvf89zFDQGmURAuCWBo4RfyWg3dMgSeEjLR4/8S/F/RFOv3nOCOV5Gj7NorejGzZlNUx0g1umby2Hvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GvPGaxdFxq9DZKhJEvFptWToV1h5vI+MsJbT0P7eM2o=;
 b=fOENlAoxdvjcrklYWogA/42+LcgwAFpMMszzyo2h2+aPFVAOBIgNp6brtlylHhl41XFgJ6cTtkD51p7k8AFtpcYX+wH2GS9S3u19xontt/YfceLDajj0ev4StkB3a4BEG6NoiwlWm70CuZf5tsM5INEjkb+lBosX49P09WieDlE=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by DS0PR10MB6077.namprd10.prod.outlook.com (2603:10b6:8:cb::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Wed, 27 Aug
 2025 11:37:59 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.9073.010; Wed, 27 Aug 2025
 11:37:59 +0000
From: Harry Yoo <harry.yoo@oracle.com>
To: akpm@linux-foundation.org, vbabka@suse.cz
Cc: andreyknvl@gmail.com, cl@linux.com, dvyukov@google.com, glider@google.com,
        hannes@cmpxchg.org, linux-mm@kvack.org, mhocko@kernel.org,
        muchun.song@linux.dev, rientjes@google.com, roman.gushchin@linux.dev,
        ryabinin.a.a@gmail.com, shakeel.butt@linux.dev, surenb@google.com,
        vincenzo.frascino@arm.com, yeoreum.yun@arm.com, harry.yoo@oracle.com
Subject: [RFC V2 PATCH 5/5] mm/slab: place slabobj_ext metadata in unused space within s->size
Date: Wed, 27 Aug 2025 20:37:18 +0900
Message-ID: <20250827113726.707801-6-harry.yoo@oracle.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250827113726.707801-1-harry.yoo@oracle.com>
References: <20250827113726.707801-1-harry.yoo@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SEWP216CA0122.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2b9::6) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|DS0PR10MB6077:EE_
X-MS-Office365-Filtering-Correlation-Id: 012f5541-ca76-4adc-5ca3-08dde55e2c55
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FoeYkA7+SntKTL9IYxz+qGdKe3oF9QC0w5vZynthe8yabcKgFx0q7tinajRe?=
 =?us-ascii?Q?4pVaqA36Tc8T7o1yNjKKmd1ORvd4cVWp+dgykAYUmhhRLaboO2OLE18tE88q?=
 =?us-ascii?Q?gjom1+Fh2V8jpA80pIeQjKlLT0ffUbAngUB88xtLGI+sPipKYyh0u6D/70G3?=
 =?us-ascii?Q?1apvdfe/ffLYKBRapmFEsTif6x2zoOG3N9l3lXGOy2lEGKl4uZ8/vcQ8Wtg+?=
 =?us-ascii?Q?KqsV6ItVeduer6H7D4gHPCwGPlIFt/UQx2yP6bfoM+0rL5syVZWHdWsljhqi?=
 =?us-ascii?Q?RRaDt02dhe/ud4l+D0WKj8ehq5velVRKbBmtalNfOEFABC5qiqI2YJ3mwfcy?=
 =?us-ascii?Q?WAOpRwO++FHOuIFf2Qymy54LBDkzE/33/h0gxpyQslWvw2VBKfHc3A9+mAAn?=
 =?us-ascii?Q?N3cZmGv3OWZQoxfRME6JJsHC1f8WrluEHAPXOl4hs/4mUBcKD1zi7BV1yRtf?=
 =?us-ascii?Q?TVG8zTJtP04vW28tdFo4BPy4UalVMQ/+PQN4QSH5nS3TeMh9sRF9sV48X9Sr?=
 =?us-ascii?Q?i+bYhmhbyyDq3D6Aj5DMwc2Be+bSxyRS/wEz3CieQoUPoQQ3ZsM2Ooc/UwBt?=
 =?us-ascii?Q?KrqjSxcVAp9vQ76ojflDXDOs+OLQcNRq1N30FP9aVWSkUDIyRSEa9nqx+LfE?=
 =?us-ascii?Q?4fvJR/amcIeYx7cjVVlMlMWCLMypFcvPNH3wum1xpm5me+3FzPChfiWGQ5hK?=
 =?us-ascii?Q?duCUSpxP6CXwShRdtm1ejqwGeBWZ5mRtTj7MasraV1oNgFzIbW7U7BHlfgrw?=
 =?us-ascii?Q?To1AEXBdbzu9SrkFLZqLcEzFN7xdnro8DrUoddW0FvqRQLaRU0fkJJHz3gMh?=
 =?us-ascii?Q?Y76IwJkyb8K9Q4/xujwuoPxuYcpakKQPAGWZ5aPJNhlDVaClm39demD53Z25?=
 =?us-ascii?Q?EeS6xAQJHK13vWpNbbWs0Prhd0T9GLclC22auBNACNhCqRE5/6Grzh/8e+ms?=
 =?us-ascii?Q?F/D/wNnGq2Syfgazkhy9HjCZ0Xk2h6gO0FYzzh9w+HRozsZ1CJ09M9x2xyeH?=
 =?us-ascii?Q?0qpKliJWv/CrMHUxzP082YgLGUblCAweVbCiNsH9em5wX3pGwKvBJ2e8Y0ZJ?=
 =?us-ascii?Q?iagemWk6CWHotcxLJM7+AB4oxMcCoLer1LT4yRxnoVNgv/CFyUHItOI7VPN8?=
 =?us-ascii?Q?3nMy2qvsEgEYX+WFvR1sQudtnbgta1cMDED1pn3cX+OlPkferIzx3vUd+PR2?=
 =?us-ascii?Q?0ZBf2tjggM7/mibAPPMzG+nFrhJtdkH1rCuRIK3caszF62Sy0BaD2VBaCFIo?=
 =?us-ascii?Q?HPMyesyLLxqaTYkQ8p8BPFYMCAQKQNZdQO0UGghJLDsLQdDRosRmzpRmzGKx?=
 =?us-ascii?Q?WUzt9xCzOKSUYX/n+OTXtGXdXgiyaaj4tA4rCCJCpQzNRljd6NMIA4+8F3rW?=
 =?us-ascii?Q?KwfVIbpERK2K/jXHrJpcue8qLvhl6CKhsKk8WNjrFTInWOXNTORdsMXuW7Da?=
 =?us-ascii?Q?iRJeSjaGTEw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hoCk0mgdXf/rhwpv2h2KsvNv7xYO7Nf2uTPKWwwGja2XsdviNa6+Xp+JgmrJ?=
 =?us-ascii?Q?HOkfCb2HGu6ZLzJZ/mju01o9DmrJzdJaAC4F6cfmk7DnQLUNycWK7oXFJyhZ?=
 =?us-ascii?Q?j4634vG6KNf7387wmQQuyXObkMMbLDg3q4WkFl7f5evfdpQ8aFNojVkFietD?=
 =?us-ascii?Q?6er2wj5Z/7+rG9asoPE1ADVl9I60sqJKXxYLyV1AwOoSF8JbRCnsmf0I7ZpN?=
 =?us-ascii?Q?Y/DnyIS+MJvKixJnOlLJmI4gsBbfh3P/NKr5Sxb3l/tpfhCqLsSktkHXliHa?=
 =?us-ascii?Q?C86CLdV/2NKaYUw/hZhZdx9Y04oF0U3SjSov8H3YEnCseKCLtTKtC0VLsRI+?=
 =?us-ascii?Q?R0Rw4EujQVUWs6df9Z4ugNXnAOnED+pkqhPSyVaMSlEgJPn4vJhxK8g4O28S?=
 =?us-ascii?Q?Fo0h2s0iFDEXOuTheu2mZJNJ66QsQ9LgB57lby0bbnB9ca86WDX12zeUYeB5?=
 =?us-ascii?Q?5ujr5FGjJMTrIuweKzMkrO0xcpB3jXeqSN8nFsf5YPUnWgHovgzQYdK87cF6?=
 =?us-ascii?Q?s4wtTXfHyLlcq409LrqV4rEAcP8eOQ84rLk8hJpZnYu4PLsHVoGZ7TB4ElKB?=
 =?us-ascii?Q?NWBOB5qm9wnNKZgR4QMU5PPLUN5l1jwhEKb+QGS/91kQTmVZbQYSTwnWVWH5?=
 =?us-ascii?Q?KqP0u/E+WVvIzxDVL9Up1FCDndCP/ck+6slEcis/QrEzjPFPEWiSEL7aCjHa?=
 =?us-ascii?Q?yZ+rN+5rKVUyC5Ix8Fm+3gmlNf52LxXG0MkTg/VWlKliQD4WW488fjzm6Mg4?=
 =?us-ascii?Q?L8bztQuxjQmlY5JFSPLI/1wc7L817DtXm+gtVd8IVZc+6F1O5x8GZQuAvLm3?=
 =?us-ascii?Q?CSH2a1JBs7tJZXysGvrsvlF8roGQ75+Qv1k50MjS5Wmlcg6ASuA7V/ghrAYG?=
 =?us-ascii?Q?7FlNVCJSMSBXCF+dAemjnDclYr42tWCP4H5rCwkqV0u5dhnW+0r7You1lGU6?=
 =?us-ascii?Q?YL+JtrxLv133ZyxogHTtyzW0QwSB6i9l6SHTUsDV8QWmTiK3RZeok73PJpjD?=
 =?us-ascii?Q?pFew+ECA8pmEcY9AKEEZv2Fdjk3X+6vcksRROMz7rlH060W3xCd6EYqZn09F?=
 =?us-ascii?Q?jVMDG1UtjEfjF1bf3bQfRGpEwBhJ8/Kz4OU+Y8ke6h5cUANA6By31lNSWEwU?=
 =?us-ascii?Q?GZy782+UAdrWzcaUKuUr1WSrfFKX4ZSlBLInbsS3Hb9XSMrpgnvtF3p8y257?=
 =?us-ascii?Q?s7EH84ZIdo6SpmG5NRmFKmWJc9eOxDMoDHUhxcTPpeW3Ajkj3J6Cpgwc15aA?=
 =?us-ascii?Q?CMX12qUFkdxS2u2GuQnojHofaBY7qc12ax3g/xXGr4nzAy86sEztDdex4SWz?=
 =?us-ascii?Q?UQ76Usb4U8mGmhQyBgLC7d0wAbuZm6TEU5reWhTLZwhWj6A9f0jmoI5jllUZ?=
 =?us-ascii?Q?uO5vt/h6lEp8IfJr34WyMRrAC975SY+MnpYiz98zcFrZLZAxslhSTfv8TKE5?=
 =?us-ascii?Q?15c0JPF8tbeXyJg22BKj28hN0JDVJSuX+rXLGrm5i5yMbw9TIzR1pWGdvsVM?=
 =?us-ascii?Q?EDFvtTisAKb97FDoTG3eWZMHWHqT1Tuus+8D7FNR/FMgEVYM1iVVKCqnL/kU?=
 =?us-ascii?Q?4fU2N78mcOQS5gIcQF1Plcd9nuL33YtK4R4hpB6W?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	zZzICwLS7QURT/k2e0MBaAluJgEHUFMdF92uBDsRHjlvusvb4X5n5gqnNLeQDE+mpLFuoZ+JalzBtaTcxo3spzeX5IRwGUhIOBlsx9rcKfJ5UCCCwFqj/7pm+3cUGNEQHbbTbvO+bhYvPHINPxRQUA6KSSCM6iiSZFBbEwiye0PDklVA3O0oyOteimPlBDtUKJiF7ce0/1RIz1L84HmbR5UW11XcZYdWochAI6q+AQeviT+B+3kHtJy0nmt122e17wXTn8ESbetCY0gM2A+csZs5Z5BHRQ4kj5Ze91KsLlWI8eWqoo+j8btwwcPiez/cjFiEn4LkKTfPjg219mi3HZ/kJccG1ljOrVx2bcidEfXyTr4ic220vcyIvVTRW68Mv/Y584yKOnlkrY85QF11mW7lQWfoW6MP8C4ZLvTIrhHmXzKDvkLkUBLm1IKN2iFqR8z0H5NXhDSrN5qyDayyVlaIIfPAK3DN+YvJkQLma+NAXu45SLtds6373kSfzcoiHtfO4re8OelBUV9qtlKVSLthasmKkBzGIsjQ8TRkdMpMK94LZTDmOaonEjacc6qAqlyNCjPpiuuF4Tths5mAmayIoLeMy9Js/WsJkwWVhl0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 012f5541-ca76-4adc-5ca3-08dde55e2c55
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2025 11:37:59.3049
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 58FnpL6NZMg2pXc7IfSJaOlK9F4PogStlXQKEwcF4Sb9hUy18JTs7tt21QPAr9Vxb4FeO+cbjWGIdiaYajZDPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6077
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-27_02,2025-08-26_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 adultscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508270098
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAxNyBTYWx0ZWRfXxQtBtq/KExfy
 e2onCpNuik3p5JeLI9IQ2UVuCLi3QDYQy3Ynp27yWMAzWz1AsjZ+S3XvsvQle4Y9r31ewsqBkn2
 2u8rnQI6uDLy0Fgv3sqjThNAbqwZkI/XYMUMSUwQtGR583TwqewKAqcFzCFpInuYHn1qAyOkR/7
 0tOHLyKhALjof3WfnHVDBMB3kxMABaeKlqiZChZ6rwHDK+8z8haPexKeXD/ommxlHU3v5YGMqJK
 wGiwI5ZQxJgLeLVhYK6CF34idQGeXsSX0t25nxmHeOKEGXHIS/2RvTP3Y/LhJgagbt9ReejnqPs
 yG58b09DoMTFvoC2UP84Id+xwj9h4queOb9CfsyfWglCVo37yQWlwI+zOdi/34TTArkRGwgMraN
 TCZke/u1
X-Proofpoint-ORIG-GUID: TGsf1l8rYGIs1mqcOHaNEuXT4s1MVKWW
X-Proofpoint-GUID: TGsf1l8rYGIs1mqcOHaNEuXT4s1MVKWW
X-Authority-Analysis: v=2.4 cv=IauHWXqa c=1 sm=1 tr=0 ts=68aeee1c cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=2OwXVqhp2XgA:10
 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=lMPLp5VHBhqu3uUK-QgA:9
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3E3C21C0012
X-Stat-Signature: 8u5ndy1so1kn9xyxpskhbgrcm6mecfzb
X-Rspam-User: 
X-HE-Tag: 1756294693-211492
X-HE-Meta: U2FsdGVkX19tS4usYOhZEYBizcShcJlkJGcwBeeOGdAdnh6EcRJ3GiSM3L8u5GEWYe8nRUU1utq7RJYBTFUhc2fXmHnxrebFZkInby7/NGNMnX/0ZITFMLFwc2NHoqdXN4tVpMZS2V8XQGYKlf2Nb+oudh6AS8lRRvXH5yPuE10MrrI9mcZVh0QKzoRx3gydVi0gNSY/6t2n4ENboOa8h1WU/iFgzfmnV9Db8OU3AR1u6PAGmhHm90jYP4oAHOmeNG9mB2IuYruQCApzsN7+JvEd9WO5qNvL2vmTNr8dVzwNTb3I74NMMKCpi8i66xQFg+FwiXe8R9xMzV5L0DOyiB4flx8GzvDRMFCUZdDI89GkNFhtQz6K0XbCoBlx/h0UmSKGEDkECGL7bgX9uaMqu5MXsVUeePun0hbq9dfJ7BLJYUB3wqeUoLXex6cpyQ9RgdBdar9JdwavUPQyXqmS5bc2z5bXuRsA+iidUPbC7H6poPv/0iP+YArfNKBzFpKlAQdd1XwAb9PAXw/1CN/ARRVNDXIq2g8a81DUNMB1goK8katD8DFBzsxPt2kXF/zpo8sy1h8jUjZg/61+48J6Qyf3dR0TO6zDnPPQ4hu0MTUK1ZqOr6l0A4bbwLvI8QoloFUPu5eN79RsdlZJZSC4rSI2zrAuVXvshwKtzZV8CwkDeH7Ycowua+kMiv75DU6xDIMyQtw62FQjA3wZdinrREQd2n4dxT1hwkv1cqybQo/V/6U8X6WVcHLfKPjq/GxvGaTmJ/RAOqefhpOxIYvjza0zFB6Va7Ix5a5E3xo3p2gyoqDOFfVeOoMCOK9a4uj21Q4S8h7J/MVFyrXWxXzMyLV1hbt10Yzd1VO0Vx7Exyx5Ed+phVeMq1H3/tOHx4uAY2mFiInmOBkh3suA+WH4RD3JuxjYYndK80zqEj4psOc4X5uE9iIPTpRlldu8u08KMDuCZ9/bbK2/3L+yYdl
 CmjOPEdi
 MX6H75EbiSGA6BZqTI3ffwtWzaadaoMJE1L0GqURFqSGpDSLy6gCKQrwh8z9pzw9/gyb++YI1O57uArLw1HPR4fC7s33BpWIIu0eJ+KqE8P2zYEUeY+d/0VSM9SFIww3nviDcCsqDuGtlgKgFB7wfgMnQ+Pk3bXDbqt6l5NbVxPIThDkmfnIau0lq6PdLwFwyj3E1CO9w3Y+HsebyNTokg5163HGqxlt9SXlsRjc1ijqJ+2vwugY8wBuMiFR1xELE4tx1SwUK9kycN8Fvv6MFnyf1HYsd4LGyRZgGM0N1hln/7kezcAQst+jLh3rQSoc7ROZBEPdqyT+r+sswX0DnqvccZbXbYv/Aq7zljoFq+KiJmXWKKdLKZBaVWvRoWvvjWIdm2jun2BT1ikwlDslHRuK/R3uKsBsNJwE6hU7O1xEdrjwIOk4XCL/w488g598hZ5ov9w99cJUO8CVgL6cY97XQ/zZg05fhXOVAJoBebOPhIo0QpQ08Vvogmjh83pBg9d3VO/tAE5hqt2DZU8reVnbGt6WTkrTOQ1vgbcS63dMR2cDV7xXzLz4T/N+YXixt+4CtpBc1MmlhPI/J5dZDg4XVydeih6yjp0zzJfOmjMzH7dCXXapqZ4ffAjc2gdC7SOc5aq3GEoFCbaHiPBwwnYkCP/DDVUTKVrP5CEpHethuDY9C47bbMJLtv9lIT31ya27VEja2jVNSJoJClXjYZ8YCa4QPct13TbABD82SSjR/HCrWJDVPAue3zQ1VOkU19TKvJLdqFg5nmRlj0HynPloBZ+JRQ1KQYsvXNjcOEuIPy0jeKM1sssG8j9ZRSb1SFih5fMkW0AINIA/mnGLneqyEDil4S3f8/OfV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a cache has high s->align value and s->object_size is not aligned
to it, each object ends up with some unused space because of alignment.
If this wasted space is big enough, we can use it to store the
slabobj_ext metadata instead of wasting it.

On my system, this happens with caches like kmem_cache, mm_struct, pid,
task_struct, sighand_cache, xfs_inode, and others.

To place the slabobj_ext metadata within each object, the existing
slab_obj_ext() logic can still be used by setting:

  - slab->obj_exts = slab_address(slab) + s->red_left_zone +
                     (slabobj_ext offset)
  - stride = s->size

slab_obj_ext() doesn't need know where the metadata is stored,
so this method works without adding extra overhead to slab_obj_ext().

A good example benefiting from this optimization is xfs_inode
(object_size: 992, align: 64). To measure memory savings, an XFS
filesystem with 6 millions of files was created, and updatedb was run
within that filesystem.

[ MEMCG=y, MEM_ALLOC_PROFILING=y ]

Before patch (run updatedb):
  Slab:            8409212 kB
  SReclaimable:    7314864 kB
  SUnreclaim:      1094348 kB

After patch (run updatedb):
  Slab:            8313324 kB
  SReclaimable:    7318176 kB
  SUnreclaim:       995148 kB (-96.87 MiB)

[ MEMCG=y, MEM_ALLOC_PROFILING=n ]

Before patch (run updatedb):
  Slab:            8081708 kB
  SReclaimable:    7314400 kB
  SUnreclaim:       767308 kB

After patch (run updatedb):
  Slab:            8034676 kB
  SReclaimable:    7314532 kB
  SUnreclaim:       720144 kB (-46.06 MiB)

Enjoy the memory savings!

Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
---
 include/linux/slab.h |  3 ++
 mm/slab_common.c     |  6 ++--
 mm/slub.c            | 69 ++++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 73 insertions(+), 5 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 680193356ac7..279d35b40e8e 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -59,6 +59,7 @@ enum _slab_flag_bits {
 	_SLAB_CMPXCHG_DOUBLE,
 #ifdef CONFIG_SLAB_OBJ_EXT
 	_SLAB_NO_OBJ_EXT,
+	_SLAB_OBJ_EXT_IN_OBJ,
 #endif
 	_SLAB_FLAGS_LAST_BIT
 };
@@ -240,8 +241,10 @@ enum _slab_flag_bits {
 /* Slab created using create_boot_cache */
 #ifdef CONFIG_SLAB_OBJ_EXT
 #define SLAB_NO_OBJ_EXT		__SLAB_FLAG_BIT(_SLAB_NO_OBJ_EXT)
+#define SLAB_OBJ_EXT_IN_OBJ	__SLAB_FLAG_BIT(_SLAB_OBJ_EXT_IN_OBJ)
 #else
 #define SLAB_NO_OBJ_EXT		__SLAB_FLAG_UNUSED
+#define SLAB_OBJ_EXT_IN_OBJ	__SLAB_FLAG_UNUSED
 #endif
 
 /*
diff --git a/mm/slab_common.c b/mm/slab_common.c
index 08f5baee1309..cbd85eecd430 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -43,11 +43,13 @@ DEFINE_MUTEX(slab_mutex);
 struct kmem_cache *kmem_cache;
 
 /*
- * Set of flags that will prevent slab merging
+ * Set of flags that will prevent slab merging.
+ * Any flag that adds per-object metadata should be included,
+ * since slab merging can update s->inuse that affects the metadata layout.
  */
 #define SLAB_NEVER_MERGE (SLAB_RED_ZONE | SLAB_POISON | SLAB_STORE_USER | \
 		SLAB_TRACE | SLAB_TYPESAFE_BY_RCU | SLAB_NOLEAKTRACE | \
-		SLAB_FAILSLAB | SLAB_NO_MERGE)
+		SLAB_FAILSLAB | SLAB_NO_MERGE | SLAB_OBJ_EXT_IN_OBJ)
 
 #define SLAB_MERGE_SAME (SLAB_RECLAIM_ACCOUNT | SLAB_CACHE_DMA | \
 			 SLAB_CACHE_DMA32 | SLAB_ACCOUNT)
diff --git a/mm/slub.c b/mm/slub.c
index ad9a1cae48b2..6689131761c5 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -937,6 +937,26 @@ static inline bool obj_exts_in_slab(struct kmem_cache *s, struct slab *slab)
 	obj_exts += obj_exts_offset_in_slab(s, slab);
 	return obj_exts == slab_obj_exts(slab);
 }
+
+static bool obj_exts_in_object(struct kmem_cache *s)
+{
+	return s->flags & SLAB_OBJ_EXT_IN_OBJ;
+}
+
+static unsigned int obj_exts_offset_in_object(struct kmem_cache *s)
+{
+	unsigned int offset = get_info_end(s);
+
+	if (kmem_cache_debug_flags(s, SLAB_STORE_USER))
+		offset += sizeof(struct track) * 2;
+
+	if (slub_debug_orig_size(s))
+		offset += ALIGN(sizeof(unsigned int), sizeof(unsigned long));
+
+	offset += kasan_metadata_size(s, false);
+
+	return offset;
+}
 #else
 static inline bool need_slab_obj_exts(struct kmem_cache *s)
 {
@@ -964,6 +984,17 @@ static inline bool obj_exts_in_slab(struct kmem_cache *s, struct slab *slab)
 {
 	return false;
 }
+
+static inline bool obj_exts_in_object(struct kmem_cache *s)
+{
+	return false;
+}
+
+static inline unsigned int obj_exts_offset_in_object(struct kmem_cache *s)
+{
+	return 0;
+}
+
 #endif
 
 #ifdef CONFIG_SLUB_DEBUG
@@ -1272,6 +1303,9 @@ static void print_trailer(struct kmem_cache *s, struct slab *slab, u8 *p)
 
 	off += kasan_metadata_size(s, false);
 
+	if (obj_exts_in_object(s))
+		off += sizeof(struct slabobj_ext);
+
 	if (off != size_from_object(s))
 		/* Beginning of the filler is the free pointer */
 		print_section(KERN_ERR, "Padding  ", p + off,
@@ -1441,7 +1475,10 @@ check_bytes_and_report(struct kmem_cache *s, struct slab *slab,
  * 	A. Free pointer (if we cannot overwrite object on free)
  * 	B. Tracking data for SLAB_STORE_USER
  *	C. Original request size for kmalloc object (SLAB_STORE_USER enabled)
- *	D. Padding to reach required alignment boundary or at minimum
+ *	D. KASAN alloc metadata (KASAN enabled)
+ *	E. struct slabobj_ext to store accounting metadata
+ *	   (SLAB_OBJ_EXT_IN_OBJ enabled)
+ *	F. Padding to reach required alignment boundary or at minimum
  * 		one word if debugging is on to be able to detect writes
  * 		before the word boundary.
  *
@@ -1470,6 +1507,9 @@ static int check_pad_bytes(struct kmem_cache *s, struct slab *slab, u8 *p)
 
 	off += kasan_metadata_size(s, false);
 
+	if (obj_exts_in_object(s))
+		off += sizeof(struct slabobj_ext);
+
 	if (size_from_object(s) == off)
 		return 1;
 
@@ -2236,7 +2276,8 @@ static inline void free_slab_obj_exts(struct slab *slab)
 	if (!obj_exts)
 		return;
 
-	if (obj_exts_in_slab(slab->slab_cache, slab)) {
+	if (obj_exts_in_slab(slab->slab_cache, slab) ||
+			obj_exts_in_object(slab->slab_cache)) {
 		slab->obj_exts = 0;
 		return;
 	}
@@ -2273,6 +2314,21 @@ static void alloc_slab_obj_exts_early(struct kmem_cache *s, struct slab *slab)
 		if (IS_ENABLED(CONFIG_MEMCG))
 			slab->obj_exts |= MEMCG_DATA_OBJEXTS;
 		slab_set_stride(slab, sizeof(struct slabobj_ext));
+	} else if (obj_exts_in_object(s)) {
+		unsigned int offset = obj_exts_offset_in_object(s);
+
+		slab->obj_exts = (unsigned long)slab_address(slab);
+	        slab->obj_exts += s->red_left_pad;
+		slab->obj_exts += obj_exts_offset_in_object(s);
+		if (IS_ENABLED(CONFIG_MEMCG))
+			slab->obj_exts |= MEMCG_DATA_OBJEXTS;
+		slab_set_stride(slab, s->size);
+
+		for_each_object(addr, s, slab_address(slab), slab->objects) {
+			kasan_unpoison_range(addr + offset,
+					     sizeof(struct slabobj_ext));
+			memset(addr + offset, 0, sizeof(struct slabobj_ext));
+		}
 	}
 }
 
@@ -7354,6 +7410,7 @@ static int calculate_sizes(struct kmem_cache_args *args, struct kmem_cache *s)
 {
 	slab_flags_t flags = s->flags;
 	unsigned int size = s->object_size;
+	unsigned int aligned_size;
 	unsigned int order;
 
 	/*
@@ -7466,7 +7523,13 @@ static int calculate_sizes(struct kmem_cache_args *args, struct kmem_cache *s)
 	 * offset 0. In order to align the objects we have to simply size
 	 * each object to conform to the alignment.
 	 */
-	size = ALIGN(size, s->align);
+	aligned_size = ALIGN(size, s->align);
+#ifdef CONFIG_SLAB_OBJ_EXT
+	if (aligned_size - size >= sizeof(struct slabobj_ext))
+		s->flags |= SLAB_OBJ_EXT_IN_OBJ;
+#endif
+	size = aligned_size;
+
 	s->size = size;
 	s->reciprocal_size = reciprocal_value(size);
 	order = calculate_order(size);
-- 
2.43.0


