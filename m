Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A453CD343F
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 05:07:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BC2A6B0005; Mon, 18 May 2026 01:07:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46D1C6B0088; Mon, 18 May 2026 01:07:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 333EC6B008C; Mon, 18 May 2026 01:07:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 236796B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 01:07:33 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C23661C1BE2
	for <linux-mm@kvack.org>; Mon, 18 May 2026 05:07:32 +0000 (UTC)
X-FDA: 84779357544.28.0E4AE7C
Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011004.outbound.protection.outlook.com [52.101.65.4])
	by imf08.hostedemail.com (Postfix) with ESMTP id EE9EF16000A
	for <linux-mm@kvack.org>; Mon, 18 May 2026 05:07:28 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=YZU6OacA;
	dkim=pass header.d=arm.com header.s=selector1 header.b=YZU6OacA;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf08.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.65.4 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779080849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uo5fqv/+mGQs+foH4MblCt8ru2BZY4sRSd4BiLE5iKE=;
	b=QuDVGv8+bgjyTuAYmOrvWjBCRd9CAiZLBuFy3yagTaDqKMD3fk8yqpWDeR3eClQACau/EW
	xjI5UcqxXEZL5WLWUksCKN+5H9AoI3+qvgoOqSLhnwhHTuCt0fsBwKDlz7viJj0GJlh7AD
	mZ9XRtXMZHR8X8UkO0Q+VqnA0K4E+2I=
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1779080849; a=rsa-sha256;
	cv=pass;
	b=4rRpSx35hEoeiTdOEs/ybDWOGdg6m+Ez+tukgeDDVsTakvxSluLeNg4VEnRLVVDLrZ3DIi
	nwVpIfZ5DYHkGRiJj+3V4vk3DZE970gPzpkbRpOsEpMe50agb+zbWhUS7VGNGFhFRYtPWt
	26W36hxSQTEXyMJ5xl60zI0KFs/JoTQ=
ARC-Authentication-Results: i=3;
	imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=YZU6OacA;
	dkim=pass header.d=arm.com header.s=selector1 header.b=YZU6OacA;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf08.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.65.4 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=I6kFInhhpy6RiLaJW8DSBTC44ZRZVJx4erLzZtUYXc9+/m7Pr970qJ4DYgp53NvIjWq8oPhdzyzYKEEnlzPSc4NJrb5jdV58OzIUb4X6UzfY6/6Kwj9CK+pyHBdf8msNYwupRy9iSoTJ/EwYoJG4Cd4iPc5rZWsJvn8Ze6rd+Rc7TMs5mOM/aSq7RRYNADW56eaMP5nEVtMNcaupkSaM1G6uK6v/IbvIHrZCZVtCqnBXPDdkQ7glqfS9Ni+0rKAB7L1NUh/bt/Gg7CNlgZFyae0bKkOM5ia6d3NN7+wj6NKxNpQlTwocxK4EN4LE52dE54W9kRff8s9qE6dOLG799A==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uo5fqv/+mGQs+foH4MblCt8ru2BZY4sRSd4BiLE5iKE=;
 b=Aw8Jo1rpg3Jg0/utTGSFqxcHZ1e6wM1oNc20deNAjaxPe3ZexQVrz+Wg285c3R+OHmBSJ2Ppa+d0K+MGKtoTPDGTee+BvJLoMDaCPWIm5BOdKEWAhJd+FihpOmVlEo0SgPxQsKNiZhwQMiEWk6uTIEDFXrVyle0zauUS74tKyTCJhz8Q0SV2EA31YbBF9rTS+ZRr+T/rE9xrb5fszF8XeTDeY0HjZ1XyD8LtswVq5MuFEGshlu3VBESlUumnVBEMpmQixNctIa1K++Qb/nSLZn9DKaGEoMmBO/3rEAX2dOHUtJN85w0NEuhP6NtedZbAL+tji6g7FjFREFhFo0Wpqw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uo5fqv/+mGQs+foH4MblCt8ru2BZY4sRSd4BiLE5iKE=;
 b=YZU6OacAS0R06Cy2vw92PAZDb98BRorBwWcQsbJtGrP4Yqjdf51R3EtD/RcdHIRVsMoPo3XfAhPx57jXNaoWj9YHl/yPvZmcVYw+9TQ2uP73PcZjeCs8HAY+q5c0ezP5yyXIT2yHkuQRJtp6zej63DW3gK4huC06uGQ/wZ4RMUQ=
Received: from DU2PR04CA0330.eurprd04.prod.outlook.com (2603:10a6:10:2b5::35)
 by VE1PR08MB5614.eurprd08.prod.outlook.com (2603:10a6:800:1a8::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.23; Mon, 18 May
 2026 05:07:22 +0000
Received: from DU2PEPF00028CFF.eurprd03.prod.outlook.com
 (2603:10a6:10:2b5:cafe::9f) by DU2PR04CA0330.outlook.office365.com
 (2603:10a6:10:2b5::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.25.23 via Frontend Transport; Mon, 18
 May 2026 05:07:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028CFF.mail.protection.outlook.com (10.167.242.183) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.48.11
 via Frontend Transport; Mon, 18 May 2026 05:07:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pxdMRHaChr9nJG50lycBMZS83kt7+lJea44VJTN0QDlinM2anLOEdcw4jtLMf5In1eweRy4oIdPD3S3euBxeHFRoY7Ortvz1AkRDPryoDKP5e0FFz8v/P3oflrSp/h6U3fQ9SGITpqjv3UMCALrM1DQN3AARu8l6Qywna9+Mkwt/2yUPLdILF3JxnLWET9Cq7ZXWK7+1iu2N8TNCalNgm7+s+i+eiBKJngZRVevYWORh+CooGS43cDCu4teRaYHMnczMf9YQc71rW5TX9DVNqWt6ZXTu4SuIzqCWWYnN9NhHISby9Qgmwfwztop952pXRxHCf6lrdFbkifUFzj1zQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uo5fqv/+mGQs+foH4MblCt8ru2BZY4sRSd4BiLE5iKE=;
 b=E2T9vkz7qG0rsLaFdOHAjvL/+X3BZGTvvH/j3Ees3jBW+CvaMMxNL88ngnciMuGSsF7q+fh7N+6GRVPgbw8TGGLgobPZ4uA0h0Lr/eTOhamtij22g0IJLCKBxbpcFZCjSqsxpiMIVvYWJDKeWQ5U30LtuXAsquhh1Kz7I8qPrlOEMRIbKGjXGrnPKF/VNs4BXJA4hdATaK8/B2kkv3+S+hTlDYw9cu+hK/YoavrAXNeLNBPnvFRZiPpwRqBahMoavcdcp/utuFuAmpOkx/+1jiwOV/Gty73DaS33Ue1MJ6g7mW4DrF9o+7MIH3lfjyBc3dmy2qX7uOQH5681Ywb3Mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uo5fqv/+mGQs+foH4MblCt8ru2BZY4sRSd4BiLE5iKE=;
 b=YZU6OacAS0R06Cy2vw92PAZDb98BRorBwWcQsbJtGrP4Yqjdf51R3EtD/RcdHIRVsMoPo3XfAhPx57jXNaoWj9YHl/yPvZmcVYw+9TQ2uP73PcZjeCs8HAY+q5c0ezP5yyXIT2yHkuQRJtp6zej63DW3gK4huC06uGQ/wZ4RMUQ=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com (2603:10a6:10:417::12)
 by DBAPR08MB5718.eurprd08.prod.outlook.com (2603:10a6:10:1a9::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.22; Mon, 18 May
 2026 05:06:19 +0000
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047]) by DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047%2]) with mapi id 15.21.0025.020; Mon, 18 May 2026
 05:06:18 +0000
Message-ID: <62bb3ce0-5d09-4280-bb30-9f38b0fe6ae7@arm.com>
Date: Mon, 18 May 2026 10:36:11 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: add pkey_sighandler_tests to .gitignore
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260515125949.315964-1-sarthak.sharma@arm.com>
 <agoPJHwC_3PnH1BQ@kernel.org>
From: Sarthak Sharma <sarthak.sharma@arm.com>
Content-Language: en-US
In-Reply-To: <agoPJHwC_3PnH1BQ@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5P287CA0017.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:179::9) To DU0PR08MB9203.eurprd08.prod.outlook.com
 (2603:10a6:10:417::12)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU0PR08MB9203:EE_|DBAPR08MB5718:EE_|DU2PEPF00028CFF:EE_|VE1PR08MB5614:EE_
X-MS-Office365-Filtering-Correlation-Id: 7790bb27-053f-4f3a-c538-08deb49b580c
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|7416014|11063799003|4143699003|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 WdxMQROhiYRvnqfYTmLrANnKnXCQXmWNEPnaYoEOWBvglWM3Xv2/kdW1XetJ/Bct9VtlDDhM9RDYcKGhQJ4br9kvAJNiSQwAFouDNiuTA3C5Gn2OPolfYeP+6SHXH+/IVBTqfzrNsGO6hXW2f+SdKow3DClbfBeZvQ7QFDAYAOalXofJxaiQMGFSAiCbz7+Ts0sGhEjdJIE5vEz8D+JyrE42v41iAD7xGZfMrA0YmkkT2LiEcesnqcqCRpvkT6hQ/nbZCGmbgMSY6MlP8qXUXNWeozvoVb9T0lGhwbGmrbzsh9YR3xnNzLr5K9YDsCMbOzxqOir+siYMrdHgR+2w7EZMfmrFCVjNbgnVJbTVnpF2X2LBjwctMzXit5L6hMkBO2o9bIDCfE9sHyKXOpoff49f+QrY41tuf/wWgzKYOoleMkZkxTlsGpHhhc02lZW90dYNTD4KU4Zmp6FuidjZ8/u9a91LCTh5RHrRrgvvovgv3L6pYpWcvrtlVl4TzKAPEaLD0PVevbXoTR8szH4RglWE7wyjil42rXX045F0n0Tmk3i+QQTg78swCWURPfxMwyUVR+2CKmfo1yGEF8873fmzPZ5BUSGZ37jUp04FZWuQZnMeA4ObJv/VNtTZiUTwF7AqPFeOIOdfYkhG8YYO1G34urvwR/UvTwKIgeFPCAS8E0ffD01Dwnf8v2X/ecC+
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9203.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014)(11063799003)(4143699003)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 HEBkvX43v9CIOtZuZ0OOziqrfTqtLWJXlntA/HBQ9ox9ur7N45vh2WppfNEaGY+M0Jk7Q4U2t4NVEAoSmNMj9p1TDa63wPem0bM9HHdmHrcowZ4MKiD6oRQfFTWMZcPYKmpgw1LAAJuA0oIFbSWlsrPfXHwLwOUP75LOxZjHeJF3sAUMwUL1AnKJtDJ8YnQf5f89LEqjW9T/rQtF52ucERhUeiXjCmsWxUK3pNAlsPrJrPGbKDzYTS3Codlm8DUg6YHN2NQO9TNZ/+X9NK8qmL8dun8KSknXq+Q5Kv3gud3U/NO+qX0wO6RkB1eNppzNC1hym5TxWNXpD6Zp+BOeLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR08MB5718
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028CFF.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	19dfa9cd-e3c6-4943-2f51-08deb49b3191
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|1800799024|35042699022|36860700016|82310400026|376014|7416014|13003099007|22082099003|18002099003|56012099003|11063799003|4143699003;
X-Microsoft-Antispam-Message-Info:
	BkXUwjdWABEZKIbKwtYfETSOqQ91AdUy1/JUng76YfbyRyWBuRuJoqhbVahO1nwHiYxSE/teFQvTMVSm9yf1UTwhRkfEvOy0T8o0+mrIcI8cL+85O9P7HJbAt+kVAcZ+HTm+Q9N1Kb7Pe+BcZoekcYv5HlfUXdyQlC+cePLvfhjeF3qxBAgliIG4N43wr3FN7V5jYa+q2c0td4vAOyJNUa1aPwbTpHHA43ZiCtzEgfDOl6qJL7OtWNotmRvqozyIoQPBAqSwB0qTaz0Ay6Pc+9c9O0i+qYKLmZu0zRJQRtj+H2O+mO+5K7uNw5wpF1/S59rYjbfS6cMnMVRbyrG0UyKOfqLS+vq4dsL3o+dmtF0oX5s02L5pqZXU4iWMTd6odYVW+tqFKj/8scIoFUVnJK2I+snFBCQBKm/yhzB9UtxKV9LNVyRn9Mu7qE+rqIPHycngJbukm4oBYt+GU5aJaBeIgFsONhBws3volj8dPmIf1+8Qk/fcL18C/K1iyufhWkEz2V+igtwuwQH1prx8F4clf8GMywlAIn5flwqrC59q+gYPgpER5OUDJz7bqAb6xGY0kPHuffwXpzWfH/85AyUiBgg3DNm3KWDI9SHcBsADfVCuZ9lGTxOw/9thSm7d/k2lIQHCCx0CAllsxkXKQr+XrAB5IUqpduUpBxHexuzsJLAU6cVLplq0DwU2YCpY8daLZBnAAmJEaN3EWX1+eDO362aAwnwRK9aGKjvvw8k=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(1800799024)(35042699022)(36860700016)(82310400026)(376014)(7416014)(13003099007)(22082099003)(18002099003)(56012099003)(11063799003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	QMwpQ6drIh1cLjeojiwMkChjpoEiUby6TxgTTi2l16gPX23VbsZDNstUgn/8BvWgQxNY5so8wErk4UExk9OGCgbTOLi29rqD1UdUValtbfgY+ElhSOiJDYGDMpTmNkxnTj6GfUIbX8BIYlP1Z4orRt/gYsLQMcjkxQsDRb0jSPeiorbX1bRFZVLD3j+smOlws+ua9bW+SDsqTb9BFXK6CxeYXb9mmWFzYmo7FL7a3sCqCIKBTdVWJiKYcmseL/dtTpBcpV5yFqUtmORSjwSFeamcQIpg32WNrra/beb7M+pEcB9sEZkkidnax92nd2V79S1NM+pzcwKzKjBczmGroRgDC2FlRtabCwnj1F0EcU2sYO3Cdt5giTYrx0TKMTbH+UibTZQ4xp/fwBz4l6Ujt00V7ENpuRL6F4tucSBqBAh0o/Pzp71W+ebQB+U1MuSs
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2026 05:07:22.2415
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7790bb27-053f-4f3a-c538-08deb49b580c
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028CFF.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5614
X-Rspam-User: 
X-Rspamd-Queue-Id: EE9EF16000A
X-Rspamd-Server: rspam04
X-Stat-Signature: 5fkdrf33n9xz6t43wjpueugne96kdiqs
X-HE-Tag: 1779080848-993083
X-HE-Meta: U2FsdGVkX18GJXXVrTvxaAcejQYEkCts1fK1izlnTqQyAIOgIMzQimvGeULDVZO4NLVhU12fCZRvbmY4DKstnEtRmD7oIExrekCLat8wToQ5Fn9rhtw6BaU6viEg4d8nCu3upBxRSHFLQ2Rt3qw5G/+r4OtpmRS/sCMDXeNabtUzE+2vRC6/P74Y5UJ2eyqdpcqk2n0GCCPcRdhfJPL14DsMmUdIAhHTu9RKC3A6ZYnizsnxth1HHcI/Nk31I2fdaNJsTmv3sh7s8qNbaqIsOeBe3LuhWgLdmr4DZebz36nlmfdcyCOEDnjWUFwHVOKxn/lvBKXA0ZztcHhCn2THOIW1w/1MaCiNYtjZrVALavNLbGLcKICPuiMFNpwrIC0Dxk9A4Ok3Sh5v1kxgWPsSrbibgKueIlSNgzQDCQ+t5ucIuBTImlN8AdFq8sxn+Wtvp5pf+kdTBhVVIVpXXF1Eq/CVHMSICY1DOjq5mW+IS5BzeTud6DIPloYizn6fw8/h44XL+wBrHgvzT01L8o9uhYCEyXC6HVN83uyHsaEzJtbBl5AVJBtMlwNrAXzbCcAuvWpVjbzj2ChKENgbg996tsvan8G5Gfrz9HFurWrQuisfFm6UpXSUSjHUJGzip7c+4To3gIfVxDWIM0sDHrG+NxViqBO765pi8lzng2iPPt0UJK9CxZDtjToKbpHIqqrDr4HyvaDT6WBjIk8q+7251x0Vr2ZZan9x7+9Qij3PqHmGQtufJOl6lVg7yOiGK0w6KJ4cZEk1kREgyzJCPmjC83/xZyEL2MUxtL+XRS6acPC2/S1aH7ehWUYZQt7iI8UqsmAfJPdZciMZjKbIRyU6UqNUd85ptM8H7j4gyg26AWz+qs5U6HlKe7a177zjRn/A6GvRKnROz3q4RzfCwcw1Bdpl/gcw38M4f1ke5ZN/Tb30kOr/mnmwcMwjYKogiP1pXOsv1dFYuXO27gukTTh
 cspO0VFN
 eVXYmlgPjzZKfN4F0eY0QkCrbO78tt53+XW9DlhspxJrtO1aObtp2kmy/2jHtH7kN+dIKuOuVNDNdfZCBx0xpi4JZGWvfzGDb069fjeNSU5IScGFY3kjXBUxzdWQPUge9nD1991Xw3hwEGWyVf+nJEzJXmJR0LLDNDJXKuOQzfIQkC8N6YvwyoYKaYCb2/rnv/2Co62D1bQjZNEz95Lk/H7OyEs8irPr70LEAwBL9HYvJTnFjJ6Lv/CSNgY7un47HK9iEfanHiTt6v11T3dezOLV3YYCzD7EfcP42sqyUELSnqpharDV4/YGvJaHJ7MiYiCoaHEc7B6A/cHXF/TtOONiU1Cn7zDEnE3eUCUz81cI8jwQv6yNUu68jU+oUIlZQ+UsXZyqt9BfHk5d2CUTf91zAdg07doSDLouxqru9juuJL0Wv6oCFob6u/IEYf/2jMg9d408CXOBg7Q5rl0rP2geEz1A2ucVaI9EIL8q25Qwwm1Lqqe8VSH51fBePt/gqc+vkaLaaewPzGIcxognk8fvrGKyMvt7eZtKD7UbkxJf1C7jH4F0HQCkx+paMX5oq2ph+xkV3D/S6r+693P2a7Fw9XJ0Hb0FtoPiv/9uVBoMcGHbfjxNd3VgnYtHdYFtWFvgk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mike!

On 5/18/26 12:25 AM, Mike Rapoport wrote:
> Hi Sarthak,
> 
> On Fri, May 15, 2026 at 06:29:49PM +0530, Sarthak Sharma wrote:
>> .gitignore currently does not include the binary
>> pkey_sighandler_tests. Add it to .gitignore.
>>
>> Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
>> ---
>>  tools/testing/selftests/mm/.gitignore | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/tools/testing/selftests/mm/.gitignore b/tools/testing/selftests/mm/.gitignore
>> index b0c30c5ee9e3..1b1d9ed87039 100644
>> --- a/tools/testing/selftests/mm/.gitignore
>> +++ b/tools/testing/selftests/mm/.gitignore
>> @@ -62,3 +62,4 @@ merge
>>  prctl_thp_disable
>>  rmap
>>  folio_split_race_test
>> +pkey_sighandler_tests
> 
> There are patches that switch .gitignore to a pattern-matching approach:
> 
> https://lore.kernel.org/all/20260511173411.267628-1-pratmal@google.com/
> 
> With those there'd be no need to list every executable in .gitignore
> explicitly.

Thank you for letting me know. In that case, my patch may become
unnecessary once this series lands.

> 
>> -- 
>> 2.39.5
>>
> 


