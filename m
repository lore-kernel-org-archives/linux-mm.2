Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 788BBCD3436
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 12:03:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7D296B0095; Wed,  6 May 2026 08:03:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D549A6B0096; Wed,  6 May 2026 08:03:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C43556B0098; Wed,  6 May 2026 08:03:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B46B96B0095
	for <linux-mm@kvack.org>; Wed,  6 May 2026 08:03:17 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 575A01401D4
	for <linux-mm@kvack.org>; Wed,  6 May 2026 12:03:17 +0000 (UTC)
X-FDA: 84736859634.10.7F75DB7
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011008.outbound.protection.outlook.com [40.107.130.8])
	by imf04.hostedemail.com (Postfix) with ESMTP id 80FDE40013
	for <linux-mm@kvack.org>; Wed,  6 May 2026 12:03:13 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=EXmSl8+6;
	dkim=pass header.d=arm.com header.s=selector1 header.b=EXmSl8+6;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf04.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 40.107.130.8 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778068993;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aOhOv+ITnB4cy9o9sbBtR2oSoufonjGpvfUDzPHu0Go=;
	b=IJlNj7ycIqleLbvSolP9DfqJ7BbXJvzsxNvSvbhJLBlhEzYTulXFDsvqn/bNuzLe+DxJmE
	nY7m17jYfopPq+ZGceBZ0NUWrFMir/2qZoLXj90dvFwZM90eETqrreyR7ZmPzxz7My3sEe
	pSaFQJiXpx7chx7Ndsp09Kl7L1Jf7bA=
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1778068993; a=rsa-sha256;
	cv=pass;
	b=Elsk+erXr7WzxIGlR6yWf2kJrCs7PsdQxuOJ5vMZyAAxR1vHcJ+x/lPh1gQLG9oX3cKdxu
	tchtfeIEPuVVE7wyN/0l7vLdk3OlphNOIZpiF6sTPQOzsR66yk0tn/HtmxqIDBJWcCdJO9
	Q1EcPj9Px/BByMj6+paqvwhrXd8euGw=
ARC-Authentication-Results: i=3;
	imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=EXmSl8+6;
	dkim=pass header.d=arm.com header.s=selector1 header.b=EXmSl8+6;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf04.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 40.107.130.8 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=aFuJvKUz+YnlyGtbtctbpgoLPVC2lMXW3ShI7XugThs47fNeCGbuqjINTER6C8RNs+tSGx7aovZNxAI2JNvne3P+KeN/QzJ1B4Mwhyx7T8zcH5ybLOH+5RJ5eyUbgnxDCOpVpUy3huSd2WgQ/8Mtd3UQCKMyHWVEN48gv4T1uh+GJiEtaEA03Q0X69+fdNJCACawlSNj6FH4zFtatMjorhS9QtLE+fHqEkZdSjiIQ5JRjW1jtUZbYpoeYpq0HXhE+YLARCSMOQ3ftFwOutLIvNk64w5KXiToc/hftvC23wlYICMg+nQy4vtVGLcLIyQhnzCaugL9xC0LlFJtwYeKqg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aOhOv+ITnB4cy9o9sbBtR2oSoufonjGpvfUDzPHu0Go=;
 b=SEQiQhboE9mHHq5R7/D7unvAwxabdDg8VTN/KyqNQ5GGYOIFsAKBzx3pqUMcsL7CLXimbHtKmJxBrHiL6qU792PlAMnhcMAQFyEumZJ9NQS5iNN3eU4OlEo1iXe68/NbwafZwoO5wytnd6KcUliehwTgdpzkmuxWO3WwGPRJ4axKZEPiNhTBJwFaI8OY5Czhs6OxAo3E7TY/k4cHNE6rWvYfmYtDu05ZQBorOzyeN10ui+I3gAEU0slhGkmW1JdnGsdDljgmUWKjll5fNOnTVl3NTkfdG+ROMm1YTNFVoxVJF/ly8nP2YZsJmpeK4+vdP1jXMYuh+4t20J80IzQ7Bw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aOhOv+ITnB4cy9o9sbBtR2oSoufonjGpvfUDzPHu0Go=;
 b=EXmSl8+6loUF/ipbLKgzpAL6o0JH9L2L9qLvdHGTm4433NpPFYh2Faph+uAxH1vPSE8KKUWTYX42G8XnIYZVkX2GHWtiYjoTstKLi/Efbz+qK++kTTheSZcWfbp1zGco2JfmOb3tWTxqdX4DIhFHXLJjq55hT7MI/Wuk0srcFQs=
Received: from DUZPR01CA0340.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b8::13) by AM7PR08MB5382.eurprd08.prod.outlook.com
 (2603:10a6:20b:108::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.25; Wed, 6 May
 2026 12:03:04 +0000
Received: from DU6PEPF00009524.eurprd02.prod.outlook.com
 (2603:10a6:10:4b8:cafe::41) by DUZPR01CA0340.outlook.office365.com
 (2603:10a6:10:4b8::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9891.15 via Frontend Transport; Wed,
 6 May 2026 12:03:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF00009524.mail.protection.outlook.com (10.167.8.5) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9891.9 via
 Frontend Transport; Wed, 6 May 2026 12:03:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CGqtavTe75l5wfLULGDQ+lA5S6miKTK0RLCc7vSTBIeOvvlsDUYcv5OMYOSsll57po6AJEesojUAsXO3RUnaXzKlOStIjKNX/Dw6h4eWvQ5WT0dcECR4gGKN0c5y3gNoNfgt3jsfkFRcvXMD/R0HynT59JnkLxdY1NeQ0pqrGUl1sGUghpS9ngcKh8U9OUqDlJowkiso4nSFilBgCMF50nqT5e5K1F+egfsFX21b2DiKu16Il4XJN9unyjYSG+Ppq43aPVsiDKCQBLTVY75GmKVN/XXzgHejzqmk7dBEdDb1/qTLZZ5YDmuoWe4lPFA5OXmhkBntM9Weu3xIro9/2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aOhOv+ITnB4cy9o9sbBtR2oSoufonjGpvfUDzPHu0Go=;
 b=gbDBLyEw1p1v8APTBncKMYkmnkTo+b9ojsT1whW5ehwb1smPkMEfXFhL8ztL7DFqw3NnzigTkDXNh3MVGjEFcU0m2bG7yoQ07xiRCUJOalcD81X9Oxkun4rYYjMketYelDriogxg3bSmmAUg740p1YC3cmBa3c0+aE0gxqPfAi0vvTWhKDsOjbI2FxklcqKYGY4a7PKG04ir7o8ZLNn0ZChA5lqlJsN8WvQ9kOg4z4+Xaq8vOEoP45gBRYT0SbhUNpfMtUjka6+OXIr1Dq7Hpq+bDe8XLa0K44frskJL8O+64cGCuObXz+AWsbSgvK39VOJWLP8hUDFi6ylaSe1NTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aOhOv+ITnB4cy9o9sbBtR2oSoufonjGpvfUDzPHu0Go=;
 b=EXmSl8+6loUF/ipbLKgzpAL6o0JH9L2L9qLvdHGTm4433NpPFYh2Faph+uAxH1vPSE8KKUWTYX42G8XnIYZVkX2GHWtiYjoTstKLi/Efbz+qK++kTTheSZcWfbp1zGco2JfmOb3tWTxqdX4DIhFHXLJjq55hT7MI/Wuk0srcFQs=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com (2603:10a6:10:417::12)
 by AS8PR08MB9696.eurprd08.prod.outlook.com (2603:10a6:20b:614::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.15; Wed, 6 May
 2026 12:02:01 +0000
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047]) by DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047%2]) with mapi id 15.20.9891.008; Wed, 6 May 2026
 12:02:01 +0000
Message-ID: <c4b9adf0-fece-477f-9a9e-c2b4bef16f71@arm.com>
Date: Wed, 6 May 2026 17:31:53 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 29/54] selftests/mm: vm_util: add helpers to set and
 restore shm limits
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
 <20260428204240.1924129-30-rppt@kernel.org>
From: Sarthak Sharma <sarthak.sharma@arm.com>
Content-Language: en-US
In-Reply-To: <20260428204240.1924129-30-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5PR01CA0058.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:1b8::12) To DU0PR08MB9203.eurprd08.prod.outlook.com
 (2603:10a6:10:417::12)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU0PR08MB9203:EE_|AS8PR08MB9696:EE_|DU6PEPF00009524:EE_|AM7PR08MB5382:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a9c7e9d-d7c6-4186-b9c5-08deab676d90
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|7416014|17002099007|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info-Original:
 rs8sN3pvNI4SNLutTU6jnIIqznE7k3ANElmAx6Sx1bpBCMseN5nQE1u7/xJRuZlNrV38sKQl/xIiTWFChK/eAFehf/pr9sS6FToejV1LVjY2n8S3zXbR+KDE813J49wEAhC0tvpVxmfE0g1ck34LWNGtZIHBumGllI00RgnhsaPdd4ZXGqOCkF59/kgfBIRcFLkieJchw2kFdhTcFhzbgihT9Jhj9Rjq0LvwSyumlcE32gtyCDzy3rZucc5ER4S35owc8X+FOiqpR5Jc2DMWcaSuU+YJfZXaIml2S42yAXgPpF1KCS5ZPPEUrmHTvTFxWWIHcQQUKeEcdS403uithUNMNExc+Ykmzm3DPv8H63UTEjef8MmO6gMC5yoSMdu6rj28w2wYY57Aj4yJu0QJHNVOJvj+8p6Kx3VB1wM6Rtmm8pd5/XhgNy3GiTr3InI3Tuw/FQTDmz87AK+7BuHf5Z/DDxvPhiNQbDaeGZ44WqjdfZknWwE611q8lkEwTUrazEmLX/ZUNBasIs0zrpfiqq3hoNmgjOCuvl8BeBvgDkUFvUwDYet5LRycU5WYA3eQhxVt/s5ZCb4/knPApjnP6DePEhyFlxmNz/fvO4qMMvu55kMpHN6JliTxebHCVBoGCyuAbQWeDifB9Jf68r++33m+617wRhcigbDZLDI1xffgcu90eZlqxxE9NT58ms4E
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9203.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014)(17002099007)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 cDvJUFil4Ul49UKrKtfAc5bBea9F61NJNjOa631hCVrUwSmwe/5pc6zU5BMXdVetO2aczC9vW9cN6rYndT6f/so8k0C0YROK3B+aPIgf6GJRknGlTv8YRtU63GuGmnrInVEL2GJFZWG5ovWsr7dBDZIt3lbAEISG8Iuy7wkRrKiiVx+muKlAJXq7L7jv8XdX3jowCNGPsXchKlVw1Mjoy7UXMeNrYWszKSbxp4zW56Qg7mWRvHhOBemb5jxmj6AyAOTnwiRzlShuNskbzg0mFO8Y4kiKrYIV965RnNprC1yFGJ0dW2U8Yu/DHQvkkDkGC8VGaO3J7td1smtstn/fnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB9696
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF00009524.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	2d94abad-1fb6-4fef-09e6-08deab674801
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|35042699022|36860700016|14060799003|7416014|376014|22082099003|17002099007|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	KiW0KAl1fO+YkV8qqeSMH/R0bjs1XEeO+3zGu3/mLibNHGaSPKkEsbWS2cQvR4IbCOoR8tmPMUhrZA0ODGlT6nBthjT7WwPYWCaLkSJLEu5Opfe9KpUOOmSaONFn0lQ7r5Vbn2nN9Z6NAbecAwOrF6o9AajMQQtL/er8MZXv+t5r+KgzVq6wNTT41x1v2JUUFPudgsXxu1F/IqJu5MA3XjscLfgEQDx2F4K8+OaEWdJvNivR9/irFg44KOoLV8sebNPOfLr6ZVzpXl8amEYgs5yrn33icHQqMtHcyvmaOe6CKRnVZm0A8508vqUhn5dNVeoQBgs0c/p2c3zgWJJawrAeqOtUbdymTwTBE5oe9M3XRaZSzz28AFvOOBCLNTHkvhOS0qVzZzfMZ/6RCC38my4r6m5yzFyWfDCGqf1dZbTuydO88z0O69fntPuUrT2JSUMfyi+Acl2zm4H0uJEtN2u06WlQmZHhjGc9k2nmhxTxM/dnJmHs7YE9sMyK5KRsuUH6lRi/x9s7ATtIO/g5+GTTd6UeCePOPdzKfKZ7if5a/9OB5rcd5ooIIh/OpoA8laFm42IjlPUC//1G65xa4DPHfLeYFyVNLMefEu8z90SGq71uHC8zNhhMKL4akYaTxG+t7CpeuEZXNfG/pVltwIK6qa4iP4lPuKLL8sjDxRJ3hBs/UKL2B1SrMs/lLC+owj6Mlos4+IeL1GPGaQRWrF/fNvRjwyaGEGSYK3mYTOc=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(35042699022)(36860700016)(14060799003)(7416014)(376014)(22082099003)(17002099007)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	5NHNPZ86UCmaI+QqipUc4KPpnjSkoGD4BRaIFTwO7GNSkactCCrmNKITgpOY5pFWEiHBD2KLkXc6KJ4IsR5QqmyTx56UCft6DHPXDAriSkbawi5gyQ3OC0/571e3ekDk5RBHXMPsPZYF3MU3qYF7GHiL86QxqevD5EGQ4TFnBgYvrR31X1SjugEgxpRB7R+T/xeCIMmCEdLq76XJPKKHj2lermrKUwBQaEW3g2K3RzezSOqv3wViASKg+9Mw9bPd0MdKUBSh3droJadrV9DtuuW5GDjs56HMseWAYruiXQCDnJgCs/2/8fihg2ziwz/3y3niiAibCCdZElBLYaWbac4VT2DnLm3D76dtPeipDfUqqrFTGvkzZ+JC7nahHYd8CwenfHo/F17H7lB3z6+N/h0rIOEzNXS4LhPFpeostK08UhbjaJlPdoamjPdat03J
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2026 12:03:04.0321
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a9c7e9d-d7c6-4186-b9c5-08deab676d90
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF00009524.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR08MB5382
X-Rspam-User: 
X-Rspamd-Queue-Id: 80FDE40013
X-Rspamd-Server: rspam04
X-Stat-Signature: wcec1cct68bt9qifyd9wa44cyp6ihsjq
X-HE-Tag: 1778068993-951038
X-HE-Meta: U2FsdGVkX18oCOt+0vt5mKgdsrSS1GWbwX+o4VSjwdN3NzZ7MDTStmu2L1Spok1VVcctmiLtSPKbTsW+vAp3EGrbmq8i4hWzkR7hZ1uH9K+vJIKzvQL24yJYKR2u1n8mHZMTZN/f0ayLuD289CXELx2OY9+SjvNfs3/4xMrStkRpN8Vtxuy2xY/wwIyo6J01aLR1xwS0mvwjTv8NMGxwLR3VtrcGxXqyisv4qSjDGhtLqYi2YGnpN/mdvcu+g5Ycj1hOn2WAwujaYSQzVbOYlrhCoebjZ+YwJ27euv16mcoSupo4FVIpqHKaL1VbOAZcdfnUKKfH0jdzXYxNoRlEPiB+krnGiy8uhyPRk+C9Lh+UJVi17W8ZKugLtmtUssy1A7cF6GpRiwDrudWCR2BtQjfLkpoPR+kiQvYSbewUG4NGTnzPq6IhedxClfctP19z3i3rG+oACr+Y85q9VWwXaYPOWhV3nRzr6OaruERt1TaXJIqaC4bjTfvG7UbXpbPoJMZ0PCDfGTuaI9n2MY4D/shBoojnBfcYiHSJNygIA+GcTXAlaz7nPHMX3wbf8aVwl5PUKacC4UBaRz8DIjfnBhHRazoN2UPumTeVewGc4CPYzEKygng4BSdYafhmxx3psHZDLKWE5sJmprTNeO9d3QTa0euicDFatrMmapd1aTzMKuKYAufDnbBXTBPgTMSQZm1ozoW7q2AXXlbI4Kz40lu6BwJJoRNHSi3XIUH3SpigxRGKO1UFRc4db0Jt56W9AiZ0HvMk6cLW3a/5YHa0Hqe+MS1HJgBaltCLuZRXdtOTuQJb8IwZ4Qobyvgav7kqORbaYpyppOpE+IpbjpqsJqwT9nlxK3ek8itiDdamnsU4ah8NT/Ou/IXfGfZUUVB+cPcvcyoZG1xZgxN/m+q4VaUD+FmJccpYMj7OiC79gIjBiejw/+xaHYg9wrhJQYf9kOnffaaEjuWxhP6tEJj
 5yDUTOZV
 U6BkinxWGj4SqKv9RDSoFBHlGCVQI0TtD4vbvvhBHFFI6n2k6FJWmwsOf1QdcQIjMYTdpVt5C6adqcyKuz+deKl+m1zYtRvdsa90Hei5lJLa1UTpArBqXg4zcisCDLgah2XI8txez0j5HWa9aXdqs4BQYCKYjFCL+RrUZp7Vt+4IbfpCAdz6MVa/Ey49ktrySTEZgOf4/edBJIEhcXkwqCAPGuu7iZKBhvCX+oldBUIfU2r2Suov0kHWDmNPlBCSL4ClMbvCrIdHMJHzyAr2lQwaGbqaV+9LrdNbbm3MJsQyDyp2kXCc+K47E5DDDR3/l7FkRKPLDbKXldEZ3lkLluUv/xp90JF8Z+CsrT61Koz/f/8UaLZGt5ulZM53uLLbmThd/mkE/D2qWO8XFSfLJ/8Kqznj9LU9LfE1h8nC2wzPFG/TPmW7/DBs02DsXKfIK54IqCpWjbl0OA1HASFq7kbaubqI2yd5xDqFfF16v6lqOKMR+3TDb/lkbw/YTzexAR2Do5ze3W+BHf1EXESzzHtfjF1R6NIDK1gBDkGEad9nsbGzIEwS9oToxOnaaAvn7NuPhN8vZkbmyBZFh5BGV6VP6sgSKbRypRC8A5LB4bRfFfcg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/29/26 2:12 AM, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> hugetlb-shm and thuge-gen tests require that limits defined by
> /proc/sys/kernel/{shmmax,shmall} should be higher than certain values.
> 
> Add helpers that allow setting these limits and restoring their settings on
> a test exit.
> 
> They will be used later in hugetlb-shm and thuge-gen.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Looks good to me.

Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>

> ---
>  tools/testing/selftests/mm/vm_util.c | 28 ++++++++++++++++++++++++++++
>  tools/testing/selftests/mm/vm_util.h |  9 +++++++++
>  2 files changed, 37 insertions(+)
> 
> diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
> index 752566f75c0b..5a89c2d903be 100644
> --- a/tools/testing/selftests/mm/vm_util.c
> +++ b/tools/testing/selftests/mm/vm_util.c
> @@ -761,3 +761,31 @@ void write_num(const char *path, unsigned long num)
>  	sprintf(buf, "%lu", num);
>  	write_file(path, buf, strlen(buf) + 1);
>  }
> +
> +static unsigned long shmall, shmmax;
> +
> +void __shm_limits_restore(void)
> +{
> +	if (shmmax)
> +		write_num("/proc/sys/kernel/shmmax", shmmax);
> +	if (shmall)
> +		write_num("/proc/sys/kernel/shmall", shmall);
> +}
> +
> +void shm_limits_prepare(unsigned long length)
> +{
> +	unsigned long nr = length / psize();
> +	unsigned long val;
> +
> +	val = read_num("/proc/sys/kernel/shmmax");
> +	if (val < length) {
> +		write_num("/proc/sys/kernel/shmmax", length);
> +		shmmax = val;
> +	}
> +
> +	val = read_num("/proc/sys/kernel/shmall");
> +	if (val < nr) {
> +		write_num("/proc/sys/kernel/shmall", nr);
> +		shmall = val;
> +	}
> +}
> diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
> index 5fc9707f6b9a..ea8fc8fdf0eb 100644
> --- a/tools/testing/selftests/mm/vm_util.h
> +++ b/tools/testing/selftests/mm/vm_util.h
> @@ -168,3 +168,12 @@ void write_file(const char *path, const char *buf, size_t buflen);
>  int read_file(const char *path, char *buf, size_t buflen);
>  unsigned long read_num(const char *path);
>  void write_num(const char *path, unsigned long num);
> +
> +void shm_limits_prepare(unsigned long length);
> +void __shm_limits_restore(void);
> +
> +#define SHM_LIMITS_RESTORE()						\
> +static void __attribute__((destructor)) shm_limits_restore(void)	\
> +{									\
> +	__shm_limits_restore();						\
> +}


