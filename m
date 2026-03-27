Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1DA910F284B
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 16:12:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF0046B008C; Fri, 27 Mar 2026 12:12:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA1C86B0095; Fri, 27 Mar 2026 12:12:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A69D26B0096; Fri, 27 Mar 2026 12:12:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9134D6B008C
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 12:12:26 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DC78EE06F9
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 16:12:25 +0000 (UTC)
X-FDA: 84592335450.05.D0581F5
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012013.outbound.protection.outlook.com [52.101.53.13])
	by imf29.hostedemail.com (Postfix) with ESMTP id DE479120015
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 16:12:22 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=OMVwRdky;
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.13 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=OMVwRdky;
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.13 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774627943; a=rsa-sha256;
	cv=pass;
	b=r9aLrXEOXestAQXDl0diTIVICFC8X3Gs6FSZx/5ZC6pJj/CU2qByXAj9YcqvLYvyeGpbd6
	nse7/yNjDKeM+H+o9j/fdWEZGUgiMYK0cDK1X8snDQmuByDaxMVTGCPwPnGHpUNYjY4JtM
	XBJYG7ziTSei0lW4MLhrFDiczXYCjQ0=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774627943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oO1Bkf8zcdePtYlgNbddss8+9TNIkHTZwNztCZ2DnI0=;
	b=zEM1I2u5JAWx/5FurfxY0As3qbGk4MhCHXXTlLWsT1ICrgt5OmdCcFvuCvsryr2dAShNVE
	+XXxh7NC4GXpx7Zxn1EhUEfhvoWmdBCP8/LXQoTAzOur62PjSXhFTwZgHZJ4uF+XOORH6+
	ve45fD798hqcQhQRksm+0bW4P6/haLo=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Eg1RG2xvSf66F3GXkKMzEY61mRENkg1drcXVDXC+NkYLxiSHgKgM2XzNUaA3MJdn4teDHLPMXZOpauH/y65L7j/Q5nmDkzUO1b0lLC+O6/pMHQlE/hiQ2FJ5fn8hwZ8ApVO8iLJpTdFnCgGIMnexx3DUjDFOnsXiM5EJsob2X2QkWm9FKxedJ2EHt1ZImIBAH82Oh6RgReO29fje8Mz5nEJKbLqAldTWnHzCbLgp2Cbnfb8I/bwXoEE1yVPpBp0R3zz3yLnViI9zMNvcGBLKAEqm3aJhGa7fCGAB9jNtnTtUAtlQCeGqaW6AX8G+BDAwRicIRr6/rfrKNsfVFoFd2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oO1Bkf8zcdePtYlgNbddss8+9TNIkHTZwNztCZ2DnI0=;
 b=T4C1NJ+srgukqHM9gs5IMnH3G59OXRodgfTPI70YRbILAgCy1+66oeNWB3fsTHtoBcwnrWe9PiR+ZGf4ceMDp0mttCavhuQSYbXym/mzNXU7xofRagXLTowmyeJjuscEaU0sszU3UbtT8qXZlN8ufMsCiPmLMpGrzyXGToh/RNg/URTQFGpSsAOMNPF5MQqDRIMFlxcVUe3ltB9L8WY5L/aw4AEJPkrAOoZ46ooG6YBCxmFYKK6Zp3FMgfDgxd/2yeuouGczeFqqlttynlzNc9AH29y6eSoNAHy/SJ0aP31L9FepdktRrZhI+o2vcC6TG93IyHtroyKDVwJKd0IijA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oO1Bkf8zcdePtYlgNbddss8+9TNIkHTZwNztCZ2DnI0=;
 b=OMVwRdkya4aes1+XRguxrCmx5ckjast94ERcDwadEd58iS8bRv51+U44SBHdQJBRvlUGhLs+Dgos1wkvv2z868RgIk5aD0whkiYyUwfr26VCSXnzKZydlGJtsqeO/MmaEUSHkLYuN8ArUQw5XE8LpIJYyimFnmRGL955+hDZKPRlhRzR/JLaI92UNCqvCxKNI298FdhJrvnPgWMd4tGx2M0T+CWL/l3mOhBZ3UVH6Fdmfgil3WRfkRx2QHvJ20SmTNhmG67J9fa3+Iir1oTnsEZmf/BBtiPB/UiyvEbqt4lDVlwLoRR6h72hXSRKgecEy9ie8Ko5XNoxc5cWQVz4ng==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH8PR12MB7157.namprd12.prod.outlook.com (2603:10b6:510:22b::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9769.10; Fri, 27 Mar 2026 16:12:16 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9745.007; Fri, 27 Mar 2026
 16:12:15 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v1 05/10] mm/huge_memory: remove READ_ONLY_THP_FOR_FS from
 file_thp_enabled()
Date: Fri, 27 Mar 2026 12:12:04 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <52CACB9A-A782-4D11-8B6F-66DA8D345C78@nvidia.com>
In-Reply-To: <10b04dc8-e155-4a31-84b6-17b302e65c7c@lucifer.local>
References: <20260327014255.2058916-1-ziy@nvidia.com>
 <20260327014255.2058916-6-ziy@nvidia.com>
 <5ac47338-1954-43ce-9984-56d70f7c392f@lucifer.local>
 <075A4C69-B386-4557-BDAA-4038EB36370D@nvidia.com>
 <14af57ba-09bc-40ff-812a-b41dfb78a03c@lucifer.local>
 <59A91369-9BCB-4545-AEF8-083B52998CC3@nvidia.com>
 <10b04dc8-e155-4a31-84b6-17b302e65c7c@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BLAPR05CA0010.namprd05.prod.outlook.com
 (2603:10b6:208:36e::19) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH8PR12MB7157:EE_
X-MS-Office365-Filtering-Correlation-Id: d318d0f5-0123-4353-8b51-08de8c1b9cd8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	sJnveLcTAExF91YxhJ5wQ3QTTYEPzyEiGlq+jCosYYS60ntCEQdPSygRJE5lRdJiSuhBxyQFBVBLlk23AkKPzDajZfXJx0Fvn5VULNqSpkHF0hUJ6WHW8oREWAnZi8GvKod/Jr0NFVLYgAR8e5YqBWb4zp8fD40gYPdadBnabvht+wknabRmpThZGijyMb1u8YaD9ENiE/+tm9HZQNSj0yt4QAvbQX0ALHMc0R6SBIlXEIqTZPYrXgwhuKzeV4wmstQ7n+tkxuHj/lSHw2Om/Kr/ZFJzotFfFYXGLzZ0TeaUy5/V/hvwn3Dcot20oCE+5zRBDw8tw5H5Nd6cMSLoj3bJlumEgYneZW2RnAaXtgeFb25JgfQnbAVp9dbwrkohQnThncM0P9+mYoAwpBl9jgwnds5MWCe8qhh54IPLRawSJHS64V1DjCioDgIjPnQ+x8VMybrfpIT33KquhR/9SdG4LTdTRJlD182L3t4XJ7q3WIf9eEUBT3P06nXZ3HDcr64VHkZ+lNXTy8H1+BBiXfXhLKmphjFXWCOgujKLUZB1qObenqmH2mKWgHLcTKvCn1ApffxxI1byOPOfBbcmJeNvpbi39sizfcLC8nhEXaXscY4JSrImvBtm9m4lMldDPEeR2PE9yGjfzafWL3nchXuS4lIc+cFplTyX12jxDGUnchMHo7sSsx0bdOLCJqzxGtCY0OrI/xJziWJ+C5jj0T/WoJvqyX+M+w/u7XIlgxQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?c2Vqc1Nyb05HbXhTTWdxYU5iWWczNE0xYnBlWVJkbXhqNUFjNG8remhGRnI3?=
 =?utf-8?B?OFRvS0VVN2t1VlhhWHdPMEsvM0RVbWdvOFEwVml5QUdycXUxRjB1ZnFJR25T?=
 =?utf-8?B?aEhJSEoxckpnUW9Qck0yYVJiWlZ2UkEwSlNidmdDaS9Vc0IxeE9LdndvV2d3?=
 =?utf-8?B?cDNFbHpOUVRIazBETTVOb1ZZL2NvUTlMTCtFZFlTVWZYRyt3OHB0SmMrUFVP?=
 =?utf-8?B?YnV0c2NrYTNQRmNuU09adE93NmUwM1J5dU1XOU1jbEQwdkdzcnFDWWR2eE1l?=
 =?utf-8?B?eTdQRWZ2VnZCU0xFUUVMeWpnckdrcXhWa0QxbUNHdm8waTRZdGFpZGtubE1H?=
 =?utf-8?B?VUhLYUIzTjd3Snk3bkVHUUY1R0J4Y3g4TlNLRWtkR3dlaDlIZlRKKzFwZ29l?=
 =?utf-8?B?dTZWRUgvWlhNMUFPc1dRdkdEMjhsMzN5ZWtPcFh0VkVwTmlOWFdOU0JPaXIr?=
 =?utf-8?B?WXQvT01YUC9FQ2dWUk9YVkcvVDUrY1YyQU5SRDR3aXRNdmVtalNRdzUyaEtC?=
 =?utf-8?B?YTRMTzdYd0p2blcwNlpjdWdtOGxCdlNBL2pOZ0RvRnlsUmUraFI0aUhzMjlK?=
 =?utf-8?B?M3lRWHZuSmx0WjdUMVI3cGlUYXFNaEE0QjJiMjlPUjVNTHpDTXFmY1h2c041?=
 =?utf-8?B?TUZab0t0NUtCUjNVODArVWpaVVBQODJRSllJYVdRNlRUYUVJd1d1R05tM3p2?=
 =?utf-8?B?OGkxMitFdXhJQjJoaTQ4RXp6QnB5aC9IenJCUzdlN2sxUWtGRzhYOXdGK0t2?=
 =?utf-8?B?ZGRPZjVxUGV3QmIxYW16MW9rTTZ4ZWpHZXRVd3huNWxFcDBxdXBhQVdZbm1M?=
 =?utf-8?B?NFJZL2Z1OTk2WWtFaCsvR3NPMk9iUXRhOHMwMWtaMHdmMHVuOTRHM2NTL28x?=
 =?utf-8?B?LzFNT2NFNVJZS09SZDkySlFaVEJTRnpIUnBrWGV3Qm05QmVrU2tINXJ5bUdQ?=
 =?utf-8?B?cmEzT2g2Z2NUWVRveHlTdkVEVGJEMHF4ZllEN2xSbDVtSkNsY3FFZTVyN1BW?=
 =?utf-8?B?QlB2NXdjSEFiQmNmTXIwbGZ1bjZkejVVT2dqbk5EdFRISlNqMGh2ZWpubk9T?=
 =?utf-8?B?TWdMblNPdE9KWmZlNXphQVZzK1pNOHVLSDZBWVdxNUlPdDUyM2ExQkgxa2Fq?=
 =?utf-8?B?VXVjKzlnTzdDdWVuTU9haGc4Ylh5b244VUsxQ2ZnbG1jdE54WUt3bG5PUWdi?=
 =?utf-8?B?RUh6R1VDRUEvN0F1U2pYT0ZUa3ZuSTFRSThqK0ZQU2hjY1E1cURBTUlNbDJR?=
 =?utf-8?B?c2F6bkZaSnJtbExSQzFONGpHQUZwRnkwaDdmSHFITFFoNElzci9ndHVtTFhY?=
 =?utf-8?B?aStxWTRIb25lMUdiMi9XMkl4QUYxTUc3TkNLVDBoblJhZmhGMUJxQlZZQXFO?=
 =?utf-8?B?RGE4MmFGdHNOV3ZoTkN4SmxITDFJWVVrM1FGZDJHWWdPK28yK0dYSVNRcGR3?=
 =?utf-8?B?WHdSckJLeE9pZTVMZU1BZUpwY1FpcURJZVdkc251MkYwOVhVajhXcVF1MS9E?=
 =?utf-8?B?bEh0K2p6VklwZXZnK3hmNlY5emZNaUtxMElqRCtTWWhKMGg5Z0NDdFd6WW8y?=
 =?utf-8?B?dGU2NkRBY0NiMmhvNnNEWDlKa3dlL1ZDYXNleEhRSlRIWElWTGxWbVZZVkcr?=
 =?utf-8?B?TGhmMUlBWTB1cjY1bzJPQTEwN1U4Q3BFOGN0TytoWWFuRjlxTlB2N3k5TGNO?=
 =?utf-8?B?N2xrT0hTTEhoSkQrbmRISnR0Z0lTSHJ2WmQ1NFFnS0pPbnRSOVdLNDVQVlRs?=
 =?utf-8?B?ZFQ5ZmJWdzJHdEtMaTZ4Uk16UkVjckJ3WVBlYlVZSUZ2STBVNml6ZmpuQzkv?=
 =?utf-8?B?SmZGZjRCUE01aDh3Z1J1aTJ3cFp4UU41dkFRekh1RnI5WjFENG9XeVVCRHZn?=
 =?utf-8?B?Z0RJaGJMOHk1RXEvMDBPSlB2WWlmUHk5MXhsd2xZdE5mSVpXOUEvN0RuaEIy?=
 =?utf-8?B?TGVpQVlEdjJMMlNqZnZxZWJCTW9BLzJlc3BPdzVMa1lqUmdaM3VVNFlVRkMr?=
 =?utf-8?B?bjZpN0kyU3J1dUVUT0ttUG90QjdFeW1UaHdOdjJ5SzlrQ0ppYnlSNFViRlhR?=
 =?utf-8?B?ZFdQdVBPY2VyYTFqK3MrZGh3cU1jS1puWmJKS21tK1hEcTJmckZudnZmdjFw?=
 =?utf-8?B?VG5lcHg4M2NQa3NOclc4U2NuUVM3SHVWZW1MNWJGcUc4aWRpalB6QXVMajdt?=
 =?utf-8?B?amdPK1VYVWw3alJ4ZXM5MUJlVk1ubTdSaUJTbUhjQkxJKzZsSkVSVURHMFJl?=
 =?utf-8?B?NkxVYkttSzdXNWFSbWQ0UmduNGpDNUFhdWZXRnZwbWp1ekdNREJHd210Y1cr?=
 =?utf-8?B?L3E4eFpqT3BDOVZ1b3duNitsRWJUYlcwRXhJVUUrMjBlWG1vRUlJdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d318d0f5-0123-4353-8b51-08de8c1b9cd8
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2026 16:12:15.8057
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IkbLaDdFZi1xTtPyyWakAR6RSQ6g2tzSj9f/5K/hnuI33fr40xHwAQS5lx6uKQES
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7157
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DE479120015
X-Stat-Signature: 44n8msex6yf83e8gnr7h96rra95ck88a
X-Rspam-User: 
X-HE-Tag: 1774627942-827342
X-HE-Meta: U2FsdGVkX18KfTwc+PQ2okRctog15WJ1GtFzZ50ogoCxFcSwqKMJ29jME6P7fkNGwO6SJwKRmZU77ja+zC7b/4RNo8vONtemwCKATmE+nCeua4j4prxuHuUxVn2zr9XhArL/XzHFwrm212HDFunE/hGUJzdAK00CTiHB1VLJU0e30YGWKbYTjBb+U3TItMruA/7yuOPHsblDHn4qxPUKmg7khpYkDChVbQRlD1RqgPBuRz8GnWj6Ut+nOMZjdhn9LZ2j58/YU8ToyNAtQh6DB3hB2en8vzBw7EGTZp2dBVFEofbUY5pFkb2nalUSO/uAee6CavhESx95HtsJc5Qrbpk4XDhZD0yaf856NxVLZxxE32PKejo8Oc4zpL6Pb/h34nYN+BHROV2QVAhFbXkMUk9olM3j7mVDxjNK2vVyYZAgEfKBj0MdxsYhPHHCR69N54dabQW2TsPcUUERudA1pXyGIHCs0MgYyO9CUAZ19rfyEbm/p3oxh8SCR4vA3jMI37Rg5wWTnw/0wBYCp0tC8hyxT5PUUr/sjBsMlqR6Dqar1y1FZrJ/6F9bzS25MJJnGtDG1xlWrzhBQopYdAXpbjsYnV5ACGtEo5qrB53ibjjQ6lCGIp3DpYEOlxrwcC+RebS2k8O2W52hLj0MJGR3K3VpTTbPjpZDMUnXU8Nddz8ub16sWVFhHZBh+W89o7MmTSBA8TukMahfZhaAy0WDNHqMI5zwUTGtLUF382XucfKLVmIY6o76miUcIWaaBmh9D6dlwiTOc/KrBSOz7Mkv//3cOtTc+EVIjoK27DS+lpts/ZCEKEvVdgrh9D/Vfdwezlsax9KWcMAgeZyTIMGsEnanLC8SjJ5D87GJ4NMmt1muJZBrhuxe+Ptt6xpgzcviPqlHuSIxyFED1ZbgKlY5ilTPTWiMiL5HcFpuf/x2FbJHIptqT5Ou0JgAg0cDdPU8qjFWRajrIhTn6V2IwlS
 TJdHw7Xn
 R0m4zFihVuFDkvPZ89JoEuxAsDFI3sfK8xwxRlCWRuVyWyIwvea7lZ8+jw1m7sXGIVQNIesUMbDsotPqxNnT55Gi4zUUsJjZsGivcSoZchPaakc9m97/CpT507N3h8qxTpiUW6eYsZ4LPfJqnkJSYjkxsDnldHU0JPSNO+7nemsRA3b0VBHnTnVa/H5XHjZlCvWWNhLaRWl5eEW20cOy5D5qoVeGxQNbvM97w7hsYEzfgfNbaefaTz9rjJbnO4PmCEQz/bfFoorO8MHVFd0reX4tokjZSvNmN9/j+2u05PAV6e5x0MEp5+xIyMo9tPz1A3JYQzHn8WxAL6gBBJpwbVxQpZv6MPCa40b4XGFcAIsfz3bFCRzQkm6ekntYmowNTU0OuFnmyCmJd42zlRr05zqXbLIW//yIPTL3qzW/IhbYqamBlsTcmCVknBlnDdb2/JbmWj2GXLl4W+ZoisxRL/Slsgg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27 Mar 2026, at 12:08, Lorenzo Stoakes (Oracle) wrote:

> On Fri, Mar 27, 2026 at 11:43:57AM -0400, Zi Yan wrote:
>> On 27 Mar 2026, at 11:29, Lorenzo Stoakes (Oracle) wrote:
>>
>>> On Fri, Mar 27, 2026 at 11:12:46AM -0400, Zi Yan wrote:
>>>> On 27 Mar 2026, at 8:42, Lorenzo Stoakes (Oracle) wrote:
>>>>
>>>>> On Thu, Mar 26, 2026 at 09:42:50PM -0400, Zi Yan wrote:
>>>>>> Replace it with a check on the max folio order of the file's address=
 space
>>>>>> mapping, making sure PMD_ORDER is supported.
>>>>>>
>>>>>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>>>>>> ---
>>>>>>  mm/huge_memory.c | 6 +++---
>>>>>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>>>>>
>>>>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>>>>> index c7873dbdc470..1da1467328a3 100644
>>>>>> --- a/mm/huge_memory.c
>>>>>> +++ b/mm/huge_memory.c
>>>>>> @@ -89,9 +89,6 @@ static inline bool file_thp_enabled(struct vm_area=
_struct *vma)
>>>>>>  {
>>>>>>  	struct inode *inode;
>>>>>>
>>>>>> -	if (!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS))
>>>>>> -		return false;
>>>>>> -
>>>>>>  	if (!vma->vm_file)
>>>>>>  		return false;
>>>>>>
>>>>>> @@ -100,6 +97,9 @@ static inline bool file_thp_enabled(struct vm_are=
a_struct *vma)
>>>>>>  	if (IS_ANON_FILE(inode))
>>>>>>  		return false;
>>>>>>
>>>>>> +	if (mapping_max_folio_order(inode->i_mapping) < PMD_ORDER)
>>>>>> +		return false;
>>>>>> +
>>>>>
>>>>> At this point I think this should be a separate function quite honest=
ly and
>>>>> share it with 2/10's use, and then you can put the comment in here re=
: anon
>>>>> shmem etc.
>>>>>
>>>>> Though that won't apply here of course as shmem_allowable_huge_orders=
() would
>>>>> have been invoked :)
>>>>>
>>>>> But no harm in refactoring it anyway, and the repetitive < PMD_ORDER =
stuff is
>>>>> unfortunate.
>>>>>
>>>>> Buuut having said that is this right actually?
>>>>>
>>>>> Because we have:
>>>>>
>>>>> 		if (((in_pf || smaps)) && vma->vm_ops->huge_fault)
>>>>> 			return orders;
>>>>>
>>>>> Above it, and now you're enabling huge folio file systems to do non-p=
age fault
>>>>> THP and that's err... isn't that quite a big change?
>>>>
>>>> That is what READ_ONLY_THP_FOR_FS does, creating THPs after page fault=
s, right?
>>>> This patchset changes the condition from all FSes to FSes with large f=
olio
>>>> support.
>>>
>>> No, READ_ONLY_THP_FOR_FS operates differently.
>>>
>>> It explicitly _only_ is allowed for MADV_COLLAPSE and only if the file =
is
>>> mounted read-only.
>>>
>>> So due to:
>>>
>>> 		if (((in_pf || smaps)) && vma->vm_ops->huge_fault)
>>> 			return orders;
>>>
>>> 		if (((!in_pf || smaps)) && file_thp_enabled(vma))
>>> 			return orders;
>>>
>>>                       |    PF     | MADV_COLLAPSE | khugepaged |
>>> 		      |-----------|---------------|------------|
>>> large folio fs        |     =E2=9C=93     |       x       |      x     =
|
>>> READ_ONLY_THP_FOR_FS  |     x     |       =E2=9C=93       |      =E2=9C=
=93     |
>>>
>>> After this change:
>>>
>>>                       |    PF     | MADV_COLLAPSE | khugepaged |
>>> 		      |-----------|---------------|------------|
>>> large folio fs        |     =E2=9C=93     |       =E2=9C=93       |    =
  ?     |
>>>
>>> (I hope we're not enabling khugepaged for large folio fs - which should=
n't
>>> be necessary anyway as we try to give them folios on page fault and the=
y
>>> use thp-friendly get_unused_area etc. :)
>>>
>>> We shouldn't be doing this.
>>>
>>> It should remain:
>>>
>>>                       |    PF     | MADV_COLLAPSE | khugepaged |
>>> 		      |-----------|---------------|------------|
>>> large folio fs        |     =E2=9C=93     |       x       |      x     =
|
>>>
>>> If we're going to remove it, we should first _just remove it_, not
>>> simultaneously increase the scope of what all the MADV_COLLAPSE code is
>>> doing without any confidence in any of it working properly.
>>>
>>> And it makes the whole series misleading - you're actually _enabling_ a
>>> feature not (only) _removing_ one.
>>
>> That is what my RFC patch does, but David and willy told me to do this. =
:)
>> IIUC, with READ_ONLY_THP_FOR_FS, FSes with large folio support will
>> get THP via MADV_COLLAPSE or khugepaged. So removing the code like I
>> did in RFC would cause regressions.
>
> OK I think we're dealing with a union of the two states here.
>
> READ_ONLY_THP_FOR_FS is separate from large folio support, as checked by
> file_thp_enabled():
>
> static inline bool file_thp_enabled(struct vm_area_struct *vma)
> {
> 	struct inode *inode;
>
> 	if (!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS))
> 		return false;
>
> 	if (!vma->vm_file)
> 		return false;
>
> 	inode =3D file_inode(vma->vm_file);
>
> 	if (IS_ANON_FILE(inode))
> 		return false;
>
> 	return !inode_is_open_for_write(inode) && S_ISREG(inode->i_mode);
> }
>
> So actually:
>
>                        |    PF     | MADV_COLLAPSE | khugepaged |
> 		       |-----------|---------------|------------|
>  large folio fs        |     =E2=9C=93     |       x       |      x     |
>  READ_ONLY_THP_FOR_FS  |     x     |       =E2=9C=93       |      =E2=9C=
=93     |
>  both!                 |     =E2=9C=93     |       =E2=9C=93       |     =
 =E2=9C=93     |
>
> (Where it's impllied it's a read-only mapping obviously for the later two
> cases.)
>
> Now without READ_ONLY_THP_FOR_FS you're going to:
>
>                        |    PF     | MADV_COLLAPSE | khugepaged |
> 		       |-----------|---------------|------------|
>  large folio fs        |     =E2=9C=93     |       x       |      x     |
>  large folio + r/o     |     =E2=9C=93     |       =E2=9C=93       |     =
 =E2=9C=93     |
>
> And intentionally leaving behind the 'not large folio fs, r/o' case becau=
se
> those file systems need to implement large folio support.
>
> I guess we'll regress those users but we don't care?

Yes. This also motivates FSes without large folio support to add large foli=
o
support instead of relying on READ_ONLY_THP_FOR_FS hack.

>
> I do think all this needs to be spelled out in the commit message though =
as it's
> subtle.
>
> Turns out this PitA config option is going to kick and scream a bit first=
 before
> it goes...

Sure. I will shameless steal your tables. Thank you for the contribution. ;=
)

>
>>
>> I guess I need to rename the series to avoid confusion. How about?
>>
>> Remove read-only THP support for FSes without large folio support.
>
> Yup that'd be better :)
>
> Cheers, Lorenzo
>
>>
>> [1] https://lore.kernel.org/all/7382046f-7c58-4a3e-ab34-b2704355b7d5@ker=
nel.org/
>>
>>>
>>> So let's focus as David suggested on one thing at a time, incrementally=
.
>>>
>>> And let's please try and sort some of this confusing mess out in the co=
de
>>> if at all possible...
>>>
>>>>
>>>> Will add a helper, mapping_support_pmd_folio(), for
>>>> mapping_max_folio_order(inode->i_mapping) < PMD_ORDER.
>>>>
>>>>>
>>>>> So yeah probably no to this patch as is :) we should just drop
>>>>> file_thp_enabled()?
>>>>
>>>>
>>>>
>>>>>
>>>>>>  	return !inode_is_open_for_write(inode) && S_ISREG(inode->i_mode);
>>>>>>  }
>>>>>>
>>>>>> --
>>>>>> 2.43.0
>>>>>>
>>>>
>>>>
>>>> Best Regards,
>>>> Yan, Zi
>>>
>>> Cheers, Lorenzo
>>
>>
>> Best Regards,
>> Yan, Zi


Best Regards,
Yan, Zi

