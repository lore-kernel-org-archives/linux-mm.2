Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7E72E7FDD0
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 20:39:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 172ED6B0005; Mon,  2 Feb 2026 15:39:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12A906B0088; Mon,  2 Feb 2026 15:39:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0024E6B0089; Mon,  2 Feb 2026 15:39:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DF1C06B0005
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 15:39:44 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 996C0B7A90
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 20:39:44 +0000 (UTC)
X-FDA: 84400682688.21.2247F8C
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3B4D0100010
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 20:39:40 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=hYVfzcps;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=MEIe39bP;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770064781;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iu+CITfqzicBGlLMmAWQj7cuNNshLdPAGTYb7UMtdqY=;
	b=dxl55YcXn9IeicQ/KwvD6baCY2oobI/VxTelzFxeV3SF/JoxvEtIJf3q2PnuWlsKEVLva+
	s2as18hBNxuFJvjKGnvXzVrv8npczUnWj5L8ndLOAppU2D2vhfunTif+4dgDZmAZdiGZLc
	jzcmvxQvdeK2RhoWgFsYimrjHJzNy6Y=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770064781; a=rsa-sha256;
	cv=pass;
	b=d1FPKafHf+HwjHOMYWfMx+yW/N9gEo0mjfOXvI32lDW0pmNjPl/2SKczY3Kjp1phwwTRgC
	uZ/1IEmz5C+ARdrCoewnXWG3vC02STF+znaVOLGI4em/+amJgzGj9wezvg3ZunxQasXTiS
	FjEO5eoN2N92Ch3TgWCDE/0qh4bEzh4=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=hYVfzcps;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=MEIe39bP;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 612J44Rx769172;
	Mon, 2 Feb 2026 20:39:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=iu+CITfqzicBGlLMmA
	WQj7cuNNshLdPAGTYb7UMtdqY=; b=hYVfzcpsJGP1O4/3KjI58sMEmevcqeqaKO
	iFmKqYhcWB8exFwT/qnIl90vv6I7lZ11jeyymt067lbnp9yQJ5VMTv9VGD9uTrmU
	KhZjAfY99dpaawFvmkxpmQZi8zpKlCcJVdQ+zOJt01MzgOAGpeI35pOhH6xlPSKq
	Yb/Nv0osbPvf16LO3iqqs1bhYUpMhoJeS3aCGL3jQKyT4VoHK8AJUi9q8boLq2x1
	G+cbBVI1skIEvGyuebCY1JCo3XwJXp19b4WbIpeJMpwBcweOFBs908Lqgn+MI/k6
	UXObs7N0dwz/21H22iG9PP3UIxtZgpXZVW1qS3K108kc0MiMQfCg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c1atak03x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Feb 2026 20:39:38 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 612JUuhY025362;
	Mon, 2 Feb 2026 20:39:38 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012066.outbound.protection.outlook.com [52.101.53.66])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4c1868wstd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Feb 2026 20:39:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vK42eE1o+YPgieRvz7OqcULxS7Ty5dbKDq3TE8o535wFOs2FRtSnCcVadbfUbwq/x2DDACcV7ioCPCos11r4RndMG6Q4YBVcRXPptxdGQcNO5rDcp1YhN8LC1twRJkF63ZuL6RBXb0kAndFVPsbsfZlxS1eZ9lmKmwOI+sdP7yzq5MAWT+IX1wOspXxDP1cNAb7KDs3lTLv9jmRMUMBrcn11Z0WHc8/C/kGK1IgJVCaYyS3lXo9mejIiUnWPqJbeJfZllbLq0MvfQIgwV0BkGrrM/OX2rTkntLslyGcMlwh9aoUfBhOomqpIKNbaBmky3zVgDIvn4viBy/qRdFXULQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iu+CITfqzicBGlLMmAWQj7cuNNshLdPAGTYb7UMtdqY=;
 b=DVKyf7AoLAgbfpfRoDN+GeN9P3XFhwwZqEPGGIQAbjAKxSSVx2fUNVns/Nfjt4NOdUWQm9/bcoSGieX7DDYo97DDpUoQ3ogZC1p5f/k5PXdxCz89mD5SgOi7HCPlhm+4GaN4ZE0z4iUbsDZxyLrnGf+/QEZMYk7FjTWjrJZbx5oHBZ6vb6p3twAA7ggDZsJ3f3JDsEYy4g8yNc4MyJVb6avNvO1cfyDLKEeqno9rUCXw5p90gVX5Cj3WUUW1Tf0ZEFsfka2QLsmjKvGeaFn6zQU8S07wzr8joT7Eo+Nlflubhmix2gHwOTsB8yTiICF0q6EWwYPb1zj1U/+A4N8L8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iu+CITfqzicBGlLMmAWQj7cuNNshLdPAGTYb7UMtdqY=;
 b=MEIe39bPjx6lNORDigez3zoBa8ba1ceF1+FbxN8tm0Ho7A2TN8toUpNW/W51dj3DWDtoLE4rQgBY9nGw/ncnmIAEzTC0HGsDJEs2EXNAwjQeWoUGxO4irQ0icfbZUAd3020/DDA31rai+WPFujZQzMHe67yrIZgwIjj7dzH0bis=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by DS0PR10MB6055.namprd10.prod.outlook.com (2603:10b6:8:cc::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.16; Mon, 2 Feb
 2026 20:39:32 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9564.016; Mon, 2 Feb 2026
 20:39:32 +0000
Date: Mon, 2 Feb 2026 15:39:29 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: kernel test robot <lkp@intel.com>
Cc: oe-kbuild-all@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [linux-next:master 10788/11220] include/linux/rcupdate.h:555:36:
 error: dereferencing pointer to incomplete type 'struct maple_enode'
Message-ID: <mmslqkujsf3epkowgd4wr75wi6jd47m7lpcwbwtv4ppsyppclu@lpy4azhk624r>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	kernel test robot <lkp@intel.com>, oe-kbuild-all@lists.linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, Linux Memory Management List <linux-mm@kvack.org>
References: <202602030233.gZQAuAMc-lkp@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202602030233.gZQAuAMc-lkp@intel.com>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: YT4PR01CA0334.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10a::16) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|DS0PR10MB6055:EE_
X-MS-Office365-Filtering-Correlation-Id: 2cef5ce7-6ec1-4f83-17c3-08de629b2b49
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?w/+Tqwb/6gnm5i6Y60JHMRJtkiAQkEcfjrpfUrTP/DaLCkW8MnRx4yY96mvY?=
 =?us-ascii?Q?h73p/a4v2AYqQjUFVFwTG7VbJF2HVGOYpUiTOOC6lg1He8jI7lYM/NHrraz6?=
 =?us-ascii?Q?HwlokyogYdT2/EznOhj/NkzHXrT+fS3vylhUAAq9vzJUB/pfxS/LqNXuL4d1?=
 =?us-ascii?Q?ThiG/d7Ri070vj1pE3CynylkD/KFODpFrNjysYpXTAzJgAlOZtkBCXMPKVDR?=
 =?us-ascii?Q?rAxWdNGLx2KfNKE7NxXQMx/wUSkwqx6GKx2WuSl0gNe4VVdIuycyzn1/fee/?=
 =?us-ascii?Q?o7i8hVb3+TXE8J/Hymxs4oGETRjbg/FtUhnOk0r+ySwDtMWZgbl7W3CCj2xW?=
 =?us-ascii?Q?DageLuyUe9YmffRRzsp7dw15IpbgY0u4/uYskgaM3z4UThQ3u84V43B7VC1a?=
 =?us-ascii?Q?/MAS7OUsE+o8bUSce4h3JODs8Jda6Zm/Mq/pIpmOBo0y5ks3+sR7/7Sb8Xhk?=
 =?us-ascii?Q?x3foNmxDuwqZ0w6xfq7b5eoNl+otWt9Yosl/92wXf1A1IKrjtlW/TW9jx7vO?=
 =?us-ascii?Q?y1ylLZIp6wnAN9V/uLJ+dDa9q0C9W7oRumgRkWK0BJylPhimTkK+6haMkTnC?=
 =?us-ascii?Q?rJzlEuVvslj3BnC8eilyZlYUfIFp14scCNn4sAC9RQThw/yeWW0q6OfrooD+?=
 =?us-ascii?Q?3zGWjTTZVfWztzrvTTv7NpZ8RSKqTkf6tWdRw7kTxvE7BooNcFt3pi1MSyP0?=
 =?us-ascii?Q?onV3tZeaj6KbVoyI+UXyX46aNRGImLz6lHO5g9mgoDR2H1PQ1iiSxvM7md3S?=
 =?us-ascii?Q?gZArzkP7W3XNTJOqHEMaUf79JGN2bXdPgo8RG6YQxOGwkHMgXX+gNoq/It7U?=
 =?us-ascii?Q?Bz2j/WxFKJLumddWjuZUUU1FuyH2lxCLDyvGfLFinIFgwrBJu/pLGs/Y/4eN?=
 =?us-ascii?Q?48VV4oo6LecMjbmyFNm5CkUfikvTW2NMvRdUkR5S+MYz6MDThzORAeRa7Q2t?=
 =?us-ascii?Q?q3cLz2uhRmzCUY5utVkH/XtEHnbb6R0Ac6hyEKnSvbRMBnXQ6VJZ+H0lghA8?=
 =?us-ascii?Q?bh1Z745TvHhBxccqhGtRfYMgyBviE9l+7oh9J82zcOdoyslTd1ig/tdSY8JC?=
 =?us-ascii?Q?/m1sKEbIcEPlJ13HPsXmzq8lOlWOw9OOwPude/LCbCQgL1nCi/tWwJtpdG5M?=
 =?us-ascii?Q?6BWcjDdb5aCnwSEAoUyKi/ikfs2JqdsGde7SIDhHTg58kyqIYDkZxkKu6AG/?=
 =?us-ascii?Q?UP709tyd1Q/8X+7DpbWpX29zakWurp14uEGCpxAiOrAo9hrYRaqopCe7t0SH?=
 =?us-ascii?Q?mX2+MWtN3l7PKdJjrq6K2pVeTSPuFyvyqpNqg3BnEUfbnVkvXju7C63MolJB?=
 =?us-ascii?Q?0IHuDHgFXOWtdWAQ+9hll5gChV8XvHC9zvR2wskbr8HoXTTXx/DwEJJJwMmH?=
 =?us-ascii?Q?/ZZrnMDojkli6Q73hpQMsuqxqTbGNAkWE/a1SrasUZtSMsvOFM2vLJMgvxj4?=
 =?us-ascii?Q?auhY35a7g2B5oefe2LzTe+Y4kUNjfo+B9SbUaUYQxeGid4kx5LZ95ziQpB9N?=
 =?us-ascii?Q?akQeZpsdEiWM0JMqRxdwIg1fkw6Vv3OQq904aDxNSbZOvyVD+m0n4PvjMdF2?=
 =?us-ascii?Q?mZXlYRmfQUUMjQqQZL1za1BLGILeYm+OL8JHAMEh?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?W+triJjqlmuEG/LB++dga5k1L79FrlNAMqhFQAbo8ucO5mLgeYNcLuC0m/u+?=
 =?us-ascii?Q?H3tHJcZunC8F5wB3NU5qzNGC8sRZd5p8bhqyuBFy7xXLFghhoD6u9mNJqR8r?=
 =?us-ascii?Q?CNqN51eOG6erKY9mPobBROQxxXbdJ29i0ONhM2zKQjgrs8KCqUANHTUBKkvE?=
 =?us-ascii?Q?Tz7zUnopzAWdL0FWfqamloAGHtb5zLCBVko8ZTwO3I5oVO8btt/nEc6rXnWX?=
 =?us-ascii?Q?w1wec0RmIpV1yjIxFPadoiOOJtemu1BVeL3vRO5wwgwBq+pPjQKP79QFQZRa?=
 =?us-ascii?Q?WisxCEtetj7Dupyd7mhnpwdYdRWz505vq6BE0KSAc5X1iHAUaflYf/QJ9Qa8?=
 =?us-ascii?Q?HZ+ByMHzc7qVZOyoQG0VivhAaMhnqTCAWwu3jqc0V9wg/TAaZCb/8krQlfqL?=
 =?us-ascii?Q?B8LYqZlokC2uHeHz6b931QPJeNPJQfFX028VbTjDqzr4X14Zy8aVGm4x6W+O?=
 =?us-ascii?Q?YJqDlEHDGbWKkaa/CVrZQ2s+7Oglw0Z53dg9YluTQ03x4f+wONN1LudAx7MQ?=
 =?us-ascii?Q?jRr59ncJIdV7n7I1sIoGoXh05BpOUeogL15SxzizmKrJXLMg1/kO/BRWa4kL?=
 =?us-ascii?Q?FBRdbL8TuMvla0Hv80PW/giF9umeLA04CA3I15hk4dFn7SQqnc/QXPOjmlUc?=
 =?us-ascii?Q?vMlmkKlZd0HGck2PY1Htwwm8UPes5El6osBwZzqBtgvAx7r84/5olUn/kTF1?=
 =?us-ascii?Q?Qw2ZRrR8Vqt1U7QE0k9dqJk0WRaq1MPxwpz+/eh1pY5ERktrXk6bv7kyzAyu?=
 =?us-ascii?Q?Nh3fqbqv/7NubW2ZkVx2jO6DebhNV0dhjemwK7cVg8cd1b1acsparH4kUt7A?=
 =?us-ascii?Q?XYHQ1rmGo9syxg/qNwAVTPcDZxzBczNXKpq4gEhhDi7/nmuxByfhOVNGpv8p?=
 =?us-ascii?Q?VJrJkNp9mwCD1kYy95Vz/gG3VR7pikZ4dgXk6ahGuVj7kzLp+JFsoiNswe+z?=
 =?us-ascii?Q?QVKt63jlpd3HoknOI8uXacHH+zv3/Bgxo/jcrwnuVOCO5dH0GBj7aZmGEqhU?=
 =?us-ascii?Q?ZIwWvZqTOs9hQuPC0IFMGoRmmuhdWOitPlim04bJMwrTwZMB+I5zHbeVa3US?=
 =?us-ascii?Q?pcSUE+JwMemDTPLvvH+lYrQvmjFNxKRStM20yN65LsLjcut8Hov4HJXT42vU?=
 =?us-ascii?Q?ziSXMfmWN1Rr0aQ/Bf/n7M2nJTAE1FSGTpFpsW5R1HQw4q08PSRpd/3jNSVR?=
 =?us-ascii?Q?PL7wN/DN3PXgAw11RpQsZi/RDYHt32qNoIXk+wgNeUxTi0CJpOrSU/Gv8JLg?=
 =?us-ascii?Q?TKgvXrrFFv+wxSYTwOdyVg5A9PW30EfhBRG+MoTBtW0C5lz2CaFDSdUTTE9c?=
 =?us-ascii?Q?XKInfU3M0B+Lso4VBBMfIwFPyH2gs3Q4rzqHfwK3XQTirFlEdjGfa+QBNd5L?=
 =?us-ascii?Q?b+ML2WNqnZoroywdch4j3AYoIwSIzPRHOLqdVnbrfM+nMPGMA2tj1FRHSFIl?=
 =?us-ascii?Q?MbsdtN98v5JCPdGaj97BYBr1pupB+HnFXmxuoIeNPYU1J/N2Ac0VvWz6f3AA?=
 =?us-ascii?Q?kSWxROsOnLfKlQDY3VRJanXkyUObRxyRyD0tk+n9k/lw0ME4WJoUkGkzuDSt?=
 =?us-ascii?Q?sVQcyKry3auFUL89AMcIVPCu8/Sjqbn5QDDvHlosQ5E4y+teKqJEhxdlqb0d?=
 =?us-ascii?Q?aujAMakE0A/6YNkcRtLJl9fUjpg6H1fP/pU8QCfpSxAyJ2cHMkeBFvwKZCLU?=
 =?us-ascii?Q?XaZkCadkmFI8p9Z7WRJdCnjyqrvlagWZ9oXKZLdY6iBCfA8dHXFN95VwP2my?=
 =?us-ascii?Q?A1MlP1BspA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	UnD1gVTlKxcwlQjisqbyfrGX+QCyX3xKqmJt6iTXBOOy5CMRbkj+bns5N68GhsJYOn6GzbCE6sPLLDJmsf9THbFUqL2S+E779p+bl8aUZ/qY6orQJNbFgoKVEpIh3IX7y2/9o7Cm364dsz1Xh9U9KQPP4Y8mFVLToyOWCwNLfPc7DksU1WV3Tx4o/GdRzv+26DATlxA8Kagt/zUOdtT5gGtt4aztw2Srh95882TWESTB2qkDmVdv3LUn0KgjDVAvI115X8exOd8ZW03v1XW95uOF3g3iKYetpPTDoZj7IEmTeDuvQn6BDspHu9DIXJLGQwOgZNjDJPkYjW9s09uuLEuoPSyPqb1VYL4oAKx8iHs+vFnddL0XSladC4Kl8HkV19Hn1yjlTGTLMRhJkeoLfGDYcN7sWB/S2HIwbFsQQFiJbpWsLkFvzz7lx9lTXc6PQfmkPbbzrcg+YM8yAdwGcXVwxB9WaUDi8r90eHMmMpUQkCEyG7J9tg88fZhwGZR91RIbE1srs16yw9Y0Am7SrYHS4UWv6UNYKOKc9MoZf8jd37FkAvedDY8HQLVvuHTG6rGKXij83Q8drSQ+VXd750Nx1KIWQ3+TEnihY4t3N0Q=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cef5ce7-6ec1-4f83-17c3-08de629b2b49
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2026 20:39:32.0133
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KgEe+bzCMMZF/jxTh98GSGLJ8tLL81euVfEba8+PnuN7BS5+9Yy0zSNPQlRj3M7e9fYEmOj584JPQ18SG5CHJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6055
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-02_05,2026-02-02_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 adultscore=0 suspectscore=0 mlxscore=0 phishscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2602020161
X-Proofpoint-GUID: OHNOSVW8RS1mc4GUrtyElHYVu4vAGIuC
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjAyMDE2MSBTYWx0ZWRfXyI914ZsXiTfM
 Oa3j89fI24uxmZRVkWka0T8XAspd3/tyTAaxz3j0YXcMKSkzNtvlS6U6U0RIhuan4VIsddh/xCK
 H/wnlTb+D7nvADQ4syxtiEY0aoMp57j6XFWgTPiYSu4sgpXhmgeTUXxUh7IVfHQIZtuEvqgmY71
 NkGwMzcv+foBg6ONUiMiFKJgl2AuS+axWXN2wJWK8KhocHUL9C0q3vAqQC3YX1u1cS59V87sfWk
 lR8/mBECBNtyzF5kaJ+8Hr8C31yZXcW6QUC6jHseVRMfPzWLMdft/9w9jBI/oaQ3y43PmWNN4ys
 Ex7hOLLk95mdk9jpCbozjVCZkiprm+fuWUJdv8cBsL4I/TtxJC/KOhuUexwdvONh5/7fXhmv6wR
 n4P33+IXJI2+eGTXirJd8SznprRTOMkJ8ZQ7PUMWulxOJmi5AMcibPJItAenD6fFYPEKd1c22Q1
 9nbj2/25WuziBcjjagw==
X-Proofpoint-ORIG-GUID: OHNOSVW8RS1mc4GUrtyElHYVu4vAGIuC
X-Authority-Analysis: v=2.4 cv=IaqKmGqa c=1 sm=1 tr=0 ts=69810b8b cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=i3X5FwGiAAAA:8 a=QyXUC8HyAAAA:8 a=NEAV23lmAAAA:8
 a=VnNF1IyMAAAA:8 a=nnLJXsDTHIVA3IG6T44A:9 a=CjuIK1q_8ugA:10
 a=mmqRlSCDY2ywfjPLJ4af:22
X-Rspamd-Queue-Id: 3B4D0100010
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: ja3a4ftmngbz444ikmda6j181yehp6sh
X-HE-Tag: 1770064780-560148
X-HE-Meta: U2FsdGVkX1+M+e/VZ+Ppjg7/0IRMlMEKiXqzTTU/NadO9nlxZ2hS0fwrZq7exIPXJDVJ9xXUs7EnNfwzzKhlTqZTy5/gmsKS9CeP+4QT8rkN+//lQ9V2rPKIpxlw/xYy85qDbfFqrHq/CVqhadRvpk1NJ9yb3jQCRKA8FWZ8D0qgcoR11Mj4PqVCkvWag8+YCkZu3w61w/b4JuQjdqo/+TRsrrvewnko/RuaX7qXZe8cNS3ADZca2idJg/D86dmQdelehAUbypne4tTJ1EjOBcptaoooURwZn9SFwTnd1n+GkoELHHsG/JXguksQiB4pPtQZB3WuUifh2QISQIMglHF0520cBIygUr5qpVPuyELASnqgNHLoOaC3El09ESRRCdRMiFhNykJhJtx8PhIxxe7eLCKY3zddJklKbOcu7iljkV9pql89gFgGyJ0DN96T5jQ15wZxOcuhNr1dj5CJ1xt+eIatWOp7ZoinstQcNl2wrKF406TploPLBizqoStW1z0G9fUqzZ6brJLLuCiOqeKDtvn6NhWNNTRANpcep6Pc1DMeDM5olqb75VLgesjaxfZp3hVebMkdbENGkN0KhQnojDgTV8JlXJgeaIUS1JFDRVHJkFEehoEbiIUrHA2CpIDKR4U6V4A18thtaMlX3T8yB9Gn7DmdLsW3H38U27e9FRlvfAtCozBiPTveM0OuZxCuG5beKLKgVh1rzuDUV10wrQ905DCCypvjx/5V1o0MF0uYFhigA0VsTNPvBID37hrWEk7pmasO3p7B3hqtuyea5Hl213ceo3rQYKT5gUILPChSuXwyOz3uR1E1NasuCDPYpUs1caV3vqM+oNdlGomzC3GbgJoO+3jaCt4iA8r/FYorlSnfhBtaiGTRq6SBLxO73tW2JMilT5de6YjXdtc2zLWJy5d/S46Z/tgDxf5VAtCUw9v6NaCmw22KBbOPzLy7ssDdqO5zA0rk/6N
 +IIWOOhk
 Ena1nJc4kyxTHq0K56RmJbMf3D2duV2cSIy/+Tb7Krk7E/d1XgsvjP7vE6kRp+y3wg8jl2hgc0BxQMO4apPghfqzyQZZXQRAcClihlUstfNSIYSP5Rq4sNrZSuQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* kernel test robot <lkp@intel.com> [260202 13:31]:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> head:   193579fe01389bc21aff0051d13f24e8ea95b47d
> commit: 60d8a8eb080e2f6927add49f47625574b39d3072 [10788/11220] maple_tree: add cp_is_new_root() helper
> config: parisc-randconfig-002-20260202 (https://download.01.org/0day-ci/archive/20260203/202602030233.gZQAuAMc-lkp@intel.com/config)
> compiler: hppa-linux-gcc (GCC) 8.5.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260203/202602030233.gZQAuAMc-lkp@intel.com/reproduce)

Thanks, as predicted by SK.

I will have to build the kernel with a lot more gcc versions, I guess.

> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202602030233.gZQAuAMc-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
>    In file included from ./arch/parisc/include/generated/asm/rwonce.h:1,
>                     from include/linux/compiler.h:380,
>                     from include/linux/array_size.h:5,
>                     from include/linux/kernel.h:16,
>                     from include/linux/maple_tree.h:11,
>                     from lib/maple_tree.c:56:
>    lib/maple_tree.c: In function 'cp_is_new_root':
> >> include/linux/rcupdate.h:555:36: error: dereferencing pointer to incomplete type 'struct maple_enode'
>     #define RCU_INITIALIZER(v) (typeof(*(v)) __force __rcu *)(v)
>                                        ^~~~
>    include/asm-generic/rwonce.h:55:33: note: in definition of macro '__WRITE_ONCE'
>      *(volatile typeof(x) *)&(x) = (val);    \
>                                     ^~~
>    include/linux/rcupdate.h:1046:3: note: in expansion of macro 'WRITE_ONCE'
>       WRITE_ONCE(p, RCU_INITIALIZER(v)); \
>       ^~~~~~~~~~
>    include/linux/rcupdate.h:1046:17: note: in expansion of macro 'RCU_INITIALIZER'
>       WRITE_ONCE(p, RCU_INITIALIZER(v)); \
>                     ^~~~~~~~~~~~~~~
>    lib/maple_tree.c:3364:3: note: in expansion of macro 'RCU_INIT_POINTER'
>       RCU_INIT_POINTER(cp->slot[0], mt_mk_node(cp->dst[0].node, mt));
>       ^~~~~~~~~~~~~~~~
> 
> 
> vim +555 include/linux/rcupdate.h
> 
> ca5ecddfa8fcbd Paul E. McKenney 2010-04-28  550  
> 462225ae47d717 Paul E. McKenney 2013-11-11  551  /**
> 462225ae47d717 Paul E. McKenney 2013-11-11  552   * RCU_INITIALIZER() - statically initialize an RCU-protected global variable
> 462225ae47d717 Paul E. McKenney 2013-11-11  553   * @v: The value to statically initialize with.
> 462225ae47d717 Paul E. McKenney 2013-11-11  554   */
> 462225ae47d717 Paul E. McKenney 2013-11-11 @555  #define RCU_INITIALIZER(v) (typeof(*(v)) __force __rcu *)(v)
> 462225ae47d717 Paul E. McKenney 2013-11-11  556  
> 
> :::::: The code at line 555 was first introduced by commit
> :::::: 462225ae47d7175f886281d8a91708550cd5178c rcu: Add an RCU_INITIALIZER for global RCU-protected pointers
> 
> :::::: TO: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> :::::: CC: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> -- 
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki

