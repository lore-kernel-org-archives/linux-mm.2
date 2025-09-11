Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CCBACAC587
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 08:29:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59B8C900003; Thu, 11 Sep 2025 04:29:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 573168E0001; Thu, 11 Sep 2025 04:29:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C959900003; Thu, 11 Sep 2025 04:29:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 189998E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 04:29:09 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BF48758DD7
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 08:29:08 +0000 (UTC)
X-FDA: 83876294376.13.4681F3D
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf06.hostedemail.com (Postfix) with ESMTP id 32669180010
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 08:29:05 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=G5Yuz9q+;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=dUUWCq9e;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757579345; a=rsa-sha256;
	cv=pass;
	b=wmm9FfiDgp/8C61AXGgkxT95W3Nfc3ZZFZD39DV9R5id+7aLwY3DQ90b+g8+UsBIkV5Uje
	MAS+e5UT0MLUa8ike8PZCd9howVpTkXhHyhPuT4mri+0jLzt8XXrV2q/5MhRFTYZcQj4V/
	EMB2LBMebO2uv5/qGjiYo53zGHsZex4=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=G5Yuz9q+;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=dUUWCq9e;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757579345;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/hXHHx0hz7l37n58tyZa/l7VADssYCEik7ZZyWwHgW4=;
	b=2IMRXkEeQ1Coq0iK4qpsS21fB3+7AqPnLpIYwG4JuFdUDdt18IFGwtqMq1sOUgG8BQXC9a
	rZvk01uWhjWMgM973+t/VzAkBDcc0FUH3eL2+nVtDlDmyE9ghtsf/2oprRVIrbcGtOuyux
	K+zzNv26ex7CiZqZMWpQcEGfNOYQzro=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58B7tfO2005577;
	Thu, 11 Sep 2025 08:28:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=/hXHHx0hz7l37n58tyZa/l7VADssYCEik7ZZyWwHgW4=; b=
	G5Yuz9q+SmsGz17ZcyEUtMAkqejnWjOesYI1gT7iWZZJqBxa/FSQpoQooISUfRpe
	wYE7DDqwaDPEKrzxRcWFAJrGzUm4Zk+MtnvtPJc2PKuWnOltBRa8hm9ui+LAjq6B
	/eo6nFY5ARDtjODve8ADWsVcx8KW1kRFzAMk7Sx5bLF6Sn0WYOgv4eytuUIaAYwx
	EsrRJOvXpEMA2lZOhBGbrns9Ufl0atlIEPnfZa9AbgppVnpmwvDlm7YiwYYaxCBS
	ZgUSYotW8KD66EdG5yx037Zs0lTROnSnjpmIqx1nRnDWWL0RpVHCrtlVSvz9ZICQ
	SpUT+14BeKX/CP8KbeuP3w==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4922jgwt8g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Sep 2025 08:28:58 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58B6r4ok030716;
	Thu, 11 Sep 2025 08:28:58 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011044.outbound.protection.outlook.com [52.101.62.44])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 490bdc3xg2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Sep 2025 08:28:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MLf986q95HMcbbIQX07T1EtoDmjwMAnxZzHTLv26c2SusqFUBnz1swJckmTup7sx6vmJ4Y1lQvhx3BiPoUZM7w85V7CvIj1hxnqcCK0FK+kJDVG58OfF8izeE4XIJHlhUOVKFfnc4iJt8Ul3kl2hulUyYgcvyB6/wLbIP7k5KHhf1sMgMFyh5y+WY7xkQNwE4VVkbpZueukknURSPm7cjNi3Szpg14KcJXyWDCfYOXtjsta7qk62SZ41DayiSpJF70im0wnoFz4KfsSSyUF5GkTSbAbQ0LJAGUEFaNmgeVip9B4AGp0rNladktk5RG1aYaWIuepMcq3z8ZpRL5vy4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/hXHHx0hz7l37n58tyZa/l7VADssYCEik7ZZyWwHgW4=;
 b=IRpStME6tu/+By8j2/WzoEpxCDW5fZ/XOFcBsXgqt9Zwman0cpNoCDPz2ddJLXbaOl/iJRudHMrDashzWqCWzgNsjtSvxgz0CRIhOhdJ+KnPHXK+ShmV5FxXQowY+tmr0QO03DbQ6HpZ2L3EDgSzFV0NIFhbxkRgJLeV4WRtUZTgW9XTb+rz+rLcIliZKv65Tm3AGf/cR0vt241J9l4wV+dZQwxbSMdZmD/Xhb3dofZFhI1wKVB5cTxPMmbYMqGZ38JnYRyXOME1PukhaXks/hrJ64EEH3w9HAno0Z+jrX06IR+9k1x45gQyzTOgyxVGAMr8b9HoqnxJdz5Bw5aK9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/hXHHx0hz7l37n58tyZa/l7VADssYCEik7ZZyWwHgW4=;
 b=dUUWCq9e6ImvWR06XclYbV/U34cbNcbVTZHjhb16utLVak3GZyB28EyB1UghKa/wPoXjC30YJUTMRYKryA+7/Eyczai2CRRghc/Pom6G/hjttVRmTOfN1PsGnLctrvU/dbGBcire40zm7DVUiN6m5prULFzJHe9ij7onlWrPTjA=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH0PR10MB4470.namprd10.prod.outlook.com (2603:10b6:510:41::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Thu, 11 Sep
 2025 08:28:55 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9094.021; Thu, 11 Sep 2025
 08:28:55 +0000
Date: Thu, 11 Sep 2025 09:28:51 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Barry Song <21cnbao@gmail.com>
Cc: Nicolas Geoffray <ngeoffray@google.com>,
        Lokesh Gidra <lokeshgidra@google.com>,
        David Hildenbrand <david@redhat.com>, Harry Yoo <harry.yoo@oracle.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@surriel.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        Linux-MM <linux-mm@kvack.org>, Kalesh Singh <kaleshsingh@google.com>,
        SeongJae Park <sj@kernel.org>, Barry Song <v-songbaohua@oppo.com>,
        Peter Xu <peterx@redhat.com>
Subject: Re: [DISCUSSION] anon_vma root lock contention and per anon_vma lock
Message-ID: <a67129f8-9ff6-4109-bbbf-4209f6dfa3be@lucifer.local>
References: <CAGsJ_4x=YsQR=nNcHA-q=0vg0b7ok=81C_qQqKmoJ+BZ+HVduQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4x=YsQR=nNcHA-q=0vg0b7ok=81C_qQqKmoJ+BZ+HVduQ@mail.gmail.com>
X-ClientProxiedBy: MM0P280CA0019.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:a::11) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH0PR10MB4470:EE_
X-MS-Office365-Filtering-Correlation-Id: 97c45243-8982-4b02-2de5-08ddf10d3ed7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UXVRdlhja3IrWjBXVnI3QnMrNG5jU0poNks2QlhPMWxtZzNmdzJCMDNyR00w?=
 =?utf-8?B?amt1ek1hYzJNa3NTeXZhZk1TZEFYWmhHMmpjWnZzRkVpZHlzb3hXQTFEY0ZV?=
 =?utf-8?B?SjRmMDFnVFNsc3lZUFNRQmJsaHhBdEZKNGtVQ1poTzBqK2FwZHY1ajRtVmZm?=
 =?utf-8?B?RjFYKzJ2S1hQaGRRMmd1RENseGo5YjAxVEp0QnZjS0ZRZXhOS2dBM2E0Y2JQ?=
 =?utf-8?B?MFl3RG4zVkNaazB5YWlHeFhZK2grS3BSbTcwV0g3VXhDaWh0SFpkY2JlY0xw?=
 =?utf-8?B?Z2hLb0xlYWhvZnN6T01ndzRHdUFGcWZEV3hBbnZ0emJ0VmxYQnBQc0YyQ2RK?=
 =?utf-8?B?d0ZzdTFscnZ1Y0RxbFdWNUlKMG4ySjFRVmFTUXJmTFh0eDJ4bmdobFpLUnhW?=
 =?utf-8?B?UnVlNUpNY1pMNnBZb3VSU3Jna3ZQWlliMk9qeUlleVNqTjlObVRrSjZTblkz?=
 =?utf-8?B?UWNib1I4L2gvZTExd0QxaERmSnBJRjBnT3phVUZKMWpaSEVuV1FNYXBPQ0hO?=
 =?utf-8?B?VTZTNkZDR1htMWViKzNzaTlRL0FiSGtnZU80ZlhHeldHVndCalZGQTFhdEhO?=
 =?utf-8?B?TVRIaHpuWm4rYUptZmZIQ296UUVJYWIrcDVoaXpESTl5RXpwU0Z0b0Z5clhQ?=
 =?utf-8?B?bndyNmlleVRkcG8yZXpnRGpPYjNQeVVvRnI5dWdhWDI3QXZmd0NNcXJMS1dr?=
 =?utf-8?B?V2MzSEl0WDFUcEx5d0pVS1N1ZWphZHR3OXkwU3R3ZktrOFNHeWhXYXFNWENu?=
 =?utf-8?B?QnFxeWphd0Q4aXdWV1RGUGpFUGR2VnI4OTEyamFCRUprdGxXYnRxaURqQjVt?=
 =?utf-8?B?OEJGcjRUNTVRUzlsSEg0L2lzZkRTRmVqTldQZTJ5OURlTm15Wjk0TENkd0ow?=
 =?utf-8?B?QzNwV1RHMUdPWmlSeU03ck9uNEdKZkg3Nk1maUFKMlJVUERvbjZKZXZOZzdw?=
 =?utf-8?B?a2d4TnZIRWl4eXkzcmpyQkI5V1puSVRxS1RVN3UySHU5eUF6NWNrNitXM2pL?=
 =?utf-8?B?a0RyR3orSXh3TzFYckZ6ejFTOXZTUGFrUWU4bzBiT0xuSEM2aVNYR1AyaFZx?=
 =?utf-8?B?dkVtQmJRVW85bmduQTMvRjByck9hNXNJZTV0TFUvY1gwVmV6ZEsxYUxZcHh2?=
 =?utf-8?B?d3pUcGl1am9rY0lFMVEvT014bkRKTzBKUEhPWm84NlRWZExaOElmYmM3R05J?=
 =?utf-8?B?VS9KTG1IYUxXSVJ2ek1lckRCNU5xc0pHc3N6ZkVLeDQzeDFjTnhEQ3NjSXNU?=
 =?utf-8?B?ajkxYktMa0JFYXdBMFZic2NkL3c0bVhreFQ5Z1VBRjVvU3o3SGRLdVVLVkQ3?=
 =?utf-8?B?emtTK29UKzlCbXpVSmdsRXh0d2IrZVdjT2ozT05GVVZaK3ZldWZ3RGQ2allt?=
 =?utf-8?B?bW1XM3paZy9Sb1BqM2pCZFdndEgvR1ZjMFZDcTlLRk5xQ3pwWlozYmdvQy9v?=
 =?utf-8?B?aUNFMUpFcml0aGYyRHUzR0l6ek55emYyVncwRjFTRGV0S1NWRXFQVysvZ2FY?=
 =?utf-8?B?V0FYMEYzdXI0dXVUV2FxaUVBSlRVZFhHVEFFYXVWRVJOek04T0E4THIzdy9i?=
 =?utf-8?B?dk9TUUExY2VJNFowRExPZzg5WHl0WFRRSkRvTWdxQStNd2ZMSHBDSlQxOThQ?=
 =?utf-8?B?cjJWOE1rL2NibXprVFVJZE5QQ1ZuRDM5VUVIRXlteHp3YVAxOEt2djMwOVFJ?=
 =?utf-8?B?RmhGZ05aR2FVUkhiNHBCZDlVc0wwZzRHa1dITlU4MTFlMDQ4RmNvQy9OS2Rt?=
 =?utf-8?B?aVZLYVR2d2pFd3lkcEVzSzhqeXNmYkl0MVJPVGVzNmtCcFJUV0dXTjAyWmE2?=
 =?utf-8?B?OTFURzlmU21oTEs4anc3L3F6ejAzemNRNUtBTTVONm9iOS9hMzUyNk9ndklC?=
 =?utf-8?B?NnFSUmh5WnVXK01KcG5PUEFyT094SWhsTjlIcVBYNkV6SVl5di9ISW9jZ1hm?=
 =?utf-8?Q?3G5Rkq6kQBQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Qk1FL0lnYTJaRWxnbm1xSHlZMmR0TE5iZkxHTHpPZmRFdFN4TVlhVTdJVDg4?=
 =?utf-8?B?YnRlVnpTNERDeWh2UlllT3Uwb1ltUmplbTd5WFMvYjJIdXpQM2VOZnFkSWth?=
 =?utf-8?B?MTFtbVpTdHAzK0lRdk13TXNVSTdrS2F0OXdGSUlwVmFMOTRWbmFEMHI0ZlV1?=
 =?utf-8?B?S1pGS0czTG8xSTkxQk5qaHdWTFhUVlgyNXJkbTJYV0JmVjk4S0k3TkxRNGRK?=
 =?utf-8?B?b3RkK1BreHJCMW1UWEdzUGhLQ3NVRGpyOGF0SXlzc0hGMkc4TUpLL1draEVt?=
 =?utf-8?B?ZmhsN3ZQOHlYdlpVU1Y2b2NqY2VkWlVDTTBQUFNUNVB6NmJtbEROd3pwWXlh?=
 =?utf-8?B?V0Q0TmZ4N0tsR0hXY3RCUlFZc3lRaUVCNHNSQVVySTNhRjBKTi96NkpaQllw?=
 =?utf-8?B?eXhOY2F0VGtjTG9GM01wc3dvd3BKb2xtWE1SZ3NmaGZIbkErSGUzM05CenRy?=
 =?utf-8?B?QkU4bTI0R0wzRm1kQTNiOFFlTWsyY3ZUSVRqS3FWeURTUlRWN0lBUnBsRmJv?=
 =?utf-8?B?bFByUUZZa25zUzlYdVZRZk5jdHdTZkVaSkg0NkJEZS9VVWxZNW9VNC9pSHd6?=
 =?utf-8?B?U1V1c0hzTmU1T3JiU2VSSmwxNGdCbTZ4NlV5VGdYUWp4ZVo3K1FZVEJWQUlo?=
 =?utf-8?B?endUbW1HUmhtbXBZejgwbmpvQ1BkWnFYL21ZRkFkM09WN3lnbEVkWStFcTQw?=
 =?utf-8?B?ekJJUzAwMlBCLysrMEVzbEU1NEZRQ0x2VFI5M0VVYy9Ob3FsQk1heVZabFBW?=
 =?utf-8?B?WHNYL2lhSjY5RGFVUWdLMUdadzBHbUREVUlhLzArK3hCTXVLNlU0MjlmUTB6?=
 =?utf-8?B?ODZiU0R0MjMzeE85bUtnV1NWalNSbDZQVXRXWmg2Z0lRY1JSWXJ0QjFMNU42?=
 =?utf-8?B?S2ZaNlQwMHhJdzBSeS9DRjZ1OTdKT2dESnBBa1pnYm9mTUhERmZJL0ZDYmF3?=
 =?utf-8?B?ZmZmcXV1L0dBaW1KMnd3TmtGLzEzZmRwT253RDdkektxT25zV1NrOUJUUkF2?=
 =?utf-8?B?Y0VNVlQ4bXdKaXh5S1RDdGZtclYyTnhwQzB2Zk1USWxTN1NlYVVtSjlsTlh0?=
 =?utf-8?B?QTdQYm8yL0lvOFpqTmUySkZaZzJOTVFmTTVWTWFKMGdRYnIvZnQ4NzJpeFM4?=
 =?utf-8?B?Z2wvZGkwSHd2OGlXcGU3MjFhN3RlTTB4aE5yQnN5UHBaUEM5Y1ZMS1hrdHl3?=
 =?utf-8?B?elhvT3hDL3d6T0hVNnVRQkdYQTlBdk12V3JDbmhacXRHOVdIQytRT0VDcDlJ?=
 =?utf-8?B?aGNhRkpKL3p1SC9lTi9XR3M2NHpkRTMxeG5GckFLbFJBNGZ0aXN3anVhRGda?=
 =?utf-8?B?Q3gycVZac0VSMkdQUnRPejU4ODB6U1Z1SFBJQkV6K0VwQUVWV3F5UytzRzh1?=
 =?utf-8?B?TGhDYnNyRVN1bVJETlN1WEVVazNwTTBaY2NYM0dxK2hyWm5JTllRYlVNQVhH?=
 =?utf-8?B?aWpxOTFXNmx5UVFDdHpBbzU2UVZFN0lQYWwxQTFBYUtlUnBGbytTMzFocUE0?=
 =?utf-8?B?NUhVckxmUFJQRlkxRzlIUUFMM3Y5WEp4YnJReFAwR0lxb3B5TlFrcTY1WTFi?=
 =?utf-8?B?dUpXbTVXc3F1RmI2bWZvRHpPUGQ2NDMvWE1RTFovTVBrYUEyb1JjQmpBN2E3?=
 =?utf-8?B?L2kyb2ErT1dwVWhZWFY1RnNmeWlJWGd2dU9sOENTUURXWE92OWV1N2ZXV1A4?=
 =?utf-8?B?ckhkL3hrMW11L3I5dld4R3g3Vk5OU1FvM2c2b21WcXRJczZWcWFFN0F6UVNr?=
 =?utf-8?B?RUhQaGppRmpKS01qNzBhSWJMdTVHaFpiQjJ6YkVqU2ZGaG5nQjRTdlRETzNV?=
 =?utf-8?B?OVB4MXJaakRqaHFoMFhOVW4wdEdJTG9xdzR0WGVMb0s3L2xVYTM4MTdhbU1o?=
 =?utf-8?B?bFIyb1NVdHNTWjhseW41WlhpOFNGTTZ3RFBLVHA1MXYwOXU5L1ZoVk4yV3g2?=
 =?utf-8?B?S0tUQmpERXBWaE16bmN3dERJdklpTnZubmJXT1N3V3VZN1RweFE3WFlWRXdi?=
 =?utf-8?B?S2xCYVVMRGZlMjNDdjJkVnZOSHBQMklEVTVsRytxZHBYZUJRemJqOWxwRGtq?=
 =?utf-8?B?R0Qva3VjVlJMUXl1QmNFNkhvM0xYTDNIYXdLVk1KQjB2UTFxUVFrUk5yVTdy?=
 =?utf-8?B?Qzl5OGlJdnZpbWxVN09XQVVZcVpocjJwTnBxQ2JCVlhyWlMyeHp1U3A4TWdm?=
 =?utf-8?B?Qnc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	nth23xIr340/pItdPV1KCeI4ft436xr6/kO3aubVB+LM1N7pkgnKg+X+ALIcsejPukJnR1EJTgaMVo2C2sb3uJZreInoICfzrSKkgj6rsVLq7o6KyVtmNtIDsQwFBLDUm0nB3gMy7j0gzYWt/fWuucHf/djdQlcd283UFRN9TsII61b+wBBY3OqS40EsnAQ/J5uk5tu+Ckq8y8K3XzDfKhEMT0F0iIoO3zw0Hjggqwe8UaziPDTDe2f/P/TzDfvhsvIolDXx5n0erVMMZNjKChqTwyg++spGhtPijUDRWUnMN39ruGQgUbiAgNRdyb62HWj3SFYB++5i/oLi1x9iZbCbFWmc/0C/BH/u1wXLeusFkW/a3fyr8grQbsxCGQspUOqeP7UBnAvM1y1v/vuBWLEBz3wEiHFUbcd8LERhiZ/u+VtCMgA4MpMCTtBcE2BmdifreJy5enNq91wS1L9/CnDDcVaE0GDayHQmMIls9CfxVko0DkqVEbQqSVzb6iM4Kludvd+wzmPqANsjMn+P1989CH/bPgPVI51lcXvIJhA3V8DnilF5DdsnK/IKVJy0QVr5ViXsX55Xqhfce3hbCYucIabh3eNpagb/X37gqyY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97c45243-8982-4b02-2de5-08ddf10d3ed7
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2025 08:28:54.9429
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jSEogDlfZnPfI0cjg8V2yfxIOxBI94JizesIGryPZgUWiuOZSrjhU7mroeCoGXN+ImSPNzZCNTGUY30hu0dBBnrqMFZWqoOnEi46WdEzbeo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4470
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-10_04,2025-09-10_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=848 adultscore=0
 suspectscore=0 spamscore=0 phishscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509110075
X-Proofpoint-ORIG-GUID: Pwvm-dbO9YYQ-F9rqfT4Lh8Xn4nZCsNQ
X-Authority-Analysis: v=2.4 cv=PLMP+eqC c=1 sm=1 tr=0 ts=68c2884b cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8
 a=ySJWfUE55aABmM4tAp8A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: Pwvm-dbO9YYQ-F9rqfT4Lh8Xn4nZCsNQ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE2MiBTYWx0ZWRfX50ETdHpn0eBc
 UtDCBNkW8anoxcLnQTv/c4mNa6JSn3g+9Sx5K17TUWdQCp6ljLvIu9slH1vLpI9oB4z67KCs1+i
 U4kKInvDproL9u2oxubWPH6UjmwPBBBe4u9Pj3NCOhFP0BpCFhxnsR1amCCPoUP+tj7MiBA+hzj
 +HYXUx0EhLyOAUmOZ2SCVjICwgtPO84vj+TdI9HYoRC1dnT1l1eT+UtaB92ROp/q1C5hOZ6CELr
 4bYVjrc2/MXP/2zIqfS3AWN+iGputPN0PYX9YQKs9L67hc77VmoW0+Ds7klVNhMi/qDfJUk9njF
 1Qsvp2PE02Bw2xcaelx89NQIl6OfOI3GBop+bngENFj0B80y49szsl5sEmBOXDcL4x3i6zlIXog
 LUFe9I5q
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 32669180010
X-Stat-Signature: 1ruri6o5q38dsef6beec55q5jhpegi1u
X-Rspam-User: 
X-HE-Tag: 1757579345-563
X-HE-Meta: U2FsdGVkX1+CcS3RdLs0PQ1Jq1kcGH0SSFUfzeAXTsET7t4Lbd26KVimycVoS+1K+3xbdTjTusc250Qc49yX8im9l8zwRog/z4pfWhDN7FmFotHxvHMW8rYJ3G72ltZ7haL6v6Y7kE7V/lRU3Vvt2CUq6gWFjgytQbxuPg5NT1B1n5v7uUsYS79llZIAehSiA5i93iROZ00VSm+fqYh8eYnoWdaJfYgQtruVkgxAkFJ0ILFOTDXv+pd7E1RxJ9H/o60JuaU2YWJ/200i5B7ozU585pmdWaHFrKOlVS/2LJibDkXonBhOPsryu7aEqvxGn4v+g9upU8DwugdYyhBx8Ay4HbozKcUTTwAjlr82XgO/OmWXhKFq68IQIFexCPe+u5vUYIH9s6idcVazjhfOMJ1Y8IFhHGAVjbD+0D3H4UAJZ3NNESaJlvRsm/A86Y8S4VvOq+0OUGqTNbUmNQBRrZa2t6DpwbpLPuFm8fndvck1QS3kbpKPdXPiKXG0jrHkbg08+ErorGJxIDsoMS+1yi0KxNx3gUXpjLY5hM8r48leg64Dq1W0nrBYjwlBBkyd5VswD3VyzKcZBUL+TS8wDuWv8XgHi0bCBA1NKuqdm27l44aCOzaKwA5pdtd3ZCIXDBcIn3aHSg4nq5maDd722J9S1C47i+jdLMlUTOo+8Kp7980/eAm/aYr+UscVk8FzgOIvVnz14eGesgYfwpd3oX0PcVU33vmGacdG1ExPDH7Yw4ORhBrY9679M690YlZmn1r3E4WW5/Zu3cQz2NPuVGeakEbiGp+ljnp6IKrnI+LSXbTiOnJfPxvIjUqsh2wIM0e30550dvlLKo1jxvIrqMgZSaMa4i+BrR2KtvQnWw0+JQOSoRYcOZr/b1Zlxe8c2RqyFrR2dj4XKcN+VSYKWG+ygNxjX2ZkpAOI7UOXsJMH5sd4hw3IeVEpjLQYCgMUB0Efnu1la1iE+vChVfp
 luS1jKUM
 +Lje1rai8ZQ+z46ZMfluZ4Lik83o1dRU3aJFqIfNqXslyOv1yeXoenCxRsaJprv/sFL5uOWFmWcmylMMg+gBE7qssLeGR8hz+zLKGduxsfqI2/qkZUZbsockkKdrxrjNQO6yfzxhBKPxWE1WJISQFKK9mozVob1wanNQDCaJFjyKhegJHiXrb0h6Fdg+dEadEptyIfX9tU77+ke+0wPZeilFNV/AQQUKYfOCmEkYW9PLYJMKE436cdQxZ8RI5JoYI7V4frO1qzEwp6RXNpJcB+7dYlPtzaxV7fRP2WwjrECYIUxZhRpUXOPM5n8XbURaavBhYDOtTOO8IWsWlG7Yu2nahLknCjsIoHTp4mwtuNorMZ/R+eeLuhc3UY0JjiJu6NTnf0PLYK8rKj5MmYi6NA5VfMKvnKTXluN5tod8C5Lnro1exxnKoIAN3LKQavrVo4a2tseTn0ksOEJtrcIuKZb6Xj+uIjZ+GIU9EvmfKEWpERRGfW+4Ot01jee5t1xZ0ZyrZag8osjMEKoGn2UjPRJwycR7sCKNyxyUtm2Qt/2nxkd6fuz1tRooGJ2/sVFc7zdoQDMKSLdecSBpCEvoHSSRbtb1LdQmBVbA7rq6KP3IxrgT36wIWd5P5pMua0Vy0ENny+ZOdTAPog7ceIkoUGnYxh1LzxeJvBywaF6IFL31VcjOXDc71NyTWrNpsXJRsOGxi7zU3GlHCxrxm65FTF4Iq+MmkNIjqnU7eaiyZF6cPTBkNGzQpkSyZhKOWNIYBz0SEoswSQINHS/jN3woUzRoz/SJUBzJJdPQfbMFN/ivN9Bc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 11, 2025 at 07:17:01PM +1200, Barry Song wrote:
> Hi All,
>
> I’m aware that Lokesh started a discussion on the concurrency issue
> between usefaultfd_move and memory reclamation [1]. However, my
> concern is different, so I’m starting a separate discussion.
>
> In the process tree, many processes may share anon_vma->root, even if
> they don’t share the anon_vma itself. This causes serious lock contention
> between memory reclamation (which calls folio_referenced and try_to_unmap)
> and other processes calling fork(), exit(), mprotect(), etc.

Well, when you say lock contention, I mean - we need to have a lock that is held
over the entire fork tree, as we are cloning references to them.

This is at the anon_vma level - so the folio might be exclusive, but other
folios there might not be.

Note that I'm working on a radical rework of anon_vma's at the moment (time
is not in my favour given other tasks + review workload, but it _is_
happening).

So I'm interested to gather real world usecase data on how best to
implement things and this is interesting re: that.

My proposed approach would use something like ranged locks. It's a bit
fuzzy right now so definitely interested in putting some meat on that.

>
> On Android, this issue becomes more severe since many processes are
> descendants of zygote.
>
> Memory reclamation path:
>   folio_lock_anon_vma_read
>
> mprotect path:
>   mprotect
>     split_vma
>       anon_vma_clone
>
> fork / copy_process path:
>   copy_process
>     dup_mmap
>       anon_vma_fork
>
> exit path:
>   exit_mmap
>     free_pgtables
>       unlink_anon_vmas
>
> To be honest, memory reclamation—especially folio_referenced()—is a
> problem. It is called very frequently and can block other important
> user threads waiting for the anon_vma root lock, causing UI lag.
>
> I have a rough idea: since the vast majority of anon folios are actually
> exclusive (I observed almost 98% of Android anon folios fall into this
> category), they don’t need to iterate the anon_vma tree. They belong to
> a single process, and even for rmap, it is per-process.
>
> I propose introducing a per-anon_vma lock. For exclusive folios whose
> anon_vma is not shared, we could use this per-anon_vma lock.

I'm not sure how adding _more_ locks is going to reduce contention :) and
the anon_vma's are all linked to their parents etc. etc. so it's simply not
ok to hold one lock and not the others when making changes.

> folio_referenced declares that it will begin reading, and Lokesh’s
> folio_lock may also help maintain folios as exclusive, so I am
> somewhat in favor of his RFC. Any thread writing to such an anon_vma

Will reply on his latest re: Lokesh's approach.

> would take the per-vma write lock, and possibly also the anon_vma
> root write lock. If folio_referenced fails to declare the per-vma lock,
> it can fall back to the global anon_vma->root read mutex, similar to
> mmap_lock.

Again, we actually _need_ to hold a lock over this range. So you can't just
hold the root and a descendent it has to be all.

>
> I haven’t carefully considered this or written any code yet—just a
> very rough idea. Sorry if it comes across as too naive.

It's fine, though I do wish we'd have a _little_ less workload this cycle,
can barely breath at the moment, but that's not your fault ;)

I do wonder whether part of the problem here is keeping anon_vma's
connected to parents whwen they don't need to be.

Right now, even if you entirely CoW everything in a VMA, we are still
attached to parents with all the overhead. That's something I can look at.

But also perhaps worth considering how we approach the whole clone thing.

My (very early) anon_vma rework would do away with anon_vma_chain's
altogether and make forking simpler.

There'd be a per-mm object that connects to others via (probably) interval
tree edges for ranges that are CoW, so splitting for instance would be
easier.

Early days with it though...

>
> [1] https://lore.kernel.org/linux-mm/CA+EESO4Z6wtX7ZMdDHQRe5jAAS_bQ-POq5+4aDx5jh2DvY6UHg@mail.gmail.com/
>
> Thanks
> Barry
>

Cheers, Lorenzo

