Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70DABCD3436
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 12:31:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D30D66B0088; Wed,  6 May 2026 08:31:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE28E6B008A; Wed,  6 May 2026 08:31:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA92F6B008C; Wed,  6 May 2026 08:31:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AA7BA6B0088
	for <linux-mm@kvack.org>; Wed,  6 May 2026 08:31:01 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C86A94021E
	for <linux-mm@kvack.org>; Wed,  6 May 2026 12:30:59 +0000 (UTC)
X-FDA: 84736929438.18.B2A2FD1
Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013070.outbound.protection.outlook.com [40.107.159.70])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7E6D42000E
	for <linux-mm@kvack.org>; Wed,  6 May 2026 12:30:55 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=PS1htCCc;
	dkim=pass header.d=arm.com header.s=selector1 header.b=PS1htCCc;
	spf=pass (imf13.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 40.107.159.70 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778070656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wfaxD1UQc4bG46414TckAW6eN5O7n6k7rUhamppdo/A=;
	b=DEuXKM1wah69YbUzwk74yhOuFfWetbhhxqNzj0el9jV0D1TzUHhfZkVSwIEqaN4kyoW2BC
	Un7hyO0ENsGbse/h4wCeP0fdE4QS5uMUcFk+/nJQ3S5/03KxgKCq0HB9kSrRFD9LvEqQW+
	SlTjCXX9fTRKvVjS0RAFH/YQhVdaeYA=
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1778070656; a=rsa-sha256;
	cv=pass;
	b=FlgZez8hGCSTD3oQq/79fPMI6azOECp5P7fi0bNhv1hwa6LgUwLzb8LFQFMQ3QGbI1TuyD
	YXoUN49u/bVkrUncX39zGa3suZokd5B62Tc3sJK0xYLvOHozuQyFKyn6h069gACaioDNAN
	NAnTtf1hUYZevG50iic59386TOLk4Bo=
ARC-Authentication-Results: i=3;
	imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=PS1htCCc;
	dkim=pass header.d=arm.com header.s=selector1 header.b=PS1htCCc;
	spf=pass (imf13.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 40.107.159.70 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=x2olF2H731bzLJX9o0/zT03+0Kxv7fJ0FNbfrtu6d2YctXcT5HZaIrWyLDROGBR4PCbmYubgfBhM1pa5UD7WBKRcc/Kydmv+zMGbTQ5J4Okd8czCt98M1fZ8urWSPjsvTIF3u1SSsNeG5w6A5la3+I6dujMBzFqxkF6kgRvmQxRksCyi1p4voSSxes5ei+H7rINdUpP+SGyyrIdK2gh+ooiOM7a/bM1b3ufsO41FaERweXHpzi1/Nj4YXBWzf3BkXV5JKqJhugImwudxoep0Ab4LGpEWWUG88tHKEAZZmTBgmcuLjh5Nhg7H8+MIEfirolcPi9hT0m9CwCch23YUpg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wfaxD1UQc4bG46414TckAW6eN5O7n6k7rUhamppdo/A=;
 b=rZ6rS2htGiIJ02SZ1zB9Xz+l29IdbCH3T92nU3JSFp2lB+/wN3XldaeJMvRFJvgaZTaJ92MLAeUm6KjW2QAVuVbqSHDlWTx1nW7C/WPRQytJuDOiem2kmTA2MyQInoVJzKrjFzYXzrcd1fRMi7EHa5zHHkaBili71hzX0klb236NMVUBVzq/D4tHIv60a7Gr/jT1aJsjZopNpEFzsB8cFTnDMejz1AlBdDVIeAKpjhJty31ei6bnVpbQawuw1zWSaHhdOLLWNwTN6/Luf/MCgOvvi+1KV1NOCL8IPE4hM5IIzsOy8pWKkj1HpFSfVkpF69K8fE9phjfUeFVVIez1vQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wfaxD1UQc4bG46414TckAW6eN5O7n6k7rUhamppdo/A=;
 b=PS1htCCctxQcw02gMHAMpoNw3LkMpLJkQa7oiWYhvYHJD8NVZ0qlBeCe/YXMc44aiwwrEegnDMDqClAiUk6NZRgeN7X4TMQvbvnYh0iY4xfvEc4e40F3zFa/LtOltKbS56mo3q1vWW0J4lkrLlPU2iTeop+5Y9XDcLmkDMaDqM0=
Received: from DUZPR01CA0273.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b9::14) by AS4PR08MB8167.eurprd08.prod.outlook.com
 (2603:10a6:20b:58e::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.27; Wed, 6 May
 2026 12:30:49 +0000
Received: from DB1PEPF000509F1.eurprd03.prod.outlook.com
 (2603:10a6:10:4b9:cafe::98) by DUZPR01CA0273.outlook.office365.com
 (2603:10a6:10:4b9::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9891.15 via Frontend Transport; Wed,
 6 May 2026 12:30:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509F1.mail.protection.outlook.com (10.167.242.75) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9870.22
 via Frontend Transport; Wed, 6 May 2026 12:30:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RIpz/NOU/fD3hvatYKpZKZfRwehOAYFbiuGEYPCtOzr9q0aNm/5xoc2Je6ZM2p1jXcwnywcNTyf6zlswr+vSy8NoHUj/XOWEGYKfZEFKGoFENPk7bTBunKUV4y+TgkzSwA2FBU6D4ZBM1vOpwDtays6uIST5pIjog5g7P6BF6vuZ7hqTOg6+ifNPPJSiQdFqrDZBt6qpB6dEllr1Ehlsrpri9Mxjbv7Hd1diws0FsUoXIePWGN8N7pGDKORvSZTiE8I9oCiUQpsNRYwJytzSsd1bGOmiftyeq8tMnJG1LxKWuiZIKmCY50vH/tqq+uVz0kz0Jq26R6whBwtHlwD6cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wfaxD1UQc4bG46414TckAW6eN5O7n6k7rUhamppdo/A=;
 b=c5QhwrQakiVpWCMvltvZYOh8JvWPQY1viwZwIV5uTicBgGwAR4atdPqnYl+ndevMgpGkWxxILIzChkiHk3YfGwAzm4i6de/NSNhETgtemK5ItaWCKwz+9D/GECzEwwg6n+lXfehnaW/a/uJwNihX8rpcZCLBiSQT1jzODsDxdhd9m0qDdZ0BQKcmlK43Gpkeb9DZF8AELLWnRdfcAO3+Bs5vycHsZy4652nbUO8cF6p0bDQSftan4rk91RNxng9BRZLuuHN54fzJ1roL8qZoLSUlr2qPzGZmMxnEHtygVNyKtJs1zZ6kZpkFnRIIC1CqvnvlNwzGMTArqt4xQasHsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wfaxD1UQc4bG46414TckAW6eN5O7n6k7rUhamppdo/A=;
 b=PS1htCCctxQcw02gMHAMpoNw3LkMpLJkQa7oiWYhvYHJD8NVZ0qlBeCe/YXMc44aiwwrEegnDMDqClAiUk6NZRgeN7X4TMQvbvnYh0iY4xfvEc4e40F3zFa/LtOltKbS56mo3q1vWW0J4lkrLlPU2iTeop+5Y9XDcLmkDMaDqM0=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com (2603:10a6:10:417::12)
 by VI0PR08MB10944.eurprd08.prod.outlook.com (2603:10a6:800:257::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.25; Wed, 6 May
 2026 12:29:41 +0000
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047]) by DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047%2]) with mapi id 15.20.9891.008; Wed, 6 May 2026
 12:29:40 +0000
Message-ID: <b9850f4e-6967-4998-88f0-b324c271cf38@arm.com>
Date: Wed, 6 May 2026 17:59:32 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 33/54] selftests/mm: gup_test: add setup of HugeTLB
 pages
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
 <20260428204240.1924129-34-rppt@kernel.org>
From: Sarthak Sharma <sarthak.sharma@arm.com>
Content-Language: en-US
In-Reply-To: <20260428204240.1924129-34-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0P287CA0015.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:d9::10) To DU0PR08MB9203.eurprd08.prod.outlook.com
 (2603:10a6:10:417::12)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU0PR08MB9203:EE_|VI0PR08MB10944:EE_|DB1PEPF000509F1:EE_|AS4PR08MB8167:EE_
X-MS-Office365-Filtering-Correlation-Id: 47f1c530-3cf4-44bf-fcef-08deab6b4df0
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|7416014|1800799024|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info-Original:
 meBgmqqjyBAjXyb5sTEwF307aUIlkd2Rl0xZPWklFgq3Hp11zb1S6uUwkJm4vTZLEYOPZocWg5wqQQsSbcYgZqoEkH2DuloFLYzRAmXo9Xpuj1iyGbVTDCI1EOAHeneJdhgj8TlX+1pJUe07gaoQVnpPi+OkAs59EaF8QMkvrYuCXs302DFb7XHaHpNSvOYWoUu+Fu07RgOfACRrTkrXE0iUiCBSisFXpPjbUya4S5g4b9fwLss+asrTerfWat2+BRvy6z7OYktbzwSqDetLtIJCOg6TdCAzhplHgir4OTwuLeESTNUwflsRB3eBdwmYY6G4tbZRjkN+y6e0e4dwaO+qmTj0QnaC4p8rPeX7LtIjI5ou5/4/8Bd756qztiIVgvgHBopzptUMwv9AGtz9agprmRin42Bb2wmYrcCPzH8ep6eGHHxstfyP5WcKs9YTawHKJk5UiPrPjvO9cD91Lteyo2BUaw2xi2fkonUkBXNtVKqVCBr8un+yM8XnHUc4f1IKmQ7wfSbi7m43I08h5MJVmSVvPkerdEPRJTClcTq+xGCEStp6B5mIzjqFHudjVosMMAzKVJWDJ5RjI/oE3WSV8m+SD7h/6K+wjjereBWItNZoz9UltSs89Vl/+8lEm697KEqgh7/7fR6O+0cJtIY+x62jv3dI8mFED7CP83xigisM++E4cQtZVlx3VRbk
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9203.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 ow/0jz7wnqyx5d0OIfIb1BfGQ4yvXt5u5o9WVzbjav9kphd19Icn+l35tr5IlcrP/X32bEHP1/1LT0Q1Bw5iLqeYqshjQtGlPTobkADgZCc5AX3sxvMN+E8FHz6guMAERtdfO0MsY2WmPQ8q4oaxUNrnYputDUD42+8ErIKqz9ov8Pi/YO0ucgXJy2+zWMqRIgSkJo6sH30AywtBo2bY42yGhjef2u6J6bU3Svlsq1F/e7fEmYGp8u/KPx3YDJ199aN6JhgNrXS3q3L6t6Yb8nCc7MksIDgAqaL/wzwfo6MacS230XLsq9hU27WCa82Xl9IvXVKFc1ybmAnH/vb49g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB10944
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509F1.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	7ad4d631-cadd-4e78-dc63-08deab6b2524
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|1800799024|35042699022|7416014|36860700016|14060799003|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	o5NfXCnGbzUvA2190Z7rgiHATwTL3dYtE15Vw6kDbjHXQH0L2x8FaNZH7GbZK1XoeaWlhVXOL2nFHiDjWCp5kCNccMpgxOpg1b7WI+BiKDhnLbIUaZrUX2FOmRu9ahVWTUBD516+Wq0bhlSrs8gZJB+2qwoTnxPgtbrCSrXDUOVWyKk+MXjq+tssg2uCEl3X/mvgz+yUSEDcl9WoIwCiaErBI0NRyDo9ccGlMyYDjAmzVZAdjRF+S14jvUbQCnaYNo9EGdF4zYpwZDhUpcgzH/eRwzVV0sa6WUdfvw+m0msZLReJXYQEy2cRj/3d/SFHTQHCBygSGdWWma0GZh8aL/WoZIC3g2U5NcNt9pQrg97F8IzZJqqXzny8/AvaDa7C1JEAzLQLgCMfAlO3DowN3yA/2C83ctQGCSZadA1dGBj9DDjpFo7xEOhob97IkEB1wmP/WE5NLZPsmB2O3oUXPnJSvX007Z1McUusGgPl8/AJgJICR49Qqn5HdlGUxuTUO0InMOSyO24w6opdGTQZGXMXw4Pnvmk0wq+GpU1m2q7yZAwfkPOCblp4W8N6F0PRXbU6M2bEzCPv7hFi8lkXLqtXYW1yAEDMmsoLrIZcDLKIxqKy7I4UUoVMxejkpRnbTUHa6rfXd+cKYjSr1fSASKJUwlf56BxmUJnJOyZvSCsmaCZ1wK1d0i2o5PAEO9cJsYx7DAbhcdFcd49in3JHLyMevdQ4IpzLXMgwxE7Smis=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(1800799024)(35042699022)(7416014)(36860700016)(14060799003)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	IHiMuR3LeDMLdc7NcHGbxSzaMOyGr7RQeroOnXhn1EfQ1B6+gZDLGblGug6Ov7q6/vlkGWMaziqHg5R0Umj2Lzfjwkzh472vuj3CkLliGWLOyBxBbTPTjh7thTnyB43m117CdnPcJjmf7WJ1fMtu5lVhYf8h+B6jHFmLMOlzowIdNkPjgSsAt4eI7rt0t93gSx+RML5zC3nn6JgoqFChXYRuRbVYKFpMjS2M51nYhYX1cIKB+yTrYuY/eulxjbxkVxjfFI8bGhywBcVwVrpKiO0VpdMEHTcRyKUAfFf1t+iy+1QuQ8ZF/GZ7nBuoAcy6NkxvLhkJQ7P+YkZM1otUaYLEIKC3D3UIU5H1R5SXsDDYtpr0GP9TkhVFfEHOPY+HKhJnLfRcQHtClufYJRFbv/vtCQ1RKpyjUcsDn+LG1z/BgM6ecBvRJuAao7R5e93A
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2026 12:30:48.9679
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 47f1c530-3cf4-44bf-fcef-08deab6b4df0
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509F1.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR08MB8167
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7E6D42000E
X-Rspam-User: 
X-Stat-Signature: urgryeauogqpaue7qizxnob78nj9o9af
X-HE-Tag: 1778070655-70595
X-HE-Meta: U2FsdGVkX18nq6VXBoAt/W4fMKbnOR799XwSSfPqvQQ68y9+ZpuMPt3vsfcCWm/DN8etfyMubxLm867mtjPn55Tm5KUqj5m8blNApOBVuXK+zTKWWpZO4Bf8AAV1WOBgbN9xxcN3TwzRE60Y7txnjyUCEstZzkXd3JlO77YbWoPl/QjPOl3V1LB9vJKDUNVeCea6qkErptM7Tzpxvvc2lE5mxyWFFnMqW1ZRjD/VQwdptSi5z28BFnYyaDL1mten0j6uqO/QGKm/y5leo0rFAe4ytyrHB7FiJH8VdFwGoEZi6hL3khzZ2oeY6GQan48mvxoNg2numf3zV0ebEDh1cnhyHkDKPgCAZ91s9vCmw8kLdC8kDNXMpauD7AnzqThSRQTx9kY1SBHL4kn+rjMn67Pi+2eTm0fp2gQp+1BMStT7sOhF2fCXPnxpOj/h4s+Pjt7z79Ly9PhVkiDvv/k/r2UtGDYG+0kmO0thOWBQVAh8R5OXxboS2Ed7Vqc1M9dusRj138kFgVOOWoKUK3ZGpHpnd3I2HN/uzr1Yq1pvblrdAw1kkwFOMLoiFxJL9zCwIdt5BcXDEcJfyU+iFS2WBqF/qv3rOBFcRyDqBBYQ3bdraeCz/FCfhRNJAfksLuvKjGkvKAmPSE8guUNPURrMTdB9p5NFIGXSnYpx9cM/UzUqJySzkm43bizPhk+N2lfSnBGmkqldn5FOq7cdSvhkOBFxM+XsOoDxOIf9zGTmYy1jtMeqVErePnv5qF2Ya2BZhvmu2SWgKSxDWrfiaqmIve2rUaupzCbufSnuZY0OQR67ipGQ1pApbXR1YA4HsDuSDR7fOwyYyLTHG55Ih4fB6rDYtQJz7t4us9r7hfGVLj9TUoMDTyJq0qh/WLVslZRoB9jeXyrBxtbCs39ZcLcr0WQh8lVpjJRJrkYEt1GhHyPj4/rsajB33PylxE1aWE/j249E2u1ofnh+IkxmtxE
 R8kht+YU
 zlwc4ef4Ee+jrcPXjXvIs54vB8KjVQjY2D2xqEkCpRZCqO8YFTnQrT+XOSl8KyM3jVd6SbeQFEJW3d31uto7UaYq563n2JIg/SdQxl9XEFXGw+PCr+Yi+o0tqI2GJPR2zNSusgh5hVzmSTlH5V4a8kTmPcQ5xi92xRlbuWaXe4CmsxjkFijj0vDatrKlvTnbsENAfRrCH2KN7KRUdAYyvfx7wILvLZ/zX2uje4P0U+DEinD8S9Z49Cdck0g/RklxarIhctXOwKfZzjGLCgr/BBhdR/zn8sIKeZPHpjfJrAppBa1YqLvl43XFoi/iAJFjh6Wvh5ZuLUHZF1NpzI17XpPTYrCa27jhQo8JMxyP2cpijo/vqL84IiL9kd1Yx/+rWCqmqxyf2q9V3Bg4GEAMfuB9OYNUb28p6k+e4TFVPAAvHOQHesmXoGcbUhNsFufW3cH91Qq+CSqqvznhi6Ih5HWj9lWT/oR2kbeUGUPPWNVOMpWNYYBe7WqU7XH8kxd/5qgXMTh05AtWtUu6q4qAhuM1gNIi3ar2KWzLOcPP5HQUnmOrtqNbQyu0ChOmZUNF+G9WDt4zI3qUp7whvcuA1kZH4Ps9Q78P0nzaYfwVx+sieC1w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/29/26 2:12 AM, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> gup_test fails to run HugeTLB tests if there are no free huge pages
> prepared by a wrapper script.
> 
> Add setup of HugeTLB pages to the test and make sure that the
> original settings are restored on the test exit.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

I ran the test with the -H flag before and after applying the patch.
Before the patch, the test bailed out with "mmap: Cannot allocate
memory". After the patch, it automatically detects and allocates
hugepages and the test passes successfully.

Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>

> ---
>  tools/testing/selftests/mm/gup_test.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/tools/testing/selftests/mm/gup_test.c b/tools/testing/selftests/mm/gup_test.c
> index fb8f9ae49efa..ddd239a69881 100644
> --- a/tools/testing/selftests/mm/gup_test.c
> +++ b/tools/testing/selftests/mm/gup_test.c
> @@ -14,6 +14,7 @@
>  #include <mm/gup_test.h>
>  #include "kselftest.h"
>  #include "vm_util.h"
> +#include "hugepage_settings.h"
>  
>  #define MB (1UL << 20)
>  
> @@ -94,6 +95,7 @@ int main(int argc, char **argv)
>  	int filed, i, opt, nr_pages = 1, thp = -1, write = 1, nthreads = 1, ret;
>  	int flags = MAP_PRIVATE;
>  	char *file = "/dev/zero";
> +	bool hugetlb = false;
>  	pthread_t *tid;
>  	char *p;
>  
> @@ -168,6 +170,7 @@ int main(int argc, char **argv)
>  			break;
>  		case 'H':
>  			flags |= (MAP_HUGETLB | MAP_ANONYMOUS);
> +			hugetlb = true;
>  			break;
>  		default:
>  			ksft_exit_fail_msg("Wrong argument\n");
> @@ -199,6 +202,15 @@ int main(int argc, char **argv)
>  	}
>  
>  	ksft_print_header();
> +
> +	if (hugetlb) {
> +		unsigned long hp_size = default_huge_page_size();
> +
> +		size = (size + hp_size - 1) & ~(hp_size - 1);
> +		if (!hugetlb_setup_default(size / hp_size))
> +			ksft_exit_skip("Not enough huge pages\n");
> +	}
> +
>  	ksft_set_plan(nthreads);
>  
>  	filed = open(file, O_RDWR|O_CREAT, 0664);


