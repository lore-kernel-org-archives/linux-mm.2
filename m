Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62718606A319
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 10:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=XLwrnVwW
Received: by kanga.kvack.org (Postfix)
	id 7BF766B08FC; Thu, 22 Oct 2026 06:24:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7702E6B08FE; Thu, 22 Oct 2026 06:24:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 637AD6B08FF; Thu, 22 Oct 2026 06:24:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3D3C96B08FC
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 06:24:14 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A0C16C017F
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 10:24:13 +0000 (UTC)
X-FDA: 85349877186.18.F73F848
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013020.outbound.protection.outlook.com [40.93.196.20])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7E8FAA0007
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 10:24:10 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=XLwrnVwW;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf25.hostedemail.com: domain of Christian.Koenig@amd.com designates 40.93.196.20 as permitted sender) smtp.mailfrom=Christian.Koenig@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792664650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oMfzdCiVCUxGHwH3OwEDew0VkRxCFE5/WZadEqnhb+4=;
	b=nY5Rd+8EcG8d052zYa7Ql13zB5vPKkxHAt46zsdB3xHqIwFuU4kghhJWfAxTOq3Ca4lQkx
	KWDoKBJ3KqJRsv1cixHWBRCdwtxj0HoGz9T1pevfPK1zIQ0vh2+lowRCzpf9rRqaTWMgic
	VRFP22shUYZO17N7ImQkYbF+NJ55+Sk=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=XLwrnVwW;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf25.hostedemail.com: domain of Christian.Koenig@amd.com designates 40.93.196.20 as permitted sender) smtp.mailfrom=Christian.Koenig@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792664650;
	b=DzZgbq0L9xLKZVn8kaZf7Qu4TOeUN1K89hX47lIJSxbTH1b+y1/oZgQIAcYjQdQwOQeKMF
	EJek7FqOFrieqr0w9bC6FDW7BjkLUwoCtM13h6haJ6z1ulXAo8c3pS1VMEBTG/BsrCpTBD
	zYzwa9iX4UVfW5kYFEFu55W12tCJy6c=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iu2pGL/9sfheZ95zjBDfeu/94IZhrqLNGmKOyEesCJr6/aalFSRwA+wK5YT/GEFvxyCkjteHH1oiqLlTMVW/EaaZjne1m7dTYNtqefx6Fz/tBvlWLTsbO8kUFL7lSG2P1belra+tv2cpyemV+XakMO1X3tANgpK+o5NUdTUujMrv+3QDATU1gC43l2BOggmzVsFIIiE5QG1e9YlwPGH/7YKpTFMGb/Cy235Aerr19zZ1oMfGT1qLqxxqXhMvcwbVs2aHepDPOhsa6TtgW+p7WJDViuWWuWKBJWpAniANiQyz8yV66Fu/XXsRacQe3EiF1yhcgo77DJOJlYmpkB7A9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oMfzdCiVCUxGHwH3OwEDew0VkRxCFE5/WZadEqnhb+4=;
 b=GMQkOdh6YSyrQmL/irmvwcbTvb3Lri6lXcwjQtC4gw7SFIf1mSHTBlpmJcA7No/m4C71hkw8SrvXeWw7N0l/0fDGT/rYwg9AuQG2nGXBhIenC6p6Bowq4nDdt8N7+RD20ufBCpWTrxsF5/DPasdUl8Pk8iM6NKPVocoQrJ2xaW8U6gEYBVrisn9sbxw5Ibqce2fCkW04+UcdfrCPxFbWdpM6AUzyuYNHRsngIua3MUdyoxjrhHlZdGFje118frjLGcl7/mJEhamb6n8eD6djafrkEltC6FoMCH0rqRreS98I9+eZdCTlX1H9stCsRbsoLyrJaIZYXFycn+mjE4++Nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oMfzdCiVCUxGHwH3OwEDew0VkRxCFE5/WZadEqnhb+4=;
 b=XLwrnVwWoZrMr5CBKjrNtDUU2sc7ANpxWSjDeFQqfVT/VAzRMy8DkiVXlGaSiI7MDXdkK5Sdg2mXCDyclvooCkH+N1e60LobeYL2RXZEdmpaO4Ud1TaMzVm1oeYoVHH16JUq5T3vOlg1MptYdFTwP8OJeargQFjTRPfk1WTW3qc=
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by DM4PR12MB5724.namprd12.prod.outlook.com (2603:10b6:8:5f::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.546.15; Thu, 22 Oct 2026 10:24:06 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%3]) with mapi id 15.21.0546.012; Thu, 22 Oct 2026
 10:24:06 +0000
Message-ID: <9e54354d-b037-47e1-9390-86d5e25444a7@amd.com>
Date: Thu, 22 Oct 2026 12:23:57 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 7/8] dma-buf: transfer memcg charges via
 DMA_BUF_IOCTL_XFER_CHARGE
To: Albert Esteve <aesteve@redhat.com>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>,
 Sumit Semwal <sumit.semwal@linaro.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Benjamin Gaignard <benjamin.gaignard@collabora.com>,
 Brian Starkey <Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>,
 "T.J. Mercier" <tjmercier@google.com>, Christian Brauner
 <brauner@kernel.org>, Paul Moore <paul@paul-moore.com>,
 James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>,
 Stephen Smalley <stephen.smalley.work@gmail.com>,
 Shuah Khan <shuah@kernel.org>, Randy Dunlap <rdunlap@infradead.org>,
 =?UTF-8?B?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
 linux-mm@kvack.org, linux-security-module@vger.kernel.org,
 selinux@vger.kernel.org, linux-kselftest@vger.kernel.org,
 mripard@kernel.org, echanude@redhat.com
References: <20261021-v2_20230123_tjmercier_google_com-v2-0-ef6ee2dd8c5c@redhat.com>
 <20261021-v2_20230123_tjmercier_google_com-v2-7-ef6ee2dd8c5c@redhat.com>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <20261021-v2_20230123_tjmercier_google_com-v2-7-ef6ee2dd8c5c@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0235.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e9::6) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|DM4PR12MB5724:EE_
X-MS-Office365-Filtering-Correlation-Id: 8cc9d2b7-f7de-4f24-44ec-08df302699dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|7416014|376014|1800799024|18002099003|22082099003|921020|4143699003|11063799006|261021135927099003|261009223027099003|261021121427099003|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	XbNar2ulZyj05LXTGfsmppGG4pYr/3defen2wZRF+QoCPpJN0HBa4KvJQy4jKJTaH5/DLjeJPWgZoBQlD5G4jiI0YiBmfFhx6oUSqk9jfaV9ugQeXfofic3f//YDTKLhDjI7YzdJCROPt1k7aSKVlsP2HUROftZODbk1QvHzPDn18+yY5C5HQrUUUstkw8ln8pNexxmUGakCcYl5cQuQ1bXvJoeOjmrMyxl3Sm/c6gIn3ZGfyfnfHNCAijWUO9JPWuCDY9eY5hNuZoHGrEh2PZTMsoXCGUYzQgQcWVHKKe7dHCNfCzAq9RHh30NznsFH4ViEw+6/3YY7xFCsZncpbgfr1CY2fD/l/oZPzvYJIJDGube9HLk7A5tzbi08GBsY+TyY6xxxh7WxLE8JiaVNckwa84vJS2Yi9cFmNd5IyiBwVRwKYp9rWUCvaJl1qF/6NAnn/2AcJJRsTD0HPTz4PTHc/bL4XE3nshkFnj09GLhpI1WLgOYmC8Dt9IxM/BvoxpU3IM1ppN5Lf20YvdFSACwgGtYDXZA/oI4E2+PpB1YER9mV4J1vecbZVeQM4hRUnI6V+r3FnLIFkATSBZwesmEFPQPNzujTNL0P4g71TukPdUpRDkJRQDuIgnUzuHsm8jH9Mh64OFe0cvZvrD/Cud3Mo7zD2O7JqNeJAJaMzyihKsa6Dk+SX7rCZcd8Eksi7/QxXB49AT18y3aWaFxkpA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(7416014)(376014)(1800799024)(18002099003)(22082099003)(921020)(4143699003)(11063799006)(261021135927099003)(261009223027099003)(261021121427099003)(10067099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TUdwaWhkZk9iK1h6dENja2s4b3JqdTlOQ092ZmkwYUhqVU1tTzdMb2E1ZTBR?=
 =?utf-8?B?eEJ6ZUk3Q1drbndmbWJwdkUwNExHYkt1N05kaW1PWnQ5UkFlYjdwN1VoYkRh?=
 =?utf-8?B?emtRMlV4RHZ0dm9FbmNqRlN3QmNBT2wyMFBCV2tiRWJKUXBlRGtPYXZ4dysy?=
 =?utf-8?B?SUxxM0tya2o2SDkvNVdVTjJPUzV4Y29ua05oZGZHY1RmdC9lNk5KaEJoUm00?=
 =?utf-8?B?TDk3ZHNSTU9tdFloMXNjZUJEUDQ0YVpvWXpYSmMwNzRiVHdQNSticzRuYkov?=
 =?utf-8?B?Vzc4WFU5UUV2akJtWjNoaEdmUmp6NURZb1lyQ3dKWm1TMU00Mm5FbHVZY1NK?=
 =?utf-8?B?YTFMSkNxY1V3V093MXliZGJCdDhGWFg4UzQvWlM4d3FLSWNjWkNJNWFNZU5L?=
 =?utf-8?B?T1A4TzNJdmR2TjB5RTRJNDlHeFhrSkdvUXJBTHdHVlVOeHBGUlFMMThFSGRE?=
 =?utf-8?B?dldheUgrSnV6R2VxMVJLVnNGUGxBMUdDcnl3QVduVXkwNFBYUXcrQmtwRjZX?=
 =?utf-8?B?RkJFZElwYk9ycm40T2NVL0I1RmxMME4xV3FWMDdVQzFuY1RPWERLbVlzaXcv?=
 =?utf-8?B?cDhvZEdQM05HanV1Q1ZzWk5mWUF5RDZjdEFURGhQcGh1RlFVeTBEbVhIK1l1?=
 =?utf-8?B?L2F1WEJscVVoTVdBeEFmU2JqNW9DU2JNSXlTQUc3Um9qaUFROUd1SWN4cEQz?=
 =?utf-8?B?MXdDMjlSZnFqMkZ2RitMKzUxSlI5bGtoTHd1c20yNFVFZ3pnNmVIcUxlUTlE?=
 =?utf-8?B?bm5BWDE1TkFvZXJFV2VnY3crZU1rREtycUd5VUhJUUZ2T0tYdFRBOFFVNVEx?=
 =?utf-8?B?bW1SMjVuOE1tb2o0azFSWXQ4bUw2NURoS2FKZ0VkZ3VpUWhmUEI3b002TS9a?=
 =?utf-8?B?a25zeUV5dTJaY3M5c09qUUlMT3pBQnBURmVzZEFJZFZGTTlnQXpBRTBDKy9i?=
 =?utf-8?B?cjBjU1ZSTW1kSjdIVnVmanF4dTZOZkpBRjdjYXBOQ0c4NXk5THdxUURIOUM1?=
 =?utf-8?B?ZHd0VjBPSFh3YnI4TVhTSGllWDh3b1RJYktSTWp5cUo5SGJXSTczdTBja1pD?=
 =?utf-8?B?cEcvNUJET2VpcGcvQzJDd0ZpZUhBS0Z3dWY1VWI3RXBpcWtlam1mNG9iUTI2?=
 =?utf-8?B?L0wrQ2JWSllWTGxqeFVpUGV0UW5XUlNUK29idFlWWjl4L0ZDZjRzTWZrVG9o?=
 =?utf-8?B?Tkt1b2dLMXhWMEs0QWZ6dFpNSUFKUmdNbmhjTlNtWHlCcjZsSVNxMmYzMzhu?=
 =?utf-8?B?dkhEN3VpWUorNzZ5ODFUM1lBTnNlcmRVZW95aTJFbzJtbXdITE9rSTBjWTZB?=
 =?utf-8?B?V3RWUzhxN2ZjdWtablZrQklHRzduYU5xdlNvWlFCdVFkWXFEbXp2dFlVdU00?=
 =?utf-8?B?SWhKeVRISXZYeWZEcUtURGtlSU5ObWtYNHUyUU1DaWN2TGQ1MS9EdHYrdXM0?=
 =?utf-8?B?UjVRVi9kMUpZUVRWNFlPVUdUS2pRSFU1WUJqT1VOK002eDgzV1ZydDZKVldt?=
 =?utf-8?B?NTNSRG5vb05NLzFrQzMrSnRvVlFCWDRVVUFuanROeXJRUFlibVgrWFFOZEZz?=
 =?utf-8?B?eDl4djlTelBlZ0RLUlFvd3lhT0pId0dDOVBnS2pxWEtqTTA5eWF3VWxjZDVn?=
 =?utf-8?B?NDI0WFN4Y0ZweXUzK0YrYkpyTXZKaUxmSjZnOVN1UTBjem00MGhqQWU5WGRI?=
 =?utf-8?B?aVRHaEZsUVVldWJ1UmQ5cVByUzBiNnY4OWlNZjBsSUVpRUl3VDUxQXBUVk1k?=
 =?utf-8?B?SHJrMWcxbXhoZS85dG1RUDluVFZyN0NZNldMK1JSaVJIZktHQ1NEam4xei9O?=
 =?utf-8?B?ZVNzVERzdk55a1NGVGtJQm5maWFMb2pOT1AzdEp5L1RyRnVFZ1JSKy9zYVZK?=
 =?utf-8?B?ZGYyT0JQWGprUVNRcFFTaHJjT2xOK2NvQTB0YlUydm41WmlkWXkrbjQrNFk0?=
 =?utf-8?B?WnJBZnBxSmlYV2owL2M4Nk1hM1pTaHNZYW1va1RpR0h1VHpvdTdoSHRpa0pP?=
 =?utf-8?B?cUxPQUdxdnN5V0UzMGFVOUdRY1V0Z1NLK3N2TmJPUWZQTyt2QjdqWGFTSjFp?=
 =?utf-8?B?QW1WN3pRaGdtUDJ6a0RxQysrSHZhREI3WGU3UFdsZUJLeTZqMDRxMk5xVjBv?=
 =?utf-8?B?STJLelRPOFVUU1FXRy9qdGQzNGtCcWpra3FNUlNiL1QwdXRzcStjeTk1Vm1X?=
 =?utf-8?B?bnVHNG1GeU82bFpxbGxjRHZlb0M2SUhLZlBnNTZOeXpNQVdOa3Rsc1IzSEhN?=
 =?utf-8?B?Qnpia05aMWlodDF6ODZ3YndJaW50ZlQ2NEFTaDBsZUNzeG5WVHpRaW10V0hQ?=
 =?utf-8?Q?NDLbMXMmb5fkP3Zt+x?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cc9d2b7-f7de-4f24-44ec-08df302699dc
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2026 10:24:05.9706
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pomOon7gX7g3TuecT060NJP+ToJ3bDALw0HT/RyQBC3Pi7zqXb6WTIFdTzBvAqoG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5724
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7E8FAA0007
X-Stat-Signature: xccpo4t6aotnsf765ekstfahgmzywohu
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792664650-192160
X-HE-Meta: U2FsdGVkX1/OwzOekuY5dTEjXScx8ewk1fQdBPT07C830+bFZJH7tFFfVrRSiMCxiI2LBfM7uiImAsluQYkTmZAN+1ePKypfaISPK8ewJNxYSMSHLxFcs9h4G6BSiukOqKc/t0jvKONYw4gQGdnLTgIY/sEtDzyvK2AUFmEN84jTX/gqoGUF1lMPFXkkq9+L8wR6VSfWTjYNR9VEcte5/AZNo1t2uv1TSzGsTa3e1T0FnbiXAQIsv5pCg7BwARjh7+Uy1NoIqi1XFdN+U5x2cm6Hc5xjldk1L+L8Jro4d1aTkAWJ2y6OTm086Zb2Q4oGJoqd8fLtDmHgVOAEClKGaDrq4zrN/SNG2KT8ckcEaW8e3hLq8SBR0h4TedROlH+UA+pbgkRFHOdcycN6dH+mO6A37+x6dOUX3LeZIuE2onXuBwUSX1UAWiBWBXXYLtOu3VhxvuW0mIxP1bKh8/QR9YSbebXlAHVWUeYogHhffWGZjiBPa3X1yKVyEFUjt9ivMMmUWPHDzGPdWQ/U4khmHep8Qrs+ZstrsFJFi+ueGhaQKOtdpcRgdzpu4JSZocCO+DSxz2VR/3eSa2kk+fVGsIYzuh5yZ5zOP0CHv9XZ4kS7ZFZzoiQp4YY88en9UQ8oirI/cYnajv6ome8NAHH4C51e4mqNyqHehChC4VEFZOpHwIboYDdxMZPOfmlhbWhAKQcivftVlf0wmC5sRcWUqjRXj1Xv3n403h6rHl3jK3jQZQKIj7VY+Xys3DA3vo+k7N+EE7FDKuA4xsTh/Nx8MnI+6PpdZc7oyUbYRtATVot9L0FTrWBG/nrkvHzoVTqV+oAyDH6u5kk0+P7pf2IA+4Zi4k0xtixts2z8jloilgUZptyJNkjEhacERsVExqu504igDZmL7Vyqw3gWUPq7lTC2UP6Mcbtk/XFXOHrePCeqOadXkn/aa7pBVPpv1nQ7MZG61K78m9JcnCOdX+y
 XZMOz8lg
 zX1KdULuwT6NCvfFB3SMF4mtXhpuX8KtmV+f9td8ypno5Rx1WYCg2q0GnoI6ptAFALVVd0okTGobnHpiT3tUoxfwSh9uJgiWxMs99ZsMoSL56YyDpXZB1OflHulzp9vYgkT+uzyRs8orwYpsMwfmZwDLAG/SuQcHOTFkmA3Itwa4gqGrNrOM9YVRrl9eW7AvRHtU6KzEhxzVb9dLLW9H2wZIi2366aAU88zOpisaS8hkAnFOsBII1l31L7d2aUqw3uY154BkR2+QLj3g0IEljwWT4TEa46rziw0nz+vVgQK+P6hcU6xuSkvYz+97FZORcHxbmN4kGqxXE7PXHF9C5F048irYkqD+WvQy1ogEfqnOJBVEPP9TX32NN+flZcbNGFt+impS/quxD3IMdUXT3KdRHBcPhtNqjlHisAyIvtb1EQ5xklS4Lzu4KcD0rbG5Le3fBl9cpy4Os/8PZsSXDrbZNQZhdqwwY6amM+47GWLUJF7iB2W9zQC+4EwmEDAAHjvSfgHW3TbVaofxBs2ZR1F6gDIuzmUxNO7vGIPx52y04XennA8K61kyAAXzvkpsmyZbapxU8sNKAs64=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/21/26 17:42, Albert Esteve wrote:
> dma-heap already supports charging a specific cgroup at allocation
> time via charge_fd in DMA_HEAP_IOCTL_ALLOC. However, dma-bufs can
> originate from any exporter (DRM, V4L2, etc.), and the allocator may
> not know the final owner at allocation time.
> 
> Add DMA_BUF_IOCTL_XFER_CHARGE to transfer a dma-buf's memcg charge
> to a different cgroup after allocation. The target is identified by
> charge_fd, which may be a cgroupfd or a pidfd.
> 
> The transfer charges the new cgroup before uncharging the old one,
> preserving the original charge on failure. An atomic cmpxchg on
> dmabuf->memcg prevents races with concurrent transfers.
> 
> Usage example:
>   int cg_fd = open("/sys/fs/cgroup/clients/app1", O_RDONLY | O_DIRECTORY);
> 
>   struct dma_buf_transfer_charge xfer = {
>       .charge_fd = cg_fd,
>   };
>   ioctl(dmabuf_fd, DMA_BUF_IOCTL_XFER_CHARGE, &xfer);
>   /* charge now on app1's cgroup */
>   close(cg_fd);
> 
> Signed-off-by: Albert Esteve <aesteve@redhat.com>
> ---
>  drivers/dma-buf/dma-buf.c    | 77 ++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/memcontrol.h   |  9 ++++++
>  include/uapi/linux/dma-buf.h | 26 +++++++++++++++
>  mm/memcontrol.c              | 40 +++++++++++++++++++++++
>  4 files changed, 152 insertions(+)
> 
> diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
> index f31f49ebd0af..7fa607d9bf65 100644
> --- a/drivers/dma-buf/dma-buf.c
> +++ b/drivers/dma-buf/dma-buf.c
> @@ -540,6 +540,80 @@ static long dma_buf_import_sync_file(struct dma_buf *dmabuf,
>  }
>  #endif
>  

A single line code comment what this is all about would be nice to have.

Some note to look at struct dma_buf_transfer_charge for details is most likely good enough.

> +static long dma_buf_xfer_charge(struct dma_buf *dmabuf,
> +				const void __user *user_data)
> +{
> +	struct cgroup *cgrp;
> +	struct cgroup_subsys_state *css;
> +	struct dma_buf_transfer_charge arg;
> +	struct mem_cgroup *memcg;
> +	struct task_struct *task;
> +	const struct cred *tcred;
> +	unsigned int pidfd_flags;
> +	int ret = 0;
> +
> +	if (copy_from_user(&arg, user_data, sizeof(arg)))
> +		return -EFAULT;
> +
> +	if (!IS_ENABLED(CONFIG_MEMCG))
> +		return 0;
> +
> +	if (arg.__padding != 0)
> +		return -EINVAL;
> +
> +	cgrp = cgroup_get_from_fd(arg.charge_fd);
> +	if (!IS_ERR(cgrp)) {
> +		/* charge_fd is a cgroupfd */
> +		rcu_read_lock();
> +		css = cgroup_css(cgrp, &memory_cgrp_subsys);
> +		if (!css || !css_tryget_online(css)) {
> +			rcu_read_unlock();
> +			cgroup_put(cgrp);
> +			return -ENOENT;
> +		}
> +
> +		memcg = mem_cgroup_from_css(css);
> +		rcu_read_unlock();
> +
> +		ret = security_dma_buf_charge_cgroup(current_cred(), cgrp);
> +		cgroup_put(cgrp);
> +		if (ret) {


> +			mem_cgroup_put(memcg);
> +			return ret;

Maybe use goto skip_transfer; instead?

> +		}
> +	} else {
> +		/* charge_fd is a pidfd  */
> +		task = pidfd_get_task(arg.charge_fd, &pidfd_flags);
> +		if (IS_ERR(task))
> +			return PTR_ERR(task);
> +
> +		tcred = get_task_cred(task);
> +		ret = security_dma_buf_charge_task(current_cred(), tcred);
> +		put_cred(tcred);
> +		if (ret) {
> +			put_task_struct(task);
> +			return ret;
> +		}
> +
> +		memcg = get_mem_cgroup_from_mm(task->mm);
> +		put_task_struct(task);
> +	}
> +
> +	if (dmabuf->memcg == memcg)
> +		goto skip_transfer;
> +
> +	if (!mem_cgroup_transfer_dmabuf_charge(dmabuf, memcg)) {
> +		ret = -ENOMEM;
> +		goto skip_transfer;
> +	}
> +
> +	return 0;
> +
> +skip_transfer:
> +	mem_cgroup_put(memcg);
> +	return ret;
> +}
> +
>  static long dma_buf_ioctl(struct file *file,
>  			  unsigned int cmd, unsigned long arg)
>  {
> @@ -590,6 +664,9 @@ static long dma_buf_ioctl(struct file *file,
>  		return dma_buf_import_sync_file(dmabuf, (const void __user *)arg);
>  #endif
>  
> +	case DMA_BUF_IOCTL_XFER_CHARGE:
> +		return dma_buf_xfer_charge(dmabuf, (const void __user *)arg);
> +
>  	default:
>  		return -ENOTTY;
>  	}
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index aa08fbb0c26c..3a6acfda1423 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -674,6 +674,9 @@ int mem_cgroup_swapin_charge_folio(struct folio *folio, unsigned short id,
>  bool mem_cgroup_charge_dmabuf(struct dma_buf *dmabuf, struct mem_cgroup *memcg,
>  			      gfp_t gfp_mask);
>  
> +bool mem_cgroup_transfer_dmabuf_charge(struct dma_buf *dmabuf,
> +				       struct mem_cgroup *new_memcg);
> +
>  void __mem_cgroup_uncharge(struct folio *folio);
>  
>  /**
> @@ -1183,6 +1186,12 @@ static inline bool mem_cgroup_charge_dmabuf(struct dma_buf *dmabuf,
>  	return true;
>  }
>  
> +static inline bool mem_cgroup_transfer_dmabuf_charge(struct dma_buf *dmabuf,
> +						     struct mem_cgroup *new_memcg)
> +{
> +	return true;
> +}
> +
>  static inline void mem_cgroup_uncharge(struct folio *folio)
>  {
>  }
> diff --git a/include/uapi/linux/dma-buf.h b/include/uapi/linux/dma-buf.h
> index e827c9d20c5d..4970a7b8e08e 100644
> --- a/include/uapi/linux/dma-buf.h
> +++ b/include/uapi/linux/dma-buf.h
> @@ -168,6 +168,31 @@ struct dma_buf_import_sync_file {
>  	__s32 fd;
>  };
>  
> +/**
> + * struct dma_buf_transfer_charge - Transfer a dma-buf's memcg charge
> + *
> + * Any holder of a dma-buf file descriptor can perform a
> + * DMA_BUF_IOCTL_XFER_CHARGE to attribute the buffer's memory
> + * cost to a specific cgroup, or move it from one cgroup to
> + * another.  The ioctl charges the new cgroup before uncharging
> + * the old one atomically.  On failure the original charge is
> + * preserved.  If the buffer has no existing charge, a new
> + * charge is established.
> + */
> +struct dma_buf_transfer_charge {
> +	/**
> +	 * @charge_fd: File descriptor identifying the target cgroup.
> +	 *
> +	 * May be either a pidfd, in which case the charge moves to the
> +	 * memory cgroup of the referenced process, or a cgroupfd obtained
> +	 * by opening a cgroup v2 directory, in which case the charge moves
> +	 * directly to that cgroup's memory controller.
> +	 */
> +	__u32 charge_fd;
> +	/** @__padding: Reserved, must be zero */
> +	__u32 __padding;

Maybe rename to flags, put before charge_fd and add "/* unused for now */".

> +};
> +
>  #define DMA_BUF_BASE		'b'
>  #define DMA_BUF_IOCTL_SYNC	_IOW(DMA_BUF_BASE, 0, struct dma_buf_sync)
>  
> @@ -179,5 +204,6 @@ struct dma_buf_import_sync_file {
>  #define DMA_BUF_SET_NAME_B	_IOW(DMA_BUF_BASE, 1, __u64)
>  #define DMA_BUF_IOCTL_EXPORT_SYNC_FILE	_IOWR(DMA_BUF_BASE, 2, struct dma_buf_export_sync_file)
>  #define DMA_BUF_IOCTL_IMPORT_SYNC_FILE	_IOW(DMA_BUF_BASE, 3, struct dma_buf_import_sync_file)
> +#define DMA_BUF_IOCTL_XFER_CHARGE	_IOW(DMA_BUF_BASE, 4, struct dma_buf_transfer_charge)
>  
>  #endif
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index e94222237d31..d994a4b2d35e 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5688,6 +5688,46 @@ bool mem_cgroup_charge_dmabuf(struct dma_buf *dmabuf, struct mem_cgroup *memcg,
>  	return true;
>  }
>  
> +/**
> + * mem_cgroup_transfer_dmabuf_charge - move a dma-buf charge
> + * @dmabuf: buffer to transfer charge
> + * @new_memcg: target memcg; caller must hold a reference
> + *
> + * Transfers the charge for @dmabuf to @new_memcg and, on
> + * success, stores @new_memcg in @dmabuf->memcg.
> + * Returns %true on success, %false if the charge against @new_memcg
> + * failed or a concurrent transfer raced on @dmabuf->memcg.
> + * On failure the caller retains its reference to @new_memcg.
> + */
> +bool mem_cgroup_transfer_dmabuf_charge(struct dma_buf *dmabuf,
> +				       struct mem_cgroup *new_memcg)
> +{
> +	struct mem_cgroup *old_memcg = READ_ONCE(dmabuf->memcg);
> +	unsigned int nr_pages = PAGE_ALIGN(dmabuf->size) >> PAGE_SHIFT;

That doesn't work as easily as this.

DMA-buf can contain litterally *anything*, ranging from system memory over device memory all the way to functional HW blocks. In other words doorbell, GWS, GDS, OA, I2C, I2S, any random data consuming or providng HW block...

For memory the "size" is the actually number of bytes the buffer represents, but for everything else it is just an arbitary number given by the exporter. In most cases just 1 or actually number of HW blocks/channels, but for GDS for example it is actually a pretty large number.

Saying that you most likely need some flag from the exporter if charging and/or the changing of charging should be possible or not. Otherwise you can potentially do quite a bunch of nonsense with that.

Regards,
Christian.

> +
> +	if (!mem_cgroup_disabled() && try_charge(new_memcg, GFP_KERNEL, nr_pages))
> +		return false;
> +
> +	if (cmpxchg(&dmabuf->memcg, old_memcg, new_memcg) != old_memcg) {
> +		if (!mem_cgroup_is_root(new_memcg))
> +			refill_stock(new_memcg, nr_pages);
> +		return false;
> +	}
> +
> +	mod_memcg_state(new_memcg, MEMCG_DMABUF, nr_pages);
> +
> +	if (old_memcg) {
> +		/* Uncharge old cgroup */
> +		mod_memcg_state(old_memcg, MEMCG_DMABUF, -nr_pages);
> +		if (!mem_cgroup_is_root(old_memcg))
> +			refill_stock(old_memcg, nr_pages);
> +		/* unref from buffer - buffer keeps new ref to new_memcg */
> +		mem_cgroup_put(old_memcg);
> +	}
> +
> +	return true;
> +}
> +
>  /**
>   * mem_cgroup_uncharge_dmabuf - uncharge a dma-buf from its memcg
>   * @dmabuf: buffer to uncharge
> 


