Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96CC1FED2C3
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 03:29:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB2256B0088; Wed, 11 Mar 2026 23:29:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5F936B0089; Wed, 11 Mar 2026 23:29:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C16D96B008A; Wed, 11 Mar 2026 23:29:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AF57F6B0088
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 23:29:15 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 430A1C21C6
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 03:29:15 +0000 (UTC)
X-FDA: 84535980270.10.103AA2B
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf05.hostedemail.com (Postfix) with ESMTP id D96F810000E
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 03:29:11 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Vc55Ka+G;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=fr623lDn;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf05.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773286152;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S6UDVNcl5saU5LVqjSKQhkFUXf8J3dPtYUpS1MrND04=;
	b=DSosROH5294FcMrtsDH1TMb1UkSRwOfJYnW66xsk1Nt2ZkATJpAOakru6BIyGW3Tj6Wqx7
	qFo03FtAF0D5o00pMBShJf4+MhIDGVF12V0x2mJz3/AmY85NecVO+Vze04UNl4YG2YoM90
	JtK6t3uxNdDMKWxxNRUvSAJA6zjLzt0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773286152; a=rsa-sha256;
	cv=pass;
	b=uKTaf66GpyoqAkD4y0emC3b/lReGAUx8kN40YIXv9BNxlAZkSCS8txy8wENB/Dj0kVjopB
	+/emvt8LL+F08QiA8MUySf6wtPkrBGCxiyH1lHhwOzniDUynJhGc60ZiC2sw3WJ1a702dF
	N0+GMlqpbe5UT5i0bbYMvjg8MYrZi7A=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Vc55Ka+G;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=fr623lDn;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf05.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62BMO81T4031324;
	Thu, 12 Mar 2026 03:29:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=S6UDVNcl5saU5LVqjS
	KQhkFUXf8J3dPtYUpS1MrND04=; b=Vc55Ka+GAn1sjBy3cLkJNo5GcCR4XbjzwS
	w/U3Azl2EFcv+PBFIVWpGREhqPp81VXh64oBEz1PpLv9k2EYjmRI0UEq1GoGkvlq
	YdHYvrT/rMjhnKEoBkSlN6eeCo6UmpBPvq2x3dtSEY7l+B565ttVhNVye95SKOcu
	krmhAj2HsawlIwT3SoY8ezCpk4syj44VFm0XD9mqRG6//G++iMV2zBgwl0ItlHP/
	Ez4SVnSTc8cPK3lmMmc+gtmpnlHV6hUlej4O50VSkEoIuaDtaC9fy8WZFnjYgRLJ
	4L53m79dYt2egww7J0aHHPkQ/WKUu9HEwYrykvMNufJ3XkqN4zrw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cuh4qr6hk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Mar 2026 03:29:06 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62C1e0gQ013298;
	Thu, 12 Mar 2026 03:29:05 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010057.outbound.protection.outlook.com [52.101.46.57])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cuh5cpqnw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Mar 2026 03:29:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b/ZK+jhagU9w5qV+ZA5Bd0/PeOduP4Wh0cm9unvF9SrqtTg6PFbFZunBOR5tDicUfoS6KNLs+un8dTG04GxyRJw1Vb0T3JYpuIqtysiQy5zgDssqzdlylrZIm5pZJ5eSWsuT05nJd0Pek1+JHvHyaj04J9R1AxTxA/qa2wOjNbMHsKpskZkNvucG/iUO+jOuCmkN4/fYM8D8WNMlipOzot/tlAHv7tBjyC1Uly945BqZ0YERk8F77rLuLNI/MY68NCDx4VtpdB4RojfmtKTzfgsl+Tc0jTs5unNzvaOx3BdHE/agbMUJwBZy7SOGrOwraxV8t6rNaetLSd/8KH/hNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S6UDVNcl5saU5LVqjSKQhkFUXf8J3dPtYUpS1MrND04=;
 b=HVI0L8DWIBftD8GlyC8JDuOjjn0CIC6pB0L94//GlN2t+cn2fgTp9LE2Oy7eEyu+tojPxaxYTD+GGwTVeMwj5fb0RgDoypSlmL/w8dx8lFtvQqBesK3pYds+jYmU6FooHnla/lGHJML1wHksF3eP9wBrtA4frPaW93MpY5IgolcwEakMx8ebLKuCsOWIEWWCh/7gt+vEOfGqpD7AnRXnbHWL6JH49K/rcPV9SmJh0WSzG+JHqasFsbKOdu8BCPcMQzTyAHXYLFJlQESlHSkh15Nkq5EiKyVK27uBU9fRNDbWE3rhy+6de3hndIinuLpsM1P+dk4ou3JyxVdyveoS1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S6UDVNcl5saU5LVqjSKQhkFUXf8J3dPtYUpS1MrND04=;
 b=fr623lDnyto23X7JHAsr7T/zOuJO0TmNIgWjh1MBNmdEPkE42j269BsrHpysJY/FCAPrWu3nC7OU/jNExEfAZVAvK45iqXmPxBIFGYpncR4xmwS2gj/bSedSNnzWwuvTtC08o2UZgomY5bNcDBmb3sUqWXqJro1B/URAhlTvHzI=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by IA1PR10MB5993.namprd10.prod.outlook.com (2603:10b6:208:3ef::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.12; Thu, 12 Mar
 2026 03:29:02 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9700.010; Thu, 12 Mar 2026
 03:29:01 +0000
Date: Thu, 12 Mar 2026 12:28:53 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Vlastimil Babka <vbabka@kernel.org>
Cc: Qing Wang <wangqing7171@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slab: fix memory leak when refill_sheaf() fails
Message-ID: <abIy9XJkZ-j7KIfQ@hyeyoo>
References: <20260311093617.4155965-1-wangqing7171@gmail.com>
 <abFPHpBDe5DsPL2u@hyeyoo>
 <7791ab6a-4707-44b4-a868-d88b93502b1f@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7791ab6a-4707-44b4-a868-d88b93502b1f@kernel.org>
X-ClientProxiedBy: SE2P216CA0099.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c2::8) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|IA1PR10MB5993:EE_
X-MS-Office365-Filtering-Correlation-Id: 814acd98-9958-482c-49bd-08de7fe78102
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	mp8R5EyDXgcQ3WiYCN88q5xzintbaAy80fRZraWCI43d2dJ3/vq2Ks7xVbv1+W3Q1s+x46aungAqqZ5eSPOd2oGAw7UW8X/2rU/RXet4kJrFVBLo2scvHO3Chh0fNj+w+WytRPH+JuWiW99hQ/3EL/Vf6xRP6HRF22xUImNN6IriKe4VgJGvn0O31BwwQGLr1fUhCExKIoDX2MpEtOg36acAgYRn6UO5sBYzCNApAuGB+shhRyGzB/3HuyqxrXl2KkhYUpi7PbaiYh4nkqIYnz0CEyYRJjVzl21AwyY3aI0xx9leJDK1rBIiAUwmeN/Ym070knnH+CHHhKbZKtQdJ1dGnmNwZ6VJEpeVYYlR/6WhrXLQEFy7RQP1YRKGe/6wSQCmshNuJ0YLBgSKhbbyeJBLDeQtB8HeRb4BoARwFSyw+LRvy/fZkvXlcPjGIHbFV8P3PIHxqqp95IkywyJ2NWnGpPTv/Wl29bLCsGh1IkY7zrmWTACMg1fl7/qVqKQo/NX78JcRDA9zvambo/9Wj491abF7djNTxqmhRbX2+b0TpvKgd2YYr+uAMLWHhqOv9+jS7ql09Py0rW0GWPoGszq8cAFgXs2oOADiQaThVBHkTykO2SIH90Ao8k7o+Se9n5BMqNIlKO1a50F3bO8snDML95eWVN7qDOtFY0eOfZ0F7FPiMAxoqwXfAEKBoOIoSrrOlfMo4MlHIay37ohlyT5aMoCNAZl9HYQuVR+5JaY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?tv8kpYckRh78DqmV/UC1B3S4/EWiworMkVkZdVfZLGXjBsSAECSCi6ofTC3U?=
 =?us-ascii?Q?AeN1kDVbraX4zVTSYjZg0F/ATD4xkL6slh1c9yQdOuwX5cAhF3bsTjcUJPG/?=
 =?us-ascii?Q?aR40DEnRZG5Qo7WCGasY44LbMW5XWI7LIgawRDuV/nX4DQr+g8DevFvG+nl0?=
 =?us-ascii?Q?BrU6dJsIPulLHy9fjmMdmDDmEtcjtP6hCRrPDd91EbzJdlCJNjkbAe2Kx6OW?=
 =?us-ascii?Q?TojbVx6hh/ewNZ2mj8U7XatH8MRbjld8HJ4kdCKSuAcR7HASIJidRT5wjYJm?=
 =?us-ascii?Q?aHycP6kqp4EvE4TxKkJixVVbgPRDXfLzaienQV4j/BWwUYu2ARljBl79YuwV?=
 =?us-ascii?Q?dc+0nJaUtIszKuVJg16UatY7DqE6aY/zE8vyMNhN7GmYurtmbYV7IcqBZ0Vd?=
 =?us-ascii?Q?ojIgRbSlPi76hDtbGTJbH+eHvLQfTGTC+BeU/mOUtoq9Jn7uCTKLlzpYXReE?=
 =?us-ascii?Q?aGeZgOnRRjhqgmGoLPq3Z8yX9bRSW36xVmusJmve4ePW0MOgPxI4WVTYQtLQ?=
 =?us-ascii?Q?rOO0tGMBgXig9Mt7jj0iMulYF0Neu06dBdB7wL9elJeKPAwMxle+y6glgHS9?=
 =?us-ascii?Q?PkSwgEIyQXW5FG7ISt83pduzgQcZhsGOIzD11BReoUOymxAoZvFK6zFJCjtP?=
 =?us-ascii?Q?S5XNFL/LwpCgCgJGpa+N8muJQa4fdaWBP7z4nTdpMIcd0IFU9RC/SCf7E4t1?=
 =?us-ascii?Q?rG41yFLkEszaIbkQ6T/H1jUf5cxaX+NJnXg2Huq+EeOvIX1mqbmrwxQtTN7G?=
 =?us-ascii?Q?EYnXiJxZ6MnQmJ7LhStfcmVpG74LryKR58NuJeO6nTSdF+mSx9vifgBNi7Fm?=
 =?us-ascii?Q?9Rf0ArvNBChPmbskV45b+p7H8n30//ujPNyqwzVfPIVjUT/ZQggjX0cOxYcE?=
 =?us-ascii?Q?FbTqZukqmPMJ469X5eim9LpbTFv2nxRXO40yoKdmlVKjHX/qKdXYzKK0sQ0j?=
 =?us-ascii?Q?yjIdC5P3DEtbHNHGeGaXvBCW+95bCNWhX7Hblt9QIWJsH/3AezTBqAgoPXhT?=
 =?us-ascii?Q?EnORan7Onx46s8vCgpPsC0iCtrjlCDcJGU63ucCP97pMFV33feQFwCG3uLQG?=
 =?us-ascii?Q?JBQKAw4+fj5oIWTwk4Jv4YddzCHsmHxeDoKwGrn4pb2wnbSEelIl0yp73SuX?=
 =?us-ascii?Q?jAEiL7QpcLAXQHSPzy67do3FPzXSAPm6CsVmOXTgjFkZSiSSjr+IkHK7dpj4?=
 =?us-ascii?Q?i47pGxYuNZic88DGVjn/Q4K507qNtP80lecU/OfIjWmKhjT5vh7+xerS32jv?=
 =?us-ascii?Q?qM8fkoE7naVGIBQ4GzXknSPH54yPi90RNHz4DNhjnpmixiqqhxiXLxEIqUxy?=
 =?us-ascii?Q?vHvwbe9akdubthulayFZYte6y1XydaH/qnCAIszMQs5VRG4NuvdPTegEwdu6?=
 =?us-ascii?Q?QB811gNZJKNM22mEf9NtWs+0useO+qL+Z2bcaMn5BsdfqHoYqsz6IMk5Dsev?=
 =?us-ascii?Q?broSGssq+O2qdh+kFY9G4PreT/VcmSyWl0KnolIJDkHpUQGX5i94AmAil76b?=
 =?us-ascii?Q?sM4Gs/HsYcvOQddqUnwyFv03V+n7L+n3x26cMk7JhokBxBy+u35Z8M/8hLOj?=
 =?us-ascii?Q?1YcEjsJ5YFFGRwSHukbFW3KbLm2OTPLXsqhepuDHUr+cSnU3DTdLqabDgYwP?=
 =?us-ascii?Q?ZEYE8t96zsUqq1i+KJaSLxIjzJ9npjujTzbYkNcuBoa+5KiPfMME5g+cw3cX?=
 =?us-ascii?Q?6ME0nq/vezN/nXZ7sBFm1aZICMlBmv1QbAKsEzPRD5LxedeXJ4tFXXB0q+xb?=
 =?us-ascii?Q?R5vCnX0/HA=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	rkYBLtoQvkIRywskzfhC04zFc+aXWqmijwPftPaot35yP/g3NWbZSHiX2dFHLS3nZ9d0ZfW1OBC26Tc8t1XHu22Oc3YHIjEhE1O3aKDb4LZ3wVAcCLJ60EmmVM2Rr/VACHT8blBM0XiYrNS3+09bVu/0fgA+XFuWXf9VqMlJLUN2GsZ/gBvhp14IPqW6BOs6MXLie2b1QpnGY8Xi3X48u6/A77ybqA8nqz6NTD4YLwbRzMe0RZSJ/fanJkt2QMKHoeJWfFAo6+WpMdDR3YawIbyleJSuIlcdYML4aLRFfWII9K8dAO+W7CW2ukNhMxnGoUkGbHg0aS8UAr26pbn0IQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	yOqYkQ+dhMW63kZhYTaYS5Q/XFf6ZAiQlFNsyCLzsjHmA2lY4E+UVWP0E2F4f0ZhZIo0/P2C4hND/DM+NIVHLj/ATZabdVtuVVksmYZeqDG+Q1V2cCY8q5uUz95Tjq9JkD0N2UmppNo7EZIR84FTFYovbZmj3086OE0vNiUyUFUgEgQSQ0llDqPzA+2+XJoq0C5CEU3Pl6gXSdyVEiD+OuDu6dFOk8Bav52VEFgdulh2x/i9pVHiSHfpRyzRf2EAuo4jX5IAedh2OHqduakOUtVPIwsHomN1xZWi2WqeCCTyeLP31PW8ew9DJWSxJ4MhPiDgyn776ShfcRrzY8VBxeFz+8ufaUBONwBYMI/frPTILkK3JqZQNyJDmGbanLMBomQ5qF8CtLOc/NRBCJwrQwYUYNjaF141NUet4mzNPaaFn/Y8gj1NnMX9EeaYxfWUAPfXNRe5wrVqGS5Z4ORBrrnJOEfZoPaoLhoXeVOaCaw5zXuR9FdKY00oh2B+0IRE4M3U5K1Sx5INmRthMInmeUKou55X3Ls0CPjgwxDqd7NWgzrlut/As3CsA+63zGrVbOXbnEnMVwuxLN9uyziv1h9TURIPz7G5qEa4I6oInjU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 814acd98-9958-482c-49bd-08de7fe78102
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2026 03:29:01.6034
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5gBEyEdaJjFzD87UNb+iblPObcIkeusvF3Qnv33gVBEO/PAw/GtOlBMJLvPl+HwdKSn5OmWijz8AQvr/9xmdMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB5993
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-11_02,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=871
 adultscore=0 suspectscore=0 phishscore=0 malwarescore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2603050001 definitions=main-2603120025
X-Proofpoint-GUID: rVKrCakWV3ZKIzcoSWAQp6MMOhuJSyPX
X-Authority-Analysis: v=2.4 cv=ZdsQ98VA c=1 sm=1 tr=0 ts=69b23302 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=VwQbUJbxAAAA:8
 a=pGLkceISAAAA:8 a=I-ef4aZAHlghwQ6S9DkA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: rVKrCakWV3ZKIzcoSWAQp6MMOhuJSyPX
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEyMDAyNSBTYWx0ZWRfXzpAY2BjPXhqd
 jBHYOH+f2n6FgZFVDGbbRrO4VaLf80EQC8GUj5NtoGIAG2EnnSf+bGycqO+ESkh8JvPHcUewgaF
 jmlv+6pKYu+kAkq/8hKBu+mN4XuhqFhcEItXcTP4IfRwSaalU0/cP68Mrv+mWREmUyJBx+yfJ5u
 b7oxSYsRJiSLYxB4eYf14Uw+Fexv+lzILdWNr+akusoNZkHQ9q/RX1tzUWgDBgUMWjM0fRY+nY9
 sEn4RCjB1cj4viFEGe6tB4c6g7TZLVgv2xQWSWp6fPx5trnQGosXcUGD4KDlNvWYDV/E13bLhB/
 nnT/LyqKTAIvZToFt4W3bX5kLTjndgGchRMeFLczr2qcuOeaAR71+IHvcsx4z5wBr8YhF4uhIlx
 BqUlHDW707xSaa+Omv4X6Y4rZHaQJQ2D9oGA4HwsCzOoo7rh+YG/0uJtAEanURj7fUcRXZXPxr3
 6/llq+u6c3PYTnVF9Kw==
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D96F810000E
X-Stat-Signature: nyyqyfo7j78zyn7iagrq667p1houq9je
X-Rspam-User: 
X-HE-Tag: 1773286151-468067
X-HE-Meta: U2FsdGVkX184mCt8LH2jnB9qTaNcdTjowkM/PBx62aexduwAlnywxqa9a8rj/KK3qfE/tZNA/RSUYJusWYJWCiugyhn7kIUkcrAYEvLuHCuHtiF/S5I9NJS3dl+Ny9t/sEtpkzrizooax8q2ADoG4ue12t8uLV7hFyhlkCGp5DgatJr269/wrh8hqgkh+/NZuqQNFwHli74ROFlfrkfXFBkpY6oUCPNy4AD4H7/lX0jMHvoA5mVk/8ZnQYSV8r4fivR3OxJlg8m6EdkDQRMzD0REFOWxg0fKQWw3+588M0VfBff1z+8RpVs64+fA4IikMf3yrc4bBimaSmFGL57vajVKUEbIo0fVyp9jKI5uaMrKZ16aE/63SLOqysQ5hL3HTrh26DHDYKTfPXmqaw6AMSDe/QYWDZaF8rn+qEXpuWtOqklxIne+x89QVYEsyJQPlbdMffhVbisFpu1VP5wbXzVpRJzCxN6K/D2IL7AN9z/TNLix4TowbhIe5/ZXUCo18ns39aR7abU/Fj0Zh1rYQk0IcRJAA0qu08GimpW7MXYxfKcwBqVzjma2Q0u2ghvKjK7gWtMB7Lu7TstsjWLGmn4Rech3elcVcqsf0YUtyU2g4mlg0CvDj7+SrlSCjKy71tgjyo18ns5VFnDo2jNnYg+KR5l0bxprxhWAiUNjxni9+4AkQqTKAKwEFExR6Fj17Ebc7OoEfC8q0WETkt8r2d/TV0Grbse78bqrhRylSjo2KZai0MiIy5GjteoXK/zvXoBlhtu4i/pPi31L85a4aiPooyHm1R91PlsVtI4PzsATQ5AD6GbZyIDD41pCQZTC4Dff0NeES+C1g8W2hmANor8dVxn/CdAhJRJNBhQmcFU5foXcPx0UsvVJOxo/FiaJPJfvY8FnMQ4+s4/StY3dNuZY51Wa4Y8sBAT6LviRJKCP2lZkQMLWrnq9OHzGXeBvhBHCUprR/KMQv4AxU5g
 jCQ7SFwg
 73Nf8FqhiYnwXFksVYkShFW6l+jZ1FPaaT7Sns4o09sDD5OVyX657+yrviZK+lXw6CXwbJQLzIk6qXsKTV47aEqf1iaIX5FdOD1a1FPZvoAO/mHabkPdnzfEwm9LtAsC8lOO8oS5e6ZwZ0onNGLuhmk2+RhSLfeSUnc7G51Pwkq1l6RTZJq/5vwJgmYUuYRSzXlU/6F2s1+nRS6NDjrSryQ7tcUKRBNp7Zg9fCniHw/TOxSTywS0/eRKLcS80DJnZlTO/HA5QyqsNo5qwrmsjedWsVlOjq190k9FMxPzNxzwWTgwF1wNlSbag9tnVpzNoSHMH/nZZ2Uon6oqsYilGEhAUcP3Hztkre7RN3kZSLmHX2pwXFAkF2IGlC+h5fGCabeR5WeSpDpyUlDKxm+R/wy1wre7EgSDzOCz2WUo7Ube0bd9IoiyPQhMwKruaofg0+3+wB+Mrp+IWN2BU43lTUeyXN8L9QdPie/frSNzPgLS6x1wjNnTaFXegkDwC1S2Doy0RY1kH4AUWlrUoLe0ttH/EVJNQGFahXUGbFOR04xhNLish1ZynYPoGMAa8bSvM+0dW5IH8TzrzR1So/WOV6fduGKhfisby09gigbXDqU2NYyMqIkXClngBu47cEZq378hRFmHtMmEhIIdf8aePMk7Jpgo6g/ayoRNtij7kEfYa06mNvnz4nm5MnGu6fOA6eHsfLHSeazjkfUOp06hCq5xZxA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 11, 2026 at 05:59:03PM +0100, Vlastimil Babka wrote:
> On 3/11/26 12:16, Harry Yoo wrote:
> > On Wed, Mar 11, 2026 at 05:36:17PM +0800, Qing Wang wrote:
> >> When refill_sheaf() partially fills one sheaf (e.g., fills 5 objects
> >> but need to fill 10), it will update sheaf->size and return -ENOMEM.
> >> However, the callers (alloc_full_sheaf() and __pcs_replace_empty_main())
> >> directly call free_empty_sheaf() on failure, which only does kfree(sheaf),
> >> causing the partially allocated objects memory in sheaf->objects[] leaked.
> > 
> > Nice catch, thanks!
> 
> Indeed, thanks!
> 
> > Probably the need to fail new_slab() made it quite hard to trigger and notice.
> 
> Agreed.
> 
> >> Fix this by calling sheaf_flush_unused() before free_empty_sheaf() to
> >> free objects of sheaf->objects[]. And also add a WARN_ON() in
> >> free_empty_sheaf() to catch any future cases where a non-empty sheaf is
> >> being freed.
> >> 
> >> Fixes: 2d517aa09bbc ("slab: add opt-in caching layer of percpu sheaves")
> 
> Actually I think that commit was fine as it was using bulk alloc to refill
> and that was undoing any partial successes. I think this one is correct and
> replaced it so:

Oops, I missed that.

Yeah, at first look I wondered "Well, refill_sheaf()" doesn't partially
fill sheaves!" Then I looked at the code right now and it did :/

In 2d517aa09bbc did not partially refill sheaves as it used
__kmem_cache_alloc_bulk() to refill sheaves,

> Fixes: ed30c4adfc2b ("slab: add optimized sheaf refill from partial list")

and this changed the behavior by replacing it with __refill_objects().
So this is the right Fixes: tag.

> > I think we need to add Cc: stable@vger.kernel.org
> 
> And therefore we don't, unless I'm mistaken.

You're right.

> >> Signed-off-by: Qing Wang <wangqing7171@gmail.com>
> >> ---
> >>  mm/slub.c | 4 ++++
> >>  1 file changed, 4 insertions(+)
> >> 
> >> diff --git a/mm/slub.c b/mm/slub.c
> >> index 20cb4f3b636d..73b2cfd0e123 100644
> >> --- a/mm/slub.c
> >> +++ b/mm/slub.c
> >> @@ -2797,6 +2797,7 @@ static void free_empty_sheaf(struct kmem_cache *s, struct slab_sheaf *sheaf)
> >>  	if (s->flags & SLAB_KMALLOC)
> >>  		mark_obj_codetag_empty(sheaf);
> >>  
> >> +	WARN_ON(sheaf->size > 0);
> > 
> > nit: perhaps VM_WARN_ON_ONCE(); will be enough?
> 
> Yep replaced it too.
> 
> Added to slab/for-next-fixes, thanks!

-- 
Cheers,
Harry / Hyeonggon

