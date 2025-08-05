Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C3CFC87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 13:35:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6AB68E0005; Tue,  5 Aug 2025 09:35:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D42A48E0001; Tue,  5 Aug 2025 09:35:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C317F8E0005; Tue,  5 Aug 2025 09:35:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B3B948E0001
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 09:35:36 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6ED9416055F
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 13:35:36 +0000 (UTC)
X-FDA: 83742801072.15.A826903
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0ECF640005
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 13:35:32 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=LHke0NZi;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=OlF7n6go;
	spf=pass (imf12.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754400933; a=rsa-sha256;
	cv=pass;
	b=MRkU6mzRkIvlDDbEEgVxprS9L+Kpau0KDZeVzNDsOoyKEEiftCUyTMYfYXJBYr4T5r4rVm
	TnG19U7YilSKVKs+7ZJu8u1i8Zfr1xI4TuzkXgsVRX6aPhkR4BCnoTSazR5fss+o1lOaS9
	V9GQO9yYFP+ADwKZX9MItVe0jb+Q+Jg=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=LHke0NZi;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=OlF7n6go;
	spf=pass (imf12.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754400933;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BK/hK3QYDRk0msL5huC59f/J0R5soD2cNDalRNueksM=;
	b=l+nt+wNAnT1CHemDX3SsXDu0VYMU1HXNUkzOSzMJXu0P6mXTyib8KFYdl4nxyU51V4eUTB
	BcGGiP0hgdEwL9D8Lhjshb7pCQye/aOGSzyFMV+YSzy9At0gs2+4XriWlm7HGIF/ygp4hw
	gpWnr2iqhxQerc3DuwqGynaUhNsx4wc=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 575Crluf027120;
	Tue, 5 Aug 2025 13:35:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=BK/hK3QYDRk0msL5hu
	C59f/J0R5soD2cNDalRNueksM=; b=LHke0NZij28DafClFOtYFEsdqiF+NG0m6Q
	KwSjWspwV1UP1af3zZDIKqIPJ4fLRUdQV8uNm1/yTg9I3anVI7xIzDs/H/dLIKEO
	ON2JSZClWd6p+4ZKlO+aU9XaW0Qlteamztm6qrmG1stKt8hbmpm9VLZW9d3sUcfC
	X9sgd300Y5eKzqx6GVZZ6vi0wSpl02ixqPinynYw4I5Dpa+UmCTK518SKZdkgkpR
	ATKebRwFuxQdYnlRi8r7nL1C4ZGzHIwR2G3QWJcLpHT4ZSgvenfBHCAqtTBjgC5Z
	VLSj1kI2rmoQFxChGJ5AeoppB4luv9b2Z/oNmP9t6m3WlfCoZ6Zg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 489a9vvqec-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 05 Aug 2025 13:35:28 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 575DRkQe017983;
	Tue, 5 Aug 2025 13:35:27 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11on2051.outbound.protection.outlook.com [40.107.220.51])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48a7jx8232-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 05 Aug 2025 13:35:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=myte9EYDPJeFP/xe368vH+u33KEGH3TOGXBxcJnnAfVaGpxrl7aPhSG8K+Yi6NTve3hp8azC8VwFRrXEVxhzri9D8IaSRjsXjEQxT+qcSvDdY8OrbLVcWUgHa8rr3TZEReiPbv9Bspf1bTaAJK9vQi/NvNpHTI/qVqXx0Esc3VfWcQ0lh7LeIo8mrrr10rCvbD31FnG14XrAKdkq5ho7xPcAPvYw5jf5HKgo8efT82TgJOjEj3zMBeP/hpepWZ/Y27+dQ9+bG8csBgqV5PX36rlzdQpIHEIhggZONteFVhJMk4KqZTOY8tmmEZYrcRSFQ0hLE5s72qiJQNt8nkhjpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BK/hK3QYDRk0msL5huC59f/J0R5soD2cNDalRNueksM=;
 b=vTb3NdjlDS4O1KW6H43K71ZKNFmt/GpYh6gKzwgMoFaxIKLDSbVNuNKtgX1FjCHIoHp7dtUfS3YO0xnnzK64bwcZ717eNtmhT5uXf0a9Lu8hJUwnJFtQg4OxDsmKnTeRcg8nxk2mg8l7NDzyPrFfqrI5fHdu0pvDz19M/UK9XZNWkoACSvrVeeLgZEgcTVM6dP/CEWSRwhXES7cFCzYfVxAFHOhLJtBSs4T8pQ6+okFjdORZSkYgiJ0CS/fCvTlBJ/r93rjtjVx1xcVbfwCBbNL7KUtuBwmFkfgFYsp+sbeuQbtnliRA6rLMF0hbjLWcpvwy+wDAaLCLW9L8q7iXJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BK/hK3QYDRk0msL5huC59f/J0R5soD2cNDalRNueksM=;
 b=OlF7n6gokRMYudrIXbleGdLW9AnYqQT4dWz40FTBweOHvWuibt3o3Nifyk69X49OKgAbTsjo+WTL3cVQNQoaRF9R/SP/gFU0kAiNtMBKDvCWuYX4LjYdVypC0URTk4ZwSM2UBhGAcYNcAwei9tV6sI9rlycqiQCdpuEN9KH9Y3k=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SN7PR10MB7073.namprd10.prod.outlook.com (2603:10b6:806:34e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.20; Tue, 5 Aug
 2025 13:35:25 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9009.013; Tue, 5 Aug 2025
 13:35:25 +0000
Date: Tue, 5 Aug 2025 14:35:22 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Li Qiang <liqiang01@kylinos.cn>
Cc: akpm@linux-foundation.org, david@redhat.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Liam.Howlett@oracle.com, vbabka@suse.cz,
        rppt@kernel.org, surenb@google.com, mhocko@suse.com
Subject: Re: [PATCH] mm: memory: Force-inline PTE/PMD zapping functions for
 performance
Message-ID: <9d60bae4-a61b-4d4a-a0a8-19058df30b0f@lucifer.local>
References: <74580442-2a9a-4055-b92d-23f5e5664878@redhat.com>
 <20250805120435.1142283-1-liqiang01@kylinos.cn>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250805120435.1142283-1-liqiang01@kylinos.cn>
X-ClientProxiedBy: LO2P265CA0290.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a5::14) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SN7PR10MB7073:EE_
X-MS-Office365-Filtering-Correlation-Id: a5198f0e-2466-45c1-522c-08ddd424eefa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7+HKE+fv0n0x3oG4kwfA6/A76pSv6XR6OBr85uzMnapy6aJvRPV9aeAOaen2?=
 =?us-ascii?Q?UrbwyMA3eOLUXdIW74TFNaunz2tbXvCeL+lYjifp2jTQAkan56LNmHcp4tIX?=
 =?us-ascii?Q?PiCw8+XBmFgmamW5JQYGA9DSdKmiAgFBoBaE6tzlvmWAXG0hgc/lBKx3HDNE?=
 =?us-ascii?Q?2kT5JnmC3AbLvO2fyRDQF9N1tcTP9Lx4TEs/oBhh2D5PwUCigtJGy9Mwa6u7?=
 =?us-ascii?Q?VAP/4xT5PxLhH2Ncg7h29CcMaIex4tCkz75Zy0WOOpjEbPowVUxCjSFqYRlS?=
 =?us-ascii?Q?6d6gqVWCMW1HJAGgMxGOoNg9L3aLSseKqxMZIj8F+z4TNE+5qlvkdXRcEJXj?=
 =?us-ascii?Q?FRDEK8GwRxK+5h9VZTbXv0HYYCsH7qeZ8mwx2XEBmm19AJenFgigSJDzypuE?=
 =?us-ascii?Q?MJuW4RqeEpZZOhpTdy2tqRBYuT4qc68Y0O7ai4kuLjq8AH4ZlgS2V5Ixp/3T?=
 =?us-ascii?Q?wHbZRtz4LI+Ci05xEmNQSb5I84virn8qZxKOT3u6QBwUq0HloWEbnlC3vzKc?=
 =?us-ascii?Q?9LqQbM5s0pJ8AmxODofqzA5TdYEiVFZMNrGajFQChrZxz/3U3Cxdkv4RBeBS?=
 =?us-ascii?Q?WwShAT1e1Pjk0PKKELLBPQXQG/R7tvDGGzpYyjUc8XQiLhIxt3IjTN2Gwh89?=
 =?us-ascii?Q?urIJBH5kX8vOPg5YqhrAVNjzxpLWXq2NCt5XK2WyCltdjbaNSNl9HTKwMDJz?=
 =?us-ascii?Q?DOGZ+wQulNMRroouXTTiCVWlJTFnO/fDoPZtgh9rFVbVsEkOGf7iXfWdRm1C?=
 =?us-ascii?Q?iLLDK8tYwtaJCu5OxclwvP7UmscAuyNI4i87LrCXBwYTm9uHE8Sb16PsgO6f?=
 =?us-ascii?Q?tjxVU7jpk25aMWMq4swW0ii7sJXGD6Xk6Kff7XAwhI8aJh98VVwH9ug6o93C?=
 =?us-ascii?Q?1HdJ9c1cL23W2WXPnElyrEVVFoGiSmt3srbYv2dC5SnEhj4MzJRVVVqLekSA?=
 =?us-ascii?Q?vBLerGljQighwafOJD5LqIjFcUlDNdUnYbhyjyVP1F7pJuhMDgesalSoULyc?=
 =?us-ascii?Q?pyiZXnpCYotL9ecnZBL36kBY1GnG/QAQvS1NsoHZxoVmz+N5OIhy6XKRgF05?=
 =?us-ascii?Q?L/nB2kXhCagiUMv963JWuCyKblreo30uLXKy5Dn1coHAd1acqN2icP73A9Hf?=
 =?us-ascii?Q?ZEYhT0djGNXQ2C6JQl7V/x5Rl/9bSFkTmbW3hQa+dR+VfuWmApUuwnUkTGJr?=
 =?us-ascii?Q?C08mfIzgSWVNFX+Ms+IIE9geJe5O7eRTMdq2mQ1V3NguCR6lE2xaQqZ6/NPX?=
 =?us-ascii?Q?RXkHRUpyJTf542FFxPQIRnfOVwNmtU2zHlqyrpBUifU4lsJySAeldav0WiYa?=
 =?us-ascii?Q?4WZTkmaE5Ootd0T9hzx/UPGHBKf367Zi+AjK1SHXJfe8vyqdnHjdbw5/+6r+?=
 =?us-ascii?Q?U0XboQba5Avsa6L8PBdm9E25Co4JvAMTUjbrTfVQL6aDpZ9UcA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Jz1Qw6L6gFgckFG9I5T6Zl9JZc3VQ1bC6tgGzqVj1H2kWt6p/ungaZlCX4S7?=
 =?us-ascii?Q?YucLEDEmExt7MVCnOIXZi8269UecUAUdZhqzRZnNnB2oJpsj1H5Gr+5Ftp9L?=
 =?us-ascii?Q?VzIgW2vLblS51gZJfkIR/zEikfy60avu63pF0yArJNqKQ930LHD0dUrGZAZd?=
 =?us-ascii?Q?OMMd6Nnkl8Ryr4TTcqHR8763QgYanpLZK7fDgSm++hTHvqUN9l/5aw/2+Vwy?=
 =?us-ascii?Q?IUKfw1wR6HdLn0dIzObN4lxNSkto2dKmoFxXQvvV9GtpaeWEF0CPXKWTBISU?=
 =?us-ascii?Q?PUAcVcI5554FslhBhQ4OA412kCValOUP/Fl6kULxKgXYxgX/CMqhuwk012gJ?=
 =?us-ascii?Q?ERA+cVy/6pfcd05InIS6g9V4pdJJwqJmhTj7SqH3erDVLY/WVqy8jMPSSbR3?=
 =?us-ascii?Q?q3NU/RpW8zkHAGS+0u70Z6CFpmIgEYjdo7cob4xjd6hoWPrAZo23yX8PBUyF?=
 =?us-ascii?Q?CIUY8mdHg8/2Lgl3xdRu4VQAQitnJ/ig5+ht85pwXcZQA7hLq3HCIIiNZ2AY?=
 =?us-ascii?Q?WFVMqwxKyE8LOmkvx8b6DgnEr+JTBVTpjRafnBCSl4JZgNBH13ayuL/NVasR?=
 =?us-ascii?Q?bRom20mDtCtQrmRz1uYiThp4x97gzLpobLOK6Bq3m+YLSnhV/9s0kKch0LH5?=
 =?us-ascii?Q?TlCItv+8meinzs50tR+xQL95fOU81x1/Huo+pnejB9ymvQUShhiDUZDBGXKl?=
 =?us-ascii?Q?PZ/SQbDkhWLMunko9mK2/H2WM0JG68zdI3XkcjAKmGdJY8Ebjk8AeuiHt+JX?=
 =?us-ascii?Q?Cuam8g5qjJ4/zXzJe4xykOzcbxcOlF0yxWVly/YMpP4NYn2PU/2+jzSRVsfT?=
 =?us-ascii?Q?9Iggb2yJTtZZc8dBJ1s4JPt+bZFa+vroD9SY/eOPrZt1ehRTUwFPHz+IM/RG?=
 =?us-ascii?Q?3zlFLLaP0tolksHO3JC3gZVFBSwYEWDkDry6TpiJpk8XvqvQblQMIf2Z0YnA?=
 =?us-ascii?Q?QC4vuFjdfiF5c0tO8P5KCQwx58Pi5j3OIqzXLe+WyT2UQ8WVg6T0dEkOtMK0?=
 =?us-ascii?Q?83yNGLrILAcmfgivoyo91pNyITvxZ2xbPPIOwC2PCLl5BUhtfdeiBYsN3qy3?=
 =?us-ascii?Q?H+XbN6UJ04Nvl9zZO11YqxPH0wa6/op1RDiRSv7M9QB0mHQlYS6JBC9xKgLJ?=
 =?us-ascii?Q?wsL8APdTkJb0KFiaa9DQuM++OqUz5dAE/eM9u9n9lcfobyhfzZ+Cev4SunZ6?=
 =?us-ascii?Q?e8cIJE9ZwDRIOOxJWD12HDqiyKu+SyN/dlaX16nu7PlRxb8cFlsN5aXLdH9h?=
 =?us-ascii?Q?kajfzY4K8TcmXa1Z7KFbnRlHOQ9LAY4FO58OXO8ygXKd/mYATLIZEmF4PHvZ?=
 =?us-ascii?Q?8n1e64ByvtngaivUW6xn9HlivzME1C5iXgYtEz56dSU4CmgZMw/lAsLYGerY?=
 =?us-ascii?Q?KWmis0lynoRdj0TS22DmbTRTSTjIPzaMF7vYSGijrlJQ54sXD2Y+ii0J4kcZ?=
 =?us-ascii?Q?vmEcGBQndHobCfsmh2ua0MUzhARXCjLlKLMcyTckFBI5JUY21GaNxpIP5wDn?=
 =?us-ascii?Q?A6nwKbPNe/wMEnm2rl5MfuzBxUYaWn7aZc0ez3MNMWqHXkvoeNB5HNm/IXXW?=
 =?us-ascii?Q?YqN74o6BgkBDjnBwqOfBK/XQ3swo3dnwKWJH4KyzVF5EQW2Z0WZf2SiBgitC?=
 =?us-ascii?Q?sw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vIQoE0Zf7mv7pXJiuiunp78wLCOCMEb0MJTxoiJ4LPjenZTBLqfdmeXFuXOxl9ndEssbnIGCdxwlKIOOj+k9QFPfWbVvkAm4PGkj3GaEsv2uWhcumbTFB0fT0XV1aUOobLYgtbBe8nPYO5zDUkRb0eIAxHrp3s47eLfvkrsiMn26GrJHW5v1NgSwWDnk/FN8knAQ+nqfoZK7Gy6pZlJgh4j+Uhk3tNZwsv9NzLYGlaMuhvd8zLCLX5/Zxi5rw+FcPfK4Fdh6BKsfmMbcQO9UmFRJdPnzBZcFf381x4PY/C2DlhehCvXWID2Lk5ukxk2Vbe/REEht8Lj0ej/wLWoKiLGrKB+Uwued/TKoYPo+8jXzj42XTkwzbgnD224JtMaRDXTazh5C0WzXunqz32B63DLzWnzjyiFE/jppQtpurPn4t6MWw9Vpw8ENUZjv62qYGMkO0R90yqhSSwW1Vdl+oD0/0rzWLBZTk5mazuARIUJ6O8alxXZlFIqvcs5JJf0NMayJfCj9OfIzvHDo0GQsHubqcuoKcXyxnElqXSIgJFg6iZf3FCKH9i+05mkSs1uwE3q1pwBnCjYE2Lt9w5+Ar2JgFht9Rnab/Wd1f/v1wps=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5198f0e-2466-45c1-522c-08ddd424eefa
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2025 13:35:25.0593
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NahlPi3V7NFfr8G0NUNRLpkD8JRAHgQacsnm6jXS/fDV3XZUTBufrlFg2Cu2vUNGTIHzBqsuaOPNWiA/2heDhpQ+LLv8j6owBrNfGKwOh70=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB7073
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-05_03,2025-08-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0
 mlxlogscore=999 suspectscore=0 malwarescore=0 phishscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2508050099
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA1MDA5OCBTYWx0ZWRfX84yQA3aTSkBv
 BH2Px2n3O41QvwnHLaOjflBHGxOO8LudvZz9O1Lj8jcPdm6SwnGyTEJUpEdg9a4XAgIJmNXsGPb
 Ac232yD0Qf4I0OUqcQaMBu2rzPDtKeq5k3QT+zP5heKkrGaCGleNE9fTpU/B98aObudzqYGPuKS
 3LEian3lZO9LB2kzUBrsure6x17pH3qyjo6oMmPS/F4w1d6R1t2JI+V9JUI/O1FCJKqkz4KhF60
 xAJcqIqOhDpPrPPSOyEqOQT3FlWynBuooY78iX7QGCuYWBwSHpwMIf5J3CEUFzeFN3C8wh2GfvI
 UgNPDd15XMzw+UwEpRiODiw7Dmk3ePRyZ0hY4ewVOIJ866Wj+PwxzluhEe1O+LmQPwvos5ojL/R
 oLVf9q5Q9KWj1Vi0cE/+M1Fe8ejRCi+wNwthKhP7q6Y/o4uUo5eGqW04BWtC2qhC4/CH/OGM
X-Authority-Analysis: v=2.4 cv=SIhCVPvH c=1 sm=1 tr=0 ts=689208a0 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=e4qpcNTpDqXyqUsRL9UA:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12065
X-Proofpoint-GUID: I0vYyXLfG2DcipWQHR5aVGEOggmH4xsD
X-Proofpoint-ORIG-GUID: I0vYyXLfG2DcipWQHR5aVGEOggmH4xsD
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0ECF640005
X-Stat-Signature: o6y3kei9xjiodfz96wrcidez79gfq9qa
X-HE-Tag: 1754400932-518824
X-HE-Meta: U2FsdGVkX19libjs+i6wXr546p/XwHeG2qx11IUApUIiXg1FVzTuTmRh8fuRa+2+oq1v+Lh/fjeEhWvwC6oz2NxCgMETA82LxDziU317ZpqUi5WIyP+VEeisJ4RfiC7lq0JJ8OcVeS/GeP4/XCAGKT23A8TS1sM4L026VZpXbWhbPtDWZ06Ee9b/GIu5XSAHRiibJYC3YL2A2UWXaZGgM8f14QxRTxrMl76nUh77vkEFEi6T0cqRQlzhyCHWfhkvOJN+tqyzeElewtcuH2zO5VzgYFkH+S6j1IWDi/5dSuBZnRT84IacPdL0NKndHLaIXAN7aMfbbTvGSD4pmjLxsIcBEUgtIDnUGScg1SrR1HSGtqcz/AP+KCUgzd+ilLyuuK73Ezz3xDF6PSSoFy1WfuVszZZRJN9r3LhvU8HLWGsmm9Ou945dWKpNGidTLLrL9ZSjJ1znpuQDarIGeLwucyWR80cBL77TO3U0oOpd6pN5LR9/XJsFF/ntF7+MmJ9YgaPgCwzFn3TAeYwp9q4dQlnluhPVT9KRODEfH6WHcjYsaW/b6OwotpZzAO4sJLTf+LffBVbexN3jfLFuRipZUBO2CRhoQB5qeXKkPqTI1S2RdHLai+tlW/rjptI75vUtrbAUypUcToTpTzuxmDT5Hc3jOWbycCHcvcfS7iTIzjUiTGWHlxSsf4e6BkqE/IQYxkssYUnBBeCigFrzaNK71Ny8KrNNqgUr3QGFt9nBV7cpm7EmQHsAr64I3m7HriHU8pkR2rYBxaON32l9tFd8Pn3C0sHyhMzqBQ1adPZk/Lz9KHhZmoDbpR4MxROLynpVbKaW0ule6Qi5I6aPCs/5D/laSEFrE36h8/eQi+mW2uMoT62kfrB0NVy97Ov1txrEJoff26MJdgqOoDcmZT8E5M0d3chHFI9CmOqiAN2zBx0TNhyVexLjQ6GG6G3YfA63jWSd92oysODjLRlUrLp
 0OnpzHwl
 Z9zfKMcH6EEyTKbzKpM6tMkx9bDPSCzOVhmcH0t21dZuKCm3XEZjhb+OjJRd5L5E19x6dssFk1xnwb96mP8QgfWaV2LlDx9pvOpov2eMYZg96BNsVCcnzVR9D/m9U4p6UzeRR4H92c+udRVZJTjeJh4CGU623jAiiGmuYnRcKDYEFjskt+cHUo09Aj8J6l5ZVYnZxEnou61B8065Tr8d3kdtiSdes5ueqkfaX6uesUHsqLXkomBHa2ecaWCEfK+7FhuW//DdP10nnHP2fsjOLryXaKqpi1D/x2ZDlOhnvamqiOdNz70Pv/7sDMEtYi0/ehaXHicguM1rON3hvIAnom9Ky4L8bDU3FEk2Dc6R/dZpj9jx9FzUOcleEbRKzlYMoMb1rrnweBi5U/NumrXXj1fzYEZgpMazHas8xChVJNOiHCcl0fa2W5leylKjsr0KGnO+IX7/VXedY/0E0nKmOjgN5wNgHyJ86lEaWzZ/206ul+36ydwmMf/ax/JyyziSlF3Axv2S+8hmFRxVWOf7cJJDuCBVeyGmHZSeJiS13h7OW0fTM4EGsho3bqfSpCNL489ImWpLqCuLUX1ZisIq5u0Ewk/rMgX4qM4Ewln9BK1LTxnnYFyH59XsrennVm+TKYKPYfTS44hIlHf22KnlGi1MDklBDbMxEGWt3LiQmoAvpIwZ6dkD88B/TsjU/1rHF0YGXFoGs2k+fcJ9JW0fKnfLopQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 05, 2025 at 08:04:35PM +0800, Li Qiang wrote:
> Ah, missed it after the performance numbers. As Vlastimil mentioned, I
> would have expected a bloat-o-meter output.
>

You're weirdly quoting David here unattributed as if it were your reply?

> >
> > My 2 cents is that usually it may be better to understand why it is
> > not inlined and address that (e.g., likely() hints or something else)
> > instead of blindly putting __always_inline. The __always_inline might
> > stay there for no reason after some code changes and therefore become
> > a maintenance burden. Concretely, in this case, where there is a single
> > caller, one can expect the compiler to really prefer to inline the
> > callees.
>
> >
> > Agreed, although the compiler is sometimes hard to convince to do the
> > right thing when dealing with rather large+complicated code in my
> > experience.
>

Some nits on reply:

- Please reply to mails individually, rather than reply to one arbtrary one with
  questions as to the other.

- Try to wrap to 75 characters per line in replies.

- Make sure it's clear who you're quoting.

This makes life easier, I've had to go and read through a bunch of mails in
thread to get context here.

> Question 1: Will this patch increase the vmlinux size?
> Reply:
> 	Actually, the overall vmlinux size becomes smaller on x86_64:
> 	[root@localhost linux_old1]# ./scripts/bloat-o-meter before.vmlinux after.vmlinux
> 	add/remove: 6/0 grow/shrink: 0/1 up/down: 4569/-4747 (-178)
> 	Function                                     old     new   delta
> 	zap_present_ptes.constprop                     -    2696   +2696
> 	zap_pte_range                                  -    1236   +1236
> 	zap_pmd_range.isra                             -     589    +589
> 	__pfx_zap_pte_range                            -      16     +16
> 	__pfx_zap_present_ptes.constprop               -      16     +16
> 	__pfx_zap_pmd_range.isra                       -      16     +16
> 	unmap_page_range                            5765    1018   -4747
> 	Total: Before=35379786, After=35379608, chg -0.00%
>
>
> Question 2: Why doesn't GCC inline these functions by default? Are there any side effects of forced inlining?
> Reply:
> 	1) GCC's default parameter max-inline-insns-single imposes restrictions. However, since these are leaf functions, inlining them not only improves performance but also reduces code size. May we consider relaxing the max-inline-insns-single restriction in this case?

Yeah I wonder if we could just increase this... I noticed in my analysis
(presumably what you're replying to here?) that this is what was causing
inlining to stop.

We do a _lot_ of static functions that behave like this so I actually wonder if
we could get perf wins more roadly by doing this...

Could you experiment with this?...


>
> 	2) The functions being inlined in this patch follow a single call path and are ultimately inlined into unmap_page_range. This only increases the size of the unmap_page_range assembly function, but since unmap_page_range itself won't be further inlined, the impact is well-contained.
>

Yup. This is something I already mentioned.

>
>
> Question 3: Does this inlining modification affect code maintainability?
> Reply: The modified inline functions are exclusively called by unmap_page_range, forming a single call path. This doesn't introduce additional maintenance complexity.

Not sure why maintenance would be an issue, code is virtually unchanged.

>
>
> Question 4: Have you performed performance testing on other platforms? Have you tested other scenarios?
> Reply:
> 	1) I tested the same GCC version on arm64 architecture. Even without this patch, these functions get inlined into unmap_page_range automatically. This appears to be due to architecture-specific differences in GCC's max-inline-insns-single default values.

OK interesting. I suspect that's due to more registers right?

>
> 	2) I believe UnixBench serves as a reasonably representative server benchmark. Theoretically, this patch should improve performance by reducing multi-layer function call overhead. However, I would sincerely appreciate your guidance on what additional tests might better demonstrate the performance improvements. Could you kindly suggest some specific benchmarks or test scenarios I should consider?

I'm not sure, actual workloads would be best but presumably you don't have
one where you've noticed a demonstrable difference otherwise you'd have
mentioned...

At any rate I've come around on this series, and think this is probably
reasonable, but I would like to see what increasing max-inline-insns-single
does first?

>
> --
> Cheers,
>
> Li Qiang

Cheers, Lorenzo

