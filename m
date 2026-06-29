Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C226CC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 02:57:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78D816B0092; Sun, 28 Jun 2026 22:57:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 717676B0093; Sun, 28 Jun 2026 22:57:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DE656B0095; Sun, 28 Jun 2026 22:57:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1B4E66B0092
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 22:57:05 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5DC361C66E8
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 02:57:05 +0000 (UTC)
X-FDA: 84931438410.09.CE03F16
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012051.outbound.protection.outlook.com [52.101.43.51])
	by imf27.hostedemail.com (Postfix) with ESMTP id 956B540002
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 02:57:02 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="TkP5Zd/2";
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.51 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782701822;
	b=ZE+VRhd5Zj2DL3HXANMwBwbDSf4o8/jnWfY4aqa2j00nVICTLmNi2ViK+Y2y7eHcP3uhwd
	aA0htl0PgvYDF1UIhTlJTH48hqbVWPh6eaCJ5N4x8+QRBcJkz+4YLYRdCXHjRZc6bY3o82
	OEd9VirRATjwZaTOu+elSzZiv+0Sd94=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782701822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bKyuHXQiUp+qz+v81Ek9nMG+4duw+7LltRepBBsyxsE=;
	b=PEoXOH4JitG5H1IHyJiOqrvC+gvK3K3V/2RgmQr33/2dixA36H/ZeWyykbRYmUdVXE2NVW
	VC8uR95N/VzbdlnY/hx/npoxCIqJoRxgk7JBGZlDVAyaBwtmxAn8Lx0tGWkna05F83pUMl
	QboyV7s6eqXEXZGq9zsxWlISt+7FIFQ=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="TkP5Zd/2";
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.51 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GZcd2X9iVAQH5hxINg7YW1WwTMoyyyddHjxzhpsa9+GrTrHcJCQzWRyDqNiIy4igGI8r0UU5JVf+l3YFteXMbyMatFd2QV+bpHGZWi1FBJgCEaC2PwG8iuvefeGhUnuzebq51DRj09NUUU+GcfsRYlzXtTMFxbROBMwpNlZ9jmFrFUuhntPpnQAytLgqLllfnQe+3jC1C2SMDRHPnfWtV3vdmUDwx1NMUdbS3t4cfiOMThk3IZF8UW1uxQkqqNbPvel02zN9elKWUjyOkr1mw8IZFSJodbHiGX/U1zt6UVZe93ofKpiGHVGgTuxs1FXSQIfGj0rXn9L2vDRLG3b+Lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bKyuHXQiUp+qz+v81Ek9nMG+4duw+7LltRepBBsyxsE=;
 b=u2RB3wFXBa/z8pcDExYF+WlgMHnFndonIJnwQ0Jziv8kIbKyFq145FGvkFcVS2+1F+6uBk3ZuRQQC+csQ1TV+M2Ifs0bDLjmcPAqZAmF1uPRRUlxoncJ9qiIET5TFrpf76ejo2HJzdMPQmp5BK1z99qMEAuyRRCAQt3RxsRm0PUtHOp7qh7oS+yM54esY9UocRhu978KEUw1N1w9dJrFCHsu+2g13tDSQhtX8evOVMScp9foo5TQKP6nIVEm7FBdJUpqIaVkPNy5uP4ohxvkeC4ox+IqykALe6ttH+voyWzsH7JeaJuS8dEyKjQwKdwcbml53c9VzWF/FJoQcU+5jQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bKyuHXQiUp+qz+v81Ek9nMG+4duw+7LltRepBBsyxsE=;
 b=TkP5Zd/2KcooekCMCoOFvU9CDWLMpQ+sZLawpKCCVgAnHeI9OC5VZuexvKetOr7doOsxN53VtAZJ96yrlh63d3PmF5/ekZRexqQk7bnc34O7Jr3ZZpJ0F+LHvhdycc9d1Qh9HtBHEo8UAmwHP4iThfcsY4LUpWYEIVeYAM9UsrRHf92pboqjPpVwrQ0ZxCIX6hOfykTD+YdNGiQmQ25QxspawNu2YHs0IdP82UA+bIcY2/AZ0g8O1zFQ7cTIUSnl6xz53pt06HnPmuzF0yEEDy7TrW+9FmKR+i6lAdPZmcWyGdHxjGiKllep8rJxjioqBwSJ2Nzqq61y3GLeukIUWQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by BL4PR12MB9507.namprd12.prod.outlook.com (2603:10b6:208:58d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.19; Mon, 29 Jun
 2026 02:56:50 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0159.018; Mon, 29 Jun 2026
 02:56:50 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Sun, 28 Jun 2026 22:56:21 -0400
Subject: [PATCH 3/4] mm/page_alloc: make sure subpage->private is zero at
 page free time
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260628-keep-subpage-private-zero-at-free-v1-3-f4ce3930d10f@nvidia.com>
References: <20260628-keep-subpage-private-zero-at-free-v1-0-f4ce3930d10f@nvidia.com>
In-Reply-To: <20260628-keep-subpage-private-zero-at-free-v1-0-f4ce3930d10f@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Zi Yan <ziy@nvidia.com>
X-Mailer: b4 0.14.3
X-ClientProxiedBy: CH5PR02CA0007.namprd02.prod.outlook.com
 (2603:10b6:610:1ed::29) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|BL4PR12MB9507:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d92e9a4-36ec-402e-9394-08ded58a111d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|7416014|23010399003|921020|22082099003|18002099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	m8mRbG08+bSzB/C3p+euvr4UCAM7gQstELGiy2vyh5sgVkb4bgJgI5ZfBvGU4fo00Db0rVnsu6CfiOqdntG1GTmKlbvs9ingvClPn2Uvq8NUIGh8rCHmuiZno2aWdaB3KjLsaY3HsY8Rf3lIQb5qbHngZ1v5RUIQVNYD07AmUiolYHvZyJ3Km91ffhUW8upJ2EMAzdzxTf02WA4whRKyTBgOcrl2RqEID3DYAlJ1yGHndupN3FQQL9GBS5s42ZZLX7eFXq+XnAqNJXP56Qm021m36fVY4YBt+iDGaoZYgAAmmLi8rzGtniWpIEqMhesyR48LHvrQ2YqMnfxWiFThTxYPopGn9KhwI7W0mRj6/vN0eRrBIrGAA0IKNXXFfohpQjgj6gCG99bdMHpLPhu4Qu3lI+c2yhLlAV/TRhAXEpcRrjlLbJWYowrC9UEcuu0K7YO+l0+0UivtrjS3Yy7tE9Q1Z1ECsgzX48oBrMgIG1zVFBfQ3NM8GuSfXNvXzADsl/aoJHWGd5XviOrUBon40M5sMSMGUTOeUAJV1cJnFpJUYSeyoFaTeGk1kJrrUipq8OAGU8j2JwzLMsKzZC6cREsYdvuQ+nTMZ6TR8lYCL5X2hwQ18upBR/NSZLtMFefB8UN6fTRHwOjjXu3OYTcGyhP4kIrcIzVhh3RVyQJ47CzAkpFVJiAL+SFDqQ2HTFgBXHeKot4vFJ8wYGs2uZ3TDw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014)(23010399003)(921020)(22082099003)(18002099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?T2ZpZFZXcUY4VlJ3VzE0cnE1ODF2cysrK3hCb25tS3J0aWFhakNaUnZrVWRr?=
 =?utf-8?B?V3F6L2pZZS9sNDN5SzVwK2d6c05xY3FVTGJxc3kzaGNNV1A4c2lVUHRPT0JO?=
 =?utf-8?B?V1JRc3p4M1hneDRaRThBdXBKb2JybkNURmg3LytYYjdqZ3hxcmlVQWVHb25l?=
 =?utf-8?B?dk9wRHdBcXVmMGpkejNDZGFjVlZ3bytBbVRmRU1ZT3p3T0RJQ3Nwczd1aFh2?=
 =?utf-8?B?L0RvMzdoVHhSTUZDMi93OWFZak01d0h0VDRvdDhjaFRaZ3FDK3gwTUpQM1pt?=
 =?utf-8?B?QjNFNEE2MjNwN1ZsSTNPVE1PSEVqMTZKRUl4aVhjQk4wb3hTbzR3YmYyVGhn?=
 =?utf-8?B?NzhuUVc2T0MwNEk4VFNTNzhWMFBqTXFtUzNCWnIyYnl2ZTVVQmt4cEU4Y3I0?=
 =?utf-8?B?eGRKTURzVmZPUnkyMnIzRjNTakpqKzgySGtkaGJhVEY3a1BiTmYwK1ltZXVS?=
 =?utf-8?B?WlV3RGNGN3YyZEtVSDdJSC9qTHVoZlNEL2psdkVyYlpQWjhvM2hlb1B5TXAy?=
 =?utf-8?B?ZW5MNW4zazY3bk9jUjUxaEd2bm5aNW1JZkl2WUU1eGJVWTF5TUtDcllYRjZD?=
 =?utf-8?B?V1ZoNzFFMTY1NW9WMzFab0VqV2JyQm9QMlBqakZ6L1JTc3JsUWZsRFd3RHpP?=
 =?utf-8?B?VkI1dHgxRkpiamVvbCtFbkZiSnZ6dUZkc2hOeWw1Wk5pbDdaRmQ5dVJuMzlr?=
 =?utf-8?B?TVl0eEhQaHVDZTdZSUZUcW9ZUjlYWng2VHJ0eUpkbGV0S0dPTktDbUhvWkhE?=
 =?utf-8?B?ZlY0SzluYnVvTlNLVGQzWlhVdlNoRy8wNkVyZWFURFBrRkNlcHBuZDd1Y3c1?=
 =?utf-8?B?dVJodThORnc0TUlHL3JhMEt6eE45UlBFUndDK0RiNUQ0VUY0TUYxa3VBZnlS?=
 =?utf-8?B?Y3pZOGkrQUJJVlp2MjAzdHR5TG03V1YvZzR1TG55UjNIbHZmQ2FmSCtxQWFl?=
 =?utf-8?B?a3lWZlZuN2xrR2ZnbXhjUFZxREZLYUhuNDZqMVN4Z2RtaWNtTHNKeWorQjhO?=
 =?utf-8?B?V25MZWsyKzJtZlV3d3l5QWU5MVhSMW1GOCtVZS93YXBRdE80RjVkbTRqdUdG?=
 =?utf-8?B?OGhER3JGTklrSUpvOXJUKzVLS2dmRzJGcFpqZWlXS3hJNjdpdUZRS2dEY1FK?=
 =?utf-8?B?SitVcURVOEl1Qy9NaWhhNWlraXI5cStKMUgxYXNKeVdUK29Yd0dpeTVFVlNP?=
 =?utf-8?B?K2p6SFZRWGd5NEpNU2VIUFVDMGphRXFOZ0xXM0tUL2s2OHI4WnpzU3JWQnpo?=
 =?utf-8?B?bzAxNkdRU21UN3Z1Wnc2NC9pVDNGL1pIdTFEVnNIcm5kWmpzV0xBcVBEcVht?=
 =?utf-8?B?SFQvdm5nRXRUL0xoQmtaYXY1OHhzRHZSZG1DMkZiY0R4Wkx4VGZ0eUx4c3dx?=
 =?utf-8?B?UGlDVXo3V05teDlZWnhUNDhvblppcWZTaDc4TU1KQzdaT01CYjZlRGZFRVVS?=
 =?utf-8?B?bElPMDVEZ09rQXY5NVFwUTJHemh3TjdJSjJtc2MwcFd6VlJNUmk4SHlHVnQr?=
 =?utf-8?B?c2poUEUwNHhYaVdNc3F1OFVCaEtQa2hlOFZwSnJ1NjhJNkoyYmR5VmVCMnVT?=
 =?utf-8?B?d1Azc3lEYmNzUVI3bVQzUUNncmlMc0x1dWNYSXFsMlZ5UzdJNnoyWi9Bd3N2?=
 =?utf-8?B?VlJiemhRdzJEQ3daY2NyWElCeldNQ2ZOMVp3UUY3Y0JqWkQyMjk0NnBMamNV?=
 =?utf-8?B?RWovMm1yV1lnZEdqUU9teGVmNlRmNDdtQUY1WXhuVEFsbFcxR2NubnJmTjhx?=
 =?utf-8?B?cDh5eDMrNFNaOUtCbitpZ1kvc24wSzB3S2hjZE1vRnZRQjdZRFptWmcyMUpx?=
 =?utf-8?B?VkhFWEQ0TWVycllOeEJVakdqbDRzeEhsSmtTeDNjNTU3OUh0bmdoSHgzUW9F?=
 =?utf-8?B?OHFzY1g5eGV3NTRFN2RyOE1UaFVBdmsxcU9mQmhyOExmVlozdm14TGFKQ0tz?=
 =?utf-8?B?L212TzR6TjJHVHlqOG4wM2RjU2RweWg2MnN0K084V0h6T0o1U1c2UmdqcGZE?=
 =?utf-8?B?amtKaVJrckVlMmhlSHYyak1MM3Q1L2Q2Y3BuT0ZIbGlkS1pDeEJDM3RsRm9T?=
 =?utf-8?B?YVNNc2VsS1dXRDRacGFzVlc5RHVPUTB5L0xlbGJieGpVT24rbWtMZjNWWngy?=
 =?utf-8?B?WXlTN2NsUkpOWXVIQUxPRFlrcXk1bEhPenN2U1V1QjVHQWcrcHYvK29GaTdu?=
 =?utf-8?B?QkVibWQwekFBa1I4bkg4N2JXMWJwUHZjbkpIQklGYTFxY3lQbkRvWnVmZkpF?=
 =?utf-8?B?RHhlaUZyeHM2WCtNRWg5Zm80V21VSVVwSyszbGI4dUhrdXpNSDduaFdnSlBY?=
 =?utf-8?Q?duAMt0O9s9oB42xwDV?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d92e9a4-36ec-402e-9394-08ded58a111d
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2026 02:56:50.4376
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Iyn9um9oq91abGl2wLfAQ7Q+Z1Z9Fi0FmjpWVwiaGAC1GDnLsSUoLB0CBeDWsNfD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR12MB9507
X-Stat-Signature: 45excp9e84irn8gea8y4cgzgbgdkgt66
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 956B540002
X-HE-Tag: 1782701822-144664
X-HE-Meta: U2FsdGVkX18TKmW07xmvZ1K/r/Pr27Tta7/D2GG9X95/LQIajKtlGIN+pK4XXCsqXgEdaSHJDuRjWziHiOZwMlaTxMyQRe6zGekKtH6gNy17gFDPDTxUVmnfE1mUsfeVcEG3s8kbxkTM8kgc9kn0JTZTY7zqHW0ShzYhTPkOrhWwoWrO9iBeKgbUQvVUY7D0h70/d2qEATg3zQ1iCol0lFCQ06s/ry0pRLKXzIoOd3RaPqzPhrMQVjF9w+HgtlOsXmjrJYYzzvcYHffwd2rNPvdLhzWiEsZ0QrspOoK01ZR/TiOHl5wtNngZONvxx5ypgE9tdSPktk6P1Dt0Anm6dWNCQLeRort9WUkDiNXpyKICj7O+NK54aOcpiwey0xeez0rxbPD2J98VnlHLMBLyr0myK2xNVHqzUF4O291LhDOGzk/O+6CqpqCe+JkWEthLyTMaOaMlrdRZ/e77MaQ3SFPYmNMLrhRrdVZpDC8szSfSvoHw8N8L163uv+8URgb4mjXzzsf1u5Sa0o1vEoZ3vvix4lzNEYcDek2eqVTgjLk7e/KlGOWxw/xey2waQnZ5VrJZp2MZZLLiGeEOV4Vq/RSW7EVcTbB5/wCRKOnz2vM0iq2a49f+gLLbX5dqQzLNo5QcyKfeKxyf4Y7whQFJNTrONp6hDeKpCGswSru1YxgPj5e9Y8B/hnMg08kYiaY3z8lB3J5AG0mhTmOJB/ZLPziu9/wXmRfBz5pQgf0z7Y4mqWbZTz+/YpLKCAP3R1hTqjNqGAwEEf7XGRkRNWgMCrJ4h4RiP/h1hHLHmnvFwR8HUtjR9ocGPzzlyKiGB2pUlqsovG4dMP5ZOP2IxMV7uud9EjFZ5tV+zoF1AEB1rcYkOokSikhwuE3PmxqUfcxqKX+x/MfYW+tpITpJOERbF2WmRGdzWZJ4rbOhIFRfxXe/4qASh///IN6kivH53mfZwVTQ/ayHuYZG0DQ6cI2
 FUNzIFOu
 kqdoddoQkvvxnro/HVzyqs7UqHq+QiwS1Z20Rhvxa8XJy1LXRDm70xykvtHV9eBITxONjsw+5wTJcId2vZFPBTbTp05J4YiScVP/vhyJLI4qkrSwMNZ9jylOWMDXFTbZorpA+BC2fZawKgUQDgbR+jBqnODenHtJvbX8dtVhtnFWEmhCjIZXXc1B30lV20f1iCEPmM3qxXxkOgPgm39ezOzHjBhDeBeG47Lthb7C6Dbb4K8O3EcqOUumara2duER+kcrTMrNqvxK183Ob/bnqrf3TuRh6at4gQxz8QNtXlvURZV5QDrsqaJp9RYiQwdUgxsw5qFo3fXRq6lSQVI0H0iqfRML/Ah6v3bZyvBXOnsDt8ys8ukNTuMlQB+C7fwV22DMaMnX8eKFdOKxEwWltsV49N+T5ROhI7aiFDUThIQA4P2Btqz7LM8KOe+ftcrTSHLU1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Any code using subpage->private of a folio, a compound page or a high-order
page is supposed to reset it after use, otherwise ->private data can leak
to new page user and cause unexpected issues. Add a bad_page() check at
page free path for it.

Assisted-by: Codex:gpt-5 # add the missing "return false" after bad_page()
Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 mm/page_alloc.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index ee902a468c2f..13c2655e24fb 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1374,15 +1374,21 @@ static __always_inline bool __free_pages_prepare(struct page *page,
 #endif
 		}
 		for (i = 1; i < (1 << order); i++) {
+			struct page *subpage = page + i;
+
 			if (compound)
-				bad += free_tail_page_prepare(page, page + i);
+				bad += free_tail_page_prepare(page, subpage);
 			if (is_check_pages_enabled()) {
-				if (free_page_is_bad(page + i)) {
+				if (free_page_is_bad(subpage)) {
 					bad++;
 					continue;
 				}
 			}
-			(page + i)->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
+			subpage->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
+			if (subpage->private) {
+				bad_page(subpage, "nonzero private");
+				return false;
+			}
 		}
 	}
 	if (folio_test_anon(folio)) {

-- 
2.53.0


