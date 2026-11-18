Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4E7B606A889
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 07:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=EMCproY3
Received: by kanga.kvack.org (Postfix)
	id BAE356B05B3; Wed, 18 Nov 2026 02:34:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5DA76B05B4; Wed, 18 Nov 2026 02:34:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4F2E6B05B5; Wed, 18 Nov 2026 02:34:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 770D26B05B3
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:34:12 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7895712027D
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 07:34:11 +0000 (UTC)
X-FDA: 85447426302.06.58DFF19
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011021.outbound.protection.outlook.com [52.101.52.21])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9F22C1C0005
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 07:34:08 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=EMCproY3;
	spf=pass (imf21.hostedemail.com: domain of icheng@nvidia.com designates 52.101.52.21 as permitted sender) smtp.mailfrom=icheng@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794987248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3LcPghvT4MlsKigSrisYfhCeWXY5hpBEtnXJWO3z5a4=;
	b=CIHJKDKBvg/VDCB9fbKJ5OQoz4hYRH4zuGcNCsOYnWVt48eUTF5YCKyA9eee5CFpYUthcd
	I/Yp/ux4MrAo/7xiHcojt10E0HgmtX2EwQBvLg/BTn8bCXbfktSIBftBFPwERsLzS0YiVh
	H3zjo/JuJoPc23TyefXttIXTCA8y+k4=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794987248;
	b=ufToCBFG6MxZml8Iu/auvJrrodxmezf7VVYKoo+1gWZ5OCdVueFNWYvxbYNGVwgjwCPlFH
	7V3L64+GNp0YXXo04Ua06bBD1IdgIch+ODGT/0vk1bre9NWtkmCR+SH74MPIqWYn6f3Jhd
	JvbmyGsTS0wBd3duImV8koBzQP0aWbs=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=EMCproY3;
	spf=pass (imf21.hostedemail.com: domain of icheng@nvidia.com designates 52.101.52.21 as permitted sender) smtp.mailfrom=icheng@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CRlZcoaLNUNmdLBg7q3fErwzx/M9Vc26E6PgswXMjeYxzmiYrB0v7rj7foJfk6Cq7k3w7Ms+k74MS2jX+Co4oi3AJnw4cOi0/Kxt1XdNQlQXLhQgEyXU0fX8EQuOgV0ZhZYQGOEOLFU08n5mTEE+50m/gqlusnuBmAMnE9pOOtXs1MY8qbP+i32jpVZvl8L55BziI6sBhUD19AA6BqOeg9So0z32BFC5vb4bihEQlY9qdao7omh24PVjwA+HTGODnpi+99jKxnPbVHiVvyV2iGauI62WdD5VyjHVkSI0HmhrxjwL+QkgR0LgtyAB1YC9SjpiSK9L7RFMZX8Pmj4k6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3LcPghvT4MlsKigSrisYfhCeWXY5hpBEtnXJWO3z5a4=;
 b=u9H50C+mO6Kel5IX3vaEEdGh5jrzI6vKOfghphg/gr864gckoaR06xhXQieUoxfWVzGqZPO/5MTuNbCVMZ1/uIT+X217MzQ6F3bHPk1n8qynU5NHkjS6eB6df7tH3n3xRaHNU1lI3ZnYzY0DTHMUhEVFHAoOhN90t/KrcebQJa3uC8cLrF2cj4jjw5J5xJ4MqzFXzMa7UO3zvix6jFpF3EfK3Y6fv0kFwhQzysHeZFAxwSYDux3W6+aR3WAXQPBOgG7Uc00LNXM8pmPxoaqZKdm666r/0cgkSTFahLhf1JTV/9hsjXoRQhzWATZiMCEXP7x2waus9oEeecXDTNJ7uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3LcPghvT4MlsKigSrisYfhCeWXY5hpBEtnXJWO3z5a4=;
 b=EMCproY3imkOlFX32G8SkpaamXpqCgBWS56nsZou/m5iKpmysno0LDxS6snbvgDBNNM6F5+cHP9XylG4F/zgO25wzruw2gXdgyP0zFYyoKiMKduGiYCpkbqeFpGlkBGeACuwsmmKJtHt60TX2Tzl62cDrlWaZx+3LWBhCy+y340Aak49wK56re+cqkcjvjIGrsA8hmiYGcwpS7tKI65gL6R1LOsnl0syeOCtfLNfczgJJlUhp8VqZGWwvZh1piriyCu1pRQB9ihrRIQwICLzifERTEQBDnz92DAr56Vu+t4aXQWDICXbz6qjG0Dt+gmOggXrd/viuBL1+BDDX1gguw==
Received: from BL0PR12MB2370.namprd12.prod.outlook.com (2603:10b6:207:47::27)
 by SA5PPF6407DD448.namprd12.prod.outlook.com (2603:10b6:80f:fc04::8ce) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Wed, 18 Nov
 2026 07:32:17 +0000
Received: from BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8]) by BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8%5]) with mapi id 15.21.0615.009; Wed, 18 Nov 2026
 07:32:16 +0000
Date: Wed, 18 Nov 2026 15:32:10 +0800
From: Richard Cheng <icheng@nvidia.com>
To: "Gregory Price (Meta)" <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	linux-doc@vger.kernel.org, driver-core@lists.linux.dev, linux-serial@vger.kernel.org, 
	linux-pm@vger.kernel.org, damon@lists.linux.dev, linux-cxl@vger.kernel.org, 
	akpm@linux-foundation.org, david@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, corbet@lwn.net, 
	skhan@linuxfoundation.org, rdunlap@infradead.org, gregkh@linuxfoundation.org, 
	rafael@kernel.org, dakr@kernel.org, johan@kernel.org, jirislaby@kernel.org, 
	kasong@tencent.com, qi.zheng@linux.dev, shakeel.butt@linux.dev, baohua@kernel.org, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, baoquan.he@linux.dev, 
	baolin.wang@linux.alibaba.com, yury.norov@gmail.com, linux@rasmusvillemoes.dk, pavel@kernel.org, 
	lenb@kernel.org, hannes@cmpxchg.org, brendan.jackman@linux.dev, ziy@nvidia.com, 
	sj@kernel.org, muchun.song@linux.dev, osalvador@suse.de, nico.pache@linux.dev, 
	ryan.roberts@arm.com, dev.jain@arm.com, lance.yang@linux.dev, usama.arif@linux.dev, 
	kas@kernel.org, xu.xin@linux.dev, chengming.zhou@linux.dev, 
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, ying.huang@linux.alibaba.com, 
	matthew.brost@intel.com, byungchul@sk.com, apopple@nvidia.com, rientjes@google.com
Subject: Re: [PATCH 13/22] mm/hugetlb: restrict pool growth to common memory
Message-ID: <av1PyBvUVJcy_Psd@MWDK4CY14F>
References: <20261114070959.3490008-1-gourry@gourry.net>
 <20261114070959.3490008-14-gourry@gourry.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261114070959.3490008-14-gourry@gourry.net>
X-ClientProxiedBy: SI2PR01CA0044.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::8) To BL0PR12MB2370.namprd12.prod.outlook.com
 (2603:10b6:207:47::27)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR12MB2370:EE_|SA5PPF6407DD448:EE_
X-MS-Office365-Filtering-Correlation-Id: 2a7c70fd-d85c-4c61-2031-08df454611f2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|23010399003|366016|261026121527099003|261022105027099003|11063799006|4143699003|56012099006|261021123027099003|10067099003|261009223027099003|261021121427099003|261102123227099003|261026140227099003|261028144727099003|18002099003|22082099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	KuxMocrdiR4cSCCljhzUZz37PKhbYoREWO0kCZ+FyD4JOayPWOp+wSONX4W0Q+3+BgaPgLh2xTDGGtj2lt5D4VJCakwFdyycPiLduYN+RZbyWC7chala/x+7LlVVcsrNOMyY/6jR4SOjHTQrE8Q6uV029kGHJNB6b0hZYxsf7Y5P5gsVDNPy8bzQQmk0QodLOGgMtv1KXPV7on27IFNbHhBc0Bx2JcKE4ShA+MSu03rh3bZVYnTLg44OoZkSWPjTrzTRRWPq4lH2TxDzbORXD2TSOsfJ3Md3oDGsJm3K5E/yIiSoUzjvMJkz7YTZt90YMbUIsw8pAiwqKJu332EbTkVoE+FXcFKAQLJOZcWBRWCB/WatKyizXGSijyDhiWvp7Mn2NuiveOVth84ZLh8rDd30hCqsyl091tPIxJoPFZ5Hu0Qe9NXdrMBhi5HRVXjDGoAarSH8QByTihMgXapJOwC8PKh5OmM68t7ZTpgINPv2BVeoqQeT+9RyhNlA7xcqNwCNGw9+nLv6lHs2GBQJVe62hKfASAEosPHLSNPXS049rHrnjeUsdVGRoCZVsXDWzP8gj2l4FWNKLaTFQOevw3B+X4hfDi1fs72a7viIPAhvvYPolNUaRwpmsTUsIk+PEI2D+AlUTKCKcS4qMxSbkN0qUxmOPsgBZDNNdSE78Yc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB2370.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(23010399003)(366016)(261026121527099003)(261022105027099003)(11063799006)(4143699003)(56012099006)(261021123027099003)(10067099003)(261009223027099003)(261021121427099003)(261102123227099003)(261026140227099003)(261028144727099003)(18002099003)(22082099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gTr2q+cJZG+ehgUPLBb1axE2BtSw8Rfuxv2xnIAWIlM7EsTEZ+YYghFGfsTk?=
 =?us-ascii?Q?I749o1yI6albDvGA9jRaORPLSME/AVYYn3ySuNFgjZeRLOkoZ5mBzt95+wA+?=
 =?us-ascii?Q?GAE127OjyXoewNtODJqygptCJtcsz/jBeEmMAmdJpj31OobzuOj926Q2xtng?=
 =?us-ascii?Q?pDrAB0ijr45EGGLBa0etSFXPcyaq4ymiaR8r3FCGXgmqW9nMkdM4kVXBYkYJ?=
 =?us-ascii?Q?ySJR33QWsaiVOJYfJNxXDJQVbZqXvfzC2Z6l305i6CiMoSBUQ9m+e6CJyfez?=
 =?us-ascii?Q?0BQlD3t49L52ssOeHO4DSWNm5RM6xqBLp2adimH+IezHMEI7lYfFSgz16SY7?=
 =?us-ascii?Q?+hNR7hJiDXlrHIkRpdXLoQuDWL3gxuEYvuIzrscU+c/ZV/QGgl0GjjYXbcWl?=
 =?us-ascii?Q?e0OOCaHkhr2dHWaE+B8bPS2j0hXUlqbWfdxs+a+EbEyomC9GMRTe6Et+GMyM?=
 =?us-ascii?Q?wUwWB+74s7waJhcq/b2W4J5wFvUOlfF8fm8QOclkn7pCsnnSxOgjAXaNw3W3?=
 =?us-ascii?Q?7w8DIa0KhTnUXQMHjTkCQvqxm0D33fLnQhq4YzAUNFnpFw80gfxXx+V9L4Sm?=
 =?us-ascii?Q?vwQ9m1PwfKd79hIoa+mm3PVmJ97i1eWs22IQLtTiRojJj6/IynDIRaWPpVaM?=
 =?us-ascii?Q?QShOgP8q/Ymdb1xZ+Rv7a9LYcHbaNRXeXAAkn4YrTFbRBPjd/pPzsyeY4HrK?=
 =?us-ascii?Q?Y8Aj1s9/M+3UZxYHdxd46vZq1sxj9oXtD5PLTcZh+JqMaLKp/m6fLvhsJM6N?=
 =?us-ascii?Q?TBTvLyE+rzCsvMl+YHn3FfKEBaY7EtcVOLjV25GTP0cCJFesKd2ik+O0ud0z?=
 =?us-ascii?Q?Ow7trTtTAan0Q9fynn5QYbT0yiGekxjXzjfsx2uovZs9cuCUblUWtodav2Vw?=
 =?us-ascii?Q?RWxuoYgnZDpHC26P9R7tJSIPx9+tPuwoYQLOo5PQZFubYEbobZMbXuqG5M6Y?=
 =?us-ascii?Q?T8MssjmAoRcS+xbRewnXgbwmP3gCtilzDleCGOeqwYLpXXI88BHSKRpfgnxX?=
 =?us-ascii?Q?oyMGloUy1qh9YgcKeppf/aD1ETiiR4KvddgMIxpjeRB+YA2cj+x5t4CKlobS?=
 =?us-ascii?Q?Xpc1mrVEU6s5z1JU/Sxh4PNWGF+x2rtsgYjkDztl1gaEXNCE+zk1IcCBEp24?=
 =?us-ascii?Q?UDaVeaMN8UtyRd6mpqbbjERRfIDc2EkuaBNlX45tFKzSLb2fUgSc29X/k/V1?=
 =?us-ascii?Q?x2GBkgubY27EmfE7ObigKJhZPGFQSlTHoJgiGX56Y6YY/DBlWDWptFxRFNo2?=
 =?us-ascii?Q?yEr06BNB815qHfxuIUyAu0m8AH/IdvmMULzeXTHUIfgpSUycboUFfTXAqojY?=
 =?us-ascii?Q?84WBd+7SxUEHTMtSFOPVn/teRDSZICWwcPcXgdEawggNfzrR6uaRwKI41UWg?=
 =?us-ascii?Q?wUHDoyAdK2C49rrrlPYpExqoe16pQKpvN6HGXkW2fAbkEHnI7lfUc0tQeMe0?=
 =?us-ascii?Q?bc7onrr1tEjRrgU4vdANaroOUCw9k66wYmJ/nIOn0BZTepbR8KJI/KFGam3I?=
 =?us-ascii?Q?Euqsk7petQhv6cwgZM6YPA884R4BqoHBkVtuOFliUHWxcEEJRUtMd2wNg/gg?=
 =?us-ascii?Q?vLzFcSHZmGvoiXEUsG36kHd0g1taQuFV0Wf963d4UIQByzFBSlHUOZtaoLCd?=
 =?us-ascii?Q?zVDVYHxM4/RxBBPAOP5QRQSuChXrL/6dtppK5LNwC2TnQ9pAlYyU5CtU5KHE?=
 =?us-ascii?Q?Ry0AlQn+miLCGk+T//22CXF4QmW9zjJSouhTf23Qb4u20udg?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a7c70fd-d85c-4c61-2031-08df454611f2
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB2370.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2026 07:32:16.5203
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QfL5HJnpkoa9GxEImLInmfxafEKnWD7MnigAjS0faMRzQDMFbZsOcW+ui6rP8Iez72Kew/mC6bX9lamPxIwQPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA5PPF6407DD448
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9F22C1C0005
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: qi81o7uxpmgugyt8hx4gpd5zdkto8bnw
X-HE-Tag: 1794987248-209097
X-HE-Meta: U2FsdGVkX1/+ocflzVq15/aBGeQSH6mzYCzpRGic5/yEGpHmruqr02uNkT+wLxVumk9pOcWityZxsB9IWwtazeyVwY99LOwZA1TBw3Vd99LVskHs8YJRMDsjCamd6Es0luiqpV/BMPUbGVgjVXtDTUrHxuJGtd4VBk/DJ3Q4C5WkCP2ccKu7NiqbWMEdyK/1fAz4GyR7HKrlhfsaLLFGbbxxEVL9GOlgd6DvLbFC8ciariQZTE/zA/TfcxlzxoorxJiCIgD/O1bJOMrSW9JUm0r7/4RFTtYic70a79nbV7hj9DsI2QRhlARagL6cMKlu/KMYCbfp5Zun3pw0lAaq89BSfLyqqE7WNRMCamB26xk4KKXgdnkuwP0vHCGYp7z5Gb+bIln4WS7S2sKAPJrBi0C9Lxac0tXuNv2uqiVrg1c697Y+l9RLs/zO0yyanZPy8gcfYlMrJtklSKvE/z0nKj94+ZcUjem5wOkUAk7MzW+i1frEZTRP5OdoSZLyDteU2zY761NG8Qc8pAtYHzfBly62QkEtVo6WPVhQDj7yczHr5tOsCZreLJtG4oX/gDm+8YeY66dpKu7H9q5+Fn5lYcIDCimakQrsTZNHYegn7/xAIVm9PvMdn9D5IDDLo1tZFqPGup/s2JY1sG3zjJaoXxY2m2ZQmQ+EU2ORMKIPeajElQWXzvG0Yg8vjGXqM1HzV5wWQT0/ejk6SyaYhVwMAf4DGN7LKBtOKrLAyt/j48G9tWueOK11oqVtw5e+napSVakiPaytiYMPRB41WcWz5aCW5rntRVlbFJTw1EnTmal33r9jEobdNeo9TVdGc2ImgcUi7xwD7yVI+6lUYf8TglWR4xUGhfPdmn5FimaXqeJReETwm2+j5L3KBnlyudFCeQsGaNx8e9TuZKET7qIOFKUZ/5x20akhUlDvLx0N5Tiid7QBzyim6U6h9PLwipY8x9BtN7x/Zq0YuhCfu4V
 oQGJEcfk
 X56pxPKx/bL/4a3A9H1EAGwz6Cpx11eBML9ZyYqC+UbOGIU0oX8V0ENWErgwoyRhNPYk47EoGSupJ06dGnSbjw7HSe8TpV/Tcc7HIEik58Mkrms69rgCmpfZnnt9jrdc9ZMbIAhJ9/rHk8eT3vzLr08NBQZuYkcRh/XVuPBYqSVs+fIcELqshx9kKZ7o7He6OkP5XoJ7AqCyreii3MiNc0uHUwi1LsbNr6znWLmR8IBR638f+Oems9jCMT939xQbZlaX80RP7ZYvwQ3+ylq/myjXR8JfyErVRAgmLu6J5ii9JK4khjnHw/q+IwP4Cojc+atkrbhexBJpZKAGA9TzdY76W2aPChQJPNyeV54sbyjQyViKjQvI3Ajrel4N5LzhxpgpnzxAZ3vFtEt/dN0Njl+nz8aLCioTHahzLgBqLoYbXusNLYvNpxCIO48jfSIxS5e4m1aHF8qamhTvVlN+66mNS9GCeE8hopzBpOIxhE7qmfnqBDm9+7GDXA4Mifhu2y5TVtSSGeQV03rDg3tgqZE084YLGW2XLLFtJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 14, 2026 at 02:09:50AM +0800, Gregory Price (Meta) wrote:
> Fresh HugeTLB pool folios come from ordinary allocations, which only
> N_MEMORY_COMMON nodes serve.
> 
> Restrict HugeTLB allocations and pool-growth to N_MEMORY_COMMON nodes.
> 
> Keep the original allowed mask for pool shrinking and demotion so
> existing pool folios can still be found on any online-memory node.
> 
> The result of this change is that hugepage allocations will fail on
> nodes without N_MEMORY_COMMON.  This restriction can be loosened later
> when/if it grows a user.
> 
> All memory is common at this point, so behavior is unchanged.
> 
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> ---
>  mm/hugetlb.c | 44 ++++++++++++++++++++------------------------
>  1 file changed, 20 insertions(+), 24 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index cb2de24affdc4..cc1468f68901b 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -3452,13 +3452,13 @@ static void __init hugetlb_hstate_alloc_pages_onenode(struct hstate *h, int nid)
>  			gfp_t gfp_mask = htlb_alloc_mask(h) | __GFP_THISNODE;
>  
>  			folio = only_alloc_fresh_hugetlb_folio(h, gfp_mask, nid,
> -					&node_states[N_MEMORY], NULL);
> +					&node_states[N_MEMORY_COMMON], NULL);
>  			if (!folio && !list_empty(&folio_list) &&
>  			    hugetlb_vmemmap_optimizable(h)) {
>  				prep_and_add_allocated_folios(h, &folio_list);
>  				INIT_LIST_HEAD(&folio_list);
>  				folio = only_alloc_fresh_hugetlb_folio(h, gfp_mask, nid,
> -						&node_states[N_MEMORY], NULL);
> +						&node_states[N_MEMORY_COMMON], NULL);
>  			}
>  			if (!folio)
>  				break;
> @@ -3528,7 +3528,7 @@ static void __init hugetlb_pages_alloc_boot_node(unsigned long start, unsigned l
>  			prep_and_add_allocated_folios(h, &folio_list);
>  			INIT_LIST_HEAD(&folio_list);
>  		}
> -		folio = alloc_pool_huge_folio(h, &node_states[N_MEMORY],
> +		folio = alloc_pool_huge_folio(h, &node_states[N_MEMORY_COMMON],
>  						&node_alloc_noretry, &next_node);
>  		if (!folio)
>  			break;
> @@ -3672,13 +3672,12 @@ static void __init hugetlb_init_hstates(void)
>  
>  	for_each_hstate(h) {
>  		/*
> -		 * Always reset to first_memory_node here, even if
> -		 * next_nid_to_alloc was set before - we can't
> -		 * reference hugetlb_bootmem_nodes after init, and
> -		 * first_memory_node is right for all further allocations.
> +		 * Always reset the allocation cursor here, even if it was set
> +		 * before: hugetlb_bootmem_nodes cannot be referenced after init,
> +		 * and further pool allocations use common memory.
>  		 */
> -		h->next_nid_to_alloc = first_memory_node;
> -		h->next_nid_to_free = first_memory_node;
> +		h->next_nid_to_alloc = first_node_state(N_MEMORY_COMMON);
> +		h->next_nid_to_free = first_node_state(N_MEMORY_COMMON);
>  
>  		/* oversize hugepages were init'ed in early boot */
>  		if (!hstate_is_gigantic(h))
> @@ -3802,23 +3801,21 @@ static int set_max_huge_pages(struct hstate *h, unsigned long count, int nid,
>  	unsigned long allocated;
>  	struct folio *folio;
>  	LIST_HEAD(page_list);
> -	NODEMASK_ALLOC(nodemask_t, node_alloc_noretry, GFP_KERNEL);
> +	NODEMASK_ALLOC(struct nodemask_scratch, scratch, GFP_KERNEL);
>  
> -	/*
> -	 * Bit mask controlling how hard we retry per-node allocations.
> -	 * If we can not allocate the bit mask, do not attempt to allocate
> -	 * the requested huge pages.
> -	 */
> -	if (node_alloc_noretry)
> -		nodes_clear(*node_alloc_noretry);
> -	else
> +	/* Scratch masks for allocation eligibility and per-node retries. */
> +	if (!scratch)
>  		return -ENOMEM;
> +	nodes_clear(scratch->mask2);
>  
>  	/*
>  	 * resize_lock mutex prevents concurrent adjustments to number of
>  	 * pages in hstate via the proc/sysfs interfaces.
>  	 */
>  	mutex_lock(&h->resize_lock);
> +
> +	/* Fresh pool pages come from the ordinary allocation domain. */
> +	nodes_and(scratch->mask1, *nodes_allowed, node_states[N_MEMORY_COMMON]);

For a global request the caller passes &node_states[N_MEMORY], so before this patch
the grow loop read the live mask on every alloc_pool_huge_folio().
Now the mask is sampled once, before the loop.

The loop drops hugetlb_lock and can run for a long time. If a node gets its first
memoroy in that window, the old code would start using it. The new code won't, until
the next write to nr_hugepages.

So the pool can end up uneven, or smaller than requested if the other nodes are full.

I think the nodes_and() should be placed inside the loop to keep the old behavior ?

Best regards,
Richard Cheng.


>  	flush_free_hpage_work(h);
>  	spin_lock_irq(&hugetlb_lock);
>  
> @@ -3855,7 +3852,7 @@ static int set_max_huge_pages(struct hstate *h, unsigned long count, int nid,
>  		if (count > persistent_huge_pages(h)) {
>  			spin_unlock_irq(&hugetlb_lock);
>  			mutex_unlock(&h->resize_lock);
> -			NODEMASK_FREE(node_alloc_noretry);
> +			NODEMASK_FREE(scratch);
>  			return -EINVAL;
>  		}
>  		/* Fall through to decrease pool */
> @@ -3873,7 +3870,7 @@ static int set_max_huge_pages(struct hstate *h, unsigned long count, int nid,
>  	 * within all the constraints specified by the sysctls.
>  	 */
>  	while (h->surplus_huge_pages && count > persistent_huge_pages(h)) {
> -		if (!adjust_pool_surplus(h, nodes_allowed, -1))
> +		if (!adjust_pool_surplus(h, &scratch->mask1, -1))
>  			break;
>  	}
>  
> @@ -3889,9 +3886,8 @@ static int set_max_huge_pages(struct hstate *h, unsigned long count, int nid,
>  		/* yield cpu to avoid soft lockup */
>  		cond_resched();
>  
> -		folio = alloc_pool_huge_folio(h, nodes_allowed,
> -						node_alloc_noretry,
> -						&h->next_nid_to_alloc);
> +		folio = alloc_pool_huge_folio(h, &scratch->mask1, &scratch->mask2,
> +					      &h->next_nid_to_alloc);
>  		if (!folio) {
>  			prep_and_add_allocated_folios(h, &page_list);
>  			spin_lock_irq(&hugetlb_lock);
> @@ -3978,7 +3974,7 @@ static int set_max_huge_pages(struct hstate *h, unsigned long count, int nid,
>  	spin_unlock_irq(&hugetlb_lock);
>  	mutex_unlock(&h->resize_lock);
>  
> -	NODEMASK_FREE(node_alloc_noretry);
> +	NODEMASK_FREE(scratch);
>  
>  	return 0;
>  }
> -- 
> 2.53.1-Meta
> 
> 

