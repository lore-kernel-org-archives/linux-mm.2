Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD90ECA0FE9
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 11:07:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 000F68E00CB; Tue, 26 Aug 2025 07:07:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF47D8E00A8; Tue, 26 Aug 2025 07:07:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBBBB8E00CB; Tue, 26 Aug 2025 07:07:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BFE3C8E00A8
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 07:07:28 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5CC6B846B9
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 11:07:28 +0000 (UTC)
X-FDA: 83818632576.15.EFDC34B
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf10.hostedemail.com (Postfix) with ESMTP id DF9CDC0009
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 11:07:24 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="oa/RMQlZ";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=wT+nuzOT;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf10.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756206445; a=rsa-sha256;
	cv=pass;
	b=DFPJyOeCAzMC58qjJnoLQ2f70VShBGtQ5sZuV+RXvYQx+zlZpDtBSm2nsq/wcl0fNMYvoL
	N8EOSPi3NNV7MW2ExpRyPs/3Du0KFTK3M4sbu2XRDi7Rlyg2hekLvlYF71aWmcyLWr/Zve
	fkNOcECDB0TmhDHGPhR3NILFBCHM9Ks=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="oa/RMQlZ";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=wT+nuzOT;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf10.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756206445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GNwZiq7FUwfDrz+l3YksGjamtTCrURtznzjJC8+6TrY=;
	b=tq2bUY4ZcYvpCSiH+1Pfu3GBJiqP73qlzSyKoPPlA2mJjB8OGBq5KlAmub7pQSigcWbxIK
	qBx6u1cePiRe39nrMePtDJeYl6f6OiEGSvkxCm7CWZIBY/HB9XfBs8T7M9lnp9XDdCVSi/
	imWqEEsY3mD6AlXIN4qdMWtiZszc8CA=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57Q8mBOg014200;
	Tue, 26 Aug 2025 11:07:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=GNwZiq7FUwfDrz+l3Y
	ksGjamtTCrURtznzjJC8+6TrY=; b=oa/RMQlZNROrbXMNiyHsOW24I56tviBbDY
	HAJ3njtofj+hnvNvwm1TOa9reDYMCUKiy+0aqhAHR287TB37evrAHZ89nPN3JiHa
	NqG5Z9D/l2gEVZMPHVFfza8PjAXU7IxZlJD51FSnPJ3fLgMvoER0uOyPZYf6Pr1+
	vbXTmlqEZgVWT9ph4RI04CVbJ76wwo36olpulpJGnFZkVli/sbjYQkkHr5cv3i26
	A//JuSmsbV5nuEaV0/qm2TH1e1MuVWFm/X1hGQ3OU0yxclMSGbJVhwaZzaS2J8CI
	ok1BmOHTf8bUdhGrFUre+VjO/u16S1paHG4sK0bm4/GSQRKD5Iwg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48r8twaxgu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Aug 2025 11:07:17 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57Q9ciLJ019707;
	Tue, 26 Aug 2025 11:07:17 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12on2086.outbound.protection.outlook.com [40.107.243.86])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48q439fave-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Aug 2025 11:07:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xYiuAM6+bCWIq2Q2bkcrwQQvaEdOiQ+79F6vi1NJMayeiDflnTnroShwO7zCrn4oigh0xEMqnU3Zg2v+en33wBtorTdtBup7sj2DvSDQRBeNnehXfSpKvcfLXfv0Ms8hbRZFBZtm8xsK5/Z2yX2W8fv7fiIJwBwYgJBo9ovRRuSYlVF4ZaRoKjEs6BLBpOuTCiCqigOgN5Qf81tWyjN7r/9VXAwmpiR+RTZfTZN6cZIXJyOcqjRo9FseH8s0ZG5QXegiMzScEXJ9Z0f/u9jecnyxu8qPx+JN1/H6mOPGZNKSNaXL+S/AAjHgvzDpTJuxL/AWHNqzsL/f42Nz/hfQqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GNwZiq7FUwfDrz+l3YksGjamtTCrURtznzjJC8+6TrY=;
 b=eP8nLHjZdBaOE1ryMcnDj6iyCL3ZW4hp46YHoKdOt0BQrb0xOTIVAQm1LZdN3ib44+yMSRbrygpSsO/jPTauoSff7TU2V8Ml+s59lJ86qzKW+/W+XXS9tIcXtaK0Ezt6qZqWxJMZ5lr8QVAqvxfDwp7eOASu2aFLDJW4GiGZQvypVh3yTB/iKjIupjoyvjbKQOYmzgz/Xo9v9CXaDNGoITM+w56q69v8VxJUaKgzOEa09hhrHAxW+h3UQBv8uKVKxmHuGxJz1toQ0498h/Y/2OwSubicKdSmCLNjncCb+lXYFqrF8tuOb3F6vOOO+ik10OiZTA2emal2CPEZMXkLZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GNwZiq7FUwfDrz+l3YksGjamtTCrURtznzjJC8+6TrY=;
 b=wT+nuzOTOPgp3oBu/Wu9INkyxU8AGfCg/UmfScsUNLtxk/S9TRSpAato3eRZceZCKZl5T1gKuHt/TARxKw9LF4ji0rkQ/+KxjvauoiWPj4OZF9641FET47Kl6VZRM042AIev/oLDtU2CznV5ikoUqE3mwjVcpscb1vEUTABeLhw=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by IA3PR10MB8590.namprd10.prod.outlook.com (2603:10b6:208:57b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Tue, 26 Aug
 2025 11:07:14 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9052.019; Tue, 26 Aug 2025
 11:07:14 +0000
Date: Tue, 26 Aug 2025 12:07:10 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: kernel test robot <lkp@intel.com>
Cc: oe-kbuild-all@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
        Christian Brauner <brauner@kernel.org>
Subject: Re: [akpm-mm:mm-unstable 125/221] include/linux/compiler.h:166:45:
 warning: unused variable '__UNIQUE_ID_guard255'
Message-ID: <247eb488-87a0-4d0f-ae1a-b2d8304dff65@lucifer.local>
References: <202508240502.frw1Krzo-lkp@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202508240502.frw1Krzo-lkp@intel.com>
X-ClientProxiedBy: MM0P280CA0112.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:9::20) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|IA3PR10MB8590:EE_
X-MS-Office365-Filtering-Correlation-Id: ebb902e9-2c6b-437d-0fa7-08dde490b651
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?KWf16Gqvu8p0Tw2TDLWi9g44oLuKLMbS2H1K99olXZJ88sWGyJj7up+lsbWE?=
 =?us-ascii?Q?rMSFl70kUsdRm3mq7WJrHwyCcb0a+POozo6u+WXpSxfCCbLbeQVQrhCqwTsk?=
 =?us-ascii?Q?3+jmeARGsGr3MJnA36/lxbIi/tTR5ppFJPX2n56xSj6s88KOpGL074A6VtQN?=
 =?us-ascii?Q?c+R/sdcVLzeWuO+RUv9yobgpj7lwHQCyYTQoLZv5KQx5vtnLzp8Qy5zzAPaK?=
 =?us-ascii?Q?rQHzMF9ljjLT1EBRVz2Fv+1wXbVW8ibEZRN/7tOCUcr1UskV+DoRkIgA+t0X?=
 =?us-ascii?Q?jd4Amt0Hf2f7inF2ebG3N9nyhZslPu8U9Bptenm0v2ptcc1pRJ2zakzuuqny?=
 =?us-ascii?Q?Rb2/osPrvH1YhDNCZKV0Dm5BnwIb43YpIhqFtSnRXjijJD5Yh1c1/x9ZQNxm?=
 =?us-ascii?Q?8NGtVleFfTDMlqDM7HMPVCaKkZ+xYMU3Plz1NBRI16SUzU7NRM+xtaLGIRGy?=
 =?us-ascii?Q?0qTYa02Ji5UmlYfU0A80gtw1OvDLVuugKhVXGQNubfyvVxFWvzLVJ/Fwm2vk?=
 =?us-ascii?Q?HWvUjhzjIXit1d7BxnrtDhq10raQ6DHuaODz8b+/P4zFdw4DdYFoWrfnEO/u?=
 =?us-ascii?Q?j71PLUsxsKKidJe+JyHauGNPpTKoqDkCeJvbEMBzPU/18VmXQSofh4KrSia9?=
 =?us-ascii?Q?v5EKA39/H/z+pVNAFTwexGZr7zI9APpR+0Ls7tkmAUciStHq6n4zplrjhY4w?=
 =?us-ascii?Q?p3F/+YUIdgW8tAOhdxaKcHhkK9QvRPsYQ+5dSG7ilsLTuHf5DrHoVY8KSisO?=
 =?us-ascii?Q?iNkiYtgqJ/A9sUFLwhvaj76CVbdFv20SEn4qiYDnW+otA5Jj8Hd1f7v+hRUw?=
 =?us-ascii?Q?96pt9TGQID/5ySQTxjzTX5EuUQm8rr5zDquev0RJ7WuWc/OxJmNm5Kr0CeRy?=
 =?us-ascii?Q?Rn8VaOlmGufZWtbc8UyMBzM5dD/R/ttLakYqc8kqLjsMlwL/fve66dOZP9HU?=
 =?us-ascii?Q?57pYjoKW7MMLYVoa6QleTDF7MteoCo/84gP3zIzzGKXuHXD8Y5rA00PMOv2d?=
 =?us-ascii?Q?c66FyRL/8YGmesz+jRFG4AiVwxuKuO/gnxtkA6l2Q0HyKajf3b/PSSuEMb/m?=
 =?us-ascii?Q?mhhJ996L98eMdx/Puc/MtbfNLEIxcnFZ43ippyDFswMm19AnflETvxWf0wAg?=
 =?us-ascii?Q?v4uyZHNHxCLgA+SH3jccClR231Lk15kfYqiRISw4aTHNMe3G0gBns/Ob6OUD?=
 =?us-ascii?Q?OWpxYeSBlg08tnswB/tIC2jP7adUP/jfSKvre9MdAXvxGIO6/UhjnPzNmH8u?=
 =?us-ascii?Q?RVagsVcitKfhTqqE3nkaqORCI9KccRSWT4PUO//Bs0PtTisbgIclVdStb3sV?=
 =?us-ascii?Q?WSpYcyksjDQHTVSa0LGFCOEbc5izXJC7zzn/fN2S+1/CcaBzI9Ed1tiXNHqZ?=
 =?us-ascii?Q?qs85/qRcZOXKw+1Sds5DcJXGUg6y?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?y2LwlT5gsk6ReD9GYvPJFAXxnsl2e6FPG4DM8Loek1CXGM5PkR9Zl+8l16Rr?=
 =?us-ascii?Q?gTY5hHA1nkIGdmPkWMGlNSXtLKpvF1ExLGPFmob8U1/hNc4VpA1+zAUj0XZh?=
 =?us-ascii?Q?0+ZsIk5qUIErND21WWoULl321NGItI4IWJjVRpRJgc4a8shrnWSla8+S2Dyv?=
 =?us-ascii?Q?TSErcGgo0ieqKF+tzpmiDgkbbl7nEEvEfUCpJLcHb4qnvHCxgmnA9Vxq52HW?=
 =?us-ascii?Q?21PCLwv/DYT29YjKlavi5bQKrAF/7uh7GZIqCdJt/vCsRnCDSqYWPDEjlSiG?=
 =?us-ascii?Q?R+jY7wsqtlc9ldp5C0O0zbte55o3RXjdzh+kVSFRwDDBgifiJynRlE+dH9PT?=
 =?us-ascii?Q?Gg9GTA6RGJbZGBvVUjQ1OK11YvxT6PlBTqmJdM8kGyxGOkOLcmu4LFVRwgOf?=
 =?us-ascii?Q?Fq88oxtTLlyfRFBPQVWgo7f6q8ftml7913pnfDcrxzVwSDBcBCuJTgnBTYxn?=
 =?us-ascii?Q?Ce/j0H1O36McB02FfPp855Q56eKKrx5FLP3Cb1Tze2lWLUGkjWMUVBxscTYK?=
 =?us-ascii?Q?rhqZWCKRWgoQ5BJ2sICpbOn7y70fL0GH4uH61PWIC5j0K8D0OJUj17jQu/ae?=
 =?us-ascii?Q?zWNaebar9EksMUquAneNRaURuIRN7G23tyHU0gKkYLGnDJK4VRCTT2mNefP/?=
 =?us-ascii?Q?OVA9+ewZZgUxmBwafp+xOyW6YjwuzrqPxa3YQ07A2bpYQhHLYfL/OqjbBLQ2?=
 =?us-ascii?Q?DqDBaw9Ps43CDzHCx1f0shnqgk4osm2ho8ST7w9takonoKvNzaSnMyVY+y+c?=
 =?us-ascii?Q?tfIGcp6LKQisNtU/b7KcZpS0vwUxqTTK3fvhFVg00c4o66Y0xnpN8BZJtXrD?=
 =?us-ascii?Q?Z/2FcI7ssZ4VOgbRLj4uUmAwSQ6du3k2tc5hLBv1FF42XNoMfSuy+4gc72y0?=
 =?us-ascii?Q?bivFb5mhL6vM834smIuAoF6mK19bMQmr66fOH7T+ylOrH0sPrfaKmmBamhwE?=
 =?us-ascii?Q?LaQE0C+BMLUFQ4zDpJoiqkW8guuwu8WcgVwUiqhYyyvrjhIWTdBNJ+6VEPG1?=
 =?us-ascii?Q?gEW9ww1pUdt9E9ZA2N+7Nld7KjokMGwizba6rrYUrJUg60tzf/Nv3L05eOVi?=
 =?us-ascii?Q?7KmtqCTi7RbDWNmbDffLQH8Fb8ar6fgoCx0tLtjQLd3pakKZQn3dW5jguHKC?=
 =?us-ascii?Q?1ZcpgBrKWh14G44Lfy9O0WAcduZNBi7w+P8dgQw1QVwpb7RbEsfvHta0N3+/?=
 =?us-ascii?Q?TP9dpgugnhjMk5+KfaY6lEnkWP43ysul0hW8d72jx/vxrfLE4f67yMg3vA4c?=
 =?us-ascii?Q?1G06GFsifoTNuwRgiaKwf8MI3bDEa1sDOOKagMGqfhbyifbaBkEswtwuLSmW?=
 =?us-ascii?Q?h33ct61k7ml/foa0qtZEskG98JS9QDI9e+tJUrKCapzYkn+5YXSgzC6FOT+0?=
 =?us-ascii?Q?0jhLtmzDMESgYZxFCzh2uOixO6A4wWJY+m7mNyj8O+ZGlfjHpOdnpwcYV4gl?=
 =?us-ascii?Q?ygDTxthgZw5uISpe6OEfJQFTNEejOaLBMXGyy6WUB2B5wspBOViIr6W2d8mk?=
 =?us-ascii?Q?fJ1ZQ+A+BxjgTEPlmPm6kY/uLgFFLiTWa+XwPKTDAf55euSZZjZHnDA7yDvc?=
 =?us-ascii?Q?93ylzZTKCupdByOmUukiQtCru528ch21VgB2fFRh2mrqHsB2OQr7AN09okjT?=
 =?us-ascii?Q?xQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	jJAg7X/NgArFzDwrR8n9lryeyR5lfxPvS2El594NiMSRvmTYbNokSz1dmAT182madzgV71PNbf3CTsopT4czeHSobdlWARRlLVbHtTbJIWuaP8ueQBxP8NwWdRm4tZojHZR4T9U4PrP5DrKJ44GF2V8mBs04I5QutbAlEv7eb++T7VttpqGDxUZ/ZGcOEreXA9XC1ZuBkTS8SWMVGafx8g20n++4npC4KME2S7t5E5Yb1n/AnSEnaM8aR+Z/2itlsGRWqU4OHdLMasc6mNyTz7Rw2DN3xaUPO36/oaKJgukQUNs7eyfl9xRq9uRkSNBENoEr3l5+FUu9zFGH9A7rFb5bBD/LiY7xPznoueil90cgKD0BG7LdYFKxG/KNURNsZzWGfWahl3ZSZWeqt+i2YJSciOftbnxPi80DBiYCpd0nhuW67tg2aGc30iWShmPDloHGyR/8ePa+4PUhOAlozyJq48i86E07scOAg+N0aBWFq0k0cgBXEOJgpQ7Moe+FaGtkLeAZypxpgNPvLvviNee4WMXx3OOUW6fsf2xz2Hbvf0DsZMGjU2/voD7N/PGEOVWKg0t/IXjDwmlBNwtsO6siNg+zuZKu7pw4OJ3AMmU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ebb902e9-2c6b-437d-0fa7-08dde490b651
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2025 11:07:14.3437
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Mshky1IZYDTcJ/cCXiahK7vGp+o+UTlJhiFtF07vVuNaw1KdtRSpqlpThrHt7BZzXjV/dtuYtaiJ8HjuwTz0hVYYL59VJ5U+Lsk/qeTmfc4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8590
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-26_02,2025-08-26_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508260097
X-Proofpoint-ORIG-GUID: K_XVus1Lb02TyFyFN-mVlHeLPHjD1Wlm
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODI0MDE4NCBTYWx0ZWRfXyINkKoadEbWe
 QqlnukS0L3dAOytAWz6yOBih3gFO5FT+wB8hAaQSx16wm2YuntjDME30MIDY1VVOtWVADwNshiy
 0F9z5/1R2jfo21ILWf/xv+4ERi3e2OQlEtdsn/lUxGWpvk0ZzHjje2xUUZFqYs2rvC+O4w7yHMq
 WHrQBeBYs3a6oQx9puFdpmMVqXNwg0Yqc8uWzvClWcjEVKDJpVpGB8nm574AeEcemO4AKSlmo6k
 nx7Ry2JJgieILMunhwgJ/e/0QuXZGpTfq0ZjUYJVbLy3FTY/TOSqw0OOug1sfHxsLiTbtqY3G07
 adAHSMt4PSD1wHOVov6gW0QI8lmjdsN39BfEKPDJBqIVrVnDA8P0ke3lMU9g+/+xm0oCFj4dYpG
 eYaGBJ10
X-Proofpoint-GUID: K_XVus1Lb02TyFyFN-mVlHeLPHjD1Wlm
X-Authority-Analysis: v=2.4 cv=IciHWXqa c=1 sm=1 tr=0 ts=68ad9565 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=i3X5FwGiAAAA:8
 a=QyXUC8HyAAAA:8 a=NEAV23lmAAAA:8 a=1XWaLZrsAAAA:8 a=Z4Rwk6OoAAAA:8
 a=j_PIIACpewnmWpdAkpMA:9 a=CjuIK1q_8ugA:10 a=mmqRlSCDY2ywfjPLJ4af:22
 a=HkZW87K1Qel5hWWM3VKY:22
X-Rspamd-Queue-Id: DF9CDC0009
X-Stat-Signature: bkng6taggxkupjmjwp1ax5f7a4ddmo3a
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756206444-986379
X-HE-Meta: U2FsdGVkX19gpNteWFJk7whnWmSdmxaJFGbJJ/bQF4ONSJNVsGPL+S2BWCGIsqZt6OVpbOx7k1J6iBKaMqJe+/jUTEIx2HDOcRWd4d4EukKu2D3hF0aHSDV3EG+HMIN1P0xc1wy9Vm1rZ9XsfNQiX9NoCtVLjIckXCn1wDSSgD0UgjhnCFNVQFCHQMxtlsydKnSr6I21pmtKS2yv/LJJGxYPjxKW3VIwOuX8xpIY502pfRTcYnpQSmB5ZDZ+5j3oAA6PfCrT8SuNVWaweujvK6Sij9wJqJN3kGLRgG5jYCEMCmQEgH2Rf/OHGViwKBRnzNY/tz1gYaxdzkTix7lj8FagbD24M7w8+dND3fN24r+MYmHCV53xm4TUvW286mO4iu+/FI23ZCOhUOpK3G2fQYJpLdmRAuRKK6Jo8qrATd402FwJTIy1PkqxyZZXQ2QkoHAcRzfC0Lr/w8Y96k1OTlfLPq+GcwazSUxUH6hZ4cwi9+wHMU9U2rehUcozFjRiDA/PE56R1Cc0oUUyvmmdVcD01oKxEauzZ5tc7UkDsrN1DloTpFeNYLfgGAo1RmOoeS1o3+XQS6hQPS+5/KXXCC19SbmFHSWeJxHbJ+Fbhi3jJEWBCWNWBcEL4GUdZ0aO6CB62qZYBUs/99FGSKKt37qXv0GTjcImOCghCbbK7nAOYxgyof1+1gxexiR85aqWJLQmsr5Gau/Pv9lPCB/mLYW46+V4LPeLHxO3EFGKNcEJEfnHCd346a67WvrkhhrxzVpAFxU1RATQg/fN48W3oKQAIBXqpr/HfroE20o6LbKP5zJaUlVi//Fm7ayF2yN2oDEe75fTfO7RQoqV6IhdJTZw71B7C0D6k+c8IHf91uC1L2sGQOisuuK7waw3cbYbEVmDcuBgeEmlse45VsV9MGU4EyHkAIVkUyOIEzcqsEnv9KLh31wiTzajomgyrnNqmWsvmcm5vg3e2xs14Qk
 woiLdy5m
 CiHyF/ZJ0O/fp7UxHDgiiSFiskgNFt11uatoqdpaE2Hv5iPLteyaa7WLI0y6LV3nJUzFKPlPGkVb2Diq+1Xr4RdCOAp1ZMD43bx2neeiJnhtECOb5amlHSvJoB5na0suxmvGJtrMVLly5MjVS4tfknrEqD+6dl+yRS7r9dZZCj0SfnBGhzQpvLCkh4RWezJaAzc3RVrHvjQB1urWfVoecvVMbKg58AXxn+0TTvpDcuMalgA5Q1yJceuOYn1pkzXSR+7Ym87NKRWmfhVR6A5pRib9c0+IrhM74GFYBxCgy803jtN+emAC78vzA7ABDtHxpGwXmUC+LNnd9trADXLuwGkFHUWeRaAPyze1ZDro9yI8LTrteJJlzYrX9zdXgou47tpAz9JufGHt9GhiuJxQ38j/kQ4qGuB6es3Jto3sXFM/Y6NlxjLimiUap5+TJjoSvROmkVHQb/T6v2n0cpQTkcUVZWPAejDD+7eqkwLDMero5qYXBHfrrOSGY94Vkh+8WIjb7UB96Q3+PDiHdvcsuGEQM3AMbw+8VKJnq3NbBGD0rztKsSRvuoP8UWvUe0tjjeyoAYBbHnU7thyL9rFjzId8pGeoZ8vQUgkJR1Fxcl8l/WzagIzSmePzKRYyLQGpytjau+0/TR9ZD3gm6splgShu0tCfJp38q1+r6TKWE433lqLHHuFK9Ocouj0M8xmBJxWMYG9v7bsajhTVEgr3df/ZWNrdtlYF0wHx0dTNEh6yPREYCip6NjtIUOE+g/s6PFeZs2wozefaKiTopr96BKYFq+iE/9/M2XpfD/YGejZE/QhbpCdeirkDbDizp5RW4CyRyEbrnvFoMRJGDqBJq/BG0X7UWBqH20IIfX2ZyMvRG0hvJBFDSO9bXIqQ9Zwd6t3yUMYs8NG5qud05XzAZT4p/lX6pSv2YmlcDh7mJTWi64w3MNhjxiwzk60Z1KqPVpaT/7KafZs94op4Cs2JLez5XJw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 24, 2025 at 05:32:49AM +0800, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
> head:   3c3393d4b766eebdc475ea5bd6bbd3a221e2526e
> commit: 98a7f4a3d2b1655e323e6943cf0203d0bd5a64eb [125/221] mm: update coredump logic to correctly use bitmap mm flags
> config: arc-randconfig-r071-20250824 (https://download.01.org/0day-ci/archive/20250824/202508240502.frw1Krzo-lkp@intel.com/config)

Sigh, another 'special' arch (+ config options) causing issues with core changes...

I'm guessing it's having problems, somehow (???) with importing compiler_types.h
which is just... yeah. This is for ACCESS_PRIVATE().

Will try to come up wtih a solution just to suit arc with some horrid config
then I guess :/

Given the issue clearly has to be (although it's bizarre) the including of
linux/compiler_types.h, let's move __mm_flags_set_mask_dumpable() to
include/linux/mm.h (even though it sucks to really).

Will send a fix-patch in the series...

> compiler: arc-linux-gcc (GCC) 9.5.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250824/202508240502.frw1Krzo-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202508240502.frw1Krzo-lkp@intel.com/
>
> All warnings (new ones prefixed by >>):
>
>    include/linux/sched/task.h: At top level:
>    include/linux/sched/task.h:99:41: warning: 'struct pid' declared inside parameter list will not be visible outside of this definition or declaration
>       99 | struct task_struct *copy_process(struct pid *pid, int trace, int node,
>          |                                         ^~~
>    include/linux/sched/task.h: In function 'arch_thread_struct_whitelist':
>    include/linux/sched/task.h:178:40: error: invalid application of 'sizeof' to incomplete type 'struct task_struct'
>      178 | # define arch_task_struct_size (sizeof(struct task_struct))
>          |                                        ^~~~~~
>    include/linux/sched/task.h:191:10: note: in expansion of macro 'arch_task_struct_size'
>      191 |  *size = arch_task_struct_size - offsetof(struct task_struct, thread);
>          |          ^~~~~~~~~~~~~~~~~~~~~

OK so somehow before there was some... alternative offsetof defined?... Because
this is just weird.

It's not really digging into exactly why this is triggering I don't think given
I can avoid the include that causes it.

>    In file included from include/uapi/linux/posix_types.h:5,
>                     from include/uapi/linux/types.h:14,
>                     from include/linux/types.h:6,
>                     from include/uapi/linux/sched.h:5,
>                     from include/linux/sched.h:10,
>                     from arch/arc/kernel/asm-offsets.c:6:
>    include/linux/stddef.h:16:32: error: invalid use of undefined type 'struct task_struct'
>       16 | #define offsetof(TYPE, MEMBER) __builtin_offsetof(TYPE, MEMBER)
>          |                                ^~~~~~~~~~~~~~~~~~
>    include/linux/sched/task.h:191:34: note: in expansion of macro 'offsetof'
>      191 |  *size = arch_task_struct_size - offsetof(struct task_struct, thread);
>          |                                  ^~~~~~~~
>    In file included from include/linux/sched/user.h:9,
>                     from include/linux/cred.h:18,
>                     from include/linux/sched/signal.h:10,
>                     from include/linux/rcuwait.h:6,
>                     from include/linux/mm.h:36,
>                     from arch/arc/include/asm/arcregs.h:149,
>                     from arch/arc/include/asm/irqflags-compact.h:16,
>                     from arch/arc/include/asm/irqflags.h:11,
>                     from include/linux/irqflags.h:18,
>                     from include/linux/spinlock.h:59,
>                     from include/linux/sched.h:37,
>                     from arch/arc/kernel/asm-offsets.c:6:
>    include/linux/ratelimit.h: In function 'ratelimit_state_init':
>    include/linux/ratelimit.h:14:2: error: implicit declaration of function 'raw_spin_lock_init' [-Werror=implicit-function-declaration]
>       14 |  raw_spin_lock_init(&rs->lock);
>          |  ^~~~~~~~~~~~~~~~~~
>    include/linux/ratelimit.h: In function 'ratelimit_state_reset_interval':
>    include/linux/ratelimit.h:44:2: error: implicit declaration of function 'raw_spin_lock_irqsave'; did you mean 'read_seqbegin_or_lock_irqsave'? [-Werror=implicit-function-declaration]
>       44 |  raw_spin_lock_irqsave(&rs->lock, flags);
>          |  ^~~~~~~~~~~~~~~~~~~~~
>          |  read_seqbegin_or_lock_irqsave
>    include/linux/ratelimit.h:49:2: error: implicit declaration of function 'raw_spin_unlock_irqrestore'; did you mean 'write_sequnlock_irqrestore'? [-Werror=implicit-function-declaration]
>       49 |  raw_spin_unlock_irqrestore(&rs->lock, flags);
>          |  ^~~~~~~~~~~~~~~~~~~~~~~~~~
>          |  write_sequnlock_irqrestore
>    In file included from include/linux/sched/signal.h:12,
>                     from include/linux/rcuwait.h:6,
>                     from include/linux/mm.h:36,
>                     from arch/arc/include/asm/arcregs.h:149,
>                     from arch/arc/include/asm/irqflags-compact.h:16,
>                     from arch/arc/include/asm/irqflags.h:11,
>                     from include/linux/irqflags.h:18,
>                     from include/linux/spinlock.h:59,
>                     from include/linux/sched.h:37,
>                     from arch/arc/kernel/asm-offsets.c:6:
>    include/linux/pid.h: In function 'pid_alive':
>    include/linux/pid.h:267:10: error: dereferencing pointer to incomplete type 'const struct task_struct'
>      267 |  return p->thread_pid != NULL;
>          |          ^~
>    In file included from include/linux/preempt.h:11,
>                     from include/linux/sched.h:15,
>                     from arch/arc/kernel/asm-offsets.c:6:
>    include/linux/hrtimer.h: In function 'hrtimer_update_function':
>    include/linux/cleanup.h:290:2: error: unknown type name 'class_raw_spinlock_irqsave_t'; did you mean 'class_local_lock_irqsave_t'?
>      290 |  class_##_name##_t var __cleanup(class_##_name##_destructor) = \
>          |  ^~~~~~
>    include/linux/cleanup.h:401:2: note: in expansion of macro 'CLASS'
>      401 |  CLASS(_name, __UNIQUE_ID(guard))
>          |  ^~~~~
>    include/linux/hrtimer.h:340:2: note: in expansion of macro 'guard'
>      340 |  guard(raw_spinlock_irqsave)(&timer->base->cpu_base->lock);
>          |  ^~~~~
>    In file included from include/linux/alarmtimer.h:6,
>                     from include/linux/posix-timers.h:5,
>                     from include/linux/sched/signal.h:13,
>                     from include/linux/rcuwait.h:6,
>                     from include/linux/mm.h:36,
>                     from arch/arc/include/asm/arcregs.h:149,
>                     from arch/arc/include/asm/irqflags-compact.h:16,
>                     from arch/arc/include/asm/irqflags.h:11,
>                     from include/linux/irqflags.h:18,
>                     from include/linux/spinlock.h:59,
>                     from include/linux/sched.h:37,
>                     from arch/arc/kernel/asm-offsets.c:6:
>    include/linux/hrtimer.h:340:2: error: cleanup argument not a function
>    In file included from include/linux/preempt.h:11,
>                     from include/linux/sched.h:15,
>                     from arch/arc/kernel/asm-offsets.c:6:
>    include/linux/cleanup.h:291:3: error: implicit declaration of function 'class_raw_spinlock_irqsave_constructor'; did you mean 'class_local_lock_irqsave_constructor'? [-Werror=implicit-function-declaration]
>      291 |   class_##_name##_constructor
>          |   ^~~~~~
>    include/linux/cleanup.h:401:2: note: in expansion of macro 'CLASS'
>      401 |  CLASS(_name, __UNIQUE_ID(guard))
>          |  ^~~~~
>    include/linux/hrtimer.h:340:2: note: in expansion of macro 'guard'
>      340 |  guard(raw_spinlock_irqsave)(&timer->base->cpu_base->lock);
>          |  ^~~~~
> >> include/linux/compiler.h:166:45: warning: unused variable '__UNIQUE_ID_guard255' [-Wunused-variable]
>      166 | #define __UNIQUE_ID(prefix) __PASTE(__PASTE(__UNIQUE_ID_, prefix), __COUNTER__)
>          |                                             ^~~~~~~~~~~~
>    include/linux/cleanup.h:290:20: note: in definition of macro 'CLASS'
>      290 |  class_##_name##_t var __cleanup(class_##_name##_destructor) = \
>          |                    ^~~
>    include/linux/compiler_types.h:84:22: note: in expansion of macro '___PASTE'
>       84 | #define __PASTE(a,b) ___PASTE(a,b)
>          |                      ^~~~~~~~
>    include/linux/compiler.h:166:29: note: in expansion of macro '__PASTE'
>      166 | #define __UNIQUE_ID(prefix) __PASTE(__PASTE(__UNIQUE_ID_, prefix), __COUNTER__)
>          |                             ^~~~~~~
>    include/linux/compiler_types.h:84:22: note: in expansion of macro '___PASTE'
>       84 | #define __PASTE(a,b) ___PASTE(a,b)
>          |                      ^~~~~~~~
>    include/linux/compiler.h:166:37: note: in expansion of macro '__PASTE'
>      166 | #define __UNIQUE_ID(prefix) __PASTE(__PASTE(__UNIQUE_ID_, prefix), __COUNTER__)
>          |                                     ^~~~~~~
>    include/linux/cleanup.h:401:15: note: in expansion of macro '__UNIQUE_ID'
>      401 |  CLASS(_name, __UNIQUE_ID(guard))
>          |               ^~~~~~~~~~~
>    include/linux/hrtimer.h:340:2: note: in expansion of macro 'guard'
>      340 |  guard(raw_spinlock_irqsave)(&timer->base->cpu_base->lock);
>          |  ^~~~~
>    In file included from include/linux/rbtree.h:24,
>                     from include/linux/mm_types.h:11,
>                     from include/linux/mmzone.h:22,
>                     from include/linux/gfp.h:7,
>                     from include/linux/mm.h:7,
>                     from arch/arc/include/asm/arcregs.h:149,
>                     from arch/arc/include/asm/irqflags-compact.h:16,
>                     from arch/arc/include/asm/irqflags.h:11,
>                     from include/linux/irqflags.h:18,
>                     from include/linux/spinlock.h:59,
>                     from include/linux/sched.h:37,
>                     from arch/arc/kernel/asm-offsets.c:6:
>    include/linux/rcuref.h: In function '__rcuref_put':
>    include/linux/preempt.h:227:49: error: implicit declaration of function 'irqs_disabled' [-Werror=implicit-function-declaration]
>      227 | #define preemptible() (preempt_count() == 0 && !irqs_disabled())
>          |                                                 ^~~~~~~~~~~~~
>    include/linux/rcupdate.h:399:39: note: in definition of macro 'RCU_LOCKDEP_WARN'
>      399 |   if (debug_lockdep_rcu_enabled() && (c) &&  \
>          |                                       ^
>    include/linux/rcuref.h:103:44: note: in expansion of macro 'preemptible'
>      103 |  RCU_LOCKDEP_WARN(!rcu_read_lock_held() && preemptible(),
>          |                                            ^~~~~~~~~~~
>    In file included from include/linux/rcuwait.h:6,
>                     from include/linux/mm.h:36,
>                     from arch/arc/include/asm/arcregs.h:149,
>                     from arch/arc/include/asm/irqflags-compact.h:16,
>                     from arch/arc/include/asm/irqflags.h:11,
>                     from include/linux/irqflags.h:18,
>                     from include/linux/spinlock.h:59,
>                     from include/linux/sched.h:37,
>                     from arch/arc/kernel/asm-offsets.c:6:
>    include/linux/sched/signal.h: At top level:
>    include/linux/sched/signal.h:192:22: error: field 'prev_cputime' has incomplete type
>      192 |  struct prev_cputime prev_cputime;
>          |                      ^~~~~~~~~~~~
>    include/linux/sched/signal.h:197:28: error: field 'ioac' has incomplete type
>      197 |  struct task_io_accounting ioac;
>          |                            ^~~~
>    include/linux/sched/signal.h: In function 'kernel_signal_stop':
>    include/linux/sched/signal.h:302:3: error: implicit declaration of function 'set_special_state' [-Werror=implicit-function-declaration]
>      302 |   set_special_state(TASK_STOPPED);
>          |   ^~~~~~~~~~~~~~~~~
>    include/linux/sched/signal.h:302:21: error: 'TASK_STOPPED' undeclared (first use in this function); did you mean 'CLD_STOPPED'?
>      302 |   set_special_state(TASK_STOPPED);
>          |                     ^~~~~~~~~~~~
>          |                     CLD_STOPPED
>    include/linux/sched/signal.h:306:2: error: implicit declaration of function 'schedule'; did you mean 'sched_exec'? [-Werror=implicit-function-declaration]
>      306 |  schedule();
>          |  ^~~~~~~~
>          |  sched_exec
>    include/linux/sched/signal.h: In function '__set_notify_signal':
>    include/linux/sched/signal.h:357:10: error: implicit declaration of function 'test_and_set_tsk_thread_flag'; did you mean 'test_and_set_ti_thread_flag'? [-Werror=implicit-function-declaration]
>      357 |  return !test_and_set_tsk_thread_flag(task, TIF_NOTIFY_SIGNAL) &&
>          |          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
>          |          test_and_set_ti_thread_flag
>    include/linux/sched/signal.h:358:10: error: implicit declaration of function 'wake_up_state'; did you mean 'wake_up_sync'? [-Werror=implicit-function-declaration]
>      358 |         !wake_up_state(task, TASK_INTERRUPTIBLE);
>          |          ^~~~~~~~~~~~~
>          |          wake_up_sync
>    include/linux/sched/signal.h:358:30: error: 'TASK_INTERRUPTIBLE' undeclared (first use in this function); did you mean 'FOLL_INTERRUPTIBLE'?
>      358 |         !wake_up_state(task, TASK_INTERRUPTIBLE);
>          |                              ^~~~~~~~~~~~~~~~~~
>          |                              FOLL_INTERRUPTIBLE
>    include/linux/sched/signal.h: In function 'set_notify_signal':
>    include/linux/sched/signal.h:368:3: error: implicit declaration of function 'kick_process'; did you mean 'copy_process'? [-Werror=implicit-function-declaration]
>      368 |   kick_process(task);
>          |   ^~~~~~~~~~~~
>          |   copy_process
>    include/linux/sched/signal.h: In function 'restart_syscall':
>    include/linux/sched/signal.h:373:2: error: implicit declaration of function 'set_tsk_thread_flag'; did you mean 'set_ti_thread_flag'? [-Werror=implicit-function-declaration]
>      373 |  set_tsk_thread_flag(current, TIF_SIGPENDING);
>          |  ^~~~~~~~~~~~~~~~~~~
>          |  set_ti_thread_flag
>    In file included from arch/arc/include/asm/ptrace.h:11,
>                     from arch/arc/include/asm/processor.h:16,
>                     from include/linux/sched.h:13,
>                     from arch/arc/kernel/asm-offsets.c:6:
>
>
> vim +/__UNIQUE_ID_guard255 +166 include/linux/compiler.h
>
> fe8c8a126806fe Cesar Eduardo Barros 2013-11-25  165
> a8306f2d4dcea0 Nick Desaulniers     2023-08-31 @166  #define __UNIQUE_ID(prefix) __PASTE(__PASTE(__UNIQUE_ID_, prefix), __COUNTER__)
> 6f33d58794ef4c Rusty Russell        2012-11-22  167
>
> :::::: The code at line 166 was first introduced by commit
> :::::: a8306f2d4dcea03538c70c26d2948483f70254ff compiler.h: unify __UNIQUE_ID
>
> :::::: TO: Nick Desaulniers <ndesaulniers@google.com>
> :::::: CC: Andrew Morton <akpm@linux-foundation.org>
>
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki

