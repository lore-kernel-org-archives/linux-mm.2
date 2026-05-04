Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE2C2FF885A
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 06:54:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEEA66B0088; Mon,  4 May 2026 02:54:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9FA56B008A; Mon,  4 May 2026 02:54:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D677B6B008C; Mon,  4 May 2026 02:54:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C3D676B0088
	for <linux-mm@kvack.org>; Mon,  4 May 2026 02:54:21 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6A19A120914
	for <linux-mm@kvack.org>; Mon,  4 May 2026 06:54:21 +0000 (UTC)
X-FDA: 84728823522.07.0645C16
Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011049.outbound.protection.outlook.com [52.101.65.49])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2E37240002
	for <linux-mm@kvack.org>; Mon,  4 May 2026 06:54:16 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=Kbe0U31N;
	dkim=pass header.d=arm.com header.s=selector1 header.b=Kbe0U31N;
	spf=pass (imf12.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.65.49 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777877657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eIQV7Dqx2LpFIQjg7tN8rKkQshwBQLWrtmZq5HnMQ1I=;
	b=Zr/r4NChPSqRXftU7yIOCIpbiVKTkKvjLgm9V1mtxxkx1ngfNPmkxLI9XzcX5Tc3Y6M0If
	+8DrN7yyIHg6g6szZI9CaAOCitt9RpAscaxgeP8+YwE8Fx4djj6nNU2lvl0najbNYVGsqj
	JmDJ38TeKNJtm0q8AUBoMeGkB7O2V98=
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1777877657; a=rsa-sha256;
	cv=pass;
	b=4PIt7X/IakSbF2zrUPe8Pc6053TfTQKjQ5hIRK5cUlb1TqnYO2TdkiENW09q3XV6f5I8C5
	rTeyRzd+hG3P9PSYxnkrhrvC8opHvc34uzJ68WNiT08/rbJH4Cf2I+rHabP/6Z3VlenywU
	Oe0drFQxa5vZ9azZeKp+vZJkCMD8JFU=
ARC-Authentication-Results: i=3;
	imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=Kbe0U31N;
	dkim=pass header.d=arm.com header.s=selector1 header.b=Kbe0U31N;
	spf=pass (imf12.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.65.49 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=HqET9UulZMIx1555mwLqb6Z20USE4lOGUwHREIUAa7h7KaLhUIXSn/7pzT9zHA+vYwMSbfXhQiNqJpqC2HRXA3FBZgN3Xcc4laqLAL9p9dXxKe45J76jJkzLvRI8LWirbAhMcvRvusB7JLGKRq+RbNtuMIPHf3JVwAqrQBuk7EdM0pgyxBIVZtnZclGc7faT4lNx83uf+blQdO0fDnBJKQUcSJ19Q28DKYveP8aIc1XANb61qh/Ce6yNNB2Xth4V6RJedbAu8yxdm2RElC9q8J7nexZUxGtt0nleYkUf6/L69bL9WR4df0xBD1la0kYflkKxTXjQGviuKsw8F12YNQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eIQV7Dqx2LpFIQjg7tN8rKkQshwBQLWrtmZq5HnMQ1I=;
 b=mtdqRAoLUURCQHIkFxKS+oyog0oE9uvrUIFdGqLkM+yJPB8Iw9TFvjiTW26okcIZkLtmoNDZT0nzRsf7QICK4AWcoEAmHXy7lwXa7InaE7VVYL0/hrarYoFUGhbdWFFic9xK23gnawTm2sAZImNsjfVkd7cQQeyEjjBjcRlBEPq0wI1hEbU71Maa5UggXMpHUQzBTJr3Cftb2aGmnqKxWrKqH0I2mueR+vMHGV39eIClGmoRbxaGLEcEvLL56oQ+sEmgbMlv5Ge6pczOTHh9fT93OtHEq+I2AxdMShet58mOAfkJZYuzPMcQCe2PBkiiroEmRcv39Iqs6A8AaBafBA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eIQV7Dqx2LpFIQjg7tN8rKkQshwBQLWrtmZq5HnMQ1I=;
 b=Kbe0U31NhHGFQpMDcm04e8OM6U0CC3jMnGRCkRgQExyuSugNFAE1x7RPT91dQu1qmsevmxfSGU2U2b0KzKAD9s03Bv4GdKNUfdOX4TjjiftWwc12IbEXCEEgKqSNrhMrARv1X1xLAbWvzW1ffVg4fTM0Gr55bS9ROzxI9iXV7Kk=
Received: from DUZPR01CA0074.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:3c2::20) by GVXPR08MB11744.eurprd08.prod.outlook.com
 (2603:10a6:150:316::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.25; Mon, 4 May
 2026 06:54:11 +0000
Received: from DU6PEPF00009526.eurprd02.prod.outlook.com
 (2603:10a6:10:3c2:cafe::4c) by DUZPR01CA0074.outlook.office365.com
 (2603:10a6:10:3c2::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9870.25 via Frontend Transport; Mon,
 4 May 2026 06:54:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF00009526.mail.protection.outlook.com (10.167.8.7) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9891.9 via
 Frontend Transport; Mon, 4 May 2026 06:54:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QhzQPE0cEhHNEXS/CAPtOYe/prnpeebkArpkEbHjhmdHbsnCZj26WH7moZ3HOvqkK3ll+3d6DTuvZ9zLvLxYMLBtTKkeIWrgEjDzFl0ZnQbVprXgyZ7NL3bkXQhW5llg9hOcyHY9h7A4Yb8OflEhNaLYRpDnPM8/kBn+SB1qAj+oj5ibv3iITuJMrm3Y8iswOu7zWJcSmC6moIcUSGSUt/nojBQVXYYK/uNGwO2LKtKF3ItHdR9LUF34pY30UT69DapYz4B2pSOzsiZ2fpLGa6s53UgG5U/hA+D4gJArPgqOaGvu+avDrQ6kCYtXxXOH/YJw9G/dsuwWkPVfzhtTSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eIQV7Dqx2LpFIQjg7tN8rKkQshwBQLWrtmZq5HnMQ1I=;
 b=MauBC0u1asfy6xl6PB/01jjcl/tgMGF+J0vG0GxjI6ycRA7MkwP4Qfhv6+WqisoLFEZsYMZCN0KedMTguN6R/7zEh/OY0hyJ9L+e2AM81Q1iUBzkI5V86HymZJO7g05+kVtlKAIEOIAscuKaKiecb3yAkPe9Gl5/4nclbVi9fk509ofJsqdo1tfiiLJCiV4RIs9ktlUMHP4xgg+XRR4bRve08Z7sFsaMAwdHXdVSSBcgussAUUv3gyb5zsfd1KcGgdoICqtDBSE2PblGyHWuqOETxjFWpr+VSGLWGYkj5SaKF0WJCbXto0EAA/TuAyZRW5BGbHvzSn2pl25n8kI2bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eIQV7Dqx2LpFIQjg7tN8rKkQshwBQLWrtmZq5HnMQ1I=;
 b=Kbe0U31NhHGFQpMDcm04e8OM6U0CC3jMnGRCkRgQExyuSugNFAE1x7RPT91dQu1qmsevmxfSGU2U2b0KzKAD9s03Bv4GdKNUfdOX4TjjiftWwc12IbEXCEEgKqSNrhMrARv1X1xLAbWvzW1ffVg4fTM0Gr55bS9ROzxI9iXV7Kk=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com (2603:10a6:10:417::12)
 by GV1PR08MB10454.eurprd08.prod.outlook.com (2603:10a6:150:15d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.25; Mon, 4 May
 2026 06:53:04 +0000
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047]) by DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047%2]) with mapi id 15.20.9870.023; Mon, 4 May 2026
 06:53:03 +0000
Message-ID: <179291e2-deb3-42c4-afb6-71e5570264ba@arm.com>
Date: Mon, 4 May 2026 12:22:55 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 31/54] selftests/mm: cow: add setup of HugeTLB pages
To: Mike Rapoport <rppt@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
 Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
 Donet Tom <donettom@linux.ibm.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lance Yang <lance.yang@linux.dev>,
 Leon Romanovsky <leon@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Luiz Capitulino <luizcap@redhat.com>, Mark Brown <broonie@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Nico Pache <npache@redhat.com>,
 Peter Xu <peterx@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Shuah Khan <shuah@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org
References: <20260428204240.1924129-1-rppt@kernel.org>
 <20260428204240.1924129-32-rppt@kernel.org>
From: Sarthak Sharma <sarthak.sharma@arm.com>
Content-Language: en-US
In-Reply-To: <20260428204240.1924129-32-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5P287CA0076.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:1d8::10) To DU0PR08MB9203.eurprd08.prod.outlook.com
 (2603:10a6:10:417::12)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU0PR08MB9203:EE_|GV1PR08MB10454:EE_|DU6PEPF00009526:EE_|GVXPR08MB11744:EE_
X-MS-Office365-Filtering-Correlation-Id: c8381952-f05c-4428-26ea-08dea9a9f254
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|7416014|1800799024|366016|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info-Original:
 S5ywjUg42ezurn4Xs918dE87kjuXfJ7kc7GKalxxbgOTe7m6Ukofpn704ZEPUo4WHOaDejUHBDFyEk0O9VPAN5eBWE00scyAcREsGXocM3OwF36nuhPHjBrAVDHktG43w5Myg058JqwNVU75MKqWdkls151Ro7sbsoqirKT1c9xRPXS7RLpX+ag5UPQHcZahU7EVbGjBPZyzUTPa8vmfgmmHjDzn2RZR+IGAjn5/qMV+7qaOcctyTLwe33obG5DyqLQTWP+a/vwKABG4OAp1GEjQ6XK+58LnR2lZQcHFAnRCXPdPMwg206Bcczuj0YPLODgz+jQLQn5nm0SvNQw4nDgzANC/m8mtec6321ckpPV3c7urGg6SgPyA2Eo1ZuNAKHolNuST85zhe3qMprzlnsXO8licHyUN7ziV/jr0T3ea0guyMoxe4HmV7rmjlu2CnqjNQKPZIdpiIGsJAoqP3cN1nxh65L+CDOl/cYYna+7Ds/2p9wG3HyO8aKj5RTaRTTifQn7230m7XMNkB1VNNNxJa+8gC+dKtHGZAL0obCY6k1pppN9d10UaB4rhn2qh8gUw+tRNSSJoS9ZAxPAJNNOjdz+if3QPYXKMntTaqzQxofbv/4kEIMYZeCB6swsxVcEuNL4kO6h6z1foCfmHMTBFpZ7FU8eNKU6xIzp3LOHwA889X4kKBXUJ6w6VErTN
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9203.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 TdX0x7o/lih041wavoLSnq39+DYMaiPoB5XKRe3DU7le9SRG3tTrEeV+1omgeL2rRC79YohK7x0A4WCbCSf4/LMo2216Q+5Zqzhuvpv1vY6xO7uithXZabTiu9iqfJhPM5osLhn7CK52oPNtRWBQ5fr0DMRx7PqhRe7NVTTqBxpEU5cNwIkHg6yF2rNo/eos5EQClD9rVbUohe1mdVDy0mfPAyWl3iAtEjskOZW8bGQEdIgcmewKpXTx6jZ+/nvR/7RYc4VUQIEsjzuorcJTLXHPtnGosBxATqnLlSQA+naewL8nnFLcLzrkwE7X2440VRRpeco5T1Os2ia2aMbSaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB10454
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF00009526.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	1ce0c3b1-6071-4ae0-23c8-08dea9a9c9c5
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|14060799003|35042699022|82310400026|36860700016|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	MctoTK+SVTyU5zZbaAbtKux+XVgb0d1dCvi9GIK0we2QZrYI4wryHx7Gh75VFzf583a6/MG9LU3G8VdZVX86rDQkCY3nVQFxyVCzIhXIW2JGkgB3CYJN7u2Hr+o5qXFYQ/8xw81OgQDm+WZHKcKdjp+BM+Gj+vnzHMipTZOzbZu9wm0a8jjO3N3IwfaEQayZeNCaI8MrVtPxElp7HR0sN9QBVqZf+xaL+DvXnzElT2pbK38vtv5hePdRj43t93OJRcH9Bis64vIpkE91u0nayi6ZK5y1AppVcG9JUH0CQ0Gxivp972rQYn4fVQxrvdGLZ0z/pz4sKsJRoiqmN9bpV94ooiYmDOJnB6PZ8RtWZX+LyM3Ip73Iq0SVE38YhZLW3CPxS65eSpO8t5t0hX2V+5O78fmKXlruO2E7H+/OhjC/25nvk00r2T4uwaxVXmkoF7wt9CV2eMZ+ipxdAM0yPL6b1vlIp3IZnZpGWirq2LDY2SDzo5QP3CCwtBRZ12yIzl3w6+KZVqn6TlCscBMtHuh7tg4nfW9C0wzulRfCBytM5bHhoG5nSvB/FcXFUiJbeX5uvfljpCPcB+iSbx18rCOneKOe8er05ZN15ROTEHpRKLn9Yo+RSnX0ADAdguXr4Yroqi3qOKTOJwko7SVLskexrjxagjZF0pfRqiU8bfifPQ+G6vIAED+U5ZkjZVf18mf8jFSaOtusIWWAseKoMTXskQnGAAw/vnR7s1QdVP8=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(14060799003)(35042699022)(82310400026)(36860700016)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	59v+pyvLTNFmTWFFwWPEq42KIMiRT4+Vmf/EIbfD7HRpuiF+3zF6EXXWk25HTtQyHtlfn6HCV7ShW7N/ox2n/WeOVGFdXUb0I6RAL3/NToGMl8KAAdy0A1ZUoIV7oD2/mC/6oHRCxxCsFroowbIJ8JSAZ/N12ixa3AtVfX4DtwEbIMho260rTFKD1Qig9xtpxJfh0yinDTy+Ya7TqG4bYjUrlXlOE9VrwL418sFiNID+1BXx4VATqSwnh0BQswZOXQ8jdzlQ1beC7uwu0Mr3YXN/POTEZJbzsHmLoH8/rt3fu6QKq0t8WLM+Hz5I0PdvdZ/3g/tz59FP8R1EdjmIxdrgVdWjr3vjJmA+pY/VpfZzXNX6EhpUcmCaYtaeqVzm+rjxe0ztvmD94nh1y+zpRpWVlXGRtQC3UmV6akuP7Ipq7nm45kjd7SSPp8tQizTT
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2026 06:54:11.2370
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c8381952-f05c-4428-26ea-08dea9a9f254
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF00009526.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB11744
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2E37240002
X-Stat-Signature: ghqj1eqnk75yzawb7q7ar7mwsgd4x4mz
X-Rspam-User: 
X-HE-Tag: 1777877656-54562
X-HE-Meta: U2FsdGVkX19YZOmWysxt6YcuunRbkE0FOYytFeeWlmKvpdb04EViy5TQqhACDQPwX7+y1pYgvMt9dgz4LSUNYuVXBhRP8VK8ZXJWrG+iicKkEzCQMps8wzQ5wRrdOSSUgh4Eq31J9BYIUoe3ZA4FJpCRIyRwF5LUN/ssDZIFf04KfRDtR0U5iZIlxLZa4ALLVYxlBq48mQOPNiI/CDGtBsyzs0pKpXT7Pg3l9vHGwHHnUhxbe04xd3MV8YWmOuNsNCTMAVf1wdl/xK4HTNM6JFqHTAziQ1JcLelhLpqNFYgsMFpbJRo16iNuSche2kP+x/cUj09Ndaw9tT3yc3d6DaaENzGPLQzUqxRvCHrhy4DXzhXYd3vHN2rw2oSVUEoApAWHggDbQ46V1QPLiqZLo40DW/DRJFLzReUCu1v4+2ySCSWRNkErFSayzK5b6lrwCoXf2SCulYwYGQ0u3pk7155ZN7VVfiE/qUtmuci/52MupApLH8sqijiATa7l79FwZkN8I2JOvm+5/IZA/wK8pVnjOYP5XKQefatWWX/v1+wwxbvhNd+h//o3nz7Y2OWtCS41EJsAx4EcOJou/mphxGx9sWnk1A/OJyz7H+wOAa0LCiSvPrLP48Ez+CzPqlY47lHHqf6zgU+cMlyh2ZWL1BuruYhqpxZQaPOg6gOC/ukDQ29VBhhRccuC61GWT9USWJgpTqbGBN3NWkp3Ot5h5PXWuNS4SKgfXbSM1q9paBt4mgAO1uQC92fB0/W03LLaYTjA1dr1aTr6IXFwyrr3pGULNYS66IdvB9aA3Uk45UDAGc2GqFq3cc915nt1hsug7HPTh+R6KvbXC5b2JTLePQM2hGmKLDz/I0oynCqlOHzgFGPgc9KpQixFUjeaQScbGVN+AhzKdL2q6YZFKJ641YOdikNZyB/zy9vdKeh4iXl/TLdSkigXOMY9nj7Ohywk/009QNA3lXepYkL6mCE
 C4zxHqps
 aUi4d/Uwl3Fj3mXkhP+WCKpnRHFz19LgnyNhUoyfqeNX9GOW2Y2TNOEdr/OlKXysScnwA33WI4cDlPi+ykH5n027jauYKiFypyzulliz0Wmk4zMj8eRPb+OdVEyA6E1nlItPz4jFg4nT+cyl/33vVJLXbPcxIcEx41qBDMSoMXPNn1qC+oxqvwSth2RTAJVPFCgXvG2XPawFNcrOTQ0z627qxvfHoDznSUh8JeGjoHYX/zh2Xnz/mH64F1uFERxg1Ug2HvcjcVnhuuudWoM9CP7KycsVDlr+xoh3msZ0ttOpjrdo79cvFiq0RDmXqr+n7lRbTeKPWS6afCfoe674Ld5zdJbw8l1A7QWqT2QpHDls7YhloHWZtI4hImb8ZNXRFCr/6sZjlZKKF+8zDpJQmxChsssciKB+wKqVC+NOSl4ZwerKZLirT1tUbjacgGzpRtcnGBJqzJ5FFtRR/byPDNY2ydGd4q+IJKW9T9CYpsY9jKa+OIFcCI5/C2w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mike!

On 4/29/26 2:12 AM, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> cow tests skips HugeTLB tests if there are no free huge pages prepared
> by a wrapper script.
> 
> Add setup of HugeTLB pages to the test and make sure that the original
> settings are restored on the test exit.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  tools/testing/selftests/mm/cow.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/cow.c b/tools/testing/selftests/mm/cow.c
> index 4321f4208fe3..1df513bf362d 100644
> --- a/tools/testing/selftests/mm/cow.c
> +++ b/tools/testing/selftests/mm/cow.c
> @@ -1881,21 +1881,21 @@ int main(int argc, char **argv)
>  
>  	ksft_print_header();
>  
> +	hugepage_save_settings(true, true);

Since hugetlb_setup below already calls hugepage_save_settings()
internally, perhaps we can change this to hugepage_save_settings(true,
false) or simply keep thp_save_settings()? Otherwise we're saving the
HugeTLB state twice here and it seems redundant.

> +
>  	pagesize = getpagesize();
>  	pmdsize = read_pmd_pagesize();
>  	if (pmdsize) {
>  		/* Only if THP is supported. */
>  		thp_read_settings(&default_settings);
>  		default_settings.hugepages[sz2ord(pmdsize, pagesize)].enabled = THP_INHERIT;
> -		thp_save_settings();
>  		thp_push_settings(&default_settings);
>  
>  		ksft_print_msg("[INFO] detected PMD size: %zu KiB\n",
>  			       pmdsize / 1024);
>  		nr_thpsizes = detect_thp_sizes(thpsizes, ARRAY_SIZE(thpsizes));
>  	}
> -	nr_hugetlbsizes = detect_hugetlb_page_sizes(hugetlbsizes,
> -						    ARRAY_SIZE(hugetlbsizes));
> +	nr_hugetlbsizes = hugetlb_setup(2, hugetlbsizes, ARRAY_SIZE(hugetlbsizes));
>  	has_huge_zeropage = detect_huge_zeropage();
>  
>  	ksft_set_plan(ARRAY_SIZE(anon_test_cases) * tests_per_anon_test_case() +


