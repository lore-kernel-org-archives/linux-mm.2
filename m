Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED224CAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 09:22:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54E5C8E0010; Mon, 15 Sep 2025 05:22:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5257A8E0001; Mon, 15 Sep 2025 05:22:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3ED558E0010; Mon, 15 Sep 2025 05:22:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2638B8E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 05:22:43 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B149E5939E
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 09:22:42 +0000 (UTC)
X-FDA: 83890944564.11.2F27240
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf02.hostedemail.com (Postfix) with ESMTP id 316F280015
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 09:22:38 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=hGb80MtI;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=fzEd+ksN;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf02.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757928159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CXH847GmJkAm9uvI8LKnjmnXO4fnN1ctSgsz+8JZcaA=;
	b=U8ovHNIKjmOXelBU7isIUEFn55VP5z4azB659ed6k4TP5pNTrPN25YWMVo/8aDshFEWU+5
	5x9Av2qc+f5zUR2Exrmp/F09H5+eyxdo6NJE9GrBAeiTtvIIUeu5rn2TvOexovPwUJRQow
	5DEJ9BI1u8mYbCWU49P9HcJgyeG08/E=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757928159; a=rsa-sha256;
	cv=pass;
	b=IRonfRWLd2uMXBnbzyFh8hAsfwrv7afHt6prrSPJ4aEzrE3ctNhomCyJcWI27HJGRS07P0
	kjfnQJ9N/rvd2gLXQsnsqp83oJwnS8ZDLRuUZmIl44BaYUYQ7l+O0dNcyyvRXybqkhtzdu
	EJY3QDTEQOFpSgBXJrjbSfjiOWhFcNo=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=hGb80MtI;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=fzEd+ksN;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf02.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58F6gE6E022095;
	Mon, 15 Sep 2025 09:22:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=CXH847GmJkAm9uvI8LKnjmnXO4fnN1ctSgsz+8JZcaA=; b=
	hGb80MtI1O74lD4edObVNsd7MluRi4ZfQz8cbqFIxTtN9i410WHzcwIHqKdgFD0f
	JfUl3CF5TKINGyr1nmT8Z1OP7VVkVroZDGIWxSrIYuBbaa9KemWZJbNUqYkeh79L
	FjpOXe0q6P3TEaebnFmTk8oSqaqtc7b+971Uj0TPfRyHQ7Mo3hLSLJ8KGMkmr6ta
	0ToVGbIlDnsEHJwtPlDGmIyD9O2gmMYbmOvNMn0ac6JtO6LF6NLlATPKOg2/z0PA
	sOTJbzSx6YyzN+MzadCr2dyOTTgAllHWzRfn+vDjIR+Hi5Qnr6U39kwVtt+efTIt
	JJQTSOoASiQJO7COK0qpZQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 494yhd1ywj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Sep 2025 09:22:31 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58F867sh037330;
	Mon, 15 Sep 2025 09:22:29 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010002.outbound.protection.outlook.com [52.101.193.2])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 494y2h1hya-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Sep 2025 09:22:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dih+0FrQZVVi9rAjVnjs7+iQK2CqD/lICWc6R6ARyWOIy3opHzcViYhArNDMbuZOFmI9J/vQ1Os1A5RqBiIrKPjicaKg+2BqgUGFN2p4rfEKQIHVesoc0/qxmV0T6gVkA6ZJqPQwysTm8cBgFeSMINEapOC12ngdygQ59IHjfIhBIbpfefH4XIArBTA5h3e/adyvW5m3k+tYtnE2NF6yZU4VWytAtrgsonIkuqqZdtO1JvkLHUe11yVg4iaylI1hbV+o+aBrjo/pRsib8yyf/tr0OBR5h8ES9hcqsqHWATusG8t1ig/xsiLb+iWdTnjrfOUvxL1daKBW7CLxdtukkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CXH847GmJkAm9uvI8LKnjmnXO4fnN1ctSgsz+8JZcaA=;
 b=BNiqMi25YRSWzYGpNLdmSuleHMFX5C6W1Q3fypKVTskuKrPPd/k5vOHBb2/u2ZZ66akEoBi8Nf5pXSmgC6jiXHGiq3BPAa9hICZVyRvrc9w3jaTxEp6Ug+S7r47dbbNE1SQY+Bqzg+FlCUcNjadjvfzugQc5ksRaGgbkRiA8Up/64AeUVLWoGbSl3WiZDrpOWFK2RiroDO9cPszGbROycSd4WpXjK8IduGV3O3Dpu/+GPGy/+gBO0bQcZTzh8ZVaUenqJGczGJih8bSKnOvwdb22DQkKHeOiw+CL+XVZzSfzUKJ3/4jWnIbwcWsmGgl+CjpqJzU1nwiuDIfmpG3+Wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CXH847GmJkAm9uvI8LKnjmnXO4fnN1ctSgsz+8JZcaA=;
 b=fzEd+ksNl4R+/7y5WhB06uuqSf3Ix/3qwgh0uSKlizWpQ3L4nfb5Pb2YcohHKtp4KRpvMjeE9NnIlCJBgdwO0WT+n+HJ5LMEOzBljHBd9qwAoYdZMZfQcpL1RZFh0phF9rtFL2Ga8JYS/s3K2Txf4jgZecLJ+TC3uiBttl1vQ4Y=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SJ0PR10MB4798.namprd10.prod.outlook.com (2603:10b6:a03:2df::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.19; Mon, 15 Sep
 2025 09:22:27 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9115.020; Mon, 15 Sep 2025
 09:22:27 +0000
Date: Mon, 15 Sep 2025 10:22:25 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: Barry Song <21cnbao@gmail.com>, Nicolas Geoffray <ngeoffray@google.com>,
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
Message-ID: <b6d5c607-a9d9-4c1b-b4ac-41fcaa2e696d@lucifer.local>
References: <CAGsJ_4x=YsQR=nNcHA-q=0vg0b7ok=81C_qQqKmoJ+BZ+HVduQ@mail.gmail.com>
 <aMdVcH7KCXBvLtFP@casper.infradead.org>
 <CAGsJ_4xDRB_F-T42WnhqpmwLyiZRwLGqx9vDf_d5TFALsCRX4A@mail.gmail.com>
 <aMd-2argDQCHww_Q@casper.infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aMd-2argDQCHww_Q@casper.infradead.org>
X-ClientProxiedBy: LO4P123CA0121.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:192::18) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SJ0PR10MB4798:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b4e8d9c-f76d-471c-aa0d-08ddf439633d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Q0hGMEpaR2dneWRPVGZYYjhjOCtTeHJ3dWNuK2JrNHUrc2VGOFVvZEhEOVIz?=
 =?utf-8?B?SlY1YU9QU2pTTlVXUE90U0c0aDludDBldzBWNGtTMmZnd1h4bjhENW90M3lO?=
 =?utf-8?B?Q1l6WSsySlZ4ZEtJM1M5aHdiaXhRMGRIRGxsWkFjV1NXeHJpckFsNmxpNk5u?=
 =?utf-8?B?QjU1SDd3SzR6SFVHdjJKVDZkNmhUbGlqejkzQ29kdW9TdG5CZzkvQmtLTTFQ?=
 =?utf-8?B?cFJmVnhXSWlqQWoxSUF2SmlENVZ0YmxUNUV4YzVZNkkwdzRyWXljazBSdlcy?=
 =?utf-8?B?S1VYOHhrOEh3UjRienZWaXFqdUpnei81eWU5Z0Z2MUxQQUF4cWJ3MHBhUjNW?=
 =?utf-8?B?eUJneDF5V09TS0ljOVFzVzBoUThPTG9xTEN6MnpXVlQvcTJhbEtJaXptemxx?=
 =?utf-8?B?OW4vNXk4NGhNS2FYMy9VVS9IUkJJQzZNZ3Zub1JGeitnSkFvT0JsWER6NW1j?=
 =?utf-8?B?elpOQWZ3K05TNkIvZkFhT2RqM2NBZVY0bjhqczVsMWRPc3RieDhOWVhGTHVE?=
 =?utf-8?B?VWtTYk1VTzJXR1JEa0Z1cThQUTVRVDZvU1lvcGl5cVVQRzh1ZXZlYjc0SlZu?=
 =?utf-8?B?bTVtbk4weXVPdGo0d04zaDV2b0J3cTVtMnh6ZzR1eVpFZE15Tkg0RU1yQ2lF?=
 =?utf-8?B?MUVQSFA3WjB4bExZZVZPNVZoMXFZdTdHRnkvNk5YcEEzdU80eTFETUNhUDk5?=
 =?utf-8?B?NExDYlh0ZExCYTRUbkV0TW5waXVuU0VYTFdDUzhlWnB5NmFQejI2YVZsaUgy?=
 =?utf-8?B?L1Z1Sk5ueVFBcHdOMVFURlRNNHVWdFN1RC94aGlQeWI0QmlublhpcW1xbVZs?=
 =?utf-8?B?anN3YmlvL3A1NGF5SmVNVlNMeUQwUXN3TGVmdEt0dXh3ditHaE40TkVRVE9P?=
 =?utf-8?B?cEpjc2NoKytTNncyNnFHb0lXaUNJZVB6emc1RVFLRlpGY0thazRmRTUrNzNS?=
 =?utf-8?B?MXNjbUgvU0Z6UzU5TkMyQUlPUTFxd3JaNFUyZW9PUUE4THlXZXlXUVp3Mkts?=
 =?utf-8?B?YjlWZFNxSkR6cGlibW91VkM4YXpXTzhqWGlZUDQ5MWQ5Q2hKUGtxMUsrUzNm?=
 =?utf-8?B?OEhLM3U2eVp1SFdkR0RVcHR0MUV3WHFlam4xeVNTdTdVTkQ5YUorQlJ4RjRL?=
 =?utf-8?B?MXBYUjBRbVd2czRaRmV4THNSL0lheWR3a1ZpL0JmYnpva3FEcnlUVXlaQ2JP?=
 =?utf-8?B?OTdDV1l2Q1Qxd2JtcDkySk1ydnNIbXcvMjcwdVV0TzNId3dTWVdFcGNzVlpL?=
 =?utf-8?B?eWYvSUc2bGc3U1ZVR21uejVWTTJ6eWhxdHRmTnk2am8wZklzejVHWmtsTlVk?=
 =?utf-8?B?amZOUGM2czNhdlk5L2VTanR6MVZBQ0dHeXpWdlpmd2IyY0FqVHBuQnVFSFpI?=
 =?utf-8?B?NkNpbXI3cnpEOXFFS1ExMVN0Z1A5UGFIbER0TmRnVS90K0kySTNCbGgvaXdD?=
 =?utf-8?B?d1ZKTXgwMTBKREhndnV5Q2VtTG16V3pPQ0pubFQxSitvTjkxZ3hUcGVkTnFI?=
 =?utf-8?B?NmcvbW5KYlM1YUtUMDI2dXZLRjUyK3Z5OHprY1Rvd0lSSHBsbWd1TWMwZWVi?=
 =?utf-8?B?V3dZd05sMWJjSW1tUEsyTFBTeDF5Z3RiS1dDSis1RkpjQUk5THNPemJ6REZR?=
 =?utf-8?B?bWx1Sk1lcUpVQ3h2ak5hcWI2cEw1ZFZVQVlLRnA4bm1HMlZ6bmRKVUcybEVD?=
 =?utf-8?B?K2pITVd0SnppZG1KaGxtUFFVUTY2UVhyUUw3ci9OUG1tUzN1OEUrNzk0Q0p4?=
 =?utf-8?B?bDVTVEF6dHBnaE5ZSWJQTEhSUWpQbFVZbC82aGJSbTRTZ3hhdU5qbkxFQSts?=
 =?utf-8?B?UFNOaGZ5c29rOFZQdnVEQ3B6NXhZTllET3l0Yko5eFJMc0E1SWk0SlowcXlO?=
 =?utf-8?B?bklNQ0pSdDU1RHFkSVFKRHh5cDJNWllBR0Z4aUFTelBiTnlENDZxMWs2KzM5?=
 =?utf-8?Q?RWUGIWHx4fk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?L1VVNXA2WW9IV1NYN0ZEdU9ORmJxeXRiZGo3K0pMQVVHbVJ4Vk1GSElOZnQ1?=
 =?utf-8?B?UFRQZi9JUU8za2orb0NRZzVPWUtHY3ZxUVozNUxSZnN3MjVlL0dDUEk1b0Nq?=
 =?utf-8?B?V3dpekh6T05rNXhtcmlreE9rUGJIdkNNdDJGcU1xMTNUL0EyN1I1SmhnSW9T?=
 =?utf-8?B?UkEvajJkSHNidG9Sb1FMdWdIdHpWNFNGWk1sMTNQOThocldvbCt6QzFHdCtO?=
 =?utf-8?B?ZFZaeDBHTUVQWmJtTTNKaWRkUVdrTXRzK29UV2dBeXFYNXhLaytvOVY1TzFz?=
 =?utf-8?B?VEhnaXFnLzRQQ01RV1VLbkh0Um9hTVZOSWNEWEZkb0V5T1c0aVJrMGsvM2gx?=
 =?utf-8?B?UnhCZVRuZ1JHbjdJdEVwb0poVEhUVG5JWW1QT0dOSE9VUWhMS21sWHF5ektM?=
 =?utf-8?B?ektMOVdDM1R4Z1R5TjZ1eStJOU5VbWdQN2hZcHNsUDBpY21mSkFJa1RKYlJC?=
 =?utf-8?B?OVl2NWw2Z3p2MzkrZ3AvVCtFOWFJKzI4NW1wZFphZFB5ZWxhQ1N0OVJ6VktS?=
 =?utf-8?B?NThDTng5aG5xNVd6OWNCU094RkRiVXRaQ1YzQW1ITzY2THFrdVk4VE44UDEz?=
 =?utf-8?B?QmZ6dVoyZkNLYlNXMGV2MjgxT1E1SUlPdmJTN0N0SDFQM0NDT2xHajhEMVZy?=
 =?utf-8?B?MEswazUwV0ZCR1RQb3BrMlNQRk4zYWJxRHREVUNFaWxWcUI0MCtsZlB1VFFH?=
 =?utf-8?B?TUVMZGwwOUlINXBMc3lBaHpSRjBsNk5scFgvUkhWL29FT0VrNkdNeWgreWt5?=
 =?utf-8?B?cEtiREh5dUFOWndjb3FWUEdSQjE2ZWdBTDBKZGJFR2dnMVdoWnlIZkh0UVA3?=
 =?utf-8?B?OW9QWklTblZlYVMrK0N3cmRnZndka2t6T1ZpMmhxWnUvVERoeEw5K092cVcz?=
 =?utf-8?B?TDByU1NpSDZHMGFwWThXR1IrVVRoYkE0ZVl6ZjlsOG4yZVJ1NkdGY2lRcVA0?=
 =?utf-8?B?N2tjRTVDbm5LamgzZXpNZ3dEcVhRekJCOWtKV2dJdUpUckFiaEdCS0dCRHQr?=
 =?utf-8?B?Q1NTYXZ0MUVFZngvMThYaHlvN0NJU0NBTXRZNFRHVlRuamN4OFlXeDJkbFdH?=
 =?utf-8?B?ajcwRTdlYmJEMVp1c3VUdEhHanlmdWVWSVpRSTQvNEZSYnZzZ2pzRzMrVDRX?=
 =?utf-8?B?S3puN08vRU14Sk5BN0UvOGJlR21aRzV4U1M1UUEyVlFZOXBveURBYUR2RWww?=
 =?utf-8?B?VzRSTHFqSnBUdFoyRzc0TkhrQ0dSeU0vTmdlTW9lZWRPTVZhdkg2VkhiSDZ3?=
 =?utf-8?B?bndoR3ZsRjVDTVFzd1hqNU9JaXAzU3dsVEtOSWhXUUwzSnBhVU9nV1FvdFo5?=
 =?utf-8?B?QTdpdHVHSllyaVgwc0IzYnNXdDRiQjRVczZsZFc4OWdFNDRZYnhNcGRhVmFZ?=
 =?utf-8?B?a0lucnRENFhXWXdYbG5NZGFoVmQ0alUweHVSRy9FMUsxL000QzJiR3pUbUU1?=
 =?utf-8?B?VzdoOTJuSHd6a1NWV3RQNm9SMHJxdEp3ODk3ZWdyVFhFeldzUkVGWHVaanho?=
 =?utf-8?B?S0Z1WlpYL0xTL3B3ZlMzdUFHcXY5VkMvZU5ESUQwRmo1N0J0WDRxWmJHVEtr?=
 =?utf-8?B?UXVwbDVxbi8yTjJ4cjJ6WnF2bS9ZWlVIZXQrQ0FFcVljbmEzWFpkWWtkMUR0?=
 =?utf-8?B?bVVBdTNscHVFdTBZandpU1RBTi9PLzBCNG9pOXFPekgwU0lwTnkxT0dvYWR4?=
 =?utf-8?B?ekdCaEhObVp3a3RkdmVZTmtyVjRRU2M0SGErTGZTRlFXN2hWRGxoMFQwc0c2?=
 =?utf-8?B?ZEZaUSt5VGplT3NGRWc4MWQ1ZXdaSUJQaTZ3WjZNS3Z2R3FyclZUcVB2ZDV5?=
 =?utf-8?B?aFVkNUYwcWNYdStSTFQ5RzhoZ1E5VnFXUkd3VFQwOHBSZGdMUmdjamR5bjNM?=
 =?utf-8?B?bTRiUjJzWFJ4cFozMlNUdDcrbTBKSFFvQWxPejE3Z1dlcWJOTVkyalVTWlpY?=
 =?utf-8?B?WktHZXBMc2J5NlZySTVzV1NKWU4rZDN2dnNvVW5xZ1lPMlFzY1QzdWd0OU12?=
 =?utf-8?B?L2dUbXh2REFJcFRKWXRZQnFxVDJWVzZQT2dGRTB6dGliMWNraFNORTJQRGts?=
 =?utf-8?B?MjZORzNvLzFtRjJNVFErbE1tSHQvT2dyeWJzclpSVVFGYXBNTC9ObmtkNGZw?=
 =?utf-8?B?S05QY3RCN2M3MlJRQzRFOVkzcjJKcHNFTUxEQ1E2WmpUYUN0RThnY1FFNmlO?=
 =?utf-8?B?eXc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	LH9jJhHP1nJ8PXYrWbXOVMMCWNE6ZXF0beYb8MldB1peohYlGyHcCKUevZqzS/7W0HHpfXx47r2F2TqoMl+H42MEO2B9TdEor/0fDtVYHoV/R5IIwOdm+jY/aUZhveRhJkrP4Wb51+kqXrpTJtP2Dh9dhJyVt8+UBIt+755/ZxKfIe4fThQjptYZj2eOeTAi5u5ruPnMlobQEnsH7CSz3fV3rz/mbsylaVaMdaSoFCpWKDxaFt+DDxIwQK3QqZY0x6xHUU4VS8SxP3dJQWSfBu+wxf8UyQiL6+aw9ckEsfG1XC0fK8C/p6sDLSdUtyG0VxdypsDTZm1uu0t64XVIY8lWEr4YWa+lTM8lNnI/njLU1+xwiWYi3IWsVxUD5fv4AEDWxUc1DMt67GY1SRuTMQKRobSqNK/Gqj+U4vSGNs5jLc81kGk7S3J3nLNBbqry/a2DMqAvvL6XDcx4Ppm/0g+1mI3soef0AN9IaPsBKDbAN0l03a5dau+1Xd3d6tBd76oBazCSJ57Lk+63G43EHAGBWpSfrQ1SJdLkUR3ou4Los1XWVdI/N6LiPWKZKyL3JpmLhKxwwnYPdBexCsEjUCWH6T/ui51fKTXF0itugWU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b4e8d9c-f76d-471c-aa0d-08ddf439633d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2025 09:22:27.3490
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2/eR4JRf+U1sdhxKwjKwH7UUXwwjlgsqMZMs/TJe7ng5HCWNAsLYJcg4srYA1zrd9LzeijB2XhBuH0D8X/AV/q5uUye8/EHpNeC29bwxVm8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4798
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-15_03,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0
 mlxlogscore=999 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509150086
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTEzMDAxOCBTYWx0ZWRfXzlcfa5mqIoci
 8gZFHVJIV5oABiCKnp+KQge19zCJAIfEoPwWmhtXbQA0kVTpE+ehxOjsukhsFzRL4vfbmjhIdZe
 pPpQ3s+Ovso+J3c0UWo4mABb6az7jwj73qlxlnDu4qJP+c9QOhO+fJBye5Tqv4M9Q7LM1kkfJPi
 jdtDVqEZOZraewgnuMrFwG8QCviieL1/Pzrh/QDN1i0EtQ9nt8CYwNvNfwu69dy2gecdTwtpaxK
 +7RIHGPiFI8DI66QmPpb7iCxJ4FjcVQpe5DFbZpJ7K/Y+3JJyL7qT4onETaQdSRVuhKsyQ/s0t8
 AkxQQSN8Z+I6XAqadxfSZoUyVpDLaCHd5l2fpeKQ81TAmpgahZHRQabQQMywJQBEos1c4jM7npp
 39ZTpVDxUkiw5EPGWrrW15WpsicOJw==
X-Proofpoint-ORIG-GUID: _8mj-LyF8jHEtbNCQGVOTgDCfjGT2bLj
X-Authority-Analysis: v=2.4 cv=YKafyQGx c=1 sm=1 tr=0 ts=68c7dad7 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=M4Qiht9OTxDcbRzhX8wA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12083
X-Proofpoint-GUID: _8mj-LyF8jHEtbNCQGVOTgDCfjGT2bLj
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 316F280015
X-Stat-Signature: ef3md7bf1dyc5sqca16btgms73yrqrtd
X-Rspam-User: 
X-HE-Tag: 1757928158-889695
X-HE-Meta: U2FsdGVkX1/6SOf75mNNYiHXiUVT5Fh6iBC5Ja0t5fS3+DHo2di8HZY18cDfez7/xL5QnQcsyXNAxi52j8Q2YCvUr6O1+4F/WeJ0JW87+uNz4h9MI8q8qvSrR4ElDYvEleWzlmqVMn52ANWMUOjO/fJuIKL6PCv1eNliS5ZQOK2mV1287yFnyxI65z8X9Zp13+CNkj2nf1sD3w6GmQKyJTn00M/8o1y2E+KTbsRTrQnWsVQeBqI7wGY+rxfkyqiEXi+qpVvXAcmrtTCdXliZTtOdxECPxYMVufYkD10u1S4Sb2GCCctO5x0URw2jRVWPVJdi0kYqqgayJa74S2r7QwDhHu0oLzbSS+imM4sihnRvTcwfTOfsZWDVFdFjsVimpQFcPkkpAUoqLwrRIHdWZfhnI5CGj92KKyrq8mL0o1DwashfClsrw6ua0pQQtk4FxkkxVO1IlipqppsAInEG6N+uN984zdkXmky26gfo7g+x1I+vXIo2mBur0Cx4/PpdhYzijR5PM4sysohjRweRP0/oH/ZCxswNz+Rs0/gmdT9IW2NT9G7t8pYhY1adwOuJuqGpNcZ+PMvgp9MDHRba8zEp8QUwDBrhc8kgZoMuwBwjxqcdJp/3iW7H4bCh9YePiJjM2JPAe7qRI1Hb/+dcFuJYsDw4cpkOpaFN4efLTiSXS077X52QZrLd6QbcVpSsQWDQe5Wq3GKojBjsrCqhO7FAarMgizD6kf+b/2zBayKCdXYj+Ic+nyaAnygSXOvT7VvaAHGrqX3h3liUJ965u2MiY/2GLSnlm0QUscabjVpShmLqcS9s1scebQabeVeHG/W1X9WJKjqE4B6+aHoneEzZzOIE7Jy0nkRn1fYDR3ik/wolroK5MIVVbUDxOi+3vvLQr6v2u7sje9FZgpvsvD0y1tnjhZ7aWcNNwAd7IjFiz5fOlgQUPd7aQtWeRPUI0XtjAPyoTK4psnCzATR
 e1Pyz/8q
 WqK7KUwGViUsXrIfS0yl7Kjg4x2+aKSUqYWOVarqyF/T17WwjbmyQvDyOsZ6uTEMVgS+uCIB4Q/eBAkSmHbzbMv6nuBBOP7/jc6qs3O5coLJ6xu9kg98XcGE73ALas97nyNIltcFC3+Z3WD4XWCYIe3mBGr6dbgUQLMMEzLEW3qITKQ3CLvFKX5ETBdtcLFDfRO7paGTccAhT4mu52j5z1+hKpfeFfOfL9ZJutbOiagq4LiV3TBvl5uxwgv1CNMnr1a06X68LJJJl+ZopfVBRlwLBPZEqP6CD34wu79IpGxXXyfBd06cJtCJ/2G1v46hlL9e9unsqqnc1u04V38qKT5aKBDqHjChJwdOhJzVsx2P25nKge/F+Ex7/R7/PSG/RHyQD2kqoGiyQtJ+Fmt+dTaayoYApugfFcWOfuBHTD0Z07ZDauggbBBWN7oZPv1TwgEvCGKVUG5RdDAI/AQRi2/5qPSrjA8F01UDGyAfkCuYPcyUf5Ej5D2rERAQLl4NiwUqPrZF2oKWDf0LLw6CM7QftMySvILEkziTDCgT26/CfISOHR4WpaHTGwuyQ7XlZ6d670fSe8IuD9aczilNVedGWl563SZZCE0c45mBExpEVwmc5DoWUH3xmxOLyLOaYfKc1KjE9PUNKUfskRWRyQ8mF52Jr5UG8xFLpfcLWZRI2WwxGHXLbhFs9+yPrjd6SKGGy3U3r6BaEpsjREIXNqTMrJ7+wJAd1jzWy8X3egkmFwObD7rWTbx9j3bP4+3KZ/OtOA837MdZSbu1XugD7meIK1ty8Dax9Omts
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 15, 2025 at 03:50:01AM +0100, Matthew Wilcox wrote:
> On Mon, Sep 15, 2025 at 08:23:38AM +0800, Barry Song wrote:
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
>
> I'm concerned that tracking how many folios remain shared may be
> inefficient.  Also that information needs to be gathered in both parent
> and child.

Yeah I think you would need to track parent + child which is just _lovely_
isn't it.

I'm really not in love with the overwrought structure of anon_vma's in general,
we've made life hard for ourselve and tacked on a bunch of complexity.

Again, I think "Lorenzo's grand rework" could help tackle this from a
fundamnetal basis (don't ask me for too many details just yet :P)

This also gets potentially complicated with the anon_vma reuse logic too.

It's about RoI.

Again, the more I look at this, the more I feel that the whole thing needs
rearchitecture.

>
> > You seem to be proposing a forced CoW as a way to safely unlink from the root.
> >
> > A side effect is the potential for sudden, heavy memory allocation,
> > whereas CoW lets asynchronous tasks such as kswap work concurrently.
>
> Perhaps you could help us out with some stats on that -- how much
> anonymous memory starts out shared between the zygote and a newly
> spawned process?

Yes stats are good!

>
> > Another issue is the extra memory use from folios that could have been
> > shared but aren’t—likely minor on Android, since only a small portion
> > of memory is actually shared, based on our observations.
> >
> > Calling mremap for each VMA might be difficult. Something applied to the
> > whole process could be more practical—similar to exec, but only
> > performing CoW and unlinking the anon_vma root.
>
> That seems like it would be worse for memory consumption than doing it
> on the VMAs in question.

Yes!

Surely the whole point of using the zygote is to take advantage of CoW no?
It'd surely hugely slow down establishing a new process if we did this
per-process?

>
> Another possibility would be for the zygote to set a flag on the VMA,
> say EAGER_COW which forces a COW of all pages as soon as the first one
> is COWed.  But then we're paying at fault time rather than in a syscall
> that we can predict.

I assume you mean write fault.

How would we identify which folios to CoW at fault time (other than the one
we are write faulting on)? There's no way to go from anon_vma to folios
without doing a full rmap traversal to the the VMA then back down again to
page tables, so that'd make this pretty damn expensive surely?

And we'd need to hold some kind of lock at that point...

Also again I wonder how easy it will be to identify which VMAs you're happy
to make expensive like this?

Also you will end up fragmenting VMAs potentially doing this.

I think it's a sort of nice idea fundamentally, but the cost is likely to
be high and it will add a bunch of complexity.

>
> Another point in favour of COW_NOW or EAGER_COW is that we can choose to
> allocate folios of the appropriate size at that time.  Unless something's
> changed, I think we always COW individual pages rather than multiple
> pages at once.
>

I don't think there's any practical way to do it any differently because
you don't know what's mapped/not at the point of fault.

How expensive would it be to have xarray for anon, I wonder... :)

