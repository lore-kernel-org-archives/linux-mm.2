Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B3E5F94CB2
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 04:58:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 903806B0088; Wed, 22 Apr 2026 00:58:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B4536B008A; Wed, 22 Apr 2026 00:58:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A2E86B008C; Wed, 22 Apr 2026 00:58:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 688646B0088
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 00:58:15 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0B9D38D2AA
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 04:58:15 +0000 (UTC)
X-FDA: 84684985350.14.168D6E2
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010012.outbound.protection.outlook.com [52.101.46.12])
	by imf02.hostedemail.com (Postfix) with ESMTP id C527A80005
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 04:58:11 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=W65WydtI;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf02.hostedemail.com: domain of Hrushikesh.Salunke@amd.com designates 52.101.46.12 as permitted sender) smtp.mailfrom=Hrushikesh.Salunke@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776833892; a=rsa-sha256;
	cv=pass;
	b=HNxcg9WpkTPLFFxattvt+0Xm56Q6TPAJsvzbhfjrj6SLS1JpZClyemGRANqUKg/oA9CqDX
	+F5uZ+I8Ur1UD5IDDbSeU9XtSYO5KHAKuCp+N0M7fyvthw8bcoOTWIfzM469rCuCOmb66W
	YxzQR75raWwRQ2Nkef/RwaWImG/t2Ts=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=W65WydtI;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf02.hostedemail.com: domain of Hrushikesh.Salunke@amd.com designates 52.101.46.12 as permitted sender) smtp.mailfrom=Hrushikesh.Salunke@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776833892;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XuydKQ3ooDlPirtpIqA4N2ypEmXtCES1D4OBH33jTB4=;
	b=yvnHG8iIZxpTszU6reENENZXg4x4o1kAxYRPBctbTY7yrOFYCUdqvkQxrk2lzKF/jMQtCQ
	dOgs75rdQD1f8rKfZAqIRYwlpWUkxFgtO3KcPDufyeM/hbf/OM/OljCC/8nOToF7NctBKm
	0okOVcuwTCWO5RKRLYRLh6w/fHWudyE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wtnm77b7/WrdGOzUbKnaswpnFi4Hy7R1+yi+Fe7kohW7CJBtK+MG2x6dSHJHXax+Oi6X0BZbyjBkWxV1fSyaM5KH66UV6ZGqLswH9jC8ejGVJHuIKcO4Mdzdda/imlZjKd4ObWxR3Ba7ilCcodxWMzglCK246gpm95BE64vXSHUe2qs7zyQUOHK6pjy/T8iBL+Q15HPB/24W7UN1ItvAscZGHD+5qCISOLAfs74n87yZwr94abpGyAA/gRXE+pxV4DABcRceFtBbTkwqgS6q9UG8vUyC5p06QT80uDk13d7jWxp5oRPw0RvfbF2Qh8qGLR/QZ5dtNk86tFKtuaEm4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XuydKQ3ooDlPirtpIqA4N2ypEmXtCES1D4OBH33jTB4=;
 b=TGiVC0ecb6f+lnXgDINBz8D22Y25+1OdEvdCojEv6AuEE1XlXBaL0fTzc+9xxCyG7kFV0+F/HAietgegc8TDukD6UeMoy3Iv2pcQJ9FZYC9otIRJddZJv0UIsXUqzJeM5A3rPlylRAAH7xqKWAoUnE9os2rVEI6bb0d41J22uMl5hTCtvRJwJ7MNMjP+9AIQ7IQOL5c83Ox7kLsm+Ca9g0N2HHME6Scz13tav/1SwDrU3lhjG7el0qJCnP5nuOhkyhLE+vfh3lfZ5G9CDPcmlrYaGY2YVluGfpWZqMwfmUosjB9AjPQrZ+ZUVMV7OSsrOSQ95zmQs1WkAALvFW23vA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XuydKQ3ooDlPirtpIqA4N2ypEmXtCES1D4OBH33jTB4=;
 b=W65WydtIeu7o98XENDLppopwPmdovrwkKoYJko4ard8ChTIEGKQP6aE5UOVZkzeKcZDEYmlQtwZxO2amwqwVBgs9RJ7pmYg+uGLxvoHxeRg6cE11e1kFjW/s2e6CKxoeQRionHZ/ygRIs3SUAM6LNZJN/qAvD0/bp2F/ghAURv4=
Received: from BN0PR04CA0095.namprd04.prod.outlook.com (2603:10b6:408:ec::10)
 by DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9846.16; Wed, 22 Apr 2026 04:58:05 +0000
Received: from BN2PEPF000055E0.namprd21.prod.outlook.com
 (2603:10b6:408:ec:cafe::c7) by BN0PR04CA0095.outlook.office365.com
 (2603:10b6:408:ec::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9791.48 via Frontend Transport; Wed,
 22 Apr 2026 04:58:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 BN2PEPF000055E0.mail.protection.outlook.com (10.167.245.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9870.4 via Frontend Transport; Wed, 22 Apr 2026 04:58:05 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 21 Apr
 2026 23:58:05 -0500
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 21 Apr
 2026 23:58:04 -0500
Received: from [10.136.43.140] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Tue, 21 Apr 2026 23:58:00 -0500
Message-ID: <5b2f566e-7bdf-4a4a-a9c4-9d89f69fc7c0@amd.com>
Date: Wed, 22 Apr 2026 10:28:00 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/page_alloc: use batch page clearing in
 kernel_init_pages()
To: "David Hildenbrand (Arm)" <david@kernel.org>, Zi Yan <ziy@nvidia.com>
CC: <akpm@linux-foundation.org>, <ljs@kernel.org>, <Liam.Howlett@oracle.com>,
	<vbabka@kernel.org>, <rppt@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>, <jackmanb@google.com>, <hannes@cmpxchg.org>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <rkodsara@amd.com>,
	<bharata@amd.com>, <ankur.a.arora@oracle.com>, <shivankg@amd.com>
References: <20260421042451.76918-1-hsalunke@amd.com>
 <C22AEA85-4EF6-458C-A735-9F7E48934C83@nvidia.com>
 <a6182e60-9b81-43cd-aa25-09e54d20d13f@kernel.org>
 <23A49388-EF68-4055-B620-54FD92FF2EC8@nvidia.com>
 <eb6a6dcc-9e48-47b2-9805-d14b121278ad@kernel.org>
Content-Language: en-US
From: "Salunke, Hrushikesh" <hsalunke@amd.com>
In-Reply-To: <eb6a6dcc-9e48-47b2-9805-d14b121278ad@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000055E0:EE_|DS7PR12MB6048:EE_
X-MS-Office365-Filtering-Correlation-Id: 23b646e9-0810-4459-c4ff-08dea02bbd8b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|82310400026|36860700016|376014|1800799024|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	bXqQosegq4+3YP6Mg+ijdL1OUxhV6qgGhjGGCKiCyXWuNOuNDtkkDaFfD8EL0cA/LvCgfuGUoHmD+bqY3893fCZlKUR3VsocC0MZMc1Ogtc5sAJX5e/NEhIPBrQSTsDtzjAWZzCSI5IPOaCJH1IJjw2CKizZLsb439bJPGr/FGKEf9T7/Agy7xs8s58Fdi2RxILLa8IWaG1BxMjEN5Pa15oCPU7Wq/wYkH1ERCqIoxG64xiWEybKRDOJbh4FmzsgXozmXOmdUAK39ZmGizPm8aX3FwAwr3VoGAptFHb/wNJW5ww406lWFPJs3WdfFnnKh5I6KcdoUBLJtUFAa1Hp4WxMlOKU/Bj2gigexX3Dg48AKZzmmSr5IWnsG/9VV0K+Z4UsKbN2VSFTH3dCHNCgcr4UGmCVD1TQLb7y3H0hlLdogAGL5EXpkHintYCezc8YtYeDkyFmg5SEStHi0CjchYDYxal8fpC2pgrlu7vBIwB8WXv8VsuhgO4jwfHP9X6LcjAWIjQgESjlgem8rfSJZEdyic4fGXLmRuwawX07Va01jlYixAtmu6JtbcmIJKFb0YXLWcvsXwL75aIIIQG4TJD7HHz2gdjqCXvy+DiwL9Pe+sEwM3w25npbpGAeOvvHMttZOvFRNND1VEvDQhuSCuPXo69aUjaguNoaRBReZWQrQJ/S5mk8JIiXkzvFIDlm4TMuLGK3mZnlz8xNwuUMpaVIom6vTukKH++9FP4R5Pp7x5UfJu4NMqR7L/L8gkKFW6xUjSC6FdF3xmmxoTF/7A==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(82310400026)(36860700016)(376014)(1800799024)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	1t4WB37acNF3vM2RUTLALM2TAjPW8Blk/kMC/JYfzU3ug422NWlxdPWe7bpvuCueUZ/dyj2Z8QzqlffuDq8rwHvYB5JwcXLHozM4U5+Hrg2kJqAay+4ZPiyS312+kK+snafGeiaQ6K7CTbsbhTELavoyJyF5BVbtb0glhvPoJrJuM18o70vBO2JWaAD5OJRJGzkW0J4y4rd5XVUsuTbG8ddXXcnJYQqagX/K+qs0lcoyTiJAGex9UOpAAo7XvsXuQXH4or0IDg1EB+4911c5ay5Zo/pXjOXMPqGE9aho5R29TZoubkK6L/JCK8rFT7ZByYIPm4Qv0ndMlVifeK4D9VULQ2BiNN8tXWNaa9caP/xu5t8Z+gvXppUTj8g+71zpMItkTRyMhzsgtoXdk0bsxPbza11bWmCXAyS+rpt8e5RUiys5u8YHH3plKozKcs2X
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2026 04:58:05.6875
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 23b646e9-0810-4459-c4ff-08dea02bbd8b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000055E0.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6048
X-Rspamd-Server: rspam10
X-Stat-Signature: 3py1mwodh38aeuwhu9sp7qimdxa4zs8c
X-Rspam-User: 
X-Rspamd-Queue-Id: C527A80005
X-HE-Tag: 1776833891-149205
X-HE-Meta: U2FsdGVkX1901tDdks9hVviDQvhFBdS4qt7uRRkTZo8gd+C26k69LKckO423NWMikIMFnR/wRrzMcItfOU3YeHWBpdoRmyLSSH6R31a3BRAq5G5+lJpO4wWuQyu39SjIB0638/MUuP3HYIqozIR3wQn68oe9ayqN/vXu9mKGaNt6Nm84W2PZgxrcTaDph8DZGqcBy+9QCiOuBsnPGQ4XkJNJaZ79NqeqcFnmTernNz5Y+TRsu99FaRy3f2fhC2baxgMaprxfUhMWsPztD2XswE2g/P8tTDZAC2gmi8QooX+EIxkjVKXm+Jb/ojGfFPUmcXG3s8L1kQK/MWCB8JlU8ICwkM6mc3HCpKvcEM64Yx/tKOn3eNDqSj5ECXQr9m/mQ9T+pqyLATeQ0/mWjfC8y8I0RT96rYl28vEccJee5BUk/RtUXEKrkI3UKF42Es/cPloTxfYYc55QLGOxEAO5yNSjl879WUfcHYO76dNoEDSc9ns2cNJZxbbdiWSNemyC03/uVk+gWWDDtAjIhk4vOFDbzqShu5FYz/I52hC0767NpM6NcQRmyyOzNAkqrnsxQ/Pl8pALGqH2X2FUGXn6jWD/zR/DIwwZM0W3qiLajBGbAtFdFLFzYIOvmwqve4xdI9ZAkj7u6gvTPuh+jzdoGVnusaKdelTjrXRnJWjru9vcihn7G2ZsMpkqU9UxK28FbLTy/YqhMJTHeydGH79dmWzfj033Rjj8D3bkPu7OHPTP1OwCMGVvZX45AY+LPMMvDtQWXQT8oZwuY60wXr1dEESPh9ztwNxNHIrg7DzQKGIHj33pSa0Y1TcFoMg7y46yKSbR/gXKGs22K+kHPUXFy5FtbXgQnzJzFFP9BTBWhv76Y1bnWDy44TUoPUbpILqDeGeuMOHgXjcn2jTqoS7FXjrfClnoRxewZxTQBQgMVkmCY/8wrS/HV3xs32MZXgcyjo/jrUTLuPvJ9rTL6Wm
 M14FKyPA
 yuiT1OY62Evg3O0dDPBUCMlB9Sz+yZYSE3D42lMN55gOl/eZqnxu2RwTaWKrqTcDNLC5EdiMdhUi6++nrLqQIS3/FOUeRPAyqz2DXYRi7knpTXm7T0KH2j0qA6ZYsrd4wL0yQ42tnAYTZw4CTQxHTFvdqA2AbjWadcDP5uwgy3DrEyK493uB/PrN75grFzP7lZdxYWimNR+EGjogSGNwXggh5HO/+/jmrwuSmSJvRgQcQ90FPyim0f95TsK/VpdlMlOS2onBzOkuw/W7YPY7mJS0rdlieYtemjKDOb3/CowHhh2o3F02DjltJ59vERBb1BX3aWDxFYbUWPl4aEtQHEnyoPoqmcCLozUpqQvxO3B9wTqPr7vskA+XnLd5JVgXKflx8CPSETVXOwn3AShnjVvOF3sV1iAkRwt2/qiOPIOCzpQCU6CczY4epDnbV0t3o4f70uhTfSJwR9uFknaNNSc8fe/1F3mMoWBLGQdYw0J7vj8p5PkYoF8YbrGflY/kS7RA4WbAs9Yx9yFTBkQsAaISKFOPD19wvE8u99QnmvcPxztc+smjseNixyBHMbqLVFvjWp1twOmZ1/SxYoLr1/+Db7rTxa4yecYqyIqEP2B/1fKQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 21-04-2026 19:36, David Hildenbrand (Arm) wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
>
>
> On 4/21/26 16:03, Zi Yan wrote:
>> On 21 Apr 2026, at 9:57, David Hildenbrand (Arm) wrote:
>>
>>> On 4/21/26 15:44, Zi Yan wrote:
>>>>
>>>> kasan_reset_tag() here removes the tag from page address, so that
>>>> clear_pages() can use the right kaddr. I thought each page needs
>>>> a kasan_reset_tag(). No need to respond here, as I am reading
>>>> the code and trying to understand how it works.
>>> It's all confusing. But we really just turn the pointer into an untagged
>>> pointer here, once.
>> Yes, I realized that after reading kasan_reset_tag() implementation.
>>
>>> So I think this is ok.
>>>
>>> I do wonder, though, whether we want to move the
>>> kasan_disable_current/kasan_enable_current into the
>>> clear_highpages_kasan_tagged().
>> This sounds reasonable to me. And also replace kernel_init_pages()
>> with clear_highpages_kasan_tagged(), since kernel_init_pages()
>> will be a wrapper then.
> Agreed.

Thanks David and Zi Yan for the review.

That makes sense, moving KSAN handling into the helper function makes
it self-contained and cleaner. kernel_init_pages only has two call 
sites in page_alloc.c, so replacing it with direct calls to the helper
should be straightforward.

I will incorporate these changes in v3.

Regards,
Hrushikesh.


