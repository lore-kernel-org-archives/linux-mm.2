Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD787CAC58D
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 09:08:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35DEA8E000A; Thu, 11 Sep 2025 05:08:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 335928E0001; Thu, 11 Sep 2025 05:08:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D5E38E000A; Thu, 11 Sep 2025 05:08:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 038658E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 05:08:46 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9B52EC0402
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 09:08:45 +0000 (UTC)
X-FDA: 83876394210.08.D46A4A4
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4406912000B
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 09:08:42 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=raWR67+p;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=hAhhtVG2;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757581722;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T9LUpoOIpqR6Egfp8o/mv1uZdiDSzJWJ6mkWJeFuc1Q=;
	b=Hfh0MSeWI+lhpP73u084OKVyTH3YJoICM76C975op3ztjb2aTlyt/Ms9YACrUjADtbiMIH
	yKQzWu0us17Wi3fAag1H7zkEFYBlTUeaEeGbZbDEdorKq8ewu+PxVM7oFsXG3QzyIASKJO
	DOTEdMR9PAo8W5bVIomSgPVXI/N9Guk=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757581722; a=rsa-sha256;
	cv=pass;
	b=ntcQdlQtwhOQizNngSDT9uIp85z06Y17EiJmMSm1F60TfLPi+qUXoYroYgT4/M09Iuy/cR
	/V0BsGAwc3WMm8Eu7/k6f8Kjszx61EbWsZxog9p+DSpnJqwd2v55QU9sSC12+3KzYqThuw
	1hu6ZCFrMmkSlCcdnm9VZKlC2vo7B88=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=raWR67+p;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=hAhhtVG2;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58B8glxh016085;
	Thu, 11 Sep 2025 09:08:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=T9LUpoOIpqR6Egfp8o
	/mv1uZdiDSzJWJ6mkWJeFuc1Q=; b=raWR67+pR+ct/6+x4T7gq4RgLaKUZpriTE
	tbKAVZzYBQdlaxWedk1MqT38UJ2yTUBf+zZ2XXLoxPwX1OysUQTdz6MYZ7IywRO8
	dXmgRGjLcUi1OM6NOCX2pok40sv4/QVA+vNnppI61cjIoy+JanTwlgASQfuTCAn0
	dikhG/1UMPFIlSAz9aTKFnvg4IAuDf9EC+fF4gZ7FBgt7HmMtssziRXQkrGnFEaz
	7fkgr6rcm0SOBU7/1mXwGYxZcMfvwfUakgO6ZEOuMkHkLmKRsxudXX8cQnJZKnLN
	deermY9JW0F6tpguF+mTA76pdG/PLIzTxOufjzjhoW+R70szVU9Q==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4922jgwvf7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Sep 2025 09:08:27 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58B8iN83013730;
	Thu, 11 Sep 2025 09:08:26 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013015.outbound.protection.outlook.com [40.93.196.15])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 490bdcckav-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Sep 2025 09:08:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d8XKicuDNekLhjvYyJesAnG0CrKYMYsudHGaeNsISP457iFoibNCqczxkMmXogsii/vdoOeZMM7v8o4PId6/Y+hj6ZkZ8bplhMpckDprLkXZ6g+2KVm6JZwDX73t8VwgecsqZyOzsn8kZKK960RLAhiFo+wqY24tDlARXtuJSoyhul2sDGjCuUdAJgoihEzn26kmFBc5DbwgejKquE74QR6GCmvtWbTQtpUHpSV7pbXz5EDrtU6gQZzfn6aOMRYIRjkx5KSSWDMUIcBiGqMR02ONwmiNa9s22KTa7etn1aBBh3mDbvAW5Gg0gCWDWhlvzsLzlgNwE+1xf3Tn+xnPdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T9LUpoOIpqR6Egfp8o/mv1uZdiDSzJWJ6mkWJeFuc1Q=;
 b=aC1fN23n6wP4iWPrCMUICE+ug+ecSie8JYAPLcQqVEx7qJlzNodx9fnaqif9Qjn1byJRoVoQ4MVteuJ/wdPbIHp8JcDjMVd6ZCtWXQUr8L79RS1x4b/8C0OpXUofwBTTH0VZv7vfHClyqrtNZW+lV2BsAh9IqX20HEQmZ9LGWm+pLVvBGgB6uVGobTNLqXDWLQhw5w8XtlsQLMJ60D2tmQ2qQjEZMVy/kyngcsFrcVIxr+5nzQ3fOj3dEBUs90QZ9gPvMIfewE50NYR8WCW4YBFG6DvfFO2PLvXsDeLsTafrLi/3Bi4s4+4ZhMxDw8EmNpAJi8bJv+IMSzaisjAZcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T9LUpoOIpqR6Egfp8o/mv1uZdiDSzJWJ6mkWJeFuc1Q=;
 b=hAhhtVG2quw9jGgSsXsoyVFwUOjZIhaHlchZnqMkpj2EygHoWfomjcHtYGWTrlfw1o1HcEYqOXLsPwFD/F8c9iz9B45dZdMtv7ilCf29oy5c5qq/FG0v+dGM5Rq1F0hA4v3Yiu8rKJ5OlJmNm+vRD7mMoqExOzLMPQ90Hjssz5s=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SJ0PR10MB6430.namprd10.prod.outlook.com (2603:10b6:a03:486::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Thu, 11 Sep
 2025 09:08:11 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9094.021; Thu, 11 Sep 2025
 09:08:11 +0000
Date: Thu, 11 Sep 2025 10:08:08 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, maple-tree@lists.infradead.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        David Hildenbrand <david@redhat.com>, Vlastimil Babka <vbabka@suse.cz>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        Charan Teja Kalla <quic_charante@quicinc.com>,
        shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com,
        bhe@redhat.com, baohua@kernel.org, chrisl@kernel.org,
        Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v1 4/9] mm/memory: Add tree limit to free_pgtables()
Message-ID: <e44e1da5-7ee4-478a-bcc5-7726f3b52d9f@lucifer.local>
References: <20250909190945.1030905-1-Liam.Howlett@oracle.com>
 <20250909190945.1030905-5-Liam.Howlett@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250909190945.1030905-5-Liam.Howlett@oracle.com>
X-ClientProxiedBy: MM0P280CA0088.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:8::15) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SJ0PR10MB6430:EE_
X-MS-Office365-Filtering-Correlation-Id: 0cae139d-5025-41f4-9fa9-08ddf112bb36
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?a+g7kUaR+mIq54+7HmJm59uzoGO/20/xAjvOm9yJys/I0glMBLzSogssKMeZ?=
 =?us-ascii?Q?G2LYin4a24Ay2fVangCWsTAONgiGx/Ubb6LXxIhzjcqIpHPjFCChOopDYL3I?=
 =?us-ascii?Q?mnF+7Qgjy3JXo2QBN2cHzKG7FaCqW4eFWzMV3pPD602T2mRVShYupmPdGNBk?=
 =?us-ascii?Q?TvEaQT55gWAdOpieFme6IXepkaRCoc1Uw5MlWprY9dv8k0V2DmONYpOq+1rx?=
 =?us-ascii?Q?xWHZ7BuYBKzlQ1LdLfGuZPqmF1sQTvtTMpQ40Q+AUGit4rqG6aDELsHGRrkx?=
 =?us-ascii?Q?V6t/TS3F1Nwksiwt9tx1e/dh0gRHGjoOAcoK3jfN1l7ZAW2/uOIWwb8qYKDX?=
 =?us-ascii?Q?1gyVMaURQQw/0pQkdrbQSNkOmSyKc3CWThH4TNJXKtxKGVvb4SpEcMcpg2oc?=
 =?us-ascii?Q?FRRYA3idmL6SNK5cU+mHqX8RLA0uKpiu1Ov/UZw6cr0botG9Yce1do7jS3k3?=
 =?us-ascii?Q?6Lhgi3t3TO63Uoqxf/jtRR6ChxlDLYrRUsMD/d3ZcEX0cA8l73U0ZifKSPEU?=
 =?us-ascii?Q?RXgC3pR6CWr6kIBhEoWvmN/XFgPuPkr+4s8jeWhzUpKdyZirNnc7dg51YT71?=
 =?us-ascii?Q?zrTGp3wc0w2MvyUAuS01s23pUlc6ILWOIN4xkTeHpUC1GGopkEQZqjuvjZz7?=
 =?us-ascii?Q?zfZXHP9QfLRCLr2PvYXzfFM/GMY61hnGFx/Mnc+LLpZh0yegp0C55crGDx2w?=
 =?us-ascii?Q?FBumGKaG6ky0WMgb7/GzpQa4TUUwOPQZq0SIKTykW88dbyMXnbXXDjMmIqG9?=
 =?us-ascii?Q?kpF/+peL3dWYzXiYvUQ2Qzb81FhjCx5zo0t+8JEsnLASKEXbvXQGC4oH7lgs?=
 =?us-ascii?Q?9vonMQcl9fZE2vZ6lZ2qCJ/ZsBczAHJj4zZ6ACodC2jmFj3JQPtdHtlwxZ7y?=
 =?us-ascii?Q?TP4QVUfPhBk5NKcMUxhVD+dfa6hLYmCBClnvCNJf/IyKDoOkNthbB1SwEjnI?=
 =?us-ascii?Q?eGiD0bGJe2NYV5WC4U9DNZV+IEffc4fIv/tQiKTS/gdrz+QR+rVu4qANlhGx?=
 =?us-ascii?Q?8+jwQRVZMkBLPj3m41WGcjCxha0B7+bvZTNrKlxiBXSxJ0fWFOfoGq7pHSj8?=
 =?us-ascii?Q?kBCH3PQ0xJU2nvWsVeHsMZk09RKfaeJru9QfOkcxBjIROf9TOZ8f7dkzRwqX?=
 =?us-ascii?Q?+9DaJtOWNhEzCk2kIXwRcD9PHCCu677EaYP9G4hqJqBUqwEaz2ZOM8WNRr5e?=
 =?us-ascii?Q?M4hyr2CWy5QbhlqtxEZAqe62AaXD/ukTqJeeNhwuWoezRudyJlgqehM4lHc/?=
 =?us-ascii?Q?xrhW37j8MTGuZwedXoPp2B/K6ZH74YuCFgALqVDyrjr2byJS6qwwuFQr6tSd?=
 =?us-ascii?Q?f/Wc2qcryqGV8iFHUogXOdMU2WYqZ4MtoNgZFcshVX4v9gjY/Om1j6X89U0U?=
 =?us-ascii?Q?NH4xSuMBQj7+0fxaAZT5HJL2FYIGCH0z4k05tHJ17TfJetPlDiZ7IV9t3VeE?=
 =?us-ascii?Q?q4bkpJcaAtQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?39cPIn+XNSug/8o9prrebOabI2CnlzldJ2m+83h4aR0ndFH5Uvs3inu3l4tF?=
 =?us-ascii?Q?fRmgnLytUpw/3zc8ZJSJmkxeWp6xkPRiZ4fPOnEWPsXFEFEhH8cf5jeUsbob?=
 =?us-ascii?Q?5kKEJUMNARGNbv56/yH9v7XPQukdtampAm/ZYRA0cBwEfd/bNko0vCccb6yD?=
 =?us-ascii?Q?iIfVB3UtiL7iJc7iyaT9dV5xW6a1QG09K9pjcutFokxWp38n3wSwk92Tokwp?=
 =?us-ascii?Q?FsHYhYQy2GnKgQGSpC50Cl/Hdl2Wb6+ml+o2uIXgv2LHg0ZVhRCNQJNdcHHY?=
 =?us-ascii?Q?fjsHeimAHW40YOdplOIAm6tSgQnpu0J8zam6hCJ+o9m02+B29hFsF52Qt51L?=
 =?us-ascii?Q?5a/XYpcBbKADKTV7se/4RreEVMdxFV6xlxC7GJTFhEyT0kKSyzaFBCN6YuFp?=
 =?us-ascii?Q?3YdmDtIcraWjYcBHCyU/Y+mIzZDqLwIAvAykrcEPwKFUuGjXFNCTREDpIVNF?=
 =?us-ascii?Q?aS7eEl4Z2St6V2CXlujxp4JZbU7Z1bmt8zUP+rVTllZAo/kRC/e56NLAIfUF?=
 =?us-ascii?Q?qoQs/jrtWhkjm1KPGh7IFcLU+mH44/fcKrpK7iyx4jd/XMVzMhTG7jAaBpYG?=
 =?us-ascii?Q?I8V9RrPhZ6kPbQpg2SfWIoRKJUssahrsizIkOxDmmLDTAd4jrHAhdPmV4c9U?=
 =?us-ascii?Q?hRt4EyHW3jHhIOqyu4cXUNurB3IqPLdkOPBdUzbv7ahu7gIhwMaKVX1qnUi6?=
 =?us-ascii?Q?rRnZxrW/vAsnuJL5GYPVf47E6AYrEpdLnm4FyQIneJQ50FXehvlzB/An+7rk?=
 =?us-ascii?Q?JaqAC8kV5OQzo2GomU0hSCJRMA3NtahPeXwKvgIjoIQ7frOGCZjQbtbR/iB7?=
 =?us-ascii?Q?pGyRrGlWpsZl+oyZEryJXe6gVwaFGUbASw4Dizs1a2Aaa2bpzrmd1WlJPsCu?=
 =?us-ascii?Q?xyCA2EbGxRGYJZYQC0KU/OM1hj/gYJS7b7+zCws8cUyxXtffBTlLT7jt1ejJ?=
 =?us-ascii?Q?dHqnnQAJrofyWJ3xK3iCrgpMUCGdxO0pQmfArqVGkw32IcDy81RsXA25ccwc?=
 =?us-ascii?Q?5tLbJ9YEvNIkbvO8VIm95O5qWOJoWeagMch4vWaxi6xX0KDG/sYaC+Y6VtKs?=
 =?us-ascii?Q?l0wRQNAWE0H6HN3Cz+ONe87GjDJGDtDmUUXheDqn54UZZ/wamNu2Yw+IT9f3?=
 =?us-ascii?Q?wcUEEF6ympKIqnOj3ge/S/EqM8dVbT3uuRT/OTQYLGpzVqrYEVFkNHlG2OwN?=
 =?us-ascii?Q?gudcNU+qC+wnhm9wJeB0K/hNEzqcqsSfHsUir/PTsJLpkx4ZfKY2x0ba83t/?=
 =?us-ascii?Q?cuQ4WFXdwSO/xulFzvefg8pLHzIyblOipURcFRMIis/B6o12EUOiHmYmL7FV?=
 =?us-ascii?Q?oYhRr8wrvY6jzCUjPvNbabea2e5CFLnMLQkauMg07b8ksK/UKa52mdn/aCwy?=
 =?us-ascii?Q?x27kVpWRF+OW8uIWj1CaKNF8R7WvWHskxRelX8k9BFDNJa2JCTWgK50cbSIq?=
 =?us-ascii?Q?5wN6ev/0S2eUhc5am9V4uR7XBlqvW/EzesM8n0hK1AOJfKizKkhTZocF+C01?=
 =?us-ascii?Q?suqZ8EQDyqSFrBve/uf7Q986E9+4zf3didXL4/HgW5hRzeadOCL2OhaP4YYW?=
 =?us-ascii?Q?iHB4POhSOmVRqeUHzwc18fzvOzKAT7ieIiNGKYXdlRDa9zLZimsSi3NBY8p8?=
 =?us-ascii?Q?oA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	j/nYYGh9XXqTyAQm8DsrybFAq9khlsMrn+IFtniTLP0WF3N86X2wgCIYOaCwDufrfvPQgE7+CZ5vDKJnPuEb2gk/JRLoahHxuyNvovaYzIdjFIXKSYJgG9Fq3bqB4x9nT+DHc+YDLSsosp8uVJUIR0NMiGgAqxXMzn6o7rAKpTuHbtlNlxKrC55Q+y/PIprpBvUqEfIpRFU2JX5RjMk6QxPUd92Hugano1PBvWSAO5zvAb3I7kEpu6kc7/xc6Wh7L6eYXqJD5BSzqfgXgUu8AnIA2Pp5b01ujt5HBtM9qzHejreL9vLte6fwBbGjSTPtbtda+ieyMFyRjUD8o4N0iah5WWINhbQmUquRVZoiXUmwWDsm3g+Ar7K/9Skjk1YZj2gfyLMaxondn2BUW/vHjOU4rAEXx18Cs1aOFtqh3bwaBtyFqBR7/CQF5nx0RkkoYMcN2x1MU9mVc5SlCkRuBnseoxb0EQrMkZjSKOHELlcRvWRpBpGvAB1/hjxE+Cf0/f1gkiarjU7Zbltrv7Tb2jNnVmSedMNaFBGySKFpzYB4hvTY4q1KWwkhXk6LoqLsPp0/N4zRhFXK7u58F/EUaxetCDG0G8RNqa2o1Ms8Krk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cae139d-5025-41f4-9fa9-08ddf112bb36
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2025 09:08:11.0795
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y85/cedJpaDQXC/q9Kmdz4mmGW3yC4IUfmZBZehen5lFZ280QW0Uo37ElqVi3VAPF7FAZz/AkqIu42HPVS59s7GO6N5TA7RMlfs31h3kGaA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB6430
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-10_04,2025-09-10_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509110082
X-Proofpoint-ORIG-GUID: zR282rCCVcX-b-iikGKhqHicaqLGXqpR
X-Authority-Analysis: v=2.4 cv=PLMP+eqC c=1 sm=1 tr=0 ts=68c2918b b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=HpuET-Fz3U5eXSXnv-kA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: zR282rCCVcX-b-iikGKhqHicaqLGXqpR
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE2MiBTYWx0ZWRfXxLFIwUGu3Jk7
 IVUcfPAFnHHJWaltbZ9mqV5y1MQRmJG/TEYcLaqR3TfJ1GrSzHxjprFggayt0lrD14sMWoKx7I5
 jV7KxJJ4nKKDh199HBBAo4AY635EKvbIaPEjmmeqGlegCsi4DhW1E6FcRz73YRtTWeZ4n47YE/4
 bpokqOUaOCfyGWMhZ2hBR1ai6PDRmgK8GkJBwucimwTN8dxGe7dn3xHbJbT7MaX70OpBqv2wSw9
 UfW6tf2XDTtfaJ+pICYGIDbpcRqVQ5JwdoAn3O2v3/jQb79HjbAXGvOx8rfLydv2NwF8vRbyIjv
 wDgf2wsOf/umR6vkZT7ZPsUF+vbh6mieaKePzkaFVKuGi/zbi9pDgsFo7tt2Dr+8aOrVhG+2aWL
 iDgwQ/y0
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4406912000B
X-Stat-Signature: 5pobfqf7kfme7mb6tq8hokwrg3gakghw
X-Rspam-User: 
X-HE-Tag: 1757581722-392780
X-HE-Meta: U2FsdGVkX1+aQGUFd1gVTEaa8ttRTF3SU99r9eKLDWb6ndfNx8uFBF4Ain74ojk49wikNfBDhKhtvkfHH/UW0n2LvoUu1cu1UaFXCp9FXxvVgwNujB/tJeYGW8KO8Fy2KjbyBirwaEeVVAd58p/tbzQua/r5vxf6rf/42s9xWqUY+sGGeyQyrts/eLvewN7vF9Wn1OclXkMjqnH5rivgiEP+oai4id/dhzn2wGSRxhWcFWUr4CCjNf8dN1woq7KTssPpzTxPs8yzNh/HUACJNQyH7Upe69sERdE7akvNJXoE4O+fl5+/dJkhhDwOMSlpcROjC7K/qwrQcWC+sqpuSmWYVZDirDZhK8F1WyXR1+g8AC0eYuvblj8tP5HOMekKa4mct6kbhXLYMisMjBJE7EFaJ1Wrz6XvZvyMMuOOgYH6VGrWY1FHKTSXl5g1AgVQ59eoL499Pr2ymRi5VlXFERzYvYFOpKqauRR6FTevqc9ChlEF3ph9VcKZ67x07vJRAEaup5bYisd1/5CnGttwAx5vIoZm66Rg40DHxqsRwgoj2Aisch94lOitIk2GfXCYCUhmRPteMDh9ZWSIx4lxX0t7764DOy531q7biz6RN951g8YYeFU7WnBRZP8wxUufX1Rzd74SkJCEWkw+AUU1xdjY1IjLx9KRVjRfYnya9SQ3Vd1jovOQKYGxZ01BTcTA3js3uva2Q8bf5Pd8x+ogWibd8B0ZOGYXyznhi+JXmzRHhlk6INYwteR4KoeTgleBgHhxn6wuzRsIiyCODXH9ATRoUNAJQ80inV/oUuOjaURzW6+w9bojc7yrjuPkxBIyBdnbyjU7ellt9Z6y+r80O7l5Bc42eesBcE2pC7bQzhIbq51sC65yjkPMTs47hV2VjQLdy8OodcGa8Iw8EAzcScTnUj23iJn3Vlt/SIfg8jlkSb+E+pjZVozZMBiVmTRNqekqED5ueiaJKjOoHwI
 CrrHUL5i
 /U6WXFkQKgzdjQGWCGjkoVmMiLbMX8H1FFDbRISzJtWKaqnCPGuPkXVISRQNC2zGi+1tVbdrU6VPSzooR6VdlL2/bSb7hAvYvc5hJdw89swXts+pxrx8LczfpMD4JiywG/XQRFU5BR0jGEdI62QeXb8854ZGtepgUrYs3GVtIELXVN1iIJgn0pIaYu0inohjxuq5SqyaIQVDgX/InCrggG4M9h8wYuNaaNd/hAc02KgXfBWmuBOjA/h560oCWYR5WA2g6RXn9dz60w9276H1iLSNeu5d+gEKVHz6YuLcQSPCg6Eo8pXzIOWH9SBBAbMIQU7PAhHSjRuIzLhXjV6uIJr1D9pE7E+v32wEm67LKNlXEn26YPJbkY4J1g/tomj/cQccWyPiG1X7Bi84MUuupH1tvOm49imSW2eyRt7w0D3BLXQ7suoDRcf6mb0e0HP9ahjROPXnpq9pl1CVTU+T5tqXiKZ+3lDwTsqRAk67ZM0+QS42yWZ+upfoOfZziN2lY7KIxn0QCE5i8sS6QWk6G5x077mWeBWuuL1BrxyKjCZyq5VP73CwuabrPJp6FnXIgUorYlknIn1exvYem4r6fbn4GaHw/OScz1FiXnGsWcZGkb0MquFFs4srJtiI9y0qHtJjPb+FuxL934z2G8wnYX7YX9IzNNmoyAiDi5i7UXkNYJufwKzkBK/q5o79Xh/V3U/mHYgB0BuLq8l0DXIPG/l4ixwaGCI0WrrObnwszPBg2Pl2xl0SImb28cT0JQJCAH4CysYEWcIoScU1nel+omNuZURxHBxibaXpU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 09, 2025 at 03:09:40PM -0400, Liam R. Howlett wrote:
> The ceiling and tree search limit need to be different arguments for the
> future change in the failed fork attempt.
>
> Add some documentation around free_pgtables() and the limits in an
> attempt to clarify the floor and ceiling use as well as the new
> tree_max.
>
> Test code also updated.
>
> No functional changes intended.
>
> Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>

LGTM other than the nits below, so with those addressed feel free to add:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  mm/internal.h                    |  4 +++-
>  mm/memory.c                      | 28 +++++++++++++++++++++++++---
>  mm/mmap.c                        |  2 +-
>  mm/vma.c                         |  3 ++-
>  tools/testing/vma/vma_internal.h |  3 ++-
>  5 files changed, 33 insertions(+), 7 deletions(-)
>
> diff --git a/mm/internal.h b/mm/internal.h
> index 63e3ec8d63be7..d295252407fee 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -444,7 +444,9 @@ void folio_activate(struct folio *folio);
>
>  void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
>  		   struct vm_area_struct *start_vma, unsigned long floor,
> -		   unsigned long ceiling, bool mm_wr_locked);
> +		   unsigned long ceiling, unsigned long tree_max,
> +		   bool mm_wr_locked);
> +
>  void pmd_install(struct mm_struct *mm, pmd_t *pmd, pgtable_t *pte);
>
>  struct zap_details;
> diff --git a/mm/memory.c b/mm/memory.c
> index 3e0404bd57a02..24716b3713f66 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -369,12 +369,34 @@ void free_pgd_range(struct mmu_gather *tlb,
>  	} while (pgd++, addr = next, addr != end);
>  }
>
> +/*

NIT: /** right? This looks like a kernel-doc to me!

> + * free_pgtables() - Free a range of page tables
> + * @tlb: The mmu gather
> + * @mas: The maple state
> + * @vma: The first vma
> + * @floor: The lowest page table address
> + * @ceiling: The highest page table address
> + * @tree_max: The highest tree search address
> + * @mm_wr_locked: boolean indicating if the mm is write locked
> + *
> + * Note: Floor and ceiling are provided to indicate the absolute range of the
> + * page tables that should be removed.  This can differ from the vma mappings on
> + * some archs that may have mappings that need to be removed outside the vmas.
> + * Note that the prev->vm_end and next->vm_start are often used.

Great write-up though you are missing some horrified noises re: the arches doing
that, I guess the reader has to play them back in their head... ;)

> + *
> + * The tree_max differs from the ceiling when a dup_mmap() failed and the tree
> + * has unrelated data to the mm_struct being torn down.
> + */

Ohhh nice nice thanks for adding this comment!

>  void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
>  		   struct vm_area_struct *vma, unsigned long floor,
> -		   unsigned long ceiling, bool mm_wr_locked)
> +		   unsigned long ceiling, unsigned long tree_max,
> +		   bool mm_wr_locked)
>  {
>  	struct unlink_vma_file_batch vb;
>
> +	/* underflow can happen and is fine */

I am taking this as a sign that underflow is in fact fine _everywhere_
including in internal plumbing! :P

> +	WARN_ON_ONCE(tree_max - 1 > ceiling - 1);

Hmm, so if tree_max == 1, and ceilling == 0, we're ok with that (would
resolve to tree_max = 0 and ceiling == ULONG_MAX), I guess relating to the
'interpret 0 as everything' semantics I think we have for ceiling?

I guess it's because these are exclusive.

So perhaps worth updating comment to:

/*
 * these values are exclusive bounds, with 0 being interpreted as the
 * entire range, so underflow is fine.
 */

or similar, just to really underline that...

> +
>  	tlb_free_vmas(tlb);
>
>  	do {
> @@ -385,7 +407,7 @@ void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
>  		 * Note: USER_PGTABLES_CEILING may be passed as ceiling and may
>  		 * be 0.  This will underflow and is okay.
>  		 */
> -		next = mas_find(mas, ceiling - 1);
> +		next = mas_find(mas, tree_max - 1);
>  		if (unlikely(xa_is_zero(next)))
>  			next = NULL;
>
> @@ -405,7 +427,7 @@ void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
>  		 */
>  		while (next && next->vm_start <= vma->vm_end + PMD_SIZE) {
>  			vma = next;
> -			next = mas_find(mas, ceiling - 1);
> +			next = mas_find(mas, tree_max - 1);
>  			if (unlikely(xa_is_zero(next)))
>  				next = NULL;
>  			if (mm_wr_locked)
> diff --git a/mm/mmap.c b/mm/mmap.c
> index a290448a53bb2..0f4808f135fe6 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1311,7 +1311,7 @@ void exit_mmap(struct mm_struct *mm)
>  	mt_clear_in_rcu(&mm->mm_mt);
>  	vma_iter_set(&vmi, vma->vm_end);
>  	free_pgtables(&tlb, &vmi.mas, vma, FIRST_USER_ADDRESS,
> -		      USER_PGTABLES_CEILING, true);
> +		      USER_PGTABLES_CEILING, USER_PGTABLES_CEILING, true);

NIT: Might be nice, while we're here, to add your (very nice) convention of
prefacing boolean params with the param name, so here:

..., /* mm_wr_locked= */ true);

>  	tlb_finish_mmu(&tlb);
>
>  	/*
> diff --git a/mm/vma.c b/mm/vma.c
> index a648e0555c873..1bae142bbc0f1 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -486,6 +486,7 @@ void unmap_region(struct ma_state *mas, struct vm_area_struct *vma,
>  		   /* mm_wr_locked = */ true);
>  	mas_set(mas, vma->vm_end);
>  	free_pgtables(&tlb, mas, vma, prev ? prev->vm_end : FIRST_USER_ADDRESS,
> +		      next ? next->vm_start : USER_PGTABLES_CEILING,
>  		      next ? next->vm_start : USER_PGTABLES_CEILING,
>  		      /* mm_wr_locked = */ true);
>  	tlb_finish_mmu(&tlb);
> @@ -1232,7 +1233,7 @@ static inline void vms_clear_ptes(struct vma_munmap_struct *vms,
>  	mas_set(mas_detach, 1);
>  	/* start and end may be different if there is no prev or next vma. */
>  	free_pgtables(&tlb, mas_detach, vms->vma, vms->unmap_start,
> -		      vms->unmap_end, mm_wr_locked);
> +		      vms->unmap_end, vms->unmap_end, mm_wr_locked);
>  	tlb_finish_mmu(&tlb);
>  	vms->clear_ptes = false;
>  }
> diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_internal.h
> index 07167446dcf42..823d379e1fac2 100644
> --- a/tools/testing/vma/vma_internal.h
> +++ b/tools/testing/vma/vma_internal.h
> @@ -900,7 +900,8 @@ static inline void unmap_vmas(struct mmu_gather *tlb, struct ma_state *mas,
>
>  static inline void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
>  		   struct vm_area_struct *vma, unsigned long floor,
> -		   unsigned long ceiling, bool mm_wr_locked)
> +		   unsigned long ceiling, unsigned long tree_max,
> +		   bool mm_wr_locked)
>  {
>  	(void)tlb;
>  	(void)mas;
> --
> 2.47.2
>

