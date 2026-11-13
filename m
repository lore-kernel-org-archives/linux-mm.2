Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 520EC606A32D
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 19:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Rce89IyF
Received: by kanga.kvack.org (Postfix)
	id 717226B05C4; Fri, 13 Nov 2026 14:49:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EE586B05DE; Fri, 13 Nov 2026 14:49:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 605886B05C5; Fri, 13 Nov 2026 14:49:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 39FCA6B05C2
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 14:49:04 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2D8C7C017B
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 19:49:03 +0000 (UTC)
X-FDA: 85431134166.01.07EAB13
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012046.outbound.protection.outlook.com [52.101.48.46])
	by imf16.hostedemail.com (Postfix) with ESMTP id 384BE180002
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 19:49:00 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Rce89IyF;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.46 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794599340;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ii57/go5pMgEms/fJPZsdT1dCLnL8gw/d6vRRrzYB+g=;
	b=kK/Cw6T7pKNhP7bQzYOqJT4b0zO138eaA/3cJjw8j2f0eqiibfszX8WPjrq6rvT4QaGO1O
	CWLLh9Qd/zcT9peVA3DPvfuuv3wgEpJogf6uB7v4F0MelT9U9Vb7zq3KMSZH0h71ZgGPfj
	T0wBUMQTk2GFPiDDeMvST7zJ4CgQLUY=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794599340;
	b=SKUfKsyVbtWKTOKaphY1vm7CoiNotupL2en+J3epQWWuieDvHrr914XsVWPqwWxreT5xQ2
	YhJKfiZFeAAad0wopa0Lm9uqK1f+UIMirf1pi97D3Cv4EHY9Fuq4wylSUlQ6sHOa9WFyQW
	me1U92ruW+xlYOz+LiAzDFJ6iVJIczI=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Rce89IyF;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.46 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rNuz6dunSyVaIcl+FqX88hL9kXu5WCtDbyG/F1ep9Eodb7CpYhn4LoQNgvbXgbcjM/LjRBe+2b+chfCeAsFQAm1Bp7TURn8z0Ngb7FF5GJk92DFbbYLElydaQuciv6xBRko9ByuSFsUTIHiqdVL2TeVdmHPP7svUzKZOY+fmg5TS8H3Cu0E1VWiTjwPEnjL/WaFKLjZM0FxMq4hbAH66OqrMZtdRwKThjNweBNTVo6I3SrlpMnZ9Edw3foFk6CR6Q9Y6FJ0Vkx7egTkTvFHNoPhZ+kIMty2AsMeOVI7CxuL2ezbKoA3E6L4jpCev5MaPmaTFMtPUB+WQazzLBVNTAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ii57/go5pMgEms/fJPZsdT1dCLnL8gw/d6vRRrzYB+g=;
 b=t5bjRktbxsBtUAbCSKsVBHU3nQviVLqL5vrwSLtjSDTqlp/NPt8c5ADoIhL+MsqxV1ShbTt0gsrp6RBuAxp7OApjXxeJZGG5XZPcTLJt6vmuKDOIz+s2qvQLtMsPDBwDKXmbqKFEeCjmH8QaI9nZtwXONEHmcC89MMQfIRvsmaUVH3L++Jz/x16IMzyzIVu03ZeIutaWGQMKd9hTLkEHvPgTpSlJVKhTWYnGsW0SWWQWVhnpqjmacIQHxibs9WspwUrgnRr9Yre3ZhypE22dLyRjBw3Iwh6wMhHOKRvRlm7RKIbLNMmdj6glKdWOTNBXeIdjdM9dU7wTEXq/rY20QA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ii57/go5pMgEms/fJPZsdT1dCLnL8gw/d6vRRrzYB+g=;
 b=Rce89IyFKqs0QUpAp871IxqO6AmrjvFnJ62DegnLIfYXDB6hc1oOa6nBi7gjVw9tYsJH674XFTVpIduRPGJEEtLVhowNGM7AONwMM3LiFQIeNpybBiWBx6FUC7MU1hU+Vk14bV54kmwK9Dwh5KsTvmVVTKzYYhj82HD75SpxfagdGoBwAgqZ0OPTw4sZ/nUoBjRREf0UdmuWsUJK7qWiink1LEJjV5ktI+tzHPiirHYgJCsQE2cZEgPRo+s7dzZ37ecx1ceDDUIUxz4yRg5+SmJMsMWo63Y4Sp9H6Gg4w/cktCqQCcVbZs/ZtGz7WPXUp0CCmoZEppQTXSO/Dtg2MQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DM6PR12MB4234.namprd12.prod.outlook.com (2603:10b6:5:213::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.10; Fri, 13 Nov
 2026 19:42:20 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0615.007; Fri, 13 Nov 2026
 19:42:20 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Nhat Pham <nphamcs@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Usama Arif <usama.arif@linux.dev>,
 Kairui Song <kasong@tencent.com>, Balbir Singh <balbirs@nvidia.com>,
 =?utf-8?b?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
 Kiryl Shutsemau <kas@kernel.org>, Yu-cheng Yu <yu-cheng.yu@intel.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 Peng Fan <peng.fan@nxp.com>, Josef Bacik <jbacik@fb.com>,
 Chris Mason <mason@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 "Borislav Petkov (AMD)" <bp@alien8.de>, Mark Brown <broonie@kernel.org>,
 "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, stable@vger.kernel.org
Subject: Re: [PATCH 09/13] mm/migrate_device: fix use-after-free of the anon
 rmap
Date: Fri, 13 Nov 2026 14:42:17 -0500
X-Mailer: MailMate (3.0r7038)
Message-ID: <FE09C34D-45A3-47B2-BF63-DF85936C752A@nvidia.com>
In-Reply-To: <20261111-mason-migrate-et-al-fixes-v1-9-3d2454362e8d@kernel.org>
References: <20261111-mason-migrate-et-al-fixes-v1-0-3d2454362e8d@kernel.org>
 <20261111-mason-migrate-et-al-fixes-v1-9-3d2454362e8d@kernel.org>
Content-Type: text/plain
X-MS-Reactions: disallow
X-ClientProxiedBy: BN9PR03CA0795.namprd03.prod.outlook.com
 (2603:10b6:408:13f::20) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DM6PR12MB4234:EE_
X-MS-Office365-Filtering-Correlation-Id: 70f27778-1612-44fb-47e7-08df41be3b6f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|366016|1800799024|10067099003|11063799006|4143699003|261026121527099003|56012099006|261021123027099003|261021121427099003|261009223027099003|261102123227099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	N/U0zk247uFumxEjjGS1n6ZpS6zhqpDeEryHJH5rSlm5DqiCF2k0C2Qc8Oe02R8qLacAlCVUSJCpDhRx85Xrfq8owxSbjHNZPxOyKDL4A9hZkyWIonwCNhXlVRqg40bchwbjVJhVtw07e0rPugBVNzAcUIJZBpVHEDSRUcwOfQi44yOBNibpCoes6D2NlVbJSobJAezSdni4JMxqJZQ89WPnx3/OpoRvoAaCcSYeZ26WZZwnMsXlhiDzCTcxllZEXE8mEVLimUtK7rnNrpS2I0NX7/7k+up/9OnBI9RyohS6x7/PUT5rvVPJ9bXQozU51cnCstPV6NBxSZJw/TK2QiLRukRygJQf7cC2Zx2yTEu94eThBNu8kQJCp3ICmP7ZfvGpzZlvUOSPgL5uCzDT+PODpcgbUMgHKiiEPSv44pzB6bG4x9tKPxyeRjez3uzN3XWB/bm/p4h/IiJ7AqCuEUG0gLsW1Ref2Xqvwfir/A+OW8wtWtV4bSCZZ4qA+0trVGwImL/zV492ofPHSlP9y5WgEUFrrSnqo+2LmiU9lge/TJypa14V5EtYYPFg5Mn5OP3jKheI7/wdSu27mQBJmA3nnr725PInaoxKId9keH33Xkm2vAVkSYLUxo2ioRi16+LpOulleZNEQ503FZ+lLz74asSSz7PtWQ234xd6ei0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(366016)(1800799024)(10067099003)(11063799006)(4143699003)(261026121527099003)(56012099006)(261021123027099003)(261021121427099003)(261009223027099003)(261102123227099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?aGzf468z16PY4smz519C8xjKzQjg/nblt9/z+c71QopC6oQcm3NR1Pn96Cwp?=
 =?us-ascii?Q?KR6ewFZ+aERFw+TXIO3VQMAsEt6BxejSHqR7ytdTz9qNeE5nQJ3/sUhJxxSn?=
 =?us-ascii?Q?SeZaRRKLzN8UW5FUCmiYHBHuPwuSO/VVRxdwkyZ/WWNJGqA4+mVipz/SUhBP?=
 =?us-ascii?Q?Tu9Qd+u8byYHLVWhHLfB3RqnNtqrcSE9YFLskzdm3nNXAjCLwByyVCjyuZ6j?=
 =?us-ascii?Q?q/CU1pzoRHdCbhUsO3ljTYv1AOeujsMa/wVtNgEa9RjjRC1gGriFUKXUwt0o?=
 =?us-ascii?Q?RUwhQxRrPJO017E77YiRfURdNulhMVcXOTo5e+kc3nlRVKfxIg2OFo2Cq51H?=
 =?us-ascii?Q?SpMgGepwsPL23l8MWEGZwZn9jZORYPvEsmoLJjfwLgElCLP0qjm9SAc3o7bh?=
 =?us-ascii?Q?GEcRLzr24/BpaRobFxQpLQmhPxbJffNfuzqqIRtD//4zIHPwG+eDZgsj8pjY?=
 =?us-ascii?Q?06EVt84aKqC9IU9JQE9jMGtNY4O0s6Tl7rpCQ5ik3voJjVAzNaeBSHN0vpEY?=
 =?us-ascii?Q?jmCOBpeOUcQJXeoOuh1Q6/eor1ENWUP9Afa2yyHUAIe1wvvIiO/mfX/YULT5?=
 =?us-ascii?Q?bboJYLP9ydvnWJZXM4UeqQwPoVTiJiqTfVUFIjWc8ST9VMOtdvjpJdoSmJnj?=
 =?us-ascii?Q?VCCe3IEVpddBi0Zk/2zaZLz4kxyM4/maMroCgXnZNmyhBLpnIOBDJlydsikI?=
 =?us-ascii?Q?nPFnWACEvSkXQMjYMapd1963U0Qge0giR+n4F+T7l6svx4WP0VgwGzLl3+Yj?=
 =?us-ascii?Q?5HlUZY6RSlM3fnbx3CiXRBZC8lv9g4VdkTE6cyvvy8ykG9XQP2qIGNdq9Bre?=
 =?us-ascii?Q?b5sylVLf4dm3Hdq2k7y2ggKKGgzEpX8UnrtVPVqEgs7CwZZwb1Vw9DhlRwxM?=
 =?us-ascii?Q?ZXfR6lwYl/s3zYzyql88O+CgEffQBn9td8B3MAMCDYY6HZ+IBXOux55RaLtZ?=
 =?us-ascii?Q?gHDDTV5aNd5dy+DlusB9/s1k9TV0C9mM9Ey7ZzJy8FX/hggSkWfryd/E6dUX?=
 =?us-ascii?Q?gM8zrstZ9zNbPdHGGjSM0C/JC32rau283xoYXuw7VgJh7O9lDhuO+7IHtlc8?=
 =?us-ascii?Q?kSPyrDVsrls9FpH8xRVbOfxGg8kksTkVrIEFwAKHxrDylCRMy+qs/1tDzV9O?=
 =?us-ascii?Q?1qeTZEuFf0mlUXvFpm2xj2Tq6VDPhCpjQkopKRTc8yPqg87SPbXdsQdhcU/6?=
 =?us-ascii?Q?ygn78ThHLTnDm9o6qIaDZ1e33pEtLT+EoogBhGpHVwwMJobYOpSOTZVmthLX?=
 =?us-ascii?Q?pTa0N3aAu50yKHWXfP05t6a4P3IH1PvxOqq82PyZZ5y0f3OjL8khHgLgl6va?=
 =?us-ascii?Q?5X1YWBG/JFBiPRgjpHAH8PvughW42ffQOkuwIjrqb+yC9+yLQrTzeuV2Pop9?=
 =?us-ascii?Q?2uUJpHcJ3rIB0TcUDp6PaPbH+Kn35M4X7s5Kaqg7kalf+TyTrC8V27xwaSIq?=
 =?us-ascii?Q?QCCgVu4PrgIb1Rf6vw866mtMFLtzBFnPif4idV9cTQQi5siJZW1cGfdrZgLf?=
 =?us-ascii?Q?aCXSV8JYWFnIfWRNLUt5m6GzamHeYypBthvC96w+p++ZJGJXaYp7h6D7bJPj?=
 =?us-ascii?Q?ZjVV8zPwBXNxH2BkM+cDekS9VrJuIeVrB3QD40w4iCgpVUj1Vtz9vPg380Un?=
 =?us-ascii?Q?TdYZFnhsBHFCsflefpStrcGVmvsf0NibJrguoh0+hdPUEmZKZN/8JBdOsYtN?=
 =?us-ascii?Q?UyNLPrjimKVf/riC/ruqr24E+YgzK+fyuABFsv3sdhTzoDir?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70f27778-1612-44fb-47e7-08df41be3b6f
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2026 19:42:20.8140
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yBedyoEXiJYPGfuYVTeiAPX+z7xIfdIEH2NkUJwHMKRBWNTONpxGQUo/3XIkw3uV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4234
X-Stat-Signature: 8563tgyz916p7o7o7k4dizjkrhm8yhjk
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 384BE180002
X-HE-Tag: 1794599340-711064
X-HE-Meta: U2FsdGVkX188U1aewvuj+OIWfYoy+dkhRWiJ+zwY4czJF9UmrdhXGU0iOW1i7trRLK/b9DlrROaMa1ekoaEuJ5zPEtJbINEH5TYExrGZ2YAmmubw/nvTG6QeUdbv5lUm0rmqRAVfFrvBzkcxFfHVP0nmM/sVIsjU1vmeZ2DrJQZfgOHniYZDaW9zIGWsbW/UFfj8uPH2i4L60Dwgs45elrHS3CqjD5cAVIOd+31vcMrO40AmcTuhHAaKI8uzlGkLGBppTA8vkh4RHaTpwbK0i5JASk7HTI10KJzqLDFr93utrMMfRdySFzVNdW7DSDCbqflFn48hV3o7OjPVKVYY71smdvDJONzxc/OujLS3ZYE53P7vM0c+oVCn87mgU1EsfAu+1IWAjZpn9r8onjwG1P1TXUMePubGFKujyx2BYls+FqsR96a4iUMyGN+JSw67NWSdAMTlDgi0GFzcbyfHdqoLcHmz9lOVqFTd2MUAKu3hO7Z91fwicaSY1QpdzGWeJPHp0WLVXWdVcKIGlgOduK832g5ZvmoHKZQUb++xNncDhTLFaY1szYx4xWpqnqXNosTk0RbdHvOlDMEW/GUEcPd+lYXxW3uhaDLBTyA/C9Ftx3vCdXJPnJKg9hh5Lu9Id4fUhE9SVwHQRUJQ7lRrUITVKp5bG8XKXgVtVa+5YCIOA5eximHPHh7k4DcDwRVaHeKVBzAgdeVkQr3mPIfDJ42I1+VCI8EAnQ7Fz06TztocFrjxLGXUX0mlAuj1iT7NjMsP6MDlXvb876PPANt3XPFVaEJ7D9c1xRATL9ByowcM2Rrz+vxl9Zqogiy3E8bCWRvJg+97pmx7EAwMTSiLBTK22u8q+x1MTo5HUL9cLebskc62iKI3XWoAjKMiIxhwvCff6m64dCaqAP0FhhGIjDrELnv5kulerC+EEvRCoJnsmMT2PfEL5tXJ4KgjU4kI/2Ip47ZDneRLDxbZBIy
 mgRtzjKu
 a587TW+3/oqiASza7s6y7/ZYulBBWvmuhZvfhagTgsmTpknRDAFw4vInr6nl6sXDi9oqKcGd8i7K9CeGxDEQ7AbYWt60WRTfrvH1CTU1cbK2OVRjOF0mXzcEFHoZ+AV7bV18lG6NtvWKqDqhO2XsuWyrjKds2Wffjt0xrE40ydzWf+mRcdiOrYYNrzQ1AO8o0utpqAwfh5mHHoXYMid+jiTeGlPyeDwQHHZtKAm7zQnPm3yOUUzcMUPI91YDub1Q1zUBd6sL1UoZpd8EtsHNevWek+5KqJg4UGBw84U8tDnP4ATuJzaXGEJbRvrC4kGNxmbvP1fa+r/7VkecYEoipF3Dwy5/rhHiHPEDQRxOG3mVr4ZozHudebT+uG9Du7FOuqFuG98fG7//Nog0mzfKMJwpHquBq9MVEoKan22PgVcRC4pikJ5by51WSYsMspbk97pvBstG7GlRBy2zzv2DBWurwc/kEgMy5np7+C7jvpkmOYPsYmtviyuy20EAfya1ceBQwu3PNiAzAxF8QrKJCHiwyUA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11 Nov 2026, at 13:13, Lorenzo Stoakes (ARM) wrote:

> A munmap() of anonymous memory can result in a use-after-free of the
> anonymous rmap if a concurrent device memory migration occurs and the
> migration runs without the mmap_lock held.
>
> This can occur for a long-term pin of device-coherent memory, or a driver
> evicting its device memory by PFN.
>
> Consider:
>
>     eviction                        munmap()
>     ========                        ========
>     migrate_device_range()
>       migrate_device_unmap()
>         try_to_migrate()
>                                     zap the migration entry
>                                     unlink_anon_vmas()
>                                       last VMA: free the anon_vma
>     migrate_device_finalize()
>       remove_migration_ptes()
>         /* locks and walks the freed anon_vma */
>
> If munmap() runs before try_to_migrate() instead, the folio is no longer
> mapped and gets no migration entry. The walk still runs, and follows the
> stale folio->mapping to the freed anon_vma.
>
> Resolve this by pinning the anon rmap of each folio which possesses one in
> migrate_device_range(), migrate_device_pfns() and
> migrate_device_coherent_folio() before its PTEs are replaced, and
> unpinning it once the walk is done.
>
> A folio which is no longer mapped cannot be pinned and has no migration
> entries to remove, so skip it rather than migrating it.
>
> Reported-by: Chris Mason <mason@kernel.org>
> Fixes: e778406b40db ("mm/migrate_device.c: add migrate_device_range()")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  include/linux/migrate.h |  1 +
>  mm/migrate_device.c     | 39 ++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 39 insertions(+), 1 deletion(-)
>

Thought about other possible solutions, like checking folio refcount,
skipping zapped migration entry, or checking if anon_vma is freed,
to avoid adding a new MIGRATE_PFN_*, but none works. So

Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

