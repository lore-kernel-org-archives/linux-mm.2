Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7C54CF64A2
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 07:51:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 292406B0007; Thu, 20 Nov 2025 02:51:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 242DC6B000A; Thu, 20 Nov 2025 02:51:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1319E6B0028; Thu, 20 Nov 2025 02:51:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 039886B0007
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 02:51:38 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8AFE24EBB9
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 07:51:35 +0000 (UTC)
X-FDA: 84130215750.27.2863E92
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf13.hostedemail.com (Postfix) with ESMTP id 21DCA20002
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 07:51:31 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=PVmoCYA7;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=svNMYE7f;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763625092;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RKCDVxXmrz1nGNjtZtxLR8PpEz3YrhFLKWng2utnLvw=;
	b=dvugp+y+gxEYnaXa7+SR5K9n8zRQ5vSs9/ww93iaRt/ov3Wzq/6c5leuYxCfNgNLjar8eL
	2647awOW4LaidtEEdhJvMAT3y2J3Y7ANrXsgUWGQz8Q7XtDVdEjW6G5T+IC7qzfMxmQNQs
	nZ/C8PdDeOeQOPYwjmebvGb5PCDkU30=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763625092; a=rsa-sha256;
	cv=pass;
	b=JqCcKKm3H5JV+AcU+6YjkOQSZ9Jok3MFpR/tMVEKig1xvPSq+Yh03xuzHMCOCH9YzhJhXr
	9AsnJ2SQPi7FYiS2CdHyrGmCqc48vWxyXWxvClEqBa5RY+BWRLmCWJwg8sEEtgkN6YN0YS
	NOKUPjddDcsvMzZemv+K4Cq+CIqmLgM=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=PVmoCYA7;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=svNMYE7f;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AK1NbOG006985;
	Thu, 20 Nov 2025 07:51:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=RKCDVxXmrz1nGNjtZt
	xLR8PpEz3YrhFLKWng2utnLvw=; b=PVmoCYA7pAtqMgRZLOgG2XZaxJe7BF72sP
	q/Z3ZEa+UVbeng7IusVdbZjyssG2R4EZX0C0x4Y5TfbZG07omvMNC++E5GM8UqWz
	hPjNx/P4NZwuP2vzYupriP3VPZBZXsMt3izwI0sSPixiQTrquWS+COHQdYhbpqUA
	iFsqK/UV0MvNmDJP0sddRWtXgPfetPT7YeUF6y0VPGhTMEmjhG3eOIGHHZKmvADB
	Fk/ZpqjfNEej8NPveH9nxIv/Icz6sXPMSnAazs3ZzNotgDh0oWLnOtRV17W1NrZp
	kMKtegKFaZm9+ZW7qXqsyh2eJrkT/+g0PzFChrJ15rXMTfICQhVA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aejd1gh6g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Nov 2025 07:51:14 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AK5wMb2035914;
	Thu, 20 Nov 2025 07:51:13 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011042.outbound.protection.outlook.com [40.107.208.42])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4aefyp03q2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Nov 2025 07:51:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L1kfulvnWX9I+sAwNOJ+tZGif2LvQsNEDUwLedmMwpyvuBwMxEAxunMfBlkGbZ+rav/qBZ1q8ny14hgs2R16amskjCkqcUwnL/iS4ol6t2ILnO1+6pXxAzxopj0AuN05j+TTupeo48m9VOCWmibv9Em6Lvm0GOIKc3jw9b8noWy5yk37BxyR8JAHWbRegFBqNNoI9lqo8Ur9rJkdKc8rnhvce8sHM34Hybdh7erTa0XAumQOEbzeDgGzW86hO7c82gM7xe/wMdTyBvo7OPbFzSi7XZzCNYmA6RWqN6x95y0/5hAEzC2ZIDpJE7Jw/hEDAFLwKGb/Xz6mNdfa0fl2AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RKCDVxXmrz1nGNjtZtxLR8PpEz3YrhFLKWng2utnLvw=;
 b=jDIFy+XQywErgqObZHCx+gFKSUqNqswDIil4/vL0aUG5jbbJt04UzEDq/boyJLevHdWF3M9JzBbybp1W1BqIWdvooHIV3MrFF8gLnINwTMsiyng7c03OxNqmk9SPeetSr75zD51eOYQuDKrmcSxer7qXT5G6wumweJkOqtRMDZzSlM75EIgqpzV3PlqopdxoXXojOQuCZrT2JkmwVvJ0V9n81d7U3FenuoBOs11b+zLBKz0KK6wBPC1Vwj+mcnY1ulWLrzs3iImixi+GlfsZeW5N7PUTN1I19ChlCKwW7K6YccYyIr1vXOUG2wxCA7nAjGNoSDmnRh42Ju7Bd6aG7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RKCDVxXmrz1nGNjtZtxLR8PpEz3YrhFLKWng2utnLvw=;
 b=svNMYE7f7DShpTLSNdNOXl5XKqrZsQqZ6EeruGvaqI6eQCHFGgOWMRJTRdJDMcphUh0L1bqiHukv10EjRqiv80GfNVA4TAt/MZ3rTuPfBtP8Qj2VkQ1XgdkkKhYoQrUzN530mCns8bPaTlcReRfiqt4nfYCEnOh17TW1M/4HxAA=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by IA1PR10MB7262.namprd10.prod.outlook.com (2603:10b6:208:3f8::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Thu, 20 Nov
 2025 07:51:08 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%5]) with mapi id 15.20.9320.021; Thu, 20 Nov 2025
 07:51:08 +0000
Date: Thu, 20 Nov 2025 16:51:00 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
        roman.gushchin@linux.dev, shakeel.butt@linux.dev,
        muchun.song@linux.dev, david@redhat.com, lorenzo.stoakes@oracle.com,
        ziy@nvidia.com, imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
        axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Muchun Song <songmuchun@bytedance.com>,
        Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v1 14/26] mm: memcontrol: prevent memory cgroup release
 in mem_cgroup_swap_full()
Message-ID: <aR7IZErOGbKNJsrr@hyeyoo>
References: <cover.1761658310.git.zhengqi.arch@bytedance.com>
 <1593e9efc2de666e9f7e7659d5c61d2ccdd17a8d.1761658310.git.zhengqi.arch@bytedance.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1593e9efc2de666e9f7e7659d5c61d2ccdd17a8d.1761658310.git.zhengqi.arch@bytedance.com>
X-ClientProxiedBy: SE2P216CA0145.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c8::13) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|IA1PR10MB7262:EE_
X-MS-Office365-Filtering-Correlation-Id: f1502291-f1b2-4b5b-6600-08de280990c3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?UtAClsVP8Td7pf/sWit9PHhsvyu0k65NXTRRnMo9xskavKYh56DqLyGHMJe1?=
 =?us-ascii?Q?K4Vv7t0YrWKuc70OqGCjglQBaI+DxO5csv+hRc4Ieuv9+aloDxO0Am9zHdkq?=
 =?us-ascii?Q?CutuBLsGCuSErqjAAjpkxm/oCYi7p4sEQAbix27TY4katC2zaxrXQBsFV6v3?=
 =?us-ascii?Q?o3JHADnDbWhmWe5Lpj5KLw+4LgRKg9Dq/hQeBfEKbHJ6lwI9C/b4bZT2Khc6?=
 =?us-ascii?Q?LFHyyhNNp27P3IpuVCJrOf0QklXQxVJ/UrqRd2xO05/D6hnozB4e3FmcayEn?=
 =?us-ascii?Q?8kDxEHOvzqmYceRIlqyLpc5I/rdslkxYAhsqidzmOfkljYHW/qP/n2BDETX5?=
 =?us-ascii?Q?ITMAhXkkaDcb6XW1B03DVf0Y3kuPiocCvAvopE+/R9V9x/byP0vgPS5Eiz20?=
 =?us-ascii?Q?gNY+XqF+l8kYjFBo6jdSfcBLrZz0DFhBXnuGUZYSD6Pm/039OlK2qUi4QYsz?=
 =?us-ascii?Q?g30mP8THj+lm7wAZn4WvKX5gtuMzzddlqPur65eTKSgiJssqDN3S8lK7Hd7/?=
 =?us-ascii?Q?XTvjq85l8pc9WRRYK1CbVPrhZvE5Cwh4nQOkQJlenIV0LvgwnUt1BR1AnJfi?=
 =?us-ascii?Q?Meifxt42TdHGIRNoKhkoW8fJ3Hy9dX8obnxfrMnPFyqICkolN94Bf3XxpOpd?=
 =?us-ascii?Q?LhJci4DHiJzXK1juuSHDvZnBtydu1yeH4v3sJUMgCY6Dzdp5yTUwayHeeddv?=
 =?us-ascii?Q?D0LFHuOnfirj80NfFO3zBZ5VUjaXLM5PK8aE5ff+dedLZ0S4VfZLYxTNZT6y?=
 =?us-ascii?Q?H762B5Ir7RQpS4+7wndbPGytkwjUl0QrSyRFDrX3XOEOlIBoKXchVU3WHdzt?=
 =?us-ascii?Q?pkyt0aLL2JmQAHghaGed1sDFIy/4URWNk/vKV4kPcDHrpyfReKzA66N4TlQY?=
 =?us-ascii?Q?FrF09Ww9D6jHx0DsV5XnDmFMl7Wls2OsIZbDRRz41OdST5DIOqUcB0w+Dm+A?=
 =?us-ascii?Q?CkT/zAIZRbT6YC76GgxLugfYOeAs9qMVuLiX8fcgn9Ncqt47RBRR/C4pLBca?=
 =?us-ascii?Q?lGsNDWFo6/CHzv7ErliUP9FZynYvbV+xB549gVa0htyCZom8PJwgFktnjn8z?=
 =?us-ascii?Q?4JiE1qYtXyXjI7kgkeViHCsWasR8OSTWtF+nTL6lXxg5v+do3A7iOiF9mL+s?=
 =?us-ascii?Q?OEaj1cFrCqToP/5aZExAud/EFu8ymj1okNFxLetO/1LGT4zuUnxc0e4dEnsS?=
 =?us-ascii?Q?xRnvWUJuebysom73L6+EtlbBIZ8OBQkmJzeDZg8y15pBmeSlc49C4znSvIKz?=
 =?us-ascii?Q?7wx3X5L1ufG3T+FCBO07xe/wtXz5KQh0b+BitRqo+gND5OWdWsp8dOQD80Rv?=
 =?us-ascii?Q?4JWEkHVYW+In+ZgUeOD4pBYyFjr9zOpbYqhKRTSC7tgS5sGW9iq+rgLfDrnF?=
 =?us-ascii?Q?oNfcCQSxjG7QctQhZDRqN/aqqsNJk6uU+WPmdCXDWboiEN3wNSf7W3cJz4V0?=
 =?us-ascii?Q?dpkAWQdbyOgJsZaPf4vIxzfPEwiHTlbo?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0ZYusda0C+nvIW5a8N2NnVg1zjI4Bu+L/ltc5/jVu6oMf7YxY8J8poSJPygP?=
 =?us-ascii?Q?qHtlexdHbHOdR6Udh2ulaJ02aQxAav/uOmTNu88FKltmgr0VUML3VzFeHbbT?=
 =?us-ascii?Q?PyCsvShYAg5QZFzCOv3kE0n7F8n7sTCE3M4YNaPUvuG7x7W4sZNbA5VqoOka?=
 =?us-ascii?Q?tXu6BEquvgshHUbRcw2wGStePxYmoDEQNYC7rXhjBfdGnmEM56jSCu9R/9zi?=
 =?us-ascii?Q?//6ZbdRklgTNzuyPFJrusJrOg4cHrxKU+37OYhuXXFGoIIlsSb4ZiztCX5hk?=
 =?us-ascii?Q?XpvVpHtOeIPAVCFQTk+kJxMEcEKwMZNEiB3QVM08wItkYGBUXQlbRDAYDHKV?=
 =?us-ascii?Q?cusyxmJqzOiHWsRi2WeNTxFwCJbmm27LPa2/++b7iCJXrBWTsyt2mcEJ/JvD?=
 =?us-ascii?Q?oVqUV1Tvn5s3cs1ZDY8iWgIo+tp5goLPqUHiIzB2rp0H1Uh7Q6/RSAqsK2j7?=
 =?us-ascii?Q?A401jcuQ8WTd7UR7yZpVxNwEH37cKfV7Nl5ypCLmDIc7k1dAdlssRM6+EAmK?=
 =?us-ascii?Q?XeZ8uq+FLtgXpgfwpxAQ2wQMCab18Mp2Rv7+neBFPMbkZMd/24EWftrWuASU?=
 =?us-ascii?Q?JONdgF9QjhrFiAc2YZAOCUMBbfZMwBMT10NJwAN5S8amTEIpiV7yr5Qr6EOY?=
 =?us-ascii?Q?dQRjjoJlMrclQRLRAjVxMfVe/Xk60dZXH3pZ6yz+Glftt0QrkAMWWl3p21ub?=
 =?us-ascii?Q?0RiUXW6YTVgGfZ3be0WDUaE4oJ1RIxx29oNmKN/ZALmzFWbGI9ZeQE8jFC/w?=
 =?us-ascii?Q?+/J/8O4cNJNw3/DyW/gxDwUg8yT5D6nGAB/A3M1BCDp3T9D9pOvU5POruvpc?=
 =?us-ascii?Q?x/vQ0EIRc14jb00JznT2pBtcJIHyRfzpMqVARfKK4CfgM7JuYK0ZXUh7yKMV?=
 =?us-ascii?Q?6iKDn+pANDiykMehLdu4K+Hx5kOZVsEy9q6xG7O1UsI1Xo/ygqiOOcRxJ+gI?=
 =?us-ascii?Q?EHBGxzB6QyoePo01AIsRuQ1Swo+PeDVbOqkKfEdGWFSGOUl3QmpqxRGxVX3F?=
 =?us-ascii?Q?h1AGzWCxKgxzPYS+00VIs6opHkXmlDeTIUy/mQ2EnLD1BklBQPmvC7ISWCQJ?=
 =?us-ascii?Q?mN8roFCne+y2SHkDiLiHs+OLeilY/eAecx1Qq2//iIjt5s1nRuLLfzsOa+Zm?=
 =?us-ascii?Q?hXcexmDeuipPPIzqA8+IRF5E6j0YWbSKHAYD6wVrtT3gQfVcZtqHL0U8kFjK?=
 =?us-ascii?Q?ZG3b476jhtRX53gdxeaGM2Ux4rOYKTIqDlgAPFBZ4anorWVoSTRKVUSsVtPI?=
 =?us-ascii?Q?8dTCgk1VdcOstgH/RqCH/uSVWjRSfSuSTWcizIxiLrHVbTC8mrIOj9vcLMi5?=
 =?us-ascii?Q?Q3fW+3NZ6SwxnTTNcs6za683067mBeT7r42FMLJ03wyLLhIoy4MKENvxQJxe?=
 =?us-ascii?Q?9FBjM2xX5vYZCPLpkxPJc+pegSxsoZHaypI4HOAuav+QGpTEIHsHNJL4FG1t?=
 =?us-ascii?Q?z1zL3nsQF/mZ+SQ/yYZHL0C7n/5iKMAWDTYBkiNfOmrUFy+xMLeCDa751uVU?=
 =?us-ascii?Q?VlEEqQB3ffBN6hVC3ODGn4Klve73Xvppq7tFL/UdDPO/G9s1uxXFYHUxAb11?=
 =?us-ascii?Q?QlG1/wNSbmOQI9pxpEvP6in3kVjmZdHoZCRzpiZI?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	PVxeauzXbG5jvdVe7bz9/qYJYk1Gm6KVmuDnhQ/74jgf41xmmlbnFDEP4XzEHS4iS/Z8kEmUawJ4ngGs4rMWpsbL05z7Jj0op24bcVVTj0vR4cJp8wt0n74az1cnBK454rMVt8bZnf87PzV6pN03ZUcFZ7sSVmpuzZx20drs8O15RZBnqwDokVqgpsmeCaPOM9Q+iIRhUDRs1wxuRPXzMIXobUZwAnf3ro/LHgXzdTK2U7oljXFwGliKqw5XIzOtc1QLnHwODqZwFK/Y0NcWLVXCjhpN5xyWvmL2p0aa8wFwFX4kF5qzlIsbo2Dv+aYSCKAOqri0PLUSoDLhLn0CkrK4+df31RoCQa7JwnTaPyMh9ruCroRjzFvF4rU6vtwvG4cVp7jGSCdcjsGPzUoTtcvBEWfxIKb9aiLQSr3kPKfCi8A6QlCp0fZlzQ0cOqW1LQKaXCBZxyN5/sMaY/cSyLzLl6okaPyh0lT9OFsS65Qee2/mBDyXdTFMfvN0EGwCLghe6ma4944JIXYO7t/qhETWMR7zWYHPhh4eJGS/KyTTHO/7v87IULzjOICN/I4ARJXnlsfIb/sz/FbIlIGyU9YodXKcUKWNgTduRCi4XbE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1502291-f1b2-4b5b-6600-08de280990c3
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2025 07:51:08.3406
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NgaHElsT5A9BZB8YgqkkMhgP78WuOL61QTUf9Jp9C1LfTCxix8nFqEED1lSJMGJKPLXLM7e6ttNMzju2BhEt/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7262
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-20_02,2025-11-18_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 bulkscore=0
 mlxlogscore=969 phishscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511200045
X-Proofpoint-GUID: ACyW2GoIHdA_2wUE3cXHCfwtW4j0dY48
X-Authority-Analysis: v=2.4 cv=Z/jh3XRA c=1 sm=1 tr=0 ts=691ec872 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=968KyxNXAAAA:8 a=yPCof4ZbAAAA:8 a=WKiVBPBMbvKHMXwaU68A:9 a=CjuIK1q_8ugA:10
 a=ZXulRonScM0A:10 cc=ntf awl=host:12098
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMSBTYWx0ZWRfXzDQSIA4n0wCr
 Ksp7gJQUNa+tYBBHSHBGgK74SvR7UxDezdlPxgplAiGS+tojyMHcLv+2owP9XrDyGGU4MA4s0M3
 +5INvA5D9OWSzKuTlHqrM/8pHZYNwm5VPLBfKwq0FfEZoQnmrvV6ItI87SnkANFw3SMiaTUvLOY
 e2c7EadQ7IZWqpx4mZ6uape5I0fppVscha9TOn+S68tuPwVbhs/y5t+4LV/vR/fSRmTzxvKYf8v
 lDgGUKCD39y7Ka2OZkzwJ0O1S+lDxbU5aMgLoCbIkQh+1hPfGZ5Op1U2tNlXMr3hsIm0dGfqRsT
 0Y7r8gV3eZVL+fRg6kE3Az23W1c8y/A+VY9C3Dkyx2O98rpzLgtKUxMPcSzLQnlF8EbIy49RWEt
 6tczlKEtSZmULxGLdR3NgcYBv2JeZeXAZ+COigS6SGZ+95zlnVA=
X-Proofpoint-ORIG-GUID: ACyW2GoIHdA_2wUE3cXHCfwtW4j0dY48
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 21DCA20002
X-Stat-Signature: mf8sfir57uqgx6a8jzfqs4mun7d5u98i
X-Rspam-User: 
X-HE-Tag: 1763625091-26898
X-HE-Meta: U2FsdGVkX19SAJIdsCia32gpf9wtiFhc1zP+0DanFOmAhali2CNMCLvVSzN5xEnViN5MdZL5rkjKYCjUuPDNsPYE03jwmopwuHuXYOR3Yt3O4mMWhrI6YZMZtnPK1oyU6JRBuPo62Hd+qItBvHNO+h2GyLAQoIMObY7vD90WkWu5OfxHtYmU0Ck52JgYAd3zZ/UHvyHFVZoh8VOb/4fXf+IOGTest7FvnH2kCR6z0si/c4M6LtmM0SkHRU1vRmW/peUARjz1A3kZbY1f55Se1y7JE0JPJdKcz/wifRDucItrFkiMVgYbDl5x8WPVtAx7RiCntIv96sBalScv2d5JptcJAo58yBby9ANxnj3f/mm6/FyZaUi2FILQ4t6ay37UcNW+DVNOxd8naeNZH9Jnxmm43mijDZQtJYP4ui8BEzPVXla1KPGFK+JxmYbWOdHj4GxivwD7rwD601NdFU9dIWR4kXY56erDb7QrGd00kfkTvzqkXPRvgEOJaizBqWmVJSgw1Jt+6V0KL4vA/h5niS7aL514e8ZOYDmu/NMyKGVG2SXsDdDjHl1SC5ce248yxSUDR7+z8RXQQdDEHKkLyPaTXXv3kzmndNuWp8UHYR0chEuYEPpMVg9UKE8jBQiW1Yy880ohPbzaPEWqrhkvoz+b55txPnKb41E6+2iruT8RAKqKBR26ao1AtKOzyJvMRp8AeKYuouHzP0Q9EnkfQbPMQdnsuqiMVoTOV3LagghRDl+VWx1zIaV8jg+S/vGpjGXHTi/kePeuJ4aSChwXuadq+D+TSArhe/KsFo/XKR3LbTtJ2HXHHPQ6DmYusKD9jNELThNX/vRQiEumOIHknQU5xA1g3Tk/h67swoP0HvRekldvTuI+zvm6bHQbL0ZORDGYjbtmub0smf6CFyYQe+nfSKcl9PTyEZ4Mn8MXF2ggUJBtBTMD3QLvv/bMkWsAl5E1/8vqIodNWMtS38S
 sPLSGdOv
 o45ThTD1C3RIICu35w03PZyTMsLd7C9/RtPKhfmlC7VJkdyt8IoYJVrHaxTbKqQCUk3CHcAFBaSVpHEZaUuqwjMfG2T09B82hvpXyV3hFeLfba64eDstGLxwYimlUgTQrycwDZ366QlKFjEMtIr5f159PAa8KrphbFS5BxlDqYjaXCcOn+0nBWy8fTldt0gOD7kwTf+dEmbipt4RlUmgmqnZmnI6EB1LsLOZT1dvk6Ol8Uef6yu2eCyyhhA8BNJuUFWpLkdI+ul7TKmhQ5gaCbBrY1ROHmRCOd0czfh89G+epSWgPwBDftQrDugw7mqvyN710y8XslE+zrZqVF+9uiQ/1NWOA7iqpWz4FXsGYvu8g0SeDsf/MTCM2J+HUhZTSoRekehagdhN/9jCdiYKxq8LKCLWX9WGBiHqh38GuGalXEGAzka7dBcJ1AQ6sILn8OZ7ZxAw9Mt0kDW3r2rEBSLQsjmFDRmzUp7R+3mwt/Qa+Uc/ev7ALKPNvNn4YufD6uhbLZhBbZiMl7jj/GGzPRG75Xp4src8SM67SQWpRVNlsFshEGk+aOHfhmkhy6QVyldacFwbkGRNzfrfn5nfXlcYq3fpY4kWYZPTQDidRopyDBueiqX/aIC0HvPZYIKJKIftzvwJWoAZ1bjXUWOAC3vKgLNXF12DsGSYShWa5ULVKIvYqqy1csYXBvdIEq2/17LEL9FYvbJ87g/IgcVWVRlRyLi7pkWya4fU54NOTOLzOPRkQdHAcuVYopdJXwgpDeVtWLF+ycSC0AZ9dkpOW51bY0w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 28, 2025 at 09:58:27PM +0800, Qi Zheng wrote:
> From: Muchun Song <songmuchun@bytedance.com>
> 
> In the near future, a folio will no longer pin its corresponding
> memory cgroup. To ensure safety, it will only be appropriate to
> hold the rcu read lock or acquire a reference to the memory cgroup
> returned by folio_memcg(), thereby preventing it from being released.
> 
> In the current patch, the rcu read lock is employed to safeguard
> against the release of the memory cgroup in mem_cgroup_swap_full().
> 
> This serves as a preparatory measure for the reparenting of the
> LRU pages.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> ---

Looks good to me,
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

-- 
Cheers,
Harry / Hyeonggon

