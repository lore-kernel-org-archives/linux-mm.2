Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D33C9CD37AC
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 13:55:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44E006B008C; Sun, 17 May 2026 09:55:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FEE26B0092; Sun, 17 May 2026 09:55:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C6416B0093; Sun, 17 May 2026 09:55:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1B1BD6B008C
	for <linux-mm@kvack.org>; Sun, 17 May 2026 09:55:13 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C8E1840506
	for <linux-mm@kvack.org>; Sun, 17 May 2026 13:55:12 +0000 (UTC)
X-FDA: 84777058464.25.FC80CDF
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010033.outbound.protection.outlook.com [52.101.61.33])
	by imf25.hostedemail.com (Postfix) with ESMTP id E4C06A0004
	for <linux-mm@kvack.org>; Sun, 17 May 2026 13:55:09 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=UF7TxGXG;
	spf=pass (imf25.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.33 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779026110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yzzbhgW4GtiU2wVRVg8I+fbuvKX3TeiYk49GNyoByvw=;
	b=1P/rbgQrXhClyfhANrBQQ6Q9ajYys/VGRXJ6KXtxl7nCfZ3mmzGGZbM5pRd9XhjGOvmX17
	E5oCzPVhKF8OlgoPe7yo52qrQQFP70mwOzV9+/SfYsons0lp96p0hCJ7Otr+ZL+zboHbar
	XUD5kb+vGyiTV3d7an+2Kn/KMPnpvm8=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779026110; a=rsa-sha256;
	cv=fail;
	b=X5T0TaWSsWx8z9o4/ypDnsyWM8z6iSCLf3APjuTFxjBOPdh0X26YHnLnXKKlss/xSy2iID
	11SIQMRev6mTfE5Xur7Ec+pbJ2479CEPJRVjj+ybGF7jmzKKBhGKjMDkikN5/cRxPi6L1p
	ZjEKUFcdBdTu3cu3SjPog2ewh8jBnUQ=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=UF7TxGXG;
	spf=pass (imf25.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.33 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Cx8oFClFeXRCVcPe6QUs1UftV6ZGjUxTFlh74dlbvEylEEnTJ1S5qiUkUE+2toKmMVqnMuvOh+IGcZufV8n3V2Wxk/XLi9OVS9UDxNxskvZx09OYEYcmGH5qO0qn1GV7hB5BMIwi6XsyzXHa6fw6a4232LYvH53JlhtdFYmpaOFkjQ7VQ+On85T7O/4GLNCujOWRo9EIbovyl884VnPufZg6O3UzDJ1/kqawbEegO77YuS6xWcWPizOMEGq2NiB1sXjognqYhy3ASIDohHMIQWQZRIgalO9mXg7Zt8wBRQti6y+2no05nERdUR58QOuYIqxVvE+QDEwc982CnAz63A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yzzbhgW4GtiU2wVRVg8I+fbuvKX3TeiYk49GNyoByvw=;
 b=VV4oBWZM2/RXmChlPIaSMpvk+phlxxZK6iS53Db5NMC3dxMGmb+BGUp9RLRCH0LIMKrBt8LQ3e3cKsZW8dNOMvFiaVFdi7+At+ZMot17ltcgpKQAH7IljDLpL8+kj0a/3rE3GX1kx/jxSjDxksRoCycqcnj33S6ZRJQEoGTnw+S5kOVlBan/ibrnj4XUp8tZcGv8DZPZ0UahJZ8ZyXK+nBQSkCs430HvsN2FgJ8yiaowEne0WTtLRyd38ZE+A3Nqvfu6cpeGFrhnl7NPzJJbqOFaoX8QqWvVTzJAMRUD40JBLCSwgfui0DKW5qfAkU6A9Pbzghv9ph2CrzFh0VSjSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yzzbhgW4GtiU2wVRVg8I+fbuvKX3TeiYk49GNyoByvw=;
 b=UF7TxGXGnzPXSWei70+FEHv5TKJbqPX4zRmKiJtAyFAAbSipzuBQepKKH5oNQjRWSi39hWfrnCUn4UYoAsFYaaikcd+M7K8ZBpb36uQ2WIq4R4i03BvbSJvmxqeEPTljj0Z6Q6GptQIVpgR1Q3cKBFfmJBtmHhOdPL9FinlnNldRIBAeWO/PjPvYhY+Wi3sFJIsLxjiUaRtXLbJzGAX/ZCnGsZJy+oKQEDGmHkG2iu3AueAHjnp++Xmu0B+ETSXf9CplQ+lVWtoUEd85WA9AEH0S3+R1Aenxee4N28hWraF8S4a/ypt8R4bNcmoJYyJYcnay/3oX+JKWtBRHa0lRUQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CY5PR12MB6322.namprd12.prod.outlook.com (2603:10b6:930:21::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.25.23; Sun, 17 May 2026 13:55:02 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%5]) with mapi id 15.21.0025.016; Sun, 17 May 2026
 13:55:02 +0000
From: Zi Yan <ziy@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	Liam Howlett <liam@infradead.org>
Subject: [PATCH v6 04/14] mm/khugepaged: remove READ_ONLY_THP_FOR_FS check in hugepage_enabled()
Date: Sun, 17 May 2026 09:54:06 -0400
Message-ID: <20260517135416.1434539-5-ziy@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260517135416.1434539-1-ziy@nvidia.com>
References: <20260517135416.1434539-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN0PR04CA0001.namprd04.prod.outlook.com
 (2603:10b6:208:52d::35) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CY5PR12MB6322:EE_
X-MS-Office365-Filtering-Correlation-Id: f8d0376e-c4ea-4a83-7c28-08deb41be495
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|11063799003|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	uBmd63inFtahzUOC9OmlS/uGMXXx2bEpmO/NW6FVbZ2kohJERkhIpPOIPiNqjaYVSbqyeuOsPI1kxi+dHz3BiuyeXjQx7OVRiCHANqajamq/xwpfCyKYlERWMHNzt4GerBQ0EoEfvmLHwsBTnW5ej0jvFxg8nZnqISRlPrp9QrNCHIBF3bgU94YbK4q1h88pELKTp1QHeRda62y2/34Keg000HXjUCgu4x0u5P5Xmr8nOCn3n8vu22fM9FBiTITgK22kIcaSN0yx7DCtbnAQwwP3HJ6sIgXO7VFIo073zNakXy9G5TXXqCeRL9f7+WDrpsWVtcayeiUPxQ0Jj/KE86dbhpox0WGPKPCN2dPasId97NjYZAGlIy7M4PXBK3rfyrZooCHXU3nSWRTSVaNwy+v+AIgfdGbTRpiD4c+SIANltnZf7WtTPiRNei8O8QcfwwO0c0u0lsMCTEQbM2ZpyMwvqxx66ftAyGemRxSTPrLkX9BdyCqIVbygQMFZRwlTEDv+Poxic1/FjHUEbtHfp4xummnNFOqVCs+O+tBWTJAbUpgT1PfvISg5RzG70HVJoTJ1b5xCdompXJqe1GeEhZIZBVwJpmniXZ9H9H1COX2xruNl8ahbMD/zllnNRYrbrB+OH4wZy68+uSyR0GgP/Tq0ITua66l486iKxrB93RspKcsH0wZmC5dtu1msZji/
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(11063799003)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8YVbv3kdFbU5F/mdt7Ujo24Iz2WbblD8uRcQRD/lCVbFCsMMkGSp7oDxgTcD?=
 =?us-ascii?Q?G9yckHaVJ+98puBwALaVyBbqlUfz2FoySK71w8HZE6zjQhs7U4v/HeqBkI+0?=
 =?us-ascii?Q?fP+PuJJXS2gu8LgK9lEesb6/DIzylcnNA3hwD3LyDv3jwIRaHb9bBGNFdGkL?=
 =?us-ascii?Q?0iTD4yj57fMIuu93TaXrS42T/YIlhb9whtyC6v+Ysw4T3QyLtcXFqqKsciA3?=
 =?us-ascii?Q?e+/8biiDht/+6Gv43n70q1OvhHwuUbcu+6dIYs6LQ/UYmFs13MMfEoUkg9Y7?=
 =?us-ascii?Q?dxCPLNU7pnyp7OTVi81lWZqJ8bjafwbpBDdEGMjuqs81xJDWYzkKzVrh5sv2?=
 =?us-ascii?Q?70ZO22jEL0qpQv3p9Qv0qE1BRG+ZkPBesjnHEByOrclrnzyKg2nHlVDhJ/bg?=
 =?us-ascii?Q?K6q+rs8SzHWyA+DWmT3j3WTtfib4LlJSqGPoErOqiC0DpNU0fNYNve/YHA34?=
 =?us-ascii?Q?kcxFvQA87Ug+KfA4ns2qFrg8/1TmOYFSoukvq/eflPcVC/UemV1bS/f03xsd?=
 =?us-ascii?Q?ygKbP3PHUR/Q1dmf/qbtqu4RLrx+9RgY0uR95byOm58VbCUI8CPhNY6VqETl?=
 =?us-ascii?Q?GESE8V+BFO2/0zZPs+JxR3HFIHILHZWKeMvQgMAXjDkDWIELWGB2sQsXI76K?=
 =?us-ascii?Q?QxjXgMtQIvUwDAhQ2guxhphIGJm5xYPVABh9TD3s8OVRNGiY8JFSsOqyqwhS?=
 =?us-ascii?Q?xBuoAyFfJrR04qXWWlZx5cymcrtlz/uscznIVs11YBqHzpdS1rryQ2FkMZcw?=
 =?us-ascii?Q?/FM6GiCiGSiTyySZ0iC4j58YC5UySj7qd+1iOufoUD8OXHPMUXni51bDiMUY?=
 =?us-ascii?Q?uL5ihGwEtnNKzn0vpoWLzMSip4zOZiEL4mfVFMcHdApN8HxowUsEPZIQJfmi?=
 =?us-ascii?Q?yo4rACfCggf7PGtgLmD8TxMt1kk5Ux48Jc9LokN9wEPsufz4p+d6NczX3mS8?=
 =?us-ascii?Q?GH11YVM18+QUVKUdv/WCCrmNQ5H8i1Wo/0rhC9AaXIxQ1j68X7SHS8jvkZ4b?=
 =?us-ascii?Q?qVZh+pmh2A+n94POD/biYlNr4qDW2uEpVAabHYY5GOY465Kc5W/LRoBZQu9U?=
 =?us-ascii?Q?uh0x+A3pNKT/0PYLJk1wG4WavUJlWQi/9JX4NZpIWArUUOXB2woL4OndgQlH?=
 =?us-ascii?Q?b+ri3Zrswx9D+JMadh0ZQfgRFS4kAigjKM6NriSIPvi5CIAw1m06qCNJi0UK?=
 =?us-ascii?Q?48O1BIQHlt4SowQIQOoC22EN0fUQzbrfAtp9GuvtCQeOZf5LLvgGOvWKD1jy?=
 =?us-ascii?Q?pJurRBn02okMRSF5Dyf2CsHmXZZWAwTyyxRE7quTIE3Xfr7qWlUX2jNmLfj1?=
 =?us-ascii?Q?Fa1E6DxKc9yTy69Wg0kJuEJ6+ynycsyx7FCEkHORBGMvdjjwlxqheEORhPh+?=
 =?us-ascii?Q?xpGcdprJH271bvE+oTKulGhCvnrju24fzCbbq502uaB2gvcrbXiE8jI8jIp0?=
 =?us-ascii?Q?bwPi4/0LLmdw2EEfN2GRqiBMb6gLupHH1Nk7HaDsW9uyJ6fDffovx0bEvz6O?=
 =?us-ascii?Q?UZEsWmfpgNySZQbl+CNMkwZiW8n0zQhJQd2LbgnoM8QYeJ+ZSvoJumCaBOUC?=
 =?us-ascii?Q?5NiJc7weSNvMPbvnttr24IZRA5CxRoGbzMwxiXAd4LXf9hy+3i8StGZQSrBo?=
 =?us-ascii?Q?va9affeKPR9HxPOGjt5YWVHpDfGT39Ny51py5Hq8Ni1hPJLCTMXJdXPFdbBc?=
 =?us-ascii?Q?YFbPkCNcXGnrz5uY2yncwpZl34rJXS+t3FWAUA09nhT9Gxk1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8d0376e-c4ea-4a83-7c28-08deb41be495
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2026 13:55:02.5990
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FXgtguYz3PHzb99clwKl/6Q00uCVy/9EdVm35/SCv8K3xyAx5sfM4NnM6zvTormP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6322
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E4C06A0004
X-Rspam-User: 
X-Stat-Signature: tch6g5nefxir4db1r1maar7qq1b8yfxc
X-HE-Tag: 1779026109-671593
X-HE-Meta: U2FsdGVkX1/LnIZYbioFSQScYrt2L4ZcorTl4ruB09A8zd6EuUWkR040ODTns8wzFHWIUWn4ir6gmEd2DTV/wboeHyWo9k+Sm/IlTkkEEqacApdfBH9mXStyEwCv4YOmUf+nCoTghY7J1++1GD8Vy3lriMxJOtsZnckUBcI1jyzt0lfyVqp4mzGfv+kppftts3g/go0DVkHWd2RevLrU3jMr/ANBxRxnxo/5hHEsSchtTiiXUHONkxVXsZOTwNs2gIwdVRQ0jtdMw+xoeMePcBoW39PivTZX5sN8cxWfUTy/tpvXgOxN9vMT+41Xg/18Uzqgf5GMHKLz9WI0l5iQhTEVDyhcqtCvBTZcahgDiB6waOeBQuDpn2gNxbqbAPaISRCww9xsAQeCK4zmLdoX41ePbCfISMk6AjTBwiHs5fck8384Jl1eCrCc1agrXSCe5v14Pg5NWgd+uqRuExUabmpC2f3UyKLKhIFAAaZFExe15RbKErHeLqOoYdnY6L0j9JG/YWdW2AB3X+fYclhS3Mml4af0hlzXWbUW9DJoUK1EHxNTyAqPhkVOrRMHbi1/YVtNS4W12fQ4U1mB+3N3qCU04Qgqa8xuqH+wPdxCE0Q4lzh50qom3aoiIHwFms3ZDCclh68/AREHYrXizrCmnG8PELi4dLRXi1jgLql48hECKiWkaog//5vzYnQRj3TpiFWrNcVmirhcm/zXFJPoZAly/g/RuQoxNiF6JSmfLvthkMBecexrEJ5b/CnqgqVsgHiwgqiHA0NC8cWjfK7nKa49C09Q82D8rTMbN2IWmJbGCpAoqFare5bru9lMXuXHGRu8OD/1dS5DavHPQH+PuBbQU95b2Kur1exmn7R/LET6ejU4+nCfJ1TKuHoBJw4BQACuFRxYDWT16XRjzLaB/blgiYpGxGx/RiL7ynPdaEzriWjx0Kj9yadL1yj/qN4f24QkoSZncv3h0OMa+k1
 3uPc6FV9
 73vqKDVR9bFKdgr+gl8fjRudPA5Pooo23wdXvSX3bXTxG0Lr8gU7BZxgtTJY+B3KUHgbSOTTttMYA4UlOAOjSynKtj1WP8nmeqDEpurCHVhdL0bH1q8omHT2gQy5dTQXSeSl5utUIjt6p6PSZqFLRYHe5JboNE47rtiIera/fGVEwRyKFalE/OC5wpplqR3KaYmMSp6D51TNFaq6Zrnz1wVMt4/t0MQye0g+AXVHqxzMo9AXJoD5jJjhQMmHUNwPtOaiJ8UsCY4cYRgCw2i09avXJk0zPdfBOSAMUoYsWQuX25n476KBQMiI6kqa3uiGPGPO+1hwocK7oGFpXMSH3OpCobVYtH3z+n6yerqcSl2jQMjnmLMAEtLsEgerH+3LKqA/L55VpFF7360PR1t7omF9ebbXWSbgI7VHsZJ9w8eHz+Y/KTMYfgGrViYM6KcjKvCvz9cU9Yc/egdwZZD9/OUO/2MEKBIMm9KbIrTe0lMH9YnKMXNsFp+uYTqc2bCDhVP6rldtEzHhTou8XwKcpyy40c3yaU5QR4nvroKgtNTaycGAtUFA8Mq1YPkbMwYb2yqIHLr/fUct8uKWYaMaNQqZumv7BYn0Esdha1j6Rw786sqBNs59tEIo+urgmmf0/R4lwOm9zknzKSUPqOUMlFW9W7tN1qzFI7ghm3GXdEzbUmrc00ti2XXtw2S+2xgAH+wcN7uTC/Upn0tPE7JDZw7CTze1KyZw+qRj8f9cT/H/Q+h5jQOJs2LSkqE5ph7WjQXcJEoJMqFmH93/K/oTUN5G6aze5qZnGsHjTxrpYBiWNkpMp7YbOvkcPKB/taYiBYW9K
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Remove the READ_ONLY_THP_FOR_FS gate and khugepaged for file-backed
pmd-sized hugepages are enabled by the global transparent hugepage
control.  khugepaged can still be enabled by per-size control for anon and
shmem when the global control is off.

Add shmem_hpage_pmd_enabled() stub for !CONFIG_SHMEM to remove
IS_ENABLED(SHMEM) in hugepage_enabled().

Clean up hugepage_enabled() by moving anon code to anon_hpage_enabled().

Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Nico Pache <npache@redhat.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Mason <clm@fb.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Sterba <dsterba@suse.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---
 include/linux/shmem_fs.h |  2 +-
 mm/khugepaged.c          | 26 ++++++++++++++++----------
 2 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
index 93a0ba872ebe0..acb8dd961b45c 100644
--- a/include/linux/shmem_fs.h
+++ b/include/linux/shmem_fs.h
@@ -127,7 +127,7 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
 void shmem_truncate_range(struct inode *inode, loff_t start, uoff_t end);
 int shmem_unuse(unsigned int type);
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+#if defined(CONFIG_TRANSPARENT_HUGEPAGE) && defined(CONFIG_SHMEM)
 unsigned long shmem_allowable_huge_orders(struct inode *inode,
 				struct vm_area_struct *vma, pgoff_t index,
 				loff_t write_end, bool shmem_huge_force);
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 2ebbfbd260ec4..edb5c3656c168 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -522,26 +522,32 @@ static inline int collapse_test_exit_or_disable(struct mm_struct *mm)
 		mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm);
 }
 
+static inline bool anon_hpage_enabled(void)
+{
+	if (READ_ONCE(huge_anon_orders_always))
+		return true;
+	if (READ_ONCE(huge_anon_orders_madvise))
+		return true;
+	if (READ_ONCE(huge_anon_orders_inherit) &&
+	    hugepage_global_enabled())
+		return true;
+	return false;
+}
+
 static bool hugepage_enabled(void)
 {
 	/*
 	 * We cover the anon, shmem and the file-backed case here; file-backed
-	 * hugepages, when configured in, are determined by the global control.
+	 * hugepages are determined by the global control.
 	 * Anon hugepages are determined by its per-size mTHP control.
 	 * Shmem pmd-sized hugepages are also determined by its pmd-size control,
 	 * except when the global shmem_huge is set to SHMEM_HUGE_DENY.
 	 */
-	if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
-	    hugepage_global_enabled())
-		return true;
-	if (READ_ONCE(huge_anon_orders_always))
+	if (hugepage_global_enabled())
 		return true;
-	if (READ_ONCE(huge_anon_orders_madvise))
-		return true;
-	if (READ_ONCE(huge_anon_orders_inherit) &&
-	    hugepage_global_enabled())
+	if (anon_hpage_enabled())
 		return true;
-	if (IS_ENABLED(CONFIG_SHMEM) && shmem_hpage_pmd_enabled())
+	if (shmem_hpage_pmd_enabled())
 		return true;
 	return false;
 }
-- 
2.53.0


