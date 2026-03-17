Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6993FD876A
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 13:45:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B3226B0005; Tue, 17 Mar 2026 09:45:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 063E76B0088; Tue, 17 Mar 2026 09:45:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6DE56B008A; Tue, 17 Mar 2026 09:45:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D5DBF6B0005
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 09:45:43 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8A179B61DD
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 13:45:43 +0000 (UTC)
X-FDA: 84555677766.19.7426657
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010038.outbound.protection.outlook.com [52.101.61.38])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6F2B41C0005
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 13:45:40 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=Nvidia.com header.s=selector2 header.b=GcO1oFgz;
	spf=pass (imf21.hostedemail.com: domain of leonro@nvidia.com designates 52.101.61.38 as permitted sender) smtp.mailfrom=leonro@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773755140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pnPneM6OE4D8kHxrsb0gZc8qXdHPFBQWUf/K9FjkaeM=;
	b=KYPQBi7431W+YbbDeEro6f1p5n3I92HZTVsM/pK4oTNJa64rK4YRdKL6kbdr8GZUxsuqRQ
	GfApHGWgW0w+S8oWVfzr9LDFV3kqSk149f8ZF7Il5Z/ehiMTXnArxagXAgKTAcP90+TfpC
	laJjGy7s53R9MRS5DWxDvZG/dSnJmxQ=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=Nvidia.com header.s=selector2 header.b=GcO1oFgz;
	spf=pass (imf21.hostedemail.com: domain of leonro@nvidia.com designates 52.101.61.38 as permitted sender) smtp.mailfrom=leonro@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773755140; a=rsa-sha256;
	cv=fail;
	b=kyM8XFLhsKDOptincj+AC7kpW5ClmwUyaY3Tkju32gahMrq2zfv22avcjGdiApGAIcOfOu
	IGr6R2bX6Bzu7KVkUN7SxLnCsoe9MuKWKBXNcw/bWfs70iHVwEPCVnJGY33Jeo/cEd2oLE
	vp59qJ1yPsUsqM94VCdB+05RCTnCDQs=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l13wot9nzAc/wmYOk4hHIa3adnQaD9+iQZ9KC8lZJVlP8LVDd9WpfZCBENRLe9G3OmTDhSJl/uiL88tW0SJU7Dsw0lomcfcuB7Du2B4NyDS3wj8ulchQ6SfdM09ZQ0VDnZjHSnjMnZbAzAYxBYdgyRnIZzAJc2N/nMi/IifWPgyPWljmyHMO0Ce/x3OhPL2FMwacsyWUEcejJ7a82GZUrTnF8HSa5bV8WqUcqCXGQQy8y+vjxsbevjEj35kZaRIoBpkc5SnSvIN5w/LHKkogC0N/RtmRrF4u8Uuab0xfMLGjHOPNgzPNQWyV/eil4GMO3IP/tJXsi4kDmOlx9WlY0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TZ8q1Gr2sBie0HpFJh+zk3S264yKHkq8RdPcNUoZ1Ec=;
 b=eqi28mCu+4/+dH6N4xYd7+Xe4tqQb5QZhsVUiVVn/lgFgVWfF1Gk6Aij6BFdiN2jkSgbtgWTIKcwbl6QBishrS8DRK79HB/AaZDepwRhlW55AR58Ymqcjx32m1shKrqV4f5Gz/VZ65CACBPhhyRuoFFZ0UAUr9XK36i9rsEq6wM7PPO/VbubZf4sgJxJ3KRIgFFiizKpd+XR0hh9u4moqK1TQhvbcLz2tDcaKEvACksBxtA0bENt5wo5k3dIS2uVQ3IiLowL+LimYpLzBaUiEjUgb+jncGazllznh7yCI3BrRammbIQqoKGsj2182HpmU6Km9edoyBRN3s05dhwObA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TZ8q1Gr2sBie0HpFJh+zk3S264yKHkq8RdPcNUoZ1Ec=;
 b=GcO1oFgzh2qBX662EsKBhXl3+Ifa9fMpkKnmdjJUOcXC2Vw7hOEsjF7oGbXc4sLTOBYCYxtIz1izbSe8B4JoHIKBVlzFsqalQA6sUaOcjfZqQmoHURA9E6tbL3s1xasJKQNWh7XLov3+3f9WrAcYINL8C4OWXjVeQK+B9xJVGZvE3XqB4h2SfoxIoUohG5za99RZ5Ug1YMfBkQTUdKf3JyajFSIWxzo6s1XhgERpG0yuhJa0UmfHOUuZZ+vD+4zkehs2QbEkrJs6xcg61jR5CRAiCnCcxmwOo7dxHlcZLJLqlLxe5UsDPXOp8GFDSsibOgKdsnM4s1Vo7DJiWshSgA==
Received: from CYZPR14CA0042.namprd14.prod.outlook.com (2603:10b6:930:a0::18)
 by MW5PR12MB5599.namprd12.prod.outlook.com (2603:10b6:303:194::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.17; Tue, 17 Mar
 2026 13:45:35 +0000
Received: from CY4PEPF0000FCC4.namprd03.prod.outlook.com
 (2603:10b6:930:a0:cafe::4f) by CYZPR14CA0042.outlook.office365.com
 (2603:10b6:930:a0::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.27 via Frontend Transport; Tue,
 17 Mar 2026 13:45:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000FCC4.mail.protection.outlook.com (10.167.242.106) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9700.17 via Frontend Transport; Tue, 17 Mar 2026 13:45:34 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 17 Mar
 2026 06:45:14 -0700
Received: from localhost (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 17 Mar
 2026 06:45:12 -0700
Date: Tue, 17 Mar 2026 15:45:09 +0200
From: Leon Romanovsky <leonro@nvidia.com>
To: Mika =?iso-8859-1?Q?Penttil=E4?= <mpenttil@redhat.com>
CC: "David Hildenbrand (Arm)" <david@kernel.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, Jason Gunthorpe <jgg@nvidia.com>, "Alistair
 Popple" <apopple@nvidia.com>, Balbir Singh <balbirs@nvidia.com>, Zi Yan
	<ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>
Subject: Re: [PATCH v5 2/6] mm: Add helper to convert HMM pfn to migrate pfn
Message-ID: <20260317134509.GZ61385@unreal>
References: <20260211081301.2940672-1-mpenttil@redhat.com>
 <20260211081301.2940672-3-mpenttil@redhat.com>
 <3c0578a9-ce1c-4d26-86d5-681cae4b8200@kernel.org>
 <59d3c0e5-23fb-4a30-825a-d90fd07bd34e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <59d3c0e5-23fb-4a30-825a-d90fd07bd34e@redhat.com>
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCC4:EE_|MW5PR12MB5599:EE_
X-MS-Office365-Filtering-Correlation-Id: cd3f06aa-1972-4c5a-20e9-08de842b771b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|82310400026|36860700016|7053199007|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	wOmnnxID5tXzG0olRSRunfCmqCPkGgnKg/pE4u+4qPVbwBnQ3Vd9J7brqTgtUxP521SnG7M3MgIG2c1oEjDFKG8irjvQXoHCEpPS5YL2Eq/dlp3QDfxcSx7DBDgG3zJQphGiFXzX1pYAG7jOhNgPR85hJkPtipk9VDWAfVirw99aAI2fUWUVP41SBL99ZnEDrw4ip0kFVau4o6WcIe7d4evoMSSYsjVB0fzwtu6uI7g19qzB5qNahTmAw+H4/+F9fn5SU3y2p4i6e19JTDTTAhhEhqi4tdFt+kc2n46toNc6edus+tzmbVK2tlCFkafyVvT+yufoNFbEs3S7Wz74iJFzGasq803AJdW5Lto60Ez5RRY6tBK5fJF61g47ZJ7X5NpvTAoZU3m/9JWwxLjv9sTVAdE5xUKPygO6r36b4fTrpcZtQAR+lmoU09h3ONdjnVms+tQMWoOYqT9+YGA3fMZOUK3S6G66MDBEDspRqwNXTeWOLe9qR2A3NtCWCAL4PV+mj8plljafUANWkh7nMQQIY2jjIwtvdVp+/+viNs4oD2j/HZXlkdKucaY2hscR9FpLzpd2YwngJ/pzzBcHTSLb1FhG1VTn/krZ3EbRM5tw8qsKPf2dCzzx9Ny6C4OPzUKDdLbcrCEMbUkp5LZCyQ3qpzpQHBDAp5jLdm+nHVHQmeJ/l5fb5ML4QN4a1+Xwye+hn/VX8mByK1dkKiOH5oAxsHclspDXsY2ub444Jhi8OU9lFIpogTRq9Yhg6nUVEzBsUMpvIr2/+b3aS2IxGA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(82310400026)(36860700016)(7053199007)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	5sG+nW5936lSW5IMfV+Nq2IW8rbDl9geDm9QHvdS/PV3OqK/24N/MjslBnPwbkJPyjtPewMmm5BK3GBrCCnCRrwF8kpDYKESj0xr1ILtzdFpQfu6Yx3ZWl7nMlLUQquKRXDaI+WjARUvisiQXyH+5tCjBns2xIPb7iHdmHvIkoGUZqM/5zs780U0wVtq1mwsWAt93dwaQYzb2klKdxmw1pu6pDNCDJ19UM6z5JW/UdBcqLNsBCmH/+wbhKa5/4qt0faPB5xDVzg4bGAxt4uH/53K1cuuHgLdbxsNcibeIVyXtuyhGIbwkKLI/JAEB69LRiQKJB+wlPaLFKxfcdt2GPeRwwVUEYElYDF9YCpZ7Mtzihj8Ti2cm9RGwj63mCCvVP0hT+TgpPn+Cb6m56x4H1NMWJmAeGSe12KIbAg4U7sJG35A9UwVPft8l6gzt79l
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2026 13:45:34.8732
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cd3f06aa-1972-4c5a-20e9-08de842b771b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000FCC4.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR12MB5599
X-Rspamd-Queue-Id: 6F2B41C0005
X-Rspamd-Server: rspam07
X-Stat-Signature: 1ad1nut9snmbx3h8ii8igq4577pbm6hp
X-Rspam-User: 
X-HE-Tag: 1773755140-793137
X-HE-Meta: U2FsdGVkX18A9zJtvCL8B7a+dRZaDmszOu4T8xgVFXcyvMvjg8Z6b09dBaTncYqpDmW4pXRNleSEkb8UpIstIAmYNXlQ2ng5UOSLclWNCevvdKyztqXcUjNPGN4AuxVjVNfvgeYLDnB20Kb5XP/taHbJtYg3GRe2Hn4Fv+3UE1pywRhKK/LjeRmj6z20+8ieVpJKVKGOzrW2Hwbr8NU0qnDabBKTJVj6FZmN9EWF8edJw+K8wdgMsqC1GcGWxqbf+BNYP+ySDdXnXlyJQVQF9+n3eP+n/SMRFX5hE+sUItUSnruCaf08bdKpuhpuM+CARQAWDLwpiS6hP7I8e+m5pzDOzEcwIH2SGK0HLH0mYTXFOUZkHNujjDAWtEGRMo1shqAtKqzjml7oin5JSCXXtx/CqlWf02MJru26x9Qo6XhBV5pdccjefoo4QA7JA5O/jPRxfh3SisjDYBB5+eqziUatvP6saAbtxqYkjz0FqBvFN9NZDqEjKA+KkYmrbPjLJ4ize8YSTAHrUqHh0o63ysxk5avxfRuyagRaFs/bo762yM/wOlOHgpdTJ6Xw8chJgGQ3L66hJNrMU8VIy1qkAAFp1YDuTqN3JQqbXbbO56M6aNFif9B2lbnvLmJPTy3lTYWHZ+b5aD5NouJ75XlPlyTzILzT+C9PpaS0zXuTun+N2lps8GnJY/xEzgk3PA7ZdUCyV/Mm4Xv1ceIL8/5UF97Qjvk+YSOwKqfvZjh5yfl59CQbc56rZCzve5oy8SLPftFlID5osPrRo+k1zkftK+4qHS7zJfc0yiFgrxBJxyLrDZGCmpzTZPLu1kSzNm8TNBXOQodZq1NSQR96Ywv793It1IUiYrql8jzyPFVcnAWu1115xKTKp+U0gZt9xdteP78Jl45Pgol26IOvJYl1/DQ4LaKX9GLJDxXmlNPLZ7wkY1qsw8l8p4gFKIK+QbJLkDZz8rDdQ7TbUn/KyPW
 7Fc3oL8j
 zX71RvbXNrYATelbrM2HL/18NSpHCbkdw7lISCxgxbOB+m1+/sPXfZMI1H4lHkGj88iuTsQIjMbWCs2ZdVQw1xGeJxqfhCZ1UwatDZ1wl20z/o38aBJeaHh4qPM5H6s658jWyEKqAszRrVN/U/1Ls+uTImzvQNm9fTCkSp7KUDwiDY9QDdxrXsxW8BsjYYr3kSXJ1O63+J/aF2jwGqfuQnRo4uBtpzeuCnDCDCakd8PavUD19yeuxtqKVs2RLuywqActl0Gs5uQmOouPTWdQThajEozbj90vk3oAUw74UydRUdERbw0HMRsJi+RVyohd5iNKKm71nILqwQ+8L/NajrXhZWLh929+uf1zjvHIjfyL0Bd1cQ+gGo68n9ZKD2lv+Kkg8yVYVPsITpzpN8OrXTXF6Oxs8nJBujUf4/SR4mO2UXwjeOq04scrlZf9mCwQ3spkkvqitSsuXA7nS8pbB7nnh2soP7zVykeRkia51D+Zxr82fiVjD+wp1wqv96/psf1Vss1+rnfuN8NyqWE+9XAXY+DlCle1Hu+NKXoMcwUDYnKxIyskF610J7+RXme5qhQyScQ92c3FR8c8rU5fEZQX8tNdfBDWyGdHOd6fVbEo/uaUPyx3z/w3z48fK7usCNbvH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 17, 2026 at 03:01:09PM +0200, Mika Penttilä wrote:
> Hi,
> 
> On 3/17/26 11:05, David Hildenbrand (Arm) wrote:
> 
> > On 2/11/26 09:12, mpenttil@redhat.com wrote:
> >> From: Mika Penttilä <mpenttil@redhat.com>
> >>

<...>

> >>  enum hmm_pfn_flags {
> >>  	/* Output fields and flags */
> >> @@ -48,15 +50,25 @@ enum hmm_pfn_flags {
> >>  	HMM_PFN_P2PDMA     = 1UL << (BITS_PER_LONG - 5),
> >>  	HMM_PFN_P2PDMA_BUS = 1UL << (BITS_PER_LONG - 6),
> >>  
> >> -	HMM_PFN_ORDER_SHIFT = (BITS_PER_LONG - 11),
> >> +	/* Migrate request */
> >> +	HMM_PFN_MIGRATE    = 1UL << (BITS_PER_LONG - 7),
> >> +	HMM_PFN_COMPOUND   = 1UL << (BITS_PER_LONG - 8),
> >> +	HMM_PFN_ORDER_SHIFT = (BITS_PER_LONG - 13),

Please don't add fields which are not flags to enum hmm_pfn_flags.

Thanks

> >>  
> >>  	/* Input flags */
> >>  	HMM_PFN_REQ_FAULT = HMM_PFN_VALID,
> >>  	HMM_PFN_REQ_WRITE = HMM_PFN_WRITE,
> >> +	HMM_PFN_REQ_MIGRATE = HMM_PFN_MIGRATE,
> >>  
> >>  	HMM_PFN_FLAGS = ~((1UL << HMM_PFN_ORDER_SHIFT) - 1),
> >>  };
> >>  

