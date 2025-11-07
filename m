Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 776F8CCFA05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 01:48:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CB168E0009; Thu,  6 Nov 2025 20:48:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87CC68E0002; Thu,  6 Nov 2025 20:48:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71C938E0009; Thu,  6 Nov 2025 20:48:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5F8568E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 20:48:55 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 05BFC883FA
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 01:48:54 +0000 (UTC)
X-FDA: 84082127430.09.24FA1C8
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8A90218000C
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 01:48:51 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="fXU2Q/wI";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=mPRuhah3;
	spf=pass (imf06.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762480131;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ntpNRR1Bw3y+eQY8WOJn57vixYxAYcgUtC2mMqsUWEs=;
	b=BLTrEygmKT0tU3biM6JAlI0mwCkr/jBV/J5wr/HO4vHi44DGDcfo7MfZPLMvi857cK72Y7
	7Vos10kd+sAsqr3RAQi2SHJD8nzj+A8Fnauk5cTtpZIj0VzTbD1FU98o4YDE6QV87eHsaw
	7WBy0Y8KJyJYU7ogxaOsrMdwMSFAdoU=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="fXU2Q/wI";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=mPRuhah3;
	spf=pass (imf06.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762480131; a=rsa-sha256;
	cv=pass;
	b=N5ZQiqglRiwfSBg3GQQvcPJb4rxzfBJOyqpUknBgwcK+BGk9BLi7soCbVIjJzMXtD5Ggeu
	Po+F3YuKbTTVKGy7NzE9foY2BgOrlFuBfNCqSqVwi72Ne2B/aNRrsm6d+qo7hzJ76qzOGE
	e15comY90Phqj4FFo/CswseY6LPyC9U=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A6LNQBC023268;
	Fri, 7 Nov 2025 01:48:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=ntpNRR1Bw3y+eQY8WO
	Jn57vixYxAYcgUtC2mMqsUWEs=; b=fXU2Q/wIs35QkFk10blaj1TNj3+NYJsNQQ
	SY72UZC/O8ZYscfFLFC6Hykg9Vl5xVlznpHGyJC9At3NPdqnY7BL1nCsn3Yuh2sP
	dnTaaR5Sx0c5HrsblYdK/fINrKNCEWBJme13GN+vBMFe1PrE3EngZnoI+vgNZHM4
	qtCF7rbrbN+m+RnC/i9RkKC5T6wtDsQVziFb829tamxT2lPuUeLL9SDM4Z8uysHY
	HIjjKecsnfSiVDFulCJAYy/ZJ6ySiBnq4FmL+Kf5+dG4Uwjt7K39Vr5qXRKYktsC
	St22LTZHDo047YgOcCGoD6832jjM7CbIyeVGn2E1uCr23wMJcAxg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a8yhj8x2a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 07 Nov 2025 01:48:46 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A70TiDV010897;
	Fri, 7 Nov 2025 01:48:46 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010057.outbound.protection.outlook.com [52.101.56.57])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a58nd678c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 07 Nov 2025 01:48:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Geuq2iR35Lj32PhRPueH2jS6dx5D3cnTDHu4bKQOBoicMmfMN++2WCSwjkcVRAP2D9hqiFCwcA44EQfJ2pJcwdbeAjzgbjxnjs11P33N3HbYSPu2QW/+UFrjI9CGYkDTgKGHNq56IbjyLZ0T6zx5Z4JOH+McDADs2jHFVtcUHOhayZKIyxJ/MsnnCN8aezf6htZPNtR9YJz5irYfNjSrgZQAsAMMbESedcF025kvcktNnzHBiIo8kTAvSeYw8V4A83/AFRRCykHx0E9c4gf9e6Ezit8KJsMxcnZ/VLBS0ZakmQ3Xm7jtJXaoQqD63QHnSpqA5IBJh4aQ3A/oXFAbfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ntpNRR1Bw3y+eQY8WOJn57vixYxAYcgUtC2mMqsUWEs=;
 b=c8gg8jNgj+BzpdfnGh4GnqstEHs//JH28X35AcG0YaIFzM4SqcUp5Z6LoPk1xJt7CCAo567ZnUX37lBi2m7AAHVhXf5mj9UByUiAlpqyiqm2dd3iJ7ZcRen9IMl0GpxVIjP6+hDFhgxZWLSIlWV/B3sEjs8srUaC6pF/Aw53tljoDclbKnDox0SBvPKbD36S51CeohBfKSFQaGik4wl1JH7brzXWdxTXHLohkevnVnPZXLHJWXhtOo5ur9aRH8/YFSGiOZv+s2rYWWr6sBmU5ugmNKUhIJ+LdJI9ZAVaPUULXBQ7vXmKyuG6PwSM48+StsxFhACpjNIGMa2ZbuPj2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ntpNRR1Bw3y+eQY8WOJn57vixYxAYcgUtC2mMqsUWEs=;
 b=mPRuhah3icxBDlqEu35Fm3NIj5dlBkgwjt4xnBrv7suujI2rXzwqAFXNjsAkRGVDTAl5eHvzNP6gNrGJxPYmu6kXT9MRD+yuW+a36+XCjnovfnUcS6n1hQiZxbAQvBsBsJcEmLjwtSgUQ6P0pKilBmK7OewSLwAc1qGhFd5oaIw=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by SA1PR10MB6566.namprd10.prod.outlook.com (2603:10b6:806:2bf::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.7; Fri, 7 Nov
 2025 01:48:42 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%5]) with mapi id 15.20.9298.007; Fri, 7 Nov 2025
 01:48:41 +0000
Date: Fri, 7 Nov 2025 10:48:34 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        kasan-dev@googlegroups.com
Subject: Re: [PATCH 1/5] slab: make __slab_free() more clear
Message-ID: <aQ1P8mHnv6_FE7Fh@harry>
References: <20251105-sheaves-cleanups-v1-0-b8218e1ac7ef@suse.cz>
 <20251105-sheaves-cleanups-v1-1-b8218e1ac7ef@suse.cz>
 <aQxbp0cikSkiON5M@harry>
 <a1922c8a-6cd1-4d79-8a7a-7462a1e791f5@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a1922c8a-6cd1-4d79-8a7a-7462a1e791f5@suse.cz>
X-ClientProxiedBy: SL2P216CA0137.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:1::16) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|SA1PR10MB6566:EE_
X-MS-Office365-Filtering-Correlation-Id: 910905f4-43fc-4e1d-899d-08de1d9fc77d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|10070799003|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?avmjvdiwl6QSJy7N/Xm2lpkb0cvknrsNzj/fLmY0iolcHlmT7dY8/L8LM+RD?=
 =?us-ascii?Q?Z3x8zUVBeugKsQcRxEXtQLC7aefbg0BOLcMU58pddDf2c+B09EGMhqyL9Dcs?=
 =?us-ascii?Q?bhy0aQZJoKQjgNJQvPlByKQHAXvU1HROzV7p/D7FVIe4xbS+eCFH1fkMuGBI?=
 =?us-ascii?Q?2ynCRBEGY9+u0POyGo59P77EMsMe3EYwShJRgGaxyvYh+G/dsWikhUK5Rubd?=
 =?us-ascii?Q?ch0zXBDPJG4d1ge1jm1EjwUAIZjeGa4LiBIKG6FbjD0p1bePWL2aR8798Tlx?=
 =?us-ascii?Q?0xrtlJPzb5aVNTY7cZq6aMcpM8i7u7cu5NqMoPuGK1eDoagg3Ykxnv5nQMoY?=
 =?us-ascii?Q?am7DbuUVRj40AerphSV0iAQizIqOoiRs5LLIPV+q7Vzp6d0e5k/HSj7cGGtX?=
 =?us-ascii?Q?9enqizYqfL/9plh0u3SEQWX+jvxQgDTX33Oi1Utow0Qo5SHRI7uah9CCR96O?=
 =?us-ascii?Q?IDc1zd24fn4rUWkH1RJG2cXO9u4wZbkpLR1ZimyoybYnRHFTym3dbK/SWeXn?=
 =?us-ascii?Q?1PWdC3wGBrzef8eunFtU1DZXE38FEgnG/D4rp78JSysit4f+eyzsu8CE48+o?=
 =?us-ascii?Q?b9mdEobnWoWq1Ct8wo5VsYhVXAQuTSTKQHNnYyACyLDoN6oI0j+w0UPZYrF5?=
 =?us-ascii?Q?F2fi3OWHOIdkR/u+q8ZSb3f8wKTqEoQlFJp/Wv256unZfBoCQPyW4wAn7Jjr?=
 =?us-ascii?Q?TCj/qkps6aKUUhl3U3htz6Em3aTVqTTseDOux8jvEDoUtPMZzbUBw58OZe9g?=
 =?us-ascii?Q?diOjEAjGyl3aOFay8G46jf1BgLCgm99idrOvnQhUQ5DwCvzb7U2AWndC2Tb6?=
 =?us-ascii?Q?TSLLdZMGw6EbHFSmJMEwQiXF485U/c3KTHQhx0PYxT2PSgC/W4aIAxEOwIm1?=
 =?us-ascii?Q?zmnFkrA3f+ZnqI0pQdIek3vt9H/eR4wWr24aWPibP3GQhRjj4I8LqJCe/7tc?=
 =?us-ascii?Q?X0pAZujq7qrhXlJ88tJX6CCeW7vKmFSfWXpYg7ssKHZrva5mf/lcz5cYw3n2?=
 =?us-ascii?Q?2wGWGARjLqSbklP0Ea1k1znsdpwa/ShBEGlyg2C9eUregpUpLNw8vZp6B1yb?=
 =?us-ascii?Q?hp+G4Ftv/KQ9XpPGRTtEQXq/nDzl6fpbJRjVw/GW8F1oy42TQdFQmwC7lgsE?=
 =?us-ascii?Q?8A/iF2RCN0DQJYjM7POP4wZtbqh5qu5NEp14zWS4Z+TAPs9uQitmqK8pNry6?=
 =?us-ascii?Q?0L7JTMeAZHvx0lnWYFCfI+6HdaNemlQeQAL0N8UQcm9wf5EGK+BfS8vtqWjb?=
 =?us-ascii?Q?t0GzwXHhqOaU/fHJXH/C+g07nd0boCzxI/lu+Jpyh/rIIOAkVVlM326hCLLE?=
 =?us-ascii?Q?mhJ7wBEKBcp1eoHVDQdqZu+C1R9bWxvR5N8U2y9fEq1qmEI1ZcKtBjhXbSIh?=
 =?us-ascii?Q?Rz/MFtb+h0k/gBaEDnHlIGjXSFisY2dy/j/nsyazE3s4uzzpcNgsJBMqmO7R?=
 =?us-ascii?Q?ona47rt4Ts1FelW77f6nHag/d+PlmN9L?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(10070799003)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?o7szzA5KwAZeqgYaqta7vNlt5JjOqpUxBO3/IK4437whn7330GgQJuNTvPl7?=
 =?us-ascii?Q?6do6kGBeRbiO8LEHagLo/fDlnYLYUy2IN8tLHUWbXGwczAv58ei7c1BsSJuT?=
 =?us-ascii?Q?JELrwlgDgNdsg8Rx6QkXTl4Qj8A/el79W6j04V6ZdhTgRZFtzQjdGsX1prQg?=
 =?us-ascii?Q?4efk4ca7HWDNPa0NzBcV0cbj0Dx30xnvuoLqyBKPE2yLMQSBkCSSghc4G2kJ?=
 =?us-ascii?Q?5Alvf+Y1kRh74FkVoy3RCvTRQtkyP8bJVqu6Wl1sJQxnVJxGwY47jTxWGALY?=
 =?us-ascii?Q?B9C7CS7GxoW03eLMpNPw1cIWI3pF5KlxPwTbD56qhynp/V0V4aR/Di610sx5?=
 =?us-ascii?Q?YVolx88vIAts1WbZm/f4bkB+iSXGz/DaB9A/AtJoxYW04oCt5muaS4fBXJ7c?=
 =?us-ascii?Q?qu/w88kuwieh7zFiNMv3U0i3iHoPvWRzlYo00Fk6sB0C4gVa2otqY3hPg6u2?=
 =?us-ascii?Q?K3nGZNlvM63rAj57Ydp9H82czFBN8kj0oi5RgxYnwNvSbqAJb99vRsBGIlkH?=
 =?us-ascii?Q?7JkYSk7moO+HHyrAIqqN7epX7jGq8sdUAeOnw/trr9Ze0sY0b0WIGQCpiGXh?=
 =?us-ascii?Q?3TaCXaakhXdoqau5TUYPtwo0qSYBdCz89YJ5D6FH/ccPUgvDOf7HdGa23BLU?=
 =?us-ascii?Q?EAj+LUQ10U6+pZZbSwUIvqfnTt0bIEApj/bpGWSopm7XYDzqcCPfeuCi/8Jc?=
 =?us-ascii?Q?3PVobznJpjImtAmTuUKdeL6l9k+k2vN4Qt0ryfMtQYLN1hbMqj+46Va68FpJ?=
 =?us-ascii?Q?nRrf3yFOPB4OVFcn7EB5KHb2i7wKHCzdFs7RyoGT5KBeYNZ4lLnYXueDw6xt?=
 =?us-ascii?Q?1IOPH82ji5og/w2vBYjuucycSNfCC0UtzT12fHeAjuhFe7WZOm90kTIvPWIp?=
 =?us-ascii?Q?fCgL9Zo47LZ79X1T1O9Cz834/p6pHNO44SXUaUi1dupyCJP2hevlNH5LT3MJ?=
 =?us-ascii?Q?hOpzKu2fBSjePKsvfXUIc+p9DH35Y3OrGw7SnTdoEWMHQc5MjJwJdDKvnlrZ?=
 =?us-ascii?Q?3hOqCPlPvLqSWbDSyex9BTQ67ucfje6y8rfjMqxpTTYbEFclnzDelG/pb1XF?=
 =?us-ascii?Q?xWMcV8V67N37GZlENVB5XBAyUM1beb2nOd9u0j1fXZQDa4yQQuqxuz2jqA6z?=
 =?us-ascii?Q?M5K0ZrZcuS+L9rAiUcYMeAIT8magDmSGWWxzNuH7hjBG9ezzlEO6Zhf/18mb?=
 =?us-ascii?Q?nWZa7BnIAy3Ej3E/90iZzxvvY7cAFtYsXovQbVzfgr0McFcFFfuxsjVRJvVf?=
 =?us-ascii?Q?cI2a10mS34Od/d6I6Ptcpt/H9Bfqm58Iy/M5WEGb/XkqYJXTc+IpycBFzIS9?=
 =?us-ascii?Q?C71vidcZUbRr4FyG9D+JdxrGhwLZQ7sysPHa42gh4bO0Vuo6NGu3Caho3etc?=
 =?us-ascii?Q?PAYarMbZL/lQfUsJYvhvJiqSzWRKGme3NqPlxHlKtM5fgjWpxqsgzxSmnrro?=
 =?us-ascii?Q?eoe6ceGEgFgw6k8zAyS78hRnSP6XO9tTTNtUtybQDD9x7u3gXv6kuQ1ajxvL?=
 =?us-ascii?Q?T6k4Vb3quWZwfgZXhoQ7pLJQU1o7PZ8Dq0hn28MS2x3nsAsQNUzNZJunE9cy?=
 =?us-ascii?Q?f+oTgZl6kVwpENWNtUUHotAsuEK29sfWiiGQ6s1TkSHzQcKGzoAhu4N3E4Vp?=
 =?us-ascii?Q?hCEtOR7vKke/yJ45yX2OcpKC0AX4/cIXuG/2YHs+BOHS?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	dlr2G9+hnoWWEeXUNqw3eCEdGFGhyMFooWAlEoqcu+zDpH3BIrL+MCEy7cwXpPOd3qRtTUAb0FAWhUSzY1OLLTIYllr4oQ5fvewGY23rniwdWRyREboN8zBbYCYAazk0G775NqPao1twXgC+eYCxoluZCA0Tl20L43d6ZVYud6a/SRRJFLE6YBTQDsYnX8OkAQrTW71F4z4mp79FeY27n9bUWg63ZlpkwPqeddMqGpjFrog8Ugq2ucwSKogQyTvR2xsjo9XHyz04+iXWoUrmmYiVNXOYaorNjOW52mr5t4aTJEC/GdgnM3FwFJPpNYAB+IpZBOZ8c3hO7oUFxmC/UmYQisAL0ZTy7cpD27jdN2F7PehJv5P9mUV+pEGhFg4a0ML3+EMxtQtZifcgbWWrE2CVm9QNT7WIDQ0F4fQkGC0JrPhh4fZPcC3NraqBQJjz9qssaVuiFlQ+8L8GkLY197L2g+bN2+ZX0VObzoK9EY4xBVo8avBqzNsTwqbyT/6eyaZ3GufsXbhdXGrzH14h7iUf2xh9Rz+0lmC8jQizFk2sYuObXEBJ+vgZvh6YCHPuf4OMqf5bdc/eeThLWiFt5f/+bFGeWoj1uV/H+j3k+A8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 910905f4-43fc-4e1d-899d-08de1d9fc77d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2025 01:48:41.8793
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: htukk9mtNdqpbPetQaYwaCwR9hY49cypRsAfVrrkP5+KKOVy1hBgAruzg36KwwJOjg6PP/9OvGsNOZ0UB/H6Pg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6566
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-06_05,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 suspectscore=0 mlxscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511070012
X-Proofpoint-ORIG-GUID: CyvtgChxDzRsRn2kQv3nXjwtDj-JSv7p
X-Proofpoint-GUID: CyvtgChxDzRsRn2kQv3nXjwtDj-JSv7p
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA2MDEzNSBTYWx0ZWRfX3IPSOz7Cpmy5
 547NHeib0KU+HXiWUoHmXOX4peD390msU+TCzXYSOJqxg7LQg14mkJhGh1bAfuESAu5JkDq8ztw
 Wmspb0kqNjVjqXYp7jdt5BtKK/XTlzAAJVLE5rv1oRWK/So8+cZkSD6H97AsjQMLhQ5QWFF8dKF
 b6LvPw1Y4bYJV5qKmVe88tZ2n/eX7+9NvLZ+8cnNBqR5Q/YKdXzvgUsCVnUNzdnVyKFft6vO+Fz
 YrmKM0xKh8wG5R4anbGWEyMF9QqF7zS9PRUyBIKt2ebOAsvjAu2Q2SG/0T0VzqqyrvBkw50Fwo9
 okwBwhH0a1pPhiKbmJ2sCEerQflmp2zAfdzaQrqz4vcatd9A2iHR9Rou4R2m4eIMBxsS+tQgqPN
 2l+FNiNsE4bO9Q7Cd0V/+fVC3PwTKw==
X-Authority-Analysis: v=2.4 cv=Lr+fC3dc c=1 sm=1 tr=0 ts=690d4ffe cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=mkM6xrP5_q2gVVe3uQwA:9 a=CjuIK1q_8ugA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8A90218000C
X-Stat-Signature: bqqd8t4he3epkasitgsudbpr17b1xwy9
X-Rspam-User: 
X-HE-Tag: 1762480131-248039
X-HE-Meta: U2FsdGVkX18QLoaNwe1L2/NWlyIlAt/IDazx0tk5AcS7U1LuoLjmz+kt+NcylymaMHQxKFFhBF37LFQOSwHh9PtytHvBZzdVFb2QJcyERkX3smgVy1DIpWgWWe0t4O79LYKllcyI9yBVTXA65edTIUAxmMbOi4/JoPZ5SdFME0RafjY1nxONCWDa/koskE0hNhLYlOMZt10UVifl+pp1MxxB2lI8LYTZZrThh+CnSKmUHusdlsxW2e2Y8+0onSQTAnMe+joj6LnCP8xnRPj0+g7KWEXxcelWiaMSwQqjv8H/Kw5akM/tvJhF7QY0sIVq9lEljOg/jdGZEVhcFszuqM9soJ5NYoGrFmYFJvOwz4QlpmuIXqHZTR/F+GkxPRdSNn2AntjDpOMdI9CJW3FRvlv9OOrLcUWbMfqlF7oqMkd/34YdDGl8qbb8CSb4NsrnDsgtx8cXAUGMaa0GH2LM7VenEHGb7wH8qa5MhdRVg9QKwLubqtl/VEWszXvNKrhuu2okGMp0kM2/GZ4jgXPW008BcNzzWka3QDD9tsliZz/tYpqu4FY1PoztWCWiaPtHQpB5Ap3ITpJO/jSppoWJzQgy/nkYmYazJhRfTYzMaOxaVQiteWo7jb9mZvCJJkKd3+t1CF34NLrKgSLV0i5gkwtyEMZjeMFBTDuRcecPJSB+IfMyO91vQlKG9j2D+eWSkj5OHwp3xuzdp/YmFZiIJvb0zQD2kIy+rrmrUBw9NMFS7sF5GyX+1e9Hk6Hg0JPrHVdvqjBW3uFBDxyr81Y77PYYAS/RG0M144QAvzGHNOC6hTO4aJbMcatgO83kKG86mhxMkUqAwihBF8nSYCPMdf7kWv+2zHNnytdCEtb3eCnr+T63UCORX/snsqDHeovSZbeW6GKlDHhXxWtQ/RZca2FFxBOQSqyahDSTTiScuoVq5yTqX4G+z8iexTd1AlIugZq6uZ5z/K+Fh0O8n6b
 H+oP4Y+Y
 7O+8oErRUgg/ybYktc6iyKfyPCVNjIfUCfcpYg1SppPXfrQk5vRvy9xfizmtJKzcpy/tToCbaYbb9sLReSiWdFBT1zuJ5F0IUWoYmx37STPcBQ7rnKAzUKb0R19eZ53j/CiZBxROSW5FSUt1NttOS1hR600W1qta2TT3vidPJmWhm7CgdKvxhoIliRQ2phU9weDSvJTatPksIsPyQ6w6z4I8WbaeVrzrIiibrru/+UNx2VXHVMSXclCORzDW0WktS6SiYDnRqT5aq9TP9wmdrVGmWSGUFGtN3aNmjwSNin5fNaDsATLrKUoiFQ61soqiB9F8J0dQ2MOPigLZcKKbI8wgyOUZokpcJy3RUZkbv2269l3Gii3/5V4SdHrutqHOVc55QZIeM9YkpuQxpmxB8YAW9jy5MGnvhTjQHp8tZQpfRDzIFoxamiV98m3CDMMleyjqwLs1xMaU4WL1AROsqD0vA/caxCZ7FJRp8f6TCrvwd5xLbxzsOtlVbcX2aW+AvQpjCPaoGtT2ibTHt65t/YeB0MFw8yZXuqMeAhKzlMUTqWbzfL75Ji0JkUIcm6WdLPSzUZ3NhrZgIMcI2MJATylNr2QNzr4Jr1Mxd9ODnp0C9b4JYsa/K/ynMNzMmHwO1nt1wqsg21o6HnEEsBAwsO45+SxP0w3qhl5XiRps3HRMdvrrIQmez1+RM+1Lt0oWx2KAi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 06, 2025 at 09:43:24AM +0100, Vlastimil Babka wrote:
> On 11/6/25 09:26, Harry Yoo wrote:
> > On Wed, Nov 05, 2025 at 10:05:29AM +0100, Vlastimil Babka wrote:
> >> The function is tricky and many of its tests are hard to understand. Try
> >> to improve that by using more descriptively named variables and added
> >> comments.
> >> 
> >> - rename 'prior' to 'old_head' to match the head and tail parameters
> >> - introduce a 'bool was_full' to make it more obvious what we are
> >>   testing instead of the !prior and prior tests
> > 
> > Yeah I recall these were cryptic when I was analyzing slab few years
> > ago :)
> > 
> >> - add or improve comments in various places to explain what we're doing
> >> 
> >> Also replace kmem_cache_has_cpu_partial() tests with
> >> IS_ENABLED(CONFIG_SLUB_CPU_PARTIAL) which are compile-time constants.
> >>
> >> We can do that because the kmem_cache_debug(s) case is handled upfront
> >> via free_to_partial_list().
> > 
> > This makes sense. By the way, should we also check IS_ENABLED(CONFIG_SLUB_TINY)
> > in kmem_cache_has_cpu_partial()?
> 
> If you really mean testing CONFIG_SLUB_TINY then it's not necessary because
> CONFIG_SLUB_CPU_PARTIAL depends on !TINY.

I really meant this and yeah I missed that!

> If you mean using IS_ENABLED(CONFIG_SLUB_CPU_PARTIAL) instead of the #ifdef,
> that could be possible, just out of scope here. And hopefully will be gone
> fully, so no point in polishing at this point. Unlike __slab_free() which stays.

Agreed.

> >> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> >> ---
> > 
> > The code is much cleaner!
> > 
> > Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

-- 
Cheers,
Harry / Hyeonggon

