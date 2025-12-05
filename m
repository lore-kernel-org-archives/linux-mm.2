Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED019D339BB
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 19:19:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43E8C6B02B6; Fri,  5 Dec 2025 14:19:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 415216B02B7; Fri,  5 Dec 2025 14:19:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DD5C6B02B8; Fri,  5 Dec 2025 14:19:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1A4796B02B6
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 14:19:10 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CBB3D12CEE
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 19:19:09 +0000 (UTC)
X-FDA: 84186380418.11.7346F99
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7BF7316001A
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 19:19:06 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=bP4t0tOD;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=zH1qCkpX;
	spf=pass (imf08.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764962346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L5HySNwNjo+yDIavPl9jR+mxF4ctkxTELY9ODNNdC/8=;
	b=6nUfnefykdTO+1IDn7nJgC24JFaPALwKsEmru8BqAU8lfqxF0P1WUaninNgSLjJJWXe9VT
	3S31WYpFC9TKu5rNO/zvOTLAClByQuA9Qz6UC+bYltXecKRgmR99/3GgGaL+kacvVU69Lg
	K9v3XSLM9lxeOh6s81sqz25NaTM9bs0=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=bP4t0tOD;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=zH1qCkpX;
	spf=pass (imf08.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764962346; a=rsa-sha256;
	cv=pass;
	b=Q5euFa71rUCMUDfLYvcTzT4y4Zl+rDUDkaquZZxOXwNCRZuCu2klXycUVkIrc+tOpe3Aht
	6vhvF6apUnDL3dTHgel8z9Rs4DWImkB+xe6xq0/RtdSF+JT5HSJrA0gogFBgaB8AeNw8St
	ndP/5ZbO2H+jELgIdFfsDMY2yzGIhc8=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B5J5o5H375484;
	Fri, 5 Dec 2025 19:19:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=L5HySNwNjo+yDIavPl
	9jR+mxF4ctkxTELY9ODNNdC/8=; b=bP4t0tODKZOsgmW9LffheNmv21jlwheTZ0
	WY6uF9m8C//cqi7/RX9QDZdmoAkHBmszzgdaVAkiu0zsVOwv4n+I7+JTlcmonLLa
	9mUzhg4FUm7Guw6sm76hkLY/vHayTxokztEw6hZfbUzd5acJ3MAZ8Hdp5zgCx8+a
	bOpsbrMlBo+oX6J//bexiwmcAj14CRv/UkcdqLO4nDilKjnWdwlj5wlTurLKPk6d
	/3ylUamUdtCst2l0wYnk9pxHZo39hjio9mrsXRQzYHBytPfWh+GqaGKTmlwc67pG
	K0Z8l6Nj4BXU6rV0TlObNdJug0aiReX3VSqTTi5ydukjqhZXiEoQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4av58h80nn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Dec 2025 19:19:01 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5B5J30Or040121;
	Fri, 5 Dec 2025 19:18:59 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010049.outbound.protection.outlook.com [52.101.56.49])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4aus9f9wsh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Dec 2025 19:18:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hjTSrsqJc+1jf2fGdNC4W/FgHL0PEiIGB7EQzj+ja7wnXtZ+04/g0qMYNYWrdTFbobetvIcJwoBh//m3Mmnq+Yv0JctuNJ7cBY/uxfZQoOvUuvwqdc55m7GDdvRfTDASYFIVAvEJDb8wyoyd+mB2d3/jTieJYEqT5hGqr2Xustr4bMvnXgnw73nDB7alWftv6KLgzxaplDAK/iESNxjxEsoKTJ/ONvIn/COysTdkC0BOLQbmLidRPSZqFrMg1jG6h9Vs0vX+ub36aOwUNzD1iN4n5id3fO0Yt9F0RINVLyOVPpwzlzukVl/adRlsPf1v3WyMg28fYbbnLsqLrmC7CA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L5HySNwNjo+yDIavPl9jR+mxF4ctkxTELY9ODNNdC/8=;
 b=GmJ8KaHhMf9cH1Av+AqzkbjW12fzSzlJrO8yv9bIdc7f9OBlnFDac6aztzORhJTbNrZl/5LtdbozF/Paql+T1Uh1xjqLdLYUcflBVaBQF1hS8zN0CnLW3T14RCR2M8y43iJlwdYhSKaOVRExH1G7twmUds+7SYHWYEU5ZpSNT0J3cfFrDRu6dulBAgFuXiQIb71KroWNL8qiuFyiRAQh2Wf3KAaqwjnr8WdA6Pm2p5JJ2StBDNQHV2zkQGb/kN9IazeNO3vILQd0fd8+8gevdMK0mmRYgddVpbst78Mwb3ix4VUl8hAx9Kd+iBLNOCUfkHoPW2AlpZ9pcVn/Ds0/bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L5HySNwNjo+yDIavPl9jR+mxF4ctkxTELY9ODNNdC/8=;
 b=zH1qCkpXBLYquAWcuofPYetjIp36vquyvQZ2lBM6YHUtqROh2midWzcbKxtX+b6A+DNDQ/8EcZA7WmFV2bHlbUT5P2Dj8eJvjEdGzoY+4YL4GuchQf/e2BUQ3JhvHwWaS5XB/7jhGMB/ybe551Wyr+wYQU+lYwXBx1mvdDwBDPI=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by SA1PR10MB5886.namprd10.prod.outlook.com (2603:10b6:806:232::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.9; Fri, 5 Dec
 2025 19:18:57 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9388.003; Fri, 5 Dec 2025
 19:18:57 +0000
Date: Fri, 5 Dec 2025 19:18:56 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Laight <david.laight.linux@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        oliver.sang@intel.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: avoid use of BIT() macro for initialising VMA flags
Message-ID: <4eea9138-3853-457d-9113-e3caa7f00437@lucifer.local>
References: <20251205175037.1287366-1-lorenzo.stoakes@oracle.com>
 <20251205184342.2cfcc73e@pumpkin>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251205184342.2cfcc73e@pumpkin>
X-ClientProxiedBy: LO4P123CA0233.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a6::22) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|SA1PR10MB5886:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f219775-91f2-4931-1868-08de34332315
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|7416014|10070799003;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4Z8DRMlnyVBOjokC9Y4/YVkdEJQlsQP0weA1RTGJPQi270vGiqgI1E1CoPZa?=
 =?us-ascii?Q?/xc2nvV9U6CWUXxHHnwK0ZXh/gMbnkFHYuYrkw1SizXx8Gjxf3wKlT3Zo3pF?=
 =?us-ascii?Q?S644DmwYlekAOE+BrOLXhoZKZJ48mvMVMcX5qnK+j1CNU2VtCMfwnRSYPgWp?=
 =?us-ascii?Q?MR+2rbmbcW2vKFlp6xaCPeRPga9UvsKFxuXZyw2U1upvaEDD7Gbj9/efbxgk?=
 =?us-ascii?Q?XdIqKJ6h7qtWePzE2XPh8s9Etb7owH5nxCy8qqaIzvSAuk3PUxGo7cFDYZWF?=
 =?us-ascii?Q?3Qx5yeVuiZfuGZs7ZZ9liiuWyIJoOrhukMMOfcNXnAVxhfvYC2awraZvDcwP?=
 =?us-ascii?Q?A+DK9Idp8gpnkZK2Ndfg4S0U217TzE6N1mqdPv8CGGu6SsINnQeFZCmQHJCP?=
 =?us-ascii?Q?VjJJJg7aNyedmnxEqIb+RlOkgnewHrDZ6dzamy9Se3aekAG2ViIwx1V3rC6D?=
 =?us-ascii?Q?r2JHECj05jPDHoM7XXVQLbHLFRfwkwpnsssQLXo8f+GaJCPANqP7o3toenQ+?=
 =?us-ascii?Q?QI0tvIgzhLyJVA0k8GC8bN+I2Cfhq0pQY2Mg7fPaeF+3IlaIVcukx8muHFfo?=
 =?us-ascii?Q?PIASGBgpm55EKkNwyNnQAMoUTH7RwxbDb9ftxmoB1Kvaw1SOIFd2oyIuF65g?=
 =?us-ascii?Q?gqSEQSUn0xZzrD2sB+uCt0Nb7++9hBtBsIiFsfdT7UwguNeAGiP+PSdR8ViN?=
 =?us-ascii?Q?k9s0slkCj1u9+snka4pfziX3qKZri6NrGeFr4kzbgrVeLs0GmnKuUD+9Hn6c?=
 =?us-ascii?Q?H/pouGGWUyIQy7iWtx3STqOw7PE9c5i7IdApkrV585xp1z8ndmu5/Cmowr7A?=
 =?us-ascii?Q?pEosRFLQKb2oJN/DKSAtwwPcXA740FeEMJoGfHl9Otac20GSUKSWcRjykEYz?=
 =?us-ascii?Q?/WVrV52EJrEGzRWWFWrU8PmM/sLxYHLjyXpZZHjsGQvc3mcRAsTyGwM0GsVM?=
 =?us-ascii?Q?WSXuOIB0NeYVV8eF2Sg5E6FFWfsr+zkWwZEsXPf91U2K2bVShD5alL+mu/4X?=
 =?us-ascii?Q?sphW+Tf3cposAJqtCl9WRBIRIWce+8i1pI+bDp0dnzTI7Ibr30XCTwfABlwk?=
 =?us-ascii?Q?/hWsqJGkOSFyriSpsmdQGoEACRpd0xkefbbguwDBi7ZlZSaBlqKtBqoiTyX9?=
 =?us-ascii?Q?mm4VUpgu0pBrMKMh0aktQKmi5xdcDdF3PEFYE+YIIdFP4+5kfbosIknhdTLv?=
 =?us-ascii?Q?s1xWTmYDKEh0C2pJskKOZQxSFxSIgKX2cpjivaPvplVEhCDHOJ3bX1fXcQpj?=
 =?us-ascii?Q?moBvfr4yFyYuyurirogO3m8l2ARinsp+AAnK9b/zL0pN+ekEpTz3xUsBI9OM?=
 =?us-ascii?Q?Q9Ed9QA0z+UTRDx8Jqv/L0eTtiOKXyFQR5YWlTK9IUlZAP3LQtsU/M4LZZuI?=
 =?us-ascii?Q?9uIwl21BqN82bIHbiuKtBBQJq0Voa9CpMiIdpUbQjFGg5R1SdMbwP0pjeCO5?=
 =?us-ascii?Q?cRTrKyjrxekPL0WoIS7kiEkar/aWauoZ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014)(10070799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8f6Qnug0g0IxLe+MpPBPtYwRBI8zZx0MG119g4ddqGxOq31BeLNcd68NfxHx?=
 =?us-ascii?Q?i2/FRCk7jj1ZlBk/sDpUT0LGgRZ0HZW+7VUS0l15U2kkvxqj/YaOhEifY46B?=
 =?us-ascii?Q?w8POygro3lqze/lafVPLW0eyfQFfrj6b52myjb+NnfS4LpDJvVKwMjsQIVyt?=
 =?us-ascii?Q?fXrofbr8xOBeVM4PKkg1lD5d6eQHSRmJv/YgiNHvPLaDVxKCwJR+OhqOmjtv?=
 =?us-ascii?Q?loESUmgNNaVZ+76K8jcGxcBVJYx7HdJbgxhOqu8LAnbbssRpPDiWrYJz4Nkn?=
 =?us-ascii?Q?GGrjqPORU9158znsOtVOAITw1dmy/zPfrJeqQWe5GlPTbiG4gaYgZ0ltk9vH?=
 =?us-ascii?Q?ez+jjvczKlteYbMfUsuUc6RP8FjCnCH+i8jt4nseh57J//BK8V6jsm0u1bgJ?=
 =?us-ascii?Q?9UKXtuWpmoqNWJGzTrcFdhzhoC2rCKgWE/xdHZM164nO+Vx1AwGIkqgX2Oxn?=
 =?us-ascii?Q?IscGVAPI3rvdDD/WznFQw8VPoSCsQQu4wx7Pb7mbs4zbOYckVLvmDoLYwNhD?=
 =?us-ascii?Q?I2z+CMMZCquq12UqwkB1fE0cS6AIqstk95Vgl4Wr26Vq/UKKtLVLFMHT25iJ?=
 =?us-ascii?Q?jzG9ziwcn29+TdadWzvVyctuYocrJkiK5AsJqnEjA6ymXmX28mf7+EzHeWcO?=
 =?us-ascii?Q?w4H+CThZecZmmn02MQREGHC4X9QLB7MubWb3KCEIfYufRgyPUBKfIHcpfdBp?=
 =?us-ascii?Q?EaYd0CL34UbADGB2ytdkCrAkvBH9nSIdA71YAwoI5GCiUDocQOIUwwGKK92o?=
 =?us-ascii?Q?Jk3k4jgab4JkfcP/YkdYoB3uFvcYUxMhZdyLhAPU0is1O9OhMj6eA3cUDmpJ?=
 =?us-ascii?Q?HdnmZMzF+P1aF/Fte1h+/SV4clBVQHw4eAdka6+2eY+S5fBOsPTFGf/1uSW1?=
 =?us-ascii?Q?DXHyD3eoTP8vRRF5JP/M15BCW0ZlZ8k2bb3l+6AAef3UFDajHwbwYopDRvYp?=
 =?us-ascii?Q?EErkXG3bmBpYKeGS5le8Z/Mktz0FVgjwkktemFZY/pnBHKy98y49K1rGz2kv?=
 =?us-ascii?Q?DPRR27iyytuWvrxbo7DGnvIDO8fB8kDHWr8h8YRzxNM/ds8ipw9kdcOVikAD?=
 =?us-ascii?Q?czah6y5fWPtytSfu4JbC+uWiCML6ZU0I5EomnSagdJrmnslQMYXZAxiVZL3e?=
 =?us-ascii?Q?1kiHy7Sm71wVDMvB+rRdK89DaW61BPvm4gNNIANPWuGsvvVRYqEf/eIqLXtD?=
 =?us-ascii?Q?JDAoEhzrtPRDp08OQWaXw4l55j2vnwCXup+38jmxX4ap2bdR7A0TC3Qx0Z21?=
 =?us-ascii?Q?YBMclj1LD6XpqpgQbmiXwM0QuhrotXnuI4fkJOhwJTrETuzX/9EXlKh+RTK1?=
 =?us-ascii?Q?MxfBl89Ei6v4zjaH+b2PDRlbghOpcrGGtrydMRZC12svQBwk9HbkpCCMJUUH?=
 =?us-ascii?Q?XOPkUZxVn+QP7vqnSiQMVIibfBFYmOZgCFRU+Sa3K2Hxz+XYG+Kw4FH3IP7l?=
 =?us-ascii?Q?RMHKkpcif2rD1RX92IHk5uAFSXZvCmFAQhyBaMCkQ94MUWM6rggy003jCEtY?=
 =?us-ascii?Q?LdOPrPKjp+ckABiBAs61Ck2T2dtcRnKp1VIm4UWcOE+807lrsLc3aJZKaBBP?=
 =?us-ascii?Q?t9FuvpmLWIo+mQN0fn12L7JbV8lBOihuu+M9XP9kI5/O/4QuHmqiwcIIqBgQ?=
 =?us-ascii?Q?FWRQ0Svla40zuLnIK+xqONMhr2RjsGSbay2gQUKgf2mslGVDFXQOHsO+UFst?=
 =?us-ascii?Q?4DdRRQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	D/0AYDEEIdpFc1tlIfBK1nFyf8ETvOAM63buw5nZMPSR/xdUlL3aWwANBPb87huhzEKtH9ZxVHt2IZgV2ylIQdNloV2G/h59kx8OAprDQdzkNE1c1OJ9vTC3Uj4S218TpMOPZko0GnezFWVO7dnHEYOi6ImvCIbdclkULALJn9VtHKxkYbQ24YZkQ7swzYJpjpEymiCo1dbok6/fPuXEUEBLgdCa523Usi4X9j657HAGJBN4u4zHTS/xi7jrJnz0p6F6NrTUwKsbb8XRf6rWxk16DYwMgYj7VNsD5L284oD8UKoOGD+7ZDcA6ojmLfwSBTA+1CZ7PPpB8RziWeXz6XNOZkROMpsuT3ZATzNiLkSR1+1HXrL+a4MjrwVLXA2In+p92OygXGTuPoYHqd5KSUsiyi369ETF3CyJhR7WH2I4PDAvYY2anQUC3gYDzmWBNqqA4vVTo8UNosnm8MtySOXu4cwDIVObKE5Fche4wI5ryCrfhl4pyXaEcdwgV2QrTk1zmkyG83nv03MxO+c0FW5kiea+5tDHOKDdHK36/x6S5ajRPao+7TOVc6LlkEDnd9BzWvgv+7epc7V09nYlBD6emEV0Q5Nc9E977j9YaPw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f219775-91f2-4931-1868-08de34332315
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2025 19:18:57.0642
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pan3KcRnHE/8EAIiqsayjwG6fYqCdSYabpfLLTeami3H7gQ6gakCesqLXWuXgmwhrp1gaal4WlFRxhbRhHNWkkaY248XtVGJmj2xAAIycCE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5886
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-05_07,2025-12-04_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 spamscore=0
 suspectscore=0 adultscore=0 mlxlogscore=959 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512050143
X-Authority-Analysis: v=2.4 cv=I89ohdgg c=1 sm=1 tr=0 ts=69333025 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=lTkFw0yXN7sNYJKbj-EA:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:13642
X-Proofpoint-GUID: fUnVQN3HFZc9QHHjVAXMGZnFVs9K4Z7F
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjA1MDE0MyBTYWx0ZWRfX+OG9t2lBE05Y
 tMmNJr45Lj4BhUF9xF271fSQZLP4VBBOdAHeLyejFcGyj0XShv+3itAHrV/bylhsLx1VRHRCeO4
 CL8O4Kl8o99PGvKuiP06SFttHmB00Lptqje1ERqERaUGj6eKqzMp2EpQ0YHC4fsNZDGSw7+nVj7
 l8lbMpn4y70BWwfKdBfrIdFOzOf+sfVBhzdF0X0cgQowo3PppsqAX4kcerbxNcWe6OWqBM3sZW3
 HmTTM4fs7dmxLXA8xfhmcKMvibDo1RNPQ1W/oUeUVOu33a3AMEW0rWN//PhsxZaUtk68+R4ET/J
 VCPSsYQBiGcqADsqnq2GyG9tFHBL0xYm4Ui4IR9J8E4Kk3mzbqo4kOczGE8p0BGluPFqCzy4JkC
 MzCyzayk9doO/4BFg+A3Uw8DLMvqi6gTnDZtO6U8+Jxi0jSIj5g=
X-Proofpoint-ORIG-GUID: fUnVQN3HFZc9QHHjVAXMGZnFVs9K4Z7F
X-Stat-Signature: 9eqbscq8t6ggj67xa7pg847txhr1ghm4
X-Rspamd-Queue-Id: 7BF7316001A
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1764962346-63894
X-HE-Meta: U2FsdGVkX1/XUHetn6bqM64SAYBz6ecPJOv8z98l9oLpZZ/WE1LRUG2IgLOheekFKiKmulT+G/z2ZVI9G7jsdX3LkALVB1ozz83pgVrhaefJxnuZU/D8dY+fGlXNRIK8BPdXKv0JQ303lCUffhwcNaF7XsQx3U3CUQt3uzWx8O+6DsR/7zVg6VmN1n8Q62VIGFd5ZZllXU5d5VTMTWNYVSLjauzB9gTDZNWLpplzciFl31O7hPsx38pyqyDZqlx75z0Me2Z7fvl32CvkLneTmQ/LCh3icyYbr/eszO4d33thh+99q95OX84VDaczotBKP50cFAtcXA16vvMx1EDqDI9i4Y18MW78TyAzQGzcI56KhONc49tiaMrM9cyYOwxZTqtADILrpturgx9Ii9UEuv83gHn6xC7zKNHhw8ZLmnA+i67R0JJBooWlybvzv8BKXhwDw549gKXd6fklRdy/UNArP+8v9BgeUh1cAD+kiizdfL6gK8Rv3ZpJ/chIhJkQALZs27B+/DgwKq9/I/kPrjHtebFIYv8UfPsRT0WmYV2jw5zR9jz+bqiq/PLlG5Nt3M81e7zVtl9690xuGMApphsoxsIjXSNIU1K4S8e7/2a9KL9wU6mPl7Cx6nKDWjRWl+AzBOIzq3zEiMUYkwBg2YljrAw8LhwvJa2yNzoAg+8UrbL4kw0BmTL9/jeFEgP4Au39ofoobcevoeptwvR2vf4vNkv/FxJTHz5TBF/mM40pQFK30xQ6IFGVWIBiZTDR3tRsxXsmtJu/5Tk870V/njIht/a1NiJd1E8slB40Nn2Mft/jVzeJumhCswyDI975AXhhYQiMWyAYSp6axGnrMCBB+dIm64FOg7TSdN+DFlcmYtE8qgw/YIycrNjaeZibqTHaJkvPp1ONlwbTpdhK0DN6j+0FRAVUSBhvTYvtpxv1MVYJmcAvUcLz7Q23yzrtaFg0FqEcnoWG5ebqH2u
 bOqJ9o5z
 rGtnL1xsJ/vaFN9Kn/SIRFlEAH4jwsgooVyweQfsLEl63IRLFK/P19v8lKGD0QBB1pWDabTWrcINdDGbks39dI6hDrnU5+9NnYQeWmZIw4tItLjs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 05, 2025 at 06:43:42PM +0000, David Laight wrote:
> On Fri,  5 Dec 2025 17:50:37 +0000
> Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:
>
> > Commit 2b6a3f061f11 ("mm: declare VMA flags by bit") significantly changed
> > how VMA flags are declared, utilising an enum of VMA bit values and
> > ifdef-fery VM_xxx flag declarations via macro.
> >
> > As part of this change, it uses INIT_VM_FLAG() to define VM_xxx flags from
> > the newly introduced VMA bit numbers.
> >
> > However, use of this macro results in apparently unfortunate macro
> > expansion and resulted in a performance degradation.This appears to be due
> > to the (__force int), which is required for the sparse typechecking to
> > work.
>
> Does sparse complain if you just add 0? As in:
> #define INIT_VM_FLAG(name) BIT(VMA_ ## name ## _BIT + 0u)
>
> That should change the type without affecting what BIT() expands to.

Thanks, checked that and unfortunately that doesn't satisfy sparse :)

I don't think it's too crazy to use 1UL << here, just very frustrating (TM)
that this is an issue.

<insert rant about C macros here>

Cheers, Lorenzo

