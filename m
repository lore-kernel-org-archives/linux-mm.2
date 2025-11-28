Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE406CFD376
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 16:14:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25CD86B0027; Fri, 28 Nov 2025 11:14:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 233E96B0029; Fri, 28 Nov 2025 11:14:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FADD6B002B; Fri, 28 Nov 2025 11:14:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F26F36B0027
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 11:14:31 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A6BD95091A
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 16:14:31 +0000 (UTC)
X-FDA: 84160513542.22.FFD9C60
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf10.hostedemail.com (Postfix) with ESMTP id 20722C0005
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 16:14:27 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=NVycg29K;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Xn00rlen;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764346468; a=rsa-sha256;
	cv=pass;
	b=qBxI0g7nsAP4kx/wswYUpUBMlNBjb8oUASLVqWnqW3HieLh0k8VIXYDT9zSgh0Z9nGbQDV
	kPWmkk4f2vUL6M/H1bc+EzrSq0CkOW4j6q2jLE3ars4GY0B6YqpLtZy9r1rwP8+NBiDU36
	vIwgTj3FJILzWa8MWExlymh0qGlKDLg=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=NVycg29K;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Xn00rlen;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764346468;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xdHU+CVZRek5n2TgFyri4H4pgLjRKBZy9POcIHjtZ/E=;
	b=a77sDPMJ5ZsxdiViCXNj5kQlBj7fQ4mix/FB+GSw6F82JbV4E7+F1am3w8itAf9VHLUsjw
	oiqpWw8DL3GeQrGZ/UEUGxWxBjzbU7Q201bBkFvb7Jfns09doiv1os6F/1bg2lESYxpCNC
	6KExgj/lr2hXr0ZpDq1XLAec6gO7vXo=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AS7tvtM2969032;
	Fri, 28 Nov 2025 16:13:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=xdHU+CVZRek5n2TgFy
	ri4H4pgLjRKBZy9POcIHjtZ/E=; b=NVycg29KI/8AlrruThS/JamrOnjYJm9nZM
	3c8RUvXHp2pB+eqXEvaSyuY4jrRNa3OHfaA7BpE+aGI5Fi0v7Tf9KWJoLVBG4K3m
	bwSjTTrM2z+xq+MdJk+//Sc8zu/7BJJ/nC4DVIQjQHmLT30WHrp5vSbXRHQ68m/c
	6UDB9lIx9In5mrXPbCPj8CV+0xt9S0rLwam01KFBF1fRDRl3lP3VxvjCLUEDToIn
	Avp1Dw9aWC6zIG13EisvZTYAvIKCX2ZfHdu6F6tbtfW8lXvhfQtwtLq9c4V3BiUX
	Z7ZnpVkuMg2slNdJ2fuMiFesI3C3iIocjvhhvy3dIbY6oYz75ogA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4apm7vj2fb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 28 Nov 2025 16:13:54 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5ASEUSU0018823;
	Fri, 28 Nov 2025 16:13:53 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010011.outbound.protection.outlook.com [40.93.198.11])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ak3mdd1tg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 28 Nov 2025 16:13:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rNCqRCvO4wbzzuEIKr1f9+42oYGo9rCpjM3JbeY36ZETAPKloawGppU0plj6X5Ewf7v6q3IucOGYM8FbFGbkxfukE3/SBlEuv6Ln4OnALx1q4HTMk/6EveRJ2ydz4NXS3KUEVpy3HOH0oJW881ojIjOGOHIN41BGjGB/pRnFO6xgb19lYRIVlC2Iv8GGsX8+txPeYyq2tRxlJNZvYld2XCFBXzTO25qVBFuR46ujfesPJwEjpXOCi+xst3rDCqEpdVYLND+WDxRmXhFg8GldMCGEyEm4Mua4hamG5TUOXv8uBkaxf8gn25/t/7MV/+mTr3EmxhxO2qgiDYIX2JfAWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xdHU+CVZRek5n2TgFyri4H4pgLjRKBZy9POcIHjtZ/E=;
 b=FibC9JutwAb6juFlxMxuDqyOtbX3ehQGw4mU5+aDXj9m7eQJS/n9YJwnxSlVP7fDXnuo4ceRcJNwj0B3L7jLen0UvZDKEOJF8i38VYp0E113eoBqTN6vkzooKQdpAG+HabC3IFiuowZ5iojRJmq7SWMnWVb9DyEdDgzXIB7jp2iz7QnyWNl5dZCJ0hWSa4TLHuOWzrqKNVvZnQPsZ1KmhMrR3c1L+WO7elaHLLVclAa3ln9Nl4O1hbqs3HsWUZZouUL1TNJEyMU3mAGnrWCfz6gnX1Zllnm5gejPlbAh/fF27bnaM3LCktPvjqdRnryhOg6Re7fl7CCHiUdRCiLkFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xdHU+CVZRek5n2TgFyri4H4pgLjRKBZy9POcIHjtZ/E=;
 b=Xn00rlenFrl2F0K+5bjhjBUBhzfcE+uxC0rPZ4adyaiPNtmm0fICCWogwoOKfnUIwap1+8jv4kJRdLRg7M+npsKtTnI1hN0rSCvmrdzifKD+aZ3lhREu9YGwXCg2S2J0U4kqJkbmPRO8+EGjMq7moELWbo9ZIJq3wcsPkz1/mZQ=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by PH0PR10MB5548.namprd10.prod.outlook.com (2603:10b6:510:db::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Fri, 28 Nov
 2025 16:13:49 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9366.012; Fri, 28 Nov 2025
 16:13:49 +0000
Date: Fri, 28 Nov 2025 11:13:37 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: Zicheng Wang <wangzicheng@honor.com>, akpm@linux-foundation.org,
        hannes@cmpxchg.org, david@redhat.com, axelrasmussen@google.com,
        yuanchu@google.com, mhocko@kernel.org, zhengqi.arch@bytedance.com,
        shakeel.butt@linux.dev, lorenzo.stoakes@oracle.com, weixugc@google.com,
        vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
        corbet@lwn.net, linux-mm@kvack.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] mm/lru_gen: move lru_gen control interface from
 debugfs to procfs
Message-ID: <ti7h5cbrg5s3zf7surof3zmxb6supnl34x7hsbziqutm7r2laf@zuunap5hwsbx>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Matthew Wilcox <willy@infradead.org>, Zicheng Wang <wangzicheng@honor.com>, akpm@linux-foundation.org, 
	hannes@cmpxchg.org, david@redhat.com, axelrasmussen@google.com, yuanchu@google.com, 
	mhocko@kernel.org, zhengqi.arch@bytedance.com, shakeel.butt@linux.dev, 
	lorenzo.stoakes@oracle.com, weixugc@google.com, vbabka@suse.cz, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, corbet@lwn.net, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20251128025315.3520689-1-wangzicheng@honor.com>
 <aSm800KsCAptVZKu@casper.infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aSm800KsCAptVZKu@casper.infradead.org>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: MW4PR03CA0352.namprd03.prod.outlook.com
 (2603:10b6:303:dc::27) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|PH0PR10MB5548:EE_
X-MS-Office365-Filtering-Correlation-Id: b36f3c9d-d240-4fad-4113-08de2e991d85
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?C9FNKlH7oVd5GQFpFDz4SLtfbVFNIQyMyg34Z4X2kIHKb8CumeUWolveq2zt?=
 =?us-ascii?Q?b/twZhzDsj8JzDLhKrsSbx80ISx5nS59zP7xOdc2mO8EZrtcmAT6SVVnY7W7?=
 =?us-ascii?Q?J+MHIv1x4Ej+k7EIQYYq8BRqqpQrq+BGW3vYsqSd5b+KLV9J3/80KYW0eDaS?=
 =?us-ascii?Q?M4dTw/Ub9E/YnCkqs+SVClxSI2xH9buRi9K4KLQ/BHI59aDez+bLErTadQRQ?=
 =?us-ascii?Q?O6lU2Ni77PRm3i6RBnYKzy51LRURkzuZL6Gzq9S9RBx30rFCwt5D+TezBxpx?=
 =?us-ascii?Q?XBlUK2Hd8VMU77kA/phMysEkb2umsu4CD7jCGYW+G1Wm3QZY0T7nxDp1yAnp?=
 =?us-ascii?Q?6K6zlbyW+nkdeN81rfM/MfYDZE957T28Wbrh7kwbQVZDpmvb58x1mRBEO27L?=
 =?us-ascii?Q?CFPtd3J+D3naojtMtlKjN1gqMjlXweBJRYe524ehQx1wi9CSVVYrp0U2SzN9?=
 =?us-ascii?Q?7yzTS5E1crMcspWSvC1e6fK3UI0I5G1o+FfPJq/fzZq0gT7pDheGLrn2Kn8o?=
 =?us-ascii?Q?30jksSdlMGN+X1mPeyF5HUR2OH1PaQ5wlnZC0arD7/JWNBWAazwKRmhN3d27?=
 =?us-ascii?Q?xedlLH0OKSmoH4jE4y36btJyEe6/jEt5Wz6AnvHJafh2sXlAEIPuMAn0HYwl?=
 =?us-ascii?Q?mI5Fna0WPFzAm1a2qURgJwXnSlFV3ERGj4ewthAR8dvBtaiNBmhOWfQKJliP?=
 =?us-ascii?Q?3KieEv8xTfdqOab4CGSdKZs3Xw9wLIaJVap/Ni83xiZTSLMZT5AqXOkVPBGK?=
 =?us-ascii?Q?FdYMnifeJOTrG4DDesJdrMncU4uxgOuDqUE7nyEGl8heDYh++8YCv3Yv5BQ/?=
 =?us-ascii?Q?UOWsgMIUtxX7f2zZg2yOq+1DtgpNrBy2le/BlqmX3hoSb3NWeDNqyHB7dL72?=
 =?us-ascii?Q?Xmg/q8ObPzcO5curKG7TkYzHTAXtzC6+O556u9mtTBo9hYjlmJSNrWFWlVGG?=
 =?us-ascii?Q?NcNR079KN+K5bbpbprboTLCX6V1eVBIk9Tz28C2Ye1hg1G6MqLcfpEPSSy7i?=
 =?us-ascii?Q?tKdElJkJF7qexigj4pdUNhwxK++TAfcMPIE6+Sq0pMPc4n5k6LwL4jo45h2F?=
 =?us-ascii?Q?zkICl6rbuPuSf8rgmJfXCqpi6rhYnk0DWRom6Lw1rEUhTyDdkQxq4Ziv5aDl?=
 =?us-ascii?Q?0Bt1OyfydIgpp94KrM5c6Kt/1lPf7EKEPbdoxmhd9zLa6iNBJUFZCdZz+V02?=
 =?us-ascii?Q?ge0XLTgyHJ8I29aP0TNnnc0DNG03NwtKGftdcvRqsulJ2+CSyCEM755O7vBt?=
 =?us-ascii?Q?AqEnPKlnzW/M9e+D0bKxFkJY6Q31jSYYxlkJxiCCp9W5dAYumrbw5rV+aPfe?=
 =?us-ascii?Q?vEWFrOlsgD8IEi72K6xM2ut+5vwOy7rvq2n+vKXC98EjqdXj2lVSuK9tBFV5?=
 =?us-ascii?Q?J/q+CT9lOxlqyijtmBHO2CqrsqsV9F0MnZOAOBkLxm/c5u3HEBffNlTJhRiq?=
 =?us-ascii?Q?oeUZ5cOssP4zACnG+nawQkOGJYb5KXlEd45wGvjGgkve0LlJjjmrtQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?uRomC2T/HF0uflwT3riEBdQqZxFTrbbqm+jHOSm7LD7tu0934hmXk0nhgIjI?=
 =?us-ascii?Q?qFAPYDE06IU5KtYnl6B3PoKGynQ475voxfsEdKfED6g6sfkuYu48aPY7KZug?=
 =?us-ascii?Q?L8yrWA75aO4EyhB0JeMRBlGnCNaN4y532nktu1qZmU3hk8vI58TbxGltR3TV?=
 =?us-ascii?Q?J5chHUm0pr0ZQiguK++EHhom3MDDw37xIuNOrg3UsJjfIY/+NqvVFPOucBJ3?=
 =?us-ascii?Q?FY1BS/72FZt3V1Zcb1CIm3JwHN5Df+umTaeGjUmik23SAihfjbHVihflNkKR?=
 =?us-ascii?Q?3f3jpVHK53woKTqvj+M/S7x8v8J/Fs05ktZt7jXQbBNFoTwUAvzQWNUthEgf?=
 =?us-ascii?Q?fTrgU2s2oMzEMSg6tlawqXP8V2eByuehL8L69ok9lXEqziyxgVANJs5hSoAR?=
 =?us-ascii?Q?qK7CKjfYnaCmUI9bDUzDS5tsM9DYYQKpoi8xd6Iakzqgff+JOs+cR5aAPgGC?=
 =?us-ascii?Q?BLVbQXJkk9cAsv/iG27AnB6/i7eDnmnGK8Kb+nyDzagANxKFCUDja/E3+ccO?=
 =?us-ascii?Q?SvArasiVfz+YwQ6thYhqYPv/wi88zGCnHW1xQG9wlZ8S/FgGKDX+uVOHM9jd?=
 =?us-ascii?Q?TPsZOtyVa8QTiy8OsT5lhIDcbMfI4Pms7Uv8DnCaSgfEVpTZmFVfVEgma7fl?=
 =?us-ascii?Q?3UTJhU8DHfTaVz4GCG9hsj8OLDDpf8Ia6aFGz/Zxgm3JnRKNPajd4ynQpf0r?=
 =?us-ascii?Q?plqgX1+sTXerudqVX914k5D4ujXGxFrhSgVv6WpO4zo3qg604lHbK5TDvBm6?=
 =?us-ascii?Q?ymvoIfI9eSXM42A4aQ9aS0q+WTw70QeUBTUnKEyCDaAGDXAjaiRtIcMoxxW/?=
 =?us-ascii?Q?qY6w6tV4yXdHV/7sNntmKJTAFhK7wNIhhsZBf313luhl0DXWLeANX3DDLHIM?=
 =?us-ascii?Q?jLurOC+eq8KEDvEQH91NdkIlWMzga0rp01p32hovwuuvpTvYm223g03iijtF?=
 =?us-ascii?Q?aNusZMX+j8mB7sDvzDh4b63xu0os8maantKiQSBf1M/en8nOGLJLGljZHrSY?=
 =?us-ascii?Q?15QAkxUQMaPqnrI/wdvXv5m0GhYtD/0RShLTW1Qrj4iG0A/eJ1cIXzwOd/dE?=
 =?us-ascii?Q?8bCtS2Gy6/2iqSrJH0ji+l89hH7wbzKJ0VhKnEb6j0LBOyWKtGbjtfIE/hCc?=
 =?us-ascii?Q?vWp+8YHVtUZUvqYTIOHoJcanYHuZ2g/ujVeIHwCfQprsiYxyuMVeaEky5Ibp?=
 =?us-ascii?Q?fRQo75rEd+B5VpZVC8QRBK0bWd6HWmIuTxmSxSVaaZcuBpVc0ZKjROcgTzPv?=
 =?us-ascii?Q?0kXUfUQf6z1ktEe/ozfnGk5j5XtXAk1TQlaGv+PuPff7O5B7LSbDC3w4X+PM?=
 =?us-ascii?Q?Wx+KfqDZPI1lp/terFZddr0E4U8MUCftZ7U2MDW75dzIGifa4LTuK2Jvraqm?=
 =?us-ascii?Q?wISGSiO5Vqsinsuu2iqj+AbxGHn5Py7TcvJRZZNEJeykuxzU7NK4K1uSAZko?=
 =?us-ascii?Q?Jw0Z7672GyooLMT7xaK0UAECIrDWZhE7k3bLwAx4YBRJGhm28gAn08lPxCUb?=
 =?us-ascii?Q?0T0BNAyFEkoL5H78WSPvKFmQNI3KzUNDke8N0JCrhrNhy+ZOp21gflat4VNF?=
 =?us-ascii?Q?3raKwJmQNjJeE2Ox3/BYCfi2ijUthuUdVacMIYqn?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	mUPy7M4QLkvaDJVwd6u2QfPS4DogkyCX3UFfFoFHtuBDiLc3S3o1HM2iwb1U53x6o/UrKHe7AmrobIv9ESRYeUdFGlVYwF7sa/7xi4DeADc85bwYLE+CAIwrv4GA7vAuw3hZDqrZUo6Y3W78jNTsyyv7w0J9j/KdMRGhbRPIGOlVg00Rnf9CdL3faG1m+cID3qEzT55l6RjkaI/hC8dxmbr9nMo5yEekmAv5tdj2Qm4TK6axdQWKc8/BVlW1dK7cTiuXou5LhzW0oeLxi5hlCu3GonEpcgmgUGn40LKvQMVQAipMJJ9aQAnf7Qp+JwDhx/wGRRkNyLKDkm6OYjipN2vrqXhpoVpl8R6QQcgJu6Vo591m/awMboK/LFZRyXcSbILTJXE2f/h5zU4IpUi5pGClXH4VzPh3/Z2WIhvUQjtePW3sf9BSL+lx5sG630Vg5vwmMsOtjvpRU2dtTjIt+2WZ96x2LTFXLlg6MH4c+6E82IW/svwoVsgl0rGnFB62MrZqvoDHrEn4bGnQgUlCQoI/Dz7E7NFWFahYu0dIWBWhHeEsxlcDa38wvSWAOHY5e+YRYpGbku9g5qz4aYy1mmyeFeBb0zqay+zwBvHu14o=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b36f3c9d-d240-4fad-4113-08de2e991d85
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2025 16:13:49.4487
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QbfZyWnDjXP/l8XqPDfeQTG6qoD0D+O1GKWiXor7lKFRtqNyCo2+vOKtcQ/yZqXQ7NmK6TZJzLW3SuZ0v6rzvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5548
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-28_08,2025-11-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 spamscore=0
 bulkscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511280119
X-Proofpoint-ORIG-GUID: PECRKKyEjILue_yxp1gv5ihkFF202_db
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI4MDExOSBTYWx0ZWRfXy/BGIeGuotGw
 HD7eDTW4x+Ax7SEp3UOrqK8Ei9Qz9DX/mDLb9k0/GDd3/roBxt0yXrCcTt3b56vEEmDG0i9btjE
 9xUNqwf94mnz+H8kTuT/BNhkMX2WbBtWrwccp6myLeMGO6zs26hkCm7LQQlWTakQkyg/v1esib/
 xtIofHIs0t8u56be0RFNW9mM9HnZbnxNFKvTLS3c3WczZ8dJauSTaIaoOSOU63gf3HPUlPBEywc
 QjTW/bKyCnnqAEjnj86U6wOtgjMgs2JmGwr1veP84YgXUcdLzOTxWUjk7AeyZ6jJt19KC7ujhUq
 hm07P9rRK+ETAzHaHd2Z5T786PPppcWIel/K7g/6DcHoCYNv+P23Awbqm5EXUACHvZaeFTW6Ky1
 MS2yu7gyKhtA6o/h8vVa7k6UAtjFpw==
X-Authority-Analysis: v=2.4 cv=A9Rh/qWG c=1 sm=1 tr=0 ts=6929ca42 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=JfrnYn6hAAAA:8 a=2hvuF6In9jHalxXZamUA:9
 a=CjuIK1q_8ugA:10 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-GUID: PECRKKyEjILue_yxp1gv5ihkFF202_db
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 20722C0005
X-Stat-Signature: ijbp98t8emhg7w3646fpfjytkwe6qqan
X-Rspam-User: 
X-HE-Tag: 1764346467-573373
X-HE-Meta: U2FsdGVkX18Mq8vb1ThC590q/ysxV8AwqzGL4qHGn7sFcFrVseoO1ieYs5v7LlHHV3pD4+Cm4R4oP3uAOm+iHUBxiDx8MgWa1ugGD2hyfRjbC7ta6MA6V29dQFllM21csvD0kDUnzSNSNn3JTKcAMHsI3A0Z0LNdEiBm0maCFS9z+B19QO9HBNnIOOvHZ0KuzrQozVAPOJrcioxPafAcbZGfu6sIhCDwStaHrVKdgtpPuWZjxZuaev4bTwTMMOn0YgNfmBTSpeo3S8n63fH/nhidbJS9+b/N/mIlCpvT4DsGjM21tUX4cPuuUb/LoajqqZ2vigM5Ff/S06EBmzXNoBneSxKdl/IstTdiPwlb3dMKrCN2FZTnkC61vn/+RvV30uzFxPCDtIRTkun75q2t8J6dQj8k5Cq2Kex4frcoqgJVukBGfPr3vAIBG9y5OXxSpMaSvxRzvyXPI8/G+Ue/4oqRgWvgzSknx+rvcgV3tIvn/IVH1Ntr8/ucbzan8+Zsz/xYrRc/shRQGJ9xT9v2Sti3g6DkMJDAV0lX+502HQUKrtMpXh9FjAgy/0U8jQnsKKrFQX5SpDvQje7RH3mzg9oDtIgNUhBwlYgW3Aa9ZXAJj3NAs3XKlc+Wwl+Ej/nL/uVFLM/KJqA2t5rATRdhQ6Hsw0fsJbfhIOtwL3iwAcSzFTAEOEc0FkzgiHgA3fjNoxTfH7+ALOxhc4rzWNxADf0vuIrh5WPs2OkurjYx0JUC1Q5hOxFnwh4tVPb0aWKPVkN0BgLi0EzBJdrW3X44oLg8ZF5z9jaJ28ueILnF1QKvQI+qCBPybSZHDXYbWkuiu7WCueIKzIiTUxIuJxFBiV+FTKa2P0Ws6xi0LA/PNuPpxvhw/G+xVPZ9PxEeST27I6RiCm/cVkzCOrdp5e27FB9ewKbdYn0E8FuS3z2ftKNkbiT5IMWJuL54YcSx3m/tGVDcFGfJsq2tupXCQY9
 aQykpWgf
 jJVHM/wa9bVSqLJIVf3ejKP0PIWecNa4uZqwpy2mkztL2r/oVr4O31dWhxvBnJSHX4UwE5S/3TpqiKR3+h8sQx2rDlT3QGrlmrWT6ZzkjxvOO1PmtdFiSzneh3KSq+LO8bNz+ZLWLmphC74rVIeTbpFZuU8IQzgdEX2xyLHE1CL+8s9AX9WRhUcd7UCNvNyS60pQU7j+SAZtuuUKkK4esHw4AygnMxFkMiKijnAV1BFL2DCVPLLlu21nGPKED2ncqoM8rRkAEqdnDRD9BMmigmu2wXs+F9haGj1bFY55DRaU/a0cOkhHyGnbMbvuuAjbdUIqn+/Fgkek9v9NCK7Xlh0LqAzCVAJ8TwzGnisjmJoBb21VNsafWm9VI+dqsNVbCZDiRERCY+aAaCgUpmZQzkGEPQoIbgvQTSpKW/hBVhmClJcYeWU9fJkkg0f+pESFWP2WOM7SxQO0+98x2zLbgVhoGewcBMnL6e9aNpislE7IDYoAiq0OSbzDASb9W9AwIWZ7QaFTheQUtuWtSpURk456S/n9D91Vx7syi2bGN+caBX9jx2O4PcGF5r63uMGXroEowuTo8G3GdtHG7EF0vp5ueyFyc2l3wbLK+2j61uVzF7Z+MLIK70OFXkFgHea0QToZQMhsNjEknEqmwPavPOmNyNbBfmx1E2wtaDRZqm+NQNhYHxPQkFD5IgXTaYcPdL/ivoKuttq6p0ipANdD8ktGJaepRWlI4dkQ93G1zfHwoVqM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Matthew Wilcox <willy@infradead.org> [251128 10:16]:
> On Fri, Nov 28, 2025 at 10:53:12AM +0800, Zicheng Wang wrote:
> > Case study:
> > A widely observed issue on Android is that after application launch,

What do you mean by application launch?  What does this mean in the
kernel context?

> > the oldest anon generation often becomes empty, and file pages
> > are over-reclaimed.
> 
> You should fix the bug, not move the debug interface to procfs.  NACK.

Barry recently sent an RFC [1] to affect LRU in the exit path for
Android.  This was proven incorrect by Johannes, iirc, in another thread
I cannot find (destroys performance of calling the same command).

These ideas seem both related as it points to a suboptimal LRU in the
Android ecosystem, at least.  It seems to stem from Androids life
(cycle) choices :)

I strongly agree with Willy.  We don't want another userspace daemon
and/or interface, but this time to play with the LRU to avoid trying to
define and fix the problem.

Do you know if this affects others or why it is android specific?

[1].  https://lore.kernel.org/all/20250514070820.51793-1-21cnbao@gmail.com/

