Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A359FF8868
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 09:36:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A1DB6B0088; Tue, 28 Apr 2026 05:36:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 452D16B008A; Tue, 28 Apr 2026 05:36:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F39D6B008C; Tue, 28 Apr 2026 05:36:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1AC9D6B0088
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 05:36:26 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8B5411B9360
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 09:36:25 +0000 (UTC)
X-FDA: 84707459130.06.BB9FDFB
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012014.outbound.protection.outlook.com [52.101.43.14])
	by imf23.hostedemail.com (Postfix) with ESMTP id A1FB2140004
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 09:36:22 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=citrix.com header.s=selector1 header.b=yjaJCj7S;
	spf=pass (imf23.hostedemail.com: domain of andrew.cooper@citrix.com designates 52.101.43.14 as permitted sender) smtp.mailfrom=andrew.cooper@citrix.com;
	dmarc=pass (policy=reject) header.from=citrix.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777368982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mpdOSyAx9rtZPwk8svxWZWLLaqX5YpnW5mDeAwGhp70=;
	b=O7P8lVZfAyz+sIF/La9NlePN0dAOYqn9k/z2mIO0ix1FF3mbNYex2MHETdiKSOY4nBc3pM
	8R8y5zTZzRMuNPS0lLvV4gpztfQ3QG1XhLNBcJzZ5BMt7+CBrd03JLVkKEYPAzkXNKNGPh
	81CkEvXcAsvLdYi1DlptH4B1bdiyzXg=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=citrix.com header.s=selector1 header.b=yjaJCj7S;
	spf=pass (imf23.hostedemail.com: domain of andrew.cooper@citrix.com designates 52.101.43.14 as permitted sender) smtp.mailfrom=andrew.cooper@citrix.com;
	dmarc=pass (policy=reject) header.from=citrix.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777368982; a=rsa-sha256;
	cv=pass;
	b=x2fDraUoR7iHep/adIDea2hNI7iE0oSNtaUC5xa4MYoirpspZOy+bw+Ehw6kdWQ5l48sbX
	maJaMS8ShrL2M1zkb2bDtlKZ0YlBFvtSiO5C/Ddi3adeR5NVm2uli1mgbXxbsrN54f4iCb
	wOiocjxXnlKL+qTNNUe1AlU/kK06/Yo=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ccKCcxHVgqechrGsirY7Hast0tX64WTHNBglbWndvpdSe9VcH9SIFMGkWSRfviVDwFKWm52p0Gg3ZbZFMR8p7xxKqriwmdgnKu79W9VhzOxXa6MymGP2VD8yOYzjgQ6WSTba8ICzTpBcoboYJo/Nx9OKTB8AZLRThl4u2PSmh+FS7d7O7S6mIQlm/5ai5FY6rP+LQwAgAl7vLfveOY1RPpi+hTXq0TuxwaY+17BKuUmD6kQtyYDbQbplsVWn46Mqnwxn4ySEzOU6MxbW6A8D/GC/zLeBarFNuMZ+fptAGpFpIg2FSC1lPqUDLs1kKn2RnvJvb7WzhNiNgFHxg3od+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mpdOSyAx9rtZPwk8svxWZWLLaqX5YpnW5mDeAwGhp70=;
 b=K5DTrABlW49NIkaVt7N0ZYSeIwCDGz95EDNGXbBTiChwAeLow8UU8g+ASwGiDhriB9+juNZ2XFhNNi973guRffj2wGcMeULdKxcmueJevcf2+0ghUtWBeYTVZZfydmMf5B/4yxi73MyAW1iCnI5Sq1JtDYJKPr04neaTQmsWJ0+X22qf5yM1OdCdOR6GRO0/z+1K6oFtrCYv2pUgen/J0sS7JgGNvkpHkXumiUXRbs1le1YmjJbTsJB+/SgjTvkeGB3Bw0kD8ayrIYzmvYcnqzVrZv2xkBTmLIswdPmEIdYMM4jHsJW/46hAA6XVTKP5NzYEOcbmGEIxLT3NW/ZXVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=citrix.com; dmarc=pass action=none header.from=citrix.com;
 dkim=pass header.d=citrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=citrix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mpdOSyAx9rtZPwk8svxWZWLLaqX5YpnW5mDeAwGhp70=;
 b=yjaJCj7S2UVmodB9FLz9FDsi53mVdV80mRkxXiiiIOGoqv3nCUQjFEVJs6h/cyJkE2BD1cgl4gPaC3neNJmde/SwYoZkRlSXSHMRBHqcrsGyZ7kxzP6WQp+7qiiFig8lUcobWLHEmP5+BiwKFg2JHVRXp8ygAPT18ELiHjBE7Co=
Received: from CH8PR03MB8275.namprd03.prod.outlook.com (2603:10b6:610:2b9::7)
 by BL1PR03MB6102.namprd03.prod.outlook.com (2603:10b6:208:31c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Tue, 28 Apr
 2026 09:36:18 +0000
Received: from CH8PR03MB8275.namprd03.prod.outlook.com
 ([fe80::a70d:dc32:bba8:ce37]) by CH8PR03MB8275.namprd03.prod.outlook.com
 ([fe80::a70d:dc32:bba8:ce37%6]) with mapi id 15.20.9846.025; Tue, 28 Apr 2026
 09:36:18 +0000
Message-ID: <82e4eb62-4226-40b6-a1ef-4711f29a5e4f@citrix.com>
Date: Tue, 28 Apr 2026 10:36:09 +0100
User-Agent: Mozilla Thunderbird
Cc: Andrew Cooper <andrew.cooper3@citrix.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 David Laight <david.laight.linux@gmail.com>,
 Thomas Gleixner <tglx@linutronix.de>, linux-alpha@vger.kernel.org,
 Yury Norov <yury.norov@gmail.com>, linux-kernel@vger.kernel.org,
 linux-snps-arc@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
 linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 kvm@vger.kernel.org, linux-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org, sparclinux@vger.kernel.org,
 linux-um@lists.infradead.org, dmaengine@vger.kernel.org,
 linux-efi@vger.kernel.org, linux-fsi@lists.ozlabs.org,
 amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
 intel-gfx@lists.freedesktop.org, linux-wpan@vger.kernel.org,
 netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
 linux-spi@vger.kernel.org, linux-media@vger.kernel.org,
 linux-staging@lists.linux.dev, linux-serial@vger.kernel.org,
 linux-usb@vger.kernel.org, xen-devel@lists.xenproject.org,
 linux-fsdevel@vger.kernel.org, ocfs2-devel@lists.linux.dev,
 bpf@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org,
 linux-x25@vger.kernel.org, rust-for-linux@vger.kernel.org,
 linux-sound@vger.kernel.org, sound-open-firmware@alsa-project.org,
 linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org,
 loongarch@lists.linux.dev, linux-m68k@lists.linux-m68k.org,
 linux-openrisc@vger.kernel.org, linux-parisc@vger.kernel.org,
 linux-sh@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [RFC PATCH v1 2/9] uaccess: Convert INLINE_COPY_{TO/FROM}_USER to
 kconfig and reduce ifdefery
To: Yury Norov <ynorov@nvidia.com>
References: <cover.1777306795.git.chleroy@kernel.org>
 <9fe875d2f55af59c12708336c571a46038528678.1777306795.git.chleroy@kernel.org>
 <ae-tVFVfx72oCC_i@yury> <f54c3c2b-33da-42a0-80b7-0f6615d930ce@citrix.com>
 <ae_LeSk7XDEseaZb@yury>
Content-Language: en-GB
From: Andrew Cooper <andrew.cooper3@citrix.com>
Autocrypt: addr=andrew.cooper3@citrix.com; keydata=
 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
 6+ahAA==
In-Reply-To: <ae_LeSk7XDEseaZb@yury>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PR3P191CA0014.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:102:54::19) To CH8PR03MB8275.namprd03.prod.outlook.com
 (2603:10b6:610:2b9::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH8PR03MB8275:EE_|BL1PR03MB6102:EE_
X-MS-Office365-Filtering-Correlation-Id: 27671459-4f10-4786-8cff-08dea50999ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	Fr2SaARcp/30JjWhQQJ55I1GRZonpmNdylsCWtvAP0iLi3fW8ZUvuFhK0s4B36VBurCZDpfzVPFq6rLx3X1PD1Kz35WTE6S81hlCopCD8pxNfXzddX4/u4dtAvIVV3+dse65UYV54WEPb9m40Wjjn3bHzaqhi5kXQt+QCerhqJvdqH//K3YBfJ3eHu4T502cM87h+5Wk64juS3ow0KcjEOrJiWG8zZtCB1zX/Zx9W+k31hKZWyU5JugE5BecKPv83c14/YMl0NlQo6wFBRUmoTmKu5q+BJ0edgjyC7MNoiJOa062R5+vQdJQm7n67DG6OFhXCui25vN24b+JEFjbMJ8I5gDyS6Pqlh1zGk+tSpPIX5sSTy93SH1THmcafkZxA/zcOtIfBXA5D4BtEZi3z7jrFmLebbEjRBeAZ4mXjOUsa0tdIA0f6ylDW3/kKbCBc2+3QCsGH2auk9QrEoz8Qehl/c2IdC5Jrp1FHy5sbgm1kO91QggdcLgX+7RDBQ1w2WivvacJ5+GA7VwN3eqYcQCchnubiGLOAKifSYUE5mgJ1MtvIP4mVz9MycwuTW1le7C0ze96+eweGDr2GRC7b4Y6Nu/5PUig49u28f0pS10LV8wLIvDRRy/8GhGTlJzQnCP9mRhy1qcYhsiyrYLbGoinMTZRP35bST2/CDKe5vbaqXTn1sWv/Q5t0sltDyceEL5w6qfuHh/xS4aeDEwNDl9teKE1dnyByfr3exuVxtk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH8PR03MB8275.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cXlrSzBLUUNTNVZEWWtHUFh0VWlZYVFER3Ara1hZNkJxcytqVGExRGJseE82?=
 =?utf-8?B?SEdqNitGYmc4eWJsa0daVmNxTm1WUy9xTzNQOFgxMHNDZ0pDWmI2ZkN3eHZJ?=
 =?utf-8?B?N2M5WXZCMDQwNFNFNDR3WFhSTWJwRHM3WEJjVERGSmJyVFNhV0NHbDY3MUw3?=
 =?utf-8?B?QkZ6bXFoK1hTZTRCeXVMT2lYbXEydmZERmxLdkIydXBBNTBuWC9RNkdFVjE1?=
 =?utf-8?B?K2dyZ0tnQXZsemcyMjk3UE5jNXV4alA0WG0wVzMzd3pzRHUrMVlOdSszNXpK?=
 =?utf-8?B?OWpVTmxHdDRZT1JZNzlabTZUY1JhL1hpVDlNZS9OU3p1K0lPeW1VVVoxSWFI?=
 =?utf-8?B?dWlVZXN2MWFTWi9lZ2VsbTVhU29OanU0cHV2L3JNNUxoalZ2NWMyaXFnVmpS?=
 =?utf-8?B?R3NvSVBwY3pPeEZmSTh6MndjQzBDZTFSaDdnd2djTjdqeDF3SlpIVE42blBP?=
 =?utf-8?B?M2sySFFhdElhQ3EySUZHdFNjaU1YbHRhYXNGbmNSWDlGTGpwSUoydkU4S2R5?=
 =?utf-8?B?L0NiMDB2Y0dtQ1BPUCtNTElxeklWUlNna3dybHRwWUVtajA5ejhPbGJOQng5?=
 =?utf-8?B?cHA5ai95K2xBNjlOeUFXdmpieWFWQWttQ01TTGhnRmJmTDVlL0diU1lZK2lm?=
 =?utf-8?B?anlNY1o5SUxPaXdsZGk4RnVyem95Ry9NdWdKT083YnBERHIvQUZETVc2NE9V?=
 =?utf-8?B?bVZYQ085U29MZUpBb1AyMDVuejlBWFRzSTl2NVZlWkE2OCtwUGRXc01HOSt3?=
 =?utf-8?B?NXJyUXZmcEtvRTdUSEZRaXRiRVducUthVmZ1cSs5WUlwVGpMaUF6TjNoc2dL?=
 =?utf-8?B?ck9iQ3VmVXowU09vc1JUMHNieEVUTW1lWFdSeG9QbGZEMDJTaXR1MWRqazhi?=
 =?utf-8?B?d0l2V3dzQzBIV0F6bzg0a250TmttZTZFYkZXZmwxTlFrVEpMUnBNaENqVUpj?=
 =?utf-8?B?VkplZXpWWjR3QThKTDZSaTBvbS9UOCtwYm8zQnlTbVVhbWczMExGdTJWQ1ph?=
 =?utf-8?B?UkhjUEF6djRZYUNDQitzMHM5YkNEaG5OT3htMEl6NWlWU0dYZHNTdm5FYTk5?=
 =?utf-8?B?RDA3Nm9nVW9IeUFTeHJtMTcwUmxFMlhYbmc5V1FwSlZGZmcxK0h5OUwxWXI0?=
 =?utf-8?B?Qk9GbG1EcG85cWhkSUE0aW1IQk5sa0Q3MzZFdGx1UzU2eFhaaThkL3F3eGZu?=
 =?utf-8?B?a0grdGtEckJiLzdBMnV0NUcxLy9BN3V4V0lETi9tYSthUk5NUjduclNDRG9r?=
 =?utf-8?B?ZmFYR1FIOWRNVUVIV1E2dlVONGZVQ0ZBQ2I5MVFvMGlZUDRLTU5rVVc2dzVn?=
 =?utf-8?B?ZmtDREdLYXJDL3JjTnZ2VTkvQlJCZE4rV3VXazBFUlFPQmx4Y3VYb0Z1T01S?=
 =?utf-8?B?VE90SUcwc0RjWXBLcU9lM3MxYWowa25VakxFd1lOMnBSUGltc0JjTWM1aDJP?=
 =?utf-8?B?Y29pQ1dhSTgwZTlPZkhEYXJHdFZLRkszWjBSa1lUK2xhZjBFc1JSMXYwcFVK?=
 =?utf-8?B?M0tKWUZ1ZGUrcEdncXpRazd6UFpib09hb3JIQmVjbEJVSDAvNXgxREI1akxZ?=
 =?utf-8?B?cXFMOGN3TkZjd2RiNkZvMGc2endCM0JwWEJ0T0czZUFBVHorTDhIcGFpVkpX?=
 =?utf-8?B?UHhLd1doQTlwSEl2TGlGd1B1T3YzMkhTUkdLU1pZMkNIVHNiYjJSbjBOTnVa?=
 =?utf-8?B?U3VlU0lWMW90QUJ3K3ZLNTJ6UHF4WmpjWVR3T0xMWWtSUVZlaVdNakRmQ2FK?=
 =?utf-8?B?dlBGQ0h6anRZMGNJSER4UFNjWGFaZnhFbDBrSjNaaEd0RVJhRDNyWjZSNHJK?=
 =?utf-8?B?SXl4Y2hURkhEd3Z5NnN1Zi9TT2tsMlN1T283dVoxUUxYN3JqOVBWWTVsOUhp?=
 =?utf-8?B?c2JNWEtUa3N3bnlTWVdqODk2Z0huV3VYdG9PM2tCV2tuYysyeWY5L1JHYXBJ?=
 =?utf-8?B?Yy9oV1NLMk5Yc1ZER0RNVWxLOWZINEhCV3JmWkxITTlTcEpEQk5Lazk5S2Fm?=
 =?utf-8?B?YU9qN0IzODUreWtZL25RbTdZbEhCMzB2ZzRhejVxTkN5UCtNMUZhNXpZUHJv?=
 =?utf-8?B?c2ZzaHk5c0c2WDdCV0c2ZklENVd1QXJSZERWNGd0MWZGOXVlRFBIbjBCYUVp?=
 =?utf-8?B?c1g5QnRIenRtUExSQ21QRnNQZjZHVDI3NWl4dDZCRHVrRnlsZm5MeUg5Lzhj?=
 =?utf-8?B?WmJrSDdFUmxOYlQrZ1NGRXFDQ1lvSjl3eFpjZ3Nzc21PeVUvK0dCMHVUcDlV?=
 =?utf-8?B?OC9zMjY2TUNrcXhhMGpOVUtBWmdFSXNLWEgyR2s1VEE1djEwRE5PRkFnYUVQ?=
 =?utf-8?B?Yi9Vb29kSWlZMWZ6NVNXU2lLSHh3cUhhVFR4NXU4eGtGZEpGbVpYelYwNFJ5?=
 =?utf-8?Q?ffVmgnSYCsz39lbY=3D?=
X-OriginatorOrg: citrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27671459-4f10-4786-8cff-08dea50999ba
X-MS-Exchange-CrossTenant-AuthSource: CH8PR03MB8275.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2026 09:36:18.6733
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335836de-42ef-43a2-b145-348c2ee9ca5b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8FETUR2bT/yBq230FXCqFNsiU0Ggu57p4Jp697qQVSZUPucNrAQZOGv7iEP1mcxKrRIFdBtpW+GgV17hrhOPkaPlgmSk7r3wIBztNDkjsJk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR03MB6102
X-Stat-Signature: bz9zqpyrkjc81cyjgechtyafwxaf4dm5
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A1FB2140004
X-Rspam-User: 
X-HE-Tag: 1777368982-768930
X-HE-Meta: U2FsdGVkX1+6MbUzXcDfZZfKB4SB70UHMm30NjuYngf6kH3ymp+ob38GZbGHtB1joANNRkhiKFB+eIDLmE32uX82PKJQ/fAZ7DFW2Ddq+PuY2Q0lKrrZnCiLWwlhJNS4WRhaxFBQaO67NB9x5tOwvr5IkFNgkoeKPY4RU69ChRS/copWeFmyRmbMET7/Oy57rkf1Mu+/w53nYy0gXuXjlvn9IFXUik22wnTLw2SBCSojBWWs0obBWkDuLqbAjmJQejqivF2tXC16TRJDJJUgXxh2v4fOuGfIbEDbshQIHPg4UFFYE3HuzQoKDhYgpvEp0RItv7XgjeNoa/YcB+0iYJ4fgvofkQH8iZY6tHNHOEWFv+yNwl+qkTN5kGqARPCMM4EqgFo2SYrq0k+ikWAwFWvad1z0b0muM9yKxaTUzcd5MKDOLoR+aca9sc+fW8ixF/7IpSbbsrxhiPcfAn7hxyuPj7FwAdAkzyrrRxmJUa0ZUEqAfQ56zYTghwisEieMJkWYd0iKxerJZxIFDe57RVT1Mc9PB2h9J1nRQOhT9QjEBCKeOfu0rlTxWPz8fgaBe/6IlCQi6R2XRPY0yfKfZ5qIJneaT/gnl0brk9Pknkix4ebDjZm8TXjA1B/04rICL3PRe+S41MbPH+LxBFPWgB6fR3QBbZQEQ+JCnLyVRh/RZaQs7pYXNAF20WFURW+UXpXDcuMjLMa5XUY8zHuAmj+OXpewcJz4SowA9IyFGkH8zkuQNK6HrAN0P/4y5Dw1zD9au/9RFLu42m5kluCAOcomh4NIwmM5ceBDbkrfpuBE+hCpmT2lTkGksmOg6CoEH65i3TlacZmtI+FkPHPXYpGXbyMiMxsiMBWeZqlcucSYLW5yVsnPMRrOwrqWnsGglALsMKrl8iACgscFx98+87PwBAGsfljHV77hr1XKKM70ov2FzdLTKn8XNyp7+kxd+NvVlzcUqr3wXYcbrrY
 XtGghLuT
 x8b69Vayk8ORO0RyFajnoyDn0odxD6wigcMm1tjJlRGlpo7MidNfwiP77Ie8xeemx9JQL49z0rGGG/obgrRUPFq2nlL5vzzCdGYcbIN0Qk+JVzaMhS5fE6NA9SKikr5L2EOnHi9x1zz63KW32asZTxJfa5PLb24kOQ16kNUEe7KuW1Z1JG5j7DUyWWlX2tdFbJwap8BQT2lgUeUPNQpezhcDACh/5AIamPtndARC4wUayLBIGUt1sHZ6lfcpnK66U4rDHn0DlYUGd51QZLGq/Myd7eoMEPY416O9HUENwoU+kWfp2VXA12sBpVaUA5pGZ3HWq3jMe6Qy1AlBJ3im/L6tqN59fgLjhMaobznmfkX1jrQ6qTGAqpPzTFmNB/HhWnU1NuQqaGOsX7Ve0rGhrERxZNyC/FcGDeQ6LteTZVTBbzcs+LEOndeLKT1leEE3Whc1+rR8BspXwFd6HWzI3iqNeFDsM6YzPp8iEs5aP0UXmFhgObA5SOELXMzmqNrQFDrvnOVY/1NGa8A5pIQx1ybFLiVGRoE5spqM65lJijQMaFp1dLO4WBciJ5cp+8+PJkO9R8QUF1EoPNC86LuN+ScAzh7QUizSZzZ69WUiZSYncV2yFtwFQXZicudZgHlRNe9zfEzJi/P/x6dSNBZ9mLXSpyQibyJDgceu6kCWt74U/xnAvz1di3TvtxWuGrqhgOn2ekoNGL/ufPydhFDfNcfZEJw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27/04/2026 9:47 pm, Yury Norov wrote:
> On Mon, Apr 27, 2026 at 09:39:33PM +0100, Andrew Cooper wrote:
>> On 27/04/2026 7:39 pm, Yury Norov wrote:
>>> On Mon, Apr 27, 2026 at 07:13:43PM +0200, Christophe Leroy (CS GROUP) wrote:
>>>> Among the 21 architectures supported by the kernel, 16 define both
>>>> INLINE_COPY_TO_USER and INLINE_COPY_FROM_USER while the 5 other ones
>>>> don't define any of the two.
>>>>
>>>> To simplify and reduce risk of mistakes, convert them to a single
>>>> kconfig item named CONFIG_ARCH_WANTS_NOINLINE_COPY which will be
>>> We've got a special word for it: outline. Can you name it
>>> CONFIG_OUTLINE_USERCOPY, or similar?
>> You can't swap the "in" for "out" like this.  "out of line" is the
>> opposite of "inline" in this context, while "outline" means something
>> different and unrelated.
> Check KASAN_OUTLINE vs KASAN_INLINE for example

Then I suggest it gets corrected before more examples try to copy this
non-english.

~Andrew

