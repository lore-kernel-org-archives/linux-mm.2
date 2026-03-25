Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A614106B53F
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 14:08:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2D716B0005; Wed, 25 Mar 2026 10:08:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDE836B0089; Wed, 25 Mar 2026 10:08:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7EE76B0096; Wed, 25 Mar 2026 10:08:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B5A2F6B0005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 10:08:15 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 843B71609BF
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:08:15 +0000 (UTC)
X-FDA: 84584764950.04.08B8B65
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011034.outbound.protection.outlook.com [40.107.130.34])
	by imf01.hostedemail.com (Postfix) with ESMTP id 26EC240010
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:08:10 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=X5FuaaUq;
	dkim=pass header.d=arm.com header.s=selector1 header.b=X5FuaaUq;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf01.hostedemail.com: domain of Usama.Anjum@arm.com designates 40.107.130.34 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1774447691; a=rsa-sha256;
	cv=pass;
	b=kmUQCEF48puCzoPCfgWAW8w9SJqTUiKKKxkuMF7joWA+G67DV3+rDPR1ZOfrC/TkLa0/OV
	daXpxRA6S9pxGeHuCtyLtdW8GWHW/+ahP2mRwUo4d7bHkdIBaK2TVvqcgerIQoU3ReCg2P
	Ne6JveIEy2nK4xbX56FiPoGqBYKopAY=
ARC-Authentication-Results: i=3;
	imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=X5FuaaUq;
	dkim=pass header.d=arm.com header.s=selector1 header.b=X5FuaaUq;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf01.hostedemail.com: domain of Usama.Anjum@arm.com designates 40.107.130.34 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774447691;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YJ6QYbQNCAkHBRQHOVRNeV588J5KHcr3/XIoNZSqVRA=;
	b=8YorBJKWQZo7AV0UaBi9fkJWRFCYH8tyXfzMBWlEFY60qpVfID1B7w79Eg6kDo6sjE536e
	ZSdysO17QdTOKPqhzjwMTXypCHj86CLRbMSJ4KCLP1Om4dsbhbivKV0zeL7pxK3Xh7p75M
	jsm1o+MES2HtXXkwibDpi8lP5D0BWB8=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=BnKCv8x7hJJSMtEZ3LyoW+KuqNBc42+kaMEQBKPwPQBEw54XhviVM2YnuFNh+CqA2YKtrG9OOjg6NjW6sqj6D03AF28u+GPsJm8cVLVPDrE1Kdt1Kp1MlvFMU7jeQQxwJLVE88qP4XYdLTTHPPyAMK5w/jp8PDttpBWqPZ0wo5a5kXZ9KIJd9AgH+P+vX6xkPcEEcDN/TLh8fVMF3RT66MCdmUObeOoyiN7hDyNSSomlZQcCh2b/HJ2hC6CrZpTBJzNG8fxt8DGM75xnmrVjN2aP8ynMlRIhfsezxAyKLifbzMgqQSGxrCK5hHySl+GOMkYxFSt9HQa4rJIYyYmPyQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YJ6QYbQNCAkHBRQHOVRNeV588J5KHcr3/XIoNZSqVRA=;
 b=T5uMIKfhGNQxka6fjtiZ/hzf2+SO9Tdt9WT8QnJPT/Kv0neMeN1h/Bbog0Tsq26Ze7LwdJF23nPV5BnPjMUgk0cGYExg97SOB3wkp2tPkunx4nPvQeaMVP1lNXf6tbTzv1Lync5TBuZZbEnKOiLZaU8FjxlbAXA/ujFJSMGYsrWdHiHUhH752MaYmj4Dos0mKHx76M95uUM4gowXp3qFelEzkaNnA53OVAFB/ZLqbJ8pxOj74Er+I70AozPLRu6yySsxCCuin1MR0V8uf1/wr2xaDf2heTzvYiJG4y8KdcKjq4LIgJgZUNgNb+hfb6QNCPVzC7p4uih3uOEDZsZLfg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=nvidia.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YJ6QYbQNCAkHBRQHOVRNeV588J5KHcr3/XIoNZSqVRA=;
 b=X5FuaaUqVJz3iCYkpvE04u5jjVVxHPkUwq7T+1eNejnhLbjo7J3Bq7Sg2zZMTCk9Xc777eUvd4+LrTNPrMo5yp7TNeQLIWypGQ9MejWHGsR6/y8uARYpEiF9LLLNreTvgGkNf+xpn9XVXVgPqeUXY/Yps4uIeIZSTVxK++gEh3Q=
Received: from AS4PR09CA0030.eurprd09.prod.outlook.com (2603:10a6:20b:5d4::20)
 by GV2PR08MB11605.eurprd08.prod.outlook.com (2603:10a6:150:2d6::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.20; Wed, 25 Mar
 2026 14:08:01 +0000
Received: from AM4PEPF00027A62.eurprd04.prod.outlook.com
 (2603:10a6:20b:5d4:cafe::b2) by AS4PR09CA0030.outlook.office365.com
 (2603:10a6:20b:5d4::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.31 via Frontend Transport; Wed,
 25 Mar 2026 14:07:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00027A62.mail.protection.outlook.com (10.167.16.71) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9745.21
 via Frontend Transport; Wed, 25 Mar 2026 14:08:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ItrNiyO7zV4uf0EpOliWe+G9jNf5z75r4iqgbgswMidtzt3RXbY3jO6tV0JdEuRD+597LWP8FEbklKelZnCU0NxKX3UEEReWjBO/HwERQzCoXoBi8SxDm110Vwd4kGneWfH5/1zNb4+05I+eMl6BIPXP+mAIPCDrH8u2TJIBV+DKFwvx+/I87+7g54hBUxiCqwmOaTrhERf8mND2p5Bl2sz7gX/UJ2PxFXpee8uE5tffnusFi0GQrpHHKXVfl5WjCT2BhKASe805shzzQTv68sEM5vNWK3h9DpmVR8DblypqYX0x/fpPbEDH/wbNLr7EUnj04hIesWn0lhfy6sqVJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YJ6QYbQNCAkHBRQHOVRNeV588J5KHcr3/XIoNZSqVRA=;
 b=CKhTzPP8rir4fSlKUPAorxvH3k9VBDS13wx+sleRlPT4pyUSHfS8GqQ3gc96gPdR0YDsylBSml3arB7knShzflrG2t0TFEttN7bdAWlL9MUL7VSqrFTuIuklHiisGPOH9RXsNd0v1cUJSaGHCd/HezBUONnId17GU0Ht74o2ZVAAHwURTWnXoXLasrZBWrGU2Z4gUlB3Jdk4gcyhBL+3IggnbYGzibiTXSsKvAnc8bLCNzkwuMK+XTYAE7PeFN+f9UhyGi5qP5OXzBae8rVD+UGQUKmllcwia+1QbS3smSw0r5PbxsOUMgjkF+VFuUy38Xs1UNiC05NvmHj4/0IZKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YJ6QYbQNCAkHBRQHOVRNeV588J5KHcr3/XIoNZSqVRA=;
 b=X5FuaaUqVJz3iCYkpvE04u5jjVVxHPkUwq7T+1eNejnhLbjo7J3Bq7Sg2zZMTCk9Xc777eUvd4+LrTNPrMo5yp7TNeQLIWypGQ9MejWHGsR6/y8uARYpEiF9LLLNreTvgGkNf+xpn9XVXVgPqeUXY/Yps4uIeIZSTVxK++gEh3Q=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AM6PR08MB3414.eurprd08.prod.outlook.com (2603:10a6:20b:49::10)
 by DB9PR08MB9682.eurprd08.prod.outlook.com (2603:10a6:10:462::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.20; Wed, 25 Mar
 2026 14:06:53 +0000
Received: from AM6PR08MB3414.eurprd08.prod.outlook.com
 ([fe80::dde8:bf0b:1dc:2a2]) by AM6PR08MB3414.eurprd08.prod.outlook.com
 ([fe80::dde8:bf0b:1dc:2a2%4]) with mapi id 15.20.9632.017; Wed, 25 Mar 2026
 14:06:52 +0000
Message-ID: <a68800f1-ad23-4788-af70-50c93c91aaf3@arm.com>
Date: Wed, 25 Mar 2026 14:06:50 +0000
User-Agent: Mozilla Thunderbird
Cc: usama.anjum@arm.com, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Uladzislau Rezki <urezki@gmail.com>, Nick Terrell <terrelln@fb.com>,
 David Sterba <dsterba@suse.com>, Vishal Moola <vishal.moola@gmail.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
 Ryan.Roberts@arm.com
Subject: Re: [PATCH v3 1/3] mm/page_alloc: Optimize free_contig_range()
To: Zi Yan <ziy@nvidia.com>, David Hildenbrand <david.hildenbrand@arm.com>
References: <20260324133538.497616-1-usama.anjum@arm.com>
 <20260324133538.497616-2-usama.anjum@arm.com>
 <E976076E-68B6-4088-BA67-AF4ACC0D3E7E@nvidia.com>
 <88ff0f5b-e6d2-400f-9316-4863a5d169ea@arm.com>
 <42C0A333-EB71-42A5-83A2-36831E1F5E50@nvidia.com>
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Content-Language: en-US
In-Reply-To: <42C0A333-EB71-42A5-83A2-36831E1F5E50@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0546.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:319::17) To AM6PR08MB3414.eurprd08.prod.outlook.com
 (2603:10a6:20b:49::10)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	AM6PR08MB3414:EE_|DB9PR08MB9682:EE_|AM4PEPF00027A62:EE_|GV2PR08MB11605:EE_
X-MS-Office365-Filtering-Correlation-Id: baea7082-f2e0-4513-b783-08de8a77ec4d
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|7416014|366016|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info-Original:
 yNhmmw8MDttXA2c7BALtyzuGMTJEikMACZbs7UThmIlvsXvv7klwI935Nvq8J4zQgXos0Imnr4JKvIRONxTjw9sGDo82sQXCW0KV4Ir8KavyrwZXt1elAzX4Xl6Vo2ZF52szP9RhY8iZTZiRaGoQth96KOsOP7tEZU7Ra1mwsZW7u5IkXIw14f7fKWOKhCYImDrUCiYMrb8lTZAyK0UzNHbBinaierPCMhPu7I9X0KJKaYWFc0tUaeqz62Sim4v5O9JxraaVu9Wy6CaOTr0aleKSt6KcgTI/+ynsTo7OWmIaoOIHPrkbgKoIONV6ABdkEPfRCUG/tuzQ8KqzOJLYO+SHvueCr9sdcEWl6EPkHfMTu8941lNCvUD4w2t09y0noCLOkI3zf7mPExBhL9K8HEDm1zITYZIQXiSSB0Rpm38aE6ga5EXM38rk3bIRxhict6ShNvEZxtQmH75Oy39/zqeCmgVjGC+hDpYNUqGh/CM8iS1xnPw6WLoIPzCm9m5DpenYNHOzi487JqT5BsQupWGBz+D9tNt+/bLGmYpYevE7Lc5wykDyRlzed13c+V5aVvm+DNYyDq0kZN29/doylvFGlKcMJPQ9n8Ss/W2W1gTwGisTrGD11g2xC8BWskWY7agnVsBrE+8kVLsHM3Mn9yWtcgLN8KFYoQuCnO0SNzgi788WJr6t5pO1N4/21qBGVm2Ycj0zFBVKaafpMn8qvFP04UTP4He5aL29uNFRtW8=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB3414.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 JEtksENzt3fksMUTFiOb5OBCqFUZ+zFSj1+53VF4DPQS8NAG2Hj+3yNcByVBCNfKv2t2hPNJwePF8Xwmx/3ZsH3tHKfGMYbIbPDvDJXEqgDB6pnpzeMOMENN5qy8DArbZ0DR8k4/tuuYI+IefBwU6TWuR3+MY2WIROps2jnL38HN/RGp42qMaE7sdjnhSl3eXb4j0hwInCX4ltP0niAvivg2itkTcYRgwPPGNP0JEgc9zo27gHfn8s9+oKcqFgqUcW+4Q4wsr8fyEGldNw69TVSPCnqUzOOSQBOU33TBW3to2rOrJzrSp8L7zttMYH5+wriddn9irWfIfkayZ74aSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB9682
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00027A62.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	96a18d13-5e89-43c5-175c-08de8a77c366
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|82310400026|35042699022|36860700016|7416014|376014|1800799024|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	Vc5lnUxOKgB94QSHr0bvzhDdwipVu5C5rEKz/hRhs/DUC0jCob6moD+OJ1Cwm5kPy7EYToQ+VcZqHAN/7HGjyi20GvD4mZg5/BddAvYTjIrMMl6I0nDBvWE0IafUKr1muGs9ps237wT8TyD5mPbzqcyvvOGz6uYD97RVAMiLNix/OeROw3TxBMUqmNQro3MjkCJMWmKG3GzzLFeJxAQQMnbRKSYUY8jTDqo4SCMfANcZudSfqwz+NVAJkjGsOJ8Czas7VVX0IvtDhh3uOoRz001AANnf+64CD4Qorjghq0POepHSxRJYuaCvksqvX7oHaGBMlNb7TBbcmNP7GTwns0V+glsSL08pZtwe7kTqh/q8d+VmLx3sG2HtbfJydIciAHxXPKj5fuRaMFXvWnJlp+TajsQTRrNj9usbc9lDAItyjJzZp36qizu1vkvtMKWkD3lDX2N3fxwqPku2YAfXH3od8YcjqgzGcCoePxRRJhmu5iFRdFYofbKS1UWjhO8SGAt70dKhDW98IRIAt0GIEPe+KkubBD8lGGG6XzOyzzfJGYiR5sr8yooJNXn0dE+v1BDeGYQhxTKz20oJ/SF6mm3zbzEtUs6C0dZlhCHB8uByHM+km3xS79+DOrWNVwW1PwXgMTeUzNNLbAJ6UNCluaNvq4gQvpGe0DWZk3sV3Z2Wf53+XB2BwCRYeZ9Kpr1RtneewuaMIGbjbuGY4O60SSpm5oLbyUHae6zfHZSG4K0jDZQ8Q/XMQUdVAQaxLY+OgJMgD4sJMLnZq8xQXiM8Ww==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(82310400026)(35042699022)(36860700016)(7416014)(376014)(1800799024)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	jHgkafy8/ST6b61Zq9q4qzKt88ijdglAsAWF5nfKQEWdYGEuG+tuUBkQcBqB8YlzCSsYs7qUUpsnXpFj7hZWgs1jrAyoWA89KKOdRC+IV3ovOJweUHVzf3UVIjizd2rz/AW90mZpv3cuZif2+nCyS1PFDaAVqnT1Bi8yY6jwhgAl30jfm+073jcD62ra9aMQJ9+luFYKj+OghOWgNuihuXRM5vhX98CTh0oEudA/Xh6/SIkklyckUHmyOclHUq2+tp6QwO5wukGteVKxdUbzH0t39hIbx189ZL2zsSWLOHfFgzg58atgwo40s6rrnq+pQEAkODkBNiMdwZ2RC4X0KejW2kGcAIi3lheR5m8UFqwTFSyS4OB8Q0PTT3TRIImqr4B902Talpsh9MXK19l80QAAnaRxUfEYVg1oc5cO77YApqf33KeOpZ0gM21qZz7O
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2026 14:08:00.2403
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: baea7082-f2e0-4513-b783-08de8a77ec4d
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00027A62.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB11605
X-Rspamd-Queue-Id: 26EC240010
X-Stat-Signature: yb675kd43oru65ubm3oogx747ai5yf5s
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774447690-327819
X-HE-Meta: U2FsdGVkX1+YKf705QvG8eUr+d0bRin5VtHwYSupmGIGiMvkKhEDYU8B4Fa8boeORmypWjkIMjDef+Yt6NJtJxTdtafsoJFHur5I4roJXdEu0I1nCgzxGc6meNGgL6xzWFn50imwN28qd6K+paXwy0F0L8bJ4pOgY2rw3wfvYmoRrIlFGGAa/7TZ581iwVH4hgDnHPTw5HnhXYwIz909bvrAKotThFnEf4YpSfpygp6q8XYAtEBFHvRDR5s6E3xP4yGqTAzd6xBuEYFz9bNs6d+CfgNQaCtSZe4+F6KWA55GdJbiwS7XHO2u7EdpNkxUEm+suj1wx96qEN1MIT2yphRUG7TdwlrVVIxfNh0WB/RSDbnF9doKcA1EXaS4hE+mcYXfpzzd3zmxSyF9X+nDAYGpWb1u98ktqwEJEDOM4Ubvbaku6eUqaKZj8nk2/SUbz0a+F+M5Fr1J6x1Yu9OIsKZzwttghKcwuRmsntT7W1Pu+uYXJAYEWQzrXRhQUs+QTDNQskN9Uvlyc1dhnhNSX3oMFm4U2tfKYUlhQfGEApqGiOELSXxbBcG9jvB+OEd6c8AC0SE8V9bxU8paeavYBMa1x6mXPdSY4MnwGbb24raVWS0Sduqrdwfg7uDwV6uCMDyq9GDT7Kb/4ogM2+YSDFeF9Qei5BYPRWrFAAd2paLeBy97NHauruKcFrncoPDqs+QJ305FATuiNi2B1G6kEWCnvqFFM/0R4Kmj3nycI7ZBMWanc+BSlwLOje0h5mf67psGYehQD+sSpZxo+Wqk58vm61OJ0N37THKRY6DpHQaKVCbkeQ3jSurGT9YkSw9BeotBYUnhd/AiNB8/zWkYQm+IulVHq7LABOXkc8ZasdS9QgqIgRKRWbjFpH2vL03mJDYrmdm2uICIKY3uA43+M0SVQ4CrqfNVX42fITmv33VCyB11hd/LWq+l5Ds/B8uewXNJ5XQtCwFLhRINai0
 sP7BbanM
 PlXO4t5PNduPS+ixHwEaBDXzm6q2nOAcE5e6ZX+Iw3VXbs5/pZ5l0ch1QiCgiNLjOrpYX1GtsoD6NQ31BDgemm4VSmB0J6voNI5mtL4GA7EBmymCVKCgkq8TTzTcyNNTnIfjt3EL9uKUjENuAdi4Db27JBvx/FQAxxvc+oNiAmn78i+8DHpBelL6Y7w/oOMTpi9O4ih10j18rHJx2rfX+sNNpdwVJBo/y5Lff8VeDPpJazb/vpkYVgxhkLuPdn+2EdJ+W6uNrz2+Qwm5mnfd8xjS6W5omvGjVW8DeIXp7cd+qJ+TS9em2fHFC/6re9fOfoJZgF1op6wvrxLbJkV2qRFVCq6gSJ7Z/gyhEkuhikPPA+yusEbHeSpfwcCwufCjRLPF2pohI+evZW2wD0P5C11wWXLyOy0sNYMA5x13EY57aYRmwzFkUm1tzFOw+K6IikE9yl0sGlPz//aH3f9f1/ZQcc/JJjGGzG3uFI7OUTrtoFWT89gA9UrcgjqHo+0tvWG1Hbtv9shcdroGUklQL69tPiFWRTUV1mYgpQwgzlZV9nx3P+0XEiErGStsN4Sp35RWVN7nXrOTkgzpk/5uY3JdRefm4fG2uXlmDRTb7upoftlNZKXZcu3JK1AFj1pN62jHrJewNrChN1Lk2she92RdP0w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24/03/2026 5:14 pm, Zi Yan wrote:
> On 24 Mar 2026, at 11:22, David Hildenbrand wrote:
> 
>> On 3/24/26 15:46, Zi Yan wrote:
>>> On 24 Mar 2026, at 9:35, Muhammad Usama Anjum wrote:
>>>
>>>> From: Ryan Roberts <ryan.roberts@arm.com>
>>>>
>>>> Decompose the range of order-0 pages to be freed into the set of largest
>>>> possible power-of-2 size and aligned chunks and free them to the pcp or
>>>> buddy. This improves on the previous approach which freed each order-0
>>>> page individually in a loop. Testing shows performance to be improved by
>>>> more than 10x in some cases.
>>>>
>>>> Since each page is order-0, we must decrement each page's reference
>>>> count individually and only consider the page for freeing as part of a
>>>> high order chunk if the reference count goes to zero. Additionally
>>>> free_pages_prepare() must be called for each individual order-0 page
>>>> too, so that the struct page state and global accounting state can be
>>>> appropriately managed. But once this is done, the resulting high order
>>>> chunks can be freed as a unit to the pcp or buddy.
>>>>
>>>> This significantly speeds up the free operation but also has the side
>>>> benefit that high order blocks are added to the pcp instead of each page
>>>> ending up on the pcp order-0 list; memory remains more readily available
>>>> in high orders.
>>>>
>>>> vmalloc will shortly become a user of this new optimized
>>>> free_contig_range() since it aggressively allocates high order
>>>> non-compound pages, but then calls split_page() to end up with
>>>> contiguous order-0 pages. These can now be freed much more efficiently.
>>>>
>>>> The execution time of the following function was measured in a server
>>>> class arm64 machine:
>>>>
>>>> static int page_alloc_high_order_test(void)
>>>> {
>>>> 	unsigned int order = HPAGE_PMD_ORDER;
>>>> 	struct page *page;
>>>> 	int i;
>>>>
>>>> 	for (i = 0; i < 100000; i++) {
>>>> 		page = alloc_pages(GFP_KERNEL, order);
>>>> 		if (!page)
>>>> 			return -1;
>>>> 		split_page(page, order);
>>>> 		free_contig_range(page_to_pfn(page), 1UL << order);
>>>> 	}
>>>>
>>>> 	return 0;
>>>> }
>>>>
>>>> Execution time before: 4097358 usec
>>>> Execution time after:   729831 usec
>>>>
>>>> Perf trace before:
>>>>
>>>>     99.63%     0.00%  kthreadd         [kernel.kallsyms]      [.] kthread
>>>>             |
>>>>             ---kthread
>>>>                0xffffb33c12a26af8
>>>>                |
>>>>                |--98.13%--0xffffb33c12a26060
>>>>                |          |
>>>>                |          |--97.37%--free_contig_range
>>>>                |          |          |
>>>>                |          |          |--94.93%--___free_pages
>>>>                |          |          |          |
>>>>                |          |          |          |--55.42%--__free_frozen_pages
>>>>                |          |          |          |          |
>>>>                |          |          |          |           --43.20%--free_frozen_page_commit
>>>>                |          |          |          |                     |
>>>>                |          |          |          |                      --35.37%--_raw_spin_unlock_irqrestore
>>>>                |          |          |          |
>>>>                |          |          |          |--11.53%--_raw_spin_trylock
>>>>                |          |          |          |
>>>>                |          |          |          |--8.19%--__preempt_count_dec_and_test
>>>>                |          |          |          |
>>>>                |          |          |          |--5.64%--_raw_spin_unlock
>>>>                |          |          |          |
>>>>                |          |          |          |--2.37%--__get_pfnblock_flags_mask.isra.0
>>>>                |          |          |          |
>>>>                |          |          |           --1.07%--free_frozen_page_commit
>>>>                |          |          |
>>>>                |          |           --1.54%--__free_frozen_pages
>>>>                |          |
>>>>                |           --0.77%--___free_pages
>>>>                |
>>>>                 --0.98%--0xffffb33c12a26078
>>>>                           alloc_pages_noprof
>>>>
>>>> Perf trace after:
>>>>
>>>>      8.42%     2.90%  kthreadd         [kernel.kallsyms]         [k] __free_contig_range
>>>>             |
>>>>             |--5.52%--__free_contig_range
>>>>             |          |
>>>>             |          |--5.00%--free_prepared_contig_range
>>>>             |          |          |
>>>>             |          |          |--1.43%--__free_frozen_pages
>>>>             |          |          |          |
>>>>             |          |          |           --0.51%--free_frozen_page_commit
>>>>             |          |          |
>>>>             |          |          |--1.08%--_raw_spin_trylock
>>>>             |          |          |
>>>>             |          |           --0.89%--_raw_spin_unlock
>>>>             |          |
>>>>             |           --0.52%--free_pages_prepare
>>>>             |
>>>>              --2.90%--ret_from_fork
>>>>                        kthread
>>>>                        0xffffae1c12abeaf8
>>>>                        0xffffae1c12abe7a0
>>>>                        |
>>>>                         --2.69%--vfree
>>>>                                   __free_contig_range
>>>>
>>>> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
>>>> Co-developed-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>>>> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>>>> ---
>>>> Changes since v2:
>>>> - Handle different possible section boundries in __free_contig_range()
>>>> - Drop the TODO
>>>> - Remove return value from __free_contig_range()
>>>> - Remove non-functional change from __free_pages_ok()
>>>>
>>>> Changes since v1:
>>>> - Rebase on mm-new
>>>> - Move FPI_PREPARED check inside __free_pages_prepare() now that
>>>>   fpi_flags are already being passed.
>>>> - Add todo (Zi Yan)
>>>> - Rerun benchmarks
>>>> - Convert VM_BUG_ON_PAGE() to VM_WARN_ON_ONCE()
>>>> - Rework order calculation in free_prepared_contig_range() and use
>>>>   MAX_PAGE_ORDER as high limit instead of pageblock_order as it must
>>>>   be up to internal __free_frozen_pages() how it frees them
>>>>
>>>> Made-with: Cursor
>>>> ---
>>>>  include/linux/gfp.h |  2 +
>>>>  mm/page_alloc.c     | 97 ++++++++++++++++++++++++++++++++++++++++++++-
>>>>  2 files changed, 97 insertions(+), 2 deletions(-)
>>>>
>>>
>>> <snip>
>>>
>>>> +
>>>> +/**
>>>> + * __free_contig_range - Free contiguous range of order-0 pages.
>>>> + * @pfn: Page frame number of the first page in the range.
>>>> + * @nr_pages: Number of pages to free.
>>>> + *
>>>> + * For each order-0 struct page in the physically contiguous range, put a
>>>> + * reference. Free any page who's reference count falls to zero. The
>>>> + * implementation is functionally equivalent to, but significantly faster than
>>>> + * calling __free_page() for each struct page in a loop.
>>>> + *
>>>> + * Memory allocated with alloc_pages(order>=1) then subsequently split to
>>>> + * order-0 with split_page() is an example of appropriate contiguous pages that
>>>> + * can be freed with this API.
>>>> + *
>>>> + * Context: May be called in interrupt context or while holding a normal
>>>> + * spinlock, but not in NMI context or while holding a raw spinlock.
>>>> + */
>>>> +void __free_contig_range(unsigned long pfn, unsigned long nr_pages)
>>>> +{
>>>> +	struct page *page = pfn_to_page(pfn);
>>>> +	struct page *start = NULL;
>>>> +	unsigned long start_sec;
>>>> +	unsigned long i;
>>>> +	bool can_free;
>>>> +
>>>> +	/*
>>>> +	 * Chunk the range into contiguous runs of pages for which the refcount
>>>> +	 * went to zero and for which free_pages_prepare() succeeded. If
>>>> +	 * free_pages_prepare() fails we consider the page to have been freed;
>>>> +	 * deliberately leak it.
>>>> +	 *
>>>> +	 * Code assumes contiguous PFNs have contiguous struct pages, but not
>>>> +	 * vice versa. Break batches at section boundaries since pages from
>>>> +	 * different sections must not be coalesced into a single high-order
>>>> +	 * block.
>>>> +	 */
>>>> +	for (i = 0; i < nr_pages; i++, page++) {
>>>> +		VM_WARN_ON_ONCE(PageHead(page));
>>>> +		VM_WARN_ON_ONCE(PageTail(page));
>>>> +
>>>> +		can_free = put_page_testzero(page);
>>>> +		if (can_free && !free_pages_prepare(page, 0))
>>>> +			can_free = false;
>>>> +
>>>> +		if (can_free && start &&
>>>> +		    memdesc_section(page->flags) != start_sec) {
>>>> +			free_prepared_contig_range(start, page - start);
>>>> +			start = page;
>>>> +			start_sec = memdesc_section(page->flags);
>>>> +		} else if (!can_free && start) {
>>>> +			free_prepared_contig_range(start, page - start);
>>>> +			start = NULL;
>>>> +		} else if (can_free && !start) {
>>>> +			start = page;
>>>> +			start_sec = memdesc_section(page->flags);
>>>> +		}
>>>> +	}
>>>
>>> It can be simplified to:
>>>
>>>         for (i = 0; i < nr_pages; i++, page++) {
>>>                 VM_WARN_ON_ONCE(PageHead(page));
>>>                 VM_WARN_ON_ONCE(PageTail(page));
>>>
>>>                 can_free = put_page_testzero(page) && free_pages_prepare(page, 0);
>>>
>>>                 if (!can_free) {
>>>                         if (start) {
>>>                                 free_prepared_contig_range(start, page - start);
>>>                                 start = NULL;
>>>                         }
>>>                         continue;
>>>                 }
>>>
>>>                 if (start && memdesc_section(page->flags) != start_sec) {
>>>                         free_prepared_contig_range(start, page - start);
>>>                         start = page;
>>>                         start_sec = memdesc_section(page->flags);
>>>                 } else if (!start) {
>>>                         start = page;
>>>                         start_sec = memdesc_section(page->flags);
>>>                 }
>>>         }
I'll simplify in the next version. Thanks.

>>>
>>> BTW, memdesc_section() returns 0 for !SECTION_IN_PAGE_FLAGS.
>>> Is pfn_to_section_nr() more robust?
>>
>> That's the whole trick: it's optimized out in that case. Linus proposed
>> that for num_pages_contiguous().
>>
>> The cover letter should likely refer to num_pages_contiguous() :)
I'll refer to num_pages_contiguous() as well.

> 
> Oh, I needed to refresh my memory on SPARSEMEM to remember
> !SECTION_IN_PAGE_FLAGS is for SPARSE_VMEMMAP and the contiguous PFNs vs
> contiguous struct page thing.
> 
> Now memdesc_section() makes sense to me. Thanks.
> 
> 
> Best Regards,
> Yan, Zi


