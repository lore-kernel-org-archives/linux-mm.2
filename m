Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C9A0F013CA
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 08:36:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FB516B015E; Mon, 16 Mar 2026 04:36:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A83D6B0160; Mon, 16 Mar 2026 04:36:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7360A6B0161; Mon, 16 Mar 2026 04:36:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 612CD6B015E
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 04:36:45 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 03E28AF64B
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 08:36:44 +0000 (UTC)
X-FDA: 84551270370.28.5AA7FEE
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6F009140007
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 08:36:41 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=aa3eFjcV;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=IN92BvVx;
	spf=pass (imf26.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773650201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9QhQ4w1288WBsU1hlgIGQAFX0gOxw/Bh4kbkveNjRsk=;
	b=eA5HtwUsKntnqB1SMEhVboGj45Y2mAevYd2JIaMJTjxcde4/su+IJae5jHZdkdrergT5Px
	FxTWeSPjvRWMmp3N+5f5QGzq6mBEQZrfYUk6nR5bU84vkR6QJ/aVDx/Kg6PthVP3p2a+Ah
	NeKWv40f9TnCl77YEd8GbVRUk89H6/I=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773650201; a=rsa-sha256;
	cv=pass;
	b=k1bN6CXPP0GKwJ/o12RAqlpBkIEToNUF7kDhxDMb08CKUOXeDDdTAbQKGA6o0Nx+Kbz3OT
	uNLfDtW28yfm8OmDNmNA+UBe1OKmMypjT91LKv+mYvrpo7WCdCtmXSCnfDvFv5Z3ude3V/
	eJ6EYCiND6+GdmJdqYfXhH4slUW4CL8=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=aa3eFjcV;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=IN92BvVx;
	spf=pass (imf26.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62FMi7mk691391;
	Mon, 16 Mar 2026 08:36:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=9QhQ4w1288WBsU1hlgIGQAFX0gOxw/Bh4kbkveNjRsk=; b=
	aa3eFjcV238l+uGAYt5dklT63KQAPl40jyaMlT7P5EgdU6n2XN3igXQKucwOoEsf
	IeZ6vwE0OurO/JuOE9peo8LicS5uogTPrfH4LykPnfVzM7D2TzQ8vcD6PFY2VCoe
	/DzK+9x9jCZMW1fb9MlvuLAgELUQm9ANbXyHwPyN05uo664F+97oScvtaW5MWJ7W
	nZ8ijJC7glDteg5V6/DDObupVsUlHfV726kU0wApZByqlUZ19N2jnk1r1iIEWpAl
	NsKYrPcrN9kk1xai3KZ5WAJBwJsINS+/Xu3Th9VN7QlJinqblh6xhye6gmOnVrxt
	Cs3ItavZ5zCRGDe6pioVFQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cvyj61sd9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Mar 2026 08:36:23 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62G727Fe030552;
	Mon, 16 Mar 2026 08:36:23 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012041.outbound.protection.outlook.com [40.107.200.41])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cvx489w89-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Mar 2026 08:36:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KENDgKQ5ryAFICEcNCmADtd9HkMICESR/7IQEPYAUh6nh5AxByp7j15iQFDE0XGk0HlAvXIBDN2hTAtyKiWUOSGN/Qjo6tKyv80uBuvAPVJVUujaRSoKXOVdofbiHVAdrnaJ5LiYXhR79bAsaV+v+ccW93Qf3El3i3IGdKUMVyMp8jZuJ+4kk53me3bEzl7ZuQE9rotP+I+KuUfaJSLg5eQWc1dh3/PndxSD4TMJwgqQrPAj/BFjhQbs6ZHzGBiP3AVz066h1dsCE7NffB0KXGlGR3/CgCh+A1GrhEHuqup158m4D6TqwDgtBYtHuiC32cnQ9I9MtFwOoEDXGz/K0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9QhQ4w1288WBsU1hlgIGQAFX0gOxw/Bh4kbkveNjRsk=;
 b=VVT1gNgdyLGJ7XP0yKXqdqLCJCzdX6v+tlBWWEqYTUaeJJXCn0QZH8aVtq/1hpa8sTEDxeOHHF4jF+U1OooIRmq94HwA5ZUZgDxSLcE5k6jxlD9mu5m9VT2FNqD99Nk2edB33OaHhq/ej7dFi+TVw4Vi4rcAleXuYZjHJXipTT0x9kdJ2b3TiojT7NR5+/cuXVpJLTD8qk7uVEvis9lZE9o9lfi0J+y1wjCM4PAvs6MwTmjrAtXenO4OCyq2yFhk7N9/d6HdKvKb3mcTxlfmfpJGxe645wIsotWhwu2S7XpNHdobmJxFiAd+nDE4MDkNbUy3bhkHyNfDzTTZfetQtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9QhQ4w1288WBsU1hlgIGQAFX0gOxw/Bh4kbkveNjRsk=;
 b=IN92BvVx2hgRjeD5Lj5he1GLZEQAuKVesWFkgQlU0/Fs+cECeQVGT9lkRWt03o+gnS+05aM1uPiVq5jLei4nBKcPfIqTp9Dy473ThntavqXKphmSIhRVzSchA4dtvntO+OXD+mWe8f6wD2LdROAIPEFeY4BBQqx+82zHVa1IYfs=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by SA1PR10MB997580.namprd10.prod.outlook.com (2603:10b6:806:4b9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.22; Mon, 16 Mar
 2026 08:36:20 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9700.022; Mon, 16 Mar 2026
 08:36:19 +0000
Date: Mon, 16 Mar 2026 17:36:08 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        David Hildenbrand <david@kernel.org>, Hugh Dickins <hughd@google.com>,
        James Houghton <jthoughton@google.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
        Nikita Kalyazin <kalyazin@amazon.com>,
        Oscar Salvador <osalvador@suse.de>,
        Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Vlastimil Babka <vbabka@suse.cz>, Edward Adam Davis <eadavis@qq.com>,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH v2 4/15] userfaultfd: introduce mfill_get_vma() and
 mfill_put_vma()
Message-ID: <abfA-AR--cvpcz5v@hyeyoo>
References: <20260306171815.3160826-5-rppt@kernel.org>
 <abe1FHyYinvfLYnw@hyeyoo>
 <abe15T7cA1B9lG4F@hyeyoo>
 <CADhLXY5ydBZL5gUQZCJnSTgc=8U0Xhaj_BtvgdBtPSmWh3NTEA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADhLXY5ydBZL5gUQZCJnSTgc=8U0Xhaj_BtvgdBtPSmWh3NTEA@mail.gmail.com>
X-ClientProxiedBy: SL2P216CA0175.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:1b::6) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|SA1PR10MB997580:EE_
X-MS-Office365-Filtering-Correlation-Id: cf492bda-6c9f-4898-7e39-08de8337189f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	7IqFKhZK+1FElMCrLrXNuYlo8TK8TcxWnnihIMekHKU928PHnUZpZn4p4f+qrTuzWRPLMIM1R+cKyj64fwtL/aoFDQy6GNsFYcY7ACg2Vy3tKoLFkmyb3SP9Bk8QqPZy1xes61HsH3Zrt910lCIQJCk7tuPp9fmfYyF/OworZWMergZL/rm+JOsK1rdfe1zsBDzoJNp2sMhhBqf2s/zVtCa9jyi+Kkwfv48WWkQztwVLmK3vuGRXQT6pxwNyymapkINNhNXeQmsAs879BX6403qh13NCocL3yMqlecrhao6ky/aE9Nr1SZqF1ZWhWgW8wY2cL2WtGZGIaO0+yk1GSD7SCBIXg9hqJHXs4M5J3MtNf9fUPnMaWIvEeH9XbRr5laqwtVdwFpg/MvKrkL1ozCaG3GMpafjH5+7mQi7FbE6iceiPhWm4Vvh4aZO3AJUewPaUbQS7QzQ2RwiO6EMu3YIi7rVk/R70RU9hWRtkXjKJp2zpFvL1De/wkqi4t55pYUq9GS4H++szdmd/ORG6RxJ3qf/1kv/8qzu1DttmF4GF4to/jSHyJNXnQzoP+aaLqaUK+d+xFShPbkCuKQcdwVEl8bcP24sduuUAh6iK2qHJ0FZ8Mf7GfVk4UCgHf+enejyfYDAqgf5viCZWzuuUyCn1y42G/OUGj9/lRjTsnD2z/HxwWKwnA8sn/7/RGLuGoB2sI1GyPNKb9ffNEdqP1yWIBL+5QAQ3DinjRofdBAQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NExXdE42c1NOV3hsaVlLZ3NLcWhTRWlCZmxOOFhMaWFCZEI4bkQvc2tPSXYr?=
 =?utf-8?B?K2hHNVVRQ2wvdFRpVU0xVlN4SUhiMDJEWlYycWt2MmhkOGFmaWdGZzZLdzln?=
 =?utf-8?B?MXZObzRtQVN0Vi96amtna1doRWtZY2tqYnQ0dFZwSUZLbEY1UGF6d3luZWEw?=
 =?utf-8?B?dTJ6aDZFUGxtcGVaYlVWM0Z0YzV4KzNvN2tqMHNFcnJ0NHM2OFVadmFQRU1D?=
 =?utf-8?B?NDhxZ0syK3A1UGtLTG5veUM3enB4VjlDSVF2ek0rT2cyTnFJbWoxN29TMnJo?=
 =?utf-8?B?QmpxMERrd2ZDUFFhSTYvY05VbDF5N09TQWk3UGdocFlCRzhCejVkQzhFVTMr?=
 =?utf-8?B?TGRSVE0yckdnd3llTGZSVzZtSnl2QlJ3UmFreUEyTnJYazN1eXpGVmV0N0lL?=
 =?utf-8?B?aWdUV2V5SDZoRnR3TmtaeG9nTzZRQ0ZSQnVGamYvWWhVeGt5dDRLVk85RTNs?=
 =?utf-8?B?eUxxM3JvWkpvTnZUV3lVdHkwMkxHQ3dLd0k4aXE2THJPSlppUmJQMW5WN0ps?=
 =?utf-8?B?bHlsclJrUXBHR2ZUR1FtbzNadmlTZWJpc1d2blFLYmRjai8yRjFQNTZuenBF?=
 =?utf-8?B?a3RjdElQRHZPRFRYY0laenBORm1ya2s0TlNFbnAvQXlnZmM2ckZYSWZ1ZXFU?=
 =?utf-8?B?SDRWY0N3b2s5aCtTekFkdVE1L21vc0NCQU82OHlSeUhwdmJyOWxQeGJFa0VF?=
 =?utf-8?B?YWx5VEZ4aWVmNnRDVUNPNHNpdDFGbVZtWmg2RENncW1yM0FoU0JFd0N6UFdD?=
 =?utf-8?B?dDVNajBqcUllZS9Ic0pzK2pqSzYwbC8zU3NhYkYvVFJkUW93cVFEdTBCNzdw?=
 =?utf-8?B?K0JTL3FQT1F0em84WlZ1eFptd1V3Y3Z4OU54ZkxmSjBqUzBGQkp1OGd5LzNG?=
 =?utf-8?B?aVBuSHI0VGpQWXdqTGVKM1R6NSt2aGI3enp6ZEpvT2pmWVJIVEgvVnRWRTRC?=
 =?utf-8?B?ckw1L2UrbWFBWGlWeUVPOTFFeWk5VHBrbzNTc21lVHZaN0p4aXlEMWI5TzJ0?=
 =?utf-8?B?Z0JDN2h0dzhuLzViY0twVzhYV29oKzJoSXo3cVBuRG1MbHNFcFdpS2R6cmZl?=
 =?utf-8?B?eXV1cTdvR2JiUzNlUGYwZkpPM2xrV0s4NnhlMVlKL0xXMkdQOENsVU1nUXZN?=
 =?utf-8?B?VytyT3dMNjZUTkRib1NzNWI1azFFT0RtZVpoMkJadGY1NDZsd3dDdGxJcUhC?=
 =?utf-8?B?RCs1UERlejhCM1JyZFd6bjBUc1JZMXV6OURIekdlZm1EKzVuckFkVVhDWC8r?=
 =?utf-8?B?dXU4bFFFdy9nMUdaeVJ3UVl6b1V6NDI1MlJBM0V3MTlDaEVZaDR2bjRSd0w2?=
 =?utf-8?B?dzNaQ3BJdTg2SUVQMkZtRzg1SjJVRW1ZSVBjQ3VPKzJRaGlqclJKZjhJSGgx?=
 =?utf-8?B?b245cUlQRFM3VE5PNHhQTlZCRzhnUFI4QU1qeEp4eUlGcnRiSk16YXE1MU43?=
 =?utf-8?B?M2ppQXZRUEtBdlB6a3JtWFAwaElCQWFCTkRDQVc5aDVCbXpqZTF0bisraTVB?=
 =?utf-8?B?ckJBMFYzclBrU0tnM2J6Y2s1ZHlYZHc1Wk02STkxMXltVGgzcHF5czUvVjg0?=
 =?utf-8?B?dTh1L2pBMFhCSTgyVEh1UWNER0tJN3Iza1FVY2Y0RTRCUmVIQ1ZzK09jb2JS?=
 =?utf-8?B?bm5pcGZYQWJEVTY5VjNoZUFWWGhVRHB3bi9mYXVoOHdoekFxTkR6VndNeGls?=
 =?utf-8?B?ZnVBdllVVm5yNWtmR0hGYVpWRWlZbUU5K3VjNUhhQWpxSkhMcjh0TjY4VGF6?=
 =?utf-8?B?SDVSK2ZLRWNiTVUyckg5QlEwRWcyaUFiTFlnR2NXalo1dWRWR255OEdZeDk5?=
 =?utf-8?B?VWVKRXByenZHK1FYbjFYTVVubng5MVU4QklvanlTYTdBWkZOaXp1WWFyZDJa?=
 =?utf-8?B?RnZXTkF5Rjh5Ymo0WWhldjhHYlIwTWtmQ0Q1aFMzcmRWbnNNS1lkYnZwV25I?=
 =?utf-8?B?NFhvOXZON1o2VFVqdTJ0NDlaTDJJVy9CZXdiTGlDbmc1cWdUaERyUFpGbzJn?=
 =?utf-8?B?S05haHRzTlZWWGdpZGVzZDUybDZwdHNlVWxTVG80bVlXRHRzSUpSZmQ3MWdM?=
 =?utf-8?B?eFJzOVExMG0ycHZjSzhQZzNJaFBwTHc3V2ZkTUNUWWY0K2pYeG1SUVcxZ2dW?=
 =?utf-8?B?QmNSNU93WXNFNU5na1F5bE9MYmlsaUNTaHZTZWdqY0VnWURaTW1SU1BuZG9n?=
 =?utf-8?B?RWVscFp4cW15TloxLzAyR3BydmlrdjV3N25VaEl6S1BrbldnNWFlUTVEVS9Y?=
 =?utf-8?B?MXJzNGVDdU5jVkxycGJwQm1wSXZpZ2VNbGZYL2wwMUF0Q1BiVVh4RlQ5TFJ5?=
 =?utf-8?B?V2VyMFFqM1FqdFZhZnRsd3ZUZXhkc0hPNGRncDA5YzZUcUxGNjRydz09?=
X-Exchange-RoutingPolicyChecked:
	hvPxlb/cIAjgFsib6hpZtiENmSgro72oYCpgai5adY51jjY14G4ZUQiGMWbFv2gsxEaW1EWsic199W90zzeoSYjHjcrMl3mzSFfVX9FSEZi+NDAEanxNUNzN+IQpc6UZV8A47g2+6bFN1VRdU5X34m6Bjl7lBZdnioCJ0bRk33qsFegjG7UorNr9dCcof//0rdO2NKtC3o5AOKJ6fhw5IMdZmklaMAW3yuE0V4CdCfOwlNRI0M8JJbZzCxOabq+nVAj+24EkK3ZxMqFU4O7q2Ed72LP11OxwewpEIwBZeaT8YDFV8hw1EXta36nkc76iULTXm2EijzyR/I1tlkD6RA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	0AzGcY5HVCW7wm+v6nUmWBiwM9thTTY2t+6LntbSDq2ZYj+9w8BcBSaPgdcfL/KUpHqQPR47wRqiH4p3eEGu4OMc854sjwkQz+wSSP6j+w/SsstxpBmYvNtbC6CpcjC1pSFO8IbrWJjzK6+pFoECYMfFbmu8k/xY9120/9fJI3zXRyBBMHgHc5Y0fw9/bNaZ+rnTWzKt7paKOqYcQos9/ObgvrqfqIm47JH9AI1xOC2RjQAUymI65sUf8pHxzElVPgZUUUNcIARCxs8zexr7cL5sQLId+1k74AdXE6H2UUU3bsj5F+glXes17s2hFcI9qr8ei/zn2JS80iW8whNBCVmzeAF7+WcCVD/16IjzVoCTlGCXpFzjGsmrRTQhRlVYfrJwJn6GQSSADW9LMKnMEVRGRf54CDYsOcgwGjYqlZr2lJXXUgZ4wGOA2oEi7SIvF1nc4wbjDcbb+7SwDtObZCJ2k/L1Pe0dsD7JZD99/Zoua7BPtN7+NQuC3uhWHn0lf8t/cyFyEkOE7Zy62JGW5zeMgWnzuO8qeg4IFEAk9ZSd5Pzz/YokLNiUByVp6N/dwc3IgdNc/ceP0GtwJOLwEQTT2oPEr5llTr7pG9+LfCs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf492bda-6c9f-4898-7e39-08de8337189f
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2026 08:36:19.6147
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wpcu+Vg3cf1SD2mhXO7O99g7/YlBjOrRdIdQ7AaLC6jI2SV3yqtorq21QxDZQpWrMOKUtfbDFCGm/Bn0ioVoaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB997580
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-16_03,2026-03-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=888 phishscore=0
 suspectscore=0 spamscore=0 adultscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2603160064
X-Authority-Analysis: v=2.4 cv=LKFrgZW9 c=1 sm=1 tr=0 ts=69b7c107 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=VwQbUJbxAAAA:8
 a=pGLkceISAAAA:8 a=yPCof4ZbAAAA:8 a=IY1PVCeD2uZor9gFxm4A:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE2MDA2NSBTYWx0ZWRfXwCaZe8jqDL8c
 S6ze/prt387rnlJ62xMCxWFp1lJFHxzZXh7VsnAGrEXKnW9rHyQEGkhmkKv44C/URE5q3RgC4sy
 AN/kDmVDXU4UlHhbif9yzuWHJaJoNTF6m0KLw6ftpz3JcmkZVoWe21+a3tyHrJ/5OIDs0/E2JL4
 uQGvuJNAHnQMinB5g+tkta4AM0mFukTFeUYMxIJKFc2k41x3CRTbSv/Bgf7+q+DVZWFM57EuvH4
 gZJaFFjaHMBkxcl73gaZFAnb5ke+uuBWRMfzVbe8k2be4+N9p5KoOw/qYVIJ4PnZNsN8NQ4i/h2
 Qbdmpuh5XDheKZ3Enp6XfeAC2pL9JfjzH0FtYPQ6SEItvucrMRzqb1GC7nMo9zsV19rf8Gly5HQ
 RbxGqfsPXQF4Y9ZQ8z2T6pTDeXe4W68wFKubGfg2FH2rKiyl04QI2DXIL9Ooi9LBqBlItr5z0P9
 jnuP6WyAIzPHtebWwkA==
X-Proofpoint-GUID: EmKyW0nZgnr35dbAcaELlJPhkgDWiqFz
X-Proofpoint-ORIG-GUID: EmKyW0nZgnr35dbAcaELlJPhkgDWiqFz
X-Stat-Signature: rzgz4gfmnyrob6qj4saau3wfopyw1ne3
X-Rspam-User: 
X-Rspamd-Queue-Id: 6F009140007
X-Rspamd-Server: rspam12
X-HE-Tag: 1773650201-290332
X-HE-Meta: U2FsdGVkX19qu7QDhUFSiHTv/saU6C86EgmIKwSCMiFgtS/fBRQEOf4VpRAzTGqOqugfE+IAe0AlM0qfE+WVAe+ZkXzuA+vBK/EhUTRaGTxHTJvF+BUISLLs89SLrAqJS0sldTUwAgr2JVMbfL5ntM1sLdJC/YYRqo9F771f/MmBr3zDgvP9TiKXvsImOSrQIpcthqee8fIprWlX94rl3ugXxBx41KCc38DDebZxqfK3W5mifjI8ERh1ugX/uAuB4rI5Eou99scBB+bnfmp0FsZA7KBzIt17Iz5EeFl1UimsppVr9wyN4iq0HEWnG7E0I2u93Lg9G6YQldwzFIeDJRx2aeOW0yMBh1H/z2hMA3WEmwOrFtZ0fBX+A277WZKoLTVtgkz5SWiGbUlNRPFKeHjX6zK0hM4Agt83/k/kryrHdO142dbj2GVFTRTH11x1TXZr9YJs2IoeozVFP6xrNgZWqnQRd7/3Fzapo0jsvASTVd2fdwiPQOU4UCBYAfNIc/d5PdDP+TKcTZ024sizG+rI0UWZcOKQlj0YJFpPaJKFQqgcrNHkWaqsZ9mEAg7bAY9J76pVp9VGOgTchzPSnm3t1KPUVVITzmCsQrn0NLbJsiG9wYZ6Xycuo3KB4P2IYDLmRDrAzgcSnsCxOTOcUeuF6WIIoljk9vxtPt80E7pEN9jTmEdQWOyrPAuJQ0rIuWZO1mIMNewQMisZ0el1wnmx1cSOj5Mb1Xnevf2mz/t1DRKLFb0sG4cIKiWbmfEVEtO/SpESxKz7nGbAbutXwxVLFSFHr+ejLg4PD0IllyTYGjsjMJ79Fhgp/h0d90ac4s2jQerSAin1MCU0+kUGr3hDvwvsbspQATxeoz3pw2dSCC26kqCqcSW9BygXCy+GQU+6TO/MeZkmlc+wAfMvVWHsL5DFbfSIX8GjIcUL3j91ozrWDybfcOlWxT9pZ/R8X1/ovDcjs8oRmW9iUX7
 BRflyQDK
 RWmOqzNuvCPNs7BO2UBNK/ui3LgM0itruDxxckaS9XKLwlCugAlQgUY26Qawo/SVArlMAkwZ+qTgfSTOtpmjh+8TvKkhIttXkunfTVl+QaY8Z+4WfODhIOBhETjojiZFHTow7uWxB/3FE4ig4aHmSZMsB9/09czbBCEBRpz+MwWgRLDtMen5Avs4Vg7tc0i+Zh1RBxVkZaNP8BBhUfYGjdlRyDpwLJOHC2F3lIJuAFhteZHSojXtXacN02GOEo6qLfk5Si7fi6cFlNSvADLD/DTga5h7TkSybSAVLjSImmXFM8Q0TMiu9naARbXSnmStLHLwI+KMCG+Bk7TN73pZdmzu9UR2efro7crcKI0rlT0lerXBJx0EL3T3F46D8vogeLKZiEbuDYgE8MBo8Uskp5SsggNHX6Ta/tOpw9my0sprJPlsb6XjTCzZFULGSw5CqEyLvLiP/7xhWnkiGS/IzlCLDu3r5thiB0gblHXS/I0reWsNdV0afWcsan/5LtApFdcNXW2E9hlDeXBQeOhVbWdFwIvXHadYdNrcfTe2vwmh9uVRX4LLudU1HPaAzaGY8n8yhdMj4qdZe3jUv912gWlbWqj32Nq+ibhKYFNbzopJrD7beAztifDH/1anweZdGq/ALcLCa4NlIID83IklqXhCUSPx9jmOsa27OLtPIuErWk4OWZo55dgh4TkEeCjSlVQFIM29TxT1giyCDKSw2YSbYEmts4xuMPynWBHnvnp4FH7UMkF4KNPZjRKTQ2uSiC9XjlSMNspa/bzT4LgbKoPcnAm4Cm1FnFhq6PWesgwJJyok=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 16, 2026 at 01:35:38PM +0530, Deepanshu Kartikey wrote:
> On Mon, Mar 16, 2026 at 1:19 PM Harry Yoo <harry.yoo@oracle.com> wrote:
> >
> > > It seems there's another attempt to fix the syzbot report from
> > > Deepanshu Kartikey [2], which I didn't take a deeper look.
> > >
> > > At first look [2] looks a bit wrong way to fix to me though,
> > > because it allows operating only on a single VMA nothing should really split
> > > or shrink the VMA if somebody is holding the VMA lock in read mode
> > > (and the validation of the range is done while holding the lock).
> > >
> > > [2] https://lore.kernel.org/linux-mm/20260316070039.549506-1-kartikey406@gmail.com
> > >
> 
> Harry,
> 
> You are correct that once vm_refcnt > 0, nobody can split the VMA.
> However the split can happen in the race window BEFORE vm_refcnt++
> in vma_start_read(), and CHECK 2 can miss this if mmap_write_unlock()
> completes before CHECK 2 runs.
> 
> Here is the exact race:
> 
> vma_start_read():
> 
>     /* CHECK 1 */
>     if (READ_ONCE(vma->vm_lock_seq) == READ_ONCE(mm->mm_lock_seq.sequence))
>         goto err;
> 
>     /*
>      * RACE WINDOW: vm_refcnt is still 0 here!
>      * UFFDIO_UNREGISTER can run:
>      *
>      *   mmap_write_lock()    -> mm_lock_seq = 11
>      *   vma_start_write(vma) -> vm_lock_seq = 11
>      *   __split_vma()        -> vma->vm_end = 0x4ca000
>      *   mmap_write_unlock()  -> mm_lock_seq = 12
>      *
>      * writer completes entirely before vm_refcnt++!
>      */
> 
>     __refcount_inc_not_zero_limited_acquire(&vma->vm_refcnt, ...);
>     /* vm_refcnt = 1 now, but vma->vm_end already modified! */

It is true that vma->vm_end might have changed before acquiring the vma lock,
but it doesn't matter as long as you verify the range after acquiring
the lock, no? (that's what uffd_mfill_lock() does)

You're not really supposed to read vma->vm_end before acquiring
the vma lock and use the value because nothing guarantees that
the VMA is stable until the lock is acquired.

Or am I still missing something?

>     /* CHECK 2 */
>     if (unlikely(vma->vm_lock_seq == raw_read_seqcount(&mm->mm_lock_seq)))
>     /*
>      * vm_lock_seq(11) == mm_lock_seq(12)?
>      * NO! writer already finished and unlocked!
>      * mm_lock_seq incremented to 12 (even=unlocked)
>      * CHECK 2 MISSES the race!
>      */
>     return vma;
>     /*
>      * returns split vma with vm_end=0x4ca000
>      * but vm_refcnt=1 (lock held)
>      */

-- 
Cheers,
Harry / Hyeonggon

