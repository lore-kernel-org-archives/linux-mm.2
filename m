Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87250C87FD1
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 01:27:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E0D36B00A2; Tue,  5 Aug 2025 21:27:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 091776B00A3; Tue,  5 Aug 2025 21:27:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4D8C6B00A4; Tue,  5 Aug 2025 21:27:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D26146B00A2
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 21:27:02 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5F64F810F8
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 01:27:02 +0000 (UTC)
X-FDA: 83744593884.09.830A854
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf26.hostedemail.com (Postfix) with ESMTP id 032FC140004
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 01:26:58 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=WdzO48RR;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=EHdqezTj;
	spf=pass (imf26.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754443619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xm5TbSzFizeuOU4Zivi1Ho5P1Lffl3hPwpj6gcgusxM=;
	b=SSN21rh15bYJSO+vfuodFiiUk8jrn6wfZWS6MJqqEMqV8BLVluxdT38o4JAsFXeXsTT/Mz
	fpbieQZ30lOV03l9iUtQIA2Qfdg8EQbJlqcA7ctkf3DOT0GN653N3KlBIJbHeUkz2dYMQD
	fmMr82MBSOnXdblc8NTWwL8SxO080dA=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754443619; a=rsa-sha256;
	cv=pass;
	b=zV4V6Hy7pag/zpt8oEu4jHavAEQZXpUY73w0m29yVR2YVVVWBCXI7wsgwHzk74rLEAWWv9
	0BIKL0/qr4/YN6H0sOHUBOImGWrQqbriWLXaWULkDGLf4lRsVfGP1g7Hhamd5Sf8omFT9S
	jsT/V82D+D3ymJtG1UFSu6qAEirIymA=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=WdzO48RR;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=EHdqezTj;
	spf=pass (imf26.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 575LNFJJ018156;
	Wed, 6 Aug 2025 01:26:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=xm5TbSzFizeuOU4Ziv
	i1Ho5P1Lffl3hPwpj6gcgusxM=; b=WdzO48RRvuI1Iq1lPfcMUNtP1BXysCy7B6
	HzQgOjFYfwug7y0Y2TkpEKLPI2wXTNwOv7pTA1wfLHBiRyjwcSpX+cSx0f23bRha
	4G5KQqXbDG5BbXQdpixkSJk09UzYx82VuKqNwhXwPpZWkVVbKBl92EbXegfp+V6I
	A0WmTkOx+IYZW8vXMq4NZlnlS+Q03kPdE2J+K5JmU7pgfZu2p5vmnp8ock4C1/Cp
	O3ZEmHkcp6vkTuMYqCr4A9vCQnow5PwFQz4AT99BZSlJU47kzmutH6PowjMmGYm6
	UpDIbrgzt3OnpzK44WC7JIPn9NfdXwUk8MNSJYQf4Wm4mUkN9qNA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48bpve0jxj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 06 Aug 2025 01:26:55 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 575MqtKJ009830;
	Wed, 6 Aug 2025 01:26:54 GMT
Received: from cy4pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11010059.outbound.protection.outlook.com [40.93.198.59])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48bpwkc8rx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 06 Aug 2025 01:26:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tX4maJYdmMlbfRQxYkbUWPBD37dqZOj1OByaiU7CaDy//k/tJGbAtavAnm+SE5U9fqnc4v5iNnJK25sozwMigc5x658BJNkRYhM+O+NZl6O6nXiBTV4MwgddOHurwsgDQRRxRXURxKnwivStWjGahXO4BmOCi/PtpDnojARpZAr07UITsJRmFLvDzhBYMD9IYGB3ZNuo/78OBj0XRuGn9Baakjg88r5DiETZbiedIps4pKHK+DsBfHIvX3c+uvSvnirU8zxvB6qFYl37bUqnWnI7L/Szwyn3Bh1gL3ehVK2YYbBoLOhqCQCJKQvZvkJ7pq17LaPDXsPPeyJlC4FUkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xm5TbSzFizeuOU4Zivi1Ho5P1Lffl3hPwpj6gcgusxM=;
 b=LvOA84r1m7g0L6nhI0DLGI1uLUuFcEYY0BUV4eusmsaMzPPFQtSS1vIm9kzH4TvZgOT55gDuHrov84yjW+z+1MwQwx+vPW+MJ3zc8ebgKX0dNKdJOsXsTpU2saD3om+6bHoObEyMufAIj2iS489EDKagkGG3r8lQM+ydtVFdypq4D6xwyp0I9KxRb3L9VUvshmpKz04AQbeBK45fLUOtQeEY/4ChKcLHg4crrbfYJF7KJSNlRBK2M5m7yTcRW9TCKnnvpN2fw7hKXTr2Qxvl5xcn0M+oERxyPZyETiMJ7+4FCXLT2EK+w/HFLmZf8h+wyItTovQqXgGTh/32JSuNGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xm5TbSzFizeuOU4Zivi1Ho5P1Lffl3hPwpj6gcgusxM=;
 b=EHdqezTjnPkXTXNMTomlGHkmNWMdjOs6zIs344fhGF1BgwvNc+f7DgxY2WYRhq6xG5d+7vt4tWBCRx1EX80Euk7uKhBFTkh90pE8zVVExAorFI03aKPsLST/wBh1LiJ8+eX36Px8QoHMvC+mdCuEYcDb+6o/jbLFVePYaLpjX3E=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by IA1PR10MB7388.namprd10.prod.outlook.com (2603:10b6:208:42c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.20; Wed, 6 Aug
 2025 01:26:51 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.8989.018; Wed, 6 Aug 2025
 01:26:51 +0000
Date: Tue, 5 Aug 2025 21:26:47 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>, maple-tree@lists.infradead.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] testing/radix-tree/maple: Hack around kfree_rcu not
 existing
Message-ID: <32irwh2uqdg56jrx7mkbcfltu5t4im6l4j44mtq7ylnebtfpt4@te3sbbfuws5q>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Pedro Falcato <pfalcato@suse.de>, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, maple-tree@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
References: <20250718172138.103116-1-pfalcato@suse.de>
 <20250718172138.103116-2-pfalcato@suse.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250718172138.103116-2-pfalcato@suse.de>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YQBPR0101CA0294.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:6d::18) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|IA1PR10MB7388:EE_
X-MS-Office365-Filtering-Correlation-Id: 5038cc55-7787-4c67-98ed-08ddd48851c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0XtryPQU8QU98vCKW34ekJNgOHe1izvvbErUJlaeAbVg22/poKx/2F43gVWv?=
 =?us-ascii?Q?80xcqWpL8cnocEz4KwTyAb8LhVe2lT19RFkvMdMnEBN2tlm2vENc7hl8Nxg4?=
 =?us-ascii?Q?MTK3Nm2H4wDHV4kdGADV637zP7xeOtt7+MyOZ0rjN8/N62CdM81Rk9LQ9Hln?=
 =?us-ascii?Q?fQYXnj+SYoWEuIdK9yHh0AjlmltqPRj8BYKb5Nr1eajubLsm3loeqAkQVXIM?=
 =?us-ascii?Q?4xmatT3IZDjMWKPgHGjqZw7FbDn2xYwmwzxnOvFXgEc/4ltH08Dv49Hlrfrc?=
 =?us-ascii?Q?kgy/aOsiJaLuOdEIsKZZuLnXEPnsbJQqGs9+6jTMdnaKNfgmBHktTZSwpg8n?=
 =?us-ascii?Q?c4pQKnfLu952xZrm2nbClxVj84G+ovdAUhvTpKp9Qs6SQvTluMOxT6i2ISpB?=
 =?us-ascii?Q?+w7OWkoIpJ65cAUn0s4WK2HUx5iJjOCon8uqsq49aKX9msLQBnMX374zu8Yy?=
 =?us-ascii?Q?eRsKQ6Kib3u43+4C8xqvBuuBvGebmq6NLY5cBa/GFIQ3djz4VFoVDWt1QNx9?=
 =?us-ascii?Q?r81iqOmu/ajCEkU+fsn8ASJDCQ358+xy3i/FuCPlzP9H0jVtrfzn4bKaUiDn?=
 =?us-ascii?Q?hN1ohtjBGmQIe4TKm9m2Oxj8FLKOBuxMz0YxUkYr8K0LFDk9dWXQfhZFKPFx?=
 =?us-ascii?Q?5l5PHrUZe9BocwF4ZFBiGd02l+qhhuQwxwIC7FmktspMwrbRrA/eIpagJJ13?=
 =?us-ascii?Q?L5NoZ+uQiTqNDdAIw7EuePKkrbRA0hKTY6JHgrIxYWn9abgQo2GTxg+SzRdh?=
 =?us-ascii?Q?OQc9EzmeqJp8pfQCnpnvsQzJvRHGPFWYPSGgojfP7BI3ly8kKaeeSFNoYwfn?=
 =?us-ascii?Q?evEKiNEaoQ4HyF4AyNUQQ5JWOA79X1TYodAZvzp6HJxfW94Uy/sZpTa3qv7b?=
 =?us-ascii?Q?tqbk78L8k3kgnBL51GgbANBrSoUbZv2EtC6uhRbsNWfo3dv917BvSsiIgXe5?=
 =?us-ascii?Q?Rswxw4sVA1jktOETJGGrb+XUoCa7lwpso8w269loSiWhCBrpT4xj1mqCfI74?=
 =?us-ascii?Q?uFNqSN51cyhEz8Ax3ioxbORChimzh8W+mV09YurE9SO03z7KG99xBERz9ZRb?=
 =?us-ascii?Q?tiTDa62i8jMv/7r8mwC9juK3eWb/jrm//pFrZ9QXzg+urY2dDFOSVfFoeXT8?=
 =?us-ascii?Q?puRjOH3erJWtN8K61+9AHUmvWkf3TRWQBolz0DrlyZxf8Zs4Vzmaglj7K2b9?=
 =?us-ascii?Q?D6ICTiPqBKmz4i9i9WQvj1YUoFZnANOBvxhejYNsBr+5cNC3k0kSVbzg7mbo?=
 =?us-ascii?Q?coMzXOTz3oOGlNe7Wm+SJMVFhsADryqfPuhd2F6DE6NsHBbWPKD4/HVySVsz?=
 =?us-ascii?Q?Jmx/OCHCnvCmiQdjXrHwOZAobD9b5j27SxiJcWCBT498GbdK3N7LjT7bHgtf?=
 =?us-ascii?Q?++a04/JrlFazuC/AKFv7IqHrR7sBNTbaXkhoPMUIHWQxkDcbozSVSSm1Pkdw?=
 =?us-ascii?Q?8l2Dwextdy8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KMB+brJrwwHYXAFbmAMxjCytYUekgD6oHACwYZS/tBY1zoIYY6kkczqh4iHj?=
 =?us-ascii?Q?YuzsLwfXSMK8CD1zgFlKFAvvKZpSzlH3nYsi4ULkVw6wcRquanR7rrf4ECy3?=
 =?us-ascii?Q?io5FxVHv0qMwtJCeeyq6BM9F4FkxxVUUr9j/R94hcNVciAUBTp+IPFWOvpx2?=
 =?us-ascii?Q?m8rKCTodDnRRKsWxjU+Gr2zwH4uRj4+6FixzwHiBA4WX/8ZBC4zEl1U7aIn7?=
 =?us-ascii?Q?X24okHzTiyGeQF6oinJ0ta+OlFzYaZl5LTQAhv7ddt00yHigI0e1QhlmDsuC?=
 =?us-ascii?Q?rxyredc51hv7kuwFmj7nFNt5yMWYrTr19clFAdUtMBbH1yMcrMH+j8B7/E1k?=
 =?us-ascii?Q?ioVwBWQPq527r7SDJdaXzgF5TWwRX44vV54Mxo1N4S+Bc+VJ07/o6tRUDsSr?=
 =?us-ascii?Q?ORhsD3s8pu+BY55oxzHmaiRytMFoHC1iv24Bs4bYmoRZAZJKh0xrfr9cSLRh?=
 =?us-ascii?Q?/cJeWxPb284VKNNHsCdvnn0gKHhS/kwXaQnWbJgeULt3OuexJSpgqtgLRv8E?=
 =?us-ascii?Q?XUwsHqs994l53bIB9QEVlk5M6eW4XNbZpQTMGSNLGRdzgyB0GsSUbTU622/O?=
 =?us-ascii?Q?p+hw0G2lXH5yhyLOlRuebEjcivoeQBWF1shbYbV7I5rvn3ck65ziwaExuShe?=
 =?us-ascii?Q?0gGkT/AwYmNU54Z52EqRmXmeY9Jdniw9WMEwJj7zW5/sVqlYvFVSOOozmG/z?=
 =?us-ascii?Q?kwbRVa2yEeKR1XK+nS/FW/lT1Li+e+nG39VYJdxwfGQsBl6bgn9IF+ooPGFS?=
 =?us-ascii?Q?BzyA853DlpWO0FmT5Xc082H1Z0RzxPrZOdLiZhd9AOk3R1amcUkRN2Bc0QOF?=
 =?us-ascii?Q?PAZ3TfKVf7i8/So+/J0uEv86uBEuQJC0XqfQGvFNUVH0EaiPrvtFaz6s65RL?=
 =?us-ascii?Q?ExyG4qHWuLn3/d4ImSXFqNTBJIWbS9BSybrZeWU4EfzOws3Jwe17MJRkzapf?=
 =?us-ascii?Q?GVzpsePJPbX5uoPirYKKnqgt9k9741r6C5pb80md5X5tqdiuhTEvarc3MWVg?=
 =?us-ascii?Q?I06Wexy5g7w2joDP84cc/9KChJjLQUXkWcsp4JvAAPA4e5li6buMkYvNaZpI?=
 =?us-ascii?Q?/YI6qhrZZXtPLc4cNOcgyZf0J2/fKd0CArag31FgcWyM5oqyHabfS5W0fFZA?=
 =?us-ascii?Q?5fLOnNTfUgGAAPN1lYhtyPax9nYGrrm0AZ18xx2YDvbfUNrXk1qzKrJXaxyb?=
 =?us-ascii?Q?yLBhGG/jn33sGnSuPej0wirSpJpvVs3DzrLs8dFt3uReH413AnQ+IahvB0uP?=
 =?us-ascii?Q?HrZ3Z5wxagIYZgDYNHcoyoRQWggZ5C6U28hwiuiIecaCHkT88RjZ8ITYL0ct?=
 =?us-ascii?Q?ApyB4cduIBjF+EFssXE/qPekWkXS/t2TY+bWwceqYD7dxOHYgAKaNLojCRfZ?=
 =?us-ascii?Q?dmAtquVqU3tZp+KCCktKp8mLaYntrtbcQ8bc+t0Y0x+YWkHPHDrkXV7Wr/p9?=
 =?us-ascii?Q?VfN7Ey144QXoCKZ7YfGHPwMmMjcd02yuEn8XCcx7EuQWYD75bhBLPxQDvNXS?=
 =?us-ascii?Q?91x1BtwZtc7vB4iusw7km0CIY6tnPhlutHgFahfB3nNL2uN/xkASw7cWN32B?=
 =?us-ascii?Q?ca4wJ3KzNgDnrhMqlSaTPIzB1OUcpAnORrkkPppU?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	fyDJwEUrPQ8UgRpU6q2Be+7OGqprF70OA0ZNE+OfqIKDw0t8i1R9dctMzb6WV/ABy82c45eMNb1m6nCC3Ee5UMVikFP+TkXzyHfygsJP7IoGbX7mC5AnKOjY/Vc/3lxPjhYIdkIPMVAi3T1HCgIk7pvgNC2ItALwDFe3Scyd14wa+Yb1+OC7TKkCgsjRpyCzvPqR+fObshReSAtwh6CaV8RGRSR2aqF5hoEdR/0Bx7nm/iu2+jRGv5Vi2fH7GlqY6Rcts2nvmbgD9EY/+mNzLrSjCLfz2j017F3Jlcv9ErUjADKACEEmDph6+Ps4WxyqEYV0+w9mv5IIX46RCFgI9lvwLFKlgUYKebK6qH9bEr5koVuOIokqkhglsS9pkvulxQm+AAXOQmWioMG/PZAq7+SIXF3Kryx90vFlnKS5Scwq1XB/3w+Jq6ys9TPlGXihAsL5+w++pEow2qSp0+GyZFjbljVf10IyMR7NV3oR6jfAoxzySYrzQFlfOdInOotrXiGCHNpNcV2hMvMXD3uObSYV1gammqGLnPybgwMMN883nlK8JRQ3lAD5/VtizUkHsYKCVVFaJYM5JmOev39bW2pdUrR3S3aC40Ck3s6oSbE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5038cc55-7787-4c67-98ed-08ddd48851c9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2025 01:26:51.0327
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ne3sW/T2JY5qegI5Qzyv+PirKPanncFx24VfqhnqUyn6OPKOZHMi0rahqxez8fDtIdnw0zEAvpfU8MmEJ9kXIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7388
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-05_05,2025-08-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 mlxscore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2507300000
 definitions=main-2508060008
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA2MDAwOCBTYWx0ZWRfX5T6EnVQdiuT6
 /4N7UJSVfhjKXjCQ1UDLNfcdemKHeIWeKnj6rScoMSTCH8sGxKw/Utxo24VjBDb9bRG//ARb/XB
 4YjfOjFSjyonkpNE5rzmW189sPXsVSzlT3366frhroPPhDeXvlJk+RETRfO69QH6WgOdSSrYFhh
 U5F6LiFZLx/IC/IU9doHwaYpnvOcnwzMifKp1HJT0XURaO85XDOKSA00AhN7OuFqii98moRARkb
 0Ol63WKZ/gXmrzBy7EFpMhJx3xTGV564tK8jeSkforX0JcbW/kaGa7XRlsvyClwSIMjsuLooGki
 TVBERM0bCdirz0xF/3B1rWGEDGtsxmpqddwgz/clL9cFAbswllube8NkV7klJ8wHQX1Bt116yo2
 3xZQRy4DHVbg7nILVRZmiIHYbfUJ0AvHmPNCW3EoCNzMn7GTN04giG4cjpqZcw4bvN5XK+7F
X-Authority-Analysis: v=2.4 cv=ApPu3P9P c=1 sm=1 tr=0 ts=6892af60 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=wcJrYnJmcS420O6A8-sA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: CxoY_PjxxGkb62tt_95CPKsor5Y87hkV
X-Proofpoint-GUID: CxoY_PjxxGkb62tt_95CPKsor5Y87hkV
X-Rspamd-Queue-Id: 032FC140004
X-Stat-Signature: ui9zu8io1ek3m4uofounu15hitk6fti8
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754443618-876789
X-HE-Meta: U2FsdGVkX18jpk5CGeF28PSs9hdIcamI7sDc/3eslw4BQ4IXwoeWhvRmJFoRJdx2yDZwXNICNSUvqaBsWYNNe2hf32wFVA+OvzRNkQZIuAOQ5CSCIuHk9TTwfdKuQ/V0PkevQNY8iCw6HvhKU0zYM7VcKj0VK3NFrKSynWEihrwPEFPSFKkg3Sdpb9jbzqV/3hJzG0lVFfF+ae5c0lxyulIT4Mgjh0XLXu2/1NZ00tpW1G5cmAT7NYZ57mdneIXa5Du4FHgHaruIfKmKvh5XSGZeAugw+Qvqnek/tS0GyjYWGo/N1acUjcKW3xNHt3ezfJEfRf1Dk+Zv9LD2QqhGBbatn54LN6EeyARRczhPjyrkoWzTKigJxiW/rxZWteTermd2Y4L2GU7yD9NhPh+m64RGdgRlaHvB1RlhMMtdoRzqn7SWDt0NJVUaSURszJue2HXmiGpoOZyQelTxhKyLfJzLcOATR7BDlQxGu8WdKiO3SQqGqq28i7oIoygnhzv7ugwG5wlCVFl0lWEe8qtPbIwKNrKz8MddW1P1CX579WprYbaQVjnCEAep2g+LTsJm3gNUyCWMGkfpvAaOSXmYE+ro6sYUOR/njPL5ESyBeBpgd3pMaS4cDGzK6H4y7LohtANt1HtsratfUzH5fALIzknXsCI2cNMaitI12by33VD7kZINxGDsyekRnlV8SW7In85J+cn3QE+KqG7v1Fmt+DbonxjbIeFT0fNZMFiiIIUn8O/ooIWVcHBBLmiCq/ck/GYCFpPfdq8IvsvPEXdQPfJhYV353riYE6UpPdj+qdLXIbOQQyL5pmB30fNTq2VKYYwFjNEjJYgxw8EYQbA1MnVONJQqBO84s74NCaBKLCF3C/pgf/O1RR3e3Lp+TTgLZfAkYiKkiahnxSx6z0VyNsCk2VauDZYDKT78CDQmisNH1+H7aKZgLOc+PFj4vcUAjnJO1cPB78R6HCDnM64
 Iwuz9FeU
 Ltz+zMp4tYoZPDWFtdC7E8W9qMCD26NYz117f528mDFJbnVqyz/4kzhDdlGSpx5ullRebzsZeMDG5H/HpZ7fnkthrjzLmtBrxCI70WsYQZ8dZXB7JYyouywRQJ2NI962zQTk74hoe3MkwgeMwpzEpZ5ExgPNHi45k7RlE4kC6Epif25PVVOodGnjYwveHV+J9bSrP5tjv1PwZwcueP8NSEaH1hTpYR6uJZNOf8D8A3tYRCBbGYho5kgvhJR/i1JoVEAI5N/mKGf1MfWVVDxFlmEdmfFjfpwNGxooAtpFm3VzS34GAggpuajq61zcti8qgpAJa6GbERFHucXRrcylU0vIfBS8cWxYQYNTJ+nd5xFd9cNH0W9q5FbTTGFz8VmYpPlW6rkyY4U2puj1PyV3TcK2tYL18SSVE1MTRF9rrgtTZmy1Q4SFq93LwR0+qWY5E8pKYH+VDYVHCsTWbEX2mxlHM1vD6vP76U9NMU0QtrnN2oG15R0G+H3Quv2VBGFjq7wtFdqNhi9GUkPNfDJYYgphHMOX/2Fve8mlT7g+RlroNYqoasf3VBbc90SIiDFb19/EdEZn4ljHlEvQMCXeSH1n380NSmg3DL8zsaCFvPkPsGH55rPYhVdKlrgKSCtLCwMXOD1/NPN1YkSWxmBX5JXzrohO1Ey2crssoS/DP/9T3bxR/B7aIp/0Bs54AvCkzBxrUP+008NBWvqodZdywFMOxqiGnli6GRkUv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Pedro Falcato <pfalcato@suse.de> [250718 13:21]:
> liburcu doesn't have kfree_rcu (or anything similar). Despite that, we
> can hack around it in a trivial fashion, by adding a wrapper.
> 
> This wrapper only works for maple_nodes, and not anything else (due to
> us not being able to know rcu_head offsets in any way), and thus we take
> advantage of the type checking to avoid future silent breakage.
> 
> Signed-off-by: Pedro Falcato <pfalcato@suse.de>

Thanks, but shouldn't this be patch 1 so that the testing continues to
work?

> ---
>  tools/testing/radix-tree/maple.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/tools/testing/radix-tree/maple.c b/tools/testing/radix-tree/maple.c
> index 172700fb7784..bfdc93c36cf9 100644
> --- a/tools/testing/radix-tree/maple.c
> +++ b/tools/testing/radix-tree/maple.c
> @@ -23,6 +23,23 @@
>  #define MODULE_LICENSE(x)
>  #define dump_stack()	assert(0)
>  
> +
> +#include <linux/maple_tree.h>
> +
> +static void free_node(struct rcu_head *head)
> +{
> +	struct maple_node *node = container_of(head, struct maple_node, rcu);
> +
> +	free(node);
> +}
> +
> +static void kfree_rcu_node(struct maple_node *node)
> +{
> +	call_rcu(&node->rcu, free_node);
> +}
> +
> +#define kfree_rcu(ptr, memb) kfree_rcu_node(ptr)
> +
>  #include "../../../lib/maple_tree.c"
>  #include "../../../lib/test_maple_tree.c"
>  
> -- 
> 2.50.1
> 

