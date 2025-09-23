Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF22BCAC5A5
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 06:14:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D82AD8E000C; Tue, 23 Sep 2025 02:14:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D34498E0001; Tue, 23 Sep 2025 02:14:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFA918E000C; Tue, 23 Sep 2025 02:14:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A8CD88E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 02:14:58 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4C24C1A035F
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 06:14:58 +0000 (UTC)
X-FDA: 83919501876.03.0B28AF1
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf06.hostedemail.com (Postfix) with ESMTP id BD52A180006
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 06:14:54 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=UUnj9+qu;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=c7r1DwH8;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758608095;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ny3XLvGb/bSswQhLR+aiY8MaNsFZBwv7SHu8dLmtcyM=;
	b=euaMOUw0Bd5I57Ve7F0aKyxwODvK1HRWcLl6OpJFSZoI7rTkz+g6S7z68+eH3KSzdv3YFk
	YxLSzcs6A7sAmyGSKlnaXNtebE8KVy81CdTNlbYFja0zABGNFyuS6GUYraTABN09rhupc8
	sxP+JEhuwcev3vt6pujl2p1iHyyyq2g=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758608095; a=rsa-sha256;
	cv=pass;
	b=gAN6Kvl3jpXIQSZlifIWMAKLeB15x1YpKtZuUC1WM/XoNoWMeA3uljGv0/e5OLngZlZH+F
	0hBXOiXDz0O9VedLDeb3vQgktJBWoF4zdOkg0HIrAmR3O7IduIXP1RrspDFQMBmrHAWVva
	Z1mt1tiCDVG0mVzo2iXWsXtPymO6EOM=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=UUnj9+qu;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=c7r1DwH8;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58MNC5j5010755;
	Tue, 23 Sep 2025 06:14:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=ny3XLvGb/bSswQhLR+
	aiY8MaNsFZBwv7SHu8dLmtcyM=; b=UUnj9+quKWlWCMgUumf7iDCEB+TsGoKPpg
	0mw+bpwjSaY4yBK5v7XrHii6rU0WkBxsdJahtT5XjkTRImZewelRRr3di21nD4FK
	bU5hylTnJrl/PPFoPXUyISM5mhSTNQhpM0DjOfEv9vCGNsE+atu95ZRoIPiRsOCu
	FsKIGe+JQHttg0Y+qViaExNXJWalGGCAziqmxE9j0GdAkcX82vYp59TPG8Cfwc1Q
	lbHRheXu2YJkGmoZkqROaHIqMclDJM4/jWH4yuxPfs7ZPOv5sOwnzQBeKRAbbLS5
	QMT8tOFKVwAze9BzuJ/NBk2suI2LKI8JTv4rRJTO9n/0tWM8KkEg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 499mtt3vxa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Sep 2025 06:14:50 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58N4hLsC002112;
	Tue, 23 Sep 2025 06:14:49 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010064.outbound.protection.outlook.com [52.101.193.64])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 499jq7rurp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Sep 2025 06:14:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MJF18nt9B2kvR//v4Sb+QmJxBf1vl9Nc7tzMZ8sQCi5DvEn20RcYekjAj6rTAcVMGMO6wEoZIF68zGv7v7d4XRFEuTM7K81kbtTBfxmrfg1kcq9a5XPtDJYGTgxbD5yTW+wz7SUbKrPhwmfGS6LM42P2ntjkmtxbONaNi8qBAje9GFd/tlbL3cMEEj9Ssrx19Ntf7mldO/YKvJOVnZ30OO8aR4MWpfy330erZDIUCb68i8gdP/5hOqkeebVs8e8o+VIeCmsSJZnQR8KC2xg/Ei7g4nHgxyyY96p51ZIcaGPpOiXU4BT5TKqsHNNk2khjhW6bqmP8NWar8Lg7324d1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ny3XLvGb/bSswQhLR+aiY8MaNsFZBwv7SHu8dLmtcyM=;
 b=Q9/tzyJnvibFyTe3GxUpt+wRkpYAFKBomhyTzp+/pYQjwqf6baPsSucb2Ks/AhPTYZvpltNdRBADWkGehoAR+YwHNrFBvGDUt/8IXlq64XWwjSCUMlThuHFJgcL5rg0Uj0Uvgf5DBzX3UytdZcEKhzC+0T6CmiMhFqk38QpyxYQ81cXhbyaheg+UgEQHIQjANhlSd0Hn8b1gS4A1Oxg14uY8L+SVnzfBAvOZofrGO7ZmMMxkEVjR5sJPqaP/OyahHZ9X/D15/+17lj30kgsyQo0knI6xPAlMof7zFJvu5hLL5m1zRB1SOYIB89BK1zWmlmGujj6eQbXgSzJFm26YdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ny3XLvGb/bSswQhLR+aiY8MaNsFZBwv7SHu8dLmtcyM=;
 b=c7r1DwH8x0bc69RN5lkYbkSW/d9guQm/KfhxUONOczR9k52B80OvZQ5wnZNfOVrBUfGvn5amfExcLGN3ksRchs5bSNQlK+P8E6jswt7nDzPzHCe0DxGf3ur6gBKvvvjSLNbZnpy7IMfBlwcvE7b5rj4VFbXoSw8gcLgXWA9OxDI=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by IA3PR10MB8298.namprd10.prod.outlook.com (2603:10b6:208:570::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Tue, 23 Sep
 2025 06:14:46 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.9137.018; Tue, 23 Sep 2025
 06:14:46 +0000
Date: Tue, 23 Sep 2025 15:14:35 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: viswanath <viswanathiyyappan@gmail.com>
Cc: vbabka@suse.cz, akpm@linux-foundation.org, cl@gentwo.org,
        rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, skhan@linuxfoundation.org,
        david.hunter.linux@gmail.com, linux-kernel-mentees@lists.linux.dev,
        syzbot+94d20db923b9f51be0df@syzkaller.appspotmail.com
Subject: Re: [RFC PATCH] mm/slab: Add size validation in kmalloc_array_*
 functions
Message-ID: <aNI6t5hqY6hSx_8Z@hyeyoo>
References: <20250922170357.148588-1-viswanathiyyappan@gmail.com>
 <aNGOnDb0WsIbk2zx@hyeyoo>
 <CAPrAcgM=-2dvHg5yvsqtT_YfjH-gThc+iGZGJpc8gpKbg-OdrA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPrAcgM=-2dvHg5yvsqtT_YfjH-gThc+iGZGJpc8gpKbg-OdrA@mail.gmail.com>
X-ClientProxiedBy: SEWP216CA0038.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2b5::6) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|IA3PR10MB8298:EE_
X-MS-Office365-Filtering-Correlation-Id: f5e999d7-336e-4824-cbe4-08ddfa687e5d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?EKi1e60Jq+smTFd8T1ub4FJSc7kBR1ey78/XEVe/Yz7AmGmYTG4sKP80p6WY?=
 =?us-ascii?Q?XlTW+MuaWllfGL7JcawW5pNB8rOsH6bNx6PiJjCPU71mnz7pljtN/CPpIfUs?=
 =?us-ascii?Q?tLorbO+rl8Vlo9u2ClREBiXMebzcLxNNteYWxHvhtmDye6ypKo7MiP5hbQH2?=
 =?us-ascii?Q?aYvxhMrexU9o2f6SgAEtqLK71NOpw0gYEF8ZmIAqdzFRTXAVRSrxCjjYalVH?=
 =?us-ascii?Q?IC0cgoindK5ejx3MStoPoG9ArVmdrKNdPEijFWSZYYXhn22mRmzYkJ7y/ac9?=
 =?us-ascii?Q?WSIFp+MNSn9prhBgUbQox/lY1R+uW2pfW43yI+VA7LW6A3/7qunltKqyfwdY?=
 =?us-ascii?Q?og7Dn6ytUvWPG9AG5uL2pIk37XcJNtJ8wCQXDYlG6sm6up+vDkNZ1/OWCOdX?=
 =?us-ascii?Q?DzkQJrqMIQkYY847TA6fk+Kt2I3gfe/S5MApRaAtYnLDXOhc6WmVn7+H5+z8?=
 =?us-ascii?Q?Ty+KhYsZIAgVzUktX8k/dx07224gUC3bZHVN+N3XRfTfn0PZmBTmz+iHquGf?=
 =?us-ascii?Q?yMWHidk1vtsci4FRzdCwJi3JJ1Bn1UBsU3HYj1ZXIoGO55NBX+EafUdtkVPM?=
 =?us-ascii?Q?7Wl9u9YrSGVFRE8RepCp0WdzRDJC6HSFjFoQN22oj0cObVkCvJNex270cOHX?=
 =?us-ascii?Q?0djBJHuxKIeUBrNnTTnlxYFDgupJN4inuz9cVf1e8/SVbC1XEbRTbX9gmA46?=
 =?us-ascii?Q?Aa2YieH2Vh6k4jRK00Eisp4PJTJc7C1VAcOeoMDDzI7gTAY97Go6umG/w7Qd?=
 =?us-ascii?Q?tszzy3jVc9oDwj0FdLO9ipbKMiqfUCrKs/V2m63dybGykTByBuqVN83w/+b9?=
 =?us-ascii?Q?6Wab2hDU+pQ0VSB7AJQ8zHwKc+SiANehVNqgjobcaCOfIPAfi4cspXv2fnYR?=
 =?us-ascii?Q?AOGTC/tn/e76zJ4o/egyPBRlZ6jkJIItzpqd010NWvnmskycOKGnyGHwBRNh?=
 =?us-ascii?Q?id3mznM2BccbI0hnY7B2nI0C9gF08rA1B7Es/8QuKDcxkyX+B/1B1MSfzbWb?=
 =?us-ascii?Q?iXFCGkYSAT6rqf4/gZEbUIP5mpM+lTYFihfB8RgG8Rkg0H+tsSRxbLWaVw6T?=
 =?us-ascii?Q?DtOQqkRZMUXJG2aUd5a4JsDShZPGMD379IWLasktm/FNAGCeSsboN9sf0nSv?=
 =?us-ascii?Q?eeoKOZz3xXxXHQdMzoJrx+klWqGIUR7mSUxZsVAGv2pwdcytbwFr0AdvdHH5?=
 =?us-ascii?Q?uny+io4DO1N4+QqsXVFcBGt4H8xmmWgaeqsvlYh44fEQxdGPW02c78+BUHCa?=
 =?us-ascii?Q?oVWikp1Ja0XVafzv8tf+qF+e3AjAIgDH9kV2hWDhywYj0Mg3jtvFamseWePR?=
 =?us-ascii?Q?+FqY3Y10v4stojoXWi432dbbClHSOZKozBxsfRsldXXbdA2O/kPpR5JAuxlU?=
 =?us-ascii?Q?uDDFKz2hdlpPhqGkeju7Fb+E7TcUhMh/uoNxcedalvyQpQmkQlRUhY4/C2QG?=
 =?us-ascii?Q?/Nxdc3xG7+Q=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bUT/hldpHMrra0gZllkzDsrTl2uNPaNCIkT/kWS3jylXnHLgFCnUSTp0lTnL?=
 =?us-ascii?Q?lXGvrKsLZJ8lra0OgFyPq+c3OGZCzdbFvAjR5wiERG2JTGwNrQmEnA9XI4ym?=
 =?us-ascii?Q?FVZXBfowMZs3dx4inUyIcqnqL6UqaVvWPG5ICMbWZ5gDTK1GepvEHRao0RfM?=
 =?us-ascii?Q?QVLjrHLBw0lHeiug8WRFFXE+IiLEB/1SGK2x0+VDMM2BvwxLan3eWxLYwL9W?=
 =?us-ascii?Q?d1sdm4TynSA4NR7GiL4YAUrMIfy11ZteL81A4o5BRNdrKd+Sorj0A4gIwTgy?=
 =?us-ascii?Q?NOCgjia0YS1JGEHIV2OiikFMJZMwCNe9Masl9HGCvAgKBFuTleyDfTBd5yFM?=
 =?us-ascii?Q?ktAPPD+1YC2WR+viF6fZupqVh2ZlwPxYyXEjLgFQmTO4u8UAL4svKP37zLR0?=
 =?us-ascii?Q?MjBlWsoTG5r3FgLpoFrllDzNA+YDd6O+JRGjsTi4sBpomFKLzo0LXrs2RwaC?=
 =?us-ascii?Q?9GXHDT4tnojPZs3GN5AE4SpRbU4hEOzLfN+EwYT5drCdXqKYQp8AHBS+vrrp?=
 =?us-ascii?Q?cEX/62FYLPc/gNMgnbgTs0qyD1Pd1oRgy/xyskDneXYAb8NkqNcW4jpDrlZ8?=
 =?us-ascii?Q?Hj1JO/0tKrAXLRpU/MdXeR7q2Omj9xr70Jk7elHzL8usna+XlZPA6eJfB43w?=
 =?us-ascii?Q?S9BxI0MGAeASf9HznayX6RGgNvA56LH+qJMGOowesiAa6MCyLxr9/B5VGjMv?=
 =?us-ascii?Q?xyjlTD0uAG7MprdXK2wDeZCUs6bXctRNnHcTBdpGcD4YJ25DfMKPkvcGrb41?=
 =?us-ascii?Q?hd4W1jirKsYGvE3rsNNbLmBIsIK8O/6QEJ2dbhTvy2VD1YyulZjEgVhCXbFN?=
 =?us-ascii?Q?bfrjxVKwbvOp7E3wNI/VGXOw4HGEhPJSCUxncTn+UMvVUGBD70x3Qc5sCnER?=
 =?us-ascii?Q?U+26LttSR9+F7kS6gmjflK2TwiQuZvM86s/+mwp9Zz9DuG5tf9rf3aoIk5T0?=
 =?us-ascii?Q?ENiA2EEy8L/6c1ZMRhxQ7LL4DvBDQbWA4jaOAAEm0D2T46yCN3Ph47n3efeh?=
 =?us-ascii?Q?hqlO4wnnP1coayuiezBX/Nl6s+JQeHD3PsVKkAsX/M5wWjh82KrmJcOVm3Gr?=
 =?us-ascii?Q?yUgnKjdnOwgyXWe0fqzM12X+5n5UXuwQZWFheDE3o3KUE5cY++A2jIKw7n+3?=
 =?us-ascii?Q?DN4wEnwwhlz6WvjYaZxTK8lVihVgVDMC3rQOniHpPe9YYmKLjL5Fi/i2eTJi?=
 =?us-ascii?Q?PLxvyeOVvTDn6+6ecaBxuRUtrYeOzz2ztT3YlqBHW+MGen4M/IP9/xB6UwyS?=
 =?us-ascii?Q?1KVhHg1CionTsshHebrQZ+VHlo3LmpsgGxoMd72CZB21n8Vrx6LIJp5jZ7ud?=
 =?us-ascii?Q?4bfTasZ9MDcWkowqFhJD6DWlws+PTtJDb68h6gWCPHPevDcmMbTBo31cloLE?=
 =?us-ascii?Q?x+ojMcKb0pLCpR2PUBoectI9JptEagtMokeFWahan5yEaPvv2a/ViqHpl5GP?=
 =?us-ascii?Q?5fPUl/xab3jccf2GoCUTqajx436eyuF7VeCl4Qw0mZEZjE+KlMcCgjFnfbag?=
 =?us-ascii?Q?CnfiKBcVKFesiUrzbNZu/VzfCtlFBbWoA7Aivea7tLbnYz/UAbujS+caVBjZ?=
 =?us-ascii?Q?yrvVppJJ+6t0ccfZopiXf07aZoXTpLX3LUgR7weE?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	A+vTnlyA+8BIQvgAwZdkiIzlfsO8gE1ekdx/0z8FhaeOFS1gs6t2sROz7yYRuEkequokPdzzVU6QIKZ61/XuEL+E+9CiIxY3acp3ktV81k/PCvEBKvk7oHLbLhMJzeWH+O52RKAP95bX9BcXQwbhx2eRmTSdtFwaIQGdmdLeRKI4hUiZrsn+3/M3wjBWDCwxn7gYJsoV16jnM4YJaCVXtEQVd9auh6M/dLkkt61NSNronQi1U6+LjK9AQvGidTo6wXMzzQcUesF0xn1ijcUB/OsEPXjo8+fDJ1ndft9m/gg8tn2EgS62rXf2Z4P0PZyhjfw5MMGOjPqMp8FfyroRjhzm3o025vX1ZoPf7DWwbPuypeMErYooeZXZMLDxazheqlj6QWmmUHeH9dIHxH1VOBNAlN3bpKZPUqK5OyEZms9wLEDO+iixJLyG3IsdN4/oYMmOQJduS5wBwGCbu0V/G+fix0QvXrXn1NRXWCfo/j0jexI/wfyksphitIxVtQliQTFsw22aMdWHIbUyP5AhlU4gSoc+xTfncEtjhxo0GnbX5dSkNBL5Xz3oR9sfoc/t+aS5AlrhoET1Tc805l0t/aDl+yA+gQgyzD66+QEuyPA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5e999d7-336e-4824-cbe4-08ddfa687e5d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2025 06:14:46.2257
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vS3afhHNCtCCZHuL6kVup3ajEq0N3X0X7MeAbmSicezFFLl+/jVLE4zNc88YntLszVr+xK2G7e2AD/7vjzORAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8298
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-23_01,2025-09-22_05,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 spamscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509230056
X-Authority-Analysis: v=2.4 cv=fd2ty1QF c=1 sm=1 tr=0 ts=68d23ada cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=DL7BUCsRM9HRBss6klwA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: cNcB7eKQB22nwNCb-WGYqYniRiJemc8l
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTIwMDAzNCBTYWx0ZWRfX3/UaTKVSZbNg
 ymIWRmMmnX7NHhnrVMCwMYSoeyPnNyR50UNC6BMpn57PI35bebE2PCnJLuOfvqUU0cechMltorn
 LoZDDtSEXFTSpvpsO7HWk0o8zwCSlBXcBc32nk+rcTQv5gZGwECaUbLE/Ns+DNgPb0Qjzlc+3D+
 bEPnQXQm7EadGPKWLr2iD+TxMJCcFlarS9MZCxxKsARAlQBtRvWZKaiC7YfLuIX63jLLsGtNh78
 hhYlpoWDIDH8+/3w/JKqGSmKxmAqKY7Fa5ARccLV5gVtK5jSAZeHuT8JiX3/7QYyqcFVcTJRpOV
 GHt2MXRaEI68PXy6tx3MuGl5rPOEplJfmN/LgMRh0HUPN3vQMiUK+P+aSPi0FbyfBPkEQ4PnIAg
 TpJnn6mR
X-Proofpoint-GUID: cNcB7eKQB22nwNCb-WGYqYniRiJemc8l
X-Stat-Signature: 96odjek6zkosng8m7mt5zpi17h6n8jrr
X-Rspamd-Queue-Id: BD52A180006
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758608094-203825
X-HE-Meta: U2FsdGVkX1+DrKC8IJP0+yp2coIYT7mitGKP2XHiT0UTeoG2ViWGVgQjqDY2U/8WVWjayLLjqc9qZ+EeEBuX/KFdkLs0I0Q5VQFTwgOgVqJyueog48AelAYiwIwbTG5b+wzIDH5Y0EovobhNEh5hEAzalaV+lpcXr2pZCmvzTq0KVFUrTK3Usv2XdMpS/X8pv+HNAFbpus/bCwjnWWp//JHC/Tl8JlBv2GaSg3WpRfY8bmHlHu5peVHCLpb5GsT2dVerY77Jvukn4+tXNRKSIF9E/SKEBaQT/9E5+aIFIN8Tyjs4kle6fQ+6ZFJvwJN3CPz//lzgIfZqbtuLs+FXQ/r+A7Oc+hn8oOU+mO1uMRQyZy5QsfdOmXqpiMH99dI4FcVGMcsOYpT4bS2W8ov8X7IhfaA2gidBBjCr4oTnX4QvMGrmgvC8tVHuQzUj/fohTO6/mDtOr2npLXA5IOkfFlgUG/1VQlz2bch5SYuJ6O6QUM05Lpj5jVLAD96lUMuSb3tC7XSvKzCatM9fRh3ERhqmTgqH8+BJBOi+n5qz6bhH3lt9og8SQM7ZbhLmPScvetkz5RflUA5KgqGZSDlJu7qblZl5vTkU/6MnBaXG76Kqil8m4ynt//xv7GhOCHI2ncoar9d82zefnh60gOX4ExbMookYl5y3Fgv3zi5EMvNrjljgxgAb1zSqGRzqyyWTrJqXgB9wfH2RB6tj9ou8fZmHcbsLLzKfk9dVyvApbnS7IQbaU1qp9T0m+0t2Fg1NXtOBfD3HUgwcHfUZDz0e4DdYka5N8kvuDJMqZljoatlY6VrPdlHgoaNeiRjpMTtmhnVl3bVwJh/Z65gpb3cZncj3zXuXTsMN4jvM2H2nHA1BuBWXWg+q65pnKy4BiBpBg5ZPrNX08UCCBIIzb0jcP0+S8bEQliiKbrSe8B75FrB+CVMKl8s0s09LekD2jjb1+FWdImhC0upjIeI9zPC
 sMSj4VDN
 rhDN5N25PZaIILC2m9wejacjKM3Jg+N3S6QJYRWCJmfXqFjn+7lnG/LAHAuAIqCrKljPoBeRmKOjtgNU6yZ3q34sWyh7EJmhi69nKEcH4YPZqcQU0rmNbNYeHFjAr0/9H+LhCrJec+MDUrygD07nIbIfNXWuEnIzyCR1McM/ju9cW8hdnTXlDG6wMvojE3etowt9vpzygBVrCOMMA6D8w+pxFQ+Ku7mlsuCZG+r5DX+fN24eW0eAP0PP0HiGD8Ua1NMVTy+G+bv6m7TOBYQTxF5C0yrv0pHn5P+xkVDZrqVpSC9USZihU21McXQHQ04K+b9pyM3jmEBAVZ+Gf1sroBuTZdYFwk5hpysb6hk1MOhkrQpVHyYNbEPfNOLTgZ+VC+xAjKhY3OWrnwQHEigHNDAGPRoMWteHsrF6zS2lud++CUMkUnkv+/anPcyCAxnUWhSXohFt9Zf1kdEK87J3gTtZo1ysjJwfVIw17EzQgAkWK0VAeOHYxmpmMdUzJ8qxJIIX1nUDDpnlae6KrW6gN0hx1Is+XBs6PQ9RL2iQrjWTMqWbW2TvakO+9mKco/6GPLofCC+Ohx3rhzppuMBxGCWvtcug2Zoa+PtlBj+l/am4vlvcimPwuOKfGaVvuqewwRL/eeAQauK5xaC4POWtgzP274tQk9PzbkDYboosXkgVKtcZ+kss2FLg1lmb/2s0AJcyIl/xhQ8EHSM/RaAu7thPIYQHOKBgryPUKipPu3ybDTu0LrqXLv6vKKD+ui3xdpxknG6haAMbvG+BplRLmJPDP3ejTkB83SppRgP2MPJuFTQvEivapAzyqZpeXCqkwcZZcIiljTKJPWWmRiSmfhCxxpuh++wC0i8RPAcRFDmdREepLj0MJR2ZEvrJoXLUSiEC6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 23, 2025 at 10:41:39AM +0530, viswanath wrote:
> On Mon, 22 Sept 2025 at 23:30, Harry Yoo <harry.yoo@oracle.com> wrote:
> 
> > When bytes > KKMALLOC_MAX_SIZE (8K on my system), kmalloc redirects allocation
> > to the buddy allocator, which can allocate up to (PAGE_SIZE << MAX_PAGE_ORDER)
> > bytes (4M on my system).
> 
> In include/linux/slab.h,
> KMALLOC_MAX_SIZE is ultimately defined as PAGE_SIZE << MAX_PAGE_ORDER and
> KMALLOC_MAX_CACHE_SIZE as PAGE_SIZE << 1
> 
> I was using those definitions

Err, you're right :) you mentioned KMALLOC_MAX_SIZE, not
KMALLOC_MAX_CACHE_SIZE. Apologies for the confusion.

> > Because allocating a page with order > MAX_PAGE_ORDER page is never
> > supposed to succeed, the caller of kmalloc should be fixed rather than
> > kmalloc itself.
> 
> So, Is it almost never a good idea to add new validation in the allocator code?

Yes, because such allocations will always fail and that's never a good
thing.

> > I think the right fix should be to return -EINVAL in max_vclocks_store()
> > if max * sizeof(int) exceeds PAGE_SIZE << MAX_PAGE_ORDER?
> 
> Thanks, I will go ahead with this approach
> 
> Thanks,
> Viswanath

-- 
Cheers,
Harry / Hyeonggon

