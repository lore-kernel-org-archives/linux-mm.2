Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E64B7606A320
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 02:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=l8L6gwwp
Received: by kanga.kvack.org (Postfix)
	id EE2EA6B05B3; Mon, 26 Oct 2026 22:13:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E94F46B05B4; Mon, 26 Oct 2026 22:13:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5B376B05B5; Mon, 26 Oct 2026 22:13:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A81196B05B3
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 22:13:02 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0A7BD120967
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 02:13:01 +0000 (UTC)
X-FDA: 85366783362.11.DADAD06
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010016.outbound.protection.outlook.com [52.101.85.16])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1207620006
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 02:12:57 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=l8L6gwwp;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.16 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793067178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jIqT3NsRXLi083h5iiBjs8CGuLcymJCfbkMmyWuMYxA=;
	b=8dNoOE2njrAFN0iNnbIcQcRJ4EZ0wXHj4I17Ef982Q1Qes3xxpQvuIyiLzTgNm6WZSIknM
	1TmcM6xupHymTlKzhRBOKtyhZ8+Gd+ZJMTokJwAHLyzsTI5IudvT+6pEPD4SCpTKcWhkbV
	8QaGeSkagD2ZxTCWMOpxw5vEcoao2OU=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=l8L6gwwp;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.16 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793067178;
	b=qh7mhBx+gj0t9yd0eMldH3DFVYW+/FbgQX86kkWOeZsk0j39qh+7v8KpmNpVGIIhAlphXr
	ztgFvSBM+ffTr/j7bh/xOUjXsQtwOmElkY4yymeNlsZEeM3+fX4JM9IFHdF7EiC/jbME6q
	Takoez+sO9/tM/LO/l41CMecilwrG2Q=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MFA5VF+ZrXuohGfCZ5ashSQ+/sE4Q7sptOjZEVWstmDlpZu7chokluTipf72M2NECpsyK7W9ty7OxDQvPpZnDWm0SAQ6poWujrubHF8wa7Ms0ED0EQ7eCyX/ul7a2mrD+rre0uY6IdOOT0Z3VxVB1fcxfMmDuQh+Phr6b9Ca7NBBi7+/KfZ4rHRZp+71RWanllGwy85JGlIf77+gqbW92LeCB1xyDbhGWr18+NuL6GDi+mTx1FLpd+yWzTlbNV7MbrXkloHy/n83qwmH6bEAk23GeHma0Z5rP6wf0wS1ozmY/As/ABPMJ2iRwa//C71YbYaDynsS2Xno/xLwqDmCbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jIqT3NsRXLi083h5iiBjs8CGuLcymJCfbkMmyWuMYxA=;
 b=c/jZNmzoc5BAQjAKEBI6GjljX2fA1e3X5XL4BtBn5/5MZ0vINfGnHpHoy5Sk/FfzX3tcLHF7VmNZbhYWSFQMbF8wPwbifobMWMn89Jb8I7BE8oZPoYl1GX9lMywamfdjZCA3D2Pfg/0gMWqrLilVa61rkHzetRelbKGpNfZnr4tR4A9AoglDErpLlLG3Z1PKJmuk1FooGe1FfdPBUu1O0FulsrvZqZBdTxXwVu36d1nh7vbdcohJoxoHMqMyp7Y1bg/lyhLzNMprM2/Cj2w8ySYTW4A8rQkL9tYL3wv1iWV0y6XOvRKZTJTPoqcaK35B+VJO1B2WHDfZn/QjzTI3kA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jIqT3NsRXLi083h5iiBjs8CGuLcymJCfbkMmyWuMYxA=;
 b=l8L6gwwp8v4J0z0zedP+zGD6xl1ybYwAU6P33Esd9WouPkPRU5siGpX3GpyHnIQPs5s+yvchJJ24yvKl6ZtLjhhqUVkqBNBtK+DwUJEE/ijuXI0epOxgx/PbHj/NCb7BSQKamSpsgTqmNu/eRmgsp7CQbsROXDVkqu3AVER2cQFZLdq5aBNFTeiNNhTCcQ6XchlGPcvkamE3LaXQHOoeapvSgY/TMDaicAOV9ABGEULn25G/Ho7rqV4PiZ2zUToI/3wzDnHWFyKjzugBaljpV6sGIj81FP+QazOED1Uu1FKzTYIpBJKUg9Anwl3d5WQs1BBVvVRVzgwX5FbnKjX0GA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CH3PR12MB7737.namprd12.prod.outlook.com (2603:10b6:610:14d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Tue, 27 Oct
 2026 02:12:49 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0546.021; Tue, 27 Oct 2026
 02:12:49 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 26 Oct 2026 22:12:46 -0400
Message-Id: <DMF99GOETE2A.D9QBKCNH0MNG@nvidia.com>
Subject: Re: [PATCH 10/16] mm/shmem: discard whole new large folios on
 fallocate rollback
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <stable@vger.kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Gregory Price" <gourry@gourry.net>, "Joshua
 Hahn" <joshua.hahnjy@gmail.com>, "Rakie Kim" <rakie.kim@sk.com>, "Ying
 Huang" <ying.huang@linux.alibaba.com>, "Johannes Weiner"
 <hannes@cmpxchg.org>, "Vladimir Davydov" <vdavydov.dev@gmail.com>, "Michal
 Hocko" <mhocko@suse.com>, "Hugh Dickins" <hughd@google.com>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Lukas Czerner" <lczerner@redhat.com>,
 "Carlos Maiolino" <cmaiolino@redhat.com>, "Christian Brauner"
 <brauner@kernel.org>, "Jan Kara" <jack@suse.cz>, "Daniel Verkamp"
 <dverkamp@chromium.org>, "Jeff Xu" <jeffxu@google.com>, "Muchun Song"
 <muchun.song@linux.dev>, "Oscar Salvador" <osalvador@suse.de>, "David
 Stevens" <stevensd@chromium.org>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, "William Kucharski" <william.kucharski@oracle.com>,
 "Chris Li" <chrisl@kernel.org>, "Kairui Song" <kasong@tencent.com>, "Nhat
 Pham" <nphamcs@gmail.com>, "Miaohe Lin" <linmiaohe@huawei.com>, "Naoya
 Horiguchi" <nao.horiguchi@gmail.com>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.22.0
References: <20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org>
 <20261026-fixes_shmem-v1-10-703206d5fa0c@kernel.org>
In-Reply-To: <20261026-fixes_shmem-v1-10-703206d5fa0c@kernel.org>
X-ClientProxiedBy: CH0PR03CA0028.namprd03.prod.outlook.com
 (2603:10b6:610:b0::33) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CH3PR12MB7737:EE_
X-MS-Office365-Filtering-Correlation-Id: c72f6fd3-e6bd-4fe7-2921-08df33cfcc50
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|23010399003|7416014|1800799024|22082099003|18002099003|261026121527099003|921020|56012099006|4143699003|11063799006|261021123027099003|261021121427099003|10067099003|261022105027099003|261009223027099003|261026140227099003;
X-Microsoft-Antispam-Message-Info:
	5R4Kafz7Y51Upmqqf6VsUJreXI36cLXYtGH9xO9H0lMWXmE+k7CekhS5KhS/Kfuh4JhspD+Ys9kqdc7pOlDk7jhyK1fWoHrY/pV3wTGeeuJ3qRL60mbOlw1tD+fIcxxd8Z3HcvdK9Kqh3tgff+fiVjZnHOAvyh6JcwfTod/I5uJEHS6Y3yerVfmB71AwWjWotBqLbggayLNY09aSqzIBK8tDTJuC7bvjvCBOQaT0Hw1iZt2eOykRBQV+RhgmlKFrc0aycgoDX+OO8o11zv8W4hXNpfn8NxYXqbeS8Yb0oHkiQQVeM1S263Ymp0TBzyPA5dsVwukuMb32VQa7FR1C/EmFnvk3z5+bzFtqJTCU6Fqi7gl3P3mk/l+OPovaZMzz8mDbG0Yy5FIuP5IjbY+jZ7yYwJ3fhJOsmOIV/2L4zh5bNDCQ+xXCliDFOCrZ8vmCj+9CeXXH88jkmByx+3z2L2dHxDOXSj8ATF7yKlvlcA/NIEfwQWtd2JcUFDzVYln2ZiROUAORq9NkoeQUwe1QCpRLtQvVm5OpgpSQ/hPWpr+loVACKnsHTigZXkUOS0mg9KjPvbGKylBH2uGTrlARWzgvctmPdvLVwyXdB9tTxQx0Rt/Fesgf8jdzYgjsnYvpkwNBDAvXcffiXPUeyYssyjIDElay2F9HH4+AaaoakxxeqKVw5dfHbulu+EamSomDldyOYLkE4Q95Pg0cD08NwA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(23010399003)(7416014)(1800799024)(22082099003)(18002099003)(261026121527099003)(921020)(56012099006)(4143699003)(11063799006)(261021123027099003)(261021121427099003)(10067099003)(261022105027099003)(261009223027099003)(261026140227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RVp1ODVPNTlHL0x6NXJJeGRoN01ZMTVyNjlIU2NLODF5OVlqTmdnQjZkcGFS?=
 =?utf-8?B?SU1VT3FQMVZDY1FNK2hPR0xiSEplcFNoNWo4Q3A4c2xUNHU2VkQ4U1JHb2wr?=
 =?utf-8?B?WjV3b0xoWDdSaFc5TnJYTGp3bmJqdlZCRVdBcXdkS0JTRWZOQUxDcEFVTGl4?=
 =?utf-8?B?VXBpTEs5elFKN3RVRmZvcmxVbW15OUxRNGlYMUhPNWFQcGNiN2dDK05HYnRP?=
 =?utf-8?B?eGNaSWxjQWV0R2NMZUJ6ajdUaitTYmVyNjhaWjRmNitpaTliekY2YjNxZmlZ?=
 =?utf-8?B?OXM2Vjh3MWJjZ1VTNGxWeExaT21HVGpRSVc3dDdlTVNyb1Q0YVlURWZFeEhO?=
 =?utf-8?B?UStsZ1RXaE90WmRCZGh3NWUwVC9zOFJYOElkWUVLdnFZYkROTUZSMitKS3No?=
 =?utf-8?B?OUllcWdzL1lEVDA0WUVuTHJtMXgxSXhMZERVMFNGRjFYc2kzWDQzaG45Yms2?=
 =?utf-8?B?ZXZMSSt1dEl4aHlzZDRQQ1c4ZTRaTUZaRGV2ZE83alZOSlZmVk1iRmYxTDhw?=
 =?utf-8?B?alhkZDZta1hobDlBcUphQmtqQUJ0TXo4RmEyNzJTSzZxSlY2MW9qY3R3V2Nt?=
 =?utf-8?B?T1FFZzlkZ016cFZ6VjdSMVQ1aE42aTZjNVpxdEdhYnZuajA4QllhM0loWk0x?=
 =?utf-8?B?ejRoZEdzM0M0TklraXloaW8rVGtyZGptd1VsUUpVdjJWa0dDYWhlaDBJczV1?=
 =?utf-8?B?clpHZjBoNGN3bGVXZXZpS1FtdjFWUVRuSEsyT2l5a2FmU2ZJV3NOTUJxZll3?=
 =?utf-8?B?ZHJXS0ZmcFp2Mk1rU2JqaXd5alVkVFdrUXd5dEFMMmx5ejVPOTZsb1BPUzND?=
 =?utf-8?B?L2p0SmNxL21LM0Q0ZmtvQTBscGRVZ2U1Q000ajFtS09CQStkbndTMFg0SXhk?=
 =?utf-8?B?bEhIbDEvTE11RUJ2QS9KRUZ0T3M1Y0JkZytGcUZsVVBSVmNwemZRb0ZEbHNM?=
 =?utf-8?B?akhYcnFJNWhaQzVDRUhibnFJZi9ib05kdDhYeVZiMVZhc2oxSW1qd0RXclJ4?=
 =?utf-8?B?c3VmTnRoNTVYbVVMWGtqeTdSS2lBUWZxajBCNTR6N3ZSVDhhc3ltNm9hbjRH?=
 =?utf-8?B?aDBLMU9CdXhwbU5zakQ3TzBXeW12WE5rMmVPSEdiZm8wWXg3QVMyWHc4VFAr?=
 =?utf-8?B?cytHVXllRkFoQlBONjJrMGxCdGJlQllERlBpR2JHZ2tDMXcreEtHNk9BdVpt?=
 =?utf-8?B?LythWWx5cldMSG5aSmtabEh4N0lQQnQwRDBZTm1YdDc4U3N6QU5UOHdxVVFi?=
 =?utf-8?B?L2FtR3VzblVDSWRYaXBmbzV0NWwxYVJDMzdmQkZlbkUwRDl2VlppTm9IYjhX?=
 =?utf-8?B?aCtHdk5MZGs1RGlOVGRjb1NuK0VrSUtRT1M5emo5amIrMzJIdWRnTDhETUJi?=
 =?utf-8?B?VGl2T1ZBRkM5QU5ZeTJJemJNSXIza3BvcUN3RTE5V3JNSXRoQVRUZHh1bVdo?=
 =?utf-8?B?VlYvOUhLcDcyM2M3MUplUVNCc0JmM2Ira0lLWmczMnlGRTBFMzViSDd6RUM2?=
 =?utf-8?B?M2pOMWREMThEdXBYdDhETTY5MTNvUTJhMVlKaUlMWHFqTzV6VUFyVk5qTDlK?=
 =?utf-8?B?V1JmTVBSMWVhRWZHZk44QjhGRjFDcGU2NWxmVE5GdlBZMFpXQmJYbDljc3NZ?=
 =?utf-8?B?OW5YMms1MHNZbHZCaEZDdGRwc1dheEhOQXJmSHNXaUJlaGF3MFc3TUY3Y1FO?=
 =?utf-8?B?WjVZbmRBMTVQbU1uZkJLTElJcDlZYzhYSWtOdXBncEpyeVBlOGNsWmNhZmoz?=
 =?utf-8?B?UnVDWGswWTlVeDE4OFZMYUhsanMzWXRzdFptaFd5WUtObFRIQ0tUNUxPMVQv?=
 =?utf-8?B?ZHBtSlVJTlNQNEpHUDZucjh5WEFCZWx4V0ZVNEw3TVB3NXlJRFEzQ3Fudmk0?=
 =?utf-8?B?Vmk1aEtFQkNnRlRka3M3ckhwK1FFUUd1eXJxYnU4WExLSTdtR2lRN2lIUHdv?=
 =?utf-8?B?dVQvZWlnRkVaUnRyaDU1N0YwU0lsRXVoYVd5a2lYRm1EakpSSnNHdUJwbnVi?=
 =?utf-8?B?TmJ3aU1MZS9SeFhGbU5oZEZ1STRCK2kraU1UZTZDMHYxdXpYS3ZiSzJacFpG?=
 =?utf-8?B?UlZmaTl1azBWNWIxbE5xOWZldW5Rak5mMUpoL3VSU2NNMnFHejI3TkJEYW41?=
 =?utf-8?B?dFpESS8zNWxRNTE0L2NsT2dKUXU5NktnTVBLeVFYdTJ1dnRKQVJ0V1dmaDNE?=
 =?utf-8?B?a3hRMk0rMUJRZURlRUZEbUt5MFlYc256RnpNMHp5V2pISHlpR2RQaWNmZHZi?=
 =?utf-8?B?aGhEbjdHUmlNWkJVeEJncXdjSUtuQVl2TU9pQ3I2VkdoWHQwSWJHS0M0bjFL?=
 =?utf-8?Q?ZjdhkQO/1EEkGpk/+k?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c72f6fd3-e6bd-4fe7-2921-08df33cfcc50
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2026 02:12:49.0188
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h7FfGvsY7JCRGFIVzoh5sTD+W9x1PZuXQweFHpYZMqZ0XhV3JI9x9YvYy29sRRdY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7737
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1207620006
X-Stat-Signature: qbx8xmxrfkb9hij4qcdssd5iximnkhrz
X-Rspam-User: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793067177-406865
X-HE-Meta: U2FsdGVkX19geCQmrjbNNGVPhj0u14C4UxUkyTd3N8g5hVkNITd5LAFWouKW1bstRLG1kUtL6fECR7b/ThLWJ4K1RgC+VPAa0tfyBqt8Q1lRk5bCqiFmKA5umwyEz9DbmJIqajubamoUoFc207lu/rxGnRdkllkf9Ld8re/8q2GByRz/9uWplwEmmocyptlOcY1/F6vc1/RS1mXN1m6v8r85C/Ko0wKsLtT61x0g1g0PVN8Da0hxFketGwMchVtyRv8RrgOwbRTRt81OLbH3mojNDcOb1vFVxg/ewhZKYIxB/Zfhh3PxsqY51wyslc+tcqytHkgk2B5Nqm8D8eSl5XIwHRXEQAKGAeC6k+djvCsVANIeqoZ4+kQR7+pA/qFpXAhqSHg7P51RytsfajCO7TPwLGds4iqst05D3OdZ8cWLpbC4RO8u+OlIy1bBf6i/qh8WtDA0D/2wtCs97E+xvHxdYdQ/eeDZalSkUsjdZcFmFlYjXIUuncUoV5IfAbvIp1S6skjSFqGqK+AuomLZ2wmJ6LZYFpeAAQPQIVJqCoZFi3g8SRjCO0SdbnKK7zSUwghNk+zOxwsuSYqh5a+yrzWo+MIZnmQKbRkOHr+z2tiPbCGg6coTYA2YRd/X/7C+u615v9eTffLcBHS+TRK4rfgfMpJFQQSXmYCpY+RnTWXyFJAi0m/Blw7cph/cqjF3fasYWg9dFrV7f9U1/Bau1kzDFrJtN5LnOfX5jmGxxWSz30zPyJGnVo609DodfTrZqUpY6QbaExKXRB7ldR7RotTgeksAaL/eMEWUEDdHwos1waJ0n23+IQ+eiFrbW1kvHpv0FE8TUkYP+HgFl2L4ESIdJDPmY8KK9l6hk5IczaYCg7i0e63RevMuy++YQFbe5GUZNMlPZRaxdGXXRARoBf5s1wv6+QRWQjawGRiuGWZ2RZtmKVtmm+LGzrrVQ8waYd+sFplAlndoAIi06Gb
 svJuDkwY
 ngoYFo+X5Qrl3L5yskzKOcNmBNqy61SYVCcUY788r7S/PrvOtv19KNilqx2CP+uxl1Z3WRVmBv5p7kC/O5HGRAk9vyuRFKroXbNAGo8q/1lo5gruEQSdMHEFun+GFUfyMiQoGhL6txzlRqPuLD7/g7ly9jmW8satdvi/Sow77RXwKCF0fDWfIuwRQUdMPa21Fi2RhAw4Rsb28z0Ej1dZu1R0Vqt5w+Tp9FsjOcvfOpixtpMvSUI1oXyj0CBwbtxKqjdPCez++RC3L6iq9//6+kCO9kuqiLTxuzyaL+lcKZE/0pFJn3PMm9ju+IwqO6P+/aF7k7rR4JsmL1BSlT1lUnaoSoB8ljAriXHdWBbMn5Q+vyDn/Mmkl2VRagAxr6zNFaKgNFpTRv42cbmus6+FuWkDtBAuaqZ7v+4PdQrLaARzYHTf8BLy1spdZO51kyp1k/ubmU6K/CbnJ/V6j0XeftYelzW+YF1FLTgb9Fb3Hodzk2TlbG4Fl+caXCw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon Oct 26, 2026 at 5:40 AM EDT, David Hildenbrand (Arm) wrote:
> When undoing a failed fallocate(), shmem_undo_range() must discard each
> newly allocated folio. Its second scan instead passes large
> folios to truncate_inode_partial_folio(), which does not necessarily
> discard the entire large folio, but instead tries splitting it to
> discard only the requested range.
>
> For example, with huge=3Dalways, a failed allocation starting at offset
> 4 KiB can leave page 0 allocated in an otherwise empty file.
>
> Discard the whole folio when unfalloc is set. Note that we enter this
> path only for folios that are not uptodate, and can consequently be
> dropped without losing any data.
>
> Fixes: 55ac8bbe358b ("mm/shmem: fix race in shmem_undo_range w/THP")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  mm/shmem.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>

Reviewed-by: Zi Yan <ziy@nvidia.com>

Rebase it on top of mm-stable:

diff --git a/mm/shmem.c b/mm/shmem.c
index e9f98d526fc52..7cf5a4d9d1ace 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1472,7 +1472,7 @@ static void shmem_undo_range(struct inode *inode, lof=
f_t lstart, uoff_t lend,
 				if (!unfalloc && folio_test_large(folio))
 					folio_mark_dirty(folio);
=20
-				if (!folio_test_large(folio)) {
+				if (unfalloc || !folio_test_large(folio)) {
 					truncate_inode_folio(mapping, folio);
 				} else if (truncate_inode_partial_folio(folio,
 						lstart, lend, NULL, NULL)) {



--=20
Best Regards,
Yan, Zi


