Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CC66CD4851
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 07:26:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4981D6B0088; Thu, 14 May 2026 03:26:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 449046B008A; Thu, 14 May 2026 03:26:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EA436B0093; Thu, 14 May 2026 03:26:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 174046B0088
	for <linux-mm@kvack.org>; Thu, 14 May 2026 03:26:54 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D00CCA01FF
	for <linux-mm@kvack.org>; Thu, 14 May 2026 07:26:53 +0000 (UTC)
X-FDA: 84765193506.29.033B4E8
Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013032.outbound.protection.outlook.com [40.107.159.32])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6E2F8A0002
	for <linux-mm@kvack.org>; Thu, 14 May 2026 07:26:48 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=XUTkKOFa;
	dkim=pass header.d=arm.com header.s=selector1 header.b=XUTkKOFa;
	spf=pass (imf25.hostedemail.com: domain of Justin.He@arm.com designates 40.107.159.32 as permitted sender) smtp.mailfrom=Justin.He@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778743610;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZqtbNJOZqzbmf//kDGGk3g6wHGNqO4iQdAi9EOMOyVc=;
	b=Kds/fOkcVb+DyUP0FvNtnd1JpDve0L6N0tMlWWgzs2uuoeadu9ysxjltGqzG5Ti6Ltn/1F
	8uxB4gD579Kk1xlAZEScokmMADjghWLv1+FKACC8hde5sJPSnx8HgfZ2X43t/EzqCLnGaK
	zMf4MDY1qRSsMDUUK168SDEpa4PrfeY=
ARC-Authentication-Results: i=3;
	imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=XUTkKOFa;
	dkim=pass header.d=arm.com header.s=selector1 header.b=XUTkKOFa;
	spf=pass (imf25.hostedemail.com: domain of Justin.He@arm.com designates 40.107.159.32 as permitted sender) smtp.mailfrom=Justin.He@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1778743610; a=rsa-sha256;
	cv=pass;
	b=sGcPQ/UzLIiEndU6D8oyvdONSJoG9NCTEtS4iprr885GSUjCXPjxyvqx0jIBqpVZ9mCvMA
	c/DK/5qmJFR5GXV25q6+B0tB7mA1uCaxz/m7+95MVaklsL4nDOI6JC8oCG5FHCcn807+8R
	0OAd84mm10CN8NCxwE9ygrv7o+G8hL4=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=FG/Spe6kVAQKlfzBKePQMhKNZZ1qQ6pt+lwEDpdKLo4PrTqhuLEc7QPmYfZ2hkHLYbWr6Udr9FYO2B/Hb9vw4cbGR3KshMFiCeZrFOSNa5UZ+ne+oWXtrMJGmfmiLtPeg4EJA2DnHJ/Y8GQCjoq+egE4QIxpWV9bVKbjs69YIZhrx8uP+RcDXM/DiZUTON3lBPZ1yIF+nHSLmOsOj7puNwuNpZBZ7mNkEB9TCgYKfNpaEfqGtIhQVfG4i4sIX12s5xr0Ox0h9esYBlDz+1+DG2p8rmAD77guZ1NJnLaVyUSkJAtuggLjA/yf5arTFvkzeiZlTLF5QY1/V5jspf29AA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZqtbNJOZqzbmf//kDGGk3g6wHGNqO4iQdAi9EOMOyVc=;
 b=sHiOMObEJy8g9Il6mIyeBODbhuDDgTsvx5OVI6k80oBXxR8yU2E0qNEJPBPs6NA8CbugUrE5rYSngoWMdrI8wvc5Q49CS66HHNXOCej7GqwnsVczWc7Exn+1SbeyzXjX10WAxRUhTw2AVBvjaHADI8iJXdHTOsttVHPWG3UEAIsHiUq9qXOPKDq4zoVgwTwexRh6w/ty50tYbZxT4D5i47j0y4z6CI2cdiY4PDXBgUwQww4k3fkcyhymCUycQdxjfRm5f9Pbq2hNPfbk2UPB8/wV94ZAJLI+YFvCEJu5PUv8hcMEg2SsNLXtlKWLNkrie/G6MysNL18akSGjsoDWXg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=linuxfoundation.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZqtbNJOZqzbmf//kDGGk3g6wHGNqO4iQdAi9EOMOyVc=;
 b=XUTkKOFa/PX6RFvLAJqLgCNoi25c/9jkNirlFiRX72zDO2jLaN7cMYrC3/qKwLYJZk9jokmli81vK2/QvDbSckhtsAOBAY5hqOU4oGcPgDLtl9VvcKD07ZO2hm6UagezwmJw2n/VhWJ6VVeY4vsFboMnFFvZjM3vZqzyE/pUb+E=
Received: from CWLP123CA0212.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:19d::18)
 by PAXPR08MB7648.eurprd08.prod.outlook.com (2603:10a6:102:243::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.11; Thu, 14 May
 2026 07:26:40 +0000
Received: from AMS0EPF00000192.eurprd05.prod.outlook.com
 (2603:10a6:400:19d:cafe::9c) by CWLP123CA0212.outlook.office365.com
 (2603:10a6:400:19d::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.25.18 via Frontend Transport; Thu, 14
 May 2026 07:26:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF00000192.mail.protection.outlook.com (10.167.16.218) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.25.13
 via Frontend Transport; Thu, 14 May 2026 07:26:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yV9qmz7B90jGxN5rPIuLP8FTnTgvu8TawDlga6atlKezpr0jroWqTdb0BchwkqiU71SUKUP86wV6FRL4ht+DT5pi09kxQMsDI69EgwjJcqfccEsRbFfRu8ctEBZEUgGWVSYiSJJg+nfbgz1/RGcRRuBFgM/zhOudvgyfCl8rszov7baad43uLMgBgbVoy57tuFy57sFYk0C+4d75Gs3OGa0GkvUmOHH1YglHisQ6Wt+fMNO2ciIfi5QiNVSigE3J6QH8nB5FB9GUm7FUy2ruIcyZ0aigsXWUHKSYg7DKm9SSJdvJioCYhZlHKQBDblWOX+xYnMkTSiEd6GRp4/TcsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZqtbNJOZqzbmf//kDGGk3g6wHGNqO4iQdAi9EOMOyVc=;
 b=L4Nf2L3mma1MeHgQqrpdAGZkbUWCXmNT5UT2DhNVNehTzKnuF0vRpIJc7RoiIQLUKO+7L3/eR7dCK+kOQSG+1jubOuYu7BkqmZerzhHvoBlVPNIG/GxzeAZ/0o+S3bSJ72lBonDHsQ7A4oWZ5ieOO8uzh0egQhFSSH3akxu2YYcZ96XFAEQjafbQeDOy8eKCxhxNaorMTFRZPKqle1TjgmCvz8y0o+J/MkZ4GK/mAh3k/M1ud2/AdyKxnbp2nAv0UNRohBg77I2ApL+op/85U614nzsQrdY9BX/BeQetAUnci6q5LVRSSicfbCNZ7kNoQqQ47S9P62g4foqusIPmxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZqtbNJOZqzbmf//kDGGk3g6wHGNqO4iQdAi9EOMOyVc=;
 b=XUTkKOFa/PX6RFvLAJqLgCNoi25c/9jkNirlFiRX72zDO2jLaN7cMYrC3/qKwLYJZk9jokmli81vK2/QvDbSckhtsAOBAY5hqOU4oGcPgDLtl9VvcKD07ZO2hm6UagezwmJw2n/VhWJ6VVeY4vsFboMnFFvZjM3vZqzyE/pUb+E=
Received: from AS2PR08MB9786.eurprd08.prod.outlook.com (2603:10a6:20b:605::22)
 by PAWPR08MB9995.eurprd08.prod.outlook.com (2603:10a6:102:35d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.11; Thu, 14 May
 2026 07:25:35 +0000
Received: from AS2PR08MB9786.eurprd08.prod.outlook.com
 ([fe80::d721:dfdb:2f83:155]) by AS2PR08MB9786.eurprd08.prod.outlook.com
 ([fe80::d721:dfdb:2f83:155%4]) with mapi id 15.20.9913.009; Thu, 14 May 2026
 07:25:35 +0000
From: Justin He <Justin.He@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-perf-users@vger.kernel.org" <linux-perf-users@vger.kernel.org>,
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
	"kunit-dev@googlegroups.com" <kunit-dev@googlegroups.com>,
	"kasan-dev@googlegroups.com" <kasan-dev@googlegroups.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, Arnd Bergmann <arnd@arndb.de>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner
	<brauner@kernel.org>, Jan Kara <jack@suse.cz>, Peter Zijlstra
	<peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de
 Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, Mark Rutland
	<Mark.Rutland@arm.com>, Alexander Shishkin
	<alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, Ian
 Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, James
 Clark <james.clark@linaro.org>, Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <david@davidgow.net>, Rae Moar <raemoar63@gmail.com>, Alexander
 Potapenko <glider@google.com>, Marco Elver <elver@google.com>, Dmitry Vyukov
	<dvyukov@google.com>, Andrew Morton <akpm@linux-foundation.org>, "Paul E.
 McKenney" <paulmck@kernel.org>, Petr Mladek <pmladek@suse.com>, Kees Cook
	<kees@kernel.org>, David Disseldorp <ddiss@suse.de>
Subject: RE: [PATCH 5/7] misc: reject duplicate names in misc_register()
Thread-Topic: [PATCH 5/7] misc: reject duplicate names in misc_register()
Thread-Index: AQHc41+fXfe8zsHjbkCNFtiSq8GzSbYNF+8AgAAGMPA=
Date: Thu, 14 May 2026 07:25:35 +0000
Message-ID:
 <AS2PR08MB97866EC459E6D0B0E80E48F8F7072@AS2PR08MB9786.eurprd08.prod.outlook.com>
References: <20260514050455.2954509-1-justin.he@arm.com>
 <20260514050455.2954509-6-justin.he@arm.com>
 <2026051446-glitzy-quotable-c4b6@gregkh>
In-Reply-To: <2026051446-glitzy-quotable-c4b6@gregkh>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS2PR08MB9786:EE_|PAWPR08MB9995:EE_|AMS0EPF00000192:EE_|PAXPR08MB7648:EE_
X-MS-Office365-Filtering-Correlation-Id: 6283b6f6-1a50-4e79-c569-08deb18a23c1
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|7416014|376014|1800799024|38070700021|4143699003|22082099003|18002099003|56012099003|11063799003;
X-Microsoft-Antispam-Message-Info-Original:
 5QjF0QaM5FV92ZAPojwzPl7JJ7vNAUp/kbnnZ7M5g9ehaEJFn25jyuE1JxRI+9hXVTSQVhNX0v7Fuv5eVz7n/gB/Bnz2Peg98l5YZA4lwZOtHEFBJ6ddfLoZofLeFrh4t1Cj2cEgs8dqZgm9jzl22aYNg+ck4ibAxwZ19ZMyYv6DN3/0XdsGtFzR0Fd+2twK3jFjFAvffjswuwb80ZnWOQ7RleAr5gsBzX9DM5Vbmt9g0gGFkIjYLA/2qPp5z75OQe152OcJKILBBSJ9YsztTHILKTFfNZlljp667BpFBy1dQJ6+/uOUjE+AnZfCZkYq9aqdDrJ98VSlkUziKjPBzdzTjsBpZnrOgsK3Z05KMgNuZe5wDujjf7YhScB5uAUMMPdS4y3roZS8FSSX7fUPnyrA2Zc2+x+wIJ1eFIjifpEIdk6w+Rf4nMG7tUl5gzU+sZjh2iwkHOKGPYv8ge+/vI+huBRTAiLN0rxeJ1y9HNO7v3PNInlB2ZjFrrIWpUsK9cT61coohjb3SmLTZtOCqsikHMy+VRMej38cUzbBxWGmunCieF5Khb2zqDapJn2h8zDE/M7UUQa64LaZ55zvIKEzSRrvqmgtjw63RIwxrfEgVB7TWlWSNvwFVLiEALexVPdHf3pse2pdX1UDUwQ+cNLCFbdnG0/kU6Hv7IkLP8HaD80ORKt1XJWGhl3xHsOSttTDZDG2bWbOr59XIMll8iz5efcKHL6fmwbFQTwAhb7kCLCA3mF+EwHBSrp642JY
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS2PR08MB9786.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(38070700021)(4143699003)(22082099003)(18002099003)(56012099003)(11063799003);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 v0FOFst5RAljb6BdANxEZWjWOqMhmKMbwJ80hiLPvzeOz2TX/GsqNS1e0YN7+DQ9LE0w0XV1Snhj85deDBzJfL6rDaKr6Z2aq4zwMdH4dcb07eS6yPCELklad7c3FUtlT7UGOnIDfqXMwRFjXBohUkmroW5JOHO/J8pS9XfqYPAdY55ibOg8AHzYWma1oYAlHbv+BCfKU5EKZfi3y57t+JRktuTgxuo/8r/Hb3fIZokY5RuQ6fod8zwYBrVnmhI8E6kjAv+zdsMtbyIaLL/c6ukQCTye5Rzgzmen7BncWErNnw7ZXnIqliAxkKGnxQ5eQnvxtdjRXluxuetW5XYgPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB9995
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF00000192.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	c6841df9-c6b7-4b0f-6cef-08deb189fd5f
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|14060799003|36860700016|376014|7416014|82310400026|35042699022|18002099003|56012099003|22082099003|4143699003|11063799003;
X-Microsoft-Antispam-Message-Info:
	acxCCoEarf4D2M6+lzU/cwHPzHSfKE6ADi2UyVGllUeyP2BZ1QDRuxVdEGmkJY9jaN8lSpNWUYeeyCXlABK+tejWWrAzZA1aBYB9Hm6whSEma+wSM7iJtJxmvE7/dd+qcOA8IYhGWfw4zzweySYPLLJm+CeMtgE3NjrlOqFmNUOi1jCQBC8O/GyYf9ChTXDaRbmB+M2bZl77CbE4wsj19tjnYt8jkt2NT2uEhfu9uJ3wwNGDsqeJjNEu/vJsYDfZ/vteI98vTZN5NEouFQIZFD1xI+KWdEazXBod9yhTA7pAw0ZCtD8wGCo+Jy22eg+AHZQrp4pobQnfhujpzZfC/owc1/vuD9q08s/a+lpsyDKBQ25cTNbzoxM7EMIuIME+vkfmLzmbztx6fGVDZcG502IDnUzadE7rfEs0vVhhQyR5KX+NunKKL+svg7w+5+nnhpyIGUxy2WFLmJ6THyqs13UOABNjWu2m9C37uXARcMIPjq6LRuI4Mk3QKMcp7wDFADgQUbptHvxj4IgZ5GeynpugjKbQFdq5aw9B0TxvBE6S4HiK761kYEcRhIyDtiA+XRd/Gvz1q2iLS1Jv+UCbCeSc84Jv2GTM4e5Rn1/pk+BvG7ufllxBw+hgWwkO531Mf4fztXqwAeGsVrUZFy8E1M69cewJWXsmtniGxeKUnXlFvfKkyaej+fzd4Hs5oYU2Ioqsozm6WJqTLeBNcxVZmmcpVdz/XL6YOOMwveKKE7c=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(14060799003)(36860700016)(376014)(7416014)(82310400026)(35042699022)(18002099003)(56012099003)(22082099003)(4143699003)(11063799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	qPCjVRANEzGLfuPp1FrefzTLWNwUR0zS3hWtc2IVwl3ygwksQqV8d3jX+HbIyc4Q5cj7HMnmCs/3w+NTZnSHd0pEMVMG76gEO0XDQVwHtojVcSByfjJddhJp0hKBdjeDX6g6ql2LhVxaFU5oYEpkvYl2bRcalNCrgoeqoH7uYdRihliohirWDpo/NREjgDIHWuGxIvUV1pl0+lQOJhusccXaLvOi2pkM9qIo9bZ9xxzEDl9r2w28JPhUnknMP8FKf8f1HWC0qmRqGC62MkfNf78PwA0sRdq0y8F+nxSxfywOzEAhuPYSg4Z/m59IN3XRafTZivK7mAyUS6nKugGUO5FZ2EtqkUIZFD9JtLUenUzJi1D11LYT9JNesRNxUyRU/9nknZ+YFmZvupK6sAQarL/X1uD2f6dc71phFUInYPSsM07QQULtfpprQW8mqk25
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2026 07:26:39.5724
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6283b6f6-1a50-4e79-c569-08deb18a23c1
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF00000192.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR08MB7648
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6E2F8A0002
X-Stat-Signature: cw9xsj9uf9yohhjm7e8hy7bjnebug1wb
X-HE-Tag: 1778743608-442422
X-HE-Meta: U2FsdGVkX19zplQkQ++yaJcyI9is8+Q8YvutS8ijJuDhkE4AJCpDphdbfRmAFyE2v+TRbtgDFq8uH9WCv8Bb74kzYqdyUcc9PrkB8isTFqjzlkwgto1ONshh6tkHHWUrXqpR0chtDucULrL+i/ubXa9RHJEGkewSiXXsoCnDNnr4hTleKFjeSfA7wlLR0fIxbVKFpEkyh15/yo1uTZ94GWg+tAVBJpXl3P4VnZp9GrD2WcFAwtGugLkJg+5JrC4Wik+xkRZb2juxoISbkeQjkwWPQEHIZkFOqgMTP0k7+HeV0bzbPawh+EJl5VyYRF0jMQCsio4+kYhiikj4g32rY9hNv9+5WlauyBBbOANa3fRlvLo1ssglAxh2ZhwK9v4mOt2XXLdHJg/Z5hJWTw37u7BgM0oD3gQ77vhBHWYubht05wQNCoQnOq5QiMI4r3uj/DwqDbT1rSX3zcs7sTRVnEUogfThCDzQ2MkBm3HXFZ0PLOVp3NU74ajICd2WAgKL9dJlQ/RA+NYC3VQihXMr/Nx52lRAOMThpa+ozZ2StXBF2JWjBo3K7/b9Lu/FvgWL84ys1XoPhYRrx8uNUYZ1apwkvFFJexV16Q1nf3HVZIth0sqWlZ7e3kmI1RghHsaCV4q9ovdOaVv08Eh/IZp98GqrJOHXV9EL4CBvGXD+O1luTjNEPD8EqzgaI+1epp2jSpL/F2OeHz9pq+9fHAMf95AU9Kn1GzNCeSBeJM0eF7SImRX0fGoQTGAz51dGl352/HhneHVHdT4+X9WSQB+zb8s2zqf5sDPu+pOTp6VubMKCPmV3Q0wkPwu+AuN9R3uwcIWBgAcFoYRVSuxHg1DSuIMdYPzLS1swg/MRPjI9fgg00nMXaSudRjG9/bqzFPBbTCauonAAGDr577QNCHLcaHr/Ay7X39nV4bzPi+hdMa/W11GI6PrvlUUVRs4Z/UWGbAFIMnmBAor68MQaQGL
 QdPul7jC
 mz00dZM5OZhVuMk4sAQlDAtpCdmyPajeC2RNIvwA9zibTk2JM/OHphdmLHmViYbAburQPbXwfrDiPb143j2Xvf/1CcDg2S7mgEAkuw0pM+/drsXKulsDwhClw2OLDRf7mVzDEqoDQuWsGsXVL9XnHDyoSu24GH04Z2Y1ZG0t2rK+yqphPTb6X2ReTFBS/j39SNthzFofff2YE36iEWJatolYpWuCgFN/10LeSFZsgj0Wv9En/6KvaQx6DxSr4+BQwMW6czfVOp3mwENFpLvy3sn2+vztvjH+EhAXZp5+Zcufobn0a5GX0ep0Dsf49gi6MazFwi+7ut+OSgOpAYquT+VqXmHfhf6ODz9NAnqMMSn9ovXAWffNTycflHyLnp4CG5qG58nwqjE+2ZjAdNjIvu4PNZH1FFsPu04Kr5igFnl7ZKKQtqwn8Tt2My1Y0yfR6OiBuyETLdDzvv9yeedNZe4EIE5Dmq7gUVmZJ58H8y4EH/+ZuZIpvKg+taiarsWxuSeAu/IFNuMQxHXKpbtOCuVarWDCco+V3uCElWjp9DyWuRw85qKzcbjlTsjrvBIogzdV7DucJ7vc9bdsxlmktdSe+5j7Amjz4Tkg4+J/4FbBrMfe0iGsVRdL8EMEQTGb5xNLA8ffjLl3jRU3je2O5rOfGlQwbgFQABV+MJJHQj9B1/FCR/PArveCRvM67HVztONlVggrbW7Hxb/tZymqaDOTcbW03zIHhfocaC8OiOov7OU/bb4Y0tBbMY+kbx8pmn7QFloUnBm/XSN9smWPn1mMj/dxNyDuPYGwj4ikWEs2I6sr4AyH8dN6RZUsrCWLjYsUa6XjzddyGv0bHaqPN+8xiROLhn3/8+3DBuSA8aj9QltQMnYEvaclTp7HaIvpwdI5rSebsQduULji/hgA8reUCspJuJ1f4xmZOuBg/wR6wXPE5Xo9mq/SLGFx8g9DVx9GXtEQTQKFgLS3fvjWEHcOXmNPl
 2e9ph57P
 BCjw+0Cg04dVtVzx9kcyvtVWpZimOjy6/AdBOoTeLdCyAYNp5G8STgCTI3OAibwu4mJJT873b4350lI/s+E0pIy7VtbY+C+FC5rvTsy92fpYUTYtude9Jh0668ZWnJKEWCDykLnVpzH64CiBUCukc+PXNTyspyydZr54vCtwF2MGEDvx8Ha3e/BKftVo3z/f6ohW13HfhUtd2zV6AKf6HMT7RStp1xe5RdeSZnS5DuKbYttRe4zL5R8gIlh9SSRT9x24vxMYQ0ExGuj61YH3WaLAQf/33LA38M9x2ob2/j4KvhfKkiHMUonRDbZou3TVOiKxpg3B+n6fi1MNU3KbakHPDkiH1sEUsg9H2Nw465M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogR3JlZyBLcm9haC1IYXJ0
bWFuIDxncmVna2hAbGludXhmb3VuZGF0aW9uLm9yZz4NCj4gU2VudDogVGh1cnNkYXksIE1heSAx
NCwgMjAyNiAzOjAwIFBNDQo+IFRvOiBKdXN0aW4gSGUgPEp1c3Rpbi5IZUBhcm0uY29tPg0KPiBD
YzogbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsgbGludXgtZnNkZXZlbEB2Z2VyLmtlcm5l
bC5vcmc7IGxpbnV4LXBlcmYtDQo+IHVzZXJzQHZnZXIua2VybmVsLm9yZzsgbGludXgta3NlbGZ0
ZXN0QHZnZXIua2VybmVsLm9yZzsga3VuaXQtDQo+IGRldkBnb29nbGVncm91cHMuY29tOyBrYXNh
bi1kZXZAZ29vZ2xlZ3JvdXBzLmNvbTsgbGludXgtDQo+IG1tQGt2YWNrLm9yZzsgQXJuZCBCZXJn
bWFubiA8YXJuZEBhcm5kYi5kZT47IEFsZXhhbmRlciBWaXJvDQo+IDx2aXJvQHplbml2LmxpbnV4
Lm9yZy51az47IENocmlzdGlhbiBCcmF1bmVyIDxicmF1bmVyQGtlcm5lbC5vcmc+OyBKYW4gS2Fy
YQ0KPiA8amFja0BzdXNlLmN6PjsgUGV0ZXIgWmlqbHN0cmEgPHBldGVyekBpbmZyYWRlYWQub3Jn
PjsgSW5nbyBNb2xuYXINCj4gPG1pbmdvQHJlZGhhdC5jb20+OyBBcm5hbGRvIENhcnZhbGhvIGRl
IE1lbG8gPGFjbWVAa2VybmVsLm9yZz47DQo+IE5hbWh5dW5nIEtpbSA8bmFtaHl1bmdAa2VybmVs
Lm9yZz47IE1hcmsgUnV0bGFuZA0KPiA8TWFyay5SdXRsYW5kQGFybS5jb20+OyBBbGV4YW5kZXIg
U2hpc2hraW4NCj4gPGFsZXhhbmRlci5zaGlzaGtpbkBsaW51eC5pbnRlbC5jb20+OyBKaXJpIE9s
c2EgPGpvbHNhQGtlcm5lbC5vcmc+OyBJYW4NCj4gUm9nZXJzIDxpcm9nZXJzQGdvb2dsZS5jb20+
OyBBZHJpYW4gSHVudGVyIDxhZHJpYW4uaHVudGVyQGludGVsLmNvbT47DQo+IEphbWVzIENsYXJr
IDxqYW1lcy5jbGFya0BsaW5hcm8ub3JnPjsgQnJlbmRhbiBIaWdnaW5zDQo+IDxicmVuZGFuLmhp
Z2dpbnNAbGludXguZGV2PjsgRGF2aWQgR293IDxkYXZpZEBkYXZpZGdvdy5uZXQ+OyBSYWUgTW9h
cg0KPiA8cmFlbW9hcjYzQGdtYWlsLmNvbT47IEFsZXhhbmRlciBQb3RhcGVua28gPGdsaWRlckBn
b29nbGUuY29tPjsNCj4gTWFyY28gRWx2ZXIgPGVsdmVyQGdvb2dsZS5jb20+OyBEbWl0cnkgVnl1
a292IDxkdnl1a292QGdvb2dsZS5jb20+Ow0KPiBBbmRyZXcgTW9ydG9uIDxha3BtQGxpbnV4LWZv
dW5kYXRpb24ub3JnPjsgUGF1bCBFLiBNY0tlbm5leQ0KPiA8cGF1bG1ja0BrZXJuZWwub3JnPjsg
UGV0ciBNbGFkZWsgPHBtbGFkZWtAc3VzZS5jb20+OyBLZWVzIENvb2sNCj4gPGtlZXNAa2VybmVs
Lm9yZz47IERhdmlkIERpc3NlbGRvcnAgPGRkaXNzQHN1c2UuZGU+DQo+IFN1YmplY3Q6IFJlOiBb
UEFUQ0ggNS83XSBtaXNjOiByZWplY3QgZHVwbGljYXRlIG5hbWVzIGluIG1pc2NfcmVnaXN0ZXIo
KQ0KPiANCj4gT24gVGh1LCBNYXkgMTQsIDIwMjYgYXQgMDU6MDQ6NTNBTSArMDAwMCwgSmlhIEhl
IHdyb3RlOg0KPiA+IFRoZSBtaXNjZGV2IGt1bml0IHN1aXRlIHJlZ2lzdGVycyB0d28gbWlzY2Rl
dmljZXMgd2l0aCB0aGUgc2FtZSBuYW1lDQo+ID4gYW5kIGV4cGVjdHMgLUVFWElTVC4gVGhlIHNl
Y29uZCBjYWxsIGN1cnJlbnRseSBnb2VzIGFsbCB0aGUgd2F5IHRvDQo+ID4gc3lzZnNfY3JlYXRl
X2Rpcl9ucygpLCB3aGljaCBwcmludHMgImNhbm5vdCBjcmVhdGUgZHVwbGljYXRlIGZpbGVuYW1l
Ig0KPiA+IHdpdGggYSBiYWNrdHJhY2Ugb24gZXZlcnkgcnVuLg0KPiA+DQo+ID4gV2FsayBtaXNj
X2xpc3QgdW5kZXIgbWlzY19tdHgsIHJldHVybiAtRUVYSVNUIG9uIGEgbmFtZSBjb2xsaXNpb24g
YW5kDQo+ID4gZnJlZSB0aGUganVzdC1hbGxvY2F0ZWQgbWlub3IgYmVmb3JlIHJldHVybmluZy4N
Cj4gPg0KPiA+IFRvOiBBcm5kIEJlcmdtYW5uIDxhcm5kQGFybmRiLmRlPg0KPiA+IFRvOiBHcmVn
IEtyb2FoLUhhcnRtYW4gPGdyZWdraEBsaW51eGZvdW5kYXRpb24ub3JnPg0KPiANCj4gVGhpcyBz
aG91bGQgYmUgQ2M6IHJpZ2h0Pw0KPiANCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IEppYSBIZSA8
anVzdGluLmhlQGFybS5jb20+DQo+ID4gLS0tDQo+ID4gIGRyaXZlcnMvY2hhci9taXNjLmMgfCAy
MiArKysrKysrKysrKysrKysrKysrKysrDQo+ID4gIDEgZmlsZSBjaGFuZ2VkLCAyMiBpbnNlcnRp
b25zKCspDQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9jaGFyL21pc2MuYyBiL2RyaXZl
cnMvY2hhci9taXNjLmMgaW5kZXgNCj4gPiA3MjY1MTZmYjBhM2IuLmQ2ZmZhMjFhYzQ5NSAxMDA2
NDQNCj4gPiAtLS0gYS9kcml2ZXJzL2NoYXIvbWlzYy5jDQo+ID4gKysrIGIvZHJpdmVycy9jaGFy
L21pc2MuYw0KPiA+IEBAIC0yNDgsNiArMjQ4LDI4IEBAIGludCBtaXNjX3JlZ2lzdGVyKHN0cnVj
dCBtaXNjZGV2aWNlICptaXNjKQ0KPiA+ICAJCX0NCj4gPiAgCX0NCj4gPg0KPiA+ICsJLyoNCj4g
PiArCSAqIERldGVjdCBkdXBsaWNhdGUgbmFtZXMgdXAtZnJvbnQgc28gdGhlIHN1YnNlcXVlbnQN
Cj4gPiArCSAqIGRldmljZV9jcmVhdGVfd2l0aF9ncm91cHMoKSBkb2VzIG5vdCB0cmlwDQo+ID4g
KwkgKiBzeXNmc19jcmVhdGVfZGlyX25zKCktPnN5c2ZzX3dhcm5fZHVwKCksIHdoaWNoIHVuY29u
ZGl0aW9uYWxseQ0KPiA+ICsJICogZHVtcHMgYSBzdGFjayB0cmFjZS4gQm90aCB0aGUgZXhpc3Rp
bmcgbWlzY2RldiBrdW5pdCBzdWl0ZQ0KPiA+ICsJICogKG1pc2NkZXZfdGVzdF9kdXBsaWNhdGVf
bmFtZSkgYW5kIGFueSBjYWxsZXIgcmFjaW5nIG9uIHRoZSBzYW1lDQo+ID4gKwkgKiBuYW1lIHdv
dWxkIG90aGVyd2lzZSBwb2xsdXRlIGRtZXNnIG9uIGV2ZXJ5IC1FRVhJU1QuDQo+ID4gKwkgKi8N
Cj4gPiArCXsNCj4gPiArCQlzdHJ1Y3QgbWlzY2RldmljZSAqYzsNCj4gPiArDQo+ID4gKwkJbGlz
dF9mb3JfZWFjaF9lbnRyeShjLCAmbWlzY19saXN0LCBsaXN0KSB7DQo+ID4gKwkJCWlmIChzdHJj
bXAoYy0+bmFtZSwgbWlzYy0+bmFtZSkgPT0gMCkgew0KPiA+ICsJCQkJbWlzY19taW5vcl9mcmVl
KG1pc2MtPm1pbm9yKTsNCj4gPiArCQkJCWlmIChpc19keW5hbWljKQ0KPiA+ICsJCQkJCW1pc2Mt
Pm1pbm9yID0NCj4gTUlTQ19EWU5BTUlDX01JTk9SOw0KPiA+ICsJCQkJZXJyID0gLUVFWElTVDsN
Cj4gPiArCQkJCWdvdG8gb3V0Ow0KPiA+ICsJCQl9DQo+ID4gKwkJfQ0KPiA+ICsJfQ0KPiANCj4g
RG9uJ3QgZG8gYWRkaXRpb25hbCB7fSB3aGVyZSBub3QgbmVlZGVkLg0KPiANCj4gQW5kIGFzIHRo
ZSBjdXJyZW50IGNvZGUgd29ya3MgcHJvcGVybHksIHdlIGFyZSByZWx5aW5nIG9uIHN5c2ZzIGZv
ciB0aGUNCj4gcmVqZWN0aW9uLCB3aHkgZG8gdGhpcyBub3cgaGVyZT8gIFRoZSBzdGFjayBkdW1w
IGlzIGdvb2QsIGl0IHNob3dzIHRoZQ0KPiBvZmZlbmRpbmcgY2FsbGVyLCBzbyB0aGV5IGNhbiBm
aXggaXQgdXAgYmV0dGVyLiAgU28gd2h5IGNoYW5nZSB0aGlzPw0KPiANClRoYW5rcyBmb3IgdGhl
IGZlZWRiYWNrLg0KSeKAmWxsIGRyb3AgdGhlIHR3byBwYXRjaGVzIHRoYXQgc2lsZW5jZSB0aGUg
c3lzZnMgd2FybmluZyBmb3IgZHVwbGljYXRlIGZpbGVuYW1lcy4NCg0KLS0tIA0KQ2hlZXJzLA0K
SnVzdGluIEhlKEppYSBIZSkNCg0KIA0K

