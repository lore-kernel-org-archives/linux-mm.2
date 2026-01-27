Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87795D2FEC5
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 17:31:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D517C6B0088; Tue, 27 Jan 2026 12:31:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD4B16B0089; Tue, 27 Jan 2026 12:31:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B56BA6B008A; Tue, 27 Jan 2026 12:31:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9F8D76B0088
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 12:31:46 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3E4BE1602E2
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 17:31:46 +0000 (UTC)
X-FDA: 84378436212.27.DDD6A8F
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf29.hostedemail.com (Postfix) with ESMTP id B9A6C12000A
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 17:31:42 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=XtNXojkI;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=eiRaVYsf;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769535102;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RsviRwB6GoLMRBWD6fxGcQGEWBFvmyKp5z2JdQrzqHo=;
	b=dS511m+NCT0a1RXMd6nNpXwROI8OfNZbaG5wyeA+7u7KG0fp/m8CnzxUUpUAZ0MwxXV66J
	aj0HztMkGlXuRPuXARAj61fCmbziL0xY+kGK/R9dF5x1gQx/WSze3W3UhKN+C92uJ3uZxU
	c0N2HU6gtP0azvLYaOfvjxJp/Q1tRoc=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769535102; a=rsa-sha256;
	cv=pass;
	b=eZNXPZo+DoD8dRbo8E7RGC8fQmHNHCdCTQwAm4n8qEY7y8qP8EQsK9g7CPnGAk0rOXFik1
	Htbqpaz/LngaUYjRhfV1MtJgXRbJaWICaRMJHanhok3dPvnS4uhCkn1Ll8d0g0vQXI7LPI
	6Eg9qD8kVZEaB87KsMn0BnphSM9oM0A=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=XtNXojkI;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=eiRaVYsf;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60RBEH9K454905;
	Tue, 27 Jan 2026 17:31:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=RsviRwB6GoLMRBWD6f
	xGcQGEWBFvmyKp5z2JdQrzqHo=; b=XtNXojkIEbM1NNFLzf+OgE1wmNDOI+RayC
	zQd/HwhDY27PrwiWjkOpdkeAEVabpX+iSH54BZIrlIoicXtVIcBtUSWvomoG++ho
	VAorFay6IoTEXiKD8wYWdVj2hNmM6iaoSHmJG/ohZR5idHr8hUeZEA4kKpCYIWEk
	FMxGoeSe7bhY/3e+J6Kzx+1V1eb21o07yCgrTlVYmcWLHeqTn0/yR+ME3XS0/sI5
	m8zjqbWPMBecT9M2S+c18ow6ogkxbnlKnOtobhoG0z//tqZ8K/St15aSffcb80so
	dCkW3HgDY7Kmy8kUH6xngAXoQWPet/dO8AcBV+K+WTxjKIoT9BhQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bvp4bvgnj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 27 Jan 2026 17:31:35 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60RFxg7f020098;
	Tue, 27 Jan 2026 17:31:35 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010015.outbound.protection.outlook.com [40.93.198.15])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmhf1dxe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 27 Jan 2026 17:31:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tJy56oHUsHgUMAYNUAyFKkUfZg8J3z4TYZc9lAF6LMopKD/LDb2qDFGNDoiqjll3kNVG2f7yp4Ue4WJuv3+ceCknmcixERfH3tA/rQGGuNpZ4I2qqgY0U+clXP2rcyabqFRmi5PzIzwwgQVbNuJ4boW+Uo8m4gEgj/CtDkZfevHbDqgq1O/EQMx+GnHUCd1nmgzaBhvGOLbIjPxEA76hxgEZnBwJNLWT1XvCh4osdzHDFUPlWkTzShGrFJIYNNSYPY+YLa/x6hdWSSbESA6gxwRDcFYqkxS/cJWjGnmqaEpjvwQI6BrC+wxkzw4NXX/EKBUFi6Il0K7nfT6kWU8pwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RsviRwB6GoLMRBWD6fxGcQGEWBFvmyKp5z2JdQrzqHo=;
 b=hWMz3maGLMxiKIgk78SbmxZU9V847Ndcv7VQx+TQIOKDZ/4CvZMtcHiph7OK+8DH6fEHcgKn0YJ48i0DIkT3Z7u4QTQ3+5Ctoop//GjcLhEQVHhuvajdUwSXZBAfkHehGMES6VBCrZA8B4jToDrImB0s2daOIusVwE/BrgpxPzokT3rPseUirpo6FqUMqMckIx5wMKj5BRzo4St43Osq33LI9vg21jFxEJ8WRvAJzmd81XHou5udDQaA4UK7BaS6apjHkp5Gc8DM8P/V1cfhjlz2a/0ReujZwu3/FG+Oxl47Tytmbc60bjP8XRWyx7GKIeaWoUTv7HP4oONLJcn+wA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RsviRwB6GoLMRBWD6fxGcQGEWBFvmyKp5z2JdQrzqHo=;
 b=eiRaVYsfH2RSBbZ40b84SEMqhNdwLO0Rr7fPVy8JDsJZyxP0KEAYAytBTB1r61EovPevEPf6xds96EMxw5j0OVhT72Fihdw+8hdBUsq3vIY7WviVvwcLBTLm2Hm79dHV/8L8kcAW7lKbq6zzwjsTK+fYIvqFY8KUkJeLfU78rSI=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by PH0PR10MB4421.namprd10.prod.outlook.com (2603:10b6:510:33::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.16; Tue, 27 Jan
 2026 17:31:30 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9542.015; Tue, 27 Jan 2026
 17:31:30 +0000
Date: Tue, 27 Jan 2026 12:31:27 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>,
        Uladzislau Rezki <urezki@gmail.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
        bpf@vger.kernel.org, kasan-dev@googlegroups.com
Subject: Re: [PATCH v4 07/22] slab: introduce percpu sheaves bootstrap
Message-ID: <dk5mggvowqulzlbv7o2n7ha5p4adq5uzh5i4d473jjwsyivi7l@lvlqxz4si37f>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>, 
	Petr Tesarik <ptesarik@suse.com>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Hao Li <hao.li@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Uladzislau Rezki <urezki@gmail.com>, Suren Baghdasaryan <surenb@google.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, bpf@vger.kernel.org, 
	kasan-dev@googlegroups.com
References: <20260123-sheaves-for-all-v4-0-041323d506f7@suse.cz>
 <20260123-sheaves-for-all-v4-7-041323d506f7@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260123-sheaves-for-all-v4-7-041323d506f7@suse.cz>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: YT4PR01CA0449.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10d::21) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|PH0PR10MB4421:EE_
X-MS-Office365-Filtering-Correlation-Id: d58c1a1b-b45b-4961-9792-08de5dc9e8a9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?pwX3QpS/R5iSOF5A76mGS+p+4ysykxLDs0XRfgetbENF35pEPeheStWLFD2o?=
 =?us-ascii?Q?ezuCIxuvUpSlB1/Nwj2Y0FHjeZxXlfwvNziUFz622wXS9GGxkN3x6rfSjuMj?=
 =?us-ascii?Q?/dSSl8P8pXxdZY67K0Ip1+Gd/+YNSEdZ1kMvGM/KSTOVgZzHsCB1WMRI4i8f?=
 =?us-ascii?Q?LLRSjn2UR8Teq3NxzA5VaLwR1Pz3kPKpNE7cWi6kb3HroDjK2xPil4kjPO7r?=
 =?us-ascii?Q?dZ67LyUbB2j/8xS7Qq/0zGz06J1ERmsEWjgwWoAI2ERkLGOjSFZHt4J7cCay?=
 =?us-ascii?Q?pJ2sxqoBkSJ7RL4fdXgqIV+GxmJCjHuq7CM1FK56qZ8m+37QgBWohuge5Ti5?=
 =?us-ascii?Q?AnVVBs6av3WMkmPEmrlg3HTu8pVAAAWlWfJ6VAUycRpOB9vHtD+P2bPgzvcU?=
 =?us-ascii?Q?TYMJ0kYlOUGMKUBmyyv6P0unKpCfz9t/EPfa6+R4UgI1pO08YYvka2by5EA6?=
 =?us-ascii?Q?A2j8p7hcbvvbLxPjpF0M/0yjyagySg9Tq6GRj+W4BHxDFQv9DBaOB5AJusll?=
 =?us-ascii?Q?kW+BniXoRwML6c6dfmyMjyz3mZfKi9X7JSxdesZs18kkWJAsHfUk0oKpRHCE?=
 =?us-ascii?Q?XzW0uQJ93ciyBrIdRb4k2mrWIiG1pn8xdqRJpt1AMdMxd9iBTY7fwyqbH+5Y?=
 =?us-ascii?Q?ZmtoHQ/yIt3N3arlVjhfWb9gdpZn5A3fMZuAFXTaURJ28zNzt7CUlkuaRvh8?=
 =?us-ascii?Q?0zuyInG3Za9+t83RX9F8VGVUphq9iGH6SQ6W2zznhCuf7ddthOvtbbS2nzsJ?=
 =?us-ascii?Q?SYMgotYBzJzUTd3hJ+NuooSLYo0qpXoGkBC3gGdTSAankdnY05Xk0Bcty+80?=
 =?us-ascii?Q?uX+rvsP/yqrA8w8ITuOYOM5H6LAK4gya4sqFIff8DtMG7BV/9himWMvMlKLR?=
 =?us-ascii?Q?/LHzY2+TIp4vFyZdqSRMn42ZerV0YQB4aeOrED/Ht6krTJMM5ac4u7BQcHnb?=
 =?us-ascii?Q?LOv6BsIRsa3se98uCn4UGW23L7Au4gQ5cQARQ5KcgPTemFEDzUdxkpcSGOdD?=
 =?us-ascii?Q?TiUnL/C6EyAsIk+oDMjkNt7HS1MZr8rdyZuBRCa7ulsB9P5rAHzu2ePrjO8D?=
 =?us-ascii?Q?mTfnMtroz07JP5fcQsEoAaxIbAPwNcAiXS+Qb0ybPfQG99ytCqSKWoxjolla?=
 =?us-ascii?Q?xa/6DaTjtkyqul5ScGsHRpKWfWnwIzakp1T09aaSnE1dNxxg0d15//CcQl7Q?=
 =?us-ascii?Q?KALeRp0g+CmrfnqsQhLdn8RYz4pCbUzAkNW8osTPi9asddJ45IIzMChnf4N4?=
 =?us-ascii?Q?IpB2Kqg7WXGyzckY+U83WY9ZPzmVR92Y6N97/zeQxxhJUEwfL5hjEsc06TkD?=
 =?us-ascii?Q?niaJmXrzm3cdDmw7LAHXmbRhIdzNaVMBBDuXyxxLXR9WjKq+T9yRAOL9CFG7?=
 =?us-ascii?Q?GGoJU+BGiSE/dQa6V11I1tyebnfm2ME+WrnW9xJKMkmipxv4Ly3CJeqnDm6a?=
 =?us-ascii?Q?2afg7TwNobbqrx+h6tFR0gdJB85kYJl2BGMAwSJgaCviE+slpZuVBybEwGMv?=
 =?us-ascii?Q?P/7imkphCH5vhiCCd57pCDqVoSbKxcH4u7H/UOpv94wnTgtvRVDFsvJ2Yiy3?=
 =?us-ascii?Q?uZCP8Z0WizBafNv4q0g=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ehWNEnNhODc7mGnWsaPCYRMIpFVP5YiGG3nZxQkG4r4wN0fKM1uJUV0gN/nV?=
 =?us-ascii?Q?O9BCeQK1remOWYKGmihceknExEnDNFrEHh8rknSI/ImoXNYgzV+o973A0QmH?=
 =?us-ascii?Q?DhBaCWjj1Pwn+XrFGQSSsJIGxQ0AGmZMrlbhi2qQ68UddmM1OQAiF+Idkmn6?=
 =?us-ascii?Q?2SPqWOcQZQyRJzZYxzHdtPWfAlzNWKkl284wK4Jsmo2fesiuHak/NOTXwKvL?=
 =?us-ascii?Q?iUH7u77HrOsFbnlOnOMNHRehmwWP/JNqxP2RDnLyozazYOIrDOR1GgaRDwiH?=
 =?us-ascii?Q?DEyp/k5RUxdmPwsklMlPfdeinwnzwKErsQaXuPuL72b+849NASrEchi5i6u0?=
 =?us-ascii?Q?18Dl74WOe2VGWjFpuB7f9mCc6WwtqIMZNTAXBSOnIeHQXghqscO9ScIbSb/P?=
 =?us-ascii?Q?BSISmhB8KJS9kU6R776GcrN+RWIO4JgOhNWIHFDSk/BRHoudxCFIAuv0GQo0?=
 =?us-ascii?Q?mZsPw+P95iXLdIh/8LnnNTP2TVfFa/D8dwHSXX4sJ5RqbhCP69vIVqvwnDnl?=
 =?us-ascii?Q?mA5YJWC/mwHWVoJefiX0JVZmKeW1PrK/6swnLLm6ZNZYlZ/GLu+Dm9qp0sh3?=
 =?us-ascii?Q?IADmydvP4nhMqu67zA8MXFXTyUP/TfhrbCcD3k4DdGIjk3Mt/MczfoKRBl1c?=
 =?us-ascii?Q?16WKm7pt15vwTWRjvtmclVkHSARqYCeleIEWI0kKtYPpxHOWTKsX6ipLhLZu?=
 =?us-ascii?Q?GPsPqB1dhOMV4Z8z3hFqFi0TJkd5FnTOzrqayDYM3qf9A/BsjmEtJX6YDzR5?=
 =?us-ascii?Q?3HHGUfqS52g1AhlePM4sskDX4G2VfSQRHatE5yyhPFe0meuuFZZhwePzfjcM?=
 =?us-ascii?Q?phNYC5SDuHn1u0vmyrMDzdlT6bHHSolOqS2KR2lFkGJzdwcrBEQw60Gla6PJ?=
 =?us-ascii?Q?3XOI2u89SqbBOWTwsCYJPO4ug807mEy/6ms8ruuwIarSDn/AWZxVqNIncMD/?=
 =?us-ascii?Q?N2Ac0kph8Y71cX1qYGEOu8BHDLelJFYDpwKYDb9uwbr4LV/Ve3rcwm1tp4vs?=
 =?us-ascii?Q?gTHooY0XWr/eYrj3TKUcgfC57zZ2FCC9M0IIMlSf06GOycvBp9YnvCPw5KDQ?=
 =?us-ascii?Q?0UuojphNhfIL9QDo2alqv4KikO6TsmSpaAzhZBQInhIA9ESHL7gDK3wDtze2?=
 =?us-ascii?Q?Xivzivb+9th0/b/sktculYXzj4qhFAFJmHt9KyDv+8JUcwKTLz+E2cwr+2xP?=
 =?us-ascii?Q?Gu2EBdTNB8NncKB/j/m9HeXtv8tzmfdzjkN4rRuiORZYH57XTyj6mdBdk5bN?=
 =?us-ascii?Q?8b00BVWp0QYRM+qJpLfwv/Fa3p2hc6eCeFllPA6Gngrnq7Pt2RUrCSbjt0wS?=
 =?us-ascii?Q?226frSgSZCC1C08HD3s2qfQVMQV7lUK+T7bjCd/+FG6iqyC8OQ2lTq9A7HJQ?=
 =?us-ascii?Q?6FXtNgH+d/bpdsF+iFY/l2ei2yU6p3i3QgUVumdMm+DpY5X9qXCMjx40XHzH?=
 =?us-ascii?Q?W44nSlliPbwF87tpvXvOVI6Zr4SdQm/Vz1NoZwhtwKx6ZucOK8jyy3OG8B9C?=
 =?us-ascii?Q?OdlBq1HTSbb00O+b6r/GjyMaia+B8z6UEK1f8cqqmDNJtvm7vv9fcB2PPjVX?=
 =?us-ascii?Q?3jfeUAw8lzH0ZfKz+fr60XesGo4N2gF4/J/hOhK3QY7gAoLiLC9hQWC+ZE5a?=
 =?us-ascii?Q?aCZeq1We75zkMG0Q9OBYXB4KrRl10ylQy0RtYD4MjDZxY3q6AMF9voomUtPD?=
 =?us-ascii?Q?w6+NSmttQ2s35rUaI8sYzyjGVZEX2rACM/tjcjaNtgqtc/zCsDJTpXVe1L8D?=
 =?us-ascii?Q?4tyW3SJtcQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	dW+8kAY57URflg9d8qZ6uBCClr19vz0u35HEur9Btbv5QGhAj5D0bfPTwfI7XWpMM/1PUwzYhiQNdjWGQQe7n1Xf27CVifcjkxeWH2J1WDy8D73m4clZD97Yl/1QILXtITmqde4mVC4tEk3HVovUVTGHrDDqmGIFJcqIWYaS0MA7BMCFtaBiGQBA3U8sKxtQN3BDeMq60zNM067GgBR8gX8aAzfMAYRyTRv4T41xm0rEXEjMdQ0Gb+jHEzDDxEsVBVepbe+WoyA794tvVwQ3Ge3c1p4X5S4zFbgI0eji3PWSZzXf3kZqyAMyL5fkPvuVUKxvibCuN1xMx+5/q5rDflocXft6s3Og6PKOuRnFwdj/TAxeyZFzAwxx5Wmk860l0x3D1f35dS+4IHCO5idCJiP/y+JqyPBjLmfbhUCoUB96zEQ9MFuIx+8b6vHLrlYWjFW34lWfFzai7S20HLCEieNPyHA3+ykKI9R1ojrpHI4M2gn3zgI/Fnimbhb1xXtn4JuEBUY3gHeTPaM15olzog1xxJD8t+rHKRYfCoNv8L38jiQyKfSe8BayNDDaviOMyhvrO7la0ebyHQyyMbCMZGpPhbls8ZxNT//Q6Qbp0k4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d58c1a1b-b45b-4961-9792-08de5dc9e8a9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2026 17:31:30.7525
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 91ZF7VgiZwhhoPNnxY83JF2SNidmIbCgEOeJYi1I9VgkXLLzi+wZ4p1cvoRuZe9e7LgnoGg1YKN3opiQSp0OeQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4421
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-27_04,2026-01-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 spamscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601270142
X-Proofpoint-ORIG-GUID: aTadYn4Q2GOLd2OCKrlDvLBWMA-pPnih
X-Authority-Analysis: v=2.4 cv=StidKfO0 c=1 sm=1 tr=0 ts=6978f677 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=Ttaf_5FmjKx-C6-eRbQA:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:12103
X-Proofpoint-GUID: aTadYn4Q2GOLd2OCKrlDvLBWMA-pPnih
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI3MDE0MyBTYWx0ZWRfX6nefJP7Y/UVD
 GnDrcqYRtCuOgR/k7BPSEcFXbzpPOcKm6WAAdbWnmGWEbAVfNr9Zf+dFYSge355iMCcQMGt+AuW
 g9tn/5X336H9fwCILKmcKQ14Hyq9igAIzMV7z4g9DEsfOiyHwIsxDl4VTgiO5da2sw7/+MnFlsZ
 Ap4wtfirwpYKUZbfmslKnkl2Ja3XwFpX9HFeSkeriGxmmL5v7/XwtJXRlriRJnc2N9AshfygQFH
 KGUO9P0gHv1Qf1m5RCDs7p8+1WQWPNChA52tlXOuGC9yFEtYOjPdFrgBD5E0zken6b/XoH5ng5s
 IkQj/stti0Q4xY7fIRhy94DVJwUSXWkb2YODvaUPq503xzv9dW6x3LNwyO7RH2mEBo85z6BpGLx
 ABSV5Nf1/Hb1vPYqKN+x8wo52XRuPwSCBVCiMcdkIDtoNRNiLAbkrWsVaptQc37eBEtB3J/Rpui
 4JDPVo+tTMMpPURUMitqembGVtQYbEJdOCXLJGq4=
X-Rspamd-Queue-Id: B9A6C12000A
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: jjwjk1qbqtetmg3jdiocjyhaps9fpp78
X-HE-Tag: 1769535102-331461
X-HE-Meta: U2FsdGVkX19y7A/4n+H8aYXG7AABPmfrgQqJPI+EsFdvruUeP+0P967i9czFMYNas9NARKNOgCGHyiaY2uAsmr8O8snxhbexm/ImIQCqkws7Rx9goYNeIy2oymS2QIUHb9xln1DFxUHNWQjFfMbXqhHVQ5DXzBaVY3XH/lYrSoSP6dR9QHaGxN9xYtKbiGewPnKHK3lDxWicQTxx0Qx4ikL4tx9RYllKWGUtGBHxjaBcs8sKN4aSr5v85+xAgS1QZ9EZPdByGI6k4qraxz34FsPxyNH8Cpo3OmKL6hqcVCCCxkGcepBlU62gbnZAJ6OU23MrsA4rCIKr2M94E+h/rhyD4wUNGm55sRmfTdCgsnSU8DI7eAd8ii4+Xlwiy8JzqKkuN0vSpAX+xndAHnPtLAG9nkABSA6dGTKwiS7etprNrvG2Pulymn4kW+K/4c6V2/xRkDzq+/4BF4pG9BtOTnutRALn/qLriBZ21lnbpurI8nSubS97UYDd/jkjLOt/J5WVasDPaz5gnyO9/OGcsecLianDBA5iNFDgPe0+Hrr7LyuA7FXg0CtugAQU/8cBDg53b12NNjXOg1J4NZiv4Ec3Kx41HcTWM8jtytfvRm2aWVbdYO0nKjcBrAiYfkOCdVXb3Sav7XkSvFpcEdtsX/BLEyXCJB6omEpN012kfElXRzrIO1qwAPUgsatnFeG0M0LpnPYOBCj/IfUFH/r5VVCs7oD6JGbOir3QAuJzLBZq/H3eOqkXTPEYlQCF2Ay0E7vdE5E+JjuUDsKxURQIcVa3vqZe05kBvdwkTbEF8aJmOkpAE2pnJ4BVcR/1gxQdTJ9Lm6cY5IfxHCw7vyr2g3IZop0QLurgUeOESe78lVXZgltt3npIo92Qpce54mHzYeOLFNh+tk3dAEXid0i85f68NvB1hAS28U+9lLOT/OxynUZDstsLhjJFIYJWqO2NI4NLirI4Wg9YVj+iDmi
 sh/XfQL3
 xe/nQyG4VlXD3A5GuAkKQCt68g/cBqyGn23SHSOIzGk3d9piHvxdwyHsq8OhsbhE6OMIH1OWa91++K3jOs74hYpONwSV5i5VfE6pCjdRULhYcy3Imreqwez4xANtHdwsS0ncs90udLRQOKkDydaBDmw9IH5UInIwT4EYV68FlFoixuBker2W7wIVF5+CBMJXmc+5TJpUzZj8XZlqdwLXo49rinyTM8/3qKfsnAbqc3b2P39XNvH+v+pqTtlBHppmF1VT9LKFRXyprbKxayV+JpTD18OYU4H1UM7w37BfkPU/s8LAXkFHIJlkv15/jBFmDi5GaJqSgOLw3KkndDIIQaxMqhrgAaSxYAQlu5wxseF2ljsLNbMUwreF894yo7zbRsiezxv/G/CEg9C4s6QBxXwUG6uNZo+K6uxBf7EBNxsXHKvW2AeySU+WyQEayIsb0rVrft+V4hNPJ4kKS41l8i1K25gGCHtJfbYU8pbKYZW4n5u23npWw7Pl1097C4P4i/E1Fid79L5BK7EeiYQtL1tV8vFunEanlsqxqyKkvxqcQTMX+K6596JDFUR5VHcYNvgWpJZld+UHsy+jdAGiECCsNbly+W9yXfkyBUExCCNT+qaqs4A5DPCdiGUQWj+1oWCo3yKC8/JO7biItGV5zgqo/jA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Vlastimil Babka <vbabka@suse.cz> [260123 01:53]:
> Until now, kmem_cache->cpu_sheaves was !NULL only for caches with
> sheaves enabled. Since we want to enable them for almost all caches,
> it's suboptimal to test the pointer in the fast paths, so instead
> allocate it for all caches in do_kmem_cache_create(). Instead of testing
> the cpu_sheaves pointer to recognize caches (yet) without sheaves, test
> kmem_cache->sheaf_capacity for being 0, where needed, using a new
> cache_has_sheaves() helper.
> 
> However, for the fast paths sake we also assume that the main sheaf
> always exists (pcs->main is !NULL), and during bootstrap we cannot
> allocate sheaves yet.
> 
> Solve this by introducing a single static bootstrap_sheaf that's
> assigned as pcs->main during bootstrap. It has a size of 0, so during
> allocations, the fast path will find it's empty. Since the size of 0
> matches sheaf_capacity of 0, the freeing fast paths will find it's
> "full". In the slow path handlers, we use cache_has_sheaves() to
> recognize that the cache doesn't (yet) have real sheaves, and fall back.
> Thus sharing the single bootstrap sheaf like this for multiple caches
> and cpus is safe.
> 
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>

> ---
>  mm/slab.h        |  12 ++++++
>  mm/slab_common.c |   2 +-
>  mm/slub.c        | 123 ++++++++++++++++++++++++++++++++++++-------------------
>  3 files changed, 95 insertions(+), 42 deletions(-)
> 
> diff --git a/mm/slab.h b/mm/slab.h
> index cb48ce5014ba..a20a6af6e0ef 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -277,6 +277,18 @@ struct kmem_cache {
>  	struct kmem_cache_node *node[MAX_NUMNODES];
>  };
>  
> +/*
> + * Every cache has !NULL s->cpu_sheaves but they may point to the
> + * bootstrap_sheaf temporarily during init, or permanently for the boot caches
> + * and caches with debugging enabled, or all caches with CONFIG_SLUB_TINY. This
> + * helper distinguishes whether cache has real non-bootstrap sheaves.
> + */
> +static inline bool cache_has_sheaves(struct kmem_cache *s)
> +{
> +	/* Test CONFIG_SLUB_TINY for code elimination purposes */
> +	return !IS_ENABLED(CONFIG_SLUB_TINY) && s->sheaf_capacity;
> +}
> +
>  #if defined(CONFIG_SYSFS) && !defined(CONFIG_SLUB_TINY)
>  #define SLAB_SUPPORTS_SYSFS 1
>  void sysfs_slab_unlink(struct kmem_cache *s);
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index 5c15a4ce5743..8d0d6b0cb896 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -2163,7 +2163,7 @@ EXPORT_SYMBOL_GPL(kvfree_rcu_barrier);
>   */
>  void kvfree_rcu_barrier_on_cache(struct kmem_cache *s)
>  {
> -	if (s->cpu_sheaves) {
> +	if (cache_has_sheaves(s)) {
>  		flush_rcu_sheaves_on_cache(s);
>  		rcu_barrier();
>  	}
> diff --git a/mm/slub.c b/mm/slub.c
> index 594f5fac39b3..41e1bf35707c 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2846,12 +2846,23 @@ static void pcs_destroy(struct kmem_cache *s)
>  {
>  	int cpu;
>  
> +	/*
> +	 * We may be unwinding cache creation that failed before or during the
> +	 * allocation of this.
> +	 */
> +	if (!s->cpu_sheaves)
> +		return;
> +
> +	/* pcs->main can only point to the bootstrap sheaf, nothing to free */
> +	if (!cache_has_sheaves(s))
> +		goto free_pcs;
> +
>  	for_each_possible_cpu(cpu) {
>  		struct slub_percpu_sheaves *pcs;
>  
>  		pcs = per_cpu_ptr(s->cpu_sheaves, cpu);
>  
> -		/* can happen when unwinding failed create */
> +		/* This can happen when unwinding failed cache creation. */
>  		if (!pcs->main)
>  			continue;
>  
> @@ -2873,6 +2884,7 @@ static void pcs_destroy(struct kmem_cache *s)
>  		}
>  	}
>  
> +free_pcs:
>  	free_percpu(s->cpu_sheaves);
>  	s->cpu_sheaves = NULL;
>  }
> @@ -4030,7 +4042,7 @@ static bool has_pcs_used(int cpu, struct kmem_cache *s)
>  {
>  	struct slub_percpu_sheaves *pcs;
>  
> -	if (!s->cpu_sheaves)
> +	if (!cache_has_sheaves(s))
>  		return false;
>  
>  	pcs = per_cpu_ptr(s->cpu_sheaves, cpu);
> @@ -4052,7 +4064,7 @@ static void flush_cpu_slab(struct work_struct *w)
>  
>  	s = sfw->s;
>  
> -	if (s->cpu_sheaves)
> +	if (cache_has_sheaves(s))
>  		pcs_flush_all(s);
>  
>  	flush_this_cpu_slab(s);
> @@ -4157,7 +4169,7 @@ void flush_all_rcu_sheaves(void)
>  	mutex_lock(&slab_mutex);
>  
>  	list_for_each_entry(s, &slab_caches, list) {
> -		if (!s->cpu_sheaves)
> +		if (!cache_has_sheaves(s))
>  			continue;
>  		flush_rcu_sheaves_on_cache(s);
>  	}
> @@ -4179,7 +4191,7 @@ static int slub_cpu_dead(unsigned int cpu)
>  	mutex_lock(&slab_mutex);
>  	list_for_each_entry(s, &slab_caches, list) {
>  		__flush_cpu_slab(s, cpu);
> -		if (s->cpu_sheaves)
> +		if (cache_has_sheaves(s))
>  			__pcs_flush_all_cpu(s, cpu);
>  	}
>  	mutex_unlock(&slab_mutex);
> @@ -4979,6 +4991,12 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
>  
>  	lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
>  
> +	/* Bootstrap or debug cache, back off */
> +	if (unlikely(!cache_has_sheaves(s))) {
> +		local_unlock(&s->cpu_sheaves->lock);
> +		return NULL;
> +	}
> +
>  	if (pcs->spare && pcs->spare->size > 0) {
>  		swap(pcs->main, pcs->spare);
>  		return pcs;
> @@ -5165,6 +5183,11 @@ unsigned int alloc_from_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
>  		struct slab_sheaf *full;
>  		struct node_barn *barn;
>  
> +		if (unlikely(!cache_has_sheaves(s))) {
> +			local_unlock(&s->cpu_sheaves->lock);
> +			return allocated;
> +		}
> +
>  		if (pcs->spare && pcs->spare->size > 0) {
>  			swap(pcs->main, pcs->spare);
>  			goto do_alloc;
> @@ -5244,8 +5267,7 @@ static __fastpath_inline void *slab_alloc_node(struct kmem_cache *s, struct list
>  	if (unlikely(object))
>  		goto out;
>  
> -	if (s->cpu_sheaves)
> -		object = alloc_from_pcs(s, gfpflags, node);
> +	object = alloc_from_pcs(s, gfpflags, node);
>  
>  	if (!object)
>  		object = __slab_alloc_node(s, gfpflags, node, addr, orig_size);
> @@ -5353,18 +5375,10 @@ kmem_cache_prefill_sheaf(struct kmem_cache *s, gfp_t gfp, unsigned int size)
>  	struct slab_sheaf *sheaf = NULL;
>  	struct node_barn *barn;
>  
> -	if (unlikely(size > s->sheaf_capacity)) {
> +	if (unlikely(!size))
> +		return NULL;
>  
> -		/*
> -		 * slab_debug disables cpu sheaves intentionally so all
> -		 * prefilled sheaves become "oversize" and we give up on
> -		 * performance for the debugging. Same with SLUB_TINY.
> -		 * Creating a cache without sheaves and then requesting a
> -		 * prefilled sheaf is however not expected, so warn.
> -		 */
> -		WARN_ON_ONCE(s->sheaf_capacity == 0 &&
> -			     !IS_ENABLED(CONFIG_SLUB_TINY) &&
> -			     !(s->flags & SLAB_DEBUG_FLAGS));
> +	if (unlikely(size > s->sheaf_capacity)) {
>  
>  		sheaf = kzalloc(struct_size(sheaf, objects, size), gfp);
>  		if (!sheaf)
> @@ -6082,6 +6096,12 @@ __pcs_replace_full_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs)
>  restart:
>  	lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
>  
> +	/* Bootstrap or debug cache, back off */
> +	if (unlikely(!cache_has_sheaves(s))) {
> +		local_unlock(&s->cpu_sheaves->lock);
> +		return NULL;
> +	}
> +
>  	barn = get_barn(s);
>  	if (!barn) {
>  		local_unlock(&s->cpu_sheaves->lock);
> @@ -6295,6 +6315,12 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
>  		struct slab_sheaf *empty;
>  		struct node_barn *barn;
>  
> +		/* Bootstrap or debug cache, fall back */
> +		if (unlikely(!cache_has_sheaves(s))) {
> +			local_unlock(&s->cpu_sheaves->lock);
> +			goto fail;
> +		}
> +
>  		if (pcs->spare && pcs->spare->size == 0) {
>  			pcs->rcu_free = pcs->spare;
>  			pcs->spare = NULL;
> @@ -6691,9 +6717,8 @@ void slab_free(struct kmem_cache *s, struct slab *slab, void *object,
>  	if (unlikely(!slab_free_hook(s, object, slab_want_init_on_free(s), false)))
>  		return;
>  
> -	if (s->cpu_sheaves && likely(!IS_ENABLED(CONFIG_NUMA) ||
> -				     slab_nid(slab) == numa_mem_id())
> -			   && likely(!slab_test_pfmemalloc(slab))) {
> +	if (likely(!IS_ENABLED(CONFIG_NUMA) || slab_nid(slab) == numa_mem_id())
> +	    && likely(!slab_test_pfmemalloc(slab))) {
>  		if (likely(free_to_pcs(s, object)))
>  			return;
>  	}
> @@ -7396,7 +7421,7 @@ void kmem_cache_free_bulk(struct kmem_cache *s, size_t size, void **p)
>  	 * freeing to sheaves is so incompatible with the detached freelist so
>  	 * once we go that way, we have to do everything differently
>  	 */
> -	if (s && s->cpu_sheaves) {
> +	if (s && cache_has_sheaves(s)) {
>  		free_to_pcs_bulk(s, size, p);
>  		return;
>  	}
> @@ -7507,8 +7532,7 @@ int kmem_cache_alloc_bulk_noprof(struct kmem_cache *s, gfp_t flags, size_t size,
>  		size--;
>  	}
>  
> -	if (s->cpu_sheaves)
> -		i = alloc_from_pcs_bulk(s, size, p);
> +	i = alloc_from_pcs_bulk(s, size, p);
>  
>  	if (i < size) {
>  		/*
> @@ -7719,6 +7743,7 @@ static inline int alloc_kmem_cache_cpus(struct kmem_cache *s)
>  
>  static int init_percpu_sheaves(struct kmem_cache *s)
>  {
> +	static struct slab_sheaf bootstrap_sheaf = {};
>  	int cpu;
>  
>  	for_each_possible_cpu(cpu) {
> @@ -7728,7 +7753,28 @@ static int init_percpu_sheaves(struct kmem_cache *s)
>  
>  		local_trylock_init(&pcs->lock);
>  
> -		pcs->main = alloc_empty_sheaf(s, GFP_KERNEL);
> +		/*
> +		 * Bootstrap sheaf has zero size so fast-path allocation fails.
> +		 * It has also size == s->sheaf_capacity, so fast-path free
> +		 * fails. In the slow paths we recognize the situation by
> +		 * checking s->sheaf_capacity. This allows fast paths to assume
> +		 * s->cpu_sheaves and pcs->main always exists and are valid.
> +		 * It's also safe to share the single static bootstrap_sheaf
> +		 * with zero-sized objects array as it's never modified.
> +		 *
> +		 * Bootstrap_sheaf also has NULL pointer to kmem_cache so we
> +		 * recognize it and not attempt to free it when destroying the
> +		 * cache.
> +		 *
> +		 * We keep bootstrap_sheaf for kmem_cache and kmem_cache_node,
> +		 * caches with debug enabled, and all caches with SLUB_TINY.
> +		 * For kmalloc caches it's used temporarily during the initial
> +		 * bootstrap.
> +		 */
> +		if (!s->sheaf_capacity)
> +			pcs->main = &bootstrap_sheaf;
> +		else
> +			pcs->main = alloc_empty_sheaf(s, GFP_KERNEL);
>  
>  		if (!pcs->main)
>  			return -ENOMEM;
> @@ -7803,8 +7849,7 @@ static void free_kmem_cache_nodes(struct kmem_cache *s)
>  void __kmem_cache_release(struct kmem_cache *s)
>  {
>  	cache_random_seq_destroy(s);
> -	if (s->cpu_sheaves)
> -		pcs_destroy(s);
> +	pcs_destroy(s);
>  #ifdef CONFIG_PREEMPT_RT
>  	if (s->cpu_slab)
>  		lockdep_unregister_key(&s->lock_key);
> @@ -7826,7 +7871,7 @@ static int init_kmem_cache_nodes(struct kmem_cache *s)
>  			continue;
>  		}
>  
> -		if (s->cpu_sheaves) {
> +		if (cache_has_sheaves(s)) {
>  			barn = kmalloc_node(sizeof(*barn), GFP_KERNEL, node);
>  
>  			if (!barn)
> @@ -8149,7 +8194,7 @@ int __kmem_cache_shutdown(struct kmem_cache *s)
>  	flush_all_cpus_locked(s);
>  
>  	/* we might have rcu sheaves in flight */
> -	if (s->cpu_sheaves)
> +	if (cache_has_sheaves(s))
>  		rcu_barrier();
>  
>  	/* Attempt to free all objects */
> @@ -8461,7 +8506,7 @@ static int slab_mem_going_online_callback(int nid)
>  		if (get_node(s, nid))
>  			continue;
>  
> -		if (s->cpu_sheaves) {
> +		if (cache_has_sheaves(s)) {
>  			barn = kmalloc_node(sizeof(*barn), GFP_KERNEL, nid);
>  
>  			if (!barn) {
> @@ -8669,12 +8714,10 @@ int do_kmem_cache_create(struct kmem_cache *s, const char *name,
>  
>  	set_cpu_partial(s);
>  
> -	if (s->sheaf_capacity) {
> -		s->cpu_sheaves = alloc_percpu(struct slub_percpu_sheaves);
> -		if (!s->cpu_sheaves) {
> -			err = -ENOMEM;
> -			goto out;
> -		}
> +	s->cpu_sheaves = alloc_percpu(struct slub_percpu_sheaves);
> +	if (!s->cpu_sheaves) {
> +		err = -ENOMEM;
> +		goto out;
>  	}
>  
>  #ifdef CONFIG_NUMA
> @@ -8693,11 +8736,9 @@ int do_kmem_cache_create(struct kmem_cache *s, const char *name,
>  	if (!alloc_kmem_cache_cpus(s))
>  		goto out;
>  
> -	if (s->cpu_sheaves) {
> -		err = init_percpu_sheaves(s);
> -		if (err)
> -			goto out;
> -	}
> +	err = init_percpu_sheaves(s);
> +	if (err)
> +		goto out;
>  
>  	err = 0;
>  
> 
> -- 
> 2.52.0
> 
> 

