Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6342CCD1BF
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 16:35:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E5928017E; Tue, 28 Oct 2025 12:35:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 395A28013F; Tue, 28 Oct 2025 12:35:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 236F58017E; Tue, 28 Oct 2025 12:35:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 10C028013F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 12:35:02 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9B37E13B2A3
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 16:35:01 +0000 (UTC)
X-FDA: 84048072402.29.1816A21
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf29.hostedemail.com (Postfix) with ESMTP id 10D8212000D
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 16:34:57 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=N1EthqXE;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=WaoQCWYA;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761669298; a=rsa-sha256;
	cv=pass;
	b=Gle57lTaH5tweZO0gJSJgS7kP60SYU4wAIqMaSoNbFxeNpJsd8Ow6Q2dq0Hhx25DDD+If+
	YxnJCWSFjWknYbHpp/45Ezcxa4pg0cYYPIMNheMLbb7S6H2jeA//8UboEnPdpr0rrcUAmB
	YAr7qjB3+Ns3L7IN/UZUf813Qy2TDPM=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=N1EthqXE;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=WaoQCWYA;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761669298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ewU7HmZXexvheSOfWnNgDSorZfXxivtiPynEu6thaqw=;
	b=OK/TyvxbqM5TsMu4KuBzk6/5rQ0cgei1Y7iP9bErORpQTtFOoy+lBFb6Ytq2arWXg7U0ZC
	T3NR8xd/IHktAeoVBwGGArlpZA/acOknZkbIrQMtU9RcCYGE9NRrP0lmE+rSeyIIaOdfJQ
	A5ceE37yc/NE1L+/kxF90E5102Cyayk=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59SBDxr6000963;
	Tue, 28 Oct 2025 16:34:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=ewU7HmZXexvheSOfWn
	NgDSorZfXxivtiPynEu6thaqw=; b=N1EthqXEaUcfFZjga2pK22ul2tNelCpkef
	KW3um4eu2tWsGoQsDDyv6wculWqIHpoW9hFJfx+UPbHyuz6bfOWnMcJ2A57nMVss
	4wc8hRLBHH5sO4DYuuUePfwrmnfpdhOZB60pDv2c59qcNJoQlNlFAnUUkwRtdVPu
	Ijqs4f4eapC1RRpstrLRX1Jjvgj15yPAzjnSJmezWv574fb0TXiqmfLa1SD5krqm
	jGl2LLTp5Wa1vKj+yHkhdpXyuWaRKcNhjKAn7dRxFejUv1+itjMY3d68HI4QgJDr
	2dtChqT9CZ+TjvmjASbqg0NXI+LD/tARJHI5/iNAKVlebhNNN47Q==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a22x6uy26-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Oct 2025 16:34:46 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59SFpIjo034846;
	Tue, 28 Oct 2025 16:34:45 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012021.outbound.protection.outlook.com [52.101.53.21])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a19pfuba0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Oct 2025 16:34:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m7WEDo6iIwiqTbZbV/cecuJ8D1lCV8uPH6FbmI/nt714crxbMnQB+6oeB9eNHPEiH79a7cjDVyvgJcPj4Z0E+y89Fzn+fhHnhYTMD7F11McbunrBS9lPW/2Ug3hcTv0mvS+6yPa3h4Ec16CSUAlSr+fqCGyL20U+0XXh6n57mxiIPpjhkzcqFkzBvdlQaCgZC/QHq2ALg68dt0IBS8KWK7Wztk47c2zruq/9t3XoUr6h1O4j82GL6kwpM9ECLnT4zJD2QSww9MLK8aSq0sOFRjANrfrTuu4xy1rF0/dMquhWFLUhB2wd6i6H/SsmP2r7FeiP/x9ZFYhW+neM44/LOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ewU7HmZXexvheSOfWnNgDSorZfXxivtiPynEu6thaqw=;
 b=aFsyI/IixRvrIljKg+sg7jCFClJyjRJJgVqKiYy+8i1MvcSbq496Gt2xT2OOh+LNPMakfRcL6dNb+3G03nr+23R0bh4mbHP1kiSUFLecNpZSd8D4QRmQSteYba0d0TVXDfnMRq0GMwbeMoVMisTCk/hifKCYg7XLpwY6Bo9tj0y6Irjwg9sPNxT6dMJdd4wTAG0Nil7Jv6Va8lZ1qfv8Ud7ZS2RCqO7rHVmz7jvt6LKP3+cm0kchI408sadwMayWAKQOk3gKn6n1H8AVmySr5SIcVbrCjgfE9DphV+7e4IaWryZa94tFKrYECfa6XCzPGudJ1VwnaYb/71vmlmDVAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ewU7HmZXexvheSOfWnNgDSorZfXxivtiPynEu6thaqw=;
 b=WaoQCWYA8v1eUSHolBYwcoGCqd11SDxwe7Ck6c9Q/dK6dI6QEMoe3LQM2j5dF1YhjOzFq0riyqmXCorZSdNYhfUdtbSPaTp/Wq2Vtj1hpgblv76QMjFk180xkB4w2tSF8O2BpaUweDF2V5BKmgmY76BHintfkivqxLq+m4n5rhg=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CH3PR10MB7932.namprd10.prod.outlook.com (2603:10b6:610:1ce::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.12; Tue, 28 Oct
 2025 16:34:40 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9253.018; Tue, 28 Oct 2025
 16:34:40 +0000
Date: Tue, 28 Oct 2025 16:34:38 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Israel Batista <linux@israelbatista.dev.br>
Cc: Omar Sandoval <osandov@osandov.com>, David Hildenbrand <david@redhat.com>,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-debuggers@vger.kernel.org
Subject: Re: [PATCH] mm: Convert memory block states (MEM_*) macros to enum
Message-ID: <3873b85d-a8c8-472b-82e1-2751c6fef3b0@lucifer.local>
References: <20251026162156.12141-1-linux@israelbatista.dev.br>
 <811fd675-b231-45e4-b9d5-636fe63bde6b@redhat.com>
 <aP-2x314BKks2_N9@telecaster>
 <3d3bfa52-3e13-4d23-8ef7-6cb8b1ab7d79@lucifer.local>
 <aaff172e-8fdd-4ff3-8161-1c7afb1f3e64@israelbatista.dev.br>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aaff172e-8fdd-4ff3-8161-1c7afb1f3e64@israelbatista.dev.br>
X-ClientProxiedBy: LO2P265CA0132.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9f::24) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CH3PR10MB7932:EE_
X-MS-Office365-Filtering-Correlation-Id: 229c0e3b-f2e7-4722-aceb-08de163fe43f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?22gBSRFWuExOtLMnj2zxJ+hOdA3LVvXuQdwvrBpzsEGbIZ0X5yPmgHPF61SK?=
 =?us-ascii?Q?qx4JmzsHpLX5JYuTbukfhRb2iHcGe8R0UHSqxCPLBrcKgqv2as+kbu/nEKpL?=
 =?us-ascii?Q?znf9/71VGNfniILvCMvmHLJ3X5Iu+c1q1Du4+05aF8Gai3p1IWE+07bhT3rr?=
 =?us-ascii?Q?+m0rtlptrS2UR5y387ImWMaP8xQ5N+NF9dYVjMnubP79vITA35wGDL8MlqBL?=
 =?us-ascii?Q?4gw+u2XTjl/oQzwKc2Em91vtjMu3auwaZaG3tWLtS9suJT7xmiTsitDiZf9f?=
 =?us-ascii?Q?a+cYtclYSK6ooN5EgFMnEazP/T9y+6X3M+l1ehQeYMclvnEQ/atW5K7Edl54?=
 =?us-ascii?Q?ewBbOXcX0wvfgvD+pol3WVhjSv5NmSh78HjLej7CvnNBB+njpFR9acgrePxB?=
 =?us-ascii?Q?aMx9Y3f1Tcznv3iTn2w4IKh4BFuO4g3FsQUG6NIMpevytxnkvTHIwfXrJAGF?=
 =?us-ascii?Q?aEGZKetBns9Jsgm4KhYShvRGhLkMx+7puKTYWjLYfcFGV8QJbZVN+IAHfm6M?=
 =?us-ascii?Q?J1YQQW72Dsan7v0AqOGHSyZ6ThhJ5wg/CSYwG4/bZ5VpFV451QhGVrIuNVWV?=
 =?us-ascii?Q?ekPZljp4WbXqBU8ate1xnqzJyIaTyChgSUwUpDp927dneyf2xTQsZzm9wc++?=
 =?us-ascii?Q?kObRPKfovbLYNG0g5Dab/rlWE8/DOlB1z3x2XUMvVXv0ke9StaEucGRV2jGr?=
 =?us-ascii?Q?ctiTPxNxevf+25BRnufCdHRu1e7qFJRhqQKrmvLIHbf5SBAOWBcHyjE8szzj?=
 =?us-ascii?Q?QDyNkvuTU0aIsx59hkWHIqboAl2D0bAOFSVfZ2AawMKarEEShPGzuMkspAoI?=
 =?us-ascii?Q?t9NCj8/+30rM26bkIL5yTucZatbkW3xq7Ijqm3TnG31vQaHzjrL6DfbXU4VE?=
 =?us-ascii?Q?/fhlgfPJr2ayKPa7BXwjWalEovBcWd0EGJnK2zKLvnoGfmbQ7XrsJITO7vmB?=
 =?us-ascii?Q?JkwFlDQbdxhfCVziCXReM9MqxG6KulYAZWmvzVxFqLP6Bku5oeXkK3Qybt3U?=
 =?us-ascii?Q?yV2hzLCaih3DIDmT5MBw1U46P+bQrQ1u1lE+R+SjkOoOODNr7f19IYKZZox6?=
 =?us-ascii?Q?JQZ78zbQRKJbNtkzgqiGyJop7Pfav4g6y2QqVX+25jUb7rjc2iUawzFvTQf2?=
 =?us-ascii?Q?5uy84psvluNrGfJJou7XJCQXrTlAqEyf12A0D5RczwqW4dtXjXa9JwZBjm2Y?=
 =?us-ascii?Q?qLdwPYq/Rhat1K7wlavhbLViYnsQRq9jE8m+SbBv2IY9RiqfInKhC2iC3/HH?=
 =?us-ascii?Q?wWX9QGoPkqxsi6OHcfmFk4ymjR6+WRpS4sUj+kMPt3KzH8Z64CSdvOt1Nzcx?=
 =?us-ascii?Q?4Dd9dwTLDQ7paVj6fbNWNt6+EW97TSsplVmWBTPsmmMb6+YPDEqZP1Npe4QI?=
 =?us-ascii?Q?wo8J6ITFFUNqsrKkp2yteCiXVsTb9E6XZcbak7v75RV6gZY9TzIpX+aNBgZo?=
 =?us-ascii?Q?6XcW8h3POWJtFlEmjM1q5KoWF+Q9Y/4/?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KyKiEsTGInertqUQsUJRKErpVsl94Md0yX7AK3x4/Wrd5qKfSBDp8Yi+jrsP?=
 =?us-ascii?Q?H/mABFk7gXNyBAoDsnWeHCN2hWvakzkyiYhkq79z/K2e+Swpl1JObmdxKnaI?=
 =?us-ascii?Q?3bUQZrSjil87syRG8u5yIlKshGs5RyGZbBnaIPUBtwpt5o2UjsCpDnXoDodd?=
 =?us-ascii?Q?kRP9FtqK0NYweovEJKHA/pzplFPxP6N1Lok29s6FOd6zLj4/3nutHOEIFBBI?=
 =?us-ascii?Q?syk5UkbdwOUn8ljSep4XeOhc33nqIpi49phoW5fmpyJwPNDSC9oBfr/9bmeE?=
 =?us-ascii?Q?VLBoIpK3tw0zWRz7HiogYuRqCUaHlLu1U7FBi60nFr1Pg3bD5UK4GHRQE47h?=
 =?us-ascii?Q?CIplPODxAtYA8gEP3Xs/PEdGNUeKOED7O+wxAEnolirROX4xOPvrEh8UhA2E?=
 =?us-ascii?Q?2TJc/IOT6G7afFUnO8idkD1a5q+nxpUG5LeRt6XvMVsTQLVFMu/5njnwWmqc?=
 =?us-ascii?Q?nNsUP238PQbQJdlxIKNdlZojOn3swCebP1Lk6DnAICctPVjP8g+Y8cjnMHUK?=
 =?us-ascii?Q?9fJb+0mL5d1yckAuN7JU3vPBcWNueaYLfmHQ4fWxYGlbXSttjlrZpsqqjiyz?=
 =?us-ascii?Q?6GvB3FLKTUl34VPN9U39RRfnzd6tAYQpY4UkjvM1wOkUeoB5HGhYI9TRpPZT?=
 =?us-ascii?Q?Ka4xl+unHDce9QkZvdc/8uvwnsuoXinHf4yD9BAMLOmSPyV5VR16ORakLz4T?=
 =?us-ascii?Q?LKLxdPdnPmbV+PPcrMhgZq7hTby+qT+N89SqYdcc11WRrg4EBAFB+GMNuWk6?=
 =?us-ascii?Q?rXSN8brRGHKL6JhjGoiQBKC+eGLuiRjCFioWqyg8UNqOPnSy8V5V3Lf9f+nQ?=
 =?us-ascii?Q?VJRIib//L7IvbXr5Om2hh2qffhBZYX1qngeE9D3MgxA3HIFglJVDAQ+fnpzu?=
 =?us-ascii?Q?7u2PjaD48MEOdWKsqx1wCoRKQAPBFJ7HTwVXthngQYPO5AOFcAH7qMQB9/sb?=
 =?us-ascii?Q?PicBieqA6KJVgoaGjHPIcscPXWxwS6ayljzK/L2ifY+uZVSQEVBfKGAMQKdN?=
 =?us-ascii?Q?WPU0N1YrhOW0hVuif5MMxYTAGR+TzesvCzGAeR18IEmLN60XB+UDcHwmSkmL?=
 =?us-ascii?Q?7edql7jBYR7QKD7ak912tehyJhmSfAavEVQILXz2TA3fMMkkMoWWVvEFLvVR?=
 =?us-ascii?Q?GqW5dPyTSBDIB0iNKkDPdnaSyLf+/Opot/yBqcFW1Bz3QmBtM/AP5ayT7q0q?=
 =?us-ascii?Q?2zjinJx5zw6fOfo6TFjItazPbrWTg3bU4WSgbktCLVNEroyi/csNw6R7ef8q?=
 =?us-ascii?Q?lFBHX/zHF5zOV31iQZ9z5JmUGgSNWPZe1wpbg/fjmGzUPT3wEXENGdOwF4qq?=
 =?us-ascii?Q?LFR7uKZ89PwWraNnwcaBHN+sNwJ0eB+HhmQ2pCYRTa33QFsdteBBtvzUSLcC?=
 =?us-ascii?Q?DXWVGwWiCu3a0rlcAMMz0xMJ7qaw7d6amNgkWM9UvnPDnibzHN0VZjuzX2N0?=
 =?us-ascii?Q?aPKjfOxUZi6gHy1+d/Ztqp2ryMggHWDQ+U2e0Ktr1Oyav0OAQydc7S/tEHmv?=
 =?us-ascii?Q?BqkVnjczAQAbtV96cNDZJUD7sSKeNSl+hOo7DgdohfY/zMNMEEY++V7FnQzt?=
 =?us-ascii?Q?UWpR7lfd5R2hHvX4b1/MEN+nXHd6jF7vgtPQSWMdqvGtg8420wmyon9jZccs?=
 =?us-ascii?Q?4Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	4HZaMqVAnTbU4wfIYrECEkq/gvhfjKqNXms4Msu8tdeEpIW0jI/QJaSUoGQvdZufgWiGgu0j3hbR824fGHe4gzRnvRXvG5kKX/G8Euxi7aZbsoCRYv9egLsHigv8Pw4OdV5SvoWzLiUU9Zgcsf25Szf/xWtV+pyWn6cqtENUB77yOfrAWFZ2A6Et63trmF1+cbrwi7RrnGGmzcNfxnzAK54Wqi5sZDd162QN3pQdicLSAOfCetvqvLwbCy9wDu5ZHUkAAkWr3MY80FSlv+N9X1CPSicvt32F0FQzaYkoB+SCm934Fo9ZQvxRtKDJpALELbHWnKfvPoGLuEMnJ8h35kdJpPiQ1waRE4wdUOxx1p0BZHLBefA8vqfVHhb+zd7hE4nuFfptTqDJhZvsPvl4HnM/KJa92XjQN/GLAeLDQfkw+Nuxwyc2ATtPkmVvkvqg3WblhZX3PYJZj1WEq2MaTG2/7ZRCBMmRhsigVmhT8X4eCouWo90GGVUrkzfRe3I87WjkfGyC7FNknxV9IaEAdCx1V07qByhS6K1GWoTSCoQAi0D9y5bAEN3BAFE4x5NSMG+bM89H/I8ZyVZMrDjZCZ3ITH85RZh4kBq9lm24YQM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 229c0e3b-f2e7-4722-aceb-08de163fe43f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2025 16:34:40.1913
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gGCRzXzmpM2XBds/Sf6pkMxWrHhjahOsC29elmzIa37jhIswzIL8eRs7IMx7jAG3CW3TStdmiIKxsuH4coPVVXKpgo3aPN3oqDh7Ik8uwH8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7932
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-28_06,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=498 suspectscore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510280140
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI3MDA1MiBTYWx0ZWRfX9mgI0SvSafYm
 khTjx+33caZe9UfWJvWAzS3+Ckmogwu/44fRuLgr7QqRQJ7KGKNzRFTgHjvsR7EtKEXvrvDPTF0
 XViSoLnBP7y7+JDn6syHppL1CBtfroe+jRYXk1TqLyO2TEeDjWxtKz7MmZfnPqyT8wggYpZOHB2
 4spc/RqOte/K+wlJUG6Ii10m7r9AY/ASFDrjKEWLgyF3UbiuuMQ9242qPx3VVGezY6LkoEUu0Ka
 js7s6yP9s6JLKcIZ76pDKPZE1XxTGZX5k10kYpDTz6NE6UmlpuB5Zd9OG01a5VVVqAZKYMsaVbl
 lbag6vaJ5PLARlq0qxOMCtxOibTGgxQqFA3qMXN7AaiamD9U1RUksiAqnJe1jYUYzvfSNCTP6y/
 7bs7yF0RC0TekV6QWZC06K5SG8dX6QCF0EzoLZygWfapSDmXXb4=
X-Proofpoint-GUID: W4BVsxqSida6ASYXps91nQ1ZmTztPXC1
X-Proofpoint-ORIG-GUID: W4BVsxqSida6ASYXps91nQ1ZmTztPXC1
X-Authority-Analysis: v=2.4 cv=dbiNHHXe c=1 sm=1 tr=0 ts=6900f0a6 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=gg0cP4egp-JiKA06d7QA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12124
X-Rspam-User: 
X-Stat-Signature: k893661iq5neuuaadypicc5m616tgd3j
X-Rspamd-Queue-Id: 10D8212000D
X-Rspamd-Server: rspam09
X-HE-Tag: 1761669297-111176
X-HE-Meta: U2FsdGVkX18g2Z/19GhZxmUe2c0m7yhQPs3E6mCegP+P2CXFbH5psluoDXJj4j05dVdtlph2LfL0fn/hFjd9iTt0zCv2RP/XKkWYvqQj4SWGce7UXpBmA5kqWQHLAVxNp4Hq6kLCaABVVLP00xZlWgK9OZWQSkwq9Av4kOOOg+Fhg9NKCp+xPiZ2nGwPuRosiOB0pneKHUKXMXOlYDRg7pAwsCzG64CuYrV1B+zClHYpOc86PJlKH1WuUUw2TIWsrLDU+NHH5LRbtISy9su13kkRWl5xOoJEkWwtFGrwb5rBrOk7bZQ0wYn6Niu2C/GAhZcwuo//4dPT7+BCSkUWkwU+8HdvazEsE4cJ7vObNXzQMd63lRyoaxI3jlEBPMCn8uBDE46RmY7yjyxw60LsL+j1IKhh6xmp27oASZ9xIhAJu++MrTFJKHG/1Qkgw0iOETmVtocKEohwrP938j+RlzHSGdODCSpKLTP636Y/v0g0u3XIGYFlDuRDLADNnrsDWnph/SykIEiNcvXdihUDIwcGZi1vfjUt1zW7vjUSSZjSpKNHg4yNINCmNViaDCcSRs+iyMgmT48hm3Wena0H/Sz0XhsgY+oYJpUjRnnDvFucAdBC4FXcsGvKs0jx3i/INJWT1ScOHho3k9xQ0+rTSnmnof0wqB6m7NCCqW0MIcmCqxJgiS7dHr65WUoqxFAPetDhWpP0OEsMi5ZW6BfGaRMxXIaNgtTEvbVXO0B6QyjQZhkBADcZe26DkmUyBHtGX/hDb1UBo9T5xAtzD5j88d981UAKFwf1l5V31I0+EdunlCj8QZ2g0F1hBDZEu0ujkKacEMNdm+/B+J0c6Fa4SPcT2/4LiMadJbYhs4JBQ7qXSBEOa02ktBJIwXA8xCZq9Q7DrOccEa6Y4t516SEgZp30LYavMzvKeHfe/5r+lB5rYb4IcQ+wAAbPrmxJ6U1sKFvGQn3vBL6FVcol+mu
 /wRlm3rc
 ClUyiIFapCYow1DYHZNd2xLpE4tR3IpcGDTeXzW3xfvgJ7SJUcMLn23oDKZK6N153/fj2f/fsHKwIqgmt/pJeaxLNyVIvoCQwS9gEDi96YgrDVJc4/QqEdWQKmdYQK+0/66vnjJLJ5xwvYGNl07WyOJp+xch8qo/py8FyHhELj5hT68e9X8RXDix6S9Rw/44iiI3tqFsAxDkV8PEH04FTDDrfdx1ixrXz3hqi/MFFm2Uhw908Bb/WY3XBC4KJYcjXJPnMjGuhesK0bTZc+w/FerhkUWVV6dzuKuR1V2plrh4n/6D2qwa9l90maSEvFkARCpDYzKC7a82UYSEQ9etxPLMf25PBryMkncKXOGy/KCLrDFKbs7VYJotPm7cykRPy0pX1izm0K8g7WWk4g88BPXGRBIbJ819L53jP8OV2PC73FsuV9oLMYZ+zmxhcFjAoD7OS7gryfLFWXei41gqxVsfmo8pbuWgkfxi1LgVslJB+vh1EbXuJ0iEf/0yeYcbmKGnXWCjFRKpMhppFGVKM0le2E6l/WAOEtjndICH1zc2bUTbQSBjijjwgtu8VTzRjNZjflKXSDLXjUKqHT83aBgvpPtP1gwLGva2Q1mtHpcvK60zuTZ2IXx7cKxcRnh66zqhBv5JQRhRXpKTxGP4YPPow/SdnRGo+Vkkz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 27, 2025 at 11:53:57PM +0000, Israel Batista wrote:
>
>
> On 10/27/25 16:46, Lorenzo Stoakes wrote:
>
> >
> > So why are we naming the type... does drgn require it?
> >
>
> It doesn't need to be named, but as David pointed out, we could find
> where these values are being used and replace the type with the proper
> enum. I quickly grepped the codebase and it seems doable, I'm probably
> adding these changes to the next version of this patch since there are
> some things to fix anyway.

I mean we're getting a little out of scope here but fine, if these are not
in fact used as flags, I don't mind, just remove the silly 1 << x values
while you do it.

