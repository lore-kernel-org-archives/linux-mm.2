Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BA43CA0EC4
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 15:48:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C3848E0076; Mon, 11 Aug 2025 11:48:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09B9E8E0060; Mon, 11 Aug 2025 11:48:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA4AF8E0076; Mon, 11 Aug 2025 11:48:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D7A068E0060
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 11:48:56 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5F9F41A021D
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 15:48:56 +0000 (UTC)
X-FDA: 83764909872.18.1B20E7D
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9863C10000F
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 15:48:52 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=bo98tDVL;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=TYOvD050;
	spf=pass (imf14.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754927333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0riQ7lLmjx8o117pHw/pyZyvx1R9J9DVFvMazq/0OSQ=;
	b=1evfFIykQu0vWKXDckvHr7ERNgwlhlixsNrgykmuO9dTCZSs2i6L/vcGTnajy5/vnd8YB0
	q0OVuRi7h6vjXU3VwmOGXaovPShptWN4qVSWy3McF4wj7mOHjULmTx7tDthpLj86S1aYB9
	niPFxxuNGTPUlKGQDqDXLx8QRs+donQ=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=bo98tDVL;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=TYOvD050;
	spf=pass (imf14.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754927333; a=rsa-sha256;
	cv=pass;
	b=OaZig4eqw2CcZC7Y0daRe8wK2aQY0Nll1gNAfbbTeUWFScKLkLec5SFk1wCQTISKiBLyzq
	cMX9227CRK8S8mhXS3iifYoYIEhTKcL/deLknGLTrfeGPeg6ZIokh5zWM7EoakO5kQTCI8
	/aQtv5pZGu+7FwrycaGVcJz2+GcTKSM=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57BFN5U2030719;
	Mon, 11 Aug 2025 15:48:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=0riQ7lLmjx8o117pHw
	/pyZyvx1R9J9DVFvMazq/0OSQ=; b=bo98tDVL/yNwWC89C1gBSpe34CF7RS21dQ
	s2FWaYzxLXF4fzFAohaPGmk6ykCGMxQEORjfTvr+w92mtWoyP5d7Buc1f/PzBcXX
	aXjit4xSw1TioLukT37p/Bgr9AC7sT+nGJNs9RyfJ+Ep1J9+Fp/MZHE4ld+ds6wK
	SVgprtsFilBAh1serPkpefWlGrvz5D6SF30QtZJJxzuV9Th4+Txv6+UPatnTTgPf
	6PDrQOb5ozcB+5WD9gg4QIxBqfGmL6fB50Xhm7puiLegf1OpZm1szJON0Z37PoIj
	Ge+Qhq1x31bZLVsWq1Pk+xPGJEglKa/pg51ejmArWXEK6TVTukEA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48dvx4ax54-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 Aug 2025 15:48:36 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57BFL91r006562;
	Mon, 11 Aug 2025 15:48:35 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11on2081.outbound.protection.outlook.com [40.107.220.81])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48dvs8k0kc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 Aug 2025 15:48:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZtDmK97Lc5PXnKk+/9JdDWFEXixwcvm9xYS4id2qijltzfcxEePpG1Xsy4ZMfgDA/ZTdWOlZgQgCj6NB+vKWPRbhJCmpYaErICsm1hLzUH238Kqr0hHsZm2J70s+ohPpSq8lYk7iGuowGJmZhYvRQ9yaB4WCoi4e1Gv6/VN+iS1jEDC7SCVU57Df58z0P32501m5JeAsczK2GCDKqnitYxqywS+3kkCz+bJE8e6n332V43o6sx8f3s8dwhPGYcq3qwGk37qeLnSUc4UTSBYnTb9gJL6BLQwy/eXyr6xgFt/5Yb0LPrTbCLovl0uq2dLCPTytxB7rZDVP87OtacuSPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0riQ7lLmjx8o117pHw/pyZyvx1R9J9DVFvMazq/0OSQ=;
 b=bhy2EBE/ju4CM4h3RoESNbFsNKfMzdS2So72vfmNouxcC7Hi7beE3fCEFKT297OXPHBHww+cJo19ZXWZ+uYDKZkb8RboXhUc4dg6rBjwWETNaK1GHeOmOxt9pCLRGsTpZaQq7fCahuOD9dWexhNJHIUkCSzGWdRhhkj3S65SyYrcyBfeL+a3YmoYg7uifPx24EeVho+liD7pDTWR97ZP9tBI8hKWzCMPFVxNCwvN0h/Kv+4OVo/pk7rXnxHbPXwv0ABveNDxezTup5vNfu4KDedkL0yQjLg78SX5IxXJJ61gRS4pMSMXlacvguU8/tQOqjvKhAsf7aedL05048tp0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0riQ7lLmjx8o117pHw/pyZyvx1R9J9DVFvMazq/0OSQ=;
 b=TYOvD050ZQwQP6gwejhY0FOJpZH+7acnsH6UVGMfC97S7Xlk8DCIvJ4YTUlvbhky+B2gR7OErmZesq64yq0BM0ULYraaWENKFMdpM6Sige+U5evW3sIF7HTEvVInW3KUSzZ+u3yVa37JTZDphnXkbxwz/lZhDo3ZlD7iIz3DFMw=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by PH0PR10MB6434.namprd10.prod.outlook.com (2603:10b6:510:21c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.22; Mon, 11 Aug
 2025 15:48:31 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9009.018; Mon, 11 Aug 2025
 15:48:30 +0000
Date: Mon, 11 Aug 2025 11:48:27 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Charan Teja Kalla <quic_charante@quicinc.com>,
        akpm@linux-foundation.org, shikemeng@huaweicloud.com,
        kasong@tencent.com, nphamcs@gmail.com, bhe@redhat.com,
        baohua@kernel.org, chrisl@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH] mm: swap: check for xa_zero_entry() on vma in swapoff
 path
Message-ID: <nnuncvxj3p7zszgojgst4z5dv3mn3xkfymty33x3rwzopr4ecv@mev6cvnkr2wy>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Charan Teja Kalla <quic_charante@quicinc.com>, akpm@linux-foundation.org, shikemeng@huaweicloud.com, 
	kasong@tencent.com, nphamcs@gmail.com, bhe@redhat.com, baohua@kernel.org, 
	chrisl@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Matthew Wilcox <willy@infradead.org>
References: <dedf7436-9afa-47f6-b676-88f2dd8b638b@redhat.com>
 <f008107a-2741-476d-9e32-ae9fc0f81838@redhat.com>
 <29e080fd-5f9a-4760-876a-a6ccef33129f@quicinc.com>
 <fec5ad61-7caf-4076-ba81-7b454ec7018d@lucifer.local>
 <9178bf98-2ea7-4ad8-ad43-cdcc02ab863d@redhat.com>
 <904f85d0-acd6-4f47-ab45-fbf18b80f1c6@lucifer.local>
 <7e7bfd05-434c-40b7-98ec-8ce352a8147d@redhat.com>
 <fd35dd5d-95cc-4c37-bf72-52a27fe822ac@lucifer.local>
 <efe3aogdw5wxsn46xyy2rrqui7oghyi7elam7aiv3c6o6hsfbx@ee6dayztcy2x>
 <2e8df53b-d953-43fb-9c69-7d7d60e95c9a@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2e8df53b-d953-43fb-9c69-7d7d60e95c9a@redhat.com>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YT4PR01CA0385.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:108::24) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|PH0PR10MB6434:EE_
X-MS-Office365-Filtering-Correlation-Id: a3675692-3a34-4215-5d62-08ddd8ee853d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/eETES1GJkdSXeIlpGCC0ys2MyDcNJ0m4MbLCsIVgmAozio3CeDFrDYYfxAy?=
 =?us-ascii?Q?gz/LoHBb4tUeZoLcu21c6bN0ose2AFrPP0Ktl5sMj/hPBNrmLV3h7UabH98J?=
 =?us-ascii?Q?FJ09NeLEiSnoLuca5vY49P3Jnl3Rlx9HrMQF4nXFp66q/rBO7noSZ7lxk2qh?=
 =?us-ascii?Q?ZSsRdLms32D5Nr1rHZy2myF5Dy8xM5j7O608fhQr3YvQCYjr7srHWkHDjITx?=
 =?us-ascii?Q?+bHW4gn+bJXCL1gvzQsdc//zb2B6BDDsyDwsWem49cb9cYUqDJh8953hWq87?=
 =?us-ascii?Q?TbYfY81kFNcSkP2/H6eqkya6WAqVNpjoLLQ+8I/ZvAL1qFXru71daBU0gAgY?=
 =?us-ascii?Q?LX6mafrDAETnSlYXdJdZ3eeAsABj9r6DosHdNTj7FDbzzCpswhpw1xD7r2Ik?=
 =?us-ascii?Q?3b/tP7QShk+ulRU6LKlnH9iYkVDldMc3de1U+hKmnU+5fZhHoVzzLlmx3yMO?=
 =?us-ascii?Q?YUy4BubetL6DFnqf5TPaQR44cn2YEqp+Xo2WA9B7KqbUhQyBbz1dpxMUclZT?=
 =?us-ascii?Q?ZTxMjz/hxf8xmLjqVmm4KRnI2rQUHiKxYTtypWH+apCRIU2eZD4cIonN5JUW?=
 =?us-ascii?Q?7HXhdN0vLOFCuRWSGEG4eXbbq6bSmOX5nn4L52VOuIW1zh16gBQVozEHWbO3?=
 =?us-ascii?Q?rNHTWXIUhbIEiSS5X/2bi3kUxxj8HnvJ5ZjFt/DLID203ixNM3E8mJ1aYIEN?=
 =?us-ascii?Q?zcQ7Fpe/31uHIISBAjNti+aUoXfzJzy8cRtow/OHOtSV321inQ5g7wsZts6Z?=
 =?us-ascii?Q?dBD6dQwgYsnMn7esKnazczPr7097uKRePS/yXS7ttnBWfpI2DWaVNHET43CG?=
 =?us-ascii?Q?xeNqpSnw009WlH2YCiVdwPrSrLrofHNm3SJxd8PKTJ/aKxzF9YrxyulzuJOc?=
 =?us-ascii?Q?HoenIKzUHIINhjz/nD4eh9TtrnkBU51+9exqoTQa28/k31qTzXiRUYJVgBza?=
 =?us-ascii?Q?zWrtSlg0iaG6chsxqE0B+AuQL/+47lia456b9enV7U4GNARVGxYDdiCTsE/t?=
 =?us-ascii?Q?Szpn3KtVzuAokNdBBKcYbfw2lg5OERHRyfmuCTWmu4I1A59cQKIqIZBeJgUp?=
 =?us-ascii?Q?LPpcoEoeYeF6hJlh37DT7uBdviB7IKbU++I2AGowHy93o8UKKthWFujRR2NZ?=
 =?us-ascii?Q?rDr+39cEGlaLySLZ1g4/+vs99BUIik0v/1F5LZW475Idn4kAoUzsJHxVWpRH?=
 =?us-ascii?Q?DZ//Clm2vADBEWtz1RfzaaKzT+ZRP5kQb+qc+e3wwLltfptB5s0+FljUuwDH?=
 =?us-ascii?Q?qGwhX4ZGV6fjbxuMxDPxEa+H4IGEEYFGWvMdjVyjFNIFdpHGJnccSBSrsUia?=
 =?us-ascii?Q?XqBakRzb1A1jviWCJohQHIdknGrUZGKOcIrtw+5V0s4F8itBBtSy37izho+2?=
 =?us-ascii?Q?CR1mh7DuJNc72SEGQbxA9Rx3v1wk81oaqxs6Oq+lZoy/H3UVCPIcYE76bUCR?=
 =?us-ascii?Q?lrdnud8uVI0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yKw1oJ/6MKuGKwE1h0vIsUyBA/w4Nr1r1w1T0sN1qCnxgZt7z/4q8Oc4qujq?=
 =?us-ascii?Q?NImjnS1GvVwmz8m2q+AgMF9S94F1ZXSYY/FhAE5GqW8s1xcISudnEyTHmk78?=
 =?us-ascii?Q?PrcYq+egarrVH++rYR7o1gJDHXILL4e6IEuoDxiTSNQlp/j8MTxlU0AsUieP?=
 =?us-ascii?Q?rlyPew5WeR73zALeU97gZz/3v7NFyg9WouieutIBgXnPnz/Iss6ab8pXRtqG?=
 =?us-ascii?Q?vZXRJd3+03ZCHO8Z/RbBHpR87xlr0tqig4/EOlJWKFgFow9qmq2EtpgsAUm2?=
 =?us-ascii?Q?OYY0UtGU78BpmJp2ujSJxFQ5rYIcalGTIu2BUz/5HRv4xDRvQmoCki4i9BWk?=
 =?us-ascii?Q?I9BvynrQL1F9kcna/Qv3nlIWaPE+xyjIxV5wE3x4INm4csLAcYACT4VK/mxT?=
 =?us-ascii?Q?ArERpIOZmFZGDQ69Rsvj4+E5k8mt4n/fMuFoetkxXJdwCVdfXBvoN3SOdHDW?=
 =?us-ascii?Q?15BcBBckTW4hpqWMhpq++cOpj5YM26B7rcDl608+vpCXT6H4VDg74IDOo4E6?=
 =?us-ascii?Q?Ld13lgaxrp9x9q3lqbJy4F0VlVM5UGiWEJHqXAadRqhdz9K459Jvcqv/E9Np?=
 =?us-ascii?Q?hviUAe0A2L3R3N83fMJ+qcC4Hta5FS++X05I1ENQCuvAfcd2AIiNRNjVewXK?=
 =?us-ascii?Q?ayrD942bUg+ql9z9dBPBuhKb8IuIiJvkMV1zero6Gs2R3zPzOtqGKY0eYFut?=
 =?us-ascii?Q?UXnB+yL3DidPG1n6pzxkmCBl5b/sT9r4X5KtGMbHIPVEQ6nsGSJ1UUrkwwf1?=
 =?us-ascii?Q?m0zP+NI6bQ/YCneAOkxaySQmjY8ts+QYIBP0PiZLPtr8mcqQsIzsikOjPKVn?=
 =?us-ascii?Q?ZP5/I9n5tBy9NFibrDWXfzYHpA0F30NmCalMPTxrPIvlD9mzA6+XEc7t1eVA?=
 =?us-ascii?Q?VAyWv2WcQdNmcxEM+JmR1xxjyEyGh5hdJOlKoqHxB9pMdbE7g7GtWgA0Q0uk?=
 =?us-ascii?Q?+3j/cj3GpfEOPZZpLs3l1kmhTpzGadt95T8QHrrkGsSq+MZDSxnqTvM6LNcm?=
 =?us-ascii?Q?lpZ7vMCa40kUHCyqlBedYSnW4RCc5HgCx+jf05BDrMlAQhmFZK5SjdKz2oSm?=
 =?us-ascii?Q?C9livcVHP7eYSPl8iFlb/bZZRE6mXRGNtGYchIpfQM3F5I9vWmPjikuL7yX+?=
 =?us-ascii?Q?8sx+PFv/xVB6cxBxe21lHVRV0K/dIcSh9KMNwMlF0E8DuwL3u+45kgCsp2Yh?=
 =?us-ascii?Q?qEewm5pjzOOyMyV+LJ7lkiRfc1D8AInUvB2j9DAOCdxUedMSKI83NmMeE1Ne?=
 =?us-ascii?Q?OBMPjulKL97PmGr2xJ5ZIb9uhbQDX93szuQZ8m4nCp0QIQUuuU0vbPMVajXG?=
 =?us-ascii?Q?mK0N63wKTqVkhKZkV8hbw7z2aAOb4RWH6n11FlqlRxI5kkBMj6O9oOJAyya3?=
 =?us-ascii?Q?WiNQ25xG6GSwmyuYoFkaQWsDNPJjUA98PqkN/O6kTQYSPiIw6gPias3ucCbt?=
 =?us-ascii?Q?qijtnIQW+t9Nt+V6EF80l4TiUc1hpH1Vnq1n75VUssOrW5kbDk6nosiBiiin?=
 =?us-ascii?Q?wP4r4nulr8Cgxm1HHecAijxk1fUbMBzhXvZ6DmJ4aoFQ3/jQ9qRPKoAb+fAh?=
 =?us-ascii?Q?N6XCHDjP55A8/tf1aLT2bqRolxiXkpwgoOSIw+fi?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	+BJ/8Bj4c8MVQwil1OZewZ3/uzAsxQdvKT+0/GOtuMxPgWEv9ZilGvL9gBEHEEGNcgJNntWdcG/xnZ+h1bdpKulp52Msv9qsvFMeZMcAiMJUcGe24FnIy+7E37ZTe3qAAciGPIixw8jQBAiGDxhKNG9Keyu13rU1V2vRcjN1cxB4r9EeEP1as2LnxgV+bVgOzOoPb2TSpVFZ0q/RUzwtZ62NAAln4HVRJ4GfFByRsb/n51RiLHngRWMyZng6azf7rcCCNR4ucCXruABO7D7/PY5jZEzWE48DGW/mAeeNQusQSqdOT4rlT2iQZLiiaKVtZVs1YCfjoumdev7nIBwsHFuvNqbqcCMCweULhu0TYDTX6b4JXcekydsQULB4kPEnIZYn5hJ3lnEBocxgrEUsF76TdN9MVn8t3xhLpvMlbqFHhesH85Xp0nWaoF8wfk5yLKU41EWIgktueY2HSoB6FWft1zSnqHpjzrIZbSXqlIpem3iuNgEEuvCI+FukAZG6z0yMBS/CrFUpX53Sa5D0S7s1lIHrJaqN5XRW6QZNNmnrH14HS1rrECSFiUs3qa+t9D0pzkOns7BxIBe3VAzSnfUiBsMbQaHlZQtJ4hQRkzY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3675692-3a34-4215-5d62-08ddd8ee853d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2025 15:48:30.7172
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VtqezILR1hotcaJYqzQ+2Pqtfx8GmwGy+XJJdKwKc6kYlHuMSUpN4wpuB5g+yfU0W28Yf1NDLlNpY1443K0z+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB6434
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-11_03,2025-08-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 malwarescore=0
 spamscore=0 bulkscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2507300000
 definitions=main-2508110102
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODExMDEwMSBTYWx0ZWRfX780fihewwaAM
 60oMa9CJbNsDD0i/jBAUDS9VeUxg5UWyGJR4aUyWJGlJEhpgdh9hifHmotyRDcNXZHXgtL30aSW
 u26iyeB4G9MvdiImgv8iR+N/PJQ/AcBcGXfHu6XCrBdDbCtncJT4QqQTkG5QVeZjZ6h9vWug8V5
 6mQ8K3pZJpmy1ly7GGDWNoPnP4jc7U7RF/vyE/MGTtSfnS1iadtlKpNEF7O6VqT0+xslhkFBJDx
 4MPrsU7YAYmmFdueRCKWIps6taZ4ZzWh7xXvVxvZQeSLOXvIGnWpZfxIRQRknINoNDZ/BQqz0qT
 LuLmFR2JJT/TtpIoODStUVTh9pfyxwckkIZHHTgHhs6VCpcCiOMBoXWzbrui0dhJkqI20lPSyr3
 C/d7aUiUbEUuH1P6ztz3Btx5RXBTr4ET+SxsJP/3LKz4ZYfwTW0l7DVoFVJHK8KKuSJfyqRz
X-Authority-Analysis: v=2.4 cv=eIsTjGp1 c=1 sm=1 tr=0 ts=689a10d4 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=20KFwNOVAAAA:8 a=h5f3xdINdf5QD8HVeW8A:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13600
X-Proofpoint-GUID: OVbR7TOL4iulO48SfKQfYq_3zpQt_7J1
X-Proofpoint-ORIG-GUID: OVbR7TOL4iulO48SfKQfYq_3zpQt_7J1
X-Rspamd-Queue-Id: 9863C10000F
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 9j77i7k79zw9eu8bh7jxqh9d9e4a1uy6
X-HE-Tag: 1754927332-970721
X-HE-Meta: U2FsdGVkX198Sq0Atz4M1GwQem7ZKxW23qlszugN6l62F3af0EQINWSU1GHuuac9lGgGm1Lmyer0zeL4jUSpgQIzCdlm2HpUqZm6QmyMG/MEUYjdqO+Qpi3HlWEpqgmNwV6Y2ciDkAR9RR4Aswc2Y5PdOXOAzalS7oYtbMv/qaSbPxiGi97cNTbpNTb1vVSj3Xzjm+Hdc1/uNJL4bnCH6igmS/u1nN59MwBVQbzUTBMOhBe/ESaIupI5WsNsRnsRBZELb5y+mWbOkfZdjjapwCxVzeEfCRPP+H+molQjanLsCqpKUiLOUtud2QiCxLM6cm+Gae84NO5uOIWDbhUSmKZBqVzDH1/iB8xXZsrG0AVX1QScu5z2vQxhMdQEQSLCNDwSajtgej6lG1bqGpVc1eeWAuv8WvWtH2EcIypPNIgKYiyDlCHXoxKX6KfrvWB6aTV2ckP+EjM/86Qr4YbXMAeCMBmlRRxR0/8yFzwGvhwb9Yapsw5lyIfudEueV0kl/uHbRQKBz+tSDWooGCYSoh7mxFE/EORXtdBFd/8TVv40HAgVINME/5VrqjOHvZxrBAWX1ufCus9SQqcFQ/0CZvJzqoav0KkXXIEu69lMurbxRSM6iT3tDPhTSMVDgKQBtv42Z0DvQGTaXv5z06r/MJo5Enq9IFTuBtfuDMbzE1DH7YEvNorQgbZzFZ6dJrgfCrs1Pnh/45gaMpIMUaLzFG22IK1xbr/oAUX9/Z+Ilmm6DC7AoIFbeEkUxOnn3RWmYC2T9zNeFeNFok0KutC0r/us0ARtkRmLWzzIq/YQHfhkZC9EXlHgHDQTU4p3EllIkHtRkzdF+82doWILr4MDdplqiWVKzbea4cfQJ1SNWEIzF4w1ZCW4a0KnLTeCMg7FfT6gNIcHlpMb3FVWIt4UhzE1ioY75X9saop1Sm/HAdmJcPrn0f5fk4kIHXe/iOo8uYt6bKOyKkNBExoKHNR
 UQC6oKK7
 y291sgErYJXNk14I+b2GBr4oHLCWs95smNiKQqrP6KWsdnz3xj4I4IuD9/bz3ABlpm9yfdb+cTmjJA5rOworW5YatAa7a2TzhEhhusPRIWFQ/4tW8/IGPEDHEeDqWwTN6dJm2a8JKOgz8h8Io6v6EABPfK3BomOB9ALgKQORQNQE5uy/CyIfVonfydv7yqmse/6DRrRIQJAI9cW/CSCziNP/cK50Em2DWmZter9cmIaFtCiaFGR9DdoTBbAAkegB7RrDPfUvZD9wdcR1Mjcx5XbYT6KubIoTQBulh8z6e7tWiMKGSczNe2BrZLOlFhxWOA387sj6MUsTgbmT/OLUw0iwzbqXqJtnZ63X/E8W5Jmi85hlOlKqud3EOPl9EHgpWkDdNJ4u7exLxxkAqLJ/QuMgW5eKbTW66J427OfH26QhEtd2wXWiEOvt+8hv7l2ZyNmIDQBUmxdAeRvHkgaXxm5XHIYDfAY5nLwtxhZv0e0kGg9pi5sS7U2quyDzE6IWDk+j5hnUTLILtXC+zxkImpp/T00oNby1f2HuycfpsA/zJOQoMQRRxl1CdK11AQom3WNwbG9GDsUOqT7Ptf0aQeHKJpDKJvjQ9Bshbo0GWnHH24oXBIo3FVekoQNPA5QyprsxO7VlurNnIf7yK9Sb7IhAvYCqmLckNQCSlPszzxZy7N+1pqgoTI2cff0RGa8DusPHORBCvoqxrTrEVMMK2WuvJMQcYf8ohTb2mWSs8Fsa0fjsExJjrtQJWzNJzd3jQgTui+hQ4PKAVugax0sultr0w0mRz6TYeZNrE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* David Hildenbrand <david@redhat.com> [250811 11:39]:
> > > 
> > > I think it may actually be difficult to do on some level or there was some
> > > reason we couldn't, but I may be mistaken.
> > 
> 
> Thanks for the information!
> 
> > Down the rabbit hole we go..
> > 
> > The cloning of the tree happens by copying the tree in DFS and
> > replacing the old nodes with new nodes.  The tree leaves end up being
> > copied, which contains all the vmas (unless DONT_COPY is set, so
> > basically always all of them..).  When the tree is copied, we have a
> > duplicate of the tree with pointers to all the vmas in the old process.
> > 
> > The way the tree fails is that we've been unable to finish cloning it,
> > usually for out of memory reasons.  So, this means we have a tree with
> > new and exciting vmas that have never been used and old but still active
> > vmas in oldmm.
> > 
> > The failure point is then marked with an XA_ZERO_ENTRY, which will
> > succeed in storing as it's a direct replacement in the tree so no
> > allocations necessary.  Thus this is safe even in -ENOMEM scenarios.
> > 
> > Clearing out the stale data means we may actually need to allocate to
> > remove vmas from the new tree, because we use allocated memory in the
> > maple tree - we'll need to rebalance, new parents, etc, etc.
> > 

...

> > 
> > I could make a function that frees all new vmas and destroys the tree
> > specifically for this failure state?
> 
> I think the problem is that some page tables were already copied, so we
> would have to zap them as well.
> 
> Maybe just factoring stuff from the exit_mmap() function could be one way to
> do it.

Yes, this is much easier now that both are in the same .c file.

..
> > 
> > This is funny because we already have a (probably) benign race with oom
> > here.  This code may already visit the mm after __oom_reap_task_mm() and
> > the mm disappearing, but since the anon vmas should be removed,
> > unuse_mm() will skip them.
> > 
> > Although, I'm not sure what happens when
> > mmu_notifier_invalidate_range_start_nonblock() fails AND unuse_mm() is
> > called on the mm after.  Maybe checking the unstable mm is necessary
> > here anyways?
> 
> Can we have MMU notifiers active while the process never even ran and we are
> only halfway through duplicating VMAs?
> 

I doubt it.  I was thinking in other cases where the MMF_UNSTABLE flag
was set but the oom code failed to free all anon vmas based on the MMU
notifier.  That is, does this code have an existing race that's much
harder to hit?

Thanks,
Liam


