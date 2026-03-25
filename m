Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D7DA109C033
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 16:26:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B51D16B008A; Wed, 25 Mar 2026 12:26:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADAAD6B008C; Wed, 25 Mar 2026 12:26:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97BB96B0096; Wed, 25 Mar 2026 12:26:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 809376B008A
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 12:26:58 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3A5BA160A53
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 16:26:58 +0000 (UTC)
X-FDA: 84585114516.09.53EB6CC
Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013051.outbound.protection.outlook.com [40.107.162.51])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2951E8001A
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 16:26:53 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=ZWWDbrqz;
	dkim=pass header.d=arm.com header.s=selector1 header.b=ZWWDbrqz;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf30.hostedemail.com: domain of Usama.Anjum@arm.com designates 40.107.162.51 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774456014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8CIkOvaocarvTHmx5EIWrkxb5Msenrzkq5S5YZ+vm94=;
	b=bHSLXj5NF+ThYHiFXn1ZqBkSYh9DnoJAvkRXygDD1UKwgtbg3J3oSFXFt9fL4z1eXqVcSL
	QR847I8vkwjD2MlaAowkW5Til8TtplbKjLaBR7BpVDm/r17oTjGyf4JPvnEf0661yiMOhn
	6VF9fEWcQmwKCSNA0Xn7j3K/qrR2QpA=
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1774456014; a=rsa-sha256;
	cv=pass;
	b=AARc2Vv36B41QSy+OMS/afCgnhQfzA/lHy40V4XQm/YVghtjohHoBrAInB4By2NE607WeO
	sNHAf6gYhiqSghpmSlmOEYwasabStP5yJFfk5zjX4vBoYRTZQPuTMRa6MFXFtvp5yaKzEs
	qLsQVPAURxyYteOEFrrfKsuK+Bk5eBs=
ARC-Authentication-Results: i=3;
	imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=ZWWDbrqz;
	dkim=pass header.d=arm.com header.s=selector1 header.b=ZWWDbrqz;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf30.hostedemail.com: domain of Usama.Anjum@arm.com designates 40.107.162.51 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=rBQeDav7DTe7baBaaRGO2gs/8LX/7IsphFjWxKUm80YLqPF88yvvpY2Bkkuvd5AP088cMrLj2JP6SkPqKy6CXYduLydgLbj3MOP2j/64EERLUN0GFOfAV8TvkrwOrchFux75h1fqub/3Ru9zEx8+wohh1nsqb1ISuv17HwK/jdZZON03Mj18vpx2nLhD0roqsY8TjoXxfwsXduhZSbgvvdoPjubEH9n//Ke2ZwflM8ndTDX6DV9yFlQ3X5CijLidw5mqCDokG2Ddl7EQj9oJXZyY+Qhs+PX02kSJU619ESk1om0YapZyt71+ByOKRUmOtSkrYQ8VW9KRWoMJlrwtBw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8CIkOvaocarvTHmx5EIWrkxb5Msenrzkq5S5YZ+vm94=;
 b=mDj8jZGiHhTdCb5ihKPeXrOb+7V95/llkXxrNrSDDCiooItzIxLPyo4z06Ch8Xx7pamszo/9kU/QMl0ddVznLg+KKndYPNBQ0VlIyNT1VT05wL3seJoyenm2Y1ObBpfZTrnXLpZjvLhUTm3FcKkV7CnuoZhnNrgyIsGa9s6q4Wqcu4CIvHcK22Fn2rUXoHaUMNeguZl1Kc0TGVAM2XxyG8yQUCfeD4YR1tKFBPhhfCdmJfhWJwI23+N1OEViFk/6J1fgOnaHdLWv6Ml0Lx3KWlbxeM9WmOGI1FOI7n/uqILRAeNMA7TyMTPBtS8rBZCnxlSTjTqVlGaZ/AtPiTdWPQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=gmail.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8CIkOvaocarvTHmx5EIWrkxb5Msenrzkq5S5YZ+vm94=;
 b=ZWWDbrqzGjsbc0tQst5ETSvOGf6muZLH8EcJg2e6u2J/BhiwCDOUeCgd6RpKjMUU8YFeMq7QrxZBMtxLMekqbAe2Xcc0M5SB94mNsDYjuUY2mdKm5Agb3zqQihj5quChq9lBAp9HlOHB1xZaPIiRooo0O7ky4fK/lm/2OSPDy18=
Received: from AM9P192CA0026.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:21d::31)
 by VI1PR08MB10074.eurprd08.prod.outlook.com (2603:10a6:800:1be::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.31; Wed, 25 Mar
 2026 16:26:47 +0000
Received: from AM4PEPF00027A67.eurprd04.prod.outlook.com
 (2603:10a6:20b:21d:cafe::e9) by AM9P192CA0026.outlook.office365.com
 (2603:10a6:20b:21d::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.31 via Frontend Transport; Wed,
 25 Mar 2026 16:26:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00027A67.mail.protection.outlook.com (10.167.16.84) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9745.21
 via Frontend Transport; Wed, 25 Mar 2026 16:26:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gUd3nbRPg7bmeyW6khcgPVsGv3xki+phQjjAVGtSHsfaMdqmSvqB+HgfJMLy4eRoklyz38xfBLXMGgPBiuaQ3UWOYM3PKsrqu22AiG5qdJFVO9B1JcfUSoghUCUPwudyDrkvM+HQrOGtZwHsi1hnWWs08stlXqJVo5gonVx8TMeu0+aOlBgLIA/BFOt8CicYqIoBRcwBc0zO1DUyH7NPUmSVtgjUC3hs2j72JpHtraOMpaIuLx8jpn4CBE9ZWuQv3A97LoOOBt/Yav6zMyvFh/sh4nRPSiJMAAvPXuAN262cQQBrRKzVOag4VlF/uAuCoL6Jdhws023XLST+NCzD0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8CIkOvaocarvTHmx5EIWrkxb5Msenrzkq5S5YZ+vm94=;
 b=et8POq9lsedRdkwhf7hAmkj5pVQ2asQnoLNvluHd3YMgix+zr0jnexhdRTga09TpI2P84VA/aF/5nleCie+wGNg/1VPx0DNYQS0LRYia5LtV3fgVT0vLUNNUVgY+8QezsC6gWpLEKv94Fdm6eVj0p1Jq62Pvx59HcCSCkun+Xx5yjbe54TyFaLAZ+P2vCzIrWqyqdEc8C8iWVXFN3YyV/QgZft3g0oJEuWGZKBpkvtel9suMWdqPb8EIx1sv7E4V5+mG+0zbWyo6DhLyTGGIiViHb1GrAOB3jjiBWW72LQQ1gZGUzLMe70RAOq5tp+Vn62iBmKQY7rVyh8JZ9sA8UQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8CIkOvaocarvTHmx5EIWrkxb5Msenrzkq5S5YZ+vm94=;
 b=ZWWDbrqzGjsbc0tQst5ETSvOGf6muZLH8EcJg2e6u2J/BhiwCDOUeCgd6RpKjMUU8YFeMq7QrxZBMtxLMekqbAe2Xcc0M5SB94mNsDYjuUY2mdKm5Agb3zqQihj5quChq9lBAp9HlOHB1xZaPIiRooo0O7ky4fK/lm/2OSPDy18=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AM6PR08MB3414.eurprd08.prod.outlook.com (2603:10a6:20b:49::10)
 by DU0PR08MB9534.eurprd08.prod.outlook.com (2603:10a6:10:44e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.31; Wed, 25 Mar
 2026 16:25:42 +0000
Received: from AM6PR08MB3414.eurprd08.prod.outlook.com
 ([fe80::dde8:bf0b:1dc:2a2]) by AM6PR08MB3414.eurprd08.prod.outlook.com
 ([fe80::dde8:bf0b:1dc:2a2%4]) with mapi id 15.20.9632.017; Wed, 25 Mar 2026
 16:25:42 +0000
Message-ID: <84f14a13-6236-47ef-afc5-e168d16caeec@arm.com>
Date: Wed, 25 Mar 2026 16:25:41 +0000
User-Agent: Mozilla Thunderbird
Cc: usama.anjum@arm.com, Zi Yan <ziy@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Nick Terrell <terrelln@fb.com>, David Sterba <dsterba@suse.com>,
 Vishal Moola <vishal.moola@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, Ryan.Roberts@arm.com,
 david.hildenbrand@arm.com
Subject: Re: [PATCH v3 2/3] vmalloc: Optimize vfree
To: Uladzislau Rezki <urezki@gmail.com>
References: <20260324133538.497616-1-usama.anjum@arm.com>
 <20260324133538.497616-3-usama.anjum@arm.com>
 <1D88CFF0-8A74-413F-9A6A-39E27B760AE1@nvidia.com> <acOjIcqyIVY9KNn0@milan>
 <a79ff8ba-ed4a-43d0-9c4b-d2883a5c48e8@arm.com> <acQKZBqTjpm6-k2f@milan>
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Content-Language: en-US
In-Reply-To: <acQKZBqTjpm6-k2f@milan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PA7P264CA0134.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:36e::16) To AM6PR08MB3414.eurprd08.prod.outlook.com
 (2603:10a6:20b:49::10)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	AM6PR08MB3414:EE_|DU0PR08MB9534:EE_|AM4PEPF00027A67:EE_|VI1PR08MB10074:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f4392cf-4d09-4370-c48e-08de8a8b4f87
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|7416014|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 KV5s71LQSTvED9E8H/qpDWeo5vmrBsDWJzRJ41ndMHeF0qZ80FJl+VG9700mtqncz63sr/xPtG7Ah4UR2wcLIxRiIFYm8flXxWWIOS4aLr0XqIo52TRlkfuQEzYBvQQNUAIFElDPq5gIG4UQVxd44dRTf2O36bSUAO8jo1GDX+PjqjgqHieem2AayKecaXBKlDntGZdDwN/ZWwWxqcHgFOd01bfQeAGfmX9nBQfvq42gVuy8stcolXZlqh9CsmpmgpgwsMoztZ6/Jeqmwvl8ctXCFYYZQ3ztCT6YE1nFrZOuEGZV6ejOEgpBwjv4FL7bDItLT321ONNhdlyxeCVKhi3oT3MYg6JklG4rd230DQDJIlQUT3R0yuFuNs8xrHTZc2CpwwpZv/3aBXkyX5va3Z5V21pr+ZqHA1wQVIFYplcSHCwzQcHAYV6DWU6zlWmZxlmdQOERe913E1DLNCdLPwxbgSYPUYpvGPOgXEGTIoAW6XNhGX6UywtOOYnzmEwx8d8oXtKIOcQgLRwqmlXxePyspyBWs1G4ckxiKpJmUuCkJurY0y6JqicTmWDBwdfYz3w9ssmXcsBeZsKSoCXEDRsxXoInQ7Vs+SbBBL8s4+w+wWIzMiov1yM/OJ9J+LUDGV77LiHgh2LUtdthT+rek4wBIrXzyDvryiVSTXQN9zC4aOmCXEjyovOhIjpnPWcz
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB3414.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 kdpkqCCC9zjx2dEFLmDR9OAkRZd+dKI5vn5xNmcg6EQIQoGF2lYh8QsZtegT3kvmAu2khPnO9PAdBh+3MHRWJHuislBxwo8ftl9BtF95QM2rM0if82wq36YXRgME+q3HunEbhrTII1lqLGDxt65RiGY+52d5efdVW9A1GakhBuhqfxJj97j3UbaS2+ZrAOvF6bquUQ7O7ilU5oBofOPgDLFofb13On9lUfwSveMJmtRy8GZXLlOxayaaArQUADfpgSWRf3mOKvmPOSSDUAtZ4H7u9IRTvN8d3iJzmLm/5KoEe3thwjlnS5okQ421I/C6QxfrQVskI7sKTPe/brKhLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB9534
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00027A67.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	87462f40-6a0c-4c5a-f28e-08de8a8b2900
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|82310400026|35042699022|14060799003|376014|7416014|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	49bN3IUx5buya+W5DEzMNPj7wI3XXGS6ROqn5tyN3LZ6ZlDHEr01BOZh9y8L8hyP4fX3lML21SmR5td6icCJ+Zyls0gUl3IPvavhg7fiCblP6Soq8DCE7tKWo0dCNzZIXgx9S6BVVYKqzSI85jko5CA6qO1WRQUp/o5+Gv9OM0TgojYrucA46eTeV3ry2aiGVXDbuAo3NRMwweAKmxAw1SGqhEdUDSY6P48jTdlCwmEiON7CcFy6CSgFcwwGsfDH79pCqZJsBiXeTIgUxNh6YbDHAFt9xNBeBopXYPlwnf54H46EJYpSxNcIOSuI8DpmXJtX93OdiQAc2UNV3PaI2lN2jDvICCs2NL0sMIZXGKE7vYxG+pxU67jPTH/wCC0/qOk5bzHNugwFdk0KazxBSwa39Trj6gR1BlEXuXFCGS6l5zta6NrwOmZ43KZCXPhFONgQYaJPR42B9pk2wOUmyDozI+Ty8IZqOP/NAS+ohqy/En1b9biZglQdgEHUNh+jh6RvqJuhmIWRndn4wFVhkqgLUbIeH/U6/oyJDWoyb7nbbhszHaw9Ad5C3+kkYHCkjHFv0C5pixzsqBgwMuvRMrcHMtW1yqCeSV8ZGBSk4uTud4A3cMlsb5Rbth5mI1oBFWoDmVJTWSDZCPp1HaWp7klOqyFdOVCqOKYVnLV2Z0/0sDMMW9irAoHEXip+1XAr7edUSuwvumu6gZj+9VcVJP/SeTd/uyOcN0IirPIOfLU=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(82310400026)(35042699022)(14060799003)(376014)(7416014)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	5wHlAiG9wE3Ml5TIRbic3bfUXYuOWZa/LTOQAE1XtC6tClwuHgrbxf9Uv6uhQsRiprlOTqHej2HbXvCEHn7EKvf/o/Y5d3A57sIditMRfha1NdBMjSWm46gegQwBEfitTesKrjy7fqMQblFKDNekRyFOuVMENLGkk/+Zj1ZcFSsNrzww42ObATWkLASAHHC0tgDFC7Sg/Na6pOUd5aT+yELfz/Cn3H1WbZ/Gvaj8M+DupWlAjNARznwMurA7c4hq0LqitJssQe4xu6ZEKUDoDmvgZerkuqTeOCsUZ4sO+iwHv/CDGmuAlsCKzzm8DdTKaTFQPDGuw32dWqaGLA4irPsL0n9jFCVfZpEAKNTiTnyF9sWHrJ9sdDkCPAKujiX9mRjpOjYGwN2czZ57Hk68UpLdnQBmgPiwzsGVJtmE3qyIVqPY33jk1qSALeJxM+mU
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2026 16:26:47.1362
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f4392cf-4d09-4370-c48e-08de8a8b4f87
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00027A67.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB10074
X-Rspamd-Queue-Id: 2951E8001A
X-Stat-Signature: uqaqxs1w83tbdmy3ti8t54a5ch48kjma
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774456013-382299
X-HE-Meta: U2FsdGVkX1+Qbmjl4rMoTgq6CvA0ypZbhVL5TMyi9DT7N3cu0qITsSHlexs9UZPkEcoad3IWkkj2SLkU8ltv13xM8Z+zBE8QIGarkhviJhnmhT48hFFnTKzT54XQ4BgJVI7D4AL7GOAJNlJkbsdE+C8gv5bc7r9OfIZ1uQSEkzpFnn8PSMzDwUSPIVu/VDUvkkTktJ6ao3blr0z2YTqA1bpHTYAplbpPJlFycHOcznLNHeKyyWSK6lxXmYNEeSyhIbxvVY+YPqhbSvLRtLfASbxP5AjRFIO2pp41UO85BAVO7JWEDDi+kH8hB+3SuxQBek8vS3pT2lmGDnLNZpzJfVMIoFWBr7Kc8LTy1yZKMfGZesIwsYaFKZ2lajS1y6WqMCBbPiT/eGBNRmnpiL75kY6+MY3mO91lt8pEXh/hP1M/Wfxh8HgV3cvzK8H4jAYr3N8hSK7H1d1v3TES0aTjQKyhv6upod6Bw3KzbQpFqju2cGSJXGWxJqpG+AF++vXg43aneJCjPz/iFm5VdOjVP+mnN+u55QHYI8txo95RM8KBuLae7AQFbSD9qC+4oUtbxf3Z3jGQDohr8uieyGX/CPh25KhC2lD9ogeTFxt595LYrTDFgjXJcePTW5HB0MlbiLw8lDUhwZYlKjFooi/jlqTPzjhw1C7AdAKdtZ/9wHbXPkvCds8XJPexVqRIpbpRSkcXO9jcAA6uEbEny77Gd7nxILybx1rfXsnxatkcHkkJtp7XtW2rRwLVAJfFx9W9ZgBEsA/mMzxZx+fafPGl3IwxLcOiRiSmXJcKB3WKSVy2m7pK0OhZfKhZ50RNFibK1BA03YKJkBz9ngeyJjElJ2SaumGLrPf2JHkLIXjzL2BzKTkNtQshT8Z/j7s0vfYhYZshXzncc8jBdTmRCcswrAXJRVbSU3MAwDB4+Nknn+OcNkqiIoDwdtIAdAOMt2GOEZFPXtJwjZoTtCvqXVu
 LHCh2nmc
 zVvhQkzByRSBEBT6hBIYSQZFcHVVQMjOpSpiOtk7lFNj4aZD70eJ/8/xHyUGQ9FBk2FDgJxC3tzPyP4/Lh0hQyS0nsuvf8o2HX5KN+3VrWNmFZnPWdFbSqwNmmqbFbKD91mGCXnxvlJFURdxrU1DR8g4ukbSpJei3gmnnzEVaQHh/t2OL522CLxltTarbL4fi/YySC3Lhhdyokmeq/RYNAtNQ26csXA9gAWUb+NYX7cBi6E2/iyv5ArVtHJK3ZJM2fohXXfQK9GqgddnFckbBkPq0NGfv0krwYsHQ1kZlQUv+pU0m/MWPbxsniT3ai3VI3Er22Xwr96iTssM8qoaRAbgo4rlNoACorDCYfNICFBlp0vmJm7Tlg40W9An8h/2oQsxN1XU3blm0ZvuupT4KYE4q8lHhgz4ksrzek49VcKkXkng2tyi1VsMJpVc3YevR0qn3Ws9LuYAZ6VXJJKFODQBG9Qe2WG+VmqDzF8UiWeI98QgMHfa3lQMDnniqalftS4h55w8e5eSv2P6vMFlFO4ueTzJMmZ9RiUlo2nTsXy6w4zY7IDkVf3WfPLd/X2XWDKnnrqjBJmi6KNZpvgdeVLmKvtPjNKgEZzBEkOzXpA1W0LfTAINXRXpjUtSb6WjaiOBf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 25/03/2026 4:16 pm, Uladzislau Rezki wrote:
> On Wed, Mar 25, 2026 at 03:02:14PM +0000, Muhammad Usama Anjum wrote:
>> On 25/03/2026 8:56 am, Uladzislau Rezki wrote:
>>> On Tue, Mar 24, 2026 at 10:55:55AM -0400, Zi Yan wrote:
>>>> On 24 Mar 2026, at 9:35, Muhammad Usama Anjum wrote:
>>>>
>>>>> From: Ryan Roberts <ryan.roberts@arm.com>
>>>>>
>>>>> Whenever vmalloc allocates high order pages (e.g. for a huge mapping) it
>>>>> must immediately split_page() to order-0 so that it remains compatible
>>>>> with users that want to access the underlying struct page.
>>>>> Commit a06157804399 ("mm/vmalloc: request large order pages from buddy
>>>>> allocator") recently made it much more likely for vmalloc to allocate
>>>>> high order pages which are subsequently split to order-0.
>>>>>
>>>>> Unfortunately this had the side effect of causing performance
>>>>> regressions for tight vmalloc/vfree loops (e.g. test_vmalloc.ko
>>>>> benchmarks). See Closes: tag. This happens because the high order pages
>>>>> must be gotten from the buddy but then because they are split to
>>>>> order-0, when they are freed they are freed to the order-0 pcp.
>>>>> Previously allocation was for order-0 pages so they were recycled from
>>>>> the pcp.
>>>>>
>>>>> It would be preferable if when vmalloc allocates an (e.g.) order-3 page
>>>>> that it also frees that order-3 page to the order-3 pcp, then the
>>>>> regression could be removed.
>>>>>
>>>>> So let's do exactly that; use the new __free_contig_range() API to
>>>>> batch-free contiguous ranges of pfns. This not only removes the
>>>>> regression, but significantly improves performance of vfree beyond the
>>>>> baseline.
>>>>>
>>>>> A selection of test_vmalloc benchmarks running on arm64 server class
>>>>> system. mm-new is the baseline. Commit a06157804399 ("mm/vmalloc: request
>>>>> large order pages from buddy allocator") was added in v6.19-rc1 where we
>>>>> see regressions. Then with this change performance is much better. (>0
>>>>> is faster, <0 is slower, (R)/(I) = statistically significant
>>>>> Regression/Improvement):
>>>>>
>>>>> +-----------------+----------------------------------------------------------+-------------------+--------------------+
>>>>> | Benchmark       | Result Class                                             |   mm-new          |  this series       |
>>>>> +=================+==========================================================+===================+====================+
>>>>> | micromm/vmalloc | fix_align_alloc_test: p:1, h:0, l:500000 (usec)          |        1331843.33 |         (I) 67.17% |
>>>>> |                 | fix_size_alloc_test: p:1, h:0, l:500000 (usec)           |         415907.33 |             -5.14% |
>>>>> |                 | fix_size_alloc_test: p:4, h:0, l:500000 (usec)           |         755448.00 |         (I) 53.55% |
>>>>> |                 | fix_size_alloc_test: p:16, h:0, l:500000 (usec)          |        1591331.33 |         (I) 57.26% |
>>>>> |                 | fix_size_alloc_test: p:16, h:1, l:500000 (usec)          |        1594345.67 |         (I) 68.46% |
>>>>> |                 | fix_size_alloc_test: p:64, h:0, l:100000 (usec)          |        1071826.00 |         (I) 79.27% |
>>>>> |                 | fix_size_alloc_test: p:64, h:1, l:100000 (usec)          |        1018385.00 |         (I) 84.17% |
>>>>> |                 | fix_size_alloc_test: p:256, h:0, l:100000 (usec)         |        3970899.67 |         (I) 77.01% |
>>>>> |                 | fix_size_alloc_test: p:256, h:1, l:100000 (usec)         |        3821788.67 |         (I) 89.44% |
>>>>> |                 | fix_size_alloc_test: p:512, h:0, l:100000 (usec)         |        7795968.00 |         (I) 82.67% |
>>>>> |                 | fix_size_alloc_test: p:512, h:1, l:100000 (usec)         |        6530169.67 |        (I) 118.09% |
>>>>> |                 | full_fit_alloc_test: p:1, h:0, l:500000 (usec)           |         626808.33 |             -0.98% |
>>>>> |                 | kvfree_rcu_1_arg_vmalloc_test: p:1, h:0, l:500000 (usec) |         532145.67 |             -1.68% |
>>>>> |                 | kvfree_rcu_2_arg_vmalloc_test: p:1, h:0, l:500000 (usec) |         537032.67 |             -0.96% |
>>>>> |                 | long_busy_list_alloc_test: p:1, h:0, l:500000 (usec)     |        8805069.00 |         (I) 74.58% |
>>>>> |                 | pcpu_alloc_test: p:1, h:0, l:500000 (usec)               |         500824.67 |              4.35% |
>>>>> |                 | random_size_align_alloc_test: p:1, h:0, l:500000 (usec)  |        1637554.67 |         (I) 76.99% |
>>>>> |                 | random_size_alloc_test: p:1, h:0, l:500000 (usec)        |        4556288.67 |         (I) 72.23% |
>>>>> |                 | vm_map_ram_test: p:1, h:0, l:500000 (usec)               |         107371.00 |             -0.70% |
>>>>> +-----------------+----------------------------------------------------------+-------------------+--------------------+
>>>>>
>>>>> Fixes: a06157804399 ("mm/vmalloc: request large order pages from buddy allocator")
>>>>> Closes: https://lore.kernel.org/all/66919a28-bc81-49c9-b68f-dd7c73395a0d@arm.com/
>>>>> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
>>>>> Co-developed-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>>>>> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>>>>> ---
>>>>> Changes since v2:
>>>>> - Remove BUG_ON in favour of simple implementation as this has never
>>>>>   been seen to output any bug in the past as well
>>>>> - Move the free loop to separate function, free_pages_bulk()
>>>>> - Update stats, lruvec_stat in separate loop
>>>>>
>>>>> Changes since v1:
>>>>> - Rebase on mm-new
>>>>> - Rerun benchmarks
>>>>>
>>>>> Made-with: Cursor
>>>>> ---
>>>>>  include/linux/gfp.h |  2 ++
>>>>>  mm/page_alloc.c     | 23 +++++++++++++++++++++++
>>>>>  mm/vmalloc.c        | 16 +++++-----------
>>>>>  3 files changed, 30 insertions(+), 11 deletions(-)
>>>>>
>>>>> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
>>>>> index 7c1f9da7c8e56..71f9097ab99a0 100644
>>>>> --- a/include/linux/gfp.h
>>>>> +++ b/include/linux/gfp.h
>>>>> @@ -239,6 +239,8 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
>>>>>  				struct page **page_array);
>>>>>  #define __alloc_pages_bulk(...)			alloc_hooks(alloc_pages_bulk_noprof(__VA_ARGS__))
>>>>>
>>>>> +void free_pages_bulk(struct page **page_array, unsigned long nr_pages);
>>>>> +
>>>>>  unsigned long alloc_pages_bulk_mempolicy_noprof(gfp_t gfp,
>>>>>  				unsigned long nr_pages,
>>>>>  				struct page **page_array);
>>>>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>>>>> index eedce9a30eb7e..250cc07e547b8 100644
>>>>> --- a/mm/page_alloc.c
>>>>> +++ b/mm/page_alloc.c
>>>>> @@ -5175,6 +5175,29 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
>>>>>  }
>>>>>  EXPORT_SYMBOL_GPL(alloc_pages_bulk_noprof);
>>>>>
>>>>> +void free_pages_bulk(struct page **page_array, unsigned long nr_pages)
>>>>> +{
>>>>> +	unsigned long start_pfn = 0, pfn;
>>>>> +	unsigned long i, nr_contig = 0;
>>>>> +
>>>>> +	for (i = 0; i < nr_pages; i++) {
>>>>> +		pfn = page_to_pfn(page_array[i]);
>>>>> +		if (!nr_contig) {
>>>>> +			start_pfn = pfn;
>>>>> +			nr_contig = 1;
>>>>> +		} else if (start_pfn + nr_contig != pfn) {
>>>>> +			__free_contig_range(start_pfn, nr_contig);
>>>>> +			start_pfn = pfn;
>>>>> +			nr_contig = 1;
>>>>> +			cond_resched();
>>>>
>>> It will cause schedule while atomic. Have you checked that
>>> __free_contig_range() also can sleep? Of so then we are aligned, if not
>>> probably we should remove it.
>> Sorry, I didn't get it. How does having cond_resched() in this function
>> affects __free_contig_range()?
>>
> It is not. What i am asking is about:
> 
> <snip>
> spin_lock();
> free_pages_bulk()
> ...
> <snip>
> 
> so this is not allowed because there is cond_resched() call. We
> can remove it and make it possible to invoke free_pages_bulk() under
> spin-lock, __but__ only if for example other calls do not sleep:
> 
> __free_contig_range()
> memdesc_section()
> free_prepared_contig_range()
> ...
> 
>>
>> The current user of this function is only vfree() which is sleepable.
>>
> I know. But this function can be used by others soon or later.
> 
> Another option is add a comment, saying that it is only for sleepable
> contexts.
Thank you for detailed response. I can move cond_resched() to vfree() and make
free_pages_bulk() allowed to be called form sleepable context. But I feel the
current implementation is better to avoid latency spikes. I'll put explicit
comment that this function can only be called from sleepable contexts.

Thanks,
Usama

> 
> --
> Uladzislau Rezki


