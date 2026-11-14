Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAC7C606A337
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 23:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=iUwMszJS
Received: by kanga.kvack.org (Postfix)
	id C44E06B05B0; Sat, 14 Nov 2026 18:07:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1C1D6B05B1; Sat, 14 Nov 2026 18:07:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0E856B05B2; Sat, 14 Nov 2026 18:07:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 851846B05B0
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 18:07:30 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 278941604A8
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 23:07:29 +0000 (UTC)
X-FDA: 85435263018.28.8C567E9
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011005.outbound.protection.outlook.com [40.93.194.5])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4615B1C0002
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 23:07:26 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=iUwMszJS;
	spf=pass (imf21.hostedemail.com: domain of balbirs@nvidia.com designates 40.93.194.5 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794697646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FaJIor44vArmHaBOyjE7uNl90Va+Q0d0xwZX2SoxbHE=;
	b=3aIvahi2IcZLo/aauBF1gUOZdUrAQzqyKC29DF7CVyPtcVsev0HtihVBfgzEDPOlzYsQOr
	E/3wKVtcSu+iunf2IBCLF2EQSgVF8iZ3SCka/X17YBNw5L1mLSoXg5rfPd9jXuAA5UAXUy
	RpWl6LsLvQ3OSOEH7Tz3U4nn5xYSJg4=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794697646;
	b=ieaZMzWnwnzrM5yPZDwJjzG0/er+nppoLYSRUN/BcMhZJuNXpZms8OJ2hKZDcXhR1jFNGr
	zENXOmBkh5oa12952S7Ux1r1zZGKUgKQZpVj8yxDcEd9ek5JHeYE1PjIopW2TqGGZS6Mdd
	l3S6NmkleK3ZAi3KXGbPeAtfc1uQ3jY=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=iUwMszJS;
	spf=pass (imf21.hostedemail.com: domain of balbirs@nvidia.com designates 40.93.194.5 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WEBsTWpJN84Whl6t48ifS2xecyoZ1tBeDIUYVdk71XEEKmnVWBhR0LX8XNQhd/njmjl2SEeEiGprlxz8VigaYhpMzVES/wQNuZqoSyQPaw5gi/HUDs6bcFCEmQ7LPoyiiY+EDvm6G2rTaQJEV1dikTwDyN/kRPDi1r29IjmrxA0FDEuK3KDyoL+9Vb69dLvnJLFseXrwiWk1ZDcfb4rOU4e7IuLNT8d+OsMOyiIliXcl5ar/1gkP/jz2PaFYvFuUP7lkxSzDLejYOJU03pMktDTr8GJPmwoCTvUsvHYZiXvxYwQridT5xSFkKUiHAXDCxh0IovXDUylDqV9yn+C4mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FaJIor44vArmHaBOyjE7uNl90Va+Q0d0xwZX2SoxbHE=;
 b=pya4C1m42lUbooliLKYLdY0w1t5Pa8NJ5x8PKm1ZMsLQv6siO7QpYM22iKffXsnb5m0+jfyZIzopPb/0bDShg2diBOZwSMw+Ma+0Vk59+EFzy1iHTWwjJRRak3Rp+q6vAwGXLzZ7Ad0EByOr3YkLNnIl+r4LWM4PZ7iZD9oRTX38ZSCb78m1Z4b1QcJFOZzD65ivkItSsQVFvIvgpgF3F4E5oMN4S/dblZ+T0IxMHGZZy5kM7vpFUfxUEJDwEPUyusipW7J390zeXSckUzfTsPbVhGL2TSQK1QnK1aOhUYt0YsEfVypR1QmfCXTaVXBBXS7VxosRHlQBjHHa29Gz5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FaJIor44vArmHaBOyjE7uNl90Va+Q0d0xwZX2SoxbHE=;
 b=iUwMszJSQvxx8JRru+qBh2TCeEcw8zQ5ha8gIlz/0D7s+ff99r//6XCd7FhNOG257ubeQTBgZSQsFbQvGqYFeebYXTSpehZlDqWGPf2C7/lQpWTYw/47BRzQyN4f4VocJ+fjJy+kIPvMEvdHKg29F/dR4WdWBJJEfz3qySTGXStKsh5rQ4oAjTG72GlDWjll3sALDQnarpAv/9nSr3BuxBDX6P+1Nt1j9a4SlAmSfU2mhNtYDvhgUabxquX43P4SMOSwIpBE6DlfoG9ORg6Y33zua69VHTmJ+//daKTqKpssPnw0beoV8NTHUO+o6JnLqvmDdgSfd0utiWM+tqsz7Q==
Received: from CH3PR12MB9730.namprd12.prod.outlook.com (2603:10b6:610:253::9)
 by CY0PR12MB825472.namprd12.prod.outlook.com (2603:10b6:930:130::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.13; Sat, 14 Nov
 2026 23:07:20 +0000
Received: from CH3PR12MB9730.namprd12.prod.outlook.com
 ([fe80::843d:c1f0:b2ed:4128]) by CH3PR12MB9730.namprd12.prod.outlook.com
 ([fe80::843d:c1f0:b2ed:4128%4]) with mapi id 15.21.0615.012; Sat, 14 Nov 2026
 23:07:20 +0000
Date: Sun, 15 Nov 2026 10:07:15 +1100
From: Balbir Singh <balbirs@nvidia.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Nhat Pham <nphamcs@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Usama Arif <usama.arif@linux.dev>, 
	Kairui Song <kasong@tencent.com>, =?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, 
	Kiryl Shutsemau <kas@kernel.org>, Yu-cheng Yu <yu-cheng.yu@intel.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, Peng Fan <peng.fan@nxp.com>, Josef Bacik <jbacik@fb.com>, 
	Chris Mason <mason@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, "Borislav Petkov (AMD)" <bp@alien8.de>, 
	Mark Brown <broonie@kernel.org>, "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: Re: [PATCH v2 13/13] percpu: queue the balance work on an unbound
 workqueue
Message-ID: <avjn4xuxUmtTfMWu@parvat>
References: <20261113-mason-migrate-et-al-fixes-v2-0-50a2ed382b61@kernel.org>
 <20261113-mason-migrate-et-al-fixes-v2-13-50a2ed382b61@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261113-mason-migrate-et-al-fixes-v2-13-50a2ed382b61@kernel.org>
X-ClientProxiedBy: ME3PR01CA0031.ausprd01.prod.outlook.com
 (2603:10c6:220:19f::12) To CH3PR12MB9730.namprd12.prod.outlook.com
 (2603:10b6:610:253::9)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9730:EE_|CY0PR12MB825472:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d16f394-9036-4877-1a0b-08df42a40929
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|7416014|261028144727099003|261102123227099003|261022075727099003|261022105027099003|261021123027099003|261021121427099003|261026140227099003|11063799006|4143699003|56012099006|10067099003|18002099003|22082099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	dEYNAQLtpHrxw9OTC62UNqWF12tHUv7w3jUAdVIJV5+P4ZroOVm6PAQYgRXYPzEq44/gPpMrXQmCD40nR5Hh0pSM8BEIPRjBrFpQ1evdV/b3NVWlHGYGO0xZ5K28bAxRbxc4jIJ0vm2xBD3hjZ7phjshW8xO3KegMGpJ0hbAKd3B3/kFGKt7VGanoGHGy0fVk01JToxKgUai2O/bXeAqza2Omk8OuNlBnsLIFq4ALieDnspnv9Gs3ZkFZ/E6+dmnGWmnD/2wrfrCZfYArS1OP2Hd1J8wyFH8arvHc7Bmn1Yeb1GLeXxN7LKjDkrBKAsUxu+2YjZ6JK8MJ5+0ozeMpKvzKCn/jO98cCiyIhmVuwPOerFqpOPjI0lo6QMS+TILk3oz/+fNQ6h0uZkKX/ZMdMH+z/iuvViBRqNiWFhGNwFGIVK+2FDILOeTIAqGqgUUjKnVKYlI2hsMnfeRBhXeRs4m9BQNcIvh52YEe1bcFFyz07kEwkvBoF4Cu6rrZ1/PyxGhU7NmaKmjuJo79PR6pIdBCEjikfgik9juXD0fUNN9mrpqx7rM2szakWFtdffo0X3eswZD+sKLcoXpXw4vGN9uZQDWDqTJkp7v9QZWB+YURepydaMouoa6TLBcu5+TfIxCR6EtqnVLRA+EBZv2L6i6AF0DeCmozZU0HBZgsvs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9730.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(7416014)(261028144727099003)(261102123227099003)(261022075727099003)(261022105027099003)(261021123027099003)(261021121427099003)(261026140227099003)(11063799006)(4143699003)(56012099006)(10067099003)(18002099003)(22082099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?SST3E/QV9k/3T28hUg2JU/RK/HbphONz2P61Tjpfsuvze4iWjyVb/S+3t2x2?=
 =?us-ascii?Q?POZnDCdN6hAS8BdxqJMWFpNMk3Um/YzPjYvPY73BU1MEWzgTcWzvs72gneqq?=
 =?us-ascii?Q?z1VMRmjCilwzCZXMM+oHxLm4FHB03Dvi/Ri/dwpgimEV+REhfnIOEmaurn6Z?=
 =?us-ascii?Q?pgWoVJceR9kdT7uKh3KBg4+QnFuLMYKWKH1NlPNNarbidh09P7KWnFsdOiML?=
 =?us-ascii?Q?IZYeSi7kTDQ8Q9M+0wpcNj0gw6TvSNSHTD+TGwt2KBMVpdIQuIZvoiC/n1eA?=
 =?us-ascii?Q?EhPuQXAP6274nMwBQq8p2w5gd292FYbGtQ3TeiogQFElKSVnNcr9IAwfZKDk?=
 =?us-ascii?Q?J4yrNc28VyR7n7lr14NO/3dgAIG6w8xqhOeoZ8JV/DV6aqyVNmllkydMqtvA?=
 =?us-ascii?Q?M0Ox001BarA1fUWBAd3DTWXdC0UdutJ6UtJ6AF1YXIHpvQu0b1fmhseO1DP7?=
 =?us-ascii?Q?Nx7G8cXjHiH449PF9QVhjNCuSj73CauRFtOr+K6NPSwU6IR5o6BlZItlAPmd?=
 =?us-ascii?Q?8HtWvLU0Kd6mfrA7nsuOOfXs+tNBPaEWf6sfumQww3m2punv/FwsF/zkzj3q?=
 =?us-ascii?Q?zVopsDxwn3exsIPFNzBKtO0vwPToRGmjBgx2ZePNTe2A4t+dD2JD0ErTLdGL?=
 =?us-ascii?Q?XU+38PXy1k7EWXKrZOpE5oGZap3WXbGoYmRg9nE9hxPAh3PG3imcMUOqXCxE?=
 =?us-ascii?Q?PI6BKjfi4+OjM7f1p6rMj6N6ZCxXWjCHdWIUKGdpvvQ1Aww75AKLePylPBiL?=
 =?us-ascii?Q?uar4izIeUM0TTpqHewmElK5vuMRY/HNt/9B2JzeUcVTpxsyZv4t5iOdJf9EV?=
 =?us-ascii?Q?sayoMbiMp9UBAbdggmhyaNJaxBUpbz5HUzQw3iWvWfU7t3jrbrPFElyite9i?=
 =?us-ascii?Q?uRqDCubA6dpc22nCl+SpSFjvX9cn6q5T8ze67sFrItYNTKQM3gUigXo9Txb+?=
 =?us-ascii?Q?ojNvgYlU2RLvFgIRii8uX/0vZBQsDPFnyfQ7NMFxbrNpwqcuaGt/mhGkprNc?=
 =?us-ascii?Q?A6FVH/tRfOoUnbmsIs9odkPCIBlwuNA8BwNmKdJaqgMaItFrR16TmSs6KbNV?=
 =?us-ascii?Q?atEa0A1PQGR6ye7w40axoss2Z9n0TV8OB7yf8LKqboDQGQadjBbyDFdXFRqW?=
 =?us-ascii?Q?u8U7ZexKhLGMtV+EGMQYdtogXAJUELNuuRnWSjmmd7DHnXUGFAcNjrHRY0sj?=
 =?us-ascii?Q?vQTrqLhOtCau94d6lr7BEzW/t8V16sPbIdnLw3wizBIOhRmj9bmNCvfHLXs8?=
 =?us-ascii?Q?B+QiTyyjRQdN/FXqcLqGYV78mqK+9UZdLoewlWrVD8sl8mjxxlkOrot79RQg?=
 =?us-ascii?Q?Il9i8KG8lgUkBmqohWXFzya1hfSHNekhsZoxAqDfLbZCSSUS55NPquVX5uhT?=
 =?us-ascii?Q?lOiMQ6cAYO5TB1MCJfwc8m2hyAsVnfAaIVhaLm8JkMrG3u0CKeBNpez6QZrG?=
 =?us-ascii?Q?HhwygP9iu3gkbcAyjJEWaPeg8EFkk4ypMb3Zt7SAzeqOITOJB6xlKSZsk4Q/?=
 =?us-ascii?Q?oIZ4t66jNlKJDoLxd4oRTswKuN+IS6kLSpa7OWsXSfQs6y06ywljXcDVZPqQ?=
 =?us-ascii?Q?sOiGRjs0Ef6D3MsZbL9JVDNxVFQSwmVaMKFokEcWHZcEU9tfnEeG2M4zCsXZ?=
 =?us-ascii?Q?ZVYYkWHwUAeB7UNFbe94oG3A7zE5uCqMZb5ECGb02/IFZFQxktxmwLzbPWPT?=
 =?us-ascii?Q?PMIDa1S/feb9aXl0hN7bvSXTby6P9aGi4EFFpIMgoT0VzQnB3EWw4xpR0pj4?=
 =?us-ascii?Q?CmC+eet1nQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d16f394-9036-4877-1a0b-08df42a40929
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9730.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2026 23:07:20.6849
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lA3FdzqOm0pMj5AnetTj2SXuPbR2JCFsdDJt7U91WG6/v0YG0GJ+hdjWMGysB7GxeNAESfh3DB9MTpg7q9ykLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY0PR12MB825472
X-Stat-Signature: 55x1y4owjwss4gfrhtqyd4ythnsnw1hr
X-Rspamd-Queue-Id: 4615B1C0002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794697646-785141
X-HE-Meta: U2FsdGVkX18x5dt61EXdHdBpqq1lIdpLphPHVxcuzCDvJeU/NiaSp2+laNJIEsvi3lbu6xz/SmGzrQ4NsIVKm/vllU1Zj3H531Itw6yumbweuRkE5ifT9/l964uilj9RGBEQF7NLEgji7MZgDnyj1U3RKkK3I2H4kIJnMSXKrSk9g9OLynjbi1aqK0sZabQnvV4b0YWEA9l3NfvD1HhW08RPcOHnLvUnaD0i8Ekzo/ijp+1ro0POBMvaidCRMvLwc8KbAdoZcf+qY9TJJgEcMhifcGe4fwS17HCV11li9dIAHdVU0vVc+gUQEGWIi4kv2QtbVHZR2Fa5LOUx7PFKntiGnOXCTcqlFry2OEEcq22gajS2SCdAbbl3ZuUpWn0Fa8oBnlvs8CREKahZNXhrQo26XH9NSGMArpuci9E7N+HfrtdwsiIUSqWaUTB5VRkzdLg6NuvHok4CklhVXvQlMOWs+CRtjbqJvnUXD6x1zwOwiFFwpdrCvHv6kyS4X7Ue9hei/ickevWOlxY1TQEWfSMMZCKYswLx56SPIBKHrwAuDg3cb6AG+h/10i/Xt6fY+DDNyrVINAHgx16n4oWkUubb3myOtB+aFOsEws9XcuF3YdfWz2hcCtfc6WrQssVn4dO6gOxetNW4gAP55MR2O5Ya1EBDBg4AqXF80a6pp0u/meprnJY13mZDbumYDtwnC8aYHP+dAWtlnPa2BYZ+9n1piS6P/6uUFYLZbX4YE8ImI4ZQFGfnJpr3tKcPvuolsEf5H5z5aT/l9flA4QJthxOL3a1QQGzm2nAAQkrfWTQIdWeOssB1NlMp/7KwH7/MPk83nhxvsjVhQrJ2CBhRqPiJgGxEvz6HaFC6N3cgoBaDLI6vXrPE8+/DkwAu1QWO+5hcfPhy3Y9zEgqg24XcrTBtXzfz4cRDkgbWNv1NaexAj2S9ozDbEPDBrXxCZXxPP+MZxz8Eja+IwK8+oJd
 XaR37fR0
 lpYjuGhupLweeqVfUJ4ZtvQA3Xqdi82E4AE1RAj7GP2NFn+Mm47Xr7gLwxEzNaEadLGDAeVa+621Cce44jdkoNqLu4KcggtIuVYUJnhOYaW3DMei11nJ9RFO+7nuYq6kckFNT73h5+BwGrZ8ffg1n8DrDU/949v0iswDNy49fJzz+e5zWbQlaNfpZxM9JjuG5aG/5IfmTvXh9f9obdO9+GWNVVzj4zXZPbdCqOtSu60eHCO2HztPSbiV+eDzFG+nvRxf89jZRO0Hu6xpNyZwP4CQP9bvkp/ylqEvkA/ccB5wZL5ZQFiKMgkFXj+4dli8gMPi8mKk6Wu6ZSS4wYEqyKHRlbq6D49Tvs6y0em6NuoK/G3dDkkNMGDKadtQEAk8vwaCKRMahWj/QuxOQFkmfPnMT3zpoHNX5eHiyivG4cwR3Kna+3p2moNKDWoyniHbhNEE8K10bEVSreWTg3ZLbTn7USOrxSBjCY+LpDkKZ/2vUjEsBV981SaiY1Yz23F/Hqk7pEeY2Tz0/gxPErwx0tfUTs20twfYQx/Aml/DO9tt6JOv5Va4g+oPcTw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 13, 2026 at 09:45:31PM +0000, Lorenzo Stoakes (ARM) wrote:
> From: Chris Mason <mason@kernel.org>
> 
> A burst of small atomic per-CPU allocations can fail with -ENOMEM while the
> machine has free memory and idle CPUs, as atomic per-CPU allocations are
> only served from pages that are already populated, and those can be used up
> before a worker gets to populate more.
> 
> Consider:
> 
>     caller on CPU 1                     kworker bound to CPU 1
>     ===============                     ======================
>     allocates 8 bytes, which leaves
>     one empty page and 4088 bytes
>       schedule_work()                   woken, waits for CPU 1
>     allocates 8 bytes, 1023 times
>     next allocation: "no space left"
>     gives up CPU 1                      populates pages
> 
> The allocator keeps a few empty populated pages in reserve, and the work
> item pcpu_balance_work refills them.
> 
> pcpu_alloc_noprof() queues the work item using schedule_work(), so only a
> worker bound to the CPU of the caller can run the work item.
> 
> The issue is that the caller keeps that CPU - a task keeps it for the rest
> of its time slice, and a softirq keeps it until the softirq ends.
> 
> In that time the caller can use up the reserve, resulting in an atomic
> per-CPU allocation failing.
> 
> Fix the issue by queueing the work item on an unbound workqueue so that
> another CPU can populate pages while the caller keeps allocating.
> 
> Gregory Price hammered atomic per-CPU allocations from one CPU with
> preemption disabled for about a second, with and without this series:
> 
>                            Before     After
>     Successful allocs       1,188   131,072
>     Failed allocs           4,097         0
>     Balance worker runs         0       169
>     Successful retries          0     4,096
> 
> Fixes: 1a4d76076cda ("percpu: implement asynchronous chunk population")
> Signed-off-by: Chris Mason <mason@kernel.org>
> [ ljs: tweaked commit message, comment ]
> Tested-by: Gregory Price (Meta) <gourry@gourry.net>
> Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  mm/percpu.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/percpu.c b/mm/percpu.c
> index f87813e6ad73..39cba1710383 100644
> --- a/mm/percpu.c
> +++ b/mm/percpu.c
> @@ -200,8 +200,9 @@ static bool pcpu_atomic_alloc_failed;
>  
>  static void pcpu_schedule_balance_work(void)
>  {
> +	/* Unbound, so another CPU can populate pgs if caller keeps this one. */
>  	if (pcpu_async_enabled)
> -		schedule_work(&pcpu_balance_work);
> +		queue_work(system_dfl_wq, &pcpu_balance_work);
>  }
>

Can this run havoc on otherwise idle systems? Why not choose a workqueue
with WQ_POWER_EFFICIENT, which becomes unbound when nohz_full is
enabled? I guess it still leaves open the case when nohz_full is not
enabled and we get a burst of atomic allocations?

Balbir

