Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05932CCF9E0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 16:12:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DBAB8E00D1; Fri, 24 Oct 2025 12:12:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58B698E00C9; Fri, 24 Oct 2025 12:12:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 405558E00D1; Fri, 24 Oct 2025 12:12:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2725C8E00C9
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 12:12:20 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E78551A0EB3
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 16:12:19 +0000 (UTC)
X-FDA: 84033499998.20.BE55C23
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9536B1C000A
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 16:12:16 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="Iru/hvQ/";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=d+23BVcG;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf20.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761322336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H3R/R51LlUwMblpLcVoc+z8SNYl5NkjgA1NIvBoTy7o=;
	b=BDdXqx2Pyc5R9iW9ju3qJNXCyokprOGzN32io/MiRoQjPljIT2cAv87LmxDoEo4p/KoZ2k
	eMeJ7msE3rSTjqjAJL91/Bi8kL0bm7kjEtPlFTyGEojsE1EfIM/lCd7fZDHO7PxbmVna1F
	O0Sgx6ht9Pc+L69XhGBQTiDoV+HJjSQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761322336; a=rsa-sha256;
	cv=pass;
	b=euYDeD03GempIxcZwAN+zCVQbUWY41xHh2RnAOHlu5yaK9ng/DL0jHSF6KGVGDMFdSl532
	vyOSz4KKjcAuWzuriCMzyhr8DIM0VSj/R+IPIYB8x0Md/Gy/Mj1z76pp9nNymy0jGOniUA
	jpSQXFJ85EYSqF4KG/dLFwl3DO2SGwQ=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="Iru/hvQ/";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=d+23BVcG;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf20.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59OGC1YD025973;
	Fri, 24 Oct 2025 16:12:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=H3R/R51LlUwMblpLcV
	oc+z8SNYl5NkjgA1NIvBoTy7o=; b=Iru/hvQ/aiAZgWxw4Jep4gMJom+6CUPLUe
	0Xi2yGdyn35fOrYHBl4J3KjtStry4ztEDkEev/0xo3upZjuMmOfLnZQQIXkk6+oS
	OUA53Q+5yg2Dd1PDJFmIxaF7hZm0T2665LyH3BrJt9tRV1aUcrp3Ade6sq/ZVt7C
	ifNauQxUaE53t1/CSMdNv6cwC1MWm+JiJQMQWfaSvVQP5/CEWsQDpQ5T93vxdY/o
	kRQZ8r/gRckYDeg9BQrY4kCY9doQvpPzh/CKYqze2J8C28cTaaqbMcxvlic+dcbA
	O0HPJx7ZHdMbVABPI1U6M+20ezmVdytQT06J06bAbG+ts3mBCs/Q==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49xv3kw2t3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Oct 2025 16:12:01 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59OFn5hs023248;
	Fri, 24 Oct 2025 16:12:00 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011022.outbound.protection.outlook.com [40.107.208.22])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bh59qk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Oct 2025 16:12:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BsIHo8JLspRCHu9alo5VpxXjtDW4d0K7Gw/GUh39BO3jK4+lj+HiI/K2+9OQs//6x221/QyvYvQZHT7p3kdVkplhSiX2mrffVMScbA7tWxX1yvLQNM3nedxg1+GtKnj8UUCXuay3wYSd9pTrUocxbu2ZF+PiWHFF9X5B62iTCyfyCVNzdxDBZo6zVL2cOFkJS+3cc7zwv50lL4wJF9TcNFngZePnwl1c//l7B71mpZ61klaiDpLqXGnZZ0+pPw0Vz0eAjpVg+CKqOOCE3ZjKxtpd38cGe2T25qDz7w/TJydm6jmL9RFzDOPuy1PjWMGc5VpLQiJFJQv/uwPzTITWDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H3R/R51LlUwMblpLcVoc+z8SNYl5NkjgA1NIvBoTy7o=;
 b=Po5bfFwr5WARpkuMksEHbWykg16pobTp2t10bEZZPbG2nB7tupirB2tnr4l+gayKcF3aNch/NuSioD/sfl6LMznFHG1t2A1NZ/xy5jdiiXs2Bx42Z8ZNgqClN4qg/7D4RpK1MIbmyDHz/q3bmHFugQ3ciJiy5r+jL7V5VvSQKkdalC+BF1uOuXH8IWGH53DfuCZFbS2fRCXxshK+W6Ua5FutdDCHjD+9FP88sE5UWz0oAE+UYTRHAe5L98rBiUq8+yIqksdT9+fSYWLRAGkIDPJfyuGypiEUXosrZyUaltUoJZ0TjVlop3zYGABAJqVMFBa84IO1Cwzw2hoWtw4xqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H3R/R51LlUwMblpLcVoc+z8SNYl5NkjgA1NIvBoTy7o=;
 b=d+23BVcG+hD9+oL1Sf2ENG65hCfG1/dziofWWEoOwdk759r7aPk8jwYDYBdIouK3Jbw29NlbUOzgEIeh+BqPi3CVCZnRpwSUlLQUkeQAP1Fu4GWIjJaDHT15UB8pspPXW5wNLFT5U6SDCpmUSBuUC3NjsQ5sYJ8MKmun/jTh/fw=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DM3PPFCD1365510.namprd10.prod.outlook.com (2603:10b6:f:fc00::c4e) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.13; Fri, 24 Oct
 2025 16:11:57 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9253.011; Fri, 24 Oct 2025
 16:11:57 +0000
Date: Fri, 24 Oct 2025 17:11:55 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Zi Yan <ziy@nvidia.com>
Cc: linmiaohe@huawei.com, david@redhat.com, jane.chu@oracle.com,
        kernel@pankajraghav.com, akpm@linux-foundation.org, mcgrof@kernel.org,
        nao.horiguchi@gmail.com, Baolin Wang <baolin.wang@linux.alibaba.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Lance Yang <lance.yang@linux.dev>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Wei Yang <richard.weiyang@gmail.com>, Yang Shi <shy828301@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH v3 2/4] mm/huge_memory: add split_huge_page_to_order()
Message-ID: <a6af6444-965d-4583-b054-6d7721a25e0c@lucifer.local>
References: <20251022033531.389351-1-ziy@nvidia.com>
 <20251022033531.389351-3-ziy@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251022033531.389351-3-ziy@nvidia.com>
X-ClientProxiedBy: LO6P123CA0011.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:338::15) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DM3PPFCD1365510:EE_
X-MS-Office365-Filtering-Correlation-Id: 21dfe746-d668-475d-babf-08de13180e68
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?kYc9l9+HUoAxwK2XtE13AGDZpMWs0wYyCoGnbGLUHJB4dYaOi8Qa1NGlU8c5?=
 =?us-ascii?Q?T/G672hzifcB2MnxtwNYIIQo2g2SzIUFwaKUhWG0XxdWzmDW/6GO7kFLWE6i?=
 =?us-ascii?Q?0soXQnD4IsH2rRuq0zWQZD8NjnjIaDmWLJSjHxfm6k0mxFS05648AclHjes6?=
 =?us-ascii?Q?tjkXyT1evGZ7H54AsM5oTgAMWhjmj+Gui/LXHsrRgqKbmHlerlCkgCmWjMeG?=
 =?us-ascii?Q?j9fhxYdSocNqO1C2DrMIiXaTRdX7jgnZp0MdKmvu86Ib0fNFaAgiy19RAcN7?=
 =?us-ascii?Q?OoddFD2ql0aRDC2qaVJyBcQwuLYWa6Ked9tht0MDQZuwwRaINPv3uflXI2op?=
 =?us-ascii?Q?a7GvjtWQXh3YMEZWyjpbRYkJiodrXy8zEybL4yX30ilk6Z1bVJzuaMoQLt1d?=
 =?us-ascii?Q?/yJ8V+PdOgtJGpOWrc7L8hnj0rLJ35RMfdY3SVYuRPNJuznVGG2CRYZ2DGtz?=
 =?us-ascii?Q?oGw6f61HHJ1SvjgiUa2TkBYjl7E+TR5S0x2Y7TQl4FWUG4aNCVXfUyAlOAX8?=
 =?us-ascii?Q?u1QWyZHmj9Samyc2EY/5y1ymSeSgh2N4FVPlwuonJLJvAW8deOsX+sM1ZKDv?=
 =?us-ascii?Q?DnQd2mZfZtv/BZvC34yo+jAYP5M7eJB9eu028zRtgHT2O9Cm7dTVLChh9pMp?=
 =?us-ascii?Q?hFnwLTvtWsTXbD3aZKb8xhJ0zkkflCV1XyhuzLvVn0bQGtZpGwg4EQvt3hJD?=
 =?us-ascii?Q?sRhE17BKz1wzE6/XkCE/md82r1+MWmvJzsjJ2gt8j5myo7I1/wAOlm05F3p4?=
 =?us-ascii?Q?6rDw3dj5ikVKt3w5WBjTzL6yGpp1wnMc+4kdYV+unZ93IiG1JmUaIzyBPIQY?=
 =?us-ascii?Q?6Xw5b22pZocspT0I+7/njjJ1qKpr0gnZudMmxKYM2UPmhE1voQxI/YRZYMGW?=
 =?us-ascii?Q?NkJNg/iRS4+AWV2eJwJ4A+lkXEiZ2vNM0lVx4Jn+5oID5K9Idl+MJHqa13NZ?=
 =?us-ascii?Q?C+8ExaobOcpXcmVcN4uoTZ0yTyjwGhu0mC7IJEqbXYOK53Jdn6jbVo9flUKW?=
 =?us-ascii?Q?Yj9JMN46UY7Eyv7QHWd8tTfRGEkytue25LU0v/8QXWx2uOalukR6ftTprv8c?=
 =?us-ascii?Q?rlsYTHTtVUjmhdgZLBmSJATyNB+ge1wWnrFdIo43AOsJtKwDfG5TXPjsEN4f?=
 =?us-ascii?Q?nkwqvmogsXVSEu0IYh+VMclkyp7qtUePh1Xtj4Zdf2XFJoY8hIbmfcIWuQry?=
 =?us-ascii?Q?SLU28MR3ba7zlIrznLVnG3e6oYlJJZMnbmhzCJz2VR/70fhaHPUW24L5vYuT?=
 =?us-ascii?Q?PEgnCIet4LvcRbyPVRi/ZD/Y+RX+u1b4XOQOyUgBRUHllez1sGCfpCCC7T1F?=
 =?us-ascii?Q?/ARZxSoybHZJBS2VqDsxUqpMbCLvcLo6Enb5TpEnpyyW8mHCrebSTgZVp5v3?=
 =?us-ascii?Q?zgvrB1gIsPKRin4meRFJMhnM51J5aI2LIsS8gVCzYtGjU7L1VWO+oVDQT3lT?=
 =?us-ascii?Q?pab8Ez3/y7+Fhw9haIQ6ilFjHJX617oC?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?YDV//7YXLRq6txMHk0RgAk3jgrhi/nPFKQX764b5u0nY8NNK3690blVmWbNs?=
 =?us-ascii?Q?Vl2xmvA9ui80RD2OpdkLDSdLKlIsfuTlu7X91aIFprLd63ezQk9xWC7rOhR8?=
 =?us-ascii?Q?OyKNS4N957iWdnB6aLTynhi9gYcnlj/h1pmERTFffw7dWtTdZq9Pk1GCgNsO?=
 =?us-ascii?Q?TdNRU/FOrmd9jCcoKRh4L62BTPYRF2MPaKJg+Kwiela874JgdsSzv4Y4koSK?=
 =?us-ascii?Q?vM1m3gCPYBbpvwJOn6AQ7mFwI1agEdOvtb7Ejq61eu9erZKhVA5p6+i7c8cZ?=
 =?us-ascii?Q?GeMdI5+q3GiI7yOw5XcYo27dE0wOX5UXLEPW+cr9E7jjKYy5Hwz6RaBKr38Z?=
 =?us-ascii?Q?ucTEkDmRHZ5XRfK/v3HrxyDrD4h0WatefWW05Cn4sinoT81Nk6e46+baKtwq?=
 =?us-ascii?Q?jdAsOt3stkwtj2ifLd3vjnocd7FPRpH0OEFNfzEtjr5c2bnKAV0GSVcHxJPl?=
 =?us-ascii?Q?mCuxrfv93t65To8lLPrXKauT+hlaXd6A/dtxB7TVVVZWzGduR+i9coDiyh02?=
 =?us-ascii?Q?ZjkbBc7RynVetYfCb258dIBfZC+SkFz4yC1+xvPH4KdaZIhjFsOonqz09b1X?=
 =?us-ascii?Q?ya8q3/E1bLLCyKIKZ1RfarqN4DJp8U78gwrV7QmPYPZNsLpHolsSTPtJuzNS?=
 =?us-ascii?Q?ZzoT7Sz1hPQVyPK6W1zPKN6SDGC3WmaiJaOKTYdMSqGMmN3/NRkenhThES8a?=
 =?us-ascii?Q?JydoTpWRW0P0d40B4PoxIktgWESkKYYuyoIKe8BvWV44zAgFPFLFFv/Va0PV?=
 =?us-ascii?Q?DC6rZ/b/Xp43T82FrYCvY1x6OR7dEwhZNq+kXsqObo6MZ0hQ4LHpS0WTJc20?=
 =?us-ascii?Q?7UJpdOYL94Y17RpjdHPch0kN5lEavmkATancG1O8yzyEgaeQP8zmYUSNXpmt?=
 =?us-ascii?Q?4xe1Rbn06Dfbcjct+4TW+meSMrVe97L8TjYT3DEC2p69a9gtyvv//oBIKJO9?=
 =?us-ascii?Q?qsWbty0uhaC4q8rIPqIofkImldzHWq3dkiHHrx8hGVztaZHcJQPJkP1+y+oZ?=
 =?us-ascii?Q?M23fhJHvGCJ6BbYkqBA/sBaPrHHgLORZWJCOGDakmHVDBBq2BKw+IlPW15PW?=
 =?us-ascii?Q?+PH4Wb6nETPJhol6DGPO96hhyHcrCVSWZiJMDNGWPmopiTIOiFXnVZ1EpDmo?=
 =?us-ascii?Q?IfXfoGekLG7BOxf3V9bKiXN+8TI3BjGTGinsicGxe6WLlySDcgt8GjEASgIh?=
 =?us-ascii?Q?v8zAYNu7g36cEa7wpjXNanM3QoFpCr5ZGoi9RXDbDTk0tknornNdfFMER23F?=
 =?us-ascii?Q?1dUPanWb9A9L/lVjhQWS3fzCzIsb7NOqWdlPRCxvUfK5db9Xr2s1XVkYQvgT?=
 =?us-ascii?Q?32KMZ7tbnP7Of5g52UZhGRRoZtCIkm6UDVLSBiAaLyTUFtHkHi9x2SFzk7Nt?=
 =?us-ascii?Q?w+cdvsHN7AGmMk26pQA5z5tdzFmlDDYSfV8KhqQjal5k10eDyRn01vLisuxt?=
 =?us-ascii?Q?zOwug7s0kL79skNce4d+fx+qGx1qbeHLg5vV8ANxk8JcW4E6W+h7DHOh9f8n?=
 =?us-ascii?Q?pOK8uKisMBBOx5MmA/K9yrW93dK/et4goqoM/uQtDfMkz8NKVQSH8JJXqskE?=
 =?us-ascii?Q?HbFn9XstsFwfeo2q07NDoLVPu000LtnLHxQEANSorc42atfyIpGbpIIl3lzF?=
 =?us-ascii?Q?zg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	hnGvrkctQE5cXb5jmDSeNL0oa9dElgiu54WzxyoyYQSeRcbOCrKeCZAoWJeiRAZqJ7HZ6pW9UV1aUQb017fOokLcnJDk9AP0RRbQ2Lf2/4x8SppyAcbb503QV9cQOj6pbxtcfr9QB2snmw2SPxiacfDFohpRIfeYll43sEaDaGACKfWymquAYz/5CfaKn0w+HBcmRL8a+5ZqRaALmFqEwM0HMfrL++VIEphyEvVjiQykNDTEMROditgocRq1SsEdgiS3VEcul5/JMRN38GexmXZdoe4rWdaQZEY/IJlmRHlwHpZIika6Q4czI2RhTe4P2J8VKw+Ix8wJgHv6vQIu/UfHfcEQ3WQe5dr5jEcLK/TaiTmywmD2twhsX0/F39b2isBR272m4CuBCQWnhOOnDlYYHjZbaK+CayGLsBhebLgCRdTnHM+WaaVjBxDXgN9R1cqJ0nIyllXUvSmjNKJADLp1PTB7xqRR8LxqDG9ZDgQH79ZqeX3NuztQquEoX/uNPvYvUTvW+SUXVuXQEmVCfP2x+Y5thoVAyLH17NHaotDwW1YOwhnwco7NdChl4HCsRhDM7HdSDlgQBQQqpfVpY8mvmAhIE8+P5h4amio5liM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21dfe746-d668-475d-babf-08de13180e68
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2025 16:11:57.5719
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 61q+5h/t5Hvscmdi/RjvwbYnWm/mXzUCL06NPzjogyHRaEzvLaDyKf+pMhRwLfhNEvsXBGy6UYR70FVJCO8JJawAq178EOVLmX7jZb/L0IQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPFCD1365510
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-24_03,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 adultscore=0 bulkscore=0 spamscore=0 suspectscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510240145
X-Authority-Analysis: v=2.4 cv=acVsXBot c=1 sm=1 tr=0 ts=68fba551 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Ikd4Dj_1AAAA:8 a=yPCof4ZbAAAA:8 a=ewQKbfUJFe_CF1CiK2wA:9 a=CjuIK1q_8ugA:10
 cc=ntf awl=host:12091
X-Proofpoint-ORIG-GUID: eZmLBum-qz8srkJ-sIrYQQympcTLK4w5
X-Proofpoint-GUID: eZmLBum-qz8srkJ-sIrYQQympcTLK4w5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDIyMDA3MSBTYWx0ZWRfX2L6ev3OPAh8e
 XxaPxa87VDB+UFz9U3tDgBrjNbjARHHLi9BHn/4OIhuk4BDgZBnx8S+uiWOGBqPn8Ln0T8Jnwhq
 CEjiw49PdhcpnOjIoRvfhkOErcd9kVTIuBup7+s5cdElGA6YziKOhHU2Wemy9c3xq+YSVMTUb20
 bbbAIct9tdlLoOXiiSKYDDhlg0/yClX+EKj2F0sdJYC/ustjRKSQCG0TvVOkFJKrb+pEWjPw+ah
 c8gataBkBVP/vbS/yOJ2rgFZ/s+UU8wnrqcUE7NdvWv5aARpbO7bJgA1O7t1HRhyUueWdQci1en
 ODKUikLqY/Np9gyA6qzh68VpnzGmlUsrSrrGPPeoEdfNH9rQBZ5K23rCs6Izaj7zv3wVibeGoxr
 2Nk4z/tlDf3chbHTv9Gt2eYc3+BXaNubLRLSwpp4AaQb9IjqSsU=
X-Rspamd-Server: rspam01
X-Stat-Signature: rzzaf1tfx4dxnnm5gexnb7kmt7z4o56w
X-Rspam-User: 
X-Rspamd-Queue-Id: 9536B1C000A
X-HE-Tag: 1761322336-526491
X-HE-Meta: U2FsdGVkX1+CpKJa3jJkQV/n8A02dNfWrHi6EDtkVRWIivjZb/k34Nx47Zf0qhhsM+JxoIcoKQqdrbWQn6NOMDMR7M97g6aZBiGh+OBZyZBmJT2RlXENP6y1V84qFjSyWPorjqI+/LpI/ZoyW1AM2rJaJZlvPLvAb3/FRIIJebP6D0BMCxOyYy/4mgBGQI6n2OeaZm6Uth2cDwpsSbdAuxPPWDLRHeq1t8g1Pza4SCQKBv32cQ1fVOsNtfkkzfGq84KmMMHzJPidTmTi3MqpiiQx3xnzUrbc64fzU8SK8/+N5Xc7Szt/JWDXI+fU6yzaAygtqt0Hk8ReulY3SkeW/AJY4trpxEsTtUKXzXKsvEkG3qTAWRiBxGNnmLXrdZKfzilsHwkD2AlOmbY3EaDF6AG9iT1318bvpKxYcJGP03aSBa1J7gXPVrUjA6iUwXyH3SYod30VfuIYkYNLLiR2CVidIwMQitv7QkQLEgLbCmQV/+X28X1OhF/ja0m4QiNFMwfGBPdSsRqDZ+nijn1X0/s9X94dTO/Qqpm/ek3rF6SY6GxMVmFur5782Ij8TrqaCj/Yms9vBxpYGCVXbUfXd5DBhz2u12Y7n59LnaxrqYLhloOUQCcXv7DXmSHdPlS1OH+WHQHFaJlEA5kN6CX3HzsdsWj90XMNQ4rD+J86Xy/MaqLC5KerO/3AXqiWyYhAPuBmnq4xNQBtO7smWTO/mXnbUCCSofGWFTDJe0Myf7Js/hPvQ3dmR6y/lp2jTD/wmzUWe65862y+P6N4D/Nepkd9hWlk4eNj3dSYH/l0G3hKCCGwmYNzQ2O/lExSR4jlHbP50LcXITgzorw7wU5QPYXGdyCNdjrzpleCxwHNLnWNoCrxB/DNswuDBQJWLySmlmlvI7R8NdRxxJFOHXhrJUILUm6etDiet4a9AmboyKXmcqYXifz1Rm15zF5/VbH63QrDE2Pb2KsHCFXYEln
 us20/28M
 T1DMXKzlY55Agktywt9m+rbBsrhDkU0MrLOWZSSD6dsXWdfow+ybT8zua+CjHhwlTbUTiW6sSJ10nMi5ig5IbtCHdT4pQysltfaYcgvxMEHZksOPnL0wnVWSYGKi3CX6AQx5FYOT8EUVvSjyrgpvqoVAet4zQLLQXrzYR/UYnlf1wRhcBlP4ZlecmOhXW7SbQwRl0BV43Jq/ck2u+QJO3anQU607NmPwJXBhMG3YHH3ttT6h7Hx8gZvQ4U4a3jf0zin+2h+IINQe4n8D6eQPdU04wmtBDNl0/QA6JRFNlIoYZyH8rGpZCqXLJetInXOIU33WFMjQXE3wNEcvw2gr2FAR7tkURKDxdxc+9JplKDkow/CcegJQ96L8yeJu9TbzLmShGyB9e5anaLy8urB+PXPD10BulI5t2U/rTlt9OMvAgHDR4/9mXpIrrcw1+59kD5lExvYqKDh4VYUMtEDu2aX1BxyRrUZA51Ptce89oHGbpQJE3McnAQSHo+ywr3TZzD88g4SpI7kvvXfQRCVhtvhKF1AP/ILe1B+sFOiscxXrTzMTBncjMDZwlam78FaPa+EkNJyasjPaKGdicQ+VuzfDaCril+kTee+APpFMFsvFb8KqttCJeygmoHTh5KrTd/16Kw5hKu28wkFKKCyHCEEfQZpH2f52biLVvAPdmvJBcaWUXSTkcAT5sBYeMRNASmcRf6Jx9n3d1XpGxx82g/e0y6aQvGDxDB7b9k79K0vPvhVcqhhe/XkTh78Z773pQ4y0wgSOhZevHt2cksWRz3ahnzgW346p8eZLEc/b/DIh3hFS1P/bPaP7Al+9RuIxSd8wn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 21, 2025 at 11:35:28PM -0400, Zi Yan wrote:
> When caller does not supply a list to split_huge_page_to_list_to_order(),
> use split_huge_page_to_order() instead.
>
> Signed-off-by: Zi Yan <ziy@nvidia.com>

LGTM, so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  include/linux/huge_mm.h | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index 7698b3542c4f..34f8d8453bf3 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -381,6 +381,10 @@ static inline int split_huge_page_to_list_to_order(struct page *page, struct lis
>  {
>  	return __split_huge_page_to_list_to_order(page, list, new_order, false);
>  }
> +static inline int split_huge_page_to_order(struct page *page, unsigned int new_order)
> +{
> +	return split_huge_page_to_list_to_order(page, NULL, new_order);
> +}
>
>  /*
>   * try_folio_split_to_order - try to split a @folio at @page to @new_order using
> @@ -400,8 +404,7 @@ static inline int try_folio_split_to_order(struct folio *folio,
>  		struct page *page, unsigned int new_order)
>  {
>  	if (!non_uniform_split_supported(folio, new_order, /* warns= */ false))
> -		return split_huge_page_to_list_to_order(&folio->page, NULL,
> -				new_order);
> +		return split_huge_page_to_order(&folio->page, new_order);
>  	return folio_split(folio, new_order, page, NULL);
>  }
>  static inline int split_huge_page(struct page *page)
> @@ -590,6 +593,11 @@ split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
>  	VM_WARN_ON_ONCE_PAGE(1, page);
>  	return -EINVAL;
>  }
> +static inline int split_huge_page_to_order(struct page *page, unsigned int new_order)
> +{
> +	VM_WARN_ON_ONCE_PAGE(1, page);
> +	return -EINVAL;
> +}
>  static inline int split_huge_page(struct page *page)
>  {
>  	VM_WARN_ON_ONCE_PAGE(1, page);
> --
> 2.51.0
>

