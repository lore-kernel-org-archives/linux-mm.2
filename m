Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F52CD0EE0A
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 15:55:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C74406B0027; Tue, 25 Nov 2025 10:55:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4B6E6B0028; Tue, 25 Nov 2025 10:55:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B13196B002A; Tue, 25 Nov 2025 10:55:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9F8AC6B0027
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 10:55:49 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 455C2139F40
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 15:55:49 +0000 (UTC)
X-FDA: 84149580018.05.D531F49
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012030.outbound.protection.outlook.com [52.101.43.30])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4ADE11C0002
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 15:55:46 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=LQogSiBg;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.30 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764086146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HevUnDQYMgnaKjCkWFDyXY4jbGZEPPduFUdhYED9Si0=;
	b=b9K0EOrjXEOx/aICqCeySuoNjO3fEovE4G8vUi9VNkrCy7VCDiNldvDEG7Bw+kiVRgswhw
	yE++8F9wWAEa0TCv9QxJiHSLGWvLuSYwAGEpsl2a30p9RhB0hStW4XaWhh1fpUX2pSu7QY
	dpLEAF/Mn3XGo0E3C5yXfw8/CgJ0IG4=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764086146; a=rsa-sha256;
	cv=pass;
	b=5DS6f5pYz5x4GjEyRvIsrlP/tookrDxgBP+/n+BFF41Wl+vT8U0zAnULbF2GT6TkRvmP/Q
	0ObprxV0InFn8ZQPRpek29U1sYJ+b99iS6duKDRCEAb/khfRU7fIbROCzExV/4LnLWeG/L
	wee8gqqiTco6oIhzd+IY4T3dimlWIDQ=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=LQogSiBg;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.30 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vwxOqWYlFZeYPKq4U7+D/vO+YnfyvGLtqWWI70t7Uo8ExtK2dNtJadH4hQkq8qMi4+BnY0+U0Fdcr8ByciTypgztEOLLZYHuqZid9//V0A5gEqVcOzYTQuoTkqRJ5q2JO1p/qnQVBSoonxyIP1cm4UOkdVOIUGiPWqYPlD7l1VEFyFlEx7BUb+8bjZppjxIrqxxSz5vus5RjUQLQ0wTKWs7YBNXgVFjGYpNlg/P+PfY29+KIFlig27V/8bsjKlmLlxLqJJO7CZqqHn6WwETYOqqICwZtqPlQ1UkrzWC2NAZfgJy8WLdsumRY2vYVaf1hzIXVVSow21M5c9S7l/iGyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HevUnDQYMgnaKjCkWFDyXY4jbGZEPPduFUdhYED9Si0=;
 b=pkQ0Z0MC3tnTBe2NZ6bYJF+NP2ZC5gplkokzFAD2V+sk8DPE5wDGg/OCQ5XnYMswp6PkGg4FnSEwzqlYOCOtdd7JIcKDaLxetubHHvbk/+LV7DSZrugSl8hEM3cnOyw4dOwzMKWRiKEvrncfPDSDOxNZQCHW6eqLy9B/cS8U/+vZuzzb3DYLIMFawA37uNfYLMLPdd36tQcOPmEhmZ2YTxtvfISx5kclzs43Gl47b29CwxoB11KlzZ5cMwXApj++2Qp6wprn4QrFK53HschU79iw6tA2GEGLrIgC+zKEZzyBjHpK+EAFeIoKh3H/MxgeTuUIUoGsKOu4x1tWT7z+iQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HevUnDQYMgnaKjCkWFDyXY4jbGZEPPduFUdhYED9Si0=;
 b=LQogSiBgOzkQyoc9iOyk4q1hWV6iShV4fFmuIqzeQ3DkwInbYLjbXjxspSK/pioWNKUV03FsoCsVPbH5yTw5iCWVxhAf0KRY3rKJw8Me0qRZ6nLtoa2TGsOYJQFR+x+nzNPQgxlirvn7WpmNbcynpdexQb72OIHbjw0wgQVgghWMPSp5a2H3xDWiDbNKiowmJ41w6vmdCbyLgvLNqWdhnEbfwryPhtfXX2yUorOP4PLqg+OGjWDQ/t02J5DKN5ld9o5nfSEGBKpQI9/vOyAbOfeJivs3MxTvHiD+9DJ9yRxUg0ti2mPl50CEh99K7k+wz/yCcXRTciZcV0zZKqw8yg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 MN2PR12MB4320.namprd12.prod.outlook.com (2603:10b6:208:15f::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9366.11; Tue, 25 Nov 2025 15:55:41 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9366.009; Tue, 25 Nov 2025
 15:55:40 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Wei Yang <richard.weiyang@gmail.com>, Balbir Singh <balbirs@nvidia.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/4] mm/huge_memory: replace can_split_folio() with
 direct refcount calculation
Date: Tue, 25 Nov 2025 10:55:38 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <57E21FA7-7233-44CF-B67B-F24CDBA655C7@nvidia.com>
In-Reply-To: <2f708eae-7d4b-43b0-83f0-7c2d98b294e6@kernel.org>
References: <20251122025529.1562592-1-ziy@nvidia.com>
 <20251122025529.1562592-3-ziy@nvidia.com>
 <df92a886-069a-450d-a551-dbfc3f629ead@kernel.org>
 <33A929D1-7438-43C1-AA4A-398183976F8F@nvidia.com>
 <34bafd06-250a-4019-8b34-5ddeedea1cb3@kernel.org>
 <66C159D8-D267-4B3B-9384-1CE94533990E@nvidia.com>
 <2f708eae-7d4b-43b0-83f0-7c2d98b294e6@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: IA4P220CA0008.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:558::6) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|MN2PR12MB4320:EE_
X-MS-Office365-Filtering-Correlation-Id: adf8cc38-c6bb-46a9-580d-08de2c3b1577
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?d0JjTHhaeGl1R0cyUGxxTGdsUE4yekN5dldTbUFzbmcxc29uZnRVdnJQTWts?=
 =?utf-8?B?MFNzbnBVc3grdm9FS2Rhcm5pVjluMFRXbnV4bVNCTFhuSlJmVyt2dVNEMWFn?=
 =?utf-8?B?OHFFTUZ4QW9YVUxuRVVDUnM5TUxjMk1qUUR5S2tBWHJlaGx4MGJVT3R3Q0xv?=
 =?utf-8?B?aEliY2tpOXJqQXFMOGNDN3M3Z3ZBTWlMU1dzbytmN2dtTUNKNUNteEtGb0lF?=
 =?utf-8?B?bCtNTUkzZWtLQ0thMXNpVXlXdTZBdmxGeFh0MmcweVI2VHAwSlk0MzZ4ZlF6?=
 =?utf-8?B?MXFjOE94T29yaFZGN3dtc3NjVDBDVUgwNnR2RnhkaWpkTzV0cVRlV3ZOQUhS?=
 =?utf-8?B?NDA4czBkMGErNk92WERyNURhS1Y5MjBoNTFZQWY4bTFGRzJjZFN5TUQycGts?=
 =?utf-8?B?WEVvbzZmYnVTRm9xUDFNRWdwOTA0V0ZwQUpCZjA3Yzg3M0pMMmhPbFNySGdr?=
 =?utf-8?B?L1FNNXhGSmZMTkZ0TjhuRHpiQnJsK0dZZzcxZDE1b2dCSk5jTzg5WmtwQUVj?=
 =?utf-8?B?dkVVZk1iKzVPZkhNMnZFSmRjZzR4WlFncWFyUjN2WDdiak5xWFdqU0RtM2Vm?=
 =?utf-8?B?YmRxZ0MvMVpvRWhhZzZKcmZ3aThUbGN2cER1S2FOVXN0Wlg1aU9XWk9ZTnR1?=
 =?utf-8?B?WW5Xb2pRNVlieDZhS0JBTldpNFEwcW5rNjVJQXNncXJXZmhOMHRYM2craG5R?=
 =?utf-8?B?bXk0VU02N01yWndUTzdjUzhvMjVncVQ3TnI2bjVBR3NhRXR6RkdxVnk1ZUxa?=
 =?utf-8?B?R1MyNnZFYVV0TkZVbGw1cTJnUzZBQ0Z4bVlhY0dtVUQwUXc3YXRhZHByYmYx?=
 =?utf-8?B?dDRJdU1uVXptTzVIdERaQ2k5N0NZUFk3LzZhcXVnQzY3S3oyQlpHdEFlNFdW?=
 =?utf-8?B?SnFWc1diQ3QyY05NV0JtVGlxZHJyUitvM2JKdCt1UnBzK3ZOSjB3N25vbmZ5?=
 =?utf-8?B?SmJHUmxId3FKd3c5RGVzSHZHRDlLbVR0eWxCNXdydHVVUHp2NmQ0bjA1T0dz?=
 =?utf-8?B?V2ZPTUtkbzNNOWwyeWtQWDZtUDMvYUdhVHJ6RmZzcFE4WGx4c3dBQXZabm9T?=
 =?utf-8?B?Sm9sd0xVbWdEeWg3R3RSR1RsSm1QQmlLQmhkVXNjSjh3TUV6bS8rUTJtVk0v?=
 =?utf-8?B?RjdFeU0wNkkvTGN2K2o1bGlGSWNLdjZrbzdrWlVMVkdIQ250amloM1A1L2Zk?=
 =?utf-8?B?a0F1Ynh0SGhBd0JwMk5hdytUVm9XS1NWamFBRU92U21pNjRNL0RBM0xVYmx0?=
 =?utf-8?B?Qy9rcUNRejBKWlo0a3FHSWxldW9JbTFYb05yRjBtNGNuSDYweGpxVGhrNzB0?=
 =?utf-8?B?bTVXdmZaTW5zcDNEa0VYVHV2OGF2OFJ1dFNnZ08yQW1LK0RQQkRHMDZ1SlV3?=
 =?utf-8?B?TnZ2b2RBS1p1Ujh6UGNaUHZzU0xycWxGckNaOUdqQ0daOHgvQzQ5dnhmWWNF?=
 =?utf-8?B?Q0ZpTVJxa2g3anh5TnBDR0M4enpxbmZRWnRORWFRTjY1cUFtYnZob1BzVzI5?=
 =?utf-8?B?U1hqcTVyLzBMOUI0MFJkZitkV3k0SEFIb05MYmQ3c3RiaGFWcnl3eXRFeURN?=
 =?utf-8?B?eXFlaFkyb1JsVlNQVEZ5UjJTQVNydVM5QWVFQXlQWXppbXNCTFk4MVc1VXJ1?=
 =?utf-8?B?LzJFNVB6dUFzeGlZNkJLUnRZd0l0SHZ3cHNjQ1dkeXBSZGlqUXZ6aVVXWkNK?=
 =?utf-8?B?Wmc5dXVkSUZvYlVGRFBOQkxtdXZxQUF0THZXSWNONFBNQ09hNjNrQTAxUmNL?=
 =?utf-8?B?c0Q0L0NJT29RRzlYc2VscGRKYWh0T1h1WmFKbnF2ek90eWtxQWVSR1dVc0t6?=
 =?utf-8?B?ejdpcHBHVmFicndRekZQUGk0V3UxTWw3TTVXbk9pU1Ayd3UxMEdIQ2pVWWNK?=
 =?utf-8?B?V3lnTmZEY3BLaVBBVXZHYXZEeENGMXlIU0ordXlVSmFtaTlzaklzak9yNllS?=
 =?utf-8?Q?QtEhEGTqeyZJEQVxt21FIu6WA9iL5P4o?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NllQUWVyM1BhNFBveXFzdkRjYjFEOEtsN1J2bUcrRmJ6WEhJN1RSSGJhUEM5?=
 =?utf-8?B?ZzROeW9XSzJkMktDalVDSU1yZkFvbExxeWtBdkUrb2N6MmRPQ1lpUVRMQzRV?=
 =?utf-8?B?aWJYTmtaN3d6VUpVWFZvMm9UYXFqQXJEdU42cU9VUVZBbTZ0by9KdkRiakhr?=
 =?utf-8?B?QVhUNEhkVXBlblpoRFRHeTVsalJLakFtYU1vUDJKWTM5d1l5VTlSYTFJdE9Q?=
 =?utf-8?B?a3ZoaU5pMHBPZDdXM2w4eDVIUHdmdWE1V3lBU29XTUR2UStLNU9oZ1oyMEJC?=
 =?utf-8?B?TjQwMnRrcHRTcE84d3dhRUxNVElNLzFOM1l2UkRkcVE1eGV4R0VPZFdLUnhG?=
 =?utf-8?B?T3BQdG9NQkdzQlhESVFSSkdZSUEyYkhmcW5vVW1PNWE0dzlXSjU4UEM2S1ll?=
 =?utf-8?B?MWpLUTFJaHRVWCtHamt4L0xKYUwxenJpaDQ2TVFzeTYvOWYwY2RvSmtnQlo0?=
 =?utf-8?B?aFRmUzJQMU8vc3ZHSDZBblFneXJ5SjFzS3kzaysyVUxjSzJRamdob1RyUGg0?=
 =?utf-8?B?b0lHaFdCeDIrVTJoNmpOTFRZcE5RNngyM1o0RDRweE9EYW5ZU3czREVEemN4?=
 =?utf-8?B?R3htOEV6Yy92L1I4aWl6bVZsd2EraTdBZGRQT2JoQzdSS2ZucytmQ2lRdU5U?=
 =?utf-8?B?MW0waUVvb2FUUWhvYXljb0wrL2dQc1FtQ0FnWWxQWGM3bngwc2k2QnFMUlFD?=
 =?utf-8?B?K1VWVXBnb1pMSG1GL1o3SXJTQm1kbkxJa21NUGNFNnBzbHpSVWkydzJIb2VL?=
 =?utf-8?B?cDYrclkzSXNuaUpEQUZ1SjNnQjJPRG9Zb1J2UnVIaXpOQlR3QS9uMDR0N3dq?=
 =?utf-8?B?VkdtYitwWlErdFJCWHlVVnB0OHFpYVN2YTByNFhrVXpQNFRpYVVGa0VGeFdR?=
 =?utf-8?B?UEUvVHBjb0wrbkF5cS81VlY4cVlJM1oxRGpDWmJQeTBIY0dVOTlsWGRRQTVQ?=
 =?utf-8?B?S0VrcGJxNUJsbUZtUU5OLy9IbFNDMU1VdGVkQmxmRWVjSTB4aEcxZk9PWG1T?=
 =?utf-8?B?MVN1L0dQb3d5TXl5aVVWTGlQM0cvemEwZWhtSjNCVXY3MlFhS2RFWUl0akZS?=
 =?utf-8?B?bFJzb3FJbDhrU253OWUrQUFlWmYyRU5NWDBxcS94SlYxV2M2WnpjbC9PWHRp?=
 =?utf-8?B?SjlINXJzQzF0cEd1NTNnajF5TmlwQkdzd1p2N1NYRmFBZmorWVRqMGs3OVJC?=
 =?utf-8?B?S0s3WFRhbGd0bnF6a1ZVbW9HdGtLWFRSRm9BUnpDWE9MdWN5TGdBcmdsdzZS?=
 =?utf-8?B?ZHdzTjNKYUJYdkZLT0x1MzZ1SVVQZUR1K3BId1ZGN1htNEFVd3cxaGs3Y0Zn?=
 =?utf-8?B?N2lKV01XTGUyOTNyelpuWGIvSVg4dmJaTWRiVkpkT0pHQ1BTcjFScFhKelN4?=
 =?utf-8?B?eUZiaHY3ZTFCa09RQmllRUllRjZjODhHblArMG8yWjFnMENUcDdMQVN2VHJ4?=
 =?utf-8?B?QThnY2VFTGFzZXRDQ1FGMllaYnRTUlJ6YmVXbEJPaE05NlJHOGwrR2liR01X?=
 =?utf-8?B?bW1iZ1FZZWF1LzRneG16SzV1OEpPQnBhQ1ZCSEF1QUNRNjFheXZmUlErT2dx?=
 =?utf-8?B?U3loOC9UQXRpNE9vMU91ZEJMMkd1SnQ2ZitBeXEwcGg0Y1FmY0I3Z2Y0MHRK?=
 =?utf-8?B?OThnZHhYaVpIaU8zQkc4T1JxZ3kzYTZqUENxYW1UZlpOamdPYlFTZmF5TnQz?=
 =?utf-8?B?RlMvUUtyVWdFMDY3N2tqN09FdnhMKzBSbHBjV1BtRHZMYUlHUVo1UUFSSXpa?=
 =?utf-8?B?ZzhjdXg2QjZEUXQzQTJ4eFV0RGdEN1NCVXNsOHNRb29Xcmphb0ZWTEk3Ymdu?=
 =?utf-8?B?K3lNaE9kRU94cnlvN29tSVJldUxqeUF4VXpsMWdmb2p1aGt0anJoSGliNHFP?=
 =?utf-8?B?eFRDWjV1VEp0bGo1T0wxLzRHamthTU1iZzNNck92NUhOcnk4SmVQQkxabW1V?=
 =?utf-8?B?UjhjcVpWZk5seTJKRDVRSlVFTXVIeTNUTUFzRlY5T0gwNHpNWnljdVB2eVhK?=
 =?utf-8?B?SENEWndLQmRsNlRJMm00VXJIYlp2Wm13UlZobjdFZ25rdkw0dk0rN25qdWtp?=
 =?utf-8?B?VkVnUnA4ai9PZ1RCL0RPbjJ3Q1VqR3lpYWZLcWN5UFZZN2V2Z2xqeUZHeVE2?=
 =?utf-8?Q?8tsrJh+GHeAkGEaMfbbzuQVRe?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: adf8cc38-c6bb-46a9-580d-08de2c3b1577
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2025 15:55:40.8964
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DFsc805GblSp0gDx7yUNtOF0qzeP2WIys5D06/7Tuakr+qE15cs04WiBg/S1zyWs
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4320
X-Rspam-User: 
X-Stat-Signature: hc58s7mozj7rgjeecb3bww17t4zy7pok
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4ADE11C0002
X-HE-Tag: 1764086146-257590
X-HE-Meta: U2FsdGVkX1/aaf/Q+bQwQ+F+NIS12SNRGQ4kaUl3rFAqGCSTS2YjAV3MU//4R4iLV+s8DXz5S5KHS3Y20tNatt4tFciHyd2g3PPCVUZltAif07/BXjK88Jkdc0dbF5wnuooQ5RvGu5StatfuDJ+b/aFCX6W3z9WkYqiQkHympZaA5dPyU0Pr4akUiuT+PCjB0wUYPjq9VhMePW8IE+H8YMMQnaBxSZS5wPqHq5TNwHZWskKXNe0rV9Y8xIfvaBhl0gI9e7nwuoMsJvVmvYITqZH3+Is8/Hll28lRW3FSIzic2GQ4Du5Ou19N0FUNBSRfQS63Bf2U1HIzXlN/X9VKpMV6LixXacsxeqahLYEd7wqwRS+4Yu8AeUUPpp6OCl1jOT4ZJ3DRI5y00DK+2L6Cm7SUDvYCCzrosCebt/JOylQfJgSvZual+71isPoIpSx3NAAB+rJekKoub8lh/tiwuXgFBYTRUlbfgx8pAuBtM1evk2JKuTRfuGoprWcyl3OlRrUE5brGic6S1gLG0RsrU6w5dcCtHUIpUTZp+fvX+bxhL92bovpsCFdun32/bi35nkugCi6j/LnQybUURj8b8euKKDk9twJXtJZGZ5tstGqNfDd1FY0vxCwUx0QPOk7e9OI2il9HQknAnBhUsMLl0tmotUffLwip/2+C31JfqdG2sjCA8Oj2pAFObEPDrS/ovAMf6Ns2kwzl6Gz2TpDQt5C1n7co2qz4arSu97ISwV2pd08P9mQ6lpjiizkDkr983PWmZneQJHv7HsfMqiYSYnEcGFXY88ASe+aRo0ilKX6j5kPXHmdEyzR0vP464I+6zhrYG4XWWIcqOL0uSCqW97E0Puj8LCMlviA4TQK4YUymqX2/3iC7qVuv8R02K0htVZO26SDDDtfjGAb+OmE/UkiiPcJNwrR4T1dZtvWEi6/Heo++nJw2qxoYFlxQpbR6BcLfcHPQ0NXzgTrlg+V
 YBRyQYqN
 wACFTIIrpSH8kG/yuKq7xTJbFQo0htJA6Fhj41H2V6AZIibL05vQG5JmJRb02e2YUY5hE0WmP/nDcB1mRZINbc/qQK46pL3hlEzTwVQWpw943h91PD4aIFmXLkshupyI/ppgntCtJ5kr9oEvc7Jcz2ugv+ANyVg7lN2O205DsqlRhA2eqev6NBs/Qm+UD4tPmKGXvkKp1NfqKc/76SoO9MPloCzxZrW9L37FBJBKB0xt3xzF8UtHskK9wVoq6k/G8h5jQi28KTekZV6rCc5IGWSakJ9RQQSKynbG4tIOidPR7BffXcOtcP7uqhh9stB1rO6WiMTuEyPkTkg8Nzp7gw3ZwU4rVL+oAs6N9PqVL95RqLyGwV0QCGgEjG7XoeylhJDw3oTiqljktm+48wJ7VELLbewFHeYNT4dPmCUTsWV7RwuPbZwxS+K/9pnQsTvZpjf7NmTaAgY7g3sss8lpRqFz/Ga7aafsFQcpOEDGeCKDc6/M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 25 Nov 2025, at 3:52, David Hildenbrand (Red Hat) wrote:

>>>
>>>>
>>>> Like:
>>>>
>>>>           if (folio_test_anon(folio)) {
>>>>                   /* One reference per page from the swapcache. */
>>>>                   ref_count +=3D folio_test_swapcache(folio) << order;
>>>>           } else {
>>>> 				/* One reference per page from shmem in the swapcache. */
>>>>                   ref_count +=3D folio_test_swapcache(folio) << order;
>>>>                   /* One reference per page from the pagecache. */
>>>>                   ref_count +=3D !!folio->mapping << order;
>>>>                   /* One reference from PG_private. */
>>>>                   ref_count +=3D folio_test_private(folio);
>>>>           }
>>>>
>>>> or simplified into
>>>>
>>>>      		if (!folio_test_anon(folio)) {
>>>>                   /* One reference per page from the pagecache. */
>>>>                   ref_count +=3D !!folio->mapping << order;
>>>>                   /* One reference from PG_private. */
>>>>                   ref_count +=3D folio_test_private(folio);
>>>>           }
>>>> 		/* One reference per page from the swapcache (anon or shmem). */
>>>>           ref_count +=3D folio_test_swapcache(folio) << order;
>>>> ?
>>>
>>> That is incorrect I think due to swapcache being able to give false pos=
itives (PG_owner_priv_1).
>>
>> Got it. So it should be:
>>
>>            if (folio_test_anon(folio)) {
>>                    /* One reference per page from the swapcache. */
>>                    ref_count +=3D folio_test_swapcache(folio) << order;
>>            } else {
>>   				/* One reference per page from shmem in the swapcache. */
>>                    ref_count +=3D (folio_test_swapbacked (folio) &&
>> 								folio_test_swapcache(folio)) << order;
>>                    /* One reference per page from the pagecache. */
>>                    ref_count +=3D !!folio->mapping << order;
>>                    /* One reference from PG_private. */
>>                    ref_count +=3D folio_test_private(folio);
>>            }
>
> Interestingly, I think we would then also take proper care of anon folios=
 in the
> swapcache that are not anon yet. See __read_swap_cache_async().

Right. After add_to_swap_cache() in __read_swap_cache_async(), the folio
there is in the same state as shmem in swapcache.

>
> I wonder if we can clean that up a bit, to highlight that PG_private etc
> do not apply.
>
> if (folio_test_anon(folio)) {
> 	/* One reference per page from the swapcache. */
> 	ref_count +=3D folio_test_swapcache(folio) << order;
> } else if (folio_test_swapbacked (folio) && folio_test_swapcache(folio)) =
{
> 	/* to-be-anon or shmem folio in the swapcache (!folio->mapping) */
> 	ref_count +=3D 1ul << order;
> 	VM_WAN_ON_ONCE(folio->mapping);
> } else {
> 	/* One reference per page from the pagecache. */
> 	ref_count +=3D !!folio->mapping << order;
> 	/* One reference from PG_private. */
> 	ref_count +=3D folio_test_private(folio);
> }

I like this better, will send a patch for folio_expected_ref_count()
separately. Since folio_test_swapcache(folio) implies
folio_test_swapbacked (folio) as Maolin pointed out in another
email, I will get rid of folio_test_swapbacked(folio) in the above code.

>
> Or maybe simply:
>
>
> if (folio_test_swapbacked (folio) && folio_test_swapcache(folio)) {
> 	/*
> 	 * (to-be) anon or shmem (!folio->mapping) folio in the swapcache:
> 	 * One reference per page from the swapcache.
> 	 */
> 	ref_count +=3D 1 << order;
> 	VM_WAN_ON_ONCE(!folio_test_anon(folio) && folio->mapping);
> } else if (!folio_test_anon(folio)) {
> 	/* One reference per page from the pagecache. */
> 	ref_count +=3D !!folio->mapping << order;
> 	/* One reference from PG_private. */
> 	ref_count +=3D folio_test_private(folio);
> }
>
>>
>> I wonder if we should have folio_test_shmem_in_swapcache() instead.
>
> Interestingly, thinking about it, I think it would also match to-be anon =
folios
> and anon folios.
>
> folio_in_swapcache() maybe ?

Yes, will come up with a patch for it and send along with
folio_expected_ref_count() patch.

>
>>
>> BTW, this page flag reuse is really confusing.
>
> Yes ...
>
>> I see PG_checked is
>> PG_owner_priv_1 too and __folio_migrate_mapping() uses folio_test_swapca=
che()
>> to decide the number of i_pages entries. Wouldn=E2=80=99t that cause any=
 issue?
>
> Maybe at that point all false positives were ruled out?
>
> It is horrible TBH.
>
> --=20
> Cheers
>
> David


Best Regards,
Yan, Zi

