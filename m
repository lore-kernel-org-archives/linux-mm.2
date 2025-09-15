Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 328C5CAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 17:00:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 893868E000E; Mon, 15 Sep 2025 13:00:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 844628E0008; Mon, 15 Sep 2025 13:00:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E4588E000E; Mon, 15 Sep 2025 13:00:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 597528E0008
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 13:00:21 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B5C1013B9AC
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 17:00:20 +0000 (UTC)
X-FDA: 83892097800.04.80444C2
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	by imf15.hostedemail.com (Postfix) with ESMTP id 29298A0024
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 17:00:16 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=lNMthA4X;
	spf=pass (imf15.hostedemail.com: domain of "prvs=5353faf606=clm@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=5353faf606=clm@meta.com";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=meta.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757955617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5CfTm90BbIAgIIugklEMBEwc23R+hi0vIoDc/UMOmcg=;
	b=IbSZ313U4OSt0cDkWChxWqaUS+3VWgZGtPb/iTfG7VrIlvQzVRcPYJCVbSFG76UZapdFMJ
	M/7v96gL9neWSRXvgfvnfTi87phUUUForwnO5XYumDm0t6SVVLzW8BVUw+/cv9bEPuMmrh
	+BQFiy4rRAVLgWJTm296PLyfmBtFk4g=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=lNMthA4X;
	spf=pass (imf15.hostedemail.com: domain of "prvs=5353faf606=clm@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=5353faf606=clm@meta.com";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=meta.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757955617; a=rsa-sha256;
	cv=pass;
	b=HYSsGVwXV3Qf4QAzRSxTFm1F49rE5HuBc6MXbHx2TywwlJbuCSxAzNGWK/00rZkLtWpN0H
	UzGuxldT5SDdLQwcq+Q2//h0hDbOvmcEV2BE7OM1bWS4HJk8goffn2nXjSLrsDVzqfoj6v
	OP83e8mgHgbscd9/czOM4ZWzVi13NMo=
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 58FGJsA32469692;
	Mon, 15 Sep 2025 09:54:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=5CfTm90BbIAgIIugklEMBEwc23R+hi0vIoDc/UMOmcg=; b=lNMthA4XaPxM
	3kThQseuhtzS9ZMdAy4IbnQ2NjK1sECAX9qmnuGq5mmeo0osCRZZpmeJRlfS48tJ
	9e9Q0VOf23/i3eMBSLVPH3e6rvLuclmazDlTHOjtzc6Ljp918vUY8V2ZFHNGiqrl
	D7Z2UqvAfrYfVPg0LVpLjQp2809du8hcJZ8GjewATud+NVQRuEUiksIoJvuZ2INK
	ql512v93QG36kVSDv2O+LV3+egSUieitVbr/QW7bhhry8JT7QVsgfCBcugARjuKs
	FE8nnmBg2lEr5rjxxNpwBgBlWM1isRMa5CuFFK4sLNBqOrq0vpafJvHBxijPIyVI
	Iw19Djja9Q==
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04on2058.outbound.protection.outlook.com [40.107.101.58])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 496j1xat3r-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 15 Sep 2025 09:54:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ckmEkTi5rxNzEQzQ8sjRCMCJHrLh2/mmtqnEALednNkr2nj6hPy8lcfEPfVO1hItUsXtWbRgLyG715fo0ZPaYKHWmeuUW7A0Bgi8DtGWscGha95D1Y9e/T41V6KSS4p0gT9k9tpnJpYChzWwktstJzw0xNUqDAa2aAxEwMaOe8dUc0JI2FjG3pBFcdhvt2GmhADGkEhFvEEq37PSOWAb/TNImg14zzjH2wUCyBLH4Kh6hI+0EwBt17ckOmgfYXAq9U+mhPvhJuk1+neYDxjIJfrCDD4sJkgu556s+rgYgo39aZzhuIICbYoUFMoObDDviHuCoB9IsdPE1eokIUTgCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5CfTm90BbIAgIIugklEMBEwc23R+hi0vIoDc/UMOmcg=;
 b=vHNYe5LNx2kPXAaMlzmvZ8DBURADpNlclW+zIyKlnuHrqUrEUsBMok40QSLQerNwnCVXmyybL+PeiVQlU9ApJ57AL5M1zkDZk1u1HgTk3l1Fi2pVbs7x0xzu9vSrmVdG4+C18XmGcmGGyQgmpcCjckioTUaSYRqrVSTeHfcQLS6wmt5jPsN+VOx8OMPMwdBO7JRSYEEIJycsF3xNQIvRvTWc+TmFnWF4O46ZRpOhtdD1FSv/4ekhRX3CqEdtiXonTDKhjKW82WI8P9maSsMvar5iLaWPkF17dbDT+t/5V/W/Ex88OC08RWcbk/jZhp9UftJxqF0StcrCSDZTdaslUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from LV3PR15MB6455.namprd15.prod.outlook.com (2603:10b6:408:1ad::10)
 by LV8PR15MB6634.namprd15.prod.outlook.com (2603:10b6:408:257::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.19; Mon, 15 Sep
 2025 16:54:47 +0000
Received: from LV3PR15MB6455.namprd15.prod.outlook.com
 ([fe80::8102:bfca:2805:316e]) by LV3PR15MB6455.namprd15.prod.outlook.com
 ([fe80::8102:bfca:2805:316e%5]) with mapi id 15.20.9115.018; Mon, 15 Sep 2025
 16:54:46 +0000
Message-ID: <6466a351-4c3a-4a02-b76f-8785daf36c0b@meta.com>
Date: Mon, 15 Sep 2025 12:54:36 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 14/15] mm, swap: implement dynamic allocation of swap
 table
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>,
        Chris Li <chrisl@kernel.org>, Barry Song <baohua@kernel.org>,
        Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Ying Huang <ying.huang@linux.alibaba.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        David Hildenbrand <david@redhat.com>,
        Yosry Ahmed <yosryahmed@google.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
        linux-kernel@vger.kernel.org
References: <20250910160833.3464-15-ryncsn@gmail.com>
 <20250915150719.3446727-1-clm@meta.com>
 <CAMgjq7A1hqQ+yboCtT+JF=5Tfijph2s4ooSqNwnexQ9kwJOCtA@mail.gmail.com>
Content-Language: en-US
From: Chris Mason <clm@meta.com>
In-Reply-To: <CAMgjq7A1hqQ+yboCtT+JF=5Tfijph2s4ooSqNwnexQ9kwJOCtA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BN8PR15CA0027.namprd15.prod.outlook.com
 (2603:10b6:408:c0::40) To LV3PR15MB6455.namprd15.prod.outlook.com
 (2603:10b6:408:1ad::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR15MB6455:EE_|LV8PR15MB6634:EE_
X-MS-Office365-Filtering-Correlation-Id: 601a07ef-3e91-4a4a-84d0-08ddf478931b
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RGxPYUFKYlNkOHpqQUc4elhDRG0rT1R2QnB3SXBleUI5MmtBL0ZVVVNaSFhu?=
 =?utf-8?B?LzVMQXpxVFhoczVYdnBYRjZ3d1NCVkFzbjBuY3BWZ1M5V1BIRXhuVExySSto?=
 =?utf-8?B?b1JHZzMxQkI2Tk8yQmhOR0M0QkNNT05UKzV0cTNtZTNQN0tsNjU5TWdVWklC?=
 =?utf-8?B?NXptYTYxZTBkNUVSN0FFcTFwRWhPdFhsVmZxVnNyaUloMlpMTzd0Y2xsU0dk?=
 =?utf-8?B?YXp4bTBlQ2YwWDJ1bWRNd3ZPRVVoZGNiQTArSHNWeDhGbER4akRLUFZscDRU?=
 =?utf-8?B?NUppU0FQSlkwM1k2d1R5TGpIdS96azdTRWoyK29KR1Y4SVZ6emhyNWlkNGgz?=
 =?utf-8?B?V2VneUdJWUZIYnVxL1k0eStrT20rNjUvZWRPamhIdUxid0drbDgwUzFFYVBW?=
 =?utf-8?B?cC85RUgxcjdrdmhjUzBLMTN2VG1EUVJ6ZDVtSWFaVGpJWE1xbzBnei9nRnp6?=
 =?utf-8?B?QXFYdlhvQ04wbzJQNERJUERUdnRoUHRXZS9ZRmtuRDRuaGR4YWRWemhycVFy?=
 =?utf-8?B?bDN0THVENXJoK1hhWEhxWS9FRk0yR0svaW42TGF1bVZEalRVRFk0Y1NzeXBx?=
 =?utf-8?B?M1FPUm5yT25Mbk1NRm0yRGhxcitrWWttQy9NWElPTkZOQjVsdjVrdGtlOHlX?=
 =?utf-8?B?bkZhWlhmVUxvWWgwa2t4K28zd3RramFSQm4vY1ZETFpsQTQ3U3RLWHpubUFn?=
 =?utf-8?B?bTZCK0VBaXBDdnBhOUI0dXJ5VTNpTTlKWTg3anZSYjgvSTFUQk5BV1lLaGhT?=
 =?utf-8?B?SGc2akNBNTRMSlZIU0VaTXBUTCtnZzVFTUZYZXFFU1VSRE5Ub1JIK2JDZmtv?=
 =?utf-8?B?b2ltUHZkdWl3QXhzcVVTbmVSSDF4UGFoSFBJODRkWVNQR3VDTm1YY3FvZDJK?=
 =?utf-8?B?VSsrTzJYS3FEWUFxL2tBNGNXd0JrMVNIWjBUbGluaFh3QnFHOTl0RjNEMGp6?=
 =?utf-8?B?d0ZZOFBJUXBMdkI3UzFpZjk5U2xrRDZxRkEzaFI0QXZMdWM4REFFbXJCQXdC?=
 =?utf-8?B?RTBLL3pBUkJKSTdoaHBFRk96aHFBdDFUZlVrdk5RSmFMTElxSVlGL2ZJYWc1?=
 =?utf-8?B?MW1TRHJmMVlVei9xTzdRM3FmRDlpbzgzNGFYNVZvZUFnNjkydHJGWklFUi9J?=
 =?utf-8?B?NUJvOFpjNUI5VG9EcE1vZE1JOFVjZDhEcy83WkVNRUxvZXVMbFRxVHFNT1lL?=
 =?utf-8?B?aXg1dU5QdmRXREVvcEE1RHVxeEI5cmZVTVlyWEVpWTFyL3FjaXBLMkdRTStD?=
 =?utf-8?B?Q05pdldHVVp3M25hcWZ2TUs2UHdZZmR1ajJkKzhHQUJjWTdDMzhVd1lWRTUv?=
 =?utf-8?B?RkxaSG1wcHZrMzFRd0tRNWNqaHFHZ1IzcUhEZ0dGOXFBODU2aS81U1plcG5l?=
 =?utf-8?B?SEI5R1M1eXB1eVZ2TnZkcnVVSzAvTXFRMmhHUW5XZ0dsK3I4MXMzSy85Y3p3?=
 =?utf-8?B?bENqblhJSy9pT1ZaTWRneW9SY0JENXFka3RRdTFiSUJ1K042Nk5jcUNGUVN2?=
 =?utf-8?B?UnQ5UlZSbEJQbm5WdU12ajVPMVhuN294Ykp0dEhEelVNb0RuRDdRcytpcERX?=
 =?utf-8?B?bmpKbDdLZkQyK2ZRTmRFWng0Q0FJTFVvRTk0Ky92dnRkQXJFcTZOSTJxVExN?=
 =?utf-8?B?VHVveU9yekQzZVcxTlhDVE1QYzVhNmQ0eVJOaStVcVdHT3ltM1pnVVNzaWxq?=
 =?utf-8?B?L2dibHJRRGpvaXYvWm82bG02Y2Q3R3RvN1JqWHdWTTEydnlucVpHdnRNRlJn?=
 =?utf-8?B?NHQ1UWtLK2xKK2NJVllDeFNoY2I1QlFONFgrdjRnenRTeW04RDJrOGFKOU5E?=
 =?utf-8?B?YkRReHY0YVI4VzRLQ2wvbFRNRS9Zd0p0c0Y2UFFiWkdCT25PT1o3dWFaSjlL?=
 =?utf-8?B?ZUtva1FnaHVCWGtSNW0vNXJJTzlmWEFlSndlbWQwUWt6Nm9NMmtlUmNFTWw1?=
 =?utf-8?Q?sEpJESVx6Uo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR15MB6455.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?amFaSnVTMzRycWF2NWM1M0I4Vk95c0k5eldjb0FlUlMrWEt5K2ZjK21IcnFy?=
 =?utf-8?B?MzVGV3ZKbFZzcjMzR0xIb0x3WGFhNk01a2VzbVlrbGdFTkx1eTBDakxoYmVj?=
 =?utf-8?B?SmxrdEtQU1JaMFFvNVBpZ2pjVGNNZjJtZVVqbWNuWG9ycGZLQ3Z4aUQveGls?=
 =?utf-8?B?UEJ1b0pCYitYaWtNKzlsdHFweWhZQUYyb3dSMlk2VU9RZVBCdVh0UlpPRDFT?=
 =?utf-8?B?UmFZWk1acmlQamh5NldYK2pwQ2czN1gyUmNnTlRwUWpIOVdzdTNCd2F5SGl3?=
 =?utf-8?B?NEw1QzlVSGdNS1M5U25SOU9zRTdUcmwxRDVrN0VGbUNnS3kvM3lDSVhYV3lZ?=
 =?utf-8?B?Wm9waFNocVlnMEpPRnpyOVBQczhBcEJ6NDdEZWJ0UUFXbkhYcTcwcU8xeGxo?=
 =?utf-8?B?SVhvTzRXS29ZTitjcUUxWDYrVUNHZHFNSXdXSFhTa1o5bk00aklNSmIvdDNq?=
 =?utf-8?B?VUdnRVh2aHpCeWIvcnF0Nm83cEtKOG9XZ0tYZG0vZHUxeWJTb1dOczZqL2RM?=
 =?utf-8?B?UHFzK0U3d3JEb1FwMURoZ05lUlNPQzFwWmwwdkpUdk55Zks1aytXYVIxVDRJ?=
 =?utf-8?B?WnhEa3RDQ09SMTd4SDJTbDI0SzExWVJPeXRBTUJJa0pFYVcxS240RXA2bzRO?=
 =?utf-8?B?bDNiRUhPeTc3dEx0Z1FpMWZvNzdaYkpIZWtHQXFjWEtkaDlOdnNESW1hM2Yw?=
 =?utf-8?B?K3Y3RDhSSHYxY09HWFY1Nk94TzZCbzJ2Uy9zS3RqOGFlR0RiN09sWmUrdFBG?=
 =?utf-8?B?Y0dOZDAwU21GTkNZZ2xvMkRaSS8vZytpRG4xWkNtaEgxNTdYNTNBekh2ZXVa?=
 =?utf-8?B?UWJuYkdBcG5hZDhzbzc0ajN3aG9pT1k3ckFROXBENVY2cnl1ZXc3Y0tpN3RF?=
 =?utf-8?B?V2FkMTJYTS9OUFpDbC92WXRqMUtqc29adXdoUnN5OVBvcjVHNHFodWFpTzlZ?=
 =?utf-8?B?Q0xXZ080b0NGZlEvK09IOUhkdU5zVEo4U0lBcmg4U0MxVzB5SFhLNVN4WkJn?=
 =?utf-8?B?Q2o1cWtEZ2JoSG9vZmdrQ2ljL0c0NjJzbHhrSlEwSWkrVXp2Rk5aNStFdVNV?=
 =?utf-8?B?MTFLc2VkSmh3dklTOVRVZ1JaeWJ2WE5ZU3l1NHppSXJjQ3hqKyszMktkRzI3?=
 =?utf-8?B?QllOU0d5NVdZV2o1eGxoNm8wZmRqTERaMWFhb0MxcHFoOXNDZ215M0R6RHN6?=
 =?utf-8?B?N1prM0NZd2JYR01IdUdlT2V1Y0g2S3Vxc1l0QVZzUlVpSkRtQll3MGJBbXpY?=
 =?utf-8?B?M3BxbkV6RXVBbTVKSnpZN2dhTFFRUnhUemFpaUZpZTZDSlVBZStYY2VZWGtN?=
 =?utf-8?B?aWJLYWdtTTJnaklzOGFNampVR0RPUXFmSk1UbnRWbjQvUTVKTkExVGlqays5?=
 =?utf-8?B?cEsyb0JKZ01JMEJOeUJpTEVBanAweXZuUEt0RnJtZi8zc1kxRUFQL3FjdzNV?=
 =?utf-8?B?Tjk5Z2pmUTZKcFM0bmlLSWMxb3VYRlJlNGkzbFF6eFdCRytBQnlSMW1pUUVp?=
 =?utf-8?B?K0ZkU1ppUmtvczdGYXhDdFA4ZHZiTlpPU0d4TmlKT0kva2s5SytrdEJZMTJX?=
 =?utf-8?B?YTF3OWJtRGJERkl0eW1vWkNIRUkwQmVRbWtySExoWGc3cGhxNFVmRHNNZEZu?=
 =?utf-8?B?WG5VeXE1bG1qTlJva3BML1YrUkxPUFBUa0xCdGY5eUdSSm9DUWovR3BmMGVT?=
 =?utf-8?B?ZzhoREgwUFVsdmovWFV5aUh1OGgxTHlpVUovb2tuY0IxSWI2QnZpaTEvSTU1?=
 =?utf-8?B?SVdESUJ5VGIxUC9ReUR6dlJiQnp0bWNIYWFsVEd1NzVzYWI3a2M3a3VtVzQ5?=
 =?utf-8?B?VmRUR251aG5jM2dJUFB1cmNRS0FvNXY1ek9OYUJoR2JkNEwvVHJtRDdOU1JT?=
 =?utf-8?B?TEF5QVpLRjdwYjZsSE1kYW9YM1JHUDJIeTdTM0d5b0s1RHhkR0M4Rlo4Ylgy?=
 =?utf-8?B?YlNtMUFnZThtWHpmcUNZaHZTNFRMSXV5QmtxcUM5TUN2UDJkaW5JRzJTeEJv?=
 =?utf-8?B?UTRuaERuY2IwdzZrdmtPZ2FKbGdYbVRCYlhMWVRzRVJuUEJSMzlGZE05VUJC?=
 =?utf-8?B?S1RvNENMSXE1YmF1VUNTN1Rnb3hUS3M1OXpPd3Fmc0Rybzd4QW1Xcld1VjJB?=
 =?utf-8?Q?D5/g=3D?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 601a07ef-3e91-4a4a-84d0-08ddf478931b
X-MS-Exchange-CrossTenant-AuthSource: LV3PR15MB6455.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2025 16:54:45.9571
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d6x0kGQtmltv/KO28A8Z18g3I74gBGH6U21UtjAcuE0bpD+d46NTzzxR+xBmZrwI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR15MB6634
X-Authority-Analysis: v=2.4 cv=H9nbw/Yi c=1 sm=1 tr=0 ts=68c844da cx=c_pps
 a=wVmz3cyIAFP1k0kvbcbXfA==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=VabnemYjAAAA:8
 a=pGLkceISAAAA:8 a=FBkDTj1ZA-tlKnEz8ukA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE1MDE2MCBTYWx0ZWRfXzwAPHo0v/4gJ
 zfkoiJAZneonBcjwuESHKK5BznH84y9WDJ3Xyf0/92f1PBewlwcHZrUh8kwXkM7oXCn/DwUA3py
 r60TllIuo4CoZZGhiIWy3wVAxSEs9K3GEHI5YyrnmTf5/x/GYoJL5AvRfDCp2AohVWkfbT0JeG5
 CzAJUZuUo8Lq9U0AkLYIQURK+4gWCNRDPl1ueb7i3APUjCFAu9a7kNf9a832fp/BxhkILRtcU5p
 W/uSZwuXOkXL/Wq5VAhzgeMAaL2hqQTMxdr3NP7k/vfXi6ib84Oh9t40iNZKfDR1WGjCCGwaH3y
 OdhlIzln7KHFWI4b4aC5yCTsaj83rOZqRD6dt/Bm5hRvPsq3+zld6PVL6pScYQ=
X-Proofpoint-GUID: 3O3lwVYtOTz0t1xm-8iiu6YP6heCcs1b
X-Proofpoint-ORIG-GUID: 3O3lwVYtOTz0t1xm-8iiu6YP6heCcs1b
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-15_06,2025-09-12_01,2025-03-28_01
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 29298A0024
X-Stat-Signature: qbe1q4xykqoy1q5p7xaukadbsg6psmj1
X-HE-Tag: 1757955616-777424
X-HE-Meta: U2FsdGVkX18vk0Vbc5J5N7LOkozlMDoC3ONMN8P5EmZEb3RJ8d8GgYtkGjCde3UK3GPYw+KgdEqtaxH7Mhn33VEe1LWSRwGdSAVv5P9Mev27Xf7z/bHXULVXLyysIg7pxSqnmNq6/LpAk7RnTAViMb2c/ztnofYhsOmCNyoVHQobNIYXqXCDH7xgy2zZZEgBs2z6g7EEGhUKanQHqCwlHDgW8LXQq/vcA7oXDKlp7dmob2EbXpiZ9oxP5TM1VAL3W8rjUM50u42MGRwHQuN5LufSurOpe4ztfDLSAuNJbpkwVypw5rjO9Ca5Ii0Lg3fZhHoTmzj8MCzNcADS+V0JukhbOf8wZvBn/9Bxf0g17d+3HEBXnySZj9fCINfuRQkKWPswXlHbnDYuLYB0DHTouoMp1jznya8Jm1oKBqmUdr4ZBy7RGPgwQ8JtFHzKoMY9di7gHPYs1/wULXop2Bmmm8/jZ63ywSSzrNOamPKVsMERDECVJv2CztlPEuc/Urjk2JdffjCMgOEgFc2sozuh044aEZtbF6+BibmbDwCz5cIas69U7DyyBI8LLoQD/2ekCKrhedFlC+1rK66qp4uRsAotXqvc9GboytBmRM48y6g6ZhrPiJyA/kcQPMSlrTQKkqA79/8gmoPvZcnm7nwN3QkoVX7YldQ+aMdVkxuNC+KR3vVh8fgJlr39teGXGz4sW024MOhtMGnA5w5xzY6DL7XJ88g+JtYD7JvFpNrc639tZAmOCGEZFioR5Ms2S97Aqr/xRtRd2iOp5tMEmjkh3XpH5hNCQFb6NZJMibBwTyZQaJztTcPOyQzCzE3L+hq+AqmSanlTa4+tC8MUsNLPYBuC32N7JxTdzu8xwCdyKPzAGv6KjTL0D/q8fNiEQeCITNAEkSxAruSLC3X7HWV3K8xxO5SNkIXm8LVmrXmLZuwNz+Um0gK4FfGVCx87yaoxKBalefibW07fn2Mljoa
 ba9xzJ/I
 qLLGJFSZ63BBLg7xQyzguOM3v8wuY3V4Q1hNtd4E/MCD9eIvQ8T99MdykSMlgroSO26b9kYHjFUPmWhq4YeLa1QQDvH3Rd6yGR2rkOnfUOnbtXxKyBVEzf8YmkX9ohYXGIA2G9FCNpdAb+YiQUdi80t7PNY82Hl2qNwh7kKMcP22idpxBM4a/WSQeLPVfEy3UiMKoy/ceciBNPH0rs1Nr7ifNFGU0oxWPDuUafX5K6TMCvq/R86w6ivhZKxO2YOOZFP8tyiBq4kuGL6wZYuSEGbgOkpE3MaA8wD1uq+iAilhJS9pOqUiObqQrO+uTVc4jplQi6v+Z3jH08DiewGan2sD0B9IxfY58EPSn1QPc24rGxOlmSWhZq2wd4GxYRyiU4U4jDN6rWRQC9wfrR+auSjXUJDSk+rsllUvHlfS4dHXfCnOsZOF4UEJtnqcN1ydmWUpocBoBN1hAf69P8jbNdChgePYv054kBFJudKrNGhC9YQmKGCibRzs4i7vo+fNPmqrd5oAfvYpwhS48MErIM2Mk2GFfTwjro/aJhW96FgwhVV3k7dhX9NYdTpHmQhAbr1i4jbZ117bEpngvcbICoyCgOo0DxVdEd4ZEt0D1GIEJExrvS1haVtJT3c/ZE4yDGnczYDcO0kjkgBuNbAHEigFUFqtYZP7vpQFmvNHRU2f7XjbXjaQkDxdtwJbzAFZCehc4O+vk5ZzihyDg2hvti6VZYHpKnlQh1GnF0aSWpjojmIvv68yFAjvT3E6+4olCHrco
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/15/25 12:24 PM, Kairui Song wrote:
> On Mon, Sep 15, 2025 at 11:55 PM Chris Mason <clm@meta.com> wrote:
>>
>> On Thu, 11 Sep 2025 00:08:32 +0800 Kairui Song <ryncsn@gmail.com> wrote:

[ ... ]
             spin_lock(&si->global_cluster_lock);
>>> +     /*
>>> +      * Back to atomic context. First, check if we migrated to a new
>>> +      * CPU with a usable percpu cluster. If so, try using that instead.
>>> +      * No need to check it for the spinning device, as swap is
>>> +      * serialized by the global lock on them.
>>> +      *
>>> +      * The is_usable check is a bit rough, but ensures order 0 success.
>>> +      */
>>> +     offset = this_cpu_read(percpu_swap_cluster.offset[order]);
>>> +     if ((si->flags & SWP_SOLIDSTATE) && offset) {
>>> +             pcp_ci = swap_cluster_lock(si, offset);
>>> +             if (cluster_is_usable(pcp_ci, order) &&
>>> +                 pcp_ci->count < SWAPFILE_CLUSTER) {
>>> +                     ci = pcp_ci;
>>                        ^^^^^^^^^^^^^
>> ci came from the caller, and in the case of isolate_lock_cluster() they
>> had just removed it from a list.  We overwrite ci and return something
>> different.
> 
> Yes, that's expected. See the comment above. We have just dropped
> local lock so it's possible that we migrated to another CPU which has
> its own percpu cache ci (percpu_swap_cluster.offset).
> 
> To avoid fragmentation, drop the isolated ci and use the percpu ci
> instead. But you are right that I need to add the ci back to the list,
> or it will be leaked. Thanks!

Yeah, the comment helped a lot (thank you).  It was just the leak I was
worried about ;)

-chris


