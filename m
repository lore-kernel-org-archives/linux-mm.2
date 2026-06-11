Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEBD7CD98CC
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 13:06:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EABF6B00A2; Thu, 11 Jun 2026 09:06:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C2766B00A3; Thu, 11 Jun 2026 09:06:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D8546B00A4; Thu, 11 Jun 2026 09:06:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F1C076B00A2
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 09:06:43 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 98E92120656
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 13:06:43 +0000 (UTC)
X-FDA: 84867656286.02.1754EFA
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013021.outbound.protection.outlook.com [40.93.201.21])
	by imf18.hostedemail.com (Postfix) with ESMTP id 411E11C000C
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 13:06:40 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=C7R6SEqQ;
	spf=pass (imf18.hostedemail.com: domain of shivankg@amd.com designates 40.93.201.21 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781183200;
	b=5l82V+YN7zawR1jD8NIsxdanRQClUAF7cylwpGf7I1bdzvqwUa4cH56KDCpuBlR7eoTT+I
	ViBYIYMSNT96IR8B/nwX+kObEBoVHYUCDyYKCRi0xaxa27Xd+1lPahAInNueyk5VQw6H5J
	vA3KcgUwSVCUolZL18WP0JMP3sbGWTY=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=C7R6SEqQ;
	spf=pass (imf18.hostedemail.com: domain of shivankg@amd.com designates 40.93.201.21 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781183200;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yfXGCChRs+6Xzto4NU/K/MuGcsi8nsi0kpDBsa/xHpU=;
	b=MD0nWWRJxb8k+Hfv1R9nKR3izzfsGAExSGpnw4NkewsT9yCNrS4D0Mpact2BpkKQF+/l9t
	QCnO/2dt340B79QcYJ4Ge8WJy5WPI2SK4oc40U4bn760a/m/kBy4foMSmXRxiCg4lMezLb
	SnSEa/C8JLwTBt/yZvY9GI2Nz7YbqGM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VzKxTuz3263gAt3RIakGEU9waq62NhBkCEowuxE9wMd7Qd8vE38Aww+zM9RKGYep+yh7loTt1uoS0ckjmlEKOrK97ZSS+esUbmA9sP12SW57CEySWnkgMA4U/Cp4Q7ihJlSSRhiwsikkIxdZZ5/JbvIVWPduoDKsuk1wDDQmuRx/aLY3u1d5ozEAJGfDyuyruKDnVj6INX79SpcN7X0zf8AB3r/uW56fPQCZfahJOonhhndqh6GEvsFZpg24xVsiB/y9i/FcHtPz+TbnEOizQrREk2mp/tGmUDuyN9e4vNWAhC9Wj/n4ZIn5g3O626peklfZ6l5xDHvSuRX2NZl3Yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yfXGCChRs+6Xzto4NU/K/MuGcsi8nsi0kpDBsa/xHpU=;
 b=gYwSNC3BBNj3mPcPL/5Nq5fo8NdmH2P0aQLgZ/QXCi+Ie0OYPsqBV8pmMVWISDI7uFEIWVUkbTeWwa/XL6AMnK6N21rjMH/NGRRfSJZp89QiGx/z7paeBdwVNKukNQEWvv81GOdTRS+Kd67H/reHFsZhGlOhW75TjKAPVZH9QlT4RWabEHTH7OrPfOfRIeuY9ud37DqVMHfuwdB+lUGwIYgQervOF2NrL21+mBBndVUWJ+ScwEIcju9SLTPtjpIqgm06x4GkqsMFYSIriIqAEJnlzeVrI9gahc9GZPgDqtgEp1t3K9WWIfExJIQI1ToOCuhImU873mQ2vlDwtcHcjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yfXGCChRs+6Xzto4NU/K/MuGcsi8nsi0kpDBsa/xHpU=;
 b=C7R6SEqQlFkbBjyFWek6pHkievTpTLwbglB2D2Gz5u5gdDKjoZQW6dBBfCbupaPlcKSDjCzaONaO7gRsNAEOUghgltUUVgA8BJIdxgu2RA3V+FNz0FiBjHPl78FBkTU6Qk3vcctKXUTLScuX7y67tlK10tKjIwr1EDq/tfTjD4I=
Received: from MW4PR03CA0276.namprd03.prod.outlook.com (2603:10b6:303:b5::11)
 by IA0PR12MB8253.namprd12.prod.outlook.com (2603:10b6:208:402::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.18; Thu, 11 Jun
 2026 13:06:33 +0000
Received: from SJ5PEPF000001CE.namprd05.prod.outlook.com
 (2603:10b6:303:b5:cafe::1a) by MW4PR03CA0276.outlook.office365.com
 (2603:10b6:303:b5::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.113.11 via Frontend Transport; Thu,
 11 Jun 2026 13:06:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 SJ5PEPF000001CE.mail.protection.outlook.com (10.167.242.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.113.7 via Frontend Transport; Thu, 11 Jun 2026 13:06:32 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Thu, 11 Jun
 2026 08:06:32 -0500
Received: from [127.0.1.1] (10.180.168.240) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Thu, 11 Jun
 2026 06:06:23 -0700
From: Shivank Garg <shivankg@amd.com>
Date: Thu, 11 Jun 2026 13:05:10 +0000
Subject: [PATCH RFC 3/3] KVM: selftests: exercise guest_memfd folio
 migration
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260611-shivank-gmem-migrate-v1-3-2d266bfc6f95@amd.com>
References: <20260611-shivank-gmem-migrate-v1-0-2d266bfc6f95@amd.com>
In-Reply-To: <20260611-shivank-gmem-migrate-v1-0-2d266bfc6f95@amd.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka
	<vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	<mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, Johannes Weiner
	<hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, David Hildenbrand
	<david@kernel.org>, Matthew Brost <matthew.brost@intel.com>, Joshua Hahn
	<joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park
	<byungchul@sk.com>, Gregory Price <gourry@gourry.net>, Ying Huang
	<ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, Chao Peng
	<chao.p.peng@linux.intel.com>, Nikunj A Dadhania <nikunj@amd.com>, Ira Weiny
	<ira.weiny@intel.com>, Michael Roth <michael.roth@amd.com>, Pankaj Gupta
	<pankaj.gupta@amd.com>, Ackerley Tng <ackerleytng@google.com>, Fuad Tabba
	<tabba@google.com>, Sean Christopherson <seanjc@google.com>, Vishal Annapurve
	<vannapurve@google.com>, Nikita Kalyazin <nikita.kalyazin@linux.dev>, Patrick
 Roy <patrick.roy@linux.dev>, Pratik Sampat <prsampat@amd.com>, Ashish Kalra
	<Ashish.Kalra@amd.com>
CC: <linux-fsdevel@vger.kernel.org>, <linux-coco@lists.linux.dev>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>, Shivank Garg <shivankg@amd.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781183157; l=3950;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=olfQQbnpeg9ecdFmCw/S72RrvERIKQlUL1h11e1/Nr4=;
 b=gCRHu2UP0v6tDLOup1gOXGbI2VE6k9oe02ImNCzdI4rhQe/MxeZrk70mgsBHgkjLhExbw0Q3O
 pUcb1/scYcVCaoNzwOYiOTJKxwIicEIMoOV1zcM0fGxkvR2Q2y2DRWP
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb09.amd.com
 (10.181.42.218)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001CE:EE_|IA0PR12MB8253:EE_
X-MS-Office365-Filtering-Correlation-Id: c80cc666-b88d-4af9-84ac-08dec7ba42a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|23010399003|36860700016|1800799024|921020|56012099006|11063799006|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	ndx+OFsZQrE1uyHd2iaXYZHTEngD8o9JqrQSu4ZYnfjmaC9juzeWR1AEMbvWUmaqKbj3C4Oa/HZcNLOaQk4lWpFfG5cWcJ7o1OPqWUpZiZ7wuCO9qdZR7zY5a2ploxlyPpUoyOwydJG4Tmva7w9tIr8llZe4ak9Vp47DRIRR+SOHt1dzD8HAKfqBACqbIbuP541W/1Yip6+rautgv6EH+vPDeJ+sAe6UcBkYgZXNIgNVHaTXwe12oGZ7z+4x3aE3mk0g5UvuvsWlAfxuKiawS8UWXov7tVc36/0dXK3J4Kmr09vnwYm2SQgSi+oURq4TJhIRxIUdFQOIU0Sbzv4yLPHbgaETlbbVtZTV9B3RxmYRGZ7W+u6+PMSd95Ft4nNxj2L3rlajxONb6KHqs6unNxW5YmnYhHWxER2AomRowTkw+2ocGh9b/6YVa1UdNgiynhbXQ483rP1Snp/kvCXu5Dop5V04CU6DZ144Xxk1QLUX6mNpDwKQvxMxf/HH7k7ms5u4MYuyZRn/9IQM28FMHZOKRVMvA7czgHgrUhsdjOdQQqbLZf6nE7urG/kpJSbuLTrON8aE8zThbezUw8Act0Yn9zIQFWICmPWhym77zg6E4F9ADRd4UUfobaiLgMG9AoFtsYFLXK58IZd1If2NQ3ednPHmiEYVRoZqsDRHzG7sN2oyR4iA5MTOx2T7vosyrbdHjj74IQaMTD1uwYJTxGDj6TgE6Cwp31JyOwufYW1ctQjAVqGkqI+qXppxvYFGqjJV+X+WvPODi4NIW1VNkg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(23010399003)(36860700016)(1800799024)(921020)(56012099006)(11063799006)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	UuEo3rDAGfl127U0x2hIeO6XV418a27jKMa7i+Pp7QT2REp2bjhBQBIx3w9veDn2r404vCZcxF9Nc3mD/Tfq5bq9dLNiqnNeRwUkxIMLargqJuq3EvzbmMpUbzcLyAqbEAZwpLdgsQ7vGF7klWk8IQf0zf2MPw3H2J5a61hdc2vZT+j8EE7eRxOsoJN2JvOs1ePmt9d6BaNk+U2XPMtv2dwO4ZJ+vr6c8wb2vkSlMG9s4mIpxL13ocwYTDkCKoAOzOvyrF+oETLSxjFChsQZqNcffm+z2m9frIphYZ/oHXfWz97c7MshK1wB7pAkCef0xTwIOSySACfH9KENcwaL4JRMdBn03iXYQvlHUij6ilqhnwRUUL5e1klx/FVRlGUrmqs+Szx6wyMPSVpK+yfJ4RGjswab9xdPV06fxJvlBwUjbRalB/oSc8w4qNulS8ee
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2026 13:06:32.8220
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c80cc666-b88d-4af9-84ac-08dec7ba42a7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001CE.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8253
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 411E11C000C
X-Rspam-User: 
X-Stat-Signature: c3p3eha9a7u394ka1p18y6m8zg1sm9m7
X-HE-Tag: 1781183200-430079
X-HE-Meta: U2FsdGVkX1/OCVOMA09j6fdsKRyUAdeZTOGi1SBc17+Tl8GHxvxisNLyIvZ0GgPqdjO0t40mhZjLn+wRnniEAQoDbU7YayREZP1jpiWgRmQLlS/F4ey9P80luIkDHgEhWamfJZnTO6mo3pjvFpDxfT1yqe4+MJ70HfESXRrE/OFSAUltbWBEagHyUw11Gq5PSteTbD3cMXIJqLfvUDQyK+auAF/01Nh9ijRIvIUezCoPllNXxOmYsmAXpuqXxaufKo1/OO5FNZN8zXJ/smeq9JLWrHjK9Ws/Rpwyst2ssQVeNXJM9TXKMri8VwhPg2o3+QQYuade+z2i76ghK52FwXnzdk/7o0Cy5XVGm24277PEU1fWLz9rmPM+ImPYvkHccTVoHUwyzLFePOgbLyzyitcKpMq6qUSwS8LU7ZoelYlG5LeiqBqezDmE6ljl5oFZet1gfb668Rcz65v+N6AioMUKF4wFLagj+Kqhwv2lHZfH6g9GuzEEWSvHU1HXhaHzE6bWJTujEQZJjeeCk2LIzlZ01M05lmj0GYqL74J1l6lnWWx6KG5/MGIcTjGxqiBGej4ekCfR/I1yvzqxC6LSnuk9mhnW5ZY1HBZvW5WAcrcovWgKFHjzSnZMkEwExVgWmGS010MKQQ8M4XW4vbU8Rm9uVfYejQ2tGFJdcI7lsdAnUeXKfxjtyKrZJMVzVwQ5Mt7nUg6uf2ljr6aWiQuqpV+YMxX2SmrWSnYDXpi9AGFIdeai0NgLd/YruWhfCGP1YqLl5WcqiS1Z05pppOvyKSX9RY5U6Z8amWMtX9dW7hzGVJw0L61aJd/9IiuNqWDpTy9jINCpkkPLlYY5kBz40Q4tYUMiixI+yogxVXqd7l/476Gozl8mRcLwtNBKBT/+51UvpSWRetaakAVCs4uncki9OuryU5H3yI/kPHSOUb5P2SXcHHt6N1GSqnm6RfF84uvA5XDtfaWRIhoB1Gp
 jOKUR2T9
 pdx6r+g1UFiuCp/cbyOVSCQ1csOeZjjeY0uEwMK4ilXEaAjKaQjCE1bHO7dhGysE12nasZDu5kAZzVnJ0yRpd0oJQDYGtfHgQwtPhBS40bTPfw4OxXu2c+lct+Ey5ANhIPI/5GuXhZ3PEk1UzBfsUkH70EbtzsxXxH1bXfqNIOISTyLPX7upfyIaoUVBB/VYpqf5fJuEr4f/hv9ph+p80IG83m4rISBgQ/5ForiCJ4QGWrgHHw8FpvQBVuNIiWy4MeG+lwH7JgfF0xPeshmUlFh2fZwPOOZeY9UcbSzqmyIraou0TZ1Dp3x3D+DSz0NUDpEPQWkjRJLYJBvvT30+0QsDBW7brm6AHIH46sNxSs2+ggfZJX0u8K0xSQtVCrxWdtjGXkxsN5fjBdMzU2K7EqgImAoFQHrRtP+sSn3FCOiwHg/XVKsKdwKIPC0debTZYC0dlUrz7tVw7VmYGY62D4yIHg2DOOvcMF9Pi0/X7Kpts7XopbYtN6Y1IjyTv/uV6IZONlP91oS1XAn5c7dGOFfVpOirG8Dq9PDVp+AdyxIW0EOTiwEDZKhG9tg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a migration test to guest_memfd_test, run for the
MMAP | INIT_SHARED configuration on systems with at least two NUMA
nodes (skipped otherwise).

Migrate every folio from node 0 to node 1 with move_pages(2) and
check both the resulting node and the data. Migrate them back and
re-check the data.

Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 tools/testing/selftests/kvm/guest_memfd_test.c | 77 ++++++++++++++++++++++++++
 1 file changed, 77 insertions(+)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index 832ef4dfb99faa4411af847d21eb426c34342434..04931d3add46cb117fe5b093ed48f838cb124542 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -76,6 +76,82 @@ static void test_mmap_supported(int fd, size_t total_size)
 	kvm_munmap(mem, total_size);
 }
 
+/*
+ * Each page is filled with a distinct byte (its index). Check every byte that
+ * data is intact after migration.
+ */
+static void verify_page(const char *page, int page_idx, size_t size,
+			const char *when)
+{
+	char expected = (char)(page_idx & 0xff);
+	size_t off;
+
+	for (off = 0; off < size; off++)
+		TEST_ASSERT(page[off] == expected,
+			    "Page %d corrupted at offset %zu %s", page_idx, off, when);
+}
+
+static void test_migrate_folio(int fd, size_t total_size)
+{
+	const unsigned long nodemask_0 = 1; /* nid: 0 */
+	unsigned long maxnode = BITS_PER_TYPE(nodemask_0);
+	int page_count = total_size / page_size;
+	void **addr;
+	int *status, *nodes;
+	char *mem;
+	int i;
+
+	if (!is_multi_numa_node_system())
+		return;
+
+	mem = kvm_mmap(total_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd);
+
+	addr = calloc(page_count, sizeof(*addr));
+	status = calloc(page_count, sizeof(*status));
+	nodes = calloc(page_count, sizeof(*nodes));
+	TEST_ASSERT(addr && status && nodes, "Failed to allocate page arrays");
+
+	/* Allocate all folios on node 0 and fill each with a known pattern. */
+	kvm_mbind(mem, total_size, MPOL_BIND, &nodemask_0, maxnode, 0);
+	for (i = 0; i < page_count; i++) {
+		memset(mem + i * page_size, (char)(i & 0xff), page_size);
+		addr[i] = mem + i * page_size;
+	}
+
+	kvm_move_pages(0, page_count, addr, NULL, status, 0);
+	for (i = 0; i < page_count; i++)
+		TEST_ASSERT(status[i] == 0, "Page %d should be on node 0", i);
+
+	/* Migrate node 0 -> 1, then check both the location and the data. */
+	for (i = 0; i < page_count; i++)
+		nodes[i] = 1;
+	kvm_move_pages(0, page_count, addr, nodes, status, MPOL_MF_MOVE);
+
+	kvm_move_pages(0, page_count, addr, NULL, status, 0);
+	for (i = 0; i < page_count; i++)
+		TEST_ASSERT(status[i] == 1,
+			    "Page %d should be on node 1 after migration", i);
+	for (i = 0; i < page_count; i++)
+		verify_page(mem + i * page_size, i, page_size, "after migration");
+
+	/* Migrate back node 1 -> 0, then re-check the location and the data. */
+	for (i = 0; i < page_count; i++)
+		nodes[i] = 0;
+	kvm_move_pages(0, page_count, addr, nodes, status, MPOL_MF_MOVE);
+
+	kvm_move_pages(0, page_count, addr, NULL, status, 0);
+	for (i = 0; i < page_count; i++)
+		TEST_ASSERT(status[i] == 0,
+			    "Page %d should be on node 0 after round-trip", i);
+	for (i = 0; i < page_count; i++)
+		verify_page(mem + i * page_size, i, page_size, "after round-trip");
+
+	free(addr);
+	free(status);
+	free(nodes);
+	kvm_munmap(mem, total_size);
+}
+
 static void test_mbind(int fd, size_t total_size)
 {
 	const unsigned long nodemask_0 = 1; /* nid: 0 */
@@ -434,6 +510,7 @@ static void __test_guest_memfd(struct kvm_vm *vm, u64 flags)
 			gmem_test(fault_overflow, vm, flags);
 			gmem_test(numa_allocation, vm, flags);
 			__gmem_test(collapse, vm, flags, pmd_size);
+			gmem_test(migrate_folio, vm, flags);
 		} else {
 			gmem_test(fault_private, vm, flags);
 		}

-- 
2.43.0


