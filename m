Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8224FCD342C
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 11:19:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B91D6B0005; Wed,  6 May 2026 07:19:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9902A6B0088; Wed,  6 May 2026 07:19:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87F6B6B008A; Wed,  6 May 2026 07:19:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 79B9E6B0005
	for <linux-mm@kvack.org>; Wed,  6 May 2026 07:19:19 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0795C160164
	for <linux-mm@kvack.org>; Wed,  6 May 2026 11:19:19 +0000 (UTC)
X-FDA: 84736748838.30.84FE1EE
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011013.outbound.protection.outlook.com [40.107.130.13])
	by imf23.hostedemail.com (Postfix) with ESMTP id EAE4B140003
	for <linux-mm@kvack.org>; Wed,  6 May 2026 11:19:14 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=R8Q+7Bnb;
	dkim=pass header.d=arm.com header.s=selector1 header.b=R8Q+7Bnb;
	spf=pass (imf23.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 40.107.130.13 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778066355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K4lXTRXfU6C5gyc/dESCTyKsyves2pEr7t81Emzguqs=;
	b=Z0tRDC2DWnbV2Ii8Rq/rCWEyKyfwhgEGsBBQXJavNKkFgKjalFnnrXGdOAKZLVLY53IcfG
	gijcKz9aJcVflFlzRgq7oYR30uC1eKgT40tL5K6zJQIcPL9EpauqxTX9HxUoh6X0vA1Gbe
	v4zYupZwTxoNLMBsI9+0mVhKDmRb9fI=
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1778066355; a=rsa-sha256;
	cv=pass;
	b=nSiP7P1RV5Vts2G7q0ogXnVhsATyuoLxivqP52Tgj2KwW8n6PNepZG4IQ50vkwy+Ib5Y6k
	f04l85bLWJjmjyCgMVjJvtlgbHKmojUrZ7334RFHbEC92/Js2m4NweryZ93Ee7evG21qNY
	nxA0zVKAwuVeXYkxXYd2WQVYFjZcC/4=
ARC-Authentication-Results: i=3;
	imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=R8Q+7Bnb;
	dkim=pass header.d=arm.com header.s=selector1 header.b=R8Q+7Bnb;
	spf=pass (imf23.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 40.107.130.13 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=W+rbO4hYFiDmsE307SjW/VqpsjM4Q0nIT5wUSw3DKewV3E0vFHvepHYtNNjOcNgz28vYXneTwSSdV0HWqvQJVJH7qFJ7PBCKz3XehUg3HGBvzpK6SaoqFp+KqLHyGr2tCmD5Sp+cNItmCjt7II/AtCmUGWBs9BOznZnEMghSV7YNDayPocJeNAWxrKNFZ4DfTHyvRCSQQ3U+iU355LANRV5R1YQ4/+2iqgreY3V26XYyT+bxvAHBo28rJWbDBxu0QRsE58QkD5ATOGbojkJjw65vHo04it6um6MlhrTm883My65Tx0sbdfNYvMcINSkDoyFhvimDyCxoz1By+slRgA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K4lXTRXfU6C5gyc/dESCTyKsyves2pEr7t81Emzguqs=;
 b=UFg4qRh8WOrrfolwZuFAAeP0U+mNnV4L6oQDQx2PfbJoccuGcV621cMNbeeaAdRcK0YxPbM9vtT99cA745P5VTDtdimCopUa8fnLp44kNwNGMsWSBGedJo6eGnXYrTsNNExYKbEptks622/Ix2pTBm5o4XlZPPQPFJzx9EusXwhMntHyzWNIH4K7Gv2jVf11jDV05tZsrk8KW+PyWyT5tKV+lLvSwsxrQta575cLOalPWrYpN2LPMY424cYh0J5tBADuX9tY6vkTaHGYS9lLJ+OaA9YUqO8xifuUpsvm5nxVAUe/mr7+Mlw/j2i0CAODeWkMYdHIUMIHqkF9JDke3Q==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K4lXTRXfU6C5gyc/dESCTyKsyves2pEr7t81Emzguqs=;
 b=R8Q+7BnbmfY4gnM6zHiMb/yCMIJy7a4ti0GHw/xiZkbIUFDbe6uh3m1uWGCbnz4UD0236LfcoIqjWoqv+aZ1YJlrnHObhmueMRS2QR/zYNrggxC1iyYPByHWJa3ASiT0Q6RBqgfVL0Y2VnfdFH+DRgnGJWRC2dUldRXnrtoUYmg=
Received: from DU6P191CA0063.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:53e::19)
 by GV1PR08MB8083.eurprd08.prod.outlook.com (2603:10a6:150:95::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.25; Wed, 6 May
 2026 11:19:01 +0000
Received: from DB1PEPF000509F3.eurprd02.prod.outlook.com
 (2603:10a6:10:53e:cafe::44) by DU6P191CA0063.outlook.office365.com
 (2603:10a6:10:53e::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9891.15 via Frontend Transport; Wed,
 6 May 2026 11:19:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509F3.mail.protection.outlook.com (10.167.242.149) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9891.9
 via Frontend Transport; Wed, 6 May 2026 11:19:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A/txiHH5CGN18Rs053WAuI3cyI20ND7NBCzwEw9ihm/wRctxoPZl8X5Pkya+NppSEKbGtEzlHyQ+PLfWVbE95AgZzBkwe+fwUKBwtpG0dYZrWtwUJlrVrcEtzjBgqrKF1KbplkxQRbe47secvo66kQapvUjSXT2SkUyo3p5QJQrnuphxzLIQZ5HXi1wpzhW9LsyowBMVSX4W/OFdQ9ek3G8mUBHb3ELraKQ+Rx69aDFDlm0hbJG98JUVaCGt1trUZ1arl5qRjMeraQl2MIdIWfpf6ANLOZtGv3MBz/aJJx249NNWkwxJssat0xOqpvBIjVJJXA/1AL0s3FDMI84qQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K4lXTRXfU6C5gyc/dESCTyKsyves2pEr7t81Emzguqs=;
 b=gTKUn/ixjhPonQ7eC5jwdbZTKd6QJD84xlCqNwfO5GREz8niWMdkrLIAJ4gO3l3pzvwzc3oqrl+qtZGn3bhgNUZGDn0e/sBP+gQyu40TsRzeRiOYsPWfcGyvrUa5JtZ4PdvGVDGcMjoVLjcTJfI56p8P4PgYdsK/X9eySykAjpBEwYcYNTeMilN6YaZ2iM/u+DVbMPvwLVK/EGy9IP+iaiutFQOJD+nWnt5dccyH1R/TlC6fF9sswVXy5ef+g7ekYXdzzK1sHli8VRFQR1yH3UFdjoBgxpOBOQqRIxQyoV0n+rPeSFpM147Z8rG5u7djCEG+MqT81WwSTueQ942lsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K4lXTRXfU6C5gyc/dESCTyKsyves2pEr7t81Emzguqs=;
 b=R8Q+7BnbmfY4gnM6zHiMb/yCMIJy7a4ti0GHw/xiZkbIUFDbe6uh3m1uWGCbnz4UD0236LfcoIqjWoqv+aZ1YJlrnHObhmueMRS2QR/zYNrggxC1iyYPByHWJa3ASiT0Q6RBqgfVL0Y2VnfdFH+DRgnGJWRC2dUldRXnrtoUYmg=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com (2603:10a6:10:417::12)
 by DBBPR08MB10699.eurprd08.prod.outlook.com (2603:10a6:10:52f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.25; Wed, 6 May
 2026 11:17:57 +0000
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047]) by DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047%2]) with mapi id 15.20.9891.008; Wed, 6 May 2026
 11:17:57 +0000
Message-ID: <63cd599f-681b-43a8-b5f7-d4cfd78b9dd2@arm.com>
Date: Wed, 6 May 2026 16:47:48 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 27/54] selftests/mm: hugepage_settings: add APIs for
 HugeTLB setup and teardown
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
 <20260428204240.1924129-28-rppt@kernel.org>
From: Sarthak Sharma <sarthak.sharma@arm.com>
Content-Language: en-US
In-Reply-To: <20260428204240.1924129-28-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5P287CA0133.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:1d2::7) To DU0PR08MB9203.eurprd08.prod.outlook.com
 (2603:10a6:10:417::12)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU0PR08MB9203:EE_|DBBPR08MB10699:EE_|DB1PEPF000509F3:EE_|GV1PR08MB8083:EE_
X-MS-Office365-Filtering-Correlation-Id: 2980a894-4204-4f82-3565-08deab61464d
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|7416014|1800799024|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info-Original:
 Yuo1mHKj8ErZgCRRnMdxIzAu9meZdvR/7Fm6ji8HZ9redPl92UJKGK7qyAaKxE4b/3ILSejmAbhxSKGk6Rfk0LlRPjf/GdUjSV3IKyTtpaKeuBak9GBD7VkTZwAbz9vZIqrC/T3U4cVgSlXQ35uy5OY4L2UibXWR5Z6Wx3ixxZjLOGVIz6CV/jJr8674RbS3mPFL5hPldHN9gafBxg5504kbfrXtQwucOYVeJNCNUO+ta/yWWMdRq2akwURLHUxrjTN260GhUsmzbRj+KdQk7xEL3lTHl2Asb/z+GoWrtFVbbk7ULLYAvl7yEvpd7Y3iZD/WzKP44UikLj1TcwWYinHTgkTHmwi8OYLLtV1rknIRk8jhprb2eoCO7IIqA9vC8FUrSQQxBbQS8h4W7GLwpG38GWElCb5dvijxGQGnGGruUE0I2RAiT4WIA1kmmPgyE8vocEIlar/LSK/z/ft6K1bwW0bx11ZybfnrFV3we/0o4cieRmG5zCuUaOtUFgA8mIeK5qSnB5OwCCLgGCl85sK5h7QM7g+6oHGcr9DcPF89aVk96VQysSuaRHyz0Yiky3abBY8RvymsLG5yqgmDwDMTcfBRBOVt8Lmm9PxWwrkGtObxpwVmqkWC2caqobyuM7tb7/9CUl0rPRJE8rEwqqFq5NXUtdmaMYUCEmZbvj5kOfbI5HPfGMQRQsqhSKZq
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9203.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 k/qMZx8mTszjKsg0EmfhDAqLSh/4aBWQiyiYyp9K7nvS5d5txRz3YJpui1w7mtaj01hnOESrTaOn51UsffLAOMhcN09Ry1v1i3617fZOk8Jgvt07zW2C1YZLcx9VXYg4EknflnNF2r2NmM0zE5TrgO6FZ3wE/jURV6G+B//LtiDXf8XzJZJZHsyc/rwfptFbXFiPwejEmtL5vUH/lnW12ICMu6qWEHXfS5psafBbj45Jm2uNbvKUZjkf8aKFbDAon60bC664ZlSUujLwuIsKSnN8wSIhzWvQ08r+PFGOlj7t6jfCrC7G4tXDeaJccbhUCteiE6crjk0+HMTeDwiqFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB10699
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509F3.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	db124cb1-4205-4a0f-7381-08deab611fca
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|1800799024|14060799003|376014|7416014|82310400026|35042699022|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	zqmAtn/lLo/+ihjbF/SgaL9ULrW1VueuiYKqQSMMYpKCDz7Rj6Y0S+M5kELvkO0xu7K/DD1plHbiecilXNS/xcLux6036cS7zODiExDh4+TuOl7zVDsoO/oDaLL6ZoUgsF1xeh7DuNw66zTXrjtfEUSpJjyZurOTcFzT8ZtCMF4DftoCe0r3XzJ1u97MCvVyZoz9p7MC9wIsWuoTM0wOAUS27mCbwAjG2oMGvhHmuzQl/UL39qpr0ieNmrwUBlQobKcX4ggGBbErHFbNfIABpOh63XCCwW19QVIG9fR+rYNW3l7N3YdLpGfhDg/ZUtcPzg8wtqhccuJzP+sTggCDkvZ9IzR30uV0LhEMrcNIWTqc1WoKYf5jmN2pdPC7ZqHvdOv6STcXvMgDk+AHTd1Q3umeTTR8p9WKrW7H7NAMqMZlGx+0SFNxc3W16NUj7hJ4C30+y+nJITq0mOhRkY9khgx4OhBGbpg2MqLon7gjRh1DeZPFtdPVk7W9hHnzz+WnL3Porhl0pAvWL/tE4cbtqurEcxgmTDK1m+9Et/K9I9BphVTc4XyMwIf/7Q2HL2UQFU8UKYxFUKzlJ120CijCCdruV+VTYCJzFtBCI5jLyK/KRb4vI4abPkrMokPArM44sHDv6tt/8DJZkXZ1Vl3SWfFjrXv0BYWKfu+R3wMtCyoBh5ds6eZ0rq7u9JCERqC34N1Dz8+IzN4H2OfxcFIdMx399qU4gR2OSuJJoDeUOQs=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(1800799024)(14060799003)(376014)(7416014)(82310400026)(35042699022)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	0HltBVW3vKyT+sMsyDRP2yH5BYvPpN0tjCcmhYRYn7VuYqYlNA9VX5/p2NWy6GbX/05/HL74lr79/gcxTkWp918V44eRC9JuLhAIDUzgtQYqaIubYw0B5E0m0aXf+AYqlgzm+konnf+Hkj329ppLbEqh1hjLSg8TPu2X9Wanx8yByKPd4TjmaBfr4vRUcX/x0FcGXDGSCa1T4ReZWV0C8Gz3yg+3FxZ4sFNsqIwSIa6/HF20a1rLBhfa1ACCfujrR5F3QlpnTgrJwn0VIpbJtROi/WuNrbStBnMNbN0vajVYdET/eBqxAXNXVagLvptz88tQ1fOCZ2c9MtRX9aA7qgciT3EMhvYuLfXrbXoZepNq25dqxdZIAKJDUWBCFpaBMcc2Ss9q03ttrX/lL5RgipL/+JX+SHbD8hVG/cQArGIPCAVso3awN21d8YpYIUqT
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2026 11:19:01.1766
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2980a894-4204-4f82-3565-08deab61464d
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509F3.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB8083
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: EAE4B140003
X-Stat-Signature: 6mxi77sifzzx65nqn3ucswqam4ab6qrs
X-Rspam-User: 
X-HE-Tag: 1778066354-538786
X-HE-Meta: U2FsdGVkX19PAemGvnnu+NWK7inB2ahkTIhWn3yw1crC+3p/ZvBsYHgLhb4XeHvTULMztGpbqJfw9WwC0+UNuDQBxAeTT8kYKT0sGBFUnynU73gh3IJprDFuL1yzeoHQKfVcIrD/cbi4eKOGo5fTFLnmGzNby+DhdtFYWzB5vspavVTdDtQz4pBUUjryBpdjcel/fz75ecgIBMtEJsB8VNDwGU+EggMv1eZR6AJxfn8qufgFeUn+nDQFIBOIMOvBt2P4HYfvU/NvLryElvt7By4mI1JExvjTIESAQArTK8sO6g3msUz9mxYAwxIImrktNn7oEu7qyVMsamjVGGlXC8BuREuNP1U/ovHgpQv++Y0iAAn2l7y7QhEX1s+HkYAyic4VyTuTneYiQki1dSBKQVDasoP4KlaxO5NbSgkv52Y5lr80nHcurtmb36OLnwMEPIBybtpbjjB6P2HtZQuZ3u9N/LsyaDKr50CoA5O2WQxphuHzySZnsRh5pLOquZX1byqX3Rc+QoH6S5Ss9dloVYJbSF5HasjNXd16GBhQwoeQ9LCN12zc7c3a5yHtU4AI/KMa4M2AuY1vn4i3XPMIN83Ll5C4MM0USgIMEuyiwzDpr/N2asBKvRZAVEeR5YKrdxSlectuPak+xF6Fbkg4Vhh4JA29H9wbW5YChVXlGB1XmtRLq2NEps69hsM64SfDart5M7Zk++N1ct29tjbCSE3u9Ro9tZvCFUzm2A7+xkM1+uz+Ps534X8XOT/dlFsdQQRjTG/5/c/RVDpJeu5q0IFBgfueFryrXWqRHtqY8JzE8NzMoWKnmgy+cl4hXipGXlxgRWOkqB9/DLoRZiZ6jIhEYdRZxIXl3kq2GmVgx4ZXPbEd4m790G+VeB2HrmwdgGbJZdWi7ZoZUD4+g3jPza138CJgL225DJL6fIw3XvJ10zq25bIIFADKmzrPH/09NVrn8FWuUJa3s6STn2Z
 9qTydTNI
 OVYCf30X4osfZqXJU8bJ/29eWm5tdUnOFeaMk9KDk5QEeKv93qefJBZD7fsDt7OK0iMzjH3SPkkDydAsMdULbnpb+rpIMCEWL2973hbXpwzupldCUJfN2Uebl8Bf24RqZ03cfLF3txEB+seyIYdRjnlalKTTYLxKKLFrdbqdzab1xV2AW5/pQxZeTiULoEAFk0HC/1IaozPQksXkIgjuK343KE5OvD4rC4VB6nNjOhZ6o7itUh4rry1AYNsOzSPEZw0xkp5j4Fl1LhRV4dn5XXJuQchcIwwMQqXQog8R3YhOJbGNwkJtSKbvAE4JmQ3hKfQFaYM5gvrStpRfrv2cquYck+Ns5g4/vkRJN+3zQ0Ro2vsihDWgOZKgVuZZ63Rq9NHoFu/LD1iyax7qQM2OhmlDqyuRf7XnjZoDROdZmnR3YWike5/Ye1uVa0fS7VzSFzy3DDXNkQIw0/++FuQ01q2zBfA2OkbEpGS+qQirNkHJ9eTPDXwwp7NEVXOc3WAxZfiJwhU2imYWVHZ65A662r46cs7au8zOyjI0KQtaXWySe+y59f2A15V8BIyTvEHQor/RzcQ9nsgONSOYuJDMTrajA8+f80/sZVTm1UmTt87pDTYM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/29/26 2:12 AM, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> A lot of tests require free HugeTLB pages. Some need just a few default
> huge pages, some need a certain amount of memory available as HugeTLB, and
> some just skip lots of tests if huge pages of all supported sizes are not
> available.
> 
> This all resulted in a huge mess in run_vmtests.sh that sets up some huge
> pages, adjusts them later and restores some of the settings if the stars
> align.
> 
> Add APIs that allow saving the state of HugeTLB and setting up the desired
> amount of HugeTLB pages.
> 
> Saving the state also registers atexit() callback and signal handler that
> will ensure restoration of HugeTLB state.
> 
> Since many tests use both HugeTLB and THP, the atexit() callbacks and
> signal handler are restoring both.
> 
> For kselftest_harness tests that run fixture setups and test in child
> processes add a constructor that will save and restore settings in the main
> process.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---

Looks good to me.

Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>

