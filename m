Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B62A9CAC58E
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 05:25:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18A4E8E000B; Mon, 15 Sep 2025 01:25:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1620C8E0001; Mon, 15 Sep 2025 01:25:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 050DD8E000B; Mon, 15 Sep 2025 01:25:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E9ECC8E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 01:25:48 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9A51358B34
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 05:25:48 +0000 (UTC)
X-FDA: 83890347576.06.78D5E49
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf21.hostedemail.com (Postfix) with ESMTP id 366691C0004
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 05:25:44 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ZcAfKFF+;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=e74QhKD2;
	spf=pass (imf21.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757913945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=51U572WIwO4+/fy1rEQiREDlkH6+NT5VmECuRI7o6ws=;
	b=Gxnlzyj8l2o8MS2lprFk8Kzt/lrEFg56xqcY1lZ9xXcjU6gJrMT2vm+tJ0SLFwrYSCtmdG
	wpKGmDGPYVXrrbagWQJ1GsguMLNAREc5Zz16at+38PijlK4RFK4dQZsY20Z/tDexgaMgaf
	n0PLFK8V3rEMRQDfPViuPdjyhc1+HkU=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ZcAfKFF+;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=e74QhKD2;
	spf=pass (imf21.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757913945; a=rsa-sha256;
	cv=pass;
	b=8Z1Qk8mYDnEl1HwssUr8e7stAz100oL8th2lwau+ZMktsSeqxdRaSEBJxDEKJCKiiaxmJS
	7iDSuAxBxE4Jk40Cg3ZHkhA1dYUeyjE71MxkncGja1G2A8YW8wdwrQxLyBvCgo1SfEFIhD
	iicCbaLDAkPyVmeEQ9hagb3MkXDlsQ8=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58ENmDTW018645;
	Mon, 15 Sep 2025 05:25:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=51U572WIwO4+/fy1rE
	QiREDlkH6+NT5VmECuRI7o6ws=; b=ZcAfKFF+G8S+O+t1lNlAydz6m2mTi2k99J
	WuzwuiD63pdJlg8G9+cFFevGKcLUs075Jgv/cfkEqf1lDxms72pTVU32vuUfVyK2
	jASQ5n8cC5XKw/JnM3/O6FqrpHgNmgJ5V19KleR7JXwiIfbgkXPSIddzztAs19xo
	Gzp4kLUsIIpy4JgEdYFgDraIrencCNPwVuT4KKMQaOrVxB1nceeI3O7kqKfSbCvD
	xNy8DxxSkTgMqWoQr78blHKlqYYfkvXJ48+dGa04NQPeJqCeUF0ny6Kbw+GpmaEr
	BwmkdxMdvIH02GKzVBjzFt8EBajuIpJjKSzQJaxFFi3ARJ4Ermsw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4950gbhg5y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Sep 2025 05:25:38 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58F1smJg015151;
	Mon, 15 Sep 2025 05:25:36 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010047.outbound.protection.outlook.com [40.93.198.47])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 494y2gtqdn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Sep 2025 05:25:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C8UZWImWxFujqf5qUbLyP+4+K5YdJIm2xVMEwvvOFvLB7yPWj6TNjyrnKjuTN4SobYfm2NjoME9zmcQUr1O74m24A+EUyHD91XQxljCIASTbgOnLroaVJiWE/Y2JRJfY26MlX67dP/vX6mS+90opbbZl3H2PAz4DKL9EjxzMT/AvaTXpP6vA6igccN6axsqkFaDHKNsmbiCvmQe5TG6r7iyQmwHirt6pxKbgNjceRCUQ+2yd2Gp29PkSGM8nSFMT+aNzyThwLL7CuTVXHEIuHHvU8RhC/wmJhtWwvXbJjX1uUc9AFKxxiOau/vIaJJqfmnsH6G6W3nxH5R5w9+b2rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=51U572WIwO4+/fy1rEQiREDlkH6+NT5VmECuRI7o6ws=;
 b=TnRiEHKtiDFWdM3uLOrLWqzuLXM51GMQogwqsuvBFLgqnIhm3Tu2hHp/5I4mt6cMgW/R2JS9GWnlq+6s7ACpt0JVD7sA/+LH+JosDaN9BxOgrSLALt12td3hiC6/oOUW/Y0KjyHv4toitQJDdLsrAj02AIRYjUzk5rAeqdi3YsFtuvOxEE0M9mUm/ID0yJzogm4eFaTXNTQS41Gwa2vMo8nStrnhtkP9bEC3BliqWcLzpj16ulOQNkZbp7toznJu5XdN1a52stPHSNTz/ZZSijvXJJtsOsMEeq6acAn+QC9PL54t2kgadLu+zW1d6vhMP2BZKdJIPu/cVxprBGF6FA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=51U572WIwO4+/fy1rEQiREDlkH6+NT5VmECuRI7o6ws=;
 b=e74QhKD2UOyqQThPI5+Y4Vr5btHUUbZXuoRc/spSE3jixzBu1toG95lkIZallD4x8Hw06CbWkmE4b/dcnNcqQd16IagrLoayS2cQMUBcoPNtBg7wFAFCpTTFAWMJ0MuSdFOHlW3lCXG/IhyQnUDlKbFmR39N/btrpdTfO/7TnHg=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by BN0PR10MB5142.namprd10.prod.outlook.com (2603:10b6:408:114::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Mon, 15 Sep
 2025 05:25:33 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.9115.018; Mon, 15 Sep 2025
 05:25:32 +0000
Date: Mon, 15 Sep 2025 14:25:26 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: bpf@vger.kernel.org, linux-mm@kvack.org, vbabka@suse.cz,
        shakeel.butt@linux.dev, mhocko@suse.com, bigeasy@linutronix.de,
        andrii@kernel.org, memxor@gmail.com, akpm@linux-foundation.org,
        peterz@infradead.org, rostedt@goodmis.org, hannes@cmpxchg.org
Subject: Re: [PATCH slab v5 2/6] mm: Allow GFP_ACCOUNT to be used in
 alloc_pages_nolock().
Message-ID: <aMejRksTtWHPZijG@hyeyoo>
References: <20250909010007.1660-1-alexei.starovoitov@gmail.com>
 <20250909010007.1660-3-alexei.starovoitov@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250909010007.1660-3-alexei.starovoitov@gmail.com>
X-ClientProxiedBy: SEWP216CA0057.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2ba::18) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|BN0PR10MB5142:EE_
X-MS-Office365-Filtering-Correlation-Id: 9124abd4-df2a-4634-1c7e-08ddf4184ab3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?kdFcN948Qf8vSnGIGm9KMDiMfOPFzNb6/bv8xI/OzhvkbNw0dCY2oB5JW2cO?=
 =?us-ascii?Q?mMVWz6QYjD/sTMnMg/zUG0mDaIwAkGrlh/fqJYkHHyJeCvlH9cdP3Hoku1wG?=
 =?us-ascii?Q?Q9DWpHlYqm46Zr2kuTZH/7oQ6eFSp8VzKHsihhoqjfwBfVWlfQD7CUUL4pVS?=
 =?us-ascii?Q?FjZratmkyCEbEdjbWSEnXaYXeDMSZywQ8VY2uIKOHbuM12ONICYV6u8xrneL?=
 =?us-ascii?Q?YV7w5f/zFheIAt28KCYOg0oI3mR0/AjqtJc2PrIBkAVcGhazzU5LjCwELFWa?=
 =?us-ascii?Q?8e2sPmZy5ABliGSk6cYy2E/egFaxllzJc4mhQAlwnvjMBG0gCNuiHZJD6l85?=
 =?us-ascii?Q?1Bo97zSbOqdUSlvI8HYI1fvy0mEhiTx/iN7WLLfxTDs/RSfZkjf0Wmbi3RMn?=
 =?us-ascii?Q?gN9fYdWNR9vuBMjZ6xAR7MCQtewHkrXOmT4iJ5iTjnu5SUVjPZxhJRVEcVCj?=
 =?us-ascii?Q?92R9inbCDBEU2KSOufcSo8SBnA8coZ0uJC0oiqp+TTSBznG0o/ctGbRIVXmD?=
 =?us-ascii?Q?5HC7f65gcHdIOUpemQCqrVbeCBbBYsctFy7nPhjXzTigred5dQOlnbCQKEFs?=
 =?us-ascii?Q?/ikIUJv7PETzFTja64rpPlIEH4qqekXXMWnlcT+CinhcUhmC3IrBROzGtuY8?=
 =?us-ascii?Q?MyrcbHZ/GR2PyrcCspfMxCz9UdkMU/ZmwCIilr2ukZshfc4q7RFqAnwdVe2C?=
 =?us-ascii?Q?/BaFTfDWvPGt99H1yXPZgR9cHgj70S0FbeNevsOrcajk6IhW1tjg0S+7ifba?=
 =?us-ascii?Q?YnVNRpzFsmbuWPVCdbP+CaEJbjKaFxSMoOeWCfr3dnuVMutoePieKzs288r5?=
 =?us-ascii?Q?TIxsv6+AG/LLHGoej54SeQsvvlIincYfjW1+LEiCYodRcgBhAvoLvqbJB6To?=
 =?us-ascii?Q?51DXP60f5z0dzPYeGUMd3MkD/4KCmcdRN+cNKkBObBkQjlOwtrxr2yFli9w7?=
 =?us-ascii?Q?aVcaqNG60NmVs+LnoVAMT5wRRVO3Uob6KysdHZhh+5uvpCASlXujMG3g/Um2?=
 =?us-ascii?Q?Ky/IcJ2PR8IkelmNRCgjHH8BpS5DbRu7PpSFfONoFJgobcGoAnuDevI8O1SO?=
 =?us-ascii?Q?YhkSwM6QZLNHcbdLHsfAJF1Ck8gaCn6+Idr2NTBrkGY6QeUMnOSjEfLinJHG?=
 =?us-ascii?Q?QpsBWYu/x4ki7O+3F7xu94g71XEI/EEBKD6eVKVoQVmQ4OtMK40WDge0KbKS?=
 =?us-ascii?Q?zGx8/3FYX5B1n++ME1BiVx2wnFpSfy/+KePt0x+H91s/hlPRq4nViZ7wOu6Q?=
 =?us-ascii?Q?xwyv00f/1odorEBOQyoU5SNmjo7J3Sl9CSaiS6kSYTcJDqzBlGdNyZjqU2LM?=
 =?us-ascii?Q?udO6DPDsLd8REP6DHyghHNpUOR17QFzp1Ocsnq+qieltLpTSbxU4xl/1wjzV?=
 =?us-ascii?Q?Q5KQQ3CKZVGJTTVTUdI+YDs3F8SqCWMJ6D0q+CpzXSiWR5+BChpaZ7yHJrND?=
 =?us-ascii?Q?1ElOS5k1w2c=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GBWhOAFs/cH76KnNwLsOeXvTQoET/y8fXLU4w6TCOwBauKGUPyfYOr+TVubS?=
 =?us-ascii?Q?sHC5M6YOb1tpx2OPuP4szXQh8QWqGoTs/NDyQUBklV/56t2dm1IZ0PqgO0wX?=
 =?us-ascii?Q?km0WZ5/q6lwfwE0JnH01ybCgOY/eNlcKJhMeCvQ7BRd5swc++CAfWpQOJHvy?=
 =?us-ascii?Q?1y/He8hBsODwA4avwz0aD4NRs7Zv9uxnSDXfyHGeZm0fpsRdERdcUFZLHF8w?=
 =?us-ascii?Q?2tUC4GYtBSJgkbzAh4bqmkdXCDplvi+gs5oZPhQEEhr+mpUGzDIK5I+L/jD3?=
 =?us-ascii?Q?YIJMBy90wzgKWVjkOkfntaiIn8KLCHhA2fdeZuef0+Jx/6XpZxC7rZG1I3cD?=
 =?us-ascii?Q?qgtl/2gUJDLiKNRffVHDdjOTHfUt1IhJWhL+vuyVOeKjoK92DahwH8rSNMNt?=
 =?us-ascii?Q?pKQGtveCCZeZ6QHBaJcN7/Q5tOQxkqCcfvzysMncLZNev+wDhLngwPvO+I6y?=
 =?us-ascii?Q?MbYTFw6Uz8+HqT4chidW0qqIgiA6Xatt4c33zbI9mqqIUb1MOhaBg1Gmllkd?=
 =?us-ascii?Q?net0vv7bx3J+u867HWb3ufsn1Y1sRGGAJHaJKELwse+5htiwzBZ34SXxPnlJ?=
 =?us-ascii?Q?EygGbLcFpgRroej+cBgHe+gUaVEbiFCHgQ5OHppjLmLfzuLWblEduGRVEbIE?=
 =?us-ascii?Q?IJ5a3a8MUqBIgM/xnYUKlh8gbaMKDsA0xxoiJkywKGyWUilFeCJwOXNYYukw?=
 =?us-ascii?Q?RPMV4hslY9JRApQ9/WUbJ/rgxZ5KBOk46m2shpGcC4H/KRzs26PGVn0e9tm4?=
 =?us-ascii?Q?v6ttgndtXxyUqdRum/CgHYg5c2441JdwQ7kNTBdRZnjiWjfLiYev8rRZI4NZ?=
 =?us-ascii?Q?RC7PU8ezw7JGTr0UZd5ZgMSHTuT+AoNgCyBpjt7bIl5y0nZ+IxDtdgl1Nxa5?=
 =?us-ascii?Q?+unJerqFrOvYhT+ikqsSVhFM1glQkiiiEPTETbuQTALYQLP+Sa2D0tq6Sskg?=
 =?us-ascii?Q?RP9R4as+j7p7QhCQ54sryncBzm5i8iZ8VYRnuQ25DuYUNznpxjjtb0QeJKSa?=
 =?us-ascii?Q?/gIpa1Wn4pfZK7+ERdJCU+Mr26BZP7cInSDAbEu5dNf1eOxjHCnIYee3lbIH?=
 =?us-ascii?Q?25xTO5yqv5T2AHq3KaoqgMml6r9CtSbzkyEPXWTJvVTvf9jB5TV+FszXLfsX?=
 =?us-ascii?Q?1IjpKlPMgotTe6H6FOFsGg+d43YPBEKom0fb4oNG0E33abausoVD1F4pYc2k?=
 =?us-ascii?Q?Ly85sH00lXF8ajR/YdhgJKNAg0kfb6lPccaPFBF+CZEJIjl8UsP6C+QZ8zkJ?=
 =?us-ascii?Q?zi1l5oKIHG8YIEckm2uD2Jvx9OjbKMvxeYW2SYtPjhRzLhTPt9mT0tLHriBe?=
 =?us-ascii?Q?2jQEGB9jKqEcf4dc9mBEzbYpOKSBFDGSFuq8d+hPjhjyRgj6oSA/W1cv2UjB?=
 =?us-ascii?Q?Uw9gyMIc33yZ8pEL9Z/O9hj82UK4uc5QKjz6ibwogfcqtGvKJRoOh9SNAVbC?=
 =?us-ascii?Q?Jlo3NfffdAaFco466dboGijRypGU6RNTBWFlNX51fPLy5J6kmGqfwpD4zzcO?=
 =?us-ascii?Q?kPBiCBw8Zu67UthROuc4Z2hBGZFX6qzSeY4Fdfd5YvOsRwiNqPOib46n3VtE?=
 =?us-ascii?Q?yQcS/aOBn7NXi2MTXmgyFHWntJCu8FJq6jw2xeCR?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	8cvCPSDWy7LJe94u7hNEQ8xZwWlUX1jhH0r0jqEq7RQc3CCnvOMzXMhOlWyhLIPPou/UwDB0uUvx2aDqje6LGIHBhjxRcWvyiEAGzWvpKZT57BRx1ONJ+K0Aa5khYS7IFvFevMkciJgZ3CHguN8bDDFtse6dyycdEhpdAuXSL/KM0H4D/HZzunNM73vQjVWfIHQSovAOV7qukPSqyZd+MAhwo9kOnVrLbjdJgCuY+or9mZ9Z6msp7ZPsrBim3AtRcc7Wi1wdfl19s9ItUDyo6ewRuUVPqEkoFQOSjazxWlPcw6u8SLlvH8sRfsPYrq/1kqCBTe7g+s1Ed3VkJpvakBdj215b3zSwxJag79pCm9vJA23fk6ViQT+7auCey9l7APLld1hqxCRPwEsvwIhvUMpU6mRIpcDoj39qp+BFSw5KB9NTTkQTnBuCrvDqtokMFQFNsOsW5oqgUIVOw4dLurBBnw7mapM5UlK78+El3qqIXXyV9PE8xvmQpUp0Z8UjObod3sWtBaU2dPKpigmnzbovRawmwu6kFVvgxkm/SQCbnPRXy3EioeJjBeYJwvS6IcbCwB5utB/Bjlu0bzVqKTJeJ8x8u1aqn3mNhCP7CKk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9124abd4-df2a-4634-1c7e-08ddf4184ab3
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2025 05:25:32.7892
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pnLs6vIZP53But4eS+L3QWrfDKSIBhHNkEf5CTT3xIQJ227iao5PzmAoV8RfZ5mczJKti9bhldXq1bZ0YHJfbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5142
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-15_02,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 bulkscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509150048
X-Proofpoint-GUID: IZD7DDcwCNJhuc7i6_2ZHaf2s9GiZw3R
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTEzMDAyNyBTYWx0ZWRfX8AK0tkSbQe3o
 daEmuqTU6pW/RrX7w82d6HnRfX+jeyX6g1TJFSx2ifB1a3+n3epK26vSM43ZZnBJK/rRr51h40J
 ymRenomaz9JSCv3m1/CUTzyJZPKuecB1Jlh3Ob/FKYBlOrHSanigF3T85Kmh8wfXhB6pccPfT/3
 Oay/Ms+vRFLhP4GBB0fl+OWGxvYp8X3VUOImeG+/TvK5x7ehEdxRLuan4yw5oeey0AVLiVHq8oY
 doi5OwlaKcPJklmmRxd0wiSL7T3Yzp/j0aZLbj8HkxiW5aLuqfqwCmyzIpckwLrNue1v6zllW/B
 JMgB+Vywg2eueTc1zrmXW9qFOLPTAd4zdtnqLw2AfaYAeAjapxBfcC7AqxDwKLg5pn0nmVkyBfq
 lN2HOk8GX7DKfC1aiGFGc0HB8CkBeA==
X-Authority-Analysis: v=2.4 cv=QIloRhLL c=1 sm=1 tr=0 ts=68c7a352 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=G1G0JzpMrRivsycsOdQA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13614
X-Proofpoint-ORIG-GUID: IZD7DDcwCNJhuc7i6_2ZHaf2s9GiZw3R
X-Rspamd-Queue-Id: 366691C0004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: owqpgxrhd1njxktgrkd6oz9eqea3fq7u
X-HE-Tag: 1757913944-453966
X-HE-Meta: U2FsdGVkX190PQFXhE83UTAs6Sm7ntf5PWMSLILySqMG1w+UEKef2wJaFCc+wDLX1VzX/dJGFzQYkVq5V82EItD0kYVqhGksSjdCynJbu7l42uaeKqLVvTpqxdlXvu/Zhqi1ZYvsdFCm9RZ8qoT2IbgT7HcxzfJ434p3UAE6Dl3zbTrRoll+p72YHMH7VXo98pSh9i36aOomF3Wz9ZTIiIrARC6gR7z59okSwOuPPqzx7TflIp6aHMezbXfCxR1i4Pku3wjjbg0OzgVKycRgUoe/qMD0O4WPHeSGlHxH/TtKctDZ4jlqiSo2pARSfu4DVTf7j9OOjibtNh+M7iKlaPPuY1Q63Zim4wOOXkF2a5BApyipIb38Pzu5Tr9sRWXumEmwQ3jCtBV3OgRv6xtusX6W1Dm8E8mq6J4FdrZxKqk+LGBQAFdaMZumiN07S2/x5OL/HK4Sg7u966GYYNtAjjdfYMjwhXIo86CgLONsymt1JKuclJq63yLEIyXpriZnsj9sEk0huWyRly3Hh70rP+Xx9nm3R0NCNHYL+WtYHZ7uyvsdljkbRttkqRj/upb3zu7b9wVp2L0kkE8YNQ3RV7HWs+6OHBeDhAQVh6vaehOgyAQmwDqF/mvm9DeGoD+Gl2rqUBYUrHFlIOD1+ycf036hdHxLDM9pVP2logWS1d1Xs4VdVbCmjjU0fjLUruhAT2yFj/s2B9KtGARRasOPgkRh/YiMoUJD6IXIkEFEDkXbvDOJGc6y02lWJ4JE6ig1MZQ6qIOKBkyuebIi2zN3XfvaVP+BXX+CuTmhkfGu3X3REkWiOv44OM9Xu2PkCDVFYtiv3l5h+VbppywcyoE7RAvPGtHQ/Chk1APupC0ADrbNXVKLrgTXqMYfDeCz9Bib5J+zW822NlaUUi+nigAKgilVWnAAg/CjN/U5a0Ty67JMVzDjKAQbW48Y+DXvxJN7hyzP2o1h6E5ZVBx/K5L
 oIydTiJW
 i3lEqnnKHMEZbnB0a+u9a/6yYPpUtpSD3KYL5bU/xdeHvGw8PO9NyAfSDCPSpb6Wp3JAT33T040nWl6iKhTbagjlYRXw2AFH6OA0XVptpoma8qg01hFK2f2G6TpNrWacmr7uRBP7nvUnVcrjXJnMZdGvM0GhvkPPo7Jb6EDdgJpjI2W+UJmDz9juijhQU0UWaTYcATdJtJBA0myxKlecyXepZP1C8HpGQIpShhQTdybRSMoMj7Vc2IZqS66mgzGHKlBn0t/jEXbfJYRx8swKWCEBLtLkEaXb5oKZr1/Qs8E+SGcMM3Hf7bKpTKPkzYfFl1A5wCt3Ht/f7sXZ5PcV3QuztQjPFeW2OEEgn0kb+9xRDuRYUw8Hu7+EcG4C1XnV9yuvoQxauye1EbgjhTFS6ZMtreJ909hEP/BFTgtDpKJMwahPeqgWWL0QDER8q4cVIlQY0V2/+33BUzvupw0l4cuEVeonBSUIHR3aaZV0pRJ/tWd+vVhIu0544/DaX/WI8pLjWDFZyyV6T9xEyusu49ziJCdaZPJ4QE7iWAaOwiXJ+Y+AhqntHrr5vSZnWWmcYgzpT2k9HT2eZNYm5dfMWTuTR+ysTdKkLa2qW5gMZAjXhviZYBOFf/HEB1TZIQre6IhUbOxzflW7ba54jEuddQbWb2kHOah/snq5+SoS0YsWfN9ZKkN9xo5pWke7aBFS3/8U/To3kno5oxPpa309uMSFNH2YX4OHcCFg/N96ITPkV8o5SPJX1TH4UpP2gzXlpG3RRLsv4VyIjpjQnMxchp1ABs8V6CNmxhdYoReLELRJoeGS7aynW3Hx8XlZusKi3rGCKP5fiDUtOb/VB10YSwGKjcB690iW2RnX0bTvjDzPJ1qGAMYbnVEJ8DmNTJOrSt28dIsR+VvGsBLeDHB6sWJs3nKCQZT1w1J8/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 08, 2025 at 06:00:03PM -0700, Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> Change alloc_pages_nolock() to default to __GFP_COMP when allocating
> pages, since upcoming reentrant alloc_slab_page() needs __GFP_COMP.
> Also allow __GFP_ACCOUNT flag to be specified,
> since most of BPF infra needs __GFP_ACCOUNT except BPF streams.
> 
> Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---

Looks good to me,
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

-- 
Cheers,
Harry / Hyeonggon

