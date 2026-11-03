Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43AF7606A335
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 03:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=IJ2eXeYY
Received: by kanga.kvack.org (Postfix)
	id 3856C6B05BB; Mon,  2 Nov 2026 22:46:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35B686B05BC; Mon,  2 Nov 2026 22:46:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 274686B05BD; Mon,  2 Nov 2026 22:46:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EC7A16B05BB
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 22:46:40 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 72A79A023F
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:46:40 +0000 (UTC)
X-FDA: 85392420960.30.B73AC92
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010056.outbound.protection.outlook.com [52.101.193.56])
	by imf09.hostedemail.com (Postfix) with ESMTP id BC429140005
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:46:37 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=IJ2eXeYY;
	spf=pass (imf09.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.56 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793677597;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pyxe9BJ4trPYIv57AxgZqUysPagmUKFnFPYKXnN+IKI=;
	b=q/3xy9Sc5a7+TG+KSca7cZy2oEH+thXVjERnyZVdGwDjCgTPUP4w86onwr/X12uli95aKX
	TE/GiLZG6n8n8vDi+/VUtCBg2ncIbkbnd5kWjoTVjCmr+TuMgJwgwcptpFSujJFPw4Lvgu
	M+9McNyRTpFolUFt5VznwaxjJ6+LQ2E=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793677597;
	b=QAA171xXaDYCDhTOsFlS/n4pVwlVh4pNRsppePqq0ThClcWAT/SibvzE5Na4Kg32MzIzoO
	Ylepp4URWzsoH7R4x+R+KfKCgbzPjFv0qZ6/dsWXwMMyGvgFXVSv9MTF/llfaFC5xvpDHj
	veiFrqJVF1aBAKYEVi8pWA5MMmSwFXU=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=IJ2eXeYY;
	spf=pass (imf09.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.56 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wYkRkuH6U6yB6e2FFfx8BDCErhmWn3S/HwbFDP/oAkWt2itlCGlZo5PVRsy2jDibodC3pmgd0vkJLWtFQzSO8XNGc34kdJ+RFU/8dEDqju3Wm5LiLS0kt3HHl0oe1KPWwniuIgXjzuYkpJAIEm7qnSCR4Y8HmOAUD3RnMJOxFXhznvVkZWsAEwQa9scWRt4S87jYxcPZYqhTrVPyhje0aGkc4Kc1LoVQYYD8UIGCKWzJ9k9IbO3xEMPDTeN2fFdcqlNI/yY4DEdG2M3IJv3QkjjWOtGmkuWrOWXF+whDN4phY0VcsxJc03z2X+423evwbSzDSUrK6+lXCoGz0g6c2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pyxe9BJ4trPYIv57AxgZqUysPagmUKFnFPYKXnN+IKI=;
 b=fIfZllZZRBmt4HHJ6pgD3Fs3joiAg0il5RAAMesjjSFbopWanxSSE+UcfPrs7bN9m3kNT9/hZ7IhkxIg5nZJUfD62HK25OyhSosJicrRJ8jN901+yJQDHXQrZrK79sXNBGcM4z5Al7wULGaXfNkdHKiYWh/QcljMsSaN2PGScwn+wgL26SSTEl4UD0FsFo8BI/0KuPnSAFmlRsygzy0SwV3kD8mCUnM9hHls5xWR/P5FCVxRn3sX6CAc0yXk/L3j5jr19HjLzP0O2afN2MkVMhiDPEbm9fVHh7g5g4b4+hg2Dt8aSQBAPno5Z1YY+H7ROIj/QZkKD4cR6k5+iG/0eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pyxe9BJ4trPYIv57AxgZqUysPagmUKFnFPYKXnN+IKI=;
 b=IJ2eXeYYQTBeMRF9KmfPS7uadxDFyH2BDQUx1RwZdZ3AEYe0PzkOU726FvI8juIWKwMuIoORVYyD0YfStFZ2V+JJBVA3GIsRiGBk/u6kXFSAYPxqOX7AyvW5TvN70WS2I/CVG5QeCVd1BLwx+yCUSvFXEeVQFxIWKfYIx4qv8c8OQ+CG4aT1jyr0hTFAmPRGb+sNY+nHaORV5hdVMK/Eh/C3eNXTXyikCNFS0QYZPjQbuicbiS+KS7PaWjxCV8Sez3zONeLoJNQvU+u/9cA63GGcstCi7j44mwfH3PsVFXL7EQbQ/In3oTb9FKIdKWzjvFW2R/lxj2kSah5qcp4SOA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DM4PR12MB5890.namprd12.prod.outlook.com (2603:10b6:8:66::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.10; Tue, 3 Nov
 2026 03:46:31 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0569.011; Tue, 3 Nov 2026
 03:46:31 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 02 Nov 2026 22:46:29 -0500
Message-Id: <DML9N19HM19L.1PDQBUPSX3RQT@nvidia.com>
Cc: <linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>
To: "Tal Zussman" <tz2294@columbia.edu>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, "Jan Kara" <jack@suse.cz>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 "Vlastimil Babka" <vbabka@kernel.org>, "Mike Rapoport" <rppt@kernel.org>,
 "Suren Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>,
 "Matthew Brost" <matthew.brost@intel.com>, "Joshua Hahn"
 <joshua.hahnjy@gmail.com>, "Byungchul Park" <byungchul@sk.com>, "Gregory
 Price" <gourry@gourry.net>, "Ying Huang" <ying.huang@linux.alibaba.com>,
 "Alistair Popple" <apopple@nvidia.com>, "Jason Gunthorpe" <jgg@ziepe.ca>,
 "John Hubbard" <jhubbard@nvidia.com>, "Peter Xu" <peterx@redhat.com>, "Hugh
 Dickins" <hughd@google.com>, "Baolin Wang" <baolin.wang@linux.alibaba.com>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH 7/8] mm: remove read_cache_page_gfp()
X-Mailer: aerc 0.22.0
References: <20261102-page-wrappers-v1-0-e7280bdb31f6@columbia.edu>
 <20261102-page-wrappers-v1-7-e7280bdb31f6@columbia.edu>
In-Reply-To: <20261102-page-wrappers-v1-7-e7280bdb31f6@columbia.edu>
X-ClientProxiedBy: BN0PR10CA0027.namprd10.prod.outlook.com
 (2603:10b6:408:143::28) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DM4PR12MB5890:EE_
X-MS-Office365-Filtering-Correlation-Id: 028be32c-986d-4f9b-26fa-08df395d0c66
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|23010399003|1800799024|18002099003|261102123227099003|22082099003|921020|10067099003|4143699003|11063799006|261021121427099003|261021123027099003|261022075727099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	AORhaMLXjpWKlYEmd0U+iVMOqNuQsH2jZEuvzFIOiogiYQpmmdMXfyC61+1DBX4a0ookr85iEvUQNo6M8JrzJ89wUfHm8PkURwTuVc12K682aVgnQF2koiKbepIi8DBU04IE80jM+IvxHytT7xspUTd2fQbjXjvNMfA/DiEO5vEp1OdTPST8HwdRpSh91xbw4jA8X0vs1CWpT3xdXvCg5kIkIOIVoT5sGZY6QPP6ifnDG+iyOGtWR9O6/F/My5f5Rm/jeDnzooVdxt0LWFHvmWTxurDaSsUuO286HyeM8hSFMCb40MWe7bnh3MV1G4ksgojZ0UtxQN+wHRzKpJ/6Oq5MSGEgLiw+aishfyTw7bzdgyCAL4l/bZUncY69LeDMALezTgq2+X0C4SR8quVZ/f9zMg1xv+wGB6T1205qp2IoxHh+pi1Q1KlpjnEiWTcQn797N8n+HPCAsZhRhEsCyfy47Xr6ZNS5yduHKb8U2+2qUAhBfbu87YjgloiDsB87KnjiB0o5SjVmXYHQTQ1EoG5en00Ie+YvAi9c2BjctgSN0r/ZtAC4Hn/Syt+U0Oa8EmvaBZCE0D2o5ZL50+TNQwxL2oclEocYZtKE7/+Tb5B/MD2YaiuFu3uLYwj7CdjVmrXrH9LD5Kr58W7ptjLrqx8RV8GSXgjaLYZg7zLMP99coksTfPWZcBR4Tijle7VK/G3i/bBKI7b3FrKHpko04g==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(23010399003)(1800799024)(18002099003)(261102123227099003)(22082099003)(921020)(10067099003)(4143699003)(11063799006)(261021121427099003)(261021123027099003)(261022075727099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Zm0zRVFwMDFZVDBZSDZER0M1STBRNE1BQXNnQkRrcmdSVUVMQjJmYkZrd0FP?=
 =?utf-8?B?d1o5QUFPUWo3VjBkMnI3d0l2SXRVem1LWGNZWHJUQkdNN2MxaEQ2MzQvQ3Fs?=
 =?utf-8?B?RVRvNlJYMHFHU0pFWnJna1U1Q3RVVk4wbmc1WjNmMFN6QVpTUE5vaXFNSW9n?=
 =?utf-8?B?d3AzdXV3cDUwSUZQVVU5Sk13SFFHZWxVMGV2eWkrMitUVzd5NmJVeUtIc2xL?=
 =?utf-8?B?WEFuVFNtWmFkS1VEYS82alByZWNhMElUVjFLMkRVdFYyN3p3aU1KQldvcEts?=
 =?utf-8?B?VHZyeTRGS2tZcUE3cmNxT2RmSlQrNHdFSWRzcGFpdkwxbWlGSGh0bXhtR2d1?=
 =?utf-8?B?S2Z4SVp0dzd6VjF1RFlha3psTXR3eVI4RThjSmZxZ2JmZmZ0czFvb2t4U0tO?=
 =?utf-8?B?K2ROQkNxc0lJYkxHK0VEOFFvV0NvYkZ6SUV3WVl3N2laYnNYV3pDQnI0UWJ0?=
 =?utf-8?B?Qi9LTEtsSFd2czVocnBPYzdsQWFQa1NuR2xpMDlpZ3ZLQ0ZXTGR3cDNwaW5J?=
 =?utf-8?B?WXhSKzY0b21WaTdyWC9STGxVWm9SbW03V2VXQ2N5TmdJcXp0RndxaE9MLzBH?=
 =?utf-8?B?YzVmd01JMHFJRHgrTEhka3FUWHlIZkJmZWpxN2w3M0ZUSCtmckMzK0Rra1Q3?=
 =?utf-8?B?WFowcWdNUllONFRhaEhYSTN2YkYraEVCb21CMnJnOUxDL2p6YlhJNzJXQ25F?=
 =?utf-8?B?enorSWxvb2tvaG8zaGdSWUVVWnBNVjUzWll1SUdQK1BpVGlMUU83SFNaZE1i?=
 =?utf-8?B?bE02TUFnT2dSeGd2YUxpdEtsei9aZ21RWlJPSGdHQVdXanpOdkt6VnlTUjBj?=
 =?utf-8?B?OFR3QmE2Sm9mSk9iTGRzVzF2YTNUTnArV0lIbXdFQkprbnJpVG94K3BPaHcr?=
 =?utf-8?B?VzlGaHdKTG5JZ3Z6MnNBYzM3cU5ZaFZLdzdnSTJveWFNM1hTSHJPeTk5Sml5?=
 =?utf-8?B?aFN5YXpSenR5ZzlZZlZzbmxNR3ZJSGk4YXIxbTBtRDBiWWVJQmJ6K0dnNndJ?=
 =?utf-8?B?OUZBdlZhUGlzVUVQdXNwRUQxUzBvazJYTHBsOHl2RHY1dW02ZTJ4dHQrdzAy?=
 =?utf-8?B?MTQ2d0FMMFBqc2luUkxyaGdIOFVwMEJlbzlWQmJaTVo3elE4ZW4wVXdHTTZ4?=
 =?utf-8?B?NUE0ampUUEwvVFliS041SWZKenQ3NGxwK0tEbnI2VXFTUTJDU05Ga0w3ckdO?=
 =?utf-8?B?UXYyQlJxTEdlMWlNaFNoUHlKZ2Q4MTE2VGh1NUNzRzgzVW1jcDltUXgybHB6?=
 =?utf-8?B?UjJ6UUFiQ2NFOGVLNXcrbkRrWW5zV1pZM2NwWDJZdWl5eTRzU0NMNHJmR2Zv?=
 =?utf-8?B?aWxQaXR4VGlYNHhXS0JrM3F1ZW9PWHBWaTFUd0tDQm5tT0gzT3pyQy8yZGh4?=
 =?utf-8?B?cWRsdkdML210KzVCeUV4SzBNdUtGK1Z0MGNKTFVOQWtWNC96N1MrVXJ3REsx?=
 =?utf-8?B?NXJ6V0pkc0d2a3VpQWZLeFd2QU1oekZMN2NONFZsM0FpL0REZHY0RUF6d0xZ?=
 =?utf-8?B?czlEMjlzMnJRRFNaL0I1R1dGcXpOQ3FZUnFFQVlMSC96ZWtnblBWRU96aHRw?=
 =?utf-8?B?VGFnN3NRK09EWU1GQndOU1E0Q1hWZHp1R2U5MGhrVnJDb0xlRHZ6aXVxc3Vi?=
 =?utf-8?B?dnlCSFhXZ0p6VGlqcDJGYktrZXh3MkpNbFI2VXJ5N24yZjVjblNVL096Wmty?=
 =?utf-8?B?emxNSlczTzVJTXQwYTNmRjBqZDZhTENCc2NMZERBSW1pdzI1WTdiakNVNHBO?=
 =?utf-8?B?RThFenNOdHV3MHVtcUd2VzRSd2hKeVJGZ2RaaXFJS1BZaEdnTnhuQmZyVVBT?=
 =?utf-8?B?QlRmWFBCV1RjMVkvZGxhZVoxSStOMnRaaTVzaVNtNk9KMVkrcVIyTi9wSDZq?=
 =?utf-8?B?bjBDYWU0Z3VlQS95QWpaeWlmUzViMitXSFhJaEp3YUNyaUVvd2YxMnFCQWY1?=
 =?utf-8?B?SUE2YmZ1czc1WTFDZE1WaSsxQTdvM1R1b0kxL28wclFMQ0VJbXNNNmp6eThM?=
 =?utf-8?B?Q2N3ZDhndVRJZkNrOENnNTZkUUtiU3lHaEFBTktCZ0xUM1Y3UkRIbWhSQVli?=
 =?utf-8?B?STBuYVFJbzhPV3JiaC9rd0thcHJuSVlscGNPdkdkV011WXRJRWpsSFlrbGQ3?=
 =?utf-8?B?WVhacjYyK05seXVkdVBlV1JrYm9zTGhGYzlTMkZXRTd5ZWRhTDFJSVFVbnhD?=
 =?utf-8?B?cnRLRkMwMmFONXBiT0FObW5hYWhCYVZqWU1xVjVlZW51bTdELzdYMGhEL1R2?=
 =?utf-8?B?NTZsazIzSFUvaEdXeEpkb1ZadXFVcm15NFNKS3ozQktaS2NqcUNwaHVhOFhG?=
 =?utf-8?Q?89HJsqyS+s2dVuHcCt?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 028be32c-986d-4f9b-26fa-08df395d0c66
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 03:46:31.3552
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YYMWpGRI+Q0gr8kfZ5SFVJ7OEU2tZCK4iDXcqe7C6ylp+X4ToGobAOxkp9D9qe+b
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5890
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: qu33sg9j58fwt4p9bfb4n5i1iknnd18g
X-Rspamd-Queue-Id: BC429140005
X-Rspam-User: 
X-HE-Tag: 1793677597-766702
X-HE-Meta: U2FsdGVkX18PxHSqWiL00YAcX2oF6rE6DIklZT82BqOVkSqGpThPH0zv/AaN6Ry57h5hKyCWfpHDSfkhqq+U+heVgKIsRhSACAHK5DSr/bvJf+tQLTH88pdk5oqqESesZo9548CwNmLQkLiQ1zJaJJyuxDJuvsI4kcJBEkSMjFNL6Y0ulxmWx+BOJdkg19FbdeBsfHScVEb5XCd38rBQJztD8L5d1j1vB6LJn/MnCybJeni0Hjj4hC+Wl/8wlg2xBFn1A+yhmzkVxIIrms98s+ekowC3tg4JFPTNmtPKU95q9w+ChZIzjqDkWXdrx21+OLQpi5TkOq40hOeXhX9y0X8zzALFq5PCsJ/r/zyj2inQ5XSUerb5LdzjEiA8wP5pZsj7ZCE6SfvZ2tWr/FTVnnf8NDjU5EWMCiBJOnOA4HqRa7o7gjQZ3QfQEkHwqdKZqOMnKFaFU/bYyuNGXKI02UAX8Ub94XKq1xGF6/OVkDWLIIW0+Ayhwz+KiBtNEJw92IYtlD+fgnpxBa/LVHcRIkme3uqvbUsuG4vNU3fCwgLeFcvnOeyrjUTiZ6UoEoRhFbI1aNvr/UvF1GzbMwr0OT8hDpDqjIqbCouo8++4zEqWpUwFfPC1Wuei3UFdUNDsaShU1Cs7AySCbuUeeM0qXHkT7fhEyK1A3CIWAv7oD7qqTDwHMmlPoqNhuJaaYeUSqIdzSNpXiNF4HZ0vnLKZ7V8fHtxAJy/7A8JVcqjuzgl5TgokYnHuC2/je8ActbjICJly+LIIUcjZTcv+e3mzFIBsNG/QJtiQiPN1T4AIzfV5lQ6o5bgqto7mv3rT9dq5KCUuUvrgnoLzI/LcWeqNcPiflbX9YI1w57jlhZvzZ3cZbyNuiM1Re1KshoHFq7ILV/0dGXp7zaHouSPEJpcuO4zLiqKP/bsJWDj7Oo1DSywMQweRysdQc8nYwuLm217MpkrehT59qHw++M0DTnP
 8egERfHQ
 +jeZy5c6RqdCj59/jkOnMJ/v5k18THdwVtp+nScNr5JZ2YrnJJ4yl3YZPzeVbBiZ/YqBS9trfXMpXGOkBwN9Z99BB9iiTTcrfB/aWn1g/glxv9CA+aaWkdED8Kltd1I0tMe+qqr80pyrJ4Fr+8oRVzrmVP94MbvRYQfUhwBS22jlknQMRdXhW4X7Pd6PNtzzBYGqSSXGydoTIeKOFn+5jxlX/QOL2nrhu8gb4OKwrInBSdzf8TZckXg0SJwqLv46NKG9VTkxERJQp5vktcPrvMDFcC9IORNJ2bhmH5IUYQAS5Q1qnEglicA3oNxD3QX/Js0eeq5YwByghqxT2ONfUi9f66C2aXMI3iLQS757Hvl2BhD5Yhxl4b5LySbL4IGGEKM9rATvCmZ23IftRZp7Cx9LfCiRvkRkUTJjCjWWUy8X/+RuejYBoDUWY7n7WRWyrs6B3r7MmsNZ425Ca4mPNyGz5wSciUKmH+Z2PCY8276D1CppHhzCeDyq+Ol/QaipNYAzTBu2W/eYkYS8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon Nov 2, 2026 at 5:54 PM EST, Tal Zussman wrote:
> There are no callers left. Point the comment on shmem_read_folio_gfp()
> at mapping_read_folio_gfp() instead.
>
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> ---
>  include/linux/pagemap.h |  2 --
>  mm/filemap.c            | 23 -----------------------
>  mm/shmem.c              |  4 ++--
>  3 files changed, 2 insertions(+), 27 deletions(-)
>
Acked-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi


