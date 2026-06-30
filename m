Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C829FC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 23:34:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83BFA6B00A6; Tue, 30 Jun 2026 19:34:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C69A6B00A8; Tue, 30 Jun 2026 19:34:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 668346B00A9; Tue, 30 Jun 2026 19:34:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 33F916B00A6
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 19:34:24 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A90B58B59F
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 23:34:23 +0000 (UTC)
X-FDA: 84938185206.11.4BD6881
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012024.outbound.protection.outlook.com [40.93.195.24])
	by imf27.hostedemail.com (Postfix) with ESMTP id CE8E24000B
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 23:34:20 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=i9B6NsBm;
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.24 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782862461;
	b=Q/OrrBv8br6Uomj1OGwYfEnG9VxkqrI5iJjzpHhbtO6qJy5oHIRSxNQC3eucW1MBX1QnFi
	0VvfT5TDKjVKpmiQJECcSTFyZG3r+9nvu9S3623JSKxilAhzf6GqhuvCpjNg8xUAAUcGiL
	RFlspPH8twlxpd8hvCAOnXFwFrxQkww=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782862461;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UEuHSiG2aXT4nEjAPsOW+07nSjmUsCoWldtDdlTFMU0=;
	b=2MiozcHwWvGOCyOnywl0wqshj698MK/1lovvBVvnmdumu2Qxh3IFS+xI7n0NJzekpxvefA
	3LaNYIiUti/W2XQf7Fk22lMsrYOYQBUnIuknjmz3u+M1g1mlCUVBJXOZax9s2zxe3V9Pt8
	CWx7p6lnHXDcOHRWeQWwxljW8oXt5bk=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=i9B6NsBm;
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.24 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k9T+mLg0NY+GBJPs7Gqzlfw3ZJgxvJAdBgmQ4+3QtFQFsKJTqJaxVTR5F3VtQbCePw5ni0w10Db5uh9y5SVBlwI0JuetrcgvoYOkTRCvPibTNuE1wDsXchi/iAZSoHlDyVpwvev2BG7v5hW7Vz5VSA8OFq+J1B27/Oyr/Yk3K0tTfJmg+DJkj+UCy+SXVnNRdoUTYQMgKaJzV1d0u6gXMLsM3DiLQpRTOrjrEDcW77BZl1/UXiGZNO4iAUIhcYt0df1z9qCuv7GESV6PseRuD3+MUzFRUICI4FgBeZgv5puNKYIkYYWwx0d53sQtZHg9DD/er0PkrFgxgCJPW5786A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UEuHSiG2aXT4nEjAPsOW+07nSjmUsCoWldtDdlTFMU0=;
 b=FoLhWAgwDHL3AGNXZ3W36kUrrqKdcqluIPkvgP/Dyt+zT995haiQ3pSHymENq9OPjWZWPNS2ObX6iszn8mnjNwPMXhxOvoKp3dgjOuKnvQOOTWsgKOpdvl/cQWWhxlkGXyLhaVpUVyOxQ1t1wW08LYiSjyWvZJlDfEAgaNwpdGi4Z/3F1t5JmC9Fq0jPN6UvM4OjfaeL95hnhOOK5/c6ASnioUne93SfguhirDzqT2VICZQ+5S9gbWORM1N+apT2IE7P5127r5UFMk/u7+WJw2rSdrIDDsNABA/O2wqLp5NN9DZvjd5xqm3C67beZPuobVJjH2QpmrMXkpeuQUlqOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UEuHSiG2aXT4nEjAPsOW+07nSjmUsCoWldtDdlTFMU0=;
 b=i9B6NsBmABke7EuZTERzIss5tup/69DX40i81L6TarWGta2adlqxa2H52rHEnLXVltfqTRggDPDhzdZPYeNoIbYs1RujHktnhXZyqom57BI88BiwaNewitJFSKlLR004ECo7oiSBZeC5LCEiNVkXaNuFwYn70tiYdkw+elNzL6W40YvNkjwu4Yy0iMZODyE+3iVLNH0L5Ok+JFyAj01BylWc/SxAK0W9XIOhXd0nahsuZ4yyU7spy0s/EW0+hveVtGJNvGx25E17h90mmXc1k0c6v1N0aO9pkkRNL/P06SgtR/7f9ZzLSjZ3alaw78tDK9YTRbp1nzoRokWzv0bx0A==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by PH7PR12MB6666.namprd12.prod.outlook.com (2603:10b6:510:1a8::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.8; Tue, 30 Jun
 2026 23:34:14 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0181.008; Tue, 30 Jun 2026
 23:34:14 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 30 Jun 2026 19:34:11 -0400
Message-Id: <DJMRZRG70UYR.MOB3ASPBCBAB@nvidia.com>
Subject: Re: [RFC PATCH 0/8] Introducte Reserved THP
Cc: "Qi Zheng" <qi.zheng@linux.dev>, <akpm@linux-foundation.org>,
 <ljs@kernel.org>, <baolin.wang@linux.alibaba.com>, <liam@infradead.org>,
 <npache@redhat.com>, <ryan.roberts@arm.com>, <dev.jain@arm.com>,
 <lance.yang@linux.dev>, <muchun.song@linux.dev>, <osalvador@suse.de>,
 <chrisl@kernel.org>, <kasong@tencent.com>, <shikemeng@huaweicloud.com>,
 <nphamcs@gmail.com>, <baoquan.he@linux.dev>, <youngjun.park@lge.com>,
 <peterx@redhat.com>, <usama.arif@linux.dev>, <willy@infradead.org>,
 <vbabka@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
 <jackmanb@google.com>, <hannes@cmpxchg.org>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, "Qi Zheng" <zhengqi.arch@bytedance.com>
To: "Barry Song" <baohua@kernel.org>, "David Hildenbrand (Arm)"
 <david@kernel.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.21.0
References: <cover.1782538002.git.zhengqi.arch@bytedance.com>
 <e2bd33d5-4de5-49cd-970f-9e80eec91a3b@kernel.org>
 <CAGsJ_4zuxaqXQgrg_SiGY4gV4t3FQHdeM91dH4Y3-RknE7mg-g@mail.gmail.com>
In-Reply-To: <CAGsJ_4zuxaqXQgrg_SiGY4gV4t3FQHdeM91dH4Y3-RknE7mg-g@mail.gmail.com>
X-ClientProxiedBy: CH5P223CA0010.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:610:1f3::11) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|PH7PR12MB6666:EE_
X-MS-Office365-Filtering-Correlation-Id: 8466f1d1-24d5-4662-3f2f-08ded700183c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|376014|366016|23010399003|11063799006|56012099006|4143699003|18002099003|3023799007|22082099003;
X-Microsoft-Antispam-Message-Info:
	1w8Jyrm2z+kZ1RXvNzbUh1yNaRr/W+2vCHqCwg2Cj9TYBF0Qa8K+KAoQjuBhetO0vGZgWsGGz4llP48h/cOkxqfAC7G27DeX64SwL/5C2m2MS0TjjYrzmsf1EbLopSGyBPVnjMto8tV6bBeTFs7YdOf9Qd6E8f6AyrBkxJfq8xyE5MocTMuNckwjKiqYUcMm5MFQp7OClNLbs/Ni9ZEWQaZP+KZiiRbzEUq7XcUNvLLrlOgcnmox+/NUcBvZqx/ptTqszsiDqq+1iThDZigskQm7XHBU10zfSqJuUIvskQbETBRTnv4Mf7lahyc71uFf9NasUyqEnjbKPzY8MKeyc94fbN9zNW3GP1ljwkL17mBlYl26dQZARehNDZ+jwKO15AeKr6Pjpbr05jnUQSF/K9ky9f9h+l4dFwmeSidhUzeVyFHG7f3S/ssrwhutEuQrdtYvE5phHX2nMCPzBCwzlBtzUEZpJ89L3JfjMxaGqcsQeVs232K3rn7an/BtHVUgXcknUeqlPyR05hZBw6QUT5Ciu3+HAyfm140OSDM6+B0ZsO2Wgt5xHRBsrhcWMy1Vlwg8ok69iH3/5R79xQ46zeK4LkCyaaBqnHfgRsGKSLXqUmj31s/UIKTGWRY7PVh66FDbf6Ho4cO4zp7/6gqtlYXmI5+aYk4HKD9ubiiNMo4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(23010399003)(11063799006)(56012099006)(4143699003)(18002099003)(3023799007)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?V01DVG9yeXVuOXJjL2tGT0cwQnp4TUI5V2lTd2JGb1pwazEzYlhxT01VTlBu?=
 =?utf-8?B?N2NpS1VzdnVaK3JPSEtxNGNSSGp5eUhhNng3aDVjMVZqTU5ZWFUyaWM5NlFq?=
 =?utf-8?B?RUhrOGdQOEJMeGtRUGtsNHA5R20wKzlHS08wamFhTGVIREVYbnQwWEJ5c004?=
 =?utf-8?B?WlpXdUJMNmdEYXVHWmdkTjY0c0Z5M01oR0J0UExna2Q3MnhMTWdvSitERWNp?=
 =?utf-8?B?aWtUemUxbUVRNlJ1TnZ0anAvaEhGcWovb0NOdXVleVA4U2VrT1ZtQXVReWIw?=
 =?utf-8?B?cUs0R3ZGeURtNGxPWXA1QlhYaUFJcjBJYW9vZWhEWFh5SS9YamtmZUc0djNK?=
 =?utf-8?B?aWNDMkZQODlQZ09TUjh5cXYzSjduSWRPMDIzbHJIYUlJaDFUcmRTUTRUcWpN?=
 =?utf-8?B?S0dkajQ2QjA2MnNlSmJDL3FnYWtVVHNaa0ZJR2hhV1VRMGxSK3BFV2hndjNt?=
 =?utf-8?B?Y1FFS0ZOeStEK1R6Q3NhQm5wR0dVaHRZZ0xIZ3FtU202Q3IyWk5mUTBoZms2?=
 =?utf-8?B?bVhzR0k1aTRjcFZIKytGNjFQRGxCMTNCSE9IM3g0UklxVStZWEwrWmU5Y0lw?=
 =?utf-8?B?MFZYQ0RjNm9qRGJLSUNNUEYrRTZodVhUZCtobm12TUpXU00vY2YyT254SmtP?=
 =?utf-8?B?RUxlaVJ0ckh2S0xwcC9Gak5uQ2FScjlZME9OSE9jRlVkSytONlliQXQwUVRk?=
 =?utf-8?B?N2NKV0wrWUFBbWpWN1hOTk41UGZvdG1mNGNQTkQ5Rkd4VWxlOGxuRngwNUxO?=
 =?utf-8?B?Q3JlbW1oRngrZEhnWEkyTzlvc2R2dEZ6UGdQUTNId3QzQ2pndVhLMGdqQmVs?=
 =?utf-8?B?S1VmaS9uSzJEdzh0NVI0UUpXejZyUzlDSXVzajUza0QyWVNWZEpML2xzU3JJ?=
 =?utf-8?B?RGIvMyt6WkE5c1BCSXdpd3gvdExndHNpck1WNWoycTEzT2M5aTYrK20rNHVk?=
 =?utf-8?B?TW1mN2xXZzJFRU1BK2gwNE1Fdm5sdFlqTUQzeUpxa3dlWnoyV0Vkb3lSdm1r?=
 =?utf-8?B?M2JPYmQ3QlBheDRzOTlEekhuVGhQS3ViTktYUGNDbnJXRjdiWFR2RWVZdWpk?=
 =?utf-8?B?T3h3U1V2S25jU3dHd3R0RUxBblBaMWkyUjBhQTZWRW8vOXQ1UGRWcC9NK1Bo?=
 =?utf-8?B?enJXZVlSekYvK1A1WXJScWxIYytUMFRTRTJGUm5JazMrMm8ySkNhVHNjSHNI?=
 =?utf-8?B?Ui9uZy81bVFyR0JHajJLM0xEVGk5UGgrZnhIaDd5UkRnYW96bEdyMWxRK0pu?=
 =?utf-8?B?RVZSV2d0eUJocHpzMUJEMFp3QWc4OVlQTU11R0VnME51ZzdwdW1ieCtmMnlX?=
 =?utf-8?B?TmpjRUpyMi9FUmttZXBmdWt5cGI5Q0JhRVdpZExnYVRSRXZ0L0tqcWxQUUVv?=
 =?utf-8?B?Zkx6MXBUR3o2UmxXb0tqNFlTcnZ5S0pGRHpEYmFTWW1NV3VPV0t6dEhyaFJR?=
 =?utf-8?B?ZnNoZnlRYTA0U2V5Kytjd0twQ2tnQzZScjlyUFkyVGR6ZXYvUEZIRjVsamIz?=
 =?utf-8?B?OUMwRS9WUWZoZmpDejRQSGhmaDIveEdBVmFtc2YxeFptaElOc2pFVkZ6eVV0?=
 =?utf-8?B?UDNZYVNWQmlhTXN6MGlpcjZ6VzVsRGN1YkpXa0Q2WnRoSjBIeldUNTJKWkpL?=
 =?utf-8?B?VmNUYk9WbVErZE9YMG0xeTlROVhORncxMG1rUkhQVWlnNHJqc05MN0FEcXMz?=
 =?utf-8?B?c3ZFakdYcmdxb0dCeWxLL0dGMmV5ekZ6c3ZYWXdIbFJLaTlHb1dnVndsNWl0?=
 =?utf-8?B?ZEIrcHVhUkxHNnB5N2pKWGlzNXdJaFFWd3gweU9UZlVSZTZSRi9tMDZVY05a?=
 =?utf-8?B?cERmV2paZDdwdEo1RC9SOUNjS1NzUTNHcWxjU1ZLMDFaRlVWd09TMWFtNEQz?=
 =?utf-8?B?ZTRiYzFwVy81VGx2RHBRakY1dm5NUitSd0RBSUVlQXUvOVdXZFhNeTBzTUNs?=
 =?utf-8?B?WlBNZ0pYdXNFM2xja1lpcEpIT25oNmVyazhpMExwb3MvZHVDMVU1NC9EeVd0?=
 =?utf-8?B?UzBMMHgvNzEwY0REQm4zNDhYeTN3dVl3dlgwb1E0elhYd2lMN0hHaUM0K0hr?=
 =?utf-8?B?UnFwWVdEUVhham9MdWlqV2JlM0xXUC81aS9HYTNON3Q2MEMrQkw1T0tWVFQw?=
 =?utf-8?B?bnkrMFNoeGkvSW04bTZ6b3pCNC81YklYZ254NlN5TFZyUWFBa0pnckdBOUsr?=
 =?utf-8?B?SVpscTRhd0phczlaaEhnZkNyYS9YUDRCSmpUSmw1REtkM1lEK3BWV3RmcEhk?=
 =?utf-8?B?cXhrRTNiTlMrTjdSa1l0Nk1GdkMwK0xwRkVCU3dZRVJtR3YxaERkbllYRkhS?=
 =?utf-8?Q?PbimkclCthjrXoTiCr?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8466f1d1-24d5-4662-3f2f-08ded700183c
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2026 23:34:14.1433
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j9xtlRhr8QCGnL2QwpMghGsmjwUxhsaDX0L6ND3Gd2wjH0iE96kEY3D1VGdqyLEJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6666
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: CE8E24000B
X-Rspam-User: 
X-Stat-Signature: kd3sxjzuamqgpy54n5aoxx4m7pc8rz75
X-HE-Tag: 1782862460-198873
X-HE-Meta: U2FsdGVkX19XA+XVDocv/WFynROCHhe5Hu91pMpyhLg1QetR1rhQFmdOcTMzbK410eLvw2VQNrfSHi9jrX+AHM1uKMHkIwguchgjrhUGCwl5mMcVBNvfyh6pOVCz5mSUEaOu152i9iZPicxhTM91GVZXGeNpQhAzJCcDZGAIBNl7YbDb3PdPe5gSD8pSjDFWOXrIj9m0UayH6UFZoiwDe/yYaAb6a8NSKDOV8LIZRffGBt0uQHAjCcD/UsMy+gd69qHUDq6Xh8sVo7fOvLZT8hgPTzmVD+NMpbumvvW8I9ghkdNN/yefddjtrql+LYmQ+lzHuR4r7KS44RXubGnXJtWR1iNc2688mWPiz/2FFMTCa50OlyJ+h23l5kK4lTYqsS/EcRWavgtRWI/zpGT0pcr7x1nqNeu/GM66ybWbj+nDIXOMd+BwhLAOw/rdr2Gw/Q6oAKz2FIXhHCWwNJ0x/Gh5dGQPr2+AwPtblC1/QRv5wfVsjhcl1pbc1HDIO2OLnbZrcU8q+6z/pJTtHk+VyGXJAYk9eTQKNLLuF16XcGu/2HdJcx6ESJKnRGmbdooxgHMo565oTJygLZ8I6fUeksgDCBmsitrDL9XTTxGojvt4KQIJVmDt7DaRSr+NOaRoz/CdAn3/5b1BICCJ6qVE2zdxhP6fHK0oCyfumWZhOwWixUSI9n/fRY9aB4vafnB9WUn7ZuWJBitxThXx1Y1nwBfqbVeel15+nxX2QDpXYyPuJ9gNKAMllCIV76J2xGTzRKtuiIicshdjTocKG/efBkiYHC3fT1wa8XJe+V9/4eTGl3Fi7AhLim5zkenKGdk0pP6V+t3yHaU2H/DXawezweF6ekI31C+zzelwfexum9UEoUfDR6j6f/u0oy7/57a5TDLyWaMy0MehrmCjsNhKKsw81tG5glDDJKEmG6RZSUixtoBlLuYUidtjozZdnNfDGyv69wibYILhxI5ZVvI
 liP7qzWV
 tDPuZ/4ceKdjUuTlPdhnpT1s8L97OkMTDoXOhnK0j0PQbj4HU7WGhZajphmt8wUVRZo3tEJEMFbOYif7oazZKkc8y5F6kfGmun7YkEklNAkFu9l2P6+cSPLf4I1JkhYF8R8VwP06nlUBwR/3seiIVALwcL17GkAxBdsXyvKtFpOzAYCDq4a/ZFDS8fIcYyEfb4KMzjJ7q+JEJ1PQYMhM+G0Pyi6b46k9NWUGXlzZsGHM4iEGkTqF5K1LfG3sps/wPC/hwwcaTcD+dWa89gXxgh0c/DOgXfWh7RhqP8rcYcAqtxRDcStThayFfaDgjS5wAZUuMpsAq96Q9mkujZwnNN2VeHDUmWvFGamDaa45W0ok1wVpD3MLY8IJYqurldtNnbAvsPn2Mrelmgx3iPYQ3UK3qdRsPmMcrkvCrf5ilc9C88Dc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Jun 30, 2026 at 6:59 PM EDT, Barry Song wrote:
> On Mon, Jun 29, 2026 at 8:20=E2=80=AFPM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
> [...]
>> >
>> > 2. Implementation
>> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> >
>> > In 2024, Yu Zhao proposed a similar idea:
>> >
>> > Link: https://lore.kernel.org/all/20240229183436.4110845-2-yuzhao@goog=
le.com/
>> >
>> > The idea was to introduce two virt zones: ZONE_NOSPLIT and ZONE_NOMERG=
E to
>> > guarantee the allocation success rate of THP, achieving an effect simi=
lar to
>> > reservation. However, it seems there was no further progress, perhaps =
because of
>> > reluctance to introduce more virt zones like ZONE_MOVABLE.
>> >
>> > This RFC wants to discuss another implementation:
>> >
>> > 1. Introduce a new migratetype: MIGRATE_RESERVED_THP.
>> > 2. Introduce two new hugetlb-like kernel boot parameters: `thp_reserve=
d_size`
>> >    and `thp_reserved_nr`. When set, the required memory is marked as
>> >    MIGRATE_RESERVED_THP and put back into the buddy allocator.
>>
>> I'm all for some mechanism to make runtime allocation of large chunks of=
 memory
>> easier, by adding a pool from where multiple consumers (THP, guest_memfd=
,
>> hugetlb, whatever) can allocate memory.
>>
>> Call me very skeptical of getting the page allocator involved like this.=
 (I hate it)
>
> One thing we've been thinking about for a while is whether we can
> introduce something at the pageblock level to let memory "remember"
> which allocation order is preferred within that pageblock.
>
> For example, if we ever allocate an order-0 page from pageblock 100,
> that pageblock would later prefer order-0 allocations. Similarly, if
> we allocate a large folio from pageblock 200, we would avoid using
> pageblock 200 for order-0 allocations as long as there is still
> memory available in pageblock 100 for order-0.
>
> Since order-0 allocations are often the main source of fragmentation,
> if we already have both pagecache and anonymous large folios, we may
> care more about containing or quarantining order-0 allocations in
> certain areas, rather than trying to maintain a large-folio pool or
> similar strategy.

Aren't unmovable pages causing fragmentation? For movable pages,
regardless of their orders, they can always be migrated if no additional
pin is present.

If we use per-order pageblocks, how to use pageblocks with rarely used
orders? Allowing lower order to fallback to higher order pageblocks?

>
> Chris=E2=80=99s de-fragmentation of swap slots[1] seems to be a big succe=
ss
> based on my observations, where he provides a similar memory-order
> preference for swap clusters. There is no reservation mechanism, no
> sysfs knob, and no need to split swap into two areas=E2=80=94everything
> just works automatically.
>
> I wonder if you would be interested in something similar at the
> pageblock level. If so, I=E2=80=99d be happy to work on a prototype in
> August. I=E2=80=99m completely booked in July.
>
> [1] https://lore.kernel.org/all/20240730-swap-allocator-v5-0-cb9c148b9297=
@kernel.org/
>

I feel that swap and page allocation have a fundamental distintion,
where swap slots are not movable, but pages can. Memory compaction can
move pages around to make space for high order allocations, but does
swap support something similar? How will page mobility work in this swap
slot defragmentation world?

In addition, when swap space is full, or only order-0 swap slots are
available but higher order folios want to be swapped out, folio swap
might simply stop (except splitting folios to fill the order-0 slots).
But for page allocation, some pages can be reclaimed/swapped to make
space and this adds complexity.

--=20
Best Regards,
Yan, Zi


