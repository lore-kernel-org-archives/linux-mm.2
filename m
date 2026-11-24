Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3AFE606A329
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 17:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=uHMnL/jr
Received: by kanga.kvack.org (Postfix)
	id CF27A6B0801; Tue, 24 Nov 2026 12:31:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCAE96B0803; Tue, 24 Nov 2026 12:31:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB82D6B0804; Tue, 24 Nov 2026 12:31:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 94E806B0801
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 12:31:45 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 28DD240C92
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 17:31:44 +0000 (UTC)
X-FDA: 85470704928.30.B3F5DF7
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013013.outbound.protection.outlook.com [40.107.201.13])
	by imf16.hostedemail.com (Postfix) with ESMTP id 32CAF180013
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 17:31:41 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b="uHMnL/jr";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.13 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795541501;
	b=XFoStOJpbGZihB9eZrlfaa8TLkwZU1mpAqSzV4ws9D0WnoySfJHGDH4EOMoaNMQCFgPRCs
	F9eCiVEWd4eudawAlllz5NVD1LvOtVR4AHjkc3qZ1rHHC/5yIZageRVypyqxlAiqa883Mb
	4FPjmMTK3+S8QJkPINqXWPvcQxv5IdE=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795541501;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dy5kX1aCdrvyNkM5BNtLn8+eP2PB7kblmaAnDwcJZxA=;
	b=yXUZUO/RrERJLnQQsnvHPY2SN7mvUg2IDCh3MKV6oLVCncjSOiTZDTlNf8ZVbZGn7gML/0
	tW+17Q/Ri2+F7nCPijILa6h5LuOWGjiyH3CZlIiRsExmQd+oo+5gbnOrZT+zbB3N6IauY2
	lifx+y6AASB1DouIH8R84voyhU5eu2o=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b="uHMnL/jr";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.13 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SM4+ah5ltwCiJ7hbV2kNEbPsIhbW9UenIz9OAi/1Fsua0sww4iN6FQN9wdv7dyUFEsqN1y7i6hsViViEY6BPiAnLtEiKjgaPb28rEnNKcHcyHYm4B+EMta7CbZXDGiVdDxtXPI7lvinPO2sM5vZMfWjBVvlqxoKJr3bT2qLvOesBfE+GHa3Bs7le8fqVGpZzUo0Uy1eu34xiv5niMHLfQi/Cp/nJHTx3yKPrY1Rc27TlJlsKAI6ONZfhjaP+KeRBdlBTuZYRCjrTiXwwZ79sQ0NUSpsjFkOdfJs0Tm3c6huxM3lUVNPSMC9K3dAcCqechSkUHZtTRvBXMJlojR51Lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dy5kX1aCdrvyNkM5BNtLn8+eP2PB7kblmaAnDwcJZxA=;
 b=qlAPlGujXti8GFdDWwwiw8utuDC8Y+SX9tDVxybTOJAv8SmNDbyd0D86d7KGkw+2xEibo0xRMAFAjLS2zbIL5DTnpMEG3YGW9HeGOd6IWSvXtIAiB83/qPRnCfmFYXxyM/2F3vv52xPy3diumRlPC9cap315zEWAg59fgFggWaQUWwC+xIa8YXBbblf738WeDoG3hNx9tvVBQ9YHh0d2bG/zB/wjOmrR9CqrwcmpI/tGvYbeDospS4KZflZMcByoHphPdE3sQ6vvQZAOM+FLqM9rFYuzFLNVxlIi0ffv4e4euVeg1CHXEgV8rbMdBw3yQiPT0i6ITzkJ0SL69dNA9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dy5kX1aCdrvyNkM5BNtLn8+eP2PB7kblmaAnDwcJZxA=;
 b=uHMnL/jrfWH/+zysoe+XbHV0Btg2hMuliLVrQyj44vZPjdVgmFitqsKg96q6Rgo4IP/44BeTYkzVOBKUEkC2LD+XLYRoDm3sy0Fx2iBV7Fg5XPfTsDMov61PxU7/W30OJkSXX5UfbmDyhYlXedyxumULyQFLOmmiAMRTSubiDerHUCfhq4LSlmnM3jqi+vH/pXsc7h4pBQm/CFfExw7ZLlykHKJrLv3bIxWHrwpOM7kUMcMmW989dKZ6lOH55abVhVimswSAF2nh5gD2U2tL9HgAqRBDXi0/vy1IAtNbVoEJGO0mboiFNke29vWKl85p/lZMo6f6PpA2drjZDi7LBA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by MN0PR12MB5858.namprd12.prod.outlook.com (2603:10b6:208:379::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.10; Tue, 24 Nov
 2026 17:31:24 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0639.012; Tue, 24 Nov 2026
 17:31:24 +0000
From: Zi Yan <ziy@nvidia.com>
To: Kairui Song <ryncsn@gmail.com>
Cc: kasong@tencent.com, linux-mm@kvack.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>,
 Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>,
 Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>,
 Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>,
 Gregory Price <gourry@gourry.net>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
 SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>,
 Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>,
 Zicheng Wang <wangzicheng@honor.com>, Tal Zussman <tz2294@columbia.edu>,
 Xiang Liu <liuxiang.277@bytedance.com>,
 Ehab Ababneh <ehab.ababneh@intel.com>,
 Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, Lian Wang <lianux.mm@gmail.com>,
 Joanne Koong <joannelkoong@gmail.com>, Kunwu Chan <kunwu.chan@gmail.com>,
 Hui Zhu <hui.zhu@linux.dev>, Maxim Muzafarov <maxmuzaf@gmail.com>,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, damon@lists.linux.dev,
 linux-doc@vger.kernel.org, Tianyi Chen <hi@tychen.cc>,
 Ridong Chen <ridong.chen@linux.dev>
Subject: Re: [PATCH v6 11/18] mm/mglru, smaps: convert to LRU refs based
 operations for MGLRU
Date: Tue, 24 Nov 2026 12:31:21 -0500
X-Mailer: MailMate (3.0r7038)
Message-ID: <EE0631DE-AA2D-414D-AB67-4C8790ECD64A@nvidia.com>
In-Reply-To: <awXIalgUrVIf5VP9@KASONG-MC4>
References: <20261124-mglru-fg-v6-0-8ffea39934a6@tencent.com>
 <20261124-mglru-fg-v6-11-8ffea39934a6@tencent.com>
 <DN2UPVW6W83J.I1S5XXQ2DPLV@nvidia.com> <awXIalgUrVIf5VP9@KASONG-MC4>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-MS-Reactions: disallow
X-ClientProxiedBy: MN0P223CA0004.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:52b::14) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|MN0PR12MB5858:EE_
X-MS-Office365-Filtering-Correlation-Id: 499412d7-41c2-4ac1-911d-08df4a50c33d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|376014|366016|23010399003|261102123227099003|261026140227099003|261026121527099003|261021121427099003|11063799006|261022105027099003|4143699003|261022075727099003|56012099006|261028144727099003|10067099003|261009223027099003|261021123027099003|8126099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	jxCVHCtfezRq4strxkEUZ+1N7yD72LZak1Hw1+Syxx/Chkll7onOvteYWUDI9qjT/IANw9sFCw4DvDT2dVnv00kIQHSE+aBE0hRNB4Q7kSkF3uDbmOYxmIk+vdLxUO23BW5NiDTCoj7In0UsANTA6hTh4YIb8lZa65AeJVxBlzcnsHlV0n8aGyWmcF1481NeGBDUQIjhi5JcMTNmn+JLnKBi43nGpsXh8tirB5M7zgmV4GGItaumsbOIvpeNlFSqLeg1UFxwIOeAPQxcpCHpuxufGy9kucILzMkXtOPwQLzgcVKYGWo5DD8gTzZXno69x/5BDVbeEatnhr2Jv6lXvtAp84CmfLPk8yzKcK+5VU+VRyekWmPbVSkLmIlIX6Rc7w2k3arMfaxlmKlWkXCXpwZ+0W+SmOlUgvVqvAlgiF4jpHYkSQF6H+H67edb43EYI7Lk8BQN3zNnLwub/iK5YjZGIEt2hRk3BReYbsCQ39Xq4t1ghznkjQLIFUnIVM+7oOeq3bwZjo8NSAhbCAXl8asC7a63IhAAwkqDXqEzomYlI0vD1kcNnw20VrbbX3izarWKfoz5GqgXV+WvBMihgJjps7QdZ/vs6M84vkuQthGTiasA84PfHc3Qd3FBuzZn7Hv1zwZpHkAMEsl21qzZY9CPw38GIN3phOoYbYtTpPk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(23010399003)(261102123227099003)(261026140227099003)(261026121527099003)(261021121427099003)(11063799006)(261022105027099003)(4143699003)(261022075727099003)(56012099006)(261028144727099003)(10067099003)(261009223027099003)(261021123027099003)(8126099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FPYfPN4kP8V1bOKJRBZAXxEHhBwMlpNjGjBk9ybiMC0wKXC4yf377qLOcNYL?=
 =?us-ascii?Q?zpzMJuWZ2ldfJRW5OJtVRu+dxJhDKy4FSSsCbUEyRcbYKYcvoG68cCphON0r?=
 =?us-ascii?Q?uBv2UIO+LPN2kiMQlD8r/dwe5iPazAxVQMhx6L2Suuh5t9tfppz4W3/L8MIr?=
 =?us-ascii?Q?k/wShccvcQ7Rph2J0te/dYeeU0JTXqVpycCU86G/r00UCaHfwPAETJQBN/4N?=
 =?us-ascii?Q?Te2SNx/takeoRVfmCVxwaEkXOK+o5UvXIWeeOJcyGL87PPuRlLMWQSROH1RA?=
 =?us-ascii?Q?+oUmcaXy9BOS4W19KiAAU5EbZwY67tS1r3cuHGHL49ag4uYIOGlkmco11z5H?=
 =?us-ascii?Q?kqJhQWVlSKaGvKRYeCybapUipje5g3wN4WiMa1zaCH68W/Uhh9Dg0FVQ9eTj?=
 =?us-ascii?Q?wEckyYPxeQkOQ1DMfIHe9IiGk5Op43l/Xzw5HVwt/FF/K9+kNiD/3kx2Ww7Y?=
 =?us-ascii?Q?NLfXUAFRToJ0zld6e6slO/tKEs5aV17gWntMH/9LsH/GwntKnC82vcPbjSU1?=
 =?us-ascii?Q?9wtzo3L3FHl11hnKVvXhalRjkfCP6QE0ooRK6vyZ1cmt8St5L5OkEz5ka/LT?=
 =?us-ascii?Q?QBzQs8I5X87aTocVmbGST2+BDETEtYtip9q8oi5BKPemhBD4tlm/POlekvjW?=
 =?us-ascii?Q?BrCiWPTyWQuG8/qfsAlJcMFH5HOXmxlD+2Vdatntuka3lGGC1PkfQsEDXHIF?=
 =?us-ascii?Q?zxFw0CsiQ63yz4ukSVggAf+J6/oP+EnTOTqNAQZ/8tsECkhfc3PaK6/ESzbK?=
 =?us-ascii?Q?pn7kdPuLGpdZbJ2NK7QtBzPzvH39e9yGWGrfd4n8J6xcqWucyyZWyHkV2bBp?=
 =?us-ascii?Q?QN56sfQoaXglBmK6TWPt7UKaYaXZKqzfz7rJekcDRb33J+OTyHw9ScAB9Ioc?=
 =?us-ascii?Q?NhC9XlV9tqgt/AUJMvzf76AhsDcCSjyK7N2FYxIHlLWNhogBbuhG0lHTgyjj?=
 =?us-ascii?Q?qXTT+D0DA6koI4qWd5Oqo4ZammuDs/JmrMgwtDC0VbnFlKDXk+y7iyel8BbT?=
 =?us-ascii?Q?1thfcgF7As6P03WHbrORLQLC/k6fGswOl3Kku0L19dsLbHJEeodtvNrlZeQz?=
 =?us-ascii?Q?Uu/7sVtS8n/ezFBhTMkXK4Dv0mFED29UvslttY0QSVGqqVa0yugLPdBu39Re?=
 =?us-ascii?Q?34KBEYy8z9At/GOmEz+oPLAK30xH04hErfuaGR/iDPa1QkSeOU75v91Mp1zS?=
 =?us-ascii?Q?jZBF1snJjbXsL4gl1TIvEzjRAk0TcWffE9y6L62RFCrfAyG/yVF6oHtCl6NC?=
 =?us-ascii?Q?sCCJJJ2clWMD4xUfq1VXO/386bbKfiX87RKRk+XQjyIg9Iv19dHLKKrk92H/?=
 =?us-ascii?Q?4KaicaUa5i/N2ys57WU625wCFAHyBW7QQ0psNrwmfnniatl6qZhau+Srgi05?=
 =?us-ascii?Q?9x2nGAbV1hY5ODQxU4Agw4pqBceuF/uvtYYE7SGkK4o5fQ5NJ1jjroJepgUI?=
 =?us-ascii?Q?/slg3OrekrixSn+dq9Qi9plEG+Ab8OTiZ7/DbKVkulPMnYBTYNro0WOR3sjM?=
 =?us-ascii?Q?DL8A5BoaaAp0zr0tpmUzjrzOWLcFdKA5Nr6G5WrMoa2vhmL9dsD8/c6wTcmQ?=
 =?us-ascii?Q?rl1VD5A+55+/KFfijeofivP8hqiEud1nbPhCcLlYN3gMZifoMIoDIZXufnwG?=
 =?us-ascii?Q?kYKUCxzp7x3wkzgTDkFqRT5CChjNXi1Hp23xb40HYqXId60Y1DOvg3nxz90M?=
 =?us-ascii?Q?r6gNg0tr0xVY/qpuutZszlF9MwdJfJmGiGJWgNo6onWvlZvF?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 499412d7-41c2-4ac1-911d-08df4a50c33d
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2026 17:31:24.4945
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pNTUTniXzhLolP33+h8K+SlBU4s0MkDQ+SzOrvqVIouboefxgfBuGVyh18MkttUJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5858
X-Rspamd-Server: rspam07
X-Rspam-User:
X-Stat-Signature: shen3aksmybzshswktatq7hineyq7oj6
X-Rspamd-Queue-Id: 32CAF180013
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795541501-588351
X-HE-Meta: U2FsdGVkX19yLsGDLycdebgnKJgQppMsrMb9m3desm0SBm8anqkOdVYLR4X8rIxJld93ZY0OFKwAKfzzZzWOtQDJajqoY8Hi25UOsGvd2s/mqLkzkCDnpnXa8Yrk2gmiuBbU4aFDP7Fn+4KXfOB+n2tvJakF8nN4jmf5YBZYkjGsriOAGJC8JSzTovrjc+IzTFGg36Q/lsxpN75JKft9w9MX9GSlF7KxpLrvsUumIjYJ+SSAJ4tRzFFuMsIKAUi+9VgliU6uQbKf/wdUD0UtJU5WyuEfFfPPVtFoSmI9+uj0q04eKfOuCxQr4vPwAIx4KKuj0grsJjIBUPAXE46fc5gTJbnLtDPkxfAq4JFBgI5yiU+SAw85+cdiOF2wBbfq2EJxiucog/hWRt1ciXPnz1ga8YwOqZJChinHhuBXt7FGmrOLKv0X3E0jwbWX9Q4GbU0JDm1DVRNrGiWeeS1EKvh9h0/TFgoQFG6MD53X+torFVGQlqn0VJWekVttcIBajx/wlPeK2V1w0ral4iyhD1DSMNDFPGwqg3TPEIIWF9SOLjVuSe6UfJ9tYN+ql/83R0YZclo6m8un24xzcJVSuqstwQogpuWTQmbiVb+ju9Ez2Vs74o+uj9ub7F/O0Ohp4cj9hW86BGpNmFAV06bKpaJd2uWbaoD7V8SstixG54TKo+pUClSyKkBrXYCdUod7OSMZCPYl3FTio0l/OPudtRXWPmqSrXV17aVkHg74+SPltKR11M8uyuw78O3chYeZoIGtQDymmbQkaYtIZzSa9HttK8ArzZViar0aeIPZDXzq4WOd0JysVzqysUECR1nAl6m1pDCkVD823d6kI0FfqOCitBmqvyPrRV+7ouMYEQHCewZEYhzLt+uAPhmhubgywcAeUWi/udgiPNlC3vFfPL+gW3F+rKwVrIxlJ9vTvV9M0CExSLRqG6mhZNJCqgA6tHe157axLXbyuD3lH3i
 txvVrOF6
 kBZYNGAm7njQBft9NltfleRUAKgl7lBavvsYaI2fxMCaEasEmY+c+6vxrl1j/1DDoLd0yYHs8E886E/B5DR2ETywssnnR+YhbgjGrzy43WsDUeRC0SmUyb7QV2AlazGPq+G9Bmw/6hEGK/zLYDzbPUA00xtRgZgDIw87JgVWk0JPkJ39cJJJAxhkhvANSqpVDaWiSoqFAXh23IRDezbCy8JSiLJbXzz4CBmsubQQ98MXuSTHGLehF3kFFQOk65bFhIBc//3GTSFjuGeyVJsdrElUDeRLVPkIa1XrEDKsi4foWUUK8RrS1yQrZxCAbJQsd7L/hhd//dA1kYxQ+i8wKypIE9bl+eqN1ECRB1uym74zeXHae+3bTGB4XE0ZnRctm01/9dvf9NI+42wMyACB4HYzf1XNDfeB9xGTjv7ba4XBBREa/9IT/pFCQkepT1KhPqrxLzf1JtfDvE5uiJxVk/BqeHs71ad/xtXBUcuZhbX3LSoGQODuUCqsPpvWeto9BvZi9uvJo1FSIqlYLkbATaeOHEj0kLPX6BCOmPF2/qaaa/0FsG0FIUtEObfg+Z4/Rt75RgN19g9fQKQqxN03RLGOIGyxO28volTUCwqJ2HcE3hYNDBF1FVeaIo8OI5c6rQwP0Aj607XlLBbF1OSFudHlIFxqwBrfvjfuYjTIpA8YgHq72+9sPALBBUL5p8SoSIjLKWVBz1yS7OkDAtcJBzjTWytT1+3ebKJBNOr1lVdRIk81FRfynv6IEHnVfiN/ILqhzNW0eArWEbvvJyo83GDl28mSkTwsUQIO6CR2P7Drx9irbb5GBmjZoUVWGuCBYwBhLM89KzohYLaWb6L7Iy8auyUz5CXw5GHgUInqXbie3181iYnKZ8zHMpU3m/A3TOCXWDSt/EI6y8EGfazDKzAmEGA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 24 Nov 2026, at 12:29, Kairui Song wrote:

> On Mon, Nov 23, 2026 at 02:52:55PM +0800, Zi Yan wrote:
>> On Mon Nov 23, 2026 at 1:53 PM EST, Kairui Song via B4 Relay wrote:
>>> From: Kairui Song <kasong@tencent.com>
>>>
>>> PG_referenced is only the lowest bit of the folio LRU refs count
>>> (LRU_REFS_FLAGS) now, and MGLRU never kept it stable: promotion used =
to
>>> clear it, and now it toggles as the count grows. But with the LRU
>>> referenced count as a stable API now, we can use two helpers to provi=
de
>>> in-kernel users a stable and sane reading of the referenced status of=

>>> an LRU managed folio.
>>>
>>> Add folio_check_lru_refs() and folio_clear_lru_refs(), which use the =
refs
>>> count when MGLRU is enabled and PG_referenced otherwise, and switch t=
he
>>> smaps paths over to them. The lru_gen_enabled() test stays inside the=

>>> helpers, so its static key is not splattered over the few call sites.=

>>>
>>> Convert smaps as the first user of them. MGLRU now reports every foli=
o
>>> with a nonzero count, so the reading no longer flickers and clearing =
no
>>> longer results in an ambiguous status.
>>>
>>> The classical LRU case is unchanged.
>>>
>>> Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
>>> Tested-by: Andrew Morton <akpm@linux-foundation.org>
>>> Signed-off-by: Kairui Song <kasong@tencent.com>
>>> ---
>>>  fs/proc/task_mmu.c        |  6 +++---
>>>  include/linux/mm_inline.h | 31 +++++++++++++++++++++++++++++++
>>>  2 files changed, 34 insertions(+), 3 deletions(-)
>>>
>>
>> <snip>
>>
>>> +/**
>>> + * folio_check_lru_refs - Test if an LRU managed folio has been refe=
renced.
>>> + * @folio: The folio to test.
>>> + *
>>> + * Returns true if the MGLRU refs count is nonzero, or PG_referenced=
 is set,
>>> + * which is also correct for the non-MGLRU case. Kept as a separate =
helper,
>>> + * to avoid splattering the lru_gen_enabled() static key.
>>> + */
>>> +static inline bool folio_check_lru_refs(const struct folio *folio)
>>> +{
>>> +	if (lru_gen_enabled())
>>> +		return folio_lru_refs(folio) > 0;
>>> +	return folio_test_referenced(folio);
>>> +}
>>> +
>>> +/**
>>> + * folio_clear_lru_refs - Clear the referenced state of an LRU manag=
ed folio.
>>> + * @folio: The folio to clear.
>>> + *
>>> + * Reset the MGLRU refs count to zero, or clear PG_referenced, leavi=
ng
>>> + * PG_workingset alone for the non-MGLRU case. Kept as a separate he=
lper
>>> + * just like folio_check_lru_refs().
>>> + */
>>> +static inline void folio_clear_lru_refs(struct folio *folio)
>>> +{
>>> +	if (lru_gen_enabled())
>>> +		folio_set_lru_refs(folio, 0);
>>> +	else
>>> +		folio_clear_referenced(folio);
>>> +}
>>> +
>>>  static __always_inline
>>>  void lruvec_add_folio(struct lruvec *lruvec, struct folio *folio)
>>>  {
>>
>> I assume this mean people should stop use folio_*_referenced() directl=
y.
>> Are you planning to remove PG_referenced helpers to achieve that?
>
> They are still there for CLRU, but yeah, and actually there is an earli=
er
> RFC where we can remove PG_referenced and PG_workingset, just like this=
:
> https://lore.kernel.org/linux-mm/20260502-mglru-fg-v1-31-913619b014d9@t=
encent.com/
>
> And this:
> https://lore.kernel.org/linux-mm/20260502-mglru-fg-v1-32-913619b014d9@t=
encent.com/
>
> It doesn't really reduce the flags usage but make the code cleaner.
>
> The co-exist of MGLRU & CLRU makes it looks weird, hopefully we
> can solve that soon, let's do it step by step.

Makes sense. Thank you for the above info.

>
>> Other than that, LGTM.
>>
>> Acked-by: Zi Yan <ziy@nvidia.com>
>
> Thanks.


Best Regards,
Yan, Zi

