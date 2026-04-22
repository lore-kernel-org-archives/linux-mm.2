Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1375DF5A8DD
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 11:21:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12E536B00AB; Wed, 22 Apr 2026 07:21:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 105FF6B00AC; Wed, 22 Apr 2026 07:21:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F36BF6B00AD; Wed, 22 Apr 2026 07:21:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E431B6B00AB
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 07:21:44 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9E935E6ABA
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 11:21:44 +0000 (UTC)
X-FDA: 84685951728.01.0E9F546
Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011013.outbound.protection.outlook.com [52.101.65.13])
	by imf22.hostedemail.com (Postfix) with ESMTP id 612ABC0007
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 11:21:40 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=kOGFGYss;
	dkim=pass header.d=arm.com header.s=selector1 header.b=kOGFGYss;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf22.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.65.13 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776856901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VRe9EqiFAovWSOsCTQgP3z0rSn9JWxwemwdeWUq7cLU=;
	b=I+h8G6aIj8g65YaNg6kU0tqtKNGNfPiwdPjtaO6zr98REKrQ6EBOlDM20UrF2XTApcYNeP
	+bCTEmHS06eBI+gTA9c0GKb7JZykLHqxzAppNAN2SlhkdRl+QDMGt8qTVzvDZaIw16BAgB
	io0VqwL7JawCbewusQy4eDjkyBDbp+E=
ARC-Authentication-Results: i=3;
	imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=kOGFGYss;
	dkim=pass header.d=arm.com header.s=selector1 header.b=kOGFGYss;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf22.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.65.13 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1776856901; a=rsa-sha256;
	cv=pass;
	b=vxpA+Enj3TDgW1U3XUntqV7HFx9NT9kvqun9iWv5wq20qGg0P1cUQLjkez97BexIDggWIa
	jrKfPYpgJsAyXPmWp8w761T6Ry3k48nlf6eHNaxv1Z4HvFZxesxOwS/xlIAGzYyzqbuMKc
	uleMPKc6dojFyddpVyQzKJ2iPAsHzpI=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=twZmbclap3OW8g2epoXRwP3weMEkZMWj/hSJDdPKjw8ERWadxFqDl2iwx94uVCdQAgXONWjZZieUxPwAQA6sXUHEEWozkAlb/Ast8lJFM9Evq36bXsW4/xQcy3QGIJ3zSW0/Ta/FSVZZuIIcOosg0Btac9YvGEFvEtOnw8wSmQOp094ta/nvHxoyGlP8vIwk5iPQnV6hoIod/nfQ0TnUe/FkX6k8vhVH7b7oAjILzVFZTfsHgm518MRS3GbQppADLeDjNvyEa0HXBxNVKnB7s8xCmGTREZK6RpmY2AYYJmgUHZpdQpdmYbvurpexBJxeYLhBb0iAXaGzZ65w+DiU/w==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VRe9EqiFAovWSOsCTQgP3z0rSn9JWxwemwdeWUq7cLU=;
 b=dpvSObxVO8mMmBKfpIPMgQAr2wCgTQxxEwiyiXyEIUyDo3OnPm+8mj8kiWzrnDKnaiUIrvaDoOtiVH3Me5Bd9VYk0lWCCB2VJumkx9qRUNgs+6yJtYNtiwi++/xulKw01qVKOUNowMxakXzrTWYokIr1xEOMhKZlad1Ypi9P9lCdPFb/xMDgXNkOJVIQzAbwoVKX9cbzK7HrXHeQrcDn+f7DlNxLYpUQgLuhgfT3TN218YmVvULZTag5UPpCvJSGufYeCnzntfPBJYK0E/oSeFtWsYHzOSnJDMVUcpbMRaoPwDkY026OYkw/BeUPd/e4/gAFN/Y16gmfpwT1bpvu4A==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VRe9EqiFAovWSOsCTQgP3z0rSn9JWxwemwdeWUq7cLU=;
 b=kOGFGYsspvJM0Uw3Vr7pII3oacLwRX4nYvq6/Hp1B1jSY0bHY2r0yhCz92okvtXcqN8QjNEDduTto8GbTB1akp/f3VjOE4azgqjqsTp8nGeRIZC0exLWQkoyrGTjmfj9Ag/Xe0T+KtMm2syLq6/sURuDbB/4GkcAWImdgT8r8x0=
Received: from CWLP265CA0535.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:18d::7)
 by DU0PR08MB7834.eurprd08.prod.outlook.com (2603:10a6:10:3b5::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.33; Wed, 22 Apr
 2026 11:21:33 +0000
Received: from AMS1EPF0000004E.eurprd04.prod.outlook.com
 (2603:10a6:400:18d:cafe::d0) by CWLP265CA0535.outlook.office365.com
 (2603:10a6:400:18d::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9791.48 via Frontend Transport; Wed,
 22 Apr 2026 11:21:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF0000004E.mail.protection.outlook.com (10.167.16.139) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.18
 via Frontend Transport; Wed, 22 Apr 2026 11:21:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vwRpZX1z2+k68F0g+GF9rUGZbPZPldeffOrq12DuyrRrvQkPLsbORlRbg5xEeG6EuPhq5yG4cCuiCvHHQmQf7Jn17OJn+DRy+3kgsi4cP/kqg5KqZWVnHFUWDQhpu7KBsEZ5Vl8fpDl36IZOm2AkzfRa4zRnwNkO+KWWQtte29WT6JcZIi/RV+ymvGAG51RwvW5d23F/nhhLJq+N91XCInoR+6H+S3PaUN1eJKZikUZHzqqUDuDbfL6w1IiUq2KFRjd2PO6ZzngHTagp1wAb8rU1lh47ZZU8Qh/lCVmfwtc5sFmffvxH1Jg5rRy2sC2WI76nN1MsQCokYIuztQTpMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VRe9EqiFAovWSOsCTQgP3z0rSn9JWxwemwdeWUq7cLU=;
 b=H7Qojv1/IzR7MaOzNIjPWk09FQqbVr9mSN0WEIy3T9n+OezxpEnOAMy0998B/o5p8B+MYKdRtNGgO7odFGlXZkoeEkcf4Z6HDQYgDos38E35JjKLH5yk73z8CULP9tY5mOp24Wyr3ZTid1Cv8KddRD/8zqXteEgrq+/VNujmQxdHyAixij98QUPr8FLJoLXaZ7rT0vI5FFvd0he/0AAjZxaUyFkMGgdQ3ARLOaKYaXEKKJ5wX/cA46k9f/uQCwl+BUu9gdYyhTwKPWlC8s388JjeXwGnBF9mw4cSaowzJ0USWsDmDfeQjrsdulNm3kvz7KhOEdXWnUBRCvc5XyENmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VRe9EqiFAovWSOsCTQgP3z0rSn9JWxwemwdeWUq7cLU=;
 b=kOGFGYsspvJM0Uw3Vr7pII3oacLwRX4nYvq6/Hp1B1jSY0bHY2r0yhCz92okvtXcqN8QjNEDduTto8GbTB1akp/f3VjOE4azgqjqsTp8nGeRIZC0exLWQkoyrGTjmfj9Ag/Xe0T+KtMm2syLq6/sURuDbB/4GkcAWImdgT8r8x0=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com (2603:10a6:10:417::12)
 by DB5PR08MB10093.eurprd08.prod.outlook.com (2603:10a6:10:4a3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.16; Wed, 22 Apr
 2026 11:20:29 +0000
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047]) by DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047%2]) with mapi id 15.20.9846.016; Wed, 22 Apr 2026
 11:20:29 +0000
Message-ID: <3d154106-1de3-4cd8-9bee-53ef20245d62@arm.com>
Date: Wed, 22 Apr 2026 16:50:20 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 07/53] selftests/mm: hugetlb-shm: use kselftest
 framework
To: Mike Rapoport <rppt@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
 Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
 Donet Tom <donettom@linux.ibm.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lance Yang <lance.yang@linux.dev>,
 Leon Romanovsky <leon@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Mark Brown <broonie@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Nico Pache <npache@redhat.com>, Peter Xu <peterx@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Shuah Khan <shuah@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org
References: <20260418105539.1261536-1-rppt@kernel.org>
 <20260418105539.1261536-8-rppt@kernel.org>
From: Sarthak Sharma <sarthak.sharma@arm.com>
Content-Language: en-US
In-Reply-To: <20260418105539.1261536-8-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5P287CA0141.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:1d2::6) To DU0PR08MB9203.eurprd08.prod.outlook.com
 (2603:10a6:10:417::12)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU0PR08MB9203:EE_|DB5PR08MB10093:EE_|AMS1EPF0000004E:EE_|DU0PR08MB7834:EE_
X-MS-Office365-Filtering-Correlation-Id: 976ac14d-1a03-470a-dee9-08dea0614ec0
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|1800799024|366016|7416014|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info-Original:
 ckIpzihaNqIkVKDrW9uz/RMMiqUMcmII2psPw1aQZ6wDLtNd3WYP+ibGCeYjyC0E+Rlzcp4fuJ8esgK/Ne9QYSHdDEdKKWVH+eCS4DW8LkQ5Y4Twk1Tg+jjrxJ5+ugM7/336P4NbRS195l5iBM3rBC5ow0jb5nfyu2EZ8Fi9Pqt310oZxVj0uwNmEG7KiRRC6cR0tOakN/UsU77NvL8sEF5l2d2PUYg/3878+TvizzI53j158oQQGj2u9EpwEdJkJJkxOhZzakK/hBSB7sB04Oej76WiEtLrQW62B3g/A7LIYjNBuo0/XtevAjOGk1NEJrkD+aRqUMuZFIWGeDO0oEhajzLLO21c0AOiX51Ov4Qs35YFwGTAjVVeF8Vf4EwmdGU+MTdDJ5iezU8lst60PbABNCHCDSJ1SPBBNd1z4RM6kFPnEmP4vCqIfW6kX1J10BKlOsczaOOsNGjkeKMocuxTD5WoZwI0YiobiVkswDj3dAv6sodkJ/SZI0omMkYbKuhTB4aLoN2sax2G/p2YaO1krZZrQS0mqRUxKhgAYjIBlZOZ24p5N4VsvawoKYGmhCCFYUXscuZ3bMALWv1hnIVPR2cxYSbssi0PGfngg2CL7Nf62RV4Pc2h2/yakYogv2DBxA94HDg03q+1QM3ai9jXixtFbdd3r/iAJDyRyISddyMkPdC8hiVtlrU/NAD+2nP+NiKi9u/hNElA5/NYRwvCJbgv3bD8uGTiMp4K79A=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9203.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7416014)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 dcwKbBu8LvY8znxlVWZzHM3C0u+IJJqbauoigjdqtf4D6WETVQEIEZFw0UXjkEuljwnUHp/srsmCgXZXj24fDxli1LT7QJO0mB4imnBGF4Kp7NX7ZnpTMaUvMmFjdPaDGqhkkNcUvo00Uvi+pqtmFKB/WSwf3ro0U26eYpEx4DQryPL7UlDhDeB19SaJCNstYQ/WaREF/lPEuv9r7UnYQJe6o3Zmj7l1li2d5JRsTOYSKTywpoADVs4bsnX01Hn9obanPZxHk9e+Uv4CPpu5yhhc/9130wSZcEwr6E2pgiln+p6VWOe3TSx0RKIslR58WNH/NTh0mWurhMQuIjMobA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB5PR08MB10093
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF0000004E.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	a73c0ad5-aef8-4736-e19c-08dea06128a8
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|1800799024|35042699022|36860700016|82310400026|7416014|376014|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	9561qE5ipVGfGguCu2fxSCCRScMDgLFWE8gy8y2wRSfjgvqr0aMiYlfQFNKqltrqzn9rZ2bLutSPfSk+az2e7cj1GcV2NzEc6qutmKZgpP2NN0k7rx8VeTbPkm1zVpH9fHKspFBOqsgYw6oO1x6kJMqd/Jh+ExR+CJVIt+Ci0x4DtVghkf71rqKJKrkQ62jt0vD23/n8Y9EZ/OcIp69MVCTxu2dWHOst27c1bITK4cotqlyhokuP3NZY9sZFwkzlBooow/eaGBp4VqYHeOLIcwIoYCdv4BCvaWw1Ve3aXz0TmioAYTqY24ZgIPomEHIDegFf1rUUZ0thnHM8JSCdMRExhDN1PgnKOj2roZs6G7HzGIRxdklEe1u9zc5GEgFYkdk10QlJ8z9q+ti0GAiqFAjU1NXeIl9oXSxjS4P5UU8nauiauPIEgsYbXzLOyU17bgOWtyj/4YN3UNWt6kx4AmlGxZoCYQGASxdc7XWKNtE2guZsphkAXA/TV5G9ftPu4RK1uPrl6PqfdGQvanT11CfwvNj7DKBnNrPDQp1ECqJBtbrKHAi4Y/e7xorEhdQgMcSCieqegI6XtBD78BooFojq9AShM5CYEizawrvWxPCjeYQ+QnYunOybv+sCuFsOF3d6ZIorJXe6cvK/CvRqk2JAP7pjum/FmVmgOM1LCTES1kV7HeXYRZkpG8Mya5JcBCd5xgmtQcuUEde3o5yxZM4PnRmruAjreGxu18CkNMeYE2Z0wc6OE4VZt4yIXj1EWR6leiVOS9hzOph99ULVMg==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(1800799024)(35042699022)(36860700016)(82310400026)(7416014)(376014)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	uhmQCGxyXziQYLOnygFu66/ZQOFKhE9oCntL2VrFQw4DTj73mQxG+6by2Map2c+Q+/it8BXXyXPO4Sxjm7tJFo6dGet2zK/yODfh0Vne9i7smLPHgBoI38ed5rV9aLYTPk9OOAR6y9K38zIvwaV3ro4jSMgNuEvrK156Qktw5Xcx/O2VraH48JqNsbuU5vts/U1oUbOyhfZagQY4T9SDH8Jc4kG1jAwe9iw/8Oy7hRlHzl8A22+LgJ1xJYwR9AcVrM9k6kt3cSWI3yV0HGO4joFsgnCgSlGubfRWWH5CWmEF6RSrrLLJfrE6XqPDuM79pMJwy9lwQNC6zQuudJ6Fvxh56WxxClN0vvIhvueJH2g48yqexwGtWqvjrnjLlptaGWSF6mFdawtriPTLs2AForCMhsd1CNVL6T0pLsMZKtXa57tJ1lNyjYz3wCzUZiUC
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2026 11:21:32.5639
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 976ac14d-1a03-470a-dee9-08dea0614ec0
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF0000004E.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB7834
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 612ABC0007
X-Stat-Signature: ewpr4ho9mcf8jmzycb4gnfz8zochbc41
X-Rspam-User: 
X-HE-Tag: 1776856900-697689
X-HE-Meta: U2FsdGVkX18s7roMwaxbCHM4st3qZI8SakwlxmAYRL+kVoi2oEno2gY8I1S0mYtvpvHfk3KK6wV7lsYMoS0mRZcnUWG8QMHcSYAX9fhWZd4zMxw87iu7UknM0Qt+L0ivexIgVPYY/xp3X37jnZldRinSUqWsccQUdRYIz8QGoA4AONHDymwMyCYVt5P8vqr4YPASxdpC1/56Ku4xDzovRNlYnIfBmteSHLxk1B6SRxpXU45BloaO8OZ+6VXdfzqrf5C5eOHNnlcupYbxB98033oiNl838sYztri2XZjCiFs/k2hBUGiRc4AWT7wJMAfq9nVa5xykClcCkvORlmi9bfeUp6so2uBQPhXESx8T/RxrqGdnpc+FjHeqgBFQ6A8s12oZiFXnlSrrd/ABnUx1V53Tvb1JCCii+/g6fVa47mwJLRzRUBZ4wwDkOfksIAtqjoMbYAG1k7lda0wMKLIVkSQd7cScfMkW/Dpoua0LrFrHC4Gq7aEIgGCxpFjD8KNcBvQ2QJ7LyGUsC9O1bxG0ECRFx1TtLLN1OdBDicKMouTtLkAVuN8UbnkkhM8rgQWHUYZXhOjIgLU9QHbm9X1/1UunhceGg/dAYG4lw7piozVttF10ly8MacgAsD8t3MIGrUL+lfDS5z29zPzJD+UBjA4CCS2tcU/HHdnDGN/XlpwR+/gXvo/KWzv7eUy/yct5UiVy6vzuOxWNYwSLQZuZpFoPbDwHyE+b6qurNuM0Fg5vmZ7cW0c7ZsDlrPT8OCzLZr8jtyG/8hewdRMp7R/RA6OZBCuxKBHSSwZzApyw/IL5u1zIkGP+yIkRyvannxLUZyvSSAtBKNC+97mc5YqvkVSQRnVUHAfzyjyUf/N8XfIW5iWJ4whNbHg+2Kl7Ar7Sq9lMOtV2lu3W9a392CGIJEm5qCFPsRwLnDwDsnUZxkFS/VoJn9Ssv/bbK9EFcVmQheNNhvsXcgGtneuM88X
 oBA2BXdw
 rG7EjZGdDPfj8A5sdvQuKN0Y44cUzcZTCcgBxlwlXItBzFm2Obe7PW5vQywt0e6USQhbsw9jmkXvgEqOY7Caef+6H32cKHeWcin3atEj1kQWSsnfO1Xukk//I/pwtg5qdwBWMxK5LGJXBdKPaeB/qSv40QwPVgzmS3FDX0p5+GCZMjooz7BnYrSYvAiwXDLHwAcgQ4PzPVRYpC9gNb+1Ls3OKa0ejHsXeUQJfhny1CkXU5w9YRct4xWv/EX8dAH8wLu2brG9ofvyaY1jth4lLfgNKu3O2tIFPP74T9mpaRry1kOKLWfduQM+CzCTBYUitPiR1pc/I5JgruXcemyR93vl8AV3pnBGibmSRkCMVL6Tc8E4JHfzqJGUXjXzbD1Sh2tXxsqMYGihkLA9DebbH5vTXGWIcm7zjQ2gO7qxcrDy27D2dmiTRFMnpqM8jz/kr3iLh1FOI3BqnNxm7PgbstJtVvLyanQ9Gy5aNW48s2629kUw3OfWv1EJfCYY+vTfzsZrT5yq7XT7YXgvDlouoOHrDGxyKoSLC6GCAfBu5jc53qBwiBPmBdhmunupzcg7v7NW0EPboWY2Ksno=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mike!

On 4/18/26 4:24 PM, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Convert hugetlb-shm test to use kselftest framework for reporting and
> tracking successful and failing runs.
> 
> Reviewed-by: Mark Brown <broonie@kernel.org>
> Reviewed by: Donet Tom <donettom@linux.ibm.com>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  tools/testing/selftests/mm/hugetlb-shm.c | 46 ++++++++++++------------
>  1 file changed, 23 insertions(+), 23 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/hugetlb-shm.c b/tools/testing/selftests/mm/hugetlb-shm.c
> index de8f5d523084..10e4baa091f2 100644
> --- a/tools/testing/selftests/mm/hugetlb-shm.c
> +++ b/tools/testing/selftests/mm/hugetlb-shm.c
> @@ -28,9 +28,9 @@
>  #include <sys/shm.h>
>  #include <sys/mman.h>
>  
> -#define LENGTH (256UL*1024*1024)
> +#include "vm_util.h"
>  
> -#define dprintf(x)  printf(x)
> +#define LENGTH (256UL*1024*1024)
>  
>  int main(void)
>  {
> @@ -38,44 +38,44 @@ int main(void)
>  	unsigned long i;
>  	char *shmaddr;
>  
> +	ksft_print_header();
> +	ksft_set_plan(1);
> +
>  	shmid = shmget(2, LENGTH, SHM_HUGETLB | IPC_CREAT | SHM_R | SHM_W);
> -	if (shmid < 0) {
> -		perror("shmget");
> -		exit(1);
> -	}
> -	printf("shmid: 0x%x\n", shmid);
> +	if (shmid < 0)
> +		ksft_exit_fail_perror("shmget");
> +
> +	ksft_print_msg("shmid: 0x%x\n", shmid);
>  
>  	shmaddr = shmat(shmid, NULL, 0);
>  	if (shmaddr == (char *)-1) {
> -		perror("Shared memory attach failure");
> +		ksft_perror("Shared memory attach failure");
>  		shmctl(shmid, IPC_RMID, NULL);
> -		exit(2);
> +		ksft_exit_fail();
>  	}
> -	printf("shmaddr: %p\n", shmaddr);
> +	ksft_print_msg("shmaddr: %p\n", shmaddr);
>  
> -	dprintf("Starting the writes:\n");
> -	for (i = 0; i < LENGTH; i++) {
> +	ksft_print_msg("Starting the writes:\n");
> +	for (i = 0; i < LENGTH; i++)
>  		shmaddr[i] = (char)(i);
> -		if (!(i % (1024 * 1024)))
> -			dprintf(".");
> -	}
> -	dprintf("\n");
>  
> -	dprintf("Starting the Check...");
> +	ksft_print_msg("Starting the Check...");
>  	for (i = 0; i < LENGTH; i++)
>  		if (shmaddr[i] != (char)i) {
> -			printf("\nIndex %lu mismatched\n", i);
> -			exit(3);
> +			ksft_print_msg("Index %lu mismatched\n", i);
> +			shmctl(shmid, IPC_RMID, NULL);
> +			ksft_exit_fail_msg("Data mismatch at index %lu\n", i);

ksft_print_msg() and ksft_exit_fail_msg() are printing the same thing
here. Should we remove the ksft_print_msg() to avoid redundancy?

I've run the test before and after applying the patch. The output has
been correctly formatted into KTAP format with no change in results.

Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>

>  		}
> -	dprintf("Done.\n");
> +	ksft_print_msg("Done.\n");
>  
>  	if (shmdt((const void *)shmaddr) != 0) {
> -		perror("Detach failure");
> +		ksft_perror("Detach failure");
>  		shmctl(shmid, IPC_RMID, NULL);
> -		exit(4);
> +		ksft_exit_fail();
>  	}
>  
>  	shmctl(shmid, IPC_RMID, NULL);
>  
> -	return 0;
> +	ksft_test_result_pass("hugepage using SysV shmget/shmat\n");
> +	ksft_finished();
>  }


