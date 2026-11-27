Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32904606A31F
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 22:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=uasFVoWX
Received: by kanga.kvack.org (Postfix)
	id CD0C26B05B8; Fri, 27 Nov 2026 17:50:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA83E6B05BA; Fri, 27 Nov 2026 17:50:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B97436B05BB; Fri, 27 Nov 2026 17:50:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D4CAF6B05B8
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 17:50:15 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0C5E6C033E
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 22:50:15 +0000 (UTC)
X-FDA: 85482393990.05.3120E91
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010026.outbound.protection.outlook.com [52.101.61.26])
	by imf25.hostedemail.com (Postfix) with ESMTP id C29B6A0003
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 22:50:11 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b=uasFVoWX;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of xinmengs@nvidia.com designates 52.101.61.26 as permitted sender) smtp.mailfrom=xinmengs@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795819812;
	b=rMKaG6q3ioSb1EMOWnkEbMcv8Lc53AAtbD12Aocccpty0pS0VYo3Z4kYZ5MViUAGoLae6T
	B3VyC630zxwG65aZ/P0EATM37uceV0f72N6qyzD8o1fFijQ9HZ/kVfB9Ywkk5sW6khSD9C
	0B6MN5iaAUvIiKy3/CXeaTkIp48LERo=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795819812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ugiAJo1m4j37Ky6v04zwSEEko4W55GR4YQCjOXpNXkM=;
	b=8odBEaydX8E44phJuolIkMAvnb+1WQ43dgT3dg8kfaR1JOslujtd66OLdmW0v12rAXZI7h
	4alD7FLtKU4VT1kLPuFlRJ/TR4Ve88C0aXe+6EzubiOz7YnFQW49m3sZTq+Sf0DtRZhFCV
	Qv81QJgSQW+3uFPJoKpflNCgCPQ0+pI=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b=uasFVoWX;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of xinmengs@nvidia.com designates 52.101.61.26 as permitted sender) smtp.mailfrom=xinmengs@nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EOD3s487NW3hUmaTFsNavAiXm4fndkBHOhRwcuIkIguxIGZHumBuTVjjyLwqWDZqU8FrjBTzYAznj5G/RMZUjmakW027nEBrFmVRSzbp+bcholfACYEYNfv5R75rVDZ8pQ3hQESbzTSj3RqPH2nqSkOauA0lZELDHhFCh6gvdGEW88ag3BmN5b9jt+QLwQaAJDm07bBfFEUBa58JgQhfpzBUFjFWcVPcoeSVvi7y/9eObr18iJIZVb+ChmC3j952x5C36gIqRXgyIAJaIETwtbZKjJcGQKV4MgT8YuTP3VG+nLefhLvNY1zHoYdWwaaTBj2Vck3QQF+Pol+7kPPhjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ugiAJo1m4j37Ky6v04zwSEEko4W55GR4YQCjOXpNXkM=;
 b=Tuf6dAMaEuDn6J8SxchBp/snuUZvPMFBVV+thh1nNj3dgzYt2mxzxGGVwHL8S2E80/wxQP8dKt2LwnfK2enWXUQ69cz2V+fZbK3+IP2662nP92/qEcDgXfrx6eWvEOFFxuR66g/eH8u5M/sysMP/UZIk8vDNc+WT20qnXDFjnhm613doXqXiva1zN3Qv9r/8jy4Tb71TKol5OfH3q7DbLSdFJ3KjJ9H+uFWDrFPXCy1KEQfsE2JTj/YJk9JfjKMIHxcXYh8ZXM+DI+QANohg7RF3nq89AD9P/1FZ2dTcxZg2HH4QS0HneGpCfZdqm2VRkMp9DHSRGiITC25xajSpUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ugiAJo1m4j37Ky6v04zwSEEko4W55GR4YQCjOXpNXkM=;
 b=uasFVoWXO3uTsIZ2xY6K5CiIJ+xhmJGKxbth7RgnIAU2KuE9gAOrgVWSju/x1HI8nL479EGzoBhoZNLHyUVfCG3MhJ5TnRVhoJ6SLzQG5QIsLrRP/I0O4BYtQpPAfCj+ByK138O/1wI2LFBi4YDcu1uBiRhn37t+toCCwBSK/RqMQIz5NXCm0jUbhCQFWxO9BrNc2kijoA5yNPBmuVNILM7K6Z0CT7w9Kvo9GrE9KPvYlcRiVA7Sr/L0sU8t+6ws8SHb2AVWbTvD9Nu9tB5YzCJs2ugKrZwmlgOsSEDGVPi8rlnppRM/eBeLlhabplPj7OCJWmXNdgoR9aOQhlRzAg==
Received: from BN9PR03CA0476.namprd03.prod.outlook.com (2603:10b6:408:139::31)
 by LV1PR12MB999330.namprd12.prod.outlook.com (2603:10b6:408:3f8::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.10; Fri, 27 Nov
 2026 22:50:03 +0000
Received: from BN7PEPF00000092.namprd03.prod.outlook.com
 (2603:10b6:408:139:cafe::9d) by BN9PR03CA0476.outlook.office365.com
 (2603:10b6:408:139::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.662.11 via Frontend Transport; Fri,
 27 Nov 2026 22:50:03 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN7PEPF00000092.mail.protection.outlook.com (10.167.245.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.688.5 via Frontend Transport; Fri, 27 Nov 2026 22:50:03 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Fri, 27 Nov
 2026 14:49:55 -0800
Received: from xinmengs-dev-vm-linux.nvidia.com (10.126.231.37) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Fri, 27 Nov 2026 14:49:53 -0800
From: Simon Song <xinmengs@nvidia.com>
To: <dakr@kernel.org>, <acourbot@nvidia.com>, <kvm@vger.kernel.org>,
	<rust-for-linux@vger.kernel.org>, <nova-gpu@lists.linux.dev>,
	<linux-pci@vger.kernel.org>
CC: <alex@shazbot.org>, <jgg@nvidia.com>, <yishaih@nvidia.com>,
	<skolothumtho@nvidia.com>, <kevin.tian@intel.com>, <airlied@gmail.com>,
	<simona@ffwll.ch>, <ojeda@kernel.org>, <alex.gaynor@gmail.com>,
	<boqun.feng@gmail.com>, <gary@garyguo.net>, <bjorn3_gh@protonmail.com>,
	<lossin@kernel.org>, <a.hindborg@kernel.org>, <aliceryhl@google.com>,
	<tmgross@umich.edu>, <jhubbard@nvidia.com>, <ecourtney@nvidia.com>,
	<cjia@nvidia.com>, <smitra@nvidia.com>, <kjaju@nvidia.com>,
	<alkumar@nvidia.com>, <ankita@nvidia.com>, <aniketa@nvidia.com>,
	<kwankhede@nvidia.com>, <targupta@nvidia.com>,
	<linux-kernel@vger.kernel.org>, <zhiwang@kernel.org>, <zhiw@nvidia.com>,
	<boqun@kernel.org>, <daniel.almeida@collabora.com>, <tamird@kernel.org>,
	<work@onurozkan.dev>, <jgg@ziepe.ca>, <bhelgaas@google.com>,
	<kwilczynski@kernel.org>, <dri-devel@lists.freedesktop.org>,
	<peter@colberg.org>, <xinmengs@nvidia.com>, "Liam R. Howlett"
	<liam@infradead.org>, <linux-mm@kvack.org>, Lorenzo Stoakes <ljs@kernel.org>
Subject: [PATCH v4 3/5] rust: vfio: add PCI variant driver abstractions
Date: Fri, 27 Nov 2026 14:49:15 -0800
Message-ID: <20261127224928.1511382-4-xinmengs@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN7PEPF00000092:EE_|LV1PR12MB999330:EE_
X-MS-Office365-Filtering-Correlation-Id: 62b3bbfe-df72-48f6-38b0-08df4cd8c6a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|36860700016|82310400026|23010399003|6133799003|18002099003|22082099003|261009223027099003|10067099003|3023799007|261026140227099003|261026121527099003|261021123027099003|261021121427099003|261102130727099003|261028144727099003|261102123227099003|261022113327099003|261022105027099003|261022075727099003|5023799004|11063799006|56012099006|260925021311599003|260925021911599003|260925022911599003;
X-Microsoft-Antispam-Message-Info:
	kyZqIJJa1c++SsWNjRKK3xtMWmXdjWsIAiIpN4uuQgt7HQEnA+ZszwVtSMK60XvWk3y7dAX9hV1a/gXTHnSMEHcSanUXPwN3k52vEWvv3ufeJn3MNtqn3G2KdamJ867moF3cSft3yNinbVq7gRrrnLeZLHBbw7oDlw4EM4v3B44i1ep5mWYqDo8WbNKr0FyWKpZbASlUVzl03Rynqq57f9x3+g197uBx2b+XVcpebdIU7j7tMelSso+NDickij3XsCt12urFF04IF8EiNSXtbc6BupnMOq6J/9llLa39Vge0g6AXRx7Cni2YwXle/Ho2GRx1fsu5trmS9J8n2hUhwbMr15ILiKrfYj834OPwmaLaVNcLCwPPlPYFNtrYojT/Y4/MlUjqSyunt/KJlpKQFjD4ypfuZTGO0RRdI20NDl4aOyRKZvBLKxZo2NbwTzhn0eSqB8LtwrSDDl0Vmv+mw4UfqqHGjqv1NDsw4o4F5Vd4nNGR00p/vkzv/evGjKlm6ruHF3htqDi4Ip9rXgqQ/E+OJjZfz0X26haFcc1NFQp1n8ZkXHeI8VwfPNTlheKEX/aGduLhn+Csi1ZM9LEUXrQJJSj3cND/o6k7/1BQ19aQndMbaXT+jaEUjlJBsNXyj3+cV+77Da2mQx23Hr2IKrHVlSWgFi9H8Lz+Vo/PMDJ7Kw4UnH700BJcDsyhs6cl0ml39qMRjavIjn6TAAGy2g==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(36860700016)(82310400026)(23010399003)(6133799003)(18002099003)(22082099003)(261009223027099003)(10067099003)(3023799007)(261026140227099003)(261026121527099003)(261021123027099003)(261021121427099003)(261102130727099003)(261028144727099003)(261102123227099003)(261022113327099003)(261022105027099003)(261022075727099003)(5023799004)(11063799006)(56012099006)(260925021311599003)(260925021911599003)(260925022911599003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	C7EgbmtVwNwmtckedV+xrlFk6QgjjF0nRU87a/EC609EkH+CJLYvGizRcIbrNYdcXsfYWJw67rPodTiZ1guE2ZdTcYlq+96jRZVnkCqq08SQh8tUDIG65a837fJZjomVDjKQIG9LnCOAeK0lWAvNrPeJt6fq6s6o4od1vik70itD1E9DMQHAbtf+SqVlMiHQ7yksJTRrgs1NIEiXNZrNpA97q5SFmijVYqIBz4XX0PCpKRtW8frTrd6QyUR/SKBJ6xvcTJyIlzE3rbYKmDAbc6eI05OgI7LnkMEbwrvFbOVWWt1SrYUP0RiVwZXBL8pOQfF5pKvQh7d3nPZjRYfRHQmjwsM1BgpNPfJlBEmNWzgSmpcPUZCTCzJbLWC9wD3qPRv894KkcEdi+6GEqdGUO3bhCK2vyfMm3oWpTKEKbis61omRInHcOzEv0PCk650T
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2026 22:50:03.7767
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 62b3bbfe-df72-48f6-38b0-08df4cd8c6a3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN7PEPF00000092.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV1PR12MB999330
X-Rspam-User:
X-Stat-Signature: smhsqd4grz46ydpg1gppabzcjyw8simd
X-Rspamd-Queue-Id: C29B6A0003
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795819811-964354
X-HE-Meta: U2FsdGVkX1+rg1LY0OUWQEYJHHTTTxkM+K5QEp/C5w7P0o9TF7bIu1qNwEp3HRDOviC25AdV/w8YZ/3QMHB2BZVH+UAgXQtLqQezBdqwFcR9i8QW3G0rTztzEg9m0Gk4ZD+X3XoFnj3TaV0VWTGLlv8SAyjxINYFdmKx6943Zd51jDnlUo9NQ0d4lFNbzijhxb++Y8DbM5/Feo/bJpOxs93mMsR0lRgwfAPKoxtvSzj9DpEKALiaQU82YDRKzZ9B8IF0CAvkh3XQIZU3BZcIoaRzVeVJXGiO03qSOcexTVz+xeR5zowUk89ryFptPqLW46t5BSh2MWoy18L2K3KgIw1Tc0cSuIF7M936jOpl7vt4WyEXCT3BwuVMhzf0F7qJVHospbUbTarYh5ejbk1romFnTxmVQgVBVX47jwcpkmmBd6cRfZNZncf1RF8nGsVXMtVToFVzqNoOrI6LIb0AniSNbqc1ul3nmbWwFw/3XzSfA0pPowtGFY+htGXOjiMCZ8lUN1sLEdRIIxJW9s8b8o4LirdYY1PfntGwin35q0lqO+9njxEmlElW6ArZ2RrifIZrm8w1hraKCDQuNcYwd+fN5r4etUKV3DfdOdWwarFFI23hgThJVGjE0YR6Y3PHYbaefcX/1IXJiGXjTFjPeGCAGsQndtZdV5isK8zPerCtjIHK7SGSb7dlRiBIrpGb2mYDSzDPnw9kh7O4SR4AtJJugkdnmA8O68bBf+oguLfQ5obrlE3xuoP+ZCVqbhJu/g16++SWEJc9kYOxZFCk5Fm99CQPV628sYiD69utjyYHKGXnjhhl1pZW0P9G0uL2XDXofhSaZfOGYvznSvRKr6HXJsd435dmVdxFBMSLIMXm+ZM355gIk6E2SkdnpglctRMFRIq4R8PAhyUCpOfAkvvSsAGwxVXglR9NMNf8U7CfxOF6+d5h5YU7i+tIvICr1OPRLzOCpoNMfm9HnSX
 5/AagqAc
 W9lQ8nV48PQvAJVNAF8dqEY522xcLHtm36fbDz10emL5lptIU71ZfeJnbd7W609elbQL1r44gTCVkeJZ3gcvLNiLmIEnTJX455MeKEmZVisxjuXEOuMPS5W24dJ1kF8vazB4xomNr07saJwyvGenT0w8aZEfS9Ryj9+vWCK89RmXKI1thKEIq7hcwFBv80h8uc+WGGvgwoltBcysXN7xkyWF0/yatUspgTDtiEMBlgIWYz3E0ciOpvN48GyDoU329Xw5AO+ko27oiFIvYPjak2wvOp4Kii3ACE/oUBJnsUvF9g7zSysLjKcpJcJx0xzmbhte1WpmNWpe649110QnMmCQ5TJfnz/r3LNEnkuKOjzei7mB1YS+ByzWapsdGKQ4kdWZjjV5/TlYa/2a1jmiDhO7jcAvmri/cszs6N8Xnu+mxIuC/gGvqOcpo1p8/Y/dOhawWNSr6gu3tJxjMX8AfpnHXBW1/QkjpQ0uFb9ZTUXXnWyA9FTKUM0H1Kw9g7SFH7uFja0xCIkqycmsQ1+FYCZkhdD+28lXMD8buUU8PqMsbw5vxqE5b3TPfQdyuEX2fhC4RkmHLzs46tEEJn61nM+KfHIJXV75H33GuRyY0vTAhyqvLYhGh9FqSqjRSFGyDqsRzLzlBDfje70ZUn9iQ32ecVXfigFBtHfVMO2NirSYqAHDfRCSbcloiANj09nlkKv4H7wynKmXrOGdVQONRq2p3YaHCauafx5Upxi4xhi3Ov0IEcjQB1vsOBPS5LkQNCWK40oKdRQQwsPH5XxOseYBeqJbXF8BazS8sVnqw93wXgK3oa9duSuvYeHSsQA0B82mWx7Krti3yp+ClnS1ZUKEvcp9XoNtZD+tbdDvM1zXeLEpuA2KKX4wM13pIezkxBjGunk7MaNBhL2VM6xEdGhRKgg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Danilo Krummrich <dakr@kernel.org>

Add Rust abstractions for PCI drivers that extend vfio-pci-core with
device-specific operations.

Provide Operations, Device and Registration with separate registration
and first-open/last-close data. Allow open data to borrow registration
data, undo PCI enablement if open fails, and drop open data before
closing the core device.

Let a driver register its VFIO device with Registration::new(), for
example from its PCI probe callback, and unregister it by dropping the
Registration. Let drivers forward PCI reset and error callbacks through
the Registration. Let vfio-pci-core select its VGA arbitration
callbacks. Because runtime PM support follows in a separate patch
series, keep the device active while it is registered.

Restrict core I/O helpers to their corresponding callback contexts. Add
region mapping helpers, and wire up VFIO core support for device
features, matching, IOMMUFD and PASID. Allow drivers to export physical
BARs as DMA buffers with per-region length limits.

Add pci::ErsResult::from_raw() for the result of the VFIO PCI core's
error handler.

Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Zhi Wang <zhiw@nvidia.com>
Signed-off-by: Simon Song <xinmengs@nvidia.com>
---
 rust/bindings/bindings_helper.h |   2 +
 rust/kernel/pci.rs              |  12 +
 rust/kernel/vfio.rs             |  24 +-
 rust/kernel/vfio/pci.rs         | 812 ++++++++++++++++++++++++++++++++
 4 files changed, 842 insertions(+), 8 deletions(-)
 create mode 100644 rust/kernel/vfio/pci.rs

diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings_helper.h
index a5781bc1ea85f..b052f1e874e25 100644
--- a/rust/bindings/bindings_helper.h
+++ b/rust/bindings/bindings_helper.h
@@ -94,6 +94,7 @@
 #include <linux/tracepoint.h>
 #include <linux/usb.h>
 #include <linux/vfio.h>
+#include <linux/vfio_pci_core.h>
 #include <linux/wait.h>
 #include <linux/workqueue.h>
 #include <linux/xarray.h>
@@ -117,6 +118,7 @@ const size_t RUST_CONST_HELPER_ARCH_SLAB_MINALIGN = ARCH_SLAB_MINALIGN;
 const size_t RUST_CONST_HELPER_ARCH_KMALLOC_MINALIGN = ARCH_KMALLOC_MINALIGN;
 const size_t RUST_CONST_HELPER_PAGE_SIZE = PAGE_SIZE;
 const unsigned int RUST_CONST_HELPER_VFIO_DEVICE_RESET = VFIO_DEVICE_RESET;
+const unsigned int RUST_CONST_HELPER_VFIO_DEVICE_PCI_HOT_RESET = VFIO_DEVICE_PCI_HOT_RESET;
 const size_t RUST_CONST_HELPER_GENLMSG_DEFAULT_SIZE = GENLMSG_DEFAULT_SIZE;
 const gfp_t RUST_CONST_HELPER_GFP_ATOMIC = GFP_ATOMIC;
 const gfp_t RUST_CONST_HELPER_GFP_KERNEL = GFP_KERNEL;
diff --git a/rust/kernel/pci.rs b/rust/kernel/pci.rs
index 3fa6831fe34d8..d6f5b0a9dfc7f 100644
--- a/rust/kernel/pci.rs
+++ b/rust/kernel/pci.rs
@@ -428,6 +428,18 @@ pub enum ErsResult {
 }
 
 impl ErsResult {
+    #[cfg_attr(not(CONFIG_VFIO_PCI_CORE = "y"), expect(dead_code))]
+    pub(crate) fn from_raw(result: bindings::pci_ers_result_t) -> Option<Self> {
+        match result {
+            bindings::pci_ers_result_PCI_ERS_RESULT_NONE => Some(Self::None),
+            bindings::pci_ers_result_PCI_ERS_RESULT_CAN_RECOVER => Some(Self::CanRecover),
+            bindings::pci_ers_result_PCI_ERS_RESULT_NEED_RESET => Some(Self::NeedReset),
+            bindings::pci_ers_result_PCI_ERS_RESULT_DISCONNECT => Some(Self::Disconnect),
+            bindings::pci_ers_result_PCI_ERS_RESULT_RECOVERED => Some(Self::Recovered),
+            _ => None,
+        }
+    }
+
     fn as_raw(self) -> bindings::pci_ers_result_t {
         match self {
             Self::None => bindings::pci_ers_result_PCI_ERS_RESULT_NONE,
diff --git a/rust/kernel/vfio.rs b/rust/kernel/vfio.rs
index f49ff5931df56..ff8b17819ca58 100644
--- a/rust/kernel/vfio.rs
+++ b/rust/kernel/vfio.rs
@@ -3,7 +3,12 @@
 //! Virtual Function I/O (VFIO) devices and callback data.
 //!
 //! `DeviceBase` combines a C VFIO device structure with the data its callbacks use.
-//! [`Device`] is an alias of it for `struct vfio_device`.
+//! [`Device`] and the bus-specific devices are aliases of it, such as
+#![cfg_attr(
+    CONFIG_VFIO_PCI_CORE = "y",
+    doc = "[`vfio::pci::Device`](kernel::vfio::pci::Device)."
+)]
+#![cfg_attr(not(CONFIG_VFIO_PCI_CORE = "y"), doc = "`vfio::pci::Device`.")]
 //!
 //! C header: [`include/linux/vfio.h`](srctree/include/linux/vfio.h)
 
@@ -28,6 +33,9 @@
     ptr::NonNull, //
 };
 
+#[cfg(CONFIG_VFIO_PCI_CORE = "y")]
+pub mod pci;
+
 /// Reset the VFIO device.
 pub const DEVICE_RESET: u32 = bindings::VFIO_DEVICE_RESET;
 
@@ -91,7 +99,7 @@ impl IoContext for GetRegionInfo {}
 
 /// The data the driver of a [`Device`] shares with its callbacks.
 ///
-/// Bus-specific operations traits extend this trait.
+/// Bus-specific operations traits, such as `vfio::pci::Operations`, extend this trait.
 pub trait Operations: Sized + Send + Sync + 'static {
     /// Data owned by the registration and passed to VFIO callbacks.
     ///
@@ -127,7 +135,7 @@ struct CallbackData<T: Operations> {
 /// `raw` is the first field, so the `vfio_device` at the beginning of `Raw` is also at the
 /// beginning of `Self`, as `vfio_alloc_device()` requires.
 ///
-/// Use the alias [`Device`].
+/// Use the aliases [`Device`] and `vfio::pci::Device`.
 ///
 /// # Invariants
 ///
@@ -148,7 +156,7 @@ pub struct DeviceBase<Raw, T: Operations, Ctx: DeviceContext = Normal> {
 /// A VFIO device, wrapping `struct vfio_device`.
 pub type Device<T, Ctx = Normal> = DeviceBase<bindings::vfio_device, T, Ctx>;
 
-#[expect(dead_code)]
+#[cfg_attr(not(CONFIG_VFIO_PCI_CORE = "y"), expect(dead_code))]
 impl<Raw, T: Operations, Ctx: DeviceContext> DeviceBase<Raw, T, Ctx> {
     /// Initializes the Rust fields of a newly allocated device.
     ///
@@ -193,7 +201,7 @@ fn as_raw_vfio(&self) -> *mut bindings::vfio_device {
     }
 }
 
-#[expect(dead_code)]
+#[cfg_attr(not(CONFIG_VFIO_PCI_CORE = "y"), expect(dead_code))]
 impl<Raw, T: Operations> DeviceBase<Raw, T> {
     /// Publishes the registration data passed to callbacks.
     ///
@@ -240,7 +248,7 @@ unsafe fn close(&self) {
     }
 }
 
-#[expect(dead_code)]
+#[cfg_attr(not(CONFIG_VFIO_PCI_CORE = "y"), expect(dead_code))]
 impl<Raw, T: Operations> DeviceBase<Raw, T, Open> {
     /// Creates the open data from the registration data.
     ///
@@ -284,7 +292,7 @@ unsafe fn open<'a, 'reg: 'a, I>(
     }
 }
 
-#[expect(dead_code)]
+#[cfg_attr(not(CONFIG_VFIO_PCI_CORE = "y"), expect(dead_code))]
 impl<Raw, T: Operations, Ctx: IoContext> DeviceBase<Raw, T, Ctx> {
     /// Returns the registration data and the open data, for an I/O callback.
     ///
@@ -345,7 +353,7 @@ unsafe impl<Raw, T: Operations> Sync for DeviceBase<Raw, T> {}
 
 /// Capability buffer supplied by VFIO for a region-info callback.
 pub struct InfoCap<'a> {
-    #[expect(dead_code)]
+    #[cfg_attr(not(CONFIG_VFIO_PCI_CORE = "y"), expect(dead_code))]
     raw: &'a mut bindings::vfio_info_cap,
 }
 
diff --git a/rust/kernel/vfio/pci.rs b/rust/kernel/vfio/pci.rs
new file mode 100644
index 0000000000000..6805915414b55
--- /dev/null
+++ b/rust/kernel/vfio/pci.rs
@@ -0,0 +1,812 @@
+// SPDX-License-Identifier: GPL-2.0
+
+//! VFIO PCI variant driver abstractions.
+//!
+//! Provides Rust abstractions for writing VFIO PCI variant drivers (also known
+//! as "VFIO PCI core" drivers). A [`Registration`] struct registers the VFIO
+//! device and owns its registration data, tying resource lifetimes to the PCI
+//! driver's binding scope.
+//!
+//! C header: [`include/linux/vfio_pci_core.h`](srctree/include/linux/vfio_pci_core.h)
+
+use super::{
+    DeviceBase,
+    InfoCap,
+    UserBuf, //
+};
+pub use super::{
+    DeviceContext,
+    GetRegionInfo,
+    IoContext,
+    Ioctl,
+    Mmap,
+    Normal,
+    Open,
+    Read,
+    Write, //
+};
+
+use crate::{
+    alloc::allocator::Kmalloc,
+    bindings,
+    device,
+    error::{
+        from_err_ptr,
+        from_result,
+        to_result, //
+    },
+    mm::virt::VmaNew,
+    pci,
+    prelude::*,
+    sync::aref::ARef,
+    types::NotThreadSafe,
+    uaccess::UserPtr, //
+};
+use core::{
+    alloc::Layout,
+    ptr::NonNull, //
+};
+
+/// Reset the PCI slot or bus containing a VFIO device.
+pub const DEVICE_PCI_HOT_RESET: u32 = bindings::VFIO_DEVICE_PCI_HOT_RESET;
+
+/// Index of the PCI configuration-space region.
+pub const CONFIG_REGION_INDEX: u32 = bindings::VFIO_PCI_CONFIG_REGION_INDEX;
+
+/// The trait for VFIO PCI variant driver implementations.
+///
+/// Unimplemented I/O callbacks leave their corresponding VFIO hooks unset. To get the
+/// behavior of the PCI core, implement the callback and call the corresponding core helper of
+/// [`Device`].
+///
+/// # Lifetime of the callback data
+///
+/// [`Registration`] owns the [`RegistrationData`](super::Operations::RegistrationData), which
+/// borrows from the PCI binding scope, and each callback borrows it. Callbacks are generic over
+/// the lifetime of the registration data, so they cannot store callback-local references in it.
+#[vtable]
+pub trait Operations: super::Operations {
+    /// The name of the VFIO driver.
+    const NAME: &'static CStr;
+
+    /// Called when the first file descriptor is opened for this device.
+    ///
+    /// `vfio_pci_core_enable()` has already succeeded; if this returns an
+    /// error, `vfio_pci_core_disable()` is called automatically. The returned
+    /// open data is dropped before PCI core close on the last close.
+    ///
+    /// Exported DMA buffers do not keep the open data alive; PCI core close
+    /// revokes them after the open data is dropped.
+    fn open_device<'a, 'reg: 'a>(
+        dev: &'a Device<Self, Open>,
+        reg_data: &'a Self::RegistrationData<'reg>,
+    ) -> impl PinInit<Self::OpenData<'a, 'reg>, Error> + 'a;
+
+    /// Handle a VFIO ioctl.
+    ///
+    /// The default `vfio_pci_core_ioctl()` is available via
+    /// [`Device::core_ioctl()`] for delegation.
+    ///
+    /// [`Device::core_ioctl()`]: Device#method.core_ioctl
+    #[optional]
+    fn ioctl<'reg>(
+        _dev: &Device<Self, Ioctl>,
+        _reg_data: &Self::RegistrationData<'reg>,
+        _open_data: Pin<&Self::OpenData<'_, 'reg>>,
+        _cmd: u32,
+        _arg: usize,
+    ) -> Result<isize>;
+
+    /// Read from the device.
+    ///
+    /// `buf` is a user-space buffer provided by the VFIO core. Use
+    /// [`Device::core_read()`] to delegate the default read, and
+    /// [`UserBuf::write_overlapping()`] to override specific bytes afterwards.
+    ///
+    /// [`Device::core_read()`]: Device#method.core_read
+    #[optional]
+    fn read<'reg>(
+        _dev: &Device<Self, Read>,
+        _reg_data: &Self::RegistrationData<'reg>,
+        _open_data: Pin<&Self::OpenData<'_, 'reg>>,
+        _buf: &mut UserBuf,
+        _ppos: &mut Position<'_>,
+    ) -> Result<isize>;
+
+    /// Write to the device, delegating to [`Device::core_write()`] if appropriate.
+    ///
+    /// [`Device::core_write()`]: Device#method.core_write
+    #[optional]
+    fn write<'reg>(
+        _dev: &Device<Self, Write>,
+        _reg_data: &Self::RegistrationData<'reg>,
+        _open_data: Pin<&Self::OpenData<'_, 'reg>>,
+        _buf: &mut UserBuf,
+        _ppos: &mut Position<'_>,
+    ) -> Result<isize>;
+
+    /// Map a device region, delegating to [`Device::core_mmap()`] if appropriate.
+    ///
+    /// [`Device::core_mmap()`]: Device#method.core_mmap
+    #[optional]
+    fn mmap<'reg>(
+        _dev: &Device<Self, Mmap>,
+        _reg_data: &Self::RegistrationData<'reg>,
+        _open_data: Pin<&Self::OpenData<'_, 'reg>>,
+        _mapping: &mut Mapping<'_>,
+    ) -> Result;
+
+    /// Prepare for PCI reset, including resets initiated during enable or close.
+    fn reset_prepare(_reg_data: &Self::RegistrationData<'_>) {}
+
+    /// Finish PCI reset.
+    fn reset_done(_reg_data: &Self::RegistrationData<'_>) -> Result {
+        Ok(())
+    }
+
+    /// Fill in region info capabilities.
+    ///
+    /// The default `vfio_pci_ioctl_get_region_info()` is available via
+    /// [`Device::core_get_region_info()`] for delegation.
+    ///
+    /// [`Device::core_get_region_info()`]: Device#method.core_get_region_info
+    #[optional]
+    fn get_region_info<'reg>(
+        _dev: &Device<Self, GetRegionInfo>,
+        _reg_data: &Self::RegistrationData<'reg>,
+        _open_data: Pin<&Self::OpenData<'_, 'reg>>,
+        _info: &mut bindings::vfio_region_info,
+        _caps: &mut InfoCap<'_>,
+    ) -> Result;
+
+    /// Returns a limit on the length of a region that may be exported as a DMA buffer.
+    ///
+    /// `None` selects the length of the PCI resource, which also caps a returned limit. A
+    /// device without this callback does not support DMA buffer export.
+    #[optional]
+    fn dmabuf_len<'reg>(
+        _reg_data: &Self::RegistrationData<'reg>,
+        _open_data: Pin<&Self::OpenData<'_, 'reg>>,
+        _region_index: u32,
+    ) -> Result<Option<u64>>;
+}
+
+/// A VFIO PCI file position, encoding a region index and an offset within that region.
+pub struct Position<'a> {
+    raw: &'a mut i64,
+}
+
+impl Position<'_> {
+    /// Commit a temporary position only after the operation succeeds.
+    ///
+    /// This preserves the original position if a read succeeds but a subsequent
+    /// user copy fails.
+    pub fn with_temporary<R>(
+        &mut self,
+        operation: impl FnOnce(&mut Position<'_>) -> Result<R>,
+    ) -> Result<R> {
+        let mut next = *self.raw;
+        let result = operation(&mut Position { raw: &mut next })?;
+        *self.raw = next;
+        Ok(result)
+    }
+
+    /// Returns the PCI region index.
+    pub fn region_index(&self) -> u32 {
+        ((*self.raw as u64) >> bindings::VFIO_PCI_OFFSET_SHIFT) as u32
+    }
+
+    /// Returns the byte offset within the current region.
+    pub fn region_offset(&self) -> u64 {
+        (*self.raw as u64) & ((1u64 << bindings::VFIO_PCI_OFFSET_SHIFT) - 1)
+    }
+}
+
+/// Mapping metadata supplied by VFIO while the current thread holds the mmap lock.
+///
+/// The underlying VMA can only be passed back to the core mmap operation.
+pub struct Mapping<'a> {
+    vma: &'a VmaNew,
+    _not_thread_safe: NotThreadSafe,
+}
+
+impl Mapping<'_> {
+    fn page_offset(&self) -> u64 {
+        self.vma.pgoff() as u64
+    }
+
+    /// Returns the PCI region index encoded in the mapping offset.
+    pub fn region_index(&self) -> u32 {
+        (self.page_offset() >> (bindings::VFIO_PCI_OFFSET_SHIFT as usize - crate::page::PAGE_SHIFT))
+            as u32
+    }
+
+    /// Returns the byte offset within the PCI region.
+    fn region_offset(&self) -> u64 {
+        let mask = ((1u64 << bindings::VFIO_PCI_OFFSET_SHIFT) - 1) >> crate::page::PAGE_SHIFT;
+        (self.page_offset() & mask) << crate::page::PAGE_SHIFT
+    }
+
+    /// Returns the exclusive end of the requested mapping within the PCI region.
+    pub fn region_end(&self) -> Result<u64> {
+        self.region_offset()
+            .checked_add(self.vma.size() as u64)
+            .ok_or(EOVERFLOW)
+    }
+}
+
+/// A VFIO PCI variant device, wrapping `struct vfio_pci_core_device`.
+///
+/// Callback contexts expose only their matching core helper and cannot be
+/// refcounted or shared across threads.
+///
+/// # Invariants
+///
+/// In addition to the invariants of `DeviceBase`:
+///
+/// - The wrapped `vfio_pci_core_device` was initialized by `vfio_pci_core_init_dev()`.
+/// - The callback data follows the VFIO registration and first-open/last-close lifetimes.
+///   Open data is destroyed before PCI core close, and registration data is
+///   released after PCI core unregistration has drained callbacks.
+pub type Device<T, Ctx = Normal> = DeviceBase<bindings::vfio_pci_core_device, T, Ctx>;
+
+static_assert!(core::mem::offset_of!(bindings::vfio_pci_core_device, vdev) == 0);
+
+impl<T: Operations> Device<T> {
+    /// Allocate a VFIO PCI device for subsequent registration.
+    pub fn new(pdev: &pci::Device<device::Core<'_>>) -> Result<ARef<Self>> {
+        let size = Kmalloc::aligned_layout(Layout::new::<Self>()).size();
+
+        // SAFETY: The bound PCI device and static ops are valid. The allocation
+        // includes the full Rust wrapper with kmalloc-compatible size and alignment.
+        let raw = from_err_ptr(unsafe {
+            bindings::_vfio_alloc_device(size, pdev.as_ref().as_raw(), &Self::OPS)
+        })?;
+        let this = NonNull::new(raw.cast::<Self>()).ok_or(ENOMEM)?;
+
+        // SAFETY: `vfio_pci_core_init_dev()` initialized the C device in this new allocation,
+        // which nothing else can access yet. `vfio_pci_core_device` begins with its
+        // `vfio_device`, as asserted above.
+        // INVARIANT: The layout and the initialized `raw` are as just described.
+        unsafe { Self::init(this.as_ptr()) };
+
+        // SAFETY: No registration or callbacks can observe this allocation yet.
+        unsafe { (*this.as_ref().as_raw()).pci_ops = &Self::PCI_OPS };
+
+        // SAFETY: `this` owns the initial VFIO device reference.
+        Ok(unsafe { ARef::from_raw(this) })
+    }
+}
+
+impl<T: Operations, Ctx: IoContext> Device<T, Ctx> {
+    /// Accesses the registration data and the open data from an I/O callback.
+    ///
+    /// The data lifetimes stay independent of the callback borrow, so that borrowed data
+    /// cannot be stored back into the registration data or the open data.
+    fn callback_data_with<V, F>(&self, f: F) -> V
+    where
+        F: for<'a, 'reg> FnOnce(&T::RegistrationData<'reg>, Pin<&T::OpenData<'a, 'reg>>) -> V,
+    {
+        // SAFETY: `f` is generic over the lifetimes of the data, so it uses the data
+        // parametrically.
+        let (reg_data, open_data) = unsafe { self.callback_data() };
+        f(reg_data, open_data)
+    }
+}
+
+impl<T: Operations> Device<T, Open> {
+    /// Set the device ID exposed through VFIO's virtual PCI configuration space.
+    pub fn set_device_id(&self, device_id: u16) {
+        // SAFETY: core_enable allocated vconfig; the exclusive first-open callback
+        // runs before finish_enable publishes the configuration to userspace.
+        unsafe {
+            (*self.as_raw())
+                .vconfig
+                .add(bindings::PCI_DEVICE_ID as usize)
+                .cast::<u16>()
+                .write_unaligned(device_id.to_le());
+        }
+    }
+}
+
+impl<T: Operations> Device<T, Ioctl> {
+    /// Delegate to `vfio_pci_core_ioctl()`.
+    pub fn core_ioctl(&self, cmd: u32, arg: usize) -> Result<isize> {
+        // SAFETY: The Ioctl context keeps this device open on the callback thread.
+        let ret = unsafe { bindings::vfio_pci_core_ioctl(self.as_raw_vfio(), cmd, arg) };
+        if ret < 0 {
+            Err(Error::from_errno(ret as i32))
+        } else {
+            Ok(ret)
+        }
+    }
+}
+
+impl<T: Operations> Device<T, Read> {
+    /// Delegate to `vfio_pci_core_read()`.
+    ///
+    /// The VFIO core fills the user-space buffer with the default PCI data
+    /// for the region identified by `ppos` and advances the position by the bytes read.
+    pub fn core_read(&self, buf: &UserBuf, ppos: &mut Position<'_>) -> Result<isize> {
+        // SAFETY: The Read context keeps this device open on the callback thread;
+        // `buf.ptr` is a user-space pointer supplied by VFIO.
+        let ret = unsafe {
+            bindings::vfio_pci_core_read(
+                self.as_raw_vfio(),
+                buf.ptr.as_mut_ptr().cast(),
+                buf.count,
+                ppos.raw,
+            )
+        };
+        if ret < 0 {
+            Err(Error::from_errno(ret as i32))
+        } else {
+            Ok(ret)
+        }
+    }
+}
+
+impl<T: Operations> Device<T, Write> {
+    /// Delegate to `vfio_pci_core_write()` for this callback's bounded buffer.
+    pub fn core_write(&self, buf: &UserBuf, ppos: &mut Position<'_>) -> Result<isize> {
+        // SAFETY: The Write context keeps the device open on the callback thread;
+        // the buffer is a userspace pointer supplied by VFIO.
+        let ret = unsafe {
+            bindings::vfio_pci_core_write(
+                self.as_raw_vfio(),
+                buf.ptr.as_const_ptr().cast(),
+                buf.count,
+                ppos.raw,
+            )
+        };
+        if ret < 0 {
+            Err(Error::from_errno(ret as i32))
+        } else {
+            Ok(ret)
+        }
+    }
+}
+
+impl<T: Operations> Device<T, Mmap> {
+    /// Delegate to `vfio_pci_core_mmap()` for the current callback's VMA.
+    pub fn core_mmap(&self, mapping: &mut Mapping<'_>) -> Result {
+        // SAFETY: The Mmap context and Mapping keep the open device and locked VMA
+        // on the callback thread. The VMA cannot be replaced by driver code.
+        to_result(unsafe { bindings::vfio_pci_core_mmap(self.as_raw_vfio(), mapping.vma.as_ptr()) })
+    }
+}
+
+impl<T: Operations> Device<T, GetRegionInfo> {
+    /// Delegate to `vfio_pci_ioctl_get_region_info()`.
+    pub fn core_get_region_info(
+        &self,
+        info: &mut bindings::vfio_region_info,
+        caps: &mut InfoCap<'_>,
+    ) -> Result {
+        // SAFETY: GetRegionInfo keeps the device open on the callback thread;
+        // `InfoCap` preserves the validity of VFIO's capability buffer.
+        to_result(unsafe {
+            bindings::vfio_pci_ioctl_get_region_info(self.as_raw_vfio(), info, caps.raw)
+        })
+    }
+}
+
+/// # Safety
+///
+/// `vdev` must belong to a registered `Device<T>` in VFIO's first-open context.
+/// VFIO must exclude other opens, closes and I/O callbacks for this call.
+unsafe extern "C" fn open_device_cb<T: Operations>(vdev: *mut bindings::vfio_device) -> c_int {
+    from_result(|| {
+        // SAFETY: `vdev` belongs to a live `Device<T>`; VFIO provides the first-open context.
+        let dev = unsafe { Device::<T, Open>::from_raw_vfio(vdev) };
+
+        // SAFETY: Enable the PCI-core side first.
+        to_result(unsafe { bindings::vfio_pci_core_enable(dev.as_raw()) })?;
+
+        // SAFETY: The previous last close destroyed any earlier open data. `T::open_device()`
+        // is generic over the lifetimes of its arguments, and the closure captures nothing but
+        // `dev`, which it passes on with the same lifetime as the registration data.
+        // `close_device_cb()` destroys the open data at the last close.
+        unsafe { dev.open(|reg_data| T::open_device(dev, reg_data)) }.inspect_err(|_| {
+            // SAFETY: Undo the enable on failure.
+            unsafe { bindings::vfio_pci_core_disable(dev.as_raw()) };
+        })?;
+
+        // SAFETY: open succeeded.
+        unsafe { bindings::vfio_pci_core_finish_enable(dev.as_raw()) };
+        Ok(0)
+    })
+}
+
+/// # Safety
+///
+/// `vdev` must belong to a registered `Device<T>` whose first open succeeded.
+/// Call exactly once for the last close, after draining I/O callbacks and while
+/// excluding the next first open.
+unsafe extern "C" fn close_device_cb<T: Operations>(vdev: *mut bindings::vfio_device) {
+    // SAFETY: `vdev` belongs to a live `Device<T>`.
+    let dev = unsafe { Device::<T>::from_raw_vfio(vdev) };
+    // SAFETY: Last close drains I/O callbacks and excludes the next first open.
+    // Registration data and PCI resources remain valid while open data is destroyed.
+    unsafe { dev.close() };
+    // SAFETY: Matches the enable in open_device_cb.
+    unsafe { bindings::vfio_pci_core_close_device(vdev) };
+}
+
+/// # Safety
+///
+/// `vdev` must belong to a registered, open `Device<T>` in VFIO's ioctl callback
+/// context. Registration and open data must remain alive until the call returns.
+unsafe extern "C" fn ioctl_cb<T: Operations>(
+    vdev: *mut bindings::vfio_device,
+    cmd: core::ffi::c_uint,
+    arg: usize,
+) -> isize {
+    // SAFETY: `vdev` belongs to a live `Device<T>`; VFIO provides the ioctl context.
+    let dev = unsafe { Device::<T, Ioctl>::from_raw_vfio(vdev) };
+    from_result(|| dev.callback_data_with(|rd, od| T::ioctl(dev, rd, od, cmd, arg)))
+}
+
+/// # Safety
+///
+/// `vdev` must belong to a registered, open `Device<T>` in VFIO's read context.
+/// `buf` must be a userspace address and `ppos` must be exclusively accessible
+/// for this call. Registration and open data must remain alive until it returns.
+unsafe extern "C" fn read_cb<T: Operations>(
+    vdev: *mut bindings::vfio_device,
+    buf: *mut u8,
+    count: usize,
+    ppos: *mut i64,
+) -> isize {
+    // SAFETY: `vdev` belongs to a live `Device<T>`; VFIO provides the read context.
+    let dev = unsafe { Device::<T, Read>::from_raw_vfio(vdev) };
+    let mut ubuf = UserBuf {
+        ptr: UserPtr::from_ptr(buf.cast()),
+        count,
+    };
+    let mut pos = Position {
+        // SAFETY: `ppos` is a valid kernel pointer provided by the VFIO core.
+        raw: unsafe { &mut *ppos },
+    };
+    from_result(|| dev.callback_data_with(|rd, od| T::read(dev, rd, od, &mut ubuf, &mut pos)))
+}
+
+/// # Safety
+///
+/// `vdev` must belong to a registered, open `Device<T>` in VFIO's region-info
+/// context. `info` and `caps` must be valid, disjoint, exclusively accessible
+/// objects; the capability buffer must satisfy the VFIO core's invariants.
+/// Registration and open data must remain alive until the call returns.
+unsafe extern "C" fn get_region_info_cb<T: Operations>(
+    vdev: *mut bindings::vfio_device,
+    info: *mut bindings::vfio_region_info,
+    caps: *mut bindings::vfio_info_cap,
+) -> c_int {
+    // SAFETY: `vdev` belongs to a live `Device<T>`; VFIO provides the region-info context.
+    let dev = unsafe { Device::<T, GetRegionInfo>::from_raw_vfio(vdev) };
+    // SAFETY: `info` is a valid pointer provided by the VFIO core.
+    let info = unsafe { &mut *info };
+    let mut caps = InfoCap {
+        // SAFETY: `caps` is a valid pointer provided by the VFIO core.
+        raw: unsafe { &mut *caps },
+    };
+    from_result(|| {
+        dev.callback_data_with(|rd, od| T::get_region_info(dev, rd, od, info, &mut caps))
+            .map(|()| 0)
+    })
+}
+
+/// # Safety
+///
+/// `vdev` must belong to a registered, open `Device<T>` in VFIO's write context.
+/// `buf` must be a userspace address and `ppos` must be exclusively accessible
+/// for this call. Registration and open data must remain alive until it returns.
+unsafe extern "C" fn write_cb<T: Operations>(
+    vdev: *mut bindings::vfio_device,
+    buf: *const u8,
+    count: usize,
+    ppos: *mut i64,
+) -> isize {
+    // SAFETY: `vdev` belongs to a live `Device<T>`; VFIO provides the write context.
+    let dev = unsafe { Device::<T, Write>::from_raw_vfio(vdev) };
+    let mut ubuf = UserBuf {
+        ptr: UserPtr::from_ptr(buf.cast_mut().cast()),
+        count,
+    };
+    let mut pos = Position {
+        // SAFETY: VFIO holds the file-position lock when required.
+        raw: unsafe { &mut *ppos },
+    };
+    from_result(|| dev.callback_data_with(|rd, od| T::write(dev, rd, od, &mut ubuf, &mut pos)))
+}
+
+/// # Safety
+///
+/// `vdev` must belong to a registered, open `Device<T>` in VFIO's mmap context.
+/// `vma` must be the valid VMA being mapped, with the mmap write lock held on
+/// this thread. Registration and open data must remain alive until return.
+unsafe extern "C" fn mmap_cb<T: Operations>(
+    vdev: *mut bindings::vfio_device,
+    vma: *mut bindings::vm_area_struct,
+) -> c_int {
+    // SAFETY: `vdev` belongs to a live `Device<T>`; VFIO provides the mmap context.
+    let dev = unsafe { Device::<T, Mmap>::from_raw_vfio(vdev) };
+    let mut mapping = Mapping {
+        // SAFETY: VFIO calls this from its `f_ops->mmap()` hook, where the VMA is being set up.
+        vma: unsafe { VmaNew::from_raw(vma) },
+        _not_thread_safe: NotThreadSafe,
+    };
+    from_result(|| {
+        dev.callback_data_with(|rd, od| T::mmap(dev, rd, od, &mut mapping))
+            .map(|()| 0)
+    })
+}
+
+/// # Safety
+///
+/// `vdev` must belong to a registered, open `Device<T>` in VFIO's ioctl context, and the other
+/// pointers must be those `vfio_pci_core_feature_dma_buf()` passes to this callback.
+/// Registration and open data must remain alive until return.
+#[cfg(CONFIG_VFIO_PCI_DMABUF)]
+unsafe extern "C" fn get_dmabuf_phys_cb<T: Operations>(
+    vdev: *mut bindings::vfio_pci_core_device,
+    provider: *mut *mut bindings::p2pdma_provider,
+    region_index: c_uint,
+    phys_vec: *mut bindings::phys_vec,
+    dma_ranges: *mut bindings::vfio_region_dma_range,
+    nr_ranges: usize,
+) -> c_int {
+    // SAFETY: `vdev` begins with the `vfio_device` of a live `Device<T>`; the device feature
+    // ioctl provides the ioctl context.
+    let dev = unsafe { Device::<T, Ioctl>::from_raw_vfio(vdev.cast()) };
+    from_result(|| {
+        let len = dev.callback_data_with(|rd, od| T::dmabuf_len(rd, od, region_index))?;
+        let Some(len) = len else {
+            // SAFETY: The arguments are passed on unchanged from the PCI core.
+            let ret = unsafe {
+                bindings::vfio_pci_core_get_dmabuf_phys(
+                    vdev,
+                    provider,
+                    region_index,
+                    phys_vec,
+                    dma_ranges,
+                    nr_ranges,
+                )
+            };
+            return to_result(ret).map(|()| 0);
+        };
+        // SAFETY: `vdev` is a live `vfio_pci_core_device`.
+        let pdev = unsafe { (*vdev).pdev };
+        // SAFETY: `pdev` is the device bound to this driver, and the PCI core validated
+        // `region_index` as one of its BARs.
+        let p2pdma = unsafe { bindings::pcim_p2pdma_provider(pdev, region_index as c_int) };
+        if p2pdma.is_null() {
+            return Err(EINVAL);
+        }
+        // SAFETY: `provider` is the valid output pointer of the PCI core.
+        unsafe { provider.write(p2pdma) };
+        // SAFETY: By the same reasoning above, `pdev` and its BAR `region_index` are valid.
+        let start = unsafe { bindings::pci_resource_start(pdev, region_index as c_int) };
+        // SAFETY: By the same reasoning above, `pdev` and its BAR `region_index` are valid.
+        let bar_len = unsafe { bindings::pci_resource_len(pdev, region_index as c_int) };
+        let len = len.min(bar_len);
+        // SAFETY: `phys_vec` and `dma_ranges` hold `nr_ranges` entries, as passed by the PCI
+        // core, and `len` is within the BAR.
+        let ret = unsafe {
+            bindings::vfio_pci_core_fill_phys_vec(phys_vec, dma_ranges, nr_ranges, start, len)
+        };
+        to_result(ret).map(|()| 0)
+    })
+}
+
+/// Build the `vfio_device_ops` vtable for a variant driver `T`.
+///
+/// The open callback and the implemented I/O callbacks dispatch to `T`; unimplemented I/O
+/// callbacks are not installed. Other installed callbacks use VFIO core functions or wrappers.
+macro_rules! build_ops {
+    ($T:ty) => {
+        bindings::vfio_device_ops {
+            #[allow(clippy::disallowed_methods)]
+            name: <$T>::NAME.as_ptr().cast_mut().cast(),
+            init: Some(bindings::vfio_pci_core_init_dev),
+            release: Some(bindings::vfio_pci_core_release_dev),
+            open_device: Some(open_device_cb::<$T>),
+            close_device: Some(close_device_cb::<$T>),
+            ioctl: if <$T>::HAS_IOCTL {
+                Some(ioctl_cb::<$T>)
+            } else {
+                None
+            },
+            read: if <$T>::HAS_READ {
+                Some(read_cb::<$T>)
+            } else {
+                None
+            },
+            write: if <$T>::HAS_WRITE {
+                Some(write_cb::<$T>)
+            } else {
+                None
+            },
+            mmap: if <$T>::HAS_MMAP {
+                Some(mmap_cb::<$T>)
+            } else {
+                None
+            },
+            request: Some(bindings::vfio_pci_core_request),
+            get_region_info_caps: if <$T>::HAS_GET_REGION_INFO {
+                Some(get_region_info_cb::<$T>)
+            } else {
+                None
+            },
+            match_: Some(bindings::vfio_pci_core_match),
+            match_token_uuid: Some(bindings::vfio_pci_core_match_token_uuid),
+            device_feature: Some(bindings::vfio_pci_core_ioctl_feature),
+            #[cfg(CONFIG_IOMMUFD)]
+            bind_iommufd: Some(bindings::vfio_iommufd_physical_bind),
+            #[cfg(not(CONFIG_IOMMUFD))]
+            bind_iommufd: None,
+            #[cfg(CONFIG_IOMMUFD)]
+            unbind_iommufd: Some(bindings::vfio_iommufd_physical_unbind),
+            #[cfg(not(CONFIG_IOMMUFD))]
+            unbind_iommufd: None,
+            #[cfg(CONFIG_IOMMUFD)]
+            attach_ioas: Some(bindings::vfio_iommufd_physical_attach_ioas),
+            #[cfg(not(CONFIG_IOMMUFD))]
+            attach_ioas: None,
+            #[cfg(CONFIG_IOMMUFD)]
+            detach_ioas: Some(bindings::vfio_iommufd_physical_detach_ioas),
+            #[cfg(not(CONFIG_IOMMUFD))]
+            detach_ioas: None,
+            #[cfg(CONFIG_IOMMUFD)]
+            pasid_attach_ioas: Some(bindings::vfio_iommufd_physical_pasid_attach_ioas),
+            #[cfg(not(CONFIG_IOMMUFD))]
+            pasid_attach_ioas: None,
+            #[cfg(CONFIG_IOMMUFD)]
+            pasid_detach_ioas: Some(bindings::vfio_iommufd_physical_pasid_detach_ioas),
+            #[cfg(not(CONFIG_IOMMUFD))]
+            pasid_detach_ioas: None,
+            dma_unmap: None,
+        }
+    };
+}
+
+/// The registration of a VFIO PCI variant device.
+///
+/// Owns both the VFIO device reference and the registration data, tying
+/// resource lifetimes to the PCI binding scope `'a`. The device is registered
+/// on construction and unregistered when the `Registration` is dropped.
+pub struct Registration<'a, T: Operations> {
+    dev: ARef<Device<T>>,
+    reg_data: Pin<KBox<T::RegistrationData<'a>>>,
+}
+
+impl<T: Operations> Device<T> {
+    const OPS: bindings::vfio_device_ops = build_ops!(T);
+
+    const PCI_OPS: bindings::vfio_pci_device_ops = bindings::vfio_pci_device_ops {
+        #[cfg(CONFIG_VFIO_PCI_DMABUF)]
+        get_dmabuf_phys: if T::HAS_DMABUF_LEN {
+            Some(get_dmabuf_phys_cb::<T>)
+        } else {
+            None
+        },
+        #[cfg(not(CONFIG_VFIO_PCI_DMABUF))]
+        get_dmabuf_phys: None,
+    };
+}
+
+impl<'a, T: Operations> Registration<'a, T> {
+    /// Register a previously allocated VFIO PCI device with its callback data.
+    ///
+    /// `dev` must have been allocated for `pdev`, and can be registered only once. `D` is the
+    /// PCI driver bound to `pdev`.
+    ///
+    /// # Safety
+    ///
+    /// The returned `Registration` must be stored in the bus device private data of `D`, the
+    /// driver bound to `pdev`, and must not be leaked: it has to be dropped while that driver
+    /// is being unbound from `pdev`, or when its probe fails.
+    pub unsafe fn new<D: pci::Driver>(
+        pdev: &'a pci::Device<device::Core<'_>>,
+        dev: &Device<T>,
+        reg_data: impl PinInit<T::RegistrationData<'a>, Error>,
+    ) -> Result<Self> {
+        const_assert!(
+            D::DRIVER_MANAGED_DMA.is_some(),
+            "VFIO drivers must manage DMA ownership"
+        );
+        const_assert!(
+            !D::HAS_SRIOV_ENABLE && !D::HAS_SRIOV_DISABLE,
+            "VFIO PCI variant drivers do not support SR-IOV configuration"
+        );
+
+        // SAFETY: `dev` holds a live VFIO allocation; only compare its parent pointer.
+        if unsafe { (*dev.as_raw_vfio()).dev } != pdev.as_ref().as_raw() {
+            return Err(EINVAL);
+        }
+
+        let reg_data: Pin<KBox<T::RegistrationData<'a>>> = KBox::pin_init(reg_data, GFP_KERNEL)?;
+        let ptr = NonNull::from(Pin::get_ref(reg_data.as_ref()));
+
+        // SAFETY: `dev` belongs to `pdev`, whose device lock serializes publication. The
+        // returned `Registration` keeps the pinned data alive until it has unregistered `dev`;
+        // if registration fails below, `dev` remains unregistered and never accesses the data.
+        unsafe { dev.publish_registration_data(ptr) }?;
+
+        // Registering `dev` allows runtime suspend of `pdev`. The VFIO PCI core expects the PCI
+        // driver's runtime PM callbacks to call into it, which these abstractions do not provide
+        // yet, so keep `pdev` runtime active while `dev` is registered.
+        // TODO: Replace this with the runtime PM handling of the PCI bus once it is available.
+        //
+        // SAFETY: `pdev` is a valid device. This is `pm_runtime_get_sync()`, which takes a usage
+        // reference even if it fails.
+        #[cfg(CONFIG_PM)]
+        let ret = unsafe {
+            bindings::__pm_runtime_resume(pdev.as_ref().as_raw(), bindings::RPM_GET_PUT as c_int)
+        };
+        #[cfg(not(CONFIG_PM))]
+        let ret = 0;
+
+        to_result(ret)
+            .and_then(|()| {
+                // SAFETY: `dev` is initialized, has published its registration data and has not
+                // been registered before. The caller holds the PCI device lock of its parent.
+                to_result(unsafe { bindings::vfio_pci_core_register_device(dev.as_raw()) })
+            })
+            .inspect_err(|_| {
+                // SAFETY: `pdev` is a valid device, and the usage reference taken above is
+                // dropped here. This is `pm_runtime_put()`.
+                #[cfg(CONFIG_PM)]
+                unsafe {
+                    bindings::__pm_runtime_idle(
+                        pdev.as_ref().as_raw(),
+                        (bindings::RPM_GET_PUT | bindings::RPM_ASYNC) as c_int,
+                    )
+                };
+            })?;
+
+        Ok(Self {
+            dev: dev.into(),
+            reg_data,
+        })
+    }
+
+    /// Prepare the variant driver's state for a PCI reset.
+    pub fn reset_prepare(&self) {
+        T::reset_prepare(&self.reg_data);
+    }
+
+    /// Complete the variant driver's state update after a PCI reset.
+    pub fn reset_done(&self) -> Result {
+        T::reset_done(&self.reg_data)
+    }
+
+    /// Signal the VFIO error interrupt and return the PCI recovery result.
+    pub fn error_detected(&self) -> pci::ErsResult {
+        // SAFETY: This owner keeps the initialized VFIO core device alive.
+        let result = unsafe { bindings::vfio_pci_core_aer_err_detected(self.dev.as_raw()) };
+        // The VFIO PCI core only returns results `pci::ErsResult` represents.
+        pci::ErsResult::from_raw(result).unwrap_or(pci::ErsResult::None)
+    }
+}
+
+impl<T: Operations> Drop for Registration<'_, T> {
+    fn drop(&mut self) {
+        // SAFETY: `new()` registered the device. By its safety requirements, this runs with the
+        // PCI device lock held, either from the PCI remove callback or while probe fails.
+        // Unregistration drains the VFIO callbacks, the only users of the registration data
+        // besides this owner, before the data is released.
+        unsafe { bindings::vfio_pci_core_unregister_device(self.dev.as_raw()) };
+
+        // SAFETY: `new()` took the usage reference dropped here on the parent device of `dev`.
+        // By the safety requirements of `new()`, that device is still bound, so the pointer is
+        // valid. This is `pm_runtime_put()`.
+        #[cfg(CONFIG_PM)]
+        unsafe {
+            bindings::__pm_runtime_idle(
+                (*self.dev.as_raw_vfio()).dev,
+                (bindings::RPM_GET_PUT | bindings::RPM_ASYNC) as c_int,
+            )
+        };
+    }
+}
-- 
2.43.7


