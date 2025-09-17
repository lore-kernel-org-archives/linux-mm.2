Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A887DCAC5A0
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 16:47:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E41DE8E005E; Wed, 17 Sep 2025 12:47:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E18A08E0002; Wed, 17 Sep 2025 12:47:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D07768E005E; Wed, 17 Sep 2025 12:47:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BEBB08E0002
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 12:47:42 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 751878596F
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 16:47:42 +0000 (UTC)
X-FDA: 83899323564.03.CA61007
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012021.outbound.protection.outlook.com [52.101.48.21])
	by imf13.hostedemail.com (Postfix) with ESMTP id 978322000F
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 16:47:39 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=N0w3m6Zw;
	spf=pass (imf13.hostedemail.com: domain of jgg@nvidia.com designates 52.101.48.21 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758127659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OKHYKAfqScRJyJgTm6DuVwXKlj+lku0G0GAsCsqyuuc=;
	b=SWhoY8HvUEEXu8GY0nJ9rIcOeqi8UhbcfMAb3EE+ueIDlhYQfoADCGw5cs7TZS1+FWaJV6
	teBeu4NPkD8e+mjgTBKPgHHPKzvdXpMSB930BraLfAcyd7nkTxh2G1j07bsmrTIaOIMCR2
	0lB/Mkt2g09U2GdRSQU+2yufV75H+R4=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=N0w3m6Zw;
	spf=pass (imf13.hostedemail.com: domain of jgg@nvidia.com designates 52.101.48.21 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758127659; a=rsa-sha256;
	cv=pass;
	b=duHjHXi/t+7FxkN8CMiJBM3AHJ9k1ASrSFvi3gMtJaBjLhSK5rrmHYeiNzm6dEmrYsXmQQ
	rXGp13aCAZquvqP+W2AYW3Wf0LONPAG2OcmrNo3JGEMzZvnViSAM8SQ5b/mPjzcDLJEzB7
	DK30mhI8NtW6ravJ7b3hY0Q0jrkHDkc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I8IMGtcnAgjkclNEPeSyLMSgwnFT/t0tPbC6N6nPyONWmqsCfLdAQmxEJQXC9xLEXxxJftQsfPVMtVroDFLx8lhDGnQl92pMuJNhgDxeAZEMyE3Z+WYDPbtT5cwJFDLiVCJ092liwP2dkH1N3dHJKO3heGcWUsx5klV+h1pxYmuJU7X8VIh6vINI2uolyc71r5Nox77sFGWNLS4KMhnXi5+4STr/3ku8WzUhhdksUDvLVo53Q77FesCYdpLjrUAQpq5NsCbqXziFJShCvBRdneeG9Iwd+aUBF8RzSl/SEQyyC7N9OinHrIPxUzG7lHsw9u3PNmUQvjvDMuB/isNrQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OKHYKAfqScRJyJgTm6DuVwXKlj+lku0G0GAsCsqyuuc=;
 b=l961PD249CulytHf99DX3JucxIXlS3yLq6Jed72zbPtMsNAjnPtbbWdWEsqk/SM9cGB7+S1V55Fphi9CLqZ98ZS62r3dH7OE+8lk5v8WTg90aWqbtAz/Oc/a6uvgf3fQ8vdJ/rLTfODvKsD6rsIgZYzrmdTubMmV1Q3dx+bk+O/3NTt4E4yMyRKl52vvx/Ch5LcaeqOpO9Qh931vS6VQSEyx+hHogvvRJvzZIT1hqzoXuDge0pEzyexOVLc+rqsWNe097b7uXz9rUT+xEzsT6d6p3MhOKfkTAEmPfv9d0cdgph+tknVNxguAyUwnS5HlHed2Bz0VrMZDI1d5AOpHFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OKHYKAfqScRJyJgTm6DuVwXKlj+lku0G0GAsCsqyuuc=;
 b=N0w3m6Zw/qc4YYXkPpHdP4lUZ3QivHxjE1bPGY4PO6hKWNzoYHlrQk8P3QpjWmyIQB2RrgymP1nDVzYBIXrBpQwV162HTjAvspIRixzOk3loo5RXrZmcZgu+x9nPu8/EOAXHH+vvppK17aP+ezdXVWZ5vxd3YjewBEA6QUsLT/SAvyOFW58OIB2AD3Ahc5eJtv1BX7dhvBUI3z9C7WEJUPcQfLPEtzKDyjQ6KQz0FhGks5QYi2RvxdBooB5fraZWWtvvBni6eKj8QUiJrwUc3A63vBYgjanG64JXJK5mRzE5iHWM+eUiH85X7exuBn9Tk24pxXC35t8j2jQpw5i5mA==
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by SA3PR12MB9092.namprd12.prod.outlook.com (2603:10b6:806:37f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.23; Wed, 17 Sep
 2025 16:47:36 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9115.022; Wed, 17 Sep 2025
 16:47:36 +0000
Date: Wed, 17 Sep 2025 13:47:34 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <linux@weissschuh.net>
Cc: Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Kees Cook <kees@kernel.org>, Eric Biederman <ebiederm@xmission.com>,
	Shuah Khan <shuah@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Andy Lutomirski <luto@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Willy Tarreau <w@1wt.eu>, "Jason A. Donenfeld" <Jason@zx2c4.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	llvm@lists.linux.dev
Subject: Re: [PATCH v2 16/16] selftests: vDSO: vdso_standalone_test_x86:
 Switch to nolibc
Message-ID: <20250917164734.GA2047227@nvidia.com>
References: <20250226-parse_vdso-nolibc-v2-0-28e14e031ed8@linutronix.de>
 <20250226-parse_vdso-nolibc-v2-16-28e14e031ed8@linutronix.de>
 <20250917153209.GA2023406@nvidia.com>
 <1f64966f-ef7a-474a-9641-561b6b7cb0d2@t-8ch.de>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1f64966f-ef7a-474a-9641-561b6b7cb0d2@t-8ch.de>
X-ClientProxiedBy: BN9PR03CA0521.namprd03.prod.outlook.com
 (2603:10b6:408:131::16) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|SA3PR12MB9092:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a08dc1a-79ab-4696-b8e3-08ddf609e79c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?L2hhSHBLZm1Ld0s1c1MwWW90cEdCNThXOHU1T3FSTnN1cTFPbVNZbXdmWHIy?=
 =?utf-8?B?VGMyWnh6ZVNSU2wrR0srSGpSRkZhem9COVhYM2tPTFFpV3dLZVIzb3ZkdG1u?=
 =?utf-8?B?YVJWb3ROeGs2WElabjZVSkFoNUV6cUdRS2Vod2tJZ2l0ZDA0YVlMSlNzbkVD?=
 =?utf-8?B?MWIrdnBqRFFWR2xWUHpSeW14dHl0R2wxRVk3LzVJZXo2dGtiNWZTVTY2d0ZD?=
 =?utf-8?B?QlorTG5aRGViQW5Db2J5NmNmNlYrRFArbnlUbGoxdGVOMmYwTEIrU01Sdi90?=
 =?utf-8?B?YXVqZXczcGNtK2ZnUTZYSzZDWmpxZEJJY2x2V0ZteGMya3ZkNEhCRm9LakhS?=
 =?utf-8?B?RC9aNG5MZStibzZ5bGkxNWpPaUtVNlpuVlY4bU9LVXIydTJTSFdDL0hqb2Jx?=
 =?utf-8?B?QnFZTTJXeEJWd1BKRnhkYjZDQk5CY1Zld3VFZmgrZHo1ZGU4ODYrYkx0K3k1?=
 =?utf-8?B?cVpwMkNHNjJTdGR1dWlyNjEzZC8yMGNUaytFaXc3ZHFvUmtYbUpGaTAxcnRC?=
 =?utf-8?B?N3VhanMvM0daK0UxaFBueXdRb0trd2pEb2dOQ1ZtdFRKZDJBRUtZTlJpM3V3?=
 =?utf-8?B?K1J2N1F3cnBnSlN2OVhWd3dGcTJYNHVRbTBPcVlNeEI3eXlQNGtWa1Y0cjYw?=
 =?utf-8?B?NjB2MFpmNDJncGpWOFZOSWhuTVkrY3g0T3B3UWR3Mm1JYmdwUGNsclZtN1Ru?=
 =?utf-8?B?VzZLbWovSFNZekRHQzA2UkcxcEhZSWsrcDFSRnZwSU9QdFlOM0gwemRTVEhJ?=
 =?utf-8?B?TTFENHduczYwTmVOc1NralJBNHE1UHdWaUFVMHh4cFp4MUlvcnBsM1FRTVhk?=
 =?utf-8?B?S2tod0dZTW9XclI4cGNYbnhBSGtvZXlYSHo3NFZoQTQzUTRBOVpRcVFzSHh1?=
 =?utf-8?B?TlBiMnIvMlRlQ2pNdDJpLzNFRTZUbzRsQXA3RWMwamxmRHlDMnIzRUlwZEI4?=
 =?utf-8?B?OSsvR0dVRWdHRWxvVElCVGVMNldvektDU1J3UDJndnZCN3VjMUQ0L3Q1cVJu?=
 =?utf-8?B?OTdXRlZyWU05NHNmd3ZVR3ZIbWc5NFZmQ2RWbnBDVXprWXlySk5CU3ZtaTg1?=
 =?utf-8?B?cVNkbDdWMXRBK0puTVFSaHFUWG0zOXU3UzFXbG1uMjYxdlpqY1Vvc0dBV2NH?=
 =?utf-8?B?OWZWbStNMmdxYkZQQXdLSlF6T1FFRWErSmZaR0QvQnlyeWtyUUNscDFaZURa?=
 =?utf-8?B?Szgray90WmFGaGt0dk16dEdDT0hoWEVxeHFzTklmSXRiL3Y5L3B5ckk4c1lH?=
 =?utf-8?B?OCtVbUxGSDRQQkxDNDBIRWJ0T1l6SE83T080dWZ4VFFrbk56MHphOUFUcjRD?=
 =?utf-8?B?TTZ4RzUydENXazZkTUpQT2x5NExXdDdTN1RBU3Z6VEgzQ2FsWXQyYzFEd0FU?=
 =?utf-8?B?ZXo5ZDREeTZIc2FDc3VWdi9kNGtWbTBJc284bnllNXBhbjdyRDBPZWF3UFdt?=
 =?utf-8?B?QXh0RjNDZ1U3dEZKVmY2UUE5TDVhelZEQnFML1lOMFRxTVFEN0IxM2xPS1VJ?=
 =?utf-8?B?N1lkM2NObWMxMTlKT3loQUltMGhhYldiUnd0Z3A5bFRlSmIyMlI4YzBCVGhI?=
 =?utf-8?B?K3FpN3dTVWliZnIwZzB3ZlRvRm5ZT0Iwd1E0YnJNUTI3ZW5mdHNnMHRSNDZs?=
 =?utf-8?B?Y3R0ZC9xQ2V5WE1Yb2pQZ2lGUjhXRUU3dXZTa3hlaTZidXVxMlVwWDFaZjQz?=
 =?utf-8?B?NGtkQzIrclU2VG1hK0Z3eloxaU9yeEtoOEx2WEhkT3g0QTdmOXNwbnlYRy8y?=
 =?utf-8?B?R2hiQmNyUHlzQjRUV1pINWRlTWdDNkF5SHVYczBwdVQyZUlNeHF3ckNyeGxj?=
 =?utf-8?B?RUhhL2RQSTZyem11QkM5S0tqa0ZrWi9vTVBFaC9JSENPa0UzVm1tRHRPQkxX?=
 =?utf-8?B?aTdyWklBUUlyUU1LMWtJN2ZvWnQwSk1pcTZaV1Y5M09aUkxSdUw0cldwN3Mv?=
 =?utf-8?Q?EFn3PHIgiLU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?akVKd2lMN1U3T1U4RVBUVFdMK1BVUFlLdHZlbHRQNStWdDk1K2F1cVAyV2t6?=
 =?utf-8?B?Yi9YbStrSTNEU3Z6THdEV2wzVnlkSWN1OGh1OVAyZG5iWE1TUHBZS214d3F2?=
 =?utf-8?B?UE5ZN0ZaYlAvWlA0RFVHQVY1TC8ycVR3Z0NLemYrZWozSFM2TWNHcGZWb3dT?=
 =?utf-8?B?ZDRiQTFKVERCaU1YRXNwVFQvdkVwd1FzWlYzM3l6dXBIRkFpd3dicEpyVGRa?=
 =?utf-8?B?RWlQckdVdjQwRDUrdi9KTDR6UGoxUnYrSFlseXZBU1dxckJ2UEt1dDRDNEVm?=
 =?utf-8?B?aktxa3ZFZ1dVMGU5dVJGeCtKZ1pubkhIZnMxa3ZtV3VFVkVxakVRcjNIMkVr?=
 =?utf-8?B?ell6c0ZjdjhKUzRZdGVRMTFRdytDOGhwY2Fram5iY3hxTFZXd005bmpXSlhj?=
 =?utf-8?B?L0U3SE1EMXVuQ044cHllY0JNOGErZG85UmJaRjJ2Vi9BNWRDZklzcThBb3BO?=
 =?utf-8?B?YWJ3eFc3OTI0eGhNVjRuMXFrZWo3ZDZmQWVUeVdsem9NbjBEMTdLalh4Q0Vv?=
 =?utf-8?B?ZURnQUd3Ni9neklmOFpSc3ZKMHkxbVpwRzJ5MWV0NmR4Q0dqVFJBSVBhaTE4?=
 =?utf-8?B?ZU1MTU5BUlJ6M3IwNk1wekVwQmwvWC83SEtiUGljd3N6Nk1pS2tXM2hGQkZw?=
 =?utf-8?B?V1YwbmdGb2lLWjMzS0VndGZYTXZ5UGhwdWlCNEJxSU16bjdEczgzTURBSDc2?=
 =?utf-8?B?TWpNTDJ2dHlVM28vTEcrMFBIQkttd2pndWV6bHJua2tyVkNTN0Q2dGNwVkVh?=
 =?utf-8?B?V2hPSXRaODJ0cHpyYWdZR0lxUlZFVmpUcEtSaEFIazRNbjNXVkRDK0FCc1Ra?=
 =?utf-8?B?ZE5FN3hFNzVKS2FiSFE4dThQQndCVzZsSFAycmFSd3kzcE5hQzRwSitZSGdm?=
 =?utf-8?B?djBoaHNGYVc5aHJLTzBSSEFmZmdNeGgzaFB4RGtGSXBKV2h3MXVYcG1NQUNX?=
 =?utf-8?B?aWMxWnVnRXNIellHMHovemRoMkx6cHhPWUxiMXZUeXM1OXBXY21LQ2xvYjBL?=
 =?utf-8?B?OVE5V1Vram85WG5sZ25CTVZ0L1dXVTdqd2ViOFdLSGQ1TDl3T1pteG9pdDNo?=
 =?utf-8?B?N0NnY1FCUHQvL3dQNkl6MU5SaEhSZUluMFZvK3ZjYnF4ZkZLSDdhWFdidTV1?=
 =?utf-8?B?Y0k1T2phWVRwUVdETy9NUDJYY3RpSWZuSWNPZmtsNEFhLzRiZ0xDdi81WHRR?=
 =?utf-8?B?SUwveFBSZnBtSFRnQS9HV3VOZmV6QWNoNlFILzRmU1hWWTQ4bzRwenlWRjRr?=
 =?utf-8?B?VHVBSENDL21UcGFYdEo2SWZTaDd2cCt4VDhkcXNlRENXZkU0YUt0SjU5KzJt?=
 =?utf-8?B?L3VJNVJkQ2JvODFUaml1VmZTeXRiZVNrYlQralhkejZJNDFXK0lxcGg1cEt1?=
 =?utf-8?B?N1JoMHgvb2hJQUxBYTg0Z09qWnZVZ3ViVDE3eU1YSENOUDBPWVk1a3VBZis1?=
 =?utf-8?B?VzNWbk9VQ1RjL05tSkZPZFlVVEUyUFNNUkRBUC9wK0JOSnM1K1crNkkrZTVs?=
 =?utf-8?B?aUpMYzVCOW03YlgwaFBXN0czZ0l0UU9LOEhVQTdodmFFV1czTllkaVVtQnR2?=
 =?utf-8?B?Zk0yNGJHNmNLWU52aVMvTWNnRi9TRFFtUmZvY0ZmUzZwY1VVcWp2eGVXWVA4?=
 =?utf-8?B?c1BBczZyQ2REMS9IR1RZMm5DaExOei9XSnRmNVNPelAycms4aEp5TXBaZzEv?=
 =?utf-8?B?Um13OWt0NkppZjRkd1h4d0VlWHF1WUFyQ2NYeE5DVDB6bFk2VnBYU1VxeU1E?=
 =?utf-8?B?aEVXSjZSZDlhSkpUdkhpUERRVUdvcDdjYWY0ZFlNTXFvbDdPdDNERW9mUngw?=
 =?utf-8?B?NlBsanExSHZ5R251bHhzMnA1WXd0dEJySmdWUkY3RVZ2ZVVRNUFjSUZjTWVZ?=
 =?utf-8?B?OXlTS05PNmRBbXcyZTN5RVQvNzVBOWp6TThwRnVhVHNzZGl0eWJIbExNWGVs?=
 =?utf-8?B?d3FXR0ExaG1LMmdoeWJvb0FaZ3RUVjhlTnZtMkVIZXBkZ3VsLzNlOVE2bmRL?=
 =?utf-8?B?U0Z5NDVITWJXNWN4dDllNmJrRk5RdjhtbmRoaHNCTzZJRGF5MTVnL1NBb2ov?=
 =?utf-8?B?VUZEQlRTT1UyNXJkQ1dlR25HOUNEeWpDbzRscFBKZDBMVktZK0k3YnVJTjd5?=
 =?utf-8?Q?Vp/AuTmQJAhRBCpVrS/x7VKI1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a08dc1a-79ab-4696-b8e3-08ddf609e79c
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2025 16:47:35.9494
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eJFL1IDqFQiCJidNFfWiqR5h8yjvG3ya/IjgcCJr+JwLHA8JYFcr5z321IFDNak2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB9092
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 978322000F
X-Stat-Signature: kih41n1wbtr79azx51e5bzdr9nf8wx5d
X-HE-Tag: 1758127659-725712
X-HE-Meta: U2FsdGVkX19ZSK3FlpDjzthj9dYA0kTyCljuR2s8+DfMyp/pBncY7EinTXaACPLLZ0INEuXRd8TRjrAHoGEOtk2pQJVeJxnXKuBKlyEnY8LynXP7qAM0l63OpQSybzVT0y2MQDU2HlYglzq8Otlp4GVMx3MWU1VD22ih4iXNcsisflArjE2b+dik7oBGppHPU6JyE/8nPfHtxInCPjPuPPmFFgsDW7lcI0CagDXunWqfyPh0hdHkONRFtE3vkdKnFQfZujs3qC96T+4mEiX1kesZXWmLjtNbpAxShQLzlV9vvn/qMwlW4yO1UsTLLrpNO7q8tV+/vMip9JCh2A+uxo6UVP0lXC/YEPjm53QYSV4R3hUVNo18yMF00x3TfnoxbS+uZbZyds65tJOfhXury+18zj2ICW7q1jVcKa4jMU6flwC+ulxVT4JlhXbcUI1lySPguDQZjNRbawErODVghxtheQF2+Kp+vInXpp1g8vrQOYZvGNra2NGkKSImw3qLp5k5OFake4CRipYA2dFugSGybp1qi8XvmiM9VPRWg1dFGxcmiOqJmhvzb4gnbbUf7utjj6tks1RwWgwiJmRlN+4akdglvo7wl6gAsuPr8IItahRFCWTk2X5mKFyGdF8cXI7EMISX+ucXdxxFFkxjF3bS7KrxWLX+W3YozkSdCoUwxlm1YsCkzF7s+8JNR5zH/yZtS5pfxBfSGiYfpHMXl+TQ0X9IiYazSILzzDaYHmSjzzXjNvTT2RJLu5gc+3wT6Y8Z5VR9hCcBmftPIMV4enotLL+tfXvC1X4JvQb8ekKPSM6gnML+jhmvHzhER1yCibAVNoriJyNufHOOgkTr7UaS/RUZeK4A5Q9Mqw1uatYDbEmCQEJOQC2S7/RXX8jZv5dPxdwybBhM31dTuNUqNAvKdF2sJHG51hzVbsP3Ekf8YR1bNYB7STVc55rU5ZVpwzvgdc+9ZvlrErftTmx
 IJIGe8gR
 j5PrGc2pPMqTMVVh4WcUjQWO9714Bm0DTgcV87K7p9e5EREsWAX8I6EdZ8AOyacEJWsUUshCJRGKWgnOgz6UViq3UyhDH+0s6r0viIBkXsv2YwXqrmdXdmsqNGgVNjnE9gxa+IkrVEBiKnWgRhsVQhJRWJQCpxm8pvCgvaQqsj+UYsAR9/Kf5AvKoSHrYTuOaCDfNQ1fMQ+UwQ6V2QV+8Lw1R0aqtCVCX00Wypdq9+j9JokGJDRtlULajp9+FwbQYIeVeJoSuyeXQ7a1M+GOnrDsmhuqV2L0cqPbPI2W0YLQQcRw9jVunivqVCOdPKVVvxP4i3bKlt1i4pNly99i2WMmc+tnLehjLbVW3EX75GB2mh0BaZoABjm/dpV9oafHYesznXA6Wr5hcnVibt7PxOaX+7Yw5leqB89QptFayjDLFqNjs3uIUx2jOISUZxedlDuVhyWYT2EWr+3ennzTkJcjhuILHNhSNQ+mNtJSt6lqChWaGMjG3aHFBAACmBcIC+dUQM5X7MNh+GTbxdwWZhTd02LUmheEbJUczMT8w5nUhuRt+JWPsEKy7IPEhhkbgfU5TqHKEUcrmrpnBa5zYc/UxlNYydm9gkJr4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 06:24:13PM +0200, Thomas Weißschuh wrote:
> Care to try this:
> 
> diff --git a/tools/testing/selftests/lib.mk b/tools/testing/selftests/lib.mk
> index 530390033929..a448fae57831 100644
> --- a/tools/testing/selftests/lib.mk
> +++ b/tools/testing/selftests/lib.mk
> @@ -228,7 +228,10 @@ $(OUTPUT)/%:%.S
>         $(LINK.S) $^ $(LDLIBS) -o $@
>  endif
> 
> +# Extract the expected header directory
> +khdr_output := $(patsubst %/usr/include,%,$(filter %/usr/include,$(KHDR_INCLUDES)))
> +
>  headers:
> -       $(Q)$(MAKE) -C $(top_srcdir) headers
> +       $(Q)$(MAKE) -f $(top_srcdir)/Makefile -C $(khdr_output) headers
> 
>  .PHONY: run_tests all clean install emit_tests gen_mods_dir clean_mods_dir headers

Worked for me, thanks!

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Though I notice it still spews stuff out of the build directory:

tools/testing/selftests/mm/local_config.h
tools/testing/selftests/mm/local_config.mk
tools/testing/selftests/net/rds/include.sh
tools/testing/selftests/prctl/disable-tsc-ctxt-sw-stress-test
tools/testing/selftests/prctl/disable-tsc-on-off-stress-test
tools/testing/selftests/prctl/disable-tsc-test
tools/testing/selftests/prctl/set-anon-vma-name-test
tools/testing/selftests/prctl/set-process-name
tools/testing/selftests/uevent/uevent_filtering

It is not related to this

Jason

