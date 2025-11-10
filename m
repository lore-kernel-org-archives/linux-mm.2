Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32257CCFA1A
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 05:27:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 911DC8E0010; Mon, 10 Nov 2025 00:27:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C2378E0002; Mon, 10 Nov 2025 00:27:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 789DD8E0010; Mon, 10 Nov 2025 00:27:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 601C18E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 00:27:22 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2D28A5892B
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 05:27:22 +0000 (UTC)
X-FDA: 84093564324.27.2FAF1F7
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012047.outbound.protection.outlook.com [52.101.53.47])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4EEE01C0007
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 05:27:19 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=12TEiNsQ;
	spf=pass (imf18.hostedemail.com: domain of bharata@amd.com designates 52.101.53.47 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762752439;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+RXKS7x2FQ6mJS0EUq5g6aDyJjBgpdjgOVW6lopD1IA=;
	b=z5dqO/yw78M2ZmUbjbfEa5Ojdv2yRdxfX6qZYELAD2SK+flA6X6G2izADDzksGS+E9X818
	Ffnn6ag+HlNUDnPXrerzXbfar9Vnc3ZS+tz+ntDmXPjyYukUVyDs71NF1BTNWtWE+lp+xp
	pwXjA7w99BOQgfCI6qr+imNNdUzWWNI=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762752439; a=rsa-sha256;
	cv=pass;
	b=ZROyWFdvNfirE16XUuDkDrThnAs1P6AVxfajV7UNipbOnO5Y/tsbjBWo7d9FXW5Bx2kXec
	HUgd9CFYq4Y3YfujW01rWZVP4KB0UpA3E38NmSJi8FDAzCt7nYRpIrLSwwPHF/Mi6/SGmn
	AL0a8aJTvesuRUHizq6iMctgkgNYJ/Q=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=12TEiNsQ;
	spf=pass (imf18.hostedemail.com: domain of bharata@amd.com designates 52.101.53.47 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RfISrsE4UqfGm2WadkEScEQLdiedcSKk5KTRakGOTIFO8v5pyKjHXauqkbA0WgI2nB/4LJeF1y5PpJL3Xx3Lze81SU7ojCtld3oXUmHdYHr3KB2csgRsTCTNOf3wG65UA8jmSdySsZM8WGdNdEhj/m62NZCvxV1jkK1FtatfvN8Y7/V9t+9NJOsL804pglrbofUfrvT/jD6o3V0loyJuZbOA8ko90loYqn35wSAPJU8+G/bjcN4B2L3+AXiMZKCr7qGjdHTZG8l7ibWNPqVmTlSKF2sa1VSi9Pc6bpWrlOD3Fbb1UAOxx4fKjQeXkmVINbAq1HMe9F9J+OkZHAk3jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+RXKS7x2FQ6mJS0EUq5g6aDyJjBgpdjgOVW6lopD1IA=;
 b=TbkA+jQDjX9PC6sqm0XrSBFfl3vi0lbQVv3H6J5T7T4+ilg9nB42diu33c4mUkIshf/pE9IB195v3p+E3PlW2Pmn7A8oq8RDTi4kURsrlQk5esyIVVm8fYEQFarLYPriKbPqnG1jJefuDNcUz83+3apwtDEQ7m19sHS9dVj0C7m0m0hbY3qF3l+5a6zqt+p3qqgjH8FVoBYJluIDnpjuIRsbDLtxLxzVEaC75VVbcBrm9QmnQnhtnc0N5POaxHp4RPjkI5JE8JaQvIFddNomQCBHRas5DDeUopjSdrIap2nfmx27INLNrnsuhmD+ubAm8s9N4Rv7wK8ro9hv1eof/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+RXKS7x2FQ6mJS0EUq5g6aDyJjBgpdjgOVW6lopD1IA=;
 b=12TEiNsQJ6VX2O5p705qfY6objkOHLAcl9mNu2ztEig5vDbAopYMe1euhOm5om4B/qzT2BQDGGzHaPsKHFFnvZgKjih3rDFgn7wEEjS+Q+mV3bZPfWYF+5prf1seFiJuH0Sm30IuQpBYkmYRF73CoIgjjr0nKHxDUi3GUqxAfD4=
Received: from SN7PR04CA0045.namprd04.prod.outlook.com (2603:10b6:806:120::20)
 by IA1PR12MB9064.namprd12.prod.outlook.com (2603:10b6:208:3a8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Mon, 10 Nov
 2025 05:27:15 +0000
Received: from SA2PEPF000015C6.namprd03.prod.outlook.com
 (2603:10b6:806:120:cafe::e4) by SN7PR04CA0045.outlook.office365.com
 (2603:10b6:806:120::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9298.16 via Frontend Transport; Mon,
 10 Nov 2025 05:27:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SA2PEPF000015C6.mail.protection.outlook.com (10.167.241.196) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.13 via Frontend Transport; Mon, 10 Nov 2025 05:27:14 +0000
Received: from BLR-L-BHARARAO.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Sun, 9 Nov
 2025 21:27:07 -0800
From: Bharata B Rao <bharata@amd.com>
To: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
CC: <Jonathan.Cameron@huawei.com>, <dave.hansen@intel.com>,
	<gourry@gourry.net>, <mgorman@techsingularity.net>, <mingo@redhat.com>,
	<peterz@infradead.org>, <raghavendra.kt@amd.com>, <riel@surriel.com>,
	<rientjes@google.com>, <sj@kernel.org>, <weixugc@google.com>,
	<willy@infradead.org>, <ying.huang@linux.alibaba.com>, <ziy@nvidia.com>,
	<dave@stgolabs.net>, <nifan.cxl@gmail.com>, <xuezhengchu@huawei.com>,
	<yiannis@zptcorp.com>, <akpm@linux-foundation.org>, <david@redhat.com>,
	<byungchul@sk.com>, <kinseyho@google.com>, <joshua.hahnjy@gmail.com>,
	<yuanchu@google.com>, <balbirs@nvidia.com>, <alok.rathore@samsung.com>,
	<shivankg@amd.com>, Bharata B Rao <bharata@amd.com>
Subject: [RFC PATCH v3 7/8] mm: klruscand: use mglru scanning for page promotion
Date: Mon, 10 Nov 2025 10:53:42 +0530
Message-ID: <20251110052343.208768-8-bharata@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251110052343.208768-1-bharata@amd.com>
References: <20251110052343.208768-1-bharata@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF000015C6:EE_|IA1PR12MB9064:EE_
X-MS-Office365-Filtering-Correlation-Id: 8295be7e-de1c-4b15-4c7b-08de2019ce8a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|36860700013|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?RftUtVlMzDGtWD9M3b0vdDq8lfKx54rKzoTGS0g0CmJU53mfl85EoruD6xVf?=
 =?us-ascii?Q?q6Hoy4iqofYKItVcQwo2fj0aVSBRFIqW4B/3VuRC3Lb1Sc1WEBCsM9xLTsie?=
 =?us-ascii?Q?Sd9da/6AkNpuQegFvkyfouCsACNOMhpnxqH2T18nlr4E7IRMhPf7xEWndJR1?=
 =?us-ascii?Q?bIPHXCpSMUJRE+SrVaK0E1IZCQ345IKr3MqBzGtJyAIgYvaor3qd3zJusqei?=
 =?us-ascii?Q?ggJqoHybugd3cw1OmEuPV0kx8TSNFaOgNDfCaMi8TFd16LI5sLcZndGa4vGs?=
 =?us-ascii?Q?8HneStj4qG6bHKG0o18Sg2F7ky3rjaeh4raRHwzMtiu8tcZxAmqiZpz550ic?=
 =?us-ascii?Q?wNbkh8vh6abdLK602PLg9a7gx+49y8/JbPDEY6xCJFnGXZOGJ84LLUGQlTY9?=
 =?us-ascii?Q?VsoW6aGYuEsgau7dEGre5M94g4vl+RB02zz21Joir2KTAlcveLeT+WRuqRhK?=
 =?us-ascii?Q?o1WfVYVr3Gv8im7SsJ5xxmwiikSPn3wDgk2p7CHY3U1Dh9OAoTwqwtdGd6Z2?=
 =?us-ascii?Q?jqgmzgKrpjcC/g0TkVnJXfP4udHIVPoVkavTjmtSekYVOeBt4Z95GRYJekEY?=
 =?us-ascii?Q?JYyEdkP2Rhl4SRKJn/Uw2+Z/xAnfct5qLdfiu1JGGIaQnvP2yPIMxYqlR3gr?=
 =?us-ascii?Q?P7GnEeJMTXA4YxnNnShRKp8yJT7k/aWq40xF1/OlnqP5rA2cU738L1AneDep?=
 =?us-ascii?Q?Zb87fcA8NCDz7ZDICpPAMG64ecyseax4TLwKiUDQzbe7s5ueuJI8dZHwCaYe?=
 =?us-ascii?Q?J7XcByqtNsJ/LUD+J6qGHdUhzxp/5LWYf9uUVNMXProzCai3M3XexJj05ZKK?=
 =?us-ascii?Q?IEYQ80n8ZDq3nFfcvhHgenaT/ftHmOr4HVZdYop8OYVh+ivl3ghwRpTrFlpd?=
 =?us-ascii?Q?w7IPsIMhF/sATraauxwbQOwn7u3gRPCxK+gK+BPvk+98ugQPeichebg0XyIv?=
 =?us-ascii?Q?BMt9CaMzBcAIW93KYvtBkjH5qmouwE8Y+5BQkjFIyfynH8G6TaSTHPA3SP5t?=
 =?us-ascii?Q?U+Sq9VG1GyatgwDCtN1fsogaAuwmSAfDjW3nocoLoXy/q3nnHut8+mrH0MHi?=
 =?us-ascii?Q?f2XEDS3cWnpCUdel/3+iLUP1Q+MUnTlaWxw5N9hB2CRMep8DU5zzpsjk80B2?=
 =?us-ascii?Q?/XCUYKrE0I4j/eLikZ9Dk9hqytCM9U2zlOYdUFS2zVWtYo8NY2+r7cJn4s9f?=
 =?us-ascii?Q?pxkq8diGyf7SQmCHAnYzWeatxmjr8OwJw5mzAVaQXcWgKPg5mRuT+6k8J01W?=
 =?us-ascii?Q?dxiT37GX+RVMd9f61Z085fS5q6SVmrlJkZpO64tXHg1vxkufgH7RcXW6wA3z?=
 =?us-ascii?Q?++cQYJuuT00cFRZMr/PuKPKY2rUzZWG5mBb0n0DQi6gnXGR+vcWYklvg28tG?=
 =?us-ascii?Q?Bs1yi4Fdjz090e0ieJt/qa8tX7GtIUlafqbsfxIVztq3Gj4VyhZ3GlHIPxPx?=
 =?us-ascii?Q?CHOgkLJJopPnCQ2M0u8bxg3JFZzYvw7d5YbBV0bxpf0x1t7hDdKXlbhEHGM1?=
 =?us-ascii?Q?iwMmJkiqbGP2bS0hNb1Ct0wuNAoHaqgNOuvoN1RiY/mZpjuDI5J2wNEKBl3t?=
 =?us-ascii?Q?9RPxMxQ4WXRr8QOEx2Q=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(36860700013)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2025 05:27:14.3970
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8295be7e-de1c-4b15-4c7b-08de2019ce8a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF000015C6.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB9064
X-Stat-Signature: ixfpqh3m638mfcp36wfmhnogbxkjjehq
X-Rspam-User: 
X-Rspamd-Queue-Id: 4EEE01C0007
X-Rspamd-Server: rspam01
X-HE-Tag: 1762752439-320005
X-HE-Meta: U2FsdGVkX19Xc3Jilt5w6JQuzNH70AINVBOSDs/fw+k5lDqtAWgkB8QR7k7DTimrsXw230UTqm/7g4kPfVvRrX961lza2QWFHWULSbiW3WsaRmBgwLoeIRaLM+LIwuiklaG8ugg+2+wlcbKQ5zn7fdz+a3uoWJlVUwOB1NAqphbi3aRO/UCdsEr7i9ZXyI73CiwDg2KlevoB625VDiybjIujLwMU9kYq7grLbfDIsxpvKQ8dWlwOIrpJ1s0vcEQ2rr2pma7fd8tPNf2IMBvgKU605nwnsVMu43cgVd1qpXG7+bx0jF8CHgjfMrMtSLvwiKwhS5TEiC8C6i4kFUZ4K2tWYYBSWSuEoRnx44zNjhbMTrMyy1th+ylf7J7kz2F0pxuhkhJv+yjBKyhGJmogOaw0be5xlsuBZeYQSv6ea43K3V4GcYKtcTIR8CIP9dt5ytlkn+bFun8p9sgLd3RTHMnigTTPPEfDKY/J99WFoDPXoiNhHpaUAQj7C3Ll4BfCaH9Vk+l/8chI0ahkF2i1bEgoJhib0rqj5Z9oubUinU9eKXMcwCK06LgZBR2aNYYp6HMs9Rbr1f1XkXUwxpLRrnog7WrlGnbCtFtW46XNUC68igLyJuy66CmjhQlg7ataGOmZO6h7VzIqxcI/xXuoDvSZTK6TZs1WiRPZmsZicSYQhUiRdMF88a2eIp4tyiDFyNCeSgkgsAEMj34dY8iOem7YTPCyUYw8VJZ6UoBXUS/WnTjUC8iRgWGp82idsb1wt+IQzXYksVmOG8NzotvMHluMtfesoQd0Up9PzNyF1yKLOhAffDnPrcOFBQPcSQSZUOVmPMwyiI5rDr0SOaX7pt9AuVhZKezj45IKfmT/7QqOu0IvCuDa99HZCzxE9SApLSE0ATstUbGKfnVleLnspHkQXaNIrHsZDAmLpoAXDqo8Suf5MqpZAV6HNFx+ouYcmZ/zzCONSczSk20304z
 V7y8/Dbm
 VLLDwe+cBB7B3//ldZjXZAiS+wGyd9wtpmuzRAB6nkHCA8Y4/Ig97K2w0yIBLnRx0TzhXhasw2YzXCaxpqqxPC5L4tfEx+G1wcNC5m0UfIpQvPaA1zf1fqwfdteCv8gGpXVj7rgQHEKKVIM/PtwccVvIWKZytjvNo8uri8w5hGcD+oaUKnl9k8cQVnH02zz8uFToRTgoXm0JhWhpfWYXpzIJ962I4braJmyoG9aGj0ikIQB2kG6qUh2i22T2wMWJOKXtHKwkXksk6SbeyPI5lHlvIJxQMxWzmedYvgxol8pq+XGpMTSfu2i+etezM/pauWE0KQrEPTfOw06UFhK2yaCex6ggOwUhLV8Chfz+G/bmJ7nAKK3S3cQrjuyKqzgy8N2wg4XEMhueeubZJijbr9OuAtkdzcxKBVEkgkuJbTowJMn6TBMHZHq9nv+vaHcODcLmVfB9gp1VF+QX3IMnMrm7J1BEMfEZOnBGa7UE2ogYyz/3ba+xMswSjfh5YJ8+6LSJVH/FITtiMjmhg5Qh1PPgPE8r+4ghdDaUNeckJxHlCRNZjq3ZGVUx5FXKl5ooLaQmTSro8FBHJklU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kinsey Ho <kinseyho@google.com>

Introduce a new kernel daemon, klruscand, that periodically invokes the
MGLRU page table walk. It leverages the new callbacks to gather access
information and forwards it to pghot sub-system for promotion decisions.

This benefits from reusing the existing MGLRU page table walk
infrastructure, which is optimized with features such as hierarchical
scanning and bloom filters to reduce CPU overhead.

As an additional optimization to be added in the future, we can tune
the scan intervals for each memcg.

Signed-off-by: Kinsey Ho <kinseyho@google.com>
Signed-off-by: Yuanchu Xie <yuanchu@google.com>
[Reduced the scan interval to 500ms, KLRUSCAND to default n in config]
Signed-off-by: Bharata B Rao <bharata@amd.com>
---
 mm/Kconfig     |   8 ++++
 mm/Makefile    |   1 +
 mm/klruscand.c | 110 +++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 119 insertions(+)
 create mode 100644 mm/klruscand.c

diff --git a/mm/Kconfig b/mm/Kconfig
index b5e84cb50253..84ec9a9aca13 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1383,6 +1383,14 @@ config PGHOT
 	  by various sources. Asynchronous promotion is done by per-node
 	  kernel threads.
 
+config KLRUSCAND
+	bool "Kernel lower tier access scan daemon"
+	default n
+	depends on PGHOT && LRU_GEN_WALKS_MMU
+	help
+	  Scan for accesses from lower tiers by invoking MGLRU to perform
+	  page table walks.
+
 source "mm/damon/Kconfig"
 
 endmenu
diff --git a/mm/Makefile b/mm/Makefile
index a6fac171c36e..1c0c79fec106 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -147,3 +147,4 @@ obj-$(CONFIG_EXECMEM) += execmem.o
 obj-$(CONFIG_TMPFS_QUOTA) += shmem_quota.o
 obj-$(CONFIG_PT_RECLAIM) += pt_reclaim.o
 obj-$(CONFIG_PGHOT) += pghot.o
+obj-$(CONFIG_KLRUSCAND) += klruscand.o
diff --git a/mm/klruscand.c b/mm/klruscand.c
new file mode 100644
index 000000000000..13a41b38d67d
--- /dev/null
+++ b/mm/klruscand.c
@@ -0,0 +1,110 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <linux/memcontrol.h>
+#include <linux/kthread.h>
+#include <linux/module.h>
+#include <linux/vmalloc.h>
+#include <linux/memory-tiers.h>
+#include <linux/pghot.h>
+
+#include "internal.h"
+
+#define KLRUSCAND_INTERVAL 500
+#define BATCH_SIZE (2 << 16)
+
+static struct task_struct *scan_thread;
+static unsigned long pfn_batch[BATCH_SIZE];
+static int batch_index;
+
+static void flush_cb(void)
+{
+	int i;
+
+	for (i = 0; i < batch_index; i++) {
+		unsigned long pfn = pfn_batch[i];
+
+		pghot_record_access(pfn, NUMA_NO_NODE, PGHOT_PGTABLE_SCAN, jiffies);
+
+		if (i % 16 == 0)
+			cond_resched();
+	}
+	batch_index = 0;
+}
+
+static bool accessed_cb(unsigned long pfn)
+{
+	WARN_ON_ONCE(batch_index == BATCH_SIZE);
+
+	if (batch_index < BATCH_SIZE)
+		pfn_batch[batch_index++] = pfn;
+
+	return batch_index == BATCH_SIZE;
+}
+
+static int klruscand_run(void *unused)
+{
+	struct lru_gen_mm_walk *walk;
+
+	walk = kzalloc(sizeof(*walk),
+		       __GFP_HIGH | __GFP_NOMEMALLOC | __GFP_NOWARN);
+	if (!walk)
+		return -ENOMEM;
+
+	while (!kthread_should_stop()) {
+		unsigned long next_wake_time;
+		long sleep_time;
+		struct mem_cgroup *memcg;
+		int flags;
+		int nid;
+
+		next_wake_time = jiffies + msecs_to_jiffies(KLRUSCAND_INTERVAL);
+
+		for_each_node_state(nid, N_MEMORY) {
+			pg_data_t *pgdat = NODE_DATA(nid);
+			struct reclaim_state rs = { 0 };
+
+			if (node_is_toptier(nid))
+				continue;
+
+			rs.mm_walk = walk;
+			set_task_reclaim_state(current, &rs);
+			flags = memalloc_noreclaim_save();
+
+			memcg = mem_cgroup_iter(NULL, NULL, NULL);
+			do {
+				struct lruvec *lruvec =
+					mem_cgroup_lruvec(memcg, pgdat);
+				unsigned long max_seq =
+					READ_ONCE((lruvec)->lrugen.max_seq);
+
+				lru_gen_scan_lruvec(lruvec, max_seq, accessed_cb, flush_cb);
+				cond_resched();
+			} while ((memcg = mem_cgroup_iter(NULL, memcg, NULL)));
+
+			memalloc_noreclaim_restore(flags);
+			set_task_reclaim_state(current, NULL);
+			memset(walk, 0, sizeof(*walk));
+		}
+
+		sleep_time = next_wake_time - jiffies;
+		if (sleep_time > 0 && sleep_time != MAX_SCHEDULE_TIMEOUT)
+			schedule_timeout_idle(sleep_time);
+	}
+	kfree(walk);
+	return 0;
+}
+
+static int __init klruscand_init(void)
+{
+	struct task_struct *task;
+
+	task = kthread_run(klruscand_run, NULL, "klruscand");
+
+	if (IS_ERR(task)) {
+		pr_err("Failed to create klruscand kthread\n");
+		return PTR_ERR(task);
+	}
+
+	scan_thread = task;
+	return 0;
+}
+module_init(klruscand_init);
-- 
2.34.1


