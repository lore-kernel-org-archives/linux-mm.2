Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 621EFC531F8
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 03:31:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21C736B0088; Thu, 19 Feb 2026 22:31:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CA526B0089; Thu, 19 Feb 2026 22:31:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02D606B008A; Thu, 19 Feb 2026 22:31:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DFC086B0088
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 22:31:43 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 48D901B61BB
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 03:31:43 +0000 (UTC)
X-FDA: 84463410486.03.C02F814
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf08.hostedemail.com (Postfix) with ESMTP id B56AD160002
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 03:31:39 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=CTM1ljZT;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=zPDi0YUX;
	spf=pass (imf08.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771558299;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fTLXHwCaiDMlJF9aPeiqHCw6Hapriw9bQM6246i5F1A=;
	b=POhgOwN29cIl0jzpnXl0HmmyJUofzREkqBpF2J0P3o3fbDftY+lR8Krm+42K3e+Ek8azcZ
	VvdI7gbOtjrrUPlYELs40HG8DETbPJu1n7C9Y46FRSSd2IOB2Pgla11qIHkyOtavyOtELs
	XHxZtkPwIc0W5y5UiVIHP0XmU0ozcEw=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=CTM1ljZT;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=zPDi0YUX;
	spf=pass (imf08.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771558299; a=rsa-sha256;
	cv=pass;
	b=KA9R43hXLiN2fY1iuLIKbRqK2lEOcf+BGSyvejpd+797C99lO3Lu2ebLlbpifM8XSYkYxc
	E8dFxULwI66LO0QY059Tc+wm46YiGuUtV6ftNZLA4Bvaax7VjJfaOcnMkemJHHtq8J7dHZ
	/Ira/JvXYCXR4RQtAcRojKT3dVgJlSI=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61K2j6DE2543350;
	Fri, 20 Feb 2026 03:28:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=fTLXHwCaiDMlJF9aPe
	iqHCw6Hapriw9bQM6246i5F1A=; b=CTM1ljZTA8Jr79Dhzwxj+uqegCkZ+466la
	+tCNI5pYdr2NWodPTbUFCYJ04VknbvT8YSdqgUb3KOvmArtcvstV0iCnVapUOGbz
	fVVTa+5fVPOAmnG9MkcfpDwrXBbVSEUN4Rb6XOz5gvlOqpKvO1ZJqvS3OgKKwmBV
	vArKBUA4hlJdXvtGB8RcUC0C5L95KXlEhhqn6j9RPZOe7Ktas84WZQi25DiRW0Br
	ENG6JKYoXDIFtIE1DfTRrQPB2NyPeJlz2vzLcfqyfSQT+Vg382afhoM2Dh1Zdikx
	GkAuYu6orQM2G0AKuMxAWxZrpF/42icZfXY42T4ajF5x4Mx/1WIQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4caj6mghk9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Feb 2026 03:28:54 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61K0v4lV014971;
	Fri, 20 Feb 2026 03:28:53 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011029.outbound.protection.outlook.com [40.93.194.29])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ccb25h2ux-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Feb 2026 03:28:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xyki7g30Pn7k+9nou3+S4RblHAeSKEzcZ1RnhA0NnQxVXp75gKkSjBsAv5o58yvjUP3NmTnWNSL7d0s0V0YtoaAgB5PfTmzhb5OCrNkqlL4XCQrMCgEWS0BCGJyGegL2a9vCq7QLy9BhsruUQLZN8G15bJkpy9CsrPSo1nhnr6emzweRurxuzVzx+ZNMdz69RFw25LCtoVajs/8A+7Qe3Psal3I15y2VQqIxwZORomrtPq7l15yrSLG5l7mgw5MrCbB9BVH1k8oz5kS2HLuTpsXNKxMILTrDQO6+ozldwlTN79iVA43ZkB09dVx8H/wtD9mAfxQ6ltj7hWGRuA+lJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fTLXHwCaiDMlJF9aPeiqHCw6Hapriw9bQM6246i5F1A=;
 b=FFc9m4PCfNoLeSkM1jwdFVDH4vqAV80oNvk5i0HKjqbgLUHdOHquV/ARAwrIhdDjG8rYMtIwnD49QuGccsfKoNAQzBlbkCqANqzjoeDFlBDttcvv3LaAUq7TA5HHbKsCbrGx6OD6glJjrKPgdd+USqoghHmMADat0nd4dvtIgNQnntgdEeSKEal9dz48G6qUNUZ8vif1ctKIJgY7HwTjogqQsgv6IfPEGz8Ctr2mfKrCBIasbroCaoMSbpSoqTfMISbhEi2uNcUoG/p4TvfL5hKHLKrtJZ1E5N2hqvoYunda9XfGiYAUEij3T8d+IwaqSF4qr7FHnG/LVN4wG7nl4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fTLXHwCaiDMlJF9aPeiqHCw6Hapriw9bQM6246i5F1A=;
 b=zPDi0YUXRg0RlVWUYbCaumgyM3VNtWh0NyVNHxOF+9fMXqXI0E3ZX4ixaYuMXGf/RDmfnwWu9R0EyGNQ9e86Mgar77Jvm3YPH0pLqypI4aC74zTKlc+wmu/czf5sQ60W9EcSHfwi+wp067WWSx0mEC6pZjg1tAozyXVbz+x/4F4=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by DS0PR10MB7456.namprd10.prod.outlook.com (2603:10b6:8:160::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.16; Fri, 20 Feb
 2026 03:28:48 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9632.015; Fri, 20 Feb 2026
 03:28:48 +0000
Date: Thu, 19 Feb 2026 22:28:20 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Dave Hansen <dave.hansen@intel.com>, lsf-pc@lists.linux-foundation.org,
        linux-mm@kvack.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Mike Rapoport <rppt@kernel.org>, Matthew Wilcox <willy@infradead.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Usama Arif <usama.arif@linux.dev>
Subject: Re: [LSF/MM/BPF TOPIC] 64k (or 16k) base page size on x86
Message-ID: <vq6hv7gyieakkka33po6nveq52vayruxsdbymcjxja6vtxlldp@th5gwdlfhrwa>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Kiryl Shutsemau <kas@kernel.org>, Dave Hansen <dave.hansen@intel.com>, 
	lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org, x86@kernel.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Mike Rapoport <rppt@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Usama Arif <usama.arif@linux.dev>
References: <aZcmlIF4bmG0twkp@thinkstation>
 <46817fe5-7166-4734-bad3-3109cc7feb1e@intel.com>
 <aZeFeAP9Zh-9q7pH@thinkstation>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZeFeAP9Zh-9q7pH@thinkstation>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YT4PR01CA0500.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10c::29) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|DS0PR10MB7456:EE_
X-MS-Office365-Filtering-Correlation-Id: 9cefdd9b-b300-4ef6-c18b-08de70302918
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7UFv+UGnwlEuMvGPdXV0v2EwyRgYCa1ycEqEB1IeDKVQH7DYCvLxyg27SONc?=
 =?us-ascii?Q?DqNlJtmLcaBE1ixwBD0jwSlxqBnLyALADwHYK/WsqijXkDZJtfr3l8MLDMwR?=
 =?us-ascii?Q?n5vj67YnfagfvaTU9Gc5M49LmS0dHtmbnIvi1yN8KTk3pQKLCtvaHjjwI6E/?=
 =?us-ascii?Q?f5P46qaDn33uV69Fc6htIwrl+E96yd6QI1uTNZXQ1QsoTmP+lW4l2xcHmt/M?=
 =?us-ascii?Q?6nFyUXz3XKLUGmiI00eAkl5hUIgFMrPpbF2UB11XdjG7BJTyumTdhwbGrYeA?=
 =?us-ascii?Q?qpLi6Mypj/RvTONKyeHMPteTb98bKo2+5FUtZS54wAEPLa6Z8U8NQs5w1gLb?=
 =?us-ascii?Q?mSzs2wwpEd78WRBPSLGz9cPmWWeDOfgtOlWmmwczpYqy1E4iWS0XN8mFSQ1r?=
 =?us-ascii?Q?EuzBNiCL+9AqurWv9h4Xfso5TCwU35Mfc1pAd+WOW+3fFJSmZdyTVk5kJpEB?=
 =?us-ascii?Q?Wi9NeZF8fNMT9oJQFQAfkTbZTC6dlJI/cDVFVma1uQ00qVC9E120GyEEJtEz?=
 =?us-ascii?Q?w7voMAoYMa9rs58eGYvo9H5kT7j7mGecvXQXmjIwZ/1bXDMtBGlwTD80irEE?=
 =?us-ascii?Q?eorfNlxBBeQz2LmRHz1f7ktXMefo46KofaHLZhqhnU/E/ISxR3V1e+wSjrfB?=
 =?us-ascii?Q?krdQfW2vBRlIBbSFQSZdh1CHJjz6CCQXHYwOi2i8CJILuhOlT9w2A7mbtkLw?=
 =?us-ascii?Q?w3rckSM/GZSv2Nw7EOpttOu5OjUwr9jSHRnK1SnFJjmo5k50UBzyTZEuRYPQ?=
 =?us-ascii?Q?zS+AhaHqTeHZ/vNzbZQjb2iiK93XKF9WWvxZUPG9ZZS1cNVp4i4OMnRUhJhu?=
 =?us-ascii?Q?JkJDxC4lsR1usSKCjgnJKGkFsoGJVS2t06bximg53OEMkUAKrYYwpf18dvdG?=
 =?us-ascii?Q?+teH39mZxB9/oys7r1h8OzASxBxS/aUABs7VZVUnCVpvnYDbAyy32gy0g3F9?=
 =?us-ascii?Q?hFQx9L4C2mdgRVmjFOS4uXSxcK4RayooFkxXtN5XeK5zIZ8UvgtYebDppV/W?=
 =?us-ascii?Q?CkCQuN7MjBO+y9bKJ45aCIwdVP80DpFfGq0dsKrBIJy1IlxKySPerfKV5N+f?=
 =?us-ascii?Q?hmw78M+GBlWpAtLucFGvfb81n1zY+iKymNNMHp+y2I5MrDvh/xemXVlhZorK?=
 =?us-ascii?Q?s1ciqwr3VT5jEpt1+x4w3uIHxy1R38bH+oxJpjo9st4YltVHvL4dGIFfXlMs?=
 =?us-ascii?Q?+QmaDh60uGyEKsUv8qRXICsKtMPp1O2FfOyah0397iaDQG1KGMl9XL39NPZh?=
 =?us-ascii?Q?y/pG76EY9Hqdkm3gEYtXyQPluq8YNINKW+YJ/C2hftQ0ABZqG+DJ/wx4YB7a?=
 =?us-ascii?Q?qULtrckPfbozHA4GAxCY6ZFn56f5gT8if07ouokoMc4tu5o3kUN89B3A4Tk0?=
 =?us-ascii?Q?kX5LYURp5oao0ivKQOOIwHPSJOdsXw2qS/wjNfwtxnWUK8TEB7KBYRUMWSEX?=
 =?us-ascii?Q?XxmaNM/KPPq2X6cT4CNiOnRG5PDhD/PUq0xD488aZZTXCOhoWL1CNX/Nnkg8?=
 =?us-ascii?Q?TRjqhYEQlORWPReQO4Y64pho8gFJx42vgqhncXzQoYFuh0FOgYnuGO49scnM?=
 =?us-ascii?Q?smTtU1R4eI83uVcQWws=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?uiK3EEYsDeK/5CgVsBYcfojjc/An1OmFT2GcM8JSXUB66k8sw7npgY/Ok93Z?=
 =?us-ascii?Q?XJPOwmyEztX8wTGMUuZcxQyraV6sPoMg/2F//VVL3SfSt0cwsbzRcU/BSXmI?=
 =?us-ascii?Q?POD38JgWXi9MWJcvQmS1olbVBPb757h4HLJNLgMUZfX27QKrlNWvH6N8ts3h?=
 =?us-ascii?Q?Ib4OmlJ4gnqn9+zVCQtDogd4QTlpqsBXIE/0gRhQYELWyvU2uT5lsAQvZ6rb?=
 =?us-ascii?Q?kJ5UYYCiCi2fm9TTbN6FTwiF0BoT7+Ece1kp2f7mU/rX5Zv5req/DKpBXOqd?=
 =?us-ascii?Q?w4NcENCHnBwtzrIgeD1DwWKyxhoBiqjzbCwL2OPJSr0OVfnDoIXYj9j2OHlA?=
 =?us-ascii?Q?4cLWOW0WSQejKIjK6bk9RGOYrdBG1DNjp5o9lkctRnmJz5ZOXc1OQXAnGwdW?=
 =?us-ascii?Q?XwXresYvxFKvWoetrapV5bbrdyLfoqID3frAY+hzW+ucQcC8BzG9xt/iKfAV?=
 =?us-ascii?Q?bcwh92BWo/eslHC4jYLwLTV2okPRKWXbmiZoF4/Xpargd+cPkcY2xmqntrnp?=
 =?us-ascii?Q?lg4Yv2ihmztYEJCIaXJ+B09xq4wVa/lx//OVAA21cfi/9lhhIVuMm83Mk6VN?=
 =?us-ascii?Q?0Q/pW26ERdvlpwFZ1SegoMbYtosg5n/lYc8rGEl3G5FfpI0WhuczA9OD5M5g?=
 =?us-ascii?Q?/TqEjHYPb7C1wW6HHeqQxaIrhnPuiWV8MCKZU+Dzent5FbIsZyYzNcrk56ZZ?=
 =?us-ascii?Q?afxOsNp2PlyNaqD6DOmdNN1FM9wKnE3pmOks4YX/tOkFXt5qqtPSid3Y1+bp?=
 =?us-ascii?Q?nmnbWBhdlSYh9EX1TBkiAnBSY0r5w2NjlJaRzHVo7JLpQOAr4O5FgEf2tfky?=
 =?us-ascii?Q?jbjUrmDDapfcZpQLWNKOaA7ztf1w3pZnGKja+ehM0nNsKTSyqFhacaAQYcyc?=
 =?us-ascii?Q?ikSAuJjebKnYjNoA+pSBmPpNN0oMDjTMUdNEwXi3LlcyH9NhELVSZzRMzwPG?=
 =?us-ascii?Q?wbgqLxlTcOPeJWPzkm6PUKYWrENIBinUuuNmVRLW1XdhR5oLcOmXBXRWKnHf?=
 =?us-ascii?Q?MTJD1tSRaevLs/Qi+WMfc5YzoQN9uHlho8hVimW6ErI3S7F8WNqhNczBoSdy?=
 =?us-ascii?Q?PZfN8BIMlHm9UoPDaKpM824oCe3fO70HsP4dQDiYv7lBsOTfun3GXk9n1+P3?=
 =?us-ascii?Q?8PkcOUemoeFUk4iVUi8NeGUBF5KoDldPpuUsOC8oxZdXeeF5hRzf10P/aJpI?=
 =?us-ascii?Q?Gw87rxb6KuPpo6cV+yiNSViQqU/aEsuJ+Rn9f58UL99JC9IuIo/5na9nRJjv?=
 =?us-ascii?Q?md4dRGUSzbLiTgzI7yaHyttvWsGDhwm/5uI/vTmv2OfiEIu9Gy2+IXFOnRSz?=
 =?us-ascii?Q?dqcn/JRDZPdY+w0OSoUpirVrXwJeZBDdBEto0tmidinyMpyCcqT+1iHUWTLy?=
 =?us-ascii?Q?mmNLMKy9WInBV51Y3tfz2YVdPkJyyIuJZyaedYRc6IN9egWP8clYaMFB34qz?=
 =?us-ascii?Q?TfTw3rtu2H2+kXXGfjjtd0ptWzmd+ZKbdvEXXI6lwCw2yvlPPe7yKHCNk1qG?=
 =?us-ascii?Q?iPzQsxcZfQpfXfPvHSeAGLNLSFBcwDkAUoiKkqMvMErdGlqlvzoFMEx6uvCK?=
 =?us-ascii?Q?OMvT1A4cZ9GEvXvmVY/PJ0Jcx3W3Z5wCXGKz3AR8VES3i8N6SRDgTtUNi6oO?=
 =?us-ascii?Q?y5CXOYekZhkOCnVtdO+jq0Y3aE3iiu902+LtUnbmm5VJO7QdulwduyNxYmN3?=
 =?us-ascii?Q?MnqV6np5hBJPJRETxrSsO9hh53MCRv5JP3PCsbCosbxu7i2vUlIUGR3yfIq9?=
 =?us-ascii?Q?K3dCnWwOXQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	05JkQcYdUgywZ3rgJr7CC9YPnVC60/8sOmzWvysDRBRoUiIttd36jY878ZJNaOBWsDTL36cnlc7a2Xf5G137KSBhmkeUeCzcD+XKdtxZZM4/wqvDQHx6B7o0b9hI1iIJx23FxmRzvVUDyEZH2SspOKVQmZ/jR+yzdx0oK9Pq/dHazatM0fJ9umtYSe7umfHRiEaZHFYVCDMHvUnYU4yHpAHJrp1MnVUr7q4optyo8tfjdQXwmDS9d4PMcGRYh9vBDEk7M0tPa+5E5QSx8Dn8qMuNAo+Awxr6RlVtIzWJ2OGQu0gGKxCIM8WbDyszxu/QmZjP35qWcFzJ/rwx6SVXb0Dk81NVQSaBSBkIpeA14GqIkIijNPHdMHuNvVFPunJP3Qw6tBMCzA1o//MR2YKIKAv/uIpprrebwZHr1zPc5aShf2bmnGwU5/3YpxXNx6Jcpkp+wwsVf84+zHw3f8PK41Y9MHoeqvlS3IlcPCPU3AysW7oL3pQzA0RGdaW0imjmue6aqG13THCE9XMNMi2As+h7fQlgxcn/qQinwZhjz0CTPPDWSyKWFqiOXkbzXpCl/66MXm0i5ekVWBaqvyY+i6LCjkDVOkKxx03Tr69Yy/Y=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cefdd9b-b300-4ef6-c18b-08de70302918
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2026 03:28:48.4929
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ovtOcxadmhlUShDPRCQRhk/cUeQfDjBHXCnmlt2PHZN1/4CjPxQzzcxDXWUuTs+iXTVuhsnjtNU0K48xkJvMJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7456
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-19_06,2026-02-19_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 bulkscore=0 malwarescore=0 phishscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2602130000 definitions=main-2602200028
X-Proofpoint-GUID: 56uwDGwWWmLdRcmahmRQ0PxM39hnpWvY
X-Proofpoint-ORIG-GUID: 56uwDGwWWmLdRcmahmRQ0PxM39hnpWvY
X-Authority-Analysis: v=2.4 cv=JO82csKb c=1 sm=1 tr=0 ts=6997d4f6 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8
 a=axbvjqKRs7VcUkscf54A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjIwMDAyOCBTYWx0ZWRfX5QLyToLQXjD0
 9Bv1t0cijbQgHpUHbDhRzXg7oB/dZP2GTeA/aoRUh7nRYf4HmyoaR4OtIAvyYZMHd3KmOlJmKSF
 9iimX0HQy3fcjoqSBmzyfJaK3M8DzRulvhl4y7yhXvw0oz8FXJtErNRNFiQmx2JQELn2XfMIJiP
 0dherwufONTBYhVGRj0mIWd1ymlDXCGvEz/7Y5ujhRW30J5RSMdAi0KU5RoGUBLQcxAupnm3OYi
 5Fhl+ZFzyTZTvD2NppluDEvhqaA5+jUV+WURs5MN/eYGou0o/fD0cxVpasIFzRg5gnb8j3DzTz/
 MnmA51yw3PHjTUMl1DCSZw9/Ctk5b7i7rb2UTJYxhPIngtMjkQ3+Wj/TmEwYfqDK0uZ7zPfJ5FM
 lGyheW51qHjK9UbYXnYWqUT54YlfYCWDqdtLpfQHsatSTQb1l8eBXIDawkPLv0qTdsL/9q/SGcF
 o0+YQqiz1qBe67y3l8w==
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B56AD160002
X-Stat-Signature: afx463nc3g3kg181jte67tbq8mi8m1y8
X-Rspam-User: 
X-HE-Tag: 1771558299-55124
X-HE-Meta: U2FsdGVkX18HpE51jAyAue99ITvpeeDYamoSA2AwFm1XGsBJAMtTTh74BXb0rs2WSai+uY9agv5gyStF8ONfGTUePWj32ia6SFNCgKw6/8GFtmZV+fOuZSaPVTtk0atHRfNurKHzVpbTddf4RCZ9bmVrH79NNJWxTlvsR5iVozolbDu9g3A06vnHBb1ehRXeSSHAljRZWyEOQjbeB9oQj7r8spIJcl4IuFlJg1qN7yu95+K/TkNgxMIHIgEgzjm+fI7/YYOVRRL/JfAlOHAv3xwaeYq1jH7UGrOEI1SqFGE2vdgNkm2RwJTHjeoI1Hjd0NACcPQ3E1CrGNAwUW6t6TPA1Dv+x2KzryiljkEzoGyA8Vzm6KyD1rIILm7Z8b7zaBDvadX9MnKgdWPZCJSGVyoTiBHSKKF1qd6ZVuQaseGQTiHdGHDtC7A4sROtiImZDU21vvyYW4h1V+O2TW2dRscOeYm5A7lwvEykY6pi1DgrIT/Iw6xxWL9ycQK1yfsWTEWKwZSiOSonMmbNAlrwBxjt7n+J6kazBlh4MX2dmTYc5nS4cXa9Epwvlxh6yIUR5ANKDKYtk/wlUWs4jFAK/9mn22AffA2SPT6HuzMHt4peW9W9EBBuTo2mPLLW3O2s++4mTDKgF3FDrW9KV+znHoiUFAaQVA3xlDxt62mSoWJxqOA+hqj79O/P2l3EVVFo1shqNuobQMi6wE/EFXEg190Qzwi9wu2blI+23MINbu7Ts6SkAtGRZY7WhXNEwnyhPpAeo9aPMjwlgm/n7gJcnyN8YCcJKGtqAfMq+3PCEZI/oHnCTnxTzRRBu2ol8Fs+Xft3zcRR/yldiIK/wITC7OGe55WBIuFRRpkSZ3oL44pP5dXqxTtyCi1cpdQUWiwmuIwbJlMa3tu+YSFyN36GnEKbIJdPtxGDbnbbHtqfYUE426VrzNLiq/k9hT9ZXhO5HKYmwclJR+aIEodfA4F
 2YLwDuOu
 Vxphckl5mf4bireJ7onEeT2A0rFZbxjlkIk7glscBziI8rtJoW9+6/gWdpVenVG63BOGANrEZCWMBJ9OqlI2HerJG1fmbbpBiApSxeHFY4IaoLh1TpMQJsUek4NQm6fkzECULSkBA6dRqO/H/iRDeEYIknQZCAkP7HHAJ7XGCcogJ7yzz0r4OetedW9rrc4heq8kMw9iBo0Oi6f9Zm5njcBVIfTVc2lINin3rBuzVrHpkYzGtxeNZVXbOQLLvuMPPu9A5okHvsNdetyQU/MUBkT4UOvwyAFJMPYRL4RyEytGrle4frRiz2tbZheLyZDTU5Fi3HrZCHgLUYZQdGr5GNsacVXClRlJAcolUZHp8uJH8qHDIa0ZAKUFqN6J1AdLT+2An9UxKQwBmVX+Z18azGLs0Lfbzkm6VkgoKI0bXtmRPkiE/WMKUVjuyu7Rbl9Ecvisxm491tw3ky2VfLSloXOE+sZb/wsLyfVnZawN3a4eUsy79lUowNDX8y52nj/2ZahMfOdaNNAAUCQdxJTpOCwaihB7fSvrL+GfDQJADTuvRgyNVOMZrQ96c3mOgRShH6W+LlyT6vsYNqfoxwZu88Q7SeOld95OhBTcVWk78h1+4+po=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Kiryl Shutsemau <kas@kernel.org> [260219 17:05]:
> On Thu, Feb 19, 2026 at 09:08:57AM -0800, Dave Hansen wrote:
> > On 2/19/26 07:08, Kiryl Shutsemau wrote:
> > >   - The order-0 page size cuts struct page overhead by a factor of 16. From
> > >     ~1.6% of RAM to ~0.1%;
> > ...
> > But, it will mostly be getting better performance at the _cost_ of
> > consuming more RAM, not saving RAM.
> 
> That's fair.
> 
> The problem with struct page memory consumption is that it is static and
> cannot be reclaimed. You pay the struct page tax no matter what.
> 
> Page cache rounding overhead can be large, but a motivated userspace can
> keep it under control by avoiding splitting a dataset into many small
> files. And this memory is reclaimable.
> 

But we are in reclaim a lot more these days.  As I'm sure you are aware,
we are trying to maximize the resources (both cpu and ram) of any
machine powered on.  Entering reclaim will consume the cpu time and will
affect other tasks.

Especially with multiple workload machines, the tendency is to have a
primary focus with the lower desired work being killed, if necessary.
Reducing the overhead just means more secondary tasks, or a bigger
footprint of the ones already executing.

Increasing the memory pressure will degrade the primary workload more
frequently, even if we recover enough to avoid OOMing the secondary.

While in the struct page tax world, the secondary task would be killed
after a shorter (and less frequently executed) reclaim comes up short.
So, I would think that we would be degrading the primary workload in an
attempt to keep the secondary alive?  Maybe I'm over-simplifying here?

Near the other end of the spectrum, we have chromebooks that are
constantly in reclaim, even with 4k pages.  I guess these machines would
be destine to maintain the same page size they use today.  That is, this
solution for the struct page tax is only useful if you have a lot of
memory.  But then again, that's where the bookkeeping costs become hard
to take.

Thanks,
Liam


