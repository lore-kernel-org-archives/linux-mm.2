Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB524C53219
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 09:22:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB6B26B008C; Mon, 27 Jul 2026 05:22:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B400D6B0093; Mon, 27 Jul 2026 05:22:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E0EC6B0095; Mon, 27 Jul 2026 05:22:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6FEF16B008C
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 05:22:18 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F3121A17D4
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 09:22:17 +0000 (UTC)
X-FDA: 85034015514.28.9BFB63A
Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013062.outbound.protection.outlook.com [52.101.83.62])
	by imf12.hostedemail.com (Postfix) with ESMTP id EEA0640002
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 09:22:13 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=IDbBi2EG;
	dkim=pass header.d=arm.com header.s=selector1 header.b=IDbBi2EG;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf12.hostedemail.com: domain of Usama.Anjum@arm.com designates 52.101.83.62 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=3; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785144134;
	b=Hf/N8ugL8T2/JF2lCvy38nPd2eFkTTPpWnjnJ5v1G8IJiH95KalxLgli++ks6H4e+AC6ma
	1PyIl6qhxZaQqPS8hjeiLgqv0dxWz9c8XWnCBKecpu/ZdRPahVvYmmBzcI5Kt/xY50zvLA
	Nc7UfSFCx3x6YhbuyF8cqFvz4DMvbCo=
ARC-Authentication-Results: i=3;
	imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=IDbBi2EG;
	dkim=pass header.d=arm.com header.s=selector1 header.b=IDbBi2EG;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf12.hostedemail.com: domain of Usama.Anjum@arm.com designates 52.101.83.62 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785144134;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Voa+sWq8kVJ+bPMP5AKFdeQle8AeqGSzU5/PyWhzmLc=;
	b=45X+cmsC/I5DXRsetlu4YK11hSr4dtWW0DgIvc/6xY5ZUR8p+3O1A2+r4m/GvbRxECo0jj
	8ign3PNIN/vOyI6XL3qryxcqDdy/9Cs/okWoaRpgRu7dPYtWSOyfgneMpPITlYag/EfFA2
	W+Hjy598RysrrJCkViLNQ2xsYOzUino=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=hD6aCbHlywjoDyn0EoSQMYBljMarSLN4uSIVoCY4BdEZBIkovcfTUmOeF3xr0PRa8u7rF8rQSMGcGW+qKzUCl1+OLli6SzUZZxpIB4tx3JxXPUipLfCVnv/uNIbwWsnE94pFHWDZvf+CKjZxx0HG+jY9A+KABreTbHxXcFAhn7eZUqqYjyUP3mC219OkQA/Ku+PCSM8alq0FTyMrYjatxJnFGybSIXBPOOCBBkHhJLNGfVJ9oc7Syby6CXvCSDp+V1xrTD9eAZ9FcnG5ip4QuxqQY4ixI7R7TGqtLPMMl7IUPD7szso5Rj5oIJA/evYe7glkrA6Q0ramDKRGeXoUmQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Voa+sWq8kVJ+bPMP5AKFdeQle8AeqGSzU5/PyWhzmLc=;
 b=y9V+J8eOH7l1t8ZxCwajZPb+9pIofmR2FQmbC8JQv+mU0pQaGRLcU3a6EZWxCEV+nhzhNEr1cOfayy8lsVWbhkjUJKFTtXnyKpMohfjqKTqdMql7kGQiifUumUAI/aXVhKyGggmEJK87fbCM1GkHXKO6NybzP+nrq0D10psT3KUEXaPy4psqR4puGwq26w/8mzYi9zBgWqaad1V34D1y3FRY7QfImSOWr193fgt9riIXYd3akB2+NRHptEjMcdhp4MEsr9Ctf9P71SZTeq9KmnVV7XdCoPnfOuXmndT7iYOE8j8RdnXBETJQ9K83+GX7D9Ef702kpmsLj8vvKwzQbg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=huawei.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Voa+sWq8kVJ+bPMP5AKFdeQle8AeqGSzU5/PyWhzmLc=;
 b=IDbBi2EGjG3JEjP/DbyUTiy6z3a+LQzqvDe/aT9nYRPnOD8/yEZdL+cEP7DdnYsVYrjexnjEtEVHsjytpDgN7pXPnPP3z8q0MyzE5x/GUd2fG4jMd+3RX40+yf9YIK5aJjcI20T3epMw0Aryxoe00jNo+3p3DpanfFf9Py/nYmU=
Received: from AS4P191CA0028.EURP191.PROD.OUTLOOK.COM (2603:10a6:20b:5d9::20)
 by GV2PR08MB9421.eurprd08.prod.outlook.com (2603:10a6:150:dd::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Mon, 27 Jul
 2026 09:22:07 +0000
Received: from AM3PEPF0000A78E.eurprd04.prod.outlook.com
 (2603:10a6:20b:5d9:cafe::5f) by AS4P191CA0028.outlook.office365.com
 (2603:10a6:20b:5d9::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.13 via Frontend Transport; Mon,
 27 Jul 2026 09:22:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF0000A78E.mail.protection.outlook.com (10.167.16.117) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.5
 via Frontend Transport; Mon, 27 Jul 2026 09:22:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MS//qpvEXFcBxBC+BGE1+qu+N4ckXdHf/yQHM8BSwCQPXvx+KG7s47MEuXjrxxLNaqDry0AnQzglVMd4U1DhKrZ5BzFOEaovyWVdECEaAmZygD2L+94IPhV/7XIiTQeYaWEqTKqtYosdXg/L+2VaCz5ge0aK26lvLy2brArtXIPuD82znVn7sH7ZvPscKyvx7ivcICGYZ5ubcmKeFrlEv8rPiklIkyxgHsPSozQ0r1Ua84PSMDcXl/18YyoeW+F+7bYSzGGZ2w080wMqpdEkok7m0m3fc1QgO7IzC4pfei1KSd11B0rHV8EdK3U0VpIfhgVMrLTjL+0lYg1x0tL4Lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Voa+sWq8kVJ+bPMP5AKFdeQle8AeqGSzU5/PyWhzmLc=;
 b=deBI4zeK4E3sCutiIUnhUTH7dzIs7gJWvF2slAIx3DCxRHgWp73VGSRBL9mJEp+7l8wNfiJ94U2SsJb+QLeIS8V5WT9Uaz/DrQB7T4Eu7oiO3Z2uPhoFhSEVfNb6GmamKDg3V6f8n/Si6qYk9AlHgXCtTUNpXUFQQO7n0fsDSIs0DD0gSerlVtOHJ2CBByWQT93ViiqfkfsZ2SNShReWTMbrPSHEmcyobserwEOuTiIdkLi2WR+Av/xeQ3KI6BhI5yoEU80AQuX474vIwubxTPJ334l14VtusMEx6jfP+m38udcTiS7HwJY0UjD3dbGGAZtZThkRkbcd01jp1jyYRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Voa+sWq8kVJ+bPMP5AKFdeQle8AeqGSzU5/PyWhzmLc=;
 b=IDbBi2EGjG3JEjP/DbyUTiy6z3a+LQzqvDe/aT9nYRPnOD8/yEZdL+cEP7DdnYsVYrjexnjEtEVHsjytpDgN7pXPnPP3z8q0MyzE5x/GUd2fG4jMd+3RX40+yf9YIK5aJjcI20T3epMw0Aryxoe00jNo+3p3DpanfFf9Py/nYmU=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com (2603:10a6:803:80::16)
 by DBBPR08MB10481.eurprd08.prod.outlook.com (2603:10a6:10:539::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Mon, 27 Jul
 2026 09:21:02 +0000
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4]) by VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4%3]) with mapi id 15.21.0245.012; Mon, 27 Jul 2026
 09:21:02 +0000
Message-ID: <0ec4de92-5ddc-482b-98e4-9a26f9a6e622@arm.com>
Date: Mon, 27 Jul 2026 10:21:00 +0100
User-Agent: Mozilla Thunderbird
Cc: usama.anjum@arm.com, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 sarthak.sharma@arm.com
Subject: Re: [PATCH v2 4/5] selftests/mm: skip hard dirty page-cache test on
 NFS
To: Miaohe Lin <linmiaohe@huawei.com>
References: <20260724102431.1199519-1-usama.anjum@arm.com>
 <20260724102431.1199519-5-usama.anjum@arm.com>
 <57c6bec2-3135-35ab-46c7-b1ab041393c9@huawei.com>
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Content-Language: en-US
In-Reply-To: <57c6bec2-3135-35ab-46c7-b1ab041393c9@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0173.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:312::18) To VI1PR08MB3421.eurprd08.prod.outlook.com
 (2603:10a6:803:80::16)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	VI1PR08MB3421:EE_|DBBPR08MB10481:EE_|AM3PEPF0000A78E:EE_|GV2PR08MB9421:EE_
X-MS-Office365-Filtering-Correlation-Id: 9df9832d-4bea-4b3f-a8e3-08deebc0863c
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|7416014|376014|366016|23010399003|1800799024|6133799003|18002099003|22082099003|56012099006|4143699003|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info-Original:
 c26z0XKLRXuxP76/13PG4VFctFExHU9d10TQHmmDRVyIvwFqA9mg9m0i7xlDzRptP49laTCDj/lOXMSVSInjqxZjiSNucm6Ms9XbcSKzs2UkDdmJKuc8lHIyRlaWzlw6mdI9qkgiVgEJMHr9Sb2Vo4U6tp//G1lrK8X5yWkV0YG6h9hipeYby/oulh7kdyHftS01AxFxb8KQrTZC8nnFo5LMIm/R22QPh5R4N0FHxPRDfieUcq8KYlvw/pkvzKAO+x8t575qEfJEJokQzkG0jJXNWbupjhWZfkWLpna8KS2XAXi1l2nZlGKSlEg/3kIh6XZ7DHnnkWxEhBjB2GrGdOeQdBysY+3V6Ch7mWy7RkM1tclL/d2TICsr9MLQ0dGEl4JnvRXm1yjDjFe1QVOeLQootyhLvYUVg3ynLYU5ULxzSvJbT6t74PNGJ5iYnJf57IKCL0aYe7t6F7mVcCN+SvNdA+XanH5zY5p+IvlUJsDwFc6Omd9kLT1zEyaXE4hgoDyyxyfvdP2VjJ6k6oNL4FPTTZFeo40NGpeo2segHKYpsuNCZToX8rC+krR/4Y/Wy3rPkQgw1AjMtyXxlCvIulybe5bHXIRWMJNzTF8YpsH+8HuOUQmb4DtnybkR5ftl447uN4Bvnl+xYqpWGQfwgKgCxXgo0tmAilyEec+8kL4=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(23010399003)(1800799024)(6133799003)(18002099003)(22082099003)(56012099006)(4143699003)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 W/S71b0MVlWDjryFJtfWxCsED3YZXVGK1o4KNt711y06PiIt9F2lCRL6PzsYhPb2zSX9ZpDMVoSxPWDRTJUDICrvOAJyZAuLHY9xA/VH8JOiXrhJ0/QzEAWJbV2A60gAHeOoLsJdST2PkGjov8XoA1FRqYYC9dX8Blafo6b+v3NSUGOyNdAr26ducysqj5DZlvxAwlFqZbeokrXV9hRv9juhjidRGRkYACNqEVzVTue3SUH8vv23k/aESNCPexT/geTZG9sJYoYKg0WyqGBf6gfaAY+JpyKGpKIv/fCsL/MPClhXG+hGdZY4t1JfbQ/7IY1jv8kKOg3CrrocKGyaGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB10481
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF0000A78E.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	3fd616ed-0bb7-4a11-3365-08deebc06081
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|36860700016|82310400026|1800799024|23010399003|14060799003|35042699022|6133799003|56012099006|11063799006|4143699003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	DjwuI9Sog1jnMyVekKdl6w+nqa5p+mSA+7ob8CERVgsGY/0g0lMy5HRnKJeHGJ9bS8P2XAaRoB50yBo2FhQwP0kRI3DGRAzHybVBQ9d44A6zcR6R0oy3xx/x+qYE5TX/gr2fMW9igpautfTF2+1MJrkfEab19TaYouFjFV7YdE44phantxP9szxaoQtCyJP48a7yOs5hX2cCCdUEFQjxVu9aKrsG5m6t0t7sguzctuyPI1L+wY5D1SpFW+j7SmV0YFnRRoe18nyNGX0BF+Vk22Ir3u7xaVelI9c2JS8KgRH5gEghGF5v48NA1+HesAhF3bYGe+lpWelQkNgLBbax72VP3aLl41FmHocedHbhrcLPP1q5f5Z7A0bvB/48qJAKLUKM5mBpVyL1WHU8zyMgwTg56bmaR7byVls9Kfi7+M3hE0j6Bx2ytRA8cNMLeSKj8vHuW4gDkpaB5hvVSoGE+I3w69EjvYNbmvT9RbD5T3mTrilWOC5op1jkGTh1+dN8iXtZcj6MZAEFG1SoTKKShOtt/Uv0Doj4lvK68+u3z44CVdRQkaP+vFpQSlQAC7ir27M/n54/FcTx6sD1KyWgoy6r6ppLiuBoTYXlpmBiO8tVtm5d7z/tGVQt0qzGV7q7bYo8LTOJLI2ksW67gPOJPXRErHwTkX9MBfqHYmUAuvJxT/QbgJkNf1r0VqeuvExzCNwqt0ErmXf1JtUfmxCaCA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(36860700016)(82310400026)(1800799024)(23010399003)(14060799003)(35042699022)(6133799003)(56012099006)(11063799006)(4143699003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	L+zz4/JRidsU8dGY+nVRMIFPiFN+RU6np8+yZ/la7AW7SdZ+INL4ZMk79/Ydd8lEFC1pMgs6riFj7bywLFoulVRqR/ijKnvxLrUkEXeH2ng+qErioF/6fsZweghuAg+EZmrZsBa+E6bjxAXmKBzbSrXEFoWwIFk+o1PmRXDftngd3ckcPzeW0+oS3DqSY4iaQq0HiPnQSJJnBDPS5GZbyTz64HdQA26vzJgtMjKVGy1DIH6RGH81zML05vqj/FYccizBx5XQjW38SuoaNwHHqgYN4QmDDJccgX1pXHO0i2e8NaW55hXNQZjruUTaql/FCkbhs6WxuJwJaNPHSraeSlh13kMKcRmyb+lzvDYePjG0DvLzUe3PQgMwr6JPJiYB74QUbY46u0h71u7jlRSykk6oTksoBfjpHlbmfAkOxvzRC7ed/hw7Rknj4ArJCACo
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2026 09:22:05.0623
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9df9832d-4bea-4b3f-a8e3-08deebc0863c
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF0000A78E.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB9421
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: EEA0640002
X-Stat-Signature: uxs86szr3yegtayjksycfnsoojzp3ubg
X-Rspam-User: 
X-HE-Tag: 1785144133-891949
X-HE-Meta: U2FsdGVkX18pZ+4j5K/of/of/DSV/q3Mb5RKsYjDAkXk11cW1R7eSC/76rmup9hAFZKJSpC4eFTnVbErgWZblmpsasHRmeXx1p0yqwBm04JV/Vk170gEa7rEB8XM1tZs+NfbaoMqiTqdBzgSTO2a7toYG2s213DuR17hL6A4Ng07IX3A3YoHb9z8dsFy+/fAQKxONMy5U6kKCITQzP3RjBf/EkGae3fYDaMJmO/Klin+3Wasj3PM2+Y0RlXFeSxd1dFJ4rlsya+hHQQtGimIyWqzwL/IAl46ISoxY0bX4AiXPrfzIUz/6IxQwyc54nRJoNDKSrWJIVO5mMuPKGwmKGjv52HqzaobyjCrdc1YCZhgVPReocXvIx5jaEewySdllXU9e/MX7VWzQQmio6VsCFkJABKZZ5R9ggUr51WvSkD3OdCxpvC01eivgH8YFBNdebH+sulDF0347xxRWhwz3fDKM9/3oSbeOnZcaLuAhNiCePJRPsIwmSPHd0GS4ZuCDVtdOn5aDEDxmAbhifi/GQNWOXH1SX5ibgZVsJnGVrWl8lnyNEqd3vYT3i7Mz19mEt4akMXYP+IHGOM7+2HXF/qucwutWAuYuAf0SvsHuSEJRcWNeOCpJFOCK65/WkhXSQ3z3riQbBgt553GSpGlCBjOnmV3MbdbQ8E7pnHJ0CMufMFWh628Hq6alQoFLPzhBni4gtsLWbHZE3zA5LLywgqpDO/TwFDlqkgPUYcI5uWXOJcjadlq8jP+fxpp/I4An2M6iWq5kmohkIFUxAtguhAsSWSl2TCxX9sLTXKeLMzJSA1J/L8KwnXt8/U1F08GEP87LwVTYF/3FBI3/yLNa0SBsZ2aKzUTK95/f8DJNYTbzWJkZ5kaA9E1GI/FbUDKXr073Z4UsbHksev7ENO13bPrrbpCqg1bliszT1MnVEjfhI5DfwZrlcD6npSxnGO+M7C0FjBb9d/Q46zWjoL
 1LOYORAr
 JkyqJgGoZYMQu88MVw82+fiTJDL6SYG/qzI+vSKJruyVqJEy7j/mLbwBptM1RHf8mJ5p7MAsxbOr5FoeK7rnhIJtpkwSIzCKj/7GXGw6d4kmTd4lqP+Su7MNIfKhkzu8vkLUwGCRbDyGaVldmQ/xSkNqzaCLBmj1IHvEXiEnj31zGC+ogHSk2PCd8DPFMhBr84FmYxxJ+ojjh406Nlhuzpmw1PNNXoAYybWsxI/KccjWDF3C8849w72RooLWINwT4iRq//DUUAIguvAVJci7IPgTE3gqO7lwo8ODwq5my8rD9s73q2huFUFsDBcQGaeB0P7R/ZYPvL4zBKi5GDO9CRkamBJPBmgT10uaJ7CsnfSAHnsB3LXDvLpc/DXWs+z5/UJ/L+evPyVd0d8l9eAQ8YY/f5Hy48M+RNy0yT3+qMGDPss0HgRGPYWpJbdCCs9jYczODNIlyih5YDYna9B4wk1kvfb1EErD9Z8CMLOKdk6NyAdEboVl8o07k+4JZtkaQHYAYXXVj8Ib/NtYwVe5q3qpH86bVH5uZvPT7W8HNHCxDY1dYgb8IE0L/Gy3LgU6uQz6qyajU1wq/QU2QoZhwzajsAxCzKYYz3KfrcYKY8j2ubjzmTMVCP+YnEJtwfrkZiK3G
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 25/07/2026 3:10 am, Miaohe Lin wrote:
> On 2026/7/24 18:24, Muhammad Usama Anjum wrote:
>> The hard dirty_pagecache variant uses MADV_HWPOISON to exercise recovery
>> of a dirty file-backed page. The recovery path records -EIO in the
>> address_space mapping, which NFS later reports when the test closes the
>> file. This makes the test fail after the hwpoison checks have completed.
>>
>> Skip this variant when the test file is on NFS. Keep the hard clean-page
>> and both soft-offline variants enabled because they use folio removal,
>> invalidation, or migration rather than recording a delayed writeback
>> error.
>>
>> The unsupported-filesystem path in clean_pagecache() also returns
>> without closing the opened test file. Close the descriptor before
>> skipping there and in dirty_pagecache().
>>
>> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>> ---
>> Changes since v1:
>> - Limit the NFS skip to the hard dirty-page variant.
>> ---
>>  tools/testing/selftests/mm/memory-failure.c | 9 +++++++--
>>  1 file changed, 7 insertions(+), 2 deletions(-)
>>
>> diff --git a/tools/testing/selftests/mm/memory-failure.c b/tools/testing/selftests/mm/memory-failure.c
>> index 032ed952057c6..3c72084f57e8b 100644
>> --- a/tools/testing/selftests/mm/memory-failure.c
>> +++ b/tools/testing/selftests/mm/memory-failure.c
>> @@ -283,8 +283,10 @@ TEST_F(memory_failure, clean_pagecache)
>>  	if (fd < 0)
>>  		SKIP(return, "failed to open test file.\n");
>>  	fs_type = get_fs_type(fd);
>> -	if (!fs_type || fs_type == TMPFS_MAGIC)
>> +	if (!fs_type || fs_type == TMPFS_MAGIC) {
>> +		close(fd);
>>  		SKIP(return, "unsupported filesystem :%x\n", fs_type);
>> +	}
>>  
>>  	addr = mmap(0, self->page_size, PROT_READ | PROT_WRITE,
>>  		    MAP_SHARED, fd, 0);
>> @@ -325,8 +327,11 @@ TEST_F(memory_failure, dirty_pagecache)
>>  	if (fd < 0)
>>  		SKIP(return, "failed to open test file.\n");
>>  	fs_type = get_fs_type(fd);
>> -	if (!fs_type || fs_type == TMPFS_MAGIC)
>> +	if (!fs_type || fs_type == TMPFS_MAGIC ||
>> +	    (fs_type == NFS_SUPER_MAGIC && variant->type == MADV_HARD)) {
> 
> It would be helpful if we add some comments here.
> 
> Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Thanks for reviewing. Sure, I'll add a comment.

-- 
Thanks,
Usama


