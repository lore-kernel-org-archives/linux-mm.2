Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1245CAC5AA
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 02:41:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E08118E0016; Mon, 22 Sep 2025 22:41:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDF088E0001; Mon, 22 Sep 2025 22:41:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA6BB8E0016; Mon, 22 Sep 2025 22:41:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B3A938E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 22:41:43 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4FB52B7273
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 02:41:43 +0000 (UTC)
X-FDA: 83918964486.19.C0AB9A4
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010013.outbound.protection.outlook.com [52.101.201.13])
	by imf27.hostedemail.com (Postfix) with ESMTP id A9CCA4000A
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 02:41:40 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=WqMHDBTp;
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.13 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758595300;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2EzgqE44iiTJ0VbT5ezQKXyj3ljz/YYHQwbuXl4DDKw=;
	b=c/+x/qsgkUVRFl88whlm56rWXhiGkN7sNuNel/hFdLVTxoEXyKa+qQI+f+IQpYGAYFSB7F
	hh22TfeOZ7oPQLncUjfjVSF8Zkozc4CTiI1JYXXKcsqS/iX+MHDn/ONRio7cREWitMoJkG
	FV7wgRUbCnQBg77A9bjwS4EZay7A5IY=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758595300; a=rsa-sha256;
	cv=pass;
	b=gRXcwsng1bhVo2CxR8ZSfwh909hS+Eayhz2l36RhiNSIWQnQWSrzLVdV2l1iH630c789ZK
	6eyQpQf+VEuSOCfoMSKF3Dqw36UGBayc5Z8nSMHMmq7va3TM3vdkLgplwLqCWvab46YXks
	yFw05z1GkkNQaEGEeREhAuMup/iafro=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=WqMHDBTp;
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.13 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eM9vTlyzB/mr3wr+OtQOgj4CuhSYMs12RBZ2HH8Mz+h9sO08+V8ldS2Nz9JmmSBeKrcLUE2kMFI+3Tw21IG8Cg/AAT7zc2ypLOdUYuwJsLAni26V7/r5xyVl5Is9/iczOcdPcSkKboK3G7lTr9NdEPHyNXWhPGGDMkadYyGn/571ojDhlPUYuDrbxoc8gkscb5tOGrQ6icQ5uZRfjhfMHpD2OGdHC3x/QNN8/kgzhOoq22s8YDJgF3wmhsEIiYY3Cy9UWb7BOvb+ayNvUGZFPlL2j9soBj2EokUBTmV0WiKFcU1+sq9nNHQOFbZsg/JblP7RoKwi6ICv0TMCUpcL+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2EzgqE44iiTJ0VbT5ezQKXyj3ljz/YYHQwbuXl4DDKw=;
 b=gIDE2bzkyhUzLPyEOEPMrXIaj2v4hPQ7QVzP117cEvmxf4qIJG68putxRSZyamactiiw5eYrA7Nd2EVY8BfUGnoSXdKxwbFydzH6ciF5YLFctVx35y1EFvO9ETQhxDPm9BhEEiYKg8qkyC2M7QleyzhCqBgzciBOx4hSvLdU42K/muoP9UWkq4LpNVF36cHRTOzEAH5EmPkDH13nHv+iWrpNZ0Q41EXnfAG0YqiittCjzldE6Bdo4fke0UKAQUr3LkW4N9ehjqVVoNG4jLte0kPhQrGbseobM9YWZp6KCuoI7bGSsbPUfSXmz0aXlY0U/6BE8dM490skeBHzWWzssw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2EzgqE44iiTJ0VbT5ezQKXyj3ljz/YYHQwbuXl4DDKw=;
 b=WqMHDBTph9K58ibh2PTPHdbJiPwQYFnbhFCOIFQiFaVveDLMT+RaC9n+3M7sB5zamxa0YDlBLKXpQ+BhswA2uA2KAIMEACR8Al/xCqxdIU5eptV/EHJXUdHCTiWd3PRzCU/+JJSjP+ETcPPQlo69OBkh+uMHQ8cTsOoi9maxZqa3U4qXWJtqLsa4F2pkXRgVwAOk0LvEH1VpCwHVNqXaTf+KUmT9cXO1sMt3v7KOu1R2v4vJvTb2m9JWj49gCWtW3L/6N4PwnbLWlc0YNtLOqQ5PJv8NV8RoHzjHtz2/RvAqVQ4Cd1L0Dua2yS2U2Cpu11J6VAJISJ/rONRR6s90EQ==
Received: from BL4PR12MB9478.namprd12.prod.outlook.com (2603:10b6:208:58e::9)
 by PH8PR12MB7373.namprd12.prod.outlook.com (2603:10b6:510:217::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.14; Tue, 23 Sep
 2025 02:41:37 +0000
Received: from BL4PR12MB9478.namprd12.prod.outlook.com
 ([fe80::b90:212f:996:6eb9]) by BL4PR12MB9478.namprd12.prod.outlook.com
 ([fe80::b90:212f:996:6eb9%4]) with mapi id 15.20.9137.018; Tue, 23 Sep 2025
 02:41:37 +0000
From: Zi Yan <ziy@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wei Yang <richard.weiyang@gmail.com>,
 "Vishal Moola (Oracle)" <vishal.moola@gmail.com>, vbabka@suse.cz,
 surenb@google.com, mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
 wangkefeng.wang@huawei.com, linux-mm@kvack.org,
 Oscar Salvador <osalvador@suse.de>
Subject: Re: [PATCH] mm/compaction: fix low_pfn advance on isolating hugetlb
Date: Mon, 22 Sep 2025 22:41:36 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <4F4C0F1A-8876-4C32-A245-22703466FF38@nvidia.com>
In-Reply-To: <20250922193533.dd6081d78e9e98f47fdf8d3d@linux-foundation.org>
References: <20250910092240.3981-1-richard.weiyang@gmail.com>
 <20250911012521.4p7kmxv46kwz5fz5@master>
 <5F7DCC9D-4CA2-4BA2-9EA8-F04C3883E289@nvidia.com>
 <20250911032751.khtgvdhcqzyf3rgr@master>
 <3DE28F4B-ACB1-468F-89B9-D7750D24BE4E@nvidia.com> <aMMGbPX9uUj7TfoG@fedora>
 <20250912010721.zd67xbfdava2u26e@master>
 <ED7450E4-51F9-4749-A74E-C3AE8927E577@nvidia.com>
 <20250913001034.wt3iw4nyrmldblhg@master>
 <20250922193533.dd6081d78e9e98f47fdf8d3d@linux-foundation.org>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN2PR14CA0029.namprd14.prod.outlook.com
 (2603:10b6:208:23e::34) To BL4PR12MB9478.namprd12.prod.outlook.com
 (2603:10b6:208:58e::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR12MB9478:EE_|PH8PR12MB7373:EE_
X-MS-Office365-Filtering-Correlation-Id: b2fb99d7-264e-4f6c-cc5c-08ddfa4ab77c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?dvny2UJTHH2GizU+0gqgeSsFNSthB1p33MD7nDciuCpPw+/q/HTrEVI48OmK?=
 =?us-ascii?Q?IvARK4AdlrznuXYIicWxXAS1A9Yngwz5CILRqPe7Rj2MDEhJe/7QGqDYoTtS?=
 =?us-ascii?Q?svZoHvg0r20JtqusqXY3gBMgcZ+Ts0AyvvnY5Uli+UkCs/hHqF0w2QwTgt7B?=
 =?us-ascii?Q?GlkF9tC0yS4hPV4zlQe/roM8MN122bj61aaoY4cynaV+TXeRQ3MkxcXQObg7?=
 =?us-ascii?Q?juFCOjLSGVLaA/gG5Xg8wy2iYASCHe1dk8IMdJXzNZThGx635iHY15zqygpa?=
 =?us-ascii?Q?pfPuZsDVbkvV5vE5jRPFgmgMrRzi8mQpYiGAiJeHO9S4mXOyGt9uTG65RJGR?=
 =?us-ascii?Q?5MI6cOppGwMKhcWVaB1misLwXpR1DhglSrDVPZhluXWSYmxi3/JKiJ9rp0Gz?=
 =?us-ascii?Q?KrVXu1M+lGUICO0d40m3d6SXIKDxGomzWVAnxdjjYSUF79TVXlXYccDUOSle?=
 =?us-ascii?Q?qFUh6lu8LlsRb1L/QNbLtJz2Ar9m6s6BUnyE15l9168fLt6xK7LRqTC5/F8k?=
 =?us-ascii?Q?v/Zg9YF9x1Z7GBy+82KGuKFhNhQtA8DvB+Kcqf7PyrbFTuyp3TVyVJSm/d1B?=
 =?us-ascii?Q?KnvGQv5tav/+Rdi71rvKzud+OWPPp9G4gX+TmBaa2rx1YIyvC0068CA+GGGz?=
 =?us-ascii?Q?4S9KilyvFJO91XE5Fl04NFxaW2b81i98WRN3tuGdswX0EOu0kWk/Eq+ZK+XB?=
 =?us-ascii?Q?Dor6GCAD03/ddtpDEUaki1f2qLdkR6igdLsdPmfnFaeVWxTWXyNCqrbsttcq?=
 =?us-ascii?Q?J05GYUaWGhuvJZzM6SoCAqsGzr3rjDsxFWLCyzKSfS0S1BJf2Nzwj9LmT1n/?=
 =?us-ascii?Q?BSKM84DdfPiNzARWllOSx7TkGIx3t4gHEO2r6iMqrc7GyJVMogqLBraQR+ej?=
 =?us-ascii?Q?iovXAaPWW0jWXea9Fd2MstnCqJEnVctdjrD8jH9G7+TkOM+YNjvduojv8DuT?=
 =?us-ascii?Q?+6l1CBMEArgGLkxbWroXHeduh6U2ivvPmYOtNa36t2uHDUfPzm9CK3g38XIQ?=
 =?us-ascii?Q?JAyKYJ9JEDo9nLfx/l2kIw/Ba1zMA8Zz2wDMWnJ8dAodsnAyQazmn+W7Inne?=
 =?us-ascii?Q?d1UyZZEEArrXkKZUODzCf2GIXXG6N3Rd2coWFYKnr4ms47aEDJMWh0QRo6EJ?=
 =?us-ascii?Q?dVVcUEw7UeF6Hu16ILWYiZ6EkjjlWYoWQrZxDiR9DSrQys/rTEDUCD4QxwKD?=
 =?us-ascii?Q?R/XUmTrIVvyL4CD+fJXL/Hvv82thk3Hh/R2QQbK7TRNs7cmSxn6ozZy/r1o9?=
 =?us-ascii?Q?LqFGs8zIZxa4MDJN4NEpYD/PMI4Myhjod4HNEOJgrf/Zwm6COjbYUdaHmPZ+?=
 =?us-ascii?Q?Qm69zDm5OgxoHxFntvQAc/6L4CcEuPFJuYTL4Bnig1RAY6vn2A0Qw0z3mwnP?=
 =?us-ascii?Q?LYuaOLEkEBP9/przkcO9ctnaXBk9pslimH3oEup5eT1Weo+58D8J+TyvsCjG?=
 =?us-ascii?Q?bZU1QKoEPrk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR12MB9478.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?SvO/xGrwXIaFwIi6l2ijGrd5pjicxnRNnV/+VrTxFDO8GejqNeIfUPy8qfOx?=
 =?us-ascii?Q?U2qOW8CQU6JDVM+hUWUJfUctXSFUIAfmgRW/QPI/K+zPm2UT70qUn5eNf0Ic?=
 =?us-ascii?Q?s8aBBnwkFxfWggQkVuWVwhVA21eklFI0fCaUKh77+5bGjqDK+HxNBanFLMex?=
 =?us-ascii?Q?toZqfZcVZkKA917v4D6LFzcbYkhFDEmGR1cjnf+P3K8o3PzbtuKW/c6jeZWQ?=
 =?us-ascii?Q?tj4Mjo+16EmwEzlEmEB8g8MknPAkSLH7ARkVHGJUMZw+HuwPr/GT8mVgC9AO?=
 =?us-ascii?Q?/iE1VMJb591C7zPH6qWOMErJqE67bf5toPwfgTLRgPoiOoET8TsM58bNqiKR?=
 =?us-ascii?Q?ynOBv3LzR9BGDhwvNz4MOxV0fKGk/Yy4SIn3uHvLXBYAcc4tsIr8XsXCxfxf?=
 =?us-ascii?Q?BIQjD60jK/+NOk1/HJ9KZaMrIk9mHNpCY6Fnz76/UsbDIjYrfRfbHOxqIQRF?=
 =?us-ascii?Q?Q4iPUxrWOTE8qD0sRo1SdMG797VcJq/ktrmEkCQuP/hUB7hf+0hMRBi2HJEA?=
 =?us-ascii?Q?GxciqgiYywq//d0N0RMuPrCWLocR8OiJe3uTzLvxDvo8g0lh1YVWfNAZCrBj?=
 =?us-ascii?Q?FfLMAJh9oxY2Tgmn39c0Z7/x0Wn8m0yiUxQ5JrHTm+CCtK/BApZNhMNEoLzR?=
 =?us-ascii?Q?0gn+fdl2kgCwNj0EJxKvYx8HWUk1rbN5X3l43uGF2ybLOnzNADZbZzLZcxDO?=
 =?us-ascii?Q?1ba0aJk3RMv6xeLv0Gl+zsb6rv0hhJ3oXd6DMrvKQoqJxJE/ZIVpbfNsr9Dk?=
 =?us-ascii?Q?E1GORLhLLtQwEP8UqQUUUmqCTtfS88bBrx1RkmvKG1DAoJ+OJUHdOi+rCLC1?=
 =?us-ascii?Q?rdQ1Tp0zRURaz2bOplFryo7jEhZE1k5C68Q+oqkujtdGtBGcte3sRLWVyEV9?=
 =?us-ascii?Q?VnHt0hxUaIbzylHlNgN377MWN4BFmffF+PAne+z5o6wRlszmI03G28YEaEsQ?=
 =?us-ascii?Q?ceJuZiMCVmZem5IGbBHxqHejPXHi3oCvsHQy+oHztBhmVQagbHnDEDvt+YPG?=
 =?us-ascii?Q?zakQ77CPTgJxCcCMlYlJU9T8UV4RCDAXMi7lHwdHAclkbn7eMPJ8DJP/lbG0?=
 =?us-ascii?Q?4y+ST1nztIWdz4VoJm1VfSLbg3pL0xUAEASZE9+r4OHowRGsed7F6JyyCY2t?=
 =?us-ascii?Q?L6JaDRAhqKlUR2COpHJrD8gyJVEngUwxBogHP5d5fhFTj18Xt7QPWwZhPGtE?=
 =?us-ascii?Q?R7plHJDdGMCahGjURNbBeYhEk8NfGk0vW3Noq+g+sgotmNOelykyrHrYmGYd?=
 =?us-ascii?Q?kYiw07rdoRP23MikHhIqWDQpqQPAmVSzzjHE/7aolHLyqF20MWBPZBAo5CmW?=
 =?us-ascii?Q?Mnt+BEK4aIMVj71aTx7FQHmSGeqio3UQww5kmrSKQwa6CCjOsxIvuwKV9x44?=
 =?us-ascii?Q?olQ2ORVuH0N4Pf/R6wMGFaofUd3eTx2lpOJVj4qsRzcOsfXGQwBi+7vOCOUu?=
 =?us-ascii?Q?28Opu3X5u4mkwPn/BA1DrT45c4a6Tt9RZIjInAVjSeW8j7gJm8WROCUdaOcY?=
 =?us-ascii?Q?6wmRIuSBK2MnIzCuOuqXcILlUAVKs55ptb0uj1+/30O3jeFqcXLU29+9BAc4?=
 =?us-ascii?Q?LPmnlG51HAOW6RNfdiglzjU5bAVBEXnWjF6Al/zM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2fb99d7-264e-4f6c-cc5c-08ddfa4ab77c
X-MS-Exchange-CrossTenant-AuthSource: BL4PR12MB9478.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2025 02:41:37.0491
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rUq4Im5Yhrd5yBf5i3CdBJ5Y8/0Pec/ZCoy51/MF97Vwm2w8nNpasUW5HrbfSdcu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7373
X-Stat-Signature: xhab3p8b1reo7k459fukxy136tfu6c8p
X-Rspam-User: 
X-Rspamd-Queue-Id: A9CCA4000A
X-Rspamd-Server: rspam10
X-HE-Tag: 1758595300-394307
X-HE-Meta: U2FsdGVkX18cmb5MqMi6YYhS/sFML8IrpPay1DyxpJoKHs12aGf0/ZUIiXOkLg7k3e/JQUGtxAUguFtjzY49TIBEKb/aaaA/C6+MWp0kXZyxNlFp90tXpsMsdXSipYnSZU0JD1RPAb/Nkr+V7Efi7cnBg29o7XT7CK0RWcklRltBY8mzlOETQX4QTxtzaeklqmXEVFzvDrkWixfaW4x3h9svAaG6aVadacwc8sWhsdOKrn/BPmwJd9UXj2+E95ogZuIRrFQ+zEO14A37+1ezKQ2WlPx85vT989ioIn/uCUNqufiyGhdN7NYENHulWTRSW6tf8ftTdg3MS44K3OOw+N8rYG8ZYj5JehfEQ5dcAEVAFAQb4is/dBv/K09dSAIiPG2H7PHINMtwM60DNsZwWtXI6RMWxtmJzsg/FiLLWVnuhKIsM05uTd4XW9JB4NmHCyMubp3tqn4suTUGCOHAXgJxcw7JdPu43qY8lcc2+rVFDvAE/XhZWjaz4mDfx7I/qnY3zp6h1qg+K8IeeMkNfWFr/zCDjrPpZgECYqu8Rxd5OAvxWcEaTe4RXgpNr5Vuqp9acILNKpO1rY1PEOOiK/JchIUwzAv3LrcSeUyS2LsEpC3zozrgjEaZaRt3yINXf7GR9ndQXzoHymRnzm+JIpWXFqFzPvUWeu7hfOSuG322pE3MUfwCM4Ti+ra1/LfiH2gbdAfCDqOeIZsmNZVkyrNFdaRTq0AU4X5yozm7u+c/UHbo8hKQKi+y7YooN2Qfs4G8MpxCpDhaC2Na3b6+PYXtFP+KoFMTmSHRjQ4+IhnYlOqoUm8T+e/1EDpuvxEg9qx1jAiWJoWGc1kG2S2kt6XbiheC/mOsHGHTZINgfltBdv4CRHFyd/7txPJWEDzXjAJi8oP+TQgbWm6OLYguUEvknxFSq0uuwjSPE39msCtV2Sf6r4QaCFxkt+ZfOTKkvCo9fSQujfmPN7COeJQ
 JxPQKDsN
 QKT3jf4dmqc68CDx0uGdwzSkE2hxaGa6RdrEbqJLydYGKOF7+2EZdRHL3a2xo4dtC/d53OyHl9B7Hcrk25z1IdZgRCw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22 Sep 2025, at 22:35, Andrew Morton wrote:

> There has been a lot of discussion here, little clarity and no recorded=

> acks.  I'm inclined to just drop the patch and to ask that issue be
> reopened.
>
> Comments?
>
> Thanks.
>
>
> From: Wei Yang <richard.weiyang@gmail.com>
> Subject: mm/compaction: fix low_pfn advance on isolating hugetlb
> Date: Wed, 10 Sep 2025 09:22:40 +0000
>
> Commit 56ae0bb349b4 ("mm: compaction: convert to use a folio in
> isolate_migratepages_block()") converts api from page to folio.  But th=
e
> low_pfn advance for hugetlb page seems wrong when low_pfn doesn't point=
 to
> head page.
>
> Originally, if page is a hugetlb tail page, compound_nr() return 1, whi=
ch
> means low_pfn only advance one in next iteration.  After the change,
> low_pfn would advance more than the hugetlb range, since folio_nr_pages=
()
> always return total number of the large page.  This results in skipping=

> some range to isolate and then to migrate.
>
> The worst case for alloc_contig is it does all the isolation and
> migration, but finally find some range is still not isolated.  And then=

> undo all the work and try a new range.
>
> Advance low_pfn to the end of hugetlb.
>
> Link: https://lkml.kernel.org/r/20250910092240.3981-1-richard.weiyang@g=
mail.com
> Fixes: 56ae0bb349b4 ("mm: compaction: convert to use a folio in isolate=
_migratepages_block()")
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
> Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Brendan Jackman <jackmanb@google.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Wei Yang <richard.weiyang@gmail.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  mm/compaction.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- a/mm/compaction.c~mm-compaction-fix-low_pfn-advance-on-isolating-hu=
getlb
> +++ a/mm/compaction.c
> @@ -989,7 +989,7 @@ isolate_migratepages_block(struct compac
>  				 * Hugepage was successfully isolated and placed
>  				 * on the cc->migratepages list.
>  				 */
> -				low_pfn +=3D folio_nr_pages(folio) - 1;
> +				low_pfn +=3D folio_nr_pages(folio) - folio_page_idx(folio, page) -=
 1;
>  				goto isolate_success_no_list;
>  			}
>
> _

Acked-by: Zi Yan <ziy@nvidia.com>

--
Best Regards,
Yan, Zi

