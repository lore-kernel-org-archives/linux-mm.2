Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AED0EA8114
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 13:39:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C0966B0005; Tue, 10 Feb 2026 08:39:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36E476B0088; Tue, 10 Feb 2026 08:39:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F1936B0089; Tue, 10 Feb 2026 08:39:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0B3886B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 08:39:43 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9930913B40E
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 13:39:42 +0000 (UTC)
X-FDA: 84428654604.22.16AC75D
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf17.hostedemail.com (Postfix) with ESMTP id 407FA40006
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 13:39:38 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=qTqgScCs;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=U6pt215Y;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770730779; a=rsa-sha256;
	cv=pass;
	b=m9VgUdqgCdgt+Rh46blCHoJAVGg4ewuKJLy4b0NQNcwZEIT3unr5Lepbt4axo7Zi683YYB
	Lui+1E/8LfIISm/Ek8Ws18Heh0Kz34191esLjhDX0b294jfk4FhXmi9hiwphtsauXgTDY1
	Qtvh9ZyK9r7jHAW4YNs2Z6HQEKb9oXc=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=qTqgScCs;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=U6pt215Y;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770730779;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H3xcLCo+3USPPh3qMJ19pWSfNakr1cO9JgsQR1Otp70=;
	b=oRr8QPRSBdEcoKYXlW6o7yXeNTOoQcrCwrW8pl4aNUimI+1NzhLXynYDcQJKSg7YmN2NTk
	nHto7G+UkFnQ/JZsxrW0dyMJ+UIzIK7evGyiEsj4Mqc+4bRI2FLE6zjUC8Vd9Ps6nIrjfD
	MLVubCGn6znhl9X65vwacrjIO/c/SCk=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61A9v8o53796717;
	Tue, 10 Feb 2026 13:39:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=H3xcLCo+3USPPh3qMJ
	19pWSfNakr1cO9JgsQR1Otp70=; b=qTqgScCsyLf6LJzFF5o9HfIXFvoLuQfBm7
	Bs8y8MjRf9Ydig/W82mH51mDHnlsbwNw56rPP233mCKHVrdCMVbW5uFL2inlMPMd
	4H4ReqJeOa5MlNNMHQEhmuLY5Aa4wNFXUO7ci8OMFiyvy271PRFI+fc6Ro/p7XkM
	JBhfAwimjyLgOjsXDv9OMlO/x81tKDZcimMrJdDSk9Hcar8enZbEjAPk2gYk5WNJ
	RTUC+NAQ1OcSdD/0XpOJf5o+xXzq/fzfJ99zU0ZCNCeCDwrZVyi3y2L+udGzzUUt
	HjiKhZMEvHX5IziX/1UzhlOaAJY1yLeQWHY0+tGpnzbF3NX6aTcg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c7s7rry3g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Feb 2026 13:39:26 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61ACDSPm030099;
	Tue, 10 Feb 2026 13:39:25 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011015.outbound.protection.outlook.com [40.93.194.15])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4c82281n4a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Feb 2026 13:39:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tCHgaTpEVb2IK6mHB1nfwnMlK6hTQcIyE9GxvVrXzzric8wtxgAq4tzBPcOoWSvBOzKhmooEdKvRQa0F5BVQkC6Jnd4bKa9T0mM+GdH2TF2tbsObBEJTKFY3pZ1an/FeTP4Z59HWdLeeGzycLWmPK70G83eTREr1ScwW9GiQrNV4XmLaqFRWLvQzj618n0IGNvxT6d8maZLBIYURoD1VedeJJAro4NrGZuX/ByeV8INUaaCY+rgfP0/a7hgcnlr2gpXjg4YBQeE4yXWEV+TMAIsm1PIdgQ1lCr2eeJ5HCb7w2d2iseW7DGvtPvZ1601t5bhCQfDZdEKPNJrSC+cV2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H3xcLCo+3USPPh3qMJ19pWSfNakr1cO9JgsQR1Otp70=;
 b=Dy/5K0ts1endUBzEUCuAkAOo5F2Dsmum7OX80Y1D/CYMwy42cXo4j1NPhZGyKDDfdw9lxSo9McVL6Z8b0R4RmTTS8U+FjgtHXI2tVCSTxPAsWkMTWgt1MCBxrzNluZGfhGA1EqVuyqsl5kSFlc5lr6m5F5ZgnJPPReyMp+r24zECc7etf29gpNWQxY0Xtq5HpLeUZ2sIblT995NGXQ/ndz6nkBeO3UROJzXCJJQJfIN9n91cBvgAzFLRKJNw5ykAlthLChq9MwV6osAsukESmPE16YVZ6ugOvjAolVd5gXjY+tUUhL54kP7SZJ7C325NfzNtI4DXZXOZqcpydFdKsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H3xcLCo+3USPPh3qMJ19pWSfNakr1cO9JgsQR1Otp70=;
 b=U6pt215Y+3aTFrwbWvg3bKtac3Eix0OlnndrnKlLR2bZfxxtQnnViLILPhhRZ8klDpvEr/GIKJrOW5ql6rA26t3qL16FgVYj09GAEgpIDKsKySUhl1YSER+XWthVIci05IwWO5aMq5XpVe0Yl48atXrNyfvGm6E/eVFCw8UZiEE=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CH2PR10MB4152.namprd10.prod.outlook.com (2603:10b6:610:79::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.18; Tue, 10 Feb
 2026 13:39:22 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%4]) with mapi id 15.20.9587.017; Tue, 10 Feb 2026
 13:39:22 +0000
Date: Tue, 10 Feb 2026 13:39:20 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Dev Jain <dev.jain@arm.com>
Cc: Matthew Wilcox <willy@infradead.org>, akpm@linux-foundation.org,
        david@kernel.org, Liam.Howlett@oracle.com, vbabka@suse.cz,
        rppt@kernel.org, surenb@google.com, mhocko@suse.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org, ryan.roberts@arm.com,
        anshuman.khandual@arm.com, kirill@shutemov.name
Subject: Re: [PATCH] mm: map maximum pages possible in finish_fault
Message-ID: <0c956b6c-1d75-48f0-b55c-ae9887dce79f@lucifer.local>
References: <20260206135648.38164-1-dev.jain@arm.com>
 <aYYHGisOQFQINXwR@casper.infradead.org>
 <397482e7-3c89-48e5-9e8c-0798ac92cc05@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <397482e7-3c89-48e5-9e8c-0798ac92cc05@arm.com>
X-ClientProxiedBy: LO2P265CA0454.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:e::34) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CH2PR10MB4152:EE_
X-MS-Office365-Filtering-Correlation-Id: b9af86fd-09b8-4494-28d8-08de68a9cc4b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Qm5E4MD3dq7i3gkHUx3JCgakQN3m9hkzzUJM/WxAfUZ4ks967nfoLe4l1kgh?=
 =?us-ascii?Q?yNgyiyaEGyFxljN7CQ8tgdT9d9auzlw8x6bds6b2JAui+0NeBVB2en9qSJ2u?=
 =?us-ascii?Q?AGesu0aMD5JtaIMxlVey0XYxNlaDU79zwWGWCL3Ls91psxMcD61Yvn1YfdTm?=
 =?us-ascii?Q?4G+nbipJrUvyzy6hlvIka4ZN0K6oCknNKg/mYDV4X+9SgelJ6RAqes5ZNeyQ?=
 =?us-ascii?Q?GUfTmdj9cJCqaUuk3vvultRtPVR8F8fvuqhogJhZt0BZOWJKASGtGbvMHj0n?=
 =?us-ascii?Q?3F49KJdf5N7rex8Gt+Fjm7JrvBF016QBgD7Sc/+WUYlpmExqaQdPwtJs8eyh?=
 =?us-ascii?Q?+yOdUPUyOAQtw96a3PErAllESdd5yI9RZLRPI1/i69FwyTcH5gJMAACxCg3B?=
 =?us-ascii?Q?qDUqiU/sk4BNJURq8/iuTiBI0kXMhNUKOs0ng7roKixtZtw8n0A8LmL3aX19?=
 =?us-ascii?Q?syHd5vP81VQCY0GyUebiVeSFnmpS4cR+8sI1/nOYC1iH9nAsCTRxI34mSQZM?=
 =?us-ascii?Q?JcP/yxsxgwi9cNkQhmjR7/A7whZCNM1r92tzw5D3K37gsKDhc58cUG7ytDAI?=
 =?us-ascii?Q?d8rqSijjP7z2hY1cMSWTB0fQSEm7Mvn5loAjTVwpxx/CzT3T8eE4piAh65c0?=
 =?us-ascii?Q?m73muDmtSgmpH4DW/G+u0NNNYIP/wHRR21GVgYH944EZEFbz1ZK3yq3BJqUt?=
 =?us-ascii?Q?ldfxXUUjaia/A5TzAyWORkhp3IHY7WcEC/5tG+KmYgjZKe04BUBRsDYmTPK4?=
 =?us-ascii?Q?gs9KA5AIeOGXBv3dV+UazNrE+sEAy0EWoQC2kXpUE9bdjO8TVyOifundD0wW?=
 =?us-ascii?Q?8beY4qqfZbL1lp//zBRiiH4fBYpxMIuLu648u9t1dK5Wd+GDZ6jbSc97NdUC?=
 =?us-ascii?Q?xdJbzdLKP/2hGydjc/hqhvQxc0efwS3YmJ4GjKA/Oi1tpwKYWagUw9mfBvuI?=
 =?us-ascii?Q?nsjv/QtI4Zn5aCCnIuIMX6JE6Aa67Gc2Z+PIHTIfbF//2bu8HZIjF+E1js+Q?=
 =?us-ascii?Q?cjqS/bOo8iVCxsGuguXNyOr/D+TH+Qvce2XmZRdvpyhfH+HnY5cIU2qulLjT?=
 =?us-ascii?Q?hLXmJY6AfxKOsgmJZqRDZ1385GxqmCYTqzrqvMa50XaQwCjxAq/quX0W4u9i?=
 =?us-ascii?Q?puM8SY8Hw+KvTEIEFcQAKzxfY5yaiEIBt0eU8dspfA2NCry4L5yqYR2wAzTr?=
 =?us-ascii?Q?+dx5eXomam22t61bdIRc+dWUDJw2m4tsJc5t++b/eWvs4einuLq6E0lDb4ey?=
 =?us-ascii?Q?QkMymjI28oCTD4Y8Q5FkIe4n3eBFxOLXFR0U5kFFsioO3qWmwK7HaQvbnoTa?=
 =?us-ascii?Q?uK4C+emLNiBp/TGzsIegBjCIZ00p8hOW/pgJipr/kHiXDIdiuV+5AXcLUexC?=
 =?us-ascii?Q?bT5gTCZTDdSHjWeLQcctbcqO7UZawn8xNyOFOelyp79Pp85/O0yew3InHO6f?=
 =?us-ascii?Q?ruI6txy6X2weXPI9/Plhxp8Yau+EA+QgCdqSkODySP0GbZt9T2CBAGNFcRlp?=
 =?us-ascii?Q?v5rFYG4MjuN6u24r9I/IY/dldMsZ6rgz34X6aYpKHmxW1t3RfmoMBLWB+JB0?=
 =?us-ascii?Q?HITyCqAIHYI5gK3fJQQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KfO1R0jg5FVpXH7bzxzY9kllYAt1JN1uCFCDWJ27Kvrm6RdXAuUBlhUV6JgU?=
 =?us-ascii?Q?8cUzK3+1vDbGR5zAVKIFVBuZTtXUDDP7QrN+yCuQbYIogapA92UQ8HlqQucR?=
 =?us-ascii?Q?tHY/eEBl7Xf3XPO3DhDJRgBxxjhoaQW0SYOV1S/xnQUz2jSD64KRVyivICcJ?=
 =?us-ascii?Q?N766EyIr0/AuQEuJDaXpZwiIJ8kSlCThDEU1UH3p/C9NQR2FtE7MZM1QopJP?=
 =?us-ascii?Q?QdjHUWnJEwSKMPKQFPRpf2e6rQMTtSActFiHGBzKcfFiURnJgmxinfQJNaYV?=
 =?us-ascii?Q?kSqULrNmDn/Fi4o5QrGOE3ER2a7XV7PDeYjCK/X2I+8F+yASYEijTXd5RmD+?=
 =?us-ascii?Q?arrNZD/XXjcgl7jWsN1MWL07wWRWWi0bxmwYqLWMXfBPn0n9pj93L47hw2vL?=
 =?us-ascii?Q?NZ+gCXaEAwIzYb0xHmYL8EZxK7iLh0Xkyw8fwQ93tE7Z7XaWPHdxtcO00qEr?=
 =?us-ascii?Q?9oXiG60BikYJ3Fv7qoqklnAV9j8O+j5fMZbFxoBcv6xFvjkWacliD/pia+Cw?=
 =?us-ascii?Q?gcXRr5Wx/DtGvfiZ7bUVM2efjls08j5itMlGshcM2NIlvChvoNfSnSVluMKK?=
 =?us-ascii?Q?D+2kLAQKDhocOWqvBEpNKtoCKqfiiittU+Zm/r/KOV2pXXB3SWkXViOIZpUU?=
 =?us-ascii?Q?PzUNEZADHJ7Y/FM+VunHYT7qFaZikVdI4Lki4OeMJhz9BwECDeajRfh6CrBI?=
 =?us-ascii?Q?vpAVi065Et57uZgdhwXkX5EdI+dVK5Tjr1cVLsLjIaF1tcDMaTQn7EyuThKX?=
 =?us-ascii?Q?UqXrFVP+F2Es3POVZDYxaQtZWRUCSC4sQ7cJ5NQPKdjeEyGJZ4YdbZt5Hqku?=
 =?us-ascii?Q?5CqugZBrONLqDLGPVHkajgioP0IqCQduFi5dGgWL1xjmmG6GoylmfI3MylPp?=
 =?us-ascii?Q?ffGxvEUzfM7o71JsSBVPrZMhi6ehxydVrHzo4ixpjyv+LgnOYH/UN5tXH9LM?=
 =?us-ascii?Q?eiCTebGLHAvfDihZRrclSkhXMq7M7ji6ZMFJB3SFhoHQiMuF4mBgARbmr//+?=
 =?us-ascii?Q?/g719vo9Ky4dreWrQJoI0zBioM4DksjJjxtSqC+NKX57+WDoHKaCIqMMhY3G?=
 =?us-ascii?Q?j8+fD+ncOpL29rLx5UlDyFChkpoPvprcwcuEbRv2XOeniUOnpIxkM0uAAQDh?=
 =?us-ascii?Q?IqrhbhUESfu6orC6pHO85G3fTUByuheDZaD0ocZ2C2t+QcnaoH6LX6eOq50d?=
 =?us-ascii?Q?3DGDE2PKlKhORbPRRU0fOOUOb1KHuq4NlpiLw6F00R9dmJb5YtfWGIkixKm/?=
 =?us-ascii?Q?fS2nYdqUKTtic2np0tD12JWHlfYSNfdlniur0pIXbRFSUDO3+WHsC3E1jbyL?=
 =?us-ascii?Q?ypq+PispSNMdg7yCNIr4qwEH7q3bDHa2mBuCnELH+Y/ZgrxePqkBIiW7IzhM?=
 =?us-ascii?Q?uensG4aV/By3CCmUDHc0NKvsLwrZX/ZIl9n0Fbm7tM6UbuvnJEifj0eHoBp5?=
 =?us-ascii?Q?kE0/XcGDxk+gG1pnfUkyJM2SmmboFO5hvNLc/IrCRPdHJx/AWbrB5J28vxOj?=
 =?us-ascii?Q?qO9n870lDYyC7qsbSKHBV8Fn0mugLu5y83KzJ7J3Ij6xfNlHsK4aLW0fNhgK?=
 =?us-ascii?Q?cgZueCOW03jgldfvRmnesJJxy3kCSKgT6bMMhaXDo8IZfQ+MYU0VB8wMb6dd?=
 =?us-ascii?Q?J9Q98AT5EsxZPgK3mu05QtbgITa9hWtym1tOOIuAH+Yhavjd2as9nT3i2Ux1?=
 =?us-ascii?Q?1vPjVcOfyx+KNze/PZqotmG2uKYxfgbJFAqGR0gvdIPemrO/U4aSstFzzMWU?=
 =?us-ascii?Q?OyawvbEhtQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Sp09ZlmElhxcNh1fHA1/vjLth1aQnIlCoLgiBoOTH0R8YcLpHrBH5+ggRyn4O+o5oAN3tSq1fNtSef8oImgN2lQkc39tp6aVxobPaO5GdzWTb30N8pBA+ZMTgY1NbVE/qSDA6uLmqcR3CmcKzc11ImBRpKCFq5iDaIf0filLjs2AHOD/wOIWed3EEMmKykDCz4yhsUoVBf/TMUPsBhPGC0jihFJMk/8TqHmX45cka882dIZJ+Zt3+mYEegH5QOHrAEcO+4bXkVPo/dBGlTBJhDp7XpNNGtH2gBhRNQ8sBZCByPU8wD+G9ojlcncDtF9VpMl39SccXf3v5yaWBTJqjilD32HC4WPQQJupOOrscUCBJSbzbrMeBtABL3cqtD7rEFkg+qoOtoYdNI9/Nv8F+nUuUnFdhJH8X8Wp04Xz6BvWd7tDstkBLR7KTQVnRyixmn6K2vhZQnEKXU2VfkXWHPvLiCXNri0rz4cgwQm7/ZZzyYDBSHDYmDKdAEamlvVhRQgLy0Sy3ZjcOhCHmLSQG7hcECfA8yDd3pnzmcgdcthUoYChlvqxso4mNUJtCCdzCj9jk5QrInUtRIxk2xSuaAiMy7aXcuDZTYl4Ibpmjgo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9af86fd-09b8-4494-28d8-08de68a9cc4b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2026 13:39:22.0468
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ljg1c86e1tJtiGrlfSSMRt8+Sk1cbbVnuc8U3F4DxCIEyAS5cS9SX/8wkED3EIvD5lVSRV35lVfyqHGW5O3lYOPkKxIWWU7FXtevBiV9oug=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4152
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-10_01,2026-02-10_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 phishscore=0 suspectscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2602100115
X-Authority-Analysis: v=2.4 cv=PZbyRyhd c=1 sm=1 tr=0 ts=698b350e cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=OGtklOPPOaM3u0r_WbkA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEwMDExNCBTYWx0ZWRfX9XWvAwuz8hGM
 I+I0sxLlyb0xo6voWxKPtTSYsYjuTjFqMAs/jGxw8B9PekdA26HBHBGJraR4N0x7QtVtE4KneQg
 PflAk9hS3ndG1LQ03x4uCUwu9oKQiZU87NPt7VYxPS7F3vhN8mMktMAe3OzhPXrM9Z4lh9vy1cs
 WJImTZo7x6dUPk5DnWj19sslDL0i4cuGtCulY2hZo4m2VKeH0b/WpChBnQoZhe8YVxaYufsFkRC
 Ihfyj/KTXjYozfP+csUQR6z1GNgcyi/+YyB34RT9kB7m9+dDGIWTJ0r04FKzmAUIfXkpUvqrk5F
 KEM5VQi+DJxLHEQpti8itxMVjQRiCO8ovJmWnpHlnbP6VFXeGRt9u5xjAr09ye/Tc028ZKRY7Ll
 drQ0kVy9tpMJH5X4OPtcPxl7lW8hq22AEaoLGY+lkD19j9YY7r0FDyfmNU5hknoeWdUr95hryRs
 0q1lVB0ag+faXoUCigg==
X-Proofpoint-ORIG-GUID: l-o5-CBAnaxvCB2RPauoZ5BV7YxpCgFV
X-Proofpoint-GUID: l-o5-CBAnaxvCB2RPauoZ5BV7YxpCgFV
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 407FA40006
X-Stat-Signature: 9nrb6jds5oisqdfcnguop6q6co6dsb3h
X-HE-Tag: 1770730778-188414
X-HE-Meta: U2FsdGVkX1+oLVIDwmdfUYbmoN42FEMxDKRXU9R6k/6J346i/VVvdpE5ubbiBqXmeCj5jOcINSUhd2I1s6DmlOOAExWsUoTqAPAFbXCWhSYNDc1Ke2YEdGtaMARYAQvQ+aLRs8bQhQ+JEqvXDC8LT+6lTl/LvaMmjkFMEel4j2z72QK0y6tE/8JS0pWFh8yvHBDP4wpXG0HgYcCfCSsjXRHOkDvzIfbrRMONVFQIALJEe7j7+LbsSG1xjn90zmNbIbISOGLqfMwdSsHKhIWcqZPWbVwsppu3CyyNHd+qC6LkLkRl3wxYF04TEZA9rxalVlI/yEaMH9YsCL1Pg7eCiRYuO6gQpVHqKFH8e5E42SpBWixjgrnJwL7qjYJlcgHXkJTXsqy5FmHUpmtfU/itfrXJAqv4Uu7uHjzBaRHnRaAVUdBavL3Je6y44A8gk9NhARiOF7gN17Auoz9vsxU5BF22WDxW/KcIxlxY2VZrT0IcqIwZb/YPha8TIwR/HgW9Ig0pNRTA3n18Tw0wQBDvCfvoZPQgEMJEOwTSD29ULD7T//zbEkuLVLmpC/nZ9krd+gCSb5OhFL7xtYBbanSPv7GQnVpEhelCvtn0Kkx180wNqZ3aI/4mfv4tDi+RFNQwu2Dp+QJP+tY9ZsezarLGtGoC9bQ7VcLiZZIvQ69dpNFT47FRWKoIwaubCfSL4rzQz5kPMUGYnx/i8xF+ph4/oquC9q7tMof8F2/myezXNdNzx7Zec9F41sHhpu2UtZ0BeozZhFAng/xSc9JNh8pBNsxe+iJD53JeeNW3SNpyiNhSmS2mcNzIBSY10lHT/n0mc6XmcgLemutkkfuhSggDa5YajQBbnV48RC4MqnH9dJ/pxbLdTpmkvN5zBFSVTYyd71zpFE4HYpHcqKI+HWcU/1gHM3akUy1bok8Pn43fEdDwBiWXYYW6GuiiRiWrpr7xPYTVcnQZUIxF89zWzzJ
 voJP6ROq
 prrwvKjj99KfLMDGUVsj05gJz4BZZTqeSpzYdF3ZfJ9pFhHFXRy2e/oK5r5bhgo36jZHscZCMFVRcdVekNrofwGTWfCjT2QdqC9MknSAk+dbev5mNDaRJvK6uUpyioW8ncKr3AxFSD3XEu1rXMzRvWS23gxUkJ0mj1ZEFZ/xjTxAsdOZUOhk/DxOLeYzaqoGFn8Wce2NocNF5/kHsjfkly+5GvwtRDg2ZBvk4ruslHZCL4JXs8PeRy6wJkcoJFRzEsPCyR63Ok6nLvdJon079r6X81bx/zNjcUT2NAcnUOysrkAoKjnK2GMHari+dreS818LQuKnqFZQD6FKcseoEfIiWk2i1nAcatcNV48MuegHMPkwiy+QblV8Lwe7TqbL1CpWqXUOzsbW/e5CszDlv5bLV82RKdBtEuvFKTHekXPAhxg61RyCl3uG+R32V46d1zy6L7WWtfM/jYRHlwOAqcnh2nzTDgtlA/5cRJyZCKUhclj9H5V61ionqymlvP03zX+1lf+QyoBZEosSYVlWz/tCnvm6pLYLW76IwTsRwHoKoSk07h3c8q4eZqKvkE8kP+D1IItfmrkKRWsWmh5d3pIbqMBDtNsFyb0z4rBxtoxqMbz9u2WDpZIi4+rL2qVnYYGeE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 10, 2026 at 06:58:37PM +0530, Dev Jain wrote:
>
> On 06/02/26 8:52 pm, Matthew Wilcox wrote:
> > On Fri, Feb 06, 2026 at 07:26:48PM +0530, Dev Jain wrote:
> >> We test the patch with the following userspace program. A shmem VMA of
> >> 2M is created, and faulted in, with sysfs setting
> >> hugepages-2048k/shmem_enabled = always, so that the pagecache is populated
> >> with a 2M folio. Then, a 64K VMA is created, and we fault on each page.
> >> Then, we do MADV_DONTNEED to zap the pagetable, so that we can fault again
> >> in the next iteration. We measure the accumulated time taken during
> >> faulting the VMA.
> >>
> >> On arm64,
> >>
> >> without patch:
> >> Total time taken by inner loop: 4701721766 ns
> >>
> >> with patch:
> >> Total time taken by inner loop: 516043507 ns
> >>
> >> giving a 9x improvement.
> > It's nice that you can construct a test-case that shows improvement, but
> > is there any real workload that benefits from this?
>
> I can try to measure this. But, I constructed that testcase to test the
> code path, not to show a perf boost (although the boost is obvious enough
> so why not show it). As I say in the description:
>
> "Align finish_fault with filemap_map_pages, and map as many pages as
> possible, without crossing VMA/PMD/file boundaries."
>
> The patch should rather be seen as an extension to 19773df031bc
> ("mm/fault: try to map the entire file folio in finish_fault()").
> The code which my patch removes, was added when the norm was to still
> perform per-page fault, the argument being, RSS inflation.
>
> Perhaps I can polish the patch description so that it clearly mentions
> what the objective is.
>

Can we make any new respin of this RFC please. I am especially not
confident given the immediate syzbot etc.

If it's a speculative thing without great justification the series should
be RFC until such time the community decides it's worthwhile.

Thanks, Lorenzo

