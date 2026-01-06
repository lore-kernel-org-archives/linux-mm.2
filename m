Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9865ECEFCF0
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 18:56:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C0F96B0088; Tue,  6 Jan 2026 13:56:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08AEB6B008A; Tue,  6 Jan 2026 13:56:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EABEB6B0092; Tue,  6 Jan 2026 13:56:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D95D56B0088
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 13:56:30 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 80A80BB8AA
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 18:56:30 +0000 (UTC)
X-FDA: 84302444940.14.A6D8317
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4A3FA100005
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 18:56:27 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=fSd2QTkL;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=uWEX8Id4;
	spf=pass (imf05.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767725787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cAlNlSOa8GaocSFuJqMleK7komwDNxkl5ftxCW7OHx0=;
	b=EOJC/agJ81x/mgJQq2NRrB+AhezR6yfq4QFEx4ISwMRRxDhwrFzhG197NVjFYXWDhXg2Zp
	O4uTum4fY3cLEjUm7lElWAupyjK87cxxsHBPJ2zJrlwjGJeSL0UBP3xvGg9cKpF1L/NoAJ
	W0tUKAihrGvt8N9HGGogzrpV8uR9S4E=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=fSd2QTkL;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=uWEX8Id4;
	spf=pass (imf05.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767725787; a=rsa-sha256;
	cv=pass;
	b=SqQCnoic+b8yPY+e7JSCN5RORGtuBSFa7rIucGOnqnrgDzcGPheyjR7Bmqgsm4lhRaTm1D
	dS1Jt7uGS2etbEz73WDIF0LOMg1cK3HQE8Ngx+mwsJdlS7dEVmCiFmMSq3UoS3Bt/kmLbH
	GLrQb3tKXphAKoIG6LmaJC7AxSPzUKU=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 606HtrAu137770;
	Tue, 6 Jan 2026 18:56:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=cAlNlSOa8GaocSFuJq
	MleK7komwDNxkl5ftxCW7OHx0=; b=fSd2QTkLmTtj14eLu37Ocdgr6BXfISlK1s
	lCr4qz7TeEOYcZt2USGT+o3cWhiVdm8B91225h4GON535YPnRxlckr4zAL7Jbz+p
	kd2Sgiu2CNPZSgdtlZ4uDyWfv0gBu0GIoWLLBmSM4Oz3LsVM2hkRRPRawDDcfh+u
	IH3HPViMqvmgXdg4SJ7NkGUXEEa8Qbcw2DlMxTRn0tpoiLiqTVjyUuAzERn22bdh
	+FviU9VsiC8FQL96UC1ix2G53d/J5fdCnE74cnbQ/vX6uBy+ZtK4L9zxQTm8k0lL
	YRNB7vBg1SgTz5dlshQpWL67cJ8TAJQyyj2Q2tqnjJG5P+AXU5xw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bh77qr38y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Jan 2026 18:56:22 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 606IJ4hW015397;
	Tue, 6 Jan 2026 18:56:21 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012003.outbound.protection.outlook.com [40.107.200.3])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4besj8pyfq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Jan 2026 18:56:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G/uGMQGUd/Uob+Uv9Z/w5a+New7qG9/TjnjCcJhjAV+U27E8wXM59ajfi6LSFUY6osTq+SplaDuBd6TNHgvtZNN20ZuWCDmPOV4X0U2B0DGIMnA//nLm3gVLy+Qwxkf9Qh4b1G0jKcYnHBDKjsbkX4XEAkvElteedD3Ga6rXojJNVPzqW1cP6PQHKKmgT/SvWRx0zkwai4g+/OjOeUSvks03LsDytOKJrvLrpXKxqwZidim0ymVy8GpH/oeyQWhY84T7NfjUrlejvdyohnRiof+UrKKxAuBHYyJzU+YtkCwXAGFXIh8mJ5l3TB0tNCjNJgA3BfWf/w8n03riqk0sTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cAlNlSOa8GaocSFuJqMleK7komwDNxkl5ftxCW7OHx0=;
 b=QXbNbpFO/wigvY0BRA8vRDAt4Z7zKPSaldPYIpiQCxrEts4bfWhdE//kU2v1m4LhMSoF57/yeIAMOqaSc+ilkAxynvyUd/KXYcu+ZbVtOUzqn8Vk3YoCkGqQghQt0MdCERPdVOQPN2OjuFE16phF7IZwFl7nkHKho/ccTTdxTj/UFCuXl90eacBlabD9UheS7sp8v8N1+RwlkSYnBnLYGf9rkJgtBhO/7GVzZ5W5xa9OUSdd1v10+nkXajZMsb+bpVzbiuFlkhRl+T6ccgVevDC1CbbBdTXy9TDFYCw+pPjA99KRKuMfYjeGf9042YzcsSOrnno4eMEu1WmzODKLAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cAlNlSOa8GaocSFuJqMleK7komwDNxkl5ftxCW7OHx0=;
 b=uWEX8Id4GhWFzFRR3136n3pv69nGC66cQbddo1Di4YX3fkYpjjZ75Xp4oE8mkmLM6laOdS+SQLDKHUPFHu7Bq1fBHaLO8XGRUaQNW1+J2PlV4YMaxG0Zi9bIJw37N5jgr/FxS4cs5zk4xJJgDGwLKZXR7WdhwHXO6T2EPBuxFBM=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by DS0PR10MB6798.namprd10.prod.outlook.com (2603:10b6:8:13c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Tue, 6 Jan
 2026 18:56:11 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9478.004; Tue, 6 Jan 2026
 18:56:11 +0000
Date: Tue, 6 Jan 2026 13:56:07 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>,
        Harry Yoo <harry.yoo@oracle.com>, Jann Horn <jannh@google.com>,
        Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
        Pedro Falcato <pfalcato@suse.de>, Chris Li <chriscli@google.com>,
        Barry Song <v-songbaohua@oppo.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 6/8] mm/mmap_lock: add vma_is_attached() helper
Message-ID: <aps74d2c2jkyrwstifkaf2etqjdvzskm7sn3a3kvy6mdp4egfn@q54mbprw4o23>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>, Jann Horn <jannh@google.com>, 
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, Pedro Falcato <pfalcato@suse.de>, 
	Chris Li <chriscli@google.com>, Barry Song <v-songbaohua@oppo.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
References: <cover.1767711638.git.lorenzo.stoakes@oracle.com>
 <38f916c87fb873ba8866707d51f5da8ba10c5de9.1767711638.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38f916c87fb873ba8866707d51f5da8ba10c5de9.1767711638.git.lorenzo.stoakes@oracle.com>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: YT4PR01CA0485.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10c::17) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|DS0PR10MB6798:EE_
X-MS-Office365-Filtering-Correlation-Id: 51f2de5f-bbd2-4ee7-f535-08de4d554235
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?p37UyCqIJ/X8mCMPP0DPEeLs+LT4CtukejREiR0bkUikD5S94vMfrZoWY8tM?=
 =?us-ascii?Q?qJassyInVPNWWvq7q/05rWG8TYd9KrZ8i+u1pMuTCM8ksT/v/+A17KhMDc3g?=
 =?us-ascii?Q?FgEmfzyKHHHg3Izzph4WdJihu7DseR9DpYtz2YfTnKW2t6pxQJBA8Z4kuDAq?=
 =?us-ascii?Q?Zn6ArJ7gB1MS4BozLapinkQBwWyFuhGAeVJcrjvbOt4gk/UZsbiznW57Q9Hp?=
 =?us-ascii?Q?5uUP38z1f030jyXbxqZ6b6Vgw7fj0Um5RM+WFAFaREQ26xkhEDrRR20jdU7m?=
 =?us-ascii?Q?2kR33oxeY9nitmsZ8Me1DpiRWNT021L1zmpVXLU/Sn75l1ElxZnoerCrML5q?=
 =?us-ascii?Q?huk54s+ZRjg3kBJpE4kv0zmHaS0Ad/g2V4MEBDTlz1uPk36Sby919KBLChOg?=
 =?us-ascii?Q?IfL5916jNLs5pMP0Vc79XHhLOIGPZOqEm6ordQ2vBD7cc8QDPGYLvxB4qDSy?=
 =?us-ascii?Q?hgP3BQ3z3US1G69ZsUpUrtOso6m1UW6sB/zIX2Va4dr8BXKJpmhm+y5eOGnF?=
 =?us-ascii?Q?XGIrU2kJAi5PiBxPHAYSZZxdmlTwuo2mpYweky6bTst7WJOC5WW3Q7l7mhdu?=
 =?us-ascii?Q?5EXXB8KMRMafBcEiHKjZzgZV8PEZXjRMoMwgHH+D63qoLMdtnEET4Az8uHrN?=
 =?us-ascii?Q?osnWZMgYB15CUXt5ssOzLGdIWslOJZT4x2u1jH9G8cZFsME5l/RCfyew3D8N?=
 =?us-ascii?Q?poh1u6M7c1lPwUox9rC/vksYKWxPiTwuzgs86LB5r/ODxNFuadopzJmpctip?=
 =?us-ascii?Q?sJCnVkmUKNU+RiUIwawqrg36OIclOAKpQRCs8lMHUyuaFG4Hv07E1XLlvR6T?=
 =?us-ascii?Q?zkAUhtVcwhEabAUKFnYyLAyL/BHuqeOqnr8VWuoCG1v1px3PGX+xkiZv3BMK?=
 =?us-ascii?Q?O4OQY/OKC7r7nXji4IBq9ibwib+qmT35mbZjkqo/w+LDCShEC++EXdMwjOjW?=
 =?us-ascii?Q?TsOl0tuUHW265l4FYQy6PB5kzCnU2tX2ZTMxdDLZUZlCd6xZF5h2mTtHJgS2?=
 =?us-ascii?Q?n1cbuhAYgLXTz4IWRkxurPJdzKuqF5U5ckGhJEyqiBBDc4TJYDQZB39l+K9a?=
 =?us-ascii?Q?P91ZcogxlqzMczFDYaUjEm0QotRTHurtoZhXAxOGROLW9x27FrQ3XdZkG6ip?=
 =?us-ascii?Q?n9YEW6eN5AQPjY0+fSrq3G8pY8dthNjgs8n9fW8GqHnhYwvq2Tcc7tx8mzoO?=
 =?us-ascii?Q?HLyT8UPSgE75+8tj56JBrUQAVZTcHnbj7oCAeRYXMGSpuvoPqC7/A/c9/RDt?=
 =?us-ascii?Q?pteWv44+B7JlMuEJjSEmYcaKAfYBXyhqZAMuPzP5NB8XgUt1TZ0IZ6WBiiNz?=
 =?us-ascii?Q?PnrTKavqPeYWEabkLyRWWtvnakVXQMHbfYSBrovp0ytKEDWoHHI4rwD9rn6B?=
 =?us-ascii?Q?BuAVXv0tf4pCnbkmXLbS14k0EUfj8fiRTxeefdE8uvQeDCITHsl6PSCIszUq?=
 =?us-ascii?Q?LBgZTGi8NEEo+im0fUFU3eRNKKQDpk5S?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0DtcAgpD1meFSr/T+XbHiYcHivXFsOf3N02Wj33MARpXBgsIBbYD1AjvdbSD?=
 =?us-ascii?Q?ACW+vGpu+yk4eiaazt1x40cTwS/u1VvUj7Nbzvd/VrjcC50/tYxZ3Dtd5eLd?=
 =?us-ascii?Q?o3aG50/9BWgY++SuAu0tZS6UAHTwbouugSckCFEn4dmFop785Vv4poZcGo6+?=
 =?us-ascii?Q?LzFs/RidWvhY8r3zOXyvwFeZ2ye9XXbYKZBpNp5IPMhLGVJsKRh9ysnO7b5Z?=
 =?us-ascii?Q?8vz4LLBjTBHj8gfVBZrAx3pqcyPmZiOVIPTcqMJVYbS8bJDeGnhxoIOhS2ka?=
 =?us-ascii?Q?sbhN72jFatq92dGXaSHCUQutX/4Ab9niLBFWA0ybjTZ1tyY7Lj0KC9zBGpfe?=
 =?us-ascii?Q?cRAVywy0nawef/BeoP/AU6lNT1Br4fET9RWpLisfvouJAqXphtLEe6xGkpRw?=
 =?us-ascii?Q?kHYqG3vXSTSslmvrkYGgAGlnDQnqejnIulkIquzpcTvo4zpXTsmRdgO/Z14F?=
 =?us-ascii?Q?NBizGqhAVAs/ACADuKtRFWosqy2FWvYMDxJnqYZXoT2rhpU4MoM2Tn9qRJcM?=
 =?us-ascii?Q?ymmfXc/QoYHyWMsCedpfx5Zk33WkVmEosRP2/pH74QDs8dc48SWP2noO+HiT?=
 =?us-ascii?Q?1KvEkgVUSxc0xlTRXHojxo3sBNLWMtytjy1aLJU/BCMDidgIpv8Kbf8dpu+z?=
 =?us-ascii?Q?x3aI0WNqCauBs2qc84g3jtVPg9AH1YOhhY1vY8hSBzCSXY6UQTm4NfR9YWhN?=
 =?us-ascii?Q?y7cBpM/7IR7xaTxhNdW04PFeM8fQ4KArupIK3Nx244lVZBzeUJqxCL/k2xRG?=
 =?us-ascii?Q?TEv5PIw4yf+ak7g9FQbloMJF/McxF8Pu1odRLABmQf2kPdgo9Ma1ApevZb1+?=
 =?us-ascii?Q?KiTWp3i5o8Mmi8F08iyRw83/AB4KPt+H6sHSIvlbqsWdWVf3XdmkwBH9Dxod?=
 =?us-ascii?Q?95XEEpo37qCsiekPZkac7K6UWdS5SWQcyFF3Tk+nIL59leDnEp/YNel5Qp+Q?=
 =?us-ascii?Q?PQl14F3I9fOlXTRDoTz2EQdZVucxtFopgWMtgCjg4/dIV07GLa+7hPzF9rbv?=
 =?us-ascii?Q?NbutC1Oh2KQTtLrPiRlu9kj76AkD6EQQNY7wLc7Xo2sR3849+UF05uq+opR4?=
 =?us-ascii?Q?vbNJcfmBHSrIj0Dq3UM8q4AQSbXCupR2PKRQrEOlekIv1Qa0Vp1+rByLWweT?=
 =?us-ascii?Q?eNqLt2bLO/NXisSu4T3kluEXYEU4jpBMMTwCna6gJVZL2uaB5GF4J6lwDNxQ?=
 =?us-ascii?Q?6nt69sHHNuhQAQ2WlzlIxhHJDMlib6BNvERrioKOgRtC/0qLW3/QQToBRvjl?=
 =?us-ascii?Q?we3Hv8NQomCHM3ETCS+FB0TGjGzz7mh3bdTa3UKzcel6cBWfaoMh8msFymO6?=
 =?us-ascii?Q?x0NTk8RDnof/mlyA/YAfWKQSOqbHHrQt++54vuzGXXrc6s4iUmw6TUv/Winn?=
 =?us-ascii?Q?RXCkSUZJPDHtg5DOQ9j3KJVdec87uk9k6wW6PZ7Np9ub2ZeDYtWzW9J63VnO?=
 =?us-ascii?Q?P5Ha57JuHcqn6exTcRKySAteR3r6oEp8bw2QVEgi2eRjdpV9n7kVBg6ruBD9?=
 =?us-ascii?Q?PyhsKQg9y76PW/+HxmiXRNT2FNwSnLwe4+T3PpdTI1F1ExpLTm+1tmXGV5Wp?=
 =?us-ascii?Q?rALrWJDM7wAbexf6IIv+VrnCRF0jh1Z8YdyxPKLh11Yz2Z9RCf5oZdcFIVGD?=
 =?us-ascii?Q?0lo+h3yZwQab/gHRqf/b+cfIp92z1WNu/6i38dh3hWpQDh9IUjgYZn2bfzW0?=
 =?us-ascii?Q?aIW7RvshyCOS0nVwtf5v62XOX2ZPodldzNItvyRG4kTwJF9gkCrA0jFarbqO?=
 =?us-ascii?Q?YobwAT/vgw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/jQWHWpNMcLrhO9x1WmxlCewFXQTkPq4Oc8kYrAPTvVZj6jrY1oRLyTyntY/xoPI0uOjgmjjoI/chcYpaHPxLuk7LYmS/vraihE+p8NbhiXxbz5duo/3KdqV/1THOOiBpYsc1ADknvZcLnw26I9WsIAr3p50rn7Lg0ffb3Lpb7DYciARusiOxZ+zZFTjt9NBEMc+NkCLAWSpLd6+FRBHz31eyUXdNnN/cN8hPy3V467ovrjcZHqcfJAx1OZGRc5WjjG0T2DjTyVzRcqmA+3ZoiEJ0ATio0d7ave2AdOoVOQdQjslZgqY18HLPEjK3mOj6G+GESD6nnFnY97c5+zQRnGPvgyMiRpkW9+28qBWcLf6QGhXCF1QIfdOszYHbVKx52CVDVsIG8g99guw7yjkWaRE+rB7mPaGXV1FTdnaR4aAAyG++Sda6TI3/ZJeYCCrUQ6RSph5jwxtjgUNySfukley3amwkInPe9mLMgJIvimBj0Alld6wpNmyTNwFNpHfECrgeJdR4VVJKju13OQNp3K+QLujXXXTVTLajxim1fA7j7JVezc7w6u3gU6M5KJ8ZMAco3YbMfJwMbn6J1xP4S698YlFsjyQof7WhMQ6jU4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51f2de5f-bbd2-4ee7-f535-08de4d554235
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2026 18:56:11.2485
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7X8iNy9cDODnGpvrxzaMfA7XUHLam4wnpNQwVrbTpofByE3YVHFbsPx94OqcRVpM3oe7sR+jomDYQpWL9YNsEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6798
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-06_01,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601060164
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA2MDE2NCBTYWx0ZWRfX7VwuW0WJkR9N
 nQGbXRybhoULOAboWxF+tY+Duq48d7Tv3x7zpixnsYd1xsq5bQ91m2AJ8YKc+H9mcfO2h4+6/io
 cIBQ43iX4pZIaXlxJpDgnVwOFNP8qeQpNKrkhVz8ivS5hcA8KW2+GFoykMwlfL17rddRdHTq8lR
 axSqespHrZZLcvEOtfXQFyisELeb/ZfL3dB+k6ORdtJEIITS6fAKgTS35TVi/W+M3qBF1w2VmVs
 3086Q4utQ944QWBp2sfRubc7UtvlP/tQ0RHuugtKOwbyFDDTgdWw0cbV58RUqLQAek2zukLjJUj
 15/i+aa4K9nQ5pkWPYdbAuOTH1w292AqcwMkqFCY/lK/bc+e1nASGCjFcPQl6K6dlr1/PBnSgiq
 4IflmxDseFdlO3lRi+eisIR6SnZIg/xH+mc5ZtvW2/lVAOtcIjK5tf7hzgziKeqfZpbWGNnj53+
 gO00VnEwuA0i28tUJjA==
X-Proofpoint-ORIG-GUID: 1TBH26G9ITOCMEVVMQGwTfduLgeHmxED
X-Authority-Analysis: v=2.4 cv=Zorg6t7G c=1 sm=1 tr=0 ts=695d5ad6 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=1XWaLZrsAAAA:8 a=R_hthKCfEM6S1s9_JxwA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: 1TBH26G9ITOCMEVVMQGwTfduLgeHmxED
X-Rspamd-Server: rspam02
X-Stat-Signature: wt3s6ujfi1uoq6h9wt1q5991cqjh5p87
X-Rspam-User: 
X-Rspamd-Queue-Id: 4A3FA100005
X-HE-Tag: 1767725787-337212
X-HE-Meta: U2FsdGVkX1/bhzqqP4aKpO015IZd9WEiudyQVwkzJDKKXIBSrunzcTdSRPcwcT3iIP9Y18viP40KJDmepU7ZyhNGvKY4IWgAc4QbmVkcIL9guPmL7inECqdZUcjMmvQGugjvV7mWN/aOfUxCJsMyOxI/RCfJz+39BHBHv3pDsxp7WfjHyi/NggW7V6nPk20KpepBYkppSJBU4P8itwnjlR2l8EwbKkxrZLT/In3DgUYopU+pobuuCtvIxpW0VhXcGd2nN0c9hSpM1SnXNJt61gQn7zllXco4+iQ8cgGL2Mof/GX3iTQXGm5+yrVrjhRR/ffoy78efnwuMPkDx0KoUaFPAcZPrN5OonIWvJz3aXxXuQnrEqPxPMJ22DRaYUDfZutBke0aJn8w3aSu8pEyfNh6o1q/jnYtkryOrweDyWjDcEUzmM4EVkHjehC+1TDFwAlCZNaiATaNitfMxBc8Cpvkdl07DeKq7+TPKrM4r7CBG94tE3pCop0JdycqzLwY8KEaMyGeWJ1VBcRTzNmDUqB32RN/JFyEM8cTS0YT9NB/opzdHVAHaIib6tdx873+LLjs0CVKNU1KxXAcUhIwxozCM+Dd3ix/Bv3UhUKqu6veoKyU+1kMOONxBcbJWpsCSIaeCsjlQ26u9xo9sU6YXDgEEs/gTVPmQQ2ONA3eTcf+dtc67+/51VnwGlZSVnonizK4Qpkhn8u5MHCZ0mgAQuu2wun0HhP1Mgkct1Wpi79S73wypR5lRLiUH4kJRDMEEUk9CLWQNKxTDTAbfsVGcZu+nbHsDGkzXY3BG5Y49pjN+zdRsqyDSkgYBuh4zZvmANUEpHA6jILKeEmhIqHSes2r8NsFPBynFkYG+tGm0ooZS6gfH+FbIJOnrAeHYjGOwcPakX9w/EJ2sCaCcFlOR80kiMTy79WzgO99CP4Ll0FY/K3tmtxSkbXf4vy2F+jYuOzZOUNybnmBNmI4jji
 +cG5F5Fk
 vj2zwsZ/mBtYdsR8pJqqcxziswjFMWSkP6YQlK7RBtnsbqqv2i5uMn3jcY+9aE4S8vUdQG7pkCt5WEqTkQJF1kUqMaDBrKKxuM5y1YqjMDkAJlPhrCWIKtqta7Z1IqS1sMclz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Lorenzo Stoakes <lorenzo.stoakes@oracle.com> [260106 10:04]:
> This makes it easy to explicitly check for VMA detachment, which is useful
> for things like asserts.
> 
> Note that we intentionally do not allow this function to be available
> should CONFIG_PER_VMA_LOCK be set - this is because vma_assert_attached()
> and vma_assert_detached() are no-ops if !CONFIG_PER_VMA_LOCK, so there is
> no correct state for vma_is_attached() to be in if this configuration
> option is not specified.
> 
> Therefore users elsewhere must invoke this function only after checking for
> CONFIG_PER_VMA_LOCK.
> 
> We rework the assert functions to utilise this.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>

Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>

> ---
>  include/linux/mmap_lock.h | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
> index d53f72dba7fe..b50416fbba20 100644
> --- a/include/linux/mmap_lock.h
> +++ b/include/linux/mmap_lock.h
> @@ -251,6 +251,11 @@ static inline void vma_assert_locked(struct vm_area_struct *vma)
>  		      !__is_vma_write_locked(vma, &mm_lock_seq), vma);
>  }
>  
> +static inline bool vma_is_attached(struct vm_area_struct *vma)
> +{
> +	return refcount_read(&vma->vm_refcnt);
> +}
> +
>  /*
>   * WARNING: to avoid racing with vma_mark_attached()/vma_mark_detached(), these
>   * assertions should be made either under mmap_write_lock or when the object
> @@ -258,12 +263,12 @@ static inline void vma_assert_locked(struct vm_area_struct *vma)
>   */
>  static inline void vma_assert_attached(struct vm_area_struct *vma)
>  {
> -	WARN_ON_ONCE(!refcount_read(&vma->vm_refcnt));
> +	WARN_ON_ONCE(!vma_is_attached(vma));
>  }
>  
>  static inline void vma_assert_detached(struct vm_area_struct *vma)
>  {
> -	WARN_ON_ONCE(refcount_read(&vma->vm_refcnt));
> +	WARN_ON_ONCE(vma_is_attached(vma));
>  }
>  
>  static inline void vma_mark_attached(struct vm_area_struct *vma)
> -- 
> 2.52.0
> 

