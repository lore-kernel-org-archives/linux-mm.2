Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 640DED74EFC
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 16:28:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3A546B050F; Fri, 23 Jan 2026 11:28:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0DF86B0510; Fri, 23 Jan 2026 11:28:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89F026B0511; Fri, 23 Jan 2026 11:28:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 75A846B050F
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 11:28:38 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 48B61D31AA
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 16:28:38 +0000 (UTC)
X-FDA: 84363761916.29.24AFFBE
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf11.hostedemail.com (Postfix) with ESMTP id E522840010
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 16:28:34 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=opKGs1kk;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=UqrURtAC;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769185715; a=rsa-sha256;
	cv=pass;
	b=BAew1E1m41pZHCABBCcdrqve4Ljc6LP3wfuiAdjHcLyT9BWvAJwOjJ2oyO11BRVDl1uhD3
	GvvBzXQnlB6M33199LESKtIZxdU5Q/zhepk3vr0ooNDHfdBnhdWRzL74W4Z0nbXYTYtcWV
	DKDv2xBcaTx2QVIuDwiNmkonzTBPRxg=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=opKGs1kk;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=UqrURtAC;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769185715;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y41xxQlUBKLqvQHraThElS/cJhC5Sd1HInD6USlMKLQ=;
	b=Jfx9hLdJQ9svk0ohDvw2khXkGPQn6gCRFBFcMnoH7u/cYyiM+NHQi6tNzs511YFNoMdlmp
	oN6jcaLLhqZnacHp5+c2D7f2cEJldppi+/CwSC6FZxvNVNIMGj1LwEZqRjiXyh3mhYEEZi
	mWG7+J0vqPcUn+SxahA+awaWtNHu63A=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60NFJNIv2270793;
	Fri, 23 Jan 2026 16:28:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Y41xxQlUBKLqvQHraT
	hElS/cJhC5Sd1HInD6USlMKLQ=; b=opKGs1kkehLCOzQI3NyWXMBKCWvXiB+jjV
	YQvHpj2W8ZxxpgEr7unGvA4t3jRksa6WYIAB4NvF3qhItL3Ow3NiFOheApz+ISMH
	JmbXUVrq2rnkR7eqeqitvFkkVNiOrKQS/PysxInNt7+s/QFujDamG+vvWZlQEq2q
	SxQZCa0Pv0TdEbIGN/D2EdImLxjMwSZVjrU+QlIGC9A83nakdZ/QWSsFHOZ8bICF
	RwBU7BMfMCjj2BxQqg2N45T4KtR4iO0qxADJ4ahv4EY3u7sFvBPQhL0hyAtKOuoO
	WRJZkWLhtrzm1smlAPFSiS6nDl1lc9fWwglgjZ9H8uU0y0ykAbBw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br0u9tsn5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Jan 2026 16:28:23 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60NGBUxK022439;
	Fri, 23 Jan 2026 16:28:23 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013034.outbound.protection.outlook.com [40.93.196.34])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vjb2ux-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Jan 2026 16:28:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l5NEEUJDNXQzPv5fODj1PK853DmuWeeCcP3a1CjDeS8GdqNKmXgTaimnbMYKr5njW1tDlkaLa/4i2RgzhyKOhWyU3bY7DmdBBbH65y2y1Ez8pI+Wt9nP3S7cCL9RT82m+tyXlof3mi+GUbZ0g1FfewWr/Q0Uct8auQ6+o2IRpB9KgYix7C98mM2tpAdWOu1Zbca8gqvyWF4YHAMfooZAuTVMWMgpxZFhkHOeTzMY8nsPEQokKgGBwK2b0M++CM4Kk2EkQ2oOp+cyXIU46Tzv5tC9Zw6bGIsaFrxTBRVwtfeWNg6YGJfgfMlR8WX7RFBKSTa1MhGfY29IQXw0OFV2ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y41xxQlUBKLqvQHraThElS/cJhC5Sd1HInD6USlMKLQ=;
 b=XQbIWfSwGfl6Ah/lVULteOajNeDddboNbrui2QcnJr9X0EuEfZ/Sf4pDV74j8kn+ChAiaa980s9OTquWyXfdLS4MCMgm4AiTbITH3dFaDVxbGC9Zgv9e3tLMWRVuMjXE3Zk4GmDicIMME6n8AF3Abs1hJDyDuLeLLEz9xq15gMG9Yt2orxd/+4K+IhCCWpUweiASHEINnT+18zzEAY/LOdPfc/bnwnboJY5BZ+QlTooG/o1EDTIIvXMx8tg50vLtv0rr16VZAgqZDMwypNEWfi+m6S4ibKQ1Ha1+8ig6o3O80ziRg/8SOB29/YAh4wZIMG4hr4bJG/jRcYTDLDCsOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y41xxQlUBKLqvQHraThElS/cJhC5Sd1HInD6USlMKLQ=;
 b=UqrURtACyuffbEllyhGDFtTEF//4y1/yX3LP6+pEi1cpUmlVOl4N348/v1DI2uOX902Qhh4Rs7zl5U+uDtjDXU5tnBzW6OWQKBQGXKVG2ZdsxDWwK99bkhRDM6qc/OQIyQbRC2GDu6CY1TimdTfebC4zO4iOU8nzX0gmMlabo9U=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by PH0PR10MB4421.namprd10.prod.outlook.com (2603:10b6:510:33::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Fri, 23 Jan
 2026 16:28:19 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Fri, 23 Jan 2026
 16:28:19 +0000
Date: Fri, 23 Jan 2026 16:28:22 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-rt-devel@lists.linux.dev, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>, Waiman Long <longman@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <clrkwllms@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v3 06/10] mm/vma: clean up __vma_enter/exit_locked()
Message-ID: <89fbbcf3-25b9-40bc-9424-f8fa89b1c03f@lucifer.local>
References: <cover.1769086312.git.lorenzo.stoakes@oracle.com>
 <f1981963e3c9421b6ffef19f15d87953895cd0b5.1769086312.git.lorenzo.stoakes@oracle.com>
 <0567268d-edea-4229-8bf4-bfbfc2af1fd4@suse.cz>
 <deb0271a-af67-4971-8e2a-be0f826aee2f@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <deb0271a-af67-4971-8e2a-be0f826aee2f@lucifer.local>
X-ClientProxiedBy: LO4P265CA0085.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2bd::14) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|PH0PR10MB4421:EE_
X-MS-Office365-Filtering-Correlation-Id: 303c8e77-6aa0-483d-cfa6-08de5a9c6b74
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?AJ1OoSjsI/bnqtkTl+ZRLVHZMdCqcDKjICguotnOldTU5LULMJLo604v0AqO?=
 =?us-ascii?Q?MwgqsxLHhwHli82FCWk8JTbfR08ayvZVwJp+XGLo4pn0IFbVKAgI9lBY30zd?=
 =?us-ascii?Q?R3FW7IHVqlpYy42B42ic5VZmDy1jX3nY411A10H6LOe92Y+t7DPVomDSJh2Z?=
 =?us-ascii?Q?SJ2KPauJ/Ijp7+EpZi+2AlTVrJzZxQVltW3+UUR6dua324xmcEX/tQe3OBlt?=
 =?us-ascii?Q?Oc5SoI7z7f3odBBkhvQVnYab7OfErKZ3j82sG4hQs98BtNFKf/pgudp8pE5g?=
 =?us-ascii?Q?RxSLBR99iOArzHJC6pt1g6JDyCpQmV5kphDhWrZMtnZt12icWySEWOW+O+Ne?=
 =?us-ascii?Q?wsX3NBz3ogFRg6W+CyYERi8Lwi6+07LLjDTccB5YWf3N3xAB9DsU02Ll+Hxz?=
 =?us-ascii?Q?q32ZZn8C9Snz2o5U2bFEaR5n0a6/1+OUpuJyNWpJQMCoClDGikOq0UDq2fpz?=
 =?us-ascii?Q?yrjB+gyYOwvrw4x+cf+opTiXnzIBgP2l+F+HtpQvAHiRJbp22zNttIeEGzhr?=
 =?us-ascii?Q?Nqvr94pRFovbxIBLCsMEUw9qzUZlUp7xt3xqT12RKD2K8iNry3MxbGV9Q5WX?=
 =?us-ascii?Q?1hWMbDJ9atJWsSsiw1anInV6IrxmahY5fuhTXLsDVAdJD1U0byaCpjOYRYZ0?=
 =?us-ascii?Q?8c2DsI2P8gnDBaXLpu/4gYHsEuZ2HDbdnufoCVCZUxqfVLUJjrPn/BILSAZr?=
 =?us-ascii?Q?nrV4xancbwuQsTk/9KtwcARTQBgCgRnW4SaDeHLi+o8b1IYOoGzQGJ4TXlCU?=
 =?us-ascii?Q?NuKeSil5lDnC9M6KuhCvzTFyAFRPO7Ip5bQgnbPT2JDxLRFhC5L1M75vLyC8?=
 =?us-ascii?Q?y6YAIhxUuZuXTjOcERKbBnpZ2Nz3niA0YTvoFMzcjgssvhR5jHUc06rQFFXK?=
 =?us-ascii?Q?+CHYEjPGOvjVf7tT0Zr8mphQCRKG/HlM5+LaKPCaBoRIh2yNrFdni5ih9S+B?=
 =?us-ascii?Q?ud2J7tyuyVIRRVh9uF72UGe4q0FSVLCvR3yIRfYPqqj8npINmf+LS6ZIWx4W?=
 =?us-ascii?Q?PCPx7l/OP/DrN7jYfZ77H7vPKLGOWKb4RgSNi3XTfQBKO66p9WX0NnYhmDHX?=
 =?us-ascii?Q?GlHoU6YuXjEVTsCMSsaiQB7VF58YKuEKb5GmdpW56oQJuVX8BL7ad/PCMM2a?=
 =?us-ascii?Q?POZB5Lay+DL52SBGuN7RGGhWg/fEUUt36swFL6NXGzNfQucYSkvANyRMWqA7?=
 =?us-ascii?Q?dfdvGC7DCZIMs5++1Q68trHPNm+ulUavq/+L/GoPDNH9EpEV7zHdEo8U16Jl?=
 =?us-ascii?Q?WOdKANqY6p5g+tUszaiy0svsi0zuk4kfHmW7sUjj+9NHwYngkIbCG86ro5uB?=
 =?us-ascii?Q?SLzzs5dviQ5Qb+mqVjm0EdCJ+WENfxFrUaSpkH5j88pa/FbSwA/E1EVajK+7?=
 =?us-ascii?Q?z6HpTHaJjRokvKl4B9nVcvimEY80LK3RcQyp0JekJbEGM+mVKg3JK1t0/LFs?=
 =?us-ascii?Q?88dH8j51++8hWDZFZj2CMv3Hp/5gNFJwDmSU3bmFBt20x+X8Z6GpB8QUc3gG?=
 =?us-ascii?Q?G9XX6tCIzsIW0vPtji0sS18A1aD9dfljgzLn1t9u895qe484T+Ali9ggP1dg?=
 =?us-ascii?Q?jPWNItOUp3UokrE+9fk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2hihzIpSgR6p3uyaW2W69eybawqOpLcspAw/kIIf7WXptsf5IHwcJ620LfsD?=
 =?us-ascii?Q?HCG1A40f6jfERKuEU+E0KBjZlg3ZdSKxpOhW6r+gaEUQMcMb9GPD8YiA4RWH?=
 =?us-ascii?Q?T31voXDe9silYpsHfXo7095kKRKvT/cxF5uqCQFuBT4FjV4acI1iv6jQn/+S?=
 =?us-ascii?Q?UtvxojIRXoIYczT1TneKVP/u/F/JiwK+1lhcBS1CyDHdU5spTdEV03EDXLbJ?=
 =?us-ascii?Q?gG1sQ0kHZjaGYp4CjEYtrYHSI+eQHHsgZ3XyiNjIE2lWpaSK1yRvgpc7HYSk?=
 =?us-ascii?Q?+9fmNFnBpFpqhQd8Y3Cq65+FjcKWQfzDhe166sonuEF5EeTRry5p6gqYtDtO?=
 =?us-ascii?Q?wh2v6yXHzjnkjhADEidFEKYTQJB2RPoqdJbkifQ8P12nae4JwZXemeXzX4z7?=
 =?us-ascii?Q?HIHzGHliz+5cNY0Z/LGU089CpcoS/GQ9t9RrQ6VRMi7ivL7ywPWRnY6DVssR?=
 =?us-ascii?Q?NIsnG141qKoUmMRgFwDUh4b6+GIJdvgDWWqfEaVz4Z9u53PZZVgElEkyhG/5?=
 =?us-ascii?Q?ZcsjOTljl9jEMP4R0PTxZXs8xn84tzlC8ojDnYuWCrgkCnW8L+rtIPx9n0lN?=
 =?us-ascii?Q?IepdCvhaigt2Cuhtl0T4JFNtiOjT2GA9xs+4vMFtf14VMLfNY3UwicZhhMHc?=
 =?us-ascii?Q?ak3bv5WODFGZmojlzm1hg5kB/Cps5a0UOCSIXQyRSC9PnuI2wIQ+N+IEuOZE?=
 =?us-ascii?Q?7oQFeAspFlpOmdnOrlEHl3zCxa3wwvZfj6p793BcCEB0ctrPyZuQJFCs4Ca7?=
 =?us-ascii?Q?A3yM3DVwWsH+Wu108Lc0C8NaWlVrP2a/Ep9XbSMVKpJrz4bnjJ0IFnKB6LNt?=
 =?us-ascii?Q?5Cd+ot34HHYKanICUZoWOegHApeBVrK5jjgAo486p92g90tjAL1f7YtEfqYG?=
 =?us-ascii?Q?iEDpH7RpXDKdy3lGFwQpwPQThfnGYtyA9G3tAyUnu+VuSNI1JWuKEHDwBgKr?=
 =?us-ascii?Q?+kDCetKC4tLuYU3QvwlbQZArNlBMxTroR2fmmuFic1ArFaEm/lxUn/7aCKlp?=
 =?us-ascii?Q?sHYzbUWuBAVxVqZilIPaF2P2rciSSQJWye5x1n8Wlrlj3ZQYaXtP426JEnMK?=
 =?us-ascii?Q?B/NLaoVoGhOp3Q5sljmVRq1FMMgLUuZG1TEBmcqrrzXVCg4+tqe3WDLbWOnZ?=
 =?us-ascii?Q?KAcjkVOR3UUiEDs8JQOAmSZgAijfWFyX0MATTtaw2kZvnZ/d1+EnVRhEBMZD?=
 =?us-ascii?Q?mMNkKaKKsqAbhiN7Mo9UIcOoE752ZgkF6ORQ/ki0PNSok/kzrFP2NYqmLf5U?=
 =?us-ascii?Q?nux7LEkUfgbLPppK5ooLYwr+04+hkIH9Z0we0RrCyYlOq/drC73/4JNr3byz?=
 =?us-ascii?Q?oxJM9PjV8ctZF3mgmfMVfwmKJQBdShHSXC+nQweWDlkJI5bRKqTzfBQzRPkM?=
 =?us-ascii?Q?m/Q38uWhlPZGa/WvJJe+EsmCDk5gjvGY/rL5zpmzdbrvbuh3YWfpZyY1YapS?=
 =?us-ascii?Q?PreTINZeb910PhukIyKpyE10B960yAX3Qumxj9kXp0rHjDOvJ7ymqThr6W3J?=
 =?us-ascii?Q?25KWR4avzR239flJlP5HDbFLE5nuO/PVjwwpE8ujJ7Wn8JF3Av5wuLfJ8jPm?=
 =?us-ascii?Q?ycUHKs1pv6H+Qk9lqH6DXwImERg2mqGJtiwf4zmbjed/jXw55nzHY/LGqj4W?=
 =?us-ascii?Q?ugPLvJrDTiyTqFmoOMoY4TSxkkzjjCu02jaM1tLeN4JQijP4pTHtwig7bikL?=
 =?us-ascii?Q?7PyHBmwLBfCr1uC+SSBVjN4Ftpcrmx9jmBt/3rCJhqoi2nCki6zoZftIDrbT?=
 =?us-ascii?Q?gnV3aU7lEn4bGkCBdM+SIOAhSpA7HDE=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	67qtzxPtRW4uATOOeHI9A2pZJlQp98j4AMjpy9bnf5/jnIiNVtdESwnibaRWugU3WvmzKdqWbuaHm/b8jVY7e7N0h4UeZA5li8pw9c+VSibxiBAb0mD6Ggps9xfG+Udd9C5AmSuPxZs3BtOZfcocLHI7lB7KrUs6XlxL7vJkdNDyP+iIsRybnSFV9EJ6bxhTJ8ztKQzntoLjm2OMp7cTArQYG7mB4ZsbTooEeBIL/TOXo3B3lr/axB3m0waeS2+SSM5Y0Tk3JMhrYekgk9sT21HgZMQLDzybki4FFOXrRZg5ssZ5sHjeDV0ZOS9DHNha1/e8z10PXd/fqOOvtMUXZap7ii9rEIAT13dbkqIFPjmiTIGNNiEM8MWNP7bl7+lZq2EItq7YbHeveRpij5HrEbpfuBfVCQuCKfMrrudJN1F2HmHVt/ZzqvEgrUnes57b9FSs9TEkS+bNoT2W1emNfY8NQ33YSq0KzwL018Ka2J9rvNUpB5vg4MwgJceJv5WHprnK70SqsoRtRa67hI2LoQpb72OdRu5Ro2BYTqDpHIzdgLwvkJM7auV+brfG2JsCcMMoV737wQKyEei8gxJl0FnFmjxILrvIS4+kJRObfLw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 303c8e77-6aa0-483d-cfa6-08de5a9c6b74
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2026 16:28:19.8284
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /SuBspWapEhzftlLlmrMxsYGTJWvdRMpPl/jSwWmgvzowqRo4kwRwuwG+HAlfK3oyzH1olwluOqLxrkEAyd+zUaj8cVUWD/Gh186wvjnNEI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4421
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-23_02,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601230123
X-Authority-Analysis: v=2.4 cv=OJUqHCaB c=1 sm=1 tr=0 ts=6973a1a7 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=vWSWekDQ5-h1ZfxgX1gA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12103
X-Proofpoint-GUID: xGwOvlCWG31uzrPOnAUWNWgvftzURpeN
X-Proofpoint-ORIG-GUID: xGwOvlCWG31uzrPOnAUWNWgvftzURpeN
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIzMDEyMyBTYWx0ZWRfXwsSPp2TuqCme
 H1wknYEnjONCul6i2z5E5D6Q4Kmt1Kkfz5Zlb4r7Ueofa8Qxa/laFwTRVzvSC91ZEOQI5JGh/9R
 wJNBVVqSjY84nUc9p6bNvfr/9r4CogNiUvjdBSh7LSW7fiN3/ZB1at5ZSl4ju09RFjLqU5NH2yy
 NqhKkaPuGQ7MTuZThEMHyNhhFIwGL/XqMkFt4KPu7XfbxwVH6j+1cpE5zcB/XcV5Atol+rxEDQg
 hVRJqC58csocztQL9UPIK1V1f00xGPzsX329Zlbg4T3UWOl3csZ8erreijFDBFxZA6Ivsg7cxF7
 L36ZL05ZuXlqgXGzIYGTTH7yTug2zD80UoP3wXlk9a3ntbqp11V7Qz8RzpsUuadXggNvCf1PO9V
 LKGiES74Lb9rzWbYMmV8wdfWp+MQOC0CNIOvXOWkMEk+XWtrHAOGLiAafofRFPJC73j8eMlYKVb
 LBMtYtvisPPZu5Rr4FFi7cSF0RMoV8TueYpFtlv0=
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E522840010
X-Stat-Signature: zthfjqrragyuu71oop331fhpdgnikau1
X-HE-Tag: 1769185714-386284
X-HE-Meta: U2FsdGVkX19NRuxhqgbVYAeQVu3D0Mp8kwUoSbUjZy3RMevjgVgdZ01lWbxL7IwcEzY1cvCK6kiWvOblrNqdApp+HcEQyhf+zYq29eAvY9SgmPzmI7OcVnoiDtqOZZxYZ7FnkgUvA7X8hw+cNC8vLHpMbPywzhjR0BKQ7tDsujpYs//HCVB+Ao9EgyelAlelIZnaS32M9gS69baAbnYpGVxuhO9zoKGHmRjCg2GgGi+p1tdcSNjhkCaY9HYsisVedqTg3uOYuOs0fEmkP7QU6uGw6Qt1HIrTlpcD6Lf2WFT8ExeIcfX1GC34Q7W0qujoZVTULIGW+FH2YxnwZRSeIqhDKm203iJs5OsaT88WC7iuvc9tMsEfgt5ztIfhFOBd+GknvPys0/QgacKl00ex/Gtyjwi432zpS23N1LSMFv1HdUdFl6oV+/QllEqQCoDchRA/IAoofGh0bpETIRxwd09F43GDXvhWvUEieVzdWHNb2z2+MQAtv6MMTrutiCYGBjLPeIf11T8SBvyLXTsFXrk1uWBdYm/bPhTzMn/1DwM20ovz5+b2n0Phyk/OvsLPVrmBKK5xjboyPBwV7CbggszWcsIV0vVp+eNAAa0fLh8xmwEgCh2q3caEtMqayCalfht68AVb1yWwPx3Ov5pf7qkRaL0OQlLDbBLsuROc4lWatarQDdHi0Q+Qjcp7QqGKTl/rbiMuHi6DKMcFnCWDEr9W/yY+ZK9W5fl/rO+WnraMlfsmZ/nS8PQfCVRBbCOx6/EDg7JqGjvMmm275fR0RHOtjx/RCbA/gLzOxIwyHpj35+a5T1+WbJ6jIPI3CNocWZtGnablioD64NcG7MV3PDFzUb1SmgSihWQ/mjqE7uJsyw1CSia5yGa9Ne14PMlAgjVc6B0S5q5zsdcGjKBJox45Qww9WzDRQZUBVdiuhiKlAmOVlXeXgGlQMVh2iOHfF4A6/A2zX5AH55c8Cps
 Ix3dazNE
 rfFUY+XaG1vqFkYsu/OaCX8lpNQMu70O772CCC9N5Q+lbHgZ0WB034k0lxBxFpgiDJUtRCmA59bcMvXFPVFp7+BxAQ3sVCp/+kEf8ktswP9uOrsGQ/1Ue/3WdovMT2tkFbF9voqqANbwP4FSJtlhSTrG4tBBrSVvckJU3g1TcscdsIHd0NTw/wB+H/mGUZNWpQHjZ+rpmNJ8o8dOwPHInLsHh8ruSAUPfoOzrAZpE2WBUv9cqSwewBezxS3g90v2ZtvGWGs06NQAGi2XGUf1KoGU8/j2rJGICQUM1pTJhozBBxuUGHZOSK1Va3xYy19oAwJxW1oBOtDZcNiEpQCmIy5KJPScVjiq5LfqXnmgzB9iUBGqb10ktiphW4q2JLy+yNZ4TLmswKP3uncrYbLd3kE2HplJTtuXs+EiGalS3qO6yo28NhyDXKD4lIwcqSEg8+3CMPbWdT9rXmuvn9xKt3DqzB730P0cn+42VnkX3s/fGkEJRUM0WclUKOhsiBGtd7bcT2N1BGtLc3veN67LAWoex1lQgUC6dj5eFENgF7ZgVBi1A2luqPqoawkQ4t6SRQAr9nFmo3LAa9HiSZ4cvpBt91K9ESPctOrg8TRfBNRHe0Ooztu2itjCaMXiRd+GPYTkFF14cJMVfdXQPEgXpOn1+xFdsUgKvsyU1f98t5bkVresWcYKNFjMdA7wVh0ZaH9/WqBW/JHspUS4MfcE/OvWkvMiBOgaL9cZ9kKfbBuFhgIs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 23, 2026 at 04:17:54PM +0000, Lorenzo Stoakes wrote:
> On Fri, Jan 23, 2026 at 10:16:22AM +0100, Vlastimil Babka wrote:
> > On 1/22/26 14:01, Lorenzo Stoakes wrote:
> > > These functions are very confusing indeed. 'Entering' a lock could be
> > > interpreted as acquiring it, but this is not what these functions are
> > > interacting with.
> > >
> > > Equally they don't indicate at all what kind of lock we are 'entering' or
> > > 'exiting'. Finally they are misleading as we invoke these functions when we
> > > already hold a write lock to detach a VMA.
> > >
> > > These functions are explicitly simply 'entering' and 'exiting' a state in
> > > which we hold the EXCLUSIVE lock in order that we can either mark the VMA
> > > as being write-locked, or mark the VMA detached.
> >
> > If we hold a write lock (i.e. in vma_mark_detached()), that normally means
> > it's also exclusive?
> > And if we talk about the state between __vma_enter_exclusive_locked and
> > __vma_exit_exclusive_locked() as "holding an EXCLUSIVE lock", it's not
> > exactly the same lock as what we call "VMA write lock" right, so what lock
> > is it?
>
> Well it's not exclusive because spurious reader refcount increments are
> possible (unless already detached of course...)
>
> We are _excluding_ readers, including spurious ones realyl.
>
> >
> > Maybe it would help if we stopped calling this internal thing a "lock"?
> > Except we use it for lockdep's lock_acquire_exclusive(). Sigh, sorry I don't
> > have any great suggestion.
> >
> > Maybe call those functions __vma_exclude_readers_start() and
> > __vma_exclude_readers_end() instead, or something?
>
> Yeah that's probably better actually, will rename accordingly.

Actually went with __vma_start_exclude_readers() and
__vma_end_exclude_readers() as felt they read better.

Cheers, Lorenzo

