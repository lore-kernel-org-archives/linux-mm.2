Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4932AC98302
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 13:48:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6478B6B0088; Wed, 23 Sep 2026 09:48:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61FF76B008A; Wed, 23 Sep 2026 09:48:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50DE16B0095; Wed, 23 Sep 2026 09:48:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1C5396B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 09:48:05 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9989AA6BDB
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 13:48:04 +0000 (UTC)
X-FDA: 85245155688.16.178D4C1
Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013006.outbound.protection.outlook.com [40.107.159.6])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7D84880008
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 13:48:00 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=CEAnJKHd;
	dkim=pass header.d=arm.com header.s=selector1 header.b=CEAnJKHd;
	spf=pass (imf30.hostedemail.com: domain of Usama.Anjum@arm.com designates 40.107.159.6 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790171280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UhJoI7Wuj8ebK8ZsC9lfG+NOdXn1WH2SV3Bha+yEvZU=;
	b=FfXLL1RNmqWmJ4noiinwIZX9lVIg4GJ3bmotoibb0XqQzP21UILSlRAxAU/t21i8LKb5CM
	Vp5r8gf+Vs6SsoV0asVDJ1xYaIfP1W+P32DDrVzHBWKJyZDRpZYjpy+MnjP8FrGBxKHNe7
	0pp+IbCNKbHbJsNCmh+WZ3AojluWz/k=
ARC-Authentication-Results: i=3;
	imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=CEAnJKHd;
	dkim=pass header.d=arm.com header.s=selector1 header.b=CEAnJKHd;
	spf=pass (imf30.hostedemail.com: domain of Usama.Anjum@arm.com designates 40.107.159.6 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=3; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790171280;
	b=GK0cjuDcpODzpiTfEcs8287u46OmqajLECDqL/AQlVjMto78yAWG7og0Zf8Woa2qirKONE
	f5Ce0tTzSp0QrIPpHC2/f/lyUIiL8MT7EpMalUFhzVrJY5ady/4gsSF2kTiyFcPih+KZyx
	B2Dfm4YAL6PrQMEks/sHNhZ8a8GTSuU=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=xVAmPSLiYLnLev2DhHQ9TtJw8jKZw9m7w5nahE/Itl7itPrHLfwlp9A3ddv0ZJhEdrS0Rg/xj9aZtLxnW0mRHfbh6QmkMQNivga4WaI/DzbMHnVXRQVmNxoAKEiKy9QTm6mteEtKK7h3XERqOpPfh++Xr9yiQ1UWs4scmKmTpp12ZP2q9UUZyPRtmjQ3um8EWO838GVv4ms15+PB18emdWhveyO1F1uunSKIC+Iq/2WjFTx0RScewtF/SGhZc0NYhT+F72RNqL7arIExReA+0wF7maShJHSacgwgSmVu0oEWo8p74GM31HSvT1VGBRDzm+nkRX0CZPOP5ST+ux2cxQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UhJoI7Wuj8ebK8ZsC9lfG+NOdXn1WH2SV3Bha+yEvZU=;
 b=PAmCtE2cShg8Gq0RF73Ksat5UuXYRnvD+u+aC3UeQM2BCAJxOa6S+/Bjttf5JUtbNrOm+XR/A+pLHlG9Et26mPQOq+nmqXVnW5s6dhQYFvlujPVimwWcDvDxYPlGL5Hk0NuQOKcCBMYRGfpJb3Gh5GGZ5/D2XxJlWxda/MTkcjjtPYBv7kND0krjVzT5dVX4pw6Duwpa9CVveue6aUoatxafZ4dBbypn5h+bMhT1E64wevsJ3a+BPHNFHm500jkVppyfvkOBY1s0+DqC0ENe9RJWJ036JvsEK2sgdXeiYzCoEodFlveByoGyapmRUWpv51bBCo5aQaxZQ3QxVM4qYw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=linux.ibm.com smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UhJoI7Wuj8ebK8ZsC9lfG+NOdXn1WH2SV3Bha+yEvZU=;
 b=CEAnJKHdb8pQYooTKptKnU5SRdLbDsAEXe4zpgonArlQ6IOgiZ/8YIcavCracvPOjQpwUG6IDxmkMRotOFU70VAs2tvEkbWl2CDlFoaYztnWgG1xGsH4yIaMIWIcku6xHq/1Jugkyrr5fMSl5MLqGbPsNAIWqIzXCdK5hRAzHtM=
Received: from AS4P190CA0004.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:5de::10)
 by PAWPR08MB8792.eurprd08.prod.outlook.com (2603:10a6:102:335::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.4; Wed, 23 Sep
 2026 13:47:48 +0000
Received: from AM2PEPF00070CF5.eurprd02.prod.outlook.com
 (2603:10a6:20b:5de:cafe::aa) by AS4P190CA0004.outlook.office365.com
 (2603:10a6:20b:5de::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.13 via Frontend Transport; Wed,
 23 Sep 2026 13:47:48 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 4.158.2.129) smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM2PEPF00070CF5.mail.protection.outlook.com (10.167.242.7) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.451.8
 via Frontend Transport; Wed, 23 Sep 2026 13:47:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ickhjXQUhKmKADyKvpX2SLen/DlJScYm9DJfnqtrT0vB5PCb170fHF3jxmOwNXlRzLUSbUuP1wAziagOgnSFGBjCttrrcFfENX65D8i9dP+ln8RQFfeUzG89n8fu/T/UzZma7+gknAH7MSvM8CLP3W63eC5OYD2IYMiWpiFMa3GM4gK2IX7P+ViaJ76swrL1VFmYumr4i47G28whFE38tD9IZ53B8tYhTEhi/T7VIrp7Esksf+puHqaCYgApPb54POHoYBpshiTFtg8tmqc20JN+oFZbq29vtym7n0NrIl2UoeLrwRJC6oVTX7oFwtYfOFa+a20xFRBPl2pL+xlMiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UhJoI7Wuj8ebK8ZsC9lfG+NOdXn1WH2SV3Bha+yEvZU=;
 b=vu4VSN3RqZb/Vcgwz/Wf9VmAAobBhpMEKFhHyr95Pjgw5OIiRPvvaQmdoJHZVLoLB52Nl7Jid26+nwpGAnFX3Zu5E6Fv23fp2XSMp4vtChySpfU3S9aMBep1Vb7KV8GRW5VuzCZDi4l/32O8rKO58Z1TH7/oEc1sON60J5QjSGVGbcqfCrvSy6efxkpmT55txFhjgEHEcigFViy3srFQ0r51h5ybwODA0eJ9pF1vAXgV4EQTrIL3zjWfh36yEsgPxGy7P9Ht61jsn37Mmx8JHPQVqoqLpDTx9xQc9sFoH5nzkmZyH3mjkF1kQHQPclrH7u3xww14apmPa9K0oBtPOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UhJoI7Wuj8ebK8ZsC9lfG+NOdXn1WH2SV3Bha+yEvZU=;
 b=CEAnJKHdb8pQYooTKptKnU5SRdLbDsAEXe4zpgonArlQ6IOgiZ/8YIcavCracvPOjQpwUG6IDxmkMRotOFU70VAs2tvEkbWl2CDlFoaYztnWgG1xGsH4yIaMIWIcku6xHq/1Jugkyrr5fMSl5MLqGbPsNAIWqIzXCdK5hRAzHtM=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com (2603:10a6:803:80::16)
 by AM8PR08MB5729.eurprd08.prod.outlook.com (2603:10a6:20b:1de::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.14; Wed, 23 Sep
 2026 13:47:13 +0000
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4]) by VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4%3]) with mapi id 15.21.0451.012; Wed, 23 Sep 2026
 13:47:13 +0000
Message-ID: <e4bf62ca-886e-429b-a268-3c0ef7903bc8@arm.com>
Date: Wed, 23 Sep 2026 14:47:08 +0100
User-Agent: Mozilla Thunderbird
Cc: usama.anjum@arm.com, Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin
 <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Dimitri Sivanich
 <dimitri.sivanich@hpe.com>, Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 Helge Deller <deller@gmx.de>, Juergen Gross <jgross@suse.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Will Deacon <will@kernel.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Nick Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 David Hildenbrand <david@kernel.org>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Uladzislau Rezki <urezki@gmail.com>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>,
 Eduard Zingerman <eddyz87@gmail.com>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, SJ Park <sj@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 Miaohe Lin <linmiaohe@huawei.com>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 Mike Rapoport <rppt@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 ziy@nvidia.com, pfalcato@suse.de, ryan.roberts@arm.com,
 linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, linux-parisc@vger.kernel.org,
 xen-devel@lists.xenproject.org, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
 kasan-dev@googlegroups.com, linux-trace-kernel@vger.kernel.org,
 bpf@vger.kernel.org, linux-perf-users@vger.kernel.org, damon@lists.linux.dev
Subject: Re: [PATCH v2 0/8] mm: distinguish PTE table storage from PTE values
To: Alexander Gordeev <agordeev@linux.ibm.com>
References: <20260903103002.1091859-1-usama.anjum@arm.com>
 <1401e907-04ff-4ee5-ad03-00d88531a091-agordeev@linux.ibm.com>
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Content-Language: en-US
In-Reply-To: <1401e907-04ff-4ee5-ad03-00d88531a091-agordeev@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PA7P264CA0091.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:348::10) To VI1PR08MB3421.eurprd08.prod.outlook.com
 (2603:10a6:803:80::16)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	VI1PR08MB3421:EE_|AM8PR08MB5729:EE_|AM2PEPF00070CF5:EE_|PAWPR08MB8792:EE_
X-MS-Office365-Filtering-Correlation-Id: 45d622ff-62f2-4780-4429-08df1979413c
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|7416014|1800799024|366016|23010399003|10067099003|56012099006|11063799006|18002099003|4143699003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 er1QZE7t/U3keliySsRiVAPvYcTdlk2LDXtXoxCQiX/p/iuft5DFC6Hg211hZb0NWQwvMx9IUr76nD9aJUEw77Mote6K6GncWOChMqvI1mvAdPiuFtY7C8ycOlKNYQ1tlEBYn1u1K/U0k6WYfHH8R9ubi1rj7q/KBa+aCM7tPa+BrOAUYCQuzhK4rHTtfI5dsJmYjVdU5NX+nPgICeyXE/qyix3tFyt8G5IoWrTWWFjVB7+b5rbKPsLN+kuBxibKgO9CMVu62dGdE+/EO40XuvQGsUBKik71rer8bglW18v0Hu2rF7C1JxLla1p73iaseziW1mjUv1m3YExgnIIMl+YIhaUOC64dFjPaeqkNJuKmYJeIDoG3g4wXQrYkck6UDnuAXxx3/JoD2gQR+ruheEguivjEq7VUX5QFYAwVdM6H/5ZHufLQqlO57DMlRyvVDUlvzJogbPkIWPJkJPrUDipq4nDYlgZ80fmDOpQ3NC1GqHaBk4DBDE2YgXlP6ZPPIBZwWetKZuNaLVhqTNtBrf0o+Xt6yHnVRPgEIBuo8lpAhYP1Geok+PounKdZ6Dt/kcTPVM6opmbIjL5lpa7vxzvMWlR9fG1NNwyvvz79w14YiI735TKIMcv5NJf7vgmk
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(23010399003)(10067099003)(56012099006)(11063799006)(18002099003)(4143699003)(22082099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 iITv+pbcilPPsUiFk1ljo6e+oEJjA5GQCrka1p5aoy5sK5/YpMHzwUzjve+/D+zQXB6T1hlApHgCWb4Fl6E07hSm463PAuBWWM8E8SJ95bMwPp9IZwnx5wy0gk6CrZWd6dSZPpZc/zVzXW7s4wtmsuH2SKf/pikvXU4rLMkejhus34n3qKxApBaHZ0aMPXv9HR1pDnmOc1Mi0f5FM1pN32GHc6thNsrNjHfOBDs4lij2vZbPDUDh94hF1ZWJZHdjQUMerPNjoAX1yhxuh6zhB1ZPQW9M7/qXajnBALmMcnt2uH9RaIili6VIXZCziCKY8yjahJb/qe3bqcLthGwBpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB5729
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM2PEPF00070CF5.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	43bfbc74-461e-4eb7-b61a-08df19792b6b
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|14060799003|36860700016|82310400026|35042699022|7416014|376014|23010399003|11063799006|56012099006|10067099003|22082099003|18002099003|4143699003|13003099007;
X-Microsoft-Antispam-Message-Info:
	0nVzaqRCcwMQ8CdRhEaC0+RTEHiFGDLJPjsvwKood6BdkpPo+vQrjbWt6LFO5G1N9Duy1aqGPzuuGHjwoeFovHL2F9FsQ7N2BqkVTz4DwNGeuHQlhV5XSUOMn/jh4Xt+dLSAuldkFi8OM3Xut0TUhAZiX/JhbWftVGf0yiEX4uuDQiuBbww8SVTsM3yxFXnHDlmBEf4ayMKB7K3COkpuOgPMB8REO2SB9ncGXZFcpsL/n8IZLNmxpCp0ynFatETxLlF/YO7FwwBO44ywqakOPvjpsssVsCxrrNd9VHcZ3ca4sdEbg5x7/UFveJJpzlcE+3OYplxTSkrt22qP2bG8OZ6EifmOHSQ/oPl0I8eqtngsGBlSScI1MMavOlaRxkDTBnlrXY1lRhUw5xwd5nx3a2eD9NIofTwBay4SjJbLkbhTXSeAu3OKwFO76U76bnkqCdKflAt2VYBm6UMQ1gKPKyFWzGz5bC6rS8gLML3oIv0F7WLk1/y82UOSIoL3V4w1dD/XnnEF56nV3MvTvw+oBB0xAWQPwQgXqv0pp2k6BcY4QW5Qvn1Tmwi8WGVrkItE9vm02nUsWh+fAq4pOZGPOlIMUSiKS24f+shaIYLJAmyHT5O3QIZ/6QiY3GAvlyGgG3htLsu3BP8pM61oXRgHw7njFUF1eyXenO6LOP5UyXQ=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(14060799003)(36860700016)(82310400026)(35042699022)(7416014)(376014)(23010399003)(11063799006)(56012099006)(10067099003)(22082099003)(18002099003)(4143699003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	XBUBjUrkRjw5NPzuCqTd1jGPyzhLOg4jg+KNMXJYHzBsXChrizCFSp/4hIZDhirOxsFzr/P9HKMMQnSScOiuIvrgEzw96cF4mKLr7XM7SBYkyr33RJ/DyKYc4dss8BWk+ly3x1C/OhurLXcHuFzM7fZWYyaJr/NDcwer8uzzdODab/rz5DhR0suxHwufBS3WGhxctV3O2nuo9yL+4AyrJxg+yXxaeSXaZEJTYHvx3BK3SBcxEF6uRHvmfXLfWpHDW1rKK0TmYx5eZNMZLnZeHxlssGsBKIxubSOpSBZ1j/Hh4tY28UAtGu5xAF7pHWE0fDz+otk5g9gdmzV2ufHDKa0y81qq2FJg+3OjPUThXMIO5kplRg7dashW6IXHz1oy2J5V+e6ZugK2SwoCDx96fHxlapQxQlgxg51bX0PrVYCQKcp9gd6PhMNVwIevCkU2
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2026 13:47:48.5548
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 45d622ff-62f2-4780-4429-08df1979413c
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM2PEPF00070CF5.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB8792
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7D84880008
X-Rspam-User: 
X-Stat-Signature: ppgadk7b8mqck8gx14sppxif86ybqbhc
X-HE-Tag: 1790171280-354742
X-HE-Meta: U2FsdGVkX1+/hx5sbQu0N/rtJL1BN7rkxTxf77EQMU4kgYzetsrGbwNddCUSzaCEJuuz+8AQhuk9Vugv2KqthJTMcW5kupC7kw9SswnyHgKsn7cXKFnuFnCiI8BwYDVUliRgnl2aDsRZ5Z85aUQ5AifKBbYnljJZ2yK6l6jkZ/+GYhxVF0oD/HoNr2uiCq85EIwqiIGBxYFOdRhWrUugmKIZWdLYzAfoWDsRaKtXY8HzePHjEQ/+fa11T4z1J17OsZP7a1ASJ+d3FeLNYtKfLMIB5CKOUhNBFhaBAc7+hmWTO6wnKCZ2I83eEMEQvzkX1o+ziD/2WvvNGOZEtJlR+DIyeuzTmZhGYHUaMULf7QYGc5QbMBJZG7gDMVBB3SXtJyTqipuA3iUht8SUrSQnXyXGsJ59k5+L5nmb7vgcn7eX3WplUPJ8TgZhv99cvRP7Cp996lJ6SKNfHkxpE4jemFwRiB18eSRtUu+P0RYOugCxqTxsVEoZr2vVLtycqytDkgzD1Q78Ly/hgLdsHsI+ZESKLGBQ2zktF95jk+PVgwWnTNV9jLm7RzCMLMcZ9itCRotYqLCF9Y3kjrRdlaqKaUPYPK9yN95YGz4uLtlsMnrIFpdzeuL2ui5AGpgbhPD4J3lG1F4rbhVCJyij0XpgsYaOJi8gp6wD0mJQDOpaRUQWFfMrKGb0QJGO62wAsBbtK9IKfsK9XfN01q6f6aYeM/dXcYoIp+GYAQWqrz8v6CDnenDff7/88RW2j19HuAAP3UhSKS740YyPj/tLOrxSVbC/sZGUEhV/IH1ypPIZWKkxXrlM0syqb4YZzXZNetYpK/YeYCiQLGVwIAOfXQtdTykjKzYxwwJfi0MSIrev2oQ1Zryak4iWLaAN10DUUyFyqRnB0evsuJAn1coVT2hqylvW8Ls9NnQ1JG5IRj7wor9NqLK6s7gjTQFor3lxmsFraP4NfCe2QKLkpgzbWwL
 +6DHvNrN
 DKoBZ01tzCgHMRwxgAkvd52x8wHRVCUN9W0/v/BRgxqyAtOjZKxUGJsT5FS0+spWBjPJGvXV7/NlQDRmDp5W4OwcBfHaScLy6Jw4GXFWnhKJA5JJuHJgC5lvD9IK6oHjKcz/9aImJjr14UA4UhgQxPFXSTRgH0HZgPGYqG4AUwa7XiTCMpE2brpkEC+dslTt5PvnRMixANXdsu6eHCxp6R1rwJED7P8P4U+XypekB8TKaAoMLesirjL3jqwR8WZZcPc4QLqSgPkInN4xyOdHHhGmRRnXP+RdIv+MV8b71uZwedLlNRLv8tWumZwwJVChQr5cMCMke9xu8Nw9OBmpyTFPDNqiqLyuQ3kvOHgVtSb3lXujERo9BpAiz6MRrMrBMof+uy/5t3oc3uXqohwzqFUmRZc4MNwI+QmXkIq3V+zSDM00DGgVh+pnoghddocck2MRgqApD+rKwFxcBeoUW1MD+wfeJQqx3gxT80gZHKw2m5p6rJgd2gT0yZRhA51tAXoIpdoJmK4CiBeWeDB+sDGmfpHpF7DxjwzsKJygsKrU2dZFx7VBwgknM0gVfEduu1zGJirlEzPtPkrb74ehf6GW1ZUcialhiTyP8Dh/a2HG8EZc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23/09/2026 1:25 pm, Alexander Gordeev wrote:
> On Thu, Sep 03, 2026 at 11:29:52AM +0100, Muhammad Usama Anjum wrote:
> 
> Hi Muhammad,
> 
>> I've the patches here [3] for arm64 conversion which I used to find
>> usages in generic code which I missed during development. These would be
>> sent separately.
>>
>> [1] https://lore.kernel.org/all/6110202c-057b-4701-8c04-1a76ee7bb9ab@arm.com/
>> [2] https://lore.kernel.org/all/a063f6c5-2785-4a9f-8079-25edb3e54cef@arm.com
>> [3] https://gitlab.arm.com/linux-arm/linux-us/-/commits/pte0_arm
> 
> I checked [3] with s390 and also against our lazy mmu implementation and it
> looks okay.
> 
> However, is there a particular reason this series is against mm-new?
> Should it be against the master, it would be easier for me to try it in our CI.

I think, mm-new is the branch in which this series would be picked up. This is
why its based on that. Are you referring to mm/master?

-- 
Thanks,
Usama

