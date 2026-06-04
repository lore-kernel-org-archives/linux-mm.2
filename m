Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB9F3CD6E4A
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 02:53:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 139536B0005; Wed,  3 Jun 2026 22:53:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E5706B008A; Wed,  3 Jun 2026 22:53:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEEB56B0092; Wed,  3 Jun 2026 22:53:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CD1576B0005
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 22:53:25 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6E200C2122
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 02:53:25 +0000 (UTC)
X-FDA: 84840709170.28.4658453
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010033.outbound.protection.outlook.com [52.101.46.33])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2136940013;
	Thu,  4 Jun 2026 02:53:21 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=b2KjSmQO;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of jhubbard@nvidia.com designates 52.101.46.33 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780541602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=D7iwQjJul7D/mo+oVjmvN8jhb35E/8AJYgImMf54Jg0=;
	b=oxU0XtzAiXb5NqDtFOFPN5DBikN4Nfrj/S5TLJfnGPjM4GR5NQIs6eZ/iYsQQi/Ni/Jwmx
	UmIEBhGgPLFuTO6rJ3904pE3eHR+Vu6vDPsSm6+HHm0Gk/hsfe6zh5uyHMTZu7wLDeKR7Q
	OHnXnAZhVl4RWzTdXgV0+IHFVKRbyHY=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=b2KjSmQO;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of jhubbard@nvidia.com designates 52.101.46.33 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780541602;
	b=HNwb5BnESdYzyyo0rjSatoDZX7kzzBb1x/Ti3iwBYdzZyy93VjzhSCiETGEv49u5cweyEm
	bjiVh7ukvkRiFoelIyQsHr5Rrqg1w3ArmY2ltHQqEgNy2GDvVQMYfCRMcuU0nVkNBXI3py
	5rDMc5E/t/SfDhFe7oYa5k4Bn0Vlgmc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oR0EAFNrDZQF77/t/yAY3zGrCFS6IIdO4Z0Wm/KT3HDxDKEHEdxUAunHK1gr5n9trTNpovNwQKytPMSpQftJjNOHgcdFPnPLN/jh2fx3426c0mKKsBQYiz1cNVgvK8Vvyo/5LvYiWXKzKjjZpLFDIrkWMNxXkb0cC2hQlwTqJlNR7wbV7omSrOP/ufMrWyJBD00JwBL0w2z2sG9DNsC7p9+Mxtej2NNTIMoDBxNUCSpmmMeIn7E9HY9HHx0rDRAeaKk9tHowqyE+ddl2j2e5MM+a03ltsMCD0oQJYxPIPe2slwO+CzG01TDHtpCI3eb9lLCJh3OuzUJKbrx4gEow3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D7iwQjJul7D/mo+oVjmvN8jhb35E/8AJYgImMf54Jg0=;
 b=frtyjL77mv1n3KBkWCdrIBqUyqMM15WzucdfV4Uk40q0SAw0v4c4dUOZysjiQnPakUQlNsH7PiTqji693BAa17xWwzT6gVCYNXFDKDtOZJRuKSf7a/RhYAQT6tZC2nQFFBbvRLqJJhzOUHUVcbjutlyq3Mft+Lofq25sAJAr00DvrY5S7VRsc7wXzJF5g87Hd7Js1nN1/BbZ7oP0yi9g/ALx2F0IsbUI43gy5xQvT/evaoXD3CGWs5mSMoViAagOXv5QDCZCP+0U9UtoUUUrhs7nT76pS63K0dxeRsQBLM6dZyldEljEZLoJ0xIysc7FlBfnenb5rEIQjYM53Hx1eA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D7iwQjJul7D/mo+oVjmvN8jhb35E/8AJYgImMf54Jg0=;
 b=b2KjSmQOIuGy+AGFdhACtmAAt5vEL3St4PAFr1x9d3mZUinkW0InI9KsqE8bC1xENmDR6NLL7qPiXU9l7l1oEDO6L7U6lKUwXru4mmGSp4UyILFDbAh12ApwrTLxpKlqjYc5+Tq27hE8OIN65Jxgqawk9cpBMia4H/jkl6ABuT/5uF1clvkdnvtgU71FW/biLZFoTujcUj3vXPJZbQpju7yplMPNOK9zSXQJGFrutPiRr68l/R3vOMIwlELbjfe+LDt6ipU+zfZygdVrnU+wKeS3BMugIw1B6D0zMfyHy30EonZXlXgs3L7DLNt9LA/Wmyjpvm8qeGj11VWJF6Z7UA==
Received: from DM3PR12MB9416.namprd12.prod.outlook.com (2603:10b6:0:4b::8) by
 LV2PR12MB999072.namprd12.prod.outlook.com (2603:10b6:408:354::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.7; Thu, 4 Jun 2026
 02:53:18 +0000
Received: from DM3PR12MB9416.namprd12.prod.outlook.com
 ([fe80::8cdd:504c:7d2a:59c8]) by DM3PR12MB9416.namprd12.prod.outlook.com
 ([fe80::8cdd:504c:7d2a:59c8%5]) with mapi id 15.21.0092.006; Thu, 4 Jun 2026
 02:53:18 +0000
From: John Hubbard <jhubbard@nvidia.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>,
	Kees Cook <kees@kernel.org>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Chia-Lin Kao <acelan.kao@canonical.com>,
	Benjamin LaHaise <bcrl@kvack.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Jens Axboe <axboe@kernel.dk>,
	linux-fsdevel@vger.kernel.org,
	linux-aio@kvack.org,
	linux-mm@kvack.org,
	kvm@vger.kernel.org,
	linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org,
	LKML <linux-kernel@vger.kernel.org>,
	John Hubbard <jhubbard@nvidia.com>
Subject: [PATCH v3 0/2] libfs: set SB_I_NOEXEC and SB_I_NODEV in init_pseudo()
Date: Wed,  3 Jun 2026 19:53:13 -0700
Message-ID: <20260604025315.245910-1-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.54.0
X-NVConfidentiality: public
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0022.namprd05.prod.outlook.com
 (2603:10b6:a03:254::27) To DM3PR12MB9416.namprd12.prod.outlook.com
 (2603:10b6:0:4b::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR12MB9416:EE_|LV2PR12MB999072:EE_
X-MS-Office365-Filtering-Correlation-Id: 21f0b36f-c797-4de1-2322-08dec1e46e46
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|11063799006|56012099006|5023799004|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	udmKxmgAJ8vhgt7aSyDaByNxIia/g5xDQbvEUT1gS33rjuhYRCXbVQ29YLu8P7GozkQ7GIxijWCrllgY175PjeKiYfin6vwSd7Txh2iHhDBWbV0uRbiMhqiSnweMwX12C8n7K5gXokZHp6v9gCZnPyC+unKnseh4paN8sJqBW+7AA5MiCP2HLIADNe3VD6GzNrJFBZHVr7JaZ0kjI1z4CcHW2nv8bf64N4bh1+5gMSyajabrrQ3MZ8tT6Ip4/Pl1sZBFweo7i13qHvjAM0RgnBaSpE1jE5VLSDIJld7Z1DfsJ9U7ZBQ6itEp/s09ml0uemnysItJhvixJ/b60rX55mpVg2PC/tQYjpRSZlrURdigyTeuqF0V4zQmR9icnki4g0EwQXmBtLpXFp0PhSlEFgcL6QzmHJ3NDMFIzEVhnemT00wCgjScE2elFAZh79/tw2WI1XKQ846dZVEVWtJnC5+lAnhw5mA8DIISzpOaRiPNWEkOe6L9+nW3pD6tEjtVioz9E6/kOCp+3N8dCfrCYFuFEpbjZswMPRHbWbqCqS66hi3fFPCawHjDcvdKSQc9C8BZsUXoyJZZM1/19XDfqnwkSdhOvCyjJF1sv1xoER/b9xY3FgWFmBhZ2XRjmXeQW/gxaacDhlBUfD88Kf3+Jlq2u8vV+Vmy4lZtOPRGa7441/d0NpMX7AY2Id8QUlBF
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR12MB9416.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(11063799006)(56012099006)(5023799004)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wKClCMaHdIy+ubf2vEBOSr2FHcgDOcBUqLz19nw0m1ZvyNZoXfzgupY5Do2g?=
 =?us-ascii?Q?8FWhnxMZBorNODZ1vW6sKIH92mOowRNqPlNzqzEBdMtGL5VL75p6L9Mn2ppL?=
 =?us-ascii?Q?BvjxTTuwtDcI55Lo18Lbmo1Jz3r9rWkQihAQVm+GIX5heDYdtaa6JFo5HXUe?=
 =?us-ascii?Q?SQj+rLxJ4ow66xDsKrySZH6/0wNOFB/dLgC/qqf6+xWuB0Rp+9E1pHtsX9Rt?=
 =?us-ascii?Q?32QWb7fCXhM0ks+/saA6eHXd8J7Jhz744rU7GECZ7fh3G7EhhFlUfaLi1XlV?=
 =?us-ascii?Q?N78s1nIyLGPdnzF0Ct7yxMCgo6AmS5XCeI71YTqm/Vvfgs+/M7RxScwYVSqG?=
 =?us-ascii?Q?MKAVfkP7Oq/H9c1SAU5JLTS/kgDygFyqYdj+DpkkKWBvfAHSUciX2ZxSxLIG?=
 =?us-ascii?Q?RSbkRr6wC8DpOtlJPuWQmupd7wEI/sdtX2QqQ5yRp1uU8LzhbgGjmKop/XW3?=
 =?us-ascii?Q?D2pBNq3UQePwchI0BIa2JU1tepVz7qEpOs007NziCMUM1Vd+LgeKPtOUXH5W?=
 =?us-ascii?Q?9Mm5H+IIASkPc6vYLUOfkZje4sN8or5oiVME/Hf610yo8m+s6gCIS1ng2LAY?=
 =?us-ascii?Q?mg8mcbBI772P0AShJz7I5RIgBGiyEMnW+iulE5ku36UQqqDk1G1hOGwRdwL9?=
 =?us-ascii?Q?Hgz5zVXMUKNeeNf1RwJUpnYqps5+WjTH095tTIuUDL/WmKyq18bu6h5iQJIs?=
 =?us-ascii?Q?4k3O0AOZli1zxb5RAd7nk+HahVL0rY4ioYwZ+b/A0YY8G935+UAYO4XQ3GbT?=
 =?us-ascii?Q?/tNPVW1Nhvbm+1VzvAdMkwxx+Ywp0e0MplIYbQNmrRdr6K4AsRx16YwTRRuN?=
 =?us-ascii?Q?xrSlcFpxpy6fu3JTpDoAf1Or/v9qaO82xLA/WS4VDjAf8V29thZtFWoO/5Ug?=
 =?us-ascii?Q?JZ1MmLUWm44YumVwgvLhNjdZ2IqzaQN8jaLLlAFVJZFqtt2RGtHMRzPJ4WHp?=
 =?us-ascii?Q?hi3zswQRzTLoGOHWbyOdsaDH72VlnW42CrMYw9cenFi92zxDZVjYwA5R2Dyn?=
 =?us-ascii?Q?Hh5ZnaFqHiwe4XVGkmy2cInrt5F+sLFKcqQFqKBdwPxoSef7T1Uo5hu7lqgV?=
 =?us-ascii?Q?NXKDJnd6o2i7EYMcorCoNkTeMGrNHhC9wqiidzGIaANOm4JB1cOm9iC8B4ZE?=
 =?us-ascii?Q?ZY/QKF+GAuKCaggdrvSCrnOkByUmGlxorucR3gVxsQMdKyfRXNql4fWEHVUA?=
 =?us-ascii?Q?Vm/d3LMmI82VKDlLXv5UlRxN0Bz07GB67E8kNqZ/4xjSOydLb2xo+CbaM6mF?=
 =?us-ascii?Q?n81dhi4kf7T9AvU2sZqa5vWYCMkGPULtLe5sR6nLpCkIwYfaXlVZ3G8omIiN?=
 =?us-ascii?Q?43srmd8LQ4IYO/35t2vUeOk9QF84mJWIJjovu7p0oVjDzZ/4wNSjG5NkJQvp?=
 =?us-ascii?Q?aFfuh88cQRJ0BwFj0HcJBXyCu6bx0x+aUZaU359OxWt2KphFluvAH7elo5iJ?=
 =?us-ascii?Q?dYYb0HZYLDPW1MsfEREGVGsyjPLutqBoZajGoD/Be+6Hk/RehbmE6zHTDL2Z?=
 =?us-ascii?Q?EX4+X/hDH8Lh3STDuLaNs81VVu+P+D2/AW/3IIr7lZlVXnMbXC916ycNSAdU?=
 =?us-ascii?Q?zrp8qTIskF9jZiGdQk/OyIDxTPiJbx+v8gLXdK0I/aZktvq7/pu9YMGkE57/?=
 =?us-ascii?Q?kaSnn20LlRritE5pVT1Mg3J6jF2oU3b5PjSbkg5XDVTEKEtAb22+3n1dqi4m?=
 =?us-ascii?Q?Tg2/LITyqs5WHfpkmbIQS0BnOVpZSHjN66slxUs/WjyjwwURR0wf/cUZUR4u?=
 =?us-ascii?Q?hHWBDEqVsg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21f0b36f-c797-4de1-2322-08dec1e46e46
X-MS-Exchange-CrossTenant-AuthSource: DM3PR12MB9416.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2026 02:53:18.1716
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K10zNyVT9yI7I1nfKySKWlUxINtMl3mqiabKBR6pMRKhQp303N0EJh+wnC5Jk8jZzFAh+ZOmRmV3Xt8NquTEsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB999072
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: py7xw4qmschsoo79rxbt536xfaidjrq1
X-Rspamd-Queue-Id: 2136940013
X-HE-Tag: 1780541601-164423
X-HE-Meta: U2FsdGVkX19PyxPUJcfrOnIypV82yaUEKZpLJiBSqJqfUCnA8FFcQPDYsInS7acznCQWYpPmLcDr80+7CNGL/jIgFmJlsz8qnWkxcu+KQPfSYZ3EyCTtK2sBfsAYCeiHgoVpAKF3qWWQwW7SapOpRdZVPiVdF6N0ffP3ULW0aurhF1Pi2hSCt7pwkv9evVGtsPuMIYbf/EW+fpED9KXeH84xdNXyuokO1ZDypUYK+O7JPDnLjaHXWvvJ4WXxwOUI8zXvo91k21csdCrb18616+b7DO16y42VUmhYZcW+a8kwUdBXSFHK+UbHM9IY6CYkuFfIlgfmMymqugETqiDTKkgDAc4gwmx5GK3o3r1A43RRhL6WB6+KOspFx8hHX2vSa2oKSu9xTjf3g2YM0ayoxfeVnoJbuBqbXq2VhvqWji2GDDkyxjXae/h6cHgJyKppPU0WuFbNUlrgE7Sw4EJkO/hs8XJvg3CZrYWVhqEj7i+3lPUtsZLFQZxzxEtQnSOsnRiEnWUD4fa2gEvZs5UF5u73wHZpE6san4hvav+ImyC3QszZziXUGgwTsECsIBT8imGQVn6Q2cHU14Z1cT3l10/t5All6pH2fo0BCr8Ez2YDof0gF32tdrE0kImjRsSGDYshfZXbE31RTKVOdr5uxEgN8sS6rKkX2dPSOKq9NTj+I3320A4+wBn/rYYtfMF+h0qYXBOA9UHYi7jA1Tl3fTe5CXG+nHhUW6LkioEBvLhLGYPDuIWk+Tcd4Q0JN/Z87YQScVvdKh/oo9U/rY/YQGXcag6K6hDc+WXTLe1GAH2gsg9ivPDKxemUdCDNMb+mOseYFgQ3no4/QwcYd+8Ajjke7k6N0QrxSLek6r+/oY/ExmaMJKD2EuwvALETG/+AkdgBNPAsf26BmKugrzZEui7RWJDJKWoS/wMgJ4NGMKZH58zj/hyNifQLW7EQxtW05XFFmjalirRDc2b2+YS
 WkyigplK
 2Or3WHn2Dn6oeZiVvTLTv0Fsv4LziFdzLGnVNSCv33vjusq1ftRO2ZndI9G6b7Ymc6uRuo1DYBYeEArb3hHu4PeQA0ZsAsJ1ebewAl0qKxcQErSpIf6JAXoCetSLwX4Ai+m/p9NU8pZLMqV7wx8Gkff9zZiwfi6hUsXpfUA7VOnfbZzhlUtZjw0WbEj+IrvMs4QJUjmXGnMnAaJJkztPRTRNwi89BzsC+yiRcAgh7Cid6fNVZH38ZAihmjFHWj0rV/N+pZ2RFD9IUN44qQJlBvlJaxnNTAu3e8ztDcXZ9GXbDOEiyiOdNzlDZFzQmu/Nh40l0PZ6VTeUj3dT9vsw43LFLZr+oKfrJ1TCqnOP/hY9WTT7TBdP1BBnop8zbgTicxCGlcLqT/fk19mOI8PeeYOUz31tHvKEaOWw8VqbmMnl/V6dPBIvDW+FnYs9qCx0oFzm7k9EdZW6oIYodk/DmivuJi6n0+fu0cw6CHOSRASR9D+tm2N6+LdiKZKO0ce2/thag
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This began as a one-line dma-buf fix for a path_noexec() warning added
by commit 1e7ab6f67824 ("anon_inode: rework assertions"). Christoph
pointed out that the fix belongs higher up: a pseudo filesystem has no
reason not to set SB_I_NOEXEC by default. This series does that.

  * Patch 1 sets both flags in init_pseudo(), so every pseudo
    filesystem gets them. This is the only patch that changes a flag,
    and the only one with Fixes:/Cc: stable.

  * Patch 2 drops the assignments that are now redundant in the callers
    that set them by hand.

Most callers already set one or both flags. I audited every
init_pseudo() caller. Here is what patch 1 actually changes for each.
The only visible effect is on dma-buf, where SB_I_NOEXEC silences the
warning. SB_I_NODEV is never consulted on these SB_NOUSER mounts, and
none of the callers that gain SB_I_NOEXEC are executed from.

  caller                       had        patch 1 adds
  ---------------------------  --------   --------------
  fs/anon_inodes.c             both       nothing new
  mm/secretmem.c               both       nothing new
  virt/kvm/guest_memfd.c       both       nothing new
  fs/nsfs.c                    both       nothing new
  fs/pidfs.c                   both       nothing new
  fs/aio.c                     NOEXEC     NODEV
  drivers/dma-buf/dma-buf.c    neither    NOEXEC + NODEV
  net/socket.c                 neither    NOEXEC + NODEV
  fs/pipe.c                    neither    NOEXEC + NODEV
  kernel/resource.c            neither    NOEXEC + NODEV
  fs/erofs/super.c             neither    NOEXEC + NODEV
  fs/btrfs/tests/...           neither    NOEXEC + NODEV
  drivers/vfio/vfio_main.c     neither    NOEXEC + NODEV
  drivers/gpu/drm/drm_drv.c    neither    NOEXEC + NODEV
  drivers/dax/super.c          neither    NOEXEC + NODEV
  block/bdev.c                 neither    NOEXEC + NODEV

John Hubbard (2):
  libfs: set SB_I_NOEXEC and SB_I_NODEV by default in init_pseudo()
  libfs: drop redundant SB_I_NOEXEC/SB_I_NODEV in init_pseudo() callers

 fs/aio.c               | 1 -
 fs/anon_inodes.c       | 2 --
 fs/libfs.c             | 1 +
 fs/nsfs.c              | 1 -
 fs/pidfs.c             | 2 --
 mm/secretmem.c         | 2 --
 virt/kvm/guest_memfd.c | 2 --
 7 files changed, 1 insertion(+), 10 deletions(-)


base-commit: ba3e43a9e601636f5edb54e259a74f96ca3b8fd8
-- 
2.54.0


