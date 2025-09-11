Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C936CAC58E
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 16:57:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2F198E0006; Thu, 11 Sep 2025 12:57:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D07098E0001; Thu, 11 Sep 2025 12:57:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCE958E0006; Thu, 11 Sep 2025 12:57:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A7FED8E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 12:57:04 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2E72311A440
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 16:57:04 +0000 (UTC)
X-FDA: 83877574368.02.C34117E
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf17.hostedemail.com (Postfix) with ESMTP id A5E0F40003
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 16:57:00 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=hKR6jUis;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=cpP+ToBW;
	spf=pass (imf17.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757609820;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fXszz9JiTr783qrCsXAaNr4B3fqvpsIWk3gbuClBbEo=;
	b=3lpen7A2D/s9e4IXYvzvJGC2tJVCrD1/YCma/zgT0cDRfkKgoX4Eu/FfarFoA6y+HK80o2
	41DQ3UiVWo3acHA3GSIgLFWSR6/3+kEVWl0BGdf1wAU7Km/UXWNH549Te9b7r4C7XAnKbP
	xcjWztpsNYbqQKD4cfJTfs32zUuEbEM=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=hKR6jUis;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=cpP+ToBW;
	spf=pass (imf17.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757609820; a=rsa-sha256;
	cv=pass;
	b=lmTfEcT/qohuTGcvapXktqz2WqLOP1jw9Y10QYrIe2c+EiX8n9Z+qSmmTqAy/JGMVPyJmz
	y8LCFuL86Eacr9tq/IK3s7qkPx+7ydVoeOFxBL41DArfC8g/FelAXBqTGxz6UfkhnXmBAN
	RTXZkd7cle8vwgjbaIt4TvTgyguJiqI=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58BFto2a006015;
	Thu, 11 Sep 2025 16:56:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=fXszz9JiTr783qrCsXAaNr4B3fqvpsIWk3gbuClBbEo=; b=
	hKR6jUisRcm9gqOw0m11FN0kDzuLLv+SlTZ6TD12ZnXBFQR2BfYZLsr2E3RhOrtL
	mnqLtNcwIzmL6yz7e/CD3xiRFiTmy1imeJSY9czS1Kai0JKn5JasCVlAnMysV4D3
	HzMDDBfV+NBdGfuybOUmIzm6P3Zo6mNj2aCdyg3mANeQF9SWX14EqczRdJQ7A15z
	+Ot8HUV+OF8J3NsOX1lx4k/Uw3xRsYdl/hjT2jDWFBv9NUeh+snMqpUavLMDzKAc
	iZcX9INZdeEM60O3G8UV/tr3akbYKqiofPfzw/c+1g6EvHfZEHKVLfra0YngQBkq
	elMJ7WIX8nWVdwdq3H/yJA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49226sxqby-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Sep 2025 16:56:43 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58BGW7XG012872;
	Thu, 11 Sep 2025 16:56:42 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011034.outbound.protection.outlook.com [40.107.208.34])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 490bdcw2dq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Sep 2025 16:56:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KB2pLkqM9NpYdyx7y097CJyxiSZnvvSB65xQTXRmwDqPxC0xNAWW0kuLLo7mo93aTz5nTjDUJflP13GmD5tx64FTVGVua5Dgp1MTdmGvVpo82FEL0D7SYT2T4mCNmyRLkEQcVko1vEIiWtMcU5/SK7xuAd64LTBvoJ895MJMrOD6sXZn7kgu48jYXL+/Rp51dIpy8ZYte4TfOwHJdZR41hbq4mMp1f/Rou6tq6A++SrvXNUk1dnicE6G2vpPaxTVYqykxfcdGtvn68hqJc42Qv+oEJNspMmo5H5KTMza9ptH0i/gHCGxMVOXj//pKllk2Hh0PmXp+8qQbj3KdkqzBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fXszz9JiTr783qrCsXAaNr4B3fqvpsIWk3gbuClBbEo=;
 b=xmLS8TyyIFsvUJNm+eHvBcYvvjBxkHmrg22Enjh+GlpSAIj/cNdryco+FgiovN7tzsj4/lTthnfDsvTbt+0WceCpqyJ7YdIPfuHVHGOMXdnYnWtpjoQR0TLrFpZkFi0Fq6pWNL8KpB+hy5kV1KYKXVQ8KMglqLE0umX7Xwc4VT9yozr/ZQGhgduZODGyezKDX+OiGt5zc0PIQGeckqwO4j++azWf2SgoIqLAu6kON15P1iyWx0vvKfJ1DOkTy3yux6+5wUhy4n+fvoKnRi4R6bdd43BFLsi0t0RTMjvbZPf4WD/6p0PZuXNqhdOt3tawWgKtskMeXurNUNdRNorfUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fXszz9JiTr783qrCsXAaNr4B3fqvpsIWk3gbuClBbEo=;
 b=cpP+ToBWXcs9k8QN1duuZVds1N341eNc2ZTOMxmlNUcQWTZjbChSqzZZV36mOXP5+BSF9j3KvRMFFdeSa8WApST80xr39qPpcs4P8XU2wGd3zS14A6KYNBp+l1fwIAmjwlGHKWxfaJ3uAeWxHR2SJT88oYC0KlxmIoiqClZqnVo=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by IA3PR10MB8516.namprd10.prod.outlook.com (2603:10b6:208:57d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Thu, 11 Sep
 2025 16:56:34 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9094.021; Thu, 11 Sep 2025
 16:56:34 +0000
Date: Thu, 11 Sep 2025 12:56:29 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        Charan Teja Kalla <quic_charante@quicinc.com>,
        shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com,
        bhe@redhat.com, baohua@kernel.org, chrisl@kernel.org,
        Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v1 7/9] mm: Introduce unmap_desc struct to reduce
 function arguments
Message-ID: <aw6vbshqvskf6lwql354dc7xn4dh445uaadbqoydzai3rnbbc7@j2lm7ryywi4o>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Suren Baghdasaryan <surenb@google.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Andrew Morton <akpm@linux-foundation.org>, maple-tree@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, David Hildenbrand <david@redhat.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Charan Teja Kalla <quic_charante@quicinc.com>, 
	shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com, bhe@redhat.com, 
	baohua@kernel.org, chrisl@kernel.org, Matthew Wilcox <willy@infradead.org>
References: <20250909190945.1030905-1-Liam.Howlett@oracle.com>
 <20250909190945.1030905-8-Liam.Howlett@oracle.com>
 <CAJuCfpG4D4ikZO1c8zN7HNgLTAco1ggk21rg9AUFwoztA95qSA@mail.gmail.com>
 <dfd8b8c6-d697-4032-be2a-569b9629c564@lucifer.local>
 <CAJuCfpGFXbSFnqQtikNq0RoMfc93cLLnqrApq8211H+FpZpJ1Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CAJuCfpGFXbSFnqQtikNq0RoMfc93cLLnqrApq8211H+FpZpJ1Q@mail.gmail.com>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: MW4PR03CA0215.namprd03.prod.outlook.com
 (2603:10b6:303:b9::10) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|IA3PR10MB8516:EE_
X-MS-Office365-Filtering-Correlation-Id: 38174564-edf2-4480-9181-08ddf1542a2c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aGl4L013RzNpNk4rOVJiajlGbTcxNjdjSWtXdnFCR0ZGOGlScjVWazdLVGJo?=
 =?utf-8?B?RTZDZzRDd0JJclRvbUdUTGVRbFd1V1RCM0JqbkNjR3BIRE45MEJjK3ArT0l4?=
 =?utf-8?B?emVOVGYxKy9Ta3VPVmRVeDVGazN1dGRQdWxoOFRJcmc3cDhpaHNIa0pzUzRX?=
 =?utf-8?B?RnZGM3QrVjQvWTBWaVBMUXpwQTNPYmpjZ1hrQjc0emdUaHpiUWpkZTNwTXh6?=
 =?utf-8?B?Ym9YYXNRK1l4Q1I5ZzZhWlNLM0RDOG1aQ0Q2ekRhbkNmY1NoWDVhcXFGKzB0?=
 =?utf-8?B?OGNnNnRjT3lydnFNZEEzZTRaM3VmYkNhUVlOYzNsZDM2WWF0cHQvMCsrQ0tv?=
 =?utf-8?B?MVowZGIzSlhvdTZFQkZKQjJNc3pWY3B4dkhCS0hjMnNyUDZ3UXJNaVRpTVB6?=
 =?utf-8?B?aVFNNTVINjZkMWk3UGtsTjdnK1hUWlJObWc5bXRqTmg1UUFQMGRPdzZyWWtn?=
 =?utf-8?B?UUNJTUdlSEhXV1hoYVhRZ3FwVERJS3lOZDhtZDZTSTlOL1FJVDhCZXB6YStM?=
 =?utf-8?B?eGM1dFpkMDJjVTcyK25jWEZjQjdNTE1IZGpneGF5RS9KbVZ5WEtZd1JjWE96?=
 =?utf-8?B?dlF6bkZka0VaMUJSa2hFeXJJSzVPT1Fna0RUbzBGUUU1RWNoN0hOaDFJcllq?=
 =?utf-8?B?bFFPVFRWWGhWRFR5UUhBUVh3bS9kV2VYNzRrUjBXMlJRbXpKWGZpRXJrOTZ6?=
 =?utf-8?B?QVJZQ1V4UjdwbGVYVkxoTVJGcGs2V1p4YWh3b2wzaENGRlRIdkk2SGkzNlI4?=
 =?utf-8?B?eDg2ZVhPWTU4UkcwSjRtWEJNR21NK2FiYnM3LzlRdW5PVWNheWdlRGljU3Vt?=
 =?utf-8?B?K1lzZTBKR09oQVRnZ3Fha2xYYkJpaVpxNkZtellOTlFDVHNkd0gvREo2aGdK?=
 =?utf-8?B?OXY4ak1rYzMzdi9wamRlZUR4K284QWhYSUpvT0lUR2lrQ0pTZWtpMHNwWDZ2?=
 =?utf-8?B?ek5pOUNaaWdXZHZYcC8vL2FjcFhzTENVbVRuY09SdFIyWFB6UnNwYmJFb2Ex?=
 =?utf-8?B?TTBBNWI0bFhiTUhXbkRRaGVkMHAvVVpyVEp4RndmUFI0Ym1FeXpMMDJ5ZjIy?=
 =?utf-8?B?WnE3bEJORjJpM1lkc2dJSmlxa0FBVGJHanBxTVJCN0dYN3hEbHZSZlg4ODIv?=
 =?utf-8?B?L2gwQnZWNWJRZ2FGZFZBZmhKRks3NXpndlJwRVdycklIRzZLT2JJOE5ja0dr?=
 =?utf-8?B?TFdGaUFVZURiTW9YQ1ppRjNucE5DUHNUZzNHUWVhK0ZnVEFzMXptc0NnbEFz?=
 =?utf-8?B?b0M5MlJ6cmhVNnVtUkxuUU9QTHlsZmFqaWsxdExRREdLRXBBTE94RStPRG9X?=
 =?utf-8?B?aUNkeVVHYm1VQjFMcy8yYWs4YjFISTUvRzBZdkZYN1JCeXBOQTExdVRSQWYx?=
 =?utf-8?B?bUxxT1BMaSsxWG1oaG5HSTkrd2hwaXJPOFQxQXFpWE1seDRsRUdtc2hJRVVW?=
 =?utf-8?B?Tk4rSi94WHFSTEZXK2RhK0JnU2RkcEM3QVZYRkEwTi9SMUdSNDBkWGFVYXY5?=
 =?utf-8?B?VTFQRTRhUXRSQmk1RmMzSTF3SnhHT0VMajV1WnBBRUI1TSsvTzdPOFJGaGZ2?=
 =?utf-8?B?Uld6eXlqai9JL2VncFJ1V1RJOFluMzgyL2QwbGt3cVZPMFBwcnMvazV5ZDc0?=
 =?utf-8?B?U2JOcklwand3TWJWSk81bjFCeThueXhaWkNtdHRHRTN0dEM2SnZGWEFWQVFX?=
 =?utf-8?B?bGMramhJMlhTMDNxY09TZkRpVWlQdkt0RjkwcUs0MlNiU3hhdmFJZ2txSG1O?=
 =?utf-8?B?VkQ1VUdFdEZTWUhEV2NQK3hIYnN6RytDTlhVakxSTit2RzJMdWpIUVVMek9D?=
 =?utf-8?B?OHl3M0UwbUF4dm9wMlJVa3RMNXEwTWF5ZWxpRWYwTWlhUzhPNHZmMG9WTDkz?=
 =?utf-8?B?c3d3Ny9DUWd3dUZsc1ZOWTBxa3F4aVZxUENEOUE0OWw1OWgvWUxyYXhLV3RT?=
 =?utf-8?Q?MHMmnN7nWwo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ODNTbXlsQWdtNElBTElrUVl6bU5EaTRFWHVLVmZtaWJWRDgzSTNwbG5Wb1U4?=
 =?utf-8?B?RHo4U0pHRHJZSTc1UkhVMlNrVDZGWnJCWTd1YmtWdGlab3pTR1loc28rK1Rk?=
 =?utf-8?B?TnNDdFRQOWI1Y3Ivc1IvdEJWZmtFclJhVXJ6RjdkNFV3eUtMKzlvZmNabUNx?=
 =?utf-8?B?Z1NVSno4TEdQSm9NV1RIakJuem1DZTBVeWlzdlUyaFVESVJYeitMOWZkamla?=
 =?utf-8?B?Wi9kVzgwMDdlSzE1bENQVDRFWmJUR01uWmQrOUZoMzRtNEg1a1puQ1lXbDN2?=
 =?utf-8?B?WXh6UUE3blRrNTRFcThadzhQVnNzZTlVVmFHMUdSdjRJd1BrZkpnMzYvaWdj?=
 =?utf-8?B?Z1pwNHQzWHdMdTdTNjB5bC80WVdaclVkL2JSRW1IMDVnZTYrekIwNkM1bWw4?=
 =?utf-8?B?bTF6QTBUMXd6cG5NQVVKdkxLb3V3b0E4REFBQ1J2UmV4d3gvYkdIU0oxaVhm?=
 =?utf-8?B?ajJHeHJOcXA4enVsRitrRldmTmIwOTlZRllhV0lFSHhwY0RTa2Z0MEErYUtq?=
 =?utf-8?B?Ky9vSE5zeERZL201V21JNUhxN0FZWURqcXBQK3cwWldGVmRLMFo1T2VKUi9K?=
 =?utf-8?B?WEc1NkltM3NldVF3bERYS0hPUFVaTnR4T28wWG15ajh3Q3B1R1RXZWhnbHll?=
 =?utf-8?B?Q09vSTlpWVVYbEtiOWJka25KSVBid2VHbUxHUzlQRVBpTEpTMWhzblA5RTQ0?=
 =?utf-8?B?dUhrdUQ4ZVdHN1FpbHVRdXlLenFKMFJPRzBJSGs0c2lxUW10akMzenpqQ2RP?=
 =?utf-8?B?Qzc2OXk1Q1k4bysxeEJaSW0yZkZyclppL1N1U0lveWV3MlZPY0dhQThQN1JD?=
 =?utf-8?B?b2FONjJiSnFsQ29JdEFrSXIvK0dTd0EyVVZtMWZDaTB4VkQ5NVRwdU9iOG9X?=
 =?utf-8?B?bmJMTWlkY1ZyRS9xcUN4a29vaHpDUmg4TEE0c01nY1BDdE5seXNBMzdvbjJN?=
 =?utf-8?B?a3doNGVmcE12U0lFbWEvV3hCUkNIdXlOTzVHZmg4SjIzTis2SlBlWjFITVJt?=
 =?utf-8?B?V0pmMlZVN3QrckQxQXNiNnJUcmMvUmJMV2tjOC9sTWFFTDlWcVBiVkJJaUQz?=
 =?utf-8?B?ZUtId0hya3dQMHc1OWREYStLYjR2dkJ4RlY4dkhOSjRKWVBrTUtQNFM3bkpy?=
 =?utf-8?B?K0JMdStpam92S3B6WDIvQnBiRTRnU1BlTmFwNER5UmVxR3RUSkhSampra2RS?=
 =?utf-8?B?RVl5QWF3bm5ibTVLT0E1Y0VMRU1PSHFxS2hKbFRTWm5SYU9kUm11aiswQXJZ?=
 =?utf-8?B?aC9JTHVDdVZXeS9rZ3U3Vkh3WjNrSkRodDEvSEJuTGJOUk1qZ1pKVEc0dDUr?=
 =?utf-8?B?QXNoLzMzOVl2cFJISUlyblpEU1VDazZDS1haV0ZydHFvZHUyMXZnemJOZlRC?=
 =?utf-8?B?RjNWUlpMcjg1dWszcHljVGc0NzkrNmVBLzNXNkJQTG1BdkdLODE3Q0ZGd0RC?=
 =?utf-8?B?R0U2RWt0aEszdWs3MmJxci9TVDA4SjcrSi9jRm9LUlBONlBtWkU2YWxneC9W?=
 =?utf-8?B?emdEdC9YYWZJSThFZzhBbm1Lb3NrOGdJZWg5OTlzK0dPeTV4SStyTmFMTFpu?=
 =?utf-8?B?ckpZZHF2U2RhZFRUaUpkci9qdUpwU3MvZW1ML1V6TkcyZjZoRHhvWFpkRGNN?=
 =?utf-8?B?RnBXczVwelROY2pQVmIyYjQ1d1I1cmw1MnFOUVRQdXJQb1ExcnlHTS90R1RB?=
 =?utf-8?B?OG9PZm9JZWdLOFZWZ1lINmVQemgvMDVwZytOQlZPVUVGeWIrMndhLzJ1Zm1m?=
 =?utf-8?B?a0RwZkZ4UEZYZk11bm93ak5aZXJZd09zam9jMVhieGltOGxKaGNmOGFIRFdj?=
 =?utf-8?B?ZTVORGFxTGQ3cWJ5ZGtLdEVJanlsck5QWGs1Q1ZPaEY3SExqUTlnUU85Tjkv?=
 =?utf-8?B?cnNzWmcxZUo2LzIvaFJRR1orb1lmWEJvOVFtZ3Y3SVB3ZWtHT1lTbnN2RHVl?=
 =?utf-8?B?WmZZbW52YUlrcjJPbWlqQ3czakkzb1V6VHFLMHZ5d2N2MFRrcWRpQmpxNDVk?=
 =?utf-8?B?ci95RTZJVnZ0QWYxNHluZkhLUFRSUUFjZTZYYi9scXRrNEN3TENPaEpiMXl0?=
 =?utf-8?B?bTNRbVE2K0UzQlkxZEJnbExPc0JiQkcyRzljbktyUCtqZEpqTm5odXFDZHI3?=
 =?utf-8?Q?T1D2Zi8B6IzV8sf1x63aFRukk?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	FpQwQ/XX9V3xTkDj9DjMDoU0W/HyP8k5QMfZcjsxI68kKFoLeYHLzuI98pKLbBwOOO/8Z58X15VGnP78YTIE7RBG8YJkH5BT9TpFZvqP3aHqTTrpoGnTj1+Dehya1U7wnpuvSrc4kvBG+Z+CESVCPpb2BMpRozBDL8v069hVVgl87AbOYKjHBmfhyL54TWDvxeieFphswMJLrJ3fgIyXzvj+Ebxvw4VOtC+xer4WyURp2NPIDUCOmn8BXhbkMYVSF2Baut8SiDGssLIkqZeLX/PWRVE7WDI1/g25tOiX6YDApeMaKDXL+UYNFhagGnYr3Q44JL9p5FVb8fZqgSJP4J6tsetoWKd4hxg8CB/N/u/EAqcjQhX+TyBaoAUEGzLsuyYGuVGFRt2WXv7KrJdu2wvQapRR1xBWzZWHtFqB9H4k8tzVrCFzs/NKL+KKiRuiYkuhqVdbVZV8pmjGdeeV4Kvgtp3dQlSmjwPFqxWjzjmrJW/oTOG8gK0o8NRBkwVqfEwMLMTWZ57+JkhD2s8zD/PRMMWU8wDGUgELRDNTKsGILH3F+jEXfCJZiwQ+uDJVRNFze76LGt4ZdlQrKJCIgiZXq1p86GzofOi6S6E+Sg4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38174564-edf2-4480-9181-08ddf1542a2c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2025 16:56:34.5827
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5dyCNxQGB3bpxmosFU9zFISXULAlgwpv9U7Hb2jFhSmJkdzu5vI6nGOc9zrszNKFDXoCRXTW06vSYewYyXaN4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8516
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-11_02,2025-09-11_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509110151
X-Authority-Analysis: v=2.4 cv=QeRmvtbv c=1 sm=1 tr=0 ts=68c2ff4b b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=1XWaLZrsAAAA:8 a=yPCof4ZbAAAA:8
 a=EAlW-bju04SoOorWpwoA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: XXMr5IOq-NE64knmaV9nSrah0r3ykZrK
X-Proofpoint-GUID: XXMr5IOq-NE64knmaV9nSrah0r3ykZrK
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE1OCBTYWx0ZWRfX4BMzGMtVTLm5
 nG43BOvs13rWBxI0wWwRB333NXPkKmY0zCEHG3KpM/9mAd/bdmEk59hu6Z54z42kIIw3XS7oGhF
 uQdCffEC/JydP/ECOoyO4TTaF/kS8ERpSU3tK7YHpX6X4QtBNiCMpJAjThJmcOo6t6jfsyvMRlz
 eT+iZnBsAAAT+hVKF9SUG1zOoT+aRtLTYGvSxiki18KN0m/s4dBJMCltETPpQq/El6KJrxTl4Yx
 rS1xy8KEH3lWFIhzX8axQ2dmFG8RPfaLXTTH69austyhIHi3+bx+BNJTpiOAs8ire9Y9ylkaLZh
 aOR+hd/8pHJdDgP9/QYRr93fjThfm8rcdrSt9pJDaJ8UrN73LSfCK7TjU6MXn1CRg7sJZVrJAum
 Gl5FnW4d
X-Rspamd-Queue-Id: A5E0F40003
X-Stat-Signature: 79nrjhkmob6yakm6egt6g3yhiyrk8j1g
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757609820-848638
X-HE-Meta: U2FsdGVkX1+cSmBwYGQiHSmkIWnJSgm8Xb2LhTfF/UaFSu6OJh8lGSTCyfGfqWPBlb6uyNzA1gGn1JDUbBxaVQwBDe0dQD49gL5nsZUvbUpTWLK6aoX+MWiP2bEOnSP8Shaf8LasJSNRQtNRh2Kg3HxUjVWyJNp81vCuqGF6xmKkRgehzOv5IGzeV6MkiNhr31HizWWCINJHRMRlXqpVb+HVotlgCGQxJaZtZboWuPVswF6jpL9F4ba28JOVSD7Xsxx/VllJ77edvbMVvm0PhYHB2hKT9h1DpBiU3ftLl8vKmZdWClwpWQuYW51mBIn2NMs0gcefXfiWDlxq0s4K/sWmluAOWaklqXJFVqZZOsbAzNgUwFN0HgyIInamoYVLnpesQuaFgwdGqbNjq++vYlZy5Cwn/juFGgPWFbwJZv9QDVQ3YZjZAWpF1Ma7H4ik8fACNXFdW8MrQJjBfyKIoTUG1RKGbt6rt9Csb1YjmZwpbDsiSxzppefsY7qSwERx0gRNLZmS/rxgU7QVdF9dAU6hFmFld7xHMEoUZ0hHWPahtc3AWnAdE3O3fEdjxvUG/pOC97ofnQurq+H9SRg59CA7UsjWzm38PXUBK0v686R//41Wlr6KynLaZ1qZPSd2H/Iib6/NrdXT/nz096Pf5oVVvdoUcU7D/1FcfUfJpFPU6dN1tDgHZKxAtF116nfSVEA/+jj3tdnf01MrBEYz9d2IKpAPP/jAdIZPpu9UafZZUbfWFx5eoU9jWsVPmYIa1mqQjOP/h2GezjIPesU5ceh1ZNk/qYZSbT80E33une1NESfGI/Zvnt7mv95z1fE1BBXRwMy9Ojjq5GJCw/0i98NBd+uqS6XyJaUwv0DapOezVsBO3QHySUWANe46yq7IOQzx4oXVsaqeqKmJre2hWJSlI2sGaCSevWYbBMHL4PC5cnFdx1LIAf23janvNGewjfenbkUoHjrehF/Qs1F
 pyzK0FF/
 XfwWGsrCzgzVOfJOYR+ng4286E7g+N6zT5N+ZjrvBiaWGpISp43wbmFjTxxc4lbQQ2wj6dpgO2F2XnS452m5aGy61PReykpZ1r7XuNJ9G2O+xW3ZpTG5TRhSUesh6+qT9/y4yhhHYm69t5mOJPYuDmvdw6vq43Y9xfDhlSX7UGlns2rVRF3aGwsbVPeOzQ0G8YZrkG/0hf/NhIQ77/1q7En5bHARyEmhizpOkXQ1bMAnngrCBg5HP4UdRFDUeYRepnsCPFWZzPyfvzlrObS57R9b91CNvsgH+UBFlsFXgjbxT8xG8uuP2HWhNli3B4/tqWJcYsNffFYvxSnN9i/xkAijl0vtAriVMMR3FSAYxw/Mf4nAVt6NIH6Sj1eAtF/J11k30/oRycgdET4xmr47NSR9FCzMzhXRdNe0aQHeAHk8aSniyLPb4pujft8m1YqACumJ/KD/hwFh63UKfrGr/3324dzMaZ14jQZQ2uLX7Y5+UP48P1kn2berx27QUoFtRIywJX2v+RoXabk5g0+hRLwp5GRXHTI5qCfpAW1TxLFDF7hDB8bXQCJOe4oGUdKgbc8nbu2IHB9s2GklPy8K7KqM5ruQvieFDQHO42Rv+16COQnx99Y9Mp3AhgAcnxhiR+xauMFKa1ANwPGI8wXEgaOSU7QFcOVPl47JmAuN0f3qj2xepTZLfqDxo4Y4lZqsiNt2N9Nu2GIOJdc4AxNctkfDJuIyaqkbGkS59ivsusyxSg3rK2GxEcuMLh/MUQFJ0Gb3SnGQSpo0eBoZCUBv4T6PkhxS4LyJ+EW6epQWzLhP79JWYRmizb9O94A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Suren Baghdasaryan <surenb@google.com> [250911 12:51]:
> On Thu, Sep 11, 2025 at 2:22=E2=80=AFAM Lorenzo Stoakes
> <lorenzo.stoakes@oracle.com> wrote:
> >
> > On Tue, Sep 09, 2025 at 02:44:05PM -0700, Suren Baghdasaryan wrote:
> > > On Tue, Sep 9, 2025 at 12:11=E2=80=AFPM Liam R. Howlett <Liam.Howlett=
@oracle.com> wrote:
> > > > +struct unmap_desc {
> > > > +       struct  ma_state *mas;        /* the maple state point to t=
he first vma */
> > > > +       struct vm_area_struct *first; /* The first vma */
> > > > +       unsigned long first_pgaddr;   /* The first pagetable addres=
s to free */
> > > > +       unsigned long last_pgaddr;    /* The last pagetable address=
 to free */
> > > > +       unsigned long vma_min;        /* The min vma address */
> > > > +       unsigned long vma_max;        /* The max vma address */
> > > > +       unsigned long tree_max;       /* Maximum for the vma tree s=
earch */
> > > > +       unsigned long tree_reset;     /* Where to reset the vma tre=
e walk */
> > > > +       bool mm_wr_locked;            /* If the mmap write lock is =
held */
> > > > +};
> > > > +
> > > > +#define UNMAP_REGION(name, _vmi, _vma, _vma_min, _vma_max, _prev, =
_next)      \
> > >
> > > Maybe DEFINE_UNMAP_REGION() similar to DEFINE_PER_CPU() or DEFINE_SPI=
NLOCK()?
> >
> > Look at MMAP_STATE(), VMG_MMAP_STATE() for precedent in vma.c
>=20
> Yeah but UNMAP_REGION() sounds like an action while MMAP_STATE(),
> VMG_MMAP_STATE() do not. Anyway, whatever works I guess.

Is UNMAP_STATE() okay?

