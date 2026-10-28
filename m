Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50B28606A31F
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 02:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Td+mfv4p
Received: by kanga.kvack.org (Postfix)
	id 2BA296B0958; Tue, 27 Oct 2026 22:54:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 291A56B0959; Tue, 27 Oct 2026 22:54:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1809B6B095A; Tue, 27 Oct 2026 22:54:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C8FD36B0958
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 22:54:51 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 866F7120BEE
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 02:54:47 +0000 (UTC)
X-FDA: 85370517414.12.C0D744D
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010019.outbound.protection.outlook.com [52.101.46.19])
	by imf17.hostedemail.com (Postfix) with ESMTP id 986A140002
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 02:54:44 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Td+mfv4p;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of ziy@nvidia.com designates 52.101.46.19 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793156084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CMb2oVQye3RPKvMmYxLoWlrPiQUfMmGkRTvDAZ0TYtI=;
	b=Nwyz9zve/Sxt0hwU/MKEuZ4y/BZQGf+vbJSt7hX3iElvmAxlyIVfp5ngvKeMnm8weBy2Ba
	cJMXA2QW0lR9Cn6Dps2xysYcw1fTeLlZuwFTO5Xk6lDNee0HzKjXGxPxObAJp4HHdIr+jR
	cHZwMu+X8JYtnLlgdHdgaqTzi68f2kU=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Td+mfv4p;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of ziy@nvidia.com designates 52.101.46.19 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793156084;
	b=E4uwSgrOKybUWePj4mtDLQ+TUHld3ao4lH0FT6gFWmiOe7S4nbqktd05V2XdgxVZ2LlXNM
	d5vyC15f9GZu0JPt5w/YN03fk/47Wq4Fs4PyUFzTNbE7DwV4TQAKbTaJuRXgR7cGgL5npD
	xtCRJgBNFVZoO4RfddeRNpTItkImYUk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ydYLIWq6W1iwhje/hOX8xJKHEecf7oNydsIfJQhsTN33XzOFx77nBCpzUVKvw0hBGM6BcL2gMhOlWPF+JYg3q7EXHFarVOqqnZuKl9xSfr7bI8IqwMgv7pVNCfCTeayLTo7km0cnTlREQ5iHsrZkx5CD2mwIdUi2KwbjLgb2BtfrBmdfRzoaxN5ZALqBfjf1U0HyY2F2GieANzJQt+xqQR0cfX5wfCFh9sF/P4WzjDlTAjSEw9xLHmyGDxPvd0uyuJTL2sY0TKWt1dWcDKqu5jln+b3D1GlFpYwsndxSnu7e+HA23oUMnrJfDu+oZys2aQ20trpfvVV/W8RL+x5R3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CMb2oVQye3RPKvMmYxLoWlrPiQUfMmGkRTvDAZ0TYtI=;
 b=gy3yN0FLVPYLJzLnbZf0J/qjbWi+17R7WvNg7hMydy4oKtDnfWAQVpAmcRX2WK2CAtuv0dwdrqsyOYegSWkUhW1cbf8XuxVs00mAy4JdrgFtZCjerAe9ecrDvQ4gQUrV9E4Xm3C9lDExTevUBhf/nBRpGnRyT6LGVpqwdFaroN06wHZ90JxnNqqFzSAyePiYBQvMx7QVlafHQfBZSQ7618ullkWlBybQ0SnX3hnsyyCH9hgN2qD7zQ5x6KYp8AHHKcOx7RP3n++OM+LrqbVqbA7kdsiw6DH5AKLsUa35xRTkzbtScMcAu53Q93IAHhyVu882YRwKh2vVqwoVK/0Lrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CMb2oVQye3RPKvMmYxLoWlrPiQUfMmGkRTvDAZ0TYtI=;
 b=Td+mfv4pRQCtrM/B5rxLLI1LuwRIMt8HRWQgzB9zAMz/NusJdSUTXDrU18a/iOd9qSlPWaxXMyxtRNa54os1D837xnpaT5TcifJlq8BursF4ytaWAwUxblb/rFE9YSTGJ3iHF7YOiqtGRC449DMNb33MA81m+cc93rX9mSi5n/3v/PgwET8aaHG2LqBb8ixQBA/SNBWhld+FxqD1OUbfXR6qbiLK+4Z9avQcp5lE8sBDR1+JQ2FLFYHnrQx/O7rb1EINRji1zdVJ89idTMp/syW7hixqsNF+I+rPsXcKFI7Ez1Us3kUvWBorGbXDtcFzaT8SOVGhAsoW8ZGz87h8sw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DM6PR12MB4155.namprd12.prod.outlook.com (2603:10b6:5:221::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Wed, 28 Oct
 2026 02:54:31 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0546.021; Wed, 28 Oct 2026
 02:54:31 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 27 Oct 2026 22:54:27 -0400
Message-Id: <DMG4RXAC0531.1TP9FSMKUMZS0@nvidia.com>
Subject: Re: [PATCH 13/46] mm/huge_memory: fix truncate racing with PMD
 zapping
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <kexec@lists.infradead.org>, <linux-fsdevel@vger.kernel.org>,
 <linux-arch@vger.kernel.org>, <linux-cxl@vger.kernel.org>, "Chris Mason"
 <mason@kernel.org>, <stable@vger.kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Johannes Weiner" <hannes@cmpxchg.org>,
 "Michal Hocko" <mhocko@kernel.org>, "Qi Zheng" <qi.zheng@linux.dev>,
 "Shakeel Butt" <shakeel.butt@linux.dev>, "Lorenzo Stoakes"
 <ljs@kernel.org>, "Kairui Song" <kasong@tencent.com>, "Barry Song"
 <baohua@kernel.org>, "Axel Rasmussen" <axelrasmussen@google.com>, "Yuanchu
 Xie" <yuanchu@google.com>, "Wei Xu" <weixugc@google.com>, "Baoquan He"
 <baoquan.he@linux.dev>, "Baolin Wang" <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka"
 <vbabka@kernel.org>, "Mike Rapoport" <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>, "Kees
 Cook" <kees@kernel.org>, "Peter Zijlstra" <peterz@infradead.org>, "Jann
 Horn" <jannh@google.com>, "Pedro Falcato" <pfalcato@suse.de>, "Hugh
 Dickins" <hughd@google.com>, "Pasha Tatashin" <pasha.tatashin@soleen.com>,
 "Pratyush Yadav" <pratyush@kernel.org>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, "Jan Kara" <jack@suse.cz>, "Lance Yang"
 <lance.yang@linux.dev>, "Rik van Riel" <riel@surriel.com>, "Harry Yoo"
 <harry@kernel.org>, "Alistair Popple" <apopple@nvidia.com>, "Nico Pache"
 <nico.pache@linux.dev>, "Ryan Roberts" <ryan.roberts@arm.com>, "Dev Jain"
 <dev.jain@arm.com>, "Usama Arif" <usama.arif@linux.dev>, "Kiryl Shutsemau"
 <kas@kernel.org>, "Matthew Brost" <matthew.brost@intel.com>, "John Hubbard"
 <jhubbard@nvidia.com>, "Peter Xu" <peterx@redhat.com>, "Will Deacon"
 <will@kernel.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, "Nick
 Piggin" <npiggin@gmail.com>, "Oscar Salvador" <osalvador@suse.de>, "Minchan
 Kim" <minchan@kernel.org>, "Muchun Song" <muchun.song@linux.dev>, "Xu Xin"
 <xu.xin@linux.dev>, "Chengming Zhou" <chengming.zhou@linux.dev>, "Chris Li"
 <chrisl@kernel.org>, "Kemeng Shi" <shikemeng@huaweicloud.com>, "Nhat Pham"
 <nphamcs@gmail.com>, "Youngjun Park" <youngjun.park@lge.com>, "Gregory
 Price" <gourry@gourry.net>, "Joshua Hahn" <joshua.hahnjy@gmail.com>, "Rakie
 Kim" <rakie.kim@sk.com>, "Ying Huang" <ying.huang@linux.alibaba.com>,
 "Jason Gunthorpe" <jgg@ziepe.ca>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.22.0
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-13-6f74bec9a5bb@kernel.org>
In-Reply-To: <20261027-fixes_core-v1-13-6f74bec9a5bb@kernel.org>
X-ClientProxiedBy: YQBPR0101CA0165.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:f::8) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DM6PR12MB4155:EE_
X-MS-Office365-Filtering-Correlation-Id: b30f481d-89b1-45e7-6f53-08df349eca35
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|23010399003|921020|261026140227099003|4143699003|11063799006|10067099003|261026121527099003|261021123027099003|261021121427099003|56012099006|261022105027099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	OZTu+o0W3haK2eOig9g4KGRW9l++E2eJHbYgl7rZhIXF/aiVpg6F0Z2oxR6IAv97PBEuzZIpdj+POd8WGLkFQ74Cl4fSOB1qWj4mm6LEfrxaL3cxzevCaSwGL0EYsJ+M4Uh6c/oSzuRISDiemQmXts4mtUz0JAMa/le8ck5MFVYhSVOdJq9ka9J/fQytd2mxhBMnLzbQjy3iZ18EBx/MZb/NypSyvHJihhgYfrA+an86HP2K6PvDM39qU/mYC4VznaqeMXH5fni5OzkkvrceXNp9a4jdZRS9K+gL9lI9Ot6N5n7fPBk2lM5ipwYABzE6SZ57M0gKtbxMk1hZGca1IhiGsyVH1hP+gRaWFmPBKIu3R2OujSXBmQFKOXaLn9fQG4OMFUQ15BX3cbH+4GgShgsUCYh2GjMg81XSSZPdzyp+f0zuUgG7AY/jmmD8+mnxfwDjyy+Hf6OnBuPESgsFjvyc7kuP0cvuF31JYdHa/GcwGSVjt3I7OMHwsjKzzyOVzu5qG6k1ADVPGjNq4X1x/igXlzSuN6wBbSLcvyFGlNyRd5BjeHk5gZbQRqPewAEyaF4rVukOBQ6XKOD2MHLwqPZZ45zVaCliKF0lhiF1aG/+0bC6no/Or64LTw99mx9by0L0iMoNKNyzUEZ0PQ/GENCL0Qau3V6YDWnkLC3A8hmzGHNXR6Hk93D8jhEq2Up418iFuydH2Xi9DdpWkpPIYQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(23010399003)(921020)(261026140227099003)(4143699003)(11063799006)(10067099003)(261026121527099003)(261021123027099003)(261021121427099003)(56012099006)(261022105027099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?KzVqNmRFQmZSM1RzQVpCcFdjeHN0YkVLL1duWWpSQlZZdjhTNjZsYll4TnZu?=
 =?utf-8?B?ZlIyM2V5U3VueVl0MHRGT0I0VFpDbUc2cEhLMTBYMS9KMER1WHhYUG0xUlla?=
 =?utf-8?B?OUVNRHJ6NHZQYTA0TVgwU1VRS1VuQ252R2dKU1JwK1dhcEJoS2tCc1hoUTh4?=
 =?utf-8?B?eGROMnR2TGQ5eTJMU1hQc25GK2oyL3g3c2NmYm51M3JjTnhLNzZhUCtMV1Uw?=
 =?utf-8?B?L3lKN3p0anN1eG9zTE0vcGJpUnBNamh0WHQ1Z3JuZ2ROK2FWM3F5ZlJxQ0xk?=
 =?utf-8?B?Y1FNdjhMcjVwZUlFVFRESGp2MmtOL3ZoaFgyZGVVLytRNXNIWVEyM1E3L2JY?=
 =?utf-8?B?N2Q2K2daQU1lczZGOHorcHhWV1lnOWNwWXl4Q2hiMGswN2ZqaTNHSEpGT1FE?=
 =?utf-8?B?TGZycGtGSFgwem9jbzd3VFZPOWNRTjVmVGZEZmZTY282ZCtkc09XczFGb2cy?=
 =?utf-8?B?cCtRM3dRUjA5amtKQUFxR2pXQjdJMkszb1BCYlZKcHh1RHRFQ29lVVgrT3Jx?=
 =?utf-8?B?bmN0amptV2ZJMlVvUVFSUnFINTlneWNXNnZNZHNESEs2dEhQMnpsYU9wSDNF?=
 =?utf-8?B?bEZSK3ZhWmI0UXVla2RUaFV5TkRnVFpvcXdLTTA3a3Zldnl3c3UrM0tMUDVQ?=
 =?utf-8?B?bjcwN3FOTUlIYTdqcG1zQ0NLMGlhbEoxUlZDZHNDUkNxQ0VWOVFaZVVMVWFE?=
 =?utf-8?B?UUUrWGVjc2lvQ2dnLyt4UnhyK3I3YU8zdVkwZ3dCdDZKazhLTGF6a1grUlJE?=
 =?utf-8?B?YTJoYU1hcXhCdUhscXc1ZTVUMUlNZ0J5UDIwc21YQ3JMcm0yT1NnUWMybzA5?=
 =?utf-8?B?NC9ZZzhQQ3dmdFRMcWt1NW03akhMMXVkbWZmdTN2WkdqM2hGQk44MUZzQTBN?=
 =?utf-8?B?aGp2ZWgyNS85MlhTQlh6a01wcHdOSWUxOTZwRUVIaWtmeGczRytnek5MamRh?=
 =?utf-8?B?T1dlbWluY2thelBDNm56MzRqZzlkNThkK0JSbUpMdkVsVHJrcytOVTg1T1dO?=
 =?utf-8?B?WS9UYWI4OGlGWmlvcjhxT1k5ckhDNWM0TVZuT0VLNEpRRVpMNEM5MkRENG9p?=
 =?utf-8?B?TThRZ2RQTU9EQWhGdHNuR1ZEbUFpdlVHamZVa0NiM0ErbDMwUUdzK2VteWpF?=
 =?utf-8?B?dlFVK29BbFM3YkdIRW81RjRURmc4WUFoT1ZySlJsTkdUaEpUbkQ5N2lsMkZZ?=
 =?utf-8?B?eTBpbFBJZkNhd3NhREZWZ0szUlFjQ2xtR01DQ0NyVzloek5WRlVGU1QyZ3Fz?=
 =?utf-8?B?VXpHZC9INEZWMjhuZ21UVTc3VjBiZHBHd09lRGNPNm84VXpIV0VvWnBOblBl?=
 =?utf-8?B?WitudU9ma0k2UmV3TGlMRkpna2x2SUZmYVBYdVlpZUprR3E4Y3hRaG8wWFVh?=
 =?utf-8?B?bjIyN0x3d2JBd0NPdG10b3p4aW10eVo1b3RxNWRxM2RhRm5ETkYzUlBITWlE?=
 =?utf-8?B?czVBeU0rNFREWkt3WEVxZlJ1MFZCMm8xYVdQS0dhTWJoM1IwOVFFakIyK3gw?=
 =?utf-8?B?MG5WQ2h5Ym0zZWc4WUJGaXI4Rm1nNFFRQ0tZQXVaY0xYWHEza0F6YXpNS004?=
 =?utf-8?B?MzE0c0dkeFBoZ2xsR3QrVnBTcTY5TGptU3NUS0ZKZld2SktrZkR6Mk1aUFlh?=
 =?utf-8?B?c1Zwa3NjVjRDejFPOFkzakJtQnpuNUtmdGhwL3N3M0k2eVNpYlVrbjJXNU1h?=
 =?utf-8?B?YVc0NkV1RllGOVkxdEk1Q1N3VlduYVZRY0orKzNxaXZRM3c4UFQ5OUNSeks5?=
 =?utf-8?B?b1d2RUxBbFhMYjZuQllNMktsZ3ZuR1Nvc1VYcCtRaFk1a2FBMWpxdlVBREVW?=
 =?utf-8?B?aFJuS2owcUNrT2F0SHVjeUxGSFZuTFdYYVlwampTekFCdWNkUDFFSXpjb2o3?=
 =?utf-8?B?OGlGaW9FMFg1TVVMS3o4byt5S1ZuTlR1QTc5ZXI5bmpDQi80RVEyNzFXbUdy?=
 =?utf-8?B?WHNmbjltZ0Z1cHpjNU0yM3p0WFIwT1dUTUxRUFNqVFlwS3l0R2dIcFRWL2Iz?=
 =?utf-8?B?R25pak1iajdHUEljM1N3Und0UjhJUHVKc01xYkVtVUNmVis0RE9HdFA4aGtE?=
 =?utf-8?B?cjZmNldva0FqUjZScXFsS1RkczdVRVJ5b2hLbzkyUkNjc2RHbzlKbTUzellT?=
 =?utf-8?B?UG9RZW15KzBucEhaTjR0T2lqVjdlUmNpa2ppMkRKdG44Snp0OW5sMVNaWEd3?=
 =?utf-8?B?aEQvV2VuaGUyNXdqYTVrRk1McmRYOUowRGMrY3lQNDlpTmVhRVRvcVh6NGRt?=
 =?utf-8?B?RTF1MWNGaFVpY2JHZWc0eGtldVd1cGhEU0ZCSVV6aEc3VHBnTXh1dHFsM3dM?=
 =?utf-8?Q?xD+nAPcjBeBYePWKBB?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b30f481d-89b1-45e7-6f53-08df349eca35
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2026 02:54:31.3406
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Pv7vMDR3pr9wb3UChXTf5DyTKBW056riedEYYsKtyJgQKJ2LCPD1OkojT61SltU9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4155
X-Rspamd-Queue-Id: 986A140002
X-Stat-Signature: tub5q61fbs3dnu98m5hpyw484oqb7i4k
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793156084-345293
X-HE-Meta: U2FsdGVkX1+K4Ldqus2+aeMBVHdczeJQ9NrBOQIJlZEEtAlEGqbnwBID9xKK6P2dDitIOJNyOWU3VZ0XIyLE83XAgzgcfkrs/Dqc4RpYEJt+XGoumbh46ry4Zk4nMjSzYlu7ZjguvqZHr250fISy+Hp826P4WPFaDaDLN26VLdHipjA9oR2fAPr3Yn92cGeT9SSTkY7FW+z9zXXH9tbWtOkl9smEfLA7O7JRxUDZ8R6HVQVSFQSUZhJdTot0hUgXKAH1kBQhdVcdEKW6l1bonZxq6OAPbEErg+7o+9tN35sAf+5Bxp+4k1fgh3UAXC/zASxTje6d1iRz3vWPB0FyXFif6KIbCkYTx2EiOSn+a/4IbqagIiKBSu8PRcGbx8Mm9B5Ua2cq15O7vhXmidYTz/B3RsjBbMEBvX516M7qO3eC1D2MVXHtOPh6Lv5m0LO3hpWMeC+5qh0tZ16r15Nmy8bAIvPySj71Bx4+HfTwZ7pnASK7M0sw9eAEYibkZ/s9NgpySDjhQOe6kQ4GqM+9E1xT0C64jcoVlwaHDP8aAgVQ3pud5/25LLJESVYsP6hoe50pQsxRTespP2/6+Ys4WZz6YVwua+iSoKQd+weVW3puFDSlzO8Ldnj9A60ng4AH2l/Rzb5y5Gm6dESXgWyLKgBvyOUuAHeQsqqjGikH9W2DUwpo8XGv70Cm1nbq4in6J0DpnnfNAmfvVxAUnt12wVZRmGp8zSsjsD1svKaugUzOcYmYPzTxCG7Gc2CBf0/z5pC9jJyNcgPyMMVepHExyazuX5TcyWr4qriDICyNZELOY5/nfgW8MBiYPppWwUZj5QrKoNA1NmCtslZKmwnMlgp4p9qJp3MXiyl7U+eyw4igsu54VbFNffftnMH3R4hdmpowj8YlFjMsZWQgTRO8Ud6gmRtolE7sWTc5KNiHf1OorTd5W4ARfTx+uX226BTGYhDdZXk6q84TTmbpLAv
 wdC9P/rC
 snezxK0/DhFN+hTV46GVTfEFU2vvcErJ6rB3rkvr7viCT6MiAT8vPE1PvzI5jpkVjOACaQ2q2UYlviuxZ6QSFnFaCAvD43tjNccgpR9T6vJmMAzlAhFAvuUzhdwMGbdWrIsCRNoVx/vEcZrtuQlusDhXbaSQWDernIU+9iq3gxL1A0tNjPqX+ac4fhfmpiQ70eIql4FpbFYWrSbqJ1U8NMlhuZ+cr+0WoKkBL5AQZC1T7pNU7d3/5M/TjAEFRcCnXC0+HnKK8silgxr6Mif/fBoeQgOunjB/tNlJLh9rrFNQB/Hqs0gdAa4suK3EjvbV4qSdWTJaorXdNMEe9NKvUxCokT5c4rmeTLlv/ioEyE0xaLH5XAEmMgF8Ew6/iBzC3pbhwUYNb3gjZEl/UG8RjeLDykstiN33x6teE9GkNkWybULkum7cO82YyU8BizD6P/s768mTlboi2OIiqfBObK9+x5R+S8epWJy45QWps7/0Yw759XrVX845JeZ1EGrln3ho9+bneLL6YaX6ZjN+EjfhsetRAkpmAooK/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon Oct 26, 2026 at 7:17 PM EDT, David Hildenbrand (Arm) wrote:
> From: Chris Mason <mason@kernel.org>
>
> zap_huge_pmd_folio() removes the rmap before calling folio_mark_dirty().
> If this was the last mapping, truncation can skip unmapping the folio
> and proceed without waiting for the PMD lock, racing with dirtying.
>
> ifs_set_range_dirty() can oops if MADV_DONTNEED races with
> ftruncate() on XFS, when we get the folio set dirty after it was found
> to not be mapped anymore.
>
> Move folio_mark_dirty() and folio_mark_accessed() before rmap removal,
> matching the PTE zap path. This keeps the folio mapped while updating
> its state, so truncation must wait for the page table lock.
>
> Fix generated by an LLM and sent by Chris Mason in private.
>
> Fixes: fe6cf984939d ("mm/huge_memory: transfer the pmd dirty bit to the f=
olio on zap")
> Cc: stable@vger.kernel.org
> Signed-off-by: Chris Mason <mason@kernel.org>
> [ david: simplify comment and description ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  mm/huge_memory.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
>

It seems to me that moving the rmap removal code after folio_mark_*()
matches zap_present_folio_ptes() closer. Feel free to use it or ignore
it.

Anyway,

Reviewed-by: Zi Yan <ziy@nvidia.com>


diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index bd44d58e86845..192f7969e3648 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2484,10 +2484,6 @@ static void zap_huge_pmd_folio(struct mm_struct *mm,=
 struct vm_area_struct *vma,
 {
 	const bool is_device_private =3D folio_is_device_private(folio);
=20
-	/* Present and device private folios are rmappable. */
-	if (is_present || is_device_private)
-		folio_remove_rmap_pmd(folio, &folio->page, vma);
-
 	if (folio_test_anon(folio)) {
 		add_mm_counter(mm, MM_ANONPAGES, -HPAGE_PMD_NR);
 	} else {
@@ -2501,6 +2497,13 @@ static void zap_huge_pmd_folio(struct mm_struct *mm,=
 struct vm_area_struct *vma,
 			folio_mark_accessed(folio);
 	}
=20
+	/*
+	 * Present and device private folios are rmappable. Only remove the rmap
+	 * after transferring young+dirty to the folio.
+	 */
+	if (is_present || is_device_private)
+		folio_remove_rmap_pmd(folio, &folio->page, vma);
+
 	/* Device private folios are pinned. */
 	if (is_device_private)
 		folio_put(folio);


--=20
Best Regards,
Yan, Zi


