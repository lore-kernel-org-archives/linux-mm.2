Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A318ECAC5B9
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 18:23:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E13FD8E0014; Mon, 29 Sep 2025 14:23:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEB9E8E0002; Mon, 29 Sep 2025 14:23:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8C588E0014; Mon, 29 Sep 2025 14:23:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B13538E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 14:23:55 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1AB46B9AD4
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 18:23:55 +0000 (UTC)
X-FDA: 83943111630.16.E0EE769
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf14.hostedemail.com (Postfix) with ESMTP id 948E0100002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 18:23:51 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=K9mGuoUZ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="FnpBWJ/9";
	spf=pass (imf14.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759170231;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ktYIkDp4XgHZv4JoURpzjeieGAUk1zQDSQDpAwxyOaY=;
	b=MemcXdS4D0g7iQL7RQT3MGSegoOJ586+VInqfGkphR077Ff6+WHh3YpAqWRYu4dWe5briD
	LMo1uGWMjvBC6F6ElD/tLV7obtHH406t4oX7m3HgHN+pnkjVccAe/eh4xLdg7m8elAYpDl
	WxHcpMUovUAMeZ3uZtVykFVO9yLls14=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=K9mGuoUZ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="FnpBWJ/9";
	spf=pass (imf14.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1759170231; a=rsa-sha256;
	cv=pass;
	b=swm/YJDx2n7iLKjewk+zUFvewD/dxXFU3ycZfeeI4iom3FTjnQqTY3RUq3geXX0kbbHQhW
	87cRjxwZwpXF2p8Nwa+WZJYIi02egxIvONrj39/1gmquVD/ydakRqs4Va2SsNAzFJJK/IJ
	Lp4MbWs/xaBhdi89W82qKRJWcoOLZj8=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58THsqBF008303;
	Mon, 29 Sep 2025 18:23:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ktYIkDp4XgHZv4JoURpzjeieGAUk1zQDSQDpAwxyOaY=; b=
	K9mGuoUZX55s2MNhafEoEraIiQrkS+5zVrRuunKmnqzQRbbk7EJ3gJj16RWXyYth
	juLvz5lnP63n38Im2Jr+lEQsjO3ao7X+SOCmpBFkdgMK0MsLvGWGIjpF9+oReBjh
	TZ4vksSo9WMzyBEuhyBcSvMvwtfFSXwpcJQ9gnIMwwdaJY66q8xl/l9UuwJsa98c
	Aj/RlLj7EYCz52VKyS2viXxCGiJs9gBw65TztX5IaCo/DTrgwERynKjqANd+Lxca
	oQ0j5S1JpRcGSB70DBmdVdzP1x0xMpIDgxh1aHM+5wbGLfiOthpxKfh2LgolomOM
	Lnsm+5QZdtIxpDzguQz/sg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49fxx001v1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 29 Sep 2025 18:23:41 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58TI02W1000637;
	Mon, 29 Sep 2025 18:23:41 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012036.outbound.protection.outlook.com [40.107.209.36])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49e6c6trbe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 29 Sep 2025 18:23:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NNin5c3/n3t+mHPl0SvQu+5oycziU8GjPcNi8fgZQSSlfAPVwDR8hhUovSSvEt5sZELbmd4KTCEQ4HNYdoFmMbYyvi5ftvnjoppyhL+7bWHC/Hn2ogxP3n1KlGM9sKB57W1wA9t0OaZ5BAZ50lxDeyGHh99w4BeXSIfBPtkj1+YdkdAitozAxdtDCjGtA1u7kHNs8yKacSAWe0zxj2FD+zP1CMnP1zPjmvDoOz3PxqpUovIvUUVjNZsw6/c7nN0lR53pn81Z5H/9cB9CtYWbjC30prz5gntDwfhAknA1UQMhWjfxBzlgIR6Kcvyze11d9E+f9YE2GvAI+rSaz74E3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ktYIkDp4XgHZv4JoURpzjeieGAUk1zQDSQDpAwxyOaY=;
 b=JkiCJYAh7TkTQr6Jldjg6Pc0hCOZWUlMKdiYvn+dgF+C55pTXRo6oE10bg2pkE2LTqSlspADgFx2qyKOZuyUzA/b8jrVNNf63IO3TSFrBj12o1JeStOc8Jdqf7gl9Ec7SaIE2ks+GWuvzzC7Py1u5YQ4ZJRyu0B0694X+bFVn5BZQKW95Qfxu1wkjE0X9stpaJhA1GcsiWb/Cq/jP44qh3VHL9+/HytuZXw6sjFMwqTSu4hLMZPuytmWVLobsHzCxgDcpd46gd8vFqmkRWO9M8t9IY1/ky9zwRRmdzXpb5eQnt+rwctY6vaeTuppYfZRZTOTxwEz2T3I5dD2HsYYYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ktYIkDp4XgHZv4JoURpzjeieGAUk1zQDSQDpAwxyOaY=;
 b=FnpBWJ/9mdgJ4o76Xn/acVZi5xntJY/1Y+uYt2jeYwJVvCxmu9oBf1ITEtXFiYeH82BJDkxwcrV1UD0y+OvVl46oT3UZIN8QUIb4w9y8CFfHBHA5baTffKGofWzWDv9Hwm7NSagRlmGACtXQBLJ12gnZVI0+Xarz2OFzP3LGPDM=
Received: from IA0PR10MB7369.namprd10.prod.outlook.com (2603:10b6:208:40e::14)
 by SA2PR10MB4411.namprd10.prod.outlook.com (2603:10b6:806:116::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.17; Mon, 29 Sep
 2025 18:23:37 +0000
Received: from IA0PR10MB7369.namprd10.prod.outlook.com
 ([fe80::c047:e76c:2405:bac2]) by IA0PR10MB7369.namprd10.prod.outlook.com
 ([fe80::c047:e76c:2405:bac2%4]) with mapi id 15.20.9160.014; Mon, 29 Sep 2025
 18:23:37 +0000
Message-ID: <c61ca94b-5b19-4c69-b2a1-d11a5301c6bb@oracle.com>
Date: Mon, 29 Sep 2025 11:23:34 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [mm?] WARNING in memory_failure
From: jane.chu@oracle.com
To: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>,
        Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>,
        Luis Chamberlain
 <mcgrof@kernel.org>,
        syzbot <syzbot+e6367ea2fdab6ed46056@syzkaller.appspotmail.com>,
        akpm@linux-foundation.org, linmiaohe@huawei.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        nao.horiguchi@gmail.com, syzkaller-bugs@googlegroups.com
References: <68d2c943.a70a0220.1b52b.02b3.GAE@google.com>
 <ce93b55c-75a7-4b4d-a68b-9d80baf1578b@redhat.com>
 <DB0E39CD-36A9-4929-BCC6-33F27E387AEA@nvidia.com>
 <70522abd-c03a-43a9-a882-76f59f33404d@redhat.com>
 <B0781266-D168-4DCB-BFCE-3EA01F43F184@nvidia.com>
 <cad74ef8-3543-4fc5-a175-8fc23a88776a@redhat.com>
 <E82638DD-9E5D-4C69-AA0F-7DDC0E3D109B@nvidia.com>
 <fzfcprayhtwbyuauld5geudyzzrslcb3luaneejq4hyq2aqm3l@iwpn2n33gi3m>
 <80D4F8CE-FCFF-44F9-8846-6098FAC76082@nvidia.com>
 <w2kwxcd6br6h4tdn6xigtuf73qklt6jhxvhtcwp7idugycgxlv@vqjx26vrnwu5>
 <594350a0-f35d-472b-9261-96ce2715d402@oracle.com>
 <7577871f-06be-492d-b6d7-8404d7a045e0@oracle.com>
Content-Language: en-US
In-Reply-To: <7577871f-06be-492d-b6d7-8404d7a045e0@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY3PR10CA0030.namprd10.prod.outlook.com
 (2603:10b6:a03:255::35) To IA0PR10MB7369.namprd10.prod.outlook.com
 (2603:10b6:208:40e::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR10MB7369:EE_|SA2PR10MB4411:EE_
X-MS-Office365-Filtering-Correlation-Id: fbb16e78-5278-4c2c-c595-08ddff854e8e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eHYwalhTYmJ4QjQ5V243ZVpldFlwUTIyMVFJMmtwUk9XS0wwNUhIbnpKaFBl?=
 =?utf-8?B?a1V4U3VIa3V6dmxZTll5VTNseXpsRzl0K2dGZERSeU1LbHEwM0hqeGw3WE9P?=
 =?utf-8?B?OFZKWThYTjdOZkNyaVV5SnFjM3dIdWtHSnZVenJONjJHeVFSY1pKR3gvZExx?=
 =?utf-8?B?WWQxZnZVWnpreSthZ05tRVBjcmVsQmVET1ZoNmZVN01VU1VLc3ZKU3JJNGs5?=
 =?utf-8?B?N2FUck1pNXhZMjVqZ3VRQ2dqMlJrem1hMWpzSXV6M2VjcXppMlFTUnN5TFBI?=
 =?utf-8?B?RWJmWUdBMGJRYzNDbzBpc3haWFpueGNWYWVZYll1Qyt6bStEK0h5c1l6ZWxD?=
 =?utf-8?B?eHd3Qi9ualdyWDFubVZ1cUZ5NjdhcGthYnFIWXNrT001S2NZcER2STNuUWtM?=
 =?utf-8?B?amRsTDlnMi9EKzNvYm5qQ2o3THYvVE80MVhuczN6L0w1d1lveGkreWZOcEVB?=
 =?utf-8?B?U0lJMFVFSXZGdkMzcmozbHNOWkNrVFA4L05vbFVPNVpON21kVnBEcitUNHJ2?=
 =?utf-8?B?MWpMUFRXZG1HSEVrR1RRTU5EZEdEQWtuMkNoZThUS2hFcjFzNVR6SzdUV2dy?=
 =?utf-8?B?dGt1YkFTNndpajJLNDk2SlJHaTdnRW55RGU1OEMxODNJVkNBTjRhc2lTSjdW?=
 =?utf-8?B?dzVQaHNRYlpyNnJGZWFac0orK08xY2paaEtFM2w0YTNFaHE2NmY2c3RobXNh?=
 =?utf-8?B?OU1IdExRSERwUDJFK0ttWHM4UzhRRE92anNMY1FnVWV2cXR5d2RVY2c0NXh2?=
 =?utf-8?B?VFRpOEJZaVdBT0RMZm1QSk1ydWVhZ0NEY1hBTXRrL3F5MWZZU0VSYkZkblVu?=
 =?utf-8?B?dmNlRlZhVjRXS0pMc280THo4bjlSdDNuZ3BrOXRZL0xrUnhJb24xNEFjeVVL?=
 =?utf-8?B?VEQ0b1BpZ05XKzVmRVFNNEhFZk9zanF3b2lud1hNeGI1bEJ3cGVwTHh1TnpR?=
 =?utf-8?B?TFhqUGtUdTNrVDlnNkIwa0xMVnRCL0dzc0tUQWFQV1NIRE54U1FVaVBqUVpB?=
 =?utf-8?B?OVFZL2JndllzYnMxeTUwYUlpQ1pFc3FGSWdFQWx1RnZVMXJZQUFwdm9hQm5N?=
 =?utf-8?B?RHU0Wkx1YWtxUkJrc2RtR09jZlh1ejB4d2FkQmRIZ29EMndmYnBKaWpldjZZ?=
 =?utf-8?B?WjdYUDhFUmhPUVljdFA4Lyt1WWg0Q20wR1QvS3FSZmlSbDZCTkN3bi9YdEJB?=
 =?utf-8?B?d095QVlLYXJBTTVGb3lQVkdkeXFHa3IydTVDRVdMTVNRM3pxL055bENvTWQ4?=
 =?utf-8?B?emNPcXk3YS92YzJmakhteWVEZUhIZ3huZG5TOHgvcnN2T3E2UGkyZHNCS01a?=
 =?utf-8?B?WnF3aS8xRnpMNzJFVVY4NDRUVmQwM3FPSjNYVUZsUURqUVowdVB6Sjh1bnp4?=
 =?utf-8?B?eVJ6cmFjM0lPYkpLdm9ycG9BRE9hSDBOT05seDk5c3ZIL0VpVzBaWURwaGYv?=
 =?utf-8?B?bGZWZ0dkUlZkK0c5WS9SL2oyNUJPTHJaQ2F5YjVUYUltcUtHYmV0Ykk3VUth?=
 =?utf-8?B?eStvRWo5YWVVamNZcCtYcjBlanE3dW5WdzR6dkQrME1pbHo5TFhwUXNEeXVE?=
 =?utf-8?B?Q1YyVzdpYU4wb1YvdWROUDBSRVBHZW1IMXI5Y29zdFgzd3YwNGNMRFBUa29T?=
 =?utf-8?B?M24xWTEwK2d4UEN4ajlYcTZSS1VLZ3c2MTY4N2NMRDdqLzV1QXY3NUFWaHJr?=
 =?utf-8?B?OWlpa0tObTArdXI1NkFVd1B2alk4azIxbk5keW5vZjZmUEZuRjB0RnVGZ1RM?=
 =?utf-8?B?bXBNcnVxZ0k0MzhJZlRwRHo3enN1NGV2QzcxZ2JmWkY4dUVyYk1CZUpObURu?=
 =?utf-8?B?aFFBS0pRM2ZPSUVTejdzbHlFbldhTWhxOW1NdlN1WVdGbnBvM0dqV3Zid0JE?=
 =?utf-8?B?N3U0NHBabkFWdm1hcXg1cE4ycmYyUm9Waitqb2NCYUZYU3FmYmtkdytIZndl?=
 =?utf-8?Q?3hMVzeIpykb+IIgaGkQ5MbA5ogG/UERy?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR10MB7369.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a1M1bW1IUlpmcFp3bExMUG5OSEN1R1JLUHpUSWFNMEFyRW14YWNsR0w5Q3Qz?=
 =?utf-8?B?bmJYM3ZpS0RwTEljQngwWUoydU9PQlFaTk9ESFdoQit2Q3JNdi9RQ3ArQWht?=
 =?utf-8?B?Q0xHR0hCb1ZqUGwyQkduR0RsZFdXMVhmclpZQ21peGdTVDlwNng1b3hYS0p2?=
 =?utf-8?B?SEdUSXFrMm9KeFREWkt6T1JJejE4Y1c4UUNYVlZhdTNJN2pzdDVkV2lyQVBC?=
 =?utf-8?B?Zi9CK3U1NDQ2RkxRKzVPQThnNkhlNkZPQ2VmZXZ4Sk1lZHduc2pDdTJ2K0Nh?=
 =?utf-8?B?N2VOb1YxT2JqV2JqTlA3TUYrd2N2aFpPT1dwQVp3Y09mcGpCOGpaWlNkWFRs?=
 =?utf-8?B?ZkF1TUZNYnQ5Z0gvaVZaaVltN1NPNHJ4VjMzNEpCZElUWHdMR2tsby9pa3p1?=
 =?utf-8?B?YlZsS2loSXMwbWNpczFYd3piMno5V3RaeUROajdTUzgzek1seG9VREtuenoy?=
 =?utf-8?B?R1krSjRsckQ5ZHd3eHpmak4xYjlXM3BEa0laeDhVc09wNVZNODB6VC9jc2tr?=
 =?utf-8?B?RERMS2s4a1BDZEg2eW54RUsyNFpTSjE4UTdkU2pLYTJIR05EblhHZFVVdDlr?=
 =?utf-8?B?b2J6RnlNa1lqQ1A2MC9OMGdjN0VtZFZyaVRnVGk3d1hDa2xONDJscHpaclNo?=
 =?utf-8?B?WE90akQ0eEVKeEc2UHM5cmJoZVR3NkVMZFl3ZEs1TE15WU9pN0RSMzZUKytu?=
 =?utf-8?B?M2t2SFpScnlQa0dyMjNDZzdFZVRSZUh6OWZFbXFaQllvL0ZORHA0Q01DNFVU?=
 =?utf-8?B?OXpYbnBJK3hYa1JzRkpWU3g2MHdlNzVRb1ByM0Vwa3grNlRJbWVVK0hyRnhj?=
 =?utf-8?B?cjhFamk2d3YvL0xZTXVrTEg1VWVMc3pPOUNRSktqNWRNOVQ0a2xBdXE1N3By?=
 =?utf-8?B?SHY1NDdyRHMzeWhHaGQ5SzVOOWtIS0QzOFlrbG1WZkMrb1N5RGc3em1XVUZT?=
 =?utf-8?B?eFAyaE05OFFmaEN1ZDRxeC9uSkF6UlpwaEVnVHNXaHdFWDErTHRaMG44eHFP?=
 =?utf-8?B?R1B0MThzTlQwc3BRdmlhRzhPdU1PWCs0V2hVK1B2V3ZIaDJ0dDl2ekZ4N3BZ?=
 =?utf-8?B?TGZMNGJpYmlBVkV1YkdYUnBxMHM3eEdGVjdoTVpYSVd1ekFrd0RNNFoyVnZ6?=
 =?utf-8?B?TS9NbU43aC9RblFMWkE4a2ZpbGNLNWxmYmZKeHN2enBySFVSQW9sTEgybGJ5?=
 =?utf-8?B?T3FKYjFXcU1jSm9mQmIwdXNiOHJwL1lQL1VKTFFmZk9tWnhUczB0REJDMWti?=
 =?utf-8?B?cU02NEFPMXppK3ZscVpZRzNBU3BTY2EwdjY4VWVFaitqaEcvWS85eSthcjVP?=
 =?utf-8?B?RXZ3Q3RkaERDQVVzWTlOK3hHdVpMYm9jNnd1NEJFNE5CZklhbmRRcWY0eWd5?=
 =?utf-8?B?V1hMUGpmY1piTEs3cVhzR0JIYWxVeUJmR1YzNzNDM1lmeEUvT2Q1UWNKYnZV?=
 =?utf-8?B?R3dSMHdjNFpaenZNZzZiSHpDNjVTZXpjS1IyaXI1Q0p5b1VTbllqRmhqdEw4?=
 =?utf-8?B?ZXFPQjZsRlhBcUFzc3pBbzI2K3o5Vmc0VzNJdGQveGkvWHVvV3c4RmFJOVZI?=
 =?utf-8?B?UjY0a0JoNnNxVkZwbk1wL25nQStaK1pGS3R2RmhGMEliNEdZQWpCTVFLSnpH?=
 =?utf-8?B?TTg5ZnlvbGJ0N3ltRGhhdmlMdVdMSEJuZnJ5THBhRW80UXJMVkVBZVVyQjgr?=
 =?utf-8?B?c210U3pxQzFxNk5hM1hjNC93V1BoWEY2cTRHQnM2enNSRlBMM0UyeXMzZmZJ?=
 =?utf-8?B?ajdIU1VhSHFHbmxtS3pqc2hScktjM1pwNEpkNEw3bjNBdkh4TWpndnFuMUpL?=
 =?utf-8?B?UVlPQUNQMWM3STJocFBScW04bTlVOUFSektmczdDRk5QbGhHQkEzZEREODFH?=
 =?utf-8?B?Sk1qRWNQN2YyOXJyaEx5RE54N0V0bzZqOXRnNmZ1SnR5Y0tKWE1uNGlqeVFE?=
 =?utf-8?B?R3RVQm1iaU5veUZaRDNMaStNZUdlaXc1NU1ER1lxVlBLekhhbVFxb3FCa0pl?=
 =?utf-8?B?VThuUnk0MklQdzR5MG1zM01pM1FxM0xqeGNBaW5reTd2MnFQVVk2aFMyRVNV?=
 =?utf-8?B?NnVpZjRrNlc5UTlmZklieFJwV0g2UGxzT0V1a2NxMTdFSVJ1L2NKV0JmYVRw?=
 =?utf-8?Q?GyZHczOdZOSV3FdHc0R7jNdgq?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	CBTfUUvOB0q/x0013mY+6R2kYBuzMEzTwAlBycyv3CdWjSI6tG1kjOPxI5l2A5aBgKDJ/q55X3+SkpMVazwaCn3P04uIXZEhGtbPtB15k8iB+3HodaVgGEv6wbzA1pmGYTTaFvVrrq3/yamjXL5nn5Zv3qGoTryz+DMsQemM3R0edJVlt0VFg1jLV8LV1whPugj9Cgha1Mr6XH1U745rz3JsnPnq+xzUTw3pUlVZo8ntuiUTjt5jo2vNt1qr0l4z2EVMx7/jC0QuFN6dP9szlIIyJAZrSPJwgCk/DC4JrcO1JgWMszOBihHdFgzWKZgYCb+Qc8lyV3HGPYOzq9VN89ewDpx2KgJEtSzvTdn+YLf0Zn3MYTYp4Lven0ocKmmXgHDJC8vcMu40bpM97grByISWSnCLnh7co5z/ZcFzS4fCNYaSmzJn130WBA/p3wLaqaPFk4MQQel4IXb8NzccV+AonX6jQxjrIrGvik7nGlx8OD0WP9vhDnV6Yn0HDQyGJlOpvorbTuX0PSQLKUj8FOxdkHLdwKEZlGhxVJ+/Qo4dP/hRyWmCutT3Yn8/ZJCBHrEyAq0n3HEM1IY/HVtmJP4qGQcrzb/3K2RUyyw5UGY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbb16e78-5278-4c2c-c595-08ddff854e8e
X-MS-Exchange-CrossTenant-AuthSource: IA0PR10MB7369.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2025 18:23:37.2577
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CBe2InJ4ogBzSCOwk+K5TfzW0X1c9UMw9vVbiq8yLij4nbnsielZxZNkTJbN/CJxbZOHH2hTnl5AFyY8W0WuHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4411
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-29_06,2025-09-29_04,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0
 mlxlogscore=999 malwarescore=0 phishscore=0 bulkscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2509150000 definitions=main-2509290170
X-Proofpoint-GUID: HnPfjsta6xSeoTAp_WwhOwkuD6ajNiNd
X-Authority-Analysis: v=2.4 cv=dJ6rWeZb c=1 sm=1 tr=0 ts=68dacead b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=rA8nFYWZcHOwgwtydb8A:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12090
X-Proofpoint-ORIG-GUID: HnPfjsta6xSeoTAp_WwhOwkuD6ajNiNd
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTI5MDE2NiBTYWx0ZWRfX73AGvN6zvEfy
 QBmb2dXq69OvapjTLyXZ1QZdryztEmOpkrfOVJSozNI0wOTO78/kbRwGzlnsE7zLabZeyd78a6g
 knYbWz4q/G8cPM5UtvWM2QEM8VWw259/1X+0V+2HdvSNRbXYGqpJN5OZy85KxuRYH/i8e3DTvsV
 H+MQczWREIXHO9wB4WpNhmIPNf6q3BzeinwX0vFWzgYaaLWYz9vtjWNKyDbzrylieAHcBolXVkG
 HiWOU4iXaKXnfGQuTVwL0GnhG+zi83nDc8lcGZeHFi+BJ8yrV8qbPCEsy/69v08kQ94I6RUqAFF
 jcRpdBkQ4zKHcCkssj8yDj3Nxy1a5fr5ZFt9vuDTGxSQbxZsbN7dPVTHbE8Uu+pw5yMWYD0c5ms
 bLA7iBaxK6C1URmC6ZmSgGEsM+cKlchZ6/xuKpfi0p632UmhFuM=
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 948E0100002
X-Stat-Signature: ookfj6wk4e4kjwuhmrokaudbkmwgnos3
X-HE-Tag: 1759170231-164358
X-HE-Meta: U2FsdGVkX19dNJLFUX/pIGJjvi4x2F5qN1kmEZJG2Id2hyFmbo6lrFhWul6sWFrBNkclhBihzO34MIm3/xW4uOnaNIFrtMa8NiegqaiX+MnvxJ4/isfqdKaXC9JjTHjOQDe1xoiwuwU+eaFoTy54dej3vbma+tVMstu6lG/HXBfa0tHC95vEVb5VhG7E8CHfii96zUGMSL9fkKLBO9iNzSv5d4OR4syzZTrcC4UNDZWHf4kjFlTIvGo8SasZPnzxhj+Kwc9lxxWbtUxE5djAZDKa+WTUcYNaF1df4YpKbQRAa2KWopGKAqOmrsKF9zgaIrzuIO5BFjSjz8apDjrzOoVzgfMgWVB00tDEpQJifPTdRQzj2zTajg/uf7S/lseKmhvultCowlrqumKvO6jS2yK2WBA9qDboxKCvrn+uTqzwPwz0Y16Uf14QB4rwCAF6E+4Usvz81aR+CfiF/gOzDjwRTJc/1SXI87W56jSitIaXaqCamqnjnHq0vTdLOZq64BCJjiU79BvTj12+cA8hMg8r0/vDn1UfJvCZvGYL9Fxuo5xQDuL6ebat8+zk+KU2P7NsqUt2ZjLklTiL9pPAtYQGDRYjhFIaXx5wEN1ujS1SiVw42aJKktARiKHaPTeCv2uUb7cSZkD5j/tj5SLmds1gDtZ0uBQ0bJI1lyjBcFq8Iy+a6Rp11YK3WhKCOYmACCEIkMEFqKGsVusUvwtRFrDDMZVfXZfpbdNA77w3oiH//xGwMDAC1ig4XCTGnjQc5/Bf7Wn4Llgv69Q0Z+tBcnCdyGgfcovi0TbXrSGi5QbnTZU7ahhpuJlswyw6LeBGKQppw5hK5aR2wffO0xFQHE3AAgV8Ak/TQJY6s/nuCEwFLGmMn1wbzYiqf3zFMLURpipL7NBnzOJI14hzrWu8npygU9m3OHP+xeeulm9Db2X3PdstNMzlkmiWVY7QpIEzWVeVdPHE5TyR7BaLx/q
 xv8d6I38
 O1cdImRBosAtgYHfAgqthHu1cVDvEAHE1nTIg7ZOMFp8hCMGicncCJlDjkldntpi74OKi2HGiTf+9xzTzYHeXuWd4v+UfJbg7I1b9foHucXQC8VWyS56A3bx2POYm01rpzyuwBvT9FxkrpDzywhBHvWmuSME3sIpl17j0R1lv4U9mlCnALqMVwX+q08Q5+O8BZRqHX35hrT+R59wX2kYxPfFooNpIrHMS7KmoSJo8U6l0xH0gr3xDQtJudwiB3wgVvSvNYCQZ+954y39ouE4oKd2D+Mxkvmn1Ksz/hi57/s8/rZoMxh/sBdVN4j8S6Ca0sGSYVTpgrsu3QJpOO4KglR5FJlFhDNPcMbHsF2gjajs2IS6nRgckXpe3QBgy2be/psQULW9RS6b6LXW+UkWRVPQEJXTAonNFmh6kMnmIq9AReLhT+G5COcfzQIEXaecKKEjrZAW7aDy9MqWVQPrwEErNwSy3jQeygy3ElnesBmf1fs100jKTibrcOT56OAMdxEOCJi8xV/fO/xBhxpUZb20B+oh9J3GvAOM4geMcED4c9lHVJogYxIjjG5tGv3WV0h62VZLpz0AZD/1vPwFcsXDNvRlEXBS2r8sPRvO3H0xLgEJtvBYlDlbMOat/FasuPgJXrW2LN4vzwHOHBQiLwqJZxfKNhfpilPbA/gkXLaeEXWqubhqry+3toPwJpUYWK2/1wbU9OsFN43OIiHQuPKcEeoEe7mA7jY4yXOzbofzPxwtqkhpiL/De2ZodFVfLf/KbGnHR5duUzXFebGP1dARiSwRru9ZXS2/de2NIGyf10Uv6HXgQZWNipqCr9LG82CedF0ysGqTcNlCyob2FIgQslA+PRIai3907gXjD2E8FyB7gcR/a/qeof6EVyt4VePk3p8sC68sZ2IuW0OTxBxRHwzGpO34r5UmIcaoT3IzPaj89NDsh24sjMJ62aGzDrWdw6zfAoNF/2ZfVYlyq4Uqm4rkl
 aERTXGjb
 EY13NIfYWGYv2Fw1JSb3IsPjQEgdLi0ELBNugkX91cJjvoINEmnCkg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/29/2025 10:49 AM, jane.chu@oracle.com wrote:
> 
> On 9/29/2025 10:29 AM, jane.chu@oracle.com wrote:
>>
>> On 9/29/2025 4:08 AM, Pankaj Raghav (Samsung) wrote:
>>>>
>>>> I want to change all the split functions in huge_mm.h and provide
>>>> mapping_min_folio_order() to try_folio_split() in 
>>>> truncate_inode_partial_folio().
>>>>
>>>> Something like below:
>>>>
>>>> 1. no split function will change the given order;
>>>> 2. __folio_split() will no longer give VM_WARN_ONCE when provided 
>>>> new_order
>>>> is smaller than mapping_min_folio_order().
>>>>
>>>> In this way, for an LBS folio that cannot be split to order 0, split
>>>> functions will return -EINVAL to tell caller that the folio cannot
>>>> be split. The caller is supposed to handle the split failure.
>>>
>>> IIUC, we will remove warn on once but just return -EINVAL in 
>>> __folio_split()
>>> function if new_order < min_order like this:
>>> ...
>>>         min_order = mapping_min_folio_order(folio->mapping);
>>>         if (new_order < min_order) {
>>> -            VM_WARN_ONCE(1, "Cannot split mapped folio below min- 
>>> order: %u",
>>> -                     min_order);
>>>             ret = -EINVAL;
>>>             goto out;
>>>         }
>>> ...
>>
>> Then the user process will get a SIGBUS indicting the entire huge page 
>> at higher order -
>>                  folio_set_has_hwpoisoned(folio);
>>                  if (try_to_split_thp_page(p, false) < 0) {
>>                          res = -EHWPOISON;
>>                          kill_procs_now(p, pfn, flags, folio);
>>                          put_page(p);
>>                          action_result(pfn, MF_MSG_UNSPLIT_THP, 
>> MF_FAILED);
>>                          goto unlock_mutex;
>>                  }
>>                  VM_BUG_ON_PAGE(!page_count(p), p);
>>                  folio = page_folio(p);
>>
>> the huge page is not usable any way, kind of similar to the hugetlb 
>> page situation: since the page cannot be splitted, the entire page is 
>> marked unusable.
>>
>> How about keep the current huge page split code as is, but change the 
>> M- F code to recognize that in a successful splitting case, the 
>> poisoned page might just be in a lower folio order, and thus, deliver 
>> the SIGBUS ?
>>
>> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
>> index a24806bb8e82..342c81edcdd9 100644
>> --- a/mm/memory-failure.c
>> +++ b/mm/memory-failure.c
>> @@ -2291,7 +2291,9 @@ int memory_failure(unsigned long pfn, int flags)
>>                   * page is a valid handlable page.
>>                   */
>>                  folio_set_has_hwpoisoned(folio);
>> -               if (try_to_split_thp_page(p, false) < 0) {
>> +               ret = try_to_split_thp_page(p, false);
>> +               folio = page_folio(p);
>> +               if (ret < 0 || folio_test_large(folio)) {
>>                          res = -EHWPOISON;
>>                          kill_procs_now(p, pfn, flags, folio);
>>                          put_page(p);
>> @@ -2299,7 +2301,6 @@ int memory_failure(unsigned long pfn, int flags)
>>                          goto unlock_mutex;
>>                  }
>>                  VM_BUG_ON_PAGE(!page_count(p), p);
>> -               folio = page_folio(p);
>>          }
>>
>> thanks,
>> -jane
> 
> Maybe this is better, in case there are other reason for 
> split_huge_page() to return -EINVAL.
> 
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index a24806bb8e82..2bfa05acae65 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -1659,9 +1659,10 @@ static int identify_page_state(unsigned long pfn, 
> struct page *p,
>   static int try_to_split_thp_page(struct page *page, bool release)
>   {
>          int ret;
> +       int new_order = min_order_for_split(page_folio(page));
> 
>          lock_page(page);
> -       ret = split_huge_page(page);
> +       ret = split_huge_page_to_list_to_order(page, NULL, new_order);
>          unlock_page(page);
> 
>          if (ret && release)
> @@ -2277,6 +2278,7 @@ int memory_failure(unsigned long pfn, int flags)
>          folio_unlock(folio);
> 
>          if (folio_test_large(folio)) {
> +               int ret;
>                  /*
>                   * The flag must be set after the refcount is bumped
>                   * otherwise it may race with THP split.
> @@ -2291,7 +2293,9 @@ int memory_failure(unsigned long pfn, int flags)
>                   * page is a valid handlable page.
>                   */
>                  folio_set_has_hwpoisoned(folio);
> -               if (try_to_split_thp_page(p, false) < 0) {
> +               ret = try_to_split_thp_page(p, false);
> +               folio = page_folio(p);
> +               if (ret < 0 || folio_test_large(folio)) {
>                          res = -EHWPOISON;
>                          kill_procs_now(p, pfn, flags, folio);
>                          put_page(p);
> @@ -2299,7 +2303,6 @@ int memory_failure(unsigned long pfn, int flags)
>                          goto unlock_mutex;
>                  }
>                  VM_BUG_ON_PAGE(!page_count(p), p);
> -               folio = page_folio(p);
>          }
> 
>          /*
> @@ -2618,7 +2621,8 @@ static int soft_offline_in_use_page(struct page 
> *page)
>          };
> 
>          if (!huge && folio_test_large(folio)) {
> -               if (try_to_split_thp_page(page, true)) {
> +               if ((try_to_split_thp_page(page, true)) ||
> +                       folio_test_large(page_folio(page))) {
>                          pr_info("%#lx: thp split failed\n", pfn);
>                          return -EBUSY;
>                  }

In soft offline, better to check if (min_order_for_split > 0), no need 
to split, just return for now ...

thanks,
-jane

> 
> 
> thanks,
> -jane
> 
> 


