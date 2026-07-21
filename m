Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BEB5C44529
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 15:16:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30F166B0096; Tue, 21 Jul 2026 11:16:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C0A56B0098; Tue, 21 Jul 2026 11:16:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18B6B6B0099; Tue, 21 Jul 2026 11:16:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C7E986B0096
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 11:15:59 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 362DF1201E0
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 15:15:59 +0000 (UTC)
X-FDA: 85013134038.16.C443392
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013038.outbound.protection.outlook.com [40.93.201.38])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8935780008
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 15:15:54 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="HpLjbux/";
	spf=pass (imf02.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.38 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784646956;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hS4zuFtTyMq+JDJzPjdXlDgJSiQXaImVVR79pCcuFuo=;
	b=SPEpPvH9W+4QP2nX2Q2LdiEKcIcXBVqulZBT3yN7cueg23plD/3HLw7Sp2nYcUj3hbyAIz
	+MVb2cbyrl8xpjnRp96fCdDp7PDrML/zUb0lxqCwfOYI9KQlQKmUafGQhFDToZTW5TKmSK
	VeT/L/hNvm9ZLnnvSIGoPn3K377ijJQ=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="HpLjbux/";
	spf=pass (imf02.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.38 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784646956;
	b=Q+r0RdMmZDmpMtW/Ed8BBRJfytG/DwBnZNC17erGVlh95jbfvKD+hCFG6/iGSHn0AsCUQf
	2TsA5ypL89WHOL6/WGjTV0bbdcL/Ja52Rlp3kDyCM+t+M4/rYZHCp4TF8z62mfmfsXyKep
	NN6+Tob4oyAwOExscPkzmUBkSsAvsO0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PqHYcqpIGFj8YsnM4cxzY1twfUsPeykY/tCE/YSzU8RQTCd9OcrqXLdgL1ajxjkG53ajroEiZQG/gSbMfQZROGRUOua7NmcPDuwU9Z5+TIXU+ZSirXQa71Z/xhIX8Nsr2uXVigQnmpfSiIJnY/btUUPDg2fcy7TT4NJO3MKVJxDYlOGYMe2ec/iNxypCylbiU4wJC/8LBpuOh4emweX5OlkN+r7yfKSbYK0Sl10nvP2emQRSCb4Y3VT0QHmS8kT/oDY9Q6vr9f4lOGAMzkuMdUTKp1oQPkrfeNqE15rrBQheBcPlrHrVUJeZ/WZMLGbe7JuD0xIH84eWBEUVBGE5Mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hS4zuFtTyMq+JDJzPjdXlDgJSiQXaImVVR79pCcuFuo=;
 b=iK+CRDNffvv4cP79/drD9gm/rDoHNkS3PpzEn69+VcxCsOAGFmPJBNQjQBQ34Ine37pOq54UULkgaQGanQoM87kw80hw+oBslaOyRLCcFHEi+Ip6gTkhlMEvNe7y7Lg+0xTbRRMKFJX5Q4jV+tiNaVLjUYFcTITw/fWPpEeifRuIWM0Clj4l7NXUINGy5IJV7dhj7lus8FIbfeIdrkkTJgtUNAtIa+A6eau8Yo47dhKO1I6uRCC/Tf/oGvMK3g3XohPC9eXrdnyHi5B7PvjEd6TThmVyrvro+pV+6whi+C/9DeXCplQiIRblvRAMKiJPfUln6Z2nuHM9e2KFSAc12w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hS4zuFtTyMq+JDJzPjdXlDgJSiQXaImVVR79pCcuFuo=;
 b=HpLjbux/r4juu0GNmx5kFj0yIft1HuZxp0CImK5EE88ATr8XhDKxLi4aH7LHzRDMezwfB4VKmPLivEBSmwAqAYy//YWKd8xUVS8CCcwg31aaS06nEKYX8HUXmljwIpC7ifocgqzPQ3QVLShOST3AQeUbm6DT/XuTpv01zVNkXPL5sGQt1nrsKrsHWbu9RPUw0ybVNy25o6aJ2V5W01OwCKQrL/ra84ONC1H3BMTmRWkIKd4o2sS8MHrbjkKY+jpilJGzUrOnBNJu1H+97prz3jJb4CcIBI/xynFrwNzkPSNS2XKAwYqa0JIcPXcfjz3RIgexBWMc5NEYm098ca0VRw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DM4PR12MB6038.namprd12.prod.outlook.com (2603:10b6:8:ab::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Tue, 21 Jul
 2026 15:14:10 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0245.009; Tue, 21 Jul 2026
 15:14:09 +0000
From: Zi Yan <ziy@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>,
 kernel test robot <lkp@intel.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
 Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [linux-next:master 6918/7793] mm/page_owner.c:818:22: error:
 passing 'memdesc_flags_t *' to parameter of incompatible type
 'memdesc_flags_t'; remove &
Date: Tue, 21 Jul 2026 11:14:08 -0400
X-Mailer: MailMate (3.0r7023)
Message-ID: <47324237-F22A-4BBA-B9F9-5936C16489D8@nvidia.com>
In-Reply-To: <202607211642.g3Xlz5F8-lkp@intel.com>
References: <202607211642.g3Xlz5F8-lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-MS-Reactions: disallow
X-ClientProxiedBy: MN2PR16CA0049.namprd16.prod.outlook.com
 (2603:10b6:208:234::18) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DM4PR12MB6038:EE_
X-MS-Office365-Filtering-Correlation-Id: d58c4cd7-b8b4-48af-0314-08dee73ab6e5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|366016|56012099006|11063799006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	zX1EGmljngXPDphXvHcsSKGdH8xAVksKcw08kvjrL/owpQCs/4qVka44lsIwGiOk20DSDBxl4Im4d4KITUGN3SNEOfjwLj3Ra2p1vpvFWnyDRWXZRvS/grV9/E4L8BbbfKfmvMsU3pUV5CvXg1iuQT9METfFRyzeaBg6y0k0wI68seyWZtoICXlSJ0numkOvVezKbdYavw0JjkDGCFL91woi6CfjzCAk6Rn3AkE/Sf5825TMGw2xoHlyghYl0lV9WweFFhGADDsWiIZayW2Jqw4DMmQLWUXK8w8y7Bs80CoSNQs4nCc6OLr0P8d3NtQ2Zu0jwtcplO+lztonpm1SF4gpLEkkadxLbWY4dFN0p/qUuEz0jkrlUrGPVcJuYp11dHbWxEib6WmPcGXqpW32/JD/qdgSUOik14qNLGgEDNH/noEsCDe355AiJ9qM0tej4ptH8mByuy2ETWOP2YRjQxtQNVuPgjCZp9DppwMhgFx3GvsmF2lurKcjaiR76+cfC97ktzb6Sxp1DCbqgGol5Ra/zqKBCAtecrqK9H3egFpEEPj2248MFdF7rM1fI4Yuz2oXq4M3bMPF2JXoC5h9EekH5SnHvgXRdpovZ/RCdW9Tyw8CvO2GdtGwKjTASEm5ORQHJntfYIchdEXA5nycARPFtG9vJJAveUbCBJoS19Q=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(366016)(56012099006)(11063799006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VDIyZ1pySUczMGRyekIvSEVGYTRZRUxDQ2hhcnpLNm5QeFpxVi9kL3FsTnZW?=
 =?utf-8?B?Snp1UjJLY255elZKZ1ZQQ0Q4dFlmalZHeWlRL3NyNmpPZncyaTJXSHM4cEVr?=
 =?utf-8?B?ckJTaGlZalpvYi9VM3dOY3hHNHBnNnJyY2VZQzZ5SmY1SVIzQzVvUmZIWUpX?=
 =?utf-8?B?Qnp6VFdQbnloa3laRjJlVTRtTi9DM2R3VTV0MmVGL2s3bHZWalhGNk0rT2do?=
 =?utf-8?B?OTBWWnIzQXBnMGMrc09NOWVZT0UyMmNyZEJZSGs1VkRoek0rZFc2MXhBUmJX?=
 =?utf-8?B?YjIrQ3RobEluY2VORmZ6N295a1NZYXBzaEk0a2U1MWxUZmZZR1dyVnNpSnRl?=
 =?utf-8?B?c1g0TVorWklaa2dxMmVCUnNFS2RtY3BINjN3UXcxeEozMUJCeWVhYUZ5UEhL?=
 =?utf-8?B?UkJjOXJWQnIvUnFKdURVWDBsdjEwbFNuYzBBYnhzTktobC84RUNzbEVuVXpD?=
 =?utf-8?B?TTZHa3RPa2hZQUtZcGNGWlpuaVMzVDZXWXVZcHRIbmJFWmVIWm1JT1lMcnVy?=
 =?utf-8?B?SlJoWm9rZDczZWl4ZlJCMUZvTld1ODhIZEcrK1J3eU1tY1dzZGZtZ3loN2pv?=
 =?utf-8?B?cDFFNGNxNUh0dDBCRkYydEpqeDNnMVRmZlpCbzh1d3dFYjZkZ1ZOQWl1WnlO?=
 =?utf-8?B?Y0RTNUlxS3NjQTVraXpZUThKZ2diSUxvODBHQ2lwMDFCeDlSY1RaUlJ1ald1?=
 =?utf-8?B?UjBKOThqekxhaXZZOEFaWGFYYm92T29RY015aHc4TUxCS0tNOXBmYlBFMGVX?=
 =?utf-8?B?T1pXVDUwb1FMK1I0UnpHZktzSUthKzRUZVRvRWhteFRobjRQVzFoTDEvT1Y4?=
 =?utf-8?B?UURmakhqeERsZzVZUzNHSVNjMk83Y3JqSVVlbkdnUnJqUXBqQkNJeXlraE14?=
 =?utf-8?B?bEpJZEExN0lyeUpNN245dnl3WjN6VytyakdWd1JHaE9DTTNvekduQ2FHUUZa?=
 =?utf-8?B?NmV0akRISzR5S1QxakZsSWdFQkxhOUtQbnJQWHA5ZGRMamh2WitBU3RRakg4?=
 =?utf-8?B?ZThtS2N2Wk5KMktyeFZaK0VEK1g5cm9nWEhBeEN6cGlTN2syMWd2eGR4NmhT?=
 =?utf-8?B?aFJNWHVSNzNBUXNySHE5YmZ3SEJXQ1pWS3lxRmlJa3ppemdicHBJVDhLbUo3?=
 =?utf-8?B?NnJvNDRDbjB0MXV0UC81bk9rczRGU0h3MW5iaTMyMjVlTGxmdEkzWG9OSkJR?=
 =?utf-8?B?RFRJZ015MXNZM2x0ZFBseVlUbE84R2R5QmNzdHRCTCt1cEMrbWVtcUk5VElM?=
 =?utf-8?B?VDEzbzJXY3VROEthZXhzdmpiUlI3eFIvRmxsLzZQR2NoY0VCZmV2c3ZhcmtN?=
 =?utf-8?B?NElQbHN5bWpxTUk4WE52S0ZYa1VkelozWkdFQmNpODAyU1NJdzhtS1JxMko5?=
 =?utf-8?B?MXR2cVhwemxSUTgxSkpGMndReFZLRjB3akcvZ1dFa050Y2NuV1lyMFVsU0ds?=
 =?utf-8?B?Skk0c2xEL0VpRUE1RS9obUgrcXlWOFlFSm1wVnJZTGZ1eXd5d3p3dDZEM29l?=
 =?utf-8?B?M3BIQW9GS21FNFJFTlBFbmR4Y1I5d3ZHakZKeXZPWGNsZ0dHdWxEY3l5b3Nz?=
 =?utf-8?B?eWVaUXBiTFVJYVQ5L3E2MjhZQWswMjNIa1J3Uzh4Y3R5elZ0K2ZIOENhYWNo?=
 =?utf-8?B?eGtEaTB5NG56elpvNnVMd1Q1NjJTK0lPcVhxaVEwaG8zNFNGejJHOUM4cExn?=
 =?utf-8?B?bkFKQ3RUQjA1MkN5ZHl6c0oyWGJyTDhObDg3M2RrV2oreEFSMllIaWdQdUFi?=
 =?utf-8?B?MVNQQjYrWWhwMEdBV3hGVHVFTlNXSFBvLzhiNGdpSGlaWTNSdzROeDZSMTZP?=
 =?utf-8?B?a1c5TkRzUENvcTZKeDF4SUgzU2FkdW1oTTBvbWY0ekVCdFBGZUR1R2hjdzJ3?=
 =?utf-8?B?RlA2UE51Nks2NVlJb09MOC9uMnNQTUU2S3J1VXRQZEJiSk1QdjRLeFZaYkd4?=
 =?utf-8?B?b3lHeFR1aEREUnNtNWhDNW9Qd3RISTVzL1ZWSWRTbzlvdm5yVXYwSi83VDky?=
 =?utf-8?B?aXJ3K2poVVZGMlpOZmRyNThqTUNGSkJWQVNKWXpFeVNYOEtmbWQzN2NmUHgz?=
 =?utf-8?B?ZWwvUVBRSlIwWUNGWGEwWStVYWRaaGlDWGxmc0FLeDhRZWwzSWFXSmt0Nzdp?=
 =?utf-8?B?bDhmUVBmZUx6UEZUMDhRQ1pVNjJaTk1rN0dIR3EzZjJ0VDNMOHR0S2RJVXdk?=
 =?utf-8?B?Ny9PMjNhZmZnWDdadWdCOFhFS09UbHJmR2d0WmhtSnlWei9LeTNKN1JONG1x?=
 =?utf-8?B?SzRmSjVBMGduY0VTVHNRVFdGVUt5elJCOEJVdmtudzRsdlNoYzY4akQvSVZp?=
 =?utf-8?Q?Ne9BrOUhFk7rCmTeRW?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d58c4cd7-b8b4-48af-0314-08dee73ab6e5
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2026 15:14:09.7830
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cwoBvcHys/C+6yh45W3LET/lrIMIaWr3uuTVExX2RS31wevRZ06HVSIK2/+irWrI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6038
X-Rspamd-Queue-Id: 8935780008
X-Rspam-User: 
X-Stat-Signature: 8i5sisq81sq4tje3bbqs11w1kifcrq1o
X-Rspamd-Server: rspam04
X-HE-Tag: 1784646954-323713
X-HE-Meta: U2FsdGVkX1+qExHHno0WiAxyQ0swDjn3vtXvnI8ABJOXqJ6sWfuEZW/SHFzWj/qnKaiHCmIMRCDwWk0O52dEWWTPCGMrzaM6bCG4hMYNVFzbNaAvDDRP9wH2w9Jq6T3nn6tagOoAv7JVOgEsd86CS9gjLvq8UV2GL8zHOYmA8n2dlRzSovWJI+WoW3kgG+HDvPB1p2wfaKb6pzp3ilU+JURsLLqYamEE2N1AStVKQa6QsWIn114NzSD2fX7jU+R5+HGF+sXD4rvieNDJ4+RAAvALw4YZcuMxC4OHnAmWb4S7diSnXvYmYJmtpPxR+9SaUmqgzeIojScyd1eCv8y8dhEfhUWQgb5D7oF3rb6QTKRIz+ugU1m9pgsz2LbXAjqEwwqLEJDq20L7m+Zc9yUlLxlbjE7py8PmwOum1WWv0b4boyqpv7GXqvuzU4NqrVOrOFg61XWnb/E5MXnpA+0dGEQzNC0ya1eNLYF+B+bAw1pP2NQyQyMpXsLVo+7hU4y/JlpvT+G9LD0lcXjykIPIvsAH4Li38PP0dkXs+SZLYIZKIXANKVXsZO7rohqi4KZBWPFoy53E/83UCKHcPP8OMd8HIeqnsKkv8kX2V5afi68EoUdJoUoVJ/cnpbnZxzu60y300JAS4X96h5Dm8fYAoqsKQaDSUnfS0n+pqdSOG3YFyPisYDqoWQVWd2D2yJMSjDh0cue7AFfPK42e3yZlGyXB4JVhS+ZMeehFd9j+sAWjghVzgkE37P84XSJJw9e0nHY61FQo3e16wwp0R6x2SDj8Hb3ffORvhqvCSqzpuuomN2RIGAp0HB5BMFZAbIGBZPSCzPySbgskviOIg4YwKwQC+1E/KiKMnmtsWNagwL1LDdyOv6d9Vy6tmyyYEzw0VfhH8tEG893FRIUvHO5Qk0hpPoqnGP3dFfoEFm2QMNBv8axvJFJeliSm+56UogFzU69pe/uX1EsYG3DzsGy
 li19wjx5
 L6niZE0H8//IdM8/GDjNbbXJ0wXo6T+k3ccDOIegO1NBxx+KrXm9MhkFo/0+GLrQI+bUigl+6lQimgha75ilz9D1NMl/BtgysnEqzEQKUANxdYDSEXtUIENFjGRly1L+ondBBBQMK8J+NxOzh1bfLgAiXeyJoWSocQRc3HQLOC/cpOW7yuyjXS12NuE2en0Z7XduPBMGuBLLA/XpxAThL6XeqOXXFMzMksnP8pR13OzgPLy3dSGEMi8Ll/54QVeDiELfgT7AO6yh5zzmTK5LWqGYPDyFdG+j3oA3pTYjtRGjuDrCFfuI7eCh7l2Pd0isOQ2ST6VLdsgG8QylZnGnoCho0PU1Dc/0xiqp6ElfNp3vjNBRZ63NTYYa7Vd+y0+Wp8Iev5pd/OkIrOwfhecdxdjYkh7cPntEWG+jbEBHYHkW91QmgqtkrFmf4pA/fC4N1GRGuIJOjxTOlvoHXWdGcp6pejbqImCh1JxuZZ6gRVzu9OA2HBmOmOZs85VVqvZqkq8ji+kKbuboJDZXzhsgkGTQPCTq/76z73Zbts7f8dFPjEeg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21 Jul 2026, at 4:34, kernel test robot wrote:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.g=
it master
> head:   3fe08b9796f36ef437ab9328e7dd1e5ff2d66603
> commit: 2e3c4a69b0c52d1f75d13c3ac380625143888e18 [6918/7793] mm-page_owne=
r-add-numa-node-filter-fix
> config: i386-randconfig-r134-20260721 (https://download.01.org/0day-ci/ar=
chive/20260721/202607211642.g3Xlz5F8-lkp@intel.com/config)
> compiler: clang version 22.1.3 (https://github.com/llvm/llvm-project e984=
6648fd6183ee6d8cbdb4502213fcf902a211)
> reproduce (this is a W=3D1 build): (https://download.01.org/0day-ci/archi=
ve/20260721/202607211642.g3Xlz5F8-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new vers=
ion of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202607211642.g3Xlz5F8-lkp=
@intel.com/
>
> Note: the linux-next/master HEAD 3fe08b9796f36ef437ab9328e7dd1e5ff2d66603=
 builds fine.
>       It may have been fixed somewhere.
>
> All errors (new ones prefixed by >>):
>
>>> mm/page_owner.c:818:22: error: passing 'memdesc_flags_t *' to parameter=
 of incompatible type 'memdesc_flags_t'; remove &
>      818 |                         nid =3D memdesc_nid(&page_flags);
>          |                                           ^~~~~~~~~~~
>    include/linux/mm.h:2291:47: note: passing argument to parameter 'mdf' =
here
>     2291 | static inline int memdesc_nid(memdesc_flags_t mdf)
>          |                                               ^
>    1 error generated.

Hi Andrew,

This patch should be folded into [1], which converts memdesc_nid() signatur=
e
from memdesc_flags_t to memdesc_flags_t*, since [1] comes after
Zhen Ni=E2=80=99s page owner patchset. Can you do that?

When I tested Zhen Ni=E2=80=99s page owner patchset, I reverted the older s=
eries
on top of linux-mm/mm-new and applied the new series. I got a compilation
error and sent this fix but did not notice memdesc_nid() was changed in [1]=
.
Sorry for the confusion.

Thanks.

[1] https://lore.kernel.org/all/20260630070810.470763-1-hui.zhu@linux.dev/,=
 its commit id is 357d3450fb9fd999994549e0b3e980de78bcd673 on mm-unstable

>
>
> vim +818 mm/page_owner.c
>
>    727=09
>    728	static ssize_t
>    729	read_page_owner(struct file *file, char __user *buf, size_t count,=
 loff_t *ppos)
>    730	{
>    731		unsigned long pfn;
>    732		struct page *page;
>    733		struct page_ext *page_ext;
>    734		struct page_owner *page_owner;
>    735		depot_stack_handle_t handle;
>    736		struct page_owner_filter_state *state =3D file->private_data;
>    737=09
>    738		if (!static_branch_unlikely(&page_owner_inited))
>    739			return -EINVAL;
>    740=09
>    741		page =3D NULL;
>    742		if (*ppos =3D=3D 0)
>    743			pfn =3D min_low_pfn;
>    744		else
>    745			pfn =3D *ppos;
>    746		/* Find a valid PFN or the start of a MAX_ORDER_NR_PAGES area */
>    747		while (!pfn_valid(pfn) && (pfn & (MAX_ORDER_NR_PAGES - 1)) !=3D 0=
)
>    748			pfn++;
>    749=09
>    750		/* Find an allocated page */
>    751		for (; pfn < max_pfn; pfn++) {
>    752			/*
>    753			 * This temporary page_owner is required so
>    754			 * that we can avoid the context switches while holding
>    755			 * the rcu lock and copying the page owner information to
>    756			 * user through copy_to_user() or GFP_KERNEL allocations.
>    757			 */
>    758			struct page_owner page_owner_tmp;
>    759=09
>    760			/*
>    761			 * If the new page is in a new MAX_ORDER_NR_PAGES area,
>    762			 * validate the area as existing, skip it if not
>    763			 */
>    764			if ((pfn & (MAX_ORDER_NR_PAGES - 1)) =3D=3D 0 && !pfn_valid(pfn)=
) {
>    765				pfn +=3D MAX_ORDER_NR_PAGES - 1;
>    766				continue;
>    767			}
>    768=09
>    769			page =3D pfn_to_page(pfn);
>    770			if (skip_buddy_pages(&pfn, page))
>    771				continue;
>    772=09
>    773			page_ext =3D page_ext_get(page);
>    774			if (unlikely(!page_ext))
>    775				continue;
>    776=09
>    777			/*
>    778			 * Some pages could be missed by concurrent allocation or free,
>    779			 * because we don't hold the zone lock.
>    780			 */
>    781			if (!test_bit(PAGE_EXT_OWNER, &page_ext->flags))
>    782				goto ext_put_continue;
>    783=09
>    784			/*
>    785			 * Although we do have the info about past allocation of free
>    786			 * pages, it's not relevant for current memory usage.
>    787			 */
>    788			if (!test_bit(PAGE_EXT_OWNER_ALLOCATED, &page_ext->flags))
>    789				goto ext_put_continue;
>    790=09
>    791			page_owner =3D get_page_owner(page_ext);
>    792=09
>    793			/*
>    794			 * Don't print "tail" pages of high-order allocations as that
>    795			 * would inflate the stats.
>    796			 */
>    797			if (!IS_ALIGNED(pfn, 1 << page_owner->order))
>    798				goto ext_put_continue;
>    799=09
>    800			/*
>    801			 * Access to page_ext->handle isn't synchronous so we should
>    802			 * be careful to access it.
>    803			 */
>    804			handle =3D READ_ONCE(page_owner->handle);
>    805			if (!handle)
>    806				goto ext_put_continue;
>    807=09
>    808			if (state->nid_filter_enabled) {
>    809				int nid;
>    810				memdesc_flags_t page_flags =3D READ_ONCE(page->flags);
>    811=09
>    812				/*
>    813				 * Bypass PF_POISONED_CHECK() in page_to_nid() to avoid
>    814				 * VM_BUG_ON when accessing poisoned pages.
>    815				 */
>    816				if (page_flags.f =3D=3D PAGE_POISON_PATTERN)
>    817					goto ext_put_continue;
>> 818				nid =3D memdesc_nid(&page_flags);
>    819				if (!node_isset(nid, state->nid_filter))
>    820					goto ext_put_continue;
>    821			}
>    822=09
>    823			/* Record the next PFN to read in the file offset */
>    824			*ppos =3D pfn + 1;
>    825=09
>    826			page_owner_tmp =3D *page_owner;
>    827			page_ext_put(page_ext);
>    828			return print_page_owner(buf, count, pfn, page,
>    829					&page_owner_tmp, handle, state);
>    830	ext_put_continue:
>    831			page_ext_put(page_ext);
>    832			cond_resched();
>    833		}
>    834=09
>    835		return 0;
>    836	}
>    837=09
>
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki


Best Regards,
Yan, Zi

