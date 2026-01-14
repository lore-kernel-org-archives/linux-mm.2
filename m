Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0E8FD38FF3
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 17:22:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAC816B0092; Wed, 14 Jan 2026 12:22:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C57416B0093; Wed, 14 Jan 2026 12:22:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAFD96B0096; Wed, 14 Jan 2026 12:22:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 923FC6B0092
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 12:22:42 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3BE841AE2B5
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 17:22:42 +0000 (UTC)
X-FDA: 84331238964.27.2D2B2FB
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010033.outbound.protection.outlook.com [52.101.61.33])
	by imf18.hostedemail.com (Postfix) with ESMTP id 74D1E1C0017
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 17:22:39 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=DZCRjem6;
	spf=pass (imf18.hostedemail.com: domain of ynorov@nvidia.com designates 52.101.61.33 as permitted sender) smtp.mailfrom=ynorov@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768411359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6wGb+7iE7BFky/1tmbVHouPmTdJ7Yp/2EIGUT4ugu90=;
	b=DWefdiSoz8S6oynUJqGt3e/VusYf9QO2rAYzNjWOD5kDKUgYmez5z23zRKsxo1F3NuyX1q
	nKuZWQXHnyqM2rZnHPpbUA4O8FLnahrZJbbKHomyoHu5Gh/K/vm962YwQS+51MN41uobMA
	DmQzorrG9xahrNWmSXXgYznD9KEGO9Q=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=DZCRjem6;
	spf=pass (imf18.hostedemail.com: domain of ynorov@nvidia.com designates 52.101.61.33 as permitted sender) smtp.mailfrom=ynorov@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768411359; a=rsa-sha256;
	cv=pass;
	b=lJ0OO28jHEEUBxqHvrrUD/AXpwhrbQV6cLUepzqrSkkcLy02UXcR1GQemHN+4Bo89T3Kg7
	zXaDBEZA6GpuQShSsedSEZeAnQ3VTrw0cbRws5gB3DIUUsXw/oz0u0xbqcNePMjHQfJUEO
	j7PzlyC4y1pn5i+lHmRKgspTgVGpWM0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FMzux0FVQ/JYIIZM/9GlbnzTT8uBtqTw5LrNbm7AKynoS9ZefkF0eWY6AohJOTOSPm7SfcUJrSFQQHSfG9Q9fPk+JM/CUXsvuGiabHBLHw/frbW82bk3u+kSZSCcS3PCFtIRDM/3ZBlzJvvuMbDk00ti3/zKN40PYlNoxo1opDKN7fKpvx0CjpFJGDNJ5xHrnrKPHUam7WIoNqrO6ETP+mglbWcQLzOf23org50oy+HMQf8oH0eXNXAwD908QPxlMvtPgzaObq8Jbe7jOLUIhCOUeh6+B5O9/5VdjXEGntJfIXzNSYUriFDXzTnkB2g08wgAaDZCRpOhzguTh+5JhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6wGb+7iE7BFky/1tmbVHouPmTdJ7Yp/2EIGUT4ugu90=;
 b=V/L1GLtX0UgOCZpKfgda8REpzqJAA8mpIwYTpjcsEUdyqtmiwgdPUM5M0gzm/npmWxSseiWm60g+i81FwMNUjisEDUczw968Jm0LGO6Q3Vx6CpH5FI6eClxnSuIOxjTlDD1B0H1aCh7NYQENZtLj802EYA55gExziTZDR77blOJoD4BVB5Rk0WtFmmL1kM5p+hp3AKA+ntpq7JZoPLQAD8cB2gOLvUIzvnTLbwqziSEhS5UHtAptW4bYOR5PaDLvZo/qjYFfHIKHc4sWaEjO+Yt2aY0aCWEGJ3sESYvNJQfVWGxu36lNZ05B32Cu7Qaj+vVexS2iD/pziXezz7dAJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6wGb+7iE7BFky/1tmbVHouPmTdJ7Yp/2EIGUT4ugu90=;
 b=DZCRjem6lmhZQj1z2bF/+BsWb5swg9Pn8OWzt9DsPBG0i0qZQSdtMCK+IOKo2wD/sole8jwqLf0oQ8RzyRGtbh9KEj7uiFvUEnR6ddw15LGqhaEXGPz6ck7PtZDdaFP+HWrd1gScmVph2BZiXMdUYr6qWFcOxtLwjCe4ptBTe38UYt+eqpaU01LlaVUKgQSi4SDTlilAKy6mRou8vNLhj3zuQ4qHqRPZycfUirorC1xEdzXbKJ+uy0Rc43e49niTFEnZMTOiRo1J15D2ZHTYg/HHoUv6Web2Cp342HCXHfDR1i0qMSkVsuVDnqoO4eKNUeS8NR+EFsfydOnKMb+Nag==
Received: from PH0PR12MB8800.namprd12.prod.outlook.com (2603:10b6:510:26f::12)
 by SA0PR12MB7002.namprd12.prod.outlook.com (2603:10b6:806:2c0::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Wed, 14 Jan
 2026 17:22:23 +0000
Received: from PH0PR12MB8800.namprd12.prod.outlook.com
 ([fe80::f79d:ddc5:2ad7:762d]) by PH0PR12MB8800.namprd12.prod.outlook.com
 ([fe80::f79d:ddc5:2ad7:762d%4]) with mapi id 15.20.9520.003; Wed, 14 Jan 2026
 17:22:22 +0000
From: Yury Norov <ynorov@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Alistair Popple <apopple@nvidia.com>,
	Byungchul Park <byungchul@sk.com>,
	David Hildenbrand <david@kernel.org>,
	Gregory Price <gourry@gourry.net>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Michal Hocko <mhocko@suse.com>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Rakie Kim <rakie.kim@sk.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Tejun Heo <tj@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Waiman Long <longman@redhat.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Zi Yan <ziy@nvidia.com>,
	cgroups@vger.kernel.org
Cc: Yury Norov <ynorov@nvidia.com>,
	Yury Norov <yury.norov@gmail.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] nodemask: propagate boolean for nodes_and{,not}
Date: Wed, 14 Jan 2026 12:22:13 -0500
Message-ID: <20260114172217.861204-2-ynorov@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260114172217.861204-1-ynorov@nvidia.com>
References: <20260114172217.861204-1-ynorov@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0080.namprd03.prod.outlook.com
 (2603:10b6:408:fc::25) To PH0PR12MB8800.namprd12.prod.outlook.com
 (2603:10b6:510:26f::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB8800:EE_|SA0PR12MB7002:EE_
X-MS-Office365-Filtering-Correlation-Id: fd38c74a-f6e8-4676-4e11-08de53917a5f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|366016|1800799024|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?hN7NGBJML5gohvyt++DtW25eBciM4nsixAKbELx6BIvI13aCqqdM3xXlJkJT?=
 =?us-ascii?Q?wgnlSJ7bwRzTa/pPAF5sTBY/hii1vMTWAm3VSKkx+6JUxDdMFc7ppSGiKapo?=
 =?us-ascii?Q?+i1+wyrrBvWHRTRsnr7FMw3NWXxQs0aDn6QDoNcYZH83IM2H5QjBg5PKDDLa?=
 =?us-ascii?Q?j5vuBh8iT1LMx2DjpiQV8N+Rx3sjD22VVs/1Y6CoFR9p4aVPu35y08m9cbIG?=
 =?us-ascii?Q?zIfeW8hElVcqUnSBHcqdw76U55yLRcPkMZT6YIMaNJdNKSdbBf60sd4jLTNj?=
 =?us-ascii?Q?8PxScMK4V1H9TJBpaQhwuGmoPn5RV82B1LunnxvEuJkIAiIGVnD5Wp0mtXVs?=
 =?us-ascii?Q?i/I2lKeuvEptdLmor840MQUjoa3w1jDgI/eSlz62d4iIQlMON1oV+FB83YIX?=
 =?us-ascii?Q?O2dwVJi63GoVQfh3mjweVNlnHYKZbCbW4psD/RXtzr0JmahvDX4MNmQTsmYZ?=
 =?us-ascii?Q?XbRtDYPrvB1eTQQPfeeDc6Rgyy+ZtE2lJYkT1tN4hbyfJliJ/5PcuUfhU3ae?=
 =?us-ascii?Q?dGTMB+Cyxg+mptDNzxkpcWfh9L41qw5h2uFWh+xYAfsn1roR4veULhfcJweL?=
 =?us-ascii?Q?Y8+1WxbXaxyuEZbCMUG6YpBuMHdgzu5JKffg92gPC/eASapfWiOZPXpRY3uU?=
 =?us-ascii?Q?v8tknsMru4or8MShRB5QwkpMQz9E91o3qzDuV3IRJetk0L/1cMRvVp5/EBJr?=
 =?us-ascii?Q?gpBuaGte3g0Nba9FxHUQMwrm9TtO94gBaye16M0fgZ9uazwKs37rdFu0Wo7e?=
 =?us-ascii?Q?nypEJOSGTJeRIy56GwrdIv/bqwDGjbX8edah+8CvE0ytJfiMnvsLyG6KpU1U?=
 =?us-ascii?Q?v4HiX3gGBaR7P/gaciHj4jAiIBnh5q1nueLwF8zVrN3I0CV/Qd20HgoAMn4m?=
 =?us-ascii?Q?+ErXNBylSoZVfcB54i6oLppfAqQ0SFdHU6IkZ/CTjvgeXnYi35swH/g/EM7B?=
 =?us-ascii?Q?Q3V9RP09stFSsH6h9EwYSfGN1qPk90A0Y+0OHSzRpsjcpFvrv0nGl3dFvKVp?=
 =?us-ascii?Q?MoYjTlNNy+2DhdrvTgnRuLnFpWXh8e5S6aheFP9NGxKt1zgqxYpJzt7wbzf9?=
 =?us-ascii?Q?+260T1ydy0qcXr5yDJbdxFgP6uW68CJt26Oa64pu9F09krcqLTyPYD2rrpe4?=
 =?us-ascii?Q?bWIgAY/ROAcrt4wRCn5RuBxrPtFGXCIcj0wC92GGKiB2IESWooGcAjhZJJ4f?=
 =?us-ascii?Q?GtsEOPUpy3L/mqspTwCVgIE06nx301N1xFP0CoHS+Lsdju8RNt8hmdmeFVTK?=
 =?us-ascii?Q?zOh/APhSZtyR3PRNKpGkri/0DHyAvhm3rZ94DDLIHt4YTYPFyLBMCX9BZZD3?=
 =?us-ascii?Q?GuLp36HBLkBcZ9cQ2ZIcJsSaZQD5W5EVq57Fbjljtm56StMYqM6DmtGWT72e?=
 =?us-ascii?Q?/69jG/fSi9ry6hyg5UozJe4QHlZ6YGeUPIMFrcLwxpNVTwAU3Q6euQpo8+ve?=
 =?us-ascii?Q?3BKPSuWlDF1MHhECTWs7TB4J+MkTlhPDybkwLljp4fScI0PFNOXBRvqElbyq?=
 =?us-ascii?Q?KT4eAyHt9VEUi/EFblwnhXOcn0n6YVPtBVr+mHRcS7GFBUOw28IheF6IzbCJ?=
 =?us-ascii?Q?OFZg/TmohgCGLph+G3tdTj4O6AvG/IFe3Kk1i11vvdiORYXA5r3RRo+OBz5b?=
 =?us-ascii?Q?xA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB8800.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(1800799024)(7416014)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?K5+RqNhrtgsfPBSAQ1ZyvkPRyWlts1/uYSZRcplIBqYnXNzoBKtTosgZnnrI?=
 =?us-ascii?Q?/WocYSSODOJYpZcYPt+16KWv9mSVz4hyNLamHNiK7lIBboIXHUqx1FbG8OK9?=
 =?us-ascii?Q?vKBbvMW0Dd2fWwUKmjEvjDCAVuxOhCI+4/qNJBPca5Ps6gclctYlQew1p17a?=
 =?us-ascii?Q?g27GluOXtuxkvA2gY4TbCowh9MW0Z3qtsdN3j6A1K3p8ZmfEZGGVxqXFY93M?=
 =?us-ascii?Q?3gGHZx35BsdatGU7v+HyT82xIPWdtqJ7THRit17FYD9yqYYt7GK8QXjg85sC?=
 =?us-ascii?Q?lX+ksWeYkq/iv5Ba5/UGauMQfolqoy4V74tShS555PfV654O2RSbQxYAbZ29?=
 =?us-ascii?Q?pnYXNkCGtTgkoZJMI/7aVsZn6QnY/i7b0HOEvuhoI7nfGj61COS8Oihth7/u?=
 =?us-ascii?Q?V5P/o5F15T/057KsMM6SXB8qYLrPOtvhUA0VI1A7F1ijsh/weKOvP9uuvs38?=
 =?us-ascii?Q?pN1b6pDPsKIPGYpRAIFQ7x5d3Rgp3gaVhRC/cOZmohU+QmMPor3gU/yRpGpg?=
 =?us-ascii?Q?MaTWcNnjIbISr1l7PBgN/9JMynsXK7UqD2HzJsxf9S9HONEu03FAdUG1hHlN?=
 =?us-ascii?Q?40R17P5Q1EdcSpiLzkOKR+P1IG8fb7cYTyygZg6D1bo0WRaCShHRkoSdb5SM?=
 =?us-ascii?Q?ALy8xucgPAP/CUsytmjdONlUkqYXUu0qk3bxERz0MW+pQPlFsMuuxNuBR8rA?=
 =?us-ascii?Q?97SBgjWGE61N1NdZN2UJCMQ+W06j7GKc2NZ0cBhMNmVFZQATn3y5YiPejiW4?=
 =?us-ascii?Q?7tCB8LctUwmdFURi2SacHd79smbYcj1+rbWjU3nuL0D3BeZwtXv/jdqsNiEd?=
 =?us-ascii?Q?XolO7NTV4Y4lXiZ21kfBGkwvFPz65XsU3/nBbbEHLrFGWm2vqqa6ixMED5+y?=
 =?us-ascii?Q?E54nehaRL46QIjp/XmA9n20pNuympIveDuANSo/caPQTnYArCWNDsyXpcPtK?=
 =?us-ascii?Q?+Veo8zUhHZNuT4PXdum4Gd96t72+2+acPfxYqztHoUrAMd1O8oEV/4+PiCAs?=
 =?us-ascii?Q?GheienmknKY9df92iDtUIDDp0aI8eH0ZGV4iswojKfklH9Jci0zyP7yJ7e1A?=
 =?us-ascii?Q?QxRrQ4AgrEnyT75bLucegxBPZmxuTwYTyeuEfRFy3Ic2zyhRwktVMjKdBElT?=
 =?us-ascii?Q?7DMMrvFtuUhAWGhAGEFgw1cFt9snn+EPUDh2DraGBfZFjVll2Euyc5ehiTDN?=
 =?us-ascii?Q?hRT8id20N6X8zrUn1iPpUoJmqf37r/jRmETaQWxgFCsDuey6wetiKzBlgM/H?=
 =?us-ascii?Q?DCXFHMnd/mF2dx8qn3Z/A2LfyH19QKxChvBdegWzONPZ0KgDoFT3p+9oXu7i?=
 =?us-ascii?Q?6pZYDDC39cMARKCHN6XKUCA7NC8RrOIGfCciRI9mOY5M7KT7hpGQI9m5otNP?=
 =?us-ascii?Q?RqD/c0UcXEUY8RBli+cl1kdFD3ZgdHIg6rbBZSK/+ix119bQaYAZYIOBKx86?=
 =?us-ascii?Q?WKXPrYGL8fNtRCCNAbd9r7wTZl9SkOGgPALcKKPYDzzy30UID01zXnWoiM08?=
 =?us-ascii?Q?g6PuhDSRPtokqKxY9czOyhqRO5cSxLVzhxVUYRN6Aw0vdflW9hVPMBpyF0j3?=
 =?us-ascii?Q?BzkZUZNlp7RV/EEVVIcq4+loxwdbSiGBtSpjs6Um7gh8T3IDUyipQIJSaPoC?=
 =?us-ascii?Q?OCbuWzSGH8ChWsAMqDYctsnwcO/4Q+oMNplkHyVr6m3jcVWgucvhWsEunqZu?=
 =?us-ascii?Q?erbkS/PT4q8AeX97Zobf4L8dtVZyYmoyXu1AHAUGx9ZJlPycmtm7e7dB2RW8?=
 =?us-ascii?Q?whZ9hB1ICBZDt9WPKlmskuZgfWVH+YOxYwlkjTLshfCB+KCmoPaa?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd38c74a-f6e8-4676-4e11-08de53917a5f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB8800.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2026 17:22:22.3386
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rvdll/HsjZP1LQb8mL4EAT8F4nkk8DYCEyUPO3kMHxeijwA+WTu3uKGgB6TupBFeAn/a4IwXe/sO7qbe6S7GlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB7002
X-Rspamd-Queue-Id: 74D1E1C0017
X-Stat-Signature: 4y7qzpr65nr7eobad3mry8i18kww3gfm
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768411359-599758
X-HE-Meta: U2FsdGVkX1+3PZLriKZAazNFxMFnlycJ59Ya1v9kimIB5u+nwqtkccnkxwIh3XFH/FeENSpT1cqWhVkBdo43qxeJiFdweTAe39WNkirYSYqqiYEBeoK4PMMm5b8UVDAH819BnVHRes4TAVsKBEENgyGikTme2L8BpCuR1WDWB1IpU9hF9BYncEc9hwqBn1y6AaFYe1k4gEy1uXU386FfgBm2SjjfCdR0pzuBlEmVorWvQTaHpFol7XQQ7t+u20T51SIDRXLwSB5+V3L/eDDK6Vp4Mv+ettyNrjf22tlyA1AHG61Nb7/Msr6yw3Ou6wYh9jnah+KvwxTEQamtoQWL3be5BTRBnqY5ceiWVtOyy5fCZXtuPqF7Cxfux3zIh92M9mYLiWWGGo1BvrBMXq/E4dVpNN8bfvswt0zeTWNEV2TzrhvF/noBHIIyPO17DRY+N5uPmGC/gT6APBmgVQYwLgyeI0kWLQ6Ydmbs+SnDigeUrC63I658jEncT+CcnpfLO5PNiHpsWnUTVhZmBxKHT3M6sZy464I4/m4RozuJR2r9sdYEI8QPqBH5+NcWdEVbU6CJ0cl7So1hq8TdHysWl1Ih0i9Og5tgLEF3i9/G1JyBzWABbpfuOQvmEXCppcppCtzDRpTzYoSg+fVHNObLM91VhES1BzJNhA9JjwPS0/0xP2+2oLoAl524I1G0h4cn7A9N3k0omiwZ+49vP48KDPbO7AVfFojw3j4bqwvhpAyIc2fYnXgbjwgfENg5NpPm4+cNVgVKCxpibw8nylmsb95Zy3i4eFFLgjed/JCNd0VZDTq0istRM1W9t+a44umJUw2AUOLUDLJWP0zIphwUkShUj2m4kZfgg0FBpge10tIF8cLUTqxv+DlGF1sO8Yjar8JkXeOTmNfONxhbLmWfW89fjwIt45M+NcTlMkcGNEkIF8rZNbM0qwmnzkjpRx+bPZ1PtyoqJFxcvS3BHEB
 Iyt8r7LV
 NDBNFnAkbn/EPiC9E+pcPg5puJMhqxAtNw3JtvW0ZlfOjWIL6hNQMjRek8UNFkW9QqtCp8NyVD3STJ8kXa11snFYaz68DRIQ3gXEIYm/6tY4nnnu20jbA/UZROQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Bitmap functions bitmap_and{,not} return boolean depending on emptiness
of the result bitmap. The corresponding nodemask helpers ignore the
returned value.

Propagate the underlying bitmaps result to nodemasks users, as it
simplifies user code.

Signed-off-by: Yury Norov <ynorov@nvidia.com>
---
 include/linux/nodemask.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/nodemask.h b/include/linux/nodemask.h
index bd38648c998d..204c92462f3c 100644
--- a/include/linux/nodemask.h
+++ b/include/linux/nodemask.h
@@ -157,10 +157,10 @@ static __always_inline bool __node_test_and_set(int node, nodemask_t *addr)
 
 #define nodes_and(dst, src1, src2) \
 			__nodes_and(&(dst), &(src1), &(src2), MAX_NUMNODES)
-static __always_inline void __nodes_and(nodemask_t *dstp, const nodemask_t *src1p,
+static __always_inline bool __nodes_and(nodemask_t *dstp, const nodemask_t *src1p,
 					const nodemask_t *src2p, unsigned int nbits)
 {
-	bitmap_and(dstp->bits, src1p->bits, src2p->bits, nbits);
+	return bitmap_and(dstp->bits, src1p->bits, src2p->bits, nbits);
 }
 
 #define nodes_or(dst, src1, src2) \
@@ -181,10 +181,10 @@ static __always_inline void __nodes_xor(nodemask_t *dstp, const nodemask_t *src1
 
 #define nodes_andnot(dst, src1, src2) \
 			__nodes_andnot(&(dst), &(src1), &(src2), MAX_NUMNODES)
-static __always_inline void __nodes_andnot(nodemask_t *dstp, const nodemask_t *src1p,
+static __always_inline bool __nodes_andnot(nodemask_t *dstp, const nodemask_t *src1p,
 					const nodemask_t *src2p, unsigned int nbits)
 {
-	bitmap_andnot(dstp->bits, src1p->bits, src2p->bits, nbits);
+	return bitmap_andnot(dstp->bits, src1p->bits, src2p->bits, nbits);
 }
 
 #define nodes_copy(dst, src) __nodes_copy(&(dst), &(src), MAX_NUMNODES)
-- 
2.43.0


