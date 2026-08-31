Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39A68C61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 05:17:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 960636B0088; Mon, 31 Aug 2026 01:17:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 911196B008A; Mon, 31 Aug 2026 01:17:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D9906B008C; Mon, 31 Aug 2026 01:17:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3FE756B0088
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 01:17:04 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EF08CC03F3
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 05:17:01 +0000 (UTC)
X-FDA: 85160405442.27.FE14E8C
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011059.outbound.protection.outlook.com [52.101.70.59])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1C38F140003
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 05:16:57 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=aZZWtc0n;
	dkim=pass header.d=arm.com header.s=selector1 header.b=aZZWtc0n;
	spf=pass (imf09.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.70.59 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788153418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NbX8UExesoGPe189jyjlMTwheCqk68Hc63bPIQy9sJk=;
	b=76HPwQreHcD3Imje41D+wuTBCmEk3WnsWKOIWOkTVWa8AtY8yIWTwtWzT/Z0PfGvfESp2J
	uKM+Pqwoy2WEFwnJBuAw/ysy6aNQLrU33jkYpZWe5tHozW6TF6g80TV9wMJKGmFxBC0eI3
	ej5/z3HMCn5a9oWYr7uJ4H85xQ7VLrc=
ARC-Seal: i=3; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788153418;
	b=wsiMfsbUrNlne1v71SJj6yX9QOUuK8xPCRr2uqqFDfV8XLuaNApOkgEqX8Jnbrqvw7GqZ+
	Q/AZ60PbOo4rQ4h0rDdA4XOhFQS7hrsQtZvasGu5toRpz4LmA69wsPgXeLbw1iAm9eDsT3
	jrbcK1dUE+ykOUOEsiEyaTNuafI926A=
ARC-Authentication-Results: i=3;
	imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=aZZWtc0n;
	dkim=pass header.d=arm.com header.s=selector1 header.b=aZZWtc0n;
	spf=pass (imf09.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.70.59 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=GhrQZ5YbhHsb3pLysajgXa6UHRJN8zNeqMq4FHZRlX6ubKZsZxuMAVfDV/9IePMVse8uOn16dppljrIAU+7kiUfAbl8NRhLm4SBRy7Hdc3shSUuLnIc6GTlBFKG2d07f9OGhAY5coZEC8hsAFvaE/EGdmiiZCJJF7bXJmiP45NLmNGPPokHzK1H4jeGNmIcJWrqZjuhNlAlot25nyif63svMKCOx9s7damLNXUeuAUPYH4k9v5ritIZPUMfYETWi7urWe8NgYJCBgmMe3/DbXG5qpCW00iAOTVQPfo/kEp37Hjidiai3Lo4KdRyP8EYJCI6z3iHJOV5beq8vTgQCHw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NbX8UExesoGPe189jyjlMTwheCqk68Hc63bPIQy9sJk=;
 b=emvEwNl+xZMDfHHW9RECkC4TV+wHXDfu6WwsjF299wRsuZjE/A0SuNUN1si91wWDo+05xmIUYr+Kzlw54E0mTSRd4BnwWrIR9CT5S5YU6juQLs1pEuYQoGwuXIvo6fr3u9mjsbb0qzBU0IGpqbZsVr3wJmHEFbUnMt7vNS1ejtHdiMvjXA2uwAkrAtFLcAWFseNZH/k3IN2upagzZqgFGOOpWKyKhFnotqKUDNAL82ISG1fmasw8wiRps83BBjrQ+6F3H0Ki1J/JPlmqtdfHsPIXiBG4mtB/GLMCiX/QCd0rQ/Lb2maQRRyg5EePac60Q9ZBJC+ltWWil1M8v8TtiA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=linux.dev smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NbX8UExesoGPe189jyjlMTwheCqk68Hc63bPIQy9sJk=;
 b=aZZWtc0niiJtJdqciVL9tWpyOHuGXuKEKLJQ2h5BO7DyZjnb04ZlbdC0WO2yetDsVO9xaEZ+uyVqCnX0P97YGjXStQDaAP9NeX984zsL+2qwFY1BzGuWjfQHUah1M9fA+NU9PixVLZK2gSLVazuC0SmRDS3GR8rNMQBtf+C6PBU=
Received: from DUZPR01CA0072.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:3c2::10) by DB9PR08MB6361.eurprd08.prod.outlook.com
 (2603:10a6:10:261::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Mon, 31 Aug
 2026 05:16:51 +0000
Received: from DU2PEPF00028D01.eurprd03.prod.outlook.com
 (2603:10a6:10:3c2:cafe::9c) by DUZPR01CA0072.outlook.office365.com
 (2603:10a6:10:3c2::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.360.13 via Frontend Transport; Mon,
 31 Aug 2026 05:16:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D01.mail.protection.outlook.com (10.167.242.185) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.8
 via Frontend Transport; Mon, 31 Aug 2026 05:16:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MGHH2XtXvp0UYnx6Y6QlRPL868YUcunUzIVM+y8X1afIPg7Ys/mM6OXM6rOAdCcSwsC+S7QgEvAgZiDlvsHLYwEeUS/PromHz02d4F4N6TCLylRUBECqNkE0gE0kBxwmc6wS0apuubrz3V4wNcI/1SXiAobXuliezlJWtDA4wfosgXOnR05G1Hbip7lRNna5AnhbUX/h3YA3DBSejx1a9wsCRDYpHcpfNkc38EUy0TjCXPk0sY4aT5zaNflMxwXDLVwZ1QLrUR09LhMCTqvOTRU5LjTtECVHUGK0Pg5KvIOFT+dXwbQS27Da8RK5oP0Dhg8DDHbh+u7Mwdn76my3cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NbX8UExesoGPe189jyjlMTwheCqk68Hc63bPIQy9sJk=;
 b=do/o5bYMapMZbXMUumNOsmKtrFz/4cQwpZ+bJycrQzg/I7YwqaWxKXwl9UhywAkzlEmn/zVX70UACTd5/S2AJfUpLulhdKOGDIwIqQCnJQtd80d5SBUoSvpuj3KOnQMtz33w9MIYVlv8emqQd2Gj+Z5VmJxtxTEO4D1pTdWg21QwPUGqjHX5KG7eQj/gRIYz0MKoSnSmr7eLglRkrCgPBMwoq7k3GGsvmcCseANRjyIe8d72hGhp5WS4uUXgFGozl2BoO3vkWnG1FLu7y3un28pL+Jo4Eufa/+1FySaVVv53rAvkwxrPMVtkAD5PWwWl/xk3WlNDySl6AISr+SXSJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NbX8UExesoGPe189jyjlMTwheCqk68Hc63bPIQy9sJk=;
 b=aZZWtc0niiJtJdqciVL9tWpyOHuGXuKEKLJQ2h5BO7DyZjnb04ZlbdC0WO2yetDsVO9xaEZ+uyVqCnX0P97YGjXStQDaAP9NeX984zsL+2qwFY1BzGuWjfQHUah1M9fA+NU9PixVLZK2gSLVazuC0SmRDS3GR8rNMQBtf+C6PBU=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com (2603:10a6:10:417::12)
 by DU0PR08MB8732.eurprd08.prod.outlook.com (2603:10a6:10:400::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Mon, 31 Aug
 2026 05:16:14 +0000
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047]) by DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047%6]) with mapi id 15.21.0382.007; Mon, 31 Aug 2026
 05:16:14 +0000
Message-ID: <f72b2d38-0999-421a-a5de-1573b0f83e71@arm.com>
Date: Mon, 31 Aug 2026 10:46:05 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 1/6] selftests/mm: make file helpers return errors
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, shuah@kernel.org, skhan@linuxfoundation.org,
 corbet@lwn.net, jgg@ziepe.ca, jhubbard@nvidia.com, peterx@redhat.com,
 leon@kernel.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, broonie@kernel.org, anshuman.khandual@arm.com,
 usama.anjum@arm.com, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260831042101.18085-2-sarthak.sharma@arm.com>
 <20260831045241.25826-1-lance.yang@linux.dev>
Content-Language: en-US
From: Sarthak Sharma <sarthak.sharma@arm.com>
In-Reply-To: <20260831045241.25826-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5PR01CA0257.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:21c::16) To DU0PR08MB9203.eurprd08.prod.outlook.com
 (2603:10a6:10:417::12)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU0PR08MB9203:EE_|DU0PR08MB8732:EE_|DU2PEPF00028D01:EE_|DB9PR08MB6361:EE_
X-MS-Office365-Filtering-Correlation-Id: 1358afca-86b1-4e3f-6873-08df071f1066
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|7416014|366016|23010399003|10067099003|4143699003|56012099006|11063799006|6133799003|18002099003|17002099007|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 0/AmB3fATUZVvYmegUVN3p8Ne/yXCu1SKoUQvgy3oQM2WsfPKhbfN7JLBVi9EtLukZgv8BCSdoND+6Fc5v2u7LdlzbO8IJhckFN2KA1BA4M5mvfcDam/J69gMbTT6PjrcNOtBXUO84Qwhizou+3jl4Q2vQFIRMG6PUdCT70iD+rTvHOFmuh5xBqB0rWWu4fO5iQZQpVbGIAdvG25ziZzDDEneIKwCToIA0MnS6eCNA91KvtiUTb8VcBBSCCd2jW429GsGnmqeY2An+BNynLBr5DVYpQR0QjPs1qs/rWRzR/9urw3GFugIxphdO7AmkghwUNtkuRmLT+jeGBnsFPWGMcTthrZYcvW8cSL9RF+vPSDA5LhucAE3lEnGZGV3qJEGY+KHCPNhJ2pioSXVqSWUI0inw8TQASkzrmDgakvO4LtYysN56XivcvelpDxgR5nGGX0XUIv3c3yeZJHRPxP92oW+iFLmxc0U5C7IhtrgRgsWiFhs38qZ3U8tkhIBgiWQgvNn4ofeOVAYzBpvs1bzkD1xDUe5ORUEKcyuWKIZpstQq/80654BBAkaPWNbJgsFtNUmR5YLLUOGX72geTbNfWoNH401P55Bs3CnWoLP90kjEeZXiOdpBJm6KCqu9+Smzv1JU03vWhhWnpGDolb3Zmi38oJpQSmuHKvhMPqa9s=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9203.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(23010399003)(10067099003)(4143699003)(56012099006)(11063799006)(6133799003)(18002099003)(17002099007)(22082099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 46w28q1CtL9zJOC3rjN/a8J4sT2d/OAxdRN75stLNECMXQgpWRxquxvCYh7nYQKp8Jg0VUlFT3nvYTKs3QC263ezoKaLXjmKDSVXbLKUFkID9iQnqJNrhSAkQPf2D0oOJVJpGGl8xIa6vOESCCKEcEX1jAtN2rLMSv6OERTna8f62Wecsom97ONED3aOJgff8RvizeHNK0VN/4lSbNotK/dM2Y1P+tOze1E2i1qM9I5MBMUbv7RgUL5Wrx50nrucSWeqqJNU7QlGDYv+crFIvl+wZfOqTb3lcm4GiGYNV/vwy6bdWGJ9AFdTTdT6lZVNYjb/9HFd3oHHoZalptrbQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB8732
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028D01.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	aa0dbf87-1820-4cfa-5fcf-08df071efa58
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|35042699022|14060799003|36860700016|82310400026|1800799024|4143699003|10067099003|11063799006|56012099006|6133799003|17002099007|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	xOj0BGIDOE6X3jWtxXESRjQE6CqcW9DiZbkgS0/eOcKNdfuEQys4niB5wH9VDhPEf3Po7qicNheDEXIuj77Ee4ClajElr2++gR6re/TBiCPeGNoGn4fSmbOOEESDpyZeGoxwWc9kSGFNEz8EwMKtq0DhX7h/ui2Ls5Lc49iBFKJ2+tXDzLAMUK5yQlX1DBEQHbnyHGRSX2m5jiXOZzejJsmZGWAsqU9susIdTaA0Q2v6/B7Cw0JpRsDkGsZppLArao/GY+95benCLV0C8qh7uSF+zile5czhLT6gmsPBqzq/3GR2KBcx/537JPdD0QciEJIVqHKBEfxAwpmzsgSxtW8rgGE1EFI00bNk9iOeNccEk/tbA9ImaHfIfE+SI5nZMSeBWFe7O1mnsk5oD+2CgisJTNL6wB4BoNRQ3hEYBu1gJZSzI/kuiKpfryGVRn/Rg6kcJ8SeWukXw2IDRCzxhpo4QUneLREQ2RaIMo7NjoBStAaVlhEDhKOehkoWN+tsK4TCdSj4eMcBkJW00F1WMxDeo/jgxPAH145ib0EBqq7a/7QxLyFXZo4uX3oxC1FdoRcCnhL6Z6Xdg2b/UTNjgrORNaVNvGQRjTWKzGAzxT8N9+CRpwh7VANzWG/s6NZIMy12id1BHyZ4Lku5xYuPZrMQR6MfiNlSpJmPBQPVXXGd6ENukcqkjczGj50Yssk+KMUH2vX/PiAhqI8eJGnpBg==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(35042699022)(14060799003)(36860700016)(82310400026)(1800799024)(4143699003)(10067099003)(11063799006)(56012099006)(6133799003)(17002099007)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	B1nUWxBmPbSz30lNBOyWOi5R7d2yL6+dXoXoI9Qu6HLC1jhXuXxrrEkfduPIm2cFPgJu3lIQe/JM/wF45tigMxQ8+ldOGF5/hzjTpOznBpohYCGBxTZhjeB0gmOCPIZ843+vF0XlBmisCuqK5BmZrbcnSQw2IM+jB1cTIXlbY3RHDWj39EiDrl/sx9y8YnC6rLkPaQ501mk5xlBks+UWg1UdSTj0C0LxNpZcTruWYk85Ih+ciCUcrll+tXJqpeWSq0BrM3IDWhV9PN0ObubNsBAAr/o3+CxE4ErBZ0nl9x2sjPHvWeOAUQnUYoXIEvPAyx476HJCvm523FTeFJm+41SwQcelFSZfFNGn/4umdFthGYK/jHEWWCIIugzvssJd7pT0/RiCNgmLD9AIPM5rgxRva0lc5/ki4bs4Vb3YwrT1km8+e6aFWC+anI0s7YHn
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2026 05:16:50.9403
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1358afca-86b1-4e3f-6873-08df071f1066
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D01.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB6361
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1C38F140003
X-Stat-Signature: ix3zq9cmi7nqutswr5sogpou9oryiys7
X-HE-Tag: 1788153417-860362
X-HE-Meta: U2FsdGVkX18TTmTIpSKc96sn+sAQ2cf+9UVxTjsgvoG42SiF2EiYIRzjt3TXuRnOT/J1C12Gf15F3imIBpQWzmlPXO7yorEetpxYOKK8nuHncSqBoFHPHCyV4htyYXIp10W5dSnlqsumWS5WXjjf44ajB4r9Pb3MWadlJv/9Kyf6/CToksaKomt7JPHObsayeQjS3ZatEC3kyUEsue7XuA+NK7PyIVEZiCePngcwPBMN5a6DNR/4wIkgGi3beKFZCDJGONNUh9fxvkBHVjATJcvhjJsqbvSEVtWey75yWH+qb+odMPhQOLkdy5QSm5iJiB7RGaPXUHDBabF85UdjRJ/6x2e3hsvtmpO35vHKXRuOJdePjcOElWSImcGlH5qqE2ORtRxLEOwMfZIHYM2DfaYwuZCjyA72VItyggJ0VrqB/rNHLSIbXqD9fP5KiEOBLAJLqFbV5lzFUga9RwJbtOYnPBkX4eBMorlwJCknfTFcDfw/2hBktO9QYVWK1yG+b0tJeW3yb7JacQfGwj55pPzxQhlzK+BrX8aZGoUQQW5xf221By81iWlds2fvfe3SmpD35pZbCy5jkgt/4svavFwjDBZBy8TxkA9og0XGfY3MfWxHYV6k3CjnQEHb8X2RFDisLBK3H4J9ViJbzOENObWbuef/EYHJ7bh6snj4sa5KH6yVSfi0+vQpIOj4K+3JutGbDedRz/ZijrSgjA0KQmQMUj6TOIW8jFGx5dEgUvKT9ycUaPblQlbWrAJuzDCrXO4h47Ix0GVce0ZvIF1AI9MlDhXjGSdaIkm/eid++a6ScHKVoWXlZIKw0RXnYMT81sHfIzNHc+6FIXssyJkNuDFpQnJ0S0GmEPU50eYRNG6NzdKHLhmujsw9VNH3O8lA2pDttjC/+vpTBocoudPDuE4g1/bsY63KYjgMjzH1RnDvcGeXcHdA8Rd4G9o+aWQYwi2AgNA+fgOum9SvOK2
 fHU//5r+
 Pm0WXYn+pe1cZ3OPIaXT51D0JR1BjIZnpX5pTf6yK+rCW0JtVHwwMuEa7hdlHxGps7YVewl+6ok21fJSZx1hCoJnptRwUQtPu+GJppJPPWydLJwdyvs5g0cuOLWRnSkyvnkYheTTK9E3BTf5lux4J1OrorWCXja3CRpCqExXR5RyjVVNgzPuwe8zPMHkU9ZN8o77CXykvoRdnsSrpobphY48LulSWIDtZ1ZBA3aE/bwea4mAP3sRLnH09M34T3i2bFxD4Jng+jlePmeKWjR2K31LR2ijCd6Y9inU/+CcjURa5cp5oc0j1G8Gz9eRB4cOtLm8IDjcVv/7TWGVSyywhZXLuwkvsUNpreGPNv2vHey5Ojs6SQ/qRLWf0snLpWggC6OOvuSWrG+aq6DENE58qy0DSYayb010k9Avfz+U9J0At40GQKWGUqU8ll/RzIUquj37wqsL9ySeM7P3X/OyeWsGxiXonq2soUdw6QDoyTikwT8CmY597MiCyWbjMGguf5AY39JdJ4oB7acg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Lance!

On 8/31/26 10:22 AM, Lance Yang wrote:
> 
> On Mon, Aug 31, 2026 at 09:50:56AM +0530, Sarthak Sharma wrote:
> [...]
>> diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
>> index 9a49af88702e..62f6f5b42649 100644
>> --- a/tools/testing/selftests/mm/vm_util.h
>> +++ b/tools/testing/selftests/mm/vm_util.h
>> @@ -166,11 +166,11 @@ int unpoison_memory(unsigned long pfn);
>> #define PAGEMAP_PRESENT(ent)	(((ent) & (1ull << 63)) != 0)
>> #define PAGEMAP_PFN(ent)	((ent) & ((1ull << 55) - 1))
>>
>> -void write_file(const char *path, const char *buf, size_t buflen);
>> +int write_file(const char *path, const char *buf, size_t buflen);
>> int read_file(const char *path, char *buf, size_t buflen);
>> -unsigned long read_num(const char *path);
>> -void write_num(const char *path, unsigned long num);
>> -void write_num_ignore_einval(const char *path, unsigned long num);
>> +int read_num(const char *path, unsigned long *num);
>> +int write_num(const char *path, unsigned long num);
>> +int write_num_ignore_einval(const char *path, unsigned long num);
> 
> Ouch ...
> 
> Looks like this conversion misses hugetlb-soft-offline.c ...
> 
> TEST_GEN_FILES += hugetlb-soft-offline
> 
> int main(int argc, char **argv)
> {
> ...
> 	orig_enable_soft_offline = read_num(ENABLE_SOFT_OFFLINE_PATH);

Thanks for pointing it out.

This call was added very recently, and I missed to update it while
rebasing. I'll fix this.

> ...
> }
> 
> And the compiler isn't happy:
> 
> tools/testing/selftests/mm/hugetlb-soft-offline.c:199:36:
> error: too few arguments to function 'read_num'
>   199 |  orig_enable_soft_offline = read_num(ENABLE_SOFT_OFFLINE_PATH);
> tools/lib/mm/file_utils.h:9:5: note: declared here
>     9 | int read_num(const char *path, unsigned long *num);
> 
> Cheers, Lance
> 
> [...]


