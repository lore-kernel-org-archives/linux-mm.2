Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 317BDC87FDA
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 05:12:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A71EC6B00E8; Mon, 11 Aug 2025 01:12:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A49836B00E9; Mon, 11 Aug 2025 01:12:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E9E88E000A; Mon, 11 Aug 2025 01:12:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 761AC6B00E8
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 01:12:15 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 00C06C0605
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 05:12:14 +0000 (UTC)
X-FDA: 83763305430.13.9D7796D
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf14.hostedemail.com (Postfix) with ESMTP id 784BB100006
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 05:12:11 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=mR6CQJlv;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=FzSzqZQG;
	spf=pass (imf14.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754889131;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4t4ZBSVPD9/1iRsdCk3wcdlp6dThbCd1wf4XE8W8LfY=;
	b=uMYjSahGl3cf2eKZr7W6Z+zOAhuk8D3gWtt7QFDwWs38mF176AIkltq74d8l0zSHnO3jWZ
	x0P4BySA6QjWEkI2r3v0hRkqfp3GJaxe0Qyql6gldiRVydP6J0zH3rMlrN7aiuo5gc0q+j
	+nDPJPqDRVklwzLfKKnJ5Qaa6CYdDpo=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754889131; a=rsa-sha256;
	cv=pass;
	b=YHh1zAJma+6SNkVcsWoZhg9Q+KUJ2oABJj+ebUqmK7HImy2b1gc7F2Ot+s31eyeFYuXC8A
	wlUyKm0csBs1z46Ho1UvzhHsT76iQ8zZKAF8Y0SFCljNMc4LGpHPrCwngw1oRR7NIuRVAi
	rybhX35ime1Do5RRSRPRs/u/7lOaANE=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=mR6CQJlv;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=FzSzqZQG;
	spf=pass (imf14.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57B3NhpD012388;
	Mon, 11 Aug 2025 05:12:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=4t4ZBSVPD9/1iRsdCk
	3wcdlp6dThbCd1wf4XE8W8LfY=; b=mR6CQJlvZeV96P+DRSf7PSJbbRUsHUsoxq
	SRJz41tOqcimEilkFwFo9p/Oi8wB9bsVliH6UhhyL4LYvMXRS1qCHeWjS7doLxZ3
	l1vsaD73HM6Ue0Vh2gyTtPuNrQ0KfGbCSH0kiZ8MeUm2eijvATCDhbDCCGVtuXuO
	wzq6HTpUvQKM0UULGm8a246EwNtwM3DJ/eZmJfb85OPtaKReZl1ooRLJ1DzKdmSY
	pxT4mAmdLg7cKlmT0z0YrvlhcYf9eQbCv8mjEOqCjBSuFzzZLqvUoT4s+HYTqHf3
	qv+na+9bIcx4id4Zuxe98d3Mpibr/bYkCTabLkiWChXUzRyMEBvQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48dw8e9qq0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 Aug 2025 05:12:08 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57B2uJeE017482;
	Mon, 11 Aug 2025 05:12:08 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10on2087.outbound.protection.outlook.com [40.107.93.87])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48dvs863sd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 Aug 2025 05:12:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C78sSzMlYq9azW1NNVXt43O5NqhONuoUDYYBwNYJEFAJdsvbF6PCaAactgGjJm7eSZMshSWwXBvPgwraAoiLxDhHl0SvtXjzPmG/vaMjL3JrhGCjmHpY7ueG47x4Kz1i9YBLPJiHGS+Cu6CS/OxuOX0o4ezCi7lM7EWdPrRGNEN30loo79+2kr76MosS8+NZP8hvvB4PdvJGJyZSaiGDXqACkZmR6SLOjjyvmIltNtCuVcbVpgngk6iabLqkDiMndwc9cI1y561FpRMZUkNJuyD4PxDzZuSU6pPcn69x9Df1gk3um0iCk1fPizc8hCEenv/dFN7RDJhw4HwaInuxzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4t4ZBSVPD9/1iRsdCk3wcdlp6dThbCd1wf4XE8W8LfY=;
 b=XCmet4CoXwfm4ABN9ek1ArC8zacemcmoN6ihJsoTFV5oQl6FxxRDhFZ7TyHWZdHugXnquUyHlchFuBFSkCij9cFoCN0TG6eKYArMUlT6o2B2FpOBmOud6k7CWYLe+iyvs0dSIneAHDzaPIw2Pm6GS0LZyISKefFHn40dOyhW5CEnCJ/yScPcwhbX0glzoBlwmXEHtYpYe9GpIVTTBxqtvuiymEtGK4FE1m0rkLLt3YE1Am/yXNfFfvEMZiMAK5b7cQO/7f6JvMduuDMsFwiHgR+OlmJ51tK81rRB4RSLF+gk200898MxtdOPNylqZk+Dmv8RoLY49nJEDHMAUzTEAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4t4ZBSVPD9/1iRsdCk3wcdlp6dThbCd1wf4XE8W8LfY=;
 b=FzSzqZQG8p7UJL2mAq003+2yfx1KC7WEL6yqL4Myl0preBqnTm1UgKJ4nHYT6nXMvHRgkkKH53vFjpBDxttAoCT+aVscOMBz/X318CBo/DM9axnmubtpqa6Ol/ViJobuWkxLlOG2rgtsxxs9TYI4w9uO7/8tnZZ2rVDTV3drMZE=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH8PR10MB6386.namprd10.prod.outlook.com (2603:10b6:510:1c1::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.21; Mon, 11 Aug
 2025 05:12:03 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9009.018; Mon, 11 Aug 2025
 05:12:03 +0000
Date: Mon, 11 Aug 2025 06:12:01 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: syzbot <syzbot+63859a31071a369082b1@syzkaller.appspotmail.com>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, david@redhat.com,
        harry.yoo@oracle.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        riel@surriel.com, syzkaller-bugs@googlegroups.com, vbabka@suse.cz
Subject: Re: [syzbot] [mm?] WARNING in try_to_migrate_one (3)
Message-ID: <d9b1c0c8-cd60-49fe-84aa-814b0191d3b7@lucifer.local>
References: <6897b156.050a0220.51d73.0082.GAE@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6897b156.050a0220.51d73.0082.GAE@google.com>
X-ClientProxiedBy: MM0P280CA0074.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:8::28) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH8PR10MB6386:EE_
X-MS-Office365-Filtering-Correlation-Id: 43484467-988e-4d05-0945-08ddd8959c26
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?sfct0HaeV0OZ2Ngpf/wRbaQ4iiubfGmm12krmihDGEFw4VvwwHsv7GV6ZfTn?=
 =?us-ascii?Q?xxSDfbr5kedwta0xjYkUvAsJZW0O+uXHu1lTgHzQackB1veJTtxgTUh8f/Gx?=
 =?us-ascii?Q?5qBvNvVB5b4GaNmV0TFrwkECahLnpmh8xuNrWLfZbEy0uAbwIlrdCrt8WspW?=
 =?us-ascii?Q?pHAEgVE1iKei9X3fdUwj3vU1dMBIBGLtwvWzcQGeg7DvgyRvJusx8df4JRa8?=
 =?us-ascii?Q?nY0Py9MuTIPRSK9kyTRsVfIXIzSi4Lyac2F7+8RX/ZIb6VsJsdUhvZeLjDY+?=
 =?us-ascii?Q?Y+avGQuCYmeEFC6SQNz3PjQzB1ZO7KxWIx55fr9PpHiYB0+kSEqLnYeLva5Q?=
 =?us-ascii?Q?QhwNYyt6nTzAEk/m0q4X9iVw+iV3xDzQoWH03G+/ay/+tX7Ot5HdwnRcZ53a?=
 =?us-ascii?Q?qOJDG0lSIeLAOeWHnjinGe1sGzXai9Cv4Tgekf/rsbfTmDP9Hs0OGFkun3xy?=
 =?us-ascii?Q?CuYydzFp2P2AzLIvn3pLeaExF4eCXo2TLBR+O0yii284kPWiaDWeEpBvZCHx?=
 =?us-ascii?Q?j0/AsS3LDkwVrd0qUnz+4xgZQeeaWxxldKQ0oq33f6lbJaTcjmLKFizlirQj?=
 =?us-ascii?Q?pWH4lsl5ovMdw5+Z+8Lop18rF5Ck582RtIzlLmJ1LnCQ0LsbLm/KU0BYyAuP?=
 =?us-ascii?Q?gjwpo2YekFGt0TWq91tG+ldY7UP0w1bdBbam5vmlyU01KfDb2zY/wKyKJvhg?=
 =?us-ascii?Q?g54Lkg8BVG7yWs4Hf9BOFGcLmL7AVkzCsFbvSy5cwypf2XslZWUXWU4EiKPG?=
 =?us-ascii?Q?3UlNrYGtiaq40I2Q2LMzjOg4MJcOuXyFDkF/Q0GTSRmpVF0IdLl95hEq64lA?=
 =?us-ascii?Q?N39mryg9VDQDsT97umjPsF1JUJfwsM+0AH7RdNfeuW54kR29n6xGXVU3z7xW?=
 =?us-ascii?Q?PKKC8LJ1lLZ7gabOJTtYbgow3BGV4ICNfKods9YKBzadIdR5sq+Ay4HOK8Ey?=
 =?us-ascii?Q?4J6vmisK3CwNNGOAr7B/nUY6eVinJUtD21ZpK5sWtOiPYpTxM+xZKa1lNVLS?=
 =?us-ascii?Q?TOGEtq1VkfT94qLaN/VD8UODIypW1N/1AcWFoLRXf/7v0ZkVs5XnyPwpIg97?=
 =?us-ascii?Q?mPzaPqVh2hYVwRwNEGWu9VRoyHezV1KYhfvz6bBYNh7VL1UWq4zlJpNSzIae?=
 =?us-ascii?Q?dbZn+rMdbDb7vQpNesJxxzuLK5rQ54/q4rJegEV6ZPJUN5zx6Icwxhq6nzes?=
 =?us-ascii?Q?sHpzF7LypHbElCqTEOe92SfIbzBhUxevCKwu7NjGNrJ2MNAGmindiCCTkoG6?=
 =?us-ascii?Q?nAAEflDqqxG+vOPBer2DUE9rFxBp2056Pv2qHErrBmS7UjVcxIVm5dXHZsox?=
 =?us-ascii?Q?uZ8vlcY60W9Cg5BDct2+OTbtvNe8q1/y4qLULrDEJUi6m58vEvi24IzsCKqm?=
 =?us-ascii?Q?GO+dabDHkIJGQLGFt+8FdgqA19H9?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?q3gZUjAK0MnEWd09yBlDDFFP61wNWW2JExBxAeAf8FYV3wHQqYyJSjHfwP0H?=
 =?us-ascii?Q?q0x3Bx2XpziYC17fOpJINe7pPTi7ecfuE/ZAahBCRJa3fgudZXcIvY/o6s2F?=
 =?us-ascii?Q?FSw4HsungYaGkYvN5stRVDy6moc0KNQfBWF64qofMcoYY2WWBQXQClMlvcCd?=
 =?us-ascii?Q?OdAKIlD9daWNszPHWQ5J4GcuWkWLvnR7WL30+ATur9hGVV0LooL9JYgesyoS?=
 =?us-ascii?Q?WSBRNZC7Qcygb07vLt8kD1hs049P5+XPFjBPhDn4klhLyz/cJ2eF2Khaql9m?=
 =?us-ascii?Q?DlJSwqjS+NO89McJ9UCrDZTdvizrCvIqWmABQhzaETMe36q7Oa2TcVo/wW6x?=
 =?us-ascii?Q?9HOk5xjb72hx6Lpyxl3BcDslIGY23Vx3IqTZ7hEVxOqWtAOBQfIcUSCAePbV?=
 =?us-ascii?Q?zgqAhUEPJn2dAzr4URD1V9mn6u8WKp17iP41zYJMwq6lji7Ot6uO8G4kIRGY?=
 =?us-ascii?Q?yxZlCUSMGeYNIASvKXzQMyPN7PePLoUkaxX/m0Oh+5ckeO+VZ0ctooKlpPGx?=
 =?us-ascii?Q?DRWRKAh9a5iWqRssfdyrY4rFAsx6Eyaq4zkckVY4MuaKvp45LpPqXZ8sq6lT?=
 =?us-ascii?Q?HuCMpl4uNQ+BViwfui8LOJN2trioTpFtCFnHPuxeZDWG5q6xtMaJx7tzAjjp?=
 =?us-ascii?Q?8tGI4bNmC7VwpBnFe9001o9L1TADkDn3puLLJpkd9gnQh+ktd67vrOsd35ax?=
 =?us-ascii?Q?oKjLts6/Z4F5ZesugmuTwq7NnEvhNaoqs1b2yVZ3iv2LcGEvd3Q/8v8B+r0L?=
 =?us-ascii?Q?/VVrFBHiWA8tv03bdgc+mi6Xi94BsxFd+tscpICSfuiMfzLOtgpcrbtAYAh3?=
 =?us-ascii?Q?v83Nu/upgYRuPr8vXE2Ydny3KaQe4WR1hn1OsIIx3HmdICPprkasDh0dNFZd?=
 =?us-ascii?Q?jHv7qMatxJnahVWYItNVoM+BIIQFrqTjLFbjtGgW4DYd12bW5IBv+hmFSp3F?=
 =?us-ascii?Q?oyoFeLKYpnLmDJyT0NIXXccCd84pUvPjEQtofSPiGa5huPCzEkSC4vyihmGG?=
 =?us-ascii?Q?36mBU754BMPIzdL8432c/ZY1q46AUnGfHf/XlC1ty0DPx+BNWiNPEt8yrQX1?=
 =?us-ascii?Q?UwQG04iOk2Bp9OBk8M/5XXDME7MLHSeoUjSShRGYlXZiy+OMmVgm/Ju9oH0E?=
 =?us-ascii?Q?Y8QrqIKy5uBo7o/DtUNLDg3vuYOhfqOwZoqAGHKMpvgmVarVMUi+IuE3sEWQ?=
 =?us-ascii?Q?DzumZrD+xuejv57x2dMf7CDsxGEYGwsviAnODTN27R5Hm+K3NihRV4ULvW3s?=
 =?us-ascii?Q?DVcF4v4R0wPqVoTWVExSgW88c+qKMrDGTVdlQeGjXGnbCr6Adiym8R4Bu6Uv?=
 =?us-ascii?Q?rCzIqE8ifsXB2k+BNQH1H2vuaeaOpuNeX/t9dKxHRhZ/OSH9QDPKcrqMvxXk?=
 =?us-ascii?Q?CPEr2j9ZVOZvWTUrgTVZ0yLK5mC96fA/aj0phXADTWz7WUIZIXDw0Y0ej72B?=
 =?us-ascii?Q?qAhVGwRBjS4qXMnFkYwqukr+Ty5C6ykBkfWVRUhwx7uvEIe65qcR+ye4ulqi?=
 =?us-ascii?Q?rDC+gtnOYcGGPVMqJYfSSEOO12gARsQun/1iw+zheblCNiK/jonV6/2ZTUrn?=
 =?us-ascii?Q?riWeVAVVk5WpiC2rJhbqMbJNvtuYhdnJDh6cJfL0HcZxACYEmA2zbZZAb7ao?=
 =?us-ascii?Q?dA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Sg8ma6a4LttGDob1jwrXWK0L/LC7dJTVFUBY8cFQv5dhHGDBVIoHWVYPL7uBYqwGdgvCAw+mUOcNlhna7cDzri4VSKalZAc1MO8YiAfu7WRkVKHMT2yYutgffVH990zPAsceJLnODEUifWBGPmUJSBtVnBNmi9YmnIjJRN1qtKSzWXAEP0bMhgxMq5HuFFcCMDcXbYoTH53oRTdfN65hhrQMqL4H6XPrWNaY23TmzxgQTQaDy5w7UgfOsw1D5tTS0dsIGso/Z3nQWgZi3qLCtkShQmcqyEXY7BDjYLLRgh68WdUIwqqqI9gDyj23n7xqDwR73GN6gOXDPOdPllW04rCs+spXMn97rdLDfcEBnMu0rOiRprg5I6QWZt8sMa5+JwidO35F7FOuWkr7TRBgKbkqJEgzUuJrxni+f8tT1Bf7HDfT60LBr5ERjWFRVwnfENg2xo40dPUeo6K4I/9XWssPO65cXOIKa7sIij2stRxxbttV3l1PvoDlYl2GtRAFo0vAQFgoeMzGgzLMh1p6T6igITSqFLSYy0O3iI9kQ8FdBv/Tt5sMkSuy38thDmPDmp29qnJ0Gx2zSQ/MqrQ8RmM0d/kDkpbCM2FE7AaUaUU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43484467-988e-4d05-0945-08ddd8959c26
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2025 05:12:03.8720
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UCevDbs4vgAvDPtOnxYEjY/fhw8Kj4D4DGVzAPpgA8gMFq6ZIaCGMSPyEToDe72yrDo3jOeL68Sds0WApYj4MIQ9mic75Uvt3jfqhhnG1Lk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6386
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-10_06,2025-08-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2507300000
 definitions=main-2508110032
X-Proofpoint-GUID: iLPYNuFmOPDC60sOiltrqZ3fR6Z43eb-
X-Proofpoint-ORIG-GUID: iLPYNuFmOPDC60sOiltrqZ3fR6Z43eb-
X-Authority-Analysis: v=2.4 cv=ePQTjGp1 c=1 sm=1 tr=0 ts=68997ba8 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=edf1wS77AAAA:8 a=VwQbUJbxAAAA:8
 a=7CQSdrXTAAAA:8 a=3g80flMcAAAA:8 a=oHvirCaBAAAA:8 a=hSkVLCK3AAAA:8
 a=4RBUngkUAAAA:8 a=PtHzh0CglTiZj8iCKyUA:9 a=BhMdqm2Wqc4Q2JL7t0yJfBCtM/Y=:19
 a=CjuIK1q_8ugA:10 a=slFVYn995OdndYK6izCD:22 a=DcSpbTIhAlouE1Uv7lRv:22
 a=a-qgeE7W1pNrGK8U0ZQC:22 a=3urWGuTZa-U-TZ_dHwj2:22 a=cQPPKAXgyycSBL8etih5:22
 a=_sbA2Q-Kp09kWB8D3iXc:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODExMDAzMyBTYWx0ZWRfXx0YOMG3N5+kj
 HVZUy1q/3lPb4c3uqpXtc6TATfFGjBMMubwWPz0rpMfUzK0dFx+Lc21BFbQSto5sVa0Zo6mjoeR
 JvSoJbieCcBfxZVvT4VmQ2p/6oVSLGsHYOfkahWlN9ZsXYhRP17EpG55bOs7p2p+lbvSyd1G8FR
 OTlB8deyEWVG+NyQXuLSnW2oZg5XOMSvwNfuL7BwErSFizw/wgWeB870VwEy7EvH8XY2QIvfY3V
 czOX/bb0sWdpfuGyNaPOlu048fOqUPdRoJCUPIMWUu5jzqA1qLxFKyI1OlOupQaamXnmXAGHKGN
 cdCUEXWy5zCx4KqfHe0o4nQJlYFeOLev9nH1NrCHH6CzpIa0h058I0S1cOA6sWoUY4SYseMEBg9
 9wXWz11WpwOb5PGIcP1KAZZuqtAdSAoXVbBdDZvr7FfIj0Ot8LvcUpleCB+pdnKGeb33/jsD
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 784BB100006
X-Stat-Signature: uqntohkpfemp5fcmx1o5ppfonyop8qck
X-Rspam-User: 
X-HE-Tag: 1754889131-637917
X-HE-Meta: U2FsdGVkX1+kiYcN1haxEjqvwpC+BVyLiT4f2F4r/wtfoquwcqN7Yt0arr0yVSzFr4GxOBg5R4I05qU/6+BUAFJduYfy1hHc6xhvVeTBstOIVgM0jRP6ZzwceF4lq5ta/ctIuCMn+x5JnesqeBKteV0zcE5gTUVYTvPeLvZxHgU9IQ1oF6sr+ZMqHuc6aSTf3ft76jtmPKdwkUForbRo773rPS4eSAcC7dg2Rxvojt+hA1RoAZx87P2wCPFcNSmI5zO+Es3y/1RFa2sYUhHNz0kzRfupFG/SLdxy3NB2VX9LaijAecQAiPIKwRsCjh5ijANo8ixbHiXFG4IbHf1Gms/234NQZskF42uD4dRcswDIac550J3pq/SL6Ik7jxrdfrUGHWC20Bazc/A4EyvyWj8/QlCCA9VcdX6rfO9vyOdcYnDkP+e3HRwPDh9B+AxEM+rqj5QsEeVtR3LN1OCcbfu8r2APJ1l+NM6NQMpK3A1ugi8puP8L4NTXmJ8k2XdQgTppamwCUN4CFezYqe91COXA5asahrh+Ogofrmi/9ljfnftIGXVNA5PYa8VmGPZTt82FJxoZ41WrGDbNLghOu04m5D1AZQWCegYjESNNPRCMCoYP9grKVra3agsqr4QiXcd71bSqreZp1Z9T3AFJOUkoi3zMfQtCcoEmw3HO2BDr+IRvrCm0QWt8cIRtSpPaevxw1MrVFOwjrBG3qQ9oyGs+yMvaUN57ma7KZpfpcusMoYiqomVdLFJUECR9c+TXjQmTfFkpS8y4NZrjtibXrwF6zBt6SahaswGYYZQI3SEedokIfFprtuQxc0kWBcsedVN6KzPk18x3hf+NnOWQYkY5JMlANNEWDiwn1u1nQQlgedBVpncjMXH+cjX1YcCw80Q9lw/5gxsK+pZx6yeEgnVul1nMOerdO1m3sv13RPrwxnzM9MNkJduGgk6uBJCIQIIxzeR5w6aU8d7OX97
 Y8u3oY2C
 LcgBAB0oDYWhcTaMp6dSlcIPUF96j+7nihptePi0nJdQg9opGduQShqs0JwglGEENHTkG+RFwo0yjwDxXB7R3ObP7CQelJIsO7pQsTKyrRCckRZ2tD3w836KpQqkIoEoloHE+hj/zntcppwnHB2wMgIU+3oRak5ayPFBCPbZLAHpeHc9s1zl0nIYOLf5WTuNCTQau17rO3SbQgD7cC89h1kLJXzNTrTxnQhwsnggQs6bjsbLlLswzlJ3IVLF4/QRR+w4I3XMZz2PKNnjGV8rBTkaWc5Veee/PHxE+1p0nH/uksZ80b6+dDN2s5oY0grIsouI973GzounwqGKj8Iqpfxas/Rm2u9d4ZHNGsp8ZQmdS/eFSCD5Y2WbbsxiW3C9Sh+8Lz7JpMJe/l0SjOyyEsZqqr9mL2vQYzsbZxjldM4cSEbCpwlB3+0rT+TtTrZRN8xRCKBmzyr1t7Y7iHEx0RQLahQED5HtdAe7JjZSuEWScNaIXI0b68BtgCAGt6e1M2QNQw0CbpzZpMSnwqB2v9zkWDJoKMdsIFBCoEqR94DXCq5Zp01cwMcyPpV0pRC2HEu+lhTni7wuZj9ehodkMUCKHCPY8M0BqQ0AWPx1L4EvaB1KTbk2ZeEoWxQtS1lm63G/G5skh29qKnFwfq+2zkuB6ieScXZox8khTLuQqcWilHXMtrkej8+g1uH7Mtt7QTNCsu0Os3S2XJXoA7Q3ELsyyOcWbE0GsElpSvMQl03So/IispDj13TAUe4vibXXEZRwtNFiIcwye9k59s2BVtfB6MNPZVPjUKhX9kuO8uxvNVfEXNicSLj9eTraTZBoJpQQTKZdhfBwywX1g3UKTJMYg1Ewud5pk8AJM4Y/fEfhkiq8dzeCNoNGELrPEdkxZ+zKLgOqav0kupB9F/KL9x1nf8il1eFj4Z+Y2ENXmU/03llSqO7VrdwfWxxv4Rvr+DGyi5wG9GZpmurP+gOzzmoK+MrBx
 Io61KXCf
 6VaqzSdQQM0RBX6B+AijlRcRY/VNeN3ySKrNa8or5WZKmneLkdYm49eBhXfTPqhWhlK+612malw1k4A9UPgWUhb/YZPZjI3yuRfUHpLAF7iWITSdtz3AxDVg05P/pkuRgt59nJZaIIXVj44GnDeXFTorAmdmw5xcKz2+McBsBBjwNv3ao415PYwHiiApiLls9bOQDgQdWE8/CEbiQ+vJRpNigD0eK9TeIZ7wUr1AxixS7ncX1SNoVYCnx539nq3tfOp13xYFwDOL4mco20C9cRK2TsZ3n5Hj48JwevJvAuX6HY/CM13aclbGJ1IxBcdamXqFA11sVl2s5kD3Jw1ITu+CX8rC0CtbmJ484uL+LJ823cDl1rvOB0jCFuQs2iyCbpvoAHJWDYUH/yuwh266nSqF9nqDM4g4bk/ha9GHpLo3P4+S7VnETb1Ek70F2nuw8A91mTXIwl6xzp8LSm/PtcI0b8fDIc+z8kKKCzi/EjhfMpCoH7Z3UaLoVi9zC1CNubFkhAU3Vt4ovbpOMwLMhI8vJ+ohwjlrGbQ1gFWlC7Dl+pGWvGqOclEarG6IqlCr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>




On Sat, Aug 09, 2025 at 01:36:38PM -0700, syzbot wrote:
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    0227b49b5027 Merge tag 'gpio-updates-for-v6.17-rc1-part2' ..
> git tree:       upstream
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=1422d434580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=2ae1da3a7f4a6ba4
> dashboard link: https://syzkaller.appspot.com/bug?extid=63859a31071a369082b1
> compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=117c72f0580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17ab7ea2580000

This seems to be racey so as is often the case the repro doesn't repro for me...

Upstream hasn't yet got [0] which is is very likely the cause of this.

[0]:https://lore.kernel.org/all/20250806145611.3962-1-dev.jain@arm.com/

Let's have syzbot test it:

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-hotfixes-unstable

>
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/d0d0622733f6/disk-0227b49b.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/6a993871f113/vmlinux-0227b49b.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/0f07823c6782/bzImage-0227b49b.xz
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+63859a31071a369082b1@syzkaller.appspotmail.com
>
>  do_initcall_level+0x104/0x190 init/main.c:1331
>  do_initcalls+0x59/0xa0 init/main.c:1347
>  kernel_init_freeable+0x334/0x4b0 init/main.c:1579
>  kernel_init+0x1d/0x1d0 init/main.c:1469
>  ret_from_fork+0x3fc/0x770 arch/x86/kernel/process.c:148
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 5866 at mm/rmap.c:2452 try_to_migrate_one+0xf27/0x34d0 mm/rmap.c:2451

Presumably:

		VM_WARN_ON_FOLIO(writable && folio_test_anon(folio) &&
				!anon_exclusive, folio);

Likely the anon exclusive flag has not been propagated correctly because of
the bug in commit cac1db8c3aad (" mm: optimize mprotect() by PTE
batching"), which means if the PTE range doesn't include the 0th page of
the folio we accidentily consider it and pages offset by it in
page_anon_exclusive_sub_batch(), which really does point to this being the bug.

This is fixed by [0].

> Modules linked in:
> CPU: 0 UID: 0 PID: 5866 Comm: syz-executor265 Not tainted 6.16.0-syzkaller-12187-g0227b49b5027 #0 PREEMPT(full)
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/12/2025
> RIP: 0010:try_to_migrate_one+0xf27/0x34d0 mm/rmap.c:2451
> Code: fb 00 00 00 f4 0f 84 35 0e 00 00 e8 f3 41 ae ff e9 73 f8 ff ff e8 e9 41 ae ff 4c 89 e7 48 c7 c6 00 79 96 8b e8 0a 92 16 ff 90 <0f> 0b 90 e9 60 ff ff ff e8 cc 41 ae ff 49 ff cf e9 3e fb ff ff e8
> RSP: 0000:ffffc9000401f120 EFLAGS: 00010246
> RAX: c3d51769d0dbd500 RBX: 0400000000000000 RCX: c3d51769d0dbd500
> RDX: 0000000000000003 RSI: ffffffff8dba5e25 RDI: ffff8880115dda00
> RBP: ffffc9000401f370 R08: ffff8880b8624253 R09: 1ffff110170c484a
> R10: dffffc0000000000 R11: ffffed10170c484b R12: ffffea0001cd8000
> R13: 0000000073603867 R14: dffffc0000000000 R15: ffffea0001cd8018
> FS:  0000555590a54380(0000) GS:ffff888125c1c000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000000000045ad50 CR3: 00000000743ea000 CR4: 00000000003526f0
> Call Trace:
>  <TASK>
>  rmap_walk_anon+0x550/0x730 mm/rmap.c:2842
>  rmap_walk_locked mm/rmap.c:2958 [inline]
>  try_to_migrate+0x3f5/0x670 mm/rmap.c:2619
>  unmap_folio+0x191/0x1f0 mm/huge_memory.c:3137
>  __folio_split+0x90d/0x1c60 mm/huge_memory.c:3711
>  try_split_folio+0x13f/0x310 mm/migrate.c:1550
>  migrate_pages_batch+0x653/0x3620 mm/migrate.c:1819
>  migrate_pages_sync mm/migrate.c:1974 [inline]
>  migrate_pages+0x1bcc/0x2930 mm/migrate.c:2083
>  do_mbind mm/mempolicy.c:1539 [inline]
>  kernel_mbind mm/mempolicy.c:1682 [inline]
>  __do_sys_mbind mm/mempolicy.c:1756 [inline]
>  __se_sys_mbind+0xa3e/0xc30 mm/mempolicy.c:1752
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fb95004e539
> Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 c1 17 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fffa7b144d8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ed
> RAX: ffffffffffffffda RBX: 0000200000000000 RCX: 00007fb95004e539
> RDX: 0000000000000001 RSI: 0000000000600000 RDI: 0000200000000000
> RBP: 00007fb9500c15f0 R08: 0000000000000000 R09: 0000000000000002
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
> R13: 431bde82d7b634db R14: 0000000000000001 R15: 0000000000000001
>  </TASK>
>
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
>
> If you want syzbot to run the reproducer, reply with:
> #syz test: git://repo/address.git branch-or-commit-hash
> If you attach or paste a git patch, syzbot will apply it before testing.
>
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
>
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
>
> If you want to undo deduplication, reply with:
> #syz undup

