Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1D48CAC599
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 15:26:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43A938E0047; Wed, 17 Sep 2025 11:26:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 412508E003B; Wed, 17 Sep 2025 11:26:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D8FB8E0047; Wed, 17 Sep 2025 11:26:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 17C4D8E003B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 11:26:47 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BA30486CED
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 15:26:46 +0000 (UTC)
X-FDA: 83899119612.06.E93F8E1
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5E8E0100008
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 15:26:43 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=JPQjZBHR;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=s0swRh+L;
	spf=pass (imf14.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758122803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=+Eo9L8Jl8f4oczQ3jUePcWsRenTrY6Q7V9vBAkTU1js=;
	b=fuWspHvegI7lrEkhV9k+Ika+fV6v7MtDYW5Jw4AFlVO8X9H12xXr4GIghb0wOTuVpAbE+I
	Vk7aONSiG+88rvHdw/uLVn4bH27V6bKLRwJWwGke/pHZyBoezaiL2Qtvwqrpk3gQ7i1I9T
	FySttY7XxbZz/fAsKeZUHBU1bIKA8q0=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=JPQjZBHR;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=s0swRh+L;
	spf=pass (imf14.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758122803; a=rsa-sha256;
	cv=pass;
	b=10P5n2+GGU6JWM+0RLSEK00Hjm2cUJFndOJR48uNAz/bobuQRPAfWKH2rrdbdSwb6a8Syb
	nsCzfwM1BzY9yhcGWWTi3uy0YqFvsjwdzfLCi/NlhCHCuBsGOTJ8TW1+HY6l5ZiAGo8Zj/
	ml2fscQvFc620zR2egWvYUCK9j0ihHM=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58HEIRJY001776;
	Wed, 17 Sep 2025 15:26:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=+Eo9L8Jl8f4oczQ3
	jUePcWsRenTrY6Q7V9vBAkTU1js=; b=JPQjZBHR2smuDYGzi2EZFm83ZZGn2dPi
	Pp+IwEtyb5r7/Y63kOS+VtE/KgtH0GGcJOmtUdQfAXJIlry6GvPFXgojvuRkKZ3q
	yQh1poKgJ/BQ6WCf6vHCjFoh5ByCgLiXB2odLxr29SwII7oEsEfwncODtZAjmEys
	v0A8Mm36hm8wacS6i31oYSRtrgf+U0gbEl5BlFrFZC7pa3qj1oDYQb5gLEE3ld7q
	KIQxq0auqgLCAL3sjejMcEkFj/YNV1EmuY/wUFMnQNNmeC0ZALynB4FOhip9JFEj
	xGXGGMcsZzoZBn01+wk3g9lvAxJGVblI11OgbCA6CzSrcgO+8Pb8RQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 497fxd1h00-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Sep 2025 15:26:27 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58HEDoJD036769;
	Wed, 17 Sep 2025 15:26:26 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010060.outbound.protection.outlook.com [40.93.198.60])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 494y2dxwex-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Sep 2025 15:26:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TbdwIcHw5wghrHXSKMj3h1tRUWr068dqyrz9VhDAF3b8Y0d13X4gz/WT8rK35FSgugjZRN8bU55pEc8KCimQeT8O5PwEFTPIToUDWBph2pV8PjMwcXLA2QXXRgIUXeJW/7GTX42lRYfieqZb51KDBZZCrfFSn4wf/selVxY8ZlYSG51q21keLgjht3uZAnc84wqatPqAVrdalAVp3f/Kq06rgeEifDTllzEJWrfl2FBiIRPhkHhVyvxr+llWjHgqHcPOg0wS+FI/eU0BMys/68M3ORUcVryY4KFdo/S/7zf30jVRv+WrA51RRyfBx/+vFX8p4yqcWaHPb4vHPV0lzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+Eo9L8Jl8f4oczQ3jUePcWsRenTrY6Q7V9vBAkTU1js=;
 b=ouwuoEwAq8LzK8+iG92Qx0cxdkiRDEGapUA/ibb1zBuPOaCHUsToPKItqSNOtuXKY7pH+ChiZlKwnbnu6HNYY96ZY8eE00nBhPMJJCv/FyCtWimEdC0LCToqbyhw8d1oaA9h/FNbKPnmrg+NZYCkDysQrrWf7eC/iZXTvAc8JMLxqjfvhLadASt/M2bV/SGT42T2i10gzrmpYsKkzVB31qXJ2ZBar76Hz2PENCx4dVjsMJVx/HrD/LzoyBvep8HyNjbGppGlaoPrwMqD/xZ/iALIJ/X7u4DNBCpi6oKHdMLQugfw04XQ5kpeSRcdKa4NXxtyrWAgYpEMhmKj6rypHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Eo9L8Jl8f4oczQ3jUePcWsRenTrY6Q7V9vBAkTU1js=;
 b=s0swRh+LLtaCv8idAesmfcPMse4hsa5SBX7y/9YIqn8seQaGkGTLfG4CSvdLNn4tRLwh+7qJ/1D5iCZ1vgrQ2x0gPV/2ujJsgug2J/Wg+nXpY+nG/QZuoDC6BiC5Es/UztLYQ7zog6o7uEefNealKU2myYV85jx8Qv1R/1jfVEw=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by DS7PR10MB4942.namprd10.prod.outlook.com (2603:10b6:5:3ab::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.13; Wed, 17 Sep
 2025 15:24:20 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9115.020; Wed, 17 Sep 2025
 15:24:20 +0000
From: Ankur Arora <ankur.a.arora@oracle.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, david@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
        mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
        acme@kernel.org, namhyung@kernel.org, tglx@linutronix.de,
        willy@infradead.org, raghavendra.kt@amd.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com,
        ankur.a.arora@oracle.com
Subject: [PATCH v7 00/16] mm: folio_zero_user: clear contiguous pages
Date: Wed, 17 Sep 2025 08:24:02 -0700
Message-Id: <20250917152418.4077386-1-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0238.namprd04.prod.outlook.com
 (2603:10b6:303:87::33) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|DS7PR10MB4942:EE_
X-MS-Office365-Filtering-Correlation-Id: 12347aa4-15ab-41bd-bd40-08ddf5fe45b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
 =?us-ascii?Q?W4EylmRvTOUSI4hqGh1iuHs2hgIWdfFVzMGF342YrcUsFYOk6RUjLLT49cTP?=
 =?us-ascii?Q?raK72eakI9IG6JmT+qP7zydyD3rls6wnl0UhLVAnXz9BOf8pCYogOeInwNah?=
 =?us-ascii?Q?CPCr1tbp161e+nyjlTpxY5hvyMF6wOQ8pv090zC3LF/dQY9p4DCy2+Lg8ONY?=
 =?us-ascii?Q?WNBuRV5h4L6z1BjVWsN5buGZS2oUN+vQwkuEMtLc64F8EW0zV7C4G9S6DEob?=
 =?us-ascii?Q?wPG6I4Bja6v9aDOr/h7DO4hoY9WFtZVBWqpmY1ZQFw7mpYtuM/oaO9wjPVg1?=
 =?us-ascii?Q?tJ8oeodwMWyhOGlkFGz6zbtdrB+L9wrW9mNHmMCB111IAIQdz94WfUhGH7vv?=
 =?us-ascii?Q?dM/f2aNGDDZQC4Do978hgD8Aij2TnHMjU9sfrdBSnb8DA6NxzodSSa2DNt6n?=
 =?us-ascii?Q?osEQnQNC3OW3t7MIhTvC7KOjRydAme9e8NIz506M0431fYgaPWuq23tXx23c?=
 =?us-ascii?Q?/xX3yRkpkxIN9FwoPNvFpb4avFCXRf0UsoubSnmhuHYymJLE9gu2KxxS+vIa?=
 =?us-ascii?Q?eanweY8H6qHaTEj4YENAdv9fZGgeNpUxya22rsFX9sotzDFzqsVPZOC25N/b?=
 =?us-ascii?Q?9B8Kd3cWvkPVn8J1bkHdhguTcDjZXwejxqj4g3OG1pK1u4cV2XlF385m3z8B?=
 =?us-ascii?Q?apc4YSgvVNRBnTrvXBPlwY0Km0ukc37J3zPSvd5zgk50ebPmiBxlV9PpiBBY?=
 =?us-ascii?Q?hZzkDJkU7pQvtySOPHw5OdD9KZA2q4hb/ad0AYo4dPol266/seAd2RFevbD2?=
 =?us-ascii?Q?PecYI1B+VlDEG/RjzJM9bNoyENZKqWZj9Ynu2jC1WhgVZ/IuXzZAh6mDjNYA?=
 =?us-ascii?Q?AYJX3ALTv/Z4nWzMqHBTVgua5TmYq0ZMTr93VADqkj8S2Vd87ZqrxF/74+ZZ?=
 =?us-ascii?Q?cnbV658qSLd9vmrxBkxIhDw7UopbOIC+X4yUro7VvPBRPMyghYKTOcBtY7O2?=
 =?us-ascii?Q?LA1NPqPzhNZ6DR4IOtFbcQh1kC6spIadK8YmsT4tgG0DElZGblbk0TP1TT93?=
 =?us-ascii?Q?k0uR367M2sTlCdIUhDfV+toDfl8UGaVded0GYftp3Jq6NPoxcK6voj7maE+9?=
 =?us-ascii?Q?oiFE3WYenBKH7BEdJ4N+trSya1ABHoowfOGq42hE+WTChAbv5kRtiNO4yuFT?=
 =?us-ascii?Q?+o+UmO9WA/CxYx3OvU+UbGXbmJSWQXhCWtlk/Hp9rXiI7WCUn8Mud/4I5+d0?=
 =?us-ascii?Q?AfBliy941wAdnE+lxsYuOIpWxhzC/aPESTe5lOubCcyAVND0zBJJ6SNqbMi4?=
 =?us-ascii?Q?JvKTV6HxT30MmfhJ6qX/35cMeXJ/m5XHDSpul5IL/abgtAjIsAMAZhKSt7t5?=
 =?us-ascii?Q?VIzKGb4Ax4QfotlgruB558z4xCs/cq181e1xWApE7qH/Nsh+H/VeGl1M/yYc?=
 =?us-ascii?Q?fx1C0+KsZS1HAYkd5FxQIGbGUHdA?=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?KNUNHUGkCgqAUGKQLV7M1SNIPfOKW+Q72pyWZnvZqViqpHt6zBnpzDxslnAL?=
 =?us-ascii?Q?irXm/ADDQ4BUIgxnYw4aMh0nAQ1EJ89Z1l/gr7h6yFpWfS9UeUdr5TlTgnw1?=
 =?us-ascii?Q?wT2/LG31jVCFuf/vMVaA2gNrxr7aodeO0VUMUQ6YcAWbizGDeC5AzKAMMV2S?=
 =?us-ascii?Q?seABubfpGw56UtOyaf8ZD/VVlVYwQC+VB2upbstphIYMh8rxb9AHctO7631p?=
 =?us-ascii?Q?Ku9C5IOt6l77qt5+AwSoMsuy0jNekqrRBRYiMd5/cQb+7bYQGsCjlXovDOfh?=
 =?us-ascii?Q?g9c7i6yV/1gsXxKH/AnQod3YgC7ouq8zXUBaxNkhERq4QiJmClJ/+E5Ds14O?=
 =?us-ascii?Q?kYLezoE7g2YSzVMMALkjplGH8k9x4j5HnmNw1XQAutGFjL79fMnKpvX/KkCE?=
 =?us-ascii?Q?1OwR5dNuHmcneQeUY8QmVAaYuYQAkar5pw0wW3Gwi0H/mA/hpYhlDrYrelc3?=
 =?us-ascii?Q?tlBCMDoz70Zt0hBrVsPjYElWkabR3oliO4By5Iq+Bci7/OzK1NhkDzRucfhx?=
 =?us-ascii?Q?T6KUgpe/IKdBWuImq9hz/6RC3/lJuaksMvEoNjiVLTtbzCBNXXIFVugNwT0N?=
 =?us-ascii?Q?a3GiOwUnsaT9w/l4sklD+YwBcqddErgC0Jl7NSC/LgCrU9sdX7BKZJuJFPKe?=
 =?us-ascii?Q?DOwao3vp2JPv3gar+jpDE/5ovm5gkFG0YeOO6vO7yYf4HDE+VIV6AdgZLfdi?=
 =?us-ascii?Q?E8vEXgAMqlwaXMm8LwSWsf5MlEjIqbxyzaUON1iGY7aaW1nn5ZbSYPYUWjqy?=
 =?us-ascii?Q?WJq5ZIsERRpz1rS8Q/R8kDNO9IXgu+Mi7ql9dFfRoXhlQrDaXfnxD059QlXo?=
 =?us-ascii?Q?LfVuvWCpQGD50/b9SbexBffonQ+szBKw8tIPcAOfRw8So/u//X05qoedHrdT?=
 =?us-ascii?Q?iJnYGNGKfSqBSABRpIUmEfntik2ORlKK/xfDJmssGmmxVX6xgYfjjV3fT78A?=
 =?us-ascii?Q?UPRqaeX7Tj+vQY/qNxW4N84trNuxNGPP7tnBhSYdZOKRgmOr5QJZ/RULZh4e?=
 =?us-ascii?Q?xiSWSCxknJWrA4qdF4xHFd3reQF/CJpe1TQJ4lN+fVoGbCHtg5bbNeTXsEPx?=
 =?us-ascii?Q?w/oVK1u62QBO7R8ftQiuCLnx1GUIw3An0XEqf5KnaqzjSLGQhF4IFCnlVRw9?=
 =?us-ascii?Q?WhC9VjOFaZbJhcwNl+xgx93C7FXfCFx1F88yyKZ9JnUeU0OPAYa11bD9V9L0?=
 =?us-ascii?Q?JVL89kB483rb9qwwO8PXAVyrgsQk2zRp/I2rHYonPSTzfoghiYtmXx0gnM+A?=
 =?us-ascii?Q?YLJ6XBGSZlQHR+iG7LzPJYUCfwf4xn369ZhJUUHxuYFpq2sSLiY1umGkSz4d?=
 =?us-ascii?Q?aTfVEVQE8D7ojZm+wlghz2IMNYJF95N+qHCw4j6YN6OVhR5NAns7QMFpV3Zm?=
 =?us-ascii?Q?VemD8MTSUQCq68PsUWmNfo1svao6ktfFDiiqLcVk0eZ5/TJnvmG1mBMiVGtL?=
 =?us-ascii?Q?Sd/Sr2MWpGKkFXwh62+X7vXKJ+fT9FCNJdCHnkJgCl2iz01HAmLNPfvfN842?=
 =?us-ascii?Q?vBKsoWP8qrkkkqwVP3ar0sDs0E6eTxzcpJMsfmCVIg0/EbiloFVtTrIHmUFb?=
 =?us-ascii?Q?Dl03YGVN+KiR1JnSvHYFNXKqRDQGI7OZpx9d5nsADVN9GASJGas7XkbHW1Iq?=
 =?us-ascii?Q?SQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
 8cH+7MbX+sNDCYzHPktbquVNdgXiUajBb6T3hakSzxegp3oftccn2L/BpgainNIC/ZrXexPm2npOv7jkBC9E30hmp87B+Lu0JLJnV8JpfWve7FveGCzhnSHnebVigwc/i0YiADjdFSZ2Lgenjz/wLnXorbssEigLtUJQv62qmeK/3ClLErGj1f99inSfiG9q36md9rH5J1Dq10sgyUEy7lvi6BuJ6H4ClwP3qbasof5/B+dFI0/3ocG46PJywk6C7ihOF8/0OtQqxFoNWLQMoXJl0qK+q/DcaAf6be48cM7gnyyTgea2urLR8UonXt4JI86Ei5a4ao66k/4TxXtaXIBup4W6606a2N9lhtQ0qs4j2ZLo32wvnKwvLXtb2JVeaV1smfui4ebAD7bjOejS3YLxOzKM7dmSSZ0SKhtgDKcOnr/X4S+f2EeGhyj3VSg3RbN7dpFMAMs5x7L5dSq2p3Mvagrf5SXXzS/O6EcRnL2V2vXjo+QilEOqh5wB9qYLvhjvvomqsLDLdEtwIRRD+t80kKHk2fNf3JZyYYkkCgT5HlBEl0J5F3inCNwe/R1pDYTSI877dkVRhI4IGPSVvIzrEpU6G18AY0v5EUsc0rA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12347aa4-15ab-41bd-bd40-08ddf5fe45b3
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2025 15:24:19.8544
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wgwsXZyLnPLsexxpEHs9Obi/blbcxoFvac+VihsrI6bhOlomjFGXU/nnL/ODcovM2HjXYUp2E0bMdx7KufDtTA2qdSDHud4cioBbhyQGTKo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4942
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-17_01,2025-09-17_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 adultscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509170150
X-Proofpoint-GUID: uPr8tJPcBk2F8qkcmNFNkCZeZQf-MiC_
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwMiBTYWx0ZWRfXxcLEwu/MLI4k
 d/fDHoWWqKg0C1qsEPTWJ4QGqHMaqc5Kqmx5nHjMlmWWQkeCIypf0lfQtfVGUP4PyLz9osKbpJi
 eZ4LYXh8Wy/hHwAuXO6TrpkkQ6hXrEElkppH2KrgFZaaf2e0iUs3TVDR5D1lrWcgehpi7XgIDSE
 t6G2Oz1/bqZF0UQGe9/Qsux9Bx+DtnztCPhY386pean/7cCE8D0bAzdImvqmaxFq25TwQBMORlz
 rnZWMKNX/fiy9cXzuugrqG94uu/0gWK2pE253+tL7MuTIi6Bh4FOsbD2UoTcGe5hjh01pfZZ6kL
 VdMkyUP8w04Bh/1qvP4lKLCMS5MPW02ctg0Kvi8gSpDmr2lZqxm3hhCVDfmho6nadHkG+hhdxwd
 AmH5+az6Je8/hkM57kgp1/reCLAnmw==
X-Authority-Analysis: v=2.4 cv=cerSrmDM c=1 sm=1 tr=0 ts=68cad323 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10
 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=zd2uoN0lAAAA:8
 a=NEAV23lmAAAA:8 a=dwtZxa6-cFIMZWPJcc8A:9 cc=ntf awl=host:12084
X-Proofpoint-ORIG-GUID: uPr8tJPcBk2F8qkcmNFNkCZeZQf-MiC_
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5E8E0100008
X-Stat-Signature: ioekhxr4fii7fhxyg5nxrompt98at9un
X-HE-Tag: 1758122803-388674
X-HE-Meta: U2FsdGVkX1/hSZ2peJ11SJhyUzMxts9xinI9TNiEBUcQlmdUcoFsEI9Fls4x9RXcIKd8wOyGzLbJAfWqVMdW01RT/8qA6H1IxSQ1rk/wlN6bOs2o0U+xT3uNvnjZtdxsA5Vysz8pX3DhmXpsV+eooh9z4MdHg0C/GPXrnRAqa7XqjMp7iauaevYAINWVtwD0YH/3Wzpx05rBRJXv0TKALtfj71buxfE+4JhrCRqcAdP+ah3qWqDIK7vekQNHh7z0HUMHU3hBDz3PDmfh5Qm9ngoKJUKEidsZBk0UY8nIC4ljloxWzuZ1bXfgiiC/G+ik+1pEaojO0ZIIoL2+8LMVlhUAS/lqtl5Q5qyPPcs3WuWxr07zu2t//dH28vTWYaKpVAzH8VXCmMH9RIOQNUic8qQCvXhy3g1m5MnAzMlCz0pRo7d/jGvYo78a8xUngwhEyLrlCVIXV/q1vuRS7Xxu8qt+YecratycyTfhuWAB6jYFjNBwEeRMyzd1FgcwvpW8COQP+dVIcodqWojnxqBfhNyMZT3Y/Ud5ScqO/rduSxDqmFn2dWYHzaRM0nh5pTd/BksNiBwXNx6NN+PJDRuQkFnwsAzLKiwtWgTN+gZKMonO/0Z5nZtURhviGBMRpdTJxtLmrQifWQGoBJnhonvLM6r3YypWqqlMlXrk+zfrxsjzrvDK3bj29ktvdZK67Zvos8y3bQkwbntSHye5YVYjmbb7eGNzq9suEtImc15drjN0APbNDdBDpc9z4nqtDrREuBe5A5cwmA9WgWJZHEyNTTLdP9qeLsoMtcTHMKWlJ9UWdElll5Puqe+FQVFeuLpO6rJdZpLHrxPUmlXRA25ZBXf9IwR1gC6bye+iO4vOrgp2d1awZMIuNC1VyGUhkvENQp3BMkJxBBfJct+dw6HPN7XLOeQemHqoR8VHi7+J4jkowNWVlXt70Ji9AbBoMK1EWoA+2mjW9W8tyQUOuRp
 espabk/d
 2T1Rp2PxnNGGxhP2Zvxt6x8y6cgQuXhjVbbHHUo/uWg0dNAq6LYdbBhNX4ZOk++4lTaPqduPe4n2/8ZQdShpjxlYr9EK9Y2d20SVKruMj1kTsJqJc0ZKPPCk5n4RVLh2ICraL2djzKaQw7Ih9KaEZTOU23dAV69NS2qsxtBb/f+fENx4FBmphdfxVllPQ3LXYAtP3aEwVQ/VstsLFOWdTt2MRDgY5+3yij9xhuUYqQWd4zrb6ruUOLJDRPNU4nGT7LkBZA0Cxrl2/wvRLy5cuprlGnL3GuzixtI2zuBm3Hyz1H5yRRVfZwGkvAir2DhegKj/wGWzAVKWEugTj9S3lRdk8oZprmYjrw1T4OJihKJXinkt3sOs2PQsdz3xexJc5azPjFLO2V1yZh5pyz8CB7HJqvhqukTueiU5GowAXaoLd5pwtBm59HT0CJCJW3qV96JYNzKK1JVkB+DVE1JXtKWyVyqJwM2/zA5NhRR7gSeFibHeZxU4kpwgWPrsQw25aVTvz4AO3ux4mzrc7OvlnPxGf7nCg0Y1botl+01AuUDyC+9p1N0ZZSTtj5/8bqlqK9MhE8A0MWzev/Pe5UChbn8gGa83IxBpjuZt2WQG9eyHHzrTnA9Mq3EEcy0DDcppazPr67sYg+1jf+kJxL7AHfiGAHzUZLIECbaPs/wtnTuCmfoiQ+vG8CUVPyT5G9Zn/GWAyd6Ldlz167/ixsdKk2n1BV3QZYZScqCmISBnFr4j0d189ansBz5CGZ2EVd3iDshNWr73l01aEMT7hvK8Q2jNExDWnWtrM0aSRynuybNASxaeoWBn5jt+t6/CsIKekQzINKXp4TdT5fNiucyX+IF+N2ujO91K5vRJO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series adds clearing of contiguous page ranges for hugepages,
improving on the current page-at-a-time approach in two ways:

 - amortizes the per-page setup cost over a larger extent

 - when using string instructions, exposes the real region size
   to the processor.

A processor could use a knowledge of the extent to optimize the
clearing. AMD Zen uarchs, as an example, elide allocation of
cachelines for regions larger than L3-size.

Demand faulting a 64GB region shows performance improvements:

 $ perf bench mem map -p $pg-sz -f demand -s 64GB -l 5

                 mm/folio_zero_user    x86/folio_zero_user       change
                  (GB/s  +- %stdev)     (GB/s  +- %stdev)

   pg-sz=2MB       11.82  +- 0.67%        16.48  +-  0.30%       + 39.4%	preempt=*

   pg-sz=1GB       17.14  +- 1.39%        17.42  +-  0.98% [#]   +  1.6%	preempt=none|voluntary
   pg-sz=1GB       17.51  +- 1.19%        43.23  +-  5.22%       +146.8%	preempt=full|lazy

[#] Milan uses a threshold of LLC-size (~32MB) for eliding cacheline
allocation, which is higher than the maximum extent used on x86
(ARCH_CONTIG_PAGE_NR=8MB), so preempt=none|voluntary sees no improvement
with pg-sz=1GB.

Raghavendra also tested v3/v4 on AMD Genoa and sees similar improvements [1].

Changelog:

v7:
 - interface cleanups, comments for clear_user_highpages(), clear_user_pages(),
   clear_pages().
 - fixed build errors flagged by kernel test robot
 - move all x86 patches to the tail end

v6:
 - perf bench mem: update man pages and other cleanups (Namhyung Kim)
 - unify folio_zero_user() for HIGHMEM, !HIGHMEM options instead of
   working through a new config option (David Hildenbrand).
   - cleanups and simlification around that.
 (https://lore.kernel.org/lkml/20250902080816.3715913-1-ankur.a.arora@oracle.com/)

v5:
 - move the non HIGHMEM implementation of folio_zero_user() from x86
   to common code (Dave Hansen)
 - Minor naming cleanups, commit messages etc
 (https://lore.kernel.org/lkml/20250710005926.1159009-1-ankur.a.arora@oracle.com/)

v4:
 - adds perf bench workloads to exercise mmap() populate/demand-fault (Ingo)
 - inline stosb etc (PeterZ)
 - handle cooperative preemption models (Ingo)
 - interface and other cleanups all over (Ingo)
 (https://lore.kernel.org/lkml/20250616052223.723982-1-ankur.a.arora@oracle.com/)

v3:
 - get rid of preemption dependency (TIF_ALLOW_RESCHED); this version
   was limited to preempt=full|lazy.
 - override folio_zero_user() (Linus)
 (https://lore.kernel.org/lkml/20250414034607.762653-1-ankur.a.arora@oracle.com/)

v2:
 - addressed review comments from peterz, tglx.
 - Removed clear_user_pages(), and CONFIG_X86_32:clear_pages()
 - General code cleanup
 (https://lore.kernel.org/lkml/20230830184958.2333078-1-ankur.a.arora@oracle.com/)

Comments appreciated!

Also at:
  github.com/terminus/linux clear-pages.v7

[1] https://lore.kernel.org/lkml/fffd4dad-2cb9-4bc9-8a80-a70be687fd54@amd.com/

Ankur Arora (16):
  perf bench mem: Remove repetition around time measurement
  perf bench mem: Defer type munging of size to float
  perf bench mem: Move mem op parameters into a structure
  perf bench mem: Pull out init/fini logic
  perf bench mem: Switch from zalloc() to mmap()
  perf bench mem: Allow mapping of hugepages
  perf bench mem: Allow chunking on a memory region
  perf bench mem: Refactor mem_options
  perf bench mem: Add mmap() workloads
  mm: define clear_pages(), clear_user_pages()
  mm/highmem: introduce clear_user_highpages()
  arm: mm: define clear_user_highpages()
  mm: memory: support clearing page ranges
  x86/mm: Simplify clear_page_*
  x86/clear_page: Introduce clear_pages()
  x86/clear_pages: Support clearing of page-extents

 arch/arm/include/asm/page.h                  |   7 +
 arch/x86/include/asm/page_32.h               |   6 +
 arch/x86/include/asm/page_64.h               |  72 +++-
 arch/x86/lib/clear_page_64.S                 |  39 +-
 include/linux/highmem.h                      |  18 +
 include/linux/mm.h                           |  44 +++
 mm/memory.c                                  |  82 +++-
 tools/perf/Documentation/perf-bench.txt      |  58 ++-
 tools/perf/bench/bench.h                     |   1 +
 tools/perf/bench/mem-functions.c             | 390 ++++++++++++++-----
 tools/perf/bench/mem-memcpy-arch.h           |   2 +-
 tools/perf/bench/mem-memcpy-x86-64-asm-def.h |   4 +
 tools/perf/bench/mem-memset-arch.h           |   2 +-
 tools/perf/bench/mem-memset-x86-64-asm-def.h |   4 +
 tools/perf/builtin-bench.c                   |   1 +
 15 files changed, 560 insertions(+), 170 deletions(-)

-- 
2.43.5


