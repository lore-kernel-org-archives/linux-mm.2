Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1446BC79FA7
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 16:29:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C7CC6B0189; Mon,  5 Jan 2026 11:29:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6886D6B0191; Mon,  5 Jan 2026 11:29:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 540056B0192; Mon,  5 Jan 2026 11:29:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3F9A26B0189
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 11:29:50 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E17DF1A74D
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 16:29:49 +0000 (UTC)
X-FDA: 84298446498.20.E28B6B2
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf08.hostedemail.com (Postfix) with ESMTP id 9052116000A
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 16:29:46 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=sU8fCaDJ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=l00XOJmB;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767630586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7SddRL1MUSOvUVhZVD+gry5bSW0fjoOSzD4QgIgXh2w=;
	b=LdP+8G9PJjkZTDGyzCR+zwteRgChlPy9jYGP8lCdIYN5uT+kHT4LLVtS98RVAt8eNEe4h6
	0dvmncaCPKTfJlQZDWJ1oOaCOI0kOVd257l3G2Ukpho2xgVna9H4AdwEeqQyaMQOGNbb/9
	S4i1GprKYx8SROTcktA6+whWaeomC+w=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767630586; a=rsa-sha256;
	cv=pass;
	b=4DNTRHphf53tWi1oO526INmwgAUqLkxED9IKn2n8YMyqc+CqfoY9CfI3lTR/KmtyrHbdLZ
	TR6r9cBhVhM5ijujJWIKdMPcUZHlpWKzJHHwLkLSwl8+3pxvbtnYTO/ADlrsPXdF0aDjfL
	RVbayW9Ssvl42BT2ccvtA/N9xJF8ZPo=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=sU8fCaDJ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=l00XOJmB;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 605GAZs81860181;
	Mon, 5 Jan 2026 16:29:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=7SddRL1MUSOvUVhZVD
	+gry5bSW0fjoOSzD4QgIgXh2w=; b=sU8fCaDJMkuIPeTnh5/WU68zUPf91N/824
	IX//q+GT79e8VDRyImPu1UCMdmEASU4RLp2AnqsRxzTDyR774SQZP5u50UcqJipZ
	HKUn2Hi8Z9bY9mThhPrM7miL3Ef0w8FNht44ZtUpi/rqJXqz3XVgcyESll6/DsBY
	q51oNZLHrHifkUStHji9KtLVWM5dg6ktL/rGSXG2H5FebnCe4WyrXYxeslJOVaJf
	fA12MPMvDTmsSi394syoPpysWh4qTkXiOTmrNrOL7u9CmdE6mvxH/cXeH4lZ6RlL
	i2xgK684rtzkbwx162msghSi7fB01QozCyKE9SHYhvxajiFwpTmg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bggkdr186-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Jan 2026 16:29:33 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 605FPv6t026581;
	Mon, 5 Jan 2026 16:29:32 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013005.outbound.protection.outlook.com [40.93.201.5])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4besj7a8km-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Jan 2026 16:29:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ybfcloIZ2cqiascauLBC8ZA127HKx63WgQoyoSg3ky9FaZMEqlihzmyUoG7vrPSFG5/UGMqvkAOQcPmlHEyKwv9ZcHxeCW1gXX6c+fnbuAF29M0aGs9tcHXnz8ipT7126AXaHDkJH3ZJ/xYPSf7LtpVyTR+w9lf7iBmEaSnqqpNOKPhr7xeTRovOoVlyVv98APaVxrX1dFr3s3UPT26rlrkNWKiiLTGoS2v1ZbBuDgQBYwlj1zasuZLzwjGMJCkTqjDV+hpaSPbdqpKzaEw+suXXyflhVIpajxtjWMDO95B6+YfHDBTta3rlpC0MuMsCfNrhp0r2F6gU4O/EaTwRsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7SddRL1MUSOvUVhZVD+gry5bSW0fjoOSzD4QgIgXh2w=;
 b=i0uqTiQ90YrhAL36qlVuYqDrsFSCzfmcWkwgZ8vwHYud0hRvWO5ApwnnmLw+vZ/mlGBgz7ABSPpnDomSpR60idXOmH9YPoJAS3BIZiDZ6/bFbh47/zXzFB2zCInfHVnZfGk/8E2b2ifzUvDLZSiI5iNqlLrtT6vNbVYkX54+Kazrx4dnTkC+swkf53btqXi3voJQxsJeaHTlqVLgvafjijv4+p+neNa2+TfzCliVXccgLUY+NHAjEVsADZhPFgbpP66qXxW8JyQeaA8Z//kX5Surb8L4ZoiGEIfFmzLou9IJ+CqXiZAzikXFHA6IbClQRGQ5fullin3TPdIJsWojlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7SddRL1MUSOvUVhZVD+gry5bSW0fjoOSzD4QgIgXh2w=;
 b=l00XOJmBpq9kjJynq1VIRxXvw2l/R+Hx0OHOfxIUdI1vZCtW4bxOBUZ4kkYfH6tx0mnfyOO2FHtqbnt3LGNkD7s3iSx6Xsdjr+j+zAa9qECSqCnwsl81jkImpAdc4nlQ6dQm48unXbXeZgesEM8nWSYGU0UMSKnSVz/vIvl8+6A=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH0PR10MB4776.namprd10.prod.outlook.com (2603:10b6:510:3f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Mon, 5 Jan
 2026 16:29:28 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9478.004; Mon, 5 Jan 2026
 16:29:28 +0000
Date: Mon, 5 Jan 2026 16:29:30 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
        ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
        npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
        baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org
Subject: Re: [Patch v2] mm/huge_memory: consolidate order-related checks into
 folio_check_splittable()
Message-ID: <38555ccd-c241-4781-ac8c-ca50e1de7309@lucifer.local>
References: <20251223122539.10726-1-richard.weiyang@gmail.com>
 <20260104023756.jufklyl3bl64fnck@master>
 <7ca733d2-ba0d-4792-bcd8-bc153e7b1b15@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7ca733d2-ba0d-4792-bcd8-bc153e7b1b15@kernel.org>
X-ClientProxiedBy: LO3P265CA0002.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:bb::7) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH0PR10MB4776:EE_
X-MS-Office365-Filtering-Correlation-Id: a5d374dd-7a06-4f95-59d1-08de4c779890
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?hS5f2VOjDXFFOQjR/lsCep/HHv06Gf3ukQ8MweXcEWJRlGFt7aeE0zqcVqsq?=
 =?us-ascii?Q?x4Lfs98SA5OVgDqVw9PRQla1DKkHJRBtSWmnTqXkzPmSggy+Kexx/ts8CVyX?=
 =?us-ascii?Q?KilpuJykg6elEr7g/H/wjyLMfYWUrBFPl3rEXzB6FE1PXur/v9fY8/Aiw4KT?=
 =?us-ascii?Q?xUzJHznP9N5JOqCQfgf2rPeaScg/2EYbcLx/AECC/zoRgcvQSUMB+VRnS38R?=
 =?us-ascii?Q?+weLU2iVMuS4tABolpdulw0uxx0jlg69dQ7i+ayNXB52iDLu+MO/b67z2i71?=
 =?us-ascii?Q?QnAaVOBdaX4KL6pCUEOV2x/9TwT11jAzCPNldCFXpXuzDcSI3z+wbg4J78tA?=
 =?us-ascii?Q?b3BgVfO3WdWJBM4vqbGQIYI3ICoWcPp7UOzn0d4H5TnvX0dSJFXzYT4XWpoF?=
 =?us-ascii?Q?NtEjFzv3LlZfRtqNTHJIgVijTtJ16yEbMKN8+UBNyOmjHVyO9+gZUOWJ7kuK?=
 =?us-ascii?Q?JEcedgURcYaSTSchxrJKAtnqU6Nu+ncLSYD0BAnYYPbs12UELgwTkNZpAnWa?=
 =?us-ascii?Q?wMzWDKOZZZz4yoK87ggGT+94adsYI/KAXjaLkDaawGzjHyjkxsoAfhXjhmYL?=
 =?us-ascii?Q?o8zcTPTHFF/7f21El05kw7h70R3UTONt9zGGRPdxLz0Kivi5VVGLsoSFmmpV?=
 =?us-ascii?Q?3ydgSnV73JDFB7jy2xxeiQflPXn6A0xoD2P8MplmNeDbn3aPsLrwfJkjw8FC?=
 =?us-ascii?Q?Efi67NwBWVEiscScsz+trMayI53V/t0H9e0sJCwy2kWgRGx9ktKZHU43tryA?=
 =?us-ascii?Q?cPFi62XoFIkaoFINFNMQWP6GObPy+H55LLscRsaMbl9ebAPZJMHkBWHBeA3W?=
 =?us-ascii?Q?UxKXgbOG6UWshx+279GIhRzrVR33OkYKeIu0dLNPSbs1e9zWFy2TvQypqjtk?=
 =?us-ascii?Q?nr83Ki4SIK+ZoaU1e06Wp3kGa6aWvzos58X1TPTN7ZSfpsTTvfxhcQvl24mI?=
 =?us-ascii?Q?uttL3ZkgkChpKV7YrxVKjYV9+U4B2RVDuUohXLYl6cwLct1h83q/K/wj+yt5?=
 =?us-ascii?Q?O0vOhwMUWGkdmWFAMWLm3LTMa3bq2mZU33QqoxFNnyZ7c7xI3oMMUh3tsBCE?=
 =?us-ascii?Q?cteNSSRGdzfmJOAx/DcAj1Ebpmf6UuCb9UCM7lfqmj+VGDg08okAgUDBQng2?=
 =?us-ascii?Q?qYXkjJYB9AT5APoB7kP7ew4yq5WRQaMW5BMMENDNElWDvjt3A7En4vTxJgMi?=
 =?us-ascii?Q?0a+VRuX2115xdxQVtC+6LeY5Fy/hP5jBcq6WyxsFplgqavYERK0/DZqlOciV?=
 =?us-ascii?Q?w3x67fsC2AgfGJUUr/XJj32qhVTaifDhv87LqpSpOtpjiPa8Dt3f9XPX2BDU?=
 =?us-ascii?Q?+p0z3PwbHT/QySH4j/PN8U82ncDcW0LmRo01HD3kwAg6tgFM8I1zz2EUMYAX?=
 =?us-ascii?Q?NhSonFtXPDYnv+MF/wdP3yi2iMv4vWk2b0uvltVnnlMEHcmX3gaIecvsHR+0?=
 =?us-ascii?Q?7odfTuC3j5G9Ocpg6VWWmV/ug+iIZi+mL0lREIBeNDICX2dc1IPa1w=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ytDErP/rtmvB93xEK2nKz5pD+ULgxw6u/pBWL36We3uq9IsF2lhwrlinEpIn?=
 =?us-ascii?Q?ym2CnD/zo3tFsMMt3mu5myjM1ZrpsUh4KiwkWOpETKd2At4bogv4QGKY87tu?=
 =?us-ascii?Q?+Y2K/T9Elca9V9gaqpEndVfJSkIYJZt+/q2DdOue34nE1kRA7PXITVPMoT2e?=
 =?us-ascii?Q?hW/D2I+en5VaNTSI1KvLiZEMZvywNbLqakDaGjz6kscsDm0btSY3XfNUBQjo?=
 =?us-ascii?Q?BhcvxjocGCC8TvjZ9ZmkOxbGk8Ic4H9xt7V4/UDOHUEPRnbu6w5elDcV17mt?=
 =?us-ascii?Q?ykWFxpwbFtVIc+m2HwLbcw6sW+xN11P1Q4Bhu9BmOnJbdNjgnzZk8+ZvmaUR?=
 =?us-ascii?Q?2rUPduu8PPgWF0v75e+thOXuN0uN6/9r8ZoMQJEOmrMUtTQ3TIPSG3geLkg+?=
 =?us-ascii?Q?FN3mtnIsTPOhGjog7zDpWEzKXnnna0WcxSgasPhSQwNS2Iw8RSKZcEBdiAfm?=
 =?us-ascii?Q?FXaHPo6QwGeaktT15PtfSGdNtTh2e4K2G7MdOkvWqnf0kwsdUfxFKeIotddX?=
 =?us-ascii?Q?S0AuVyfIwOH14LrThZUtz5g4l5N2p7iakZP9EC9cWVvVeNjYCw6MFnVMqv6k?=
 =?us-ascii?Q?KSgqMp7Spac/7uznrh0GFY1+xgWDt/e4iGAFVScAjU97zDevH2ZwMfFnpjQ5?=
 =?us-ascii?Q?Fqh3Y+6f1KodB1AIyirPRiqpeZ9zCUCYm7GneH8mvUUiTH9Ox4my0+bemtw+?=
 =?us-ascii?Q?QP2L1b1PLcLucUNSrBXZTlX7ETlmrE+056eiO6pSREoG598wCf27JbDfDR8X?=
 =?us-ascii?Q?Fcip4E5fGzJ0wp2mqaSzxpD6anQs3PF7S7EadRwMa6x7bKL0l2uDbVVBSaZl?=
 =?us-ascii?Q?a2iCdBDylaEK4/gR5KHkg/be7qlv5LpceY+GrVcysaWxODsqsaa+mmIlZbLm?=
 =?us-ascii?Q?DKXj5cWfO51dpQQlX8FQJ3sGP+QJBRp/tHz/u8U+9aMYXVEPevS4yAtcqKv2?=
 =?us-ascii?Q?wc+3b0f1Jl1P4z3J9Dr0nw63JSvAahUO7N1s3UZyuioiyEVyuBzfcygVINll?=
 =?us-ascii?Q?3mxEqmJhbXuWEz43r0OqmA354OJxEpt4u4CMFBYPNBoQACtpD/wCbVWwfGQb?=
 =?us-ascii?Q?CYYSxDeXq0nbpLGnnegRPdciS33ujE1veuuKxElrEXg5/6KvZne3r/KPzvuJ?=
 =?us-ascii?Q?gQqmxiRVK3o7J0o3udMxTDcjgCwok/Hm1Q/I7xjoQrS+o7g+7p47P+ajL7p4?=
 =?us-ascii?Q?Vbw8pfZOgHIZopV2PFgw4nT4DCZNyayKXgy1gKXTWtpQMVw/r1KcNovSLmy3?=
 =?us-ascii?Q?UA+g1JKz0wdT/1ni34/JXdOzD5qRSOiLdQVjLaQpUkbzqrSbrSm96u8Puf6B?=
 =?us-ascii?Q?Wostt47LX/iw/z/+f/ocJ9IO0xa2K4ZYFeg7yCtfr/5l7xHdT+bkGkX26Bbl?=
 =?us-ascii?Q?sAiWaX/kY3tMBDRhOkKYoePaJx6Xf+RJcX/bFwmk21LgMV6+KbVZbjfxkwkC?=
 =?us-ascii?Q?x7NR34yMsqIuqgk2SWVtEpe83j8nHyhCIiTa5DpWjZaeXHX/7/vASydGd+ye?=
 =?us-ascii?Q?vxWkzcjhhx1x4Z/rCluV2X9sFwR5zHVC+Xh3OH6loP0EapWVFlyoa12jOLn5?=
 =?us-ascii?Q?P/3l1inUS0mDjEojipr3jvcAbqWbe+APhZZgn8RBxGXVSfTgbMalA9Yx2XUC?=
 =?us-ascii?Q?bO01ikYnXGDjg3AZOiPLuczmWFCLrb1IsHZlU9h1ulOQvMPomg7U27Dsri/L?=
 =?us-ascii?Q?c429v68RM3XBOwIo61OUBNDG/gACjTFw97owRQdvtGeecYW/71CoMs3qWMcf?=
 =?us-ascii?Q?sO4f43BY6oPOoV82GY1iBpLo9xeNGnY=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	xek6JKET4Ui12tCNyfHapuyAtGroUlUk/gDYgYoBq/6nUWaG8fZ1sX4OllCZvKD1q6FvAfjqrTfQf+fdW+qaKX3jXuBGdCFPgN5q6LzmeCidIw1VxPUSHUJw/HonjGvCAMFybAZ7cCIB3rUcNKFRP1dCDrHW6YEU23V2rQwt1MI6coFbTMKhml3rzkiKPsFnl4sFuaGmypq2aTrkOprBBWYZmZQD55BrKt8h7kc2BEH6FrmWg7hl8TGG8W+nMoVDbL2yRC6yCp5Oo0cHugZmPhS/sMJCdWpkFAov3C2Mey2kQsqwqaDvynVeNGUds0Xvh9qFudFc3Eh8rRAQR0Fv4l9rtLunSoR+Hh7Fvn3lDQlp3Ic05wudai0N/YObeZ2P2PiasyJONf1JiCDznHkOfVge1gHqRYccAVgKsQPBLvjlEc+n49Qn+7T8UW4emmej2ir3j26sxhgz5jWeFB8MfxcRq3T/LePLFdR1/8XoQwTaOYGqL/Uut/cYU9hI37cFFpTrgZjCUQikCMq2L3ZOjfJuPNWBzkpCFIWx7RRUrltHJ8gxaGpGvL5jgYbtaroFpCvGbuu1Q+2QIfZ/kK9qC9+dNy3DNTeifa8/xGqVj7E=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5d374dd-7a06-4f95-59d1-08de4c779890
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2026 16:29:27.9725
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t/QOtyPbQCDayh/0vKq9B93YdCfgMWd1SwtucdQRehFdIKPSMQiDt5RhM3nokkWKMq8dmXk7ROAQEvakrby2u9+V5hVkCEyaHh5vhjL8MFg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4776
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-05_01,2026-01-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 mlxscore=0 spamscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601050144
X-Proofpoint-ORIG-GUID: vgePepdRTWJ2WftLfybh-s43POfjbLDk
X-Authority-Analysis: v=2.4 cv=QsdTHFyd c=1 sm=1 tr=0 ts=695be6ed cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=Ikd4Dj_1AAAA:8 a=pGLkceISAAAA:8 a=cmOdqfYU2JuMTF-Kdl8A:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA1MDE0NCBTYWx0ZWRfX/BpOMkkXDn9e
 0WMiPXLCB9qlUjYAzjdg8f3Cp6oRIDhknJ8EsXbngtu+dXwn0U6hXOzGCHvrV6w+RvROggw0Ef9
 Cy2wavHsGIGE5kabe1d3yr0NYrVTGcvwXfGXWt1u1JKwiUsVBlfESFnYuh+b1Ag2wcB/Mvj/SKx
 PUxjeMSYtrrgkHkGM13fm3I+/cKnHpNV/TtSZ9L5oSqjKreDF3NWBoHgBC/t4BkVipS912nDKJI
 +OYwFdiL1oR9UhldPYXtM8sZAfYxR0arrZ1OCfz5RSRL8UYfJPnClK+1qyLhQcbG/7pBMPpi/Zw
 6Vd8RKEa7niuqZaaWXEuPzqru46RGpQorLNNQLfOaIhhKpsAVjkFC2qrOmdj9g/s8j+yOnEVj1C
 2a/1PN5A5u8A+LQuW2Fnpp+SISlXwbLaVlBlmuBWrnQdN/j2EqMPt64OuAc9/157V9X6MR7xFV9
 DTurWBCstDvk1xIfLIg==
X-Proofpoint-GUID: vgePepdRTWJ2WftLfybh-s43POfjbLDk
X-Stat-Signature: ahj544fu3n6p6ehfnhxdi4xapcq7z43u
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9052116000A
X-Rspam-User: 
X-HE-Tag: 1767630586-67354
X-HE-Meta: U2FsdGVkX18SbMaGwdS2FjeUesLbhcNPaD9nr9lGNh0uVVrc0ZhOLo0KQetk3R208JU7SpQc+P5uO9Kye+VwnUTTR7KJOcMV9dXdK8faiNpb02xQeGBd05dFVcROwgEkLZ8J5JYsjXH6XyKRZcVziJ3ua5UXol71mS2iykTjcZSEfH8vsPKbPlvokDMQdErfyYNU8l6QOJFwQquZ2c57jXddudkZKkZuJxiVrXTqq/E8B8NG4yzoqmEVqFDMguIyo2dBJu00NH1YMszfwuhMdfcI9H936KsFxFEvIBhD3qIpt1RXHJHl9Ibpig6WF9jntUERbi4n+YkNDKJEbTsDmUe2bk+kiu/3g80ngdhN7+LMu9Rj3Ll8yGGmgXgIK3nOHeJdkEDcxyxKNe5tSSvHceYt+/WYmPb9UtqZd03VHBX0s3dDsurc3hrr0wNgZ94AreiknkpnG8E86U/kiWfAj7wqg/yiKAxMrxl0LMN8hyirjNkugK+FpmhkmcQ4CPCYn++jIveCa1SL8966iQz4IFo/Si91/rbHtQC0cLJW/xj0Ai2gCXgPkeVoTiNpFYE9xkVCVVn+1537c2k+cNIeZ168zC0ibeUTSr0wa0X/+kwFt4AeDarHtUQu304ayY9YUHjgtUr7hkcUR2QHcPyUWX8io/YgNOxhKmIO547GmNnRNgRg/EUTYPebIE5l5phwPBLf9VGqBi2EvCqexstHwAIUU86p0LSIuSjMZlSXO17n4QgzZzKvczcNWde9dibPl3H6tq/mAcDv6UnB4NiUxPl8Lwu/qpswkqUZn+yr96uK7q/tMybQ/IDmzl/mpnchiVeNNmMMHxmYO73nwMGkePLoL7NU1fONm4ahyuXRgK2pnP1RWyluHM6gDMcnpabJ97EN3ir+3H5J0BwdkJoV56GL8w1ck41ZXf5mnyS6k7qn4pHSDTT5gz0AanDabP4khA1mOtPcM08G3jvyt07
 M+ffOJFi
 gGylBOqJpLcHqTooFKVxEE76yUWWGiaSSkS77Y9Gk8xF51/QFnkSJn8bpFsOPAe+Et2IFaMtJlje48LMOoJkg16ewQhiop8eu5hGNRUn8M9t0PdtstGfavIQwgTMbv7HzkmCEncnQtnCIOID+ZQ0OG+WiLwqaw5c1S1JQJ9uwD4chgZAoqUrt2giDsRRpVOxScTg8n/F+y/ggYKIZJzZziuwcIT1kAVeavotmyZC8I0+fG9WVDxWKjUBuHRahCy4+urQRRH8N1Ecv6v3uy5WHzNa9N0r8A6Sp3PHJfEBYEkd1kPoVvXJUGqk+JoeHp2l0jo85f9mjUHoWM0+uTqRnIgNmxOvx6yfXq5mAIBxun1vPnxbiOyOGKTNJFG4UkNEX1B0QNwfOVuvQcy+gKI/ugQ8jjTkK9f5l5ojGYp7/TR+f/5SPqzKklhsBijYFCR1Wf5rIQdZIePD0iogSB8YsMDsTb83Ucyo5jrKv55LAyk47iLEMz0PxKQRUuABWVqV3l9vhBAVKYb1aZA7MEeB6kq8xpe/EMOaG9XT4WlEfQprWIU49Qr8AuCpiqtcMAMl/u5r0lL4VfDArWvZ9UCsoteo3wUFqbxb153772iDnTBWhlQXXIn4aJHDQ1sOk9zaJ9KhkDaQeZ879UGlWsCr9JmXxPv70xHTkVJjG3dJfKhqUGgUgwPz7/fNbHQy/b5G3cnEvCMdufdiy48BZydgyi/5Gv9xU+S6r50LEDv/d3YYIEto3DQTBZ+tl266m/a9rjW67XBjztV+kUKA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 05, 2026 at 05:16:45PM +0100, David Hildenbrand (Red Hat) wrote:
> On 1/4/26 03:37, Wei Yang wrote:
> > On Tue, Dec 23, 2025 at 12:25:39PM +0000, Wei Yang wrote:
> > > The primary goal of the folio_check_splittable() function is to validate
> > > whether a folio is suitable for splitting and to bail out early if it is
> > > not.
> > >
> > > Currently, some order-related checks are scattered throughout the
> > > calling code rather than being centralized in folio_check_splittable().
> > >
> > > This commit moves all remaining order-related validation logic into
> > > folio_check_splittable(). This consolidation ensures that the function
> > > serves its intended purpose as a single point of failure and improves
> > > the clarity and maintainability of the surrounding code.
> > >
> > > Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> > > Cc: Zi Yan <ziy@nvidia.com>
> > >
> > > ---
> > [...]
> > > @@ -3719,28 +3723,33 @@ int folio_check_splittable(struct folio *folio, unsigned int new_order,
> > > 		/* order-1 is not supported for anonymous THP. */
> > > 		if (new_order == 1)
> > > 			return -EINVAL;
> > > -	} else if (split_type == SPLIT_TYPE_NON_UNIFORM || new_order) {
> > > -		if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
> > > -		    !mapping_large_folio_support(folio->mapping)) {
> > > -			/*
> > > -			 * We can always split a folio down to a single page
> > > -			 * (new_order == 0) uniformly.
> > > -			 *
> > > -			 * For any other scenario
> > > -			 *   a) uniform split targeting a large folio
> > > -			 *      (new_order > 0)
> > > -			 *   b) any non-uniform split
> > > -			 * we must confirm that the file system supports large
> > > -			 * folios.
> > > -			 *
> > > -			 * Note that we might still have THPs in such
> > > -			 * mappings, which is created from khugepaged when
> > > -			 * CONFIG_READ_ONLY_THP_FOR_FS is enabled. But in that
> > > -			 * case, the mapping does not actually support large
> > > -			 * folios properly.
> > > -			 */
> > > -			return -EINVAL;
> > > +	} else {
> > > +		if (split_type == SPLIT_TYPE_NON_UNIFORM || new_order) {
> > > +			if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
> > > +			    !mapping_large_folio_support(folio->mapping)) {
> > > +				/*
> > > +				 * We can always split a folio down to a
> > > +				 * single page (new_order == 0) uniformly.
> > > +				 *
> > > +				 * For any other scenario
> > > +				 *   a) uniform split targeting a large folio
> > > +				 *      (new_order > 0)
> > > +				 *   b) any non-uniform split
> > > +				 * we must confirm that the file system
> > > +				 * supports large folios.
> > > +				 *
> > > +				 * Note that we might still have THPs in such
> > > +				 * mappings, which is created from khugepaged
> > > +				 * when CONFIG_READ_ONLY_THP_FOR_FS is
> > > +				 * enabled. But in that case, the mapping does
> > > +				 * not actually support large folios properly.
> > > +				 */
> > > +				return -EINVAL;
> > > +			}
> > > 		}
> >
> > Hi, Happy New Year to all :-)
>
> Happy new year to you, too!
>
> There was an offlist discussion about some of the text below, because a
> couple of people wondered whether it was an LLM-generated reply, and whether
> it is even worth the time to read.
>
> So I am curious, did you end up using an LLM to compose this reply, and if
> so, to which degree? Only to improve your writing or also to come up with an
> analysis, code etc?
>
> Feel free to use an LLM to improve your writing, analysis etc. Just a note
> that nobody here is interested in getting LLM-slopped, so don't send
> unfiltered/unchecked LLM output to the list.
>
> In general, I think it was raised already in the past, please don't send
> patches for code you don't fully understand. It consumes quite some
> bandwidth for us reviewers/maintainers here and it just gets very likely to
> break things by accident.
>
> The comment change suggestion below does not make any sense to fix a warning
> we trigger. If an LLM wrote it, you should never have sent it. If you wrote
> it, you should have invested more time to understand the problem and come up
> with a reasonable solution ... or not worked on it in the first place if you
> don't understand the details.

Honestly I have repeatedly told Wei to not send series like these and have
been ignored, and therefore I now ignore his series in general.

I think that's a reasonable approach - good will can only go so far.

But it doesn't make any difference, mm's 'merge by default' approach and
our continuing to tolerate this kind of thing means that nothing will
change, and unless you propose to NAK series that obviously contain LLM
slop, nothing will change.

>
>
> To the issue at hand: Zi Yan pointed this very thing out in v1 [1], no?
>
> The patch as is cannot work: we cannot return -EINVAL for something that is
> not supposed to trigger a warning.
>
> [1] https://lore.kernel.org/linux-mm/01FABE3A-AD4E-4A09-B971-C89503A848DF@nvidia.com/
>
> --
> Cheers
>
> David
>

I for one however, have lost patience!

Happy new year, Lorenzo

