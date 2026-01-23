Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D5A7D778B0
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 20:12:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A061A6B0552; Fri, 23 Jan 2026 15:12:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BA426B0553; Fri, 23 Jan 2026 15:12:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 762226B0555; Fri, 23 Jan 2026 15:12:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4F8CE6B0552
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 15:12:42 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F37BD140625
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 20:12:41 +0000 (UTC)
X-FDA: 84364326522.15.5D77745
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7D778C0002
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 20:12:38 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=H1CaHgAJ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=gNjXqN+B;
	spf=pass (imf10.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769199158;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t1KU4jCZS6L/0xtiZA9NVZsfVAfFi3/ltK+jPGtmfSU=;
	b=XoAAtGxjy/yYLG2uOc3gPTKCn2G+JE/uU8fEXHzH8OyMiTFydZtwjN8aJoJQ/CglYqfKKn
	fbERmCx8UaIPqb/eCasArqTq1eVleSYxvE/cuoqM72BZFLKvqIYG6jQ+/CuHCkcpBVJh7m
	Nt2AOZ8o1o6ZuAwcU8PpeZCKVDQt52o=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=H1CaHgAJ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=gNjXqN+B;
	spf=pass (imf10.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769199158; a=rsa-sha256;
	cv=pass;
	b=b2cihw6kZRwd5vkysZ3wSkIa6MalG0KdfYLlpzZ3C6cVTS8NnNr0EmFf8n1MYQwyloYQ3n
	HpCpGJeyNGDTXLauFAR79Zkroa8O9X0+8sadBiD6SrNJtFXgg9y2igDKdh1pxvrN+N3Tsd
	dsPQPjN2fCJ1kC6AFzetN9qLxEZ26T0=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60NBnKCl2172813;
	Fri, 23 Jan 2026 20:12:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=t1KU4jCZS6L/0xtiZA9NVZsfVAfFi3/ltK+jPGtmfSU=; b=
	H1CaHgAJFq4MJScYkNu6p/uRSRAIh7RZ9/I6yQhpVPOsz8TI0fbAdI5AXfuwTHg7
	Kf25xLXtmvqZQpZn+0aw8nEWGjKegkh4ObwEaB+yzimTBPoZEM3+JArPOGjdbPAd
	ebM2ZaBBXRYxIWfq2VpCCJY9uVP/zcuZG2HsAUHU0cWpMQvrO4IURH3oJWf909rY
	g+qhevgL41L88mC4EpeqXsP4ODSnbO/zvFcyeduUHSQ9dVxzrByFRR47gbJvEW19
	6KgoC3ws8Gkn1zojgNqQvi2J91UufM+/2vPSe0Mc5ZBADX2ROKfCTwuqP+1tOnPf
	ig6o75Zq9ZnPdyC6FXKtCw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4btagd7k7p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Jan 2026 20:12:28 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60NJV0GY022439;
	Fri, 23 Jan 2026 20:12:28 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010020.outbound.protection.outlook.com [52.101.56.20])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vjmgqp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Jan 2026 20:12:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mW8rmRylzNguLYAvE8X3VNJB12+Asku93AHa/zQR3kzZXHyXSGruKhWxg2qW81srriD6+AYx8E3waxVq4t4roj0oYNRDpPrnGfz1LCrrLnZ0Ha/D6axMzhWUrQV+ecSlZeCt+OrsMNufCRYJO1LgBHvu9az/rmBkkt3/NH8qcd/umjxYVIor/8XqE2nacY4ro20ccFXLP/SqdkU4wy6Xp1SlWpbErWZAMF2rLEElf7x18hW82Pl/rSXwzxxpAXfA6YxOXgXk5IxEipt2Bsk9DZcYhbw/0vEO0NWmaCuS5b3dFTHF+O8/B7BgFaMIZL2au6CY5doB93zyB2n+joYAKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t1KU4jCZS6L/0xtiZA9NVZsfVAfFi3/ltK+jPGtmfSU=;
 b=ZJuaSzRqHf/zLMhJ+/eGBuu2Cie2D2ItVXjb77BzxWsvvIMF2+f1hmqgWLiXZ/Q5pIE0Lgc9JgE+Mqy5DrlYPResFjLxP9t5wlOmCtV0FxN4EkxT3tmZ5MK/zRg0cxjt7h7Wn0wujgxFhO8oECdw79Vpj9BWZPOa5HMThkmKnM526WPaj/wKaufIxZeAVynclTzzFhGmvQC4+KgMhSFWCuDaD4kPYvr4GK3mWWFh022pgtVuq/fm/SqKUiS+HoBGY3+2hume8xf0GDQdHuHAicPspzUorZ4vLSzrgKGoRSPWxeFU/HnSlFmo6r3n8YWp17ZRtO5GR4eAEsY8Pt9kTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t1KU4jCZS6L/0xtiZA9NVZsfVAfFi3/ltK+jPGtmfSU=;
 b=gNjXqN+B2ZJCOZcakSjOw/D0KyosickXnktk5z5HfsSIGJnQXLOFvAGiePeb+XtlGl7TTL+LO9OMSUIaPZBvVCm6wFl8aKzI3wCXXtGSk7IRGMk1nVVcyH9T1fxEB+5WZMXt/RV/shspQLmBo6O5swaDc7bvLUclzmeATHE+hPw=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by IA1PR10MB6877.namprd10.prod.outlook.com (2603:10b6:208:423::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Fri, 23 Jan
 2026 20:12:25 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Fri, 23 Jan 2026
 20:12:24 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-rt-devel@lists.linux.dev, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>, Waiman Long <longman@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <clrkwllms@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH v4 02/10] mm/vma: document possible vma->vm_refcnt values and reference comment
Date: Fri, 23 Jan 2026 20:12:12 +0000
Message-ID: <d462e7678c6cc7461f94e5b26c776547d80a67e8.1769198904.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1769198904.git.lorenzo.stoakes@oracle.com>
References: <cover.1769198904.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0286.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a1::34) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|IA1PR10MB6877:EE_
X-MS-Office365-Filtering-Correlation-Id: 82559725-ecbc-40e5-760b-08de5abbb959
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zyuZ9qyFy/NXc/M9if6X3aKwuuIyBb6DJEEhNXp6HNdzG6jaCZ9YiyhIZ2J9?=
 =?us-ascii?Q?8pZBYkWZbD43g//rT5eCuhfcTx8M3V6siylUZdpHW3f38je6yhLQ+ym3V1uL?=
 =?us-ascii?Q?Dl5HS0sHvGeuxRpvyv54VxnO2IGOyxzgySFm3g6HVHKqh/IwQPuk5g3p3Wr2?=
 =?us-ascii?Q?AtCDnGiLeDThVAZ/r/RmzqhgX55RzeiYkUQhgDKAUG+nK0AyiWiDc8hn9T3d?=
 =?us-ascii?Q?dzYZVDUF0bxy+M6F5ZlN6tDUHzDgrGJFkGNJbvOlusrgW2z7MqLxSW+vMULF?=
 =?us-ascii?Q?Wdayj/9yOEAcjYFEWIoUuUAxfgyRrAM6/0OFRwpUpMWEpHwCnTw+oB5QhTYz?=
 =?us-ascii?Q?EZ6Rs7gUoj95BXaCCFe9Ixib0nBG/moqa3ipikRoYaDeOMRZ8GkEMJz3km9J?=
 =?us-ascii?Q?QSRuKHRsOflgpR+5B1k0erMCpcc+50JrF329SN6gA6KuXJK26oLCvcbprXPI?=
 =?us-ascii?Q?ou5HzkK5km1VYDe+KXyRtRGgr5a9Q5dkcOnlpYxJVAngkY/Jgj767Ycui41V?=
 =?us-ascii?Q?zR943zpCJViteA6LtdJQUuljZCGKaNsIpC2ZWTGyUzzraVyfgACsQYPGQb/0?=
 =?us-ascii?Q?O/5ZTxAORqzc3arW9UxvYYcjdDgyjemJIoDvH+rhQVbWsur9gD+EAPN6ts8G?=
 =?us-ascii?Q?F8aofhqPJ4tjeTqR6MNYYklyf5kKDjeYGYANnuMTK81PaWCsULGzuwyG/KSI?=
 =?us-ascii?Q?IJWSg8muI+D6YfW06hueabixQcAIzuAY6c4vN0L5Mi9d5Es0E+eUsG5VTk4O?=
 =?us-ascii?Q?3wW8LyHinf+XLWWlUzN74PdWhJztp17ayeQpUGA2EivGIhsR7a8CmBrBKens?=
 =?us-ascii?Q?Oc4KWO4i/fmnQaW3cC7flzcdfXpmZaM6XR5F9SnO80twm82wXHaYJV3Fxzg/?=
 =?us-ascii?Q?yzLvUor5IV4AlSAVIorVdqHsrb6cU6ilGlkaFhrFm8nsRktbV4qFKf+GcUwm?=
 =?us-ascii?Q?IKB96/jYq71SfN5LDDCDw6RD/LcTlLmhUZOdlJMJfxuA9xoUwxTBQ9d9omT2?=
 =?us-ascii?Q?D84cwHDcz4fsGxA+qV4n3A9Xl48+oLkGW/pwus6TjwRTVhG6Yx+Yi6TOFGty?=
 =?us-ascii?Q?J4cPtkGwqYGyYTQyL0on1WNQypjwsE1Gqc0ruwPOjaeJ4GA5g/mbxlfe1P1n?=
 =?us-ascii?Q?EnGEMlfqV3Co+x16p1LbanzEBaaYjt2Buc56GcpyzgK/z8ZZlfLjYOrZeLJg?=
 =?us-ascii?Q?oWFQI65K0Dx/dCkFUFHPuiOsouWshgbZzZXj+NUVfbrKAGBomulbZCTR3Upr?=
 =?us-ascii?Q?2tZGDcKYiWK/KHlrZLURjAFRoAJX6CDKYqeoFiI4NeISEmEKcf6G5LkbBu4U?=
 =?us-ascii?Q?oP+nEF1GpdzHM4Zk4mAhq4SsHGetLUtCicCP6fEsVHt7Pkkb1QxEinZBR1kB?=
 =?us-ascii?Q?zFNexaRoiqDQFPDVdvcDgC8n4Rml70iSoVREZDyrY94Wx62rkdfdke7xOYbP?=
 =?us-ascii?Q?Vqr0yxe42gF1PMmswtS88pPxULTqoEAYGb/E6067dCOF6Y+hOCm2E+DUPT55?=
 =?us-ascii?Q?2wbu0weFEhwrbBiUCjMAIsMkFDZT7V3lai4P9I90wmBMSq0CpQ4FOVhRK/p8?=
 =?us-ascii?Q?XrXSrF6kJnbAI0IqCeA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sNZrUub1xMPomMB+kWP9mRYc90qsRS9NBjZJ2FVMHMjM9xE/xpgWLVmCEQiU?=
 =?us-ascii?Q?Zo/3gN9boKxkf3EdTDOiKT4h9UlOVb8ESDes0OljccOe/kqWxYHNtI8tS7bK?=
 =?us-ascii?Q?KbVjE7xp0MBR2b/e3U5LJRuG7bBBSjPx7GI9sPcdztebdrI19jUBWNx5ktb+?=
 =?us-ascii?Q?lo2p5MJymQgYuZl43SByph5D7fl6u6TC1umFzC3OUFRoSHJV5KtJ5d2UpjCM?=
 =?us-ascii?Q?TnZ7Gv+FCvl007u9kOm/sKxUYcDaQGWuFh6/IYUyNBR/cYc+wkeNg4Omi4fn?=
 =?us-ascii?Q?i0lCZFSQNnj9qQWjkjg2xdaKWYIrDsZ/nRB8knJ6f8+Y2zC516gYsounhGDT?=
 =?us-ascii?Q?y1rKIZ+YbzwOYii3OilVTOR3jvJsjDYy/bqQ3jh7zbgijktn7whOyL1NHj8o?=
 =?us-ascii?Q?DzhQz1wJkawj5sdTbIfCxpxysEvEi45ZWFMZ0BNeYEmEpHU5aaY4fDOK+Yqo?=
 =?us-ascii?Q?HyYmWDcFBZ94+HBIdz26D8E0UXDmwSAFKotSH5Zdh0TbWagAVANjFRwYk66t?=
 =?us-ascii?Q?Zt3V2pcd8Ur8P0OFYahvTxWoe9xp910uhe9sT14ErVqT9DfR+TtoZM6c45dl?=
 =?us-ascii?Q?uQmmTS6zOq95pO54oXSdkUSeQeZ81XbO4gmtgQJTy5yIiXtzRu9XMhwVqu1t?=
 =?us-ascii?Q?MW+LbbHOMxZv/4OfrrSVQ8MFR01nXmBz42jFvvmqhbwNmNrWqL7JM3zn5xPq?=
 =?us-ascii?Q?MKS9/porVG6squ/jhtJih/lOFPbWS62cpYqz+Xck1ra+iryyDCxTZiH/l+Sm?=
 =?us-ascii?Q?mR8SkkPFu1G/xR3XT6FQqkaXcpyEoo91Z6Eyrx+rG942R7VFdYZaiY/EIb61?=
 =?us-ascii?Q?VaACaITdPUn+8IO/fxU/2X22Vm+67qqP+NSw4TsVZ01oU1DM5oK4MTk4BaRN?=
 =?us-ascii?Q?1R7Fi7SI6+eKVPXFHJVxQIzPDo+Vj1+GuaS6HJOgX3FUQ/+sKTwXXR5EbB2r?=
 =?us-ascii?Q?7A7myU1o/eg4cfCQ6sU7DFFxfNry00MArDTP9Rc9vKxp5DzyQzsChuX8F76U?=
 =?us-ascii?Q?mYxfCWMMp5g3oLHyg1s4vwiOmg9JBNJgGTNDj+Vf6e6af+YvUL7FZV+DQWQG?=
 =?us-ascii?Q?PWZrlDbD1FHbXWOakKHgo6Xt0XCkKetrvIVGfOPRE4vofaLbsXnqxNXAIxRZ?=
 =?us-ascii?Q?v4FF6rsz4AQmFRkHwSERbzYFwyRjgqIjUrY1fRWzptbuIp9+YZkDyCAmSSO8?=
 =?us-ascii?Q?jLIYdkO99nw/YP/aNMOkcBDGvSpzHeczOQjkGNGPrCqjapzTJJVkHPaRLWS3?=
 =?us-ascii?Q?HW2dXSFCFz1FEIO7Ast8VxQ88R010xXnRMLfCcd/5uRiy/4u+YnNud0z0yp0?=
 =?us-ascii?Q?CqUZnRYIr/cV0TNDhWWOk+ZLnScbt1WsR0+0HUmK1iF9Fp+blnKgPitHcvT2?=
 =?us-ascii?Q?d5MDTd2YZxVw1oEJXXPoEHrPwZj7Yk1NGYuuNiigWVsz+XrKIA6TUZC1lmsj?=
 =?us-ascii?Q?zHCO1FVSg3OMDsNsbgIZq5LHKX+eZ6RteqJZpUE6qNlbHx99LzJfl0wqxgBu?=
 =?us-ascii?Q?26t5RYWjkc1ulmoLtlF/hYnkXOia1gw0Glsmm8onCnQb5nYPXrDubTS83emE?=
 =?us-ascii?Q?XaFqvHgy6QVTs1OybXpUtR0aaUkhYRfPL1ce1RL3wL9OTvr7AKPI6FISiyZK?=
 =?us-ascii?Q?ftDAiNOIGNE9xE4y+uzDFtBrQGoYEE9OG4cWXwNvwBIu7Er0AiML/pnJgHhz?=
 =?us-ascii?Q?t3fLFZpctIvK7voiJSKhcz2x1t+Op46yJIg04hXgftFyzDVDQtcFRe9Mk0Ri?=
 =?us-ascii?Q?qAlbSq3vr6Pucnz/dxuEX5vo7Q9288E=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	chg8iKCyiMRg6KWfq0v2XkKaOuFfsEm+44uu3Ttr3QGX6o74uxyDIBtN66Zke3jWImuLgAqIXJRBO1bQXx3HgStiheIDQLCjhvmvr7vvCyXiHno26kfTS0x7Mrr6xwUN/O8Wsfd0MO448Ezf+atLYzXk0bcgjuOk3z9hPeHTQ+cxLA3DpZ5WVUvzUxhzeQrtC5vFBMQWhNDpBoe9jUD4qB4nt21Vvw3bavD9tOM1qfvc0/bgyenPiW1PNm1sY+uRdx/2uaHdlHEa9ctceNO6guOJQ5dQoU+PGv8G5OeYriTvGEQhW9V1sjFB0MJIhppR5rD7yFi/QvUdPZsSYRKXjRx2u+HmTi7T/BX2hcfvDnpsaj4YNLbtQBYcIbVC8vONsSIKm1rvhVI6x/HfvBDhYa2brBOfmTI3TCjBjuHtfYkL1UgUVvazwsIYIpYXZIlrc/EmyPO2GKkuHZvtimcSt1SRH9xfRbTptc87iHl7i//RSCtZbUZj2TyMuu1vFoEonUiah8cTo2TSTrltVimpKGDKqD+ipqzyQtdkznfxPSKNxYEHsvew58nQuYvirFKo8zMXgspz+cFz4aJtOtxuyUX0PBzlLbrbG2ISsFxWT0o=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82559725-ecbc-40e5-760b-08de5abbb959
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2026 20:12:24.9399
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P+k38Oy7ThRbVIw4Rb0PwbWvhcU18ho6zujVfubQqnbUPC7H37WCPUtE6CPtDiB/hrcRuVHH/BnapWTo89CkijOGy4fRMjYm4Z8cc+IXUmU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6877
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-23_03,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601230154
X-Authority-Analysis: v=2.4 cv=PqqergM3 c=1 sm=1 tr=0 ts=6973d62c b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=ZcgAvwBTlqKtWV1XiNIA:9 cc=ntf awl=host:12103
X-Proofpoint-ORIG-GUID: Yz6Ne3jnDp1akr6cqYXEYgP4yBjRcYfo
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIzMDE1NSBTYWx0ZWRfXytIFOWyPdvRb
 FY1kGZSI9YtvDLSFdzAEJ3CiseRsnNdQW9WfoxU9mbvUCJyD8BPs5OAeK64wJWFe9vbMdLIhz27
 s52wdYn9M7Z5zpsKYbURLqnfB4U60ICHypAnIc4yux39EgDRmjtryseiUiZhh01zZ00klR0Zw3X
 +Z/phOmqRR6SAhtsTd6YquZLx5OnlSxhWuf2M4wNUgEi//sILNRkuAVsNMU0shENjCu5ZfP5U3L
 MxqWf7mWJRMBTD5YkveloQFtPgffjiXgbzEqjB9kDqqWUgBVxBpvzjHx8rK5N4nina8EmuG5MJ7
 2aMCN3yTWOYSnHB4/Wv0dQZZs7OcufR/seAuLOCnBofSn2ZBY3Dx/1vpnvoTNAFBP+e4X0N+B24
 LMMSN+WHvWgcrpOgjZwpP1mqlT26uh4xBXohmNHTRHJ/HqYDvzSXwHIheteQfHwSMBHVJr2bru9
 q6hxz/OYf1ybMNT9EFnUBkQuCRMq+Y4mQ7P7RvoU=
X-Proofpoint-GUID: Yz6Ne3jnDp1akr6cqYXEYgP4yBjRcYfo
X-Stat-Signature: 498wutfhqamyoccsckgjjc3qhcu1ppzj
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7D778C0002
X-HE-Tag: 1769199158-711421
X-HE-Meta: U2FsdGVkX1/LvotRRvcYtPiGSqqh8neNIk9Re7jBXc/Yvlo3GW5HmP+mL7NwaeCmn2fMm4o9Okb1XQi83aR1zB1FajF9k1uFGHeGIhQHgvYIDlW/aHtvsT08WAAWI0fi8JXNrhm5i/NJXA38ZhgDCX4YWvKhCxXhScLJqSAYYmaU1CtdeOn6wsiJOx+S5zUUSJNFCMhqGhhtrx0Hk+954aCfPfoYAXkhKFYmrl3LcMrXQGF6IXx4sbbvesoUSKjVgTqEtgp4IlFs5QXErvwr1oGUelLz7PFvbLvSRUUqPhTnz6qPOQj6a0rJXrXhcrGYIriTy6NctW9eVW8JoaxpvTHBtsv52x0o3WRN4YyZpsGrPp+UMX5FMYvdx9YrmhVKS6JWQK47J32IkPQ7fMwvMCeED8w57qXKJfMlRat07AWSdgau+Z3cXm2WFFcFh6FDmx708Pr8SYM/J+fRxtIfIzan4ypkfy9VeXDuhfUj2YSFY6IECMm1d7VYBILrujvksTfthH2d64dkHwfsq+klWx2EwTZfoIvuHYo9V1EltG4MvNb1Lpf4FTt7QyKc9J7t0YSOdUJQtjCfdHg7XqY6AUisUX5wkY/Ai7PYtFLlI893eh5UZ//ABY3JJk8YvPUjWuTM5ABIhEVpuYq5sA5d0h7qtzx2kJJ1uSfVMJO0ENH0ENsj94UVqtK/lfiW3mHpH5zhcXGXAuMvGCVqt6EXABjcx9Tu+uWhXCrk5m5LizzidOwxxRlHBOvj6I4gMmUctfbOfcL7EkCkmJHm4vt1V8a2a8XL4lGymo4Cm/lIEyRYwsIZeggZioUNrT58hYa3pk2Zmc8IGNX7X40DRnmt0E/sTFmpA/QqcR5KPbV80tVj4p3D51kKCu3mIX1nz/l3/34Eca8XqWOOaiBsrj0nosmAjg4ly/q6jpWIBTKX0iaTf48FPy1NJ1SQMOWDfL6Jp/reT8sAlJxVCnZm5fq
 oPLwEwW8
 xFX327FwKJuURerk0y6xBArMuXeXMAdo5X6WH9G/+uUxSysy0xnW7HM3wrhiEwy/rIyRqQLAstX+cXyAjR3OM8/J86R4Dzf48JyZAbpIOQEBhd6Oq6YU6BS4IyTKXaKwa40RcOoemImHVqGOZraK6HFxTHh22iZPlF57T38P5Ei5NugRsZJU2Wf/9A/APR3Mo9ciM6uRugD4vtFeCOC87+9LxbTHs59wOX9PS6eGmzOBi8Ra7ePItktF7ey0vxbpS15f986naCZksCyuYH+7qtefNGDF+J/rej+NhsvhHOMHb2nnexW1jZpyclUkeUXZG88sevWfvs6EpANh6V8da4zYQgNwVNqoM82IVizBh03jbQQEbUq+LNY46oXGBhLOHMlQyge33Fzn1VK33bf3V6v7VrnogujB/ljTGi222hfcpGmI6e94AOjEYWyz2qC1qV21L23JuaTMnqq3vEX1p/lIcF8RfLSJM5pu6HCrHKvT+U+LrgoEGiUhqF6A0PNrnGA5VNGl7tJnRUTCXK5yFt+xCtSDdy0GB486E9w09ykyK4o1IP/WNiOcvmi0l0tzxCI98QJVdV7DNDMYkGn6CURpHe1VXAyEYGJLEVGHRUGqzFQ8JPWLGsVOVTBox35Jk2ui/ApPzZBAUSuNW+SB0L0WT+yOSiqljUmnB9VQlZjX6yrxN2hEUDD3RAAE4p9u+Ac5TlcRwH15QciDMdzadPjxzR3ftJlMSKOdo/uUc/BLeJNx3PoRVOUTOcJN93xTTkRBY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The possible vma->vm_refcnt values are confusing and vague, explain in
detail what these can be in a comment describing the vma->vm_refcnt field
and reference this comment in various places that read/write this field.

No functional change intended.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 include/linux/mm_types.h  | 42 +++++++++++++++++++++++++++++++++++++--
 include/linux/mmap_lock.h |  7 +++++++
 mm/mmap_lock.c            |  6 ++++++
 3 files changed, 53 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index bdbf17c4f26b..12281a1128c9 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -758,7 +758,8 @@ static inline struct anon_vma_name *anon_vma_name_alloc(const char *name)
  * set the VM_REFCNT_EXCLUDE_READERS_FLAG in vma->vm_refcnt to indiciate to
  * vma_start_read() that the reference count should be left alone.
  *
- * Once the operation is complete, this value is subtracted from vma->vm_refcnt.
+ * See the comment describing vm_refcnt in vm_area_struct for details as to
+ * which values the VMA reference count can be.
  */
 #define VM_REFCNT_EXCLUDE_READERS_BIT	(30)
 #define VM_REFCNT_EXCLUDE_READERS_FLAG	(1U << VM_REFCNT_EXCLUDE_READERS_BIT)
@@ -989,7 +990,44 @@ struct vm_area_struct {
 	struct vma_numab_state *numab_state;	/* NUMA Balancing state */
 #endif
 #ifdef CONFIG_PER_VMA_LOCK
-	/* Unstable RCU readers are allowed to read this. */
+	/*
+	 * Used to keep track of firstly, whether the VMA is attached, secondly,
+	 * if attached, how many read locks are taken, and thirdly, if the
+	 * VM_REFCNT_EXCLUDE_READERS_FLAG is set, whether any read locks held
+	 * are currently in the process of being excluded.
+	 *
+	 * This value can be equal to:
+	 *
+	 * 0 - Detached. IMPORTANT: when the refcnt is zero, readers cannot
+	 * increment it.
+	 *
+	 * 1 - Attached and either unlocked or write-locked. Write locks are
+	 * identified via __is_vma_write_locked() which checks for equality of
+	 * vma->vm_lock_seq and mm->mm_lock_seq.
+	 *
+	 * >1, < VM_REFCNT_EXCLUDE_READERS_FLAG - Read-locked or (unlikely)
+	 * write-locked with other threads having temporarily incremented the
+	 * reference count prior to determining it is write-locked and
+	 * decrementing it again.
+	 *
+	 * VM_REFCNT_EXCLUDE_READERS_FLAG - Detached, pending
+	 * __vma_exit_locked() completion which will decrement the reference
+	 * count to zero. IMPORTANT - at this stage no further readers can
+	 * increment the reference count. It can only be reduced.
+	 *
+	 * VM_REFCNT_EXCLUDE_READERS_FLAG + 1 - A thread is either write-locking
+	 * an attached VMA and has yet to invoke __vma_exit_locked(), OR a
+	 * thread is detaching a VMA and is waiting on a single spurious reader
+	 * in order to decrement the reference count. IMPORTANT - as above, no
+	 * further readers can increment the reference count.
+	 *
+	 * > VM_REFCNT_EXCLUDE_READERS_FLAG + 1 - A thread is either
+	 * write-locking or detaching a VMA is waiting on readers to
+	 * exit. IMPORTANT - as above, no ruther readers can increment the
+	 * reference count.
+	 *
+	 * NOTE: Unstable RCU readers are allowed to read this.
+	 */
 	refcount_t vm_refcnt ____cacheline_aligned_in_smp;
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lockdep_map vmlock_dep_map;
diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
index 5acbd4ba1b52..a764439d0276 100644
--- a/include/linux/mmap_lock.h
+++ b/include/linux/mmap_lock.h
@@ -130,6 +130,9 @@ static inline bool is_vma_writer_only(int refcnt)
 	 * attached. Waiting on a detached vma happens only in
 	 * vma_mark_detached() and is a rare case, therefore most of the time
 	 * there will be no unnecessary wakeup.
+	 *
+	 * See the comment describing the vm_area_struct->vm_refcnt field for
+	 * details of possible refcnt values.
 	 */
 	return (refcnt & VM_REFCNT_EXCLUDE_READERS_FLAG) &&
 		refcnt <= VM_REFCNT_EXCLUDE_READERS_FLAG + 1;
@@ -249,6 +252,10 @@ static inline void vma_assert_locked(struct vm_area_struct *vma)
 {
 	unsigned int mm_lock_seq;
 
+	/*
+	 * See the comment describing the vm_area_struct->vm_refcnt field for
+	 * details of possible refcnt values.
+	 */
 	VM_BUG_ON_VMA(refcount_read(&vma->vm_refcnt) <= 1 &&
 		      !__is_vma_write_locked(vma, &mm_lock_seq), vma);
 }
diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
index 1d23b48552e9..75dc098aea14 100644
--- a/mm/mmap_lock.c
+++ b/mm/mmap_lock.c
@@ -65,6 +65,9 @@ static inline int __vma_enter_locked(struct vm_area_struct *vma,
 	/*
 	 * If vma is detached then only vma_mark_attached() can raise the
 	 * vm_refcnt. mmap_write_lock prevents racing with vma_mark_attached().
+	 *
+	 * See the comment describing the vm_area_struct->vm_refcnt field for
+	 * details of possible refcnt values.
 	 */
 	if (!refcount_add_not_zero(VM_REFCNT_EXCLUDE_READERS_FLAG, &vma->vm_refcnt))
 		return 0;
@@ -137,6 +140,9 @@ void vma_mark_detached(struct vm_area_struct *vma)
 	 * before they check vm_lock_seq, realize the vma is locked and drop
 	 * back the vm_refcnt. That is a narrow window for observing a raised
 	 * vm_refcnt.
+	 *
+	 * See the comment describing the vm_area_struct->vm_refcnt field for
+	 * details of possible refcnt values.
 	 */
 	if (unlikely(!refcount_dec_and_test(&vma->vm_refcnt))) {
 		/* Wait until vma is detached with no readers. */
-- 
2.52.0


