Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2924CD3427
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 12:08:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7DA46B008C; Thu,  7 May 2026 08:08:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2E506B0092; Thu,  7 May 2026 08:08:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF6736B0093; Thu,  7 May 2026 08:08:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C16046B008C
	for <linux-mm@kvack.org>; Thu,  7 May 2026 08:08:47 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5BE6D40503
	for <linux-mm@kvack.org>; Thu,  7 May 2026 12:08:47 +0000 (UTC)
X-FDA: 84740502294.09.2BE8CB0
Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013018.outbound.protection.outlook.com [52.101.72.18])
	by imf30.hostedemail.com (Postfix) with ESMTP id 85FE18000B
	for <linux-mm@kvack.org>; Thu,  7 May 2026 12:08:43 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=Q5nCQ0UV;
	dkim=pass header.d=arm.com header.s=selector1 header.b=Q5nCQ0UV;
	spf=pass (imf30.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.72.18 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778155723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CHulFa5g2lfmsUqkwN4eTGae7RpKpGmIvRS4Z892znM=;
	b=49hB5/oqxzr14N1ZnnklvpNnxO2URUAwiwpFYOgKZ18eOh2dtqF/6QLNg3Q43GKueSCDYK
	HjRZcqd2NcPSS10azSS6YlTrPK0PZpfpsY4RAKoDORADo5k3RAA7feBi1brAChyGts3M15
	PXGgj5PKJpN+YUy4Sp6fFSW4kABR9Tc=
ARC-Authentication-Results: i=3;
	imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=Q5nCQ0UV;
	dkim=pass header.d=arm.com header.s=selector1 header.b=Q5nCQ0UV;
	spf=pass (imf30.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.72.18 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1778155723; a=rsa-sha256;
	cv=pass;
	b=UtnOjmywu5Pbl2R3b2x4U7htsPsF5sjg5yFtZjZc5BCjs5UD21WmiuOFnGpoR2f16QTsuq
	CXiGFDMzce+UNckpIt7lo1F2qRnQ/B+OHa82AYKhD8Ab/l0iErRC5i01GHcjqq/55oVPj6
	HKcqG0oAKHxUWvMq8hnrlE2zq9b6Dic=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=vdzbC4U5GpruTeS5wo5ne8XzthOwvS2KV+Eihx408BvvlzfpHDgFh8n6Fm9G5KEBhMbzmK6BhTAoODTETi/fhxWA4uoGsqKwt7Dwz/fcqjY+yV/1vLGLnnubGcVRL0SveWi6U12j6ahKc7lYfcHk/UvgbkAq51jZRxdf03E0upKeGb8y/8dLUcjjeSnlkLhhYY9V5K3f4/vqrgt2/Fk4j2dRcubnQdh7jgK29aefUZcl71IzN3O1iy4gKOgcjETLPmIH+ZPAKQ3Ki9WwCvzT4xBGC6D9zCBQmLSe6KehmFeYg78ExVRUGjaTJg/lyR0P+4ykGdPlYenCdP24q5QA7Q==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CHulFa5g2lfmsUqkwN4eTGae7RpKpGmIvRS4Z892znM=;
 b=kYvwoI5EcxRo/WqFJNNqLXsIrayCMhKuLK1OwxL8+s7y8rtJIn2Ro9iEx0VCsIgvE02MOjD5crwtT+Bs8SYlIPBOAt7B31XzDNxj8/tx/s5RGQVXC2zv1IPIBeiyIK20qOMMLTWE5dfxgMwaB9FR9q6qPVNrhaWoCxSVzOSQgwKqWeji3F3hwtrmOU6UgnRwcLQsPRj5UEmWrTHVOBB+GMfhnP6OTruGfmI/NpqqBJrJoFo9/XvyCeIaZAjqZTTieQ8fVu9XNmf/xLqSx9SKEC+Z7aHC6z3oHMiNwS5tQMl83X260E2m/YQffCF70lfSrOsZRONPN1cJGKID+GJDkA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CHulFa5g2lfmsUqkwN4eTGae7RpKpGmIvRS4Z892znM=;
 b=Q5nCQ0UVdOozZMxUW/cqvyCDftbgQHag3DDPMUZoQCKPXHdSb/WOvUzFXSxYjCc3/aSzC7rRtZ2qm0CK61+tMv9J/JAXQ2tlnRDzQcOQENurkamkciM92GYJY1NSdRiIi0nAZ874+Ie3hB5sbwjd4u8tuMLlABs1oGorBW/0Ruc=
Received: from DUZPR01CA0257.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b5::29) by DBAPR08MB5670.eurprd08.prod.outlook.com
 (2603:10a6:10:1a6::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.17; Thu, 7 May
 2026 12:08:36 +0000
Received: from DB1PEPF000509FC.eurprd03.prod.outlook.com
 (2603:10a6:10:4b5:cafe::6b) by DUZPR01CA0257.outlook.office365.com
 (2603:10a6:10:4b5::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9891.17 via Frontend Transport; Thu,
 7 May 2026 12:08:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509FC.mail.protection.outlook.com (10.167.242.38) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9846.18
 via Frontend Transport; Thu, 7 May 2026 12:08:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xQ6dHkBm0Umhhm+uFFgx3fRx1Ek2OcYQ4dKEvpw/SxXZL5RSORupA+VHDXCkOYL5X+XgjVGB8JGN+0oNvEIyQL+bqWdmjcYNYf4Q7IHSY5blRPlpGMQ6DGbIOezDNwZ1kSSK/0ZRntxEXC3W77zSNg4UwYFYbsXupDJIZGY4XMET4SK4tf483/zIk8BO231lA1xubqEtXntARfkaiEQyUT1sg3SsWlQVPVxzqzpQ7lGMzzQEJ45jfAPmTZBAfPLxnskWTTKk6JGIZ3izXw9nw8mO7TkS667+usvDAfK7SP/HGUaB/jia9GsNiWSqTHLpZVGV+8EBO5VS44rngIeW6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CHulFa5g2lfmsUqkwN4eTGae7RpKpGmIvRS4Z892znM=;
 b=V3e49bZNk0OTsmZ9Fi8glBE/Uhfd3q3tlrnzgCIBcjngI64SziO6o2Oke3pIIQCS+Cnn3UuSJeN0nYjSTijzoANVofm7iJdxV8EHqp0P+MJU0gmCtut/sYo/dvmNqA72USVVSrptoWAo8/WP1h1TlPdfKdDsS3+N7+qhK8yuP9TksKraa3Bws3Q8nmCrTUVIgRf2nHk5G+LA8wmKGYPP3dbymbQ4OxUBvyIzqLziOBoCkTEN9qSTUaOYgiCMBnLAVN5UNvATJd8upfJG1LN7vCGBCwG78Oi4ogNNhtVA7PiiJS7sRpo1pidLMgdgZ2FeAf1DbW+J+6W9Pqye89V/Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CHulFa5g2lfmsUqkwN4eTGae7RpKpGmIvRS4Z892znM=;
 b=Q5nCQ0UVdOozZMxUW/cqvyCDftbgQHag3DDPMUZoQCKPXHdSb/WOvUzFXSxYjCc3/aSzC7rRtZ2qm0CK61+tMv9J/JAXQ2tlnRDzQcOQENurkamkciM92GYJY1NSdRiIi0nAZ874+Ie3hB5sbwjd4u8tuMLlABs1oGorBW/0Ruc=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com (2603:10a6:10:417::12)
 by AM7PR08MB5447.eurprd08.prod.outlook.com (2603:10a6:20b:10b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Thu, 7 May
 2026 12:07:30 +0000
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047]) by DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047%2]) with mapi id 15.20.9891.008; Thu, 7 May 2026
 12:07:30 +0000
Message-ID: <6ee08c4a-da7a-4ea2-aab7-eeee1b415bc6@arm.com>
Date: Thu, 7 May 2026 17:37:21 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 53/54] selftests/mm: run_vmtests.sh: free memory if
 available memory is low
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
 <20260428204240.1924129-54-rppt@kernel.org>
From: Sarthak Sharma <sarthak.sharma@arm.com>
Content-Language: en-US
In-Reply-To: <20260428204240.1924129-54-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5PR01CA0182.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:1a9::8) To DU0PR08MB9203.eurprd08.prod.outlook.com
 (2603:10a6:10:417::12)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU0PR08MB9203:EE_|AM7PR08MB5447:EE_|DB1PEPF000509FC:EE_|DBAPR08MB5670:EE_
X-MS-Office365-Filtering-Correlation-Id: 81907e82-5fba-4119-1de0-08deac315d53
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|7416014|1800799024|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 7LSdzQ7WJdMvhzLywLVuhf88sBM2m4j5JFZza4Silg4vPcBQCu09x259TkihT3+APsiBlRfLz4iDfoNi/+Ox56BNmofj2HTUZd3x196nkMBca03G7cDEiXnfydMH9bfVT4mx6W0IHvgeEx3ePPov9Fu9/WV3GtXCjRow7Tk6WcShzgfrWC/ngKvuQom6UHMDC6CokUc/hHZB52fgCGHrb3vmvUga7rCF/obfNA7NHW/u546iP8wpXyKIHJIpKhOo4N2GkjVxpF4ORrd8cp9MhPU7hMUb8SQa7FVAq/+qFQsybpoGRpmNlXJO436n0d2lDCRHkUmbUHUFZCtIGmiekjn1nlUvctYdFqxbQw8SrMmCYMSmZ6lFAMPgmuUEHjpat5k35nUvl/zEsL8D9GDfBB1T5+jWTS/07t4j6WYMxwzVRQ9MUvfkkC87Urioia7m7DKRX6bn4oBD36IlMdELBSQr0b4JPK6uA69C4Z7MMu2Yt6eIO50+P2CTeTz8erOtM1s3UyFw4mQ3WG2XJzY3XD23zz5VEJQz0eBwjXG1IwjTtnPnUvhTl4e3HN7DMKS6HF6swkSYLnSxP6redZ6jt7EbJ3YqandMDOflBPKij8CCvh8jy5bPZBuFBmDBfSYWiQd6B5yKAvNeHr98voHNFBb9zC6ThQ8tv7afoD2idJI2a75M1Dvsy4TE2RQvd7rL
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9203.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 IFaanAmvmXPVsl6QBSFz+gdASBvkanfMcWK97MW/5eugIN6KT3MGPV01rTVefkNAohEy0ALdfGFXsBLtmeIKVa4XTWWhyq8qs2Fe0dNPzuHRlBON6x0lUP9sjzOkqdiB3cl+5TWZFopC/h+LHrsGoH9MqjrCW915rCorVodEaELEVQX8s3RsVahZbwDHYRYAw/oMy6VvlQWzsRJXqaAXieb9rYEMebs8NfYVajjHIXPLWyt7FM548hrtoQK3OUuv5rOCNUc1t+kllA1RDYkx4BDktX66I7lvMyj216bSyAAd9AhC6dF9ECtPaI9ShwLqszNO5I+mpBXoAL8IZncuIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR08MB5447
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509FC.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	b9fc4b6e-8890-47aa-1ae9-08deac313634
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|1800799024|7416014|14060799003|35042699022|82310400026|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	M9g0BqlHIAgYKahP2DmohLvKNGYUnFSYGDUtuZ/oy9s6qClxY3PuPU9QWOqKsf1rWlI8qGNn2eaRLGozEVdyZsp4V7mzt3UD3OBIP4gvOqJRo593UH1EEkXGNsLR2YOpUFRbq2C0aQqBXCKR6Mx1NqDhTw3v6lMRMA9YDLXnhXdxCd/inHKm6JKC/3CfS6ElpUg2XwZrbhvrNx215n5V1vTOwc/muiJ4kuVhgs0OrbU0Eu1CySTzhI7lr8TX4FnrBNpU5ZqQBdMDxuzcxPShGmq8LDptX7WM5YbpWU3Z7Krcj/qRRBY8I06qkC+aR2nC7oljvGpuqRqDFL6PQp//4GuyP/mYAdV5Cy9GvM/sLbrQv1qr8HDm57On9q4l1Rf0QFyTILxBUDS6REIMnYYzfwFwiozCmwNLQyyFWab2DCSkcxi65HKHVvUNMXLqypwTi/sCA+VOMAFxrqpG338/RKOoSmf4FusIuzCSHpepjR6jF7bX8Ij6ksIhBSUtnkKkXD7hUYAkXdqqTGUVJp7XZS+qqaJYaPKdJ23y/qxS7o+LilmwRbMZj0mBjdJdILj5zz/jXYWKnMidDbXQdYXjHqbyOTYLFv+5mjt/2ZejKgG2WBMsg4eQ1YxF7+kgbz8YTGiRVWgtkD0lloNFaWmxFsP6yjnKkqY8TTjO285byA2hPLl41Zt97KVB1jU1Izgl1xHx4aKPFoGWateq1dXXkoDykwDA6TieCK6ud6Se7Ls=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(376014)(1800799024)(7416014)(14060799003)(35042699022)(82310400026)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	JZK55lL0KQ2F4o7HmvGtUkX6gKQokEysklN30cbh0GfCE9Cdn6bQfxoBb1bEBfqQdnEnsVX9xcpGq4MS3JNOZ2xo4cazhzxVQgiWfnecIZJV1BHxDYiazrVjq2Tzf5ppGbnJUm7ppS3hwu5rTo60EIL9U2qzvy3mhWJlmw711nyxvG7eEkyk8C8+HEH1rLNH/uO+jImmPqmEAvmXXfjdkj2/Qn6dreqXDszghjiz50YKxjsK91VT/utJODrp+J7FXB1+iQaQElUGtfTVxTAjpmwPUMm65p6ACyWQiJqIWbcQuBuhGaO9FTETQ6niYYmtiINMaUer2zL9aky5g5+ZAA4Nl/A2JL5aL859d0G2MHoMiYDgOzZyGgekjY5JjX9cYIsZVulSNgX9RbeKmM3Q3Gg3CZIUxZLhjjQAZRyFzkwMwmhCTYPuw2Iw1B8dgxFP
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2026 12:08:35.1172
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 81907e82-5fba-4119-1de0-08deac315d53
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509FC.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR08MB5670
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 85FE18000B
X-Stat-Signature: 4brccjhmfpxxduewebannn5brz7ztnfm
X-HE-Tag: 1778155723-132722
X-HE-Meta: U2FsdGVkX18ezkG1C3fR89JZjP90mwXyTrkvVLRazTe0Q1nlrjAoImvlvX7OdzcB5atN/DJwgpa9/KWS/zca3GfmEjewHGhyTz+6NFLxDn7tVf1tBOx65y+hYB0AahToBQ8bMx1h5cStZOf6052eVmXWi4eTvneJd0nO2bNI7wO9aFYfeWcPeUk3yGumvAwR2WOHQVWWlaPDkmJw/96QPKTLadomeHtqjxonsSHLmpcAsjixIvhQ/Stu5HQI7vWkH/Klv+JobWcqzzY9pJlIyXCZZZjltESbHpD6uHZ+lHNX5s3YQo6UQfmiAnmS9Do4k7naxc2h3IiIHYktb3dRaIHOI8/uRSKwuOdJucqxxkiG1vIbQYNKsozkrJKkBXyqA5UY3gMOFyGc7KKA1OuOQQQkkD3I5wcCFOhctHJU/GjU1+3CCCK/KpDLxQUDsdUd+ysYN3jAaqPufxWU5l7yP2/9Jx6xb7rDL8EO4AvU2toHkcICXF3upqt9+yXwaU61BlZwBsLZJE8IXH3JxW5r1hPQ//34V232wMYWIKyE3Hmf1jXsdJrhLSUI9S2Pjr2WSZSXU5bOqZRPToO4lvx2EQSdLwYbwxohB8JIEa0xU51izg9YV+Xs+Il22y/GpIYiP8tEW0sR41sHQTL/Uyp8oAw2ouUZbODfQfKojxAUOFziSxrAbDHs+xZiOWx3dWyFNKyfbSFN+caD01suxXHaczi0OA/bQTBuxjZ8mrTRuWUuieL/PaHCYS0YRAeRKs5SFjX6W9FrEu5Pm+DGB+U1v5bUELs58rKi2mZO/TKwD2Yjhqs5h5sdT10UUp4ne3gL6iTNUSdpyumpUZ+8G5qe2HnNf9ItAfjiIZ1lDOTYg4NuJ7A+a/OnewXYQpE68cRC4auKjjcBjAtlfXIr1u1d9abO0KfqhFYQxyX4CI+F+DgPquhSCHNfTXxE1hM4PAZ3LlLFcY7EjbGxvueZ6gU
 pU87tS4Y
 UW2S5fSWmRxv+m2Tf8VqKHGDCjxDOSjh/gVqDe0RXC3Bp1PKPjRBAjdXCQz2sSO69cNYnpRBMQ1NY/8wiYVRTTQQpBZ+RhB79WqggS0DaW4YKbk5/Sfi/gL1Ogp8/5mtgppm32PrL/HGdo2dxn7Ymfalada2M3nbmz9O6We6sOeHn0eqnNfo09E+JxGFzT+5VZd6BKwUiRF+ypwh+5kGwfm5fK6wEcEl/aOpMruKT4kfqx1rJCoLC89Tw/xy5WLy6LTgxapLTMF96PkJ5NTWJdlwLSXieUQdzxoXtJaFKR1dKBqsww+Kp0KUjUpvwcITqai2rKHkAHNP2Ul3bV1DUl+waJV1rrfDy3EZc1HCdFxrhfTkdM+7k4KJj2AJmn8/8S4tEaPDTugcEI0Nkm82sEpLg+lLkDtAoObxeA1QPmaFIWwSf58j1zE+GcQXVoNm7axzy4D6BMhdtUlgi+J1RLW8ultylnfZnM/yMIP0EiFQ50C47H2uioCtFtw+ivpGs0VCI0aeS7WTmDkOeScwDAGchQbKVrkQxpscYSn34cGxQcAT45OZqzqF0ZwDcGxMZUKw4tclXGufX/luPMoVwHuA5nwuHZs9Zl7p4P8rtWpnPp/U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/29/26 2:12 AM, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Currently when running THP and HugeTLB tests, if HAVE_HUGEPAGES is set
> run_test() drops caches, compacts memory and runs the test. But if
> HAVE_HUGEPAGES is not set it skips the tests entirely, even if THP tests
> have nothing to do with HAVE_HUGEPAGES.
> 
> Replace the check if HAVE_HUGEPAGES is set with a check of how much memory
> is available. If there is less than 256 MB of available memory, drop caches
> and run compaction and then continue to run a test regardless of
> HAVE_HUGEPAGES value.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

This patch looks good to me.

Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>

> ---
>  tools/testing/selftests/mm/run_vmtests.sh | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
> index b9e520194634..b42d19036182 100755
> --- a/tools/testing/selftests/mm/run_vmtests.sh
> +++ b/tools/testing/selftests/mm/run_vmtests.sh
> @@ -99,6 +99,9 @@ EOF
>  	exit 0
>  }
>  
> +mem_available_kb=$(awk '/MemAvailable/ {print $2}' /proc/meminfo)
> +mem_available_Mb=$((mem_available_kb / 1024))
> +
>  RUN_ALL=false
>  RUN_DESTRUCTIVE=false
>  TAP_PREFIX="# "
> @@ -239,15 +242,12 @@ run_test() {
>  		# On memory constrainted systems some tests can fail to allocate hugepages.
>  		# perform some cleanup before the test for a higher success rate.
>  		if [ ${CATEGORY} == "thp" -o ${CATEGORY} == "hugetlb" ]; then
> -			if [ "${HAVE_HUGEPAGES}" = "1" ]; then
> -				echo 3 > /proc/sys/vm/drop_caches
> -				sleep 2
> -				echo 1 > /proc/sys/vm/compact_memory
> -				sleep 2
> -			else
> -				echo "hugepages not supported" | tap_prefix
> -				skip=1
> -			fi
> +		    if (( $mem_available_Mb < 256 )); then
> +			echo 3 > /proc/sys/vm/drop_caches
> +			sleep 2
> +			echo 1 > /proc/sys/vm/compact_memory
> +			sleep 2
> +		    fi
>  		fi
>  
>  		local test=$(pretty_name "$*")


