Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EA14C53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 14:23:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EEAC6B008A; Tue, 28 Jul 2026 10:23:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29F846B008C; Tue, 28 Jul 2026 10:23:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 167566B0093; Tue, 28 Jul 2026 10:23:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DE15D6B008A
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 10:23:30 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 628D240391
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 14:23:30 +0000 (UTC)
X-FDA: 85038403380.13.C63EB0E
Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013046.outbound.protection.outlook.com [40.107.162.46])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2455D40010
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 14:23:25 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=A0fxobD0;
	dkim=pass header.d=arm.com header.s=selector1 header.b=A0fxobD0;
	spf=pass (imf17.hostedemail.com: domain of Usama.Anjum@arm.com designates 40.107.162.46 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785248606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DIc2UoDth2FewdCnIyWL6YZwuLkZgksFv0+0U/SuZsQ=;
	b=5mNK/IFYo7MCegxtgb+owNnLfhml5YNo1UYd+5NJloLRNiWIi1EZLXPuCdHXFpz7hmAZPX
	+9gB+jf/Ol+19MpO9alDeACKT0mwB0cAaNgjz4+3mvNFW+QBVp2lccad7vdvTESw4UGUUD
	MFuhSTKrdJlLzPMIf2oY9hJUgDk4+lY=
ARC-Seal: i=3; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785248606;
	b=lYR3miqXMELTqSGUHVr4mZ9ZTPvNm6quAH/v5c+GXkhk1OM87/ElwytowdwLTPI+H09OsQ
	aWH5Z13P1GpJk/T6MzXSms7a/W31vk7MMUYhRignL3ITyImDyAlEWISHzudVb6RFr9mYOL
	EgW/WRYU2lhL24VlDkJBVRa7x1/ZYcs=
ARC-Authentication-Results: i=3;
	imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=A0fxobD0;
	dkim=pass header.d=arm.com header.s=selector1 header.b=A0fxobD0;
	spf=pass (imf17.hostedemail.com: domain of Usama.Anjum@arm.com designates 40.107.162.46 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=q2xNrA5yX4nwCdp69BXzdOQCvY9Lf4cOchjVAgMbS3XU463yy6/WqO8b9Vezl0s0/VuCPXGH4yI1o16E8nz7txXGTEUFBN1OYKjlazmvJfwJ6JRywO2ERVZTzZWR4+wNrlywJ3a0pnFcbJo2Jeyov3Ormax/EOVJOeb+v/pxIEEfdksXQs8d5wkAdHHJMhhCpxXJzA053KNeT7LuilMHNo3jr+FRwudcFIWtIXIsvJUUAhu9/WFkIZAP0pVR0+NppsE3cEA8HaU2D4L1KurXPIcCz6gkR+B1r7qThZfSoqVxXwWUKM4iBmLzRjDELzY76FdkOkbFeaVwhdZLmP+8Lg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DIc2UoDth2FewdCnIyWL6YZwuLkZgksFv0+0U/SuZsQ=;
 b=vqsoxx7omPbiGAC7H750wWNrQCoaCt1yvDw3IXm/dWWPZPkIbZ5WG1gacqmiaOA5yPnu0bUmPzGM/+XeZtaTYS0i94Jnib3ksETMveXmsMzyBlJtmEaoIHeaSbWE7U0hYGGjc7TC3iT9oAf/fjTQATiSWtBGxyizfTsFmhDfDJnYA8d+6En4nHbJe/szJV10mY2B3zOTa/U5n4zkvrcAqgYLBNVkcPalN06vyvoCOAGcth8o/xzoTPgzWoB9mmXj0XPJIVqPiy+s8UXB2kqfyVXMoraLoNlWNkCodTMO0pwCuGYIKSrqT7dT1W5PKWnpcRjAfDUNquj2gSNCS2Q1ow==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DIc2UoDth2FewdCnIyWL6YZwuLkZgksFv0+0U/SuZsQ=;
 b=A0fxobD0SyvIvpELlPGGZCV9aad0mR2gAVT+IkkF99A3BkSxFL2Z2Wyo1HE0lHpd6tRZ6cft1QKz0pAgLqDSCFn2/OwwITMWtz4yis3GdDeab/BSiVa1g+MobYI3b76vPJAgMHLY4hQBNXzCvOqm94dtOlbvFvCWRJbPM/B3p9M=
Received: from AS4P191CA0051.EURP191.PROD.OUTLOOK.COM (2603:10a6:20b:657::23)
 by DU5PR08MB10468.eurprd08.prod.outlook.com (2603:10a6:10:527::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.12; Tue, 28 Jul
 2026 14:23:21 +0000
Received: from AMS0EPF000001A3.eurprd05.prod.outlook.com
 (2603:10a6:20b:657:cafe::18) by AS4P191CA0051.outlook.office365.com
 (2603:10a6:20b:657::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.12 via Frontend Transport; Tue,
 28 Jul 2026 14:23:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF000001A3.mail.protection.outlook.com (10.167.16.228) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.5
 via Frontend Transport; Tue, 28 Jul 2026 14:23:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iPSyUSe4Vuhg6MlzfNj8iwXF5p6DeCqYiPM25/ELWElIqbaWQVr++vDSGCXnYUtNdG7VCYfAbzHnWarNS55405BD+3tSnpQwe2zJIq8SaqcsFlkUkS8Ld+FeRPr8Pjm+ZpC7A6mipOEne6SmWN28rdZt4p6e3y3UFizgv2HNcyA9wSG8dFjI5rYHLTcZOZDhTHBNyXFCAnTVzGeERNQq7gc/s7neLsngb9CaFsGUlAbrFC98PsZ7O2bMV2Hhf9MpFgKC6wYyw8nQgcTckAoqdvHz9Iqe02UgueQ8xJETwV+gXLZyQ8jupC8coQtQg17E/rv6kpaAdagWBAVZbujOzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DIc2UoDth2FewdCnIyWL6YZwuLkZgksFv0+0U/SuZsQ=;
 b=B/gdY68lurbQNv5f1w3UF/SYorxNngK9kZXGhvw/g0eV2y5vl4SBXetAPfzEWlemRpkZJfxz2EObNJdiZTfGt9Irq6sXUS4ujGUnOGrmtJBV5czHvtZBKE9iCDRkvs3t0A9E5Gbayzx2HJCFM9RiWOGRDc3VdgpXBJPCAi6gTA/mYNfPEBB8OsVXacqJTtBaMOwtCMihmZQR83kt4gTEHw5HFQZNpuFATjikucHz7vVK8nEcWb9QtsPVAYD2LgsTIUhBiqYQNOcZylDxsUmLHqkO/UpwJJg6xj/ZfoOtdO8r5NMfVOcG1RloMch/loCVJaB7uoLXzBbfPLxLULiWew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DIc2UoDth2FewdCnIyWL6YZwuLkZgksFv0+0U/SuZsQ=;
 b=A0fxobD0SyvIvpELlPGGZCV9aad0mR2gAVT+IkkF99A3BkSxFL2Z2Wyo1HE0lHpd6tRZ6cft1QKz0pAgLqDSCFn2/OwwITMWtz4yis3GdDeab/BSiVa1g+MobYI3b76vPJAgMHLY4hQBNXzCvOqm94dtOlbvFvCWRJbPM/B3p9M=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com (2603:10a6:803:80::16)
 by DBAPR08MB5830.eurprd08.prod.outlook.com (2603:10a6:10:1a7::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.12; Tue, 28 Jul
 2026 14:22:17 +0000
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4]) by VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4%3]) with mapi id 15.21.0245.012; Tue, 28 Jul 2026
 14:22:16 +0000
Message-ID: <9a289152-70c1-4e13-a0d5-f77bdee72d8a@arm.com>
Date: Tue, 28 Jul 2026 15:22:14 +0100
User-Agent: Mozilla Thunderbird
Cc: usama.anjum@arm.com, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>
Subject: Re: [PATCH] selftests/mm: unpoison pages in memory-failure teardown
To: "David Hildenbrand (Arm)" <david@kernel.org>
References: <20260727095415.385026-1-usama.anjum@arm.com>
 <a811c371-ef3d-4932-a9d4-2390a98e1382@kernel.org>
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Content-Language: en-US
In-Reply-To: <a811c371-ef3d-4932-a9d4-2390a98e1382@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO6P123CA0053.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:310::18) To VI1PR08MB3421.eurprd08.prod.outlook.com
 (2603:10a6:803:80::16)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	VI1PR08MB3421:EE_|DBAPR08MB5830:EE_|AMS0EPF000001A3:EE_|DU5PR08MB10468:EE_
X-MS-Office365-Filtering-Correlation-Id: 73a92e6b-4a86-4eec-8230-08deecb3c70b
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|7416014|23010399003|4143699003|10067099003|6133799003|11063799006|5023799004|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 ndCiT5ehRrhWhMLrXWNQznr2POOQhzkBWSSv36G0sh4sGbjTJds44OPvVRr+nsi4WM76ka0jtupnEn5YF3npyv1I1vP9Ii+Q4IrwNYyLaPmh4/nSaXmleoUtPboHvbkKAafYsHR9JrzMiRdbXLInn52s+C/JzW0/4yRCeh9X4o0edMUhu1DL81lHe8hWhQ5YZo8VsBD4sDEwamrgKAEM62jWD0s0SU2jY8okPuWQ6s2IxKz11aHt2VN708AupLSE1O7qX996XZS/gYJkfMjdBKevVr6YuCb313Q4W/YP0AoH8zrrX5pwYwibmnGdcHiJaODG2l5vSiCGKusYnF+vY6DtdDbQPCOrX8bNVHYZ+RUveXXuHEsBLXnXLUrrlIYfnl1reg9gGeIcqTKOCq9Via/i7EEdeqoyeFUM0ESYNk8gjN6vyg3HF4xX1Y/PeuNTtGK2gUNDT2pX8SPYrF8bZKvcxs247onb0sGxBfWBJqHdFesEBOunsqfsccJfiA+PbK+M0JFjhTVTRql94c/qctIkwEUyN1ZWuEv2WnSv93t0Q8zbTgg8dbVnzl8mFgW0OiQ/uoePkgjY8hhl6nfB5QmgN+Pw1Xk3e84d80DdHAl4yoOxJafOvgevR5DfuE3nS/s0iEI8cargCgghZ0tWUjY2ncfZerOgl7D9PRMS/0g=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(23010399003)(4143699003)(10067099003)(6133799003)(11063799006)(5023799004)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 amDKxWEu/syi0cqdNatVwTgWXcb0qu45tNKhXz2IbExKvXZqlKx1pUV0XcJCI4YBKYb6QAydSbL4HaBIBg/E+P0rGNRsDA30XqIj9LJB5BY6zxtyLJS5VOlovHKwbHO1vwviAEBkTk46mW9ezfgdxgfkwMf/uvGTg6xxu8AFT68LkzeLKjkcE195FFxQMzIClgkKseJZtn/emFiXKJl/qE5F1sY2vfjZSiO4229kFZwNHBFBKYlS1aRu7qgaHZtCAR1Mz0W37c63qWFq3AbdaigABr4os45v3mSxwhYBMd8N2hsJ8ftBAg2Meod0B03pAToTk8V+qgYyStZWr4ytzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR08MB5830
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF000001A3.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	1798c20f-5ac6-4f87-ecbd-08deecb3a00f
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|14060799003|1800799024|35042699022|376014|7416014|23010399003|36860700016|4143699003|10067099003|6133799003|11063799006|5023799004|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	ECrpUlh3f6E5xf38JiT03ACLxZO5RWKhnhaUrlLu7F1XqDBXVEM7ENZa/g0ioHatuTN3XklNAzSAZaNWzDoxnoY1vyKBFC982dNzYRmQBacIsoS8F06M/sYILoqwjPP1AhCCgZiDaQ72YigZdCPKKs4FOrSyvXnfiiB11C/Qu2ETK+k32JyKVnDH9zzxqVKrFEoiS0ISggKE8xyTjKUg49a7fEMWOgAImkfZljqyLpPZThnPMWAQUjii81k9N7usCcWNfVIQsLoOABzy6HPuhgVQYlnbdgOADaA6nyc+PTsfp8SAy88O6Wy483Z2WAarXmU5oWj4EQobRutPW0KPj7bUedN2MWF9QzM74Hqo3Dzcm+jnKTi7+hDoQBUkLCJ3NH2tJMiHQpVY1Fhp7Q7vOIzQopHFGNQn5G7/8SsXIr2e5PgoKtkrbWl1QC5jTHhSucMNGORxOYeUFi4eyNPFNJdl+BxoVQEKUmvvpttE9pX51gGSrZ1Z68SQfJldfCoYjEqCClWCuySA5v+CNJ/HzJAUR5XRnFlBTBThl2tZOK7xVEHefEltJNh+mYPfz1UEO99OWJiPe/B19msLPrmbxspOKdwTn9MkhY+w7BcODF90kejLTE4JXiVnusK0ixKVuJ3eBaF6/LWHe/UQ5yZT1IikwvbNYVSxi8BfYr3vWd0nw/pAeae+4o5UUQ1t1BUfeKKnU2pxImc+UR/P+vUeDw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(14060799003)(1800799024)(35042699022)(376014)(7416014)(23010399003)(36860700016)(4143699003)(10067099003)(6133799003)(11063799006)(5023799004)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	4/LxOeaFRA1CnLGFEeTeaIg49CD3AUOqoTH/Kg9cGarC8O5DZWj+nJ1H1uKOjPvfrRf/9tn1G6dG4n4orBcejkvbCnfw4TcTw7diq5QGlo/qCu67FA+YnTf5A/UPkyMG4g5XO2/esNEF9Gz7a1fMidHDtU9qhTvl+4ROWo0FNHsI3nTCeeWHeoVltImixacklzx7/50sBBe240ai0wJxXgYV6hQnz7vDmgnO1XjY4WHTXWzxirHlSwjbDWBVFABc/x4l9FzIomHDREiPDxej1nHq3UXwQN1V+lPYKxjUWX77yxy5qtiE69cDy5waQDAzY4C8qhKRrb0ZzFrt3wlXOJzoAp9BnkC+mVN5hLEENbz5OrB+BzNMVTzlCrolM2mhLgH6/7Ost0v3Z898G+kkUynBKKS9nGhizpT0KowG4vtyyevEZRAKyKsZ3z4hNgIX
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2026 14:23:21.4848
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 73a92e6b-4a86-4eec-8230-08deecb3c70b
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001A3.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU5PR08MB10468
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2455D40010
X-Stat-Signature: m1kcfsozy1h8sfuyuawr6kpxizsbhsci
X-Rspam-User: 
X-HE-Tag: 1785248605-60489
X-HE-Meta: U2FsdGVkX18tybXIUZCG5bPXRz+YV6SkecxVtZvfAwP5V33y5Th0wnFFU0ughUO67eKt++IOtJHiv0MHmC93kGH8YumGHowYAILbrsS+lMF0tXF80+1Ic6o7ScyBITAlCpOA/PuXDdLwTF+D2MeK6rLM1M/Cs6q8gMuOgYRLJEmRUeLdgKfDncT79MAzJa9AeOkbo1bq3uB6k0+OXCzx+cxfBBlqVNHjMf133f0KfK7fqeHKDHu0U9q7PdpE+ceNBLsjCC5+pZcH3H4lO2L/Qcij0Ia6vfnLE5aSAurMMkg9Z/uCPxfqw8pXtjYFRjuUYEj4MpFplZbxvEE/67ysywWqELQ2DZtNJ66ajY/mkkwJS682Xwgy76sIIR2r+I2l2HPrQCsvCIxCqEnOd2ielDTXYVgA19QNNc3gX3hknIP3EiKp8aXaRjsqM4q0F9ixAnDov0lVzGXZ9zIyIfWcNVqR1PBxaOQ84yg93988b9zC8V5GR785M4dBpqTcDoSEwSg64roTQIABOk2k2OiNV5RK/B4SZpEUPQ8N/urUP5EWYF+XkFvFR3/94+oBS5RuQDxDLAOZED6jshdhgwLgVyuAd6n2HxQYg6svzqnk5PZJlqRx2XNEIKmCZ6wXkwc1KUjLLYPz/3FeiyTtKlgd7ri0SIPCufy4tWOHTK4nH/SGeJk82x1+nhNZIqe5jtwKj8/aTq3yMhlkverPrmoyddJMxalrfNxyqg6Tfg7+pbisW06zVuSCDFz8tzv9zXdkONPD3Cku2AqsR1kt//aj+Zn1ppOAjmAHP+PtOpn6z+e2N/pJVkV2AUaFR9yNwCd/4g/Xt9b/dx7B3GU/AptJfkkl734lOxeRUn0hbWj183sjy6BgwnOLz5dWyWTqcF9e1cR8tIhk/VWYCUqo44kJpN4wtkYJg2Ojo6dvUe/aSeCjAAQztHu3nmOtc+FbaC6Q+vnhAKdzEbvvix0OJg2
 Uj2Te3/8
 dFJ+9Gs3d9JMPMCNwo6XUlkb749+fxkHue6cDvO11ffBlhLE7NFr+FhBiqhgQvJEhBuVCx4uBEHi0g2npd0a/W/whSF38nkdACszpLRN95oldiObIMSEfx/f8uSAxPd5BgnFoDCRFRfsGS7b47WXpdBeVWdK3PRZdHhGAyGG2+RQPu/gmwkEqrKtIE6g3tpj4SrN8JGxx6MF7vYgqLQJRWY4ZpUg/gIGWSluwln8jUUNXHHbKQWDSFGz4JdihkoZ8Cl4nP+5EnCEC2ZOHzkaoMnHpuejvf2F/5yrvwbErM5S8iXA4MZzbkgeqCflqK+UA4G0txFJULw4ZMH+K2muFIwqDCCNxNEGveM0u/daSe239NIGNJx5crL+v9WOZpVZPbiB7AH1iLnOQqczIEA+8oPfPUg6Cp+5JPnWboUx+wE5gA+t56ET1gOPZXkJCAHd6684T5PtXsCDdWchBC+mLp542aBbaUM/9LpFuXM/JqSCET2VOVau1vlFqOvmS6s8wWBeKxc6yckOjkV+fzDp9bQD1NAKoZaUeP2bZsUc9OfiL3lGSQBW3WJcfuuaF6p0o+Q5PijJDwl/drPYvh5FuXZtobmcGKSXUbHazFNvJr0q8GKs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27/07/2026 1:31 pm, David Hildenbrand (Arm) wrote:
> On 7/27/26 11:54, Muhammad Usama Anjum wrote:
>> The memory-failure tests call cleanup() only after all result checks.
>> A failed ASSERT_* invokes fixture teardown and aborts the test, so it
>> skips cleanup() and leaves the injected page hardware-poisoned.
>>
>> Invoke cleanup() from FIXTURE_TEARDOWN() instead. Guard it with
>> self->triggered so tests that exit before injection do not try to
>> unpoison a page when no injection was attempted. This runs the existing
>> HWPoison and HardwareCorrupted checks on both normal and assertion-failure
>> paths.
>>
>> Fixes: ff4ef2fbd101 ("selftests/mm: add memory failure anonymous page test")
>> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>> ---
>>  tools/testing/selftests/mm/memory-failure.c | 26 +++++++++------------
>>  1 file changed, 11 insertions(+), 15 deletions(-)
>>
>> diff --git a/tools/testing/selftests/mm/memory-failure.c b/tools/testing/selftests/mm/memory-failure.c
>> index 5d00aab31f9b5..eaa8b9bd401a1 100644
>> --- a/tools/testing/selftests/mm/memory-failure.c
>> +++ b/tools/testing/selftests/mm/memory-failure.c
>> @@ -122,13 +122,6 @@ static void teardown_sighandler(void)
>>  	sigaction(SIGBUS, &sa, NULL);
>>  }
>>  
>> -FIXTURE_TEARDOWN(memory_failure)
>> -{
>> -	close(self->kpageflags_fd);
>> -	close(self->pagemap_fd);
>> -	teardown_sighandler();
>> -}
>> -
>>  static void prepare(struct __test_metadata *_metadata, FIXTURE_DATA(memory_failure) * self,
>>  		    void *vaddr)
>>  {
>> @@ -200,8 +193,7 @@ static void check(struct __test_metadata *_metadata, FIXTURE_DATA(memory_failure
>>  	ASSERT_EQ(pfn_flags & KPF_HWPOISON, KPF_HWPOISON);
>>  }
>>  
>> -static void cleanup(struct __test_metadata *_metadata, FIXTURE_DATA(memory_failure) * self,
>> -		    void *vaddr)
>> +static void cleanup(struct __test_metadata *_metadata, FIXTURE_DATA(memory_failure) * self)
>>  {
>>  	unsigned long size;
>>  	uint64_t pfn_flags;
>> @@ -217,6 +209,16 @@ static void cleanup(struct __test_metadata *_metadata, FIXTURE_DATA(memory_failu
>>  	ASSERT_EQ(size, self->corrupted_size);
>>  }
>>  
>> +FIXTURE_TEARDOWN(memory_failure)
>> +{
>> +	if (self->triggered)
>> +		cleanup(_metadata, self);
> 
> If the variant->inject(self, addr) fails, self->triggered would already have
> been set.
> 
> Wouldn't it be cleaner to have a new self->poisoned that we set only after
> ->inject succeeded?
Setting self->poisoned after variant->inject() returns would not cover the
MADV_HARD signal path.

The call path of madvise(MADV_HWPOISON) is:

madvise() -> madvise_do_behavior() -> madvise_inject_error(MF_ACTION_REQUIRED) ->
memory_failure() -> hwpoison_user_mappings() -> kill_procs(BUS_MCEERR_AR) ->
kill_proc() -> force_sig_mceerr()

SIGBUS is therefore queued while the madvise system call is executing and
delivered on return to userspace, before execution can continue after
variant->inject().

The test's sigbus_action() then calls siglongjmp(), so an assignment placed
after variant->inject() would be bypassed. The flag would remain false and
the test would attempt the injection again after returning to sigsetjmp().

Also, memory_failure() sets PG_hwpoison before several recovery paths that
can return an error, so a failed injection return does not prove that the
page was not poisoned.

Maybe renaming triggered to injection_attempted is more precise here.

-- 
Thanks,
Usama


