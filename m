Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C8ABD2D8E3
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 10:32:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5C766B0088; Tue, 27 Jan 2026 05:32:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C34C46B0089; Tue, 27 Jan 2026 05:32:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB8666B008A; Tue, 27 Jan 2026 05:32:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9A9046B0088
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 05:32:18 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 507A4C36D0
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 10:32:18 +0000 (UTC)
X-FDA: 84377379156.17.8DC01D0
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1ECF4C0005
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 10:32:14 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=PXeKsAvC;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=qkiCiC8P;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769509935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=T+a4v9T42HPq44XVe17lkXVWK0+otTA/38R/igBqL4I=;
	b=wOJHCcifzd2mGH0yrdr6BxJvs0FgHnchPINEP/DU2vp5vadTmzXVOiPntQlvHCdMyBF/d+
	pe0U8zRlrAGtr8omTcZqeXB+yA5y/addp+NV1LlNkUUHX6Zistbk3pIs0X4mVwnotq6K51
	GhIi1Za9O7FEeopFsBDi8hqZJmdVf6c=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769509935; a=rsa-sha256;
	cv=pass;
	b=4BG0q17mDWnh/1LrVjJocPvRNgpJiKKpypD3rGP159uJ49h5KTtKUp3r/JVK1CQhzLgQ4G
	lH+9Qbm+t2b4PmDof+m8oQ7yLdNxAc4wzRVXW9zmbXvO3Fu9MmWkpFLfZBJcsqd687pq1W
	a6HRvwjdXbyaKsl68gUKq7NI42UmzIE=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=PXeKsAvC;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=qkiCiC8P;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60R0abIY689996;
	Tue, 27 Jan 2026 10:32:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=T+a4v9T42HPq44XV
	e17lkXVWK0+otTA/38R/igBqL4I=; b=PXeKsAvCHCsaLgKdHyxlXGHrwB5JucP6
	id8m4Zs8uYgWY4J+IWboB/aCdzu56YXMbYV5MTVM/I/dRq10OP5XGVWIDxFcd7xV
	A4jsGzNFrolmXMuOFVwu8okJHTJQRGNzXJ7Gkmykr2uaTR4vbKz55hGbGiFT+9WG
	IRq+rw8acuXzIe38EnfD06ISjRFdtNCMlC/YX4JRaWisMI9rIay4KyBNtkHU18FQ
	DUdraUPekZ4dXYw4XEoGWhGcDeT/gth9sG/8ZOd8Q/85oQaXfX2xIxQPeFdpUwGb
	jYPAqqMJmN62xJcjzPC5eA96nyVUC66hQy22Ij4Z0RJtVBEjUKWJFg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bvnpsbrfk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 27 Jan 2026 10:32:07 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60RA59TL033652;
	Tue, 27 Jan 2026 10:32:06 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011008.outbound.protection.outlook.com [52.101.52.8])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmh97abs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 27 Jan 2026 10:32:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XBEHwa/+9kxPSeOOs3rKVUmusdkO4TduVDGZceaYwU0FpDcZT9RNtHommU0etapslUgJFNHFlwWzxbWkaFrqKiyU3gKThQ+GgrwPhNnCFTAqFe9IVkiVTXsHD+XuNaIUx6fWJVPbYIb4USzMijunuy5sDeoYxqdlCRpyVdHAHLoAVNGAIhoINaPrh4TiWVdttzKivVM5sGs2myEz0XhEmzbaotdO/Shy8HjTlBdl1M2ayV2pTQsC0sP3ZiBuWZ3N9MVhKk4o6ylkfEZRv9ghflhGxqoNIKkum1pdDu38ytqngepVoaffHjQTWbw7JMa4Ul4A3buTLSl3ceUphe5Jfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T+a4v9T42HPq44XVe17lkXVWK0+otTA/38R/igBqL4I=;
 b=WoVIVse24LJA+4GAR1qm0aV/1N9NTaK3wxdl2oXUCDnxCtL+iPMziwYntUTepf1pg6X5GWXAb5XGocxKtuM4/MweUXPuu7SA063ZkzqmmUgbtP8XFi0lqlrDoooBGxroGLva6VnsJ4FSzlHFHbmMlI4ThPJqu6StZf4furHgvs9Djr9iYBMF5sA4VuGtQyOAmCRSUM785rginXN6t457QVzTeuyfyvbMZy6rznTAGdPTxR+gaLDIkALRbOMYUpLKe8d8/K5IzmlNlUWBntuznZf5pxTpBE6Be/CVOyUs+9Lmlo8e/Ylg7PZa+ivumeyb0tZQh2GtHfofJf3wh56zDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T+a4v9T42HPq44XVe17lkXVWK0+otTA/38R/igBqL4I=;
 b=qkiCiC8P1CihTjtPIN3AF09qJYqUMQNO1v7QJhPR5VwQkwND61G15MFGtD6l8aZcmx7PzL1jR9j6cCdd9Y8xmcaDfYe8cXPL8W0Qaq4cW325SB7l7rkCUgSaii+lFWz+d4U69F3z9K2o/ajnth84HRngtfwiqF8R3aqncaER5II=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by SA2PR10MB4636.namprd10.prod.outlook.com (2603:10b6:806:11e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.14; Tue, 27 Jan
 2026 10:32:01 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9542.015; Tue, 27 Jan 2026
 10:32:01 +0000
From: Harry Yoo <harry.yoo@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Muchun Song <muchun.song@linux.dev>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        Michal Hocko <mhocko@kernel.org>, Yeoreum Yun <yeoreum.yun@arm.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Harry Yoo <harry.yoo@oracle.com>, Hai Li <hao.li@linux.dev>,
        linux-mm@kvack.org
Subject: [PATCH V1 0/2] Only allow SLAB_OBJ_EXT_IN_OBJ for unmergeable caches
Date: Tue, 27 Jan 2026 19:31:49 +0900
Message-ID: <20260127103151.21883-1-harry.yoo@oracle.com>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SE2P216CA0185.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c5::8) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|SA2PR10MB4636:EE_
X-MS-Office365-Filtering-Correlation-Id: b61f32a3-5d9c-4bd0-3a7c-08de5d8f4e8a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?UhvQAq2ZmYGRbhXYO6S8OyQe/qDVdxu9RvChN3WfrrZlYQaIfBEwFNsN2CbR?=
 =?us-ascii?Q?jC4wroq2Cryy2mqQHGMEv0yUw9gs45dY5dUU1UuUTyx48zNvhBP9kt/OLvX3?=
 =?us-ascii?Q?JsdpKPO3UjK6U2OwpuwRSnnoGcs8vooMphE8H8BC0W9FKV9Q9jyBIRKThqGb?=
 =?us-ascii?Q?72Pwxb5tS0ufksnz4NIYsbLmGIUoP/LKvx5nUJc8MbNInftcqQ3kU01vSCCb?=
 =?us-ascii?Q?icJggt6Pf3RFbqUeEK8bI6DKwzJpnaBTg4QoN2uBrQAazoguZ9ZZGjb9r66u?=
 =?us-ascii?Q?FTxC5/OeS5HoFTmgBG9Zi83rVSSqzfZJ5vgip0MKZ5mT2EAfcGiTDnZI2KB1?=
 =?us-ascii?Q?KZ440xDrSREs5FaP0DJlvAOtHfdqORVnpsEH+NhRsJg66dC5Q91l3irZJgB9?=
 =?us-ascii?Q?UGMGY0kqPPWKT26V36U6UB8gpnwjO1F2WB96kb4PmaaARGWvfsR9h76o7QTy?=
 =?us-ascii?Q?HX8hcZOEIs0Xaz5GJ5joBVm0ZLcSbkv+uhf94OjM9hvosaZ8gO9H9v4RC2sP?=
 =?us-ascii?Q?N72aGm6vZECUhybeohR8DyVthnOkjF5gJ9iCrPgzKpQsvl3mXsI0vqI9a0+2?=
 =?us-ascii?Q?ifXSfhQgxLR1WrgYyEod5+VXM2WyfY19To4MCesvxAOXnj2iMcusH9UHOlV7?=
 =?us-ascii?Q?DPIloEKgV81j9VCZi7gZGLIeXR4XnHYFz8P2PtgkS3hu0xnPc7NuES2+Sdi5?=
 =?us-ascii?Q?vcjRRqyIPdNfmR6LsoHuCcckrrOctqR3z3FmjEvBjhLWDTBRtcEyHKWmaMW+?=
 =?us-ascii?Q?TcotD4FLqr8fM0c+2s0Jr0hvjmLk/juzN4KFfqm5ceJjEbyPZ8eVu45BoD6K?=
 =?us-ascii?Q?aGWdRTvEpQm00QUMCpZZSF6Wmy0sGZ/AKxznnbdAWAmRujCl7tDSB7dy2PPl?=
 =?us-ascii?Q?0W6c97qJqvpIJmzxI4UPEofLQ1GW2uHw8LfUBujcfDdC2qqkcmOvATSBEJ5G?=
 =?us-ascii?Q?Wb9QBWu3SFDOxDiWJXyla0N4E6GiiJM5K97+JIQXQIMe3UhyuiIGt1mRhKss?=
 =?us-ascii?Q?7J7OzZpoAAB1gdViBXljllyrGYkX3E4C0u8PKt0+s+D7V5ImngsIywAnOhK8?=
 =?us-ascii?Q?22FqldZmPAX5z8sC+ZFGGR0nfcx0TinBNuNnVkknOFiF6VWthcJQZdPxVK3Y?=
 =?us-ascii?Q?751KhLLfOByVnWiYwWCPFpiFo7t1drWFmjLda8100KOPIuYnQeCKqeeVm/dH?=
 =?us-ascii?Q?EBtyd/0H3O6uwGm3uTnJQ1iXOK/FXz2hjy/EOPscJbOFOkXfKiiU/cNBuj34?=
 =?us-ascii?Q?nyttN/pqYckm+TLXRY4nF3o/WGSs3XXOiUghUB2XYZhReO5uiirYsoidDbWD?=
 =?us-ascii?Q?npeu2cXkVboeEyPMAj3YQHWfo/2tv77I+BkrhG15wvk6wyhnCJ3KhVa7/f27?=
 =?us-ascii?Q?v17MK+6ye/Riu3Yh50LQ2HDXR2s8mFFISaL+oI9oh4LvxOsibVIp5E3rybw0?=
 =?us-ascii?Q?60gcNrVdeaWUGTRomvHVEUomWwPjGEwiL/rkPVymTE9LUxG2LBZQMxqOHXxs?=
 =?us-ascii?Q?vmwcFyLvt3Ij3dI7nOuoP3Xf5VCB4EHgpPhGHrhOUdTO1paTbmDpn4umhgX/?=
 =?us-ascii?Q?SkJavssVYdxCjT9JxgM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fpc+udXoYwPn6GG33bva0rvY6Yuv2W32JlXrGt3NvId0L4wUgdiiySb66eY1?=
 =?us-ascii?Q?4EzGKV1BTkpJtMxzqnzV9SIc9dH8/If6eLBdswtrp76smch8QdQGioiEI58D?=
 =?us-ascii?Q?/t/Ao3kofe/vRg1PhLhl6/lYtWf5Tj6yO/6jwO4WiKxkpWO5339RhxxAd74W?=
 =?us-ascii?Q?Gej41IiwuaFTLopJSKy/VeMxXwDKM+a7S1DPCJvuF4sJjrOjUsc7llGd7wAo?=
 =?us-ascii?Q?4vjz2SKxZqzB41ovYYm5mbiQG++Uf2JtZoPOrW9KBKb5gPJRgXxtMDztSbkw?=
 =?us-ascii?Q?qepcv4igYDT9MxGOyv7Bhf7msd7bBX6FcQIbGG/kM5ZPZnG4N2sWYefbun0t?=
 =?us-ascii?Q?ZPb1mXFUsMdbhRWDgdaPgtcucrVOLvm7c7DzZYIRVWkqHKT2ItpyCqMddgph?=
 =?us-ascii?Q?GEzflVVdT8qPsWBV0g+XvURWJ3ko9iia/d32VJJnlUSRk1pTBTa0AFf4NVO4?=
 =?us-ascii?Q?2XCMd5qfvVKiwFptmZcoBvF9NNwtPxwL9C8oPQTPur1OC+7CNur4O0JW4Xil?=
 =?us-ascii?Q?LiokFS1KDPS0bkEmZ7btOZ6QZFLZJpwGp4kGUSl0fLp41kB4I5tjzpdYMcxx?=
 =?us-ascii?Q?fb0QTs0cCrDIr6kSzw+9jWPFVnyRm3Z0cederfu/3gAjMrf1/sPKQx4h0puN?=
 =?us-ascii?Q?QzYlEoDxtTml9c4YS+mr2tuAfeKLnqT0eR8XrXqzVEK+7/TaTA5hv/fMANed?=
 =?us-ascii?Q?ePut7Tdrd2jnK8X6R0tgutS6VC8cBfKLu5qQCKFz4Ulov3Z/vLIhBYXbG7lt?=
 =?us-ascii?Q?eENMkx9qrUrg6lIS4bTl24smOZtEy/36Zu/D5IHSrztUzs6ltlnUzomJpBOL?=
 =?us-ascii?Q?l25kJWV6iOwUohecJ13VhQbkihudnaPJeo7I4V6mLdNuiYNgVx1Ws39k06II?=
 =?us-ascii?Q?3xkePNtGSaFN3Yx2ldMHkxcvEuS89Sxkh+pUNqtEgMK+t8Nlj83Uyg5ZZDh/?=
 =?us-ascii?Q?0ZOpEqTCioiE35swCqi3q9vx5cRe7qO8Xl3eU/ThaU8sGuDw27HV5x8uhwB2?=
 =?us-ascii?Q?03XvSXHOcDNP0nybYDPndlyggfXACml/0Voht93oJo8UH4VnwbDEtgHKsVy0?=
 =?us-ascii?Q?crfyQw0svyDOeMHXZoJzE4x9DATeiwinWdCY34UZV6Z6nDEIjqC9Yo++vqGz?=
 =?us-ascii?Q?QowjRo/sgw0XOCuBhGM8zEVDV3HC1Bz+AZMbK1IkGCNocsmI8hqLsQGjkg7z?=
 =?us-ascii?Q?WbKkv0k9mWqVqSW7HCI9or4g6DrJrL9JTaTUMnAHVGh3fULESIHXkxrJZK1S?=
 =?us-ascii?Q?/TRw3Rs75guFM8mgJXGhZAStG6lkBfTQLcADESTxmtLE1iuTybEUl4OF7Lri?=
 =?us-ascii?Q?zO77IpiYerglTNqjVVj4E/3s7oDt7BHkhP+yi7zU37VtgSIoieMgGa13TGKk?=
 =?us-ascii?Q?2FqCuIohSO2is/ko2i5qznd0SUU0b+WeFWqAKLx4anEBafUZV5Sta3OrGbZy?=
 =?us-ascii?Q?+iXrNOV8v1Y6p90J3+tjGNfyx9eDSC92CdSlEw5UTF98lz+pJNajtpeOqacJ?=
 =?us-ascii?Q?uHNCaGiio8C/sHiTcDRmJkFySjTZWCPkzCfUsBZ6vch5PltMTKh193oaShsv?=
 =?us-ascii?Q?gem2o3wwMfT4zJaG8I47uLosrmxrKGzpUFWrhXhfgCfVNdM1NhwBBFTiHMtB?=
 =?us-ascii?Q?ZwlOn9LMsv3itBdO2IeOP0QOvK3VN6n9H50GLSuWfftP02QgY683r9lBi8uY?=
 =?us-ascii?Q?kByMHikt6ChB+zBL8WQUcz124PZOOh8QcMSLujpu3R8DF9cJJsqzl8YCFOS6?=
 =?us-ascii?Q?3gDOdHNKeQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	PfTkSkhVanqJfADJejsMcrgjZ1t/ye9GbnEQFowL5ALd4b/duNDp8Ufda7hGaavRIaKXt7nGLSsewOvsFXjy+ZG35bhus+MOB0ol5YX9lcA+Y+BsqadefdraM7t+ybagaF6zMrPASTQc0V3OHD7v3B/c12cI+QSd8mrUAaQLvZjSTX368adgP8FlHQE60cED9NbLi2ot7hpROGbYbRPkpBXIv5fES57b5Y8sug5liv/rroqsMWBWRPvldwDA5tbqI4KSOmVolLaZEsFiQ62usXGoAHKLJI50tI5vvkoEuvuYfWaUKcl8HC6VDuL72mkVDCF1w0wDz9L5lIdaibm1qX2AsOq7IpmN5WmFXsi5fh43RqOxPHslZ2J9l2EUo74AS4E74168vGkhSar+4h2JbLGiPQJ/Etj3QEAD0Ff5NYMKpcQacTbpB4IPDtAFetZ7Iteu3NQK4SEZPkJu9Q/ar3KKh0xDhLlccWoodMQ6oH8ygtrkd9f4WSR8/IDboS+5VtwN0gtO7hLB5TLX1XNAZUoncq/DaEpiUAKOz3kxJC6vxeHPg14RCmcDPR0kKhKwZXFpqogM0kw329jSUa5nbnAg2ESYoafK0ntKbgZJ7is=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b61f32a3-5d9c-4bd0-3a7c-08de5d8f4e8a
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2026 10:32:01.5235
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e71Ff31nJjNPhbBCmOqD6W8v/VHsDOVXkGQmJW6M7ZONDFtYKJFqg5/hl7sNb/jBcuzEJYHY5kzS+M6taVMWUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4636
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-27_02,2026-01-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 mlxlogscore=740
 adultscore=0 malwarescore=0 spamscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601270085
X-Authority-Analysis: v=2.4 cv=dY2NHHXe c=1 sm=1 tr=0 ts=69789427 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=bdwf2aSjWkdzs9MUh0IA:9
X-Proofpoint-GUID: 7skbTu9DLrPaS5_3-wkf0IWZ82hv1Fje
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI3MDA4NiBTYWx0ZWRfX0nSQIYUa45gA
 nZuAMj5b0NUuMXEaO+BlJaJiaLlmoUnndnGdtfTWWU3d702uFhIW5b62XHEwgmw2ArMqNikZpO9
 eQERTPv/NwUF2gLUFm8u1tFt44mAGaRRKG0KSu0vpB6ehe2ESgPXJHmH8xSmByykoM87KZchcOh
 2uCAkdlL8yQ3KOREaLkPT8zZBslmtJy8brYeoadXbj1qpC8RhG4lVa00u0ja7qDy77VOpB9sEHb
 ePg6bBP3aiHKL7V2U3AHdJC6eN3aHADWwLUZyjwtqPxmb03QwvZvWRNLHDxtrDGsoADfnpxQBgT
 bLNmRkZWNWrUaJ9nrxPz838itHRJYhX/aMVQowTJSBYOX3wJs7GrZM0VZiffeFpOACH65gpOfyX
 zK/9jiVwXw0En3+2rIBF0/MqqCP2+6BfSBcaUKs9ujdnj5BRfFELEXb1LzvNDeGQaslEE7v66S6
 IFa0z2L8t0xuwVom14w==
X-Proofpoint-ORIG-GUID: 7skbTu9DLrPaS5_3-wkf0IWZ82hv1Fje
X-Rspamd-Queue-Id: 1ECF4C0005
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: pj35m86odw8mxpwgiajz3asaku8or74m
X-HE-Tag: 1769509934-269376
X-HE-Meta: U2FsdGVkX18B8XSrx3tWYQ37UvihQNUegr/o6RgaylVeG7EgesZYJBAAWRTKKY4cHoyj/1YhXHF+8xUsEFfBhi1qACYfjarZjF+LE5ZiOpyqrVDr96KO5IwreO/fdG7uvp5p3fNNd5ULte3GubV7NO1QML1vafyoDSFMfM9LaxGQRc6D1zoEvOq2VDY0vcEJ5ImNAcBC6dOnKkA8sM1pJlSXJ2eFDKrmW4XuJTD9/hTQDyj7F56vaEqoKNWgka0GB2d/JXndAaGG4oBiv/+ev+1/PiKrihc6i66l9/SAPINY9dlEiFL3esYLyC02pabTJUgyOC2UQitFtYTvcxUnGjHTQ1luF7yU0XT+qDDFiSZPG1eoKAUmlKT5tbzfLWmqTTah2XMMJpSW+rx0UpO8V7v46ca/OcGLC2evKFfgTdBKDhmF+PBShGBqARgf5+1mWhUOExnryk60Uq/sVKOl4XCkApXlItg45IQq39tPWb9seU5WjKwjiganmBX4nJzKBBx4Xczx+o5ll4sVbo+wPd28j7yrAyq2Sv1p44nsk8Zfv3cXp4keEfJlRDplhwpd2qssc921gLu1myP6w619NNXlSIC1UPGeZxqJIWCIbKZ8d+d3JX5s+yPF5LpQOPyEYiCyasfe1ZjHXKJgzkgnc66CcF4sOOEZVPbgk+TDZj3ZLxnXWFH1clZmHmaTuxoRD/OIUxONL/yh+vvW/GErGsuTlmeEsceY0wcPLjLG2iqvVQVIhL8H/3Ty1IewsBzcOePExkKYJy6O+91044uFfIGdz9/PMxhLvKvE+1EFpqldRKcy1rkbmFKgcaR9y25HbNyJdB8rFxDLeyHfBU8Ns6Vah9zXVYniT7HDu756vkHmtVqmBTTqaFUZriwich0QH0TdWqqc9yTHa+yuZbQNnr6XuhCKj2KLaJUGANFiTlaeTPk0LW1M1C1142r7r/TBPx5cdn62RK1GbNXBhZw
 byTZ8S1v
 mqEpkt0sdkEV6QxONjczDNfA2B7nZmyB4J6GkHbmWViB8YBdEeTyWFlDTmotVspofut7N8B6/oGlajwzmukMlyQK7Wl/EwZ4arhIqmx1Huh1t6i/oGCUIfuc354Cb3ZghGf5Z
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

While SLAB_OBJ_EXT_IN_OBJ allows to reduce memory overhead to account
slab objects, it prevents slab merging because merging can change
the metadata layout.

As pointed out Vlastimil Babka, disabling merging solely for this memory
optimization may not be a net win, because disabling slab merging tends
to increase overall memory usage.

So let's take a conservative approach and restrict SLAB_OBJ_EXT_IN_OBJ
to caches that are already unmergeable for other reasons.

Ideally this should be part of the slab/for-7.0/obj_metadata branch,
but due to a conflict with slab/for-7.0/sheaves, I based it on
slab/for-next (be36abd97e52).

Patch 1 factors out mergeability logic to slab_args_unmergeable().
This is used to determine mergeability before the cache is created.

Patch 2 uses the new function to allow SLAB_OBJ_EXT_IN_OBJ
only when merging is not allowed for other reasons.

Harry Yoo (2):
  mm/slab: factor out slab_args_unmergeable()
  mm/slab: only allow SLAB_OBJ_EXT_IN_OBJ for unmergeable caches

 mm/slab.h        |  1 +
 mm/slab_common.c | 27 +++++++++++++++++----------
 mm/slub.c        |  3 ++-
 3 files changed, 20 insertions(+), 11 deletions(-)

-- 
2.43.0


