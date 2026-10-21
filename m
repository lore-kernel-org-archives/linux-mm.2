Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E13D8606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 07:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=KHnyO1uX
Received: by kanga.kvack.org (Postfix)
	id 0200C6B01A1; Wed, 21 Oct 2026 03:18:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F12A76B064B; Wed, 21 Oct 2026 03:18:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD9716B064C; Wed, 21 Oct 2026 03:18:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B4FF16B01A1
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 03:18:06 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3CBB7A7F91
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 07:18:06 +0000 (UTC)
X-FDA: 85345779372.11.E3558F7
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011000.outbound.protection.outlook.com [40.93.194.0])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3F7EE20005
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 07:18:03 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=KHnyO1uX;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of balbirs@nvidia.com designates 40.93.194.0 as permitted sender) smtp.mailfrom=balbirs@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792567083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CfVlp/U84Ek1YAWH2BfUTwRSlofgxtqwRgKxpRacTng=;
	b=deB+qRQRH4tH+IkFjKB/LTxVfCy5UVyqMPydNmpIY6sZmHe0xTr1hb4KG6H6nqfnFiDl46
	/pQyP9JHaBJP9+7qPZVM1f2Qd3cJChsQL3nopCWI/U2Ud/4bV84F0DT7d9wXoLFYLs1o9a
	yGaUqQ4jFeztZelC6lLNhd5Dqo/tmbM=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=KHnyO1uX;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of balbirs@nvidia.com designates 40.93.194.0 as permitted sender) smtp.mailfrom=balbirs@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792567083;
	b=HoJFXBE5P8bZ05T69BxLZTKeyveXcrK6wtHOn7wP+cnEA1+nwqkqhj+nsShq7pQFnCTzUR
	GN4vwuA3bzpXwQwLQho6wfLjMS3B1aG58zVUT/+pFXvcPGMMfOvcH5NkdtwKpPrL6hgUEb
	20KjWWOD3UUAR0Xl+p61KnpmGiSCnUk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P76pzTuXnAbIXIkiExULskXscKI6oaNBZvjrc8jtD1+buM5ZUKh/T1nsRLX4qXCs0N+ImRNEvnpgn6NiV3mCfEBAk8j+M/P4K1vKJ9UrSnogBe44LL8yS1m9j54sJIuMIpkaJQb8C2LaJOxuA90iNxupLQL3g5iIfBq0SfI527zpVijWGJXgZKYX+MzzaZJlAXLiQUqN3ydq6c2/S1PIzyApMsu8OmPXJE7N5rG7Ap3nsTO8V0NIhw3tKgbLYVb6IbLgkbgibWsFbHu2iNrJx4AsENM7NgxM97PCFoyPEb5T3v74q0Hpds0X2GZndEVyPG7Ndo53tCxYVdauh6v+fA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CfVlp/U84Ek1YAWH2BfUTwRSlofgxtqwRgKxpRacTng=;
 b=NLiBbruD9qzzjnxzQyjd1h5F7GaV/wrA9ceTvry69o57O3cAGCUthEH9R4dRqpAtIAotVyaE7Zcm6nU2tCx+JZfg/6CXu4Ac64lQl4bqQYOcWBj7wb2hyXNpsAOrskTVKfw1RVG5csV6ZcVrc7g7Z/irq5dhBVFLbScQW0uLPIRe3fBK825uqVsRQFds+S/juHCmB/42vVXukMjBqF9u/xBiCFC4XeRVQfhn1TbwlMncYSqHoZgWWUD2sLNsuWFhrhnSA5Cd7/tDeDq03GFc7c7NoPPvVzCkylaW+Xh1T2rxgk9CMEEzzp1XdcEyYulCwu1dbwnGsYRAOLtfW7+dLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CfVlp/U84Ek1YAWH2BfUTwRSlofgxtqwRgKxpRacTng=;
 b=KHnyO1uXkmxvCakoNtwV727ugHZfYq3Z+fLXJ7BLui2KZaQ0zfiwX3trQSmRW90PNg5KLRRx32eG19uLGdBu1/X0jw6Pt637TZLS4uTDZGznAwVzYjOxkRIW8Kq3h8LKvPz4pbU0SNJtmwpnc4l8vfgZ3nCNPG5UBDmZCxree6r09lFwIuZ5bkMd9s8s37h0jKqCe+gJq/2Iq2y30Ox/QZw/2K3ujktPBzCgRW+xY3+JhSI3mdzhibGG+jjWJzNOycFpLcaiqNxejK2k+U6zEQdMnMNSgRekLuk3Tp8POrBcBGs4ACmmVaTTQ5hNdtNSYv5j2JrDgpVWzXsOXxAr9g==
Received: from CH3PR12MB9730.namprd12.prod.outlook.com (2603:10b6:610:253::9)
 by SJ2PR12MB8738.namprd12.prod.outlook.com (2603:10b6:a03:548::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Wed, 21 Oct
 2026 07:17:58 +0000
Received: from CH3PR12MB9730.namprd12.prod.outlook.com
 ([fe80::843d:c1f0:b2ed:4128]) by CH3PR12MB9730.namprd12.prod.outlook.com
 ([fe80::843d:c1f0:b2ed:4128%4]) with mapi id 15.21.0522.016; Wed, 21 Oct 2026
 07:17:58 +0000
Message-ID: <017202b1-1c48-4fb1-a951-6d909fb30016@nvidia.com>
Date: Wed, 21 Oct 2026 18:17:48 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 03/12] mm/hmm: preparations for HMM to participate in
 migration
To: mpenttil@redhat.com, linux-mm@kvack.org
Cc: dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org,
 linux-kernel@vger.kernel.org, David Hildenbrand <david@kernel.org>,
 Jason Gunthorpe <jgg@nvidia.com>, Leon Romanovsky <leonro@nvidia.com>,
 Alistair Popple <apopple@nvidia.com>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>
References: <20261021060506.2377545-1-mpenttil@redhat.com>
 <20261021060506.2377545-4-mpenttil@redhat.com>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <20261021060506.2377545-4-mpenttil@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: ME0PR01CA0071.ausprd01.prod.outlook.com
 (2603:10c6:220:20a::19) To CH3PR12MB9730.namprd12.prod.outlook.com
 (2603:10b6:610:253::9)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9730:EE_|SJ2PR12MB8738:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f98694c-7d06-4b2a-40ab-08df2f436f2a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|23010399003|56012099006|261009221227099003|4143699003|11063799006|261009223027099003|10067099003|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	Ya6pgCv5DLF5doseikTllR8jrceUxOL4nZ0TMrjjUy2a5MR9lnXKBfdjTgLc0SjbuuXA2EjaKdiOxL2B2JQJ6v7PNSBkdap4hlSomFZHe7D5CUekexQEQuuK/I7Jlqs85Yo8B2iDEJrHUMpn7ZK4+chwghY/Aif5etGuV/vmw6wItftbjRwmLONFGeshPlqf+xw6pKa36MXvEO3UY/M51bbyywqKNHcf66TqRNhMJu1xh6vdGLQeruV1agoG2s3oAL209M+d9MJzX0iCX+7Dj5y2NQ2Y1mvgPnpQ94Fj/wnRqaam+aM3WG2F2pQpLcRrQB0nUJSwcaoNas2USlNIaJ688VQbGN+fJApaXXwNM+CiZ/2mnASo8xE52tPXup/sArSggRjNIpQF+F2nmWA/b4hKXs7iX9xkCohxbBuXTvz84CAzb3xmegdxk67Ye1o7xstPLASg6P73isZ9qlrFtqqZnvVYvb/x2dGxppSeQht5lBiAw+/a/rCqIkWMGUjI7H2nzEVSh/OXOIHgm/8OSImo6yCx4xwl0EfXWcoGJSHN8Ekj3lRU6MuwFPj4g3QDRu6O8c6y+9A5hTpNWq+mAnUOvONNyY/G4g8iGrE1bWBS426RJ7GxN/kFHuEGY/S2SY9kxM6+MlYvzZCtXUXGQXzUiWMz+fLgc43kDXwMwYM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9730.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(23010399003)(56012099006)(261009221227099003)(4143699003)(11063799006)(261009223027099003)(10067099003)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OUpQQTJsTWlnSWVXRDZHTzdycllJMTE0QlI4bkFsU2pLUVpKSzYzN011OUFx?=
 =?utf-8?B?OGF2TWlxcEo2Sm5NUmN5TEw2WktzREhzRWoybEVRN2F5TExQaFRiSmJTVkVU?=
 =?utf-8?B?cWk1c1FUU0ZRTWlUZ2JMaXRDNjNUY05Cc3lmZ0RRSFlJSFNzSS84cFcydmF1?=
 =?utf-8?B?azBwTG9CQkR5eUFKM1FsZ29sMHc1QWNGYjZSUXhJYUxCSWlVYkY5S3l5eXVX?=
 =?utf-8?B?KzUwbVZKNy9sc1dWY2R5MHNuS2pmczJhZXVCOS9Ocnl2bUszLzI3SEhaeXFU?=
 =?utf-8?B?VXo5RlczeXI3TWswbXhXTVM4QU9KM0w2RnJ6cDgvUDBUc0ZhdWcycjdGVjFD?=
 =?utf-8?B?aWVjc2tGaFpNaWZmKzJQQTdHeFNIWUZyMFo3UlZhcjFNQ1M2NmFtQ1Eva3pN?=
 =?utf-8?B?ekMrT0ErYnZpdGRzZ0J3cENJbkVuYnNDSjlzdVhZck1lMXcyMk5LMkh1bnk5?=
 =?utf-8?B?NitiR0lZL1o4RndmU1ZzYlBVdm5hQzhiZzVQYjUrWGF3Vk1ZdHhLUWs0b204?=
 =?utf-8?B?WXhsSm45c0IxSjR6WjJxTndqd0QxZmsvdHV2bFVLYnBvRWYxSDdJOEZQVCtq?=
 =?utf-8?B?YmNnSFdERGJkUC80MjNTbGF3eHJZSkFIeUdzOXRLdEo1cmV6YURJMTRTZ0pt?=
 =?utf-8?B?bTZVRldRU2VJZTVzYUNWbUxhVXlNWVRCRFI2dzV6ajBmQ0UxWEM1c3FNZVZu?=
 =?utf-8?B?UlVUa3FIQWI3SDJSMTlvMzByeURDWHhKN2NuemNWTW1Ya1plZlExL1lYNE8x?=
 =?utf-8?B?eXA2Y1Nua1dub1FkRkg1VDJsTTJrd25ZTm1tM1h6REFQMU1XNHhWMW1xZ1pt?=
 =?utf-8?B?bmlObERwdzZ0S1pnckhnajdlbTEwVHZhd0gxQnk5RnNjUVNJWTQ2R281WEZ0?=
 =?utf-8?B?RFVucnlwNm00TnZ3YXl6dG1xeENISGlhREJyVVJjUWJML1pOalR6MjFNdHU5?=
 =?utf-8?B?aTN2NzdVMjM4MUFVcmw5bDEvL0x1UHF5dURpSTNlenBXVnpadm9EYWNwTm1l?=
 =?utf-8?B?cFlGb0VQSC94emxkZ3BWN2tXSmI2THF3akFicUJaUTI0S0kxUVlNaWt6aW1a?=
 =?utf-8?B?TFBQMjFCYzluWkVmNW1XV1ZqWlZCU1BLUmd6aUFqVVN4L3U0NkRwOUFrUm11?=
 =?utf-8?B?SzRibG1CKytQNlhjWU1HZE9Cd05aRmFJZ1ltODdFQXphb2RKNnk5Y1NpWmhS?=
 =?utf-8?B?ZDhDelR3OVM3MmtNcHZVZFVYRkZvUEZkSFcrV2poLzlGTmpuMmxJcWNCU21N?=
 =?utf-8?B?encyOEk3amNvUWY4by9lRDhEMWlQMS9VS1BQeEplVks0NGJ3R3ErUUtSNzg4?=
 =?utf-8?B?SjI3YTlpSVoxaTdKK1pBSHROd3ptQ0lmL0g3VytZc2dSMnZsRGMyQVIyR1Bt?=
 =?utf-8?B?MWdJenFFS0tmZDA0c1J4dUlqQ2toUWVNcEdPN1hpQkp5VkpHUkNIMzY1WXVL?=
 =?utf-8?B?SEVCWFZDVUMvY0VmY282SysvaEZhaVpPdGVYMU4wcjV3N2NEcUYzSVRjdFVG?=
 =?utf-8?B?OFhiazRzRVlnbGxHaHYzVmdiZERNQ21MdVhEV3pwOXRzWHVGT3VWTlBuS09Y?=
 =?utf-8?B?UlFBK2Z6TThxbjB4WGRQNzZuUnduRk9uazRoTS9KWEg3djR5VDNua3dkUlVo?=
 =?utf-8?B?a3RjUnhkZG1KdUFMVXRwWHZ3SnBEdFZ5VDRnNFRtTUtzRDZkcVczT3g4YWJk?=
 =?utf-8?B?L0hYdHl5emVXQlpXU0F0aHVRRHFkVVNYcTcrYXdoOE92U2E4d0Ixb3VHbHpt?=
 =?utf-8?B?Tlh6NnZUZGlnaUFvZ0RSaE9ackN2bzlJVkVOWWhpbVZiVUdRTVphOUJrTkxx?=
 =?utf-8?B?eUlRMnNkUEQydDFud1NMNkFMVnRKUFQyaElHM0NIaE5yVm9zT3NCRWtrc1kx?=
 =?utf-8?B?UWRRS1VFL3J1Y2ZWSnN6KzVLa1FsbUpyVXBzY0JYbWRJS1h0ZEhhOW5iUEk0?=
 =?utf-8?B?dTFPZ0FIR0RhSlJOYjdUL1piZXJOMC85RlFGYUhTOGoxUVBOajVPZHhxdUd6?=
 =?utf-8?B?OFA2SStJcTZHVU5nZmFLOGljTkJjVmV1ZnR2cXNxSHM4VVlTdlJTMHdCREwr?=
 =?utf-8?B?WnZ6TVhacGpGLzZqQmxHOGFYMlB6aUV2TU9UUDEzMis5bFMvT2liSDJNWllx?=
 =?utf-8?B?d0M5dnNVdnpjWi9EbVJZZmREbnVhUHUxTWRwZnJEWlJuZkl3UFZBK2YvN0pp?=
 =?utf-8?B?NzZCaWJaUDhlaDNyYksvL29ibDlOR1NFNlQyZ1pneDYwYmthOG9WZ1hDVHZD?=
 =?utf-8?B?dXU3RGd3SUNxN1hWcUkwbS9mUnl2N2VhWEgzTytYS0V0aDB2ZnJRd1EyN2c5?=
 =?utf-8?B?UHhIZVNyQmhJWGJjRFNtTTI3MlR5cnkzTXI2eU02K0dKeWhtRVhsdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f98694c-7d06-4b2a-40ab-08df2f436f2a
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9730.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2026 07:17:58.5129
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RhsIes3p08tBAsbhuh+bzDx0w/VMcHR3tNO8PvrnMChMsTgxKi1JETZUV9b01Ce/Y+hseWlCOh5+PqQxHX0Syw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8738
X-Rspamd-Queue-Id: 3F7EE20005
X-Rspam-User: 
X-Stat-Signature: oajp4hbm5o3kcghi4hswdu51agficrig
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792567083-20411
X-HE-Meta: U2FsdGVkX1/4pUm0QWxK4d15FHQYDe4JB5r01KBNS6KKLkdXOAxfyDu5M9DR67BvL4YYwCe1CTJrrETl51BduNYdOirREFD0+SrlYVccGEvrBfsRsvgPsxKbMtEOCZiaJSWQZeMoowYB3xQ25bNLNsKhBvZomiAqCj1SiAaqzS+nTOSB2ZW4APXYDRrkjc3uZpo9KsKFQG5us6xoJDcylHj1vSs86EyzBWa4PxUh+F63TaiWAIngQW6KvEXOM8N6MT9dk+pUYf1qk6oevPOm3o8d+5v7qwiHm4nVfv4iKTkgdabM3M1Rqvyk0Z45R+MQEJamZHPvxGMb6+nc9cW8eupROiBXL27qYlaXtmYeophteP9cYETOzn0T3yjA+cuIj9e0Jnd0Eiwc24CWL3yEbSteXUsdXhNgb5GEOnWZWMv0AJhZHuTAoBE8vc9FhqxLNgSfcn/wStr52syIIOIKQdcz0ECNgWMyaJbo5aTCl1v2QE4QGqRjUqQoOrVGUeUxrSTgarDPXate35qC0lPIsvCvvBQpLr2QOMX3+l+jHZcxh2su7xWoCEQhWDJHw7DvAdPwH372e0DWXih81GGfNX2hojp1Li61WmKEEzB5CAnxhdZn95T+9Y/A6T0wx0KiMrOIdUxfUno3Gv/HIq23BRPP+bDJzF5rwL6PDEzlDd2wi36i4D6OkOI8xyJCw+2IzkuAJzDqRzafsRdAlu46FsKfdh6AU1Cko/XaWxvRPoH9i5NqX+SzMh9d4+oLR4XUVy1as9lnjvyPOwx96w9LgQzKEnpqjbhXFtNwXQwCdh2X+X4qtuOlhf7yXVAfPqx5LqskTDc4K55f0x7DscJai020iSIzU1aRz3ng9UQgRODMdbl0PlU0sqi81HekS1QLOM6VdR+0A0tcZekrbbUo8+wGciL2+YluLzSlG+DthSdQZKYw55lerUNtiXYmGMYY2rhUN18UxHwT96DtLrg
 zVO6Pu4G
 pxh85Q3t+IGQxUJ8zZ3wELW/6idf8B0nZcYvsBpbIrjqAGlsukHZGGBsWnVNBKCndUJebl7hBcx1otztgLiCqOiOvf5/iJ6NGb4wO3VGHhu1HF9u27WSuHEZK7Sq+1i+jBu+tsT3rwLtLEhnTlnOrs/AmdIlHS/mMqGWeqztR1E7iRxTYoglKFecQRCRxcLA/JPhxr0seCfRG2WXbJL10eP+DMtV0BLFrXRseABmJaEp70T8hKo/kzarnkoUVXBvs1ZzocWK4w42hodbxIjR4omcfuIGDcC+ArSmm5vXdnU/f11EcUK7mc3SKaU6vcLc8A9ojB7kedBfZWAiykfyp3xBgn0GnHbA2tQUtt/atX3VBuM7dQtnFDR9aYo7474448X00htTr5M5wW5VyXg2rpVRKgrkB82d6Xa17y+wpmfahyjxkOWZY7NHpNpwErhndEej9k+kNBBRJFJNF51g81xrt34peBHQGm1eSPrVyH/jweIBstpZ+/G5bg7Zo6OPgFtnNvhCrWsUISftGSriaWDq91td0HTNO6vIjZouzjHfMFOrnUPb+iJRuaLgXuJgzotBAz6io8SK+s8ZOv248qjXuw4vo1uYT3rnc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/21/26 5:04 PM, mpenttil@redhat.com wrote:
> From: Mika Penttilä <mpenttil@redhat.com>
> 
> For migration to happen after hmm_range_fault(), the vma has to
> retrieved. Luckily, pagewalk already resolves that for us, so
> just have to save it for further use. For migration, mmap_lock
> has to be hold for the whole operation, so vma stays stable.
> In case lock-drop behavior is requested, return an error while
> migrating. Also, rename some struct hmm_vma_walk fields to solve
> namespace collisions, and we are later introducing more
> xxlocked fields so be unambiguous.
> 
> Take care also of firing the mmu_notifier when migrating.
> 
> Also, prepare for differencies of how mm_struct * is retrieved
> in fault and migrate_vma paths.
> 
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Jason Gunthorpe <jgg@nvidia.com>
> Cc: Leon Romanovsky <leonro@nvidia.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Cc: Balbir Singh <balbirs@nvidia.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Matthew Brost <matthew.brost@intel.com>
> Suggested-by: Alistair Popple <apopple@nvidia.com>
> Signed-off-by: Mika Penttilä <mpenttil@redhat.com>
> ---
>  include/linux/migrate.h |  50 +++++++++++++++++-
>  lib/test_hmm.c          |   2 +-
>  mm/hmm.c                | 110 ++++++++++++++++++++++++++++++++++------
>  3 files changed, 145 insertions(+), 17 deletions(-)
> 
> diff --git a/include/linux/migrate.h b/include/linux/migrate.h
> index 280ec9a866c7..dd7dd7ec6995 100644
> --- a/include/linux/migrate.h
> +++ b/include/linux/migrate.h
> @@ -5,6 +5,7 @@
>  #include <linux/mm.h>
>  #include <linux/hmm.h>
>  #include <linux/mempolicy.h>
> +#include <linux/mmu_notifier.h>
>  #include <linux/migrate_mode.h>
>  #include <linux/hugetlb.h>
>  
> @@ -108,6 +109,29 @@ static inline void softleaf_entry_wait_on_locked(softleaf_t entry, spinlock_t *p
>  	spin_unlock(ptl);
>  }
>  
> +enum migrate_vma_info {
> +	MIGRATE_VMA_SELECT_NONE = 0,
> +	MIGRATE_VMA_SELECT_COMPOUND = MIGRATE_VMA_SELECT_NONE,
> +};
> +
> +static inline enum migrate_vma_info hmm_select_migrate(struct hmm_range *range)
> +{
> +	return MIGRATE_VMA_SELECT_NONE;
> +}
> +
> +static inline void hmm_fill_migrate_vma(struct hmm_range *range,
> +					struct vm_area_struct *vma,
> +					unsigned long start,
> +					unsigned long end)
> +{
> +}
> +
> +#ifdef CONFIG_MMU_NOTIFIER
> +static inline struct mm_struct *hmm_range_fault_mm(struct hmm_range *range)
> +{
> +	return range->notifier->mm;
> +}
> +#endif
>  #endif /* CONFIG_MIGRATION */
>  
>  #ifdef CONFIG_NUMA_BALANCING
> @@ -151,7 +175,8 @@ static inline unsigned long migrate_pfn(unsigned long pfn)
>  	return (pfn << MIGRATE_PFN_SHIFT) | MIGRATE_PFN_VALID;
>  }
>  
> -enum migrate_vma_direction {
> +enum migrate_vma_info {
> +	MIGRATE_VMA_SELECT_NONE = 0,
>  	MIGRATE_VMA_SELECT_SYSTEM = 1 << 0,
>  	MIGRATE_VMA_SELECT_DEVICE_PRIVATE = 1 << 1,
>  	MIGRATE_VMA_SELECT_DEVICE_COHERENT = 1 << 2,
> @@ -193,6 +218,29 @@ struct migrate_vma {
>  	struct page		*fault_page;
>  };
>  
> +// TODO: enable migration
> +static inline enum migrate_vma_info hmm_select_migrate(struct hmm_range *range)
> +{
> +	return 0;
> +}
> +
> +#ifdef CONFIG_MMU_NOTIFIER
> +static inline struct mm_struct *hmm_range_fault_mm(struct hmm_range *range)
> +{
> +	return range->notifier ? range->notifier->mm : range->migrate->vma->vm_mm;
> +}
> +#endif
> +
> +static inline void hmm_fill_migrate_vma(struct hmm_range *range,
> +					struct vm_area_struct *vma,
> +					unsigned long start,
> +					unsigned long end)
> +{
> +	range->migrate->vma   = vma;
> +	range->migrate->start = start;
> +	range->migrate->end   = end;
> +}
> +
>  int migrate_vma_setup(struct migrate_vma *args);
>  void migrate_vma_pages(struct migrate_vma *migrate);
>  void migrate_vma_finalize(struct migrate_vma *migrate);
> diff --git a/lib/test_hmm.c b/lib/test_hmm.c
> index 6911daa9f854..cd88e8177d0a 100644
> --- a/lib/test_hmm.c
> +++ b/lib/test_hmm.c
> @@ -145,7 +145,7 @@ static bool dmirror_is_private_zone(struct dmirror_device *mdevice)
>  		HMM_DMIRROR_MEMORY_DEVICE_PRIVATE);
>  }
>  
> -static enum migrate_vma_direction
> +static enum migrate_vma_info
>  dmirror_select_device(struct dmirror *dmirror)
>  {
>  	return (dmirror->mdevice->zone_device_type ==
> diff --git a/mm/hmm.c b/mm/hmm.c
> index 2f1e98c6b644..4e9542aedc25 100644
> --- a/mm/hmm.c
> +++ b/mm/hmm.c
> @@ -21,6 +21,7 @@
>  #include <linux/pagemap.h>
>  #include <linux/leafops.h>
>  #include <linux/hugetlb.h>
> +#include <linux/migrate.h>
>  #include <linux/memremap.h>
>  #include <linux/sched/mm.h>
>  #include <linux/jump_label.h>
> @@ -28,15 +29,23 @@
>  #include <linux/pci-p2pdma.h>
>  #include <linux/mmu_notifier.h>
>  #include <linux/memory_hotplug.h>
> +#include <asm/tlbflush.h>
>  
>  #include "internal.h"
>  
>  struct hmm_vma_walk {
> -	struct hmm_range	*range;
> -	bool			*locked;
> -	unsigned long		last;
> -	unsigned long		end;
> -	unsigned int		required_fault;
> +	struct mmu_notifier_range	mmu_range;
> +	/* Set once mmu_range is armed with mmu_notifier_invalidate_range_start() */
> +	bool				mmu_armed;
> +	struct vm_area_struct		*vma;
> +	struct hmm_range		*range;
> +	unsigned long			start;
> +	unsigned long			end;
> +	unsigned long			last;
> +	/* fault and lock drop related fields */
> +	bool				*mmlocked;
> +	unsigned long			fault_end;
> +	unsigned int			required_fault;
>  };
>  
>  /*
> @@ -95,7 +104,7 @@ static int hmm_record_fault(unsigned long addr, unsigned long end,
>  
>  	WARN_ON_ONCE(!required_fault);
>  	hmm_vma_walk->last = addr;
> -	hmm_vma_walk->end = end;
> +	hmm_vma_walk->fault_end = end;
>  	hmm_vma_walk->required_fault = required_fault;
>  	return HMM_FAULT_PENDING;
>  }
> @@ -400,6 +409,58 @@ static int hmm_vma_handle_absent_pmd(struct mm_walk *walk, unsigned long start,
>  }
>  #endif  /* CONFIG_ARCH_HAS_PMD_SOFTLEAVES */
>  
> +static int hmm_vma_capture_migrate_range(unsigned long start,
> +					 unsigned long end,
> +					 struct mm_walk *walk)
> +{
> +	struct hmm_vma_walk *hmm_vma_walk = walk->private;
> +	struct hmm_range *range = hmm_vma_walk->range;
> +
> +	if (!hmm_select_migrate(range))
> +		return 0;
> +
> +	if (hmm_vma_walk->vma && (hmm_vma_walk->vma != walk->vma))
> +		return -ERANGE;
> +
> +	hmm_vma_walk->vma = walk->vma;

I don't quite follow the check for -ERANGE, it checks for hmm_vma_walk->vma !=
walk->vma, but then set's it later to be the same?

> +
> +	if (end - start > range->end - range->start)
> +		return -ERANGE;
> +

Have we established that end > start and same for range->end > range->start?

> +	if (!hmm_vma_walk->mmu_armed) {
> +		hmm_vma_walk->start = start;
> +		hmm_vma_walk->end = end;

Does the walk range matter here?

> +		mmu_notifier_range_init_owner(&hmm_vma_walk->mmu_range, MMU_NOTIFY_MIGRATE, 0,
> +					      walk->vma->vm_mm, start, end,
> +					      range->dev_private_owner);
> +		mmu_notifier_invalidate_range_start(&hmm_vma_walk->mmu_range);
> +		hmm_vma_walk->mmu_armed = true;
> +	}
> +
> +	return 0;
> +}
> +
> +static void hmm_vma_post_range_fault(struct hmm_vma_walk *hmm_vma_walk)
> +{
> +
> +	struct hmm_range *range = hmm_vma_walk->range;
> +
> +	if (hmm_select_migrate(range) &&
> +	    hmm_vma_walk->mmu_armed) {
> +		/*
> +		 *  The migrate_vma path has the following initialized,
> +		 *  so take care of fault path below.
> +		 */
> +		if (range->notifier) {
> +			hmm_fill_migrate_vma(range,
> +					     hmm_vma_walk->vma,
> +					     hmm_vma_walk->start,
> +					     hmm_vma_walk->end);
> +		}
> +		mmu_notifier_invalidate_range_end(&hmm_vma_walk->mmu_range);
> +	}
> +}
> +
>  static int hmm_vma_walk_pmd(pmd_t *pmdp,
>  			    unsigned long start,
>  			    unsigned long end,
> @@ -594,6 +655,11 @@ static int hmm_vma_walk_test(unsigned long start, unsigned long end,
>  	struct hmm_vma_walk *hmm_vma_walk = walk->private;
>  	struct hmm_range *range = hmm_vma_walk->range;
>  	struct vm_area_struct *vma = walk->vma;
> +	int r;
> +
> +	r = hmm_vma_capture_migrate_range(start, end, walk);
> +	if (r)
> +		return r;
>  
>  	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)) &&
>  	    vma->vm_flags & VM_READ)
> @@ -646,12 +712,12 @@ static int hmm_do_fault(struct mm_struct *mm,
>  			struct hmm_vma_walk *hmm_vma_walk)
>  {
>  	unsigned long addr = hmm_vma_walk->last;
> -	unsigned long end = hmm_vma_walk->end;
> +	unsigned long end = hmm_vma_walk->fault_end;
>  	unsigned int required_fault = hmm_vma_walk->required_fault;
>  	unsigned int fault_flags = FAULT_FLAG_REMOTE;
>  	struct vm_area_struct *vma;
>  
> -	if (hmm_vma_walk->locked)
> +	if (hmm_vma_walk->mmlocked)
>  		fault_flags |= FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
>  
>  	vma = vma_lookup(mm, addr);
> @@ -670,8 +736,8 @@ static int hmm_do_fault(struct mm_struct *mm,
>  		ret = handle_mm_fault(vma, addr, fault_flags, NULL);
>  
>  		if (ret & (VM_FAULT_COMPLETED | VM_FAULT_RETRY)) {
> -			if (hmm_vma_walk->locked)    /* needed by sparse */
> -				*hmm_vma_walk->locked = false;
> +			if (hmm_vma_walk->mmlocked)    /* needed by sparse */
> +				*hmm_vma_walk->mmlocked = false;
>  			else
>  				WARN_ON_ONCE(1);    /* broken fault handler */
>  			return HMM_FAULT_UNLOCKED;
> @@ -694,19 +760,31 @@ static int hmm_range_fault_locked(struct hmm_range *range, bool *locked)
>  {
>  	struct hmm_vma_walk hmm_vma_walk = {
>  		.range = range,
> -		.locked = locked,
> +		.mmlocked = locked,
>  		.last = range->start,
>  	};
> -	struct mm_struct *mm = range->notifier->mm;
> +	/*
> +	 *  Could be serving a device fault or come from migrate
> +	 *  entry point. For the former we have not resolved the vma
> +	 *  yet, and the latter we don't have a notifier (but have a vma).
> +	 *
> +	 */
> +	struct mm_struct *mm = hmm_range_fault_mm(range);
>  	int ret;
>  
> +	/* Migration is incompatible with mmap lock drop */
> +	if (locked && hmm_select_migrate(range))
> +		return -EINVAL;
> +
>  	mmap_assert_locked(mm);
>  
>  	do {
>  		/* If range is no longer valid force retry. */
> -		if (mmu_interval_check_retry(range->notifier,
> -					     range->notifier_seq))
> -			return -EBUSY;
> +		if (range->notifier && mmu_interval_check_retry(range->notifier,
> +								range->notifier_seq)) {
> +			ret =  -EBUSY;
> +			break;
> +		}
>  		ret = walk_page_range(mm, hmm_vma_walk.last, range->end,
>  				      &hmm_walk_ops, &hmm_vma_walk);
>  		/*
> @@ -732,6 +810,8 @@ static int hmm_range_fault_locked(struct hmm_range *range, bool *locked)
>  		 * output, and all >= are still at their input values.
>  		 */
>  	} while (ret == -EBUSY);
> +
> +	hmm_vma_post_range_fault(&hmm_vma_walk);

Have you checked to see if we could end up with notifier start/end inbalance?
For example if hmm_select_migrate returns false?

>  	return ret;
>  }
>  


