Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5B0AEF48C0
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 02:53:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C25B96B0005; Thu, 12 Feb 2026 21:53:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C07426B0089; Thu, 12 Feb 2026 21:53:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A944A6B008A; Thu, 12 Feb 2026 21:53:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 95DA26B0005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 21:53:26 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3BFE31C229
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 02:53:26 +0000 (UTC)
X-FDA: 84437912412.09.97BFE67
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf26.hostedemail.com (Postfix) with ESMTP id B3973140003
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 02:53:22 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=kL54VkW5;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=gEtfJOtn;
	spf=pass (imf26.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770951202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Von6iiOeESiJOcqVnPCENdo3jADXjBxipm2YFiHG/R4=;
	b=5yS/SL0TdpPpP+Xh+e76+PstJWyMKdMLGxpXt7xlBXUkQelY88oxAsuZx0pSKizSBHsl6L
	KietjumZamQ2jF13JSBd6EsZJfyOMbKSmS1qQzCxPyEl+yz1Z8rG7aKB4EWUiHBpqLUend
	9NXN+0rzNvvI255T8lbLBdxV+Qw4nzQ=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=kL54VkW5;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=gEtfJOtn;
	spf=pass (imf26.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770951202; a=rsa-sha256;
	cv=pass;
	b=UHCL+y8+OQj9DQQ8VASoM2z29mGslINFPB69Da66ff2lCZw5T/soeiGaxuc06oG/bjrRug
	UpYx/Q/+E5t5Z2UL7WbwCVfTgzG+6tgl1w2WjL2jSDc3ZNVNwGsqI0zatSM8q4e9s/6BDo
	Pr4grxoNk7lq5mjWvEdUlmhgfDs7tGw=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61CGNFCu2001139;
	Fri, 13 Feb 2026 02:53:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Von6iiOeESiJOcqVnPCENdo3jADXjBxipm2YFiHG/R4=; b=
	kL54VkW5dudyKl1qoC+LBUFWxk3ybCK4BpMn0gdyW60/gM1ur3x3TgRh5CeFstSC
	GOUvlVNIzpI8+KGrczDDdvTM2B8pBWaS3memY2wGdzRJ+jQ6KGS81HhDSlJkrnQE
	B1cefITzC99ujjIaOO84DMFhe+j0qWMImn/fwJ9pB6SJYvQTkmpy1IZHIz6+CTXX
	TTPOJt3/+vIp/NQtiEqyhon289BW5YYB2WuFKwYEB7vRcC5WPS2ZIRxhfq5CYnm/
	MJIrG6bOVVFw0jyVf4YJgXQZsTVXt0hTVTTIDeaGyY6/RKobGWCMGKqOhfI69ADI
	xkpqjJfjee2KEx4sDI6KLQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c88df4mde-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Feb 2026 02:53:19 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61D2itXv032939;
	Fri, 13 Feb 2026 02:53:19 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011054.outbound.protection.outlook.com [52.101.62.54])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4c825x8edj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Feb 2026 02:53:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ek+QN9tDtmaHKgdmI7B0FkTMKHjAruPH+rXeFItISue6MExWfOf8qqmZoWQSwIZRAY9xoq6dhY1Z0xtRkJ3hBLMyh+Hmh23LOivY2ewsRGmpL+85nrpG4Hzm5PnmrX2QBw56hVfIyQALuE3BjRVoBrwDuepMlRDQMN2QcXVYeBoTZCpeiKn7XF8J+71M+pwGH2fmI5hDX1RnBWg8cw0TbVaiMOtw8FTmmjk1UL3R+2n0PSdKtoucZH5aRX42dtERWAyHvvM8ERdePgDyCh5m/tEztweALBKAHy/CQ2xotaI6540cjWzzckAWdfkh4D74tGfh8doEaTwX54Gncme/1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Von6iiOeESiJOcqVnPCENdo3jADXjBxipm2YFiHG/R4=;
 b=DSsaeRq57x7rmknM2+dd2a1xOr7au8sf7Ry5m39q0bPCxrHyoP1WWFlCv6Ft4voqOnbc59HVr1rLRko7zM72kEALUksDKUTD+if0iwt3u2vdDDPtwweAHrWyULg74bkUUBk4UIS+kvg+nFrNSJYy6E5n2AtoUV0nD7S2NLDJSvbIEDAmEXlwdFbvOP/h4HGRgHLWsbacrPo6vej8l1ft/D35EknUFqlG6lP0EmB/CFodmndBYeHfsVAgzGIUbQdJW5nCAgQpDaUb+8kVRnZX+VtLY0ERbBPGEuEwYdPUfPzkbBY0ecfmTnV9xrK2NsdYAc1sY41lNkwPe7BzjvyuIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Von6iiOeESiJOcqVnPCENdo3jADXjBxipm2YFiHG/R4=;
 b=gEtfJOtnYuwgZpE8qxYIfdeCDc6BzOsqB7ljB+RPldIngBcAMK6Mw6RpJ4jTV4tPdS8N10lVbBneVaQm2uqAvCMTXovTcKksqFYxQeAEY8qDatQXj6kJXYTJUUL06ZLahyeOn6oqTQHiQ8CzYBJ+hLMMtDrFJ0m+VZQHurmRMjg=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by DS4PPF8B03CE791.namprd10.prod.outlook.com (2603:10b6:f:fc00::d30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.10; Fri, 13 Feb
 2026 02:53:15 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9611.008; Fri, 13 Feb 2026
 02:53:15 +0000
Date: Thu, 12 Feb 2026 21:52:59 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: syzbot <syzbot+54245a237762e7cbecf0@syzkaller.appspotmail.com>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, lorenzo.stoakes@oracle.com, shakeel.butt@linux.dev,
        syzkaller-bugs@googlegroups.com, vbabka@suse.cz
Subject: Re: [syzbot] [mm?] KASAN: slab-use-after-free Read in mas_walk
Message-ID: <6pj7qr6p2wcg5pbigqzbxikpyxw32zqaysepdzhggbvrd3rf3o@5nu3sf6wz6uf>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Suren Baghdasaryan <surenb@google.com>, syzbot <syzbot+54245a237762e7cbecf0@syzkaller.appspotmail.com>, 
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	lorenzo.stoakes@oracle.com, shakeel.butt@linux.dev, syzkaller-bugs@googlegroups.com, 
	vbabka@suse.cz
References: <698e287a.a70a0220.2c38d7.009f.GAE@google.com>
 <muuhcv22gzsr2a3g4lsu4zqsjkdbjqxn7bszh7r4nuqgq2oc5a@7jqpwr6v2vez>
 <CAJuCfpFkHnmX_40RdjnWmicB46Miry6Bc6Lht2rfno0jopraUQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CAJuCfpFkHnmX_40RdjnWmicB46Miry6Bc6Lht2rfno0jopraUQ@mail.gmail.com>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YT4PR01CA0443.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10d::15) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|DS4PPF8B03CE791:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f5fc47d-4993-4dd3-44ce-08de6aab0898
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QkZYb0RhQ1FJWGNQdlJYdnNFUmh0ZnlvS1RXb05iUUJXcm12bTcrT285aUtp?=
 =?utf-8?B?eUVBd1BWTzdzUitMeHJqa0NwbWhmdGxhRU9PRlhIWGRXSlVRTnBRMEFHZWcr?=
 =?utf-8?B?bHRUQnVEbkRRZWFLeG41NTNvZHVLRTFVZzBoc2EzSXZwdFdJalBYVWl1K1NQ?=
 =?utf-8?B?OXZId3dpREJJMnBQVjZoYUJ6WHZTN2p1bjdvdmR6YmYxZE96TVFQYU51TUo5?=
 =?utf-8?B?WVh2MjlZQTRGU1N4a2FMVk9DdzYxYnZYTHNyNDNOU25HaGZaUlF6ekU5TThF?=
 =?utf-8?B?RDAxZDljZWVXaW5SUFdEeUx0bVdmR2FHcXFOeTBSa2pZYlZ4VGh5elJQeVZn?=
 =?utf-8?B?d0FDUXNabVVST2g2bzh2RGhIZk03R1RobG84S0NSQ2RPVjM2TndIcFhMUlBR?=
 =?utf-8?B?Wkg1Ym9GZE8yWWJaQUJLMWJzaDhXK0VqeHg4TS95OWFCNGRTMlpZeG9jZXk4?=
 =?utf-8?B?cGhnZlFjanJ4MVk2a0gvbXR6ajlHb0w2V0pxeXMwZEhMS1d2bEdacGpTbHJi?=
 =?utf-8?B?Q1ZuU09jRDFmcTFXN2cxL1dYT2FsMXZIanVlbXlySGowdGkvakhVZnQxL1Yz?=
 =?utf-8?B?UlBha3BUd1ZmandPRllrM1N4NzBsd2o0NS85cmxxUzFlb0Q0UW44U1FPN043?=
 =?utf-8?B?WlN4YWZ0UlF3dXdXMEk0ZDhYNXFkcWU4bzhrT1FFelczSjVQUlZVUStMSG45?=
 =?utf-8?B?UjloNzAzVWFFNTZvd3d2YjZjcjExd29IQWFNVksyRGRKdktUb3RUNlFCMFZv?=
 =?utf-8?B?WHNVeDEzLzU0b1ppMXFIRVduRWVHWElQdk9ucm9tREpiMHc4aktpQ3g0UlE0?=
 =?utf-8?B?WXFuSTFscm1aWlROTlRTR1BUd0R2U29GbWdGRXEvRmVDSVp0OVBDL0p0cWl0?=
 =?utf-8?B?OWpOZ0RkTWlqS3ByZ0FzWmliNkZDL2NVL0dsanBCeGwrb1dGV25OcHlRUHU5?=
 =?utf-8?B?Y2dndE5idk1IZGxIcEFZS0RRbm1lVEp6UVJGNjh4dGlNVTAxeFdRMG1tM1ZC?=
 =?utf-8?B?dDZGVjZ5Zml2cVZtclB4YTZzZTJBWi9jazI4L2ZhdWs1allCQUZIdVlIWFhw?=
 =?utf-8?B?NFlCSUNIZUF2YVF5RlVqTlBrTWl1NDd6OTlHRGJqWStWOExuRWRLVm1UTGRz?=
 =?utf-8?B?OEJmcjdrM0tYT1JRUGIzSHdKdTZseDRETWhhQk44ZllPRmUvL1RqaWVieUFQ?=
 =?utf-8?B?eG44NmhNNk02elRHaXk2SzZxZDMwUXRZZTRpRmREUUhOWmU0SHNTa2VRMHZv?=
 =?utf-8?B?SkQvSXZGTDMwdXRKN1dQcFB4VEpTT2ZlRVlrNkx4dUxkb09LS3Y1ZU9DUGQx?=
 =?utf-8?B?WUpQVXRWZUtvYmxJaWg1STZQczdiVFYxNFBkVmE0Uk1JcHdCNlp2WG1zVkpi?=
 =?utf-8?B?L2s2RW1TaktuN3A2NXVzYzQxVWVrazZqTFJqQWllZEU4NWIrRm9HTzh0emJ2?=
 =?utf-8?B?UDNKdi9lVFJGZlVibW5qSWhxN0VkcDZDOTkwN1ovTUNFNVNXSVFUa1krYVRj?=
 =?utf-8?B?Z2tFaTUxeWwxSzMxWmVTTU9QN3o3RnMxTGNZalVNcUFwcFNYTWRIRjd6Ry82?=
 =?utf-8?B?dWJwUVc0blRjWkJCeEl1SFB1Q1RlN2t2aExuRlJmVHR3aS9jdS9BdVM0dTJE?=
 =?utf-8?B?Y3hlbXJSa3ZBZUgxNW1LUXN2UGIxVTgySFEyWkZJZXRRWlBGMzkxOTJtNDJS?=
 =?utf-8?B?bTg1NEVJbytlTTh4QmR1dloyT3M2cldCSTMyL21nRmZsaVJ3YTZrdkZlZ0ts?=
 =?utf-8?B?ZVg1bHYxWEgvRjE5MVlyRjlyRlcxSDZwTU5LbjMzMWFVdVRMQ0M3Z0tlMTJa?=
 =?utf-8?B?c1V1ZTZQbGk3aW9ld29hTWQ0MTlKaFl6cGZwSEw3YXJ4anl2SjVzaUlkd1hk?=
 =?utf-8?B?aGFqdEp1b3cyd3NhL1pXSFFuMVphMklIRjZxY0JPMC9Yd2VKdkphbTViNjEx?=
 =?utf-8?B?OG9tSlFQU3RVQU1TNVBpYmhRY2M2czB0QnVmWUpjQktzL3k5VU85bFhjNzNw?=
 =?utf-8?B?UUxhNVZ1RFFUR3NMaDZDVFpCK21pM3pycG9jMnhTc3V2Z0JGRy9Ic0ZpVTF0?=
 =?utf-8?Q?e5+YVh?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M1hYSXZXNUczSXUza1NuMUtRZEJGcWI1UElnVlZ3SVZHMlhLYUNzdWpYU25z?=
 =?utf-8?B?ODBlSHFBb0ZtTk9ZTkE4RUQxcmdFSmR3dTJIamJuZytnT3cyUGY3dWYxRkhD?=
 =?utf-8?B?N0ltTHl6NGZqY002U1JPaHVvMldkWFhLSEVHejFpcjAxdGxhelFsSzFvSlE1?=
 =?utf-8?B?UW1xRUhwUFBNTW05U3FUQmNDRFlEYW83ZTRBQkY0VFlqNWFGVmVQL0hOR2pR?=
 =?utf-8?B?dUpWQmNXVlRJVExrNUxwaDhWWHBLWlRFUmMyOVUwemJOSUs2dmh6TWhWZXVQ?=
 =?utf-8?B?YUppQ0FNbzVod0xZYjRGVEZDTVRKbjRaWC9udGdFSXJNclZlQnlSWUhwWUYx?=
 =?utf-8?B?bmRkdjRiNElwZlA1cmQvQ1RBbkZmWW8vQmlNZWdyR2k2NUFRZEhHRk5xeUhX?=
 =?utf-8?B?QmlNSklPM0s2Z0lIWjlmSytGekdacmQyNUFDMU50ZGdzeWtTZkhCR2d5b3FZ?=
 =?utf-8?B?R2xSMU5IQlJBLzNneWtUVFptTmYzZUFYTHhQTzY5SWx0ckc0Y1VtR2lXMjVq?=
 =?utf-8?B?NzZQZSt5eVNtRWNoMlFtTFM4QkRIdE5ETS9pWmRhRm8wTjQyTjU0NDd2Unlq?=
 =?utf-8?B?eVR4UDRnWUQ2N3NuenVNRW9IeHZqeWl4YlY0MzI2VnJQRWhDUWVzdUhYZDRU?=
 =?utf-8?B?c2xTaDJ6LzJwNEx6ZUZTS2ZpQ3dtTTZta1krNkI2NlNSemVhNGowM1FNc2pD?=
 =?utf-8?B?M3pXVXJDeHlzZjF2ZHh3bzgvcDVTeUNyWlMzNmJPaDZHNkxCWURwdXNrNzYy?=
 =?utf-8?B?UjlBUnd5eUFYTmdRRVkydk51Nml0UkJ5M1dKd2NsZ21hU1lDd2plVTZIYy9Z?=
 =?utf-8?B?TFlteXI0d2xFNnNpR1E5Y0hxaDBpVkdWMml6d3FkTVNnbjJ6YlZ5dTJ4SWJu?=
 =?utf-8?B?U2ZDeDRiQnptcTF2T0o3U0kvQkExUHk0NVlNMWkwdHJNQUloRGZ5SVZoblMx?=
 =?utf-8?B?RGV1NXdGVkFxODgvL0tTck9vRUMwV0JhcTdEMjMzZkpPbm5aYjdjWkhBTzZH?=
 =?utf-8?B?M001RGdROUtlL0w0UWpYSWNTYnNEZjJjakNkNDB4elVpOWIxVEl4R0x6ak9D?=
 =?utf-8?B?ZHdlTGxqb2E4bmU4cGRBSkpYYTBRdStLR0Q4Qm96cmZDdUtqaXgrMkxLbE10?=
 =?utf-8?B?aXRkMUtUQVkrREQ4WlprM3k0V2lZV1dpMkdtN0lEc0FsU1VrWEorYzBjUmk4?=
 =?utf-8?B?L2VOaytFQU9VVS9HNW4wY3Y1Qk5oK1MrNGJwaThiWWpudjMrbEFsb1FOdkNF?=
 =?utf-8?B?Vmc1aEVzM3Avd2NBNVhzZTB6Q3BzZFU0U3RJL3ZGbkFjanVMNDVFUHNSZkcx?=
 =?utf-8?B?QXdNakROWEZqQ3FYSS9yd2lzaTRURGlOR3hyb0c5UlB6eks2MGs3aE8rY1JC?=
 =?utf-8?B?RmpFak1ZSDVVR3IzRFJOYS9KU0U1Vm1oNG8zYmVBY0hUUW5RYzJmM3R2TUtL?=
 =?utf-8?B?U25qQTFuSFgxRndNMENJbWhwZHJNVjBaZVQ0cGM3YzZnbWd1eUIzRDF0d0Vi?=
 =?utf-8?B?NzNsb0hXbGdydmFyMml5OS9tRWUvcmJOMFY0SXg4WTIrbm9MQjZ5NUJWTWRD?=
 =?utf-8?B?V2JaMjV3TWk0dDU3bWFyRUNmMkxZVWc0c2pNaGlUNzUvSG5zcVhGR0RFd1lh?=
 =?utf-8?B?VFZqYVkxU0FyU2NBRkY5NTRLRUxwdkZ0L2g0bE9jMXJqTlFaeHk4SHVBRy9O?=
 =?utf-8?B?U0FGNENhWTRORktBUEp1c0MvYUhkMkNzU3A4bVRlZjF4b2gvNFgwT1dOKytk?=
 =?utf-8?B?K2loUUUxcXJmU1Z6ZnpOdGFabEhCdVp3UnZsOEMzdTdPekFpMFJxbU4rUnQw?=
 =?utf-8?B?VVY4WmdVTGNUeTZHekJxbUNQZWlFeHl1dUZ4eVRZRDBQUFhaTHBpNDJaTnEx?=
 =?utf-8?B?cmF6eVI4bVlPOGdxZjBudVlhMDJTVnYyaTI3M0xKV2ptZmJrN3NWeHhNb2ZY?=
 =?utf-8?B?cGFkNkNhT0tBcEhwSFFodlVFZUdkMHRZR1VNQnFPb1dJK0dWS0tUbUxnSDZC?=
 =?utf-8?B?SllPM3p4OGw3NDJ3VmJvaFhMYlQ3UEVTTzRUNVR2UW1oZktsS2JyckxHMTFF?=
 =?utf-8?B?OXFlZFIyN0Z6ZnorSnZsbXNSbWhabVBzanJMTUFxMmxaZDYwMEJHbklmaWsv?=
 =?utf-8?B?Y3dsVktrdlN1ZTArSHpZRkVqTXVCR3dsNUtKbE1WQ1J2alZOV2RPNk1tcnEz?=
 =?utf-8?B?RlMyVGQ4S0ZDSGNrOFZPYTR1N1pycmdxZDFyVHFwQlRXTDNkOGpQN1JIZG9W?=
 =?utf-8?B?WG5hNHBTM0J3dG5YV3hLckRtcnFFZ2kzcUZTcUUvREJqUmtLN2pmRE84eitx?=
 =?utf-8?B?NExCczk4RGthVzNqZXl4dksrU1lFT3ZpTE0xd2xiWDJhYlhzR1YxUT09?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ZxLaJLIkHmok772YiQJJWDAPKEcXkYdfRWSTcjlUSVEmFCUbj0qv+cSnjOOBXCNEZejphPm6hiP8o/An3MWdp4934oZUSv67QPAi+pRGDfqT1jyybc6cx0uTD0MJhIwuYmT1LCTKBOIXWJ0UemfnE18OaSmfdHdNj9x/P/k38J6dUsgQHLR3UZ5PPInM0JOpH8XOkGhSuQ/7/4a9xKCmfx+T+1iTaVjXiwwZ9Vp/omo5ktVpilLDk/ZiCiyzmhvHTLMD3eGk22uMxHQI7GdABIF7QJU/hUcop4QoAfotNJTknr/rzoFSnRR2GVtXVl5X3VhqWAXMv5bR8lMldEfwN9cWBF3UnYoMv/3bSHbagTT7fAWJwWVgwMO4kVmzx9b6ASwAoe51KuoDDik1+by4vizKKby6mARjWoOs0eEiqRk69/c/WiKBP5qNc2CV1GBEVPrvJJoKKDAoXEJ2XrhkXYQ50hsE0Znz/bnKNcmjix297HgM0xpzRgO1r8ux5xk9AiY11J28uzC3wi+qmO1GlIVF2hFG8MtKvduIvwtw13zLgz9D2sV+RgxjPSy7dqkN0cbi9FsadtwbzkAqe1aTxjI85IGifngNk3GwJsmI0J0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f5fc47d-4993-4dd3-44ce-08de6aab0898
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2026 02:53:15.2836
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eZZwxElB1yxgbgZtd3IRCvzuBUcHCIcDKHVAu2TdsaSaTJMQq1tXUFtDeQjS/gQNfI3cq+5lZfPUk24KCvMPlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF8B03CE791
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-12_05,2026-02-12_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 bulkscore=0 malwarescore=0 adultscore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2602130020
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEzMDAyMCBTYWx0ZWRfX2jZuyj8PmG/H
 IhX/3HDqBN0zfIhRnUErIzKQnDxGiia1b6gONzVF44e0+nq70yjsjr1mYTvPijiwIZsocNpweSa
 wmuneuZ2KJMSfSnUdc03YQXGtK1s9osTvYqi9JO+PjLBOhCrEpjx4wVCVSgLUw3eHhcDky2wc70
 VaN7GQEFJuFDxrqZVMrGAQTL5x2GWt/hwYigzM6hVJjELm9LprN9jLC4v/slX0j7yZVNJ1cgMRV
 VTwf06QxG2t4qPiRxK1gVpekR66l0w9k5LKbehiSR+KNyq3wcp2StJfkmIZJSTaVPzXC2iYnKSE
 x8iSleqjGkNhwDv3DV3/yt4QnI84c/D1H4HrN3FzZ0iJ5cuUAo8wUfeuloNVQXIFmAp1ycSWZg8
 zLkur+zix5583bMDsHdbhd4qRaeJlIjG/GQJL//aWEMjrPxp3ydreg3/fwZ85/ZCll+wHfru9wK
 tDjSbnPFHPfEuXnUnp7KXvsBIMPOYoPk9r/6uugw=
X-Proofpoint-GUID: 6xWHgPkM-8yFXZkhMBGJwHqR2h52rylH
X-Authority-Analysis: v=2.4 cv=AqbjHe9P c=1 sm=1 tr=0 ts=698e921f b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=edf1wS77AAAA:8
 a=3g80flMcAAAA:8 a=1XWaLZrsAAAA:8 a=yPCof4ZbAAAA:8 a=hSkVLCK3AAAA:8
 a=4NHquoEuM3-4Q9iKXO4A:9 a=BhMdqm2Wqc4Q2JL7t0yJfBCtM/Y=:19 a=QEXdDO2ut3YA:10
 a=slFVYn995OdndYK6izCD:22 a=DcSpbTIhAlouE1Uv7lRv:22 a=3urWGuTZa-U-TZ_dHwj2:22
 a=cQPPKAXgyycSBL8etih5:22 cc=ntf awl=host:12148
X-Proofpoint-ORIG-GUID: 6xWHgPkM-8yFXZkhMBGJwHqR2h52rylH
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B3973140003
X-Stat-Signature: gwkm1qw4rnfbo9aibgh9tke8fx996c5w
X-Rspam-User: 
X-HE-Tag: 1770951202-230085
X-HE-Meta: U2FsdGVkX18xjCLwzdaXi6rE+KF6msI3oSIqmjMlsAaI4Z9j1c5fPJ34EBEkuUsykpGB2Qib+zUaqlz3UTPLC/IKBosRb/t0AwxXuiWy18Cfy9ypuoYfumciF4MhlKIbqYxN4jaHenzxojeQhUPDBtf9fB9i8SiBOlIt9bHm5JrnwpZHhY0nzArhd63VbdV1DAt7RJk93ygvtldap4PrKHciewGGK+KeKlhw1otrQhg64hwesc9py6wvTnECt3YsAujMHw4RMEljLN6dTmdBVFouHuJOEKrgP71tkwkQcOygKqQ58Fpb5LZ5j8ZC+j1oRZbyJUdpdo+ZPxd2ZOCeaby4CJh7ZO/vd9RzN+oKRYthm1OCb3op96tXYeEfCCb64civtcMd1h93KOH1zm+POHs/8GNCFiz8KneMggpxjrcm12iWR7aZmj5IyxygYe4UyUkf4SwVpAuMU6Z3UE98uHszigO9ujjkHgqPqQhiCDI747NK+0tWXzI+cvqNM8Hlwi4olbkVnVjbhCN7TE+2kMZQCTb53WLhm1xFr9G9LEqIx38mjoz3pv7Rm0oJ8MyUTmFjK26iNIiv6tKjAeN/thYhrzFM/TBkQacTBp9qVWQ9KAlRrTV+BhS3TP2lYTtSOSal3ZcatYepwNgdlwT7PgLndzxp8nqR9XF/SwL5uIaf6O2xSkUhfaUNe5F8UXF2ohSGvYs+u2jPRh28qKQSI3EswKY/DmjHrR0Pa7J0Lnoi/7FwgzA81ssJ+upJUcuoYTCn1hKiB3lcuBfAiwzeqkGTymety8ZTQ4IUsKl0lESVcfkeWlxw0ze6X1lyUa2znfC7EmgvALOhv7y4COPGHAOZIqp9a7NA9Kf014h+wIM1JYG+4/RlKpmANhzdggyxoumrZb+MikXgdihzL1LdIUraFJoCSFOL8Vc1JVadRpWXaTDwMPms1b8nk4YG9+UyFPe3E1bGBNDXNhgVssz
 BXcX6Y8W
 v/QrbCupQNSvXrIQfWNrxNUH1Dx62exXQncoLHblr1RuSl+nyswoUtTwzrcZs1gwFn+cQtwVtyHs3DPlW4nRTLvfj1yhQHM+2oTRE4c1BLq6/ZFlrkOF56zGZY1BAdOhoQbZliOH0KMHBkSwMCiCqE5hBpdz32PUmOFqiMXZ2pSjVrgB90U75r2dg03QVTrY260E5SsqzPYjZI40sMiHeBJnDz12OPWwkZLm1RUFf8JI1GFY8rql/IwT2KWmWeQOsa4duBYdyaSlE42NjLE3TmcVfZs6RxKJtAvE34xSaVZAUgSq3XberYOew0gA3SsR3fcfboT+T+F953xKceX1JHutpWY7cNg2twCQ00sPfYovS4s/oIG/Ys+/7cokFfRuSzBvSKhQO3gIT3MPnD9RSCaCKWhhx/2xf4cXmO4Ai2LlTyrxb8ZJBqIy+rHuLARsWcfvTLfpvvN/wCeLmypRQWHMWqg+8WJqc3rHsZB+lXS9QvrO8VoXhpieov1aCqH78k9Ll3EoxpmnQPyrMFZH9ce8v9sAfGn6I8oR7qNI1IFaZ9mZHDgCnJ+vccGmcVnB/JJvvtCjP4zatfCnxjDaswkmNjhSzIBRnTBhr8LHHw8Wip51bwg2ZhCH4+6/Ii7ZuZehnjs22/yyJU1+CSozBvA60PHTWJbGGigVqP5g+Z6KYE8OSpi0NDdSr5/j/gx0xvbcZ/YY86z1BM3YXVFTF/Bbeft1eEjLtwInaOM56QqttD3UE4wGXQa68ZNTl+SvWEBpQT7VMM0tOwJ4itJSUPnLAF4QNa/F+vPAPCHpGBsJ2icN5smpOP+ZGj7/mEOaK1DA0AdsV5UJAZoPvVsN1K2Jp6jIfb0kICyUhPsVEdCcgJtA19WPkoIwP4z7Tdv+0UudBjduScgjWsDoUCkgKrK3u8qDGnU360haRJlB5rGILTzg+LNqAPnQQxbqrEV83Z7cAQuXXuFNhkZino65IG9rf3H9Z
 E7f/Sl5j
 lk+6LvLpnWxwINA8VQ7ESRFrqpKeiUtSsJqzYDNLqHM3YR9u3MlQe4HuUCvTKY8TOhpmK6Hlv4ATRk0QicEqKufWe6yy0X0YdI1Y/1+xNWhyMxbm6sBKJKNNIOO4+dXgz4duKKsUwsj0igVLQam46iBCMl912C73ZiRZEQ7mJz5N/eosCONIMYbxCiHMf60E2Be7pAsoKba6TSPibhnqsOazn4gyqlRtVrXfycDGYbDJn/aphhqSpF0Tr8g3h7Y+jhd6pkepgTWBj3XDSECC602w+RLX0VeW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Suren Baghdasaryan <surenb@google.com> [260212 16:31]:
> On Thu, Feb 12, 2026 at 12:56=E2=80=AFPM Liam R. Howlett
> <Liam.Howlett@oracle.com> wrote:
> >
> > * syzbot <syzbot+54245a237762e7cbecf0@syzkaller.appspotmail.com> [26021=
2 14:22]:
> > > Hello,
> > >
> > > syzbot found the following issue on:
> > >
> > > HEAD commit:    192c0159402e Merge tag 'powerpc-7.0-1' of git://git.k=
ernel..
> > > git tree:       upstream
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=3D1304cc025=
80000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=3Daaa1d655b=
ee4457b
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=3D54245a23776=
2e7cbecf0
> > > compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils f=
or Debian) 2.44
> > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D13d40ff=
a580000
> > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D1704cc025=
80000
> > >
> > > Downloadable assets:
> > > disk image: https://storage.googleapis.com/syzbot-assets/a42150718371=
/disk-192c0159.raw.xz
> > > vmlinux: https://storage.googleapis.com/syzbot-assets/4cda72c184d0/vm=
linux-192c0159.xz
> > > kernel image: https://storage.googleapis.com/syzbot-assets/404b09fd74=
ca/bzImage-192c0159.xz
> > >
> > > IMPORTANT: if you fix the issue, please add the following tag to the =
commit:
> > > Reported-by: syzbot+54245a237762e7cbecf0@syzkaller.appspotmail.com
> >
> > This looks like the mm is not reference counted correctly.
> >
> > The maple tree has been destroyed via exit_mmap() while
> > do_user_addr_fault() is executing.
> >
> > >
> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > BUG: KASAN: slab-use-after-free in ma_dead_node lib/maple_tree.c:572 =
[inline]
> > > BUG: KASAN: slab-use-after-free in mte_dead_node lib/maple_tree.c:587=
 [inline]
> > > BUG: KASAN: slab-use-after-free in mas_start lib/maple_tree.c:1207 [i=
nline]
> >
> > This shows it is the root node that is incorrect (which is stored in th=
e
> > mm_struct directly).
> >
> > > BUG: KASAN: slab-use-after-free in mas_state_walk lib/maple_tree.c:32=
91 [inline]
> > > BUG: KASAN: slab-use-after-free in mas_walk+0x8cf/0x9b0 lib/maple_tre=
e.c:4599
> > > Read of size 8 at addr ffff888078907400 by task syz.0.18/6008
> > >
> > > CPU: 0 UID: 0 PID: 6008 Comm: syz.0.18 Not tainted syzkaller #0 PREEM=
PT(full)
> > > Hardware name: Google Google Compute Engine/Google Compute Engine, BI=
OS Google 01/24/2026
> > > Call Trace:
> > >  <TASK>
> > >  __dump_stack lib/dump_stack.c:94 [inline]
> > >  dump_stack_lvl+0x100/0x190 lib/dump_stack.c:120
> > >  print_address_description mm/kasan/report.c:378 [inline]
> > >  print_report+0x156/0x4c9 mm/kasan/report.c:482
> > >  kasan_report+0xdf/0x1a0 mm/kasan/report.c:595
> > >  ma_dead_node lib/maple_tree.c:572 [inline]
> > >  mte_dead_node lib/maple_tree.c:587 [inline]
> > >  mas_start lib/maple_tree.c:1207 [inline]
> > >  mas_state_walk lib/maple_tree.c:3291 [inline]
> > >  mas_walk+0x8cf/0x9b0 lib/maple_tree.c:4599
> > >  lock_vma_under_rcu+0x101/0x5a0 mm/mmap_lock.c:253
> > >  do_user_addr_fault+0x41f/0x12f0 arch/x86/mm/fault.c:1325
> >
> > ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> >
> > >  handle_page_fault arch/x86/mm/fault.c:1474 [inline]
> > >  exc_page_fault+0x6f/0xd0 arch/x86/mm/fault.c:1527
> > >  asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
> > > RIP: 0033:0x342000
> > > Code: Unable to access opcode bytes at 0x341fd6.
> > > RSP: 002b:000000000000000e EFLAGS: 00010246
> > > RAX: 0000000000000000 RBX: 00007ff2e4816090 RCX: 00007ff2e459bf79
> > > RDX: 0000000000000000 RSI: 0000000000000006 RDI: 0002000020003b4a
> > > RBP: 00007ff2e46327e0 R08: 0000000000000103 R09: 0000000000000000
> > > R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> > > R13: 00007ff2e4816128 R14: 00007ff2e4816090 R15: 00007ffc4f622688
> > >  </TASK>
> > >
> > > Allocated by task 5934:
> > >  kasan_save_stack+0x30/0x50 mm/kasan/common.c:57
> > >  kasan_save_track+0x14/0x30 mm/kasan/common.c:78
> > >  unpoison_slab_object mm/kasan/common.c:340 [inline]
> > >  __kasan_slab_alloc+0x89/0x90 mm/kasan/common.c:366
> > >  kasan_slab_alloc include/linux/kasan.h:253 [inline]
> > >  slab_post_alloc_hook mm/slub.c:4953 [inline]
> > >  slab_alloc_node mm/slub.c:5263 [inline]
> > >  kmem_cache_alloc_noprof+0x2ad/0x780 mm/slub.c:5270
> > >  mt_alloc_one lib/maple_tree.c:174 [inline]
> > >  mas_dup_build lib/maple_tree.c:6299 [inline]
> > >  __mt_dup+0x5a8/0xc20 lib/maple_tree.c:6382
> > >  dup_mmap+0x36d/0x1e20 mm/mmap.c:1744
> > >  dup_mm kernel/fork.c:1530 [inline]
> > >  copy_mm kernel/fork.c:1582 [inline]
> > >  copy_process+0x7371/0x79b0 kernel/fork.c:2223
> > >  kernel_clone+0xfc/0x930 kernel/fork.c:2654
> > >  __do_sys_clone+0xd9/0x120 kernel/fork.c:2795
> > >  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> > >  do_syscall_64+0x106/0xf80 arch/x86/entry/syscall_64.c:94
> > >  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> > >
> > > Freed by task 6003:
> > >  kasan_save_stack+0x30/0x50 mm/kasan/common.c:57
> > >  kasan_save_track+0x14/0x30 mm/kasan/common.c:78
> > >  kasan_save_free_info+0x3b/0x70 mm/kasan/generic.c:584
> > >  poison_slab_object mm/kasan/common.c:253 [inline]
> > >  __kasan_slab_free+0x5f/0x80 mm/kasan/common.c:285
> > >  kasan_slab_free include/linux/kasan.h:235 [inline]
> > >  slab_free_hook mm/slub.c:2540 [inline]
> > >  slab_free mm/slub.c:6674 [inline]
> > >  kfree+0x1c7/0x690 mm/slub.c:6886
> > >  mt_destroy_walk+0xc0a/0xfa0 lib/maple_tree.c:5028
> > >  mte_destroy_walk lib/maple_tree.c:5049 [inline]
> > >  mte_destroy_walk lib/maple_tree.c:5040 [inline]
> > >  __mt_destroy+0x2d7/0x390 lib/maple_tree.c:6446
> >
> > __mt_destroy() is called with rcu disabled because the last mm_struct
> > user should be gone.
> >
> > exit_mmap() is only called when there are no mm users left, and then th=
e
> > mm is write locked before removing the rcu protection on the tree.
> >
> > It appears that somehow the fault has the mm without holding a referenc=
e
> > to it.
>=20
> I tried reproducing on my qemu with the same head commit, config and
> using C reproducer and it did not reproduce. I think the only
> difference I have is the GCC version I used. Mine is gcc (Debian
> 15.2.0-3) 15.2.0.
>=20

I get futex issues before I see this issue - but it could be related.

I was planning to add some debug tomorrow to see if I could figure it
out.

> >
> >
> > >  exit_mmap+0x5d3/0xae0 mm/mmap.c:1312
> > >  __mmput+0x12a/0x410 kernel/fork.c:1174
> > >  mmput+0x67/0x80 kernel/fork.c:1197
> > >  exit_mm kernel/exit.c:581 [inline]
> > >  do_exit+0x78a/0x2a30 kernel/exit.c:959
> > >  do_group_exit+0xd5/0x2a0 kernel/exit.c:1112
> > >  __do_sys_exit_group kernel/exit.c:1123 [inline]
> > >  __se_sys_exit_group kernel/exit.c:1121 [inline]
> > >  __x64_sys_exit_group+0x3e/0x50 kernel/exit.c:1121
> > >  x64_sys_call+0x102c/0x1530 arch/x86/include/generated/asm/syscalls_6=
4.h:232
> > >  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> > >  do_syscall_64+0x106/0xf80 arch/x86/entry/syscall_64.c:94
> > >  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> > >
> >
> >

