Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 790DEC8303F
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 18:22:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81B998E0061; Mon, 25 Aug 2025 14:22:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F3478E0038; Mon, 25 Aug 2025 14:22:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E1708E0061; Mon, 25 Aug 2025 14:22:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5721C8E0038
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 14:22:07 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D1C96830B4
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 18:22:06 +0000 (UTC)
X-FDA: 83816099052.15.F16D257
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2052.outbound.protection.outlook.com [40.107.95.52])
	by imf02.hostedemail.com (Postfix) with ESMTP id ECA4680005
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 18:22:03 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=JhHimdtX;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf02.hostedemail.com: domain of jhubbard@nvidia.com designates 40.107.95.52 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756146124; a=rsa-sha256;
	cv=pass;
	b=CPAAoFxMnOA859BrrwwE6JsR0lSM33L9CRHPL5lOJrhf0vxe/P95dMwN2dGqM2UkRnU4B7
	XxoQJGH+K+QccKRKJu/EPYZO9ZhNmJC6qaPhCuRoTRfh/tM0bYJv2j48lkOXq5OKGBoPSQ
	dAMoDZSZapPOLis/t7H7PfMKv/YjoyY=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=JhHimdtX;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf02.hostedemail.com: domain of jhubbard@nvidia.com designates 40.107.95.52 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756146124;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UmTPSQh7WD9yYdJaEQKH98TDH82jSkVmtZ9hGS6jfWw=;
	b=o7l3bw8m2vCelaNV8xPVruL39aUUz54YzCoGYGdOga6nwo8oFhzl6IQMA3W9yysZ8eUvT0
	HrXRnRXsZRoctknLZrw84TQdtQ0Pol+euhsEkAa5r65h2srb0Ofz1PtKiCcoaxay0JXZqu
	HLwbcS238hcob2M5nfgcktuTDABmj0s=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MLY7FBXWmyEVzFd01WeKSclzGw7KKIQJ3WiRzWaup44S74+ERnhZ3zwwdOB+Cc3+4iFCOHPKfdUp7dnwzrhqLnV4kbOlAaGy0zrhFq4D+Z/Q75crlVcWBjfoLyk4IUIFpl+7WZ21L8iGZMgdRoL0zBKDMKdl8RPfELwHOwSfrZvwncQKpuxQeMrxHDRKSPIummwp2sGSo3d2yFRVtOEt2+nEwBUpa/qal/dHYVmH6Lb/VkU4n7Qj/+S0oSDnypnsNysGmVYzDUPZPURETyngQRm+GipeKRyrS6e1TVtiDX2kmmJQJ0itN2R7i5NENAUNUKidyuF2Pt7uoh0/Tu53UQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UmTPSQh7WD9yYdJaEQKH98TDH82jSkVmtZ9hGS6jfWw=;
 b=ERbsppOYsuXBKnA21UuSvOU58hxCNs1SeVQRJh37kc5eO5kRIwR8PvqU1/F+5ucvRT8L6sAg6EypahL/lbAoyCLnjZol/fzb/gYLqz8pbQukf9S6+/KXtviAe4Y5BYuQ8mhTogrjA3TsMWmumKdpsBx5qAHWwmF7eq2xmt0f0hnJdDrQCZ8gbYituZTALV4YFKKQZQZeR3c+oBVmhm0k2jtcLvZdRwyncBzjz3aq6URSFDkLcbIEn1GHM+EXcH5xlrtKVAY3w8je0Ia6ppUivBY2pcCqUZZo5xIvzoBAOHfCojsCM6ClUq7+e2sgjNn1qbeuhRLax0IxI6p4fSLHtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UmTPSQh7WD9yYdJaEQKH98TDH82jSkVmtZ9hGS6jfWw=;
 b=JhHimdtXhIVS0HecDxqWnGcnaeImf4L2hoOH3FJ5K0+SXkFfHbf22sxuxIEK9brqjb5KbDm1xIdiFT5HpUwPYWEo1HIILxTZ/LDsYkB6id26vQ/oqCkrpSeXSwdg75wRDAsGrkH1oYQobRVU5Unp8q37onIcm8ptxoxxXZsLGYRK7/XF418BjS9loASd0zr6jCq6x1h672xxzDXf1F9tVfFCOxBEtsq6Vb21eh/kXqO7BTHiCgJEywsS1U+x5ugW7Jf7yTmfw5C1upzVBrHB7ijNH3fs0iSOFzqN/vanL1Y+K23jfpwZhV8dwyvF5KhA7qC4MAo2VgNQa2A3E15LGg==
Received: from LV2PR12MB5968.namprd12.prod.outlook.com (2603:10b6:408:14f::7)
 by CY5PR12MB6624.namprd12.prod.outlook.com (2603:10b6:930:40::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Mon, 25 Aug
 2025 18:22:00 +0000
Received: from LV2PR12MB5968.namprd12.prod.outlook.com
 ([fe80::e6dd:1206:6677:f9c4]) by LV2PR12MB5968.namprd12.prod.outlook.com
 ([fe80::e6dd:1206:6677:f9c4%6]) with mapi id 15.20.9052.014; Mon, 25 Aug 2025
 18:22:00 +0000
Message-ID: <4a9e0017-53a6-48dd-8e3c-774a859a28dc@nvidia.com>
Date: Mon, 25 Aug 2025 11:21:56 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/8] selftests/mm: Add -Wunused family of flags
To: Muhammad Usama Anjum <usama.anjum@collabora.com>,
 Shuah Khan <shuah@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Peter Xu <peterx@redhat.com>,
 Leon Romanovsky <leon@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Paul Walmsley <paul.walmsley@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-riscv@lists.infradead.org, kevin.brodsky@arm.com
Cc: kernel@collabora.com
References: <20250822082145.4145617-1-usama.anjum@collabora.com>
 <20250822082145.4145617-5-usama.anjum@collabora.com>
Content-Language: en-US
From: John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <20250822082145.4145617-5-usama.anjum@collabora.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR02CA0026.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::39) To LV2PR12MB5968.namprd12.prod.outlook.com
 (2603:10b6:408:14f::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5968:EE_|CY5PR12MB6624:EE_
X-MS-Office365-Filtering-Correlation-Id: f4a79fbc-7f1c-4225-56f5-08dde4044828
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bUxjQWlpa2dqTGtHbUVkZHc0Z20wa2RQbTF3eER6WEFXTTg2L3dBR3ZRWEZp?=
 =?utf-8?B?ak1naGZhUVo4WGtmTk1POUZwS0tZMnMyRmZFOFBrWm14enQ0c1hCYUZmNU9K?=
 =?utf-8?B?eU90VGtJUDhYTDAvV1h4UlVsNmJHV1kwZlkxWFFHQWcwS3IwVmptYXNtM3Jz?=
 =?utf-8?B?VDB2WW93NkpSSDNtUXNkaUk0WEI0QVJub3dkYkI2Z2kwNjRXMzJobm9UYkdi?=
 =?utf-8?B?cnFQQUQ5a2E4SEV1K1dDbU15MGY1S2RTYVJ1SnVNcG5ZQUo4a1psdE9VSnR6?=
 =?utf-8?B?MGJoTEk5c2hFVTBDOURLK2R1YTI2elVVVG54WjVESG40cWFia0wrb3hZc1p1?=
 =?utf-8?B?d1dTTHhaVk1vcmJ3cEU2THJZcDZ1OGlLTWtIdzZQRUFhTnNWYWx4VmVkSGpx?=
 =?utf-8?B?SG9JMEJRdmk3Y0RaRVAvU1d3WFptTVdJbW53QWJLdVdxSnFsbGxxM0V2Vndp?=
 =?utf-8?B?ZVUxMTNTT2dFZlV1RHN4ckRHSk5UMnVCaDR5ZXU3QU44SDhOeWZwZFFBTGhV?=
 =?utf-8?B?K1dkWFJyUVV5c2RDQTJVT2EyaEh2M1lnMnZKVmF2VkhNY041NHczdmxzSUdN?=
 =?utf-8?B?eldsbGR5V09pS2h6dldiazd2Nnh5dkl4SXo4UnB2ei94WU5OWUI2cXBOQUFU?=
 =?utf-8?B?NVRZdE5obEZWRSt4RnQzRFYrOEl6emJMUEwwZkY1MCtsaTRBNW55YmJpbS81?=
 =?utf-8?B?RmVEOXpySDJEaUFCdFRNQXFlM0lmaUN4K0k5bFdlY1RXZzQ1RURwVjNTY2V6?=
 =?utf-8?B?Q2NRc1VSZmlyNXFYcFRoanlqb2xCckhoQUVqQzQ3aHZycWs5UC80Skc1Q0ZL?=
 =?utf-8?B?cndYWFd3RmNnWXRZVG1sbWdzUER3aWxIUitodE96VzdhUmhTKzd4WldLVFBm?=
 =?utf-8?B?bjUzd2JIbi9kbTQ2aDJlZk1uQVhYUlhyRW11MDBUa2xpY1NJakJIVVB5RU5C?=
 =?utf-8?B?bGxJUThPcFEwVXJXOW92WnRFRnZZdGh2RkhLRkJRRU5XSGZSS2htOGFXeVhr?=
 =?utf-8?B?Q3J4SFVHVUl4alhRYmQ0NktBUGFnWUtDWFpiMWZVQ3NkVnQ5blcxRkRSSVB1?=
 =?utf-8?B?MU1yVks1TDF4VkNuV0QxRGdRcHJldlN1SzVXZDRUbFFLQzVQK1hGZEpLaHZl?=
 =?utf-8?B?eTlIeTk1cXpOR1VpRmxnYXdOSUViWmNHZDBnc3FxZTk2UHpCK0tVdm1rcEk5?=
 =?utf-8?B?cnI2MUdKaSs3a0ZJeEk1MXcxY3liblJreVFRVERtWnNQa2VKUkxKb1g0eFZV?=
 =?utf-8?B?QUhzM2U1RmVrYXZFTlNxbjBjSXlkaWUxN2U4UDV1YXVBaExpK3dOMVFBL3kx?=
 =?utf-8?B?ZGFGMnE5dC9lZVpycEJDK0g3dVV3MUNOTFBDRitxS3VOQll1ejF2d1FSVVpD?=
 =?utf-8?B?b0hjQTlGMTRjN2NSM001MGt2UFVScGtVd2Q4T01lSVNjN3hESUlJV0d3ZVRm?=
 =?utf-8?B?cmhHSkwzWDFBM012ZlhwdlozZldocHpVeDZDejBWK0NKMzRaWTh2azM1N09P?=
 =?utf-8?B?cDdpcjYzUGpEckdBS1U4OEFKVkp2YjZCdFVOeHFwbnVSTHF5OE56bGovS0FV?=
 =?utf-8?B?dE9oUWIvZ2krbTBXcUd6NjVLSXE0aVVJREFqWStpNkkrWFh4OXFjNlZ2OU4r?=
 =?utf-8?B?R1lLZm9wdkx0MGYrZzlhZ29DK01DaVU2U1NPWGRKdHhHcU9WN2p4ZUlTNjJZ?=
 =?utf-8?B?VWpMN2ZvcEVUTEZpV0g1UUp2Z2RpYkRSTjVJQVUzenVERlJwMkljRHBNQkJC?=
 =?utf-8?B?UFZHMkRVQTE4QkZUeGlzcC96aHJyZjVIckh0Z1hGVkRQWEY1dlVlZ0dDaDRX?=
 =?utf-8?B?SG5WWHp3YjlBMWpPLzg2U1BRU05nRlg4a3BlZ3RWTUJoSm5xTTFEN3A2QW9Z?=
 =?utf-8?B?SUJuN1dBUnplTVhxQVVCbjdNMjVQUkJzV0hCcit1dU9EZXhqRmdKTWxHT1NM?=
 =?utf-8?B?YVVTOFhWM09oQUM0MGZQVEZmbDZLRUVoTFVDSFdHQUQwdmpkZG8reGRYMVU5?=
 =?utf-8?B?Yks2a3ArNVVnPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5968.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YTZYbWdic3NPakZqRCt6cFJVK1NNdFgxOE9TNGVCcEhiZjdMRXVOd0d3VTNl?=
 =?utf-8?B?TUNKbTBNOWpRR0dBNyt5ZnJmdDd5bXUyYTIxL2pRTFpKN21ZMGt1WG1TRENy?=
 =?utf-8?B?dk9xRjVHemQyU2ppS1pPV0tMMXNKRUxqOVVQRldqb0dBNjNvcGF5ZmZrUDNW?=
 =?utf-8?B?REpQcEx6QXJUZXJoN2ozNTB2ek1FMW5NaU8vQlZoektvUmg4ZUdEUXpxUHlk?=
 =?utf-8?B?blFuUlliWG1GcUpzQUcrZWJvdXQ5ajMxdERYWStWRGNFK1EyTTZSbzBTVDRL?=
 =?utf-8?B?cW9ETXpRSWVvM2g5SW1zdko4cU1GdndqWVQ3Qkgwc1FYZFAzeWl3Z0ZVNXgv?=
 =?utf-8?B?RXkwNmpPYnZuQVNQbmVTRVNmM0JEU2pCL3ptdmpHOFFXT29ka3ZaU29ockMr?=
 =?utf-8?B?QkM2TzZKanJxOU9va2xmUHdKdEVPYzdQZ1dRWHoyeE4rWjdNYW96eWpLZlkr?=
 =?utf-8?B?SmFHSi84dWZrWjk5djk4M3VpN2V2bUttU1FEbEI0K0pHSHE3NUVkT0xLVjFC?=
 =?utf-8?B?dnRlR0lTandxdFRpRFVUSDlpb3JVeGVFKzZJT3pUOStWRGh1eVhpNFdjT3Ir?=
 =?utf-8?B?ZDJRT1l0OVExUDVZd2dmaTBNeC9PZTZQOE85YTErM0RIdFp4NDVhWWlkNk9C?=
 =?utf-8?B?SU1lSXlrTW5aZXcrTi9ISDIxSmpNQUNpVmNIZ2MyYlI1TSswUkdDR1JmV1NN?=
 =?utf-8?B?QXdaVkZkY2M5U0Yzc200dnA1clBKa3hqWG0zdkUyR0V5MUdPczR5eUcyVisx?=
 =?utf-8?B?b0dnRVRGUWJXSzVSTXhFUE1sek40T3Urd0p5Q3FKV1N3eUZORFdEYVlCcjZQ?=
 =?utf-8?B?cWlvMDhsdUNBcXY5NzRIeWV1aGlGdnVkcncxMDkxV0FpSnVsQXo0OFVrWnc1?=
 =?utf-8?B?OEVsWnFhTHppb2FlNjQyNXY3aXpHMXFtUFpHM2loQXkxTE5hNDJ1UTFoSkhv?=
 =?utf-8?B?S3IwSnlBWTg1OURwMXhWbWFIQjVjUWpLUGh4d2hPZytSV254K3FOeVpFdHZP?=
 =?utf-8?B?NjlBVjIyWWd4TC9jM2NwYWVrVXBEaGlQMzVmalFjbFhJcHhLTTgwV2JsaUpM?=
 =?utf-8?B?MmpiRkVHcnZpM3FEamgxWURiRUVJQWJYRnc5V2M2UU9xYkZxZUZHTXNYNjhY?=
 =?utf-8?B?a29FSW16WENKYWJuQnVYeUtwME9yWGpWTFF2Y1B5SVFOaVRTUmlHSTdPSk5G?=
 =?utf-8?B?TXJNR2RJM2xDNkYvVHYvdWFhdG9INWp1bU9NMGZ0MHh0ZTVpS3VoYmhscG55?=
 =?utf-8?B?ZE5DQXNyV29HUzNNU2EvQVFxOXRoUW5nQjN4SGVFMVhqSGNzZk4vWWxUamls?=
 =?utf-8?B?U1BERDJEdlFlbmxqMlFzTVdtT2FDZi9HQXliRlBvMi9XL29jZnRXSTY5WUJ1?=
 =?utf-8?B?S3VtSTkwenV1ZzlyNnFhRUltQjUwL0d6aEhqL1NCakhIZ1hkd2VWbUpDRWR0?=
 =?utf-8?B?RlZYeXQ4SXp1bXo0TFVqeEU3WTYwNHJLVFA2UkpTczd2aGFHKzNFYkJiYkti?=
 =?utf-8?B?MjlJaUx6TUU4b3VFZE13eENvTjRVOE1KaHVpMGg0b0U2S3dHSUJjRHBsZWF4?=
 =?utf-8?B?bFVpbXYyY05naGh2aWxxYzJlNFAyR05URkhLWEIyZVF2UmE1RnYvbVBSdHVS?=
 =?utf-8?B?bE1tdHpPUzdOSGs5ejRiMGgrVGRtUTRWejVHYjBzdzhIWFZ1OUl4NmM2VGdl?=
 =?utf-8?B?clJUV3E4cWFrM25UM3IvdUtQd2pCOU5JaW0rV3Z1RmlteGZGZ0dBNG83bU5H?=
 =?utf-8?B?ZXd5MWhlL2h3azhUNmx2SUJqd2t4OUFLcllpd0tMcVFsL1EzaUwxS0V2a2NO?=
 =?utf-8?B?NE0vbGhUQjVWUnFpd2xsRFo1Nk5OZ05mUFJ0b1gwUUppVFdIRENCSDFJMVI2?=
 =?utf-8?B?Z2tNSnlKQnphaCs4RFkvRUxTWFg1anNxR2NZVGdEK29OSW9NYkJTd254VWcx?=
 =?utf-8?B?NmQ4M0RQeFh4NkI1dlhRaDRqcWE0TzA4Z0pjT2JXYmhySjVyU0Uzbk1XY1RN?=
 =?utf-8?B?QmRuU2NGREtVVzFuUU5vck1DOWVRelRmeW1MbTgxNmNDeVdrUVc4N3hmNlcr?=
 =?utf-8?B?dGdZUXBvUDFBNjUwMm9EaGl0ZTZCTXF5WVlwTnBGaUU2ZGErL0t6KzNPanJ6?=
 =?utf-8?Q?ax2Kk7hsC95/DNqiptka/AZCk?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4a79fbc-7f1c-4225-56f5-08dde4044828
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5968.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2025 18:21:59.9995
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m79ghvQPgl2OqVerG7LwXDPMHsPT5ZHXlBQL+jWhIXDaypHmlnPO+eBlN4D5xWLhysGFQ9HzzD2y5FAk4NQhPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6624
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: ECA4680005
X-Stat-Signature: msfuizaned9etghkreedw5hjbz18sp1d
X-HE-Tag: 1756146123-191552
X-HE-Meta: U2FsdGVkX18WBE6TZHeM8bzEs41ZrIUFFnuAnNCjLcAN6bANGBX2kh8SzK1Lx/hrIcuUYDi9J5/lrrFmebL5M/TWl+4X1OoPqhmP9AQaRORy2BIZTU+e7CmSfoFp1IgwaeHLtjCMfT0vStE+D0s7TJ3vydKMzJ17VkeIrAUhR0hdMxaK3RpWVKiS65B7YxNHEucENh7aGgvXqo8HBFeG89elmM3S6I67f9SJzWM3xEiGf8XKQJ5q4JTsUkuU9P821MOFF6Ft14kfpFcL3dbc2r0Rn6UDGRVC31qmQ1f3D2h7x3wTqy0gitdnvVM8XtPY7EXpXXeIyi+fGtd8jCC5upd96tmJoOBibbg7GBqZxnU9HsYfu5IFdZbxkrwqaX3Dc7Spd3WMCHbWl7hlDwgZjpdLzFQrRn1NzOzKtGRC8E8hew7XMtA7QS/mnZ0Qh4seoQmS8b5yliKrcE8IEoqPCnbsR+atrOb+noSj1NRM/C1e+XOmawz44gKJiyA4C5Pt9Px7i++z3nCQ67Bvz8JynzDy7iwBKNMui50O438rbmDSbOXUxoRZybbnejqxuZlEDUARu3ZmHgsg0vSHBVfkZgnWdqlFoT0kF3ZQ5xn25EhE+SvamvDa88Rbi4NN+GOZC/NNkLYtBVaVTtjlEF5AE5IZhnowxXoMqvbQ10H9ZAtO0HqNDl4OoLXFg1+GRIYxDh/8bHttrmvAq29o4Qpkikhc3jK8X9Vg4Ef960Iu6WPVtcaJ9KTrFh+CB6StPhuWHar36DS2nnzakhK5wmLbxcjGDS4T7ImomjnlxsJdr35aQw2sUq0hPyaOMgD805RtZqp8Y5KoZ3z4jQ5Vy1infXioZZBotJKdV76/Y0EOiOEhVYYK2XBLYJ+LtCGlMpizXgCB6FzmNm1gTih3wudPlQodN5pd6sQLyJTUasKupvEeJ3qSMRksRHNibFw/C0aZHy41Koo7s+5foY3dBLH
 E924Tkif
 cc0m7jSdZmANnfIvWQ7DulhjAYy/11+5cZWrlr5gIVOTGM32E/W30wzvFGAI0bfwGAmlL2ZfJv3By5FISGo6hMN33DFHrTE1x0+FY9FO1rUzniwhq3zItSF++prGPIT0OpQS65kj6t33zMXQGXoexfWffLO9MHZBrkFR+7vM5hRx1xbTSA3y5rRW6OUxsfDmHacH03Z0cfRf14BOkEnM10iXUFwUufreXQepzbEB8O20vhai2LLdq3GJOyK/DTLF9ziJvOech+GfLoeraZpHVfDprsl1QZmSRy5KQsUNWup/P4z0e9ssflYc/DAeDpjMiQ3Jsgu656N2GA6AAuiqsvJv8sznxaI16ZxF8KQ9iJUmlKXJiIpszbJRoAU5N4R5Ymb7mDbHcbumb7S7yPIPmkW2qJNp8srwkAlEQD3A/N7o+L2unso9cdkA7zLpjDSEY/qPhU0Bzgrz4Uc9JjAckCEfFwhH1NBJGdlErMC0/dRKDPbsUhZHjd5ugMvd34pIbf19S
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/22/25 1:21 AM, Muhammad Usama Anjum wrote:
...
> diff --git a/tools/testing/selftests/mm/compaction_test.c b/tools/testing/selftests/mm/compaction_test.c
> index 9bc4591c7b169..4fa03679e9b07 100644
> --- a/tools/testing/selftests/mm/compaction_test.c
> +++ b/tools/testing/selftests/mm/compaction_test.c
> @@ -203,7 +203,7 @@ int set_zero_hugepages(unsigned long *initial_nr_hugepages)
>  	return ret;
>  }
>  
> -int main(int argc, char **argv)
> +int main(void)

Hi Muhammad,

This is not helpful nor desirable, in selftest code.

In fact, I think this particular patch is actually a solid
illustration of why you probably should just abandon the -Wunused
flag in kselftests.

Skimming through the other patches doesn't change my initial
impression, either. This is adding churn and admin overhead,
but for test code there is basically no benefit here. Certainly
not enough to be worth it.

thanks,
-- 
John Hubbard


