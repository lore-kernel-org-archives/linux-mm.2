Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0061ACAC599
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 15:25:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C73798E0042; Wed, 17 Sep 2025 11:25:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4C188E003B; Wed, 17 Sep 2025 11:25:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A754F8E0043; Wed, 17 Sep 2025 11:25:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 82AA08E003B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 11:25:08 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4EEAB1A05BB
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 15:25:08 +0000 (UTC)
X-FDA: 83899115496.18.AAE1AA5
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf01.hostedemail.com (Postfix) with ESMTP id E9DCF40013
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 15:25:04 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Qo9oF15n;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=vZ+YcbDl;
	spf=pass (imf01.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758122705;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1jhh2wbXgvNKGlkz07LK3EJ3G2Jr6Z6dAyuV5F6P0xk=;
	b=8eLEIa0A7TxUk+y0TfPa7qgnhdlhDKORc4UudAInbbIrwE7Q8/p+GHREgNApezFQJQHOmR
	wjpYIpvHvAo+IcocUP0om8Buf8ZX/MDV/ZfFOVR/UHvbnITaAsH87iJ0jPso9mA+UlfUkj
	6TSrSOQp0O9IAcfsRjC/0o1KZvlbe0g=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Qo9oF15n;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=vZ+YcbDl;
	spf=pass (imf01.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758122705; a=rsa-sha256;
	cv=pass;
	b=Z5ER4sS6uBKA9Ajmpo2LVyA7ChwHKd63wfMFsOjqUszmZPwhtpu4fJcbiaLyezGPETnIeY
	llP+d8h32PED6uH5/U1wAENN6kpNl7r1hGRsU7AgrHiidE/iB1pjXZiOisQGSOlPBX9xX8
	d+Kbaoc/dvq4y3Ixx5AcQKTqbb9JUSQ=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58HEISxZ007341;
	Wed, 17 Sep 2025 15:24:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=1jhh2wbXgvNKGlkz07LK3EJ3G2Jr6Z6dAyuV5F6P0xk=; b=
	Qo9oF15nCG8GGsM7dHIDGb3LuqI8TzIZmiGN1vQMa79CqqZu9Pw3w8FwGpftvXfm
	sSgckhDFNbfVZh8EUxuyT4RcolcBXzljQNV/TSylmX68wMRCegZd3e8XmoGLJvLh
	uF6dSuBCI32+oH4Op6PZkSaRrWvJ1RqAAQoJ6pCpacUQ/s8ErKfwdKTQWLdQ5/+O
	Wr+BtFQx38UuKySokWhIcLU3bHZPmkTbJYNs4AyPNVw4eQV/+IGcckix46JqeJuq
	E336x68DE2hvkoa+E2S1yeP1cxvs0lBWeuKHbmfhm8whJ6mu3Gi5ENkmNnHJWuNl
	0eHEpGz9DrSicNFF6qFt/Q==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 497fx91gsy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Sep 2025 15:24:49 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58HEm8dH036930;
	Wed, 17 Sep 2025 15:24:48 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011054.outbound.protection.outlook.com [40.107.208.54])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 494y2dxufg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Sep 2025 15:24:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MuGxvxP/YQe76pSKJEvSj/b6f8BhE4GU1da0jdzLZX8nrCYyY64ORVbsmeE+8ywV75Brxe+YkGguPIuCXoENBgRE1ceoETMjUa33+rGm62VmD+H5/+qhJneDWrKNCytuILzHppe6gVnB8VILd9FjY3Y9GpMy+2OS7erJeKhcIOc/xyZEM8oWDh2ckUbEZStdc4ugTj26buAMRzTprRAYglg6k1eq1cDOfw7L2YG2jPCErTH0SvnOzgoa22rmLe5UO7QUbo2bERMy5bnFcDr+bKQWcMqVgvP9a9pKNS2cVsNoPkwkRwpa6bDHP93Pi3Q5IwJifm267H5yREUBI+DmmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1jhh2wbXgvNKGlkz07LK3EJ3G2Jr6Z6dAyuV5F6P0xk=;
 b=tNdOgFAH1o0BvEmmpU4YqM4g97vPpsfOLcdfbNHkGFkRFGUDAeyJIFh5oJcqbMsIC81Xlw+WTX/Z5IxNLQlFUbBQsBmSQBtIos+fuKYd1zOQZFuAI2tNADj7mfjGGQIEQoFhEKW4VObQUyTR9a5M+cKBVfp362FkhRKr4LbQ5+SzsiXydbpMU3MYXmY0+9kOBmwrLAQ+XbSMn5BIBlp1jrU77U/ezw3q5T0oiLaVwiC8D3ArV0EwwYpvMrCgjLxuxTql9ALL0xb3jeQD1MK8ihUrqovzUrXsCjJJg+8WyjpxrqictrsCvBN8Pxje7LRrz3SjisAywM8/GFHrvYDPlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1jhh2wbXgvNKGlkz07LK3EJ3G2Jr6Z6dAyuV5F6P0xk=;
 b=vZ+YcbDl2qoEu0d3v4Q0D5YjLQYj6Pdez2rCUiA5msjn7vGutr2VoaqG9l/ijtAO51F9KTAwwaKtF6ESD6PzA2oUT6lZX+tvhgE7yHEew7rTF1ylOHx3tu0wvvmre2Aa9h8eMH4V30JyOFRxXLtRZYqyQmaIPLL1DSxv+AzlNZU=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by SJ5PPFD020A49E6.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::7d0) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.21; Wed, 17 Sep
 2025 15:24:41 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9115.020; Wed, 17 Sep 2025
 15:24:41 +0000
From: Ankur Arora <ankur.a.arora@oracle.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, david@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
        mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
        acme@kernel.org, namhyung@kernel.org, tglx@linutronix.de,
        willy@infradead.org, raghavendra.kt@amd.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com,
        ankur.a.arora@oracle.com
Subject: [PATCH v7 11/16] mm/highmem: introduce clear_user_highpages()
Date: Wed, 17 Sep 2025 08:24:13 -0700
Message-Id: <20250917152418.4077386-12-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20250917152418.4077386-1-ankur.a.arora@oracle.com>
References: <20250917152418.4077386-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0176.namprd03.prod.outlook.com
 (2603:10b6:303:8d::31) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|SJ5PPFD020A49E6:EE_
X-MS-Office365-Filtering-Correlation-Id: b0716c09-4eee-45ce-334f-08ddf5fe5256
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?F1/luQa3ar69KbRC9isGlwcjOdsc5LcXYo2Eym/TJ7h6TL17XNJhFwMHSRaj?=
 =?us-ascii?Q?20qbLlTgSj2+3u5elOZb9QPyIP/UiwK7ofDjS1NFCj09mZdP0nyw7IHXsU7V?=
 =?us-ascii?Q?xBoMpnFmOL+NToFu0tFUgLPh+B47a4VqsLWKm+en4MIFa5cbea/6QPpEqSYJ?=
 =?us-ascii?Q?X3CLKakdxX+lZAFR3IgETM0vwGyv96PN1YzCfISlwAZiX4A3mIbVK2t+1c8t?=
 =?us-ascii?Q?Q6E3IsQbGaTNYOqxxxc+2TyGlZ4kwKig32Li/uQYzybo0nbGtNfALoIyvqiJ?=
 =?us-ascii?Q?dwqL4YgtFB0n75QjIfV+xBC7T7OrUzeYgODQGDSsAvg16UIBfMXP7NbDdGM4?=
 =?us-ascii?Q?UADVU+QCjPXiJEIJO9yn4S1cC29c46dLAFodoZ4+8zQNQ40+48UsyxK09DEZ?=
 =?us-ascii?Q?WP/H63/0sc4LsabHpzPvKErU6tV+K6+cD0dOh3SU2zg6XHkSSpeUKFxb9Xpy?=
 =?us-ascii?Q?DVhKuc14IatwIxx4tYQHuGVpBja9Jwywt4SsMFQQ0sRt0IP6M2VsUYt7cEtb?=
 =?us-ascii?Q?9f+oHysCrBmVU7Bd27iaoP7uzzcDM4IM7vQk6IP05mUtB3+GZ0oXKbyKbJCj?=
 =?us-ascii?Q?kj7tc7hnDUgBIh6q5linbtyrQJOK+NTaDRvm1U0kIJShZjUmSXr3AGn8D5mN?=
 =?us-ascii?Q?/zB3Dshr+t8nBG3vqyAyigbcwS45Lz8enHnGB2NVY1E1MLO2IItTHjmQ6g1+?=
 =?us-ascii?Q?nMDci7j4C2gKKiO02V6hzqbrt/eYZifddGqlTKhK+GiZBmpvhKK1m3IeFK2P?=
 =?us-ascii?Q?ZtOSKUrQpoKmQCeOi98rqsHPX0QEHKhkCdzobAKO70C4xYjOuW6XuCriA/Wl?=
 =?us-ascii?Q?KCWiByHbCy0zCx8MGquEbLqmV09V8vpQf9Wsr3SQmUeTpEjF8Ow6DZXtk9wr?=
 =?us-ascii?Q?FQF3lxjKz3hCfst7140cD2Zb2oQ3zIjgIEBT9XOFG8knhK3GftY5XZ28PYsv?=
 =?us-ascii?Q?8Fo5Bq7J+fc8AY5BODZio+3s8Mx1q7MXg0vC0cX+j2k3HIp/lP8tWfUdRi/+?=
 =?us-ascii?Q?nQPxjU5trONcBapx4ifyiMe+0f036FBfIcYFaidz8I619N8+tzrbP2do9rP8?=
 =?us-ascii?Q?AgkHGNLsMr3qn+Feht6JzkbO4Ku8ACBzMyt1cjId7FWpRheIDENin7iHJk+h?=
 =?us-ascii?Q?sFJ/g0kCuFIPNBqKUhh7Uw3TZQsYcKCID8/83Og3AP9XHdnm2zR0Wxk9Kf1z?=
 =?us-ascii?Q?Qq5DsQRlurWhfU59GBHzILgVHw2hmCsRMOzLUI4WT/rYeVHsdawSgNpnPjev?=
 =?us-ascii?Q?wcmp58xBZ+pS3LCyID6AmCaOTU7cZqf+7uRVmy2veeWVmqEVvMzm8WfjsO89?=
 =?us-ascii?Q?pzSd6BT9sQ+F5veB7GkRzJuhC5xJYGEt9q4uSsB4AtPe3JMzPX+FI7PoupoE?=
 =?us-ascii?Q?M0kKBRk+xu4Q+Gw+1YV8cI8vPxXUImEsnpid9u4MUyCHRtxZ+Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?tX5jAygqLRF0VvhWPAswLRUIg6+pBs0ROUhYbaFyN9/bb1WztXfmkuHGqydY?=
 =?us-ascii?Q?NbMSF9z2UiSMUqiYIgwPtOAvUWnYq2y41Vv/Cg02FaQoxXuZ9GAUfQKiN6LY?=
 =?us-ascii?Q?Gf/PdWah3FHub17l+E03ryDR0CqbJBQm+gV/yu2L+7uRi5LGmg0dRrY8hvKJ?=
 =?us-ascii?Q?2cBacn+kD1y9VG4H/dzX4RRvrdbZweNg9sV1hFakomB7ORwaj8KMF48YLjs3?=
 =?us-ascii?Q?ncG94+mjaBl8boqDbFnDE2FDodDdGdquqUzyIojkuMJhCrf6oMkg3jLE9Q8r?=
 =?us-ascii?Q?6oSKvuZsg1WYQIkSeq3zXQu28TkRZOPkVWon8kwnpJbFEuaprQNTiyDufk5W?=
 =?us-ascii?Q?fjMjPr5BFSjkfdDDpBKkVSndu1TU1l+ZJ4VRBq48mfvRKllBpd+rhPfYxSoC?=
 =?us-ascii?Q?FNgFr8znCbnO8ck97lsQhr9CQTPmes8YpHriKoHiwYGAShRYj2eRFw0Eugu6?=
 =?us-ascii?Q?0A8W8HHcFs8Ihu4roLooty6bGiDRjuN3rvt3jtXM3TgTvSvvudQ6nJZeuMGP?=
 =?us-ascii?Q?Fa7FwkN4zTp6+4beQdBboMmMh7Jn7KlyIr8ltgWHMMtcvspETwJoWJlpzJ4I?=
 =?us-ascii?Q?NnE4N0yHEiErcrBHFtn+tQ7ppj5ApxcDi0LXLY6fZinWqSSkmiEJuniJ+TRH?=
 =?us-ascii?Q?b4O/Dn8EnsCyzLWGQbNHIkTGWcS2WPdgNJANFac5UE3E1uhDF0F0U+VDA3g0?=
 =?us-ascii?Q?1sfKrHclqFiG4RgqhVmk8aNE+XkjnSIjBzU/xY9+APWbVCUwEei8ar8Fc8si?=
 =?us-ascii?Q?3+Ighk9X2Yu+7eis2YHCtiD0Uxjp5UmnBj0T57XgVQ8RdQowLVJrgEMD56xR?=
 =?us-ascii?Q?/3SwR8asi3SBebolrAellLXd93tBRj9kaYzF1dO8o9DEs34uIDL0aQUJD37q?=
 =?us-ascii?Q?2e58KvgGxI8pZqOz8Xpaq07IlxPGwENxoXBw88UWaUCIxWAhgomvFtQgjev7?=
 =?us-ascii?Q?Vgo/H2DoVyGPeRm+s2sfpvHfRLRVPsIQndYnIgoNAz8SIoPFon/foyeKTy8p?=
 =?us-ascii?Q?Uq8PaZ57x33LolTfU5Drew2OOaFyvxPZ+2JMUFkRzejdxupxSFPXqVNwncEq?=
 =?us-ascii?Q?Z+cG9g0VWX4BuRFBW2UrLr8NJ+c+hUo8AuiCCgMxeErfpuezHw8XQsawYefX?=
 =?us-ascii?Q?G9z1zOSqbX/CZ9umZcmUytMvysfcNQ7Hxd1eIfTOVEpTOI1oyHiFx1sro1d4?=
 =?us-ascii?Q?+CYii71TyqxQC3Rrx81+NYbtAgbwdS/lH6Q/ZvnXQzA8LM7HGebVKmNdlcyc?=
 =?us-ascii?Q?Gd8sudAS+j4NlSI6dPbsexnC80UBzvYEw3TdP7Y78Wnem9fMcTKEyCiLE5Wx?=
 =?us-ascii?Q?Mzq0pUrwBfIMq9HZ3LxkSzK7Uwp1DXJTfhpvYAc0nCsfEt3H4X3wND/IGVEF?=
 =?us-ascii?Q?ymMgJbCM2SJgMqme6kMl5mcX3OM6KK/g/PBy6nl4M/nB0MSgzWK2Ujc2uOGi?=
 =?us-ascii?Q?gRbRJLxbFzYV1a4EAvDvIPq881WPD+QcI9EsUwUq99i3L24JthRS8/fAkwla?=
 =?us-ascii?Q?KsUOWf0dodwp/CkQVEp6V/yoTzop9lRx20cjmHLxiDDTOEevN2Nkciqztmgz?=
 =?us-ascii?Q?PZl3zrQ2v7tTkq8zYGtpHQiNCLWKPzKpraVyinf9f/UbvFePzg75j1RG6tVo?=
 =?us-ascii?Q?3Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9Q4aSOZ+XbYAjiYBJvtxrirDBiQXW6L7ta5cu6+ZSI43R6jL69dikK44VxH4xH31pJ74IIbUCX4N91cZb5nyQPSZtPiNIIPp9jLC27ehVKK11Hry4EKXq0Tw1glnpQrRx+2+6chnrm8bbOBCn6IfCUGkknpyZeljNrh5MbU9sVaDANqxktmUoYY982SnST2Wr9LdTSLrWYQ+g6jxL2vg9wJXgQvAFeA4puZJF1d2UMzgiKcNkoTUEIYwIti3i3NuzKdi8zq6uyZIz5G6l9hwn2WFd7oHPx58LhoObWsOdXaaDAktk5C4Qc83M7u09aIM3rLTfH1VWBfG6GBIiDHMv+BOLJMfKt8Enj+KqM5JlS0c0VDG7x1WxY8iQW1b1iq1XgPJLQbSdraQqPaylb0UtUzh7Cn/yiV/DRfQtB1RHFTHCyuUO61G8g+NICIjAbTFmVhMKMdPrdVgBVGFNT+XofAhLymSfhmVc4OBmgqwxky5ZICq8t6Wz8+8R/1ElooWJxCNLSMAvC+b15TLxTAtw/T+j/v66/A50T9cK0USGuHWkoDSb6r9YcqzumpMpYtoYBJvpGHQ+wGeS6e0Wtism2V+1M0oZ4GZEsYEu3favWs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0716c09-4eee-45ce-334f-08ddf5fe5256
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2025 15:24:40.9501
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GAYdNLOlzogQITsx8RuF5GwZZT/hPl+0OugOyQr/KpaVUI8sCQQIPV/EKQMPEUAs63tPTjQde4UFoQI0+G7VL6NMOzkiOq8reCyc35n9wgQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFD020A49E6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-17_01,2025-09-17_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 adultscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509170150
X-Proofpoint-ORIG-GUID: spQKExu2GpdOFS03vw98aI-xenEBs8Zy
X-Proofpoint-GUID: spQKExu2GpdOFS03vw98aI-xenEBs8Zy
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwMiBTYWx0ZWRfX9xb+cJT0Frpj
 AIWRRSKYksUeJc2WRG7gBniHRTih/maMqXVHXIpbCDNdPz3aDZOVmJurLG/YrjCMQYt1k+9rr4a
 APT6FMjHmvvP9D4deIY5ubQJ/wgSwTBDRJAOA3wHoIsOhfBHSukBTtiQXvqsj3fYkeURDXGWgoU
 l2vD8z0T861lRoBu8nvv7HjRAmIEW0R+0Fx7FcK7Yp/5zOvhYHV0UkuKxsz3wOJvWTqJppvApMv
 fkXqN65EHSRRmpNI9v93jx9D3eNWhwmaVsKna7Gw452D5Pk2OG+qZ/21Ghxf7o/go1OAaUDaoFe
 L0drBsmiUoHsrHyvv5dJg44jwcw1eHu2fFCdB/BSleVOGZrp3Rh0nRPoMmH5BKJKIHWZ+6w6IP1
 Ayaa/6f22hhRTNFmDdr2GcPkY4EzTA==
X-Authority-Analysis: v=2.4 cv=N/QpF39B c=1 sm=1 tr=0 ts=68cad2c1 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10
 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=0BMyZFS9aL5pxuX05u0A:9 cc=ntf
 awl=host:12084
X-Rspamd-Queue-Id: E9DCF40013
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: f8yzhfyzywkmnc86mqmi6ds4pxoa5w4u
X-HE-Tag: 1758122704-339255
X-HE-Meta: U2FsdGVkX18ucHRGqUFAg+RhhISAUBIgMRCNS13jo8BR9gb3VMxJSyefAtWaYGQM053h8rPRIO8b9WhjyLTHjm5m+LDucFJjhzO/zu3J7//jtP0M0gZhfoxVN+8NBeHq0INt1ifQ7FVUEals0CC7j7iPtfcodeW7Cvm0L1AGkuhx4ip4a+0q9zq6ygw2eLDMoBzO863rtSJoOVlXOSyrl8/BCtxAUFc88KSCOsdv2s1VjhwPPKnVuJUKp4SW2yxrf+4ygEu8nGGPnfFgGGLPICOCTpZhWArXCsPUfvOJJR338DCoXdLyCPlpmb3jLoa4PR8abGrfFn0Qh/Ufa3vO6fjFG+Zp3+ecJ7wZDoWv+ryqszJqTOnDOHjOIhreJ86fs3usxOKSmg5/9R6slVlNtbKl/xxlHQ5D0NcNiVrPTAtqQhLSFXKhCK9dQ5xR+QN43oWy1D7CqHFAncyJzivA0kRreB847xAFiuBeZfB8dUatCw06rkNtxSqx8XxQhKp4E02n1kUqZ0g8f2JMLgZ/sEUy+YcynDVJabqun6naOoKPU/dHLDp/t1VUNFY+UTLesTOnoUpKBEuB2eJIttS2ZGnfWY5bxtpYL0ZIfoT9b/VtGEepcjDLY05X5ejz1Dithj16ZTkrpC528BiAMrhfoT6CP6bey/mun5aP6cvlSz+ZeqTMkM6eNvpQUuPRbNo1WtRxAFHtznj8rUJf8Bmhe0H5ns3kPv1OopYnqSSdl6zFni3yahCC/ZhvZ5VbwtyukfGJKGolmaEJhGx0x3RfE/CURB8MGcs9R0+cyIOZsyZVG2TfAc/nr8idIdg+vtuHDmVEY/6SWsl0dLqJ8CdFGJvGrvb8douvGiNEhH7qX7uLb/nCol4gA4zmj5dTklqw9Z1heUWDdOn8Hxztbht+5ysEEGs6R1B/TGzmYPtzWf+CHgc8rME+xe6RqcOsx9CDpS25O6zqRI27BWSQteL
 EI0FQGNS
 iAvFDUm9PWNDLKXAb8pYKLpBUxQRrtIER15B1Z7D9jzLbGUJ62eVhoxz/GqcW4PWwsqI4tsOCsMG1m49j8ZCBNPHFaPy/7lUoKahddQjPnwm+/HsiV1+WLVZ/CYRKTTLTCjEDeq3IYcraGnumm5m3ws6z2/S1QWCnXhjTgpIZAc9YfMJp1QikLZ9n1ZaUJhL6lSekLF0/y4cv/jIsgxF5I4e8NfwsnKSJCxEJTiRI57JdHaiBRL0B4ECyb93+P9gKUnYGABIKcavNsL15GdtmHHHhfJJ3cziMU4qIXW8Py9jlWrv+AhvEgCGk0tsaKaGdGA6SLzl2ZeDmMORUI0ID0FtPHpW4zjzLkdbiO3QnFLU+hVsWtr02yzU5uuMGJCyP7ouB5Ps0ORZgWpeVlSMtJN/uomrUz9vyEFxPB4lkY+g1ycaYqJ78b+DJprklz/GXLG2kCcyHInFwQM1elwReZj/R1l4kvUcq5W4idFK/egNEMdbyEfH+pHRWZiLAPGfqt7jV1SFQA7mKjdbkED38033eZekZhVpvwY2IZ6c6b1n5MAfoE6v1V3hmqfinmmwa4WqIDP4Wdje095JattF0bWjS0VJ5YL6dBLDPacNxuS++bRpOAY+6ZeGqBECdvVNUeQEIaEN94lVySL/U3JgxwfxaO6l2UmtA613Rsw6kpUh/xCN1Ovd2s/fLpThC+2upAhwunAmjCPSSD+bo6XCJYXkmWwnGzNa7BoG1NFhEC2hZAuqKvTcRy7N2ablYaxh/dTqZUB6df3Hn3Eg2zrjtQrpWFzZI1vkBSj6occVynDHucCYG1FgqfG/sQPCjWKNiznlb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Define clear_user_highpages() which clears pages sequentially using
the single page variant.

With !CONFIG_HIGHMEM, pages are contiguous so use the range clearing
primitive clear_user_pages().

Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 include/linux/highmem.h | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/include/linux/highmem.h b/include/linux/highmem.h
index 6234f316468c..ed609987e24d 100644
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -207,6 +207,24 @@ static inline void clear_user_highpage(struct page *page, unsigned long vaddr)
 }
 #endif
 
+#ifndef clear_user_highpages
+static inline void clear_user_highpages(struct page *page, unsigned long vaddr,
+					unsigned int npages)
+{
+	if (!IS_ENABLED(CONFIG_HIGHMEM)) {
+		void *base = page_address(page);
+		clear_user_pages(base, vaddr, page, npages);
+		return;
+	}
+
+	do {
+		clear_user_highpage(page, vaddr);
+		vaddr += PAGE_SIZE;
+		page++;
+	} while (--npages);
+}
+#endif
+
 #ifndef vma_alloc_zeroed_movable_folio
 /**
  * vma_alloc_zeroed_movable_folio - Allocate a zeroed page for a VMA.
-- 
2.43.5


