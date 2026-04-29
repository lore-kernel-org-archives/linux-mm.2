Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0230DFF8875
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 12:00:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5ADB56B0088; Wed, 29 Apr 2026 08:00:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55E8E6B008A; Wed, 29 Apr 2026 08:00:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 426A76B008C; Wed, 29 Apr 2026 08:00:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 31C556B0088
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 08:00:34 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DC8891C0060
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 12:00:33 +0000 (UTC)
X-FDA: 84711451146.19.0493624
Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011057.outbound.protection.outlook.com [52.101.65.57])
	by imf22.hostedemail.com (Postfix) with ESMTP id A5B31C0016
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 12:00:29 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=YlfrZ89U;
	dkim=pass header.d=arm.com header.s=selector1 header.b=YlfrZ89U;
	spf=pass (imf22.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.65.57 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777464030;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qPOM8z0R9A6kthgaOEBj2UFQveEX31NoO9Cswg8pcQE=;
	b=3wSgVNM9cO7aLvE6MVIYYixYbyU2WGhJWxroNzNIf9Gdj+8ccipvxuYkFuAoTJX3zj8J2V
	wUlkWUzbuoFQlZZPfDMFeSI2PbELGldSBR4DmgIXlmrF5JkRE8AdbO66atm2wM2mW8cGvS
	aK0xMnfeTz+iOVQWgdWcRctkrSNZSYI=
ARC-Authentication-Results: i=3;
	imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=YlfrZ89U;
	dkim=pass header.d=arm.com header.s=selector1 header.b=YlfrZ89U;
	spf=pass (imf22.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.65.57 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1777464030; a=rsa-sha256;
	cv=pass;
	b=NCEuOy7fsTussaZ6uaZyQQCBtW+/aRo/ytzqk7ydmUVxV9yMqDTk2ki6VEEZ/+yki0pJir
	U0PEBBdxz1OuvvkIvfZB44RdsIo78uMD589o7Nu1up63I4q7MPQE/RMCz9SnmTRMNIE+vr
	0VX8RL8RBFUq95gD8WCnVg6wc/hryIE=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=QN1idrEp76p/WFYeobFjryenYm88ALN5j7FQ2OcngMPAG1tNK52SNSLzogn9VD5UTSGpWkmdrnz1sfWYT9b+qkydIPcDXa7+XpF8MY55kBpV/JOr95QhM9yKtB8JhCvDbeK3bLF/3uN55DOPb/5Q3AiDfU/vjpc+iYfHOw4qCqCFuA9kBAt4GQBS2hMmk42byfb5SK9d57HLNZ+TaZ6G2CwA0rT6NFha0yv/Y3+0zvnDSC7MJtrpMD7vv0SbCCnAkZJ86mzmAZgZocZyB5LqSTHt1tzZgOG1I8hRNAC7H0Z0V/g0CExfZ8PDWQXcIOlvjKBUKQwwXTpT0gco3rdFLg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qPOM8z0R9A6kthgaOEBj2UFQveEX31NoO9Cswg8pcQE=;
 b=p68a60bMhdE7T4PcOK/rXfjBAUm5n0Jqel672j+sqzGsLtGo4MdEN5NauWSl9I492+2Nt7Fojf3i44UzOn5bLVhiskDjd5tNV/z24cqr1lmcfDXiI9UR7hF61YS4cDX2TaHrXQd7ymZjYzW974Lj4/0dze5vEhV/yGimwgbwzi5IuM2vLK2P1zPB2sb0en4mWHapT+FUhvxNyJKgPHB2BQiJnq8mmbGOQ6GBuCJuRADGcKXbWAOQygerHQHq8lqfezALOu14xKlonqg5j8nyOXaABxJs15nKUDH6VFLKcWwEHklxPq5pE/Y6wUxEAztCNrZPkj5x+UfXMR+bzuzMjQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qPOM8z0R9A6kthgaOEBj2UFQveEX31NoO9Cswg8pcQE=;
 b=YlfrZ89UP4ss+Ck9EomkpGWrcZqT3vDk7Uw+RKSjd/6FSZjIldQmm/gngIwoCkzqcFrCvG6DEr7y0G26w40OSteyAEnQS2KiUtRF9dBCwBtTdgQGEz/zMt1j0ZAlC4lCeK/IfVs+i4avyR+3f5wTD+yqKrwsoVcjw3UiM5jZWS4=
Received: from DB9PR01CA0007.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:1d8::12) by GV4PR08MB11602.eurprd08.prod.outlook.com
 (2603:10a6:150:2d7::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Wed, 29 Apr
 2026 12:00:14 +0000
Received: from DB1PEPF000509F1.eurprd03.prod.outlook.com
 (2603:10a6:10:1d8:cafe::38) by DB9PR01CA0007.outlook.office365.com
 (2603:10a6:10:1d8::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.30 via Frontend Transport; Wed,
 29 Apr 2026 12:00:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509F1.mail.protection.outlook.com (10.167.242.75) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.18
 via Frontend Transport; Wed, 29 Apr 2026 12:00:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mc3AWDCh+f2PT3qyLFli51+1/SsAVPq6dlVfWIn2coBM4zvVy6rb2cszDp0s1sylxaxztIRLMy2i8P8lUv8tQG60dnDOeLl8ZaAWlD+hqb7EI9YSkYaic4UBLa5P8P0Xo1g4u13rG6OMVp+WRYVfWRdjlQ7ppv8AaLe2t57+RYN9nOsw1Z3Ew3B12GQFqzH3gGdvfYSxjm+YPDeTdLqouXUEjBF9D0fI/M7ZtVbvnbXVQ+fRWYAX6HEagtmGylB2W+121DrUGwUsfFNKJl2InA7bii5wKC14zjHYc609WFif/gVKSCFKexpyBfBhCurcjTp0icyNVSfQGJ9ULKyOBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qPOM8z0R9A6kthgaOEBj2UFQveEX31NoO9Cswg8pcQE=;
 b=YCiwVt/4VByiW6T24mXrW1auSXuqB3ZRgIFtIj7uXf9HCBCuYI7sBBB0yUaSwMg8+m7NvNp+Z5CJvAsp5fz9yQT2GalIeXFfJx6RE1AECaNBk06ir+F1tUQaku40g5DXOehBqPYvcR4OFk/7f9tvS4ITVo2SCTW1w04qrg1alcX/h1MYE5Xo41OSF37el8psjOpTzeWGirU9XN4yCnKGNfc/mkzianKViWeIdkAugk2yO+z6tyW9T44Mq+PHMt7Y9TcSFG/etdPU2o6FvU/asDR88GSU674ZpzGHewGnd6zwMAzOjnb/nnbyItwt+IKmD6heN1yT1lxxZmvTxmrTsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qPOM8z0R9A6kthgaOEBj2UFQveEX31NoO9Cswg8pcQE=;
 b=YlfrZ89UP4ss+Ck9EomkpGWrcZqT3vDk7Uw+RKSjd/6FSZjIldQmm/gngIwoCkzqcFrCvG6DEr7y0G26w40OSteyAEnQS2KiUtRF9dBCwBtTdgQGEz/zMt1j0ZAlC4lCeK/IfVs+i4avyR+3f5wTD+yqKrwsoVcjw3UiM5jZWS4=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com (2603:10a6:10:417::12)
 by AS1PR08MB7474.eurprd08.prod.outlook.com (2603:10a6:20b:4de::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.18; Wed, 29 Apr
 2026 11:59:10 +0000
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047]) by DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047%2]) with mapi id 15.20.9870.016; Wed, 29 Apr 2026
 11:59:09 +0000
Message-ID: <176c5377-773f-4be9-896c-780645eb7562@arm.com>
Date: Wed, 29 Apr 2026 17:29:00 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 15/54] selftests/mm: ksm_tests: use kselftest framework
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
 <20260428204240.1924129-16-rppt@kernel.org>
From: Sarthak Sharma <sarthak.sharma@arm.com>
Content-Language: en-US
In-Reply-To: <20260428204240.1924129-16-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5P287CA0018.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:179::17) To DU0PR08MB9203.eurprd08.prod.outlook.com
 (2603:10a6:10:417::12)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU0PR08MB9203:EE_|AS1PR08MB7474:EE_|DB1PEPF000509F1:EE_|GV4PR08MB11602:EE_
X-MS-Office365-Filtering-Correlation-Id: 72bb1cfe-34fa-4ebf-9643-08dea5e6df4f
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|7416014|366016|376014|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info-Original:
 k/hc/D1RjxB29LKoXsWpVda7u9kNuILXzN5kGS2W3WnK4Eq0ev6BpMnGc1bzJAG+j4oewipPmGidrM6kkuvvAXDTBlf5V+wFMAqs2sfsaVxFKTFoizND2ba4XVCn9QlWfGP1ovLyoQHPRyivBJbPW8G1rtwwePPNc6/ZfWSzSsykGCoFi4bLF/AY2bPRX+PJg6n7jlVXydsYyW2GBqdSmfoXTSiqut89CfEZAeI9Kr7172o4ZBgMbLP/yoe5DN3GgkyawRGP4cTu7FyLGK9Wd//lXrKQf1swHeKw1pHEBA7gSfDXOGD2FbB+ar8QQAX2uV9vFowKR5wdxY1om7I/P59fVIGtG27/lPN3Ude40WrhBsLNOVMLpHEmFKE18gL8xLstEo/M1Km8163JguNncuGJojaimiKPJ/6OZc0Q8w/bAU6oW7SfFQMngA7eEP3/Dfn9LEP7PAljbtDsGhyR/qNQrsH3XvP6hifd/VhnyX46yO0YQn7fzXeQs0KD6bxqZC6D/mVXhutYwgKx27wBABxyatNQnwP8HR3/2txY0OKNssQfkUixjkO/jpFWrORkSrPBmwHQ5KhorNsG31Z+SkcgdW5vNnii2vI8HBAWbGszwZ9Z85ovKwLxnumNopuveJJreEHolyZKf7/mAkkDKSjrJDTqOAAYJkKAAyB21c6hlUrpXckVzxgkZsO+wWaaZysJIa3wBBGdTIeSEKOoI6x9j0eM4pwE/UdmFSifMrY=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9203.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 Tio/mKOlld5nO+DR5fxK+ME5qlhFZ1m2b1LJ10gEzlrqp3MMyHcLHStHCBCFdoszzx0riD7RGizWAfnlXlk3A1+Za9Z9e2pHr+YB6cspySPlHaohKl4LW6T0RXnQ+HZX5ranXzXHG+mCqbCb6Fk9SdYTvPteX7L0w16RF4R3mEcMsaYyqhP5tmu3TJbZIUVlx88HvYJuf35NmdqrG1EbUsA7bUiewZ29RRHf+/ESxnZZcOHOv4qog7gxA59bYabYUmV8fhxK2K03oV0QUu/up9WaoqMimLG46DNnTRh/PbspvtlzfraBR+yx5HImiVk8S/UCY6UFYuvrWtA5ltRk8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR08MB7474
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509F1.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	f8052054-7903-41b7-1176-08dea5e6b8b0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|35042699022|36860700016|376014|7416014|82310400026|1800799024|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	i3ByQkLAGW9jLEp/sVAPaaNeOiBM/2e1mI7CRLQpSyKLQXjIRnikJwHG3JVWAMhOCId2ZLSwTrDNiYnZfB0mSNAEDn2P5dCRdFZWlpO6zqU4RWVFxA1jevPoeBU2I8hz+k7y2CjJj/WLewlJ24gLUb0wtVRT+P67DZTz36YTX+l/Zj42P6RkuqfTaXu3AHA+QIohiIsuTE3oO5D2zIwB03GNvYh8nf7ddyjjSpzq/ypTke5PH/LDXPmEitqRuJvK7utn2AObOfmK27TfpGnYoVHWMZ7dhehjTcR+seMb28dqhyu+L26lLx7b2aGcTeccAWNt9TdZzMM+HPIt5meScu00OUC1lw722rkOMKfYfT/S0OeAX8i63vHjTNUpkmAc50IbM/erie17qrKZdLxSRoKyeIqARey+IffmZxSbh5NHJUT+62KyCG0IY55TvOhF11DiT18B3Idv9q94gbNi5wLxObu2ujL4kuLPnY4Edh05BZ6N+UnPKa0R5BC0TYpZxJkRPkAIS07nzvQVrR0wMgxlR217RIIF1ATtsocJKbU+mqP4ivongEce3iyE3HKLIuFJXIT+hpWGEeVf1ix0TO2G/+ukYBSWKwDjpmPaWmasdvKS6Y0FUBNXaZJbttou6CgG2M1pMY92HlMAaphx9/+ueMi4iNHk4s76Xrsah2wURd/2DN/Sf85zL14qYMolemnEqSB4g7bTihiDdoPgM2d3/BCyhtig2FApS8us83AcRDjTp1LppH60/Cir+G5/BatphchusFr/ZKK9zsNWzA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(35042699022)(36860700016)(376014)(7416014)(82310400026)(1800799024)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	wdiovXmjTXaoGOusKJI4qu6nYbvtmUpgHTCYv3xQADJ0jDHe9EgS91gm/V0+yK++jXGef1h05rhfc65+eIO514yE0dOJlFjqO6+Q3iQs5sEF8Q4SfP3FjPpA3IBoaJN3NEN/D2s+hSTZFg3QIFxr/Zv88iAR+90EaFMqnlmNVdq2X4CGIqagmDRDI/qQ5SkL6tMy+vTPBUU+v4LfpAMszTWYrIRNk2ySaoPf+tiEWwLIJVe/th/v3kfa6pzBX+alp1lmTgR/LOzTsRi1TFW8qZco8ESdGB8eiolEe24ilmAiIRCmfnEebiRBLE3Qdz9VqK0fF14Q9VnsE5Bsuiw07xvsPXA5SqwZ4b5hAQ57KhryAeG9wpn1Nd8kMeESgaFVmD7hBhRwcLqR9fHOcDHnmeNDPo6CyaYKGFb9qpF7CEjIChLDZz8Mar4Nt9/nArFD
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2026 12:00:13.9725
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 72bb1cfe-34fa-4ebf-9643-08dea5e6df4f
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509F1.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV4PR08MB11602
X-Rspam-User: 
X-Rspamd-Queue-Id: A5B31C0016
X-Rspamd-Server: rspam06
X-Stat-Signature: m6msyazpf5wkf1dnewfontwga53bhxzk
X-HE-Tag: 1777464029-754193
X-HE-Meta: U2FsdGVkX184s77aaFrBAGIaJobCh4cYXOxSyDzJOn3L4kEgm9Cd/eZRNgEEh5qax4AG+fA3qWMfXa6dF9U0TO/aP0Q5uGG3XzP22gQriATDNlsor9tRGxF8Ub/R95uB8siwSP5VD0gt5GtWpQIG1e7TLbSIwmo6K/NN8nxY8MBBvl8RvvHvcAgCl4BJpLlsrJ9HGU+MdrV7sfG11k3w2/xw3JxI0nxiAwLuLiHD4HtNVr0ZehKDp3VVhg3touo9wmN0SFMGnY+RuHl0quEiZww9O/lzpNfEye6Viy4ybWH2GUKkwNnxud/AVyrdDacoSwNHTXy3uRHqP7olcu9OTevjnewXF7+dmJR7ZBVX0s4dwNyPk+VF9wqNucNWNZWY/8WVQgjtVUx0F8Tj1Ua6WHJWDeD/Qdie9UbRxN4CyzntS1ZJs44lqAKXsevs23CsdOU/xy/d/iAuILy6r+cTK9cJcmN0vmOKxvKyDMRXl2Yfu1J5Q7RwQVNYV22HefVwvIEgqHgvulDrV0ABWksU1eaExk0WdlbX1neZ80lb80IiQ3B7cF6GfrCjOoCURF2IbT11e7KUJIE4FoYkBgqeVt7PNZxC8nwaVx3lr8yX0p4B0clJU4CHEyowGpej3Vs4wkvdYHzt+G6bWUU5HY8jMudNl5NVusLpM+hmbPECGqZgIqdoNFGJX7A1XC00szT0O6P3/L2TBnbg+ATHM6dr7nNDVfltOtwyh7VHndBB1toOGb0P5U63u2Y/idO6YX3q4Ges67hOD+/2q4YJUiLIWf8bLcoD7JMd5kffNTntrgYHhng0bBDmm+WWdrLL0AQhXrgZkzyU7F1HewpHpVtZNb7wkuoV3Ldcll7Y96S7A0IkrNOqPnPwrTU6nf00rb/77TNPjTP09mIxf1x5tP2cEg1qwouQ7LJjpT8bGqaWChqA2V/HAVNKNFtftxFwUHGxYwT9Di4oOtX1uoFr+ra
 C1YVj9V8
 649Cbpw9P+sIIBheABFmok7yRQuV8PO8Cng2daHVYXfF/gErGO0iVqOeJRbtQHucmWx50BAxDRWV2Az/eXjVlSzoVv0PIS0IRMYnYdrZTF+56dREWPKxXCz9Q4/ohUB5JPuC8deFhxswNqv/hvLs4FxQPlW7pVqYIPZcm2c+JmUqA1WlciRbMespRF179od4f7TLUK3RA9f+KYk8E4p+G/FOjHUra323D5hFysbMvwW9OJrqaivU+R9oDD2XGpRghmX3sLrzx5yvhCC7m67zuwhUWvNLkdcAy3p55WcKoVtjXgic+iqTgS/fmb0iee/tJRbnpcWxlvwBxzPe5BVTdnIXyOylwus2io306uLtl1nD2KV3LBK4/erambu6M4DAi2nmfxTeIU1mFO419mhzpAG2a1VjhvcTIh4T5QJ2GX2AMYF+iWVGcurga4QDVgfl6u+r88d50zUp1yxSiy3ziwIEjZIa9h8jpXaEnSAcBfcpYE/081Zp2R39jQ2PPwWIsn414QqPiZUdiwkdnwDa7m6+e/UwFZSX0H/DIilgYX1DVh0+pFd355dvU0/EGqxaQqIrfLul+rUCydjCKU0SK7oX8fWUF/aE6zjBzrnGFXTCdcPAZ6uoiznQG+0gpaRdnox8o
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/29/26 2:12 AM, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Convert ksm_tests to use kselftest framework for reporting and tracking
> successful and failing runs.
> 
> Reviewed by: Donet Tom <donettom@linux.ibm.com>
> 
> Reviewed-by: Mark Brown <broonie@kernel.org>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>> ---

I've run the test before and after applying the patch. The patch
correctly formats the output according to KTAP format with no change in
results.

Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>

