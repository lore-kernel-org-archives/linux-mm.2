Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7A77E6BF39
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 21:01:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 570F76B00AE; Fri, 30 Jan 2026 16:01:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55C366B00B0; Fri, 30 Jan 2026 16:01:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F61C6B00B1; Fri, 30 Jan 2026 16:01:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 293EA6B00AE
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 16:01:10 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C37808C351
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 21:01:09 +0000 (UTC)
X-FDA: 84389850258.24.D57F30F
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf28.hostedemail.com (Postfix) with ESMTP id 37BF9C000E
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 21:01:06 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=WF57F7aO;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Jst14YrS;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769806866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nsCoVKnWNVdRGbFF7nf4ydhmpR0wG5Jj6DpOyXo7WSU=;
	b=rbAZBoAbOsFB+8q7zdfraC92sLMH0/UVyOFdYbCIOxcSZMP8A1GKny/lkagOOtZbmcapMn
	NC8al5SapCEK6cicWM7iv4kGcezmVgGGxVoeLi0nvEK5E3apHnI4a6UdWtJD+IP46VpqaI
	PymjMFI+amTEJpuNGlCuu+ub83AvKrg=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769806866; a=rsa-sha256;
	cv=pass;
	b=6M22SOm/t5r+kVS4sWpmys6YpYjjIqYpBtJLEI1pswyfp0iW5jvCxsAb/wpsOnKPhwn2OM
	m890x8x5LMOeQI5YnBC9cT+887/CSnrySRrO4QKevOKcLbuUNb8ZTB5sGRhv5RibYuOh97
	O2MIFPLPMHZoBmRW1LiC2L+BMjvFF1g=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=WF57F7aO;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Jst14YrS;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60UKDEu23406906;
	Fri, 30 Jan 2026 21:00:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=nsCoVKnWNVdRGbFF7nf4ydhmpR0wG5Jj6DpOyXo7WSU=; b=
	WF57F7aOxgWOkLqz5TBRbE0LVwa1lhBdRj/ZHUr23uGIAXV1+sGAYjFFHl9rpqvw
	p51NbSL/WQhL/Wd58EVcHvF7p/ts5MX3S/R7tce5GXPW79kk+cs8QDjKOF6oCn9D
	mRaThBEKOKM+YUMSbm2rQGgyWLUZagaEqSvSZaArP742zzbtm3gJMbp+WRYM3dLl
	RB3J6CP0tTuBccdbUsEOKkxGCoRy/BmINb8/pvF6gp3W5QTuWLenlc4veGoCLSaY
	l9vhdYWu29mTxlrNjN+bOLT5+wRfflu3sjHmNPw7bVPJI29qoS170P0srxLgJqnz
	UYBUoNeG2BNAv6fKtmRQgQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c103e8dus-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Jan 2026 21:00:59 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60UJJC5L012770;
	Fri, 30 Jan 2026 21:00:58 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013070.outbound.protection.outlook.com [40.107.201.70])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmhe6f1q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Jan 2026 21:00:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ursIYMgX/kH/RZLnFGKviie1ds6vtmbeiJ4x0jk7BGCwTpqxogDzFyEWyP99Fz+mJtPcKY4AWKUfxafCwu+3ZNmEoQG5mGZBtI3ENOhyXXJtBXAwliUx7rXQsSO0X4ha5ui3eIRyvPDfYGY0BIctQjGVCDTQXt9VUcVIqrgXzw6nDVOScMtzcJwHGh9UTYlUPlAXU49Vd80yB4wg5POSzIM37aFNU7wqskxBB8BKdhZrbrXWnYf/9bSO5e0/FkyEO3MbtRL8YuVw4DiU397VHCLXovtsv8uS3FgvsD8Nw8mwsreT23RTJxDqdR6kMpZl6jHMctCm0S9bpS3zKB3ctg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nsCoVKnWNVdRGbFF7nf4ydhmpR0wG5Jj6DpOyXo7WSU=;
 b=zMGjUfG83W0nfvHUCX9uN7n1lGSc138zU5kUiPkFsva2LU1WHEC9j5BQonFuOcTdH2BqigySRWFLC5o9qWUH7Y3DvbGzQHw67Xq2HiMnM7jeWCvH6jJ6ZbBOdjumtKOC/gL+KZe9gniJWmI7Arx8Btl7twChq1sO0yXQIgUFII8K/u9SoyiLs2J8xcSAsuMnqGGZvxrMasIrtmjwkFVVUueMFhf8JaRIYdGeCsWq2eaTu8fD4glSes/jJp2Ao9wzlAYWI0rr8RIFQwLH3bLJRxtiV+p2YKkI20J3d7rT/UMLF+NuWfrKS80jOD4A44AQpH7/XR9tA6n+hO/DP+irwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nsCoVKnWNVdRGbFF7nf4ydhmpR0wG5Jj6DpOyXo7WSU=;
 b=Jst14YrS+aBLGlwkFf8MThFv6AslMQcEQZ/Esh4jBy0br6OxNSiisKSl69V51eZhSGFcZoY6oIPKgRIWVaFzBUeBHburM1OjXO2H0cJU2wzNd18LrqyYlrA0JBBOkLiOvjxm9cNGHqf7c/dfL6R2OYAL0dyNypdrk9X3w6VX6OI=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by SA6PR10MB8061.namprd10.prod.outlook.com (2603:10b6:806:43a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.11; Fri, 30 Jan
 2026 21:00:55 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9564.007; Fri, 30 Jan 2026
 21:00:55 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Sidhartha Kumar <sidhartha.kumar@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Alice Ryhl <aliceryhl@google.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Arnd Bergmann <arnd@arndb.de>, Christian Kujau <lists@nerdbynature.de>,
        SeongJae Park <sj@kernel.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH v3 26/30] maple_tree: Use maple copy node for mas_wr_split()
Date: Fri, 30 Jan 2026 15:59:31 -0500
Message-ID: <20260130205935.2559335-27-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260130205935.2559335-1-Liam.Howlett@oracle.com>
References: <20260130205935.2559335-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0345.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:fc::26) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|SA6PR10MB8061:EE_
X-MS-Office365-Filtering-Correlation-Id: bf8096e5-b991-48fb-b392-08de6042a8fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?bp4L2dCBFKzqSZKUsqmnUaJgrNUp9EzubyQH3rVVjGsp1uninkpQrOBfwUAz?=
 =?us-ascii?Q?HpXsuwbm64EQ4/nPagPl2OGldeNwpmODm/lfZAZxudoOd4FHKVkBL8qV8L9m?=
 =?us-ascii?Q?yhcjrf1/g20CI/FvgByPPfw7n6qP15g4Ps7ThsDRjMwgw3CFnd5FYmWkabMh?=
 =?us-ascii?Q?x27j72uRpj8Y1K3p9dqnax+n2fMI5Z2WushsBRC7h+CUbhB7ey/yp5iqo8hD?=
 =?us-ascii?Q?0DDtZUt4uMQontQdFMA2V9Te3oXQZeXRKtPx+/25qVMd12dj2tHgQU0XZaVk?=
 =?us-ascii?Q?yHDni7IB7USBxL22DewUnRfEA71dkjlGYPrBC2QPQg0aaVnxCwCWw9VpjoHK?=
 =?us-ascii?Q?wE7naVCdE+JfIZ1V+KwXfXjyh0j5qICNEVXrhdbZOnpeUdWq1bDi+s4elBLN?=
 =?us-ascii?Q?JTwnaJrnuMOWth0bT2311GVTXnZgVSfadxje6PnbDAfxhCGjYS0YDDKJSpOl?=
 =?us-ascii?Q?4Dssa7V4k574zzuHHrIW5LyKfs1eM5Eu6sryNh8X3GkLvHy5ZivZMFGgL7BU?=
 =?us-ascii?Q?ns7wMYhxuWZey2Wz2KBVFVkhiUzaxIJjIV+3DKsRB4/V4Lh0Bnd2bpzFhqgI?=
 =?us-ascii?Q?OCtnsOXxIsozL7iS7XldHOJBfEhTTPzfyTv8ziWtHGTMsUdyQc7UrmBkw3OR?=
 =?us-ascii?Q?MWod6xexWsYWEE6CJyXJFnjrAoUH3uq3CX5Ud1hlhQgTHTCYpB8YwNhY3uAo?=
 =?us-ascii?Q?RiCI9d7bVEkC5qmuqKjvSoWteoGymv2YHB9sJYlpQCYU4cSYnmJJTYb4yLON?=
 =?us-ascii?Q?kAWnjLJh7FE32vjBKVA3FCqqrJT7zpXBmD0RH0gKpd5LxmNxMDpy3p8kRrpm?=
 =?us-ascii?Q?9JhLNOfDXcXD9OMiYszhM0+zIUPHmWIFKjarWfRxrPyaGeg6zwD857EeGufp?=
 =?us-ascii?Q?Afao3KrKmrr3r4ctQlyjLWXQgEesWxHukvsNKuwuXvJfufF5WgJKBvCYrlag?=
 =?us-ascii?Q?Wvv61dlPjl+4X8mR6f3sI8z1zHfGUQL4F+9egQVLqhwSrn20bKkRvVCTeXMk?=
 =?us-ascii?Q?zlkFHjwG9TAcXwHZPfzsjVY3gcg7AJRMIkK7vYMHEgpPgDaoA2UtA6pwQquH?=
 =?us-ascii?Q?T2mtG8sCx263b6s5k/lOxj68MGfwPAJckOqsC1J87qVu24BAahtM/tEwGlnF?=
 =?us-ascii?Q?jk0WdeY3QhU1VxBH0/TlKbDM5uSsnv45lEqt6CeV4AyibBj9F/Ggp3bRwEWN?=
 =?us-ascii?Q?3DPOuS/HVH2eCGy2YWryyC/wZqzWni57q+Shi8RIFH58A8TxCcFa/+5gTxXa?=
 =?us-ascii?Q?6ssOGZjLLqeDZncAAeP3b98r97E1DPsBcW2rbqJIxyg8GWHyLXdCM4MVgyAl?=
 =?us-ascii?Q?cAuP8WjyJSdW8dgira01eewx43ibElTopRiHSETAUrBGGYKYfFluoGkSvuLT?=
 =?us-ascii?Q?SWuG4I68hYKrpoaHVhnrJJUJVZ9KEO9A8DW9rab/Sr1WZ1gitesACE5YUuuM?=
 =?us-ascii?Q?10DOx6NRHdAMi8PRjOk+y1qytY/Fa1aRWMNvv9ZR4qix1nx1+j5cbxbKa8oa?=
 =?us-ascii?Q?qitLFr59F1mr+49CTnd311aw5fddP1/74ezws0hXSY5suhIknAFeyPFaWb0f?=
 =?us-ascii?Q?TAUnHx6X2bo5CULOxK0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rIH0T1rPELhFR7iZ9PoSW07aPgEY3/xZ8bruwYINbatH6wzBz+Uc6XdOCGV9?=
 =?us-ascii?Q?ZQ8CFYf7fPzPQV/gLLB9nNwhncDcWy1/E7DCAgPCL7ZxuZhEAWOy4oVDU+ZG?=
 =?us-ascii?Q?1uH/kpzut5oUgPNYP0nPNGMfXC5KV7EfmliZBxZ3VT2Lio4wRJC16jEIva/j?=
 =?us-ascii?Q?ACvgnLAYTuOay1dP8yL6bnwFHpvFMjjWfMhoNdBlVQ+BK1l5TC6Ma6iJY0Jq?=
 =?us-ascii?Q?Kk2AzuGxhaj6VQWM42g/xkddy1rF39/Jd9MX/Wd36SMDFap96tsIcRNTZaJ3?=
 =?us-ascii?Q?8LrKNylnLGlk/eLTeTMF8HAXh/keRER8ThjGTtYi9Yak6fGxQQDQj0EUX7pv?=
 =?us-ascii?Q?HLdnpNxRmyg601/qSHvZ1DK2D8s63MiEYEySRo2BnWz+dVMN+ceXVbjDfbAq?=
 =?us-ascii?Q?0OW/SkTvAGSWzdpMQOThcKoMnqenACbfWpeMmswMuw4q7CylxR8EXYOUxf71?=
 =?us-ascii?Q?UGpST12uz4vzCMBo6dxP94VbqwUo/o8V94GnMcXJx73wZtcprHibX+f6IRw4?=
 =?us-ascii?Q?2T7gHIOxv3pmYimA+fDWOgiDv/jwceMI69ZqXgfJ8ER5pr2tukQmAcJVjRrb?=
 =?us-ascii?Q?G/uyPH2UfYrAyEZdGBQP0Ge/fpBZ7RNr5J9ypn/MJqVxwev3xZYMONWqZyR1?=
 =?us-ascii?Q?j+zp4GiCXLIsCQme093zdRJm0Ozbs0BFVctcBlwktob6GZMoTQuS92pUP4qm?=
 =?us-ascii?Q?n9njEv+TLR4J72qDaycxZ0bUVD0kpY9q4bjnawFpG1IaMX1tKS69Yl8D7/Zc?=
 =?us-ascii?Q?esTSaGeh6qoQHJH9+WJP2ydtcR3eqP0SVv8FHG9uiu6KzF8/BFJ+fFqs9ktv?=
 =?us-ascii?Q?0udxNmAm78m4R4FVjTJpF1QujR7z8cFnuSEFk684m0r4octFPf+l+sQiiena?=
 =?us-ascii?Q?dFsvnYUb+2Mk5fpENjbXKkqUikqWqNNJe4sdv51mw31eH4OJ+dV6Spi7fCtz?=
 =?us-ascii?Q?XkZb/j4Uz4tCRACUc6UuI3LiSCxeSuWHgM925zlB/v0OPbBQyGb7RD7pRnCs?=
 =?us-ascii?Q?nYmkLiO27N9mCH/99mPxBgQbMzOCYSwpnQWZsO1LLpwvU+De+HbIelvx5Z6S?=
 =?us-ascii?Q?Yw+yfO9RNqsyz4pcMou0x++LZXWj9dRkJrikc0yDaN4BK4kKH1cf06ZwUqsr?=
 =?us-ascii?Q?Oc+EHhvXSKrQKLOR70qOD8ANe0EaGn5BYvtqLSOQ0ZKiV+nFcuIGl05n0Tom?=
 =?us-ascii?Q?JujlJ8GEFgaxV56MjdVDnBKMJi8ylbOBf1WiKT0Pn9ttyUoFRg9Wkl6RKQJm?=
 =?us-ascii?Q?U916JuZtkmHPL/QuKlV1NkOkMikGz0t4nDiscSlNGxYnwVWVkCJS3ZM3n0SW?=
 =?us-ascii?Q?Tyi9pCa8o04U0GoOm8nmz0WshPh/l3ZaAjM7JD5GDY40brS5zp49JNuBc2Rn?=
 =?us-ascii?Q?LoDdiXv3NjmcKmScytFK0HB90pIjqKv+nZ1d41Jq7O4sbY3f9BOLyG7EAAsf?=
 =?us-ascii?Q?g7odKSmxjJPXaTHg9folorPLJq5D6JDVDhxf85FKtz/OS0XYR0JTHsSynxlp?=
 =?us-ascii?Q?lWsS06IhtVY9gLi0UXsGgK0Ui5WD5HhPwlbTzpcKRBzGeAj2ZYkoQcRT203w?=
 =?us-ascii?Q?BaYHrRem1X6K2hpNYe5P/fGFlwx3C+xwHWkpw3krH85j1AHrCGTCxhQ4NHmk?=
 =?us-ascii?Q?6jmXNnAxaAuJ8wVuWrYtrDKtNMdeykTzzBmDzvObCH17mKG9kTl2GxanOSyi?=
 =?us-ascii?Q?8wuWeLz6eDJVzM1/mmfFJ90BBT7Uitqyze4R7U1VUwAr3kB5CuWmb3Jqgi+Y?=
 =?us-ascii?Q?u1VTuuaMLA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	aeTYscLVyCSeqVyEGD2W41yq5bXMFnwmViIy/JSuhbQn3wA8YIiyewLabaiBN6Lf6Oz5Rw0s2DgRvMRlToNA6cCFjFzbgas4em2+9IcEITnCRdBvGh1XaO87mBPujgvu9HvWnAkfoEMBefYk5NkeMXulz5ZD6i7NXuQ+h1+FzI1J2SmxcRO0Fd/bLeMsJnmqnK8Llt9ez3zfsrStz9D1VIZxzzaYfVXodv7Fx2c2kyJmi+1+2/mfhoVRrjlTlPjZZgnGNThfaA0F97weUjxTKTJHcw/XBYmbeFFDB5fPyPefF7SPcu/aakOVx5/9ndMo0kvwsw93D1Cvxi6SAR68Byk1E0JE/4AM5eZmWbP5cRLTreFDyaKZ77qH9lVkUI/tjVotPGC/B2nPwLx4EqPR0EvwLuwnd0LC1CppqyeZWhb4X0Dk2fV1SLpnDk6gg2ydeDZFKLr/Hx+Q4PUUE7MpX3R5MrfPdyH5rBn01VipsdAF0V/P2zrkMCEM1bsgpScw78T2XmjyN1yCxEaNZYQZODbU8y1L672vYzoHEio61CFy7ebDFBWLmFdYfN5gv8xBxxAeCZ1jCuwaKeR8L6LevK+2z6Wp5MpDfk75t1YRRwQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf8096e5-b991-48fb-b392-08de6042a8fe
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2026 21:00:55.4402
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TGoMNxi/SB61uJ8m/EEJCu8xDugqeN/FsWEf+Y5Axq2+DGKNbceNrYOALb8HDA2TGaiWui958kREg2PoFOvO/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR10MB8061
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-30_03,2026-01-30_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2601300172
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTMwMDE3MyBTYWx0ZWRfX9ewmtJlbAS/X
 rAUjbHitCcbcuXIWkCjSl9VsGwPolc5YD9843l1LNbN7Lw9ZSMXEsXFX5yt0ei/LCKyDaBxa6T1
 M51O74pgn4Q6+IdH3yiA42LPgpEhdtNYUR2PQWk17Ov5Mdfjc5sHETRKECfNKOOtTbIx0AB3hDC
 8HA8Abjrq6bItpZjHK0LorAtb8Ev4XqgYrbH6LB7o57RmVDvw+pfC0+BXlsi80Y163R1kBqit/S
 ptIkPbWQA3cF2SIKy6Y0jZundY+g0ge4ldIDFwZuk2jbEPrR2hOPzHPIHkge7GafO26e1HUwCje
 RcdzDvzhSXvc9/keGe/PG0yeM1OuuUX5eEHJPYoHHSQLbZNuJVnxRT0UpQ1ZdSmsuZL5B6idw+5
 gDBby7JFwkFl/hFTrjXr7IeNpXhjAnY/wITle9sRFDuWl0Ce8ULarQTiCqyXdx4vSKVQdhZFJBo
 d0MopvJnmu0MHOdMBsg==
X-Proofpoint-GUID: AUJXLc99nFP_zyLcuWX-PvWQas_ztOnS
X-Authority-Analysis: v=2.4 cv=M/FA6iws c=1 sm=1 tr=0 ts=697d1c0b cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=fZ5cR1aKDUsyH-17_CgA:9
X-Proofpoint-ORIG-GUID: AUJXLc99nFP_zyLcuWX-PvWQas_ztOnS
X-Rspamd-Queue-Id: 37BF9C000E
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: hka73yjgob8mydct3n4ge56no9e5aka4
X-HE-Tag: 1769806866-986168
X-HE-Meta: U2FsdGVkX1+Km9bKoFrY7XbA3UDHSBwkTBDFvIma40q3quMG3UCqCVcdLVe2CIZMX5oSuD2j972zs9EjOyu7C2DReNrXqj1Dgl3NPGHcpjsRLwCkHjeMXiPwmg05g2P1636JL0V/zgpSnMgQvqErGPKSmhbuyDyPuct5D5oM4ZQU/iAJKiTJ3ctqaaVLtlGUPlMNkEd1977Zgff1ZTFsgEU1zYK8fE5B6qNaEOiQolcAuhyTLJiivjNvFlf8JIsPCI20ka1rH03LeopD7i6ILFKSrQ+m1ak48qxl0YtkxVttgDCX/h1/luKwJ4PNenIfG5CSLTMaRF2h93+xnspNCECXui3tDSYWt6k1r0WCSNfmILCbvvzMkRW10iQbAy2dxo14cbZ1xR2B3ylk1fFrJmRY97l4btwALmLVba/EiQpMV5s/9mUcQQy2togL9x7tzDKXvFUjig9T9tJRbh8yk87m4DDMXoT47tPnGjQJxqzUKP1L5XMfd+pn7bHd7NN2VrXZVTOLCBkSoU/olU0hCQk/VyA6jYzzMrNoS8qQmeQofKRiAnfVX0TlKOwZUTDgUh1BrHKdVAbC3pZJroHTeOM0KVky/lfXAG1oz8gnMb8QVUDftbFOGTNYjm/GJ30KhRmNR3b3y0u9ul7a3MV10anpuYRTacumNRdIgj1Y55Qgf5rC/BarBzIL+O6jvC8g1LGZuJYAfwd8u+HQzjh/I0c5TojRT0uYl1z5ZjKpSsQvin4cv6Hs+TEnraxYOa+PibZiPmJHJvOfYSufqTadGsyIL02uWPVxiE5I+WUzH8TXUJgkYIaSgBlbJvVbuh9dDqsXr2OtaYCkS9IFZBbxu+TEBB9bhhOBXNMgnwffT7s67sHNdorlVLTjBg6AbmmQNn3W031+7uwlN2opg1YweMRlZpIaJp6ciSbM5hQP01yR7okWGNlMgOmi9zV7jp/j+2EMumr2CFOff4MM9wt
 QIbbcw2W
 G2ZWv+w15vnCVrlKFuiM5maFrgstc2VDNq/Vvt6925TmJRg5iVNf0AwuMVkh2LjrltsYq5l5HGqVZ6BH2s3lUiUla46lGFgnea8+NZp6fXRks7ih6SKhJJ7oDV28KrGHHqP93F1iVHIP4fRNr3o4s+LJshwNs/TqtFnSd4T4rRXUgE/BWgN7iMxtHEIRMZAtlrBIgv4vZNXrwaKQxzgjo34gPJGR7Gr4Px+NdEo8saCv/dn+LWxE6hgH3KhdOgI60P9TiHKgKwNbIY8Ohcobh8TsDnG67dmT0XyBravEOKj8lMgvXDBLwHp+qrnDLbHjYkwucJ2cbc5RMseVz8Tk/PRSCmKpJWtIHTB4W6l/0ISwFQw+ryDn9S4Bvud0NSwZIIFOK53e9eahZJCJMbbFSpJs3ZRV+/+9cm0DE+dbkEQ7z/r50xCTOVXbtY7Ej2zFV3ZaSUXUMch6thVT2BLkWOLqSJhv/ZW3T4W5UCHZYBYMPkhDmBexLbChIwvcITXMFkZ+fbz/zKTeoiexGg7AkIgnm6JEu+qpytD8vvmAxCZtAnxS8x5/taK6VSyJ2888BEBl986cbQLJaVFdIlhR0SVmvtp3F3UNRBoJXFG7SGTgzudtN0Ww/GxRs2O+k+yYROtajbIoPVfzXq399DhGKdyORiA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Instead of using the maple big node, use the maple copy node for reduced
stack usage and aligning with mas_wr_rebalance() and
mas_wr_spanning_store().

Splitting a node is similar to rebalancing, but a new evaluation of when
to ascend is needed.  The only other difference is that the data is
pushed and never rebalanced at each level.

The testing must also align with the changes to this commit to ensure
the test suite continues to pass.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c                 | 99 ++++++++++++++++++++++++++++++--
 lib/test_maple_tree.c            | 55 ++++++++++++++----
 tools/testing/radix-tree/maple.c | 11 ++++
 3 files changed, 149 insertions(+), 16 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index f04989f8a115e..5813ad17ea6fe 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -4542,19 +4542,106 @@ static inline void mas_wr_append(struct ma_wr_state *wr_mas,
 	trace_ma_write(TP_FCT, mas, new_end, wr_mas->entry);
 }
 
+/*
+ * split_ascend() - See if a split operation has to keep walking up the tree
+ * @cp: The maple_copy node
+ * @wr_mas: The maple write state
+ * @sib: the maple state of the sibling
+ *
+ * Return: true if another split operation on the next level is needed, false
+ * otherwise
+ */
+static inline bool split_ascend(struct maple_copy *cp,
+		struct ma_wr_state *wr_mas, struct ma_state *sib,
+		struct ma_state *parent)
+{
+	struct ma_state *mas;
+	unsigned long min, max;
+
+	mas = wr_mas->mas;
+	min = mas->min; /* push right, or normal split */
+	max = mas->max;
+	wr_mas->offset_end = parent->offset;
+	if (sib->end) {
+		if (sib->max < mas->min) {
+			min = sib->min; /* push left */
+			parent->offset--;
+		} else {
+			max = sib->max; /* push right */
+			wr_mas->offset_end++;
+		}
+	}
+
+	cp_dst_to_slots(cp, min, max, mas);
+	if (cp_is_new_root(cp, mas))
+		return false;
+
+	if (cp_converged(cp, mas, sib))
+		return false;
+
+	cp->height++;
+	copy_tree_location(parent, mas);
+	wr_mas_setup(wr_mas, mas);
+	return true;
+}
+
+/*
+ * split_data() - Calculate the @cp data, populate @sib if the data can be
+ * pushed into a sibling.
+ * @cp: The maple copy node
+ * @wr_mas: The left write maple state
+ * @sib: The maple state of the sibling.
+ *
+ * Note: @cp->data is a size and not indexed by 0. @sib->end may be set to 0 to
+ * indicate it will not be used.
+ *
+ */
+static inline void split_data(struct maple_copy *cp,
+		struct ma_wr_state *wr_mas, struct ma_state *sib,
+		struct ma_state *parent)
+{
+	cp_data_calc(cp, wr_mas, wr_mas);
+	if (cp->data <= mt_slots[wr_mas->type]) {
+		sib->end = 0;
+		return;
+	}
+
+	push_data_sib(cp, wr_mas->mas, sib, parent);
+	if (sib->end)
+		cp->data += sib->end + 1;
+}
+
 /*
  * mas_wr_split() - Expand one node into two
  * @wr_mas: The write maple state
  */
-static noinline_for_kasan void mas_wr_split(struct ma_wr_state *wr_mas)
+static void mas_wr_split(struct ma_wr_state *wr_mas)
 {
-	struct maple_big_node b_node;
+	struct maple_enode *old_enode;
+	struct ma_state parent;
+	struct ma_state *mas;
+	struct maple_copy cp;
+	struct ma_state sib;
 
+	mas = wr_mas->mas;
 	trace_ma_write(TP_FCT, wr_mas->mas, 0, wr_mas->entry);
-	memset(&b_node, 0, sizeof(struct maple_big_node));
-	mas_store_b_node(wr_mas, &b_node, wr_mas->offset_end);
-	WARN_ON_ONCE(wr_mas->mas->store_type != wr_split_store);
-	return mas_split(wr_mas->mas, &b_node);
+	parent = *mas;
+	cp_leaf_init(&cp, mas, wr_mas, wr_mas);
+	do {
+		if (!mte_is_root(parent.node)) {
+			mas_ascend(&parent);
+			parent.end = mas_data_end(&parent);
+		}
+		split_data(&cp, wr_mas, &sib, &parent);
+		multi_src_setup(&cp, wr_mas, wr_mas, &sib);
+		dst_setup(&cp, mas, wr_mas->type);
+		cp_data_write(&cp, mas);
+	} while (split_ascend(&cp, wr_mas, &sib, &parent));
+
+	old_enode = mas->node;
+	mas->node = mt_slot_locked(mas->tree, cp.slot, 0);
+	mas_wmb_replace(mas, old_enode, cp.height);
+	mtree_range_walk(mas);
 }
 
 /*
diff --git a/lib/test_maple_tree.c b/lib/test_maple_tree.c
index a182e48b5f5e6..434d8a2fdd99c 100644
--- a/lib/test_maple_tree.c
+++ b/lib/test_maple_tree.c
@@ -1024,6 +1024,7 @@ static noinline void __init check_ranges(struct maple_tree *mt)
 	mt_set_non_kernel(10);
 	check_store_range(mt, r[10], r[11], xa_mk_value(r[10]), 0);
 	MT_BUG_ON(mt, !mt_height(mt));
+	mt_validate(mt);
 	mtree_destroy(mt);
 
 	/* Create tree of 1-200 */
@@ -1031,11 +1032,13 @@ static noinline void __init check_ranges(struct maple_tree *mt)
 	/* Store 45-168 */
 	check_store_range(mt, r[10], r[11], xa_mk_value(r[10]), 0);
 	MT_BUG_ON(mt, !mt_height(mt));
+	mt_validate(mt);
 	mtree_destroy(mt);
 
 	check_seq(mt, 30, false);
 	check_store_range(mt, 6, 18, xa_mk_value(6), 0);
 	MT_BUG_ON(mt, !mt_height(mt));
+	mt_validate(mt);
 	mtree_destroy(mt);
 
 	/* Overwrite across multiple levels. */
@@ -1061,6 +1064,7 @@ static noinline void __init check_ranges(struct maple_tree *mt)
 	check_load(mt, r[13] + 1, xa_mk_value(r[13] + 1));
 	check_load(mt, 135, NULL);
 	check_load(mt, 140, NULL);
+	mt_validate(mt);
 	mt_set_non_kernel(0);
 	MT_BUG_ON(mt, !mt_height(mt));
 	mtree_destroy(mt);
@@ -1285,14 +1289,20 @@ static noinline void __init check_ranges(struct maple_tree *mt)
 		MT_BUG_ON(mt, mt_height(mt) >= 4);
 	}
 	/*  Cause a 3 child split all the way up the tree. */
-	for (i = 5; i < 215; i += 10)
+	for (i = 5; i < 215; i += 10) {
 		check_store_range(mt, 11450 + i, 11450 + i + 1, NULL, 0);
-	for (i = 5; i < 65; i += 10)
+		mt_validate(mt);
+	}
+	for (i = 5; i < 65; i += 10) {
 		check_store_range(mt, 11770 + i, 11770 + i + 1, NULL, 0);
+		mt_validate(mt);
+	}
 
 	MT_BUG_ON(mt, mt_height(mt) >= 4);
-	for (i = 5; i < 45; i += 10)
+	for (i = 5; i < 45; i += 10) {
 		check_store_range(mt, 11700 + i, 11700 + i + 1, NULL, 0);
+		mt_validate(mt);
+	}
 	if (!MAPLE_32BIT)
 		MT_BUG_ON(mt, mt_height(mt) < 4);
 	mtree_destroy(mt);
@@ -1304,17 +1314,42 @@ static noinline void __init check_ranges(struct maple_tree *mt)
 		val2 = (i+1)*10;
 		check_store_range(mt, val, val2, xa_mk_value(val), 0);
 		MT_BUG_ON(mt, mt_height(mt) >= 4);
+		mt_validate(mt);
+	}
+	/* Fill parents and leaves before split. */
+	val = 7660;
+	for (i = 5; i < 490; i += 5) {
+		val += 5;
+		check_store_range(mt, val, val + 1, NULL, 0);
+		mt_validate(mt);
+		MT_BUG_ON(mt, mt_height(mt) >= 4);
 	}
+
+	val = 9460;
 	/* Fill parents and leaves before split. */
-	for (i = 5; i < 455; i += 10)
-		check_store_range(mt, 7800 + i, 7800 + i + 1, NULL, 0);
+	for (i = 1; i < 10; i++) {
+		val++;
+		check_store_range(mt, val, val + 1, xa_mk_value(val), 0);
+		mt_validate(mt);
+	}
 
-	for (i = 1; i < 16; i++)
-		check_store_range(mt, 8185 + i, 8185 + i + 1,
-				  xa_mk_value(8185+i), 0);
-	MT_BUG_ON(mt, mt_height(mt) >= 4);
+	val = 8000;
+	for (i = 1; i < 14; i++) {
+		val++;
+		check_store_range(mt, val, val + 1, xa_mk_value(val), 0);
+		mt_validate(mt);
+	}
+
+
+	check_store_range(mt, 8051, 8051, xa_mk_value(8081), 0);
+	check_store_range(mt, 8052, 8052, xa_mk_value(8082), 0);
+	check_store_range(mt, 8083, 8083, xa_mk_value(8083), 0);
+	check_store_range(mt, 8084, 8084, xa_mk_value(8084), 0);
+	check_store_range(mt, 8085, 8085, xa_mk_value(8085), 0);
 	/* triple split across multiple levels. */
-	check_store_range(mt, 8184, 8184, xa_mk_value(8184), 0);
+	check_store_range(mt, 8099, 8100, xa_mk_value(1), 0);
+
+	mt_validate(mt);
 	if (!MAPLE_32BIT)
 		MT_BUG_ON(mt, mt_height(mt) != 4);
 }
diff --git a/tools/testing/radix-tree/maple.c b/tools/testing/radix-tree/maple.c
index 5ea45d67556a8..feedd5ab7058f 100644
--- a/tools/testing/radix-tree/maple.c
+++ b/tools/testing/radix-tree/maple.c
@@ -35406,7 +35406,18 @@ static noinline void __init check_spanning_write(struct maple_tree *mt)
 	mt_init_flags(mt, MT_FLAGS_ALLOC_RANGE);
 	for (i = 0; i <= max; i++)
 		mtree_test_store_range(mt, i * 10, i * 10 + 5, &i);
+
 	mtree_lock(mt);
+	if (MAPLE_32BIT) {
+		i = 47811;
+		do {
+			mas_set(&mas, i);
+			mas_store_gfp(&mas, check_spanning_write, GFP_KERNEL);
+			i++;
+			mas_ascend(&mas);
+		} while (mas_data_end(&mas) < mt_slot_count(mas.node) - 1);
+	}
+
 	mas_set(&mas, 47606);
 	mas_store_gfp(&mas, check_spanning_write, GFP_KERNEL);
 	mas_set(&mas, 47607);
-- 
2.47.3


