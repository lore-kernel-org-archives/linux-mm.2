Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CEFED7879F
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 18:22:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DE1B6B0088; Fri, 19 Dec 2025 13:22:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88BD56B0089; Fri, 19 Dec 2025 13:22:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 736036B008A; Fri, 19 Dec 2025 13:22:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5FA2A6B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 13:22:19 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3592DB8B70
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 18:22:19 +0000 (UTC)
X-FDA: 84237040398.07.D36D7FD
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf06.hostedemail.com (Postfix) with ESMTP id B740C180002
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 18:22:15 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="F71NRhd/";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=kgqP7Bu+;
	spf=pass (imf06.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766168535;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JBV8fFdfxDQHEB2IzMFaFuCJZlHJWGdtMHORCdNc2ZA=;
	b=d5GFKYRqsYHLJCsCZICSBfP5QFvmRgVPq4MqF7spsu+3GcQTCJiLtnOv2/ABDyiGZEEI9j
	aGM7ozgA9ode9wa4VrXfALDu4nhqOO9IjHBtsjvtyOVM67TTBvBdT8sc0O2CFNsjlHyNAU
	DWZwBM9ri2ADJJZ4rkMmkaaW4d29KTs=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="F71NRhd/";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=kgqP7Bu+;
	spf=pass (imf06.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766168535; a=rsa-sha256;
	cv=pass;
	b=P6xQYiidCKz1BlP/XrLYgP2A4YxbwSy1SPhV9TcxLexHTIH9UvRJwMFLP8202yrY78Vp8p
	PJQ8IpseLUahxArO0HWHvB2upqL4xIBxVDOBE3IPyMI1It5LnYFNtuBgsO4riG9AO0yz1a
	evw9o7Hyn7rIqncwSg/PYJ/QsDY/Tmg=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BJHvE5T112666;
	Fri, 19 Dec 2025 18:22:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=JBV8fFdfxDQHEB2IzM
	FaFuCJZlHJWGdtMHORCdNc2ZA=; b=F71NRhd/Y/CqI/hlLebkJ9hBWCbG0jgjzz
	poZxz+i0AtAt2pI2AetPX4n4w/u5Bxk0JYXctrN2mR0IF97dDbsN0xvAtSrK/9Te
	ioKGsymSWdrJ4uN+VaLlOH5kfVtyZP2f189QRevu2OOeU+KyNPbrD6KquQNR9TgM
	vP6RLfscAhodUTx8SQwLkPfHskqvQwNCbl98oWa5E+JRos6f0wSWI13I8zGoat1J
	o1w5+DvfNIOZo2K0fno9eILhXhfGihLHlgMbsRC3wTWYtDK88H3Www2frudBmxsC
	G3YuNgWrp2TNHIM3t2WutB2pcxJX2IfiJwfwo3h5FloZGHuEE4wQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b4r291jb2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 19 Dec 2025 18:22:10 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BJGIS77035059;
	Fri, 19 Dec 2025 18:22:09 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012047.outbound.protection.outlook.com [52.101.48.47])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4b4qtdtk84-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 19 Dec 2025 18:22:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C5I730FKnud8EKz9a8XAgGYzCRlsIzL5yeHdA7nvmMZIIXsqj0eogq52BERzYNIHB4masnoKXgvSwHf5RvF+pVaVClmxp1ZVANxv98LnoFuJT1IKBbGRnlq0mIvyzUBrk07qXRX+sl5T/cNGNT4TVN+HlHRJ7JCUrkjhneUMu93ie3N4ZLUHIEg1S0H80RdcF5fD7Nq62r33C+LBSrUUcLgMEFKgJsqptmkWAk7iTfA2DnAq7IJayF+B5PsCdyflzM+FRR2Q0PwmN76Dgr1dviaWRY6XlGioGwpfidjcWCsLacVYlhmMQgIR5x9vEeT/vI6HNEgBzjzwSovof+VdoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JBV8fFdfxDQHEB2IzMFaFuCJZlHJWGdtMHORCdNc2ZA=;
 b=QVixSbN6GxwQ0niwnXDOzFK/mpyUXLfPF4F3ihVj/SsKdFJ+40NH98dWNnc2PzXj820VHT5M83SfICmPoL5h/Toi9ehMdXKH4H8KnIUxXyox5j3a4kyE0xIHbYc73tM48YQO2vGntwNUEbQ0u+bD+sIa+w6UPZWUXvlwgRZNtqH6n5jf25i1HY7fUvFhuvV4a7Wa1MqNq/+rbghS2l0GG0HpfTNpXcesZT4bW1GVtiwivmuuhpmdmiWt+r7w7A4VMSf8E08xwHkjJB2j9xco8rblsBeI8LqeKphvLn4GhneRDg4RTu/IzXvjGPN36+En9R+aIcV/iZ2N2RgkhzTAbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JBV8fFdfxDQHEB2IzMFaFuCJZlHJWGdtMHORCdNc2ZA=;
 b=kgqP7Bu+Jww4wXPmRTsQiEctMedQRBY4Gu8P7TpFmE0A6pTngG20LrVSVPsVf5lFgwXA0D3EaRSuaMh5tZ3+RrJ5OCnmUq/GY2qMqaRqUz81qgKrfaKoSeG8vK7GM7KcRoFvO908wd9qj1LIMBymXEu9NO76FavWS+ppdZqHkZs=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by IA3PR10MB8592.namprd10.prod.outlook.com (2603:10b6:208:580::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.7; Fri, 19 Dec
 2025 18:22:06 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9434.009; Fri, 19 Dec 2025
 18:22:06 +0000
Date: Fri, 19 Dec 2025 13:22:02 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>,
        Harry Yoo <harry.yoo@oracle.com>, Jann Horn <jannh@google.com>,
        Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
        Pedro Falcato <pfalcato@suse.de>, Chris Li <chriscli@google.com>,
        Barry Song <v-songbaohua@oppo.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] mm/rmap: improve anon_vma_clone(),
 unlink_anon_vmas() comments, add asserts
Message-ID: <fkgm4eqdwymljueszhsfyvm2zksc6x4vagca2mlnpl7vtawap4@d7obev7d5hce>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>, Jann Horn <jannh@google.com>, 
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, Pedro Falcato <pfalcato@suse.de>, 
	Chris Li <chriscli@google.com>, Barry Song <v-songbaohua@oppo.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
References: <cover.1765970117.git.lorenzo.stoakes@oracle.com>
 <3acc90a8613d5e2ea8882d60b5677228e6fe624d.1765970117.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3acc90a8613d5e2ea8882d60b5677228e6fe624d.1765970117.git.lorenzo.stoakes@oracle.com>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: YT4PR01CA0492.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10c::16) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|IA3PR10MB8592:EE_
X-MS-Office365-Filtering-Correlation-Id: c9e28b9f-0e61-4f03-80df-08de3f2b83c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Kv0n02YEg+Psha1s2RcofFOjBTx8qCUKOCnkSz90aVHMHteOGSaOujvVZVNa?=
 =?us-ascii?Q?bbx1apFtcrBVY6DZ5ec9+CqTEtiu5Qd7U+IhTge66Z6snxt6cZPrZOom40ac?=
 =?us-ascii?Q?E6SlVup6jOLugnX4xgHT1DbD0MhmYrt7zK1CjPM7Vlo8OXZ3pUXPBu9jep4U?=
 =?us-ascii?Q?ZBNy4iZsyZbecPIehG3nPAl20r2s3L9aFT5Mthqx5sAhn0r6Zq32cCbQrOOM?=
 =?us-ascii?Q?Mc3JKKu/jZhIi+QKuOmzzZdlFRpOE4Z95d8ZY5xZWjJ724I2epCmRTFWkP2r?=
 =?us-ascii?Q?KyIRKfqMgKKo7SXe3s6tWOPoMfU6Am5zCvYCnjm83bHNPfsvcRL83GxuyeJT?=
 =?us-ascii?Q?NKr/IB/flsTfzi/gyZRDL/IUEadFZ9qM2MWNev40AscdxQDUtnAXgnX5oVTH?=
 =?us-ascii?Q?k3Uk3SpXdjgdmSR13iiO6r/Tio0vPj0Q8ClOt0Q8cH1D4UNwYOr1GrAnYOsK?=
 =?us-ascii?Q?W5Z3cQnqit/lhscEU7fKrRd2lC4NoiKPakpOJ2PN7IR6geJkHK7eWFz/DLC3?=
 =?us-ascii?Q?VV2lhyTsPqmyrnYSBWEsqTs/YHxOY8O8DimgUACDRus9QBLK4gTNjhVuH2yX?=
 =?us-ascii?Q?qIXFToyXGvf/Fs4YWm8uYBzD0pfDzIOPvRmzgAEe68Rk3awgdagejHDuUNLf?=
 =?us-ascii?Q?d9jY9gUIHhX9g0Vn+7kPh3/pIhxfpXy7WzJEdy3TUzpcYr/RhN/bsm50HMwG?=
 =?us-ascii?Q?3m4vM2Pi64IWj4dTJ+DgGYvzlsnF+f/yCk+M/+aaLJfeZFUwZa37AOuSRcML?=
 =?us-ascii?Q?Q3XkmamN3w/AdI9DEprFMm1Fc/Gwzh7b6XVc+ca9eJRKHERPQEsVgM0aULVr?=
 =?us-ascii?Q?1KPGfCNA4ramwY07fEbuHc12h/4AQu3DxwNLOCVYYjbQoBa7bIxO9582VjAd?=
 =?us-ascii?Q?kDUt8eXMauUzCU9W6+afRLBah/+r2QNXmhM6ubi14eY3ID8ebxC3u5O6Ttp1?=
 =?us-ascii?Q?Ww6UFQ44CUy3sth/U1yXtNRLpdN1wi8uapfj677Xqazc2uzeGuLClh7AU3ek?=
 =?us-ascii?Q?3AVNAG1pGgfsnEeDU7Ktd25l6eYGQCXSGojKUR68jGMllrnEtmyr/7T93E8S?=
 =?us-ascii?Q?hYQ3+DAB3J5Sswa3DmH1w8JyTmO0x9ylrsCg9uCCvJslGnuk69JgQRo9Tj+p?=
 =?us-ascii?Q?cZo+pSAvISVzncH+uFigumL80GIXt9N4NF5r1v9uUsZXe7fHVH3McKy9hHqg?=
 =?us-ascii?Q?8Tb2EExFxMVEu+POQRUJwUbY8jsH/gRficziGcgtRyGwS+v4yorl5OsSjrdl?=
 =?us-ascii?Q?CcXRgBntAUjtw1RgSm37XCuH/GCujKhBXeqJZwaEqTP4/L0Z+auZYOcb8wfk?=
 =?us-ascii?Q?ZiLsQhoJBEAkWjc6cU8OPmG6yZLzz8GYRdixBJxKQPhlWzCldMaXZH2STNcj?=
 =?us-ascii?Q?sLj0UJ0SLoWz0iZLuoe6hHfjrs/jI/JdX+5tSRxgtEzZY/wFIAtTlGI8X6b5?=
 =?us-ascii?Q?nAeGtfmVuxaRoZ7ZIgGP3Rwtge2imdz5?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kd1DJ9J0DGc8YVauD4jieMHFHvUiFN26bFywbRiYIZAxavtVNb0wNPbtuOmb?=
 =?us-ascii?Q?y055Vlu3+BwNnwMk003sazXr5coIWalZs67242fu7RjE0n2QuE3OwWkdisfz?=
 =?us-ascii?Q?8LdzqjP2eYqtQ81UjPtA2cfS47uvdskFR3vl3Fv4cvcQTDsDIyKvTinlYD4R?=
 =?us-ascii?Q?PuJDUFl6T4Y1quFGQMvJwyqh70XzrKYBezXWTwdaWoYjRiJ2GBbb11DNoCxg?=
 =?us-ascii?Q?tYKJ4T5U6PdSOC5DJxuoWYtpsap1zjtxjFElFPc5WX3Nadw9AsxHOd+zE+Nb?=
 =?us-ascii?Q?bWD95j1Y8rof8vabx5Fgy6jlWjK7LzAVO4JTwOcB/bbV/hRiFXvWeqokELmh?=
 =?us-ascii?Q?WGacw2837MUWF7bUyUPGyiN35qBbFd0cwZYt+JZmVjn+GrJ5Xt6xDj0tL/ix?=
 =?us-ascii?Q?o0Urd+I8PAMAZ5KZoL+b8INteuQOi5Gfz9+SYxbeGz7HdbUNdBTt4B9HyQyf?=
 =?us-ascii?Q?xUQqXmYUGuYf0d6BRdI1B15tmb6cCN/bVG+R+liBlzE5DL9GBkh8wZZXxNKn?=
 =?us-ascii?Q?K6Czga7ZPiPV4S7hj4FBcVMjMejSB6qPDgZcLmtswNgHjmY4yfWqdwi+6Zyc?=
 =?us-ascii?Q?r+x8BG0bA8jI2WHYbEwCV/06XXLeWasSrYAayUDCOaynCj8uH1IXydshvOuf?=
 =?us-ascii?Q?5gexH+AqPcnEU6qnAYqtPo37EijM/RpoIoXSIgdEwtVqJMhvFfnjXFXurlSv?=
 =?us-ascii?Q?DqR4qaiVBx653NE2ylTRxtqwijSy2e0P/onJBadeltn3bFvokDZBdye2gvI+?=
 =?us-ascii?Q?3PDt6kbpSAiN3NUEfNHBsf1nzlS7w0KCHlmdGI+INqOo+nzdYhGPso+uX8uw?=
 =?us-ascii?Q?hTeT/BF9t1XFbEvs6DSWSK6eaP+wwdaBugB4UgCT/xJ0gbHsoE0vXn55HG/I?=
 =?us-ascii?Q?HdgjXWmJj8WuB+sHrIqt/t1pvF5tKC6L1S+D1HmjAXrF0nx7ldNbGZ/TTZ1+?=
 =?us-ascii?Q?FLoBIJLxuciCuJwcffQOL1n6k2GzdfgwNfi6rv0sDGXuYFpZss6QYpWAxNGa?=
 =?us-ascii?Q?sErkRJ0mVvRND8UBh2bNXCkID3K0JIcZi2tWcr2x8/ABWtG7S1Pp6D0tCaHc?=
 =?us-ascii?Q?YSsVFjy9VDroVE+3qaMWpUDPVQLmdDDp9iNK2/u8fsMfpzU3pdJgN5GWYj+Z?=
 =?us-ascii?Q?SljtW8rgrhr7odWo8qCjwdhc05eWTy7+7tCHJSjib+nQ0iGdm+vfV7w0WJ/V?=
 =?us-ascii?Q?RFKyxGd7GPTYtOBUSVyKOlb+gj4t0eUjrYhPdojmEOLzsJnK8y6kXhxGVYOt?=
 =?us-ascii?Q?dqKa1mFlhZuhq/s134RcxYQe2mY+CpyR4LmStSV8PgcTocqzOImriMec15RN?=
 =?us-ascii?Q?5qVfJ2tc1rIAkyZBdVHYZvuoS9lU1XW/gRwByVejoQAZzupANRQwstZsjbJG?=
 =?us-ascii?Q?5qYOrBk59pHcpN6Sq4KCWVjSyxsAfts4ZcdqF3lGmRwSAQQgogiHzYoSeSoF?=
 =?us-ascii?Q?scBxmE3qqUghm7Xbu4zE4xZY5R+OQMqrLUqjbRJy3rptA6S2qkPMI5dMKALc?=
 =?us-ascii?Q?p921XxrybW1DzIXL/XX0nlynF8izowPzWATAnqg/jASYIDlTp075ODlCtG21?=
 =?us-ascii?Q?jr4OrSE3T92xJmQcOu04OVQg840SnX8isjzO57iAxsxyfAOPbYpY8aWWR7GV?=
 =?us-ascii?Q?OqxRE/IyQICUvtOAHMLvyuPk2mOuMgbZd6cPkWhplWjdvk5YEQfq3p6S6qWh?=
 =?us-ascii?Q?P/KxC/2Yh5p/RV3OmolvdOhTAiPxHlLkISrPe3K0XRB+oBPPKnWlpoQG9va5?=
 =?us-ascii?Q?atQMsOmXGg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	dZK6U97ho3oanjE4CiuRXweqwF3v8qQOfVm2HydplLNr7kAMZDoEPGAlKT+QfIDnYqGRzDo+5eVp2wND0utJp7xY1BSA0BEveE9EgOSeB0juHyjhNiIiOK5l/VW7D8cnf8uUuv0ujc9GJyGRN10szobVjEHDIFQWDChG/88DA291WSGekyS4P4HlCAGsFTkE1GjN5epjqeQiFq/ZDLC3rqArKibJ6UuKGSZeFMIiChDTnY5DgGzdUydWR3ArqkG+Lc6RgBT0RBpwe9wp+aP28rUIVINPlyvePb3CCtxRteRycTTnuGFA4EJuwQ0U14gD2Q+RpvY3IFJdioKf9hvHQ+aHZn54nfUsqi4CCbNDzaoGDBzNXtT/j6YSwxxDboaXpBfxAgW8Y6077L/qhLSGkewa3Icoa0Zi+sz++O1sVH3yTuR8UYOFoBEGvF8LsBsbeh4xnLeMvxHR59I6Ra6QvjV6oURfq11rNTSwpgGHdP/9vfOXfGJNKMdvJfQcieU9cEN9kBoeHeCnFsuy10zYeFYd9Fi0us2aVkfg8nD1TATrCwE4Kc1Ere3cH3ov1liVp0YfSer2Z33lx2aBDBHbUWWjHWS7h4cuXqk4OA1MgN4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9e28b9f-0e61-4f03-80df-08de3f2b83c9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 18:22:06.2044
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kCauJUnoJQGAriGFUpFY35s3iyGIBpBswX4t2v3aMpp87MVHzFmJE4Gu6CrB9EeQw2jKTnpbeyvkTxcGIVyGcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8592
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-19_06,2025-12-17_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2512190153
X-Authority-Analysis: v=2.4 cv=WZgBqkhX c=1 sm=1 tr=0 ts=694597d2 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=OFUI4k93655JLWhF-vEA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: cYw1Plmj6YUJMfc1qwkM6hm8rbW0ONIw
X-Proofpoint-GUID: cYw1Plmj6YUJMfc1qwkM6hm8rbW0ONIw
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE5MDE1NCBTYWx0ZWRfX4E6KaqHUFRU0
 F/le6sw17nkR7P8wacG6xvJtLLZKOlL7814IAy0M64kWwP6VRzMUXZ4Q8wDJmy9NLs8fwBGvDiq
 oNN2Uf1SXM/hnfUlWtoaTVvH/QQEvh0vKDa/fscyVxhFaVD/o1NRj9yLANS+qH1DB2YEfsiFn7N
 JCyBNOBGNdvWQ8PHhCXytMPTZJDAOpobzIZvNG/bU7rwZU5+2Ed65NIYGbmfRtviEL1T3fCRAIS
 yYdnFwDX9o8jnvvg5r46We3iBsn8kb9d21a0DN2ODjqiqK2xYJrfYE4wwPJRUKCRK5N/5yIp595
 kMeYHyP8uQqYXaUxzLqd+YkI0m6IqnCGDZHm2sRT3rO9nrlu+5rNAyIZjoUhesGDiI44gbGRudw
 FyqZGHBncWbvXwxe53aLmYHiBSSMFkNZHPSTmVEefZ9xuSXKzV1MpicXdSYfdiZD1GAtbnelVI5
 7AN+9VulebIocevYXrA==
X-Stat-Signature: ntrz5iijgef6bz3o3589bbyegqcy8gep
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B740C180002
X-HE-Tag: 1766168535-956419
X-HE-Meta: U2FsdGVkX18sEtkXjT7yVMtMIoFLEI2PumqXudNJZuut99LxV4eU4NT/8Abc2ysyg3M72MAKXR8ZVZJ037tJ57oKJmpZq1HyZ6i4Y4Pe5HQ3FwmM4/rYq0SEoWLAOLn/swFy32NTGMqgrZGd1jobQNbAjVB12oMdNLiFFOSX+91d/XBn+tql5Y2jjQwZTYWEYYv1x01/6QBClfQWUp9OMPgOwyjbamCWLBzOTJolNM2rgjWkvelPDBKc7dDGC9me2ff4aLOHy9HNa67DjigJqIKjkp+Th5qzmQB2EeKHev0xiDBUVFSfebYG/IuU8a9wp3TDHJlaSB9umxMMKaBkxd2fRh64Y3KoiAfXa8X1CvJVYL7CUd13ynbN1oVeA6rygp9bN9dKqn8Nww6bXuTQcPGaU8fAyzAcssIU6ykS+jKqMTrGhYfuV5D+CWh1auMRIspOqHN1vmSRjEJWNEZC/+ZfUmjtQ5QcyqV26XkEQrE4mamgOcqrKTnI68wTy8sCQnGyL3Ie0xpF/Ox8++AtFokV5yVMUqCXWm+OMNiWW9KnOr810kpKjv1p3M5awt2Fg+6COw2Nnqjw+s1NTe08+ZqjA3HRUFMTyBIZZQwasMLFOtbYJZHnXwt5/H2w7k49X6pn9s5A6RoMC6YvNkV8not0U4BZ8YlGnL87t+jWp+sTmnSYyCgi9ZnHAET5K3aSY89Zwj2PEfZyH7uGd+nPLkbzsAqFkiPpUcJDoY4ZJxKy8Q7OZIbnruiB6sSFjfGCy/CRi8HANbSPMIv4vpLM2eZQ4cnbWwpDtHS1Q4GcV1akx+/PSBJ22wB9mf+72LJkVcpjkCUuIF9SFsVH32tqkRX0T6n+DvvyMU+qVdY5aV4zqEqBqdLl9I08KMYiTZN61tbF8MnTWTYnH1dBMwJmPrgqEGfkfEMrVo/TvJ/+uyiX6CpUr3rDFt+vwSOcYO1qKlSC5MnEmUdEstuluej
 IW/YCF1D
 uUIlV190t7lfcoYwaAIgLONqLMzzuKJcgAjIiBec4ivUKSEI/1Fws6XkTjZ/Jpa8ZP+Ioef8gt1G4PXVu2qVqsTRxDh66LlgvPVQCgW5dyOJPWH2FMrtZqDDIGoxujLFZZObTCxtPfd0NSPBZg/g/GSh8P/bkrIdmU7/g9St2DSzUAE5xMrbmdVup3Lvrumo/zVLtA7VG/ZI4aoPN+XpF/MGkHIPh5hOClclGDdH/G9z7KKWycU/H4n56XdO20JSiC9bXSwx9fGZyBCuKtEvoAkxgwH/bxbS9m/ncvPm19srHctsB+9v1PuBkIdiI6dD4URL8VVOdUnFe6L+2FxYD2KWJuUM+LuPE2lCjEVUtNrSHySYPKlvQLjbpoN4qE8JfRTOvWklyVldgqdSYugz2AWTi2BQeWOwy9eAK/D01+VUAcE/bj8l2FapqjTIe+YIXSv1Pf0s9k2R+lf+gJEONM7SC3dC4dUlfXbZfCIFHeGDmbmY8cWel6mRgTlnZL5FcIgEO3RCYrZMQAvXkPl0l1TdpkcZB9B4zp34rOBNILQYLrOFBVHn0So7LVg/1lRYPWll+N3F9+QizVTv+acMk4M1YStU6WiEUe8Pm63OINmJLAB9tLthLilwF8XqomVSsQkJz7llDuyHIPeuoAuqZ6WQo+CvHqNhq1/aa
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Lorenzo Stoakes <lorenzo.stoakes@oracle.com> [251217 07:27]:
> Add kdoc comments, describe exactly what these functinos are used for in
> detail, pointing out importantly that the anon_vma_clone() !dst->anon_vma
> && src->anon_vma dance is ONLY for fork.
> 
> Both are confusing functions that will be refactored in a subsequent patch
> but the first stage is establishing documentation and some invariatns.
> 
> Add some basic CONFIG_DEBUG_VM asserts that help document expected state,
> specifically:
> 
> anon_vma_clone()
> - mmap write lock held.
> - We do nothing if src VMA is not faulted.
> - The destination VMA has no anon_vma_chain yet.
> - We are always operating on the same active VMA (i.e. vma->anon-vma).
> - If not forking, must operate on the same mm_struct.
> 
> unlink_anon_vmas()
> - mmap lock held (read on unmap downgraded).
> - That unfaulted VMAs are no-ops.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>

> ---
>  mm/rmap.c | 82 +++++++++++++++++++++++++++++++++++++++++++------------
>  1 file changed, 64 insertions(+), 18 deletions(-)
> 
> diff --git a/mm/rmap.c b/mm/rmap.c
> index d6799afe1114..0e34c0a69fbc 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -257,30 +257,60 @@ static inline void unlock_anon_vma_root(struct anon_vma *root)
>  		up_write(&root->rwsem);
>  }
>  
> -/*
> - * Attach the anon_vmas from src to dst.
> - * Returns 0 on success, -ENOMEM on failure.
> - *
> - * anon_vma_clone() is called by vma_expand(), vma_merge(), __split_vma(),
> - * copy_vma() and anon_vma_fork(). The first four want an exact copy of src,
> - * while the last one, anon_vma_fork(), may try to reuse an existing anon_vma to
> - * prevent endless growth of anon_vma. Since dst->anon_vma is set to NULL before
> - * call, we can identify this case by checking (!dst->anon_vma &&
> - * src->anon_vma).
> - *
> - * If (!dst->anon_vma && src->anon_vma) is true, this function tries to find
> - * and reuse existing anon_vma which has no vmas and only one child anon_vma.
> - * This prevents degradation of anon_vma hierarchy to endless linear chain in
> - * case of constantly forking task. On the other hand, an anon_vma with more
> - * than one child isn't reused even if there was no alive vma, thus rmap
> - * walker has a good chance of avoiding scanning the whole hierarchy when it
> - * searches where page is mapped.
> +static void check_anon_vma_clone(struct vm_area_struct *dst,
> +				 struct vm_area_struct *src)
> +{
> +	/* The write lock must be held. */
> +	mmap_assert_write_locked(src->vm_mm);
> +	/* If not a fork (implied by dst->anon_vma) then must be on same mm. */
> +	VM_WARN_ON_ONCE(dst->anon_vma && dst->vm_mm != src->vm_mm);
> +
> +	/* No source anon_vma is a no-op. */
> +	VM_WARN_ON_ONCE(!src->anon_vma && !list_empty(&src->anon_vma_chain));
> +	VM_WARN_ON_ONCE(!src->anon_vma && dst->anon_vma);
> +	/* We are establishing a new anon_vma_chain. */
> +	VM_WARN_ON_ONCE(!list_empty(&dst->anon_vma_chain));
> +	/*
> +	 * On fork, dst->anon_vma is set NULL (temporarily). Otherwise, anon_vma
> +	 * must be the same across dst and src.
> +	 */
> +	VM_WARN_ON_ONCE(dst->anon_vma && dst->anon_vma != src->anon_vma);
> +}
> +
> +/**
> + * anon_vma_clone - Establishes new anon_vma_chain objects in @dst linking to
> + * all of the anon_vma objects contained within @src anon_vma_chain's.
> + * @dst: The destination VMA with an empty anon_vma_chain.
> + * @src: The source VMA we wish to duplicate.
> + *
> + * This is the heart of the VMA side of the anon_vma implementation - we invoke
> + * this function whenever we need to set up a new VMA's anon_vma state.
> + *
> + * This is invoked for:
> + *
> + * - VMA Merge, but only when @dst is unfaulted and @src is faulted - meaning we
> + *   clone @src into @dst.
> + * - VMA split.
> + * - VMA (m)remap.
> + * - Fork of faulted VMA.
> + *
> + * In all cases other than fork this is simply a duplication. Fork additionally
> + * adds a new active anon_vma.
> + *
> + * ONLY in the case of fork do we try to 'reuse' existing anon_vma's in an
> + * anon_vma hierarchy, reusing anon_vma's which have no VMA associated with them
> + * but do have a single child. This is to avoid waste of memory when repeatedly
> + * forking.
> + *
> + * Returns: 0 on success, -ENOMEM on failure.
>   */
>  int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
>  {
>  	struct anon_vma_chain *avc, *pavc;
>  	struct anon_vma *root = NULL;
>  
> +	check_anon_vma_clone(dst, src);
> +
>  	list_for_each_entry_reverse(pavc, &src->anon_vma_chain, same_vma) {
>  		struct anon_vma *anon_vma;
>  
> @@ -392,11 +422,27 @@ int anon_vma_fork(struct vm_area_struct *vma, struct vm_area_struct *pvma)
>  	return -ENOMEM;
>  }
>  
> +/**
> + * unlink_anon_vmas() - remove all links between a VMA and anon_vma's, freeing
> + * anon_vma_chain objects.
> + * @vma: The VMA whose links to anon_vma objects is to be severed.
> + *
> + * As part of the process anon_vma_chain's are freed,
> + * anon_vma->num_children,num_active_vmas is updated as required and, if the
> + * relevant anon_vma references no further VMAs, its reference count is
> + * decremented.
> + */
>  void unlink_anon_vmas(struct vm_area_struct *vma)
>  {
>  	struct anon_vma_chain *avc, *next;
>  	struct anon_vma *root = NULL;
>  
> +	/* Always hold mmap lock, read-lock on unmap possibly. */
> +	mmap_assert_locked(vma->vm_mm);
> +
> +	/* Unfaulted is a no-op. */
> +	VM_WARN_ON_ONCE(!vma->anon_vma && !list_empty(&vma->anon_vma_chain));
> +
>  	/*
>  	 * Unlink each anon_vma chained to the VMA.  This list is ordered
>  	 * from newest to oldest, ensuring the root anon_vma gets freed last.
> -- 
> 2.52.0
> 

