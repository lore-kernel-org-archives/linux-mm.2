Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D638ACA0EE4
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 20:48:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 581DC6B00AE; Fri, 15 Aug 2025 16:48:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 559FF6B00AF; Fri, 15 Aug 2025 16:48:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 421F16B00B0; Fri, 15 Aug 2025 16:48:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2CD186B00AE
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 16:48:54 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D09B9C025B
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 20:48:53 +0000 (UTC)
X-FDA: 83780180946.06.D12CEB9
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf30.hostedemail.com (Postfix) with ESMTP id 601AA80004
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 20:48:50 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=hY8r5qNc;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=CCq4k7ag;
	spf=pass (imf30.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755290930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wr7cg5Po/7hv5h8lm2NBLLJSaASFlyTOia09tLdddm4=;
	b=X2XXyNgHFza2YQcPD8vKA2RhCEC3MqVvQXcLqOVh1Jh5Q2GjuVe8IXWR6Kh7A9c5np1bZv
	aq8mxvLGO5rI3sfN7CMuO5Fg2+30SJtUSJxdewLkV9sEVZ7DYW+03WTWEz26YPx4/5FUym
	tTWpcz6fFv59qDRFkZO7Ayyz0d0RnBI=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=hY8r5qNc;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=CCq4k7ag;
	spf=pass (imf30.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755290930; a=rsa-sha256;
	cv=pass;
	b=fSMJUYgyCnjI4z3QrYB2szBR8xsdipAhOlGH1k1VyzWbIfxx4EIgIPpMJNUHU/rkLfZA4G
	b16uep1SFS/ke46NC0DWHBo2lofRDgdHLicphCAN5KQHsUXpyPsKvjeuzXybUMiosSJjBa
	9RssLM/mJi/piu95rriadPWqwBR5Tr0=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57FHliqM027040;
	Fri, 15 Aug 2025 19:10:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=wr7cg5Po/7hv5h8lm2NBLLJSaASFlyTOia09tLdddm4=; b=
	hY8r5qNcHBL1Q83TeZq5imnf9jrmlIuWg6615PCdeXyuU9Pcr1v7jgjLJWVtVpRV
	U7BWnDmNmOSXUGNbXo2hB9cZ6x3f7nTt90VcPIJt9nmPjTozRO6ntzksZkEHEPxZ
	cfRUEEB/DI5/BHIJA6cjM85cvpxJxKVLL+uC8JJXnfeegiYlgXSM1myWacGp7A4T
	Jtrt9zTl4jOo+ERGTAhAa3b7V6Pdq7o6l6UrazjAULq7WNi3uhwDg7q4i+xpCuFR
	8nExAQxygRVzkkwcINd95lulNq2JYf/LQmvplAC6IwSwqFuuJAQV5BPRm5dKDn/0
	YmT4zHGn2fKmc9BN5nahtA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48dw454hmn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Aug 2025 19:10:51 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57FHVMou030195;
	Fri, 15 Aug 2025 19:10:50 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02on2060.outbound.protection.outlook.com [40.107.96.60])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48dvseafnn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Aug 2025 19:10:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MGVGpyVEgy4Gsh4l4TnpPdCIal3aQF4M5Jx2NZMuTTLNICpgRrs1LqtadW/xzC4qMCnnLItDG9ExL9N4NIawvTJ5U1K8OkVYspNukztIeGoo7ODolBqgq/0N0W2HnqfAOLEMtq0fhZvwvzxWwsut102sbwSFG5hwy8mYyx954uIPfORGDsNoSy7OMCg2dnR+dqJhxay2yA74AkGGKiYPN/10Kqvz0/ZCZaYw7UjuAMslNfmJ9Vxl4SHkz3FQPYr9WnVreBYI5RcInyqXiZ92+UID715//j+sZOYFHu/ne0excmetu0PB7xaZECqlxF+tHy8BWvDs7i974lmDI+KrzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wr7cg5Po/7hv5h8lm2NBLLJSaASFlyTOia09tLdddm4=;
 b=YCn85ZP0RgZdHy1I1D/rpXCU9xQwt8dgoknRcFhS0ArVlYgzy5znsf/9+tsjjwVJTSuaD8rzPcqlFOBOX78RJaV/GRl6GdxymoVR2bpmyae72+lUrPKtdvoyAlTfDQxY3ZAz5ki2phYDejS/sUyQ7eFjn5VwxUbAaoBOkfDCrIGKauF+JLeInz+W3dvO3OGsq3FH/B82WrTEh8VvSysi35F0vlK4gmpOMGjHu9OdfY5x0UEsIFZJsUnE0Kid1/nRjR3GDIIt5guS6+92bbGgey5EOBFDvyBIYBMka/hl2OIO6/BMEJBBRqgst2IKqHrJ+c2rBky+hdjCbQG82DZKkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wr7cg5Po/7hv5h8lm2NBLLJSaASFlyTOia09tLdddm4=;
 b=CCq4k7ag0n9rXxwlojxyKVtVeyLcgXTtx2b0fRHMosi70L7bkC+CliSgTSLrrYiJ2y0PfTmhZbQnjA304OBuJI/fyloGLbQnmhM3GTWYcGqIdzlf98zfBqSq/Fxe/WFAoRDFnsknf6l7SgupaCvao7LtG1n4XO90P4SMZ/wls1M=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by MW4PR10MB6464.namprd10.prod.outlook.com (2603:10b6:303:222::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.13; Fri, 15 Aug
 2025 19:10:47 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9031.014; Fri, 15 Aug 2025
 19:10:47 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: David Hildenbrand <david@redhat.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>,
        Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        Charan Teja Kalla <quic_charante@quicinc.com>,
        shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com,
        bhe@redhat.com, baohua@kernel.org, chrisl@kernel.org,
        Matthew Wilcox <willy@infradead.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [RFC PATCH 4/6] mm/memory: Add tree limit to free_pgtables()
Date: Fri, 15 Aug 2025 15:10:29 -0400
Message-ID: <20250815191031.3769540-5-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250815191031.3769540-1-Liam.Howlett@oracle.com>
References: <20250815191031.3769540-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW3PR06CA0010.namprd06.prod.outlook.com
 (2603:10b6:303:2a::15) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|MW4PR10MB6464:EE_
X-MS-Office365-Filtering-Correlation-Id: 66d32b07-ef78-4f3c-7a12-08dddc2f711d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?qoka3mU5BC37bcgTJ+mdPNUdtqxme1oSLu8QT6206lveOE6SYx5NMCFpIjxV?=
 =?us-ascii?Q?YNkM9c3gHz0AV3ZlWHvDr3iB1RPG7hjhLeDLnVQXZ9CNz9c5chMixohS15ab?=
 =?us-ascii?Q?+/T1xg+xYE12CbWxIeElR6fZXnuubIX2f3dShENbFthN7h2xn9knAP4JxT4a?=
 =?us-ascii?Q?8o0mtzjF2SoDbHsKiO0zo6mx9AysOKCaJCGG2xh4NdWMojGkFhlD968XyvVM?=
 =?us-ascii?Q?6LPE1wuQvpGSDDFawUdrjW+NsZbbNawq6P+x0uBZC8QWrTDYliBxLsW3l/JR?=
 =?us-ascii?Q?wxC/NSOlY8xUMZVbp7Ud8jKgEWk4BryjjkYkFt32AR03cmwjCocuy4klwAyq?=
 =?us-ascii?Q?7IbVFSTWCWSp87D5jz9iikc6ZM22zehf8n51kxAeQ5glNDIr42nJHfI/5Dll?=
 =?us-ascii?Q?5QI/T2oYgCKgrHgRDNhUKdh1pxyZ9y4XhLAr5W+lZzlSk72m9GOpCKlKpRst?=
 =?us-ascii?Q?eVqkxnbDDofW8T6PEGXNCIdO5jBCfNNRMnjRBVAaJ9P9x+Cu5qhDoJfiPPSt?=
 =?us-ascii?Q?+/uJRDz0z9s7h6ZizWCsm2IrPqap7zsbKsRBHtQigmTObBHrn/741qG+rcJy?=
 =?us-ascii?Q?N5K7HJ6oMxkEiexKAiNXArr0SncquPHEd/LUAkiGtO13A900gmHvt6dtHyy0?=
 =?us-ascii?Q?BYNwOQ5mG65VG5aDg6QRxxQmgJfPvdyUVDd2p+hWwyKOCo33qy/2e4Zu1GHN?=
 =?us-ascii?Q?noyadFVgv9WVPHZlk0Oefaos9x+Ppbv0mwyUFYPN9eFINQWPRdbHXDTLQeLa?=
 =?us-ascii?Q?jWoWeKe1YafSuJTHUU+/DBYiSAcmf+zsn65vbHUvKWZbD2O+v1BTCHBoawvm?=
 =?us-ascii?Q?oPoiB/VYvA7W9MUQAa2njr4GwZTHlwD4P2wXUOmbpkuICkDbP6K6ejgU9n5f?=
 =?us-ascii?Q?e4WZkssrZYjKAjealRAqhyqx/9/WegfCoNlaPL8y+G35WE8j+m+2Ww9/XenE?=
 =?us-ascii?Q?m6upapPvVfcvXiHo/I0qi6OLnC390Po7drOuw48mMP1V5B8Fa19Nor2yVgD0?=
 =?us-ascii?Q?5OTT9ofjQaLsiABKVr9EfgEQY9XMQFGAtY4tFt6HN0HSWlXnR2noEHLFS0kF?=
 =?us-ascii?Q?15vvakE7iw1kCDwOJaoGROomTCH0jxdtklZ7+ESXiErtULWp2I5ak6kfMbuA?=
 =?us-ascii?Q?yxYMuiZyOWnT+3SZPBNWuDTPYgu8Mny7dddMGeuDo/NTiC4LAsB0aAsvHzqg?=
 =?us-ascii?Q?VrQv886FyxD1Xkoz/sfF/t5B3pepjFMgp5Pluk7g3dBZIlctUcQI6hE2wM1b?=
 =?us-ascii?Q?f81a8BbQaYAaXf6zwNNsB7DXzM8veGbXw/q7Ch9/kXZOtZhJfHelPOiS+U+2?=
 =?us-ascii?Q?jEVtOY08BpNQwkXA6RrhIuYa84le1GT9v1lPVJZKz/szYnY5qYvPZQJh49XQ?=
 =?us-ascii?Q?VsMeks3IhKDU6uXPPN1fX7pSOYQK6MiWR7wkqvPNyTRWsdNj0DyJP2zqRA9x?=
 =?us-ascii?Q?yJimR7tIFXM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HSqAY/q5f6bB3+ZHZyi4X0sjP+IsNR0U1caFX8yvy6fK3JHS0lS1eNS0sL6c?=
 =?us-ascii?Q?uWEVGN4KZqVMp5E+wr/JG/Yv9y1DcWtbqDCD5r85bwsLohLjy7U4GAcTLslp?=
 =?us-ascii?Q?LxaITPRallTs8JQcKQDmzGg5BSDo7u9aEMuNmEDe/v0s1PBIBCqJ3C2jP6ae?=
 =?us-ascii?Q?XHu1YDZYdCyowc2/tMCbOnkgwmc1zDkl+kLfyS2xhi1bCho0RTH3cQ89BjnJ?=
 =?us-ascii?Q?zR6gRg1TW+/f9Teto+IzpbjAX4jnDXvnrD3bOQyo5iVPeGXI4LxeTsN3lMS3?=
 =?us-ascii?Q?4z7uThvWQsClZv6c/uZ4pkPOQn9RPHeLnRPKPHnqsVKnp5941WfwGOw37uwt?=
 =?us-ascii?Q?4CTDWgYuPqqp+5W91W8K/7o5B3asA+hHq+xdBydQK+bcpboOkdq8sSiF1Jvw?=
 =?us-ascii?Q?UFANJgh6FdghmpAmjw21FxOYSH6dPQZEg6/RwpgvGj6Afs9tIPD0biP7Esa0?=
 =?us-ascii?Q?PwrmA7uoKz4CKaDelA3cSDnc8MKGvrrjFzMT24r/hyQ6GTliRegP+IFHKdRa?=
 =?us-ascii?Q?XYAgW2s1I/WvMRUwZZ//aDDf0Zu//Ob/ggfTXJDyQBBHgXTqAskRlaovr3DM?=
 =?us-ascii?Q?runPbJtzH84H2KuV+AUOsDDHtkoJ0cBGKxvChG4yteib5HIB/4MmRLoNoayP?=
 =?us-ascii?Q?JLIPsQgaEhmfg59p5ibQVp6YqDg1GhkrjEY3fMucu1um0FIaWkRDAC2r1ocE?=
 =?us-ascii?Q?60vE7vz7b4AxDdmVTV9u+qk5ztvx+R0D9c8TS/p1vJzhiLPasLC6tFG5KbGD?=
 =?us-ascii?Q?ZcueLR2g6Zfk65X/aQR0Y2Y5UQKPc15aLU9PwQYttbmtjN+M4zOqJBXEzR3m?=
 =?us-ascii?Q?R9Mg9RcnkodB5/QwV3bvcSgQ/MXFmiulOKqLHvYGkDHkhDsVTDtYtwTvGyC0?=
 =?us-ascii?Q?DQqExP4m2l9UKMmvpRzT2Hhem68wxVaoOLdnw+aPJyIZ/oxwzzYKD19KmOHD?=
 =?us-ascii?Q?QFwEH69kAWcF331KdO1ogGDIANYmkOKpaSJmDMetmwS4fT6+XvTpfLh6fLeG?=
 =?us-ascii?Q?nooLS9EsT1p+3EXX2HvZDJcUeFANptqylX0kehlyZL28CdLRGIlfnJiA755G?=
 =?us-ascii?Q?t8Cvy/9OD/Fp01VuKAIccfBhuXHorNyaaI4hlJHGD3qb+TyFgxMgF6DMf7D/?=
 =?us-ascii?Q?OPk/t6y7Nh+nU9PUTTl1vE56pOnmIuHopePLqrlBX36fsh10QICkTXPusvio?=
 =?us-ascii?Q?vlWDAgal74qUE2U3iFbnm3JDJlW7ZIWjSBgKKy9W0uLh3CFSoVDgBsk1JQbK?=
 =?us-ascii?Q?+VH+dO9uQ6jmiqjaoypCkxxyyP2PL0E4nYX2fdo9lXTllGD13hlwKhbVOYN9?=
 =?us-ascii?Q?WjYJeQmBG8J1x41LMCeF0ImxWuoB5wbTTQfulRyfxGCabYVnyM29o7D3JahM?=
 =?us-ascii?Q?oVc6Rk9//ahPBDUmLbJED63kxwJergKQcB7xmD4lHJoLHE4r6U6hsNwaeQcg?=
 =?us-ascii?Q?xzftnwbKLKTQ3nc+/JQK5bGe3z931AIC/FfVDrp30Ddw6fFWBn6xKgTbcPg4?=
 =?us-ascii?Q?zbW0G3YLpitVxMwevvz6X4UoAxIbPEtT4TtFSTehjmhiqhDt9/7HJzw4/ZcP?=
 =?us-ascii?Q?jcoKZKlRQPxT/gz8TUOXHexKQEhV22ezjsG07y5u?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	N4OzOnydF0K+gR+4g/iqmfOZ/Nz5IzmuZpKYC63Etlly1/lilUIVcvCBxPRRzYxi7eS1jjoN4xJLFUIKpF1c/DM9lZ3pkHJp/iw+2W0kaVGhRZ4etee78Sf64fMCO48cb+u0yOIJ9Nl9P+cBjdev6F1DeXzsY+B2nexDOWSN139TcZjkx0YGWCzmSmgPHye89HTUkLbYf9USG9jCe3XzkngwP+kG+zPi88CC/PZ5hQkhNpssZWbR7fodwAM0uHkjOfhBjE5f0s0D225meFqx9ohLgmhAHD5ljJJKFHWk4yIWom6Aq33SBtoDXH/bM6kOHX7CPUhCs9RttzIAj3atphlrAsNd+mIqjeD9gXpqVYWmTwkkJhT7bWxsPc3JQilL62VWYHJ26H3mYkwYbrtt8IjwLW5fpGI7Iiq9gHO5z2/jn/J2T21tvGPVqe9DijVBLVankGYmn3xwLAJKtv9BVDLZQxG/afK69K9nXUBV9jRP3pylFMe2Wi3IoLQNNKk7WDN6tA+tvSeyy7/nU+kV3uXvRSrxJqYJ+fJd5fmqbUUMX4hrUcQ8jF7sbcmmJ6kdil/gx9X5t1Hh2Qfct4w2ALwu9H1xLzKTv2hD7dp8epQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66d32b07-ef78-4f3c-7a12-08dddc2f711d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2025 19:10:47.7096
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9PbKbIJ4hFYfmVgVvTZqYvO8aiu568jsCkx1VP1DpWvdRb1qNCD3Lmfj0mmtDxVgMc2xHSb0zSAhZPQrg51jLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6464
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-15_06,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 adultscore=0 mlxscore=0 bulkscore=0 spamscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508150162
X-Proofpoint-ORIG-GUID: pSz825y8da75LFAU_hoTrWP1mWd4jQ-x
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE1MDE2MiBTYWx0ZWRfX3SbF/kB/+e+X
 PT50Ja8bNHYEwVk15aUeed2QAfD+xjjFqTGVhIX1tBDst2/BMOEUHICBXlVo6KE2TkH8O3pMU2G
 O7Pl9eWnmAPDqvH7FhVD2lwbfVxymHitgmp3ZMLDacVvRrMJn2ms3HPDIaol3Pb6EobIzMJsLdu
 zoWspTOU0F6J05LttGZlJvYkVPLc9hZxl/TcF/hiZQIJCKz/EEUgHbdhHcBVwYSlZZrvqS3og+f
 URsdvKiuNTwUIpkKLepaOdJJaJyfj/CesXjXF9MhKgRSxxlSDGrPgr44aM13+OM1WrsUtRmBJcf
 y3FmD1G9tOTipgOkgj2j3SDLh0dLA+bW/RNAlyHznR+/3r1jm/7lcnslQ/UThgooOPPX9pBMV48
 EO/bF36k3QppBfESCN34EWHocXsoDP7WCynO/qZKKcJkXqT8bpUqvYWuKm8WgagDQTCbsJT0
X-Authority-Analysis: v=2.4 cv=X9FSKHTe c=1 sm=1 tr=0 ts=689f863b cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=2OwXVqhp2XgA:10
 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=rbsCjLBnI5ZH7-GDkaEA:9
X-Proofpoint-GUID: pSz825y8da75LFAU_hoTrWP1mWd4jQ-x
X-Stat-Signature: yu9dq9edmzmx6pfu6sb8ah3ohratenqu
X-Rspam-User: 
X-Rspamd-Queue-Id: 601AA80004
X-Rspamd-Server: rspam01
X-HE-Tag: 1755290930-858766
X-HE-Meta: U2FsdGVkX1/jbcZrMh2i1fEVYAkv3k+AjtzNHsako/aBLWVWAn6rPITZbMrMkb9Ioyy7me9b5OtX9XxCbc9175t/6JBkzqnTjoaNrOIwM/ys4afxDlZp8sAUxFl/2Lv1GDAy4CxdKf5UFhCkJwIs4slhpN4kxKVfrcMQoT/f8gG7aUIa/U7xqQ68xzSzcSupBEDuyBve6ngA013lUqicQVNls9fB9aGFOe6RVusc9rl1efb1S1AOG0Tk19d0RxryWCuv5YSXBN23nanBzy/Rpq9MFTUqMcwqZ3EMPd67awClGneL7xdUR/r3KJ95qp3njEBgGO21bI/7Pkb8z5GZhC9efK3rUzb/ClS5il6J0AgW5uWHllyoZDNW6PRE/GHBXbnTUGP3rg1Cyl5kVWEcdCEyAuD3faOKa7t8dOa+vVXSbGofvDNhzyJu1Efw/pdbE3ejriR+7I7Kxc/xjNAlnc0VK7hhTRmdkXXTjMeT31OJoHCyu8PPGamD+f0CgInts5wDs/5hZ5tPjXXZjetXBrx81k/NoS/kFsHdsn9zlLrNOHd6vLtsEUHwuBzyAb8qkZhbLlj0p39c97JOprxje6S2SyOINDLEY4A3j4SFKUntPM9hTEOOJ6CmxC0XBlB23oHCerq25OOvAoNUBK9f2w5wOXDhYpMqODz36TTk53cBzVw1IdziujNTJ2iYNT4bF00DyvAL6YSNvvbP/SbY6qjbqLMrN2MrWnsl/1dhUbTMUtlM6D1yjWHcWD1VSLGMLMU2DKSW4jqbmqCLijnlZ+QNhXiXIDL4/vduNdMGULw3zYANvcbaMUD3TJ2B/Rg+kLwcFTlgyH56dnda7xx+LmQSUPq0Onv1Ciy0UrnRhZPGST6qnYwpVhsyhIdAdXCoM+o3dhb/qVK4ydbC7YDtLPr9h/D0rCOmBJ3sL4S1qa1L0CgG9rUFsWpxwg6SCL/oaKF+XMhSZqqivSX+3Oh
 FeAIeGkx
 Vm0DusNyGCnmwsky7j5KU/Iv9xl/eX/A6Dx6XWxJxlBXeC4QOPF120pTvHyiCOn2aPIWOWAEwnWSxWUN2tUuVD9uWVa5DIXzlcrII9yxJWYPmLO+6bewpF0ulna3j7gtKzmZYLnMqnxUxRfJjh5BhuyM3EClWwfGSwPowT6lKDF/d8yd0h12lP20Cx6VKerKPPo/kuVN0oayG3pLlCKdjTS0DYRkmkZ10H4gS739uwRW5h01MtpMAE3joQKDuLG0Y3enaLV4asifkGZeplf+uh0YqHGxanDH42YKB5lpEJOzZhUVpfKz3ikf+HP4SCBLnqs2O+1MuH7G8n46ukOBSYuWeW2KcvqTt2rIh9cEFXQplJBvjG1L9IvC2edEwwDhz4+BTHdVM4HCHTOEBRXbN2Gm7fkvlwNRpJl21E5MZbbxyiUVGK0Vun6K25GG2gh1GUqc5ghIl5JYUq5LEO6CBApyH+0W16wMboo1gPDkq/gAosZ9B9KHvowMnAlMfDPfsMSkuZz1b2C+LcSYYx0nKaFbLF8Lc3JsW5Y0gAOpL1mT0IG7A/kVzXHI69KUmfEQe6164fLdpesF71Qi25mKvh6WL38EWsEeJ5VF772/yWhbaWjKh+JaGSCOCSPV3KCgCl8VIsDVZazv9wCQya9/Y+X2bTO6Tc2mII462tpA0OQVXiTSb1//XKKhigtehZQT1MIunFe7BxlF3FagfvZOGgmyXdnFe+Kd+Uc50rr8KWo+mSPhHvpbZG3ImJccPVflT+pvC0iuF3D36nhhI9c5fBKXlYg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The ceiling and tree search limit need to be different arguments for the
future change in the failed fork attempt.

No functional changes intended.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 mm/internal.h | 4 +++-
 mm/memory.c   | 7 ++++---
 mm/mmap.c     | 2 +-
 mm/vma.c      | 3 ++-
 4 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 45b725c3dc030..f9a278ac76d83 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -444,7 +444,9 @@ void folio_activate(struct folio *folio);
 
 void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
 		   struct vm_area_struct *start_vma, unsigned long floor,
-		   unsigned long ceiling, bool mm_wr_locked);
+		   unsigned long ceiling, unsigned long tree_max,
+		   bool mm_wr_locked);
+
 void pmd_install(struct mm_struct *mm, pmd_t *pmd, pgtable_t *pte);
 
 struct zap_details;
diff --git a/mm/memory.c b/mm/memory.c
index 0ba4f6b718471..3346514562bba 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -371,7 +371,8 @@ void free_pgd_range(struct mmu_gather *tlb,
 
 void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
 		   struct vm_area_struct *vma, unsigned long floor,
-		   unsigned long ceiling, bool mm_wr_locked)
+		   unsigned long ceiling, unsigned long tree_max,
+		   bool mm_wr_locked)
 {
 	struct unlink_vma_file_batch vb;
 
@@ -385,7 +386,7 @@ void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
 		 * Note: USER_PGTABLES_CEILING may be passed as ceiling and may
 		 * be 0.  This will underflow and is okay.
 		 */
-		next = mas_find(mas, ceiling - 1);
+		next = mas_find(mas, tree_max - 1);
 		if (unlikely(xa_is_zero(next)))
 			next = NULL;
 
@@ -405,7 +406,7 @@ void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
 		 */
 		while (next && next->vm_start <= vma->vm_end + PMD_SIZE) {
 			vma = next;
-			next = mas_find(mas, ceiling - 1);
+			next = mas_find(mas, tree_max - 1);
 			if (unlikely(xa_is_zero(next)))
 				next = NULL;
 			if (mm_wr_locked)
diff --git a/mm/mmap.c b/mm/mmap.c
index 0995a48b46d59..eba2bc81bc749 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1311,7 +1311,7 @@ void exit_mmap(struct mm_struct *mm)
 	mt_clear_in_rcu(&mm->mm_mt);
 	vma_iter_set(&vmi, vma->vm_end);
 	free_pgtables(&tlb, &vmi.mas, vma, FIRST_USER_ADDRESS,
-		      USER_PGTABLES_CEILING, true);
+		      USER_PGTABLES_CEILING, USER_PGTABLES_CEILING, true);
 	tlb_finish_mmu(&tlb);
 
 	/*
diff --git a/mm/vma.c b/mm/vma.c
index fd270345c25d3..aa75ca8618609 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -486,6 +486,7 @@ void unmap_region(struct ma_state *mas, struct vm_area_struct *vma,
 		   /* mm_wr_locked = */ true);
 	mas_set(mas, vma->vm_end);
 	free_pgtables(&tlb, mas, vma, prev ? prev->vm_end : FIRST_USER_ADDRESS,
+		      next ? next->vm_start : USER_PGTABLES_CEILING,
 		      next ? next->vm_start : USER_PGTABLES_CEILING,
 		      /* mm_wr_locked = */ true);
 	tlb_finish_mmu(&tlb);
@@ -1232,7 +1233,7 @@ static inline void vms_clear_ptes(struct vma_munmap_struct *vms,
 	mas_set(mas_detach, 1);
 	/* start and end may be different if there is no prev or next vma. */
 	free_pgtables(&tlb, mas_detach, vms->vma, vms->unmap_start,
-		      vms->unmap_end, mm_wr_locked);
+		      vms->unmap_end, vms->unmap_end, mm_wr_locked);
 	tlb_finish_mmu(&tlb);
 	vms->clear_ptes = false;
 }
-- 
2.47.2


