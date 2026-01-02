Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21C83FA3753
	for <linux-mm@archiver.kernel.org>; Fri,  2 Jan 2026 16:31:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75E1C6B0088; Fri,  2 Jan 2026 11:31:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70BDA6B0089; Fri,  2 Jan 2026 11:31:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B5716B008A; Fri,  2 Jan 2026 11:31:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 44FE96B0088
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 11:31:12 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E1AD1C2415
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 16:31:11 +0000 (UTC)
X-FDA: 84287563542.26.9240FF0
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf12.hostedemail.com (Postfix) with ESMTP id 667164000D
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 16:31:08 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ZYAWwEEu;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=hG8u9m2Q;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767371468;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ib33ahOKO/C9FAusTdpzM/AU3KEicvkRFp7r3LrNOGA=;
	b=fVSeAj2qzK9xvGqWFzYDoclRtV5zCOF/1/XXsoBjDqSPLtt/zTVeEDkYzb4Vp9F4b0DE36
	s1pVNQbxKscJtvky6pNqUuxvWkiBKscb6j++g5APl4DpoOtHIg3sLH6ot3cEmLRZP9dRYF
	Ht7zURJ25zv26cU8TaAoz63BidQcl9s=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767371468; a=rsa-sha256;
	cv=pass;
	b=bXGXW8eKnCAH00E6kCPd/8mKJLt/0tbGn5p47QLyU3EQFfBqE8FikxdBL8hZ6LHAdotHQB
	tK1ZsmVhjz1NWrgUv5njrQbaDkhutw6KwYx81Gfs+IYbkl7XDRFyvFbl2i9y41Hee84r3m
	5sjLsoDmSNOCfgMLivQRTtrcNyTzMHo=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ZYAWwEEu;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=hG8u9m2Q;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 602BuSAO2954595;
	Fri, 2 Jan 2026 16:30:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=ib33ahOKO/C9FAusTd
	pzM/AU3KEicvkRFp7r3LrNOGA=; b=ZYAWwEEuyTnjznoorP4A/P5Pu+ZLqK9Cq5
	SURXPlJDDIm5Uz8mg8xvta8wKA7VS6d+9IwudgY3XU0H/NSnyk9AgPOfCvrQjD95
	iP71LNMGhJJXG6Rhpay7v4TIei0b5MMRa8DB7KYev+455O9YuDH2rkabIZWq+rOD
	KjiffJtwInxFfTBWF3HMPaFzcrQX8HWACX9gK9hJPFY0G8wPwvJmg5158L5V1b+I
	pHFFjVuBvPDkAGDBfUNxHOii7IrJwevM0LGckcYPi29s+RbaL1lpkUV1IYUq/QMx
	CiQG1HPdmzvV3ypud1i0hzQIW5I3Rda3V/pfCbRyEQqMgbt1PAAQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ba680n89y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 02 Jan 2026 16:30:59 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 602GPCXY034055;
	Fri, 2 Jan 2026 16:30:59 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013023.outbound.protection.outlook.com [40.93.201.23])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ba5wdy9n9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 02 Jan 2026 16:30:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xuZIsU7UeYf4KS//vF2nICR4phqPbgEvMu1yFdXaroVg5ywXAzKmjvz9TlWPyTo+GjoIu4by7QynK60kn5kJEvWmVybYecrS6p2parFeVcRPGfp+W05gdUy4Y+nPr1M5huxV4EXeig+xzYW/nSjp+FxCYB09fMQrNOXAG2R7zvAGasHdz1B6tN2191E2HnwC8Ph04Fo2CqZp3Ag1aS5rS+1bcqgymCVRbE9HSi7UTaJScBpD8/1P6FZD2DkKu6xndRngTGsYvQdz51ZlQgBpKg71B9HTuukv9FX2BKn/GsRBT+4ruCkBf6KJsdUIeEfEb/uVAgNPTdQCNwhnbkEbnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ib33ahOKO/C9FAusTdpzM/AU3KEicvkRFp7r3LrNOGA=;
 b=wUrhpv3+OWL9cM05IygFK8kQ2oYId2rAMY3Ian740aXZ6Uz25FxTYJ8Cw2BpjfdSaPGlI5OzRxO8P36vnX/xy309gbAi81k+TH+yNQOrE+fe4gAxlnojAGv6KBUmjKiqTW9e/U8THqpVtQXDkszgVYqFfcHkyRvOe2JVsAR85crnJQxYMBN7L+ZtMKYCzo+FT/xjB6YSIgSQczRdrq3Na7XQJC4B89inZhxpzwiH2Y+kK8/lo/jThgmtvA93dnHB2Prgqq1Z03u56T9ZmILCIIv7rAokLShXwXKDHGJb3lp4mSuCaFhBoXPpBRp61yNz0XRfED0f7uXOl3NOlZ2Y/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ib33ahOKO/C9FAusTdpzM/AU3KEicvkRFp7r3LrNOGA=;
 b=hG8u9m2Qp5hd5LYlFjlLWc/PAHd4ulozkGikKDMUapPKV8Qxo/+96ArU2pixLZ+BaQaHErNAaQgvzR5eK7LVHOVxYZx4/e+ayZS2seRqjKIAmErS8lXLo/pKpmPnyw6yztTFAKIOee8ywPpjAKe0SaesGH6WAKo36yNBD2TrvjY=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH0PR10MB4517.namprd10.prod.outlook.com (2603:10b6:510:36::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Fri, 2 Jan
 2026 16:30:56 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9478.004; Fri, 2 Jan 2026
 16:30:56 +0000
Date: Fri, 2 Jan 2026 16:30:57 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>,
        Jeongjun Park <aha310510@gmail.com>, Liam.Howlett@oracle.com,
        akpm@linux-foundation.org, jannh@google.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, riel@surriel.com,
        syzbot+b165fc2e11771c66d8ba@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com, vbabka@suse.cz
Subject: Re: [syzbot] [mm?] WARNING in folio_remove_rmap_ptes
Message-ID: <75ba8e22-9f00-489b-989a-373d374244f5@lucifer.local>
References: <aVTJt9M-A1BL8w5O@hyeyoo>
 <20260101130906.839504-1-aha310510@gmail.com>
 <aVZ6b2ri1iRpM-7y@hyeyoo>
 <CAO9qdTEzgQQgV8HixsckHhOd5OgRk=_wRRaRbq4d5wJADMrAzg@mail.gmail.com>
 <794095b5-e9ee-4fff-8e3a-1e6b98e670a2@lucifer.local>
 <dd304877-1010-462d-bdf8-9d824250a05c@kernel.org>
 <9306c37f-bc7a-4a7f-931d-452ef6aad358@lucifer.local>
 <aVd-UZQGW4ltH6hY@hyeyoo>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aVd-UZQGW4ltH6hY@hyeyoo>
X-ClientProxiedBy: LO4P123CA0322.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:197::21) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH0PR10MB4517:EE_
X-MS-Office365-Filtering-Correlation-Id: bcb94e2c-2f3b-469e-59a1-08de4a1c4dd0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?aMLWspd7/hVfZ/zhyqtujmyBhowuoNUJ9THdBqlbO7eXSzSL8tJInhnRpLsQ?=
 =?us-ascii?Q?w9EtL2Hmqw6F9+jMoQRr13qSMPTJn+eZJeAFCHyos4+MDte3ebdIFJ61Heb2?=
 =?us-ascii?Q?m/wC7a5laFjsXwSgHYP5NkZq3qzToOhd7owP6lTLK38jlnradclOel8HnfZR?=
 =?us-ascii?Q?+5Z0Z2zEIvDZxbrJ3G67tS66kawrpBgUi+JUqNmCHgLoX3Ga428KR82thjp8?=
 =?us-ascii?Q?CJsBzV5U9JKdtaz6UH+6+GmVKqQmWQ9rfLQ7J6CRkC5Bae8m/s2GyvNnkW58?=
 =?us-ascii?Q?BFAZzERSrFF94cubPptGGwOR92U13D0bgWdggtNwtbfMC3Vj5YaC2VqZbUG0?=
 =?us-ascii?Q?HnqhKfjoTJuuhOtspgM0EJgPvjE+HObyAgOZ3f3OpppKP+s4d0NTddNj0dpS?=
 =?us-ascii?Q?d2oBzvO9SKxEkzeDEXhpFj/Lh/PcgcY6MnXTC1HdU7kdISDOAECNMn75Rubd?=
 =?us-ascii?Q?SKu2UlUypSVQRm9iBFxQdNn/WIsxS4wauQJACAohyh+dCgizyDtwxu16qMDH?=
 =?us-ascii?Q?M26LQBwAc0cvsjQS9jCNxXEVmps7phlW1U2Jccwpfj/IeVfxbyggwjDM3Ehg?=
 =?us-ascii?Q?/NHhmiRws0cwi/0EdRCDvWXsAUgQRI6c15cNw3g7hpNoh7DKTQaGzGqn18cL?=
 =?us-ascii?Q?GWCauV23Zj317/5L2nQI5aMghhmxXoV4MHqDvMGqR4zHFpS3yExSDqusBFcz?=
 =?us-ascii?Q?XPb414+yPdlicnt3RYbkFyLp2K5zc41qpYYZak6fboVwHQWv5TiRjxt+z7mi?=
 =?us-ascii?Q?/I6Tpl+qyHlNpQO7SC9RJzIIH72VeUkMsh41et/Q+bYyUXS8zaU4Zo1lSDTx?=
 =?us-ascii?Q?HZbHESBt5h5XJ+0a/vs9PC6QsS9/HbfYFAi3rwFySDp2Oo9Fkc+dVJ1GarwG?=
 =?us-ascii?Q?Bc6rtzs1v6A+eKhuLXqT1JAVQb54k1H13vr8+vT/77TarzgWea+ej62BoMli?=
 =?us-ascii?Q?UW02AfW02cX5+hZJYJiH/T3YwpW+oWsffUr0ShXMda7DH2tq3UiYYqZaZCAH?=
 =?us-ascii?Q?RKCqSlmKJZYB/iDSoRYCfG+0R8AVXdL8Y6IZhfwLcv2PWBAk+GdkHYioZRdj?=
 =?us-ascii?Q?VlS9WBEBnHR6KxfDfF5x71pGcgUhixh8z/usb7Y9EWIiLW7v9o7gIYxYLZfe?=
 =?us-ascii?Q?OXKIhoV9uhRq/3qVMOTHxplqolqJ2vqZrTEbFL1NMT2k/Gss5pwPrRauqTh9?=
 =?us-ascii?Q?ox/u+Rmgx4jQcwaqbqU0mKQ1gepCiXlXbtA7NoYGaViG1Hpo3QKtd7EAh/1u?=
 =?us-ascii?Q?TEbZ91zdPdtN/Pefj8JF+eWz7KdvoJWQ5jvbalE8BXnd8EIBIE9iF3hjRyMt?=
 =?us-ascii?Q?FVImP518ZhntD3fwQtPZoTlQADe00h4krGaiEcGc7xcS9Gv4Gu5kELtzwCzW?=
 =?us-ascii?Q?CLQkCL1GpCDbKwgusJTfKwdfx5US81nty/rhPFUm187Stzrkes+qj9IfYns4?=
 =?us-ascii?Q?J7DX7UYgydax5zBcsbXulMhcbiA8bUEy?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?310pdzuv+PIBGfCvHbt5MKrJJeQ25GmbdVrVaWUHokLDmN7om9t/3Rsl31JH?=
 =?us-ascii?Q?e7mgB6JAUBOft4FnbFP0nLUemLxJvYkWvKm3+agSHELnQG9VtB122lT9X98n?=
 =?us-ascii?Q?1cBHoQ3HFCKOMFFwB1hEiWi4wew+uJUu0xh60Bv2BbLPJZCvR/7/6oHg3Fmd?=
 =?us-ascii?Q?lMRzpeUjBifDlim1GWjEHcVUWzW9r48JZiW6cKJXhafcZPynnj3Dqweuj+Xk?=
 =?us-ascii?Q?MDrgAdZBdyT31LnYssCePM/zCYF2/oLcXDqaH1STi1xP4ybd0amsjVWsvkZI?=
 =?us-ascii?Q?dVevAax5FZAQtoxZe/Ja11p4JChuOiW+/WVrdUjRAJOnuc9VPgmBANGab601?=
 =?us-ascii?Q?bJOJ+3EYIGRIJnMWyifYRaljPlJPGeg/MLSeYyKUx771Ra1jTun50vCy5tAN?=
 =?us-ascii?Q?94jsbQXlxkkGyp0bn1Vy6VL8g46z95ZV5KsL5uR6eyRi4yFTHVzNt6t9NePz?=
 =?us-ascii?Q?jFirs9FIF4RsAcfqq6uqzq+DwvhCUXiqvElZON55kX9jVHguglyZfKrQUBa/?=
 =?us-ascii?Q?XDPJA6E49eG3qOxnLECyykd0oX+muyf39awIZVs0XCdluent6kE3idyOvX8q?=
 =?us-ascii?Q?tWE/yfpnIrusps0Jte8egjSE8Us7bZsAg/0hydJ5ozuq8AFwtHtv7GEzrMYb?=
 =?us-ascii?Q?IGt8YjyH8vh/XOJjxQwkoseFGYsUShpls+mpaAr/mBWKnDwudaUUjp8+3cZ3?=
 =?us-ascii?Q?XAcC0p3TLUUqKqJOAZ0Njh/dKZFyhRtdkCIULMpZQz3Ikd0geJgUtd5muys2?=
 =?us-ascii?Q?WbBnQCN3zGqnhCQO/aHW4tRGLm5PtKnfAn2BENdRNbGQ6q57saa0iNpRmMAL?=
 =?us-ascii?Q?yLguFgs6eViQzbotmFRo7ct9aDQ2To+4+GneKvq5ApIG9q4uWAYAU1465y05?=
 =?us-ascii?Q?xFsnDYLQzzPKoRlcvKLEaKN/pbYpZcYczcV3zJr6j23Y3OyHsDSFSIL3/q6k?=
 =?us-ascii?Q?1BUx6pbmDZGMYKpD9O3KWoQLhRZuOj1fUgSefNle4SIhqyZT2fyNHF8AAYQC?=
 =?us-ascii?Q?91rIDtnJwOt5i30661Vp1OoMWh3rXmk2QGaQ/RF+27ddx0AlG4wf5Zd4w3DV?=
 =?us-ascii?Q?aBYFnjMfNENZQq8zYjb2N0XbrYp/XbT5CFnO2Zb82hU/l+MXVI3EA/kNag0e?=
 =?us-ascii?Q?qp17nhVw6UAVXspNWN/8dR5Td4tLqyuBcBVB1Af+p7Ng9PLAqPp8mRnrUrDO?=
 =?us-ascii?Q?U3V6JieWlEKzZJXlq5TlsnjSJlKWEA+pLCfDbuPtpE3SuDEe4Nl7O9oBxt22?=
 =?us-ascii?Q?Qn2xj/Hs//Jn8WLN5aDerd8e+MmRd9y1HOA+TEP+c56l8rNrsaJU1Iei0lH3?=
 =?us-ascii?Q?nwE4QrGegpkXkN2TGpjIAlH1q15lEzW0oo1eJfDnBj/c/Y6qsXQlar9UhKEo?=
 =?us-ascii?Q?mo7VRP1zkFtcLRX3y6/ZX4t1tYb1L6x8vCng0uzTOfMtWlCLst4GATamQYl+?=
 =?us-ascii?Q?q/RY+IjX8D3nNr1UmSysgjOEZdtTDotJ/Ptsa+YISFBjgI5cj9YOWJqOlyCK?=
 =?us-ascii?Q?JzGAglHDaKftP2NIiU+FukmNUPdxhmV3aoXAb+/U9hjbEPdyC558WivhacQD?=
 =?us-ascii?Q?4AzOUwetFEaAlGAojov+x5ULMUTcIkvaZTs8ysF2CVm9BoymnVGAG0Nw2Lv8?=
 =?us-ascii?Q?1u8uhpOOCR48CtB6WYKhZ0rbFUdbMSrsFmV04bIiVzXH700s16v5XtOrkgF5?=
 =?us-ascii?Q?DcWoiqOt7JKhREh0chIzeazGFGENJefNm1hLrg4ZJwjk5suqMJhyzIGWpK4K?=
 =?us-ascii?Q?zo8Wx4yDpS5ZoqeWOBxIe2VSuN2Zdm4=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	1S2OCf92HFA2jLN+1aFDP4C6SdHJKrdTy2sbBjK5U2eeQvrek08hBigIP6c1qOdfQMYkSSCv6b+TnEIFLdvITE8bMHCbDGmhMgX2Q3ymmpYNkbUM4Mcr8/3Uia8YZ471qPtBaAgmO465HkIru9EmZOP0C1Mc1ZzCmrjVk1V8b2N092ygRycKtT6NyakH4+bS4M6KsbSwtdI9WKS22mXr8p+2kToS0F6d+2x9qeRmytns8rh88Uxk2eb6FabcgEXDoJBCV377p7yiFmCKFYIinkcfCIccKrhcswyVKBtTjN0NDZzQjr0rlJ2OUjpC4Gm+mE133KJ5AQe/dz4tRG8GTjYC/+US/zDf8XNlO4+6ZIupB+aw7ibF/CyrbWRuf/OInSNM3r8vBToKChtXLwcfpxdqpc5RyYpj0z9bPM4jwr7HcKYTTlO2LvYtGXa4K2ZRL+HfQpgjLF4DjjWExdhjQjBfA/60sptdefAZsF6tfqxj4zVfMh8EX4QWEOwK4WbEfRMKcjE4UP5T+cGHuNyCfJnkc1cMieXvDOoAczNLwOSF4mQNziO6z5p+5EJCGqIalGAbI4WQLw02YMAwaCSdEaN4zEwUJ++ftoSyyE3je9o=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bcb94e2c-2f3b-469e-59a1-08de4a1c4dd0
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jan 2026 16:30:56.0251
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: COTYisAY8MP8WswH0iM84KqWuoiy0FQtlLhXTJmPEy6KA8nB+uO9wx9t4fBYYDKlOM0L3xTU1IP2VpX8ar8DPnuMS0yOr1DINVeuVvhtOnk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4517
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-02_02,2025-12-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 malwarescore=0 bulkscore=0 mlxlogscore=999 phishscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601020147
X-Proofpoint-ORIG-GUID: -NyHoJJm2FMAE4Rvf5P23PKwc3p3pgtv
X-Proofpoint-GUID: -NyHoJJm2FMAE4Rvf5P23PKwc3p3pgtv
X-Authority-Analysis: v=2.4 cv=HPLO14tv c=1 sm=1 tr=0 ts=6957f2c3 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=YwFO4oDwsqWJ17XbV8YA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12109
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTAyMDE0NyBTYWx0ZWRfX0UeZUt8eMI6e
 efm+3O5A6qUu8drMnRmeyuRhXbhzz3i0EQB9iUQM1cDyUKq+KXDfusKxFCSu4KUVghHfIAaCMwO
 LppBvyLOZLPF//vxopRQukwA0i+aV36N+HpD5rHIwpAybuAwK6EwKkpvoLDVd+Pr8LCMecjeDJa
 rUtB8w7YcVzYZg5N/pNhbpznJJeetLBu8cs9lfM+RVxTnxdWePT1pY1e9xIY99V2A8t23OyrmPE
 JTsVYGiz1jz8vhHDjDYK0tIefTXG+Xqd3MXGbNwPWeStLOzy8I2T438DSzvjg0DUkUxh3jrvvtM
 pZYZrCtAJXbdDK4hsZT03FB2CNUY8sO8NCPJkvHpELYUWq+Jl7ldlPHuJSGzfWYTGhKkV0g5KKj
 0OelEJiyB/0e0Z25kuMntM9iU94lq6CwVh4KWs92j+hUXvk14U96S1p8PV/6ag0QM+01GVedb1D
 K9g8hdiZYHpBp7zF3neuZkzA9QCCoVrAx98sYPJg=
X-Stat-Signature: zjxxcifrhzqsopfegkprmkq7mdsexore
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 667164000D
X-Rspam-User: 
X-HE-Tag: 1767371468-404728
X-HE-Meta: U2FsdGVkX19sUkl+rwiL8IuiFuHFaWbubfrymmflOyxXIf+8fAe57EHecvmLwQ8XItQhcMG1LFM8Vw+kZVCn0+Br5OhnoIT4krMEKxS9NmRuVmoGt12jlx9/DUUDZR8xMAN/tQRLFuX1mYTVui+jIfTSlb6It+nYcmZyajt3h70MpgBUtsrX2+flKiivgca70YYYDzNPdsjbqSzY0Qo4jnx9e6vImkw8s8d17PjiixS15WivlrPCQcNYQS5bqxUEIPwq2IHldEoISf4iaYlN6dJMBbakCoVaKstw+R5YbtcNhKK2y+f/XBSy34H8vMF/v4emaFvyF74XN6NRANUUM7HqN61c3opAhfkyOyV+gBUfYK3ZTRDzaGVuqHjmuFRUVTheUyzpJeft+VmfnOQINS4jJYHkTacMZLyf/+D5Ua1h21/Omza0meElJXdKeTMjuZov0BD1vjWEMEg4XP9ZsFhOrVj2b+DSGjseayzoSYSmckDp9RnHQMLgPvsWze0HGBF7d6ENjjUUFiPgfrE+HvbFOsFZD25u7HyLWdEOh4TeI3Agl+Ws9ds5SD8I6GiBtUSzoRPWea+eSl5a+DKjBbYAgkGj2SvB4h5YdwfQ2LW4MZtyoCvTMv90Obs8J201xCH7jxn3/q4rX8OAjXJD0p6idr1P7ADtHUS4BlRpzVaYiIaJMdKA3mOyNHQE1zznolfm1fIaQQYssk70B/uTTjMidnYPRvmShfDWHMJqXEE73tXYfVm82WmewruJYYt0tg73wimWXgFZUwbwr2vIVG+0yLzkKubJbmT8BEPhKlkoKK3jxMReaUVJoRWPyS6b4xClHhK8gId4A1Y7AXNZRJj/3M5USsI1y/aTrPM0wNy64pjEZaUYAei70gyadWkUDjOzJzvmLC53xzDm5qy5l0e7W8nVGbWJjEizonzFCykJa4SmIAbYJWdXG4Jkcon7qr7tQH+cD4YvPhx0ree
 Dx8EWwyV
 sA3FE1yGsvjLFcrBmWPFTv2IORhVGSCV3gvkGKvWhaNejJmII607yS0f+PgSYe25HGQYg1mld7qZfwD69IMG6P0h1J6OSadrTQ0Vs6ETpqxnmlPPVQqC+tjOu34fprxMJVMXvXGx4g/EHNZmuRf7syv/CL1iuv2dxnD44Wgx4hZg6Rd3XoCOoCBicuahYgepctnZuoMiaHCG4Dgb4epLjBKtg1g0uSFQipssbcRjgq4LiC/gctdx+O/vwrzDsrMEtumcPA811iGthn3sJ5MqRJOQiAbGi5pjnhms7J7oQd+07RAqnXTE3ESy4YxfNUmNvZZvM9wc/RWQAjbQenrAALznX2KXuKE3qpc4fRGWjhdQ/cNWKuZPnDYLS72QJIU79CKe0aw5+HLvOuC0j3535kBNVhsRyGuS7HCDTkeaWRNTI6uWn6SUpdLTFSnvILiW0OIlL1ibMnm2touLrdcUlNPJrz80zeS2+4VyjUp8fgd0q45FrrTerNxKfWt7LZgxQIkjI3YElp0/RcbbbBpuQaPjx8boNf17+JDLYDV8a9j8ONy7GiNYR3PQARkYFzg80eC9d+m2JFdWBlT0zOmVab7DD+2E+wT4dHg3u/Ij//3KelnA0KfJfn/JntRl6IzcnW9PA26l91qzU5Wt7M6DQCOzDNYPskn/Ve2bY5ghp07GSAwY+qnUa5J2jRdtoaL7MJE0nep6qIBDDgLdwrb3yDVUSHYyMkYQ4ScqAtt82D2vYVns3S0cxHPmXEmiJmeaivlCoZ1hKyW6riwSwg+k8LApXl75copWOWny9DUJ2nYGR0/u0sXjY8OwXdg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

OK I have figured out the issue. Big long-winded explanation below and rough
patch included ONLY for reference, I'll send the fix properly once I've figured
out a less horrible repro.

This isn't a product of commit d23cb648e365 ("mm/mremap: permit mremap() move of
multiple VMAs"), that's a red herring as it seems it's just what syzbot needed
to trigger this (as well as Jann's assert obviously).

It is rather commit 879bca0a2c4f ("mm/vma: fix incorrectly disallowed anonymous
VMA merges"), another of mine (mea culpa!) that seems to have caused it due to a
really subtle corner case.

We initially set things up like this:

0x200000000000                                                        0x200001000000
|---------------------------/\/---------------------------------------|
|                                anon                                 | <guard VMA>
|---------------------------/\/---------------------------------------|

->

Then we mmap file0 at 0x200000ffc000 for size 0x4000.

First we unmap the existing:

0x200000000000                 0x200000ffc000                         0x200001000000
|---------------------------/\/|                                      |
|  anon                        |                                      | <guard VMA>
|---------------------------/\/|                                      |

Then map in the file0, having split anon:

->

0x200000000000                 0x200000ffc000                         0x200001000000
|---------------------------/\/|--------------------------------------|
|  anon                        | file0, no uprobe, unfaulted          | <guard VMA>
|---------------------------/\/|--------------------------------------|

Then we do the BPF shenanigans to install a uprobe in file0 when touched.

Then we mremap() [0x200000ffc000, 0x200001000000) to 0x200000002000.

This means we first unmap a region to fit it (err sorry diagram not to scale :):

->

0x200000000000                 0x200000ffc000                         0x200001000000
|-------|             |-----/\/|--------------------------------------|
| anon  |             | anon   | file0, no uprobe, unfaulted          |
|-------|             |-----/\/|--------------------------------------|

Then copy the VMA over, and since there's no page tables to copy, both the
source and destination VMA are basically equivalent due to MREMAP_DONTUNMAP:

->

0x200000000000                 0x200000ffc000                         0x200001000000
|-------|-------------|-----/\/|--------------------------------------|
| anon  |file0,!u,!f  |        | file0, no uprobe, unfaulted          |
|-------|-------------|-----/\/|--------------------------------------|
        0x200000002000
                      0x200000006000

Note that the MREMAP_DONTUNMAP means we leave the file0 as-is since it's
unfaulted and no uprobe so no page tables, nothing.

Now - the repro isn't very clear (to say the least...!) but note that it makes
it possible for these mremap()'s to carry on in the background while other
things happen.

After this, we open then mmap() /dev/comedi3 at 0x200000ffe000, which overwrites
the latter portion of [0x200000ffc000, 0x200000ffe000).

Firstly we unmap the portion we are about to install, which as a result, causes
a VMA split. In this mode, we create a new duplicate VMA of the file0 VMA, which
means that when __split_vma() calls vma_complete() it invokes this logic:

	if (vp->insert && vp->file)
		uprobe_mmap(vp->insert);

Which faults in the VMA:

->

0x200000000000                 0x200000ffc000      0x200000ffe000     0x200001000000
|-------|-------------|-----/\/|-------------------|                  |
| anon  |file0,!u,!f  |        | file0, faulted in |                  | <guard VMA>
|-------|-------------|-----/\/|-------------------|                  |
        0x200000002000
                      0x200000006000

We then put the /dev/comedi3 VMA in place:

->

0x200000000000                 0x200000ffc000      0x200000ffe000     0x200001000000
|-------|-------------|-----/\/|-------------------|------------------|
| anon  |file0,!u,!f  |        | file0, faulted in | comedi           |
|-------|-------------|-----/\/|-------------------|------------------|
        0x200000002000
                      0x200000006000

Now, with the background mremap()'ing going on, we might end up triggering the
multi-VMA move logic, which will separately move the file0 and comedi VMAs.

Note that this is not necessary to the bug, it's just what syzkaller happened to
end up using.

So if we at this stage mremap() the range [0x200000ffc000, 0x200001000000) this
will be executed as two separate moves - [0x200000ffc000, 0x200000ffe000) to
[0x200000002000, 0x200000004000) and [0x200000ffe000, 0x200001000000) to
[0x200000004000, 0x200000006000).

So we start with the file0 move.

mremap() will first unmap the range prior to the unfaulted file0 that we
previously copied:

->

0x200000000000                 0x200000ffc000      0x200000ffe000     0x200001000000
|-------|     |-------|-----/\/|-------------------|------------------|
|  anon |  ^  |f1,!u!f|        | file0, faulted in |     comedi       |
|-------|  |  |-------|-----/\/|-------------------|------------------|
        0x200000002000                   |
           |  0x200000004000             | to move
           |          0x200000006000     |
           |-----------------------------|

Then it will do the copy, and try to merge. A merge will succeed, as the
unfaulted file0 and and faulted file0 are compatible - very importantly, as
these are MAP_PRIVATE mappings of files, the vma->vm_pgoff offsets will be
compatible even with the faulted in 0x200000ffc000 VMA.

If these were anonymous, the vma->vm_pgoff would not be compatible.

They are compatible because of commit 879bca0a2c4f ("mm/vma: fix incorrectly
disallowed anonymous VMA merges") - the source of the bug AFAICT.

They're compatible because of case 1 in is_mergeable_anon_vma():

	/* Case 1 - we will dup_anon_vma() from src into tgt. */
	if (!tgt_anon && src_anon)
		return !vma_had_uncowed_parents(src);

And because the _new VMA_ merge will treat the 0x200000004000 as the target VMA,
which will be expanded downwards to perform the merge.

The merge will be performed by copy_vma() via vma_merge_new_range(), which
ultimately invokes vma_expand() (big credit to Harry for honing in on this!)

This logic contains:

	if (next && (target != next) && (vmg->end == next->vm_end)) {
		...
		ret = dup_anon_vma(target, next, &anon_dup);
		...
	}

However note that our target _is_ next.

So we end up with a folio that points at the 0x200000ffc000 VMA's anon_vma, and
the moved VMA does _not_ have 0x200000ffc000's anon_vma pointing at it at all,
there are no entries in the interval tree from it to the 0x200000002000 VMA, nor
does the 0x200000002000 VMA have its vma->anon_vma point at it.

So in the dontunmap_complete() function in mm/mremap.c we invoke
unlink_anon_vmas() for the 0x200000ffc000 VMA:

	if (new_vma != vrm->vma && start == old_start && end == old_end)
		unlink_anon_vmas(vrm->vma);

And this function methodically goes through each entry in the anon_vma chain of
the 0x200000ffc000 VMA in two cycles - first removing interval tree entries to
the VMA:

	list_for_each_entry_safe(avc, next, &vma->anon_vma_chain, same_vma) {
		...
		anon_vma_interval_tree_remove(avc, &anon_vma->rb_root);
		...

Then, if no interval tree edges exist, we leave it in the VMA's anon_vma_chain
list for later processing:

		if (RB_EMPTY_ROOT(&anon_vma->rb_root.rb_root)) {
			anon_vma->parent->num_children--;
			continue;
		}

And note this _will_ be the case here because we did NOT invoke dup_anon_vma()
and did NOT install any interval tree edges pointing at the 0x200000002000 VMA.

Then on the second loop, we will put the anon_vma, which has a refcount of 1,
which means it's freed:

	list_for_each_entry_safe(avc, next, &vma->anon_vma_chain, same_vma) {
		...
		put_anon_vma(anon_vma);
		...
	}

And thus now the folio faulted in for the 0x200000ffc000 VMA has a pointer at an
anon_vma of refcount 0 (it's a SLAB_TYPESAFE_BY_RCU object so until an RCU grace
period can still be accessed with this refcount state).

And thus we trigger Jann's assert :)

So taking a step back - it turns out vma_expand() is _only_ invoked in a case
where it isn't just expanding a prev VMA in a situation where there might be an
anon_vma to propagate when copying a VMA when performing an mremap(), i.e. via
copy_vma().

So what we need here is to actually keep a track of the VMA we're copying from,
and dup_anon_vma() this in this special case (since the duplication logic needs
access to the old VMA's ->anon_vma_chain).

I have code that does this, and it fixes the bug.

So it seems to me therefore that commit 879bca0a2c4f ("mm/vma: fix incorrectly
disallowed anonymous VMA merges") introduced the bug, as I didn't consider this
very subtle corner case.

I am working on a less horrifying repro, but I already have a patch to fix this.

Which I include below for reference (against mm-new tree which bizarrely still
doesn't have my latest anon_vma work in it). I'm going to try to get this better
repro sorted so I can add a test or at least reference the repro.

Once I have that sorted out I'll send a proper patch. Not sure I'll catch the
next -rc but will highlight it's urgent.

The uprobe being invoked like that after an adjacent unmap is err... strange but
I guess maybe what we want? That's something else to consider anyway.

But one thing at a time, we need to get a fix out for this ASAP focusing on the
anon_vma bug, so this will look roughly look like:

---
 mm/vma.c | 55 +++++++++++++++++++++++++++++++++++++++++--------------
 mm/vma.h |  3 +++
 2 files changed, 44 insertions(+), 14 deletions(-)

diff --git a/mm/vma.c b/mm/vma.c
index 7c712e0be28f..56bb46a2126c 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -1135,26 +1135,47 @@ int vma_expand(struct vma_merge_struct *vmg)
 	mmap_assert_write_locked(vmg->mm);

 	vma_start_write(target);
-	if (next && (target != next) && (vmg->end == next->vm_end)) {
+	if (next && vmg->end == next->vm_end) {
 		int ret;

-		sticky_flags |= next->vm_flags & VM_STICKY;
-		remove_next = true;
-		/* This should already have been checked by this point. */
-		VM_WARN_ON_VMG(!can_merge_remove_vma(next), vmg);
-		vma_start_write(next);
-		/*
-		* In this case we don't report OOM, so vmg->give_up_on_mm is
-		* safe.
-		*/
-		ret = dup_anon_vma(target, next, &anon_dup);
-		if (ret)
-			return ret;
+		if (target != next) {
+			sticky_flags |= next->vm_flags & VM_STICKY;
+			remove_next = true;
+			/* This should already have been checked by this point. */
+			VM_WARN_ON_VMG(!can_merge_remove_vma(next), vmg);
+			vma_start_write(next);
+			/*
+			* In this case we don't report OOM, so vmg->give_up_on_mm is
+			* safe.
+			*/
+			ret = dup_anon_vma(target, next, &anon_dup);
+			if (ret)
+				return ret;
+		} else if (vmg->copied_from) {
+			/*
+			* We are copying from a VMA (i.e. mremap()'ing) having
+			* unmapped the target range. If we merge into next,
+			* then we must ensure the anon_vma is correctly
+			* propagated.
+			*/
+			ret = dup_anon_vma(target, vmg->copied_from, &anon_dup);
+			if (ret)
+				return ret;
+		} else {
+			/* In no other case may the anon_vma differ. */
+			VM_WARN_ON_VMG(target->anon_vma != next->anon_vma, vmg);
+		}
 	}

 	/* Not merging but overwriting any part of next is not handled. */
 	VM_WARN_ON_VMG(next && !remove_next &&
 		      next != target && vmg->end > next->vm_start, vmg);
+	/*
+	* We should only see a copy with next as the target on a new merge
+	* which sets the end to the next of next.
+	*/
+	VM_WARN_ON_VMG(target == next && vmg->copied_from &&
+		      vmg->end != next->vm_end, vmg);
 	/* Only handles expanding */
 	VM_WARN_ON_VMG(target->vm_start < vmg->start ||
 		      target->vm_end > vmg->end, vmg);
@@ -1823,6 +1844,13 @@ struct vm_area_struct *copy_vma(struct vm_area_struct **vmap,
 	VMA_ITERATOR(vmi, mm, addr);
 	VMG_VMA_STATE(vmg, &vmi, NULL, vma, addr, addr + len);

+	/*
+	* VMG_VMA_STATE() installs vma in middle, but this is a new VMA, inform
+	* merging logic correctly.
+	*/
+	vmg.copied_from = vma;
+	vmg.middle = NULL;
+
 	/*
 	* If anonymous vma has not yet been faulted, update new pgoff
 	* to match new location, to increase its chance of merging.
@@ -1844,7 +1872,6 @@ struct vm_area_struct *copy_vma(struct vm_area_struct **vmap,
 	if (new_vma && new_vma->vm_start < addr + len)
 		return NULL;	/* should never get here */

-	vmg.middle = NULL; /* New VMA range. */
 	vmg.pgoff = pgoff;
 	vmg.next = vma_iter_next_rewind(&vmi, &prev);
 	prev_start = prev->vm_start;
diff --git a/mm/vma.h b/mm/vma.h
index e4c7bd79de5f..50f0bdb0eb79 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -106,6 +106,9 @@ struct vma_merge_struct {
 	struct anon_vma_name *anon_name;
 	enum vma_merge_state state;

+	/* If we are copying a VMA, which VMA are we copying from? */
+	struct vm_area_struct *copied_from;
+
 	/* Flags which callers can use to modify merge behaviour: */

 	/*
--
2.52.0

Cheers, Lorenzo

