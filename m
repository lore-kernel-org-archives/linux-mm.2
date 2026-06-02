Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BFB5CD6E61
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 09:12:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACF316B03CE; Tue,  2 Jun 2026 05:11:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA6616B03CF; Tue,  2 Jun 2026 05:11:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9955F6B03D1; Tue,  2 Jun 2026 05:11:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 875886B03CE
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 05:11:59 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3486F1C00CB
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 09:11:59 +0000 (UTC)
X-FDA: 84834405558.09.552302E
Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011005.outbound.protection.outlook.com [52.101.65.5])
	by imf02.hostedemail.com (Postfix) with ESMTP id D88D180006
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 09:11:54 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=lL6BezCO;
	dkim=pass header.d=arm.com header.s=selector1 header.b=lL6BezCO;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf02.hostedemail.com: domain of Suzuki.Poulose@arm.com designates 52.101.65.5 as permitted sender) smtp.mailfrom=Suzuki.Poulose@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780391515;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fb0D0KrKGhNBxmEk5l3OPWmNyHDGDePPvR9YDZC7L8c=;
	b=xwy3vBEJzhPd22A54Rbl/f2z2UXUiEry/+Qpl24CxDEomBSLeUf359mOyzb9stusj1ttQW
	0fHmnCLuvqgaPX6SnMmj2Iab157wahJsNm88L3vopyabhtgUhAOO5RktOfCx2L9rcMKNOR
	oTWAETfhPS+cTJiAJi0EarnWUbwxxDw=
ARC-Authentication-Results: i=3;
	imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=lL6BezCO;
	dkim=pass header.d=arm.com header.s=selector1 header.b=lL6BezCO;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf02.hostedemail.com: domain of Suzuki.Poulose@arm.com designates 52.101.65.5 as permitted sender) smtp.mailfrom=Suzuki.Poulose@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=3; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780391515;
	b=3HFaR3PSCIGlr3YevZ7N+DC3rOabgZetkwyp0NlqDF0aOrtFyvJA444kP4FqUmBvh4NqeX
	4pAVeyOMtP+brNvDa+2kF9rv2f41HurN3r7PeXWq6oE9xmPLHfaVv2S4M/MYkyiOJYCeyz
	+J9zYkNIu6K2QJsK6QVy+1YWatXaIZg=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=xwnCFLa5itRRG837Vg91jx85NE0oSotKQ2ypf9VZ0rTRPawJto0jGHssxSN/obimwOU/Z5d7+M2aSceAIAzDmOWYQJCGssQfA4ud+hXuq3CBzntrKFFcortLI+rhC9UZuVquaVHPppEQTLyKgaKZ3vVyR+6RgG+51AJWUU0BUqiAkw1uY+z7QpBUNZ08K6oOCpdmASY2c476mcznYFtrCELunRucvEoJvwzXPaIYiUxC9R59CRY+EvspwPL64OtjDGdfeadwYk33PRq3aRDdvRkgqByl++pZFFCVIMlJ5iTuWIadia0VZyZvlK6Lef1DqyCLdxYSvy2WsjN9rkJIqA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fb0D0KrKGhNBxmEk5l3OPWmNyHDGDePPvR9YDZC7L8c=;
 b=ZpQvr4bGcMNO/OC6kQOJ8ztZJLcaij1ZIrGrNaN9M0sw3oXEnTc9d+DS1vIh8wW8JVuWi3GCVZV0YaCwR7LB31AguIY9bm69H3dDMmIfpBEWhkU0fJhmcuSM6OyFJjIc61WPi5G69wwD4KC/3d4AGl9sRAEm767Wu7d5zwbpZ0msm/riXHPY4b2PdqSoLxwM4H0ytiRWm8w95PI7ggrrxssUYUfq2nAgb2w3D3Pe+pTK3id0qmCfIqPrW9hmTwud64rG4rBMlMFx9h9lzjxka/HrE1ZcMNtE3G9nxG82tGHicWo11tllgD2qOwUJSG3zXFZOL+iCVpz7tBZJrBJjsQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=google.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fb0D0KrKGhNBxmEk5l3OPWmNyHDGDePPvR9YDZC7L8c=;
 b=lL6BezCO3ZCXeTda9MbnIx/V8HgFKIXdYcUt95QGD5Qiv7jQ0tJt/DsCyHJjQ0NgyiOXChRL1daS4Cu1HA2r2FAucxpXkOg22n0fI6EP5QCVSqq5BVcyqkkGVL6qMp5g8xjtAkUja5KO7DyLAOWWauJvm+cSbIqZ8bdvzIdYeXk=
Received: from DUZP191CA0067.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:4fa::26)
 by DU0PR08MB8711.eurprd08.prod.outlook.com (2603:10a6:10:401::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.17; Tue, 2 Jun 2026
 09:11:39 +0000
Received: from DU2PEPF0001E9C2.eurprd03.prod.outlook.com
 (2603:10a6:10:4fa:cafe::c) by DUZP191CA0067.outlook.office365.com
 (2603:10a6:10:4fa::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.71.17 via Frontend Transport; Tue, 2
 Jun 2026 09:11:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF0001E9C2.mail.protection.outlook.com (10.167.8.71) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.71.7 via
 Frontend Transport; Tue, 2 Jun 2026 09:11:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k5t+QX80fOMhs+kEuHljheCPP6yx/5loeKM45JjTCLF12RaywnyL32/RGht7q4stpSpTQ7t+VmSvXXHLHSDEsJuwAcCnArrhnLIjbbB5QlJuBUfZDQodyXMYRh+eGNmR/gcFrGVOQvY7O/NlMYEsOPn7BXZ/PIWYpbB5GDfi2kQCvtRBDobZr9sa253uh33H2S4VKNt1ZXRRX4/tTcHG+cP2cLCNQupJ/svifCvjx+ENqxx5unNplHIxqskjzoX0HpPmJmJLf8o085SDxNsFamBhqFNMIQ8ktLchuTc0ylp09aror3MWOUV+NzX4N3H/let0AnkJYZ645xytEzbkYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fb0D0KrKGhNBxmEk5l3OPWmNyHDGDePPvR9YDZC7L8c=;
 b=nUnhF2grMFybCVEPodSo74gUzDlU0xmA2E3TUhYYeKGd1jPUxJjI+c/DbLXW+G3VgcOsIiGQICAw+oYgBGi3kpnCNja4xsYrlYpDq3DRmfz6QhqRmKa5b/PerAPWu+vHagiveAYtTBghKbtw8qCMWXe3Bgfghe0UR4qmb7pm5roLwutaFN1Ow7P7nHVe1gKy1MAvocEJukUjLUOuEk0sXfTx3fPBhqUbVxFtBucZs7B1pJm2JLseUFchjfP5OUgaDJ18JSVYfn7EFajBD9A1kppXTuruQjCBSbX38pB8DtkvrI9NYtkdKYzlFtN7wi3aDQaHmW9cfMIm9nOMaUqS0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fb0D0KrKGhNBxmEk5l3OPWmNyHDGDePPvR9YDZC7L8c=;
 b=lL6BezCO3ZCXeTda9MbnIx/V8HgFKIXdYcUt95QGD5Qiv7jQ0tJt/DsCyHJjQ0NgyiOXChRL1daS4Cu1HA2r2FAucxpXkOg22n0fI6EP5QCVSqq5BVcyqkkGVL6qMp5g8xjtAkUja5KO7DyLAOWWauJvm+cSbIqZ8bdvzIdYeXk=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from PAWPR08MB10975.eurprd08.prod.outlook.com (2603:10a6:102:46e::7)
 by FRZPR08MB10999.eurprd08.prod.outlook.com (2603:10a6:d10:13a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.16; Tue, 2 Jun 2026
 09:10:33 +0000
Received: from PAWPR08MB10975.eurprd08.prod.outlook.com
 ([fe80::3c7a:9a64:14bc:ce15]) by PAWPR08MB10975.eurprd08.prod.outlook.com
 ([fe80::3c7a:9a64:14bc:ce15%7]) with mapi id 15.21.0071.015; Tue, 2 Jun 2026
 09:10:32 +0000
Message-ID: <144bbb9f-39a2-4c90-8903-51521e022da0@arm.com>
Date: Tue, 2 Jun 2026 10:10:31 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 07/42] KVM: guest_memfd: Only prepare folios for
 private pages
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: ackerleytng@google.com, aik@amd.com, andrew.jones@linux.dev,
 binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com,
 david@kernel.org, ira.weiny@intel.com, jmattson@google.com,
 jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org,
 pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com,
 rientjes@google.com, shivankg@amd.com, steven.price@arm.com,
 tabba@google.com, willy@infradead.org, wyihan@google.com,
 yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org,
 aneesh.kumar@kernel.org, liam@infradead.org,
 Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
 <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Youngjun Park <youngjun.park@lge.com>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-coco@lists.linux.dev
References: <20260522-gmem-inplace-conversion-v7-0-2f0fae496530@google.com>
 <20260522-gmem-inplace-conversion-v7-7-2f0fae496530@google.com>
 <d01cf1ec-b85d-4af6-9810-8107c0e2a4ec@arm.com>
Content-Language: en-US
In-Reply-To: <d01cf1ec-b85d-4af6-9810-8107c0e2a4ec@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0273.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:195::8) To PAWPR08MB10975.eurprd08.prod.outlook.com
 (2603:10a6:102:46e::7)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	PAWPR08MB10975:EE_|FRZPR08MB10999:EE_|DU2PEPF0001E9C2:EE_|DU0PR08MB8711:EE_
X-MS-Office365-Filtering-Correlation-Id: a80b0a3a-2b8e-44e7-c9ef-08dec086f46a
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|7416014|4143699003|22082099003|18002099003|6133799003|11063799006|56012099006|921020;
X-Microsoft-Antispam-Message-Info-Original:
 l8Rfs5PkFu4rGFjSRWn1dpEfnmPrtAtMnLcnbAdPrwF5XIU7zT91LRiQGSC6C9L8FL/bMrVNnU5ciSFdnNhzLGKCL0gJ8HymNmeiGBuu/0NUQ7T4asfCpLw0ZCYM6zMLM3WyEQyGVYlDrkRhqxs3AA3gSlJ2YBBBBzjp+3+sqARlKtW3zD+OnjhZOH4IY7gheh42vasD+K07vAJTb126uDXDmJLe9/8klQ7yLDSyxQQapeHkrVZCGHruKyMHslJly64Zb7lZWY8pLj3jpjLVEmZAOSiQjWu/1CFARfdCxbqj3WoZ7t2b3j/ImV35jPAeZPYpxf+IBCKrmYTAfMf3DQBgPnH5GrLOnZpKObjQVKEcsWzUftU93g8qTPMsbk93AVe8vc3cAQeI0JXJTG2mvRVPT6LMpNeHl0PbJa8VXg5cYE0GKhjN/Fv0XK5OWV4C+tT8KZZMG9dNAgOKBlMulOop5AcVXAktPAY/G5RZ7LvxBLhm0c5zt/otmbFF8SRa/yHc0qIr8Pf/kr7cai3Xc9LfSTrny1QSg/OBeIaxjDTebsHIABdegNkjU9OGx+te1Qc8kKQZ7wfbgoA/BambJpNrNCmBucAGr54oOCZtF4uQbdZOoinhUkY/Z6umBgVmmkpHx0MvJRxObfbivAMB8zOVTDCFPxXTA5mqPuf/rvIjh4bOG1OhV510pYQEkC5rNVFDE04GCyB8uipDRH2KVxpRBdlP+L4Pt8OPslhXexE=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAWPR08MB10975.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(4143699003)(22082099003)(18002099003)(6133799003)(11063799006)(56012099006)(921020);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 Smh2c1FLMAKkYlCcWGkBMm50hsFfjZPUNbdMvb8pyK4Ze8fzd6T8I2cIV7hKyfXEeU8ZLBIkHRmU6XRbzy2y4CZgwPw3t/Y0nyqVetQ6dL9xlhPYJx1xZlJYudpwXPw0VmZ9M0r8TGx23dyxx6bCCB8WbVd+/kEXu0III9Zkemu3onmm+Yytksku2wPEXg20dRL7HfJK2PvG2D1fmO0MpIukVsAE1f6FuQaEZ+5CnjKmmq+t0KkymU6pffhZHjgAP45i5RHAtwHL/mtsw+rfuBGqLREfTz2oKt6cPo3Fk4yM+egwKVt/C/IiMY3KfyFUCdoQFcG7fLYT5eQfwFbK0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FRZPR08MB10999
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF0001E9C2.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	4745e14f-aa23-4307-fc7b-08dec086cccd
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|36860700016|7416014|82310400026|35042699022|376014|1800799024|56012099006|4143699003|11063799006|18002099003|6133799003|22082099003|921020;
X-Microsoft-Antispam-Message-Info:
	43ERN6MLba2lA1+Q1MLFWQIEFZT/oUTn5JJ4m/gzoI1NxKiKHNXwtbDeFblyFpm/fhicaAaR8gVRV0ebYY/Os9L08p1+kszKqxDdpz6MkOXWFJymzUHHUgHS2vOBoUfC4WTOgAB17VuM8xYDTF8OvRZw191smMM4aMXvuzihwi6PMFbtIMlFMXevuSmIPS23jqgBKot+yPJ9mTRn2vE+E1gt4MCfBwaYbSP4iJ/CV4a0MbEXYuCUk8ztyrTiMTHzQeRZsfEdTvLkUScxAAvJorpDbDVCfrV7c5wt33CinKSXgKNt7r17seS7zEUO/5aMNzi9lLy0tPMwhvamHZnrTh52FHb/tXGXsqtlt4ms13x1BJoXYctXClFV7jjju9HUngzaQwNo366FQ8Kr+2jwvla3Fu70DJ+lIToxhUZ/hR0QezG3D+7M3U9EmUQwlXa/gLzCJUEUuQxpb5Oq/Vzq9TU3/0tGM2SHKP3SmDoMfaJuw89ZOJHIawB/GGl9clGNczfXUflsnubpPnNVyivga491R538T5gRPM9rWomFo5QYgzbgv2HQq2xBSd6w5gd9Rz145mX5ULd4tHKrl7QzYN5f2dB1icO4MIA0CeeqwyI7DB2qqv/nE0oFY3ACHKSP1qP7W+8vCIivzMwji6XhWjGe+350dLK/XL1tx1HAWT5x7r3CvXS/MoKw+i8PyNq+XFY4D+dlr9Nq3ddSf4HVhzUv3M8t86JQCU7mpXLYIiYMC2TgihILukauGjt7QXsCQl6dk7h/67o9xY1ngEInlA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(36860700016)(7416014)(82310400026)(35042699022)(376014)(1800799024)(56012099006)(4143699003)(11063799006)(18002099003)(6133799003)(22082099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	X8s/AOyZfskLKV0Q4Aac0URIIuwejhACyqZoucAxyjFMdPmNpm90gtN70KjkbMGv8cQ+YsPfk53nxI6XaisRatzthm5lvMiqo+5SwYTbTa5zAPtZx0/BYRmQO0TCAWnz513xjLHYVgEzRz3QCkPxvUwFJ7PhziL5tTvoQTHBeYc5sDIBGcno9zkbIZild25kiiTWlxoARUm++LdVUWf+jRR3ht/EPppzKZZnWcT0m+NTgLb24WY6eWGza8SPyNc61GFupqTq4q1ctCv325Uf5W/aEAL5CrwBRMPLrF7SuYt4kWCdmrXncuj2dLBAU3LwCsxrT4lbPXqUU0z02X6tbCuwyyAV8lY7nxKSdKORvQVh2zlMo9Y2Cj/efC8g/bk+mrWPfBSFuAmB2HNIuQ0uOLUJwy/c1fEhB3orKBalfOAduH2HooyPpYXZkTb+AFW8
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2026 09:11:39.1186
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a80b0a3a-2b8e-44e7-c9ef-08dec086f46a
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF0001E9C2.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB8711
X-Rspamd-Queue-Id: D88D180006
X-Rspam-User: 
X-Stat-Signature: qtfnp641rbce6xka8hkhwhn76ttak53o
X-Rspamd-Server: rspam09
X-HE-Tag: 1780391514-521110
X-HE-Meta: U2FsdGVkX18dHGKhK8TbI/PQytZ5XIPj7LocWgd619AYlX7cvr29DV4drliAyOeIvgzDSFBKP3oWkHd/iSOfGgNUaefYSRvcj0qS+sHmx0X+Q0G4+sLyi9qIipO9JJk4GOFMCwI7bIL7X+MCj/hixvrWmjEbDp3zGyrbKMNMUToNeOOnfbg96iXwjaR++QF95Mi0gg3Vdvh+NyATdOBNB780rWXRnczZXszQtnXcfIUJdrHJzblHoA6g3JsUmNweC4iuo7OGWhpsxO/Heam2TlwUbafAsO4qoh/5JOQhKRdBjz04z2lCJNREajfVQX4dC6EYUuqhxCzXjwUE5BEJEKYZltRWs1d6EksdJb+/Oi/Kcwujjj5g4WBORAho0yZSGArT8Qme/EkxJhdo3VqBMXlVUEwxrwIdO2UDHycef9Fif4jepP8yQmDmhfNd/6ObHtKS/YfbcR5U6eU9dRRfswroe2T2dtGRZi5pTQvVt0COo9jxukkjg868+TABT2tCGJDTEBbHIDBV2Ow5ojuSee4kDxgMY8+IN7jMI1JiOVAWcY+I08PI0ojjXxD/8YplZdzYlx62+D9rdKaLMPd/oa0JTTbQYQlsoqRYlMCR+lkCWek3FJ2YQdGLuDcyk8KMtwKZc5g+cRz78KMOSsSoWOWBGaTn7Mk/XTa0kI6QxmFblJd6/nTCQzEj9t+LWP92D0DBtNoMKEx3xpsammiYpPZ3fBBKPGD8ylcQ9ZkcSa7NDng+wX2392p/8Au1FAjLxWYvLCPNwmWq+QisdZtwkXzrOX3XU/9NbMktqQ+YIXBXqkz36OPae1faJjhU5W7gdkKFNIc7Tc8mSrYOFSCcB38sqB3CQWIR4XIUPIrf/9CNNbX5WChJq5bWIXU5lGzPmm/ekzOTcd95urHAw3NvAmJo2jDnuRHDrSCLEl16CqdDK06NXWggo83GmWlZsPBvPSsbF1UNBZch2t8mxrA
 lGbyBo1r
 oZBJzGQLsTHA4dvMmQECjCp1EiIDCnn1SIUwyI3D0FiOvLF6F0NAhpB7pemBAB0+nRkh2C3B+To4bpWx4jy3zPsCgdvaZrbYnA4O1HpB623RwSzqWLSy8xcDoqihuIpLAQ//WCdWXi+KKRg/hcLrw23CHaxinbdiB2+ukl7yHQ6Jf256z66vF+wkJ0DsCEvAJV+JzdQGAEEf3TmTd5g1qeJQHSky962Z1xFGqzSHy7TzkCOsXVt1plUs9xxnsJCsbhfVFIF2oMKNUDeloqo/C8zKGSxa6pqiQSB0tez92SV2JxU4MWk1Ndaxg8R9rJEKJ5lPljhD+ZqdYfPYeOT+ujkekw07Thv+ofYSuDN/j5Uw1+JPzTQFRzI5Gzic3Nx/A9+EfI2Ip5Z3Xw7YGu1aeq7mBGb80PXC2OYA11sxJWiR+r9bObHs65R5QYO5ssfH73XPiWdUUl4Bkr/ak9Au0iWdoYrE0Uepbb59WAvDzwTr31UdTAmk+DFYuWswDqJxvUzglPOg924jtjTc2Vb3JuZm91A8yP14aJB/Fv48/ivLlBPG1szBE9qdwuaYnLzh/p3GG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 02/06/2026 09:55, Suzuki K Poulose wrote:
> On 23/05/2026 01:17, Ackerley Tng via B4 Relay wrote:
>> From: Ackerley Tng <ackerleytng@google.com>
>>
>> All-shared guest_memfd used to be only supported for non-CoCo VMs where
>> preparation doesn't apply. INIT_SHARED is about to be supported for
>> non-CoCo VMs in a later patch in this series.
> 
> nit: s/non-CoCo/CoCo ?
> 
>>
>> In addition, KVM_SET_MEMORY_ATTRIBUTES2 is about to be supported in
>> guest_memfd in a later patch in this series.
>>
>> This means that the kvm fault handler may now call kvm_gmem_get_pfn() 
>> on a
>> shared folio for a CoCo VM where preparation applies.
>>
>> Add a check to make sure that preparation is only performed for private
>> folios.
>>
>> Preparation will be undone on freeing (see kvm_gmem_free_folio()) and on
>> conversion to shared.
>>
>> Signed-off-by: Michael Roth <michael.roth@amd.com>
> 
> nit: Missing Co-Developed-by: ?
> 
>> Reviewed-by: Fuad Tabba <tabba@google.com>
>> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
>> ---
>>   virt/kvm/guest_memfd.c | 9 ++++++---
>>   1 file changed, 6 insertions(+), 3 deletions(-)
>>
>> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
>> index 78e5435967341..adf57a3a1f5dd 100644
>> --- a/virt/kvm/guest_memfd.c
>> +++ b/virt/kvm/guest_memfd.c
>> @@ -894,6 +894,7 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct 
>> kvm_memory_slot *slot,
>>                int *max_order)
>>   {
>>       pgoff_t index = kvm_gmem_get_index(slot, gfn);
>> +    struct inode *inode;
>>       struct folio *folio;
>>       int r = 0;
>> @@ -901,7 +902,8 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct 
>> kvm_memory_slot *slot,
>>       if (!file)
>>           return -EFAULT;
>> -    filemap_invalidate_lock_shared(file_inode(file)->i_mapping);
>> +    inode = file_inode(file);
>> +    filemap_invalidate_lock_shared(inode->i_mapping);
>>       folio = __kvm_gmem_get_pfn(file, slot, index, pfn, max_order);
>>       if (IS_ERR(folio)) {
>> @@ -914,7 +916,8 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct 
>> kvm_memory_slot *slot,
>>           folio_mark_uptodate(folio);
>>       }
>> -    r = kvm_gmem_prepare_folio(kvm, slot, gfn, folio);
>> +    if (kvm_gmem_is_private_mem(inode, index))
> 
> Don't we need to make sure the entire folio is private ? Not just the 
> page at the index ?
>      if (kvm_gmem_range_is_private(, index, folio_nr_pages(folio)) ?

Or rather, we should go through the individual pages and apply the
prepare for ones that are private ?

Suzuki

> 
> Suzuki
> 
>> +        r = kvm_gmem_prepare_folio(kvm, slot, gfn, folio);
>>       folio_unlock(folio);
>> @@ -924,7 +927,7 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct 
>> kvm_memory_slot *slot,
>>           folio_put(folio);
>>   out:
>> -    filemap_invalidate_unlock_shared(file_inode(file)->i_mapping);
>> +    filemap_invalidate_unlock_shared(inode->i_mapping);
>>       return r;
>>   }
>>   EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_get_pfn);
>>
> 


