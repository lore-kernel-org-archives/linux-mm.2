Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 971EFFF887E
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 17:09:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CB6D6B008C; Wed, 29 Apr 2026 13:09:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A3AB6B0092; Wed, 29 Apr 2026 13:09:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E86666B0093; Wed, 29 Apr 2026 13:09:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D2A366B008C
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 13:09:20 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 62F351B9549
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 17:09:20 +0000 (UTC)
X-FDA: 84712229280.09.A2B57A6
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11020143.outbound.protection.outlook.com [52.101.201.143])
	by imf15.hostedemail.com (Postfix) with ESMTP id 821F7A0019
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 17:09:17 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=t+pHHE29;
	spf=pass (imf15.hostedemail.com: domain of yang@os.amperecomputing.com designates 52.101.201.143 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777482557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v85j+0bGElAPFU2Bzo3PUorjiPwnDrfwlUjCFlrKqY4=;
	b=upzcm4Fsvre5GCGg3IevKsno87DjECUOf87kLPMghTc4DVGXel5vRFmFb7c1vP4/CzXZCt
	SGepE9z7JFHjLJC4xpFzdplNu4DlwJhpWk2DPH/kz4Q5qoJvw/czoIwMT4NwdIJn8kyHMz
	bTummja9TcN1Asr/dd3QORftdFkp+uU=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=t+pHHE29;
	spf=pass (imf15.hostedemail.com: domain of yang@os.amperecomputing.com designates 52.101.201.143 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777482557; a=rsa-sha256;
	cv=pass;
	b=T7Sla58mUrdAVO+myXl3nj0H7xCiguBOs1ahAJx41eqCB8A6WSTOAgzEUkTmSBm/LyNV2W
	3zBDaPuUF+6eT6u6ywUJaVS7oW13KMsZp+YOkV+Z5PQkJFx86CbAdZoRFBUuIfUvpUtOPN
	eAc6D7710JHpumN0cUtLdTp7YkyyjwI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CLc6mf/P7vMrpmo4B8chbW0WHB7MCpzjeJRpi8hSBmUAc0YaaHMiQVv7k5ytdW+NM/Q52omeiGW2JFj0SZw7X7FEHWSk/IvbqTvA918tL3gIwZUhUjattsqmgJ7qjT3sXXSgXvw70WLj5q74oBgJREhO7CmNc2CV4SY6zqtKldoYbhWmWiEVGdDUu9AvlVVwCMMwn197TCc6WhQkuJ1v3WVafV8w0LIPppsYRwYxN/jveBNLHLTEHEItRwDbYeJsYvpTaUj8YsX3ZW5tofonferOBxr4VFHrSNqjOyNWPFxYCOL4v/EZlms7uatftnhRzliYCK1qFV/h74kzBGkrIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v85j+0bGElAPFU2Bzo3PUorjiPwnDrfwlUjCFlrKqY4=;
 b=D4mVJN4pgzuvZjKJ3W1av2/GUd2UH5ZKFEQWhvtS693tiiP8fOpEsuLNvwYfrDCe/r0e87XqQmdWA8U4FTCQV350ZzlFNEHxYJs07ZzGH3RFqLRI1WSkyqxePWML7hVk8fqC/6KQ7O9CRHOumH7foUsp4nbmS0r4nInspSE7ZXsQm2xuq60IxQXaWbnP1fqelyR4anmKoeWyqqKlylPwN0evTAzv13mgqiv9XO/4FZt5JpX5/gCTDVG++3tO8Yt98Xy2B1JWQ/5GRxttt3btnOXT7Ps82C5mIQdoTtjbCzo8D1d3Im1waFVOm4LI56j0spVdtwGeh2x8CUZArBfuIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v85j+0bGElAPFU2Bzo3PUorjiPwnDrfwlUjCFlrKqY4=;
 b=t+pHHE29IBm9Pbley5mkml0G7ysVXHTVlvn+rBx12ar7Jj5+tGy9X/NcOLxUDDfbAh+0dIelhEkSGzyBy5WKZJy2Akjwi4awN9SO+53dZ60ByYVlfFYvW4upZWA1z9k8mH1z4XtLcYgI0VS31lfskdOG6eFCmH/Xv3WMCrB6/20=
Received: from CH0PR01MB6873.prod.exchangelabs.com (2603:10b6:610:112::22) by
 DS4PR01MB994309.prod.exchangelabs.com (2603:10b6:8:349::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9870.18; Wed, 29 Apr 2026 17:09:13 +0000
Received: from CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::46eb:64a3:667c:c1a0]) by CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::46eb:64a3:667c:c1a0%4]) with mapi id 15.20.9870.020; Wed, 29 Apr 2026
 17:09:12 +0000
From: Yang Shi <yang@os.amperecomputing.com>
To: cl@gentwo.org,
	dennis@kernel.org,
	tj@kernel.org,
	urezki@gmail.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	ryan.roberts@arm.com,
	david@kernel.org,
	akpm@linux-foundation.org,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	agordeev@linux.ibm.com
Cc: yang@os.amperecomputing.com,
	linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 11/11] arm64: percpu: use local percpu for this_cpu_*() APIs
Date: Wed, 29 Apr 2026 10:04:39 -0700
Message-ID: <20260429170758.3018959-12-yang@os.amperecomputing.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260429170758.3018959-1-yang@os.amperecomputing.com>
References: <20260429170758.3018959-1-yang@os.amperecomputing.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA0PR13CA0008.namprd13.prod.outlook.com
 (2603:10b6:806:130::13) To CH0PR01MB6873.prod.exchangelabs.com
 (2603:10b6:610:112::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR01MB6873:EE_|DS4PR01MB994309:EE_
X-MS-Office365-Filtering-Correlation-Id: 8fdd8f7b-97f7-4146-8e09-08dea6120929
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|366016|55112099003|22082099003|18002099003|921020|56012099003;
X-Microsoft-Antispam-Message-Info:
	XwNRQOFRFLHWla1qMXCZ5kbThZBPsQWVrSqqFMoNopJT7TU7gFr8uHnZRWkxn3vndk1lwjrUD6ejUs9k2Qb/1/snjv6uMXSmivjPeoQXZsRA8WI9Wf6aVV/N33LH9FR+4mbojAkO5U8paHQcx7+3W5nUxLPtITVSHAaJ4c61hDGn6YyDWgszxGloTt+CwT4lJhZlnH14yrfdpur9x09aBpy/QuebYqPN6mWJenaE3u8wwBbNnj6PfdSj/55TzcJmqjiBFjZ/1zqa95FUrEan9nbASo2tifhejrJ5Cpq2lzRYuaTE3WKyVYKzuCw6YXhsQDL+Z5ZzwdlqigCp7sdaUFV2QXPwvytlBehsiHqowu5Zr4Cea382GcobJ+WylNCUkoPcvaCOBh8KgQqGRXDU/HaGcDqLxGzbpE2HojNgH1/uCAPAgIF6WR5j5EuTNsrO5p9RHuMh2bzVI4qCYA24F9sCAJBa2VdEy1Ral+qazAOmHMg0g+unEUeTVmXb+5LhGxdbdWN7YaXrJvhV42LunAgXvcJ+dAuunmInuT2P2tIT6cVVNQdpXnLQkfLmzAONS/WMgYjZ0uks5aoYRxD2yp/wPFjurTE3solgohn6MsUM7z8n2o9N6W7jfc74ETWcOvGs3rfErF+ki6HQ8tB5a6W7xHbuqBdvumNwDrtId4TN8w77hc7x48wnJIm4HLjKwVCJKPJdQjCE/S5H6k7FcSAHUWPN4srW89lefCa6I4wxZDqHG8fL2vNi83n7Dct8r4PXRIbHAVPOzLth3DVzoQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB6873.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016)(55112099003)(22082099003)(18002099003)(921020)(56012099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?k+8+a4oPg7FwNxT9KWwuWAILN6JZnZmXAzWURihSzX5gOZWsGaTntVbhC3cC?=
 =?us-ascii?Q?pgyl3gM+YrYvNAvFTFMWI8H3CrGfkXVJhF+xGJLaJXm9+SlZ28I9UT5PdOdd?=
 =?us-ascii?Q?Z0uGlBBdpWjLPoU/woiLQ+WjdDfr5qcpDVK2581ubZKWe1TaeyE+mbeKeE+i?=
 =?us-ascii?Q?9M5p5hES2Yjzz2xoeo2cCMqfn4/0zxmTbht5FpLk5iiUsxz1bCkAuTt3eKRX?=
 =?us-ascii?Q?1UyEEOQV/xiCmZj81IV9yWZKdbubnV91DvEtuGwXhkR8ocvlcuSXYcEJK4y8?=
 =?us-ascii?Q?xnaLXyScq/5Bu2wI6oKAaDsgHUL4rli0pYQ8Uu6ap8yHYMP614mBFCYh0TBt?=
 =?us-ascii?Q?MtKtH+qhi/7Z1V3IfGQ2eid/E+enOxh3ZttZr3+Xh6mW3ADhtVi1UbhPbhsT?=
 =?us-ascii?Q?H1vjYhlex/M/Yh0W7T83bQg3x7aA05I6WgQh/2JeDOvCrwsH87+vysCtaTgv?=
 =?us-ascii?Q?HFYQI1j1r36WvlAXyqBtisMmR7mwriZnJE/s1sUljOpnsHYXZDZ832UU4v3O?=
 =?us-ascii?Q?4DF5kLE6WQFp03JMISu/etqWGkQsrQDPXzkkqOe4RYPLw/uVLp/1DUUuxLDX?=
 =?us-ascii?Q?DmSNgYlUrUCrYMBdyYS9hlzr646C6RZQnjpU8YFSVGsElRYqFx7hkSJbF/rm?=
 =?us-ascii?Q?n1EUG2NjM2d9HoOxhEw/Ku9eLosRr8Op770mRLwWoo3t3PDE2T4k+ekr7fae?=
 =?us-ascii?Q?YlA3wQ7sqmQu7c9oIUw6PoPOuVE/LHZG3A+mylNhk4nqHojyUpL1gmXEi0eg?=
 =?us-ascii?Q?DpieWXtB8i0lXzmCF7ikJmVxoLYas/XWaZMo4viA8zsNP/MmC5hosCT74rP9?=
 =?us-ascii?Q?AK7TKTafITIR43EnnJJa5JLPI37/Smqi1R2In9focarV/1mx6nW8f79xrQUr?=
 =?us-ascii?Q?Sr4vJMtJY37jssZKOE+mZScaUmoYvbWoN4fvYKcSvltmeV0e/mg6g9kfcUky?=
 =?us-ascii?Q?R9VKwO+Hzrns6Su2ulRWN5umu8pVuHDxPAF+SxJTXJPuHOO+tgWSsgp4Zxep?=
 =?us-ascii?Q?2/zdeo+sRMV/PyWSTzrd0hZxjQuGJwIciRciAB73L8E1EnvwpeaLlCcwcauM?=
 =?us-ascii?Q?t7v6jqHIEkNPVD5JQqUPzEex+/WkPhNu4FB97QD09dGKJniCI8LfC5VZNDRX?=
 =?us-ascii?Q?ZTY5J3iKCmMOjAww+W3W/hu6/RtLSCXUo4NVfCOGLMYtwoMDqUuRbYQApeL4?=
 =?us-ascii?Q?DMFk3QmaaVTDT9f7jIBki0OwRptQoFSXAgrypqWiQzwKxTSwXL3BKqzHaZ6E?=
 =?us-ascii?Q?Df3BIJPlKKPrW9jlrmtYaOXEVTYJKUS4RXfkkM9M4cJnbq2FqNpDEycFTW/K?=
 =?us-ascii?Q?X/z92MFY+GxfEjF2bnUxUDCryV25DLah8RHyopbEeHdKoItAZ7gin46RrCxt?=
 =?us-ascii?Q?hEn4DfTmQhy3qZcXdK9LRVaOgwKIEDYOqX+Ce5TAfDdhuk2NCWcw1lvQPZ82?=
 =?us-ascii?Q?yatC6R5dvtA8fzRVRN94koD15XDjgaSCSXyMM0olJGBqn5noh7+acZXki1qf?=
 =?us-ascii?Q?syb2Qz17eF1cSvZGYem8sRT9TXYux/gZ554k7O+3/WPSRS6c/13Q8mJyS51e?=
 =?us-ascii?Q?MA3G+ydPvwJYeWgk13DCPUNIPvWo0KODboVVQWESU/IPPaNUwj/0lEZKp71F?=
 =?us-ascii?Q?KGYcRonjI0DYPHZeVhCrnurdT1oGTmNGujpQnNcOvbG86EZcfny+2Ma9/qEZ?=
 =?us-ascii?Q?nTZ5GNrnB6GppkS8RJWrB7rhFJzqWkfQRcRqp47DZMpiVZYebFtYLa8Dnihd?=
 =?us-ascii?Q?e8N0RPsKJPm2wLlHE+tRvDYEVQKpgSQ=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fdd8f7b-97f7-4146-8e09-08dea6120929
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB6873.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2026 17:09:12.7913
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ml1/JDA1DYp03iX/ucm2NT/hOUje31qIK4dK0lzccd11/27Cvc0y+qp719r9l3qtZKvnFHpL+nMUmrhfLyjShLcnW9H6Bjey7rbX//FA8oY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR01MB994309
X-Stat-Signature: gxu8rtbex77fpogkaxasc34wfr3y8edh
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 821F7A0019
X-Rspam-User: 
X-HE-Tag: 1777482557-4800
X-HE-Meta: U2FsdGVkX186UwKys857vDKM5O7bAmVA3xHGcSYBSyp6no/OE/NVhr6mb6DKrWZTc0R56xvKSlN8Ghgkv8mUNj/3fHi0rKhN+D138ccswN74iYSao9bQe94kAcdeyuHDkbaS7prt1RAr46BkmZ5Lfx0CjM+s9UbhPnHg11hdW2rXRBkFFzuKEh9kBUrzxRwGxSth3YU7bizrjSejf4DSIiqUc7oWjtbGnBhZq+LlxElSX/fektSXfKEbGIgWq2qLwRq1j4qXFExpRd+vg60ZBk9d9GuCnwn6muODoBQMFVlURZC+p9h7XHuVczA+9Upg7Lgw/aU/jhl/FRghdHOX2dV1C24aFdgwQ3qXRd5dthf1eBwXZuURwqQ+S1vHZaSgq0s1oRzk0fSuUJed2wKdrSgthY+EfHl0t50NaPOwlJdYv25REjCNEOnWoODWh00BjDHvBWxfkkzKt2OcVsWV12dNE3uBALhvm7n0jOGJHoZQYs+ee3uWfP1P40rgqa4R04gz17TjOTE4KHdsR0J9ozRDxSp9j8sTKHK7mSM3x/wACmhhPe20L/BYhD1rNQv3/u6RcKbU6VEZZIsYNgTXyRBflma4rEpmNqpeep8QkazRVkqXmJEyQ2oFBHhi3ess0dKeaXpl74vEA0HKTzJzZ201eb/nFUAwRhHT2VQ4mEZ4H84/T5dDoHeyfMGOWT5ho3lw8nVMdCPTcWZEWjHIRyZjLhVUwpP04cl6gWPLyI4e9ZEwdn4EglcHyFtN9kytAjS7I74XwIfxZwR3iDlckMATc3vc6Vo7HZe1FGkJajGbflQX8cwqEYD5/m/aprYaF1hJnL7XMUIhpWNDQas5KcFRAO9/3bRQ9sVQJj1Tr/G9C9KwfW70D3dZRmfCfHi/uyHPgqP3zmNSoketQh1uTUq5EArtcu1IWF2w6IWo6+CUmqkfaVs7eRh7WN9lVu88S2CNEF41wIBfTxuiJhi
 TaQoAyv7
 4bXQTalxHHkKqeH0jGwWdkJB/Hi7h5TvW58BgoFKjeYaEwH1ojjeXtBwvjQOE0ChhF4FXe6EEsntubLwBQn5YScVM+LQN4Q4B+jNwjxq9JP7lcF3eY9RUNfJM1m2oPOKS0nJj85Egn6Za9A3ZYOqK8imJosY+zSuNTJKMMOiHMDntOVga8hScsHIFQhVn4CfuJemp0TLPCsHBcflXd2wGxuy9iJM7kQyaBhVI8p7ZYsUmwn8HuTi4IpOQ6FPy+nFPR+uOHud2MEzfJh+wyBLg0pJI3hhWJsx3t6kXuWpuXRRSb1A+z2ZAvEHnq4zG/Q5j5836h8zw49VjQidn829wVB+zgrZ3fM+gyq8zGr61QBfUsAr2ynP1IN8usTu2gnfpxyTvCLczH4FcHH3bv2mLMdmSu782uD0y6cBxAPxkM0cdrZ6ZU0/y1Yi+VUzKwPMYzEW8VOSrU6MirGB0dd+/9FhLdXwlt4Dynp3YfpXuPtRwTOXItnjFWq3YGVbMAz94eoqj6REuuDVKd3LtDgxRUcVWpiqN8L95R+YE+4/xNba37rI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use local percpu address for this_cpu_*() APIs.  Because the percpu
variable is mapped to the same virtual address, their address can be
calculated by using __per_cpu_local_off which has same value for all
CPUs.  So preempt_disable/preempt_enable is not needed anymore.  This
optimization can improve the performance for this_cpu_*() operations.

Kernel build test on AmpereOne (160 cores) with default Fedora kernel
config in a memcg roughly showed 13% - 15% sys time improvement.

Signed-off-by: Yang Shi <yang@os.amperecomputing.com>
---
 arch/arm64/include/asm/percpu.h | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/percpu.h b/arch/arm64/include/asm/percpu.h
index b57b2bb00967..15db56f981de 100644
--- a/arch/arm64/include/asm/percpu.h
+++ b/arch/arm64/include/asm/percpu.h
@@ -12,6 +12,7 @@
 #include <asm/stack_pointer.h>
 #include <asm/sysreg.h>
 
+extern unsigned long __per_cpu_local_off;
 static inline void set_my_cpu_offset(unsigned long off)
 {
 	asm volatile(ALTERNATIVE("msr tpidr_el1, %0",
@@ -153,19 +154,21 @@ PERCPU_RET_OP(add, add, ldadd)
  * disabled.
  */
 
+#define local_cpu_ptr(ptr)						\
+({									\
+	__verify_pcpu_ptr(ptr);						\
+	SHIFT_PERCPU_PTR(ptr, __per_cpu_local_off);			\
+})
+
 #define _pcp_protect(op, pcp, ...)					\
 ({									\
-	preempt_disable_notrace();					\
-	op(raw_cpu_ptr(&(pcp)), __VA_ARGS__);				\
-	preempt_enable_notrace();					\
+	op(local_cpu_ptr(&(pcp)), __VA_ARGS__);				\
 })
 
 #define _pcp_protect_return(op, pcp, args...)				\
 ({									\
 	typeof(pcp) __retval;						\
-	preempt_disable_notrace();					\
-	__retval = (typeof(pcp))op(raw_cpu_ptr(&(pcp)), ##args);	\
-	preempt_enable_notrace();					\
+	__retval = (typeof(pcp))op(local_cpu_ptr(&(pcp)), ##args);	\
 	__retval;							\
 })
 
@@ -251,7 +254,7 @@ PERCPU_RET_OP(add, add, ldadd)
 	old__ = o;							\
 	new__ = n;							\
 	preempt_disable_notrace();					\
-	ptr__ = raw_cpu_ptr(&(pcp));					\
+	ptr__ = local_cpu_ptr(&(pcp));					\
 	ret__ = cmpxchg128_local((void *)ptr__, old__, new__);		\
 	preempt_enable_notrace();					\
 	ret__;								\
-- 
2.47.0


