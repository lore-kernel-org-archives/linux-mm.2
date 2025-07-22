Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD837C83F1A
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 11:55:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30EDA6B00A7; Tue, 22 Jul 2025 07:55:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BF886B00A9; Tue, 22 Jul 2025 07:55:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 139676B00AA; Tue, 22 Jul 2025 07:55:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F22976B00A7
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 07:55:29 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8401F13055D
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 11:55:29 +0000 (UTC)
X-FDA: 83691745578.11.6F47E35
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf12.hostedemail.com (Postfix) with ESMTP id D4A9640005
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 11:55:25 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="e/AakLdG";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=jUwzjzyy;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753185326; a=rsa-sha256;
	cv=pass;
	b=S5GZCZXjO5ENG4pzZyI3xyrl4pgJYEdenh+xznpVnQv5YXffYVH261fcFKyq5VVNBk5rAi
	c1NNF8WXqRyZpRl5Upev4OyEqrt23viyMJBd4Z/zp76R6AYbcIrcXW/a7jPFPQ546Jb1LD
	GsgCeK+HeJ2K9Jcdv9MMTZ3zVh1gmyo=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="e/AakLdG";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=jUwzjzyy;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753185326;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W0TnqAyi8vMfzH+0w0se7SdSi3npjyzRR6J6p4kmgtc=;
	b=BzSrh/SyFFIusg5ZonBS2BxoedwnSdV0paGozydhePqxfhdA1ZQFHkcGIhZYmrgI2SNpTR
	jWX4PI7s1IeDi1YsoP5cuspZQYfDyjLb7rgzW6iUsjxrar+0N2wXRr+kGiEAD00iq9vUEi
	aOlVywqBuveTBtOkVpszxhzLb7RUSno=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56M5TCPZ009173;
	Tue, 22 Jul 2025 11:54:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=W0TnqAyi8vMfzH+0w0se7SdSi3npjyzRR6J6p4kmgtc=; b=
	e/AakLdGjD93dANRRS71nbawPBl91oEvuAnjkuVfPLK08ndD8igw7WiP/+Dz/JY8
	HgFAgIIsPgsdqgwYR43aT0eHVInO8NFBtMK/1sbZhuiNVUKD/OfXG1UPb63hepRt
	YySSugL9E5q9Mud0JcVaHSqUAe46B9wD1d1VaSB5A+GbEGQFXjY2l0ClgGJfFPDd
	zdXE/FeGwtPRdMZUDb24kZtaIlJm+j6tjiEokBu2C4NhjmmbnT6/dUfOdoUuSQtr
	blpHTJwRil9bO222+x4GllJ1M07amaxqBQSrob68YDcUTAlOFg8y9fumdzmRF/Oy
	9QQfLW6nmYc06U50tpkLOg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4805tx55dc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Jul 2025 11:54:55 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56MBlTpB010459;
	Tue, 22 Jul 2025 11:54:54 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02on2076.outbound.protection.outlook.com [40.107.96.76])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4801t97wwx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Jul 2025 11:54:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OjeIIl0v+/fv7Szf155ODZcgXg4jTLtxD1/cPEYO/sMvi+7aW9FxxpcGPfN485fScKZ5zanN/d8nflLXLIHTUtrfkmy9fAjAuSDbFASM6y+/3Z750qHlDIjQKHPO/qK59J/BH7I9TGJRhoA7mNNUQcYNsz9L27mXjkoIkpnVnQ2xiR/CK1o4I0IbytEE0NyF4XI9fPnRIQQbxSfXXYOOM0ljCRFojQMAMNCoEuzBHzMDydP78hVDD1+edaD0rUVacwjBWQK4JrNCI5AXBDwtPkDCczaDJ8x8hGgRN4mCWyXH08TlfWT+WPrOQqL6wdyhrE+rhe8rPbNozU3/kvSOxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W0TnqAyi8vMfzH+0w0se7SdSi3npjyzRR6J6p4kmgtc=;
 b=ml2xhtxmgmNUx4JuphdKhfl+TrTiZVmXefwceewiEc3ZsfOWrdXyUPvicsE5QHPoxxU/5+z8s7WIVUAdIj/NOzEZzdOPjkezQ0v3TitIPSir9R88Id+zpoX6cdfWUVM0qSlRTzInVBf7OUCGQHmQSAS7v26s5e4uao8ODVDna8jEJ3RvZP26iDVNvcKkRnnX9Dah5o4uJvGMNvrHmzwenQaizGyTd6aMfI4C6QOmebA/f/1+VhF0g1lHe1eQv3JPWSbdceXhAy5cR/TYAbQ8We2jHZufK5pCPe+EVJ4Q2omVd4E5b0RO1Erx8ULiFe0L/M17DA96qXUl2RKdceKXSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W0TnqAyi8vMfzH+0w0se7SdSi3npjyzRR6J6p4kmgtc=;
 b=jUwzjzyy+cSZNGg97IaNw1ntNHDwwd8HwZnKKIkrR3YBXa3G2A+CA3fBR7xiUOpaRXA2d/8IypYNuB/x29R1ZQvWlx/b18Bc/ZkEzupmJzAl2F54HLy2iZPmyBvFcoHVNegfWqL44nRSzmcf+C1QgGzQoRyC6lFdRvrif+b7SVA=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by MN2PR10MB4192.namprd10.prod.outlook.com (2603:10b6:208:1d9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.29; Tue, 22 Jul
 2025 11:54:51 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%4]) with mapi id 15.20.8943.029; Tue, 22 Jul 2025
 11:54:51 +0000
Date: Tue, 22 Jul 2025 12:54:49 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: David Hildenbrand <david@redhat.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Matthew Wilcox <willy@infradead.org>, akpm@linux-foundation.org,
        ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
        npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
        hannes@cmpxchg.org, usamaarif642@gmail.com,
        gutierrez.asier@huawei-partners.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, bpf@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [RFC PATCH v3 0/5] mm, bpf: BPF based THP adjustment
Message-ID: <fa81148d-75ac-490d-bca3-8b441f2afe1c@lucifer.local>
References: <20250608073516.22415-1-laoar.shao@gmail.com>
 <b2fc85fb-1c7b-40ab-922b-9351114aa994@redhat.com>
 <CALOAHbD2-f5CRXJy6wpXuCC5P9gqqsbVbjBzgAF4e+PqWv0xNg@mail.gmail.com>
 <9bc57721-5287-416c-aa30-46932d605f63@redhat.com>
 <CALOAHbBoZpAartkb-HEwxJZ90Zgn+u6G4fCC0_Wq-shKqnb6iQ@mail.gmail.com>
 <87a54cdb-1e13-4f6f-9603-14fb1210ae8a@redhat.com>
 <CALOAHbA5NUHXPs+DbQWaKUfMeMWY3SLCxHWK_dda9K1Orqi=WA@mail.gmail.com>
 <404de270-6d00-4bb7-b84b-ae3b1be1dba8@redhat.com>
 <CALOAHbDMxVe6Q1iadqDnxrXaMbh8OG7rFTg0G7R8nP+BKZ9v6g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALOAHbDMxVe6Q1iadqDnxrXaMbh8OG7rFTg0G7R8nP+BKZ9v6g@mail.gmail.com>
X-ClientProxiedBy: LO2P123CA0041.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600::29)
 To DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|MN2PR10MB4192:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ad854b6-917c-4c4b-24c6-08ddc916911a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MGZTbE1LdENSTHd2RzlyeWkwdWJ4bmNiT3hQVytIaUwzdkpiWGtPWUdWTitN?=
 =?utf-8?B?QThrNEdyMG10Wmpzb1gvQ3pFQUY4ODgvV1k3aVliY2JpZjczWFU1VzNveGhT?=
 =?utf-8?B?ZUc5OEl3L2xsMzM3bVhkR3RQVHRqRlM1TDIwbmlxOWM3RTlMNXdCZ3lUOEZI?=
 =?utf-8?B?YkhqaWVvaUdEa2JsaUY5bWMxbGN2K3ZoYmpnSzg0cmp6d0JIV25YUVl4RWFv?=
 =?utf-8?B?L2ErdHlBMWlqOEN6ei9vVmlDVVlibldONEx4RmpkdStHNHZIelBPcm9JVnRx?=
 =?utf-8?B?bWVMQk0rbEZlU1hTM2FUQ0t2bTRYV2Z2Z2JEbnJCNHpDWkluWkxUSVh2SUVl?=
 =?utf-8?B?RE5KRk9za2J6NG5xS3hhQWpIVzFwYkZ0SUFFYjhCOUFWd2gvZXdwd0J3UHRz?=
 =?utf-8?B?aXlzOUNNVmVWMEdDU0k2bWtidG5mTjQrVTUveEZBM2lKMVdDY1lhSEZ2bkVM?=
 =?utf-8?B?by9QSFJrdE1yZUUxOW56dTMzN1pQSDJNbzBQSEFCVnJJcXlsQ2lHQjBKNktq?=
 =?utf-8?B?NDlSWVRMVndoRElYV2JUb1p0SVNnY2pYSGVJeWljSnBEcWY3aEh0ZDFoZnB4?=
 =?utf-8?B?UkliSkUxZGYySW1rTFF5NWVCZUZxVnBzcjdSNG03M1VnTnNPZXd2ejIwVDR1?=
 =?utf-8?B?NytTZU4rVGVXSDJUMXF1cytWOUsxYm4rdXdXdkI5eG1uN3NwQVRLOW1ldnR5?=
 =?utf-8?B?Nkx5aW1CanRCYlpNS1ozalQ1cHBnLzVFWFdsRExoSmZ6U2dCQUI2Qmc5ekdO?=
 =?utf-8?B?eXdIdmFWcTlldGhVQXlOSzY1MUJIOXVMdWlua0lKQ3RFVnp5ajZMTk1VVWhJ?=
 =?utf-8?B?aFVXZlR0RjMrWldaY2VwUlNCQjFyTC9EVHRsSDBJd3hQR1FxNldoYzVkTjkz?=
 =?utf-8?B?SDJERTc0dFhLQ2dkb09jQ0dCeXQrNzFhLzBzOEM5dXlGcmdybmNUM1JjUVpx?=
 =?utf-8?B?RXN3TDN5ZXAxYSthYXk2bU8rTExjYlh2a2FOd0ZUOGhpNjhYL2xGTGoyb25K?=
 =?utf-8?B?emE2OE43YldpUlI5TkJIZ0N0SkNobnVIUDR1emN4TzhMZkV5djhDK1BPdnVN?=
 =?utf-8?B?OVkzSnYyQWF6bUhTSXVTM2xzUjQwTDNvZnpPNmh2ZjZFUlJxNWp1aDl4V2p6?=
 =?utf-8?B?MTdMK2dRLzNvRXlidU9LNmJBN0JtZ1hoNTAzN1ZYRlZFU25zS2ozN3QwalA3?=
 =?utf-8?B?S25WSVZrYmhNMmIxMlpHaWswOXBwU3FVaDRhK3M5VVQ5bVo0RllORjhjYUtX?=
 =?utf-8?B?REQyWVNXa3I3ZFdoZmp4aXlsYmMwNlFwUVlReVYwZnRQYjJyRGdoZVdRc3V1?=
 =?utf-8?B?WjNUa3VoOWQvb2NHR2ZJL1BKS2JtTDNITEVaUUorbklzWWpERExENTQveXlG?=
 =?utf-8?B?bUM5THBPbUc4V0pNNEdqWHRacjB4UkRkQ1pTenFkY0VrQVY2MWpURUJXSGhX?=
 =?utf-8?B?TEhySU1CODFJWTFPMVlZTzFnWFJNSm4yajVkWm9XdFNTek9FWlNsWDZQMFZW?=
 =?utf-8?B?U2g0RzQ1YUZzSmc4ckE4Y1AxYmMrdm1NQTF1NUFKOGs1Zlc5ekFBajRqODhu?=
 =?utf-8?B?Zk9jQzdFOG9id3ArZ0lVeG5hQmRPVC9kUUpHMXBkUDRabUROYjlKa1k2a0Jy?=
 =?utf-8?B?R05wRVhLdTE4c3AraEdObm9aWkZlMXNwVm1pN3pVTElCbWQxSnViTGphTDNO?=
 =?utf-8?B?VGhnbjNub2VabFdRMXFIVDB0NC9vODNKZUdBUlFjTDA1U3ZORi9FSTBXVXBl?=
 =?utf-8?B?REV6NGdjVE0yQmY0Uy8wOHZzbjRPUTJTUUF0TzhUbkF4NlliOGwyTlMwUVE2?=
 =?utf-8?B?VFl1bXFBWXI0MWVYZUx3NjBaL0xJb0IrM2F1RTIxZDNGamdZK1IxTXhTRjdh?=
 =?utf-8?B?SVgxRmdUdndveGJQejNZcFBlQld1WWhWcGw3UmozMnpwNDN5OGpnK0hvSEVm?=
 =?utf-8?Q?VPV2a5Owy84=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?L3dtcTUrK2EzMTJuWFRXZjE1ckZMVUdPbFJmdUdJcWVRQVFIdXhqM2hTYWtp?=
 =?utf-8?B?S1RFVURPc084UGNCUmdrTTE5eTNhMXF4MS9odkdXcE5FN0lpakZFdHdWVFd0?=
 =?utf-8?B?aHpuVS9YYis0aXlvRjh6R3VXM0l2ZVBxelB4UDArUDdJbmhGSmtlVmhvQy91?=
 =?utf-8?B?QWZkU1pxYjRQZnQwRVB1TldEWWpOWmJxQzJWOEZUUHhsdmNpUFl3Y21Eb0x0?=
 =?utf-8?B?bk1QYW5hYk8rQkpTSTAvbmpQRnJJdHBYUU9OZmF3VEp0M0ZoVlgrTnZ6ZWll?=
 =?utf-8?B?aGFEWkZjMFB5OFJJclFWQkZjZUlYbzZncVF2R3VqWFoycHpna0kvN3FMYWlI?=
 =?utf-8?B?U2V6RHZuYkE5cllKK3F3aFcrQk5LNmJGRng4T0s5amw4bThoVHE0TlI4WURG?=
 =?utf-8?B?UVNhL3NndEt3QnU0ZWZ4QkEvTGVpY0lacThESlNhZmRQdWEzSVFqWXlVK1Ra?=
 =?utf-8?B?OHIxQVAxVGJjNnI3YStrQ2J2TDJ3c2tlM3E2R1l6UG04K3NLcWxQTkNwR0d3?=
 =?utf-8?B?b2llYTdKR1gvbk1xTytseERWdjRNd3NUKy84NDB1cGtoenNkUGZmaEM4UnFr?=
 =?utf-8?B?SithNEE1N05uRjlhNTF3QjZWaEFaK2dWbXJCcXUzRS9nUEtkWlFUWkliamt2?=
 =?utf-8?B?eTN1VXljOFNsS2lDNzN5cXk5ckQ1di95RXZpNEd1dStVQnd6akNUeFZyY2VF?=
 =?utf-8?B?ZWRSOXRIUnNIMGd6dU9iaHpBS09UMVZqWnFzcVlYU2FPakpoRFllSG9IU015?=
 =?utf-8?B?OHdZbTJaVzBNU3Mzd2JmNVNpWFlqS1N6YkpnRlJJR1VUKzkwQU15VzhBMlJN?=
 =?utf-8?B?WVJsZnVIVWdNVHo2UnQ3VHBnTlAwZVh0R2pSMVoyK1VrTmhDdzJ3eDdjdk9a?=
 =?utf-8?B?bkJDKytOZzd5OS9zVXJIM1dzVlN3NElrazJEVkdQN00wcTU5d0owTGo3WlQ0?=
 =?utf-8?B?VS9VMkV3b3NTU081ZDZzL0ZTUlZ3YTFxU0pwajZNQXBFOXhLZFpqTUpDbEpE?=
 =?utf-8?B?YXUyWDkzeGRTYzNrQXFLZ1NMVHp2THFvVkZYbDhldUEyaEZQQjNSKzFCTmVq?=
 =?utf-8?B?OTU0QzhzUGkyT0RqN3NJN1M1a3JteldlZStyVURUM3k0STFHMENKUXpGVVJJ?=
 =?utf-8?B?MHJTTHdMYSt1T1FnNTA1L2toZzFMK1gzKy9YWnd5Mm1TUGllem96a1diQStB?=
 =?utf-8?B?RDhFMThZVUNqelhDR09xa1VrOXVqdWJLaXdFcHNQaHR4UHdOdXVPQURralNu?=
 =?utf-8?B?alpjeWF2SWJsU0dvTFRvSXpXZTJ5QkNObWJaamlOZGRjYWhaOFpjVW9aY3c2?=
 =?utf-8?B?aGhrbE1TSkVQSXh5dzRTSXcvbVZrcFRHSWhPSVNYWUJJTEtqaklGQWZOY21F?=
 =?utf-8?B?MmY0S0lPRmpKZDJrTjlDem4yS2txSzZDSVBXWmhCajU4eWJtODEzTCtqb3Rm?=
 =?utf-8?B?SE1LcWRDMkVYRzBibUdiYVVGNUZIMzBnZXNBNm0zeUdIajIrYnFZU28xQWQ1?=
 =?utf-8?B?OCtEcWF1c2xmVWFzRGE2L2RMdHRIL1ozQ2FmczZjOUl2Wlk1aE1hQ3NzZ3dM?=
 =?utf-8?B?eFRLVDJVQzFzTlpHZVBWOXpnTlN2U1NJdmJjd3NPNjRsM2NYV1ZPMlhoN2dM?=
 =?utf-8?B?bkpSWktUQ1hSZWVFa1dvYVhiZldPdXJEL2c2eWNoQjZTbkZUMWlBT0FVQnF0?=
 =?utf-8?B?Sy9UR3JIUWJHMWtrWXppbjF4aHZqSGtSRUdjdExnbTUxUjlQaXd1S0ZFY0tH?=
 =?utf-8?B?TzVDaTdLUFlSZjBFVitBWElZR0h0cEtKaVpCZVdEWjdmaVFhZEdwQ1NVRGYv?=
 =?utf-8?B?TG9HbWowejhsVjM2cGx2V2VtSG1BOUR2MWt4dlQzSEVQUWdvSE56cG9zYWFv?=
 =?utf-8?B?elVHMlBEaE0rc1BLa1hDSFppOWJDeWR2NTRmaE1pdW1aTEpCeGFGYnl6bW01?=
 =?utf-8?B?TkRoNXdKWWMyNGtxeVlWOE80Z0haS3VDY1RDQW5ac0UwS3h5blVIckw4bGZK?=
 =?utf-8?B?RUZmSUdoQUxHN25LcEh5OVh5cUoyeENPNys2SGp1NDJvWE8xY3p2N0hMV2VC?=
 =?utf-8?B?VklkOXdCNzJ4OHpYOGpqenBwcVRwenIwdkc1THBLSFhCK2s1Y1ZZbmJNZ2dD?=
 =?utf-8?B?OFBwUVFMS3lWcjM2ajBqcW5RSmxQUXFXdXY2RmJoWENiQVVTRkd0MHByNGRF?=
 =?utf-8?B?L0E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	m+lzTLeu+IhZkBWlgCmS0vJFtF7DjrjydFUlucjJ1DNvxD0qkwX7V2ZZxmtloFHvlQwTdlAcgqEIt2tvBwhPnWYFnKRsycCGCOoZv1MunUjOsWGiIagvaMsZHtR/lDqg0nGoJlKbwIkGx45RjK1TQ+BIWY0YJtjnM7vR1PUvjNYyGUZNiAxQDSlNBxhDCdTXmyMpu3SRBvElzmDkHg7VvGJ4iK7Sk6mmC18MN2BZQTV7qLxPt1I5G85pIyWUaLiYHKKfOynsLu/VFWqOYLBZaJO9fkjjIG+2sfAiWs9pArCF/nkXu/CfrcLRsxA+PBQtFKwva0px+I0J+TXtxFk46jq8W1OkndnDlWdu/QZhb7M04dfgAVoDimMR94s6MRSbcgJYYnLH3ARLgOwP/6Q9luWfniaFUrtTw1tMtNu6FlYTlG10IbUlZi+GGFiaVluJibXh89q/72fGHFKw9ENg29/hET4gaTkiU0zOJ4XZR5Odw4P3g2IAUWFxmsxAxekhwmpTkXz3ytkGHoERQx9yWLfGoYh36jwHnKbvRMQY/WFOiP2tc9UUrKJQ7Wuz2Myjw/Q9icbbJUqgQ8t+FH6XBaq9QZmnzzPvSOpDh6lbdJQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ad854b6-917c-4c4b-24c6-08ddc916911a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2025 11:54:51.8071
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UjrZs/8eLMK7kOmRvUrBjl+5NTIEA1qw6OroXrLx4c8+0/ozdp4fszQs+ctxPIZxlviEuwZBps3JB3unVoRw49UN4Z/j1g/Z+ZZlVqTg21Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4192
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-22_02,2025-07-21_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 phishscore=0
 mlxscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507220097
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzIyMDA5NiBTYWx0ZWRfX69hMXeu3PkkE
 LOLrS7Od7IMSlfrln3XSan64zhHiXeo7PgyNhcbdkLyCWfinqT8G0/9SFo+fshnfzeIV2MDXTEW
 +A2y2oL2yih1yufTOd8WWI+3zf45AMynBbB7tyOF1YsGjpQT2vPwD+Sdqq9gxh0O5XpBocFFeKG
 cQI5lVB6Qcvp/klzaApF8JA2vmC0pzzTpYfp8yoZKqfVtsgZVL9vG5tJ3OTTAst8iUIRynYGMiU
 RzGbPW8RVKBn/x496ty/w0F97pXTelbgnkx3fQV9kxF1wPdd/gX4ZX4WcN68/XrQt96rmY8EBBz
 PPMhWUxIjwmO4BWtm1gzXTyVNQX4qR43z8XmAOoqeAR5cd7AwU7mpHu2dEhmJunKRnXG+0J1IW9
 mgWD6//rwv30pEbBcLAWl9bf3AceDN63KuY2Z9+HhP03lWKS2EjLFsLgBtGH8k9EfqGrbpg8
X-Proofpoint-GUID: aMjm-Qtls2HhOfem-cyEbo4ZhMFbYAjt
X-Authority-Analysis: v=2.4 cv=IsYecK/g c=1 sm=1 tr=0 ts=687f7c0f cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=j-S0C_JIks05hnp0aYIA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: aMjm-Qtls2HhOfem-cyEbo4ZhMFbYAjt
X-Rspamd-Queue-Id: D4A9640005
X-Stat-Signature: i4kqy5daf4japzmdhk4od5o1fj35wma6
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753185325-664314
X-HE-Meta: U2FsdGVkX18m3GfONN2SXDcH/vtetQTZm2DnLLGRaxjqYRv+dM4+BN8buN4Xng/BAm6BHONKsKhbirmkmw4HTOjsWiC8TKHcgggAHOZqQftPUpvH7gUX/wPmwxn09rB23aO25o+Zwdr33pUV3b8gatqgUR/9SSR1BFc1kJmYrXjVZbLgOlSjb9BGUV2WCFX4nV0VdSOlcX1pWyR9qd/kDcO91y3tkvVXJczLRCQtEZ3QIPS7kmUyHp/x9G3+hjJ3qKEPZ5GgjGpRuxnpQv2jOk0HFyMNwtMHIDVIabGtC8ayctGVMzJJlF7rWF9/lgy6wAd0HnU8LSfDctrZBH1NwMPYjsN9wpN0D8a02Q2TP6teQiG3ziaqcO3Nc04XGwvnNycKeJ4HWmWt5pjcSSwXxsy2TU2wY3TXl8AcCVNSvgvynru54v3A0U8gcsJ5NkMOGNpOIqU3WXdYKzUUusacSmRCbHmsGxzo6g7Jf8pJzXh/fAoYVLFA/5Z1iOEsJIKGlu2/bpBEHcX0haPRTIiG5+BOFMATop1JnC4hdEtOX2wF/Ozwip0pvqssjeuARH/UduFQksZxxzjr3OEQdQtnxMj/6d0uYjllFmLAgk2iEMG+2yiOsCX6qfGz2kBJMH/r8YyapvfYYfIA+oL+6sgzPF9MldDtl5gpRg7dKZtePhr8O1P3QrP+g7l1VfUz2pWi7Eui9aTuxoU1dYt7oWp2nPZiKzDGhPsHYY7+l2E0ry8jSrBnFl4MJjj/GKGNT5lMjh1NIrXfc8YsBq70DoAWDmdkxIvX09hf2kgAnV91+gv0+9oc2D1mR2jPDehWVRlFzjt2OKwOoQIiwj65qlPUzl3XOa+8IlGN23aQILo7eEOBPfiPcqWHJaoqRDkhQR3QEN5E8BDmk6uIJoTi7f4rxuSBapSZ3cWL4W+QYZL1DaQ0HcC15e/By+hGeiIsnk+RLV9WQJsceYhijPWBt6D
 p7sCthDI
 GPS/OPKQt2FRB9wy0tJEeUQH4XC+9z1/MK2R/uJz8HgjVc6FM7Xm+tLoYFTiceviaS3zsqQqHGbHZgEHdidllG4NCq2tGklPKOf+mcY1TS9HtPm0yN7V7RiA78JYxOMk4HqN6Wdf3XO11RP6V7PiSvY2XtYxZtED9n8auBvHgMZvIpft4DybaI4zzMXccQCKOdmRq2zLnjeyIXh93ECUd02VwGzqFU5K6tELvgCkZdHh0261HvwPpCoElPauYmTh6M39L71vj3XK8L1M+4ZzTq3Ap/bYboid+R3FOSX3gKdk4DKRJ0yg0AKteLNr7mCgZP6pB2h6fL/cyPXfld1eowbaDjcRd9b8xUeevjHZC42y2vmaPJRaaqLasUY3BbR/MsjaG03Z0JtNSnBAUqqjsUeda2b9FlXeIv+iiFpaV2Z+SKFl8SjPBJClhQftr4jiyOuHftEHtJJ3UXGsYRBPR4dmfbUKVJ56YNO3dz680T82UEnBG9Tr+NyN/u5fql+cgL+L8PJrT3k3eMJlAlGeqzBSJjV4xRjUSe0OW25322zMB2ET2MxhlzTy2nVDadfYijoYW9Aq0XGK8FHQcWYCybtH5gzIzDS6LCFUGiSZ0D+cgNvQ0rklU0XKzxiaEHoiEJrMxc1dn5suTx3LYnu/jg4r7JPq6m3wq7tHN9EO5Ud75U/SOlBh67j0XvOmlmqc6oDeYSjUSe6RVHESFyCMyASLKYiUWZNUjOxLZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 22, 2025 at 07:46:57PM +0800, Yafang Shao wrote:
> > So for these kfuncs I want a clear way of expressing "whatever the
> > kfuncs doc says, this here is completely unstable even if widely used"
>
> This statement does not conflict with the BPF kfuncs documentation, as
> it explicitly states:
> "This means they can be thought of as similar to EXPORT_SYMBOL_GPL,
> and can therefore be modified or removed by a maintainer of the
> subsystem they're defined in when deemed necessary."

Except that's not how EXPORT_SYMBOL_GPL() works at all, we can remove at
will and are only required to update in-kernel users.

So that comparison is simply bogus.

>
> There is no question that subsystem maintainers have the authority to
> remove kfuncs. However, the reason I raised the issue of removing

Except the documentation that seems to very strongly suggest otherwise?

> widely used kfuncs is to highlight the recommended practice:
> - First mark the kfunc as KF_DEPRECATED.
> - Remove it in the next development cycle.

This seems reasonable, but I'm not in the slightest confident in us just
relying on this.

>
> While this is not a strict requirement—maintainers can remove kfuncs
> immediately without deprecation—following this guideline helps avoid
> unnecessary disruptions for users.

The documentation doesn't state this, you are surely just inferring it?

>
> --
> Regards
> Yafang

Overall I think we need a different mechanism in addition to this, such as
a very clearly described CONFIG_ option that makes it ABUNDANTLY clear that
the config and thus the related BPF hook may be removed at any time.

Ideally with 'experimental' or such in the name, or perhaps even tainting
the kernel.

We definitely need something better than what this documentation is saying,
sorry. I am not in any way confident in relying no what this document
states.

Cheers, Lorenzo

