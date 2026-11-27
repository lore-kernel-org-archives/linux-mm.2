Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A34A9606A6AF
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 22:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ofSOttNU
Received: by kanga.kvack.org (Postfix)
	id 5CC936B05B6; Fri, 27 Nov 2026 17:50:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A2E96B05B8; Fri, 27 Nov 2026 17:50:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 491C46B05BA; Fri, 27 Nov 2026 17:50:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 082536B05B6
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 17:50:12 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7DC6B120536
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 22:50:12 +0000 (UTC)
X-FDA: 85482393864.01.B71B949
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012004.outbound.protection.outlook.com [52.101.43.4])
	by imf28.hostedemail.com (Postfix) with ESMTP id 39C31C000B
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 22:50:09 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b=ofSOttNU;
	spf=pass (imf28.hostedemail.com: domain of xinmengs@nvidia.com designates 52.101.43.4 as permitted sender) smtp.mailfrom=xinmengs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795819809;
	b=cU0F+OtCqlTP5NI8xGvq87/eDm6w6lVZcOtiB7OD8xX3qQdpbY+r1Py4mgV9IJMLvMP3ii
	Z4nE8JfURQVNzaNiOxehe6/Wjs0XBF70jElFxOfMKFDhQwbZgo3vacUvVs/Ln/0Hy8hKjk
	CmeOX4Pfw+iWtqcsZf5PjtHbAGCLvVk=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795819809;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uEXwla9JBQd8AD+nWvIbirME+iAZxIOXjbsu8IKRpHY=;
	b=QU9zFGfrQoPwTLF39mt2wnpcx9SEzL4+EaN402GY3n+Ye1uT6nfBfsUbasNtJaCZ4C5CCO
	JdAZnU/F9gUo7ixoRQERwHwWHCxXFsumE0+uoBH5XVcMyrBp+YQgfmguXKgS59NcA9xeGH
	N63y7+TFAtiXUGc2lPm5dkeCh+GEjdU=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b=ofSOttNU;
	spf=pass (imf28.hostedemail.com: domain of xinmengs@nvidia.com designates 52.101.43.4 as permitted sender) smtp.mailfrom=xinmengs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rkd8s2fQHgdi15ILnktZAMXVoyoS7nJWSqe9WZFjwoH2kO6OV6n1BZMS3XvgVBvATkqsupCphVLpBLqHLibUPJ3pZmb3JI7QocOCG/B2IxdgudIFdQJRhDRLZfkM7dApU5UZQtJanne9HW3ud+Pq9NYly4snhXEH7jYkLTWlE5pBCA8SYupzsf1Rq9GCsrzCjG9kGVuaeyWAB7pYO7z9Pxbms/xLfbO3MuVdPIZWl1VlsYK/0780K1zXIAwmdokOWN7/uTsUPqIsxcNpZx4zqC5aP8Z6uMJaf+bANSyzKL72M+7+qJC1N8yHbJV5sFP00wpsnqFNYqem4s4dg033Fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uEXwla9JBQd8AD+nWvIbirME+iAZxIOXjbsu8IKRpHY=;
 b=YF7Lm2vrhs/2w+u1c9LxJjdJAeIAecHJbQs2eZKxd1jkqJfJgBJ84zN9P/vDBSGG2d7lIY7mRYuyJ3dAeWlj9FCijl0l/53Ihjf/o6cDmmlG0ZL9RyurYGUG/iIwPMT1xGJXyNG5MjyZetN8Hw0rn2oxgN840pPfpIKtCCU9F4B3bTyHE7Llvalvhk35MuVqGbgVoRjPzguQUEmxeXn1AWppG0u/5jy0Kqh5wZjA/atVp+RWM1sICdOdMVQzD5y/bqRQfTRVFA+qSYAzCvxbTJkPP72xRchFr8+lCFuWvpprBLv8X7kGqCSWMb8MnvNavHZker3jUAFGbQFn1jwZ8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uEXwla9JBQd8AD+nWvIbirME+iAZxIOXjbsu8IKRpHY=;
 b=ofSOttNUBnBD2j1AuewKoBnviHH5XyxKR86NrV7GoG7HuFxHdZ+mo8itbYQjRgL8DImy8a3jd3PwWUDoIJahIB+U07k9o58TrPnWo/AnT390vGSUPfRO1NpcO/+77ge9R7vK3OXYZUZ/vbS2uSpAtTAbrjfvSYwRYmrrUlIQ2fTXBO3Ncv7nioYsbEY21/eoi1NeVh7NQ4IcpxVIGTtmCxvk3xiOe/IdwWbx7hP2dlH5cObJczqo1cdlsdmWZUDG1gLLxUv2iTv7+p4HkooymIH3SsOAG+e40TT4BFMcXlLBNW2PakGvyIZjs8ddiwDVKAlhdvCbd0dNVXxGlHMDng==
Received: from PH8P221CA0038.NAMP221.PROD.OUTLOOK.COM (2603:10b6:510:346::9)
 by MN0PR12MB6318.namprd12.prod.outlook.com (2603:10b6:208:3c1::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.10; Fri, 27 Nov
 2026 22:50:01 +0000
Received: from BY1PEPF000264B0.namprd02.prod.outlook.com
 (2603:10b6:510:346:cafe::41) by PH8P221CA0038.outlook.office365.com
 (2603:10b6:510:346::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.662.11 via Frontend Transport; Fri,
 27 Nov 2026 22:50:01 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BY1PEPF000264B0.mail.protection.outlook.com (10.167.242.119) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.662.3 via Frontend Transport; Fri, 27 Nov 2026 22:50:01 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Fri, 27 Nov
 2026 14:49:53 -0800
Received: from xinmengs-dev-vm-linux.nvidia.com (10.126.231.37) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Fri, 27 Nov 2026 14:49:51 -0800
From: Simon Song <xinmengs@nvidia.com>
To: <dakr@kernel.org>, <acourbot@nvidia.com>, <kvm@vger.kernel.org>,
	<rust-for-linux@vger.kernel.org>, <nova-gpu@lists.linux.dev>,
	<linux-pci@vger.kernel.org>
CC: Simon Song <xinmengs@nvidia.com>, <alex@shazbot.org>, <jgg@nvidia.com>,
	<yishaih@nvidia.com>, <skolothumtho@nvidia.com>, <kevin.tian@intel.com>,
	<airlied@gmail.com>, <simona@ffwll.ch>, <ojeda@kernel.org>,
	<alex.gaynor@gmail.com>, <boqun.feng@gmail.com>, <gary@garyguo.net>,
	<bjorn3_gh@protonmail.com>, <lossin@kernel.org>, <a.hindborg@kernel.org>,
	<aliceryhl@google.com>, <tmgross@umich.edu>, <jhubbard@nvidia.com>,
	<ecourtney@nvidia.com>, <cjia@nvidia.com>, <smitra@nvidia.com>,
	<kjaju@nvidia.com>, <alkumar@nvidia.com>, <ankita@nvidia.com>,
	<aniketa@nvidia.com>, <kwankhede@nvidia.com>, <targupta@nvidia.com>,
	<linux-kernel@vger.kernel.org>, <zhiwang@kernel.org>, <zhiw@nvidia.com>,
	<boqun@kernel.org>, <daniel.almeida@collabora.com>, <tamird@kernel.org>,
	<work@onurozkan.dev>, <jgg@ziepe.ca>, <bhelgaas@google.com>,
	<kwilczynski@kernel.org>, <dri-devel@lists.freedesktop.org>,
	<peter@colberg.org>, "Liam R. Howlett" <liam@infradead.org>,
	<linux-mm@kvack.org>, Lorenzo Stoakes <ljs@kernel.org>
Subject: [PATCH v4 2/5] rust: mm: add VmaRef::size() and VmaRef::pgoff()
Date: Fri, 27 Nov 2026 14:49:14 -0800
Message-ID: <20261127224928.1511382-3-xinmengs@nvidia.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20261127224928.1511382-1-xinmengs@nvidia.com>
References: <20261127224928.1511382-1-xinmengs@nvidia.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY1PEPF000264B0:EE_|MN0PR12MB6318:EE_
X-MS-Office365-Filtering-Correlation-Id: bd61a0e0-3aa8-4fa0-7820-08df4cd8c50d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|7416014|36860700016|23010399003|22082099003|18002099003|6133799003|261102123227099003|261021121427099003|11063799006|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	2JVJur91vtq36VIPD0mL+LUTFtFSoblao8CZaa3job7mOAYWRsrp17dqpmPJgXEro/iEICOHcjxO0wMlGdTKcU+5BCdqYmC2oyfoBlvtsBZ0SmrDghfGW0JS8a/8nlvYsYNwZPh4Pcep+aibV6ClVEKNxAK5wvBS/eepSFs1fOG+IK/rdbmQWPhwecSC6Ylx7xMMile6YNRYUX8VRmAPERamrdsvEDH/yNUAVhvRa+NFdQMrVXBK508PvXqL64iF/Obp+GQCi9r3eArGQa6KWAdGyxjzunGOjRjW4qiwqg54zp05d6A8Cik7S9EzEzi0kaWL/roP9IB8B1JCqklMC59LTpDL6XDY3u5Ut9WtL9yrJfUdjH8zealn1E1ffNXLSONUCuuffCd/bZkK8biY84K1Ar25mOrRPsgdrj/6m6f4FM9BgO0AYur+s/HAtAOOHGBYkTzkwdqBEiwBdBucWZcl0m641sTOq2H6OSt3wTsRAkJ+HZbIMZu9nYCQ+/LlnQbUgpDxFy1e9Qn16QWzxS7muePROo68g9zl/F8a0e2Nb4gySGZQhmB4kxFtHxgoPsjZY7Ej77Q3v+3JEiJHMwg3FQXNHS8NuiOR+pV1jT6OgqrfbeXoCj7ZZatijTDDw/ahMpVxhPydQWZ4oUmxeAyfHSb9psCS9lOxyyD2RWD+RUXnY7n6UozkOqoWwrE5kLUvyMZVHQnRBYv/tsorMA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(7416014)(36860700016)(23010399003)(22082099003)(18002099003)(6133799003)(261102123227099003)(261021121427099003)(11063799006)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Lu+MbUX7QHTlakqoJrN5e/gphICptdJLkuj5+Iltblq/cTZRsX4ZJddI8mJAA3VTREiRwgFuuauMN7aN6avNlA59aMDeKkgq4oL4BLqj3BAdc9vxjAKsRAzCaziRPFw0CNf5aZiJp06Jzp4cSJOJ0O0y8MWPDrku3KpH6TWpQKgcJPFoHhBLhsDZh0xHHbj1ZeAeg0EkMpZfrg5wiAvvJgUj40WFgrydH3vkHnijVmzwntcjFydcTGOTThJR85rD3I8F/58/w0WiXPtGWnPPoGGm+7I1wVJh6QnOl6X2gRPFrTGVeAPsgRfzX8vWmSFcpRjO12ydCJtIEjrYFXooNi4d56Mqg01+S3K8OuERM1hI+9iMNPNHqQ5WnNaMKOQieQ7SWMN2lt0FOD7bgNoeUpaWxn/dr92zk6+FUShw6R5XHMHvIGsjyhz5Fujt+PXb
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2026 22:50:01.2294
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bd61a0e0-3aa8-4fa0-7820-08df4cd8c50d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BY1PEPF000264B0.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6318
X-Rspam-User:
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 39C31C000B
X-Stat-Signature: 8scm7kwu47ah4x5x5usoc35x31gmjieg
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795819809-333041
X-HE-Meta: U2FsdGVkX192YUK2u3Pb5y5SoibIB9wk3f6WAg3Yy3I9+vAln7cn3rhV6KU6WR67fBQKZWuU1ddo7cud8UFTMrY+58QBlTX76Afy5RMgmLN4LQPcObrTxBParcgSPD7Dlj1F1rMPvZU6gzWP0bgRBSkZBwkTqAivxQ0qAwHKF2qv8yaGM4ZbqgmQRaVNhpJkXbb9jTNv7hjO/iXOrwYz3wc+MplbnU33pcPZenN+GvULV1ueTdsthlhIeBNndYvz3n9YGrusHKmDbyu7SinE1+TQH2AF1agy2ey+Lqm/VcZXoYtb0zm20gITsfU3Gi1em7osuvjEivjy3kjAR+jbYgfK8sbcPb2Ap8tfw3vAsDltVmyY4qLJ75cxuDLwZ3ezbZEICpYrL+IJjCZWLtTbSjZ7Nt9bHW8dlZGr+7B+tiuinpPn4QbZyI1zz6GUkOlkgZ/774yMGl9v8MEyN9AMpmCgAlA8dO95X1CErjFhLKI8O8U+6cKvRs2pm60xQpxCB9nMx/LaG8tBF0iY4uj/nRS271ZJa3bKqlqKxKUC0H4pTIGsC6DPmqzN4BFBZ23dYfrfyfg3eBHijhLAUCREHiNzPKxope7q+DBC75TPEj4HQ1i7WrUhV2oTtlRDleGL4vqTQnxyWrYRTxvFntblOKIHXd+k5yBQjcbRYqJbBUuuCDJbCmYuA2yzw5s1vjf3mQwFAfN0gJFlEhT+0/h/WnJsfXz1oStq7Uj1TXE16o9cQ+H715eMMQNrSYiimwZErmWpmJCZCkXW5w/eB5upvu1fgNmIqt8p4Ges/AjLZgyz7pVwKIxJZBsu1fRPqbuILJIRrHZRFZlmAIG7yT2NTkTqEGyi9xEb1SAofmlQSlCobHS/pIIWLiGCmiR6GMV2teIMoIC/Td+3bdtd3R8tLP3PvwRqeDHuzuHNv55M6ZWi8qioDJ0nYCUJeeuwiLu7Tuw5Z20XnB0ScdYWz9V
 aHe+JvlA
 b90ocdSZYPFrZvvrhmgrXXiUdL8gOZaZT9wqybvleiTGazhJuVt/eL8fCw4T2wZUmJPfd+/2K7dTBJeg7j+0fdXXjNX9ueASgktxGlFStKctkxyJS66w8XMzN7V38uspOaMbcU4SFMItUrK0TXVrDvH35S4+up4uar0cJ88OKmJc3qFzg1Cl7X0WMxuCC9dDBTVFjMfgpbpf5OHIS/vnH+t0kFam5wiHakBPhq/psjCFQ/DV1ADEoIsiqr5YNCfXsitw0BxBLzsT0uEzMUesH4y6DW5TkjAPSAHVnVHgmDc0qYXvwdUtbzIs27INmnrR710PXjeQlQJEm6/58FHe1wLgHO5INO0GUcG3VgIH9rkKaCZls1Yrv7BQ7oAPFO/GxBxGrPO5sjkPLA/vhiKBBKwxr0CVUzOouh1mRE6Qh46vaR7hUoR9T+NlkKyX98sBbORDODkWxOZVuKsaGI5fyhhUlYLKm7OhGcYxMYD9sTdHKLArPptazor6xM899eow5K3uSexL2s//0zbPsL8EpwAnHa53eHA45Po+TZ50FL8JgC584rXvBul4kN0EQK+uKPobgc9GSDS/+CtTG3LL8pain57l64Ut6dmVQkas+G8KUeUJSgSgRRPultTKnX8T4UWABvcvjjFTtzwf1YbqLWuPvL5xCay5x0TbAb3BHCsUXGv3200wXIZCfSTC6Oilpf5l0ArmTQEGSNHHDU9jUTnM71MisnwiBdZWj0STyELga+7+4yBERDMTZK13GnMJEf7qG6aN8wuEwfWoeNtd6VxlvpvbCFu4WOZ+HFZ8x03OjIyonauhvvgj0054sb1AX3PelgMAQKB1AHlxHNvHYmtljt4hfEzn1Liy+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The forthcoming VFIO PCI abstraction needs VMA page offsets and byte
lengths for mapping bounds checks. Keeping these queries on VmaRef
confines unsafe field access to the MM abstraction and avoids repeated
length calculations in callers.

Suggested-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Simon Song <xinmengs@nvidia.com>
---
 rust/kernel/mm/virt.rs | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/rust/kernel/mm/virt.rs b/rust/kernel/mm/virt.rs
index 63eb730b0b055..b0210869b757a 100644
--- a/rust/kernel/mm/virt.rs
+++ b/rust/kernel/mm/virt.rs
@@ -92,6 +92,20 @@ pub fn end(&self) -> usize {
         unsafe { (*self.as_ptr()).__bindgen_anon_1.__bindgen_anon_1.vm_end }
     }
 
+    /// Returns the size of the virtual memory area in bytes.
+    #[inline]
+    pub fn size(&self) -> usize {
+        self.end() - self.start()
+    }
+
+    /// Returns the VMA's page offset (`vm_pgoff`).
+    #[inline]
+    pub fn pgoff(&self) -> usize {
+        // SAFETY: By `VmaRef`'s invariants, the VMA is valid and the mmap/VMA read lock prevents
+        // concurrent modification.
+        unsafe { (*self.as_ptr()).vm_pgoff }
+    }
+
     /// Zap pages in the given page range.
     ///
     /// This clears page table mappings for the range at the leaf level, leaving all other page
-- 
2.43.7


