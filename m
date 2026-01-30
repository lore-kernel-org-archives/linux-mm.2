Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6073E6BF2F
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 17:06:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10B796B0088; Fri, 30 Jan 2026 12:06:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BA046B0089; Fri, 30 Jan 2026 12:06:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB2F36B008A; Fri, 30 Jan 2026 12:06:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D73176B0088
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 12:06:38 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7FB54C277F
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 17:06:38 +0000 (UTC)
X-FDA: 84389259276.12.A103474
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf14.hostedemail.com (Postfix) with ESMTP id 275D4100012
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 17:06:34 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=EE8AWozL;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=yZfU4WIn;
	spf=pass (imf14.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769792795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cIVBiRoDTrZs7fGqJzsSEWwh64uWiuk2QByZ4dPMewA=;
	b=rNX1inK2RuwHRGDnMhH5pS2VZgiAXeQeP9cqCmkdfAb2depnBF3jFrNw/6EfcYMrzwgSPo
	EfmOZp5EeuvCmY77U64pAK17wP4JL0kb7UjXLlfFxaExgAUljf0pQLoHOj2ERPoCbKWiyn
	RfHIS7nBAL2ElRimPz+YvRxqC06irjY=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=EE8AWozL;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=yZfU4WIn;
	spf=pass (imf14.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769792795; a=rsa-sha256;
	cv=pass;
	b=HvayNGBrBXMuU91f1S8jlDLfo1gTyLgN0slBhJ9emoDwdvzznCxvfTNT3SDkAOsW33TJ9I
	8e++aBAZIZyxUB/coPP40WfVflMqQ7hxcq2kqnP3rdWKdBz06aSpciy7yKxLCswRmyhd5a
	LWdo/MGnqBZlwDlky18gA92cGYAkKvU=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60UChJSQ3324720;
	Fri, 30 Jan 2026 17:06:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=cIVBiRoDTrZs7fGqJz
	sSEWwh64uWiuk2QByZ4dPMewA=; b=EE8AWozLVugvBtBc1uWcq5QW/vYC2zwZCa
	x1JV/hGl9NeWT1DuQvakNP5ejPN1t/iuyO5HuH+cJtM67GuAHPYvBjEfhAhoRjU8
	e8AbfxiwWO5Dons63mJvl1SIUgS8FsxjA2l7AYq8HtQO8YNn4WHX3M8TAF0yjbHL
	Ph3xHkKbRLeDYOo3R1z1kb9svFJwwCcEMF2kxmEN03drH2RMoAYUXORrurYr0q0s
	Po22awbhekCchU9lzB81HSuWz2dmHv5P9wbrMv+YN0FIb4U9B0XRMafHt3N/HAO6
	q9A4yJ5Fus0cQ5xnjJ/3Ax1k9mTY2LfXpnwNCc3qjZMzA05QhdYQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4by2vgnmrt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Jan 2026 17:06:23 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60UFsF8g036182;
	Fri, 30 Jan 2026 17:06:23 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012058.outbound.protection.outlook.com [52.101.48.58])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmht79ts-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Jan 2026 17:06:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qb2NhEGH0HLizEIMD11uTt3XcARCnHrxR/F6uH5JAbgXkHwZa5agr63i3l7PWC5OrOmFUAdLtUWeIUaM5zlHuFD6vr5hE5G2Vnqnzg+IQLuMWJG33xKOSkMzMjAYO9Ch5paEI9wLuNGIT50d0uxMlB3EDNNFEFvz0oOb0/zhqTm14JEpLZC4wdcK3N94VKZ1EXgDA4nT45xE6NyKjU4zed+DWI6RAp88RE+i2Qb1x4djtJfEkETHkLWflQLNXPOWPcyd1kJ0dcT6PIrynK6s7EyXxh+CEShHytONt3hoTHYuEc10dDUXOL8pGJxkeM3poav/+ovj8VvSesf+oMejhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cIVBiRoDTrZs7fGqJzsSEWwh64uWiuk2QByZ4dPMewA=;
 b=g0033UgpJ5wg2OLEg/MphQ/PzlL+JQGOSv1KabGQG7BLGEpSLSsgqS78kRKIGyBJ7HkuJdEpnxw2O3gwjR28VoD2ycGO+XJqPYB1GP+ilWPusIia8AMaK2z+54addVAzfilWgxKo/rd0Lvdn0Pk8zrj+6H9sjbjKW0ppnH8h8ZbAgTA4RgUDwRcOSFOggeaiE/5R69p96NGl+DHGT4McYXWUPawHQY2c/K48a4/TgBLCuX5hX5vLPEFHvU5G+y+y8+c7ZVB8jJXVjIG71x9gHoAE5BjcJPNKApwVYf1e5d4cu5n6jQ34rSyQ5TXdTTzJvSTqQojYWD7OIat5o7o8qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cIVBiRoDTrZs7fGqJzsSEWwh64uWiuk2QByZ4dPMewA=;
 b=yZfU4WInB9dAYR1HdeEb4Xxkcm4t3R/IxF2qehGOeLu4SKVIc8WfjwWzrJXm4ZsrIhfvODCaVmNFXVHMmYhkOarQHHu96Ya7dAvHrJUpEjprbcJSZUft1BkY37JwHNQFDtD2XM/vguiKd7H+4SMHE8fJW6ELmIrYevrxNlWVkjw=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by IA0PR10MB7580.namprd10.prod.outlook.com (2603:10b6:208:490::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Fri, 30 Jan
 2026 17:06:17 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9564.007; Fri, 30 Jan 2026
 17:06:17 +0000
Date: Fri, 30 Jan 2026 12:06:13 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
        Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-rt-devel@lists.linux.dev, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>, Waiman Long <longman@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <clrkwllms@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v4 02/10] mm/vma: document possible vma->vm_refcnt values
 and reference comment
Message-ID: <jkom6emb7qspovq2jw7bhc2fgsol4bog5zc65u7papvqz3is43@3t4ibq2qmmzl>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Jann Horn <jannh@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, Peter Zijlstra <peterz@infradead.org>, 
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, 
	Waiman Long <longman@redhat.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
References: <cover.1769198904.git.lorenzo.stoakes@oracle.com>
 <d462e7678c6cc7461f94e5b26c776547d80a67e8.1769198904.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d462e7678c6cc7461f94e5b26c776547d80a67e8.1769198904.git.lorenzo.stoakes@oracle.com>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: YT4PR01CA0402.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:108::14) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|IA0PR10MB7580:EE_
X-MS-Office365-Filtering-Correlation-Id: 946aa99b-c408-44a9-67a7-08de6021e1e7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?OG+xImQqJa/O/Hg5Oc0rYO0msRyLMe/BI/UaFl0t6uDNStq1e/O5XtM/4NYN?=
 =?us-ascii?Q?L7utR/ZRtsRi6hqcPkgJsfAh/qu25nw53v/LdoEVO0sys+voJNjkz+VG6kUy?=
 =?us-ascii?Q?auIgRl5/RfX5glHWdmqwwKBfDBVDKbcmnkbDdxWj255uyjhjvzYnzXHQXO9F?=
 =?us-ascii?Q?ic4ioUKLO1CZdNbM6z5I95LzqnVCaM3LvbbD8KYY5UJsAOLMxzGWeIHNmyfk?=
 =?us-ascii?Q?wP8Tfp+WZXdmhlJ925r24hVwBFrtcbHeGxr4uGzCqjqmm7LIOBHx4dmahlLT?=
 =?us-ascii?Q?G4Ky33e3bXkwNgQWT+vGj0XM+co+E5tV1STOrq0BcheP0568sKPXnSW+F/5i?=
 =?us-ascii?Q?zBTCYYMtbyzSA9xYsTXGzSgSaOxNwAYi/H0Z0lQ9ZiX2byWvGCxdNojVwY6V?=
 =?us-ascii?Q?dayIcus3S0eHBVfrOsRgWVqG/9AWEx1tAN6moZsMp2VSlzJ9m+Kn0P+Y/nDI?=
 =?us-ascii?Q?woIZeTh6E7iKxAR54au2YNTNxF8BxGj8ovWffyt4uCZ6py7JLITIX3+UbdX3?=
 =?us-ascii?Q?40n8swogUN5PMkp+T9KdD0BxBVG2KwHsi7BRwaOLct4wYyD59RlTGuEJV6Fz?=
 =?us-ascii?Q?GBUk2+sGmnk7arqp0gEhGtJnNIn8W7TZ01b+E5EmQu1FWE1jvEXqOQAQLkZW?=
 =?us-ascii?Q?yErPxxfujzwG3dz46jjixeE2LIUR2hyC/CmuFcg5tQFE3R5+BI8TAtW8ISyT?=
 =?us-ascii?Q?P+EIgFUqHp04B4PAJzL2Mr7cxNFPrJo+w8p97sIUfIDqfYqIICwau/hjvnCr?=
 =?us-ascii?Q?RDq5cuATdsT4ehhZDxvVC/fXHXR3Rs62Gsm0/P03F5jFnjFEgz+H2T4UigQM?=
 =?us-ascii?Q?i34Z8qga53xPrPhquV/lZbG1T/BV8d4FbWNEmj3VRaX4c5bAMx99Z4JgNCxQ?=
 =?us-ascii?Q?Oaz58QjhyO5sciZvqCuzwDbh/04v1xY3ugF51TcoYW9MfANedOt54UQyWtCO?=
 =?us-ascii?Q?Zf7r/faIjCYRQAavvrKhOIOE4ZgCvjLksgQOEBv76G6tvlW0YuHcNVqlVfuM?=
 =?us-ascii?Q?xYj7KqZCM3wU6oxDNkAULLG89dIYiW24YvLQxUa0xu0ZUW6gmrcqxl45JLUM?=
 =?us-ascii?Q?MPHAwbXpDYD3DKUOlHPX61U9l1FmKenjNilDhubRMu86wxLRFp9wolVn7Ih9?=
 =?us-ascii?Q?DgoOzfpP6A9HGszMIQCym82GFlskmghabSbXjufibI4zFp/x+iTfNtFVGifu?=
 =?us-ascii?Q?4F3hlW+hUv8kfFzXrU8yiKq1MZ/zuM225DG8N/WBMtYnU/H/kZcreXWlN33+?=
 =?us-ascii?Q?fDRI6m5rKBTAv2SX4D3FELDclT2h8H7/l4zHT3E34bW1sCSLoOI4dYs3HoF6?=
 =?us-ascii?Q?/3Aaqrn0vBM3G4OedBjymyvpZ80qqAxKeU8x79Z8kCcmPVvZUIrJ4nipKTpw?=
 =?us-ascii?Q?x2RcASrFLzcBMywWPERjTZgG63s1MMSGfyPoWlUSGj7OVE6lSDkVZ8bO1aFa?=
 =?us-ascii?Q?5O6rjjQwhVbAaYf0BGER2fLEOYv3oxVll2IqQvUmMp0pEg0bptkKYrD2DYTT?=
 =?us-ascii?Q?MvG2cin0j0ZKeZxY+uMpNqzspWMVljH4Yf9KcOJxUmfG1h5kJbBoi6/eJ1Oo?=
 =?us-ascii?Q?KjlUpqfdUIA3JN+mYFo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3ZnK7aHbwKG0zEvW/ogM4KroCmI5Fn5+LjcsGh9NUtg+bMi9hLoOGPWn1m26?=
 =?us-ascii?Q?8YsGt1mdHVhA7plwGqrvqOs6e7QQGJ3UCEe9OtbquB5X8giRra1hE6FllR0T?=
 =?us-ascii?Q?DPkJ+B6W96dgeN0rrZcY6fRwSpg5OYyJzBixQWfwbHowjH1fAUH1bFyG0+tj?=
 =?us-ascii?Q?GaIt8Fx35Ojfwbolbuf9TqtCcJrX4Ix1fpnHf6omUUMwY0AVq4DCVVe3eNgY?=
 =?us-ascii?Q?g5BG9zxJ7GRgsTvpJWGUd8kIPk5bfEqa9voEXmjwxSbY8GOrbktQCeIGCOay?=
 =?us-ascii?Q?yYWdWDpqPvlE0szIo+qZSYpHuaUznDVk07Mg04QBPi6XozahVbNMBHErXwwV?=
 =?us-ascii?Q?3/peMukkzNyLGDAImRXNvzgqkiLCvmQ2wYz7PUXPBFsU7qSF+TlY4v647opm?=
 =?us-ascii?Q?B8gDhvZ41S7YhFlp77JziOTMJp5NNFnX0CqVKBXD9u4GfvTfiw4POkDPQtyu?=
 =?us-ascii?Q?Jb0mqmSSdpP9cvJs8sibVyUPl2iuQKgBUV+Y9n413CfAbXHfRIyw50zsAbQ7?=
 =?us-ascii?Q?xS2Zmbrrb/+4If9Hncuh/i1s5NW+7zGWrJI8s8wi3Qlm8xPt8tJuFqFuQi8U?=
 =?us-ascii?Q?WNj67JgtA9xUu+7Dkulvmluha+ZVcQtzM7Qd+et7H89CIrd7Bkn+MBXja8e+?=
 =?us-ascii?Q?PBsVYHpOkv6u2C8Bl2fhLZckxPJVmahTh3XwvggHTxPHMJN6lxxGM474S828?=
 =?us-ascii?Q?hdAw+5PumsVpy7rNJyY9h0byJVREgkuwP0qfJcgyZWK6yQ+XfAbnH3H+CFBo?=
 =?us-ascii?Q?IALgHdeCe09mEnQvChYkqdqGbHE3DTKM2ixLrAqAgKSizyNj3zVSFdEr7NGh?=
 =?us-ascii?Q?Keb/4/fJnNsvH2Daq7SgZq+BdMgzndE7RshY58Ms2E2N2dUU/QwuFj2Wj37a?=
 =?us-ascii?Q?zkFupzybgNkxuvvlyIlAOrV1QPXysF+RXRN4TnytvRM9CDtGqNXR436AvEBE?=
 =?us-ascii?Q?qpuSm+On/Pr2y88TBgWfIF6mZeKmyMv4upUwHGM4xl1QfkMT4QgzjZzaSKss?=
 =?us-ascii?Q?jMBZqk0hJIv/p/kxtITpGD6K6rG+HoTn/QZBMWYkB1t+HMXGRPavt1fbjDEh?=
 =?us-ascii?Q?SXM5XqLy9P5LcoftRDvTDkQ04Q0Zuox5hDZiAEkiv8wyLfsoAdHrljboTvCC?=
 =?us-ascii?Q?cUkIf9sAfwMTz6FzrlHEmozYz+2peGhOyCszbjvriwlKndNNhibIiiq30XVQ?=
 =?us-ascii?Q?Ty4ghReHkTBx4ywS79cvnCRdk74C+YG4R3weU49ZpffCJ8XWjvEfGtNY8Iox?=
 =?us-ascii?Q?K8wccaSJWsg7PBO+HKw92Ax+1T677bbzdx9/ba2Bfz3gl3OOhIw4p236Wkp0?=
 =?us-ascii?Q?v27iQ2p2cwzATy8dWQKgJjyyJGZKKCUQ15oPaT49oZoP8cSBnrrPPB3zjNB/?=
 =?us-ascii?Q?uTGqkyKe2y3JjcC1C9TKPK3/krBqY96olbAwZe8DxQsnDq46SSi5/nzF6gyI?=
 =?us-ascii?Q?6HwFEEFzskrFp9meR5qDvpeyHc8MBrwezxdY9sDzemrzXFjLxZsrIih+wujs?=
 =?us-ascii?Q?YVJDOfVTQaV/zr+7gBrlWORwj6Gz/09u+vqPCcWWmx/kYKZiftW+1rwWqZW+?=
 =?us-ascii?Q?8kl/+X3Ubd8Fd8/27gfRzOu2DRB1e+F88kbsvbP6AlGHnBorNeETzZWDp5T8?=
 =?us-ascii?Q?nx8FgPSfTe4Yg92ZwnWGG1WJeyzeQmEUw+zic/4WBThm5l8bzwDUl313EiEQ?=
 =?us-ascii?Q?W8+AnvyNKSi9cKEnxAj/MFTl7MPY9k9Zwevo+SKLIPAcBKBLn6Nf9JLlTZ6n?=
 =?us-ascii?Q?ddZG4NEMsg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	K5aps+Y+qwWnZwvtvG3pOwijLUw+94Lzd0LIPCHuU77H+hzikTsvSaVdBC8DQ5YNMHkHG7ZSPSJKGHC2AOu6x19vT/2Ex9mJnuE2SAlkpbYakKIznMqzZwvG9nK5WAbojFN2MgEUegXUvbo8+Lj4V9dlZn44Pl845UsSJkRmGNjo34WGntJGqurnOSeLFEJr4n2LP6prD7enZjlzL24bfmDW5inDCJKz+fukdHLxU07FeGUbsA7luDK8YuhAhQuh/caBnbpot2LML/tNXfhVIW9XRr/wlQnWyqVB+8SsX6Hfe4CJR0BTBQaSk7+0INBj0SjtO7CRooHEbS0mRkwVESNcsi5J+vYwIW7eGvW07EEhts/UagZZKVxwdhShdDvRs92FcjMX7n6LX0oXxazSq9G8y6FF1Xn3r2FEejW5FyMj9lumSgKkXf4b8EAFNoex1Jlip9FM2iUB1LyjlnFjl+M26vfKGRl0vRkGyVLIW8N4Yy3Jtz2dIM/Yu+97VMDWKzzbCFEabrV+srhzgeyZuNq6iXmHA4uBkE32lFfulOUab1nEM4pSdSWbwgI3JXEtgq9d15C+Dl2JN6S3bW9yBJP2Uk6TvyGsLd5S66d0K70=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 946aa99b-c408-44a9-67a7-08de6021e1e7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2026 17:06:17.4986
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xPaRCtACVkpQL7SdIrpL3K0rJ/Z9P9GJWPDPo0z2KvrC8NDNkFa4nrik3pzO6sd3H2HXTr5Qd6vSPU43qM+gzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7580
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-30_02,2026-01-30_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 mlxscore=0 mlxlogscore=999 phishscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601300140
X-Proofpoint-GUID: 9aNj-aMUvbKF0Nde6bIB3H-MCQRRQgEw
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTMwMDE0MCBTYWx0ZWRfX+fIRiQnVP7WI
 qOHQDuhbrTM5cZmkD01ww1u6YJmUn/sx8U8596lECRKxBFQe4pc+HOzddZiQ5Q/G7uvJcalnYCh
 6OOelM0zeFsp5Tm/1IeUl1uyg38GYvu2IJBCphmmAHi5pUPnrlVaGfJHrujiBDhNQXeBOJi8KDJ
 NODUOWMV1U2oZPdoEZ/D0olfSRtUQchVOZJ1GZiLSmgx3BkIjUxI/DY+k3UqONq3QAraJuwzVg1
 6e1w8Bsrk7KJOq0G9M8gafdyeshbC+5ri7e1Jdo367f+STHe+WgKdcWZOH7X/efyuN5MG0iPzAp
 ObyUqIFXV2jf2UZIYoaJNbd8LsAXvYeMqDgTOU5HH+EH0CO2BJptX3OcdFwhpZDd4vlvkUT1bvR
 +UVhCelR50TVgzVGXvT3uxDbKS5kpGFDfrSfU0GdjQBmV2Xcr8QjKhU1rFKwS1oMufBGb3MMe87
 Q7JrkpOFL2afQ1mopQf+dK0kj/5WUEdOekWyWlxY=
X-Proofpoint-ORIG-GUID: 9aNj-aMUvbKF0Nde6bIB3H-MCQRRQgEw
X-Authority-Analysis: v=2.4 cv=a7s9NESF c=1 sm=1 tr=0 ts=697ce50f b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=2KzJbkUJpVLLnW4jeM8A:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:12104
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 275D4100012
X-Stat-Signature: fcbhmpsezjd1pkwh3y7e9cz6mcewbsyn
X-Rspam-User: 
X-HE-Tag: 1769792794-856803
X-HE-Meta: U2FsdGVkX19Wypc2cffzPPsBT0KJzLj30RJK/Ohe09MVRMFF1Lemv4KAsBklDVd/nzywWQwqANJJTaucBvlcVJF6yr7Crv+bL0hy9AmnAAldi9Jq8I5xSpKCv5zYLBPqEYhtvGCQhlFr7opRVP8XPRvSMywZDiIZe6vEse3rE34AP463PrvYLov3TuLg8jFBOFvd5TJ38sqGYtPn3Hu91mZuWpwQSRcbvAEviuZ8aigp+sTYSUukk01aFtxuroSXjyiwoeoja1eBid0fzxborWuf8CdKfXX6jHnjLt763arRbDTLHAxIhJexUmgDZSm4Rkh+b7emqcSc6Lh060ZTm/SztnAnQLD0oGdJUyFtDzg7moL5SqPWGi2T1trATPaI5RrbCPeNzzkIgk+VM6/qca6F7xuRaVf64DdOlZnzAInEp5BAHeNXqC5y2XsBc9YvtGV/c7uWB8S9zD68l5W7CQkfaKODxzbioxKsOXa+21xyVbK/HENHEaRr7A5mDdHnIQwyzKVW8Rh2qBJN8zoaFxv7LvOnQTKlVkwPf2dC0YsTMEv38CNOh2ZQMYzMApeJkS9PdYZO7tQrN8FwD6meKG2EcYcXQMyMR0OZ9Mj3d6scYmJ6JlOGreOeTtBh6yvb9wCU1hVqkagfh9WrWXh4CKgBIueCypiZz93qwPaOtyNlw+LHj4ZlGGIvfhbQCWdAiKJH298SSpB9CnUYklHuuUk6DiEZFSy1c08wd6MQfpue/OZAD2vG9p/vrJvN13HzKMFVXWy+8Q0oEGYA9FdDayEnt+r0uXOwkKt8q6lvTyU3aaPuCobtMMauiRWqiGM6NjkhYGNPAskYxAssdGQRf5BupzUdYZlX/dc/P40SuhRdcQYxz5VEaD90dC2RKky2WiSbGUDDd3XlZ9YY9MTYYNFd7Bz/IvP1O2VdRD26wEyH+qBvwpb0Bq+jT8GApDhL2DUF3QeL2uvBUTKZLoh
 5MBk/LP4
 Ozdk6Odsi8xzKrxcIa3JlZHKKQOpwkaEYp+gxRHFZ4Z1YYPrKHDDX6VH8ogvL3cF9nPd+DMqJNhpSyPuohpPcofzE9MAgvsegt4DPPOIFCvtdf+ccQqYwxcS0/CP+klTUV2wxEUubMR9mcoefTGC9Kf4yyM4RbJgXhDJo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Lorenzo Stoakes <lorenzo.stoakes@oracle.com> [260123 15:12]:
> The possible vma->vm_refcnt values are confusing and vague, explain in
> detail what these can be in a comment describing the vma->vm_refcnt field
> and reference this comment in various places that read/write this field.

You may want to indicate what attached/detached means?  Then again, they
get added/removed from a few trees so it gets a bit difficult to spell
out.  Maybe a pointer to your nice doc file?

This is certainly worth doing as is (minus that typo), so

Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>

> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---
>  include/linux/mm_types.h  | 42 +++++++++++++++++++++++++++++++++++++--
>  include/linux/mmap_lock.h |  7 +++++++
>  mm/mmap_lock.c            |  6 ++++++
>  3 files changed, 53 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index bdbf17c4f26b..12281a1128c9 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -758,7 +758,8 @@ static inline struct anon_vma_name *anon_vma_name_alloc(const char *name)
>   * set the VM_REFCNT_EXCLUDE_READERS_FLAG in vma->vm_refcnt to indiciate to
>   * vma_start_read() that the reference count should be left alone.
>   *
> - * Once the operation is complete, this value is subtracted from vma->vm_refcnt.
> + * See the comment describing vm_refcnt in vm_area_struct for details as to
> + * which values the VMA reference count can be.
>   */
>  #define VM_REFCNT_EXCLUDE_READERS_BIT	(30)
>  #define VM_REFCNT_EXCLUDE_READERS_FLAG	(1U << VM_REFCNT_EXCLUDE_READERS_BIT)
> @@ -989,7 +990,44 @@ struct vm_area_struct {
>  	struct vma_numab_state *numab_state;	/* NUMA Balancing state */
>  #endif
>  #ifdef CONFIG_PER_VMA_LOCK
> -	/* Unstable RCU readers are allowed to read this. */
> +	/*
> +	 * Used to keep track of firstly, whether the VMA is attached, secondly,
> +	 * if attached, how many read locks are taken, and thirdly, if the
> +	 * VM_REFCNT_EXCLUDE_READERS_FLAG is set, whether any read locks held
> +	 * are currently in the process of being excluded.
> +	 *
> +	 * This value can be equal to:
> +	 *
> +	 * 0 - Detached. IMPORTANT: when the refcnt is zero, readers cannot
> +	 * increment it.
> +	 *
> +	 * 1 - Attached and either unlocked or write-locked. Write locks are
> +	 * identified via __is_vma_write_locked() which checks for equality of
> +	 * vma->vm_lock_seq and mm->mm_lock_seq.
> +	 *
> +	 * >1, < VM_REFCNT_EXCLUDE_READERS_FLAG - Read-locked or (unlikely)
> +	 * write-locked with other threads having temporarily incremented the
> +	 * reference count prior to determining it is write-locked and
> +	 * decrementing it again.
> +	 *
> +	 * VM_REFCNT_EXCLUDE_READERS_FLAG - Detached, pending
> +	 * __vma_exit_locked() completion which will decrement the reference
> +	 * count to zero. IMPORTANT - at this stage no further readers can
> +	 * increment the reference count. It can only be reduced.
> +	 *
> +	 * VM_REFCNT_EXCLUDE_READERS_FLAG + 1 - A thread is either write-locking
> +	 * an attached VMA and has yet to invoke __vma_exit_locked(), OR a
> +	 * thread is detaching a VMA and is waiting on a single spurious reader
> +	 * in order to decrement the reference count. IMPORTANT - as above, no
> +	 * further readers can increment the reference count.
> +	 *
> +	 * > VM_REFCNT_EXCLUDE_READERS_FLAG + 1 - A thread is either
> +	 * write-locking or detaching a VMA is waiting on readers to
> +	 * exit. IMPORTANT - as above, no ruther readers can increment the
> +	 * reference count.
> +	 *
> +	 * NOTE: Unstable RCU readers are allowed to read this.
> +	 */
>  	refcount_t vm_refcnt ____cacheline_aligned_in_smp;
>  #ifdef CONFIG_DEBUG_LOCK_ALLOC
>  	struct lockdep_map vmlock_dep_map;
> diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
> index 5acbd4ba1b52..a764439d0276 100644
> --- a/include/linux/mmap_lock.h
> +++ b/include/linux/mmap_lock.h
> @@ -130,6 +130,9 @@ static inline bool is_vma_writer_only(int refcnt)
>  	 * attached. Waiting on a detached vma happens only in
>  	 * vma_mark_detached() and is a rare case, therefore most of the time
>  	 * there will be no unnecessary wakeup.
> +	 *
> +	 * See the comment describing the vm_area_struct->vm_refcnt field for
> +	 * details of possible refcnt values.
>  	 */
>  	return (refcnt & VM_REFCNT_EXCLUDE_READERS_FLAG) &&
>  		refcnt <= VM_REFCNT_EXCLUDE_READERS_FLAG + 1;
> @@ -249,6 +252,10 @@ static inline void vma_assert_locked(struct vm_area_struct *vma)
>  {
>  	unsigned int mm_lock_seq;
>  
> +	/*
> +	 * See the comment describing the vm_area_struct->vm_refcnt field for
> +	 * details of possible refcnt values.
> +	 */
>  	VM_BUG_ON_VMA(refcount_read(&vma->vm_refcnt) <= 1 &&
>  		      !__is_vma_write_locked(vma, &mm_lock_seq), vma);
>  }
> diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
> index 1d23b48552e9..75dc098aea14 100644
> --- a/mm/mmap_lock.c
> +++ b/mm/mmap_lock.c
> @@ -65,6 +65,9 @@ static inline int __vma_enter_locked(struct vm_area_struct *vma,
>  	/*
>  	 * If vma is detached then only vma_mark_attached() can raise the
>  	 * vm_refcnt. mmap_write_lock prevents racing with vma_mark_attached().
> +	 *
> +	 * See the comment describing the vm_area_struct->vm_refcnt field for
> +	 * details of possible refcnt values.
>  	 */
>  	if (!refcount_add_not_zero(VM_REFCNT_EXCLUDE_READERS_FLAG, &vma->vm_refcnt))
>  		return 0;
> @@ -137,6 +140,9 @@ void vma_mark_detached(struct vm_area_struct *vma)
>  	 * before they check vm_lock_seq, realize the vma is locked and drop
>  	 * back the vm_refcnt. That is a narrow window for observing a raised
>  	 * vm_refcnt.
> +	 *
> +	 * See the comment describing the vm_area_struct->vm_refcnt field for
> +	 * details of possible refcnt values.
>  	 */
>  	if (unlikely(!refcount_dec_and_test(&vma->vm_refcnt))) {
>  		/* Wait until vma is detached with no readers. */
> -- 
> 2.52.0
> 

