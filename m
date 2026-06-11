Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B42CCD98CC
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 12:13:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEAF86B0005; Thu, 11 Jun 2026 08:13:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC1E46B0088; Thu, 11 Jun 2026 08:13:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B0DB6B008C; Thu, 11 Jun 2026 08:13:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 898856B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 08:13:52 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C4FF3120612
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 12:13:51 +0000 (UTC)
X-FDA: 84867523062.04.7CDBEB0
Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013046.outbound.protection.outlook.com [52.101.83.46])
	by imf16.hostedemail.com (Postfix) with ESMTP id BFD5C18000A
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 12:13:47 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=o9hfrAZT;
	dkim=pass header.d=arm.com header.s=selector1 header.b=o9hfrAZT;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf16.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.83.46 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781180028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=evSgxxnx6DpE6G7fJeW7KO4hh9I2r0jUtB8zE06hkwk=;
	b=2eUYSZNvAVsvJvX0FQiwyZ5zX9vYXLYJQ5j+bUCTBbaMLfyyTmgrrAnNxcRp/BB7vZhVa/
	fJpe+Td9pP8JIAGjbWsQqJ5l9uFf4hTtt24QPLVp/ZtbZGfl8B1Cw20ILPtE3gw+/5OL+i
	EkqR+NF6WTcuiQBHQ5QZqV+8gKvo70E=
ARC-Authentication-Results: i=3;
	imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=o9hfrAZT;
	dkim=pass header.d=arm.com header.s=selector1 header.b=o9hfrAZT;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf16.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.83.46 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=3; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781180028;
	b=XmG96pwvweHQCdqXf99HDDYKL8bui3aVUQfZBQIGiWq1tqqwt9bGeEEvlB6BV1p7hIu6gm
	jZoqa9ny3hHj+UdLZtcsHb0woFKtBKMpUqYGURaoqRtImzR8aisV6qbFPjnyDILcFspLGr
	YevxBxFcls4+rA9QOShOq4olx331sgo=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=TiWCKz0drovnqJoqQlPLznlKgCvYJw1apSz2fsk6YahYQz5OXBL9ASTPYODe+5e3aic2lF1xlR3+LwHppgN9o9oSafrjDRCEzDFyaMWdAMJUo1GeCx+d1Q1isFX1iv/j/N4lw4oW+uAYu9noT+Bc+RqkLb3u6529kXr8MKehik0iGBfGSFt1b/9VTPFrH2Ltd8y1uResemGF/Ac5bIunvhxGA6SjdHIG6p/pawwMcWc767xPbBtzNWhYJiHB+3unA5DLUB0RGfdonaNGbA9jKCXDciDafXBCLCHTwghZiIXc6IXA9KH+HA1z4dum0WQ1Oeg3ZHKipGv4bA6QZiB+2A==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=evSgxxnx6DpE6G7fJeW7KO4hh9I2r0jUtB8zE06hkwk=;
 b=W6hKRx0UahKWnmPmnLcn+KBOiG5v3h9anHFBLjE3flZTjjGXFhF5wf6SlJUkxUg2fFO+LcyNxwaWL0a3RekbJgDz95HTh/Yipb2AMG+rVbtLPM3F3bUZ05KfZ5loNUA6jEDG3hW7CiVUu4oWt6/Kkc5kKEiXtptOeYH5kqYSLCXu1xZhLKk+sFbjtDNijbwF1NG7TQpbcf0LNiyN9ww2GS+uChk4sUQ5cgbmkOYfMAiZVajFHa6q3Uw9SDF7IhZ1EHaWXMK37RKQjCD6YFm/3yIBwsgh34ByMjq4JxJY2h6Unp9wCed5MK2JKLoGev/R13dFjkBDbpeY1SGR/8znZA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=evSgxxnx6DpE6G7fJeW7KO4hh9I2r0jUtB8zE06hkwk=;
 b=o9hfrAZT2CkbNaZlvdI6qXsaD+s4IfmyVYYL+sRYxpLDhDPQNRfZFJlBfEu4cLT6cpvFpPoelMYsuzYxgmJDvGo7UA+DfrLblLXELWOcfv5nQl+I4cgU6kc1orh/hubzwM42wp/KPiXnBwCXOvsxiW2NMIP+yYL1zFMbM2nKP0U=
Received: from CWLP265CA0542.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:18d::13)
 by VI0PR08MB10992.eurprd08.prod.outlook.com (2603:10a6:800:257::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.18; Thu, 11 Jun
 2026 12:13:41 +0000
Received: from AM4PEPF00025F9A.EURPRD83.prod.outlook.com
 (2603:10a6:400:18d:cafe::86) by CWLP265CA0542.outlook.office365.com
 (2603:10a6:400:18d::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.113.13 via Frontend Transport; Thu,
 11 Jun 2026 12:13:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00025F9A.mail.protection.outlook.com (10.167.16.9) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.139.1 via
 Frontend Transport; Thu, 11 Jun 2026 12:13:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M4p2IT2EgEG+Nh8mz9Rdc0W5bEQCBl3UjSpBfLUgYYGLJTShWGLX+V7pRYBD/JWt2agpMOoCS/yjTIa2RDhm6GQaK4nIGOCDGbK/UuSmJAcvebiZrKyG+nc0fjQBZgUpgy6YiECwE8u5hkya3fg3VWBqBB10RbCu5qclR0U5swfQFif1tgO8wxW4m+8FKTJbhAzX6KnmWtoQMR0iueN4ZJd7nCTaB/+CSzZMzeJaYyFLkmowtFwk39634lwo4W6/BFKBlZN35GwvQd0c6F19ZT/VcuTH28nfLuAx4Jy29YjqXzyaQHBLnvpm/+ycQrQDOq/4uoGr6+1KNN41+tYWGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=evSgxxnx6DpE6G7fJeW7KO4hh9I2r0jUtB8zE06hkwk=;
 b=uzhadu0eSx339n+omDXYBYo47d9r933LV68ZxOhTZE90HMHSR0VjsYSvRGQr51gXpA76YvcHLX/VAUjFxM+qtpNh8iRo0VHmRAvNwj4jGZmvw1O+6pXT2Yxl+5CQOQBW90FkoINNtFvqzF+Ql9RwQgfABHtpaP+1cfrIj8hJM0o820NXhc19Z65X4NcxDbQOd0GcZg0X7wHncaXExqBFn/rc/B51E9W6BFKlvh/0kWmgUI0EKQUXyajTKwXx5Re0iYRXdYlASlqpFwMV8BVXXeoyMueWcGd2tEyQZTzJC6fk04D+Kz08pqkP2YOWTT3eNttC1vaQcDGVCYhhyvH/qQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=evSgxxnx6DpE6G7fJeW7KO4hh9I2r0jUtB8zE06hkwk=;
 b=o9hfrAZT2CkbNaZlvdI6qXsaD+s4IfmyVYYL+sRYxpLDhDPQNRfZFJlBfEu4cLT6cpvFpPoelMYsuzYxgmJDvGo7UA+DfrLblLXELWOcfv5nQl+I4cgU6kc1orh/hubzwM42wp/KPiXnBwCXOvsxiW2NMIP+yYL1zFMbM2nKP0U=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AS2PR08MB9200.eurprd08.prod.outlook.com (2603:10a6:20b:59f::9)
 by AS8PR08MB9622.eurprd08.prod.outlook.com (2603:10a6:20b:619::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.13; Thu, 11 Jun
 2026 12:13:16 +0000
Received: from AS2PR08MB9200.eurprd08.prod.outlook.com
 ([fe80::e16d:9c1a:8c8a:377d]) by AS2PR08MB9200.eurprd08.prod.outlook.com
 ([fe80::e16d:9c1a:8c8a:377d%5]) with mapi id 15.21.0092.016; Thu, 11 Jun 2026
 12:13:16 +0000
Message-ID: <df38064b-227d-45d8-87eb-6e30872e6a3f@arm.com>
Date: Thu, 11 Jun 2026 17:43:09 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests: mm: fix and speedup "droppable" test
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 "Jason A. Donenfeld" <Jason@zx2c4.com>,
 Anthony Yznaga <anthony.yznaga@oracle.com>, Mark Brown <broonie@kernel.org>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, Aishwarya TCV <Aishwarya.TCV@arm.com>
References: <20260611-droppable_test-v1-1-b6a73d99f658@kernel.org>
 <9afa4ff1-9749-4efa-8112-73fca1f25e8b@arm.com>
 <b2e63557-a0fa-409f-8a75-12d43257efb5@kernel.org>
From: Sarthak Sharma <sarthak.sharma@arm.com>
Content-Language: en-US
In-Reply-To: <b2e63557-a0fa-409f-8a75-12d43257efb5@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5P287CA0094.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:1d4::17) To AS2PR08MB9200.eurprd08.prod.outlook.com
 (2603:10a6:20b:59f::9)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	AS2PR08MB9200:EE_|AS8PR08MB9622:EE_|AM4PEPF00025F9A:EE_|VI0PR08MB10992:EE_
X-MS-Office365-Filtering-Correlation-Id: 7cd5ee09-4d50-4481-661a-08dec7b2e046
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|7416014|1800799024|366016|23010399003|18002099003|22082099003|11063799006|4143699003|6133799003|56012099006|921020;
X-Microsoft-Antispam-Message-Info-Original:
 N6pb8n3hbKzvKPUvVKvRHKEl+Be3LCUE771CCzoaP+s0MFFEVEOMnxAfcRm3gaPWwcZzPyJmMcSvYpdyHO0LUmJXEgjQdKUnpHEh513YEA9RzguoUQTXjvOnyC5UE7xbm+hc48grFXcu/C9zSEGMRFYWeMpS04mAb12gjeFcys3hbMkht5gOAaXwKzFYUneI+MrXYAjmUHfEBvmEwHX5O8UZBnkmUQuPbxI0rIc1wLp8b4l3O7XFqC1u7w3PWyFcWjo3xFKNNyg5aVw3ZfPWg69Ypf7Y4rKn/q7kyKjzMz2OGBQxoW3chbnIlSATTnsmtnAknscsV7AZ1eKQ9Kbu16w08mQnFJQKKwNkrJ1x1yKM9nfHGki4AAKKb0LXtqf7ParPO4CtOWbsbe+o8m3X/JsPd/9xTaenmNe+vQEnvjhmag8gB1KIZirg27fV5X1y4jBCzRgfjP68Fe4f/Z8A9Xryt2kjIKyeX+ksiXPiDQwaXzeMgI6wovyE4QI5JUpn4OBe1UWMHizaoallzDlIGHWPrzQLp2Q38/zGmEgHbWH0R7gM44BWm0pT8YwR9crNN8sxdKU8G8MiT33pIRa01wcPMDv+0Ayo0dJ1Wwvj28VWT2WO6dFELku6rG6bxSsPmkdo1zeMP06thYgb+o2xsGTk3Zps1RSZxQ9/3EdvCgxgfvKiatSxvq0Tt2tN9nY4E43JLxhKTLQ2x1BZhrToXPhvVspa7lLmE46yd31I0i8=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS2PR08MB9200.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(23010399003)(18002099003)(22082099003)(11063799006)(4143699003)(6133799003)(56012099006)(921020);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 W8ZTYv9AIeP7+X7B8Mdm17i/VmVHrDfecJw5pyDguJUKDplnj+5m7Yp1ug536Iqn8vGbxoDh8H7kbBMvAeRavoblWWl2kdvf5sxvu+RRVirDxrBNfey8qy+jmZNYnUVLMQbBa07UY5ZD1nZIxZrqbfMMSLwd+xPGvGm7G89xiNrdwKpy9odD9uX3JRfh/51RIJJKZ+HaDa3PRLenCDuL4Bzcdi5iRY8+COzPeMk0RYqH3wxede8A/hxeUh7iSPelDEn0LjXn7bsak/mXVqJHjMNJMTy9Q+l4ymH9XYDb2xDc0com5ey+3mLEZaNu1rfq7wqJWZ5Fqhm9gcEfKJZWLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB9622
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00025F9A.EURPRD83.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	5d4f5aa1-5b4c-4ba9-0b0e-08dec7b2d10a
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|36860700016|30052699003|23010399003|376014|7416014|1800799024|82310400026|14060799003|921020|56012099006|11063799006|4143699003|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	V58R84abQuco9RfoI+Fmd6PnPXjsx+GQXAnyAijiIqhgVFhHqm6/JiV8ydYPuJ4hgaQ9zXM9ug15+ICGEPLFXtgp4gL+0pDXTDAs5vZALOHUN3XvrHX+s2FSeW/p/cn+D9N1HqfDontSpE6rWiVorsw4ZeFcIpP6xCL7ZfkWZ8573pjgrL1XUDYzL7gu8HiyMohZrDG3A069lji6yUN2GuZ3wy8dj/z9Zg8y2DcTBz2sOCO7XC5EHwl/pOrgEMd9+JL6ocu2i9gVKBjnG+S03Zlg4styOkQm21zgj0U/gc2oitrvJYcgTZ5U9dE4efXVjM/nVfzljuKhzCC8KsdajG6HKulEHIE/t5V8HtOVEcsWFhl1NPDoEc774iGc0a9WqiNTrlsSmml9aJc8PK4FDbZL3jO3/i0Y1RPyGrgWowcrl5HWTKSleldJNCJDbuoAWn4TGA2Lqf7bRYdIYwKmdi3ony/4OuX6N+hMfn6VEcblXh9EDMtALrgA6jAybgTOuls1reIRIsQvIalbRghWf7c2kIOjtLakfMXfff/6KpIlaJI84YqsKr7oedmgEzgISiZ8RgcJ6t6kyvgkOhrrQBvFnR783auSPFVspv+IQcrLub6D6JqysdaFm48FzhG0hPOabzfyTbQSOff1uAIyCXveEurMu3heG9K5OTK1D7siM6jEn1T07ruh+SffoctSd59fRaQVUal/9wixYeJOYETyZLeiaYUzaftibnRacW4VRDqSDO5ff967r+u5HmovXg9TrQMN4eRoShD3f/XwOg==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(36860700016)(30052699003)(23010399003)(376014)(7416014)(1800799024)(82310400026)(14060799003)(921020)(56012099006)(11063799006)(4143699003)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	YvvhR1mleMaQitKxzHE7hB2/f/q/hg/pk5XivJdcCpBF42dc+MH/3nsM1yBC8741Kzj/Jdj1L3U3/fgaZGnv6IqOkw9ObZgqRPQEIhTmMcUHZxUj1N7NsY0PZECD0VDDyHazdv36yqHnHoVAxyOJcYIKsIg/dtDU3QvSt9s0eI6QC6K97Q78ST5ROOe3p8aFJ+JtaV23Qn7mSJM9jl4sGOVKtA81IHjhy1IvlRX+UbzhwQi4h9oTXAoz/c0zkr1CJm9BYQl7xiPbYR37ZKuqsNfX3ufEvxGhuulS16sQ8oQd+NVOAyfc9vGOP/X1R4BD36GTSLPF1YmBzp9phdSrq9fbkQ9qvOeNzHnTSRyLHgnl/nGO4QHmGxUiQD1UzMC2zlDvpigVoD6DF0Oxy5QZQ/ts/s1spcJG0NERlvLG0ZuT/J3+Eo3Tk72IxH8U+xQo
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2026 12:13:41.3067
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cd5ee09-4d50-4481-661a-08dec7b2e046
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00025F9A.EURPRD83.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB10992
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 1reefebqbfdp78gns7p1gafh3qmpraqo
X-Rspamd-Queue-Id: BFD5C18000A
X-HE-Tag: 1781180027-407381
X-HE-Meta: U2FsdGVkX1/crRDEHPpYcYWVCSrjF+f3mzZPAS94kRFRS8OyCPwd3C16GLYAGGxOvL2I0nUy2ljdHDPvxJI4xEWKPV6W5vFOlnrJqnsf3/hOPg7a5OE1ZvzozBhYFEVgkPRlCbZqOFXmELOxBRCSC/Wu95O5XdSPIUi0PQXdQIlIHguqFfPjrbVE16y4YBd1DNLQyv8vDP+zpcEw9hARtpeNywJGKe8Eom+c1ugdkYBJJPPQoROWChYWuMbdelLNZvGZEM7+R40fMDjHMsg6tJdEZ2oB6aNPbFn4XimmwXogOx903/rz5DDkLbTUtim8TcoRaF2eUtHC7xVvrq8pQ2SGNEZj+ula5nnYXTEqwZxOb88UwpVNGrjfwVGW177jxP8HxBVRG58QNrnFz4Q0Gz4y401NX51+8aGV9ALoSBerl+YDlkKwXFEuoQ3t1EzjMAhR/MRe6JlrJ8flZOWFKRNr97hafSLMEEg4/ANGu6d3rz5O/a5F11CV+qWWeUypw9r3kTittVuyC/6QbQiTx/wG+AO5Vp6mjinNgbZQm0GaxPJXSYvEydAskFOGMx8HgQucPutfQf/BKwWAwpwV5NJFPreKpnMRtdxbPMeLJMLQELa4hhwD6t2hNcNrCBVs4l+L+MCCcEtWWV0YucQYzy00H1af5KJZit+3ckIttmybjqtyNthX9BdlRATnmHMHat5kb5vCyzKNxx1Xdf0SLpKuaJ318VxKF3ZwYtvpqvRMUzqxYdRwwwbd8qrtlAPhEk7eIfo0U+dcw/lpEFIHeZeiHupsUdKrR6kfPhZK61ubMTI2kG58tU/25VShWweVPGVLfJ+oNY+9/NkF1/1NHba0jiDjEV+U2I4sk0dQIQkGpmaQzasxsxrlNvGco+7rkYQIomaiRPvqlL/ltne3cxkQjaqrHb+rHWUJJFY4ogGZ7g5LJh+Z13vjw/i6w+WJNSBl2iWmSICPvDt3e96
 T0gOmIwv
 +0AyxXIae9Z8XayBG0jTxVjKXsQMJKcTkvICYsf6q6t2SmtGej7eFKJv7oLZLcbSfMP7k8ZrAmpa4vkCGcqADrShhcCGoCzejUCKm7ENvr7WWDhDoe/2M/9a4Cq1Drel7Hec5AtU2xc7bsBuQznMLadFns8eJQnmH0DyNVW+/zF7hBxpqv+a7Hap/qNBl+mr+SSHgHu5vcfd4cHPE44d2DG6pcxONteN87t5bRlxd9amelw6NoJhGwC9SLPeDWiV/5L7ox+Mek3Jbd4uEM+S2c50wrRK6/iG28nkaXKHxvO9PPkn/JazEAfgiJtYPKReVstoLxTRHyuRa6mGePZdO3cYA4DN7p8v0CNaT+n9wAgMHTNVMZgZpkRfACDP0qIJ8NMH8uddHcSy40Lkga8Sux3u1KLijW6ZHcS5DN1zG2JYZgHe0aahXX/FRkTd2mLdZoz1202uaBKmgDw3bEBY39+FT2hHO8Hja83Hm89+wBGQ5PDxMEhiHMDDyFXiHcg+vqyhX0fRTu62mInUTZLZNySeLAb9dP6df3vtFDP2csKyYyqpT4p3+rSXY1Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/11/26 4:56 PM, David Hildenbrand (Arm) wrote:
> On 6/11/26 13:07, Sarthak Sharma wrote:
>>
>>
>> On 6/11/26 3:31 PM, David Hildenbrand (Arm) wrote:
>>> The droppable test currently relies on creating memory pressure in a
>>> child process to trigger dropping the droppable pages.
>>>
>>> That not only takes a long time on some machines (allocating and filling
>>> all that memory), on large machines this will not work as we hardcode the
>>> area size to 134217728 bytes.
>>>
>>> ... further, we rely on timeouts to detect that memory was not dropped,
>>> which is really suboptimal.
>>>
>>> Instead, let's just use MADV_PAGEOUT on a 2 MiB region. MADV_PAGEOUT works
>>> with droppable memory even without swap.
>>>
>>> There is the low chance of MADV_PAGEOUT failing to drop a page because
>>> of speculative references. We'll wait 1s and retry 10 times to
>>> rule that unlikely case out as best as we can.
>>>
>>> On a machine without swap:
>>>
>>> 	$ ./droppable
>>> 	TAP version 13
>>> 	1..1
>>> 	ok 1 madvise(MADV_PAGEOUT) behavior
>>> 	# Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
>>>
>>> Reported-by: Aishwarya TCV <Aishwarya.TCV@arm.com>
>>> Fixes: 9651fcedf7b9 ("mm: add MAP_DROPPABLE for designating always lazily freeable mappings")
>>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>>> ---
>>
>> I ran this test before and after applying the patch and recorded the
>> execution time over 5 runs on an Orion O6 board.
>>
> 
> Thanks!
> 
>> Before the patch, average execution time = 3.87 s
> 
> Out of interest, how much memory did your machine have?
> 
> I ran into this myself on a 200gig machine, and there was essentially no
> progress ...
> 

My board has about 15 GiB of RAM.


