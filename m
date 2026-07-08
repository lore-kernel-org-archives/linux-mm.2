Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 573A6C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 01:54:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BC756B0088; Tue,  7 Jul 2026 21:54:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 193BD6B008A; Tue,  7 Jul 2026 21:54:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 083206B008C; Tue,  7 Jul 2026 21:54:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CDC066B0088
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 21:54:32 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 588AD1A0613
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 01:54:32 +0000 (UTC)
X-FDA: 84963939984.23.C062758
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011069.outbound.protection.outlook.com [40.93.194.69])
	by imf10.hostedemail.com (Postfix) with ESMTP id 849C7C0003
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 01:54:29 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=dE6CKJCk;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.69 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783475669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PdiB+ZsLgLotNLWidn7YTFulb4NHIYexj5JpCnyBalk=;
	b=NfAvPY4tx1SvHs1tIQOJamIn1wsMSx0UQhjgD/ZXedcrr/EzA4PrHCCWXG4TEwdHCTgp57
	DMiILu3Q+IPE75obn+9+SvbbyeoFwDMRTsArFAZuyyMATcWZ1s80rQf4c2CzV1gEQwsePv
	njusFuxzdjmLVsd1i30tfi35TKHj8+M=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=dE6CKJCk;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.69 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783475669;
	b=mzOPs68A1jKjmz5qyOf+D1aSi7WsbRxZv/63idjYmCh3gLqAUt83/6eseLuw5Qncn5vmR9
	8bM7Maj6Ag7Of3/Z3+6pH4XJ8mZUGfDMEwxM/m1JVhDFe5Xa2LPh926Mkjw6ElHoNjlUXE
	zWmwN8UaR5Q2UdiOwfBHRMaTiLuU0eY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v+lXu7I9l0uEPulmjYRckvgBJjChY8jTCo0ifV+oqbo06yY7bGid29txkoaKgyiP0t3A6t7ascHQF5dKvcegn+Bu+L2vVdZBZ+h+4Fw6nqH/mYwsQmU21W8oRFfp66YXm8bcKzPz1Ji0+MHe3yZV4gojLGCK7L+1VPXmzNQvJ/d0CpyMgqV+Y0K0EVEkSbY5wdb+uFp2r3Mk1K+X5Z6eVbG2TeVL8zlhl0bEKsu3Ft32nAt/CPn+CUSVDpbJsGmodOq24taDlAC8OrAU2bRmCxMrZNFHEN4GfAWikiKsxdkkIAUgCxKtCGmXELC/3iM9Io6QXWpY/EfxQQCZl1BJaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PdiB+ZsLgLotNLWidn7YTFulb4NHIYexj5JpCnyBalk=;
 b=WVc/Xwg3rcER9UWMKNFDTf6LGJfOygXVg4l7SiIWLRpSh21G4dRJKPAj3LlXzXMCk8bcwzTyP7opW9TRs+kxtTIEPyuHqTh/Wn2N8W3htyHzJbhE1/bGq4QEPcEh+/QcOspRPTnoxE38mLa+GYt70uTFNr8Oa6aJ3adC3ywCi6ZLl6D4aCpcWdA9B3bsouMnex0MeXxGU6T0s8jIenKJOJRjoFIqMizuk3XObNvoc+9K4MB0utz9fI0a+ErQNOgwIpDAz4/nKTjnVqC5G1MmEFu/x9duiW5thfFKtrd/dwUjG+GRhEjZFV0O/3Zd3YBtyawbp1hxSt4LPMSC55eLDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PdiB+ZsLgLotNLWidn7YTFulb4NHIYexj5JpCnyBalk=;
 b=dE6CKJCkFo3tbJ/9NQUnuu0HRk7/H9PiCP88vO85hoEP9XtfQQkLLt9P1RvHPqGxbqbJufLOcym03ywR2Aik3KXWpNA8viN4Lci5s+XwfxNiyPWdJPGFLpcq9ha6HG5zc7JZY9UoeGB1P+s9KgWFLeZPSm0pDma+EslgpJse52Bu4b+zpOwwzk5RO62H9KxHte1Q3gIXZL24vDJpme9S5eRHfiv+YnVSHSUHs4KPxB4J8T0W81ONg8XRHio2t/UDNemStZsOaww2T493pvlnsJLhyhwfEnLtQq9YK2CN3Wn0xXz/0pnBCp9WzpS+f1iE65XlueJBnlv3yHFHZXYVrg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SJ1PR12MB6290.namprd12.prod.outlook.com (2603:10b6:a03:457::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Wed, 8 Jul
 2026 01:54:22 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0181.009; Wed, 8 Jul 2026
 01:54:22 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 07 Jul 2026 21:53:46 -0400
Message-Id: <DJSTCFVXV0WB.1GHVMY2J7OLIF@nvidia.com>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH v2] mm: migrate_device: fix pte_pfn/pte_dirty called on
 non-present PTE
Cc: "Matthew Brost" <matthew.brost@intel.com>, "Joshua Hahn"
 <joshua.hahnjy@gmail.com>, "Rakie Kim" <rakie.kim@sk.com>, "Byungchul Park"
 <byungchul@sk.com>, "Gregory Price" <gourry@gourry.net>, "Ying Huang"
 <ying.huang@linux.alibaba.com>, "Alistair Popple" <apopple@nvidia.com>,
 <linux-mm@kvack.org>, <stable@vger.kernel.org>
To: "Kefeng Wang" <wangkefeng.wang@huawei.com>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>
X-Mailer: aerc 0.21.0
References: <20260708003955.4024340-1-wangkefeng.wang@huawei.com>
In-Reply-To: <20260708003955.4024340-1-wangkefeng.wang@huawei.com>
X-ClientProxiedBy: BLAPR03CA0108.namprd03.prod.outlook.com
 (2603:10b6:208:32a::23) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SJ1PR12MB6290:EE_
X-MS-Office365-Filtering-Correlation-Id: a66dac35-db97-4224-d3c5-08dedc93d48d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|7416014|22082099003|18002099003|6133799003|5023799004|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	zaO+Zi0KeCsmH0t2CV+9yKY3VStMKPh9aKo8GfobSdgcCgjIcgxodqA3zS96S7acdKk4oOFYdl8M3oygXOpusNtWUPCLedRLPcNebEC4yZ4ShzDDbLQBX/bmYZqZKBBaems1QmmccTry0IrgFX7HeHjmqsn5szquWVk2w1O93xuqE+P9tvBJQR9lImmbss7fYlYY+Ali6myaExBUXxgvKtTsZzHukUaIRDrJUcPzW51FBZn57laJnAqrn4XCrFMz3dxVogkAZ/FOjz2v2JFrfs71AKc414gLgL1+kbdtKaQuCuGQY/vL54As5ZhUn1292uvqEQ52+hc7ID2rhmd8e7YP3IfL0ZrrGxRm7lljBm0T+i1zQorASvljgfG+HFLFCuIE7OzqDF78tPoQElsIid6eDRjwOMIeakY7iMmH/LLRD3EuGyHB13DhbSQcr45q7CImhoeHi5yAg/MH64ebsDo1FFO1IJIiXVP4JCgxp0kyvV051b0s1x+JKnYtg3sKs53X0K6VHfO6jPU4khXh2BbMZ5Bu8E/qSULzMwqOqVCmHHpejTh9eoAZAj7viUx/QbMbqkwlK/9H7ai7WPKX3Xuax8CJ8lpMBlzGRLWZ+BWRy9x+OKGgymna6Isq5W5idOQMQpENvz5HeAKsu7tigBn0Tna5i7jL34FzJJ99lu0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(7416014)(22082099003)(18002099003)(6133799003)(5023799004)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WkhWVGwxT09Rb00rdG0zZGdmdlRGRzVjQk9lOW00L1NWRDBZcVJYcElkL1cy?=
 =?utf-8?B?Z0dYYjJKT3ZTa1o5dUpXMFE3cS9mK1lJck00NXRHaXhla3NuU3FHTWRYeDBR?=
 =?utf-8?B?OHlTNGliKzRkUnFSdUptdytxWTl0YVNLN2J2YjhsVldvRnB3TElDZUVoMlIy?=
 =?utf-8?B?QXBNVzdRcUliODFlM3lDQ1JmQk1ULzlnNHFOVXQ2SjhGZEFLTFJQWDR6cjJ2?=
 =?utf-8?B?LzMrYnlPRFphTytaZkxKaURmbkpXVW41WFp6eWxja01uZVRpcnlFaTh3NjFC?=
 =?utf-8?B?QWtESThxeVRrZTY4amh2SE5qL1NPa0RDbG5RTlcxeHJUNkR4aWx5SlhSZkNZ?=
 =?utf-8?B?NVE5bWhJbUxIR1NTdElLVlViTUdUcEljVjI4ZmVYb3NYVjVjMExGUHMxUkJr?=
 =?utf-8?B?T2ZNYkNQaHVNUlk1aDF2Zjk0SUltbWtnVDVraThxZjlnTFpsUzdxanRNaGsy?=
 =?utf-8?B?S1hhdmZxcW5qU0xteEtFNDlYUnNvaTdkeDE3VkZUVVZLY1Q0cWpZUUxpQ0Fp?=
 =?utf-8?B?YkUvZHRkZUhyUGFZUWtPdWJjTXBiRTlPTU9jb1BMNVYvM1RNbVZVK2s4L21C?=
 =?utf-8?B?Q3A1ZlQxRDBqZ3JabEZSS1A1Q1daQkR1bnVyWC9pS1pzRktsdlFjU2w0NnVO?=
 =?utf-8?B?elVzMG5Gd2hIOHVlS2E5TE4vdXlBS2hKTEZFOVc2c2VlNjlBbU9qWWlFVHRH?=
 =?utf-8?B?ZVFLM3FCWUxneTl1d280cW0wY0g5dksxQ1dIeXEyYVZJSmF4MWo1QUVhNnhC?=
 =?utf-8?B?LzlHU21pdzVTcitBTkt5N0NQZU9yb1JFaEVMMTFtUVNROVFyUUc1RExrUHNK?=
 =?utf-8?B?akRsOHFSZ3hHak1ic1VXSzRCUnI0T2dlSFhtRGZsWGFEMmVzSStkNDVhY2ly?=
 =?utf-8?B?T0c0cEpaQ3RoTVpxSVpZaUdzWXNIR1dvaHpCWWxNWkI1ZWtOVUNkeXluREF4?=
 =?utf-8?B?TVE0cFpJRWsxaTdXQ3NLZmcyYXN0Ry92dStLa091S1crdnhLQXNRbFpGc2ps?=
 =?utf-8?B?TXVJV0c0UDN4NVZyM20zc3lnVWdLN0lNYm9OMjIvNXlBUE9rOWYyTWYyK2lj?=
 =?utf-8?B?cnQrVVAyaHNOOWRGREZXZnJWLzV5Q2ZXLzg5WStTZWpIMGFydDJmNVVkT3p2?=
 =?utf-8?B?eGFHYW8xeFVya0t5RG1IdW5pVFhUeHRpN2FGaDBhZkZseGwzVW5VQmptNXFD?=
 =?utf-8?B?MHlyd2FNaEtDYXNCT1lZRityaEhyMGNzaklBa0tqRm96R0V1M2EzV3ZJbnFJ?=
 =?utf-8?B?Z0p5aHFmSWlzVC83K2VIb1FTaTY0aGxHaHdvdWdXamZ2Z05tY09XWlc2S2Nw?=
 =?utf-8?B?QTViaUh3NU5wK29SV1hJWFlQalNJVGJuQmZseWh2cWY0VnJaaHkvYmNocU0r?=
 =?utf-8?B?bUlnME5LRDVIeVdLMEpySWkrQ2xLUzJGclVHMmFBSmhvMS9uNGx2S2t5SXBj?=
 =?utf-8?B?UTB3MzJOUjd0SEdpaXc1cDlPY1hqMmFqb3djYldRTnJEWGZFVUtyTnUwZ084?=
 =?utf-8?B?WTBNTXZlbmFDdU8rbVk2Q01ibnN3Y2dZQWZzYUY0bUVpdUhNVE9QYlUwMGpp?=
 =?utf-8?B?WjdwT2RYaWhkZWRTYmZJVkY1QW1PdkRhWFNTbjQ3RytzcHppTk1YbFVCYWZq?=
 =?utf-8?B?RXZvbm1HdWYrZURQUUFITXhwei96Z2lPNWlhcjJWU09yQU94R3J3NXVWZy8z?=
 =?utf-8?B?bzd1NEpHMHJ4dksyZ0FyNk5nZTNUb1B3SXN2TU16Yzk4dWhCcXFZTVJXSGZl?=
 =?utf-8?B?Snk5em1mS1pTaGRIK1pEZHRSRzN2VkFpSkJsZXdHaGVSWFlDWSs5Y3pHUENT?=
 =?utf-8?B?Vm53ck9VY0x1TmpCQVpUVFFlLytYazFyc2VlbEluaEhEWFVjSThHeENDUjU2?=
 =?utf-8?B?MFJPVGxORkE1VUJkUjNCMEZ3bnlwWDc2eERaRnRac2o1bThaS2JPVnRvOVlG?=
 =?utf-8?B?ZDdNVWhkakF2UWtUbUhpZzFZR2hWempOOFgweDhUd0Y4bmJzZ3oxanpiYlcv?=
 =?utf-8?B?dmM5YUlXVmJuQkRzTVRYakhMY0NLa21ERmRpRHpuZUluYjlveHNXS2dtazVF?=
 =?utf-8?B?ZXNGaEFaNW1Xb3QxWnZUaVA3OU8vcXZIMEo2SmJlMFA3ZXNaSEJPOWhZTGpq?=
 =?utf-8?B?ZGJCbGZ2V09JdUZWMkQ5RkwrMTFEUlVWUEhjbnVmaS9oblE0RnVyYnVaMkZi?=
 =?utf-8?B?aDZodFFoY3YyOS9NQys0VTJiZWF5RmY1STE4bjJuREZjM05FWUlrUU9QanpH?=
 =?utf-8?B?aThtV0JHVlp2N0k3cGZWckUxNjRnRE5FOE8xSEZwVU1EOTJXMVpHMEd5d3Zk?=
 =?utf-8?Q?3+ZNrLnKlhvXLmpGzM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a66dac35-db97-4224-d3c5-08dedc93d48d
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2026 01:54:21.9365
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HZe2+8l00181bDBcifzmDta4KOVuOeDYgKy3qqs63DL2DlIAzYfuqHrUkLX6qiHX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6290
X-Rspamd-Queue-Id: 849C7C0003
X-Stat-Signature: i7u31mt5z18d415dnyp9pitibn9b3sxh
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783475669-547068
X-HE-Meta: U2FsdGVkX1+ceYkFxy0Yu+tM3ceEJItL9GprX6HrTkiSFVo6Ibw2A0ZZUYOJnjGpfyGWTUIwqmpstfDijpqLmr9VjMs4J4yoKJGWg2g8ZR/7bUbV5wXtG9vd5Lhpgiwp7w3D6kvBQ8XDRXN8kUZCFtZcZLXwMsP+4kMLsyRaneCFkInw/gchVx2FMyKhJoeXaMcg/fDzx+rSniNgs2m7jJXEpOrO/CY+kUrkACRkPRhuUmB6G5VbeQ42zAez/1ToSeN0mrLitLC9By2SG2uSZcUw9nFk8iLytqkccPZ1IPSHTBHAo3uZfhoT22kse2/07ljUH5J/wOrcROgqLxbqOK9DwsHCbRqvfzpBfc6DKXZdwqi31OFVbSB4M1XdNSjvvC0eawBsacjhdt1J8vJuydTQMnW+UorUx5DOdgUp5rV03yaTKNtNGvipC0ul2Y78/Rm55VsCS5WI7LPFkbSFZR5hS4yCypyJGyotJ4C4wrlXDYEetBHTVkCb/egE9r76GTIx+PEbFA2T6sZWCaCxsMQ+WTyYkYkYRdxCaU7K3sxbvZC8Wl3XgiE7M3o4X467eiDDF4UF1M2mgkWsN1osCAOYUj+GKNK/3auGdJWAZpQq6hZONMbKDoFHs9NRhYPMm8HJy/TeUP8AGGgLhHbi0gDsZyfCg0b4YirEqnxFLLM59XeGvEWbvKiQkLLgXs6goXDJf/Kks57dtYO1CONp+0Cy7uwo5RIfb+sgzMNMgJP71m1OPg+31vElJV41l0Z1c3AiPbmc8HooTRXH6n+xlkos24LcRLvi30nIIFInPwf4rpe6R030xLcWEu//fWjSWQ2yRHObVS5CaGKVnEt/vLIk79qn7MF2BBifUszn3IadG9PjEmzubKMF6AZ6+uxn6uia//WOkt+ExGqGpYuZiNYa+r0dwdNbhDl/BtZiSd0bBlqrr/38s6Q0UoX89LmgH8G6WyUEpyNOhcNI+lb
 FAHkAWla
 lxfzacTOeyeM6I/C4BoYh8yurmi8xG8vQQH1DXSjNb+BXHVa+v0EFg1eIFIr2aCTR2GxkG3u+t5A8FPhXHN53+jt2QRSpVpEbAsvxCX2Vrq1beWnG0kLGrYrcsI1xFtx80k/WUtvXVJzvPIJaecHgAYGyguoLSLjhxSwvAJeYyqRKJmH2WzJHlzgh6XoxWKf5kWlHOd2yFf3vwFLXebUA37nV8u2+QuMqd+taJaWRfiwzT/AdX5fq6ICuTHBhsJeJH3uY6B53Gacivl6VqogjciK6fn3fFs2S75OHI9+UZLIzr/gin8p7GDmf0Hrh0w0Rn3sCyM2pzGO7gZ4GaUvF+Qg7aeusNvilgzlbNSqZsFsRDvALZdenCNHqlaWteaaOXDYDGLFGTot/9ua5sRdezwD0YkrQNYWz3SUsXzSk3YDJrlaPK3luecFOf6Tv8ntPzxh12DjAeagS8WiyV0byPr3+omQGp6r6EWU0eGIb/Gh6gXp2alvIVcvHTHG2bjQkmN2A39ew+WDqkWV6+Lhi2FuWzTEC4kUdX+82fn2+US55qkYXHLQaD3Z0GQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Jul 7, 2026 at 8:39 PM EDT, Kefeng Wang wrote:
> pte_pfn() and pte_dirty() have undefined behaviour when called on a
> non-present PTE. In migrate_vma_collect_pmd(), these functions may be
> invoked on non-present entries (e.g., device-private entries), leading
> to potential crashes from pte_pfn() or incorrect dirty folio accounting
> from pte_dirty(). Fix both by guarding with pte_present() checks.
>
> Fixes: fd35ca3d12cc ("mm/migrate_device.c: copy pte dirty bit to page")
> Fixes: 6c287605fd56 ("mm: remember exclusively mapped anonymous pages wit=
h PG_anon_exclusive")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
> v2:
> - correct changelog and Fixes tags, suggested by David.
> - cc stable, suggested by Andrew.
>
>  mm/migrate_device.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
Acked-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi


