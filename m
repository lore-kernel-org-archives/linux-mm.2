Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B96A606A319
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 06:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=TlHPY42K
Received: by kanga.kvack.org (Postfix)
	id 65F586B0199; Wed, 21 Oct 2026 02:57:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6107D6B0647; Wed, 21 Oct 2026 02:57:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D8216B0648; Wed, 21 Oct 2026 02:57:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 118496B0199
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:57:11 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 69C9616046A
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 06:57:10 +0000 (UTC)
X-FDA: 85345726620.18.A05A692
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013071.outbound.protection.outlook.com [40.93.196.71])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6B20040002
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 06:57:07 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=TlHPY42K;
	spf=pass (imf04.hostedemail.com: domain of balbirs@nvidia.com designates 40.93.196.71 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792565827;
	b=jSUA+FV7BgqTjTiqKdg4pvOs2At7uVjyv/29+Y5AToRhBG70zJvOnfRAEucMDz60qVI4uf
	ztfFtP/lHnzwneOcZvGYMdcJ0xUtyGXaapQQfkZsRKu9ilDCwk7PsVrJ/dxvXu6FkIDw7f
	jObX6kpTLlxn3qyoS54bZQqU8/u49qQ=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=TlHPY42K;
	spf=pass (imf04.hostedemail.com: domain of balbirs@nvidia.com designates 40.93.196.71 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792565827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W4G75slcCaTGHQ/UyeziB6AkH8vMyBGRPdmILosqiis=;
	b=4auq4qQ1w0+Mh/fPYRgxcRcaAEBfAAKXkgV8ZLQGnnIoIPZyhi73jD/iaO1ezdAbXc1Lax
	Ya1L/+LhSSVwAmZePwnc6pGre/7yCFREbyOt/SOk351/I1oMSfnD8GiTUE0kkBss7d9Lyu
	4QPK1vi7Hhl2FT1gufBh83c133w2i7s=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Yz7zWVVvUTAIM1w+G4SVGR+MgiqD/XXV9g05vgQlJyOMBG65FLxspvaDkzc7hlxpFXgESBVhdg7YdyggBlqn0KWZV/ukemog6/PdxYgcyIY+yEqNXVWflmcvdJ+iCE/V27tdvAVHawfrBMu/ndaBBPfIVfCmzHDPnv5BPZDnsM+Jw8av3xHp1N2L4iEIpTUV4q7MZ5OErm5gAzQo1v5MG3yuIKWgHljWlNpRhev7f3DmsPkq7p+/4UqsDlx+YE4RZuCPIvIztVVkNjQCp8BnK5anG/VC3SEg+HAVfE3zs8tG6bUOwbIQPn9qDo18OvYbV2f95n2fx+76gBE8icakXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W4G75slcCaTGHQ/UyeziB6AkH8vMyBGRPdmILosqiis=;
 b=Fz7gzV//CFPFXGDbta8sx+cYKG1EFjEuQyUE6l87aLSjfIVZ9bmbf+nAGeq9WIv2hXLE0kI46uTJlmGr12jFSQyGOVLjlXhLrkMhhG8qAG4evTAR/Zk616++28D0KvSRCWTqb/Fw2sK++hkPLE8ONaJq0wdFLRvdi/QMgIPSLAE5kwkJVSK4UwRj/vBBP3gy4WhpWTK++8Fd7U8EKI3Ok/pBikep6QLgRnbM2K/qQ+rIKPFIl27RzU1XozSOA7eNlK9Zq23SrSpXGGfBy2gHKQgF1yNCFsE9AEabdE+Y1C5k9+5/wtmDN1cDWb5HHmxoZCwpPchAU09MrOdvRCc+Gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W4G75slcCaTGHQ/UyeziB6AkH8vMyBGRPdmILosqiis=;
 b=TlHPY42K9Tv+vMhvJLCa00zTWw85+tJau7Dk8XVqpX/c08HCtQAn0VUANiB50iz2DlWlrhz/jRnzYlu4luA8/Unb/0UV/r8ZBhgMkHAgvEi40tL0MfLo68iDT/fTtCZ8q9a4hUKNzP7h1P7d3ofjmSYOKwIJhQ6NSBaYf4T95z5PqYCJfrPUQO+WUjcqYg7z8x6zog5FwcHB7F/jXg4WgAsHNlLAc5vtAzsIajif1uXu1ksBmot1nXlu+ZgrQr+cYb0yPne56qmuGduMyVRIg6GTeeOJcv60TdrYY6XuW3LMsWIuu6ZK86+DUrWeJnjYy0xpfYzjzUqSfFJdAZRDCQ==
Received: from CH3PR12MB9730.namprd12.prod.outlook.com (2603:10b6:610:253::9)
 by LV1PR12MB392019.namprd12.prod.outlook.com (2603:10b6:408:514::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Wed, 21 Oct
 2026 06:57:03 +0000
Received: from CH3PR12MB9730.namprd12.prod.outlook.com
 ([fe80::843d:c1f0:b2ed:4128]) by CH3PR12MB9730.namprd12.prod.outlook.com
 ([fe80::843d:c1f0:b2ed:4128%4]) with mapi id 15.21.0522.016; Wed, 21 Oct 2026
 06:57:03 +0000
Message-ID: <cc42cbd1-2030-4fbb-94f6-5e92cba2431e@nvidia.com>
Date: Wed, 21 Oct 2026 17:56:53 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 05/12] mm/hmm: migrate collection in HMM pagewalk -
 pte level
To: mpenttil@redhat.com, linux-mm@kvack.org
Cc: dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org,
 linux-kernel@vger.kernel.org, David Hildenbrand <david@kernel.org>,
 Jason Gunthorpe <jgg@nvidia.com>, Leon Romanovsky <leonro@nvidia.com>,
 Alistair Popple <apopple@nvidia.com>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>
References: <20261021060506.2377545-1-mpenttil@redhat.com>
 <20261021060506.2377545-6-mpenttil@redhat.com>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <20261021060506.2377545-6-mpenttil@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MEWPR01CA0192.ausprd01.prod.outlook.com
 (2603:10c6:220:1e9::17) To CH3PR12MB9730.namprd12.prod.outlook.com
 (2603:10b6:610:253::9)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9730:EE_|LV1PR12MB392019:EE_
X-MS-Office365-Filtering-Correlation-Id: 04faa0a8-74f6-42d7-40c0-08df2f4082e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|7416014|366016|10067099003|22082099003|18002099003|4143699003|11063799006|261009223027099003|261009221227099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	E9mf07tjZM1Lj2BYPGcDFSup9DoRTOiVoPLurhvPi6UKGsGYbGz4BY6R6vhZxBXTlxA58u/pKu69HY3XNUTAT5MOE42u8oxU6TIcmjMeQ+K/wOdYwj9m8rLguYiNGc/Dn6rTbHs4FgQCf6b1PJDlhMVKGD8W51nttVJm1+57J1S5FSOUGUx0qgo2gqL/KaNuEgmUect/fcEnX8zTXnuP7SxyD8qHubIGGZsyOCnhiZNsLC7GkLyRBHmSvQzib+H/rRuMv151ZKWYS1zKdvFQCya2jV8u9BPKwW44kPom9xrTfeQM17rM3rg1YAW8N8aKAnphXbUfx40Ck52H8n0jobRrEj7Iy6r0T+Uy2jlOoN/dZKCZT/YTulmXMLrJKz15g9em88RqIawdBZ4HApSP7ElQRqHqCagB0cOpLxa7ILjRtRpcsBc/0JxiEKuOgvkBfGh8XoLX+AaOviVOjRHPhX3180ZTuceZ/YD/0o2RHtFBJY/3gOXHRsL+byAR/2wc1eb88M+EK6Qcesipt9uLafMpfHAtGzDMd7GD5+jV3hWb/tXfSrzt1hHiJjGgXu0gqETUqf/+5fFIJAwUsmLu11bcBA1zMMVpknvmCq2J2fsKx3gT775BGwZmvATqmCMvMG62dLKxssG/qehCqM36VmajkEOr6BnvYH/vyf5yl7g=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9730.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(7416014)(366016)(10067099003)(22082099003)(18002099003)(4143699003)(11063799006)(261009223027099003)(261009221227099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M2JjcnNxQVo5OVROK1NkQjZHM0Q0U2tDY3Btd2UwZmV0TUFibWl3MndZSlhQ?=
 =?utf-8?B?NDRVc0pQNnl1Y1M3bm95WDIwbkpvS2VucGM0UzVadVRsWDZUMVFpbzZvaTdT?=
 =?utf-8?B?VXE3Y1J1NlpnMnpqbGM1Z2dFTExRZTY0U0M4cFFnZGs4dnl2TXlCUmM2aWNV?=
 =?utf-8?B?WGxtbzBNVTIrWW1sMWh6OEVtSXNLRGltcmQxb1RDWUhJVjBBVlpUQUFOcGJr?=
 =?utf-8?B?bkcwS2hsd05TNGgvais2OFZ2Z0dLcEtjNk5Ld3VrWmdtZWxJWlFGdDNVMU5p?=
 =?utf-8?B?R2ErN1NieDkxVFZOOXdDSTRabzdTQkNpaWp0S0lUNy9KTERrTDh4WE9yQmh1?=
 =?utf-8?B?blEzZU9nUnhFeUxucVFsV3FrMmhHcHpFREhTWENoc0RHWEx0QnBwMjZUeUIz?=
 =?utf-8?B?TDJDNFpGWlRiWTVZK1F2Wjh3enVHaHdvRFpLMXRsOWQwaU5YcmhBeW1xVGha?=
 =?utf-8?B?Rm9wMlBKckY3WFlBT2QwOXh6Yko2TnlYUk9Pem50UFBsN0V0dFNwVzRjMXBw?=
 =?utf-8?B?d1NOcWRHRmpaNSt4RlovelpLZG5UaHBWekxsK1JVY1ZKTkFLNHBBTWxwT01v?=
 =?utf-8?B?NGMvYXM4NmJVQ0lrTUNOTmF0Qmk0ckdlbzNqcDdXK29LSlI1czB0eFpVOERZ?=
 =?utf-8?B?MkRnTG9LbjFIZVlpdUJ0YnpXM0lrSXk2OVB2SmFvMVUxQmNoeWlIeDBkSGpk?=
 =?utf-8?B?TlVGV0Rvd1hHTkhSTFFWZFN1SjI2Q3I3WkFEVWU3R3MyMy9xbFlRendUbnNn?=
 =?utf-8?B?dktMTDNaMXpxVWdmVjd3SFdNZkhXT0lSRS94SVNtdzZaanVDcXNWbVJ2TU9o?=
 =?utf-8?B?UjV4K2tDSXNYOEFLWUtZVy9salI4bnpELzFYZmFpbXdDODRkMEtIdjJBK1ZI?=
 =?utf-8?B?NkZROVNKbmRlNHB6Vmt3K3ZrVS9qVm9NaWpabzZzYkJJU0xSOTNSZXVlTFNv?=
 =?utf-8?B?NUVyZjVWRldNTkcwTVRRSlJQcXRFOWN4dDQvNnFMay9OMXB5bnFJcGlOUDZE?=
 =?utf-8?B?WFROamhHWnc3UXJtNEw5L1pQVU5VUXd4L28waTl1cUM2NG8rczZsUmRwR2t4?=
 =?utf-8?B?U0oyeGxGUm5CbThtUngvYVA3b2lVR0N3bXowR1p5RkZFTFd4S0xjVHFjSFB2?=
 =?utf-8?B?L3ZVYXNiNk5hRCtvZ1pLcjJ3NXZtOEppWjRzc2JueXNMQ0NqNVlXeGZheE41?=
 =?utf-8?B?T1pDRS9zU0YweHNTUUNab3FLTEtubUVnUGdUY0ZCL3ZtcG00Vlh0aEg2M08w?=
 =?utf-8?B?S2Ntc3dVM2dpZDZna3Z2NU5kekJqcEM3ajJkcm5nSlllT0JhNEVpeUtqQzEr?=
 =?utf-8?B?eHluaUhkblJxV0JOcVBvV0Qwb2dsV0VqN0xBdC9Hd3dSSWhwNFB2NExtcktH?=
 =?utf-8?B?dWFIVVR5NGx1QW1vYytOQUMyY2hDN3hPc2F1cWJKaWFJeTBCeXcxV0F0ald3?=
 =?utf-8?B?U0F3Ujh2REdhK1NGV0d5VU5DR0NhZ3V4SDErT2JkaFU1RGtJSEZONzJqUHdF?=
 =?utf-8?B?Sm9RUisxbzg2clAxUXZycTlZcDVka3Npd3VNdjk4V3FuNUZrMUxUcUFvclJm?=
 =?utf-8?B?OFRGeGY3RmU3R3JoeDdXOEJJa3JlbGJBOHlYeE1CZGhFUkRLTDVocmtTNHlC?=
 =?utf-8?B?QWFBUllYeHVUVk5DRnpwSlJ5ZWJmV1dIT083bDB1Nm9OeWlNNE9RTERnaWgv?=
 =?utf-8?B?NzErSXB4TkxncjhuUWNidjF1ZHpJK3MycHZ1TnNSK2p0UStxVzUvSnBHQXdx?=
 =?utf-8?B?R1lHM1pVUVNIKzZZWC9XRXRKQ29RYnc4ekF6eWN4L254a3FwSHRLRGdmL0JM?=
 =?utf-8?B?ckJqbWVDYUdqZ3k3K2hhblo3OEhCc3U1cE1Tc2ZwYU5XQTFmUkNScFdyZ2ox?=
 =?utf-8?B?WXYzVk1VNHYvZ0l6L3hheDlCM2luL0JJOExiMFJIRDJhcm1NeHpVNWM3c2ZP?=
 =?utf-8?B?K2VJM0tLZGxta3FqaGdpT05RaHVVWXJNWTdPVjRaNXNPQnFJYkltYlBzQis1?=
 =?utf-8?B?WGFNb2dWdWxPTHlSZ000MWEybHhrdFRUYi85Z2hqNzQ4Q0lRMDdKWmdjVWU4?=
 =?utf-8?B?YUNzWERIZzAvTnMwOEYwRDhOWkpkK2pzQkp2elZWQVBPejNYSXBLZ3E5YUF2?=
 =?utf-8?B?eW9UbU5SMG84STVaTmZkZDBObnB4eEpoRXA0Rkp2VHBhMlc1QVB3VFFzWk15?=
 =?utf-8?B?WVV4VE9DQWsrbzJseWx3QWE2bkFKd1dLNGFLMFAwaHlqV3NQSHdtbG1nZ0RR?=
 =?utf-8?B?a29MMTAyVGQ2RVJ3SnFYMjdUS2Z2SWxub3N0K05YSGZVaFl6REtpZXVGRUM3?=
 =?utf-8?B?TDNYbjI3YzdjaXEwNGdmdmdqa1RTWU1KUU41M1RmME1PaFV5VW9xdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04faa0a8-74f6-42d7-40c0-08df2f4082e3
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9730.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2026 06:57:03.1194
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UGI+eU5PdJ4Y9LeyW9QnDJlhvgEDdq/FyM9Qb+ZXsIc0BCYKT5h5yqVPm9kSPzD50AH+1X/0ScngVEF6d7t5MA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV1PR12MB392019
X-Stat-Signature: wbqheqg1kpkb3h6tny3yrp7woitu1kbn
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6B20040002
X-Rspam-User: 
X-HE-Tag: 1792565827-704193
X-HE-Meta: U2FsdGVkX18rR0gbbrAzZzpk2R+gM5EktKQbv9xRAQMblYJfSxOgfWFBVaFaOMg9H94xcf0VSMymQH0RN5BpZOXEYONabOvIEPBb2NNBBDo1+ZNSUlKwm22aSgRHWYU7gaXDufmwkYxAOKL4XLVpcwyNfIZo9RcKv1nO1t2p7ZaYr9Gmfw3ezIEBFiSV3Ff2xtC3PjZyMxm1YLtBo4J8uUN04Gucpz33Rx1fmd4OBceyfddjFu4IJm6krgMZOuwyoTrTpXYNre4WurIKipH4k54D2OYYy/DxCPCO2NP6pXX/0R9b+JEFPhPbqHH2gCkRuHo/ZWXbMCYLJ7H7SHlUSe2ZGYN5m3mBLUi46EBzcywFHWrNgRHNVR7oHweSWlL+0mSmXK9VsBx7wfX/Ic9Az65coM+lMQB25h9svZmH8mMmvTvSvttOhkFUwgX1moEwjDjNQElh8uDL5p9+OQLcCN5waVHtLY7sPqCs5kpMkUpmdN27W+zJNXp2b5c/fCljvGQT25O1iAEcgz7kAW31ZiLyEiqyAwTT109FXYVdm62jsgqNpE7VJtbTo/FDfeRBXywnO33Gc81A6ZlHCp/x7V5dhi0wqQHcrNe2Q98lxjpF4Y7Dxu29pujxiv4fhh5DNzczfDSAg20bC3K+RBhKhQwf/YdrCuIVIOivnNGeuXGVypIvXupWvtpFKt41c1lWPFqZ1zldMEGJRjknFkW27/Ci96YHQUM86nYxiBUgqoSQ/5V9gZ3BJTRfNJe/Z1fd0Ovd+XCwGRpmf5H9c+XyZdL1JzMDJ158TaxeZSLQwi84LMrwQFYgEFpA2ugzeOEiX0WFHDZr8qwiDwwQlQsuHPVFMs4NkpAKyspVbyvcssCm+zE5QeOvxR6BolgcFzHEPweYpRFj9Z3fGeII+r0dwqaR+5oo5vnri7kdBSI+r5xDaK+owu5KfjNZB2RBstpC1Q79W8Sat9rdAZfri1G
 yB94VrAy
 YJ7LCU2OsCRI1m2OCRdWW7KMUGe5zM6i//GE1gO+nAI0rhDplXRmRaqQWq/3NcwymEw0SZhB8h3FykfxXI2qnOAODghTq5XNqU7BusFdDpYdbm1bq3/G1NRwCC4NaV/BZCNLI10gM7dtkDtPgpTqeF1CtlFhrb6DQPZf6OZnPKojw8sOBHII2A+hdJN6It18mfmjBXhHVmybZ2Y/dzLfHLUgFAHQDZzjaB5fN5ORKIqtvmCB/O+ltx4TExJazutxelAli9FCM7qSxpjGIyjAfB8KdDzTeestIaDojjQI89vtMjx2cy6KDYsq77omId2gbRBEl8UbzhE43M067QO7XJSuxvQNk3FhLr3nr+bkA8Sgqj9FCoS8NvhRrs+xsFfYb18OANGWWbBejdeyejfPHwsKMT6FKhhpKDmS2LtJVprv0xzyokUwG6+nPKwCrA3KXRyuDszmEZm7eSg/xFg4j21r2iaG0ewgdMij+KBrdwUNAOYMcXwymadc3g8mqNtmSvGZtFtsxKPI8Z4rf+uOnHbWyX9uM05uxcfmCYj+pqmR7fWL2T85keeRdgQHbkmLMOfvJ5ytJ9y+DojvIGUmT0HcADlJxjQ72BKEq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/21/26 5:04 PM, mpenttil@redhat.com wrote:
> From: Mika Penttilä <mpenttil@redhat.com>
> 
> Implement the needed hmm_vma_handle_migrate_prepare() function
> which is mostly carried over from migrate_device.c's
> migrate_vma_collect_pmd() function.
> 
> Also implement the migrate_vma_split_folio(), for splitting
> pte mapped large folios. It is also mostly from migrate_device.c,
> with care taken to reference folio before relasing page table
> lock.

Typo - releasing

> 
> With HMM pagewalk based migration, the idea is that
> hmm_vma_handle_*() are responsible for faulting,
> and the pfn collecting part. hmm_vma_handle_migrate_prepare*()
> do the migration decisions (with HMM_PFN_MIGRATE), possibly split
> folios, and insert migration ptes/pmds.
> 
> HMM pagewalk based migration is enabled in later commit, for now
> now hmm_select_migrate() returns 0.
> 

now now -> now

> Cc: David Hildenbrand <david@kernel.org>
> Cc: Jason Gunthorpe <jgg@nvidia.com>
> Cc: Leon Romanovsky <leonro@nvidia.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Cc: Balbir Singh <balbirs@nvidia.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Matthew Brost <matthew.brost@intel.com>
> Suggested-by: Alistair Popple <apopple@nvidia.com>
> Signed-off-by: Mika Penttilä <mpenttil@redhat.com>
> ---
>  mm/hmm.c | 263 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 262 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/hmm.c b/mm/hmm.c
> index 119e70dbca56..0ce947d0e572 100644
> --- a/mm/hmm.c
> +++ b/mm/hmm.c
> @@ -491,6 +491,63 @@ static int hmm_vma_handle_absent_pmd(struct mm_walk *walk, unsigned long start,
>  #endif  /* CONFIG_ARCH_HAS_PMD_SOFTLEAVES */
>  
>  #ifdef CONFIG_DEVICE_MIGRATION
> +/**
> + * migrate_vma_split_folio() - Helper function to split a THP folio
> + * @folio: the folio to split
> + * @fault_page: struct page associated with the fault if any
> + * @hmm_vma_walk: walk in progress
> + * @ptep: pte_t * for unmap and unlock ptl
> + *
> + * Returns 0 on success

and drops the pte_lock associated with the pte

> + */
> +static int migrate_vma_split_folio(struct folio *folio,
> +				   struct page *fault_page,
> +				   struct hmm_vma_walk *hmm_vma_walk,
> +				   pte_t *ptep)
> +{
> +	int ret;
> +	struct folio *fault_folio = fault_page ? page_folio(fault_page) : NULL;
> +	struct folio *new_fault_folio = NULL;
> +
> +	if (folio != fault_folio)
> +		folio_get(folio);
> +
> +	pte_unmap_unlock(ptep, hmm_vma_walk->ptl);
> +	hmm_vma_walk->ptelocked = false;
> +
> +	if (folio != fault_folio)
> +		folio_lock(folio);
> +

Could you add a comment on why the get and lock is split into separate steps
with the pte lock dropped in between

> +	ret = split_folio(folio);
> +	if (ret) {
> +		if (folio != fault_folio) {
> +			folio_unlock(folio);
> +			folio_put(folio);
> +		}
> +		return ret;
> +	}
> +
> +	new_fault_folio = fault_page ? page_folio(fault_page) : NULL;
> +
> +	/*
> +	 * Ensure the lock is held on the correct
> +	 * folio after the split
> +	 */
> +	if (!new_fault_folio) {
> +		folio_unlock(folio);
> +		folio_put(folio);
> +	} else if (folio != new_fault_folio) {
> +		if (new_fault_folio != fault_folio) {
> +			folio_get(new_fault_folio);
> +			folio_lock(new_fault_folio);
> +		}
> +		folio_unlock(folio);
> +		folio_put(folio);
> +	}
> +
> +	return 0;
> +}
> +
>  static int hmm_vma_handle_migrate_prepare_pmd(const struct mm_walk *walk,
>  					      pmd_t *pmdp,
>  					      unsigned long start,
> @@ -501,6 +558,11 @@ static int hmm_vma_handle_migrate_prepare_pmd(const struct mm_walk *walk,
>  	return 0;
>  }
>  
> +/*
> + * Install migration entries if migration requested, either from fault
> + * or migrate paths.
> + *
> + */
>  static int hmm_vma_handle_migrate_prepare(const struct mm_walk *walk,
>  					  pmd_t *pmdp,
>  					  pte_t *ptep,
> @@ -508,8 +570,207 @@ static int hmm_vma_handle_migrate_prepare(const struct mm_walk *walk,
>  					  unsigned long *hmm_pfn,
>  					  bool *unmapped)
>  {
> -	// TODO: implement migration entry insertion
> +	struct hmm_vma_walk *hmm_vma_walk = walk->private;
> +	struct hmm_range *range = hmm_vma_walk->range;
> +	struct migrate_vma *migrate = range->migrate;
> +	struct mm_struct *mm = walk->vma->vm_mm;
> +	struct folio *fault_folio = NULL;
> +	enum migrate_vma_info minfo;
> +	struct dev_pagemap *pgmap;
> +	bool anon_exclusive;
> +	struct folio *folio;
> +	unsigned long pfn;
> +	struct page *page;
> +	softleaf_t entry;
> +	pte_t pte, swp_pte;
> +	bool writable = false;
> +
> +	// Do we want to migrate at all?
> +	minfo = hmm_select_migrate(range);
> +	if (!minfo)
> +		return 0;
> +
> +	WARN_ON_ONCE(!migrate);
> +	HMM_ASSERT_PTE_LOCKED(hmm_vma_walk, true);
> +
> +	fault_folio = migrate->fault_page ?
> +		page_folio(migrate->fault_page) : NULL;
> +
> +	pte = ptep_get(ptep);
> +
> +	if (pte_none(pte)) {
> +		if (vma_is_anonymous(walk->vma)) {
> +			*hmm_pfn &= HMM_PFN_INOUT_FLAGS;
> +			*hmm_pfn |= HMM_PFN_MIGRATE;
> +			goto out;
> +		}
> +	}
> +
> +	if (!(hmm_pfn[0] & HMM_PFN_VALID))
> +		goto out;
> +

We use *hmm_pfn and then hmm_pfn[0], could we be consistent. Based on this I
assuming that there is just one entry in hmm_pfn?

> +	if (!pte_present(pte)) {
> +		/*
> +		 * Only care about unaddressable device page special
> +		 * page table entry. Other special swap entries are not
> +		 * migratable, and we ignore regular swapped page.
> +		 */
> +		entry = softleaf_from_pte(pte);
> +		if (!softleaf_is_device_private(entry))
> +			goto out;
> +
> +		if (!(minfo & MIGRATE_VMA_SELECT_DEVICE_PRIVATE))
> +			goto out;
> +
> +		page = softleaf_to_page(entry);
> +		folio = page_folio(page);
> +		if (folio->pgmap->owner != migrate->pgmap_owner)
> +			goto out;
> +
> +		if (folio_test_large(folio)) {
> +			int ret;
> +
> +			ret = migrate_vma_split_folio(folio,
> +						      migrate->fault_page,
> +						      hmm_vma_walk,
> +						      ptep);
> +			if (ret)
> +				goto out_error;
> +			return -EAGAIN;
> +		}
> +
> +		pfn = page_to_pfn(page);
> +		if (softleaf_is_device_private_write(entry))
> +			writable = true;
> +	} else {
> +		pfn = pte_pfn(pte);
> +		if (is_zero_pfn(pfn) &&
> +		    (minfo & MIGRATE_VMA_SELECT_SYSTEM)) {
> +			*hmm_pfn = HMM_PFN_MIGRATE;
> +			goto out;
> +		}
> +		page = vm_normal_page(walk->vma, addr, pte);
> +		if (page && !is_zone_device_page(page) &&
> +		    !(minfo & MIGRATE_VMA_SELECT_SYSTEM)) {
> +			goto out;
> +		} else if (page && is_device_coherent_page(page)) {
> +			pgmap = page_pgmap(page);
> +
> +			if (!(minfo &
> +			      MIGRATE_VMA_SELECT_DEVICE_COHERENT) ||
> +			    pgmap->owner != migrate->pgmap_owner)
> +				goto out;
> +		}
> +
> +		folio = page ? page_folio(page) : NULL;
> +		if (folio && folio_test_large(folio)) {
> +			int ret;
> +
> +			ret = migrate_vma_split_folio(folio,
> +						      migrate->fault_page,
> +						      hmm_vma_walk,
> +						      ptep);
> +			if (ret)
> +				goto out_error;
> +			return -EAGAIN;
> +		}
> +
> +		writable = pte_write(pte);
> +	}
> +
> +	if (!page || !page->mapping)
> +		goto out;
> +
> +	/*
> +	 * By getting a reference on the folio we pin it and that blocks
> +	 * any kind of migration. Side effect is that it "freezes" the
> +	 * pte.
> +	 *
> +	 * We drop this reference after isolating the folio from the lru
> +	 * for non device folio (device folio are not on the lru and thus
> +	 * can't be dropped from it).
> +	 */
> +	folio = page_folio(page);
> +	folio_get(folio);
> +
> +	/*
> +	 * We rely on folio_trylock() to avoid deadlock between
> +	 * concurrent migrations where each is waiting on the others
> +	 * folio lock. If we can't immediately lock the folio we fail this
> +	 * migration as it is only best effort anyway.
> +	 *
> +	 * If we can lock the folio it's safe to set up a migration entry
> +	 * now. In the common case where the folio is mapped once in a
> +	 * single process setting up the migration entry now is an
> +	 * optimisation to avoid walking the rmap later with
> +	 * try_to_migrate().
> +	 */
> +
> +	if (fault_folio == folio || folio_trylock(folio)) {
> +		anon_exclusive = folio_test_anon(folio) &&
> +			PageAnonExclusive(page);
> +
> +		if (pte_present(pte))
> +			flush_cache_page(walk->vma, addr, pfn);
> +
> +		if (anon_exclusive) {
> +			pte = ptep_clear_flush(walk->vma, addr, ptep);
> +
> +			if (folio_try_share_anon_rmap_pte(folio, page)) {
> +				set_pte_at(mm, addr, ptep, pte);
> +				if (fault_folio != folio)
> +					folio_unlock(folio);
> +				folio_put(folio);
> +				goto out;
> +			}
> +		} else {
> +			pte = ptep_get_and_clear(mm, addr, ptep);
> +		}
> +
> +		if (pte_present(pte) && pte_dirty(pte))
> +			folio_mark_dirty(folio);
> +
> +		/* Setup special migration page table entry */
> +		if (writable)
> +			entry = make_writable_migration_entry(pfn);
> +		else if (anon_exclusive)
> +			entry = make_readable_exclusive_migration_entry(pfn);
> +		else
> +			entry = make_readable_migration_entry(pfn);
> +
> +		if (pte_present(pte)) {
> +			if (pte_young(pte))
> +				entry = make_migration_entry_young(entry);
> +			if (pte_dirty(pte))
> +				entry = make_migration_entry_dirty(entry);
> +		}
> +
> +		swp_pte = swp_entry_to_pte(entry);
> +		if (pte_present(pte)) {
> +			if (pte_soft_dirty(pte))
> +				swp_pte = pte_swp_mksoft_dirty(swp_pte);
> +			if (pte_uffd(pte))
> +				swp_pte = pte_swp_mkuffd(swp_pte);
> +		} else {
> +			if (pte_swp_soft_dirty(pte))
> +				swp_pte = pte_swp_mksoft_dirty(swp_pte);
> +			if (pte_swp_uffd(pte))
> +				swp_pte = pte_swp_mkuffd(swp_pte);
> +		}
> +
> +		set_pte_at(mm, addr, ptep, swp_pte);
> +		folio_remove_rmap_pte(folio, page, walk->vma);
> +		folio_put(folio);
> +		*hmm_pfn |= HMM_PFN_MIGRATE;
> +		if (pte_present(pte))
> +			*unmapped = true;
> +	} else {
> +		folio_put(folio);
> +	}
> +out:
>  	return 0;
> +out_error:
> +	return -EFAULT;
>  }
>  
>  #else

Thanks,
Balbir


