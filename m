Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDDE0CA1013
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 17:54:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29C308E013D; Thu, 18 Sep 2025 13:54:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24C4D8E00F6; Thu, 18 Sep 2025 13:54:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 115438E013D; Thu, 18 Sep 2025 13:54:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F14A28E00F6
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 13:54:51 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9E17AB832E
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 17:54:51 +0000 (UTC)
X-FDA: 83903121582.08.52C13B2
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf16.hostedemail.com (Postfix) with ESMTP id 30EB718000C
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 17:54:48 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="mmGzv6/Z";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=oSTlFPTc;
	spf=pass (imf16.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758218088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iNiyqBnl2cgKTwjYMF695o+DAxelV7fBi7lM+63o3rE=;
	b=zfhIjRueTtcWiVUqy/aBfHD5gFWZs/lCHzyhuAuMdwwlPSH4PizIe3MbSS/2hA50ML52jB
	KVR6lH0W97hs7+enLIDUMgsQLdJJXHFyy1+3ScoOtxgvePlfjI+ZP20O2VuZy2efxGYMHx
	we7CU7FKU1OQlkXChUXdyuLH+UN+pac=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="mmGzv6/Z";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=oSTlFPTc;
	spf=pass (imf16.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758218088; a=rsa-sha256;
	cv=pass;
	b=tLNRAQl6kwKX4q38OuDZV+v5Xqr1asXaL7Ol+OMc7JUmQij4Y1NjrZALl3VmbMTLtd8M3k
	YeRYewJoZgIHAn2MLnkjHLUTN7yyL36OpdYj6Y/Njtm9KUB2NnC6LquFUBGMqsHPTjbbfJ
	GLFyUGKpQeIj71vcMYMPsW3vDcwB4Y0=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58IG8dIo019426;
	Thu, 18 Sep 2025 17:54:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=iNiyqBnl2cgKTwjYMF
	695o+DAxelV7fBi7lM+63o3rE=; b=mmGzv6/Z91KJ6nO3P5+J2Atfg31asfTrnz
	Evo87H8uZ9zvMadz7gzyLmExOvbkHbbc04w+h7tdTydayFW/ScvNQMFdhLJKztDF
	v7auFu7a76gRS+KTE7xRZlisFrkDNdJ3TletrN/+ONmtYqko/QDDsk8JsKQrdczT
	tKQ9/TuXgCU1VE8AmFS+mh6UhNQUP7XFzMSWEpP2eHuiGXDNttJN8bvX00JtKDvi
	EKgsZVc9IcLeAWsUjruiDlzTt+ux2HaTGZalFklMYwbFlzZU5EhHbnnaYQKn4V9h
	4TL05BAl0SqTfYKR2SGUtgNkBbj1MAVLBCAi799cJ6102AMiWlfw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 497fx6m20q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Sep 2025 17:54:42 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58IHqKIP033730;
	Thu, 18 Sep 2025 17:54:41 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011043.outbound.protection.outlook.com [40.93.194.43])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 494y2fehpj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Sep 2025 17:54:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dmmeUibnSCqi+hX2W78hGZ1Jlimq+cQYkCPUAj2oRn+waiwDuxli9FClpDPSgAY4wwb+zwNOtDwbhAJX/e4kKFmItA+rPGnTzoKslOGPkpg4H3Iaw8ycN4+MmIzySQ4bDD/OwUIKPn4VU5zlhK5PNK0hu823d9PTbT0QLXIj2KKt8kUiOt548gHo4CHhutY+yZIcjOH7osBFR24Z3JW1VswV0E1CylJLoUPl73bepueqK6oPq1Qp6lTmlhE90fX2zcGvpgEYh8YOyLvSs7FI//OwdopKvlMqPnoz22iBJtVyAphyg3LgBurJZHo5rFWf1yQgXuFV9/C0d9Li29Gupg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iNiyqBnl2cgKTwjYMF695o+DAxelV7fBi7lM+63o3rE=;
 b=bM8MQAkRLincUCTQvK8QqYeaZpDG64RsdthFWIFnHJKhkDUQAWJDD9/HZiSyDr4BnflZ7pJXt61eD5/mOy5vAgasoxKAcn6OrII+IwHz9vBppudXNKdkdDxXMyuRpriYDiV2jrhpBM09oGar5OepjFoSzOU3G67JhBVO0/ZPGeb/mnsVVgHK6EBZxR5IjgaY/FE5s6d042bZBumn1h/h5WJBaqSaafGa4EHxyozUX22oKtLuWcRzokFp7/qditmfgtnlmRlPfVKItptI8tDMkcitoZZXWE/6BViacLAGjorjaNKfzhV5j8cwtFBrsERaBxkYPbNgA9Vl8VvBYgzGsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iNiyqBnl2cgKTwjYMF695o+DAxelV7fBi7lM+63o3rE=;
 b=oSTlFPTcnl7EAEJ2OAEJm0xpeXfrD2wVpyXHO8CA/wOIDzPRxwQUvq/9p1JLeXXgyu/cljdPbPBZNfw7uVjbYhKaqGJy+20hmZ/zDRacMePW3uLH7j1VaRoGUoT/O4scKaYXHWD/zQod8Rw13YwgX1GvqTQCyIYYiD1NH47kJKQ=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by PH0PR10MB5681.namprd10.prod.outlook.com (2603:10b6:510:146::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.13; Thu, 18 Sep
 2025 17:54:37 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9115.022; Thu, 18 Sep 2025
 17:54:37 +0000
Date: Thu, 18 Sep 2025 13:54:33 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Nikita Kalyazin <kalyazin@amazon.com>
Cc: Mike Rapoport <rppt@kernel.org>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Peter Xu <peterx@redhat.com>, David Hildenbrand <david@redhat.com>,
        Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>,
        Muchun Song <muchun.song@linux.dev>, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Houghton <jthoughton@google.com>, Michal Hocko <mhocko@suse.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Oscar Salvador <osalvador@suse.de>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Ujwal Kundur <ujwal.kundur@gmail.com>
Subject: Re: [PATCH v2 1/4] mm: Introduce vm_uffd_ops API
Message-ID: <i77haarh7xnf322rywrcomptj5eydm33xjwmozt7lvxw6n4rpu@datftmvx47or>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Nikita Kalyazin <kalyazin@amazon.com>, Mike Rapoport <rppt@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Peter Xu <peterx@redhat.com>, 
	David Hildenbrand <david@redhat.com>, Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>, 
	Muchun Song <muchun.song@linux.dev>, Hugh Dickins <hughd@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, James Houghton <jthoughton@google.com>, 
	Michal Hocko <mhocko@suse.com>, Andrea Arcangeli <aarcange@redhat.com>, 
	Oscar Salvador <osalvador@suse.de>, Axel Rasmussen <axelrasmussen@google.com>, 
	Ujwal Kundur <ujwal.kundur@gmail.com>
References: <289eede1-d47d-49a2-b9b6-ff8050d84893@redhat.com>
 <aGfsaIIzHWfjcNFd@x1.local>
 <e7vr62s73dftijeveyg6lfgivctijz4qcar3teswjbuv6gog3k@4sbpuj35nbbh>
 <930d8830-3d5d-496d-80d8-b716ea6446bb@amazon.com>
 <jxekhkhbn7uk23oe24svxrs3vfuhseae57sqagndqgh2e7h33o@kfkygmrvjb5n>
 <aMp-kW3OLqtZs8sh@kernel.org>
 <du5pzxmfk6lile3ykpaloylwz4eni6disj2oe25eq6ipzqemiw@ybcouflfnlev>
 <aMvEu9m7fJLnj862@kernel.org>
 <4czztpp7emy7gnigoa7aap2expmlnrpvhugko7q4ycfj2ikuck@v6aq7tzr6yeq>
 <a1a48a0e-62d3-48d0-b9c2-492eb190b99f@amazon.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a1a48a0e-62d3-48d0-b9c2-492eb190b99f@amazon.com>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YT4P288CA0094.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d0::22) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|PH0PR10MB5681:EE_
X-MS-Office365-Filtering-Correlation-Id: 41923738-3656-4e32-fb54-08ddf6dc6ef2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Ps0JZSH9ZUDX3THB7TLPaz8cOe75pdfolBn+m85oIONCox5FATVvzIqF/MYV?=
 =?us-ascii?Q?XRU2aliQpOrPn2N/whRi7MemrhtEQd39mel+6+7QaZWSCZsch/dIayk56bja?=
 =?us-ascii?Q?83T+m/E6vGCr7uHSSNjff62IdtQjUVE/4aCDsOBlaz+LoHqn+E4LLHJ94X9J?=
 =?us-ascii?Q?n44dA12ED5W6Qkh8sFOuEf7mnWbrE+qRq0xEZxeVCiFQgOKX/Ek0dto6wsP0?=
 =?us-ascii?Q?KgqWUyUiXzwRDzTAAMxaDMG2tXSVaqOmkSsBnUow6uUVvmLJA2GFYP3q/Bru?=
 =?us-ascii?Q?VPZ+IDiFMlTRQqIBOy2q1LoQbNKR+8+3G/muS/zMBQ5RIU67PpQ8W49ZUKf0?=
 =?us-ascii?Q?YUQNbN4x7LL9/9hHDUVegTr9ouGRDCE85MBJ8oetCVVJaOQBbg9EKVMWmijb?=
 =?us-ascii?Q?ZjcH66LKB3i4FXoobkk6xgLfy5MzQYJiO7x8mIWqJEFWLM+fs6t4yD8CCGcl?=
 =?us-ascii?Q?tL+EbdKVzZNu2+9nMXsq8pf7/aMCPlIjcLU2AiAjRLMv4N4RvjqmVN6X4LzI?=
 =?us-ascii?Q?cpfip2snXBv2gvxWvXI2rKm5nNBe5K+uBbNCBxUm+vZUrrv8AzqkGP49Wmcs?=
 =?us-ascii?Q?gbqD4Hbv1kePWDVYUwpdzhht3oF9qQDF9s1IzO3tr6zH6yNB5oUxZESgV5fQ?=
 =?us-ascii?Q?kVS4Nu2LQTQqJCb38yZeMKynDAOCuWWG/3z3Ead1bVuJ29nEEPe0UzfweFJi?=
 =?us-ascii?Q?SjT/cTHXpc9x6OHxYRw9lArYkJwx3/TSlqpA6mVTxGvMFRXfN+xDelE7fjTY?=
 =?us-ascii?Q?Vw0TnP02zRSVfVJz6l9Yg6KDxakzz1ruIhjwjfh1qU8+0TqhZbm8ubwnFZek?=
 =?us-ascii?Q?vzHcz1x3fZnT4xJ2J35w60bRYZ4GYt04JmGj8kYy7BsLi+l67spJcU0mEGp1?=
 =?us-ascii?Q?plMOm12I+W1FA1KW4hKNcwixgScMhvg2XlDcJWVcQcxmkg3Y4UD6hvM5IEFm?=
 =?us-ascii?Q?YI226hv97nMVXd9Z2eD7Y8lctWl/fB2VswK9XeRHrZ5/1HfiJprPIGPiGdAG?=
 =?us-ascii?Q?ZGIaWr+xPRrrtHjEpnbjwQE5wRGYmv/vfKvjed0/lZ3nFi1QeMjmQ+/N2A8Q?=
 =?us-ascii?Q?JWIFh4bZ0bDszEPCWrk9kMw1RXXA5pF1QcE2VqC6drO504cjTVKkgkXvVfjU?=
 =?us-ascii?Q?121hM2SQQ6I1TSMABfFdC/zWHnneS37NzkcAQW8KJS96g7r4xudQO7gAM/3j?=
 =?us-ascii?Q?SftnzBCMg9gsa7INr+8KD+2tmCIODdemNCiiv/Vd01C1i0ZO3kIb13MumAwK?=
 =?us-ascii?Q?VM1jmU0wUuUqChnZhU4+KdSR02gBu3c+gdoIW7g/gEVj6nzPv1dmLg9FNppM?=
 =?us-ascii?Q?SzV/9RXBZDmGi3vKKPqYiD/GOrkbE4ff99+3NAPdK9iXSzPUrLFhwkO/nWeF?=
 =?us-ascii?Q?MAMi40Hlpwh4HYzo/DdlcV6s7p+fHdbkaq1kseTTP0ZlLhk/e9A7c4hvcvX1?=
 =?us-ascii?Q?Z2AJnWOAjoo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mbgz+uJlQz+VWkGi+RkCstLsrar31ubMekIXElOMnG3rbn8ul6vhbBeqUWt3?=
 =?us-ascii?Q?iUb35MaHR/ejeMa1IycjyOxg0RtMjufKweU5DfL+jUU6zFDj6G0xLq/UZ00a?=
 =?us-ascii?Q?8GGdNlgb9mvAl7nDXopu6sy9zokYJzVfd9hkvDKqVcdwCN09RHJKZZhosl87?=
 =?us-ascii?Q?V7ts8AM8kNdP1fvGC/Ki2G1sdzrtKkxEgIXFPnUmgDdnVN1qnUVfaR4SgYrx?=
 =?us-ascii?Q?4jOdqq8auMN7wzvLHFXPYAbqVMKUaJOtjgHdGEHqwKI8ASlIXnJudHdRE2vA?=
 =?us-ascii?Q?2PXIUehQI6bkUYWn9Mh2U+AYKKzovWij4QvZdRky30I8VtFFzRtA3pnK2gwh?=
 =?us-ascii?Q?9zEG39qnjvpurhXAUv7a+XOEAYAH1A3wqGYRskS9PBmF2J8nzB/LGwv+kLcI?=
 =?us-ascii?Q?wOafBdkuKx/skb84c+Ch3cRs6TQ3RpkV6IEP1swJmLd71t8aJJ5L7jdrSkAd?=
 =?us-ascii?Q?wfbXRdp06DDciDrFdbO47mkQH+9Oz57IuDlYQZ/mUhzeGC4rp5FGYNOrGE9X?=
 =?us-ascii?Q?TrbaeEh5LltL3eqEB5BoOd4h8QAHEvD9udIi8/SC7ncijSqUQabF1tdrz7S9?=
 =?us-ascii?Q?fuyQqRurviWn7HSlFcPctecpg26hj0bS3fQOja4EEfP87MaIXfECVg9zeErv?=
 =?us-ascii?Q?ZLZ5Sv7sNwIh09TwSjelDUGh+OP0iiG5vcVKsaiW2lvCqHlkZ5oLwFZcfaAp?=
 =?us-ascii?Q?D6EX8reZO8V29Q/+Uzs9r7+esuubUsUHQi6GMhyQYDkiDanoZ50ipKqznhm2?=
 =?us-ascii?Q?lv6kFJ4rTkzZUF/GlDkVZdhVoZJtZ6wVi3SdIdGzC6YqkDwMV3X8smdOETEA?=
 =?us-ascii?Q?VEZP3B6k6KphnTpcX+FuzIJitjyJougSS2zMpbzBrlz289a+hwe9dEiQzbzD?=
 =?us-ascii?Q?7cJIPtfQBd6Rh4gD6QhNuIeS40kNqCBtrN5gBWn3fGEx1aIBObGoKl7C6Qrv?=
 =?us-ascii?Q?QFzEM5sURZwZJ6OLuj8y+h5GaWQivks2K+L2bnCZiEa0OKl/2JHRWW/BMBgF?=
 =?us-ascii?Q?oMlT8/62392i5TG06vbC+qNoWrclI6NpO18k4KcO3b38Qxd8DSqIfxZg4GmD?=
 =?us-ascii?Q?YziAZVRCQu6Q5HW/ruxH4AYLCnmM5nUSUpx5j3ccoD7h9BjbXS7wGD8ffh+d?=
 =?us-ascii?Q?N3On+BnY54/HJVxoSNR6QY0r0xSHMgwQhjZPS+x5xFJM0JOF0dWtxLyNrohA?=
 =?us-ascii?Q?EoxaUqSS9ZGh2gLfkKN5vfspShfhzSooS0ysNL6RBrmvxHMkU8+GJsLRVzgX?=
 =?us-ascii?Q?qvLJzYGHB9jqpCPNiCd2dnA92qAbFVdjyKwVdU3DILRcBzoB9jI7dWtUjZwO?=
 =?us-ascii?Q?ihMMyrLRx7m1YAMOn4ithHF2W6rVSD7QyH7kEP4KgU5lLOqNH4HGPCY+POqQ?=
 =?us-ascii?Q?FBgqISq4veUQu/ttoYBd3X+R75p1Os/ezWxdJxQSOH72LzOSCunVQzCJKJWI?=
 =?us-ascii?Q?acWsaedMw4Xmm68WMg8GQL5BrFlqoc58sBs+9KX4baDC4JYK1qeI8tZ0PpTz?=
 =?us-ascii?Q?YPxrN5IuqrQi4ZKitpYpoyjjmsUlSfX3Fo8cvPNJ3i50Adkiaf/ApxOMrtZD?=
 =?us-ascii?Q?3TscbJp2cf6jhcXpPQfZg3IFw9jCuDxTckw/M4Zl?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	VfK6Ycvv4Ev02gnm2wokhtvitqhym3APMcn/+UEflxs61bLJEepLe4aOFddJQxZXVI6WL9725q98ZqZBuZIYd13d8H5WGHCvi/3PfXvr3Pwmtb/8aCdDJzuBHyZDJKFB9p2rdxGFaPmZS916oQnqXpcG6LRjncGJ4zB8YN4fMaOA4jtvbmOPKogwc9egx0/H4FNFKjO51TRHB2lzLUeUP8PNINGjQ+6AmVHfQbR/R86msFQb/Of2qMsODF6PEMw3MMPZEIQ2yjGjxjXeEF67oEHcROzvpZ4bGZHWX/LVNnV4BezeJF/+1JkuLiYkOI6cvEaLW46haOe1+sagsz0zENComb1Zsx06zSvvB2rloQ2WTziwSfH/nAvS/wqwBnQ6FUbUz7nByk2WeTWUYhJsdYJysIc4RQpoYGmUvvDANewdRzqu6rAEmqD6A13yFYx843HexYgvagJQb4jetZxPhrGtaEfAnKUOH6HgEQK263mFdOhBmGfPYPG9z8l+HkpP1tDIEr3vhFUAaEkOG43qjfp+5eZFOqIQkXKlB0WxiPzelNxdJ52G88ByWc8ffwpnNM0ThphN8bA+yJ2jXdvSbMG5wkDysR4KNJHiwymxiP8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41923738-3656-4e32-fb54-08ddf6dc6ef2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2025 17:54:37.3325
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EUMRpkHjAMo8dUUPAuIHBkIUByYIMR3qLdFW65pnn9E8A95U66yzKVxIWvK9ADPTnYmoffVOQ9+MOkyybk1KJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5681
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-18_02,2025-09-18_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509180158
X-Authority-Analysis: v=2.4 cv=TqbmhCXh c=1 sm=1 tr=0 ts=68cc4762 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=vggBfdFIAAAA:8 a=RLX45CE-8YziD9JLk9kA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: JoToePhELhI6VlXv_ziL3XU6nA2bnkOX
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwMiBTYWx0ZWRfX63cu00KvzZhq
 /Pb9tAdk8XupDCRMimVGqVbN04SQ4IH0ZV7Nl8xH0HxgmvVmiS0xWJ18UOyAI+p1F0UphBM2bf6
 vfgTJ9ex7A91RkbFXydPjEYr3uzzGvKITKYMf2dG7KguSzQIBOKnoOQJmfan1wJmonO8J20VBlD
 tx3yAuutvhAgbQFc1GGI/j6EmD8i9JnzElbbl9Us5FIGE4Sp5viMwHdjRMF07sEPxB21gcD9lsE
 7r/IQtOiOUG9/OZmxazNtkp7UZrxyBF0JeuN64NF0fzmCNq/BRDYtV92XSG+5WXEbR6y/7DnXXd
 u8BzFLQGZbldEYTeTaJpfUfe6czxocSD03ZijvIzZhb7TmhYFiLbfhUxQVR8UQG3Cq/8J1n4bhv
 UYzHTbM2
X-Proofpoint-ORIG-GUID: JoToePhELhI6VlXv_ziL3XU6nA2bnkOX
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 30EB718000C
X-Stat-Signature: p45qjkrs7zjew6nsucifhgp46xqknpax
X-HE-Tag: 1758218088-374912
X-HE-Meta: U2FsdGVkX198lcA1FQKbXF1fSfQoYd+XCxe9L+oP6lfWI4BXNgg4bsRAbBQumnfFxLQGqstpRtLlXE6Sn+drTm6JSXyRc/ndHwZ9DHCudRdt8CS1ugFCxxOQRqBUR05JKCSLfFPeaNAebv9ZnTJjO4hJ6PsJnxJ4K7/Il5vCQHA/aP/V/+OLGBA/07M11UMyUOjZDUm9IHDiFHauiJGR3jSBnFq9mAb04LXk3rk3xW807LH6rLawB0E+T/G+DzpqnEaeR2i04DAMnth7DIFU7CISpb3Q+fQWLVSlhEtQyTXp3PLVyrMF+QzvwW0hS+RZkGSSjFZ4aaHLnLWUZf+K2caAzogq637WvApnNie+MxzaZh3Ct8W/0VTXfg7LdyztDiXz3kpNTWZxAUq7EugGbDh7EoyIuTFoY/HiI+3nAgqHI4BNZRbB9owEENQ305NMyzLyAAcUP823DAamwZ98JWNtOlwQvpFEB21w1D/TYDq4207K+jJvXOPk1rQpO3sYBBeUvMV5BTbWwfc/Z9R71qaIlMbFE8fd7uRA9ntk10/846z0/dCrZxPPcPuU0jSJ3vjkMj1127d78KFgDRHTwmsb5VmIq9cbRV+WZlfFMWJos3CK5+2cKxfttG92ia15HrQAteKkbvGhxyoFOvh+gHzRetKtGMRJ30VHkjg16pINg65lkfW/5ni4W59auvqFxqNFzYNWZGCoNy/f3Ricm4x3YniDU/mks1MkIGizAJAUQa4tnviRHVTFpZBbke9GWLYA3hA/NY4WUNrS8F6NP0xcqIur4WH5j1Nww7jdGzcm2FbR3VcQGcEjdvhDinExUTpKZdKNDReuZ6wAfYmV4qWCyMxJf5DkSDB7nkg4xqNoGh5D/PBa69KpqOAXkakfdkHxT1vuZInvRQpjg+0cQy7NLMqURIeiWi+XRrAa/GBmXA38izV0SQaJbSysSaFG2+p7COv9V8CPRUPtp9k
 hyk/dhIN
 h4pgl9h+YOdnqZCSYXVNd5oBDze71fVZ9xrLTiIiwW9S2QD6k2vNU5Nv1wO7fEWlc1nxKwhLWhx3DAmtPu0TB0lb6A7XSftP/SQKVoSu8zHkhd2QYdL3Eg2vnhPOckMZyTZMA4+L3Z9a7U/f28SshA6IjNtr6kbfR/3WAM2hUyFcJ+rDTWwmTJMQafxfCj44uMCNVH2Vy+tzkS2KXBo9A6lSsBGD5S6nU0zg5y30SOq4lMBnK8KfEVIF0izDsNg1RLBGMMlp5NQ1P1FuCteeaSY0uHZLbqdmLC3fINzEmuHZXLMRhi85u3cWZP8bH0gA6eX6wDiv7WRfoO0f+glVLPh3orZwS9vQj9KGh5n3PATYQx8RDpa0DBNyn88CW2682IQaF/awp1qlfFJkrvjSMfkJvADuyS5H4qyPo8vKH2Fjhetabg81/JClEgOaJYxO0mr+pJjpYk5Z8u7QidrHeRycsuxGEp2n3tsChHDwSyYTxaW+LNQFo7JoiBfuWhSYP2xlKWBkHJDanWFBHdQMADzQ+5oXEfOgbPoSZFodB7D7RRCYmuih/n/C7biiguxGFi69usfBVn09sIMRH3jNdCtXlclSvVFMscrNWcQ1bu/YDtohLFpskzx4lE8ap9kEJVBdmIe6llmb2bF3fO2+K/sItP7H5/teu2YHuRmcIuIgMD0u/axATxc93swXo+eJWXW+pUktD0KIWb1n9glEoZ282mvXb3okIICi5ZpD2gbXepi9bStE9AZ5drIj6l4POVT+rKj07Ww/bT3MmIYUzOmpfuvkr48k9sEPHjPM0mlnhWUDj66TjmY2cSt++RiZTA8ZhHptnatemrH6MCwKLkKhO5YU+RuHcbP8bDUSHdiiXrrs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Nikita Kalyazin <kalyazin@amazon.com> [250918 13:16]:

...
> > > 
> > > Nevertheless, let's step back for a second and instead focus on the problem
> > > these patches are trying to solve, which is to allow guest_memfd implement
> > > UFFD_CONTINUE (or minor fault in other terminology).
> > 
> > Well, this is about modularizing memory types, but the first user is
> > supposed to be the guest-memfd support.
> > 
> > > 
> > > This means uffd should be able to map a folio that's already in
> > > guest_memfd page cache to the faulted address. Obviously, the page table
> > > update happens in uffd. But it still has to find what to map and we need
> > > some way to let guest_memfd tell that to uffd.
> > > 
> > > So we need a hook somewhere that will return a folio matching pgoff in
> > > vma->file->inode.
> > > 
> > > Do you see a way to implement it otherwise?
> > 
> > I must be missing something.
> > 
> > UFFDIO_CONTINUE currently enters through an ioctl that calls
> > userfaultfd_continue() -> mfill_atomic_continue()... mfill_atomic() gets
> > and uses the folio to actually do the work.  Right now, we don't hand
> > out the folio, so what is different here?
> > 
> > I am under the impression that we don't need to return the folio, but
> > may need to do work on it.  That is, we can give the mm side what it
> > needs to call the related memory type functions to service the request.
> > 
> > For example, one could pass in the inode, pgoff, and memory type and the
> > mm code could then call the fault handler for that memory type?
> > 
> > I didn't think Nikita had a folio returned in his first three patches
> > [1], but then they built on other patches and it was difficult to follow
> > along.  Is it because that interface was agreed on in a call on 23 Jan
> > 2025 [2], as somewhat unclearly stated in [1]?
> 
> I believe you can safely ignore what was discussed in [2] as it is
> irrelevant to this discussion.  That was just reasoning why it was possible
> to use UserfaultFD for guest_memfd as opposed to inventing an alternative
> solution to handling faults in userspace.
> 
> Regarding returning a folio, [1] was calling vm_ops->fault() in UserfaultFD
> code.  The fault() itself gets a folio (at least in guest_memfd
> implementation [3]).  Does it look like a preferable solution to you?

I think this answers my question.. but I want to be sure.  Does that
mean you were getting the folio and doing the work in uffd without
returning the uffd?  I tried to get those patches, but they didn't apply
for me.

What I want to do is limit the "memory type" that we support by
restricting what is done to service the fault, and handle that in mm
code (mm/uffd.c or whatever).

What we get is more people using the same fault handler and thus more
eyes and testing.  Less code duplication.

Unless there is a technical reason we need more flexibility?

> 
> The other patches it I was building on top were mmap support in guest_memfd
> [4], which is currently merged in kvm/next, and also part of [3].


Can we process it in the mm without returning the folio like the ioctl
does today, or is there a technical reason that won't work?

Thanks,
Liam

