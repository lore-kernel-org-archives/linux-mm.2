Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04F7B109B48B
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 15:10:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61B196B008C; Tue, 31 Mar 2026 11:10:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CBF76B0095; Tue, 31 Mar 2026 11:10:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46BFE6B0098; Tue, 31 Mar 2026 11:10:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3047B6B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 11:10:06 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DFF771A02A5
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 15:10:05 +0000 (UTC)
X-FDA: 84606693570.01.98D7600
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011030.outbound.protection.outlook.com [52.101.70.30])
	by imf21.hostedemail.com (Postfix) with ESMTP id A55671C0005
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 15:10:01 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=gZ4OrIv2;
	dkim=pass header.d=arm.com header.s=selector1 header.b=gZ4OrIv2;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf21.hostedemail.com: domain of Usama.Anjum@arm.com designates 52.101.70.30 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774969802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lozMjJRNAqoaUaUZBmRl7EgInw+BWKG6uICLrsPT6M0=;
	b=2UL7mZ/QmYKbe/xvxaCYp0M8QXWk0tlQR5sR3srjPyusOxXn/Lh2gUOFk1jbWTAmNmFn9y
	r1KZ1t5ASMbTLrFkarpisvdNGOlRjDVLTSw/4rBkwtE0SrwzgOx6tLs7Isq0HOO5EYs1gF
	RW3BAhIx91DsJCEiQCBEOxAneqhYzao=
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1774969802; a=rsa-sha256;
	cv=pass;
	b=stb42lzsWNKDMenOfXOwCpZxgM/fVQ3W6rF1V+SKZvAlO1qB9adY6Ln6GGeowm/ILnQwKQ
	wXRJKQIloIC9yzYVy0IYSbgyeB2o1URxSbRNmHvV/Dg2FlJQwJnUSpouOHOQl0+n2i3qVK
	t0sZP3AmluxkCy4yZpyAmhA6kEp495U=
ARC-Authentication-Results: i=3;
	imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=gZ4OrIv2;
	dkim=pass header.d=arm.com header.s=selector1 header.b=gZ4OrIv2;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf21.hostedemail.com: domain of Usama.Anjum@arm.com designates 52.101.70.30 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=yXpoYM1yrINMFV6M94JyoTmxpXilCeHHaJgxvF0bT20avzeu6DKg0L0Qm4mDch6NCTqM5UEAGb8SQo3l0ExeGiTKIgImTmDjqyR3IzlvG/QUAmNXwVpwhZ6zjvhHe1sJcf1E79GTgcoEjTNwABP0uap8SvpN6I0pit5hoLzOXkjYuTYSgizgqoRsXwCeyaVTJmVM408W33xzup261EUkJyyV5RB085Jhs+ql/9cKQzJVKtap39xxTA0/WuHva17kIxBIIrs9ghEcxuEh19G062aR3CmDmnBut28cfGftv94y1wtrh5zMnQRE9o4wG4WmbJSWmAZHxCAAGlXNDR4c5w==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lozMjJRNAqoaUaUZBmRl7EgInw+BWKG6uICLrsPT6M0=;
 b=sm+MwG9/KMGhVdkmZDvZUHCoWN8HXWTMD9sr856daCUbwvb4IOOQ+77S3tTRMn7qChHuAnvBKFOLbSLDuiNjf7ODlf2BwVSXLMUK6J95+CygDVSy3mN/3Q/Em/LD3ThDwiibx2Izyiu9B/jCi9AEzhmv+7Z+Lqi0K8WSLZkgG1x92RCtY3ELwea7VzGYYjCr62g5PYbnOiCjJVyeuVbY3riQlQifJmZhI94gv2UBFdzuEepnk67erla8U5SJMuhLcOPoEMtgw2UNPaAsIcAZQrSaJ/7dDPakiOV4jsUGhMxI1z5c0LbBacpE/fJas4Q8TpSwUmVzlH2E+Ywyek00CQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=gmail.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lozMjJRNAqoaUaUZBmRl7EgInw+BWKG6uICLrsPT6M0=;
 b=gZ4OrIv2Un+tpELrDVUTZ4krmfABsvRHfhdpQ3pFqLHbAn9vGFDU5O0sbnci6A8/+TzC9e9KSG41i3nVLRLfr4mrz4oSUMS57+cP9K/Kr2FeFBF8Dp9ICiH3TV8wwIYL4zN/+rxQLImKuzKIrnovp53MeblKB1Yy4xbzuBcl3nM=
Received: from DUZPR01CA0346.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b8::29) by FRZPR08MB10903.eurprd08.prod.outlook.com
 (2603:10a6:d10:13a::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.28; Tue, 31 Mar
 2026 15:09:55 +0000
Received: from DU2PEPF00028D12.eurprd03.prod.outlook.com
 (2603:10a6:10:4b8:cafe::6d) by DUZPR01CA0346.outlook.office365.com
 (2603:10a6:10:4b8::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9745.28 via Frontend Transport; Tue,
 31 Mar 2026 15:09:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D12.mail.protection.outlook.com (10.167.242.26) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9745.21
 via Frontend Transport; Tue, 31 Mar 2026 15:09:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ri92su5rCiSYqkn9TZI7O9q+ody+SaeC6qATw/f1TpY8wrYynMtT8SNraLLT9ga6lLcL34RV+ok9Q0x4wuWbsA4VErvEWAZynsYClQnLgcdmNpPsGuLWqoagpxUMH7nU+6TeY9IGxeZzGoGzU/Dxvy2i8WvkZL+NNTG7DkJQHewmaDUbXGprDLg6NbuCxX4wgjkT7R0omcMfCcDNYjiey/gVdCDzAS5yWouj6bPoCAExFqMTiWoJ+Q3Y1jz1+qgZFZQTEUQGmJARNCM37W7S64AQIL0eIfLqjoXCF5SiPm5p5ytoacqUZceUkjuNf30Jx/WV4cFbqD/CzWneaFk3NQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lozMjJRNAqoaUaUZBmRl7EgInw+BWKG6uICLrsPT6M0=;
 b=SVsjaOB8jxbEq2lMOgxco8bs4C1QIE8kwLXn4Pz8wUeW30y6LctZPJro53vjV4BX0RC6ciSYlms7XmxsiaSJ7Ft8wpO/UrOVwaZbgZ5j7DsIOYieTPdrKrTp/MzVekdzvohBHvZGT4iKkBqO6cf+cF79D940azP4nJCv1n8PabVH/y4ccncZs54gA5aloejE8BqPr9TMDRjwC0aSR4T9WOjONeETvJAuDIc6HLeg4CRIY/HKGc2Qdye5xP0bl0YXqBOW5UAhW7LXe3zFnu6Q+or7ahoKbpS1Zxp/abDc6rSI5Zyf4AHO9gd8cJbfhDV81YZJcez5k7z3vkiW9jBOCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lozMjJRNAqoaUaUZBmRl7EgInw+BWKG6uICLrsPT6M0=;
 b=gZ4OrIv2Un+tpELrDVUTZ4krmfABsvRHfhdpQ3pFqLHbAn9vGFDU5O0sbnci6A8/+TzC9e9KSG41i3nVLRLfr4mrz4oSUMS57+cP9K/Kr2FeFBF8Dp9ICiH3TV8wwIYL4zN/+rxQLImKuzKIrnovp53MeblKB1Yy4xbzuBcl3nM=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com (2603:10a6:803:80::16)
 by GV1PR08MB10402.eurprd08.prod.outlook.com (2603:10a6:150:15d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.28; Tue, 31 Mar
 2026 15:08:48 +0000
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4]) by VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4%4]) with mapi id 15.20.9745.019; Tue, 31 Mar 2026
 15:08:48 +0000
Message-ID: <6373112b-d89c-463b-9802-9e2b2fb56ab6@arm.com>
Date: Tue, 31 Mar 2026 16:08:46 +0100
User-Agent: Mozilla Thunderbird
Cc: usama.anjum@arm.com, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Nick Terrell <terrelln@fb.com>,
 David Sterba <dsterba@suse.com>, Vishal Moola <vishal.moola@gmail.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
 Ryan.Roberts@arm.com, david.hildenbrand@arm.com
Subject: Re: [PATCH v4 2/3] vmalloc: Optimize vfree
To: Uladzislau Rezki <urezki@gmail.com>
References: <20260327125720.2270651-1-usama.anjum@arm.com>
 <20260327125720.2270651-3-usama.anjum@arm.com> <acptAMZrCKz3Y7O3@milan>
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Content-Language: en-US
In-Reply-To: <acptAMZrCKz3Y7O3@milan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PA7P264CA0215.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:374::20) To VI1PR08MB3421.eurprd08.prod.outlook.com
 (2603:10a6:803:80::16)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	VI1PR08MB3421:EE_|GV1PR08MB10402:EE_|DU2PEPF00028D12:EE_|FRZPR08MB10903:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a65c9eb-d9cb-48cf-a646-08de8f3790d6
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|7416014|366016|1800799024|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 s3YIdrRj7NxnIDowaMdXDtzDabz+02GMyjw2lsbXW5U/c0caRDqAchK9nGcQrlmi8iAeQ4tOGgzkMPifiZ79BKlVQ/XRBKhfdrCcbvoSjFnSEz5DQtnCoc/lnvaxqjdT47MKsY34NnZ3Gt9HgjqFNDO7FcsZ5nXYZWUqcVOUbwmLqIz98irgWw1xUp8pqW2B7aNCUmAocReocQ9KHG53pn0nqUHqpsOo8EqiHQLTNMQQs7utENvIA1gmf1DN9cjoVKv9cYlq4qmWr+hq347G1T1QfOMjqyTk9jQmL6i8PENkpBWKjhsnjLaQUmj89JVdE9cGDd61n4KmCZGHbgYZwkQy4sNc3uFt6zPojAlEDGagezRkCCJAeBl3wvmF7EUCC/rYmyz5YFsnUj2fLHzU70Xc05w9+/7cZhn8CbN84ujdvKtc/ddyFOFIel1TPx8MpFaFbJfauXm0pM8YauqXRroLxHNqOed36j2QuuF9181YQUBwX7jCmnqRdNIku8sSJjEITZ5AkI8FlqOc4mQjQIYPqKZzRaNyJ9/wbYVjr+dVrVfQd2KVFKQVmKL32XDTuVW33dIsrvnlxDyYdYrfU8fMFMOBh3vTfHMdSOAMkboX52T7ZABqFJZnMV+shGwimixscyYjR4eVFj2rfic4UxCZjQkcyhZbrj0qO1utAexvnWeTaIvHTuxf++I8HF28
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 LW16E1jLIU8UNH6wd9Y7QVID9iK2PYVG7qwFZ8zvTOSkHgkHbJwI9WoKrCKJL5S5JuFi2Gy073yJ59LxerF8x6oiOd0PqU942Hxnj2n5zcuFvsnmL6WONBo0jdHdQpyKHRPfUWOd2EGxZNM2BjWiuAS05dfbk6GN8EskVd7bB3cLQxiPuSy7HuZSa8fNbksrGm3fqIEfTZ3nXmUbctLHgs/5AH9cR/uKZP800GAJTIjWVpDfY8w+5ewsrTeGrfPPxi7LJRVt53ryy7R/+xn4dSg2OljD3KcH+Pqvj1xuf3va+iBjk0AwvMuQX2LSUPrCPTpe/+zZhXh5V8VfHjhgrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB10402
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028D12.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	ff649b6c-182a-4740-af15-08de8f3768c9
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|1800799024|35042699022|82310400026|36860700016|376014|7416014|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	XCg58wUPKPOatx5rCOOHY4uFkyT03LYgEW91M7hK3UdAnqsS0irckAHaUmTOCps8m9yaZ8zKuw+MKXbn6T+oa1ZZ2vwpYG59ddstLV/4wRvivNp3oMvZcRaFqpU4Og98JIyggCeyqpl21EbRzVwHDTOElgRoxVp0au7JQxBz/9QJlpeMX/RuyrhT6Rci4exGiMNu01a6PjhJBDm3xqlDK99ikVX2AiyHaCsFICbzT0UushQsNlbz1o7AVuagsUxDh8JWA/ITMUMJk5w0Xryk9MOJhPK9EulEAyvVEelpyAsQEZpa9QiE62pBMkhENu92+oRm1RBV8MBxFko/ZNW2IgS5k0aUUdQ1MVwpXgMfKBnzzWLHHm2sL2g10Onk6qopAZkvs+Mx9XePJ2/G6h2q4QMfiWazfNo68Zl4bSLdUEB1PTut0XFIEzXPESij4xKDzvZgs38WtRkFoKzENNXS7VmSzuuG2jkoRZ9mMsP0BEP7Zm0gNmEsGqqTph+80dhzMrw/l+J/5+ZLUmdVwAppMyCZRxNm713PXs/5FZxYRH0htojhXHl9P1y93aGwSnZYgcKcnDL9oDql5syHMiL7lugHEH1+i5GQaH2DTJQf9+cqmwPXYjnPpt0tyFnaNxweMQjtHtKJOkRu+rk4bx4jyPO/bgG3yM8QtXY/xqTVjDLNfBOYz18cjbeY7m2iAiHfkcmhfJbzjd0u3krqtLDBzSjPK1+EWR3PByiFW7VuzqI=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(1800799024)(35042699022)(82310400026)(36860700016)(376014)(7416014)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	LHAMJ2dIJjoZ+eBWKns/CxL0DEZqcuyK3BC+K97JncQtII2NJNksZwThoV0+RsLpXOP+yXsMzWFOFLV+P587gffvyHscxjrhJh7hIkZR6Pq9A1LRyIpOp1ZO32PBnWcqNitit7KHyA3OgzX4BIMDN2SvtPp88VFDFqDX0IuSA1x+hiDJ435YB4q3SkrOTnqlX76OFbZgKOzN70883CxFFlCsUTltUxO0WY4/Txsp6aCjl5qv1gzDUp2bU4XJPoy2XST2xJjfpjbDW/o/K1mAYNZk2BVLSedpZU9UKfQT0Ay6IWQSQ+0A4UB4w75VNa9pIelbFbxy0E45CLIFtH26Zn+Otom78Nt5Ru32sxkqjAfJZ9rk4V7F9r+nY63giiO/fkG5KlczI3hlVTJFxBUDygtS4780vZ8dVoZ+A37Z+/tTDL0IK1GhZvzYo4mNM25V
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2026 15:09:54.6309
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a65c9eb-d9cb-48cf-a646-08de8f3790d6
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D12.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FRZPR08MB10903
X-Rspamd-Server: rspam12
X-Stat-Signature: tud3of55jrki436ux5zcbw3c9j4qfuyb
X-Rspamd-Queue-Id: A55671C0005
X-Rspam-User: 
X-HE-Tag: 1774969801-277508
X-HE-Meta: U2FsdGVkX186HnujgHUQ8bxFjlIKGhO30w+y0E6gPNGFT8a6nuUHGPv2SlEjs4SDHtoM8sh9Ug6OGVC6HTyJuqlIivGOTWuizvwquYM/JNz2uKc56Hm31zq4W0sGNjbf0mr+WB6VRj2hjvcp91+CUVDE+hssQqdBfqkxg4tx04gvMhSuxt2vwBsOjokGmxfGvA7R6NWrOJUz2KYirgz92YT6KFrMETj0gS7z8sj5d0PMWtXmeA+yKQbkgFbpC4Wln1jnUabz406cNr4hq3e9EWr1PW+ggCP1f7EmRjjs9JEKRwWlCryAwvpHj25BqfPu2YFMiX3ejkCXiHbsG8nzK+LkBs5IQqN3TirWuRj6YonaiJOdwsyJZeBR/JILJib6Oznqb1Nkoapg71KVHRjBf4my4nEsnEck6h4P4c1j70NhgMI1a1hUUYz006TL7zg8pARr/WaFjP+4D4QvU4qdL89I+HrLpOOcKLQ39LUxeYmMYbuY4I69uH7SQrgK7hAJ8iqjOxjDFYpr5gau4lOLCMMvAQA/vujXiI6IaApPbhyJ0DsJJAkEx6OgpynISCAi5fRr2Ow2ireskoKwjrCQIY0ue7j7dkxyMxVQkUuirPzbfvNxnO4niAh+QfK0b3NNiOnxNO9J4VbQ/aKLp1Y6N4HisOy91OvARvnWuX0otSGabaiuQiACYgfVmMK1QAHvORXNOlmC368i96VpK/bm46+FBfeCmwxQ5SREVww9RWlx4ElCPA1soBVcUKop2mEFAWvMGtCz5jZbIuoc7tLHRcCsvQNSt4dFYkMYKLIPN05dkN3WSHD8K7TbPR4OGSjTcnVJT1pthH1AtUvbKXHtBnox0GOn7lzJzM/sFkxnJ+8VfBoDu6bpDRJsTvg5ONedY6hdfbe5rzinscUY6kiOgKK513tIe9eZeIAFL3FmyaJGbhHULKfqmjufkqyGNAho58yD8Am7yd4E/MTGnMm
 fDOZBRKP
 A6vqt4Sn+K/Rl8L8PgQ1oDBBPixKBVyQsYnq8RAX5KKR/BJjnU41xLP+hhcQhriESa4mQnKrkrBancRyKhMCqguSvTsehuZxrGR4lA4pFE2XPw8UVAF0OI4RMIH3PXS6Fdu83ymR9y9pvHXhBzFHJzp90e+NTDKhWuGIlWwCeIdB7L64T/3yN8tp0eWOXud+Czl3ciMrpBEwQpY0bJwap9GCulpXpt+/G2+hPd9krRQMUuHNPB12Qn3ZJ488HgY/vkB1TtlY406AOs1KBso7+OdzXtngptcEp731K9x+6r2c3cK/k4CPNvwckv9GzE/C/MsHSLbMO/pJb2IGKK8XBqSiKKaqfnR/YBeMKR2tIMwKzrMB6D0/bp7gcXKnZ1utAGIDgpFcz6ECGdmzH6Utz7MsROVEJStpiPAuLAhsaM3qe2lRWScE4gByPYwfLKv6CpV5rjs9g8Ec9QkCXrr7p33sxIbUukdWyvwMZz53+wge1yJnI+vNfvK9wDvXitB0f3mD6JAcQxF2L0Gpfba0+/89CbxXFhEqwXgX0ZOaZzrpSogn7/VOJu8dvVSuiuzTFKaVvhO9DXmuJ6yBpIrKG6hW5M3ms08Mtx43GB61elqhT8nld9sg7LRXPvsAwxVMNrErJN8hK7bBMoJ5uQwl9xQccKYL3qmxqspm44pwNKn9m0ts=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 30/03/2026 1:30 pm, Uladzislau Rezki wrote:
> On Fri, Mar 27, 2026 at 12:57:14PM +0000, Muhammad Usama Anjum wrote:
>> From: Ryan Roberts <ryan.roberts@arm.com>
>>
>> Whenever vmalloc allocates high order pages (e.g. for a huge mapping) it
>> must immediately split_page() to order-0 so that it remains compatible
>> with users that want to access the underlying struct page.
>> Commit a06157804399 ("mm/vmalloc: request large order pages from buddy
>> allocator") recently made it much more likely for vmalloc to allocate
>> high order pages which are subsequently split to order-0.
>>
>> Unfortunately this had the side effect of causing performance
>> regressions for tight vmalloc/vfree loops (e.g. test_vmalloc.ko
>> benchmarks). See Closes: tag. This happens because the high order pages
>> must be gotten from the buddy but then because they are split to
>> order-0, when they are freed they are freed to the order-0 pcp.
>> Previously allocation was for order-0 pages so they were recycled from
>> the pcp.
>>
>> It would be preferable if when vmalloc allocates an (e.g.) order-3 page
>> that it also frees that order-3 page to the order-3 pcp, then the
>> regression could be removed.
>>
>> So let's do exactly that; update stats separately first as coalescing is
>> hard to do correctly without complexity. Use free_pages_bulk() which uses
>> the new __free_contig_range() API to batch-free contiguous ranges of pfns.
>> This not only removes the regression, but significantly improves
>> performance of vfree beyond the baseline.
>>
>> A selection of test_vmalloc benchmarks running on arm64 server class
>> system. mm-new is the baseline. Commit a06157804399 ("mm/vmalloc: request
>> large order pages from buddy allocator") was added in v6.19-rc1 where we
>> see regressions. Then with this change performance is much better. (>0
>> is faster, <0 is slower, (R)/(I) = statistically significant
>> Regression/Improvement):
>>
>> +-----------------+----------------------------------------------------------+-------------------+--------------------+
>> | Benchmark       | Result Class                                             |   mm-new          |  this series       |
>> +=================+==========================================================+===================+====================+
>> | micromm/vmalloc | fix_align_alloc_test: p:1, h:0, l:500000 (usec)          |        1331843.33 |         (I) 67.17% |
>> |                 | fix_size_alloc_test: p:1, h:0, l:500000 (usec)           |         415907.33 |             -5.14% |
>> |                 | fix_size_alloc_test: p:4, h:0, l:500000 (usec)           |         755448.00 |         (I) 53.55% |
>> |                 | fix_size_alloc_test: p:16, h:0, l:500000 (usec)          |        1591331.33 |         (I) 57.26% |
>> |                 | fix_size_alloc_test: p:16, h:1, l:500000 (usec)          |        1594345.67 |         (I) 68.46% |
>> |                 | fix_size_alloc_test: p:64, h:0, l:100000 (usec)          |        1071826.00 |         (I) 79.27% |
>> |                 | fix_size_alloc_test: p:64, h:1, l:100000 (usec)          |        1018385.00 |         (I) 84.17% |
>> |                 | fix_size_alloc_test: p:256, h:0, l:100000 (usec)         |        3970899.67 |         (I) 77.01% |
>> |                 | fix_size_alloc_test: p:256, h:1, l:100000 (usec)         |        3821788.67 |         (I) 89.44% |
>> |                 | fix_size_alloc_test: p:512, h:0, l:100000 (usec)         |        7795968.00 |         (I) 82.67% |
>> |                 | fix_size_alloc_test: p:512, h:1, l:100000 (usec)         |        6530169.67 |        (I) 118.09% |
>> |                 | full_fit_alloc_test: p:1, h:0, l:500000 (usec)           |         626808.33 |             -0.98% |
>> |                 | kvfree_rcu_1_arg_vmalloc_test: p:1, h:0, l:500000 (usec) |         532145.67 |             -1.68% |
>> |                 | kvfree_rcu_2_arg_vmalloc_test: p:1, h:0, l:500000 (usec) |         537032.67 |             -0.96% |
>> |                 | long_busy_list_alloc_test: p:1, h:0, l:500000 (usec)     |        8805069.00 |         (I) 74.58% |
>> |                 | pcpu_alloc_test: p:1, h:0, l:500000 (usec)               |         500824.67 |              4.35% |
>> |                 | random_size_align_alloc_test: p:1, h:0, l:500000 (usec)  |        1637554.67 |         (I) 76.99% |
>> |                 | random_size_alloc_test: p:1, h:0, l:500000 (usec)        |        4556288.67 |         (I) 72.23% |
>> |                 | vm_map_ram_test: p:1, h:0, l:500000 (usec)               |         107371.00 |             -0.70% |
>> +-----------------+----------------------------------------------------------+-------------------+--------------------+
>>
>> Fixes: a06157804399 ("mm/vmalloc: request large order pages from buddy allocator")
>> Closes: https://lore.kernel.org/all/66919a28-bc81-49c9-b68f-dd7c73395a0d@arm.com/
>> Acked-by: Zi Yan <ziy@nvidia.com>
>> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
>> Co-developed-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>> ---
>> Changes since v3:
>> - Add kerneldoc comment and update description
>> - Add tag
>>
>> Changes since v2:
>> - Remove BUG_ON in favour of simple implementation as this has never
>>   been seen to output any bug in the past as well
>> - Move the free loop to separate function, free_pages_bulk()
>> - Update stats, lruvec_stat in separate loop
>>
>> Changes since v1:
>> - Rebase on mm-new
>> - Rerun benchmarks
>> ---
>>  include/linux/gfp.h |  2 ++
>>  mm/page_alloc.c     | 38 ++++++++++++++++++++++++++++++++++++++
>>  mm/vmalloc.c        | 16 +++++-----------
>>  3 files changed, 45 insertions(+), 11 deletions(-)
>>
>> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
>> index 7c1f9da7c8e56..71f9097ab99a0 100644
>> --- a/include/linux/gfp.h
>> +++ b/include/linux/gfp.h
>> @@ -239,6 +239,8 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
>>  				struct page **page_array);
>>  #define __alloc_pages_bulk(...)			alloc_hooks(alloc_pages_bulk_noprof(__VA_ARGS__))
>>  
>> +void free_pages_bulk(struct page **page_array, unsigned long nr_pages);
>> +
>>  unsigned long alloc_pages_bulk_mempolicy_noprof(gfp_t gfp,
>>  				unsigned long nr_pages,
>>  				struct page **page_array);
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index 18a96b51aa0be..64be8a9019dca 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -5175,6 +5175,44 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
>>  }
>>  EXPORT_SYMBOL_GPL(alloc_pages_bulk_noprof);
>>  
>> +/*
>> + * free_pages_bulk - Free an array of order-0 pages
>> + * @page_array: Array of pages to free
>> + * @nr_pages: The number of pages in the array
>> + *
>> + * Free the order-0 pages. Adjacent entries whose PFNs form a contiguous
>> + * run are released with a single __free_contig_range() call.
>> + *
>> + * This assumes page_array is sorted in ascending PFN order. Without that,
>> + * the function still frees all pages, but contiguous runs may not be
>> + * detected and the freeing pattern can degrade to freeing one page at a
>> + * time.
>> + *
>> + * Context: Sleepable process context only; calls cond_resched()
>> + */
>> +void free_pages_bulk(struct page **page_array, unsigned long nr_pages)
>> +{
>> +	unsigned long start_pfn = 0, pfn;
>> +	unsigned long i, nr_contig = 0;
>> +
>> +	for (i = 0; i < nr_pages; i++) {
>> +		pfn = page_to_pfn(page_array[i]);
>> +		if (!nr_contig) {
>> +			start_pfn = pfn;
>> +			nr_contig = 1;
>> +		} else if (start_pfn + nr_contig != pfn) {
>> +			__free_contig_range(start_pfn, nr_contig);
>> +			start_pfn = pfn;
>> +			nr_contig = 1;
>> +			cond_resched();
>> +		} else {
>> +			nr_contig++;
>> +		}
>> +	}
>> +	if (nr_contig)
>> +		__free_contig_range(start_pfn, nr_contig);
>> +}
>> +
>>  /*
>>   * This is the 'heart' of the zoned buddy allocator.
>>   */
>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>> index c607307c657a6..e9b3d6451e48b 100644
>> --- a/mm/vmalloc.c
>> +++ b/mm/vmalloc.c
>> @@ -3459,19 +3459,13 @@ void vfree(const void *addr)
>>  
>>  	if (unlikely(vm->flags & VM_FLUSH_RESET_PERMS))
>>  		vm_reset_perms(vm);
>> -	for (i = 0; i < vm->nr_pages; i++) {
>> -		struct page *page = vm->pages[i];
>>  
>> -		BUG_ON(!page);
>> -		/*
>> -		 * High-order allocs for huge vmallocs are split, so
>> -		 * can be freed as an array of order-0 allocations
>> -		 */
>> -		if (!(vm->flags & VM_MAP_PUT_PAGES))
>> -			mod_lruvec_page_state(page, NR_VMALLOC, -1);
>> -		__free_page(page);
>> -		cond_resched();
>> +	if (!(vm->flags & VM_MAP_PUT_PAGES)) {
>> +		for (i = 0; i < vm->nr_pages; i++)
>> +			mod_lruvec_page_state(vm->pages[i], NR_VMALLOC, -1);
>>  	}
>> +	free_pages_bulk(vm->pages, vm->nr_pages);
>> +
>>  	kvfree(vm->pages);
>>  	kfree(vm);
>>  }
>> -- 
>> 2.47.3
>>
> LGTM:
> 
> Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Thank you. But as the implementation of free_pages_bulk() has
changed to using num_pages_contiguous(), I cannot take this tag.

> 
> --
> Uladzislau Rezki

-- 
---
Thanks,
Usama


