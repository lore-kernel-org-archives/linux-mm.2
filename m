Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 889D5CA0ECD
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 15:49:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 271E38E0077; Mon, 11 Aug 2025 11:49:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 222618E0060; Mon, 11 Aug 2025 11:49:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09B848E0077; Mon, 11 Aug 2025 11:49:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E74A08E0060
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 11:49:01 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B4054B787D
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 15:49:01 +0000 (UTC)
X-FDA: 83764910082.28.DAB6EDC
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf13.hostedemail.com (Postfix) with ESMTP id 47C0720007
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 15:48:58 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=MqPdfxHy;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=qw4a9qW1;
	spf=pass (imf13.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754927338;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9n4mXKZ2OfxzOpokW6aBZM1Kz1fJSgErHEp7zB/gNjA=;
	b=jegYL3XDlTBfojy8E4WqUGVuobprMd+0pN58zdGbleMw0a7lqf+2I5SSNWBAG2SVmmtRUu
	7NYbmRKclRFjnFnTPjjnvjO/H1FzyxC7/SxZREH+JXRK/JzgeecySDZg3oWX84oldp266z
	6CWUpxGqwri3F9leVtmRhtHSgyDXEgQ=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=MqPdfxHy;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=qw4a9qW1;
	spf=pass (imf13.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754927338; a=rsa-sha256;
	cv=pass;
	b=VqpBUBgxf2PkAcpJ0TGkKAEoGcLVCw/lb01WVnrxF75Jgph/YOD5uaJZk2+wKyu3UN+SLT
	cBdWuOY5zdS1p+2mJF+ZuOq31piXNOqN8fgVosesztpBeEzdt7xEgY8DpQdSVV25BmPa08
	W5EB+EUfbHHIOpohlPO1D3CP4eLJAgE=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57BFN4lb006247;
	Mon, 11 Aug 2025 15:48:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=9n4mXKZ2OfxzOpokW6
	aBZM1Kz1fJSgErHEp7zB/gNjA=; b=MqPdfxHyDqhD52aw80sREYjXKtpB7Zgcm0
	oDOYg0I0GlYQTGagZ4FGW1W5Q95poeXshpqGGnr6YChQrrrxg6SHgMeoD/jxjWfP
	mJvlEUB/2Bd8OVt/8BfJJGJVQuqISDR5/VcP1Vgc6M2fsVgjiqx/KedgYj/aP2z+
	zhj+svvVeGFUHxp/JqktuYzwlFD/NvIUW0422kcOAvb7J+WIaOpJnyfc1WHtc9uS
	6xH25mT3UHAkB5L9NE8g9hBjqf2ozXQdEcMEoUn9JSEnENRskeICKIhGFEYsZNrA
	z/uigbG4BmFlqwyfl34ezHXA6TxMMq0oj7vMC5Ew8FAEySLY9Gig==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48dw8eawht-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 Aug 2025 15:48:47 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57BERhvJ009647;
	Mon, 11 Aug 2025 15:48:46 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12on2067.outbound.protection.outlook.com [40.107.244.67])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48dvsf3b6c-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 Aug 2025 15:48:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=V4Lzjp6YMDH/Zc+bLqykoJVY7WFyBD7SbMLE2YpogkxgUlin5+XcUsUpDIa4dcbfJwxjlRkUOVXLwBKz94vL24bI+qFEBezu3pWi2SlL4QggwYgxrdmesCOrivmn/afScqNa4o3b72UQ2bM0ms/UGm/lr5HIDoYTIsFYCdTm96yW6AP4oIoFsovhJmg5toVi1lS/A87+qj59+VvDNI8pwc1Qge6nt41zWwjzkrb+IXEv3ZsnVj2CTYdou8BTw/OGW7OiNx45W4GqMD+TNK1qCaez9Ip9IFIh8FXuGge7adrr6W7GCoyC5wYjNBVVM98pv6bYYsNTIeQ8DvzDZwnJFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9n4mXKZ2OfxzOpokW6aBZM1Kz1fJSgErHEp7zB/gNjA=;
 b=fBCi6hplyfis3nq1fgMZ29puom0mWgnPZBoLyLJF78BD/r19OQnqH+YkxmJ6frusKbkOMXExkUkYZ7RlbERMdpWk0UV+dOpWSEzG7j8UEHk19IOs2hzBkqf4G+pw8WEOYrX76tM2AjEy09oWEMrNviM9jGMrgx497q0Fbwi5iuY/DKQmvd9czXvtGTvhYHH+BIEqB3yUuRkUDe4McvYRz2kEg3y0QIvXaYfZXcrm8bQi3LuqD0Q6JCJEHCPMHGgBfzakQGPuc9HzU38cVXnlcDlcTalVl8RfOF5uUJZn5HmGdQ49MRWSzbwsfKHZRgyJNoSQAG7Rr+8Ha0Iu8fRLbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9n4mXKZ2OfxzOpokW6aBZM1Kz1fJSgErHEp7zB/gNjA=;
 b=qw4a9qW1tkL7wm4wxVUtnCmtSDpQYFj504oH2mdtQb7dSeq11UvkikGRWP2KVAl9EBPdpRgvCLWXgHwAg7ODGSED6JondpeFrrYLIOz/hYnHtW/EyZxUAI5XxeTT9AruraYRMZBOjf+AbYlDnVqx6dW3MY4+5UxPoP/wO3hzqR0=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CH3PR10MB6737.namprd10.prod.outlook.com (2603:10b6:610:146::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.22; Mon, 11 Aug
 2025 15:48:20 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9009.018; Mon, 11 Aug 2025
 15:48:20 +0000
Date: Mon, 11 Aug 2025 16:48:17 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Charan Teja Kalla <quic_charante@quicinc.com>,
        akpm@linux-foundation.org, shikemeng@huaweicloud.com,
        kasong@tencent.com, nphamcs@gmail.com, bhe@redhat.com,
        baohua@kernel.org, chrisl@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH] mm: swap: check for xa_zero_entry() on vma in swapoff
 path
Message-ID: <e7781de2-dd05-495a-9a40-7718f04adf0e@lucifer.local>
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
X-ClientProxiedBy: MM0P280CA0106.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:9::25) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CH3PR10MB6737:EE_
X-MS-Office365-Filtering-Correlation-Id: eb0bc874-34b1-47ad-6d60-08ddd8ee7f5b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?dh3TCI6fKSWIo7zgGQ7b4tfbiXcJmZv9bH21VX3Z1zDa9526Lo1WFOkQiUh0?=
 =?us-ascii?Q?PZW5DLkKq16gtPhpImfGonpuA49en+lnZX0+8St6qoSu8wdxUKMd+ZsT1M0p?=
 =?us-ascii?Q?M0FJFFC1/SaIiWHlVjRc9OZHvrRBubnV8SFWDonJZoo38fD9CsAop66JC1hm?=
 =?us-ascii?Q?383FX9l2I1gmTBlnHJ2gEB0Ad2fqLKNeHGP3hH4XudXHcKXBqWnE8CLncdcy?=
 =?us-ascii?Q?FwldpI41wJoNh/oN0bYJT89r/znC74Yelfj02v/e/6TiCYdgfcfYHZ0+DoLJ?=
 =?us-ascii?Q?1INjQXX1VeFq58ZVB2W4aq8TES1pIPk6HNOIDn+DHJklQ2QcdTNbPmPbLPa3?=
 =?us-ascii?Q?HaKZqy5i/LiBzRdvTGmMvFZjAxWQQdZseIZH/TdCrKpp4fPMQ0kasbMt0rwS?=
 =?us-ascii?Q?z4L+kxm6cah260TBfNy2DO6WwVIgrJq7GAa1ZgcZ1GVAFob1wXrenYYI9ax+?=
 =?us-ascii?Q?ZbN9C06Auxs7jAYv+ENsZuoEa0NW1SJ3xQHna/zkRkQxf/cwutlYTQhQSUpv?=
 =?us-ascii?Q?WWsu/0F7uOqb2VcAAjBIRuxcKtZftIbXTEqs868OqmelUfQrmSl5szASDxr7?=
 =?us-ascii?Q?RW4/kAvD55AC3H6UBBZc+UMmHKsxo1qiqTcKTpV5TjHi2pPmAOt3F1ov8b7f?=
 =?us-ascii?Q?J1jZfGQedXg0vWmzekYryAWU5TDqjXudjWwK/9iGCtwGqDUdwfTuglDXuxOK?=
 =?us-ascii?Q?na9HNCYpPiYb9MoTUNUuehcKOAXQt1W7oDSmSkjEOKs6ZfgeUhA87KVBU1LL?=
 =?us-ascii?Q?Q4Wj94F+cCJ0h75cWDrOQO6ePWWJEHLBNipYcc4/LIN1zzJtCs7n/dAPT7Xy?=
 =?us-ascii?Q?rd7gQa6iI5RoHHcP4N+1oNMC5Jv1fwPtUCA7H9QqVXn9zhmbJ1Eh2d7Ie6eL?=
 =?us-ascii?Q?ZqvHYUcEx8/1qZI254UsU+1lh/UGdgeo2pteRDhY0BnZyvKUD4FturTIfOHs?=
 =?us-ascii?Q?VVI8KE9duWOJuTgNi63djbtSGT/xbxRKg+F0NBALLtqnU1CWjYJWr/hBl8rE?=
 =?us-ascii?Q?BRhAAmmHdd6c3YAuYrZSjoREZssCwhXfM5ZV9T8l837C6ZPblm7EYSyBASwV?=
 =?us-ascii?Q?SwX4ZvidE/YvJ1SM7x69SwAkxsGrZlOkuNFmIm3Z0e2PQysk9dglkzeHIWTJ?=
 =?us-ascii?Q?YFlRnK4CeAHg3i6aGfBAaB1aE+RNKDS+Hg6udpJ6AAxmBo57Tpw5zR0fG8NL?=
 =?us-ascii?Q?mXcg9xGgWvsYVR8AUrQ7tWP6H5gcsEq1BxxWMjYJlvZ8SXE9B3yLrOOoCCF8?=
 =?us-ascii?Q?oWPwYVcmrj3ixHcpzWPNvVGnsb60e1sWruHigoid3Y8lqj1riLgomWBowlO0?=
 =?us-ascii?Q?6rH79VKzDQrEnMSx5a55fT/fDxukAo2eFunuAQUxPmf+rRbiGHtSgymGxHSU?=
 =?us-ascii?Q?sg8hAkKh050LgInJLJxFLgX3DuYvV5sIqWBMO/JfJppU7iZNFPEvFz9xrE/V?=
 =?us-ascii?Q?SIL8IAhhvto=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?K41SL5ZgzfQrW9+FjgsqtU/YzlbPkMTsTBQrM+1odOni2sKVJnERMQQTCIQw?=
 =?us-ascii?Q?oG4Ce/c/4DcE5EcN3dKf5I3QkgScGSPKr7IuVa8rim0QfGTB6ShvjWjGldiM?=
 =?us-ascii?Q?7we8fiWIWlIaWkqSQ+ZTJzaxRrMnFtDwo3aD3IpP7lBQtQFYpyiw1vvRWZvH?=
 =?us-ascii?Q?SJMLFNCzCB2wNcoo5e3bmTMJw/mQv5Jrtg4C3INtgJi1t5P9ECiorMOfgF4c?=
 =?us-ascii?Q?YTK7iXTzDdAiU3wWVfhwM9vfFrhWsWU7MKwau02CGCOlvpfoaqu3DsRt1RUP?=
 =?us-ascii?Q?4wLIvJJSAkmMwnE3Nr2XHV9CDOv45xZCwaUve8Is8KAz+k0Xog6a2CVQIHIv?=
 =?us-ascii?Q?bVQj88nGJtgKKxzay7Tr0WOca1iQmwqQjADYSgdOx2K5ergeS2jJCpiCqSne?=
 =?us-ascii?Q?7N9fakXaOGuow/wzO2Of1lpI6Zb7kYLoYWv7vJg0OCwSOYl4K00WfkLvyQmX?=
 =?us-ascii?Q?iz6z32Jg35//xZ/w+S3HhNu1YeDv+8gKzcYK1Yf9y1HxjiBZOkusNhn+mstx?=
 =?us-ascii?Q?ThiLmiBRgPR/ETMac+NsVtHURov+BP9XONgpsllZlZ0Tnf+17s0v9KtWNZpv?=
 =?us-ascii?Q?te6w/Q1M2cpgBnfw17ChwiA1YZRk2INXI1bDlP+NA2oj+c+n1wAQNwpsnOlO?=
 =?us-ascii?Q?MPVMajatGu/EQ067XWKzS3eoUtW/R3C9BA/B/LBTn++PDH3Jrs4nQa0xQcWR?=
 =?us-ascii?Q?8jNNKMQgn/sztGql6DV2kGBmfbdmuWhxRmBDXdHMNI2rqZ5WXA2H6P4T35VT?=
 =?us-ascii?Q?E3SG1LeNgjYfRYLKw3HqYTL19v16K/BC7UcQunjGOjYY2h/cd2ccC/9ql87N?=
 =?us-ascii?Q?QtbrbUaFthQbqyAsXDRnBNMgB5YhzB9pzhizXA5wWsYiOh3P8umjia3TM4ms?=
 =?us-ascii?Q?UYpzkJwDLSsw0wwGHocVEwSmpkPfdiIs7wUgSkaOIyw1RHsrjMcy8fw3SQr8?=
 =?us-ascii?Q?FW7J3RN5RkeD9hS6TAjx3HKtlv1pLOv+P3FPI4ObEit+3FeTZyz17H+fipSx?=
 =?us-ascii?Q?djPHk0ADEGgylLUjvS8YWVr1aItXhCT38xBOYfWOfwyEVCTCSoQxbiWHNilq?=
 =?us-ascii?Q?Vd+DtKhCe3f9RwRL0++68bncATuplSmt7GaKRDp3Ogml0TjezOfQOoYHMsyq?=
 =?us-ascii?Q?tT+kCrkr7hr5dCH6K/wz6Lwt6LOb3e7iYYe9EKamIbqjr26F3TOgzD92dPGh?=
 =?us-ascii?Q?7F9twUsw62yzZ3b0/49PDIElLOns1zDIgyJ0W1yRjUiEIymKrVpU4WTGYsEW?=
 =?us-ascii?Q?8srW2o54tKbOyxNbNLidI5oSJ/0pxXUF/nnrXXEDZdycymHrE2xRBw5lql1J?=
 =?us-ascii?Q?+W/ykVUPuSthrjG5Ejdb3o8RDm0JutZLCfPd+lHTdJ2isoKCljMYJVumzupr?=
 =?us-ascii?Q?9KdDEmOSZZof8Ixzm0tk1CpP38CqOJ0exDvRCzqxF4zGw+0jkVIq/Ovh7oNm?=
 =?us-ascii?Q?DfwHGCmHzvxoPZbT42Op6jmehDlsqCscKN3wtC9jVxl0nFjEmkFzfWgL4Saz?=
 =?us-ascii?Q?ZlDUUPtMwjx9fw/BmOKrks04ZQ3ZAKpYPY6uUFqfJw3xjaDOB+au39FlWyNl?=
 =?us-ascii?Q?DjYWGB3xboBrNMzpwp9NberurehX9POlHDydMujRWoxc6fOG0z4woHuQnZJ7?=
 =?us-ascii?Q?Bw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ypzoRRLZAzEcU6UlsGlVOrf4HB1m3cVkEFkvTuVXA5k/wQXfvXnhgOw41YJ6XPaRPMSGfqr7FDLz5tOvMBbfhjK1DupsIN21vqAg/BdJRFN7URIHiCcJqFVDSuC5MCzRi1DsKUL6hoemwHYwQmqSwgk5gQvRRXrheGRcgSYKtUdoU4M17XEjG58K2GT1MPRV/vpjjK2zZcOoaqOJxio+3qq4lTpc1+Jd9os20QgiyHM9MWIJ8gAedjQssP4/A0ley5eSNGE//V0BIZii8OMBg7owsvJxW9qkHL3+RvUNfnXG8L5bsxcVb5u7jO/vRU7D/4lJc0GPy6EZ6RV9D83N0FWLcpW/AKwPK/nV+G2Zr7NbFAK5bhAcSUq87Dlj/XvTwFe8Mk6Wd48VlQnbn6cQxcAbniGjXIsfdzCZcmAUc5nDQWuP1zlKq9rmQHrzm/XJiiBHwZ9kopXRJVBF8l44lktodMR9Z/m113OK5bjs7BsMDDuPxJtzbFWbiN6IsXlF2L9PWsK0D8qAR85LToeHX5mnWvXLatG1Ga7nS6KF7bHwWzdUaZAUve9W3mB+6+msyj92odoi4NOv4R/45de0DJ+OerNa9o6rvXm4N+oAOes=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb0bc874-34b1-47ad-6d60-08ddd8ee7f5b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2025 15:48:20.8068
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DOhAqk8bmVX8jnc3gyQyB+Qv35+BCVtXKBid6rVZJ0koCXW8GXb2BP9+bi9WllFVym3YCMUYfChIOIP1lqC5roMTx+439rojdAJ4A1Ipb4M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB6737
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-11_03,2025-08-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=907 bulkscore=0
 adultscore=0 mlxscore=0 phishscore=0 spamscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508110102
X-Proofpoint-GUID: 8LCGOOK-7J6igfcq8wfEl4XIXSR8lP9v
X-Proofpoint-ORIG-GUID: 8LCGOOK-7J6igfcq8wfEl4XIXSR8lP9v
X-Authority-Analysis: v=2.4 cv=ePQTjGp1 c=1 sm=1 tr=0 ts=689a10df b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=Anz9CkioGlI5ipyUjA8A:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12069
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODExMDEwMSBTYWx0ZWRfX+4ndvHh9veRl
 TwVV4+MNBk0ngFmW3saawsI4Jgn6FhLs/IBLRGj+d3nWrJLzxHcgPbQsrHiLF5txml0wDQGuuWd
 CP0ZKqZpwRvbeScjN5YGka6k9rwsbu/Ro+SxmRbLMwvcOK5V+0TOYkKX6dSSX9UVavBpDFlEzgr
 u5r5l/d5xVH1X4xBe60gMCm/q2diWnQrNKRJ/R+vgIeRN3GrR8sJvCQwJQSpOWoLIi+ILeeHtfi
 rz1IDDg8WJPY+KnOCxgjsRam3FRlrg1N5oVOx2Vf/wv3JhueBoy0Gsdg7cTB3v3jxq/5vszUVW8
 1Fadt9VZKVpuspCk16RvcjsCMt8NO4FB+K9HSU/n0ueeDMQTU+mNJ4gvmRysB4+kW5kE2DQvh+3
 V0+A2mCSsjF6uskb329eZ4Khb3iTzI5iXblR+mxVkGpTqKgxFkkPUYkiyyjGB1JgL9w6LtN/
X-Rspamd-Queue-Id: 47C0720007
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: uh4pk6c9enepxut7raf67jokhgmrq85r
X-HE-Tag: 1754927338-991153
X-HE-Meta: U2FsdGVkX1+ymG+I736+iPHVgFZHbOHMcvnneBn7Ef+0SY2pTQ2/viXtbPDjwjMTMXhwyoLUshUCrnfgVUF435gfjBcikGh/hrCKNI1xvOSTXCphjiLDSonCcau0ERZjRJxd1+hcz4UDOv0MqF3NS+ghUbkGTbohuWJGPK98qGUfWwXcGJPSGr1aA+p0nSP+lhbCYChXJVXUvgIRcctaZcaZBA07RSNbomUX7Po2vqb/0w3y99RLfayEMcOl7BOUhAoWocO9uW4vQ9QZ72Wd2IUGsDmL+iOgse/AjSVVhuOVsZuVUuEE8jIkba99oxdSSOJ2RTpP0vagGGGDwqIeg/x5BXDGF6dHlfi0LkjMNMYW2lOEVRbJ2EZNVf2rXEkvIvt5X1DPBARzI7N7F/fA/NqGuhFRaR56MCZaq5Mm/ZvUtKHYIAfmTU1z2xvmnIJwli1ctRXHGhXlgoomjyHcW4PWcCfODICaaKLbjfGxUFmQG7hdxNcYuG1hfKwsmvpq3zZ8162BVk7+W/FgUt9zBkSXMuMUgdo3tSmyPR6GQWPdIw7+QLZrrgRh7mrAShCybWx3D3dAEyxMOrY6AzEyBC6k7UEzsQF5yVUS6N7PW2CySceThMhKVrVA4r2+AYVV5/wvpT+2duboiLk5lTeR20mMogr66M+pZwswOL0L00qE/8z3YBu0aKS3XOPlcHoRyAs5pi3EnIiNpo8DiqBOmjP8bzRSjt55rhdyw3h0sZdLQ4CsMQ41g3iyFQC8zrh24EZj6Bdn8bnLBZDsK5u4supfcNiVdLB5r5BWXkus8q8n8TBNGlwZZbJM3fG2v/pFPginrCdbrkaTZeHBte+zyV2XOTSvAYBix9yzCq+V5lOwgMl9cXIAgdlMe8Lz7Iaol3N4TvWi+iwa3NIoGMJo/HJPwnt2O16L4PSmzPI1ub1EtlMcDT8WM3pf3qIy/QxalsC8bapwxxBqoE3Ru6e
 dfmGadkn
 dRwvVR+lLT0X9qRD9Vl+wDdJb7fK5AT1IJ85o6qAW9OaKdJ59LsOJi1rmi6k+uK+BnAy8X+eT+7/XlUPiHyKpU79/vG33etGQIwUlWphreh1RWMjoDHzteTVp6ptk9wYRhgj5W4tsTJs0JrjBbAaWvrQL5pGIdH1l0SUSAT4Xl1m0O8gr6ShY2WMVTkDBK4dVeOi6NBzmXkbfKz1NqZdfBgp5qNSZcDI+CPftDJpqLpUKUa9EdrXVTt1KIQmtpW1WNqpu59sAWJRa/T1nPTx/oYt7+1JIP/rf2a16IEj50W5nzTULUldJVVJ6twfx99JeNmMNy8JbkgGQjTPwi0dEZNgaO7+56na5FObmSpETi+1rcaY55v4izDDKTP2y/x19YKnYP3Nk+3QY1osHPkz1G9skRbuhMn778wCL2HBMA07QxrAPKlaIiILoVQGdaEIXF5cJHrFb9Y15smQ0GjFdUJcKOPtNX984NnCVAb2ypFCpNnztgMZS07nK0CCvGjqi0ggms/VQ0Wlid5vjlKlMM4i4KH3VfsbHaiPesObaHXdjapKnTr27x6EvW6PtbQyvK73vEDlsSodoAfF+xuuNxDmToUGWT6D/Oil9VLRxZjgE+99dqHpG3ht6tqdnrbRFR4Q/9YQ7IAOxyBVnobEc9nX91czgPpkQzh8stvrHenSmj56eNqfbgX3V93y1QbjPpjZpvikWfQAa9bPC4IOTfdNNDuL/DX7jRldSH1i+yn0SnSO81Ol2hp/jOCxH5qymTxiZoTgU3GOBODQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 11, 2025 at 05:39:32PM +0200, David Hildenbrand wrote:
>
> >
> > I could make a function that frees all new vmas and destroys the tree
> > specifically for this failure state?
>
> I think the problem is that some page tables were already copied, so we
> would have to zap them as well.

This shouldn't be too much more egregious?

The issues arise when it might be an OOM issue, but if it's a fatal signal we
can take the time to clean up.

>
> Maybe just factoring stuff from the exit_mmap() function could be one way to
> do it.

Is exit_mmap() a problem here? Or maybe I don't understand what you're getting
at.

I wonder if but can we somehow avoid telling swapoff about mm's before we're
sure the operation has completed?

We are doing:

dup_mmap()
-> copy_page_range()
-> ...
-> copy_nonpresent_pte()

And there exposing things to the swapoff.

Could we separate this out until after we're sure the fork has succeeded?
Would it really be that egregious perf-wise to do so?

Anyway - Charan - I think for the hotfix patch, you should respin with a
check for MMF_UNSTABLE, as set when this code path is active.

Then we can think about going further in untangling this mess...

Cheers, Lorenzo

