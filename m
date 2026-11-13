Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 074BE606A8B9
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 22:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Vr/oJpzg
Received: by kanga.kvack.org (Postfix)
	id 0AD5D6B05C7; Fri, 13 Nov 2026 17:28:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06D716B05C8; Fri, 13 Nov 2026 17:28:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E77A56B05C9; Fri, 13 Nov 2026 17:28:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B89E36B05C7
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 17:28:00 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3DA1D1A02B5
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 22:28:00 +0000 (UTC)
X-FDA: 85431534720.17.CA4FC48
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010048.outbound.protection.outlook.com [40.93.198.48])
	by imf13.hostedemail.com (Postfix) with ESMTP id 66E712000B
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 22:27:57 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="Vr/oJpzg";
	spf=pass (imf13.hostedemail.com: domain of balbirs@nvidia.com designates 40.93.198.48 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794608877;
	b=rty4ng3iwDvltUVtQ4WgyldxABxCzqYTRGbjk25MjuX3L6nj7E1WL57yIJYO6Z7YNeWU0s
	gd/Cg/VIkECuovXMDuXadHEI7PUQ2aMJ1PDlV0XWVdqDl7lW6KL39DS3ti+p5xYQS+nRxX
	GbdNiaJnQBjOYWVvZbxep4qTVAKdil8=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="Vr/oJpzg";
	spf=pass (imf13.hostedemail.com: domain of balbirs@nvidia.com designates 40.93.198.48 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794608877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jvORmgtlar4uwzXngtnvL5lj/B9H+uZzAb+3mwCvdfE=;
	b=MkE85J/MtwzQVSn00SDVLfQ2PkfaTev7ZFmZvUFS0RGLjesyARLIBkxSZ8cpCTFbePsutn
	Tbeku3LlmmxBXx2RRSIcjtR4oNoVlVt0NVoRwUgiZNNVcjVxJCMsviCa1ni3m6JHpypTGL
	pfzFozt6S0qrKhl7T+lNnijupclp4l8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NsHd5cBUOL+CpAQqGbF9ImjcqXmezOblJTjVdiAODmhXDi/aF0NUDfmnO0dSRh/jqueHHxC4rxUrh9/MVFmZ2qdKDBgPs4sMYT4r2O6Pv4c2+5G1HZgm+Hhu7t2928XrlMfWnTnXKwMphjWLfpuza2WxMvo62cskSupCvMPzD5ENFOr/6xecGGw/JTc4HWiKiiyLq70r3lfOz3hFbUdlZgqraq2vQNjVd29UqkuDmzkEmS78VyP8WlYBTc+94sgH3OfMxMAD6wLn+v/iSzuorS8feYUAcw+croSEMJhCd2e6nIl8VJgEKYEihIp5UdyWCWibxfocKRbAnz+qiaJGBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jvORmgtlar4uwzXngtnvL5lj/B9H+uZzAb+3mwCvdfE=;
 b=IGWdrYwk0nwroJKxG2ZjgTka7viuw9Hrqv6CbBUGLM7JaRE0+XJ6LnlrYNtClnv7hrG3L4fJVSA2CXY+0tHBNSvKaKoezqM19r41Pi5g46pnIc4QtyIP0hbnaoH2t7Oxgd/lnxltxkDBG+TvPOL/B41sFRKEX6PPdoZ+V4EMuU6TAUvg71bDqny2z4wAS7tA58mX/bzsAVK/j4LKpmOaRL81JhlvkhjxCK7fAyH//ntI/48tKEBTLHYJD+NDnMLH0GeZzg0rU1ypCr8uytkS8NK3b8uvwKu8gURVsMDyKFFU5yJR+VjAhKwrRYZW/ORcjj7TxNxYMVZa8QsjPlolyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jvORmgtlar4uwzXngtnvL5lj/B9H+uZzAb+3mwCvdfE=;
 b=Vr/oJpzgzenuvlvTSme04HWmzVBs2fXlODb2EyUQU0w76D4v3B7MEstg5mGVt/iUqElpfp1rDr6FGxES3cI2YcNlVcdZttIBlHG9a8a1P9fZ/M7QTKzpDT4gIdpk68SnmB56F+GwDR1g93OzwKyIAODJfZ4FFdCZca8YEQGVIpfskKOUVMDTbV2YSGPmAVzZqkrtJa+VlrllcVMR6do6PUAN3pV7WDRXn+zYbifHvJt/0NwgRMfvp/M60kR94k/oflo6vYGqdUCc16IBKccqE0xFB9SclgW9VuO3/OtIPI2XYfiyEUW8oVxScI2s2yW4uCvtrBl0q/ZX3g206T0aVA==
Received: from CH3PR12MB9730.namprd12.prod.outlook.com (2603:10b6:610:253::9)
 by PH0PR12MB7095.namprd12.prod.outlook.com (2603:10b6:510:21d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.9; Fri, 13 Nov
 2026 22:20:12 +0000
Received: from CH3PR12MB9730.namprd12.prod.outlook.com
 ([fe80::843d:c1f0:b2ed:4128]) by CH3PR12MB9730.namprd12.prod.outlook.com
 ([fe80::843d:c1f0:b2ed:4128%4]) with mapi id 15.21.0615.009; Fri, 13 Nov 2026
 22:20:12 +0000
Date: Sat, 14 Nov 2026 09:20:07 +1100
From: Balbir Singh <balbirs@nvidia.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Nhat Pham <nphamcs@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Usama Arif <usama.arif@linux.dev>, 
	Kairui Song <kasong@tencent.com>, =?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, 
	Kiryl Shutsemau <kas@kernel.org>, Yu-cheng Yu <yu-cheng.yu@intel.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, Peng Fan <peng.fan@nxp.com>, Josef Bacik <jbacik@fb.com>, 
	Chris Mason <mason@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, "Borislav Petkov (AMD)" <bp@alien8.de>, 
	Mark Brown <broonie@kernel.org>, "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 07/13] mm/migrate_device: look up fault folio after a
 split
Message-ID: <aveLSEIfoHAQH5l5@parvat>
References: <20261113-mason-migrate-et-al-fixes-v2-0-50a2ed382b61@kernel.org>
 <20261113-mason-migrate-et-al-fixes-v2-7-50a2ed382b61@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261113-mason-migrate-et-al-fixes-v2-7-50a2ed382b61@kernel.org>
X-ClientProxiedBy: MEWPR01CA0031.ausprd01.prod.outlook.com
 (2603:10c6:220:1e5::18) To CH3PR12MB9730.namprd12.prod.outlook.com
 (2603:10b6:610:253::9)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9730:EE_|PH0PR12MB7095:EE_
X-MS-Office365-Filtering-Correlation-Id: 5514ea44-3c3e-4b8e-13c4-08df41d44922
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|7416014|376014|23010399003|1800799024|366016|10067099003|261021123027099003|4143699003|11063799006|56012099006|261102123227099003|261022075727099003|261026140227099003|261021135927099003|261022105027099003|261021121427099003|261026121527099003|261028144727099003|261009223027099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
 XKNiy9BmX3mIKkWmAdME40hJWHCgYxvp3dUaGgrQMHf/aDDmf6L4hDiREgMCQCDuVRf//U3Ii/ZUyYhhqEHLBrO5jSuToWArxpgirCSeafZ5B+u7Jv+vyvQzwmOfG7hN9Y6nz+scyR5BJxyo9UcNX2TK4e7U16jPWx1vmrH1lVh9MmqS2DdkgD0E4Cb1IQqmfN1MTl7tKnDDGJuaflLu+J1L5ZWdYVDKzuVZlBtprbK3vzm95/rzFmiFDnooHSLl8IpDwQOyEsa+sQjcZOKiszO4qeuzbvB3L9p49YqFpipHXqUGO0ljE8IIuCq9BcW1/+fnRfRrV7pLJyTpkoKdkDAqEEUxfzB9HfBK0yC4FG/kWZhdLgKU0PpVkJ+kAHUx9z58Bi8anxlaEgxajUAyAtgJcAPcUxiF1rUIBkG3MPAn88Crt0aQF68vtCH/cMF2JM5B8ipdbjot+xHbJTb8kkLkjcMsj2gDOV0j6abwZlJvtiByFiterad1ignow+i0xgqzRE6kr0J3RlKh//Z1hhcYCw2UtpcBBJI530YiGuxOWJpX9rNNsSfaoVNhubOitEQrjBP5bvbAXUDZZa2B1sDDh51BfjLyoW+P/ndmmlRILPQOnI/5YQaQvHL+idvMf6CMXKzq/zIw1xJKoq8QCA1vcpsa0v8Hr5IJXvY9HA8=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9730.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(1800799024)(366016)(10067099003)(261021123027099003)(4143699003)(11063799006)(56012099006)(261102123227099003)(261022075727099003)(261026140227099003)(261021135927099003)(261022105027099003)(261021121427099003)(261026121527099003)(261028144727099003)(261009223027099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?Df81hu6TOC4VORwyFVEAzr7rFo/fFNE3jawdysVAYClsR2r4usI+L2nrmL8X?=
 =?us-ascii?Q?eG3FxS4g6y8P9BbNPMhCrjcjQ/+SyflvwX7Tzd2ftH08Osgcr/58cmjtJRRz?=
 =?us-ascii?Q?tRZDiIhpqJbpE+KvRabiMq98tc9/prwEGKKBIJwiQGMyKDbzbBhsdhRJVJaR?=
 =?us-ascii?Q?ZjCqNdPG6GNUfP+0MQlMhlPDMTTK1GenRtaWVe85y50v/OnBI+xYSNjtobyf?=
 =?us-ascii?Q?47aEYbk6zBTYJD34z7JIoFHKl7T5Fvla2SnMugFZ4F8so5jOuHoV+NJVzLgB?=
 =?us-ascii?Q?gYk0RHbV2zcjqztdV/anB4deHe/NuKGzMqAO7vJaRGhE66W48bOSXiXsvlOY?=
 =?us-ascii?Q?W4wxcpOYkkr7mc1CbXKkIOkniPu4HlqTv9YHIlUp26VLBuIVdsirKnFMTkvo?=
 =?us-ascii?Q?sJBZkp100j7Jfs8NSpnqxbvnZaDaqXYQ6w71SXOUzrL2aKCkEcJ5ZbZQnsXQ?=
 =?us-ascii?Q?l+M+h94G1NATsSDfuIhlJIDLooDmCgFEx1jiP/HlQOTqx6aac2lLfLppHD4Y?=
 =?us-ascii?Q?2lfzevXAUULPE3orMagdHJq0GpmU+IIjkumbWN6zy3oaY/h7sKnP4x3l8+FH?=
 =?us-ascii?Q?IW3sw2oUAdjnHKuVEJYPb2c5ovNREE6MpxJOg7HePsWsskjERkChM1tGBuyS?=
 =?us-ascii?Q?xlanubEoYQMqhubD7tdiBrXxFjLbi0mmQk1vMIbXmQa5dIMhChwZUdJXdg1o?=
 =?us-ascii?Q?rV3B0zGn2CbJiK0JqXewFtgJXsz7SknQO/wNkT/zMPisRNVmOfSUxGaZWvea?=
 =?us-ascii?Q?FIgh6RZw5eHVL7APtkAxWGdQSyclQpAHVOTzBgpam3ffiYIQz7XIHhNnnFPJ?=
 =?us-ascii?Q?Hzj5BhL7vpXEQgx3v5G+1p3G2RQe7CijeGtG3ZaZZAgu8APqZspHE3P6VuA0?=
 =?us-ascii?Q?g0+c5Y+6lI66D6Z+Ag75LU2tMHPUZIGVI9KCaZT5tKFwiI/4mZm1yZ+6P5iB?=
 =?us-ascii?Q?AziPRxUjKJMcuz2LkxjAXddUylk2KLzBjNDHl2XeHunMsQhY+VV3AQMJgut6?=
 =?us-ascii?Q?sCQ/gXkLIscJEcssgC9IpFdRcoT6db0O8jEQE7gVRe021MEMMDelVDWtEd3U?=
 =?us-ascii?Q?N6NQ//ej708lXvg9QLq3wVFAYxt614TDK6bS7ADLipVVy+bCD88GBdq+hkl7?=
 =?us-ascii?Q?wJ99Ql56awozLhT8n7PeWgkhmDq1viCj/ruL84AQdxPOGGHpLO/2aAv7mM7o?=
 =?us-ascii?Q?uQ2jgjAKlp8xj/4eLpLoX49lt1MRgxhbfFRRX6BsMRsyTZWVhREEHq8YwgOP?=
 =?us-ascii?Q?/fOajPKtxQiuGfIa0WTZkczI0R3eCrb/zsHdYFznoyABs9CYCY9un8G5pf1f?=
 =?us-ascii?Q?PKvaTMlR+vbRlg1SLe1hn9zXulR6hIQLmiJuE3ThIZVFZ+omgq4dwR0ptoPh?=
 =?us-ascii?Q?ZW+rnpOggXHHQWOzH6ZbVis32Xb8K6YxRUxvBqN3VnDOFGlhywo2ECTLFXSy?=
 =?us-ascii?Q?NUsftCLxTcRzF0l2CpTaMP2ac67DetH22mB+9ByYbWp8G3somlGAjcLBxG4D?=
 =?us-ascii?Q?MF95JXS/O1QD5u3J3orL+m1G1QTWu9BytmPjZ+5MIYlfV12GKez5qy4lJP2I?=
 =?us-ascii?Q?/tlRj44ZCq1wMUg9HqG9jLT8ug2DU9GA84HkbBdvNeOJo+PnOVoEVH/xo5I/?=
 =?us-ascii?Q?tQsid+YFQU96aaQzstXLBi8grTfvg2YoSqWT+IILDb6PQBis7r28L7yLet1i?=
 =?us-ascii?Q?xBh/nihmzrNbD/0o6a4Hfbq7i7MUVrY0+onvECJajqybC1uAJXD2DZ9CkBMH?=
 =?us-ascii?Q?IHDOyiV04Q=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5514ea44-3c3e-4b8e-13c4-08df41d44922
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9730.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2026 22:20:12.7174
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pwuFPrcLtHkQOrwVr6lxIvd8nBhgnAq++F9osSTVEMrAeB3iZN17RbbtMt3+XovgY/ZX3qjUzxlpUxa+NbMU5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7095
X-OriginatorOrg: Nvidia.com
X-Stat-Signature: tz11wssrzy34z3oh8ax6czfjsdu5xbem
X-Rspamd-Queue-Id: 66E712000B
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794608877-985958
X-HE-Meta: U2FsdGVkX192Y1ukomIhFvxH2+E6BTOFE5PgGhTPBI4qepAGnIX6htWoACZ3/nhwLUPuqk8Gcr1rr/D6OeZSL/eYYDzPCcL5EYv60n4tGFqvZtdF/S3nJHuBJWUtHw+6cBY0Dj4O/hFnjPk8a+W7diFZQ0jQhfCs9T/WjOLyC/ry2DwZirMZufzN5hwVVMO8pYzjJT8F6wwfTMwISGVGTVLViWZM+mTqK5JeSci5p8VlMbIvfWd8la9ztxDfuz+83Mx+VyTrVPuQiDbsYOxXC+c+ycxST6n1nPW/sMWmRBhn6sBsrH+pOEkhz1ztdrCcR2H3RhdBUtKmcCd3g34YLj8F++iDGlSiDpibhYB5t7cYiz0gYY4M6FhUo92RGDrPNnE4aMsa0FQGpcy90z2bTNKO5zEiXRm+nPb3+oQey+jj0r1Fmcln4PemTVxpvTK3AzQu/TShb3cNg6lbYJzuJcU0/YBJzKouCGY78IDjpeJ6jVGmThbsW8W5NQb4WnR7zGCnev2mrCuF2DghXDLIJpETB+dA+fAfWDOInbxYm7HO5ZwT2rShGDqH8BKdfPtjHpDlG/a1JZM1CI2FvMlnKk0613tV5hv8RysEbAJ0CDVm4/8jfj53viFtVJ+CjMzq+8x06XkrbPtMK0FmoyVZ0w7xXUSGyAs2aGz5q9JB2H4NRDmQHm/vIFWXiq/z4CUvGzGFtB/35pN9rWRO2LZ/kKXFik2vf8IOeTf6882+g+0WUax3/EcRh2scER3aVZHUHaudb46MvxE6NZhuSN4bQX2VZEOhhv+YhI1oZJNYXqK7BzNUdNK0VBt5XsGwrIIcHp+J+WPnwBeUyMeX2SIvtFW+dm2Bu6uVqeVoXh8fDQRPz9dgBL5YER7yyDaSwUe06xtH/dNzjr3oijvhjJ10JBG5UZkV5fQUoPI1cajgEpu16kbDyQ5fA6W/z5ki6bh5z4WdOvSf8vr8kC26VJE
 aajYC+Zk
 Ik3OFvYff4dC18mIYKPhW7jrorVra1ln9ikEXcTxi8n9VOPPMXa+IplvP7+YQwpU5DCizS7PdB31bZs2xcRuA1K66cDIKgz927uhYkcn8dyrnCTUlqma4EEHOGF/NItyb48fvAVGjjKmX6vNlJeqVSN/1MO0KXB3z6pn9DqdY2M2T8XPWtIe3Mt7gwNqbqOUflIzkW+Oy2h1sS05y//kLdnKKLqVem/HlCtluSFkytg4ZKFQ1MsLyIlhn6/HaH9sML9NZmkQ1N8oC0BiHABctO9UpOKxz3Dt8QLKx92m8gnRJ1YMxGPJcE4amSNwoFspdBrMLAgYXlMXU472t1e7lOEiqCrzvNQrsf7+YwUJWiT3U9cv1D+JV24xpkQzzvLDXTwZRWiPchdEoikxCpXQvc5iyETDnx89u9k4eJgy2Re9MmEKDLGIq3zM9XrjJHJSL/V7o9tbwYN81Fwd1xwedy/zSaJ5a0ABM3f6jzJquQDysiRqGqkB6oDa+GNk5zilI7mtP2Z/DJCZEfk40NAxlfmjSGlS5+0MIOY/H/tiMbz8dP59d9QGUdzsWgBwDF6eNxfkgjrRbKLEIIdg+Tykjw5K/310POZIPZIhM1Sr1vDQveNSK1QLB/0HaWMGXE0GOPykw9msBtLt8n+AKpSEf0QVQyEu8T0FE0ggK0+mgZcrg3kvjY+Q7speY5w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 13, 2026 at 09:45:25PM +0000, Lorenzo Stoakes (ARM) wrote:
> From: Josef Bacik <josef@toxicpanda.com>
> 
> migrate_vma_collect_pmd() looks up the folio of migrate->fault_page once,
> when it is entered, at which point the folio is locked.
> 
> The fault folio is assumed not to change after this, however if
> migrate_vma_split_folio() splits a PTE-mapped large folio which contains
> the fault page, the fault page ends up in a different folio.
> 
> Resolve the issue by looking up fault_folio again after each restart of the
> walk.
> 
> Fixes: 022a12deda53 ("mm/migrate_device: handle partially mapped folios during collection")
> Cc: stable@vger.kernel.org
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> [ ljs: pared down commit message ]
> Tested-by: Gregory Price (Meta) <gourry@gourry.net>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  mm/migrate_device.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index ae795fdf36f4..45e571dbfb4c 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -233,11 +233,14 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>  	struct mm_struct *mm = vma->vm_mm;
>  	unsigned long addr = start, unmapped = 0;
>  	spinlock_t *ptl;
> -	struct folio *fault_folio = migrate->fault_page ?
> -		page_folio(migrate->fault_page) : NULL;
> +	struct folio *fault_folio;
>  	pte_t *ptep;
>  
>  again:
> +	/* The fault page is in another folio once its folio has been split */
> +	fault_folio = migrate->fault_page ?
> +		page_folio(migrate->fault_page) : NULL;
> +
>  	/* [start, addr) is collected if we get here after splitting a folio */
>  	if (pmd_trans_huge(*pmdp) || !pmd_present(*pmdp)) {
>  		int ret = migrate_vma_collect_huge_pmd(pmdp, addr, end, walk, fault_folio);
>

migrate_vma_split_folio(), already computes the new_fault_folio and gets
the right references and lock, but does not communicate it back

Reviewed-by: Balbir Singh <balbirs@nvidia.com>



