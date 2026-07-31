Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22BC1C54F54
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 06:13:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7A7B6B00A1; Fri, 31 Jul 2026 02:13:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2B856B00A2; Fri, 31 Jul 2026 02:13:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCB476B00A3; Fri, 31 Jul 2026 02:13:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9191C6B00A1
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 02:13:24 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 20040C0396
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 06:13:24 +0000 (UTC)
X-FDA: 85048054728.18.0EB6CEB
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8E6274000B
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 06:13:20 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=SK1f7Eu1;
	dkim=fail ("body hash did not verify") header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Gbnbri6z;
	spf=pass (imf07.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785478400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pxK0/qr1MW9sKGBjBBXByQb4SrQuNftx3hOoBYzub4Q=;
	b=mQTwUTuh2uor1XFirtwxSakiRyH5Hzn4FKBBhPMRmcGF8/LyphsFIug1arukS5x8igMOE9
	c46tU4aVYjW60TBsmt2oqzu8m1i1TKMF4rQC/cnW//nublUsvn9+B2wE5PPoUos4oxYm62
	lig2mqeomEAfUciBnprtbgWG9RR/9Xs=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1785478400;
	b=BmRUCJ7crH6+cyXe6GpDkyjbtw8cNl1IsSlc7Ie2YcqgfhDO8CcZmyxibrIrB15QS7unwN
	EPQLhxrTx4giO4KGH1YN6eeBaDx6myzSGdDkmlaKIMW47xl4lBQ5niEg5e1c56kfuN3r86
	yRbXAL18sJtSii1OsVQjgNwihQWKIUk=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=SK1f7Eu1;
	dkim=fail ("body hash did not verify") header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Gbnbri6z;
	spf=pass (imf07.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66V4s1IM1780420;
	Fri, 31 Jul 2026 06:08:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=pxK0/qr1MW9sKGBjBBXByQb4SrQuNftx3hOoBYzub4Q=; b=
	SK1f7Eu1JcXrSSqCkUHa10NxIwBUcEy6f08+cct4rKWnYW9mH7QxUFwWYS1R1SZt
	n/uDILCgU2ks4BfbDx7qAaf0fF/sXsRKUfDrkI10jxVbcSxF3NZNbi03IJKfCOR7
	sQXlO1d0kOHWJCSSxaKQUFv+SZGX0F4pg+X6zAdlkPjmThaaPD0XmES7k6nLMcPQ
	6Y5Kh1CW9kP6VjYcrXTRShrAdUAEmMtLx+OszIWxGLwt4BS3DMkXw76WkKpe7SwX
	HpRMWLovJHwfJjrGb9jd9o3w8Xui/8xKWgdJN7c4WXd5sNKLn5lxVyvRoC4mEYUy
	MkJNoxPoCWsFeVrHSXX3qw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmr018xkx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 31 Jul 2026 06:08:01 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66V65ZBL021194;
	Fri, 31 Jul 2026 06:08:00 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010026.outbound.protection.outlook.com [40.93.198.26])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh8mtub8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 31 Jul 2026 06:08:00 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=np01zKF7i5exJ5/cybs1Kto2/1p/1gEuQAjVoVYfXpQ5qbi1MCB6xaRCFVolyb+ryrE/GMLza8DFWo9cVylbYkQ/tRjvYrWf1yyuNZl6dgJqT4Gvge1iHUlrfZU5sTVCJrFrv46JM6xkIY4qO4q65lAHuaDp15rK0vjn1v1jomXtat7+RLGKTaZ3gq7/sYAk4RkWHPRgq5mPbG5/V3hqjJyl3Nl5v0ybtrEc+gQTwNTtTYm4vbkZprjpIEx6uwPvglocLFq/GQxND/Ynr/w4M1TG1hTIQ6Aqw04O9rbW4tNTQa2PKp7AqqYZ3wfSzsGBuUsfUsQD0lp4SDEENflZww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YM6RMpy8MJyi3UlhTGQmTlvj606RDFB5GBmcP+/2MEE=;
 b=C1vZUd3zRA/pBNWHTiCEm/UJVe90DwUj1BgTd5X/Zn/5AaQGUtEx6dfBCXCp2+TYLKwycFmr5PAui5tYJ45s8w0xaiRyI/3uGS4cihcCtKH7G62mN0eyXpn3/+PasHqTYYNwVczzdl6A1ntF5p8qYubKNIkZ0IVyveojiDi0dUbA7ska1hbVyOInmplHH6b0rududJWHzKQhOHz61cP1Tu2QZnFzvsqZBlXVj1j4QwnORPebqXlaGjBoM9MJ836aSBtiezDS8UGZFR4jx06ODo+6lDxXj/MOGqytdiFsnbZZXL3JcH+fii/tWrBaCgkWQboOTQ1+EEJreV6tacjllQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YM6RMpy8MJyi3UlhTGQmTlvj606RDFB5GBmcP+/2MEE=;
 b=Gbnbri6z/mjHnAOVH9kdxBlUNtxn9KiEeOWu/P+K6t0BmQoIDkTYJeBbxGoOeYj3PL+D+OeBfJwZihOxI/TMIBDt6MXU92j50Bcj7mYOjRmQqIwCmBEvhq5pUNfHhaZvGJRNwJAtYWywYQy7rNQ4g2bApBjn5LP/FidNI9PNXpM=
Received: from DS0PR10MB7364.namprd10.prod.outlook.com (2603:10b6:8:fe::6) by
 SJ0PR10MB6432.namprd10.prod.outlook.com (2603:10b6:a03:486::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.15; Fri, 31 Jul 2026 06:07:55 +0000
Received: from DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::a4df:c903:e1aa:322f]) by DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::a4df:c903:e1aa:322f%5]) with mapi id 15.21.0270.012; Fri, 31 Jul 2026
 06:07:55 +0000
Message-ID: <03f13222-f9b7-4d48-bd4a-d7e4ad9c627f@oracle.com>
Date: Thu, 30 Jul 2026 23:07:49 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 02/13] mm: Rename folio_contain_hwpoison_page() to
 folio_has_hwpoison_page()
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
        David Hildenbrand <david@kernel.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Naoya Horiguchi <nao.horiguchi@gmail.com>, Jan Kara <jack@suse.cz>,
        linux-fsdevel@vger.kernel.org,
        Christian Brauner <christian@brauner.io>,
        Jiaqi Yan <jiaqiyan@google.com>, Usama Arif <usama.arif@linux.dev>,
        Gregory Price <gourry@gourry.net>
References: <20260728204409.3396238-1-willy@infradead.org>
 <20260728204409.3396238-3-willy@infradead.org>
Content-Language: en-US
From: jane.chu@oracle.com
In-Reply-To: <20260728204409.3396238-3-willy@infradead.org>
X-ClientProxiedBy: PH3PEPF0000409D.namprd05.prod.outlook.com
 (2603:10b6:518:1::50) To DS0PR10MB7364.namprd10.prod.outlook.com
 (2603:10b6:8:fe::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7364:EE_|SJ0PR10MB6432:EE_
X-MS-Office365-Filtering-Correlation-Id: a48c6574-7171-42e0-6372-08deeeca101a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|366016|1800799024|4133799003|4143699003|10067099003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	ZxND7CgqvmFn71Dvp6pfz+rbDACs28oXaQg7cXFyynkIh9LCrpTZ9t8fDQVbkDULmXhRJjdsIg7UIsSRsrteCrjQiyBotgd+sG2I1INbHh79NoWmih6iWbJwYKo9a51pXNOgJnAw7I4zJ+HrsVHrVzUG7gZGXTZC1zk5PNowFWAAaC4IAmzYX5usyBNYYmtQI0vuAqslpNhLQGwiWyQupHVPv4WddTzQItu+q5thNY3KGFx25ljhQ/FYVsOQhKiDRgdU5g+Rx+2hUvq33lCan7MaSI1zNupd9gE2t2oGbehEXUmZf/xRoWZxrbnQwb6vcYx5LGdPN8j1TumwUWTfh6SnGwBkwAE6C+WzPXwACkJ6biQLzUJUaVX/hL2l2Io8Qcz5We/V2Ax/8rGJoLLCC7mm8tDgyxOAOFWM5AYqSJs0hwXS4dz9m3mq2Nk92t8a/uQBEEFWL35uum+87N9MXNJyoRR/ee2log3EX8K+sQdtSAFsqjNZuJgOGZSjkAuTzHbpxUBBnhPFL69oMny5L49z/uOmbp2IVXnVpniYnaS/r9avKHl/XwJyHTTmxoEhK2FHQj9CoSFLsIYwdkEtsZamOp0OT4h4TS2azRetDdKywffNgd/XbnHg8cJUsmctmQN5kkuPK1ma/Ewn9sKZ/zyT7YGyLa8Y8vJmwKrQtbU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7364.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(366016)(1800799024)(4133799003)(4143699003)(10067099003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SjFqYTgvaXpxbTVnM0tHb1ZXdnk0ejV4VTM5cEpHOWdPZk1jc3hoZ05QR2ZG?=
 =?utf-8?B?RHJVNm9pOGljLzNFTFpKZkNQbUNCaW1KbDhpREdWUTE1MkJFUmtZRktpanEx?=
 =?utf-8?B?dkdRemEzZSs4bkcrMm9UQUVRREVXOW93OHJyMHdUTTl3SWNuR2tFN3U1QkRE?=
 =?utf-8?B?QkhxUVl2UUY0YkZQTzA2TUpWY1FSajZ5TTV2Rk9oY2RRRSsxS0l4WDdGRE8y?=
 =?utf-8?B?WUc5amZqTXM5eWxXZjNoTFdmaXZZUmtDSS9HL2hnK0tRejlWTG9jM1VGVWJT?=
 =?utf-8?B?Wms5WlZzQ1I3VVFjTVFVZ1IzdDYvWTNHNGhCNDk4bnlDZE9TZ3VmaVo4WlFo?=
 =?utf-8?B?ZDV3Mm5tQWtkZ2xSR0NXS3JjOGxVeWdySTRhdWk1WlBNSjZLYlQ3eExjaHZG?=
 =?utf-8?B?Y3VVUEM4L1UwTGZSY3JYdWQ1ZFpUYWcxSXNOWTJXamk4anR5bXVvcDlEUW9n?=
 =?utf-8?B?Ymhxb0RqTWpuaTFHWlQxQ25OTXZXUGxGM1RBOS9xZm1GK0JNeFhsV0pEeGJS?=
 =?utf-8?B?Yzd1TStod1R2VlAzbTVwN3pRTVhuUDFXYlY2VHhQNEdsWHZUWHp0Z2xPcUFo?=
 =?utf-8?B?ZkJlTVB2WTFuRnpkQ0JSYmI1blR3emJ0MG1XeU9Sb0E1eEJWTFNBZHdQbnFp?=
 =?utf-8?B?Z0h5MHNrOXRUbHlZd2ZNV3JIV1R2NUFmQWNvYmJmOXlid2hxejhlMExpc0dB?=
 =?utf-8?B?WTVPSGNqQnRyU20xaWpueVcvNis1VHFyZHdaUVdzK1J4V2paQTdacHJKVk11?=
 =?utf-8?B?ZnRoclNaQWo0Z1NDUDZoakZDNkl6R3IxNXN5d0szODk2TitzUndtaCtDQjVX?=
 =?utf-8?B?cmpuVjhqVEU4a25QNGp0R3hWc1pWcy9HMDBGQjkrRnB6ODRjRlVvQXVNNGRF?=
 =?utf-8?B?R3V2MjRRSVRzSFUwZXZCbTdtSWxXaFJ3cE02OFNiWjc1bHhjWHFjYVhkN083?=
 =?utf-8?B?Um5BWVg4T1B0b0hoOTY4YXVFVHRLTlMvazk1dDBFMG5xQjVMeGVwYk1NMHFU?=
 =?utf-8?B?aWxvVktrekh5Mk45SFR5SkFjUlVkdndROCtFVUFRalg5Vi8rTHVQMzFjd1FL?=
 =?utf-8?B?UEo5clVnMFVsaldFbDkwdlVhWjl3NTJMTHZGb3NnRXRyazJZNXh3UW5mTk5x?=
 =?utf-8?B?YjJrSVdsa3JiVUl4VXhHM0VGbk5JL28zVUZ6VEZRajdVMzJLZ05WSGJlVzRZ?=
 =?utf-8?B?YjhhWTRaTGlySVBwKzBCWWtrT29udkl0bm44OHR2Mk84N2RiZXNsOFJTU084?=
 =?utf-8?B?YlpoMUdleXM3c0h4OFNsQ01CSVBTVGhCcEp6T0Y0UmpVZmZmREk0bXFiR2Mw?=
 =?utf-8?B?dUFVcCtmRGhkMExNNURkSHlRdzJIYXhPaVVQSFZodngvWER3d0V2dFQ4WlF6?=
 =?utf-8?B?OGJGQnFZWWI4WjBRakhETnVaS3N4Z0dYM1lPamFTR2xvanRDTTFHRU95T1h6?=
 =?utf-8?B?cVEyeTN5cVNndHlwMmFrVnVtVlJlak5VU2MvUTFjV1A4Z3dNRU9FaVhDdmpO?=
 =?utf-8?B?WGE0Y096Rjd0VDRnNFV2TGROcTl0YWMrUERMdkx2Mmo3YUpEYURkbVE1WTg5?=
 =?utf-8?B?U0xzMEpwMXU1L3A1SlJSUUZVV1AwLy94YVJhQUlXTlFIQnZQd09wK3JJYVR4?=
 =?utf-8?B?TkpqUmhvSUdHbzQva2kyMTFyM1VVYlVZYUpzY1c3UU5SSGUyNy94TmNqQjc3?=
 =?utf-8?B?ZmpsYlVnbVhEbUtVYWF3TzVMMGtnUHIyd3QvaXR5bVhaSXdnKy8zTk9KYWJE?=
 =?utf-8?B?MFcrRnJDTFhQMTRGMVFlUWRtUXVCV01ibGdVdjhPTE1uTWRkMW1aQkNndDA2?=
 =?utf-8?B?dkZFZWdUeXlDc0NlUXZlRngzaUVMM0tTSEgvRk5QMFEyZXNzV1o4QVUxVXEr?=
 =?utf-8?B?WERqWlhQNlBobCtiZDc5aGc4TkdNcGVUMzhNN1lROTE1MXNXTWZZTEJJbkhv?=
 =?utf-8?B?OVFacjBpZGl2MkNqUGxaZUd1VXNMazc0WnMzWTkxWm5pbTM4R0RUNE12anVK?=
 =?utf-8?B?aWZqd1pnanNyTDFsN3g4MFk2K1RqeExMcENNVXRMbUl1MnJNOUlZbTZPYWNW?=
 =?utf-8?B?eDE3aE02YnA3U2FXWitlWjllUUplZWlmVGFkWFFnc3FVa0pqdzJFK2lxaWJx?=
 =?utf-8?B?SUxPeE8zM3J0N2tDQ3hCbGd1OGJQOUV5U3lRb0gyNmhoN3ZORURaUFVGekJM?=
 =?utf-8?B?dUZqbXB6TDJwY3lpd1k1NWo0cXVoZlJaSGYyR3VjeUpPMUNZTnJDbFptRTdJ?=
 =?utf-8?B?THIrV053TVFJSkV5aUVFRWowMkxkbktZMnp1YkZnWGU4TTdsaG9XaFM5bFl2?=
 =?utf-8?B?OXhLSXJoNDJDMGtxYlowck1wT1o4SGdJeUNWT20yclkreDdqNXBvQT09?=
X-Exchange-RoutingPolicyChecked:
	RRuz+cAHoQdZuUi0l16xoAXAKjRmCAzPtAvUtfZQVJCjcsqd5RITWeF1eSKVqte5OO7K84o47xtxlrzdB81zjC24eYFR/Pke/MpPZuEt83L+j5XGHT/G/a7rLxvGy5NMF30TbLvMfKHKvD6OvGRBBK4q7MOjmVEjIbgHZY48FRzpw1iXzmlAlOMkjNeEn75gAsic8gvRm/EQM29SfOIh0Wc4HNABBcniDsZoFsF1OwExTQKH2QEfnDr1zTcB+gdJEpYT2HkW2cUjK7Eu/N9hqguS+enF/mc1XpxLhFJMYVdtahEvJo9xKEtPOhZHz2pf1SgDM1KqZ1FUAYHEY85DNw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	hsC2HymriQo3LBNfNtTOIipDLvg/wCMf5TLqmX/1vAoGbaMmsfpqONttEhvtiZCcLo5QoEVlAFN+zqoeYABpIKqF33JiyRGrbU8Z8UCnNULMF27496fT6+lfG5NK4z+xHivVOc4yxuKImGRjbPZmksZXa78nQgAXmySsuo1r9zPdAST21qcEGnmH20Hh041RSLuKK983T/8fLsNbp1ktwyBKx/rOgMGn0aL/PwAXRaxcQzEKSJ7XzVNKXhXp3v1NfnjkpxuW9uGYPZcfak1W8mTN1Qr4RJia5YX0qaTJxaH2HoMjKWRryb7C5sAi21ydj3J6oZQWb20NPiYH356KkV+YxKHXsntjJpOvgEHhQ4pGIZLMxU8uHdxTT2pU07lFqz97aRh4X95gT9WSDEy/TXTIiFfr5jlNzVjfBv9DOJGKPamXqDKhrNTN/6U0KAB5aL04dE+kCro1GqyzNpAyctcpv7ycUwMz1RAfs+Y9BPpmPKQDo9ElerXmpRHVERInoDgIbReOoO0xro+lhj71d2lhLe1z115zvL2JIlPQiU0wzCndWZTx+s4Q+HR/SkX5ln65G7knDeAZlK1BmCATevlyN3mJT4tjVlUqx+JJKb0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a48c6574-7171-42e0-6372-08deeeca101a
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB7364.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2026 06:07:55.6212
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PQfVsIJaBIBBK7KePrxdjpPG+FMgLMkxiq/6DU0YC5jF5R9BJ8lIuf3jWkDNeA+eLKXBNOf/ZJou40qEwLO97g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB6432
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-31_02,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 lowpriorityscore=0 suspectscore=0
 mlxscore=0 bulkscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607310040
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMxMDA0MCBTYWx0ZWRfXxJh2akCh9ZEw
 HaMn/+INcibPnUe5b9AgP63nr+ZM7NGfNBYMTgWEDLO39U68Eq7XAnmvjEtkoxaihPzZAXHRxhW
 yd09tXSYwzkZwcQsI9B5uS7aaJ8eOM9BsxuJkHbh5kaCGoPFmeJx
X-Proofpoint-GUID: zHoAIdnsX3vUMpaIm5gn0YzwQcrFlPXT
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMxMDA0MCBTYWx0ZWRfX1vHDQ7s/4KnO
 L42Usv9aHqIBtxhXgQFhhdh9xo+0T67EJck11321d35z4Ag99R0ta3GLLnTnq+HA1ADHIqWn8HG
 T8s7lODZAzTEBu5BEvBbhKTaGo7d9UiGtgrEV+sljz1o9XkXuKdL3HF5FOSDAok/F3TFi2Umqit
 7ZeO+sThBtVHTUgTQCCT2EaEx0tqB3Y3gZCgz5Si1iCzMwanpJevMYWV0NkUFgA1umBZyU117ED
 +F3GJUY3GgrbK68IFEFwcwgGmjtwnm4LYQKl7UTx6bwJTafI4CUrH3WSzWtiSjNbatB7tvFJUNR
 +FzHUkEaF7iapk5p+IrJUHeY/1hiFTWxbaMqdiEGTBeeYnLD0w0mxs377R6zTeknxz7Hhzj0bKe
 WhqiXhcvOkra7IznOyco25ky7xBwP9uUovKx0MVSR4M+kYhmh8VBMMxA/DLVYLeYR5rVJLHflLL
 0883lHZcW/jfe7zFm30msa6rFC8+umWL+f1znXps=
X-Authority-Analysis: v=2.4 cv=KL1qylFo c=1 sm=1 tr=0 ts=6a6c3bc1 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=RpNjiQI2AAAA:8
 a=JfrnYn6hAAAA:8 a=tHa68p0SAAAA:8 a=yPCof4ZbAAAA:8 a=4OxuowGdLQ0wBXtkrGkA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=1CNFftbPRP8L7MoqJWF3:22
 a=ufIsyHvWW7FwcMbVRpPq:22 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22
 cc=ntf awl=host:12107
X-Proofpoint-ORIG-GUID: zHoAIdnsX3vUMpaIm5gn0YzwQcrFlPXT
X-Stat-Signature: mkgcxi1bo9cdtpoaiy6q14dehd7greiq
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8E6274000B
X-HE-Tag: 1785478400-996937
X-HE-Meta: U2FsdGVkX18PkuVFEooPUkOwzr9fbg3sx05HHqEPaHFJYlZb1zKWjxf63BJ49FyVxpvMq9jr0a4Qy8fnXw58gpf6ErgufwqlvlPPhcTLIsTI5aMGrKh1WtB2w9GsC9zs32SWxnkEl+N1ORYaU9XQpPEhE6XdV+wiEr1HAM1FfIuD7rqjtUs8YY2zJ1wxtrGhaqbaIyIDKpuC20aLhCtuHt56d+aIaapAwTIlrJU+w3rDF03ovLtibR9Iv8Z58JK7NxVCqREkxWaL2QpudsUxCH/8L07vJ6QGqca8wVz+dVs0GGfeAm4afrTF/NuhwOda3a5UXf+FLvUDStGchkXTmwxzpT2d0k5hxwur43ri5qWujkAGa2c4KlEjKA9c+NywMrdGcZxEeUV53eU2pJlKcHEiqQ5TsHAFS7KClScBxsdgPlr1Ps5b1Y97rXunhFJnkddw9KRYyn05AWYmw5XGUIO0OdyG0OQU2Of6NXCOisD3kpecWtoJyawuoiZbaTPumDzBokxoqrNeEdk1SGbg7XzfB1OpkHSdKqhBvxMvwb3S8R/fgO9VEvsbAk/jW3TVMkURIVUwGflLvIrnaTdzWol17e1fCjN/c7pQ8qzFZyUbOSiLuN89lg/S8jnqSfywcaFyKs3r08Hr7KWHcocnkmdVTuP3XFIvW2vQ3K5gVd8BqeENJusDTPJ5aGgIXy3RQp7yRbawaSFwi3e4Kof5vnZHBu03DGLJpHRMUTtrQVUKUWt2WKCwoQ/ts2hU1biUfphyN+DmOeMpAgCYlMjGAEw+3habp8HrGl/4XlJj9ruSljqZVArWpyaZWSiEGbTCHxepNbEGWvthlzujbU90SEP1ixs2/J60v1IMRAYF39FNu9GF43NCWyH4VVM6SITXDu3Y/IK+fiqnGab0n2j15R6tkNJy8GD/Fu9B+PGzOgYFP/9mlJmnriAc+LL9Uj1AoYQs9z1fCeGxwRAYwFt
 33Xy3T1G
 5hHwUjCq0l9dyOoMRd5xnkTBUwsxNIuHMHvNQgg3YILgYCQlZKXySG2gRBcrHP8bCK+CGvELk1kLd+v0q0W3aQ7eX2BK57DCl+10ON383/XMA3QYu7+449hZREwXguRhAz0S21OIsONuVrpi4MpRdJMoHiSFIGQamSpyAuYC8tHyHcOKHVUxfbZw4yvhSMEghfSgUlNnaYKGF1k9h7WBZx/S1YSqTCcHZCK8hUjKFgZPNf9FzgY4DVWNCvmJgwanIzzoPCNCBWHCOM04DxTqdqOGfW4IRyzD2EjyVTsk0BclHTirQ9iwYWzA4nCtTYscDMzDwKssSillEsgsrxOpc+8crnST9m0P55EZtnC5bRfpGcH7SBHFHt77N8GYurQa3L6DFhg+IN/Wtw4Q9yVSepMXxr7uERikbcVrxAaCuOt5ffKvmTUGxB75dA2HNfuXxfiMYQmZZcoJYNyvz99FvNlTybTyju34auaqUOYqFsxF+70xJFwqBDSc2RpDTBREFm6KxLLU0UMI6UQcoQEEvYzRINUhhq70fjaeGIGCiPsBZZ5h6DB3ON9UpJN1XolMp7u1qzrFx7nVHJDFM7qlVhPYB7/4W0cF9STfcieOah3K2PtgCJPGzed9S/nuQfZjTRcEALmIjOYT0V9EkNT1PZoCkGGMPcXWY0OBPYr2DGz1HH/7aTFDlkkMiEhjK/btKWFOMBq+K5dSO079PtzA6qosnStFUWrGRa2ez+RgvcPP489wn/Dn1wNCXEshTkKwVH4Ho1YCZT4Nqh+AOQ2JrjENYLEPTlQYj+TwXp+9J7IPOHMsgndwfY67prliAbhZQU2gPKncx2jdTXEuBzIsQuavdO3UvQ5ccvMNXs7c8JWEKOWPntZEw9hCFBcEJ401qJkhmLbnV/qt1opvWUecpZ/rQPTS22I7AsofrYpaf7fiKVbNh0yfK7xI3H2iMp9FjfvjbNmrBQQM6rgW+uG3V3m8dNfWi
 ixLKFM1q
 gAjpBaWY12vW0DRiNkIMtIUlBUyPmQKjhS6eorV6sdfA7gp1wu4D/MY9vfuGE0zD1PFPZ2lWpnWlBFn28HKVIO16c1cZk551vHEf41MmGAs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/28/2026 1:43 PM, Matthew Wilcox (Oracle) wrote:
> This is a better name for this predicate. Also make the argument const=20
> to allow other callers to be made const. No functional change. Signed-=20
> off-by: Matthew Wilcox (Oracle) <willy@=E2=80=8Ainfradead.=E2=80=8Aorg> A=
cked-by: Usama=20
> Arif <usama.=E2=80=8Aarif@=E2=80=8Alinux.=E2=80=8Adev>
>=20
>=20
> This is a better name for this predicate.  Also make the argument const
> to allow other callers to be made const.  No functional change.
>=20
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Acked-by: Usama Arif <usama.arif@linux.dev>
> Reviewed-by: Gregory Price <gourry@gourry.net>
> ---
>   include/linux/page-flags.h | 4 ++--
>   mm/huge_memory.c           | 2 +-
>   mm/memory_hotplug.c        | 2 +-
>   mm/shmem.c                 | 2 +-
>   mm/vmscan.c                | 2 +-
>   5 files changed, 6 insertions(+), 6 deletions(-)
>=20
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index 7223f6f4e2b4..4185a03a45cf 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -1083,10 +1083,10 @@ static inline bool is_page_hwpoison(const struct =
page *page)
>   	return folio_test_hugetlb(folio) && PageHWPoison(&folio->page);
>   }
>  =20
> -static inline bool folio_contain_hwpoisoned_page(struct folio *folio)
> +static inline bool folio_has_hwpoisoned_page(const struct folio *folio)
>   {
>   	return folio_test_hwpoison(folio) ||
> -	    (folio_test_large(folio) && folio_test_has_hwpoisoned(folio));
> +	       (folio_test_large(folio) && folio_test_has_hwpoisoned(folio));
>   }
>  =20
>   bool is_free_buddy_page(const struct page *page);
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 2bccb0a53a0a..353340309107 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -4413,7 +4413,7 @@ static bool thp_underused(struct folio *folio)
>   	if (khugepaged_max_ptes_none =3D=3D HPAGE_PMD_NR - 1)
>   		return false;
>  =20
> -	if (folio_contain_hwpoisoned_page(folio))
> +	if (folio_has_hwpoisoned_page(folio))
>   		return false;
>  =20
>   	for (i =3D 0; i < folio_nr_pages(folio); i++) {
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 7ac19fab2263..33007e8e546a 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -1813,7 +1813,7 @@ static void do_migrate_range(unsigned long start_pf=
n, unsigned long end_pfn)
>   		if (folio_test_large(folio))
>   			pfn =3D folio_pfn(folio) + folio_nr_pages(folio) - 1;
>  =20
> -		if (folio_contain_hwpoisoned_page(folio)) {
> +		if (folio_has_hwpoisoned_page(folio)) {
>   			/*
>   			 * unmap_poisoned_folio() cannot handle large folios
>   			 * in all cases yet.
> diff --git a/mm/shmem.c b/mm/shmem.c
> index b51f83c970bb..492c9bef3620 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -3240,7 +3240,7 @@ shmem_write_begin(const struct kiocb *iocb, struct =
address_space *mapping,
>   	if (ret)
>   		return ret;
>  =20
> -	if (folio_contain_hwpoisoned_page(folio)) {
> +	if (folio_has_hwpoisoned_page(folio)) {
>   		folio_unlock(folio);
>   		folio_put(folio);
>   		return -EIO;
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 35c3bb15ae96..70e54ace0e74 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1086,7 +1086,7 @@ static unsigned int shrink_folio_list(struct list_h=
ead *folio_list,
>   		if (!folio_trylock(folio))
>   			goto keep;
>  =20
> -		if (folio_contain_hwpoisoned_page(folio)) {
> +		if (folio_has_hwpoisoned_page(folio)) {
>   			/*
>   			 * unmap_poisoned_folio() can't handle large
>   			 * folio, just skip it. memory_failure() will
> --=20
> 2.47.3
>=20
>=20

Looks fine.
Reviewed-by: Jane Chu <jane.chu@oracle.com>

-jane




