Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AED5C2A06C
	for <linux-mm@archiver.kernel.org>; Sun,  4 Jan 2026 09:16:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7000D6B0092; Sun,  4 Jan 2026 04:16:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AD4D6B0093; Sun,  4 Jan 2026 04:16:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 558176B0095; Sun,  4 Jan 2026 04:16:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3BD686B0092
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 04:16:39 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C7E248C048
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 09:16:38 +0000 (UTC)
X-FDA: 84293726076.15.D814AE8
Received: from SEYPR02CU001.outbound.protection.outlook.com (mail-koreacentralazon11013054.outbound.protection.outlook.com [40.107.44.54])
	by imf09.hostedemail.com (Postfix) with ESMTP id 66545140008
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 09:16:35 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=oppo.com header.s=selector1 header.b="i/xtglaC";
	spf=pass (imf09.hostedemail.com: domain of liyangouwen1@oppo.com designates 40.107.44.54 as permitted sender) smtp.mailfrom=liyangouwen1@oppo.com;
	dmarc=pass (policy=quarantine) header.from=oppo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767518196; a=rsa-sha256;
	cv=pass;
	b=y/rh2kpoecF3R1o8tpoyAyGV8NW4OT15btfrPlxQGLDXbtGj5NxTb2ojFiwLD9AkcccHIk
	8DL7IrpsC3pmdgxXdHH8mi8M5s6o19UjC3sN67MxPP/+8xkf3HmBhBP2+UR0pmsoXIOb7c
	VfW2rPSPQlHhfFVbVTddgsFEkf8X7ts=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=oppo.com header.s=selector1 header.b="i/xtglaC";
	spf=pass (imf09.hostedemail.com: domain of liyangouwen1@oppo.com designates 40.107.44.54 as permitted sender) smtp.mailfrom=liyangouwen1@oppo.com;
	dmarc=pass (policy=quarantine) header.from=oppo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767518196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bd2hP7g0MLB+jrCZYuLukNqlFg27+ytVf09bT/UkgTQ=;
	b=r2pU3Hx1YAzfmWwNf2z0CfNGR29Iiqp5GOe1lhIh5O8O0SnkQvpbD43jpnlD5gekEtd0ge
	ppk62iI5IT/bW7WNLNw8+mIUzpYNFknLBSvbpYQEAPmNPqlcUl1em0FxyVwhvLvYDw8UQY
	SqHNnuhiY+aQ7t7RwmRiaJ4lyToFAbk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZulyimKTA9+gbg7ZUsldrUASy6mrqOv5qqg35iRTXzxp2Ext+FUjEiSwgjKlE8Qar5M+oqNIrohEORnTgPqr4IFkdfm/Rq6xe6ECQW7RVnvOOo1wsKqK9RihhUab1by3Mhp8U0beonYo2RSpVyHpUlvKdS/kLTmuDUS3dxgQsB9E/1ZRlyz/90c+7AXOt/TJ7pMHikgqXWng0dV91O2ytyx0uxjhv7DKlvE0ZpoV+36mALxwH3IpIjQJMDGjbuaBeGY15youW2Ulr/T69ClS6DSeBzRhORePwsFpu/+ALAQHIdxR0FfJjJdfhleIb7hT3lgYi7CdEK0tTVqtfuRnsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bd2hP7g0MLB+jrCZYuLukNqlFg27+ytVf09bT/UkgTQ=;
 b=Qse54X0WgXZPzxJ89sf2rgU0LflEgpKPJYT5f9OzqJgmvh2o8xP4z+RQHYAOxJCb1uGU8etR2scpKaCaUYWUdwUOH1vMoyDrZFjwDc+K+LpHB/+29Cbso9XMNCEuKLOYBqilo1SFQpjzStA54essH7ohYKoptBurFt9EIbbON24EsiWRFA/LMxUyV0NjOYOxuhfd1FkO6qYZ0skriWV7erIJyBZqoWF8rFuoTwQs11ikfsNWBeU8+YfGVn/93BcQu96i/ZC7Xsar4+q3es6ID5K/a7fyuyuXbeho8HqpuiyCXxiSJebaUgnasTH9FP5YltFRLmVlKsR+wEZrb8J9YQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oppo.com; dmarc=pass action=none header.from=oppo.com;
 dkim=pass header.d=oppo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oppo.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bd2hP7g0MLB+jrCZYuLukNqlFg27+ytVf09bT/UkgTQ=;
 b=i/xtglaCtF9+WCd2js0LnbANCxmrB4h657GWSnxYo147D7/myTtPlT5VIc4uMi8Z4w0X277igHVyW30+d/7weSCu0yhACctqceSkRVp078+UXuZLty9j3KwG4S8zsF+1ICT3ih6/PPCCyTCSHKnw36MNwUVE1Yw2cUsYLv3SaJA=
Received: from KL1PR02MB7739.apcprd02.prod.outlook.com (2603:1096:820:133::9)
 by SI2PR02MB6037.apcprd02.prod.outlook.com (2603:1096:4:1fc::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Sun, 4 Jan
 2026 09:16:28 +0000
Received: from KL1PR02MB7739.apcprd02.prod.outlook.com
 ([fe80::c7b0:3b4:9c16:78f]) by KL1PR02MB7739.apcprd02.prod.outlook.com
 ([fe80::c7b0:3b4:9c16:78f%7]) with mapi id 15.20.9478.004; Sun, 4 Jan 2026
 09:16:28 +0000
Message-ID: <cccf352a-1a68-430d-83fa-a14bb5e37464@oppo.com>
Date: Sun, 4 Jan 2026 17:16:24 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/2] mm: continue using per-VMA lock when retrying
 page faults after I/O
To: Barry Song <21cnbao@gmail.com>, akpm@linux-foundation.org,
 linux-mm@kvack.org
Cc: Barry Song <v-songbaohua@oppo.com>, Russell King <linux@armlinux.org.uk>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, Andy Lutomirski
 <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, x86@kernel.org,
 "H . Peter Anvin" <hpa@zytor.com>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Matthew Wilcox <willy@infradead.org>, Pedro Falcato <pfalcato@suse.de>,
 Jarkko Sakkinen <jarkko@kernel.org>, Oscar Salvador <osalvador@suse.de>,
 Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
 Mark Rutland <mark.rutland@arm.com>,
 Ada Couprie Diaz <ada.coupriediaz@arm.com>,
 Robin Murphy <robin.murphy@arm.com>,
 =?UTF-8?Q?Kristina_Mart=C5=A1enko?= <kristina.martsenko@arm.com>,
 Kevin Brodsky <kevin.brodsky@arm.com>, Yeoreum Yun <yeoreum.yun@arm.com>,
 Wentao Guan <guanwentao@uniontech.com>,
 Thorsten Blum <thorsten.blum@linux.dev>, Steven Rostedt
 <rostedt@goodmis.org>, Yunhui Cui <cuiyunhui@bytedance.com>,
 Nam Cao <namcao@linutronix.de>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 loongarch@lists.linux.dev, linuxppc-dev@lists.ozlabs.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20251127011438.6918-1-21cnbao@gmail.com>
From: Oven Liyang <liyangouwen1@oppo.com>
In-Reply-To: <20251127011438.6918-1-21cnbao@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR01CA0024.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::20) To KL1PR02MB7739.apcprd02.prod.outlook.com
 (2603:1096:820:133::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KL1PR02MB7739:EE_|SI2PR02MB6037:EE_
X-MS-Office365-Filtering-Correlation-Id: 70212a75-9cf2-499b-1b51-08de4b71f12a
X-LD-Processed: f1905eb1-c353-41c5-9516-62b4a54b5ee6,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?K0UrTlNpNEN4NVNUM2x5SDFOZGRwbm5Zc2RHanJMT3JFdDZiTlE2WjA1dlA4?=
 =?utf-8?B?a3BhQis5b3dtdXp3aDlHdjQyaitPcGQ0cXhSWkVzaEx3NjZBTHQ0YlNmZlkw?=
 =?utf-8?B?MjBNMVhyYTRHaXdoRytUNUNzVjQvTFZzU3pYREdiakltRCtOOUFrZnl6eity?=
 =?utf-8?B?RVV3cTBaOHIyMzUrU010dzJwMkVoYW1oUWprMXVvQ3U3UWh3cnZxOHV4bm04?=
 =?utf-8?B?dDRQd3czZ2hER09zQ2RLcmtkNUlFdE5GOWNDVGRwOGRBaU9SL2kzYXpBVTgv?=
 =?utf-8?B?YjN2VXY5dDVRVWozRlh4dWN5NS9uZm9QMDVkSmNoMFJZeVhpZ0o1UVdLUnNj?=
 =?utf-8?B?aDZaRHRzS3pBTVJOMldnaXRTKzFUdW1oRERUWWNMenVwNjlxL0N6OW9VMjRH?=
 =?utf-8?B?LzlMa0d1NFgrRlBDNlRpa0I4OHpwYmRXb2tHUm9seFU5SjBkQnMrQURpK0Zq?=
 =?utf-8?B?OGVMRHEzVGhKR1ZPTTNKUGRzcVFrQ1BIRURZK0J0T1RKU0dqOHN1aXVKZDRE?=
 =?utf-8?B?ZUs1M3dlS3FJYlpBaXpoU1p5d2RqV2JhaCtDK245ekVyVjVwZjhPYUsra2Rz?=
 =?utf-8?B?cGxKRHhsb1R3WUJOcmFrZlNxWW5RTy9mVkNNenMwWUpTMHQrdXBFRERzVmJH?=
 =?utf-8?B?aVp0WDVLK2k3Um5aQVZSQTJMNC9lNEFNRTdhSmJtNUNTR3FSYWVxM3RIQ1po?=
 =?utf-8?B?U1FvWHpjSXB1aFpBYUVnNWQwZjZvYm5oMXl2RmNybms0TUxBbVpwbFY5WXI0?=
 =?utf-8?B?TTRUY2JLVGFmeVR4WEFQcmgvc3FTek42MU9MUUNsOVk5aXlTTzBZQUJQN0V2?=
 =?utf-8?B?dVkxOTcxeTJYRjZkK3kydHJLZThYbndoZFZpOGhlNHVrZURQZkVwcmFnT2l0?=
 =?utf-8?B?amFzd25OVnRMS2tmTXRvbUVJbE1RdzZzVVh4R0pnU3kybityU3loRHp1Z1VM?=
 =?utf-8?B?OEs3WENsRHQ3b2xDaERtVVl0KzdRaWtXVTJ4VllsVG1GclM2OEg0N1NaN1pX?=
 =?utf-8?B?bklKSGEzWUdqLzlaY0N1VUxITE9oOWxGZ0NMWFlWN2JkYk8zVnVlWnNiakov?=
 =?utf-8?B?YzlKUzFqSlo1ZTUrbTlkdXJOQ1E1V0k3L2NKRGFFMjk2YkxuRUFySlo5NzM1?=
 =?utf-8?B?MEdmcngyOVFFTHZpK0NVcnJPd2JnUG5wbnJqY1IyZEI1cFlERmM1VkJnUTBG?=
 =?utf-8?B?ZUlGVDlraWZTTUp3Y0VJcFhzMGRFSnJrU1hHZ3NiNXkxRVpGanNuWCtjcWc2?=
 =?utf-8?B?aUw1alRMTWZJMnhkUHRCU21rdTI3bjA4MjBQemhLcko1L1VrUWs0ZmUvb1Z4?=
 =?utf-8?B?K29NU20ycXloM0VsN1BLaHFJMEpLeWVnT3ZFWElkeFcxYXI3djhSVndPeGRk?=
 =?utf-8?B?VVh0eElZWVNhdjhicDJXWi9LalNxajRReTdmK1FCRlNSbTJZSkl4OHBvWHd2?=
 =?utf-8?B?VGJJTDI3T213UTRHa1NDUkZ2MDBrMmtCN0g1b2VoY3Rqa21EVFB1SkYzRkNI?=
 =?utf-8?B?R0IxVmZqNXFZZzNlY0NKRVhOR0NLQTBuaVQ4WFltdjRzZTJiUEhtczJEcDVP?=
 =?utf-8?B?NXc1YkdlZmdKQzZXN2Rlb2tWUzFpcE5PbStPeGVmdlI4d1ZsT3BsY1RvMko2?=
 =?utf-8?B?YVA4Qm9XWXlrbUI4cU5YVnlzaGFkcGUxeEsvN0tyOTQ4MWI3RE1LWDlEUnh6?=
 =?utf-8?B?WjBJT0k3S1o0MncyN2F5WENuWkpkUTVlYWEwUVVoQlJNNVpWazZic1BWMHox?=
 =?utf-8?B?Yy9Rc200QjBXMEIvZjAxams2Y2tJTUdLb051N0pHQ1JoVmpqTGx0R0s4WGRM?=
 =?utf-8?B?MXJwVU9Oc0M0aHhKUUl2TG5PRHB6ZDZtblRXcFhWUnAxWTVOSjBlOWRaeTlD?=
 =?utf-8?B?T3ByeGNhVUdJZHlWQlhhcWtxQTArUnJ6bU5wV2ZQRmxIRWN4MGF6S0tDUUpQ?=
 =?utf-8?Q?Hw02SOU7+wZB6F39ZaZZZDfsMjjPE4TJ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR02MB7739.apcprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VFJSbXNIdE0xUGdGMVVubnhYTldKTmNWK0ZaT1NucW0wTlU0TzhCRGpaS2pn?=
 =?utf-8?B?UmlYYkIzVVg5RUxtWVFIRnJCNC84NTI5T2dMc1ZLdmlobnoxUDFkMnVHbHg5?=
 =?utf-8?B?TlU2U0xIdXRDbmplWVFYbVV3d3gzN2FxN0dzWFBJbW11Tk9xUUh2cnFqWGpY?=
 =?utf-8?B?NzBGa3NndzM0M2EvaFFVNk5qYXVhTmVRTUZHK29rMnZSMXJ5OFhwSnpPUU02?=
 =?utf-8?B?MmF2L280NGhzWkIyQlk2K1lXbGhadUw2OGJDT0Y4cXdqVWQ5U3VCVmp4aU5z?=
 =?utf-8?B?VzV1QVN1ZlhoSWExaDdwclp6aGhPLzhoYUs3K2xMQkVYVUZHU2lJd0JiRXhn?=
 =?utf-8?B?bFRROTRzUWF3ejRuTFd1MDZseXRlRy9LYTBPSUFjTnpJNnhicFR5QmROM1Rp?=
 =?utf-8?B?WFJGK0RMWGxKQS8xUGN3TklrbVhlQVI1elExK3pBVXJZaGF3NlI1SlRDN0Zs?=
 =?utf-8?B?emRtZWNjdXlHOHhzc0lIczFzYnVyeklTdWpxK0NyVTh3b1hCZTBaa2ZuSWls?=
 =?utf-8?B?by93V0pjSlRMVGJiV2ZwaFRqemM1aitueXNPSllpVE9Db0FRaVAvN1ltVTNG?=
 =?utf-8?B?dmRDdHUvZ1g5T3R4NEZ5dlMxQjFFTUs1MmZ1eUlaVlhKdEZVWHZRU2ZaS294?=
 =?utf-8?B?d3B6cDZQNng5MGJZWEQ2bmNUTXFpaXRPNlc2a2tSRElXZE9oa1RMWUEwUGNu?=
 =?utf-8?B?VUx2V01HSmxvc2Y3R1ZoZWJMTi9EMjVMdC9JZnFDR1crMDY3ZkVqVW1zZ1Fn?=
 =?utf-8?B?TDltdUNKUXdDaFJQWW0wV2F6M2NOTHQrYkpMbExGQVpuRUN4dndkbXd5YW5x?=
 =?utf-8?B?MW5PdXRGT1FZbjA0VDlpdW1wUzV2elU1R1Z3Zlg5VmwvUTh2dVptUGhEOUpZ?=
 =?utf-8?B?MFdPYmRoSGxMNjZ2YlVQQjB6dFJvOEdUeU5XckZIclJUR3IzNmxrMm96STJH?=
 =?utf-8?B?bm0xdWhQQXBYdlZxU1JWSlNHL09qQjVJSUV0RUN5dktIK2ljNFlsNHpXTzln?=
 =?utf-8?B?bThSOS84UGppejg5QmZBOS9DSjU4VmltTlhEMUk2dGFKUTA1UHFsb3NKS0NS?=
 =?utf-8?B?Skt0THc4WnVDUy9SV1ZaRFdQaWlrNmlxWWExK3NFVC94QWVhdUVaZ01hT1Qx?=
 =?utf-8?B?Z3hBQjUyL0xOZGN6SW5NaHJJSWdNVjFkT0J6c0hWVTZOcnpJK0VSUmY2NWNQ?=
 =?utf-8?B?U0phVTUxT2lPKzRDb3FKcHJWWG9RMytBRGlUMDhOSElWNW0zcGhQakdwamlM?=
 =?utf-8?B?VlE0bmZ6QmhvZk1PaUFiM2RPSW9raTZ4OHNsOWtpWmJoeDM0SnFvcTBiSkxs?=
 =?utf-8?B?ZjJYaHdBOCs4d2ZmTnFyR3pQUjdNU204RlpqS2JGSWJVTjlGdlVTMjVyd0pI?=
 =?utf-8?B?MC9BYkl2V25FZzBTdThjcXNQL1dONFg2YTBhRjZtOXlwNm9CTzhWUTBjS1RJ?=
 =?utf-8?B?RUdCSTBFZ1I2bkFTblptYWZaY0JrSlRqUmk5RHUra2dqMDY2YnRpaTN5eVFs?=
 =?utf-8?B?U1ZjZEZ6aURubXpmNkU1YkVPcFpiVUt4Q3VsUGJ4NTRsa0hPYUtaU2NJeHpF?=
 =?utf-8?B?NXpKcHZMK0VQc2M3OU9IcmgvNGttb0RBTWh4aGI4QS9LcmdESGh6VUU4ZXd3?=
 =?utf-8?B?RSt2alVMcGZscUtCalJJa1dvL0VybEsybTJuV1BwZ0NwZER2N1BzaTM4STRE?=
 =?utf-8?B?RDRvWi9EVlRidGxvRkphaGdSbmNBcnRTbmI4SVNXRTJ5c0M5ZG40cCt5T0E5?=
 =?utf-8?B?dUJpZk5YSE1TVTdnOVRiUGNaZGJqMlFKdUJTTTltWVQ3T2pqNkhVMjZrZmEr?=
 =?utf-8?B?WHVBQTJpdG9NMnRJU1hWWnI0Q3NrSGh3bmRVRE96N0JONlhoWE5GOHpTWE1u?=
 =?utf-8?B?TjJMQmlRN1dXWGExSHZxL3FQMFRpVENYb2dxdFJzV1hSbUphQ1VZNjBWRm1O?=
 =?utf-8?B?S25wUlhwOXcraG5lRjZsaGdqeWpKMlVYMktNL01Qbm5hbVFOR2J2ckY1MGJk?=
 =?utf-8?B?aExHMlNRclZ3OUhRK2lVbjM0OG1FKzhUcVRHVlo4b0RVTGphdllLWUpFYUF2?=
 =?utf-8?B?YnFsZTY4ayt4Ui9tWjhpaHBhL1ZERnZhRG5jNzhOU2RZSUpXSUVBZWtDNGp6?=
 =?utf-8?B?blpJQTFCNVpUeWN2TllpRlJadW9QWFJwUk9SRGw0c2xReE54YzdqeGhKME95?=
 =?utf-8?B?TURvYzh2MElKeUxGdWg5V0ZWYlRvcm5ENTNkT21KMGtzUXFEa1ExQWJMUFNk?=
 =?utf-8?B?V1VuZUFUdmViZW9GaitEc0NCZExmeTFLVVFCZEtMVHJNMDMwUWU2d2xNY1FK?=
 =?utf-8?B?SEVZa2p6YTVaMHI3K0ZsdHhVdWM3ejltM1BsaFRVaC9DZXphcVVPT3JHSGdJ?=
 =?utf-8?Q?ccKUP4tDkSxtShkQ=3D?=
X-OriginatorOrg: oppo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70212a75-9cf2-499b-1b51-08de4b71f12a
X-MS-Exchange-CrossTenant-AuthSource: KL1PR02MB7739.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2026 09:16:28.3654
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f1905eb1-c353-41c5-9516-62b4a54b5ee6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UFWbx3ZciZeM19tBv2pWlQYPCUur1U/nKfRVz8IhK7CB7RGngsnl7QSaI6YOrNZY7HFnV9N/FEB6Ms1eJEkYUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI2PR02MB6037
X-Rspam-User: 
X-Rspamd-Queue-Id: 66545140008
X-Rspamd-Server: rspam04
X-Stat-Signature: 4881x8jqrigrzw9noe9cfjsrrghhs8wb
X-HE-Tag: 1767518195-819442
X-HE-Meta: U2FsdGVkX18AeGdYTJwuMraWFUp3TGLkoULbq0dGdo29fxtX6edUpMZ/meC+REtmLHU/HjVJbP9vOT2VVYr2g9aWjgLiA20SBRigkZ/cuZgx6pX293kbyhbXw+Q9z9M7jvL9XjZRKfKLZtdqKk0t26iJh2LVp8dsm/ToAgUjzFSzMeI0Fuj1EAmotfKnca/FZ4wQW8gJKONBg0oPj6H1BaVBHEB6MwdIDAQ/KBsmYVH0TdZUq+DciaFJ31reRPfD1W085h/HUfmd9YPn5oMkFA48wyA7SbyDzUOMSRbI+ZgP+YqjtCdhEx7GAdUxUxo/32EMt5l3Qg35+izqi8WhXrL2jn4Vo/k9VnW8upfwnJ1JqkKKa+6UgLHFgcICVT/vWPaw5uOjXXDbjplV+xlnd0uUyz5/M6c9f+brmboRydp5T5uCnguIwbCiaJZe8XjCCtjNykNPmU72GHX8wufAMiPpYEA5s2JdGhnJUbkiaRbqKpXjDUcBIwK2LWAkaO5v4op3UHUApFfch8FcmG7JdqgxvGVMhz40kHSYBE9XDm3O1dodel4mYLG2RfzH//LPwuOlfxC7yOxGL93r29oH8bSi5yBm5nqOrywR4+Qp0QwdwDI/v/tKRKzEQcYPDBBqCQrnjgYiS5L1h4pasoTczuXNRUogWwlb9XJ9wINh2vo6o/roOQGHp9Gyp2mv4sLZQW2LvHlUwqSEER9xTD6MhbsILg+/0PH/EHZcOs97JNXxuUVQmZpoRLALDTPdz8NVeTUvXVj+SrC9H4H4d8beMhQDoLtzem6BW3ia1aSXlRYyJKPrpUqvzaAFJKwpC4qQ90bw4pZGubagwWkGxrr7BXbK0tZ1YlCUyvcoDE0E5oQ77nbsYzw7Smu3O9L2VsNiktc/ZoxG7iwESr38dJO5Z99TheEipXMYQH318Mm7mSVo8w+v+BbYjo36LFHnv7hKtFv+j4WXSrrVFvlJmZO
 tt7J2knz
 ZWAl/Fc8lZQDMlyg3tE0FsPhIbqCuqjIKsLelLTd3Kfq0Ve235gR0H00QeHlN5lzQQf1un9r0q3SzkOW2MNQuDiPxRdiKj/4VluCSX9E7Anztkg6QdU9BNlnjprNrMgVtnGT4j9JIw4v6fqD8uMNvx/7aALRkn7A1Qzy/2aAkyG66ZLt0JiCQGyBoTQyPBe8Bhnb88JBbgIQcUGJ6Vp0nHgRFAwXLGqRaE5pRNINsnin+w10t47YBF+i2WmWw/phOZCkSmVbI8KHRI2yBu+WrXFJ65sNGBaiREbMqgh57dTv8cm7rN8hf7/+aEv+JbTyjcNsKuD2z/vsAmi7/ecK1t/6lzcZNkGkKaua0EAQ1RWSTVeu3vR0ZB5wXwFHp6sJO+GcYJU0tT+yaH3cl9CQojm8PdRaelbi4YkTvtqurscRB1XN9hyrslkL5VGBJsKxxQoxBC406jpT0fDM3ZaVMKHpl5zF23cCrN8XBgLxb1lhXdryQOXqbGw7vgfrItQso/Ud7FhYVVfHmmRjs5ny7svAE7qaZmL7jNB6jvGkfZxmRn9C9GWC+jXq4onLVHJZQJMGfrzTfUpO1yvKRi/K3tQfvTnkK9beIIrUEKYQ1Ioz+I8MadTXZcmfzcujkkw/tGlJuwLpvTqVep5cEpFFGjxkHnNEu/0PLbEGGnW7H5+E03Ik5z/dIHQ8t+571d28vS6NvKHgkccLJMj83j6Hdtu7T8zl6PTB0G0JomI77V8w3yYtcvkRI2pBC/1ExV7Kq7i4fxXyy/aoGQwJhUldCnb2MqfyzsNpKNABY8H3L6U3nHG58iEGBlVakYw7uesDa2RCRwcHBbpD2eiyXea5ZJRxKXcuSrqMj+LDIY1btKlWjvWQ9liqbBpG91Sz64ZqjLOKgKCu/N86CD0ydaYhAnWLLfO21gwy9XYFQzIi+e+LHDO4za8YmFy7IigbB69zolOAYlm6wpkIAogsA4ai4ft6bVw2q
 MsoR02Z4
 McIFPfL9WMlxQJaI10SsxqFq8Yvr4VddZIP1dqA2uwZUWMweg4XqNY6NrMsPIORwJ5SN4Vr4vHa/4BYTfIjMTZOicQFNnPufbZjtQg6YTAXYBjuQYD50DKSs/m7lrvmMkQGp4CA/UGbHHGiAxmUL0B+9hctV8C52BLr8wJZgC8fe1bMhQdtS0JAt1RTOcrUn4RVpa+eIZ6C0j9SkeqPiJbr2rvAO32aDvn8dwa0YKGzadYilfrqNKNCZtjIB7sVx44kwqCtNluxLZfh1TQ/DEPTwRFvRYsr0HZEEMFZbm1nf4bfso+gFc7xkw9D9de5g
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/27/2025 9:14 AM, Barry Song wrote:
> 
> From: Barry Song <v-songbaohua@oppo.com>
> 
> Oven observed most mmap_lock contention and priority inversion
> come from page fault retries after waiting for I/O completion.
> Oven subsequently raised the following idea:
> 
> There is no need to always fall back to mmap_lock if the per-VMA
> lock was released only to wait for pagecache or swapcache to
> become ready.
> 
> In this case, the retry path can continue using the per-VMA lock.
> This is a big win: it greatly reduces mmap_lock acquisitions.
Here are some test data for the patches:

== Test Case ==

Douyin (Chinese version of TikTok) warm start on smart phone with 8GB RAM


== mmap_lock Acquisitions And Wait Time ==

Metric                    Before (Avg)    After (Avg)    Change
------------------------------------------------------------------------
Read Lock Count           20,010          5,719          -71.42%
Read Total Wait (us)      10,695,877     408,436        -96.18%
Read Avg Wait (us)        534.00         71.00           -86.70%
Write Lock Count          838             909            +8.47%
Write Total Wait (us)     501,293        97,633          -80.52%
Write Avg Wait (us)       598.00         107.00          -82.11%


== Read Lock Waiting Time Distribution of mmap_lock ==

Range (us)                 Before (Avg)    After (Avg)    Change
------------------------------------------------------------------------
[0, 1)                     9,927           4,286          -56.82%
[1, 10)                    9,179           1,327          -85.54%
[10, 100)                  191             88             -53.93%
[100, 1000)                57              6              -89.47%
[1000, 10000)              328             9              -97.26%
[10000, 100000)            328             6              -98.17%
[100000, 1000000)          0               0              N/A
[1000000, +)               0               0              N/A


== Write Lock Waiting Time Distribution of mmap_lock ==

Range (us)                 Before (Avg)    After (Avg)    Change
------------------------------------------------------------------------
[0, 1)                     250             300            +20.00%
[1, 10)                    483             556            +15.11%
[10, 100)                  52              41             -21.15%
[100, 1000)                12              5              -58.33%
[1000, 10000)              22              4              -81.82%
[10000, 100000)            16              1              -93.75%
[100000, 1000000)          0               0              N/A
[1000000, +)               0               0              N/A


After the optimization, the number of read lock acquisitions is 
significantly reduced, and both lock waiting time and tail latency are 
dramatically improved.

Thanks,
Oven
> 
> Oven Liyang (1):
>    mm/filemap: Retry fault by VMA lock if the lock was released for I/O
> 
> Barry Song (1):
>    mm/swapin: Retry swapin by VMA lock if the lock was released for I/O
> 
>   arch/arm/mm/fault.c       |  5 +++++
>   arch/arm64/mm/fault.c     |  5 +++++
>   arch/loongarch/mm/fault.c |  4 ++++
>   arch/powerpc/mm/fault.c   |  5 ++++-
>   arch/riscv/mm/fault.c     |  4 ++++
>   arch/s390/mm/fault.c      |  4 ++++
>   arch/x86/mm/fault.c       |  4 ++++
>   include/linux/mm_types.h  |  9 +++++----
>   mm/filemap.c              |  5 ++++-
>   mm/memory.c               | 10 ++++++++--
>   10 files changed, 47 insertions(+), 8 deletions(-)
> 
> Cc: Russell King <linux@armlinux.org.uk>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Huacai Chen <chenhuacai@kernel.org>
> Cc: WANG Xuerui <kernel@xen0n.name>
> Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Nicholas Piggin <npiggin@gmail.com>
> Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
> Cc: Paul Walmsley <pjw@kernel.org>
> Cc: Palmer Dabbelt <palmer@dabbelt.com>
> Cc: Albert Ou <aou@eecs.berkeley.edu>
> Cc: Alexandre Ghiti <alex@ghiti.fr>
> Cc: Alexander Gordeev <agordeev@linux.ibm.com>
> Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
> Cc: Heiko Carstens <hca@linux.ibm.com>
> Cc: Vasily Gorbik <gor@linux.ibm.com>
> Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
> Cc: Sven Schnelle <svens@linux.ibm.com>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Andy Lutomirski <luto@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: x86@kernel.org
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Pedro Falcato <pfalcato@suse.de>
> Cc: Jarkko Sakkinen <jarkko@kernel.org>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
> Cc: Oven Liyang <liyangouwen1@oppo.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Ada Couprie Diaz <ada.coupriediaz@arm.com>
> Cc: Robin Murphy <robin.murphy@arm.com>
> Cc: Kristina Martšenko <kristina.martsenko@arm.com>
> Cc: Kevin Brodsky <kevin.brodsky@arm.com>
> Cc: Yeoreum Yun <yeoreum.yun@arm.com>
> Cc: Wentao Guan <guanwentao@uniontech.com>
> Cc: Thorsten Blum <thorsten.blum@linux.dev>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Yunhui Cui <cuiyunhui@bytedance.com>
> Cc: Nam Cao <namcao@linutronix.de>
> Cc: Chris Li <chrisl@kernel.org>
> Cc: Kairui Song <kasong@tencent.com>
> Cc: Kemeng Shi <shikemeng@huaweicloud.com>
> Cc: Nhat Pham <nphamcs@gmail.com>
> Cc: Baoquan He <bhe@redhat.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Cc: loongarch@lists.linux.dev
> Cc: linuxppc-dev@lists.ozlabs.org
> Cc: linux-riscv@lists.infradead.org
> Cc: linux-s390@vger.kernel.org
> Cc: linux-mm@kvack.org
> Cc: linux-fsdevel@vger.kernel.org
> 
> --
> 2.39.3 (Apple Git-146)
> 


