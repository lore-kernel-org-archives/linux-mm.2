Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDB4FC982DE
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 17:56:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F6FC6B0005; Fri, 16 Jan 2026 12:56:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A4006B0088; Fri, 16 Jan 2026 12:56:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1517C6B0089; Fri, 16 Jan 2026 12:56:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F1FFB6B0005
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 12:56:27 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A0ADE1601F8
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 17:56:27 +0000 (UTC)
X-FDA: 84338581614.24.17D38E7
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1CAE212000B
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 17:56:23 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=O3UFymCT;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=pZLR4BrL;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768586184;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zSsylmx1e+/y+iYWwDyMKOWz41QhnkG1JtmFtNgbmxw=;
	b=19dtakUujpNUbrO1cbeLIfEEEOtAfBtjJ/CWE88uQhceluLCoAOGlhwIPGvgrA+Et2arw6
	2n3LNfcMwWzhV387kyQxGIqJYQXdqV+kc6wrvK+qsBGdpsVZu2qBxFSstk6BvqaUCovoDd
	k9WJlkRoXwVdA6WIl3/YOyxO1IjYUtk=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768586184; a=rsa-sha256;
	cv=pass;
	b=gRKHz/cW7SLR2+MReRfL3+kVsJb4m8iklyEzMdTs/7ZGKIYcE994XiE7SGPzRE24L1cYSK
	v/B/aeUt2EH9IeE4hQmzV2Z3Blihefmw9lFTuvvG081oBZ7zT29BkMkHV1SsYfdKJxH1lx
	xA7B7pbXHYnfkA10mbYA3RmSElmb9/E=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=O3UFymCT;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=pZLR4BrL;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60GDVvo21655865;
	Fri, 16 Jan 2026 17:56:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=zSsylmx1e+/y+iYWwD
	yMKOWz41QhnkG1JtmFtNgbmxw=; b=O3UFymCTUDciY5R4cNqhIFLMVVAWYB7Sk5
	77Cb1WHTsLPpWu9bXUgVg8nSVSSWj5yacheC/XcMt0FWSQ6m0ytIr/jkuhNVoujT
	FYAA19jvL8bcx7wnY45aRA7l/6LEly/GHkW07qE08nPZeoDB6GCW2Qa9b5nsL/oZ
	Eef0uyZG5z3nvyU6JP+GbEiEzilRUIwE2itVMmI5+PV7mpCA+epJmppzynxpkkOx
	nBQMQzVT6Y+mIX0WV7pASGBeD0vs78B28c0/zSJYZ4z/QxcRnYxtV0SdEidvvBBk
	UdRbx2UbAtvSbY2gjOQBqs4WjaHozeNmN86MZJpFpjJtGVlulpLg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bp5tc5qev-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Jan 2026 17:56:03 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60GHSLZu008170;
	Fri, 16 Jan 2026 17:56:03 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011013.outbound.protection.outlook.com [40.107.208.13])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7cxgyn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Jan 2026 17:56:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cbnwiho1iNoAUTpw0UNgINhiWGrF9iov16qGeKomkQilKcAm6NnD1YcjOnYCjNxhFlMuL2ifQKTZBrdVPsvoDQetiIaeG590qUVWSAK8ufiqPjSPVG9RsrGyOjpTjk0+fFGtNlGsJrOIcF+77FTvi4FRA93B5Uww4MydLkuOGDsMyCg8dwqDkIVNKMqSY5U0zhU6/f6c8jlX8eJgj4HYmh4zFNDkNtb8rRT7B1rp+kIZZm3oBJ2GvFHWVX+HGk3Se4PG3137xOW1EtZ/joNfbYE8loqG8ugPz5QsSKPFVL3dkBwqiGcsP+r6pV3AHs2G/GaAKHAdXFu1b2BE1ibEew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zSsylmx1e+/y+iYWwDyMKOWz41QhnkG1JtmFtNgbmxw=;
 b=g2bPrtafTyY1W9q/7TDbvonm8zzHWUiLX2JHBoYzo1ebIdsqMXW5AsSYVtXQKQAmLbkE5wa+dM2cKpZc/lINVPsiZqtWw7VwBcl42LFfS6aJ1Nd0mEiIO+0Nk8+SZhJyCwJg1zQE441k2LNXqpBwYOKAondasW7aWUc3xctmbunO8JvmGjJOpg0d99QhdI1T1uIE/MyyVBVRh9N52ro4c41h8WYxktRwLyO7beZSJMf7aBopYxesRi2UAMN15OUt/vPPl5oizUldOtFPlB6zOPILO3oBHGChTaA78fhl8aHQsuEqcIFejqXbEDmMZv3iRL6+jLn23bw2p4b7PFiJlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zSsylmx1e+/y+iYWwDyMKOWz41QhnkG1JtmFtNgbmxw=;
 b=pZLR4BrLRosxstPMk6onJecZi8ahp2ipglr4hQVSMypS6O47OVyryyM43h4E24BT/dTUb1mquIaBY/Iud0qEta0TDF+WYOPrD1HRBNsFbhcP03H+L8x3z7IMkj5sT3NIoimSEh8/vQRLpLYSuwVWT8D3xw5/BoV/cxNtj/EFGVY=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by PH5PR10MB997734.namprd10.prod.outlook.com (2603:10b6:510:34c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.9; Fri, 16 Jan
 2026 17:56:00 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9520.003; Fri, 16 Jan 2026
 17:56:00 +0000
Date: Fri, 16 Jan 2026 12:55:55 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: kernel test robot <lkp@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, llvm@lists.linux.dev,
        oe-kbuild-all@lists.linux.dev,
        Linux Memory Management List <linux-mm@kvack.org>,
        linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Pedro Falcato <pfalcato@suse.de>, David Hildenbrand <david@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, shikemeng@huaweicloud.com,
        kasong@tencent.com, nphamcs@gmail.com, bhe@redhat.com,
        baohua@kernel.org, chrisl@kernel.org,
        Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v2 08/10] mm/vma: Use unmap_desc in exit_mmap() and
 vms_clear_ptes()
Message-ID: <rdkyeoi77thmvujvdi3dgg5c7m243gzqg4vanyyg25he3tblxy@mvvwnlkr55qu>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	kernel test robot <lkp@intel.com>, Andrew Morton <akpm@linux-foundation.org>, llvm@lists.linux.dev, 
	oe-kbuild-all@lists.linux.dev, Linux Memory Management List <linux-mm@kvack.org>, 
	linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@redhat.com>, Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>, 
	Jann Horn <jannh@google.com>, shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com, 
	bhe@redhat.com, baohua@kernel.org, chrisl@kernel.org, 
	Matthew Wilcox <willy@infradead.org>
References: <20260115182720.1691130-9-Liam.Howlett@oracle.com>
 <202601160919.v3GpIeUh-lkp@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202601160919.v3GpIeUh-lkp@intel.com>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: YT4P288CA0005.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d4::27) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|PH5PR10MB997734:EE_
X-MS-Office365-Filtering-Correlation-Id: 658eafc8-d732-4901-d1d6-08de552881fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?CQ9KWsISeOZRJmYbC/2+9NWn/bkqzTm6HAZTKQlM1PgA7TmEFybL/6EQqN0+?=
 =?us-ascii?Q?FBvFrXR/oIFAGFDjzyNCF386uMtKn9qFroGwGKzo8gj9uKtj6HT2lxoZUG6e?=
 =?us-ascii?Q?wv5usp2F4MtiQnJFjzgmliag65sBmZqWVM5wc6Nhbenn75a8gqsung73VXuE?=
 =?us-ascii?Q?No5xNHhOaohLOyx25VUikwRX6b15P5ggqMz8oSUwaCj62tlkAnG8nTEkQUu3?=
 =?us-ascii?Q?Fte8OJN6iepFjkREqngnq+XaBbOKFT6434jiTKJU3lvw+UlXnB204BVv5H9S?=
 =?us-ascii?Q?Aq3Z3MQ3nWnytPtbEPZtzCw+GMC0wxaIj2ORO5c9CpB8x7jMtUBnhMa9TeM2?=
 =?us-ascii?Q?yOd/CW7rykg4uuVrMp2aslDDQMU/ER1NErdE+DXEJyL4PZ3unjbxa1Jm9/Z7?=
 =?us-ascii?Q?CYTA9Ub4U3iK45fNWwAQELvRB1Ihe+h2iqSgPhNuxMrblRfLx7DNibv5uJWk?=
 =?us-ascii?Q?0yXSTFqJU3lrdia1D7sgn0gow7egGQvL0NSYbrjUxxZFpflvb71psLVAZT9U?=
 =?us-ascii?Q?DfJeqZdy/HDeqbUeCiRnAAjKW4UXMn+LYqsQ9BytEevAelpDDddwE1wTVgft?=
 =?us-ascii?Q?CVgawYmxA/DXe0kOuNokkJuuJpMxgKc5Ak2bbbF5vtl3105OtgJX1JMTiXMc?=
 =?us-ascii?Q?nPkRaZmUSWhdnYo6agOXeVwZhF+d/JQdnsbUiJFmmQD2Y4q7vJ8p8XCfYVK/?=
 =?us-ascii?Q?3HkTfjiHnlurYIp8Y03jawEi36k/Ka9t3BN1izqhqWFGyZTZwNzDrYZj2r0b?=
 =?us-ascii?Q?ZlTPeT9xHp2xwjxIxnBud/SE67Td2dRRN20J0PORtAtfbt6bStpPF8qEmVrW?=
 =?us-ascii?Q?5AipFQ4z8nA472+wgAhhrQ5vPvr6yD7nWQ7mpn5Lt+y6CT7jSoRIunLzV+Op?=
 =?us-ascii?Q?eao+9eAA1cYDhBB3nCkpCUMToRoS76cKrI/7Lvf020NVYqVEVIP7nEObIOpc?=
 =?us-ascii?Q?yF7JxiS5jN5kWWqVEquZxgSZPV9HEomyx/MZ0UWoFrBZySiwUR6mZBSXuoMm?=
 =?us-ascii?Q?HoTlziopRwweyYfQGp4Cb3c3Iez4X8SJ8PmnRnkjY+UIUcdXVTXARH/+K78a?=
 =?us-ascii?Q?VXVkf1K4BN9KrkleQRkAbZLh4MaksltGoNeR0LyCLVHkV0ZhJ4d/pL1DTzu1?=
 =?us-ascii?Q?gLoUppsVJu6UFCOU3KBDpTEnjmm9GSkmOjE7qUUy02xhlCVg5xWgzR8xUNQ6?=
 =?us-ascii?Q?qCGVOfWdWLnZG4BttWQyDc2Ab7vBn9XYcSOzcemrZQYju/vvbS7XmQXfoDHx?=
 =?us-ascii?Q?Unnu7EwlO7mbO1XscSLN7YHIQEUjN9w8CeLt9HK/o1VKOxNRzu3MatyOb+E8?=
 =?us-ascii?Q?WzgMC1S0JmQ5ueVZpeyybO4zv8BktcJUQODmM+llVKyA64MI9kKzFGi/3yjA?=
 =?us-ascii?Q?58K//zueLsJoojQkXvHM9buc204aB8bGN9Y08HF3W3al8MYK+kQ9P65k1ZpK?=
 =?us-ascii?Q?u5um+DvSY11+l2UIKFySFyxEeTiV9nhEcT84ci6o3/EYYAYR3R+Qn/565b6r?=
 =?us-ascii?Q?z1RD+iYVyTWJwgc6aCT1H14ssx8P51neigsKuQDjPLSbU1j2DkMvwnT2RMMp?=
 =?us-ascii?Q?pkZoyYlrbi0reHD3V+Hg/+3rx6GNTkbZBYZJyld3?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5F23KvD/OW1ZLFY9+MS7EsVzZm7f1WAo2wZGWU5Wnn48WqroTl7L6EIWpWl5?=
 =?us-ascii?Q?+gKzJctWWYjfBAiG1J+6C0VlppbocnV3A7goldy/GHz4gzlYePesKp8DbcMA?=
 =?us-ascii?Q?83dU+s6J8kuKtb/Z6qb/3M8+gnUe171ZFs36c35g/HDDSnSii+d+YqkriMdi?=
 =?us-ascii?Q?hv/B4emt43GtTodbHOPVEo5Vl8D3fX2QnAfZ1yQwnkRqaMD7F2RcvxdHqTg4?=
 =?us-ascii?Q?Cw9K/9IPj3WuDEqOMTYAAJoePk9LOPttdKvEqWcXsIIVLwdgNAlQqoYc/w4H?=
 =?us-ascii?Q?XxNLKJHFr21ZSNK3/YpKv3r/Fxfw1aAF6Dz0cjwJEX/HKLsfMuig9HINXYd2?=
 =?us-ascii?Q?uO6hLQvGzAnv2FZmMC9ETiTIO/d4yRlTjlTuNpZQ9qpfFAktoepDPopg6pPp?=
 =?us-ascii?Q?sM56MkHsCvG0wLg9kF3SciO/oX7xmrYqZbPIE3vnGDDhRlcZf4oZhvnfm6s2?=
 =?us-ascii?Q?391EujIveH43nzhwX3iXHnipQbu0Ds6jIzbUiVPslh0Xb9WoTsOZjqakRXg+?=
 =?us-ascii?Q?vfgA8+SOttayJSVwhnH+tt1gRQtaQi+S9wc7bw5sNIs+9KOHdanTz6igxUTy?=
 =?us-ascii?Q?lYq3rSCKWZAD7cB0Bx7MN25VNi6I/yjo2Ae83z8bT4zdEnVeE7FVRNDWZ9a6?=
 =?us-ascii?Q?YDNQn9fHReej8Fohh5Dz98jo6g5AtYybw8fc/juRSe0CmeNnvkXrt7KMKMbg?=
 =?us-ascii?Q?5sZHEAmylc4m2klFKqVjtAwfJFrRbpyZdyHJ2ihEHlmstNdUlKsbAxF3huTl?=
 =?us-ascii?Q?YmhZW1K2I4wrCQeUN9JFYrdtTq4vZosztRwCaJb+DYHDz1A8x7Hgl97V2t1C?=
 =?us-ascii?Q?QP6+/XlXyM31qZ/6Jfoc1Y3RLfc3uAa701VMjiHqKsHLnoJQl0YziWiEp9+3?=
 =?us-ascii?Q?gOWl0hsE2JeNPDhpL9zEP1Cv/iP8hg+6XSHFRZb02ISwZVJ/TyIYIZ0BBuZx?=
 =?us-ascii?Q?C/ZeuoZ0wkws9IwDiClAPAOvma/AAFk3m3y9Xx/e2irOpL5WmOJNQJPLzsfk?=
 =?us-ascii?Q?R52/P3EjTnXaTARGrVGmeFD4/LoyVGClypSBGyszu32n5j4WU1nICRYEhYIz?=
 =?us-ascii?Q?FFz/WTvruaBlzq92GUkhM8sVbk+2btHgFiSzsUb8340wmSveNVPzDuHqNKfF?=
 =?us-ascii?Q?QHD5mbvQe8l4Ta/6dPUmP5Ocz31WO1X6NQDpffgPKTYxVqItmph8Tdsx7Wus?=
 =?us-ascii?Q?3cGvErubXaZrECikEY4242PRyAnEP3+r5eRxkzG4ONitYHs0qm6yPd1H9N2K?=
 =?us-ascii?Q?SJcfaw/Yg3qHir9kTZUeQAf6qh1Jk0SIMrIpun86VETD0y5YOQQvc+K4sHka?=
 =?us-ascii?Q?31KJJjuUDOSF2gcPa6DUzve0pUmqcJODheCk8YklBJsfD1nX/mMjICSfl8SE?=
 =?us-ascii?Q?NYZdaShZfU79sfbiMcm6oa8KolW6ubqMU1m482/lgfen46v1Gbco5i/GdXLT?=
 =?us-ascii?Q?oU6SK9dYZhyVmcXFY3HZj9KDBO1BDDKjPGHdfjH0M6sPV8dRS9xSfTlhVIVp?=
 =?us-ascii?Q?j1xDtjczUQNFUNYNgKL6kgunDIaSm4X/iQW4pBAu8YeGeVT35fA1AO3floRB?=
 =?us-ascii?Q?NP5XIjKUP8moG4wlR7PS00A2LImmoM4c9E1zO2XXaRPN8nWvAhBCMrBR7l9j?=
 =?us-ascii?Q?DPsesThwaxLY41aReTwKOGNKhfGyMH8aRLYLIMY32wzfZQIyQVNuX7ptFfRB?=
 =?us-ascii?Q?8km859qDJxAxvy8+pFuTWz//YeG4HA6Ii7drLsvj/DqJWizOzpXyoXIaTyhw?=
 =?us-ascii?Q?92dLOMuLKQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	enXGuysb8U7mmHJGXvnJYRugK06OfwgvZx0WutmnlLUpFt+cFUa2sKzF7YdiUvvp5oAS6Eua7qNG4suMlhRzpoF81ibyi7pHYChte2fItiRw8t7UFfQX70+sGD1aBQRsaUzT6ys0NFu+GX0jRFFC+SzwbrPwlHd6eUQ2YaLbCCeelV+yA27JerLmAKAUjLeBkJx/u59VL6cnUcnrIQYHDaxaTE0ECIQXpoVDwjt9B1ngMuWoCVGK1j/b5k4JcxanzYkGHQquy6x49D9wPMPoHtE8VGpaR4TnhtPaPHpuZowT1SEA4eVI8x99AI1KyxltDrAKMtEDCYBnj8tC6KE0oJwjR0InBgmLM9l3Bk+fQTTTG4oZiExFbfSNvZqSbRVDAZzIkMHXsFteu0NrxlWj0ZSx069lw7CfGOqhJyoY3soRllpt13NBqaF7ixFQbqYpIS54mzBPXnlbeZUQUOKwy0Hlszz6VRHL40i3r+MrDxMAsOUlf15v75jTwVftrKe8zEGCiokIX2PzlX3FuqZULWYV3pBSX750tWSMy1FIEqJ+ZLmzuZbVsy3DzUfy+WuQeWccSzf41EhstE7Ty3rPqdAK7ei+5T3gjX/VoEEpXAQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 658eafc8-d732-4901-d1d6-08de552881fc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 17:56:00.3476
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q/CKl5G6VwIBld+0SAnNXBP5c7okyVOqKZyzdGcMcKPfHcJNDPFRWA/sbP9TKDv61Vngi4Pv04dUBTbmCHDtHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH5PR10MB997734
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-16_06,2026-01-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 adultscore=0 phishscore=0 malwarescore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601160131
X-Authority-Analysis: v=2.4 cv=XP09iAhE c=1 sm=1 tr=0 ts=696a7bb3 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=anyJmfQTAAAA:8 a=NEAV23lmAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=i3X5FwGiAAAA:8 a=QyXUC8HyAAAA:8 a=Wv2KClHB78hmEtDnDKQA:9 a=CjuIK1q_8ugA:10
 a=mmqRlSCDY2ywfjPLJ4af:22
X-Proofpoint-GUID: LJHWxrebZ7317iycOHQl4ev2w_ARYIZP
X-Proofpoint-ORIG-GUID: LJHWxrebZ7317iycOHQl4ev2w_ARYIZP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE2MDEzMiBTYWx0ZWRfXz4QZ8B4F/DXB
 NNaiwmGJONBxEi/OHA9g1tIYN3SjZoX5dFBD/fz3ZS3EQZVeens50uinHcGVPcnigSPOkvsTy44
 6yQXsMs8QKxl8n6yhF8WaeTL4kL29JLMSstgKSjf1oBMEQ3y7VFFDL47fJuugo+8gR4JNng8JgN
 0jisjJi6dpuht4STVzEkfevQdAIgu+PP8Hk5cE46yyMX9gr0om33ZUAb9P8leJqF5klzVY8ySYJ
 RQ8mNjpvBj9rLPyWoX4GPKJ3G96GNUXaO9N5gDrSXDdT3Eob3gLHhdpuxUqrSjenuHrpzp6EXXT
 qaGEADTinmWUQlDP9oiWgKLk79E3gloc07CMFeNhWTjt3TgpCeXrP959gl0rFHyQgqwfNo1AIr8
 KN18L1NjqnYCEMUsUZ2e6S0AI25/0nXcceDc1Vn/r2+gAmMXlZS+yftx0z26b/OGlWfDRWoBCob
 94SoGqR0YHqDt3wlNIg==
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1CAE212000B
X-Rspam-User: 
X-Stat-Signature: d5ficme7bm9kjhr1gn5wxcu7skrwkcms
X-HE-Tag: 1768586183-348798
X-HE-Meta: U2FsdGVkX18uUzdfO4vSA5ITvqJouEYXN2kinOPIMfoGNGP+XuD7dNkMjb82gUimj1VfoLDApWNwN60T1lSflhHpk6qT+aXXbhgUBV/Bz6ICgOnaUVSrkzxKR/taBOQjKfmJWtX7lojIa9SIccyJbPNCjdocQJwgcsGcIV+vSGKkjDc3+lt4b7/2nx9eoJG5v1XZm/ajY8sKhL3GTDfW8+LfzLR8gq3Ov64DYexa/j48m+JOUO59ZNhYQMLHtOYtbKhlMX05i0oaMN3FBxlm5Ox71dMr7mWxhF2vF5QMchUlLD2xzTzHd+VnikddGVavOyttZXQA/0lt7RJkkVbCBmKOzB3I2qmBrzFy8vSTBrHlEnP+ZU5C+x5tM/6Pb8EkqIi4g5xXyVK8lCItsRPf+0z5IdpgJIvK2WM3M7WPxgURc6ZsHXHOqBWsX1Iyd0lDCaX18rKsGuElOWsE+aU8bCL4WZJ9KAFCpAIUaY2xEGq6oKRpI5zR8nMT/ZkzOo2r/NUqPlQNtmFHBeMdEcDdLLTbRAqSgGjmsZx7GVu4Z0hth7UryLbnylTo934QdW+NFDe5QehdLckhgRbQayg6czwAzmTCpyT8QmCL1TsVZGcQGuiP/11dzv/hAmjyxPCbs55xcEjLFSdkpYJ6pm/malPnTBGqXBa0Eip1a+1KSHs8HUNmZ7YElnm5S2mCyjviec5Lv37NilHD6rV98iTbGeOYBrwH4xt5V8J+JIYMQPXh/3sC3ag2ETFlTVSQkfZYAeDP/SZk4j8sHMnxRMw/4KsxX4+K5T6zIZkwiDJH5qhy0H9u1UeX6Xs81BE1Do05HfIfxkE/0KRJhxCg5rGvwGKGid7y119JSdAo/zu601+WQiWH6zeYulW9havuWs00E4vHVLES4BmLp/0gNyhW0U1jPdUUolKMzHzCnnloC55PpoEEPMjwF6EYsntoZ1ONdIzsUmDbpcvUxOtIxRB
 IYjUT24a
 Iwb+/T1255Ge06IQNrygeJHBPggU6BPPlXplLJ5pulU5OEk83F0Mc/bK1qXRPbHfnitSOYRVFVJ6qiXp43Hpmdqjq8PmiqWUPpY9xrJVpHzmj2bKehi09t5SFgz5ZbIUltrQ/HfQYqh7uWafylEven6MeOBPIkNnyh3B/YcBA3malW+wLsJyNmk4iHsPBS96ecO6ESK8pSOPjxN4F1oj9D6oKpBP9cg6WsZ/EoiVohttW6BysGBWXuA7qTibc+OaKaW+KIuNsKGqmddKG/7XdApodBf7isLLLuBPQMCd/rrsZC3UcyMs0fu3AS01FjDmsjgpSbu44oL9ST+9F+ncadp3VkuqZtDw2Nmrvg9CCze2jEI2zZdnIlZRS44nzd2nV7k3YNdxbC77hwwKmPMiZDrOaOmB/pvhPKB5b9Ws64O7hcOFc0/Lc0Rgdw68kT77wZxq90IpMW6a9rvfh1y8wIT8YCuU7ClbmkXfjQ3FolX2iO+XObvHJY+ncv9RSU7FY0md5cNygMWyKHw+CCmu/gXXVYduJol3Ck23PaYXj/MGyTdP5TaysBjXzaITwhR+lfiqtKCUSk2Xy1iFP54lp+hSayx24ygu0OJX1a5+9lhJN2GZzjOZYnc6MfPtU4beXdFIOeznEB2eM+aOIawmlabYbUgV1Q/k21S71U9H1rgn6s5S/yVwW95jg0U6KfpuCwAUk3HgUx/4zp/6+OfjRySArnF3ZNgCl8qUhLIoLHjWptw8wc5IVuz3cw6ktaXPFn9oeuRVm9SsAuxC26l3U3eRAo+ryD07l/MEhLcHyaB+WJh6BQfeX+8QkczBR84cDwTAus/s2+KFpHByuBvluiXbxEw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* kernel test robot <lkp@intel.com> [260115 20:30]:
> Hi Liam,
> 
> kernel test robot noticed the following build errors:
> 
> [auto build test ERROR on akpm-mm/mm-everything]
> [also build test ERROR on linus/master v6.19-rc5 next-20260115]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Liam-R-Howlett/mm-mmap-Move-exit_mmap-trace-point/20260116-023126
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
> patch link:    https://lore.kernel.org/r/20260115182720.1691130-9-Liam.Howlett%40oracle.com
> patch subject: [PATCH v2 08/10] mm/vma: Use unmap_desc in exit_mmap() and vms_clear_ptes()
> config: arm-allnoconfig (https://download.01.org/0day-ci/archive/20260116/202601160919.v3GpIeUh-lkp@intel.com/config)
> compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 9b8addffa70cee5b2acc5454712d9cf78ce45710)
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260116/202601160919.v3GpIeUh-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202601160919.v3GpIeUh-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
>    In file included from mm/filemap.c:54:
>    In file included from mm/internal.h:23:
> >> mm/vma.h:176:18: error: use of undeclared identifier 'USER_PGTABLES_CEILING'
>      176 |         unmap->pg_end = USER_PGTABLES_CEILING;
>          |                         ^~~~~~~~~~~~~~~~~~~~~
>    1 error generated.
> 
> 
> vim +/USER_PGTABLES_CEILING +176 mm/vma.h
> 
>    169	
>    170	static inline void unmap_all_init(struct unmap_desc *unmap,
>    171			struct vma_iterator *vmi, struct vm_area_struct *vma)
>    172	{
>    173		unmap->mas = &vmi->mas;
>    174		unmap->first = vma;
>    175		unmap->pg_start = FIRST_USER_ADDRESS;
>  > 176		unmap->pg_end = USER_PGTABLES_CEILING;
>    177		unmap->vma_start = 0;
>    178		unmap->vma_end = ULONG_MAX;
>    179		unmap->tree_end = ULONG_MAX;
>    180		unmap->tree_reset = vma->vm_end;
>    181		unmap->mm_wr_locked = false;
>    182	}
>    183	
> 

#syzbot test

--- a/mm/vma_internal.h
+++ b/mm/vma_internal.h
@@ -46,6 +46,7 @@
 #include <linux/swap.h>
 #include <linux/uprobes.h>
 #include <linux/userfaultfd_k.h>
+#include <linux/pgtable.h>
 
 #include <asm/current.h>
 #include <asm/tlb.h>


