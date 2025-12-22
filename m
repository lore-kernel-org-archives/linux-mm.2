Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9401D711D5
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 10:21:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CCD56B0088; Mon, 22 Dec 2025 05:21:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A4D86B0089; Mon, 22 Dec 2025 05:21:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9EF26B008A; Mon, 22 Dec 2025 05:21:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D48B16B0088
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 05:21:12 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7F7FFB9CF0
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 10:21:12 +0000 (UTC)
X-FDA: 84246714384.05.19585B1
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf13.hostedemail.com (Postfix) with ESMTP id 075762000E
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 10:21:08 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=kP4IbLYQ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=UKmBnFi3;
	spf=pass (imf13.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766398869;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DEWxaugCh1/BoyshFzxYWrv8fV13KQVjepphJD1ABaI=;
	b=yguhxrn9sMpi9IsilaRedoI5ks9WnNc/Uczcw1OQiTS3NZuD57Z52296+PYnMgRcOJKVI3
	MeTphvYHZokztRF07Gzkb4ttAfk/4gygNrvpCY0D6vIqyRqyR2VBXDCvG3i/PtC47rvCMn
	AwuJM9vNDHq6HeEhp0I3Gj6oMOVkUsk=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=kP4IbLYQ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=UKmBnFi3;
	spf=pass (imf13.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766398869; a=rsa-sha256;
	cv=pass;
	b=PWAgxvstxz/dtrhBodP/xMnM0DWXgJ3arulOZktGyhq0YuStnT+Wy7Hy0XLT+fQS5vNaCp
	9yFePacvnP2NNmLfpoFP9H5CVpz5fjv1ZViHOlNBGPek2XsrSOxFQPYdgysqrx/5+JwH0P
	O1HSZhtwiRHpbj9c2czpGPqlw3z+0QM=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BM9aPC91942826;
	Mon, 22 Dec 2025 10:21:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=DEWxaugCh1/BoyshFz
	xYWrv8fV13KQVjepphJD1ABaI=; b=kP4IbLYQ1ahbDDs8jtaHF0eu+bPofbxF7t
	6qgcgy5ArqLq69m2Pap8QtXaS9y1/dv9WH/7PYqKeP3HxlLG/Niv0cF8XY6HMhjy
	ZgwclpjmTkmdfxzuaZblGLH4VAfPC8PrPDu+9njyxEl+cLPdSvM0pUsbIB8cFjw7
	4ZxpCTJ0mC5TUIrUWbttjVgbVbhikGPPhjDzDm9noqBsILnPK34Ry/DTzay9v6Qw
	rIyLvi9VjHehZhSn1mCzkkyvicpAloN9KvmDBi94G0VJvxndN4dGnXg3FfZGCflv
	d3UhvdjDH2uPUa043Ne/UlJfkSc2bVrppXIjP3EkOyUYNG4/+8nw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b73gng1t0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 22 Dec 2025 10:21:02 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BM8el2h016543;
	Mon, 22 Dec 2025 10:21:01 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011051.outbound.protection.outlook.com [52.101.52.51])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4b5j8h601k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 22 Dec 2025 10:21:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AYPN/hE1nNUwfY283STlJBCfuS83EQAcSYQyrqbZgbN30GRFvl5rCmnDQF5hAeMOkDiUuy3tNGBjiLmtCcnxgewaQhZxQ4b/v/EG8QY1fat1UWd3Oe8blaAEzldlAqgsTTtraI2T/9u7hnQldegr7qbxhkjbXFSQ5+GwsKsQL5Re44TWyoe6yX6n0oPYd1DhW+p6IJZAQ5QRd4t0HI1W6FhlDo8MarRNaqigX1v15Lqi8iR6aKr2x1uoN0GGDprGpDhABjPqpkc/h/R3HJX1ZbJSIuboet/bhWKz9RL/VYO+8gyOnXcmiZktPjEN4npHX4ROxeiTSsJK7hwEYt8pCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DEWxaugCh1/BoyshFzxYWrv8fV13KQVjepphJD1ABaI=;
 b=fEG1a23KgyA7vuhldBFO8LK60bauJrHAUkRIDknIPjZ1SLho3838HtF4VyAflN308yYKb3eAAkiZN+CgPD9/w/RuNBWDqpAirHO1WBl6jN2RYAwEeoXKoRfRNf08ozTcjD36YR67e8zWbvqEUXPm/TnUg1YeohW3VL3MvsiJPEG6LkFQ19j4HcFZereFJTFkfzJKeXi5DKhpOb+H1YrgLYKAFJCIKrVhlND9RESfvAtPyq/W2rGExQbhS89vxQrVX8LbVEQ6eTTqRaiNehW9H0VGyjSZLc+L6az97elVjH4/Mgq11T7zOZ7N7DzOowOm5XjbZqvG8NAtibHb6qWstA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DEWxaugCh1/BoyshFzxYWrv8fV13KQVjepphJD1ABaI=;
 b=UKmBnFi3xgMGbvRL4I3Y9rQmj/FkJzf2plMXnL3AQ5SPdXiyYN6/62u/+KY7Fb8EGD2wHv/A4KDIUUXuWoWaQGQDt0eyHNWHZN2uozzDJ0V8O6sO+yMpEkWp/qP7ou+GeWA9BMJdwtczPh4/5wP2fw4v5Yp8JP5mLrb4Wm17io4=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by MN2PR10MB4127.namprd10.prod.outlook.com (2603:10b6:208:1d8::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.11; Mon, 22 Dec
 2025 10:20:59 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9434.009; Mon, 22 Dec 2025
 10:20:59 +0000
Date: Mon, 22 Dec 2025 19:20:51 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Hao Li <haolee.swjtu@gmail.com>, akpm@linux-foundation.org, cl@gentwo.org,
        rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] slub: keep empty main sheaf as spare in
 __pcs_replace_empty_main()
Message-ID: <aUkbg1FMG3g8zZ8V@hyeyoo>
References: <20251210002629.34448-1-haoli.tcs@gmail.com>
 <a231264a-2da5-4468-a276-777fc0241246@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a231264a-2da5-4468-a276-777fc0241246@suse.cz>
X-ClientProxiedBy: SE2P216CA0181.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2ca::13) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|MN2PR10MB4127:EE_
X-MS-Office365-Filtering-Correlation-Id: 6aeff8a1-8e1e-4045-3eee-08de4143ccd0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?W1fM3w/O0CEpO3OS407aWkwd3ikZRAhRX1r8Z1eLwJ/ZYiilHeaWe9QBI3UI?=
 =?us-ascii?Q?pTWGosGbV6urlTdicLq3ldi/qTI5k/PiXo8nfL5+UoVeZvpwrnHl524FgTsO?=
 =?us-ascii?Q?KZDuBSiacHYkf7skEKivKXWaoLbVELccl+NGXtmFLG9daaUJ0XIQ/6nRZqQt?=
 =?us-ascii?Q?nKXIHfAz7pIThCJzHKa8SjTFwKpWWlFQ94ly5TbYO4w3if4p3VgN60eZhh8k?=
 =?us-ascii?Q?iWP7izOMIk1Uf5WaeC+n6/zpRLTrziT3aC9GfyidfV7z/Y7UHkkPFUOYGqCq?=
 =?us-ascii?Q?PLju3iSf6+K9GsmZDYGxx7S7ZS6z5V6Y7HMdIyLZC8BOSfRel9kk9MfNRk7g?=
 =?us-ascii?Q?DRlZPpsc1UkfN1z3SSHf3q9gJEOPKOjN5eyv3UGvNPTO4/OInJg+FXbo2EDu?=
 =?us-ascii?Q?PuTM85OvRlB1GhXBYKn6cpEHUsPxr1Ciy3ykrz7jQ/B0XKqq88MDUqVMner8?=
 =?us-ascii?Q?N/jUBYKDMpnwX54u2HH5R4BRNLVx7yyphrk5ZUOlWzmAPFU7VhCa5Zyga473?=
 =?us-ascii?Q?GJj0T1f3B3GjbjlLyVbsGxsxp7a11UZhr8mMFDHoAfXbihj/zNJL7EWHsJQb?=
 =?us-ascii?Q?P9tFmtWsnfEjtSf8SURsu/D3+yifJKorqhdZXIUnaSCSbYPCE8mg1Wjefwjp?=
 =?us-ascii?Q?6Y+tpgHj5DQs0xlfUWj/C1X63L2MQS6Wrmf51Mt9wdFmiv+diMj3WTBJlXjw?=
 =?us-ascii?Q?UYCPdvlYV5fsQhlNLRyINyXONPFGZfSz+M621PkISixyDPTwC2tAQFaZC9Vu?=
 =?us-ascii?Q?oH9oBM48Z9hp3o0k6waR78BhkMtQ0OyJtygET8u5ZZrn2vfC9OKlKVKQm4py?=
 =?us-ascii?Q?NPTwQbgLycGuvdgAjJbvfNWhZFiVKuhL6O3ZsM3e/KmdQODGEPsCLGNL3VVk?=
 =?us-ascii?Q?uh6SwfUH+UbO1cfF6R7o879Sj5Bi55XgqwfrabBbsWWwa3S58MffAi0cA8ob?=
 =?us-ascii?Q?8MwvO1gio+WIlOhDduQoTtjQsW4zMWa3v6ycxrEnfoDLTdUvdAWESxyW+W1h?=
 =?us-ascii?Q?Jo/zLBjQYXZikeiMdh56RiQ9jgAc8Ji1bwPTI0qYt9aqoP/T29KAFrL+pCEk?=
 =?us-ascii?Q?4ElwqruGk+p8aTzEAkOMkims+qYqjvhhdBBkVimZixA6/sj/gzW9AY3IIp1H?=
 =?us-ascii?Q?pigL3VwuqVZTAtdA+UNN1ngYNH74N8KsgzzNlgwDYgHdqFnbJSEX30MS7uXZ?=
 =?us-ascii?Q?hAqeZuq5rg9n0kXHX1bIy++gwe3MtqB993p7rZxvLTzGvSLpOUKSi95n33Ek?=
 =?us-ascii?Q?XF1zJGhbJyZzIzJgAJ9gbQQRxwEcPVFGDzDw8j9W44gkJIp6gu/fTdMfPy5v?=
 =?us-ascii?Q?U4gbll2VGh6eE0HmItgmg9p0Z+nJsOI4cOD2zeSreXAVBB1+dVtfd7tGOfvF?=
 =?us-ascii?Q?0VclG/M3RfNcvI49mcW+NTztWg/vjaehfRP9KR9cbvMJe3xF9w4lcVhqFYsg?=
 =?us-ascii?Q?q8Cg1WsqmKYIfeRem79xELbZPuoDYz/Y?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gJIB4TZO5beffDU8iodE7eZgm0wpXJerNSJT/ljHo7NqkpdNbEcX5LdC4aoT?=
 =?us-ascii?Q?cjr8M7apNCfkO1/qpBbiwjNNrTWuDqU1bCwIN+WdOcBmceeQoPe7VwRUlPlU?=
 =?us-ascii?Q?bwUYSoJr3D1Jz17NH5loApqCt5f5+HIhcdvK+Yg+QK8MR0B2d/YUNc/0Rwh0?=
 =?us-ascii?Q?zrga+vCb0Z2MsI/pGyFG1p/q04nnxgBC6eE8QrS5oydgj3g+7YOWsl/7oVsQ?=
 =?us-ascii?Q?uL+d+LeYeFedPh4tTklKcp4MGm+v99r5fKFj45DwkEMMC6P6CGQfGWO0EP0F?=
 =?us-ascii?Q?8zOVjj/+efDzsTYrZ6snyrqtDKv2n1AvDWYZPhtU8bxcK8LQ7eU8CAwtV4Kc?=
 =?us-ascii?Q?DUH5/ibtAAcEvNNTyHGRBTDWkVUX2FZ6vUIjHRkx8QGZjFpWy/6v/oMRfvpO?=
 =?us-ascii?Q?oULYfiigcppZqJt5Q1mQ2+mhOgSSxWCh2a0c/+ZHfgbMlF18frqNCoKs443P?=
 =?us-ascii?Q?+lM/NZn0I1uocndXGqt5ggV48RNwkx7iKqbLUC4WZxd6EhL/DbLkXbmg8vZh?=
 =?us-ascii?Q?W1u7dt1quWiOSiESyAu/03Zc7aYkoxQjnkoMlUAPDrKrbk+eskuVuSFNXjhW?=
 =?us-ascii?Q?k7ADfk1ifmR8XhKOvDSHz9h1ggnycgrDGQVQZP78AC/WVJ84V3ScPjxIdPXq?=
 =?us-ascii?Q?jxWSUmUUN9aoP2lMJ3OvI3W/bmmIAJEhedwgNFznxwDTtHZOIP/EEqgYcfho?=
 =?us-ascii?Q?bXAxoTDI/KNjz2Jmt4CxsVghALMbnvQJo5FDKy1P7HUhiAcrFUvOQrP82sgO?=
 =?us-ascii?Q?/UnA9W9P0k9lt+hBmVEQaWC3F+hhOlnVahcIR/JfsOwQAyx5/wIMgtJjiFeT?=
 =?us-ascii?Q?747fbno8c8FD9Io9Qua6ooXv52UUV75YBGWQiHMtIjmnCWOInsa0zWi4XqV1?=
 =?us-ascii?Q?lgQL9GAoywy17zEetAOK/53OweEeVgiqJKriJh7NKOemlZeAH3G8Ze3W/qaf?=
 =?us-ascii?Q?fA2ln9NeHmQaHsYApblk4a+YPsN6/Ffd7+bXdCDPn4NQ7kPRrMKJ3tnAUzdd?=
 =?us-ascii?Q?pE9cvRC7GIMvaFaxtSa/M7bZFWQ5ELxMj9Es8vNYbKZ9UuhB7yiYOvL6Bf9O?=
 =?us-ascii?Q?ZS1m0xD6PXgJlUFqoYY4aLCWL6toy+kEVW87WQtJSNFakfu0N0Tja9iQabV9?=
 =?us-ascii?Q?r1hNIiMQ6AsyUIJkC7UflCV8xisWXFN3Xlosgl1d/Pxpcb90VegVQgEUKKR2?=
 =?us-ascii?Q?0FWDjSpHay3Ho1p4mCOZqOvjktU1XfG1R/LefzNyrPa5EW0fwKlyCaRpFxEZ?=
 =?us-ascii?Q?oGPz5tjGAGA0bGDt7kzMKeM1+sy6ojvY2OiU7iMkj+Eb8YxzXPyVjQ/JJs89?=
 =?us-ascii?Q?7MJlECnQfRe6Ay2ucH9xDSAngKrWLAU0wcUiQye1TrK2D3fuq8snGRb9yFYc?=
 =?us-ascii?Q?UpZNqidrE2Dd07gbmH21wA++BN08dHHN23FrDwp0FojD34Tb6TfsauC+h2go?=
 =?us-ascii?Q?o1Ry1/UzlzrXhghpRFQVGIgE+0bIwebgQoiXem152cSEKKN5XdO5Ww3DfS4g?=
 =?us-ascii?Q?jDnoNBtFM07uFzZE1ln4hiLAyCd3FXFilXf1yGsErBMKG53bWZeIiCuiogz5?=
 =?us-ascii?Q?Jank4dv3SNYLWLbJQvK9GIr9E9PNGllzK+C4ufPiCUv0s7ntLPSdye/38jw8?=
 =?us-ascii?Q?+9S9e2WgxxTqXsme4l7nw+ONlv5cY7dmfRcaJQgSqC0FuUpqJ19w90O93q2d?=
 =?us-ascii?Q?i1eXgqQnOiw9XpwBZ1PKH7V77zjNpID/1dV6sjY7UGIcRWzwS80YZZUPwqBT?=
 =?us-ascii?Q?ebRJyqTcvA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vSVqA9TbfdcAAZbjzEb0SVJFFATAhAcdrpwoEZdioTNi3rGMAmHnWD9jhldyYwAs6ii9Qcy4BPpEnnSHruJexVZVs8lBg8xyoOilGCKWUzewMFZfvIP6X/1ncZCvxPEovW74NB2ijZNvUgIUnQxai6fJ/VZ7r+WUahSj1+KsxgQXBHT2z8wVvEuXfU6upZEQ4JfPYB3KqoZ6a70efTbM/LYlUHXf/T/nWnU8tMycXFU3Gm6oLZv+EAnVlPvSLAAeEzR82Ht3USK8y1aOnEIloVKM3LB5mf/V8FIqC7Yaarrg7n/vkA4T+qIfQa9NnfwmSsX4fbxCQanLccYl1m3uKXgJlsTCrwOgUd3eiV7H7dQiAkD21Zqqwy3y+kjJzyFPJauvhcpJpLy/W7pIiwDg6cPB9TyP1J36Z0MnrZnazsdDW9rU8g+FVZyHgEC3R2DtZERxwYclB616mM5hjfrHiSr76M9YpEogs678Bvnq7xykM8Nw/NXM8/f9pCsRBqln9qK0lzHGJLtt8O/sWw2Ls19l5PXjmDIEKF0Pjpf/fE/s5QqW7o6T28gsjRTxST86icqv571up8h4er33ArgyDDCLGG9SsJryuRchqpBH0a0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6aeff8a1-8e1e-4045-3eee-08de4143ccd0
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Dec 2025 10:20:59.2161
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2xaSPvzvhJjmWkJDmtRP4vQzllglaKX8ds9pyCx/qDxGkBqEOqrf/tiUfo5fRA3M6hICHsLNFcWkckEK/fF3Pg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4127
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-21_05,2025-12-19_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=782
 spamscore=0 malwarescore=0 mlxscore=0 bulkscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2512220093
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjIyMDA5NCBTYWx0ZWRfX5/z2oL0Vdyer
 3hePlrePDpL8ktvOA08AISO4MCp2hvzS1ZzkStvlQceug2GTi28Cefg89NmaOrFqg2L49V3oK3+
 0U9GfLQvfbuUl9XWh0JjDUmZWEp6rIu87T08N+yNGjcNWKM7lqgJJ5vq2hqHNJOX5RjXYMcFzko
 qc1IOR/KQGbW9i/suii1Jfi9jMtftTWy4DqkLqJcpOBncfNJw/RXhAq8yrWY1N0jLIUxyM5EiWx
 xg1EEEbpbKz8BaOfrchkYiln4pnGT7f1KcuU2OPUDghDfnxKXqBtwKaGsyCUsbv0SgWo3E/E7oG
 Bmjhq1s5ZXEJqvSruaQ2Fr6R4oU8C6aBMPq4U8WLoVKZ6mS1ageiTIN/78m3SyVFAGjLUV39u4t
 CpcKd++ozpJ8eGtLaAxIc52m/dqf7SDTwEbr+1MNJ0c4fFZoRXSKJ+DRp1tS+TikdBDqnKOiuTX
 KOZpO6T+GOHUM2vicEGibObRRMBhrSKwbsv110P0=
X-Authority-Analysis: v=2.4 cv=NZPrFmD4 c=1 sm=1 tr=0 ts=69491b8e b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=pGLkceISAAAA:8 a=yPCof4ZbAAAA:8 a=-YfL9HJC0o2F6NPm7_wA:9 a=CjuIK1q_8ugA:10
 cc=ntf awl=host:12109
X-Proofpoint-GUID: vEqrHunVK_On1-fohHZkSJk-e1sUKxRl
X-Proofpoint-ORIG-GUID: vEqrHunVK_On1-fohHZkSJk-e1sUKxRl
X-Rspamd-Server: rspam02
X-Stat-Signature: spntwtjgwm7dx9ex6p9sk37cedayp9ci
X-Rspam-User: 
X-Rspamd-Queue-Id: 075762000E
X-HE-Tag: 1766398868-86922
X-HE-Meta: U2FsdGVkX1/TPOvqQc+qeq49r5RbC1kloXGc/7XN1yVMSLs3CS7O/lYF/60PlxBOgHVGMHrDprOr0kPmdiswiyhmTvZyFJz1yyNqx79/aUVeMf4xnVH2o5eIkUcTJH2+u7FhGHxkOeoF12jAWvneKcZ+VVGlOveV8B5cQOLlWN+SSzwuPOcnC6O1Jmg7efbkAK9OP5557xm8zPKNYIS5kUMYmXjDSXmwFUOSMHXCa3ajE16JxOgV32Y8ULbk0s1mkVjfksqd/YvD0qy/mqlco1Y6Jv5/MTBy4BGovxR2LZfBLb6tBFGcl4W0GAjzq3Kl3lYh5CaWKl8Oi/8bk8uETmPKkodQL5KaWTo5wsJjHfK7NSHm4CwnqxIPrGGk5itoiaBpzBQtLto6+qMux3RBGyzqGmcnkBaAdQCV6VCpPJS8ZafjfRHtNRdzJQ7tqfp0tZ2IvjydUar8r3/7FuIFFTExkmZA6DxY6nZ0LDpgPlysHW0Y6YcRn9lW89dh6mpjf6z+wGXm+xsTPNrjPuiiXgY9mxaCwMce3iGMNIeSC88PcnouTHd1Tk0hUYHCxX4uF+Bzhu/TTXSaXZHoPPUZWfkzyRNppyQNQZvyWp024+V2rQopZyePvf45YX7GCKsP3EUjDDb506Bkgy4hsobrgPKl8myOp++h4wuhyKGCG0WRnnmoFOntnsuua9V5171zFtxb/S6oMh1qsJ3yf1FqnemoSHY8wK9r9Tpl4r9YkSdWz/ecDJM83S1kJ1x5QgN6ftSU44PFcLJGnXrzulnkc4FLQPl7cQrQWqT4c3CYHxSeTlJ8Q9OPr50lksOcxWphTJyY13BJNn3AwAolIv2UEvU0z54+4exr5DqxeSVkH0ZxvNbrHAgLTnZS5XBEJw5de11VNlPDAVofpRvPcwoHXf0NSe6Ho9zaqZVS3ctuOGSLX7wtTbw+sTZr/Y3BBC3dQo5qIgSJu1Z6Z4Y0Qka
 SVii2t3v
 pEofUwIvbdZUS6cd58KIEm0TCazj9FHjZC57JjpeLhB+lUtin5RM+AjMT2GEDmC2BSxj6u5sw+MDnl9l7VSY13tJn3/noos3to2zf7fVB7tJBrxREYI2TAF7OKKQ3pBNP88qltkaVLqf8H6sGMGk4sTSPEfnFkdnp7L/H9vKpyZszJrnMtkfzO6uaXLarxU9dDFJDcDlfvCVecprJK53uVfLqNrGCjY0Trc90ekkJBLPr+uOIgAgsNA0vuwueGd0POlXIGYU2Ww7/pG9ANUbN0CJ/KauBeIMUK//WavvgMtytn6MJdobcVm0FJDU7gc5A4itYc1ZyA4GSqPqTwrPIaMTpElxAlO2i/x3qXuPl/Cjjdxw1HXatg0BUtUZglOGUXSd07/b+6TwfELBf7d7+Imf2Fabgn5WS8A38kbT5VMXs8Ez3/Y3YlV9uWJQWdtB3eKMdhXQsUv+Tggj5UJdWkzJtrUuLR923weTp8fvdelmk5uUcAjvwiG/W+0qQ3+U+2V8MCxUwJhBNNg1jO/+/Hbtb/9nM24QOsdWx3UskhNxCngR2uR3dFccimhzpSYwDDxRrLLofmjuSUBTU4aBjKpdKhZSw8OYyz/mC1VVFE8KMTmIt3gpwMW0UEK2MS7kysaKkXxpwsh5oUynOnS46Ff1F42ak+zhfNTnb3EqbiGA80RW3fICsZcE0QLNaAf92jxgcJACIV5w8CvVVAJiFwmrs1O9JVpmW0Xb7Ef01fcNlM/PZbwJZZI8A1vkCthA5CPvq407Hp2enJPLyi8jRs+6MbUDiBSvG0ZrvKBSihwO8ta4cxHlVmqO9lEDui3WMR6kR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 15, 2025 at 03:30:48PM +0100, Vlastimil Babka wrote:
> On 12/10/25 01:26, Hao Li wrote:
> > From: Hao Li <haolee.swjtu@gmail.com>
> > 
> > When __pcs_replace_empty_main() fails to obtain a full sheaf directly
> > from the barn, it may either:
> > 
> >   - Refill an empty sheaf obtained via barn_get_empty_sheaf(), or
> >   - Allocate a brand new full sheaf via alloc_full_sheaf().
> > 
> > After reacquiring the per-CPU lock, if pcs->main is still empty and
> > pcs->spare is NULL, the current code donates the empty main sheaf to
> > the barn via barn_put_empty_sheaf() and installs the full sheaf as
> > pcs->main, leaving pcs->spare unpopulated.
> > 
> > Instead, keep the existing empty main sheaf locally as the spare:
> > 
> >   pcs->spare = pcs->main;
> >   pcs->main = full;
> > 
> > This populates pcs->spare earlier, which can reduce future barn traffic.
> > 
> > Suggested-by: Vlastimil Babka <vbabka@suse.cz>
> > Signed-off-by: Hao Li <haolee.swjtu@gmail.com>
> > ---
> > 
> > The Gmail account(haoli.tcs) I used to send v1 of the patch has been
> > restricted from sending emails for unknown reasons, so I'm sending v2
> > from this address instead. Thanks.
> > 
> >  mm/slub.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > diff --git a/mm/slub.c b/mm/slub.c
> > index a0b905c2a557..a3e73ebb0cc8 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -5077,6 +5077,11 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
> >  	 */
> >  
> >  	if (pcs->main->size == 0) {
> > +		if (!pcs->spare) {
> > +			pcs->spare = pcs->main;
> > +			pcs->main = full;
> > +			return pcs;
> > +		}
> >  		barn_put_empty_sheaf(barn, pcs->main);
> >  		pcs->main = full;
> >  		return pcs;
> 
> Thanks, LGTM. We can make it smaller though. Adding to slab/for-next
> adjusted like this:
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index f21b2f0c6f5a..ad71f01571f0 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -5052,7 +5052,11 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
>          */
>  
>         if (pcs->main->size == 0) {
> -               barn_put_empty_sheaf(barn, pcs->main);
> +               if (!pcs->spare) {
> +                       pcs->spare = pcs->main;
> +               } else {
> +                       barn_put_empty_sheaf(barn, pcs->main);
> +               }

nit: no braces for single statement?

>                 pcs->main = full;
>                 return pcs;
>         }

Otherwise LGTM, so:
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

-- 
Cheers,
Harry / Hyeonggon

