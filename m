Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CAF4C88E41
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 07:54:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 503686B008C; Thu, 10 Sep 2026 03:54:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DBE66B0092; Thu, 10 Sep 2026 03:54:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A33B6B0098; Thu, 10 Sep 2026 03:54:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0A2796B008C
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 03:54:14 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5E853160466
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:54:13 +0000 (UTC)
X-FDA: 85197089586.01.E0C8803
Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013053.outbound.protection.outlook.com [40.107.162.53])
	by imf12.hostedemail.com (Postfix) with ESMTP id 42ACC40004
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:54:09 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=jrUsZkFy;
	dkim=pass header.d=arm.com header.s=selector1 header.b=jrUsZkFy;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf12.hostedemail.com: domain of Usama.Anjum@arm.com designates 40.107.162.53 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=3; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789026849;
	b=jWHTpnuIDoUMqoTJySW+dS88Q+FZjnymPWu+ZBCzGU4LWqhJh6QSJzneVr8DSrPQW3TDuG
	hqCsFS5iQKMRat9u8FAxm8AqU9DAkIoOBHtHJcQvzHqSnl5F/Vcys453riS+MJonyvQIFh
	Vj28Nx1je8b6XMjj3Y4mG9zvLXTQUwQ=
ARC-Authentication-Results: i=3;
	imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=jrUsZkFy;
	dkim=pass header.d=arm.com header.s=selector1 header.b=jrUsZkFy;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf12.hostedemail.com: domain of Usama.Anjum@arm.com designates 40.107.162.53 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789026849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7hUBOvmXN2tcAFbkRLLNCK0pBzRWKnuouI4EYw5iq2Y=;
	b=2XFrPNWSQ3lKiXkSiSyTY+FimCnj/nXEJOLqiKIL/dfCd9gPtJDPKPSlUXR7/v+P4zT/bK
	h8T25Fqibf8p0ahu7jFYM0FOqlWMdWWouBpzcCT/1UEscsUfXmEApNeMiX79ZSP8ILtvY7
	z0DhgQFNnoCNqToZxlAsDBzgokz2Fn4=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=LNS5HKbfz2sR/iZC0X9kXSnTvTJ2uYzzEoVTKY57WT/Ey8wVme/GGw5qy40sQDAwGIDBCBDy8f8dz0VwrE22ZcQBFBee7WQu8yZsRpeateX/HX65kSjSb5ZHNQPnwl9MB6HEEvcTAu+OcTRkUA0RvAjiLgk7OJjCPFY69wt8owch9Mydl/KsUIUrT6tCPH1hSKY9r2O2DySfzQB0AM29yYmoE88ODPGI1Ensc4yB526p3VwCDhfK3UyEigNKXVCAtVRBA0sK0gD6gBZdQF8fNaOP6CtzBhD8uR3ajkqpaKcahsSphoEMQCdAT63F4epxWD+LO4ddfuRNqJPcSFOJmg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7hUBOvmXN2tcAFbkRLLNCK0pBzRWKnuouI4EYw5iq2Y=;
 b=Y+ChenO/GpjqH0o1KRlvT5AqrdliE0OAuTvzCeJXQBjkOc7S3iQy11DD50bxHFpHKLiJu9oFUCeyKiHWf5zI606cCk9TmqIXljfAxVEJdglHGTBUdv5vyaa9hygQ3epdViOTBAxrNAUGOdoqQWWd6VImOzteHlKcFjbAfQ17qNOhpeSoO7jhMnhHGiMYvQQGZmCAUGKkvgUJqssW9uNhTH5njr2twN2rbiMY2mYpO9MyjlQQgIy85VsizlKfn3pJEB0Pgz1PfbP5vi8S/fOIVxvqivsAez/OeBgzWoR6IJ2jobEFaTiB1o8kfUB1VNtOXXRGgdXTqwx5+BSzbWdq1Q==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7hUBOvmXN2tcAFbkRLLNCK0pBzRWKnuouI4EYw5iq2Y=;
 b=jrUsZkFyZSn+SpvXOHieGfWsrqI55CVUh9icd68G0GCaSQ3arnwVmZt7XFUqyqrlToOkaIxamXima/3HwqbAQWwhPh9OuhF1RM/2wpZo8f5lAjfHN7q9JT1my1myAKFpCwGeuBKuY0rC3JF+zEw48PSmid7k6iwAba5mcB6whP0=
Received: from DU6P191CA0041.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:53f::21)
 by AS8PR08MB9363.eurprd08.prod.outlook.com (2603:10a6:20b:5aa::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.7; Thu, 10 Sep
 2026 07:54:01 +0000
Received: from DB5PEPF00014B89.eurprd02.prod.outlook.com
 (2603:10a6:10:53f:cafe::42) by DU6P191CA0041.outlook.office365.com
 (2603:10a6:10:53f::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.9 via Frontend Transport; Thu, 10
 Sep 2026 07:54:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B89.mail.protection.outlook.com (10.167.8.197) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.5
 via Frontend Transport; Thu, 10 Sep 2026 07:54:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PJ20Apcmi6WtcurCo+Vj7pTEGfWTSdaLVKS+ob6KdC07SK+vVy7itz5AJJaD/9KPEBl4N1RlnYhps2vcNvwJukuZ+t8MdtcYG1h9w3AZrNNL4wB+mlN8+0aJjjYjebOyEGxxyhcLjjH8mjQZswaT3y3K/iDmOyVLE54cB7VfiI81Oi1nPAAMxV30+Z1mGPYjNQ6kb9GyKEa0H2HyIMxNacYiqOVtLqUBsB1irJokNJQZydq5I1tsMRCl17I0VYdv9FVMt4Y9pm09oK/BvNt8B7Eie67sHEmxKSmCwRzxGsEbNNzL55XBDXJTUGTy5qU6fTnUHHiMFRYKFF97o/Z4QA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7hUBOvmXN2tcAFbkRLLNCK0pBzRWKnuouI4EYw5iq2Y=;
 b=hSyTSnEH59Kj+QVZErMyfoSb8sNLP5CaQfKEramv0qBwP8hqG13CLb+5OiYnhmAdWO8CxmPDyRk9+xYueS1QdcPc/uRRQSm5jCH8jx80kS8Vjvm6PgXwuYD7r76xooVIddmtP0oJ6JbPGT/uO+xqX1ColhIJzaFcghNnHZyIba2yn+RQSCCgirD4sW6VgnUiQf7Zie3Bw3QI8NWODxHYHfQcSkOXG8Kz16V+oFf8mNabh4GZhsVHibst+BPr0KtDLY6JSnUIUTNehE4Wa7bb3eyBSh/boNk7vQj1VQ+rVgZwwmnfiGAHDaXbuHonwmMuSx4CktF2w9kvj14dHLaLqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7hUBOvmXN2tcAFbkRLLNCK0pBzRWKnuouI4EYw5iq2Y=;
 b=jrUsZkFyZSn+SpvXOHieGfWsrqI55CVUh9icd68G0GCaSQ3arnwVmZt7XFUqyqrlToOkaIxamXima/3HwqbAQWwhPh9OuhF1RM/2wpZo8f5lAjfHN7q9JT1my1myAKFpCwGeuBKuY0rC3JF+zEw48PSmid7k6iwAba5mcB6whP0=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com (2603:10a6:803:80::16)
 by DB9PR08MB6699.eurprd08.prod.outlook.com (2603:10a6:10:2a7::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.5; Thu, 10 Sep
 2026 07:53:27 +0000
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4]) by VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4%3]) with mapi id 15.21.0406.004; Thu, 10 Sep 2026
 07:53:27 +0000
Message-ID: <9695fac7-bf13-4e34-9cd7-4326ec21fcef@arm.com>
Date: Thu, 10 Sep 2026 08:53:25 +0100
User-Agent: Mozilla Thunderbird
Cc: usama.anjum@arm.com, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
 Jonathan Corbet <corbet@lwn.net>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
 Leon Romanovsky <leon@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 6/6] selftests/mm: add a GUP selftest
To: Mark Brown <broonie@kernel.org>,
 "David Hildenbrand (Arm)" <david@kernel.org>,
 Sarthak Sharma <sarthak.sharma@arm.com>
References: <20260904123631.198697-1-sarthak.sharma@arm.com>
 <20260904123631.198697-7-sarthak.sharma@arm.com>
 <b0400430-c3b6-40d5-b476-49189b1cc292@kernel.org>
 <5e0b9365-cbac-4f2d-b915-85edf3093508@arm.com>
 <fadb8870-37f8-46f4-aefb-c21bc3a31e5b@kernel.org>
 <07dab220-8497-4eea-a4d2-b27a6e01eaf8@sirena.org.uk>
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Content-Language: en-US
In-Reply-To: <07dab220-8497-4eea-a4d2-b27a6e01eaf8@sirena.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PR1P264CA0070.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:2cc::10) To VI1PR08MB3421.eurprd08.prod.outlook.com
 (2603:10a6:803:80::16)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	VI1PR08MB3421:EE_|DB9PR08MB6699:EE_|DB5PEPF00014B89:EE_|AS8PR08MB9363:EE_
X-MS-Office365-Filtering-Correlation-Id: d1d51c1b-540b-4265-5857-08df0f10ad8e
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|23010399003|7416014|366016|10067099003|6133799003|22082099003|18002099003|4143699003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info-Original:
 x3QMjGYHyd4JOxXsfTI6Q7YYXos80d56O1QNalvsz0RZKdNWNXlVWEI+oHoSe0xHZdScVw1bzPDMDSsSN8MiZhrTQ7o+9OiajV1Vn37elm+uW1vwlrjvv9DijBeNTYtW0r13N7fYERsVQ2PwYoPzaiCVX55uO96vz/vcYgbBpayNmhs5IGcQ9/mbxiZQw4gqebJumpiY1iIYuZxILQPgV2ltk0JtGR8NWr44lkwua6heB9muDqAnl7Jx7Z9HTUEAFDVPMe5gLniSh47jzq1vDXML+HuCGqDVl2emkJq4EvJToHJXQEUq9zvRtdd+X9mcAZZd4oNXl5phfp1PPHDh9AzmAGhGw5Q9CtrmOBh7UhPinb2tn6eREpHGjNitJJZtl04Gxl6WBp8V8LxicZfNd8Dr2wM6i01dlUoQaFGugIWb2xHi8SR5XBmEAx8QD3q4NbcdKK1cYwl4hLwziBrwizg2BGQRge5nL/UWb17CPCtROuHcMiaV3MZHhuHGOheZqyWl63SonaSGIcwYOnPCFCFFb60Mjdio1ido3gMAeK7lg2MFW55IqFEYApu3YlR5KH37aWyLx2GuxqPEVeEgS5M7bdbPHQdzjrgW9qnkVfHzj+XCbPO4uV8ELG5oEhjvnlOf+cqbuBqfKZqjvP6m4u6FHFI7in9qXqCvrPnrqzY=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(7416014)(366016)(10067099003)(6133799003)(22082099003)(18002099003)(4143699003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 LHL+J5lUR9brK8poFGmzZiQNygOP8crA6WGMfOlYSR2AhmhyeLzqlTsxm+dxqi5lL2vCkJhbOdATXq4IvfnUJOiRCRlltXDiFxJeMN68cx+KzZMe3cay5KgFc2rO8WZPviLGj7ueQqNlvFA6S8W4kG1k3006e4S+nAu3n6YkbtJ+0YEdev82kTE6rPBPs3Xi/+sifZnOIG1Z5+wfJMdWP2j0zDKobGlBQBL0qA2wbmXH7VuSDVg3XoZ38y4YnSlIbh0niQ3T9MlHM24njctshVZSEkpCk8vclrk5XYaN8G+/ZME7sf+6JUKo4iO2iMVkQy2VGM81mt5Ph+wANgs69A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB6699
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B89.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	4a8d7854-b581-42c0-8c8b-08df0f1098b8
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|23010399003|1800799024|376014|7416014|36860700016|35042699022|14060799003|10067099003|6133799003|56012099006|4143699003|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	QR1g5syt/zWnrh1X4nP3lQseS2ngD4OSG+pwL6o9/4ma80P5HE+ZZ63Kz4aC2FxQTBgzKg2QTAP7MHM9bqZfLojTrpvnDqVo+55YrbxaiSfAE6oKN/DlF4f2siHD9y9u7zsDdSbV5PO96UrmqZWCCuF2Cchw7Wm6oMxX8IMSTea++idKKogSX8Pp83O6T8yiZFHBvoSex3IKxaH+88mx8h9e9pMy4OUrIMqyB9/5K14BJkpYaLtvtwRHhqFtNuTU8MVYLW2utEMFdOfZopFEhcq3+ODbSR0ie9TZB2/NnK2ku0BR/MDqtAzeW6Wn+ZOXPGWCnycCht0DMJiX5agRqpRFzW88Ui935maWmbP9TjK6fBs87f307wkJM8tkCtWa9K9K1M4JrgXdlSr5C15Vo4RCvxSvlFXWcyT84M+X99ifqtinO31/fvbHLQXFLAcbRq+v1SE6RaapAckve6vGBTO/UCx7LHR4eOp6bsdpMSbJIHiyNDl1A3ToITL/A9aBhC3p+rbbHjeDgRxtwYwT36AukRmSr8TPvgIaR+mniARqKp8amXMviSUunUqSqJHs7yEy2Jp9ErG+UAJO6UTl6PI9wRpyNXJ7nQ77eD1RUDsc9+jTOuXzn9bnW6Bk3nYdm1bN8mrB2pDUEwQjr7P2ObNzEkiKYMNe++cHa7jVhTsI6xXDqcGdtlqOdcOnIJLbCl8QuipIxpBjJT0FH0mNfQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(23010399003)(1800799024)(376014)(7416014)(36860700016)(35042699022)(14060799003)(10067099003)(6133799003)(56012099006)(4143699003)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Hv+2gYtVp6274o0Hx3IZ9qleX6VU755azENj8SOOFnps08JvbLJpJRCaehdswMymQYHZmDQPdDd/tIEe/fk2c77p2NiKxMWfMJ4C0zAPl1iaqWjnf5bUWoAxjN1YXGrUB9OBMQisjiN70MZtIzMDN4+JdU72mtl9ShYS/TYbD6/DFdnT2+TFBZn7TZ1X6ZG7y4KWaxcZBkaKZqXQ38mKwjT+HKM9VKU5PBNL29xJFPTsNGte/tkKQrIU5TnVMgWACO37N7JOV/knrD8AIyPfm1Vp+xanvZtJVZ/vY1kht+MC9L/7aF64JqmX0zyHX907zba8//OTXdSVhOpr4ad+ymRbFka1afT7cUW9SR0eBsxaa5MurzPgY0AzyjpbRU4QV/ki0sd1WD/ndQBF65JgtxGrY0ECwQkeheAlkgCm4YTDdf0tCqdtdfoZUjHGYiwV
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 07:54:01.4541
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d1d51c1b-540b-4265-5857-08df0f10ad8e
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B89.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB9363
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 42ACC40004
X-Stat-Signature: b4ap9kyuymyt9hzah6nnfnyy14cwd18n
X-HE-Tag: 1789026849-708400
X-HE-Meta: U2FsdGVkX19gAgcgKPQThMRi60wi5aSKz7NP6vL1282dFMWZy24JiFdEN+jY98uLGui1ogkBQpxsfEnasEby3ti3iKZzndx7FUsNG2X+qPqJ5La4Bk3jDrHP7bW1GxRjQ3n1MTtOt0Kkfy6f2koKt5QVuDqz9jrpfCS46lW3+djR7Xp0a5ZOoYU3A0A346fvAOTi5tTgPEUBMYSMhwwNEP9U69pq/T0UXrjVbVeRA5uSW5QaWNWw/SGKfPFcQxwApkeKW2Wujd4dpfNePf4CjRPYbVt9js3RaNvNIZUUILyNQ6UlD8KM0hHtoA1GWclz/iPyDO1tLDx1njEQFNnVZZqt6V+Oi4D8ZARc2WlwoEzZi8aBZCQ0lhCt4Q79Ggp+DmIe8lim7YbDBaDdENSvWI14c4YVeuoJCFvzNoEaHaa35f3fP4WVQ4pW18k/RdSXrv3JglsdxhBklxXM16p5S06v2wCTXoopdlh3y2sTqhPG4QQBJJo2dnccPTzmEcvELgD6jNdBkv895Yk/r9o2fqlwDM8Y7hhy8N/tV+YZv9yI6+Kl3M2bzTwNHroUSz9WYueP4VZLXigyiIraDczd9TcOAIh/dbG6WQgyHJeaSxSJYlXytoAZRCrLrrMj+yotC1CIeUE1v766nBOYMun/GjMrkuRXV3SmQY1dqJfl4llwYLIeskaORPxtfmISZ5U3HeiTkSSvgTXxhJJgIPY+UjIqjtWG62RxsjuuN3qXqWoQrWFrBld62k2HECsYg/3b9RjTQ4ytfvP1Z0DtUBSqdbRHhWN8Oy1vOm075tlVQsm9V9cWrGaO/+d73Z0CtZXa07FGrjh+6jysuWnmSdh7LQdPAT9bB6hRAQ9rvxGYw9XuWB5iH51DLZ0EOFRS3ZxJjA/znKxJ7Chj/rvjMwxMSHExLx1xwtDa9cWyi+swb/1i9ZqnnE4MXu/JJhbZ8PMCjOskSDYoM/lWgqOekfj
 0TWoxldr
 xqNNdixwO06GxsbNXewT2rnxcNDYa1J+TnA9QeMXEo9lzwuRCYkIiZOAqWwBmSW6kfVVUHqdAEWJ4imDGIaCyuF93T1hrcSR6NrUGPwrq7z0/37R1SZtNlLQrizD8c3nl01vrnkLvp/JIj0glSAAy/5PK6YWj2qaigh6ILCrHQS6j7WcLIHfRRAUBvEZ/l/62Z9TBOoKIAsb3yhOzgfY0Gvdr3oJr4W0cwOkJaelOP+ua2g8c2oRN4+W4nUyhzELzAUfFqJfLAjSil/6uMUMKDXudJVhCcjq0RaaDzb2x/M+FfmNzuoV01cwFxVUkuSyODzbUcNOn61T6dbMcR+Yrv65lZvjLpWL7IMPGuP59PySAoPV5nWhHEd0c5IK6w1ZcZK6+xEYuo60kU/XgelrwbLIwnYKiEU8TtWm6R/L9A2VlPsbaDlawCljurUgvjsM8j+AzmaRpP2qEyhaQalTgUWcLHFJGCQjIo5LLG6L9ksIL/rlycoRFCQ76tecrHRAZO1yOOVqt5ey/RqMVYfc5Vn3xKFqVyyA2Wmg38gZ4KFIhCG44Bpyw0PJ6Ng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/09/2026 6:34 pm, Mark Brown wrote:
> On Wed, Sep 09, 2026 at 07:03:59PM +0200, David Hildenbrand (Arm) wrote:
> 
>>>> 2) Move it to tools/mm/modules or sth like that.
> 
> ...
> 
>>> This is an interesting change. We can keep this open for discussion
>>> here. If required, I can work on this in the future.
> 
>> Yes, we should in general try moving all test modules out of the core.
> 
> If you're working on this please make sure to take a look at how the
> various automated testing systems cope with modules built under
> selftests (personally I think everything I care about uses tuxmake
> builds, but there's other stuff out there).  I think the answer for a
> bunch of them right now is badly, but I didn't actually go check.

There is huge discussion in the past on converting test modules into
kunit modules [1]. Selftests is not a correct place to keep kernel modules.
People have moved a lot of such modules. But new test modules get
added over time again.

[1] https://lore.kernel.org/all/20250207-bitmap-kunit-convert-v1-0-c520675343b6@gmail.com/

-- 
Thanks,
Usama

