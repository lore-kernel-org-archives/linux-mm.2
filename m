Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C017FC87FCA
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 10:05:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D08D6B007B; Fri, 25 Jul 2025 06:05:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 581916B0088; Fri, 25 Jul 2025 06:05:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 449636B0089; Fri, 25 Jul 2025 06:05:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3466F6B007B
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 06:05:23 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AE7F01DBAC3
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 10:05:22 +0000 (UTC)
X-FDA: 83702354484.22.A42528A
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf24.hostedemail.com (Postfix) with ESMTP id ED731180012
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 10:05:18 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=e5lnG4gN;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="LT/9MGxV";
	spf=pass (imf24.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753437919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RG1MWNC2RJMcKM4ehTOlV+1CM7EtHP+efLJj2KEaMc0=;
	b=RD+/WiJxd6n//gcbUGooaiUiBsBPkErCCi2K1JAe1PYJwJa+dxgPGFIDQL9dOkKlyySCe8
	n+SPQHsfaygyYxchhjv2GSHoFXsEmASFvfcNCU1RvupW1UXwKzqw5Gt7jfKyiCZRHyjRV6
	WQGtxh5rpx7c3+MPWaALocNawMrsmVE=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753437919; a=rsa-sha256;
	cv=pass;
	b=nYdAdwX3d5J4NPuAXa2+jUP4hh+9zZnwtj5dnXM41ehSRYXEGQOqLOUJamvDnq5gY3lrp4
	D/izlsQ+ypuQTkm89uXa0inNC09vPVbj9c1XxXx0QH+npIAVGXQo/+nKHFvSruP2XXbv8E
	W+FDFPrqEJIterlHhPrI/kDwf+uOmwE=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=e5lnG4gN;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="LT/9MGxV";
	spf=pass (imf24.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56P7fsJE005951;
	Fri, 25 Jul 2025 10:05:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=RG1MWNC2RJMcKM4ehT
	OlV+1CM7EtHP+efLJj2KEaMc0=; b=e5lnG4gNbmRq1LFNxx3bl9Ta1uXyPvlsl0
	+Jyt8r7nrmPjq3SYFCrbykCMrcYLM1D5KtYqo9zskMw03cbw0dqzYhQQlFgJLtTo
	4J1UiMHGf9RJvAH4eHOOfH8+/AFgfESS26sGhp59GEtvu09FY6/8xfzIcF83jG4K
	XWsPYgoi1E4scrFLFp083mPMbXz6xZovfAot9a7l6E/uuV3IqAo5CBbTFV8TbXj9
	qhPkzsJiWqBvCcushIGMVxeNijMb2CDJUwS/EMLG+xhLtFApBq6ylRCNG3VOTp9N
	ei+IINpY3DqPCZv5VMr0GTJFPthzZ3BCKiOY12+lg0e9C1738Aiw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 483w3vgs7y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Jul 2025 10:05:14 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56P9cBJ6031494;
	Fri, 25 Jul 2025 10:05:07 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11on2074.outbound.protection.outlook.com [40.107.223.74])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4801tk868y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Jul 2025 10:05:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NlEuiu5Ov3p1U58P2rDzYDmKFLC5YT65Sdapa2jmWg7NrCMohHUNU5dibg3bXHT8/gE79PsteUdgb9e9n4y9Sqt9iUnpiIdppVBJXFTTerjZMtgZNfVS9gW2fSBq6puhIPxn9ezGepMW3I0YCbBAEoVdNPGiZKE5LawbOGODsfpQxXBgoZ7Dv86HPjj6t7pvmU2YZQSzyBV1iv1PK+H2UtbmGD8g8/PIC2jJFgJn/v+2o1GfETOUhy2Na0RZCP6jTeNgiLi+gGg1z6vmUYKlBT4APoUbBGZuP0aVf7MYz5oU2QDg/WAgfnTJdl2fj5vaTm0bYeYqj37/C+YPwA8jGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RG1MWNC2RJMcKM4ehTOlV+1CM7EtHP+efLJj2KEaMc0=;
 b=H3Unh2S0YD7yQhctvxNpOTdRjMQBdF4YKXoU2xERg5Wul+TjntNX9ZiP2MHyHKNy4W8TUqDxHpjMKjPtzSzublZLRTWE53Kp+n/FIJj8F8eRSZikzopgd1vEmhtd+O2uTrvAumoMVfMSaeEBILuKj1cSedRQ6BjDtWNhQnUg9+DCoHPpv4g9NHXbrVHWJAC9koOt0dXp3hCEH8KIRbqLsDB+2nsMOl43eZHMu2BwWvIhThhgZYx4kx4TKgYpv8uvtjK9gmriT7PS7sK9vCeb1H1WDGahnZBtvB6zu+HYq4RKxnJsPWlGXZGQkZUlrat8vXDYdagiSuzluSkq1vgG5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RG1MWNC2RJMcKM4ehTOlV+1CM7EtHP+efLJj2KEaMc0=;
 b=LT/9MGxVDNs8DAUQrLsO1ccWdIx1fOjiYKeniINnZx7XJMcZUiG1IED/GJ8b0mxyiwFwv4/Rcl+MOB/IMCIAg2NqJ2zAiVFoqofwUfKIUB0uuHO9ZLzkcC7Tr9BOzOhD8RYNcsfADwJMYSQ3Fja8tUVhbXpfK8lej475pDfNT7I=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by IA1PR10MB6781.namprd10.prod.outlook.com (2603:10b6:208:42b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.24; Fri, 25 Jul
 2025 10:05:04 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%3]) with mapi id 15.20.8964.023; Fri, 25 Jul 2025
 10:05:04 +0000
Date: Fri, 25 Jul 2025 11:05:02 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Jeff Xu <jeffxu@chromium.org>
Subject: Re: [PATCH v3 2/5] mm/mseal: update madvise() logic
Message-ID: <d055173e-233c-4513-ab40-d7a10a0b81c9@lucifer.local>
References: <cover.1752687069.git.lorenzo.stoakes@oracle.com>
 <ec480dc1fd4ce04bb11c0acac6c6da78dc6f4156.1752687069.git.lorenzo.stoakes@oracle.com>
 <4f66d89a-631a-43eb-b4f9-c9a0b44caaae@redhat.com>
 <692f9624-e440-4cf2-8202-861c679ddb73@lucifer.local>
 <0ad414a1-9a57-4050-a7b6-fdea08aebbd1@redhat.com>
 <507a09cf-291c-4886-92e7-9d9cc294a247@lucifer.local>
 <aa839e3a-11f3-49e1-8c3b-a60106c8d165@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa839e3a-11f3-49e1-8c3b-a60106c8d165@redhat.com>
X-ClientProxiedBy: LO4P123CA0038.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:152::7) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|IA1PR10MB6781:EE_
X-MS-Office365-Filtering-Correlation-Id: 992b411d-cc21-4462-4ef0-08ddcb62ba07
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4yVTVvrXXOGLsPFp91qRthxrVieEscmFERdrPI2LFHO11DuBws0xO6a9tlah?=
 =?us-ascii?Q?GAm3LUnZ+TmXASbFUp31+UV5nFIhfbyelI0/5FfwuHMMPFGMqG6/yaMnq2f5?=
 =?us-ascii?Q?mzGSjQhTRlmZivCqd39CM5O8skeyrmGIrfbE12UV2TVCZHz+RXD5YEcBOOV8?=
 =?us-ascii?Q?tFotWpzeJ4PwzxqQzK5u+xC+HAknBbZnzdlY2dOd9pgmGiI5nU62i34ijSnk?=
 =?us-ascii?Q?OOu3ok3nlfE/ay3RUVEtOEUoykUbCuuTKZr4blpdLl7ceW2XyXJ+oVhAlEjF?=
 =?us-ascii?Q?Rj3yQBd/dzHD03dWozrEP3hkr9gcFCkx8PYtXHwSU+4W9nzFND3RRMo9zNOo?=
 =?us-ascii?Q?i+huTWjO4fr/5Iq4aUICcGV0ZFq3B405EbuHk414lMR/HtoMBF+1gU6TqOi8?=
 =?us-ascii?Q?V4LxwAkXaL+eSm0vbhQvTDvdAbplR6QmJsthd3kRAGgG4NKBAy2pKf6eeDMN?=
 =?us-ascii?Q?FQggF0sEIlXwGdOjezlFyKYYumDyqGGnqezVUcTJOGy0pkgUVX7gdajeiTiI?=
 =?us-ascii?Q?t7oaV9Mm6GdL78nJbrnIi8qTx64syGndNSJTxgaPFGDCFxRtPNTMj/6DcOFz?=
 =?us-ascii?Q?hTEnUQXJvV363Nk2Plh/fdNcx/dQZE7lQolpGnyySlVglYYpf37W7oOtWKDo?=
 =?us-ascii?Q?H14R0rHjg19cnnShWnJxIOm1kWAs7b2qyHO+Gi0STMWafvpgmf55BVDo7Osr?=
 =?us-ascii?Q?yxpU6pQ/6P1xp+cvE8PP8M0Tx3yE2WwIZCBrSCxotIX3XfsWr4vMHVgLaMmB?=
 =?us-ascii?Q?W/oH39gNzeRWrYcCTM3lxIwlBljYaGLPjRaxVB2GDG6Gl/mdCxUZlg0b+ksA?=
 =?us-ascii?Q?m68pje8xQgKIq3D/Aw0XHUCWJ/BKYjqCU+5EWsJU1a6RjUCaI61D80nb/IcK?=
 =?us-ascii?Q?x2PpUfSSy4EY1lZeDKCS6Cgcpl04OFyvZWr5ztQJSfZdTK1TfgFyhy145FZ4?=
 =?us-ascii?Q?nDpISfDyN2fFNE/y7m0l7UyjhUn/J9iJjc4c9VEtSQfe/RrnMELzUpszQDj9?=
 =?us-ascii?Q?Trb5RAjZW07nqSKO9vDGmQbD3Jn4fdQ2/qXClQW59KHriy28NjIE90ajWT20?=
 =?us-ascii?Q?jJSFc8mHhYP1p4d5VIxsN4haDzTer9LhLqhb1zbkGt0SrCV/eBkIfuzMu90L?=
 =?us-ascii?Q?rg/KbCmShxmCnOf3nY6v/Z8B7Jcd1jK2lLBjA5ayXnMXrqby+mxTZRvHX9OF?=
 =?us-ascii?Q?9lay7uPamBp13N4bTUUZZBrHJMcMtRQnNyxt5A/Xs1f2wPrKJqCh1QF2Awkb?=
 =?us-ascii?Q?m/p1RikCxS/4wMdxr1QyjMtl5ApJjAl5I6fc//MY5cE+NvH030NcJkPy42CR?=
 =?us-ascii?Q?hLeg8UCoH93T/BcNzF9Ur/YWDA8c4DcDQ1buozpfm856dcLh5QvyKaXwy8BJ?=
 =?us-ascii?Q?IA6+ssTWhpSf+gYJmafdaltWT4l/m8pxf0GWl00CroYCyXLg8dRZ7dQXckq8?=
 =?us-ascii?Q?bpv1bEyMSlk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?tnCMJ7HSXHp0bShyImhlxvMBYEayx18dx0vZBOrK9hp6MS7cTrusycBtOH4/?=
 =?us-ascii?Q?Jyfux7qIEQJw9J+c2Dy0KNIQ4nEF6IQMtT49LGGEdLF4S7UsphX6NBvs4yaA?=
 =?us-ascii?Q?5oE221+s4cy0MWzJQ5uife1hgkqJizYNZ6qdkW2e0r0YHR0YVGWClo4TcSHO?=
 =?us-ascii?Q?lZFzObhBbb6zOzHogC1nhwDu054PBRIf0YSp7D7FGC0KZCQuy9XkSmyN+bF4?=
 =?us-ascii?Q?L0MpU4o7+7EXLScH/NDLNx5SqCJ8tN7w+Lph0/GTfqV9CrI9sUCHUJbfA6Nj?=
 =?us-ascii?Q?FrifZLDr2oDtPot5zdg9D3bm/m3t3s4WgV278MolYEr6EM7GZhm8NkFpETSp?=
 =?us-ascii?Q?cIvnSbqZj8J7IcIK7fe/9nIyuOOwl0TBB1G4MEefh1WwKVQBwTv3dk+2jHBO?=
 =?us-ascii?Q?FAvdrZ/a7uhn4m53SK5KBxr9ZXL91+WyISEAII+89JGBuze+MaQFM3kDma7m?=
 =?us-ascii?Q?kXsVZ92aa7dWBZLfpv0aMOeCScXm72deu2+t07gmLYTf+4pKYHGXOIfgRhzw?=
 =?us-ascii?Q?hTm9H6On34iz3JFiBNbME2U5jbaoQBg+FvRRj954m48sdXyVJneVSBERywnu?=
 =?us-ascii?Q?W62JUDFWylRZo27uTq4gF3OyfEKorjewPjCQWoGFb7xBckjYt2fglT+HeuLC?=
 =?us-ascii?Q?6mxGvpgUN1rUMl6CgBiPpOJEmJwnjaOlcK5EZXQoH28ifqCc/MQ56NSzntso?=
 =?us-ascii?Q?/6rWHW/dpaPuB5mWgw8Qf8BbvaVUd+AjW5PkuM6K4nYge/j6a1OC9ibFTNNk?=
 =?us-ascii?Q?nzMcSvoQ6tcyr/DBbZ6hwUBoonr9r+6NfRXlxVCvi6L/Ctwsg0WnZosL7QbF?=
 =?us-ascii?Q?R6pon5nPQpMD2RXWg3bAaCg9E2pmm9HFTQAVgwER4hZPt0JDWpCosNAUkKcS?=
 =?us-ascii?Q?ZLJh0gaszeMotfsAkiJUpq9nOXiUmHydnXGTCaQGYqfBqfqU7BpoWq8brC8i?=
 =?us-ascii?Q?GmakundH25+IdkLZm8FJhEFJ+YRjE2DTTtKmCju2PMnTuuCnbX5j0fe6eIim?=
 =?us-ascii?Q?FM660W4KeddQElAFub5ystMs0f8N5qv/B3w2ntjsoD3XYM71t7ruVbhyhPjm?=
 =?us-ascii?Q?6gunhAwc0HdveC4a3tRW2onuG7LTY8TpsehDAymVCOTASnh5vpPRGaSPmggV?=
 =?us-ascii?Q?JJwpGWFTlRcmtTkRJM7gztNlGowT8R15CE/qRV7fU+G61wlVKkq00cuYcI4N?=
 =?us-ascii?Q?SiVRItGFTamwYqODxKIDx1lCOuDYVCPPewYya708wLZSE5wjZR8ZDlZm50zX?=
 =?us-ascii?Q?pMJ5RU+qG1HQymtAfwRIL5pwoEPpnviD28Tk7N0IvaO6hId/qodOHyg0edmv?=
 =?us-ascii?Q?MyGuSvBxINLRJtXtMD2sRP+c4CSmj28LwLX9Bfcjg6/HwegzjJT4DfRrfbNE?=
 =?us-ascii?Q?/doQVn9FDdwU25A2aV9YiSpwvJ8jS+kWqqH1d7smXgj8FIskxJc7gs0EcIC+?=
 =?us-ascii?Q?SYXf3ho7PEkw+AY+eObxvYH0AxVJKwh0VMIiPCix99bg1LhE7oCV+Gbq3X3c?=
 =?us-ascii?Q?36OHlOO0bG/jGsiG3nfY65jjp6U3o5OurixI8yd4xgRqnb07qE7JntFBXckA?=
 =?us-ascii?Q?YTYH86bCSUW6DVurGW4LcXtHKTOm+vfGRKeVwR26T5Zn9oqzGLvtDKHaigYp?=
 =?us-ascii?Q?zg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	QaAOg9h7vEloQ6tjLjwEuWr9JBUy8UpmEw6vr+IWwuujaRv5wrCjvs6W7ZllWlqRXQ9NngoIGCL61Le81W05BtzPO8OS+hitPGROmzSRabVujYU+ynKTrZgFqm4KYaPrX+jSmAFXdN1hhiWGcV8iRvephYU9fWBIgPB/m9ZAkP4RvWB24IMXJN8jlU6X7B82cdyYQuJL5A15y467kW/smrfr07l9tsfa8aVZ/lkZF/EKCcKGc3FNpMRmE8i5kM0o8ComkDL8FM5AK3qdRThVEa8nxlj8OfFEWz92J0D6Jr33UAf7nB9luCgHJ03mHqD1iETRn6+g2kCNgSYoZmJaTyG4kF7dX7gOf2wCoXY49xZrAVLJbMcU2bqbYLGzkrjI+lXH11iAHXP8v7ry9aA0C7nd9VsBXR4spAZN3gapy6Fd6b/vgHqemtmqoXLks0phKiopi95ZALC22uRdwSsexy9MCwk8Z2bcUkQ96DaIkMgfYD3ZJaJBYf1m+VY+ItazSB4q21IY5eehbZCBflqlarC6Ch3L7LQD86ipco0dA51jX67KntTuRNahu067GYXOvcMnBn1Sysx031dvhaFFYgTFH2tSJ+fRj75c1dPGU9c=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 992b411d-cc21-4462-4ef0-08ddcb62ba07
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2025 10:05:04.5438
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oqalH6CvFNFiHUYz3lQHlzHRtmGQ9A7VF15NJgFfoMGvRBM/8+1lqF5h5/mE/HeXUhK7rXKFLn5iSJfNrbl7fDjU2ZrKcUJcYEc1Cbq+cgI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6781
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-25_02,2025-07-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 suspectscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507250085
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI1MDA4NiBTYWx0ZWRfX1i8MrdYZe/1F
 PDChSFSxrB02fwsOhQU+myUydM1EdLj0LoZISLgjbxnGOxURAuvvnrtnTo46ECYuhEkVP5hgLIN
 XfIxKU6Dsy2btc7p4CbRvwoCiLy6U9Z6xXprLTgjoHwL1ITPiW26YMu5XjTRXtUrdW+sRgSj+zC
 nM3SAyp41WTq075Ns4bOiv+PYY9R25m+iRX4F+nGLD2eR7E8wIgBhcsRT5apTWMUuFbj7puvzaO
 XGPB6W5q/R1MYCM6g6hAvmoGNJoA/53ArY2Ag6tv9JheiNAH71RPOhxYJZ/iShPkvn4f2Nw2dJT
 7Q/EgCNqD7djFR4vsrgjDOrsZwQmhhp8GXPi1Jh4ZH59GTdDw6Tm0OGtUqDPdFpSbzKodrIu4CP
 Zaa9ijt51Yq2j//9WwE3siZsvgq6tvh69/n0VrshMI4fIrClfrzqGqRTnLkHJoAKUthqztLn
X-Authority-Analysis: v=2.4 cv=VqMjA/2n c=1 sm=1 tr=0 ts=688356db b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=cA9CPFuHgmmAN9skUJsA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13600
X-Proofpoint-GUID: Fcb7xee8acEeWO8diAe2zUV1LSBei-CN
X-Proofpoint-ORIG-GUID: Fcb7xee8acEeWO8diAe2zUV1LSBei-CN
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: ED731180012
X-Stat-Signature: ti4d9e4sfuudykrzfix19sd5ryx1hfcd
X-Rspam-User: 
X-HE-Tag: 1753437918-459179
X-HE-Meta: U2FsdGVkX1/QJjnlWGuTn5uYJELZfePv2qUJpXVSCTZ5Ot79bp+ITVz4U5A75mfkI+1MLhRNAaZOhYcl/bVhN1t1Gdi+d8gJPKiVD5o/SbJh+xnmnU6H78Jg2j+CpJisc1D0mftyH4FhUZm9AWrL/Wk1ly/n042dMwkN8qexJ8NM8yYkrg2kr7Ncq0mUfoxaJYwW3SFtCZsVjSBrl4XVDxvdgWOLQT8xfZx6tHhyRHcEv2VDmJeqMQHpJB0DKUaAj0uX2yUBsnJOAhwypP9iPKQtBpAdtlraGg5h6m6/sEWb1eFeG+7BiObRC16faLzYOoB00TI/QA2JBa2sneJq0WoytfrYJCPzcxkcUQydI7o/ck9MuBR3cDKbeTT/ZftxQjJcSYIYbs3xyTiFcs8PQoeOHO0GeG21Vl4rTO6GhZFyfSYlO9OCkQ3c/rfrF33FpyjPYamE82BobJ60gVUXFgpI+aOwRUDIaVMiiosrjz1DaEpPkLE3liEqVIbeXCLlctfHoagVeEbAmGw1KMyFu/orccoL+J5mWYT2QdPzJDi1e/vo7aplXXd5xRBQ2sLTXXNdzwRkmNV/jWkbX81aULdMFCq30WFEsiWNM5QkUtd18vLvsfE2Q1/gfdo/1sQZIObdAWemr3wsk35y8YNO6OsrJEevsmcYlhIS3kkab2Hkqj0x35ImazOIa3I0hFnQ5RHiR/OrVJrcOK0jJXNn/a08OQC5lVEa0ndvKJe4jhZgYo4za+sAtA4G7Maz6fpXSN0WTQMrb4/bFGBH2Ep81P+4jo7C9Nd+FBBDh9sBWK4wI0+LZjd858xrfqIbnZ+Af2p+zzO6ZbkxgzErz8QQKQZR1ebMiKKBP3yGxc+Cbk+fBPq7yfuyJQNfD0LyVVbvu1c4WYkgAWrryrl4PirLtCIZXzB+Xue8+6hlzLCXjpPy4aUq2/JcG5E/wMmWoJGtyfvCAgX0g1gPgrPU3ys
 4UMhPsEE
 DcB5ZvVwRZFeLOTUBzN32TqHol83Oae1aljVrvItg685zlotoFW2bzLbJLUR9P7gJmt5tOQ/eyEkxLC5b+ow69Sxm8qog03vBeSAm0qaVepy+qDYb5OA5NJ6YY0ZGRRaJKfLyaZtPH6OXCzvDy+5/v2ZOMhfoowFmq8HXmCx2OS01/Stch/R1oRtrQspQ4zpHiU6mkUEvuEt/SUCFQkrJmbp5BTSWdvyj+Hge7fCuVOyh9cu+bvNkmaQeryTrak6PX7kHuY0AXg2hQ8/e+YyN/n9UiEankk3+T+LTTedxlQ9PpZs3TxpVXzmtiKlJlau4mFts38IuCd4f4kR3R1CMCWSaSb7GM/VtF8EpTxMqSWVcgeTHHVyDXqm6M3UgkbWh6fRlXimzXDeET1fqHlIXwlUPHYiFNwpwZ02V+uSYAhXVrhTrKwCg6TCllAKE6wkC17r9LrUb0BetlhvK/aImWVcNlR9K8YNlZSdboF5P//IS+HvA2oATyW9fDZi/H/nDfP8wiXPNIQgz11zt9Amnh3VM12Dk134WXEKW7eLYfh+DBnFexgLU3+OQSi2Yf94ABqBeltN46rYMEOHnPreBr9vhR8kBEryFMPJKB3AwHJK9wspCPzMFdF/NM3zPzl1sbVEpFYZNIoxN19Ai6qpp1gDuWb2jmrxIoXfJZrsH8M3Ame0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 25, 2025 at 11:46:13AM +0200, David Hildenbrand wrote:
> > >
> > > Well, there is long-term pinning that can break COW and other weird stuff
> > > like FOLL_FORCE. Most of the latter probably holds the mmap lock in write
> > > mode. Probably.
> >
> > Well GUP uses read lock.
>
> Right, so it can race with MADV_DONTNEED.
>
> >
> > FOLL_FORCE won't override anything as we have this check in check_vma_flags():
> >
> > 	if (write) {
> > 		if (!vma_anon &&
> > 		    !writable_file_mapping_allowed(vma, gup_flags))
> > 			return -EFAULT;
> >
> > 		if (!(vm_flags & VM_WRITE) || (vm_flags & VM_SHADOW_STACK)) {
> > 			if (!(gup_flags & FOLL_FORCE))
> > 				return -EFAULT;
> > 			/*
> > 			 * We used to let the write,force case do COW in a
> > 			 * VM_MAYWRITE VM_SHARED !VM_WRITE vma, so ptrace could
> > 			 * set a breakpoint in a read-only mapping of an
> > 			 * executable, without corrupting the file (yet only
> > 			 * when that file had been opened for writing!).
> > 			 * Anon pages in shared mappings are surprising: now
> > 			 * just reject it.
> > 			 */
> > 			if (!is_cow_mapping(vm_flags))
> > 				return -EFAULT;
> > 		}
> > 	}
> >
> > With:
> >
> > static inline bool is_cow_mapping(vm_flags_t flags)
> > {
> > 	return (flags & (VM_SHARED | VM_MAYWRITE)) == VM_MAYWRITE;
> > }
> >
>
> Not sure what you mean. Using FOLL_FORCE you can write into MAP_PRIVATE R/O
> mappings. Particular useful for installing breakpoints into loaded
> executables etc.

Sigh. Really sorry, I'm having a terrible week, my brain just isn't working at
the moment.

Yes it proves the opposite of what I said, I misread it foolishly.

Please disregard.

>
> is_cow_mapping() tells you exactly that: the only place where we can have
> anon folios is when we have a MAP_PRIVATE mapping (!VM_SHARED) that can be
> writable, for example, through mprotect(PROT_WRITE) (VM_MAYWRITE).
>
> A MAP_PRIVATE R/O file mapping matches is_cow_mapping().

Yup.

>
> > So - we explicitly disallow FOLL_FORCE write override for CoW file-backed
> > mappings.
> >
> > Obviously if FOLL_FORCE is not set, then we're ALSO not allowed to get past a
> > FOLL_WRITE and !VM_WRITE situation.
> >
> > >
> > > >
> > > > Hmm maybe I'll soften on this anon_vma idea then. Maybe it is a 'cheap fix' to
> > > > rule out the _usual_ cases.
> > >
> > > Yeah, something to evaluate.
> >
> > I'm thinking more and more we're probably actually safe with !vma->anon_vma ||
> > !(vma->vm_flags & VM_MAYWRITE).
>
> I think there are possible races, the question is how much you care about
> them.

Yes I was just wrong. Please just disregard.

I mean racing with MADV_POPULATE_WRITE seems a niche thing to worry about, and
so what if you did, it's writing a... copy of the underlying file-backed folios
no?

Equally long-term GUP, assuming it breaks CoW for migration, is what, populating
unchanged folios, so what's the issue?


>
> In case of CoW-unsharing, you're not actually discarding data, because the
> page in the anon folio is to maintain a copy of the pagecache page (of
> course, they can go out of sync, but that's a different discussion).

Yes I know.

