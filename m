Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3AF310775EB
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 17:36:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E2E56B02C7; Wed, 18 Mar 2026 13:36:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BA766B02C8; Wed, 18 Mar 2026 13:36:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEC456B02C9; Wed, 18 Mar 2026 13:36:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DBDFE6B02C7
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 13:36:18 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 999351D6FE
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 17:36:18 +0000 (UTC)
X-FDA: 84559887636.24.6B85131
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012037.outbound.protection.outlook.com [40.93.195.37])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9F56340012
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 17:36:15 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="ISac8f/s";
	spf=pass (imf11.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.37 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773855375;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0mQQaMZU0DTE99t6jVs2NEo3NyBoCnGRw9BbPAjCGMs=;
	b=BE2HmNREC4pRZtytMoA7tf4LiHZzdtXSk0+DAFjZMEA87sred33cDMnZcX4xNT9Wo3DjzG
	3SRkNP2OG6piCjxD43YOKshAeP0vJXyLpcJdU+2pNBNBIdidg5jrgO54QH8aoF2ZYUTnhC
	UnRy1UIuX6GL8DvUBn1jlMZFtgBiZd0=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="ISac8f/s";
	spf=pass (imf11.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.37 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773855375; a=rsa-sha256;
	cv=pass;
	b=sdQtkiLReypKaAx5QJBAwEFiVB6LJOVCwTY+II5WX66D9RAXs93JL4xbOijyltigFcddIu
	RVoDZnyzug/7yj83078LYDRwULpNtw7R4TmPN8r3YvZHC5WDXtF/IpvVPKVYlyrjrwj851
	V89SfDfox+J5ggxC7qPn3DLTACo8ogM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZkaU8FpoYZiQxNG042QhLkeDLv5LRJ4bCaJCQZSOUwQ+XlFk1TXK4z7bp7HDw5LqrV7SiDGmpS+IA45Cs3tbIfD+oXAwp088tbD3STTtxfiWRk8mvftExQjufFou8la0cC9uY9aJDJrIo9TMBHDkoE55BqFZ4AbZySYKvcW9iJFU1EQy6Z+TOte2W5CVNhiZB+AV9UeGanEEoOb03goCnGTTLTDuKhP1ztg4HFYYNGbbnRrEmDZCcgWlzJ0XpdcMUMOa33bM3VFBgiDGlMVUSdlX17xX6LG9+orMASqCoKL+bhflBVFU5FlCKp5EbU39xTDrtz012fBJvLgYvqL6jA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0mQQaMZU0DTE99t6jVs2NEo3NyBoCnGRw9BbPAjCGMs=;
 b=PkTBCNuu8pWwBv6bx+UjZQfxsbij+P1Qqdd/HoPd40EagYj//iPCcujuf9ZMHUxFnlRBquFcKx5uRUWX7P4TwQC63wCJxCgT7nWwhxc0h5Rj8RuDQdaLVvmud4bD6D8onCA+k/Au8tbep2h5s5Gec3SPg5NA/gX6wqywgLm+psreCuOxWmxIIt2o5cqNkLpW6gzeSAdIRRIYnpzEhJ4yPz+msIi7iw/sBh0E1lxSAHiJchig9/XdLLdCCDw6befaf3TN6DDmFO17LgAmP8lO09vvnsbR78e/Zsr3SoyV+hEcGScOM5EZP9zwiMpdSsDcICQ7EFhtizzeyfP2nMdf9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0mQQaMZU0DTE99t6jVs2NEo3NyBoCnGRw9BbPAjCGMs=;
 b=ISac8f/sA8Y9WdWm4l/NGMwYNdOZnMRw8T4sB65TZ0mt1SgoDtfyVXWVD0zLiHeQPieszWMKSFf9iSixSWtxGZQ0o6RqJezemuJScOvO0ZIlV2CI8l/g5iNvmmBRGe6J/iaXPmsOvDnyk7lzjI+00Cq+XjLcUUfdf8RbLyXF0eHkaHsutCmjYXoDegXU5rfps88A0i9LnynRzJgeFQ+X9ie1SWwESggjYt9WltNu/xpYtOWsfLIuarNPHsP6mlQoQ5hfk/ViSxL79dq+o7TT3e04xVbgL3Y24z7gyMCQpb3p0xacubevnW50tAiKYOTAM7OVbLHT4RUrgqD3+T9/Dg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 BN7PPF5D27497F1.namprd12.prod.outlook.com (2603:10b6:40f:fc02::6d1) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Wed, 18 Mar
 2026 17:36:11 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9723.016; Wed, 18 Mar 2026
 17:36:11 +0000
From: Zi Yan <ziy@nvidia.com>
To: =?utf-8?b?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>
Cc: Evangelos Petrongonas <epetron@amazon.de>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>,
 Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>,
 Samiullah Khawaja <skhawaja@google.com>, kexec@lists.infradead.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v7 2/3] kho: fix deferred init of kho scratch
Date: Wed, 18 Mar 2026 13:36:07 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <58A8B1B4-A73B-48D2-8492-A58A03634644@nvidia.com>
In-Reply-To: <CAAi7L5fvUPUqd3A4m6wubeYh90NH+S2KBRE1R8WKerBYhkU8kg@mail.gmail.com>
References: <20260317141534.815634-1-mclapinski@google.com>
 <20260317141534.815634-3-mclapinski@google.com>
 <AD9E1B18-C813-480E-894C-FEEB51EE8A93@nvidia.com>
 <CAAi7L5dSOxXETv-bYs4hJ1SfixMBQXS4fmfKs3SzVvQ=yY7oSg@mail.gmail.com>
 <76559EF5-8740-4691-8776-0ADD1CCBF2A4@nvidia.com>
 <CAAi7L5ex+66qgFzRkLDbuOmC=cVrMyBctPZv6wd15n1rc2U9KQ@mail.gmail.com>
 <0D1F59C7-CA35-49C8-B341-32D8C7F4A345@nvidia.com>
 <CAAi7L5fvUPUqd3A4m6wubeYh90NH+S2KBRE1R8WKerBYhkU8kg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BYAPR06CA0071.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::48) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|BN7PPF5D27497F1:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a7a3abb-5a4d-4766-3102-08de8514d858
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|366016|18002099003|56012099003|22082099003|7053199007;
X-Microsoft-Antispam-Message-Info:
	j2xX4yvF+fKqcTej2dZSYkxf/mG1RdWokEKsk590lXTeXY20lknPJ74r4/WEwCfP/fuyAiDSJLxZR7uZnseJlrGGg+13NZqBJ5+FmJsKTqdseZuYzvHhsEd7IkTwC9EykxaCzzcfT7AlLfvJCPrA/R5RxL560amt9tQ4ocvV62QLAVhsRR5qmQe4M0FaJ1CCsrmN6v55qnhxBMibJtS1G9zJDWLvNE2bvGpHTBB1R7c0zVlWWHsgsgI3czNJXN7/9kWSqMclxHA8qKBvZjgqz4UhxzcfmQWyqJU2QxtX97yJHE5xBPW4XF73Qsmu2PSpWuvuZPtCGiZNK68sk3FNAvkm1jJ/VuLD7D6FLRh5+haKHyPxSV4VFc6mCl/oV4D1c/C53ws2BzD8D9sqCG0E6JTAWik0jgrcdEnWjRr0dQhnosq/iiqJeXmpIEGwdsFPCMBSGckB3va8Z2tdQX1CrobeHsWg0OVwEcyEYUBk+0cGkGbT1pxaGDwuEuuuIhHHBVjTf6ZGlhndWLsA02ufzVmyC5vbtj9zhIHPcKL3e2DK6HOeveac2bYJme7KdZ1g2dZgJ+ZtX0MIX/+PeZWxnI9MLCrFE8mLingpwp4rWbiUTdTEb+M7X7OO/FdEgD2wgbbWh6SYXykt/cKdIjB+hmuC0xT/YL1V+RpHAb/wbhxW703+P4edv4o2K2HRJ2YB4BKNXu1meB4MU1Zq2xvuqgIev4PSQrNcmzFiy+PTVSQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016)(18002099003)(56012099003)(22082099003)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WEZrWlZCd3djLzI4b1NSbjRqYkhac2U5dUgxTVhRc2s5Z2V6SXE3YzRIRmZh?=
 =?utf-8?B?UU5nS0JGNnQ5Zng1OEJyc0dkY3kvYkhITHYranlzNlNuZ2ZZRFNYZlR4UjY0?=
 =?utf-8?B?L2dQOVA3NkF1TjI3dkswYkxsWmVEM2xSa2hLL1F1bUxQUzJCaERrb3J1OEZV?=
 =?utf-8?B?ZDZlVzlxcVdLRFhwTjYzRXlUS3FBTGh6dDBqM09VVDY0bFM0K1R2SCtmU2tr?=
 =?utf-8?B?cnRxVG4wVVI2SkN1RDlUckh2UnNxTFFHMGtScHpOSlNPOHlpNTlIQ1krNk9r?=
 =?utf-8?B?MmtYOXBSdnpTWUVHMHBzbGd2T0NmdkdGRUxoVWs0VXBVY2V4eGtTNzI3R1JF?=
 =?utf-8?B?K3dNSENLNytTRUd3RUxQNkFiQTFCNGViK1RCeGN1enc4UGVORVVpaEttenln?=
 =?utf-8?B?eUU0cERvdExtUERTOFFETWhSTFU5TEQxWG1RMmd1eG5xeEJ5QXN1K0RZUEtu?=
 =?utf-8?B?eENDa2tLM205U0Fta3owbnFYZ2JaNGw1UUhSZDhId2tUSytwVUo4RzBBZmRG?=
 =?utf-8?B?YWVUYVByOVVFbnBiREFtZkQwcjg1UWc2QU9GVVZiMEtXNERTaXpheURZTUd5?=
 =?utf-8?B?YTFvaTV0aEJINEpySGhoMU1Vc0hrTW5icTI2WGZRSUhWeDlHc3JUeVcyOVNR?=
 =?utf-8?B?Z2huWVMvQm0vZ3pGYkx6THVvRVZlTHB6Q0NLMzlxMkhTY3Nhcy9YcW1zanVD?=
 =?utf-8?B?clJTeWl5UkIzaHVNWDNnWEFvZTdOUThIcGhtWmRKLzVDY01QWElsZEFXVG9J?=
 =?utf-8?B?amFLSUN2eEx5THNDU285amhwbmliOVB3cUdlU0p6Yk5ZeTNrVGtKNXFQZ3Vn?=
 =?utf-8?B?NjEySjZBOWJQWGxjZ1duTEZXNjdYRzNhN0RjRm4vZlVlTVFYb2JSdHp5OXRp?=
 =?utf-8?B?b1NMM1huTlFCMlpnaXVQT0RVb2Zab3B0cTI4VlVrT0lMYS9KVFdrSVZaMEZ6?=
 =?utf-8?B?V1p5aVoxVjlSOXlJYVVoeExNUUpyT21SNm5PRHRXeXc0SUxGSXhvbGN0YjVv?=
 =?utf-8?B?eko1c0ZWRXU3Y0FBOHdSVWpvbEFlMzRrbUlYV0ZUVDdGVDJkOUNSU1psRlZS?=
 =?utf-8?B?MFcycTVjTjlzdUwyUEV0cCtYL2tvSzVVcjVqQzJHSzVhUWUyazRndnc3ZUM5?=
 =?utf-8?B?c3NEM2dGYlovMytPMkpVRUtITG05dlBXamFnSUtrbXBRY2VYZVRKNnJPV2s0?=
 =?utf-8?B?QU1MZWVReS9sM2l3ODROck5GNDkzUFhUakRINEhNamE0NExLSjBJcEVvN1A5?=
 =?utf-8?B?ZzZVMWRYYTVISlZZVkkyQWhUdmoyZUo2VHhnK3ZwZUZmdDRjTC9LcmpXQTht?=
 =?utf-8?B?MnNsUTFPeHZ0QWE2aGhNVU4xSTRFSkJ5YklMRDBrNkRzVThqd3J4ZnBWU1I3?=
 =?utf-8?B?SkhlN1JXZUlzYWVETXdZREJqWktlQk1TVzJuV0RyTjFOeCtva0ZaRzNDUWRk?=
 =?utf-8?B?U0xkYWFmdVRVZmErOVBxb2h2eUh0MTFFYTlYNm1tU0dBMmdJYjBRUGZ6R3Y5?=
 =?utf-8?B?ZE9DTXYzVFJRWjY0OGNGemM0TkUwWDl1UkJpVEpYUytXa0o0dEJtVlpoRG5r?=
 =?utf-8?B?aXBqWFhNQjlGaCsxRDVGcUk1dnlac1VneEJmMEJFKzhJeGhwWWRSemxWeGN3?=
 =?utf-8?B?ZjZ1T3RCRVN6S0MrZHNvSU52ekRXZWVJbnkrcks1Wk5FZ2RNZHpKc291eS9L?=
 =?utf-8?B?RzVxTUp5aE1MQUNJR2VlMWxza3pRc2ZjcThqNkxDVVlhWmxZUzVSeG0yQTVN?=
 =?utf-8?B?azNYd3A3TUlZaXRNVnBmNStVbEVnU3JGY0ZZeHRNZndYL0ZMWGc1WjlCdS9z?=
 =?utf-8?B?YmJVYWo3cER4NGVBYkpud1A3Rlh1RUdZWURJL2EwQW1NUGcxc0RLYVYrSUo4?=
 =?utf-8?B?T1R1UytDVG0wdEhKaTdNSUFoSHZPdG5sa0pNMGNjaHcvUDJtMm5NMTduaDhW?=
 =?utf-8?B?ekU2bnA2Z0pjOW5aZzhHMTNxTnVFMUE0UDhQbWRmVUhvSUxTb3cyNW9FVjU4?=
 =?utf-8?B?Z2IyNjAybWRVMnVMUHBjUWpGU2lXUkRndi9aOXdTbVdOMXREL1ZFRmFrbUNI?=
 =?utf-8?B?S3JnMFRCeGcyMWJMeVcvSmVRMHdMZFNPL1pwWk1sVzBseUQ2SGNoWFRZZFNx?=
 =?utf-8?B?cGtVWldKSStYTFJIaVFSRHNNOURseVhHUXNtKzEvV2M3dlQrb2dzQnpWMkRL?=
 =?utf-8?B?b0wvc0NvWDhFMDN5aktERGZ6dUN5cVg5TnRaTEp6aHAzT1F2dk5pQm05OGw4?=
 =?utf-8?B?VmlCYjRlTEpIVGtCelZXYXVlOSt6aytvZUE2elJ2cnl3T3QxYWtuOVlPVlRB?=
 =?utf-8?B?RE5LaHR3cGFWL3RNQi92UGYvVGROVjU5bHAxTXNiWlppdjJ1Wlpqdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a7a3abb-5a4d-4766-3102-08de8514d858
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2026 17:36:11.0209
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M33A95z88CowiGQxKou1NY6LFwdccNpNouwCboX/mFI7LlND19uJTTiuQwYnbzKs
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PPF5D27497F1
X-Rspamd-Queue-Id: 9F56340012
X-Rspamd-Server: rspam07
X-Stat-Signature: 47mss3se5pk69ocz7ruqbzr4byg4g8u9
X-Rspam-User: 
X-HE-Tag: 1773855375-338312
X-HE-Meta: U2FsdGVkX19cfogrtk88amgU73zZOdla0l1DJ5JhvdebT7yT4LdfZwobUonBU3sJCtNjIRL3nqh74RmqrUz6hB7Kx4R6d/b5DBMOAQR/DIMrcD/0o0sj1tNPEbbtfpI9bbranYElzTNP3zaMq0thdK7FfNMX3Fi+aAPh4nwAOnzPZcndGKY6ar5HT4Bs0YgKQ7PQvO6gbqcvLV9m1g08fidVk/EOByRgnZGXAXKbBc/JANZymqQ1BmeMNcEH5ZFmlK9EGFjsJr6oyHRouPiDXKUflbF3Nc2LPpcCBMP2HmbjFiSyZXH0KRQ8V8OeGTA4aL5ApzQV6a4SeznuvNJraftVodQWomS2Aciy130/OMYFHJz3bF3XJ7PqWzLtQXlbshrVGPySL+NvSxU1JZW+KusZ9ZHlXMAo+6e7G+MFKHBMXwYDFalUBDuSIbst4zBDXXJRWzzahcHGFokR32XvpMoNSkJ8Z0PGQQboeMiOYKwJtQ6zqBySRkh6l5FYru1g1R1aYmGIgflZ7lo7qTeMr/98tcRihI1PqdnEwP4d4NyfM9kPlVpxsn/+Dvb18gNLUrHfzdv5gBJewjjw1jcOnH1LC/CAIL3vrGtZWQ8tYFM5GhO68ch/slRXKxXiyCk5TSaoGaXfKfTwSlxQVJc5NpCQSrwFbRE6seUOUmSiIZI080cNV/wiDFP4+mBtL9nArKfL0tEgzLWtCJ9clyNtro/KY8za3nzVwU++I2XsrdVnXpyCB8tdq1Sf10UUv0fHLx1sWLr/mJ07/lAjQ6WnglBMY2VcNugIgEO3vLxUL/1mcVsXaxJhvqYUJnN29dzzJ3X+4XbT7VOFA8DR34wMob490rInn53LD5+akpaqrS92r/sNacOreyvbpX18DbSHzeFkjdCeJx3fwu3aQyEYyyyJPkVcsBvBW6R18r0/2+FKnNzDJgJeFf/QzG8MIC9e3rZjQqTv5TY3lG7f9ql
 5rWj8Rti
 r1jNlpjWrCO8boL6phhi2Zp6TIZ3EpOskzIcxcwbdVrcpMUO/GkR07Uq9m87H1mHAKaFdaAn22CM3lMyM82K5mVF3z0Bs+psV6jBaaj880g0S6oha3yH3Ai7XvTP2V4iO8/krJkxnYG5zKzCnLa4nrD5kDpRia4oIrnOoI6ozcFlqzP2CHiiXEgSo+FP74fFnjZi8QU6gS7bgydeSyfgOBBxhRLK84lVu4SjFc1Vn5ihpeqba9sWYWw+BwTpNTabsQp7ypEMrTB4S9URV1KDUQ3sEsk3o4+AdNCMcWLWIgmksyibEr2UAcA1ZCOt8O7sURupEhp9OGBHF3jd4fw+uvMcxdeuCXaUvT4kiKs+W0G7/o+IF+Z7aSSZceg3FnrfGYpvBn4EVEGXsZ3JFlsNKdENLBcf5kRaGPMqBY9HUZs3w6So=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18 Mar 2026, at 13:19, Micha=C5=82 C=C5=82api=C5=84ski wrote:

> On Wed, Mar 18, 2026 at 6:08=E2=80=AFPM Zi Yan <ziy@nvidia.com> wrote:
>>
>> On 18 Mar 2026, at 11:45, Micha=C5=82 C=C5=82api=C5=84ski wrote:
>>
>>> On Wed, Mar 18, 2026 at 4:26=E2=80=AFPM Zi Yan <ziy@nvidia.com> wrote:
>>>>
>>>> On 18 Mar 2026, at 11:18, Micha=C5=82 C=C5=82api=C5=84ski wrote:
>>>>
>>>>> On Wed, Mar 18, 2026 at 4:10=E2=80=AFPM Zi Yan <ziy@nvidia.com> wrote=
:
>>>>>>
>>>>>> On 17 Mar 2026, at 10:15, Michal Clapinski wrote:
>>>>>>
>>>>>>> Currently, if DEFERRED is enabled, kho_release_scratch will initial=
ize
>>>>>>> the struct pages and set migratetype of kho scratch. Unless the who=
le
>>>>>>> scratch fit below first_deferred_pfn, some of that will be overwrit=
ten
>>>>>>> either by deferred_init_pages or memmap_init_reserved_pages.
>>>>>>>
>>>>>>> To fix it, I modified kho_release_scratch to only set the migratety=
pe
>>>>>>> on already initialized pages. Then, modified init_pageblock_migrate=
type
>>>>>>> to set the migratetype to CMA if the page is located inside scratch=
.
>>>>>>>
>>>>>>> Signed-off-by: Michal Clapinski <mclapinski@google.com>
>>>>>>> ---
>>>>>>>  include/linux/memblock.h           |  2 --
>>>>>>>  kernel/liveupdate/kexec_handover.c | 10 ++++++----
>>>>>>>  mm/memblock.c                      | 22 ----------------------
>>>>>>>  mm/page_alloc.c                    |  7 +++++++
>>>>>>>  4 files changed, 13 insertions(+), 28 deletions(-)
>>>>>>>
>>>>>>
>>>>>> <snip>
>>>>>>
>>>>>>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>>>>>>> index ee81f5c67c18..5ca078dde61d 100644
>>>>>>> --- a/mm/page_alloc.c
>>>>>>> +++ b/mm/page_alloc.c
>>>>>>> @@ -55,6 +55,7 @@
>>>>>>>  #include <linux/cacheinfo.h>
>>>>>>>  #include <linux/pgalloc_tag.h>
>>>>>>>  #include <linux/mmzone_lock.h>
>>>>>>> +#include <linux/kexec_handover.h>
>>>>>>>  #include <asm/div64.h>
>>>>>>>  #include "internal.h"
>>>>>>>  #include "shuffle.h"
>>>>>>> @@ -549,6 +550,12 @@ void __meminit init_pageblock_migratetype(stru=
ct page *page,
>>>>>>>                    migratetype < MIGRATE_PCPTYPES))
>>>>>>>               migratetype =3D MIGRATE_UNMOVABLE;
>>>>>>>
>>>>>>> +     /*
>>>>>>> +      * Mark KHO scratch as CMA so no unmovable allocations are ma=
de there.
>>>>>>> +      */
>>>>>>> +     if (unlikely(kho_scratch_overlap(page_to_phys(page), PAGE_SIZ=
E)))
>>>>>>> +             migratetype =3D MIGRATE_CMA;
>>>>>>> +
>>>>>>
>>>>>> If this is only for deferred init code, why not put it in deferred_f=
ree_pages()?
>>>>>> Otherwise, all init_pageblock_migratetype() callers need to pay the =
penalty
>>>>>> of traversing kho_scratch array.
>>>>>
>>>>> Because reserve_bootmem_region() doesn't call deferred_free_pages().
>>>>> So I would also have to modify it.
>>>>>
>>>>> And the early initialization won't pay the penalty of traversing the
>>>>> kho_scratch array, since then kho_scratch is NULL.
>>>>
>>>> How about hugetlb_bootmem_init_migratetype(), init_cma_pageblock(),
>>>> init_cma_reserved_pageblock(), __init_page_from_nid(), memmap_init_ran=
ge(),
>>>> __init_zone_device_page()?
>>>>
>>>> 1. are they having any PFN range overlapping with kho?
>>>> 2. is kho_scratch NULL for them?
>>>>
>>>> 1 tells us whether putting code in init_pageblock_migratetype() could =
save
>>>> the hassle of changing all above locations.
>>>> 2 tells us how many callers are affected by traversing kho_scratch.
>>>
>>> I could try answering those questions but
>>>
>>> 1. I'm new to this and I'm not sure how correct the answers will be.
>>>
>>> 2. If you're not using CONFIG_KEXEC_HANDOVER, the performance penalty
>>> will be zero.
>>> If you are using it, currently you have to disable
>>> CONFIG_DEFERRED_STRUCT_PAGE_INIT and the performance hit from this is
>>> far, far greater. This solution saves 0.5s on my setup (100GB of
>>> memory). We can always improve the performance further in the future.
>>>
>>
>> OK, I asked Claude for help and the answer is that not all callers of
>> init_pageblock_migratetype() touch kho scratch memory regions. Basically=
,
>> you only need to perform the kho_scratch_overlap() check in
>> __init_page_from_nid() to achieve the same end result.
>>
>>
>> The below is the analysis from Claude.
>> Based on my understanding,
>> 1. memmap_init_range() is done before kho_memory_init(), so it does not =
need
>> the check.
>>
>> 2. __init_zone_device_page() is not relevant.
>>
>> 3. init_cma_reserved_pageblock() / init_cma_pageblock() are already set
>> to MIGRATE_CMA.
>>
>> 4. hugetlb is not used by kho scratch, so also does not need the check.
>>
>> 5. kho_release_scratch() already takes care of it.
>>
>> The remaining memblock_free_pages() needs a check, but I am not 100%.
>>
>>
>> # kho_scratch_overlap() in init_pageblock_migratetype() =E2=80=94 scope =
analysis
>>
>> ## Context
>>
>> Commit a7700b3c6779 ("kho: fix deferred init of kho scratch") added a
>> kho_scratch_overlap() call inside init_pageblock_migratetype() in
>> mm/page_alloc.c:
>>
>> ```c
>> if (unlikely(kho_scratch_overlap(page_to_phys(page), PAGE_SIZE)))
>>     migratetype =3D MIGRATE_CMA;
>> ```
>>
>> kho_scratch_overlap() does a NULL check followed by a loop over the
>> kho_scratch array. For non-KHO boots (kho_scratch =3D=3D NULL) the cost =
is
>> a single NULL load and branch. For KHO boots the loop runs on every call
>> to init_pageblock_migratetype().
>>
>> ## Question
>>
>> Does this add overhead for callers whose memory range cannot overlap
>> with scratch? Can the check be moved to the caller side?
>>
>> ## Call site analysis
>>
>> init_pageblock_migratetype() has nine call sites. The init call ordering
>> relevant to scratch is:
>>
>> ```
>> setup_arch()
>>   zone_sizes_init() -> free_area_init() -> memmap_init_range()   [1]
>>
>> mm_init_free_all() / start_kernel():
>>   kho_memory_init() -> kho_release_scratch()                     [2]
>>   memblock_free_all()
>>     free_low_memory_core_early()
>>       memmap_init_reserved_pages()
>>         reserve_bootmem_region() -> __init_deferred_page()
>>           -> __init_page_from_nid()                              [3]
>>   deferred init kthreads -> __init_page_from_nid()               [4]
>> ```
>
> I don't understand this. deferred_free_pages() doesn't call
> __init_page_from_nid(). So I would clearly need to modify both
> deferred_free_pages and __init_page_from_nid.

Sure. But other callers I mentioned above do not need to check kho_scratch,
right?


Best Regards,
Yan, Zi

