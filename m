Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 005AFF45A18
	for <linux-mm@archiver.kernel.org>; Sat, 11 Apr 2026 03:06:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA9F26B0089; Fri, 10 Apr 2026 23:06:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5B0E6B008A; Fri, 10 Apr 2026 23:06:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C22486B0092; Fri, 10 Apr 2026 23:06:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AF39A6B0089
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 23:06:35 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EDB4313BA2B
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 03:06:34 +0000 (UTC)
X-FDA: 84644787108.19.D48A625
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013033.outbound.protection.outlook.com [40.107.201.33])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1A5AB100005
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 03:06:31 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=JfthdI+x;
	spf=pass (imf05.hostedemail.com: domain of ynorov@nvidia.com designates 40.107.201.33 as permitted sender) smtp.mailfrom=ynorov@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=JfthdI+x;
	spf=pass (imf05.hostedemail.com: domain of ynorov@nvidia.com designates 40.107.201.33 as permitted sender) smtp.mailfrom=ynorov@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775876792; a=rsa-sha256;
	cv=pass;
	b=PIJDUiBkAmAkOj7UmdHwXJNcZDWpfGz0N8CUd8ihM5NcKk8BRRCjcha42CIlaEPcBBrDdR
	L4kaa0kwHB3UQuVQBN1/BY1vjKox5cDw9LUFXN8L6GhGBUIsWgiCja8KpI5/3od8EQWsvj
	MJRRs2qI2Kgx1jASOxvBKdtM8/GQ/6Q=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775876792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k78EPPb2CagNEgVe5EaK4TxmVqHb98V2wPlEU/CrjYQ=;
	b=GJmH9H8hUib59ewJGIEno3WEl+f43K6HwDT6WwLvbd+aj6tIv0ph6c+sBrAlGtXIqGat8m
	zRdyvD/TveAc7sZYwMqlsNo2i+jVJQ9xUxENnDSTtm+bYGiJoWdBxfqBO0JnceSp1wRCdI
	cn1SDCpnFUsMpT15MbzKlWygJeUy3hQ=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cPAQT3mQAWOT1ehzCbTGp8/wpgEqCa5ccWoOkMU8NAIObmCD9ap553ygYtAHWzSKZ5LOToOkieNQNW0It1xOHgfJphmtsLVZXtBafW/u3RvkwMD02pfDQ+F/c2bAjbNtjSHo1vZtYOs+Na93YScMRm5f552GWfqIXl3daPHF3ndeaj/vUq7cFEdC+62TqrAsv+a95GWdMjC2nuir1S8Xmnuy6H4FU5BhlcC/LlAfl1/FH3iKtzDDlkJ+goHZilunSMYQ8Q6f4AUKuf097Hm68gKKt6j4k4U2L/t9Kp1+7xVLdynzyAMuHqXpaRcW0vVODdDr0uuy5WvzzH7g14seaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k78EPPb2CagNEgVe5EaK4TxmVqHb98V2wPlEU/CrjYQ=;
 b=TjgipQZvh0/IR7rjAkY9o/PhbTUtaGtvJZJjLBufcC9lmua6nNQaM8GVHh0eVCd/CSpjdwp6z1W4hLGQcveubZe95AiXQ7T3ooabgGlKJRVEiaXVSSVsa/RdYcfCj/FF3KXFyWzVtoe4uacfvkPYmYfYFlxK9ejBDmcZeyqiWrs4aX4nBP8N49+xWRdPNI2fK7/ivguS2H9kzfNvbvhWEXqS7HR2EQaOBduiNS3EMWYciYkcUAe0PtdIAKQGPdD1mOFfYSCi7DjLp/UbB6TNj4ufbuZYiR+WgZWVxTTn1GM8YG/QyHDCRKGnV+hXTGD2n5YhdKulchIY80YWlftebw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k78EPPb2CagNEgVe5EaK4TxmVqHb98V2wPlEU/CrjYQ=;
 b=JfthdI+xwu4X73RGdXSHXHYzaItFNfd+cEAa3eXwynATGdbgmsd3oXmZxYRPc5sMvSxW3SYruSW1D0VD5yTzuBMLLR1Z1xswkogTw/rAHtdEMuK8L83TFJEYGUffBa8k8u/yoL9BervXboHBwnyGkqL/l46yYTRyOLsMZ87cBoZbarwHlkESSFKSk86KuKZVBj15093Bdie9Wa2ka6BbKIJnvrKH9gx9u02090SZW7WehbuBXp1M9RnPcCJSFFKAc2mpWmhPeyoAA6AG1yia2ZQxboyVDVBLcqwGPuZA+Kz3Gxk6shj3xZwobAgP6p7NRIcxjDFJM/vxxbBKnvchlA==
Received: from CY8PR12MB8300.namprd12.prod.outlook.com (2603:10b6:930:7d::16)
 by PH7PR12MB7259.namprd12.prod.outlook.com (2603:10b6:510:207::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.44; Sat, 11 Apr
 2026 03:06:25 +0000
Received: from CY8PR12MB8300.namprd12.prod.outlook.com
 ([fe80::ce75:8187:3ac3:c5de]) by CY8PR12MB8300.namprd12.prod.outlook.com
 ([fe80::ce75:8187:3ac3:c5de%3]) with mapi id 15.20.9769.018; Sat, 11 Apr 2026
 03:06:25 +0000
Date: Fri, 10 Apr 2026 23:06:22 -0400
From: Yury Norov <ynorov@nvidia.com>
To: Mitchell Levy <levymitchell0@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@linux.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Benno Lossin <lossin@kernel.org>, Yury Norov <yury.norov@gmail.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Boqun Feng <boqun@kernel.org>, Tyler Hicks <code@tyhicks.com>,
	Allen Pais <apais@linux.microsoft.com>,
	linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v5 7/8] rust: percpu: Add pin-hole optimizations for
 numerics
Message-ID: <adm6rmerdgVtclo5@yury>
References: <20260410-rust-percpu-v5-0-4292380d7a41@gmail.com>
 <20260410-rust-percpu-v5-7-4292380d7a41@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260410-rust-percpu-v5-7-4292380d7a41@gmail.com>
X-ClientProxiedBy: BN1PR13CA0028.namprd13.prod.outlook.com
 (2603:10b6:408:e2::33) To CY8PR12MB8300.namprd12.prod.outlook.com
 (2603:10b6:930:7d::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR12MB8300:EE_|PH7PR12MB7259:EE_
X-MS-Office365-Filtering-Correlation-Id: c19f99bb-48bf-4dc2-803f-08de977750cc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|10070799003|1800799024|366016|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	RTOlnN4NLH9FC/PFc/bGzQ388auIkjnqGTf5N6DdTBBkYXY3e609DYDXfMnOE3LraRFIC3oKmCve4qiLsaZJugQBpRwjpBw01YEdxAmjkCobTFxTxsHvzO4W4L50rNN2KxJTTrHzUKsBPehvO43ElhccDJjz5NBcX5kT7TG3GYhuVxv+fyXhAROAkaF3ws9K8flm5boXEJ9Q9KKP0u5LpAe9G08HlZ2eioN+mYb1+RV6zH2KkgghjOG72N+Ab3kK56KkfP4nt2aHXsHfjJjEbPI+L/3nqSjyuNQdoS/7ZqcHLnZ9fhQkn1BuMTqbV5Vd1wdfJtVO+n2zdkd0OZJgL9dhIlAWpFFKqjEfaODmv1OzA9i+FwzMtOnZSrAKzHI2T/trMSsSEwHm7ShgH+9UM5zCUCTRK80LK/R5rORnYsHVjZJqwKWgju56bPBoZknzTd5TSSclt80Ujew2jONCa+rxIP2cOnJk6s3yi59kii1mbuC5FNUoen8aITcB2dXSCds+/QiB5pDwusNcKLzE2QOHwdGjvODNcY22jnrrCweCfxX22rFDvqzc/7yg3WddtwfspNdscAJCDzpzYrG4Mbi30Zmr5FrCRbVNt0zW8uQL2zYlPDBqSwb9vIfgVkB3ztYGetaGn+owlPIOSFYRCG8d7gw9i/xRxeTncK28QM3MMyO0N0QaNoVcMcsAk/gQvbrc386K/0/kM9HasMZCkwZhyoaGIvjFB0rqlt+3ZEg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR12MB8300.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(10070799003)(1800799024)(366016)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mSRuiNR20kMmyyhWrfeb8m7LcRXhgR3XF9ExaTnL5p8lXfRtkz9Z5rNKJsCU?=
 =?us-ascii?Q?KHeEps/mqCmPF24IV/VkEQu57zF+K8NMMEaLvgV+N6eAh8rIy1U1Kbzzkyvk?=
 =?us-ascii?Q?VeRnGqhvFBVUwbdb/ZzHGXg0UoRzHkOw5YbDSIb0G7j/8kNiixHYoTKpbeTz?=
 =?us-ascii?Q?IW1c1Fi8eapRrn5N/D5iV3Ft3wZh1JD5opvQKlwrK0Wue+RROVO6b8nXYXJo?=
 =?us-ascii?Q?jGyKAZoJk0LotzYNw63ATt3HYyTiiHIZtgiI8vOpylWvgV4RSt7dKc7wyLy0?=
 =?us-ascii?Q?nAWnhUp0O5hXV/S8Gevb+3pfpnExdaUgFqTK8W6xEHAnP8dc+TKkvgYus2sr?=
 =?us-ascii?Q?ToqB/chzrtqcCQU5XubvP//xRifYurgwKhZecITD3igBKEeCtzfzFTod4NOa?=
 =?us-ascii?Q?DNtbVxGRiPQ1Z8MMGxyvb2NQ4zVbFwpx9yID3niDmNeZhKb/6TlTnOLWOYlP?=
 =?us-ascii?Q?E2hAAxtLvp0JIr5dNaOCfDkqDc5+UpSojDN0aG5fVKwzsuO0crZVoeHcvsG8?=
 =?us-ascii?Q?OX47AgsgJrC3zcqaT2q2WmSiKu+y+iwjMGihWiJQMjNqODhV5kkoryInB3fV?=
 =?us-ascii?Q?GGWFJ1KdUrES3yj5Z03+2791Mu/ivuUoFXtdGS3U+CkcEuuivva7yefIz/2o?=
 =?us-ascii?Q?NY7xkIeoNuum6TSCULLNnIp3FmfyQISnFYfhdSNgTljtcmrKe3zTqGsbEaLi?=
 =?us-ascii?Q?QQwuSpYaHbKQmr+dXId51sH/TVIibWsyMif4VawSXfrTHunkGkCWnA5ciSba?=
 =?us-ascii?Q?O7noCtpmqhqZly98jvzux9A6JJ6K1cGM2PsKpjEHh1qU7n1AJbdvqtDCYZmk?=
 =?us-ascii?Q?nncv1biFA1aocg9pUGCALi/A7+J7C8LHc01HBneMt6rRvtnvDWCtOqlld2YK?=
 =?us-ascii?Q?L4++Z/Y/psFBjAfiBCZ49NE/ncwLub6iFNcRLbYzCApehiKsNwFRjZsoVXHn?=
 =?us-ascii?Q?gVLqVzTKvKZOCTF+fNCrfqU402cnbBkk/6Wtq8NEeIUt14GM8bIk1uc7sJZd?=
 =?us-ascii?Q?4rKKHxil/XlT9FzR1V1FNlAuC37fVPCaikNof85it7DkDPy0q1Z4cNggmxuK?=
 =?us-ascii?Q?iggj0l0k8J9ZAD4ubFoq1c4oIs7sUGHJJecihbWr9c3jBmZG9gfkFtfY8Ygp?=
 =?us-ascii?Q?OGtQiB+8OMDsXc9EdcAr2ivPKcuNmlJaaJ+XBDzLZfEv4U9MBR7GbxblpoQ2?=
 =?us-ascii?Q?HOektLE8h/FTbMX/gF/fgeQkxn9LpnJGJgspkxebUOQal07dQq5qHWxER63t?=
 =?us-ascii?Q?uCPlELSvH2vUOjLR9vl8Mj+8zubFKuJwXu4k3q02MQP9t6YbnfCMO9X279GS?=
 =?us-ascii?Q?AeX5yJS+AZrzrv3ME9gjZpiPTP/4fWESe2GpqArU9J14XJmI99bRIRGDK6lk?=
 =?us-ascii?Q?J3N866axIgNfTlTxK5IkN8iMiFsPjb+EyGFpIOmgyz2YgJupUD09+ZwdI2p9?=
 =?us-ascii?Q?nF4WSdWE1MQTeEPPjCEzUc9GGoIQyE5cHDcS++qzQPWJb0qdq64YBsSCcQSA?=
 =?us-ascii?Q?3lzTZOpa1yQnyOroufIGJvnw3wbE+wXZLxHRMArzXASxPvlX9W5GLE5xfGdD?=
 =?us-ascii?Q?j78O9e50QC2FJSqEd6S6Qacvc40sdJS3ZpH8NbMVC4lQCJIm4emjBmjUpW//?=
 =?us-ascii?Q?8Vrqd+MUJnW0lDZBB3a+TXUXPb6/kYLgckIMjzvLaoeV/nMf0GW5RZ9isPM2?=
 =?us-ascii?Q?XGcm/iLA9aZq65FQTC1Evn4vQaTMZvkxmO2txgs1pept6V8HKiKjY6dehJG8?=
 =?us-ascii?Q?yCKfrH/OqPMs4i+kIg/MaLBwxJyaMlERtxVMISAyH+WQVzm301jh?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c19f99bb-48bf-4dc2-803f-08de977750cc
X-MS-Exchange-CrossTenant-AuthSource: CY8PR12MB8300.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2026 03:06:24.8592
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M643T4ju2WCGn+/YElT0ywANNVrsmGTTjMegjf93ZXI9kQOt9H+xACyCEDqeIkDnEivSX9AzySSYC1Bh8cCNFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7259
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1A5AB100005
X-Stat-Signature: jp78feuuz47a9hrc1cqb5jbtu3r997gb
X-Rspam-User: 
X-HE-Tag: 1775876791-381568
X-HE-Meta: U2FsdGVkX1/GvIGQH6/f95QI3nwGPsUF2SsXtCUIZz5UjXpEoCmzZNi4pWF7oQHbd8Pv9vFxCaieHKw3pL9Wf/GJRx8BZmbK7BKMrC83uzUY/ceppfjr42v1FHHpH7A3x0C4gNrTW0HdNlOhCUCFhZjR+FZMiibJgM94RwCWkSDlliqxR6nqpTmba4DpxpRMV042VurQ5zY7s2zCC2aVIaRrDt9zHLIEK8Vd1SGdg+U8+uJhWu1canyuUpqJ4MFw1O5/c4bWLVH3zPz6pBbKo+Ody2OawlC05OvTxbWWiOoZ3zmSE6/IdOX5g5hpAkZ63X2A8uUcHjLojIS8CgjjacFIONnYQPL+SKwUHVbWUvm9xj27d6pg8UBAIfgPCWsFqTOeq4n2B3iD6xlxcDq5AiSA6Veqmr1Gmk1Ka2ESk5YdqIkbiup8PMImMArLXiPRORjEM7yqv7s6s4J2ZOEUOe5foVS0ryNBlCba8BxfXX0IM1veVzxN1CKhGChvCooiuqCED/+hZwYc+eeB6bJojZESXlJJ8Dd+24bfepCbrxGjHXKVHRXU93GBY32KmLlNgFlpkDxbGSW3FD2VXmD8vOW5cOKaJ6SXDRPeOWGqOyGuRUS15dI/+hhygOzQk0SvvEVn28GmbaGPkEuTiOkousTsFJ3jlf08ijDJQkXHOvMdX8+b5NLqUIZ5CeP1A9GKkEoC/GiFryWZs6/yt8oJpjf2W0R+N4oz2eFZB8t6svsCIBj1+FhESUwDNkmBY1yCh6eMvG3ZxVl5Zq0a9qiK82zoLSz4vlEPFiXzO0EVHT4u1RL6HVuNKCL/gmNMIFyTN8fyC7E2RfEas6g5qECnBltfAz0P5JQJ31h5tfDvqvar2aVbjKppu8bo80FGSO0Q5X2XCXxBl/xPRlcQR83qbZUNgKjluWJsB56GtCTons59ebUfUmKzUgGi9vj7mH/Yvk6AY6YuPekwNKj4bcb
 1Ndc4GjY
 5wamb107zEZBaBGBV0GUnPKo/nU+v2K396tUYonc8TNo3Lw8j6SC4jQ2T8V+rwwePeoY94GBuYiOIMrZwnjbCJsK8Zmdd8LlbIlg1f4mTyUoUDUCcbY9Cw39rSTfYDa9Twp1grm7Qp53QaTke+foJe0H6hivZMEdCTuBI5cyaA7lnWuUyoygHsSOts8i5d/IIHotLpi3qfI+Xn+wXD4bJqjcDeen2Ilar4xEIJ31St1cie8E45tnHmr599RW6w+VYY9x18YC2bIqehV7Zp+vnKvNVxeM7Vld5ymkBspYPdSMRnHUwMhv7FrO1iQc5A/4ZKn7+KVrLOcxa5KEEgRTc5zne/EVeNC/FbOn7ydw7GTKXf7WPwzl4pVoi5Cf6i5IIAodSBxHt4Yq9WVByAbRwhNmnG6WjByZE36tJvTZ49y4SG7N7rOvoCSYlczbSxeuletFJP8d1fMBPIW4wT82RGAiObg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 10, 2026 at 02:35:37PM -0700, Mitchell Levy wrote:
> The C implementations of `this_cpu_add`, `this_cpu_sub`, etc., are
> optimized to save an instruction by avoiding having to compute
> `this_cpu_ptr(&x)` for some per-CPU variable `x`. For example, rather
> than
> 
>     u64 *x_ptr = this_cpu_ptr(&x);
>     *x_ptr += 5;
> 
> the implementation of `this_cpu_add` is clever enough to make use of the
> fact that per-CPU variables are implemented on x86 via segment
> registers, and so we can use only a single instruction (where we assume
> `&x` is already in `rax`)
> 
>     add gs:[rax], 5
> 
> Add this optimization via a `PerCpuNumeric` type to enable code-reuse
> between `DynamicPerCpu` and `StaticPerCpu`.
> 
> Signed-off-by: Mitchell Levy <levymitchell0@gmail.com>
> ---
>  rust/kernel/percpu.rs         |   1 +
>  rust/kernel/percpu/dynamic.rs |  10 ++-
>  rust/kernel/percpu/numeric.rs | 138 ++++++++++++++++++++++++++++++++++++++++++
>  samples/rust/rust_percpu.rs   |  36 +++++++++++
>  4 files changed, 184 insertions(+), 1 deletion(-)
> 
> diff --git a/rust/kernel/percpu.rs b/rust/kernel/percpu.rs
> index 72c83fef68ee..ff04607ee047 100644
> --- a/rust/kernel/percpu.rs
> +++ b/rust/kernel/percpu.rs
> @@ -6,6 +6,7 @@
>  
>  pub mod cpu_guard;
>  mod dynamic;
> +pub mod numeric;
>  mod static_;
>  
>  #[doc(inline)]
> diff --git a/rust/kernel/percpu/dynamic.rs b/rust/kernel/percpu/dynamic.rs
> index 40514704b3d0..a717138b93dc 100644
> --- a/rust/kernel/percpu/dynamic.rs
> +++ b/rust/kernel/percpu/dynamic.rs
> @@ -28,7 +28,7 @@
>  /// the memory location on any particular CPU has been initialized. This means that it cannot tell
>  /// whether it should drop the *contents* of the allocation when it is dropped. It is up to the
>  /// user to do this via something like [`core::ptr::drop_in_place`].
> -pub struct PerCpuAllocation<T>(PerCpuPtr<T>);
> +pub struct PerCpuAllocation<T>(pub(super) PerCpuPtr<T>);
>  
>  impl<T: Zeroable> PerCpuAllocation<T> {
>      /// Dynamically allocates a space in the per-CPU area suitably sized and aligned to hold a `T`,
> @@ -162,6 +162,14 @@ pub fn new_from(mut initer: impl FnMut(CpuId) -> T, flags: Flags) -> Option<Self
>      }
>  }
>  
> +impl<T> DynamicPerCpu<T> {
> +    /// Gets the allocation backing this per-CPU variable.
> +    pub(crate) fn alloc(&self) -> &Arc<PerCpuAllocation<T>> {
> +        // SAFETY: This type's invariant ensures that `self.alloc` is `Some`.
> +        unsafe { self.alloc.as_ref().unwrap_unchecked() }
> +    }
> +}
> +
>  impl<T> PerCpu<T> for DynamicPerCpu<T> {
>      unsafe fn get_mut(&mut self, guard: CpuGuard) -> PerCpuToken<'_, T> {
>          // SAFETY:
> diff --git a/rust/kernel/percpu/numeric.rs b/rust/kernel/percpu/numeric.rs
> new file mode 100644
> index 000000000000..13b4ab4a794d
> --- /dev/null
> +++ b/rust/kernel/percpu/numeric.rs
> @@ -0,0 +1,138 @@
> +// SPDX-License-Identifier: GPL-2.0
> +//! Pin-hole optimizations for [`PerCpu<T>`] where T is a numeric type.
> +
> +use super::*;
> +use core::arch::asm;
> +
> +/// Represents a per-CPU variable that can be manipulated with machine-intrinsic numeric
> +/// operations.
> +pub struct PerCpuNumeric<'a, T> {
> +    // INVARIANT: `ptr.0` is a valid offset into the per-CPU area and is initialized on all CPUs
> +    // (since we don't have a CPU guard, we have to be pessimistic and assume we could be on any
> +    // CPU).
> +    ptr: &'a PerCpuPtr<T>,
> +}
> +
> +macro_rules! impl_ops {
> +    ($ty:ty, $reg:tt) => {
> +        impl DynamicPerCpu<$ty> {
> +            /// Returns a [`PerCpuNumeric`] that can be used to manipulate the underlying per-CPU
> +            /// variable.
> +            #[inline]
> +            pub fn num(&mut self) -> PerCpuNumeric<'_, $ty> {
> +                // The invariant is satisfied because `DynamicPerCpu`'s invariant guarantees that
> +                // this pointer is valid and initialized on all CPUs.
> +                PerCpuNumeric { ptr: &self.alloc().0 }
> +            }
> +        }
> +        impl StaticPerCpu<$ty> {
> +            /// Returns a [`PerCpuNumeric`] that can be used to manipulate the underlying per-CPU
> +            /// variable.
> +            #[inline]
> +            pub fn num(&mut self) -> PerCpuNumeric<'_, $ty> {
> +                // The invariant is satisfied because `StaticPerCpu`'s invariant guarantees that
> +                // this pointer is valid and initialized on all CPUs.
> +                PerCpuNumeric { ptr: &self.0 }
> +            }
> +        }
> +
> +        impl PerCpuNumeric<'_, $ty> {
> +            /// Adds `rhs` to the per-CPU variable.
> +            #[inline]
> +            pub fn add(&mut self, rhs: $ty) {
> +                // SAFETY: `self.ptr.0` is a valid offset into the per-CPU area (i.e., valid as a
> +                // pointer relative to the `gs` segment register) by the invariants of this type.
> +                unsafe {
> +                    asm!(
> +                        concat!("add gs:[{off}], {val:", $reg, "}"),
> +                        off = in(reg) self.ptr.0.cast::<$ty>(),
> +                        val = in(reg) rhs,

So, every user of .add() now will be only compilable against x86_64? 
I don't think it's right. Can you make it in a more convenient way:
implement a generic version, and then an x86_64-optimized.

How bad the generic x86_64 version looks comparing to the optimized
one?

Thanks,
Yury

> +                    );
> +                }
> +            }
> +        }
> +        impl PerCpuNumeric<'_, $ty> {
> +            /// Subtracts `rhs` from the per-CPU variable.
> +            #[inline]
> +            pub fn sub(&mut self, rhs: $ty) {
> +                // SAFETY: `self.ptr.0` is a valid offset into the per-CPU area (i.e., valid as a
> +                // pointer relative to the `gs` segment register) by the invariants of this type.
> +                unsafe {
> +                    asm!(
> +                        concat!("sub gs:[{off}], {val:", $reg, "}"),
> +                        off = in(reg) self.ptr.0.cast::<$ty>(),
> +                        val = in(reg) rhs,
> +                    );
> +                }
> +            }
> +        }
> +    };
> +}
> +
> +macro_rules! impl_ops_byte {
> +    ($ty:ty) => {
> +        impl DynamicPerCpu<$ty> {
> +            /// Returns a [`PerCpuNumeric`] that can be used to manipulate the underlying per-CPU
> +            /// variable.
> +            #[inline]
> +            pub fn num(&mut self) -> PerCpuNumeric<'_, $ty> {
> +                // The invariant is satisfied because `DynamicPerCpu`'s invariant guarantees that
> +                // this pointer is valid and initialized on all CPUs.
> +                PerCpuNumeric { ptr: &self.alloc().0 }
> +            }
> +        }
> +        impl StaticPerCpu<$ty> {
> +            /// Returns a [`PerCpuNumeric`] that can be used to manipulate the underlying per-CPU
> +            /// variable.
> +            #[inline]
> +            pub fn num(&mut self) -> PerCpuNumeric<'_, $ty> {
> +                // The invariant is satisfied because `StaticPerCpu`'s invariant guarantees that
> +                // this pointer is valid and initialized on all CPUs.
> +                PerCpuNumeric { ptr: &self.0 }
> +            }
> +        }
> +
> +        impl PerCpuNumeric<'_, $ty> {
> +            /// Adds `rhs` to the per-CPU variable.
> +            #[inline]
> +            pub fn add(&mut self, rhs: $ty) {
> +                // SAFETY: `self.ptr.0` is a valid offset into the per-CPU area (i.e., valid as a
> +                // pointer relative to the `gs` segment register) by the invariants of this type.
> +                unsafe {
> +                    asm!(
> +                        "add gs:[{off}], {val}",
> +                        off = in(reg) self.ptr.0.cast::<$ty>(),
> +                        val = in(reg_byte) rhs,
> +                    );
> +                }
> +            }
> +        }
> +        impl PerCpuNumeric<'_, $ty> {
> +            /// Subtracts `rhs` from the per-CPU variable.
> +            #[inline]
> +            pub fn sub(&mut self, rhs: $ty) {
> +                // SAFETY: `self.ptr.0` is a valid offset into the per-CPU area (i.e., valid as a
> +                // pointer relative to the `gs` segment register) by the invariants of this type.
> +                unsafe {
> +                    asm!(
> +                        "sub gs:[{off}], {val}",
> +                        off = in(reg) self.ptr.0.cast::<$ty>(),
> +                        val = in(reg_byte) rhs,
> +                    );
> +                }
> +            }
> +        }
> +    };
> +}
> +
> +impl_ops_byte!(i8);
> +impl_ops!(i16, "x");
> +impl_ops!(i32, "e");
> +impl_ops!(i64, "r");
> +impl_ops!(isize, "r");
> +
> +impl_ops_byte!(u8);
> +impl_ops!(u16, "x");
> +impl_ops!(u32, "e");
> +impl_ops!(u64, "r");
> +impl_ops!(usize, "r");
> diff --git a/samples/rust/rust_percpu.rs b/samples/rust/rust_percpu.rs
> index 5adb30509bd4..90f5debd3c7a 100644
> --- a/samples/rust/rust_percpu.rs
> +++ b/samples/rust/rust_percpu.rs
> @@ -28,6 +28,26 @@
>  define_per_cpu!(UPERCPU: u64 = 0);
>  define_per_cpu!(CHECKED: RefCell<u64> = RefCell::new(0));
>  
> +macro_rules! make_optimization_test {
> +    ($ty:ty) => {
> +        let mut test: DynamicPerCpu<$ty> = DynamicPerCpu::new_zero(GFP_KERNEL).unwrap();
> +        {
> +            let _guard = CpuGuard::new();
> +            // SAFETY: No other usage of `test`
> +            unsafe { test.get_mut(CpuGuard::new()) }.with(|val: &mut $ty| *val = 10);
> +            test.num().add(1);
> +            // SAFETY: No other usage of `test`
> +            unsafe { test.get_mut(CpuGuard::new()) }.with(|val: &mut $ty| assert_eq!(*val, 11));
> +            test.num().add(10);
> +            // SAFETY: No other usage of `test`
> +            unsafe { test.get_mut(CpuGuard::new()) }.with(|val: &mut $ty| assert_eq!(*val, 21));
> +            test.num().sub(5);
> +            // SAFETY: No other usage of `test`
> +            unsafe { test.get_mut(CpuGuard::new()) }.with(|val: &mut $ty| assert_eq!(*val, 16));
> +        }
> +    };
> +}
> +
>  impl kernel::Module for PerCpuMod {
>      fn init(_module: &'static ThisModule) -> Result<Self, Error> {
>          pr_info!("rust percpu test start\n");
> @@ -228,6 +248,22 @@ fn init(_module: &'static ThisModule) -> Result<Self, Error> {
>  
>          pr_info!("rust dynamic percpu test done\n");
>  
> +        pr_info!("rust numeric optimizations test start\n");
> +
> +        make_optimization_test!(u8);
> +        make_optimization_test!(u16);
> +        make_optimization_test!(u32);
> +        make_optimization_test!(u64);
> +        make_optimization_test!(usize);
> +
> +        make_optimization_test!(i8);
> +        make_optimization_test!(i16);
> +        make_optimization_test!(i32);
> +        make_optimization_test!(i64);
> +        make_optimization_test!(isize);
> +
> +        pr_info!("rust numeric optimizations test done\n");
> +
>          // Return Err to unload the module
>          Result::Err(EINVAL)
>      }
> 
> -- 
> 2.34.1

