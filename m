Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0653C982DA
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 13:17:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6EF16B0095; Sun, 20 Sep 2026 09:17:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1EB56B0096; Sun, 20 Sep 2026 09:17:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE7136B0098; Sun, 20 Sep 2026 09:17:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8A4DB6B0095
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 09:17:40 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BB426C042E
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 13:17:39 +0000 (UTC)
X-FDA: 85234192638.26.D7C89FA
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013046.outbound.protection.outlook.com [40.107.201.46])
	by imf23.hostedemail.com (Postfix) with ESMTP id BE188140006
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 13:17:36 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=U29F+IsP;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of noren@nvidia.com designates 40.107.201.46 as permitted sender) smtp.mailfrom=noren@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789910256;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gLaLPVJb6wlZ4sG9P7Mw3v4kWKyVw2KAOXAn7liO71c=;
	b=37V+ISGi5qIRb8O1aYhmFyf91T1Hc1N/Pe9V3Q3xlzsoi+nHTuDttWkd3s/e4nxuM/JAHk
	B3qDa0AR7dA0EIzHZm0zZh4pqv6hb5lAwnQFtnehwX1rybV0+XBhxAUfCudMbMeufBKp/k
	yM9Wqj6IQqmBibpLTirldP5jGVzl9J8=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=U29F+IsP;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of noren@nvidia.com designates 40.107.201.46 as permitted sender) smtp.mailfrom=noren@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789910256;
	b=XtObfDJVioS0Dd9UfICAgmGHL2e9CoWPhje2Z57whTjDcAkh16WQAAMnVRiPAksfPtlH7E
	LrYaEufkdQA0Xijs4JCTPqPadtdijE4dd8ApCbrpo+5vJ1JJAzetrHBdmZ5O0FVnapB9gH
	+9F+rFd7O2hsJbznrzI1l4aO2NtcToY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u1pzDf5sTGxYruYsPBnbexaPaZojAzuje+cN8YBu3T8JoC+u/EOq8V9N4oUy6e+CnfCACLgpCXVEuyz46DyeL2XXDwfRO6AYQIuL+0s4rL7TuvPV9eS8B3wt2EBmWmp3r7cS5vfOmdDn1eVtldF8s++jINsh2BG9tMTVVglKwKEGU9ZSvQjWVdR2PCWSkOlMfHB/+/Nyeuxw8PfCJ1HAMuSEfadllHhThLDpe5x0WwpptgW4yYt2gOrKuZhnMTkn8Hw6Dx90+loNnaPt75vcdxsVS56d0IwjlBlYq6ZGknlyV0ZsejAYOS7RjOr0cQTHCTWT/4mj62o87Z1l+VELkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gLaLPVJb6wlZ4sG9P7Mw3v4kWKyVw2KAOXAn7liO71c=;
 b=RywrExJF9CymfFGOOYxg8VzwusZliZBMM67mKQ1tp9JWc9YS0BSmA2Nfv3XoZdS9RnFNiZNgIzCSt4IfvD3BGuhweAZLRb3p/FTWjlFJo8yG0HUk29SxOUeEUzhWQ9VcOwPAEcl3rjqQZvpLl1m9PfcC+s2WAQxH3vFzamZxYvurJ+6sNSvTuCEbVQ6B3OlmkKvBR9+X5ot6me5hIzYImXpRPytaD5S7vPV+CX3U6Uih/MmMphTs8FLrJ2+pTSD5d7O5pDKCI6q2yPo+kljjRHhaHp4iiBRYsWU4eFn7m+YQUfnCwkMRRj92c71PcnTaHRLwhOooyrkRxtOLCJtkhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gLaLPVJb6wlZ4sG9P7Mw3v4kWKyVw2KAOXAn7liO71c=;
 b=U29F+IsPO3A9k42MqErDn7HZPS5MnOedjrD2zcTbMP9EpFwOrqO6lpYHvT/Z7C7odRPdTAyIgRzUxINdYlTbNQX+OPBA2i2N4Ou6Ww7GGFbfhtLfdOJ6LACrCXBblDPl5xH/urq/EH+36FYQvWpdyL2WBi6LeOVhvKkfMdXcEAadWUDml/vmnrV8vOYMGalkTh7mv1cxvy/rTnzsyADIlfxw4pBhAsTqi+nLEdslX4kJcnQgt0GF5u1xZst24VJ55ATiDQQgji9e+fr1ixAPXlI38k3m3z4qj1o3eakBK8ZELslc+CFmG65uOXK2Bol6J+v42Ht3/dwSYtp5XenRrg==
Received: from MW4PR12MB6802.namprd12.prod.outlook.com (2603:10b6:303:20f::19)
 by PH0PR12MB7095.namprd12.prod.outlook.com (2603:10b6:510:21d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Sun, 20 Sep
 2026 13:17:31 +0000
Received: from MW4PR12MB6802.namprd12.prod.outlook.com
 ([fe80::51f4:a3d9:b44e:9587]) by MW4PR12MB6802.namprd12.prod.outlook.com
 ([fe80::51f4:a3d9:b44e:9587%4]) with mapi id 15.21.0428.014; Sun, 20 Sep 2026
 13:17:31 +0000
Message-ID: <1e29995c-4877-4d83-98fe-88da780b6d40@nvidia.com>
Date: Sun, 20 Sep 2026 16:17:22 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm: remove min_free_kbytes adjustment for THP
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <brendan.jackman@linux.dev>, Hugh Dickins
 <hughd@google.com>, Nirmoy Das <nirmoyd@nvidia.com>,
 Dragos Tatulea <dtatulea@nvidia.com>, "linux-mm@kvack.org"
 <linux-mm@kvack.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20260901190123.3511535-1-noren@nvidia.com>
 <20260902162323.GO3004@cmpxchg.org> <aphS2TancJAZLND7@gremlin>
 <20260902183752.GP3004@cmpxchg.org>
 <a1f19a59-7dd5-4fb1-b5db-3efee8d249e7@nvidia.com>
 <20260917134949.GB1344@cmpxchg.org>
Content-Language: en-US
From: Nimrod Oren <noren@nvidia.com>
In-Reply-To: <20260917134949.GB1344@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0106.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:bb::10) To MW4PR12MB6802.namprd12.prod.outlook.com
 (2603:10b6:303:20f::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR12MB6802:EE_|PH0PR12MB7095:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b53e0fe-a3f5-471d-4983-08df171986ad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|23010399003|11063799006|56012099006|4143699003|10067099003|3023799007|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	7dWquMTLi27OOCaMKeFnc27aB/vbbPJR36jnUNFIx7rSJzMfX4EcIJFu+OFKnjLOmT4JfJwv+S7gh3S9AYwUXyX43aEpJARhe6WhNlG1DkqNsBjexv9080Oh/9E2iy+cs0St7SYP2NpGA9p+QE4BKAWpO/qzeLUE4+0b+hn5Xu2fVbS33s+CWdEC4Vsuqp83Adtz6A8pN8Y+VrCJH33xPwphF0V42HozH68hS4F+VlpZTTS0Wov3qeIXQFX61Q3/C7MDpvQ0YT7s4McPehOgG87/6dr4usSYo2jSfwr0AJRePNMF1r5o17Kw3nw99KepiCpbeRk3j0bsgIsFyRmFwvK0oYV3n05jbOe0Udv19DxuvfOw6EeYKeTJ/SXx6XrZTHEoxmaQzJOMs71pC7KvH3Ex6438a5OEL+vncz+VOfbb5m6qhLggzS2qIlOoYibIPlfINM4llW2m7N0dUQmVQp2ZnwnDQT8YzrgePtspomqu4EbRQUeVWHxLNnlVMozYg7AWS4XNNQ6+NwhlFl4/zvdduYHtYPAuPNzE3WsK3PyaFl+ok4R4C9HPbU+bdfmYhZ9mHKQV7KzAC0RSj2hhPe8XFeVVSSFtSbtR0lcH5Qq9vqO2w83viZnNA11LJqAOzUZWjamSGMXsvCRa028KSk3ch8Sr/10WrUR7U7bvXhg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR12MB6802.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(23010399003)(11063799006)(56012099006)(4143699003)(10067099003)(3023799007)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WkVyUERMOUFTNWNsTUxpTkxvTTF2SGowMmVnMUhHTUpRUTFCK1djMmhCbVNq?=
 =?utf-8?B?QWdMUEtWdEVBR2V2VEJRU2h3ak5pM3JlcTlyaStDUW9vdUZ3OWJKeWRLSzZj?=
 =?utf-8?B?d3V2Rndxa0lpMVJiSUgxdmwrMFJObnVaL2hXMGdzSHQ0TFNzTERyMFBPakZE?=
 =?utf-8?B?S3ppMlJIMUJpRUx2cmJUcER2VGNnRUVzZ1IrTy9Hd1hUMFU1YTI4QkdPd1lY?=
 =?utf-8?B?eW9zKy9qeG15MlVsSjVRQWJCajNKZVg4NjgreW9LMzFsSWZCRlRsRHpiYWtn?=
 =?utf-8?B?bWJjTi9nQzVQYk53dCsyOXkvT0RqVTl0dzBlWDVpMEoyV2VvdzBubTkrQWxo?=
 =?utf-8?B?bEVmTFdFZTJ6SHVtZTE2TTM3ZkFwU2svbXlVdUM5WjV4TVhYVTdSckIwWFRk?=
 =?utf-8?B?enI0N2tzdzJxQTNNMlQ5akI1ZmVVdjNBMFFTWENVRjVTN2lrSHlVdzFYVzcv?=
 =?utf-8?B?U1MvUGEzQmpEcnhlNElWRWgvUDlOTURmWG5IUVZDSUN5Ui9WdEMxSmt0Tkdo?=
 =?utf-8?B?dEtsdWlzWVVHMlArWStaSisyTWZ0KytLcGZWc2RVUkRFenVCc0dZS3o0eVlD?=
 =?utf-8?B?SnRDeEh3MENuaDhSd1FTT1J4NGVJNFFYN0N2R2pCaHlpc21QMWgxWWtKdFB1?=
 =?utf-8?B?eGsrWEpLVnVmVUR1b1I2dnNUeVVwN1ZlakNvNkQ5VUVLb2ltbWxWeDV5S0Ro?=
 =?utf-8?B?K1Z5SkdONWxKNmdsR0lmODFhWGhWVGJYRHRtcWkwZTJLYi9hMm9nWFRGSm5Q?=
 =?utf-8?B?QTVOT0E2cTJPNlFWSG9scTluNFJud3hycTJuVnNvQzNlQnU3ZSttaGVHQjlX?=
 =?utf-8?B?WEpUb3hBcVRNZUpsM1JUM2JucmJidWx6aXcyUnAwSll0VGRrRTFFSjhFd0Vj?=
 =?utf-8?B?VXQyU3g0T2t4MVhoWDlmc0VEeEZFZkJmSHZJbVh1SFNGNG0xTlBrYUV5Q25u?=
 =?utf-8?B?T2swQ2RaYWZYTG5PR1pvR0tleXUyeWsvMWpXSUlPZnFVSDZtaitmWkFjcUl4?=
 =?utf-8?B?WmlqbUtDcGRvYXZFQUg3Ujcvd080Z2w2cXg3YnZLTGxzSThBZFdtWGsrc0Y2?=
 =?utf-8?B?eVUzend2a2dPRTBFdHJNM0hrMmQwSDZiUUJMT2ZsaWxlejVTR05ONmlEaGl0?=
 =?utf-8?B?RUNPK1ZRSUhrSHFxelJnTGx3M0h5bVgzNzFhZUdZNFJ1MDBWUDAwYm5HWUxw?=
 =?utf-8?B?bDIrbEI3YW1lcUlpeXdGZlZqR2czVUJlWnlTSGtBK2Y4K3dJa2JsYXNWUEw1?=
 =?utf-8?B?YnZLRnBEOCtuMmcwWjhBY3hnOHNFUFZlOWMwRWJEbndiaDIvbEh4cW1BdHRh?=
 =?utf-8?B?eWNUakdtTklJNmdVQ1pXQWZMNGp5UTd6ZEVCcGJtTGNNT1NLVTMzS0ljNzNN?=
 =?utf-8?B?aHdCMzRKbnZlOWk2bnB1L0Q3STBEYnFPcU1URzN5THphd3dVU0hwSVoydmth?=
 =?utf-8?B?cSt3TElJZGVsaDQvTEdQVmtjbGYrS2dBclk0OEc4ejJ0UHA0QXdWWWFSQm01?=
 =?utf-8?B?bGJlOEU0M3p6SzZyMm5ZL24zTXZ6NStOWVJrd0Y2T2Y5YWtjTnNMQjJPSm9S?=
 =?utf-8?B?RDkzaDZPaTcrM00wYm5LQkY0bTBoSlhwOTVxWHI0dk9IT0duSit6UE55WHhD?=
 =?utf-8?B?MnJUTmUycklBaE1iV2dxVnFSb05nVFZRS2F4ckQ4UjhDVERrZGhLRnJLajli?=
 =?utf-8?B?czQ3eG5XNjNtM1VBWHgzSlhCcUdUbm00VE9NMllNWFJXWmJkR3VVTy9Qa3pQ?=
 =?utf-8?B?cTM4c2RYQlhObWJiSkdZTWI2MjZEbDRWNTgrVTU2VGkzSkdoREtrT0VHMmNO?=
 =?utf-8?B?cGluSlZGakl6eUkzTEtweHNjWmRvWkl5amtzZjZZdm9xeVFGU0tIV1dpZk5x?=
 =?utf-8?B?RVBDQnUyOVFZZ3IzRmhvaUdXRDBFcEU5RG1WNXZwdnZHa25zV3pkN2FSbkdp?=
 =?utf-8?B?UGc2U0t4SGJremtRQlp4OExEakhEeVp0Q3dHeUt4QUxKekVSVHg3SGtIZUV5?=
 =?utf-8?B?Rk5Nc29sVERvWVU5clhONzdxQmNuVXNGelJTT2NkMXZUV2VWT1ZNZmhTc0F3?=
 =?utf-8?B?dFE2emFQZUQ5a01vQzVNLzQzUnJoRy9yUml6SzdyYkNXZlNzRlBrOVc2MG4r?=
 =?utf-8?B?cnFYTTl0UHhQMklQTGR4c1U4dEdzRXdwRkhzYS9VUDZYeUlSWTRmcFRUcnY5?=
 =?utf-8?B?c1dkd29YSGQvM0hMNkpqTnBhZ0ZCYzgxdytnTGFwVXpTcWwyc3VjNFZrV1gv?=
 =?utf-8?B?cHFVdmNmVmFHMFpSZzk0N05aeTdzcnBTZkE3ZlFXeVVZNmlTQmg1bTBWMGRR?=
 =?utf-8?Q?uXB/A1m7ILCjoEUFKX?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b53e0fe-a3f5-471d-4983-08df171986ad
X-MS-Exchange-CrossTenant-AuthSource: MW4PR12MB6802.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2026 13:17:31.7385
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gBCPC8e2Z4irOeFrk1nTiNvysoI5OaYisgnPwzGmS3wNsUTpyZdDQC52jhNNoNL/evSooYfNjNJuph3agV6wUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7095
X-Rspam-User: 
X-Stat-Signature: 857phwhwzgiukft3jtzf7h4b6zkc5d4j
X-Rspamd-Queue-Id: BE188140006
X-Rspamd-Server: rspam07
X-HE-Tag: 1789910256-307613
X-HE-Meta: U2FsdGVkX1892oyQUauOlzrE+pPESVL0O2zINGKVSrNBZv8FZRZtfz7f5k8XxDWkvhZz0JZxJk1NeXtYIpxj2dcnxvGioH+/8umDgPxi9pyciIhYIangqRK/107ezkX+CwhMgxPvvdGhPIQGzrwW8zDX4Ufup5ZhA/ntT8Dw+sJiTqvgdBZpo4CCfD9eTr2Vewn4jeQ1GbliEwp77Vzu0um0Q5OetXMj+mWkFAlcKdIVdXArsVrNVkdw623yaA9LnXW6NKVGEjwjWGXI0VB31AbreMufwH+Kn3iqcPEwdwnDa6az5XD4WEv1eNbdiZPYCu8wUdGxSqs1II9eFexEZaRyQZCagAzeekj0xKgzlZGme6UDxVaORliezxNo+peigx2kor+5EFgm9JSdjJvoN+UH3IFPArA5nxStP3n0rjGFt0+XWQ8mPP1PHnFxcY9XJF9w4hUydy16vpHSG7W2APS0TdksPn6/O03OB4hmLPtQFD+e9ihP0RA7OwRy0Y3jqZAmmRZgiLDEs8ZScSLs/bvpe7dUPjdYPhMkiYADxfcq0Jl4jLwzCa6w4amKJJOTlyViOyqnlSUTwc7gyqe4PSTUtP4b1jN0Lnkx95I6vUioXX9k3Y5mebvOGSZhoGK1KcJjKoUfrqCNRKaCo82l4LteEDbOaDHRA3eTZcToh+F5kcERYMy+SgYpBgBvwmjqYFQpWDpKmpXBbIcNWqQU8V1npsme2OIje73v5tkdxKvEilyCjxikUFmQHclval2RjdqKA2OpNjq7z+QsqOsuxeKAOT9JspTXGpK+SnYU4HYw/5YHREOgRikcLEeI9825U4vN7n8UnnYq2jXjPOOcynaeoBsjj6ecO2KZr9Wnnmyb2jkK3xCaKn6teh3SUwaKKh/zj9Ay2Dn1x6kqWoP9xBvwoCeTMiy7EVdwFX3mSX75oqaJpXjrCcq8OMQGgmM9jQfh8Mq2yqvDIigGsJE
 b7AsUpZq
 drLNtcfMEaEc+T0BnFDZcb6dvBLKsfrSFJbu5hhjRdeaCw6W9hzsm30bSS6Mm1COrpIC1Pwj184Cyw835To92jZmQhSZJuXu6Pj+Cu6ZtQL8rdjkVYFvXSFR6ZBO9hcgbmmahk9GHZL7fWBEev/2+tQeg4D04uIBsZ8KYdMIlCSM3Jnuz8RsGDJMlb3etdRqZGy8SEj3JeuxRuOZvYsgi4vIFNkVJeZJ74VVt+ThY6W04Z9cB0ClUPmoF6AEdaN1LSUFRijiftc1Og7DE+a3ERjGa3VGOjPH7hw4yAXPtVlNiOx+3NOdQ06Jof452zPOwLB2OoW3Wd8X1z7mS9NLmdz3zysmcJ1c9JOEXIK8mhRVPCxbcZF5RPSIdo4Lvpyr0DZHWC89KHCOGauvJmgum82C1MFCLMX0JFQ2OnZ3El5t8038zv9LBiyU5pS6YsdbTeFTGIrIY95V7oAEH8uW1MuqGIgv1REgS0lT7n/pZdD4k8EpuzyFKKYn6dgXFZewctqQkbCzTQcr8MtH6sPPUuockyCDLmdFBKz2AliTNmPo0RdtgnuQmdszu0g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17/09/2026 16:49, Johannes Weiner wrote:
> On Thu, Sep 17, 2026 at 01:19:12PM +0300, Nimrod Oren wrote:
>> On 02/09/2026 21:37, Johannes Weiner wrote:
>>> On Wed, Sep 02, 2026 at 06:00:55PM +0100, Lorenzo Stoakes (ARM) wrote:
>>>> On Wed, Sep 02, 2026 at 12:23:23PM -0400, Johannes Weiner wrote:
>>>>> I'm not against carefully evaluating and testing out today's need for
>>>>> set_recommended_min_free_kbytes() in real world examples. But this is
>>>>> not that.
>>>>>
>>>>> Nacked-by: Johannes Weiner <hannes@cmpxchg.org>
>>>>
>>>> Isn't every possible change to address this kind of issue subject to
>>>> exactly the same kind of constraint?
>>>>
>>>> I'd like to know what not rolling that dice looks like :) or what
>>>> constitutes 'careful evaluation'.
>>>
>>> Usama gave some great examples in his other email. I'm not really
>>> arguing to keep things out of tradition. But I think it's fair to say
>>> let's at least test the common 4k/2M THP setups under memory pressure
>>> before and after the change.
>>
>> Hi,
>>
>> I tested this on an x86-64 (4K/2M) virtual machine with one NUMA node
>> and 16 GiB online memory, using mmtests config-workload-thpchallenge-fio
>> with THPCHALLENGE_MADV_HUGEPAGE=yes.
>> min_free_kbytes was 16 MiB patched and 66 MiB unpatched.
>>
>> I ran each kernel 30 times, rebooting before each run. The results did
>> not show a regression in THP fault success rate or latency:
>>
>> Average THP fault success (Percentage Faults Huge) increased from
>> 13.07% unpatched to 13.34% patched, and average fault latency
>> (Fault Latencies) decreased by 6.5%.
>>
>> In contrast, compaction metrics were higher on average with the patch:
>>
>>   Compaction stalls:          1,635 -> 1,713        (+4.7%)
>>   Compaction failures:        1,350 -> 1,416        (+4.9%)
>>   Compaction migrate scanned: 4,812,254 -> 5,587,587 (+16.1%)
> 
> A 2% increase in THP success bought with a 16.1% increase in
> compaction work looks like a sizable efficiency regression.
> 
> A scan efficiency drop is in line with expectations of what happens
> when non-frag placement reserves are taken from the allocator. A
> comparison of trace_mm_page_alloc_extfrag rates could be instructive.
> 
> Why the 2% success boost isn't quite clear to me. Allocation latency
> improving suggests the extra work is primarily picked up by background
> compaction. Reduced reserves could be making proactive compaction more
> aggressive. But the improvement is unlikely to hold once you run out
> of idle CPUs and the additional compaction work actually eats into the
> workload. It could be useful to look closer at who is doing the extra
> work and based on what triggers.

Thanks.

I ran another 30 pairs with the same setup and workload, this time
adding identical CPU load to both conditions. CPU utilization during
the measured workload averaged approximately 99.7% in both the baseline
and the patched runs. The aggregate mpstat %sys value averaged 2.25% in
the baseline runs and 2.22% in the patched runs.

THP results:

                              baseline avg  patched avg   change
  Percentage Faults Huge          9.92%        9.12%      -0.80 pp
  Fault Latencies               4923 us      4856 us      -1.36%

The average difference in Percentage Faults Huge changed from +0.26
percentage points in the earlier runs to -0.80 points under CPU load.
It's worth clarifying, though, that both differences were small relative
to the observed run-to-run variability: the baseline/patched standard
deviations were 4.52/4.59 percentage points earlier and 2.64/2.95
points under CPU load.

The same applies to Fault Latencies, whose baseline/patched SDs were
432/368 us earlier and 181/132 us under CPU load.

Compaction and reclaim results:

                              baseline avg  patched avg   change
  Compaction migrate scanned    3,983,598    4,563,788    +14.6%
  Kcompactd migrate scanned     1,242,728    1,944,022    +56.4%
  Compaction free scanned      17,689,565   20,461,694    +15.7%
  Kcompactd free scanned        2,608,710    4,426,810    +69.7%
  Compaction stalls                 1,476        1,514     +2.6%
  Compaction failures               1,265        1,319     +4.3%
  Direct pages scanned          1,339,044    1,344,907     +0.4%
  Kswapd pages scanned          2,011,323    2,141,355     +6.5%

End-to-end workload results:

                              baseline avg  patched avg   change
  Duration Elapsed                98.82 s      98.33 s      -0.50%
  Aggregate fio read bandwidth  0.2142 GiB/s  0.2152 GiB/s  +0.48%

Aggregate fio read bandwidth is the sum of the per-job read bandwidth
values in the fio output.

