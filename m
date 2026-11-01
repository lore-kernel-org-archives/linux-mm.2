Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6485F606A32C
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 02:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=LSMsEcAv
Received: by kanga.kvack.org (Postfix)
	id BFFDB6B05C6; Sat, 31 Oct 2026 22:16:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB0F46B05C7; Sat, 31 Oct 2026 22:16:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A79676B05C8; Sat, 31 Oct 2026 22:16:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6ECD76B05C6
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 22:16:09 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D25B7120853
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 02:16:08 +0000 (UTC)
X-FDA: 85384935216.14.3B7089C
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013009.outbound.protection.outlook.com [40.93.201.9])
	by imf11.hostedemail.com (Postfix) with ESMTP id DAF6340002
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 02:16:05 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=LSMsEcAv;
	spf=pass (imf11.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.9 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793499366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PHY3op/sKzJI/D92BGtbGPemOoqlJ+m5Lb2J/nUsLbQ=;
	b=ydG7XRyb60zjoYErLwsIGwv6NN+qiA4yVmv3Cp4CIEYcMH7/KTPkYbSNf5XHrEmoy4zD49
	wAURNw4lV2fqKwNH4kWMlxS9nvbuLG7qy/5tighMqpht4ASMt750KMk5TUdysF6DM5ZxQF
	FCkLeSRN9Cs+Y1rSzcS02y3ieJHpAV4=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793499366;
	b=GjJmiRORvKWqjmNQiMPd+cWEQ3MsMzfjeUqNKkd90azUf00rbGPRd80IcRqkCjI+t4MSO8
	ObQVtZ/6xmFvOtvkrF7HyhO/CTvLtodiv9A1QJd8F79RTag8zqHLs+mZE7JwPCEA4Qbt8k
	qw8A91/trYETYmVzy6py9H6djUGBegk=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=LSMsEcAv;
	spf=pass (imf11.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.9 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ACUVy+oFP/C6zQvclMvHH/CSR7HqPdSiyY8AyduaT6sfRzWQDNRvvF+2Ci1ZA1u34EJFjPoOx2A3+NPmJ+DNSVuPvCTAyfZ2A/PfQdtR/oOPcCOJ/uMSojDdjOPjIrJf/152eIv0zeYAvavWi6eE0mbziTzrRGRF6BMZqNtOYeDkSUIQIQr8c+sbZOjdgEGubGAsgibsJY/hdtPpSOzLZXzuPQbghllltJPWrejsdhyZ/hJm2wAooz2HcL7H7CdLGYs6t1YHmlITwGzAuvDGOYGLglNXfnt8QwCWvFmFH5ke2/gXt2w77wjLvZOMiifqnTQWAn7AuaIRwTecHC9QLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PHY3op/sKzJI/D92BGtbGPemOoqlJ+m5Lb2J/nUsLbQ=;
 b=hP5+phphrKcckZeICUMUVXvncomX5mwra2a1ddfH1mrx24ZX90LdxW9YvP0O10CQjjfD8q1e8ZnZfjMqiQPwxMYkkqj9Lq6rIKhuWg9GAzQFHja1u2RjZyAn3LiADZYaimfzNWK6qDDTtyuZDPD3NS2Oa/soyxzboSmawtoql+sF6srsAq1eQ50MxoBeqWSmlSZyJjX2O6M5ods+YUCuYY8U6ZCdUXmI0X2P/ZAffD4uXx0yBavbQsjxRqKLx2mjFtr32MHq2Ubnbbxc8p+QE21Hl1z9p9YwjhbLUxMgPAZkUMxxMx7nKwRHcJ9g6/xkNqWijolks7LQ9ZKlGKICSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PHY3op/sKzJI/D92BGtbGPemOoqlJ+m5Lb2J/nUsLbQ=;
 b=LSMsEcAv7QTgAvpQ9OITBQ51o4dYMFqxOsxqlJeEJVCfabzPvTiDF1keot75WkBxTKwEKh0s6v053nY25FjSsau0dB1pk6LJxYjJFYOaRrhV4iK6FV2Ogeuv+FPhipHMcoetRSKhqESEJNTowY2F4oeAJuAGmN82pEgAIFm6tkmak9YewZUiVjNsL0U10OpAJqSx62ILOVXXw1m/Ddw9KN1IVYDVQcXQSQr/l2GOX7WVCUMMNmjfYqWs8RpzNvghoLrUxgrqhkQQbs/4cLUT0/RPHxJNZ29rFh1AsaGToNPa4Fpg3Ka8hcWnqrP6/6p9lm6t+v8zNk4KeOykQkYO3w==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by LV9PR12MB9760.namprd12.prod.outlook.com (2603:10b6:408:2f0::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.11; Sun, 1 Nov
 2026 02:16:00 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0569.010; Sun, 1 Nov 2026
 02:16:00 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 31 Oct 2026 22:15:58 -0400
Message-Id: <DMJIGN2WK8BB.12X03XDR3OBW5@nvidia.com>
Subject: Re: [PATCH v3 14/47] mm/huge_memory: fix zapping migration entries
 for device-private THPs
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
References: <20261031-fixes_core-v3-0-d6437171ecc3@kernel.org>
 <20261031-fixes_core-v3-14-d6437171ecc3@kernel.org>
In-Reply-To: <20261031-fixes_core-v3-14-d6437171ecc3@kernel.org>
X-ClientProxiedBy: BLAPR03CA0063.namprd03.prod.outlook.com
 (2603:10b6:208:329::8) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|LV9PR12MB9760:EE_
X-MS-Office365-Filtering-Correlation-Id: 28bb9fcf-8461-4ff8-ad3c-08df37be1279
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|6133799003|10067099003|22082099003|18002099003|921020|56012099006|11063799006|4143699003|261021121427099003|261021123027099003|261026121527099003|261022075727099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	VglyTav8uaooeWz2s4fu3BqWDegcxZJOsqy6SVKPjwK4kTcF8XCzyFF/lXguG3GSXiW0QvbeTQDO+PYUHm2qzrJUfFoV5/HyHY03WfNgaWttu7pJYolBtaCONWKB816k03SPL9ZyqVJFUsiM7SmSjB/i6Ka73NwohbEfqUx2hosjS+4UUiVR58UC0mcTX41ExNXeJP3QlZljdM647IwQOnzPsaO5wKAw+TkX1AFStgf30gEYdl74qkwn69OXSvOgziXsLYi9ZriJGKzZtgay8Lmj9DHhTrYQbFEKVgYQvlbZITcmbdKKKD2goplZOjXH8+Go5IZahyJ/k4K8Z1QVFGps55UhNQyM6Em41wLrby9grdzi0XLdujQVCpgMr3okCXYvm67RIz/3HyiqumBq0JDCi5XjohLjM0kI9riHfqFNWfey+PAIy/XTAYdHCFaHKYAAy4Ue6HYF4G38yx/OvtvKGT7IhYJ2gUGr+KofD5osQq6BLLd0l3/tX72BBbF+NamNWOKXyrF1ZeL6kc3TdYVNmBaAK0UFHo0d4OezgSm69C+H13Cb9WO2/AwwqNqDZIxV2ZOIJhnAPhIXRY/YiJvA023O0qnP83hbmIwaRLbwikZHWR3K0UCPAUSp3OG162QK2KZayGWqTj++Gtuw90ag82ZYSEWB2oaSUCmJ4rh7dKOmMNKd6Of4du74MAhZFb6X+cCrCsCafhysygaz0A==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(6133799003)(10067099003)(22082099003)(18002099003)(921020)(56012099006)(11063799006)(4143699003)(261021121427099003)(261021123027099003)(261026121527099003)(261022075727099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?T2N4U09saCtKR3RqK0p1ZXpFTkdLdWpKbWRFVzFsR0QvVHhsVEVzZGtMcmNC?=
 =?utf-8?B?MEliL0c4ZmxXMlpSelZxMzBkTDNhbzExUWtOeWVpVURhUlpwUE05N0ZOUmNy?=
 =?utf-8?B?d2orbGxlaTlBMUd4YlNkL3BOQ09aK0ZiSHZlZ0VkQ1JzdUxURE1Jd1IvRHpl?=
 =?utf-8?B?dVczZ1c0aldhcjU3OHVKdnJZVDc3b3d3aTRpVmEwRjNVNXkyRGpoV1Fua2s0?=
 =?utf-8?B?aVBCbGQzMy9icGVVMEUrQnQ3dW5MYWxqN2FwdDY2aHJlajRZS2kySGNYL1FW?=
 =?utf-8?B?dGgyYTI0ajRyN1FEK04xQzBnTjFDUWdxSnpsYmhGRXM0MEZlMCs2cU9tcGgz?=
 =?utf-8?B?TURhL2NpQlRyV2RNSWlMdmE3ZVNyL3hRMkFFcHBMK0VSNlNlS3RkQlNja0Jl?=
 =?utf-8?B?VFdFY09xLzdZVlVQSDF1OVo5YnQvcG15bXBMRVlHKzNwbXNSamozeVc4SGM5?=
 =?utf-8?B?WXE1eVJXNUU4QjFid05od3p3MStnT3ZDd1RsUmtGU2kwTit3R05BcWc1Rk8r?=
 =?utf-8?B?U0hVMGEwWFRQUVRrQTFGWFNuaVF1S2tmN25NdS9xR0pZclNaNmhNS011ck9z?=
 =?utf-8?B?TXgxWlJiZzBWSTY3VGUxOE5sNVY0cHR6TFZTQVl1L3FJMFY0SzN2K012N3Az?=
 =?utf-8?B?ZzV4RzlpV05HMjNWZWt1QnZhRTdIdUMzbnZPNWpkTVlkV2V6a0E4UGJiY0k5?=
 =?utf-8?B?Unp0aVFrVjF6c2ZWSWw0WDFCUWl1MEFmNVFuSThKMjBXWG1jZlV4NXNvZ3h6?=
 =?utf-8?B?c0dKSExZVndiRWRubGNoSVhPcCs2R2hYcEZJNVFKeG1nNTBUWWZhUys5TG94?=
 =?utf-8?B?Unh1WWF1UzlwNEVpVGVMSWp0MHZDR3JoZEdCVk55S3hLRE03N0JFTmRSQXNT?=
 =?utf-8?B?UVROaHIzMW5pK3lLQlA0djM0aEliZkd4cTFROEkwdnA4QkZTUEdWRGRXRzlT?=
 =?utf-8?B?SlE5Zm1kQ21UMGdVYjBoYUFxdmVHMDBBT3BROWdBeXd3N3ltajZUR2VUUFhG?=
 =?utf-8?B?V1dqRDE3OHlvMjdDWW1kU09ydW5wSHBVeUtSWWtmY2xvT3U4MDlqSmZiL2Fn?=
 =?utf-8?B?bkRkT2lOWlpkaVdTNjFxdHFzVUhtNDV6dmIvMnoyajlwVVpSMW9QNXRvMXNE?=
 =?utf-8?B?Z0VQc3NEcGEvZzZvenB3MjlYL09uNDM3QlNEQlg2ZkxUM1RSRnJDZXpWdzla?=
 =?utf-8?B?aFV4eFhrYXdxWUFFcHlZa29oZFdPUE96TkZvODIvdHJoQ2s3UVdVbzdBSVdI?=
 =?utf-8?B?WnFzdTVLYlpRV3VvbjloOEN3REp3NzA4eW5SaDdvUGtydnBram1vUThnRmlN?=
 =?utf-8?B?SHBIa2djUVY5bjNnQU5jcFlQYWlQQStEb1IxMWg4YkN6TThsWW9FQkkrV1pl?=
 =?utf-8?B?blZ6dmc1MU5nZVNGbVh5dXh6N0h5eGRBVUlTdjYwRjlJQy9SZC94MDIrTHU2?=
 =?utf-8?B?OStsZURQNjV6clFEVEIreTlMaU5xTS8vSFB6bC9iUkxZYi9aN1dGejE3Nmd4?=
 =?utf-8?B?YndlaUk0ZGxCY1hoRXNscGQrME5ZZDJBVW4xcWVSaWZDK3laZEZsTHZsOHFv?=
 =?utf-8?B?eURCMHlCSWgyNmVIZ0NwelNMalJEQjIwK0ZkWG1xenZqelRXVHVJRVNIMWMz?=
 =?utf-8?B?bS90UTFYY0RHbDR1dldxZFBhUXhxNVN6MXdESW9KaDgyd1FRcmg1bXpOUDNx?=
 =?utf-8?B?Z3ZzN3pmWENsQnNCQmtobmV1aUtWNW8xZWJ6ZnpWeWpZakdOU2VMVDhUZ3dq?=
 =?utf-8?B?eXg0NU1ONHFSbisrYjYra0pHa3g4cVkrd2VIUkNGblZ5bVIrdkt4NjZOWXRI?=
 =?utf-8?B?NjJyYTR5c1NhQzVuWW9oWlR5Z0k0QXk3WDVQdys5Q2xaTXVJdkdZS0dDT2dK?=
 =?utf-8?B?VjBJWUFWQmVITWlCbjByaDZoUTFTR2tobFZ4UFFpUkltY3VMbGh5RzN0Wk9v?=
 =?utf-8?B?RldMTkh0c3laUXF4ejNhdldkQXRSU09qSHlQaGRBQ0ROMTh1WXJPS0tnSUZ0?=
 =?utf-8?B?QXRzZFpPNmhvbDU4U1RIRm94b094MDRPWW9WNWVTZEJ5ZHZDVkNTRVh0NHNa?=
 =?utf-8?B?N0NuN2pVajVBcTBncERBd3htTmJ2bFArTldiQVh2UEE0Ym9EMXNYOVhHa2oz?=
 =?utf-8?B?MkJmOCtyTzZuc00vRVRDMzFLdWNPUEE5N1luRXIzSU53b09lR3Jtdm92N01h?=
 =?utf-8?B?TkM4YUlmMHk5WmJ1MTdGWE0rOWxWMy8xYktTYlltMERPVWhpb3NESFRiN00y?=
 =?utf-8?B?ekFGUzlHUm90SHZCVmtUVjBVRVFkQlNIeWFROS93Mk1nejR3OHFDMUlvRnZ6?=
 =?utf-8?Q?CSPXpeN1le/36RIer8?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28bb9fcf-8461-4ff8-ad3c-08df37be1279
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2026 02:16:00.4275
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /4uvc2pHCPDUaAdPETHu151AX2MPzlKOfPvMzE7GyT0qG2/Qq7BjRbNv2/IptPao
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV9PR12MB9760
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DAF6340002
X-Stat-Signature: eygo8onjyg3ymgtsyg6pkf9uq4figa6q
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1793499365-450437
X-HE-Meta: U2FsdGVkX1+YGf5cGxOwoH6ktq4AtXtvMwmdVvcd+ITo4o5L8qHNhDmOkuK63AseRDp3Gue9GLpMZk/sLFeOV5FYPB/UOvfT4Y0t6oNvv6SdhFA7SovkfwaUvA1uLxyWTX0X0AkYurUx/R5nj4q1XrtGw8gm8s9OKOPTfNbYSti63cOZvGe0Ja7fXFNpFeozO7vpA1tS/uqwBLbovNqHbekxhnwuzirqQLKFIdD5eu0jrl1sHFqJ/i5nCGDW57WoI4RdQs+tvNajfjvaKfKFBCVz6NOy3LYeR0uQW1H51Q7eylSpUYT1Oz/RC+Ec/IHk6M9atINxFYh/YJozawnKlQOrUlmRXVlMu30lADDWtAdp4X7YQJz6dtH6gd3iGB0F5gtlp9wWORu9jBAmmPASQ1K3CWHrtpDpVWF0WtAUULK+Kc864xbWUSShMxYR/rydPpomIfOgUnGIGNKpzISTbo7OvjmLy//RLO0llxigbtIVn37qrq7sXA3JDoo5LMifHYzKORvePX15YLZ0iRmd4UH66Yu3VFoX8mhIxDmmCg3CLgV+8zBCbK+smSwQuss798nZ804Ty6RjZTi8YfGO5Ld0PCwNJCmlWLtFO1p2jv7yQOFPfbtbx6Qcr6aSrSU+SJBBmzRXkFeZIWlspkKeRAWEBcaWEWf2hqrNleaZV2vpl66h2mAw4YcDLE1I564/Gev2zUOtN8f+XT+bmr29GBbo+RA+GLLwAPoTLBcNHlEQucAF1YFOOtkYOyCMWkefx0V1dfqE1BQHWydX1NPX6c3lrrqvfuUb/Pe2CRfrLUdoW89fS5+wdg1WVXKAFuBRW60RQ9/vaBFfx72IHsHqkzyqBkV6hczFt1YzS9XtnBpFlID1fsYXKMjemAOZCfFHzHd7ILrDWqT2qRM9zBJNtgohVrZdbIQOUUkTfHtuwQxA8mLNp8LzRt1gXHtvyiRkQG0VClrK4/ntzV2TPX6
 LlIoKP/6
 NUm/ckXWz4hGkQPe7Dyygeno27sJT2K16KGwNtSqhQd8L4nX0rUN/fSUyMAkRw/dQYTOih0pItRsLv1cNHgnFHFYee9E2oI59KpU+fvTcQMqnqjxgMWpyT8FQOcsZ7883cGJ4BAyJXAfzA1z4nmTA7nbZyEahbtUdKktMdsZdo3g9z5X03i6HZA/IMlF8nmJrc5VDUD/nQpxo1EwftnEpRDloY9ZTpjJJ+MyEiyJjCoSh+RE2WGnqaNg8c+0fN5yCFxtnWSIjeWZwGqNl3cp7aLsZePbYztEwqXO3FXI5fuoZyEblztnuqyBPdtpF2uXRHBCszbrhsF5lw1y16FlXogUd8EO3o029OcLZwUqnOjRz4nIZuGQbckxYFunnLJIFC6MZjzkn3JgppD4/QLnt0GimB/w0dzZMEfR0+2ha5W6bk9R1njl23gINCP1ihSawzbxYlKG31OI6d1QvnQhWEjbmzSi1v4y83HaacI5ehpiwV80LBvxPMGntIGS8lNIPXCxwdmgxKbyXMt+cM8oIWYfd5jZRr3gVSpA53CctQk0nWXwaYWhtULD8xWGMTWb854VITK+B/YwOengjGBcFP/lCceTz2BS4Yggt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat Oct 31, 2026 at 5:39 AM EDT, David Hildenbrand (Arm) wrote:
> From: Chris Mason <mason@kernel.org>
>
> A PMD migration entry can refer to a device-private folio.
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
> Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  mm/huge_memory.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>

Reviewed-by: Zi Yan <ziy@nvidia.com>


--=20
Best Regards,
Yan, Zi


