Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35DA2606D814
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 02:45:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C87526B05B9; Mon,  2 Nov 2026 21:45:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3E596B05BA; Mon,  2 Nov 2026 21:45:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A66396B05BB; Mon,  2 Nov 2026 21:45:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7224B6B05B9
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 21:45:22 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 07D5CA7C36
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 02:45:22 +0000 (UTC)
X-FDA: 85392266484.02.240957F
Received: from LO0P265CU003.outbound.protection.outlook.com (mail-uksouthazon11022118.outbound.protection.outlook.com [52.101.96.118])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3B646120004
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 02:45:19 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	spf=pass (imf29.hostedemail.com: domain of atomlin@atomlin.com designates 52.101.96.118 as permitted sender) smtp.mailfrom=atomlin@atomlin.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793673919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nXmOhnYBKNaazB5unQgiYoowIg93Sa+PfFVBYw5Rq3k=;
	b=Or5py+QKuYi0qI9ec63ps0WnPoMphw8iAFKWichrmtfoYv8ooU5kKgBooMmX/soUt0v3iP
	pFzLQd3mG1uFldHgfmw7dmuuTj8HxCujn37uNFIeBEtnmfqt4JTKFprnK/mPe2vsqYPad8
	fr8u7WinwtzTsQheV6QAkasbaEH0fyQ=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=none;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of atomlin@atomlin.com designates 52.101.96.118 as permitted sender) smtp.mailfrom=atomlin@atomlin.com;
	dmarc=none
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793673919;
	b=8brZdoVbPhH3FUADwGJKrt8AcEf4HnKYW6wAA4sYQiDXDaiSXdIEtY7hSJZ/IVojDqS5qK
	+tjlKOZLRd6CdHojdIyNZrTmNUuVhXMPvJQbcNHeg7uPzPaYOuYAnMwIHajrZDRd8Nq4m+
	pfmMak3M6pYF6QnUGw1JTEwX1hK3Z+0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kaA7oUdKmyzWRBg4J11BqAA4G1s4DA1xbSz1pfc8G05C1xu08PUZy0QuZ5Ev+Zm4XZBDnglI7bpaXLKHiaomFj4h6ElHmwxE4oRx5edbEQEHdXYwNvW8otqZUHh8nmT7Ju7X+bLjoQbW8R4E77hlufo3YaZ+n0wejakSDtlveuPwwIE27o2/+Tnx297I7tHT5KuGjXiIH4u9ofLjucgsQ89ihEaaefnMcvaNWuKy+o3lrjPfHGq3Tw7bj3jAPLlS385fif4Ud+32yyY7AZZ7vZUOQRuTdNYzIJklYGUzwpZSmnwqFX4vHHWNRucXJQCz4Qf9z046+ZwSsWfdxTLR1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=nXmOhnYBKNaazB5unQgiYoowIg93Sa+PfFVBYw5Rq3k=;
 b=wR2S9tFL7/0+miKPR9vkJoHqiUjq7APmMKjVejOOrsfgYg9xuaAF7QrvD8CSz6SSpBJZN20NKT6mE1FfGCr53/SmPWZvx9jt4D1UELM/cjqk6yMUYQx+WJPz4pqiIRxFYgnugZn/96FHt8xgCtCuiCjUgPCqEI6WWdghxHwZbATcjyPjtM+4NQ5hQCciMA1tC19Q546xHYrolyLaZ6dR/BpvDJRq4mQZav1qXQJTrggLocTQueKLJ+tNnfeqmtg8JnCkzLBbPGIjcYpzPxZt5iK5EB5pUJtAJY5or6qChGZJbMC23Yc2qXyq694eGuNQ/yNLJUwNax8ucbt+AydzSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Received: from LO2P123MB4190.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:163::8)
 by LNXP123MB3740.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:134::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Tue, 3 Nov
 2026 02:45:15 +0000
Received: from LO2P123MB4190.GBRP123.PROD.OUTLOOK.COM
 ([fe80::f71f:a9f:c4de:687a]) by LO2P123MB4190.GBRP123.PROD.OUTLOOK.COM
 ([fe80::f71f:a9f:c4de:687a%5]) with mapi id 15.21.0569.011; Tue, 3 Nov 2026
 02:45:15 +0000
From: Aaron Tomlin <atomlin@atomlin.com>
To: pmladek@suse.com,
	john.ogness@linutronix.de,
	rostedt@goodmis.org,
	senozhatsky@chromium.org,
	mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	kprateek.nayak@amd.com,
	akpm@linux-foundation.org,
	baoquan.he@linux.dev,
	rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	ruirui.yang@linux.dev,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	kees@kernel.org,
	anna-maria@linutronix.de,
	frederic@kernel.org,
	tglx@kernel.org,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	bigeasy@linutronix.de,
	clrkwllms@kernel.org
Cc: linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	linux-rt-devel@lists.linux.dev
Subject: [RFC PATCH v2 5/5] panic, crash_core, sys_info: Introduce crash_kexec_in_memory_sys_info
Date: Mon,  2 Nov 2026 21:44:53 -0500
Message-ID: <20261103024453.922373-6-atomlin@atomlin.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261103024453.922373-1-atomlin@atomlin.com>
References: <20261103024453.922373-1-atomlin@atomlin.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN0PR04CA0117.namprd04.prod.outlook.com
 (2603:10b6:408:ec::32) To LO2P123MB4190.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:163::8)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LO2P123MB4190:EE_|LNXP123MB3740:EE_
X-MS-Office365-Filtering-Correlation-Id: e0e563c4-b2e8-4ddc-a33b-08df39547d6f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|7416014|376014|1800799024|6133799003|7136999003|10067099003|22082099003|261102123227099003|18002099003|3023799007|261102130727099003|921020|56012099006|5023799004|261026140227099003|261022105027099003|261021121427099003|261009221227099003|261021123027099003|261022115727099003|261022075727099003|261026121527099003|261009223027099003|261028144727099003|260925022911599003|260925021911599003|260925021311599003|261021135927099003;
X-Microsoft-Antispam-Message-Info:
	HbhmDDTxX98eTEHRzOKSv3exqH5klzjHIUSFabrMmiF5BOXvAgbkSWVQymBQe/CfCFbXUEUFLuw6O0MNIV22bHYeV0XdYgaRX7QTjJlVfYQCo8dLviEhw+b5F3KF2cKnzJLGIq65pr/J5GG+SRi9388tNFR6M/fTbOgT711iqIxn/0icgW+0pJstgOTyKOdifcrZNu5tGUNXLFpEgoTAVCh73MH0etX2GNcoPTRfZlZ1VwjkT63shwCGvU3NrBHi79hJ3o0Cn+/je3uUN4He4Sglybr6Q6fCnJUyxHNIzth4C+vsFeAOzV6XSBw1tzoDQUsD1LVwh3lT0tql7Ray2OExjYMTA7Nx1pWfqI6ly4lrjQiSRL7tmiMCqOmJMtNM5XdbF8SqY0tgv1/CdBmLlzzL3d7ickgwosDrCfQ/KQkliXEE9PjYFQzUmQL9RNWHwHT3JalEU1jl98uVVN5s7LuraSH0nMCKkPnM2oLfLSEb6RRGS7tZ+Pi2r8CaUbGecH/m3wF5N5dX6eAoZOe0jmLCXfxrPxzrZKpNeXe4WfV2ClLU+GqvK8BJP8My4ORFv6Xb2tPEuxGSuZ9LiR8UNgoRw1aBR/8VdrPvQBgqnsHURlYWMCSqLIp9PXQo5NHnHH05+vzngaWDRsV8WST2Nu5HIh/VCioN1ctDxZh4tLnab5RC980cI3SWrEvNiZtIa0X1TGq8d9FXeo8dBi1Qcg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LO2P123MB4190.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(7416014)(376014)(1800799024)(6133799003)(7136999003)(10067099003)(22082099003)(261102123227099003)(18002099003)(3023799007)(261102130727099003)(921020)(56012099006)(5023799004)(261026140227099003)(261022105027099003)(261021121427099003)(261009221227099003)(261021123027099003)(261022115727099003)(261022075727099003)(261026121527099003)(261009223027099003)(261028144727099003)(260925022911599003)(260925021911599003)(260925021311599003)(261021135927099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?iGS5srf4AyjiHLIZr50KR1H53iSrv5ePOjDW/5UyzzP2ruJeJhTI+JdCDoVV?=
 =?us-ascii?Q?N5RLtwI99jEk2Ufl/677ycfXgA1B5D4kvcY/0yBoRGpg7WjRNTobf8bhNJ8r?=
 =?us-ascii?Q?98zPhFpLd/5JS0XaSNv/L27p5Q2+d/5AlDf9OA9fM6ejKfBrjdRo85mLP7oS?=
 =?us-ascii?Q?wvY33iC4d0FXExiz6kQ3IhlmKrwzdsLS8Z0vwRYwweTfiKX3LR1tbGFWeQB1?=
 =?us-ascii?Q?UHgDXozRa2jD5YdjRQh9EbyGJ4GDG2qTFcTFshPRCDsp6eP3jx+hQ9nTLzAL?=
 =?us-ascii?Q?aHtwh2FdIGxKHhyntG4tsa0tue+Ro2UkeyP7HqP/uJnTgWQtrQSpMOkRsqai?=
 =?us-ascii?Q?AOVxD2VRAMbGR9LAkqx/xwIzZJPwprVyyxNWtSnotO+NUWvseyWffsS4NgFR?=
 =?us-ascii?Q?vQJIUjk41RKIBnXIPALFYtAs5hfD5MXQuCtQ0AD9mQDR94I3mM1YjRTUHflZ?=
 =?us-ascii?Q?dZLJI3PYv4nUvkFEGBDsijqq2LUhc0K10H6YLIIWnYaSW25QDvSThSayIgmx?=
 =?us-ascii?Q?wJzsJX7DanbFCkUYj3l0jjS6aQM9Zy4ChT754P5CKIpXLRPehM5GODTOsNFO?=
 =?us-ascii?Q?/zJUw6OR0t4MBgCJRfu6RLVsjedFSlqbcGsxkdSOWFvtzJUevJOjXHD1eNDE?=
 =?us-ascii?Q?QXTph4AwowVwbYWkx/nDkdHC/FMaqF6VerV/o9Nxm/3mUNEEc70MRnROZybv?=
 =?us-ascii?Q?tlbSW3S9UTBU6SoMAYHPeN3jxh3voMm3MXhaBI1BFhl2MwZ4Xdo0gmumskJd?=
 =?us-ascii?Q?q093cLc0jdHTQOTvlg1SmufwdCtKPkIKqFadJSlGrztiw3Faxz1uHAFDSd4R?=
 =?us-ascii?Q?CjGsl5xObsuhV16L2FH2t/P2WudKo0tUwo0pp73R0Ls0Sk0biV5U3JdYE0xB?=
 =?us-ascii?Q?iKy4Z8H/NTxaJ1Wu8HxIzBI6+IvoXsgBAC9ReivMNKt2VIj+3KdZaV/vMLB2?=
 =?us-ascii?Q?g5fOERmcoHFuPGN+xiM3CbpZHFaWZWVnBc4Z74cmS+s7kru2qx+6AbWVqwkL?=
 =?us-ascii?Q?ZsqVHImptUFbGa4wA1u04BYJmEF7hgHMTCajH+GJv23eHNcGAR4KPxPfUDYa?=
 =?us-ascii?Q?2QcvvIAM1/6HJ+05lxLCyQd54bxEXoH+wtGvscBu58iRHnjLpW+stWQlHsCg?=
 =?us-ascii?Q?49KkuqPqjvhBhQQsWRDJ5Yy5541REphVKvhojnGB8b/EzZIybU2B5/avslzX?=
 =?us-ascii?Q?iW7ncTVKC+JuowNNK5JN8CtxSclLIIWVdAqMIbhfJywq/7nGecO0FVivz7mQ?=
 =?us-ascii?Q?PjgQnmUbVGZv4hUjTtm2iF0Y2vHXCmAJ6kvff6CMPlBvbyOFKTAo5hlkGuuM?=
 =?us-ascii?Q?g29pfLE+SHVNm2k98jOOKOnLbDxVm+6t5ETYTuEfLwic3kvnyqwhS/RcNDRm?=
 =?us-ascii?Q?5kGdtbYofdbyPZd5fbS4yjNSQVnTns91dpdL1ti4kQvFNB+qs9TCjuTttGSU?=
 =?us-ascii?Q?seRwPZHSodpRO/5Ks59ge6TEdGzZnh6RJu1Vc1QZVmhwLUwXuexvYTBJ/KOO?=
 =?us-ascii?Q?mbH7pua7/1+p9AwGuiPDW1jfyjxtq7O3o4jEpmleHaWa/YpDT6RNnq7234DB?=
 =?us-ascii?Q?OkaoNIs6TXpEm6bGLTX6QCuk5LAmm4dRpnIkSuh8j9csvN6CAsGEAUupf8Mj?=
 =?us-ascii?Q?ktEzxahkUbEER6UEr2LOcoZRAxXcJvY49h3IJ+73SoYJ/sKKKg7tEKcS2bo5?=
 =?us-ascii?Q?u8PNOSKJV082QPF9ZGjcQ6gRagcjRl/I8SUXZif0jDIVBbBpkP7w5NIzesLL?=
 =?us-ascii?Q?ZMj+pxDGjg=3D=3D?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0e563c4-b2e8-4ddc-a33b-08df39547d6f
X-MS-Exchange-CrossTenant-AuthSource: LO2P123MB4190.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 02:45:15.6145
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LXEC6RzkhFS6DAmo93L69tkEU1t7L5sbpJbMyUqm3h3e+iri8pVYtMYiZznZV5XYVOWtxy8su4K1f2W3RtlOWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LNXP123MB3740
X-Stat-Signature: 1fjfjmtjco3akbekbqw1wz9f4rc58tyi
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 3B646120004
X-HE-Tag: 1793673919-905128
X-HE-Meta: U2FsdGVkX1/ce8OnGYde2LBQBlIZGB1pWqwuR8Ycw6LaqOtfx+7rrK+9Cx5/XH8bjmbdh4JtgDp6DFlGl21Y+sQ1bBZir13LnCvXJZ0Z1HrfZUrig4DwX+nduQw5Fr6sKAYQah/3F6u+/9aSrByDdeRFpo6jf0UJ6r7kXT7/Ul93z4EevtcRQBt5oXYVO8VSVgqeJaJNcrqqEf0aN3r5y/8X+D7NVYo9WxKpuxaQjPNCroiBCihmFhDjorowPUqx5B7LPpLpNUrv4s2VKb5RxpfjUBBDy7gENPFavi9PVpl37SO60MXUhHEYZqlhMlKyMmOeCv7E6NRZYk2bOVH2I3MNDHPOE265K86ksw760FTWR/Qv+3egd/RB6zMDHK3jbuP4GNo321zc899iejDnKoVmirr2mFR4hHNoX4Rnp39zSyzbXyIhxihX1F4hDmte6RseAoc/mNlhdA9DxX/CoVV3VtoAKa/zYfY828CFAMlpMQ1lEkGilmEdb3uOSb8jnOuFdt7WlavfoDVYlADBIq1wPXsRnmgxgW1HPfN3KB5feL6yU4ZYU2DcUnJICLDxNrEjXRxmDhy8FPONQMYyBGxqlVeiLzJzK5OmV84VfakSyt0+cwLR54hshwl5WzUbvvP/YZEz/ttczGB9dAw61PZeJWKh5jHqv37CH5JHQ9ISS8WPsUHNBqL0V8Kuo4k707XpilcToPn157AZ8W5ki2Gk733eicvlEivme5HFWwM35iKBdZuCOY0OtlxeVcKazAj9ZOMnlBfW8pwwdFf8gPaMNkdGxKcaxwhOUXh7MpJ9VYJKTl0xFaSGWSE85sJ76y8oaOi9tnQbhT4vkZ6H7YRA7phmnMS1xERaj6vtHn5DY0VrXjiL4n02VVpMYsnO00ZgCEG9Qf5BsstIPSqMnbetQ1OaXPyhMKkmGCJiD8U+rew8NVS2BjwwiWVEMvpVnI69tOBwiGW/KUZ446O
 lb1SpaO3
 mkaAkNuknXTkdPnRr1UPKFWD6ZXoCotXyS2M7Jhp5e+Pmw9ViRRnI60pfVWeuQhSg4LSgoJxZ1l/fSJJm0sHb06hqyLshWdKkur1a7/VzoLPkwWJ6difQuBk6d8x5vjxN+6+o9LXmRqSZ5ONlRgzvldBYxhjaYn7oXpARRnb/E+qS9MAWqhF94D3vzLSqwHuwPPCFG42WVCisFeh+yO3pYiQ7e1vDq872+jQQV0HEI/yhr1yk7EqYISGG/cxBPtAm0Ihu3Lmwl4ws3rsRY8c7f5PtkEx8tK0D/ktUF1WmRtrj17YdwyGbdUZr2RxU9z9Tl4pmXFXLDsPX6Hk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When investigating kernel panics, capturing post-mortem diagnostic
telemetry (e.g. memory zone metrics, lock states, active timers, and
blocked tasks) is vital for root-cause analysis.

While crash_kexec_post_notifiers allows executing panic notifiers and
sys_info() before jumping to the kdump kernel, it is frequently avoided
in production environments due to the risk of hardware watchdog timeouts
induced by synchronous console emission or fragile third-party panic
notifier callbacks. Furthermore, if dump target storage is exhausted and
saving the full vmcore fails, utilities such as makedumpfile still
extract vmcore-dmesg.txt first, making the in-memory printk ring buffer
the sole surviving diagnostic artefact.

Introduce the crash_kexec_in_memory_sys_info boot parameter:

    1.  In-memory pre-kdump collection in __crash_kexec()

        When crash_kexec_in_memory_sys_info is enabled and a crash image
        is loaded, __crash_kexec() invokes panic_in_memory_sys_info()
        after saving crash registers and vmcoreinfo and prior to
        machine_crash_shutdown(). This captures sys_info() directly into
        the printk ring buffer in RAM with local interrupts disabled,
        console flushing suppressed, and the ring buffer tail pinned at
        the start of the crash output (recorded in bust_spinlocks(),
        __report_bug(), oops_enter(), warning paths, and vpanic(), and
        cleared on non-fatal warning completion or task exit in
        make_task_dead()). Because some architectures enter
        make_task_dead() with unbalanced bust_spinlocks(1) calls while
        others balance them in die(), track per-task nesting in
        task_struct->in_oops (using a u8 packed into an existing
        alignment hole, as normal traps and page faults nest at most
        twice and even recursive faults inside die() only reach single
        digits before recursion guards or stack exhaustion halt the CPU)
        so make_task_dead() unwinds only the dying task's unclosed
        increments. Similarly, track __warn_printk() nesting and pin
        ownership in task_struct->in_warn_printk and
        task_struct->in_warn_pinned across the __WARN_FLAGS() trap.
        Suppression and tail freezing remain active across
        machine_crash_shutdown() and machine_kexec(), only being
        released if machine_kexec() fails and returns.

    2.  Execution sequence reordering and defaults

        Reorder __sys_info() so compact, high-signal subsystems (memory,
        locks, timers, and blocked tasks) are collected first, leaving
        high-volume dumps (all-CPU backtraces, full task lists, and
        ftrace) for last. Default to SYS_INFO_IN_MEMORY_DEFAULT when
        neither panic_print nor kernel.kernel_sys_info is configured,
        and avoid duplicate sys_info() execution if machine_kexec()
        fails and returns to vpanic().

Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
---
 .../admin-guide/kernel-parameters.txt         | 11 ++++
 include/linux/panic.h                         |  1 +
 include/linux/sched.h                         |  3 +
 include/linux/sys_info.h                      |  3 +
 kernel/crash_core.c                           |  6 ++
 kernel/exit.c                                 | 10 ++++
 kernel/fork.c                                 |  3 +
 kernel/panic.c                                | 56 ++++++++++++++++++-
 lib/bug.c                                     | 18 +++++-
 lib/bust_spinlocks.c                          | 22 +++++++-
 lib/sys_info.c                                | 20 +++----
 11 files changed, 139 insertions(+), 14 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 0b3c140babd9..f21ff4a9254f 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -1041,6 +1041,17 @@ Kernel parameters
 			Default is enabled if CONFIG_HOTPLUG_PARALLEL=y. Otherwise
 			the parameter has no effect.
 
+	crash_kexec_in_memory_sys_info
+			[KNL] Collect diagnostic system telemetry (memory,
+			locks, timers, blocked tasks) into the
+			printk ring buffer entirely in RAM before jumping to
+			the kdump kernel. Unlike crash_kexec_post_notifiers,
+			this option bypasses slow hardware console emission and
+			avoids running external panic notifiers. The printk ring
+			buffer tail is pinned at the start of the initial Oops
+			or panic message during collection to prevent telemetry
+			output from overwriting the primary crash context.
+
 	crash_kexec_post_notifiers
 			Only jump to kdump kernel after running the panic
 			notifiers and dumping kmsg. This option increases
diff --git a/include/linux/panic.h b/include/linux/panic.h
index 3b56f873f1e2..9e3362934967 100644
--- a/include/linux/panic.h
+++ b/include/linux/panic.h
@@ -58,6 +58,7 @@ bool panic_in_progress(void);
 bool panic_on_this_cpu(void);
 bool panic_on_other_cpu(void);
 void panic_trigger_all_cpu_backtrace(void);
+void panic_in_memory_sys_info(void);
 
 /*
  * Only to be used by arch init code. If the user over-wrote the default
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 1c93da75226e..fa7a57aa50f8 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1071,6 +1071,9 @@ struct task_struct {
 	unsigned                        in_thrashing:1;
 #endif
 	unsigned			in_nf_duplicate:1;
+	unsigned			in_warn_pinned:1;
+	u8				in_oops;
+	u8				in_warn_printk;
 #ifdef CONFIG_PREEMPT_RT
 	struct netdev_xmit		net_xmit;
 #endif
diff --git a/include/linux/sys_info.h b/include/linux/sys_info.h
index e7699b82aa49..8dfe8544a7f2 100644
--- a/include/linux/sys_info.h
+++ b/include/linux/sys_info.h
@@ -17,6 +17,9 @@
 #define SYS_INFO_ALL_BT			0x00000040
 #define SYS_INFO_BLOCKED_TASKS		0x00000080
 
+#define SYS_INFO_IN_MEMORY_DEFAULT	(SYS_INFO_MEM | SYS_INFO_LOCKS | \
+					 SYS_INFO_TIMERS | SYS_INFO_BLOCKED_TASKS)
+
 void sys_info(unsigned long si_mask);
 unsigned long sys_info_get_mask(unsigned long si_mask);
 unsigned long sys_info_parse_param(char *str);
diff --git a/kernel/crash_core.c b/kernel/crash_core.c
index d0bd2d0cf899..b3bcb2c9040a 100644
--- a/kernel/crash_core.c
+++ b/kernel/crash_core.c
@@ -140,9 +140,15 @@ void __noclone __crash_kexec(struct pt_regs *regs)
 
 			crash_setup_regs(&fixed_regs, regs);
 			crash_save_vmcoreinfo();
+			if (!crash_kexec_post_notifiers)
+				panic_in_memory_sys_info();
 			machine_crash_shutdown(&fixed_regs);
 			crash_cma_clear_pending_dma();
 			machine_kexec(kexec_crash_image);
+			if (!crash_kexec_post_notifiers) {
+				printk_freeze_tail(false);
+				printk_suppress_console_flush(false);
+			}
 		}
 		kexec_unlock();
 	}
diff --git a/kernel/exit.c b/kernel/exit.c
index d5e7bc2af804..efe3c4677123 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -71,6 +71,8 @@
 #include <linux/unwind_deferred.h>
 #include <linux/uaccess.h>
 #include <linux/pidfs.h>
+#include <linux/panic.h>
+#include <linux/printk.h>
 
 #include <uapi/linux/wait.h>
 
@@ -1069,6 +1071,14 @@ void __noreturn make_task_dead(int signr)
 	if (atomic_inc_return(&oops_count) >= limit && limit)
 		panic("Oopsed too often (kernel.oops_limit is %d)", limit);
 
+	while (tsk->in_oops)
+		bust_spinlocks(0);
+
+	if (!READ_ONCE(oops_in_progress) && !panic_in_progress() &&
+	    ((tsk->flags & PF_EXITING) || !is_global_init(tsk) ||
+	     atomic_read(&tsk->signal->live) > 1))
+		printk_clear_panic_start();
+
 	/*
 	 * We're taking recursive faults here in make_task_dead. Safest is to just
 	 * leave this task alone and wait for reboot.
diff --git a/kernel/fork.c b/kernel/fork.c
index 8b108ed37152..95df3001a390 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1009,6 +1009,9 @@ static struct task_struct *dup_task_struct(struct task_struct *orig, int node)
 #ifdef CONFIG_X86_BUS_LOCK_DETECT
 	tsk->reported_split_lock = 0;
 #endif
+	tsk->in_warn_pinned = 0;
+	tsk->in_oops = 0;
+	tsk->in_warn_printk = 0;
 
 #ifdef CONFIG_SCHED_MM_CID
 	tsk->mm_cid.cid = MM_CID_UNSET;
diff --git a/kernel/panic.c b/kernel/panic.c
index 4cb26914b2af..77e5ef137d15 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -62,6 +62,7 @@ static int pause_on_oops;
 static int pause_on_oops_flag;
 static DEFINE_SPINLOCK(pause_on_oops_lock);
 bool crash_kexec_post_notifiers;
+static bool crash_kexec_in_memory_sys_info;
 int panic_on_warn __read_mostly;
 unsigned long panic_on_taint;
 bool panic_on_taint_nousertaint = false;
@@ -71,6 +72,7 @@ static bool panic_console_replay;
 bool panic_triggering_all_cpu_backtrace;
 static bool panic_this_cpu_backtrace_printed;
 static bool panic_all_cpu_backtrace_printed;
+static bool panic_sys_info_dumped;
 
 int panic_timeout = CONFIG_PANIC_TIMEOUT;
 EXPORT_SYMBOL_GPL(panic_timeout);
@@ -573,6 +575,31 @@ void panic_trigger_all_cpu_backtrace(void)
 	panic_triggering_all_cpu_backtrace = false;
 }
 
+/**
+ * panic_in_memory_sys_info - collect sys_info() into the printk ring buffer
+ *
+ * When crash_kexec_in_memory_sys_info is enabled, record system telemetry
+ * purely into the in-memory printk ring buffer before booting the capture
+ * kernel, suppressing synchronous console emission and pinning the ring
+ * buffer tail at the start of the primary crash output.
+ */
+void panic_in_memory_sys_info(void)
+{
+	unsigned long si_mask;
+
+	if (!crash_kexec_in_memory_sys_info || panic_sys_info_dumped)
+		return;
+
+	panic_sys_info_dumped = true;
+	si_mask = sys_info_get_mask(panic_print) ? : SYS_INFO_IN_MEMORY_DEFAULT;
+
+	local_irq_disable();
+	/* Populate log_buf in RAM without stalling on slow consoles. */
+	printk_suppress_console_flush(true);
+	printk_freeze_tail(true);
+	sys_info(si_mask);
+}
+
 /*
  * Helper that triggers the NMI backtrace (if set in panic_print)
  * and then performs the secondary CPUs shutdown - we cannot have
@@ -670,6 +697,7 @@ void vpanic(const char *fmt, va_list args)
 	if (len && buf[len - 1] == '\n')
 		buf[len - 1] = '\0';
 
+	printk_mark_panic_start();
 	pr_emerg("Kernel panic - not syncing: %s\n", buf);
 	/*
 	 * Avoid nested stack-dumping if a panic occurs during oops processing
@@ -713,7 +741,8 @@ void vpanic(const char *fmt, va_list args)
 	 */
 	atomic_notifier_call_chain(&panic_notifier_list, 0, buf);
 
-	sys_info(panic_print);
+	if (!panic_sys_info_dumped)
+		sys_info(panic_print);
 
 	kmsg_dump_desc(KMSG_DUMP_PANIC, buf);
 
@@ -1067,6 +1096,8 @@ void oops_enter(void)
 	/* can't trust the integrity of the kernel anymore: */
 	debug_locks_off();
 	do_oops_enter_exit();
+	if (!panic_in_progress())
+		printk_mark_panic_start();
 
 	if (sysctl_oops_all_cpu_backtrace)
 		trigger_all_cpu_backtrace();
@@ -1097,10 +1128,16 @@ struct warn_args {
 void __warn(const char *file, int line, void *caller, unsigned taint,
 	    struct pt_regs *regs, struct warn_args *args)
 {
+	bool clear_panic_start = false;
+
 	nbcon_cpu_emergency_enter();
 
 	disable_trace_on_warning();
 
+	if (!READ_ONCE(oops_in_progress) && !panic_in_progress() &&
+	    printk_mark_panic_start())
+		clear_panic_start = true;
+
 	if (file) {
 		pr_warn("WARNING: %s:%d at %pS, CPU#%d: %s/%d\n",
 			file, line, caller,
@@ -1137,6 +1174,9 @@ void __warn(const char *file, int line, void *caller, unsigned taint,
 	/* Just a warning, don't kill lockdep. */
 	add_taint(taint, LOCKDEP_STILL_OK);
 
+	if (clear_panic_start && !READ_ONCE(oops_in_progress) && !panic_in_progress())
+		printk_clear_panic_start();
+
 	nbcon_cpu_emergency_exit();
 }
 
@@ -1146,6 +1186,7 @@ void warn_slowpath_fmt(const char *file, int line, unsigned taint,
 		       const char *fmt, ...)
 {
 	bool rcu = warn_rcu_enter();
+	bool clear_panic_start = false;
 	struct warn_args args;
 
 	if (kunit_is_suppressed_warning(true)) {
@@ -1153,11 +1194,16 @@ void warn_slowpath_fmt(const char *file, int line, unsigned taint,
 		return;
 	}
 
+	if (!READ_ONCE(oops_in_progress) && !panic_in_progress())
+		clear_panic_start = printk_mark_panic_start();
+
 	pr_warn(CUT_HERE);
 
 	if (!fmt) {
 		__warn(file, line, __builtin_return_address(0), taint,
 		       NULL, NULL);
+		if (clear_panic_start && !READ_ONCE(oops_in_progress) && !panic_in_progress())
+			printk_clear_panic_start();
 		warn_rcu_exit(rcu);
 		return;
 	}
@@ -1166,6 +1212,8 @@ void warn_slowpath_fmt(const char *file, int line, unsigned taint,
 	va_start(args.args, fmt);
 	__warn(file, line, __builtin_return_address(0), taint, NULL, &args);
 	va_end(args.args);
+	if (clear_panic_start && !READ_ONCE(oops_in_progress) && !panic_in_progress())
+		printk_clear_panic_start();
 	warn_rcu_exit(rcu);
 }
 EXPORT_SYMBOL(warn_slowpath_fmt);
@@ -1180,6 +1228,11 @@ void __warn_printk(const char *fmt, ...)
 		return;
 	}
 
+	current->in_warn_printk++;
+	if (!READ_ONCE(oops_in_progress) && !panic_in_progress() &&
+	    printk_mark_panic_start())
+		current->in_warn_pinned = 1;
+
 	pr_warn(CUT_HERE);
 
 	va_start(args, fmt);
@@ -1240,6 +1293,7 @@ core_param(panic, panic_timeout, int, 0644);
 core_param(pause_on_oops, pause_on_oops, int, 0644);
 core_param(panic_on_warn, panic_on_warn, int, 0644);
 core_param(crash_kexec_post_notifiers, crash_kexec_post_notifiers, bool, 0644);
+core_param(crash_kexec_in_memory_sys_info, crash_kexec_in_memory_sys_info, bool, 0644);
 core_param(panic_console_replay, panic_console_replay, bool, 0644);
 
 static int panic_print_set(const char *val, const struct kernel_param *kp)
diff --git a/lib/bug.c b/lib/bug.c
index 7c1c2c27f58e..c6e02225ce95 100644
--- a/lib/bug.c
+++ b/lib/bug.c
@@ -197,6 +197,7 @@ void __warn_printf(const char *fmt, struct pt_regs *regs)
 
 static enum bug_trap_type __report_bug(struct bug_entry *bug, unsigned long bugaddr, struct pt_regs *regs)
 {
+	bool clear_panic_start = false;
 	bool warning, once, done, no_cut, has_args;
 	const char *file, *fmt;
 	unsigned int line;
@@ -219,12 +220,22 @@ static enum bug_trap_type __report_bug(struct bug_entry *bug, unsigned long buga
 	no_cut   = bug->flags & BUGFLAG_NO_CUT_HERE;
 	has_args = bug->flags & BUGFLAG_ARGS;
 
+	if (warning && no_cut && current->in_warn_printk &&
+	    --current->in_warn_printk == 0) {
+		clear_panic_start = current->in_warn_pinned;
+		current->in_warn_pinned = 0;
+	}
+
 	/*
 	 * Before the once logic so suppressed warnings do not consume
 	 * the single-fire budget of WARN_ON_ONCE().
 	 */
-	if (warning && kunit_is_suppressed_warning(true))
+	if (warning && kunit_is_suppressed_warning(true)) {
+		if (clear_panic_start && !READ_ONCE(oops_in_progress) &&
+		    !panic_in_progress())
+			printk_clear_panic_start();
 		return BUG_TRAP_TYPE_WARN;
+	}
 
 	disable_trace_on_warning();
 
@@ -245,6 +256,8 @@ static enum bug_trap_type __report_bug(struct bug_entry *bug, unsigned long buga
 	 * extra debugging message it writes before triggering the handler.
 	 */
 	if (!no_cut) {
+		if (!READ_ONCE(oops_in_progress) && !panic_in_progress())
+			clear_panic_start = printk_mark_panic_start();
 		pr_info(CUT_HERE);
 		__warn_printf(fmt, has_args ? regs : NULL);
 	}
@@ -253,6 +266,9 @@ static enum bug_trap_type __report_bug(struct bug_entry *bug, unsigned long buga
 		/* this is a WARN_ON rather than BUG/BUG_ON */
 		__warn(file, line, (void *)bugaddr, BUG_GET_TAINT(bug), regs,
 		       NULL);
+		if (clear_panic_start && !READ_ONCE(oops_in_progress) &&
+		    !panic_in_progress())
+			printk_clear_panic_start();
 		return BUG_TRAP_TYPE_WARN;
 	}
 
diff --git a/lib/bust_spinlocks.c b/lib/bust_spinlocks.c
index bfd53972a4d8..a8be7c129cda 100644
--- a/lib/bust_spinlocks.c
+++ b/lib/bust_spinlocks.c
@@ -9,8 +9,12 @@
  * and panic() information from reaching the user.
  */
 
+#include <linux/atomic.h>
 #include <linux/kernel.h>
+#include <linux/panic.h>
+#include <linux/preempt.h>
 #include <linux/printk.h>
+#include <linux/sched.h>
 #include <linux/spinlock.h>
 #include <linux/tty.h>
 #include <linux/wait.h>
@@ -19,11 +23,25 @@
 
 void bust_spinlocks(int yes)
 {
+	int old = READ_ONCE(oops_in_progress);
+
 	if (yes) {
-		++oops_in_progress;
+		if (in_task())
+			current->in_oops++;
+		do {
+		} while (!try_cmpxchg(&oops_in_progress, &old, old + 1));
+		if (!old && !panic_in_progress())
+			printk_mark_panic_start();
 	} else {
+		if (in_task() && current->in_oops)
+			current->in_oops--;
 		console_unblank();
-		if (--oops_in_progress == 0)
+		old = READ_ONCE(oops_in_progress);
+		do {
+			if (unlikely(old <= 0))
+				return;
+		} while (!try_cmpxchg(&oops_in_progress, &old, old - 1));
+		if (old == 1)
 			wake_up_klogd();
 	}
 }
diff --git a/lib/sys_info.c b/lib/sys_info.c
index 496893eb776b..5320369455d1 100644
--- a/lib/sys_info.c
+++ b/lib/sys_info.c
@@ -139,20 +139,17 @@ subsys_initcall(sys_info_sysctl_init);
 
 static void __sys_info(unsigned long si_mask)
 {
-	if (si_mask & SYS_INFO_TASKS)
-		show_state();
-
 	if (si_mask & SYS_INFO_MEM)
 		show_mem();
 
-	if (si_mask & SYS_INFO_TIMERS)
-		sysrq_timer_list_show();
-
 	if (si_mask & SYS_INFO_LOCKS)
 		debug_show_all_locks();
 
-	if (si_mask & SYS_INFO_FTRACE)
-		ftrace_dump(DUMP_ALL);
+	if (si_mask & SYS_INFO_TIMERS)
+		sysrq_timer_list_show();
+
+	if (si_mask & SYS_INFO_BLOCKED_TASKS)
+		show_state_filter(TASK_UNINTERRUPTIBLE);
 
 	if (si_mask & SYS_INFO_ALL_BT) {
 		if (panic_on_this_cpu())
@@ -161,8 +158,11 @@ static void __sys_info(unsigned long si_mask)
 			trigger_all_cpu_backtrace();
 	}
 
-	if (si_mask & SYS_INFO_BLOCKED_TASKS)
-		show_state_filter(TASK_UNINTERRUPTIBLE);
+	if (si_mask & SYS_INFO_TASKS)
+		show_state();
+
+	if (si_mask & SYS_INFO_FTRACE)
+		ftrace_dump(DUMP_ALL);
 }
 
 unsigned long sys_info_get_mask(unsigned long si_mask)
-- 
2.55.0


