Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52699C87FC9
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 17:15:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E38A56B007B; Tue, 29 Jul 2025 13:15:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE91C6B0088; Tue, 29 Jul 2025 13:15:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB0E46B0089; Tue, 29 Jul 2025 13:15:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AE2576B007B
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 13:15:03 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2D0301601CD
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 17:15:03 +0000 (UTC)
X-FDA: 83717952486.07.9E72B2A
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2041.outbound.protection.outlook.com [40.107.93.41])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6245AA0006
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 17:15:00 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=A2JU9qeO;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of jgg@nvidia.com designates 40.107.93.41 as permitted sender) smtp.mailfrom=jgg@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753809300; a=rsa-sha256;
	cv=pass;
	b=4MST81/NcxaQ/6uuyuNbVBYyH4/Z92c46Tn8eI1TsUTeDWnaWkLfi5ifZp9xXPsHUjFd48
	oEa3vsx5rk+XnKT+p9a6aVJcjbFBJIUVB6y4t/VbCcyAFVY6rgnD/GAn1tjZhrqfI47k8R
	WvWR0jzvzK9i0WTDYKF/u0EMZFUkn+I=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=A2JU9qeO;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of jgg@nvidia.com designates 40.107.93.41 as permitted sender) smtp.mailfrom=jgg@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753809300;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n9BRM1q5heZf7KmBJ8o/BgskR2iqhkmyDvd/m9PF7kY=;
	b=YfcDc//MSZQ4+wriJ4+9kxitEwPDoW/CrmWOhaoilTRaqqW1yWj8TD9NuXFpuZIw7ugdd/
	TlIfotJN5E9JoGZlU3/hHIULjxEhyne3EP2vcaqZVJHWPZOMpvm45MuBW60olNLeRg664x
	rTnbTgsGSxkdgG7XtLv5FX62d9ATsQM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wlIRhl/RNclEPly6NracVoeQpMii5j7Af85m3lHN1X1wY014ErV4nBOasStu32YixVC5sAM+m4J0HlPFuNQL/v72yOt8Zxdltbrmm13ie7Vd17g5EWPmwUTb4u1U+RlTEc3EUX6IePr6fkDQWVB7CAeZCQTCoQ+RfOtd8mkPTXJzO3iijfepkPDvBk13nvBulAfewI5DcJkxb+8eOQN1m+YNGxdaFTSZAjZppZv35YwttZetoIDtLhY550udpPffn4cZ3qyjq1i7juS7yJjjTj+4+I9FSFrlImMgRGuXFsV0dYUrC780OXtwLQINOByajexs8znAXkEobEj35jjlNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n9BRM1q5heZf7KmBJ8o/BgskR2iqhkmyDvd/m9PF7kY=;
 b=eyHS+DrkEBe3UeFkB5NRCDdxw8GG4ZIWlXXATBMUskpWIrIOUb27e2ovs6sBNT4KeDeqHgRNgSRuXz7p0F5NEAgpDhGU0qOZL6a1zoDvTwg6ZVK6V7qqPiZY1PknSxYYxtqoxS8r9Vs3Uff7cv11VLrGYQOMHEAZBTOGeJlcOQTyT9bRUqlS3sYt5CPSFHqh5omJSsnnGi9KCS77+tS2GXXdrEwz6JhJVHKacxEIXE6CGBQe0umtkZC+hMkH4mYZrtVIhlreAPWizdMnWnNaJXvBIdkkqDJ5R9C0hUcg3IAnmZxBjEig3k4KV9shp/ND1lWIZofOCvuIbOdLqwASUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n9BRM1q5heZf7KmBJ8o/BgskR2iqhkmyDvd/m9PF7kY=;
 b=A2JU9qeO+YmwhDJOEbtNMIyJbQ0j58Ab4E3xF7YKAsoD30/tkmH5ylzNdCECIHuDJgYTavPIpJpveVXD2fK7CiypPF//yLfu/fBy8Zm4lzMhEPDTlGLIAeCSZ3bIzncLvR1AODCPgw27T2+JSLkhjIP+Hj0RHv8zt7xRcW3MdzN+/UBrS2osefdbNpUJ7JRJNjS09pD0tpsP8rWLAZ7BMRfAbkwVOMUoTyQoVeBFfAbMF4VTugxKK3lWyHl2Apdoj2w9+02dJ4UpH1lnqYSd0fdIM2IxUbayKnsUstuOgIBFV7klZrsmL/4uufOvjytmNKALEMV/k+ptdQhXP78Kcg==
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by PH0PR12MB7983.namprd12.prod.outlook.com (2603:10b6:510:28e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.26; Tue, 29 Jul
 2025 17:14:56 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8964.024; Tue, 29 Jul 2025
 17:14:56 +0000
Date: Tue, 29 Jul 2025 14:14:54 -0300
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
Subject: Re: [PATCH v2 09/32] liveupdate: kho: move to kernel/liveupdate
Message-ID: <20250729171454.GO36037@nvidia.com>
References: <20250723144649.1696299-1-pasha.tatashin@soleen.com>
 <20250723144649.1696299-10-pasha.tatashin@soleen.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250723144649.1696299-10-pasha.tatashin@soleen.com>
X-ClientProxiedBy: YT3PR01CA0074.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:84::32) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|PH0PR12MB7983:EE_
X-MS-Office365-Filtering-Correlation-Id: dd118a5d-800d-4c97-06b8-08ddcec370ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?QjXkbfZAMz5tQDHMfL5H14fDyXIh0kenkPaAktPsm9BeaItC8BqMughUnx2P?=
 =?us-ascii?Q?UCPY3Gu5HREbjHnrwWTdHWUiQm+9O8uNbpK/kyPXHRI6102JgAf61vEO27zo?=
 =?us-ascii?Q?wJZK7DJhuD769Tet26O2FwCSsmPP0m4diqkibItfPdkJjs2wkydWhAOj0SnX?=
 =?us-ascii?Q?IYR3asDmIRP5h1XFL4gOlzB7m7GQIRWnnF1yvvyvVOIxzdUubeUxX7WCcxOf?=
 =?us-ascii?Q?xmYQBttRAVdhvS7riyNUQI52Z+KReVWpLnUBbert/F6VFXvZGcWcsuzYTwQ0?=
 =?us-ascii?Q?vYTsFsFy3p8I+BU+oFq4E99DRCLyQCNwWBLBPF+CKd9TshtWbC8QJbZU6Z90?=
 =?us-ascii?Q?8auIpXJTdSHW7MXu+Frr+CInTEmVTMKPEsaN6FqoPdJHv+Vm1TDlRwtPzWXK?=
 =?us-ascii?Q?P5gBtFnLADL7h9pCR+NzncR4BnmLB8eXVWQFQn3q7Dbppry1Q7+x6ROIDoVG?=
 =?us-ascii?Q?ubGfxiHN1pY69na3TLuxmid36mDU9Te5Ho6oaXnh85cqVrDvNqHnmQMicMjO?=
 =?us-ascii?Q?AA4LJ8BDud45iHpnpZ8g4HbYw7XXRTdCjH9UHIRZU0r5NF7f6Yhd6vkfAp1I?=
 =?us-ascii?Q?3ql7spXPc/r8C/59Wf/Hp3H0gL48082fi8csYl9F3gqguY6zUFRk+cA41xIa?=
 =?us-ascii?Q?bLwetzroFXBBS0A5hPpnabjwq6Go2daUmyHZ364f+v/cwuhxvNlGekMMNt4X?=
 =?us-ascii?Q?B5eXouMrsR1MLfZgv6TMJle0uCRGp+AmVx4nl0LZXZsDTF61WGQPO2zVlfLu?=
 =?us-ascii?Q?yMDD0/bbP+L5TtlU0SQi+3E6dajqPXMDMON5lB/m4mzfNE5sQ40ngt0Xa4q1?=
 =?us-ascii?Q?w32FN4lv9VRba9j/Uie3Ig5aUCOjW7Xf8dQpuLGFPwb1FnZTRtaLystBPf9M?=
 =?us-ascii?Q?QdMLUG2I2wn8FHCa/M6F3mkY1fFM7ZwJRsHgUqE0yMAEpAAjsJz7FsZc5PBW?=
 =?us-ascii?Q?wS6RPcUxrAMuYoGmz30GsRT1ZCzkJ8OyJJawZu4O9xJ6gfo+47O4G7OEze48?=
 =?us-ascii?Q?V34iZJ8tUdkW301enYrziKhAiz81osdYNbu4ZB3+P13ggRHgWhVlkY/LHePh?=
 =?us-ascii?Q?wRCoEXqKbRfVQLUB/Hgqkoanu+aeKrQ4Wl7QMKDxnfnN/KmVAba8hsn5qEJV?=
 =?us-ascii?Q?j8YPcnDSvHlyygUIpYKgpcFVIKZ6vgriHq8C3V98TVvsDNzi0tMmK8WaIsgy?=
 =?us-ascii?Q?nXZINv4SISnsP6wrbawD287Q+JB89g9heKI64K36pO+fnpI2yg+annisRykb?=
 =?us-ascii?Q?28QvdwmuGDyVzix0RBg8AZ+KNxEothc5ztD/BSL6n6Q+EXe7vDvV/vcJIy3d?=
 =?us-ascii?Q?WgRbJIE+HL0JftRYk2n76s5VVai6hn/7b0BoQKKVhMN73ypXeWSbWGVuHOeq?=
 =?us-ascii?Q?5BDpC0v0NehiNBzOR4/NN6jDTuAAaJtKXBYRRdnjk3Z5KnJvLVRHigNLivOs?=
 =?us-ascii?Q?xJ6JPR0bF4g=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QnQxvUapmPSpVxdqg9QgvJnsug6Fbz1/wrB58hs1yGl5O/kYw6HGWoxtZgL6?=
 =?us-ascii?Q?aZtF5d0vuvakaUPO5i55FsnUTysHN0YkoYl6Oewa+3E8J1Dioovo6+P+Hj/y?=
 =?us-ascii?Q?+wE5LRs3O9/nc8GqzJDH3pFvyYh5ne+/r0fTsFE4nvnm01+iY76Yl1vr2A3w?=
 =?us-ascii?Q?0ca2xLRuhy4ZGuErd4HBmB8XOsYNJTcST9bjO4bLmI58M3Ngklz/SoiBR794?=
 =?us-ascii?Q?wCJ40Ir5ZXQsODckCmAqOA/meVIat5AsSSqj5y1C+WJyCQewDe/9JnBNWs3+?=
 =?us-ascii?Q?ZzG02KF70aSpBJyhuNAFNJ9kvUxJfEmyq80XXPTCzwuQVRRaFv3/1lZwWsKe?=
 =?us-ascii?Q?uZE+tNDqsSBFOjQaU3+qDNo/fWxtCzzIUJRa/6O59FSqljz51qrUzhZNFP7H?=
 =?us-ascii?Q?1ZO0c+0uD5m9Z8FhYgiXRqfUEs2nEhp7arNQ4V+thOxEfycOw2oelqk34tPy?=
 =?us-ascii?Q?YlsSHEe2W7DAYk3icUZ5Whx944uv8zZBjDMyqiuSUy+6gNJhoV4AexQYfbEF?=
 =?us-ascii?Q?xI3bHLIY3n5FF7CE0bXZAyqOXcksqY0fD0mG7mE76No6jhurhaxyfcFIKPzH?=
 =?us-ascii?Q?RK9/+SsOpw9pllNBOoV7ljC6wbJ9vrkSt4bMoERb1FlOZ89tbyPn2U9HAi0w?=
 =?us-ascii?Q?MCY4s2uXMozP04zKoxoLaWFTbqDMT2qRUm6uqhLv2Lpddwxj0TlF3fHrNOU9?=
 =?us-ascii?Q?LCopR45S1Wu58eJEToOYQwGw3/uqSru5CqE31BS3vmfdT2s0+UCEBkIX6c2E?=
 =?us-ascii?Q?qmLxCm62rv3tiNUUbDSyj72EEdWdrEhPmQjedNYX7Euw93Hx+2ION2cbSynv?=
 =?us-ascii?Q?MqG0BSalhX4OYH0UT86H4uDf9/WFcQFbu8H0sl+DM0sFFHQSRJe4QOFyNvP9?=
 =?us-ascii?Q?xj+C0vRdDxYt4Oos9YGjXVcXlzuVE3qBTENjpkCFr9Oow966VKiDH54zF1ev?=
 =?us-ascii?Q?TK/eIKgN3gSJtUeyydPRLNgzFQDmBwub2CewfJGaBSfe16I5NKYckrAkvqus?=
 =?us-ascii?Q?/owFxj3jcd6BGf6H9B13fGlVmfrd9n0UfFKk0rnOLRvaa9fxabkfvLjDd3eo?=
 =?us-ascii?Q?opTjDl3Tn2UOnCtle4l7L420JqOfDQu1mJS21O5yb0JNSwvcwxtseZZguj/U?=
 =?us-ascii?Q?eG4QHBxxZyAZzcEM8E4fKXq3b8GmGUYZz2NzMXCHKAHqjyGvZ1tMzgnW+Lh8?=
 =?us-ascii?Q?IANAY+k7IMDr+CcPvG+EB5Y4SyoS10lLQ/QyrrT1MPiaM2avZMWJVR7830VJ?=
 =?us-ascii?Q?Ncqi14BSOUhAtw+ZT1nRu+euQYPLsI9v7QP1TLkWkfkZPwcj8+ZhecHzCqyB?=
 =?us-ascii?Q?4QDHhcRablK8R06OT8tKBSzHf1BmdK6H97X5mz95enPr9eF94AYfhNQikz/6?=
 =?us-ascii?Q?GAHyxADeXKz2ieF+B7c1HTSsJbAs5K94yEP1D9hUrh7svq4IzPWnsFUzMxIR?=
 =?us-ascii?Q?EYdk/PJwAuPbxU8wg+wwtgGrlXXqxXVaY2pYXDsIVNejP1yoAHQySj/C2IXP?=
 =?us-ascii?Q?IMKXp8BmBBwfxKUFqGlcFAjjoSStKIWyxIdSmCsXpXzPc9W4jrmARDzzzrPq?=
 =?us-ascii?Q?kmGShiYe/WdPGxJrVzg=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd118a5d-800d-4c97-06b8-08ddcec370ae
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2025 17:14:56.3779
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EPCedtOha2iXN4SP/DxrS3lw/RTg8RPpOdkz0zWRF5sHKcMgW2/mLelIyTC8TvFz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7983
X-Rspamd-Queue-Id: 6245AA0006
X-Stat-Signature: h4qddyp93ngz8awgkwxqdxaqykaowx3a
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753809300-472096
X-HE-Meta: U2FsdGVkX18jZbycS+3mU18jFnCiThR5WdV6ZAMXh0fYLHpwoBvn8Ax84/UKlj/UYX976UnJOhQERF2GiNl3AZITDMQka5ewGDj05ND6V1sxTSdw12fKyTKhLMHPSbHDEpwpK3wraMlXSuiSxvef5UGVOMDyHBRpDnkEGlyyInGYBB5+LBTv+GUizdrANplzhZVujFTwMPXwJQLJDKIMqtHQ8l4pjCzG7rJqPECcJjUvxNscB6/Fw3UaPjrGNL2orF5lQHdD02igVVPc31dhOcSSBHA6+zEk1+/sH7z81Zg2tljLs546bjJCicni9w7pADwKq3oimKfdXsyifR1JDTwNlAhBDkJtmGiZWJUyFGJM+nOaYRUMQiVa49iYvuV1eo/mlmg7A6DeJqU8mwOsT/ihdIE4OTtztFNu3dKVEEYRs3H8G8A4jLuFPtsXhfV3B6wiijIgZjppzLXIovm6AVMh8AODWpCGPhGvua2CYY/CAIY5gS/P1xTO9T0kuDqjkKlrGfA43/q7ihFby25O3bBUJA7TjA14blEdioIGRhIQcVVf5M57Z8d5uPMPFVBjSnOhZQEN7eFnkkBsAEqbWkKijsXhWYe0QWvoWaCMl4wIR2Wui5Ik8h5BBGD5zlDLYQavayipyFX/ITBfInLAme+kwz7jfPyZ5NFOfKW6eGjY10d7f8vU7cGe32tOCUZO4ELkZlwr9LdNNjy/Jo8b771/4W0OeC2/7hFqDoQV7qU1FgxSKuBFsNtj/yC6BTvbj9U8RqHOHhh9tQVRjz22haGQkWqq6A0ktshV/k+Ac1KARSh/RBBtUDOKOa23jwZrXiPWjc8cIK4uVMCJcSYj6D372eEUiyv5xU1rknaGoExCw9LI6EN0WB31zpa/dYrlAemzh+Bq46cZFkSSzr4CDoDsJ4K+foj+3zQcDivERwT/RX0KkMZLfWaUcbCoYlrYbvophJFPYRqul6FHM8j
 Rpp40t44
 Lwt4+x3QdHfTRxIynH/uSms0FJpXiGJdmb927y2xG/JjxqQs46K9hbI4uOnMbCGHloeS0LFq4jkTww1ZLapV5+GLNiakCRJsvJlyXjch22gDZk0QDoPOJPXABsxjnMiJRV9PDKOFs82+uKFhRLuFztXp+1KtIwHw4Vs486YYqPKFTE/AfCSaBqVNKPuBZR8F5FhEAawHF7WO6mLb7OTg+GPoQ9G28XoKhHKfWBKmay9oI06sFhCwImIisAs1aWGLkW5sXExKZKygrurL4fZPYQU90hmbSH6xMlWd1D8NlWnwYkxZoK0tGCo4s/U8TgpiSB9X1LSCmQwARm2flPNMVdOIbFxTRiWL5L93sDS/GDBT5RjnuUbKobGKfVwNTeUbCfOJntvU0chK5adB4dUPkpv4GnX8XVURik+b/nEovaT2/Xat5qfo5uy2w6Ysgf+xVn//tqyelor7PucnSumnQxq82eq/J7fjveDDRSMtIcaPcHpo2mKInN71v1LQMB18z8blpfl90eBiI171287g7GYwhYGt5o5wTOk3UNEC/rkybEBT+3UydBe/kKKjZvjmQ8NgSdN+ormTiq9NDU4VzxYUuABCO0d0zVOqu8165irx3fFAhZDU+OwuaKcOVbzV5l3JzCSpt1pNwteNSjT5wB1sm4Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 23, 2025 at 02:46:22PM +0000, Pasha Tatashin wrote:
> Move KHO to kernel/liveupdate/ in preparation of placing all Live Update
> core kernel related files to the same place.
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> ---
>  Documentation/core-api/kho/concepts.rst       |  2 +-
>  MAINTAINERS                                   |  2 +-
>  init/Kconfig                                  |  2 ++
>  kernel/Kconfig.kexec                          | 25 ----------------
>  kernel/Makefile                               |  3 +-
>  kernel/liveupdate/Kconfig                     | 30 +++++++++++++++++++
>  kernel/liveupdate/Makefile                    |  7 +++++
>  kernel/{ => liveupdate}/kexec_handover.c      |  6 ++--
>  .../{ => liveupdate}/kexec_handover_debug.c   |  0
>  .../kexec_handover_internal.h                 |  0
>  10 files changed, 45 insertions(+), 32 deletions(-)
>  create mode 100644 kernel/liveupdate/Kconfig
>  create mode 100644 kernel/liveupdate/Makefile
>  rename kernel/{ => liveupdate}/kexec_handover.c (99%)
>  rename kernel/{ => liveupdate}/kexec_handover_debug.c (100%)
>  rename kernel/{ => liveupdate}/kexec_handover_internal.h (100%)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

