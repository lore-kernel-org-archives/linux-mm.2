Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A426CA1013
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 15:41:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 738F48E0002; Thu,  4 Sep 2025 11:41:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E9BD8E0001; Thu,  4 Sep 2025 11:41:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58A058E0002; Thu,  4 Sep 2025 11:41:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4528B8E0001
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 11:41:30 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D1244C0270
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 15:41:29 +0000 (UTC)
X-FDA: 83851982298.30.157F12E
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf15.hostedemail.com (Postfix) with ESMTP id 67AEBA0016
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 15:41:26 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=bzd80nU4;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Mlh03033;
	spf=pass (imf15.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757000486;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0QjGfjJq+sXbtaYTSbjNTXVLd77NRon55Kx9YQSd1yM=;
	b=XptfPxqm/1VR51r3Ejrqt2IXGoT++GrLjAf6/4xvVqoYL9n358/UNG8Lq0SOyWPLxNPfMv
	W0fY05PEkRMNhaSR/+/DYhjXnSpPgyXEfaT2blUFplvbfPHnSOnR9YvjmCC2BxiLepguwy
	vqK/yVCyWCD5x1UQyhhFoBGJRcIZO/c=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=bzd80nU4;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Mlh03033;
	spf=pass (imf15.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757000486; a=rsa-sha256;
	cv=pass;
	b=NqIwsCVDvDpbDj2GOffUKpM9L3yqm5GxYIgUs72k8ZMIVsVreuqqx0URqomvDLSlzGKyyr
	T3z8a2lPIt7BU6mnEhUx0nJdYdVIG6D5qf+fF2/Vku3sGfDoA6gj5IicfqaD2/f1Nb9l9n
	6T/cFIizea8Rcq+QWl0BYMCuQgeS0Ds=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584FYxEX022118;
	Thu, 4 Sep 2025 15:41:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=0QjGfjJq+sXbtaYTSb
	jNTXVLd77NRon55Kx9YQSd1yM=; b=bzd80nU4W8wPPIqb+H/gefSoIZg0futcVN
	Yvo4sNj9u6J++5notfg5qY3AEywzo+vHFPT7WhVKHKX8Bfc8W9aU/ovwWieGy2x2
	FlrBBqxxxHc3bv/xpGb/0TbakiuEzf4GsIu3CHfoUpoDNqbwAtetg0gr5KPu4pvC
	kJulYZxtr/cG5fU5OcX4f1Gv4yIGSSqBqmSa2KZqW+03mSMVkCd44Evj3qzIPptI
	M4cmnSesp2/sFp3NCuH4HH1yIwaX0p4jCLw3yukfWlr5gRq0WONUa/JRj+JuSrgE
	W1v7Qv+CTl0Oa2WVfHqIcKCuQOPyy0C1yxlp1BSDa22BqLhzGSzQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ydhd00gd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:41:09 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584FDvBQ015809;
	Thu, 4 Sep 2025 15:41:08 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2078.outbound.protection.outlook.com [40.107.237.78])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48v01r04v3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:41:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hauZd2O57WfXNUX0Qyi0Havv7m6WJUJLcC9p++vdT2eW1R7y8j9qlDDeSeiwakC0XmcRrxelNKevnHtZOODFlhwiXF80TRc+Ghr6CyxeE+f03NXme4DuA8t7uIlhp0FNFw7zNqgkskNJdSq43p8WrEB3veybodWudHtCmiA5yNq+jWtz2RN3E5cQpIEAS9ecBG0uCjql9sxcHttUdkt6T34nX0IAh9fKOf6lEMDouBHNuJt+wKqObbYWs3yxWbEZ9F6q1HK3aKWMWvl4V9R+PVIh7IaR8tI4mNRxajmHiiSFnEi0JxFJWwgS5elh6axKD88fkI0/g20tRWiIMKwCUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0QjGfjJq+sXbtaYTSbjNTXVLd77NRon55Kx9YQSd1yM=;
 b=FiqZMNL0ahJ0Cw1MXQ4kYGIzG3hojE28Ts/kMTys2dTgZL5dENP/ijpnVRGIJayzYpWvupnx+tbPYBGXwIO/tEwkMv+ERLl54z0CegqkIBdnhtnVUnT2JYAEXTxCkjCwEA3d6rZtDfnV+FQ4l4DqiusU33ftxuW8Z0qrX/vPcAdXWGw/ouocqw85hRRdCLDchy67m/k99dL6CiRXPrc7d7sAS53AwnSCM59Uki5fob56uA8P9z8SnMXJrYJSAsjP/aJtuoyrCn0U5FfYhrLI33eLUxfxSK4nLdAxb69cwhL/A+ILrxR5wr7gbwqZXi6uO3/HhaQ1oZrYSA1OaON5BA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0QjGfjJq+sXbtaYTSbjNTXVLd77NRon55Kx9YQSd1yM=;
 b=Mlh03033vU7aaJSOv+cllXlfdb4M4gLqJiKTtFFa9XOGVKcOrlJ1bO7xRPI31Bx8nqtGi36ANNR6m2VjmH2b4Gf809NWau5PuCqSLLeeo4nYZpfQh32O+7DfhY4RfViywDjAsJuS4MdJhNxtt0JqWCSWTkxfCivzHNYfDXB5FLU=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DS4PPF66324196D.namprd10.prod.outlook.com (2603:10b6:f:fc00::d22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.29; Thu, 4 Sep
 2025 15:41:01 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9094.016; Thu, 4 Sep 2025
 15:41:01 +0000
Date: Thu, 4 Sep 2025 16:40:59 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        David Hildenbrand <david@redhat.com>, maple-tree@lists.infradead.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        Charan Teja Kalla <quic_charante@quicinc.com>,
        shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com,
        bhe@redhat.com, baohua@kernel.org, chrisl@kernel.org,
        Matthew Wilcox <willy@infradead.org>
Subject: Re: [RFC PATCH 6/6] mm: Change dup_mmap() recovery
Message-ID: <6d59d785-9fe0-4ed0-b9a1-b9419d2f7ceb@lucifer.local>
References: <20250815191031.3769540-1-Liam.Howlett@oracle.com>
 <20250815191031.3769540-7-Liam.Howlett@oracle.com>
 <de385044-e9a2-45a1-b74f-68ba80bba146@lucifer.local>
 <jr57bivqyzarzicmitzuz4unk5g6gytfnh5olmradn7nmei7yt@s35yr2zhknz5>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <jr57bivqyzarzicmitzuz4unk5g6gytfnh5olmradn7nmei7yt@s35yr2zhknz5>
X-ClientProxiedBy: LO4P123CA0317.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:197::16) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DS4PPF66324196D:EE_
X-MS-Office365-Filtering-Correlation-Id: cfdf4945-80b5-4e72-534a-08ddebc97338
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3y276srVrUZLcoJWh/Ud/ipjuECxC5hGAjAYjkJ1oNH5dKOgOA1ua5Hl+rO0?=
 =?us-ascii?Q?4y20L7GRGY4RNIHU8p4OHaZfR2cffHAfjwvTm09nT7tr7ea2ZOehm2um+KOp?=
 =?us-ascii?Q?nxexo1rZ/5FWRmDFTjxj7pqpyy0uG0FgJO3hId9gFMvl8dVdApkCPnH0h+Uo?=
 =?us-ascii?Q?iPVO59O0m8CgSPLbTUCAJkP334EvWoqFYghTBHSCc1cB2e8jACuMUgpI+c2L?=
 =?us-ascii?Q?Brzm1UR43cPKjjV3DoG3z4OXyZG7S+h0bEe6AZH2p/PF2NbYr55PVVIQcc6a?=
 =?us-ascii?Q?iTgC7xwyMXp61zuQ7gUPQxH/bwC0fqx9vCrlAd6AukXAQrcvYfivw/j8gM9Y?=
 =?us-ascii?Q?dxWLYTjPfLDeL5sheveT19GCAWbKbqelq5tEKZupowv/LyBhlNdIVRKwBYHr?=
 =?us-ascii?Q?hnj2KZ9O/fjl10NWs0us+kc9bAH1IF1aJhyXFjNzJcd+ns3izxLgCOb5pAvc?=
 =?us-ascii?Q?wx8X/ChIWkZ3lLaMmF41ppnEDZ57hMlGs//b23WKX4a8xPbcZ1POP+HX6O1X?=
 =?us-ascii?Q?HQg0pjAL2J8xDKQgobsptT0Q8uJ2Ws9pzpY1ljf2TAMRD2jGYKKlU9gY6pB/?=
 =?us-ascii?Q?rJsspNikC1vzSWlHqrk5R8Mn5eu7VwhI9R1Jb9ILbwaAjBGqpbbeI4QaQCTZ?=
 =?us-ascii?Q?Eehe2GH95Xh1d79PQl3nQmPsP8jo1LY6tAq9DTJZB8X46lH+1GFJ6nx/DzOE?=
 =?us-ascii?Q?qMZ1+k88JMcnbQWt47MiwEbm2wJppXaf8fbDRWzcP6BnsyIFKMRcQROcEsHk?=
 =?us-ascii?Q?/uBCO72gt6MjEkmYjCtSSf3I/V/1BUfMyQcww4rQHGUrsfEtJDVn8D0hCzq2?=
 =?us-ascii?Q?sLvu/HcIp0kE940jsQqKIAl2ztJ9Wvv6Niy13QZXHq0/xxMMkCuZJqs1idPA?=
 =?us-ascii?Q?ngbMEn7G91IGFijCaJJKiepF4BBCanOLN0DXIE7TvoNXGelNxAioL4SGrapp?=
 =?us-ascii?Q?9scI69hB3A75xTRXuLd2WBQ8MYusCbuDyIULCmMuOXLyBamCYAzNAncrzy16?=
 =?us-ascii?Q?drR4aBSD8ukaSIhjvmskXpjjgKIHDx9xqrwS4i2M4SFk67fDSSL7FEWziN9l?=
 =?us-ascii?Q?TDFPRaRedx9v0B6xiUa6+Df3XbAslLtpjzmHSQVMQcI6FAUR1jenVUwM9gnE?=
 =?us-ascii?Q?G4SEKJBvNJwMydcHNZace6xNBCx296Ng7nnFk8aNM0C+YWwT+QKtUEn2a7mP?=
 =?us-ascii?Q?sztz/8KaKk6mzaWeBhiXrgOWWs3biZgHeYDczr3KOhtL68nkVk5di64DnE9g?=
 =?us-ascii?Q?lmpXNNlORde1/DlWt3IkS0R++tmSYm0L+gabkRIw0kU7ktg4aUDZWuB84f4g?=
 =?us-ascii?Q?iz9bxp4qesJjlOMnyeK4uMAk5aJRR7DqUpkfAxuIIV4azktwlbKHhqeDyOKI?=
 =?us-ascii?Q?t8/kQ8RUhpaNI1DwAgBOLJYf4Jn2SaTsO0qy9gFzBBl+hEJC3v81l8yRe/O2?=
 =?us-ascii?Q?NItxKHYihtGQaj93M1TFN5zkFyOKVnXin/W3OMTeN2293xsPDalUFA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?OLrZXnl84rum+Z73I0MIErF9QyLy2xmzYu9mvfsE1yuB5bakZ1yYeC8mqLfw?=
 =?us-ascii?Q?TqQmFZhLQtLG8nFWhnnCJCsTcb9d7p8RHT1eUF5X/hXXhggtvn4sUueISfUJ?=
 =?us-ascii?Q?YferpF1eeH6H8N6yY28jpx8JNvY4FeCrSsP/nGjIHa1wXjI6eArU1VwHNC59?=
 =?us-ascii?Q?gXdIB8iP6y5u9qpVBum6DjcniZNZAU5Y8ie7jCa0arWuakDJR3MBQm4N6y6T?=
 =?us-ascii?Q?hT9z8bFMcv/cqEvlU7cqy9JWRVKBqYLv+QkO1dqlbr4NzY8yEi5Xe+US3vAC?=
 =?us-ascii?Q?gZSp+gsHSDdY5uzay1yL/sF2WFDqjOPg586AjZgz/eCyP1xaOTRpoKs6FPTf?=
 =?us-ascii?Q?qDhEn/BauKUelkl3eSEtKwXIxC8ZTxVxCrH0ZqyJDrcUeyAk5M7FIFZ0Pn2S?=
 =?us-ascii?Q?86kHM/6owopg5RNrN++H+8NHPkcKd1ufcmXaWAmxxvAlGCBuPsQsCPyk6g0C?=
 =?us-ascii?Q?80fk4kSrFtXtuRsvhWjTsyDzYUGw6s/pYn19JczkL1fHJNHsUWPVx65x3cvE?=
 =?us-ascii?Q?OpuGF318AGX+q9ki+zWNkVtBKV2JD5G1PTc8AQWNYwvUvIr3xnClXjsY5o4/?=
 =?us-ascii?Q?xcKZZKt+ebn3kGFVpUgr6PAz30JxdzmDYgvaW2MIKVhac+MtqmUL8oMaPntc?=
 =?us-ascii?Q?JCArMcBG3K4p8XEAiN+XgM472E48Qysh8SxSZo1pHq2lpV7J/PdCtIkaJe43?=
 =?us-ascii?Q?W93onQ9PQ/1yYv86CF7NkysCWnJErES1Q+tTAMXZLnOaVse2bEErCgVyN/Un?=
 =?us-ascii?Q?GKZyrkrST1fBGblPZ5FE8mbR0nPwekKizkmAxu4jZgRFQK6QJkv0ihQMdZ+S?=
 =?us-ascii?Q?2eW1tPQNHazyXnN2zlacENH5TCfjkSuQj/Wbf60z9WMzXTeC1I2q8TgZjR+0?=
 =?us-ascii?Q?GXY63D7fqhVJyF2LqY3j4kdEzHsXvGsnygUsc6aIEhHS5VzQw8tYfpUA0T40?=
 =?us-ascii?Q?GSZ91IeXmy5hBduW9I3aeCmoss99btmULrVcqkvSfofjDfBBDssa3TayrSKn?=
 =?us-ascii?Q?uHpXDLpAS42dnbp3CwxN91FUdpnjKAjLQR6xz7zMAEjTydXC773mgx7e/mL4?=
 =?us-ascii?Q?yODCP7/HpW0QaOzqbQmgcV8gmTCj4DpQneFKIRUHPLvWeEfDuqN7ItHqRnO3?=
 =?us-ascii?Q?HTSKzPRMvzWHknZXnoopQG2PrIFPnIsBW4RV2nG2kzjNC4LPS9qY1U+iZMBr?=
 =?us-ascii?Q?+kT1dv3U9Al3OG0FNalyVJalTFLCvbGFgpTZv6AZpY2Tip80cj9OdvtLbwmJ?=
 =?us-ascii?Q?hSB/sydDoeabjnmOpZU/4ZXABotVNvAxnQhME6ruz3HFtL7SiunKgp87cDuB?=
 =?us-ascii?Q?eylWnYL6DrIPhuc4/QsBK0kx/H0PcpVTVCOcFK9ucBdeV1OnR7aJs1/8Nlbd?=
 =?us-ascii?Q?V9/SCYrjkoPTirmqXYAsLVd9A2DVSH29kCjYJ99XpHb4yabAEM2tXW3jfTW4?=
 =?us-ascii?Q?3zH45EryLb9/m62DsqdiVVIqxHUd84Ap3H8pVta2WORZadLaSlVjyitoJiZh?=
 =?us-ascii?Q?P6Y3oKIxYk3G+pYyaCcJki2ApEojOXHljHg4h8SMpAydFp+C2Lqhmd9Id1Jc?=
 =?us-ascii?Q?FOZrBqyr087zxQcPYMZzUeeHGgnQtrCS5m7CX9xXaT5IdSwZFk8sVZT+jgjL?=
 =?us-ascii?Q?VA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	VhQodUCEJ/OMxezYFq4JnoX1uieyXPBVNu4T2q5/X66Jq9JkiIklBDaGDyPHZP2Gci3RV9B+nXBepQg9ePorc2Yr02ouIZ7oJEagxtwE1LxREgE2B3NHW5gXQvYreKR8OtrJ73gmKRRVRXpfBBiJ7ncC21l2z6IOKM9VW/2kiTS+tghhxuxYDxg9hdKMKoOJRjfGvqvBEGGZ5iSk2wfTTL7zkbK6s6bVDER5+11UN7yQ/+LiFslfXm+QvO3o1Mjnc6gVfUo/Z/ByX/Ap2ghtHsmoNIZbJ0zhJbIgmPvtVj/3NpEBlJFmFLEUFii+kMQ5CFTC8AEi9EUpU39BMIoF/Ygbj0bkRizKKBiXTyPNprRUI3V0ezgA17N7NSGnvpIV24fZkvmlKbG8I3HKOZO4iA4/+AI6xdhWmk/DnVvXp7ezWvJBMssu4L20G49rN/isLzVUki3AL0NLxySKzv/hCbdERlc39l+z4hFH7ziff/GRTI2iRxTK8JddxZBuiEtxTCrx8/i4LARo5myLyJmIs3pzvipps2iCe3AXjtsjiLkaFNdPOVifOK64/MiluRly7GVDSpXrnEmQf/MQzs/4q8jcEbymVLJp/a1aTMeDBYo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cfdf4945-80b5-4e72-534a-08ddebc97338
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2025 15:41:01.1110
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SJ+Kc+mGr1VFafEXA0TvnC34R2u0Eaf8d5cac0NVcysUFacGPcrAItK7ALIJaVcKgSgW0eJnVtex+SuRI08hFwN9ZT/dg1DQdumaNKlBuMM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF66324196D
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-04_06,2025-09-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 bulkscore=0
 suspectscore=0 adultscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509040154
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE1MyBTYWx0ZWRfX1HwhAUGqhSK3
 bIglVQWRuMk9NnbnAGa4iHGWPVFwb/NTtLzj8i6eaNNmMZyw9IYTPZgbqdEFAGFFJ+TfD8+SWi3
 Tymo8TiJEdiafJDdbBEKHClnT9+u7spfBQ34cIO0+mZhJmquMJ4oWNdVhTr6Msa920g2Rr/XhRb
 X7KvaJHh0FAUDhREfTT73xyxP+8daDpy59twiPbTBrWYKSEbhQX1Y+d67GcF4ywxBin6BfxoVet
 bM5njYEQZKhQgGKeiBFSe28rGiO2wK2eGhdrg1HJzjyuxdOMx3iazeBU4rPGHjT8SivOINz8GHf
 cTslMxlhIyECZ2VD/eVbu+O43uLgSNQELW0c4Isy+WqY+/mnwNuWNxHPd6bGIf/OiD4UKNaa6NQ
 mU4TbD/J
X-Proofpoint-GUID: EtyYlApqYDxUjf0Cfh8hQuq5xXjAaNWu
X-Proofpoint-ORIG-GUID: EtyYlApqYDxUjf0Cfh8hQuq5xXjAaNWu
X-Authority-Analysis: v=2.4 cv=QoZe3Uyd c=1 sm=1 tr=0 ts=68b9b315 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=b0hnUdlMOSf_WmDoS3QA:9
 a=CjuIK1q_8ugA:10
X-Stat-Signature: yxhfoie3uudgperw45dx7bcnarkpdny5
X-Rspam-User: 
X-Rspamd-Queue-Id: 67AEBA0016
X-Rspamd-Server: rspam05
X-HE-Tag: 1757000486-836116
X-HE-Meta: U2FsdGVkX1986HvN5bbxoRzk0wdjG5J5wDPe8H3JLSK/EeN8p4WdwlL1ZJ2OjeKdVkclqXxxKB81voDgfDZcqkFAZLy6X2dPEdmk3Y6yICobMjLLrvKS0rA1nKLK4KqUPhoVoEbW+/xW21mmt3S/hN9j/Ojhuc+3Qme6Nl4vxIe4KI2nNDGtK6nBdKjJ4UME9iGkkgbC1ydfqRu+JNKW7//AMiTKDnWH4txN8Uyffgg4ohC+bINXrYsT83JcXSF9FbaSacgWURh0NbSD19lpFDI+aSkFfhdDYO+MwjhzZ+cI9LaAjwgbfOWAiQIdvYBFkrmzmuOcDZJXtPSudJ1oQcLT98eG1mYjU7I+aCUlogbxnU/V73jfrYKf08GyncE0OooTc6HK/yJ6HDGd8CiD2z+ZfikuA8Kw3KrNPhStG2swQeHu98D8zHACO+GluIUHHBoX444jQ6Q5DOGTwt3wJlOB2ActBkHBQdgHybXhrMlIx7twbJivPP5S6k6vzmJtcJyI5rJV0kWDmqFFIDaBJPJ+Gvtr24MnH9iizV49t61T+tIW8/CRf0Jh/v8he+Tb2avpPmVZwrcSsJ+B/e6vsJugbob277/6sw2sBiAtvZVsJeNgL/CF6KhR0Q+WZ9gYOkhzX73ha5mjldC35WtVDdUcoQOa08nef7zOjYUHEObeLhRDPxZdfzBmNVHfVs8IFuIm6Omqdj0bMObabTgEg6jb572QoKjwgTFaUPbZMoC4C+jK7At3ya4q6fCYrZAA+mWebXXrXUs9e6wPgt4Xri8F8jarwGGHz0ldoD2gccxuYSvAYNKAuVrBt5uAYNC9VArdxOlW3YoOX1zao74nIV4LG/qgBJHCfkeDwZrh956KLf3tu8ymxsM2eNsMaAJGBmcZZsD2zKNsID8pNsR89VznPUe3ipTywp0BWEnP92BO8IetzOgK12ueyMJpum0d/2IMzCzIdSjKBGpJe5b
 BrQD760L
 pDj8Oxx/vprGJUjnjeAh6YpuLZ3bDFn07EqwfFgqKMLumc3TRydVHmjt0YJxIFBrHzpQJqKfVEONaQyxrPW8WrEKVrbFxJ+eWAhM7FKibZzu9VgrFF6IwXPi2A3ICjjkfU/HzxNMpYoP8wg9oniaNvBUn+7XVrbgeIpeIukqXB2DRIupywtSoNZLU9eHN5A0tFVdRIycjqTqooUAs9e0iUI6Gt/PXcsc9YuTef6oivm2gAT3maAEEhvwwfSuOytqKmOBiFZ9LYMiCNp/nO4TVYwDnH+O+NapcZGvXD8czeNr81dzJveGqVvRyOTPFSXC3v5i+gJICuaj/Q/oGxYL5Ofhn8iYFvvoMGxbfLN3Ay1SyiwYHXAyrSAw8ftQS+jLwuJLRmAHmmJJR61APgeDgGqbQ4CXQAKwWnyu7rCL/bnqsMeXr4UnD+joEQ66SnvPkgtCtofvT01NtMjamvL/jAnsR+mQDqjY9U2kf1Ylm/tAyZn1sAeevYvzi6J6nOfdZlOrefFtEkGd8VDFwmZ/1aexVEXqSUU57smrkQntaPqITjqY1VYqrijHCQQH5eA5jrHZen9X8tdrteBu/5HxbFaqZuGQui4JNfwSlFFbvBciBrsMCqELAufzBA9iM3r/v40ydfnGgIVtVeQc5YUeZFRwiphAXh8aajMac19QVRmGmWU7Geq4WC6muOEG9y+nGKpAFjhSCrL6D6UpUon2u0DFX6tnSHaw0LA2sr1XGf++thtD0Dxn1O40K7A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 03, 2025 at 08:13:45PM -0400, Liam R. Howlett wrote:
> * Lorenzo Stoakes <lorenzo.stoakes@oracle.com> [250819 16:34]:
> > On Fri, Aug 15, 2025 at 03:10:31PM -0400, Liam R. Howlett wrote:
> > > When the dup_mmap() fails during the vma duplication or setup, don't
> > > write the XA_ZERO entry in the vma tree.  Instead, destroy the tree and
> > > free the new resources, leaving an empty vma tree.
> >
> > Yesss like it!
> >
> > >
> > > Using XA_ZERO introduced races where the vma could be found between
> > > dup_mmap() dropping all locks and exit_mmap() taking the locks.  The
> > > race can occur because the mm can be reached through the other trees
> > > via successfully copied vmas and other methods such as the swapoff code.
> >
> > Yeah god.
> >
> > >
> > > XA_ZERO was marking the location to stop vma removal and pagetable
> > > freeing.  The newly created arguments to the unmap_vmas() and
> > > free_pgtables() serve this function.
> >
> > Nice.
> >
> > >
> > > Replacing the XA_ZERO entry use with the new argument list also means
> > > the checks for xa_is_zero() are no longer necessary so these are also
> > > removed.
> > >
> > > Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> >
> > Ah finally the 'action' patch :)
> >
> > Obviously my review is on the basis that you fixup the rebase etc.
> >
> > This broadly looks right but some various nits etc. below and will have
> > another look through on new revision - this whole area is pretty crazy!
> >
> > > ---
> > >  mm/memory.c |  6 +-----
> > >  mm/mmap.c   | 39 ++++++++++++++++++++++++++++-----------
> > >  2 files changed, 29 insertions(+), 16 deletions(-)
> > >
> > > diff --git a/mm/memory.c b/mm/memory.c
> > > index 3346514562bba..8cd58f171bae4 100644
> > > --- a/mm/memory.c
> > > +++ b/mm/memory.c
> > > @@ -387,8 +387,6 @@ void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
> > >  		 * be 0.  This will underflow and is okay.
> > >  		 */
> > >  		next = mas_find(mas, tree_max - 1);
> > > -		if (unlikely(xa_is_zero(next)))
> > > -			next = NULL;
> > >
> > >  		/*
> > >  		 * Hide vma from rmap and truncate_pagecache before freeing
> > > @@ -407,8 +405,6 @@ void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
> > >  		while (next && next->vm_start <= vma->vm_end + PMD_SIZE) {
> > >  			vma = next;
> > >  			next = mas_find(mas, tree_max - 1);
> > > -			if (unlikely(xa_is_zero(next)))
> > > -				next = NULL;
> > >  			if (mm_wr_locked)
> > >  				vma_start_write(vma);
> > >  			unlink_anon_vmas(vma);
> > > @@ -1978,7 +1974,7 @@ void unmap_vmas(struct mmu_gather *tlb, struct ma_state *mas,
> > >  				 mm_wr_locked);
> > >  		hugetlb_zap_end(vma, &details);
> > >  		vma = mas_find(mas, tree_end - 1);
> > > -	} while (vma && likely(!xa_is_zero(vma)));
> > > +	} while (vma);
> > >  	mmu_notifier_invalidate_range_end(&range);
> > >  }
> > >
> > > diff --git a/mm/mmap.c b/mm/mmap.c
> > > index eba2bc81bc749..5acc0b5f8c14a 100644
> > > --- a/mm/mmap.c
> > > +++ b/mm/mmap.c
> > > @@ -1288,7 +1288,7 @@ void exit_mmap(struct mm_struct *mm)
> > >  	arch_exit_mmap(mm);
> > >
> > >  	vma = vma_next(&vmi);
> > > -	if (!vma || unlikely(xa_is_zero(vma))) {
> > > +	if (!vma) {
> > >  		/* Can happen if dup_mmap() received an OOM */
> > >  		mmap_read_unlock(mm);
> > >  		mmap_write_lock(mm);
> > > @@ -1858,20 +1858,37 @@ __latent_entropy int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
> > >  		ksm_fork(mm, oldmm);
> > >  		khugepaged_fork(mm, oldmm);
> > >  	} else {
> > > +		unsigned long max;
> > >
> > >  		/*
> > > -		 * The entire maple tree has already been duplicated. If the
> > > -		 * mmap duplication fails, mark the failure point with
> > > -		 * XA_ZERO_ENTRY. In exit_mmap(), if this marker is encountered,
> > > -		 * stop releasing VMAs that have not been duplicated after this
> > > -		 * point.
> > > +		 * The entire maple tree has already been duplicated, but
> > > +		 * replacing the vmas failed at mpnt (which could be NULL if
> > > +		 * all were allocated but the last vma was not fully set up. Use
> >
> > Missing ')'.
>
> Thanks.
>
> >
> > > +		 * the start address of the failure point to clean up the half
> > > +		 * initialized tree.
> >
> > NIT: Is 'half' correct? Maybe 'partially'?
>
> Thanks.
>
> >
> > >  		 */
> > > -		if (mpnt) {
> > > -			mas_set_range(&vmi.mas, mpnt->vm_start, mpnt->vm_end - 1);
> > > -			mas_store(&vmi.mas, XA_ZERO_ENTRY);
> > > -			/* Avoid OOM iterating a broken tree */
> > > -			set_bit(MMF_OOM_SKIP, &mm->flags);
> > > +		if (!mm->map_count) {
> > > +			/* zero vmas were written to the new tree. */
> > > +			max = 0;
> >
> > OK I guess this then will result in the intentional underflow thing, maybe
> > worth mentioning?
>
> No, nothing will happen as the if (max) will evaluate as false.

Ahhh ok. This makes more sense :)

>
> >
> > > +		} else if (mpnt) {
> > > +			/* mid-tree failure */
> >
> > Partial?
>
> Right, thanks.
>
> >
> > > +			max = mpnt->vm_start;
> > > +		} else {
> > > +			/* All vmas were written to the new tree */
> > > +			max = ULONG_MAX;
> > >  		}
> > > +
> > > +		/* Hide mm from oom killer because the memory is being freed */
> > > +		set_bit(MMF_OOM_SKIP, &mm->flags);
> >
> > Obv. update to mm_flags_set(MMF_OOM_SKIP, mm);
>
> Right, happened on rebase.
>
> >
> > > +		if (max) {
> > > +			vma_iter_set(&vmi, 0);
> > > +			tmp = vma_next(&vmi);
> > > +			flush_cache_mm(mm);
> > > +			unmap_region(&vmi.mas, tmp, 0, max, max, NULL, NULL);
> >
> > (An aside for the unmap_region() impl, maybe let's name the pg_max as
> > tree_max to make it consistent across both?)
> >
> > Hm we could still use the mmap struct here if we put in vma.h. Just have to
> > set vmi, obv prev, next NULL.
> >
> > So:
> >
> > 	struct mmap_state map {
> > 		.vmi = &vmi,
> > 	}
> >
> > 	unmap_region(&map, tmp, 0, max, max);
> >
> > Possibly overkill and hopefully stack ok but makes other callers less
> > horrid.
> >
> > Maybe also good to add a comment spelling out what each of these params do.
>
> So I've tried to do this cleanly but it hasn't worked out.  I think I'll
> add another struct to clean this up in another patch on this series.

Moar helper structs! Yes yes yes! ;)

>
> Thanks,
> Liam

Cheers, Lorenzo

