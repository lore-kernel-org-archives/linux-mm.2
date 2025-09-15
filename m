Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9995ECAC598
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 08:41:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE5DB8E0011; Mon, 15 Sep 2025 04:41:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABD368E0001; Mon, 15 Sep 2025 04:41:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 984B48E0011; Mon, 15 Sep 2025 04:41:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 76BD48E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 04:41:57 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2642913B223
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 08:41:57 +0000 (UTC)
X-FDA: 83890841874.14.5D012A2
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf30.hostedemail.com (Postfix) with ESMTP id BA77F80006
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 08:41:53 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="f/ElitvD";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=d3SwU8Tu;
	spf=pass (imf30.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757925713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ruxt9Pb8siFjGbub6RUvlXWGfHzCvdFhvxGPGwp3wdM=;
	b=kVVXSn45KEAzccmGtHuhHmzEreOTkBcQAk+iCt25nJIbD7pYYbwrXLKQLZVLPKJBrqX1dt
	yIYmAqgG37YITjkU56BLUsBfTlFNfHU2jCSBg2xt7Cgk8SaQG6Qkk/WEaTLe3OsHt7QNkl
	0W51rTBQRY+Voxxa9KqNDGBX1r292oQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757925713; a=rsa-sha256;
	cv=pass;
	b=H+hoeQJzJ5BHdwYpJAymy4SjKkMQCiaTMJf9oGPbBzXHc48qPVSfG65OvgQgflUpwxpWIT
	RfMzlg4TE7KmaBoSMfo8JPd34G4VC6wyFB4+S0NGBjsoV7tezsZvT7iNCBsn1fEP1gPanX
	Z9EXfmDEl4xTIvq7UXFcF+Z9C7XfzgQ=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="f/ElitvD";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=d3SwU8Tu;
	spf=pass (imf30.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58F6fqqI031796;
	Mon, 15 Sep 2025 08:41:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ruxt9Pb8siFjGbub6RUvlXWGfHzCvdFhvxGPGwp3wdM=; b=
	f/ElitvDlblqEKzvG44sngDWovg32ixKgSm7OoqkhOIOUPR9sr2aTYsyB47tm0qk
	lH/699mMeOaAzFQNO0mBMKlJiIB2SAJyVmKrjd5TmrCg8qDHZ/uqaYA+uMfnaRvT
	V72oYTDN3Sg+wmHIek9hNuzqrh1/iynbcG2vWND+4SF6llv0eS2t8pCIM4jomCai
	POhvkPEkNz846i4YUkh5SXXpmhbE0YLRit4Pl1fisWr/AEam/EURS3foOWVYND2r
	D2x5IkW1rSjw5be8o76NGneiJ29E9McCB6fu2BH597fbSjaJkBG9zpM8zP0Ql4qV
	mRfoTByNMKpIJ9GMMtcTxg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 494y1fhvy6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Sep 2025 08:41:41 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58F8OGxh019183;
	Mon, 15 Sep 2025 08:41:40 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012010.outbound.protection.outlook.com [40.93.195.10])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 494y2ayua2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Sep 2025 08:41:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t9yCUG3m/nAoufA6VN17iF1OCqWXb/E3mOfNUfzf9qwekWMhnGaaUWkBXLyag0S9NJJYv7g+tLagv7bDHmW2CTAa2nQREPFahPptSfae13/1v1EOt2iLSU0cFqRocvMhJx8X0XqF79tq1mDv2uUELxXx+h0NqhGT01AJAL6Q552lM+AQxt4GiI1eRFBhMkbMelBKnlrNQb6tdVaQCimd1VENNV5OVBgcjmj41GdM1hSGdPvTAiwcUIdlezZn26b8ghlZKYC0OK6AkJbDCCPisfh3qbF9sHRiI9f6QUQfOfAWx86WuptkBVRA2qQNChmYDEycWrFa9GhibzeAVe+DhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ruxt9Pb8siFjGbub6RUvlXWGfHzCvdFhvxGPGwp3wdM=;
 b=r/tEh9427KSUQ4AMmcUrSt4M9mzrSHk09Yae2qh1k0IfarlisupKjuqjWDY5YCgWSDkEyh+nMEvBpV/6evOl+yZ7ahzT0ABa0siwkt+zO8IcmNGOuDvo8ZYRSLSbbnkmaYYPLSbJdzY4djNSnfk8nLJxTuJX/xLMH5G+HgpTRHGq2/u6zkXEEm1qqKGR7Jh1GVWliH5hRoqS79fI6f1dM6RF5hEff5sAnKqtW7pXKxWSXWWMIIKI2emqGW6e8Dr30f7xCqycXHunO2GPYXVcN9o4TfWdMLMyFtkmVEg103cCQzsYmKzJ6lVAhxYkDynqm3S2Vqp8GUXqyDsY+dLbHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ruxt9Pb8siFjGbub6RUvlXWGfHzCvdFhvxGPGwp3wdM=;
 b=d3SwU8Tu9F3ot18tKV4FuP3EMMy9Qdm3WVeb7WVjhKxICAUu2eLLE3s6z9YuVVsoEWfMJ5r0w7ktamNb+z3wTLUJlrVi+zy67NSyjXmClNFuFjk5yHFVUd8iMnIzevE7qLIE6xusipWZZlT66fNU0A9BICj3J9G3s+5kU2OtaXE=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SA3PR10MB6952.namprd10.prod.outlook.com (2603:10b6:806:31b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.21; Mon, 15 Sep
 2025 08:41:38 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9115.020; Mon, 15 Sep 2025
 08:41:38 +0000
Date: Mon, 15 Sep 2025 09:41:33 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Barry Song <21cnbao@gmail.com>, Matthew Wilcox <willy@infradead.org>,
        Nicolas Geoffray <ngeoffray@google.com>,
        Lokesh Gidra <lokeshgidra@google.com>,
        David Hildenbrand <david@redhat.com>, Harry Yoo <harry.yoo@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@surriel.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        Linux-MM <linux-mm@kvack.org>, Kalesh Singh <kaleshsingh@google.com>,
        SeongJae Park <sj@kernel.org>, Barry Song <v-songbaohua@oppo.com>,
        Peter Xu <peterx@redhat.com>
Subject: Re: [DISCUSSION] anon_vma root lock contention and per anon_vma lock
Message-ID: <a3a96ab2-5a8e-4d1b-9a24-01955f931b6f@lucifer.local>
References: <CAGsJ_4x=YsQR=nNcHA-q=0vg0b7ok=81C_qQqKmoJ+BZ+HVduQ@mail.gmail.com>
 <aMdVcH7KCXBvLtFP@casper.infradead.org>
 <CAGsJ_4xDRB_F-T42WnhqpmwLyiZRwLGqx9vDf_d5TFALsCRX4A@mail.gmail.com>
 <CAJuCfpG1DHeLtsTcD3A46vDV5BwBDAD7B-EVG4TQEY-GSvzfeg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpG1DHeLtsTcD3A46vDV5BwBDAD7B-EVG4TQEY-GSvzfeg@mail.gmail.com>
X-ClientProxiedBy: LO4P123CA0489.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1ab::8) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SA3PR10MB6952:EE_
X-MS-Office365-Filtering-Correlation-Id: 8d1e18ce-1589-45da-afe4-08ddf433af80
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YytBRkk4QVFsV3dSb0NIM3UyQ1Q5emJ6WHc4YmI2L0NRNVhEN0JuNVJRUWpq?=
 =?utf-8?B?RlNqNzBEMmltUWNrM09sbUx2MVcza1VWS2hOV1c1a05IU3BVS0phVVh0eWgv?=
 =?utf-8?B?M0Z6cHA3bktEUWtXS0RsOE9UY3doYW9NZWZjNHhZazRDVVdzMkg3VzRoVXhj?=
 =?utf-8?B?RFdjeHdMUWxacnY5cExud1IwWGxVaTAvMXhaSjN3VDhmajhFazdGMWxrYWJV?=
 =?utf-8?B?RHVuOEVRV0s4Q1RVcm1HaGNQUHc1K3NpTFF5M2VWV3FFRzBUOWk3aUxwNHVU?=
 =?utf-8?B?cm5ZdktPVzBJcUw4bjdNcmZzOTFib25McjBsRjQ4ejlKMEtzRW1lSWZObmtM?=
 =?utf-8?B?THlROWhFWUlTQW1RQTVpMy9CU20vRmIxT3pBSDN0ZnVLL3p5SmJ2REVteHRO?=
 =?utf-8?B?Q3pIRjlJQ1JMZE1sWjdRdmNSUHV2bHJITCtKUjQwYnRYQ0dTV0I1QU9qTDIy?=
 =?utf-8?B?S0VxdWZEQjAyQVY4K3ZLMDdsbFdHQ0F0OE9jaVdROGV2TUdaV1pyTkVuTi9P?=
 =?utf-8?B?QlFybTBWb3NyZWo1U1JVY2hUOWh1LzZSZHdqemc4cWlGaWxnU3R5aUpXaGhF?=
 =?utf-8?B?cjYyb0dHMzgvdzg3UC95dG5UWkhxYkY4S0MzRmNOdVR6b1BBWnZKYWM1RWtG?=
 =?utf-8?B?TW1leEpuUnY5VEFPeE5wRGlMcWVmRFFHaUdMT3BoUHJmNlo1S1RpUVZja09L?=
 =?utf-8?B?TlFSMW5FNGZYVVhISGxMOGVmL0g5dVNzQWtUVEhEcC90bGl5a2lYellYRi9m?=
 =?utf-8?B?alBhRWFzMlVxMDBUY3ZrN0MzVXNlaHd3Nk5wQTUrM1VSZnlQNUxzV3BXbko0?=
 =?utf-8?B?WkJzRVBtejk2b3A5MU9QemhEME5oNXV5ZXEwSFdIZTZUVlVUMm4zTldFNkVB?=
 =?utf-8?B?RU1RM2JEZjNHQS9MdFNFZHNXby83ZVhCSFlTbUVNa0toV092VGY0bGhqakhj?=
 =?utf-8?B?dGRXTW5TR3E1MkxhRkRHZHB1Y1ZOczlWZnBWQVdQYUd3WnBBVmpadFVXZHJs?=
 =?utf-8?B?elJEQnE1dzA5MjNUQzF5VTN2V1dYUzlOTWhUYTJTRWc0c0lLVU5lTXZCaGJR?=
 =?utf-8?B?dnpJVUhUeWROa0FiQmhUMVdoeFJINTM2UW1pUkFlUjRJY1UxSUJFMmE4YnFN?=
 =?utf-8?B?K1Q0REhLTWpwUVhVUGNaNVFYV0FoWnNtMCtPKzlLNVhFckQ4VkVUdG44ZTY5?=
 =?utf-8?B?V3lsSURMcEMzd0Evdm1ERmpHTlA5SVMvQmo2NDR1NlQyZ3daaFVVeWp4dXJP?=
 =?utf-8?B?K1ZhbWcxUTRYWWxjTW0zZXN3ckM2Q2NHNHpkTGp2N0ZMQXQ1anUrMUFjSkJI?=
 =?utf-8?B?Yjh2NzI3S1A5TGNCRGEyNmFMRDlSUktNUjJyYTU2L0FKU2dvbzNDQnRrdndt?=
 =?utf-8?B?bitFb1h6anJmMjU0dDVBdVE3R1NQRTRBam4wbEFBZFZ3WFQreERwdE1tcVha?=
 =?utf-8?B?aUltY2d5eC9CTVJkL2luZG02Um0yZUl2alU1djYwWXIxZXNBMEhMa3Zxck5N?=
 =?utf-8?B?NVhZS3VwTHk0NklzN3RrVE9hUVRxT1lOMEhRbkllUFROekFJREphZE55aER5?=
 =?utf-8?B?NGFFZXdyMmZpV2xOVUdyT2FVSklGVjF1TUoySm52U1BzRHQzRjlER1VwUkRy?=
 =?utf-8?B?ZkxSNmZ6MmR0a2p2WlFudzJaMnZ4SGxtNGs3Tk5nYTdQUG0zTkNQV3l3cjAz?=
 =?utf-8?B?RDBwa2I5OUNPWDBMRzBqR1RCdm9scVNWR1RoY3hkRXdzbUwwTzdqWkYxWnp2?=
 =?utf-8?B?RnNFUDRhMUVOTXFlQkhPODJuY1JOeVFMOVVqb0Yxa0FyMTBnUDFlMjRrRDEv?=
 =?utf-8?B?RXJqZGlYeHBZVUd3QnZrWmYyeFU3Tk5DUW5PazFuN0NQU3dVbUVCV3ZzWk85?=
 =?utf-8?B?TUZCbERHeis4Mlp6Y1lsNmRLWU00aFU3Rk1nOUlLUUk0VHZuS0p5YTRKS1g4?=
 =?utf-8?Q?SivARJIEUpA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bTcrbHY2eHF4ZmgrOVdEQW51L0M0STgzSFhCKzNWMDdhN3YrOEJ1Q0ZhcUpm?=
 =?utf-8?B?QldFVitId3BsbzZ2aERBdUYyNTYrenZDa3prZGtueHdkd3E1WHNFWUR6Ujdv?=
 =?utf-8?B?ODdRV29KT0FhUkFtWG04MFcwQVVKVEowTENkOGljbC9Xdk0vTit2OTNYU2V3?=
 =?utf-8?B?dnAzY1BFUlVqM2xBdWdQRUhsY3BEa2xkTHI3L3ZuYnVRMEl4RlBrN0ZUbERn?=
 =?utf-8?B?RkQ4cmlLL0ZRK3JGR0JYS29MMjZiOE1zdk1zK09UWE5jcyswVE9VVnVacFkv?=
 =?utf-8?B?TFRRRk1CRlBXSkVjTTJOeTR6TnBpM2s1NklzZGFzS2tYRC9RcVR4dVVnbWlG?=
 =?utf-8?B?UnRmOHVydXRYRWpBQS9aeWRYMzhNWTNIdUVpbmxqeVZvbEl5TGw2RHRTNE45?=
 =?utf-8?B?QWRnMWJFQThvWFZMU2xkN0lxS285VnhBTVJsd3NsOWhzVEhvaXNOSDdYa05x?=
 =?utf-8?B?ZDFvNFpNbTRLNnVyWmpWSjVYVmVWMzJjM1Zyd3dKOEc2OTMzcDdqL0pmRFJ6?=
 =?utf-8?B?Qnd6SDY5c0ptT1FBZjUvb2Y2TFZ2L3ZRL05nWmlPYVFXd2hkL0NIM3g4d3lF?=
 =?utf-8?B?YitFVXFaUWhCczJ2bkZZdzlTRVlVa2FaeW00WGUxakVyVTlaeXpqOVRGSjlX?=
 =?utf-8?B?cFFwRXZWOU8vekYrU0xVTW9rcVZBNU1Ma3g0M0Y0RDlpTThxaHNxa0x6RnV2?=
 =?utf-8?B?c1g1SEJHSGpaNUIrNmlrQ05nWTZjazNaRFJyWnJhU2NreEpjMm4vTW1mTXZN?=
 =?utf-8?B?NFcwdG5QR2hzQW5sd0U0YXBOWTFPYUF1a3ZuKys1MTdKbTZUR09TVTFmOW92?=
 =?utf-8?B?ZEZuT1U1UlprTy9WVldmUXNxOFpBME90UEtBMTdNcERYb2xxRlRMemVycFNY?=
 =?utf-8?B?ZFM3N3BteGoyMlJVTzdnSm1uc09ndjIyZGxqNE1wRjR5YmpQdWEycnVEUUNY?=
 =?utf-8?B?cGtvTmo5a1htdEF3RnEwWHlRMW1teEhMTmdOVjJvcE8vZzMyYWtoS21rSWJn?=
 =?utf-8?B?MU1tanp2NWhjeFVRWWg4Q2RmMlBzNVVKRU9BMGw5cmZjL0lYRVYrZnM1K1hZ?=
 =?utf-8?B?bHI1cGFqSGhtTFhNQWJKMEsza3AwYmpONUpGTDhBWHRHbGlhczlhNXJqSGRy?=
 =?utf-8?B?dENMUUFlN1RKN1FMYnFUMEwxVEhPdHVmUFFGU0VWNlBBdEtibFBYVmtDdzdF?=
 =?utf-8?B?WUkvL0cvNEdieEdLUWNiQktPRDIrUmxvY2k2TmFMbG1xd0xZQXY0NmhPdFVO?=
 =?utf-8?B?MFljb3puSTFkU3BRazh0MXVWb0xxSE9tV05VdnIrMVhYdnNGMG0xQU8yS0Z5?=
 =?utf-8?B?Ykd1TlhXQ0NwZE0xTmRza29zbDRiT2JCR3NmakNlN08yaXlhWldpdGRuSVl0?=
 =?utf-8?B?bnduUWtiS3ZobHozT3FITVBzaDAyRFN6T3NBZEtHVng3MzBPOTM1K0V1SURI?=
 =?utf-8?B?YlBtTVpJbTdIY2l6aEVyd3ljcU81by94ZDBxQ21idDZzVERxUjBWTGtqRXpr?=
 =?utf-8?B?c2RkMFpnV0Rpck8zajVwdCtvTXM3UWtzdVo2WnFDRjVzdk84TmtQaXFCUFV2?=
 =?utf-8?B?UUNZK0ZFcXR4dVdPbk14L3dVVTNIaGxZWkRDNHJ6OVZudEgyTmJNWDRMYjJm?=
 =?utf-8?B?VW50b3Rra29haWxaLzhhU0FoczFjQWFId1k0bVp2YUdYZ0xuc0lYVGVTUU95?=
 =?utf-8?B?V2FORUdERDhOMUVkWFY1akE1VThVaUtVZWcwdGo4Vk8zUno1ejd1Uzk4WHV4?=
 =?utf-8?B?WGVhRzQ0NTRkMkRaSlRXU2FZZFg5WElLbzdXNmxhcm8yUnJVdTFrOG1yODUw?=
 =?utf-8?B?aXFSd241cW1tNmh1bXBXNEdxaXBLMU9CKys3Uk8wWC8xbkZkL0Z4WmVscFoz?=
 =?utf-8?B?aUNSRjFDRGUzZ2p6MEFBdUZIR2taQUMxWGg3Yi9WZ1d0aE5EQThsaXkzVjlV?=
 =?utf-8?B?bCttVzZJcmh6bldmMWlxTExLK3VzcHFqSUNLVDB5NUorUFhDTFQ5ZCtLZ1p4?=
 =?utf-8?B?bTkzSGVCeGpiQlFhKzdSRFQwb1dYMmdNMHZaQVh2dm5Gc2pML2tWNVYxNXNv?=
 =?utf-8?B?NTJIMlNhYUdmZUR1Mzk1Vk9pYXBsUFVaaXoxZ2tMcTBTRkdvUFJlTDJlbTBH?=
 =?utf-8?B?UWJ0RUpncmgzd3dGeGRmbmVqMnRoWW1CMU1Zc1JDSldZRXFEaU9xL3JVN2FV?=
 =?utf-8?B?dXc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	j7CGvzz4szJxy02UAQ8zEG3dlm1n2ou+XdArCW4v952rt7wUDl66MSyRBQ9Pw0+B7q5B6tKgu/WFF7SNSKXfREod/MXyygg8igoJrKpNHxfN2Os2HXS6cmsPFMswvtmenpyebeG8yP83vc+Fgt2AIusPAG+lJnu5Yj4CkSH5qGJjCAqJznRmA9BvjgQHmFt0lHAmM2iR/o3aDre7FCSwgMn9MiGuGTyoDsRA21YQcrPXE4H9d6AQ3hxfNuCwkm7CIwHJYAt+Y1L6yFnNB/ARAzN8WVLbaQu0x1OVQnaKMg/w3Q8z6luerWy9PCOk9jeylkdtvhkIAAgT92HfDJKS4Bm2Uqtk5p+nfqZHkFbzMDQOkArtO1zpjzM+X5+oSZ/UU3Z70bfX1dLvPoqmGwMJHAxqi8xCeD1qZjMYUWSm7XaAlzRedXJ09Dh2EWSaXHqdIE3JbZof/fW9LJSYLRCdNDLdYNVAWKfxPooQHnuFs2CDNAbcOjnYs0ZHlafIUzkT7POl4Rzw+4e2IJviv64xSCpDtgokXKJxgDEKsqiX1ypkB3HTtE6aEhOR/QSzYfukjvxCCf76gKYCpaW+LjWE0x0pH2mDbPvnVVXO+M+EVe8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d1e18ce-1589-45da-afe4-08ddf433af80
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2025 08:41:38.3199
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YSCMsnrPGhhlgFD00ZukmFEqqTJ8e1HkLeOO7nL8RkzCsskp/jdfZwPTP7/PFzjYF3fIVXklboJGHnFtQbzGHqdxirfXWZmx8V2HD/HvgP4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR10MB6952
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-15_03,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 suspectscore=0 spamscore=0 mlxscore=0 adultscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509150080
X-Proofpoint-ORIG-GUID: v3f00yfEV1rMdTnX5OOPHqnV0c7HLMd_
X-Authority-Analysis: v=2.4 cv=KNpaDEFo c=1 sm=1 tr=0 ts=68c7d145 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=pGLkceISAAAA:8 a=JfrnYn6hAAAA:8
 a=pQrAfrMi3lGLwFlyzQ4A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-GUID: v3f00yfEV1rMdTnX5OOPHqnV0c7HLMd_
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTEzMDAxMiBTYWx0ZWRfXxcNZ0BTQMIvb
 I3n4Ivm4lTKrpULzSqgvCznluTeqLmljr+9XqAL9BXMI0/V0wxGsLQkExLhnGls1lZEfC4Fj2jF
 MNZQHSU66vSA3wgqH6F8ACsFp0CE3ekDMhEATg/oALP2sPrAUPJ6FdtMizBo40p680feJCAtXCf
 eSjCf1BheM/E6glh3h4z6Ga+ftqwYGXmzzfWIQAXN+XiyfCvTYhS4+lg1euYOef360RX1GcLX1q
 sgYB7xDL+cF+T+0XrM+vTSe/9SCdD2xFnQS08WQzSFAN5JhoAK+TaM5oS5E4K4DwYTTuSrVhb95
 fYaKjmILE3JJKizWWW+KqrUKS6OfO9TQJF2tnoJ9CyBUVcWZq6kUhV43cPe3FfUlHzLqdTalku8
 FJLkSaFC
X-Stat-Signature: 3px1yyj1f8d5buznfibt3jgr6dapj61i
X-Rspam-User: 
X-Rspamd-Queue-Id: BA77F80006
X-Rspamd-Server: rspam10
X-HE-Tag: 1757925713-100426
X-HE-Meta: U2FsdGVkX18j7+35IZHBgvIPr6RrTzm76KXNNRveu/2pEhiQLkDFUYTM1on1Rcipfr5P+PPX5bQV2lfBIJTBmxWDxm7B3JQHBfdSSdWWphFXRrMwLrFry1LVZhFHMir3Au4uKSzxUVb9dmWGDwXO6t71sEb1dnRzcTsS6mkLhrlXnYgcJnIkV19vPCL8D7DgpNaGOA7S9RymElfdW3RjCH2i8YypeimGM44xxjP3EfXMuO+tMpErjYS1ILqeo04DMRrzhmj9IHIKWzXZWQW3WWdVE+8JqL5MT7zvfFWafl8AdR4liRJPi8RtT5VEdzE1QKIdtB8+ZI42CtZo17mik+dERmmVcE2vHapOKjTvgrwffuzT72SmagxdWA4MQ6o2WfYVjxguPDzBQdbFGTNrMU7b3KRFu7RxDC+X075nKiCeXNi7xToICzEFFLgj1MFVKoRJetgSd5i1G9+/MQadE/VKKvnhBqPK7XHgTdNGMXTGwYqL8zUxA7bZ2L7N0Z2oh2r5OcR8ALLyRHyUJlEAIP2mTPtmKCy/V5jHKvKxWF0cTtmLMSADBfvfcmeTphVSW5/EGAQ/BtJTVt+3i/Z4y5VoGgVn/6EDjxEVXO74fU1C8Op04dFxL4/rT4XzjWMcBL8CK4rpJMNtkCrNlkPQWGlOz8cLNQYlupLd9QQ+I0T2c2y8EFO/I9NDgVjaT9J93YmcfJxA3Qbm4rt7mToGL1TRMVQ3YVqQclhYQqErlwnLIlV8E+uJHZHHMZ70SBz12lBAsxM6MTaf/6tWlKm9YKS/jFD+3BNMeNlQeBQGBC66W+TxhYjbwng3+7PshAZ+1xiXk1KwPX7NPTCLiT5KuR8ijrYL17vgO7a1bfGfxNelRd0ga5put4GWG4MFTp9mg8KOX1t3bY2XtbZ8WUSu7SzEtvo94E6Z+9fxD/5zUMJwjD1zZG6DvSrRkcpsmsGG+/45QlQaRQiWes4hJ4v
 jxbIVHJB
 ktWJAKcE5jhlwT6xLLphc2FqlCiw5rdiu3gJcoUAcNttA8c3DURuXnV8OqVOMqaZz7IPLHrcy5IAR3ChBU4/OpAs7TONdrCaGksLoktCwoY+9ROh83FOvz5oKqxi/JFW4CWVeIRLts23F8TP4Xe1PaUadhbFF2OFdZFHHciY/xMAZRYRWgY0A6+wMWXDUJUFblTUJLztSG6iIkSPjUOSglrdZSOfTHl4x0M4ksN9wwI15U9FmHFj1vP7X+BJMmynT2AMZPQdVfPDPJyS8rpCyisKyNkwX4v76IABDv+LHAYrbKSNIeVsSTkQmqSGduWhcFhuiGDmk0sITgdbi6R30/+HJo4hJw7NWFyG3JxJNwp81iKyxEPy+OwtdQGTswASRjjihJF7tHSKkV5V5pUatv5Oj77LsJR0LkA6bWMLVx8UeqVa8L7IubD2hQ/X2QfvHy9Lvr8ui4MrZISFpYH+PiSG16E7jt9i7LnvXJL0jBQzqzT/X3eCDOXAj1bshoPsMfrG7afrwgnqpBJsua9+SpfluIMDnOaY5+AmBEbJUEUwcngS5zSOPg1rN/b5pl2tVITL69Pp0BbOsFnl6LVSW2mKPiKhdKyftkJ9gkcIGKdHshehrqJIZiVKo3+MX3xjhQvJt0ZDVjz5sREDbe+DwVoZo8koYyk13n4BuZ4jltEPrQgql0uHfnhcwqfnefwhiXBq/hrYbrdAwHgxqufpwauLaS58cGh/whwwkvZp4x1dVWHLC6GdDuWWXWZP20wSNnLbaM1b+5t3CHGpvMwmGcsQNVAUTh7vXSbBbVTacErw7GSg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 14, 2025 at 06:47:48PM -0700, Suren Baghdasaryan wrote:
> On Sun, Sep 14, 2025 at 5:23 PM Barry Song <21cnbao@gmail.com> wrote:
> >
> > On Mon, Sep 15, 2025 at 7:53 AM Matthew Wilcox <willy@infradead.org> wrote:
> > >
> > > On Thu, Sep 11, 2025 at 07:17:01PM +1200, Barry Song wrote:
> > > > In the process tree, many processes may share anon_vma->root, even if
> > > > they don’t share the anon_vma itself. This causes serious lock contention
> > > > between memory reclamation (which calls folio_referenced and try_to_unmap)
> > > > and other processes calling fork(), exit(), mprotect(), etc.
> > > >
> > > > On Android, this issue becomes more severe since many processes are
> > > > descendants of zygote.
> > >
> > > I'm not nearly as familiar with anon_vma as, well, the rest of you
> > > are.  As I understand this situation, usually after fork(), a process
> > > calls exec() and the VMAs evaporate.  Android is different in that after
> > > the zygotecalls fork(), there is no exec() and so the VMAs stay COW.
> > >
> > > I wonder if we could fix this by adding a new syscall:
> > >
> > >         mremap(addr, size, size, MREMAP_COW_NOW);
> > >
> > > That would create a new VMA that contains the COWed pages from the
> > > old VMA, but crucially no longer attached to the anon_vma root of
> > > the zygote.  You wouldn't want to call this for every VMA, of course.
> > > Just the ones which are likely to be fully COWed.
> > >
> > > Maybe this isn't practical, but I thought it worth suggesting.
> >
> > Thank you for the suggestion, Matthew.
> >
> > Lorenzo suggested possibly unlinking the child anon_vma from the root once all
> > folios have been CoW-ed:
> >
> > "Right now, even if you entirely CoW everything in a VMA, we are still
> > attached to parents with all the overhead. That's something I can look at.
> > "
> >
> > My concern is that it’s difficult to determine whether a VMA has been completely
> > CoW-ed, and a single shared folio would prevent the unlink.
> > So I’m not sure this approach would work.
> >
> > You seem to be proposing a forced CoW as a way to safely unlink from the root.
> >
> > A side effect is the potential for sudden, heavy memory allocation,
> > whereas CoW lets asynchronous tasks such as kswap work concurrently.
> >
> > Another issue is the extra memory use from folios that could have been
> > shared but aren’t—likely minor on Android, since only a small portion
> > of memory is actually shared, based on our observations.
> >
> > Calling mremap for each VMA might be difficult. Something applied to the
> > whole process could be more practical—similar to exec, but only
> > performing CoW and unlinking the anon_vma root.
> >
> > On the other hand, most anon folios are not actually shared, yet
> > folio_referenced and try_to_unmap still take the entire root lock.
> > In reality, they only care about their own node—no need to iterate
> > the whole tree.
> >
> > I still think optimizing from that angle could be a better entry point :-)
>
> Hi Barry,
> Thanks for raising this issue. I think technically the optimization
> you are suggesting is possible and it does look similar to per-vma
> locking in that:
> - The reader tries to read-lock a specific interval and on failure
> falls back to locking the entire tree (root);
> - The writer write-locks the root first and then one or more
> individual nodes in the tree. Once the writer is done it unlocks all
> the nodes it locked and then the root.
> But as Lorenzo pointed out, this will not be pretty, as it adds yet
> another lock and more locking/unlocking into the writer path.
> In the case of the pagefault path, improving its performance at the
> expense of the writers was not questioned due to pagefault being such
> a hot path. I'm not sure reclaim will be given the same benefit...
> Something to consider.
> In any case, I'm very interested in continuing this discussion and
> would love to test a POC or discuss this at LPC.
> Thanks,
> Suren.

Hi Suren,

Have submitted a proposal to LPC re: anon_vma in general, and (in collaboration
with Barry) am planning a PoC for this!

I think we need to be very data-centric here. So we have to ensure that the cost
is worth the benefit. Anyway I should put out a [PoC PATCH] soon!

We could even start by looking at a crude version that just uses per-anon_vma
rwsem as a first step.

But I do think any actually workable solution will have to resemble VMA locks
for it to be even vaguely acceptable. As otherwise grabbing the rwsem's y'know I
think probably a little too much overhead :)

One big issue we have here is that we are doing anon_vma clone on _so many_
operations, that is split/merge/fork.

So yeah needs assessment, but I think longer term this kind of issue can feed
into my 'grand redesign' of anon_vma which is a simmering background task (and
again I hope to talk about at LPC if my topic is accepted).

Cheers, Lorenzo

