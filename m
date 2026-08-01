Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA2E0C55173
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 02:17:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABA226B0096; Fri, 31 Jul 2026 22:17:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8EE96B0098; Fri, 31 Jul 2026 22:17:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97DF06B0099; Fri, 31 Jul 2026 22:17:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6A8EC6B0096
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 22:17:13 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E2FBBC01F0
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 02:17:12 +0000 (UTC)
X-FDA: 85051088304.18.A530FB6
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013055.outbound.protection.outlook.com [40.93.196.55])
	by imf15.hostedemail.com (Postfix) with ESMTP id 205E9A0003
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 02:17:10 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=t80tp2Dr;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.55 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785550630;
	b=Fwiet+z+dn+81/BbLB7C5LLeRLGTtbGbLNxTE5Bntdu7jB/wUvC0TRUOPhUECF0jdnKWP0
	T3GNZ7hSvmeZSa2Fd7iJdfourXclZZ7W4M22wMLJUXUFKNYIpdTfamJ0MfIz7GBGWz7Fw1
	/kv/wDjI0tMym6DXE9sY7S3f9KCSBHc=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=t80tp2Dr;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.55 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785550630;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oSC1Hw8r25cbPm/Bni1MQgYhh4hsk40TS7XpsltGVhI=;
	b=P+qv/rDVl6DasJBG23fIqZOxGnuRkOulPkwHsVvALe8e/Yh5GkYR3sS0zDR7YZ2MuJgoNX
	TZb8/GXkcEKaXY22M38UTMGQPoF5P5mOWraVshfBQ+eKn2B4fzzIWt22Fb/BSKDT81SFa6
	kUUmaSnlrG4a8vD0qtrCYgQkGVUA9Uo=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZAtzzy2G790sZccZyGXZirZELc/Leqrhd5ZtnJ9+QYc6iVKqZGBwb9051wYwg4HXvRU3V5Vi/0NH6Sx9e0EyatUMe2Op0zfUrYDgGqmKlFx17gyUNJi9obEvyW7iWixVnbuApbNWKfAVTnk0keq4oJ1UAmmYGnWxBJD2kLFfN3lrtkcUq+j8Lts0DkJfIhYzHhB2oG1AOpjEpOiJp5qlIRBHvUf63RXbf9Ly8QWmM+SMmoBB73HcbAf7DubudJma/ah01ZW6qfcx9TlC0UWDhvOxbXYNY7mJMcYkScVE/xeXwbF4XTLzVvOgdg5dfQ2azVEwkfRARMKMKzQwhPH2yA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oSC1Hw8r25cbPm/Bni1MQgYhh4hsk40TS7XpsltGVhI=;
 b=HtKo1DdgpuRWUGuff9BwG4bseNKwNSMRSBE7Jro04z18Gzhbx8C1BWEUIYCnsPldrtWZsZzgem4k2bdg1holB3OfA/2tpgyUyyBv76ekq9yZkWaqNAHfdrUOiM5GgJyzFFvw0Mq8OA1PpFXScOAMGjYm1s6QR0yGuc7fh4OIWfToBAIeQ+HuBEBodNT8rVHqOASksuwre2hwejxC5fyh5vzljgbKQy6rrJHIUB/9L/HQO7QpX9CQhgm0OctHu5svdMPRwfBaPecOrPY8U4CrWJInB9EOM0j8A2vy1DtgagIaFCm0K0R+LxvZHkrmw/r8kZKYOJVPUmnXdsdEauYiuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oSC1Hw8r25cbPm/Bni1MQgYhh4hsk40TS7XpsltGVhI=;
 b=t80tp2DrWPPfBXpppUAnChXyZzuwpLQMawYC0fdLjcGTCTqgMF9gO/qelEtU9iqhHSA2J8Mb2fz6jvmieZnHSZ+szAQDyw+HSRah1BPTx3idEquAVnkmZ66eawOBPI0q0vswbbfFEyQc9qRPYjr9iQvRwF/8MqU/iZIQriVUDQuuxAR6z4haqGlHQJwKkFHRF0gJIFeiGKMzmYAxZXyiwkIgHscjZsPzfVLtGCN4BNZbBKGzu+KptTM5xl3CrewoIUUYhP0gtAFrA04yK7HqixsTy39qFq8h7HF5VG3zhw+r9wsN0FvxVLtPzC6QenIW+qag1JYB263Ran6wX/Hg+w==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by PH8PR12MB7373.namprd12.prod.outlook.com (2603:10b6:510:217::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.16; Sat, 1 Aug
 2026 02:16:58 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0270.015; Sat, 1 Aug 2026
 02:16:58 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Fri, 31 Jul 2026 22:13:28 -0400
Subject: [PATCH RFC 05/14] mm/hugetlb: use direct assignment instead of
 folio_change_private()
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260731-remove-pg_private-v1-5-142c97ba3562@nvidia.com>
References: <20260731-remove-pg_private-v1-0-142c97ba3562@nvidia.com>
In-Reply-To: <20260731-remove-pg_private-v1-0-142c97ba3562@nvidia.com>
To: David Hildenbrand <david@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Zi Yan <ziy@nvidia.com>, Oscar Salvador <osalvador@suse.de>
X-Mailer: b4 0.14.3
X-ClientProxiedBy: BL1PR13CA0194.namprd13.prod.outlook.com
 (2603:10b6:208:2be::19) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|PH8PR12MB7373:EE_
X-MS-Office365-Filtering-Correlation-Id: ebabab00-5202-42e1-06cc-08deef72f73c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|23010399003|366016|11063799006|56012099006|10067099003|18002099003|22082099003|921020;
X-Microsoft-Antispam-Message-Info:
	tKF3AWRWq3mVGWIOek5g9pO4cxA4JcZapPw+GN/wVuF1TS1J/yLchTOLLdgmtkWsR1vt1Ddmfy/Zbq9CWa4l2xsk5cPo+bgWfBRqnqYwciE9V1eRyw3VIK5GPYubDfqBENjwKBaGDMT+Czaq/UJ2VOUW3+w3fnT6YQJGwFXq0zC0NP0lf7w7kFrXK36IbdVxE29P8AVTL82eMwRvTgOuuFOXR4hqaByMPjuWdIBA48R3ZJDxhivWpMGXrmnri6hqzZoc1KOY+earcwWvwdi0qNtxIAljpXSLDUwZPUEy4qlVEPfw2WaR01CexFJzscB6Mgv0TDe9K5LGBfNV1WX/FGxthVD9au/M01KPSXKuFXl5px1TZ3W9z2IOYd0aRygz9dsYPuKtcT9NgzRDKFzRyA0ve8R5SF+uwIsZnuz8m8dXn9dxn8I1yvqcLHdyaooZjSHSIsBaN5ubqrKNVhV2FqB5OdwDC8RU2Dd/J4SbrPwJDx5b8Ftf9UngkiipEiFuUcv+KwNOciUppfT3JsDZUS8+izdr/CToQWFO2jp9aeJH3v/tcI/Xp1MpQZT4DC6amECU3XLKpNdg2GR1lO91WGaJbBUNFe/S/8om+nh6O6N5CKLxRFXEQnRMxlFsRwUoLlUuGuJlOs/8q5jaQ/4LL8l1uXM4oXpLZgUQ8NGKfen78cyxsRqWZvxrbxiVOEksWMH0u2i2a9u3ByvNnwrZog==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(23010399003)(366016)(11063799006)(56012099006)(10067099003)(18002099003)(22082099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SFNDU2t4VVd2TEF3eTFaakdsZnROSnZpM1E4SlN0QndQYzdKVlVrMkdFYmVv?=
 =?utf-8?B?L0pNNnZVQWtBSGpIKzc5UlcwaDdyeTVvV25sSzZpc0xFeWM1M2JQRFU2eUFS?=
 =?utf-8?B?VjRweXZWYkhWWnVscUh0RlhGcWo4TTlwRVAreUlGbmwyQVNhL0diMmFqcnNH?=
 =?utf-8?B?U3ZyeFMvNjZJWXB1TldQbVBmNHhtUWQ4Mk40K2hBVkt5R2VSSFNRdHpCdTZO?=
 =?utf-8?B?TE1hQm9maDhUMStmUzdHQlp3dm05VVZvbFpxL2FWVzZPSVptZjlvN1NlOTI0?=
 =?utf-8?B?VWhGbU8wYy95aVRtRnBHV1V5eXZBWlhNaUk2MVljZ1FLekNSdDJ4MEpVRmZ1?=
 =?utf-8?B?ckJpaW9xUUoya1ZVcmZ0TEMzY3RYSmZtMVZZWWxlZStrNWdidDdnMUcwMUVI?=
 =?utf-8?B?RmtVcTdGUDVOa2RsOE54QnZNTjNRclgyaXR1eWh4bjZ3bGRlSVZLNmpQeHpM?=
 =?utf-8?B?UWZSSHhra3FYT1R3clR6YjJtZGY3U2QyajhSS2crRGhOb1NTR3B6alEvQ245?=
 =?utf-8?B?WDRlVEF6QlYwby9ZU01ZNmhuMHVodGRwK1ZFL0w1ZmNVQWRYekhLRTh4REw4?=
 =?utf-8?B?NHFxSlUwaDByNnhSd2dXQ3pnZURza3pGNnEwVjJPNExaODViRGo0WThERWZ5?=
 =?utf-8?B?OGZRbDVuUEZEM3dHZW9kQ1BwdlY1K2xCRXltR2kyZFdhbkMwL0lwb1lPb3dx?=
 =?utf-8?B?cjBMTkVsU1VoWHN3MEZUVnErWXoxekhYNldKdDdTUlRGaFVYRmZPdzliSkFH?=
 =?utf-8?B?N2JtYmhEQ3gzV00zM3B6VW5WV3Q4U0hDOFd6Y3FsMFpMVEtrUm83UmV0RDdv?=
 =?utf-8?B?M205bUpPcGRYcjVyS1lhUmtSZ2ljdHlVWG5FeFlJZlpienplN3VaSDNYemdT?=
 =?utf-8?B?LzdCR3daNENDQytVME44bU9vQm0zcDNLSVUrVkJoNHpYS290OHF3K05oY0lu?=
 =?utf-8?B?aGc3eVZkdWFsNHdmWUo2dXBNUThYMHQzbDdyNXoyZytZVHZPYnp3U1VzRVY5?=
 =?utf-8?B?bHFGc1RYQTBNcVBqYm1RejE2Y01ubGY4MVMxYkVTSWNqRXZTb2tSV1pXWE8r?=
 =?utf-8?B?eHQrTFMyYnljK0VJNDNybUJHeG44cFZHOXViOU5LNHNWZy82cDJORGgxaDNs?=
 =?utf-8?B?ZHV5dlFaMVcvQnZuRmwzUzV0L1FYbVEyalV1K1lTV1QxWjEwV0g2TUJJeWw4?=
 =?utf-8?B?dlg4OXphYUV4clo1OG1UQ3prR0VzS3NqMDNKdE9JOXpCdktycEIvb1p2Unp6?=
 =?utf-8?B?RzR5dzZ0bEJ1UVhrNEpyU1IvYW1Ub01QTGo5TXZYVC9WcU80WWYvQjZaUjJw?=
 =?utf-8?B?UlhSSFkzOFZmT0hQbTJVT0sreC9qTGpQZHA3eTVkRXBZWTJhblY4MVlWd3dm?=
 =?utf-8?B?SU1DYXdiUVJESVdtbUZWTEkrRVdaRU0wa0s2dk1GdnlEdnRCQTJORGZQdGNG?=
 =?utf-8?B?WDBLTkpiWlM2bmVmbmlTUEtWWWF1Zkdud0ZZMUdtbjQvYUZIL3hSUWhGTkJE?=
 =?utf-8?B?ZDFpSCtNZ1pXbkw3SnRqdTU2ck52UGg1VFVNbkwxZHJqNGNlYWRzRVZkMmlS?=
 =?utf-8?B?SEVJU2Rqand6WG9IbU15YVlOYUw1MzBqN1NLOWduaFFtcytUcXoySVE5R3JT?=
 =?utf-8?B?WnVCVXQ0OHQ1TnBXQVZscXJtV1FmbnFjMW5DN2U3RERoM0ZGaVZjWjBOWTRs?=
 =?utf-8?B?RWkveU9uZWlLZWxSd21BQVV5RS9pWk1tRWlld3RMcGRpaTkycUJ0M1lXaFRH?=
 =?utf-8?B?R3lJTGJZcFpSRG0yVWt6K3lWODdDc1pRUHp1ZHRWTXdkcVRWc1lTR2VmRExq?=
 =?utf-8?B?dFlON3dHZ3RtUGs5ZmZkOUZSVFQydFlBbkI5eEJMZ3pSZC9KTzdIL21Ud0c4?=
 =?utf-8?B?YXZZa3NEVFJGcVQxQTVEQVlLVGFLUDNyVHRTektnL1VZV1NmV0U3VWVFRHJ5?=
 =?utf-8?B?SzNNWmYrNldzZEVpUVgwK1JOTFFudm5hYkpiOFBGT0dzeEJ5Tm9mVXJHZlI3?=
 =?utf-8?B?aUhiM3JQSVlzS1RRSXNpeU10eWhlM05EU1E2ZnhwdG1kZ0czekh1TnNYZG8y?=
 =?utf-8?B?WkZvaGxsZG8yQ1pZdStXWGRBVDlCTFU5dVAwd1J2dkpRSjhhSDdXUVBNRStJ?=
 =?utf-8?B?TkhWV1FwZEpSWXZIM0NwWUc5dUJBRjlGR3lqd3R2a3R6UTZxMlFWU3FOYk5K?=
 =?utf-8?B?RnFZc1NMSnF5SkpCbnpCNG5tZXBpT1RlUFVZWVdGT2NaeUN0em9nOFNWNUgw?=
 =?utf-8?B?M1Y5WkpxdDhPS3F4Z2pTUUZPVUxiTHdCaGdMMG9JY2Z4MWJZZWJUK1lZci9j?=
 =?utf-8?Q?9kQuYwpVMHmBdB8DNB?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ebabab00-5202-42e1-06cc-08deef72f73c
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2026 02:16:58.7133
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S47r0/HU7XdB4r5BgGRg4ExdEEPADwg2ESeBMg9Qad2ISTTOdSj0FJMGIsz1bDEn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7373
X-Stat-Signature: sfse86cxqiujkxaky3ywds7yxceksxmz
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 205E9A0003
X-Rspam-User: 
X-HE-Tag: 1785550630-578641
X-HE-Meta: U2FsdGVkX1/bXISgafOMCarlWDixZWBl9kFOZyEdCk1u9xB3UoC+4rkFd3Swdjx5jc1Xg6IRd0/BLnAmRlCtc/Dunb+qv+dlV7Bn5ApW4Gg7ikSo1xMHv7IhjIqzMNUXKzkURBPBekJFqzWhnGBz969LdnlgziAFPijpYgs2gYcP5naruXTX1KcIQrfwn8uvxcIntvW/HBazLLKlweAMmkdaU70jSXYqeUNOroOLDdvZl9yYWxe9GUoMbM9QSFshm3tXKecTd4H7HF2p8LMs4s5Kiglt13xs826kp97KpdGaMVoJF5fJTpP+IhsPTJcEBs/zhqtuEUl6TCLPvk4fAzO7LlruZtQg74rNAvWniho7ZhSQxK5R8ajqIXcoGsp0CDzI0oaoxl6ZczYi+2EdGDdpGphuU8VYa0enPXzPqyKMPDr6blt3xi4PU5gVHRMamuDbuaV1mqkN2N7SHJbnHea7krMAq6/atgvADU6DSPXN274ZotcuXD7T+5rBqPW6BfJH738A5tY476Uz2WqBAriKe2wOxlHCYM7HojiEhG6E6oKXW8fMENEaY1omXbMtq0v/QelMZHRssjNN8GEuHe1SpCHHwSMAQnvKKpnQghCmWwc1PUPn5M42dcib4BftKq6jZ7sGGIAqvaReDPlA801XNJ5TNWR5cl13u7QfylgeCUNHOoZ3UjXhe81lWUDfj2kOFW/66lERfUux9gDNcNRi0NoT4WtJI9TKhATRra4ABOw7PdfrU1DWtox488BXJF2j1XgxENobCjFjI97Xb+J4Z4uKxbr0RVyD7sIXQPIlI1WuKD77+hSW+pnjz9SiNL3gAaXCQ12r3JtJ88jZOXGflQPpe1sL68w8ma1cCjbeO0gx7faXijjKiPI/YW7s7JxjU9YIZ8yod2o9mJ0tdOsbnf0EaPAfDj9eFXJinemALeUIGw6kqfDxlO0lVqHng6wQaHKwqaQ4wd6YMa6
 bmBt7iuk
 eRX/L8TaGIYDnZjEi/DfT2kkrkHtsF0yzUbisv+amtXLgn9eTLstMbcxLpEDtteclW8BXsVL45HvnFmFSRF9vr0cY/PRk0ly7NRG5ZMd46+1eoZe+rej8fQEM/HGMCHBgFNDoc8GqPt4jluZrAwtkKRc4wBHVmshms6LT16nAqJlgFKlSgQAt0Tj/G8fvxfnx97TKfbNmyrl31cmKS9dTzKiLdOlJOJKB+xo8vW83/WH4oOX1OF/NO2Du61OZo4rAmk0dQJx29KEh2tjjwaRBlD32YxZ4hbFTSieuT6XdCnR7xZI0CDwSxa6L3uihe8HsN/kFBreBiV4exv/RYVlEYmqNDIuEJMPVajXv3k1/aveZwfByc0mSo/FrIEiHWzZsxQFK0ZYWeIkQGu+RIamPZG/iUh+/yFiLv5XaJ0mQc2q8ieZx15bfD4MFr7TP+pBAvQEXP9PMZHs0A4UXyEUza/3FQxH0vhDXfYJIVPnV3sTqI3rLfEDIZ9m6WYI/rtwvszT4TDiCuUBEBP06cAVlIkKc5ZSOhrgKy04wBrAxRa2qPjfKg20EDzT9UcdbLwIiqJC/jm5Ems7iWJg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

folio_change_private() should be used along with folio_attach_private() and
folio_detach_private(), where adding and remove ->private content requires
folio refcount change. add_hugetlb_folio() simply sets folio->private to
NULL without refcount manipulation. Change it to direct assignment to avoid
semantic confusion.

It prepares for a future commit that remove PG_private.

No funtional change intended.

Assisted-by: Claude:claude-opus-4-8
Assisted-by: Codex:gpt-5
Signed-off-by: Zi Yan <ziy@nvidia.com>
To: Muchun Song <muchun.song@linux.dev>
To: Oscar Salvador <osalvador@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
---
 mm/hugetlb.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index a77c3c1cb8943..0abaeb47890cb 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1433,10 +1433,10 @@ void add_hugetlb_folio(struct hstate *h, struct folio *folio,
 	}
 
 	__folio_set_hugetlb(folio);
-	folio_change_private(folio, NULL);
+	folio->private = NULL;
 	/*
-	 * We have to set hugetlb_vmemmap_optimized again as above
-	 * folio_change_private(folio, NULL) cleared it.
+	 * We have to set hugetlb_vmemmap_optimized again as hugetlb page flags
+	 * are all cleared above.
 	 */
 	folio_set_hugetlb_vmemmap_optimized(folio);
 

-- 
2.53.0


