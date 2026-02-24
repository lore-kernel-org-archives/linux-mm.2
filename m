Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3D0FF4BB8B
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 21:21:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C82666B0005; Tue, 24 Feb 2026 16:21:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3A306B0089; Tue, 24 Feb 2026 16:21:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC6DE6B008A; Tue, 24 Feb 2026 16:21:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 97B466B0005
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 16:21:17 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4BBB31C2F6
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 21:21:17 +0000 (UTC)
X-FDA: 84480620994.05.F27A741
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf30.hostedemail.com (Postfix) with ESMTP id A59338001D
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 21:21:13 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=nigDeqEo;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=TKhXMo7L;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf30.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771968073; a=rsa-sha256;
	cv=pass;
	b=JLkxB5s95k+51tpQc1+5+vSfUHg3JIs30HBEVevDUtl0LnIeAN281DSrST+LxMnpO3kQ8z
	Z2bUm7LWOwdTGlLIHmRpDMrqanczNu5ZyTlOzg5YgnrNx9n6+cL+DuHPTUSyYh2QVXqD80
	b8X9MYlRfIjIFdk+6ObRbdnW8ePjNm0=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=nigDeqEo;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=TKhXMo7L;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf30.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771968073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HdquPnUdZNt4t1S/LTk23PF8lAI95/ozgsmaLirQIUc=;
	b=XVQCW2yhnGRqWKQJKcONjqignczcSo6XW/H9EUwRrWq7v6Av4N7ZM3YLjpOREHZqin1jUk
	TT4q7XiJS03mmUZPRjo0qKlWb79eLQDOZvc+sa48PIdk5hrNp2zzPdxUsbxDntH+4enSW2
	R6fWa13uqLgJHWouZ7uMz/zZohd3EAg=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61OItvYk4019329;
	Tue, 24 Feb 2026 21:20:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=HdquPnUdZNt4t1S/LTk23PF8lAI95/ozgsmaLirQIUc=; b=
	nigDeqEo6mHIRgEDb/o8xlAjwAQfj+2mt0ht8bYI2BxmQd2FBHuB9p7Yr7ajN40y
	RmKD+F1LsxXi/750QLeyGxrBvGHS1UUOeh77r4F0+JJuZEYum8BaR9QCwqQUJx6Y
	jRC7d0pMmVtO/O1TLq+tvO4lAMvnOO6k8fMwZAQVk23Dl/+kYgjW+Qm0y44t4mmp
	tZwzkeJQTmmuupvF+LN6wZCY5lkGd6NA8JbaJ1Qa1aYaEp6nrrY7SQup0wjuT3/r
	Ycg5RAmc8awhvMWaCRo3h5MTMayw+e/hOe4HN+nHWq3y+2hHDUrN7D67u691syyW
	JKTerUEc+I8DRhr1/qlGrQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf3a0559y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Feb 2026 21:20:59 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61OK8d0a012751;
	Tue, 24 Feb 2026 21:20:58 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010062.outbound.protection.outlook.com [52.101.201.62])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35eg12f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Feb 2026 21:20:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZuRe7sxmc6wqzmWvOJM5EoXPSHkUBW42vC18bXG9kvsI2afCaih56keH7EaJIda1NujBs0EqJzjsVFkbpV7RyoTZzL/RgQRZYWCK8koFoocmfgynvlX3t1aj3QdW6XBginIv1UP+T4MeE7TUDgfAcazk4X3CB/qLgYrHl02dreIcfsCklSMN33NuFwArxYxaBRN7WXNVutRUu1cn8QctKjQECCU2A02tXH1j8AxNdauuOHo/CgmVDwyJB/S5oi4o11NblzlsSIJK2S7O27cVi7ROCv1cQQ6YJCAjYYDb6z7rkV177NVTF0/1rKn0p10AfRp+DOWxrN2fAI62wV2f2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HdquPnUdZNt4t1S/LTk23PF8lAI95/ozgsmaLirQIUc=;
 b=cIsi3udFqauQUceDu91gVtBI1UKnm7rWGTiumUS8us4NgAvV3G0BDFL+w1XGOtTCfgXk3aj44QKSKPTgjTlgJnSE24pCz+JKqVSPRYmcntTOpakQxVSyBnRKxSPQIGUe3ycqIj38UjCdNugx8lUR9qFZBTaf+f7ZIVcUGUnTdQo2/zKdMAqv1+a1gNehgyoAfdYNqpOwrxiN3rjWTqsv25JKWhH/sSS8xLNPFpTCV97C2/GBnQEAC3mxnmouPUNDRsY3p0y9sHLDjEdBBZo0F+4Z1nDaVBCgN8KR9u9s8nkm/KsnlDr6fY4O+eVEkCBBPG+JINIYaX5ZlQFMyrMDlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HdquPnUdZNt4t1S/LTk23PF8lAI95/ozgsmaLirQIUc=;
 b=TKhXMo7L6euEo4Tdk6HxNRMpqYxu0Y5qC+WtW7uAW7E5Qbbr5oyhCDUO1wHI3KP7pkkp5834w8pEdhX+/xc5Q+hYlotmfTnIhCrzNfZ3qcVfCuxSfz4Vkl6CnGGNo7wwLWnPww/SkNlAWI/PnxC7qA7aTnxJ5JXo9pGIxf/+/hg=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by SJ0PR10MB4591.namprd10.prod.outlook.com (2603:10b6:a03:2af::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Tue, 24 Feb
 2026 21:20:54 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9632.017; Tue, 24 Feb 2026
 21:20:54 +0000
Date: Tue, 24 Feb 2026 16:20:40 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Barry Song <21cnbao@gmail.com>, lsf-pc@lists.linux-foundation.org,
        Linux-MM <linux-mm@kvack.org>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Matthew Wilcox <willy@infradead.org>,
        David Hildenbrand <david@kernel.org>, Oven <liyangouwen1@oppo.com>
Subject: Re: [LSM/MM/BPF TOPIC] Do not hold mmap_lock following folio_lock
 failure in page faults
Message-ID: <hzrnxlu2ukoy5rmwrztrw7nk3icswtwup24jw5nqk2h5xf5crw@e3gqxyjf2pb7>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Suren Baghdasaryan <surenb@google.com>, Barry Song <21cnbao@gmail.com>, 
	lsf-pc@lists.linux-foundation.org, Linux-MM <linux-mm@kvack.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Matthew Wilcox <willy@infradead.org>, 
	David Hildenbrand <david@kernel.org>, Oven <liyangouwen1@oppo.com>
References: <CAGsJ_4wFMm4WBM8pi-+wmgsUAu-+W2gC0wNR_UrdecY3-+5uhQ@mail.gmail.com>
 <CAJuCfpH7XEDbuAg75wTr25nLM04a8doMf5hHQZVFcpMqyok6Hg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CAJuCfpH7XEDbuAg75wTr25nLM04a8doMf5hHQZVFcpMqyok6Hg@mail.gmail.com>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YT4PR01CA0083.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:ff::10) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|SJ0PR10MB4591:EE_
X-MS-Office365-Filtering-Correlation-Id: 991196dd-914d-48f7-ced9-08de73ea981b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VisvT3RFVGFTaVBma0ozRE1wK2pxMkM0TlNvTUM1MldmU08xemtab3I2aStE?=
 =?utf-8?B?QUZXbmsxcXJUQkFCSU9hVG4rclFxM0d4TzE5TmxQdHV6UU5UaHBERjRkUnhB?=
 =?utf-8?B?TEpBUE9kTVNnOFRZN3pqSlBSb2ZvbkhhOVFQTWVHcUR5dk4rdGFOVUtPSjdk?=
 =?utf-8?B?ZHcxZnh5SjN4Vm1ETWFmOUZiRlpnTkFXTDJGdjZsODdGYy9ab1R6bHJVeVRt?=
 =?utf-8?B?ZjZZY0wxN3RIRzM0Q3FPS21RUzRNRWprSk9aN3ltd1gxRW01YTU1YlhzdjJT?=
 =?utf-8?B?ZFFsT3pnK3Nlc2RzY0hJaS8vMksrbXNmcTVmNWxyOVFEcDFpNWJWT3hDNFpV?=
 =?utf-8?B?TXMrQVMwblV1MXhVamNwVlRpdGdlVXh2NGorNEMxMjl1YTF3bFhpbjAxYmhh?=
 =?utf-8?B?WGtDcXp5bGZKeGxscldYdnZFNDZiYW8rRkxIWVl2QW43SWtpRk1uWi9Qenhy?=
 =?utf-8?B?RXgwcnc3NFN4NDZibXZHNis1STBFSWVNQXA1SkNUV21WQnFRQWFKeUNzYm5C?=
 =?utf-8?B?eG11K1RvMWw5WGxHRjRFN2hDR1hLaVpTZUpKWWRXdTQwSWFxa2NhUTZwTVNz?=
 =?utf-8?B?K1FnOE50V05qbXhzUUdIQlVJcnM3azg3UnV1WkxNZ3pkc3FhdWpNK1pqc1F5?=
 =?utf-8?B?WDRSeHYzVkQyYWdrajBvRC9KVjZiVWpiTjZNOFh2Z0lWOG1MalFobWVVV1lL?=
 =?utf-8?B?Uy9DZUc5QWdXcjdIS2JyQUhYcXdab2ZUOEdEc0RwVWxLcTVyUm5jNU5EUVl1?=
 =?utf-8?B?ZTBxZng5bXkvTEp1Yit0cldkakxlSXNycG43akp5RExDVG9hOHEwejdHcElN?=
 =?utf-8?B?cTFJM2kzR0o1b0lrV2ZKRFRYdG9xc0RaKzBHcXpHRWVvenFtRWFwdExxL3k3?=
 =?utf-8?B?djJWaFNlVkdnSEd1eTRLQ0JtM3V4ZitZTVdnK2JXNEEyZDNwYWxPeitpNUJk?=
 =?utf-8?B?d08yVk5MZUh4OWF6ZGVxOXpralRqQnFlN1JRS2FZVzlLWHBLZWptY1dqYURm?=
 =?utf-8?B?aHgxdGJ6eU5ETjg4QUFiR05FeUdvVCtYRTBDL29uQXFRL2p1bVMwb0oxQmI2?=
 =?utf-8?B?S0tDR3hCNmk4NWQvWWVtYVpLbDhOWFp6RFdYOUlxSE56RlFKbFVDNFNBaE5l?=
 =?utf-8?B?bzIwZGJCS3BiSTJLUTFUVGkxTXA5cENDd1llTUsrUE41V0N1NFJnRWZxZ3Vp?=
 =?utf-8?B?M2dBeTR4VGRUY3ZqRklTbmF1QzFpQnU3dys0b0EzRFplc1pWSWFKUWdTSWph?=
 =?utf-8?B?TFpPa3Mvc2FDalJmdkJXTk1IR0syRmI0dnJEUVVZZ2kvM2F4WVo5V1Q0ZDVu?=
 =?utf-8?B?V2MvOVhrR3FXU21obE9Nbk9yU2dTSVkvbk9xMCtPNE5nYTZTUnRDNTNSYk9T?=
 =?utf-8?B?NWlTcWk4K3pLUFJ5ZXR5dm1aSDZSYjd4VHkzckZZK0wwYjY0ejl5NEE4eldt?=
 =?utf-8?B?R0lLYitLTm5IdFcwL2tteWZnTC9MWFE2ZjQ2NFlNOHBheldEWng0WmpuU01G?=
 =?utf-8?B?M0tsSmN6VnZQTFBmdnNlTDh1T2lLdk9xaEJQNmkzTFU5QTgzbnF5SnBrT0hG?=
 =?utf-8?B?NnY3MUk4ME10UzRYK1RlWXE1VGdjc3ZlQnNZZUYwTVVnUEMyRFZjcExFU0xP?=
 =?utf-8?B?RHptOUJsQUdmWGtQMkNkTzNDazh5M2FkTjd6Y1k2ZGhTa2kxVDY0cEFjbWdF?=
 =?utf-8?B?dEc4S2NSUnlLd2tWcHJkRFUzNjdDMU1lUHhVMjQ2eUJMMFRuc3lPL0VqWlNo?=
 =?utf-8?B?eUpsL3JaR2xxNDRWOU1hSyszT0tCV3F5LzlNSGRIN3h3OWlIc08ycm1CU0lY?=
 =?utf-8?B?RzVMZmQ0UzdHUlNYVVdNWEJHVkU1WnFMT1A5Qmw5NHp5aTYvZXNiczhwdXgv?=
 =?utf-8?B?elh2T0ZJcmNXR3ZjTmZ6L0p5eGNKbUsvaGJ1UGVQWkdGRFg4Q2ZkTzFMYWNj?=
 =?utf-8?B?cm52QW5JR0dDQ1kxOVZNc0tUamYwQWdDNXJaOFg0SGw5UXA5SXRWMFIzSXlG?=
 =?utf-8?B?N21oS083K2NQN21KclN4bmFrckZNcWZMZVE1M0doVWJVV1FtRmdkcjJjYmVH?=
 =?utf-8?B?NUhrL0loN045bFRhYzFMUGJ1b2hra2J3ZmR5TXZpdko4Z3VyOWthakI0Ymd6?=
 =?utf-8?Q?W6Xh4TCuaAeeN8wPI7fcTNO5Q?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VExxNW1XYy9RRnlTTHA4clBQSkYyblhPMlVJcUkxVyt1L0hFSlA2MFR2ZGNs?=
 =?utf-8?B?RWROSGlpVU9CdGpFL05MTnlLeDYrTmZnVnpQbzFlRUo1OUNiZk1zdkt4TElh?=
 =?utf-8?B?R1ZnRW9XT2xLamZ5UDJxWmdzSnZqcXU4SnFPRGRzaXFXaWdtakd3eDE0RElP?=
 =?utf-8?B?K2Evc3FZUWdUYUkyRU1meHNCRHJHYWMyb3ZqcTRwQUZVYUc4SXJLQlkyWUhy?=
 =?utf-8?B?OWRDSFBxNFI2Q3VwZ3VZMWhnN2t4ME81TjhMRjdUK2IrTURKdmY1azFpMTlP?=
 =?utf-8?B?c1RrNno3SVIzVjI3QTB3eTJJMDBtUDZwOFdyZzJvanNGc2xvNXJQRVBUQlli?=
 =?utf-8?B?eGZ1THlsRThoSG9ycnpySHlVYW5FZ1ZYaWY3dXZ6UjdLQkZHMndyM3ppdC9H?=
 =?utf-8?B?Vy9jYm52citSVk9rV2ZaRzU1SGZBME45R0ZWNisvZVpFSE84ZmtyZU5DZzBX?=
 =?utf-8?B?bDF1d3ZmckQ2em8vU294WDBUdWUzQnBIem5vQmo5NVJvN3JpcVM0R3FZdC9H?=
 =?utf-8?B?N2RCNmROa21GWk0vUlVEeUR5b1VpN1ViaFRlZHdGcXpKQXpNRERCZzRwTStX?=
 =?utf-8?B?QjNRaGhrY2s4cGRtdjBFR2ZINVE4S0o3UGpueGczaGtvMDhrOUNCcVFOU3M0?=
 =?utf-8?B?QUtRL1hDa0p5VFh0djA5YzMvekhJR01LaGNFSVgydUVKanVBelhTQ0c4TFEz?=
 =?utf-8?B?SUt6TXo0dnVWZWE4T0FaZXQrZ3poa2syeFFPSjc4bGZiMVBRUXVlUjBPNm1w?=
 =?utf-8?B?R1JDSU41d0R2TEYrZ1ZhakloMXNFVzhudk1xTmdNOFdjWTBKL3k0SjF5U2lY?=
 =?utf-8?B?MHIwUTFCUk96cmRmMTV1QWpmM0paY3p5aEVLMTdoM2dyMmNrbGJJbmdJWkVn?=
 =?utf-8?B?TWVWNmRHeFdpQWNLM3dWODR2OWx0K2lHWGl3Z21wM3dNMU9xTjRHOUZHU2FE?=
 =?utf-8?B?T0krWFpQUGxVOHhTQ05PemhQc3dmK1BoWGZzVTEwUS9USGVZMkNpdTVKbTJ0?=
 =?utf-8?B?UkZhYkJvQXMvek5OUEVpaG96MlkxZHVTeVY5U0ZnYThDYklVeERDaFdnV2Rs?=
 =?utf-8?B?M0htaUE1c3cvbFZHRUc3ZjRSU3RWaFRBZmhVVzkwMWdFR3czM3F1WW5qd1M3?=
 =?utf-8?B?eUdYRVBxR243bGpaZlVpRmFheERsSjkrQXJ3a0wvV2JSSVdXOXVPd1RNTUpQ?=
 =?utf-8?B?Nm9zSVloTVZtUlBJNzZDcFQrY1RycmdMcitCRnVkZVdaK0lLSThzM0xtVVNL?=
 =?utf-8?B?aGwzNmdCSUtVNVoxbGg2MVl0bEdOSzgzR0E3THgvZDN2a3RLR3V0c2V6eXVj?=
 =?utf-8?B?MmZTMU1zSTBTem4yN2s4cWdsZEdMZlJlYWRpMnA1RW9WSWx5YVo5RkMyNVhy?=
 =?utf-8?B?WEhxbi9UOCtreTZ6bThhSnBCeVJHNjZ2N2piVnhXNWdNcWFqZzgwRW9PL044?=
 =?utf-8?B?bG9lMVlqbVhXaVpPanE5dksxL2NMMndUQXd3S2hHblJSSEZadDlSNkkyS3V5?=
 =?utf-8?B?dWxTUUUrWTkxUGQ3ZmtGNTFOUEZveitaR3ZZbFRuNVg5ZnNWYzRoWWh1Ly91?=
 =?utf-8?B?VWNKNGZIUWI2NUJ2bW5WQ3hLMTVQQS9WQTVoZHdxWXkxSEk1aWVJMkJsNkli?=
 =?utf-8?B?MHJINldsNG5qUlAwcUhJdzUwdHczK3RkUzdiYm5jS3dGVysrVVNCc20rOWM3?=
 =?utf-8?B?NCtPcU1ET3hqY0phZTBQUUVpZCtBM3lYTFdrWFhyUHIwTEdocktrQnZzUS9y?=
 =?utf-8?B?SkZoN0RsR0VqQ2k5V2VyWkpHRGF1N0VQMlJRaytaZ1dXNGpwV0FFM2NEZWgx?=
 =?utf-8?B?d2g4a3plUHFheDREenpPaHU2TU9IbXI2VDZlK3p1WnVRc1l4WmlMcDFlQWkv?=
 =?utf-8?B?M2tPekU0V1p0SVRPTkwra2lRcEFzUlRnaDFIeXNtUG55eHZqWnVzMlc1T3Zq?=
 =?utf-8?B?T2l5c2NNdWJWTzlSU205UnU3MllsZk02TXRzRWMrQ0hRMEtTRkRSdzkwY3Zl?=
 =?utf-8?B?ZGJqdzN6WDZXK2g2Q1JnRGJkSHVqRU1GaUtYVU9ZZXB5blQ4dkFxWDlycDlm?=
 =?utf-8?B?aTdIUmVVeWZNWnBLRjIrSjlEWnVwWVdnKzJKUUlzSVlJVm5NWVovSmdoV1JE?=
 =?utf-8?B?ZDkvMjVwL0wvRFlhdnJOOFpPM0VyczFOMG9LcXpOV2JqbVZ5TDloSXBScnFx?=
 =?utf-8?B?YmJNRlJHRFFkQlB6ZXFpM2pQNm13TjIrZm45VlNvL2NRaDlzcEJYekdjSXFT?=
 =?utf-8?B?YUEyZThqRXhGY3UrMWMrS3UvUjB2Vkx4NU1pY3VFTXNNWFA2T09MUWpXY3ZO?=
 =?utf-8?B?aFg2dThkR2QybEJtTXhKN2l2a2N1cHorenA2dThYajNlOTNueVBFZz09?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	yZRmllthqnESLs7kMcoV+QqutyraC1GLnSD9NsFcJ9eTeEYaQVAcLnBI/McWTAmSlyfHWX20wygAoM+eR99scWBhhCfcQufoZaBw438x/wzZcTgpx16J8KwlXGxrmHv/He5uAorLQOF2F+G9fUc/8oUZKREefj4f69Cdw5chD42l3Km+hSsFT+9mG0PNx1ZrXhL5e9Bugu/dOsmT2y47rWpU7Z1kHXdQ/xpxPwFUNg5NUW3zhXXkUdGdgEfpiKOmK1MGtBQU3psfgvz4tKpZIdSyDS8lANSA+RMTduPda/pXjUWH6zCH7fbQRUuBTKqjI62TA7zIgEuhIhzhpSfLt+su25ZQ+vPe4Pb2/4cyltO9wUR+uaPxlzQBlRP32Nt9iMyAkbDeet6qdQ0/4c10I42Fotv9Uiou8Alk3sGpQR93plOSApvCG4S9JGtoafXGnNe7LNz2QWxzD47+IxRxgUM7HjJcJFBDw1ALxIY1GpjoaOaW14MQv3zXTfxie6JgevU5yrxruQLZ8MbUq4drdgoNqnT0MflEImPkeNCtKKzqdeQMApcS+OMT883gmJ/wQnuWaQ3EdpzdjaJWhusH+QtuTxqdKqCCWqFRbJ4dv0A=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 991196dd-914d-48f7-ced9-08de73ea981b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2026 21:20:54.6306
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5I42vWULTAtUaDD65bfQu2V6L2OmLzGY8ZJMLNBIESltDWb0UYNFNC04zvVbTyVsc1mXWnuLlDxmW/fz+TZJ8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4591
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-24_03,2026-02-23_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 bulkscore=0 spamscore=0 phishscore=0 malwarescore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2602130000 definitions=main-2602240185
X-Authority-Analysis: v=2.4 cv=IskTsb/g c=1 sm=1 tr=0 ts=699e163b b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8
 a=pGLkceISAAAA:8 a=A2pY-5KRAAAA:8 a=JfrnYn6hAAAA:8 a=1XWaLZrsAAAA:8
 a=LmnVNd84e-f6OKqGCtUA:9 a=QEXdDO2ut3YA:10 a=1CNFftbPRP8L7MoqJWF3:22 cc=ntf
 awl=host:13810
X-Proofpoint-ORIG-GUID: JUbfN-SVPxpA8kAiWniPfKXLQKXTk1JR
X-Proofpoint-GUID: JUbfN-SVPxpA8kAiWniPfKXLQKXTk1JR
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI0MDE4NSBTYWx0ZWRfX3Sv2y8PuA9z0
 HNnEwJMac6UBMDd+BmJpG8xAsD+KjBYFLRfm0z7c25+acifIHaA/EUEzmmgCsWQFu8HNZSg8nHM
 KfwCrxoxsia/Bqdu1tsSDrD9tYnfIw5Di2XcB64Y4wXmuBmkft18ELtqte0HHMwKwDRoLk4oKnO
 DkrMhh6dPHq/sCB7REypLX4fZLw3bgWBfZzFPL9FY1M3ou/VF9qvdwbztgr8X9UGZAF+8o2uJQY
 itzabk4Kgu+SUZuS8mQsqJWWdsGC+xegMUD3KvbZRANLqc3hBhV6YW0Mo/8VvJRiDHw+XVm12uh
 FwA0VdLl1VueW/L2mZgdO8TzQ17pMnUMNaOSL9CkIrl2V4Wru6Tno4RzPFN8AUBoKSIilmXaq1I
 0pG6YRJuNGc2OG6b6WBCbxv0sJ8R7lxBSASegqUkreajQXCSjNuSKeu+zWtXhbBByZ/lLyNAy4n
 u2F/RDpk8O3NlQZN27xzf4PycdaSj/6SH+xsogbk=
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A59338001D
X-Stat-Signature: jr7869zpnktooibfh9y57tuweb7pntd1
X-HE-Tag: 1771968073-302935
X-HE-Meta: U2FsdGVkX1+W7YRmw/bI7qv5tkLls0yybc09Gw3aq5m3m+svlz9UFWhpdCzpxypNSDBudouCUdKT+iVazD0Lw4JqYa+9GIxDssmdbVlNfvmoe2yAZ/1W081B/pYfYQdBucVVP3BDINj2BYUhnKBExlg5qtFREiBEj1V9nGUD2tAyUnJLn4c/GHOtQRzFT6C7Oj9tEkdjWVSfP/O+92VRzrhAKyGFyUhgkCyIvw7rnHL41G7ooYobqJS6HP7LNu88o0ayPjUPUBucNVksSKpYSqkW3pLEzHqZMTXzrPezrKw2OEExeEpiiCdfAXjvkjfzaDSy7en5dt+cw6LTKO1hy+y0irEPXRkzvkSfaeDDQHTpku5jWRb7fpHmv5VKHyH/k/mLJzlYGTnSRnlGlnloLGyHWunjRD8IWGmZn0m/rO1H7qeIpBUP0GJCyiZWXkw2ewb+F3HLKg0Ianl6WKsZEg6vtYBAOnQqHeGRJUYwYq9B3aJQHadxVSwG1vSomGviSZZ205dUWthdZfh8iH3piuPCs0ijUWt+2wumYHlOwwawTuPHuF+wSIwmT80VqyvqiP4fYfHaKfOhtcA0Xdc0pw6Im9FOOcNQWxfW5BPw+XxHt0xF9SKKlwqNC7zEcdFnBxD/IekzeVvQ0L9BC8lCssTYIJjnpeR11285qEpQX1m7l2LvCCCT2BlL4RrPp/OgpAD4GkKR3CYVjUJ97Qk68FaUG3GlV+ZJfdzfwQDIJmnudkaxHFwYb1jgeRZNJ0NAcW+cHIbmRb5QWWCQ9u30vgAjJM5gtrOCAv32YroF8P70yq5qRsCIWCx9RlZe3Ib87Q6JXmxWp8kidEhvE8Qm+CGZv32gWyoORIfQ9YEKVpp5KyIx7CGirdWzSsdzEMfK0wB4D1wdd+9XIOScDJorvSwxcKDKO0mj4flK1127Yb5EYzqHk2E2PtwY78aJYGGpKtkEeZKLsM4IxYoX4a3
 hODXsatK
 SFJyAu3yeY5DUtG+AaFz3kBQ/qXQbu7SlM4htEjWRalhjyCQ2uOO9lzjn/SEHdIvw9LXsvEv35nYWtc7dGbR1AnMh3nmb2fotLuVbRsuw+fpj9GS5/hH5kwkj2zC3xQKzTKqEjP347v2bYs0z0kw//8qCY78XAZFVSyNAWoTGNq0VNZD77ziWJQ3pV4D0wAwzM8VbFDc124FXvpJeo7pCJUhJDC7+f4uY3SK0rsI7I4jhwNHqPjL2wNA6UHSBThCwzVI5deXtXAvbdOcX/DjcU+xWWlTh6gDlISHMQ004JfJWCKT18hPb2NXHa7c8sgrg5Rii5tDQipml3dQJrES7Xxoh/aGlkNSg7Wo68yhNS37YJfv/mOZt5pQd0ninmUIaSvN3VYC5fBb1bqFXNjwlifmTJBrnLL0B7iq29VackItqP3bAzIOiYSK0zk6/4k6MTnvGGpgMQcUVo8t96lirAim9mDx9wvfCm8O6oDsY2jR4VlfHb+poC9VV+7vNxBxMQN8OLK9e0QcASlVnxOpHrP4rvfDIVunFOanZfs9xGzb0NjC7KUYP/yh1F0sle09km6YEz6PnugF/MiyAsGt51qR5NckKTgM+Z6A0dXSkZ8oe/be6Lwown/mSp2nLQQ9JSFoggffFYzHW9/bDplG6W8pVUd+majaE3BGJveYCJp9+BmDx/JtqGCZPUrH2A9g9C9ot0QK0zE6HzaP+mUCcHTzNhxUmaS5408ZoDvP0c4Z2QtHZRk/oLlIrPod0TeB8w6EZq78+bb/dcwzypwlGygpfpQeD+LoJhKAx2lkNRoe7hFPX7GZleeVIlAdCsaToKLfw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Suren Baghdasaryan <surenb@google.com> [260224 12:14]:
> On Fri, Feb 20, 2026 at 2:13=E2=80=AFPM Barry Song <21cnbao@gmail.com> wr=
ote:
> >
> > Currently, page faults use per-VMA locks whenever possible.
> > However, when a page fault encounters an I/O read (e.g., in
> > filemap_fault() or do_swap_page()), the handler releases the
> > per-VMA lock and requests a retry after failing to acquire
> > folio_lock. On the retry, the fault handler always acquires
> > the mmap_lock in read mode unconditionally.
> >
> > This can occur frequently and may sometimes cause UI jank due
> > to mmap_lock contention. A proposal suggests using the
> > per-VMA lock in the page fault retry path instead of taking
> > mmap_lock [1]. Oven reported that this can significantly
> > improve performance by reducing mmap_lock wait time [2].
> >
> > Matthew appears to suggest removing the page fault retry
> > entirely and instead waiting for I/O while holding the
> > per-VMA lock, noting that folios under I/O read may be
> > reclaimed by the LRU under severe memory pressure and
> > with thousands of threads. As a result, folios might be
> > reallocated, causing the page fault to repeatedly re-enter [3].
> > However, holding the per-VMA lock during I/O wait raises
> > some concerns: writers could experience long delays.
> >
> > On the other hand, retrying with the per-VMA lock may reduce
> > mmap_lock contention, potentially shortening page fault retry
> > time and giving the LRU fewer opportunities to reclaim folios
> > waiting for I/O. By the time of the LSF/MM/BPF discussion, I
> > may have already created similar cases and collected
> > additional data.
> >
> > Another potential optimization is to remove the page fault retry
> > without risking long I/O waits blocking writers. This occurs when
> > folio_lock fails but the folio is already up-to-date. In this case,
> > a parallel page fault may simply wait for the simultaneous PF to
> > complete the PTE mapping.
> >
> > I would appreciate feedback from LSF/MM/BPF on approaches
> > to eliminate mmap_lock acquisition in page faults triggered
> > by folio_lock failure, for both I/O wait and PTE-mapping
> > wait cases, for mainline inclusion.
>=20
> Would love to participate in this discussion. Hope Barry can attend in
> person this time :)

I would also like to participate in an in-person discussion about this.

...

>=20
> >
> > [1] https://lore.kernel.org/linux-mm/20251127011438.6918-1-21cnbao@gmai=
l.com/
> > [2] https://lore.kernel.org/linux-mm/cccf352a-1a68-430d-83fa-a14bb5e374=
64@oppo.com/
> > [3] https://lore.kernel.org/linux-mm/aSip2mWX13sqPW_l@casper.infradead.=
org/

...

Thanks,
Liam

