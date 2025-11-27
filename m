Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41666D10375
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 06:30:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BE0F6B000D; Thu, 27 Nov 2025 01:30:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76F536B0012; Thu, 27 Nov 2025 01:30:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 637526B0023; Thu, 27 Nov 2025 01:30:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5278B6B000D
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 01:30:18 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EAB5E1609B1
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 06:30:17 +0000 (UTC)
X-FDA: 84155412474.29.3A6C9A2
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9CEEF40018
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 06:30:14 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=INBC6xF2;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Sfdr9vvH;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf04.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764225014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WtPw9/FGlBDlOUGI7XfnWB4ysckMS7G6i/DXP7NomRY=;
	b=8LGFV8vyR45E0VMOdXmc04eI/SY5kwZ4mzKX3nSr4PW++CY9We8O4zOZnkbz4jpnZUyWhA
	Xv4rO+WpN7acTDVi60T+ZT/Zsqortz938BeyRTAPMCjKLTf1yvs8BHPdluOFVocFOArLB9
	Xq+GJp9FsZ7zDVyWfhDDBbJUn7G6O20=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=INBC6xF2;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Sfdr9vvH;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf04.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764225014; a=rsa-sha256;
	cv=pass;
	b=ZbazQ4C3DDK9FTHksGpIRvaBwBJ4i+Mfj7Q1WspoM/M8GcdGgFBNQBACHSpRpSvt5xh9mt
	DBgvUILBMsi74jZwkcBa/VnfHODkSRUj2oq3GTNqFCWeFZyhcTmop2UytsUCFIrlyvas84
	yCBNOtdSPh8jfVv4nFje3uoAiuzJBXw=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AR1NdaH3618669;
	Thu, 27 Nov 2025 06:30:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=WtPw9/FGlBDlOUGI7X
	fnWB4ysckMS7G6i/DXP7NomRY=; b=INBC6xF2kOQ69qRj+F5HMn5JVemsGoB0+S
	BrYJ/sfBd3l73nUpmI8+9wgasqEtzHMgSNbrrHRSehVl/lZHrhW+N9jwGQXtDwkH
	HZg2FW9wiHJwmK6/wel3aeL+dv3fJbfLYTV/V8SnKwRw8oVZNGR26pDEYAWqZF8g
	JgM4ac0RK6C9exmavCp14lcgD1apswbs5T5bceBwG4VGtHGygSzJos0py7fiiL4i
	QS8MjimCe7Stq2js5meyPEXsNmj4PIQFXmVaQuVhrcblaqsN9119TbCHeJRfoZEj
	JD2xGtzgvRCkqHy4ZOUQFcx6mesFnKqW4hF6gDQY246boJb3yJkw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ak811xxfs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 27 Nov 2025 06:30:06 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AR6OKfP029812;
	Thu, 27 Nov 2025 06:30:06 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012043.outbound.protection.outlook.com [40.107.200.43])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ak3mffbk7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 27 Nov 2025 06:30:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yKo27U1XjAEbbcxuy+tDsj84ZQiMSLF3hmy3qN6mjs+wy7ImnJ85sb/T3b0Xo2dFf5hj5/miI37J9AG2+KXqDbe1tlVibO6ynz5HKnLKQvRq0ZeKk2yW+z/A+p0w0yzhsQKz4dxHzUW8eHeuhUlo3MkFjHOMIbk+uaRSCi4mCoj+kz7Psta+FbIG8fBtdB/l4tCIM5C33a+n5PCHPBrKs/PtJJkfiD1b/n6J7M5m9mch6vgufKF5CIm65od+wgmAAZ7W688AQavxV508EQbt80bN6ysuRqxW9Oz2iZlYxgIHr8/3NwJ8nPd6xhXA/6gF27K4BZunCu8s2cD1Ggk+Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WtPw9/FGlBDlOUGI7XfnWB4ysckMS7G6i/DXP7NomRY=;
 b=tns7ntS3m/yTs/7FPRfFAN2iBv3SkN0unledbeldGl24wFEGi8gEnKTndxtAGeuWQjABl/1Up12c+Oltw1GsuD6LZHCaZwKGTE5ZwdsV8lbG9BFgZ8lUGqM+0Qg3Aa4VQHMQmj2zR7pXgc9xGj70tjyDq4/Dp9LoQv7UHL8Tf0em8mtiVL28mGfCCjEtvIqKnlIl718/E5053A9wVAgqDfAaAp9RlSdgFS8Ju4T+rRUq0yhj+H2Sh5klYAUu/rBcgvjI+0j04JXHH+NItYb2ezqn5ywcOoZC51JC1NI13YJNcR2Vpxr8iSAc4xc/filvokvgTXt+eD3LPQ/P+lhsrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WtPw9/FGlBDlOUGI7XfnWB4ysckMS7G6i/DXP7NomRY=;
 b=Sfdr9vvHmbSI+0DbiSG0v5orpuekjoxq6Py5JhVlQ9hAH+MEOIhp45NuhLvMk7GPEjycCAf/XuieCWHWrTsVfO3c/KD3nqIMWtJYUMz7haBX5GJ5TJAnqVeM5Wg5HlIPU8US9W8yEjRp0paUu6MW47quYq5MuU9a5eK4ctWyX3Q=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH7PR10MB5698.namprd10.prod.outlook.com (2603:10b6:510:126::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.12; Thu, 27 Nov
 2025 06:30:03 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9366.009; Thu, 27 Nov 2025
 06:30:03 +0000
Date: Thu, 27 Nov 2025 06:30:00 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ziy@nvidia.com,
        baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
        npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
        baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org
Subject: Re: [PATCH] mm/huge_memory: use end_folio to terminate anonymous
 folio remapping
Message-ID: <6f7574be-07cf-4b0d-aa24-ffc52ce1ecb5@lucifer.local>
References: <20251127022436.20734-1-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251127022436.20734-1-richard.weiyang@gmail.com>
X-ClientProxiedBy: LO2P265CA0270.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a1::18) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH7PR10MB5698:EE_
X-MS-Office365-Filtering-Correlation-Id: b58d27b2-163d-4ee5-35f8-08de2d7e65bb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+N2EaOagu3nrmB4JpCajHLZUy5tecXogAo0H7n3uknJUgQL5O3HCOY6E/WEM?=
 =?us-ascii?Q?eKuJ7O+nppumfTuvTP+HV065fGxhLsRcmtXoxUFlCUnDqiLyq9VIBGg/6FTp?=
 =?us-ascii?Q?a9SPrcOqnzTCzWRcMVJOattzBsvZCqAjKMnd9GuTRZoW6oDBoEa8CndjjcOv?=
 =?us-ascii?Q?J59mIqf4lkWVhIt6AYcfAbWYPqnFx6L0eh6xfJYGSj0iaPtnNgJqoYXUmOE0?=
 =?us-ascii?Q?/etswTEKPvHrR2v7osJnsy865vtpN94UkP4vPDOn14b74V/qOKDxwnVWwp1a?=
 =?us-ascii?Q?nXgjrbLzV4RS0c3yYPQS9EaQzKskgoixrmJdvoD8gfhk7P/nlZxwHvpoAMpv?=
 =?us-ascii?Q?Jq/8QOWnwZmM4jTrXrjV3ALEcoT8NE4kaJJXEB2KUyShkPgHjSaXaOSIb77D?=
 =?us-ascii?Q?dVSa+UH+xBzpqrVL+EJ6N+V8O0duOlvjyNPuDoXkAXHhueV5TBislpL6Msjk?=
 =?us-ascii?Q?C2nebAJ5II/5Gpx8M9qqS8Dt79da8IeGHnxulx4Hm+GGATuYCA+kJ045Wcpy?=
 =?us-ascii?Q?eNhOAmcK2/BkwoGUp5GIdieYKk2ihoS66BGWmh5pXgmNYotzZSqNaW/Kg6go?=
 =?us-ascii?Q?IKVe54plXCgCeeKdSYuWpA912Zx9gwkQEEzY0gGVGbTV+EDXbLgpzgCg4Sh4?=
 =?us-ascii?Q?1UMMsmWhi3z/RYvXvy1aP/WF59+e3ioDKyWJ0Khilbw+eiK85Qrv3xysJWqM?=
 =?us-ascii?Q?kO3nLb5cDpyu+8/753EEMfMis/4m2eFUV1uRjBVnAKQrOwX5wdkGplm6ljTR?=
 =?us-ascii?Q?TKIz5oEaETC8RxFZtrG9GpepJGCnJdvzHUdblGpj591PzoBeoaQP141oykTG?=
 =?us-ascii?Q?e0eBLVk9zL8YoDfU1lxycawLZG9u60ezZK9jG0tkHEzFPRFoSCIpzsUhnlUN?=
 =?us-ascii?Q?W9xob/oKEU3Fewf7jE3hA0mPCFj+O/KCkavw5qGaLIkWk9fckWi76cujedPI?=
 =?us-ascii?Q?okM4Ta4Wy5b/xsJSYeXSEPZm7KrMLFv0rFtzuSP4DU7jD0jIL9E+n+3o037U?=
 =?us-ascii?Q?Q3/gXlM9J/yHsQ51ib+hG1DILhtZz9nqQXUdAyGIq9XNCg39T/lBd8MCsa+K?=
 =?us-ascii?Q?EX2WCy5Z75W+KTa6uxOkfBT8BQeHb8txGTCM5UcT6H8AIfjpGOWGmGL0k5UO?=
 =?us-ascii?Q?csnVeGI+0uzPfZwXe3w/aI0uvl4gn0M6WbUbHCusLbvEKxfK50xRt+Vyin1T?=
 =?us-ascii?Q?y1/IGeOS83Q9dtaerUlQI1kAWzkA6ic9EvitdQZP+UxL1WUUMcbA0uERcFUG?=
 =?us-ascii?Q?b3gVY2gz7lVRlRRJXyoENK05lXTbR2CuDODjYlnrS+Ve52dJxCCRr6rKKHhJ?=
 =?us-ascii?Q?R+G/Vt29uqkaiY9k/EnHTFeCKcTPt7Vfi23pm/QOY71pTsZErhg/7TlZcdRi?=
 =?us-ascii?Q?+HFxYXSG0Za7Re0tqKbdk7YR31r/f6Q5bO3+IVdBM1RejNY9sZlkr3cTbunG?=
 =?us-ascii?Q?6BcL5xoUy6afL1XfT6g4s/e4xRqQnz8k?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Cm5GsSzC+FNAVqor/aX5zXnc+vYFhRjSu7kVwq0o4Sa7Yrf+ft+jwzHnDEeF?=
 =?us-ascii?Q?ob06vJxV/JqGr06HVB3XWJu42JQrSAkP21qoj/cHIW3UbdrH82irqwIMI7Cv?=
 =?us-ascii?Q?vl60Qq5tN8nlCatnp09KDn+309jraZVNTm2j8Tr8kUgyDlK+FvxJ5JREhq/N?=
 =?us-ascii?Q?lrbLsVbXMThHcJKBBgYovLTqZF+yvyLdBUdytWtAh9DcCYHLude9471dLXas?=
 =?us-ascii?Q?XuMQG14tWph3rw71xUx0t1ziYRRLnwdTuACYAtNQo23Tyoy1vhqkaFD0kuUn?=
 =?us-ascii?Q?oI0dN0Wg3iVvuWuh4Sc4LhuzdDTWtovFh6I/b8AYJrnIlane3E2qoCrBHEDo?=
 =?us-ascii?Q?04x2jdkHEb3+IjQJfQIXvLOmqjWXsioUwMiwPQ2lq38hppsqP0p/1BarKTCV?=
 =?us-ascii?Q?OGbSgh1wsDo/S0P7iICCjKMLKJIkhZCu6UELbxr8gGRwDPM1iRDRN4oHdhVu?=
 =?us-ascii?Q?QR4nQt2FqR7jeqKL5XJ//b7lcY1VSi7A2Sbv3n/LYsx2kfrOZ6obtd0dJ2cI?=
 =?us-ascii?Q?L5+/zhNuS2UqFrFPUsA1ZdINqGijR3H9XYnL9gb8K2dMZSzbT3C+KVEJFw9G?=
 =?us-ascii?Q?k7VsaeIZNIyjFjIHh0zEyzezviX5nO9P4aif6s90ZfIvBg8ZlycX3vmodnEV?=
 =?us-ascii?Q?BD7W54RH7+msqwfkVgUvOpzL++PfYoVtjq8LGnXXdUn3HZNUofs71McQzpc4?=
 =?us-ascii?Q?anV2vP8duzWoX0GRMvXa8R+bn8jhWiLfnD6Xo0e51UdrtE4tYHyg7hjxfcsI?=
 =?us-ascii?Q?O0gTFD9YDRGlViSQyUr5LvVB1dbC2bMVl+52wMDiHEpBQsljJfBCdlQ1ATas?=
 =?us-ascii?Q?xDag98zCZ8P61qIxKHSsuE4zvwVJaJl+QO6oFkR40qPqyIqXPzoUgmkqNLLt?=
 =?us-ascii?Q?tp7utK/Hm4iSJjQ9Zqons8cvqcbgvfJvoLctZ5h2Q92xBt0ywUtlm4RNX7Jy?=
 =?us-ascii?Q?4/7rmH2ojtBeg1vVXYfr3VNpc4LR+knuzuSxOAfX4LdI8QyLvhTVnv76x7IY?=
 =?us-ascii?Q?JZnS59hkrI1o99vAV7VSJN8o4FBuMvgaHHVttzrqbG0Feffy5YUJnWktjX3d?=
 =?us-ascii?Q?zDapdtJvrjKGefzJ5HBP/b9cfoJ7E2B3CSXs/VtBj2zLx5VfzJ2uLOgQjEV0?=
 =?us-ascii?Q?Y6++ylFStXnmCB2TSTXwXBd9CuQNiOSeC/6Jm/1XZbHGho/Uxen8MjV9zGsn?=
 =?us-ascii?Q?KIZlgMUkL+XhEMdXUOAAnqDNlOJ7BbnVkYZ9rfFyJmQbEccePrMlXIAis/PL?=
 =?us-ascii?Q?JUEXmmx4XvN9WSRGk2qjD5rVLKvMlX6UDnrVuz2qPqo2YeDa5d/kR1NrMszt?=
 =?us-ascii?Q?Haauhe1mfLQSXEfpH3ko1eaWj2GLIGbV0OdM3erOfdCtjNfNY4hriB03M0vX?=
 =?us-ascii?Q?xIWV9WsVqX8rPyIWvhwTrd0+q0wjEv4gZOC8Lxj5UwFBjQTW9JUGDgUc4NBM?=
 =?us-ascii?Q?vysO7jPB8tlK6JtJi+tsw62wy7Dj/0SF4ao7+mp2CgC6t1Bn9vVEHrwBIBf2?=
 =?us-ascii?Q?XdAVP3hZBgIsRFl7tclN0RR2ucnTTadRKQ99MYbgra+ttIfOWMM6uxACIW/e?=
 =?us-ascii?Q?Wu/fKdwMb+x7gxNZmnbS2mtjNWTFB9lUoAwFKAix92kS//ec7hjxOsXyiIc3?=
 =?us-ascii?Q?cA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	zgWj4lauptf0tHr/yzMMfAZXMGPV1niJMKybWDmlNzYJNyZfGt4q/L5iw0yO352M1/+O32Z3kcvzfMMZOqY0PdQ0fCsqTsvPFMRHF1PGlgXFi6jfA2bEEBYiCuXC3of7xu77ERW5JSPvInkBr8vZz5HEhHc4KMl385QoKBMxKgZLUge04XpTtNLgwXg+FvZaAVjYPsglaHjX9yhtIdLCcV8hbIdMU9HzcYrkj6ZgymQ8nGaNR96h4Bqpz27cEWfFJ1vwPuGnaIv/b17i5QOHxQlwPFvy4EofJczLufbYvipUoiRmn1wQQkinMww1l93Z2d7PnE2rDgH9B60SVDMLGF5lsrL54SvnnZ2t9OmBDtOqbr3UDxY+9nFmhOBUaMA/KCg4/OyDUUyHfJ31NvZe5ibiYlk3gilErD02GC36e794SYIFnx1HxpS0AGhYfzjAwwLYNvz5I9T5WH3o2rhaD4iY+te1F6uFPhoVHadc+tcRD9L+3zmbh686pnMRuAtoUiBcwfo6ki9qSXQDlhuLksDGb36d+KLZw3j0KSx7NoFDPJlTuRq4JA8bvTWrNwmLJ/KGrJfgiR7upFkaajhh86JhO0b7m1iW4AElSeu3M/A=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b58d27b2-163d-4ee5-35f8-08de2d7e65bb
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2025 06:30:02.9774
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nb3kEE/zcB60Lalshrt80W5kUVUkibyRhFGC0mZgmKaYKYYJERtaZq7PPcIFU0OTw9UspVC8PTNYgCER/MmcoCFSUaUXDLfsMgNmioBRAdc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5698
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-25_02,2025-11-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511270048
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI3MDA0OCBTYWx0ZWRfX/GENMvEbzA5y
 Llj1zTAIVan7Q9uV41f8dxpjj9+37FmwdEnTY/othfs+xLW5qjgABlbz+ao3Lz3D3B0dHyOAZiW
 A/C3K9MVl3wVPsnX5dRQUNTEZfVxvPi3GgG7qjrR3Y6NsG1GcgZmMKr6TQr5jB7h59TetvD3BoP
 Iw4XEMGcbGg7Xm1oFZt1GBZX+MZ1+SwFichlr9hb+e8EhEvYsp3NazG7YhfWbufM+lh7zyvZkha
 8X/idaC67WDGYMRiZHenypjdmxRprG1Zfj20tC89qdUQFG1J/YTmYB2puVAsgEIeUZZR2DBwZ7V
 sMKcjMXgjQPUeVkiO+ZH+pWyQ5x3foaR36yTTy6169XrnJFmDl09Xnczf1gvkXBiPUqFqLtcxDi
 PqwVlc32fSASeJHTtMJ3pjvw9ZW5y9utjosWNoQqaIiRRg68M74=
X-Proofpoint-GUID: jhmtuSW5smxh7WRK_cR-QnbkK8_lMCpT
X-Proofpoint-ORIG-GUID: jhmtuSW5smxh7WRK_cR-QnbkK8_lMCpT
X-Authority-Analysis: v=2.4 cv=KKpXzVFo c=1 sm=1 tr=0 ts=6927efee b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=pGLkceISAAAA:8 a=Ikd4Dj_1AAAA:8 a=mjD1dZybrLEv6ISYaREA:9 a=CjuIK1q_8ugA:10
 cc=ntf awl=host:12099
X-Rspam-User: 
X-Rspamd-Queue-Id: 9CEEF40018
X-Rspamd-Server: rspam11
X-Stat-Signature: 98yd74xf8s7sjoh5t5e949u15zpadh1c
X-HE-Tag: 1764225014-638027
X-HE-Meta: U2FsdGVkX18I5nXqD0Dz9mf7hzHDwhzGUkBgRdGqwVFbj6fsK8cH3+R5BI9IvBGqfeMRRPnTFNpMqmShlzNgKTXLr/VZYpTFa5revELSChUSTzV/95EVht4y9F7VmnIL/znxANYLJckYL7PyjqliBDHPLlrnBV0XbFQk4KwzIJCasTYL+FUBmFFAloz8uz4kCw0fmIeL18DY/dCVbH+NDnDGGRhfFtV4lnE1XweyCf+fAiKr0UtVbGsQ65QY5LgESJMDxduUKL2lHo5V+FRqbZklCDRyVZ3XvDWx83gjtSiM3OXGjA8g9Q9wpqyvGStccazueVxEE/dfUP8Q8O196qM8m71xnOUKPwEloAPgyJ1s1g9H5FeVSmimur/UoCzxYwT+DFt4ujSFlzkz56SSoboFvt7WkxR9yuYNGhGflSrQaTWN/ckFAel6CftpSk4Yr2XTbQJqLUQJAB8kTVgRY/QvxT3vfAsoxnrWQqaexY2hT8AwWBxi2RNiNlolJ289JGZWddxsyEjL2vSovEStOZPtFFYnQLCsmnp4ZCfiDyUdUcI/DljMrN75scdgUzjFw3qTX8NQRA7FI7i7nN9Qa9g/k7GgqLP0wSRZkjj1KONh3bWZH12iJgduWVrCKWLA/FIqqdmbEcpimXnMZW1vGLhiXxsSIvQLFuBJxpvXuYOfs5YVJFPx9C/bgpSpGdWz1Mu6E/4Px/UnM3NiFqiQec0foT+L8kFLXg3MgyB3zUdm1Oh/vu4ERFyw6oNwhaREwnK41o0kZA9lykgTlLKmwjUHE9inm3TWp4wAFogs5V4Jb/pdFQYRRv30SYdDxyoWr0ItUTDYyLuVoumxbjScIQQBPo/xmuLdAtxl77k0hxW8jTmm8xG+XSXzyggkEEKteR3WQVJ9v30R1VfHUEnNsJ1jzm63vo1innlHhMXQG61BPGRXiv3v93qeTdr4/5ehO+O+hOVuCNo3VSmn8Il
 dpXqLkpK
 Q8Si5DfnS+HKqDMxop3WfHmfM3F0Fl19gFfVR4WYWtktdd7pk5j/AwOXvVtFqFev8so+j2Tt4yah/25295+ZNYjZNjNGkIOln56VnepKedwffFK0GmT+zWsl59MDNib9mj9ajHedlPgWbir/lQyCDwAGCBtJTVACo1Rwo2vWKzwau1e6M1CCzJ576p0vBDyLh8zDlq/mmY030tblUr7/HBli+yWmKATqh7mCqNFgZM74IQcclWASeg1IaUcAjNpkp9K1i6kjJtc2Dac3r34/4fPQfYmURtmB0Cwqc6Ec/MFND/oRRX/x88zuH7RVOhUPtybdbbiG8WZU8Kc/HDkmjABjrcSAjKqZnp5Gq32kzAXeSDuixji/s5yz3aGIFkW0x9LWOB6+4zftVWGbRfbmN+S9VS2PR8G6kNw303mQbF6ROSpDr2WBeQwbK350ammeyMp94HzuUaJZLfdAMAO5iK/6UuNSKJa1lilCq6IlO4UjgS86x5+ZmsWNDDviZX5hMQPE6bn4HR476y9WvRT+CeICyNcKAE9RjaZNqnWovEvapi5p6hvZIxGSvBqwkGH1LR48x88tllKmg6q0GWQeqEvLOSiwx2umfuc0EXHb03UdV2qOZ72dUNXWsw+MiBWpvaZg2Z0YmOW7OcrEyJOy2gqRa5kjnOdTPc1Ze9w2HuUkWbfmjubtrhfEHMnZ3iYXRzi8n6lDvKRaVNyYlzMjd8fTvecoz2jLXj1mgRGwPjGcDPRrUMXEw32yo69esBM+bzEzPltmXGeNRBCRojjfnxE8VmbJ9G2xNYqQH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sorry Wei,

I know this is small, but can we not be doing these kinds of fiddly patches late
in -rc7 please?

Thanks, Lorenzo

On Thu, Nov 27, 2025 at 02:24:36AM +0000, Wei Yang wrote:
> After splitting a large folio, it is necessary to remap the resulting
> anonymous folios.
>
> The current implementation determines the end of the remapping process
> by counting the number of pages that have been processed.
>
> Since the final folio in the sequence, end_folio, is already known and
> tracked, this commit refactors the remapping loop to leverage end_folio
> as the termination marker.
>
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: Zi Yan <ziy@nvidia.com>
> ---
>  mm/huge_memory.c | 14 ++++----------
>  1 file changed, 4 insertions(+), 10 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 553bfa961fce..afc7b2f91e99 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3414,20 +3414,14 @@ bool unmap_huge_pmd_locked(struct vm_area_struct *vma, unsigned long addr,
>  	return __discard_anon_folio_pmd_locked(vma, addr, pmdp, folio);
>  }
>
> -static void remap_page(struct folio *folio, unsigned long nr, int flags)
> +static void remap_page(struct folio *folio, struct folio *end_folio, int flags)
>  {
> -	int i = 0;
> -
>  	/* If unmap_folio() uses try_to_migrate() on file, remove this check */
>  	if (!folio_test_anon(folio))
>  		return;
> -	for (;;) {
> +	do {
>  		remove_migration_ptes(folio, folio, RMP_LOCKED | flags);
> -		i += folio_nr_pages(folio);
> -		if (i >= nr)
> -			break;
> -		folio = folio_next(folio);
> -	}
> +	} while ((folio = folio_next(folio)) != end_folio);
>  }
>
>  static void lru_add_split_folio(struct folio *folio, struct folio *new_folio,
> @@ -4066,7 +4060,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>  	if (!ret && is_anon && !folio_is_device_private(folio))
>  		remap_flags = RMP_USE_SHARED_ZEROPAGE;
>
> -	remap_page(folio, 1 << old_order, remap_flags);
> +	remap_page(folio, end_folio, remap_flags);
>
>  	/*
>  	 * Unlock all after-split folios except the one containing
> --
> 2.34.1
>
>

