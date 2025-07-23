Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A20E8C83F25
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 04:47:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 241336B0096; Wed, 23 Jul 2025 00:47:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2121B6B0098; Wed, 23 Jul 2025 00:47:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DA4B6B0099; Wed, 23 Jul 2025 00:47:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F22656B0096
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 00:47:56 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4C37CC055D
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 04:47:56 +0000 (UTC)
X-FDA: 83694296952.21.1A85A76
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf02.hostedemail.com (Postfix) with ESMTP id 15DF080004
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 04:47:52 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=a7eCbxtW;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=e2amN8w6;
	spf=pass (imf02.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753246073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e3PpH4eJF/qBzTDcxgmWiTwiZTaUskY0mXofFNLjSPw=;
	b=bvfRgM2U31elgxO1SGXcLA3nmJ5HyXqe8xHGfYeU9R190T+tOzMl5De3XjUUEUvghidMRr
	/av3ZDEtJ0v1xigKgA2YEO1V4+3QcRQrGg1tVT8bT2FNkMVlgfT6zm/YyeGww7VI9zsQCl
	cMNJj27QNm1AT5rHdNeYeCmDcsNIWzU=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753246073; a=rsa-sha256;
	cv=pass;
	b=FFjz2bkeND8oEHdayp+WFHAqDZ8k69mQKhw3bbnArRqG3ahYs2+cQOAuIkVV8DYDXPWLEK
	+rGz3Y2Tet0AH42p+qM+mbc74gcDvsEsKMtR4CSmkg8k1mHFeIkuPxrhcFYxjCdBriu3+K
	LMGyanJFEVrYP39Bfj8VMJiN/Si+fKs=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=a7eCbxtW;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=e2amN8w6;
	spf=pass (imf02.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56MMQxPX030806;
	Wed, 23 Jul 2025 04:47:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=e3PpH4eJF/qBzTDcxg
	mWiTwiZTaUskY0mXofFNLjSPw=; b=a7eCbxtWk3uAO+mB5PbIwUUB3YHPvw6hKG
	475MKzfTxqFJNeRR06H8GTswlab+x9PO9rfEVkRHLmx0OIklsRCszSqxcT6ub4cn
	dFsUZ3DnaX/KG3VSIo9GjYaHZsZWXq4udu5Eeiv48iVIy32z8Ea5cKaOrRG1ITQ1
	8LR/APc6Ol0K3zHu9dwrAUMIWXxJ8NSNl4ZNU2CQV2RCnrGacVeiUJVBVRcJmnJR
	Px3H6Gw2h2PfhWukdQiUd9kXlUcRdW5rhH78mq94RLKxx1u2zhOG/uXBEnCfKl1g
	tvraHpms18exONh8dkv6oLbPATKX9YUOwYvQh/zMtBR9UFYWTBCg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4805e2enc8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 23 Jul 2025 04:47:49 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56N4Zn0J014433;
	Wed, 23 Jul 2025 04:47:48 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010044.outbound.protection.outlook.com [52.101.193.44])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4801tgeeep-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 23 Jul 2025 04:47:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iUP4DtnKnGGFGbXgntZ3ya86Q0fuibIL40FD4IuV10/L36Ot8Iy/es0KYTXEzpcxq9Rh00C2UnNQl+DFcSUyZxtnT846OqqG9T+t+Zb87JHk0VJmgXAuAgI7b6jcvPitmcJl89H87dI6BArK4kmTVtqmsSFeTN1VTbxyoqcioZlWONHKtdNyicbqhaj4F4a6DYOvw62n/HmGGg7/d+Ac2bO+TVbkq2St5F7I8AcxkTySgCs7bCCWA4mPdNFc++x7JdyurKo3dPRkMcJ0ic15wMtzTngIpUXzWxE35RiQu4KomeZUV98a38NvMxblTbvKLTYJLTq5hW7crNVKU7RCZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e3PpH4eJF/qBzTDcxgmWiTwiZTaUskY0mXofFNLjSPw=;
 b=moGxKjA4GIpTRRGMBmwlke7AP7EE2Yj+LCJ5Nd5wpzRKUJHSEZccRdsgLGKkgRYDt7sZeTBXubxjf7X0UFuGf70gLD5eoS8mTLgBkDkTTHFL6H8BYcmbVapdgIM6xL8UsKuEk5ru8FRmSYpI2arTrGIcCWwzB+b1QWXaszyNkhVsfVUViXpXYyhbDjlJXgpO+kH9bkZKNoWkI9p9T3J0Y+Y/jLFzHViouLju50mIm4WrnCD7lT5lNFJRdceDLPbBO6Ri2dJmXJI6avWtn8S2wnMuRC7dUtOV8BVWC6gmhSsx1h0Sa/QuzhwVIckdNcH4gJsFmrhwhlCF0Jvrfk4WvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e3PpH4eJF/qBzTDcxgmWiTwiZTaUskY0mXofFNLjSPw=;
 b=e2amN8w60qQkIEdDGqeU3A+y4gL6EZbVWhaAQlZsmuK5GS0G0Fot5RcL6k5OIJdC0bBgQv3or9q3Ahc2DxOAdDzv1XYIqWSkbrZqhry4/CkYmCOE8JtVWYz8mKHpDCCxLi/nBP93oQ+nshyFx4eZ+Assy7dZrAe4ec9YWouyWNU=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DM4PR10MB6110.namprd10.prod.outlook.com (2603:10b6:8:8b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.35; Wed, 23 Jul
 2025 04:47:46 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%4]) with mapi id 15.20.8943.029; Wed, 23 Jul 2025
 04:47:46 +0000
Date: Wed, 23 Jul 2025 05:47:42 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        Muchun Song <muchun.song@linux.dev>
Subject: Re: [PATCH] MAINTAINERS: add missing file to cgroup section
Message-ID: <db683871-16a1-4187-b7b4-9fbe672446f8@lucifer.local>
References: <20250722181409.154444-1-lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250722181409.154444-1-lorenzo.stoakes@oracle.com>
X-ClientProxiedBy: LO2P265CA0027.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:61::15) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DM4PR10MB6110:EE_
X-MS-Office365-Filtering-Correlation-Id: e77ecb69-eac7-4d98-ea5e-08ddc9a41187
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Q3cL51MnTOVGxmic4grB3GHnyXze/C65oaJNWZyV8f0Ubf0P9mLZtgw93GI0?=
 =?us-ascii?Q?cBrfLSKrYhZapvZl26DRuHyWby6OhwD0eK85x6m6GSPheL/jOqeQ2XQhd0Tg?=
 =?us-ascii?Q?kD4W5xQAmI//dkvWtlnrPg2b4quSpEMyRonxmjUbuxq4sMBylrWqCGHOcClV?=
 =?us-ascii?Q?TAJV7WkMY37Bf237WREVyYXyMiHpfYm3t2sYv8foDtKzNv5l/hrvetbqbu6G?=
 =?us-ascii?Q?PNT7iOeukXr9TaHPo/CnUN2Sc3rYqJjS1F/eSrsu17ncUj+dSPLjLO7Go+TF?=
 =?us-ascii?Q?rSz3/TAuOUkLxyXDmhfSfbrGpwnLeII55LAeEwNukkRobw58MJzBB9I4klxS?=
 =?us-ascii?Q?x+qbuthzbIHxus7qE7Vy4muBwSqrwRM4Ym57HIGJIcw0fqYK660e9IzKsnxG?=
 =?us-ascii?Q?Nk4888Sjn5VAp8CWKyDpEkUn79BPc5jCEbObAVfeFC2rjttGaV/Ddq2l7IVu?=
 =?us-ascii?Q?WnjbW1ibStM1uzx5tHGz4ecpvR2+DTuZQNxy4UtQvZKkTRjDg4wwVn7mgIKT?=
 =?us-ascii?Q?4lw/WJ8VMryijk7xAym7AlDtB06BHeUahcCOoN7lcMQZGn/9gVHv5DFIGE0a?=
 =?us-ascii?Q?Ak6Ke9PiLPz2LZSNH1oP1WYn5nwBjVkyieoxPQSX/gYJt9IKbYQe/0aNnYBk?=
 =?us-ascii?Q?9jyTX+CplGv85pxAEgDRDRkrfeYj6w7+DiVF1SPxrRj6BdY80cVtj4r7vP/1?=
 =?us-ascii?Q?Q1pxk4gTJBcrEbfJW+PHMBr0rtguRSAtTnwE+msKLyTEELNhEZMfXSdoeQFb?=
 =?us-ascii?Q?gHCuAthXhrHAn7sBUl6F0HWqRZjQDU8qtYxtCFn47+4nBLa693+W/ZjJc0Ih?=
 =?us-ascii?Q?sltD3r9VchNufBb+MtoYEu6auvqexj0uh46bJm2zPq1NTudGUdvryhGc7LWf?=
 =?us-ascii?Q?SFlD/21DRVZK6tdUfZ9V2Mh5PX38vNl5ra6VZOdIxqd7z4OwI+1cK1YWfO5K?=
 =?us-ascii?Q?mUy6QIppZeWvzOgpoptoX56/YGjjXLPVgqYeUPBh4yR8bnxjl46ssgYFA1D3?=
 =?us-ascii?Q?uZlksuAzyWLHQ5eNcV9819+Af/519+nCVyBKZIrIUaixGvbqH9Q9+XXwFrnH?=
 =?us-ascii?Q?IO0bB7F1BUIcMKjbWLoNJuH0XgLBf8dDboPIZ+/lWhkv2ZYutfTyzPSttt/a?=
 =?us-ascii?Q?PwUb5Jk6dc3lKwXgUTIcYbLx9a/6gOf9lByNoAy+DEEwPIk4yksftZOnkw4I?=
 =?us-ascii?Q?ZRe3OmhwcgbuXvd6JV67g9kVkPnw3/sshfAKqVG4HBKf+d25WkkibKe0TLRD?=
 =?us-ascii?Q?rDbOfASwNQPUmSmrSfKZC71s7sgKIcmLZYd+NdkJEi6VjSWYKbgHCX/lIVW5?=
 =?us-ascii?Q?b6W1rBViRrKYhwIPQauyi7hWddegH63U13zJrMi9JgGw7xX10MtAjXZQq4/R?=
 =?us-ascii?Q?3KPVD4jr8PjJtr+qGIQ2OPnEaMsqYW14Nf+mvq6OTjMliu+eqoteqDcNtdoR?=
 =?us-ascii?Q?nU2Jn3bVTSA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?w9AR5RxPEe8S9DgMmZozvoftmppI+R5p6ImkktzQpVGzUGrTIL4gDZhMyJWX?=
 =?us-ascii?Q?L96pBullrWKaWnZJg+lELiwWB7pw25ZgGoaIWKHPcGNW2xd6J+v8p+ryp6SZ?=
 =?us-ascii?Q?sfFHBqgBHkaz0AaAqBXJce8h3vDEqdF+zAN8FFib34nku7YlY9gnFbuW3KCz?=
 =?us-ascii?Q?f1sYkMdFdL3vZf9/l/CUByi7uySUc3QrwXgQIq0u9QFVTpZ5KJw+QMnwRKD0?=
 =?us-ascii?Q?lxzNZ/R9XuVM+MCrFsCqTfQIn/J3Ugc1MnDo/kpqKW4BYhC4Uuvl0NGbK+o0?=
 =?us-ascii?Q?hWZjFR2tzgN/ULF45fmaY/lpdzYx0HFDxtFRx+mKq9+yzmdfIrapx949UCp6?=
 =?us-ascii?Q?OoW6rcSNl+rBR1/EY37yJhe111vnzFwG2kGIURVctahW01mD2/slfDipXc8z?=
 =?us-ascii?Q?RhqIYcPrQbbuQGqEjoUC3bxlWXeapyekg/x5kI4m0H9yZF4ycJDhX+sMaKVa?=
 =?us-ascii?Q?qB5TyKFCyl84JjEThxjlh37VG0ZRjduw8FxntDDsB2W4rQTDJrrrOwHFklbJ?=
 =?us-ascii?Q?S1FBlJB+XdHjb17Kl3GvUDkG/Z1Vo1FvJGOQ/b+wXRM1tHLihEclSo06/YqS?=
 =?us-ascii?Q?QZMYhq5phQLfeXSvH4Eeyz5oJyx/6rf/EjHB/fzBjXheyNrS6Y+mk1N/NdzM?=
 =?us-ascii?Q?bTdf+J3bEczOSfot+5Rvq0vV7nP0ZsnQbiruW/LtGh5p+/NH6geRwjBNz8Kl?=
 =?us-ascii?Q?1IsyJjne8sKDL8apHBzGBuv1lMsAxWndwd5pd9a/DYHkhwVkGzJwSptZaPZW?=
 =?us-ascii?Q?pMU4aJF4DeD8Wfc98A16XO9smCb8qiPyus/SpHllfrLR4aKLy92zyLl4rYu7?=
 =?us-ascii?Q?7dmrqjBrGs9P7uUzqvQTkKk51oJSkJcnz1SP+eVk93rjsBE7wq9uEvRWI1KE?=
 =?us-ascii?Q?NXbedkymONLyBsr34S1ehvVuKyP9kXKbjmazb2iqc3WLLJgDQgxJKuYIB9jX?=
 =?us-ascii?Q?l4q6Gm74Lp4k7vpXtl9Oo3mOUpRohadMa56U/GR+QKQgGO/INRTEK5msgQRu?=
 =?us-ascii?Q?gmv/eA0qxOMYfhkSC0ncopCu95gYYmr02Vqb7eAkS5LfuWDVrkeSvB3x+X+t?=
 =?us-ascii?Q?r2fNV0Ry3b9kfv0X13OGucVhA85C4NN24EkutLIAbvVuCr7jqUCovqBjLEb/?=
 =?us-ascii?Q?Ioeb/XL1EvNB1aHXreS7ZCHvBYBab3rLehrt8fXTXucfTfC7jj5RaTmptdh3?=
 =?us-ascii?Q?3fpz5F+2KTbOaU5Nbdfsi7/GJHu/RfAfv2Fvj2vXuHd9dBqsPLzxw6FM8yZB?=
 =?us-ascii?Q?TVcdAhu5tNKOoPekodRGmpmYi534hhxpIWhZjx7V6jmcqF6u4Wdkcmsoz2lk?=
 =?us-ascii?Q?XCgfRgMoSHqobANX7Ct53DDzXcCRZugvn/tJ+YCvsyvnuxvqPMTP5bnW3dmq?=
 =?us-ascii?Q?1eEY+PFwurSu6KkduJ17JW5UZz/qSrVWWq2xzSL3UZ3HncSezMLHQK41E14n?=
 =?us-ascii?Q?IGJ1jJ3VLka4FSRTW2eaHSO7R4ARKZXUIKlunHVCht18QnicFoU+0ElaZsx9?=
 =?us-ascii?Q?g1bdEYX9tntpt6RIOrvXsxi2m7K9N7QkHekNrR2z/mdD62RLLYtJPE2JX3Ed?=
 =?us-ascii?Q?wNvtQaEgpE9yjMQSUKRTZSw8gVTVeaPyHDlvntGBVFVWMNaK+pDq+LNswMyz?=
 =?us-ascii?Q?aw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	lF/oYkWyw6htm7RelCx2k2cB//bf/VwbXpNLS4SvDtuaGJDcmCC9lU5jCULvQ3ISk7gccf8jrS4rj7kExjjUDa05eE34IdcjkvBHTg4VJuAnvP3GA2nuBQjbo3gXZMI4TpHRoEtEZQ1+73xXlxaZRxCiJDBghODgEBRt1C+raqmmdFiwIN2btmV8A66RBoxv5b5b4j/NF+51zHd3k2p62WHgvFCI4NFOs49FwupgVlVxHgl4e/4oRDUBbZzlfwePEqCIRsuAauyAtOQoLCNVsBa+k4TI00NgTnr3P4FZQKlYkW+Dvxp8VuJYt9h1odzlk/GFfGwHzfU9rKJyHSD3DUDDu00KHzCdIx6zWiCfSRjQNPC+BiN0DsW+X7RQYUm11ovBYP0MZnTnWq5yRr1EVPvsdlt/IwGmDegmgiY/Z+9IXIza2/fp8MEgr0OEz5jC5VAFss2nv15VKrlTqw8qNC5g7SzPz6cWJN6v4MG8WzLKTDGw5lDsaVT96gLPNL9NIyZEk2mDh9Sm0QnFdAypk5O0Pfb4FTQsyXP0z4M/Yqdf4BYfkJIx1Pcy/1vezyOCORGVjVIFG0TfDsCDsMIx9mTGT9r1uiRwLHUpoe/WCiQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e77ecb69-eac7-4d98-ea5e-08ddc9a41187
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2025 04:47:46.3987
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bbz+Hm1oUrHcEgJ7YfmrB9HxsmdBUucwUTvB2vz1HAllKt4lsVemCGvZNC2MluZG7lbenutc670SUThsPbQWFoRLrtW7bzQZ620BmIN4hJ4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6110
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-23_01,2025-07-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 suspectscore=0 mlxscore=0 phishscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507230037
X-Authority-Analysis: v=2.4 cv=WaYMa1hX c=1 sm=1 tr=0 ts=68806975 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=yPCof4ZbAAAA:8 a=VwQbUJbxAAAA:8 a=37rDS-QxAAAA:8 a=5Fy94hsdk_8r7wK4jFsA:9
 a=CjuIK1q_8ugA:10 a=k1Nq6YrhK2t884LQW06G:22 cc=ntf awl=host:12061
X-Proofpoint-GUID: -rZjpX_9iUvty0jRhVwxOBdYhf3fge8t
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzIzMDAzNyBTYWx0ZWRfX2TW0fZh75A6r
 1O0j+1DhDH/Zvm0Zgr4dZf1VBAZmf/CWu0iV1QDdE4X4MND0144VqaiviqrH/bGdgCk2RIr6TAc
 PH90w1WZbNkwuG3Z7UQ5nGRFnJeoxD/v//PaYJwHQug+RZBOzCvrdZqmcKImObo3EL63F/e/GVo
 yPWGcMOIlSguqIU9Eya8IBz+MPlSyZu4+unuJTV4jopVNs61yHuebkYyGHASwRJAXW1c4cLm3tw
 05aSjrTaQIrykCBZwlz6c33VGD+/SXs2TpLGI1/akVuaLqBq+0KvvF9VSAAJwTaY/I4v9O2aWnj
 XEaCdfE3HWEJm3lqY499VfE6EQ1/EOe2xgQDeIV+IUtmRhFXya/DWXAwNxgOP3GylRxlcd1UiR5
 b2SMmrVmBUTDrZJ9u51DNGVTkZ4bAm4Drjli1gae4cPK6pA0UY1ySP5iAvG9SfJdNq+n4Dhl
X-Proofpoint-ORIG-GUID: -rZjpX_9iUvty0jRhVwxOBdYhf3fge8t
X-Rspamd-Queue-Id: 15DF080004
X-Stat-Signature: aey8311prnb8azbk5wy9fce3eoxwfsn9
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753246072-379809
X-HE-Meta: U2FsdGVkX19EaMfrc73xyBmMDx5SqoHqAYawsENQou1ZxFi12FtyHWUzMNuawQRIveCtCh44EW4J851JH24jJqw8GCK8Hab+lRgwa4KCCS4KUj4DZ7i7nbMtJpGzYL1uq/qJ8rxzKexBGshkF8ZaJysn+1HXxcZsVx4IZxc+WhRdOFp0oxBPzj+I75Fz9Sljm1Vc8UEOKsqJu54OZ4Td6A/cRoh5FlLsnkLZjk6YWCb4ODjAGtB3zFYeZZtI9m1le06sVweGbP6++xN4lp9Fp5QDb2CGivfIrHuRocOikFuJL/qC2LAKVMMLYR64qhyY97TQ4o0qE1VPvmAYlYCvfl/6wW13NlEcTMte2L50WoUgwEEAwEiweT1RzVOBX0ij6ipypMWSFY2EvfXSiRW3cQYPUuFM/cBlskGFmlTEWBoI2T0cDNYvTeQ4orUIKC5rT0KyJVW8qjQf90IFn9PNKgfdN820A6xg7RrljNYkZKjxVlIK284EXGkmfg+nZdJjFcLH4dIUcvncV7zPJ6W7DUk0THnhhI4H7SUSNn0rTXkYrUSHGSgcBRY7cN6VIXOftiHd7eFUFAYkAbWaJ/bWsiBDLH6+77mczDtSqCaxoDOLFAr+rX+q0o5Mc5qWMKNUdCznPG9f+XlPggSSsS6A/Oo99BnQ7rnUEcw6kjHtYoVurYMz2DuGLcnLndcaMAKRsWcIoIUUBibBuL150Zb5GsgLSxUsCX+cUCpItCn34tMCUEWalsoX0eOL2TsBzLPd30fNB7GclRzboCM++rC0LsopPWWXZpiVqc9AUFTp9eGL4QrxL86Im8zRFnNhuz16gAeuQbmFz6+xH4cTM4ssE8E7QFtQVgrdo6O5h0uKBDjgY7Satpr3QkOltFXO73dzbtXdh0yLq+5DgiNU5Z8agiCJLlun4yRDuA+EiqQmzSIWC9FTOt6ZVk/100UIkLFgvKli2imKGlQXzbVCbQK
 A2XgNTZI
 OTyYXsvUg+1eS8zIFxFPZQ8RZeBVu3JAQ66ObBZwhHf6ODYVkDwdApwHbcqAAu9ndf5rl2d2hWMJx97IgTQBntOtq7vQO5NrSmpp45/5Gv3qIqEAR3YkA5BTxPgJUEnQuaU9jiGl6dpkPxGJ/w8uWlCqf+TjIHqXeInxOcvMIZieDhN8wTE3dkzpsQRQ1MvfyYhc/UqY27gBDvQnwed11qhRnS308tnax5kcsfOSLykvUc28vhVh6R/CWHngNp9uWplTcuENaRLebWEatr3tGuLVR0LaFwYX7VX5boItiHjO5rxwyXquSEn3qwUL129C0TMboPvxttcf/I/z/7Y0rAiPit91BLdDi+uJpKWtm5DURSQAvNq6wt1j1NBvEYnU70PLvWqrcemluhKggRx9teEKD2Vx8TxN4HMCzaNKqbD72ypFTz49hvVlPWT2KXY2xHRiJpTHbHX/0q8fmCPv/bL7+LZY6ioaEx3SGhzO0arvNNUlu+oPMiPf5hiLM44Zq/WMzR8L6f8r1IJzIH525a+0SXoGS/noH2KPtzEjanTGoquG7pSYYLZR1p6GTN9dOVBMJIbEo5LpdMf4+VJEXMGCAH3FxBSmLmpyNqOjtXe0LxKnwPP0jnZIhj+XAI7y+nf2pmQ9b4s2zHaJp911Mi1W1DXvxSMmcWhRoeJ6DPHTS03g45eh4hyypgOBozIak8Fjr1Vbuc9qJrMPc3ekg12hXWUM76NJFQvaXzK7T1kDIGbNcnEI0Tq6jd+GKnKOWYUwl7iUnyoP5EiumvWCZeGroZbVp66+nEPM7U8gMlS41WrRJSDS0sYTb0Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,

Please also apply this fix-patch to add the page_counter.h header too.

Thanks, Lorenzo

----8<----
From ead67f805cb860c355f2633d3e4a7128f0bac72f Mon Sep 17 00:00:00 2001
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Date: Wed, 23 Jul 2025 05:45:45 +0100
Subject: [PATCH] MAINTAINERS: also add page_counter.h to cgroup section

This is the header counterpart to mm/page_counter.c.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index d062318b6d09..bd9ee8d5e17c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6163,6 +6163,7 @@ L:	cgroups@vger.kernel.org
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	include/linux/memcontrol.h
+F:	include/linux/page_counter.h
 F:	mm/memcontrol.c
 F:	mm/memcontrol-v1.c
 F:	mm/memcontrol-v1.h
--
2.50.1

