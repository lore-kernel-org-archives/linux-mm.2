Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9962DCA1009
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 15:09:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCF318E000B; Wed,  3 Sep 2025 11:09:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7FA28E0001; Wed,  3 Sep 2025 11:09:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C47828E000B; Wed,  3 Sep 2025 11:09:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B23A58E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 11:09:01 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5CE64140743
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 15:09:01 +0000 (UTC)
X-FDA: 83848271682.29.E676895
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf28.hostedemail.com (Postfix) with ESMTP id CBF96C0013
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 15:08:57 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=SKEsLauY;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=uR3Ufi2J;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf28.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756912138; a=rsa-sha256;
	cv=pass;
	b=XLBBFk13MRVLIhajxA70poOcve2O9A15UFerCsXQLJBH8rUJzZ7fWv/XbFUdny42gFZZsA
	siGzWp0tHaAhShE8XKk1zVsCqCpvXp7+hyoh9AB7rjk8BvBNEhBQBuQbF8vMTaflZYWUke
	BojNyI8VLlQtpYwwBWIg3r1cD7MPm9w=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=SKEsLauY;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=uR3Ufi2J;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf28.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756912138;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qS+CXzeY4qB0tMwao47TmDRdi0fFffQ3HmAYmUoPKBQ=;
	b=zr3M5kAzbD/10tWhilBsKQVkse9p8JLgTqi+Z1b7JXRHyjZcVJUbiqCtohGlVnHdyG4Feu
	pT5jeokswPKTglFVvBjYM5rMcHITDHiGeK5BpnijTj0pLJswSpWDfgQxW699Q7kKUJR0NU
	vVcI03vG/ATBIKCT+BmlbkXoqrmIMmY=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5839N7LI026740;
	Wed, 3 Sep 2025 15:08:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=qS+CXzeY4qB0tMwao4
	7TmDRdi0fFffQ3HmAYmUoPKBQ=; b=SKEsLauYVWEYqJ1Ul/RsaQ6aRp6qlU7ZCj
	0I3mCpXRiEkFqCtMf1RiF8KNQRcDfe2Uzdswqj4WhLWwfa/4rxLYQP/tHwNVKk2R
	+LQ6JE9ydyyKIOsHDKnkkvvblNyxKF2Wkc4h2LIQj/tGa1OnptrqQbJGvhBI0c09
	1yexzmmozMPFn8YFN9L1tWlzFIRev748a3yMv+6LvO0HbNEAgVslE6l1Kjhv3JXk
	LwsyJULJHlvshCduqOTJRzsJgW8bEolsb5sgz7mF1Pa/9bwX4dXXW2Em6bRDb3qE
	F8R5oN7pobmM0BBvcQTyY6WE0hImEl3O055A3BMz8wS7aIAgUkOQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48v8p4p04y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 03 Sep 2025 15:08:52 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 583DeBSE036187;
	Wed, 3 Sep 2025 15:08:51 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10on2084.outbound.protection.outlook.com [40.107.94.84])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48uqraesma-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 03 Sep 2025 15:08:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=clucR2RBLw1yW2k/+293ENBvZ6SUjmRVDVfvmhjKApfVg7bNR0xYIptfQ/1NJsfnuukavK0TvBWxWgtpPgeUdtdVOZUPU8+o6XjFex+rwXUd207MhxKbJiEsuOL3KxBnyQLtoylOCd7xWlY0xeANuk8EjejKO5V75j85u/bayKEcEcM+PW7TO9hazl0IDHkdm9LDgMlG4kMkDt4k3gA/d9ksiYvbbi2NrOxwFxl0DYy2mRtLkhpxo/WpEWlv+4bXaVyeMGxleXfxZ2KAFFv17C0VsxQzy22gL7FEvi+zaCb4hnbM0JeTZ9hqW+hYjRWAbS3rJk2PNqmAbRp+nphniA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qS+CXzeY4qB0tMwao47TmDRdi0fFffQ3HmAYmUoPKBQ=;
 b=A4Uss3UdmEJKSlrq0kWwy94tIVWiOllslNuwB+7woN0GWzhJdIFDdlJRHb4MD3CtbCM2HKRSfJzNv/yKWr51gd9C5ASTyIy2t2HamFRDoXWKWTNcwispaPoXDh8MuMFuOG8hBoNV5lGP/0MTIBX2y8tGDQo33cz6S0Zr4e2OYefUr9bq7s93kq/edplQ0OC9f1BW3kB40fvD7EUTRrEnOejyS9mOQQe2K69nYHPGNKbclGCWQqydRdxno6ijgRNHWXgT09hTDIo84rw7gcO/Eeuyt+hIcELd9OXMzO9X01Q0b/218qrk9pigICFCgwen1T2ZDA1Hf39c3jkt8eHMWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qS+CXzeY4qB0tMwao47TmDRdi0fFffQ3HmAYmUoPKBQ=;
 b=uR3Ufi2JfMbffIbfqEb5XoFpq+PE5rvo55XzF+jJvZLBfRq5aUVX1LO+anJG5OmSdHcf7mwxiVu9dqpdCA6b1bDX+cRQE7hH8sb3gbTbJe+4A1s/jFMN0WbZxyIqU/U897iIMLOE8ZpYlrQ89mht8qNARsffT4JMNKkWU+2Vmvg=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SN7PR10MB7047.namprd10.prod.outlook.com (2603:10b6:806:349::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Wed, 3 Sep
 2025 15:08:49 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9094.016; Wed, 3 Sep 2025
 15:08:48 +0000
Date: Wed, 3 Sep 2025 16:08:47 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
        David Hildenbrand <david@redhat.com>, Vlastimil Babka <vbabka@suse.cz>,
        Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] mm: do not assume file == vma->vm_file in
 compat_vma_mmap_prepare()
Message-ID: <29d99c91-815d-4f43-9c05-c62b76e8c7f8@lucifer.local>
References: <20250902104533.222730-1-lorenzo.stoakes@oracle.com>
 <fbxu5tqrhtrvxznrk7xpkzvl4uz5o4jhb427vupc3u42x3u6mt@e5exfypuzzs3>
 <68e2ab97-7855-4c13-8241-46fff7164700@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68e2ab97-7855-4c13-8241-46fff7164700@lucifer.local>
X-ClientProxiedBy: LO4P123CA0216.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a5::23) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SN7PR10MB7047:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c2873f9-695e-46b1-f6ce-08ddeafbc91c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?TW/ZhH259KfCArNe4mLZ8MYa5aq1lJ9Wvx0BUU3gUUI0bpU3ZnnEhhVl7YKp?=
 =?us-ascii?Q?k/VeZWYWUnyqXwEDctRoQM5kHgQpQIQbujmTqhCooNXw87oegBZXXd4yYV1Y?=
 =?us-ascii?Q?e0rRZHDT9Ayi2dqBBcsh71x74u7WrFkWNOlSVrSa+gOzSs6xxvg39vvhlHxR?=
 =?us-ascii?Q?aobU7m+X/ZbEoSsxkCRq1Pddq2BMnj+SDhWjrsNAxTt08V81b0QyDU6p+viC?=
 =?us-ascii?Q?k3mLVx/58OGjL7Fir2lphHrdHN0ez08j8fdjzggcBL6L1pUWZquP9SyUpfcs?=
 =?us-ascii?Q?vtheejuGV3qPWCtYaRTM3NQo/IVfWsqqMW9Mga4+DmCBxKycHVOWs5SyPnES?=
 =?us-ascii?Q?mY/Pb7C6xg4ej23qRX7nh0va1M3nfkFgy3emKM5xSqBbk00tfZ/b3W+vUZ9O?=
 =?us-ascii?Q?fGjuHGioGIZ+NvloxCoiWiuGz3gL8nX5Oy06tqPGO5ctOjkk+DxfCHIzIFr+?=
 =?us-ascii?Q?4xmxZGLmrwy946iQRTUGBNox7TsdQEAfSaglM1igeEy6pDV3xKexbNbUbuzQ?=
 =?us-ascii?Q?zt8W6y0xk0eHdiPKUqoetYLb8Z2Oo9n8rS39GtEwejLtmmuqOe360eMercxI?=
 =?us-ascii?Q?7inOsHFbub8QAn35cQ6XSREtJVkNzYDHTFs9lRRP6MH51PlScpoynCEaLPJO?=
 =?us-ascii?Q?61WcOZ4B6V2j446Z/ZOQFf2/D4rgwScJ0QFHRL2jR3V4EZ3WKAwJtmLwS2KU?=
 =?us-ascii?Q?xfhwu2ftjQzBxIEfD4yLsfUgqPRwawmWr80flE1sUMZvZre2if2RnhqZSeWC?=
 =?us-ascii?Q?fwaqGbTZxkA1F1G65WWpD4GFZw7a9e4BpVwXgv7PKZn2mkXRQBUmp78DUKGs?=
 =?us-ascii?Q?t9N3J5RuAq5tNrMN4HNR0cemwOY6NjwaxPAh4FP2333kNihjkuhmzmgH0Fpy?=
 =?us-ascii?Q?HXUe62kkIo8dhrDiHymWBDY68WRCjfCdt5xmHuFL5yTHO4sXRWe7EwYoUPiZ?=
 =?us-ascii?Q?2Cq2AIQFBoYNpEnmZB+z/RbSzd8z/rv/SY8FhLJ9po7JGsKg9fFva3hFp3lH?=
 =?us-ascii?Q?YJO1sZ9pGhSNP/YMNJ0t1nNjSWZo+5jCJwJqnyyhioXdS9ltbrjhvmtmoauE?=
 =?us-ascii?Q?E0uXxqXrRVeUEZND8rq6f+34EcH4+BGvdvp5dagSBDSycOVjEI0yjJ1TgYof?=
 =?us-ascii?Q?8j/OUm6UGKCnOhfBNF3TOw2rUlPpqzchGaZJBewsPhJbBYdJCt3cHW4T2sdP?=
 =?us-ascii?Q?P4y2mhYzMffBdUR7mlAwSzYS35d9TTlmRziU5qJ7t4gSbWBrob3ZgiDc0ZSl?=
 =?us-ascii?Q?E8CzuknNH8GSf7I7hwQoIcyw10vw9gCbfrslSTl2b9DyPEF93dOPfwgnSl0c?=
 =?us-ascii?Q?X2fYOm8wB0zmK4juofx2B3oeIZnA9IL1fNBLtVQ1m/ZDgXFv6cumonVGQ1+f?=
 =?us-ascii?Q?ZSM+BIDy1QJ2IubazqnBmNAyUESEeFjJJROGJBXnIJOzz3K5GgLIUqhw1z1b?=
 =?us-ascii?Q?RmgAp9bE/ewW6zWcJwjqvduECeHgSXRxpfVBph4EGV3Hw8iYw/uuaA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jwayKxIz08i7lnArpdMNLovQqyYOQjUoGr3ncC3qow7imMg/jHbLCyrv8o6n?=
 =?us-ascii?Q?aRzorm0rdnRZesGtPl9gPJjqLqNyLgUsUM8Z5gfyU2MmR6SCXzWw6eVTEQJ3?=
 =?us-ascii?Q?pY+m9+RwnGAgq8cHcRIvMYvsDdZXvpTWkjbHvKXZ3MclKb6cRgzjuHy5vMyy?=
 =?us-ascii?Q?02yWGavUml3JnqfHpfzlheA6itcSwkpuuCDRm7jrFmrx4iql+L2MiBRFnW3n?=
 =?us-ascii?Q?QBmlq8PEw3lP1l/CWNQahAvIYpPG3xDHMp8wa54jAcY7d5X7W+nZF4JboRM/?=
 =?us-ascii?Q?kW1BzVQQlEud8lq3IDBAJoG88+nIOlA1jeBFl28iEisa1OaKYkXFGA0bfuuj?=
 =?us-ascii?Q?2Ma/ruFvuYJwUqL4aLvx62pb94tMXhE+GbDGrkaz1Lj8tmbrLLFJmST4dnxY?=
 =?us-ascii?Q?o6IcPWtGGkR3tEZHJF52z2W5SNMXSWCuaDbI6qMFzHRIldszECkXHzsm/1P2?=
 =?us-ascii?Q?+m7c2q72VQ/OLq/ddV5L396GRGQ+B5afYmJjASJDhIAdEq4huGGCgNkYmEXt?=
 =?us-ascii?Q?Lw+h208OEW+vNKq9pK9jso59WfCp5MI1rBTq9gq25kPn1JQgKDeCOVavp6hB?=
 =?us-ascii?Q?EneR5dJS1r9GC6Y+RjajVYOqKraL9Hfo4p1DS3ieHX/WOsd+xU/FMqFPET8h?=
 =?us-ascii?Q?vGdJpxyc0HQtUFxTq9wKROgw2wEM44NdRrso4yKzYsmjr4O2m0BbTZow+6od?=
 =?us-ascii?Q?WIX6Jb/6KAO9I+bBfxc6rVIGquzfD9P6UqktL0aq2vr+hoLxcoroyJscLcT9?=
 =?us-ascii?Q?x4wfPU0+SxOkMSQzbPVDkEZ815hFOqn0ZYfdwI0wePIv5wHeLPM8aA+P+KlL?=
 =?us-ascii?Q?ZfDGqiZCZeVrjEIO3YPlkwfhygJVuZ5agaGwylgbjafm6b6Mmgjud2ljoFrH?=
 =?us-ascii?Q?mYviY2+FLA6otfZGSXlng+J/v9aRcqI8O8GR74tpc/XD37BHYxaFSuQoIhPG?=
 =?us-ascii?Q?E7DaDUrlKOMi36GT55OsqGYtZUDF+PwwPd1ukHmbgixEdVDfX5Ya9lsiX37K?=
 =?us-ascii?Q?kGeu4sxvm3tuTmZjY2YciqG/0dX5yoWUx65Xn3uhgm+Sc6xjGFRgVMK5oT7W?=
 =?us-ascii?Q?oQSbxqVvYuTZy2iLxSqLdbqIG150m46wNfMQNNyLVBq4oXFfVAndpYokXEJ9?=
 =?us-ascii?Q?EgijvEsn+SZCorf7MTprYRZWHaIRuLC07Nsx2bYhwHLizE8cVaqJ7Uba13pq?=
 =?us-ascii?Q?/MvSGmeCOymWv0VAqJzSmAtZ9Apu+GWoBaCr+sJ0P1WZinsfY9+V7DJvtByp?=
 =?us-ascii?Q?AKgTOWoEFuPqzJkqmqiUY63hCnqkzUl6Lfv/9WUXTemSP/AEO/49tA0FpcT/?=
 =?us-ascii?Q?od2gJq2h6CNMHIWCvJTjzfI4P2EIskOmpJakgdYHp92Pn8XRK999a4gDcsPw?=
 =?us-ascii?Q?WDc7ATagCA2mUunIrk1VkILm7Z4yvBS1WBYSaOOhNfZh/VeoISC2HsW6Fhum?=
 =?us-ascii?Q?HSgGqNaTSeFhAp54pYLv0ueThJ1JJDU6dl/6k8T2sXQ62xEKI3Ht14nR0OQW?=
 =?us-ascii?Q?FXEnHVQFijMvvmRqmpA6jAdUk+jjZq8nhXKC39MUVuXNFNW+dAybXyv1/mvd?=
 =?us-ascii?Q?hdm+v95WXxrhYCjo9cfjsnjR0Q+AE7jaM7ItZNLMCYfxZOCsX8VnYn2AffB+?=
 =?us-ascii?Q?Uw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	1QgrlrUJNY/OCcKzs5E7olzF8oTXh0SIsPA6niU5ZRKur3EmVZxqnRByolWQaPh17/jZr9bwjSAi9bpmBEPW3QPvABQgXQ3zy7mDx8n9Aq9UCLDLmM/z3ZLOGSsuKEM+UafQuoVIX7EGPwDupY/psSKahc8YCn/e7coeZJhoT6TeAiBtw/efKZMVEwIwp5nuYiwIt6mrdizG/JTkBjq5hCiawgy/1cAHD8WJnORJci2fWTDv6PdYNJENrG0RaLk/kVfp8Wo4o5OFF7lE5qPHuud76Zl72P07r6ayxeoUQ53QFfCoKByPYK9WnBRhqN1IYR9IUnabroCLmuiHDiqucMtmi7NFFbRxOR4pL5OlmrS2iwFG/18N15SzawmG//wP28HIhsEzd9tLJzjGG8RekxnmO/7W4nPzut2Pah2D94txOpxOmP3026KExiTP2HBkBg+UOpufgsbxXvjESKcZmMYadhYWflgJuoiJZagx4WuZ4gYgQ+MzkpZF51hFcF6UMYpGO9O+2GqbnolwJmuk+pCD2FqR9oCOCJWrBa09SJ8XwmZAEiPF2lfyeFwqipFEfAr29bMtV6HMQv337hsgz6brqhJy/7Pv314RDrTPJRE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c2873f9-695e-46b1-f6ce-08ddeafbc91c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2025 15:08:48.8996
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JHl4/zfqj73w43s6d+gNrdqzxEFBYwkXks9RhkpVn3iUJeWJ7vxFyZY5LXhgyRZOk7QWOfsP8U7bYXSTCFqt1WH1jRkMZicWw8qpZtlYq6g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB7047
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-03_07,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 suspectscore=0 mlxlogscore=998 spamscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509030152
X-Proofpoint-ORIG-GUID: sJo2qs7j6qWF_JM4pmrFDSm6ifaFJ0vw
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODMwMDIyMiBTYWx0ZWRfXyiZuUkLPH/MY
 KSgVdwqex9Al1cnwFdfQ7WZlH+Nw6sh4WLsNVUKwMey59JqFep7NGqgRjFYFZIwbrfPvWtImNf4
 KxBxOTn+uL/R/lgPn+/fWpvBIvH92/R4cUquBZBju+cxGvIiifB3WmG6ds1Km67WQzAbyrlNbXy
 Yu1w6wWB7OdCjrUDucmYPt5b/MC0e/CGhEBDkSG4aSl7hPIumR95A7n1BHHpuSF50eAw1FvsnRp
 udXjZUskX+xb8icGscYZAE2KieAY0YRvOWmV7VdtpTkwI+CUOnAe/pZUY13d70pydach6jfF6Nu
 5o1tR+/Ka/MCWMJQhxSCthf3ErY1h1rk0rGAF4Jl5R8QF0cjkrlirLLkQCjFchxZCPBH309wqa+
 BDaFKxRG
X-Authority-Analysis: v=2.4 cv=doHbC0g4 c=1 sm=1 tr=0 ts=68b85a04 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=5GVuVi787-8-LCMG5HMA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: sJo2qs7j6qWF_JM4pmrFDSm6ifaFJ0vw
X-Rspamd-Queue-Id: CBF96C0013
X-Stat-Signature: xepq53idpy1q7cz7ywxn1zzeyj3zu8a3
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756912137-378221
X-HE-Meta: U2FsdGVkX18GgZKG54uSPF/iDJ1a5kPMTWmiuv2qMfEi/Mo96oFjTF+UmaFBGBuomWjSZttOBgin6dOW6fSpzqAt1rsjekJIZKR11l5lST5DHbqDvJILih4ABIouTizxnt5sM1h3NPjzeHGQEV3p7G1bcJkJHgq9ti7y8KHc2Gn15WCrks90onNUMtbqHX4UcoyC+o216JZpGNGf6Dpa4j/nQA+sGvKJWReRnzYmiKUi9ncrAr2KDhxe6L/cI76ofs68r865vDz/iZHcEicpgo0S471ZQtwPj0x8j1gw97kN0C9dIsEgv87iBp8T9AydzPzhlTdsbtCUawcua8shilR0i54L9ugfzQTDZCY1NuYMQ0XemzcAtEW6kQkPYMRaSz7xzQCB0anh1OtjyLzG4MuHacTqZGx8BisESx15KIekJ1FLL3n5WmGY4fkIBhuJzVvZ+HXGH/0wJ26bJ4kIaidmELYoDyZNElf/1cOsMQuh5lSVQA9cgZjCb+v3mY/pHnpFSu92Ayw4Grxtywa8SFgkPlp6t0viEhlJMLE+U7q//kDKJX3JOzK+hXhA6QZEpvCcYBXNiGvvYNMW5B7BrNNJLfjACOWoRwBOR2nQbcZlTZ6K3FbAHmCX004h21ujlwF2Z4anlXdLHSp/e0ZPdFkS0T8aGOi8ROmI45gec4is9FQ+/I8h5KvNilluwWrZhAT+ffj6+8gk+mjY7y27EN7anYvWzr9ZKlLCDtj5nZbs23OA0OwflNJqUtkzMuXoETFD3U5Nije7bYWzdxiDerboOu3iwE4AjfT5Wy930CZSxDZibgLYXRZ786/OhEJlUMRUUlW3KnvVX7P86WHNlRYdYVsaz1JKhQQrJm9leDoVq4Mztzii60XW15wq49vtiVnUGi5vV1PAJR7GIkasyxgB+MFxAAoPi2lBw5z2awLQOvJ0G7k75/kVc4T8Du9lVd3sUlGpiF2YWVQGink
 ovvlX7r/
 Y/D3jzMAL+xEmJUsXq9cMI255d1ZVOjMBAizdgK6GJs+9zS43x4JIA4TtuXB1ZGOwORa8ga904lnuTxOe+CIUrqxLd7cgFrp71vSnO6IGQR5Ou8329IWnkRxWzHfy4+nRZfCK56C2csE/sepH2Dp86/xHxT/eNEqObeTzT6Q2LQXzgUU8SXKg7LTFxXzlcStotpn0rnCqym/P8g3F8XyfviaduVr8G/svzFQK4p4KJjEu8k8ylS1+OKmigNfaBRGJMe/HuJSqvUDawf1HZ1YNs0nH79Yr2G672xpX7UVxskjVXCyrq1WiE9vY3gpHYh5rXmyYdPFfzA5L7j5WLVCD8/TJ6B6yrJLlz8TfM3VZ0llBl0RWPN0KLszGMPwNYZIv6n8c2cYHKWoHcy+5MlhVXe19LtUMyrBmhT0CauVaQqvsbC20ujwUVkeurkeAWpXrvHpgtG51WlXU1BVd6ao2bHAUbeCFBX6LzIrOisITAjr+KplUFPtPQK6jAlWXTgP9OYyev2yHox5z0wdWkZyfLp2vBcwFRtgd7aA1WWMWuR08S15+CAig3dGjGhpk76ddA4LfnYRh+Im7eSxS55B8Ea6mpKnCTTuLVVwtMrauUry/aWb1AyQtaEQwt3FYF1bKofeMI/3x0oSzwK4WPuWwbreTzVbv7yN54VMCPTq2dxBz4LDf/KD4U093tOQuJkgCGL542sbvVCCXYdJ0K+w7gfyr/sxoIfFYlCrFOvOju/ZYhSaksDyaIe1wdhKyVcWBiL6TchBDY4HoQ18=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 03, 2025 at 03:52:21PM +0100, Lorenzo Stoakes wrote:
> On Tue, Sep 02, 2025 at 11:08:10AM -0400, Liam R. Howlett wrote:
> >
> > One nit below.

> > >  static inline void set_vma_from_desc(struct vm_area_struct *vma,
> > > -		struct vm_area_desc *desc)
> > > +		struct file *orig_file, struct vm_area_desc *desc)
> > >  {
> > >  	/*
> > >  	 * Since we're invoking .mmap_prepare() despite having a partially
> > > @@ -258,7 +258,13 @@ static inline void set_vma_from_desc(struct vm_area_struct *vma,
> > >
> > >  	/* Mutable fields. Populated with initial state. */
> > >  	vma->vm_pgoff = desc->pgoff;
> > > -	if (vma->vm_file != desc->file)
> > > +	/*
> > > +	 * The desc->file may not be the same as vma->vm_file, but if the
> > > +	 * f_op->mmap_prepare() handler is setting this parameter to something
> > > +	 * different, it indicates that it wishes the VMA to have its file
> > > +	 * assigned to this.
> > > +	 */
> > > +	if (orig_file != desc->file && vma->vm_file != desc->file)
> > >  		vma_set_file(vma, desc->file);
> >
> > So now we have to be sure both orig_file and vma->vm_file != desc->file
> > to set it?  This seems to make the function name less accurate.
>
> I'll update the comment accordingly.
>
> On this in general - In future an mmap_prepare() caller may wish to change
> the file to desc->file from vma->vm_file which currently won't work for a
> stacked file system.
>
> It's pretty niche and unlikely anybody does it, but if they do, since I am
> the one implementing all this I will adjust the descriptor to send a
> separate file parameter and adjust this code accordingly.
>
> Cheers, Lorenzo

Actually, let me also send vma->vm_file in desc and make that what gets updated,
and make struct file read-only.

That way we solve this problem a lot more neatly. No users are currently setting
desc->file so it's safe to do right now.

