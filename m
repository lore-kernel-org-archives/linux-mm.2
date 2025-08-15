Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EEF9CA0EE4
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 10:09:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB5178E01E8; Fri, 15 Aug 2025 06:09:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF6898E0002; Fri, 15 Aug 2025 06:09:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F4128E01E8; Fri, 15 Aug 2025 06:09:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 892BA8E0002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 06:09:00 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4A87AC0947
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 10:09:00 +0000 (UTC)
X-FDA: 83778568440.03.E148E21
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf14.hostedemail.com (Postfix) with ESMTP id AD8D5100007
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 10:08:56 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=IaiPCocX;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=s6ahMVph;
	spf=pass (imf14.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755252537;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YeKNc2ZTbDLUfT6p2ph9czsyu0QOL0K36wi/Tah0140=;
	b=vPyMDNbeIbEJtfCnrnp08JiKnJW0H6yey851l9ZmfWejPetfJY9gpRNMMNTuOg1/XCCTuX
	LdAL/0rFY2V3xeDReNSUzgqUR0+VkJz/wRBjPzZHt2f4v1aaFu1QqqeI+scd7Fy22UD8mM
	QVSbASoobgctpBclo89WbmeN0XOAc9s=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755252537; a=rsa-sha256;
	cv=pass;
	b=tXqZhw0/fqsP910ntSRzbkAPRdFQ0yvZ4yBQyT4QJ8itxgeK6hKtotwDkOar41rPQcjTcz
	ikIN0uh4tNWe92EvcdQSNhtL0IyvObR3GQ5jr2RkEH6TSg40181LTGT7C86JPmrm4U1d/k
	XU0bDY+BCjX8j0Y/DboLjvmPsPG1A5w=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=IaiPCocX;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=s6ahMVph;
	spf=pass (imf14.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57F8g5CU010279;
	Fri, 15 Aug 2025 10:08:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=YeKNc2ZTbDLUfT6p2p
	h9czsyu0QOL0K36wi/Tah0140=; b=IaiPCocXG/tAmsRFNKp+DpIxnY0dTBzgPI
	GtKIbMZQMcPmDW4TaQhbGcpq4nbSIC0GOAwbSafOvVg/GlEOqAAESGE1EREJnba5
	yimvn8W6KH5ZugM6Zls4GANJhn4vYRnjbfOd8oNkPZZ/qXsW+DR54ras0IkzwfaS
	/6NayVE5mu0X73SaoT2YTBMXH2q1YRJoYiMSlKVOi6yIhBMbiuWFbBHERH6ux/RQ
	9WbTlKFK/+Ngo7qlpDEmtTsE2pmqFFzgsXwLc2X14oUs72gQsf4DhSaG7xRXr3of
	Pa+riUQ1nt/31cOqm8csiwelptqr5e2MIC1jZtUxjbu3C6ojeAHw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48dxvx3kuk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Aug 2025 10:08:54 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57F917WD009671;
	Fri, 15 Aug 2025 10:08:52 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011026.outbound.protection.outlook.com [52.101.62.26])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48dvsm5p7t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Aug 2025 10:08:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Dh4PlE6CF5u1E+Z51axgDIdWn+EcNMgsohK9brbeiq5Lppylj3vEKCM2M3bPZQrvwapfHIbCRpCWXQJSTCmMW8MOeUOQpKyesEJ3liPu5CxtEcPFGq4v/PwcbBDXqQI9IiQywIFHvQBBEnIcOQzYlemapdYYcnsXLeKuVQ1FT23o3I1aQ9BWMj8y1AgZN3ZjEqCoD1PG17YBAHdXvRkTUy/L0jWW+BmERUQy2eqna19mbd63Oiaih4TURGZcSSIkmrflu8ju0uTru5TzHjR05sf1yQwKqZkMgmM4zgH1zwC9GrsXvHqHef/jhqaINd7Rg4fPhw3Y42fZWxqq76V2MQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YeKNc2ZTbDLUfT6p2ph9czsyu0QOL0K36wi/Tah0140=;
 b=efASn/EsZiz2byjeQj2wftBEVEd5MDNXOS+eGAYc2eoF1/OI64Ts33Zo9pUWU4fjS8OLqoAzjQ1jb0ax9SsqmMBaw8GMR0ukXGQktakf63kjKYhwiZczuKqdlsmEOOYLJNGNMyol2F7kLycDgmHpVvrDrPWDeNhaogG344dyRxc9GabRw3eknqim9cLTacYfufrxy/JkFHHQZcqUgIktVOVRTxc9W6vJS8+0LFhiwqXVRuRJagS3f4l4nTAAoXFbsm2JSH1tKhvPw37iDOwzrG1aZ9n3xb8Z+i5KuSiGvqdaWnFI54Gtsuiw7btUZUoW1mViyAyrzeoK2Cikt0i/QQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YeKNc2ZTbDLUfT6p2ph9czsyu0QOL0K36wi/Tah0140=;
 b=s6ahMVphfjluqViRyLwcasifUjGguZzKGPPJjtckMlVcC6bcmq/G2/um8TMblcsymOtqVycbKY2V3gucLtaMBLojxZ1hsCaSHxjfYuuUpMyu0SsUDy+IQCcDSPPVenzlQeawnA8mXJvxjP7qE06AMfo5GCIT21IGNwsVlHfXTkE=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DM3PPF424CCE606.namprd10.prod.outlook.com (2603:10b6:f:fc00::c23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.16; Fri, 15 Aug
 2025 10:08:50 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9031.014; Fri, 15 Aug 2025
 10:08:50 +0000
Date: Fri, 15 Aug 2025 11:08:48 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, riel@surriel.com,
        Liam.Howlett@oracle.com, vbabka@suse.cz, harry.yoo@oracle.com,
        linux-mm@kvack.org
Subject: Re: [PATCH 2/3] mm/rmap: could be partially_mapped only after no
 entire map
Message-ID: <458c4ea9-1e33-4159-a545-6ad2c5b81add@lucifer.local>
References: <20250815084943.23063-1-richard.weiyang@gmail.com>
 <20250815084943.23063-3-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250815084943.23063-3-richard.weiyang@gmail.com>
X-ClientProxiedBy: MM0P280CA0108.SWEP280.PROD.OUTLOOK.COM (2603:10a6:190:9::9)
 To DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DM3PPF424CCE606:EE_
X-MS-Office365-Filtering-Correlation-Id: 24481bc8-f46c-4b49-d8f2-08dddbe3bb70
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?MOKrdIBftsc6aj8tIF1/hqtu/4Uu5JgUhQ5b4ywpYA2e0huQMwjJSXOuE0NQ?=
 =?us-ascii?Q?sohGB4BI9vkYUfjkiVMCdcmPTskaXrH7bmOohQLP8k4IzcNIi8RrbvzTUeVH?=
 =?us-ascii?Q?dbBBZWM3WPtUraHdXcWcchKGnGAh7DauoHXE+9gokJvSIJKZjmU/S9H3Og1k?=
 =?us-ascii?Q?ux3Trl1Bri/O794V2k05lgL7cjt4Tvbp5satr8BSUl2EOSFAOehf8PN8NRtL?=
 =?us-ascii?Q?oWjHJxZ3RqefpaJS9K72avRjBl+csu6j7hqfkc8EnoSAT5Hz9TyPvo0RFej8?=
 =?us-ascii?Q?aMLHYuJVTlhkC0VrcFTNhpiuSFEluR221HPTBmeqolkPoNaYmUWG6upTZnz5?=
 =?us-ascii?Q?NkC9C0LWkS8LctLtc84ortSAG0SgAQ+E1+KonnZOlBXgrDhe7+IQ+EvNAo8l?=
 =?us-ascii?Q?Zsi2jcZKgujWaPHmuaeNv5n3wLcjoJvxcaNkmj1M45ker2ed6T257pb0E2x6?=
 =?us-ascii?Q?vus1TXsJZKmWdzcXRXWiIbgo+ad/bLl1QAWDTspZMZlvZ+uuQmu3SiKtC2cy?=
 =?us-ascii?Q?wpLIg36gnS/JpcHG65tIy23XzZgUytRPnk95Y9+yFLEJZKG4fOtk34pEMBFk?=
 =?us-ascii?Q?fHtQPNzP9hbbgIA0vMjkO4nCpgZQuFHBd+olm+18J4vggoBiNs/qV4FQnp2/?=
 =?us-ascii?Q?hM29U8KqO5GN4Y9yQvtVzpQ4KpxDYktdeQqBt3WftA4fNB3PJjTZoOsMs6Cy?=
 =?us-ascii?Q?dPBQwCj8bI8Pc5RaeyofdOPq4WPD3pvYapgzc+CZi5y4Eqlemnjc6JfGseJy?=
 =?us-ascii?Q?wweMGjlaNIzubSXHClhDHD0u8blqV/r2LRk1q3dM+9nYOdUC/1qr2RDbJFF3?=
 =?us-ascii?Q?MhD6wr3s65qTPSc1pI5ocgdUZdViNYYLtxywSDKzkCP5Z9AVk5ek8SRETFbt?=
 =?us-ascii?Q?OQVsaRP5nl0lRguAGHEz2Hi/twDL88y+5A9x5TnuTqqerpwMQz7KNKW7jbeV?=
 =?us-ascii?Q?NjwIER/7Y3dwQtwEesGunyRVOTHHm1YcGIzQSzle1QKY2YlSreesMi/BwhEg?=
 =?us-ascii?Q?jfeEz1lIGFniTFJTEPxMdO6P4sMhJ4nWJePM87PZ/V+dvleNcQ09pwI6rpXB?=
 =?us-ascii?Q?GJziTSKny2rb/fEzhAosFjEDyEUROobLozqUiM7RUX7BoWuy9VqgJPDlyXKm?=
 =?us-ascii?Q?QNqaIpWJwHEI6mtkKLXBM3kuNFUQMFcytysVvfYAu53qIa9VwnlbbPVmNsjn?=
 =?us-ascii?Q?wB6cFp0MUu/1svFuq+SZWInQMEiDZWP9ZcAwVd/rbtmDxhMT67JDMuqW8LUi?=
 =?us-ascii?Q?Rbz5dPazOHlhmhwlM/kLGLYhnZ+B/9co67RrzWGiH1huBuz0ZOOeLp0rZKQe?=
 =?us-ascii?Q?DeeQ7+l40Yk1S5gNNMChPY6lWd6BcrizXIbXNB45wTprtK5aVXu8XiQxvIox?=
 =?us-ascii?Q?H6FrTR747qsNBdcqQxLGUqX4k46RWxJ3+6G6dIosi55KzgLj0Oq8ntbX9CKu?=
 =?us-ascii?Q?CcmmTFzvUOo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JRepCJscP2WXPNQ8xa9PH6bhbJjlz9wkJ59zUlgu6jFq3baLag/h5MJxg72Q?=
 =?us-ascii?Q?tZHt7A6DPiW8nmeeEIvYhhMuv5bPFeCnPD8BFU8UxPN2sdTDkBn+0dYypPUs?=
 =?us-ascii?Q?C9Qx5woFtpmPVr1dSfFsG7E3DlCTl1GqzYy5ThIA1Dg4FiIY14ehd5ihEQQV?=
 =?us-ascii?Q?f8WrzJiYiQTLbVxsjd7DHHbMCAWW/2yCLulNS5uSema9NChcjknrT21KrFm/?=
 =?us-ascii?Q?QS33lWxlrgU7Zr4w/gC0HZfek8xWiXD/Is2o+tOIZThfreMCdakZe0KHnR4R?=
 =?us-ascii?Q?IrUg5TmE1Px0NbI5r77qnE48+9MfzfUyoBL960Xm+qAaNT5HW1TUdDrXOcaX?=
 =?us-ascii?Q?ER3QscT9y2BK4IHeVp2KO/28D/4PU5s3PNIika5TxJGwt6w4aE4QrTbBZgbH?=
 =?us-ascii?Q?d0lTXysArorzyu6OxQfji1sXNVnmRVznEw7fMGwdx9PzY6JsMFKtJu/pIpUz?=
 =?us-ascii?Q?V763PinVPN3PCSonoH0wyjc9avFRpP7at15gMkaWWxNZTwM13uyNwkbipa+W?=
 =?us-ascii?Q?exY4Azt7h++LiutzUC0+azTteDAFj6HNsIr7NkmhE+ug3jPGaJ5fh81Ksjoq?=
 =?us-ascii?Q?II9B3mzfRwH+L9FZBcKa1mroNTVuBLhWbXziCyLg8sWNZ1uuZmK/NrksRYBk?=
 =?us-ascii?Q?iqkntHNyVRyPTM602M2FU0VdJCcGomuypG1WpWxUQd1+84znejYwfnFnxmG+?=
 =?us-ascii?Q?8aE2InrRnnMG/W3qROx9fwzyAn5qpdMgq+QLP1DAGs/EQIc96ZzBand9n1uC?=
 =?us-ascii?Q?ijr8AnxHfFm1ej5z2wpi0VNF4DizlWBeNssa9/U7iCCrVV0qcMlgCyoROu+d?=
 =?us-ascii?Q?CsS5eHmyhBtPR2SCjPzpAX0Cs5uAZwZ6r83/2DjELOcwGqlWioRfuEYbF12s?=
 =?us-ascii?Q?RH9/6sEx/kBm7P6XNtQbD5Iz34qyenWPBVfb1CKrrlFbTXElqj+Z5jntRYBz?=
 =?us-ascii?Q?CRl31wOPMP0QL9OZJ5Xol30QwPvYO/xTxQ56gHmh/uRG9rV4PRWH1O3Obs5W?=
 =?us-ascii?Q?C09iZfR1ROBN7jHctXzzDU+ZIOC4t5i4Awh5504XjMNQuTEgjjOyrCFK9eHb?=
 =?us-ascii?Q?HkZ8Hl1gCTFAT5NCW7qdbI2iV3pkTO1fGbGku+y0BHJ+mGE7I1vPkLTV7O2i?=
 =?us-ascii?Q?yPhN7q1M96a+O2q32I2Jh3tmHZWUO/O/GyMiazikeQkSOxS4pKfyoavwUCzq?=
 =?us-ascii?Q?5m7xRqWohjjWSLlkp7vhTP+TVSJY43SejOk7UV1TcPVfxNgfnMFwpm4fFq11?=
 =?us-ascii?Q?GTqZ3k1qnBIj2IBanH4w58MbItq4ubOCbIZ0xSf0HTPjseUwxtxZJ7K142Dx?=
 =?us-ascii?Q?iOWkxrxu64wCtJnvbT8uJNQdmQMAGgOyK+Wuz6Yy7VKLrN2XBiqKq6INqNVa?=
 =?us-ascii?Q?xQvvsvEsvWVFstUekKggXDzMmomajZne/P2grdO7V5goSErN2xGshfREwoP0?=
 =?us-ascii?Q?59i7iIy92f/v8mKgHmc38lXgTsAMSnHf5dA1zf01DpXOfVRQiFMxvcJiGZMu?=
 =?us-ascii?Q?P8bmhZbU58vsvniQrWa74YyHxIorl2o4C81vbKBY+mjLHaA4EX8s/EP6tCGm?=
 =?us-ascii?Q?F9vOCbL++2/jmYm/7YRXsu4MOWw1979PgEnYWOemPaPXbAdJh+aWOt7Cf+Q9?=
 =?us-ascii?Q?8A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	axbBtt4jxbASmL78pmHIcCzQTDqLIrh2HxVcx5DgxgiVScoLK66UupTmdM343jPkKo8GPrs5Kj8B1hFCAafjLaMzUkie7wo9Cm7lt8h+QR69CTvMh7HwfzL74U/D/e2/IJ60V4ibtr45bLgUmWQ1eweDk0VA9kaPSZNbLkKw6tmJ2Mkjoi11LjlH9C1qAM/NpNlPAUI3kO4r+PRio1s9zd34pSxa6hjui6PVncJ+t0CBd8m0kHs6wkAvSxwebT9kF+h/yle26OBDkQM6JRHTv6VAvrCXNiDGyHfstLZ1zk0EqRvAAra5toeitfnoEzZzNvYNZVp/H2dSxOK5WP4ilPGvZ3YEXhryEzXBiQY1X6HT8S7+Ykqp2klHOdShNsupIZxlXUoAG55XgRJBZQvdnp9MZ+wNofxCXRG3tt7I2DTkSIqSrWh26M7Pdauo9QXMo/wvSBeWK884W8Kq1hDzy2kadDbIvgPggA8cXUWCwLRFaKZABn5HqpiRKs1+z3XFgO3hbhd51sU7ivucbANGumo6vIq2AaQ7T7dhDP1MXXkaCeW0E6A0AoZK8dCAeFfCYK3Rvj1+JhJzQQ1AltcAJw0KoxC8LxEdfpMpDf1PvEY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24481bc8-f46c-4b49-d8f2-08dddbe3bb70
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2025 10:08:50.5874
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EH3k3YM5ymyJ1nqtK/0ey/16gwDggl8INUQ0XJAy9LASlmRub3/U3bm4ccZDW7b5eHXgPm/LMV+oK9VmZRJbh6J19a8bP1YQg+9J200rUdw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF424CCE606
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-15_03,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=879 bulkscore=0
 adultscore=0 mlxscore=0 phishscore=0 spamscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508150082
X-Proofpoint-GUID: _b8f9XFrjlvcpf_iB9o5UxJlNdKEpAfr
X-Proofpoint-ORIG-GUID: _b8f9XFrjlvcpf_iB9o5UxJlNdKEpAfr
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE1MDA4MiBTYWx0ZWRfX1G5s6VJlMmi1
 Wuex9YakUJcqC+rC/VuUCISFjYrtXHi1CcY6D2o1FE1lztVQiUozeH9lk2gKWraRtZbFtscfZIx
 lCWXkPpXFHdvgPb//7yrsgLUfUU4FgT+fE/6OfyloNTLdyxZyDwN1FpIFs68ij9Si2/47GRoQee
 TMsh0l1LFeByxtJ9I2ehd19d5kCtBp3z/zEZPBS3LbBPaKjA0v5TjOualRVL3lEYTJLp/p6qA5j
 8YSkyZfH5rtSsd9AVr5qFXKXpHsk4zadENdKSQvP2Ep39Bb5mLXlz14D2K3BGHwUwmZof9Y5vGe
 cNJeOVLZ/AcKcBSyfzUo7R4Mfvgx8lhbh71dI9qCh64+54uZbBrIV591+HwXfwUHs6nwdq6cOWx
 VKXVeDJyLq6Kmqj0Cac3F9TEIwWp9E0+DNzb5zNM9hC+iKoCWwQhCre3/1v4oYARkLEQbkVP
X-Authority-Analysis: v=2.4 cv=dpnbC0g4 c=1 sm=1 tr=0 ts=689f0736 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8
 a=yPCof4ZbAAAA:8 a=fwyzoN0nAAAA:8 a=rBf-MXkO-ZOEP3pZ2lYA:9 a=CjuIK1q_8ugA:10
 a=Sc3RvPAMVtkGz6dGeUiH:22 cc=ntf awl=host:12069
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AD8D5100007
X-Stat-Signature: e8s6o7ptk86xk9x8wydn71uhe6sw4oyn
X-HE-Tag: 1755252536-444073
X-HE-Meta: U2FsdGVkX1/5+iVxb2qlkU1dJyK0JJFmWw/gUWQd7sCdBIw8KiEY8JHh+eoWNHjFs8fv15awAFmx1SjFXufUZTYLg8GrP/FVfoWNJNYoT3tFQbcnA4EBZfUXu97algUtmE2U4vbvmg8DNalu3Y96Y2ReRdxWknB0wx41YewZvqvwM8ODSPdmhVQ7Ch1dSVlorjK0OZL7kLFXXYDMv2UHPMs26WlUFXZ373M+4/LBq65+gPK1d3tOVMU+JIBZOpHMgoMYoDVhyCh9eKYIqeDxmhtlp+fllLViEQpiXWVUGCSk5l+sOYFkv/HcHTh7jI5hdq1S0LMJJpep4TuspPakVonlfFq/r2U5f+t6toG9jo/vKAUtz5II7dBzAW36yL7l2i3Kwz453oRU6ZEPWpo8EnV/AVaWxBuzzDFMZPPw645wrlcWP2TuLdx/9vybdm3g/+6GrnCxTCFKcR95KUNbToPHuDjc4KXhNawgrvsUHRMyzq1LXjAAk6rIfMNuGBS85hLcewjzhZrBUA1b3/r+vKdLtOUll9ETGNgPSz3uCP1uvsOZ7/eFjkC2nfyg+Z5WMoUxO5Jx2M4q4MI4eUm37A4Jn4AYUF04jNGsfTXjFRkWelS2+AF4Qikk8MgX7x3I/zY733SntA4Gr/dwSTwXjoBmuhk4srd+NM0BMxWp3aB0BuHu6v5RyHzD9GpbiHxnsbWNxmpjgteEXu5lSfkiJBHEBx/JRsPdihdK7SCKZwKFdrxAYtngywc5iUqYThP9o6/VS/Q+R2W5D9MmNxtwVOe/N9qrtaik7Qn8oEA+s05eGawIVJTvjsgLFdlM9LNS9cBNFV2pepuctw99Ql91JVJl9Lk5xR15FCDheGsirUjmLwwCDkeDtQE4+ayr6lu9eqLlP/gwSdEkAvYMTWgy37AlcXfrr2MsM/z7us/i41u3IfUYc5r+PS+EIghqTbXLijH+X12t6nu+Xd7L7wk
 ybJq2zn/
 7qaw5nwsOqMOOCR9KDZagTsT/QYDJ+UrpRykDu+6Mw7CY60ZVCf4EzhG0iqLwwDKxFKVLXZbI0A2M3Kh/zaDxlxCkp7vBesr7rtFDn88cDVBjel0FJrXOhtovlT+i2DTgWy/PXB5GiQv2NU4TmRWl/M7mWvibEPXmWxmeTR+uuJ5MKgfbQCICkwCIGWalqP2jdvZBg3UnovkGuACVsJtUeRcIjEU4B2hvOwidHXTa+ONBjTevN9X2jayTat/e3RU8xwlY9zPnF2x8xL4MASNNc3O679DYdKSqsmxc73VHk+2qoXAPjk4j08Yy582gbiPw1VRu6GL9HxdqPxOH2wc18T4pXRoG/JI3fZST1VN/fJ4vbHQ45bVL/E5icX3hOsHhAtWPL7HcOYq3fNhCD5Qnph+vay0ey+gyxg54vM7DmSBy33LX7lsaFEoDcGkIAKIHc3z/h0VbiAXJm/Z5h4ZrlokCDFOLE2V/owf3KsKYLvD/w8pLRXz61kiYkwyY5I6Xwp+GGtVeV5iyNh1wYzpx9MErOsazf5jCnViYag8mcsEouJGfko4KtUtsaSjAerpPgxUNkuDiodAT8Gfpc+gq+3lOYptmlDVmHdfJgnlYLUvZR+JmV8Ue4LmHO5yNmxQfqFDE2/Vh1zxXln/D2UoMwP6RHEqHjRegOVvshEGcyKlCn1+hMT860pWhd+yexE+icOk96aXuX3N/carazBsPaqUe21hDWZctXZJhpu8JwyQ0pXn1+GocH/3U2xbDaqezzf1oACU8/rCzmjNgUTPMy/EfYR+D4ZcErkJI6YNXvrjVJNEWW5Z48x0Tk1z/SizpWQn+IxUpR9qKGiUmdAsVuTxwxDn2flRQQz/FhQ39nnvimTdIevLScO99BDLkQx8y3kUb38fPDLdkqxAHZS7DyFtAmoHdtqRhP0LlepEhL9IFwKtN0sSI3FG+FwPKmrxz4TSnYy3zdm8mI0Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 15, 2025 at 08:49:42AM +0000, Wei Yang wrote:
> If it is not the last entire map, we are sure the folio is not partially
> mapped.
>
> Move the check when there is no entire map.
>

This one I don't like, you're having to sit and think about why it is that
this would be the case, vs. just unconditionally doing it.

Again, as mentioned on previous series, just because we could do something
doesn't mean we should, unless there's statistically reliable perf data on
something real-world indicating we _must_, code clarity absolutely beats
everything else on importance.

So yeah, sorry but no to this patch, please resend with just the two
reviewed (unless David radically disagrees with me :)

> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Rik van Riel <riel@surriel.com>
> Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Harry Yoo <harry.yoo@oracle.com>
> ---
>  mm/rmap.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/mm/rmap.c b/mm/rmap.c
> index a927437a56c2..645d924bfc7d 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -1757,9 +1757,9 @@ static __always_inline void __folio_remove_rmap(struct folio *folio,
>  				/* An add of ENTIRELY_MAPPED raced ahead */
>  				nr = 0;
>  			}
> -		}
>
> -		partially_mapped = nr && nr < nr_pmdmapped;
> +			partially_mapped = nr && nr < nr_pmdmapped;
> +		}
>  		break;
>  	default:
>  		BUILD_BUG();
> --
> 2.34.1
>
>

