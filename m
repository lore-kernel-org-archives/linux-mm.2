Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C381DCCF9E0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 14:32:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C8148E00A3; Fri, 24 Oct 2025 10:32:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 178998E0042; Fri, 24 Oct 2025 10:32:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 018D18E00A3; Fri, 24 Oct 2025 10:32:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DF9868E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 10:32:58 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9288B129FB8
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 14:32:58 +0000 (UTC)
X-FDA: 84033249636.07.C8614D4
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf19.hostedemail.com (Postfix) with ESMTP id 096261A0016
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 14:32:54 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=IwIMopuk;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=QXDQIOmD;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761316375;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7N1ZaD7aaM3u4A6Q+ksRaWleGL7ZztPbPq96wVlDWSw=;
	b=slg1kFSZPp7bvVJPJx807EE7HFQGmQ7x5dl8ZpJMnUd0DsmtNmZR8K86mi6Zda70FLNiaB
	N+kGkCP7gFtEyc0pGZOtQj4cy5jugK1dSZSNXhZbyWkSaOoELUGr3NDXxlWP9ZPSlgHVcK
	5ex1TLPaM+P01DyuzX/swgSe21uhQp8=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761316375; a=rsa-sha256;
	cv=pass;
	b=P63kMdTyU02TJtVNcxMFdhOnzQVkiRe3CdhdHJlY/8FrS9UFsWRpfPgiNFhLrHGmV9VsKe
	x9bCXINGkXY2j1NF07A6L8kLyxu27WZl1z8IwESzdQKhauRmz2K5Lf/+yBvZdqOYiUCaO9
	WNhVccCUwTbNPppNNK2P+fiL/4O0QCc=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=IwIMopuk;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=QXDQIOmD;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59OECKV8013823;
	Fri, 24 Oct 2025 14:32:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=7N1ZaD7aaM3u4A6Q+k
	sRaWleGL7ZztPbPq96wVlDWSw=; b=IwIMopukbl7G+YCYXPgMaCouT+wxe86es0
	ZHnoST3dhpu0/T6iuo8tBvtb7/4pf6wt8G9UV1kBD+/9w0mKgE74DxGNo4YNSo7X
	qHMjBcx4TQvik80aRxLK36bNEzoSE6mjTErjUIKiOJcLeNd8lHKHnzIa5JF7w3LC
	psngTBAz+1X43dN1jJeIDDedXJEIMwLISjzgl+yN+0iPT/xbFH5MchZlpkyzIi2T
	J3FjnuV3ck1Do5xNm5BsHTVMpl4r+25h+plJ/KS/glgkFLkt+Mz6nPD3WGkhT479
	SUEeOruOZOcYvmcPwKpBE7nL3KvC8f+tndTV+cFawaB6kLov4aSg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49xstyn5r3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Oct 2025 14:32:48 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59OEBYm1030542;
	Fri, 24 Oct 2025 14:32:47 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011032.outbound.protection.outlook.com [52.101.52.32])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bh19xr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Oct 2025 14:32:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fC3WAnNjI0GynsF7qNhy0ldakpOuaSXSMyqZqR3HckWxJ/65fCjKjrA8TQRyKTPjRYX932N3S87QhjgbhgbFvDmIOtoW/0Bog6/XjwMV9S5EBLjcRAD6rVGHFvMTgUsIB81Uc/nL4umbGJMFr4+APwNI+WCM721xKpakNy8x089lw7K0YyD30nJbliI9FcKQ3O+/bBmVe5BQqxujCPScagTxlPNRzsMbPjD87xov/nKwql3AVH9rDGseOvN3gLtknIxY86oRifSnULyEZnaatDmE1LGDXTBK0iMS7wGsDQvU7XUXgJNGXw7Wdc1JlE/ZRnzu55e979/TZ6BwJRmeIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7N1ZaD7aaM3u4A6Q+ksRaWleGL7ZztPbPq96wVlDWSw=;
 b=BE2KlhrEs0Q+ipbWxpRpfhaf8fD5Gmnm7M8VXrAtH4KG9Mf+2dGhrffEKvQ9gDkxJSrnwGOOBksgo2nFJnpA3LSJONSN0z4OvN1vtcj77i2PUzgaMffcq/QBzcBSo6a3nXma3iKAwu6ZgnzeJpYHgRsxlp2QmonC4FPdtjnH7QbJ86HWt1hIxuJXl3J2Ylr9P6beaZAGPLIo8ja3R2d7oxb5UdSQ6oPsTq+DkwEWubVTIhQIAEo3mdRbW1hZ1eBKxCd0ABpODQ2D3N5N6HzZ/dBKg9xkAkz6Ivu496G+U//H+F7daCrd8eSca0sjESParzOgYyj7QuOBcg0Jmi9Qvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7N1ZaD7aaM3u4A6Q+ksRaWleGL7ZztPbPq96wVlDWSw=;
 b=QXDQIOmDdHFhy5eXfNJ7bcnE1fPVO/jd079Fz0Y2Sl33CrIoTxbCnKrnYyifgayz3Ld3uFmr2Zt5I767LnlySvyOoi+5sQP0lJ76XhaSicnTHy2ntI92rQ/+IRGxmWfs9amPLwrL6CKWvhNCxyTPu2kqmtY7UIgePo4OwGwP2mk=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by LV3PR10MB7843.namprd10.prod.outlook.com (2603:10b6:408:1b6::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.13; Fri, 24 Oct
 2025 14:32:45 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9253.011; Fri, 24 Oct 2025
 14:32:45 +0000
Date: Fri, 24 Oct 2025 15:32:42 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com,
        baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
        npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
        baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org,
        wang lian <lianux.mm@gmail.com>
Subject: Re: [Patch v3 2/4] mm/huge_memory: update folio stat after
 successful split
Message-ID: <9d035053-d1ef-4284-9d27-fbc28cda26ad@lucifer.local>
References: <20251021212142.25766-1-richard.weiyang@gmail.com>
 <20251021212142.25766-3-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251021212142.25766-3-richard.weiyang@gmail.com>
X-ClientProxiedBy: LO4P265CA0097.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2bc::16) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|LV3PR10MB7843:EE_
X-MS-Office365-Filtering-Correlation-Id: fc2c83e4-6f54-4917-ff1c-08de130a3252
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?UO1yrwI9EdwtuVdD6gq8QKQVu87eYtMKgU4ogmgYBZ/IcG9/gTu4yJN7XkT8?=
 =?us-ascii?Q?aCjRRILUOfIuTduFxtRzZW7wqEQc15/lBbctzRYQY0PGyohgbAL/nJWxfxKu?=
 =?us-ascii?Q?5L97qC4tK7EKi8sI/tHq8q63SckIbzObhxHGgPyRh9rgNQFkxYwYhmqnO7i3?=
 =?us-ascii?Q?NAa/I6u8D4qAgUMLtSxA69QuopGzdYTMXzIirQdFARVe1SojT6S5Uc+iQSg1?=
 =?us-ascii?Q?eHVM9Ccgx68PFFQGw/vgvAI4WxtSsEcYlnGb/TEphLkwkdi1gp+6d4qr4QCi?=
 =?us-ascii?Q?MDodf01couwF0C3XgwlYHBQH6Wc5aQC5SY6n5uhE5Nm6lfjPXojidl2s/lbB?=
 =?us-ascii?Q?+v/zCW55ND3Y0BBQxeR5bOx/yfnxFlTbjfN4tUWhfY6R15GTRoRoaenDmngz?=
 =?us-ascii?Q?dj/l0bqhmgr+kpqtV6r41so8yri1dAKVr4vqgudjZMhct0p8vt/B7aYUJdmk?=
 =?us-ascii?Q?XfO65fi9foZZBS3ZVl475k+teBKSEguLX2/SupYvkBCwagvgMlBICasShv/p?=
 =?us-ascii?Q?S3lobMJQ/9v83OP8QBaOPCsgw7djG+amyeQ5HnP82LuYkawRqITuXfVXElM5?=
 =?us-ascii?Q?XSrug09atciUdukrwypE3z0smpS1vMBDqpHZeirmGN3U8ScFgdOZrAWYZjEL?=
 =?us-ascii?Q?AVO8n+0YZFAfVd/EeAXl9y647kWjFzLfX+/Yo7TKpfNUsNNhwjQsZP3r3ksP?=
 =?us-ascii?Q?EzSAXF+An+svXrcGihYIdalp4LfI1KCpZG7Ck47YO+UlocgdctY+7C3SUpLI?=
 =?us-ascii?Q?GU3/zF31by8Lf4rcR1yE8h9O05L3XhV6lUScarzlybxePu0gigv8j0FB77ax?=
 =?us-ascii?Q?oigJzWpJs76ZCLLKpY6Hk6UXtn+gei7vUf92UPus0x+xJJPeC7gDcDwy/WKp?=
 =?us-ascii?Q?i4hNSeUAh/NOGeWh8b+rY4RKXNIuY968R2JkWRTwbsQW+50z7FevB+ml6Qtc?=
 =?us-ascii?Q?A/zTr+AfSml+dNxLExNtO+xSI4gH7MAqRDtYJ7578/XGU3/ZqcMvS0nccgUC?=
 =?us-ascii?Q?AxBh9UTRgJUZI7+8RDEDB+EJiKz4osDfKPc/jdJL3QurSO7vmEUrdQBAVzsI?=
 =?us-ascii?Q?5Ux33HDKgNcSbEkpjqlUM1ewGXPftTglRb85gigeZf06rrlvYrGSXkYmRl9U?=
 =?us-ascii?Q?v23zeS9BXLf1VeQN9Fj5BuYumWiCo+ONZ677kJXQ1wVY54aREVb+5vCHIj+m?=
 =?us-ascii?Q?jECX9oswm0MFDktol/6CLAXhpUv1JWxDtz2f2i/1K30cScpS4sQ8LbSSWsZ2?=
 =?us-ascii?Q?3KEXa5ll/jrvqtIeVXPDCDpC7Nj/J6YxIOwc7Ez8N2lZximFK54Op1AzJsCi?=
 =?us-ascii?Q?yUDcC7+rNZo9OfkTMUZidOKnSy873cnfTOpKv51J9WnbErwZpIH+x+nyNcFB?=
 =?us-ascii?Q?Gboyxbc/K9IL4j23s0zYNOib2hvcbiQ1qFiKLEYn+KZchSUI7wCeyMy5A3qd?=
 =?us-ascii?Q?wgFN8KcFwKEzYwXd9H0ZJXyugGcObonL?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5ZRS6gBED/ZVHpZGC/Vd6DQ8yXL7XqV37nziCSye8D60PtzxxN1Lzq8sDQAf?=
 =?us-ascii?Q?W4GmcBoIV0UsQDcDra7o2jmiIkhsPGyySZtT7Sq7+aDOaeT0CeiC/aMrp91D?=
 =?us-ascii?Q?a/EOPkNHbNdcKqdH1qdO3t/s7mcA6FW1NFACuWL9NvZFFwxjqLW54IUbp5m1?=
 =?us-ascii?Q?Vr+n7Tc5KRfkTZG0lBvxJ89S60HGRxnHZQuo28LN1+u996H6NcQuQDx0qz3h?=
 =?us-ascii?Q?nPV9jUz64k0A48IhuitymtaOO+XbetzNgCWLDcdmxHRZPePwvtFqePfIRSl8?=
 =?us-ascii?Q?p4pzOTu6YW0ymD+nkUCKiY10ChkER0hHbCNnoeVMrzBbDsVlKmf6Un8eiypA?=
 =?us-ascii?Q?bEQfRIeOEpoV54aKmjFyywF4D7mutB+r+qSLVuT6QoL96z09ws20eHmIsahR?=
 =?us-ascii?Q?9bLYhOfnpQZjv592Di3LNzAgEPsRITC5VqcmAT4HR8ppUNIFzmF9ab+0NBxl?=
 =?us-ascii?Q?XSX0itI4k/rAd0Tq4PLpenF8WuNrAtwC1aW2PAkyEv9r3a0NzVzwktbfHN2H?=
 =?us-ascii?Q?4w/jK6u79FCOkIk8bnarpt0LsC3bTRm9oyTr61782iGE6cOt3AtzvNJ4xtut?=
 =?us-ascii?Q?qAceNOUO7TMZREI/L+jBHXZ4950bz0TB1gBo2PcM0OOKhWKLQzmtrYQpSAL7?=
 =?us-ascii?Q?oZspeA4rPAGeedJXLPS8RiIMeRPrUs46uzKToSZ+okXeYFnx/s5a7RRDdxqK?=
 =?us-ascii?Q?XHmLoE0gIX2ZjSIZZFEUqaNsVfRl1aPZrGmB91HLrQwZrU9w2SMOttsKdBXM?=
 =?us-ascii?Q?1II8//M+btRX/eNplMxq4NEcZfjamaNzd/51Cy3inYSsOlUEOHm64i20qW22?=
 =?us-ascii?Q?6MiqyoyROK0N5SKyWD1veFsc3YYngValnJ99GzP3ZJq94vl0lQcdT7rZ+Nm6?=
 =?us-ascii?Q?ZtnOwU8tLqAueubjOSOA+yTFGt20HMUtrGHnXCpNaWi8mMX5jo7FP9LXI034?=
 =?us-ascii?Q?Vjfnu3k9+/H2zhxGcZB4AzY37MaSsyFBDub0A7gznF1mODwRYEWf8OFwouJE?=
 =?us-ascii?Q?8rBNY8DW8Aw8nF/zAZWjFhwF7wPfH86V8q78ywWFsRiSPg0eHkxSUTfxfgAs?=
 =?us-ascii?Q?mBRw2IfvWZKI+zZlsOcpcbX4GOd2NypIYgiHu7BJQ6aLJWwZKIdF5EKlskM8?=
 =?us-ascii?Q?KJtQZRuJYtkqXu+fpIb03va0Cn1OJuSeM1988YThrkexkVilJ4JekVHUh6uF?=
 =?us-ascii?Q?f+dRqPq1v6py1hBO+myTdgaJ/BoRz9N/k/Ns5mi+wPsRME3FJ9fRyRUxYpxb?=
 =?us-ascii?Q?5p3MC2lnQNkFx7UsQVRgPO42ETE6sNDaXc7UvidqpbZO2fgwwILliYqZ9VrX?=
 =?us-ascii?Q?nfGTfpi3LoVLUPKU/bdRYwbSD5HNhJhGEnchBttAMIeW8GtUttT4bewRy5g7?=
 =?us-ascii?Q?CoROICsWfhrqbDaKIYR6rza7znGGGhrLXKbpKuVLe6rGKbyHzTNqBcVAhtC9?=
 =?us-ascii?Q?JeDhgR1gKdtO11l/clkWo8GDYt9wURw/BvzxGyi8DRPmtaDc9K80hBuwaTUC?=
 =?us-ascii?Q?ok3vsqzKnpRpr5K1hc16HAQWpKiTj1k2P3ZpsKQc0CE0Jtl3gVZeTU5a2gVJ?=
 =?us-ascii?Q?khIx9THPHP2yoWp2Yf9VOcUSuBVANHYKPda3oJ+EFHc/rpN5kWR9s8vOj20l?=
 =?us-ascii?Q?sg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Bn8W9yUr/VnKR5c2ZQJR/Q1R1dJHbhQIDarn1jxNGYCv9HwMW5Y40+/mjNko2CSI1I4+nauQeNCf20JUi4tGqzm4D6FpdzOdIEkJ4MxinteUEJg2bWgIx4qcDHXUMQlETcq1CJ15Ss2ZHt/VmXw1rkAawh75UODm3b4NDNmBcNejZSuIgNmm/0WcXzZjLZ8GNPPrwSVwX5e0sQHdzepRRmsrdpMmHz7jTYVGD7U8wqk7phtiH8WJLOIepBdNVDxf30lSVp8N9pBjwV1y09qtLmvcWvzmwwOyBZ3kRG4jZbIlskLCTAnEAOgJXUZ7zkFCr4Fn6Xd2TSSKvK0c7CKk+k3sFTH9aR2Nb4BbYrptM5kO68zV1jG6LFh4QWJMB+HHJ8PHPRsY8S86qndoR3OWa3smsdI7B+1BUjrK7PxOzjnEMi7qbg3HvUBGvuPbk27VoDOIpRJe0RFGbR2lywlJ2cwrTRnNNGl6/NdEFbjuB4iB+Sq2ly4XwSkxcE4OmKXUWYJValflcqdPJN2/OQU8Um6vQ+PufPJSpQuJBCr/gbcWut+uM5z0m0cNGgdSa0Z34GIdcWSK3Mtp8TzzIdu24UOIc9IpvG++pWwy1ZRgOtk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc2c83e4-6f54-4917-ff1c-08de130a3252
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2025 14:32:44.9796
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DYWabPbm7p1OMzmmZInEka74r0LCeSLIHO5YepOnTpvsz3tI9ZgQsVaZ2Ip6egXDP9Fmp7C3vfii/kPv3DePvztbQZAeRaKNTuLzf1VnfQ8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB7843
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-24_02,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 mlxscore=0 adultscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510240130
X-Proofpoint-GUID: iiN8qcNy-ghLoS4LJqFOXHuhZvMX0r0t
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDIyMDA1MCBTYWx0ZWRfX4WTzq+CFyW7E
 mTFeFaK4+RTEQTOJnniiMOMi4LEJp8fomflTCRrCq4t79UYbCIg6yd16XaExvsnxQ80vnsY1x80
 ClcZerifERGyoBmdhp2+hwSFqPbJupocMv1QIrpBJhtuS3wIxdINKX2H50eht+6K4XHcPcBhGyN
 6aJrx8NMAy/MiaUfGk6c7C847gXT6SRk1v9UQWmLCRDmmyKHdq+BZ43zYrB/cKY/KGLTBbdD/iO
 1ZR84MbRjZO5zAsvhd+QyfmAGELoH38uQdQFdYTo3yklEi0jbQxaTIHWKCWUGY4qSZRINTXjj8h
 108aPI+EGPv6dxcq4+t8YE2ChLOQXBvkeS7SC0Qvu3FDJnOxuEE9+81v18WXBleNSG46b1uNg7A
 hduKONh6nJMCWWgLAJ8kgDTChnRFzXC8tQpmhY08Khuu4hTbcGg=
X-Authority-Analysis: v=2.4 cv=OdeVzxTY c=1 sm=1 tr=0 ts=68fb8e10 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=pGLkceISAAAA:8 a=yPCof4ZbAAAA:8 a=Ikd4Dj_1AAAA:8 a=xPR9yz2GF2VROeTxYd8A:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13624
X-Proofpoint-ORIG-GUID: iiN8qcNy-ghLoS4LJqFOXHuhZvMX0r0t
X-Rspamd-Server: rspam05
X-Stat-Signature: u1zkj699nog5isaae41jjka3i43kcpgs
X-Rspam-User: 
X-Rspamd-Queue-Id: 096261A0016
X-HE-Tag: 1761316374-528540
X-HE-Meta: U2FsdGVkX18Og37UMmPeyFzxrJWfUbqcRG8B9O4VEaNeD5KhDbuAbjefqgmfJH4+koRLUHSKQL8L8E2B2apyashBn7eURU6891uQ2UNIZK05PmqeZb+AxvrBTrEbGQHTwujwghBcmql9VqqqELO6TfLJ/YjMd0AlZIi4NxrfNbZmEsyDGMW1Ca3HwNna9oVrHgDxIBgeg2+Bb7OWhJ1hgL1V3wKbHCY4/wZAQIgbU1bhs96ZkB9xoJk6u3CQPMbxh04r3gpCJY4V+MJifMBhUN+cJKfL5Qtji18llg3BcC3bOkNLrzND0/TGnwxMMMWgPgQ1kPPJjFQc1kBMi8rNyyygJQLvI3QBP7UdOtOX+wMXCvyQTc3SczPjg9r+JrkdgN1JZpTnNfAWInZFqUzu/NPVFbfDZds4HSpRo3hLKX1OixZudBQo4e0Pvv1uqzPetrBmpNNHSB1rRPxhWwfeQJ7ULXldxwDzZQ8fdnnGzQPiqYKNSSoCvGYr2e24RsTA5o3/T5lGwInSao0C1XKrEn2y7wvNJFSOEDmBS7F9Zgocu6uU8PGtGkatDPFqnzQWCZAPaznU/APnv7kLO0SpM50r2HBSIdbKETxzDThcpdTRVPCmCsrDUwxqdDy1ZtXCHQfuoXU6owhzWNOzD2kQVnGEloJpD8eq6oHbBq6KS8Qkx6zKTNMls/vChi1ES/lCi64xz2ZZEW9Bvs/gjHZmP3eTBK6F03c4OH243No7gD8+MWmE5hfXyFDfnQ5YjPI1/kFYxmpaCeonNPhxAAjlyUGhjaUpr0YPwRfigZBZfkmQOC7t/QwmFXE8uP+vwguUK5SeItbYnQLHQExcX/VMcT5juZuGdU8Kemz3yYgr0zXyB4XBDU+fBFfBsduxqe5oMYrHfUTChHUVn4oHL11K2/y0iRJXYIhk5+mN/jooCjso+tRot2r7pypr9kGSIjOL14ptYod7YiVxiS30rvz
 e/nIBva/
 bnU0mtrSBX0Xnn5/KR5KYpatsPPH88FceYjeFDPuh1dT+pxjr3ceQ96vZc+BgpnERVuQcN7EtxS6w51/FEhnPjCahmCc7oALYB1UQ9B08lof1uJZ6+ISFNWknKaP+8Y206FEa/8jb4Ee3AwIFM4eKRvogrBrVaQOiWOmUkH01liAjQMrWhoYCsMK2T0U3Zwhi1gykYsgHnThP71A2B3NAVcTwOrBIrneDpZMjKIuDAEW2BHnxaK8+SjlD2jzmDfxcEDGq3aoWXudE4KfkTsZrGGHmCs/BVvqY35A3gW/xhiJ37Uqt0hWiJW3xYYA13C7PWb6yM04h0l15ZbZVcA78GjDW0QNUzR57v8MNRjh4kO3RYgq8qIEPhPMOkhKvdt4WAbuiUnnSoLgXkaJCivyZpzBD5/QsCDaZDuPJeutfvqf7KyJ+oSkNmKxGfalQT9azdHuA//dIwUewmHmWq2nKrzzeyHpEu34d5QWlQtDGN36Lp8/0GkF/NBqOcx4ydFW4r0FbGXhozPWwgy3nq3XWCmFPfQOVBaXW9uDvOEiKSVFH/pMcWBntWYiGNodZXtAqqkcZUaIwkg6a80t2fEmvHQUZiumcg/sIpJwhnWgb0eLdNjLcihFpIt1x6dpOQ7D38qWEc7tVHRGcOXJKvHAQ8mRAgI6TjDhZ/l1tfa8jUzixBYuPtwCCluq2PyQeIjASFtSv5Ps9jsFo/HVlMvQbeIFmTedJenDrlqNPDTCI6JwRLkXzx5NLy7/YVBtov34BkGCdMlN0O6hkS5HWgN3QMq7jTof0CsRjZ+Ec2Py7iFpmnfJFZKoiYvrQ0g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 21, 2025 at 09:21:40PM +0000, Wei Yang wrote:
> The current implementation complicates this process:
>
>   * It iterates over the resulting new folios.
>   * It uses a flag (@stop_split) to conditionally skip updating the stat
>     for the folio at @split_at during the loop.
>   * It then attempts to update the skipped stat on a subsequent failure
>     path.
>
> This logic is unnecessarily hard to follow.
>
> This commit refactors the code to update the folio statistics only after
> a successful split. This makes the logic much cleaner and sets the stage
> for further simplification of the stat-handling code.
>
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>

LGTM, thanks for separating these! So:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> Cc: Zi Yan <ziy@nvidia.com>
> Cc: wang lian <lianux.mm@gmail.com>
> ---
>  mm/huge_memory.c | 44 +++++++++++---------------------------------
>  1 file changed, 11 insertions(+), 33 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 6d82df4a88dc..b9a38dba8eb8 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3598,13 +3598,8 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
>  	const bool is_anon = folio_test_anon(folio);
>  	int order = folio_order(folio);
>  	int start_order = uniform_split ? new_order : order - 1;
> -	bool stop_split = false;
>  	struct folio *next;
>  	int split_order;
> -	int ret = 0;
> -
> -	if (is_anon)
> -		mod_mthp_stat(order, MTHP_STAT_NR_ANON, -1);
>
>  	folio_clear_has_hwpoisoned(folio);
>
> @@ -3613,7 +3608,7 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
>  	 * folio is split to new_order directly.
>  	 */
>  	for (split_order = start_order;
> -	     split_order >= new_order && !stop_split;
> +	     split_order >= new_order;
>  	     split_order--) {
>  		struct folio *end_folio = folio_next(folio);
>  		int old_order = folio_order(folio);
> @@ -3636,49 +3631,32 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
>  			else {
>  				xas_set_order(xas, folio->index, split_order);
>  				xas_try_split(xas, folio, old_order);
> -				if (xas_error(xas)) {
> -					ret = xas_error(xas);
> -					stop_split = true;
> -				}
> +				if (xas_error(xas))
> +					return xas_error(xas);
>  			}
>  		}
>
> -		if (!stop_split) {
> -			folio_split_memcg_refs(folio, old_order, split_order);
> -			split_page_owner(&folio->page, old_order, split_order);
> -			pgalloc_tag_split(folio, old_order, split_order);
> -
> -			__split_folio_to_order(folio, old_order, split_order);
> -		}
> +		folio_split_memcg_refs(folio, old_order, split_order);
> +		split_page_owner(&folio->page, old_order, split_order);
> +		pgalloc_tag_split(folio, old_order, split_order);
> +		__split_folio_to_order(folio, old_order, split_order);
>
> +		if (is_anon)
> +			mod_mthp_stat(old_order, MTHP_STAT_NR_ANON, -1);
>  		/*
>  		 * Iterate through after-split folios and update folio stats.
> -		 * But in buddy allocator like split, the folio
> -		 * containing the specified page is skipped until its order
> -		 * is new_order, since the folio will be worked on in next
> -		 * iteration.
>  		 */
>  		for (new_folio = folio; new_folio != end_folio; new_folio = next) {
>  			next = folio_next(new_folio);
> -			/*
> -			 * for buddy allocator like split, new_folio containing
> -			 * @split_at page could be split again, thus do not
> -			 * change stats yet. Wait until new_folio's order is
> -			 * @new_order or stop_split is set to true by the above
> -			 * xas_split() failure.
> -			 */
> -			if (new_folio == page_folio(split_at)) {
> +			if (new_folio == page_folio(split_at))
>  				folio = new_folio;
> -				if (split_order != new_order && !stop_split)

OK I guess we don't need this as in !uniform_split case we use
xas_set_order() to set the order, then try to split, and if an error arose
we already would have handled, so split_order == new_order is guaranteed at
this point, right?

> -					continue;
> -			}
>  			if (is_anon)
>  				mod_mthp_stat(folio_order(new_folio),
>  					      MTHP_STAT_NR_ANON, 1);
>  		}
>  	}
>
> -	return ret;
> +	return 0;
>  }
>
>  bool non_uniform_split_supported(struct folio *folio, unsigned int new_order,
> --
> 2.34.1
>
>

