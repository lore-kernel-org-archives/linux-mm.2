Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF3FA606A32A
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 03:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=s2fH7TAs
Received: by kanga.kvack.org (Postfix)
	id ADCB86B05B0; Mon,  9 Nov 2026 22:10:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB3FC6B05B1; Mon,  9 Nov 2026 22:10:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CB386B05B2; Mon,  9 Nov 2026 22:10:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 719B96B05B0
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 22:10:32 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EAE911C4289
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 03:10:31 +0000 (UTC)
X-FDA: 85417731462.07.630EC9D
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012037.outbound.protection.outlook.com [40.107.200.37])
	by imf22.hostedemail.com (Postfix) with ESMTP id 29E16C0009
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 03:10:29 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=s2fH7TAs;
	spf=pass (imf22.hostedemail.com: domain of ziy@nvidia.com designates 40.107.200.37 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794280229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9vvfr6gbLyZykWn/1TujmRhg2mHrVp+i+RVwFc8etp0=;
	b=q1jQ/rUMvrhmf7bhX3T4m3kHpM1OfAEfnKNmvNadMkwsjlKuo+oswW3VS9887hiyFKv98S
	//4ZMDlLLV5aN/lLh6BEoEBQ2DkQoLd64hbTn5FZZ94aeVzErCvpNfp27Bz8FZS77+oYxh
	VfJh5vqU23NeisPjiOPjAVV1LBUm74Q=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=s2fH7TAs;
	spf=pass (imf22.hostedemail.com: domain of ziy@nvidia.com designates 40.107.200.37 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794280229;
	b=yrRXxV4rUugU8N3qaH/Jk2+BykcWGjBD91e1gh+acc5KoGxceCLdoESQl9aiiWutsl6gpx
	S9jqgTjFEg3GDpZQy3AC/1jiPcOgREuNIOPQmZS8fpoDtwUJgcvx5qIJHl/6SY5iQom32J
	H1rkzH18O8+36qkg3lIb01NFkgSpFMM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h/m/iufYPA2qBTwHO4bsYFiM7z+7UXO2Hc3CdsgL1QGAgpuXvTdqYQzu9APxZQNn455sM5W11Frmj/FXKAklEpPdgNRiuwYPaTAs7xIUZXaRGNf+pXWF9KZiqTWUn5SpvRAcYWI2idBIQ5Hs9jL7NmimH8GxoraRtDScuO9piNUNm7VSzCHI36ecivqc62SO5xTWNsdib9VgcvgXQB8IEcsXuNK6EQ1sEWUZFvGI2jPO7zJx0PF58GpTvKh1KY4uPk0ATbfo1Z0AFBQqz3IG4Uif6InDky1h2hfx7CAD3nCNj9gGHE1qdeYMG4C8NSdg1wyX8W42TvbkcWiN1EL8/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9vvfr6gbLyZykWn/1TujmRhg2mHrVp+i+RVwFc8etp0=;
 b=oAtFF8RIsVCaETLkTvLHGYIOmtIaUBEj9AIGOk/BQ4Yj0YxxY5jLT8djRQgft8dpZ4PdfgQtR2WhwtCptn+DtJpV+4os+KOFMDmML/vS2pjSn8lg/eRiQ8hfgrHbmF+pRHr1/NCwb5HG/Bwjat08Ajn3IJOTMB+2L6cG0IbstMwlEyOAvsZ1cTf9mlWXxCPgxJ/g54KxYjtycidI8GZNgkiB7Gg6H3HW0Ce2UQx0RnvPTWNdZMwC+u6MxU3hGc6QLYOU1DXK+0f5IgLyty38LEgSY28MFMEd59CefFbONYsYZ3Fiop1UcU7AbIs5RZRXqEkPLniOAXH+ohoVe4ZvUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9vvfr6gbLyZykWn/1TujmRhg2mHrVp+i+RVwFc8etp0=;
 b=s2fH7TAsdoYldfjCFWM+YE9v6MN8dJh68Vh0srj4QvUbpy7t4rAEKWRA7C6LA7R9eJ4UoBRWKJHcBfn5jC8vSa6kfBK+xiPqa2lksAjRKqMVAFj0CLjJo5KRtCm7jm206Ks6VUgB2BTQ+fRGqg8uLZvLkUi46ULV/sGwznlcqBBBZ0xev2IqhxVNUaL0L7Oc3OmTKNmAage6RS32ScwfFZ0nQdsdM36YJrDBavhzAiBvUKyuBjIEXnbFxThKi4vfaVWZpZgn6c/B2aQ4oCn1Q6lKJSp2vJCn1+JT6pIyJfGo0MgopSqW6cJ3gQT3vPz7aFUtcUme1398JuEY3DpcCw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by FT1PR12MB924478.namprd12.prod.outlook.com (2603:10b6:170:21::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.13; Tue, 10 Nov
 2026 03:09:24 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0592.010; Tue, 10 Nov 2026
 03:09:24 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 09 Nov 2026 22:09:23 -0500
Message-Id: <DMR78FJXMD8M.QC57KT5GIPX1@nvidia.com>
Cc: <matthew.brost@intel.com>, <joshua.hahnjy@gmail.com>,
 <byungchul@sk.com>, <gourry@gourry.net>, <ying.huang@linux.alibaba.com>,
 <apopple@nvidia.com>, <willy@infradead.org>, <shivankg@amd.com>,
 <ridong.chen@linux.dev>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>
To: "Song Hu" <husong@kylinos.cn>, <akpm@linux-foundation.org>,
 <david@kernel.org>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH] mm/migrate: don't move memcg NR_FILE_PAGES for
 swapcache
X-Mailer: aerc 0.22.0
References: <20261104044313.2099309-1-husong@kylinos.cn>
In-Reply-To: <20261104044313.2099309-1-husong@kylinos.cn>
X-ClientProxiedBy: YQBP288CA0048.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:c01:9d::18) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|FT1PR12MB924478:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b1e2b6f-2def-40cf-7eee-08df3ed805f5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|23010399003|11063799006|56012099006|261021121427099003|261022105027099003|261021123027099003|261022075727099003|261026140227099003|261028144727099003|261102123227099003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	W1eAOLVz08WlTN9RSQZrVQcbwVZoS+liAjGyknM7TNfGtwfEwFIpLnLn+kyaIIlZZzUTLrch0/oUSk7YRD4wTpTwBwPjmx6xC+87GBq+CYHIaggOidsnkUtiHIdAWWy+geMxgggPhDwhVztS1c2M9+Y9LKIa9DLr+YGQEXISj+/WRgFvvu3M0dcVR/+7iS+xfP6ofMFLtsBXT4JJWsdIHtxLOr3rgYjFmHhmIiImHXkY7NXq5p6yfIaMg/DV9/hqrsrJ3LeX8SN2NzDwjgw/i/mS6fpqJ9m63jMzZ2hUI1t2yA3cXIdIq00fyT/2bBIS+zZwEd3yIFxIerTlnCOmleAVtYJn01w+4mckOe5sAYGZen3zuVFa5T9y4v2lzGVZYUC1m+hukhoN7KCJB/AKFaUJdBWoNelUKTjbDyO1nB6iNv/6ACoH3WIoWN1dduexWck5kO8Br8/56lnOIDK3slkcctHHcnQ3djrlz1T0Q/7QZcXxksjhRNGAA1WTriQzzKVfru2QDM07GaZeGyGpO4cpSsXrSKmalqKN6lqbiACQkKBpfATUfNOKCHtjN2XU0hZzH/OcgMTuYontDu928z7o6YR+IhRJCjDeCm7jXxACCeBYknaS8dtuO0fTnGZUD3diG4ARrYpbO9/0LvSARflMwsvErxuxwg24M5zI8VY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(23010399003)(11063799006)(56012099006)(261021121427099003)(261022105027099003)(261021123027099003)(261022075727099003)(261026140227099003)(261028144727099003)(261102123227099003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RFZ6K1JHWGtZQkQ3RFc1SzRVZVJCUjV6N2NuT2NzT1J2WnRoZkhWeGkxUFpq?=
 =?utf-8?B?QlRQdnpKV2tubXh2a1VIZnRVcnBzdjhSRkdBbXovb2RSc0RFZDRnc285RzFs?=
 =?utf-8?B?UXU2ZWxPTmdwM1pRYkg3OGZFZVcxaXA1ckFOU1ozT3drRUpZTHVmUC9HUVRt?=
 =?utf-8?B?UUlUa0N1V1JPbXA2dDBobWw3dEZDNnl2NGNGNXRGekRFYmRTS0F1SUwzblVv?=
 =?utf-8?B?YStZTU9mSnBMU0V4Y3Z5Y2orbmZGOTFGalFXQ3pkVGV4TkFEdUprWjJscndY?=
 =?utf-8?B?Zm5DSUR2aTA0eWRZMmhIY0tVVnIzN2UxaDQ1dHZDTmcyaDdHeFVWMnNNQThC?=
 =?utf-8?B?UGhOWlF3MWo5dEZFczE5V2dXMW9wNk13V3duTXhraDhRck04cTF3dHc3UFhu?=
 =?utf-8?B?dlhPaWVUSlFKdW42OStNRk40M0xaLzl0TkNENTR0RGZ6a3pVaHRHb2tpbHEy?=
 =?utf-8?B?aHAzSFFldWk3d3ZyalB3cm5idU1KQ2p1bjVuMDJOcDQ2cDd3NnZzaFRTdVB5?=
 =?utf-8?B?dVpmaGJFQmNCd2FjRnlJZUZnTUJEcVR3b1dmSG5OOFNxRXY4SVFlam96M3Js?=
 =?utf-8?B?WmpnVkFzV1g1TWpaamMxQisrV2oxOEVHVW5IcUZmdlFsUXBoaTNkUWwydHpr?=
 =?utf-8?B?enA1aS9Nb1pVYXZocXBmZlVkaGVjVmtNWGxSSzhPNzJiTG4rb09QWmw3VFNz?=
 =?utf-8?B?VXp6RFNWT0VlZHVJQ3ZobGEvcFFjcmZhWXRrdGU0NVpGOEpGajdsa056S01Q?=
 =?utf-8?B?V0tVK0lTY1QybkFwU3V1em5pRG1xczNET0Rwb1NEYzVKRnFHS0w3U05IQldQ?=
 =?utf-8?B?ZUprWGxmb082T1Z2dk1rU1c1SjhJY1hNZkg0aDM0a1hVaEwxaHBORXU4eGMx?=
 =?utf-8?B?eldJQVQweXNDWmxsNzBlZG15TFFJNTl4eXJOR3c0TFQ1U2ZPOEFWQTJZa05P?=
 =?utf-8?B?VkxSY0NyWm5uVE1BUEZEZjhuM1RORmcrczJlMTN4M2Z1VEJhc05oRnJHL2JN?=
 =?utf-8?B?K285T0lRVG9zR0wrU3BiSW9vaXFvRFZ4U0Jja3grVHJGTDFnTWhjTzNRcDhL?=
 =?utf-8?B?UHRoamt4blp6Vmk4VFlFaVI3ejNSQXRvUklxL0tCbGZhUEpIeVAySCtJV0ZL?=
 =?utf-8?B?Y09xU3FmN0sxdk13Z0UwOUxocU1wWHpmdzlFbm4rMU5aZWY2b01iNEFXQnoy?=
 =?utf-8?B?eXpySWJIL2ZNb2pkUGllTHBRT0hSak41OGhzNitoTHFjbjNTM0dIZEpsWks0?=
 =?utf-8?B?MERCeTFKOEUzSnV4UTFFTE1Qcy9rOFFUS0NoRnE0NWo3aGJqV0R2RlgyTmov?=
 =?utf-8?B?ZTVwUTFFdlVuLzQyNlBFczZMZy82aWFFR09KZVMyWGhyZDVxb0VUb1Z3OTZK?=
 =?utf-8?B?Y0RKeWdDN01ZRXhNcVZBVkxuV1FDM1kvV240dWc2QllHcWhmaUk1SEllZ2oy?=
 =?utf-8?B?TFJmQzh3VW9NMmliNXN0WEZFbjlQaGNNdFZOd3ZGbmkyUlZrK1RkdVRYNHFP?=
 =?utf-8?B?bVR0OFdwR1FDcUNpZ3JnSkp1THFlQzZRc3IyTi96UjEySW4wYURYZysxTmVp?=
 =?utf-8?B?QmpaZkZ0M1oxZ05melhLeHpUaFJHRWxaRHNDMTFGaXZXK3JjSUZlalRoa01E?=
 =?utf-8?B?ZlJDVnBmeW1HUGg4ZWM4R21aN2w3UVNkUUY3cmN6QXJkNXhDaXVWSDBQRnpw?=
 =?utf-8?B?OWk5dTlaK3V5SG90SW5BRHlCTVFNb0g5NTBva1VyMDBqZ2NneUJ0cmF0OFNz?=
 =?utf-8?B?eGE3b013ZExuMU5QVXVDWjYvbEFjQ1JBOEJUT3RNbVVpdmw5eVJsUlF0YmFQ?=
 =?utf-8?B?L3NCOVVCVnNveStjRnJadkdjQUdVNXU5Ly9QWWFka2dQcDhXUU16bG9KL0V5?=
 =?utf-8?B?S05oNTFQbzF2WENEQ1ZxSE5QRnRVTmdBZm9ubWNia0RpNXRKQ2ZTSnp1ck94?=
 =?utf-8?B?d1lScGd4ZTFpZ0luc0Q2SEkwM1dTSkNnRDYzUVJ4SnZHLzJNMCtYNUk2QkhB?=
 =?utf-8?B?a1M5NzhtK3VQaGlNellEMDNTOTFQMW1hTVdJSmt4S2J4ckZyd0dlZDBrelVZ?=
 =?utf-8?B?MlFRNHRFaXlVMlhKTnVNQjJTeEpHbWJPaXJLRjdCcmFaSFlNZW5IbmVyNi9D?=
 =?utf-8?B?eUZwRVFKeUdKNVdsVmxpZ0Y1di9Wai9sS3BOSmdKYk1RM3RTQXArZ3A0NTlI?=
 =?utf-8?B?dWpZNjhpNFMwWHdSNXVaWEVNczdkWEE3R05kb1VkRWhSczNZMC8vWWorc29L?=
 =?utf-8?B?NW1rNHcrS0VoR0Jza0tIclVVRzNWUE85aWdZb3RrK3g3cUtXVFpRYlRrTkti?=
 =?utf-8?Q?PenWGvOtLuZYhlrz40?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b1e2b6f-2def-40cf-7eee-08df3ed805f5
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2026 03:09:24.4851
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OGRy8E4tAD2uJGrFQESNHb3nve+LniV0UjU+6IYf0WHbTrQjuia34kFAJRfW2X44
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FT1PR12MB924478
X-Stat-Signature: 7wt1orfmutn7n79dspe8nc46mzkpjqcp
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 29E16C0009
X-HE-Tag: 1794280229-833224
X-HE-Meta: U2FsdGVkX1/ggdMBn72EMeeKsF10cVIsPXU7fpQMdtcZwcaTG5sJ/7lOxN6Cz751iwRzVinwHIQov+spTgQuRjbNlP3a46U9LJICulKSYKHiVODtvlYV6+vaVD+QV8TT7fPTwD0ZnaDQhLo+zQFnaW47QdKwRonOA5NskSNLCXux6jN/dz8bMJ8+1RqdWpuCQUjYkdG646Nh669e96SAasTk9bYyhGiwvp48oG6kF0DrODIIiPbqma6HfnVpdBqadoS6J6eO4h5rHYiSITTtqHMw5BjIW/RqvDBM8//a/SesNJZzbTVCvAcDjj2vGTM0aJsT4ki1vosnbWAZmwuXiXZS3sDisbQqXqJQd0P8juyOdQX4QmTV77wKNdUPkQCGLtkeugIqzMPtoReDXP+jRTCFiowtY/RUbaKxCkZGWMo8GnYbtDJeXBbtI1fbSGc3I+lpYmbY4d3EcAR0zYf1AH54+d4+/q60Twu3rFlvB0IzTBCy85t3103e8s+gXgkWlUOZXOOa9msXJ/j6vqpJj8SpKoGrnMrSftWK6Cxj8wWCur6xQGCULgWnVnc/ITHlpoCBCoXVFNoDILYzNgwYxCCY0ze+RdwUfKSmerei7MRVPDwf6HY3sjX7lZR9s0uqqZ0jJyvgN2l6iYoVjYLtIypWzplSaSrBHdemzKCsw1IE7epq1HMZHora0S0dViAjjeRvgvGOcv5o9raF+RuSuEM9Rx3kOrK2hVssNU2YpMQpYXG58UNsoWN8UfAFq+H+nvxsicE0sAt0bRof4ixT5jTTzu0/6PvG29Hw3YsK3iJ/x413dM0sjCLbfakdXMPCa2+LA3J+qgC1o7KWDYn3tnAfw0jFKrXpNvGVIG9JpJlNUmOSXsT3fIk1XFEQ3/I83k6PXM9BB1jxo9pmqwTuFQoberqKWlafNGNgkBff0/BH1PeL8P4Z/1p1AbdRVhph7QctVdRnaj0ls0mlguK
 r2SeZkr/
 71v/KtpzqYOe0x9W2IndkDe7FxjZn8Fqme0ORiAfyMsIgT91q4A8wrWK15p1ulgYe2QGaQlhCvPXmFy9kD6j1IjSnYkvGVMIJI4wUcAsxEucwpg8EdkUrMxZghabUMd13zkcZjzexC98ZidHi3hg11vQGxRq86y4UHJpJH52Ea17JhvoxXMClljapPRgWOzRLrZJiJxwtLsrpIV1edsNxpQteRQ4BjVRpKfUFPcaVaRggYs1PhEMnOK+/WN/vK0d+qyfYfud2Ie9gItTylFcEADhCyit7xZBATNxPONOLHN7mXErxyrr08K0mXCbrOkgQrCKnvheRRmJcMlnJ9v8CD4laj42+JsqwbApYcFTI8c7ur3cGY4xta37oWkL8lV2m2luIriwJ6h4PvVSTesdc4EIfNX2mY6nEIGbPPuQf6QHgsBSnVy2+acpvxT7diTZNup5GoZdAjX52LAR6n73+Qx96YeIFfWTIodYyw41GQrWgwmi84xS//Hg2Bm2gktxKWuI3jDd1ZmgRlgY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue Nov 3, 2026 at 11:43 PM EST, Song Hu wrote:
> NR_FILE_PAGES lives on both the node and the memcg plane for page
> cache folios: filemap_add_folio() and filemap_unaccount_folio() charge
> it to the folio's node and memcg, while __swap_cache_add_folio() and
> __swap_cache_del_folio() maintain the node plane of NR_FILE_PAGES and
> the memcg plane of NR_SWAPCACHE.  A folio in the swap cache therefore
> carries no per-memcg NR_FILE_PAGES count: shmem folios drop their
> memcg file accounting when swapped out, and anon folios never had any.
>
> The cross-zone arm of __folio_migrate_mapping() moves NR_FILE_PAGES on
> both planes unconditionally.  For swapcache folios the memcg plane is
> empty, so migrating one misaccounts it: the destination accrues
> nr_pages that were never accounted there while the source counter
> underflows.  The wrong counts persist until the memcg is destroyed,
> but the aggregate in memory.stat stays correct, so the drift is easy
> to miss.  NUMA balancing, migratepages, compaction and memory hotplug
> can all migrate such folios.

It would be better to simplify the above like Joshua suggested.

>
> Reproducer, on a 2-node QEMU guest with cgroup v2:
>
>   1. create a cgroup with memory.max =3D 50M and swap enabled;
>   2. memset 128M of anonymous memory in it, so reclaim swaps most of
>      it out;
>   3. fork to raise the swap entry refcount, then fault the memory
>      back in, so the resident folios are swapcache ones;
>   4. migrate_pages(pid, node0 -> node1).
>
> "file" row of memory.numa_stat (bytes) after step 4:
>
>                     without this patch      with this patch
>                       N0          N1          N0          N1
>                      0 (*)  51691520         0           0
>
>   (*) the source counter has gone negative; negative values read as 0.
>
> Keep moving the node plane via mod_node_page_state() and skip only
> the empty memcg plane, mirroring the swapcache exclusion the NR_SHMEM
> handling in the same block already applies.  It accompanies
> commit 4eef27af2932 ("mm/migrate: move NR_FILE_THPS on cross-node migrati=
on")
> and commit c5eef2e03618 ("mm/migrate: move NR_KERNEL_FILE_PAGES on cross-=
node migration").
>
> Fixes: 0d1c20722ab3 ("mm: memcontrol: switch to native NR_FILE_PAGES and =
NR_SHMEM counters")
> Signed-off-by: Song Hu <husong@kylinos.cn>
> ---
>  mm/migrate.c | 16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)
>
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 28a8d7734735..bc60f6587d1b 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -690,8 +690,20 @@ static int __folio_migrate_mapping(struct address_sp=
ace *mapping,
>  		old_lruvec =3D mem_cgroup_lruvec(memcg, oldzone->zone_pgdat);
>  		new_lruvec =3D mem_cgroup_lruvec(memcg, newzone->zone_pgdat);
> =20
> -		mod_lruvec_state(old_lruvec, NR_FILE_PAGES, -nr);
> -		mod_lruvec_state(new_lruvec, NR_FILE_PAGES, nr);
> +		/*
> +		 * Swapcache folios carry NR_FILE_PAGES on the node plane
> +		 * only (their memcg footprint is NR_SWAPCACHE, see
> +		 * swap_state.c), so move only the node plane for them.
> +		 */
> +		if (folio_test_swapcache(folio)) {
> +			mod_node_page_state(oldzone->zone_pgdat, NR_FILE_PAGES,
> +					    -nr);
> +			mod_node_page_state(newzone->zone_pgdat, NR_FILE_PAGES,
> +					    nr);
> +		} else {
> +			mod_lruvec_state(old_lruvec, NR_FILE_PAGES, -nr);
> +			mod_lruvec_state(new_lruvec, NR_FILE_PAGES, nr);
> +		}

Like Joshua said in another email, it will be more readable if
NR_SWAPCACHE updates can be moved into the then branch above.

>  		if (folio_test_swapbacked(folio) && !folio_test_swapcache(folio)) {
>  			mod_lruvec_state(old_lruvec, NR_SHMEM, -nr);
>  			mod_lruvec_state(new_lruvec, NR_SHMEM, nr);

Anyway,

Acked-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi


