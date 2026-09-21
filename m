Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18741C982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 02:49:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8D816B0103; Sun, 20 Sep 2026 22:49:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E16EF6B0104; Sun, 20 Sep 2026 22:49:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C69826B0105; Sun, 20 Sep 2026 22:49:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 851CB6B0103
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 22:49:33 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E710E8053D
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 02:49:32 +0000 (UTC)
X-FDA: 85236238584.21.DF057D0
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011043.outbound.protection.outlook.com [52.101.62.43])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1958380004
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 02:49:30 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=f37NWxdT;
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.43 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789958970;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hij/2KKCNlote51muLwx013HrVJyOsi46bc0NJ825Qw=;
	b=7KL/xuP2WxObKFIeliTPfCrfcxaCf2VAoiMMzRi0AQ32WpGN9psfTGsvnF4SMfIe5AiWgr
	HxYDh5kHL20OfDp3fhfCwX6YPXZLwDeOsiV2W6He9unZGmmD8OMAVI1CgZYKf6quoJktm9
	/UF6dtQSLEvGaOPpz0T8O3Q8kXk2nMQ=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=f37NWxdT;
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.43 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789958970;
	b=dNZiB6raqXe+KEZS4GapDSy9K48BIYxlZ3YW6H4lGmsbOYxdSyWgrNTmyqm32UsiuMcQ4x
	Ce+ozOuFR1Pmj2TPEH4/3KTHfs78x4QPt6MsPdETenDDDCf6QU6oEiXuIu5XFqS6DRhiED
	O6bPeqrFsKyfDqgTHh8Mz/XlS7o9yso=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bdb4DqomIquX3fni1se5DXdllT8yO8UYksO3Fm3If4TWsUp04wKmGsNnANZNr3ZuFl8pFeYxwLyb7gGDFLhHRQOz+ChNfxhnZqXOCTQP73VAqWGhEr3u0q3iacNjWby3gpJOUFAh9+HVDFRpw6VhWXO9Wy/UXPwWQwbUNRnK1CkuPebTED144mAqcH7U6+SORGCJadjijXjIdlwVZGCMNfsFtWkAPM7ygzz30Z6w6bYXaVg3rKFQa4JQ6lzgbV0x0etkE7pXAXkn3QpdV2jug5iPMNDVUfpyn7cpLXKNw44RNzFN6NYkYlsmumfgzUMIktu+jMSGOIIViEpZlCkoMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hij/2KKCNlote51muLwx013HrVJyOsi46bc0NJ825Qw=;
 b=Kz/fLtoTIF5iYML4qFvWY+Y5FFdI+2GqSMA09mPaT4TaSQxqrsv+OUSxSgLu5mO//hcQZyxpPHVcjFuf2/3B7Xn1wiiV5jeb5TUtLwOTo4IxpeNCIokt0Rld/MWEFGMdXq7tYrU+G/S92vu6NPnYtrNdvV/hTKyxc3+na2hhpllhME4tn+2JdwSWSu/u2DzST5IE7GfcSQpft5MCwpf4sok596mpeQY5OvbLNS3CdUPzEH3eKFm6g2ixUXVLPB7EJAiq1OjEf5Z2/vghQVNjcQE7IXwOlCYmN4a6Yv8SqhHGRk7p80d/qGGSt+FQbpKJnUBpdHchWg79FLfCQYOySg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hij/2KKCNlote51muLwx013HrVJyOsi46bc0NJ825Qw=;
 b=f37NWxdT/m9flf4zObwnELjNshtURZEr8c9Yy8P6JloK4tBwHf3GbhdlSBoyv/v7JinAKqnj+ybG+KxFJ5ww67J8B8PIIjlDBd0FB4uHGkSxE5V/6IrSV4WyigsvOfH1mA071RmTReuQC+oK8iUKL8RhisCkF3PKkevcP1Pd6qseyGb1cgRlcSNo+9wRBQTgFdI5x4C65e0QZmjr83e/atjZzktptMuXJO4Re0Qe/FoPpMEUbz3dKYQGbnZCey3A6e8Tep/IeTbIZ8HtSatUj8C/7RTmR4d77VCee3u+zJm/qKaMOEyiiMtNPOUB1JNyUCcrQQbJzSgxnu04y0Zxig==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DM4PR12MB5843.namprd12.prod.outlook.com (2603:10b6:8:66::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.15; Mon, 21 Sep
 2026 02:49:06 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0428.014; Mon, 21 Sep 2026
 02:49:06 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sun, 20 Sep 2026 22:49:05 -0400
Message-Id: <DLKNHNP6LH59.3MEEBCAJGFEVK@nvidia.com>
Subject: Re: [PATCH v2 2/2] mm/page_alloc: refactor build_node_zonelist()
 out of build_zonelists()
Cc: <linux-kernel@vger.kernel.org>, <kernel-team@meta.com>,
 <akpm@linux-foundation.org>, <david@kernel.org>, <ljs@kernel.org>,
 <liam@infradead.org>, <vbabka@kernel.org>, <rppt@kernel.org>,
 <surenb@google.com>, <mhocko@suse.com>, <brendan.jackman@linux.dev>,
 <hannes@cmpxchg.org>
To: "Gregory Price" <gourry@gourry.net>, <linux-mm@kvack.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.22.0
References: <20260912030424.2889731-1-gourry@gourry.net>
 <20260912030424.2889731-3-gourry@gourry.net>
In-Reply-To: <20260912030424.2889731-3-gourry@gourry.net>
X-ClientProxiedBy: BLAPR05CA0032.namprd05.prod.outlook.com
 (2603:10b6:208:335::13) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DM4PR12MB5843:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b40c5ea-e76a-48f1-03b4-08df178ae76b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|7416014|376014|10067099003|11063799006|18002099003|22082099003|56012099006|4143699003;
X-Microsoft-Antispam-Message-Info:
	g1omLhHN8RmBKkADzInPPvw485V7b+d/IFaX3oi8ng+HO/yafJSqmspMbHKDCfMP/i5fjLZKkd/jXw34MEO1CNt97WF5EZ0kUA6F2wWG3MfK5+ZD0y0xoTtB9UDxAU7ZsmMlvIS3dYAFzBPgefedaOeMF0QEBb2qIW+iKva9PInC/uu2i7CPKkCEkkceL3oDMsHT8X82hDklFT0F8f+JQvEITLFBniToout5NONWE9Y8ryAO69qgbPCn/WhwP3TC8ZIs8h0PEd4KkcZTGmwFkIISLfzD/O7K+UaVC8IkQaSUGgFtNWtAaWl0zM5Vhwa8Ie4xh8kJhOP44rLF5LIQ85ijS/GK/2KLuZdOoAJemvrR8A9B/o08Xkjtsxhirjvfs8eVT6qQjUJzZa156R8HsRJu3AIEWJKR+p6PEWBY25xEqp/XTFFB4B9MJM2A+Vsr9On1xLhg23tP7tQIf/keOo6h0ZVCiVG5TMNpJqvH1oKy7+4j+r+SawExFIs5kBzEN+hvJYfPZa+Hh4KeZ3qF9CFNa3txeYBvT5SAxV9G7NPd2elsyROwdheqLn9fXnIb5h1S+WkyppdMf/B2VkkSBr68CsUfC4X0eQgG+x5tODbGd0aCIb/XFISpSzGiEAI9Dx2jzikCaSGpHJ1QS5DjFjOULDzdAr/8yG48NgGsB3s=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(7416014)(376014)(10067099003)(11063799006)(18002099003)(22082099003)(56012099006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QnBIMEFnQ2w3YkswUkdvYjJwTTVYOHBYMkp4SHlCdUVUeU5RdExjelN1ZDFH?=
 =?utf-8?B?dXJNSUs2ZG55ZXBjTkJYT2NTeUIvMk1OTng1ZkFKeGNEbnJuU3BsKytSQnF5?=
 =?utf-8?B?K1dyNDUwL0JIdjkwckFyRjRYOEhTc3NsMTNZY2NlYTRJT0I2bENFSVUvNjk1?=
 =?utf-8?B?RUNHRHFIV29zb0IxQ2xDb3Z0R01BMHhKN3hrRDNhOVhKQ1lSeUUvSlQxMzBU?=
 =?utf-8?B?S0tHOVIydjc0clA3SnNvQ05NTnJMenl4UU9DNk5pa0hsWG12TSs0Q3dXckE1?=
 =?utf-8?B?UkFnRmQ3djRjV1NVRkR5SVhqeHZpbCttZ09tWG1TL2JkZjdlSE1SY1dQQVEr?=
 =?utf-8?B?VklFd2FxbXpIZFU1TTBsQWovaXBEczhoZ2Nzc0xhT04rSXBSTUxaTGZKU3dx?=
 =?utf-8?B?VTlOSXh0dmtidThqWGk2aFZmTlFvRE9UTzdHNW1uc0dnWUlaUXc1bzcwMUZi?=
 =?utf-8?B?MGQ3aEMwcTN4eUJoVGpOc2t2VUhudFJxOE83WkdjTmwyZG9yZ1lMUWpOdXU3?=
 =?utf-8?B?NVA0TWR4MDdXazJhM1BVODRCdndudVV2MzgzcW1QbVA5RVFNNFkxRFM0SXQz?=
 =?utf-8?B?VWRGMzVjQk5iYi83ZUE0SkpSM0dRaU43MDBSRXRCbFRqWittdlp1Q3doRk1k?=
 =?utf-8?B?WFhnQks0NUprOUw3NTU4VVhYMTdETW1uOHRPN0E4NUNGSTNKd3VyVkZ5MUFs?=
 =?utf-8?B?NWNNcmFnUXF6cDlicFNwS0hiUmhsZWFNNWJXR1VZd1dUYXBxa2ZMQ2NzbVN4?=
 =?utf-8?B?bGUvZTAyUkIyTnVYUFFoeE5DWDFFbjZXT2JiSkxBdU0xWG9PK3pyQkFST2lK?=
 =?utf-8?B?RmMxY1JDV0x5clBGOXhWMnRhMVBGajBlRTg2UmU3LzM5Y3oreDMxOXFBWEx5?=
 =?utf-8?B?TFVTbVpsUWdvOXJRbFRxTVQvSE9vRDk4b3crbi9MeUFORDlkM2NNaE5ZU2tV?=
 =?utf-8?B?UDMxMUNKcUl5c1c1RE5NSFJ1ZlJET2V2UHhYQmVITFd0UzZkd3VxVkFmajRZ?=
 =?utf-8?B?OUlWb3NGMUFWK3FhekQzYzZqcGVUMW9UOGw1anM0ZWVCT2lIZVcrdFJGSlNT?=
 =?utf-8?B?WUY1ZXRiR3dMMjFxMC94d2ZqUC9aMlFxdU02UjhKblcvS1V4UXFIdGR4RVNU?=
 =?utf-8?B?Qk9aMEZmUEc3cWNZaXdWS25uY2xaRER0OFRLbFNhQ21aa3N2WFRzdElRUTVo?=
 =?utf-8?B?MHczY3JHNUpVZWErdUs0d2ZBK1NJRGVFcjJZQURTZGVWQ0gweGI4SmpaVHo3?=
 =?utf-8?B?K2p4anlnbXlzMkUrd0poYnB1NjZzOVY3bzhkZ1BnWjdRWFVHaTB5TGN5clVL?=
 =?utf-8?B?YlBBWmdzbHFLTlZkV0NKVm45VzM0QmdrZ3NEcllKN2pxZ3I2OFZiTWlFT3Rx?=
 =?utf-8?B?WEJ0VkdJOEx5S0M4ODJwNzRCeFpDamE5QmtUWHhVZElMTGVpSWxBb0ZyVG9R?=
 =?utf-8?B?MTR5VXQ1K3ZHYWI3T1JBeCtJUDRhRmZUZXlrWUVzZVVla0d1Z3hKbTB0amhW?=
 =?utf-8?B?dzdaZUxFZG1wYzZ6N0ZIUUlWTTh2MGhTZk5SdHU2Wmh3K0NmYUVKbnJBTTQx?=
 =?utf-8?B?TCtiU3lZbzBCR2d0N3pubWcwQnBBbC96VVgyb212ZDZPQ0llTm1sbTVLcDEy?=
 =?utf-8?B?V3gzNFQxc3E4TGFEUUhySlRxM3FTVDNWdzVCK0hJSElDbGY4bHlRUEVGaDFH?=
 =?utf-8?B?VGxjbW9GdkduRngvMWVWSzRXa0toVXZYNnl1YmloNGVUK2VrRTUrNncxY2RZ?=
 =?utf-8?B?U2RFQ0V4OGp0UDJzaFZFWnVsMVdtVFJhTEU5OEc0MGN5WThyMktMd3BvaG0x?=
 =?utf-8?B?K0E0R2YzWGtaVXJIVzJIWk1MRHlZRHpYMXBpeUNFV0pRUnp4NG56czdLb1po?=
 =?utf-8?B?Y2M4ZTFjYXM2WXV6cjhmTHZEbE44bHcvdGtDNGUwR1NhWTRjRyt1SS9iR2hK?=
 =?utf-8?B?OSt1VFk4VVFuRmhsb2hvcDJVTWJuWjBmNlpyOHNYa3hCU2ZDZVdmRzJzd2h4?=
 =?utf-8?B?S0FoSXFoYzV3ak5IRHEwY3d2SllUMkxSQ2YvNkNaYzlLT2xOVmd2VWxNS2xI?=
 =?utf-8?B?bjZqQ3FTaVQ2TVlpNFFVd1ZQU2pKdEQrMVlFclE1dWdqWGtONmUyN0lMRjF5?=
 =?utf-8?B?d0V2ZUNWZ2lKUjRGcDBDSkpCc3U1Y1FsOEdDcFVSeXR6MXBkckJ5MHU2YnZH?=
 =?utf-8?B?NUwxeU9FK29sYlNnYy9PdWdKZHR0VUZ6M3lpMHA1V3h6czFodjhiaWt0TG1p?=
 =?utf-8?B?LzZRenlvdWFyMU4xSkRwbWMvQlhHbUhVNDJCcDIreUV6QmRrM0RxalV1SmRJ?=
 =?utf-8?Q?iGe9DN+rHzxinIuX6v?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b40c5ea-e76a-48f1-03b4-08df178ae76b
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 02:49:06.7183
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AmhrljpGLGSQ6oOf36zXZMWH4SWA1WMNloZIg+jgX5ssbvBsYDxMCff6A+cuks5G
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5843
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1958380004
X-Stat-Signature: 8c8n5r8rbg1a7c36h9hpqm4s7xjma8ji
X-Rspam-User: 
X-HE-Tag: 1789958969-830851
X-HE-Meta: U2FsdGVkX1/iqA/BoIMi5gMNtqpCPS4OsazTJZNrBxVYH+QXmsxHpTKlM2bk7ZdKsJ/LBoCd+VIstZu6Cmvbx2eEi9CCbKwuIkAbaVayX9FFZshGBmOxzQ1RAyyxjc1V9UoNQ3tkQLdI/hrc5Uy8XnbEhcuTYMGuajEt3T+Ql/o4U4Ae/loBKfM4wbjOofqiBvRAAdmGrkY3iM/evTzA04bNpJkeZ2begau2Y2BKXgrI6XcvE9KKxPylE8dbGkGDuzRO9/HhYIbntsGQGEBjyO6sYnjVqJrhBonK5QXEVOXGf9gQ7rkQfq93GqNQ+9CabCUUGDGl2Nb8wZpZHqlhZmssuqfaM+tz9n3IoBzqNIOAKygcSd/gZdn6IczdEj407vA2i73cbkm9Z0O+kJsZ06sDnDBybUth5TcvrJttH56sVzZ68r2byul2V9ICNUO6BCHM0YrDM5HN/2zQe4Hv/UGMaIX+zpNs+ltdi/Q0RCf9nqSWJ1ZmaDi1njZ7+rCULMBWTlF29AvT9axYfIK5Lzw58ffHzGHXdQFe1OUhharxSkCitVAY+Ym/yjUGUBFtlINvfxbTQjuiShHbM9KOnPv4TLfBekcu2dJsDFob1rbZb9QQb51b793P1vCFCdvauBjoQdyKHGobmCdb5u8CDxu5j5uTNsovhhioSTIdyY8pgQsz3zpjyW4Aj7HHOP9nEdwkK/p1EZy4EQJEiRjS+JhlqcW41Qg4oTCInay6g8aniP95o/zFHxs0YxPeRgW8O24Qcrw8fQYl3Wmj/e/YCb/eYOD/eauUPE0vAmFKISA8nBYVzJTXjzh2DeB2uGFvA8iT7QFqf6gFnLjQW+UJSO8r0R+6Gw8drD4t6uqfggNMXrIOf52d0LiX/axo6k+9re7aC1wy5+CZb4MD3ixzPD1fZLzQ+rtAv9N/TnDUy0hTdx8Lyd5Ut1/C0D0R+rhrDGfSYQIvFR+snpt9Ac6
 G2LSnfZi
 XgaeL2y2lq2haSI8r4F9mcOrfQI92jScav8yAIy7kmM+7VPY6wotQINNfSjcfGhVQV9aXg6/igPe7olt5HHGBuyFtq61UzUiGyrm1yj01sqhmG8Aj/78+Q0/bjK7zrLkJDU80wuhZzXtwEAs/bAV8+xbXnqfM2vYjpPnduY999K+TfnzJChtMojfL4B7eMreYvOQELU/FcoP9xmGSREYCHBHohorsrrFHTAicyB+3ESorKqeFIwT0JpmdJT6tLUtAX3c0K7zMDr/nvX8n6QLsMMZPXEBA+WkmW72cBMpEHvYUwWcSoth05c7r9elvXF5MENqeECCNpUB/bFejLE/LjEN0TMM9oaMNt6rGegABvpipqdQqFrsTs1bWkCd71p0sTWGVh0DMG9Ag3hhn6DXPXNo2bkT+QmzcdHH1VsKp4K1SjhEipWKLixzFJlX2dx1shnuZH73BaAYcLnY0JA63Wyka3qf7b5VH5Yci
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Sep 11, 2026 at 11:04 PM EDT, Gregory Price wrote:
> Extract per-node fallback-list construction into build_node_zonelist().
> Build each selected node directly into the destination zonelist so no
> intermediate node_order array or node count is needed. Print the fallback
> order as each node is added.
>
> This lets us build new zonelists from candidate nodemasks instead of just
> the default N_MEMORY node state list.
>
> No functional change: build_zonelists() builds and prints the same FALLBA=
CK
> list over N_MEMORY with node_load updates as before.
>
> Signed-off-by: Gregory Price <gourry@gourry.net>
> ---
>  mm/page_alloc.c | 63 ++++++++++++++++++-------------------------------
>  1 file changed, 23 insertions(+), 40 deletions(-)
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 7efce139d562..d1888d5630e0 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5857,31 +5857,6 @@ int find_next_best_node_in(int node, nodemask_t *u=
sed_node_mask,
>  }
> =20
> =20
> -/*
> - * Build zonelists ordered by node and zones within node.
> - * This results in maximum locality--normal zone overflows into local
> - * DMA zone, if any--but risks exhausting DMA zone.
> - */
> -static void build_zonelists_in_node_order(pg_data_t *pgdat, int *node_or=
der,
> -		unsigned nr_nodes)
> -{
> -	struct zoneref *zonerefs;
> -	int i;
> -
> -	zonerefs =3D pgdat->node_zonelists[ZONELIST_FALLBACK]._zonerefs;
> -
> -	for (i =3D 0; i < nr_nodes; i++) {
> -		int nr_zones;
> -
> -		pg_data_t *node =3D NODE_DATA(node_order[i]);
> -
> -		nr_zones =3D build_zonerefs_node(node, zonerefs);
> -		zonerefs +=3D nr_zones;
> -	}
> -	zonerefs->zone =3D NULL;
> -	zonerefs->zone_idx =3D 0;
> -}
> -
>  /*
>   * Build __GFP_THISNODE zonelists
>   */
> @@ -5897,20 +5872,24 @@ static void build_thisnode_zonelists(pg_data_t *p=
gdat)
>  	zonerefs->zone_idx =3D 0;
>  }
> =20
> -static void build_zonelists(pg_data_t *pgdat)
> +/*
> + * Build one zonelist ordered by node and zones within node. This result=
s in
> + * maximum locality--normal zone overflows into local DMA zone, if any--=
but
> + * risks exhausting DMA zone.
> + */
> +static void build_node_zonelist(pg_data_t *pgdat, const nodemask_t *cand=
idates,
> +				int zlidx)
>  {
> -	static int node_order[MAX_NUMNODES];
> -	int node, nr_nodes =3D 0;
> +	struct zoneref *zonerefs =3D pgdat->node_zonelists[zlidx]._zonerefs;

Why does build_node_zonelist() need to have a new zlidx instead of using
ZONELIST_FALLBACK like build_zonelists_in_node_order() did?

>  	nodemask_t used_mask =3D NODE_MASK_NONE;
> -	int local_node, prev_node;
> +	int local_node =3D pgdat->node_id;
> +	int prev_node =3D local_node;
> +	int node;
> =20
> -	/* NUMA-aware ordering of nodes */
> -	local_node =3D pgdat->node_id;
> -	prev_node =3D local_node;
> +	pr_info("Fallback order for Node %d: ", local_node);
> =20
> -	memset(node_order, 0, sizeof(node_order));
>  	while ((node =3D find_next_best_node_in(local_node, &used_mask,
> -					      &node_states[N_MEMORY])) >=3D 0) {
> +					      candidates)) >=3D 0) {
>  		/*
>  		 * We don't want to pressure a particular node.
>  		 * So adding penalty to the first node in same
> @@ -5920,18 +5899,22 @@ static void build_zonelists(pg_data_t *pgdat)
>  		    node_distance(local_node, prev_node))
>  			node_load[node] +=3D 1;
> =20
> -		node_order[nr_nodes++] =3D node;
> +		zonerefs +=3D build_zonerefs_node(NODE_DATA(node), zonerefs);
> +		pr_cont("%d ", node);
>  		prev_node =3D node;
>  	}
> =20
> -	build_zonelists_in_node_order(pgdat, node_order, nr_nodes);
> -	build_thisnode_zonelists(pgdat);
> -	pr_info("Fallback order for Node %d: ", local_node);
> -	for (node =3D 0; node < nr_nodes; node++)
> -		pr_cont("%d ", node_order[node]);
> +	zonerefs->zone =3D NULL;
> +	zonerefs->zone_idx =3D 0;
>  	pr_cont("\n");
>  }
> =20
> +static void build_zonelists(pg_data_t *pgdat)
> +{
> +	build_node_zonelist(pgdat, &node_states[N_MEMORY], ZONELIST_FALLBACK);
> +	build_thisnode_zonelists(pgdat);

If build_thisnode_zonelists() means ZONELIST_NOFALLBACK, why
cannot build_node_zonelist() imply ZONELIST_FALLBACK?

> +}
> +
>  #ifdef CONFIG_HAVE_MEMORYLESS_NODES
>  /*
>   * Return node id of node used for "local" allocations.


--=20
Best Regards,
Yan, Zi


