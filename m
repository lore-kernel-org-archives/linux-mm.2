Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C70B2CA0EFC
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 11:23:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3A4D8E00A4; Fri, 22 Aug 2025 07:23:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC3E68E009D; Fri, 22 Aug 2025 07:23:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3D1E8E00A4; Fri, 22 Aug 2025 07:23:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AB3588E009D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 07:23:30 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 40FEF133D27
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 11:23:30 +0000 (UTC)
X-FDA: 83804157780.17.E5C1101
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf26.hostedemail.com (Postfix) with ESMTP id B05E714000E
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 11:23:26 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=J3IUhQdQ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="E//vhMa6";
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755861806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oZfpq1JSQ3dbKrF4o+QlGVfiN9h/thDoEp1Tnt/7MS4=;
	b=GTOqg28XmIVj4CO4DWhgKH97QCarRoUr2uQY+nWo+jdKJMiKO7oCFcTNK7bOi8A/59rGE8
	t/PiPv0/Ss6Crv1aMjNB9ePtvtHo/+TlbxBI3o6QzTouoQOANMk/OkMqM3Yr3qMdY0jdKI
	42fBXGpx18hhWa61AI3ZoG8bFgImYnQ=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=J3IUhQdQ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="E//vhMa6";
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755861806; a=rsa-sha256;
	cv=pass;
	b=B2SXt7CoR0wlvi1V0uW7Dqfup4nk985jo93blpEFUUb7jTCqYdaSyfkDuCaRcOT8yb0j0b
	OdqDNAy9fucDnd0L/wnD0bZZ7krvQDjILGteAnYA1frkugeUbv6R9GRDNHe/PQ1emCAjFd
	3ja8ualVUMy9upwogeFBmLX69/CbEPo=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57M9et5u010017;
	Fri, 22 Aug 2025 11:23:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=oZfpq1JSQ3dbKrF4o+
	QlGVfiN9h/thDoEp1Tnt/7MS4=; b=J3IUhQdQ24/rCdAAghUH2G7pkmjXh4vEQB
	LSZmmgGAqsJJLeA2QLTVf1zDMTmAy0CMe2cpmxGvp9ANWHKT1ESiKW6xhy6eDtnA
	SjudAosipEy7Bv8UGPc1nqmuBky7iz8xSBuIa1d9AhfysvIZWAH+VKMJuwkLOrGm
	CQ7Bn7dN2FSZGjvGhtMjrwMvJd+4KCTlSL8QDQbWyWiM0XI/lw19H/lhho11kBXd
	LsYKqY8KCMZdW3oxHoTtjAhByD5aqKCWxBvy7AvQhefHW1Dcxf9RETqPgtpIzNUO
	TTIf/nMS/e3cGf1R8rw8fKoThCcHB0qNAZRHVZAaxHxgdfl2pLsw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48n0tqwj05-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 22 Aug 2025 11:23:03 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57M9h3iw020714;
	Fri, 22 Aug 2025 11:23:02 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12on2077.outbound.protection.outlook.com [40.107.244.77])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48nj6h83dy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 22 Aug 2025 11:23:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d+xRuOVWI4dE9d5LH4mq19Ndanwl/uTd/9pqjH+HcPQc+HJi60o1xqMqOEKMPGry6mLfCiaFdwFfaiuSFY7f0IBURlr+ckdH3iG8O43Ba24sGxZssb0jvVG4T7ROjCdnEsl8SkRs18/0iwnW6tmwcNk+/KzxJGwvPxaMnHhHcdStVB/HfPYiNHxdv6PmUPJ8sqmxkLwn9tIC/MzjMNwKPuMR5Ww7l8dDLpPB9AHR8QkQTXNgqSqydWuha1XYpnNqOg3ixTtDR3JSfi7hmivzGsCLpYzc68GRGS50ytKy4zikkjl2fVBoPhAaDVxaoedfYlIhk71VQMxfi4gx0+y0sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oZfpq1JSQ3dbKrF4o+QlGVfiN9h/thDoEp1Tnt/7MS4=;
 b=MBTUz8FITGqP2aX85Ue6pmqHxOnNauBCe21Djc4sYJJrpumXkEAsd0yNavyaHBmzaljuTIYT8+Q/pKyZJV/du4xmnX1H+sug62GL+xFlyShlGcDi877sFd5AOPM20hjwTS4ZMevHoK6EO0DiuSgP9amT/60X1NM42MWFBF3jaiS9QhBBKIjqn564vQO7q1s78nrPfe+tRO1ZjGLhb+WzBZ6KEZrMwMNKCmwv31sq3kAi/0YgiNNcWa95cjolbKJRBYW8boVWjQcGsVRh9eMECIr9ARVSQ8zuBlHK79WeCfrcWBsk61SBWTg1qqWOIET15gCrgWnq2ZyexPivfV8TEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oZfpq1JSQ3dbKrF4o+QlGVfiN9h/thDoEp1Tnt/7MS4=;
 b=E//vhMa6r8gY2rd5SBMCRhaRKPUTIQiEh8MxDP+xhi4wJXk2hpjrfCr4GSadUf1MKeSpeSnX5kxRNnpSAjonOtBHsh2Ve4GWEXfT6hZoWb+xeEftS1SHa/EQjTpasbKt7a5uCBvc6oXwGUFuwbLoQ0w2sQsI/t7MWxMNnTLSsqM=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by MW5PR10MB5762.namprd10.prod.outlook.com (2603:10b6:303:19b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.18; Fri, 22 Aug
 2025 11:22:59 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9052.014; Fri, 22 Aug 2025
 11:22:59 +0000
Date: Fri, 22 Aug 2025 12:22:56 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: schuster.simon@siemens-energy.com
Cc: Dinh Nguyen <dinguyen@kernel.org>, Christian Brauner <brauner@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
        Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
        Kees Cook <kees@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] copy_process: Handle architectures where
 sizeof(unsigned long) < sizeof(u64)
Message-ID: <233952f3-fdee-4ad6-8ad4-8f690b036f68@lucifer.local>
References: <20250821-nios2-implement-clone3-v1-0-1bb24017376a@siemens-energy.com>
 <20250821-nios2-implement-clone3-v1-1-1bb24017376a@siemens-energy.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250821-nios2-implement-clone3-v1-1-1bb24017376a@siemens-energy.com>
X-ClientProxiedBy: LO2P265CA0172.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a::16) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|MW5PR10MB5762:EE_
X-MS-Office365-Filtering-Correlation-Id: f5f3b3f1-4e27-40d5-7288-08dde16e3fbe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?jjWmbo/bJ9VR8wSlmNuFNbWTWr2IwE+ymLfWzIMsA+2Im4J+oSk4YlWwHqyb?=
 =?us-ascii?Q?ozW7cw+k9u4kGJEDbfl4+qLkRshu2fjreHWxqZyYFXMPYMTt9G/OVO8mevJX?=
 =?us-ascii?Q?2uL/R+ARKBiK45hiXxM96TvLoHqMfbyi1ClEppa9GZW1Ox1wYQ52myw3qMPT?=
 =?us-ascii?Q?xeBmJG4XQorlDgNc6eA/z32XPBe/j3oRFDVsk06bhH1061pesNld6c/vSJ4l?=
 =?us-ascii?Q?M1SgxrlbE/HzjfaGvzoFihQJw/oS68sO04xKxXFScrr38bdnfL6PbixbtHh5?=
 =?us-ascii?Q?lC5ldsCVvLUyc5Mm/iqxy5o7uwMGaL6x223SdC30B5T1NFrKiFLjx6Z50TYE?=
 =?us-ascii?Q?aECnOprwjFv7JxDzkEXnJpToBqG0nYR4CyunfL6miDicj/MlayqHRcsLC7NZ?=
 =?us-ascii?Q?hBm7hIh0gzPbF3neSpTFwGsiSnoQbMP3tUzMxvWU2BcyZ1dSJx0QnXx0Dz9f?=
 =?us-ascii?Q?ULlNkBk8ltTBhP1EeMRmmqXyV1ZpqUP0czvhGa3FN0UkWGu/cIvC85EHu7gX?=
 =?us-ascii?Q?dF8O/PJSQ13F2yiNu1teO9Je4vmwl6F2kjxBpDmiwE6441gdJ1aBrhCdwp/R?=
 =?us-ascii?Q?t3D+XrLQqP5a6r24DN0AcHxKpMkotLb0lY8vsr+zklz//fcIDXaxvYwTEtQh?=
 =?us-ascii?Q?+h1V3idWqyTQSQVFi7Ea9dxV+oeHqlSn/f3P8Ry4c4Vhe0oWslqDQA/ylKGC?=
 =?us-ascii?Q?OrIwkNMotMfTQE1uSZ88nzvc/WCGlvLzrH9xD32oUHO3C9JUcdNqkgco06MA?=
 =?us-ascii?Q?QnRKkt+D6gsWFRkTedh9fszfC7H7sAj792kfSWN2ITxskgyin0EFvwaThgF7?=
 =?us-ascii?Q?9y4J4qhg2dX9An1aLzqKn8UgrNK3w6+dTGgXNDhzBlHZB9B0T43E9fFXAQHv?=
 =?us-ascii?Q?rweABmNMtFAs+vcB377w+EYVKQFE2B7W1pIj8578sSL5HHJiA6tb2FTSeroU?=
 =?us-ascii?Q?XnORT+eerxjQo7iX6LVs8ShUITyjwn9h9o45T5eVCmXNe7/1RuGxHIEaqWOW?=
 =?us-ascii?Q?NukLJobfGCnBS+fy0HGXB1ypHXqP8QWFsWXCrh4754er98WOM9WkfC2MjqeU?=
 =?us-ascii?Q?dU9w57cQANEy2c26d7UFOAEZX0FpkBRcbUp/66b1iJ6WWHZ0/aOfNWkeXfZZ?=
 =?us-ascii?Q?nl0TfGyBgkg4NdH+5ct81N/SnHhWDV/Z2U9yFY8YwskyECIPt0DPO8iD8kM7?=
 =?us-ascii?Q?IcE8v5FnfY59WzxuV3aQB09x9kXyhA7B0WUPR2ce1nA+ClnMHSZJW+UsCVQr?=
 =?us-ascii?Q?fUv3R/ZNKjuktpwrBFqCFVp/aXsWFSg9Mx3qxsittTPrfnZ6JFcuocOOvZmT?=
 =?us-ascii?Q?nDMNyRfSRTfd5iVmjQPwnNuqq4O7nzDLqJjSmJZWheKW8iXv4IiK9MzM2f2k?=
 =?us-ascii?Q?0P9R980kWwXIHCZaxApxoaECBBqym0S2JuGKNDE6qLWMGRM/kIFoZnEPZlhq?=
 =?us-ascii?Q?2LUmKHtLetE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZlydYsC/lDQYSxBMouznemrRJEU/xPI1F/OWEPGXllOOtLUkkjjj+lxKrJ8W?=
 =?us-ascii?Q?VQJHtmpqAAPMdM4xxsLtjMo9Zpf2KQ9nv5mXx+Y50soSBLFGqmi9pIOdg6tJ?=
 =?us-ascii?Q?fbrorWlBXwKlJXJYpkQQJfYxVWLaSf4XE30JqYgZy6L8BGdg526Z+AnpYge5?=
 =?us-ascii?Q?3ptXJn5m5dcR/Ptn9OH2y/zoEWOqkU9V4ySOczorTybLDQXKVPJJvaIfR8jy?=
 =?us-ascii?Q?s3DcXds4u6l7vT6SXrvhRBvywvNpCgyMSkZQqt+0PcPW/0CjH/0Hw1VD1GKC?=
 =?us-ascii?Q?TFgELf3cGgS8pAVVfGist3JQ2DOMgYIjaBjXRFTunJ4UQF3Q8k3APfojtb2k?=
 =?us-ascii?Q?+DqUaYCPUaVA+F90Gw6Y53ku0tmKcQ49fMw6MLFBSMfJ3pQYz4zFnJDthOq9?=
 =?us-ascii?Q?T124dSFlreuZsuhf/twS4r5GjxMYsLDfVy9WHyV6h7ESieMc97nd7DHC3Lxl?=
 =?us-ascii?Q?rJ1DloaqbJPXjn9xweCjtjFBHddqGvdp5ZTlHtc1O6GBKOyrmKPCbmbxNp3h?=
 =?us-ascii?Q?NzU72AqTIQeo8s0LcSvcUp1fo+zVtbzjjzQOIrzcQrHQ9nB1FVxra05gZqYp?=
 =?us-ascii?Q?gHpdy1kLyY2C8VyBlLIGwuV14hIQmg0Q2HStBWWu6QHf6y7GY0W/jM/4IFg+?=
 =?us-ascii?Q?G3Y7NSxAXltGnHb227zbX1/NRj6IcRGhDJ4DynsEwdbOcmMvCZ4B3+tW3wZo?=
 =?us-ascii?Q?qtERNhfgYBWkPgqKkvHucB6oSMcJvo7Qc4k4s4TiQ8A8rGwiA/BTQtkMJEb2?=
 =?us-ascii?Q?FD3c0rzg1HuEN2Mvm3US3WvPLl2Wr/oweIuHA8J9E9RqitfrLu+wP4wbdjPY?=
 =?us-ascii?Q?n5q85l5iwGIeQ2vUi4A0n67xhKr3zzEbJK/EbmD8dEDb+nf+P4kEPswJGCQr?=
 =?us-ascii?Q?/vZk7fj9N0oN+Mr0U6IMcREkOVSHrZTRtfPzg2yg2MegYL/voW6opZjjGrDb?=
 =?us-ascii?Q?PlE8IEo81MUDgYCFLY0J8BLG+W26lD+wunotcRoXXZfiAWjHqT+tx1X5HNOJ?=
 =?us-ascii?Q?sOwgRe3+h2EBR8WjukLfrVBBdjih8z/YKjx+1jQZecEkWcz6L7eKhQJzQFXG?=
 =?us-ascii?Q?+irqVgH9GL9DuG0KTdqqRXeDiiwd8NoARVzBYvDo4Q7/TLU2Xh4kZ9TtNiZZ?=
 =?us-ascii?Q?2P9/rWAx9u2RUostUPeHTtgsK33Ddf+Mn9zyEOmnHRszits1qABhhE8GHIme?=
 =?us-ascii?Q?VWLuJLWbzKhQffrvHP9iBmk60raVegBBUXAf0w5uyVJt0gydj+lWJzziaHzR?=
 =?us-ascii?Q?VRlRKuB3c0cqd787nvw0ydQ8bGzJ+sCJ2e7WFVigShW0feUKGXwPpb13Rw9i?=
 =?us-ascii?Q?TLJRLha5H3vRCHqA/fX2lDl/HhZvgASPZqkGsY9mS3PogayCLA6SZM9J0y0p?=
 =?us-ascii?Q?6Mobxu5HuUkXeKVL7phn5tgw1Hz/8d+xiJdtcHr/zHrVrADayTydX5sRHl0R?=
 =?us-ascii?Q?FmHI7vszEX9pScpKJrru9JPixphH2EMykF3jKw3P89wzmI+phVK25+WvJTpv?=
 =?us-ascii?Q?VTNB1ONmXkSNWa0wbKo4iyihU8qIc5Mtx3soR0jWWoJLjEuJiAmDPzYkBf8V?=
 =?us-ascii?Q?HGq3nuvwRLIjD263lMHgpf+ZLNW4Spm7UGEOawLX40KEbgxCEQ5HJ+vtut+s?=
 =?us-ascii?Q?fw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	nOGx4ws/GjSU4CCwFwjhiWOE5zdvTUVSXGGrDtQsJcaSt+sfdUcaSBZ7OBLOAA67BCJ43lGL1aRW5osp/oACEaHza4hfnWV+fZCGRn1xH3WRdzz4aE/XqyGc3t5mcQAhs5ujJW2+8eBXkhbFfO1hecYOyCQf2brVByOAroVIHi/Byf5eohg53gUxdAT27DWVwu0O/C0IT+7CtbtXc78DJKonnDUA13XXt2ctK0zCUXTgwO2sikqvlY7qQrT1XQ/OAWlUgeXSgTbtj4mafHA2ajGRIEF+SoaWDr3IUhUYsDWkS6ayHGmyNoxz0XZIqA8XEARVbs9di4AZtUBT3W3riYyLbdU4eWW5upm9oGKf60o9BsObLVCWv+4ojYWjn+DL6TvcBqwWBzt+SpB07N6ax4JLRMltjEdREMYiYzbzZR3eGTftnom0c8xT2gkGroFhxNloQ47v77e/2a9D7p5nOErBiA1gZ79CxPaECG203rFxLUTtj0uRCVKME1McFdTRhE01hqBiY0A5Kby0NzPBhgwPCNVXL4YXGBssUppCHHxcJBLQpeS9n85S5H0E3GoUD9glwibXlt9ahiCBOvWY69G0pqdYhH/Bn0ty6qqTm5o=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5f3b3f1-4e27-40d5-7288-08dde16e3fbe
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2025 11:22:58.9248
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oOosHkTp9UQGEfb0zz6KNuD04cFVuYHFt6YZHSGu7YHAJZCdcHgnW//0YIfwn1Wmzu8NxCh4/9CPy7ruZCEqxGV07clhTcbGH3uK9vVpdMY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5762
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-22_04,2025-08-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 suspectscore=0 bulkscore=0 spamscore=0 adultscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508220107
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE5MDE5NyBTYWx0ZWRfX+BJaJDKUmJHY
 e51pAJ7AlJeZ/OuysGvE/pk7F40CL/Erl8i/0vQvPE5GTHztVDSlsAUyWdP0qfQGbdwpD63Z3DZ
 Azudbwioa6dIRZcGxcoTjUUEURJ9JJUJa8KWs7Uvddw2Jn7PuNSeVLqhH4CR+6uzbKmtTV5RZ7d
 2aMWhVE8vxr8NSMBMXYa/SFOU40wXIJPfWu5ZGPJw8LNYwOG2FQbjIgPLDwa+e4Z5skJ7MXmlVM
 L0bBAjHIWCPd2tUpBL7m1sd1BWSMXKtiC+STiWWqHEFsmDE5J+bJ5MmJxP4/KKZsSJOhUEutVPq
 97pOfgyx8qNwign7FpELVDVtk/suaIvS+Y8b85DyE8dAN1Sk0QcR1HzwX7lKzlt3J31ayUaPJBE
 LT2x+eYxPbPH2mtnM4j0PcU9kNscdb1Movuie6KhRhwuxtWPk8Q=
X-Proofpoint-ORIG-GUID: ncU6_OVVTayezvZ54I10zSQvsSqELabs
X-Proofpoint-GUID: ncU6_OVVTayezvZ54I10zSQvsSqELabs
X-Authority-Analysis: v=2.4 cv=K/p73yWI c=1 sm=1 tr=0 ts=68a85317 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=xrKq8BdPAAAA:8 a=56lA155kpmB9p1ufybEA:9 a=CjuIK1q_8ugA:10
 a=XMSe_M5rEsREOkcl5Ev-:22 cc=ntf awl=host:12069
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B05E714000E
X-Stat-Signature: 5ox66pnrk4wakkqqsf557nyqyuzzfwam
X-Rspam-User: 
X-HE-Tag: 1755861806-147643
X-HE-Meta: U2FsdGVkX19IblcQ6Xq6Ef/CQSBsVkfnRftOCoB2HQajd++XZirbl4pVjOgXZvLfbgxfLAhRzcg0eCAnz5L/I1sko2JHYAmHe7eMeLm/yWGPR9AQxHlOFhuIZLMMHfIcMKRcE+xa5qSFqSHJJo6VYbHq8hCjvTYmBNOwlLdK4XwavUC/C6JgwQAB7XmNckg8pp4WZBX2ZuMlZVnrRcSf8W5HdkZcnVpT3i3dSXPimDl4Vbij3d8d9oD5c8xA8ax7ZpFKsHvgNz69qehNIJTDTsIKL9QmVBulNjipJ4c5vn87pcTALta3CItl6rN4MRNGpQYVBLgA7Xgy5sfU2eIsqOBxwPOmC7HNtftWOltzN9jUzq9cK0YCCpvyoRZECRCTvmoLPUYnr7/ARszkK5KYKolubaJtqUbvX2RqEhLppfxu+L8FoMTTt3SuI5j6mJXvPWBn0Y7ghCEdU2sQOaFleCX1Fd3D5+ZtWr5q7nKgcsggNc9hXVkeEp0WjPwPgM0JyHstQxSEvrRBesjcPMd0u1q+mYMgZ+oZTGWGeIQNB18c4Zx74digvSDY8jD7k4ZPO5ByJ8K/vu58HdEm92AD0ym8bUpjM2XuUsTEYvTpKG79k4WDi7vcWOAI3dJoxHoHNLJ9Mqe5ISYcO3ZNcccA1u/1QnuLbBFvh8R5FpZ5aVkyb88snSCrjh6Wn5x252CQ6B7hN54yI5v3/CoajZh/Dva1RKOjUBlwSrzhYi4+ZALfm3BIJs0qLbX8RIRFnoUAzcWV8hK2ts7I7tzVTy51eObazgv5Ph+tQahfZU3prknOKPEMw4bx+482Q81lgoOz/GfEEyfUzbngIRAFuOsHr1HHbsZ5nxQ+6iX9hgcJLhlreuI7m8Zk3otBDTZ9CSvP6FMZ+7V19hoMUGjBUrs7vuPr11KQQSJPiWwNSZ5u1QMhiiOhmGAts6WU6rBU83ShIRtDq5PsGU5i82iCjqe
 dzsYQoWf
 bwVhvXFcJCoUrK/rD4o7+KefPffMHWGvhcp75LPJPCT9X2nw25ZOQweV3pC8O0ifxSr+AF8DcdVSFm6kigQ4e8VTpk5rWedC2bbu7ijC0nsTyKeWZ0I2TJEebTgVzzHlS9pCxbi0IKqNLf7njZVB7s1Mrii5JhEjhkoINWieIrTcIV7TAmdGj4fg+rzNHdY2H0Z7BkgBDIL3nld9WiW9UMEvQ7/vrDCzpKq084/llYUWVOWg+SS4CzA9F9VdhvmsBqrznY76vFZvdDbyqctS0GzsupZVA+pnSBnMauPtDOfZI6NGD5sfI9jXXOK0VFf0NWhSwFxnMexQ2AufehVxDIJs6Gz/DZdmG/9r4fBZl9anKqnG4/ycZ1xkSCbSpl1bsKw/SnsRf/fUQV2NhjR0RUSn07EjnIQt3Qso9htFcHgiN+3EWmLM0r0Ihemwl3Df36cgBTzaYxgqwNFsf+fUW+LNZra8FuigALfPhwnOQkIEq6q/fG7iqo6lMtXTCHtj+r2wBB0ZV+le7nSlgzrk0zefnCBRbinJLoThHmtk+EYIuI6dYZhx5mmL1KAK+BjkJ+XHlsOPUNMomriiiLdol9Pr002QQrF2X3+5R9DmjaTCP1r5Q8bRKLUDdMDp4z6O/0muLyW3f0yXUwkIk49L/Z96j+zMFB45WGpY1WefDrMw6TQCDAwTUB3B4FEakhcWL0pMpkRdRLFExLwfKCsAMTgMlSKaGIoZU8aX557pTsuuhnlJMM3Lbfqz8SYkJi6uQEeXO9vA5EeGKW3cEuwIBmHFMaSiVt8Gbb7HMYWvL8gcntEgbS2MizhCRH4SISmxuuKNJ6uhAKxNllG38b3yyIL0Jcw2aPTPXTPW8ZiCQ05PD28gZzmA0MxNicDgbMtW8Gv1ey5cYFUeQ7vMhR+HhKKuung==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 21, 2025 at 01:27:37PM +0200, Simon Schuster via B4 Relay wrote:
> From: Simon Schuster <schuster.simon@siemens-energy.com>
>
> With the introduction of clone3 in commit 7f192e3cd316 ("fork: add
> clone3") the effective bit width of clone_flags on all architectures was
> increased from 32bit to 64bit. However, the signature of the copy_*
> helper functions (e.g., copy_sighand) used by copy_process was not
> adapted, as such, they potentially truncate the flags on architectures
> such as nios2, where unsigned long is a 32bit unsigned integer type.
>
> This can, for instance, be observed via failures of kernel selftest
> clone3_clear_sighand, which attempts to trigger the conditional
>
> 	if (clone_flags & CLONE_CLEAR_SIGHAND)
>
> in function copy_sighand within fork.c that will always fail given:
>
> 	unsigned long /* == uint32_t */ clone_flags
> 	#define CLONE_CLEAR_SIGHAND 0x100000000ULL
>
> This commit fixes the bug by always passing clone_flags via their
> declared u64 type, invariant of architecture-dependent integer sizes.
>
> Signed-off-by: Simon Schuster <schuster.simon@siemens-energy.com>

Ah this is a change after my own heart :) as I have worked to make mm flags
at a fixed size per architecture (and indeed, expandable in the future)
[0], and plan to do so for VMA flags also.

It'd be nice to go further and make this an opaque type etc. etc. but not
sure if worth it.

In any case for a backportable fix (I agree with others that indeed this
needs a fixes and backporting as this is a bug fundamentally) this is fine.

So,

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

[0]: https://lore.kernel.org/linux-mm/cover.1755012943.git.lorenzo.stoakes@oracle.com/

> ---
>  kernel/fork.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 5115be549234..0e9b2dd6c365 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1510,7 +1510,7 @@ static struct mm_struct *dup_mm(struct task_struct *tsk,
>  	return NULL;
>  }
>
> -static int copy_mm(unsigned long clone_flags, struct task_struct *tsk)
> +static int copy_mm(u64 clone_flags, struct task_struct *tsk)
>  {
>  	struct mm_struct *mm, *oldmm;
>
> @@ -1548,7 +1548,7 @@ static int copy_mm(unsigned long clone_flags, struct task_struct *tsk)
>  	return 0;
>  }
>
> -static int copy_fs(unsigned long clone_flags, struct task_struct *tsk)
> +static int copy_fs(u64 clone_flags, struct task_struct *tsk)
>  {
>  	struct fs_struct *fs = current->fs;
>  	if (clone_flags & CLONE_FS) {
> @@ -1569,7 +1569,7 @@ static int copy_fs(unsigned long clone_flags, struct task_struct *tsk)
>  	return 0;
>  }
>
> -static int copy_files(unsigned long clone_flags, struct task_struct *tsk,
> +static int copy_files(u64 clone_flags, struct task_struct *tsk,
>  		      int no_files)
>  {
>  	struct files_struct *oldf, *newf;
> @@ -1599,7 +1599,7 @@ static int copy_files(unsigned long clone_flags, struct task_struct *tsk,
>  	return 0;
>  }
>
> -static int copy_sighand(unsigned long clone_flags, struct task_struct *tsk)
> +static int copy_sighand(u64 clone_flags, struct task_struct *tsk)
>  {
>  	struct sighand_struct *sig;
>
> @@ -1648,7 +1648,7 @@ static void posix_cpu_timers_init_group(struct signal_struct *sig)
>  	posix_cputimers_group_init(pct, cpu_limit);
>  }
>
> -static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
> +static int copy_signal(u64 clone_flags, struct task_struct *tsk)
>  {
>  	struct signal_struct *sig;
>
>
> --
> 2.39.5
>
>

