Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF397E6BF39
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 21:00:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4F206B0098; Fri, 30 Jan 2026 16:00:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F2FA6B0096; Fri, 30 Jan 2026 16:00:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 761FF6B0096; Fri, 30 Jan 2026 16:00:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 54DFA6B0096
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 16:00:33 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E2E0E14072D
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 21:00:32 +0000 (UTC)
X-FDA: 84389848704.28.6B469AA
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf15.hostedemail.com (Postfix) with ESMTP id 39A8CA000A
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 21:00:29 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=giFrih5G;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=KmZSQ0hz;
	spf=pass (imf15.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769806829;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6BRZ85az23keMYfKCiwlz8J93jy7Cdd8clS28lbAo54=;
	b=0fNfBsa8m/8aEXeJ5ewEru5cPhfkM9JroAfwMnE0F2+ekW2GWaWWuWqWzVWz8e4SoYD/an
	NWLZHGe6evZVQBM76X7XXCubMVqvV1VIKrHRlGai/NptBKtOLGSZ+vZ4whfpaQRKwxUgbd
	dbUWza0DzeIAAEPkcLUWR9MAeH+k1JE=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=giFrih5G;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=KmZSQ0hz;
	spf=pass (imf15.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769806829; a=rsa-sha256;
	cv=pass;
	b=O33hS/1wcZm6vLAdAwo4BfmIX5Z/Z0WkwMwaQ9l33s4PRvW4mX+raBZBrnK/jAYznVVDOa
	lUWtDPcsGPG5GErHF/R4qlA3U57d0fWajowzUBy2Iq/dESC80H4XD5++8uM1pG+/AM6OOR
	9ZLS2gkTXZJi5lReSsEVgDfvBJraccs=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60UKDIDL4028214;
	Fri, 30 Jan 2026 21:00:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=6BRZ85az23keMYfKCiwlz8J93jy7Cdd8clS28lbAo54=; b=
	giFrih5GM1ZknX+PW/5IwWv6HNoDCOIkZFbQ2be7pndSaRxtUqyynilDcre5/7TA
	SuzaWQiB1NPNS4eOK9KhiVfuXrVMbetyzAkZ2YaQ+1l11N4xN5bM49GuBGWgTQaz
	nJO9+RjaQPBPwn2Bp7QNRXlwl2cZGTjJtBYKbjD+RPPZi/xctzXgXMNP3qUnwFss
	Mpgg1D4Iy+bBRNKkATgp70ZK/uh/vHooooPqzbHqfuRrXsa1g8DtlkTkU6yT5iUu
	fJiRq01UQ4QypgSLcp6kupCMCS4lr6rhwiUNi4VVxYLtcziL/krJmrsuQMRxo+8e
	ZJN5zv+l+QNVzTTiKZWeLQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c10668cfj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Jan 2026 21:00:20 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60UJKVtf036073;
	Fri, 30 Jan 2026 21:00:19 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012061.outbound.protection.outlook.com [52.101.48.61])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmhtex0q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Jan 2026 21:00:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KHMnnkhZZMapZJAoKLOXOqf85UFAByzlBNTpvHRN+nr2mFO3RvhFglE/4Udt2qqfnS0nA3AeVoaPZTXlzo1VFDnJwWnD2WQK7fKKHJI/mVK6tYsgfkChzmwgar7TXgViIbPHhbrOgGOdr3lCDm+yxMgi4Q0O22cL8oqNUChj5MqmmRvOA+kVsWDPS7YaSSGh2Gh6xxireyWqQ8LVQF81taNgOiepUQ4daZTmypsNfNyn4ac5GybcGgFQaAVoQoBLdGRFNyL6Ho/rYspg1cde24MI//5gsZSnOMIpdSgASDgRvPYeUCry2pCkQ5AvbJwYtDpNQGndmzvEQdUAfh4tOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6BRZ85az23keMYfKCiwlz8J93jy7Cdd8clS28lbAo54=;
 b=M2b04N/uI4kNjxLRs0GfQc0Gz8z7OmQBTRQDm55ltUppN65ntl6VlReENwL3aZS+AUkZKtniIB990MCdMmlIzCoxWgE3TxbG2KID7Aga55Pu0Wm1OW915jfXqHDoz3+2ndXnUq1+WqaZsG69jPaxUSas281MrPOozEyp0ilYu84MGTIzdy+oly8k3ve5Lzaq7/qg+2mz4lXcaKnLdsTRdVjjEHg0F+H6yy+AsCbhvq6r7t4hUzCYoYqNylLZVN4Vrn+ToKkhoY3nk5ZHw4Vb2T9buNByfwk1I+FaQDgpgkHaZ4rVQ1pbJmAcSM/1/sii02vQmrY0pB1KssbvvpLmzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6BRZ85az23keMYfKCiwlz8J93jy7Cdd8clS28lbAo54=;
 b=KmZSQ0hzxdmCmayaU8uHo0hyaMj+7UuZQVAiUFCAej6mYIG+D/rQo22fKNYEVXv5bf4bK5bk2eJhn7m/t/NabCi0gHA7IrTiCDhRbwsaD5p3fBVZLNwRbK1uIf2084Lz9fAPZaO7wB9mN+woLKSDQyQkqE0BSqA9dGOC8bzGbQI=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by CY5PR10MB5961.namprd10.prod.outlook.com (2603:10b6:930:2e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.11; Fri, 30 Jan
 2026 21:00:15 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9564.007; Fri, 30 Jan 2026
 21:00:15 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Sidhartha Kumar <sidhartha.kumar@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Alice Ryhl <aliceryhl@google.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Arnd Bergmann <arnd@arndb.de>, Christian Kujau <lists@nerdbynature.de>,
        SeongJae Park <sj@kernel.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH v3 09/30] maple_tree: Move maple_subtree_state from mas_wr_spanning_store to mas_wr_spanning_rebalance
Date: Fri, 30 Jan 2026 15:59:14 -0500
Message-ID: <20260130205935.2559335-10-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260130205935.2559335-1-Liam.Howlett@oracle.com>
References: <20260130205935.2559335-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4P288CA0043.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d3::29) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|CY5PR10MB5961:EE_
X-MS-Office365-Filtering-Correlation-Id: ca7b8613-196b-4674-019b-08de60429100
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1PBXInFx00qUO7Ri+xQcWZ02OwluJjkhpi+Pk8xdTXcTcO91x9e5vxAk8ebt?=
 =?us-ascii?Q?zGrnBTx1n0hiBFn79ioVMbMKffcgYP+hgfFtdajSIKWMvthaPcfLVaJFfH+m?=
 =?us-ascii?Q?NZyl4c6YspkXjyrdK4d1oebZMDsHgvPav+CksaPdSatmjQNTmt6BdCwojk0R?=
 =?us-ascii?Q?ZAxieAdFWmyvTcSg6teRT2815I2EcC/kTK6uL3219UO6kmXHw/JQrO0dO4Yf?=
 =?us-ascii?Q?oLr9hIlOJOPYE1IPMjVG42aBddSB/JLg3JqI8yE3pe2KEkcp6h/r/J5nur4a?=
 =?us-ascii?Q?hOgPx+6ouqLQy3xNXA66XScbw1RRKVb3mjaJ9z8iifFgM5u2KaUZG2rwxZl6?=
 =?us-ascii?Q?ozXI6aje00H0jEc91c/sZJMLbar8laSySx0KUk4aM9HaWT6SVVnH5DvsjEYo?=
 =?us-ascii?Q?WLnNgLH6eMMfkQX/CPcxS2/QehtrF8kkPP4X2BgQHHh5Zj1pzrMlyC4b1VOr?=
 =?us-ascii?Q?ttWSfLzTC6l9r0a3eo2Zu+hD8wFcXw02eq5g0i6ezduXPGzItm/VAJh8KSTx?=
 =?us-ascii?Q?a5IcO2ogbPM5+4RRJ3bg9rChcriDAv914yqShMdy7K+FI3uLJvrLo5KwDxPW?=
 =?us-ascii?Q?LKN9xYoXdB2V1fEy+NN1G+k+Ote9mCvwmD5aUokvSDT7ny4AsuK3XqYivg5C?=
 =?us-ascii?Q?JqXLVyU8PyVfNgbQ8ZTQkaffQ0GwHIsTFE8pvbFQESGm3dxxogGt+0vEV+Tw?=
 =?us-ascii?Q?grIaEzgFk1Wo0BWW6Mo+wNBJmiXFOIfUaBeZbzAWJBhxnvViow1NRGm3tgrU?=
 =?us-ascii?Q?DfnkY67gHbx6f6kpknJids6+d7HCWtm6qfKnE4FY/M/EoZl8TJzkhVOgCIoZ?=
 =?us-ascii?Q?+PZ3wV0DyRosIgUPgEBNr4ToD+o/B+2ujCrSMlx7NvvXabzETVlXPUHsyXnS?=
 =?us-ascii?Q?iL+wum3SRhqR1i1VGvF2v+xGel3TYxkfOU514StXLammuMwatYsHZG0oD4kv?=
 =?us-ascii?Q?yzkF1Jtd75nWi1/1ht1cTno0tAB8yf5/VN8Hl2do1y4cyw4iuaY4dWWArUHG?=
 =?us-ascii?Q?6g8WLY7ltV9dOthj0523hZZ4o/GJQxpS4nshA5iwbs0oweBZqDiDhzRlujTe?=
 =?us-ascii?Q?wYjKQ7dy9wqztdh+2ezWZxgmg0YkUP5iTFoSyvmjCYN+1M0HL1UcdNaS8b4b?=
 =?us-ascii?Q?FKzYBhTHaCkkn/neS3bfxWxRciyuFeCOLvMNQtryLj8jY7xXihxNkSc4zzOk?=
 =?us-ascii?Q?UJDf+v6sAWsvlLi0ONKVU5PBn8H10Io3L0utmmvGvGwy7hHjWo3mKD6EjV64?=
 =?us-ascii?Q?QGpjcaJ060iXLFR86pw1zn4jXY0G8b5Z0mmZGre8hTFSwxXJ/R0tzvv9mQ4T?=
 =?us-ascii?Q?sLhNdHFBgUkkBnLwYHT7VOJGEgzIq1q6Q5Ewp8auvb0tjoTIF0/seY09y13J?=
 =?us-ascii?Q?VjgVXeIkduivyNz2JOZzBgeHTJMBmPdFmXVxnMTCq1j4HfVm4SbS+HfPM32J?=
 =?us-ascii?Q?d6YE81mmxvKLnEDw2eSkBS87UIKhvLqFhrRs4bUUC+6x0OhYoBCrFb6s6lZV?=
 =?us-ascii?Q?j2usf/lfGYBX1Xls45YTe19kRa2X9emeKkqQQkt2NuAf9Do9hRBD6Ieu9yAl?=
 =?us-ascii?Q?+D0Y2BkxhlaNbmO2VB8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4Qye8rfQ31JTosa27X4irEl3qOb0/Yci3jULFvd9UCzxL0iS3v8I4NxJ0j9W?=
 =?us-ascii?Q?2RxAWfq3nX7lo+f+AILku1BPXAheGGRDAWoQPSYP+J5e7rq/quycUFTtjmkD?=
 =?us-ascii?Q?CXjOFLFdwBR4QBMZYUV5lzmlyyaklKwGJNmi5FHyjP9YH4txCBwOzEesr55v?=
 =?us-ascii?Q?omhlkdcUBmpAv8TXzuyK/a4QyeXx3DPAEbkKY8k7+EbT6ZbnN4vK9SB0KbgK?=
 =?us-ascii?Q?aQ6llZ5w8vW1wKJK8Z5dQT9OD03KOosuptKfbUt1D0wTeldx8zmuECkAV+UL?=
 =?us-ascii?Q?2n6rr31rSB+Q5lgcwa86d35R0aiztVt9ktZtRKF5IJkl4SCtLJwoz/8OIFxF?=
 =?us-ascii?Q?y7+l1JMnMDngXp3ORmPiM1QI5m4UUhQ97hj2yuV0gzoGyH9nzPHldv5EWVyZ?=
 =?us-ascii?Q?dyePLY5yd1epvooqpMi4peCPj6KbyRSl9CjwurbGHUBrgsanOdGCUTvxASrl?=
 =?us-ascii?Q?6EWaWQJ9cxq4ArYI2KbdysS09iAol+j9zpJzPDn1+O+rd9ETkxh4EeNKe7CO?=
 =?us-ascii?Q?8DHtM7C9wepmVQy26Y2XJcu8jiUqEEw+BvT5je+BJ832N9kG2ud4uCx3L+eh?=
 =?us-ascii?Q?ykQ7ObhSc5V3mrhUeKuG5sFawq54NQriiGII9TEHSOk0xSrWOAaCzM1ai1op?=
 =?us-ascii?Q?snF8mTITNqCiIFlFYzIzIezez6LRbjBZptly5qYPGQgUzqeYbBn6PS/bsZnY?=
 =?us-ascii?Q?LrycsGSiyuEkk2MIKBny0Ix1kWJa/IYiDnmjowc2sfUWxpVnnqPBtkQJ7WS9?=
 =?us-ascii?Q?9VWN/x3CJWNtR4O11L8CNqBLbZecDH9Ns37IBME5TbsLtjrQgMAnv/bpPDtC?=
 =?us-ascii?Q?P2NOEP2/k4gLBWe1QwykVYFjnV0Ro99SG9ucbTsJJ2E+Os7EYP0YMeAkBr6v?=
 =?us-ascii?Q?MtdccK9GNmxe8hyJQmduQZGM+KuqpGmApa15JqkDpvlFR+AyhYxFpGwxhBIr?=
 =?us-ascii?Q?0x8TQJqwD5oKWxj+joClGt7McPhgwNhM7MwXgNvmLkH5f4FPVBPoi8zQ3pyb?=
 =?us-ascii?Q?kz1zUcfA52Vl9euOEvi0JMfxPIUnNXSFGID8Gafv5t3QHVd7msFp0XAybrWs?=
 =?us-ascii?Q?kBq/uqmxUOrwSVWuH2GZr7Z4ISzMm99wtolI0vgddo8oDKhuQn9ze+KdKGgp?=
 =?us-ascii?Q?AA6UWVefjyIcrAPYlHZgzVXrvqAypqrf+tRAWbpl5KUm92FecPATIjUFpfKf?=
 =?us-ascii?Q?0CxKoN/qlnXwLQ5L1QvF/CrPI5f34ReryypC3YtBbnwbV5K9SPHzvfDzdHOM?=
 =?us-ascii?Q?OCxz63lyHwshImhiUBrRxljFZqHk6OLfmytXQzMGMsas6BCnv0Ri17xfSi/B?=
 =?us-ascii?Q?gxqlJBZ496oZZ+PuFlUWdn5jV7sntWJ3AuGuGrV89O0O6r5fK2vLmjid7QS4?=
 =?us-ascii?Q?aovtFZ9lKNPypUoE22FeFm7YNAXGjwOAUcT+auk1EW+6phsfxohqmmVqiJpf?=
 =?us-ascii?Q?TFfAHSYCa+mG46JNlsZ6pEcCFipfeG8vjBpN+2aFpHiinedlP6pPaKJ+x4HW?=
 =?us-ascii?Q?W+f/PtEoUZ2fFasG5yvvcXE52sBuI1uloOKeR9XRNtiPbR9839lSxmhGFGdA?=
 =?us-ascii?Q?jjkeaAXk2NU4SIIXLYKZUrOWl9aVylUlQv8u3bd+chim1wwFJpqXGwE3puES?=
 =?us-ascii?Q?R7/L/3OsfLu/XzHImN1UK5FkEJ2iTam88fG2DH7zO5vBhD+PoDlfoDwErekx?=
 =?us-ascii?Q?Tu+onN0Ai8chPJnArrGyW0ZIHFKZ/jva8kbS7oCqGMqhLD6jWxPoySb+Ucg2?=
 =?us-ascii?Q?bZDN/iuhUA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	SnzMdIlT/y+ZCoAuAK7eGXruOiHX4oHslzOifd6Licn9aivfD/RFaq2e1l/mBRYVcLyDFgr2duGrTlku1k6QU45dCAmc+pN+Lc8CNYZ6RNs+zo2QbmXKLsa7opeLiekhr5zBMrTdL+uj0Tat+36imI8j3aYmbIR50qDqntOv3gVy25shUgsV1NsSWTjdoJoCrLkUVbATPs8MANTOxfMj0htFIGR0m13smdFmlYwZI78woMhr9PmBwBe/bqv/48rCXGbzX4E3luQuKPUM/5YXL/0HSl4hUtAhblJcNanMefU46SagkSW+z1BznNClo4u9kfeyOYiYl8efGWixVFMuUtjVPhFWuUfTlEnNZdj3ltWI0tBqCGfxLzLzyh2j6nMT3gpNRX4DFx9Ocn9HMfMTasOQbsm0lTTVdfpoKUtzlfyn3lByV3sj5fNNJNzzoO4GzMwEceIe5991OeqX80w1+6ppSvtRGp+Wo3Qj4W7qK22WwvyNjeUKA2MrqrIWKZQtym+NQz3kULu3n1K8Z7CqyGxDSAVb5UxlC2SlFsNPMQLwoHDDb/EgCf6ClGVyeAf3BNvSgRkYlxGUFi/YVGJaRGVIbMEGCnCknHJfoN6fDO4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca7b8613-196b-4674-019b-08de60429100
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2026 21:00:15.1119
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1/Id0IS3Zz0Eiy/GyIZCVOrDx+WANfh2cmbdK859azYhtg4EyjbbUOtDnDxyiaJ8CPqtwsFIqiNqlJG1e1W2Bg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB5961
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-30_03,2026-01-30_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 mlxscore=0 mlxlogscore=999 phishscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601300172
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTMwMDE3MiBTYWx0ZWRfX6IXKlnLofOUx
 RQB9z7P4LaE2ILi7KxVezwNpQwW9CM2NfUtFnTJTUgfzNBV95Kxvz0pWe6y4pjNXiOYeMejmmLT
 37pBEBRRbTasnSqlASrFEGvUh2AxvxMBTs1+DAadJpS7OxXA5yjvUBj3RttbZX/YFbmBzS63rGk
 01qylZmT7fF3hNr5IMAyTygu480GJRtCaR8nuOE3xDD+t/4Q/btOLaMXI+F4U+BXDkXpwnhahPA
 f3SmCqVUuSE6Rm2JGdJ4xBzBFbDilRxqbS9Jh0Q/sfFpUTXQz9drbSBoxFTjG1bYhYJTEx2Sd9O
 PcNnXh5Y/M7bqtsK+gIreiBCLuwSNlOP0MzpAzJLgbhJF2NIF16T3WkBso5k4fGAFFW/mn2xPFr
 88VHYRo0t3gD2gBgBDhTEKfVOYI05zpvfwkjJWS99uwvGhItRuasDN7oXRbwJlMMyHvRSdCAnLe
 jNJTvIhqDrWJ/PdPmH45gKaYujqAPgrbA3ExOduI=
X-Proofpoint-ORIG-GUID: 5n3gDZPNEuoDLBV-qFSQUCF80Yq8BNSt
X-Authority-Analysis: v=2.4 cv=EebFgfmC c=1 sm=1 tr=0 ts=697d1be4 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=CYoulDwovmb3McnCtv4A:9 cc=ntf awl=host:12104
X-Proofpoint-GUID: 5n3gDZPNEuoDLBV-qFSQUCF80Yq8BNSt
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 39A8CA000A
X-Stat-Signature: 1dxrddskwizd5e7wdumuxh7zca8f7aok
X-Rspam-User: 
X-HE-Tag: 1769806829-594873
X-HE-Meta: U2FsdGVkX1+g1xzTkRlHwKv6/D7zH6gek2CbeY2CGAcnaSHoztg5EQgf55Cve9ccl82JylNQWrhno4UK2sbi3dOFtG7xK4Iyi0zgYt7L98o6qbqs2W1OTCYfh8pqsx30dX+QmRjEyBBKrvbbwqgTlZYQfi5NdkOuupdD57WOH64LhY46efx3S4W4ZXVuf5JLqloXd+hfgpEcwtAfBIQIpulLSNzhyl4mFbdu+g/YYJ0WbCIFDwvey4yAFjbmINI+n5J0LjJjH2D+Dd/+ElZDceYeZ1+0cO49eRrzk7tDPX5uqA1YgyEr+GrPkFfwwwpCWfn3N7muxgUTQsngls8ZAaIowB4a31vjTFroZqcWRu/ZArnyoGHmp5mVzfXDSCl1rK/MICrG99WcONPu9QQUebQwbzh4qwb95saAgNn23rDpGv7ZhBnUTLbplaEgz2OrlJx7qOIw5g8lQeQItgKk2UXThGZbFfbpHXfP4+MdbCqh6u8UMTSJynIofWQF2qbjGyoOaykQja9HCiIJ7dNzdSX/T7H9KD8bsJP/qXk3zOokP1emywdOII3PKcbL9m7H0bErV5/DNwijZ+gE1NKYRwpgT3aTUZeJ2X3D1BLJQAaezC7Z3+yQ8ejO92UpEuSn7nDWJw/wRJqJxFmoG2O426qS4plLxgECw51aREJL4+zbhAyQZ/Fb635qOIvWWZ0RGZMYCfilA1rmkDYoIAHdNjnJUKvzGHFi10gcKnijt/l+5ckx20MtHoHJXHo3JBD9ceCinAcnp+eytlF4LjzLX4L8Fl234AdzDnKXFxlRo6B8Kll5FgiC7cWLe3YpIXihh9I1VRQj3dKuQeniVepxge2TpRB4Oale4eIBHzjTxcZv+r51Te2hNK7F6lyK0BiTIXgUlJI4YV2JDTdfuKPJLkDfgbVmgPhGEP5QqseMZgO56PIJoduiOS3CdQ7GxzJCbFbPfWcxvE1r71Ufdla
 vPyuFV/1
 uoa2DQi5fjWYotnd4k2psZM4L26XtcWYxc58hW9IOi+YRW30+V0UscePrWLPVm5F852hcyGzpXT0E5bjnjlaWQJ75HWFYUnYzuLtHBrtOmkeAbiEhiPBfjB4Ow4DnaAFKl7JpEFtJ50mUpPM3pPmPMkN4tnTFd34/BvYQKPtvrEO1aepqD3xR3T6jvE3o55mMKmuLgc2Yyo8SiJADICtFDMKHYH3bTW8ulNEzz5TuFh2OBU9f7+WSCAnf/9aTd0kQoSkB/PSz8DKuMrgyarMHWLHJ7zf5I4+wUoIGdezPIhqRshkatMqJskvFcGH6cEWTiVB4CbUcUYbBo3VUXYCOUExN01ktqO6UXcfmeH2BrPhTQGidbFQk+dyiCcCMx3zwWU9etenj2AZFVJvo60FfhGWIu8guFMIo5MpnV9y+fefIEudqO+qUMNFdmsh4JvjbwbVx4O3ckolctz41qgo/y39focnfpNhR02v6UWLVoUNv2N19FbE91wuARZMVIytIuVn8/EVGNG2fKRmSVV/Yk91kOu9ZISwgwxC+WHPMFEYmmEqa36HwEciKgWLLXKBDBR1yJc1phk6LrnCZuvAIOx28amAjm+RByDHLjXBpUUt6WatJCxya5kpuGdjm8OpCigYWd+3HZeBkhK6ERJA0qc7jrwYI+0vuE8Z1lO0rhT16XatJvM6+5qmKarALELTFxcjm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Moving the maple_subtree_state is necessary for future cleanups and is
only set up in mas_wr_spanning_rebalance() but never used.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c | 41 +++++++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 20 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 91d3fb7ac39c5..c5bb341da5e9d 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -2750,46 +2750,52 @@ static void mas_spanning_rebalance(struct ma_state *mas,
 
 
 static noinline void mas_wr_spanning_rebalance(struct ma_state *mas,
-		struct maple_subtree_state *mast, struct ma_wr_state *wr_mas)
+		struct ma_wr_state *wr_mas, struct ma_wr_state *r_wr_mas)
 {
+	struct maple_subtree_state mast;
 	struct maple_big_node b_node;
 	unsigned char height;
 	MA_STATE(l_mas, mas->tree, mas->index, mas->index);
 	MA_STATE(r_mas, mas->tree, mas->index, mas->last);
 	MA_STATE(m_mas, mas->tree, mas->index, mas->index);
+	MA_STATE(mast_l_mas, NULL, 0, 0);
+
 
+	mast_l_mas = *mas;
+	mast.orig_l = &mast_l_mas;
+	mast.orig_r = r_wr_mas->mas;
 	memset(&b_node, 0, sizeof(struct maple_big_node));
 	/* Copy l_mas and store the value in b_node. */
-	mas_store_b_node(wr_mas, &b_node, mast->orig_l->end);
+	mas_store_b_node(wr_mas, &b_node, mast.orig_l->end);
 	/* Copy r_mas into b_node if there is anything to copy. */
-	if (mast->orig_r->max > mast->orig_r->last)
-		mas_mab_cp(mast->orig_r, mast->orig_r->offset,
-			   mast->orig_r->end, &b_node, b_node.b_end + 1);
+	if (mast.orig_r->max > mast.orig_r->last)
+		mas_mab_cp(mast.orig_r, mast.orig_r->offset,
+			   mast.orig_r->end, &b_node, b_node.b_end + 1);
 	else
 		b_node.b_end++;
 
 	/* Stop spanning searches by searching for just index. */
-	mast->orig_l->last = mas->index;
+	mast.orig_l->last = mas->index;
 
-	mast->bn = &b_node;
+	mast.bn = &b_node;
 	/* Combine l_mas and r_mas and split them up evenly again. */
 
 	/*
 	 * The tree needs to be rebalanced and leaves need to be kept at the same level.
 	 * Rebalancing is done by use of the ``struct maple_topiary``.
 	 */
-	mast->l = &l_mas;
-	mast->m = &m_mas;
-	mast->r = &r_mas;
+	mast.l = &l_mas;
+	mast.m = &m_mas;
+	mast.r = &r_mas;
 	l_mas.status = r_mas.status = m_mas.status = ma_none;
 
 	/* Check if this is not root and has sufficient data.  */
-	if (((mast->orig_l->min != 0) || (mast->orig_r->max != ULONG_MAX)) &&
-	    unlikely(mast->bn->b_end <= mt_min_slots[mast->bn->type]))
-		mast_spanning_rebalance(mast);
+	if (((mast.orig_l->min != 0) || (mast.orig_r->max != ULONG_MAX)) &&
+	    unlikely(mast.bn->b_end <= mt_min_slots[mast.bn->type]))
+		mast_spanning_rebalance(&mast);
 
 	height = mas_mt_height(mas) + 1;
-	mas_spanning_rebalance_loop(mas, mast, height);
+	mas_spanning_rebalance_loop(mas, &mast, height);
 }
 /*
  * mas_rebalance() - Rebalance a given node.
@@ -3447,11 +3453,9 @@ static inline void mas_new_root(struct ma_state *mas, void *entry)
  */
 static void mas_wr_spanning_store(struct ma_wr_state *wr_mas)
 {
-	struct maple_subtree_state mast;
 	struct ma_state *mas;
 
 	/* Left and Right side of spanning store */
-	MA_STATE(l_mas, NULL, 0, 0);
 	MA_STATE(r_mas, NULL, 0, 0);
 	MA_WR_STATE(r_wr_mas, &r_mas, wr_mas->entry);
 
@@ -3505,10 +3509,7 @@ static void mas_wr_spanning_store(struct ma_wr_state *wr_mas)
 		return mas_new_root(mas, wr_mas->entry);
 	}
 
-	l_mas = *mas;
-	mast.orig_l = &l_mas;
-	mast.orig_r = &r_mas;
-	mas_wr_spanning_rebalance(mas, &mast, wr_mas);
+	mas_wr_spanning_rebalance(mas, wr_mas, &r_wr_mas);
 }
 
 /*
-- 
2.47.3


