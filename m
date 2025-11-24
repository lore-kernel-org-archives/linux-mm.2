Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EE51CFD313
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 17:11:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EC526B0006; Mon, 24 Nov 2025 12:11:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C3426B0023; Mon, 24 Nov 2025 12:11:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B12B6B0024; Mon, 24 Nov 2025 12:11:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 79D0A6B0006
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 12:11:43 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 23201591ED
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 17:11:43 +0000 (UTC)
X-FDA: 84146142486.20.38C0EB5
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013042.outbound.protection.outlook.com [40.107.201.42])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3C0A5120009
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 17:11:40 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=I5Le9Zfv;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.42 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764004300;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u4UjbGRH8ZP8AKstiVFFdJaoBWULJMOOQls3ZIIhZEs=;
	b=oNUg8lWDSMTyVzmpx0GAnnJSHiT6kbsJfm0OknWpfCNyTFK+Du29NjIw/mUTfXlNeS/ss8
	LTbrQuhxJmhJyPAnQ3YOSp4p06GYwUZgwWy6DEvD0uYF3U/2aVU/Yx1txynZ/gk7RjmiLP
	+GuUE7xgRhWw1EJVnDEAwVnqZ15fLQU=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764004300; a=rsa-sha256;
	cv=pass;
	b=2dB71VSKA+Qp9UtC5/DBi7j/TY0RWjdV3lq8QyYg3xh8zGUts+nvqW12omUNvuUx0cn/yv
	yIbJGrqPHAGsf8s1rNQdnxgn4W00Sx9WR1KpK8rdX0bY/WFXdVedIBPNy/dndV9uoB48RX
	P2jT9Zw2RH87mUqCa7kkTWTfj/2OYxw=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=I5Le9Zfv;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.42 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mli3FbT8pKqQ0IhfR5iIV6liIFhriCkMAACrM/F33mXZaOjpYCy4K5+n7ZVQ8c3IHA3NCsnw6XSjmD2RqpC1p3AMr2YrvlccmLvsRB1bJM/R5C1MYCYldERli4+KemvfHc2zxN4UebcVLo+CPNjKKAboi9pa/ptD6HReUvLUZn/5eo4jjE/kSorlsJTU1ZMrEH5DUXLCwC/SXxDU2K9Egt7zvyoPejCnvo0Ay7ioI1mzm+DEikTZ1wndc5z7vI3x0N+pl057lV3E5dg6zQkjx6mHi9aghXWL/gwiTcNFVKDQ3IiYmmVekmoECSiQq2vhszccSAZ+l0cF33SB41wbDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u4UjbGRH8ZP8AKstiVFFdJaoBWULJMOOQls3ZIIhZEs=;
 b=qy/VtXjnyfKVI6uxobdovaKLQkxQ46hgWZAvWvFDxomYKe5fTVuEFfQd1ttWK8vmwYct+SiQWzcWBMUUjOjCPBye4siUqda9iLBq2cwP7Tl4oRpusxj3sOwB8h/ziwxvaY1OjFOQ3zCJmxgvY3ayCZrYATzRSvHRBKnEK4LqnYWFleWGrIdBX85CNJJe1dR0hlFSU8IffmOWtBgMNSM+kfnN54la+xs+aco50TiFKviRG4pyWffLHIBJHlG5TsRsDSpP/PSM+H4nOwiglfAsGY2cLCvVIwb+Rap9spdCCrRVsF05yPNw1WlqY0HVrBQblCnrP0xZ92gKG/HKLRj7EA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u4UjbGRH8ZP8AKstiVFFdJaoBWULJMOOQls3ZIIhZEs=;
 b=I5Le9ZfvQUydUxFcQtLKrpzj5Y/d7+COjZlTgLJCOcLMxfCPTFDkatG6NfqrNXeeQB8r7P1Q0/wxlygwUQtVUMDbNwRGRsp5zbwN0D6/Qjw5cFBYBCIVm9/iLRtrhPRMC+LX7sSEhH6CQ/SwK8BsoiqzRot51CKDihRLVctrf5vB5KKI5wiQ/vtVy06hf5m8csxL0lXZPgd/g8McPoeREoS+qNm4taRsHEiV/smM/TV7u8zzMbfBf6BDw0JRChBXW1PBtobpxmzAaiFzzko0cZn5vZKBg/n4wGz7qQW2n7HYmy8XHSaw+G1VO5i3F9eqzBY7jwbqNTB1nAFm3anp0w==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CH3PR12MB7594.namprd12.prod.outlook.com (2603:10b6:610:140::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Mon, 24 Nov
 2025 17:11:36 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9343.016; Mon, 24 Nov 2025
 17:11:36 +0000
From: Zi Yan <ziy@nvidia.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Wei Yang <richard.weiyang@gmail.com>, Balbir Singh <balbirs@nvidia.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/4] mm/huge_memory: make min_order_for_split() always
 return an order
Date: Mon, 24 Nov 2025 12:11:33 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <E88077A0-88E0-4164-B81A-741EED84CF43@nvidia.com>
In-Reply-To: <4a242eb5-dc7c-41d0-942d-4dd3dbc7ec14@lucifer.local>
References: <20251122025529.1562592-1-ziy@nvidia.com>
 <20251122025529.1562592-4-ziy@nvidia.com>
 <4a242eb5-dc7c-41d0-942d-4dd3dbc7ec14@lucifer.local>
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0163.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::18) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CH3PR12MB7594:EE_
X-MS-Office365-Filtering-Correlation-Id: e34a4e2d-a511-48ac-3147-08de2b7c8614
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FoIPGl8HUR+4m1eoFdra0ZkDR7b/FsHuysiQvLkdHIZWYsKTkXdqe+1LBpkf?=
 =?us-ascii?Q?OlLsjo1+x3RiEleWb7cdm0DnKKMTfvJCPqFNttwnwAysu6hU0I7UxaFxtx1a?=
 =?us-ascii?Q?whehYzp3v03zm3axfIq53Z3NY7dSWMowrILuFl6r+18VYZJBNWxPfnyts6m8?=
 =?us-ascii?Q?dd7xkN0D3XsDaCr6x9u9yCyGB5h5tmNgYmP6m62Zk9cgmg6cLir7RPLrAQdk?=
 =?us-ascii?Q?fhMujmYvKp95oJsbq6MzAir5+9i+k/CgUGSmoSeZzD1XZf1S2VKJMC4adhnu?=
 =?us-ascii?Q?YLrxQCCdXdN/f+zMa1Ed8Mt/un9sYNGFcjbW88px1cJ11BypQJ/eNrJjOoMb?=
 =?us-ascii?Q?2+d/b/+8Cggkug+A0y9R1ewvCCQBwcAtbM9/0sCRI9qkMAz0AnUrpxAdf4nE?=
 =?us-ascii?Q?O6HN1AB24ZUvOK9t+7e+PXgJlKI3s71Yh5hw1F90nEWoUhqHt7GetVOFudcN?=
 =?us-ascii?Q?imsxz+tXbJTvw0zrdJEVaO/QPrGkLXJS6qu4Ct8AJ+5/TxE0ATQ1xieCmWFW?=
 =?us-ascii?Q?pa3W9l306/p0Sc9xguMliIwjAsF97uxoYaoz+0KowTy27lfWp8EDWO3Xe2HS?=
 =?us-ascii?Q?8m7tAGxcW54ADJipohgaKvCSpU44lER3cek2Mhw4LbEEZob94oS6FAgqiC+1?=
 =?us-ascii?Q?A6jbZ+xH9ajHDhkDETOkV4sZyyFDx1n3e7OOQH+KpKqaOhzWuoIOgykYaKUx?=
 =?us-ascii?Q?t+16k49ea/glbFIbCD41RJP7gqHDtHMSk1YCAYNzDJGD/CRyxK3cMsXX43nM?=
 =?us-ascii?Q?3FXbtxei4XMZ+uDRZKaUXE595KiohYkDADhClpVTcWY4suN+ZqE1XBpocxov?=
 =?us-ascii?Q?XJQLpnT9CBpwrzRfwOPKzYQqWDlxswOWf1Nir+g8w/CcqbPUiTrqAQgJbL9U?=
 =?us-ascii?Q?VN5Ed9dpnFiniWP37oF/7bcQ4NUfRfgWvhOoUZd6gJBkKKrIx8lda9+Da90C?=
 =?us-ascii?Q?B3B8t9Sp/4z+1fA6Gxu/uu27rXTCA++qS8gXbysoRtEJRC99hYk3VvuAKnW1?=
 =?us-ascii?Q?OFsnwMK+sqe9/g9Sk2ZaTaShbdvPvFlAMf/fzoGw7rkNOZ5sEvULE0fNpSK6?=
 =?us-ascii?Q?MTOdCR7MrdBCoyiUyNuZXe1tod/ibsD3YNld+DpJyr0YEl54/ZxS6rBtSSIP?=
 =?us-ascii?Q?35QA6ePoRbOqQh/h+3fcw025I7bK9jD7b4EvjVOJtWhe9iQyssjBkglZv0fu?=
 =?us-ascii?Q?pc6zsMC6yiEjs6ErZ6wxfAAU2wzDWDY05oF/xvPJDtASUBQVRi/BBnUuXfRk?=
 =?us-ascii?Q?SRHuIaz2sL/Cx7ZEB9q0tOZqM/3Rzxr2xxzj4b7UJ8XuCYnzDDx3nCMQs/Uh?=
 =?us-ascii?Q?SXLwfupa0QV0/ow7iO2TZOZxxujosbBnxd5+ejl1FflEC5YBbG4LCnnp16Yk?=
 =?us-ascii?Q?IuWcID6xqyApqxFcAmvlwvv3g2E05LZ4tt1PFFpIXND/QTDWne9R9J5+5R3/?=
 =?us-ascii?Q?ls/YGuv/OGHmaR58564H706tEZyVNPzK?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KSDt/G4+WFxz3ar72xFmQxOREJQZNHKyr15LS8AKRZNCtaljtA2eSfS+aNWH?=
 =?us-ascii?Q?KPP2n0A0UK/Yik9BuIflOWCZm6Fw7MtayUtejSytl6Q9SUQEgd0jzCUHDgTr?=
 =?us-ascii?Q?546XPEGGj9ltzh32uyw+aAzz1f0zMaTkGYIt1ms/QW4bW3ILIawrqJ8F6+lD?=
 =?us-ascii?Q?N2R90zb2hbQP9D8E7Wt0aPnhU/68bl2/h2W4r6fYFyOwsxdEFuBuYmzWMA0h?=
 =?us-ascii?Q?wmEc9cRzkAq4mNrkeoJrAnkdS7JEUOFxxNiZT0DXwAnPCiaOhR7whZkPEm35?=
 =?us-ascii?Q?Yvu4CLrbWMXxpeLkM+5WzcSHsDqzOhBO4QJVxkWh30lIsjx/Ho7/qX/ocd44?=
 =?us-ascii?Q?iJOXsVb5deW2Rdq8dRQBkS+3V9oTXi04SDMdrvgSGWyz0L3zDOAcCFGpyMDi?=
 =?us-ascii?Q?WtjN+09kOEFaTjl0mqdy8Q3G7b/ycrXrOyIvTpt8UbajbYnzlx7ChTniedUI?=
 =?us-ascii?Q?gkoZiIPvLxli5Gp/FEzy3XkkCMVuTPq/QvDBwtNfDGJf8u33181ZWVXOL0Oi?=
 =?us-ascii?Q?O5+nBgXpKVUcTh9VYyPFQaxsS9Y6lhWpFdoefcN0UW84NCm1LRfqs09psaU+?=
 =?us-ascii?Q?XZAlro6Jlhu3/93yot0ziFqttHPtkQmwFjjFIt2aNynmGASpM9r2AahsaiFj?=
 =?us-ascii?Q?iAAzYgkNVgKCqfqwsm0YRqDQfL6ZYcLOBP/Jv3c5bwdk25KYWaLigJ1cGNsK?=
 =?us-ascii?Q?M3Y4tyDaoiZNQKeg3IbBhACfbqBbrKjc+/SR7YGRD+4p2BRfu2NKnc9DlTK2?=
 =?us-ascii?Q?4AmlvByRCcubcE9XffEhuyF5L6rY2stoP5xh2k1THPZSHg+HVYk9pl9vDO80?=
 =?us-ascii?Q?UHXza9wHeWUpFp632csB3tUQ2bnrQ46Yi0q2kXZpvcMRlp6ASYm06gnAPOxb?=
 =?us-ascii?Q?wZRqTYQAazRYGE+hWSHeTkHN4zbRQvzMxRilQTPhihUexb0Q4fBZ7e/M5oZm?=
 =?us-ascii?Q?SOdUJhTIvGSZhtuk7wGHA/QYpkjYc397p+0jQhvEzZdfbDhXGLpIw+nUxR04?=
 =?us-ascii?Q?tkRMm3S0/ENkiZl39Tj7WfWpZRV7ez1fBv6+PP/mifVHDM2q5dv7mEkrlpV/?=
 =?us-ascii?Q?uySgJrJrR9zSyEzdBstMMDTEhVXQnjsuOisESNtTwj88Ra5/6rsxmTpINL2y?=
 =?us-ascii?Q?5FmljafB3WSKV0zznub+wpBAtN170g3IhWjTNeAfpaXSamKfGF9udmOXVPcf?=
 =?us-ascii?Q?covGRBE1nQS57hRJZvoj8EeRvcTnr/ldTloUNaU04s/8QjCQUPEnS7A0cIYt?=
 =?us-ascii?Q?oQuo6xM9oWr0uGFdEKzhqQ9kZKxqFAxx2hG7o/FttcBPe4yUL5IgQ0EVPxE/?=
 =?us-ascii?Q?VnUIsDS5aGPgOGG92Nh8L6BMC+6fj8PjoQM4mNXm1xYXxNBVpdRw29LEpUMB?=
 =?us-ascii?Q?nkP3hgwlCEacJDvOmfG/gWywCYE1zuTaAaCzUH+ngw1S4IhTcBI6HvoJXsg3?=
 =?us-ascii?Q?/kSB1NSj/Y2UOkC2NVQF9qL/kLJM9hmFxKn81Gf5zD4WwOYr5b0AX+AnCjIn?=
 =?us-ascii?Q?DsacKJgV4R/tVwkEuOEiGVlHw0JavEuFSK42rGSI77fUaJ1680QAMLyd8foX?=
 =?us-ascii?Q?qJXebs2uJDJXN5PMuvSw5hNpNanAswZHtqgWep4T?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e34a4e2d-a511-48ac-3147-08de2b7c8614
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2025 17:11:35.9853
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qJ42/JmYRpkyE6yrzxrNtyIyovcEKkGRk5Cq2lyQt8PnxnaS/C0qfb490Qjnxcxp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7594
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 3C0A5120009
X-Stat-Signature: epti8pohaf8zrmaupudb14xwrkzdnz3r
X-HE-Tag: 1764004300-344524
X-HE-Meta: U2FsdGVkX19v+eTOv28cCjabDfb/HmXweKF4t1Dpk7GzRWSxyf2Ecq8/aElxg24qYJRHfHi4bPPTI4ixnT9VZc3nXR0Le5taUE4oOXF9pfvWE67EJxAkrz70QOqb++c+VUkvV6nF4n3YnU8gH8lWYT67tcyudBD7OfU7NMesdvrBRUePmnVQTxq1s2aWNAovvc8Ch33xdvhOzJJ8vLlWazmcpmILZ29kscTIn8otDeOmLjR4iZxExDcEPis726jpsR2EGh7Mgu5uJm8Eag5397v8zjaYRkpAAsPFmZsG7sd0SqzIZeM1CYKgC4wAHdXtLDHOD7Mg1c8sv79qQtF41Z/4obaDXYg1FOWvSEs1/CwGApY981hKlAxuHF+AsteMDUrPA7TFcP5vIwlfcZsDAUDVBEF7NiPwLSUGnc7dgsXy++sLd2fNMdIy4j0oicEg+v2exdUsk7zT18vE1KHOwRb82/ld4HfDh92bbWvVIcNKls4Cx45w/ws0+uN32T5MIhapilO3ao/uj3oogtDfqx7HxZUMkMPFuavEEleqUnqGCe0w4kuxGAE2UmkhOXOBkkpQtLDZ85l9j32RuN9q8E4ma6Bu3Hq4A7yUgohf6Ac5T0uFZG+ZnbX1oKIMHk8ivCi2feGk9SRe8QQyiknBICSaA3KzBIKhBK6Xl3lAcPPZXJShiy4E0H8bLoD6TDuObKWL1iBBmqVBvY4Np5rY70rHnHYmb98KsthY5gPK0M8l+7hqP41fYv3szlzj0kuLPNVRasOasq9LnsP6RnDZi/v6wZO/UYr7Nbb2MIkl8PbUdu3vrGv20uJG/YsO2gY6EwuOfD/5olaC26oO3ZJxLv3OUV/bJaDFMv+7QkYrlNGRLLIc1fLPErmefdK5sZQ7bNHL3M7YkYz9UoC2uLzb0wsBXJdVt0vwghWJd+UgFhnnCT+l22rYi9be1W9x4sKMVfUMmlfGYR4AkNH6eeE
 L3rNUU5j
 DAsWkUzefws8zJXg/BSVIJ3yUEF0Zm6/aMyOZdm5ZFBBiOuxZpWD31kjOO89hbJXOge7yW8pBSEU5FXC3EJDahHyarppjvXUXrzyfFMQKaDGMwZligAwHbFc8laTXgEJWsfkOvh1XBLYexTP3xkh2Pc38cMpK9mW71zfqOz2DkSUKDV61kwbozFf72NlyuZQaJ3aEjUdMDmCwZzp33Hn/Ll86LWmPsAbnPp5mnG1waIIpq0BJuUZewhXfH4HK5JMRS0sqLLjud2BnvOmNlr8BJIzIT2LTVZkPFpbAVh93KVOXWqNGQeYhCrnYggzc6nNAXWIeI0Qli2YC6lzNaVIJv2cdTC0D2ZMFakrI5MMOiPYSTX5+AMPO9BfUAmpVTp9UCrMOawchFK6MMi0UQfD8hsiF3vPYm45cUheT2TLZUWVbidB2cP0pGHN7bLkQFQz8BgVvATdSO9B4e7Nb5MBl5hqkVw0TJmG61RQL3OHjpv7Sk/Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24 Nov 2025, at 10:18, Lorenzo Stoakes wrote:

> On Fri, Nov 21, 2025 at 09:55:28PM -0500, Zi Yan wrote:
>> min_order_for_split() returns -EBUSY when the folio is truncated and cannot
>> be split. In commit 77008e1b2ef7 ("mm/huge_memory: do not change
>> split_huge_page*() target order silently"), memory_failure() does not
>> handle it and pass -EBUSY to try_to_split_thp_page() directly.
>> try_to_split_thp_page() returns -EINVAL since -EBUSY becomes 0xfffffff0 as
>> new_order is unsigned int in __folio_split() and this large new_order is
>> rejected as an invalid input. The code does not cause a bug.
>
> Yikes!
>
> This class of bug is all too common... 'unexpectedly returning an error the
> caller wasn't prepared for'.
>
>> soft_offline_in_use_page() also uses min_order_for_split() but it always
>> passes 0 as new_order for split.
>>
>> Fix it by making min_order_for_split() always return an order. When the
>> given folio is truncated, namely folio->mapping == NULL, return 0 and let
>> a subsequent split function handle the situation and return -EBUSY.
>
> OK so we allow the split essentially or rather give a return value that is
> essentially 'we don't care' because any attempt at the split will run into
> something like:
>
> 		anon_vma = folio_get_anon_vma(folio);
> 		if (!anon_vma) {
> 			ret = -EBUSY;
> 			goto out;
> 		}
>
> In __folio_split() right?

Not this one for the issue I mentioned above, since this is for anon folios
and min_order_for_split() returns 0 for all anon folios. anon_vma == NULL
does not mean folio->mapping == NULL, since folio->mapping still has
FOLIO_MAPPING_ANON set. The fun never ends, right? :)

The above issue is handled by

       /*
         * Folios that just got truncated cannot get split. Signal to the
         * caller that there was a race.
         *
         * TODO: this will also currently refuse shmem folios that are in the
         * swapcache.
         */
        if (!folio_test_anon(folio) && !folio->mapping)
                return -EBUSY;

>
>>
>> Add kernel-doc to min_order_for_split() to clarify its use.
>
> Nice.
>
>>
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>
> LGTM, so:
>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Thanks.

>
>> ---
>>  include/linux/huge_mm.h |  6 +++---
>>  mm/huge_memory.c        | 25 +++++++++++++++++++------
>>  2 files changed, 22 insertions(+), 9 deletions(-)
>>
>> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
>> index 1ecaeccf39c9..9b3a4e2b0668 100644
>> --- a/include/linux/huge_mm.h
>> +++ b/include/linux/huge_mm.h
>> @@ -372,7 +372,7 @@ enum split_type {
>>  int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
>>  		unsigned int new_order);
>>  int folio_split_unmapped(struct folio *folio, unsigned int new_order);
>> -int min_order_for_split(struct folio *folio);
>> +unsigned int min_order_for_split(struct folio *folio);
>>  int split_folio_to_list(struct folio *folio, struct list_head *list);
>>  int folio_check_splittable(struct folio *folio, unsigned int new_order,
>>  			   enum split_type split_type, bool warns);
>> @@ -634,10 +634,10 @@ static inline int split_huge_page(struct page *page)
>>  	return -EINVAL;
>>  }
>>
>> -static inline int min_order_for_split(struct folio *folio)
>> +static inline unsigned int min_order_for_split(struct folio *folio)
>>  {
>>  	VM_WARN_ON_ONCE_FOLIO(1, folio);
>> -	return -EINVAL;
>> +	return 0;
>>  }
>>
>>  static inline int split_folio_to_list(struct folio *folio, struct list_head *list)
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 6c821c1c0ac3..ebc3ba0907fd 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -4230,16 +4230,29 @@ int folio_split(struct folio *folio, unsigned int new_order,
>>  			     SPLIT_TYPE_NON_UNIFORM);
>>  }
>>
>> -int min_order_for_split(struct folio *folio)
>> +/**
>> + * min_order_for_split() - get the minimum order @folio can be split to
>> + * @folio: folio to split
>> + *
>> + * min_order_for_split() tells the minimum order @folio can be split to.
>> + * If a file-backed folio is truncated, 0 will be returned. Any subsequent
>> + * split attempt should get -EBUSY from split checking code.
>> + *
>> + * Return: @folio's minimum order for split
>> + */
>> +unsigned int min_order_for_split(struct folio *folio)
>>  {
>>  	if (folio_test_anon(folio))
>>  		return 0;
>>
>> -	if (!folio->mapping) {
>> -		if (folio_test_pmd_mappable(folio))
>> -			count_vm_event(THP_SPLIT_PAGE_FAILED);
>> -		return -EBUSY;
>> -	}
>> +	/*
>> +	 * If the folio got truncated, we don't know the previous mapping and
>> +	 * consequently the old min order. But it doesn't matter, as any split
>> +	 * attempt will immediately fail with -EBUSY as the folio cannot get
>> +	 * split until freed.
>> +	 */
>
> Nice to have a comment here to clarify this!
>
>> +	if (!folio->mapping)
>> +		return 0;
>>
>>  	return mapping_min_folio_order(folio->mapping);
>>  }
>> --
>> 2.51.0
>>
>
> Cheers, Lorenzo


Best Regards,
Yan, Zi

