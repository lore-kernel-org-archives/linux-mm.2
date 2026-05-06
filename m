Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11440CD342C
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 09:16:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 508206B0092; Wed,  6 May 2026 05:16:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B89D6B0093; Wed,  6 May 2026 05:16:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 381066B0095; Wed,  6 May 2026 05:16:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 25AC56B0092
	for <linux-mm@kvack.org>; Wed,  6 May 2026 05:16:24 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C8C281A078A
	for <linux-mm@kvack.org>; Wed,  6 May 2026 09:16:23 +0000 (UTC)
X-FDA: 84736439046.26.D862AC4
Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013059.outbound.protection.outlook.com [40.107.162.59])
	by imf03.hostedemail.com (Postfix) with ESMTP id E268220005
	for <linux-mm@kvack.org>; Wed,  6 May 2026 09:16:19 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=E1yHwZYu;
	dkim=pass header.d=arm.com header.s=selector1 header.b=E1yHwZYu;
	spf=pass (imf03.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 40.107.162.59 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778058980;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IZcSTCqCSqlO5C+kcwYlOanBClmSRbE8fQRJhP5zoWU=;
	b=aButjMJFhZUdcTI+SQ6KuYEMDciBMj2AwjFOl9uW6qJPQZUIpAsvkF85l5ns5ah+cYrFGe
	HXIdZd2J3cYguBIaaD4qLMA4qwMAYmgWCmDCg8ha1kSB/Of8gVfn5+ptirMSOXqn4WKBpB
	yh8zGsIDqBkRbNGj9gery9o4eFGK1fY=
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1778058980; a=rsa-sha256;
	cv=pass;
	b=AfEfZHFuIWrbNye+w128W8ZaXTRJkFQWqZrUKUhmaf/4LoRnBmSuzxUp+wV4RkW9JUIfME
	G5vRg6dUT6O8K98HdNb25h/3zpMW/YXwbuEywyrhYH9uEa6CSj7MgdAqOL4bAu1FPfOK06
	ry27Hmb2zC9wGmCPaCYBmUNlhKnkfV8=
ARC-Authentication-Results: i=3;
	imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=E1yHwZYu;
	dkim=pass header.d=arm.com header.s=selector1 header.b=E1yHwZYu;
	spf=pass (imf03.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 40.107.162.59 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=F2eGjXM7gIfKgzGdMtS0ksaE2e4lEz2WsNJOglFESryGj/zCMhY+Yn3PK5ZZ/lMQUvxsCvyXfl0oUwqYcA5wcwSYvXxADHF24Q6lsZwdKgWaIKaINTFZh+LoIype4vJOWz83LsZwzwKNIWekI0Y/H9avlwfJs0YReBRbisdpblCy4F5n8Rr4L9SWWtC4nAB7EO3FRtqc3lMPU6eB+/nO4E3Nf7R16O7hA2mqj/T5L2Wmmat2YnAnHTyneKVfve0cHXCArsEvD5Lc6eMmHE/FGubh5qxRH7VNzoGItBq/Q4bshlh3f2bf7m2K+/OjQJuslqwqunph9UrhMEko2pyMpA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IZcSTCqCSqlO5C+kcwYlOanBClmSRbE8fQRJhP5zoWU=;
 b=argvM39g86SBvvNAbJhJluLG/9I3ZYoPZa4rEL2/wgyO42/cSxzKKaSQ1cGMTPube4OrhYOnVJHU5DHon5hRTXON0ipGn/2gjSD7KgEWGmhPpkJyhIo4i4cuoVDckHbHSgk4BM1SP0Ah5tMVFA3UhaqX1f6tmExfvZJY1l6RDQuaDq44SYWmSCjs1a4U4C8Zdd1UAorK53qnjvOe5+MFNnlDYMGIKWB5dwyp9h6adQQ0q1TaGE5fHGu/xyrvS3HCDf9WPdqeLtCB4EZGUiulWTzivzvvm9eg9ju4ZchTNRrI+CGzAAJx3b7FaDqk7Pjfpx2nDvOLTarB45t7CEnldw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IZcSTCqCSqlO5C+kcwYlOanBClmSRbE8fQRJhP5zoWU=;
 b=E1yHwZYuRAAm3WnyKjhAEzAbo2GAyyO3tUK6U7kuOO4NQgzt4eq8bk6Weh42gcviHKhvJmxUdwEYGQJ9G0gxdmdhS5+hbooJG4kPC0OJBvigy5pqC74Sa3Pp6Hoa8/PD02gHo9Lg+PcgPeEwCBbJqN/GdfBh8OEcrddQ2kz++Hs=
Received: from AM6P192CA0016.EURP192.PROD.OUTLOOK.COM (2603:10a6:209:83::29)
 by AMCPR08MB11969.eurprd08.prod.outlook.com (2603:10a6:20b:76d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.15; Wed, 6 May
 2026 09:16:12 +0000
Received: from AM4PEPF00027A5D.eurprd04.prod.outlook.com
 (2603:10a6:209:83:cafe::3) by AM6P192CA0016.outlook.office365.com
 (2603:10a6:209:83::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9891.15 via Frontend Transport; Wed,
 6 May 2026 09:16:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00027A5D.mail.protection.outlook.com (10.167.16.69) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9891.9
 via Frontend Transport; Wed, 6 May 2026 09:16:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SH1ipA+Zzwt8aX1eB/SfLZ0udStdIVgbgZc6eIQXT6soQ5an8C3Sf8K1dd/yDqnTwY5Vb4CdNEzHv9zJtzDNBCheqeusxfTUHaVW+DZtT4ZUJZCdnv7F9vmq0FhiGguI7cvsxTRN7tfZ5DgNqX9UTiRkPvLgh9dWbpe+KmnCiJS/5PWwsR1E6kkPu5rqFaitN//hlGDwlgm33VnokS84x4qHzaXTnz/MRFB4epFdjVgms+hyHgPdmXsabShJFbOkpcc6928ze7osulhQYeZF065k35NXiO7d5BnXOgHkL4pRhOEqHhB7YNFCckGa3hLTvEaDp+VWONva2xwUBrOdDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IZcSTCqCSqlO5C+kcwYlOanBClmSRbE8fQRJhP5zoWU=;
 b=vs1FfLHY+nBcLVqxOMSu8askibxvuykUNwLp390wIveksPQCYSzT6l4LYgm+CGs1ZKKFWz6n/j+BBGqJiJD5M3edIPhXgpGWBmSPjbQ2B9Sbc67awVt0gThLOMYj4V1vGv26/QzeMW/e8uBoelVApORqgxYnBnZX1CWChrYysyb9MJlWSQuYIqeJy8DRmw0S5Nc6JHHM4b+GPc/dTR+wiJdWhrbEI1r+oj7BKU+NJ9iCP36kNM0fPMWQPARFo8mOqyHdv2PJma/QBOlABSFjLbCFlD7GXGFxsLQJgX1/s6P/au2LuNqWPDLFSvytg7vVMwkpCfPA/51gtEVoq8+PWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IZcSTCqCSqlO5C+kcwYlOanBClmSRbE8fQRJhP5zoWU=;
 b=E1yHwZYuRAAm3WnyKjhAEzAbo2GAyyO3tUK6U7kuOO4NQgzt4eq8bk6Weh42gcviHKhvJmxUdwEYGQJ9G0gxdmdhS5+hbooJG4kPC0OJBvigy5pqC74Sa3Pp6Hoa8/PD02gHo9Lg+PcgPeEwCBbJqN/GdfBh8OEcrddQ2kz++Hs=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com (2603:10a6:10:417::12)
 by AS2PR08MB10227.eurprd08.prod.outlook.com (2603:10a6:20b:647::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.15; Wed, 6 May
 2026 09:15:07 +0000
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047]) by DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047%2]) with mapi id 15.20.9891.008; Wed, 6 May 2026
 09:15:07 +0000
Message-ID: <9ecc4348-5d5c-457c-a83c-f7297c3ee5bc@arm.com>
Date: Wed, 6 May 2026 14:44:58 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 23/54] selftests/mm: move HugeTLB helpers to
 hugepage_settings
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
 <20260428204240.1924129-24-rppt@kernel.org>
From: Sarthak Sharma <sarthak.sharma@arm.com>
Content-Language: en-US
In-Reply-To: <20260428204240.1924129-24-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5P287CA0176.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:1af::17) To AS2PR08MB9200.eurprd08.prod.outlook.com
 (2603:10a6:20b:59f::9)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU0PR08MB9203:EE_|AS2PR08MB10227:EE_|AM4PEPF00027A5D:EE_|AMCPR08MB11969:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a42cd9c-d1be-42aa-8337-08deab501e16
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|7416014|376014|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 0SnOywG74OVu4Cc1asnClhZoIljb6Wu2jPG+VOCGT6wDUqlbq6WXjGZQ79MidW424tbwSDqYrdQwv/1Q3HcGXTqcOnLnkqqJywJH6AeUCfCig1xXcLUmKnu9/rRe4dRdoIVH/4elBXrpl2FNwo7tWn1IYkwZw4L0zxH7hmt4T/jm1G6UHPLUy1FLXt47puNiFjKcALms/oziKWGsLOL1GMyPA7eG2z81B5q+3P0LfoJHJAx+YeOG+gxFuqTapinKdJzbc0UoRiK3ZL4RLVxxbGIq3mzHch2L8zrEWa5YlO+pmEpWY6YMHuLjfeuNBaMgpujaMmSCVY/OiuhNVxCNAu5kuTjeq1jkRoLA4UjgER1XiKkkSTyRqhNYeWQdWTr2BoSi93T0zXzS56/kUJwts2aYXweh+Q29E7vIdrgFxm5uHiD2m1aXkS8SZpTzBWY6Gara8gOXH3plAYzNvuszjtwYZWxcwKJWqMwzlZ0X8fGa+HRTplnc1vmeXuRP1Wtnsv5ALWcOlgNW/LXLR+f03edeoMNwtFHzbRN4mEQZPgObQ6AhlQvPJXEJcUIO8TP9WYzbb+153XzN2ikpEeDqOLNNmLSb2WXj5eQwZHxqL556S5qQCxUaFnZ0UIhGDrgErfe6N0lL2nEmnqTkjp8x/mgDtZtq2ZH3ADuEivMepqv5wUBVcyMip1BYd2TY3mZz
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9203.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 scruIK2ToUHonZB7DD9VeXLv9mtSqA3j0y5TeiZvZs8PvqruYLjmHdZ21lUXl5hKssWLym6u0sP1a88QQ2uegBB+EDjyxZ1t9/fqdQoXkdSY3F7SvFayLRoM4fg5d4VOiehjPJy4pCwXidFedWXMkoyUEIlOaTLTPmKPAneX6Enkr7M5F9M0izg5rM+b50y1E+wHI8icVX2k9JnpDl01l751m0y3udEsPtOvpP6H5I9yQZ4muQANbKtLf8/AFbbNqdxVi8kl74XNySuvoE7O3gLxCJPY8ZQuiOWk/EepWl1CPkn3vPYtfY1DI1hbBG711VNJZJtyTXEs6qohXJAMyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB10227
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00027A5D.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	e0520efb-7f80-444e-36e8-08deab4ff6d0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|82310400026|7416014|36860700016|376014|1800799024|14060799003|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	+k/IGyhd1STW9RaUM4ShgIAL6OR/2dtpor2MnuZ1caxoP+OT9IRwdTiM8DnYfQOIJ1gpPuusoIuAdAD5k+FjD8E5kwKxSGWbhsMI/0jJVO/PVFFxEXo8oBT0D+Wsj9jD8LlHqC2LWmwi2d8xmU+TvTH+5km6muaPKhSaC/8IbP9zfTtaWTLoNdZNZ5CP2zJ2txBL0X70pTnRx8pLZhmvRY2+euvDqgHMK1fGdMrzwyHcwngxMH95XR6bhVIO/Kyn4dQd05wfXK5J+zq+NVGbQbcpaIyy/85Wi4hzjytyOW2+RkE+7XnEcRQyu2vbcDM6rlFfy39iyWPdRCDfwdBbLLFfVz32SjYF1y93P7U6IeQVLDCKxHfrUPGa34sxpr/DQOmS/LyX+CCn6i0V3B9cNnY7b9kOUA1+bgoYAWGrVcoBNzQoo4NR/oNwvYBBxiimeMFmnklX2klNjozR07Y4smeyMvliyv5osLapKwLZxXkOBKzRZ6O3ilujYIV6mFWo6kOaC+2/nB5hTPlL91HN1wDfuyNOn/vaprqO3oC5CnLv2Bm9g/g3NL8rsXr9YYGCg3CKVwHBDIQRLHZDPZH7ykmJbr+T/AXiDX3WnB+x5I1BpKaDhLdTs+oLR+QuZhXC8cAbokEUkYATY8SJ/yG0YwWnA4E2xZS5LmecA1iqlDESPoYnI7C6rhdDGoF308buW3hLHPsVCJvS9UIRpxsRvrrNg6p6SZ7sGHK05jjEtFU=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(82310400026)(7416014)(36860700016)(376014)(1800799024)(14060799003)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	X6t4dyl5LuiTizP/QSvFicjSiJMQBT9GIu0Q7c5dKY0RRROoLQyPB/0Ktw+tl9kXT5rO9lIIsi2TRs3UcDOJH2RwKvg+LN0j12NLAVo/fyYbg4J2Tw+mKttyA3u0GjRc86dra3fWecKap4vj8Mh/9mnjMe5JiOlfN1JYs/rF+OB6pAiysJhdlz4RcpRC2ca6mUfaiKJ6OBPw8sHJaY+G1xZ+tXa/kKdcN1LNBRrSITwgOH77caBvbckNVb2uze2Tg/93V6iJNGa6egAUgPrQ7bWUQF+eqMRf77bBZ7f0PPX/9JW65oTIHuOu+FOvsCl6BIMlHaPZPCY2fSWOSrSOCF6XsS0bEwTQLNJKFap+ThRtPI/fcduu+H4VdTNdNRuhf476RMkZdnldyAvJ/pYArcF+aqRujqsqZMkml9QZ9wJwzTgoc1Xnu1ZnyOOBqIvW
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2026 09:16:12.2673
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a42cd9c-d1be-42aa-8337-08deab501e16
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00027A5D.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AMCPR08MB11969
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E268220005
X-Stat-Signature: 1b4giwsiaimrn7s1iapp4nxeor5ttgqi
X-Rspam-User: 
X-HE-Tag: 1778058979-528730
X-HE-Meta: U2FsdGVkX18dHCAVTd3cmvXuWgpi0dCAHvu9CyFtjdL4YvzRMCTRKbSJvrKcdqhBG5lSOu6yvq9ZMZv6r15p9YhfJ626ju49jZTdKoUG6p27sVMbJae5Zex8Y4RHxn8nC8yggDAvay3pGP4xhvjkeU4eUlqpTGgUkBlqKB50y8B34zMiAayJ258FFOSaF+FJr2W5WQCCgHWpv/aZBvRIKWjs6BUdgbxnVt1lYdpVax3HX+hSZnmdJxuRRGMWR25hO1w8RNhhaX2gIA2mGYUJtOyMv3WWoBdDE2WBf1+gi0GA18ElmLb+g2X5pbhWIWyljCPS+vL+MUIigBxoaC6qmINZ4jOnbOY/y1IwKLXaINeXPoH48i1BoyTgTb2CPj6bOE623oSqRtywA9O0fQE9Gq12VU2OShHPHPqasYEgXF5AawAqh62kWrQYX0/Amy/CBD2cRzys1qxsOIiOYpeL0cg+3l2lnEy2MW/Gdh4sBy6onJKMF7ThtN33Q+8C2Th9uBVKTwFeRqf4i0IBTXw3r0JhbTatzpnjH15kXUtTra5Il+UxT/6Od/JjjMa8EKDoCad01lfeicHk4VXMesVpCaxCBwikcG5AkSCLiFKqzFvKzwYXJkCVwyYnVAfjCtsbyfyHb4qo3Qb1l0kqZBomNaSdG2m21VJcHHo6Amhc6Ry9kLvmxld0Zuz9wBr+F76mbrMFqepTAc/tUx0aTbkWVtNNXD1mrT4PoDkJGcHSglUb8wtA4PQ8Za1BpgI3dZ6vAiVgNr49Jq4OhqzGjowERXW9cii3pAH+LgLCP2+4NdtLL+xBCYa6HconX3F6AZoY3Ka3O/9lRbneN4XHgwsHbPe98kOjHudQAkCXdx3WaMqTPFg3MHCYlCI50ZJNZMJm5orCUG7TMEJ14siNiapje55wim/+ZV8cU1Yi6AJqycbsKtZxc0dOCOUUVEGFEKuf5/5Ue7Emt8M1UPnrwkB
 mnnfKpHx
 I+0RKddU2qF+emqMUyF1FEAHmCR0CmkAoFVArWJtSHBjONKpAKWrF40/oYD8QwmdAVD0q+2hNTOnsCzd5zQaX2MJcfTYEwtF7gK4rkuPJzzf0oGMT7TNolaqf5toNEsk+hn0d2JS6CNKxJzEDTOIrl2f0huKsaOLlK5haTkUblx7wUSNLuqwhUE9SuueS4ODTbuNIiRL0TXDeG3QyjanNmKRkNIl8pnrxSW0vao0sQTg36BQ9Uo6deLdy9K+6IKR50jSRMXIDiS49OwhWRICAGmrnbdJdIMjaX1+Ku9Joy1EVgeRQU7Isb9mDvfXn3CsKAezWIyDiJKmljXzbZ5izMzghLq0tBJr4yvtl5FeRaIAscIYyKB2Wsmdm5trj7X6qGiozhNGigjcRb2F8qRUhWM5snx60VHB5B/lXpXzso6sotBkfltwNo50yNQqR70WeFc74i4+JTckZ5H7KPDmR0t8+Dl9h7PcD+26ra5ym3xswQvapb/21L8229/SGOj/wEGgRUq/Nh4oVDllLrkyVZkJbnzpMWP5w9Z3gjoCw8TLb1MZOVIF1lzWBpVr9xWEV3BHnGEdJyqZF+3JsKbSMzZE/YV5KdIugCvM5bJH6XR8nku4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/29/26 2:12 AM, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Move library functions that abstract HugeTLB /proc and /sysfs access
> from vm_util to hugepage_settings.
> 
> This will help creating common helpers that save and restore HugeTLB and
> THP settings.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Looks good to me.

Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>

> ---
>  tools/testing/selftests/mm/gup_longterm.c     |  1 +
>  tools/testing/selftests/mm/hmm-tests.c        |  2 +-
>  .../testing/selftests/mm/hugepage_settings.c  | 68 +++++++++++++++++++
>  .../testing/selftests/mm/hugepage_settings.h  |  8 +++
>  tools/testing/selftests/mm/hugetlb-madvise.c  |  1 +
>  tools/testing/selftests/mm/hugetlb-mmap.c     |  1 +
>  tools/testing/selftests/mm/hugetlb-vmemmap.c  |  1 +
>  tools/testing/selftests/mm/hugetlb_dio.c      |  1 +
>  .../selftests/mm/hugetlb_fault_after_madv.c   |  1 +
>  .../selftests/mm/hugetlb_madv_vs_map.c        |  1 +
>  tools/testing/selftests/mm/thuge-gen.c        |  1 +
>  tools/testing/selftests/mm/uffd-common.h      |  1 +
>  .../selftests/mm/va_high_addr_switch.c        |  1 +
>  tools/testing/selftests/mm/vm_util.c          | 66 ------------------
>  tools/testing/selftests/mm/vm_util.h          |  3 -
>  15 files changed, 87 insertions(+), 70 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/gup_longterm.c b/tools/testing/selftests/mm/gup_longterm.c
> index f61150d28eb2..ab4eaf4feb7c 100644
> --- a/tools/testing/selftests/mm/gup_longterm.c
> +++ b/tools/testing/selftests/mm/gup_longterm.c
> @@ -29,6 +29,7 @@
>  #include "../../../../mm/gup_test.h"
>  #include "kselftest.h"
>  #include "vm_util.h"
> +#include "hugepage_settings.h"
>  
>  static size_t pagesize;
>  static int nr_hugetlbsizes;
> diff --git a/tools/testing/selftests/mm/hmm-tests.c b/tools/testing/selftests/mm/hmm-tests.c
> index 788689497e92..409b11cad4bc 100644
> --- a/tools/testing/selftests/mm/hmm-tests.c
> +++ b/tools/testing/selftests/mm/hmm-tests.c
> @@ -11,6 +11,7 @@
>   */
>  
>  #include "kselftest_harness.h"
> +#include "hugepage_settings.h"
>  
>  #include <errno.h>
>  #include <fcntl.h>
> @@ -27,7 +28,6 @@
>  #include <sys/ioctl.h>
>  #include <sys/time.h>
>  
> -
>  /*
>   * This is a private UAPI to the kernel test module so it isn't exported
>   * in the usual include/uapi/... directory.
> diff --git a/tools/testing/selftests/mm/hugepage_settings.c b/tools/testing/selftests/mm/hugepage_settings.c
> index 87ecb309b430..ebaa621c45c6 100644
> --- a/tools/testing/selftests/mm/hugepage_settings.c
> +++ b/tools/testing/selftests/mm/hugepage_settings.c
> @@ -1,7 +1,9 @@
>  // SPDX-License-Identifier: GPL-2.0
> +#include <dirent.h>
>  #include <fcntl.h>
>  #include <limits.h>
>  #include <signal.h>
> +#include <stddef.h>
>  #include <stdio.h>
>  #include <stdlib.h>
>  #include <string.h>
> @@ -396,3 +398,69 @@ bool thp_is_enabled(void)
>  	/* THP is considered enabled if it's either "always" or "madvise" */
>  	return mode == 1 || mode == 3;
>  }
> +
> +int detect_hugetlb_page_sizes(size_t sizes[], int max)
> +{
> +	DIR *dir = opendir("/sys/kernel/mm/hugepages/");
> +	int count = 0;
> +
> +	if (!dir)
> +		return 0;
> +
> +	while (count < max) {
> +		struct dirent *entry = readdir(dir);
> +		size_t kb;
> +
> +		if (!entry)
> +			break;
> +		if (entry->d_type != DT_DIR)
> +			continue;
> +		if (sscanf(entry->d_name, "hugepages-%zukB", &kb) != 1)
> +			continue;
> +		sizes[count++] = kb * 1024;
> +		ksft_print_msg("[INFO] detected hugetlb page size: %zu KiB\n",
> +			       kb);
> +	}
> +	closedir(dir);
> +	return count;
> +}
> +
> +unsigned long default_huge_page_size(void)
> +{
> +	unsigned long hps = 0;
> +	char *line = NULL;
> +	size_t linelen = 0;
> +	FILE *f = fopen("/proc/meminfo", "r");
> +
> +	if (!f)
> +		return 0;
> +	while (getline(&line, &linelen, f) > 0) {
> +		if (sscanf(line, "Hugepagesize:       %lu kB", &hps) == 1) {
> +			hps <<= 10;
> +			break;
> +		}
> +	}
> +
> +	free(line);
> +	fclose(f);
> +	return hps;
> +}
> +
> +unsigned long get_free_hugepages(void)
> +{
> +	unsigned long fhp = 0;
> +	char *line = NULL;
> +	size_t linelen = 0;
> +	FILE *f = fopen("/proc/meminfo", "r");
> +
> +	if (!f)
> +		return fhp;
> +	while (getline(&line, &linelen, f) > 0) {
> +		if (sscanf(line, "HugePages_Free:      %lu", &fhp) == 1)
> +			break;
> +	}
> +
> +	free(line);
> +	fclose(f);
> +	return fhp;
> +}
> diff --git a/tools/testing/selftests/mm/hugepage_settings.h b/tools/testing/selftests/mm/hugepage_settings.h
> index 7748a9009191..320b97e768e8 100644
> --- a/tools/testing/selftests/mm/hugepage_settings.h
> +++ b/tools/testing/selftests/mm/hugepage_settings.h
> @@ -6,6 +6,8 @@
>  #include <stddef.h>
>  #include <stdint.h>
>  
> +/* Transparent Huge Pages (THP) */
> +
>  enum thp_enabled {
>  	THP_NEVER,
>  	THP_ALWAYS,
> @@ -86,4 +88,10 @@ unsigned long thp_shmem_supported_orders(void);
>  bool thp_available(void);
>  bool thp_is_enabled(void);
>  
> +/* HugeTLB */
> +
> +int detect_hugetlb_page_sizes(size_t sizes[], int max);
> +unsigned long default_huge_page_size(void);
> +unsigned long get_free_hugepages(void);
> +
>  #endif /* __THP_SETTINGS_H__ */
> diff --git a/tools/testing/selftests/mm/hugetlb-madvise.c b/tools/testing/selftests/mm/hugetlb-madvise.c
> index 4c6c346a3af5..316384d919db 100644
> --- a/tools/testing/selftests/mm/hugetlb-madvise.c
> +++ b/tools/testing/selftests/mm/hugetlb-madvise.c
> @@ -20,6 +20,7 @@
>  #include <fcntl.h>
>  #include "vm_util.h"
>  #include "kselftest.h"
> +#include "hugepage_settings.h"
>  
>  #define MIN_FREE_PAGES	20
>  #define NR_HUGE_PAGES	10	/* common number of pages to map/allocate */
> diff --git a/tools/testing/selftests/mm/hugetlb-mmap.c b/tools/testing/selftests/mm/hugetlb-mmap.c
> index 9f5ea8d6d656..031085cb7d17 100644
> --- a/tools/testing/selftests/mm/hugetlb-mmap.c
> +++ b/tools/testing/selftests/mm/hugetlb-mmap.c
> @@ -18,6 +18,7 @@
>  #include <linux/memfd.h>
>  #include "vm_util.h"
>  #include "kselftest.h"
> +#include "hugepage_settings.h"
>  
>  #define LENGTH (256UL*1024*1024)
>  #define PROTECTION (PROT_READ | PROT_WRITE)
> diff --git a/tools/testing/selftests/mm/hugetlb-vmemmap.c b/tools/testing/selftests/mm/hugetlb-vmemmap.c
> index 485a6978b40f..af5786bebfd1 100644
> --- a/tools/testing/selftests/mm/hugetlb-vmemmap.c
> +++ b/tools/testing/selftests/mm/hugetlb-vmemmap.c
> @@ -11,6 +11,7 @@
>  #include <sys/mman.h>
>  #include <fcntl.h>
>  #include "vm_util.h"
> +#include "hugepage_settings.h"
>  
>  #define PAGE_COMPOUND_HEAD	(1UL << 15)
>  #define PAGE_COMPOUND_TAIL	(1UL << 16)
> diff --git a/tools/testing/selftests/mm/hugetlb_dio.c b/tools/testing/selftests/mm/hugetlb_dio.c
> index 31a054fa8134..81e3f7bc8e76 100644
> --- a/tools/testing/selftests/mm/hugetlb_dio.c
> +++ b/tools/testing/selftests/mm/hugetlb_dio.c
> @@ -20,6 +20,7 @@
>  #include <sys/syscall.h>
>  #include "vm_util.h"
>  #include "kselftest.h"
> +#include "hugepage_settings.h"
>  
>  #ifndef STATX_DIOALIGN
>  #define STATX_DIOALIGN		0x00002000U
> diff --git a/tools/testing/selftests/mm/hugetlb_fault_after_madv.c b/tools/testing/selftests/mm/hugetlb_fault_after_madv.c
> index b4b257775b74..abc3904c5268 100644
> --- a/tools/testing/selftests/mm/hugetlb_fault_after_madv.c
> +++ b/tools/testing/selftests/mm/hugetlb_fault_after_madv.c
> @@ -10,6 +10,7 @@
>  
>  #include "vm_util.h"
>  #include "kselftest.h"
> +#include "hugepage_settings.h"
>  
>  #define INLOOP_ITER 100
>  
> diff --git a/tools/testing/selftests/mm/hugetlb_madv_vs_map.c b/tools/testing/selftests/mm/hugetlb_madv_vs_map.c
> index c7105c6d319b..ac60b4f18784 100644
> --- a/tools/testing/selftests/mm/hugetlb_madv_vs_map.c
> +++ b/tools/testing/selftests/mm/hugetlb_madv_vs_map.c
> @@ -25,6 +25,7 @@
>  #include <unistd.h>
>  
>  #include "vm_util.h"
> +#include "hugepage_settings.h"
>  
>  #define INLOOP_ITER 100
>  
> diff --git a/tools/testing/selftests/mm/thuge-gen.c b/tools/testing/selftests/mm/thuge-gen.c
> index 77813d34dcc2..1007bc8aa57c 100644
> --- a/tools/testing/selftests/mm/thuge-gen.c
> +++ b/tools/testing/selftests/mm/thuge-gen.c
> @@ -28,6 +28,7 @@
>  #include <string.h>
>  #include "vm_util.h"
>  #include "kselftest.h"
> +#include "hugepage_settings.h"
>  
>  #if !defined(MAP_HUGETLB)
>  #define MAP_HUGETLB	0x40000
> diff --git a/tools/testing/selftests/mm/uffd-common.h b/tools/testing/selftests/mm/uffd-common.h
> index 844a85ab31eb..6c5aca9cb63e 100644
> --- a/tools/testing/selftests/mm/uffd-common.h
> +++ b/tools/testing/selftests/mm/uffd-common.h
> @@ -37,6 +37,7 @@
>  
>  #include "kselftest.h"
>  #include "vm_util.h"
> +#include "hugepage_settings.h"
>  
>  #define UFFD_FLAGS	(O_CLOEXEC | O_NONBLOCK | UFFD_USER_MODE_ONLY)
>  
> diff --git a/tools/testing/selftests/mm/va_high_addr_switch.c b/tools/testing/selftests/mm/va_high_addr_switch.c
> index 5d38735ea60e..0b69bd4b901d 100644
> --- a/tools/testing/selftests/mm/va_high_addr_switch.c
> +++ b/tools/testing/selftests/mm/va_high_addr_switch.c
> @@ -11,6 +11,7 @@
>  
>  #include "vm_util.h"
>  #include "kselftest.h"
> +#include "hugepage_settings.h"
>  
>  /*
>   * The hint addr value is used to allocate addresses
> diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
> index db94564f4431..e62e2a473123 100644
> --- a/tools/testing/selftests/mm/vm_util.c
> +++ b/tools/testing/selftests/mm/vm_util.c
> @@ -291,53 +291,6 @@ int64_t allocate_transhuge(void *ptr, int pagemap_fd)
>  	return -1;
>  }
>  
> -unsigned long default_huge_page_size(void)
> -{
> -	unsigned long hps = 0;
> -	char *line = NULL;
> -	size_t linelen = 0;
> -	FILE *f = fopen("/proc/meminfo", "r");
> -
> -	if (!f)
> -		return 0;
> -	while (getline(&line, &linelen, f) > 0) {
> -		if (sscanf(line, "Hugepagesize:       %lu kB", &hps) == 1) {
> -			hps <<= 10;
> -			break;
> -		}
> -	}
> -
> -	free(line);
> -	fclose(f);
> -	return hps;
> -}
> -
> -int detect_hugetlb_page_sizes(size_t sizes[], int max)
> -{
> -	DIR *dir = opendir("/sys/kernel/mm/hugepages/");
> -	int count = 0;
> -
> -	if (!dir)
> -		return 0;
> -
> -	while (count < max) {
> -		struct dirent *entry = readdir(dir);
> -		size_t kb;
> -
> -		if (!entry)
> -			break;
> -		if (entry->d_type != DT_DIR)
> -			continue;
> -		if (sscanf(entry->d_name, "hugepages-%zukB", &kb) != 1)
> -			continue;
> -		sizes[count++] = kb * 1024;
> -		ksft_print_msg("[INFO] detected hugetlb page size: %zu KiB\n",
> -			       kb);
> -	}
> -	closedir(dir);
> -	return count;
> -}
> -
>  int pageflags_get(unsigned long pfn, int kpageflags_fd, uint64_t *flags)
>  {
>  	size_t count;
> @@ -396,25 +349,6 @@ int uffd_unregister(int uffd, void *addr, uint64_t len)
>  	return ret;
>  }
>  
> -unsigned long get_free_hugepages(void)
> -{
> -	unsigned long fhp = 0;
> -	char *line = NULL;
> -	size_t linelen = 0;
> -	FILE *f = fopen("/proc/meminfo", "r");
> -
> -	if (!f)
> -		return fhp;
> -	while (getline(&line, &linelen, f) > 0) {
> -		if (sscanf(line, "HugePages_Free:      %lu", &fhp) == 1)
> -			break;
> -	}
> -
> -	free(line);
> -	fclose(f);
> -	return fhp;
> -}
> -
>  static bool check_vmflag(void *addr, const char *flag)
>  {
>  	char buffer[MAX_LINE_LENGTH];
> diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
> index 1a07305ceff4..195bf2e26792 100644
> --- a/tools/testing/selftests/mm/vm_util.h
> +++ b/tools/testing/selftests/mm/vm_util.h
> @@ -94,8 +94,6 @@ bool check_huge_anon(void *addr, int nr_hpages, uint64_t hpage_size);
>  bool check_huge_file(void *addr, int nr_hpages, uint64_t hpage_size);
>  bool check_huge_shmem(void *addr, int nr_hpages, uint64_t hpage_size);
>  int64_t allocate_transhuge(void *ptr, int pagemap_fd);
> -unsigned long default_huge_page_size(void);
> -int detect_hugetlb_page_sizes(size_t sizes[], int max);
>  int pageflags_get(unsigned long pfn, int kpageflags_fd, uint64_t *flags);
>  
>  int uffd_register(int uffd, void *addr, uint64_t len,
> @@ -103,7 +101,6 @@ int uffd_register(int uffd, void *addr, uint64_t len,
>  int uffd_unregister(int uffd, void *addr, uint64_t len);
>  int uffd_register_with_ioctls(int uffd, void *addr, uint64_t len,
>  			      bool miss, bool wp, bool minor, uint64_t *ioctls);
> -unsigned long get_free_hugepages(void);
>  bool check_vmflag_io(void *addr);
>  bool check_vmflag_pfnmap(void *addr);
>  bool check_vmflag_guard(void *addr);


