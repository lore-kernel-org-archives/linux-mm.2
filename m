Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F3BDCA6007
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 09:20:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 250A96B008A; Thu,  8 Oct 2026 05:20:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B3C06B008C; Thu,  8 Oct 2026 05:20:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 054126B0092; Thu,  8 Oct 2026 05:20:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CC3DA6B008A
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 05:20:27 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3F615804EC
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 09:20:27 +0000 (UTC)
X-FDA: 85298913294.02.D42989A
Received: from MM0P280CU009.outbound.protection.outlook.com (mail-swedensouthazon11021120.outbound.protection.outlook.com [52.101.76.120])
	by imf06.hostedemail.com (Postfix) with ESMTP id 48CD6180002
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 09:20:24 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gaisler.com header.s=selector1 header.b=INuFnRN8;
	spf=pass (imf06.hostedemail.com: domain of andreas.larsson@gaisler.com designates 52.101.76.120 as permitted sender) smtp.mailfrom=andreas.larsson@gaisler.com;
	dmarc=pass (policy=none) header.from=gaisler.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791451224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nChlZmlrvLWslmoho1/5aTc9r9JcLlsuI9ltEi1anog=;
	b=uIxiEnPB77uK8rk0iyve/Qu0o1OWf4wErVo5A4xzRKmbXGAruvPy4P1EFXCsqz5VjvBL3I
	mG16gu60VQwf6rYf5lggonVUQDlPyCvRdKzNTsTPL9g+/0IfLaTPCFIxKuIXR+1/Bwj4qw
	gNhSfpov8nZxG/SESPtjyGLFHXdBo7c=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791451224;
	b=5bUkt518XEuR+wk94LJ+3CznccD8G99uq15ftaBo4g5DaFbJmIWilgxMfnNlMj9pdpkHk4
	NrulfY71mUm4grCLd1fjYY9lUJTCYJ1iF7B3pOOKKdZ8sqBLom7i3snMCvWW4OYpOr+e1A
	G4adyZHb2gEeNSoYA1oU35mFCWS+vxk=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=gaisler.com header.s=selector1 header.b=INuFnRN8;
	spf=pass (imf06.hostedemail.com: domain of andreas.larsson@gaisler.com designates 52.101.76.120 as permitted sender) smtp.mailfrom=andreas.larsson@gaisler.com;
	dmarc=pass (policy=none) header.from=gaisler.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wWYCaXyqJi4ZWPF6qGx6PPahhWGHET64lXKc47FBjG7p2ybmlaSw3rSqwcUE/w6495DBBi00Msx1Pad4CqMHlQlVM/qJIb43Q5vas6TnhUz2FdJfY3o6B2lwCryb05C+irQEX9CK9zOP4PCPwtgggpydvj9tiGz5gFS6IjMBwPI6bAh3/u5LsJOt+jF5jWza6nAnQNwx7cGLV5HlOz3lAZgm2cs+gOYRAbkzrFUX7971nLmSWo/Vtm1aZx2dKuksQVEeWsAvwcOHAAlC2BAH2vckuGtUVDeqtRen6KsZsXENvEjTjnymAkIWFVRdV6NxSVMk43cdlaX24bz4xvnycw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nChlZmlrvLWslmoho1/5aTc9r9JcLlsuI9ltEi1anog=;
 b=EWlQpJR1KYsOvtPjPBUbxCi4oXSmjhItlg/0F5aiUdQvXqIqDoCkmDk8i9oy4P1UZrVAO50NbeQ2qOyuzNSviNYashd2A8Iio0MztmgBkxQtH8DrkGsak+6QUS5bTPwAObwhg6jYu7nAYFdphTRQNywuypUTYJT/jkCyrJ9wD715p9Nijg4YPW7QZCwJmjdD5lPzVTSrr5yeqR3JkVu02DcEbyuv9s+t7ECmIaAbzjrAq85WOSi50rlHBNq4tuWFkqH6xfbV3WD7KshbsfI9ufAaE4aHcWpvGYL5/aaP+AGRDHan8ZnF+AtHymELnX+JmRaqAwL9nnBZoN4FVLBWTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=gaisler.com; dmarc=pass action=none header.from=gaisler.com;
 dkim=pass header.d=gaisler.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gaisler.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nChlZmlrvLWslmoho1/5aTc9r9JcLlsuI9ltEi1anog=;
 b=INuFnRN8HZTZOmhztmeE+FWSg1C4ii9V9BgUPQhgDJ8RNd+LGyBWi29rZlGXHvH4Z0GZukAbrrEUd0nzmbqjHKg79DgHWjVgSQ0gc4YaqpMmpuSQB1UaoPfWU4gZjqGOATUuLN7KeBByoJkt4/4D6lM0ztbm/o5DPbwPmtuEgBaTMP0iptchQ/0h5NNjuKKvSwcf3Zc7zJKLoWCgKKhqaM0rYpC5qZi9c5buiMvfMK5GC5lkxReIkyvtUoaD2PFCY5fggNJ/0O0fl7QtbwSDi8zqAFCsedpUclVBHil2D/RLwqNrbjWzjN+WTGlLd8zLfiUjSYM5paTFCQs0O7ZJJA==
Received: from MM0P280MB495062.SWEP280.PROD.OUTLOOK.COM (2603:10a6:190:2f::5)
 by GVZP280MB1086.SWEP280.PROD.OUTLOOK.COM (2603:10a6:150:f5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.17; Thu, 8 Oct
 2026 09:20:17 +0000
Received: from MM0P280MB495062.SWEP280.PROD.OUTLOOK.COM
 ([fe80::1f13:f10:e16b:7939]) by MM0P280MB495062.SWEP280.PROD.OUTLOOK.COM
 ([fe80::1f13:f10:e16b:7939%4]) with mapi id 15.21.0472.016; Thu, 8 Oct 2026
 09:20:17 +0000
Message-ID: <c24fc419-7bee-4fe4-be12-9aa378d49af1@gaisler.com>
Date: Thu, 8 Oct 2026 11:20:14 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 8/8] mm: Drop pxd_ERROR()
To: Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org
Cc: samuel.holland@sifive.com, David Hildenbrand <david@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Yoshinori Sato
 <ysato@users.sourceforge.jp>, Rich Felker <dalias@libc.org>,
 John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Helge Deller <deller@gmx.de>, Huacai Chen <chenhuacai@kernel.org>,
 WANG Xuerui <kernel@xen0n.name>, linux-alpha@vger.kernel.org,
 linux-snps-arc@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
 linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org,
 loongarch@lists.linux.dev, linux-m68k@lists.linux-m68k.org,
 linux-mips@vger.kernel.org, linux-openrisc@vger.kernel.org,
 linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-sh@vger.kernel.org, sparclinux@vger.kernel.org,
 linux-um@lists.infradead.org, linux-arch@vger.kernel.org,
 linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
References: <20260831054331.625505-1-anshuman.khandual@arm.com>
 <20260831054331.625505-9-anshuman.khandual@arm.com>
Content-Language: en-US
From: Andreas Larsson <andreas@gaisler.com>
In-Reply-To: <20260831054331.625505-9-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BE1P281CA0084.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:78::11) To MM0P280MB495062.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:2f::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MM0P280MB495062:EE_|GVZP280MB1086:EE_
X-MS-Office365-Filtering-Correlation-Id: 83646bf6-eeda-498e-e234-08df251d5e2c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|7416014|56012099006|4143699003|11063799006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	NC/qpKPoxiyUAIaFboaEX4yQJbeZ+vmHWvsqeQ5kGT8l7X9fcYqp9eBx5WDlxiVvR0L+48Kj8haTuGmN+ee23fz3oSbjQL0jDYSXa+8gvblI86UZZh4H3rc1iI63OnAtUl/Bc29s8THJfx5bFeLN0emAE2uZAHoMFHy90APywhP9Z8AjykGKVGL0t0c2nvMe3PsGovHxRyjauii+CaAg7FIwI2CS/HOCQfII4YJSPtE4I0SRp+V6w4RmvmGuzeCsqZSrWw82tVXGVw0nRXYEEjprr2bBi/k2erOTWX+ty2uFPb9NPtUYLqYJ9PHu+KDHk4Q/vhMUK3yGm+xZ+4lHwTIkrPlcoR9I3RrI4QZlUmJ2jnb0OByBCKTN6WeW3SPL7RUqYcLSHKhK7REebKrFE0KT0iexUictJu2Fnotxo5BB3aWPdM5djXsume4Uu/+LrZgrVePGx8jVXrq7s0fx3tDDa8Its7qN4Q+p0W/zrq+NcYe8ULVC7XRuOjK0vRn8IJYPzelV1nlbTqr5dOdn1l7Ngd1FRLzsM1A/gAKUICvJl7+yqtc729F6ZYuOPgHw3w2EZKjndGEXmpox7kfKl6X1HCrim3tkhks2tAZ3SktjZtPITkfZDdVBJ/FfT8XA3Aw4kbnTbKOULc4nRgbN9ElLoKLj3Wvavjhkq2aZS/c=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MM0P280MB495062.SWEP280.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(7416014)(56012099006)(4143699003)(11063799006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Qnc4WTMwaVBFYzJqcExMa05CL2Z6N2lPTHJIWHJ6RkNtSjQ4YTA2YWhOWHNP?=
 =?utf-8?B?c3h4MGNyVWpGRXAxYkV5a0VycHRMZmJ4cENISm5EeHF6NFR4U0grNHpzVFNw?=
 =?utf-8?B?SitEcWRXSExhV2gvMW5hZUQweld3N2JSdVEyZGRDckVZMXZ5SlNzSklhcmk5?=
 =?utf-8?B?VEt1RHBCbXFKb0lDcVBwRXdFOHRDUTNqemh4TFExRnJhM0ZzTTR2N0JVYlZ1?=
 =?utf-8?B?VlA1YXo4RHIrbFRpa2QxeFM0VWJwVzQ1WGlaQmdBTFhnK1VLaHllLzdqSFNL?=
 =?utf-8?B?WE9BWUlhaHJKZkNPd0kvZ2U5TEZTUWZHOHVtMTduYW1wdUlaTTIxeFFmU3Qw?=
 =?utf-8?B?QWxmQ1NNSHgraGRsb1pkbmVORHF2eDF0bUFWTjBiNXFzZDczRDZ5R2xqdFRR?=
 =?utf-8?B?Kzhmc3ArU25pcDQyUEpkekh5RmxrVnV0TFVCajVUN2czMGc4UGFqZEx2SEpl?=
 =?utf-8?B?NVVVcjBRaFoxb24wVmZrTVBOR2FoYnRaUFpZSmxXcnVvV2w5TzEzaVgzODNh?=
 =?utf-8?B?eWdPV0J4ekp4bkVpdGUxY2RLYTRSWGZqSUlwVHNRdlFyMVEwNTZLcVQ3dlh4?=
 =?utf-8?B?UGdtOGNwb2g0d2MwQ0Y3ajRUVWRMc1dIbnRsVTFpSTJtclZzNFFPc255cnhQ?=
 =?utf-8?B?TU5abWFjbjBrS25UU01WMzhjdU9VZTZuVUpaQ2xBSHBSOWlGejFWK3RLaldG?=
 =?utf-8?B?RkJERVNnbHJnWFZTUkxTVjBlVTJ1d1JNdmkwUWhROHZtMUM2dlJJeHQyRmdl?=
 =?utf-8?B?UW5MU0cySjFHWUpkZ1RQSTA3SE82Rlczb1hqakhiVi80U3cxT2swK0t5OVcw?=
 =?utf-8?B?UjkyekRsR0JuZTk3QWZuR0RwYjV1SUNUbnNwaFBOQjA1TEdKWFRRRTNNNyt0?=
 =?utf-8?B?Y2YrTmZralIvNllYNG1aKzRONTJrZWYvTFFBbjg1S0lEcmZ3amo4UVMwWTZ6?=
 =?utf-8?B?Sm1VZXc4aStLMWx4dE9PWElQZlg4eXhaRGMwcHlVWFlJNE53NXh2ejl3NVZH?=
 =?utf-8?B?Y0dyaVc0bm9xVXpDV00ySWtnT1AzSElIQTJieHlKTys2a1ZpRDdUVElIKzBw?=
 =?utf-8?B?Yk9sRWlTQTlKeUZpQUYydnIvazY3ZjVBYXkzZXdZWjAxRlYrYXAxKy9PU2gr?=
 =?utf-8?B?UFo1U0hFSGRzUUZwYmFmalNmVTBrNHVmTmVSVVEwUGFxL0VlWHVCL3dIMFhN?=
 =?utf-8?B?ajNyNDJwblBVbjRDR1dvVHpuNEx6VUk5MldTY0ptMEgrNUZVUlRCd3kzMlB6?=
 =?utf-8?B?bnNBb1lya3pVd2g1YzJwVFpHNzUrRlJEVHdyMGg0dDBQck9zL0w0SGRjcC9S?=
 =?utf-8?B?NHM3L0RyU3hIaWl6QnFzbEcwZ3NwWG1uc0FsOGg4citQTTFRTWdKdEdORi9R?=
 =?utf-8?B?WEwySCtxUDBxYkRmMzhmNHVSVWR5SjgzeEt1WFN3U3lVKzdZY2k2UzBURmda?=
 =?utf-8?B?YXUvTFo3c0EvTVNnR0dieTh2VzRrWGJCY0prTWc0Z04vWXpJbFFVcjZLc3hF?=
 =?utf-8?B?WDRBbUFkbzBTMzMzcnIxTGlJTW9QOW1zVU5HSkc4NFNkLzczV3hYTUtzcjRY?=
 =?utf-8?B?WitCZ1g3SzNjbXFONGNDWEcxWlUyR0piM2p6dThwQlREaXFzWDhoYlc5Unlk?=
 =?utf-8?B?dWpjRk00c25DQW9ITEVTU0ZITDRJSm50MWZoeGNFRjlVZzlqZXBxVmIwbnFL?=
 =?utf-8?B?bnRRakpsRC82V3R4ZzBRbGl0aEtBM1A0UlduY2xCUUp5Q05VVXNpNFgxM0tS?=
 =?utf-8?B?U0loRGpFckpUUElXTkRSV01VV3hXN3F0QXBOMjRxWUJYY0V6QTdEZThMZDEv?=
 =?utf-8?B?SU04Y0VqU21ydmNCS3VMOXNQK2psemZXRHk4UDZPOFpvcmV6eFlndi9ocm9v?=
 =?utf-8?B?eXRVampFMmZvNVBQSCsxVGxkbXVCcENac0RGOXhnMldaVmhaelhlcXB0dnB3?=
 =?utf-8?B?RFdack1RQVdGVU94RWxQQXBsdlNrd0pTRkVneVFVRXZybnM0ZUVLMHYyRDVC?=
 =?utf-8?B?UkVKb0h2Qk13VVNiOXNkUWs1RHpKd2UvU2lRVlgvRnU5VlJ3ell6czZPN1Bk?=
 =?utf-8?B?d2VHdDZVUTdaYWIrYkdmYXFmNktSQjhyNWVlRHNOZ2c3RTJyL3puSm40V2lQ?=
 =?utf-8?B?RnJwQjhzRnp0bUZVeWx0bUxVN0E3NlJadU9oOGFDOGNRbFVjdzRxNjl4ek8v?=
 =?utf-8?B?UzFka04xY01xUEV4TmRoc29xUEcydDM1Z05kNWhmMjl3OVhHTnJDUVJ5WGth?=
 =?utf-8?B?cFFId1A1RHJEbitNS012U2x6NTcwM0gvbk9rekpFYVZZbG4zYS84elM5b2lY?=
 =?utf-8?B?d3N0d0dNS3h1RWRYR0NLUmFaeVVVWlByVURvc3JuTFh1SHp2SkxtSVpGZUE5?=
 =?utf-8?Q?yjjhfEohdeTOoAqE=3D?=
X-OriginatorOrg: gaisler.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83646bf6-eeda-498e-e234-08df251d5e2c
X-MS-Exchange-CrossTenant-AuthSource: MM0P280MB495062.SWEP280.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2026 09:20:17.5038
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 91fa4a59-2167-458a-8318-e45d80469d7e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5BZfB4EAaSFJ84qYftmRVMohK/eymk8QLHXJzzFm4elUHya77EOOlIY25xck2qu/+rvHfHMgpADg5257wP54q4lxf3y+8uFBxp0svqv6SU8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVZP280MB1086
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 48CD6180002
X-Rspam-User: 
X-Stat-Signature: tdfy7egabix1rp9wcpypnahqppptw6kw
X-HE-Tag: 1791451224-984174
X-HE-Meta: U2FsdGVkX1+kaGwTSHzoOSgjU4ILP11uSkhxHdr2qSs9I6M+s0kBWjFUlLX5H2GMVL7KG9XxifZ9aJlikmE4MakMzJp0k6LWa/ly67QW8P3qH6S17JVIBFxLhsEQijrSxw/4IWSXZiguBgCQwk/b4YYRWVOn7NPr7yqGLZLC6mIcqZbJEyXfovM1AstSCCugPMBLxUPJDKA1IqUs8PE7/77SJVJMx8X1OfRo8UWhLB91q5D/C2mHnxNvkHNZsMjdReRej5j3hhLpe3ugaiNg/B4ofiFC1vLf1HJy2hlkgPJ1gwmO2xnHXVqygbF7ysRylanAH3AynZ4fWjkHJrFYO1onlaW8DYZQaN7W1VJzRNcVA0vIxbz6miyjOP/zPM5Uu+dxKp47TBQxFJh71h//XaOO4gNrXeS2aCKrvZxt1wn4bIljRTtohZqdRIkyTKh1YH7V0MIdk/szs3iXsnJSbcgpfBqQVamlkBYja3gZtkUSYm6TuRpH2XpBHCsu8lEcVRWuZqwBmekikeUedZFqvmKHBA8Pic9rsbvwq69w/2ZMDJGGOjMwmSxqSPTNlG7Pzvn6+UZFRQjGrA852OvBau0DWvf0H7l1ELPpP6Ndc11x8Z3u0i3LXbtJvHMz1e7mriCjsDLd8Uh13CD9tl0oz069R3aIx8RgqObmLt5pldNmefE0OxDrv/XAP8jPF/S7Zcq8TFxbBueAzLWOBho2UoqT/1UxXiNvKvL7bgbbVrtwn4KPUOx9asCZ5lbSEITi14syk9TQOgYDhF15pAOr6j7nKpl4H4e9qHrTc73H4Epo0BS3TEDa2m+9E6LG1BUJJyjSBuJeQCQsr+M7lklWsqLmG7rhJlckICRG583Leh8wZQZ5OoStB1RWdWLxTj3EiRWLOLvBTUTA8M6odWZmZn4UEYmGntTO2UWY8U/6iVhrZcfJyxfK3/cNtPLHndxjwPILO5dd59tm6dS21QT
 9RY9oPGG
 dT5KIoYQqeUbc03Eo0EBxsLhSwaAbMUBe4rUImjH+WNDehmMBumgkFZ34qOdeZeYwLNay4rI5NLaZQcqkoJdj/GvEklXQfu18/MCARMd5dC1qVkBaJMhcRN8xcKwEkByB8cibTOo0I0x+AOs2dNhIFo3pZYySCEZtjbuR+9wBS9EhqAo/YWuD4oUseeZkZ4yN8DB16m69ZYDFbhlG2hkbo4NuMCyHjfnerCVIHKK9fWF2XiEuULosGBLuG94cf+PUtWSpeI2x9A0xgGRDPw/pAHRudffgyhg1Aqiow2gF/Scz0yE4jlYuc1XJbGzYfMrVMZ3hxkIVO4NJ6oiQzYUlLHuHuwdqW9KqpPzlFz6uBqyRjda7ZIVbxKoRJFI/i5paHHXp8803+wa8ylaQc6AKXE8eBpX0t1ksLSzYMEwe9YvmaLzcwnfa7JW8noIgLjDUFmkPih5knonTSXLJ/yKsvJUTSShbn260wWq/qCDt6lYhKe5VCnnbtNv1kiblgX72HYHQNKl8C8UuvXRwecmrNKqLuExCc9BFgOIxxjn5/zHeHzXqjdubhQ7QerNB6JUE7FNoicuWX6Vdq/6MMvMi93AXLlLotgknt3q0DN/x4Tox8lcmP3z1KRX3un7QkfKR0kHgOP7CzRQuc6E1if34XDpZszaR1xadHWixBU5lA6vFRJv0pHACaeO/pi6fh3cN96vP35UyPxhV8XTzhvfvDQAc/c2IDu0mH8agUwADFJmu8cBIm1gxCv2iFqahuO3KC/ANI/R5qTzV3cWzYMrkivabrfoJQ5wZeN6ZU39wAYqYPsPejdcIXxwSrl2dA/44R29tlzWyBo6iYu+TXMyTMRdSIySw8ajrcjVaFEoE0E1tXwdLE90sgnjhmR7325IbzM2yebtCW/lbibTtdRWYhkKhZjazpnJ/CSIhPpqcR3phIrYSllwYDmsLjQTE6/iY3f3jalDcMkEw1jacdHMef8CkXUVa
 8RhmPJU4
 2E//88IvSdrXt6UtUTOY5hgxhpkJsXuO4j3qwpZu1o0XzbDqFjkmiH6kW0PhNYO+R0peZKAv/2k4XOf3u3J+d4EWjqFyIP1S
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-08-31 07:43, Anshuman Khandual wrote:
> There are no more users left for any pxd_ERROR() either in generic MM or in
> the platform MM. Hence all these platform macros along with their generic
> fallback could be dropped across the tree.
> 
> Cc: linux-alpha@vger.kernel.org
> Cc: linux-snps-arc@lists.infradead.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-csky@vger.kernel.org
> Cc: linux-hexagon@vger.kernel.org
> Cc: loongarch@lists.linux.dev
> Cc: linux-m68k@lists.linux-m68k.org
> Cc: linux-mips@vger.kernel.org
> Cc: linux-openrisc@vger.kernel.org
> Cc: linux-parisc@vger.kernel.org
> Cc: linuxppc-dev@lists.ozlabs.org
> Cc: linux-riscv@lists.infradead.org
> Cc: linux-s390@vger.kernel.org
> Cc: linux-sh@vger.kernel.org
> Cc: sparclinux@vger.kernel.org
> Cc: linux-um@lists.infradead.org
> Cc: linux-arch@vger.kernel.org
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Acked-by: Geert Uytterhoeven <geert@linux-m68k.org> # m68k
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
...>  /*
>   * Encode/decode swap entries and swap PTEs. Swap PTEs are all PTEs that
>   * are !pte_none() && !pte_present().
> diff --git a/arch/sparc/include/asm/pgtable_32.h b/arch/sparc/include/asm/pgtable_32.h
> index f89b1250661d..5a5f54a090f5 100644
> --- a/arch/sparc/include/asm/pgtable_32.h
> +++ b/arch/sparc/include/asm/pgtable_32.h
> @@ -40,9 +40,6 @@ void load_mmu(void);
>  unsigned long calc_highpages(void);
>  unsigned long __init bootmem_init(unsigned long *pages_avail);
>  
> -#define pte_ERROR(e)   __builtin_trap()
> -#define pmd_ERROR(e)   __builtin_trap()
> -#define pgd_ERROR(e)   __builtin_trap()
>  
>  #define PTRS_PER_PTE    	64
>  #define PTRS_PER_PMD    	64
> diff --git a/arch/sparc/include/asm/pgtable_64.h b/arch/sparc/include/asm/pgtable_64.h
> index 0837ebbc5dce..44d1333065a6 100644
> --- a/arch/sparc/include/asm/pgtable_64.h
> +++ b/arch/sparc/include/asm/pgtable_64.h
> @@ -96,16 +96,6 @@ bool kern_addr_valid(unsigned long addr);
>  #define PTRS_PER_PUD	(1UL << PUD_BITS)
>  #define PTRS_PER_PGD	(1UL << PGDIR_BITS)
>  
> -#define pmd_ERROR(e)							\
> -	pr_err("%s:%d: bad pmd %p(%016lx) seen at (%pS)\n",		\
> -	       __FILE__, __LINE__, &(e), pmd_val(e), __builtin_return_address(0))
> -#define pud_ERROR(e)							\
> -	pr_err("%s:%d: bad pud %p(%016lx) seen at (%pS)\n",		\
> -	       __FILE__, __LINE__, &(e), pud_val(e), __builtin_return_address(0))
> -#define pgd_ERROR(e)							\
> -	pr_err("%s:%d: bad pgd %p(%016lx) seen at (%pS)\n",		\
> -	       __FILE__, __LINE__, &(e), pgd_val(e), __builtin_return_address(0))
> -
>  #endif /* !(__ASSEMBLER__) */

Perhaps a bit of a pity to lose the printing of the address of the pxd
that a number of architectures did before this series, but i have no
strong opinion.

Acked-by: Andreas Larsson <andreas@gaisler.com> # sparc

Cheers,
Andreas


