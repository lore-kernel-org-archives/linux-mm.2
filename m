Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAD56606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 01:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=MW15Q6Gy
Received: by kanga.kvack.org (Postfix)
	id 7B1726B05B0; Thu, 26 Nov 2026 20:44:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7618A6B05B1; Thu, 26 Nov 2026 20:44:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6020E6B05B2; Thu, 26 Nov 2026 20:44:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2A45D6B05B0
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 20:44:51 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 719CC16018A
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 01:44:50 +0000 (UTC)
X-FDA: 85479205140.17.3FA136F
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010040.outbound.protection.outlook.com [52.101.193.40])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7D284140006
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 01:44:47 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b=MW15Q6Gy;
	spf=pass (imf09.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.193.40 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795743887;
	b=MQr/n/qporT/11049CdtCvTtvSftsKnBfcd1SQf/mLrvUTUZ9EUYSLsXd0RFgvPchei4ar
	7zYGmuf2lptduQ9njMazxidOybtidD7M7VT9heDBArfP8i6qL8KKoLJ39CLvlK7R2Qkay7
	TXdBRA7/8aQkcay4uCK3KtNi3Qe2Ocg=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795743887;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=F6FgnRBBIbwrxI4lwGo1aMAXJbw7ZwYULsoHw6m/0/Y=;
	b=ZxsF1WyYqLqpmx2ZVI+M8q3FlqIV9oZ0ckZ+IJZ/vsDilQjEghulKKik21j5/fA/6EDOBF
	UlIDRrbDE/R9hwShtU3IGesq1ktHOBFjn6pMnh1NxtUh7qp5/mZRkhaVvP4yhadqX67VCK
	u3ieIGp+HMgI6Nve5lBtwa3QgB/p9xQ=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b=MW15Q6Gy;
	spf=pass (imf09.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.193.40 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YkaTKVFfPxSkUdJ0arl3Ge/s3iHRZm5O4zTiGWzU4WibQE+wtBAc0ZvHby1ySVRqNnKt8HB1dASJ6HzgvOsB1NhcxskWlynJ8kkAzNO3u9z2lMswsoWcy+21HySt3LxS9yc/V+NEfeVai4WbMXwMJPalUbzwc1OSCCySuZmyQA56oixPjyCvLCZVcwcgL0mQJD8wW/KORKBWD9BqdvZ6762Q8SQjXnpFod7rkJddMBNkilmri7+vf7FsA1mPDoX5AJ6yknOK3uMWHycR+sOs2roTHzOi8VWKDmG9pytbWh86QQrivj6fMj2fYjwG863tFxKuz+GobVYYtHyPw7duBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F6FgnRBBIbwrxI4lwGo1aMAXJbw7ZwYULsoHw6m/0/Y=;
 b=MAFTr1OoF6fX7ovyoSFdNxqPcgBtN14eEq/zfozgTujPiBxIb3b6lSY7H3iejnFfyrsFO0NxGOegb8Cj/XxRx0Jbm3plr178QUdIIYDExJydz+KjTwGDjUxiRI5Ds9qVKpafY0VCLtHnByDvgc2n1mG8Qgds1YUVN4WwbG3lupr3skxH1Txa012u41KSxnKrmzeOGE9SeZqYQqlDlDKeZ2jpgNrjv+ilso9G+T66CSkC1MxDLZkvmcfjxe0422mgU2792AkWDWpTfIFV3N8tteSX/kwLOB8GLNIrtQbcxizQlm/qK8b8BAjPkycKl9lnTuVnJ1xIQekrv5grqPj/lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F6FgnRBBIbwrxI4lwGo1aMAXJbw7ZwYULsoHw6m/0/Y=;
 b=MW15Q6Gy1Co7qIGTH+ViWskLvT9qi08I29aTG5/NrvYtuxmv4ZHu23unwXj3ofo4kr/FwdpYsfPw1eTOer8oYOslocoU8x01bESUP20/XCvXU//UBqqGJ4iM3/tmA42/7z4bGEjsBEuy30rL5nYgd4/BdbiscLnxSLTi34pN8+DkriDt08Oa7y3uM5TmU6Crpl3q1tSjObjOO7wqh7yWFNWn/g1XpSR/vtZYHOY08jZTghw1OQ2zg8xdNCjVVjHuxNu0HSPgtNw9qRn87jOYnE50Ey5A6gMlM+W0O3L7qw/yqw9A0R0+0foY9EGRvKL3Fhl6kQL7i7gZcj9RtqyXeQ==
Received: from CH3PR12MB9730.namprd12.prod.outlook.com (2603:10b6:610:253::9)
 by PH7PR12MB6491.namprd12.prod.outlook.com (2603:10b6:510:1f4::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.7; Fri, 27 Nov
 2026 01:44:40 +0000
Received: from CH3PR12MB9730.namprd12.prod.outlook.com
 ([fe80::843d:c1f0:b2ed:4128]) by CH3PR12MB9730.namprd12.prod.outlook.com
 ([fe80::843d:c1f0:b2ed:4128%4]) with mapi id 15.21.0662.007; Fri, 27 Nov 2026
 01:44:40 +0000
From: Balbir Singh <balbirs@nvidia.com>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Balbir Singh <balbirs@nvidia.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>
Subject: [PATCH v2] selftests/mm: move the HMM migration benchmark to tools/mm
Date: Fri, 27 Nov 2026 12:44:30 +1100
Message-ID: <20261127014430.2043154-1-balbirs@nvidia.com>
X-Mailer: git-send-email 2.56.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MEWPR01CA0203.ausprd01.prod.outlook.com
 (2603:10c6:220:1ee::11) To CH3PR12MB9730.namprd12.prod.outlook.com
 (2603:10b6:610:253::9)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9730:EE_|PH7PR12MB6491:EE_
X-MS-Office365-Filtering-Correlation-Id: fbef4339-94be-4a46-3926-08df4c280080
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|7416014|6133799003|18002099003|3023799007|11063799006|260925022911599003|260925021911599003|260925021311599003|56012099006|261102130727099003|261022075727099003|261102123227099003|261021123027099003|261022105027099003|261021121427099003|261021135927099003|261026140227099003|261026121527099003|261028144727099003|261009223027099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	SheAx7ah/If4zkokkZazDWNN/7r/cWyUvO/bbITzkVzCbXgDdXizbiHAZzXxXAvySDgKYKT2MYRrdzUWzQzL4C4zqSYlDMleA5y7jXvNZiv24zNvW6XWr8ozw7RwC31MMcJMHPfw+0pNPAb2rYdqhNGw2fzlISiheDwiVuJVpj4kpBlixa4BgLWYvov8E07pPoDIBitCqedc8GkDURwLfiHieCEQD7n/YrUBPW2hot1bTk7pIRhJqwsAPukkTHeAN4an2dulL/AptxZU4alPENMp5W61RXp0fVXbgGFNA7ildNBcxJ42p5GEiQu/XQeOgAvpfCIEHiZ+MOFIcxatmrSi3LaK7N57pxYLIhdfmg//Mx4rhczcjJHCkDqYVUeMIzapdE00LjmKQW2s7DKU0W836Wn75pxRELkuhxZh9LAVwSw4DDYSUDCLR1FcL9Gt7BpEJe8rSVTU4Pq2zpmA5euOA2rU9DIQHI1e5A/uWx5YRoWUJ1i9WMURMU90JUpIJb7LQy5nTJcFm1QJz1ChMb2LNs8+SQ4e1fcMEau26Z4/fEHAxJ1NBk7BNMFl9OSSl2bdkzlulKeUVIXYaV29AaM7Lc443b7R7lN1JMvCed0voTh1Z4QDKM+C2fajhtiL3r8mLeoGp6ULSoBA6wpzP11Bm6Paj8O+KrtLOXFVJTQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9730.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(7416014)(6133799003)(18002099003)(3023799007)(11063799006)(260925022911599003)(260925021911599003)(260925021311599003)(56012099006)(261102130727099003)(261022075727099003)(261102123227099003)(261021123027099003)(261022105027099003)(261021121427099003)(261021135927099003)(261026140227099003)(261026121527099003)(261028144727099003)(261009223027099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?n3tj94Ks4YwI65J1wCVMB5JQ6AM4Ko7PZDNu8sJbRGq681D9nLM+EO/U0lr+?=
 =?us-ascii?Q?c7oHKO0vqQcrY2eD9Cad8UqaCAqqreUUCW02lZu5T910f4O5c47oGI2DuK5e?=
 =?us-ascii?Q?wbvKnxCt2KDtKplkT3oBaEKyYuA2nl0Tv4Nncu5ZL8O6nBptlUcLLndo6d4I?=
 =?us-ascii?Q?7cExwggT0U2F+/YkgqkPn2xziLaELff6qSrcv/KooJtDPgfy+tbJjIb8VcMI?=
 =?us-ascii?Q?uVSAw8hniw4160V+YxleSLhgug+wAEZ/gwbb4zlSMP6sQMYuMn5arXZZv+YT?=
 =?us-ascii?Q?E+1SUlAuoynQL/vc+tEjXYIu7VJAfeNlKAXRwEWiohAc22weY/iEWFkWBgJ0?=
 =?us-ascii?Q?PbPJOt1cpglfxzvI35WxrS7jzCVUOTpYvux6XzEUrAcbViLnFh5A9bna38GQ?=
 =?us-ascii?Q?N7T4l1oNnKdfenwKOtP3sAHMta+5eZDhBYQfPR7R9rFa7+7HJbeZuHsYpRzB?=
 =?us-ascii?Q?wlHz82CXO5xgVFq4jQ9cRXD/pDDpWGX7XMqNSQWxa/qzYNa0yLcPYiWihpgH?=
 =?us-ascii?Q?CVeiZbiTDGp3D7ulCrVax0o8o41IheWV/pkq+FIJCjC8itB9Km/Utd3w/MmI?=
 =?us-ascii?Q?SCbTX0Ks2ffGq06sB7BwNMaPKi4pjVsuUcT3nSwH872fe4oTfJpK747MF2CM?=
 =?us-ascii?Q?ooVFzOSC3L3WCmkQNb4Ezp7Y9iYrctvZwlTI1PeCITMX43ev9hClghqU2ufM?=
 =?us-ascii?Q?aklTrp+By2BP563hMSoHV4vPxrLoMgZ1n37Bo9cyXsOaA1/VFXXRiKLVdhYt?=
 =?us-ascii?Q?XljhvGM1PjLqAz/sLTX3XDX52QJ+iOgcUg1bkL324qnHST8HZGLeB6MBlaDO?=
 =?us-ascii?Q?gLY4uI3k/r35IeliNts4T+RTwBJ6rl7QLty1iLNfG+U8XYxtQF4eBkn07Rol?=
 =?us-ascii?Q?XPUrit0mmYF0HpcCP3DxX6TYSrb620Wz+as/jh/tXncLZFWK4sTRlbpb+FGc?=
 =?us-ascii?Q?yN/A1xXn9UBT56Wrd6NtZd1BkeU83ErtBYv/dH1pDhbdCLepVe7q55EtEWr8?=
 =?us-ascii?Q?QUOH/MDXHOrH0Nt0Xywh6QdOi39mXPXDXnxV2V0RQTVEBKrp5OrvCvwqF3YX?=
 =?us-ascii?Q?fjnxkvsu4Dpn2YJFae7Hi1aJy9Ru7f4VNqiLJqUdSqtdxlZgqi98vc32iiuK?=
 =?us-ascii?Q?sfFIGIqiSWQbb3YPJ++Z55VwBubDkM3Fsfo245CslYPAdeH6OJyP8ZsCzmy5?=
 =?us-ascii?Q?zb4go1vmjMkaMnYUzv7G3Is2njh3F6Jgp70y4aBTlfJV2CvYK1umKvWeBEUr?=
 =?us-ascii?Q?p2B8P2xSWdg2ajeHsTxpcUvM9kQ+Nv4eToI4cmfNfspxavxp4kUcPyzygtfV?=
 =?us-ascii?Q?Fnz4UP/qVDtVwwN5o/5XUzOMrFxEwPnFvKpGiMEHdZHhyZU1nuq1+vg/leLy?=
 =?us-ascii?Q?Mi5vBaBBwmqs47Axhhlb+kuqVRDkV4uusyWoR6EyznRDunt+xlpc2+UqxbqP?=
 =?us-ascii?Q?T7L+a95i3lJGZicQfPgrjhYj6/QiAQ56Jx5+v3UaVVpz2hL0qi1DbfZaHneP?=
 =?us-ascii?Q?r9YNQ51gfhVYiJHFlAYsQG98eLbIS8MDk3Hjw7jitShJ076BeaXSJqZ1FI1r?=
 =?us-ascii?Q?1a4nV9xW4cVfQV4tk1R3XoaDE16OSaHfQS+lNK1fxCbcKp6q8NcmRPYp2/ss?=
 =?us-ascii?Q?hv0cPSmzCZFX5TaCCyUWmt94ItzLV/6uiWNeo5lqSrbaHQ71bUf+DrYIEHXv?=
 =?us-ascii?Q?F8WLbTcxSWiWgyWMjPiCbw5iC/vpNslw0yNV/fLsGuBmtYtTIrb2fjNnKgUS?=
 =?us-ascii?Q?hObADN16Hw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbef4339-94be-4a46-3926-08df4c280080
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9730.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2026 01:44:40.3704
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZrPDRiRIFSbjxLVEMETj2Uvt4JlJ2UirDnk5gPP26qWbTjvW5SAY6DhNKku6wXDFDZcIN24KaHqT03Q10Lfmcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6491
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7D284140006
X-Rspam-User:
X-Stat-Signature: ebch17zu4xf3wnjfk87h3xzzezigthdf
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795743887-416947
X-HE-Meta: U2FsdGVkX1/swmLIe5bxjmSL1UXVsxjO7IBYZhH1YHj71PQdENnuJTxGlnJR/DdfjnnOEnRvKUahmS9marHBP3JLIr0VWe1kREes1xjXmzyARi6HLznkSFV9F9V+LbpBpxf2NVMMft8s2p7EHtjlGhNB7yg4dd47IVWbjUsOuQnHGXBuLeo5RedZL6JipVdzZsRFgjbna87evK9yC4mGRkFvZYyrsCZmqJivvCo4HXGaDRJbUj7QVlu4bG2ERoNZEcJaZb3RHbu39y/gFNujpE3rPXKsqDmcd6MDpR1cYK4t3JHC9bSteQ05ZxfekdeQy+q+nEJZs5kPSgMs2p5I7+s3NPjfgBTy2+PxlLr976hhd++fFMWxOuEPxbj4y2eFvBfyO25UHyMVBqO+p0sHaKXuAzscujWMmxu4pR8A1ub4+v/fH211frWObRh/IbBbwKr/h3zCcx61vZRLud19m1ouJ+HGKSl1U9d7u8O4dDsfb4EHR5a1JTmpfBfl/29Cbkyau721kxrcflcamxl4Qi1nqChdgMC942q/stCaOvsu+fdo3cWsHyVz5Pn62eYMTp6J2uYagmJqg6lVWVR7B+vzhZuG5m8koer1P+0/lVSVOPEBKbf/CldmsOel+iKC6TMBhHFSrbxZns2RYcxbBa+0ksroWhiWYeT8Iqlu1jx6GpKrwYebN0dwVUTWMH8gX8qHJI4o9IkMwsycOkBitB18NYzL5s5fS9RHjz3eP+QJXVsAj0acAM2p098C+ULic2eCfi8PRr4J2xRw+rDMdOmo0vBv2mPVuRf0ret239DnXxgR36k/oiotkhw3D5UJbN+FpToUtlD2xgvtb6DTlctq87cAYQ+GW3s52GD956TwjZ120Y+NExP3Wa2dH1lOYs+e3MjtGIlbCgeaf+1/KLSQQ/DQoROFZYIVwJ8cz9rRHBKTGUpzw+oE9IBN75aTE84noVx7k5Ipqf1RX+G
 MTuh7beG
 D3Pv0HZLAU894+sgQUiWEzffu48dc3W/vNaYeZd2j6RVRwE9MQMzNxPWzKvQQ4oXQB1yRtuROdUMjchVLhI9adXmJYVO4En0fChWG1atgDa3JTgaGG+BdQdsYNPOhtbOfRgXfdJ5gSygnEIqajF2xOOafCCh8lM8DBysO7Pk9RsV2+HScfc8S/WFI5pxzFNdF8wOjtBB2gvswh5j4AtLTmBEaNOfHnaOiU2JnYSICUPLVxbpMWqu/Qd9PmFQTgDvPQb0NiDhIAZf164+p3/qDW3zEIEVRAQiP6ArD0b3ijn/bohwKkFtbsdT0kXqXl+9mPqhKe4uI3FkpEsemMIfpUq6q2Q8+ZIwa/Wq+NtAE13yIqhUw7oVbjD4JoclAiV5UcETe5P8yopIYr55ZFgv7usnWmLt+HneGiHyOC1cFJ4GTOZIBTaFU7A0AWsrbfIvYmzCRYmzSBGntYcpFGNwdEFhBITy41SWrwullfvH022QqWHKj84u9FPIZSq3DE2/EAFObxmkjk0B28uDXT5pcbyzfGG6hDwftAI4ikVxGIlD0RFikuWWqy8cU0yZVYfdyr+wa0TeZ8uTm69kJC3c+SNv2+5LSYmgm9R2gK0Vp0jeDTuUJrJUSM+0fXsGVgo7IpScPki/hKJmMAl3yEiUynUTIU/toSXTLLE6+nK4t/Vho+r+glnljwNG+u52bIdlWlKmuyDfSCvIzgeE+ddxwfmn6lEwy0BGMDme72+zGMeCmpS36GJGUkxtrRY2z0LCsUzVZYZTfkIqkAGoyCR5M2avOvMc/uhopBx1j7q6l/7e2rqT2Sw8SdXm2+zT7/3F8994X1GgFoAjf+zQ+KbKHkB7zxLfP4X0keaqTBDuQwVu5gKMugE+J712/0gvMvx0WiCAOszNSxiQ31868ur9L4uncAbBxKEAlZQp29BIannVzT7Q33+qWd7WZh54OjfOVKlOdRxpH3Gf8wUYXsbcNxRkQP4VS
 XXM/MBVh
 XP/LMxr3Ys0O7stivznaG7kupYJx0r955E8jpRKUH64=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The HMM selftest runs benchmark_thp_migration on every invocation.
The benchmark repeatedly migrates buffers in both directions to measure
latency and throughput with and without THP. Run it on demand so the
regular suite spends its time checking correctness.

Move the benchmark to tools/mm alongside gup_bench. Share the device
fixture, buffer helpers and migration ioctls with hmm-tests. To run it:

  make -C tools/mm hmm-bench
  sudo modprobe test_hmm
  sudo tools/mm/hmm-bench

Use a size_t index to match the word count when initializing the buffer.
Have make clean remove $(BUILD_TARGETS) so it picks up hmm-bench.
Like gup_bench, hmm-bench is installed in /usr/sbin by default.

The tools/mm build enables -Wextra, exposing a signedness warning in
detect_huge_zeropage(). Store the pread() result in ssize_t and cast it
to size_t for the buffer size check after verifying it is positive.

Drop the 128-PMD buffer to bound the amount of memory migrated in one
measurement. With 2 MiB PMDs, the largest buffer falls from 256 MiB to
16 MiB. The remaining sizes still cover buffers smaller than a PMD, a
single PMD and multiple PMDs, with and without MADV_HUGEPAGE.

Call fflush(stdout) after printing the results for each buffer size.
The kselftest harness ends the test child with _exit(0), so timing
results still buffered in stdout can be lost when output is redirected
to a file or pipe.

Link: https://lore.kernel.org/r/20261124215730.0f6adc9ad36c7abc623a1dde@linux-foundation.org
Link: https://lore.kernel.org/r/fba23668-add0-4787-b027-bfba1f66e090@kernel.org
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Balbir Singh <balbirs@nvidia.com>
---
Changes in v2:
- Move hmm-bench to tools/mm alongside gup_bench, as David suggested.
- Fix the signedness warning in detect_huge_zeropage() exposed by -Wextra.

On mm-everything-2026-11-24-10-33, hmm.hmm_device_private.migrate_fault
fails with -ENOENT on the second migration to the device. I reproduced
this in QEMU with the selftest binaries built before and after this
patch. In the same guest, both binaries pass with test_hmm built from
the parent of 5cbbd205947d ("lib/test_hmm: invalidate all mirrors on
device-private migration") and both fail with test_hmm from that commit.

 MAINTAINERS                             |   1 +
 tools/mm/.gitignore                     |   1 +
 tools/mm/Makefile                       |  15 +-
 tools/mm/hmm-bench.c                    | 192 ++++++++++++
 tools/testing/selftests/mm/Makefile     |   1 +
 tools/testing/selftests/mm/hmm-common.h | 202 +++++++++++++
 tools/testing/selftests/mm/hmm-tests.c  | 384 +-----------------------
 tools/testing/selftests/mm/vm_util.c    |   4 +-
 8 files changed, 412 insertions(+), 388 deletions(-)
 create mode 100644 tools/mm/hmm-bench.c
 create mode 100644 tools/testing/selftests/mm/hmm-common.h

diff --git a/MAINTAINERS b/MAINTAINERS
index e02fef18972d..11666eb9565a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12199,6 +12199,7 @@ F:	Documentation/mm/hmm.rst
 F:	include/linux/hmm*
 F:	lib/test_hmm*
 F:	mm/hmm*
+F:	tools/mm/hmm-bench.c
 F:	tools/testing/selftests/mm/*hmm*
 
 HONEYWELL ABP2030PA PRESSURE SENSOR SERIES IIO DRIVER
diff --git a/tools/mm/.gitignore b/tools/mm/.gitignore
index 2d08f713b664..97e77de81f29 100644
--- a/tools/mm/.gitignore
+++ b/tools/mm/.gitignore
@@ -5,4 +5,5 @@ page_owner_sort
 page_owner_filter
 thp_swap_allocator_test
 gup_bench
+hmm-bench
 memory-failure/hwpoison-panic
diff --git a/tools/mm/Makefile b/tools/mm/Makefile
index c9a5bf234070..1f9c16e15c5a 100644
--- a/tools/mm/Makefile
+++ b/tools/mm/Makefile
@@ -4,13 +4,19 @@
 include ../scripts/Makefile.include
 
 BUILD_TARGETS=page-types slabinfo page_owner_sort page_owner_filter
-BUILD_TARGETS += thp_swap_allocator_test gup_bench
+BUILD_TARGETS += thp_swap_allocator_test gup_bench hmm-bench
 BUILD_TARGETS+=memory-failure/hwpoison-panic
 INSTALL_TARGETS = $(BUILD_TARGETS) thpmaps
 
 LIB_DIR = ../lib/api
 LIBS = $(LIB_DIR)/libapi.a
 GUP_BENCH_OBJS = gup_bench.c ../lib/mm/hugepage_settings.c ../lib/mm/file_utils.c
+SELFTESTS = ../testing/selftests
+HMM_BENCH_SRCS = hmm-bench.c $(SELFTESTS)/mm/vm_util.c \
+		 ../lib/mm/hugepage_settings.c ../lib/mm/file_utils.c
+HMM_BENCH_HDRS = $(SELFTESTS)/mm/hmm-common.h $(SELFTESTS)/mm/vm_util.h \
+		 $(SELFTESTS)/kselftest_harness.h $(SELFTESTS)/kselftest.h \
+		 ../../lib/test_hmm_uapi.h ../lib/mm/hugepage_settings.h ../lib/mm/file_utils.h
 
 CFLAGS += -Wall -Wextra -I../lib/ -I../.. -pthread
 LDFLAGS += $(LIBS) -pthread
@@ -28,9 +34,12 @@ $(LIBS):
 gup_bench: $(GUP_BENCH_OBJS) $(LIBS)
 	$(CC) $(CFLAGS) -o $@ $(GUP_BENCH_OBJS) $(LDFLAGS)
 
+hmm-bench: $(HMM_BENCH_SRCS) $(HMM_BENCH_HDRS)
+	$(CC) $(CFLAGS) -D_GNU_SOURCE -I$(SELFTESTS) -isystem ../include/uapi \
+		-o $@ $(HMM_BENCH_SRCS) $(LDFLAGS)
+
 clean:
-	$(RM) page-types slabinfo page_owner_sort page_owner_filter thp_swap_allocator_test gup_bench
-	$(RM) memory-failure/hwpoison-panic
+	$(RM) $(BUILD_TARGETS)
 	make -C $(LIB_DIR) clean
 
 sbindir ?= /usr/sbin
diff --git a/tools/mm/hmm-bench.c b/tools/mm/hmm-bench.c
new file mode 100644
index 000000000000..ee23d8875e8c
--- /dev/null
+++ b/tools/mm/hmm-bench.c
@@ -0,0 +1,192 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <limits.h>
+#include <sys/time.h>
+#include <mm/hmm-common.h>
+
+struct benchmark_results {
+	double sys_to_dev_time;
+	double dev_to_sys_time;
+	double throughput_s2d;
+	double throughput_d2s;
+};
+
+static double get_time_ms(void)
+{
+	struct timeval tv;
+
+	gettimeofday(&tv, NULL);
+	return (tv.tv_sec * 1000.0) + (tv.tv_usec / 1000.0);
+}
+
+static void print_benchmark_results(const char *test_name, size_t buffer_size,
+				     struct benchmark_results *thp,
+				     struct benchmark_results *regular)
+{
+	double s2d_improvement = ((regular->sys_to_dev_time - thp->sys_to_dev_time) /
+				 regular->sys_to_dev_time) * 100.0;
+	double d2s_improvement = ((regular->dev_to_sys_time - thp->dev_to_sys_time) /
+				 regular->dev_to_sys_time) * 100.0;
+	double throughput_s2d_improvement = ((thp->throughput_s2d - regular->throughput_s2d) /
+					    regular->throughput_s2d) * 100.0;
+	double throughput_d2s_improvement = ((thp->throughput_d2s - regular->throughput_d2s) /
+					    regular->throughput_d2s) * 100.0;
+
+	printf("\n=== %s (%.1f MB) ===\n", test_name, buffer_size / (1024.0 * 1024.0));
+	printf("                     | With THP        | Without THP     | Improvement\n");
+	printf("---------------------------------------------------------------------\n");
+	printf("Sys->Dev Migration   | %.3f ms        | %.3f ms        | %.1f%%\n",
+	       thp->sys_to_dev_time, regular->sys_to_dev_time, s2d_improvement);
+	printf("Dev->Sys Migration   | %.3f ms        | %.3f ms        | %.1f%%\n",
+	       thp->dev_to_sys_time, regular->dev_to_sys_time, d2s_improvement);
+	printf("S->D Throughput      | %.2f GB/s      | %.2f GB/s      | %.1f%%\n",
+	       thp->throughput_s2d, regular->throughput_s2d, throughput_s2d_improvement);
+	printf("D->S Throughput      | %.2f GB/s      | %.2f GB/s      | %.1f%%\n",
+	       thp->throughput_d2s, regular->throughput_d2s, throughput_d2s_improvement);
+	fflush(stdout);
+}
+
+/*
+ * Run a single migration benchmark
+ * fd: file descriptor for hmm device
+ * use_thp: whether to use THP
+ * buffer_size: size of buffer to allocate
+ * iterations: number of iterations
+ * results: where to store results
+ */
+static inline int run_migration_benchmark(int fd, int use_thp, size_t buffer_size,
+					   int iterations, struct benchmark_results *results)
+{
+	struct hmm_buffer *buffer;
+	unsigned long npages = buffer_size / sysconf(_SC_PAGESIZE);
+	double start, end;
+	double s2d_total = 0, d2s_total = 0;
+	size_t word;
+	int ret, i;
+	int *ptr;
+
+	buffer = hmm_buffer_alloc(buffer_size, buffer_size,
+				  PROT_READ | PROT_WRITE,
+				  MAP_PRIVATE | MAP_ANONYMOUS, -1);
+	if (!buffer) {
+		ret = -1;
+		goto cleanup;
+	}
+	memset(buffer->mirror, 0xFF, buffer_size);
+
+	/* Apply THP hint if requested */
+	if (use_thp)
+		ret = madvise(buffer->ptr, buffer_size, MADV_HUGEPAGE);
+	else
+		ret = madvise(buffer->ptr, buffer_size, MADV_NOHUGEPAGE);
+
+	if (ret)
+		goto cleanup;
+
+	/* Initialize memory to make sure pages are allocated */
+	ptr = (int *)buffer->ptr;
+	for (word = 0; word < buffer_size / sizeof(*ptr); word++)
+		ptr[word] = word & 0xFF;
+
+	/* Warmup iteration */
+	ret = hmm_migrate_sys_to_dev(fd, buffer, npages);
+	if (ret)
+		goto cleanup;
+
+	ret = hmm_migrate_dev_to_sys(fd, buffer, npages);
+	if (ret)
+		goto cleanup;
+
+	/* Benchmark iterations */
+	for (i = 0; i < iterations; i++) {
+		/* System to device migration */
+		start = get_time_ms();
+
+		ret = hmm_migrate_sys_to_dev(fd, buffer, npages);
+		if (ret)
+			goto cleanup;
+
+		end = get_time_ms();
+		s2d_total += (end - start);
+
+		/* Device to system migration */
+		start = get_time_ms();
+
+		ret = hmm_migrate_dev_to_sys(fd, buffer, npages);
+		if (ret)
+			goto cleanup;
+
+		end = get_time_ms();
+		d2s_total += (end - start);
+	}
+
+	/* Calculate average times and throughput */
+	results->sys_to_dev_time = s2d_total / iterations;
+	results->dev_to_sys_time = d2s_total / iterations;
+	results->throughput_s2d = (buffer_size / (1024.0 * 1024.0 * 1024.0)) /
+				 (results->sys_to_dev_time / 1000.0);
+	results->throughput_d2s = (buffer_size / (1024.0 * 1024.0 * 1024.0)) /
+				 (results->dev_to_sys_time / 1000.0);
+
+cleanup:
+	hmm_buffer_free(buffer);
+	return ret;
+}
+
+/*
+ * Benchmark THP migration with different buffer sizes
+ */
+TEST_F_TIMEOUT(hmm, benchmark_thp_migration, 120)
+{
+	struct benchmark_results thp_results, regular_results;
+	size_t thp_size = pmd_psize();
+	int iterations = 5;
+
+	if (!thp_size)
+		thp_size = TWOMEG;
+
+	printf("\nHMM THP Migration Benchmark\n");
+	printf("---------------------------\n");
+	printf("System page size: %ld bytes\n", sysconf(_SC_PAGESIZE));
+
+	/* Test different buffer sizes */
+	size_t test_sizes[] = {
+		thp_size / 4,      /* quarter THP */
+		thp_size / 2,      /* half THP */
+		thp_size,          /* single THP */
+		thp_size * 2,      /* two THPs */
+		thp_size * 4,      /* four THPs */
+		thp_size * 8,      /* eight THPs */
+	};
+
+	static const char *const test_names[] = {
+		"Small Buffer",
+		"Half THP Size",
+		"Single THP Size",
+		"Two THP Size",
+		"Four THP Size",
+		"Eight THP Size",
+	};
+
+	int num_tests = ARRAY_SIZE(test_sizes);
+
+	/* Run all tests */
+	for (int i = 0; i < num_tests; i++) {
+		/* Skip test sizes exceeding INT_MAX to avoid overflow */
+		if (test_sizes[i] > INT_MAX)
+			break;
+
+		/* Test with THP */
+		ASSERT_EQ(run_migration_benchmark(self->fd, 1, test_sizes[i],
+					iterations, &thp_results), 0);
+
+		/* Test without THP */
+		ASSERT_EQ(run_migration_benchmark(self->fd, 0, test_sizes[i],
+					iterations, &regular_results), 0);
+
+		/* Print results */
+		print_benchmark_results(test_names[i], test_sizes[i],
+					&thp_results, &regular_results);
+	}
+}
+
+TEST_HARNESS_MAIN
diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index 675ec57d47de..c129ac2c635a 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -6,6 +6,7 @@
 # If you do not YOUR TESTS WILL NOT RUN IN THE CI.
 
 LOCAL_HDRS += $(selfdir)/mm/local_config.h_gen $(top_srcdir)/mm/gup_test.h
+LOCAL_HDRS += $(selfdir)/mm/hmm-common.h
 LOCAL_HDRS += $(selfdir)/mm/mseal_helpers.h
 
 include local_config.mk
diff --git a/tools/testing/selftests/mm/hmm-common.h b/tools/testing/selftests/mm/hmm-common.h
new file mode 100644
index 000000000000..838d496b35fb
--- /dev/null
+++ b/tools/testing/selftests/mm/hmm-common.h
@@ -0,0 +1,202 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef HMM_COMMON_H
+#define HMM_COMMON_H
+
+#include <errno.h>
+#include <fcntl.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <stdint.h>
+#include <unistd.h>
+#include <strings.h>
+#include <sys/ioctl.h>
+#include <sys/mman.h>
+#include "kselftest_harness.h"
+#include <mm/vm_util.h>
+
+/*
+ * This is a private UAPI to the kernel test module so it isn't exported
+ * in the usual include/uapi/... directory.
+ */
+#include <lib/test_hmm_uapi.h>
+
+struct hmm_buffer {
+	void		*ptr;
+	void		*mirror;
+	unsigned long	size;
+	int		fd;
+	uint64_t	cpages;
+	uint64_t	faults;
+};
+
+enum {
+	HMM_PRIVATE_DEVICE_ONE,
+	HMM_PRIVATE_DEVICE_TWO,
+	HMM_COHERENCE_DEVICE_ONE,
+	HMM_COHERENCE_DEVICE_TWO,
+};
+
+#define TWOMEG		(1 << 21)
+#define HMM_PATH_MAX    64
+
+FIXTURE(hmm)
+{
+	int		fd;
+	unsigned int	page_size;
+	unsigned int	page_shift;
+};
+
+FIXTURE_VARIANT(hmm)
+{
+	int     device_number;
+};
+
+FIXTURE_VARIANT_ADD(hmm, hmm_device_private)
+{
+	.device_number = HMM_PRIVATE_DEVICE_ONE,
+};
+
+FIXTURE_VARIANT_ADD(hmm, hmm_device_coherent)
+{
+	.device_number = HMM_COHERENCE_DEVICE_ONE,
+};
+
+static int hmm_open(int unit)
+{
+	char pathname[HMM_PATH_MAX];
+	int fd;
+
+	snprintf(pathname, sizeof(pathname), "/dev/hmm_dmirror%d", unit);
+	fd = open(pathname, O_RDWR, 0);
+	if (fd < 0)
+		fprintf(stderr, "could not open hmm dmirror driver (%s)\n",
+			pathname);
+	return fd;
+}
+
+static bool hmm_is_coherent_type(int dev_num)
+{
+	return (dev_num >= HMM_COHERENCE_DEVICE_ONE);
+}
+
+FIXTURE_SETUP(hmm)
+{
+	self->page_size = sysconf(_SC_PAGE_SIZE);
+	self->page_shift = ffs(self->page_size) - 1;
+
+	self->fd = hmm_open(variant->device_number);
+	if (self->fd < 0 && hmm_is_coherent_type(variant->device_number))
+		SKIP(return, "DEVICE_COHERENT not available");
+	ASSERT_GE(self->fd, 0);
+}
+
+FIXTURE_TEARDOWN(hmm)
+{
+	int ret = close(self->fd);
+
+	ASSERT_EQ(ret, 0);
+	self->fd = -1;
+}
+
+static int hmm_dmirror_cmd(int fd,
+			   unsigned long request,
+			   struct hmm_buffer *buffer,
+			   unsigned long npages)
+{
+	struct hmm_dmirror_cmd cmd;
+	int ret;
+
+	/* Simulate a device reading system memory. */
+	cmd.addr = ptr_to_u64(buffer->ptr);
+	cmd.ptr = ptr_to_u64(buffer->mirror);
+	cmd.npages = npages;
+
+	for (;;) {
+		ret = ioctl(fd, request, &cmd);
+		if (ret == 0)
+			break;
+		if (errno == EINTR)
+			continue;
+		return -errno;
+	}
+	buffer->cpages = cmd.cpages;
+	buffer->faults = cmd.faults;
+
+	return 0;
+}
+
+static void hmm_buffer_free(struct hmm_buffer *buffer)
+{
+	if (buffer == NULL)
+		return;
+
+	if (buffer->ptr) {
+		munmap(buffer->ptr, buffer->size);
+		buffer->ptr = NULL;
+	}
+	free(buffer->mirror);
+	free(buffer);
+}
+
+/*
+ * Allocate a buffer structure with memory mapping and mirror.
+ *
+ * @mmap_size:   total size of the mmap region (may differ from @mirror_size
+ *               for alignment padding in THP tests).
+ * @mirror_size: size of the mirror data buffer (the actual working set).
+ * @prot:        protection flags for the mmap (e.g. PROT_READ | PROT_WRITE).
+ * @flags:       flags for the mmap (e.g. MAP_PRIVATE, MAP_SHARED,
+ *               MAP_ANONYMOUS, MAP_HUGETLB).
+ * @fd:          file descriptor for the mmap; pass -1 for MAP_ANONYMOUS.
+ *
+ * All internal allocations are checked; returns NULL and cleans up on any
+ * failure. Caller must ASSERT_NE or otherwise check the return value.
+ */
+static struct hmm_buffer *hmm_buffer_alloc(unsigned long mmap_size,
+						unsigned long mirror_size,
+						int prot, int flags,
+						int fd)
+{
+	struct hmm_buffer *buffer;
+
+	buffer = malloc(sizeof(*buffer));
+	if (!buffer) {
+		perror("malloc buffer");
+		return NULL;
+	}
+
+	buffer->fd = fd;
+	buffer->size = mmap_size;
+	buffer->mirror = malloc(mirror_size);
+	if (!buffer->mirror) {
+		perror("malloc mirror");
+		free(buffer);
+		return NULL;
+	}
+
+	buffer->ptr = mmap(NULL, mmap_size, prot, flags, fd, 0);
+	if (buffer->ptr == MAP_FAILED) {
+		perror("mmap");
+		free(buffer->mirror);
+		free(buffer);
+		return NULL;
+	}
+
+	return buffer;
+}
+
+static int hmm_migrate_sys_to_dev(int fd,
+				   struct hmm_buffer *buffer,
+				   unsigned long npages)
+{
+	return hmm_dmirror_cmd(fd, HMM_DMIRROR_MIGRATE_TO_DEV, buffer, npages);
+}
+
+static int hmm_migrate_dev_to_sys(int fd,
+				   struct hmm_buffer *buffer,
+				   unsigned long npages)
+{
+	return hmm_dmirror_cmd(fd, HMM_DMIRROR_MIGRATE_TO_SYS, buffer, npages);
+}
+
+#endif /* HMM_COMMON_H */
diff --git a/tools/testing/selftests/mm/hmm-tests.c b/tools/testing/selftests/mm/hmm-tests.c
index fb46a3be8687..ed7aa96a404a 100644
--- a/tools/testing/selftests/mm/hmm-tests.c
+++ b/tools/testing/selftests/mm/hmm-tests.c
@@ -10,59 +10,22 @@
  * bugs.
  */
 
-#include <errno.h>
-#include <fcntl.h>
-#include <stdio.h>
-#include <stdlib.h>
-#include <stdint.h>
-#include <unistd.h>
-#include <strings.h>
 #include <time.h>
 #include <pthread.h>
-#include <limits.h>
 #include <linux/mman.h>
 #include <sys/types.h>
 #include <sys/stat.h>
-#include <sys/mman.h>
-#include <sys/ioctl.h>
-#include <sys/time.h>
 #include <sys/syscall.h>
 #include <sys/eventfd.h>
 #include <linux/userfaultfd.h>
 #include <poll.h>
 #include <mm/hugepage_settings.h>
-
-#include "kselftest_harness.h"
-
-/*
- * This is a private UAPI to the kernel test module so it isn't exported
- * in the usual include/uapi/... directory.
- */
-#include <lib/test_hmm_uapi.h>
 #include <mm/gup_test.h>
-#include <mm/vm_util.h>
-
-struct hmm_buffer {
-	void		*ptr;
-	void		*mirror;
-	unsigned long	size;
-	int		fd;
-	uint64_t	cpages;
-	uint64_t	faults;
-};
-
-enum {
-	HMM_PRIVATE_DEVICE_ONE,
-	HMM_PRIVATE_DEVICE_TWO,
-	HMM_COHERENCE_DEVICE_ONE,
-	HMM_COHERENCE_DEVICE_TWO,
-};
+#include "hmm-common.h"
 
 #define ONEKB		(1 << 10)
 #define ONEMEG		(1 << 20)
-#define TWOMEG		(1 << 21)
 #define HMM_BUFFER_SIZE (1024 << 12)
-#define HMM_PATH_MAX    64
 #define NTIMES		10
 
 /* Just the flags we need, copied from mm.h: */
@@ -77,28 +40,6 @@ enum {
 
 HUGETLB_SETUP_DEFAULT_PAGES(1)
 
-FIXTURE(hmm)
-{
-	int		fd;
-	unsigned int	page_size;
-	unsigned int	page_shift;
-};
-
-FIXTURE_VARIANT(hmm)
-{
-	int     device_number;
-};
-
-FIXTURE_VARIANT_ADD(hmm, hmm_device_private)
-{
-	.device_number = HMM_PRIVATE_DEVICE_ONE,
-};
-
-FIXTURE_VARIANT_ADD(hmm, hmm_device_coherent)
-{
-	.device_number = HMM_COHERENCE_DEVICE_ONE,
-};
-
 FIXTURE(hmm2)
 {
 	int		fd0;
@@ -125,35 +66,6 @@ FIXTURE_VARIANT_ADD(hmm2, hmm2_device_coherent)
 	.device_number1 = HMM_COHERENCE_DEVICE_TWO,
 };
 
-static int hmm_open(int unit)
-{
-	char pathname[HMM_PATH_MAX];
-	int fd;
-
-	snprintf(pathname, sizeof(pathname), "/dev/hmm_dmirror%d", unit);
-	fd = open(pathname, O_RDWR, 0);
-	if (fd < 0)
-		fprintf(stderr, "could not open hmm dmirror driver (%s)\n",
-			pathname);
-	return fd;
-}
-
-static bool hmm_is_coherent_type(int dev_num)
-{
-	return (dev_num >= HMM_COHERENCE_DEVICE_ONE);
-}
-
-FIXTURE_SETUP(hmm)
-{
-	self->page_size = sysconf(_SC_PAGE_SIZE);
-	self->page_shift = ffs(self->page_size) - 1;
-
-	self->fd = hmm_open(variant->device_number);
-	if (self->fd < 0 && hmm_is_coherent_type(variant->device_number))
-		SKIP(return, "DEVICE_COHERENT not available");
-	ASSERT_GE(self->fd, 0);
-}
-
 FIXTURE_SETUP(hmm2)
 {
 	self->page_size = sysconf(_SC_PAGE_SIZE);
@@ -167,14 +79,6 @@ FIXTURE_SETUP(hmm2)
 	ASSERT_GE(self->fd1, 0);
 }
 
-FIXTURE_TEARDOWN(hmm)
-{
-	int ret = close(self->fd);
-
-	ASSERT_EQ(ret, 0);
-	self->fd = -1;
-}
-
 FIXTURE_TEARDOWN(hmm2)
 {
 	int ret = close(self->fd0);
@@ -187,93 +91,6 @@ FIXTURE_TEARDOWN(hmm2)
 	self->fd1 = -1;
 }
 
-static int hmm_dmirror_cmd(int fd,
-			   unsigned long request,
-			   struct hmm_buffer *buffer,
-			   unsigned long npages)
-{
-	struct hmm_dmirror_cmd cmd;
-	int ret;
-
-	/* Simulate a device reading system memory. */
-	cmd.addr = ptr_to_u64(buffer->ptr);
-	cmd.ptr = ptr_to_u64(buffer->mirror);
-	cmd.npages = npages;
-
-	for (;;) {
-		ret = ioctl(fd, request, &cmd);
-		if (ret == 0)
-			break;
-		if (errno == EINTR)
-			continue;
-		return -errno;
-	}
-	buffer->cpages = cmd.cpages;
-	buffer->faults = cmd.faults;
-
-	return 0;
-}
-
-static void hmm_buffer_free(struct hmm_buffer *buffer)
-{
-	if (buffer == NULL)
-		return;
-
-	if (buffer->ptr) {
-		munmap(buffer->ptr, buffer->size);
-		buffer->ptr = NULL;
-	}
-	free(buffer->mirror);
-	free(buffer);
-}
-
-/*
- * Allocate a buffer structure with memory mapping and mirror.
- *
- * @mmap_size:   total size of the mmap region (may differ from @mirror_size
- *               for alignment padding in THP tests).
- * @mirror_size: size of the mirror data buffer (the actual working set).
- * @prot:        protection flags for the mmap (e.g. PROT_READ | PROT_WRITE).
- * @flags:       flags for the mmap (e.g. MAP_PRIVATE, MAP_SHARED,
- *               MAP_ANONYMOUS, MAP_HUGETLB).
- * @fd:          file descriptor for the mmap; pass -1 for MAP_ANONYMOUS.
- *
- * All internal allocations are checked; returns NULL and cleans up on any
- * failure. Caller must ASSERT_NE or otherwise check the return value.
- */
-static struct hmm_buffer *hmm_buffer_alloc(unsigned long mmap_size,
-						unsigned long mirror_size,
-						int prot, int flags,
-						int fd)
-{
-	struct hmm_buffer *buffer;
-
-	buffer = malloc(sizeof(*buffer));
-	if (!buffer) {
-		perror("malloc buffer");
-		return NULL;
-	}
-
-	buffer->fd = fd;
-	buffer->size = mmap_size;
-	buffer->mirror = malloc(mirror_size);
-	if (!buffer->mirror) {
-		perror("malloc mirror");
-		free(buffer);
-		return NULL;
-	}
-
-	buffer->ptr = mmap(NULL, mmap_size, prot, flags, fd, 0);
-	if (buffer->ptr == MAP_FAILED) {
-		perror("mmap");
-		free(buffer->mirror);
-		free(buffer);
-		return NULL;
-	}
-
-	return buffer;
-}
-
 /*
  * Create a temporary file that will be deleted on close.
  */
@@ -326,20 +143,6 @@ static void hmm_nanosleep(unsigned int n)
 	nanosleep(&t, NULL);
 }
 
-static int hmm_migrate_sys_to_dev(int fd,
-				   struct hmm_buffer *buffer,
-				   unsigned long npages)
-{
-	return hmm_dmirror_cmd(fd, HMM_DMIRROR_MIGRATE_TO_DEV, buffer, npages);
-}
-
-static int hmm_migrate_dev_to_sys(int fd,
-				   struct hmm_buffer *buffer,
-				   unsigned long npages)
-{
-	return hmm_dmirror_cmd(fd, HMM_DMIRROR_MIGRATE_TO_SYS, buffer, npages);
-}
-
 /*
  * Simple NULL test of device open/close.
  */
@@ -2475,191 +2278,6 @@ TEST_F(hmm, migrate_anon_huge_zero_err)
 	hmm_buffer_free(buffer);
 }
 
-struct benchmark_results {
-	double sys_to_dev_time;
-	double dev_to_sys_time;
-	double throughput_s2d;
-	double throughput_d2s;
-};
-
-static double get_time_ms(void)
-{
-	struct timeval tv;
-
-	gettimeofday(&tv, NULL);
-	return (tv.tv_sec * 1000.0) + (tv.tv_usec / 1000.0);
-}
-
-static void print_benchmark_results(const char *test_name, size_t buffer_size,
-				     struct benchmark_results *thp,
-				     struct benchmark_results *regular)
-{
-	double s2d_improvement = ((regular->sys_to_dev_time - thp->sys_to_dev_time) /
-				 regular->sys_to_dev_time) * 100.0;
-	double d2s_improvement = ((regular->dev_to_sys_time - thp->dev_to_sys_time) /
-				 regular->dev_to_sys_time) * 100.0;
-	double throughput_s2d_improvement = ((thp->throughput_s2d - regular->throughput_s2d) /
-					    regular->throughput_s2d) * 100.0;
-	double throughput_d2s_improvement = ((thp->throughput_d2s - regular->throughput_d2s) /
-					    regular->throughput_d2s) * 100.0;
-
-	printf("\n=== %s (%.1f MB) ===\n", test_name, buffer_size / (1024.0 * 1024.0));
-	printf("                     | With THP        | Without THP     | Improvement\n");
-	printf("---------------------------------------------------------------------\n");
-	printf("Sys->Dev Migration   | %.3f ms        | %.3f ms        | %.1f%%\n",
-	       thp->sys_to_dev_time, regular->sys_to_dev_time, s2d_improvement);
-	printf("Dev->Sys Migration   | %.3f ms        | %.3f ms        | %.1f%%\n",
-	       thp->dev_to_sys_time, regular->dev_to_sys_time, d2s_improvement);
-	printf("S->D Throughput      | %.2f GB/s      | %.2f GB/s      | %.1f%%\n",
-	       thp->throughput_s2d, regular->throughput_s2d, throughput_s2d_improvement);
-	printf("D->S Throughput      | %.2f GB/s      | %.2f GB/s      | %.1f%%\n",
-	       thp->throughput_d2s, regular->throughput_d2s, throughput_d2s_improvement);
-}
-
-/*
- * Run a single migration benchmark
- * fd: file descriptor for hmm device
- * use_thp: whether to use THP
- * buffer_size: size of buffer to allocate
- * iterations: number of iterations
- * results: where to store results
- */
-static inline int run_migration_benchmark(int fd, int use_thp, size_t buffer_size,
-					   int iterations, struct benchmark_results *results)
-{
-	struct hmm_buffer *buffer;
-	unsigned long npages = buffer_size / sysconf(_SC_PAGESIZE);
-	double start, end;
-	double s2d_total = 0, d2s_total = 0;
-	int ret, i;
-	int *ptr;
-
-	buffer = hmm_buffer_alloc(buffer_size, buffer_size,
-				  PROT_READ | PROT_WRITE,
-				  MAP_PRIVATE | MAP_ANONYMOUS, -1);
-	if (!buffer) {
-		ret = -1;
-		goto cleanup;
-	}
-	memset(buffer->mirror, 0xFF, buffer_size);
-
-	/* Apply THP hint if requested */
-	if (use_thp)
-		ret = madvise(buffer->ptr, buffer_size, MADV_HUGEPAGE);
-	else
-		ret = madvise(buffer->ptr, buffer_size, MADV_NOHUGEPAGE);
-
-	if (ret)
-		goto cleanup;
-
-	/* Initialize memory to make sure pages are allocated */
-	ptr = (int *)buffer->ptr;
-	for (i = 0; i < buffer_size / sizeof(int); i++)
-		ptr[i] = i & 0xFF;
-
-	/* Warmup iteration */
-	ret = hmm_migrate_sys_to_dev(fd, buffer, npages);
-	if (ret)
-		goto cleanup;
-
-	ret = hmm_migrate_dev_to_sys(fd, buffer, npages);
-	if (ret)
-		goto cleanup;
-
-	/* Benchmark iterations */
-	for (i = 0; i < iterations; i++) {
-		/* System to device migration */
-		start = get_time_ms();
-
-		ret = hmm_migrate_sys_to_dev(fd, buffer, npages);
-		if (ret)
-			goto cleanup;
-
-		end = get_time_ms();
-		s2d_total += (end - start);
-
-		/* Device to system migration */
-		start = get_time_ms();
-
-		ret = hmm_migrate_dev_to_sys(fd, buffer, npages);
-		if (ret)
-			goto cleanup;
-
-		end = get_time_ms();
-		d2s_total += (end - start);
-	}
-
-	/* Calculate average times and throughput */
-	results->sys_to_dev_time = s2d_total / iterations;
-	results->dev_to_sys_time = d2s_total / iterations;
-	results->throughput_s2d = (buffer_size / (1024.0 * 1024.0 * 1024.0)) /
-				 (results->sys_to_dev_time / 1000.0);
-	results->throughput_d2s = (buffer_size / (1024.0 * 1024.0 * 1024.0)) /
-				 (results->dev_to_sys_time / 1000.0);
-
-cleanup:
-	hmm_buffer_free(buffer);
-	return ret;
-}
-
-/*
- * Benchmark THP migration with different buffer sizes
- */
-TEST_F_TIMEOUT(hmm, benchmark_thp_migration, 120)
-{
-	struct benchmark_results thp_results, regular_results;
-	size_t thp_size = pmd_psize();
-	int iterations = 5;
-
-	if (!thp_size)
-		thp_size = TWOMEG;
-
-	printf("\nHMM THP Migration Benchmark\n");
-	printf("---------------------------\n");
-	printf("System page size: %ld bytes\n", sysconf(_SC_PAGESIZE));
-
-	/* Test different buffer sizes */
-	size_t test_sizes[] = {
-		thp_size / 4,      /* quarter THP */
-		thp_size / 2,      /* half THP */
-		thp_size,          /* single THP */
-		thp_size * 2,      /* two THPs */
-		thp_size * 4,      /* four THPs */
-		thp_size * 8,      /* eight THPs */
-		thp_size * 128,    /* one twenty eight THPs */
-	};
-
-	static const char *const test_names[] = {
-		"Small Buffer",
-		"Half THP Size",
-		"Single THP Size",
-		"Two THP Size",
-		"Four THP Size",
-		"Eight THP Size",
-		"One twenty eight THP Size"
-	};
-
-	int num_tests = ARRAY_SIZE(test_sizes);
-
-	/* Run all tests */
-	for (int i = 0; i < num_tests; i++) {
-		/* Skip test sizes exceeding INT_MAX to avoid overflow */
-		if (test_sizes[i] > INT_MAX)
-			break;
-
-		/* Test with THP */
-		ASSERT_EQ(run_migration_benchmark(self->fd, 1, test_sizes[i],
-					iterations, &thp_results), 0);
-
-		/* Test without THP */
-		ASSERT_EQ(run_migration_benchmark(self->fd, 0, test_sizes[i],
-					iterations, &regular_results), 0);
-
-		/* Print results */
-		print_benchmark_results(test_names[i], test_sizes[i],
-					&thp_results, &regular_results);
-	}
-}
 /*
  * Test that HMM can fault in pages backed by userfaultfd using the
  * hmm_range_fault_unlocked_timeout() path with no timeout. This exercises
diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index b5485326fa0b..9643058472fb 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -944,13 +944,13 @@ bool detect_huge_zeropage(void)
 		      O_RDONLY);
 	bool enabled = 0;
 	char buf[15];
-	int ret;
+	ssize_t ret;
 
 	if (fd < 0)
 		return 0;
 
 	ret = pread(fd, buf, sizeof(buf), 0);
-	if (ret > 0 && ret < sizeof(buf)) {
+	if (ret > 0 && (size_t)ret < sizeof(buf)) {
 		buf[ret] = 0;
 
 		if (strtoul(buf, NULL, 10) == 1)
-- 
2.56.1


