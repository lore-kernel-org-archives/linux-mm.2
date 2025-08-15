Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D148ECA0ED1
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 09:38:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E027900243; Fri, 15 Aug 2025 05:38:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5914B8E0002; Fri, 15 Aug 2025 05:38:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40BA1900243; Fri, 15 Aug 2025 05:38:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 298898E0002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 05:38:46 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AD88BBC100
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 09:38:45 +0000 (UTC)
X-FDA: 83778492210.11.285CD2E
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4004B180003
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 09:38:42 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=hAQvy6Nb;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=RnHtYWzx;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755250722;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bavkr9denuJ/13Fo49i/aPbVlLKrkO0mjjxvTCIz5wA=;
	b=ph6vEGejJKt8TYsHJDSucpClt/IxuT+YVIMH5f9Uda2DrpIXCVJWLBIBMdbWdEHuQx5CTk
	4mTypegKP0o5/uulNlg9qIFILdCIMPNGZLjgq3upNCSTal76lyqhMvaV2W80bNoz2CrzIg
	qyajVLInLZ+wOuWLE98d84WvRpy8qlc=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=hAQvy6Nb;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=RnHtYWzx;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755250722; a=rsa-sha256;
	cv=pass;
	b=kv0LlUA5gNCAunLJOHqaFLqX3+yEUxI+lxTqTUwPpiuCStI4+Yu3Paf0/OtrOesxmMaUbM
	EjnOY37G5hxEnuce0HxpfKyN3GiRb2NJZYuVfERhRHeTT93tgBVIw9k7/bh4l2I7I8BUMw
	a2iZXzpiSDpDQ7pEHAPier8FX38Vx/E=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57F8g5tt030865;
	Fri, 15 Aug 2025 09:38:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Bavkr9denuJ/13Fo49
	i/aPbVlLKrkO0mjjxvTCIz5wA=; b=hAQvy6NbIi00V+sKSgDml0wsGtoc3dmP08
	9v5q/w+DpRAM91mJL/6bDm/Ry2wbwKDlhYvVXwy37Z8EBnbdhtTP+qF3JkGBFm0C
	oaWPP85MLAC1w9ruB32ZwoVgX/kUE9jsOS4zKj+fVK5DQbuxlIHox84OZRVm+uf6
	QC0Vs+Y4fpZJzL/+hM7jueesZV0gZeRZchR0KlA6tqY+06JmdAns+HnVZP0mjJTV
	dPGnMQxbZA9q30Ue/tSzM6eJWudeONiqFXFqus9e12skLMEJbnP/EnVc9TG2z/oM
	Z+3AIbqVHFYBcv0FIeqU5HBT71sVKjvCiHZI36fT1I7v8aYkQRFg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48dw453q8r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Aug 2025 09:38:40 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57F7MRxE006369;
	Fri, 15 Aug 2025 09:38:40 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10on2043.outbound.protection.outlook.com [40.107.94.43])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48dvsdmyrp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Aug 2025 09:38:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uXha3Oh16SAGI0gwLh7n/LR8niT5xfz8azZpUOoLL0qxxLZNpwQVuYppovR+wzOXSLhPfi0WXgiLIKK1B/zQGgNMwmkisV1qGwBhbpTPkR1jjJFXO8vwo5n27yoL38n5m0lBFOY4zE+u/mpCisUdhmQtoob4LjxL+wqFgXw/h5qdWNu7nOfQJfHJ/hetTBpauIIlsVGjctyPLiSkqxsmxyBJiAnp3bmh5tNNrzaOMxic8V5wasTESOsy06wmtXrFlCiDCTxvv15atD17lE6Ykr2yfAsT6I/kjegd6TjJVNnM0lCckwOsND0IMsRYcvEHRMyRJI/H701fOu7V/4yeJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bavkr9denuJ/13Fo49i/aPbVlLKrkO0mjjxvTCIz5wA=;
 b=ITv1IpE7wa3g84Ja7f9k7fxMSiq9Fpo60rh1Q5bJcb3+X4QG/qCpx1KD7GnV29KGZVaJypgG6IhM+8IfqhZxRW9c61n7SSD5HzWHDLgWjvNoPLDczVx0G6gy/sllSwCD8D85xLCpFdEN4qahAu8lp8gPBp/Swn+y29IMQS+f1nTZevrQAWmiMVc4RK9z8CTRX+v/wFywW+ZUHE1XwZLkOryyb13XgRmbq//wJRYtJ3Q2Au+BAlWTzByEMopD06jk2wCc1CJcBlS/vpOqRin5n2mBTZKtpiFMPpp97JWJ1VhaOmBdzxKX3RO+mB7g856nMrR2T6yj64nODz4dJUWTug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bavkr9denuJ/13Fo49i/aPbVlLKrkO0mjjxvTCIz5wA=;
 b=RnHtYWzxHFxcuaY2glZ5+wOqdkfdB2NLgDzu16Eb0QJbYZYInd0GiraF2xHH9u0F9uoBBl2EPZHcYJqtllqRam9djmHsFchgjws8KTCm7mPQa8/E/eR8KqmSf9/Tf35B938l4kRopAy7y/iXpj/C0ZOYfuen+q02kAI/Z52hOQY=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by IA1PR10MB5969.namprd10.prod.outlook.com (2603:10b6:208:3ef::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.16; Fri, 15 Aug
 2025 09:38:36 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9031.014; Fri, 15 Aug 2025
 09:38:36 +0000
Date: Fri, 15 Aug 2025 10:38:32 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, riel@surriel.com,
        Liam.Howlett@oracle.com, vbabka@suse.cz, harry.yoo@oracle.com,
        linux-mm@kvack.org
Subject: Re: [PATCH 1/3] mm/rmap: not necessary to mask off FOLIO_PAGES_MAPPED
Message-ID: <d1800d00-b983-4a14-8338-f1f30c330ab1@lucifer.local>
References: <20250815084943.23063-1-richard.weiyang@gmail.com>
 <20250815084943.23063-2-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250815084943.23063-2-richard.weiyang@gmail.com>
X-ClientProxiedBy: MM0P280CA0006.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:a::12) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|IA1PR10MB5969:EE_
X-MS-Office365-Filtering-Correlation-Id: e9ec8c13-cdfa-439c-938a-08dddbdf81ff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0j1r12Z7Zdo0nvmeSrA1NS99VTUSD9sHlGoWKQmz7dJDNEznFVzIIgD1impm?=
 =?us-ascii?Q?uezPVMxaXiGmW5Z1wCmVHw9ZXqrntXtudsxLQNHDUhjohROrv8YfnSKHG1C1?=
 =?us-ascii?Q?DVnbxZg8ZodmkOY/7/PWBLSjiY4boz3KCFfPJW+zEYRoeihnHXBWmXsaONj6?=
 =?us-ascii?Q?pKXtvjJ4RMgOr1LjMY/K+OFetrxtbego71IzMTTElArSk6ITTYDDANNzGlvE?=
 =?us-ascii?Q?NioIHkbLafEXcbvLDx4dn3IFN8pxAVbgjaU0vQz7FGFxsbyXo1arzP17yNuy?=
 =?us-ascii?Q?vcKmlP43btArCXC9iMTl/dOBRaWUJLXWo/N2lQySqufGc+55/gAGad3Axc6k?=
 =?us-ascii?Q?tS9FNwHP8h3Qhr7WBGr7vfQS3nBUHWS5HeqL6AKCcBxWuGuzGeeFMS6b9iXh?=
 =?us-ascii?Q?3OXzl6jF8LLKl07/+9aJ0GNb3Nm1+TE2ioKhWUgXmCifHa7mD5WwzFWuKtYT?=
 =?us-ascii?Q?p8oqSXdoeN6L6OsyYuH2UM9dJuV1zXEtOO9igYHwppf22xHCQoOhCKX4SAS3?=
 =?us-ascii?Q?fikZ8EW9HX1+vBC4jthPgYkwy7NGDmbhzEvRsmr2WHL08rQ8pflD2PHDvcMo?=
 =?us-ascii?Q?D8lh7PzCaJHb7kM/7MlRDJ9Vlqe1EXjbAVyAlS8jPduQwK13ufvWG3nxMj+A?=
 =?us-ascii?Q?ZaWZGEqwNO7MovjCRN4jcb1/569uszN8/vJfHFg1D+ZvJGEFUxJsHJaBnsQq?=
 =?us-ascii?Q?+DQD5t3Vv4IwK6TyYFrfgeen2VrzXKYM2DUjJVBw5tnr6k53F2fQ7nbdIMcL?=
 =?us-ascii?Q?I1CnRtg2nSHlvJi4GrnBGD+3My7gqNUUO9Imn9Ww/pnCCV74vJ9fPEleue7A?=
 =?us-ascii?Q?S/tx3hg8oZRhLGCtPeIcgy0Q+R47xocfX6o6Pq0ayvkJzEG1TubUTXpoxMbr?=
 =?us-ascii?Q?e7v6a/hpup4OPQoXizM9vC4bniE14FTnxsbsg4VVvRl/7mybCWLGA8VTt2oF?=
 =?us-ascii?Q?3dlmjZ9WCGY+F5VSTFm64bgezPIJ42rPuMkZJp91i+xOoTZVGZWFcrf0x7tm?=
 =?us-ascii?Q?AZo6rJMBLUz1nSDmoORS2lu3RW4I5MxsaKgc1j1NfDyp0YRoDWqN1oiJvsWa?=
 =?us-ascii?Q?pu07Kg/ZHFExtso5NdkCqtzN3LHfFKhub8iLUoM6xKi8NrOcWxISkOh2iyg6?=
 =?us-ascii?Q?4OaJt+H8ooHCxEyUuSioKlawAIjWhR759AHo4bTJuQO5J+nWlVvea+aVbqf5?=
 =?us-ascii?Q?1Pl1osHmGdvak1Sw1XICF3p4V+Tp7BWmNpolf4rGlpfLPpJuZmzBX9WWtrZf?=
 =?us-ascii?Q?Kn0MXgztRVNzamOvOcFtxQ6DPxt6wxJEevS5/s9l7566Uu+XNaLcCc2Ux7Dp?=
 =?us-ascii?Q?DyfWkqN0+0Z04e6WQVJQwThvkOrcFy8s85FmC41EzxvxVBIl3sjm8/h7D1BQ?=
 =?us-ascii?Q?h0S6Rcms/R79z1AtzWq1FbZHJJDYzH2qJBmpmliN/2uOOUvVIw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZPBcELLUfJeOqVv2Mtse703at/xkwZfv4alRpLZ7Uty1eZ0U44ywZ6hktCTH?=
 =?us-ascii?Q?2bhUUfceVVw273dX3u+N53zYah4OIFRXFnknI42oyAclK0QIM4SMn91UXIyS?=
 =?us-ascii?Q?tsPkC4FMbz0L1wLCDymAYp0xM6xMM1Tu9SETLkYShkmUQHCiKeOhfJQ8m7yI?=
 =?us-ascii?Q?8fP1IP3zOqXJwbbM1SUi1p84xsGCUD/DzsgbqcHRsXKAT+UR47AGmjm8j97P?=
 =?us-ascii?Q?I6GB/yvOfOE3hKmVoS1ZJvjse0hAAo+iMTjQgqhk3lMCiV+s/2jyczzsU4hu?=
 =?us-ascii?Q?dRy5tyxvKuPeafb7qxxE/+A0NCAaSKjOeCLGe0VKBJfhHr/bX9jxeSQN/lB9?=
 =?us-ascii?Q?ts1RIYsZ0LyF1jvkkw/lO9oAw6XwDAO/Ljwxbav9Bh3PlAZCWo2VfecsggIi?=
 =?us-ascii?Q?UBVijTFaOlrIbViPRpsd4EpfU5UXd63F7X/I8qhr2tOzi6+B5xdxCwEGaqgj?=
 =?us-ascii?Q?UV2g87nrciQeKKoZfqUwMurHwnCySfiINZizixCFayJthSm/MhwBpzIGpIn4?=
 =?us-ascii?Q?BRArhJxbBqHQ0cuf6ypgm72DPbDi0XvYWShldFT+63J3BU/TBbPBVujNnu92?=
 =?us-ascii?Q?SKO4UH2gIWAaL6WjTv4lmnl8fSbqm+uiUiv3IS8Ulf4EDEa+OihnmgAJK6Gg?=
 =?us-ascii?Q?zNHBgM95tvFsByfd1tW9HorY3RImdo8DM1SwoFW8GtSbhmixZS0fdkPF2jA3?=
 =?us-ascii?Q?fO/WZelA4whv6yFAnQ7NUJP+bV44tOTbjt58zdjjb4iBqmvS76WDfD0qC/Ul?=
 =?us-ascii?Q?0SO7dxy6+/irnJFO0BnZoh6r4NMQ8yRS8f+l4xMh3bwtjm5z3Bmlh62u7aJu?=
 =?us-ascii?Q?zikw2ICNY899O4vjRrnmouoSXOiMOth7lmYOYCRx+ORhj4BbO52ByNaOQqsh?=
 =?us-ascii?Q?kjGywyH0sFk9bInVpYHEmZpxsqqTEiedYl9QEr1VA6vsMKR+d1hx4KpOsf2j?=
 =?us-ascii?Q?rEtSIlARCLCxUI4UBxCOddMlTKjAkAD3gyZa/tyU5AdRXPyHEJp8cWtL8G6d?=
 =?us-ascii?Q?jYPZ/0gXvB7OCuZt3x92wsgMF5uSI8M0dRbjOYmee/2DCQNk5DwXaIqGjqFF?=
 =?us-ascii?Q?6hObLgLWTgAjNvRzDPZoyYXkQeePTwbNhwHjWBuD7NtnLRykZNVi7ohvOKKR?=
 =?us-ascii?Q?ouexHUvxINHWaQagBl+fcodsrQjog63r8VDg6u/gWJoFsrKp8jztivEiM3PM?=
 =?us-ascii?Q?z7uUrPWhycxul/Y6iy4qHF+fnRP/PX/+Q9+ebXsmW7Mb5wCOyjWZ/f7DPMca?=
 =?us-ascii?Q?/BABaaulbpSG0cD5YqmnhollblHzRmLGSp6gIC3Nt7KZkcfL+RpXq6CZjQ4C?=
 =?us-ascii?Q?mis2GsSMTqziXjX5hcE4ml7Q6OVBclbatRWqwDUbhNWzt0ZbPdkHsjrvico3?=
 =?us-ascii?Q?6ikf3VVEY/qwds+esjVI8sEdRaWIs8g23h4ZdCtLnn4V103VJ/CPaq0Kbowb?=
 =?us-ascii?Q?QdwoyDa8C+mYtD9Ryk+wr2jG/hBHUTf/c5bE14TdLGUZdbCJ29aOpViTEEnS?=
 =?us-ascii?Q?ffhnLkG6IMUDqAMMcHCDC5oG3pU7byDLyO0xgCwEYf1fsQv4vIAlsfmykCWr?=
 =?us-ascii?Q?VqAgiv7LCx1v6ccWSYFKtOKmI8edouUW738pkczJ10zq4+MiCJkSe8KxFjQp?=
 =?us-ascii?Q?RQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ULfZqHPhSS0XwyrLEBtfGLD5V/9pRmCltL4GTPVTrnBBzsWtAI+N9xlXujc+bJyxPP9h4YBPw57P0e0MCUy5781d30ka/o9/kkFoEahVgrrL5Itnkdf98U2fKA2dMtpdjWby/a7m3xI2wLJ4ojlnfqdFwJKXOENfPXhmthxvVAXVhqxEg5jTtrwCUsXTsbpaSaLymSI6nNOibtE8JTX/VihQRuT868/lXYLkEK3LTdfsfJOI7Ab0+0DSmktP2pBNmlSFSg0DkYV/V55mkbQIdNxo8HaGAUTlPoSV+pxn9ws6cmF4FvF7GP8GonumYVf13asadVKIoitG9kmWxTeQzcp1zFM1xX1/MmC8/5fyXAQ6I/EHBw1paDwgREElAH7Wk60fFyZwA670iU9S1NNwSKqr604NAuYScqZmSHkAaiv7qGPUpNytnmoEu2HZTKL/4RPhi5cBd1th50MuCFuFAYXrB49vrcCp/sOIzySyqInF3VPZt/9H/pSzjHCOYqBUSi9TR0FONSTDUnhggGKWd+V8C1Y4QxC51qqK9+2VRiPfmUQ3/hld7uWPraVseFssm2UBzNhn58tYdFrf0s6BQuCzbU8G8UeN1aCjdzMuq7A=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9ec8c13-cdfa-439c-938a-08dddbdf81ff
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2025 09:38:36.2514
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DAznp8poC/a57mwayZAlXbFq+S3Tgt3MtUve+438K0wkp67RtPOW8FRvaMa8iOtv6T9If/yCrtExA8f2y6H9yMcoNAb3ns2RTrkeNGu45Ns=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB5969
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-15_03,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 malwarescore=0
 spamscore=0 bulkscore=0 suspectscore=0 mlxlogscore=938 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2507300000
 definitions=main-2508150078
X-Proofpoint-ORIG-GUID: Sja-lKcIrd6MZrk8VSkMHElo43ShEuhK
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE1MDA3NyBTYWx0ZWRfX6HPN4NNOAHfG
 xuKcrvkh5Wc6osai2Ficd21PDgMgdqxkRmDltbRrqFHzqQ1sfhFwv2WzujOaZ/1oN709WkZIGa8
 xcXxDEiwoE1jWz08ugP/XxD6fLxj1X2cJTuRo4FsS1Cp0gv1spIZrdnulC2sZgDZyD7je/5SZMR
 fdOfRyAgRbhDmCDo1lk4BcsBo3c3ILRplPf2IT5zHlvmb1O6J57QUFofTLeldXs6/WHjoLWPwre
 zUvVRezCZBITVZSQvJiEvqzqWOnZ+10QyyJM6ognu2kv4uFUqOa17wUvcQPjRTymARTawmQsaSB
 jLPdpD3OeRZu/p9BzrQnhsUu/wF0PNlh5yp9qG7ng40/W1kFLR6dFOc8NYtCCXqDE3i9xHL8tkE
 vr9WwY27dDh7DU+0fWKEiX6f8XLYbTRa+i0Iyk44VX2jqb0NfSiNrWaiUxrGdSVMoqplSo4p
X-Authority-Analysis: v=2.4 cv=X9FSKHTe c=1 sm=1 tr=0 ts=689f0020 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=pGLkceISAAAA:8 a=yPCof4ZbAAAA:8
 a=20KFwNOVAAAA:8 a=fwyzoN0nAAAA:8 a=UJFqzMfubsnPi-3umhwA:9 a=CjuIK1q_8ugA:10
 a=Sc3RvPAMVtkGz6dGeUiH:22 cc=ntf awl=host:13600
X-Proofpoint-GUID: Sja-lKcIrd6MZrk8VSkMHElo43ShEuhK
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4004B180003
X-Stat-Signature: ny8bad86ibhgxw9n14db1r7ux5edh4o6
X-Rspam-User: 
X-HE-Tag: 1755250722-180330
X-HE-Meta: U2FsdGVkX18lyPNideazEEv2Xi38qJ70OlzH3t9N0xXry3t6aD9aguUnhQHH2Zf8EJZKNxMD7GeJRjyWVU6ePOBGQWBA7DBcmU89DAcs/xGOB5G8HhTQNu/PxbonFOeh7k1+DCCmX4aK2fCx+heZ49DmTA8zvolQIGud6cgAc3zepknZRFYwK3Ixmg8VtSkvEIxD0mn2EJM37FP2+iEUrGTrQgeL5EsfKIm5TlvrKWHKu78acGFNUCPZnLFqJYExvk3KNufO5kUJtSkepLBIgIamaZdXz91boM78vKE19Wg7/siebwDLpg7IQC1+iFadEZKtDq1iu0QY0Kz5v2+B99/ZAO1/srQ13NKtjmZHSoaamyCTNFvlJDk2yA10IRCgq+dHdD3ZIo+1InbeXtu3KJvcuptF5iXL3gcbi2EhkKlisl0rUV+tcHeKwWlSWJ4WE7vcXgJ2LD/gTpXeEx3ntR2WncHd8EiN0autdnRBeu2yLGau4Pp6wf+rFffAB+DVofYto1UBk7SUbTDZipKdVkSuSlVPjrusuEX+D2wUWZXkBwNvuTsiqaFiMV2x8vthFlBH2IBkYMojzVSWHfDR9CuJylF7CyUM2rBeNIdBXAgOmh94jQksWDKkuSGJk5h9gaQUY04tFpF4OQNybsT4t4HxCYez84XFezw8hXcg0WlNbEp+uEXeST/XCCIwap5KIJGfW1GHYLy4NYeS1UikCrcTitOaPw+2G4rJvsHK6zW1MgMwoE2DcdwRQMgFgK1LrEG10w1X8nLEhmE0ePFlNDd/MiH0d1nZO0QRQ4eMnzH10kcEgVVMvuC0jtOJ+42fzWxKyzF9mTTjou8RiOsuy93ufELOqI1NgXJeBdX1d08ARU4ccXkEKkVXbO0tpSW2x3UZORm9DVSXeFLpdWzwdn7gSXGiQD5veR38y6EDr/eVqvJ7KqEV+dTSqvXIXsWyiMUBUiLuU6/4dtjBeZ7
 1ESQ3IfV
 hTTWKvDK3Fp3/F+EBCHJbrTSHF6pTz55bnj+RSY+vrqoah6jLRHxYacGYCAW9CG3ghbMHVzkzbKjQ5TGaep2O0lxHI/6Msgs/u5AV8rBmgP+UWKjdwadxkEHTDbqAa7cl+Bp2DgtyOE2mBzUQ3d9QMAfUxaeUWtNa+QTLCnP7nOjVriEIF4jgSoIHWR1fcK+Xc6n/ArKNFO0gIKJuZWIjwFdo7vaR0EUW02DGlbFqmGmVhCLe5zBVn/QiZ9SRvFiY2ywbvbo+YFuXXRXAvckj6sZ83GIriwsvEIP4p0jAHHf30VdBRh+TlcYNKFLUWtTabVcerIKFu1K1YmNxMtqbh6z7UcZ38U14YqSBhbC/fHzekSAkY6RMnU0Qpey7zfTNuKVUWZ1Vvucemi2051/eZ8qGqsjoUJguZMurUlxZJgE3jxvgxoneJylfQwncyZp4i2zZbo9udksGGNimRCH5Q7jegOCHeRxT41XhB1UT6VWZVrcKXWgVBaczr0qYqVBVorJ9IQAlUS1Q79g747c2Rt2SveH3UyC4TxEgD81qdDQ9mldBz7M2R5tvzKVcV9RTlajSW7vFhZ4/DrKQF3yjXPD4QA/0nv+CvHgbHGpCmwxdNIUH9OZuOBXrGULSwfXPQICJdElCvKiDH2A/mC+ozixli7hSTHDf/5aSzfE8YtPmuR/7o60EPpQ3LGB3bYrfe4vGhXRZevrk51T9wBtPu5NnFYhero9OWfheAyqZQNilsxLtPlkBVsmYbpQHe9Knu82HL5+xbVyOFo/q1WoVwsysaZ0rMN9yK39R85XbtcarY6WLXzw+NIZee8e0MWM4YDuQAChIMpnyqCRdjjyXRmd/l1bfJCKUrMMghUgJR3I0Y2BHw0A+E2n1bkgo0J5L5ziVVZmGYIjnGgqJ8kEfsDn4llcf/IRW1LRW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 15, 2025 at 08:49:41AM +0000, Wei Yang wrote:
> At this point, we are sure (nr < ENTIRELY_MAPPED). This means the upper
> bits are already cleared.
>
> Not necessary to mask off it.

Worth saying it's because we are in an if branch conditional on nr <
ENTIRELY_MAPPED, and FOLIO_PAGES_MAPPED is equal to ENTIRELY_MAPPED - 1.

>
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>

I suspect that this is copy/pasta from __folio_add_rmap(), but it may also
be some way of asserting we don't underflow nr.

Anyway I think this is fine because the branch implies this is ok so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> Cc: David Hildenbrand <david@redhat.com>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Rik van Riel <riel@surriel.com>
> Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Harry Yoo <harry.yoo@oracle.com>
> ---
>  mm/rmap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 1c5988dbd1e7..a927437a56c2 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -1749,7 +1749,7 @@ static __always_inline void __folio_remove_rmap(struct folio *folio,
>  				nr_pages = folio_large_nr_pages(folio);
>  				if (level == PGTABLE_LEVEL_PMD)
>  					nr_pmdmapped = nr_pages;
> -				nr = nr_pages - (nr & FOLIO_PAGES_MAPPED);
> +				nr = nr_pages - nr;
>  				/* Raced ahead of another remove and an add? */
>  				if (unlikely(nr < 0))
>  					nr = 0;
> --
> 2.34.1
>
>

