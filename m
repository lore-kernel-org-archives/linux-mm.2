Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90859CA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 09:01:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5D448E0015; Tue,  9 Sep 2025 05:01:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D342F8E0001; Tue,  9 Sep 2025 05:01:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFC588E0015; Tue,  9 Sep 2025 05:01:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A806D8E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 05:01:00 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7A2EF1A045C
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:01:00 +0000 (UTC)
X-FDA: 83869117080.13.CB53559
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf29.hostedemail.com (Postfix) with ESMTP id EE37012000F
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:00:56 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=V5CaXnfw;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=vqHvRp3N;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757408457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+6XdlpwbFV9D0sKhdMbT9XSsUkiDbdRYbQ1yYl3hWPg=;
	b=R4CjC4fypVcqRsfgyKjtOtB+zeQiDHz6JkwUDd5OCDRybs/91TJI+cQOd1IpwqWKisfAwp
	HPAIa/8kWpucr4u+LMJRMb/em7DrXggDNZ85ZcEPrgqBQBBb8PGBSIC1tSR+9csrAnIxp1
	4dzZ6zSrcCxT6C2Y0Y/lyMs/jTnnqCA=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=V5CaXnfw;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=vqHvRp3N;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757408457; a=rsa-sha256;
	cv=pass;
	b=HT8ADDjJrGuXnoNV/53V8LbbyU9EEjLNfkJqoMdhnf20gNSKPIJGlFkp2zDDqxf867SJRi
	eCANb2Uv7TL7PE7G8hQB3mwabSfrk8ES8L6XrEkMtAUZwQWmnLReQSrI0FyzKwzBX7A33a
	RmQYsCJ5MfXNn0JArzasf1bYqnjS73Q=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5897g2V3021263;
	Tue, 9 Sep 2025 09:00:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=+6XdlpwbFV9D0sKhdM
	bT9XSsUkiDbdRYbQ1yYl3hWPg=; b=V5CaXnfwSOx6Ko65EF7mCyoOK9EcchAv2f
	cMzXjm+jbBz7x/r2U8bexkSRDaQGZ35LV1vBTFQcmM83hbQqC6lLtArk6RThvsAy
	4Qk9wncupYxBcpYo3CJBsj7lBN0CKUy1Q3W5nVeuqAE8BtDOX3ikhwQxlSByN5gj
	A8CYgX5TFupo40RJVSkb/AZUz7QqbWB7HIrjDLEPxCw8WZFn2lsjrS9FYBz/8vxZ
	mka3wagOXppqdR6C3jvntlRNcBw1dCI+hVWKjbMk+gBwae0c6ErtoSwr+kSB/wkq
	IvC11ADsUrwZqw2msISNRfH5zLqycli8nJtgaTxBrvrT66p8VN2A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4921pe9gg0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Sep 2025 09:00:41 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5898HMDw038949;
	Tue, 9 Sep 2025 09:00:39 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10on2044.outbound.protection.outlook.com [40.107.93.44])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 490bd9b3sx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Sep 2025 09:00:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Jf0A/eo4SZbYVdVzvVZUU1YCH3cvOHnI2MyA8mxxHsIDmxDjeWK4Ip+FB+I3iQGK4RmmhjKY2NFOFT7qHbP1J/dMJbW5hujeKgAiA/EHVtdpfD+ujyhl60GzzK3tPBRVm7x49kcFnE+7XK1d/x9H20Sk0nUHD9ffYUu+R071WHiBQXNFAmTwdK4QsEOlzYJinquP41SkKrhWMO5oPGSdzlbY7i4skeXtTEfvtqIN45OqHmWlQZLotT/t+g4GBW5QhYbjUAsLal9VH8pVksVAxrfbz+iSpBFFYr9fFyaQF+9DhP287PhKy5EIi4d+YkbnPo5Q2ExgqoWyr3RRdKIvYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+6XdlpwbFV9D0sKhdMbT9XSsUkiDbdRYbQ1yYl3hWPg=;
 b=DjX5vGKd9qVsYtq+MZ3n3sfYhF34Ia0kWmjql9BpNapUn7IpyrSmpTBAoLf+5WeDYNXRLb3sb84MdYdiggfWhSg3LQJkOvlyqessxmGk1++6NsVADuQsk8xyGe8izs7ZPsoH2hgXou5k8eGW/NsmR4vDxAriiRG/xC9bRSA1rA19aErLVfprrufNGAsjQPMGH0OE7Y1KGzIPAs64wkdqfk+7wgJweFnswrV6SkB5m9eA7PJ1L7eKKrRELQEXOH3GY0DLhrpruhrkdMyBSWUMU6qAsbXetQI6r+cNVR7MXpckIrpKlLTzi9kFFW8kgMiqU9LJalMh1ZNd5D0CS7nh8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+6XdlpwbFV9D0sKhdMbT9XSsUkiDbdRYbQ1yYl3hWPg=;
 b=vqHvRp3NqMPZ2ISXyQ4KbdpSYJ60ReuFtBQrvbHoF2Y6BbgfqE7Mh5Db9GQl2Zconf7K11iJkIvCEAizJDCnbFaeN/8EfYD6UzZifdjYJrPYsPqFD0kB+Um/lrZaOOjL2V/3ZnLevDXDrO/jUl+4EnfsWe23tecwp9uHN9wbf3Q=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH7PR10MB6652.namprd10.prod.outlook.com (2603:10b6:510:20b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Tue, 9 Sep
 2025 09:00:31 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9094.021; Tue, 9 Sep 2025
 09:00:31 +0000
Date: Tue, 9 Sep 2025 10:00:28 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: kernel test robot <lkp@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, llvm@lists.linux.dev,
        oe-kbuild-all@lists.linux.dev,
        Linux Memory Management List <linux-mm@kvack.org>,
        Jonathan Corbet <corbet@lwn.net>, Matthew Wilcox <willy@infradead.org>,
        Guo Ren <guoren@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Andreas Larsson <andreas@gaisler.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>, Nicolas Pitre <nico@fluxnic.net>,
        Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>,
        David Hildenbrand <david@redhat.com>,
        Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
        Baoquan He <bhe@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        Dave Young <dyoung@redhat.com>, Tony Luck <tony.luck@intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Dave Martin <Dave.Martin@arm.com>, James Morse <james.morse@arm.com>
Subject: Re: [PATCH 04/16] relay: update relay to use mmap_prepare
Message-ID: <b816dee8-b787-4988-aa68-564bbd00307c@lucifer.local>
References: <9cfe531c6d250665dfae940afdb54c9bd2e9ba37.1757329751.git.lorenzo.stoakes@oracle.com>
 <202509091137.FMoksKmh-lkp@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202509091137.FMoksKmh-lkp@intel.com>
X-ClientProxiedBy: FR2P281CA0154.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:98::9) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH7PR10MB6652:EE_
X-MS-Office365-Filtering-Correlation-Id: 254e25a6-2234-472d-f871-08ddef7f544e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?gCn263bMSBhoPqWTcah30n5PFDUGrDE9XCmF82lzMiyR2oPAcBJfonff2T3u?=
 =?us-ascii?Q?6m6nSGBwlv5ziG2ZlxrOfvF/4ihwR9OGhPHiAfx1RYFidK8wb9d8Yjqr7NX6?=
 =?us-ascii?Q?oydGao6TzRWarKtzSEL1uALo/IIyvT13a9+wnaPBYN6qshMUiZ86XmQjEoRP?=
 =?us-ascii?Q?NzL0BW4yW3kBfWoMDBAUOzqO+tGicIOOoxGXfnsYMNxNoPJ6ot3mlOQ08AWW?=
 =?us-ascii?Q?+iDzC/habaqNeBK7JgpImMekcJWy8VKPqO+W1bRW0jSqXOAfIMzhWMZ1mzgg?=
 =?us-ascii?Q?hj5oGTpFLY4ELk7zseEtZOtT7wwgkEAg1RpxZ9+ejphH8GmQ3N/kTUMMGx6A?=
 =?us-ascii?Q?//HMvzKA2PIekeDgCT8b8q9vh8uBgtu7A8Y24Io7zh2bCb51H/chnRfJF5ZY?=
 =?us-ascii?Q?ieup7vMsIPLD+JXW1iJwW9Q7DKCYM9pFxdOiX88GWkUkWAUUg/xBeigSAJTy?=
 =?us-ascii?Q?ivSQKP2oUH38IcS4wEyelQ6RoBdMAmDRQsaLD4xpsVItxP2A6FrTFSe47XzP?=
 =?us-ascii?Q?ZFa/OjjAluDjfIRQtzbBl6PCwykWhJaZvqpp+7sEy0Xg47RPmxUfv7Ac/QEa?=
 =?us-ascii?Q?j3c8Do4nqGIbHti4dPADVM0fK5L9VPQ8cVFf+kgmRGZfmjH5iUq8Vo7GbBJD?=
 =?us-ascii?Q?QWK+cStLd+VjqzHNHdaxWzFgs7q1BVVsrgPf8RUqxDocwNyK7eI8moleD7bs?=
 =?us-ascii?Q?ZG0mjl/6eJrhCbrM3smxzLZPf101hyb9Rqq6rbD4OR2vxpaekFlUDApO4tsf?=
 =?us-ascii?Q?9WCg6yVv7B/SeHUfa84AhzMAarPlRrO1LGasl4qnG9rVQg9P6p1rq6vdPFk6?=
 =?us-ascii?Q?pKrxLxX2cgB26eXm5VDbvKNsL+g5n78ODsMnX+ivi0Y5DzRc3NDC01HQFkYf?=
 =?us-ascii?Q?nPrubRBqzBqdCKmkItEDxykfTFYzf0TViEg/AaUhoqEGPLd3+T+4pIPZfZJg?=
 =?us-ascii?Q?mcnTtixHWlcMhEuWEEyfIyIq+5xNjz63OQ6EJbr0pLuizNv+atPfufvxWBZu?=
 =?us-ascii?Q?b5Q11oT222s+P/e2rJtdhnRk5dy4wxzyD/Ova63tSn7IuQD33gMwcYXEC/WL?=
 =?us-ascii?Q?Zzwh2vNcdzLuC+faU05gN16UZ+4E78Az7Aa69pVqNAFt3tbbv5Bzkl3tpgGb?=
 =?us-ascii?Q?BA4z3R1hVo4tzec/lq+nRWDckH0Qno3v0E+0NWZWrFHc/W2CBpI0Q0Q07n8K?=
 =?us-ascii?Q?r1IzYUizY7+eeciQ9iOzYt1hpDxjCeqX4goLCTNtP/3RvpAdFx+OP99pIwli?=
 =?us-ascii?Q?CdR4pwlQYMctSGOO7WwUBY3MMEt6hJGAJJW3NOicnxisyGMgmsFjBcnKjnsa?=
 =?us-ascii?Q?Z80W7vdhXnrEE2bGF0ntC17GHAcpeC6Hbpet4D0SgfYBGWv0EHQ+/PewijdI?=
 =?us-ascii?Q?uub3CHYl0t1bM/bQWWluf4Y3FCvh?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/JSqt73AKU7ub9/g+i4kRAUBjNH9btBFML0tfqcrwaUqL0tDnWEo3te8pPao?=
 =?us-ascii?Q?tKxPz6Dk9no1gM3xGwSyQCAysnQwt+TOfNCvFzfIFc1xFfM67sBtbyLFI89i?=
 =?us-ascii?Q?XSkpLZZe4N8VqYULD9pN4ETkltUVj0HegrbbM3GaAkWXEc5eD6frDZafEpnZ?=
 =?us-ascii?Q?vqMJY0I6P+X2kt3cz0T/Pgz/CqB2/3fYActv1VJlUP4TdH3kEcWEHtTaq65v?=
 =?us-ascii?Q?O9764FC3HteaF6PQnaQxqCH0FA7TZYpkxekrWpX7IOVThaA/uuwRcrPrMaB9?=
 =?us-ascii?Q?qq6JNlZdhED0NcT58NHVJZwxovEKzEo/VzShkiE9U6ZXeHOPkIvJ6KUzkKcO?=
 =?us-ascii?Q?q6HsEoM99rZvZOabFKZ11aW8Vh3HWS1zw+Ej+Edgiy6WNlhLZMsy40rdWEQ3?=
 =?us-ascii?Q?HA1gOF8mge1x6w97P3SfSS6+cyAVG4xKKtiO865PZIPU1gL0GZBYicjA+X9w?=
 =?us-ascii?Q?Z4dXH+lr4wAX+mClYqxFOIU1h0S4ws9E75yBvW3kgmy1ZAmsOoCtmnqDYpcd?=
 =?us-ascii?Q?Z3jPbbABG5h15JMorDWWDkD0QH78qOTIdp1+t0LhM5rzkgCIfwarHhbXeXj7?=
 =?us-ascii?Q?XcCCVcQFWODwug0yvBGY/73mJEw6GG2zJkzQO2fvyi8dpbr5/HFMBeAeLY23?=
 =?us-ascii?Q?JmbDE9B58YcCJkCAHsqWaPBHRPXU41SEfp5GC+Q5t6cMgpBk/+pd+3ueKUQK?=
 =?us-ascii?Q?4tuRgi7Cyt6tXG53x5JA93+xHe3FnJm9sqQkPaW+sb3lkVbwnlVdKVwBxbg5?=
 =?us-ascii?Q?F6lSbzO6nglbSM9fPrp0uq4BRU9OW/O4zxY76s+XYm7UVy6OSpAhimIDClOc?=
 =?us-ascii?Q?SwjV4GGt3zRYx1jTbYvQG+f1UBtz8l6TJ7VSyjGH6+cuUsgp2gmUgdJhsCpF?=
 =?us-ascii?Q?mfM41iFiQR7FFl1+Kl2i22XFCJ7I79cP4zQtO5rCxOnjzsqRin9ah288r9Os?=
 =?us-ascii?Q?mQ0oV4indImhEXFBaAg5y71dpNVFTL8l6AjlqN8hpyXzXqjtfM7Cxh7pc03U?=
 =?us-ascii?Q?0UBcvpzNfZystUhpyTHrXWLZ3lGsB4gyflXtFZ0EpqjGsGBURpgQhxPiUrtp?=
 =?us-ascii?Q?FBeczaJIOLs0phTV2GrI1a7bawK2uGLrB0eZCFZ00fOcqD7sybuvlIBziM4R?=
 =?us-ascii?Q?3fcvlp06cJ+2AbosGQp9RkRqN3shsGfN28BBBvfkcrnkfbU+UW0Ep1ISUM7C?=
 =?us-ascii?Q?ytARa56bq3OAVQDdCXiGw5/ReDw5/tl+U4IOzhL6Wu86VoyOMqdHLqdYxdFA?=
 =?us-ascii?Q?UoOjC+H6MOKWAfeeEMAVsRqR1vudY1YSshCIrm8IxkkdA10Ml9ulkGDhlhSA?=
 =?us-ascii?Q?KZPxQxlZbsRV07BYh9b9OjjaiC5IRi9T8AT95JoRJ10lqNlm+0Q3hzKpnCOu?=
 =?us-ascii?Q?cO1xt1z+V6Mzl+zIkt9UNeTbdX9Sr1Qs/A4yNRStdufrawoQ2jJMZl7HG+lS?=
 =?us-ascii?Q?21dwhxNEMOQtfhYqP//9EVB9zE1OmFJPHl9BaQ+RJFhgLIqZ7No07gFtYa0A?=
 =?us-ascii?Q?3/6bDaOJL7nBoahjE9XUL0sCIrtvEkBF5JqkZZd8E1mAORZY7zptYOJ5Rc6Y?=
 =?us-ascii?Q?x/1xG2n0kU+1iEz1+NcvIQCfkTJx87GbSBB/Gd7b7dLhUILhW8OkyCGqSJWp?=
 =?us-ascii?Q?lQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	7fA6HoOWWwqIYF2SdK6PJC1ye7voD5P3sYayLUxUQiu5a7cPkQp2SIS0aT63Yn4JmYlhRcdJUdm6Vj3SAHQ79NRH4iF0yKt4Gf4y/0plR0qk0QXkPqRIn9K4K9JyscM3x3hPbjZNQFp9uKBap47jmQTPxg1A1u6sVFiMJRRu4pH/8cAIkdxge03PMyksSau78WXXWleqIhpoh9YEUlJ5tDmOjuzmAJidEqSPQbm2vKdB6JqtaU1Hx5olG9RFJ57KFdJUzIUf/7DacOPk5JISno1vGGJtK7hhXgi526WnE20MkmGXBOl7QD4HLVAc3lx+CVMzA7MgtTc4f3G9b0GvkkprGB1Udf6Wzu0YTkPM8XuBaElowg35UqyCTPnS0OtIMgVZaRYNkjqdY2on4JljmcCb7aqAwr5dRdtqABVIcOrqjStFEe1uasgJQ9TLKo7UeR/QYepkNCOJAEUK3w5ZQv0ujSFj0k7n6dflsn5F6M7kvnkAaAdqXyYUR5Q5i21Q14DcS1//RqfNBv3dA/bJ307U2whPrT7kqmtFPxhj1nYRGSm9yAbVITuijZZuxn4pSUolWFiMHZdMQz1LhEimEmhlevVDBmDKGH6ZQjxjSEg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 254e25a6-2234-472d-f871-08ddef7f544e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2025 09:00:31.1467
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wmIj1ocZaWUaz0eHUMIvqo3vPANCDR3Q3qrFdZm49XQVx0hMTc48Dn35z+Sg/ssCPB4Tl2hbZI0IobVkjGks1NkzJPvwCJ98QoYBxtAyrIc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6652
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-08_06,2025-09-08_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 spamscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509090088
X-Proofpoint-GUID: Oy6WOWxSGgr-lu1i0-6ynpnY5oPztZB6
X-Proofpoint-ORIG-GUID: Oy6WOWxSGgr-lu1i0-6ynpnY5oPztZB6
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE1MiBTYWx0ZWRfX8xFOQtZc7uDI
 8juGWlW85yg/TNjVQD1hnaIF7WQTnljYcihU2PqVMgJw8WYQvp3qG7Uy4cmpNq/H6jJ8cVSRqq3
 4G71i+flvS9Xe9XyEB8ZKv8YdVaUTggovciQn9xv7ZtiAQ7kVHELg5ghAgqaHguZ+D4bEW+FoRm
 g9WKFo2pYkJzrfS3mQ8Ig6cjns1BWCaWhflNDsbo9FNSXGwDxMqzNYspfWoLiHBXcWBdX+/vYQs
 AQYuDMK8U/+66A+h/E27QYcaaj9YgOXclmSRSw16hUa9l6XkySjLxSjxtKDnf/TBGmOcrWk9myr
 Hs/5yedhlLnd0ioZ2p9/p8WkwYaE2DvPDvTzRO8+mLE68h3Wnqv6E6jHTPIxOrgcX4tt2p1UB1b
 z1OlBReVt9tyP+MEGFM+CLR+fyLtlA==
X-Authority-Analysis: v=2.4 cv=b9Oy4sGx c=1 sm=1 tr=0 ts=68bfecb9 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=anyJmfQTAAAA:8 a=NEAV23lmAAAA:8
 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=i3X5FwGiAAAA:8 a=QyXUC8HyAAAA:8
 a=F7Axq3062FBaK2MCJoYA:9 a=CjuIK1q_8ugA:10 a=mmqRlSCDY2ywfjPLJ4af:22 cc=ntf
 awl=host:12083
X-Rspamd-Queue-Id: EE37012000F
X-Rspamd-Server: rspam05
X-Stat-Signature: 5rzjpc61qyj8buxfuirmf55pfni9xf1o
X-Rspam-User: 
X-HE-Tag: 1757408456-211381
X-HE-Meta: U2FsdGVkX1+EeBSljPItyU+iyClFFsj7GUmy8PWotZyyrOfVd8FhzneMJu9KZesyctu9aiRruYrRlPX6CpLgB0lJkeXr0PTQhOoeN/D8ZneRGfG0zhSl5Xi+P8JgXkwOJ00aL8PYMMDl6VZQWrit8H0E9eF5uSzvRvEm9Imh9gMWHio8WL0BQqb1xtU4h8xMw1817Tpf2HaO4bDc0CLPDN1SuudOE/0P04wXkXF++XtaqObzoZxnUqpXpaEOQx0TENLDpNugC7dvGnVqmjYEga7YcVj9CjgcBY/FPr0H8QBLqMwAGnhs3c7wZOlXuMXY+N4rydf5LbpkdKQMd0y2hJ+KhvvVen5W4KtKd/hxMTi2avglUDS13a6wg52N8Yj5s4DJf3VgNHagDA42fsyCs3ITs5ays/gFxBFSw+eGNL/Nz2e5hA+/t3JT0O1qc4hlpJqWVJn0Xn2xsqDMrP6S0bejMEyMuI9NjGBG68tf2b0QKZraY9ZEPF8sNtVPtHdwo57Q4/nAK7egetsPJqvfHJWsDlmDhf3xauvFXpNU1b7fwLYX9S8X/ex/h3st7U5L8nNRZ/TZR8Wqd5agVlOxZQk3Y+1kocRr1CspQRMDHYXLNyBjLA/4jRnsLm3y+dQX8oYMh7g63Dy/puD1ZOFkwANeYWgK2Bh/azRlcsbqmLqatnIP7AtRUMKx0Ze/gTLDuAylpA4EZetDzi5HbEbZvNa5MRa5RxOuOSTAbuHb65VhayHlnrI7fhN0PSs6lTnItphvVWc1YQgdxqOCJz66iBZCWCAMlF8diJ6GaHjtZ8LeEpRsHNB7qCuM3/mwmRDyqGi2Bp22ihcVFhhrpilUZ6F2gGkw1EFjTueXfIYVqBfRJwSrv/cUHEwgmVmjd7evOPpOjfegqLANqtR+ShtYLoq0VeJpv3KIx2Rx3TCdUQysWoBQtheglPwMNvIz2ctkmBKovDkOerXiTptH1eH
 JOskmM0F
 v5vCRwclr3OyD5FIu07W75FBOsrPTbrUxffh4i3bCi8AY30/5I+BIebNn3NjL7CAQKmToBOFgJzXZBmta9j2U6/A6jrJn5m23pCzXRcj6HZYt0CPisD6l3DBKpQBPd7UjW8TR0L9sEGPT1F0MywskaPt517RlsrIC94YbQVVu63ic7clw6fensZT5kqmxP5O+3FwY8rNXXey4FgL97N0fauCznozzH0BsNy2szLOP+/lZUHIypURbBDHo7UzMtF9tZt0sDJ9cC1yDk5TfnAAxCvPF2zOZtOQhV1NydxYS9QqoOhyjrhMBs8tkdQdIPbAoK31Ojt9dcxeYZONZJbjQFC6Is+X1npQKO9t1HgsRrna6tQjVitNnFSajRRmpavqzNQiSGh1w5waDdT6FE8ID42AI1M2nrO5ou2owt1EaiXMDlmBilFEnfncCq+nw+ZEBNmTDnQF6gNaOWHkGc9+4Klg9aGjcNVr4V+Nj3T/MDrOhHPFQ7x1JyGLjFIoIpBoUCwTl+IhXO+B+44x1ehGjKc3QL+Vsig3k3XC449nb7XMW4g+oZa480FkNVWcx+A8yd8k/xaQgTEWBw+PLCwMWzqeuB4E0Wxwnjh22GhiXSVzbVNDMgU0I5Rih3ZjLyhlx9cKJ4AKMq4vWmRwkOb6Vt8I3jUUREfQfe6Hg77Q/1Ldq1mBUmeKKxVm/SaiInQ6c+Vz22OakfJD0QAgA8H+itj1/3SlqDXHcQJCBqUEtoC9nu+sJ0tYRYPcuMtZbNYRBU8Egt4Rj5qABugPdZf6axF57x1bWJLLk/ouTiee2iYGo64q0q5IthdaOdcWzd0PuDRLS48a4Ck3Wkxi+Wutu8YqiI14dheL0sUNtkG9jOjK18ogJYuuKGAX9rACjuAieAG+NgNNqqq3GFxExJsApKWpGaDNEnqddNNz/u2P4UOIleLhfUaLtGyzbGA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 09, 2025 at 12:09:20PM +0800, kernel test robot wrote:
> Hi Lorenzo,
>
> kernel test robot noticed the following build warnings:
>
> [auto build test WARNING on akpm-mm/mm-everything]
> [also build test WARNING on brauner-vfs/vfs.all char-misc/char-misc-testing char-misc/char-misc-next char-misc/char-misc-linus s390/features lwn/docs-next linus/master v6.17-rc5 next-20250908]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
>
> url:    https://github.com/intel-lab-lkp/linux/commits/Lorenzo-Stoakes/mm-shmem-update-shmem-to-use-mmap_prepare/20250908-191516
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
> patch link:    https://lore.kernel.org/r/9cfe531c6d250665dfae940afdb54c9bd2e9ba37.1757329751.git.lorenzo.stoakes%40oracle.com
> patch subject: [PATCH 04/16] relay: update relay to use mmap_prepare
> config: i386-buildonly-randconfig-002-20250909 (https://download.01.org/0day-ci/archive/20250909/202509091137.FMoksKmh-lkp@intel.com/config)
> compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250909/202509091137.FMoksKmh-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202509091137.FMoksKmh-lkp@intel.com/
>
> All warnings (new ones prefixed by >>):
>
> >> Warning: kernel/relay.c:83 function parameter 'buf' not described in 'relay_mmap_prepare_buf'

Ack, will fix on respin.

>
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki

