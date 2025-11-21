Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09E8ECFC29F
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 20:24:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6ED36B0095; Fri, 21 Nov 2025 15:24:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A496C6B0062; Fri, 21 Nov 2025 15:24:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69E966B0092; Fri, 21 Nov 2025 15:24:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 45B5E6B0062
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 15:24:31 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BCC9AC0727
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 20:24:29 +0000 (UTC)
X-FDA: 84135741858.03.644E731
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5C6A914000D
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 20:24:26 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="Ap/ToXOk";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=f2NwhyHA;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763756666; a=rsa-sha256;
	cv=pass;
	b=aVMslW3CLkq6fg9lyiWLGBblNXapeEtyctVBj+VRI211f52Sr+BuxBELlv/vkDsAi0Q6fe
	7IfCUo+1ZDGNWN2NaqBxfY+U5PTB3hDd5e9Q5i5hpbU6yJRb3L/uYi7R2t07QdyvXzqc5w
	Nh0RXf9APpT976RUgENlIBw/X3quR7A=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="Ap/ToXOk";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=f2NwhyHA;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763756666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h4BEQK9BqWSN4ciOJqr7uXm6JYPgw/UjENTkI8lK2wA=;
	b=b63RZgmqNfDbzCx2mDVe8da3XewAmXrj/NM31RVYdDGUYjPRooUwiVHhSrxAUthglnJod+
	zw6spw49O7ZEXpC8rA4NO7dgMcYUE7OCk/KDjd+jfYgjjeLbxU2+muY+3dAEYgZiKVCef5
	sx+tGhFul3j/FnDzH7+DTqGQNd/LuMU=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5ALK9H51008264;
	Fri, 21 Nov 2025 20:23:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=h4BEQK9BqWSN4ciOJqr7uXm6JYPgw/UjENTkI8lK2wA=; b=
	Ap/ToXOkKLXr6J55EtE8lsbLkVNLZjVTn4HEjMcyyOhlBZJBbiZnfwJvnD6IAtSH
	APtepmZk7wep8EgIIWue5CCQvR5zb0/8nqp6SDWH8cCTKpVtfwz+zkUskBQ14jfa
	rycsJD9ClTDfbFA+nfCgNRgKSB66dxCUgcg+9y9fCyUazmHew0w8lgRtyMbfE36R
	8+C9VfHdJ9ex513YoFFXBeCM15c8aMwjq2+uFZxo1pN5c9AWxCBWYkYnJhf9GoBM
	XuxyYjUn61Z9jX7wcazYgKxhQK1x2deMPQUlGOfdTRqFfOzg1OgnDJbz9eEdYLT4
	aA8kHq0TrfDC6nP1ZpXt+A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aj5dtu7u6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Nov 2025 20:23:59 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5ALJTslU035952;
	Fri, 21 Nov 2025 20:23:58 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011041.outbound.protection.outlook.com [52.101.62.41])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4aefyrcg1x-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Nov 2025 20:23:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cixnYqihSUNGZ9TeSBq4gOK2gYSHIwwEcPX05nIC+19NPfZY7qwnYJUkgBB1L0gIWPNZwQ5y47GtfdtrBVQwUn1BixR/GbeRlA94cOuuTL1cB1tIrl+0RpJW7jEHlk5N4hdduQv8S+co835N+pYdsF4nHfb9UkLAxr/B05dqFacylq+iBTuvx+YP4E3U54MiU/xcd+/NDo+l44If82JyBmmkm/dRTA+vRXhTQXUnS9vAN9sjE8KThpVZMaz4AJZaXopvHSrhGrfFV+FiutOiqDqXtw2qEq1j3F0TJEES4/e7zwLn4ICVvgDDed8mVgXtpRDvnJTWu+TrcK1u4x7oDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h4BEQK9BqWSN4ciOJqr7uXm6JYPgw/UjENTkI8lK2wA=;
 b=OkTRMBfnRkzDx0h1jsWnkIFkubVHZQQAEtVbr4r8m+plFcPl5r8vveWRTljA/udUrpAISmpojpo8o/XaDCabpshss24meuBfbYVIceRo3Lfm0jTnSnqOgdZV1gwZARHszQssxN/5qg1ww12MIVa9WFOaFXyeSqTB84/lq7AyIiO5xi3gaZL+hr+DgILJNFrHpw0K4EnSJnN7prBRgNnRUDDKc6p0DkxrLr7BxYIw/0j/XgoclWRUYVxVSFn+GUaSCJp7yUB7xw6dhH9UAVjxSghG5P1G9ybTZleH+KHiAJF9WBRURIuJIUUA028yQo+iHg9p2mUSWW6qDNADHlBiyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h4BEQK9BqWSN4ciOJqr7uXm6JYPgw/UjENTkI8lK2wA=;
 b=f2NwhyHAqr+gYvRiZjMQM/Nwz5+QQvAk+q9E8FZMFGYRH7V8jZj+jPXVDS5f3yzovmbgFzN/ngM7eEhaS+OrfBwyIrrFo7QAkc1HATBD72oQwUWLbEVmV2gj1A937bctXsvu29az4Eaimfx3nWNilCWcIKV+Y/jW8Eep/8PrMtA=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by SA1PR10MB6470.namprd10.prod.outlook.com (2603:10b6:806:29f::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Fri, 21 Nov
 2025 20:23:55 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9320.021; Fri, 21 Nov 2025
 20:23:55 +0000
From: Ankur Arora <ankur.a.arora@oracle.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, david@kernel.org, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
        mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
        tglx@linutronix.de, willy@infradead.org, raghavendra.kt@amd.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com,
        ankur.a.arora@oracle.com
Subject: [PATCH v9 1/7] treewide: provide a generic clear_user_page() variant
Date: Fri, 21 Nov 2025 12:23:46 -0800
Message-Id: <20251121202352.494700-2-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20251121202352.494700-1-ankur.a.arora@oracle.com>
References: <20251121202352.494700-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW3PR06CA0028.namprd06.prod.outlook.com
 (2603:10b6:303:2a::33) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|SA1PR10MB6470:EE_
X-MS-Office365-Filtering-Correlation-Id: 91c8354b-d93a-47e1-2341-08de293be4ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?qG9LnPKwp/VFo0KEyXhCJGCQY8NCGUvpx8IUm3bqjgPyrdEpy6Q10gxtaQaQ?=
 =?us-ascii?Q?2DSt33VCoOy6qxIEu7hv3hlRuaikih2A1PoVpAYCSikArcrWsASi2E2NNUZo?=
 =?us-ascii?Q?mzAlqkRzgArfGHwZ4ZVoFFeideZ1POI2cEjOOFXDA//ZPvENcLK1pGloegoo?=
 =?us-ascii?Q?TIV09TkUrPZkgWnzTEAMvNsy+g+SUTNzS5X5J04rtZ8AypS8iNqSVa7NeBVh?=
 =?us-ascii?Q?RSaGbhXGYJ7GaiLqifjWRzjwNePgL+rmQ6gzJnvOw+rqofo5wrVFgkRd4Ogb?=
 =?us-ascii?Q?mriLxSAYkaBw3RxAicVb0/Oqm8MnQkYFevmklUAmaeI2TXDXtzrR6SvhvIVa?=
 =?us-ascii?Q?q1RP03vCygOrQvDXiU7pCx6PSX3sVPbKTIVbxg3VbbZbsHrH713qMryIFwFf?=
 =?us-ascii?Q?SUV0dX7SxjjREUfUtC6cWRLB22Hwu7OlMxqrFiPOSQAcCl8ayU83dQ9389PW?=
 =?us-ascii?Q?Otf0l6oW2D9o7bChoHFVwbH1fsXridqIa0vNW1l1S2L74EpI+SRTELPG+gn3?=
 =?us-ascii?Q?NrkwpOLvVZVRz0j8XhytUy60x7OxZK6jEibEBekclLcOaruEb/zxTbOTxv3T?=
 =?us-ascii?Q?16sd+ypfcWY5M4+a8yys7ZTGIVf2XCrMTCdwL/6Hew+4geV9BsXDTsB+EJUw?=
 =?us-ascii?Q?7a/xsFJty/hNmDU4sakRcq+NWoP2+2efC6IdxC9MB8Yy9b3bbxddEkyAKquK?=
 =?us-ascii?Q?2wzpeVN4Rg9Ev3ZtJlGwMIR5o8347JqOAsdzD5PHJ4zGBLxZVApDH/GeiLpb?=
 =?us-ascii?Q?5Fs/9rIDMcK/QF1yYwfXu6H7bC5J8plC5Mucc7ubssl0MG4ttKlOpMxr8dkU?=
 =?us-ascii?Q?Byoe7t7FwNs/J63+jvDkApHYTxZiG0u7Dnr2TG2C49SjIv2qEpqi+yRoEgY4?=
 =?us-ascii?Q?ow5rFSfhUa2wFFDDQ3IUnSH4t1nR6uijfxrEg1cLudSWhz4zV4ZOYqdrtFP1?=
 =?us-ascii?Q?eI7edkig7JPHnio0mhcWQOZvIFXIzAIPvzg8h9K6P91n+v3UV+1WDem6/rwo?=
 =?us-ascii?Q?HXHgaF7wZz3oMaaQ9OWXxKEgXLn23cAHWEsONmXqEn2hQMTxMa2V20NeyurI?=
 =?us-ascii?Q?PYNc73G27jCQahznK+fJmrcekNS3uRe+0b2N6cpf/QHgtnwo+4frqiGqderU?=
 =?us-ascii?Q?9yFut3mb6SlvAROg9oOptMWT21+2Q3ALNPZ06i3rQc6j7UIFEOviZq3fK5K1?=
 =?us-ascii?Q?nzgFvJrvnHYjAwcprku0D/btzHtrWnJ3Cmo2gaS2s8gYtxn+RskAXWmLA2yJ?=
 =?us-ascii?Q?+PWu/DIuknzu/v4TF6xE6wi9B1XIH09nKHeMUMrJKef1sHyaGZdQ7XUXGebv?=
 =?us-ascii?Q?qbj1OYmTWEgB1GdkA6kAfYP3tikJANsoXJAo085L6BJxKBFoCdbF4C4RrDzY?=
 =?us-ascii?Q?CBFNrrdMG4foTK/j3GG+0AKrT5PTo5X/zpk5Pf4LLrkzo1cp9qkH0SEM/BcE?=
 =?us-ascii?Q?cn2wgpUAThYERpCGNcgPhtW0sxg7/3WL?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9IFIXFDoM+9UqjhsIvveJnGT9J17OImScnnw7GU2+udKsujE50dCnpZqVpa5?=
 =?us-ascii?Q?hEOrcyRpLWcECvAZ2b9kx2MMYFRFxWHo965Wlx2UfRN8xiGotoMvMtT6pEto?=
 =?us-ascii?Q?gYecnAeoixFW5/Wff919cgEKOMxkU+lvNVsFdaSNhzOSW33tvSjOQDhSWUTI?=
 =?us-ascii?Q?EYE+T9Q4YdTTbobqQSCD6eDyWXzApjciTIIgXGBptSRTZ+mSKpKEnlcxIKmf?=
 =?us-ascii?Q?tgtGhSEW7dvQUaMAmjvQGujZV8jZuJwX8J90WbcV80ooVUUVl39ImLkPSMKW?=
 =?us-ascii?Q?42XipzWh1+bYKIwpll+4nqOko5fZvRq+iBRryyK9H3Fu2Ngfu0VQ+4yBLafC?=
 =?us-ascii?Q?GKXUlDuW8aCRrXYen3OJnQY2MlkLaUxeLa+XgGfTGqi8adjZpMRIGU5IUtcK?=
 =?us-ascii?Q?pFDH/9x3G0b/qFjhfu//T1NPKARS9+6uPk6Qo1u7Vats6pQRGXkC7t8LVH/Z?=
 =?us-ascii?Q?sa/49HK5fKo0e96aMzfZ+BSNqu855Y8oh5Rtg/ewQzvK3o9+gooLKu0tRDzE?=
 =?us-ascii?Q?y2YHws0kfYU67+DqIWGRpnB9SQQBcZMdicr71Fn9SEB9PLIzSGgncKEk2knC?=
 =?us-ascii?Q?BI9DAA0j3y1IP1gyLOGAG0KnkEx2zvOz54nkFn+QoLN6NfcZsiKRl7/QFwri?=
 =?us-ascii?Q?9I6dMUuy8MY1uuitttCb8vfUs/AtCVnfaf/tU9GoneO6kQlkbvIPJzXBpCK2?=
 =?us-ascii?Q?m/CUbvKzudD4f8WwhWZ2yYvnyf42BjqrLOzzMJrPT/Xbw4CV3EmjLEsU0Nhy?=
 =?us-ascii?Q?e72aHFAtfXTFJKW/SRr+BZG4OVHtEU8Cn9jnOxovLOVTFHBkZk0t4QroQfiM?=
 =?us-ascii?Q?3cBoLz248g3fpo7XMFjgg9hIBLLLggVj3uihpfmkA2A3Q6AaMwhxvcWvlGQP?=
 =?us-ascii?Q?szewTQFsDB4X5Sw/+FDl1DWtbBV35OLfCBl47a9isnerZhaXDNtD+eYXzIgP?=
 =?us-ascii?Q?CdUKxhAc/spYIiQyRssrEfiud02T/UF7j8nINkhMjp1E9a8DMVuXa9/LyNLg?=
 =?us-ascii?Q?RUZ5FzCySpCQfvXliTmM7KDAYgfC6gmo+T44Ok0IHQQqKhcCsYhoNANRXrrN?=
 =?us-ascii?Q?Rpt8xSMIIQAY8zk19uhax8rpHmP+CYN8lZFG/49ePCSiM21Si/UyGmVuwH+x?=
 =?us-ascii?Q?S3Pmh3WdeB37a9OOdqo3LFCQJx9UOJzJxWvBuvhDiwaT1UpvILUADfzoVVha?=
 =?us-ascii?Q?BxZufaneNSmp8zXscuqOdU3saUhJ0X+h4yBHtlq60C9JNwbUEccfe8l53Rb5?=
 =?us-ascii?Q?kid/m54YDn1lLpCDenytIbJneuyYbio/TuxqR7R7sG5NkP4plE+T/DAFhvEe?=
 =?us-ascii?Q?CV3PJ+hkJ3alxCI6LO6TdBjte25SEQ4B1LShLiXItT1BS0f49ktzBvNu1eTe?=
 =?us-ascii?Q?Vk0mXhKr1vw1qDvoeUy+QIsSHZqSBsFrrg9D9ROvPAvjsgbH9WH1JvCDXWn5?=
 =?us-ascii?Q?fotaYLFdCFEoVUXz8oauiwzVQrh5e2Cfcii5dPGRSDvKarPr9GFprXVvwB1b?=
 =?us-ascii?Q?zwOSnz5qZILWARFiohOavxuJWniHYkQl3mpS5Ca2U72MLkgDU0TXwsBFXsPI?=
 =?us-ascii?Q?JtTdewxbnBKWyZDRFsbedE6a8NfizdHueUh51vcq4msI7rbDykc3iMWG7lnR?=
 =?us-ascii?Q?0Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	JZ0Bfi7WR2zC2JEOqZK7Ag4rQFEQNOwj+DRM/jQUG/up+JlgdQiit6kHJyWhyBeuEyPfEeJro13F2ZeHnV6jITFKAFqylJa0/1mFXL07XJfUTJkEDuY817hXqRrwy7OsnXy8em5aSCOV57Z227+Pp89KV7zF7WDBIufwYMKoJW4GuPfqA8M+wPbUqqk7Y9m/W9LTKDk7GQIXIP5T+0Im9u44RTVwFYf+UseytfnAPOyErs20IY1FELoTW9o7bTztqK2qDk6KeWEqcBM6V9fT01VWiInJ3uWznRs86IZQ1CfnquWHvFM7+44XWkxJUNuVsg0ZNwwXoxbZZs0bHsu1N/115cfNdnAR2tkZ5EI/I2XWdRl372aKGG3pfFcnjWuo/w/4Aq5o0u82o8OTWndxLWS197vaDMPwd/21toNkX02J1efXbA88x8WB9rXt0EWoDwBUgzljV0qttrPClfHicYD08nZK7XJXsCcTFP0PmdoVuuakbEyrbOVyQD/QFqMl3emcThPqxvpktih0f75q4QgiKKQJm5DIscIltbgyTjHPor8wuv3EDMAbBFJvrjzfP+o57habTOCLMmG5z3QsVjjB3RwDTfDNuRenf3HOjDI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91c8354b-d93a-47e1-2341-08de293be4ae
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2025 20:23:55.1251
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kYzzwhbigtr1ZOEKnsu9f4G2C6Dy+wYm+CamstcxdjbmLrYU6TGFqxVxZQDfA6xb4O5zJiqTAyXZNWQl+OxQFGSw+LJ4fMXgoFieDJgVLkY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6470
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-21_06,2025-11-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511210155
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTIwMDA5OSBTYWx0ZWRfX3bguy0nVE6zG
 JHGgLiDJxCh6iAUsTLrTzgTq6GF9Pr5Aslmo1Qq1KPhX+efcv0Ip1qQvYfeIQMHfiYfmHDw8pHW
 Z/Tk3jZR6Ufzt+jCm8o38mIggy8+BTb/oWlRFPhG0PxiFZG1TvMK82EvX5MbH6xZW1p3BCHdEgP
 BWz9ZKnmsSfEgRJe8wxswpteApaKe8qJwthd2zDRoGKBnLlaGvKzPLjkLo4O2xfvbDVfZV9NGda
 Bx7bZA0jUcxoz1QMtEPaH37PILu0+DPOzO2tHsvm54Ap1invHbFflsw4SFnp6TX1Lhmo7vDmcJ1
 +RO+Dy5y/h4IlKKswerUTD1qbe5l8mR630vhGOyMCFiSsh4WzldpD9KOciWUCKBTajezB/I0e7W
 irrw5R2TfDcHbx4Jft8smx2qo3JJtvWyCit0B6NZcIiOGAlrcLE=
X-Authority-Analysis: v=2.4 cv=Dckaa/tW c=1 sm=1 tr=0 ts=6920ca5f b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8
 a=Sf88-goebzjZ85YUTTQA:9 cc=ntf awl=host:12098
X-Proofpoint-GUID: WqhE1oTqpPgVY0pny2VH0-6iXJ2rW7DN
X-Proofpoint-ORIG-GUID: WqhE1oTqpPgVY0pny2VH0-6iXJ2rW7DN
X-Rspamd-Queue-Id: 5C6A914000D
X-Rspamd-Server: rspam07
X-Stat-Signature: kzcignuzbg6q3hyki4opauctidxsaauw
X-Rspam-User: 
X-HE-Tag: 1763756666-380197
X-HE-Meta: U2FsdGVkX18eYAF2DxLZqsDShnXh9iFY8BxKX3n5DcvnFK6b9UOPypj64XTJCtDF8KlSENaxeCgSGD+se3LtTjoC6a2pQurLsJ7ELuOF0BcMXajnt33LT8Jfim/NYcnpJZM9a1FskRhS8lsWX1EHFIn/iQDiQ0WYyz5ILXcQ89aBl+bT7Q/DDljr3e8XbhFX2dAMt4QOX5NAckHk6qS15z5HzmWmvzuxg7QcKvuvU80WK58ImxjRS6KbyERwB2bISSqGARxlkCiBXTIV7PYIxGFpyhAEaNpALK1p5OLEVSjR/U7oqNalruoZcO8ZZoHLV4C2he/7h1icXQN81RYkZGzkmLk8z7TIWBNG4Geoq8GHQNur/sLV3rh+TKYhZE7QKxS5NPFxPZcFP2N1Ur8kvzC1cL2Y7pe74l698lKAykbw8VhnnFSdlHrFCHq/FMDwq5pZM+gRG6OpeGdeEfty6qLhVinXS1XXZDgTScZcY+oPDEMXfXM8wWkn4ik6+7AwJv2I7znGR7kHU9TL7P9mVvQwzO9YrC5xM97Y2hO3P7rriTDW8ihb8ZTSBDkxH9PkgEgNUYsOWJjMIZ4I6qdeG2JrVqH+relg2izwKRr8fu8xynmQQMkr+A1pNMxzB+AMQamRUQIwaq465LVCTZ3yp7Y7pSflrSyXGTW1/yIquY5GP+gfHT6DVjVA12qisvQ+h/WflFgwOumrrOrChp96r953Z6a+BHoOzfvHGnxSV/4dWhaU3XiVxgKD1sMFuYZkxsIdRaRrzKluHm0k6FlnrF4Tau2HYRWN79KRqH5rVQhPzczJtJSRSVut/P3/Aq5Y12upaMrdfiMCfrK7fessWgamNmDncn2Is2o0AWBrvvYEcx37ED5IkYuywVaqjL13oZT/KcMz/y3kOutgsOVNqN+vyqcMy3+k+lAuikVLZzi2S8FR+yN+tlsC1sPvLrGh8OWawtSSPgN8MN20dIL
 Nsk04nIg
 HT/VraZ352CWpkFrCUPrjDWefVm4llk3gNylzkbWjONyKM6i01ogPhRCHfbOpmZ9cYAF7TFPTDf+4btbf17l0eT4tTz5fbESnRZWpNgCIKNKPVwR3TrNeuV2w7A4u/SaJnSN3ly/DwzOLd1fT9/zb/feJ4g9ycN+KqW+6MoZlmXjEkM+34CDWInKDCAqgoHdyyT75/j+35q/x82fCA8VKRXGOVlzR2kB9wAcrZbOMA1Of9dv+0LkR3v6kiXQGXam5j20oTOLNXPRKYGYnrQyOYlMyp9SHp6hzKaXskJSV2hf20/vsmW5KQNOqyNIjsunr8aHi5lCZJCo+TEfG0odRYk0uBmCC3ruuaq/Dzf9kL9BEUmigwniH4118JCtFY0UcTxVGypV6XDYBkGXbBP0zu6N9Dkv8b9IqbVkxmHK1qq04i9p8MDiG4bARESueNAH5Xy9YgDYMwFQwtcDxqQRXzMy8lAWZyGmCLlwXl1TkEUDDWUeBgOexfIU1H5RnQd2Ej0A3MnTtJBcL8WO/uJg/LgGPFMrk1DiDlfBPI2y70Qg7kH/mfNuM0pBD+/ALgqGKo+uLF96cNb0bv/gGHcNzVA9aFbxK4Axk+Cth9rGIbttRGs4zOCUM+5ObWVS/3DaEkSz/S4NUpgFMK/S4/8GR3ed1ev7/dwsae1KSN1Yz56uCqZFxmJyLBxwYtV3lL0CRPCMnYeeJ2e/iI5gZoMFw/34P6g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: David Hildenbrand <david@redhat.com>

Let's drop all variants that effectively map to clear_page() and
provide it in a generic variant instead.

We'll use the macro clear_user_page to indicate whether an architecture
provides it's own variant.

We have to be a bit careful if an architecture provides a custom
clear_user_highpage(), because then it's very likely that some special
flushing magic is happening behind the scenes.

Maybe at some point these should be CONFIG_ options.

Note that for parisc, clear_page() and clear_user_page() map to
clear_page_asm(), so we can just get rid of the custom clear_user_page()
implementation. There is a clear_user_page_asm() function on parisc,
that seems to be unused. Not sure what's up with that.

Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---

Notes:
    
   - For architectures which have a specialized version of clear_user_page(),
     define clear_user_page instead of __HAVE_ARCH_CLEAR_USER_PAGE.
   - m68k/include/asm/page_mm.h, sparc/include/asm/page_32.h already define
     clear_user_page() as a macro so we just use that instead.

 arch/alpha/include/asm/page.h      |  1 -
 arch/arc/include/asm/page.h        |  2 ++
 arch/arm/include/asm/page-nommu.h  |  1 -
 arch/arm64/include/asm/page.h      |  1 -
 arch/csky/abiv1/inc/abi/page.h     |  1 +
 arch/csky/abiv2/inc/abi/page.h     |  7 -------
 arch/hexagon/include/asm/page.h    |  1 -
 arch/loongarch/include/asm/page.h  |  1 -
 arch/m68k/include/asm/page_no.h    |  1 -
 arch/microblaze/include/asm/page.h |  1 -
 arch/mips/include/asm/page.h       |  1 +
 arch/nios2/include/asm/page.h      |  1 +
 arch/openrisc/include/asm/page.h   |  1 -
 arch/parisc/include/asm/page.h     |  1 -
 arch/powerpc/include/asm/page.h    |  1 +
 arch/riscv/include/asm/page.h      |  1 -
 arch/s390/include/asm/page.h       |  1 -
 arch/sparc/include/asm/page_64.h   |  1 +
 arch/um/include/asm/page.h         |  1 -
 arch/x86/include/asm/page.h        |  6 ------
 arch/xtensa/include/asm/page.h     |  1 -
 include/linux/mm.h                 | 22 ++++++++++++++++++++++
 22 files changed, 29 insertions(+), 26 deletions(-)

diff --git a/arch/alpha/include/asm/page.h b/arch/alpha/include/asm/page.h
index 5ec4c77e432e..d71ef845deca 100644
--- a/arch/alpha/include/asm/page.h
+++ b/arch/alpha/include/asm/page.h
@@ -11,7 +11,6 @@
 #define STRICT_MM_TYPECHECKS
 
 extern void clear_page(void *page);
-#define clear_user_page(page, vaddr, pg)	clear_page(page)
 
 #define vma_alloc_zeroed_movable_folio(vma, vaddr) \
 	vma_alloc_folio(GFP_HIGHUSER_MOVABLE | __GFP_ZERO, 0, vma, vaddr)
diff --git a/arch/arc/include/asm/page.h b/arch/arc/include/asm/page.h
index 9720fe6b2c24..38214e126c6d 100644
--- a/arch/arc/include/asm/page.h
+++ b/arch/arc/include/asm/page.h
@@ -32,6 +32,8 @@ struct page;
 
 void copy_user_highpage(struct page *to, struct page *from,
 			unsigned long u_vaddr, struct vm_area_struct *vma);
+
+#define clear_user_page clear_user_page
 void clear_user_page(void *to, unsigned long u_vaddr, struct page *page);
 
 typedef struct {
diff --git a/arch/arm/include/asm/page-nommu.h b/arch/arm/include/asm/page-nommu.h
index 7c2c72323d17..e74415c959be 100644
--- a/arch/arm/include/asm/page-nommu.h
+++ b/arch/arm/include/asm/page-nommu.h
@@ -11,7 +11,6 @@
 #define clear_page(page)	memset((page), 0, PAGE_SIZE)
 #define copy_page(to,from)	memcpy((to), (from), PAGE_SIZE)
 
-#define clear_user_page(page, vaddr, pg)	clear_page(page)
 #define copy_user_page(to, from, vaddr, pg)	copy_page(to, from)
 
 /*
diff --git a/arch/arm64/include/asm/page.h b/arch/arm64/include/asm/page.h
index 258cca4b4873..0e8de245e283 100644
--- a/arch/arm64/include/asm/page.h
+++ b/arch/arm64/include/asm/page.h
@@ -36,7 +36,6 @@ struct folio *vma_alloc_zeroed_movable_folio(struct vm_area_struct *vma,
 bool tag_clear_highpages(struct page *to, int numpages);
 #define __HAVE_ARCH_TAG_CLEAR_HIGHPAGES
 
-#define clear_user_page(page, vaddr, pg)	clear_page(page)
 #define copy_user_page(to, from, vaddr, pg)	copy_page(to, from)
 
 typedef struct page *pgtable_t;
diff --git a/arch/csky/abiv1/inc/abi/page.h b/arch/csky/abiv1/inc/abi/page.h
index 2d2159933b76..58307254e7e5 100644
--- a/arch/csky/abiv1/inc/abi/page.h
+++ b/arch/csky/abiv1/inc/abi/page.h
@@ -10,6 +10,7 @@ static inline unsigned long pages_do_alias(unsigned long addr1,
 	return (addr1 ^ addr2) & (SHMLBA-1);
 }
 
+#define clear_user_page clear_user_page
 static inline void clear_user_page(void *addr, unsigned long vaddr,
 				   struct page *page)
 {
diff --git a/arch/csky/abiv2/inc/abi/page.h b/arch/csky/abiv2/inc/abi/page.h
index cf005f13cd15..a5a255013308 100644
--- a/arch/csky/abiv2/inc/abi/page.h
+++ b/arch/csky/abiv2/inc/abi/page.h
@@ -1,11 +1,4 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-
-static inline void clear_user_page(void *addr, unsigned long vaddr,
-				   struct page *page)
-{
-	clear_page(addr);
-}
-
 static inline void copy_user_page(void *to, void *from, unsigned long vaddr,
 				  struct page *page)
 {
diff --git a/arch/hexagon/include/asm/page.h b/arch/hexagon/include/asm/page.h
index 137ba7c5de48..f0aed3ed812b 100644
--- a/arch/hexagon/include/asm/page.h
+++ b/arch/hexagon/include/asm/page.h
@@ -113,7 +113,6 @@ static inline void clear_page(void *page)
 /*
  * Under assumption that kernel always "sees" user map...
  */
-#define clear_user_page(page, vaddr, pg)	clear_page(page)
 #define copy_user_page(to, from, vaddr, pg)	copy_page(to, from)
 
 static inline unsigned long virt_to_pfn(const void *kaddr)
diff --git a/arch/loongarch/include/asm/page.h b/arch/loongarch/include/asm/page.h
index a3aaf34fba16..b83415fe4ffb 100644
--- a/arch/loongarch/include/asm/page.h
+++ b/arch/loongarch/include/asm/page.h
@@ -30,7 +30,6 @@
 extern void clear_page(void *page);
 extern void copy_page(void *to, void *from);
 
-#define clear_user_page(page, vaddr, pg)	clear_page(page)
 #define copy_user_page(to, from, vaddr, pg)	copy_page(to, from)
 
 extern unsigned long shm_align_mask;
diff --git a/arch/m68k/include/asm/page_no.h b/arch/m68k/include/asm/page_no.h
index 39db2026a4b4..d2532bc407ef 100644
--- a/arch/m68k/include/asm/page_no.h
+++ b/arch/m68k/include/asm/page_no.h
@@ -10,7 +10,6 @@ extern unsigned long memory_end;
 #define clear_page(page)	memset((page), 0, PAGE_SIZE)
 #define copy_page(to,from)	memcpy((to), (from), PAGE_SIZE)
 
-#define clear_user_page(page, vaddr, pg)	clear_page(page)
 #define copy_user_page(to, from, vaddr, pg)	copy_page(to, from)
 
 #define vma_alloc_zeroed_movable_folio(vma, vaddr) \
diff --git a/arch/microblaze/include/asm/page.h b/arch/microblaze/include/asm/page.h
index 90ac9f34b4b4..e1e396367ba7 100644
--- a/arch/microblaze/include/asm/page.h
+++ b/arch/microblaze/include/asm/page.h
@@ -45,7 +45,6 @@ typedef unsigned long pte_basic_t;
 # define copy_page(to, from)			memcpy((to), (from), PAGE_SIZE)
 # define clear_page(pgaddr)			memset((pgaddr), 0, PAGE_SIZE)
 
-# define clear_user_page(pgaddr, vaddr, page)	memset((pgaddr), 0, PAGE_SIZE)
 # define copy_user_page(vto, vfrom, vaddr, topg) \
 			memcpy((vto), (vfrom), PAGE_SIZE)
 
diff --git a/arch/mips/include/asm/page.h b/arch/mips/include/asm/page.h
index bc3e3484c1bf..5ec428fcc887 100644
--- a/arch/mips/include/asm/page.h
+++ b/arch/mips/include/asm/page.h
@@ -90,6 +90,7 @@ static inline void clear_user_page(void *addr, unsigned long vaddr,
 	if (pages_do_alias((unsigned long) addr, vaddr & PAGE_MASK))
 		flush_data_cache_page((unsigned long)addr);
 }
+#define clear_user_page clear_user_page
 
 struct vm_area_struct;
 extern void copy_user_highpage(struct page *to, struct page *from,
diff --git a/arch/nios2/include/asm/page.h b/arch/nios2/include/asm/page.h
index 00a51623d38a..722956ac0bf8 100644
--- a/arch/nios2/include/asm/page.h
+++ b/arch/nios2/include/asm/page.h
@@ -45,6 +45,7 @@
 
 struct page;
 
+#define clear_user_page clear_user_page
 extern void clear_user_page(void *addr, unsigned long vaddr, struct page *page);
 extern void copy_user_page(void *vto, void *vfrom, unsigned long vaddr,
 				struct page *to);
diff --git a/arch/openrisc/include/asm/page.h b/arch/openrisc/include/asm/page.h
index 85797f94d1d7..d2cdbf3579bb 100644
--- a/arch/openrisc/include/asm/page.h
+++ b/arch/openrisc/include/asm/page.h
@@ -30,7 +30,6 @@
 #define clear_page(page)	memset((page), 0, PAGE_SIZE)
 #define copy_page(to, from)	memcpy((to), (from), PAGE_SIZE)
 
-#define clear_user_page(page, vaddr, pg)        clear_page(page)
 #define copy_user_page(to, from, vaddr, pg)     copy_page(to, from)
 
 /*
diff --git a/arch/parisc/include/asm/page.h b/arch/parisc/include/asm/page.h
index 8f4e51071ea1..3630b36d07da 100644
--- a/arch/parisc/include/asm/page.h
+++ b/arch/parisc/include/asm/page.h
@@ -21,7 +21,6 @@ struct vm_area_struct;
 
 void clear_page_asm(void *page);
 void copy_page_asm(void *to, void *from);
-#define clear_user_page(vto, vaddr, page) clear_page_asm(vto)
 void copy_user_highpage(struct page *to, struct page *from, unsigned long vaddr,
 		struct vm_area_struct *vma);
 #define __HAVE_ARCH_COPY_USER_HIGHPAGE
diff --git a/arch/powerpc/include/asm/page.h b/arch/powerpc/include/asm/page.h
index b28fbb1d57eb..f2bb1f98eebe 100644
--- a/arch/powerpc/include/asm/page.h
+++ b/arch/powerpc/include/asm/page.h
@@ -271,6 +271,7 @@ static inline const void *pfn_to_kaddr(unsigned long pfn)
 
 struct page;
 extern void clear_user_page(void *page, unsigned long vaddr, struct page *pg);
+#define clear_user_page clear_user_page
 extern void copy_user_page(void *to, void *from, unsigned long vaddr,
 		struct page *p);
 extern int devmem_is_allowed(unsigned long pfn);
diff --git a/arch/riscv/include/asm/page.h b/arch/riscv/include/asm/page.h
index ffe213ad65a4..061b60b954ec 100644
--- a/arch/riscv/include/asm/page.h
+++ b/arch/riscv/include/asm/page.h
@@ -50,7 +50,6 @@ void clear_page(void *page);
 #endif
 #define copy_page(to, from)			memcpy((to), (from), PAGE_SIZE)
 
-#define clear_user_page(pgaddr, vaddr, page)	clear_page(pgaddr)
 #define copy_user_page(vto, vfrom, vaddr, topg) \
 			memcpy((vto), (vfrom), PAGE_SIZE)
 
diff --git a/arch/s390/include/asm/page.h b/arch/s390/include/asm/page.h
index 9240a363c893..6635ba56d4b2 100644
--- a/arch/s390/include/asm/page.h
+++ b/arch/s390/include/asm/page.h
@@ -65,7 +65,6 @@ static inline void copy_page(void *to, void *from)
 		: : "memory", "cc");
 }
 
-#define clear_user_page(page, vaddr, pg)	clear_page(page)
 #define copy_user_page(to, from, vaddr, pg)	copy_page(to, from)
 
 #define vma_alloc_zeroed_movable_folio(vma, vaddr) \
diff --git a/arch/sparc/include/asm/page_64.h b/arch/sparc/include/asm/page_64.h
index d764d8a8586b..fd4dc85fb38b 100644
--- a/arch/sparc/include/asm/page_64.h
+++ b/arch/sparc/include/asm/page_64.h
@@ -43,6 +43,7 @@ void _clear_page(void *page);
 #define clear_page(X)	_clear_page((void *)(X))
 struct page;
 void clear_user_page(void *addr, unsigned long vaddr, struct page *page);
+#define clear_user_page clear_user_page
 #define copy_page(X,Y)	memcpy((void *)(X), (void *)(Y), PAGE_SIZE)
 void copy_user_page(void *to, void *from, unsigned long vaddr, struct page *topage);
 #define __HAVE_ARCH_COPY_USER_HIGHPAGE
diff --git a/arch/um/include/asm/page.h b/arch/um/include/asm/page.h
index 6f54254aaf44..8cea97a9c8f9 100644
--- a/arch/um/include/asm/page.h
+++ b/arch/um/include/asm/page.h
@@ -26,7 +26,6 @@ struct page;
 #define clear_page(page)	memset((void *)(page), 0, PAGE_SIZE)
 #define copy_page(to,from)	memcpy((void *)(to), (void *)(from), PAGE_SIZE)
 
-#define clear_user_page(page, vaddr, pg)	clear_page(page)
 #define copy_user_page(to, from, vaddr, pg)	copy_page(to, from)
 
 typedef struct { unsigned long pte; } pte_t;
diff --git a/arch/x86/include/asm/page.h b/arch/x86/include/asm/page.h
index 9265f2fca99a..416dc88e35c1 100644
--- a/arch/x86/include/asm/page.h
+++ b/arch/x86/include/asm/page.h
@@ -22,12 +22,6 @@ struct page;
 extern struct range pfn_mapped[];
 extern int nr_pfn_mapped;
 
-static inline void clear_user_page(void *page, unsigned long vaddr,
-				   struct page *pg)
-{
-	clear_page(page);
-}
-
 static inline void copy_user_page(void *to, void *from, unsigned long vaddr,
 				  struct page *topage)
 {
diff --git a/arch/xtensa/include/asm/page.h b/arch/xtensa/include/asm/page.h
index 20655174b111..059493256765 100644
--- a/arch/xtensa/include/asm/page.h
+++ b/arch/xtensa/include/asm/page.h
@@ -126,7 +126,6 @@ void clear_user_highpage(struct page *page, unsigned long vaddr);
 void copy_user_highpage(struct page *to, struct page *from,
 			unsigned long vaddr, struct vm_area_struct *vma);
 #else
-# define clear_user_page(page, vaddr, pg)	clear_page(page)
 # define copy_user_page(to, from, vaddr, pg)	copy_page(to, from)
 #endif
 
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 7c79b3369b82..6fa6c188f99a 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3879,6 +3879,28 @@ static inline void clear_page_guard(struct zone *zone, struct page *page,
 				unsigned int order) {}
 #endif	/* CONFIG_DEBUG_PAGEALLOC */
 
+#ifndef clear_user_page
+/**
+ * clear_user_page() - clear a page to be mapped to user space
+ * @addr: the address of the page
+ * @vaddr: the address of the user mapping
+ * @page: the page
+ */
+static inline void clear_user_page(void *addr, unsigned long vaddr, struct page *page)
+{
+#ifdef clear_user_highpage
+	/*
+	 * If an architecture defines its own clear_user_highpage() variant,
+	 * then we have to be a bit more careful here and cannot simply
+	 * rely on clear_page().
+	 */
+	clear_user_highpage(page, vaddr);
+#else
+	clear_page(addr);
+#endif
+}
+#endif
+
 #ifdef __HAVE_ARCH_GATE_AREA
 extern struct vm_area_struct *get_gate_vma(struct mm_struct *mm);
 extern int in_gate_area_no_mm(unsigned long addr);
-- 
2.31.1


