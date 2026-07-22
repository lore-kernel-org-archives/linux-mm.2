Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4730DC4452D
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 04:39:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F0496B00D0; Wed, 22 Jul 2026 00:39:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A17F6B00D1; Wed, 22 Jul 2026 00:39:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26B756B00D2; Wed, 22 Jul 2026 00:39:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E58446B00D0
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 00:39:42 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6A6D91A0352
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 04:39:42 +0000 (UTC)
X-FDA: 85015159404.27.8E1D845
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012024.outbound.protection.outlook.com [52.101.66.24])
	by imf29.hostedemail.com (Postfix) with ESMTP id 48126120002
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 04:39:38 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=StBEYEWJ;
	dkim=pass header.d=arm.com header.s=selector1 header.b=StBEYEWJ;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf29.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.66.24 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=3; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784695178;
	b=l5hxiMefosir0OTOxEtUoZRdS7MnplTFq/zWpiGGC4E7I1QTHswW1YVKXjm4JLQ+zN8eey
	aRhywEvfNCBgL+Tz7ViZhvCOSp+ehns7S8JvI/YoCqUxK6HeCyo/e8xM+9ygrvM5fqgfi0
	Dh7zc7641o59ozBn+OSqmTYb/Mt+vyg=
ARC-Authentication-Results: i=3;
	imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=StBEYEWJ;
	dkim=pass header.d=arm.com header.s=selector1 header.b=StBEYEWJ;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf29.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.66.24 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784695178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wbVgzfA643nPqDQHesnWq3qXC7mpwzDK+W1ThSy3c28=;
	b=jdI6F4/WfFzBZOuXeWe7Pk9T47SZdwILZxSZhojS5JeRqIrU3jiJ/mNeUaqQ2eUb7CLIeO
	iN7XD8XsRP6nzzsuBcTutL+4dYP8YlSrJcTnsnDnab7bamcgerqrjJl5vJXlT5Jc8yfQN/
	qHOYqYEgOA7JNvJdf1tcn4nobdoJSbI=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=SdgRLM2OflaIOREu3gZWVoxelEDn4MnacqQMXCL1NniXo1iqHOukrLyeyBHYaCtnzjbhFq63A1yS/82yd6lQ/roJDTGQjQIvrNVB8dtm1/AxmZAVeKcmX+JCNoKnu0jx+7NRqkkdRLeFfkDs/E/tb3PbfTHY3rnMPin9nKjBcirNhnv9ffj4r3tuPhEBPmB40nNX+snOU3d4i1pM12p5iI6BnnWdLTq567kBRxBoreTpps9p9TN7rva3kc68PFM0AFHUSMZENUNe/07K6j2jKeRok7oj0z7/vyW6q6UAmSu8IbIAbfLPTGIx8l6GSWSUHjV0pjdKf+dGp1B9k8EHpA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wbVgzfA643nPqDQHesnWq3qXC7mpwzDK+W1ThSy3c28=;
 b=dF3C7SuZNbIRMgnTQ5aiUvRHzxZ0sRMRcx/unOMvwKSwv6t1xR3O9O6KynippLlP0dPyrmogUCBFyL4zBXr9T0uvk4LYKP2Y464xsGUuSMnNxXYLcWbQveMV+SfHytEpGldf9tTyaqifvw5AvzWd28Q7g0TmZaipnlOgZXrDcvETZ/1uqZNJJ8mNK12IYl2dl8xkQtZOIAX/XDCBBJv7tVR6OVEfnBrpE2ZPHxElRi4ykVGiq7B48LpNScU8hSk87yZRc1YKac4C8IbU7LtP6nXkPvO6hnD35MZuAGHwUdkNKz03imFB2LR+Wr4PRzVYhB3PdDAKIF93g1vR5IPIDQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wbVgzfA643nPqDQHesnWq3qXC7mpwzDK+W1ThSy3c28=;
 b=StBEYEWJAuLUc5VBPzl4/IaWY+RtuAEDsIb4vs6fPPYQmxo5RrDtV4Jac8hZEGzRarT+mwILLV2qzkRi/nBM+5slD+2JNYcKLpeNC0ef7+JF8/d11IXtXCnBIB0+ZzkxEz3ucKIKaoSVX8ejVTP8/7KK7UWribxWJblWJxhBcV8=
Received: from DUZPR01CA0034.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:468::10) by PR3PR08MB5627.eurprd08.prod.outlook.com
 (2603:10a6:102:83::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Wed, 22 Jul
 2026 04:39:33 +0000
Received: from DU6PEPF0000A7E1.eurprd02.prod.outlook.com
 (2603:10a6:10:468:cafe::77) by DUZPR01CA0034.outlook.office365.com
 (2603:10a6:10:468::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.10 via Frontend Transport; Wed,
 22 Jul 2026 04:39:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF0000A7E1.mail.protection.outlook.com (10.167.8.40) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.5 via
 Frontend Transport; Wed, 22 Jul 2026 04:39:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UjNYp9SA0PnhBqLKLZ2Z/VW4Neg+NhuJW548ir7JAK6WcGY63Fuc9o7mrzWsH9x5ehl22UwAPDDgDob1GUk0g+HyJK+0YG3qi8VFqvEixH1Q3wzJCkx0SSIgnOA4IZpqg/l6/yOCxZWqhyoGzdB4x/99Tb71wF9wVH9OX3jXbUjkE+jmlL3oBFoKHPU+d5TxoqHytiujuJoMUnbDjeWZDHGOR+hf5RBgO6PfWq3uvS1UghahchzyNiIOuTA74TVgrZz1QdQcuVMc2R3WDsj0P9Lyb5r3yBVVe9BQsyW+NEtKm6crh9bRjLq3rEzeToTdczA7WUuqG3YC/wsLQi1HvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wbVgzfA643nPqDQHesnWq3qXC7mpwzDK+W1ThSy3c28=;
 b=kxaiVa1UCT6N/1ivyZII+J4eHQT+s9fUFfZM24vbIuHmNVe88A5lzaVGLsWRP96woWOl7KT/FsBfYkgY/mB8vt0XLn3jfXpwM/JOifE+j9Gti4KgcNf+uGaXU/D1VNykRBCY+868ekqYiK/yQIaVdQ1ldWdE44qlbvZuiM8Arkmsd49RAYE4LnV2LQlQg04ks03SEaS+92ZEzXAL/2OHo3sV8vtx4Dwc8D8jWGZjYC0A+9KNgj+IW6IhyHSu81gGAEnOFWMz7ykLXMDPWIuVHnriDNXWpwxZacvzF5M+L4L7fTyPiBzFFE+NiMm9w5nTQO0jp8uWKfWYVd13SJ4nSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wbVgzfA643nPqDQHesnWq3qXC7mpwzDK+W1ThSy3c28=;
 b=StBEYEWJAuLUc5VBPzl4/IaWY+RtuAEDsIb4vs6fPPYQmxo5RrDtV4Jac8hZEGzRarT+mwILLV2qzkRi/nBM+5slD+2JNYcKLpeNC0ef7+JF8/d11IXtXCnBIB0+ZzkxEz3ucKIKaoSVX8ejVTP8/7KK7UWribxWJblWJxhBcV8=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com (2603:10a6:10:417::12)
 by PA6PR08MB10419.eurprd08.prod.outlook.com (2603:10a6:102:3c8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.18; Wed, 22 Jul
 2026 04:38:29 +0000
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047]) by DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047%6]) with mapi id 15.21.0245.009; Wed, 22 Jul 2026
 04:38:28 +0000
Message-ID: <86fbde8e-c0dd-4ccb-8890-210026ac6756@arm.com>
Date: Wed, 22 Jul 2026 10:08:19 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 4/5] tools/mm: add a standalone GUP microbenchmark
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 Shuah Khan <skhan@linuxfoundation.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
 Leon Romanovsky <leon@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Jonathan Corbet <corbet@lwn.net>, Mark Brown <broonie@kernel.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260716123226.197736-1-sarthak.sharma@arm.com>
 <20260716123226.197736-5-sarthak.sharma@arm.com>
 <4665dd2d-99c8-492c-a4cf-b72028317d0b@kernel.org>
From: Sarthak Sharma <sarthak.sharma@arm.com>
Content-Language: en-US
In-Reply-To: <4665dd2d-99c8-492c-a4cf-b72028317d0b@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5P287CA0194.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:1aa::6) To DU0PR08MB9203.eurprd08.prod.outlook.com
 (2603:10a6:10:417::12)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU0PR08MB9203:EE_|PA6PR08MB10419:EE_|DU6PEPF0000A7E1:EE_|PR3PR08MB5627:EE_
X-MS-Office365-Filtering-Correlation-Id: 9600c2b7-ecd2-4c3a-684e-08dee7ab39fa
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|7416014|376014|366016|1800799024|6133799003|56012099006|5023799004|11063799006|10067099003|4143699003|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info-Original:
 2OUZAElBtVTWThM0joqZpB9oKeyoiLZ9LFxLzti+xl/FvxwVnRDyJQpJezay0GDDsba5IgbuzWtOMFjhUFQR8xdoIys5y2gH1/KAq+Mq8AKaea7H9JK2+OS0/ggifeBO6AcfmjfIQqQLMk0tUkscmmVg0QG/ajgveiiDgh1qFJC9MiuCaqr4Uj6gX02W3nr37fkmPE9yXHHl0C1QxP4F5F5ISgNV1sCu0MZtrRRwZ7FlSHFyF33c6lr2jM/407uBuiaqOnM4s8Vl/5cHKmRIagA3nQ8eNr5l5xvLvXJQGPvq1LZ149GZ2ESL+7+8iA1kU+vhBzDZXFVw31ELFw8mDMDWtjqqmw6qJF8Qz6p+2/uQhKhnGfH6lRd610AOZ7a76wiFXV3E0K988kbJ5UlTV8XTYRVxOdLBeAs2F5EPr9I/ZtSETqrSLD70loJ7pOi4jgNDM5MmYRDYTmHeACEAfgT7W9ly225LFswW09oaAXBclzATwHJOUpkARmBLnog9f8mNXXKd0/MmbPCKAiyCfRWWMwQNT2dlLPZRByQFod8kVk96FjilV4i0fyMHYW5jK++gujGAwq0yd4W7WQFmkFHDuAAuQQyst4lJmVfyUxbnmTNMmWf8Kws2/0Lp4yqAe1b17sFnpYOf87C0r6gnmvPD95oE4loeDKJvuIrTXjM=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9203.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(366016)(1800799024)(6133799003)(56012099006)(5023799004)(11063799006)(10067099003)(4143699003)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 N5vYVNZrjFUFMwDseatsbS9OLmInSObjc2fgoUG7l9U8WcUE5Dx9obEAqTYq9dNjf7JUEFaUugyl3zlxnQvUAMfCgDmKvRNforPYQLE5gOV5EwHlEw18DwSk4YC9r9i2DiSs1LEhtKwMruFrjfTjIRnBltC6QCHMoDliBeMDyKW8as65N3ZOCbSCWhppxKGnkQQVcGGGsrwmsf7IluiDZx/ckoLzQeP8TfvP6ZGAmpT6NnNsqxdZCnUB/oYuDLvuHHtb/aNdljYJIPX4b9od+ZI/a7RSAG+touvHpSc3aaJdEcof9q8gyfKYnJ/viz84sxCNtVvk7he2peoEFnOBcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA6PR08MB10419
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF0000A7E1.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	284b1811-ae0a-4443-dd17-08dee7ab137e
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|7416014|14060799003|35042699022|1800799024|82310400026|23010399003|10067099003|5023799004|11063799006|4143699003|6133799003|56012099006|3023799007|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	2tH/pJNdiUiRB1WbsWMajN7fZqILdg3FLQ8NvBV7YjeKJL4DXpJqEnD7X7hYP0yQLVcBTtrTKFysyLdwjU6CaVFoS+NcH46ZWLGgQI1ONdpxLNfcLaxA4ofTX7epXJ5AIgqFkVhUvUyV1s2uCtRF30mj+wk3i57yGwCq4raffPhW6YLOUxM7cDtTKKg1BvMGne1H9FqOroIkmlsHfqOA1MoZyGtPMglfm+0dowpUIaORzlqHUqUUcD7R7QqYJ7hUQJDAowkJUAXquXQsaa/NklHbLT3NvgDuIgZRDm6qflaoqemqqFJvArCMdO91yexO2AcdtAQNYj45AZDDh3+PW8bsXJMRrHWVCf5XOnV6bPxVw4ujg6Jr6hu9AfYbIGXRh9Ym/s04gVHTiFnElNSHQGnOWBXqg+8br+ct2SxNGIN2FdMTHqGxajzQesYG51HKKPw5ycRuZNLUL4IuIigaDgOPTRJg2VrFA24V8PK9seALTPWk1O7l481/hsmP5ESV8a3fDx4O3jkKnHHxYYZ42eB9t4BhK8CtBpAzrtuHIRF5UxCs8Mw30EiCSZkhSoXz2iwFc/N7F7Q+adXyNE8XqebtWuGFNx3LkqOad0Ps7fsyoeV+7dHB5+aa1wdFJFmzggej5eXbVwul3yWkMNg3IvSbzPso4D31BBe1p4Bg2QKPN3pWT8bhex42bFAqG6cqrI1jQ8ibC2CmOhKXyj9i6w==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(376014)(7416014)(14060799003)(35042699022)(1800799024)(82310400026)(23010399003)(10067099003)(5023799004)(11063799006)(4143699003)(6133799003)(56012099006)(3023799007)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	GOfR846pfyiXmAKXGucd6FlPI56rRLPZlfmrGOuqETQ/rs+wFxVpm3OUMJcrcs2TFQQ1hngcMIsIlI6Btf4hgQyEtTXjoMqYK1tzfeEHLbTqdKIPyHmRqrhLDFHGx0z4XL+ZIJlym+Z8huQrwxw3Hzo+yOLQwv03XG5WqMXzlGCs+WhZV2v7iRMXOvDd17OTpe8zGMW2k6DXvQ091nGkHhNco8go9DUoPjJjFCwcF1iPWcM1KhOxQ+nUUrN9MWtMw+rvhT5Y8/QVEVxHYYOUR/zsaZO9ixW4OZxfUu11uuMxKttSvrhY9LgUxMMbIlyLZQD8WVhCMMmvfzBeS3xpVT7I4ExirQAsZdFvPMTYYgKgYbYNJfo7LxcHA73FVE+oAl0QbyXyQfSZdC+7qA2m0VJWoPkDsXCjx2yINvFNDZ9KdbqdO8y4h34YFWJqCyzw
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2026 04:39:33.0338
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9600c2b7-ecd2-4c3a-684e-08dee7ab39fa
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF0000A7E1.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR08MB5627
X-Stat-Signature: yopt5nxdftcgujdprxsqkrbd1mmn8son
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 48126120002
X-Rspam-User: 
X-HE-Tag: 1784695178-14758
X-HE-Meta: U2FsdGVkX1+h8OShRZntMZwWLVfM3ZDySj9uocH1acx8+35+9xDiTYYyRica5fVr50XwfB+WUWEYQwU4SPRNS7uF7aMbBYVbvVHSVRn496IU8F+0Vn3DBr1o6V7b/kaK794zcWRZiaaNu6MPErFOxIjnw6ItdWhK+Puh3WKDJagNOhH8Xsa4SvqDrybChnzozXcJQGQ+gGzROBeRLlAgqHmBr9lqhKR4QtVD0/sPm6kS/+70WSnOFEKa+6Q31V5tg6NeEKCjnGG6hKPv5WnksCdqTRb12eTvrbK3KPIb7EH63fulyojUskViDM3AdXxZ2RdvmkSsSsXdk/XjamnZFDoAYz7bEmCcPPOG1lw/eKcaQ0bd0Za0eTdTCYR2FfTAGE2xLgJ1Ef+VeDrdi8oAyPHJEUzV03B6nbuP/spveLZYDOje1hKq7nfdC6XMQQZ5O8Vndgu5klqnsYnh6L089yFZiE/RhGe4oJOOAKDn0mY62l2E3oYw7yUtEEf/2/BU9614wMJpAhWeBY+hOydHGDPqWVT1Rsw0tkRJEj0ax0Rd3q4UETlBk8oiTxkn8//izLWEbKfVqgFwDJJ0+9ljnrf9dH9lz4Fo4t1de8t6DzFR17asQzKgS5HPB+tux0NFCy2I6BWMel+kSO1o1wz38CUDvZiDUYN5bUpJTQaAYdwrzReYQ7RVKSdNO7nIMiKSu9uqwej0ZwvzTDpFsDhdDknAgpluKoXYObXq4iYbTcliJmDkl1jvcuDNS8o2pViMKAAsHbNqG7XJZj2fBjaTto0oUBlGSdfab6hzEjVZww9AQ00j+UpkHN8nM1TiS2r7y0Bnx3xbg3L1gUli1DQzH4d62sBxrwsSeCpGxIWywAFN4rUX2esbjEnbcAd84fO5Hi2d/ujY63dvMMcoxH1USTPEXkeBS31ZEQV6gAWDLRHaMKRa4ccefnwqZUHG96RLNBK/P3JRmAgKYPHN9bv
 /5RlzN64
 fe+J1OlVXuY+WyD2fJGhUc7tzJvrUTs07b0aqqcNOukZhySpyC/IEddgvEFXoB1xnHJs6jkHGPy2ajHpze09n7aIsGQfok8j4mUl5jV5dSaYhttdsbdZYo1UNyTgLrfVMneuMEPBAgwjdJjRCuOgj3kZN0HQz3jSIGrxrPz4/NeZpvGuW/TYj/cp0gXRBFU6t2YTVx+hiBwIN5XhRaMqkYFS10VXU1FzFIKo+MfTf8IzR70GOlD+yrK1H8dP7mQ/x2yMrIfdIRwuoScDxZsThIr8W7ZtOx5DWyhrYryoYHgXQZHFDAmBxX6pkG79ETxOz+YdZDuoaS7Gqsgo6UfXmMxeBfSHVqqEo0+r6f8klVLndicAq0pXMOFdfbJURGSAnvA6133ILTnQOUnYGgG2SnCww7iwSErAgNA8hY6cppF4BVqSEc3e1cuHgdtwMsX1fRdvOEXGKa0M1/5nR1fIcuNZetPxL0nKAvmAmbNnO02NOClR2Jkciq5WNhZpUZYQwry2sxMCUwfbike+6LEPb5qx9BJj8FPFeASIVF6sPr8VC90N0knekMiDB2zFAOT2l181ctkTkcVTpJNqph63IHGPdEbrtI1yc42pQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David!

On 7/21/26 7:22 PM, David Hildenbrand (Arm) wrote:
> On 7/16/26 14:32, Sarthak Sharma wrote:
>> Add a command-line tool for benchmarking get_user_pages fast-path
>> (GUP_FAST), pin_user_pages fast-path (PIN_FAST), and pin_user_pages
>> longterm (PIN_LONGTERM) via the CONFIG_GUP_TEST debugfs interface.
>>
>> When invoked without arguments, gup_bench runs the benchmark subset
>> of configurations covered by run_gup_matrix() in run_vmtests.sh: all
> 
> To we really need the matrix in there? The matrix was good for selftests, but
> not when using it as a benchmarking tool, no?

Yeah makes sense, I'll remove the matrix part.

> 
>> three GUP commands across read/write, private/shared mappings, and a
>> range of page counts, with THP on/off for regular mappings and hugetlb
>> for huge page mappings. Restore HugeTLB settings after each hugetlb
>> benchmark run. Validate numeric command-line arguments instead of
>> relying on atoi().
>>
>> This tool is a mix of reused and new logic. The mapping/setup path comes
>> from selftests/mm/gup_test.c, while the default benchmark matrix matches
>> the benchmark subset of run_gup_matrix() in run_vmtests.sh. The standalone
>> CLI and tools/mm integration are added here and the HugeTLB setup code is
>> shared via tools/lib/mm.
>>
>> Add gup_bench to BUILD_TARGETS and INSTALL_TARGETS in tools/mm/Makefile,
>> link it against the shared tools/lib/mm hugepage helpers, and ignore the
>> resulting binary in tools/mm/.gitignore. While here, also add the
>> missing thp_swap_allocator_test entry to .gitignore.
>>
>> Add tools/mm/gup_bench.c to the GUP entry in MAINTAINERS.
>>
>> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
>> Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
>> ---
>>  MAINTAINERS          |   1 +
>>  tools/mm/.gitignore  |   2 +
>>  tools/mm/Makefile    |  10 +-
>>  tools/mm/gup_bench.c | 482 +++++++++++++++++++++++++++++++++++++++++++
>>  4 files changed, 492 insertions(+), 3 deletions(-)
>>  create mode 100644 tools/mm/gup_bench.c
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 26b06d80ab45..7d121dee9f0f 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -17024,6 +17024,7 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>>  F:	mm/gup.c
>>  F:	mm/gup_test.c
>>  F:	mm/gup_test.h
>> +F:	tools/mm/gup_bench.c
>>  F:	tools/testing/selftests/mm/gup_longterm.c
>>  F:	tools/testing/selftests/mm/gup_test.c
>>  
>> diff --git a/tools/mm/.gitignore b/tools/mm/.gitignore
>> index 922879f93fc8..154d740be02e 100644
>> --- a/tools/mm/.gitignore
>> +++ b/tools/mm/.gitignore
>> @@ -2,3 +2,5 @@
>>  slabinfo
>>  page-types
>>  page_owner_sort
>> +thp_swap_allocator_test
> 
> ^ Does that belong into this patch?

No it's just that when I was working on v1 of this patchset, I saw that
this binary hadn't been added to .gitignore so I added this, since I was
already modifying .gitignore to add gup_bench. It has stuck around since
then :). Will drop this from here and send a patch separately for this.

> 
>> +gup_bench
> 
> I wonder if it makes sense to "git mv" the existing tool (only slightly fixing
> header inclusion to make it compile), essentially removing the old benchmark.
> 
> So it would be
> 
> 1) Move tools, fixing up includes and removing the gup testing logic+matrix to
>    make it compile
> 
> 2) Extend tool by XYZ
> 
> 3) Add completely new selftest
> 
> Because looking at patch #5, there is not really any code reuse there, but I
> suspect there should be some in this patch here when moving instead of copying.
> 
> That would make this a lot easier to review.
> 

I agree that this would make it easier to review, but then there would
be an intermediate commit where there is no gup_test selftest. Is this
fine from a bisectability point of view?


