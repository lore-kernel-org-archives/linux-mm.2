Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B47DD4661C
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 19:37:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6709A6B00DD; Thu, 15 Jan 2026 14:37:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EC7E6B00E4; Thu, 15 Jan 2026 14:37:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28BC76B00DF; Thu, 15 Jan 2026 14:37:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 09A5C6B00E0
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:37:51 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BF2108BB16
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:37:50 +0000 (UTC)
X-FDA: 84335208300.29.AF2251F
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf10.hostedemail.com (Postfix) with ESMTP id 52739C0008
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:37:47 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=e9MAEl8r;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ELmAWkfp;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768505867; a=rsa-sha256;
	cv=pass;
	b=gCvU5SINNSF4nLot4S6HFoe4pUKv3THClS98/40hsA05xR0YCDCfY1qXfmSUA2aSeQ530h
	Wr3m8ssmmaW2ypw4xYWpEcppcLAbh63RX3SLXtorYFirm1xXVBOZf0vcujpRYSaSTRh8gy
	tdHJtbJBqN+JfU8eGmq3Cch0toCFXN8=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=e9MAEl8r;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ELmAWkfp;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768505867;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qhDT7zbM6+62WVcy6p56gogns5KVjtkPQW/fp3AFqoM=;
	b=dhiXma0bWyuvuqEhin2ogYO6Eioju4dgKsdIlPfClvzij79o4oZiLkfuIfFPc1kOnJxd03
	zzb6awd55UT5fzZwrENVsCaAht8aS2+kUiQEDc9z7lCV1cK78jzYb3QKn4X0/N0+7zG+SX
	Ow9FXoGWFGgqSBNgYcqpweSt3KXj/7Q=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60FEfZUN1940184;
	Thu, 15 Jan 2026 19:37:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=qhDT7zbM6+62WVcy6p56gogns5KVjtkPQW/fp3AFqoM=; b=
	e9MAEl8rmWzEyPyCvVr2anzsCdkqrFhFVN9nsoMa5gFnKA6iwPcEHElhUxcqpf1D
	nDFe0lu4wnzmXhfpR7ETxWDhtnljVb4BWwsAJc+hNkTOcU/K7XGOfEfoSi5mZfuy
	DNkg0uJlYR6XLsqA0t/J8iYFB985FMa8M5s8SnQWPsyJ0yhjgg/DfjCG3CxtiZgk
	0ldOsecdUBLWxXEQmYS5RVSwV4eqDQaD/b/2m+f7a6NHKtEj55ckwTOAKwDobSC8
	bcLCrlROY/+cErucTOiYYYG83i+XQ72E5FSfhafVD3eJrV/0Qn80v80q9F5QGRr9
	ixfM/57Nw4kAUCM0nyBkHg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bp5p3bwcg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 19:37:38 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60FI1DXU004234;
	Thu, 15 Jan 2026 19:37:37 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013057.outbound.protection.outlook.com [40.93.201.57])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7nguhf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 19:37:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a5bZ5Mpx6PSsVfUHU9KbNJoBVrl6EsDGISGf2Z0KbM2XVeF438WIug3DpzeToagHvTHQnQPit1zMBle+jyowkQcPmnDIrFlc84yerf5ht/SJXWz63mx9DzfCyxrvsvVYv1KkqCkNwUI+g1zqstfuANhxNiPVIAPCcuhF50yXfhdbnf9RCArQk/EkLu6m6U1/M7C4qovb/ROwlPzlhFriu3AnBfFBCW/2QwmsD7gPIoEWE7i04WQmjckVZP0Qhybox0JU9z703QNCsd0VymLGdPcxNa95MK74Tox3XVrVeld5L7E6MpARsbDXmv0fC5Ep1JjzrNPkfVxVnmrTEKSf5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qhDT7zbM6+62WVcy6p56gogns5KVjtkPQW/fp3AFqoM=;
 b=YXm/HkTOCoYNL3zaa8pkOsTzRuxVyuKjY1iQm4ZzHzm1PiMdgWAUBIY47ZZBDKU3oR6KZkIdaC7nQEXnZ+GuCe4TRVBchs+LpYKXn1Ljk4WWDrjpQLm4cChi0qv1HSqH39mMUprqMJkExC6e34efQzytYgjVR4+7nLwWJkQYo+tiWnBj1KO3AZDZSfVtxYEl3b3Tcajr8Ek4PQpCY5ptVBxgB8KTwjSXtBWlhChSgW6iH26TkloOs9gAI2b9tkD81Q4YCNSZKNGZ4BsRKC8ABdWR8maWMeL73E9oyFHXGHCiwbkkvaylk79l9sjjvlEzfVnQYpGzWHxylKYj5CgWxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qhDT7zbM6+62WVcy6p56gogns5KVjtkPQW/fp3AFqoM=;
 b=ELmAWkfp4rHgMFKs7pKl8QaPsmvIKYKTNlcsGbYC+ci5GT+dLPDFpIBac2mO8Ko9JuUYYQy7WEpU3VJvHbcoUwyf3bTdTeJpTJwUNY8Jay4FzyWLRr/86L0VcXNqW8rIoSVDi8g8168LXffNtHOA1zqYj5aKFJVcz7n7URZsoM8=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by SA2PR10MB4507.namprd10.prod.outlook.com (2603:10b6:806:119::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Thu, 15 Jan
 2026 19:37:34 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9520.003; Thu, 15 Jan 2026
 19:37:33 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Sidhartha Kumar <sidhartha.kumar@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Alice Ryhl <aliceryhl@google.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Arnd Bergmann <arnd@arndb.de>, Christian Kujau <lists@nerdbynature.de>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH 16/28] maple_tree: Start using maple copy node for destination
Date: Thu, 15 Jan 2026 14:36:35 -0500
Message-ID: <20260115193647.1695937-17-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260115193647.1695937-1-Liam.Howlett@oracle.com>
References: <20260115193647.1695937-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0057.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:111::13) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|SA2PR10MB4507:EE_
X-MS-Office365-Filtering-Correlation-Id: 632ce57e-b6aa-40c4-2d3c-08de546d8797
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?uPEROP21X93PkBvsnUXzmqFfZ+FlSQ93uYiAPP+72ZdMAkEXWWkYGs7Z8gvH?=
 =?us-ascii?Q?x2hpyhYO2OfnFA1C5sheOOR18T+ZyE8VUyMAwW9lk9XLtc6DeDli792hCz5h?=
 =?us-ascii?Q?hCKLebG+oUVTH0blTJWVom0qLlhju2Bsd2vL7ctZV1jxxdajvVSuF4QwZWui?=
 =?us-ascii?Q?ShYvZpiPCr4zu6DdyldHHavetbEyE6U3iyt4QzHEwmbEyqeGbR+BdFaQqnS2?=
 =?us-ascii?Q?Nr0xdkV3h3JVzjUiN6eT1OUOvTwH6MiYEhWFPZpQNVJyzC7LS5zjbeqvf4/7?=
 =?us-ascii?Q?Ma2X2hziPfQ4ymyfQe0EG5+7UjUkl8Y0o6/AIXcyhu8nWt6Z6PDE7hX1b5Jm?=
 =?us-ascii?Q?namplajOM3LIrNmhW5SnVT0XRmlRqQ9aUIE0biNU9Fc1JwEVWV2Hgcp2kG26?=
 =?us-ascii?Q?B6Brl6WidY4DcFXQXcvu099GVBeechNYLLc/RT+jWXWUL7zbRhUH1ch0LYn2?=
 =?us-ascii?Q?WeX/4pmJ9iYvt2ri0a9+twWHkPx8e5wnchFAGuCxeRCGpY3KrwhkZ04tIjRG?=
 =?us-ascii?Q?XC4y2KeEiHKZSg7yLCDbzjX91t3Mf2dfx/1sh/gNz3P87aiFJttbc7/p9Fez?=
 =?us-ascii?Q?bzv335dnbxkG482xQczI18a7N0afvFPHxX4k1SfzfNxuyCfyIs5Q2nwV3Hjp?=
 =?us-ascii?Q?67dR26gPYqJvdW4BhMJOProSZPTX0Nk0ROmtsUfGnvny/PNPXGI1hWeRDIP4?=
 =?us-ascii?Q?cjWvX8ME3tg8c8YLx63qHt1b1ATgL88LzTLFEwUNBhhGxc8Tkn2uvBiOc/F8?=
 =?us-ascii?Q?ODzLEDP8dUkn1cJsVmnLv88YiOB5Aw8/c7JDGKapbcxuPhcpSP9eJFq/YKY2?=
 =?us-ascii?Q?LqUpGDLZUW3nRYOye3Ymg6iEL9sAnqA/tnX0+9xSz3IZCvXkmPIwHo0XZJQW?=
 =?us-ascii?Q?knEu92OxNjNwL4/AsuLfZGMt3Top61IFT8hRomd7Qs28jGERUWr6gVYZAQI6?=
 =?us-ascii?Q?3IyeXu46c5vUYfBzVgG4ZTMh195wAQpfNF3qV/Li525uNlTcFhJJpvEWBX1+?=
 =?us-ascii?Q?b1V74k9HUCi6+fK83v6MLkEw3W+e3EkPqzHHKuBsjqsqNHohnKboGwnczMp9?=
 =?us-ascii?Q?OPCInT+k0PT92/g3enplRMBJZXpSLxIZN2r+GM3Q6zg0zxFeKUosO5DDEMdY?=
 =?us-ascii?Q?Nt2x302DJXbdymUN9fuveBVLpv1/I3XofWUP+m7FlqQZdFc1S0iNWaHM4ByW?=
 =?us-ascii?Q?CBB5brBULgr5mevN3F/0WSgPxRcjGT7VY4Q6MbZ0vtAMHC6v/SygJe2+F0fE?=
 =?us-ascii?Q?mew8Vv7WgwHZoDudsNc7iMAQyyKMw2niIVbQhCAdLYzPjTUqIzOFh2M5/E4Z?=
 =?us-ascii?Q?m8aT8kctgDmaz9h4ph8KZS6rMtkTqsNGRuXh9aUJkQTjbclcX6sEweoeQ6qP?=
 =?us-ascii?Q?8+QCfqqwnTzFsyI3XUyadQiWjpYEc3dkO2m/0R9QsM22RsuxquWzR5FJ/Z8M?=
 =?us-ascii?Q?rT9C4dL0GqLScQaNkH5Mn/5ji1hVkP8Axmd6kojXooRF5F8XiAqUUWX4vj91?=
 =?us-ascii?Q?asdezpBqqKP37fFSldUZ29PWFjissAJ2+5BvX5t3nvI/Amy2KbG7Pz4Ht/Z+?=
 =?us-ascii?Q?LyAhfZ4924doGOW+APs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ypuqCV0fEk+oFLvpupVvkkKrvYULLzm+ulTe/t/uMcrM7BqubwdhsskS9nOm?=
 =?us-ascii?Q?SwmO9zb0e4OWgrLzfWSBwrk7sEaoOIKEzj2ifW3js27tvn8YDmmaVB4ckVqq?=
 =?us-ascii?Q?QwryFj9O6wcCMX7+yNewSCNxM8J07DQTaGBNI+wRNKthkyQmccjxQVanIMlh?=
 =?us-ascii?Q?V44rPcxie7TVeMwqeW2Vn39+wss6HMSRsyxD1bAmaR6lQbs7QiRnShNUSFiF?=
 =?us-ascii?Q?Nceu9VR/axAlzJgVVoxfUyIfgjZGFFfFXqUsPc4FaV8vDSXC5SQTAqRkKlaf?=
 =?us-ascii?Q?BkL5a7FpQAPQpNlwuolE5qo/jnFJAUyol55dy6TnM+GH5NfSnT7UKz1YCE9S?=
 =?us-ascii?Q?/zxh19IaPSFh0t7nKhZxhYOcnmKSBol31CspO78koBJsZb2ZhEe5BC81sp3K?=
 =?us-ascii?Q?L8qu5hzbe8lKOqWWNOgik/9laSe9NQry5KfK/n3T+CgFithQdZzfTGJ2Hjol?=
 =?us-ascii?Q?Mqr+BrXNVUHhpggNrkq1csQue8RGYmMQzDjaPfcz9LpxDVlXEt95w0saZW+k?=
 =?us-ascii?Q?LL6ZLEzhLqOfdq0FTeNFY80fjGDqg1MHgYxMVGJKTXSGGdEJJWABuzIWTHG7?=
 =?us-ascii?Q?VgJslsyCgNd0Ghxdpc1fFYiByKLpt1jUtvqKX9Xd2iViywu9iBjycXdWMzcM?=
 =?us-ascii?Q?E/Jt1PKZ1RDk+gJAKo4tojD68/RS17UeUtxHBevH+1u7je4Mlc3wv5F+5T7A?=
 =?us-ascii?Q?VVOZzE2nChLOAH3cb1j+5DakVuqy2txw1Y30BeILTGvg26Y+ESSKqCvxSBUC?=
 =?us-ascii?Q?Z0ilpqrekLz99ubxaJseyOL70LLlpoNa5qLBSpMdqXvEPGQF8fwRLdULrH3e?=
 =?us-ascii?Q?DbFQi2RP58bpb68GCwOzwZbLhqMGFoF1/9/OdYxznvmkMtw+CZF+nN048BEO?=
 =?us-ascii?Q?wmCpTTh38Hlc5r6+kBlz18oQzbbKaW8fMMTTZWkSRhhoDWtEaWe/MNcdg59Y?=
 =?us-ascii?Q?u3AemhnGso3yu5pwTJfKbLv36sz7XocwVaXoAIAWfAt9xuy2XRrlweNPRLBV?=
 =?us-ascii?Q?+qiMT5mKSuDCJ/jfkE6ffBIb2zckVDDMNYQOXh1zGHucVgadUuLBW9Igkr9Q?=
 =?us-ascii?Q?PCLuiYnrpCNocTnkbPL8fDXtPJMXRDDjM7h/7bBejjUlsp090P2NG8XnUcDW?=
 =?us-ascii?Q?QOLHDq2So/3efLwmNu3W5NMwxg+CTWRRht7VOtChK8feb64tfcPYdbLfIETh?=
 =?us-ascii?Q?hns/0TDUEG+iRvUbLemnw+7kvALC8HKzm+xgV7K9XHIrrlej5rLF3be3URqv?=
 =?us-ascii?Q?WW8G8qXuIRaGdKzGQJpVaAiqqEp0nHYxy1S3ZQb3o/wppUf/jT1f40nZo/tk?=
 =?us-ascii?Q?olzXw0s4DjhDCcmduVDWhPmQV7qcbT5W/XbjVMaej2niTOMb7apyTnGAFL6/?=
 =?us-ascii?Q?WfeQ8zxd+glpLfOB8mpb7trJ6REDn3Aew8XxtVJFrIJPUPAg95qsaf6OibdK?=
 =?us-ascii?Q?1uB5VXff3Ee6/ZMpWOKvJkeU4UEuHTIe00y09jcD473ippMUXcs8J2UNbkOa?=
 =?us-ascii?Q?YoYsjCcX6xYfBAWGUZTcfNGdPnIf0CWrGUKMyglOAM/Lpda+tacO/pzjzUsV?=
 =?us-ascii?Q?E/levlfPP4pQG+TCeO+hcEOh/aL+p5GJXA5xpWlrq9r6dDNlDau3IzmT3XK8?=
 =?us-ascii?Q?O0M2fNLTXdFCFSOch+Pcri/BFQDT+0zo6Cfs1GEZmkGzv+VVN7dC93aX8kw9?=
 =?us-ascii?Q?meMEP1Po0qtP7L03PtZ4oMBOwF1BNGLuwSF54PeN5drEAwvnytP6pN4VadBG?=
 =?us-ascii?Q?wsAXNECRQw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	t3d16y+D5swk0RgYD9zdwQnNaLPflg6Q/tG/3fOiHvIrY9SN1yv/nG3TX+SjcW5pqUEgJ+aDk9fcImJAEMuxn1K8nYKK1I0wULZtYeW46VON3UQdrhht+k2P5zed8JzM5y6yyhLo4ZxqFd9uGDBA+MQAyTPpILQ+BjSxJaUzvC0VyPdeu6EJRLaL0hrX78Wezzy2Z1QBipEic8amtr0vsKeXUy7sgnsjwIpkEwPVYNx0pNxPDmFT3vR5mKnmYmxozIJyqa51iZc4ycISiEhBr7NU35mTnWzCTuGs2rfa8SkgOKacuzwiQcpuvlstxqEQwdRngzwQy1qWFfGss/GDjHtrZ+iFWpMuguBcfkcx0X1wrGO01KqyD8JS9AFoAhJRKc+JdCk6nXfBiFXeDV01sDT3RD1I7AaO5lj2iYB+p/kammy7JgZdzezP4XlqslG3gMlKVOGgCk/J94GPkQJHx6+xqn12G5r+IrYJAPnqNiIcnAK6I9n+pZuY9+k358SrVnEzAhxz6kxK6e351SCXRpjMtUoAygohIziXKeOHcMJ9f3+8iFHdK5Gd6TYhF1HzwsZ9sp9AnMPc849fiaO/kMVPX7rmnLM6u0a3g8uHcG8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 632ce57e-b6aa-40c4-2d3c-08de546d8797
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2026 19:37:33.8341
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iORHa+44OfTmEjHfyY7GATT6FNzEhjrml/fN2sHAc+FXWFOPz8wWcpUWFn+ROYSa8qWJmR+4HuTz45d16zV35A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4507
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-15_06,2026-01-15_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 spamscore=0 adultscore=0 mlxscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601150152
X-Authority-Analysis: v=2.4 cv=OJUqHCaB c=1 sm=1 tr=0 ts=69694202 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=87tggohZ5hOGCbKafh0A:9 cc=ntf awl=host:12110
X-Proofpoint-ORIG-GUID: TDKuDqOrSvaKLyl1OONEqmYwORMbtJpP
X-Proofpoint-GUID: TDKuDqOrSvaKLyl1OONEqmYwORMbtJpP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE1MDE1MyBTYWx0ZWRfX2JyiynTqEpae
 UxA6SwtkMzx9budn1yRDLfsGYJQ2vVoNGucWa+uqFcTXwIzdQlzCXUlWwJsahCDxmAhO6F2/m68
 KiwA3ASDaTUF7zDaIZp/iinCXZKVuSNGfeqmmw9ZdCnHVxbFHf51z8efoAyQQN6y31i18d7hQ8i
 +DZo3uZhlbu7ROHSQ0YvOF6YUlDXtm9VsUV+i+Hyv7qgZ3tunAUlOwi0tIPgWdbq4vVm2iNQ4SP
 rUfqGKIIC8uAMNpyTWFD+K6jHf63BUls7/5oQ3CG0ah40jL70cp7jHh2oJmdyziYpgulQhBUa2Y
 JJTUSbVmxLptLMD1yEp5sx0kYz+fCzHAts7/OqmwZnRYfgpCTNXbXQTXZf2F0drJkElScuJUyZ9
 iO4K0cthpsIBzZ49Yob6jOF7vaVfH6L2ZzoRltVmg6XWgZlnVV5RZRZcCYT804UR3D7V0j6cGKZ
 OTFaNxG92TzziH7WStvDTjSHWJosGtnZKbA4LqFc=
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 52739C0008
X-Stat-Signature: 3fa9ym9exnqc1eye3ptbsn9sxrnnoazd
X-Rspam-User: 
X-HE-Tag: 1768505867-287732
X-HE-Meta: U2FsdGVkX1+b4OM4hNvuGGQZtK5Nr10FWLvFl+ehb7HEHRfeIsX7GtzzHTTpcWesbhLep3qQQiX/RCpi+k+tDfx42Z8QtwstqyXxMiULUiKC1yfOMX7ABMHbBZcty2in9y7JOqDa/dDiA5sUohdEH9xvD+jGzVnBboDdEiXt/xGdRJzE8d3eeuiLGCi6lIgTysaaUzjXkG5pa5yd3l7vLl38SA5B/1YsmIKV5km24WwiqlmXP94giPh/Lm92+rJwJkr6HHXnSbqmot1axEV1go8c53XsqSNFfWkqgWPh7/7xehqLjb663/1gxNk2jGkAunmweGX73huTOANxNvU/Y2gq3WnQ7Y84iQiPqGQQL+Hcq85olHK4SOuzQlNCCGaufqhcvPzOMGTkQopZKO8h0I/+/e+hEKG6fIIejNjQzNQENX0WasBYD2+IRBYcBFAmJlw9YEA/BNI3cEV+mm6UQ9t8I9E8Bu0ANVhdvaQO7utNefo16XWpagWCgq7DAmMGiHOqjuMPmKONDAyjntrQjABwTVX5h+kmma5VzFVFosngoEFlKcl0xloA82rQp22RtX5kpNDMd6f4pPrgSc8631UhhK+2Tjiu+vGLeSNSNSR6Z3iREJh5yC0FBbk1Ypog2rxWDw0ThPZeMpSxCi8uQhgVzoK7+P9nCiFh5ToscCsE4SYYCGo1e3jWrvU3610tZB5VuuXaaMx834MJ3mFttUedtirdgqZKemxCtt+U4Zbb/S9//fMEPiA3dawl7lKrxvFlIdqy37BNrKKRQg+h1Lh0i0sYWXrA6GEyfh5eCUA3M3rVfAavQ6xn1T+pNs8T7G3/xpyJNrCTmnrPS5JhbDA39wkMIJqQe0SlbQ49Nb/gYEWEy7J6ADRoDA0VKJC0FY5mLsrh30e0FXrfk4GNx1TAlr1eritRO4w9CSQQSEcpytuAIdzs9lfLG/SKrG7SiB5+n1x+PaaXHxrGPQZ
 GZ1OUpXb
 YUmhClYVhhOV+9QGiRT1CiEK3nW7FN33L9D3CaHCVKKG1+0xt1Il5i665NfP5kXW7w+r9RKfKKIpFNaCK22az4Vblh2zFQxtI6Of8MJujNHNlLDSMaN2rsFgnNaG96Tt3LaBwb0Dfwyj93FM55949n5sCrRWEGi3FI8Z+nQ0I0zmDN8+29ImXu0DocajgYlITReeK/+eS+W6I0GWSXc4DWqKzzg6FVxBEVVnZjehgNZMXEpwiSsJFj1Wmqid3WOY24iPiBwKv59CyrD3mBifReSkimgCMtWnrfZk4L+ImX5e1aDAZH0o+5roBjrAE0GgsHJLONzCFdbH3/O8hMihvIFmvXiVjcA/rWC0zYX46Vc140HOffknVQ3NwxmMwkzz1VpP5XLfFCj68R7UoHq/XdHWQLiOgrqW9N46iFQwVApFA9WPXjWTAhdMimJfycyJGzR9Qgx8ZUGF5p7LX/ylgmE85tLNGKu7nuyUcaYWfsEz72nDM/X1jEZlFvew7n8AL6CSmOYqc1LTIf/L0fHBv0sli9V4c2GPZwHMT+tH9M9qD/i28KaKV7lBlCw7QvyAb7kv7kbk2V6Yg+21figjo0Ks0juYvdbrFBk1oEdxybH2qat9GNzK6hY/fHkcsGSE4EWTGPnn/bHo4eDyd5O73Yul+QpE7DHbF9GwMDGV7aI5wWL6wDpZmM2lxJw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Stop using the maple subtree state and big node in favour of using three
destinations in the maple copy node.  That is, expand the way leaves
were handled to all levels of the tree and use the maple copy node to
track the new nodes.

Extract out the sibling init into the data calculation since this is
where the insufficient data can be detected.  The remainder of the
sibling code to shift the next iteration is moved to the
spanning_ascend() function, since it is not always needed.

Next introduce the dst_setup() function which will decide how many nodes
are needed to contain the data at this level.  Using the destination
count, populate the copy node's dst array with the new nodes and set
d_count to the correct value.  Note that this can be tricky in the case
of a leaf node with exactly enough room because of the rule against
NULLs at the end of leaves.

Once the destinations are ready, copy the data by altering the
cp_data_write() function to copy from the sources to the destinations
directly.  This eliminates the use of the big node in this code path.
On node completion, node_finalise() will zero out the remaining area and
set the metadata, if necessary.

spanning_ascend() is used to decide if the operation is complete.  It
may create a new root, converge into one destination, or continue
upwards by ascending the left and right write maple states.

One test case setup needed to be tweaked so that the targeted node was
surrounded by full nodes.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 include/linux/maple_tree.h       |  14 +
 lib/maple_tree.c                 | 605 +++++++++++++++++++++----------
 tools/testing/radix-tree/maple.c |   2 +-
 3 files changed, 437 insertions(+), 184 deletions(-)

diff --git a/include/linux/maple_tree.h b/include/linux/maple_tree.h
index db6a02788902a..0c464eade1d66 100644
--- a/include/linux/maple_tree.h
+++ b/include/linux/maple_tree.h
@@ -156,6 +156,17 @@ enum store_type {
 };
 
 struct maple_copy {
+	/*
+	 * min, max, and pivots are values
+	 * start, end, split are indexes into arrays
+	 * data is a size
+	 */
+
+	struct {
+		struct maple_node *node;
+		unsigned long max;
+		enum maple_type mt;
+	} dst[3];
 	struct {
 		struct maple_node *node;
 		unsigned long max;
@@ -178,7 +189,10 @@ struct maple_copy {
 
 	/*Avoid passing these around */
 	unsigned char s_count;
+	unsigned char d_count;
+	unsigned char split;
 	unsigned char data;
+	unsigned char height;
 };
 
 /**
diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index a9d4f3ef8e888..9bc921d99340a 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -1320,6 +1320,21 @@ void wr_mas_setup(struct ma_wr_state *wr_mas, struct ma_state *mas)
 	wr_mas->r_max = mas_safe_pivot(mas, wr_mas->pivots, mas->offset,
 				       wr_mas->type);
 }
+
+static inline
+void wr_mas_ascend(struct ma_wr_state *wr_mas)
+{
+	struct ma_state *mas = wr_mas->mas;
+
+	mas_ascend(mas);
+	wr_mas_setup(wr_mas, mas);
+	mas->end = ma_data_end(wr_mas->node, wr_mas->type, wr_mas->pivots,
+			       mas->max);
+	/* Careful, this may be wrong.. */
+	wr_mas->end_piv = wr_mas->r_max;
+	wr_mas->offset_end = mas->offset;
+}
+
 static inline unsigned long ma_leaf_max_gap(struct maple_node *mn,
 		enum maple_type mt, unsigned long min, unsigned long max,
 		unsigned long *pivots, void __rcu **slots)
@@ -2507,6 +2522,109 @@ static inline void mas_wmb_replace(struct ma_state *mas,
 	mas_update_gap(mas);
 }
 
+/*
+ * node_copy() - Copy from one node to another.
+ *
+ * @mas: The maple state
+ * @src: The source node
+ * @start: The offset into the src to start copying
+ * @size: The size to copy (non-zero)
+ * @s_max: The source node max
+ * @s_mt: The source maple node type
+ * @dst: The destination
+ * @d_start: The start location in the destination node
+ * @d_mt: The destination maple node type
+ */
+static inline
+unsigned long node_copy(struct ma_state *mas, struct maple_node *src,
+	unsigned char start, unsigned char size, unsigned long s_max,
+	enum maple_type s_mt, struct maple_node *dst, unsigned char d_start,
+	enum maple_type d_mt)
+{
+	unsigned long *s_pivots, *d_pivots;
+	void __rcu **s_slots, **d_slots;
+	unsigned long *s_gaps, *d_gaps;
+	unsigned long d_max;
+
+	d_slots = ma_slots(dst, d_mt) + d_start;
+	d_pivots = ma_pivots(dst, d_mt) + d_start;
+	s_slots = ma_slots(src, s_mt) + start;
+	s_pivots = ma_pivots(src, s_mt) + start;
+	memcpy(d_slots, s_slots, size * sizeof(void __rcu *));
+	if (!ma_is_leaf(d_mt) && s_mt == maple_copy) {
+		struct maple_enode *edst = mt_mk_node(dst, d_mt);
+
+		for (int i = 0; i < size; i++)
+			mas_set_parent(mas, d_slots[i], edst, d_start + i);
+	}
+
+	d_gaps = ma_gaps(dst, d_mt);
+	if (d_gaps) {
+		s_gaps = ma_gaps(src, s_mt) + start;
+		d_gaps += d_start;
+		memcpy(d_gaps, s_gaps, size * sizeof(unsigned long));
+	}
+
+	if (start + size - 1 < mt_pivots[s_mt])
+		d_max = s_pivots[size - 1];
+	else
+		d_max = s_max;
+
+	if (d_start + size <= mt_pivots[d_mt])
+		d_pivots[size - 1] = d_max;
+
+	size--;
+	if (size)
+		memcpy(d_pivots, s_pivots, size * sizeof(unsigned long));
+
+	return d_max;
+}
+
+/*
+ * node_finalise() - Zero out unused area and populate metadata
+ * @node: The maple node
+ * @mt: The maple node type
+ * @end: The end of the used area
+ */
+static inline
+void node_finalise(struct maple_node *node, enum maple_type mt,
+		   unsigned char end)
+{
+	unsigned char max_end = mt_slots[mt];
+	unsigned char size;
+	unsigned long *gaps;
+	unsigned char gap_slot;
+
+	gaps = ma_gaps(node, mt);
+	if (end < max_end - 1) {
+		size = max_end - end;
+		memset(ma_slots(node, mt) + end, 0, size * sizeof(void *));
+
+		if (gaps)
+			memset(gaps + end, 0, size * sizeof(unsigned long));
+
+		if (--size)
+			memset(ma_pivots(node, mt) + end, 0, size * sizeof(unsigned long));
+	}
+
+	gap_slot = 0;
+	if (gaps && !ma_is_leaf(mt)) {
+		unsigned long max_gap;
+
+		max_gap = 0;
+		for (int i = 0; i <= end; i++)
+			if (gaps[i] > max_gap) {
+				gap_slot = i;
+				max_gap = gaps[i];
+			}
+	}
+
+	if (mt == maple_arange_64)
+		ma_set_meta(node, mt, gap_slot, end - 1);
+	else if (end <= max_end - 1)
+		ma_set_meta(node, mt, gap_slot, end - 1);
+}
+
 /*
  * mast_cp_to_nodes() - Copy data out to nodes.
  * @mast: The maple subtree state
@@ -2678,6 +2796,7 @@ static inline void cp_leaf_init(struct maple_copy *cp,
 {
 	unsigned char end = 0;
 
+	cp->height = 1;
 	/* Create entries to insert including split entries to left and right */
 	if (l_wr_mas->r_min < mas->index) {
 		end++;
@@ -2719,6 +2838,100 @@ static inline void cp_data_calc(struct maple_copy *cp,
 	cp->data += r_wr_mas->mas->end - r_wr_mas->offset_end;
 }
 
+/*
+ * spanning_data() - Calculate the @cp data and populate @sib if insufficient
+ * @cp: The maple copy node
+ * @l_wr_mas: The left write maple state
+ * @r_wr_mas: The right write maple state
+ * @sib: The maple state of the sibling.
+ *
+ * Note: @cp->data is a size and not indexed by 0. @sib->end may be set to 0 to
+ * indicate it will not be used.
+ */
+static inline void spanning_data(struct maple_copy *cp,
+		struct ma_wr_state *l_wr_mas, struct ma_wr_state *r_wr_mas,
+		struct ma_state *sib)
+{
+	cp_data_calc(cp, l_wr_mas, r_wr_mas);
+	if (((l_wr_mas->mas->min != 0) || (r_wr_mas->mas->max != ULONG_MAX)) &&
+	    (cp->data <= mt_min_slots[l_wr_mas->type])) {
+		spanning_sib(l_wr_mas, r_wr_mas, sib);
+		cp->data += sib->end + 1;
+	} else {
+		sib->end = 0;
+	}
+}
+
+/*
+ * dst_setup() - Set up one or more destinations for the new data.
+ * @cp: The maple copy node
+ * @mas: The maple state
+ * @mt: The source node type
+ */
+static inline
+void dst_setup(struct maple_copy *cp, struct ma_state *mas, enum maple_type mt)
+{
+	/* Data is 1 indexed, every src has +1 added.  */
+
+	if (cp->data <= mt_slots[mt]) {
+		cp->split = cp->data - 1;
+		cp->d_count = 1;
+		goto node_setup;
+	}
+
+	cp->split = (cp->data - 1) / 2;
+	cp->d_count = 2;
+	if (cp->data < mt_slots[mt] * 2)
+		goto node_setup;
+
+	if (cp->data == mt_slots[mt] * 2) {
+		unsigned char off;
+		unsigned char s;
+
+		if (!ma_is_leaf(mt))
+			goto node_setup;
+
+		/*
+		 * Leaf nodes are a bit tricky because we cannot assume the data
+		 * can fit due to the NULL limitation on node ends.
+		 */
+		off = cp->split;
+		for (s = 0; s < cp->s_count; s++) {
+			unsigned char s_off;
+
+			s_off = cp->src[s].end - cp->src[s].start;
+			if (s_off >= off)
+				break;
+
+			s_off++;
+			off -= s_off;
+		}
+
+		off += cp->src[s].start;
+		if (ma_slots(cp->src[s].node, cp->src[s].mt)[off])
+			goto node_setup;
+
+		cp->split++;
+		if (cp->split < mt_slots[mt])
+			goto node_setup;
+
+		cp->split -= 2;
+		if (cp->data - 2 - cp->split < mt_slots[mt])
+			goto node_setup;
+
+	}
+
+	/* No other choice but to 3-way split the data */
+	cp->split = (cp->data + 2) / 3;
+	cp->d_count = 3;
+
+node_setup:
+	for (int i = 0; i < cp->d_count; i++) {
+		cp->dst[i].mt = mt;
+		cp->dst[i].node = ma_mnode_ptr(mas_pop_node(mas));
+	}
+}
+
 static inline void append_mas_cp(struct maple_copy *cp,
 	struct ma_state *mas, unsigned char start, unsigned char end)
 {
@@ -2806,38 +3019,147 @@ void multi_src_setup(struct maple_copy *cp, struct ma_wr_state *l_wr_mas,
 }
 
 static inline
-void cp_data_write(struct maple_copy *cp, struct maple_big_node *b_node)
+void cp_data_write(struct maple_copy *cp, struct ma_state *mas)
 {
-	struct maple_node *src;
-	unsigned char s;
+	struct maple_node *dst, *src;
+	unsigned char s, d;
+	unsigned char dst_offset;
+	unsigned char data_offset;
 	unsigned char src_end, s_offset;
-	unsigned long *b_pivots, *cp_pivots;
-	void __rcu **b_slots, **cp_slots;
-	enum maple_type s_mt;
+	unsigned char split;
+	unsigned long s_max, d_max;
+	unsigned char dst_size;
+	enum maple_type s_mt, d_mt;
+
+	data_offset = 0;
+	s = d = 0;
+	/* Readability help */
+	src = cp->src[s].node;
+	dst = cp->dst[d].node;
+	s_offset = cp->src[s].start;
+	src_end = cp->src[s].end;
+	split = cp->split;
+	s_max = cp->src[s].max;
+	s_mt = cp->src[s].mt;
+	d_mt = cp->dst[d].mt;
+	do {
+		dst_offset = 0;
+		d_max = 0;
+		dst = cp->dst[d].node;
+		d_mt = cp->dst[d].mt;
+		dst_size = split + 1;
 
-	b_node->b_end = 0;
+		while (dst_size) {
+			unsigned char size;
 
-	s = 0;
-	b_pivots = b_node->pivot;
-	b_slots = (void __rcu *)b_node->slot;
-	do {
-		unsigned char size;
-
-		src = cp->src[s].node;
-		s_mt = cp->src[s].mt;
-		s_offset = cp->src[s].start;
-		src_end = cp->src[s].end;
-		size = src_end - s_offset + 1;
-		cp_pivots = ma_pivots(src, s_mt) + s_offset;
-		cp_slots = ma_slots(src, s_mt) + s_offset;
-		memcpy(b_slots, cp_slots, size * sizeof(void __rcu *));
-		if (size > 1)
-			memcpy(b_pivots, cp_pivots, (size - 1) * sizeof(unsigned long));
-		b_pivots[size - 1] = cp->src[s].max;
-		b_pivots += size;
-		b_slots += size;
-		b_node->b_end += size;
-	} while (++s < cp->s_count);
+			if (src_end - s_offset + 1 < dst_size)
+				size = src_end - s_offset + 1;
+			else
+				size = dst_size;
+
+			d_max = node_copy(mas, src, s_offset, size, s_max, s_mt,
+					  dst, dst_offset, d_mt);
+
+			dst_offset += size;
+			s_offset += size;
+			if (s_offset > src_end) {
+				/* This source is exhausted */
+				s++;
+				if (s >= cp->s_count) {
+					cp->dst[d].max = d_max;
+					node_finalise(dst, d_mt, dst_offset);
+					return;
+				}
+				/* Reset local src */
+				src = cp->src[s].node;
+				s_offset = cp->src[s].start;
+				src_end = cp->src[s].end;
+				s_max = cp->src[s].max;
+				s_mt = cp->src[s].mt;
+			}
+
+			dst_size -= size;
+			data_offset += size;
+		}
+
+		split = cp->split;
+		cp->dst[d].max = d_max;
+		/* Handle null entries */
+		if (cp->dst[d].max != ULONG_MAX &&
+		    !ma_slots(dst, d_mt)[dst_offset - 1]) {
+			if (s_offset == cp->src[s].start) {
+				s--;
+				src = cp->src[s].node;
+				src_end = cp->src[s].end;
+				s_max = cp->src[s].max;
+				s_mt = cp->src[s].mt;
+				s_offset = src_end;
+			} else {
+				s_offset--;
+			}
+			/* Set dst max and clear pivot */
+			split++;
+			data_offset--;
+			dst_offset--;
+			cp->dst[d].max = ma_pivots(dst, d_mt)[dst_offset - 1];
+		}
+
+		node_finalise(dst, d_mt, dst_offset);
+		++d; /* Next destination */
+		if (d == cp->d_count - 1)
+			split = cp->data - data_offset;
+
+		if (d >= cp->d_count) {
+			WARN_ON(data_offset < cp->data);
+			return;
+		}
+
+	} while (data_offset <= cp->data);
+}
+
+/*
+ * cp_dst_to_slots() - Migrate the maple copy destination to the maple copy
+ * slots
+ * @cp: The maple copy node
+ * @min: The minimal value represented
+ * @max: The maximum value represented
+ * @mas: The maple state
+ */
+static inline void cp_dst_to_slots(struct maple_copy *cp, unsigned long min,
+		unsigned long max, struct ma_state *mas)
+{
+	unsigned char d;
+	unsigned long slot_min = min;
+
+	for (d = 0; d < cp->d_count; d++) {
+		struct maple_node *mn = cp->dst[d].node;
+		enum maple_type mt = cp->dst[d].mt;
+		unsigned long slot_max = cp->dst[d].max;
+
+		cp->slot[d] = mt_mk_node(mn, mt);
+		cp->pivot[d] = slot_max;
+		if (mt_is_alloc(mas->tree)) {
+			if (ma_is_leaf(mt)) {
+				cp->gap[d] = ma_leaf_max_gap(mn, mt, slot_min,
+						slot_max, ma_pivots(mn, mt),
+						ma_slots(mn, mt));
+			} else {
+				unsigned long *gaps = ma_gaps(mn, mt);
+
+				if (gaps) {
+					unsigned char gap_slot;
+
+					gap_slot = ma_meta_gap(mn);
+					cp->gap[d] = gaps[gap_slot];
+				}
+			}
+		}
+		slot_min = slot_max + 1;
+	}
+
+	cp->end = cp->d_count - 1;
+	cp->min = min;
+	cp->max = max;
 }
 
 static void mas_spanning_rebalance_loop(struct ma_state *mas,
@@ -2993,173 +3315,90 @@ static void mas_spanning_rebalance(struct ma_state *mas,
 	mas_spanning_rebalance_loop(mas, mast, count);
 }
 
+/*
+ * spanning_ascend() - See if a spanning store operation has to keep walking up
+ * the tree
+ * @cp: The maple_copy node
+ * @l_wr_mas: The left maple write state
+ * @r_wr_mas: The right maple write state
+ * @sib: the maple state of the sibling
+ *
+ * Returns: True if another iteration is necessary.
+ */
+static bool spanning_ascend(struct maple_copy *cp, struct ma_state *mas,
+			    struct ma_wr_state *l_wr_mas, struct ma_wr_state *r_wr_mas,
+			    struct ma_state *sib)
+{
+	if (sib->end) {
+		if (sib->max < l_wr_mas->mas->min)
+			*l_wr_mas->mas = *sib;
+		else
+			*r_wr_mas->mas = *sib;
+	}
+
+	cp_dst_to_slots(cp, l_wr_mas->mas->min, r_wr_mas->mas->max, mas);
+	if (!cp->min && cp->max == ULONG_MAX) {
+		/* New root */
+		if (cp->d_count != 1) {
+			enum maple_type mt = maple_arange_64;
+
+			if (!mt_is_alloc(mas->tree))
+				mt = maple_range_64;
+
+			cp->data = cp->d_count;
+			cp->s_count = 0;
+			dst_setup(cp, mas, mt);
+			init_cp_src(cp);
+			node_copy(mas, cp->src[0].node, 0, cp->data, cp->max, maple_copy,
+				  cp->dst[0].node, 0, mt);
+			node_finalise(cp->dst[0].node, mt, cp->end + 1);
+			cp->slot[0] = mt_mk_node(cp->dst[0].node, mt);
+			cp->height++;
+		}
+		WARN_ON_ONCE(cp->dst[0].node != mte_to_node(cp->slot[0]));
+		cp->dst[0].node->parent = ma_parent_ptr(mas_tree_parent(mas));
+		mas->min = 0;
+		mas->max = ULONG_MAX;
+		mas->depth = 0;
+		mas->node = mas_root_locked(mas);
+		return false;
+	}
+
+	/* Converged and has a single destination */
+	if ((cp->d_count == 1) &&
+	    (l_wr_mas->mas->node == r_wr_mas->mas->node)) {
+		cp->dst[0].node->parent = ma_parent_ptr(mas_mn(mas)->parent);
+		return false;
+	}
+
+	cp->height++;
+	wr_mas_ascend(l_wr_mas);
+	wr_mas_ascend(r_wr_mas);
+	return true;
+}
 
 static noinline void mas_wr_spanning_rebalance(struct ma_state *mas,
 		struct ma_wr_state *l_wr_mas, struct ma_wr_state *r_wr_mas)
 {
 
-	unsigned char split, mid_split;
-	unsigned char slot = 0;
-	unsigned char new_height = 0; /* used if node is a new root */
-	struct maple_enode *left = NULL, *middle = NULL, *right = NULL;
 	struct maple_enode *old_enode;
-
-	struct maple_subtree_state mast;
-	struct maple_big_node b_node;
 	struct maple_copy cp;
-	unsigned char height;
 	struct ma_state sib;
-	MA_STATE(l_mas, mas->tree, mas->index, mas->index);
-	MA_STATE(r_mas, mas->tree, mas->index, mas->last);
-	MA_STATE(m_mas, mas->tree, mas->index, mas->index);
-	MA_STATE(mast_l_mas, NULL, 0, 0);
 
-
-	memset(&b_node, 0, sizeof(struct maple_big_node));
-	mast_l_mas = *mas;
-	cp.s_count = 0;
 	cp_leaf_init(&cp, mas, l_wr_mas, r_wr_mas);
-	cp_data_calc(&cp, l_wr_mas, r_wr_mas);
-	if (((l_wr_mas->mas->min != 0) || (r_wr_mas->mas->max != ULONG_MAX)) &&
-	    (cp.data <= mt_min_slots[l_wr_mas->type])) {
-		spanning_sib(l_wr_mas, r_wr_mas, &sib);
-		cp.data += sib.end + 1;
-	} else {
-		sib.end = 0;
-	}
-
-	multi_src_setup(&cp, l_wr_mas, r_wr_mas, &sib);
-	b_node.type = l_wr_mas->type;
-	cp_data_write(&cp, &b_node);
-	if (sib.end) {
-		if (sib.max < l_wr_mas->mas->min) {
-			*l_wr_mas->mas = sib;
-			wr_mas_setup(l_wr_mas, &sib);
-			mast_l_mas = sib;
-		} else {
-			*r_wr_mas->mas = sib;
-			wr_mas_setup(r_wr_mas, &sib);
-		}
-	}
-
-	mast.orig_l = &mast_l_mas;
-	mast.orig_r = r_wr_mas->mas;
-	/* Stop spanning searches by searching for just index. */
-	mast.orig_l->last = mas->index;
-
-	mast.bn = &b_node;
-	/* Combine l_mas and r_mas and split them up evenly again. */
-
-	/*
-	 * The tree needs to be rebalanced and leaves need to be kept at the same level.
-	 * Rebalancing is done by use of the ``struct maple_topiary``.
-	 */
-	mast.l = &l_mas;
-	mast.m = &m_mas;
-	mast.r = &r_mas;
-	l_mas.status = r_mas.status = m_mas.status = ma_none;
-	height = mas_mt_height(mas) + 1;
-
-	/*
-	 * Each level of the tree is examined and balanced, pushing data to the left or
-	 * right, or rebalancing against left or right nodes is employed to avoid
-	 * rippling up the tree to limit the amount of churn.  Once a new sub-section of
-	 * the tree is created, there may be a mix of new and old nodes.  The old nodes
-	 * will have the incorrect parent pointers and currently be in two trees: the
-	 * original tree and the partially new tree.  To remedy the parent pointers in
-	 * the old tree, the new data is swapped into the active tree and a walk down
-	 * the tree is performed and the parent pointers are updated.
-	 * See mas_topiary_replace() for more information.
-	 */
-	while (height--) {
-		mast.bn->b_end--;
-		mast.bn->type = mte_node_type(mast.orig_l->node);
-		split = mas_mab_to_node(mas, mast.bn, &left, &right, &middle,
-					&mid_split);
-		mast_set_split_parents(&mast, left, middle, right, split,
-				       mid_split);
-		mast_cp_to_nodes(&mast, left, middle, right, split, mid_split);
-		new_height++;
-
-		/*
-		 * Copy data from next level in the tree to mast.bn from next
-		 * iteration
-		 */
-		memset(mast.bn, 0, sizeof(struct maple_big_node));
-		mast.bn->type = mte_node_type(left);
-
-		/* Root already stored in l->node. */
-		if (mas_is_root_limits(mast.l))
-			goto new_root;
-
-		mast_ascend(&mast);
-		mast_combine_cp_left(&mast);
-		mast.l->offset = mast.bn->b_end;
-		mab_set_b_end(mast.bn, mast.l, left);
-		mab_set_b_end(mast.bn, mast.m, middle);
-		mab_set_b_end(mast.bn, mast.r, right);
-
-		/* Copy anything necessary out of the right node. */
-		mast_combine_cp_right(&mast);
-		mast.orig_l->last = mast.orig_l->max;
-
-		if (mast_sufficient(&mast)) {
-			if (mast_overflow(&mast))
-				continue;
-
-			if (mast.orig_l->node == mast.orig_r->node) {
-			       /*
-				* The data in b_node should be stored in one
-				* node and in the tree
-				*/
-				slot = mast.l->offset;
-				break;
-			}
-
-			continue;
-		}
-
-		/* May be a new root stored in mast.bn */
-		if (mas_is_root_limits(mast.orig_l))
-			break;
-
-		mast_spanning_rebalance(&mast);
-
-		/* rebalancing from other nodes may require another loop. */
-		if (!height)
-			height++;
-	}
-
-	mast.l->node = mt_mk_node(ma_mnode_ptr(mas_pop_node(mas)),
-				mte_node_type(mast.orig_l->node));
-
-	mab_mas_cp(mast.bn, 0, mt_slots[mast.bn->type] - 1, mast.l, true);
-	new_height++;
-	mas_set_parent(mas, left, mast.l->node, slot);
-	if (middle)
-		mas_set_parent(mas, middle, mast.l->node, ++slot);
-
-	if (right)
-		mas_set_parent(mas, right, mast.l->node, ++slot);
-
-	if (mas_is_root_limits(mast.l)) {
-new_root:
-		mas_mn(mast.l)->parent = ma_parent_ptr(mas_tree_parent(mas));
-		while (!mte_is_root(mast.orig_l->node))
-			mast_ascend(&mast);
-	} else {
-		mas_mn(mast.l)->parent = mas_mn(mast.orig_l)->parent;
-	}
-
-	old_enode = mast.orig_l->node;
-	mas->depth = mast.l->depth;
-	mas->node = mast.l->node;
-	mas->min = mast.l->min;
-	mas->max = mast.l->max;
-	mas->offset = mast.l->offset;
-	mas_wmb_replace(mas, old_enode, new_height);
+	do {
+		spanning_data(&cp, l_wr_mas, r_wr_mas, &sib);
+		multi_src_setup(&cp, l_wr_mas, r_wr_mas, &sib);
+		dst_setup(&cp, mas, l_wr_mas->type);
+		cp_data_write(&cp, mas);
+	} while (spanning_ascend(&cp, mas, l_wr_mas, r_wr_mas, &sib));
+
+	old_enode = mas->node;
+	mas->node = cp.slot[0];
+	mas_wmb_replace(mas, old_enode, cp.height);
 	mtree_range_walk(mas);
 }
+
 /*
  * mas_rebalance() - Rebalance a given node.
  * @mas: The maple state
diff --git a/tools/testing/radix-tree/maple.c b/tools/testing/radix-tree/maple.c
index 85fb5616c133c..dfd7099f0d8ef 100644
--- a/tools/testing/radix-tree/maple.c
+++ b/tools/testing/radix-tree/maple.c
@@ -35508,7 +35508,7 @@ static noinline void __init check_spanning_write(struct maple_tree *mt)
 	/* Store a value across a node boundary that causes a 3 way split */
 
 	if (MAPLE_32BIT)
-		i = 49590; /* 0xc1b6 */
+		i = 49430; /* 0xc116 */
 	else
 		i = 49670; /* 0xC206 */
 
-- 
2.47.3


