Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8812E606A32A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 02:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=HZUJT375
Received: by kanga.kvack.org (Postfix)
	id 9038A6B0959; Tue, 27 Oct 2026 22:58:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B42D6B095B; Tue, 27 Oct 2026 22:58:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77C856B095C; Tue, 27 Oct 2026 22:58:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 56E966B0959
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 22:58:47 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D141A120BEE
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 02:58:46 +0000 (UTC)
X-FDA: 85370527452.21.E69EEAD
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010039.outbound.protection.outlook.com [52.101.201.39])
	by imf26.hostedemail.com (Postfix) with ESMTP id DBCB2140004
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 02:58:43 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=HZUJT375;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.39 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793156324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=70+ae3ZTqtj1+07muayYl3ANIB+dyOWYDBZ5+RJCHYs=;
	b=rkapV9P/1bw6iWsSQ4cbtGU8NDEvAP5I9BgPUaVj11trVCT3n/doK/CFopaGgCWnwD02TI
	Gvvj1zluMQTJ3F0VJ+T5PfaJrEvjRBRicT3Pr0mBP6gxkY8tkmYePZxxoC/QeNpOaDtd0W
	TGyibQbjYPcMmCYhwh35BHPs7aFia3E=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=HZUJT375;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.39 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793156324;
	b=5rcH+ZnBcpf63khTPwvMe5vJXADE7mj1ZHbC5SnDCQGJjEZUGP4Blm6Helx8BjWMAlzfIX
	+oxzDIW9TAuVtSAaXEzLuJVZPr8RWt/o31a7AIv6kD6SfYL1pRo+n/yZbOJj1Hs2Ez3K8G
	tfW7EN4718/hlD/cJGtoW+1oPCX9BVY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LxkpL9B2OJrBuU388imPmmPuuXNOqaciLWhgvSkeDv3iNPSeTaDwKTXLYYTbchoQZfIFjaXnJL17JT9+tyRzyM1WBmHv5swwyidIUWtPuvu4P2cJkhqcfNHvKNlGT/DNQZbKfaj/SQMP+DDriUh0Nid4fP3Rthn8ccoqUIq+bbD6IBgQJaO/evVbe1HZgPu6I1dZofSrkJqCo+JFD97uEyjSzSdsatAhelh4Qqe6TZwWaGy/ECJxwqG9oNd5K995HJ5YGvhG/EKngGH7P4OY8HKWW5virxa0UMQwiCFs8n/KCZc/k5ku6sxV0k0ZChHfAT0hcit/0ZbEh58DKJ2+EA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=70+ae3ZTqtj1+07muayYl3ANIB+dyOWYDBZ5+RJCHYs=;
 b=NwFAtlQ1KDLnYi/zSlcDXnvGiVhKnp8KwAHvV/QGayYFh102vSmQWqQ5V8Les5u0L90hJqhNHgCUGYwAwSPyIKV0xwWmZyI0jxRMbBr0qcjMy8o85B5EDdjXA9Phsb9Ipw5YIpg8V4UIeM4QeteQMqVNjLUXJkDODXLTkPg2zlPPvstr9bqwL64XDT2orEa8hOWco7op7ASdzvFFY/OgvPcMncJmOAnWH6lOacWYSIcq3hvZ7SrtGBQdBpuSSDxPji5PunB18b3WRzUL/QaWJ2+WjkUhmprED7QrGlJ6O5KZkhFEY5w59F2xdMzyHJ7j9tO10Ny7gtnPK2jdSujGUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=70+ae3ZTqtj1+07muayYl3ANIB+dyOWYDBZ5+RJCHYs=;
 b=HZUJT375SpdVAF7Sp9FPnfiCDV9dEWNoMq3y8My/RrO/kwzjh2ji0fwylBheC/blH4oLA+2wqy+58cOL4nIsJVR9UEyFQq5vf6qozzyO2BoA8WtX21lNXE+4GYMTULUlw+NEUFliTdIMqY2cAQQ1DsdQLaZoYvAKBX4ya9ZE7hsCLv43lUXOIbbJaC8+rG3/uurvPM7gwnwxu1O4qtUK6hxAuJnFvO9l0WwCGywcP9h/0VIdK5mXoPl0f5qvkNNXW0Qi3ea+Mt6Lm/aqVC0IamDWgd4K1gmnyB4z5XkCxiP5gcBSG8ORfvaPAT0Aue2tJ6clppftcFmEkAMGrdzH7Q==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DM6PR12MB4155.namprd12.prod.outlook.com (2603:10b6:5:221::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Wed, 28 Oct
 2026 02:58:32 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0546.021; Wed, 28 Oct 2026
 02:58:32 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 27 Oct 2026 22:58:30 -0400
Message-Id: <DMG4V0W8WUGW.31QWJYW2A4Q1X@nvidia.com>
Subject: Re: [PATCH 14/46] mm/huge_memory: fix zapping migration entries for
 device-private THPs
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
 <20261027-fixes_core-v1-14-6f74bec9a5bb@kernel.org>
In-Reply-To: <20261027-fixes_core-v1-14-6f74bec9a5bb@kernel.org>
X-ClientProxiedBy: MN0PR03CA0023.namprd03.prod.outlook.com
 (2603:10b6:208:52f::22) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DM6PR12MB4155:EE_
X-MS-Office365-Filtering-Correlation-Id: c6663443-d9fc-4b67-c97e-08df349f59d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|23010399003|921020|4143699003|11063799006|10067099003|261026121527099003|261021123027099003|261021121427099003|261022075727099003|261009223027099003|56012099006|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	xESxOB2XQxZz/eM+nB9DvC/xPJefH+YtO7mibdKFnWCiTzc2jXvn/RrXUhWKk7YkvKBv06z8gHfovoel6XKsmpWOEdEwb0UrROjujvQ/36I4FeWcSBcsqj0KAjhvQ3mrRim8tWT9ZzzyZc7Dc+bwq/2w9VN4gItpSFCq5YYeDrTxZ37LnFO6ZATeXSzdVTn47DGRPK5MY7/Y14uyHIXMzzotLdd5Lxf67JnBDZL/eMAMoQ5Nfv9jZnaW8SK6lhSBvSluPzHuub5AqwrzduXrLfbqE1oLCGlK9wKeKSfIdxcfczfxGA+2z1Et1e+iZmPR5Y0/q2cYl9yU7iDBLoxdYb/eUHCTU3DnqVbm9vBbgGBz+cr5fH+It4TojB0UbDQtXBdXEyrTbVPVim2HllR+YIgRbwCa0pnn3mBBGwzx7E0qscciqKpubpmMpTOqd7dpUCeFq/2NMIPBRLmzhtbPWFu8vMajN+Q1yso0HPbGhp4gTd5GeYFrbzdgBGBst5ohR5G2TQ7eGy8qKU0/9KMwYFW9oP3hb+PrY7yxdC2vrO0gC7jBxMVmnnkdGlwpKBQLY9f4Lbx623EQJTG3I+Ft1ux5soCVirMsgTIB/UIIGg6qLragBMN+vXi1Ma5S0WwhgX5EheX1VEJ52R2cveEC+Bv6nLpGX/ZpJdYdMYfYIqAJWMCsk80I5dJFyOL5sovxMIYe3IO6Mt/xmAKamJAFSA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(23010399003)(921020)(4143699003)(11063799006)(10067099003)(261026121527099003)(261021123027099003)(261021121427099003)(261022075727099003)(261009223027099003)(56012099006)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RHp3NHVXOEJvNVFaemhtQjgybDFNdVFPbVRNNytmTGE3MHJaQzgwbzBnY2Jy?=
 =?utf-8?B?NllmZmU5NFIzV0xhZEdZSm9Ibi9aeTM4OFMrMC9FVHJXVnE2NWsrMTJoeERX?=
 =?utf-8?B?MTdJNW1qRzdnVXhER3lOd05LcW1ydEllKzUxSzVWcnlSdzVidEdhYm9nMEFR?=
 =?utf-8?B?OWx0NVArYWY3alE0SCtMYlRROTRiTEZJM3Y5RUF2b2ZtVkVQL092UWtzNHA3?=
 =?utf-8?B?Vm9GY2RHZUtweFpMMXNjMWtmczNrZzllMXExSlVBUjFXODRLTlNpVy9EMnlH?=
 =?utf-8?B?bXJOSUgxR25mb24zaVBIenF6TzYvZzlIdDlPVHhZTkQvWTdQMm1xSFF0Q2Ex?=
 =?utf-8?B?K0ZjODE0Qnk2MjlJOVdTMk5wcUhLNStWenNUL3hscnNSekdXeksxTVlmSmxu?=
 =?utf-8?B?WGZsUTQ1MjJDQVNieHY0cENkWk5ZaXB5amZNMGh4OEFPS3FscWMrcStWdjdZ?=
 =?utf-8?B?OXltdTZtVm9BQThWV21CL2crY2JydUptN21XMUdkckp3Zld6eWc0eVNLUnlx?=
 =?utf-8?B?L3JpT3hTTmJjYmdkWURhNEQ4cDYxZE1nMWhYdnpYK0EzbGJxdkdNeHNUcDhm?=
 =?utf-8?B?Zk5xVVFUVFFFbjdQV01OdVhUU2xRbzNTY3IwdVlFZE1HVjBROUxiWXdqVWpp?=
 =?utf-8?B?WWlxWEIrSXZvU2dSZnlFWTNlR1g3OUtNdUZ5ZVByV21iWXpqVnlLc3hOWkRM?=
 =?utf-8?B?Q0JvWDU1cUZIMTVZNXduME5SYkNEUXdiY25EVmFMZk5wOEVUMFpoaWQvVDBi?=
 =?utf-8?B?eWxzWmF2RytoZ1NVbTBVUHBCWHI0THdKVmFCb2Zkdy9Ic0laZXdVdVBxK3hF?=
 =?utf-8?B?aFdEVTloMXcrM3EvYUgxbDNlU0RIaDZZT3lndWR2Y25DQnVweWpEczRpbW1R?=
 =?utf-8?B?YVVlckZkcTJLdmtnbnJlWklSdVZ6bFNULzhPdEdYaWhlaWxOZ3daMXpSWEJD?=
 =?utf-8?B?ZW54UUdPVExPK0w3Q3FpTGF4UmV3cW9wUWVxckFaRTFXYkU0TzhXWkx3akR3?=
 =?utf-8?B?OWlTVytINFMwTlZld3ZiT3hMT0F0UHN0bHlkQS9PVWViTGNDR1NPeVVVMlJ1?=
 =?utf-8?B?RjB0SUNMMTVMK2lRNS9BajRDQlEvcm93djBkZ3VicUM1QnJZV2ZBTU42TUZ1?=
 =?utf-8?B?aW1DS1d2dlR6RGhidEIzdzFlVnlWaXhncDJZczFzTlE4RVZRN3hPQ1hia1Ro?=
 =?utf-8?B?RFBwNm5jcSthdFk1bVZTWmxtMFlLR0lkU0FXZytROVN0Y0toTysyUEtGOHJm?=
 =?utf-8?B?eEM0MUF5TU5ub2RwVUF6SHRFS2VoaWhPc093QnViRTVpS0pOdFBLcHRWSmlC?=
 =?utf-8?B?L3JFYmJ1Q1ArRkpZUDY1V21XMkQwMm9vZVNibW1TMnBhaXN1LzJXWjRnTjds?=
 =?utf-8?B?YzFoSlAvWjFnMnlvbmxPa2lGWEtOVlp3S1lKVGtYbEZhMDZvT0xJNi9DTTRE?=
 =?utf-8?B?UlB6K1hnSDJuNUc5bC90UExCMDRDT3hORTFJMG9IMnViSldLTm85dmNCdWFs?=
 =?utf-8?B?WmkyZWt2cGp4WUZQL0NUOUNqR015Rk05TkhQZ2ZvdDkzemY4UFNGNzhXd0tu?=
 =?utf-8?B?ZzA4V3gzem1TMmhxY2U1cDVvbGc5R002QzZrWnJsYkVZUjV3QWkyU3RIc1pq?=
 =?utf-8?B?Z3FVWlNrd1E1WmRtUzE0L2toUXFiam52Zy9YOU1HeEU2OFhtVDlSK0hMSWEr?=
 =?utf-8?B?UDB1bHlZcTR4SVRENjVTMHorNXhNanNjWDd4OE1UckFSeFJ0QnFYWFdWOXUw?=
 =?utf-8?B?Unl2RHJ3a3p3cncwOXRMejNFQ1k5bHl0dGZ0T2lvUExjQUY0Ny9iRUJCU21a?=
 =?utf-8?B?ZUgzL2NOUWRzYzVLYk5uZHhxa1VkOGJIUVc5WWtncFBES0ZrKzZORngzOUJB?=
 =?utf-8?B?T3I2M3d2d2lGSEs1SmhYVkwzV2dJSSsxekFRcGNhSWp0WWZLSmpSdWN3VVFp?=
 =?utf-8?B?RjhDei9EbG9FQ3AvVnFoQXRYOHRJTFFyeWl4c3UvRTk4dm9CTEJHOTN0b3lq?=
 =?utf-8?B?a0d5SE5sNkVrNjVFYzA3bm14c1ZQd3dGeFlLcmNZaUs5ZDZCNkR5UlVZdXJi?=
 =?utf-8?B?enhZd3huZVo4b0JUaFVBcGMySmw2eldzZnpFOGQvMmpyNmxSMk1jaC9MVXB2?=
 =?utf-8?B?UVBibW04OTNwSnRRSVpVSkIzRTdFcVAzZk9rNXVuOUdKVFpOOWIrdWhhODhr?=
 =?utf-8?B?ZXZMRlJ1TE1nZnU4azJocFM1cHZYeDdYTlFINW8yKy9TK2ZsRkJqcUZBeG5N?=
 =?utf-8?B?UkZRc0hONlJDRDFlN3RHZEFXS1NhWW83NmxXamhDL1BDRGk4Ym55VkFucmFP?=
 =?utf-8?Q?K2a7+abisiieuFtvEq?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6663443-d9fc-4b67-c97e-08df349f59d5
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2026 02:58:32.2679
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wk1su8W9IPs55MRRIgbk0V82MMl9tHWF7iAM3t5q1yKThc1ixgS5czsHLTkO5VY5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4155
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DBCB2140004
X-Stat-Signature: x7boboraqqhp11q7bwdthmhqgg1idskk
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793156323-276642
X-HE-Meta: U2FsdGVkX19PCeaOPQvnKil0zhlGq+kbxnmsPZCJsxXNiYTe/9zXyYFvleEpxDujaHAwcdvSWA7T6R4t0cY3Hvc3UuWobWRp+StCIucFLxNhkqqZxJc8haC1P7A90Q5cRB/dvP2Rf2T5Cihl4objqN3V5tP57JR/8cbXtLHYa8uy/ulWgUGF5NnwYZ2viRVxo32U1n31Hh9LHGo8Z9IKSsHVZl0j54jBs49r6o5zlryVLyX1g4kTKt12wAqe11leSeLViCr8WmxH36oZWIdY4U9GseIQkEvXw1U7/nX8DzCp6M8ZsZNumQpGDmBJbt5YtdDZrbkr2DHbTf63nrPyArslItf9ygh5zxlMlYqewk1CUVPtDNwQBahMpbI/0q6rn5vbOQMUU+pHsjjDTOdLPyqvLXkKMwpnGQa3NIWa9I7RTmCHkr98xpLUHPg57O0h8KTc/VHUKiCyM+xdLJyZypb6SCbYcqgUKK4CRS3Z50tIHr/He7b3jZL6Nc+JtgOOFfxvnbtSsk8pFS65uAPH4VW/eHEQiIFn/IJYWP16eoac/XuuRnQkYoiFE1PitT5Gc+2GNeCgZvkGmr/o6/wArF9Fqq1dcnYIHh2aSTS1R4PFpqe3sE+hbFWShzK7lnGtkt55KJe9q0UvHk1/3dI/mLdJ/h0mCY8IndOeyUea8UbXh1r3/4ItwL0trSi0gpsFesh4NYvZSkNHqloVREO3/gWTy2okeu8dbOwcOqFHw47aYh1/ETgsuncJM8S26uQ6s3V2TsqcdBH06aXvwrfrKAaFlYBCbxOTgd/ikNB5CqAqN/pNkzBSmh8//cfd356fT+8AJPOJtUVX8ArptEsaEMpK4SV4i7IDKOzr5VvrY+9cTOu/EMEAAVMy6oIm4hHacPZ8YBtc6K+C3mwMNrLDU1uOQHCCU+VabSzuGNDeXeZ3anoorWv4z7co6PpZ/WYPkoCHbzyVtEOmLw/jmHr
 NjZz36C4
 DL8Zu/85phUoglrSQnOhUDgZ5EmIvBqitrxyrSAN7qkBJhpkeZIl/tIEAMfK9up+KdjSNBQhNt6tkNd5AKViSzh97gctW/FLzHaxDbKm/Tvov68aAGpGZ1CJTTw2VSVvSV45DbGKsug/j50pA7kn69r89UK9PvP7RMRxMrLz3IBdeRaO8fNQxXuCuAzLu3jay2MSi7TDxUxOjvsCZ1lhMDlK1tkLCv8c6+V7qNB6yOzPO23nTrtUM6fDcbn2hdPCyOlhDAvAnzSwhoojaEebIT5pS8WAjXXA30HsbETNCDg1nNF8zmX59xwm/554+H6ncMCAzik3KAMl2kucIW1mZe4wjK+1U2aHdOVPGrc81DcjqGxXgCCBv3nj5+TmqOcTww0OWHVtXfBb6f2M7aNc9YY7obw1RQ/0XYEVs9xinEOzmvS+xhPq/L736+O2BJ6GB05co2Rg6fJo8JrrLSg2F5Wnzd14SVfWlZyvjZQJgfkKvvKd3Qx5cJ27Lepx9pL1al58/vFaGEvRJA7mrAsHM3gnY5CixjT6xy+Aw
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
> A PMD migration entry can refer to a device-private folio.

Right, set_pmd_migration_entry() does that when a device private folio
is migrated back to system memory.

> zap_huge_pmd_folio() checks the folio type instead of the entry type,
> so it treats such a migration entry as a device-private entry.
>
> Installing the migration entry already removed the reverse mapping and
> dropped the mapping reference. Zapping it must not repeat those
> operations. Concurrent MADV_DONTNEED during migration back to system
> memory can trigger this.
>
> Check the PMD entry type using pmd_is_device_private_entry().
>
> Fix generated by an LLM and sent by Chris Mason in private.
>
> Fixes: 368076f52ebe ("mm/huge_memory: add device-private THP support to P=
MD operations")
> Cc: stable@vger.kernel.org
> Signed-off-by: Chris Mason <mason@kernel.org>
> [ david: simplify description ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  mm/huge_memory.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>

Reviewed-by: Zi Yan <ziy@nvidia.com>


--=20
Best Regards,
Yan, Zi


