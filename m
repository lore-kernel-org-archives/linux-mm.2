Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A462CCA470
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 18:16:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 815FF8E0007; Wed,  1 Oct 2025 14:16:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C5BF8E0002; Wed,  1 Oct 2025 14:16:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68DE58E0007; Wed,  1 Oct 2025 14:16:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 557128E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 14:16:22 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 04EC28567D
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 18:16:21 +0000 (UTC)
X-FDA: 83950350204.26.9FF718D
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf29.hostedemail.com (Postfix) with ESMTP id 9580212000B
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 18:16:18 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="JVmIXne/";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=NojV0psK;
	spf=pass (imf29.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759342578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CpDTLMb5I4KFJQBVkbo8vvxo/VctarHJRtQ4MEpZd2k=;
	b=xtW309FrbCfFpvrkyz8rXlorTBFAHZ8CkFnIIcM9f4xolrNvB8ahTXbzZHy7q2EtaM2kHN
	EIVg2+r7m+GQRI1xCOet/XJ/XsWIcGojArPBiriOPDTkNA7IIJ7lpHlp6MoVi3Koq6t2X5
	q6xVZs14g06BzG+ZO321zY0tJDH7KaY=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="JVmIXne/";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=NojV0psK;
	spf=pass (imf29.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1759342578; a=rsa-sha256;
	cv=pass;
	b=G/EW5ZF+Cw+c/R/LuKhRAA+z0VlfKa7AZqaUJmdXEsnInqzDwyqVpyrtWMWjGNUeCTxgYK
	x2Gyzn/o6CHInNitctQx099N92k9+mGPgAhYwbLvdCD//JBKU8njU8D2T1xR4HiT4MlKPY
	IHBBhKJ7hsfO4/PJbgTMUD5bA7cj+vc=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 591I0nGX000507;
	Wed, 1 Oct 2025 18:16:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=CpDTLMb5I4KFJQBVkbo8vvxo/VctarHJRtQ4MEpZd2k=; b=
	JVmIXne/vPR2aNrpxYLZ7kWa5ayBOOSBTSKyjhB816TV1OLiBYJ+ZZQLBWLlYE1Y
	P/+bu+Ju4g2yZA1MRsiM0tcXbrYJxIQIl19hoYISs7hD3BDpIaybBajtoyc9g6JO
	6FMTl5AA+2TOl8k6kseu4xtsItuz64IUDvk+eSTkt7mSo9dRdmjFORTpuFFLYQo5
	YaDnniL9oOQ20/ttcDM3md9+Ui1AvvlIlinH1G+r3d/QIyl0Kv6MoEnFyQCLRuuP
	BFVQwzBNCw5yeoMtjQDmZxBXHjKLNgpliB7V30P6nMFMvpeEBZGWKOStT27odW1r
	e5nhiOPqoUtEoc3/lKOBZg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49gksxa31x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 01 Oct 2025 18:16:08 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 591Ge4aJ023181;
	Wed, 1 Oct 2025 18:16:08 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012036.outbound.protection.outlook.com [40.107.200.36])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49e6cagh8s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 01 Oct 2025 18:16:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zQewBKribscjLXmXcVbAdY0y1lF7hGJTaXur3pZFiaeEt1OAUYJCu4bgzq5iA2juTMvcaELu4SbWeRWxIXI9u7PxjKB9rPdlM4M/bClqV+Y3Z+4z3XJplmTLyCYCJJ353A+UwEInfGGJoQnLqU1wh+H0jc4ZtOzUXunTMaJto62yLtH8UMceyPMXBbXDIPulKVqCzGVNjuPVeY0WvnmHqaeZXfxWj+4/ppbzfVVG2wL9MnIY6U5WqlncD1jVHFzDoUxHF9dOkU/9QaD3DI0u+lUuziCdX6FAHVduCFD4pSTibmg3H4jeh1wggAd/aZeMyZ9356VR+buh6ygQnublLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CpDTLMb5I4KFJQBVkbo8vvxo/VctarHJRtQ4MEpZd2k=;
 b=lasSuKGJbKqSnU0V+DVKbzK2XARfOm4DEOZsJU5hs2zu9cvz+hRaYxTGXrhlwHw0ItgQLuKQPB/6XY/383fP81Ox+RFWyKBetxa1uDhppc1/59hajuVDPKyfO8Lpa5lfu6bhN+ImdklrFjLNUuznO+lG2ubNPOLMHrNIqUlgZfDcNUamJ1vbBVLeHcKWTTXmJidC9PWVMBUaq2GCx5y2/yxeu87Egs24l6WA2Dy8KMpo83/2ndfME8O/yZkIdSipAwaei00K0GBVSSFrN2ia9FugZ9TdZJlEaHYlJqKt5qQU3bWdT6YQHpTdRhNRTmJtwJkhCCpuMFnXHouc9fkqsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CpDTLMb5I4KFJQBVkbo8vvxo/VctarHJRtQ4MEpZd2k=;
 b=NojV0psK6FjNYMa0R9hY7fJ6wSyJHNqhG92O140HchN2a5N3IHFCa483KkMK4PtFE5IdyYzPy6MiPbws3GoXtVCmIMtBDiAHL7uhc/tWW8YRclDrUnf+KHu3jGJuhpP+RDdnbd08JpjIC7THco0kEBZjsVlhwyNa8RT1fZq/2tY=
Received: from DS0PR10MB7364.namprd10.prod.outlook.com (2603:10b6:8:fe::6) by
 CH3PR10MB7833.namprd10.prod.outlook.com (2603:10b6:610:1ad::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9160.18; Wed, 1 Oct 2025 18:15:58 +0000
Received: from DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::b7d7:9d3f:5bcb:1358]) by DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::b7d7:9d3f:5bcb:1358%6]) with mapi id 15.20.9160.017; Wed, 1 Oct 2025
 18:15:57 +0000
Message-ID: <b451c3b8-98d8-4df7-b076-cf9e6ed7a087@oracle.com>
Date: Wed, 1 Oct 2025 11:15:52 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [mm?] WARNING in memory_failure
To: Miaohe Lin <linmiaohe@huawei.com>
Cc: David Hildenbrand <david@redhat.com>,
        Luis Chamberlain
 <mcgrof@kernel.org>,
        syzbot <syzbot+e6367ea2fdab6ed46056@syzkaller.appspotmail.com>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, nao.horiguchi@gmail.com,
        syzkaller-bugs@googlegroups.com,
        "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>,
        Zi Yan <ziy@nvidia.com>
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
 <c61ca94b-5b19-4c69-b2a1-d11a5301c6bb@oracle.com>
 <d15fec58-58ad-fd20-7130-9c480df43d15@huawei.com>
 <8d39b975-b85f-42f2-8be4-0b7adee09dd6@oracle.com>
 <c97dedf5-0f45-5082-64b6-ef0772dc33a3@huawei.com>
Content-Language: en-US
From: jane.chu@oracle.com
In-Reply-To: <c97dedf5-0f45-5082-64b6-ef0772dc33a3@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BN9PR03CA0702.namprd03.prod.outlook.com
 (2603:10b6:408:ef::17) To DS0PR10MB7364.namprd10.prod.outlook.com
 (2603:10b6:8:fe::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7364:EE_|CH3PR10MB7833:EE_
X-MS-Office365-Filtering-Correlation-Id: 6cebb92e-6d4e-4fce-ec2f-08de01169102
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?d1VmSU9pTHQza0Q5alNFbVVTUk80MXMxYTNoWkVKNUhiMTRjMzNYZmhuWGJK?=
 =?utf-8?B?dHUyUjhTN1R1QjdXVjNKeHVXdis0WnQxNDlwRndQNDY2bjlSSmV2M0pTSzJm?=
 =?utf-8?B?a3kyVXo0Q3l6ZGpBUVc5a1pxeXZZNVFyMld2WjZ1K0N4VEFhK0JoUERTWjlX?=
 =?utf-8?B?bGpHdk9DOTRaMDJaQjN6T0drOTZaSzRDaDF6eW5kU3A0WWVZU25pajBGUVpt?=
 =?utf-8?B?ZUZBK2JRM25PTHVHN2pYM0RnRitWN1orRTZrZWJMdnh2ZklveHBiKzArcFN4?=
 =?utf-8?B?T05jSTRnVVI0Zyt0bHVpY0c5aFdTZk9YbmRaME9nRGh1YVdpOXYxb3o1VjNv?=
 =?utf-8?B?dlkxNGF1VVI0SE5RUnRYbWJReGNiZVl2UG03VENobmY2dzFtOEd3NlVsWHRZ?=
 =?utf-8?B?UFNLUFJMNmxkUHFMTFhpQ2twRWh4QzF5UmxTZFNsK2htSm51Y0cvVC8wdUNw?=
 =?utf-8?B?dHhCczRxZnZQVUpjbXduRTVubmJQb3VwajIwYkZ0NzlFeUN1R2VPREUxbjA4?=
 =?utf-8?B?eHRIdzJDWTZYL2EvTm1kZTBGNVd6SitZS0xzWnhEWUZwOGxOaWYyMVF5SlhM?=
 =?utf-8?B?QU9URDlPcGdsbjM0dGhCL3EwYzFPVFNOemR2eWR1Z2dDc3VESkpCdi9RMmZM?=
 =?utf-8?B?UjhNK1Vub1NvMlhrbWtleUZEa3c3SmlQUno0RmppY3k2RlErbCswdXdXMVdu?=
 =?utf-8?B?VkpsZlVoYXUwN3U2K2ZoQVF2Nm1sZ3J6dXJBa2poK254QmZ1UFdZZDkrYmps?=
 =?utf-8?B?d3VDM0xNYTFwN3ZCVkd6aEgxRjM4ZmUzenZOSHhudzQ3czY5b251dk1vdm8z?=
 =?utf-8?B?ZlNYU3JaTkxuVkVlUGdUdnM4ZGV5OHp6RVJTanNWSHJ4R0p5RGpFNi9yRVpp?=
 =?utf-8?B?WGYxTzExRU9HYmVnK3BWWXN3T0Q2UGtwVkliWmxiTlpwNUVOcEJFTHZlK3NJ?=
 =?utf-8?B?MDNCZzYwUm11aHk4YkZGZWN0b3lBaVBhNW1IQ1NEZHVjZVYyMk1GVHF0NGVy?=
 =?utf-8?B?QndaVmNKWENIWE9YcnhXWUtOcEJuVXpwc254VDk1Lzk5eU0vK09URVdNcE5Z?=
 =?utf-8?B?dzE2MHpZaGZvY0FBWFJQbnp4anZlVmFRVDUxT0lhMG9KazJJVG1nYkRTYkxT?=
 =?utf-8?B?T0g2RGJMTm1JdnBsZVhRbEF4R2w2MVpVa3BJQ3ExaHYveFdERHZKbXB1Njdm?=
 =?utf-8?B?ZnUyZDdDZGVWcTNmeG1zZE4zektXWWJpaU44UlVjUU1Fdkx0TURScU5zSTNG?=
 =?utf-8?B?N1RUSkl1RlJxK0ZUdUhCQUtNNjh0cmJ6bTdkaVpBenMyTmFBTnFiTnErT2I2?=
 =?utf-8?B?MkdxaDdyY1d2NXE1S3Z6dnlacmJsbi9BSDlUSGZ3WnJvd1k2dXVXSDIzaWJo?=
 =?utf-8?B?cnFoZVRjSkZWLzFMOTg2TmxhTTAwTjB0aXd4T2Jyd1U0bXJWMWhBLzRsVHR1?=
 =?utf-8?B?eHVZUzg2ckJCUy80Y2ZHWFlyQUROWlp0QXJ6ME93cGczRHVVankvY2JiMEdR?=
 =?utf-8?B?YklvY0h6ZWF1UmJyVzZwV1ZyRU9mVjM5WHN4SlNHcmRPVDZpMDlueGhXYkx5?=
 =?utf-8?B?TGNhclBwUzAwRjFKUTVmdTVya0FtWklZYWhvbUtFVUhzM3htNWpicUNaV1p2?=
 =?utf-8?B?aG80RXNLckp2a1dZcXlOb1gzRmlQM3Y4RUplT1pBR2QyUlROcUp2VkVWUmtp?=
 =?utf-8?B?KzRIMUpIbTNBRVh3ak42TXB1UDBWUUVmTEFGMW41dWRESkUyQnpkNFZGOFRE?=
 =?utf-8?B?Z016cm0xcjRSbENla3IySEVpQXlNZjJ4ODYzQmRrREM5QW1KTlR3THpiWURi?=
 =?utf-8?B?Z1lTazdzQ084a0dJSUl4bkdUdElJRlV1THZRVlhDb1ArdC93ZVliWlBUeUVt?=
 =?utf-8?B?eFRJMmdvN0pqenZuNy9rY1FySnVQUmxVT1hzeGNvbUVZN0EyNlJqSXY1dmRp?=
 =?utf-8?Q?KQoaOriUiUbYx5fc3h8ZTdGI7IWsc58J?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7364.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NFBKaHU1Zk5RRmlZNGZiQVNFWURRbHB6enR3VHRrUmNXVmJGMmxVOWRHQlBG?=
 =?utf-8?B?U1Bqdnlkc0ttQXRPQXE0NzVPMmhpVWN1c25PZGF1RFZUeXQxcHZNNWUvc29a?=
 =?utf-8?B?cStRWmtlYU5xVGhQVGNZUTEyUDkwaUJCang5MmR5SHB0WkJHc3ROSWI3L0Fs?=
 =?utf-8?B?YnRkRlV3aHJlVkpTVjVaU1BFQzhteWFLNEptLzlVbmlNTkdCdjVyNFVGL1Rq?=
 =?utf-8?B?QUpHZ0pjcHhzZ1J5UUNwL25VQXJSSUFOSWdhMm1xa3dLWVh4VzVvOTBaTlBI?=
 =?utf-8?B?TFA2MmRHa0dWVlZYQlpZekZBWXBjRW5UUUxMcjg1QUFSbE5CRzNmNGFtMjhv?=
 =?utf-8?B?TlJ1YUphYlRWY3l2aXR3eGdCUHNydTZRRmFycXdWb0V1MU45SVFoN0F6NDVN?=
 =?utf-8?B?UGJhR3h4Y1E2Q25yanJNb09zbUNJZ1hYbHBJK3VpKzlIay80aXZnMVFHN3Za?=
 =?utf-8?B?SnBOeWo5NFkzR1BZSHdmLzhMM1U1MnYydkh1SUFiNE9IWGtoOXFYSGVOY3N6?=
 =?utf-8?B?MUNaM0xMb2pBMXYya3RlM28wenN0c3lYVFB5UlJISDlKQ01ISVZqeXVSZ0ha?=
 =?utf-8?B?UDRoMW5jcWRyYytEand0WDVaMGRJUnRZeG9LK1BZbGhyTHkyMkxyTlhXMldz?=
 =?utf-8?B?WEM2dXFyTGhMSUF4ZjhSeUo1V3Z5Ly9HenVvRDdIZXlPdkVnZE1zdjRSTDhB?=
 =?utf-8?B?Q1dVSzZZU29WQWFVSHozaTlIaGFjbG9zK3NGNlcvdjA5U3VlU2p5UTFpUjRE?=
 =?utf-8?B?Q0hrclhHQ2FuL3FCV0ZiQzVDS0xmN2xpVlFqSlJndjBCdmg2REhXOGtpT1Z4?=
 =?utf-8?B?MkNzOVQvVzl6aHdDSTVGMTNyanhOOFJ1eWJjTk91TGR3cVhPTTVsSE1mcFVZ?=
 =?utf-8?B?eTFIZ2tPQVdxc0hMeEhsZ0dzaG5rQUxhNGFLM0l6OUlDU1NSOWRhUkp6bU0x?=
 =?utf-8?B?UXFSVHR2VEI0a0ttRG9RdUV4S3Z4U1RBcG1TRmUrUlNQQVh1QzhLRUo1OWlH?=
 =?utf-8?B?WGkyNTg2LzhlaGo0SWp4MmdIR0ltZXNxKzB5amc1a2NTSHF5QW5LeFpkTWNh?=
 =?utf-8?B?enBXa1JYek9GS1Q3QkJZOGVGajg4SURRN255Q2E1N3RpTHc4NVlTaVNhNi9S?=
 =?utf-8?B?SnhiWVBUczltaEZxNzR4L3E0a3pnY1hscmdqSEVtV1ZZakpQVWg3MGlxRjNq?=
 =?utf-8?B?Q1RhRXZVanBtbFpLUFd1SmVVWFJ4VGdJUVA0NWx0RG05NXc1MWhYTkZKVk9i?=
 =?utf-8?B?NlF4V3VISUM0ZE5Nd05CRzRLNDB4bUF6c0xGaDQ5c1ZXcG91ckN4RHNCVW8x?=
 =?utf-8?B?QmpXamJLUzVCQ0gya1o2NkUvWEhtMm1lWkVnU2pkK0NmOVRVcWROc3NpYWxj?=
 =?utf-8?B?cnFwbVpRQU9PblkwTGlUYTkrekRrZTg4a2NNVjJCMmRQRmgyYjRoYTdzUWdj?=
 =?utf-8?B?ckFsci8zdHNYV3ZsY1RwT2tRci9jR0hmOHNUTjdzRmZGSXJWemtGZUc2VytN?=
 =?utf-8?B?MmJQTE8vYXAwT0p3MlZ4d3pQS0llREhzZG56MVVOR0hoMzVHQ1RUUTVZVnE2?=
 =?utf-8?B?YWJoNmJJWS9WdytwRk1OSHhkeUJTL3Z2TlZTSVZoU05GTEFZdGgwSlJzNkJp?=
 =?utf-8?B?UERjeUZZMkRzdWZSa0dORTFKeVlibEh6U2g5ZldQTGdCN0xSdTBWeldGRVE1?=
 =?utf-8?B?ZGY5V0tQRTBPM3daRTZ6cDBKemZnQlplb3M4ZG5PbVQrOGpER0d6MnJkWk8r?=
 =?utf-8?B?WmlUOFZnRjlVc1hnZGc3VHBVU0pKaFR2NU41SDd3T2lObjE5UHJ2RHVSYS9T?=
 =?utf-8?B?cXRldmdsNWwyUXk1REMwektnWVZQZGZoUWEyRHI4SVZpekltNjljeHB5bE5I?=
 =?utf-8?B?UitIMFBleGVqQTFad1IxSUFZdDBMVTB2ZlJJL04xRFNnZzRyRzBIdEM3QzNK?=
 =?utf-8?B?dWFvT09URUJUZ09yWkt3TXQ4WnE0SHE1UnJDOXo3Mk1oWWh2clpNbU5HTWNy?=
 =?utf-8?B?NGZPNk53Qk1LaHNxZUV2ZDlpcitiQzF1M0dvSlovQURqQmUxaFlaRko3Q0Nh?=
 =?utf-8?B?UmE2RlRodEIyZWxOcmdkNjcrQWh2ZmZUdkU1SWxQZkM0cFN6d3VoWEZhdktZ?=
 =?utf-8?Q?wsyqa2QSu2TYSmK8HoNGPeVW2?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	lgzNCj90o6TtEmvreumxTtRf/l+oAnKP1qNZlV27PR7Ha6Qa1H5ZMM8wUOhODKXHLnitIesPNOStNKW6yFj43qv003MQx5DZfY84Zin86w6T2vxsuxQpMG0Sy4yEavJ9Xog8Q1ccgYk47591ipl8oGEeQejikBfPtEcyMT+SszDkTZDsQ/vVIQ3yWd4QennNaqxDoge+EQnoP/+dfVFOsdXIgDUm34IcXKnPZWdvplhpU5PHX3oiqI02B0Our7JCiOZ3Lyk3sEJQ0DgtLux+ROUpScfknzly1sx9sFlQqQiOE9hgo5sU1Ao/tcLi2WRlukQz5Tm7njxG2kCoOOuH7Duxep3W+ImeJCLgCVP6HPhy0tHWCzTIePQf/bMHl6Dzs8+beZFOp/a7C/pa5iu9k8YttZlIfF3nsKdjli3Dozp26MHvAqmiWVFbHqdvBr75Hp7/jkQCWvzMVB/+GQwOUJasfpvs2baaaVoAg3opxyqoJMjIVVLgB35KqlMDXeRT4A2mIxEkYAWJmbAVIgr4ptvcy6m0opwp3DdypNNrYp2PIRbcByb2Eh3ATFVSqUinUIz3FoJiWHEgz9CgCK6P5hIlEJaizDUmW5UJhN0+WAQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cebb92e-6d4e-4fce-ec2f-08de01169102
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB7364.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2025 18:15:57.1245
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q7lzNd1+W3J9cJgVxzbj1ErPheRsre7zv4+ZBDRx+leTTqwm+dggBV3T1wAjnNhCbGyXM+kv/bd+yKtbN5u1xw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7833
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-01_05,2025-09-29_04,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 bulkscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2509150000 definitions=main-2510010159
X-Proofpoint-GUID: 42Vc66DFCaWnKTHk-RC_8aQc03-PkzvP
X-Authority-Analysis: v=2.4 cv=N4Ik1m9B c=1 sm=1 tr=0 ts=68dd6fe9 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=vm3rMv-giqQMgpSKNcsA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: 42Vc66DFCaWnKTHk-RC_8aQc03-PkzvP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTMwMDE2MCBTYWx0ZWRfXw2xDUWNfJHLS
 +6Xisx9tMAPAi491r+ENE1VrdZDndn4BuJK4Npu+V6PopazfRupIhY+jSkGEzjxBrk+wfL1KXEP
 3q/cSTOms6tWlhnoYwS7m7JErcgDc0kVMdbBQ8jPRSYYaw/7f25VmFVON+pSegkdHoK/3rCe6SF
 uA5RJ64LV5o90jh5Jq+VmREDFJpCeOLF+uARrFWBAa9iUgx2oJ1u7ANq0DsAVkZwJ1hcvmQY2A5
 MAG40+ZHvQSXiDi3uTbNwF1aUNrYn+F+kyH0if3uJ618RMEABDl27ZOBwuTCqjgGGaH7SdxxNwy
 2Z/zakKl4lAMVU6dMtFxrm0xM3VHIekEc4pfnSJPuF38k1iEvfCIatCIEzEoQTCezRBtOM/nO4s
 Azv5vD+ppknxdHe//rimVygTZUHJMA==
X-Rspamd-Queue-Id: 9580212000B
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: jmehyzyzpr3myb1mc1t36duph6hhgcin
X-HE-Tag: 1759342578-301323
X-HE-Meta: U2FsdGVkX1+Y7GZ9bEYYDOS0XYgeTI1/FKeNHe0cqBFdn1/Bd9mdoZZ51xB1tkRvBUe3oMLLHqQr34wk2MDFFaWPqS5TDy/NH9M3kJF2oWdE4FLa9AlyIbDU60QE9P+h+MpbVw1pYX6IRKxSpo+ONGMmPGntkRrW7PQpAlwI3OIj6IiPWLQ++MA+QAURlVoBNxcjZA5FPTFQon+VtDYoCji8PyDUXBGJ69eV8T6VUk0d2fAcdPuKAxUTUvAYcw3gWqBzJZSEOE5bfhq1WPFWUAnLj5qguIaMe/UPq0g6MbbSwmMvaTq7UIlTdGozz1X59LDyVXiGwmQUEHBy/Xx9jbs8Kq3v/HHqX9fLc1mQmmLsD66uWxCwoHt55PIWy5EcnDud86cRjTMzAiiN8Hbgn6g6s3qfGSOO8RgPparRVqDlvhtHIAuiY0KK6d7nLPb0Bf8pLBofnE/vmMdREPqP09fzocxLy2WVlE6Uro+qSmLlExES5c/iwRpD/lDDPcBSKNVkhC6HP0dLlaXHIhuuW2wt/89dl9AP0n0C4gnp7tFKIFM/vFDZ8Im+62A1tFd/kYP4JZogdBq5IvXnfQXG8m36j9EbzwRjtEUPcv7py4L3hyW0nRH7g85Ctv+InIyOe4mNqoOcg2a5QueeVEsnbJy18Ukz6tJB4A8tPMY9hzqyPbtHEJftzNzmt0pxHtg0YAHE9LY+BDjg5HD2W9MazZ94zLB4j7oOz88swdFsnbcsmtDGw0R6pMQFAAPK5Khu9XMsdN1bLW0cy/WdHV9m9lplvWEFuJE0HrRWx9mpy00pw06DZnYT2wEQSfrwW9vmH5Xz2Yux5RSs8XQ1jFFUSmCyxvqxe7V7Y5YThW0DCcrIif+ZKUAEL0yflsEcVFmUvnGEXGMGDGnV3n78uyD5O7IUd/tw+2yCNTagjZkZS5KbSTMdAWSCnW2MJNpaiyt+PRATna9d596+KFQjqUG
 pi3rxjak
 Ed6f1gyUklxPogTSM5al9dyd2q31HxCUgwXZQiBZSgfKWNMe+Q3iqc9dn8C/CCMwSZFgXC6rMBQjeOAQAoV1alnK0YICNc0GYaYppuwXdQIUjj7I9HwOyF8arAA3rQqPIMjK/gkRgSWxtF8nxXhpV/wSePfttntiShReEfk9odwlj9MSDUPJObE/UeTU2Fkq0vM20fLjMuQmhb+G4s6yY3J23NesZMcniyt43Fn63/mmM1vM11HwjuKytWe1txsR69o0oR4yuIbKlbwrSgi+/gGQyK6K8Rkkmiyy4p1bmAe6u70Qbuj+gyRXIWFg3hWxiX/W/QffjBdhtUHnhonpkGfmG9N8OMR4kRByqTguzS+utYoqMNJ0aYdvwzQF52/9jlxpFPof4oHuIXMqp88cOR42l+dQhpYHeCrnJE9jcM2eAX9k/SULyPcgaq6XXmXVEqyJSOcmmRgWkoJyWfD/QPc7l52gV3G0kyGiLYArVl+Ds9wApR4FX2cVLJAv6iq7hEAFuM7+jr1S3NIAunPlGUGiEfBgkQDz90r48Iu5Wy0/x3BQ94XZ9NnAWFiRNN2RM4ZAoC18yk7tZw7WvJGBQwhOhoVQirrTAsk3oL1U1zP0p9UrFdaQfK4lzPF3aiGfl5NXcaOl5UR6LSosgXCWQ8nUWh5YONeNRQ38ORpG+FsCPiJWvrv4sbILG4yJ1S+K2wtg+lFnZ8ZITMd22oFr3WMFyANjnPfhfAPjJJvK1QUGLRb5wcVmQC081nq+wOGRcxw8HO0LZ3tqpLULJs1h9KsdcBs6nl1KH3yZlX7K0xUnT8sF6UuNO5PmR83cW4am7D2DAYaJHh+vegK4P9LqAyF0reemUZvRtYLjQmY3Q1sOXysCmVTSwfhK14/J4NGtE+1LJSk17LfQs7ku8c1ds7BaaWHyXtFrCT6y4mAQP7YfBSSjloBnRhKQlHA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 9/29/2025 11:31 PM, Miaohe Lin wrote:
> On 2025/9/30 12:35, jane.chu@oracle.com wrote:
>>
>>
>> On 9/29/2025 7:51 PM, Miaohe Lin wrote:
>>> On 2025/9/30 2:23, jane.chu@oracle.com wrote:
>>>>
>>>>
>>>> On 9/29/2025 10:49 AM, jane.chu@oracle.com wrote:
>>>>>
>>>>> On 9/29/2025 10:29 AM, jane.chu@oracle.com wrote:
>>>>>>
>>>>>> On 9/29/2025 4:08 AM, Pankaj Raghav (Samsung) wrote:
>>>>>>>>
>>>>>>>> I want to change all the split functions in huge_mm.h and provide
>>>>>>>> mapping_min_folio_order() to try_folio_split() in truncate_inode_partial_folio().
>>>>>>>>
>>>>>>>> Something like below:
>>>>>>>>
>>>>>>>> 1. no split function will change the given order;
>>>>>>>> 2. __folio_split() will no longer give VM_WARN_ONCE when provided new_order
>>>>>>>> is smaller than mapping_min_folio_order().
>>>>>>>>
>>>>>>>> In this way, for an LBS folio that cannot be split to order 0, split
>>>>>>>> functions will return -EINVAL to tell caller that the folio cannot
>>>>>>>> be split. The caller is supposed to handle the split failure.
>>>>>>>
>>>>>>> IIUC, we will remove warn on once but just return -EINVAL in __folio_split()
>>>>>>> function if new_order < min_order like this:
>>>>>>> ...
>>>>>>>           min_order = mapping_min_folio_order(folio->mapping);
>>>>>>>           if (new_order < min_order) {
>>>>>>> -            VM_WARN_ONCE(1, "Cannot split mapped folio below min- order: %u",
>>>>>>> -                     min_order);
>>>>>>>               ret = -EINVAL;
>>>>>>>               goto out;
>>>>>>>           }
>>>>>>> ...
>>>>>>
>>>>>> Then the user process will get a SIGBUS indicting the entire huge page at higher order -
>>>>>>                    folio_set_has_hwpoisoned(folio);
>>>>>>                    if (try_to_split_thp_page(p, false) < 0) {
>>>>>>                            res = -EHWPOISON;
>>>>>>                            kill_procs_now(p, pfn, flags, folio);
>>>>>>                            put_page(p);
>>>>>>                            action_result(pfn, MF_MSG_UNSPLIT_THP, MF_FAILED);
>>>>>>                            goto unlock_mutex;
>>>>>>                    }
>>>>>>                    VM_BUG_ON_PAGE(!page_count(p), p);
>>>>>>                    folio = page_folio(p);
>>>>>>
>>>>>> the huge page is not usable any way, kind of similar to the hugetlb page situation: since the page cannot be splitted, the entire page is marked unusable.
>>>>>>
>>>>>> How about keep the current huge page split code as is, but change the M- F code to recognize that in a successful splitting case, the poisoned page might just be in a lower folio order, and thus, deliver the SIGBUS ?
>>>>>>
>>>>>> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
>>>>>> index a24806bb8e82..342c81edcdd9 100644
>>>>>> --- a/mm/memory-failure.c
>>>>>> +++ b/mm/memory-failure.c
>>>>>> @@ -2291,7 +2291,9 @@ int memory_failure(unsigned long pfn, int flags)
>>>>>>                     * page is a valid handlable page.
>>>>>>                     */
>>>>>>                    folio_set_has_hwpoisoned(folio);
>>>>>> -               if (try_to_split_thp_page(p, false) < 0) {
>>>>>> +               ret = try_to_split_thp_page(p, false);
>>>>>> +               folio = page_folio(p);
>>>>>> +               if (ret < 0 || folio_test_large(folio)) {
>>>>>>                            res = -EHWPOISON;
>>>>>>                            kill_procs_now(p, pfn, flags, folio);
>>>>>>                            put_page(p);
>>>>>> @@ -2299,7 +2301,6 @@ int memory_failure(unsigned long pfn, int flags)
>>>>>>                            goto unlock_mutex;
>>>>>>                    }
>>>>>>                    VM_BUG_ON_PAGE(!page_count(p), p);
>>>>>> -               folio = page_folio(p);
>>>>>>            }
>>>>>>
>>>>>> thanks,
>>>>>> -jane
>>>>>
>>>>> Maybe this is better, in case there are other reason for split_huge_page() to return -EINVAL.
>>>>>
>>>>> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
>>>>> index a24806bb8e82..2bfa05acae65 100644
>>>>> --- a/mm/memory-failure.c
>>>>> +++ b/mm/memory-failure.c
>>>>> @@ -1659,9 +1659,10 @@ static int identify_page_state(unsigned long pfn, struct page *p,
>>>>>     static int try_to_split_thp_page(struct page *page, bool release)
>>>>>     {
>>>>>            int ret;
>>>>> +       int new_order = min_order_for_split(page_folio(page));
>>>>>
>>>>>            lock_page(page);
>>>>> -       ret = split_huge_page(page);
>>>>> +       ret = split_huge_page_to_list_to_order(page, NULL, new_order);
>>>>>            unlock_page(page);
>>>>>
>>>>>            if (ret && release)
>>>>> @@ -2277,6 +2278,7 @@ int memory_failure(unsigned long pfn, int flags)
>>>>>            folio_unlock(folio);
>>>>>
>>>>>            if (folio_test_large(folio)) {
>>>>> +               int ret;
>>>>>                    /*
>>>>>                     * The flag must be set after the refcount is bumped
>>>>>                     * otherwise it may race with THP split.
>>>>> @@ -2291,7 +2293,9 @@ int memory_failure(unsigned long pfn, int flags)
>>>>>                     * page is a valid handlable page.
>>>>>                     */
>>>>>                    folio_set_has_hwpoisoned(folio);
>>>>> -               if (try_to_split_thp_page(p, false) < 0) {
>>>>> +               ret = try_to_split_thp_page(p, false);
>>>>> +               folio = page_folio(p);
>>>>> +               if (ret < 0 || folio_test_large(folio)) {
>>>>>                            res = -EHWPOISON;
>>>>>                            kill_procs_now(p, pfn, flags, folio);
>>>>>                            put_page(p);
>>>>> @@ -2299,7 +2303,6 @@ int memory_failure(unsigned long pfn, int flags)
>>>>>                            goto unlock_mutex;
>>>>>                    }
>>>>>                    VM_BUG_ON_PAGE(!page_count(p), p);
>>>>> -               folio = page_folio(p);
>>>>>            }
>>>>>
>>>>>            /*
>>>>> @@ -2618,7 +2621,8 @@ static int soft_offline_in_use_page(struct page *page)
>>>>>            };
>>>>>
>>>>>            if (!huge && folio_test_large(folio)) {
>>>>> -               if (try_to_split_thp_page(page, true)) {
>>>>> +               if ((try_to_split_thp_page(page, true)) ||
>>>>> +                       folio_test_large(page_folio(page))) {
>>>>>                            pr_info("%#lx: thp split failed\n", pfn);
>>>>>                            return -EBUSY;
>>>>>                    }
>>>>
>>>> In soft offline, better to check if (min_order_for_split > 0), no need to split, just return for now ...
>>>
>>> I might be miss something but why we have to split it? Could we migrate the whole thp or folio with min_order instead?
>>
>> The soft offline code was originally written with the assumption that only 1 base page will be offlined.
> 
> Yes, only page corresponding to parameter @pfn of soft_offline_page() will be offlined.
> 
>>
>> With the recent introduction of min_order, it might quietly offline multiple pages, is that a desirable thing?
> 
> I don't think so. Even if try_to_split_thp_page splits folio into smaller one with min_order, page_handle_poison()
> will put back the folio into buddy after migrate_pages, set the hwpoisoned flag to raw error page and hold the extra
> refcnt. So only raw error page will be offlined while other sub-pages will be put back into buddy.
> Or am I miss something?

The thing is that the non-poisoned subpages are also migrated away, 
they're no longer available for the user process.

thanks,
-jane

> 
> Thanks.
> .


