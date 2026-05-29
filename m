Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86997CD5BD2
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 06:33:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82A696B0005; Fri, 29 May 2026 02:33:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DB6B6B0088; Fri, 29 May 2026 02:33:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A3086B008A; Fri, 29 May 2026 02:33:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 551F56B0005
	for <linux-mm@kvack.org>; Fri, 29 May 2026 02:33:21 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 21B561A09C2
	for <linux-mm@kvack.org>; Fri, 29 May 2026 06:33:21 +0000 (UTC)
X-FDA: 84819490602.06.D429288
Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013016.outbound.protection.outlook.com [40.107.159.16])
	by imf12.hostedemail.com (Postfix) with ESMTP id C906240002
	for <linux-mm@kvack.org>; Fri, 29 May 2026 06:33:16 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=THi7Jff6;
	dkim=pass header.d=arm.com header.s=selector1 header.b=THi7Jff6;
	spf=pass (imf12.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 40.107.159.16 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1780036397; a=rsa-sha256;
	cv=pass;
	b=SFYQymT+PapgntjNGAOnf6Lvs2QHGbUbJnA0ENTYcILG1TcS40fx6MHFoJHsWEmjx/ewCE
	85qD0Cq5H+XpXhfdasqaj9xdDixsCEUXfU9ZYeEoba1J/7T4eqEsIxduaE8VmvPYHLAKf9
	Be/hiIAamnRjiVOFJNfIGLVhZ8aYbrg=
ARC-Authentication-Results: i=3;
	imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=THi7Jff6;
	dkim=pass header.d=arm.com header.s=selector1 header.b=THi7Jff6;
	spf=pass (imf12.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 40.107.159.16 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780036397;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GW0CP+ZsZC4al5ZwOSMYomFQLHQKOerVe7jZ0jYNcrU=;
	b=dqMFziYUNJjAhoyQwSxbz/Ce6xwa87TC1eCDoqLW2HbKYaMULK3dJQ768HNkByj1DDIdg7
	OlC3Cr09WFQFuC/6Gs1Kapm5ZY0NtMpIQToy/FHka7HjL1N2qHKwmRKLYidU8shXMUJPhG
	rbFHu9p3SLjefEM2+lH76zUaGeqUlXk=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=dnRvtIUt25yeguLBaYWCfpWZdcrU5UdVLpTWDLnPVvLBlfrSlWVjODTieR7p9B9zQLLUgbWwYnzCvwv6XO+5xVd1fcKXKbGfDu3A+Ovw2KnR2231N7y2RYEs3RaPz3Kos9sypX03zrSAh9efhFhwyBhXXdwbUkW0J88wujxbnQqMSFT8MvQRWUiMY5eMrpjduWLD30hxyakyFDhXDnn4bi3bhXqjoZVkorTXxeGDnGrLIqPkotLLTwMBMkVVznpituWQ2JzqW/nohE+iQnSqos7EQ4q0MRCCOqofUccO7OWldZT/oAR1/TpwpCrRm2ryP66hjWX4OJi2lt66BvprhA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GW0CP+ZsZC4al5ZwOSMYomFQLHQKOerVe7jZ0jYNcrU=;
 b=AVBQCGJFOlGFVuTihMfZwHNiW5J+Ya4PS029SH2LfHR71arLmW9M8BFkZy0n2TX5QnM8Ys3uQ+DOkWda3nMemU6s5bRzAclK/AoVxjxKH/EvkjZ0RRgPeDQJiqUHXOoMyeZ7JZRsyG9Tco2xmfoM7ciSc0TSbosb7cTKJ1tpnKOQRrPj8ZZt5nCon5vlbsW1arh/4JlVU420WndYDIIFof+IqhgHLj8DVZ2NDI3oj1W+xh98XH21igNpeHhGCUzDUlCrlpzfjgS4wfdY1uYtf7tejhU3Lzf3+FAj5pZsx33lHs3AFCj6adcXYd30lK7H/MQ/S8Oqr0sLDZ2BYMT4pg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GW0CP+ZsZC4al5ZwOSMYomFQLHQKOerVe7jZ0jYNcrU=;
 b=THi7Jff6jkViJnCpuIHMfbBqt2M0fhgvOcH7aFitLjt212EmMrBOjnTRX1BQceOIb2JM2UT0zvPA8wJeT7XYKKCBUJM+dCUYmk3uyQApa3wVBbcTHoHkRNqfYr6uZmo8wphxASxVqYqOvMCZLOwQRHb5nPYB8k0dz4aSLyAaVEc=
Received: from AS8PR04CA0049.eurprd04.prod.outlook.com (2603:10a6:20b:312::24)
 by DB4PR08MB8032.eurprd08.prod.outlook.com (2603:10a6:10:388::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.15; Fri, 29 May
 2026 06:33:11 +0000
Received: from AMS1EPF0000004E.eurprd04.prod.outlook.com
 (2603:10a6:20b:312:cafe::8a) by AS8PR04CA0049.outlook.office365.com
 (2603:10a6:20b:312::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.71.13 via Frontend Transport; Fri, 29
 May 2026 06:33:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF0000004E.mail.protection.outlook.com (10.167.16.139) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.92.5 via
 Frontend Transport; Fri, 29 May 2026 06:33:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hN6NjjapgGaBIu+z5x08x8Wf/AurLiY6K4HLJcnrpJDoxPEzIHZt8O+PcAyJq4+XsfgrPTQzHFVnhe/JYGb5q2+2AvfyVLj3HpohcobTjFM6+6cy1MKyGBN5XpHmy7uw+X2wFU/Wi8MnG70C9LerTBp1hfiirQPI+6vOFyaDYTXacRFykjXjTlGW1XP8CE/tMRDGcXqqCWPW2KlXtpCQMIFSscqhxt30e/gB+8m8VokiQAItK7aIJqw6+nWEH6K/KcVDOQUnDLs5q0yEm3pDfifLMP3jloU88oCh2Bb3u8MSVyJX6eszMgsqQL1h0I9Y5GzrcwFmpD2awFbjQEvEtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GW0CP+ZsZC4al5ZwOSMYomFQLHQKOerVe7jZ0jYNcrU=;
 b=SByACEEAtSZM0yxm6/WLHayO2jAyaBIavoAvph1g3Px8Qns4+OzbUw8PFgK1JXF/lROXYrqvFBKCPZy8/LRzQCnXhoVaeE0+QXh3iixlg3rCQsUe7NnDUpNTKuMYjIphhOJgwstEmM1V/ymV5L8RubLoq0Z16kPld+31OEK9CD7Yd4zuKYHZbuojdhz2MFgzi78RiaoifomEkyOj4pOtjo8yqqeaOsjAW0iJDDbD23BNfYw/nm86PMcNeWpkpvIW6glws/BgL6YLdGOTK0f+f/PNbaeo7b87BHmKysr6uegkSfRBsb7xt70A0Xfbi9HJ4MEWirlskRXjJbwwdOFhLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GW0CP+ZsZC4al5ZwOSMYomFQLHQKOerVe7jZ0jYNcrU=;
 b=THi7Jff6jkViJnCpuIHMfbBqt2M0fhgvOcH7aFitLjt212EmMrBOjnTRX1BQceOIb2JM2UT0zvPA8wJeT7XYKKCBUJM+dCUYmk3uyQApa3wVBbcTHoHkRNqfYr6uZmo8wphxASxVqYqOvMCZLOwQRHb5nPYB8k0dz4aSLyAaVEc=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com (2603:10a6:10:417::12)
 by DU0PR08MB8322.eurprd08.prod.outlook.com (2603:10a6:10:40d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.12; Fri, 29 May
 2026 06:32:01 +0000
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047]) by DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047%5]) with mapi id 15.21.0071.011; Fri, 29 May 2026
 06:32:01 +0000
Message-ID: <3e98ca04-086a-4028-a854-c317d0ceae70@arm.com>
Date: Fri, 29 May 2026 12:01:52 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/5] selftests/mm: separate GUP microbenchmarking from
 functional testing
To: Dev Jain <dev.jain@arm.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
 Leon Romanovsky <leon@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Mark Brown <broonie@kernel.org>,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260527142432.230127-1-sarthak.sharma@arm.com>
 <20260527114752.cf4dd3e1bda93fb8ebab5a76@linux-foundation.org>
 <3b4176f4-e099-490c-a5e2-6a36d00b1207@arm.com>
 <403181bc-eab0-4f4a-b986-dab1d8c49bf3@arm.com>
From: Sarthak Sharma <sarthak.sharma@arm.com>
Content-Language: en-US
In-Reply-To: <403181bc-eab0-4f4a-b986-dab1d8c49bf3@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5P287CA0130.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:1d2::12) To DU0PR08MB9203.eurprd08.prod.outlook.com
 (2603:10a6:10:417::12)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU0PR08MB9203:EE_|DU0PR08MB8322:EE_|AMS1EPF0000004E:EE_|DB4PR08MB8032:EE_
X-MS-Office365-Filtering-Correlation-Id: d1e1eee2-4a88-409c-edac-08debd4c2732
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|7416014|366016|18002099003|22082099003|5023799004|11063799006|6133799003|56012099006|4143699003;
X-Microsoft-Antispam-Message-Info-Original:
 tUvvY6LButqZipRaMhA47/6SsP6CmDzeTzULWjTgUyFEcbNuCXwy0Y5Rum+5WEp04QdUkVooOqXJ9JqSnDH4DcmMbCjEzD5elc6QZIBpoU00KmfNdq5c2f7ldeERGM+ks3nsK0zQszj9mhPPS0WqGitm2fUbsuSY5dOx61uFEcOAoYvIWbUgdSaI2ehwXSFZIoJgBS+ALkrPSB+TjaDuz1Z6ptGws116f+M8IsxfvJGtdIQg3r1ySEA0wEEZLMHwbBacZmj4Hha0HiGQeNhd0khpU84MnU37prRbfIz5/cxof36zY8A19IPVyLq9MISbpB2loRpJJkVPcHIEv0wEMCpgjxBe0HxtBSrnHNaJm8lR15vulMWRSpFaC+3yV9DRw2kkUb589cgeZ4mBYVANbBk8nAN2X0tHSf7Sr7wpBrqL8t74bxk5hufu5s0BuwmoPUX2nl5E8Pcjsizuf67PT0zfJBGh/el9y9XNO5CgfRoJdSwgr8Hocz5XD/tgHiZwBhk6ooTFLwVlYsU/cD64FkBHZtapupyMtyuNZKUqxZs6kOrkZ/bBSbS4s2S7liDHCh6XEOpMtVoHiGJiohP1kpzsvKKbfGAi3uU1C5utQKQsJj/nBf5p3QUV2zx5716ayen1CK5MDNxtLhFzVOtUBQ==
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9203.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(18002099003)(22082099003)(5023799004)(11063799006)(6133799003)(56012099006)(4143699003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 s/gIiAWAhe5B94m/n3N6UmAKfP+CEq6J4KNHeRlNtvCUJAthG2mEocMOa9NBlNQ6DHzqjtCOyhCKMh4wF0JWonL/DVzbEDkjihTvGxyHWWrP6dWQrRLPWJ66tJZLmrCQKIKvXqbTJ3NSlQKsv4kkvxlmEumiv1r3lic1ir/wvx8+R3L6ZLvi+CCSsOcCUxVSZs1cu3e0apuEG3WMakP4kpaO1ep1ksocjFHaEfVYAECFruKRrr6x2nDAxpCwq/IJ/qkS1mPa4JPnFsfo5c9XS+/Clgg0iXUXAOvtqsF9SWZ0WeyOxANoUMddSmggQPzK1b8i0mvVcN9A9Y0u0R88NQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB8322
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF0000004E.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	7d29084b-5f9a-4d35-5920-08debd4bfde4
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|36860700016|82310400026|35042699022|1800799024|376014|7416014|56012099006|4143699003|6133799003|11063799006|5023799004|22082099003|18002099003|13003099007;
X-Microsoft-Antispam-Message-Info:
	E1sglhRdTHFPfgh58Ey8uSSf8Gp3zO6RB/pyP0zjXf7KSZ8mimQ5TwJ9JzGDWm8OGYgNAtNFOK/iWtHW4kleOfFsxgZTEx3V8zi3+k8atPOis6ppo/xrrR0R5Jm4I4yxefgFcUvm+fwtNbeDW8szJXpdYZKSGBLgKjFAFuJoSEurcCBzIdejQcMk4PUTwSVw+8AzJjKtLHg6vn6VAUg6SeSEZVjdOFzvBuPqtvV+dxnASNvrHZ8pA5pbnS39Uout+PhSSM/bwm7z1qtHUIrNwtjiPghF6hbtISTHsUdc2nLKqyQEBLubTetJGfRVmWtRDreuD09eXvC+JaJY25qoLsuPVUPoLKTuVqYiRylm7kM6N+8A7fgOzIHTttpdw38Gy3PeiN9YIES357YvUi4QTvUrCup1mGpxgZedvZVxIzmeWFfohsRZsLWLnjUEPNk+I21IXP09Z+3UOgIYOfYLFwc4eU94B5hQFLJKA4pytuVkstOhKx7XSP+NpOM1JYl435EtbM9Z6PdTzAJU2hSKjBcpZYXnytBisqmACuTK/vJN7O5dfEDIBnHzV6U7ugaN4Y4gPh+Gq8gUMlbyCHzSwRIwpsVDjJmqJClpv1VDtSP61H0jp1qu9MS4JkCLuFqbNGKWXNYW31ukaAECYGhPok0HKE51rUyi9wU4UU4W6qwo2OY3FonN/xQkrko5o6CG
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(36860700016)(82310400026)(35042699022)(1800799024)(376014)(7416014)(56012099006)(4143699003)(6133799003)(11063799006)(5023799004)(22082099003)(18002099003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	u2Ym6cVVrUgSt7cEx8Xwh6QOyJ+4Wgi64jpeE/iSkmH8uQ4L+jkQ8S5uG5ra3Nph+k52xZNL9DmsXTHiJ4nZP+Lbi9Y8tNfE+tbzE7kmIGetOOVsVvhEOG73q5kmfe7QUUZ9n6Pum/40KqbqrnDKajKmSVM+h5n625AczjGDcq2cJvBN21XnWzZiQLbfgJenUEeQx9V0E1Xn339AKbj5coU1yt5FTo3tT59a2aLNLpGfE1/Buo+jGxDjwyJXy5al7xldcUL+auxKlrR0drqRR6cYZ4s5ZVuWR1qsI3rQ17NZSKeNBi0Ss9BrjF2hRllScVaKLQgpqpLH57LXEayc+XB5bdg3qShB2gTZMWkHweODPtYLrn3lClfEDafwUooU83Nkn0Gy4BANnGDp9fYLDmhqmOhXaO7XfJwgCE3p7k+8xwrNWmSSzE/QgU4uRMcw
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2026 06:33:10.5057
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d1e1eee2-4a88-409c-edac-08debd4c2732
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF0000004E.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB4PR08MB8032
X-Rspam-User: 
X-Rspamd-Queue-Id: C906240002
X-Rspamd-Server: rspam03
X-Stat-Signature: 1i55zrq8jr18huqdkxsqiyx5k6enrouw
X-HE-Tag: 1780036396-150906
X-HE-Meta: U2FsdGVkX18C5aV2hL5DkkHJ1xBi2+mrVzFcj3ORJrd8t2U6uyZyuVAO3npG8J8ry+C1xBw4Spte91t9LcO5+gyIc/8iHaX7RNY6GLvpkF/0DUjGF2GdNsxgB+X9wi4ESXr+W74JP0zsiU2bF/+9Hdp6Pa71XGKsLE4iFZwsvcMMVtQPJuAc95dqEoDIx/18K5GDEnHhZyZt2akTq4cYPnr4xg0X/fwWRSkbo0qlIv5J+5IhyYkMPKgcOWWW7TsdrO7+KFnmgf1foE//mFW0Y4v0Q/wBUIQ1PsWtnZMIxVKTusEPgBiKF6ilRQmcCTWnMOiavUEGJYOWlq9gLm7VwhhcDELEud0q0a4v9a8bxuD732O7sDSywF12AOsgDQ9Qd2pjiReJ8+SuFK3i0bPgyJX8OwvE85NIeW2iKAkelSRQStKoMulUvAwyYiUBk7rF0kC8Nhs0tw3gAuihibPzoON6Dn4b1cOjbEGfswnVf5brS4jKwI55p3a2L5aIj0jnUwCKZ/hIsvn9KXUGHyOfvd/YdChdqxcdP08U9QpQrVIF+N+Run26m0fV5Zajdz5u7Ze2pBblihLaRDpzh+E4YHf+wD60QChfYas75daoTX0S3S00r2QBn02L5fEJwKXqPE5NeQ8Qpgvx0yynNt7A5DBkvYw3+u7N6Jfgl1oSIF7zWF/+Rz+z++P4qjUcuwCNSRSMQzBSjcsW+X4DYSyhecaXAsjXhaQpin7CRXv8+0SLixbape5Whe/PGmaOdQAkIChJ0J4SX9rJI8XflGfeqTzZGV991PTVWZyzydKGS2ZmN+bMkOe1LzxBDkHxowemD+r7fgxXtr+4ip1IJpsM2YYaHhZAL5rMAsQu72HZOUKD3ySTfXu+doNO7YzEwkuYQqrckjrHAqXm6OTFQirAPpz3MLPRx23ShKGzJOYHTSDzeIHdVEtZ5mEr5Y2ZM6EA0RI3O94DzYctrVtRgHz
 OVYy09w0
 m2cUvOF6vliZZiq5DocO/rADQ6p+YuiG8gHeAZNp5Vw1BQ5+RpEuW3jLQVkYCSOUZgbMMe/HP9fjxW3CK6Jj6UGAnFebnn+tVWkcoQjP7yHGLowKP+xbZRW+r5p1qiQlDel6gdCV8bcqXwxkfmE4ROSiM/wGBIub1rsKZ1lT53vLMxrkLbX2zI8XLNESAnayGY4a+tW6JLxxlE5b8bvFf0zJT+OdcYtDIwtcEAu+4AvXN1OK1RKQCzz+VpaBqcpnMWsykUHuP+k53YEIHpy7G9FRmhqdLwz/qskdsKz1D0jAW2+pkEgKPWdy4unokdgfnwVjyh9AhYLgcbZ0wzo/r5+ogRM8iLFJqpTV7zP90mwIJYiacJZq+nd6bMweLKz10euvoiQXPbmc9DMlImCnHOKiKPuYv/7DK+uNV4jxrVXxqFd/YmLwSeo8Phez3LZJClMMGKUIVctphmCqUj2g88OeMkCxkcFG/8cVGsvlETlMLFGF/pB5YDUaMv5vr9NxKVSNfKZuya66SCQzRYfOR7KLySGmbCi7UIwmorHgULHAteypDGGbegjGX5DVh7H5XmwOedXk7gV6YYno5wJFI7QsdilmJ106KP+9q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Dev!

On 5/29/26 11:36 AM, Dev Jain wrote:
> 
> 
> On 29/05/26 11:27 am, Sarthak Sharma wrote:
>> Hi Andrew!
>>
>> On 5/28/26 12:17 AM, Andrew Morton wrote:
>>> On Wed, 27 May 2026 19:54:27 +0530 Sarthak Sharma <sarthak.sharma@arm.com> wrote:
>>>
>>>> gup_test.c currently serves two distinct purposes: microbenchmarking
>>>> (GUP_FAST_BENCHMARK, PIN_FAST_BENCHMARK, PIN_LONGTERM_BENCHMARK) and
>>>> functional correctness testing (GUP_BASIC_TEST, PIN_BASIC_TEST,
>>>> DUMP_USER_PAGES_TEST). Mixing these in a single binary means functional
>>>> tests cannot be run or reported individually and run_vmtests.sh must
>>>> invoke the binary multiple times with different flag combinations to
>>>> cover all configurations.
>>>>
>>>> This patch series separates the two concerns: tools/mm/gup_bench for
>>>> benchmarking and tools/testing/selftests/mm/gup_test for functional
>>>> testing. To avoid duplicating HugeTLB and related file helpers, the
>>>> series first prepares the existing file helpers for sharing, then moves
>>>> the common helper code to tools/lib/mm/ so it can be shared by both
>>>> selftests and tools/mm.
>>>
>>> Thanks.  I'll duck this for now, see what reviewers have to say.
>>>
>>> Sashiko still has a couple of nags.  Minor stuff, arguably ignorable.
>>> 	https://sashiko.dev/#/patchset/20260527142432.230127-1-sarthak.sharma@arm.com
>>
>> Thanks! I went through Sashiko's review.
>>
>> Both the points are valid but look very minor to me: one is a temporary
>> x86 build issue fixed by the next patch and the other is stricter
> 
> For the sake of bisection, we try to make patches such that each patch
> when applied one by one, does not break the build. Sashiko says that
> applying this patch breaks mm-selftests build for x86, so this needs
> to be fixed : )
> 
> Although if there is no other major review comment, instead of respinning
> you could simply reply to this patch with a fix patch and Andrew can
> incorporate that : )

Thanks, that makes sense.

I'll wait for reviewer feedback for now. If no major comment comes in,
I'll send a fix patch to move the x86 Makefile change from patch 3 to
patch 2.

> 
>> argument validation for -F in gup_bench.
> 
>>
>> I don't feel they require a v5 on their own. Let's wait for reviewer
>> feedback. If a respin is needed then I'll fold these cleanups in as well.
>>
> 


