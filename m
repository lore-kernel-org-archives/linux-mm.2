Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F72ACC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 14:09:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F9086B0095; Wed, 14 Oct 2026 10:09:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CC1B6B0096; Wed, 14 Oct 2026 10:09:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 795C26B0098; Wed, 14 Oct 2026 10:09:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4C31D6B0095
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 10:09:21 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E94DBA817C
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 14:09:20 +0000 (UTC)
X-FDA: 85321414080.26.CA15FE1
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011041.outbound.protection.outlook.com [40.107.208.41])
	by imf05.hostedemail.com (Postfix) with ESMTP id C30B810000A
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 14:09:17 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=b9EOxAr1;
	spf=pass (imf05.hostedemail.com: domain of noren@nvidia.com designates 40.107.208.41 as permitted sender) smtp.mailfrom=noren@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791986957;
	b=pLzrXBecitMDSuGuCck8bnyuD/KGp2MgVrhJb//C7EMjuK0eD/LoQmfjrPBVQBb169q1kx
	A2kVWPFS3rns4Wt4e3wHzTHEd0IuWFanKQ07zLg9y2zQe6394PELM13iY6wU8G0rnaSVZQ
	6CrJaP2sfspckwOazot9nzEfI4znpfQ=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=b9EOxAr1;
	spf=pass (imf05.hostedemail.com: domain of noren@nvidia.com designates 40.107.208.41 as permitted sender) smtp.mailfrom=noren@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791986957;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=KDZ7kG0qZh8rz4IuGHG5KYxEg7BxYg5G2Zu4YVQyIC4=;
	b=Gr4GFFTIEcZU49cyNi3ujHkPkqfPhcsY+rN99botehv/4ww/8xtH7WO4l1zvoPv9xfRqZ0
	U5mj6IfkVieVqvENHXjRnWsPSk6FayughLDWwabEj1haFiPUtJUBq7y9KmpZLYbuE/ht91
	gwoFuf3ej4lTlI/qU1al8oZ+othvdag=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YrP+8MBuVtE8k1A0J2vr+tqqPIg40u+zb03mLsW4c9ZxDFPczoC/437F1yJyALTHvUvXZBrTLHO66GJvw/NtFe1mczEI28aShBM43fadZ8si19BoGsWvV+0GvmG67ItEGLum0ARMrh3HZ6avGAIF5k4nOpDDthSGA9ebg7w6Z/1vJ+hgRcHkZyT+hxu4COsuR7Vy52b597ycnlIeA1TgDK9lNogyWBQoiY0TX9K1p1iLLjW2tnB7dANLzHBqmeHlXGLkO/c+rFB9Vc2snNuYsD9nZqmOkpvReErobjvz1FLk+zd/e2LajNp3Wcuy89EndvWYg+TZ6D8RL7B+ja125A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KDZ7kG0qZh8rz4IuGHG5KYxEg7BxYg5G2Zu4YVQyIC4=;
 b=bZ8+VN+y+zFM6zV2zTMdP8omTFaE11GZfoixuCTSwAFdq/DT7EOQeaUtibKVmTlwHG6BzDOQv7L+a0YrkLI+2w87weBnmk7o0drxPsJa1miaJvzUIp6r3WxDWH7GLTfP5KGD9wQOBTozPn87qVupV8vpSzfob+qxQ98YuTz39Y0jF1JuwNphnWu8NJjRjJAWymL9sMPXtd3zen8FDZYIbaH4nivoTcvUABpNTl76l4j6A2UwBDJEo/E9VZNXkJWPhEJGivsaWGpbzinIPvmrT8tHf2zbOq9EyNRu1LrIVFZ/olHKI0UZkxbvaRCUd/P/mHVbksWdJ/e4srfvpyhKTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linux-foundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KDZ7kG0qZh8rz4IuGHG5KYxEg7BxYg5G2Zu4YVQyIC4=;
 b=b9EOxAr1Eh7RgwB6UrjX4PuEZN7wjvh5r1ElCB8bM13EsHKh6SM0Q5fuftGAEKQHTDVYFmUDuLkf5aMz46KS1cYYS6x//wZI2dY0jV2H3Xb8F4E5h0MRC6xcf6WBBp5BCpKiV3dihA1qFm4KO4QE5qkXVvwv/+oI+LZojlX/k8MYV8E8jO/KSgQGCzVAo6Fg3LKRUjKY28J8iCLXV74haoEHdpqGjcSsqCPCKwWHSye8Eh0hCT0yyj9tlNfI7dY57xVvRdVvTdtqKgVepMqxBB1FUyHG6XpS9yGiNWvg9GHlOfoAjRC6coACCvzkeV5UG3Tk4V/vgBZanpqfhKTJjA==
Received: from MN0PR04CA0013.namprd04.prod.outlook.com (2603:10b6:208:52d::18)
 by CY8PR12MB7658.namprd12.prod.outlook.com (2603:10b6:930:9e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.23; Wed, 14 Oct
 2026 14:09:08 +0000
Received: from BN3PEPF0000B374.namprd21.prod.outlook.com
 (2603:10b6:208:52d:cafe::42) by MN0PR04CA0013.outlook.office365.com
 (2603:10b6:208:52d::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.20 via Frontend Transport; Wed,
 14 Oct 2026 14:09:08 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.233) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN3PEPF0000B374.mail.protection.outlook.com (10.167.243.171) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.546.0 via Frontend Transport; Wed, 14 Oct 2026 14:09:08 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 14 Oct
 2026 07:08:30 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 14 Oct 2026 07:08:30 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.49 via Frontend
 Transport; Wed, 14 Oct 2026 07:08:24 -0700
From: Nimrod Oren <noren@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
	<liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
	<rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	<mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>
CC: Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap
	<rdunlap@infradead.org>, Zi Yan <ziy@nvidia.com>, Baolin Wang
	<baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, "Ryan
 Roberts" <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Usama Arif
	<usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, Brendan Jackman
	<brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, "David
 Laight" <david.laight.linux@gmail.com>, <linux-mm@kvack.org>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Nimrod Oren
	<noren@nvidia.com>
Subject: [PATCH] mm: stop recalculating min_free_kbytes once set by userspace
Date: Wed, 14 Oct 2026 17:08:59 +0300
Message-ID: <20261014140859.1006967-1-noren@nvidia.com>
X-Mailer: git-send-email 2.45.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B374:EE_|CY8PR12MB7658:EE_
X-MS-Office365-Filtering-Correlation-Id: 17c400f6-7e0f-4ae5-2895-08df29fcb6b6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|7416014|376014|36860700016|23010399003|6133799003|18002099003|10067099003|11063799006|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	r1w6ugStFEO4LoHcQASXd+QE69mXzcM3/0goVzzTan0P+B0B+2DpfqlnN8sJbivTFR9TAdC98T1dr9lr0E1u9n4AYE2B1gI6rBmW9EnSw2K5fLjZyjk0358eijMLY1C1XTWrQjS2YmoKr5gaspGluCua+vBdVQ4cR6Z4OohnxeaOVeTAlseJYN7jtKmaE0jproGBzA0Ps3dEUYvETmH9NSKbfIAHeVsgZDK0vd9hfJR3mVX7Fywxz6AyVTM1oQr+iia1DZ+QHm9kMiH++ckv5gMHMfwAClt3fOLn3h0hIlSS45SsNckTl3Yb1/eDMMgu3Mc7Lx6r+42ih7L2IiSoeOThzL37SCwfsK/FIi+eDsd/rUh0djCMyeR9qFcJIbYEX2jJVmbFRRO/sU/QK+GySMrlwDB/4jKMLx7AI/lpZz4aCVyDTmME6NlFX5tQdm65HoBbAoOmj/37whFQZ87d8TNx43D9MOT5T6rTPu9prFfEtWwDUfpxikW/CCw8L9n46pt474GOI3JMeZ+OccUG5npdtGdYr7wzwLQFLm/0ge8KMLEG47hbDRyAeQ+pkYJ29FIundjMJ07/KuFRSxsi38ForO0G1aAywpepgvGIwJqn6uobrZHQU92Yu9p2AVd8UPwwX0gGVZc+S7gctJmzxhY1BlBaaeWfee5/xYQAxEcoStNj3mUnqxZdojwoL9VSW9LXGaaeiqX3BbG6ruux9g==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(7416014)(376014)(36860700016)(23010399003)(6133799003)(18002099003)(10067099003)(11063799006)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	CB50L1m7Vql5VMHcOKsYmtO9NlMOj0gGCYV4bOeC3Z2ytcBgrNQPnNJ3ocaCZnv2y7gOVnXrfQKJVxzKIy2+w29OaK+HFMRHuQphutR6o4zzMSCzqwR6THZXVof0um39fhbudPsKGry6c/FEpc1oiLJ6ehDzZ0wahjuP/oMzoJltuK5yE+AFtHEKURSBh27wzFiZkIXrrrWQjXunBdK5osa6+YJFjZfxWI/+A8BNnNStQ+7ki8g67y7L4mtTwgV4wni+WLKjWpIDChnEo3r5hV65F3L0m1oBBAiUh3Cxi/ek823/L/ucVcRThX+R2Png1WAFqWAR4u5rM5mnW1XjNtJXO6oxXeOxbWXy2ZsTh9tcy8yo0WZOnKiwl3Mnu3LUhlSO6dxbKwUnxFvc3QVboWpBw4Tq5k02gsFTbQIZ6t+ibfWLAOhGVvzG3aBGouzN
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2026 14:09:08.1983
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 17c400f6-7e0f-4ae5-2895-08df29fcb6b6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B374.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7658
X-Stat-Signature: zpx11zkwftqec9br7amiz4k16gbg9jrm
X-Rspamd-Queue-Id: C30B810000A
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791986957-775874
X-HE-Meta: U2FsdGVkX18Mv5OtFlSV0bdCCLD5QwGqU4Fal0DyNnFFo1JZ19KmXc20hV3xc8YWEv8tinBssglyugGX1N+Xf8n8p0SgCUWcIebtI26d2dWVySUxUfA594UUqSsLFlfpofDwafOmT/x3TnWxJicwid5OEkeYnP7dkU+tafDorbjyxtnVnLaOgnQA/T2S71IcWWrQ1uVasaCyT8nCLgfew0KQVfQE4NDZWrjmV4hukN7BaIfTUTVhtNR0h4YXtdec8TMzqwdZ/ITIwXAM6SSRY9T6hehfqv06cSgGOd2pmywliCV/Df2qpP/9xmqe2rf05EOpW9OmEvoLBiagYHJ5opJIP93id2FAhEunMoNs9n/o2YnuSdoAIA4kkccfSmxZF7uwdn+DTOOqnNPnh3UaEd1DTUZhCadUeTUR1btpOc/Yl5OmbFKfD0uFgnhNd2JuGvq/DxZYPVRlo00xAv5wHT6EGZvQrkwpkiM5yEEhtRk9PrKTkXNcV9/+VjQ6XoI07pbd3np4yhJRnptOht/KryyjOeJM9DX3VWvwbVpLSyI2PbGRUZA1aIbvLOrFSarjwrU/hhniDsajhSVtuAGsvnSJ+/dohLqim3ZRcP6/5rMJ5mMJd2Rpa09ZV6p95j52jHqRkXV9pKo1KLrEowpL+N4P+ExDHJ69qQkcq1i+5rzTdCJef6YjIIB7B8Clyb5aMl0/DSL60v+OUK8gTWPu7QECgjycdqvK0jFgzRwiStndNdcKoNPqQtqks1psC+MnKnmQy1TitvSa1wp+oiBbvqXUBH+bHqYOmZ3pUWEAmUunpl688Yo83z/E5eseGdWP95zod0Omos13PudbwfQ6vISkF8Lr6+oSsy15GRjQw6Df0yCWxDf+iXVqJftjhoeGrIpQ5hFmEnZXVq7Ql4R2iDskaA7D6V1FBYOTh8zOsbc1TutwxuOwWD6NBjHLaAw+LCro+YhwXztoR8JZbmu
 vgB+dzf9
 EJtQUA9cGUjfo7s2QuZNsuSNKx9D8GE8K5rGZ/Bt3I2U6gENrOkHc67sTLZAIjnWjUAEnJNqdNydmpQIyacrz8QY/7CRcMDPq/lVeQU4qRgqd74hwai4tPXmC/rqzQiuyB155iT0LINbZPt19PNSSNrfnGGbNcquEUK1cCnKbugaTjCgE0p0B4dXiYQOSXP+hW8uol7g6AKV24Wud856zS9KwkRyspHGp17eVCP/EXAnWYBsHogvEkF0o7+5MQZB5G2wv6lGMM9SamaSqNylZqom1kfQQ/9duprI9cT3V5rlHy8UFTjU5ApX1YucAnaEJ1MrGhaotuuh9xbGICFNKmgqPDSlWQdXYsmURDhX3wuv+Q3WsNpAiOU8wUwqLKIYJVesxFKNLYQVvU/8NmJCUrWoap/C+oJE+iHpguNg0qNzJGOg/IPm+dSyF+kUux0WTIKbn6CZ+guNXcUaCEL7aJYFtaUmDnFrKuy+AIM/RhGR4mbQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

min_free_kbytes is recalculated on memory hotplug and on THP sysfs
writes. The new value comes from calculate_min_free_kbytes() or, while
THP is enabled, from set_recommended_min_free_kbytes(). A value written
to the vm.min_free_kbytes sysctl is replaced whenever the new value is
higher, so a lower value does not stick. This matters most when THP is
enabled on configurations with large pageblocks, where the new value
can be excessive [1].

Stop recalculating min_free_kbytes once a value has been written to the
sysctl. Systems where the sysctl is never written keep the current
behavior.

Link: https://lore.kernel.org/r/20260716173504.760369-1-noren@nvidia.com/ [1]
Suggested-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Link: https://lore.kernel.org/r/d202dcc3-d7d7-4e98-a9a5-3137cfbfd041@kernel.org/
Signed-off-by: Nimrod Oren <noren@nvidia.com>
---
 Documentation/admin-guide/sysctl/vm.rst | 7 +++++++
 mm/khugepaged.c                         | 7 +------
 mm/page_alloc.c                         | 6 +-----
 3 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/Documentation/admin-guide/sysctl/vm.rst b/Documentation/admin-guide/sysctl/vm.rst
index 5b318d17aa4b..189fc57dac5f 100644
--- a/Documentation/admin-guide/sysctl/vm.rst
+++ b/Documentation/admin-guide/sysctl/vm.rst
@@ -539,6 +539,13 @@ watermark[WMARK_MIN] value for each lowmem zone in the system.
 Each lowmem zone gets a number of reserved free pages based
 proportionally on its size.
 
+By default, the kernel sets this value based on the amount of lowmem
+and recalculates it on memory hotplug.  When Transparent Hugepage (THP)
+support is enabled through global or per-size controls, the kernel may
+also raise it to help keep pageblocks free and reduce fragmentation for
+THP allocations.  Once a value is written to this file, the kernel no
+longer adjusts it automatically.
+
 Some minimal amount of memory is needed to satisfy PF_MEMALLOC
 allocations; if you set this to lower than 1024KB, your system will
 become subtly broken, and prone to deadlock under high loads.
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index dbae78b68dd8..3fd209f9377d 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -3148,13 +3148,8 @@ void set_recommended_min_free_kbytes(void)
 			      (unsigned long) nr_free_buffer_pages() / 20);
 	recommended_min <<= (PAGE_SHIFT-10);
 
-	if (recommended_min > min_free_kbytes) {
-		if (user_min_free_kbytes >= 0)
-			pr_info_ratelimited("raising min_free_kbytes from %d to %lu to help transparent hugepage allocations\n",
-					    min_free_kbytes, recommended_min);
-
+	if (user_min_free_kbytes < 0 && recommended_min > min_free_kbytes)
 		min_free_kbytes = recommended_min;
-	}
 
 update_wmarks:
 	setup_per_zone_wmarks();
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 6ed36ba4d055..57a33da2562d 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6737,12 +6737,8 @@ void calculate_min_free_kbytes(void)
 	lowmem_kbytes = nr_free_buffer_pages() * (PAGE_SIZE >> 10);
 	new_min_free_kbytes = int_sqrt(lowmem_kbytes * 16);
 
-	if (new_min_free_kbytes > user_min_free_kbytes)
+	if (user_min_free_kbytes < 0)
 		min_free_kbytes = clamp(new_min_free_kbytes, 128, 262144);
-	else
-		pr_warn_ratelimited("min_free_kbytes is not updated to %d because user defined value %d is preferred\n",
-				    new_min_free_kbytes, user_min_free_kbytes);
-
 }
 
 int __meminit init_per_zone_wmark_min(void)
-- 
2.45.0


