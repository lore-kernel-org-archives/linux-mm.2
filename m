Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BDA9C8303F
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 10:27:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1EB88E0015; Thu, 28 Aug 2025 06:27:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF6838E0001; Thu, 28 Aug 2025 06:27:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C97658E0015; Thu, 28 Aug 2025 06:27:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B62528E0001
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 06:27:02 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 55371160ACD
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 10:27:02 +0000 (UTC)
X-FDA: 83825788284.21.F68F224
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf03.hostedemail.com (Postfix) with ESMTP id F18B020004
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 10:26:58 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="U/K2Y2KH";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=RJlKUHZB;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756376819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9rZRoDchGIJeZ0Zk+OBqOmJSJmgQVEGxXLPXcGQ4HY8=;
	b=l4MVbA1DqKen9YFvVNM15de444UBusON+A8Kuq3u7GbR+tQZW32pt0T7LUpBfrxPzXzZ+C
	tcyXnYDO2vpcwJwUSEa0Dr8MU/M/je/ihZR4byc/UtisIYTIyLBKNTNKAOvgXoK0/UiDtA
	ASes1HHPNC2c0C/1DlqrmbpDGyfjjfY=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="U/K2Y2KH";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=RJlKUHZB;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756376819; a=rsa-sha256;
	cv=pass;
	b=7tCQ8pAOj9bf5ax6l872Ed74usgKIDcp674VQa8VXZ0RWvzDgK9Eecz63Nc57sj6i25JLD
	N93jJ+hXeySyvXE173kn0ZLWRNQNzrgVU6yHzxo6uiTcfqJBXmATON6wtC7TMJzUERQ28H
	Xpd+xWGQzRZVNhYnTz33YUoSBoCniGI=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57S8tmQc007542;
	Thu, 28 Aug 2025 10:26:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=9rZRoDchGIJeZ0Zk+O
	BqOmJSJmgQVEGxXLPXcGQ4HY8=; b=U/K2Y2KHymW1lh5yRfGePBDeSa6LDIIVRA
	bqYvd9+MxCPsAXezDeuUp6fQZWL9gl/TQy5N+2db5P//aPOtYT12FXaAlH9lY1Lv
	BsD5t6QEQ9P36+bjZsxow1HlxVbKVWCGz+U2xY11sFprDaBwRAGR4zLRRH8tL3Qz
	vGLX+Iao4hlDof8f2PiXMmpr00JDleeUMOmaxFQrDGWyY7UG2cQIbY0s9iMIhEZS
	1+Ck5951bJ40kXlhD1tbzZdl9R+gJWtbhreYNyPGTl/jq0XagYB/9XUE0GXAFw97
	xp47Vk5EAWckxG3SSc6u8ZlU+lDUkgBdLyxvXs0+nELX8V3xzDdQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q42t8274-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 10:26:56 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57SAGY4Z019610;
	Thu, 28 Aug 2025 10:26:55 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11on2050.outbound.protection.outlook.com [40.107.236.50])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48q43bt6vb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 10:26:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xTJfIE4D4FQjRYusg7bwasaAgSJxuO1vjfBF3bFv6Tu50kf0pM7cO5pC3NKem9GqLgW6jWeef4AZemu2TIhRzN2tnpTrJ7mlA5VbOvtI8Uz3Cz/ANbYRVCuK3E0cR6rCqaNxwl/VwQ3BYv2TbqnIorw4Gx/Y7+tA1RSZQQoHsv6KUP3kvCopBIAsdTrFsCe74lOXfgmSxLh6SAY5Quoi207R3mXmY2469gyKKVwQ2HAmUERvu/0vT/bxkrY1NzffUiX4+PjvgdCAd2jAphteZVB50w3vJ87EOEIQbxGqPjQduuh6LSxusW9gk/uLkgV6LegE6tNhVxQwJMz85jHRTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9rZRoDchGIJeZ0Zk+OBqOmJSJmgQVEGxXLPXcGQ4HY8=;
 b=nlL0bmTnt23KHyUSIz58b0kAhQ177fyMS0QgOw3VvJmFBQYe5YG0MfRjqH9LpdEOrztiv1rheCqHRo/My1QGWogGhcnKNuPyLCUlTjg7gXWzvSAlRx/cbLSebqC9mBkvMJl+guv5kLyoUNOwbW9PaLplcAk71Nb5sDWt66xjK+ekSEmXlYFak4WktysCjeIvfbdYWQ1XbkHFsQgLMdmYmWuZ1xvzKu5pZAIQ+KtWQ041j1hjB8IIU4kLH+ixiHZWJUiIiPNMaXgKv8bG+GctxMIiHyNwm/PLzvh+s8G/F0BuyXUapBg/+BACB789LXU/nhxqjCNbu8fXJOzoT5z5wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9rZRoDchGIJeZ0Zk+OBqOmJSJmgQVEGxXLPXcGQ4HY8=;
 b=RJlKUHZBraZWGANCdDvHonLfJyDo1ZTgm7p1KSwF5KV1dPbBbSk16hlp0UfXGt0Bq2rlTf1CRh7F5h+cKiZZxocxlLo8qREotwWWFfUXE3lJ2ZXB/bTcoxil2SZOBeZeRHgwq7UtiP3lMIwWopPtPFDr4kugTOcFJkXGBqDzLic=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by IA4PR10MB8544.namprd10.prod.outlook.com (2603:10b6:208:56d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Thu, 28 Aug
 2025 10:26:49 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9052.019; Thu, 28 Aug 2025
 10:26:49 +0000
Date: Thu, 28 Aug 2025 11:26:46 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Brendan Jackman <jackmanb@google.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>, linux-kernel@vger.kernel.org,
        maple-tree@lists.infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/3] tools: testing: Use existing atomic.h for
 vma/radix-tree tests
Message-ID: <79e362f5-4452-4b9f-ab6f-751fdee8628e@lucifer.local>
References: <20250827-b4-vma-no-atomic-h-v1-0-5d3a94ae670f@google.com>
 <20250827-b4-vma-no-atomic-h-v1-2-5d3a94ae670f@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250827-b4-vma-no-atomic-h-v1-2-5d3a94ae670f@google.com>
X-ClientProxiedBy: GV2PEPF00004588.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:158:401::44f) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|IA4PR10MB8544:EE_
X-MS-Office365-Filtering-Correlation-Id: a0bc0014-4cab-4f05-9e77-08dde61d6595
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?yIJNEyPw+DEiI28JjEqE/d78Am9bMR7UCmRhrRP2SJbOzmw3/IOdBlsutdRM?=
 =?us-ascii?Q?rDRPxXKZsTblYbUV9WLZH2GZAkE5uEj3KrrNdRHPi8h5T7aSQzzGrjPraPVb?=
 =?us-ascii?Q?WiQL4BOW5kpiNk2upEmy2g3FuPmZW4LEpP6xSJVE7zzI33l+lAPLB6jbkOEZ?=
 =?us-ascii?Q?A+1VVcLCPY1Udgtvd61Rg3DPcooZgwf4PMmFNH/sM7L9f7EB5BTZXKqVcuC4?=
 =?us-ascii?Q?ko3AAbGPX3Le51eyazYhbMO+kWH4ridRCVCEodGHvfPDGHsPjnz15hAhrOPo?=
 =?us-ascii?Q?Ob8cnv4Mf93vY2DhZxI2SiRN6qmvArsw+CPHpHzDHZ99Pz7b1lcUDV9i49jv?=
 =?us-ascii?Q?C0VWeN/L295u2XRdIudk1fuLQSQJSB684cmI7VAEzIs8X+uS7EAjkbgQxv/t?=
 =?us-ascii?Q?VI51VOUDQjplJNz5CcLnE7YqCN9DpDVnEecR80FkxQW9kSZeRxDIqQloPl3E?=
 =?us-ascii?Q?Q/X8LHpZ7OjyB+V4fed+NPKrh1/K/rrXIlR1RWv4U8Jff/0j4EDeGJpr/KaZ?=
 =?us-ascii?Q?oYfxW+AoS/HrgQZPJ+1jfnOgz0RCdGowAIV2Werpxg+C5IC9D+LclhalmWBB?=
 =?us-ascii?Q?GDuqKxPraXbEM++nqkgAicausUBXq+ydJuJy0ObKc+aOH0jRmIUL26cUKAoG?=
 =?us-ascii?Q?WipbyvE0b3M6qGJVkdnM0KnZCIKX43ZGus9XYA/vfZROqYGQPT02ZnJItHtX?=
 =?us-ascii?Q?OnjSGcX0UBDt/hiqk3ZoBJSrhIUsv2u7QQ1/W9IlxFq+FFfeQLBJgOK1Ud1M?=
 =?us-ascii?Q?wKhmIP5oD5f+b8fJUnOrfLFbysERjsd58IrZGOcm7rO/8GC5CPAztZpbWoO+?=
 =?us-ascii?Q?rpzVolGBttGT+nEfCTMnsiocVD9kM9w4gNmXBRrcv0F9m2I7DFhHNAxnjVYa?=
 =?us-ascii?Q?ZonLAWeVqEn7RLcgoIl5NNmUSCFywaekFHL8LfyluiL/AYNc+OukeaNxf5rp?=
 =?us-ascii?Q?FZ7xNeuWXuBazjGAir8g71UO48OibevZB+5JLOeNVqe7w0uTP6JVRSeMP4GD?=
 =?us-ascii?Q?TJy/3+ypSxgXxwOFZ6MzvuAjsLGdO2QDhwtV3otZHGHPpqqPEoC4Vylsi66M?=
 =?us-ascii?Q?mwSCcvfQHb134aRbhsgRFGgUr1PZpH0jFZmGbdzZEzGq7E1ur5AZ/YV9geKB?=
 =?us-ascii?Q?Ffvc0JfrBahQAepwV4za4jHOgUsjUpFA2lI49wx2IEjn7dJek0KQVKmQvmwi?=
 =?us-ascii?Q?p1FUSeDIbJZY0Gx0IF8cmHIe65mA2e0GydednGx7Doq85Yuu7dlTFftoap7v?=
 =?us-ascii?Q?m3/f4+fASqeV94j0EFD+Z4VAzJWCIXc6oXfDvv1OoHnUqNmHfj77pK0MZGDM?=
 =?us-ascii?Q?nIzKD51E21UNqKAWQw4grux2Lp86Ad9oH7TuqJoqDOC02eTG7Fei3RBwFasx?=
 =?us-ascii?Q?K7oP4LpwTLr0+d6PPXPAFkkzeNzlasMVpj9wrDqD1GuLr8StsHF8SjFBfApJ?=
 =?us-ascii?Q?GWvDDZxWdrc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1MwsQpi/csceRUbxKebuh5lP+Qt4UjFfNpY0H98wdBgQg+bomayTullee/va?=
 =?us-ascii?Q?dSjc14G37rrr5W2ByAEcy53fxzLbdkbyocMoaFa/oDCCYIMY08Dh09gC645i?=
 =?us-ascii?Q?paHpXCXngl52lH/6vwfVoWLfB8UVpqY/iJRlqJT9L6MqWBD7WRfzVHotWyQz?=
 =?us-ascii?Q?cXJysGu+Ay0tUTP+6n21XGm7fdjhAddXc+U8C2Ue8t7EJNmyyBLJ5+wKnGPw?=
 =?us-ascii?Q?3j9rnsxtp/DSpB+PKdpMdG9noiaCv7US1S/1aB44/kNhlnipLuBS2OzR69q5?=
 =?us-ascii?Q?A35xhWqzxPe2F1Fk1XNf5+gg1EFSqAa+IUSLU4VXKjr+7deUIKeeUWwsafbN?=
 =?us-ascii?Q?J5JJBcP6URpr0A4pk62c8tL+smRdGiTvUbX2Zpti2kKdORWSGKRHow5Arsck?=
 =?us-ascii?Q?Nn5GTZEcRRBUAfhgifkcBD+FAQQqm8TkCuab95J9+F5iJcDsTprl6hmHBbaF?=
 =?us-ascii?Q?vJqMJAUASuTG0W60fMgCEjbKoCFbsYLkKVQOLErERYECkl5Qg2HJICEjL+hW?=
 =?us-ascii?Q?JDkK3pLBNfTQyIkXZqquXOWNKUYNusYXBrpI/vUgr083tsVDyyoLHP/Jo95c?=
 =?us-ascii?Q?klzygOCNaL2YKct1Sz0fPC/ZTHqHqor2WB1WxUAhQxFgpBVMdU0ABm+26gIY?=
 =?us-ascii?Q?uQXBwnXhTulzzDhvcLAY1xoanj1M9w6jn2tXEJDZOt/dlBHaDh5v41jWzgre?=
 =?us-ascii?Q?0/n2wKnx2pgbXM6XH1y/qEsCaglpvYUBU0g48j+8v0nGe9fJA0YLNBDgIbBP?=
 =?us-ascii?Q?36b/w7NZt+TiUi+mTRvywwlS624rkLcq83zxLBAy4qtyN4OF6cIe5ljGG6zm?=
 =?us-ascii?Q?PPVC2AbHtwjOYowDzTgPUOUCXGZF+uy468qGme0HNeAOI4NGKQQmIQHRx3xc?=
 =?us-ascii?Q?Ycg1lcHQfvLr2QumD3G9iK84cWRmoUVzdODDJA5HFewsB0BxXVjtwxTNOVCh?=
 =?us-ascii?Q?/YR4/+NgAFivm4L3ZPE1dNT4amrkqqmqK/hyCYwXdo6GQdZDHSNy4tracA2P?=
 =?us-ascii?Q?7cJ7rH9/If4XMfKY1IcClorw8DQORPJZhP2se8LH/ZhrhS4IpcrjF6wckQkw?=
 =?us-ascii?Q?jBF7nQHdaMQSRcVxtFiqKyATcjSN6UP4PkCrCsPcKrMfcbLdbafppUPcLNk9?=
 =?us-ascii?Q?19E+DelqEOudBcgegJsnCUtIjpf8Z4x2EwzYsnfwjYlsE5ptTyBB1lIq0QJ6?=
 =?us-ascii?Q?Wixoqjz1M1m1Nlh1peZrnCcdDx/VcIM68t50uJe+oCYsrJ0j8BHN8N6dGDhF?=
 =?us-ascii?Q?TFmgFsutRF2nqgjZ6YLcKKz78OU/4OyzTY+f3VEFHytq/navygKGBOVSBs1y?=
 =?us-ascii?Q?UVsrWYo/Itrz4Y2tXd9yNEzA46vAy8gJYKxkfrifq10brRD/Wit4FD96GPfy?=
 =?us-ascii?Q?gSHesoL9bHXwNoS9VdVnuBTzNVZLWolT3yh2AHTGEnstRAc0un9ARf5X/kCF?=
 =?us-ascii?Q?kBgJdYwSIjt0jsqogwg+EaOcU9wnt1V+IV463gEdUAAl74Zag325EMyQqewr?=
 =?us-ascii?Q?dGqWQ72meQ3M4CNkdezFEFRHPHepGtJILx0a2K+K/owyZy2smkqIxEhFZ58N?=
 =?us-ascii?Q?Kr1HSplqaEwniDlao0LbkctnZUtMUkr4oxTR5TEbY5sqmmK1WMYT/i8fCUYt?=
 =?us-ascii?Q?8g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	PnT1/q9x8sZUkVTRsWQpK6EVU+aokQBTyPMPzu4ODy8EtSYFhP3IqwBXVDGiYfJQUyRXA8+65mYnxx/1NlDDrPa4inAO+Otj6a1t1JQwMPuwwkjBK9kspPyt8hJ2q7Qs9lfLlBbgeTC9DCOuTuFb/O3mRiVtMTryhDyWDnriej9dGJwewCwlXVS9EL59E+LqPrinJWhE0I5XoEBGyTLiCXI/p/MXqpxJxGTaK1KnaO5GWRtjjcdJ++gLqAuNhDgBi0FnT/lkiVzGXLoPU31tTBLvyxjLibFiPiwDyU9y5KfhQKP6ezC+cu6v34NrxDCjTADp4NX5WTXsO6JddSFmXOVbZ3JjWuq3+NIb5iH23DSpPNC/5It7Gg/ik3nCKr4Ewpqg76Z/qnBHzEjiBREa0EC/EcChoccTLTAfzitDZ/oNYjm7l+I1YvxsO38/DKXBuY/DEtqJrf36J6QA7wrri/c3ndbIeGcU40gcTQmfPLcaoCXR8vAl959ZaDY7AEnYB5NuCbW8NGd5r9OL3P/wq88VoM9qnN6VVaNiC6u0E2LplmTqy2X4F58Lycnn9qpMHuPapF4bmArKgsGNvI0lmTB5Atv4z+i0AN2MWxxXPNY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0bc0014-4cab-4f05-9e77-08dde61d6595
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 10:26:49.1035
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YGNtqptPzyPjpuGr1ZtSrGQb0rO/kY68SScEChZGqRWobZ0QoUfk2dTQE8iS0ec1UWEA8iRB2Btohsm++10NeFFQc+8Ix32DOZyRzy/PSzs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR10MB8544
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-28_03,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508280087
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAxMyBTYWx0ZWRfX7U4a4HZqVXaR
 dJEGTYB1FT3jdB3R9ZSVtgJwKbbm8Ydj229WULkCuiUdlpOfDK404RgIJ3Tx1YhKmiE9C9EM0l9
 l0v+ZGFS1KvQ7JZdAy4TL6cRtJPbP1vyUWw5lt65anElTnQvKpyLZk9IpLq0GDIWBGBAjtvqp6+
 cow0ed4q5HKvxgf3+H3A87Vz1sM0zpP+uOuBfJXmAaPHTBbgN3LifZNc5ry/Rw2STmcN33anD2w
 iB0bznf6rARXs4ZhKVdsDrol6Q0RfFvUepacvwNT6nNUyW/sXfzohDPngDym8ulx35rFuNrA/m6
 XRtpKqDiW/49ebw4SwIpjN6+vlTXS8x32XZTAtEa4DFqQG9gH24Rdqncflp1mVhaGG5Sn6OTITg
 rmlvpb7o
X-Proofpoint-ORIG-GUID: 37bjAix5fcALfCnwKTeZjM2Ens2iBK_k
X-Authority-Analysis: v=2.4 cv=RqfFLDmK c=1 sm=1 tr=0 ts=68b02ef0 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=1XWaLZrsAAAA:8 a=yPCof4ZbAAAA:8
 a=FwGiae7DSPBwYh3wwPQA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: 37bjAix5fcALfCnwKTeZjM2Ens2iBK_k
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: F18B020004
X-Stat-Signature: obuhjurznssqq8ypjrt3wd8y7qmsyzz1
X-Rspam-User: 
X-HE-Tag: 1756376818-430541
X-HE-Meta: U2FsdGVkX1+RdbYiE865nKJSyMAf01RG5f/Rw2uxMBElbAoAkIgFAIDlLKe0hgL36kXqpBCjCtn+Kbhiwmh+MsX+HPJEEAcz4jRE6QUGv6M2jZLgYZWSczmqqqw7ALROMFMJxMuvXzlYFRsI3oH8yMC6Ky2YZ9Nzv/Z/Bk/rWx62ZgUOT55nlOKJxpNKRp54MvZd4XVFpJenO4bQi8KDOk5Dd9KGfeHMbtRuATAyD0nJWxNRtMhSgpkqniYD8EnXRaUBkxzdqir4B/URnzyIohQivfPECNFcoAa1JNAEqDhyv/kk9OJoM6aWv9fovVzcXHqHSCkKgCG9hleJwHBz5CJcWSiW2ebjoa+gp/PQQrMzSzgx2A3Gd3QdbAz2+WryBORVpyG7jFKY6Fn02ei0IWQ24hRQyXeLpNfoQ82XMB6Q5clJLUnK+3aaoR8n3jfkFMjps8Zxd6hLjAFtYTAiwAiNgZNAj/WOUTlE0HS9q2kiG2BGHY4IrgRso1M8x3wtMleH+fOfM2UB3/hK//u9RrC0WJOWLIqfWuTRxOdb3VDk5q0acFkFhF9Gx6CKe9ptH14tCoS8xgJLgn6vwxMysE7g5hhHV0XB7JkTpaaxL+d6Hj+Qh0Xl3cGun9krgNqjEV9qfoTHhQ7cvST/JeqZm4rXZK4njVTy90gNnzVI2cKsrtMDndYDakES/0qUuBFFSSMghTCTPZ1x0fGFCwmoBuqXfA3LjOT7lETi/gY2QaniupzRTWtDLvQUvOWiDd2EPKUBQpm+CStdDpfjfKV5d+JiNvrmeA577bDuaNduXNyNZs1Rwrfv4z27kphCN+/XSq5SmyPc9dmv6RDzlojh/yip8HR036jvCpugN6k7R5iTAmq3+a6D7OiCzUqrCkTsTv7c++yJBquSqNVvVfHHzEduIWOOAlryycUf4qFCS83TtU6ZvQ589iztPrOfrmPZ03hCmAUG7HeXRPVAzOq
 r5I2DrU1
 JzQiomW5ciEgee1kJC1Chk+67hozNXD3raw0qnMl/RUGeLTEQvKmsvMITPOVo9TZVS0/fhwS74DKUIn6yJOGfqg3kdjG/QHXSIO3J/8EyLnelUPoL+XpukdP1zRe13rW4k3cTcg8QNlyxoAIpyO2fFi8/m0QlF6qIrlYEQgmXWlVuysZ4ID+P7iBlgn3GmmF+X519gNXpOBRbjU4t52tb8ulz1Mx+cx4Od7Ts6+baXbHkkmzk+CC7Uvqhu+hTj6HxmW6744m5iibe2aC6Uz2p+qbnzbaNbHuoIzSEhXSkhxut7yxxLDv2GtdzS0p0UynWSTXVrBdsxPJp+FM/W6+gDIP8Y/PWIM9f18bA2OQ3fssfjEvRU+odlg5B20NpGspoBnsOeH0zbI1eQK4e2iDxnjKY3nHuVz0Jz6O8Gd4Lc5UIZJgUkLtfkeg1EQe0/j6evvFh8BHzbwFnnM/w7asnJG93J2ISUeblVIlj0nhRQT4EODkcKrbvKoyUVioII/2LDnClYaUYhXSeC5hkXErzPIrsQuxBW9DggdxLz1gpFj4LmY2gC8mKpaGYM0tpH142DkX9dShYePsuqlDOmrgUg/e9KqMzjZI4Rfd4dOykItbxjiojyEUPGtbiIk0cEJaMrWF2KQgP03tdSdkFCUR4rxjQj3RGcPmZyZ8Rpy+XlUmnMd0JGQD3+t+ZRQDfQz1vtWQnsy4NBDjfibDsVkK3o0kjuJ299SyP+mde
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 27, 2025 at 11:04:42AM +0000, Brendan Jackman wrote:
> The shared userspace logic used for unit-testing radix-tree and VMA code
> currently has its own replacements for atomics helpers. This is not
> needed as the necessary APIs already have userspace implementations in
> the tools tree. Switching over to that allows deleting a bit of code.
>
> Note that the implementation is different; while the version being
> deleted here is implemented using liburcu, the existing version in tools
> uses either x86 asm or compiler builtins. It's assumed that both are
> equally likely to be correct.
>
> The tools tree's version of atomic_t is a struct type while the version
> being deleted was just a typedef of an integer. This means it's no
> longer valid to call __sync_bool_compare_and_swap() directly on it. One
> option would be to just peek into the struct and call it on the field,
> but it seems a little cleaner to just use the corresponding atomic.h
> API. On non-x86 archs this is implemented using
> __sync_val_compare_and_swap(). It's not clear why the old version uses
> the bool variant instead of the generic "val" one, for now it's assumed
> that this was a mistake.
>
> Signed-off-by: Brendan Jackman <jackmanb@google.com>

OK so on basis you fix Liam + Pedro's comments, feel free to add:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

On respin.

Thanks!

> ---
>  tools/testing/shared/linux/maple_tree.h |  6 ++----
>  tools/testing/vma/linux/atomic.h        | 17 -----------------

Thanks :)

>  tools/testing/vma/vma_internal.h        |  3 ++-
>  3 files changed, 4 insertions(+), 22 deletions(-)
>
> diff --git a/tools/testing/shared/linux/maple_tree.h b/tools/testing/shared/linux/maple_tree.h
> index f67d47d32857cee296c2784da57825c9a31cd340..7d0fadef0f11624dbb110ad351aabdc79a19dcd2 100644
> --- a/tools/testing/shared/linux/maple_tree.h
> +++ b/tools/testing/shared/linux/maple_tree.h
> @@ -1,7 +1,5 @@
>  /* SPDX-License-Identifier: GPL-2.0+ */
> -#define atomic_t int32_t
> -#define atomic_inc(x) uatomic_inc(x)
> -#define atomic_read(x) uatomic_read(x)
> -#define atomic_set(x, y) uatomic_set(x, y)

This is nice!

> +#include <linux/atomic.h>
> +
>  #define U8_MAX UCHAR_MAX
>  #include "../../../../include/linux/maple_tree.h"
> diff --git a/tools/testing/vma/linux/atomic.h b/tools/testing/vma/linux/atomic.h
> deleted file mode 100644
> index 788c597c4fdea7392307de93ff4459453b96179b..0000000000000000000000000000000000000000
> --- a/tools/testing/vma/linux/atomic.h
> +++ /dev/null
> @@ -1,17 +0,0 @@
> -/* SPDX-License-Identifier: GPL-2.0-or-later */
> -
> -#ifndef _LINUX_ATOMIC_H
> -#define _LINUX_ATOMIC_H
> -
> -#define atomic_t int32_t
> -#define atomic_inc(x) uatomic_inc(x)
> -#define atomic_read(x) uatomic_read(x)
> -#define atomic_set(x, y) uatomic_set(x, y)
> -#define U8_MAX UCHAR_MAX
> -
> -#ifndef atomic_cmpxchg_relaxed
> -#define  atomic_cmpxchg_relaxed		uatomic_cmpxchg
> -#define  atomic_cmpxchg_release         uatomic_cmpxchg
> -#endif /* atomic_cmpxchg_relaxed */
> -
> -#endif	/* _LINUX_ATOMIC_H */

This is also nice!

> diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_internal.h
> index 3639aa8dd2b06ebe5b9cfcfe6669994fd38c482d..a720a4e6bada83e6b32e76762089eeec35ba8fac 100644
> --- a/tools/testing/vma/vma_internal.h
> +++ b/tools/testing/vma/vma_internal.h
> @@ -21,6 +21,7 @@
>
>  #include <stdlib.h>
>
> +#include <linux/atomic.h>
>  #include <linux/list.h>
>  #include <linux/maple_tree.h>
>  #include <linux/mm.h>
> @@ -1381,7 +1382,7 @@ static inline int mapping_map_writable(struct address_space *mapping)
>  	do {
>  		if (c < 0)
>  			return -EPERM;
> -	} while (!__sync_bool_compare_and_swap(&mapping->i_mmap_writable, c, c+1));
> +	} while (!atomic_cmpxchg(&mapping->i_mmap_writable, c, c+1));

Obv. ref. Pedro's reply.

>
>  	return 0;
>  }
>
> --
> 2.50.1
>

