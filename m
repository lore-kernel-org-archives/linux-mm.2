Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 128F0CD342C
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 12:15:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 503C76B0005; Wed,  6 May 2026 08:15:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4669A6B0088; Wed,  6 May 2026 08:15:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E0B76B008A; Wed,  6 May 2026 08:15:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 199716B0005
	for <linux-mm@kvack.org>; Wed,  6 May 2026 08:15:49 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 96580C0BA4
	for <linux-mm@kvack.org>; Wed,  6 May 2026 12:15:48 +0000 (UTC)
X-FDA: 84736891176.10.D6DB4F2
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011000.outbound.protection.outlook.com [40.107.130.0])
	by imf24.hostedemail.com (Postfix) with ESMTP id B920A180004
	for <linux-mm@kvack.org>; Wed,  6 May 2026 12:15:44 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=qy5zZQ5x;
	dkim=pass header.d=arm.com header.s=selector1 header.b=qy5zZQ5x;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf24.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 40.107.130.0 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778069744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oracdaU2e2QlSGHwA/MaYRGuKrUkOCDrxHOJtWxgXS8=;
	b=rIXVLhj1lxsIpbOyhMTEV9IJDgiLmL2kPca99II0lOBkdBhVrgsDXJXsS4TIoREAWVOki0
	R6QNi9aV6xCx2JxQzRFDCsVt03T/yx70Aqvm0tGYVhs+z0nC/99KewiB+TungMxKjfRTnZ
	yJRl8HYFb24k6vGI0jsJvfyKxqrOR78=
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1778069744; a=rsa-sha256;
	cv=pass;
	b=pHkDADljIyTQI86eFDh32iW9eKmIt3vaS4RyNRA6D4kGHRrG3qFYtNijARtAJxDR6951mw
	YOtbWUqBryMEktBbT1Tnxbv8VjLolOj2jd3+6WVEU62SnuI4x7u3ZPzAhNPNhe4/0vNomL
	aHW7w1tCRwL1NIr9JdvwnyDuW4vaqB8=
ARC-Authentication-Results: i=3;
	imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=qy5zZQ5x;
	dkim=pass header.d=arm.com header.s=selector1 header.b=qy5zZQ5x;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf24.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 40.107.130.0 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=SBDujYbajTGyCj6tVzW4ZtP9pT2dIZAvojzEyHcgA9poC2pOQzet8UCGjVTpa9qEJk7d+OQvc5IUbomxBn42fqDiO4S0mptUkgS2url4dbpWtpEB2xW8gwfY6S53AakYq8REhbFVQIGSjIf6InRaoNQ0Kpt92yeSILzB+fWD0kfNTU32UR66IRndiGlK2tXkdzUmRtVKfI2+eFX72e2s/tTpllXmPeAr6eYn6++ON/txj/k0Wwu2tb/qHp+AT4w7qmsyoXPeKFPrxuAVv1uIG7FYJY6/LOIyM9uVEgyDZ+WXZocNpAR0U4XUy3gX0xk/8QjsQVzGJMaRscky5bdTNQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oracdaU2e2QlSGHwA/MaYRGuKrUkOCDrxHOJtWxgXS8=;
 b=VPWFn9X6YM68UrPRSKzgABkWxx89YOHJo/GMnIl5+8iBWKpAhA0AeVlyoP5M5DVCrsZULAVAzOeGtXlHEOsoGYAu0WgkcYtvDcPKymkRIQDmz2W1ttrcIyRxZZfWMW7TZkHl5C2FfteHh3jDPvhoMm2GXEQ2CHYxRDfMePIluYBmI+r7lRzrGO6qHO3cazmxSfmi8kQ+bRZr9bTwxp5IcWj3hyu2xm8ThrHxRPhGo4hAG3V3yjwK33OhO5nPeCoy4GP8HW58AJSyFz7PifJ6NzgNNMdUiYf7O516+bmJZIh3abd5I/BzZKuVf9IuuDBlkuGdDOicK5D6m7UhJ6kwVA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oracdaU2e2QlSGHwA/MaYRGuKrUkOCDrxHOJtWxgXS8=;
 b=qy5zZQ5xXq244Zq4lahqqfunLrCMWzTheZfDKOmSiN+lejAgwqatmwhKmMWjBTq+rIibO1YbBPTDIOXZuiI7qqhRdGQnVzMpx5m3NDdjvEj2VR76o5R86JCvjLjdSKLkD8Bx9kaDX3DXOfd/21Az7weXWzJgxidgjfs76p58Kts=
Received: from CW1P123CA0028.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:292::12)
 by DU2PR08MB10203.eurprd08.prod.outlook.com (2603:10a6:10:491::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.25; Wed, 6 May
 2026 12:15:39 +0000
Received: from AMS1EPF0000004B.eurprd04.prod.outlook.com
 (2603:10a6:400:292:cafe::96) by CW1P123CA0028.outlook.office365.com
 (2603:10a6:400:292::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9891.15 via Frontend Transport; Wed,
 6 May 2026 12:15:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF0000004B.mail.protection.outlook.com (10.167.16.136) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9891.9
 via Frontend Transport; Wed, 6 May 2026 12:15:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hLwV67gwLGT4fBgKcXaMyuAN6XR8Skn5q8KYAmy/Fp/5RRXN3mffrnyOdyZ/Ht00y57RcRosrHBOAk9MtV3KWAK5tPAnWq+XGW2/RC/4VFY/LW076S2aUO5vpmHfiPKYaSw4Ph7sZ9QrBQkDk3DSl9TWeSVrBLGzM/Ml5iS+Fo4DIrKxUg74S0Nx94CzTtbPLAR5nFNBKGWasN5vJluP06RLjb5l2jZebS48t3J2+9C0vH5VSyy64a74s10BGobEiDclRX/YavJyWgFslcs8Z1BE+bBCL+1naH8uhK9hkXqHhjZXSkfMF/bB1jvsnhzIGusKJHxBbh89NxH8Sra+pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oracdaU2e2QlSGHwA/MaYRGuKrUkOCDrxHOJtWxgXS8=;
 b=ohoPRG/EgORdk9T8rwbOCXkNAa/+sch9/rkgGfvyhczBtsUm2GVa9Rdr/ehLEfM80HJOMLbOkwGCBF4dD76Vcw0houzTQHp8D8TwFZn+7UqgBlXJT/BZQNzOWoeepcUUAmWnhAq94Ae3GVXf19vl7D+sNRyNoUfaMUswBKt0pKH0aDQ22NFTsdvZVMNGSjTJMptso02jZ/vofc3SQSGd0ki0mw95BwCrn8GMtajAfQuAHUMLMg2/m251tqDxf7FrV+AfT+Fae+Ei9vWe7b+tnvJZPmAY276X1kdDpEKMLRK9pRZ7J+XP2RzuFN+XoO4pMB2w/FEmwgEb2HfAkQiYzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oracdaU2e2QlSGHwA/MaYRGuKrUkOCDrxHOJtWxgXS8=;
 b=qy5zZQ5xXq244Zq4lahqqfunLrCMWzTheZfDKOmSiN+lejAgwqatmwhKmMWjBTq+rIibO1YbBPTDIOXZuiI7qqhRdGQnVzMpx5m3NDdjvEj2VR76o5R86JCvjLjdSKLkD8Bx9kaDX3DXOfd/21Az7weXWzJgxidgjfs76p58Kts=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com (2603:10a6:10:417::12)
 by DU0PR08MB8347.eurprd08.prod.outlook.com (2603:10a6:10:409::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.15; Wed, 6 May
 2026 12:14:34 +0000
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047]) by DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047%2]) with mapi id 15.20.9891.008; Wed, 6 May 2026
 12:14:34 +0000
Message-ID: <aa2899b9-f08a-4731-84ce-8c9cbc67f3b0@arm.com>
Date: Wed, 6 May 2026 17:44:25 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 32/54] selftests/mm: gup_longterm: add setup of HugeTLB
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
 <20260428204240.1924129-33-rppt@kernel.org>
From: Sarthak Sharma <sarthak.sharma@arm.com>
Content-Language: en-US
In-Reply-To: <20260428204240.1924129-33-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5P287CA0015.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:179::15) To DU0PR08MB9203.eurprd08.prod.outlook.com
 (2603:10a6:10:417::12)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU0PR08MB9203:EE_|DU0PR08MB8347:EE_|AMS1EPF0000004B:EE_|DU2PR08MB10203:EE_
X-MS-Office365-Filtering-Correlation-Id: d38fefe7-4b5d-433d-871e-08deab692f60
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|7416014|1800799024|366016|376014|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info-Original:
 eVCcnKtOy0bzw/e4WKqeHL4GTOZL7aL0Ms9o/xI+udbN3/jamEURKNziwXbKYovFiGTGl8KCj4NRPxm7tKCFc+xIPk+murh/kqrt5hf0OqzeosHkjUIMseE0Hnq7DhoLUV2vsR+WoHiBBTTj9aZNWEbOesg4A54/n3H9IZEC3uup3curbwKNGYAZah1W3d+N1oSIm5yEvco+OZgIHAGQW5zc0Jmxhe/n5IiPCHfIXaLbRYejMKcVQkkaX1MoMSj1aX5SS85FFxkGxsr0SgxaVw5HE0ii7AVg69DRbf8KLmh4swNbL8HkRhBX6jqyXqaedqcmJbNWtdww9s3P9V+P+UgOqE7+YV7Nqb4FPhXa8rDXbTQuVAe0SODExayi59SCTLgV4ST8+RKywfr24beVUzy1saO14M42wID6IODsEc59AROpn0J7jz43fD0xdPHw9FEpqXwd+1Va9WeRu0IWf04z1Q6WuXKZmAkHQ0+dTbclpUTjXhTt4PCEgS+yoaHJYBnEEUn7BEHgjHsBwcOoIPyihliWs3hsuEGcIQ6VqHMmeOsDkHqExL8LD/JkP1S+G+Tqdjt/j6UTeXNJiM6Ep5YYltWlsVfDULOJvpOpt6vMj0S+jNQojOCirVzqlKq+WBoBvsRG7/YjcOn5+mDWpRKsKaGrs3QxVDdCp5k4VCFPrOOYimredaLknFJnPNYy
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9203.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 OvGia4D1x8wDvuQynQ4y6LOsB/mpfZz0n0mj0glPEaNA04grr61RO1mRCY/hnR8s3PpQjXW9JEV5Y8HR4TRCrUMCVcDGzIeNroqgFsHs0IrhTcBAKNvE+tmwvmcl/g8UYaEg1yLpthASL2Fej2V7vsaBooWmVRETpq+xruL3rmv+BX+XYbBFqyaIRJG22jFM8fNGYwbMIIGQYDiUhwy3y4iT98wTlBVrdTL20/aZu8gC/agZckuJcXdnZyZYEA4sRiRx6qzdFx7oBTFSSg2RdfLAfzyd3VCECWD0gwlaImq0uNnlyoPZ1YaSEzv6fPZQVBlKOleBrSqONvYxp6QsTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB8347
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF0000004B.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	1ee87388-0265-42ce-5cee-08deab6908e6
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|14060799003|36860700016|1800799024|35042699022|376014|7416014|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	4ic9dF9pHLtad+63y8qadTDS1gK2Mi+x+bK/9HP/f5CT47w6Ax9JLAOYC3X7G4zTGoIWDvfxqAuRY5GNdKqWV7FGpQTSFeWn9f1x/o2dzffJFd3nq+j7ysm9P/c15In52WVSXOcYpj7WWHT8LMAF5djW0i5eRXgRcVvxaHaz3KoCTp40tWiORF56Pphj5XIylH09vkefknHgZlZPBwI2IXWSS5ThRTlpucxea8KOux+mypkhUi01hS5fejchiL1tCPqQyM3ZOCx15+chvANQOWHkqQW8/9yBViNp2AbGadtMJSthEjNaUi62ZfUm7KlYrGfDkmzWP52CCmsOLe969ToyYZlnNLmTyou0WhyVswwIYJglKQ/VVBdZn+SnhgjY2eAmtjFEdiD69sHrsy4jMy9CwOIjDqSmNXplgSsuvxsMubF/8yO6j1NhAnqHIZhgY0sfm0eV7/oVvyppncXk9Jk/8DMrsGCpod6CwdXqSUIMAFQktaYrZTyrhZf7bRoT+gOVmtu6IKHEgMGJc6kvDXdjDiuZoWQelbaBimHGLYE4lvbwlCZDxIWAH7VxObZ+SIVgujw+XoAGTog+9PoHiL/cz2AnnmEol3Q325XsqKC5klFCsWEcmmDskYt5wRh4F2CSkdUKON3pa6qwSclnFhSacsNJGMGACOqj925UvkwrXNSldVvW+pEEZdBc8JCNWEoBbIDJisPH5kQUyK15sqLcFiC3f3LntaipLXfqzr4=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(14060799003)(36860700016)(1800799024)(35042699022)(376014)(7416014)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	RxOMA2yNBXbC+QEBIzTXz6m7FyDdNZXWHDB86XvOcZ7uTpdRYJTTduMrPb/7LSnaRTbdR/SuftEhGCsngvovwk+6amQrgh1PCfpGxKn0OxkwZQH98F+DYNUMQDoTHdGhMM31n379q+4A76aT85p2Wbb06xwzV9PAJOOZ7BcwXY1p5tG8ijsBLU+OwmWrr0OET8cmvnnz3u62EpB/umbt4+2eb9UoaujSJ0JzegQC6fmRLJQgptWp1r7CxPYMXIHs1eon5avgQl9nSWsdokMO+U0Wd3X14KcurXZWXP8hHJnqEeg8oeQTqWtqG0CDo1bXzwD9QoPbWvZAu8/+gmSLQDAU9IU+rEi1fE4HrGYgw3reAQ4g5Qo25rS27CAehbxBIYaFh4s3sww0/G2QrTyTNMQ/lhUobtr/xvuF6qCDtFtKXwZN61TFLNAd80LfA8WT
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2026 12:15:38.7013
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d38fefe7-4b5d-433d-871e-08deab692f60
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF0000004B.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR08MB10203
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B920A180004
X-Stat-Signature: irzr3jk611kdieparmgwzcbdkjhkep3m
X-Rspam-User: 
X-HE-Tag: 1778069744-29561
X-HE-Meta: U2FsdGVkX18Ug2t4bIYuC2u6Tx4kaFI8iXhEFF+BhzeSNhNsEmYwsLjh4wLPY85FnG7JJqHeEDS/Tx8a5OE7yUvOq7HRH5WA6b8qziMFqpcdX0MP5E4XeCGJfkKduXCAQl08bHm9gqCH+CWUGsyIyFJVSA0xmGwTcSi7wLfLr7Wcx7PVZZNOEap4vZeqtQ6b1RRvcCGIsh6Ga7BkYQcRIzMwWl9zbVChgpglhUs/9sGEWmvzwgxzxDrJmLfdNhR+Sy/epz8EGoJ4MDx72KKaf6vmVg6ODHtrnGgMLnRtxvcEoiWVUSrislGp9XDrUqnvdb9HAqAik3BtBn4RQ4aFBGlmZSDaGmrZwBEGzoPDOL7vieI0pZCsdShXQXJzMJTKlvuRDcLAiF/mWRxkxvASz4OZs66/9fYSuATrOxEZqTKGUXnmF1vE3W7RLeWNZqBxqmrAp0dcRVkDrRS0uKdpFipo9xbcTQg5PRCKHdTPQn2FlC2iHhYoxXw9qDW4D+FdBIUo+2ySNE3OKUsMKJ6dUfM7hIGbVrnV9WJWmO3aCxkgyMNA3VRP+Vsk7rXW6qpSQOE76yeHsFigZZuBcknj2zMLS6W5Z7nF/N4VSV1OX3Jh1pNGLI+gcmN3etX9Bt2v0NZ5/l92reuXYSx6RWwdc+Bjp7L3paeilkDWVjQTkPuaA1yCGdsN1oO/Qm1ge/AEo3caw8dX3Ij5CxvKW+niAyjBs/dOk2vMs0R36sgxGxb6cO3vOT5OQQ1zkuCyPS4/z/aMxX8GFA5uid13CuLQIiG0QAjRa9MOw2Xoq0HN+G5Wy9DyCC81dKJAkvkSdARysPuKIpXLweAGZjCzfUgEDfFE8I7Emdg4DCQIcpEEELN6CPU3QtvYghtEWV9h+nP8ZRfy8X1DhSPg/YwhgNZK8X0paHWuLsaglsy7ObWcpZirqOV4Z7TZ4K1Ugdr/YAgmCGr3BiGgJ/gVzD1mX1W
 tYgVinDc
 7o3udHf1bq5pxiDOErHiSjoAw0i4PiXGzT4Tvu02dadsORBAYp7hKhqjvadwRHPcjEcxk6mr8os0Re0gOpebL0442oT+MSIpd/oZjbL6Bf48znDeBNDkocKIVEAeNZeJK3OeoSt92N14zUZZD6Osa/B/ZnXKbnJBXjC7h2t2iJfRzTpbkzwn1W/FJHBcB71WPwlkigAwrlhvoLUf4/JGsPeanjnXX5FH8rDX/LZqmxkwgi5tkCJ51risf3C0YedtN6BGce+tGNdii7197pq7/4df/lj12NpSS6iXpZUAYzdBGQI9xlruAEuP5O3+TvxluNqb8WapqwU0fZ47cUKlRyZF2Qj5slgE8I0+uYqcUm1eUaXBhwUsqwabQXaHOnniM4YvNaqmQ9PjcmmcS4YAgslJIuQ3G8+J2djk2D5iWq4TQFNZi8cC4Vii2tHZtZF4OgMqgUCFfgtGNdpDKzNDIDmyimOFXp9Via4NvVIXjBEjMGKTFXmxUYWe+109xTUv8vBZSIWuXmJ7Ypna/ZsAEN/+83Dyx/iC5pFPyXVUG5lJ8Ogv4LErufnmT75in7/R07s35JOOKAPzmFhvzVm7ntmzpRcu8KjRV5a/F6EtbvI364cQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/29/26 2:12 AM, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> gup_longterm tests skips HugeTLB tests if there are no free huge pages
> prepared by a wrapper script.
> 
> Add setup of HugeTLB pages to the test and make sure that the original
> settings are restored on the test exit.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

I have run the test before and after applying the patch. Before the
patch, many tests were skipped with the message "need more free huge
pages". After the patch, these tests passed successfully.

Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>

> ---
>  tools/testing/selftests/mm/gup_longterm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/mm/gup_longterm.c b/tools/testing/selftests/mm/gup_longterm.c
> index ab4eaf4feb7c..6e1de12bf28c 100644
> --- a/tools/testing/selftests/mm/gup_longterm.c
> +++ b/tools/testing/selftests/mm/gup_longterm.c
> @@ -510,7 +510,7 @@ int main(int argc, char **argv)
>  	int i;
>  
>  	pagesize = getpagesize();
> -	nr_hugetlbsizes = detect_hugetlb_page_sizes(hugetlbsizes,
> +	nr_hugetlbsizes = hugetlb_setup(2, hugetlbsizes,
>  						    ARRAY_SIZE(hugetlbsizes));
>  
>  	ksft_print_header();


