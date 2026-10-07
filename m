Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 023CDCA5FFC
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 18:58:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D65C26B0092; Wed,  7 Oct 2026 14:58:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D16346B0093; Wed,  7 Oct 2026 14:58:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB65C6B0095; Wed,  7 Oct 2026 14:58:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8F3276B0092
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 14:58:23 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1A3AE80356
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 18:58:23 +0000 (UTC)
X-FDA: 85296740886.08.1850534
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010015.outbound.protection.outlook.com [52.101.201.15])
	by imf26.hostedemail.com (Postfix) with ESMTP id 23C7B140010
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 18:58:19 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=oAOhUaJw;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of joelagnelf@nvidia.com designates 52.101.201.15 as permitted sender) smtp.mailfrom=joelagnelf@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791399500;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UNTBad831l2/inXBznQ/GDVm005QmSgHz3Tz5Ypc0nM=;
	b=bkDiNVvBOXUog4ognV1hPH1jkYGKS5UFYsCZuO5SwokACXUzVzDebs+g+dX2IpIWllX/kM
	98uegW1GKePtTauQx3ijbAJ5PzUEJm+xCjvdhymnOEyzHRPV/l8/xis5G50aHFIb2VVFLC
	7daKNsVeDuZFzIw73kjVAYZvgJP5ipM=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=oAOhUaJw;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of joelagnelf@nvidia.com designates 52.101.201.15 as permitted sender) smtp.mailfrom=joelagnelf@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791399500;
	b=vPxREVPgoz/C01NJRdfLCM6ZG++XanerM064k9k7DMvBbmTNhVOpoLVj5Pe6z1vUal/bic
	S0pWgvId4EwUyfknyW/SR8X6o0ANAxPES+7KyyJFx2u3AdSIpZEQ0o6+dL268vV6Sa4AyP
	eesq7cejHSxHDkUvv/0CQd+X0gF3hdw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=diZe8xMi+e34p5RL6niL23UveGkQrUEYa26x3TOMPCmP4ozgYk/E28DKDbTPinLvi83fJYpzcj+TAJ7GgwlcWecFxaqkE5a8C30QEChebjluqbY+mSh0KUpM8R6wQTLtiiUo1VRFg62/0uY7XFiYNlx+N/ZyGFiUPieuSN3tjrC6NOmF+dM/sqTXg5O3jTZFAjKYm5+trirsg4PNmodkYGtHpaBS2YpuMsFfr+Ol0jlxeutWPe2v1dcPbg3C5i5DpGLN+2/zWx3ESP2b3wniQZGZ8XCv88epqjSHTwh5ia7lCDht7cQKV97rSBAhQGWsQLxwoee9Se6yVBDfso9rbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UNTBad831l2/inXBznQ/GDVm005QmSgHz3Tz5Ypc0nM=;
 b=yexhBcshC0G8/zr0FjJ71emRCWXHUbnJYW/cGvwBrBScvvHrZ9YTwf2O/5KJgz4TyONrmSZJsyqrf80W6Xx1AJUaQw2VZwMcc7i2mN+cljCKLN1gYEIDLKcvqbwyN/joXkFHYKbsRR7ogXjgKeB9sEWFR8pvd+glvKrOfqU1lTTIPlCH55JX8Vegvfcep/k3A2NTP8CyTpM/z/IZ6CuS2p3yMlANCvD5DZk2omE4Pl5ke4LrhStFNG+v3KxL85/QKZ3qJvRTInAtozUi2KOuImmdsdRxSLqWLisPWxWk2nF3S48IrH2xTG0iqpKfbyTkGqa6JSSQtiCqL7fNcku18g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UNTBad831l2/inXBznQ/GDVm005QmSgHz3Tz5Ypc0nM=;
 b=oAOhUaJwuoucyKU2DqH2tdp7FV8JBqCfJ8HRFB7m/0BPMSUiD88gFhXJsSMEetz5zkV76OIKlJUDxbN8XkI6QyF7rmeQx7OyB6uqBwcWb1SaEUwZiBAbXMVlbkSK5Gks7HH9yMPfnhut3hX0GUBonw5i6+X3qdBh56civHQUBa5dhimIaZUiMh8VC2OeUbeDm0JHHhcw0lMX+cejvSrD6Pb0GnjkS9aCAmczu6brxO4nogWbr+p80eWLiAV6FQbKYIZuNplAJXNjWRNIhoqpDbHt6LuCzpAZADXNUyd6NawYZBe8aufu2nXtMcw/YPvwyMX2xldFLT4s5Z7i72Mv5A==
Received: from DS0PR12MB6486.namprd12.prod.outlook.com (2603:10b6:8:c5::21) by
 SA1PR12MB8723.namprd12.prod.outlook.com (2603:10b6:806:385::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.16; Wed, 7 Oct
 2026 18:58:10 +0000
Received: from DS0PR12MB6486.namprd12.prod.outlook.com
 ([fe80::88a9:f314:c95f:8b33]) by DS0PR12MB6486.namprd12.prod.outlook.com
 ([fe80::88a9:f314:c95f:8b33%6]) with mapi id 15.21.0496.010; Wed, 7 Oct 2026
 18:58:09 +0000
Message-ID: <038a4b64-3f7d-47f7-9ba9-a962c265e0e8@nvidia.com>
Date: Wed, 7 Oct 2026 14:58:04 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 16/17] rcu: assert static storage for RCU sync and SRCU
 definitions
To: Yury Norov <ynorov@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Jason A. Donenfeld" <Jason@zx2c4.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Matthew Wilcox <willy@infradead.org>, Peter Zijlstra <peterz@infradead.org>,
 Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
 Boqun Feng <boqun@kernel.org>, Waiman Long <longman@redhat.com>,
 Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
 Christoph Lameter <cl@gentwo.org>, "Paul E. McKenney" <paulmck@kernel.org>,
 Frederic Weisbecker <frederic@kernel.org>,
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
 Josh Triplett <josh@joshtriplett.org>, Uladzislau Rezki <urezki@gmail.com>,
 Steven Rostedt <rostedt@goodmis.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>,
 =?UTF-8?Q?Onur_=C3=96zkan?= <work@onurozkan.dev>, Kees Cook
 <kees@kernel.org>, Joel Granados <joel.granados@kernel.org>,
 Anna-Maria Behnsen <anna-maria@linutronix.de>,
 Thomas Gleixner <tglx@kernel.org>, Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>, Ben Segall
 <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
 Valentin Schneider <vschneid@redhat.com>,
 K Prateek Nayak <kprateek.nayak@amd.com>, Mike Rapoport <rppt@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, "Michael S. Tsirkin" <mst@redhat.com>,
 Jason Wang <jasowangio@gmail.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
 =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Nathan Chancellor
 <nathan@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>,
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>,
 linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 wireguard@lists.zx2c4.com, netdev@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, rcu@vger.kernel.org,
 virtualization@lists.linux.dev, linux-rt-devel@lists.linux.dev,
 llvm@lists.linux.dev, Yury Norov <yury.norov@gmail.com>
References: <20260915030336.1192299-1-ynorov@nvidia.com>
 <20260915031334.1194975-11-ynorov@nvidia.com>
 <20261007184105.GA3837481@joelbox> <asaUECwON5PS98M8@yury>
Content-Language: en-US
From: Joel Fernandes <joelagnelf@nvidia.com>
In-Reply-To: <asaUECwON5PS98M8@yury>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BN8PR04CA0051.namprd04.prod.outlook.com
 (2603:10b6:408:d4::25) To DS0PR12MB6486.namprd12.prod.outlook.com
 (2603:10b6:8:c5::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6486:EE_|SA1PR12MB8723:EE_
X-MS-Office365-Filtering-Correlation-Id: cf668440-b0e8-43fb-bf25-08df24a4ee0f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|23010399003|10067099003|56012099006|3023799007|4143699003|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	421eAfrguhnyzMb5VnpgE8yWymDanFTnxgGUExLCMmwXuI4rTJlW8Px7jH1giYUmKNFdjnArWNOuIaorrI1YwaTWGPoHdDvXH5A4OAVEE0Hyzo3L4FKULLXFmd8BIpY52YJ27HFCJzg2zoWrvHkf8D/z3+cKkkSH8+UvOlEXOsuq55VuK2a0YXpGhu0x18CGPDn60HKnnYqsSqyLeQz0T0I0ntbL8BNiqaV82kPVAuaQRn5ajmZSdRKqPhBSqdXDpeNi2Q6zQ8Hvqw2lq2iQaBzH6OpceovjXrusQ8lNAJQfgNVxwlPciyrvgR1PaBFkuPqZd+MEuMIk/SrUL9n5+L5wPEU4gzeWji22KRVFjH6IzjGph8i7mszT0u+xk5ULaWyChK+xkTBIePPg+wttscAE/f5dCeJevwQG5zgQbQNJ+5BwvE56hKZbnCGC8/z/4BKpqUuVUoNao402zH8dyfAQ+Gh3A3ega/1DOOgqtSzmWUeM4XjovCcvmXA4bjfhRkyxhdnX8YRiCkg8Fwwx+HKtuAI7Tl4P/t1M23GyN17euY0lTBTuTC0zLg/mUEEMwo/F0PnQLkvg0DWLEeOSmg7A+vSRolCAr4VDk7dsoLHOwMdZVgvL+UPJB7Wc2/xeJrS9bxhwt5pt3pChueFIqYtK+dulAxdW3rPfzY8nzY8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6486.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(23010399003)(10067099003)(56012099006)(3023799007)(4143699003)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U21QRUt6UXA4QktJV2Y3a2Z6dTlDdDNRQkVQMER0bnB2YWwyWW9mdU13MVZx?=
 =?utf-8?B?anBNYWpHWlZpODVIaXp4S1Y4UGgrN0k0c2lzcUUyeHVWSXpjOFR3TWpvR3Bx?=
 =?utf-8?B?aERqYitFT0lyRi9NVStwcFlacytQNVA3QUpVVFl4NVFkV0oycTFoUnVOTFFW?=
 =?utf-8?B?bWxnb0VWRzc4VDJxdHpwK2hmREZlZWVaVTdsWnI1OUJCcVZLeGlPWEdGcmli?=
 =?utf-8?B?anZ2dmc1Y0U2eGE5eWNuMS9TeGU1YXYvM2EvS24wdkRoalNMQXNsa25KUEFF?=
 =?utf-8?B?ajJLK2JEdDQ4K0xyM0ozTHpaSTJ1ZE1OMHNEYlJzN2lEamk4UmtwU2xFYXRy?=
 =?utf-8?B?RkJkU3ZhZysyMHMzNTZoT1hmOTIxUUlVVlBHbHJ6am5VbTFQSCt6bGNxckFW?=
 =?utf-8?B?S01ENFlyV1N3bmx1a0pObEVPSHI3N2ZwOHp4emFpYWlJMmxxY3ltR2U0bFFi?=
 =?utf-8?B?clMrdFJsRHo4ZW96b2piek81TVFjQkw0bXI4ZzNrblpOeTlXRXZJWk4wVG5E?=
 =?utf-8?B?bGc0VkNCMlFBNW9uNzFGK0hMT0JHRWgzQlRxOGM2K3N4ZjkyaS9BTHorQ09y?=
 =?utf-8?B?WjNyZzRYcjBnNXVGQ2lyTEpERW5rZCszZjVjT1ZkZEV4emdZZlZuNlBFTjJW?=
 =?utf-8?B?QjBMY2NCK2oyTHJnV2l4ekZmL2w3VjcyYUZEVDJGSUNpQm11VDZnS3ZDSUNE?=
 =?utf-8?B?NStVdDFicVdJRHVlc2ZRbE1lVFBYb0YxaHFLWVgvT2orYkJVbjZEY05XSU9Y?=
 =?utf-8?B?UTcvQXA2R0ZoWEJkaHpDSnVWU1E3UldZQVErYjN5MDQ1Ykk1VllZVHN6RmlY?=
 =?utf-8?B?MDRvNndZSXRRZFUvSkJWZ1ZiMXhJMEhSckZKQkM4ZThxSUE3aExhMkNzTWM0?=
 =?utf-8?B?bS9mdStWR09XSDgwMi9CYWdnamhTK0FTZGdMc3ZUaFBzYVl5K3A2aHdzcG1k?=
 =?utf-8?B?SGZibCthTnU2SEd3blhPT3hSbUxXUVBLTmhmSU1ISFY2SkdmWmJOVXpPRXFk?=
 =?utf-8?B?Q1YvZllGS0FoYk80VXhWTm9yUUZWOFo5YWFhdXlOK3AzQ0Q3TmdWamw0ckFl?=
 =?utf-8?B?OXdiejVXMUV0TGJseGJXUDkrWVdIYlRjcVkxL3Q3NFFERGNzUEpiOU14Yk5P?=
 =?utf-8?B?OERPTm4xaGxGZDdld0M5ZnJvVExiNytzYWhkU1JHcnZwbmpkaEFVOUxSaHc5?=
 =?utf-8?B?UVdFNnVHa1R3UkxnN3p1RUNEam1EYmV4MzE3b3o1Y0tBcUVIQWtzY294ZnJQ?=
 =?utf-8?B?WmFmVmRiQ01aR3BOZHRIOVowQmxyVFlhVEUwZXpnYzZ1TWJWNGtOUUFqR1JU?=
 =?utf-8?B?cnJCU3QzM3ZvMU9TaWdrVmFKRmtvZDJtRTJ1U0YvS2VySUs4YWlFUE5lbWll?=
 =?utf-8?B?TkFJODEwNVg4M0lqekV6bHp4ajRSY3FEVFpidS9rM2trZEQxL0NnbVNtU3g1?=
 =?utf-8?B?b2ZUdno4dm5zbUdKUlk4aFlpcFhtUFBJaWlaeXF2eGI4YTAremJibTVTRk9n?=
 =?utf-8?B?a2c2cjJZdWNiYU5WMWpsY3UxZ3Q4L3A0L2lMMVhTd2YyZTUxWEgrL1FKcUR0?=
 =?utf-8?B?WjVqVE9BQi9JMlBRNHozZVF4R1NlMElFa09XS3laeE1DTjZONWI5Z0llTmJ5?=
 =?utf-8?B?K1RFaThOVmNWUmpGeU91SU5XNEpJUUQ2alZoMHRzQ2lkcmMycWFsaURZWFIy?=
 =?utf-8?B?VHh6c01tVGgzdm52WlllRGJTY2VTbG42K21lcHdPSFZaNmhDWXlnMkt4OEZl?=
 =?utf-8?B?dElBaFlOd0JRWXRwOWFyRGZsb1oxcm1IVWYvS1V3bVBmTDBlOFM1b2RaQmxD?=
 =?utf-8?B?KzRmelNNVGNuZ095NHpvYy9aSlcxUWJjdFpkSWNUek1LK000VkowU2s0OTBp?=
 =?utf-8?B?bDVOOUJUVGxIQVVIaUN2ZkVFdkJyVGlsNWtJSGZ5aWlyOElrVkFETnF6M0Zj?=
 =?utf-8?B?cldUT1p1ZXFMdThXdDdJOVdnUWl0amd2cVhPMjVBY3ZNRFlQRUR2Y2dXL3p6?=
 =?utf-8?B?TVhlbTlIQUpqNDdrZk8wNGh2Q05ubU1QM0swL0Jlc2lMR0pWZGpqQ1RCemhn?=
 =?utf-8?B?cUZHdDVyeHZRdit2Yll0eGcvcVFMRkFZci9FVWJ5UmxualNuYlJnclcxTWZz?=
 =?utf-8?B?Q29LZUxOMmVseXJYUTRvRGRhaCtVZzBMQUJhR2ZJVVRrRzg1KzJ4UmNlbTQ0?=
 =?utf-8?B?Z2RvaUVmQlkzZDdLMWMzSW5qTE54VmhMZ3BYR3hDbVlhOHFMYndsTk9jOEpW?=
 =?utf-8?B?ZktibUZoeXVKSm1pNVRHeGpMOE5mL0c2UUcySk1nKzl6TCtFN1N1dEorQVdR?=
 =?utf-8?B?SmVkUFYxbkRwSk43TFpMelp3M1A0eWxaWmZXYnJTOS81dWI2aXZWUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf668440-b0e8-43fb-bf25-08df24a4ee0f
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6486.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2026 18:58:09.8614
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pWeCOYfpw2qqy3ftpTMrz04yc6pmjptUYgQ/QNA12Fn2ybkYus4tgKDiPvUCa1kWIWsaP2xssmwjFW+gm8wsGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8723
X-Stat-Signature: azztd1ir3xtoq9tzjth14txsg3csumw7
X-Rspam-User: 
X-Rspamd-Queue-Id: 23C7B140010
X-Rspamd-Server: rspam08
X-HE-Tag: 1791399499-496436
X-HE-Meta: U2FsdGVkX1+yaKnEMmgECpCo7RKC7SMlA6yq74c8/jnBCINMY34wYJfejphUJ2qDBkzzpaAgSEGhMfGA8ei5fgp2mvHN9ghp2KEy+JuAMl/4q+/0VRctZC1AOSG7gyvX0Dp2uopZltILKy/8nIXOGOR7GQp494/jx45brBVeEONax5RQpqDeKjLrhtm3H9xCVAjBbZKcbCruR+3u9MuDeYgeiCRBGX4veVK9RHrxwfJiurRUtmP/5qP5wWqKq67RBgxXji+nI2vw1UbmXaIQ/j5eZ+v3Rp83sloPI4mDsuVzgj4mi5PxcFcLy1IdCgQI4wuAXU02ucvqnR/lzfCh7SbRpY/g5uucSuLcnE1h8QuwLwRH9ZNg6+dR99GyjWJO9ZvRtmVPqVNdXyisiynltOUKiROI/o3MuHr73ewVuv6YNg97OcmgADffbw1bgc1BPWAyqCxC/oT0wIORR9vSHWVy7pr8BKUKCBtBJKXNWdYiWZ6rW9NSyirYuVvyW6cU9Iu3RoOxvKR59GZExa8mqvkqiP3pHn94NF59wyR5JpVkRGlXgfbeFb+SiuLIFUwc8VEy/2oQzSjf6OjOTMAq7/BEharM30V8f/bQePZCXJ7fXhiMZE9cEJ1U5pS3Vpa1gXYjos2HA/jiNMxVvzOx1C76OqTr/1cfyHA9f79w9GLE+cOP2o020P1+IWDa1VCkIfB7OzkSYWt8n1Oh0l4NuA9G2zfHSymqXkTCWgbuvsf+gTmF21jnorUa1N/8ABUXr/uNazk0EwjUIpc3GF5gL0Gc+3yrRW9nIJi0fWJEjroPcROfAGkMRWxPgDocYGsAluXFBnHcSgfsrGHssxRT3VoNN83+yy6veLtERtgT/3DlCGVDGVWzxsd9mnPnKywaA5KZ8gkPCLF2Q8Dj9uX4Mc2xhp4yNtw04zbM1xYQ4sLgqLcslfDsACAV349q2E3Q8PMte9bb1ahoMIc7Mxv
 VqIUQJ2j
 A8bT+21TlgTMgSU+j7r0VA8bEgfrbTiyt2EFmSm9cQiXMER03eG/5jBoDDUaUsr5fIWcF2S5LaVBxGr9kjYQ1BPZ0tmSHP1U+XuYWbrCydZgK0td+PvnU2ct3/wefL5Y5Zn01oHFis8WMQJ8TDBh9Zwk4H8eIZbcVHqVbJubxlyNCF8a7DViQerfAKowwXhQqSEqFpS/adUpiSK4dlmtdcpLvjg2guLtFSphWEMo+6nMWaNfVK0X5ZT/tnZIZlpsLvxLUWsgblXgM1FTN69TA9uXGRw68MR4KTjxtbFBZcVLBV2nF87Jw7AW3p9cvDWRQqe71Jy1vyVPmleQJHyUgB6JMUXBLZJiY/a9G84tRByKsVEg/4caMwaeSQFqKD3PmxysdFA4uLB5ntWxbdhf9PTY2ccw1NTQBNJnX7cz0/XVz8PagAvZPohdKzUdl/Wivagu8x3OVhbfDS1B3LJ3jKUmK2SgLkQ8gkkJVltEt+uZB7xl0673r2HQxlUIVimjEEqRq5I3EbltnE0uerKw2PkkcMdKkMnSFMTeqkWe29JzYYUE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/7/2026 2:48 PM, Yury Norov wrote:
> On Wed, Oct 07, 2026 at 02:41:05PM -0400, Joel Fernandes wrote:
>> On Mon, Sep 14, 2026 at 11:13:31PM -0400, Yury Norov wrote:
>>> DEFINE_RCU_SYNC() contains a statically initialized wait queue. SRCU
>>> static definitions similarly rely on persistent lockdep keys and, in
>>> Tiny SRCU, a statically initialized work item.
>>>
>>> Add ASSERT_STATIC_STORAGE() to DEFINE_RCU_SYNC(), both Tree SRCU
>>> __DEFINE_SRCU() variants and Tiny SRCU's common DEFINE_SRCU() declaration.
>>> This covers the non-static FAST and FAST_UPDOWN wrappers too. Tiny SRCU's
>>> explicitly static declarations already enforce the required duration.
>>> The existing per-CPU restrictions on Tree SRCU declarations still apply.
>>>
>>> Assisted-by: OpenAI Codex
>>> Signed-off-by: Yury Norov <ynorov@nvidia.com>
>>
>> All the changes make sense to me. I'm ok with carrying this for -rcu 7.5
>> unless you want to take it.
>>
>> Reviewed-by: Joel Fernandes <joelagnelf@nvidia.com>
> 
> Thanks Joel, carrying it with the RCU branch is the preferred route IMO.
Ok, applying this patch for -rcu 7.5, thanks!

thanks,

Joel Fernandes


