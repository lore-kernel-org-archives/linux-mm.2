Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FF0DC5DF94
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 08:44:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2F536B008C; Tue, 25 Aug 2026 04:44:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB8AD6B009D; Tue, 25 Aug 2026 04:44:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B342E6B009E; Tue, 25 Aug 2026 04:44:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7E1366B008C
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 04:44:53 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 46F3E16038B
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:44:52 +0000 (UTC)
X-FDA: 85139156424.10.A3421BC
Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013043.outbound.protection.outlook.com [52.101.72.43])
	by imf01.hostedemail.com (Postfix) with ESMTP id 297044000B
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:44:47 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=cEyru5zH;
	dkim=pass header.d=arm.com header.s=selector1 header.b=cEyru5zH;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf01.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.72.43 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=3; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787647488;
	b=y7sw2f2pxuOfKCjBf6F47hWTwSIrw6Zgsg3Gv96/RDH7EGwsmwh1SBtP2T41LxtPeT4B7s
	L6WP3Y9kyB52cOuw23dXxLpWTxv6MFQAF9JKBDbRtRX+T2OBwfvOz9tGkfsg51YqaA+pD6
	SeU3OV+fWtda1jYdmMR5ztaulbNWZw8=
ARC-Authentication-Results: i=3;
	imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=cEyru5zH;
	dkim=pass header.d=arm.com header.s=selector1 header.b=cEyru5zH;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf01.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.72.43 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787647488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gh2hmec5w/ZCUmDkgz5CU6sucE01IDCplkoPoC+O5FU=;
	b=fm1+6yy61zsyVq+Q82Yy78vOU0an3wIVTZSnf380xho/EXITraA9Yuz63Txq0wnspJU4Ld
	yvZJU5F++P7owzlKGPMWbqlXsLxacEHZMWRckIXOCn/llJh8fn5DBI0lfuuzDeRwGFZBHV
	/02ftQsDEvZQtsx4nadaMmco0ElVqh4=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=JCtdE+R4JJpdU+LP+jNNt/9GTQBGTLmm1uR0fDmeZnuyidmffVcTHVFAYc5SLoiOeLEunH7LShMycqtdUt2e78m9EO3NIo3Vp4iWgOKTnhabofpaHpH43st/vMyloN1uJ8E+Vyn0bA3U1yGDZDb5m3GztWxrtUUcNUgmv8zCnZ8N1tyXiXo6uGnGuVPUVGrlDY1eB8P9wRzz2KDlyUg4yFkPTEUO0k/LQZoNwpq0Bg67M8d2YhTJAqXGLqaEKxIhl0qMOUE+xCKqPMcHU3loBZeMhWjaSFM4lV/KGQEG53WOSd16Qnlk/t4vFk7YE0tnytAb+CLemEad3uppRUvTBA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gh2hmec5w/ZCUmDkgz5CU6sucE01IDCplkoPoC+O5FU=;
 b=ajZTncHrD8hFbV6wIslBa5P0yA+gW/Z+3A0C+wuN4Hs0LvdmHY53AAEVdRCOf0bZSY4FcmstKqX4g6Qa3a1nEbU8lZmtQ2ZH5EM1z2tylocaBIU5KrX1o91oZyJHCSOsRqrFVTNrZ7OXuOHk/NhvbHOvgyqw37v76YCL97NIEsa9uZjqtasgrjoQamAH+3flDTIWqXkib1pyDSxViR6LmNAVvcSloDmP3GMUJys7rN2xX4siQrGJJxbzv8JiMu0vaeizkG4c7fNYcTTne2dNDj4j3hxGRhh+EBOwRK6yrjlNWE1hIbgguzScHNJH+ZXMpfGLI84HD5IBxh8XrA1ldA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gh2hmec5w/ZCUmDkgz5CU6sucE01IDCplkoPoC+O5FU=;
 b=cEyru5zH5fLsG75WP/ZcI8nB8aADaBY4A7KBQqna0kq7dyQWdSQNdNdatv9ImBGnIyGHbXO95TFOLfUO5sLZa8I0sazfoW97SLIIcKVKMGtNw3LbdofMOnZN+NaG1LcT8Mn8vrdMQTdpGLEqNpFFVFAcsP7aCvqmTtmYavxJjVc=
Received: from DUZPR01CA0051.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:469::15) by PAWPR08MB11015.eurprd08.prod.outlook.com
 (2603:10a6:102:471::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.12; Tue, 25 Aug
 2026 08:44:34 +0000
Received: from DB5PEPF00014B9C.eurprd02.prod.outlook.com
 (2603:10a6:10:469:cafe::6) by DUZPR01CA0051.outlook.office365.com
 (2603:10a6:10:469::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.360.6 via Frontend Transport; Tue, 25
 Aug 2026 08:44:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B9C.mail.protection.outlook.com (10.167.8.170) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.360.3
 via Frontend Transport; Tue, 25 Aug 2026 08:44:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BIzsfUAqkVoAgDlgJAQMpeuTu9174vULq/s3kbdhUGpS3FKBK8C2b5SPl+5I++UlLQT3PdolsEEnk4wqIRDwUueLRSriO3SafUslHBom+IeCCdjjalDmBR9DWpmJnrOepvsi2GUHjQuC6pzIwr4i7SZJyDC0K9ivMCIiKU6oVOa+p7dQnE4NlB2vXo7xBifey8iagPrq6Ewh9pT5sCMRx6c/QW1DrjRyltsUOB/Rk38BK6vnHscw92ZKl0q8Yydz5y43ofxaP50jGz6zshDJfXu4bUeF2rd788LTx8XYK8jKZfFnRowu5SKbSfldUs5U8Ya71QjpJBQYyUsuo8VR7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gh2hmec5w/ZCUmDkgz5CU6sucE01IDCplkoPoC+O5FU=;
 b=JKrG7rupz09B1SHx5REifnOaTcpVyW7V7kL9sQi1UqH25V/6OrQjWzLeS1exEVUxC3rjUAcS9e4ZNsAnksFUMsdL89KglmoIr1QlcuPogscDBj6YWQI7xwjOCAe1W0f9d+PpE1sdFobiujZab/VQx0+uBc5L4l/7HBjSo2rIzXKQc2YCxBleGB9eRPhkRix56KRSKR2KWly3I94t9FmBasy8C++ADSow0A0m2I/HE+DgH/EOKa5iF8sxufk8/fujIWpj6FUGVVr7Joc8+2iYOopszSYjJm13lSTnYc1d0kNrJPMc0WPWe16lhYzkydaTQoTgtrcs0aKDRhmGMudmuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gh2hmec5w/ZCUmDkgz5CU6sucE01IDCplkoPoC+O5FU=;
 b=cEyru5zH5fLsG75WP/ZcI8nB8aADaBY4A7KBQqna0kq7dyQWdSQNdNdatv9ImBGnIyGHbXO95TFOLfUO5sLZa8I0sazfoW97SLIIcKVKMGtNw3LbdofMOnZN+NaG1LcT8Mn8vrdMQTdpGLEqNpFFVFAcsP7aCvqmTtmYavxJjVc=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com (2603:10a6:10:417::12)
 by AMDPR08MB999844.eurprd08.prod.outlook.com (2603:10a6:20b:750::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.6; Tue, 25 Aug
 2026 08:44:00 +0000
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047]) by DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047%6]) with mapi id 15.21.0360.005; Tue, 25 Aug 2026
 08:44:00 +0000
Message-ID: <1712e68f-f95f-4200-8079-d471cd486c72@arm.com>
Date: Tue, 25 Aug 2026 14:13:51 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 5/6] tools/mm: make gup_bench a benchmark only tool
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
 Leon Romanovsky <leon@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Mark Brown <broonie@kernel.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260813181230.483746-1-sarthak.sharma@arm.com>
 <20260813181230.483746-6-sarthak.sharma@arm.com>
 <c635db29-9067-4783-b706-92e81ba8ce88@kernel.org>
Content-Language: en-US
From: Sarthak Sharma <sarthak.sharma@arm.com>
In-Reply-To: <c635db29-9067-4783-b706-92e81ba8ce88@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5P287CA0340.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:21f::15) To DU0PR08MB9203.eurprd08.prod.outlook.com
 (2603:10a6:10:417::12)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU0PR08MB9203:EE_|AMDPR08MB999844:EE_|DB5PEPF00014B9C:EE_|PAWPR08MB11015:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c88af7b-ca50-437e-90c4-08df02851611
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|7416014|376014|366016|1800799024|10067099003|6133799003|18002099003|22082099003|4143699003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info-Original:
 Kxvti1E2Gh/DrxpnUmsA0mSKk25X+QMUNRazDjJPCyLDoRlDZYTQcbS72m1REtWng5RlD3hwMmPHiKFe8XkBZr5HkIDukR5yURFcKrE1gdNr4+zv6oeauMnSF5st31JSb7sf0nBOf/MyD9XLhdbH5WeMkB/RBugRFF7S/0birwu8cSudt+f6UnJrUHgpG6RQSRKdNWjr9h0Pl/BQfxwbwQsG3QMxUSvEOwHmUXFr4cEbEjWh+7Qdk8klThOR+r2/2KV5ZalHP86U3SRe+Cv89PQ9kIq/a8SVMkOEQwKQdxHYpKYf+m0jYDkmiBHGnYur8fBq7QRMtbetxDTx6dNRNfvOfENhVVQZrP7aJYkhnZ82GgbtwSelXw7n1mb8sjOCPsY4UXkw2UzmTOR5rZfJRQVC/6S3I94g/g7bkB5Vfe7pao/dIh81xRvSPGI5ViEeYe3t8GKXDrZD+LnAdQ5bvDcfHIF1WqSNNVH5XevYNlzBud+cI7eky/q3sXjMB0hxSIo2TxK8XibjtEuIcNWsXPg9Vkrkf4mnsCViOW4b1jZko97X0WnCOZWLMbxSrI1SmtbETccVW7XPZ1F/9jXALpPePqMsEgBYa+kIKs3Zkqrxdui/66lLlvkSrR5FxssBNvft4M6ZKpJ221x2qg4PJ0Vw4175zERWmjsyWhPjN5Y=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9203.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(366016)(1800799024)(10067099003)(6133799003)(18002099003)(22082099003)(4143699003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 TWFLYyHyErvHZ6r2NPo1tryza+8ZNVfj/ivVjVwB0RAKYyFCUgxJSAPhPjrzUf5DI87tySDSVbomi7TLM6ngAXkltHEMdwg/ydU2wn0TProF6/kVMAgib1tlj8nxcNAlTAi9Vw4B50CnSI+WBG7i5C0baASfEaTAGPIv4wIambE2FcOPmzRz2uPIZC1s53w/thbX5QWtBnKi08dUMgo6LZWTAIBR8tfuY1Xyk85RavVJwERDOeIlpgW4y9fhqVOWT7uJUkIQXE5TGmwrRsn4tfqSIvYcsyxwvfkS1wqrhV/I1GNhDstAtegwMNxWtcc344tWsrBTKITfL/zMBp7qYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AMDPR08MB999844
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B9C.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	1fe0c755-bc95-4f3f-bd6b-08df0285027b
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|35042699022|82310400026|23010399003|36860700016|7416014|376014|1800799024|10067099003|4143699003|56012099006|11063799006|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	CXWToWZG1wYd0p8CUPJTHLwboBRmX3qZdSSZ1mfLSsr1LognAfTJdmEX+BPOj6WUlBmp4oqtoora5+5CIMpN2/dGySVPbo1/BUrXpYrFBbwjggQFKMnfh4OBYdbD5UpuTeC86DqtXYotM0iKupDWW/PpyMwQqsQFbpgVrtG//EJMXjowf/j7gzSixzPp1ZOeOFOfetCIizg9urnC+q0pH2sBFG3AWH23CEN4pi6RXMiEd7iKM8ugqTDnA5tsyG3nVL0WlssAj3QRA+WaDpqK82wz6wQucC6ORTUd5TDIvTbFcEFuTP5w8ZyYXs7bLrSL4oUKfTkhGwlol9T9mCv9iQ6cCo4EcGqN+mHb8MwsfjzwpBPUH5rLmipqfoCsosQbCYH/X0oLMCKJewzIpdYLLcRxND8QzfvOdlfydIdsZ57be+OIGg8Np0lOrdmUsPEU461cYei+07N2pkM6yJLrixi3MGdaPATVnH5mVBLI83hGVOShPIPeRsTpcAYYJKuFVeown46eCvDPWvTmwSMOgYReGrmlRi7as5mojqpbvCbsihyo6fF0LXcOfbZJifLRkAmzJf1DHPB/wE9bLpCRo6fkImwGwehivnb/v1S8gPuRmPVrOpR4q6rK2hgPaA9Uvjhv3baY3HQEE4iFIMy9ZCMwUyIFhi24u8pYRYGjd20kOUR1XDQhMejg6aYKu9lCBocgFE966HC+Cu/YsxwFPQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(35042699022)(82310400026)(23010399003)(36860700016)(7416014)(376014)(1800799024)(10067099003)(4143699003)(56012099006)(11063799006)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	qwWNyDZiTNXKeHNESSn453lfRhpJJW6WI/04WfJPuyUqdyuZaM2R4bCSJnVsfXZ7HGFOVduJRrRpx85dgoGYBn+U5kIUi88rbub5FPtzMo3Nmzu/vHz9kQeCuAUMD68bplFgBPQa72BWgnbsKvWHTB9+jRAdMIfySdSnn4H6KxU+hx4k7b6TsHy0PPl3NSIzZN4bhAfaw/wPjpWz66/X+JRTqlZL58CJ1PIXCK204qWVNbjKvkRM7wKcRmrJAc3lvfuN5KVESses+kB0sljUDpF5KA6fxurHuWzEywQkxiMV8KtiJ2TtM5UDkCXXLBoRwvU9jeDYQvVLkvTDrgM9a60cyve1Rk+69ePwHkzDzRK9VYh3KIidebR4VraK6dpPxS38gFghM6evtVh6/71VaRQqwFFfVTkio+icPo3D5NokPAp1R/orhxKqGyMBuw6F
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2026 08:44:33.3035
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c88af7b-ca50-437e-90c4-08df02851611
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B9C.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB11015
X-Rspamd-Queue-Id: 297044000B
X-Rspam-User: 
X-Stat-Signature: qwpaxga1akmxgnpg9p7unybc1zbn3png
X-Rspamd-Server: rspam06
X-HE-Tag: 1787647487-157397
X-HE-Meta: U2FsdGVkX18+nEwxobqaSBYb0ZWWqzVylW9qhv1bNJYaOdCE0QkwK+7uURH4uuI/A8Orie0K2OOPRmbfGblgLqSuqHb3QLb8RWSBGiQw5QxzvASCeDa1F2QyCQjM1NGQ8bbFK9Tl9MKfmxM3kntkueX5lkqtEXYDahg87usIsPPipQAtTW0gYvUVy7xzAk0b8CWpWuHWDXJW/xrFx6RENVtfs7OvKgVSzwWXMKls2Al7K9HFs/l/OZnoTMQ7uPOXvhTiTTEu+hyfVIl+HlJSoOykhC3aXKk/l6y/PBLCTY8nNtXVA6dZhaVUUfr15G62kuHuisYOINS50kex56dJrKIqa+cDtd+s2KufYOdKi5B5Xq7MiXKBD10BB/G6h9UWQQwuN5yS1BIcuAD4OQMsuVWE7sYC1a4AIARI/odZy6qeUra1jOERPnF2ZPzIL7YJRSW/hfpGPie7TZI9crhjjuoczhW42fkHK5sdHvgDTLMnXNPxooE0ltfli5D5JNaHsFXfstD7tfAWTrufUXPjMYkKw5CDvx8uNcpD91Up2EYjuG7Y7C0QehNV4HUULtbSZWk6k5QJZMMs0/hf0K/S22hRHUd+JRulO38MzpiBm6NvAEvoWva4/HW2dyP9lpfnkyan5hd95E6W4h8HT52tK8wWgogqi8SQ4mlWn9HPsNgr1eMnHyMzcsweUu46OP+rwLu6Xb0D5XDGEYe3sdJsCb9QPUfGG2rKvW69Dygdwx1+k+0i6oochCuMJXk8BNoOLwYvCcLi5Fm6cMc9TJEXSbjH5vxYSddwirIn6xVFzG5zgrEuURqOZPLNik1KqA2NaVT57sq/bsZsuBZcv2xHAfc5Lj6TatXtTk8Qs95Sb8cwYgPZ9wzdtDWVFxEvsO7dgT+zJWU96TesaD/1TsjDko8Z6bm8pEO7iZjrgKQnOBXS8o6Lm+Cko73svTKntQ+fIpNMkhKqW+cb1kpE/2G
 YTl+YLtV
 dohHYcSr3+nvPyRroHxfRRNkGsrR8v9KOWcDlgUZl3xrW4l2TjQ2t8SMdCd5uw8cirId+znUzv+5ivH1A7LAY7X7qyViOu4FjseZDWOjxbUX7Z1Gm7wSHLCpPJH29DRbFNECv46cbICFMcnAg4YGtzCbrPJTJXZ2m6h5fzzT24v80xj5AE4R2qtjktFkbcUzkWa9pPsvPUCZ7kb9Bhi4PZclqIXpnSvcRj8QihP2Zl4/wZLtHA7GZKvPkPfZgZhIRJpttSmljHEAfOlVx2LL6u5t9Z/i3oSDixFY6GfJoDsf114hrEw20z9eDcToPVFFRtc3y/Ahx1oid3UCkU10dQ4r8/6nKWa6BPpc07QNGagv9I7ptL0cK16n8hMgAqNsgmq/4RfU5j8fzH/EupgLvsMc6WfE4JVQfn5+eul1fWu9jljFPXaaFvsZ9+o+Y+yT/9ZrIRFSwa+PxdR7yTJKFf6ntftivs3wR3MHll7nwSu8+SoZALWvuI0I5V2KxO1x64Mj0z0LSBfoSCggaosuGrpEaA/HqWIZWl8rvsBRkhim+dusp7dOiR0vwHyb9sMTcbFauh4HFN3hWxt5DhbaHpRZEt6W7p9DC5BaJmz8aZnUM7HbzZedSYiXFCyOL/XpRJfZ7oRjkOsFak/Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David!

On 8/24/26 6:07 PM, David Hildenbrand (Arm) wrote:
> On 8/13/26 20:12, Sarthak Sharma wrote:
>> Remove the functional modes (GUP_BASIC_TEST, PIN_BASIC_TEST and
>> DUMP_USER_PAGES_TEST) from gup_bench. Drop the kselftest dependency
>> and use normal diagnostics and exit statuses.
>>
>> When no arguments are supplied, run a single GUP_FAST_BENCHMARK
>> with the existing default values. Let users select other
>> configurations through command-line options. Report ioctl failures
>> and handle errors without relying on assert().
>>
>> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
>> Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
>> ---
> 
> 
> [...]
> 
>>  	free(tid);
>>  
>> -	ksft_exit_pass();
>> +	if (thread_error)
>> +		goto err_unmap;
>> +
>> +	munmap((void *)gup.addr, size);
>> +	close(gup_fd);
>> +	close(filed);
>> +	return 0;
>> +
>> +err_unmap:
>> +	munmap((void *)gup.addr, size);
>> +err_close_gup_fd:
>> +	close(gup_fd);
>> +err_close_filed:
>> +	close(filed);
>> +	return 1;
>>  }
> 
> Why not have a "int ret = 1;" and just befor ethe err_unmap, do ret = 0;
> 
> That way you avoid the duplicate exit code.

Makes sense. Will make this change.

> 
> 
> Apart from that
> 
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Thank you!

