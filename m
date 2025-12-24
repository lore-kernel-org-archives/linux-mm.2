Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09069E74903
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 05:53:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5654F6B0005; Wed, 24 Dec 2025 00:53:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 512B16B0088; Wed, 24 Dec 2025 00:53:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A0146B008A; Wed, 24 Dec 2025 00:53:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 231A56B0005
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 00:53:56 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B7D0A140620
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 05:53:55 +0000 (UTC)
X-FDA: 84253298430.08.41BF83E
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf22.hostedemail.com (Postfix) with ESMTP id 557D2C0003
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 05:53:52 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=CT0MWbKf;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=khZC4ZwZ;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766555632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a10sra4lDjxQHPtbVoTxYblt365Kg3fdjgf0qAy6UBA=;
	b=6bIh9S4XhLfOh9MjAYYAjJ4vOu75ixq35mt9ZofvbN6y29aTszHQKqIT8LC1Qh6gMVJkUo
	luKFhEAq7p3JTmBGrg932i083SKXX4m8iBish5eZzaW3WKz3JfS5kRqtyOF5N2x9zgp+Hs
	1P2S3hQUxWESgQAkoXexMyIMDqAuaEo=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=CT0MWbKf;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=khZC4ZwZ;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766555632; a=rsa-sha256;
	cv=pass;
	b=ovbCXRNcjeYpwCvaH5P1kjERRgDSwvPK/S3kckFeBR41o1xvsqTTYqa3NQn+jX3xqq+vug
	GF0QpfzgUoCZOWiz36S7P0cDwdtX5+Pm+SvMU5OqHBEWZzn4uWbsjSyt+/o1FbD6P6yTwK
	3xdFCICKxMXZpwiQoVV4uU/oawqwvnA=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BO3Iort2168052;
	Wed, 24 Dec 2025 05:53:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=a10sra4lDjxQHPtbVoTxYblt365Kg3fdjgf0qAy6UBA=; b=
	CT0MWbKfM+7IqLlofv7PsTbG51AF3uS/571DOr5x8+iTCotpjeo6ajUyhcXxE8fe
	jJkWY5fVs8Hvn49CQn7rC+TcDXw9Vdv6pzqEPPJ3odrNbN4/ac6C0fIA/EmzlMqO
	tqcErb5/wU0bi7v9QtIUflqHD1RO3Db2nJ05V4ZejZZ/VMoYuCdsfIuOU+VHlWEr
	N3UNha7N4Ct0jrp9v5EatDmkjWpneEGcBglbf4c2nS61Ousqi/XwUP742jZnMSiU
	P7wBrG2acBtlMOxulNitkPcBGZwaXM6xt0oXkxmlTdKdDdeCpdcraly1u+BAIi+f
	qCumJbwdXDYZOHPKps8dOA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b885202th-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Dec 2025 05:53:41 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BO2Z6ae016592;
	Wed, 24 Dec 2025 05:53:40 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011050.outbound.protection.outlook.com [40.93.194.50])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4b5j8k57s2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Dec 2025 05:53:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uyNkyQantDkpdZU0FjZhxLq6Mvw7yN+2rCBfg1CTDKk1f4k+0NzfuvI6l2vZtE3PCLpPVB1TdpEtZhCv289imR9Sr3NA7zIIghXfbTVitDXo5UV8y2d/G0X7l5PTFG/oxlCdD3Y0agI4HzMBi1fQwZ2miZeO0hSxXxRE/UFO/2BI9citepykPqlM0kp5Glzscrif+FzQT48ujy4s5Pmq+qz/6AD0vwqD+w8bSPMA9iBJ8qUhiDhUj0RpAmrSSt3/4auN2fqIMoUkoE2wKRBKAWOGrSKEvlHfmVuZYcBGwO/uO0wzEjo7gHXlHPF4iF04lBBmsNmYTrbTLA7unBMtNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a10sra4lDjxQHPtbVoTxYblt365Kg3fdjgf0qAy6UBA=;
 b=JOGV8n87oEitiMVEWuB7/I25nm+ZXT8muXJUIuccBwKupgAM02UNI5lluCKlVK23VtSj0UvjhTBgGkqm0qu2hvAi3v9oLLiJmzyvBSDAdD3aUAgQ8uT7pnf1apCzdpN7GFMhDztNbhji/8tT5K1agdN4T7VvK+TfFuNd2d0cFlbPp7REkutKIFXfdHhCk7fvbrRxeC04boW6+gKhhgNdHsSY/49sXv38+xXLpKiHFk1hZqqxpmWnQ8DYxujJv4djNxvrcQ1W7PUD15uCbPkDw5qNyz4vRtVZScaHFVp+EOf4xhkH9ap8jkMSvVj0s1FhykjP93jQrGHIbFAt6jdB5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a10sra4lDjxQHPtbVoTxYblt365Kg3fdjgf0qAy6UBA=;
 b=khZC4ZwZxjRqOkVPr9Odr2mXPevwAT3XahDEPQzJ46Z78CUPIeabgeoI1oEu40tDTXJYjARqO/ob4wyBDdDtItiaug/L90xP7FOn+L8CWZdsPXT96Al6NZd6HdRCFG92yfLoW+RMV4fLagw7ICubR6uWV9l9qIE8SFi6zoLwUz0=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by IA1PR10MB6806.namprd10.prod.outlook.com (2603:10b6:208:42a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.11; Wed, 24 Dec
 2025 05:53:37 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9434.009; Wed, 24 Dec 2025
 05:53:37 +0000
Date: Wed, 24 Dec 2025 14:53:26 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Hao Li <hao.li@linux.dev>
Cc: akpm@linux-foundation.org, vbabka@suse.cz, andreyknvl@gmail.com,
        cl@gentwo.org, dvyukov@google.com, glider@google.com,
        hannes@cmpxchg.org, linux-mm@kvack.org, mhocko@kernel.org,
        muchun.song@linux.dev, rientjes@google.com, roman.gushchin@linux.dev,
        ryabinin.a.a@gmail.com, shakeel.butt@linux.dev, surenb@google.com,
        vincenzo.frascino@arm.com, yeoreum.yun@arm.com, tytso@mit.edu,
        adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH V4 7/8] mm/slab: save memory by allocating slabobj_ext
 array from leftover
Message-ID: <aUt_1uDe05diks7b@hyeyoo>
References: <20251222110843.980347-1-harry.yoo@oracle.com>
 <20251222110843.980347-8-harry.yoo@oracle.com>
 <graryni6wadpi3ytfq7zimj2kbmm7dumxvhxtzmxndrv5s2y67@ju4cdnsmos6e>
 <aUq1x_BowqYpHZAQ@hyeyoo>
 <zex6wgdlxk5vgwm7ou657fdmi27xnxihdndlszfa2chghamfuz@grhtfqw7gm7o>
 <aUrCXYdziRWP9PfV@hyeyoo>
 <c6owr44jdncf7q5zqgq4wn4pm57ai4cd3upauwmwszopuddf5g@52mkqbe2m27j>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c6owr44jdncf7q5zqgq4wn4pm57ai4cd3upauwmwszopuddf5g@52mkqbe2m27j>
X-ClientProxiedBy: SE2P216CA0116.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c9::13) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|IA1PR10MB6806:EE_
X-MS-Office365-Filtering-Correlation-Id: 90a39dcf-ad8e-4c49-1d9b-08de42b0c82c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Y09yVE45K2NyUFM5d3lWOHpBNW1JeWdPQUhqSEpKY3dpVkc3UzRDemdNcVl5?=
 =?utf-8?B?OVRLWFFTTUVXSFQ5bnY2MlFzei9HUmE5b09GdG9LNm1jejBkaVZLRTh2T2lZ?=
 =?utf-8?B?ZHdJWEdWUzZQSlRyNnpsODd4KytKSHdESTJqa3EzVnU4U2NLT2pjVUI2YnVn?=
 =?utf-8?B?bWh4dzRDSUVlejliSHY5bWlSS2FrUEhrWERUYTVvL1gzTEFHcExrUGF4MVJJ?=
 =?utf-8?B?ZnVFN2ZxV2w0TWt4SDFqMkFLb3FhTEt2Z2xYWXY0V3BTRzdIRE9NWFdWcEZu?=
 =?utf-8?B?YldHMGdhLzZGbVNDMUFtSGtFOHpDZzJWeGxSOGtMUHFBdFhRY0t5ZWp2MkZ1?=
 =?utf-8?B?bUNucmcwbUZvNFlSN3g0WVNtaGh0Q0VmMzRPSld1bEsrTW9wS1pYM3RUWS9P?=
 =?utf-8?B?MXRkdXp5dGIrNlpRVDcxNkpFTG1UbGlIZTk1cm9Pb3FZZkkwZkxIc092TG9Y?=
 =?utf-8?B?NDNJbndQWko2SHp6ZXhSRldtZWo0Y3VodDFoUTlCSEY2RGF5Q1BDNW54bjY1?=
 =?utf-8?B?SE9oeFF2dVZWSzVkMjhKQThZU1dnTlJiRFlDRTJqYUNIYTR0L0pKazhWNFRs?=
 =?utf-8?B?NXlVakRMczF2bExaR01TR2lIRXZrcWFTOWl3emFpNUhrZWYyQyt3WCtBVjEz?=
 =?utf-8?B?M2llYkx0MTJmU3RhUHpvT1RSTlpCYVZMQVdha2w1eU9HN3V3R3dCS3EwUXlo?=
 =?utf-8?B?dWhzZU1aNkJNZDZpUGN3Y1BaUFJ4dnhvNVphSStJbloxakVrMnVTa0s0R29s?=
 =?utf-8?B?UDdmZGl6Zjc0dWI3OGptMTE5blp0Vlh3TFFHN3hhOCtsdWpGSFVRVWZoYUJp?=
 =?utf-8?B?VzJpT2VLQmUwTXB3alBvMmo3N2NsR2thcjZFYU1mYlZJSVJISzBHQ1BLOXQ4?=
 =?utf-8?B?ZzFHOXNIMmJPOTZJcDFFRGI0NDdLWUJ1eU5ZZk5Bem5raGFWb212ZFd0QjAv?=
 =?utf-8?B?eHhMRWxCNWpjOTMrL3JaYVNVU2NwNGIrV1o5TlFuMHlWcDZ3WFFYNUg4VlpT?=
 =?utf-8?B?Y3JSSU5nM0xiT2owQnhHd1kvYmdQQmxhMzFuVnJjby9GQVdiV2lhVkJKWkx0?=
 =?utf-8?B?WU05bTVmMkFzVTU5NUlJZjZOSDAwRmwya2hjWERIMkZxUDZIcFhUcE5uUmQw?=
 =?utf-8?B?UFhSU0lBNGxobmk2bTFLZUxHdUliOE9lRGRTbktnYm9vNVJhZzRrOHowa09W?=
 =?utf-8?B?Q25zVVFraG5rSXErbEhHZHo4OVg5T2I5M0Y5L0RnWEdXN1I2alBySy9BM3F2?=
 =?utf-8?B?YVpBOTBEbzFWNWxHVm9hdU12VGFZNlBCZGZrNGRWdnZLMVE3S3FuUTUwamhh?=
 =?utf-8?B?ZkRhcVBORHZCSmhSdURkVmZBcmN5SGMzTlMvajJFY0RrUDc4UTY4NVYxdHIy?=
 =?utf-8?B?T3JIZ0ZvaXhvNlNrOUdna2p4bnRtU0w3dnZMS1dsTDdZanM4YVk1bEZ4Skt6?=
 =?utf-8?B?UVdEQmYrQmhtVFNYN2l5eDdJcldrVEJoeDJtTWRLZ1FXN0pCRjhwTmRlOTNN?=
 =?utf-8?B?b3h3MThrL2ZqRWIvZG1XWXgvTWdjQmxRL3hCWm1xcVlXcWpkRzRqT0FYbTVx?=
 =?utf-8?B?QjUrTjlobU15aFNXMDFIVWoyM1V0NlB6VnZudUZuVlduaXFTWk4vcy9PR1BL?=
 =?utf-8?B?d09jRTBBdXc3Zk9FanhIc2JPN2FOZTQ2alVTSTBob3ZWV1pTcjZxaUJDZ2FI?=
 =?utf-8?B?NHFQS2E0TnJ5RjlqVFRyeUNtSzRnRjZrcDY4SkQ1Q0lzUnhuUURTV0g1WENt?=
 =?utf-8?B?YUtlTjQvTWtYN252VFJVUFpqaU1nRHAxWVgwVzhZWHFiUit0ZE5WS1pIWnN4?=
 =?utf-8?B?OVpJY1FNa2x2d0N0ZFptaVVPMmU3aDF4R29Nc0M2VWF0Y0RVV1Bqc3FncmRS?=
 =?utf-8?B?ZlljT1RvbnprcHdtRnU5MlFiVWhKSWZLbW5KMmhVUDV1MzY5ZjM1UUNWcW43?=
 =?utf-8?B?ZUFKQU1nTEFKVCtmbHBPTHkvYXNETFIveXZGUlJPRmI1MVNuRE40cmZaQUQr?=
 =?utf-8?B?L1BXNHJIZk5RPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?enh5OEwrTUhzV1JiQ3RsYWZ4VXNvc1hzdWNNajhTMDM3VUthd0oxZlEzUVk4?=
 =?utf-8?B?ZnF6dm4raTNFMmxjQ08xN1MrZmNhS3NlMGFMRTJ6SkVReENFNkl3bDZqYUVK?=
 =?utf-8?B?Wm1VWWNYanVVdHV1dStWYitMNlBnUHZ5ZE1ZeUorUUk0SmJzTEZldmRQMXAw?=
 =?utf-8?B?M3BJQUF3NlJFcmVXSmVoMWVyRjBqencxNzhoeGxwcll0VFRMSmVBRWt4U0RK?=
 =?utf-8?B?UmpkRTdWcEt6NGQrRzZZQ3IzY3U2M0pwczBhVkVUOHI0YVlSQmNLanpVd2Vq?=
 =?utf-8?B?dW0vRGZPb3Vna2MyT0ZJdHBITEpHRE0xRUs3M0U2NW9BY05rTHZuUTFXU29q?=
 =?utf-8?B?RUZQZDBSdTRkZi9ISGtDaUlsTitLRDhNVmhka1FsNm45Mjl4NzJQWW0vdkFv?=
 =?utf-8?B?UkZjS2dJTUlYQWxRbXZjYUQxUlRqSncxdG1PSEhsa21DNVd4YXZmSk9iQldt?=
 =?utf-8?B?MVZCdmdBWTRFcXV0UER3eE9xcEYxcHl4WlRsOWRGRk1WY20zYXJYZVc0YjRT?=
 =?utf-8?B?cWo3cWNTS3dIdGxCY1h5UDkyZHMwbzF0eVEvOG1zMzFrb3dGYmFTazRlQVVH?=
 =?utf-8?B?ckVJUTlTV2M3MysxSkdjNVVCZHNWV29rZkUzYWM1Um9aOTZjRDUwRkZwTmNB?=
 =?utf-8?B?QUk1eEdCbitnR2RORUV6YmE3ZTNnV3BUclF3ZTIxSmxzRVYwb0lkT3BGYTlE?=
 =?utf-8?B?Zm43Y29sRXExb2RMMHlnWWFUSEpvVGNYbkJUK1liRWpiQk5CSjJlZU4xb3Va?=
 =?utf-8?B?L1hQSFlYZ2thSW9VNXlkM1NGbGR3SVRVQWk2Z0RaZGZtS042OG41OU9yeXFG?=
 =?utf-8?B?WmNLdk1CNG9GUjJOaUJVT2Z6U2tqS0xwRG15Q09NRjBYSXB2cmhycENwakpQ?=
 =?utf-8?B?WURLcVhQRlRlYWlEamkweFk0U200ZnkxNlc5ZGJobDNzS1hlU2hYbU05aVFu?=
 =?utf-8?B?cWgxbzMyVk1yY3BBSWFFM0N6Q0FodHczVHVmL3NuTkIzYVczT1liSnArNzVR?=
 =?utf-8?B?QnJnOS9DeldKT2xMYnVVMENmMThLZWY4L3ZSSXJrOUl2SnZxZEJOalJNWGdq?=
 =?utf-8?B?UVBUbTN4K2tuSXdta0tQRmhKQ1FNYkFKWjYwMFJYbXNBRnB0L21qelVvRjho?=
 =?utf-8?B?WEpDTVhWVTIwZUhGQ2tacDRZcE15NEFCNDY2VUV4VDZKS1Z4ZFRSdzQzUmlk?=
 =?utf-8?B?WUsvYzNXZlJHd0xIWFlaalhlY3h4U0Y4NWkva255UGhSWkdKa2xFckVUc3RV?=
 =?utf-8?B?T1dyZnlVNVdHYi9YQXRiMitmUWMrbWVGT3FtUE5JSG1ieHFSS1Z5Ujlzb0Ur?=
 =?utf-8?B?OGpKVkE5ZGN6Y1d3dC8xTTZxRUVFdE9RdFF1NnIyQkVRSmdockdlZmJoYnU0?=
 =?utf-8?B?Vlo1dFIxdENUR09UUVJ1MXc4ZExvcys4RTFOTi9ETThVUDNnNlhMZWhUc2o5?=
 =?utf-8?B?V2VvaUlPcXQvYW11V1VwZUJDV08wL2xUL0tOeXAzZ3BNN1BDTzNHc3NtWE9R?=
 =?utf-8?B?d2k4RUM5NGpEd05MVVBxZWYvWmpKSzNtYVB1aU5xeElRV0hWWG04QmZCZzcw?=
 =?utf-8?B?OFBkZW1Od3k3K1NzWWpXNytBREJSclNzMnpmSjh1YnRWQkJ0d2RTSUJNRUhy?=
 =?utf-8?B?bWtERndPVkR6WmtKVU81bkpva04rS2lRbDBXYUxrVVl5dlRSaEpvNmdDeU1t?=
 =?utf-8?B?b0ZGc21LL0xyRWczN0RYUW1UVlNnSjUxZmU4OVdMYnFva0JWMEZoMEd0Q2tp?=
 =?utf-8?B?UkRWYXJuTUFwVXJjdXBIcGszcFlLN0pCYmgrWnZDenVBKzVXNk5JTVFoQTRP?=
 =?utf-8?B?QXY3bzFpcExtcnlma1NkQnVoN3BDTTkrQ3AxT2lhL0p1ZU45UGl5OVBIRkFZ?=
 =?utf-8?B?Q0lBejYvaEdJOUduc0cwQ1lHOTRQc01kbE1qdkFhdzZad0RHaW1NMWhSK0Nr?=
 =?utf-8?B?NDRyeEhqL3ZjTnd3dE9PTDFtTkZndmpKMmx6WWV3S3AralNtRjgxQmhFVEE2?=
 =?utf-8?B?amViZ3MzVlVYRzlzMzhUZ0dIRXF5T0lyMVdybmJ2ZzV4SENBV0hEakFBQjhq?=
 =?utf-8?B?OHIxWWtYK1JFYTVuOXdGdzIxWW96TFkzYmJ0ZS84R1hHWVZkZjJaUHNFa2k3?=
 =?utf-8?B?cy82Z1l5Vnl4RDFmNFY3Mm8wZ2xYNEpIWlJnNHg0UTZESk5xMm9BcUpua3F6?=
 =?utf-8?B?VkpCVTB6R2d0dG9XZGxPb1BpMzJWak9rcmZtSVJidFBKSWxaL0hDbVdnYml3?=
 =?utf-8?B?Q0ZqVTZJNlJrd3VtdFZEU3pacTF4MlFRdnpjamltT3FVQ1pqRXFwQ05DS1pS?=
 =?utf-8?B?eWFFUDdCVGlGOHR3bVJkcGtzYW9ld0RnaWdoNTJHRldFMGladGlRdz09?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	7w+kQbkzNZKn2qw4+gX9OJFnB20ulYt7j3PtQ58xpMHOBcMg7hTWNEDFtwBPpQLz4uK9UH5nL+Yyzrgocp+ydM/FHj3C/sJhATOtTDyCbPwAnxSCXQYfmh5atO1wZyZYx3nDdN7nP0H2jqVZAlWalKHObtQZIDtafRJN0leVbFCLlZAmmY91MmWtUGZJkhhQYiwiohlvCdpE/1TkDUdBfDkDOtmWlbLORh5EKvmfwXa1HQFVR2qIWP640JbtrnaoXe7KLiBThnL7iXnoHofto1GeIu+GI97cSzFz2afCXYq75ixdrLInca/HFZCbJuXmSnPt7zkZxkyVHUXLVw1ssDrd1jFxmNQ0Z/PUFeYtJ6ICobLUvG5H+pgEa2AiN+plz/iWtOmKJmIoHfq3KV6ysTwxim34Ejp93RRnbfgx0hxUQSwY8RmwVuAhOvFX1agK7AykpQwFidB8I2ZX2/x5JHKGDXR+6b2CeXCQz7MJJMwsYbfJVoqBESMlJdupjNCd/7/vF2ybhEEZrZK5/QQPajyD44ulZK0ozgz44oFxhTYLQYO6bNAOXgR7aMSwGjUQFKAeIWssEazbqSSPQxKp9dVFUoWSQoMJUSF43i/fZoQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90a39dcf-ad8e-4c49-1d9b-08de42b0c82c
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Dec 2025 05:53:37.5186
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: juHjXQWr9hZO9WOjvMeZwygXRZHz8QBPLuR4d1PhrlN8wrMw8pfyqxFZ0NGn61co2zZfgh9Y7tX+u1eW1qdlqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6806
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-24_01,2025-12-22_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 spamscore=0 malwarescore=0 mlxscore=0 bulkscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2512240048
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjI0MDA0NyBTYWx0ZWRfX2eJ1zf5Fnvub
 zt0d5aPMsKp7qbP1I6wTx27/7TSImmeQ9bgLqIZ77EFYZpJR5ee3pnCzWLZ1U18KMahAdwmwf/l
 7HIv7wLoF990xrZ1b5NhCx19VLW+A+NTIsdMoernaUFFJ6UHbex7w5OWnGsx8M0F7edlVT4T5T0
 4WDBNMJ0etPCpvsmrMgjGfMLvjcC8fQTTMZU47VfE90Kp42S22PCv44W4qtbkHoPvMeDkmW09gL
 gXB2rRDSlNc3u0+XXBSaNKjboaGBf52EApBGD0ApKSF/bk3wp3iZlZz8Bdm2Rr+/GlbVuK6dmaN
 OT+3uTbetWF2/0OdpoQCTDN46Iwz6gGouBd/3Io5auS9aE47pJpi/1pzUa8lq1oSUolhzk0rieQ
 sszPzdZmn0qC2RAsZaI0zKlkyzEwKfO0h2Fa9vJN05TjcQ0ISu2hQzaq2YPR5k4KFMnzCYaN3Rs
 a+nEuZMiM+ukjaL9hbZUbj2QmNW7KWLcWeEk/JzY=
X-Proofpoint-ORIG-GUID: A-6_sPKDPXdm-eMtYzKXNeRI250gnPlh
X-Proofpoint-GUID: A-6_sPKDPXdm-eMtYzKXNeRI250gnPlh
X-Authority-Analysis: v=2.4 cv=cs6WUl4i c=1 sm=1 tr=0 ts=694b7fe5 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=1FiV9YUQRRfSUSArBtQA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12109
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 557D2C0003
X-Stat-Signature: kkdxgt8ja9mmmh9cyo7s4ass7eopri6r
X-Rspam-User: 
X-HE-Tag: 1766555632-346880
X-HE-Meta: U2FsdGVkX1/Mhv6hQGfKdrULXUvPu5dTHlfRNyue3U1yjgwDNRulNHbxMkpUqI8ABhMu4o9rCevs4q6oXV8n6G7nyA9M3qo829tKX/sNRW9Q74t8+UaMYaDGsGg9SqeNeIcSIwMYUj5kVtkvTk6Sr5M/uMaHa2b6PqmN/1ja8jEdNxEoU8hggcAmBGawlgBCPEmAZLuLrg+K4qNap0QOm/jiFdg/+l1NRRnab++ZuJarNdEFBdQS/wfv6OvrJ5iMSAI+EAjQV68t076iByjG1E8eaqBB155qRyTBVjMJY9VWmfB+gc36+ideXa4J3Eqpby8dd0BiW8I8s0uZcTWIqv/OB18Di59QVZtARXVTq9Dm0RfHSwgGVLiWKRrBILi5DKJGVdj+IV59gdBQmitOBAbo4sglRMH4DRgCDRJhEI7WVp7pA1IvsILxnZTOEXj70UjCSsZQp6Y7DE22RER2+y1dzHpMekpmzBMjdYbHEfu2ZYAf06peShFPB29S0bweHmvvzSP3xc4Rm8mhyeBLUAv3otdMbI+viBfqP0UReOdKMLRU1YpycMZRrv3KayJ5jFZT0XCAp4ZTerzl8b57+4MIdRNKTBg4WWapK6xq5Nnjucl8NPzPdEBQLAOK/0ZLrcsD9NpWokoFx51I40G3+dXl2x6Az+FCbg6BDY3PUrvel4CxFxldyesbJ+RpFt5rP3y0MfAT9F0YV3wKO43SXLDQHUP3QonCTC/OpRYD4lFfKAEDQGwXt+Sy0RP1Wyx4jKMrVo7zKSIX+iIgk4zvjh/isR6ZlTjDVtABMir0ZojUMR40v/VcXlJQsEeXOPEesRNuFGeUp/36b7duSbhPVWx0VdOxIfuv5Qaobjbi6I7Mjh0dfny3N1V3pmB7S9WmemC7SH6iBCMgWJbvkK9wav7B5YjPQinlL8sbIv2CzHoHUMz2jOEzzJ6dioQVoJRxhOvq3DFHLmbr0BAj00P
 3PkM0McR
 fiOGmxJTD2VwfFlrakUnc0cVPojphc7DLhtPrb8R2AiMIt/qxmIU5mjzaTB5IkV6oHaQsA7svja16a3WSmVAX2W8HT8f3oQZabNFkAdSGMsJkMc4DV9MokNnKEFSl6oU5pi5WOHsJgaXrNOFsKjGJ0V1mGsg/BZsmGegf0IflLIU/pFST9XEJHmcabEIaTj8PZMoN4iBK97w2rxVpg/WUgDW55DUdKvxPlULG4Hx0eQXhEfDGLynwRJQf/4GiKQxJbWLls1boQM0uJt+C/Ki64k9drNs6SVdFjOSkVfmBIRJkWvjkva71O+GMcZhlckii7X44wFQTzL1uXqFOhpTEtCKVeMu3kaBYqxW2T/uK4YDoBn2jn/QUKBdQ0LBNlU1hvGjdzh1ENzrmt/4T8pUpKTfRsMoQXqcrUbj7EOEXVdlSMO24LbB/3Y8/VRQPJSt0ymtLBinNMjoQgb7bc6ogi+twYSh+4/RoE+E4+FJAG1cq/Z8tht3bbofgghlKXsptZ88AHkaRLezTHbewSnrcpwDW+z2HWuKlYZSYYv+N3GSfFgmU4UV6/SGC/PWMPknfYbt4chP1FRCw/Ttf2KXkkhDPEEAAub3z7ps0WrqlVQfWmTSYlZq/bHVQsar72uoULewPsxoMbTydmPoroHHEr+jtHuEOrLSlQFIpj/Fl0KfQ1113ii01GZULWeWlOXwHhZA3H5ZVcgcKAK54xAcJyvWdstD66Xrk0Dk1johLM2dMvqBFDK5HyRYV1bVhtXDTuO5m8IWIvf+BpzAP72zH3qAm19CSy0HP5Nf7sG2NmxS0P2a5cL+0JOXeyVUm/o/jRY0Mzla0O2+q1KiCbYtQe53ma/GEOpfBtlTX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 24, 2025 at 11:18:56AM +0800, Hao Li wrote:
> On Wed, Dec 24, 2025 at 01:25:01AM +0900, Harry Yoo wrote:
> > On Wed, Dec 24, 2025 at 12:08:36AM +0800, Hao Li wrote:
> > > On Wed, Dec 24, 2025 at 12:31:19AM +0900, Harry Yoo wrote:
> > > > On Tue, Dec 23, 2025 at 11:08:32PM +0800, Hao Li wrote:
> > > > > On Mon, Dec 22, 2025 at 08:08:42PM +0900, Harry Yoo wrote:
> > > > > > The leftover space in a slab is always smaller than s->size, and
> > > > > > kmem caches for large objects that are not power-of-two sizes tend to have
> > > > > > a greater amount of leftover space per slab. In some cases, the leftover
> > > > > > space is larger than the size of the slabobj_ext array for the slab.
> > > > > > 
> > > > > > An excellent example of such a cache is ext4_inode_cache. On my system,
> > > > > > the object size is 1144, with a preferred order of 3, 28 objects per slab,
> > > > > > and 736 bytes of leftover space per slab.
> > > > > > 
> > > > > > Since the size of the slabobj_ext array is only 224 bytes (w/o mem
> > > > > > profiling) or 448 bytes (w/ mem profiling) per slab, the entire array
> > > > > > fits within the leftover space.
> > > > > > 
> > > > > > Allocate the slabobj_exts array from this unused space instead of using
> > > > > > kcalloc() when it is large enough. The array is allocated from unused
> > > > > > space only when creating new slabs, and it doesn't try to utilize unused
> > > > > > space if alloc_slab_obj_exts() is called after slab creation because
> > > > > > implementing lazy allocation involves more expensive synchronization.
> > > > > > 
> > > > > > The implementation and evaluation of lazy allocation from unused space
> > > > > > is left as future-work. As pointed by Vlastimil Babka [1], it could be
> > > > > > beneficial when a slab cache without SLAB_ACCOUNT can be created, and
> > > > > > some of the allocations from the cache use __GFP_ACCOUNT. For example,
> > > > > > xarray does that.
> > > > > > 
> > > > > > To avoid unnecessary overhead when MEMCG (with SLAB_ACCOUNT) and
> > > > > > MEM_ALLOC_PROFILING are not used for the cache, allocate the slabobj_ext
> > > > > > array only when either of them is enabled.
> > > > > > 
> > > > > > [ MEMCG=y, MEM_ALLOC_PROFILING=n ]
> > > > > > 
> > > > > > Before patch (creating ~2.64M directories on ext4):
> > > > > >   Slab:            4747880 kB
> > > > > >   SReclaimable:    4169652 kB
> > > > > >   SUnreclaim:       578228 kB
> > > > > > 
> > > > > > After patch (creating ~2.64M directories on ext4):
> > > > > >   Slab:            4724020 kB
> > > > > >   SReclaimable:    4169188 kB
> > > > > >   SUnreclaim:       554832 kB (-22.84 MiB)
> > > > > > 
> > > > > > Enjoy the memory savings!
> > > > > > 
> > > > > > Link: https://lore.kernel.org/linux-mm/48029aab-20ea-4d90-bfd1-255592b2018e@suse.cz
> > > > > > Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
> > > > > > ---
> > > > > >  mm/slub.c | 156 ++++++++++++++++++++++++++++++++++++++++++++++++++++--
> > > > > >  1 file changed, 151 insertions(+), 5 deletions(-)
> > > > > > 
> > > > > > diff --git a/mm/slub.c b/mm/slub.c
> > > > > > index 39c381cc1b2c..3fc3d2ca42e7 100644
> > > > > > --- a/mm/slub.c
> > > > > > +++ b/mm/slub.c
> > > > > > @@ -886,6 +886,99 @@ static inline unsigned long get_orig_size(struct kmem_cache *s, void *object)
> > > > > >  	return *(unsigned long *)p;
> > > > > >  }
> > > > > >  
> > > > > > +#ifdef CONFIG_SLAB_OBJ_EXT
> > > > > > +
> > > > > > +/*
> > > > > > + * Check if memory cgroup or memory allocation profiling is enabled.
> > > > > > + * If enabled, SLUB tries to reduce memory overhead of accounting
> > > > > > + * slab objects. If neither is enabled when this function is called,
> > > > > > + * the optimization is simply skipped to avoid affecting caches that do not
> > > > > > + * need slabobj_ext metadata.
> > > > > > + *
> > > > > > + * However, this may disable optimization when memory cgroup or memory
> > > > > > + * allocation profiling is used, but slabs are created too early
> > > > > > + * even before those subsystems are initialized.
> > > > > > + */
> > > > > > +static inline bool need_slab_obj_exts(struct kmem_cache *s)
> > > > > > +{
> > > > > > +	if (memcg_kmem_online() && (s->flags & SLAB_ACCOUNT))
> > > > > > +		return true;
> > > > > > +
> > > > > > +	if (mem_alloc_profiling_enabled())
> > > > > > +		return true;
> > > > > > +
> > > > > > +	return false;
> > > > > > +}
> > > > > > +
> > > > > > +static inline unsigned int obj_exts_size_in_slab(struct slab *slab)
> > > > > > +{
> > > > > > +	return sizeof(struct slabobj_ext) * slab->objects;
> > > > > > +}
> > > > > > +
> > > > > > +static inline unsigned long obj_exts_offset_in_slab(struct kmem_cache *s,
> > > > > > +						    struct slab *slab)
> > > > > > +{
> > > > > > +	unsigned long objext_offset;
> > > > > > +
> > > > > > +	objext_offset = s->red_left_pad + s->size * slab->objects;
> > > > > 
> > > > > Hi Harry,
> > > > 
> > > > Hi Hao, thanks for the review!
> > > > Hope you're doing well.
> > > 
> > > Thanks Harry. Hope you are too!
> > > 
> > > > 
> > > > > As s->size already includes s->red_left_pad
> > > > 
> > > > Great question. It's true that s->size includes s->red_left_pad,
> > > > but we have also a redzone right before the first object:
> > > > 
> > > >   [ redzone ] [ obj 1 | redzone ] [ obj 2| redzone ] [ ... ]
> > > > 
> > > > So we have (slab->objects + 1) red zones and so
> > > 
> > > I have a follow-up question regarding the redzones. Unless I'm missing
> > > some detail, it seems the left redzone should apply to each object as
> > > well. If so, I would expect the memory layout to be:
> > > 
> > > [left redzone | obj 1 | right redzone], [left redzone | obj 2 | right redzone], [ ... ]
> > > 
> > > In `calculate_sizes()`, I see:
> > > 
> > > if ((flags & SLAB_RED_ZONE) && size == s->object_size)
> > >     size += sizeof(void *);
> > 
> > Yes, this is the right redzone,
> > 
> > > ...
> > > ...
> > > if (flags & SLAB_RED_ZONE) {
> > >     size += s->red_left_pad;
> > > }
> > 
> > This is the left red zone.
> > Both of them are included in the size...
> > 
> > Oh god, I was confused, thanks for the correction!
> 
> Glad it helped!
> 
> > > Could you please confirm whether my understanding is correct, or point
> > > out what I'm missing?
> > 
> > I think your understanding is correct.
> > 
> > Hmm, perhaps we should update the "Object layout:" comment above
> > check_pad_bytes() to avoid future confusion?
> 
> Yes, exactly. That’s a good idea.
>
> Also, I feel the layout description in the check_pad_bytes() comment
> isn’t very intuitive and can be a bit hard to follow. I think it might be
> clearer if we explicitly list out each field. What do you think about that?

Yeah it's confusing, but from your description
I'm not sure what the end result would look like.

Could you please do a patch that does it? (and also adding left redzone
to the object layout comment, if you are willing to!)

As long as it makes it more understandable/intuitive,
it'd be nice to have!

-- 
Cheers,
Harry / Hyeonggon

