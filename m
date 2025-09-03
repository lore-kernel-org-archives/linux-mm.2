Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E05B8CA0FF2
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 12:29:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 142258E0001; Wed,  3 Sep 2025 08:29:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F2D88E000B; Wed,  3 Sep 2025 08:29:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F03208E0001; Wed,  3 Sep 2025 08:29:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DAE2A8E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 08:29:08 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B2453BA901
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 12:29:08 +0000 (UTC)
X-FDA: 83847868776.15.4270AC4
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2083.outbound.protection.outlook.com [40.107.94.83])
	by imf17.hostedemail.com (Postfix) with ESMTP id E50C84001A
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 12:29:05 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=QcZOFYQW;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of jgg@nvidia.com designates 40.107.94.83 as permitted sender) smtp.mailfrom=jgg@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756902546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VsFxHt6bCE/g1j9WUSGZzHtfgIgT9HYpEelVPgqLong=;
	b=iXzBfpfzCtudgoTNrYlW3ILsVnVKOvEqGZ+I0SJAuEQ5ybRP2eFaGF++EhaG5kfb7/xXY2
	S1YEJhTnGi/fZzvWZDdrInjS3uQijrR6sAr8RhEP30APVkk/as9tD+hKxUbM8UxlzpBNVz
	iS/fGTfCHNzPcnZAGjBRq/oyEuB4i94=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=QcZOFYQW;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of jgg@nvidia.com designates 40.107.94.83 as permitted sender) smtp.mailfrom=jgg@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756902546; a=rsa-sha256;
	cv=pass;
	b=Td3dSQ8Uz9zrGAssMpbQ/FNhV4rXycurvQoGaMkE8+ckYnx8eUOvMB6zmbzd9QkOZa/70F
	7rBFD+osluAx9ijujBL2e4D01sXRzWeVDw7e3SX2/c/YvD4fSP/O+ZDUxvnplmDEAmKouZ
	CAM40CvOkvYaCfYaRpcC41EBn7lXBPo=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MJpjB/VRn6EZrvRmAFbbEhNSk01+C2pxwwUPDz2E0edgwbu2I8olh928eHRPimsSbz8z40IcN+/X+YHnwplme0V737Kz8Y7E/ugYe2ygioWluxl5POE/jpfIxn6rqcpE8ndi5SZRHTSH9xBfZ56fIQx5T1gYnZ7yT+IeGpH70GLnI9kKPNC6P3NQKhbI5hneXC9FYHwK5qOWlYM3BkhNPAXMCCHIXoekV9ra7VoFzHyz3eQozhmsnf6pOdZRW/ystVjWbuH0Y1dAqOTlXhxFGkme8yMktdNKjyyUtNuYDzV9+9bzv1+YvsongieCaTysC+UYdHn2iu+ycAqFsr2RAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VsFxHt6bCE/g1j9WUSGZzHtfgIgT9HYpEelVPgqLong=;
 b=c+RQMJra+Hfg7egp1+vA1+CJyYKDzllD3+qUFP8D7IKMj9+0ysFUBDF2teJ0l62oFihrF2bifr5+pan/Pv/qNBw+jVmXLySRsGFfbt8ZJwu8QDkmH44I28gdu5Yqgs1LMW7V42ICtn5Xcbbuxe20zKqhBQgJd45zQps78hi26nCZfm019SZiFE/Qma6TcIZ18f353b4XobOyHnnLS8r/NyIZuP6XB2hXOQ/XezFwsDVuUs8i7Kto89tEP8Z/S9cKgVfRM+W9K4hBn8e1IN9pbIX4CwSdaFKFOyShdwmUWT7Zb97ARg7d8pcYrPE6OmA0whR8vHA0UDpzhgzVG2/v2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VsFxHt6bCE/g1j9WUSGZzHtfgIgT9HYpEelVPgqLong=;
 b=QcZOFYQWNtpEPDQ8F3LdRboZyPjM+m7DGQiUCZl5hY3wc9p7CNaIWKlhuH8GZtyZjW24RqBTVvCe6aDsvnP1hRTLDVVluVwgbyecoivKUvlH6DxVU5/9pNrZWV1nJyFiQdJqzQm8KSgauQh0ACY8F7dy2tvBBpJyYZGce0mHUXoGC0Z/x4hEJvbrpiijrOzFSyDzzQY6jHwkDIrs8mOVNfoGtAh6Mc5Ej9ymNnI5i5kD4SZqWkyB/GOHp50HqOD1aeJXiRs+/uWEZKjkr0dVRk81DjXRkulRrCZOXbfLejP6MJCNmJnev7c9pH4ZmnwU/VbO5bbyIGzCe7TRH1/5BQ==
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by DS7PR12MB8324.namprd12.prod.outlook.com (2603:10b6:8:ec::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9094.16; Wed, 3 Sep 2025 12:29:00 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9073.026; Wed, 3 Sep 2025
 12:29:00 +0000
Date: Wed, 3 Sep 2025 09:28:58 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>, linux-mm@kvack.org
Subject: Re: Where to put page->memdesc initially
Message-ID: <20250903122858.GE470103@nvidia.com>
References: <aLc_nckaDc2ePRv7@casper.infradead.org>
 <bfd5161e-c76e-4a0e-bc1a-bf7510868827@redhat.com>
 <aLdcPeb8zrfDwd2p@casper.infradead.org>
 <20250902211514.GQ186519@nvidia.com>
 <aLd8l8v_DL75NU43@casper.infradead.org>
 <20250902235740.GD470103@nvidia.com>
 <aLfIEKLqpe_xB7mW@casper.infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aLfIEKLqpe_xB7mW@casper.infradead.org>
X-ClientProxiedBy: YT1PR01CA0123.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2c::32) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|DS7PR12MB8324:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f23122f-f8e6-4f22-99a5-08ddeae5759a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?XI9HEEKwAiXBROksYWCFMlcqRDrHHLGpAtMy0Cebmakexm/IbGfM23YvzrmE?=
 =?us-ascii?Q?CNf9VXtomty+hdxH9MQYslHgBiTlEehpPtabUTcRJqoRbwSt/jrU7Lwcoc3K?=
 =?us-ascii?Q?XsPAIsUnVXTvNRyZO6fhdfedvzhaA9CoeG9xrQjzhK0XRKl7d6YA+fz4Ygvu?=
 =?us-ascii?Q?iXCN3zZ884XjeAbHkRj66oRWTorYsJS+yX0SlG6rpgySp/9tJHWIU9MLBP+8?=
 =?us-ascii?Q?Xa1zjSuHiP9u2cio/k6ZDUiRG1OJfyKa+dSbb0L7vj1mMMK/L77hb6LVTM+n?=
 =?us-ascii?Q?3eUFUtJeYGHJxebCG60XdoJ//skyD135qMJA04+zZmlFDKkeDG19/4/K/WqY?=
 =?us-ascii?Q?G3MGJmrCh30ToYkNJHFYBcmj6QpX/ypHQ+L0VPd4F3vaRi+8FoX/vYTgQ+4I?=
 =?us-ascii?Q?Eeu/scs7KCDmXmfCPXE9+DielLxUlrmcqLmoorYMqyBSHYTAjzXHT5w/f8Xb?=
 =?us-ascii?Q?QH1u2ezpMgVmfIRx9llBlFuyhw1miobtO2bUeqYPgag/JNW5g4+SEJddX758?=
 =?us-ascii?Q?+edZ66nGq5kFMzT3J5uPFuFkUy+PItk6bignUwC//gtWuNMgo76pmk2svAXS?=
 =?us-ascii?Q?vEwCCdyYF0OlV9f5w8eaUiBWHM/nIco8jf7vehhlLXiEjufRtsekHrdohlgs?=
 =?us-ascii?Q?56Bv07l6LhPnTxd0iyDYVngICnRB1dEHwsnTEv3NtZu9sTrls3EivWmDOB8Q?=
 =?us-ascii?Q?fS5iT5j6R7/MNNpTWdyk+RMaN+8F0cbRCAs27niLOOuSjHezX/hxGo+EbfhQ?=
 =?us-ascii?Q?cdVMBFhPg5aUPHSPgwPeRpmA+9tI5NmBGKPK2MXnIvo+zCq0pvYlpuPsmYiQ?=
 =?us-ascii?Q?xQ/hEy+ohdQFxjw8Biy990lW6RULkNpy1oJuz6WJiQcQ6zS3Ze6d3yxmfFd6?=
 =?us-ascii?Q?NqJzg4mguq9XEbFzQCA8br5xEAIzHi1r5QaFvLvTNDVXmLRgwDhRpqjzUBio?=
 =?us-ascii?Q?3v2zpBkV02s8GxmR01vDL2zxpSx2mIevUK96XNbMgauw5oWNXBhdpfH8UTAx?=
 =?us-ascii?Q?gCYqoHzwVQqB1san+rQXRa3+RlIr+gaSB88tLXF5/4Zecp3QO59bFJSix/BI?=
 =?us-ascii?Q?yM5+4UUvgkp83i3duZKEhTPeNtEaihII01ASV6QxXkyABUZC5lIsR65SPXeW?=
 =?us-ascii?Q?vWLfEChV1Z+BZmttbgM+kRxnrR92dBH9SwDGrzi7grKSdnV6hOcSQs8I7lHm?=
 =?us-ascii?Q?xm6vBerttxJh5f/R029m8I7OjFDxd0EOgl009eVxU31JWaKQUNHV+6hXAz9T?=
 =?us-ascii?Q?pxXnlO29LsVKZy9qIWGSplCqKYlV/5FcYR2sWtvzYx5YzEm4rJjBTF3t7esD?=
 =?us-ascii?Q?LbQANl2xJ0sfFcnk5bbNs223SvtrjvDwymtnfhOunGfiT3J3Xb2ftxWm50km?=
 =?us-ascii?Q?SoHRpx4IUjbDHeAKQ3n5X5iReI3OjlfQv6ZBQ+O/eBllWWgN9fsxjEbwd1J7?=
 =?us-ascii?Q?PGkeAqDUN6M=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7RPqnngKKwCl7plVNDBtevtda6SqzxS5bHBZFkCNDYzHX9m0qRgYekEYt39y?=
 =?us-ascii?Q?7mKXnHnK9llxVWwiGzPxXmeK6nCkM+nFMQbtAzc/ke7hEAr9se4NjmajvXx1?=
 =?us-ascii?Q?j0xR4oCbu9h9wbB/OsnMhDVT8CPV6DNP7PzGMwJ3m2Hv53bs/HU/5/2uq8c1?=
 =?us-ascii?Q?RSx0S5xX7h3nbrJjFAGfXYDbItRiMBVpT9Wqezlcz2pCJHrTMkGyzdfAyKk7?=
 =?us-ascii?Q?QeBymCE9uFt6h0jGiKwxhwcWQOeLFxoC621LXqRB8OBXOZLjCjMRVLp7bIxw?=
 =?us-ascii?Q?eGi5nWdxMfxq1vDa7qtvnd9MmgS0vK42fMYocgK/tWoi34thgNAmIqfV/wvi?=
 =?us-ascii?Q?KaiBSFjLM/rrniZK/PgXsNRMDUmo0k8pxJfjdiKeqbuKeLDJ9n2MSg9xQiJ9?=
 =?us-ascii?Q?6w6k6zhrJJeYcW1OC43CuuBXB/6sD3OSir8x+JGPa3VRNIOAY1gnWjW13bGc?=
 =?us-ascii?Q?YNQVa+FB3fPCv9hrIqoahnfSzB2oki4J8sRpYixmrvZeC9JVc3Bfz60bBusz?=
 =?us-ascii?Q?hG7tP2UQfE18TC/l4XP5IdEH2PlfmnffCI3mFvIpYuN/IKzOSBLVutxSulRM?=
 =?us-ascii?Q?5zSe4gM0bpvuvm89hPeiEClDhm7oHBRX5NJQqjwaO5yf1B5+5a4CnaPops6R?=
 =?us-ascii?Q?DmXsU4XqmZATQLJTbqF4kNoSB4GnGeLmYIuzN5RaYh9sJnNnHMNydvoNU/3k?=
 =?us-ascii?Q?+jMrPrknkzm/uqKhvqhmrFm6w15jjOgPr5+ebDwZOOIAvnvZ9rP3PGQKC/H9?=
 =?us-ascii?Q?1cdHLAdhEDe5NUK18OPwVUCJx8/X6eTHFGlfmH4uQPuxmUpWq50iECXceuBi?=
 =?us-ascii?Q?HgWlGXtn7lwwIMQTO+TMFb8BStQo2h/RubiD6y3eXVs/pqG4KMLW3AUhe3Mv?=
 =?us-ascii?Q?bSGmPDsvcd6h9ia9MHW8fAVbZe8DgAPsARgQl1tkMsjIM9wXhoelMYb8B+P4?=
 =?us-ascii?Q?Rr4kstQkNLB6p53aIJAp++3FYxG9ovtq/DHIJgkXdUVV2R1UAm7SR4aLpSaN?=
 =?us-ascii?Q?1vp+lP0RjWnHgDFj/pw26i1yiikkhQTr0ng261Q2gitfBpIA8xjrzBB7w9/S?=
 =?us-ascii?Q?VsTlq1rDdRGPMSkpBjdZheWinEwfzT7kJmladneLQrsGloRx0tqSNfwxifBG?=
 =?us-ascii?Q?/kVES5z0UHFoGAWFNRol3rxUNnwZkoCTVAQfLPVGmYHBnkt5+gMtauA+U4EI?=
 =?us-ascii?Q?x+4oyAHzgJ6p/pQIISyhdSLFJ88Cj9sWMo5jS9bCpGwXncapgxgb6JvHLHOR?=
 =?us-ascii?Q?iZBn9uLZ3gsnB2PkBNmRZp5dDTCXM3rEKImC93FHmyRhW0hx4tKU5uhjOeGb?=
 =?us-ascii?Q?O6SMOeIBhAc2RelR1ZmSlkXCrUMOac4+OPpOVy7ig8/kOPbqruh0YROujUN6?=
 =?us-ascii?Q?5V5XuCtsX1ooahK5qy9lvHTOCWRTCMXwDX6SkNcv0Z6E9803ubDCBKLCRme9?=
 =?us-ascii?Q?NGrCgLRFl2aEEaZ+cT68K2gWLu4K6gPKwCdV4UD7fqr/NzzvqVDIGuZJ5U1V?=
 =?us-ascii?Q?wb8Z2jQs66UNLpcCaeJDgVC+tapM924mlJEAeZdLGCeXf10JVm8kRlHRYNhc?=
 =?us-ascii?Q?FTUiDnOKlnEd0IakEkA=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f23122f-f8e6-4f22-99a5-08ddeae5759a
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2025 12:28:59.9516
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6wzevXJ7OadQJgpF0lcTEFkx/hSDkUVDrVZlTmGJ+Qx1JAUJ0W4ccpm78f0EZJBu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8324
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E50C84001A
X-Stat-Signature: 168b7d84dj6jhfhcpstwqowrhhh5a16w
X-Rspam-User: 
X-HE-Tag: 1756902545-919928
X-HE-Meta: U2FsdGVkX18lkvH6pGwMvclUSYvtuD/byNuk1f4JNIt9TULWUQp9LX8TirQJRXe4nRBac7NE2kRDEegO1bExLHgN8m9dZGzYDFRVMvdo9kDFdRd+zUqwuiOB6fp+BKPCHYnjlaDPi7wQcSOBl9d7ac/haSLnUj0d94ObRki/NCsBkXpc5ff3Q5a4j5NbEU6nps1xI0DS8ZbkppXkmIGJy6bJw1hZwwfW6N1QndW+givGlenzUote8n+Gcn+4arlEeuQCa0/YzniWd9fni/zv7kPI0FLQm4Jaal2S1hhJ8Q41diUvlV9B9bzz9MPzsnfu6sW3EVerSJNOR/OAjgE1yJeyzTVw/J4bsEj/pROwQVWQ+srg6+TmwBezjUjpx/5l4Zpv4KWMWTmV/yd1FFTmnG1uYYsxe7tlGdEUNSGnfnN5ZR/kYkWFWsAcmB48bFKR+JIn2bryyERhIG1g1GBDlP0F8BUBZF3jGU3AZrttiCXdoyQ8iZ2FNR6u5V3S+rMICDPQ1+1XGk81lX9QBskTChxuLBdgAIyI6o5raGz+voSdKJjTY9MXg3jHXucmEetyfhNM//TCgD70qhEcb27m/ilumWVucMe609UfRUrn541N8lifUIa+UK9NKR/UaIPv8BFo4XMN3dXJyREpPzUGgkEbwhKZa1YaP4+ukxYqDwkpBwR0qjgC8vp+I4dKICIbsRjSExmSrYKWN/lS4QMBRMCt6ZVtSyij7ngQmivIC1d/eT21Gv/L/xXVt1TBXAflhr3nuOwHWvdI9UbKCoab/IeAFs+5E9YYQRlTIUFxHrgMYlw+taSMC7iZjqryWLkCXHfLH6+retjCij/Np+pn2eIjqrqqCT9LlHpjkLqIUXxUZa0FEy58VAuN8lEDxNp0AY5NII4GFLeeHlAptivJ+HZ6qehRTkw3h1uI3RUBBBaKnogFtuKpcJIcZDEaVjzXaPHSRFDhqUUtVuM0MZ5
 XPpEcYpa
 j/pJCnFPH60ITdzGvYjanT57+XH3OfYKzHSU8KxycZ4EGbmJQ3XoWcnQKWxtDwuz1e4msT9/KVAJdr343/J2I2BpcAR/zE10uvc9DeksfxsjdePlmDvAWE4VMzNV7/5CE7XjDDxbpbbWM9VyPcEs6kOzpiLnil/auj/eTQzHT0MRsiM/lErYdwjLQKHjijy3gbwdtT7Dw9MiOS3k+mHDBnYACJNipTZeJ/ozG5h2/3vIfc/UqlQ8P0m0Q0TkghV/ccpxxNRMOKx1DrA7i/d7o2SzqBoeBrF+VouinwQNpTV7akzbUT+e0G7YQLhRXpl/HAbDw+aHEvzCI6qUiOKUrJFSfua1yLv0T5z4WtSLecMSfQPD9ypzel0W+CO6Q2NwDfFELj55Qu8WuIQo0/KL5jWnyZcMENcUSlC1qSvWVXNzGx2UaQTJqhUkloUVcOkKUTFO59gNU/lJE/Q7M9AJlWBHOdIgKnJs2ngtAz+AhVpa97AWXeWV2fg/8bCOh/JIhH3+14BCwORCTUi8bZooV5WbN6g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 03, 2025 at 05:46:08AM +0100, Matthew Wilcox wrote:

> > This recheck is because GUP fast effectively runs under a
> > SLAB_TYPESAFE_BY_RCU type of behavior for the struct folio. I think
> > the memdesc would also need to follow a SLAB_TYPESAFE_BY_RCU design as
> > well.
> 
> I haven't quite figured out if _all_ memdescs need to be TYPESAFE_BY_RCU
> or only the ones which either have refcounts or are otherwise
> migratable.  

Anything that de-references page->memdesc under RCU using the re-check
flow you outlined has to also use TYPESAFE_BY_RCU for the
page->memdesc allocation to avoid UAF under a RCU read side critical
section.

Likely it doesn't make sense to RCU de-reference page->memdesc for
anything other than incrementing a refcount.

Jason

