Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46133CD5BA6
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 10:17:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8500B6B0005; Wed, 20 May 2026 06:17:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 801A06B0088; Wed, 20 May 2026 06:17:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C9106B008A; Wed, 20 May 2026 06:17:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5626D6B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 06:17:19 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F3D8DA026F
	for <linux-mm@kvack.org>; Wed, 20 May 2026 10:17:18 +0000 (UTC)
X-FDA: 84787395756.29.9B20B3B
Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010004.outbound.protection.outlook.com [52.101.84.4])
	by imf31.hostedemail.com (Postfix) with ESMTP id C234420004
	for <linux-mm@kvack.org>; Wed, 20 May 2026 10:17:14 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=XxfFqlbO;
	dkim=pass header.d=arm.com header.s=selector1 header.b=XxfFqlbO;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf31.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.84.4 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779272235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=opZmbjXb3oSuD9YpdMoqIR7BOAZjZ0o+22fhwO6pHKU=;
	b=lJbyzpkA//+wrWvC6dxT6I1ERQNAMGkMe5WpUgsLe6rFKEVdTgQpLJmWxiueUz5NGGHRgA
	xwh64JqL7As+KwwdP3f7kFNtdwq5RjYYmJhRQgYdEV49BWXx09WArLmnlFQrsSje6Bpu7o
	79VU1lAGhr2MECfgGiqpe12muuGLHpM=
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1779272235; a=rsa-sha256;
	cv=pass;
	b=VaGAMxmSF9E8EsEa7HjM2vTlwJQRaxOGpQsEQM9tFsy9f5v5TTzn83a+5SQEoYTzky/oRI
	teYrayxugujTBMuZIP65IhlD2a1xkb4fsNoQW4tKZu4VrkvNzcwL/ftVTYR4eqJrzOZubE
	6L9sYbsJkDA4xigBbfxH9Bb+oKg1ghM=
ARC-Authentication-Results: i=3;
	imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=XxfFqlbO;
	dkim=pass header.d=arm.com header.s=selector1 header.b=XxfFqlbO;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf31.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.84.4 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=SCEWwj4WYaaDDqeHbgPL0IhTDNIUD9HPPpoQ5TyOe6cLLm8duhLnbwqMXs/DcGfoKQ3j2NcVImQkXMzomsCFZ6nAXeMiQ0faVXikDKYuo7SiUSSj7AEtU5lm7dW2R8ftd67lwjQmoqE9bV6clXFO0lBybibk2JQmQFS/zbe11xXkWBjSQaF4q77BXUULwjxBJw7ScTiJjJeZnZlFODFJ8aQMbcvt2CJV+Dm+XjAqYOWf6GhDLvM5bNR3bcD6FMVmotD7OIsG5SKFTnw6eTRd09IuzWtdMZM/CovHr7E6Nq5MHrUUxE3/M2/yTDw9brvCke7kDlfCzDVrk/930wy/YA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=opZmbjXb3oSuD9YpdMoqIR7BOAZjZ0o+22fhwO6pHKU=;
 b=n4rQ3oNVXoTcKzgHK+lWlLXYg5BgxzT3gg1SUeOTmZ1V4TcgJ6PlHodvYPVz3X+2oRGF7LfFu3gLqAlg0nuNs1I1r5NSKfhzZqnICQyG4kSxgSFpJUOAplpxusH8VrqqyBsTBjL/KKPrVh0E8T8017NCm3Qa7lWqxqzCVpo+v4Lxa6ArfhDcrL+Kqdc48BgwasWc5jSQFwpYRyPddfPfEBlkk7zSr45pUDn+Emwsb9vMvMh2xTMJ9XaDPktD3uyt1u95aUjvU2zpJOyvXc+KX808ZpMZ6+CXd5b/f9hZO05MjE7hpiHtt9FuTv0hNg+LhDuvkpYwDZ7/QPrBTBMsZg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=opZmbjXb3oSuD9YpdMoqIR7BOAZjZ0o+22fhwO6pHKU=;
 b=XxfFqlbO/eTPKUJnyd+00kOS4sCz17hXzft6MeKnsRIW/B0fvH+Id4unBVqDfWiWqz0bC2+10WoDPRKxQxDaR+NQZ6zqs2Z9z/MGHW6QicOUH+VHNy/ukw2ySk8eBrjobe3UVT+WdblO+Fvk0GuNvzHXbCZ3+dti7O8YdaL4rmM=
Received: from AS4P189CA0013.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:5d7::16)
 by AM8PR08MB6516.eurprd08.prod.outlook.com (2603:10a6:20b:363::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.14; Wed, 20 May
 2026 10:17:09 +0000
Received: from AM3PEPF0000A79A.eurprd04.prod.outlook.com
 (2603:10a6:20b:5d7:cafe::a6) by AS4P189CA0013.outlook.office365.com
 (2603:10a6:20b:5d7::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.48.16 via Frontend Transport; Wed, 20
 May 2026 10:17:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF0000A79A.mail.protection.outlook.com (10.167.16.105) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.48.11
 via Frontend Transport; Wed, 20 May 2026 10:17:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cjZdV/auBd07A629WuSt6TV7NB514dK0bU3w/6RsEL8IIgt6OxEgTz9FBMspJ7olVLOLScWCJ2mD9yOTu8r5iWO78xox7ChddFpKZvZwJns8v+CN4wfUJYGdITHRif3spgyUT2iRWb2m5yonYGHZtPLSSxDX54QyUOzW+HpXkGtSmp7yicHLQUZaqVS/jPJRSDU0QMWiqridBgZmDXdhqp5cmiJanHfXffguikw7vNzsmlxJApcrg0bG9u77qzVbIPjhCP0vh3RE9lGxZS4BUVuskO9oNcdcRWYnDzQfgap2CKl57tFpT1UvKpoJlccDG7sXsfhVMSjHCzU1vN0SsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=opZmbjXb3oSuD9YpdMoqIR7BOAZjZ0o+22fhwO6pHKU=;
 b=Nfl/4MzaTFju2vd4ifSvuGWwr+LBUOOdM/gUt06wxPMtHruEE/Cy9OL/pG/WkCu8Qsh7cZm9mqELyj8ubcASp0FXK9wjK+92dENPf0EzXInQ0pOncTm0OiCbFlOvYye2unQ3BICiBv/2KTOqy8DvOa2TGQv+cf8uRCY+GNSHCsuoYqU5ZzvlmdNclu5Mm5T7H3CFL49G7owN9UA5UBEKCvqPXyQ5z+4FM4zHDj6UPRCcqbDo6z8ztTd6cguR4VitfU1CRjzKEH5todMCPcY4QMXseqpJH269AlEzIR9e44ZEzn4SSPWYiiP1jPqYjbRQ0cLjR25/bjVFrifNnOTsfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=opZmbjXb3oSuD9YpdMoqIR7BOAZjZ0o+22fhwO6pHKU=;
 b=XxfFqlbO/eTPKUJnyd+00kOS4sCz17hXzft6MeKnsRIW/B0fvH+Id4unBVqDfWiWqz0bC2+10WoDPRKxQxDaR+NQZ6zqs2Z9z/MGHW6QicOUH+VHNy/ukw2ySk8eBrjobe3UVT+WdblO+Fvk0GuNvzHXbCZ3+dti7O8YdaL4rmM=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com (2603:10a6:10:417::12)
 by GVXPR08MB10640.eurprd08.prod.outlook.com (2603:10a6:150:14a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.14; Wed, 20 May
 2026 10:16:01 +0000
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047]) by DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047%5]) with mapi id 15.21.0048.013; Wed, 20 May 2026
 10:16:01 +0000
Message-ID: <9382431f-3746-4477-bbef-87abb58bf180@arm.com>
Date: Wed, 20 May 2026 15:45:53 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] tools/mm: add a standalone GUP microbenchmark
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 Mark Brown <broonie@kernel.org>
References: <20260519120506.184512-1-sarthak.sharma@arm.com>
 <20260519120506.184512-2-sarthak.sharma@arm.com>
 <ag13GbKcLMIoHOHj@kernel.org>
From: Sarthak Sharma <sarthak.sharma@arm.com>
Content-Language: en-US
In-Reply-To: <ag13GbKcLMIoHOHj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5PR01CA0042.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:1d6::9) To DU0PR08MB9203.eurprd08.prod.outlook.com
 (2603:10a6:10:417::12)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU0PR08MB9203:EE_|GVXPR08MB10640:EE_|AM3PEPF0000A79A:EE_|AM8PR08MB6516:EE_
X-MS-Office365-Filtering-Correlation-Id: 83baf115-a3df-4874-82cd-08deb658f3c5
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|7416014|1800799024|366016|4143699003|18002099003|56012099003|17002099007|22082099003|3023799007|11063799006|5023799004;
X-Microsoft-Antispam-Message-Info-Original:
 VbQxvRz2uCm4WNECdisDKAKkuVvFCeO0j1VfynFHKYvOxefiuJapo/2v1JppuFW0FkooZE2xZDJ3vtq4Nn00zC7Gh2axyqlR95ENCZV61r/RA+w9z8ku9SeIs4dd9rPk62rGHyw3kS0fymzGYgdK3y+SRm8bV8/3Zr661FvwuE3YSFtI1BVe+PPrOOI0Rq0wZyTRMaLQ7IDRo/teXGgFU/X88qIPVVAArabuTQstTYrSWcFjgv76lCrNzdQcFd+JRq0EYuU1wJFeRm9u1PjLpdOWNQ3s0AeDqALo+/cQ7yNIpf91Aps8NKsmjzhNtKP4IB5n9p6IMU4tgAn+13MQMCZuzehBa/20Mtw/NJOavq6f+ADORnCByM0kx2xRUSSm6NMryHKTY6DiAfONEOQ+OMdHH5pbdxS7voGY+9MYXV3jczjeuAxCGA5RIEbcBXyxdbh31RfpnwH0Ic9TYoN0LqHXoOpS7NK6cZ/J6jn0N8KV3BVEkkmjVjXj4mmSoRAsqe72zIZ32yK8wAyH++3XUpb1xfHByp102CQa2oKRU6DN9+RjnyBR3BjN8qqOiYm0y0YYmMepT9B3luytfuvvgdMiTc81gLL+AHi92W5s0goPoCIywlPa+w1zrDp9rFba21ekzNrORIiwHKMoGo7EDSpQ8OJJE4NkhlaIyAp/acJxPntCRx/SQ1yauQWxPW2f
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9203.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(4143699003)(18002099003)(56012099003)(17002099007)(22082099003)(3023799007)(11063799006)(5023799004);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 ZMEUPJxl9PnVHJe07ei8JSgc0nhJczVvp2+8TtijjRzIraRTomhDpihq7Nm5n3h8e7oJ3lvBCdsoyt14/qehDPmTat7I/ATs0OEyBLAOI1iHnQk9938iMZYOWMknq7EVakX1qIS18TJlplZQUZ9G0SZynLZ5LBam3u/rRUclfUSaOoLwtyAqNEzha/AKX8EEe4bVt7royFKGcscjhYVmjiU9dqHHIpRVzY3S1Jlk6LdcYxcZeM9wnwZh8oBwqnojVGvPzfDWq2552KktVayE7W0IRvlW5ZMdgZybMPJZ82q6J3apx1R/DJQb+m8nSmSNcZhR+cR9k9FxegekSTBi/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB10640
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF0000A79A.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	0fa8acce-24e1-4502-effd-08deb658cab7
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|82310400026|376014|36860700016|7416014|35042699022|1800799024|4143699003|18002099003|56012099003|17002099007|22082099003|3023799007|11063799006|5023799004;
X-Microsoft-Antispam-Message-Info:
	RmAo01X7MKqKmOxgqUCOkdSmMzwB7oZIlqnDR/uVJ6D6zD3vkzsbveoLUzLVNeZYqgctWKtzSi/R97EGXHPq0Xb2VL3IS6Xh9ATvveO9urWuLkY+zJKoHhw8OF0pgM8bvwc6FJXlr8L2zv38B70wJfYIYjxKMcp91f3k+BoyX5r3cC9Y48yvar3aqR3jVZWxEeFKDUoS1HRaSi+JxX0WI2akeaqg99d1WfR9fNTdHCZNMQn1MKZaVCxEEzjRlSt0RHLIaitDlr7UjB+oSHoVZWDLsr7HOQh2ZWhr2QMcLG72VNJZkQmwEbu6o9AFsSq7DaTBaiW4tpnwPde4FY9I2uNvzL1/MYbRZWOSHg3/kZluXjz8gSkbn6JnXQdU8wS80FhDFsJ8ZeKd1EZfHxOvG92rpHPf8tLmcMpsSBiOO2A6Acz/ZbagepfNqv0DZ5ZhZBiplLFnh0KB3yYkTdnwjtc1e8YrvUFRGSoB1+HcUQedKcxiQib58fVVUAIz8jFOqGsCxjUyu0nwKFboi0KeVPlvUEEvbYy6louhtVRSp7vr7+mTSiQ/42Cwq5ViFfJPJpitPydL9y+u0bkqdr0dim2c9jomdTb7l7AccP5PTa3X3JCAhXrYUpktBLzoTeJ0eEbSrF2I0w27NymeFdC0LEFUaR9ojDWoyauy4EVrIe2S3iNKNvNXfy7qzaRbqq0O41sZWPWbAQDxtnGunb0ZpLR7aGn+dUf9z1JF9vFDHI0=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(82310400026)(376014)(36860700016)(7416014)(35042699022)(1800799024)(4143699003)(18002099003)(56012099003)(17002099007)(22082099003)(3023799007)(11063799006)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	LQv1fFamh+fZRS/0pSr+zLUUuVQOJpC4InXmmYg2fsqNI95J6r3H1pgoACvHA14nVGiJ97aHGi/UQ2BYJYKFjNmk8iLUd2MUew1pqUPgsVlseqL+FRwJx0Gvo5C25Uw2gBFCwC0t8vgsUw+Kwcz5+U8I+i3AzjHHvJBpdmoVMiWmp/Y7KTclQZdoLF3hc2TsLmsSHh+nfhp84MPK68ao98SZ7ti7DrL9yMO5ApLSUxfnZwz6hQRXdXwwmYKgRkL6UKMCdC0RJBSfgvZqOZtbAlH3WL0c8SrJGM6If5XB2p5daaw79iOZYv9/kNWxyogHltJwz2k614ke+XribogZhrK0m+3UsouVWz2gBohfP1Jf4IKIVUIWNot3DpRzVzsQ8P4CR1X3Ds0JyArAqOrSn4smG3MvT4gmn2MkVIHr+DQWNdiZ+dTBLpHTEH4ZhPPc
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2026 10:17:09.5464
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 83baf115-a3df-4874-82cd-08deb658f3c5
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF0000A79A.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB6516
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C234420004
X-Stat-Signature: emtngk8e8p4hadzzzu6iuemno3ptxos7
X-Rspam-User: 
X-HE-Tag: 1779272234-558191
X-HE-Meta: U2FsdGVkX1/jzl2UPGW+9Dlh404/yYNTkGsLHUpPig4NcT6K8S/stvmIbhTc0NJ4aUsQQCDTocc7rT07Py/q5jJhNlq/HwKyYzN72ufpYVW8pRVTGEQzuz+843J6dlcqgXffM5+t4cOxUmETmwOgfqnlVmxJUzu5rsbPyXbprSon2fCefoMbvpufOIoU4Pq5Tcu6xL2dpKzX/cz2WTzVnUXkOTM3XZNqOqvOD9qH++7CC78Lghl7GEzgDCblMGQOWSK6GVBZGrs0RbQCplnuSmQnknis79z/lcmoTAQwF1FwBQ569aa3CZgg2J7Ta/QEMbHDxmuEJICpevMPVTsuvDparKSnr68vLBW8jDAr29f6h6943kYsqnteFzXtXbg+2U5Yu0hjxJgZl14IuMjrH9MCTsnPV6eZH4i73ksSTtiJAexD1lifRGK2VNYf4/Na39WeCY/2DGc82kJJbJTERv4JW445aJstc5dVxFXNohUYrXlbY7kI9Oxgn+v2NX0yGSQQ/kMGuHuEOASAXaSE63YFBHUfEV8IF2E+ox4V8n6sydXOHRPQm/UXDDr+PQTbbzb2R3OwgGWJmVobu8Oo0ykbS11TosWgM50VgTC4ezvNT7VtfZLW1E68I3nkH/4m2D93N1W5YlBwhiUnVUwgLMTTNbUdqHJXm37no/GlNPjm6rtAm8A7aJhdsl2yG+0f1AKJM9JmKnYOpjq7zJhwjYK/H0+6SpmIln/g88YTMypctB03uTZuGsDUAL2sVhqXxcnpynRW2Zw6c1mnA7x3+fLhp1UUypG3hnXUTAekNheW5oh/8nr6+TuykhttIr/IBcy+jMF8vkQdV/RenEw7W6N1k/IeE0eUB4r/uipcZ6Ig3mtt+HdqsPIE0PevqG8ZoSYhWLrd9enUVhhUxtLTJ6MYonEHHVPduDUDNcs31SL8H8e+6uaq3lpXHWZGYBSp6lYNKLm5pN6ULUOtSd/
 gQCy+sPJ
 9WyplhVS5OYrN3HboKQl8ltLcV2M2nxrksH8uWB20lnrSP7iQ8sBU3Req7GMQpjqL73zm/mUoayP1C5Ig6bzdBmL50PAiQ2rfstMQ5b80xod+lnYljVoS+7JNgCxc0JA9Whb+wl1+nsqRtCM7pW60rFkPrJTWjCjIO3GRvtKix4nxNdevEXlB5Xf1szRPOT2fulTguT49ksRGUNW3u8rsYbon/V/AqcrXUDwo3WfZEbM5MsV8Ybagh8AmLv54yUaG8zgq/n5r9X7KHcwZEhBGMtp4UfJzHaBcvlkTV/qqZq30/6QPcJXoJW69RulBaXhaOH33ykZo8AlgvB+Xlt0X3PhKbX5mJZoDQB+imFjqtf95q9etTRZ7ChbYHCbre6SZ1Dm3Y1y9Qj5foVi2agKYni5q7RXyN6sIcg2O7Ka0P4P9GkTQKPQWphiLDiLMZxKYlhVnQhQYJKR9Q2YFH+N5/07gkmLME+29ntEqhx8onMGZNuDnhns9Fpl3fWnVkUpXEeeYnIdNmOn0aMksBTbHHaBIPsde0Ei/VW49pNoDaqDYsoRRnZ2HrYrtRQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mike!

On 5/20/26 2:25 PM, Mike Rapoport wrote:
> (added broonie)
> 
> Hi,
> 
> On Tue, May 19, 2026 at 05:35:05PM +0530, Sarthak Sharma wrote:
>> Add a command-line tool for benchmarking get_user_pages fast-path
>> (GUP_FAST), pin_user_pages fast-path (PIN_FAST), and pin_user_pages
>> longterm (PIN_LONGTERM) via the CONFIG_GUP_TEST debugfs interface.
>>
>> When invoked without arguments, gup_bench runs the same matrix of
>> configurations as run_gup_matrix() in run_vmtests.sh: all three GUP
>> commands across read/write, private/shared mappings, and a range of
>> page counts, with THP on/off for regular mappings and hugetlb for huge
>> page mappings.
>>
>> This tool is a mix of reused and new logic. The mapping/setup path comes
>> from selftests/mm/gup_test.c, while the default benchmark matrix matches
>> run_gup_matrix() in run_vmtests.sh. The standalone CLI and tools/mm
>> integration are added here so tools/mm does not depend on kselftest.
>>
>> Add gup_bench to BUILD_TARGETS and INSTALL_TARGETS in tools/mm/Makefile,
>> and ignore the resulting binary in tools/mm/.gitignore. While here, also
>> add the missing thp_swap_allocator_test entry to .gitignore.
>>
>> Add tools/mm/gup_bench.c to the GUP entry in MAINTAINERS.
>>
>> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
>> Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
>> ---
>>  MAINTAINERS          |   1 +
>>  tools/mm/.gitignore  |   2 +
>>  tools/mm/Makefile    |   6 +-
>>  tools/mm/gup_bench.c | 491 +++++++++++++++++++++++++++++++++++++++++++
>>  4 files changed, 497 insertions(+), 3 deletions(-)
>>  create mode 100644 tools/mm/gup_bench.c
> 
> ...
>  
>> +/*
>> + * Local HugeTLB setup helpers for gup_bench.
>> + *
>> + * These helpers were copied from tools/testing/selftests/mm/ and adjusted to
>> + * remove the ksft formatting. Keep this copy local so tools/mm does not
>> + * depend on ksft output behavior.
>> + */
> 
> It looks like self tests of at least 5 subsystems beside mm use hugetlb:
> 
> $ git grep -l "Hugepagesize:" tools/testing/selftests/ | grep -v "selftests/mm"
> tools/testing/selftests/arm64/mte/check_hugetlb_options.c
> tools/testing/selftests/cgroup/test_hugetlb_memcg.c
> tools/testing/selftests/kvm/lib/test_util.c
> tools/testing/selftests/memfd/common.c
> tools/testing/selftests/net/tcp_mmap.c
> 
> It seems that we need to better share the common code in
> tools/testing/selftest.
> 
> And adding another copy of the hugetlb detection and setup code does not
> seem like a great idea.

Agreed, but that was the least disruptive approach I could think of.

I am thinking of doing this now: should I move the
hugepage_settings.[ch] to tools/lib/ and move the read_num(),
write_num(), read_file() and write_file() helpers to a separate file in
tools/lib/ itself without any ksft dependency? Then both
tools/testing/selftests/* and tools/mm/ could share the same code.

Please let me know if some different approach is preferred.

> 
>> +
>> +static unsigned int psize(void)
>> +{
>> +	static unsigned int __page_size;
>> +
>> +	if (!__page_size)
>> +		__page_size = sysconf(_SC_PAGESIZE);
>> +	return __page_size;
>> +}
>> +
>> +static unsigned long default_huge_page_size(void)
>> +{
>> +	FILE *f = fopen("/proc/meminfo", "r");
>> +	unsigned long hpage_size = 0;
>> +	char buf[256];
>> +
>> +	if (!f)
>> +		return 0;
>> +	while (fgets(buf, sizeof(buf), f)) {
>> +		if (sscanf(buf, "Hugepagesize:       %lu kB", &hpage_size) == 1)
>> +			break;
>> +	}
>> +	fclose(f);
>> +	hpage_size <<= 10;
>> +	return hpage_size;
>> +}
> 


