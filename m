Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70EC7C83F26
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 16:35:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CFF26B0088; Tue, 29 Jul 2025 12:35:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A7AF6B0089; Tue, 29 Jul 2025 12:35:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E63816B008A; Tue, 29 Jul 2025 12:35:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D30336B0088
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 12:35:44 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9139AB67AF
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 16:35:44 +0000 (UTC)
X-FDA: 83717853408.28.9459BFF
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2053.outbound.protection.outlook.com [40.107.244.53])
	by imf10.hostedemail.com (Postfix) with ESMTP id 88310C0013
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 16:35:41 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="I/HwfF8S";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of jgg@nvidia.com designates 40.107.244.53 as permitted sender) smtp.mailfrom=jgg@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753806941; a=rsa-sha256;
	cv=pass;
	b=qGZ8IfQq3QyPK7zj7LeGLhxLub5Cs4pf4ciz6+MeHJvKGXGToL4jxIWQLt+ICckOoj33Gv
	4CYKLbZ51lL8UyZkXYl/sOmsdVIa6u5BE0vzT5WEYl0s03t5ypuUjoGpMqSRFMyuLBMjhm
	QzpTHrrFjfo9pM6lWtUsl8E3O2Zwu/4=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="I/HwfF8S";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of jgg@nvidia.com designates 40.107.244.53 as permitted sender) smtp.mailfrom=jgg@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753806941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cjNoe21MzN9NmoBMh6SetqSfklCq20X//3nrfS5g8SA=;
	b=2piyc6J9GrBTLgk3tPLPH/IE78VC6NVSuzU2u0Fa4Hduq5VDsb7cDqrJzbCByRoJP5XCc4
	5GTJy9nMunfCBrXWfRL5Gzh8pWPdxTez1rlEBCY7ztbHgRPNPmruBGSRusMDG/Uto/KCcw
	ondVTxcNmDPxbRtaj273Spc0x01mIAA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rUtIwb3vTTBNgm0dfbz3CNvkX69mY6cFDWYwB41oxJT3OdGK1DSJnFluUsTnGitB1JU7nOUhm+uh3rt8cjda0C+CH+VIcDXfZq8V6VnWRam6rxYWCXJELhK4RitexNJ0PDdmaPurA4xE2r1ndYWBmK6wzBwBbxoEu4oqQlzyHtDoQLu63Kh02DwYBtVp8KkAvQJqmKIF70wbF7Q7QOUEgWoRKqh25/OieI4xyqlCHyGnknDTrcfUPY5YPJdS8oth0o9eJWHd4oKr0z4o91egMyZpAKf1rE7JsQrjCejKxdjneSOfoeWJ68UbxcWaVll8lyJ/eJolAi/p+DQRBzJc4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cjNoe21MzN9NmoBMh6SetqSfklCq20X//3nrfS5g8SA=;
 b=RIseYJME2ZWAi8oSglH1UGcW1sjoxuq6ogdR//COX0b9SJEP4uOgVmiJqif2o6rUBanuz3gvEpFaCYWR8pfw1G6vw/ZM99Tdg7GB5wJ0VHqVcx/PqdQPoMxjT5uZ3zF9lAE8YHU1v/XBb3ugXLqNhbCDKnKkjZ4r69/uUL0w8St1MtuMRby7EWwvcJfSwTa6dWXWomxj6HDCW61M+rurK3/Xb1n+V3ZuTPP4+Tfgk3dWt6WryLTM43j4hYpS4VPCvRvt15jS01Fl2nY/80hea+EYuSFN0CYwBwvZLLmLwfEwhoN4BpocSiW9qHayq+uJu1yZOb/CNDgOtMdd6GfXCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cjNoe21MzN9NmoBMh6SetqSfklCq20X//3nrfS5g8SA=;
 b=I/HwfF8SQJHkf/OlrRU3yYDbaaSENOzjedwT+S48FuSyZs9A4X/CR8yIOlXN+Dba0y9iPwwOzNyQjypCYmrYDH88T4xGd/B6oyQvHQ36FE8/y1+InLhE6TiUtnh1kes0PyaeGLOc58DdfUxbKe3cteMFLVyDBG4chtvpj+Ns0/RzGRpXQswhwUjB5I6fDAC7fAzILp6sRT47SKO2QwAZ93uUBH1CDYlzydK1pALP5TILCZEQAGAgvvVCYPOYKtSSVx7gz8RYXk57d4tfTc2APbwTsW5fwfJC/DAMB4g6LS6RoVFx6QK+M/WmWYWzkclhbWNTW9GBUnzoBIryqqZvfg==
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by PH0PR12MB5648.namprd12.prod.outlook.com (2603:10b6:510:14b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.11; Tue, 29 Jul
 2025 16:35:38 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8964.024; Tue, 29 Jul 2025
 16:35:38 +0000
Date: Tue, 29 Jul 2025 13:35:36 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com,
	changyuanl@google.com, rppt@kernel.org, dmatlack@google.com,
	rientjes@google.com, corbet@lwn.net, rdunlap@infradead.org,
	ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com,
	ojeda@kernel.org, aliceryhl@google.com, masahiroy@kernel.org,
	akpm@linux-foundation.org, tj@kernel.org, yoann.congal@smile.fr,
	mmaurer@google.com, roman.gushchin@linux.dev, chenridong@huawei.com,
	axboe@kernel.dk, mark.rutland@arm.com, jannh@google.com,
	vincent.guittot@linaro.org, hannes@cmpxchg.org,
	dan.j.williams@intel.com, david@redhat.com,
	joel.granados@kernel.org, rostedt@goodmis.org,
	anna.schumaker@oracle.com, song@kernel.org, zhangguopeng@kylinos.cn,
	linux@weissschuh.net, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-mm@kvack.org,
	gregkh@linuxfoundation.org, tglx@linutronix.de, mingo@redhat.com,
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
	hpa@zytor.com, rafael@kernel.org, dakr@kernel.org,
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com,
	myungjoo.ham@samsung.com, yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com, ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de,
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com,
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net,
	brauner@kernel.org, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, saeedm@nvidia.com,
	ajayachandra@nvidia.com, parav@nvidia.com, leonro@nvidia.com,
	witu@nvidia.com
Subject: Re: [PATCH v2 16/32] liveupdate: luo_ioctl: add ioctl interface
Message-ID: <20250729163536.GN36037@nvidia.com>
References: <20250723144649.1696299-1-pasha.tatashin@soleen.com>
 <20250723144649.1696299-17-pasha.tatashin@soleen.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250723144649.1696299-17-pasha.tatashin@soleen.com>
X-ClientProxiedBy: YT1PR01CA0141.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2f::20) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|PH0PR12MB5648:EE_
X-MS-Office365-Filtering-Correlation-Id: 228787e1-d9d7-4bd1-f5b0-08ddcebdf2f2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?DdufbRL0rQoRlO/qbIeKKHKetVPYksqw0FM8YjnRHqeAGXNaKOV5SfOBnLQg?=
 =?us-ascii?Q?65xJCetAZKpJOuCq0hJfvVJE37ZdI4BPRHGHQuvOK+bIhouzoixDj4A9PVsS?=
 =?us-ascii?Q?DKvrX11mwpgvu5p136k2ptK3Lru0jKMUlZ6w2gprQlwg8xwCGxKBTGAalA3c?=
 =?us-ascii?Q?Qt2rU184ZObOlEdZDK4pabk4oK+w4pRYK5mYMEA9KQhw2erYFpTQISLqqwbZ?=
 =?us-ascii?Q?4U2xxbEb99YXw7zSaRaHYbG8BTXX5t3QLMw1V3HE1zhB+X2lz0qRcIUhgzhF?=
 =?us-ascii?Q?HRnkht0CzTQ/hIrEBNfWd/zJ0IKmXZjc55XTtmGu0UVxh4ddIsF0jqY7lTfM?=
 =?us-ascii?Q?zRxJXpTI1bhZqy86MKOhy8GKrtIGOgywvC0o66oXzebkyIecNuszXVmQubRS?=
 =?us-ascii?Q?mR1bi3eXzoyiO2o3H5zK+F4RA3Adk/G2neeasttKxd9qXQph3VI5EKLFyYZa?=
 =?us-ascii?Q?zgyn4mrCsWJLmhEg0+/wDUMp9G3dmknl2CpAbWwZMKVm22T1aJWmotDfIvrg?=
 =?us-ascii?Q?gg0wCzUPlyKa6wBInJQIAdvCi9JuZ+OUV/BHI2UWd/sV2RcXLneGYs27MAKA?=
 =?us-ascii?Q?dIBTCqiYqSgt0Q7fHsdwvF2ACVC9M4kP6yAAU69aE28EadTqHJRpEBxxLKwR?=
 =?us-ascii?Q?xha7upVw469l7gP1dMA/xNH7YDtgRYDdY82b9XbeAQ2PMKMeA05cDK436C7h?=
 =?us-ascii?Q?/cEJegBqR07jNlHzNGtXWMTxm5C5AwiKTqva9G6UZOofhJejzjOrj96twb8l?=
 =?us-ascii?Q?u4GUbCKZ8up3zIuaeu8emxPTXyxUgVoeW7Kb6pmZ56Wdegyge/bCdLplkjX4?=
 =?us-ascii?Q?Wnh1UPKYNnx9Sa08ynbP6DCQW/uEDIQb4N5j5bFVhQTTPMM7BdGbBB/vJAp+?=
 =?us-ascii?Q?YPfEhx9WJGseq88NQ/3Kz0Mqlqwir4nBb2h7lb/h3O7Nb4sHDnmnfACqYLxY?=
 =?us-ascii?Q?Mfi5xYmygdaPy4CIMhbdAbhf4YR3vzIxr2Y1yzS25Cul/RYNZOCrE21gr2JE?=
 =?us-ascii?Q?JCtmGga6qcjz1rXTGaNjmRsy9aXX+MX2gvABYj2CdPyiOdH/azJZHwfMWdV9?=
 =?us-ascii?Q?ubR3p5f6nyesSxLMQAs9s8sIAK6RXtflBM0rv6k1Jc/NA5p2NqXKrChaLX17?=
 =?us-ascii?Q?f+/Bl74EYwF5z6uA5GXv0ZZ1puAiv5hf4xcO9eXk78DXZsoidWD/wccfQcu0?=
 =?us-ascii?Q?k+Tagun6r0J4g5Vw/f1+GpkrXobeoiFNK0hObDQsICL/lb6lMdL3LIYHKSfd?=
 =?us-ascii?Q?PihDYiSu0XBA5Miond1gy3CxMboYoVTVGl+QAONF/6CzbPWO2rtdtZXUJQWW?=
 =?us-ascii?Q?4701ufsc38U5/Hv9gkO7TRThT6VRlo8ISU3z5DW/2xZm/bs69lBbxA152t0k?=
 =?us-ascii?Q?u1OK9jl6sF7QEPfmTH49Mtx1AKrmlF87Pi/vBLzgUOZkIlNGDbkW0N4R4zEY?=
 =?us-ascii?Q?rrP6D5WzgLE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?tzSLAbqWaW9YaPyH3WlahxOw+2ZzK1986Bq2355XcWSbKSHOHwkHUHdN9n7K?=
 =?us-ascii?Q?8hj1fE/KIJy0M3YjsOygWViuSx2Y7CAD9euGi+0g5Cdspgoqm9v82CqP7BJZ?=
 =?us-ascii?Q?R+cXLjNegI+kUbU8uVKIJT/O/uwC9lh0OW5k7/Y4fzPJoAbIXtWe2xLsasNO?=
 =?us-ascii?Q?nCox08Qz0kStsasfc+8m91Zptwqs3QRDs894rJdx04z4QwQws46RYkP7klMG?=
 =?us-ascii?Q?8XffopWLD5THsfggFEgrvAM2HJLRqkKPOpl7KO/WXiaBURpdbxU4XPsodrtW?=
 =?us-ascii?Q?/bZV02mjvBKb+PV1LJBTFQgvFg2KumGU+pbYMGrcoGx466COAq7fvp7IzopV?=
 =?us-ascii?Q?E4By2ETw+6bk8SlEkhcxsDK75x7+KkiWrlBiY6evqhFnhIMHZu0YaB3wAhil?=
 =?us-ascii?Q?iMOGjAK4SQrlgFTOAVc6/Xy3+Kwpa35VPdF1srO05P55vLKvgFu/mN80RgUy?=
 =?us-ascii?Q?xUUl/j/ep7VcHFehSOGmMFIo34GoAu85Kqt3P92a5SwdG+yraQg79nRTkhb9?=
 =?us-ascii?Q?aSqHcSg6BlOVcxPWcQNSICjiw8XxZqawIe4UgA5GEe5JSbMZWK5UtSs482ZI?=
 =?us-ascii?Q?L4+wDahpyYQjqNqVFa900PUowxZNzEz/2KNIGYWMCLeHD+XNlyWGrWd23ICA?=
 =?us-ascii?Q?J1VQ5v150edZP1dHdSP8EiwmbMkiifc6ZzfJIJSFRnICZx9X136W9UGLlb2q?=
 =?us-ascii?Q?WXOhoJIYFKq+g+lZYuzajENN23jD08z86zObfX02eJ8dNpRoPIfXzUjEOFXE?=
 =?us-ascii?Q?Hd6D+gFDWrSabOdJrWf9gPl0lzhCJ70QgblKlczYXvuqQtGDCSJ5odwHnIye?=
 =?us-ascii?Q?nFo005wEvQPxiYo3LjjrBxZAJZP8BfGhP/2IkMwe4UNW7LWNByibwKPnW3X1?=
 =?us-ascii?Q?VXTJfN6swpIsPSE2OaJfvEvJ5TUSKR7lRs7aEEwGJVcAaUGMZ6hyS3Ud8qCi?=
 =?us-ascii?Q?mNky+NHoC2eF2A3cnpEwecdoCo+RQHXb3P+RcnsZqrJJV2ws17bIrV5ylVck?=
 =?us-ascii?Q?had7cCJksGPghiSs156Bdgq/CrncY5fqhCrFt2PKsWiNRcCfJv73FLbIugUd?=
 =?us-ascii?Q?3/BudTONKh/UTsgu1TsBBLn3DpXAqsFFRqjXYfjaDK82QExp+zkvKxrhzvNT?=
 =?us-ascii?Q?V+XaHPA1hKzyf7LMo4b0A/uZyATT4du8Zgyfbq01/oS4A1Oq5Th86hHdTWXS?=
 =?us-ascii?Q?0iKMa9kCtf4WeqSc0SdtRO64SVaqmt+osTUihQ0zIoc7o/D3lsKYQg/zFtXp?=
 =?us-ascii?Q?Dotc3EWMrm75LCjQ6ax5cWb7TmSccCh6uKONlCNemCuo1iW/IOsme+mI+qEf?=
 =?us-ascii?Q?Pi+CTPDW4BSoQ6iCBH1CqkHhi2X+nEjwS8CSYqha4Em6qRh0Zkf4qIQJxG28?=
 =?us-ascii?Q?EUE+eDUDtC/OalB0ZEMFY+I7yDg88O3E9eVJ8EWjU2X9uyKLxbATQQ+pzX4x?=
 =?us-ascii?Q?FH/68tDwnIQDSQh+d5G9fkz/mCqgNNmuH2A1mBmT1T2XdfCce3a8LLWwfaER?=
 =?us-ascii?Q?fWFHyG2Mdd+SMrYyUAmFPN6O2+JmyJIyTln1idyYzaVVt8kX5hjHFS/mO57z?=
 =?us-ascii?Q?gApHW0rtbhQRd/PdCpw=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 228787e1-d9d7-4bd1-f5b0-08ddcebdf2f2
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2025 16:35:37.9704
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4MjeirolLa7GZAiFLup9FsiUncFsQN+J7No/qQF5dDRPYZ2OpWa0epZo6AgHDgqv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5648
X-Rspamd-Queue-Id: 88310C0013
X-Stat-Signature: dh7t7rc6gnjokj3d74d853e1txhc3bqw
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753806941-581295
X-HE-Meta: U2FsdGVkX19W15slfPO8wyFC5XZul+Ch3xiLMYYVTGXNvNe6YgFM8Qx5nSFODlQRjgCFxj563ZFL2f8oNZKI6whMDNvRkOcBQPGIQa6kDdm9wl4bP8DPThgvlfpQ+be3QWbD80TJikl2DEeBVBEChFjVOztU4Yxrcpvk78Oq3HXb4GWtiJm5YiXtBgE7e8Pq13aRiu0A3ZA5BZK0tErTYFSnhmDFFBF/rE+P2YueJst2NMFtrDECDlSxHox0r8kBxpoER0gC6zq0YwaCVEnddCajQwO0x78rw2w1mZhNSpxNwUZTDsbsX3vQZ4QpREjSAVGqCUTSoVKnalv2FeGm5uut59ZjjX8UeA97FOhgbvHXI1H6DJGrPYDsjGaoBbkNpjsmZv6baxN2teflPLfnAGKDN13qSATgrA4g1/XFCFKg49PnHgHDseIWEEuMSxyXbi172nf8AQwkPmVZJcoolJc7AX+fSS8SnETzdaD2GBbOKy35EbTfN8j9K20rnPuFbcNF/+LLAauqQ4WowitRN1O8HjSAXx7ReCd+c95CW3dIFdt0G3klq3P6X1VAohBmjaYl/S3wHt9+MXuJvw9x9dcCxs3ryBHpq5e6QjCUfFAH30KmSn9qVjcvJlkYJYGOIjc04VAevQijwQO5MokX+SeOw+RI0e3w8H8CDFB1HromNl1Pyn49GJC5Y0mG0mrekvTRcAJEis+E/T1gRN/kerGeb6W/P+cMVzo9JaTaDZBOyqNmnuUuJ7kniMVQAEtTImHXs81HRHEc/H1LRJY8WG89txH6GCkxDtA9aYlN8tHdCvKS/zO29UUgENYsyqdxtNtJQjkbNVN9/+xaU6mVI8wrd1X3nF5X9hOoOyD5Tv52cDNMXXdlaE6msJkfd7XuOej7NBM07R//UXcQE01ahmSfYzRCqUi/4RfYrHNtGE821Z+CkebP2VO0uZf7W3/68Tm4s+26vcFResuRWRf
 u37S/HdT
 OsamywbvTybT9I23UIHr3iO1oz2+hqj2MEPWWNiw56C4pUTn5FYM0sFkmhROcKqEimW8+TyqsRhiUMbkWeIF+Xmbr5PASV4jPkGZhhoknyaR/aLJEH8zrF8+/jHn4Eyr/2GwTcBPD607t0LljPaAwTsNairlOl7XW8xUCHEjc5WrIyKv3Lv+dTHBhgkdf6aoo1prl5rF8OYprQ2s16Dpwex2kNP6IhlCqdnXUkk3URQnsIbMFKgD88toyVAulMmWPouloviPv8Z+Sw/h9KnsYiAP1IMWhaEK22wiVS9X7DDq8BePFPaowavDzTuGFBnOmO0YL8fsnwjvP+P0Nksy2LjJdgCBVlZPxoJh98Bx+agkZJww/DEyfsKRyEPnadAr8M0kOPTQx/1Bz/lq0Cl9JtpSre0JbhQAsLtmOZBL+vc0o8PiHeBkVyQ3JiJhqsjWd/G/R8dvjirYwwbpH4+Ocy7AonKR40R1Q2VDOhnl/jwb7v6nuAKa63TZ2cI/EJWx9sRSG6MXOZwD+Nb1TPB7Bl5JF1XToRsjk66Oh6m+pFif9/vA8qvpijkJFLmq/CrC2fVCQidiXA294A22QiuMEsxPgsMGWRsHnTt+wKZJ/4XhDo1hsFTg2I1ml2wR6emMmTL2jCKjYrWnNqAAKPlOIZfSEsCRAh+wu+x5M
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 23, 2025 at 02:46:29PM +0000, Pasha Tatashin wrote:
> Introduce the user-space interface for the Live Update Orchestrator
> via ioctl commands, enabling external control over the live update
> process and management of preserved resources.

I strongly recommend copying something like fwctl (which is copying
iommufd, which is copying some other best practices). I will try to
outline the main points below.

The design of the fwctl scheme allows alot of options for ABI
compatible future extensions and I very strongly recommend that
complex ioctl style APIs be built with that in mind. I have so many
scars from trying to undo fixed ABI design :)

> +/**
> + * struct liveupdate_fd - Holds parameters for preserving and restoring file
> + * descriptors across live update.
> + * @fd:    Input for %LIVEUPDATE_IOCTL_FD_PRESERVE: The user-space file
> + *         descriptor to be preserved.
> + *         Output for %LIVEUPDATE_IOCTL_FD_RESTORE: The new file descriptor
> + *         representing the fully restored kernel resource.
> + * @flags: Unused, reserved for future expansion, must be set to 0.
> + * @token: Input for %LIVEUPDATE_IOCTL_FD_PRESERVE: An opaque, unique token
> + *         preserved for preserved resource.
> + *         Input for %LIVEUPDATE_IOCTL_FD_RESTORE: The token previously
> + *         provided to the preserve ioctl for the resource to be restored.
> + *
> + * This structure is used as the argument for the %LIVEUPDATE_IOCTL_FD_PRESERVE
> + * and %LIVEUPDATE_IOCTL_FD_RESTORE ioctls. These ioctls allow specific types
> + * of file descriptors (for example memfd, kvm, iommufd, and VFIO) to have their
> + * underlying kernel state preserved across a live update cycle.
> + *
> + * To preserve an FD, user space passes this struct to
> + * %LIVEUPDATE_IOCTL_FD_PRESERVE with the @fd field set. On success, the
> + * kernel uses the @token field to uniquly associate the preserved FD.
> + *
> + * After the live update transition, user space passes the struct populated with
> + * the *same* @token to %LIVEUPDATE_IOCTL_FD_RESTORE. The kernel uses the @token
> + * to find the preserved state and, on success, populates the @fd field with a
> + * new file descriptor referring to the restored resource.
> + */
> +struct liveupdate_fd {
> +	int		fd;

'int' should not appear in uapi structs. Fds are __s32

> +	__u32		flags;
> +	__aligned_u64	token;
> +};
> +
> +/* The ioctl type, documented in ioctl-number.rst */
> +#define LIVEUPDATE_IOCTL_TYPE		0xBA

I have found it very helpful to organize the ioctl numbering like this:

#define IOMMUFD_TYPE (';')

enum {
	IOMMUFD_CMD_BASE = 0x80,
	IOMMUFD_CMD_DESTROY = IOMMUFD_CMD_BASE,
	IOMMUFD_CMD_IOAS_ALLOC = 0x81,
	IOMMUFD_CMD_IOAS_ALLOW_IOVAS = 0x82,
[..]

#define IOMMU_DESTROY _IO(IOMMUFD_TYPE, IOMMUFD_CMD_DESTROY)

The numbers should be tightly packed and non-overlapping. It becomes
difficult to manage this if the numbers are sprinkled all over the
file. The above structuring will enforce git am conflicts if things
get muddled up. Saved me a few times already in iommufd.

> +/**
> + * LIVEUPDATE_IOCTL_FD_PRESERVE - Validate and initiate preservation for a file
> + * descriptor.
> + *
> + * Argument: Pointer to &struct liveupdate_fd.
> + *
> + * User sets the @fd field identifying the file descriptor to preserve
> + * (e.g., memfd, kvm, iommufd, VFIO). The kernel validates if this FD type
> + * and its dependencies are supported for preservation. If validation passes,
> + * the kernel marks the FD internally and *initiates the process* of preparing
> + * its state for saving. The actual snapshotting of the state typically occurs
> + * during the subsequent %LIVEUPDATE_IOCTL_PREPARE execution phase, though
> + * some finalization might occur during freeze.
> + * On successful validation and initiation, the kernel uses the @token
> + * field with an opaque identifier representing the resource being preserved.
> + * This token confirms the FD is targeted for preservation and is required for
> + * the subsequent %LIVEUPDATE_IOCTL_FD_RESTORE call after the live update.
> + *
> + * Return: 0 on success (validation passed, preservation initiated), negative
> + * error code on failure (e.g., unsupported FD type, dependency issue,
> + * validation failed).
> + */
> +#define LIVEUPDATE_IOCTL_FD_PRESERVE					\
> +	_IOW(LIVEUPDATE_IOCTL_TYPE, 0x00, struct liveupdate_fd)

From a kdoc perspective I find it works much better to attach the kdoc
to the struct, not the ioctl:

/**
 * struct iommu_destroy - ioctl(IOMMU_DESTROY)
 * @size: sizeof(struct iommu_destroy)
 * @id: iommufd object ID to destroy. Can be any destroyable object type.
 *
 * Destroy any object held within iommufd.
 */
struct iommu_destroy {
	__u32 size;
	__u32 id;
};
#define IOMMU_DESTROY _IO(IOMMUFD_TYPE, IOMMUFD_CMD_DESTROY)

Generates this kdoc:

https://docs.kernel.org/userspace-api/iommufd.html#c.iommu_destroy

You should also make sure to link the uapi header into the kdoc build
under the "userspace API" chaper.

The structs should also be self-describing. I am fairly strongly
against using the size mechanism in the _IOW macro, it is instantly
ABI incompatible and basically impossible to deal with from userspace.

Hence why the IOMMFD version is _IO().

This means stick a size member in the first 4 bytes of every
struct. More on this later..

> +/**
> + * LIVEUPDATE_IOCTL_FD_UNPRESERVE - Remove a file descriptor from the
> + * preservation list.
> + *
> + * Argument: Pointer to __u64 token.

Every ioctl should have a struct, with the size header. If you want to
do more down the road you can not using this structure.

> +#define LIVEUPDATE_IOCTL_FD_RESTORE					\
> +	_IOWR(LIVEUPDATE_IOCTL_TYPE, 0x02, struct liveupdate_fd)

Strongly recommend that every ioctl have a unique struct. Sharing
structs makes future extend-ability harder.

> +/**
> + * LIVEUPDATE_IOCTL_PREPARE - Initiate preparation phase and trigger state
> + * saving.

Perhaps these just want to be a single 'set state' ioctl with an enum
input argument?

> @@ -7,4 +7,5 @@ obj-$(CONFIG_KEXEC_HANDOVER)		+= kexec_handover.o
>  obj-$(CONFIG_KEXEC_HANDOVER_DEBUG)	+= kexec_handover_debug.o
>  obj-$(CONFIG_LIVEUPDATE)		+= luo_core.o
>  obj-$(CONFIG_LIVEUPDATE)		+= luo_files.o
> +obj-$(CONFIG_LIVEUPDATE)		+= luo_ioctl.o
>  obj-$(CONFIG_LIVEUPDATE)		+= luo_subsystems.o

I don't think luo is modular, but I think it is generally better to
write the kbuilds as though it was anyhow if it has a lot of files:

iommufd-y := \
	device.o \
	eventq.o \
	hw_pagetable.o \
	io_pagetable.o \
	ioas.o \
	main.o \
	pages.o \
	vfio_compat.o \
	viommu.o
obj-$(CONFIG_IOMMUFD) += iommufd.o

Basically don't repeat obj-$(CONFIG_LIVEUPDATE), every one of those
lines creates a new module (if it was modular)

> +static int luo_open(struct inode *inodep, struct file *filep)
> +{
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EACCES;

IMHO file system permissions should control permission to open. No
capable check.

> +	if (filep->f_flags & O_EXCL)
> +		return -EINVAL;

O_EXCL doesn't really do anything for cdev, I'd drop this.

The open should have an atomic to check for single open though.

> +static long luo_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
> +{
> +	void __user *argp = (void __user *)arg;
> +	struct liveupdate_fd luo_fd;
> +	enum liveupdate_state state;
> +	int ret = 0;
> +	u64 token;
> +
> +	if (_IOC_TYPE(cmd) != LIVEUPDATE_IOCTL_TYPE)
> +		return -ENOTTY;

The generic parse/disptach from fwctl is a really good idea here, you
can cut and paste it, change the names. It makes it really easy to manage future extensibility:

List the ops and their structs:

static const struct fwctl_ioctl_op fwctl_ioctl_ops[] = {
	IOCTL_OP(FWCTL_INFO, fwctl_cmd_info, struct fwctl_info, out_device_data),
	IOCTL_OP(FWCTL_RPC, fwctl_cmd_rpc, struct fwctl_rpc, out),
};

Index the list and copy_from_user the struct desribing the opt:

static long fwctl_fops_ioctl(struct file *filp, unsigned int cmd,
			       unsigned long arg)
{
	struct fwctl_uctx *uctx = filp->private_data;
	const struct fwctl_ioctl_op *op;
	struct fwctl_ucmd ucmd = {};
	union fwctl_ucmd_buffer buf;
	unsigned int nr;
	int ret;

	nr = _IOC_NR(cmd);
	if ((nr - FWCTL_CMD_BASE) >= ARRAY_SIZE(fwctl_ioctl_ops))
		return -ENOIOCTLCMD;

	op = &fwctl_ioctl_ops[nr - FWCTL_CMD_BASE];
	if (op->ioctl_num != cmd)
		return -ENOIOCTLCMD;

	ucmd.uctx = uctx;
	ucmd.cmd = &buf;
	ucmd.ubuffer = (void __user *)arg;
        // This is reading/checking the standard 4 byte size header:
	ret = get_user(ucmd.user_size, (u32 __user *)ucmd.ubuffer);
	if (ret)
		return ret;

	if (ucmd.user_size < op->min_size)
		return -EINVAL;

	ret = copy_struct_from_user(ucmd.cmd, op->size, ucmd.ubuffer,
				    ucmd.user_size);


Removes a bunch of boiler plate and easy to make wrong copy_from_users
in the ioctls. Centralizes size validation, zero padding checking/etc.

> +		ret = luo_register_file(luo_fd.token, luo_fd.fd);
> +		if (!ret && copy_to_user(argp, &luo_fd, sizeof(luo_fd))) {
> +			WARN_ON_ONCE(luo_unregister_file(luo_fd.token));
> +			ret = -EFAULT;

Then for extensibility you'd copy back the struct:

static int ucmd_respond(struct fwctl_ucmd *ucmd, size_t cmd_len)
{
	if (copy_to_user(ucmd->ubuffer, ucmd->cmd,
			 min_t(size_t, ucmd->user_size, cmd_len)))
		return -EFAULT;
	return 0;
}

Which truncates it/etc according to some ABI extensibility rules.

> +static int __init liveupdate_init(void)
> +{
> +	int err;
> +
> +	if (!liveupdate_enabled())
> +		return 0;
> +
> +	err = misc_register(&liveupdate_miscdev);
> +	if (err < 0) {
> +		pr_err("Failed to register misc device '%s': %d\n",
> +		       liveupdate_miscdev.name, err);

Should remove most of the pr_err's, here too IMHO..

Jason

