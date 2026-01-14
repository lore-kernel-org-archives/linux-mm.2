Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AA6FD39000
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 18:33:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D61976B0005; Wed, 14 Jan 2026 13:33:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0F156B0089; Wed, 14 Jan 2026 13:33:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8EE76B008A; Wed, 14 Jan 2026 13:33:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A1B636B0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 13:33:48 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2CD7E8C0CF
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 18:33:48 +0000 (UTC)
X-FDA: 84331418136.08.3E7AA0C
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf16.hostedemail.com (Postfix) with ESMTP id A9827180002
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 18:33:44 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=oNZsMg60;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="q/oKyBYc";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768415624; a=rsa-sha256;
	cv=pass;
	b=xyxX5m4BnLOfEW5eZSa7MZ2LbZaFYJGF0zylbaKmvdFFeVuRM7ZL4Qv3/4AAHkYPi9/pjE
	pr805tb2ykwtndDErMr3f5Hf0aW4qqLUpQR+TSX/Vrg/qKd6qZyI5myprqSGCfGnr7OPGG
	8cEq0K3rHRT/UIvRDAGVWwuHm1i/ikg=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=oNZsMg60;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="q/oKyBYc";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768415624;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FA6+cNJR32p2qMzNGf7u7qtl1704gaCDGnaGsTx6a1w=;
	b=6OnVbtg1rjPI6wuv7of1+CcRvPcHAlInyk3qk1klfEawjKoOl10b0du6RjWh1Zzt0TeYNU
	ieFZ8hAd8ocZBAdGUOubRtVuQY3CjguVmw468rn5qzcLYvVuq7+PAH5Ep2e1aMJcQ2nUZ/
	K75UUqKKo0rbAwLNA9w9wlW9LG0RBXQ=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60EHs3gW2863589;
	Wed, 14 Jan 2026 18:33:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=FA6+cNJR32p2qMzNGf7u7qtl1704gaCDGnaGsTx6a1w=; b=
	oNZsMg600yNHSMTLvnwSpbKyuAClWztMIDGX17WeIQiVePmAMff+nrwbe0tqr22d
	/ruogJpKQHyO5NLHo8fvPaM6K/B99MhrpHUKSYM7lyxuPUFle00NeTTnZxUk29kp
	PRKlE8N1noOspFhQqX6zgnplDbL5iuTnM6Rvr4f24DVpX3EwtkiClvUQN9wFV4XW
	pQ/tbZinN9aljwUrd1j6DxugmGZvIWOluBRHXlox+vbtjGYFXhFU51t59kZXct66
	p0gpmtJVbv4ZznTNOP/SXHMyMkzk3VQYn/Uy3OPiH1VXID2DYhgK1/6A8iXJN01B
	aXqFUHl0FZJkkouLTsD8ng==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkh7nnvnx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jan 2026 18:33:39 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60EHRChv029103;
	Wed, 14 Jan 2026 18:33:39 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010061.outbound.protection.outlook.com [52.101.193.61])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7m5dnw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jan 2026 18:33:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O4My/65lU8N2vbpLM+w1d3V7nYBtvr3XEJmPYDygU09YubAMKVZNNm3A1wg5YT2lRM754dStYaYacz0nzAOoz/eA5CPS2Sc+43lv8I3e1WlbnMBoTjDSDObPwdjUxFKvkiLgrEWQJe6Xi5bOvsLIEcMOtb17EkH87q6FQcvSdCBaK+GEbMocX5vvFGuPE2TIWUCWhoBNeCFMiAjOlYcvWdoY+RQiPMuY+JfNkoscW13xfyC54WAYatvK9abX3fzXg+yoK8pE2Vktk2GGVu5KnO5Kz8FX+f+Cxa27LKW5OlnXQDSxIlUmT+UCBH8Vi8Wf3roXgUMm9VGcu52wJ138vQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FA6+cNJR32p2qMzNGf7u7qtl1704gaCDGnaGsTx6a1w=;
 b=VipdQztSTUjaHSoUsNtNdL6DE9bZe9tAyqrekVBrsEnaJGf7dVTWNZqioQPASEhwOcaFlhhvDn/NxERz0bLimnpCf/k32oLMWgltFJAiwKa03m/Y5wYGoy/GqH8DXhF4zEwS+tM6xqPyYaFJc/dd6BcqycTlcd5BaAcr6oPz0VycK8ZHChT9a+ev3XMVDVQKYSQ7O2Bj5qdjRcT30o3k9M52em2RB7fMqs72L7e3P5TYLR0yPpfpbupWb0pwDcAKAV6RhPd9RdOvKYHsLEo5gP1zlKU1dyWLl2mCb6ctF1e1gfDTh7wdyhuzRtzThRdT8L5uuIPXPcHPM+z27kZSIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FA6+cNJR32p2qMzNGf7u7qtl1704gaCDGnaGsTx6a1w=;
 b=q/oKyBYcbNxX1bYSlBONdgTeOFkLhll2OssJK5KJ9IfAtA5PYnOHZNtN/y/VkIGzX57yow5lxAA9VCTmvcccmOh3fMmF0r5Ms0cV+4LPuvVovVv0KzjqTDBHwJ+sn9fkHmv1NzBvZfaT2txmCOmbRtuSnp5yFmPxfM6C34hLpbU=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by MN2PR10MB4286.namprd10.prod.outlook.com (2603:10b6:208:1d6::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.4; Wed, 14 Jan
 2026 18:33:35 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9499.005; Wed, 14 Jan 2026
 18:33:35 +0000
Date: Wed, 14 Jan 2026 18:33:39 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>,
        Harry Yoo <harry.yoo@oracle.com>, Jann Horn <jannh@google.com>,
        Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
        Pedro Falcato <pfalcato@suse.de>, Chris Li <chriscli@google.com>,
        Barry Song <v-songbaohua@oppo.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/8] mm/rmap: improve anon_vma_clone(),
 unlink_anon_vmas() comments, add asserts
Message-ID: <3da4df0f-4205-4f69-bd3a-cebfce5b6f9c@lucifer.local>
References: <cover.1767711638.git.lorenzo.stoakes@oracle.com>
 <5f55507a877028add5fdf8f207f5e333c7a3fc85.1767711638.git.lorenzo.stoakes@oracle.com>
 <CAJuCfpHoNdg4p__pmdsQepzxSpLe4j_7s17=Y5bicETacP4a+Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpHoNdg4p__pmdsQepzxSpLe4j_7s17=Y5bicETacP4a+Q@mail.gmail.com>
X-ClientProxiedBy: LO6P265CA0016.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ff::7) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|MN2PR10MB4286:EE_
X-MS-Office365-Filtering-Correlation-Id: 8638b8b0-aa21-46bc-3196-08de539b6d29
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YnhxR1Q2SFJCVHorUGZwMTYzT2dOQnBwZ1N2bkQrczc0aUxJTlowNXRYVVFo?=
 =?utf-8?B?M3NkTUg1bVVnU0VPdXA0OExKY3EwTXFXeDZTSVBOaTJVZUJaWFRod3A3WGhv?=
 =?utf-8?B?U09ZeFNmcEdtWkFuV2dibExOUjBWdml6UkxnV2hSWXIwSEdybG9KV0J1RTJX?=
 =?utf-8?B?M1ZrWFlKMWNPM3l2VWFrQjZpd1drQ1QxMytnUE45WDVKcUx6VVFQOFpuSE1I?=
 =?utf-8?B?OFVQbDR5ZVhjSGZtcHd0alhGekZVT1ArMDZzZ1l4dFB1VnlzRFZLVTkxMk8x?=
 =?utf-8?B?dFRVWUh6MFJmMlRiNDZqOVA0dEpqRzB1SmdoMUpuY0Jhc2ZkOHJZa0lUMDdN?=
 =?utf-8?B?QlBldlFhRERHeGtPYmthaVY4SWVVeGtIMTZ5UmlBZFBHSEVkQkhKTk5wNHNV?=
 =?utf-8?B?dHd2SGQ2cDVic0lxVnBDWHFiYnNmM0pCUWhTYVhyWmU2T0lsbnM1cHloT3la?=
 =?utf-8?B?WGJyU0NIc3ZtT0grQTQrN1N2STVmcFZtclRhbkNib0Q5dnhqSWQrU2RUYXdW?=
 =?utf-8?B?RmVORlVWWWRJbFlKY2hGY0pqb2lxNTF5dzk2dEErZTYyWXk3TlpsTjVmNyt5?=
 =?utf-8?B?MzBtSkZuWjFTbFRrYlR3d0grVUl6NWZiYVJjZFdtZzl0SFdZTUpBNENNaXlV?=
 =?utf-8?B?di9lalNDM01jOUc5ZUp4WUZuZzFxeWdtZlJ2UitkckNucHBHVjFEZ3JJMlNk?=
 =?utf-8?B?cHMwcmxMVVBHV0thRzZJekoyYjhoeTZYYzhWL0ZOS0RHY0VmU2lqQUhvZHlD?=
 =?utf-8?B?Z0NVTnNJektON0lMZ2lCRU9jbFEwUDFsRzVxZ1lFVXhNUlY0WmhtcWwzNVNy?=
 =?utf-8?B?djRrWkJtNzhKck9xQm1jRWFXZlhOU1ZKWUVYcWtLYng2dEVDZlB2M3JMS2Yv?=
 =?utf-8?B?Qkh5ek5YN094MExzTFJkNEkxa094dThqZ0FFVjJhbk5vU0xFNFljeUVSYThn?=
 =?utf-8?B?NGlqdmVvUTg4djJGS1lFMUhhVU1ORGFDUGhoRFFkRDc2SkhPQWZHd09nWnBW?=
 =?utf-8?B?ZlhtRTRoWUpzbjYzekdVTUZ2MEgzMmVzUml0bE5LaUdGL2ZEU1pNOVR5a2xK?=
 =?utf-8?B?dkE2OEgzMUY5ZEE5QzJLM0JkTVVQR2xQNkwwSGw3OFhsSE1jTmNvaHc4cGg2?=
 =?utf-8?B?NGhZazVsZ0dGUFdic1R3ZENYeFoxNlBud1VLODdRRmVXNFhZZGk1aGZpTFl5?=
 =?utf-8?B?bGdJQmZPZ2t6VmRuRUsrRktqK1dzRllGMUkyQzdTMXJ3ZjdXZ1duNUFKKzBv?=
 =?utf-8?B?bGZLYnJTMi9ZOXF5cDc3bkhaSlFBQzVvSzNiN0h5QVBHVUV0MXNrbHlGRUJS?=
 =?utf-8?B?dkFhL291ZXU0T2d6RlA3NVMwdFh4WlpDWGtpL2x5Z1M0QU4zLzhzSzI5Y09K?=
 =?utf-8?B?emhSSkJSOEk1cW03WUd3WlV6cFZZNU9pK0xrTGh6RWpaMW1OZkxaa3ZjWEpI?=
 =?utf-8?B?NlRaR0Z3Tk1BM084R05aSlR4T3I5cmZVZ0JVeFNIVUlMcDZyMm5xeXp4ZElj?=
 =?utf-8?B?cE1QdTRrcXJNZU1aOFIrZHRBOTJ5UklNT0tyb2RUQWNQb2JzZ0hlNld5OExK?=
 =?utf-8?B?ankzYUZQM1NwWVNhSldza2h3ZWJQcDQxMi81ckVoQytHVURxbS9FaENqTlYr?=
 =?utf-8?B?aW5jdWUyYXhFUXBPS3NQK0FkaWdQWHVyN3RRckVFR0JmcWFTZHBzaVBRREpW?=
 =?utf-8?B?MnhNZUFjcEkxWC9uUFg4cjAzRWROSTFMQzhXR3RBRXQ2bVRSTWFzQVpoTUYx?=
 =?utf-8?B?MjMrdFNRaitldFZtSmpMZ3Q5UmdUR3Flc1J0T2pkZDVRVElBajcyejhmN1FE?=
 =?utf-8?B?dFJIaFVKOFpBTThnWFhuczdrNklpQ2czQlNUN3VuNFo3WTlSbGE5dDVJNHIv?=
 =?utf-8?B?bHVmNk55VlFnbmFBaHhLZDRUWndkNENwZUdtWWRRYWhyRUtlNURoV3BVTjBi?=
 =?utf-8?B?NHZndjVuemc0bERSMWhBU0ZVdGdBeVI2dkRocVdnSCtTVzBGNUx0NmFIWlp5?=
 =?utf-8?B?QlpiNHRUU2JBZDY4UUtNNmFkejZXK01Zcmd2V0MySzFXN1d2T052RTZoUko5?=
 =?utf-8?B?MHJKWlFqYzdsdnZEK0NQSmRlUjVyc2FEVHhOZllKWnMzMnRJNkQyOW5NT2c2?=
 =?utf-8?Q?oIpQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dnhYUy9zUSs1elN5VzBIRHpLWGt1V0FXRTlvWkZDVkxsdVlmUisyZzg3VXBC?=
 =?utf-8?B?SlRSTDdUcmdDSEovengwWWIwNTcycGdzYVgyVzIyZHBmODBRUUZlS2h3N1Mv?=
 =?utf-8?B?aFhDNUFMVFBKSU1TbzlORWpZeHl0ZlI1RGhVSjRwcTU1T1RQMGlJY0J0MEtC?=
 =?utf-8?B?KzVsRkJNYnhjeWtYdGs5aVFuRW1NNTJVQWthdzRpd1hQSm9LYnpvRVhVUHFu?=
 =?utf-8?B?bXVyQi83M2kzUWVOMEtxTnNzdk9uWW1Gcm81d2hWVXN2cmNoc292dlJ0Vy8x?=
 =?utf-8?B?VTNoNEMvNGM3bUl4djlTVk8rNXYzOHhNb042N0pXUE5ya0ExWFlTQ2RoZG1Z?=
 =?utf-8?B?NmNUU0RmSmZ0aVlDVFRZdFI3RjB4bCtIVGUzMFJkbG82Vk0zZTVqWlNHZTNN?=
 =?utf-8?B?U0F2enVOdmd2b2pFUkcvczV3NXhOVTIyMklmOVY1VktzTm9Nc2pPL202SjJD?=
 =?utf-8?B?SXdEOW1BNkNqTWlDUGphYzVBRm5sN2dRZEdMT3N2M1JZakpwT3IvUkV4ejFw?=
 =?utf-8?B?alVPdXgvLzBqczBWQmFQeGt5c1U1Vmhab3cwMCtwMTg5R0VWWFdJbnphMHFk?=
 =?utf-8?B?OFd4R1BVbXc2VEY3aVFFRkY5RVEvT0RadGFvS3lCQmwwaXJZei9JRCtGTnA4?=
 =?utf-8?B?WlFRL0oya282aG9NY015aXZaWW1LcTJ0L3B0bkFIR3pGbnM4SS85Zm1Lb2V0?=
 =?utf-8?B?T2NpVnYvcVg2c1FQVnZXb1AvSFR3aTBVSS9FR0JtK2JKcEVkTExOZWtFbjZQ?=
 =?utf-8?B?eG42MkxFRmZxRTNWaFJVYUc5eFNVSzh5YWpJelp6Vi9Pa05hbjQzZXMyMFlp?=
 =?utf-8?B?c3Z1b3E0SDd6eU9vOTJJcXZQNWtNNlk5N05OSnVPcjBFQmc3eC9VWmN6N3Yy?=
 =?utf-8?B?UXFYNUQ1VENiU05kaTQ3UUFCSWlZb3lQbmVJNGFhS1d0UzZ1UXY2bllTemQ0?=
 =?utf-8?B?WnRCSjllRmpKN1dxaWx0TU12bU5TTHJ0cGZIbjk1U3VNVzh1WWwrQU84YjhB?=
 =?utf-8?B?OU1pQVdEdHZ3cUxadTZMWm1sT2VCbHJuTldWRTBTVmsyeUQvaE84K2hxNGxv?=
 =?utf-8?B?TXhmdWZNVldzc1BjYW9wQmZZUzdCZXF3NlFwRWlpQW05cjFnV2h1RFpvdWpn?=
 =?utf-8?B?Wm5LN3VZd1hqeklKRDFDNEpEVUVFaFFCdkpwTmJyVVU0elQvQTBiajBQa2Fh?=
 =?utf-8?B?OEJKNXd1aVdIUXJETTYvWDVCQ3huQ1o3Ky9sVVZQWTQxTE5IYmdOcFlSOGFC?=
 =?utf-8?B?NFJzM2x3SGd5NUtyZzRaa2pqNFNHYngxaVdNR0FXb3RrclRTRENwUGorQXVi?=
 =?utf-8?B?MWVKbldGcjhBNzR4dGtmN0RGR211Zm5OeXFLQTlkWTE3a1ExN0NodlM1SFg4?=
 =?utf-8?B?V1hrN1NEZ3FhV25tWjBYSkhNUkwwUXA2NFVrRjViQU43QjdMOUdVeUxwSS8v?=
 =?utf-8?B?UGxUWVVHemVNMnpsaFZzQWFPc1Z4SkxXZ1VMbCtUVnQwK3poWmlPaG9abmov?=
 =?utf-8?B?ZFhZUlY5Zll4WGlUZi9QdVdiSFJhYUdQWi94NytDOFBCRnJ4UFVFakY5Vk94?=
 =?utf-8?B?bmhTTzFWcUMwM0JOZ0RjZFhLUit5T3hpbXFNd1MrVjZMYWdmaHRZUzFRWHNX?=
 =?utf-8?B?ZXB2RFZPcmtlaCtSVTRMcDFDM0d6ZjVMVmJCdnpzRUtuQURDdmtvWURpblRU?=
 =?utf-8?B?YUtZZm5PS091a3FLbHlYUnMrVFo5UWcrV3Rtd3RjK0hCbWhnWW5rNHRkeVk3?=
 =?utf-8?B?dm43eTFXeDE3YmdMQWZFbXU1Z3IzZGFWMnArRVczVlVQK3FXcHMyajRaeG92?=
 =?utf-8?B?c2RFVGhEWFZDYjZFbk5sbFc5dmRJdEpUS2IvTUlGZG1vK3dhTExKL01iZHIw?=
 =?utf-8?B?OFNvRjVNMmVIRFJmbnNPc05jVHQ1OUVyblNrOStnaDJSZzVrWlFWN2hqdEdQ?=
 =?utf-8?B?aWhaMkxWZEg5a3ZNSWp2RUx0RVl6WlFFN01CYWdKSm9TN0JONG01L2ZIR1U5?=
 =?utf-8?B?Z2dYN2RQZjVYWHdEaVczV3JDT2w4VW5hUThDWGdDMmI5bVJGTHZQK3M3eXZH?=
 =?utf-8?B?ODU2dE1vdUFkMURmVkduYXVSNkZ0NGs1Y01ZTys0eEdYWklxOUkydzlFUzRj?=
 =?utf-8?B?Qk1OK2orWFl4N0ZmU1RXOFlNS09xd0hzOWxuNUVNNUU1KzVQMnZNT3kvNmVI?=
 =?utf-8?B?SU85dDNPb3JaaGY2a25aN2hFQW5xRHZLK25zSmQyYXZhQll3aWIxUEw4WXlh?=
 =?utf-8?B?c3llWW56ZUtySkhMMGZHa2h1dEVHRFUrN1NJMG1iUTF6aUlpaVNVMHhCMFBt?=
 =?utf-8?B?YXR2WU5ncnVTMEx2N3lpV3hUQlpXVlgrSC9xNklOMWRvb2hqZDBmNjY1MGVx?=
 =?utf-8?Q?tcIQx4QzwSqqZb5k=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	E/RFyQjMbaobtRuWENezBN8VRclpMubpJBYC7vPinP+zs2tgyx8rF8JZA6tgOw3FkY4+uMncNzdLObc4XRis/xOEp9V3eF603Mfpi0T9HSlxqzn2LPHn59WjuDNdUprYGrS+If8CkmLEWJTcNKFPuLjm9HU9l7icYad7eViVUI8WmnPCAB2D03VyeZeU/E7RmMioLl4yYA9zpWpysE+ag3B1xxyHQywLrpjbMHQgmfLIVq7o6xbHcxCpGfS1gERAeOAKwHHNyL4LaEZt/bDry75DluKgFz/noSp5FHFPqvncawm7Uop9LRdaEFlBIleUJbnyQ2KB9DfOXGzEN9eKHz3KzZbd0dVLN9a3a9vvOPYeYvBW/e89bHI9qb3aa7d4Qs1qj9TXeurC5XqoYFzUk573bJVPljg6xU/haAMP9rPPrCy25HDVBILqPOdBHAdplaLWGaskwrfymRlpnpP37HWn9EWrBNqqOQPQDvTKN+A3sMY777N252I2MDlr2nvbgXy6s2SC3AE6ZIRBJlc3+tSZJuUbbZSBaQew4N25nCduYHTBakWZDF+ASk7jye40yySZBszSKknLh+Ffv7KrBGlFkllD6oRioXxZRso0Lxs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8638b8b0-aa21-46bc-3196-08de539b6d29
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2026 18:33:35.0707
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f7mCrvhftwmM/IH6pK1L5wZilAdzXlLADLi0wP7nzl2zUB04nqnDSDE/qrwwAuL3tZWj5CwM2DVpUhxfsyY18a7dWf6tV3IR7xPjqDZofc4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4286
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-14_05,2026-01-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 mlxscore=0 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601140154
X-Proofpoint-GUID: U4LORXomfbu0lO8uFYrrVlliPqVOX4li
X-Authority-Analysis: v=2.4 cv=X7Bf6WTe c=1 sm=1 tr=0 ts=6967e183 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=SLvQRTD8z07Jg4PE1awA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 cc=ntf awl=host:12109
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE0MDE1NCBTYWx0ZWRfX29hlHTbdCYvs
 G6w04NnTjJQCjyVjkEZzs0mBZ6fjtkAJX9sUk9bNLU3L40zfcarDHWeiouFcy9juQukfeH8+FBa
 VnRdq7UJwxl5Lkp1Yeop9H3334rgfU1n0GIqqqXgeppF4P3LsxHsG6Vceet0E1IHmIJMurWYSwA
 ddS9CWlg5EuG/QNyoJ76t9IqrRjWGQX2H4kNVZPjF5/IpCkxkKBtLU1dcDwlYcoxA3Rpr+T/wii
 ZHA+w5HzyssA2AInOVd5HMQCMVZOchqa3vxN5ZqIRCtvILpjTW8dEbACHCk2O0kUhHMDfXmjotB
 L3gJh1k8uEg8Uj2RI4aLE89Amk3878CJAKhq2y1ZQYzjmGUzqFP8EPIsPIx5i9ifM7nmCvhOEFG
 2TmdY+hIWz0nXjwn5qWr6OXt6r9mXhF56D90sTR1HWf/mJ6xStwxzVg1McgZzTb0YvXjckNNnL/
 RVyNJtwaC6P4ejGiHp2JfacZsxm9Tv+10HdJROro=
X-Proofpoint-ORIG-GUID: U4LORXomfbu0lO8uFYrrVlliPqVOX4li
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A9827180002
X-Stat-Signature: 6apkiw7hthinjf9iiay671t5wuogstud
X-Rspam-User: 
X-HE-Tag: 1768415624-9919
X-HE-Meta: U2FsdGVkX19/o0nmRLPo1W/VtaAAXeH5oOtd4QJqsYh1tUuswf4sgMlSsVHhDfHH9HjLdeRdacdWVF9Cf4cHYG/YFohCoRCjR9cmzIRwn/xKRjXLbdixD79MzzypdYqlV3e9eL6g1VDtnr2cQvwCdKgpZeomlL70WQizkfmAmZjIx1UMw8mXh6HePeqtfkkJgqlu73eiRjYM/6+6+k0ka/RIddcEsqnezozXiMkpPQzuORLyV8wTlDlpEyyz+Pqw6V1kl3YAxuClOuYKu0sUQrKfPxxqtVkoYSSqPUJmwOCVzR0lXJLuxp3Hei6CwgnYUEEcB2tEjx90TTFJaQipdkp/XIMgMCi7YHsFap+eB3GUQRqv0ORzwXDXXvx80Qqdk63dAZ4oelH/Uit+Zzy6sDX/3R8QhWdnVu66hFX/eeBzwDZj6mIPoExiv/qH+INMkYxQP2h784cSKon8PJTAWEphC54Q4f45zcjukRqF2p8Ei9SgdmVCLCIEj5/M/qCVovRKZLrZmDaMsnuIZ6l0Vh2oQBT+15Jw0rk75B4Jt/iUnFUYdqTLkZiwsVzEDakh/wbzu2nR/A0YsYJgAjiKVljNHqLx9mnQJtfsiduXYxxOKpfv1xcaG1DF1sd1QijgxNJ/Cn2nv/KiearaqJjksqU6UTUh1r8hZs+C+R5DqkVT7CiTuhWzcDuoVAed9SR2/feuKm6NcpOJwjtVLC7yRw1sZPdFsnA0w5S09+FmHjuDIo2sYzBjepuBwyFfpJI9Zwntp8UUurgwZMIoM04ADrkBYWDqmO4cQAEfb0Q8sURZRV6k9dZ2BM6TGC5SJDxnLAj0VddKyxB3R88d348huzLYTVGpSauhKu0e+pVrHtX7G4XWpjY/c10j05nmgIFFweWJsPJLLRc1a6O2CdtOIOFRqkXomvKwJCaAMokAaZ3UIdhfL5bFiIl6t1Ns2CiggV82dgbj/P36+3UXUij
 tZECPhgW
 +ANn5PYEhz5v0oYhhHVFmewRc9AHwf5873FL5IlgHj93WZuOLBdZKm2DFX6+7fYMjIAja1Haimf5UmXcl+6lmAD2lxBr77KooPR5ANPKJJjIypwJgEV4pfFHm2MYU2H65G42xsO26jj74idzSjaWG4gEZnfcigY8HUmp+ljPKmVbNKf7SqWBh3OwQ9lmtsSKJhcFCGBAR0r05ge+0bE5+X1wvCv6D9Dm65csqeuVbHgknrx8bnV5wDs3w5Haw4w9m6szDcL64110hi/JbVtuKG7dXjOofb3IsGaHdqz3FSsPg25IhjO/35WlvQfIogQBY9/As9shCFJZnQFUgqHhd4Nf7v+v/coujYhcmLZvFIh/mogmWSI7alsvOvtfQWxxgFkvq/mG2TqIwOqKjZSdAz3cb3b5ppz4eDpCMNYLk/nsbZgK6XyBX2HlD3GL91qK9nDBI/t3pKP4qYPQ/YOSxNC8sBry8/GCcgSEdvYpcabfTThO0NxVkjDRWQChBYl9fsL7ieI9RSYzi4lqwhaJKsTKrNz45w3Xb8Qrltss/Q8Jk4rcQt1TcWvpCx5SIoqN1QOT7MtOJ8x8N3B0bRl5Ji7wHEefGnxew+pFdAVGsfxq6eVXe/LNP+UwRkv64Xa0xorr3tmTzsKxGf2WAFqMBxBQ7Y67W6TyUDdwtTG4f4cUvERPGizRnRTM0+l9nilvHBd0ZugP78AARk7A0Z87d0212ag==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 08:14:23AM -0800, Suren Baghdasaryan wrote:
> On Tue, Jan 6, 2026 at 7:13 AM Lorenzo Stoakes
> <lorenzo.stoakes@oracle.com> wrote:
> >
> > Add kdoc comments and describe exactly what these functions are used for in
> > detail, pointing out importantly that the anon_vma_clone() !dst->anon_vma
> > && src->anon_vma dance is ONLY for fork.
> >
> > Both are confusing functions that will be refactored in a subsequent patch
> > but the first stage is establishing documentation and some invariants.
> >
> > Add some basic CONFIG_DEBUG_VM asserts that help document expected state,
> > specifically:
> >
> > anon_vma_clone()
> > - mmap write lock held.
> > - We do nothing if src VMA is not faulted.
> > - The destination VMA has no anon_vma_chain yet.
> > - We are always operating on the same active VMA (i.e. vma->anon_vma).
> > - If not forking, must operate on the same mm_struct.
> >
> > unlink_anon_vmas()
> > - mmap lock held (write lock except when freeing page tables).
> > - That unfaulted VMAs are no-ops.
> >
> > We are presented with a special case when anon_vma_clone() fails to
> > allocate memory, where we have a VMA with partially set up anon_vma state.
> > Since we hold the exclusive mmap write lock, and since we are cloning from
> > a source VMA which consequently can't also have its anon_vma state
> > modified, we know no anon_vma referenced can be empty.
> >
> > This allows us to significantly simplify this case and just remove
> > anon_vma_chain objects associated with the VMA, so we add a specific
> > partial cleanup path for this scenario.
> >
> > This also allows us to drop the hack of setting vma->anon_vma to NULL
> > before unlinking anon_vma state in this scenario.
> >
> > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> > ---
> >  mm/rmap.c | 130 +++++++++++++++++++++++++++++++++++++++++++-----------
> >  1 file changed, 104 insertions(+), 26 deletions(-)
> >
> > diff --git a/mm/rmap.c b/mm/rmap.c
> > index c86f1135222b..54ccf884d90a 100644
> > --- a/mm/rmap.c
> > +++ b/mm/rmap.c
> > @@ -258,30 +258,62 @@ static inline void unlock_anon_vma_root(struct anon_vma *root)
> >                 up_write(&root->rwsem);
> >  }
> >
> > -/*
> > - * Attach the anon_vmas from src to dst.
> > - * Returns 0 on success, -ENOMEM on failure.
> > - *
> > - * anon_vma_clone() is called by vma_expand(), vma_merge(), __split_vma(),
> > - * copy_vma() and anon_vma_fork(). The first four want an exact copy of src,
> > - * while the last one, anon_vma_fork(), may try to reuse an existing anon_vma to
> > - * prevent endless growth of anon_vma. Since dst->anon_vma is set to NULL before
> > - * call, we can identify this case by checking (!dst->anon_vma &&
> > - * src->anon_vma).
> > - *
> > - * If (!dst->anon_vma && src->anon_vma) is true, this function tries to find
> > - * and reuse existing anon_vma which has no vmas and only one child anon_vma.
> > - * This prevents degradation of anon_vma hierarchy to endless linear chain in
> > - * case of constantly forking task. On the other hand, an anon_vma with more
> > - * than one child isn't reused even if there was no alive vma, thus rmap
> > - * walker has a good chance of avoiding scanning the whole hierarchy when it
> > - * searches where page is mapped.
> > +static void check_anon_vma_clone(struct vm_area_struct *dst,
> > +                                struct vm_area_struct *src)
> > +{
> > +       /* The write lock must be held. */
> > +       mmap_assert_write_locked(src->vm_mm);
> > +       /* If not a fork (implied by dst->anon_vma) then must be on same mm. */
> > +       VM_WARN_ON_ONCE(dst->anon_vma && dst->vm_mm != src->vm_mm);
> > +
> > +       /* If we have anything to do src->anon_vma must be provided. */
> > +       VM_WARN_ON_ONCE(!src->anon_vma && !list_empty(&src->anon_vma_chain));
> > +       VM_WARN_ON_ONCE(!src->anon_vma && dst->anon_vma);
> > +       /* We are establishing a new anon_vma_chain. */
> > +       VM_WARN_ON_ONCE(!list_empty(&dst->anon_vma_chain));
> > +       /*
> > +        * On fork, dst->anon_vma is set NULL (temporarily). Otherwise, anon_vma
> > +        * must be the same across dst and src.
> > +        */
> > +       VM_WARN_ON_ONCE(dst->anon_vma && dst->anon_vma != src->anon_vma);
> > +}
> > +
> > +static void cleanup_partial_anon_vmas(struct vm_area_struct *vma);
> > +
> > +/**
> > + * anon_vma_clone - Establishes new anon_vma_chain objects in @dst linking to
> > + * all of the anon_vma objects contained within @src anon_vma_chain's.
> > + * @dst: The destination VMA with an empty anon_vma_chain.
> > + * @src: The source VMA we wish to duplicate.
> > + *
> > + * This is the heart of the VMA side of the anon_vma implementation - we invoke
> > + * this function whenever we need to set up a new VMA's anon_vma state.
> > + *
> > + * This is invoked for:
> > + *
> > + * - VMA Merge, but only when @dst is unfaulted and @src is faulted - meaning we
> > + *   clone @src into @dst.
> > + * - VMA split.
> > + * - VMA (m)remap.
> > + * - Fork of faulted VMA.
> > + *
> > + * In all cases other than fork this is simply a duplication. Fork additionally
> > + * adds a new active anon_vma.
> > + *
> > + * ONLY in the case of fork do we try to 'reuse' existing anon_vma's in an
> > + * anon_vma hierarchy, reusing anon_vma's which have no VMA associated with them
> > + * but do have a single child. This is to avoid waste of memory when repeatedly
> > + * forking.
> > + *
> > + * Returns: 0 on success, -ENOMEM on failure.
> >   */
> >  int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
> >  {
> >         struct anon_vma_chain *avc, *pavc;
> >         struct anon_vma *root = NULL;
> >
> > +       check_anon_vma_clone(dst, src);
> > +
> >         list_for_each_entry_reverse(pavc, &src->anon_vma_chain, same_vma) {
> >                 struct anon_vma *anon_vma;
> >
> > @@ -315,14 +347,7 @@ int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
> >         return 0;
> >
> >   enomem_failure:
> > -       /*
> > -        * dst->anon_vma is dropped here otherwise its num_active_vmas can
> > -        * be incorrectly decremented in unlink_anon_vmas().
> > -        * We can safely do this because callers of anon_vma_clone() don't care
> > -        * about dst->anon_vma if anon_vma_clone() failed.
> > -        */
> > -       dst->anon_vma = NULL;
> > -       unlink_anon_vmas(dst);
> > +       cleanup_partial_anon_vmas(dst);
> >         return -ENOMEM;
> >  }
> >
> > @@ -393,11 +418,64 @@ int anon_vma_fork(struct vm_area_struct *vma, struct vm_area_struct *pvma)
> >         return -ENOMEM;
> >  }
> >
> > +/*
> > + * In the unfortunate case of anon_vma_clone() failing to allocate memory we
> > + * have to clean things up.
> > + *
> > + * On clone we hold the exclusive mmap write lock, so we can't race
> > + * unlink_anon_vmas(). Since we're cloning, we know we can't have empty
> > + * anon_vma's, since existing anon_vma's are what we're cloning from.
>
> nit: At first I got confused because it's possible that vma->anon_vma
> (which is dst->anon_vma) can be NULL but then I realized you are
> talking about avc->anon_vma here. Maybe change the comment to use
> avc->anon_vma instead of anon_vma for clarity?

I'm not sure it's useful, because even I say that and a person reading it was
under the impression vma->anon_vma was part of this they'd _still_ be confused
right?

vma->anon_vma is badly named and I'm a little conscious of not over-documenting
with so much detail that we cover all possible levels of confusion.

This series is emphatically meant to be a _foundation_ for fixing the obscene
mess, not to polish up a horror show.

So I'm not sure I'd not be just adding more questions by doing that or need to
add more paragraphs to explain that 'hey we're cleaning up the anon_vma's linked
via AVCs here which isn't the same as the _active_ anon_vma where faulted folios
point etc. etc.

>
> > + *
> > + * So this function needs only traverse the anon_vma_chain and free each
> > + * allocated anon_vma_chain.
> > + */
> > +static void cleanup_partial_anon_vmas(struct vm_area_struct *vma)
> > +{
> > +       struct anon_vma_chain *avc, *next;
> > +       bool locked = false;
> > +
> > +       /*
> > +        * We exclude everybody else from being able to modify anon_vma's
> > +        * underneath us.
> > +        */
> > +       mmap_assert_locked(vma->vm_mm);
> > +
> > +       list_for_each_entry_safe(avc, next, &vma->anon_vma_chain, same_vma) {
> > +               struct anon_vma *anon_vma = avc->anon_vma;
> > +
> > +               /* All anon_vma's share the same root. */
> > +               if (!locked) {
> > +                       anon_vma_lock_write(anon_vma);
> > +                       locked = true;
> > +               }
> > +
> > +               anon_vma_interval_tree_remove(avc, &anon_vma->rb_root);
> > +               list_del(&avc->same_vma);
> > +               anon_vma_chain_free(avc);
> > +       }
>
> Are you missing "if (locked) anon_vma_unlock_write()" here?

Ugh god yes. This is an annoying irrelevance as we eliminate it anyway later but
I'll do a fix-patch to avoid bisection hazard.

> You could also avoid using "locked" variable by setting anon_vma =
> NULL initially and using "if (anon_vma)" as an equivalent of "if
> (locked)"

I know, I did this on purpose to be explicit. The compiler will optimise this away.

Anyway it's moot as this gets removed later so I say let's keep it as it is.

>
> > +}
> > +
> > +/**
> > + * unlink_anon_vmas() - remove all links between a VMA and anon_vma's, freeing
> > + * anon_vma_chain objects.
> > + * @vma: The VMA whose links to anon_vma objects is to be severed.
> > + *
> > + * As part of the process anon_vma_chain's are freed,
> > + * anon_vma->num_children,num_active_vmas is updated as required and, if the
> > + * relevant anon_vma references no further VMAs, its reference count is
> > + * decremented.
> > + */
> >  void unlink_anon_vmas(struct vm_area_struct *vma)
> >  {
> >         struct anon_vma_chain *avc, *next;
> >         struct anon_vma *root = NULL;
> >
> > +       /* Always hold mmap lock, read-lock on unmap possibly. */
> > +       mmap_assert_locked(vma->vm_mm);
> > +
> > +       /* Unfaulted is a no-op. */
> > +       VM_WARN_ON_ONCE(!vma->anon_vma && !list_empty(&vma->anon_vma_chain));
> > +
> >         /*
> >          * Unlink each anon_vma chained to the VMA.  This list is ordered
> >          * from newest to oldest, ensuring the root anon_vma gets freed last.
> > --
> > 2.52.0
> >

