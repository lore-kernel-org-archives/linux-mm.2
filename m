Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5046C624CF
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 11:23:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD9F66B00BA; Tue,  1 Sep 2026 07:23:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8B5C6B00C0; Tue,  1 Sep 2026 07:23:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A52836B00C2; Tue,  1 Sep 2026 07:23:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7B3116B00BA
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 07:23:01 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 89551A03C8
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 11:23:00 +0000 (UTC)
X-FDA: 85164956520.02.F276DB8
Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010052.outbound.protection.outlook.com [52.101.69.52])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6D60C40004
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 11:22:56 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=nMZscLZE;
	dkim=pass header.d=arm.com header.s=selector1 header.b=nMZscLZE;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf12.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.69.52 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788261776;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=StFAYWQF4wusuPIufLwWXJ29iSTLjcqX+fJORRMjcdY=;
	b=6ptYwelk8D6SEwT5XRHKIblKPUheB9/mZ6JhMV3xd3CdMGf040OlY/yjcBodQpEayVGFHj
	KzMGHrvmr8un+tGf7O2b1k3pQfOfKeHie09kwpAlpq5MlhG68lXERy9DCfoU/lAAYsikyD
	1wqPh+b31pXv0/YHP/dA9j5YcUbLvE0=
ARC-Authentication-Results: i=3;
	imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=nMZscLZE;
	dkim=pass header.d=arm.com header.s=selector1 header.b=nMZscLZE;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf12.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.69.52 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=3; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788261776;
	b=akzoG447iRdxyX01aNUxPXGIODdOPb9zIB/hvc/0a5+OKFV96faDpnfGRoZybWip7Q35JX
	4bk3NsxUqS8wU3dl+bt49kThd2E91WF3YpU+Q5+VTHUneMheHt8igDpS0EBzFgl6/hUa76
	fkUv5Ah6N/8FXr/fr6aQ1GCuwij1cvs=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=hamJ8dLw8EUQ5wrrpzmpMKzeaV3vBSPYvGUBOyoC+oEwJB1UHYdOq5DqqktFXfLsFfiDisFyXwu4/YTK4EQRPIVfIv3uabxf3tUgjj6pFVRDaRBhzIdQzLeh+XHU8DoO020N/+WJyLtuGAIR94gOjTgW1MibwHs2qy9iTuw6lgNBP2NwwA4wkg6PjzB+h8llD9PQzbFFg63OPinJaUCWDjKNhlb5QoncMBI5gqgXaUbhW62XOxEgn8WPQF38QvrDYhT+TC1KoBM5FjzLUq7R/Mbg5qcjrcVir//1EMXCHvyD2jN1v2VU3DashJnkcAdeemXJDgCV2SQfdRcd3KGuvA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=StFAYWQF4wusuPIufLwWXJ29iSTLjcqX+fJORRMjcdY=;
 b=bxfgB0wjzTPJbXi5jTTFbaioxLaftnDr3SUH1/Ts5jlCDRt1lWSk+V5TlumUr5sOMV3x1nAnLPpItRI/Z4c7G5gPreMbJqabCQMM2brM0Xql+DyJ9PShuvLvv0DWAKeMr6FwpqRF964+EfeFo9Z9IUKhOqU9wWS3MU3CoTifboUxUyPIOf/Du15hnSOg1zImSVOL0ZMONoem4ftXRcL12HGKs+kgJHPAYuym6d/WiRwZbarCv+b7d1GXiWKCHKnHrDJfRRYG1x7HfW0Vj42iDWOXHPXfxijh+n/FrRybmi+2x8fHMFcdvUTz0bMGob8TzW/MzWful3JYUIPZBvfB2Q==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=StFAYWQF4wusuPIufLwWXJ29iSTLjcqX+fJORRMjcdY=;
 b=nMZscLZEiKAbxY+VcQSSi7Q4SIgL2v+44YQaPya29ngf2aIJg0U+Aox/+BQdHKtpRv8KjX1krGrOtwwjkxF9CdYMbD5AfLhhtMaw4eP/hnsFvLegLlt0K2YzWBBnnQCSLmUQQBpKyXMMsmadVAD5J7vEGElojpq7Xw6wSHinrVU=
Received: from DU2PR04CA0279.eurprd04.prod.outlook.com (2603:10a6:10:28c::14)
 by VI1PR08MB5519.eurprd08.prod.outlook.com (2603:10a6:803:133::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Tue, 1 Sep
 2026 11:22:51 +0000
Received: from DU2PEPF00028CFF.eurprd03.prod.outlook.com
 (2603:10a6:10:28c:cafe::9f) by DU2PR04CA0279.outlook.office365.com
 (2603:10a6:10:28c::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.10 via Frontend Transport; Tue, 1
 Sep 2026 11:22:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028CFF.mail.protection.outlook.com (10.167.242.183) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.8
 via Frontend Transport; Tue, 1 Sep 2026 11:22:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Nlkij7ZFyooLyHSDA9rvokigevIhy0hm5yAmTYRcy/CpTQkOwqSsF5Ts5xK9qnLNEPcVuX2efnnChp6PN4MYsPLZv7kYfH4+/1mtQqFJWL+PDnd1WP9F5pSlLpiGN5dBaI15IP8+LP8F0/JFVft6AcKZdoKKYwShoQqaAw9riAwsqEWxc/4SWDvuyH+JTqGelRQyqgZ+lsAiuYT5V33fen/pCwvmbcUG99x5EawYICUGOhTJbR/TYC2X649mT3yMaLiGRFK4Omx8SD2IeaDMsj6q4DXth7PBqGcUYCNxYiSOhXlAxDHnWBL66L4eZmpEPiZ7EjF0QudHnt6Boz9wGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=StFAYWQF4wusuPIufLwWXJ29iSTLjcqX+fJORRMjcdY=;
 b=vqVT2tH1WyxkFE8HwHZFoBuU2Naj1bBcksoGnEfzK2Uix8xqw3D9Cl8NtO907ueQa0M/+9ztIdU3L/NPv/7RpWnht2sNfjEcBL/y0UpAHqmPXNu04NRpoaHy6YLU3mrgtEZI8G4LBKL9nOu5qFwFs9q37Ar+5LxE8/k+ZU5lFZYsgHUaRCmu8cF9Q7nubru7QA8/HJOomnWYi1oAp7nveQlqVNSrw6aFrauaas/wdRYdpDe9r1HTFoDjXIekpJVP+4cb68pjon4Q5iCh8VuzOEs8ZZ8lGJrKVte+PteldFJno8X4UQNP8PBfnBUPBkT/XHLssaYmNBtj8G+eSRzJ3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=StFAYWQF4wusuPIufLwWXJ29iSTLjcqX+fJORRMjcdY=;
 b=nMZscLZEiKAbxY+VcQSSi7Q4SIgL2v+44YQaPya29ngf2aIJg0U+Aox/+BQdHKtpRv8KjX1krGrOtwwjkxF9CdYMbD5AfLhhtMaw4eP/hnsFvLegLlt0K2YzWBBnnQCSLmUQQBpKyXMMsmadVAD5J7vEGElojpq7Xw6wSHinrVU=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com (2603:10a6:10:417::12)
 by PR3PR08MB5802.eurprd08.prod.outlook.com (2603:10a6:102:8a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Tue, 1 Sep
 2026 11:22:16 +0000
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047]) by DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047%6]) with mapi id 15.21.0382.007; Tue, 1 Sep 2026
 11:22:16 +0000
Message-ID: <f2fb4b62-f96a-4df4-915e-eb7130671515@arm.com>
Date: Tue, 1 Sep 2026 16:52:11 +0530
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH v3 1/2] mm/gup_test: prevent overflow in GUP batch
 calculation
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260901083452.115365-1-sarthak.sharma@arm.com>
 <20260901083452.115365-2-sarthak.sharma@arm.com>
 <apaqJk91uAN-zD66@thinkstation>
Content-Language: en-US
From: Sarthak Sharma <sarthak.sharma@arm.com>
In-Reply-To: <apaqJk91uAN-zD66@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5P287CA0100.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:1d4::7) To DU0PR08MB9203.eurprd08.prod.outlook.com
 (2603:10a6:10:417::12)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU0PR08MB9203:EE_|PR3PR08MB5802:EE_|DU2PEPF00028CFF:EE_|VI1PR08MB5519:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c47fe3e-1ca6-45cb-aece-08df081b5c1f
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|23010399003|376014|1800799024|56012099006|10067099003|4143699003|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 yIJVF0IarOMo+4fEOh7AxnEAxAvpU30P+G1vDi9E1sj7x778doRYSvg8IIyfUih14fLDCwOTzlQflMb2sm1bPhOoGaCa2ocizI+x2sc1f/qC/Lsagg6wUGv/oh7uRxPMAcd+mGps/xDhcLqoHf3s73UyVhY4wb5eAUet8uuDBINGcEsyUeE6V9c9RrhJmVSB5SkulK3h2NqMPt9NbGpmIWNHlTLDcofm3S+XCZOK4XrCmDQuxDy0JZc+u+vPZ/s3clAAGKOpxMQKfSA4CMco4mwDvNeibSTDjT8RBDm+1LybBe5v/rWpxe3mhKq/UrQ/TdWuVnVhmsjk9m/J26Xeuf8MxFuPPifCDmAx/J5gQeyIEMS1qEp8yqUrIqIQ9ULiVTfsr37vwp/6WjGswcVJFMf3g57AXWdE8RUCBt5Y/MET+M6s6LyoZTq5xnazIv6aRTdp+0kuRL7TtdvHnrqLMQdNY2/GUIvrRm5iuIYWLbhY3H3d25Xdmb7GQ3k9wXkU47x9cTwuzfvg30lDLENkI7k/nv5KqlHMcgNduP53UB71VDXuhDGJDOyOpwuHZHoJnGlChmRQPzgn30TErLiu10WO3V4ARzeORAdwcCduL8jLr3oCZF32QsnxYcaYnCGZZRa3Mm7IlWasf4umK6KoJ8oN6ESMY7tvgT2ve4ggcys=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9203.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(1800799024)(56012099006)(10067099003)(4143699003)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 kzPnIVGSEvBeVs1V9BmvVHMY+AkKqaaeW5n3VI5Nn89UFzC+XaLtfEUHTrqF+STBxvZcw1BI6LtLSNWvk2m50x6HHGOGPG6DT7liGg2RDQGntCQqA+IagN+63Wt0yeHQOFexDE0TbA3yqNR9jmKdHqqoBPhzfNVbE/vUJDQcAqXDXCpdzQFwx+Y+uWMaUw0HPjjXRmkJ7v4+1TRxPYRiT3dKo7uJfUEu1g4OJRWc+OZZzXQlFnHJpeeGZBg92NosGPH95lmR5SjweIaXNquHTPSVXd19cEQantvr4fvmjf2gGLLKcW8w3ggASy1DIMwo8LxKYYjvT+J3YGU3KGvWKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR08MB5802
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028CFF.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	453a4968-7753-4267-9894-08df081b4745
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|14060799003|1800799024|376014|23010399003|36860700016|35042699022|10067099003|4143699003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	6tiFDpl9P9N/LMBvbt56IfpxZc3+QOCdbGezbvld7ZeNT+DhmfemfLyCmq/dkUJt0nSSlYYUq6wtcqSj1k0hUNUqMgxq41e3h7+WyRH6GgYupMelxC/3Mo8Zo8x6QZtaj2xCAos9fQiiw9exDr3gbADDHhyhVBOfL/sN95Yu4RMi2J43nydSXr2vhUlyiUPtrxuT/PrQAQkRyQ0F6TGB2BEwp6XHmOD2xs7fwj05e5TB1H9tO16rL23+a3QazGq1q2HrGtFyexWID3zyWpoeokjurD5Et9gqW32mSnVIqOQSAogD2c5mZh6lKFtmO3uU/HFrJCYn2rWtOctN63XMsFbyDWlwi/rMSerud/e+aEdeARIjh6wQtJcqQ27Em+Bk0fuq00QLwY3OiZmqfXlVXMp/TS2pB3qdPnunPEgObhgNbW8C2zBjVY93hrKeI477qiiu5lsAEphJRDNXO87i5rWVE7q3Koi4VLqzS0RkqUf9Gz86REiaRvFGj4i4EGNu8u6zmA41XQdyAfUELeyF5pBLuec+eVm8zwhib6pMKRNuzI9X25BgyZ1GYnGuLdP8xfGsIs+DcuxNULFfONbitG3g7QvEfl3E8+ee0TwyYrg8MXyMk9q32nOzIKyuBVY0L8kxW7Suk6xE7SV03+6M6WVoRDr2gB2GpaMot97Jg7w0SyedMdRQQwoYsszcHQp/WoBCLrfdnWSw0tH+ErvY7Q==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(14060799003)(1800799024)(376014)(23010399003)(36860700016)(35042699022)(10067099003)(4143699003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	UByMnPP8+rfnJK6ll8iscZjLx89UFLBYO3yYWUpPpyMKkaEbuGDLSAYzwnGV7vTmYpl7W/EfVt49hiz6gHgHe5ieSKxdQNXCqZoc+fn7Qc524vTdfi7eYQlQQipMd6G0/8Dbb76h/sh5YTOzbl9hDZvF6dWqsg6aJcbvDiOxVL9xV66bnRF4pQqDk5g4wNZ2reMhsN3ZVLuBE9OhCOEUITEzc4fEeheOl64R8J7g4vENtJxXEnphhN/X+UxJbxcmO6yueKQz/0ZSQJSs0Babt/3I/HdwCBaMSRjE23HWZIlDmCqnHNUCH6K6R83r62sfMF82FBt+jpTbeTtZSeiRQFHwU/k5jaCIlCB2MCQ5unUi/ED6Cu8cckrXeKWnq0xBOx4XYNRq3+E9AdFqHduNtMLWWiJvbNqyL3BmprFq288ZqrJAlu1IyYDy+j2bniwz
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2026 11:22:51.1606
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c47fe3e-1ca6-45cb-aece-08df081b5c1f
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028CFF.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB5519
X-Stat-Signature: ctp1oazqmdnpadfn4358o4bmk716n88e
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6D60C40004
X-Rspam-User: 
X-HE-Tag: 1788261776-180957
X-HE-Meta: U2FsdGVkX1+iEZWGpOTku9p/nFNWjxzCpXkQhITOZkMgJVrqdJqp8qXPC+Y72p23Gzzcpvh1MhgLHB7UoA8qccI4q2MhUddGZ24s/4fwp5MQslznhotl/ie79o9nhMUgSzsMYrj2Ebb/lZ8LbcNGP53h76ulN3t9dYKlxedJrR2SmSqBc7XfKnGjHWW5wFGRgAMh9OrMaVwcZp1pcyniO64W2xgWISesqvYUrcjrYmNGF4nsDM5MZCx44f2drr70TBYoZskPSlqXZ8QN54iQqgOT6/ajTaH9j6GWkoQoxrLbi+6p1ng4ELtHhC+EdQwCyvX+phxwAl4Do+BAxNE1Tft2tYDPxRBa0ASoH26l3wPefyChSxCe90ck5Rj+FMiz/Z/dK9LbbujxN4vtSHSQ5dXHq2nkraZsUGxbowiYZFRqoKt8ku6xyh4i4+Ov/xCGa5gmAL06TlHFhs9FRHPx5hu8ayxFT9THqa7N+4mzGXLGlv+dyPWiD1tCXlYQBsq9rK+IGqTH5fbkiiIt1r27q8coYV127Oc4w30uN/PW24U49/bipxgZpG1UM9xxFnptljQjXZXP/b6aaD0wK1132ED/Tuz0rIKTTtX7mtigMEQcfSGTB+I3V17MkWar7e69PyYr9b6UDiFDYdZMvmYyymomzsQV0NBb6aNVVCfVc1gXEx0gq0SsnT4+Oj3rVAHzvKg33JIbsF9Sq+ACMWCyb5GouF4Jg9uafin8AVPGQfljU0m2BuWVxg29yChJLXnSMKeKgyUTVseYh7umqWIQOJ0ONplDCqGUpPLMT3d5trufqYgvKhiTG8UnDzv+7l/1ApQiD30K+VRVbyeZybqfROuxw+y8fyIX3s5Z5XnJO1uvziCLjOSfI5Gfh/IhzPfallKRiLSUGZuPHwQm6GBSk20L+nuzLnFiokujn6QoTOT05GsoouePBdvqpFDvXh/wUGI5lVotdzHJ8RtFyr7
 v1mdRDax
 3nbHAM/nqGzGqTpgex9j9SSAn4i/Un9EMC7Pz+XySd4JFeexndhg+/ociig4NKUq5AoNNVnv9xo1O3Ve+POdSiK+WU8RCkxkQNs5zjYNuPhKW40nxoVUbXWKjzbepWLpA+HMiO8offet1Smi5zQWMctqGgL7JcfTryiQwfqGdhG2hYUyBJ7wD1c5q5a9wUDDAjWyeaZYZ0xMNWWCktVNsE71SZVQhSa+baaWsDHBy2BEPHABINwNSkqWIxy/VhjpNd+KKK7TBK1m2jIG2dzljavKx8ZNjehKYmf43ygp3UQ2iho4924MHMbqrwVPAErQjYJ660mJZjnbBdEfvmMEmLlz2sEXn2rnQogEjZz2m38WLPOFYHf+TWQdkDSyaDeP3NS0b4b7aAbPuswFBLT+weA1sutjjmuvLFiMvh9XMiOWsG52+2WFBFlKZZIdzFuDUKzT4kPyfJU3qEQkztWSDyMq7IwbcHcYKkg+MOFsR/iXnylUF7XAN6Oo2eQEKZJHtaWktdUYpjg8NFhgDs7svyPdC8bbgqxX01tTC9x98bTMvRZaiwrSmw3EiqUIdUxMc11AhABzuO0rvRnVJfaqN1lzT6EdvRumwLGilRbqiXjwUpvrPjFceuz5MqQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Kiryl!

On 9/1/26 4:05 PM, Kiryl Shutsemau wrote:
> On Tue, Sep 01, 2026 at 02:04:51PM +0530, Sarthak Sharma wrote:
>> __gup_test_ioctl() calculates the end of a GUP batch using:
>>
>> next = addr + nr * PAGE_SIZE;
>>
>> If nr is too large, it can cause the next to overflow and wrap around.
>> If it wraps, the next > end check is bypassed and a large value
>> of nr is passed to the gup call, even though the pages array was
>> allocated according to gup->size. This can lead to out of bounds writes.
>>
>> Compare nr with the number of pages remaining before performing
>> the multiplication. Clamp it to remaining range so that next does
>> not overflow or exceed end.
>>
>> Fixes: 64c349f4ae78 ("mm: add infrastructure for get_user_pages_fast() benchmarking")
>> Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
>> ---
>>  mm/gup_test.c | 5 +++--
>>  1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/mm/gup_test.c b/mm/gup_test.c
>> index 44c1cdfb9c37..910cbef709b4 100644
>> --- a/mm/gup_test.c
>> +++ b/mm/gup_test.c
>> @@ -139,10 +139,11 @@ static int __gup_test_ioctl(unsigned int cmd,
>>  		if (nr != gup->nr_pages_per_call)
>>  			break;
>>  
>> -		next = addr + nr * PAGE_SIZE;
>> -		if (next > end) {
>> +		if (nr > (end - addr) / PAGE_SIZE) {
>>  			next = end;
>>  			nr = (next - addr) / PAGE_SIZE;
>> +		} else {
>> +			next = addr + nr * PAGE_SIZE;
>>  		}
>>  
>>  		switch (cmd) {
> 
> What about this:
> 
>               nr = min(nr, (end - addr) / PAGE_SIZE);
>               next = addr + nr * PAGE_SIZE;
> 
> Seems to be easier to follow, no?

Yup, this would be cleaner. Do you want me to respin with this changed?

