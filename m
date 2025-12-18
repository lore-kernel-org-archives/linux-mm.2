Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB9A5D711AE
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 20:27:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D0DA6B0088; Thu, 18 Dec 2025 15:27:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A7906B0089; Thu, 18 Dec 2025 15:27:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3601F6B008A; Thu, 18 Dec 2025 15:27:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1FCE16B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 15:27:12 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BD4501A02C4
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 20:27:11 +0000 (UTC)
X-FDA: 84233726262.13.B172778
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf30.hostedemail.com (Postfix) with ESMTP id 524968000C
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 20:27:08 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=PbCXveJj;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=qlMt6iLB;
	spf=pass (imf30.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766089628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S3I8SWafZ5O9PJrtNj5dLVx6iMPlA9nixFab6Uo52tM=;
	b=dffqBudP9QRVe/89PXB83twHOLqvnF7XzIbFVmLuwiBbX9JELfNRQt2OSatgLQSZOeAIKt
	1Inpl6cKfngA3XhLve8uUVPPWTX9THa2hjIDVqgk08XI8S28Qq6s2rxJ8UXsXEnq/NchgW
	bP1xPOgrtFAmAx01hDv05BwXW4l5kr4=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=PbCXveJj;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=qlMt6iLB;
	spf=pass (imf30.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766089628; a=rsa-sha256;
	cv=pass;
	b=b4fYXU5J4dVE3V6kdE9zL2jWFm//RvTaZmjjc9YCSIBNqNxhhZJWFwbYyzyBusxrGcbZFJ
	swPOJZvGD1lgND3mMfMKrj4tAiwW3BmCGjpm+DKo1RScGti0Gfedozq9jSOjXD2AN4MV/L
	zLM5WSj/Y7BTN7bRwo+AGa/EWZHMT0Q=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BIJkQDn1605296;
	Thu, 18 Dec 2025 20:26:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=S3I8SWafZ5O9PJrtNj5dLVx6iMPlA9nixFab6Uo52tM=; b=
	PbCXveJjdj59Isyp1g9ZQfWt75VNAvQk71tf3dfobqXL99op57SS6D62Ww77gsmI
	Q5AEQZX+ZddcQZw2IsDJJ1nWtzKpdbY23XVReKbKlJDviRrG0HeCJi6nYZDQVfDf
	bZURc7XulDCVXq3CqC99TvwS+xLodX+FTSz9H0N1pC9wZBQjSlX/qAM1xyv6ejcA
	a/W9aYypDS2FmpADhk15k+erS9rBgmy1JBtYyP0pwvneKqeKKl8D+uFkKKrvvrH/
	/sZ+kC59G3B/y1CSXH75ok6J5CqTFiJNJhuVl5JdetEx0AQG4IHkCDpNOvhDk8jR
	1rOthBXFKHJGUyzp6dr+rQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b4r2cg23x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Dec 2025 20:26:59 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BIJT309035249;
	Thu, 18 Dec 2025 20:26:58 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010004.outbound.protection.outlook.com [52.101.85.4])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4b4qtcj3rp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Dec 2025 20:26:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ys2bV1Squ5GnCh4j/qaAxaGn7rlnNfQDYaWBrf4RjASMfspIBJfsMD2lhPrBPX8y9y3RFNkjekDDyVgsP4pfTKmf8GSxm29/AhVJT1el21YZ0oszfTT7H0t7/Ttfh0T73zhbBvv+CAFgmkT5iVN1HKtA76Ef15u/DWZxkGY1v21Pdd4S4rwmAInWUKL9EFcvCxIq+9jN4onW2rt9vz1hz9mzwG4TLsLyWUwqCekcZaraaRmMruFoiK3L5kcc42oisk2Ecqaa7dWLtnQQ9P+oPWU09vwTj55kpzVxm++afpAlQdRukNcZHGrLTGqDcQqdQQroGN/y+odSEphyGd7wmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S3I8SWafZ5O9PJrtNj5dLVx6iMPlA9nixFab6Uo52tM=;
 b=CbZ/8yoj13CPEVZUb6hMoT9M6JG/1Enkj16b7ZPocL8leQ7PkR7cyGa04dh5Db/q6NHEUiW+dYc2ig3toJqaeXO/033jpVxmH4yqDEQWGjDpyCue5GQn6r8enb7BtE7RnsYE61iA7HrWr2qP1aONs2hzzrJ0ciubiafbhR6BlU1EQ2O8OmndlIb4r2sg8HwUG/jiLfESabrvsFGz2nqE8l3xQMuaGrsBC9Ntlrddh6Cc0LaBSp6yFPv6iilA+cWCQxKwCAv9ipXD3HYb2/d1GKrqACnqgtBlMB68ghP5AsTLaRaOLm+Kn2/DLx5lxCIyLMEcvKDJk0pIlKfrJrv6ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S3I8SWafZ5O9PJrtNj5dLVx6iMPlA9nixFab6Uo52tM=;
 b=qlMt6iLBi0xZtC+tW5AuiTf17ohxsfQ90WS6EgC8SjcAzyOu4KoRYRt/J1zjsfDdFdPPl7USq0K9oGub3V/R9+hX0AJ4iq6M6YPAR+ipbkUatCjsOWeJ73RnMe2nUjGFRug/TIyvhfUiDf7OmPJfUWDSd2fMe/M3DCbEioKh6A8=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by DS7PR10MB5022.namprd10.prod.outlook.com (2603:10b6:5:3a3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.8; Thu, 18 Dec
 2025 20:26:53 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9434.001; Thu, 18 Dec 2025
 20:26:53 +0000
Date: Thu, 18 Dec 2025 15:26:49 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: jane.chu@oracle.com
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>, muchun.song@linux.dev,
        osalvador@suse.de, linmiaohe@huawei.com, jiaqiyan@google.com,
        william.roche@oracle.com, rientjes@google.com,
        akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, rppt@kernel.org,
        surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/memory-failure: fix missing ->mf_stats count in
 hugetlb poison
Message-ID: <duh4px5nbhpuy2t3oztp7gersieo5q76kdlbzkgya27cxmaoxs@uvzwpigeknpo>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	jane.chu@oracle.com, "David Hildenbrand (Red Hat)" <david@kernel.org>, 
	muchun.song@linux.dev, osalvador@suse.de, linmiaohe@huawei.com, jiaqiyan@google.com, 
	william.roche@oracle.com, rientjes@google.com, akpm@linux-foundation.org, 
	lorenzo.stoakes@oracle.com, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20251216215621.920093-1-jane.chu@oracle.com>
 <a7cec1cc-bcab-4dff-926b-f3d3c5136f61@kernel.org>
 <609ec743-e989-4c50-904a-80388d6a0096@oracle.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <609ec743-e989-4c50-904a-80388d6a0096@oracle.com>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: YT3PR01CA0101.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:85::14) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|DS7PR10MB5022:EE_
X-MS-Office365-Filtering-Correlation-Id: a2a87043-d75c-4708-93bb-08de3e73c824
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|27256017;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?bi2CwTOG46Np5iogd8INwZr4/hCFMCn+y/WImxGjUOmAO8Aqq6/Zr+/qSz?=
 =?iso-8859-1?Q?moUbGw0TbMAemEO1oRj3Rm9Sobdk6cqAVItCCAybzgOYiQQbPyNUVRdT2R?=
 =?iso-8859-1?Q?hPMq04SqYkI3mlNyghpjZw+HE16UN1QBRaln05vSlegcDBCETNsQGJUusd?=
 =?iso-8859-1?Q?9+hf6YoSC/keuvoDUpUxwEwphd3mN2e+SxcsClAgYNJ7BBLkCvAy9quNFx?=
 =?iso-8859-1?Q?aBA3FOi1a2V7jnJGczwljg2W8Z2ZGShvq0FvubXzx7xcwrcEaLXBHHAoYV?=
 =?iso-8859-1?Q?7gg/ZyN04eiYObzoKmQGZxPyEaCTikyArDzh8yL4HeUdVZINEEaUt6iKVW?=
 =?iso-8859-1?Q?xHLhgCzFELuKrhZdDYBz+dkOx/kl7lwCs7XHarIA56EH/PIBcLqfjGVrzi?=
 =?iso-8859-1?Q?P1RicKecpXpIor/TnxA6gf5FEcW1UL9thbm63g1qfiiGoVjImAXBCiszY4?=
 =?iso-8859-1?Q?+n4EYl+5ebtdUNpSCRmCg3i1I0ADVQiEb3q9eSNk0HiaKPNsR3LLsw+G0v?=
 =?iso-8859-1?Q?WIZ6Z513MRCQGCJkJ901mZz+NXjGvQ7gK5ouTViCu+WoRa2M3NmtPH0tKV?=
 =?iso-8859-1?Q?fnh+LM7SUPelrmF/akGWWhw+n4bLZbzcI4nEexSGQMZyQGqj9PuBpmfAyh?=
 =?iso-8859-1?Q?VlmD5A36WyNGBelvbkiCOVu8gfBqKAXpAMv1NflbUy2LpHAdwvLNbQ0xoN?=
 =?iso-8859-1?Q?heoKxsc+y4MkYskWGA7nRgrf+r3ebz9le/PY1pqAF7NOLI7gqCCZAaGu6j?=
 =?iso-8859-1?Q?uS7nzHiahZ86pxAbtJH4B6bakQd7kJK6msVl5Ul9OC73Kf4OlehOU70doL?=
 =?iso-8859-1?Q?GKmM6BSKq2bFf41qz0IJ5xRGidBqCpj7Ar3mMpyizmlk9tiDldEpFIiXhq?=
 =?iso-8859-1?Q?oCddaXa/+M0h35kJSLMquGmMCrxqiLwE1Me8Ol/O6Er9P0XpdJFZboIBBf?=
 =?iso-8859-1?Q?gPAB5V0e2v2oZjy57CP3UCidDouyZiunPxRZMx7PePwmf9mT5ns+6NVlkR?=
 =?iso-8859-1?Q?6TjUeSXJZzRJYUDUR4/RRVrI4wjJ4zOe41m8Ch39q2qrClmIszbIM6pCdj?=
 =?iso-8859-1?Q?IAUdvlfG9fQxRG39ZWX+nbgm9KPlSa7j56mHhGTVWalKEo1KMWKdE/q0Ya?=
 =?iso-8859-1?Q?NTD3h9xBnDxj81bH4PFHO1AWcQutg81wVFix8UDSHyLqeUAiG9lsqVK2OX?=
 =?iso-8859-1?Q?6t4QVS7n5PaZ3lPoS7F4QoTUS2OjtxJu9uC3LEJw3iLjmKvSxfXoy21seO?=
 =?iso-8859-1?Q?Eo8gvcJ9pD5u7MNSfyaMjFX/FYCaxZf0ZiRQQaISZZr30UFnJiPRWeSr3M?=
 =?iso-8859-1?Q?F/Eh7K+BCdYXBsveCA8XV8AP0G4bRdfXXOB4vJ3w7nRyz0TUoJjpzTEoms?=
 =?iso-8859-1?Q?MEtz6bRnxoptBrhigWuJaT8aUnt5L4ncOcrsUhTsFoRyzgHgGaNkRJf3xw?=
 =?iso-8859-1?Q?p0JTkgvK/431la8RTnlA6VQK23QgRUqPi3Ih9AP6OmFtW4zzFjXFKgzU8d?=
 =?iso-8859-1?Q?/VhyhUTym3b3Le6b1SC5pFEWXoML1Jx+2xW8uF4xHdNN6W73+Gz6mkO8Il?=
 =?iso-8859-1?Q?uAtqHC01RNmqKFIXbaVA3u74e0MZ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(27256017);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?iso-8859-1?Q?CwGwlRQGaL/CbJ37jOz6N9htBuA9DGJXqCmCTFguyZPY6z+nfuXFYpq/cw?=
 =?iso-8859-1?Q?gU1zAbEgflsp5TIVISpYYEepIwHP+QIRVVE7flP+MykXbhigjrWUMfYSTl?=
 =?iso-8859-1?Q?8Vf6p9Ybk3dxjrZzeo2W48UJRmM8t4oqedAU2wMCRVEl19MGeVCwfAsm2t?=
 =?iso-8859-1?Q?qpqikEwWaSoBLe39QP0ZdoFAYHv5AZQPPjj2yFe8lw3a4ig6XvzEZcW+jt?=
 =?iso-8859-1?Q?A9smC3KM10tG4IZT1xu2KhMoOdPYj/UaCrBZ60w/FumDlbRYGak9360PgL?=
 =?iso-8859-1?Q?CONb5+SbNT9S4Db9iVH3bDICvZpx4ryvxOuhsGhjQOR2TlArq797Scwc1l?=
 =?iso-8859-1?Q?5KJnhWAaKe4WeuaPT5TNbNhi4hDvHh+rLmdTeYHroxsrhMf9SmZrF4Q8sh?=
 =?iso-8859-1?Q?At0JNaegg8LIfRXIs2C1aP1T1rROlWuMXf10xKJH7VjgMLhGQruLr8n4RV?=
 =?iso-8859-1?Q?vKuI1HuEywC5O23lItO3MutQ04LnEpN8bLEp/rFP3Fes33SL4ZD1Etehgd?=
 =?iso-8859-1?Q?gzvW07ID4k/CvuKPsgCxnKWRc0BH3aP8oYlK5voPr3yayvzre0KWehIekq?=
 =?iso-8859-1?Q?bQj6h5GN1rQE1AMRMO3sQSGuPYjb9JKc21UnSUJ7leAbYCOrxGHl1pPqzQ?=
 =?iso-8859-1?Q?hLJv8p455pQTvrmr+OMZDTj19oTwxxweWvfNV8iH6H0EWc8btmtQQye3cw?=
 =?iso-8859-1?Q?uOcltqRlUlIXNNNJJSFgVrYQzYGkSQrD5HAfmayBi1l6ZMJYCdwfI/7MHP?=
 =?iso-8859-1?Q?AiIPOXo5gGuRgLZNEjN6ICuT+KZRKTYJB7VoB/IpQflehlMj/zDPKN6QkC?=
 =?iso-8859-1?Q?VaHpAuCroo7jccTqcjCm0Bu7MFCXCl9XEstVxp4Qt2RSFj9qVvjqC1l73q?=
 =?iso-8859-1?Q?VlWetuTde3jpbcZrU8+19ADBumD7bpnlUNuk2OhFWnUoWsMdbT3bNtmOFB?=
 =?iso-8859-1?Q?ylJTXhLrmGEU5xLcK00u/wjIza67X6bP+soFYpNsW28j7HdBbx2kk560dj?=
 =?iso-8859-1?Q?bjleA0aVlaqPtUqYxmelignZiMFCWgAS0eVCW/lByNhKrseLYQQ3sQvbD2?=
 =?iso-8859-1?Q?PH6m9+erT4jVvdN/kpQ+RO0e/Vj7ExYgMYoRDNz8ZawV5fo4/S7oA88uLf?=
 =?iso-8859-1?Q?t8w2oe3vTgb+Tgs2IU3ipxk0DGxHsvjzrRKNSoYb3y87lYJ08jjuKpCfbM?=
 =?iso-8859-1?Q?3t9iGyNypS8VLYz2dWGqH+yD4XrwpRlWMspPwk2nYKgy810XmVqZw3diqE?=
 =?iso-8859-1?Q?B1SSvObDHzHb6Yc/ToO6GHPumJEiEtbLnlNJNkNan0rOCMZKJmB8bQSkgz?=
 =?iso-8859-1?Q?GZ0lbrlORUHPkiEO+ZzSG6VrWvCTbJ/U3k3+7oG5H+8UBa+1NiSWzOmHng?=
 =?iso-8859-1?Q?V67mkHP1slMw+S5vOpabqG7ehdZgHywoF0ck23flIr/CCLwtE++0+fdean?=
 =?iso-8859-1?Q?CfNFYeO+8c7fLOHVo9Vf5vjgVM7JyDVtMu9TDBJK7zCi4My/gRE15J0Wg2?=
 =?iso-8859-1?Q?LHgncb55xNedjyhRNCZz7tCLb2WdW3W8haglatztJ23Pj+ST9eFAkdy7vz?=
 =?iso-8859-1?Q?RuIo4MjWIw+cv5u/06ZK5kqTh27jipi9QIby8AXMxH7fuSQTIFElG89VdE?=
 =?iso-8859-1?Q?DfUFwnBXrVokYnUcNVG9Am1ejOKBB+tVJg?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	BzScGKfmWNARTyc/c5xsNtmsuLjGdEgYf0ytfViRe2udwYVpM3POa0IXMIXE+9nTXzWchYcP6wPQgfDbHYYgjxU6bj8peVaotePR/ROg3sf9944TTi70pARO4HT+C+Z5u8A+fwIfGxtoLsnxx4V6QrzPPPIA37lv7u4ueVF0c1Xa1QIFXRZZGTUKLtPpu2nxcjlrWTJiRnJuiM5XjllPRtQvfIhxpnRuHk8FINxLICDJnCtACNWsxkJjvxmrM+6rBxtDNZ24xlttVngQ2Zh1cjr8xE+7uEkmlQSlbD01lTuTDdt1v+Lg5Uwk2dsfLvKXTE4vcwOdGSku1BzK738ZTbKmKOw6pAmqPekhvkYLTwtP03u0FpqusPBDK9pfrrfO72UeQ+pX7LHbRg1eCChDwti1pWRb5E8NxxaLb0RNkvvbUlDGizwgiIllQtY2cwm+cVCi9d8zwJxk5GuQx9V9jfbb5vSlB58mBGQgzAt0PNvzVJK5fwAg4I0ehm9LRFI15sQfTXFsiY9ZzKvHCBtPigYg0WE2eh7DBhuIKF+TzdXvv5qjBtMXUrytvMPFofh4I9A4cAL+wOLVUJlw63VrF5g9n2KHhp1GVklgEpmwObE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2a87043-d75c-4708-93bb-08de3e73c824
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2025 20:26:53.4885
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g7J9xOuGEptITjfFYSsY7tyBDTalAQ/dKiR+8Vpwb6kXgmioJvUPMGfNwZkXI+LnB+norKC5yhNQYFLOPSvNEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5022
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-18_03,2025-12-17_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2512180169
X-Authority-Analysis: v=2.4 cv=YJmSCBGx c=1 sm=1 tr=0 ts=69446393 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=8nJEP1OIZ-IA:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=VwQbUJbxAAAA:8 a=1hcZ96g0T1X8wApP0doA:9 a=wPNLvfGTeEIA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE4MDE3MCBTYWx0ZWRfX5DzLm1zs1o5H
 uqvCKZrIJaBkqSXfcw/o9K52ay0Obug4lrU5q9ZbtkG2gZxczLXCpVMU47iAh/LBgQTe/cXZYPJ
 PR7aYOkmCnC1ARuMrclRZYP0E3ClPT53xyRMoBzZ7WBKbz2i60the4wYBnEWXj8l3hTBJ4KYJZL
 gHTITa04r/chH+fT7iP1WgzoNHphfSwzf8qzqV0Pl1ojZrmxoDhfCDLGfWKgVohczJ/GWyuARM3
 99z4istxHfz0E9RymKwmILvcETExL/NgKm6Nr0zKep21AJ3RAKEAH0EkT8R9CqG8x6GjcXbyuar
 17zMZEjc3vGltEHObZAOTZUgrygzqyjibuJvbFCghvlocR3XalHMIlGhkOj8GOo+SpylWPYsU4H
 SXtPAhn7MjGnYg41OST074OuiNAglNFyVMbF9TbfmOmC+g5OO6v83dfSB8Ol33FLXOpjoPOuD98
 T+x5h414dj3ALaFuwnw==
X-Proofpoint-ORIG-GUID: bkgEKgiQNKmJgTre8jey3yxyphZg5UQK
X-Proofpoint-GUID: bkgEKgiQNKmJgTre8jey3yxyphZg5UQK
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 524968000C
X-Stat-Signature: z5ou6q5pzo5mhafm4w1eri5y8wtdfsra
X-HE-Tag: 1766089628-199142
X-HE-Meta: U2FsdGVkX1/Ez5bo6Wn5NpypT2fTjPoM5W2LoWMJcWyKgLDn2Y9h/uCA7GLIZT89VSMUF2GCGZcebZ0lSPB6SjH4j0FsqlsyrFvfjy4H2OML6L8tqTo/sdhmQFuXkooquOoCPqUSjXLsvLP7QP+WUvOVIeT5gGAvVZcuy4BDzXJuHuqlK76suxIUmlbggDmhxXWLI97GOcTPf2TkgYDSlA1It3/hsEUc6Q/18VFCiC60qiTCevt92ObEknGXJGLDDqMY2HOAwW9dSJiCYwrqINXTblprtYfcAEJkhoCv2fN03Ve+SXJ28q5ImHzSSEbai7ZsGzS8Jw8m5vlKiMR4mmk5pWpV1udFSwCXMo6w2aS3GOU28vQi8q8y/JqfmcyJRJdZlQdDptrbEzsednVm/vJKrlMVV/wPZGCZU/jIBe30YVisZBbjCHYQNT6UPjhh9JUKNRTt8Q9hsJhlMgAAcroEJ7wmxjj6AabowNrgXYkROwJUYtEUcfYd+f+Do8EbHaSUgxm9ecvXMEEoYG0y1m19eY+EXXPbBY7FyQfcPlVCZpnq5uOYLh0VhtNX1DQD5LBFiLpszXKdSiR9wkHIO7TLAB+QnxWAFoHkBRL/Rz6cJl+iFs3vAfllLGZqb5IAqNMTM7fhSodzkH37w3oKutze+QYUUDavSBcmFH1hYjDNRkEjLpyDpUj4Wgb22pvm0ojF5Tq9xp2tKRlRCQvBOrH7kr7R+HaZm0kpxf2Ll7yQrFpScEffYg5AuQGOVo3nEwFpuru/7O6rpchN15dwVvp9JgUw4HZMMaeCIWSrPfCiXX7Y4HWhlF49wg+AH3a0jrcv1o8cIm7xLam+KE6ZY32mCvoij53Fj/QVHzkOocZkGEJqY/EBI5m+AW/vOq4/0Wti2DqhE9MGnlEaWHslifa6Kq4yeS3O02FO9jMidv+4N7aiCHA4oOQTD+XdVV15LA9MlTgIu2BQ2m7RIsQ
 c1NkAaxd
 /7a91AwEagUVm9/NS5ZDxGgKw90L/AWCYYb0woXPJigGaaZi6cRTbh/mwYR0xQoThfUPjKha6bsLzzbtDb7fvI2aYBNw+zz9+URoswHcStbEQrhLmanmOaEBbiGx7QbLq6faNFSX07wEr0quxzkVIb2fidHKqnDHaLZ9WhcZ17+0DaZfHWY8Bdwx6XsL0PjnoUB9r+YfkcjhHfWopw8AZOuYyqKfu4iHgExlawA9gWWHSgovYMETKnKESjRTyz1Nhig23r8Px430OXAzDx3Rh7i/mM/+jz4Hp6X0NNVCY2jBgZxN3J01ohTMZK8z0pJywT/FVam2H4/UMNPT4dlek8mJAIhId2DqUZKBr6Q/5DhowMzdGims8SPg0dbBk2iLGQ+l6q/k70pJ92liz2NWOGr527TTrqG+IPFPjkdZ11tamk7wUIhsUvxxNr/iMWSiavk35KhGUUN2TGKGzLjl1aXNT/YkJvek/DR9if0N0/c4hwWPgQyK+PaoGnYwXpn4J1fa2yoXG+2VSPztW8Bvxr0wKL1HGduhxZgs2XmmSJmGOSGyOeN+m/kmSGdxNPxKNrkdk1YZ28wJwXEPZM9A7vvfYKv9XPq33of8g97mpIZD9Q1Wsm9BrHb7+zdrRV44wwZVTBI85ZKnED9FsRLykkOFuwKM3QNI+ouko2hC7bG/+uCs0F0LnSUvG1me4cwuMxT7QKjsi2IRBFy9QgbnHKdOdmw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* jane.chu@oracle.com <jane.chu@oracle.com> [251218 14:01]:
> Hi, David,
>=20
> Thanks for the review.
>=20
> On 12/18/2025 12:41 AM, David Hildenbrand (Red Hat) wrote:
> > On 12/16/25 22:56, Jane Chu wrote:
> > > When a newly poisoned subpage ends up in an already poisoned hugetlb
> >=20
> > The concept of subpages does not exist. It's a page of a hugetlb folio.
>=20
> Okay.
>=20
> >=20
> > > folio, 'num_poisoned_pages' is incremented, but the per node ->mf_sta=
ts
> > > is not. Fix the inconsistency by designating action_result() to updat=
e
> > > them both.
> >=20
> > What is the user-visible result of that?
>=20
> For the purpose of observation, and potential action afterwards.
>=20
> # cat /proc/meminfo | grep HardwareCorrupted
> shows 'num_poisoned_pages', the global count of poisoned pages.
>=20
> # ls /sys/devices/system/node/node0/memory_failure
> delayed  failed  ignored  recovered  total
> these fields show the per node ->mf_stats, that is the MF handling result=
s.
>=20
> >=20
> > >=20
> > > Fixes: 18f41fa616ee4 ("mm: memory-failure: bump memory failure stats
> > > to pglist_data")
> > > Cc: <stable@vger.kernel.org>
> > > Signed-off-by: Jane Chu <jane.chu@oracle.com>
> > > ---
> > > =A0 include/linux/hugetlb.h |=A0 4 ++--
> > > =A0 include/linux/mm.h=A0=A0=A0=A0=A0 |=A0 4 ++--
> > > =A0 mm/hugetlb.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 4 ++--
> > > =A0 mm/memory-failure.c=A0=A0=A0=A0 | 22 +++++++++++++---------
> > > =A0 4 files changed, 19 insertions(+), 15 deletions(-)
> > >=20
> > > diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> > > index 8e63e46b8e1f..2e6690c9df96 100644
> > > --- a/include/linux/hugetlb.h
> > > +++ b/include/linux/hugetlb.h
> > > @@ -157,7 +157,7 @@ long hugetlb_unreserve_pages(struct inode
> > > *inode, long start, long end,
> > > =A0 bool folio_isolate_hugetlb(struct folio *folio, struct list_head
> > > *list);
> > > =A0 int get_hwpoison_hugetlb_folio(struct folio *folio, bool *hugetlb=
,
> > > bool unpoison);
> > > =A0 int get_huge_page_for_hwpoison(unsigned long pfn, int flags,
> > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 bool *migratable_clear=
ed);
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 bool *migratable_clear=
ed, bool *samepg);
> > > =A0 void folio_putback_hugetlb(struct folio *folio);
> > > =A0 void move_hugetlb_state(struct folio *old_folio, struct folio
> > > *new_folio, int reason);
> > > =A0 void hugetlb_fix_reserve_counts(struct inode *inode);
> > > @@ -420,7 +420,7 @@ static inline int
> > > get_hwpoison_hugetlb_folio(struct folio *folio, bool *hugetlb,
> > > =A0 }
> > > =A0 static inline int get_huge_page_for_hwpoison(unsigned long pfn,
> > > int flags,
> > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 bool *migr=
atable_cleared)
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 bool *migr=
atable_cleared, bool *samepg)
> > > =A0 {
> > > =A0=A0=A0=A0=A0 return 0;
> > > =A0 }
> > > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > > index 7c79b3369b82..68b1812e9c0a 100644
> > > --- a/include/linux/mm.h
> > > +++ b/include/linux/mm.h
> > > @@ -4036,7 +4036,7 @@ extern int soft_offline_page(unsigned long
> > > pfn, int flags);
> > > =A0 extern const struct attribute_group memory_failure_attr_group;
> > > =A0 extern void memory_failure_queue(unsigned long pfn, int flags);
> > > =A0 extern int __get_huge_page_for_hwpoison(unsigned long pfn, int fl=
ags,
> > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 bool *migr=
atable_cleared);
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 bool *migr=
atable_cleared, bool *samepg);
> > > =A0 void num_poisoned_pages_inc(unsigned long pfn);
> > > =A0 void num_poisoned_pages_sub(unsigned long pfn, long i);
> > > =A0 #else
> > > @@ -4045,7 +4045,7 @@ static inline void
> > > memory_failure_queue(unsigned long pfn, int flags)
> > > =A0 }
> > > =A0 static inline int __get_huge_page_for_hwpoison(unsigned long pfn,
> > > int flags,
> > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 bool *migr=
atable_cleared)
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 bool *migr=
atable_cleared, bool *samepg)
> > > =A0 {
> > > =A0=A0=A0=A0=A0 return 0;
> > > =A0 }
> > > diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> > > index 0455119716ec..f78562a578e5 100644
> > > --- a/mm/hugetlb.c
> > > +++ b/mm/hugetlb.c
> > > @@ -7818,12 +7818,12 @@ int get_hwpoison_hugetlb_folio(struct folio
> > > *folio, bool *hugetlb, bool unpoison
> > > =A0 }
> > > =A0 int get_huge_page_for_hwpoison(unsigned long pfn, int flags,
> > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 bool *migratable_clear=
ed)
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 bool *migratable_clear=
ed, bool *samepg)
> > > =A0 {
> > > =A0=A0=A0=A0=A0 int ret;
> > > =A0=A0=A0=A0=A0 spin_lock_irq(&hugetlb_lock);
> > > -=A0=A0=A0 ret =3D __get_huge_page_for_hwpoison(pfn, flags, migratabl=
e_cleared);
> > > +=A0=A0=A0 ret =3D __get_huge_page_for_hwpoison(pfn, flags,
> > > migratable_cleared, samepg);
> > > =A0=A0=A0=A0=A0 spin_unlock_irq(&hugetlb_lock);
> > > =A0=A0=A0=A0=A0 return ret;
> > > =A0 }
> > > diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> > > index 3edebb0cda30..070f43bb110a 100644
> > > --- a/mm/memory-failure.c
> > > +++ b/mm/memory-failure.c
> > > @@ -1873,7 +1873,8 @@ static unsigned long
> > > __folio_free_raw_hwp(struct folio *folio, bool move_flag)
> > > =A0=A0=A0=A0=A0 return count;
> > > =A0 }
> > > -static int folio_set_hugetlb_hwpoison(struct folio *folio, struct
> > > page *page)
> > > +static int folio_set_hugetlb_hwpoison(struct folio *folio, struct
> > > page *page,
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 bool *same=
pg)
> > > =A0 {
> > > =A0=A0=A0=A0=A0 struct llist_head *head;
> > > =A0=A0=A0=A0=A0 struct raw_hwp_page *raw_hwp;
> > > @@ -1889,17 +1890,16 @@ static int folio_set_hugetlb_hwpoison(struct
> > > folio *folio, struct page *page)
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0 return -EHWPOISON;
> > > =A0=A0=A0=A0=A0 head =3D raw_hwp_list_head(folio);
> > > =A0=A0=A0=A0=A0 llist_for_each_entry(p, head->first, node) {
> > > -=A0=A0=A0=A0=A0=A0=A0 if (p->page =3D=3D page)
> > > +=A0=A0=A0=A0=A0=A0=A0 if (p->page =3D=3D page) {
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 *samepg =3D true;
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return -EHWPOISON;
> > > +=A0=A0=A0=A0=A0=A0=A0 }
> > > =A0=A0=A0=A0=A0 }
> > > =A0=A0=A0=A0=A0 raw_hwp =3D kmalloc(sizeof(struct raw_hwp_page), GFP_=
ATOMIC);
> > > =A0=A0=A0=A0=A0 if (raw_hwp) {
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0 raw_hwp->page =3D page;
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0 llist_add(&raw_hwp->node, head);
> > > -=A0=A0=A0=A0=A0=A0=A0 /* the first error event will be counted in ac=
tion_result(). */
> > > -=A0=A0=A0=A0=A0=A0=A0 if (ret)
> > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 num_poisoned_pages_inc(page_to_pfn=
(page));
> > > =A0=A0=A0=A0=A0 } else {
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0 /*
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * Failed to save raw error info.=A0 We=
 no longer trace all
> > > @@ -1956,7 +1956,7 @@ void folio_clear_hugetlb_hwpoison(struct folio
> > > *folio)
> > > =A0=A0 *=A0=A0 -EHWPOISON=A0=A0=A0 - the hugepage is already hwpoison=
ed
> > > =A0=A0 */
> > > =A0 int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
> > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 bool *migratable_cl=
eared)
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 bool *migratable_cl=
eared, bool *samepg)
> > > =A0 {
> > > =A0=A0=A0=A0=A0 struct page *page =3D pfn_to_page(pfn);
> > > =A0=A0=A0=A0=A0 struct folio *folio =3D page_folio(page);
> > > @@ -1981,7 +1981,7 @@ int __get_huge_page_for_hwpoison(unsigned long
> > > pfn, int flags,
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 goto out;
> > > =A0=A0=A0=A0=A0 }
> > > -=A0=A0=A0 if (folio_set_hugetlb_hwpoison(folio, page)) {
> > > +=A0=A0=A0 if (folio_set_hugetlb_hwpoison(folio, page, samepg)) {
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0 ret =3D -EHWPOISON;
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0 goto out;
> > > =A0=A0=A0=A0=A0 }
> > > @@ -2014,11 +2014,12 @@ static int
> > > try_memory_failure_hugetlb(unsigned long pfn, int flags, int
> > > *hugetlb
> > > =A0=A0=A0=A0=A0 struct page *p =3D pfn_to_page(pfn);
> > > =A0=A0=A0=A0=A0 struct folio *folio;
> > > =A0=A0=A0=A0=A0 unsigned long page_flags;
> > > +=A0=A0=A0 bool samepg =3D false;
> > > =A0=A0=A0=A0=A0 bool migratable_cleared =3D false;
> > > =A0=A0=A0=A0=A0 *hugetlb =3D 1;
> > > =A0 retry:
> > > -=A0=A0=A0 res =3D get_huge_page_for_hwpoison(pfn, flags, &migratable=
_cleared);
> > > +=A0=A0=A0 res =3D get_huge_page_for_hwpoison(pfn, flags,
> > > &migratable_cleared, &samepg);
> > > =A0=A0=A0=A0=A0 if (res =3D=3D 2) { /* fallback to normal page handli=
ng */
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0 *hugetlb =3D 0;
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0 return 0;
> > > @@ -2027,7 +2028,10 @@ static int
> > > try_memory_failure_hugetlb(unsigned long pfn, int flags, int
> > > *hugetlb
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 folio =3D page_folio(p);
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 res =3D kill_accessing_proces=
s(current,
> > > folio_pfn(folio), flags);
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0 }
> > > -=A0=A0=A0=A0=A0=A0=A0 action_result(pfn, MF_MSG_ALREADY_POISONED, MF=
_FAILED);
> > > +=A0=A0=A0=A0=A0=A0=A0 if (samepg)
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 action_result(pfn, MF_MSG_ALREADY_=
POISONED, MF_FAILED);
> > > +=A0=A0=A0=A0=A0=A0=A0 else
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 action_result(pfn, MF_MSG_HUGE, MF=
_FAILED);
> >=20
> > Can't we somehow return that result from get_huge_page_for_hwpoison()
> > ... folio_set_hugetlb_hwpoison() differently? E.g., return an enum
> > instead of "-EHWPOISON" or magic value "2".
>=20
> This is an option. The existing return codes are as follow.
> __get_huge_page_for_hwpoison():
>  * Return values:
>  *   0             - free hugepage
>  *   1             - in-use hugepage
>  *   2             - not a hugepage
>  *   -EBUSY        - the hugepage is busy (try to retry)
>  *   -EHWPOISON    - the hugepage is already hwpoisoned
>=20
> folio_set_hugetlb_hwpoison()
> returns
> 	0:		folio was not poisoned before
> 	-EHWPOISON:	folio was poisoned before
>=20
> To get rid of 'samepg', how about
>=20
> __get_huge_page_for_hwpoison():
>  * Return values:
>  *   0             - free hugepage
>  *   1             - in-use hugepage
>  *   2             - not a hugepage
>  *   3		   - the hugepage is already hwpoisoned in different page
>  *   4  	   - the hugepage is already hwpoisoned in the same page
>  *   -EBUSY        - the hugepage is busy (try to retry)
>=20
> folio_set_hugetlb_hwpoison()
> returns
> 	0:		folio was not poisoned before
> 	1:	        folio was poisoned before in different page
> 	2:	        folio was poisoned before in the same page
>=20
> The whole point about identifying the same page is so that the re-poison
> event is not doubled counted.

This means folio_set_hugetlb_hwpoison() returns 0 on success but
positives on error.. this seems to be going further away from the
standard way of doing things?

It would actually be good to remove all magic values instead of
expanding them.

I think what David was trying to say is to have a local enum that states
what these numbers mean so that the code reads more cleanly, instead of
digging for the right comment to decode it.

For example, in try_memory_failure_hugetlb():

if (res =3D=3D 2) { /* fallback to normal page handling */

vs:

if (res =3D=3D MEMORY_FAILURE_NOT_HUGEPAGE) { /* fallback to normal page ha=
ndling */

You could spell out your other options as well.  Maybe something like
MEMORY_FAILURE_HWPOISONED_ALREADY_COUNTED
MEMORY_FAILURE_HWPOISONED

This would avoid adding more magic values and increase readability.

If you changed try_memory_failure_hugetlb() to use a switch statement,
then the compiler can catch unchecked enums for us too.

If you don't want to go the enum route, then you could use a different
error code and propagate it through, like -EEXISTS for the new case?
That way the return is still 0 on success and less than 0 on failure,
but I think the enum idea has a number of advantages.

Thanks,
Liam


