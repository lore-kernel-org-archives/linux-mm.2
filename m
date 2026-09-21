Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D29C6C982EA
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 02:29:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34AC56B0099; Sun, 20 Sep 2026 22:28:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AC436B00E7; Sun, 20 Sep 2026 22:28:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D82E6B00E9; Sun, 20 Sep 2026 22:28:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C58F16B0099
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 22:28:51 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 089FB1A04F6
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 02:28:51 +0000 (UTC)
X-FDA: 85236186462.16.5995416
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012045.outbound.protection.outlook.com [40.107.209.45])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3DD0C40007
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 02:28:48 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=BHzSHgRa;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf11.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.45 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789957728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vPq71KQaAOBJ6HXf0FB3D1N+8QOENtxdWLUdCeBflGA=;
	b=kA9aUnZDrB0QFkt+PAWIWfoh2Ir1J9VDF43F/QhhIcthBQZpFw+zHTWVw6hj+0fRmMD3Y8
	PTq+oVpQ3Ix3vqGYb3T+zVBofPH90j7GT3EKlKkHJP8lP5mm6dnjfL8SfBG3oh8gzSCaC/
	2qmqZR9Ioxr2mqqxCs8o6UE1+Fk9DdQ=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789957728;
	b=SR0d+Hy+civIuo6Kmarc2rdz9MulppqP8D0I0qWtoJfkqVDXImGwpXU9LP99JN/MYKybCK
	xWpDV3+C2RxoyHH+yoqCS4C2qCAU2OW0N+/q36N5ecViOUfn9kXG6dIKD1CPacLKe+tV1e
	/kx3wZnG/A79iaWMLSsJGbz+e96BbDY=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=BHzSHgRa;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf11.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.45 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rRKJloJHUOQPtBkCkwATuE9nTpv7QekY5fFTEPPLOs+a8PeOsVu8XxC3zz5LHs6cZNMe9qfUZlpDdbk5yQ92HHthS/Ds0gTcXtNg0416a9hdcRMXqZWq+g7C5kUIlLtTsTy/23HcjpF9dvh7LrT266S+Sb4zlGjrfVPV45ntKqNKfsrbyAf/CSCAfZ/MnFkR778KEkhcHM4gLOseQX0c0ECv6EZUXHpV7NEiutNPlvHcUd7OnV/dhigv6tWMwgFneocgrDHoafN4hq4X2t4mxqUidRjea0iXrosonNkWzmFA6PtoHfku6YeA/EnNu8mHb2XmLriDf+JMk8YjY6N91Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vPq71KQaAOBJ6HXf0FB3D1N+8QOENtxdWLUdCeBflGA=;
 b=ThIecJwcb3ikmBrUK/CoIYqmKz6+6zmGaJ/7ANIKFWgvmQ7HjosfkpWqY1+32BC+0pNGEzeC22gbYGxEoXSHHp2nSB72wL91wPSE1FHMRBe8DPF33aZ+FLXVWH4mNpV2DZttvdTzQhAjeXXLP28lLiAenEXc0jO956XRXe8ysbz0LcUfuuJ3hiviho1tTdcSCba57hvEfrNwyeMNsNdNS2c6Y8cy/UTui9GUmQ++1gG3vgrDew2oxdNFzSwk1ovUNaChJr9JdjyPqPJAOMoZFfcoqyVM2JZJvXKDajzYAm4Qb7ZCkjcwHg8/SWTKB65Rm/XGcjvRLEfRs1r7cHiHQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vPq71KQaAOBJ6HXf0FB3D1N+8QOENtxdWLUdCeBflGA=;
 b=BHzSHgRa4rWKI1o8FE4fMe8sEdCvYjfbUyh1o8Zo6PUSh6bhvcooavxZiuJf3enM8HoFQ6Hy8aLRQMrj6321aUNUBOi9+ZYlc7JdhssYXqlCJOjch3vDLxEGLcs93JqaFg47FBD7CNsEvkJvbYDXkL6W1Jb6SMWBxo8KVyj+I1+BsgiHXnOr97e72mbZnb3hneXFdqYT9jZZpFU4AQ7zIo/xiQM3ou6t8OqF0YupZZMK4mgemT5ZfSXey01jTsUbXYVa59TdO5VqoC9pizYb/LLKuvISJxT3q35j3j4K/qabYyhBY3unsXq3pE05804zTthEraB216DIdGmC623kiA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DM4PR12MB7719.namprd12.prod.outlook.com (2603:10b6:8:101::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Mon, 21 Sep
 2026 02:28:34 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0428.014; Mon, 21 Sep 2026
 02:28:34 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Sun, 20 Sep 2026 22:28:06 -0400
Subject: [PATCH v5 10/17] mm/page-flags: check page/folio->private instead
 of PG_private
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260920-remove-pg_private-v5-10-bb68b6a21869@nvidia.com>
References: <20260920-remove-pg_private-v5-0-bb68b6a21869@nvidia.com>
In-Reply-To: <20260920-remove-pg_private-v5-0-bb68b6a21869@nvidia.com>
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
 Zi Yan <ziy@nvidia.com>, Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, Jan Kara <jack@suse.cz>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Byungchul Park <byungchul@sk.com>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, linux-fsdevel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org
X-Mailer: b4 0.16.0
X-ClientProxiedBy: YQZPR01CA0114.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:83::25) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DM4PR12MB7719:EE_
X-MS-Office365-Filtering-Correlation-Id: 62c4a13e-1050-4bf2-0dc4-08df178808f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|23010399003|366016|921020|6133799003|10067099003|56012099006|5023799004|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	+jFAluaXycDzKyIehr/Mk8RdYNbDzGx7Glh2ltGBaTHyj89nx/3xVKA9V5Haox5lpObks9JimPHEbAPCYzs98H4IC4/QIuCmycmIyYUIZjHLYtpQjpOHiotc4uY/6JySPK5x8aCa2akQf4FxEPi4GnCIpk4Sz0VmYYMGdDl64Ko348zspxdQ2pDPPCYHdFjX0ZFRAfjkqAGk/YxqB/pcg+MTpgNWVsLaBeODoqc1xCi96XafvYNrYnxPDHz2E5fbsIS+modr7ZUZeDdzlT4cBBClBM+e7HNPl+SfDgaBsHJBLN0AM2vVjKUOp/OeLhEX7ssqnXvXylIPgGb6vzxnU5/+btZ33alTIv/PuIYz0RwNTibR5DWrJ4EE+AJFLqxO1WAed25zBTminvykDd3eRxU8CoZOgxjL+OTv8GkEmcdoW31mqmtqGZNXxAZhaXUGxbR7u2nXgzRLkN41DoFajQal3e/CUdfw76Y4RmnBfAcYeoONs4rKhYcw67NZwo8kCVBMYTs1CkJOx1mJkHs4cGaJGCHUdMd2fwmcDIZOI6+9Kq23vUq2osNJsJjj/x52Y9bi94uIV63xOpTi7THsXPlS6xqeAdL7v8kPbWa9WQrwpdke+ofyYOTjGFpEnN8ft917WwEMhU36rS463H0hChBqwfcMZQbLvxxZwNcXMP8RsqW2Zwbyvb6yHLiba53xjQ4466fMfZqXnc3zAUq4wQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(23010399003)(366016)(921020)(6133799003)(10067099003)(56012099006)(5023799004)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d1czalI2SWd1NkRGVDNaaUxxaWNVWUJwWVNLYy9LYjMwS25XTG85SGFFdlVz?=
 =?utf-8?B?a29xSHgzVDkzRHVkQ0RNRTV6WnJNWTEwbEswaUJXWDlWRUZKN3hoaVd5ZTFU?=
 =?utf-8?B?RE1KT0JxV1NPVGFwOS9TYVRaK04wQkkwT20wbDk3VXdZMUlmZHp2ZS9iSFlt?=
 =?utf-8?B?c01wMFFVSHlPd2lXbXkwYUp6Z3d6aXllbUhjYUJWNDk1eVUyT2gyR2xPU3RQ?=
 =?utf-8?B?TWp1a0dGVnN1MTd1Q3lUNW9rZ1NaUjBtbFhxY3ovWkpMRk9VekNzaUQzdU53?=
 =?utf-8?B?OWxvbW5GRGliUWpReHhaV3k1M2FnZ01LQ2x1RmtlY0p0UmdhYUd1ZXNUTW05?=
 =?utf-8?B?Y29QeXVEdkFobTcxV01KUmhVRUJVSHNtQjZaRjlJU1dsb0R2QzczRDQ2ZjRh?=
 =?utf-8?B?eStSaDhkMVYrVmZ2aGF0UG50dTc1MmN2d3hZenBEaG5HSGw2TzNUTnVDTmlG?=
 =?utf-8?B?RTI2M1ZWamhlRFZwTm0rRDVjNC9maUdjSlBXK2NncWs0akhVcEZCZXZRTjdG?=
 =?utf-8?B?R0VJanFoczFyWmxoSzRZUUdsUTg5UC9DaHJsK0I5bTdxRkt1MFd1MC9QY2NF?=
 =?utf-8?B?NDROd2tTVzFhN2NVaUJYT1J3Q3F5Skk0bDJlU2IyeEtDdTU0UmdzdmlDRGtQ?=
 =?utf-8?B?UUhzWU5TMzdBUjBrejJoMllPRWcyQUFSWGNIU0lLRFNBZkxrWGJLZzVkZFBw?=
 =?utf-8?B?Vk1EWHpHblNXUGY2SmNKc0JUS1JkTGY5VDF2WmU4Y0t6YWNUamF0ZjYwNDRm?=
 =?utf-8?B?M1QvUno5Q1l4VHNpSC9tN3VBUjNyYmFtczdYVWw1OGJqdUNQY1hOaFlvQTM3?=
 =?utf-8?B?bDk2Wng4V3pmOE5XS2daK3l2NVMvUVZpeXhROHBxREZDdFdNOWdHN3VXUUFP?=
 =?utf-8?B?MTN5YjdLRGR5cmlheDN1dERIeGwvRTRWaWxDVmNXdFVCbGR5NEl6Z0dPaSt4?=
 =?utf-8?B?dFNGdWJBalBNdkdhUFlWak1NM25xNTFSa09aMkNzZDNaTGlKZk92ZHpOYjhZ?=
 =?utf-8?B?U1gyWWhCd1hRT1dyUGNYWlRPYWhtWWV3Q3hwVlR0R1hzZ21sMEhrZ0JxWDNy?=
 =?utf-8?B?QUNQMm1tUDgybnU5RE9iSlVNOTk1Wlh0RmlPZjhaS2dDQzdKOTRxOXFQWmJZ?=
 =?utf-8?B?SWwyNHo0Mm5nY2tRWjNUNVkwWTM1V1gvc1hBZGJxRjN5Z1NadC9TS3BaR2pr?=
 =?utf-8?B?SUE2TmgvSTJ6dVNNUVR1eUIvdEFJZE5DSnM3dEtZWmhMai9JdEx5bUQ2aklD?=
 =?utf-8?B?SWV4eG9yQ0p4OVBPenZzQkZrekNQTzN1M1lFUEU3cnZYWEQyY3c0Q25kZTZZ?=
 =?utf-8?B?eVFxMk54ZE96QUduZXdYMERqN01yVEVvdW12dWREYk1XbWo4b3EvQzNRYm93?=
 =?utf-8?B?QWJpc2dIcVI2WjRRdWl0Zk4wRDlzR09ybzdnNUluYml2R21TOHpKYm8yR3ND?=
 =?utf-8?B?TzdhSHkzZXR3ZUVGZnlmSFpuZXZvT0gvejVWd1FTN3BiVTJIazVDSHhuVzBE?=
 =?utf-8?B?RHVJQm9pSGxXb0hETG5oc1JBK1g3eEJLMTU5bkQzaHRsSk9Qb0V0eEdsMExw?=
 =?utf-8?B?QWZudmEwZHZhT0oyc0tmM1dHYlFoNyt4TGZ3SGFVTE1MMDR6MGY2cjdTR2VG?=
 =?utf-8?B?bEJKeXlIaWQrUmpqSEVLQ1YvbEZhamFRakViS0hucXBGWUdkTGJyM2FYTVI5?=
 =?utf-8?B?NmJpck1QNUFRcGdyVmJMVHNZNXpadEZraXhyTEhDSFFEOUpTM0QvVGs5MFM4?=
 =?utf-8?B?WDMxRnpGQzdoL2RrTXNxYVdlWjZNZWhnUnlGQjlNWXhHc2EvUERnanlMQTVF?=
 =?utf-8?B?M296VmRFUWNIenp3bk9wWVltdmJNMkFMVFNTQnVDbkc5Uk5KVFA4OGpvVndD?=
 =?utf-8?B?V0tkQU5qbWdaSUpiZGsxQm1USll6WEFzVlBOaDRCcGFZSVpCWlZqaVFLem9O?=
 =?utf-8?B?Q2g2QVFLQk55NDh2ZzhNS0g0cnlGODNRMUw3bmFDZ29RM1Yydi9FMFhsZm5n?=
 =?utf-8?B?cWZzOXZSSVh1TFRtcEIyK1VzR1VwbTFkeFMwRklNNlNKYnIwa05aek9TUld1?=
 =?utf-8?B?UVJRUVVWS25SSnE1N3Vjc2hZaU5ZSFFySDNvbXhkZkJER1lmMTRtZWxzOTJj?=
 =?utf-8?B?ejVqM0tiK2xOcm9NZm9SaDVvZHRlaHRkY284V1BDUjV4Z0pob0MxTkMzRm5U?=
 =?utf-8?B?K0VpWUl3M2x0c1FSdVc3V3JORE1OVW5OVkJRbURob3ZkSkZDOXZ3OTQzeE1Y?=
 =?utf-8?B?bHpKeDk4dmVIWTlpbExpZTBFNUQvQ0tERU4xbGNGejN4QVdMNjdBYUZXZUFG?=
 =?utf-8?Q?wYVROZLO6H+hwc/9/Z?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62c4a13e-1050-4bf2-0dc4-08df178808f4
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 02:28:34.4111
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1Uk5hIE2g6tAA16M/iTqH+o+K5CRp2SZDk3+3licSqdmh7xcbQJ68VcFrfj46ihh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7719
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3DD0C40007
X-Stat-Signature: eod36y5rd9gaupfpusg49pamkuysfcch
X-HE-Tag: 1789957728-356944
X-HE-Meta: U2FsdGVkX19b4o7oRbJgWNIUhO+Bg0k7oUnYOYbD3IQe7fP6z8W7BPfvJ0/gRUWWkAKweo1qQtfKFT3RFnNYN+Pbzh870yuK9OHN9lrq9GGdjXkLi1uDgOEjzFn43vSdPOnvgLdDck+FlijQNTCvy0zgs18H4D/afvV86h2YbhI6qnAk26G4Ql5Bo+DoK1cN+jWonxzVryh3KI+CtYnMiskpcGBWZHS2mSPMHUtUcsi1IqTVHuTiZDS7Yr/3ABhOUChDO4Bsjy8DJOMAITlbticG4hEPpOMGyRX4NpFVjttXtj8PoJ9P886v0ciJqQg3+0ZxA5Lj3ixlNCzWoP0PPbQwUegKmnIYdxKuIv61Zl1E5jlEO9IvQpRKuvgJZqs4CrdT+2cmC3lVkD4zOaFcdYRBGU00d2dDZS0H0LqATA7J2pBGWMXFZmi25oPVhqOeUhUPxO5rC93hiqOI74CIxQgOdsEp9aG/qo2B2pqNOAbSVMiQqxGNw7Mtz934PG/J8tlqH6JWVFHlwPRSdcaegG+QgEUpZxzWxLghJ8IW89bUAriV9dI9yYfvGTmrB2kFsZ4CvjBsxllbro5IR60SDEZoga5A9dD+ewBXV+O6Gv4+hbXJRT19eIP2zb8mcQTfXNTQW//2HzhamyX1oRXGhvJHa5CONH1IN/l7/8SNRL9sl5+o1AlTeP9w7NGRxdoyIR2bKlDiZDVmD8wt/720RvL3BdlnFzLWQQp9hR1mAf23U6zumKL/PTj/BkuYDierY/VTG+12Vd2ngzwMNXrcqw9qbid86TUIGI8VFiq3hNB1PwQ4nuesewQ4HibiQQqpvZVotT14y2z5GlvYLroxMWZ1DQ311LMpqB8vPdJdQiuwF0DOmUm9SYlN/IDS1UR52uobvZBfDFjBnQ7xAD+CfCptRArQ7cLNwBirkLXExyVmSaNtHBh31jXpFYXmmWm+YRSdeGzRRrqyXhLDGhv
 0q4tT50q
 3pXYZpEb1E21oJlQ2clXcUCm74b3TC5zdRCnX/niRnQiuw0TlVyQC+NWiwfF+zGrKJhThSgA0dW0fZBxxkPaAv8FCemhlXDVe1yFnzGjk4bXnKNk/3pI6Gjxu+3WFaTOxNomr904gLcpzTbhS6m5NuggkIMzFb/W/fPrBnbQKoNtWn1NJy/A549IYA2kss65jfY/p/gzvaBbowTUic+rxajznNwWYmLZIJj4rVApIV+uwQFy2qdX6Xm96EAQ83p1iZvdX+rJXdD2VFuJXP79kz5Sts3njB3bHlv3CFMbIWL9ek5Kt70VqmmtXkm2tGFBz0lH426YlrzGyQgSRcb8dgZ2hvFRwSrulYeEruZFPd2SgOnlWiIZ7nbdGnIrQVgDXA3SxzW1N8jnL91nzJFBTkoo/DKdy5HdzOhUjBiQK8z8nupMmnj9BUJBMmyGGrFVWrHrF1d6isMVVtRh+tWb0KUoJlboXiuQ0Rx7ERGIwjNV8dZbAdade5y2TuNCzPPGhmZQWKHVxYfOxk0N6KY9O7K7zBAlORMtn4eWSxsAhOTTHdzmBdLkLWwI0Ar9zRQJCgnMBxxP4qmP3G83C8i/HRUS1+pf8q2H36M3TOliocqS4fcuPJ1mVMP8v32mbJruG4LiEQpcJCWdKed2msHrVlbNKL9lS/F4tcWlZhRIjlvXJfqtr8rriCtfZwNMqJ4a5HvfxK5muYvOFG8SgWH6grWqTIW3sJ0zxkjfDUyQTpzuhukWejJUlLrqxZxkszWBGiCDwfE71WMjXEnO496PeAs68F4sIwH4oRqKlI1rDOvmpPdPSeMtF/dJDxpIjQmsFinTU6dBy3yjLlG9TFtNrhgQ3PiekGY346GbGUi1u/8/oXVHSW7DQUmR9SuQprjo1UfvjaJ/Wa9C+5/ShXWjzHWNHpDGixuPJViS1izArlNtwW2Y0loWhTSKTkuOfJ+VTUMZf2D2WUm4yDQW/o+AZ4IFElPUe
 3MKkBkxD
 u3HIpGZMQKgs5UnCmvXos68FTiqq4TAjT4CuBCSFTos87u9nDqC3VAmv2TtDMFkFP/N/hphVjhPdllstM64vPIDTHW7jTP1ISf6fYlVJvBlOAC6kz24cXuKPKz3l7MvV3hNkNL+dbDdHLMK8FV66xw0IK5CPV9yT9gTdZ8EccD10s2uvMXDoR+SucoFmRxuD2M9J/JjrieBF3XU6KwkPGQqmLQNyX0t6zOlPUElg2qRUbdE1ccVlNnggSM5AmiyyXQYpWjWOaJak7M2vLz0ycw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

After the changes of the prior commits, page/folio->private != NULL is now
equivalent to checking PG_private.

Stop checking PG_private on pages and folios and use page/folio->private
instead, except swapcache and hugetlb folios, because the former uses a
field (swp_entry_t swap) overlapping with ->private and the latter sets its
flags in ->private. Exclude swapcache and hugetlb when the code is meant to
check PG_private only. PG_swapcache and folio->swap.val cannot be set/clear
as a whole, so excluding swapcache with folio_test_swapcache() is not
reliable. Instead, use folio_test_swapbacked(), since PG_swapbacked is
stable when a folio is added to/removed from swapcache. Add a helper,
folio_has_attached_private(), for this check.

folio_test_private() and PagePrivate() now read folio/page->private plainly
instead of an atomic read of PG_private bit, so KCSAN complains about
possible data races. Annotate them with data_race().

folio_expected_ref_count() can be called without the folio lock, so
annotate folio->mapping with data_race() while at it.

folio_set/clear_private() and Set/ClearPagePrivate() become no-ops.
PG_private is no longer checked at page free time. They will be removed in
an upcoming commit.

Remove KPF_PRIVATE since PG_private is no longer used.

Assisted-by: LLM
Signed-off-by: Zi Yan <ziy@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>
To: David Hildenbrand <david@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <mhiramat@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Jan Kara <jack@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Liam R. Howlett" <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Kairui Song <kasong@tencent.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: linux-trace-kernel@vger.kernel.org
---
 fs/proc/page.c                    |  1 -
 include/linux/kernel-page-flags.h |  1 -
 include/linux/mm.h                | 19 ++++++++-----
 include/linux/page-flags.h        | 57 ++++++++++++++++++++++++++++++++++-----
 include/trace/events/pagemap.h    |  2 +-
 mm/huge_memory.c                  |  2 +-
 mm/migrate.c                      |  2 +-
 mm/page-writeback.c               |  2 +-
 mm/vmscan.c                       |  2 +-
 tools/mm/page-types.c             |  2 --
 10 files changed, 68 insertions(+), 22 deletions(-)

diff --git a/fs/proc/page.c b/fs/proc/page.c
index 260772b20bd99..f90e1030825e9 100644
--- a/fs/proc/page.c
+++ b/fs/proc/page.c
@@ -232,7 +232,6 @@ u64 stable_page_flags(const struct page *page)
 
 	u |= kpf_copy_bit(k, KPF_RESERVED,	PG_reserved);
 	u |= kpf_copy_bit(k, KPF_OWNER_2,	PG_owner_2);
-	u |= kpf_copy_bit(k, KPF_PRIVATE,	PG_private);
 	u |= kpf_copy_bit(k, KPF_PRIVATE_2,	PG_private_2);
 	u |= kpf_copy_bit(k, KPF_OWNER_PRIVATE,	PG_owner_priv_1);
 	u |= kpf_copy_bit(k, KPF_ARCH,		PG_arch_1);
diff --git a/include/linux/kernel-page-flags.h b/include/linux/kernel-page-flags.h
index 196778a087c4d..fe5ab6e50bd70 100644
--- a/include/linux/kernel-page-flags.h
+++ b/include/linux/kernel-page-flags.h
@@ -11,7 +11,6 @@
 #define KPF_RESERVED		32
 #define KPF_MLOCKED		33
 #define KPF_OWNER_2		34
-#define KPF_PRIVATE		35
 #define KPF_PRIVATE_2		36
 #define KPF_OWNER_PRIVATE	37
 #define KPF_ARCH		38
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 66d384da4433b..d9392ac8dff9f 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3004,9 +3004,9 @@ static inline bool folio_maybe_mapped_shared(struct folio *folio)
  * @folio: the folio
  *
  * Calculate the expected folio refcount, taking references from the pagecache,
- * swapcache, PG_private and page table mappings into account. Useful in
- * combination with folio_ref_count() to detect unexpected references (e.g.,
- * GUP or other temporary references).
+ * swapcache, private data (folio->private != NULL) and page table mappings into
+ * account. Useful in combination with folio_ref_count() to detect unexpected
+ * references (e.g., GUP or other temporary references).
  *
  * Does currently not consider references from the LRU cache. If the folio
  * was isolated from the LRU (which is the case during migration or split),
@@ -3044,10 +3044,15 @@ static inline int folio_expected_ref_count(const struct folio *folio)
 	ref_count += folio_test_swapcache(folio) << order;
 
 	if (!folio_test_anon(folio)) {
-		/* One reference per page from the pagecache. */
-		ref_count += !!folio->mapping << order;
-		/* One reference from PG_private. */
-		ref_count += folio_test_private(folio);
+		/*
+		 * One reference per page from the pagecache.
+		 * Use data_race() since folio might not be locked.
+		 */
+		ref_count += !!data_race(folio->mapping) << order;
+		/*
+		 * One reference from filesystem private data.
+		 */
+		ref_count += folio_has_attached_private(folio);
 	}
 
 	/* One reference per page table mapping. */
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 7080a6a1a79e7..6d839f50bdcb7 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -575,9 +575,31 @@ FOLIO_FLAG(swapbacked, FOLIO_HEAD_PAGE)
 /*
  * Private page markings that may be used by the filesystem that owns the page
  * for its own purposes.
- * - PG_private and PG_private_2 cause release_folio() and co to be invoked
+ * - folio->private and PG_private_2 cause release_folio() and co to be invoked
  */
-PAGEFLAG(Private, private, PF_ANY)
+
+static __always_inline bool folio_test_private(const struct folio *folio)
+{
+	/*
+	 * data_race() is added for readers without holding the folio lock.
+	 * Only the NULL/non-NULL answer is used and both are valid while
+	 * private is being attached or detached, so the race is benign.
+	 */
+	return data_race(folio->private);
+}
+
+static __always_inline int PagePrivate(const struct page *page)
+{
+	/* See folio_test_private() for data_race() use */
+	return !!data_race(page->private);
+}
+
+/* no-ops during transition */
+static __always_inline void folio_set_private(struct folio *folio) { }
+static __always_inline void folio_clear_private(struct folio *folio) { }
+static __always_inline void SetPagePrivate(struct page *page) { }
+static __always_inline void ClearPagePrivate(struct page *page) { }
+
 FOLIO_FLAG(private_2, FOLIO_HEAD_PAGE)
 
 /* owner_2 can be set on tail pages for anon memory */
@@ -1169,7 +1191,7 @@ static __always_inline void __ClearPageAnonExclusive(struct page *page)
  */
 #define PAGE_FLAGS_CHECK_AT_FREE				\
 	(1UL << PG_lru		| 1UL << PG_locked	|	\
-	 1UL << PG_private	| 1UL << PG_private_2	|	\
+	 1UL << PG_private_2	|				\
 	 1UL << PG_writeback	| 1UL << PG_reserved	|	\
 	 1UL << PG_active 	|				\
 	 1UL << PG_unevictable	| __PG_MLOCKED | LRU_GEN_MASK)
@@ -1193,8 +1215,31 @@ static __always_inline void __ClearPageAnonExclusive(struct page *page)
 	(0xffUL /* order */		| 1UL << PG_has_hwpoisoned |	\
 	 1UL << PG_large_rmappable	| 1UL << PG_partially_mapped)
 
-#define PAGE_FLAGS_PRIVATE				\
-	(1UL << PG_private | 1UL << PG_private_2)
+/**
+ * folio_has_attached_private - check if the folio has private data attached
+ * @folio: The folio to check.
+ *
+ * Use this in code that may encounter swapcache or hugetlb folios but only
+ * wants to detect attached private data.
+ *
+ * Return: true if the folio has private data attached.
+ */
+static inline bool folio_has_attached_private(const struct folio *folio)
+{
+	/*
+	 * Swapcache stores swp_entry_t in folio->swap, a union with
+	 * folio->private, and hugetlb stores its own flags in folio->private;
+	 * both are excluded.
+	 *
+	 * NOTE: For swapcache, folio->swap.val PG_swapcache are not set as
+	 * a whole, so folio_test_swapcache() is not reliable to exclude
+	 * swapcache. Use folio_test_swapbacked() instead, since it remains set
+	 * when a folio is added to/removed from swapcache.
+	 */
+
+	return folio_test_private(folio) && !folio_test_swapbacked(folio) &&
+	       !folio_test_hugetlb(folio);
+}
 /**
  * folio_has_private - Determine if folio has private stuff
  * @folio: The folio to be checked
@@ -1204,7 +1249,7 @@ static __always_inline void __ClearPageAnonExclusive(struct page *page)
  */
 static inline int folio_has_private(const struct folio *folio)
 {
-	return !!(folio->flags.f & PAGE_FLAGS_PRIVATE);
+	return folio_has_attached_private(folio) || folio_test_private_2(folio);
 }
 
 #undef PF_ANY
diff --git a/include/trace/events/pagemap.h b/include/trace/events/pagemap.h
index 36c3a90f0acca..5d47b774633a4 100644
--- a/include/trace/events/pagemap.h
+++ b/include/trace/events/pagemap.h
@@ -22,7 +22,7 @@
 	(folio_test_swapcache(folio)	? PAGEMAP_SWAPCACHE  : 0) | \
 	(folio_test_swapbacked(folio)	? PAGEMAP_SWAPBACKED : 0) | \
 	(folio_test_mappedtodisk(folio)	? PAGEMAP_MAPPEDDISK : 0) | \
-	(folio_test_private(folio)	? PAGEMAP_BUFFERS    : 0) \
+	(folio_has_attached_private(folio)	? PAGEMAP_BUFFERS    : 0) \
 	)
 
 TRACE_EVENT(mm_lru_insertion,
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 30b7c63b0e359..8aa2daba37391 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4846,7 +4846,7 @@ static int split_huge_pages_pid(int pid, unsigned long vaddr_start,
 		 * will try to drop it before split and then check if the folio
 		 * can be split or not. So skip the check here.
 		 */
-		if (!folio_test_private(folio) &&
+		if (!folio_has_attached_private(folio) &&
 		    folio_expected_ref_count(folio) != folio_ref_count(folio))
 			goto next;
 
diff --git a/mm/migrate.c b/mm/migrate.c
index a369d0c95c386..b7b92925a28c3 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1327,7 +1327,7 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
 	 * free the metadata, so the page can be freed.
 	 */
 	if (!src->mapping) {
-		if (folio_test_private(src)) {
+		if (folio_has_attached_private(src)) {
 			try_to_free_buffers(src);
 			goto out;
 		}
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index eeab25d6ce364..499a35473e4f3 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2705,7 +2705,7 @@ bool filemap_dirty_folio(struct address_space *mapping, struct folio *folio)
 	if (folio_test_set_dirty(folio))
 		return false;
 
-	__folio_mark_dirty(folio, mapping, !folio_test_private(folio));
+	__folio_mark_dirty(folio, mapping, !folio_has_attached_private(folio));
 
 	if (mapping->host) {
 		/* !PageAnon && !swapper_space */
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 80041e2b8049c..dd6261c862794 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1029,7 +1029,7 @@ static void folio_check_dirty_writeback(struct folio *folio,
 	*writeback = folio_test_writeback(folio);
 
 	/* Verify dirty/writeback state if the filesystem supports it */
-	if (!folio_test_private(folio))
+	if (!folio_has_attached_private(folio))
 		return;
 
 	mapping = folio_mapping(folio);
diff --git a/tools/mm/page-types.c b/tools/mm/page-types.c
index 7fc5a8be5997f..47e4781c5fc38 100644
--- a/tools/mm/page-types.c
+++ b/tools/mm/page-types.c
@@ -73,7 +73,6 @@
 #define KPF_RESERVED		32
 #define KPF_MLOCKED		33
 #define KPF_OWNER_2		34
-#define KPF_PRIVATE		35
 #define KPF_PRIVATE_2		36
 #define KPF_OWNER_PRIVATE	37
 #define KPF_ARCH		38
@@ -131,7 +130,6 @@ static const char * const page_flag_names[] = {
 	[KPF_RESERVED]		= "r:reserved",
 	[KPF_MLOCKED]		= "m:mlocked",
 	[KPF_OWNER_2]		= "d:owner_2",
-	[KPF_PRIVATE]		= "P:private",
 	[KPF_PRIVATE_2]		= "p:private_2",
 	[KPF_OWNER_PRIVATE]	= "O:owner_private",
 	[KPF_ARCH]		= "h:arch",

-- 
2.53.0


