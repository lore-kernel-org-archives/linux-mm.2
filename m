Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32171CCD18E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 09:16:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CE278E0021; Wed, 15 Oct 2025 05:16:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A58C8E0002; Wed, 15 Oct 2025 05:16:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76D348E0021; Wed, 15 Oct 2025 05:16:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 61C078E0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 05:16:19 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1BEDA5CC4C
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 09:16:19 +0000 (UTC)
X-FDA: 83999792478.28.49284B6
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf07.hostedemail.com (Postfix) with ESMTP id 96AD84000C
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 09:16:15 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=HGRpOJGs;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ioNg5wi1;
	spf=pass (imf07.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760519775;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6+MI9H5P+CAGUe3rtsXUAt0AGCN4F072r9pE2h8pcOo=;
	b=2WdHe/CLgL3pRTTsHofwdYTRe6/bUpReEoR75sbY3ojdPVd3kUxMizHRPrs73GWDnbXDLY
	G2WiYS0B8obnJjieaLUDPy/OnfLijJsip34U8omaPc+cmH9H4jbizwWfj7K6Mps5HBA1w/
	REVxTy2mU08V7Pclzli6GvbHB2R4UWc=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=HGRpOJGs;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ioNg5wi1;
	spf=pass (imf07.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760519775; a=rsa-sha256;
	cv=pass;
	b=8pc4iF1kSuFiuuzgFYmU/MT3dWmWudmzes4ReGiH1nYZc8mGVb6sMb0Dadm/UcFfro3TEh
	s09ii6qCp62gCMq8zYAP2DqBWeXwHnmFA6A6kQFWXGJ00B8eNtwSMbQl6jP60wTMR7EsS5
	JEc9RNKkBszeHXLTs/V7CwoKjSi0evI=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59F4uGIA017509;
	Wed, 15 Oct 2025 09:16:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=6+MI9H5P+CAGUe3rts
	XUAt0AGCN4F072r9pE2h8pcOo=; b=HGRpOJGstLX/VXKeTKt+nlAHALAxfCmucH
	SA5XtM9YwY2V0hhWbkmyYg8QHgxMB2Xe0sV6ruMcowWD9vjWAoiS9yqRXHthSBAx
	wZkTA5P4+YIqdeIjW2AEknaZ+8+B0XreVcXo+Vuawi8SkA+zGlOTwgSTV+O6WT1F
	zX8T39p/K3Xh9GHRWnIkPciI8WNxMAV8NyfpasmyMKJRnpNxLJoVhj5GcBO0c6x3
	MERx3JzFaSOReiQdiMlaIKC5Ft84bPYYyUdYa0vVrS8TE0QCS/kFXEuGe1S8krwZ
	ncGfQ3EllwnVmffok19XtJV1Ct1MqAPOAQDPoAO1GGw9B9iwcOAQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49ra1qdb5b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 Oct 2025 09:16:10 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59F8UhbO037909;
	Wed, 15 Oct 2025 09:16:10 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010007.outbound.protection.outlook.com [52.101.46.7])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49qdpg48bx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 Oct 2025 09:16:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ofCGyBGASL6AnmWvmtx+lfcrV9vpAwQ501e+idYzSUKSu/5c1yAEXO6zzJsQrRCx7B2ZikfJBe7DDW8MpOffHM8ZW9cndU5DeHboYkTI7ynqVtry8x31X7rQ6jC1gTJ2tHzpwklUzDSkiuSWYx2T3C13C4KGesUsTyk02Rz9Z/kuep/nEm6EyUZcxNr+0MdgPeikCyTQFNgMELefcxVEuMj4CXW510yt+dcwI/rIIiHClhCj2St29+lan7gS6NIUm/pgqGDtpQWVPQef/Cx3f9kRtZJFYzsg55ns3vOHixD5JQFMbelvLnqwVyFqdbqNQAtPpPLNeDwjhlbSRShc9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6+MI9H5P+CAGUe3rtsXUAt0AGCN4F072r9pE2h8pcOo=;
 b=pd6eNRsZrArMol8PEdE2tZwogMcyrklhAzsm5YksPzTj5vT6U9+XPsGf7FEiu5PGlFDrStlSZAtoWp1jwmzcygZBOTaQq6U1sdnrHisabpcY/BGiYtdGt4+w6vcjCTlaTWFSHcEqI84yQ0pV6YiCVxIi9CyGxjQ4txLSPPlw7BHuCoPghDlflbWRvkfiguv+ZvpTC/Pw/IfU6Bn9RyZjRNyv9CwYOlw7JHZFOvUDor1UDP33MANLPvnhFUlizpkGt/7rofwj51UHvXE6eyV2cZueXDC7HWG3TxclnAFBjljABoBvma7LNWmnnJaFDJpaFU4p3BtzYQTATH4r+yKSHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6+MI9H5P+CAGUe3rtsXUAt0AGCN4F072r9pE2h8pcOo=;
 b=ioNg5wi1tw/uFynnhU8XEJTPX22j7mqd3j5/DxteViJR15beCc49Nz/rHjLv9Hm6YKgqO9ZELncYnLFbkB5PH/H89mViycwBpBvfyj/zSOHx376s/BDee4OFJOxclcL4iNnRZZwjqCSpvBrmWdD75reBe1WhI66Bc5RoXxBOdIs=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by IA1PR10MB6784.namprd10.prod.outlook.com (2603:10b6:208:428::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.10; Wed, 15 Oct
 2025 09:16:06 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9228.010; Wed, 15 Oct 2025
 09:16:05 +0000
Date: Wed, 15 Oct 2025 10:16:03 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Lance Yang <lance.yang@linux.dev>
Cc: David Hildenbrand <david@redhat.com>, akpm@linux-foundation.org,
        ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
        npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
        baohua@kernel.org, ioworker0@gmail.com, richard.weiyang@gmail.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH mm-new v3 1/3] mm/khugepaged: optimize PTE scanning with
 if-else-if-else-if chain
Message-ID: <cc998aee-2a98-45ae-875a-9712d4c29240@lucifer.local>
References: <20251008043748.45554-1-lance.yang@linux.dev>
 <20251008043748.45554-2-lance.yang@linux.dev>
 <3982686f-908f-4f92-b3ae-e6f141e617ef@lucifer.local>
 <cfbd4f48-69a0-4ba9-bce8-f578d9602125@redhat.com>
 <80771030-0d8d-4f65-803a-f89da3b59796@linux.dev>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <80771030-0d8d-4f65-803a-f89da3b59796@linux.dev>
X-ClientProxiedBy: LNXP123CA0019.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:d2::31) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|IA1PR10MB6784:EE_
X-MS-Office365-Filtering-Correlation-Id: 0cc5f7d8-5c37-48bd-95fd-08de0bcb77e5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?AmoX+4/x279Ia+3TEMDfXhphDOFoIihYyi4bAfDTfI1EDTwLb39n7Q9JEAFf?=
 =?us-ascii?Q?s+3IGd/yIfWf+hSXTVeNwEzhDoaY5jxc6rw36fR9KzIxWVzN+/LkkBzWT2sg?=
 =?us-ascii?Q?iU2M4445EnOicbEK7ysFGrHAj73uSflrABCM8IZCbfHi98GSbqamdJuKWh0B?=
 =?us-ascii?Q?G/OKs4IyhdwxEy2TR0LIbl5Sxi5u8ndm+0MWl8Dlmu4jyfy60rdWqzhBcnP/?=
 =?us-ascii?Q?HyoG6r57XVcHfDNBO1HvtuqGgbyajgmBgQRyBBwboj71OHt9zErlw/hznPM6?=
 =?us-ascii?Q?ZXQqqOiAmw5L+HxpE9jtI5RAG2DNP96G3UDEmEvPreXiP1TrJpiwnU8Tu0Rp?=
 =?us-ascii?Q?K+7CaSOSrKCISwY97+MckCU+D+OyfJ0MTKBVoxNff5alD7k+2TPP9gnCnF5Z?=
 =?us-ascii?Q?fN+vz2301QZfNbRAOI6At2F/K5pZN7V6nrYdRZ9Lqmj4Cu1XQuCUMZs/ELFA?=
 =?us-ascii?Q?JW0tLpvdCqobKCj5yUn9yJd/B4Cq0yT/GDR4+M6D2u6RkyBbFPd1P5DAZZqu?=
 =?us-ascii?Q?T2CmMW6JddVDL9aS0DdYLihY0yPxhIQ5inkjcP1AVUh3mXrqU+LOXsn8xT9C?=
 =?us-ascii?Q?FLLex9DZ5bX1srniq7qfDi0oIzFsrBxXF80Q3HLDPLncTzJxkCSysUtKVSdZ?=
 =?us-ascii?Q?4dh/pN58wo7vkftoe6zdrgzlNN1WHN3g/qsiqvYqov+cINgSyve6O1CZbHvt?=
 =?us-ascii?Q?//yWb3ClXKI7oqpsPiqGMJPDdzEbxeHi8N2pdFLZcBaL1CgON7T+Xzy+/L5C?=
 =?us-ascii?Q?/LO8gz4dasgH9ccEam44vBoz7u32jQbq3E2Y36i7q/VigOIIg5goONsT9C4h?=
 =?us-ascii?Q?PYFxbW5AxhpOCWCxWrFAX8WMfA9FzonuiFNqomnzca1n7f69Kk3UUu0jNLoJ?=
 =?us-ascii?Q?k8O+b4z3hn60FTb+6COiNQHFYGLZE//aFL1xGKEgyidqyNAJ8XQy6yMMBFwc?=
 =?us-ascii?Q?tY86fGx2yX4QeId0JkV5uw1Sc05Ov/1hOKf9IQoEo55bKw15UArd5rGtzt0u?=
 =?us-ascii?Q?4R/C5QqU9gKmvHz2XfDjtjxkUsIKs9vgIlkH7UMfWJ6KVPWndOCfp+8zf4xL?=
 =?us-ascii?Q?Tq/Emf2axsqgdrZYtkCDuQrd3vxoVxdnfNFt5UxYZ1ogFnI4BSXE2GTFSj6G?=
 =?us-ascii?Q?c0RUhqy4pQFFD7JvPhijWh+Clq19M1o1WvKgdGqLpelhbcTbgQugrHjB4SyP?=
 =?us-ascii?Q?k9hWS9/1BRz5JCZbOcLKX0zErKUX2KZ9oQ3G9j6CbBLsZtQt5Ksojk7bSFUs?=
 =?us-ascii?Q?fFs4CStShk4gIiaMBFCZB3+4bB+FVzn/YvH4stbhfoeCtfzT4UNmMb/vmah+?=
 =?us-ascii?Q?rzY1zl8KVSq1XrueC+HnZnxXTZkC2/w+7Lw2Q7vbRe1umRUwTBdNPTyJsnqI?=
 =?us-ascii?Q?3nic0AM8r9yXmYo+yQdTZj0B/Qt72DU8G5IbAQA1dQgh9eHb0rZjVmDY9+o6?=
 =?us-ascii?Q?N/L6hGB1N/+nZg4+0iJMjhLiSi7SMMID?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/KdZQsd6ILPdwywb3XqYZcEP52LDlyMWJ7DjMnWOGaRxhppL5QwsnQ19B5CR?=
 =?us-ascii?Q?4lVNzdd7IVhrPx85M4h0+oo788upkM3reh9fFM7x9UmVxxbiNXYuwlPLpESg?=
 =?us-ascii?Q?9P/ZpgMMwg46HEIQgP0b293BU9oNn0Z/u7LYlW+cuhAwo/3+mh0HOp7Nm4eS?=
 =?us-ascii?Q?lXP1U6LCCj28YNDqovm3UP3qtCsQLZrh4Adh7J3sxarYswwygc5G89yB/huA?=
 =?us-ascii?Q?xe1orZ4HJg4TKJi3HkC8NQszM9qapfwPauC/uOZ5ocBm9mjuVXP09K3giwKa?=
 =?us-ascii?Q?IepwndqTpsk/ldFBn6DvlBuixBvGpKp1DopzFq0jJj9YyUFVQzrtv+ta79jo?=
 =?us-ascii?Q?G0JKcAnANsp0pNKmv6a0VTNE6o6D2KPSPSnZDP7DZAN+OjYFH5IVZzN6aOk3?=
 =?us-ascii?Q?E9SL/nv5/5V2eE35GouL68pUD8ubQo3o50wPaKCNQnaTVSp4Q4g+K9Nv2rd+?=
 =?us-ascii?Q?X79B5mlnki4uTXdGjgv0HiWlTsOPmp65akyCFv7aGOj6BKfG/Li9BexsED5a?=
 =?us-ascii?Q?ZoIt/QP0/EEwfatrfETf0fEvYTm4y/HPC46ZtmvzUP1kgRPHaU0n4KVYT06g?=
 =?us-ascii?Q?dt6DXifCMVo6eSy1UM2XyhuiUajKVg64uS/UmMiodCSePH/7SOt7fhV9S6P4?=
 =?us-ascii?Q?WwTlCBWQUJCi1OzshJUltwnOo2D4CAq3HcdEfT4Nn9PUppE1szH0kyWovyov?=
 =?us-ascii?Q?YPI/e4oRj3y7IY1raQeFkjej9NdrCXiemumsvLJG/ee93Fggg4Avb3GFk34a?=
 =?us-ascii?Q?ENZiEnKIa7NlNmxvSQpcpOqyGE/Mb9SZk9F6nmUbVsFaw9wSPHG+p34whImR?=
 =?us-ascii?Q?YRwpe3oms2SeaBvpluWjtl3XDyLwtWNZpomowtxVrPyH0LqF/NY7O8P5UEhi?=
 =?us-ascii?Q?iVrK90uWbNxJQEFTd47tgGjLIyM4aPQbusYxYuI/umN1BndPqHPCK2M4puEB?=
 =?us-ascii?Q?yD2VO3DQHB64PKnc8NFYqzNMuck0h51nJJCpFVfuX0M/+t3bGHQAUIoy9UT3?=
 =?us-ascii?Q?/SlJHZJTQRb42KVmoxQ9D6/z7PB6r8nSXXWcnF4ofFQkVxxLmS0pwgbT46ye?=
 =?us-ascii?Q?zvaXNyqGiA5SD3A3avOapyiSNMdqkt7I3B6/43B7/wEw6k33iQGPUOqBW4Xh?=
 =?us-ascii?Q?XqGpo5lN6RNWYPfa9pSt3LbwaF57aeEfpTshZA5LWx7BLaE3dKfCk62vnGLD?=
 =?us-ascii?Q?MiVJeXFaafjg39kg1Re8OaWGE/ENzWhJs6VFOrzfV1hNeOjFqxRFT6m1z2BU?=
 =?us-ascii?Q?dtnpPyDvQ1NTxrS3z/xYjcpAxEqJnoKG5cxfEIycvLYwm3tM30AMzN3yN/sR?=
 =?us-ascii?Q?VIr6CMC+ettISJTttx7KUnz9Hju82UAh0xMd0MHbcZS6SibFSLyksyf6ao/l?=
 =?us-ascii?Q?080jRJKtYYYlvihvP0Di/FVmChsBW0wV5SOrq1mZobTHhL+GidD6s6qvnrew?=
 =?us-ascii?Q?X3AwmpXPPBqo51XJj8BTOuyB5nlOfxXHck0aCmU7BF83g01oM69nPKjeX8it?=
 =?us-ascii?Q?bnH3b1sjyGw/74b2Tt7rNa2J8BIDto+/1lJjxFpaKQAjiztWjXCat6jOaaiZ?=
 =?us-ascii?Q?czLKN62GnAquL+NPhVdYsUhZRws+fO4Vnd3fUe2JZqtl+nz3H3YV+w6An5BM?=
 =?us-ascii?Q?Mg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Jbdvk6k8k9Nl7glpaaK50sbcrBAdbN2KL2KEmuK2O+zA24PCUZqVJTZzkt/wSjMIiaacPutiG8hYjMOvDuxCey4NroAjG7LL6oUHui7h3U+ennw6x4NlWMnVB/FLkDvbNHgzSyIvEVjOBxfcKIgXqcix5y18ivRBiZav7rKai2ocyyJG5LKM12P9BNzUyoUzdasLVLtIJxX6/LKDNLkoRmsA7RuqH66W0qUxUOMuZizfwP2e3iV+idwM21BVQdlhniKksAFoWZ6vq0X8q5zZOLd7+81RFP1xxPQ0r7bhQGIHOYPKrtof/rMjpiF2rwdJfXkiZapMI9STf0kLKuVO70UK4nZqVei2tBQecy5Dme1DkfprgwYo2JhO9VCTkvUpJK7XrkTpm3imkjxPRXfvXvih0fd/QQp2QT6Dq7BShsi8uOAAz4+R+FUNj0qFxuK6SqAY/4avmNrWYW3VmfMI6hxnxb/6U+VvjehxF2CV9pE5GSVhna2M/GvU3tsnxqmAn2PpqqO32zyDJCR87ftkS/aflqp9yjL5k+fYArcnieCCd3s5wGIUQIW3TBRHvtVx3j8jTHqjA+6t1hBocH6bYyh2cyWwyFXXqeGXQBek7fE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cc5f7d8-5c37-48bd-95fd-08de0bcb77e5
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2025 09:16:05.1575
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aZAyv9B+bpbZijJRoAiN825V79b1Mgg7lq0nHFExighv+NHR4jNVJfNUbL8VOFei+rWlt2O81U6xSDDtjWHO4Ahhmuj3RcVbU5KQMwu/Puo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6784
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-15_04,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=456
 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510150070
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDEyMDA1MSBTYWx0ZWRfX2T4UyW06ug7v
 BDylsraYYYVmU0DY6AaGuhZ30Xe+xFfRgAJlSmNYKMfbjguXoIUIMsNPEOiejq0oAfpaScsWogR
 oKl1SjS6Q+UYH6p1acQkohCiOyPY79hbix+el5P1vdHgaB+5Dgxb009rEUa4AbeCSGpgm7yx78V
 zgGoQoj4Nk9/MJUJ8b1bkpS4Rj/mDshsW1dHv3/KiLys+waSIIx0I2B9GzKtNdJzXta5deaYMbq
 1tJxK4sGhatP/V8Sl1XMGbbNjFvxwNKH0LFo3uNaI37L8RIPj4NTsTwH54+lw/0ZhLa0J9UmehE
 ESvABthZITrt/52KlpH4J6F9cflOkOnL9nQGwBdJejk3WNCDtTrOfwo11MtQLSi4E3ABybybmvz
 /U2qrLeS8DDcCAHE2mocGQrHHPPp0Hnzc0wgfzdvUrzkmb4abZs=
X-Proofpoint-GUID: UdMec6zAjr2zShu8Ff5PTciOpVx1Q4Y7
X-Proofpoint-ORIG-GUID: UdMec6zAjr2zShu8Ff5PTciOpVx1Q4Y7
X-Authority-Analysis: v=2.4 cv=GL0F0+NK c=1 sm=1 tr=0 ts=68ef665a b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Brgje6hBAx1A1USD5FYA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12091
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 96AD84000C
X-Stat-Signature: bemkzk6fak18susa3d37dcxikda6yqkj
X-Rspam-User: 
X-HE-Tag: 1760519775-365783
X-HE-Meta: U2FsdGVkX18ovtcBcRe6LHDe8cdkPBM3og5TBLFI5M9RJiNZioXAqx0CXNXt2EG9F+U9eEJzOAkR1Fa/kHXnDfvHrEnjmf2PCy250cQgWLDlVGKOPuQoduAqYUdfnLYwHn8/fLVEpV5XIS+t+YAnDgHdvn3L8AMqnQPw4vD8tz702KRHaAiaKU3wsiKPAaR80caU7PwDBM9mlI/u/sqveXrMJWHFKGIRzYA1Y0RPGRcQ+5xrJ7VZGUGZkB5hdjB1d7mgJs4PKQAz9JLx9/PwCQ4O5TSDhHhF3DfFs74ETh0jibhRzyw1vV3ixOJvA88cv0EO6jhZgj9ablHEaJcstaRHYs01mBtAz+vbRS9drmQ3O09jzYX2xb3RK8MpfRnCrrDhnk2xBJ1OCvfV6VOrb7J2LTleVNSTxZ1WDKyY2IhlPadTOBE77IWNMLflQQl/Zoq+cJkSthXSVhjKHIPNEPSjd6QidOfbEfnRPD5igwXXOy4GuTf9g3Y/6j74j9O179nfm2mhAvE5oc53vxEXJ3Gckl5wlv0oqWC2xM3aub6J7a0sJotnzCGlIpbd5eQgFub/pZ3KZRKyrwwi8t8YSfcRK/8/PRVRPgNV+D7u1M3Fbo2wfvhCXFzXFvaqGZz7KlVGaWODbryvBZLWbcvTZ5YztQhvQmE/PN3rPmO12xLlW40Gc6y6wSnL6sY6oy8ymVYo0cMp9CPiMwJvx3OQbTt3zwkbZ9P+9BrCNJSnRiFZEEanp/p5oEY9rHua75sFLLhBxO7i29A+bXa4r39uIQhlTCMchRbUd5rKdxwaL5VVERHLjz22WOAdUqyVvLqYW1ruG4srnldDJaVZ7676n6DVHQmgOxOiEwhmt5MNK3+WjQM9xVTv1UVJG5y9ZrP02pzxql8vtQW37fQMHCenRi5FuXWZBUFGZhWamXacqXGjUileaHfoS5BaoUwLzY0IlENrO8dAGBVROZqmQzP
 g+Ta1/xg
 p3vs9SC6vW+M98173I0K/fgnu8MONDOgLCgBnxJCdtSXZtEjWJ45tcL0IpDqX1tqTXbxWKnWRHQNMGFB9HLfgx5ONlyDpEcQ9f7hc1PVB1bh+sT53WCEBy2fzgLncltZB+39qAG8IgkJtt8TxqsqnLs8XqIAf9Vhylj4df6MqN/IG2VRVSMX9j5Ycd0adNUAlOjikZZjn1xFDjaamKbi9qV/kmGPDp8kJev/VIFwddngdN0Ca8k+GLzTPZeKjSrEWbgOVwgpsmOAgQYGvE89sr3VNUrDc5iZ8BNcDHm9SLBPHM9coQEK+94Tpm6vu/z56UwM4dMTcVEAzVAKwBW3fGuR4aZIcfCul+TNf7pGDGV2+O8XUPbHJJQSU0N2n0HYb0lZBpIY1c0N1NjVnKGgC9KAIropIs2d7RtzXB4ZHIswbF+P0N5a7S+pVoMk9J7pPrN4G5oAy3nm8alDn4ipu/CcmTZdxx3VkW5mf/+B7XCOvGuV/zvvLcSl5GK/6mNu9UikdprczOJfW/s5CRxKvQCj0XWbcEEmgh3ZXaPi7g2nRd/kW2Y6n0yhoY03YhUtvu6WrLQThGuPtAEnRSUrvyA9462+4WursdDPxJZzAl81tvpr3qG80blk53Wo1Rptxviswm/6lnbMqdPtdwnFmflZn8zMuSb2BCJq6+SUZd4fZFGl2XmeMV9RKyf3y4FbAVT44
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 12:49:26PM +0800, Lance Yang wrote:
>
>
> On 2025/10/14 20:27, David Hildenbrand wrote:
> > On 14.10.25 14:17, Lorenzo Stoakes wrote:
> > > On Wed, Oct 08, 2025 at 12:37:46PM +0800, Lance Yang wrote:
> > > > From: Lance Yang <lance.yang@linux.dev>
> > > >
> > > > As pointed out by Dev, the PTE checks for disjoint conditions in the
> > > > scanning loops can be optimized. is_swap_pte, (pte_none && is_zero_pfn),
> > > > and pte_uffd_wp are mutually exclusive.
> > >
> > > But you're not using is_swap_pte anywhere :) This comes back to my review
> > > quesiotn on the series this is dependent upon.
> > >
> > > >
> > > > This patch refactors the loops in both
> > > > __collapse_huge_page_isolate() and
> > > > hpage_collapse_scan_pmd() to use a continuous if-else-if-else-if chain
> > > > instead of separate if blocks. While at it, the redundant pte_present()
> > > > check before is_zero_pfn() is also removed.
> > >
> > > I mean see review below, I don't see why you're doing this and I am
> > > unconvinced by how redundant that check is.
>
> Ah, good catch! Lorenzo, thanks!!!
>
> > >
> > > Also this just feels like it should be part of the series where you
> > > change
> > > these? I'm not sure why this is separate?
> >
> > I think Lance is trying to unify both scanning functions to look alike,
> > such that when he refactors them out in patch #3 it looks more straight
> > forward.
> >
> > The missing pte_present() check in hpage_collapse_scan_pmd() is interesting
>
> Yep, indeed ;)
>
> >
> > Likely there is one such check missing there?
>
> I think the risk is exactly how pte_pfn() would handle a swap PTE ...
>
> A swap PTE contains completely different data(swap type and offset).
> pte_pfn() doesn't know this, so if we feed a swap entry to it, it will
> spit out a junk PFN :)
>
> What if that junk PFN happens to match the zeropage's PFN by sheer
> chance? IHMO, it's really unlikely, but it would be really bad if it did.
>
> Clearly, pte_present() prevents this ;)

Yeah, not so clearly kinda the whole point I'm making here. I mean all this code
sucks because we have deeply nested conditions and you have to keep in your mind
that 'oh we already checked for X so we can do Y'.

But the THP code is horrible in general.

Anyway let's stay focused (so I can stand a chance of catching up with my
post-vacation backlog :), I will check the respin once you send!

>
> By the way, I noticed there are other places in khugepaged.c that
> call pte_pfn() without being under a pte_present() check.
>
> Perhaps those should all be fixed as well in a separate patch?

Yeah I'm not surprised and sure indeed.

Thanks, Lorenzo

