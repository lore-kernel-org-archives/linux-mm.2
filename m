Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12E27CA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 12:55:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 562586B009F; Thu, 28 Aug 2025 08:55:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 512236B00A0; Thu, 28 Aug 2025 08:55:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38C0E6B00A3; Thu, 28 Aug 2025 08:55:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 22BBA6B009F
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 08:55:43 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CA17F1A018B
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 12:55:42 +0000 (UTC)
X-FDA: 83826162924.04.9168D59
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7050840014
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 12:55:39 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="oliu/QsD";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Nj43Qn7u;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756385739;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cKX5meqMsMKyKJsaBIMs2l4foZgyLRInWJfIAC+IOcU=;
	b=o/Rs/XezefvAr+ygkfGmpuXzGqHNKhITr/IUPIvp1+FLbwoGmHEnLtlnMZiNMUBqpsfGv8
	1SU7ntAUshm7tleGkpIb6UhfWHId8Zo7htFp/lRP48JskkxWSp7BMfbmgV/54hKb0Eq0No
	13yTvtcg4HU8gOHQyMUXIUJTEaq4GZ0=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="oliu/QsD";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Nj43Qn7u;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756385739; a=rsa-sha256;
	cv=pass;
	b=j6cjm3pogvJNuEEdlbWWWsNIBnyXFiYSnB89N8EHuZwpmVqTZqoY72jHYaB5yRJsSrRNts
	Gc7zaOmW/tjX2eu1u1UCbxDwbqjLD3wGvDZLssTimLwuBMQoG2ZoEUfrs9TqEcDREt2fxA
	KMnbSuSm8TX6QSaNWYocTpM5Lz2rte4=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57SCioq3013602;
	Thu, 28 Aug 2025 12:55:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=cKX5meqMsMKyKJsaBI
	Ms2l4foZgyLRInWJfIAC+IOcU=; b=oliu/QsD/Q2cEhvtmcP927msvjSZ5yVrfd
	5I4SVDrrHh9O1B0rtPkhgnqK7koYb226/W8xbM3gjE07ywEBQAy3gYXxohNNf5W4
	pAVdZr5/H/C8x1vILgspDKSTL7aZk2giPNGD/582PZmmxmxGpTJ+eC01koWHMgug
	I2rGwzv1Bdke65CtVglOTBtxbjadXANfs5ntO8Wqj1WjsPOajaedqeUrVoo7UwuE
	Eox9IhGrmpxuVRwQnoK6CvQ2Z2cAX/WYVvI6OyjM0vOYCv4QcLncXKSWwib6Bzrd
	v8atKrY9jtWb9RXc2FjHY6gxE4P2GWO/6DCkDE/FLdr0OYSXVmoQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q58s8dtx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 12:55:33 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57SBWNdV012226;
	Thu, 28 Aug 2025 12:55:33 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02on2049.outbound.protection.outlook.com [40.107.95.49])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48q43bu11b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 12:55:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MFEuxRx39bXIHpmYz8A9YTIaBhak+aZ8mBAI4pW/DKlxtEoVyBKbgkPtTebi8MRuADzAq6Jk/tcEL1Dlsjn9XaIbGQ9L3d1nUVCmqxoAkEXj8Ph463RLj1qufaRpRd12CE9SP5LqUX5V8mU5UXTKm3as4RV1d0ph4GByfHMXF1M79rzbnaZFO439gxZ/eLzKoTutXLE6XawYznXewzUwrAesa0b2uSyQJfTzqQ17ftOucd5kqtN/plRyqsB3yuRk58tlWRo5ukBOGtnZyaOgYW1gh+e/oY3vCajhtev6K9gFLmwTG7bdXqnS5byuoId/nDTeaUbd2jispHL6WUU6jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cKX5meqMsMKyKJsaBIMs2l4foZgyLRInWJfIAC+IOcU=;
 b=f1x4F3oNiYzaa9vH4rRF9ms24gnjf2zEABeK/zGvb1BP9rcjIAFUxHqBVPcziqYt0AgQfJre9LjtsckIBgIP7wCxs8+1Zynt3VCfS035PRfiNbyQ7Wep9VoJgR/+olclJ/T4KW4Shej5t01KjRMlZb3KYxZD4zdtSDn8+pItXjpt+Lt4gji3CSNNhS7JUwBWU586Ob7zcVPsRWJkmOVDq1esnKLf0hi+fmqE/lfMHmGAJgmewYfLs+ereJYRbZE+kb6qTBichQfNQ1loldDbxszmaUz9smBa1R3tn3m8a6tn2YnDpQ1tfsu+Mk3ijNQojvwhZ4YfG13+RsKiw50M8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cKX5meqMsMKyKJsaBIMs2l4foZgyLRInWJfIAC+IOcU=;
 b=Nj43Qn7uIJc4pSoyCq2DlMtIHYnKnjn0hsWL8M4XWTwumH+tW/XGNZGfydrAN8b8P/yVYkL/pIjP3ynXoQ07WF6dv0Jvf+TwWP5PKcnoMP+hBVFdVOTkWnqz8lnmvCLnxOvEh2PGkAZiQyzRJt+Pa3m0HAwmzzn9+gr8oSg9QAA=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CH3PR10MB7864.namprd10.prod.outlook.com (2603:10b6:610:1ba::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Thu, 28 Aug
 2025 12:55:30 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9052.019; Thu, 28 Aug 2025
 12:55:30 +0000
Date: Thu, 28 Aug 2025 13:55:26 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Max Kellermann <max.kellermann@ionos.com>
Cc: akpm@linux-foundation.org, david@redhat.com, Liam.Howlett@oracle.com,
        vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: add `const` to lots of pointer parameters
Message-ID: <d6bf808d-7d74-4e22-ac4b-a6d1f4892262@lucifer.local>
References: <20250827192233.447920-1-max.kellermann@ionos.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250827192233.447920-1-max.kellermann@ionos.com>
X-ClientProxiedBy: GV3P280CA0084.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:a::17) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CH3PR10MB7864:EE_
X-MS-Office365-Filtering-Correlation-Id: 029d7185-920a-417a-b50e-08dde6322b5e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Wps3RFTJ9S46jSZYzYSwq83R2QXLdLCOl65Nleo197Mm/6igoG62HIVkhsQs?=
 =?us-ascii?Q?rCXA0ye6shLKnRLirmGfGKV3AVgKXIk3ySybPhEFnRLO44p6bt5YMxWf3unC?=
 =?us-ascii?Q?MyH1Ki/imIFm07h4IS1TyKMf2Z9/li/w3fnO0GXwRnbpqZxNsPdKHFpv1pfi?=
 =?us-ascii?Q?X5/1btxF1/UR/pXgdxXaBWhIhC6M46tmt2P8d90jgP4JbU7E6IOZao1JzOwV?=
 =?us-ascii?Q?aJt37i5nEI3D+6TKmxe/s0PDlbNilZ/HCUxKULkqgylWyrHaCBI0Uy3wlLRi?=
 =?us-ascii?Q?woMIxiQ0k9ehR2Qef9Rss7Q6QpAcwgJkxisNU1To8nXHZKk3qjNReC9DCYSI?=
 =?us-ascii?Q?Hn5LTcuCaKs/r8KAv7yFwGfdWzqWlmv9zN064KeNfWgCxmBrhqyzUfqRcClG?=
 =?us-ascii?Q?3qnmu0BmphocGXpAHdgH8uD6V10oaS+gMuwZebM2Wu/SwSUdqDDMiU6YCVcE?=
 =?us-ascii?Q?O6w1IWpQAmzlRkFtyuv/bDIqA58h/xPCWFHxs0KAQXEwArAQJH2i3Ggwyn+5?=
 =?us-ascii?Q?fr1hgcu/sLmTT8PiQE6HHm+n4lu1yhSMDESnyuYBB8eNYpyaUDdh9IcdryTR?=
 =?us-ascii?Q?i650fyt1QZspePmbQJvZDJHIuNlwt9yq8aBn7lbfmDYjJG2YoGWLARsqEGpR?=
 =?us-ascii?Q?CmXT7HGPFyXAsLxK6BQoJdz2rtPobgIn0tH9T7qr+3vhjh+b7xEGuPo3i/6o?=
 =?us-ascii?Q?AK6G6Jj2BfzPE2vA/hypIssTPuLAbnFw1/7j47Ciprhc6EQYNyim/Gb1WgpI?=
 =?us-ascii?Q?JjNlAAr76z+p1rPvE5slRPHtANlpYBdLvXPWc47RJy1kLvKtUDpGUELerh/B?=
 =?us-ascii?Q?AzJVW/sNY6b9fcSJUY/X72fYKhY04Zgr01jKHQqtUWmt91K78bOXkJEnvJtT?=
 =?us-ascii?Q?FYyZyfazyFyVS8cexQMOVR+zOAa8q2EApSgBdeTcTPH8GZsO4psj0VodKzBj?=
 =?us-ascii?Q?ouY6vvhU+luHihEcX6DeUc7QSyddkk05E3Y1KDEGwFWCqakRXCvpHK3B+j0Q?=
 =?us-ascii?Q?6ayBvGH5QCPg7PVk6UrJJBYnkL8k94oZJkO7XvCzHXpZHWJaGrcA7K3TOMYS?=
 =?us-ascii?Q?fuTJagPRl2K592ZkNZyxrAj/LBIICUdFh7Cg8HGR58xlYCJTzOgf6HbPsnUl?=
 =?us-ascii?Q?XZEpwyoFIkNaYJPdDF0Q0iytOu+05wrHDEbxmJ+ydJImBADJQGO8x6nJfN+2?=
 =?us-ascii?Q?DA97btU/8bbqPMY1VOgJu9fMlXcVq+YCgiheBjkAFmJVvgWZHScB1iKRqMSD?=
 =?us-ascii?Q?5675+NVOAaxT4v2ZFM4zQgZDoh896YDp4pwB2CWinwXflcd80ZgtPlXB+c5P?=
 =?us-ascii?Q?Z8rVAt1QRKTKRqT9fnu0sVVrWXkmB5SxDJ9ijZlZCtHqgyhscYiiD8VVY7h1?=
 =?us-ascii?Q?b0zB2u7B6iBtdrbfXiLtnzNiKcWJlTnXOPR029klqqg8A3+edw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?aARaX7PrWNFfebajkOd9FmWHM4915yxDxXNOnHMgr9r/dhY9NTYlLS7mulqt?=
 =?us-ascii?Q?KIHBqBlYBpqMdPSdZsB78oM4xfU1BNEGaqfxS0FEQkobwAxdlQm7aYbOy+fS?=
 =?us-ascii?Q?DCluBsL7P2fv3Tu13cvOk+L3jFVIxPjtjbNxlxFxm2v589ppI6R5nGkX7c06?=
 =?us-ascii?Q?iU/CRuNDODi8Ao0SdIVVfLJoWz4be3dyIxhsBNzs19BNlrELxfWYoMVLBNQi?=
 =?us-ascii?Q?ZWbql9EtkgJIiglDY85/eU9PiC8Cz+UatwzrWLH/cTT7Hb5KvSGXpQK0LzHQ?=
 =?us-ascii?Q?QiXeDt5wwuSXpROj1k4UpyF9LaMjfUV91F3zyd/r11AOxkbiy54sFlGKm+OW?=
 =?us-ascii?Q?eFFp6m98S0Y844MTRk3TIiSl1OWk98dXAbWXorDDcSxFq7CIMHfMU/MBN2Yr?=
 =?us-ascii?Q?SmXlUB167QG4BVyxwtRFetQaM9AHfHJ384j3RM1CZuowZ/hCJDJH1eT666ty?=
 =?us-ascii?Q?rkolQUrRxTV4mDNR8PhaakfqotCGXZxE2TUn3sBD9++a1natWLq1InyDn4Bc?=
 =?us-ascii?Q?DPAeDWx1YRxp8Nb3k84OQNtXsOtAT2gGvyQO0LjBenQExk9viP7CmAApkJjC?=
 =?us-ascii?Q?9kv6pCQmgZigq1rDzx6MtMS713sCiIXq59CSc3B8F3NFGe1QOO1kDnsh+NVH?=
 =?us-ascii?Q?NCeT6f9qV1Sel9sa8JSWzIiJcddZ1fCDA08hl28aEoCEt+GHr2qzuJwAx95M?=
 =?us-ascii?Q?PZpZO8l2JF5LzN7SbSIV/KrQi5EeuuhDQMUMKSbLTqCrGCw2M8K2bOaoXWR3?=
 =?us-ascii?Q?ikFtyjhPDgIPbafaNQNWYV0kY/5dY9hvDP7t/0rmAOeZQy5UTH+WRInDCK2M?=
 =?us-ascii?Q?yz7DosjHqcmAYP2/cRp6lLKjcs09XEleaN518tywmA6agGRQBNYO+ZhTzTjh?=
 =?us-ascii?Q?LVTqoe8mlSHdVP2bQTsTUhOC2fAOk6WLtgNttlaXUXoX/680M7LLNaJaLXVB?=
 =?us-ascii?Q?JuxlpjQo8LJLRcyDQAkm/hza2Mo+DINyAY36TUF+6vedxlLb5GZE+kbTajvT?=
 =?us-ascii?Q?c8uGcUB+sWzPUS/KMLNLpPOrTbKkZ1QcTbRDVKfo94YGLrXPVGEHWOufgIMX?=
 =?us-ascii?Q?KAfr3UfcMPdmn31o58f/UeyM4vW5egVwVw5Jpvi/vkS+sTQ+gkJToVdRZbCF?=
 =?us-ascii?Q?nOkGBK9at8g8pCQ47W7mcNg1fesMWH8STWxpys8QxM/AfHah5HZRc5mHEuzJ?=
 =?us-ascii?Q?is69hkkuIjIr4d2YBRzsVVZgieYzrwNc0CX/a7vY3zWDXXxi7DOnz1hvfqvy?=
 =?us-ascii?Q?BLX6boBQPAY2adVNOXX86y+XLJoFJxS3gpE2ANEakA8dw7a8b/7PvqXN9dNo?=
 =?us-ascii?Q?vdFKzm+kmegDbq2sgojNU+u42klOmHBgY41iRP3OFY1ake6sM35WmdXQI3kp?=
 =?us-ascii?Q?mJDg9krQP0qtbbjez6FqXjTWxaXleFy2rwcvLDQM1p+cDOSTxqS7rKFaDaOp?=
 =?us-ascii?Q?LbEAkUl2J8WbLQV8wd+9vg2XFIPTLw5vepMspW8ZMZDlWtr9lxqSOWTS//Ra?=
 =?us-ascii?Q?IWPqAzi6qCahOyhkMHqRDxh/9S8XK9LDMI+Y6MLAYgsjgjGbKd2KRfOlm6MT?=
 =?us-ascii?Q?mBd25OBw2/0cBhw0PRxPA2fBbqfuBd+RDFZ8RWAaTZMtVdl3Xpg5wqXQG1db?=
 =?us-ascii?Q?YA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9BjI019gyeel13XHD1X8mPEmhg5k6ZnVF0WNbw0YWhvRZhKYDb0j1+A/FPUjmnDknUwc//SeNz0iEKGR9Pv1em6yt2FnfjZkNQ9niRNHT646QOsx8fkUBtUPr7n+Uh3s2vj7bgxmQrCc2EfVPkJtxXlY+/mQ3CLzhQO6M3AKZYpC7wxUuu37Is54aKa+6iGavRT52gCZLuUE90wx35/AXkhozblOFeFih5t2FuY3UG+cBapnDdeExplP1Qy78PuTISnCFsiWACj4EH54TIWfAiUHqVCqUCxlek8iUKQG+VKL3PcYQwHE0slq5bCd9Ynp3P8E+5KYmqkOi8RueMtQXnqp/Ck3qG+RYBuCfZIfpyBuDabMZmmGjZ/vKPsFTgAoxpPyFchLGKpVjpEzMH5u7EgxFjHYbvf7HPJTc0xUAMS9XqjUQ2IuBwhhN+wfpko0dmxqyClTcdFQKlhIL17H1RrvOEgengX8F/Zw8+4zQhBdbXael0qB5Gl7MsQ2VG1q5hOCor1hqkAKGenHSfubiBfHs5tB1leJOyMBLJJRQHihhfx0F8wxBGJWSg4Uzw/HmReqBkmNon3uuCj0x2MN2gpRCmfDdue2PoFrQ09T5xk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 029d7185-920a-417a-b50e-08dde6322b5e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 12:55:30.7557
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3Bfn5ytth23UTE94m0+7agzsl7SKQbyCzn/UX0Bnx+6hHHQNeGtTeXE0pYm8QnRmd1Tdn1ko3WhQVz1vs9R7N2B++PFxgdWniKP8gywyEgg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7864
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-28_04,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 adultscore=0 mlxlogscore=966 spamscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508280108
X-Authority-Analysis: v=2.4 cv=J6mq7BnS c=1 sm=1 tr=0 ts=68b051c5 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=UgJECxHJAAAA:8 a=9XuE3sFbdpPRtAqQdrUA:9
 a=CjuIK1q_8ugA:10 a=-El7cUbtino8hM1DCn8D:22 cc=ntf awl=host:12069
X-Proofpoint-GUID: edFuIehFv47FMOQk2fJCj0Qw-tzBZ3I9
X-Proofpoint-ORIG-GUID: edFuIehFv47FMOQk2fJCj0Qw-tzBZ3I9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAyNyBTYWx0ZWRfX7NcppjNOwWRB
 dRnkvCOTJQws4kunznCb7GES81tTzD5QtgU1wtzT3SuGs3FBvEGxwzNZh0Pgd9Nn5JSZBTRfswa
 oml24np2KtriUCqFkBmc4xMmqa5dikBdxYbU1/pJOdNIva8Jwbq6IMwXHf11b1LxWWg2HnjAefa
 5HPaanx3paHeh+y+jRmauPs9qFXnZPEG51jdHc/2aaQPaYP845eax4m9sJmEVr4qMq/Qu1QZfv/
 9OVbaYe9iwVYVKFXgN9mbj+kuzF2Dtu6qN6xdaMKN0L163KQEw+wALUDphqru4JLWAJA//YRN6E
 uKzcMAkQz13+bjY+IJ/6geW333k3BgZBGpnEqwfTRKgeftpeDcrMiv7jawXkc/6vWXcM691w9ps
 KeY8sN8vpSGeBMu4by192XG8hP0FQQ==
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7050840014
X-Stat-Signature: 5qk4j6nkrfq57shig33pgw1iaiqdx7n7
X-Rspam-User: 
X-HE-Tag: 1756385739-657391
X-HE-Meta: U2FsdGVkX1887feeI3ZZdiOAeuTtORcIiEFrN4cV4zV7XaBtYvlyPQ8ydslqepH+ZMPZBESM2jVy3oSrYrpdwUGOGX9pyzJ80PDoIBvKsRdgIrLVP5nxCQJyQO7LZzwK6rLKdHDHOEZvDOKQ34O81nmie3KR5s5OUb68cfsyHre4LIhDrdG6rDk/vZIrQDtacHLCzhC5XtuegbGpnKbiDoprSYzsVihxYdPb2+frHl67cVBXGxuhL24voTyf2W8CEhTnPuAllK+nzKCKRjthhGdqOxj7KSIkGvaRCptZAPkDLaUQ9eTxP8+rlaby8liuGBAXFptmnTRAte7RCFBxWMD0GOy/ROBzVP6SXK3YQ/S8+CPxqJ7kQ7kPsnDsxUPSn5Ns36a44gqn5CHu2l4tFtgIHUFWdAazM9z+vkh6dM5mmzIa1cY5eU3NhE3Dn4WFluIZauLEPiuSP9/qibib6BUzPJ9Xm8P7xcQi0GHSpxNVrCUPxtakMvnARkCrFzsCBIop+0EHafwCBLCd9J1KMMFEN9xAL1QMbE7iYW5jhPRWqMDRYJUvLhCih7KFdYFvWTJGtlsFPlzifKzW21wyXmTGs2DWz7AUtPe6Nz6UtoIDyl55LbwwCctpLtDuiVYR3UGyJp38BIWGzvb1R6wQpoPRztA9j2uG3X4HI+sGe0CXabsVup04+1QFh65Kl+h0W/y1XqMGQ0laJUSmwSCYH/q4vcYWuLk9ea9q+Awva7cqR4FMS6em0gRep1XQTFAiva9uCgf9B5SrNfh8v0YNKzt78f0+lT73L6jOOwas+MSUoLGwRHrVjaQPdvrVLptr8C1xJkX+0zISF+qNz4QiM41jE1k+Tt6wATVl3AIFEun8Jn1wQaoPuOG33yOiz5TGr4EJ+252lByKDs63+egw6pAU85V3IihAa+jsc+FrA7L3B80rid6zgJFHoOvcwVyYZJLmHke6N/rtFxNCvw4
 Sz/pdRL8
 qpPNiCMci8qbfPn9ZsZNMA6YbNdBrnI+9bM8H0Q0LdGaGxncaNBB9ksN84FsNOoXaNwa6TCvwBAxoKtx3fcOHwW98BZbJFtKlJtO7e/r3h7iczrYvViDxtbZQSUKt8JLY/LfsWMMZBt0NIHfOt0/cTjNqa/EZ15Ir10ydJ6o9Uq5xjK13j0luB8eiNzS5GWo0jaC/RpOnn/+YHQg+foNgvq6s4L0d5lxRgTs8Aif4Y0w0NCOjZdcF9EMgu00QwL7MntV0wxWh3aVMtynHwBSnUsGRkXap7eEXWgRoIy9q2/SyoyyXLSusHj9ho43kljj1uwhywsgczr9tEiZCPQvUvdVy7eIMI52HeKlAfWkkxZEOVRi2VPbPqE4Xf0oL+4cuEAAvHnJhcRK1gFqthocvc58cLEjfPD8Xp9AzRFcKi1YHuRLGXfaZmFheCBzzTUeZ4d4aMhIi6bUaj7vKOGUYOwNVddB7R9BGzgx2ZSxKMyvJQFF9hlXzB5CbMfeViDvj7VYPumwIEmUvsanayJ7itdFjymIhNN3Rqtxmj97ObcD4iwrLVpJ+xjMD5ttMsnXLNjkUL0qVp/wHbxuNRB3wyR1I66ylhsVqWtVtuRH556xhiEwR0P9EPQnu8JpyJ5AN68kWsiXBW0HQmXXxuJeqHF/zuo0ZjOr3VW3Jgv+hrdFzxjdxFDwQL04QPARCmrwMNI5P7f7SHh8FvbpW5gyqVg+Ey9Ff0zSHBcE+LemihBt06YHhm6z7LaMM3+rzi9Q6BIclsBwkKJQyLVJ0MzLbV1Ls1g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 27, 2025 at 09:22:33PM +0200, Max Kellermann wrote:
> For improved const-correctness.
>
> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>

NAK.

The patch in this form has dubious value, and the interactions on this
thread are not encouraging.

I also have pending series this will conflict with.

If a more reasonable approach can be suggested with appropriate on-list
behaviour (I think it'd really need to be an RFC also) then we can take a
look at that.

I think something more logically divided as David suggested could be
workable.

Cheers, Lorenzo

