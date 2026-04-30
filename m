Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 518C1CD13D3
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 16:22:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 830A56B0093; Thu, 30 Apr 2026 12:22:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 807596B0095; Thu, 30 Apr 2026 12:22:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F6026B0096; Thu, 30 Apr 2026 12:22:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5CD186B0093
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 12:22:02 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DEB5B105785
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 15:11:23 +0000 (UTC)
X-FDA: 84715560846.22.BCC7B83
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010065.outbound.protection.outlook.com [52.101.56.65])
	by imf12.hostedemail.com (Postfix) with ESMTP id BCA5540005
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 15:11:20 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="iobF/Hm/";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf12.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.65 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777561880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D7+Hc9YftzQFlqLUGSJMSZgQXTmv2dOrrKUdCSg47UI=;
	b=CIYccJbe5a461Fhn6PxPt3goOc2c8xgg2xj0owY6y0CI1gErBEe2E5JD2RN7iWlG4qoXIL
	mu5uF2OiTBHsq2EVcl8rNrY7KJfNxAGcjwfgKxxbz9eoSm6VoDZx5kHEW6hQCxgD98C4Nf
	Bdge9WuCbKYMlBbg481x/41X6cQTyRA=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777561880; a=rsa-sha256;
	cv=pass;
	b=jQBb0e+qVYaKlKL9lvO0OvQO/60uKoWsYOD7UdCDXUjCcHQY1Yjuyz22QNJfEEzlIxQ/8j
	8Brp887hq1MuM428ptXhv0+ZNJwTrxE0IdVMpJC5CFdETOTy52rESwOrwAbhBc5dvalMBS
	wVQ3rZP2LEd3uWSPpqcW1ObX/tRbazw=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="iobF/Hm/";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf12.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.65 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZwejkswFS5r9hNqTmqNQ4d31fUQn1OKkwbs5niKptKJUmYkUfZUFEn7ShxuQUPUD1AeSpOYyahWdolPHZKWMxxq94FZWaEQ5S4KbutV7eyosU72fyo2rh00aQ/oTJKjQVnmnwH2z/a9FaQ/60Ckdrzv6/znapRyenRsS857eCl9cB7RrPj8SOmREnLR39VLmxHUgJw1q/E30QAOoq9CXT3ZrJhdompFQY7HBIH/lvb/3F79SGvDgHiv9x3fpcVXH7MLyRF6l8VVNPQ8BAthHawxT7o4ldmgvkez5UJU/WTDbyEFEbRqA4WkfotpD/MaPY4LNNtcTSm8A1g0R6aM1sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D7+Hc9YftzQFlqLUGSJMSZgQXTmv2dOrrKUdCSg47UI=;
 b=f1Z4cfmgDY2b9vCAx7Toztrl+IyCaR4A/Hz0ph/raD2mrbXAiKzS9TGk4m40O+hw6hQFlVbUALdciIouYYY214BdNjhY161uXGEv1qzZt8uzLeqFaYB0Qz7+AethEpmkFtAKE1BIXcNCWOPNRBDXoC/W/9ldzUAXmnGwMn4F5D7gvdl2mQ1/7YpDloWoEbyiIPJ3qU+ve2dNRzK3CqAAays2ysl1pRM8dbrkJ0sKgwtBNiq9YksXVmgyLvC8kBpd4DzZF2Kcb+q86rb1d7J36JzFQ+kSIqcTQoV35jScurn8E3knE4t0r875Brx60J2lZm8JPFR8ap5TZdq8wNph5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D7+Hc9YftzQFlqLUGSJMSZgQXTmv2dOrrKUdCSg47UI=;
 b=iobF/Hm/6TcyHrpVmFZDKOhGVTrIooDOonT/JaqxTtmMT+yFEM3eTP1qwHiUlbL5KEXxPuy2q+PXJYxrOABqjPszrdsvj+shk/WwLUtBfB53iEufGUuqz7+ZP+S/dvL1XeAkpogKoK8/b0RTADCg+EuAS2eBp4c1x0fWkaJ+snUxonD1z2SIW1jfaCA4B+OaradnO+j6uSx5xXVp2X/llVTlrH2gWOqUhNAImlVIwLWy9T+wCUPLKGsZymohaTlCNFQwDx5ErGpshmZ/hoH4uF43fiFsQODB0YFWzfhNQ6uYt669E73qHIcTvMkqFK2oGU6nNePZ9Jfhe1eHGo4yPw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DSVPR12MB999194.namprd12.prod.outlook.com (2603:10b6:8:496::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.26; Thu, 30 Apr
 2026 15:11:15 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9870.013; Thu, 30 Apr 2026
 15:11:14 +0000
From: Zi Yan <ziy@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, <linux-btrfs@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
 <linux-mm@kvack.org>, <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH v5 02/14] mm/khugepaged: add folio dirty check after
 try_to_unmap()
Date: Thu, 30 Apr 2026 11:11:09 -0400
X-Mailer: MailMate (2.0r6292)
Message-ID: <CCA78A7B-95FB-4B25-BD3C-FC690D2B1343@nvidia.com>
In-Reply-To: <20260429152924.727124-3-ziy@nvidia.com>
References: <20260429152924.727124-1-ziy@nvidia.com>
 <20260429152924.727124-3-ziy@nvidia.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: CH2PR10CA0001.namprd10.prod.outlook.com
 (2603:10b6:610:4c::11) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DSVPR12MB999194:EE_
X-MS-Office365-Filtering-Correlation-Id: 77da3ba3-0da8-4f3b-a8f2-08dea6cab8ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	8jVDVtwZ/F3aZoRt66wBFW5scDwXMgJCZHXpSD9QUO/MymldCR+nw7AvgROLoGr9OfbxFF+8ejQ4Q2n7XnJP9aKpKW+vh/bCSHm0/mwLcfUzdBdpUEqfv3R7W9ZggThwGJIqPFZQb/8QpBCBs13YEiu90GDn4X/jTug/czfv3O/pf49bsU+uIo3ZWtG++ldF0Bhr6aFICM4LsB9qx+/uhL54Gm4Fiwc8vvMbMBuxGMiPF9oMqk1yH5yaFIp6GtIlLoAE+7l2mFebAcs7ye0idCdifvNkfa3R89UCUYvNWTrcb4tdEDvnJsibEgU4fLmW5pZ+s+SuKjr0aAFB9CXmUzTeX3TlIPPSyiYqLBBVwmkfHb+xOMKF83iojecpCkAcXbUAKlNcy/rsayagtB4BwIPYZh3MKkryTdiSnS4zrVLz/wQjmGinRuqFmfVva+WjhEdmTdhD6hCudemdmbAAeRMqZyANylfstPVRqOOBPGdDXLV8p8TC8lvPk5DIKYxbpdIK20QKA4Xj0uHfi3tjJkeuxZuAgLsKbttUsOmzjj9Wwm7g4VehI+JKDI2bpX6HCVLed79IPgscnu5R2KROur+lRTkQNT0ez8Y8m39MXN259kBb2malOqV6b7TKr5kyj/ymaOkZl0cW5IBVdWEE1XQ3+3P/MVGvM1sFzLp2KWGStoNaIx0xMlKmJpAFrUHgV7dJJ/B7/zeFOnSfZ9tM3uKEk9fZ2NVUpUFJ5Qsw8KM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9Qt9iTh5kQgM41CikK1oUt/kGE4ezXsVtIN8GOMHE1B6P2C68KKuX6l+9XI/?=
 =?us-ascii?Q?700c42o9Pzz4smbzSnuZY8UK4MM/2dVDv5KBGz6ef1uwSOlTB1TZqCrCOyJK?=
 =?us-ascii?Q?0nymCbjz9q1sQchtRWl3plj6MP1ec+ctmH8Akz/OI+8yT7OYDT8XhMQ7zXYU?=
 =?us-ascii?Q?U/1uE0p/HwdYXnnyQ6Bk+Bly3LR51ASq3hAEmJJkQYT7xeZnhMTtjHiBIGJ4?=
 =?us-ascii?Q?7oIALFUsZCbjR+ZrcaOWuJovsMRkRCrKYxlcVlS5133wssa7NhxihW4yjv/d?=
 =?us-ascii?Q?FsmVyFCXAF+8tfTs4kW2j5eo9Lyye/HOdXfJvJsJDUL9AJQo6cA062kJAbIf?=
 =?us-ascii?Q?i7fKRNnxwl/MrKfguQJHIfSboTDeRsvfHZY4xF0hmN0oKv1HpZCtkHzHifdc?=
 =?us-ascii?Q?/XSXx+w9fyo6mI8YrPRNouSJk9Q9FSshGdK1njwfJU7tT/jOyVJEwdG3IfFl?=
 =?us-ascii?Q?5zKup7G7HZflq7+ozPyOaGH4IuLVusdgGsIFSK6XNyjm4mD3aBicE3vXgSlF?=
 =?us-ascii?Q?7eXlf1mC0YF1/geOEbBRzl64TyrVFwEIqss4Pmbz9hSDXjpCl8leKe9rQzaU?=
 =?us-ascii?Q?VyMwGuxw5WVJFsyqG1vu3KgO5o6Cx1Q/7cS0l5oe6M9TJKgjdYhpXiaTtKIu?=
 =?us-ascii?Q?/BO1N9N2TBGsiclpJrjCaZAYuPUZsHh5xoSHqUgVlnLBAjmCJSS4QKdtvqHL?=
 =?us-ascii?Q?8enX9BXXAGUEzTSYJ82vCU16ohJ6kyHUrBo+ayNQ4JI2h3xDWksPgAACgCck?=
 =?us-ascii?Q?lvZ8kX3yhfbbpFisVoXbg4GfhSL+lgYOA3X5bwF8oFqg6j+v5AhQNI4Qp8nL?=
 =?us-ascii?Q?8y6p/GsedRfVPG4/sdIY/mkIKxHjaGLhS53BnhtA45nqu+RVYTrXY9BEr1TO?=
 =?us-ascii?Q?R4SWnmQVZEAtcrKcgzKdW/qrScJmgnmqCRoOUSnoamBe1gcOc9lsjiGT7CYA?=
 =?us-ascii?Q?QPdMlFhmSJmaqAlRlNGyM/OL6r4eptjPmCTvebVJrd5DE/fHDY/Cnv0nFttI?=
 =?us-ascii?Q?vsKMcfqJwUAp+6d9kF/xZti1VxqrLf25h08tQYREyVTuuK71a3nqOE3UpRgH?=
 =?us-ascii?Q?MYLqF+Ea9zEMAn0QKjwnO3RAgNo+8rWT30EWjyr1Qt+pQKW//X5tdqOYdBUM?=
 =?us-ascii?Q?nJcehiJOEYm8laZyeqyqpvNufv8VuPRvFW4edbd9LGafooq/euFvB1g+UFdW?=
 =?us-ascii?Q?/lKHa/8XGYaTRL/9EBJkMYYqftZPcvHnLtTC13QrNVlOuR25zXwoaM8aKimK?=
 =?us-ascii?Q?x7ySzNOe/mfnw58QASGDf8X3irb5WTE5I5eoLKVi6U93/cE7gZNhv1pOsfxD?=
 =?us-ascii?Q?KMDQnm2IoMmpE2aLdRpP0HuPHfzLJMv/w5N4EEuux76Gf58vsuPoAd7uDOFA?=
 =?us-ascii?Q?JpgcozxwEMV3760VT7K0u7eA372eaE0EyCIwWiJKSuOHHRIAlER070+KMDNl?=
 =?us-ascii?Q?qewvpfTUOl10FS/hYsVNiGN8nJzArFeGNEfZFOsJZW4k3zPMz+kR6km+8bn/?=
 =?us-ascii?Q?F5HD1Wn+v6PXLNCFRbf1x6DG9ZxYJTodSWwRAoHH7VEM3pToxqcxqAS8Q+yr?=
 =?us-ascii?Q?nglQZM5wHoasan2Qknwz7wTPcItb8By45q8xh+sHyBPUobgL8lCdjUdM/B+Y?=
 =?us-ascii?Q?hKvW8yauMm5mTZqQ07c1KUuLD9u+mOpllhdg8/M2aMUftFxH43gT3DTPFjvA?=
 =?us-ascii?Q?0bih/24HN4qSNtBlgEFs3hTu1GGep/CTprzcAlOX/p1Yd0s4?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77da3ba3-0da8-4f3b-a8f2-08dea6cab8ae
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2026 15:11:14.6889
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1/UFeyoRU3XWYhppJOmqloNlP9Zc8A0iZSlvhnK/Pllr+drQL5iKcBK8SBEtR7QH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSVPR12MB999194
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BCA5540005
X-Stat-Signature: 5hg8e7j9b4n5ggq88e1fbyus6c1aerp3
X-Rspam-User: 
X-HE-Tag: 1777561880-729341
X-HE-Meta: U2FsdGVkX1+XiF5yLOjEXmNPp0W7OWf9sw25JC2tdEzzUmwhrhC9anmRtXy5MTNGX+x9TgOGr99XHQyY2+uIP59ruwkS5G2FCTMq5kOdu9Zr+PFOf/jSxAhc+C+zsSrCB32w+o9ekXftIMSYsYD8Ia8X8N6k5FnxYyL3eEMdArzYX8XpVsEHSNPCzenpw1GMAxgrCMDp1S2HEu4Vm1gcnFRgxe1coky2wDYqJqDSOy1it3pDppoSJl3XuGOoWqdBP0uEd2Tj2ZnHLfh9gd0YgMoMxzadhk/My/3qLmbY8Otzj9QrpJXrxbG2Wh8GakUSzKkjdZnkmoffb2EYjVfOOXAhjuXGyOXMJbzG94SutdDdyJe+Jx3Uk0KehTWPOkR08zlk6pNbakejcY8Pz25rNI7gTrYuzf3uI7bZIqxOMWusPrz9wbKM1PpedPKr46bX7BDj+F0hqax4ZlSMqk88yyvU0OTeazfIP1YeJJEfvVFtwd+vi40ChZezInHrMtydTfr+GMsjNF2HhQkBlTdqkGNcLuwvtMoRQeypDpnnINALCc2ZkE872Qot/aloBAPtEJurnGO+/n77cNgvMlEkwS4co61vn31yeQmOalD9Dvd4n7gvosCJLulHBQ36mg9AWtaBrsITV9ym2Xd3uLCHA83ynO5yiuL7iDyfFjrRa3UmMjBilIMHa0IwcDOkZvQfIHCko8IsjEnt6gau8FIdnTkSt2giJzLZGSNYrx7679S/vwZA0DZ9v33sACAYDE/h3n0HEcIkxU7Qw0SyS2ZGoGQvccOdoPmk1kFGgKKViBrC/EioUX6t4J7y63kW0ynqmyC2u+35x6ZYChCjQEoosOUXp5AG37F/uqITdw9egysNF8qhpfQKkS4Oqw9PsHr03xB9qZKf1sFqfjGLZnvcsmVS9tqPSMietAHAQUJa2V7Q5ugQERqTp2oPoODxBA7Z7oKYISDJQ7WpUjTDuMy
 CDztayEb
 eCF5zzjnijie3O+LG40CITBHv5vQqNbCnBQQl95loie7IxWv7cydhCZSps0cpIK/517bJvNIR8RoGFp1OAhCHKY0hU7kI74Fc8ao8UM4lsUGFbnRx1dKiXYio2QAuBxz1FUV/QBla4THWjdg0b6KUcdld7xND68dit32FB98Zv2RW5lCnF9A+/RrK4IkY6w8YREEZlax3W7b8iOTmknFKwc9o6UDq7cgmHSme87RN+Vb/3100ku/p0p+i4bBPx1IaiUZMU/pl6slOC+cD3i6lNSxVa3xDjqAALoaKFMV1lf8rzwSSRYcoeib771bGVoxDdt5V6V2eYj97VN36S8tlywsRTS9zyhutwZ0HH8/A5k4rjMbXvQljcQPPAe92CinAGMqTuS9RjpzBL8Yt3lcvEajmu0CysNblv1jUlQFsjDN0R6UOzivgJKh0LTdkGPCW4X1Cj69PQUOiL0DC9YCZDosYpHR7VIEinNnCf5Py1sQ789MAS0MliKd90OP4FAY3NljR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29 Apr 2026, at 11:29, Zi Yan wrote:

> This check ensures the correctness of read-only PMD folio collapse
> after it is enabled for all FSes supporting PMD pagecache folios and
> replaces READ_ONLY_THP_FOR_FS.
>
> READ_ONLY_THP_FOR_FS only supports read-only fd and uses mapping->nr_th=
ps
> and inode->i_writecount to prevent any write to read-only to-be-collaps=
ed
> folios. In upcoming commits, READ_ONLY_THP_FOR_FS will be removed and t=
he
> aforementioned mechanism will go away too. To ensure khugepaged functio=
ns
> as expected after the changes, skip if any folio is dirty after
> try_to_unmap(), since a dirty folio at that point means this read-only
> folio can get writes between try_to_unmap() and try_to_unmap_flush() vi=
a
> cached TLB entries and khugepaged does not support writable pagecache f=
olio
> collapse yet.
>
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  mm/khugepaged.c | 28 ++++++++++++++++++++++++----
>  1 file changed, 24 insertions(+), 4 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 6808f2b48d864..71209a72195ab 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2327,8 +2327,7 @@ static enum scan_result collapse_file(struct mm_s=
truct *mm, unsigned long addr,
>  				}
>  			} else if (folio_test_dirty(folio)) {
>  				/*
> -				 * khugepaged only works on read-only fd,
> -				 * so this page is dirty because it hasn't
> +				 * This page is dirty because it hasn't
>  				 * been flushed since first write. There
>  				 * won't be new dirty pages.
>  				 *
> @@ -2386,8 +2385,8 @@ static enum scan_result collapse_file(struct mm_s=
truct *mm, unsigned long addr,
>  		if (!is_shmem && (folio_test_dirty(folio) ||
>  				  folio_test_writeback(folio))) {
>  			/*
> -			 * khugepaged only works on read-only fd, so this
> -			 * folio is dirty because it hasn't been flushed
> +			 * khugepaged only works on clean file-backed folios,
> +			 * so this folio is dirty because it hasn't been flushed
>  			 * since first write.
>  			 */
>  			result =3D SCAN_PAGE_DIRTY_OR_WRITEBACK;
> @@ -2431,6 +2430,27 @@ static enum scan_result collapse_file(struct mm_=
struct *mm, unsigned long addr,
>  			goto out_unlock;
>  		}
>
> +		/*
> +		 * At this point, the folio is locked and unmapped. If the PTE
> +		 * was dirty, try_to_unmap() has transferred the dirty bit to
> +		 * the folio and we must not collapse it into a clean
> +		 * file-backed folio.
> +		 *
> +		 * If the folio is clean here, no one can write it until we
> +		 * drop the folio lock. A write through a stale TLB entry came
> +		 * from a clean PTE and must fault because the PTE has been
> +		 * cleared; the fault path has to take the folio lock before
> +		 * installing a writable mapping. Buffered write paths also
> +		 * have to take the folio lock before modifying file contents
> +		 * without a mapping, typically via write_begin_get_folio().
> +		 */
> +		if (!is_shmem && folio_test_dirty(folio)) {
> +			result =3D SCAN_PAGE_DIRTY_OR_WRITEBACK;
> +			xas_unlock_irq(&xas);
> +			folio_putback_lru(folio);
> +			goto out_unlock;

Sashiko asked:

Could a concurrent operation, such as truncate(), lock the folio, remove =
it
from the page cache, and drop the final reference while we are jumping to=

xa_unlocked?
If the page is freed back to the buddy allocator before try_to_unmap_flus=
h()
completes, could this leave a stale TLB entry pointing to the freed page,=

potentially allowing memory corruption if the page is reallocated?

Answer:

The folio still has pagecache and LRU refs before try_to_unmap_flush() an=
d
the truncate and free operation cannot be completed in that small window.=


> +		}
> +
>  		/*
>  		 * Accumulate the folios that are being collapsed.
>  		 */
> -- =

> 2.53.0


Best Regards,
Yan, Zi

