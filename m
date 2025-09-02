Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA275CA1007
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 22:52:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DA1E8E0002; Tue,  2 Sep 2025 18:52:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B1E98E0001; Tue,  2 Sep 2025 18:52:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A12C8E0002; Tue,  2 Sep 2025 18:52:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EF9298E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 18:52:16 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9B2A2B973C
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 22:52:16 +0000 (UTC)
X-FDA: 83845810272.01.3C49150
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2065.outbound.protection.outlook.com [40.107.243.65])
	by imf02.hostedemail.com (Postfix) with ESMTP id DA68F8000C
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 22:52:13 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=lvhdqWh4;
	spf=pass (imf02.hostedemail.com: domain of apopple@nvidia.com designates 40.107.243.65 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756853534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RB2AwIGSpgYzWL3SypJFGSRH2Abk4KvWKy4MsTEpO98=;
	b=PafCcNPj+6pGPUbCLGFO6lgKnuWd2F2XRCBmVH/1mirZNf2EOYQaGlru7jxBRRFk75RfeC
	mTEK3iLroXauNaATioTmCzCmI8tMmmfva7W0osuOV4ORGyxTZ1zrTVTTLWLaahyJW4gfH4
	cwhI4P0OuyVm7cjRdcLejnyfF+2j+Hs=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=lvhdqWh4;
	spf=pass (imf02.hostedemail.com: domain of apopple@nvidia.com designates 40.107.243.65 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756853534; a=rsa-sha256;
	cv=pass;
	b=Oa3Rlmof4GSL/QbxBSlnvseIaPtOBh4su4uFMRJEpDut7wNqxo+M0x4eJ8RyuMP6kwnmST
	41CngpggflIELWqdI1VaMFF3+WW4dLGS6rJAxdRSY124Ckoed+psgsxJXv6upxJ9A8/Od4
	oKXl3ZU3iJBfy8izNWgDh/F1GGCx6WM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p8merAqSftNzVYWaIAqFUHPObl3cyGtN1V5swSevTYZd0Y1M6WGHvQBTof2rx9N7Ui2zvCxJa6dYgeYOqMWTNvON2l2xNg9pJcXN1q3anFwO58QPMl+ufLFs2h+aUcTu1gL70QuyEluAW4uLWegAaT8LZFCtRx8m1w0CgwDYmB5k6ZqW+I1qII+MTaIvVfhULMulT5IFMWHkHRn77b/cs0pMESFKoe1M++vH68NdE6AFjjw/anRR7LObsWfncwj/+TqUBPpUywI2pn4YyU/I2zfn57k9nTUUgvkPI7UCpngmm7W2LKt2/R6BTpZBcmwtsQOupF4GULn4FgIGH2trNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RB2AwIGSpgYzWL3SypJFGSRH2Abk4KvWKy4MsTEpO98=;
 b=F6JGYmgcXj/mtVUUBEqfXd7xQoemQA5opzFvHbLxROtssfKfYKratMw2xh24u9PB7wtzKa3Qcnm1xzm9+ycOF/9DrPbwD8XGdgfAJJmlkZkSnVCWk/iyjmaY5znXWs4DsLvhQK9142Td2DfnCcBd9XU02+8CU+oxaBfuBRobakfgU3J+aVrNTgYICTxAjlSVLZU54fY0xOg4OqGhcJImjaRmCaIQyaZrY8gXn9awMake72g3b60Eh4mNSICR4vH8jPdnlKCV6TDb42lbR22jyp3+1OxLtSaeUozteYl1/s0ZwkvQ/ezYnljLD6Wn1r0x0VXUB2mFQ7tYYTVIwjtejw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RB2AwIGSpgYzWL3SypJFGSRH2Abk4KvWKy4MsTEpO98=;
 b=lvhdqWh4lDvb8N+7+5kRqU/oITfzduInAN8Tkz2Oi0ftfATRnh0OfOxTKOAcMeCSRWXj5tqV2k5rVxiKyQKXQIfUvfoXTDvRxnyuV42/atr+BYsNED+k/M+LidKKwkv02WrH+Wor2OjZ4pk250s0B5Jsea1CYADGzUGVlw7P0b5lI64zPEsOUg04ydsfsj44hcYrpHvBQBOdPU6OFpsIXHFOdj+z8P86OARkdMhoZf5a97erh10E9zthceM1Vr1xoAG4hq/ZAzBkKKKvQQIOISSTTfvoXsf9W3UVjYLoj8NLY6N5uhm+wFkBEaV5lSLLw2rNI0fh3reZn51QtJVHcg==
Received: from DS1SPRMB0005.namprd12.prod.outlook.com (2603:10b6:8:1e3::12) by
 SJ0PR12MB5609.namprd12.prod.outlook.com (2603:10b6:a03:42c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Tue, 2 Sep
 2025 22:52:10 +0000
Received: from DS1SPRMB0005.namprd12.prod.outlook.com
 ([fe80::7629:20ac:4306:5f4f]) by DS1SPRMB0005.namprd12.prod.outlook.com
 ([fe80::7629:20ac:4306:5f4f%5]) with mapi id 15.20.9073.026; Tue, 2 Sep 2025
 22:52:09 +0000
Date: Wed, 3 Sep 2025 08:52:05 +1000
From: Alistair Popple <apopple@nvidia.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, osalvador@suse.de, 
	jgg@ziepe.ca, jhubbard@nvidia.com, peterx@redhat.com, 
	linux-kernel@vger.kernel.org, dan.j.williams@intel.com
Subject: Re: [PATCH 1/2] mm/gup: Remove dead pgmap refcounting code
Message-ID: <zpp2ztak5c5e5kies6er4mioolsjpufxgizcrjf2erk4fxryox@dvnbkls725wu>
References: <20250902051421.162498-1-apopple@nvidia.com>
 <ee3ee18c-27a0-4c38-a639-e93e91a392ad@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ee3ee18c-27a0-4c38-a639-e93e91a392ad@redhat.com>
X-ClientProxiedBy: MEVP282CA0014.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:220:1fe::7) To DS1SPRMB0005.namprd12.prod.outlook.com
 (2603:10b6:8:1e3::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1SPRMB0005:EE_|SJ0PR12MB5609:EE_
X-MS-Office365-Filtering-Correlation-Id: 55234700-98d8-4fa3-bf14-08ddea735954
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/KDLfRYoPN0Wp0w+E3wHRVnqjh0qNvvWHRN6dl2tCJTmWamOtj6CDWDjXN6q?=
 =?us-ascii?Q?I4PMJlUqHHFenriP2mZ8SpE02148ahSiG/k1+LEs6mGnmzpVlZR0NRguJ/QP?=
 =?us-ascii?Q?A7n8lxgomTZV0KsORzk73Qjc3ezPEp6MWzYX14e3XmiisQa8LZa2Xyey3qhb?=
 =?us-ascii?Q?OTvplbR1dcZloyyvi1YaTD6krivUO7ze1zKvFYZHvy+4GdWiE4jQXpFzmXSV?=
 =?us-ascii?Q?rTBeEXWkh1XunDq5EqTVQSUNsXdpoYnW9udfANNWdAbylvCt9IGDCcT8myYF?=
 =?us-ascii?Q?UBG+ovqsUTLhrWDmpz97awlCjCrfV17ywzrxMYgRdKypX2EUtx7UbiuUk2qA?=
 =?us-ascii?Q?gBOFHKR5+QVhuT8W6TaLp788krf4PfFycbGjtvXPzim7RArR0ZTDGGy/QDp9?=
 =?us-ascii?Q?uMBrdzDmG4jsZECvpr6ABzVAmjiQJqk4MEuq96O5U/aX8G84KN8YghcBlvvs?=
 =?us-ascii?Q?BvYEO6Ster6bmjrKgV58swaThN4ckxrXDT0sxEV0Ng5UjS4FIRCtM01ARDGV?=
 =?us-ascii?Q?1yq5ObTsbFWSFXgI/LtxQiPSUgNQmoBohutNrhevQznZA4gehlyLFExt8OP4?=
 =?us-ascii?Q?k1I156d9qG5Yue6BX9FkgTBitp038+vQn2qLqt8V0oqD8x7rCgNk2XkpaU24?=
 =?us-ascii?Q?OaV2NbgjcT9A+/m4laOLoSVZixlOZ/FB4fr0Io6UY4h6KnsgEhtq7zKongyG?=
 =?us-ascii?Q?GFQz6XR6VnXQPd4KNxnxTdO2FkNG+IZSrhBa2cN9NHhNyXuErnDxESiNo1ly?=
 =?us-ascii?Q?2onFt5XtCgKGsMyUue49Ju3T4Pmfy5kpqRsPoHWz/SzTs1ftYQNjgH+yBTm1?=
 =?us-ascii?Q?A94IESF1lya8d9C3jawbI6fP0L96M169bs6FIXoJRO0BFrY3w+KZfCJYIaKQ?=
 =?us-ascii?Q?J2VtPRlwWLTDnEU7T6U8xcJWwMBrQ6+pgfbr92bF4euuwGwfDL7J/6ohc6FV?=
 =?us-ascii?Q?EUyTC3ZH/0pBnnA3lPx9jbx3Vb8KmAbYvO0qZsi3Gczx5haDKVHLRlNBPf1c?=
 =?us-ascii?Q?rbImXtamlVSPGs0HQ6t7Dy0ep5a38QTr2PmRN9IXUT5pwFdJv5VIu6G7O9T1?=
 =?us-ascii?Q?BzoJ/azPTccFrrDCiy98YOM+VSebTD3EP5xxLQVBZEkjmD7CBFvf/bQz7NTZ?=
 =?us-ascii?Q?LjEPBTgxVBCX3CjKJlrpEJGraLGz6HtmbdR4/b05X13b232WflPlMslwaNuk?=
 =?us-ascii?Q?1X8RwEnE9wH57ZUlJ2FDuyscNsQ0pyV40dPU4PnrL6Xk3I7ssXpOgyD/6H0f?=
 =?us-ascii?Q?zLWJMRXOLfIklCF8z4AuMpPZB/IgY0ra76shb/EgVK0pAHMXEQDu0m7rmJPj?=
 =?us-ascii?Q?mSCH3cyvtWuF4PzqOzRvvx4n8PGJTtOGEn0lkKfIQFct563xid2FDV/oOe1a?=
 =?us-ascii?Q?lNqh5M/210h69/eY2PjGZTAEaHsQFn+22VwDVQ3FafkCOXhiVXVExMt2gKgV?=
 =?us-ascii?Q?ZcvsEHmK9KE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS1SPRMB0005.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TEx1wAffYBcEaxp1TvURD0PI/B7Xx6wZXsLixvm0/iaPqaeOnynVk0QJZJ3D?=
 =?us-ascii?Q?WotGXaL/rXEjsycx8HczqfCHkmXUJYFJ029N+L4HZfBJ4j/JLvpSc4FI+JFR?=
 =?us-ascii?Q?F1D90ghPQqrgOVdfsyGOHee7PgPolt1l8sUJJFGNsemrwPO2ebEffFU6DUZg?=
 =?us-ascii?Q?+KmV8xnSwN1+xVy0symVz/EggCKSshqHCrFZ22W9I+X7bBUDg/jDaIjPWoZS?=
 =?us-ascii?Q?TJBYA1X3IclYG+bDAiJoCB+aKAZyq9dTKMvwlqfMqFYUAzJQENPylAm1B4Oa?=
 =?us-ascii?Q?L6vhHWWPQQ2sCgMgabACcvjFgu4UOz26OfUe7Jt0+rV673HajBe0Tkxz8scX?=
 =?us-ascii?Q?jP8VqmkGxu4krC96mbAhG431JME5v4HDa4TPbtQ6ayYhlHQCDxcUW1okjPj0?=
 =?us-ascii?Q?FnWhHaT7mPL8xTqee+blD2LkaxW1O0rbkarcUBlBQomEijbUN3g51C7qjXVj?=
 =?us-ascii?Q?/9PCmtZzDIP0GAshL6y30zxP4nPcMIGw0e6VeuD8Gm91qxinmF6Yg0PpTs2J?=
 =?us-ascii?Q?QnzCIONf5yKj+DLpp2iNNlbSsjpZsQTXZIywCoW+sFunpIG8tHFBz4zpqYng?=
 =?us-ascii?Q?v9318Dbt9n1m+Fqoa7Pe5xDdqmdWn2m6ZJTz+IC+VHU4ajSa35g16+EEDiUY?=
 =?us-ascii?Q?BXuQbH3J30Zbp9xiOW0Q31PpUvDhGNbPUuLqLFrBGCL+MslUFirpez/Abc2c?=
 =?us-ascii?Q?0wy1RpjIfOK8GxAPMT+XGHKZ//q7WvUq3Mje9Gr2XteG/tx+4yo6DQasah+3?=
 =?us-ascii?Q?wud3S7YJTh8CDJwSVzWgZhvhCVAQmmxyknaG8jc+Aj0MXlrGgxusxYg9/Euf?=
 =?us-ascii?Q?lbNQJYWNub6amJPogL2uftMgI9YZJmqZz3qXwKlVyiy+1u0t8CHHfBuD1X2Q?=
 =?us-ascii?Q?LQ0+3VWA5nqYMVOqA4A3g8qMOog5hEpbSxSw0SkOHWjdHnYclTA7UlQUelOd?=
 =?us-ascii?Q?+VNs96J6qk+rNakUi82L8VM4OoCSc1xjy46djl7IEHI4/PtyBsZ89bEK/uUk?=
 =?us-ascii?Q?RioK9nTgb87nEg438TKPK3+bRNuP7a9I06CQ+O2XuQyJSlRapWbX4oFQvpSs?=
 =?us-ascii?Q?C3Kj+tiMgR5w/WesrnAn/puWX3xJnfAqxE+3y1wFNp43l++vdPACz0Rtsl6s?=
 =?us-ascii?Q?rLTig6SU1UjMo/CxB9+T1/WTBZidyEGGuaWB1IFyKiwqWmDan3x+ZTxG0vCF?=
 =?us-ascii?Q?RDATinTDkkzSj8W/rMa63zxRtMgECm3WJEFzsHGPljCQjuwxo5UQJf7RyiBC?=
 =?us-ascii?Q?pzibsF+zc4FdAfqfta5LaHIZppiwbRZaz/tVPcrLbcXCCJXuMuTN19w/IQPU?=
 =?us-ascii?Q?FOrZiL+G1+0E2PI0iuH9LqfHmP9sU0LMKPf1X75NjHyQkQtAhUIffyTw0Qud?=
 =?us-ascii?Q?Nrul3/DTZIZVuXB/lzCBFVvNCRC7u4bez7aLkVwuBVvVso4Q1XI2iWrug5aW?=
 =?us-ascii?Q?87US827US5pHkeN3I8mSDgifTyGx7lMeKDXzbVB/XNwutibTgJLxc/ylLT9g?=
 =?us-ascii?Q?WiJQB86SJygrSIwXf8QTSEHbHCH59nLzqJ94esRgWMpZYc9+t37o4BWoCtEd?=
 =?us-ascii?Q?/JkGUkRhjmtAPKRW6Iy8qArouUWSyJJDhjo/ZqTU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55234700-98d8-4fa3-bf14-08ddea735954
X-MS-Exchange-CrossTenant-AuthSource: DS1SPRMB0005.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2025 22:52:09.9030
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IK5PHKbcc24b0LJAibsSJcWVWx7BKdOkek8B9eN6BlyaHJHYatCZI7Nm3RrdOD68iVmY6ZKEju1Z/0IVm46thg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5609
X-Stat-Signature: 577kp1dniqgab7fiph9it5hh6fnb7pjx
X-Rspam-User: 
X-Rspamd-Queue-Id: DA68F8000C
X-Rspamd-Server: rspam05
X-HE-Tag: 1756853533-452837
X-HE-Meta: U2FsdGVkX19AQU0zRaiiWGe/KfZHrp0jmpUByZkpXQGUMAFSzN1p4me/ePMT+CPD/8lUzCsBoD/TfZv5qNd1zGUPn/7cfaf9zMKS7rEoj3A46UR+VcU5TrSd26vhUoQM3+tfp5sJc7qkcCBbzjmuQl8wQt9tKMWnXqhC4BQwNDzuoiISH3tOj46FIDm0PWmW3hY+grSNZ0z1EJNZOy2ssTk+DauNF40axza+emEj65689mSNjyhWC5NDAiKpz525DJfiN03Vf+Pb3vJy7ud4iOcnI5026y7EdoKwNJXMkEEapn4KlGldKRrytcrfQQEbMp9d8OpbVOX9EEFYq3r/cXqPCenfo4r2Zj/wXxcrXyKLFF4JoaByXFDOwHHIiNNtcx1ic/i/+8hOyBo6tGgUmlhlroC4RTBmuSotPy1RxXtiG6LS7+hFNlO+8SumLpI2Phl6r1HNUEVLPjSVIjQRRVbwNvLMrrBtjrjkbhQa1xWapo/ks6CMYO2yL3Zy1vuIak7Ig9EZfhCCdjXweIJxHjS2Mm5pCmvKRCyUB4cXOxH1NSVoy6Ux6jhD+SpwFEWcampIC+KD6JNCbCTDD2rvuqnCQmu1JffMTLpUTqqcwYurJ9ZyU8ni6hMkfIdCeu7NxB66W2tLmSlDiYqaRIKGyOY9zruCLL4MFbci8sY/RA1NJhP22qin9Kk0IVHJ9RB9J95AU2GAtjhn+j0N69M13A28KHV+jg572+Pp37mpmpMuUMU5yL4moeHraKtBA5Sk0OgyVWbb1/2UclrA4/2A+0pYEsgG4oTfx003TWLXMqSr1q3adk3bmJG2B+OX2o/6EKiozBqFcFGYmvqkAZOOGAPh91Rbrw08/6dwm9bSqVO7yqGHZlmrtBuvGO3jOugM5Ntxb8Gttbc8waC9YAsPq68Z82zoekBR8l5w09yvwOpA3zWHIAbTsIDDRTznihL5nYuLK2VnvCR266jQzK7
 8F4Swu3m
 nnKjB6Y3SbbjiUPBXmRJ/JZPFrEDGIQUXxRGMQpEU0kDMjRZXzG6aaZQ/lKQZ24j2C7xA7xed2ijy0tB4+M7FZnNjx1b2TuIFXwVGbHnvayZ+ATmyagj61uQE3616LTqcfUXR1mwzcShIy34Vw9lQhTRZMoV0mfU2e0T+eO8T+uoe8mKZla0V6c7fUi5sYGpxwH+LK97wdmDaIJuamSRaUF/jJC3gdtRpsO46bqWYxkwpzokC2Rtze6WA2kDkvvD1TzA+SoD4r1pEN39OEZfFPt/8dWZcOJ2gIJLl7rT1uH2lowrFra62A5zL386516AgdPRfLOQ63ImzD13k7Pj6Evdbn7IF/m7nIBkfJ12Mo2I4oH740+KsTU2+RBq9N/328hM35847cPDLHLk+hffRW4kEnd5FRphD4KxIQ6GDTxCTyTG9Dkq8Mc8R7WA8FYBlPEF+sBlyVp6L3pSmz9HsyeD1z6fQvVXuMlpzb8B+DffUQ9fOfPPoffY7Eb9YsSItMvVquOB932pw7dg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-09-02 at 17:46 +1000, David Hildenbrand <david@redhat.com> wrote...
> On 02.09.25 07:14, Alistair Popple wrote:
> > Prior to aed877c2b425 ("device/dax: properly refcount device dax pages
> 
> "to commit aed877c2b425" ...
> 
> > when mapping") ZONE_DEVICE pages were not fully reference counted when
> > mapped into user page tables. Instead GUP would take a reference on the
> > associated pgmap to ensure the results of pfn_to_page() remained valid.
> > 
> > This is no longer required and most of the code was removed by
> > fd2825b0760a ("mm/gup: remove pXX_devmap usage from get_user_pages()").
> 
> "by commit fd2825b0760a"
> 
> Otherwise checkpatch complains.

Aha! Clearly I was tired ... I saw the checkpatch spew but couldn't figure out
what it was trying to tell me other than I was wrong :).

Anyway the kernel test bot tells me I missed a call site so will fix both these
issues and respin. Thanks!

> > Finish cleaning this up by removing the dead calls to put_dev_pagemap()
> > and the temporary context struct.
> 
> [...]
> 
> >   {
> > @@ -661,7 +656,7 @@ static inline bool can_follow_write_pud(pud_t pud, struct page *page,
> >   static struct page *follow_huge_pud(struct vm_area_struct *vma,
> >   				    unsigned long addr, pud_t *pudp,
> > -				    int flags, struct follow_page_context *ctx)
> > +				    int flags, unsigned long *page_mask)
> >   {
> >   	struct mm_struct *mm = vma->vm_mm;
> >   	struct page *page;
> > @@ -688,7 +683,7 @@ static struct page *follow_huge_pud(struct vm_area_struct *vma,
> >   	if (ret)
> >   		page = ERR_PTR(ret);
> >   	else
> > -		ctx->page_mask = HPAGE_PUD_NR - 1;
> > +		*page_mask = HPAGE_PUD_NR - 1;
> 
> At some point we should remove that page_mask thingy as well and handle it
> like gup-fast: let follow_* will in the array directly.
> 
> 
> Lovely
> 
> Acked-by: David Hildenbrand <david@redhat.com>
> 
> -- 
> Cheers
> 
> David / dhildenb
> 

