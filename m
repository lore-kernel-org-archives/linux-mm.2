Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D40CCCD342C
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 13:15:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 203846B0095; Wed,  6 May 2026 09:15:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B4626B0096; Wed,  6 May 2026 09:15:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07D546B0098; Wed,  6 May 2026 09:15:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E8C566B0095
	for <linux-mm@kvack.org>; Wed,  6 May 2026 09:15:46 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8F60A14022B
	for <linux-mm@kvack.org>; Wed,  6 May 2026 13:15:46 +0000 (UTC)
X-FDA: 84737042292.16.AAD1A36
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010028.outbound.protection.outlook.com [52.101.61.28])
	by imf04.hostedemail.com (Postfix) with ESMTP id C2E1C4001C
	for <linux-mm@kvack.org>; Wed,  6 May 2026 13:15:43 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=R3lKYbAo;
	spf=pass (imf04.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.28 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778073343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tKm+I75MqLH5FFybicnKVsUpbZee1tWk0U07zyqmmS0=;
	b=PMn6jAJexopn5wOsIFXpzICQMR7RknmN/wjVk3wTm6mC/xsk/U8ep2xJuphTokk0IfWRvd
	7GEuOdtGUskgy7KWUkuLEgDCgR4YP5Kcy8QTsitj4MW+xi5Hm6Ia7w7GAYuIEU1MCHO/0l
	iQ7Hty4CZ5dQ8AC4hGdaAByketMV7CE=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=R3lKYbAo;
	spf=pass (imf04.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.28 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778073343; a=rsa-sha256;
	cv=pass;
	b=PfPm3606DAPOjYOBaD8GO9plsNa8pedmqHdaBKWTo3EO8bIpAXQM6/+IKkbHXEa+JxGLsH
	2b6ODZ4oKupGcYlIrJgqgmwTzL5vid4p4DRepxqFE6SisIxNSYoMimuP+f2y8HEviVJ/J8
	oIG+72XawUSYf+K7k+B2my+DL1sKafA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PEQ5+GpVwesSGKECG0iYwppvm72cu+KdWcaGXiaUaRmanr2dRxQuWKYfK3me9JD7xGEOsu0rmaAD/oaDCDjQbgR5vgMfSgZEVPujfrqCZNtm5KJj16uZO4/1cifhfCIB3lJ/jEBzuGVe6wBtDXlcG1LpyQK2kMKw1ITZSoBDNvXSID7hsepnTdB+2FugzC7qJVfEtppwwStHgFljfFM/va9aOi3BG3mL9ej/TyvHjXjOGpGsIDq8zpaFgBmjIDfP7lIpAPiGaNe3AbtvyKPTWkKrT6WNfQqjmd9SriuBbUPDgUNlUXoHSw9sY4uywTwW/neW5i3VorrWZctKf2erhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tKm+I75MqLH5FFybicnKVsUpbZee1tWk0U07zyqmmS0=;
 b=r73wRiAofZrvZoifx1D9wA9z6lUoAkh8pDmNN4dBBFSG/5CU/w5LVvSIDNrQFzS2n5GaLgG5TxWQVGfpCFAHiXbTQsee073+QIDy+cxDbQpOxPXKraaAqh7DedJRdJ2ypun1cCEzvVJPncTb0KrHgEoNTAnj/HtUc0NWDx4bFIof2Ys3CuwkMHbOI55AtIgkg/XMuTnoBzp+7K9vqvkT76XQAI/NzdDp3f8ig3YcLJdneuC0u8J5dJO0xznf21E3p754oaqqhErPOv379v5dT/z9h78Rr9ziKUk0dVG4whv4PNhFn/mwjQ5r14ixbjTn0+zdB0A/vz2OksGbsgLO5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tKm+I75MqLH5FFybicnKVsUpbZee1tWk0U07zyqmmS0=;
 b=R3lKYbAoevIWf5Zb2pXKox7i1dvQUBFVu/A0M2kqlzlITvs93DlQod3jOQqocDEpOtvuo4pp0UHTTpaZbAy8bAqpSNuKaKYX//9fgesPKqD68kyOngYCSD4G1FsHypKDTkmlPkujhB7DZQ7JkWkkKZ5yrrpMVbshNM7aNLWTEi3CNfJ6pwjVjliXts5564whVWkZm6iIq4kpIQCFJqzEx6g75aXps7urxc0UTiUK79iTbAH3XQrmxx8+XsoAlgnIb358p+Cx4zxTWSA9JgC3O5ZaUfHwPLeAuppe1iwjZuOPhKaAK0HoWuDEVKYtRp+FsNsOa4zCe+TOxxEojLSAsg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH0PR12MB8152.namprd12.prod.outlook.com (2603:10b6:510:292::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.15; Wed, 6 May
 2026 13:15:39 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9870.023; Wed, 6 May 2026
 13:15:39 +0000
From: Zi Yan <ziy@nvidia.com>
To: Nico Pache <npache@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v5 11/14] selftests/mm: remove READ_ONLY_THP_FOR_FS in
 khugepaged
Date: Wed, 06 May 2026 21:15:22 +0800
X-Mailer: MailMate (2.0r6292)
Message-ID: <61FB928B-03FD-4852-BED5-4E453ABB706A@nvidia.com>
In-Reply-To: <7e42faea-9f55-4722-a426-94be7fc3a49b@redhat.com>
References: <20260429152924.727124-1-ziy@nvidia.com>
 <20260429153538.727855-7-ziy@nvidia.com>
 <7e42faea-9f55-4722-a426-94be7fc3a49b@redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: YQBPR0101CA0311.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:6c::14) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH0PR12MB8152:EE_
X-MS-Office365-Filtering-Correlation-Id: a5ecec89-78ce-4ec9-682b-08deab719137
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|10070799003|366016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	keEp3pXRmMO2A6imwdN7WXiyvKurWZVaNGv70G0/M09hVKXWGjlc2RIx1OApWoNy+q16vRLddCYEAD7vxPhL5NcgM3CuF9K5SgnmaX3xI7lRmcxDSIF5U7ybIK1Vr9Ta06uNCNAIep0FSLI7h+3s1mY6ewOjDux4+Cis4y8+aIa+yLM4y2iT9FcLwM/wUFTX4J1HUh3ASkMBtfHah0XR1XmjT+7uavvB5EwIRSUB1iajJrKm79JOnml+eC7mHxD6pfHdAsRSSo7VqAUL7oVI6TKn6HJzeGWRNs9U4PhA7nfsgcJ98zTPXF6M+CmjApvtkaf1JMDkfpcGoEyWh/RZljkgROwS6iiCg+Q02OBH8wczu//GI9YA5PvqisenJbg0YNibEdU0fCxXODF6nSD6eTfJDMatD0uk/lAgkzcQ0IDgYE7PqLGbabPPOh1/l+w4lQmTJR+VX9ic/tTzHni0WiZqSHLAU47vzsvVqV10KsBf/UhFm/2AtcYzvXan1X1kohYzwT2p7KzD2enndt1IrwqFbhH8lBWr324K8els/Iij+Noj0hVSUDabVzJthz0/RlhjR1pnQiu6bCPlAca/rw8aa0qOOrO7M4IwwYfqc7yQJwnl6bGjxVmhTJ7pDDHjhRtVYCv8r+5q/x043kkcNcT0uW63gCgEsHWQI8f1jj4LMpcyuJ9KHxxwDsafu7g8
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(10070799003)(366016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xPq8830KIRgTBxsfJ+PtNVrXXma37FQwtLaCVvJ97ffalrz7Lptb0sSzGb4U?=
 =?us-ascii?Q?hl949MA5qnCP1kxsFwNr2ug1PLeUYXzfxdSfgjCeS/phIwu/Od7h+0EuKTbV?=
 =?us-ascii?Q?TVxBhGmp0UhuqOhV05IgtxIGQX/sO+kDa0QkJ1hk1gH4ZbU3Uok+FakBw8o6?=
 =?us-ascii?Q?i4Q/1PaIYgxFI+7l5t5IcIl0LL5Pr/hYca7aIA2SO/SGE+nrqcifDRnl4Gab?=
 =?us-ascii?Q?xmPRKhYM5v+9hQm66FYqyTtq4lZWxJONHAir/ydfO4c6XrkyG3glC2yGt7+j?=
 =?us-ascii?Q?S0rundVAB3j3AdIgFwYk47l2vGPUn3WAy/ZRfla4bYqeJo7s4skFk9SEcmQg?=
 =?us-ascii?Q?If6hUHH9LZQNgVbhgZJ52Snb5lz11UyMnrKa9AJMu2f/z17mVcamvagAXnY3?=
 =?us-ascii?Q?CO4I88ZElbmyTFvZqfV3J3Mw7QOUCq72iv5zbxS0xBhOmrVcQnRpRvEws6RN?=
 =?us-ascii?Q?rQkd7CHVgMIgyLy0cTZVCNnR8wTNuj2y1V5KlzsAmVRqwEvle93tCLJuMaCH?=
 =?us-ascii?Q?7CrdHNBE42IP+IGmGGvo4tBk2mAn+54PBezXuyKLNY2zE/1p7zb16iB5OKJt?=
 =?us-ascii?Q?eWJW/hFxORMR0QLFu8SdnPv8X56yRsb31Ay/nIvBiupk1QvkpEb9/cPLWwL/?=
 =?us-ascii?Q?vB3tvrpLOfz6OqJV85V/xiNnuvayn70qbW4MVgAuWcDxiq6G8PWXXNtJ68vb?=
 =?us-ascii?Q?RgKiTBgzL3GKVUXuGTzqYuOZNNSlSxcFFeh0bBZHNIGX6oU3RiT8bOM5HrKb?=
 =?us-ascii?Q?gh0KL6C9Dey5+pz1uagKpqhDl93ris2gFQ+Ny/dca6Osb3Tp6YYXxzBnph6A?=
 =?us-ascii?Q?5M0+qUGeQAVhToeFh6pPCvmNeN+Al7OBiqwxNpstPL9Hlh6cmm5vCkatxGUK?=
 =?us-ascii?Q?Yg/yeTzG7Fg60+ZI6x2EdJfLgYuvgKBXMkKfTQy4Wnd5Qx60qpYhCTpFn/5T?=
 =?us-ascii?Q?1eWlqvi+yhyKzeNgqbWjPU9iS6EZmOV+UVxokr09ppKe+J+8KMHYP6toGOhc?=
 =?us-ascii?Q?SbW1YsRieNBh0RUN4aczrgbyM8WzWHfVMBEo4/ngZqZVOTU439Y393EqPE7j?=
 =?us-ascii?Q?bsGhVSmj8bgeQdwj5B8PuBIpH3Yb0uIJYXQcKx7cpdE/aGnu36yeG8oD8Xnl?=
 =?us-ascii?Q?nFGqthMZDr7/wMM4xTut6Drh3Ua2yOkrS5ugrNd5OKBYxPMqJprohpn2W0PH?=
 =?us-ascii?Q?J5RYJRVTTB9+L1l7s5GzKgNKTlsWWS3iNuVuHk4A/50XYQY/FmXiwFfb/Tl5?=
 =?us-ascii?Q?EmIiByt1juSkH3SmUF76oQcv/HQ2lsJg3N7d3g/j7E60GRbhvvrp9JlcSV92?=
 =?us-ascii?Q?ntfLGCkl08sokngU8nAvF4Q7pjEJFJhMbM5vF/DEE2PSL1VONOOhInIZCBVt?=
 =?us-ascii?Q?Tjvwh3BFzPYi9Dv52pJAaJOh5tmKgZT7KuTttA6wBWl5ROto+/9V1TPDEGky?=
 =?us-ascii?Q?Fvc9vh13C1+W/oJImE41sEMloi7NshhbuOqNDHTWGJZj9olXFmYqgB/3ybV+?=
 =?us-ascii?Q?oUPsMFqR7liHIHegss+UHRNM6TF6F9q6oHvqymJdIz49sJKROcYVJAaoFs5J?=
 =?us-ascii?Q?uyeujNvNxTwhpsmEdQlxcQqprHgMqzdS/4WZp59NfiSamkjgTvp7LwBCn/RG?=
 =?us-ascii?Q?dSd32Uqb+Dx3fe3rox58kWJZDvxOSeeX3DG3TpFEWVmT+Wb58YGXpUzO/PMF?=
 =?us-ascii?Q?ZMi5gs+690tPbg0Hh3k+CYPr1tew57qSiOel1BUMnMtMr5heuuczU+Q/JuHD?=
 =?us-ascii?Q?xxHx6bOajhnP5LcMhOgpL80HqoNDiGqw2fDmPonnvFnlVsogalg/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5ecec89-78ce-4ec9-682b-08deab719137
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2026 13:15:39.0410
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tYV/j14PttpOj/WVfhvJ0Rb9T5Gjx3CDKGj2vc80dX369dWC+Ca7EHpNhRzKtMr8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8152
X-Stat-Signature: nxuku4rn47zhmiq1qba56dmyyfhaegq5
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C2E1C4001C
X-Rspam-User: 
X-HE-Tag: 1778073343-269639
X-HE-Meta: U2FsdGVkX18pcTwhKaADbdP4ilemTecfbCn3hMtS22y+hf1MmYHGiQZiOW6fQB5p3AMg4cbX03vdq9P5GB6qiOrUFl1fifPkCl4CRXjCDzx0UM0GmwBPx+pXuz2Y5WWpcivZS6zpogBWzh79w6PLRq4VytZ/7RD3hfdVc3n4UVwbIHWu+pQTEoIqH0tMSfajylzh9xA7BQMu4RduM9zznqt0v5MUXAqFC/A1IqXm6Wu3XD/iigX9k3+Dg50l6d1CYMaMIf1hKYiVQe4MSCsUgMMAKDQhKqlB18fb5hSGU08Gvynd29HaY0+tYkC7/DltWT14qNSy1m2OK8wJ9IjNw0OIS73jjTrk7LwMp5O4Pe5Ju++zrMKkBwVERqH59ano80QRPROvXwRZ2/iy3NGE745VwPTcOKohxJ/xY1FdazBL7UYAAGywySwEGNBh7tuM6R4RAUbNe+fabv7lyx6fjuc/9AnUBTumlDBNWGMlm3Girh3OuOikksS0mra9FT6dllxcOjP5D0GWjiNh1wslSlLSYwkMF6nhpHtWV5li7THCKuGnV33vb9qWJyxvAn9zJKvWJarY33GNmrnDbt9v6rXgDyCl9vk1DLzTS4y8wA3GuCu2WgUV4PJHLzsiFVn7QzTzwfgC0o7p+w1vHnVrD13bp1Bg0COjnVDrHqbU/r/23kPGNVdCgsppEoUaWIojWX587QpLEFm8gzylLpHXyWNKuWxHrHF9mPqD5QHikzw2MkydUsgLBLnIpNlhrYyFDnf6SiM8LjEuSto7n+jYHYzV5BbaJe7isCBKeGJxGUdaH8IlLZXajg24vXJ7BaU70XZ/5SMtS0Y0VAcspCbYxycT+nG7MdADFsBfFH6UJL1gN9bIFE+X83T+sWa1MSuOdkUASp3yWmv64R1GGF35IU7uMl9fimyosRLf8QyZk6o9jEYfNxx+h6pVWRkBRPaFE+lSciXYte7uiAA7F+i
 881Q+67H
 8xR7G7eijZtCfgSl97Cfc334RRgtr3HXieyb0Mmr1q6OEoNw09BSLRCX10S2bg4v5wiuEhygQPPzqC6C9gOgk2SzzSVm9nVe+zIQrC7IwZYivSCJ6mqudODfRTTM4sRZnGyI89rNyHtdVMV2Y6u+avuNBKYKEEPs/0xkhx0Fub/bCGBap/txJpRLazbVeSqYzyeyxf3DDkIpyAsOoruLjdF44xZAO8XJXyvwPKwydXgG7bnMLDf4mPUS775HrYdYgcM7ECcYkl4kr4Zd8N2GmVMvUARYk0+cN95J/tN7YWJsNduwcmb8k940liznr4c39nDJJuyD2vJcxxM8ZkpjyCAz8o+qkRAb++N9wsJ2jVxFSsgAcADq55Yx/QHXXvrDkSJc56RbY3edbthhAw69/dC+d7AjrjLQ1PMsKMx069SVXiujQx43xpMsoIg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4 May 2026, at 18:11, Nico Pache wrote:

> On 4/29/26 9:35 AM, Zi Yan wrote:
>> Change the requirement to a file system with large folio support and t=
he
>> supported order needs to include PMD_ORDER.
>>
>> Also add tests of opening a file with read write permission and popula=
ting
>> folios with writes. Reuse the XFS image from split_huge_page_test.
>>
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>> ---
>>   tools/testing/selftests/mm/khugepaged.c   | 131 +++++++++++++++-----=
--
>>   tools/testing/selftests/mm/run_vmtests.sh |  12 +-
>>   2 files changed, 102 insertions(+), 41 deletions(-)
>>

<snip>

>> diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing=
/selftests/mm/run_vmtests.sh
>> index 3b61677fe9840..854c5c3e3a6ae 100755
>> --- a/tools/testing/selftests/mm/run_vmtests.sh
>> +++ b/tools/testing/selftests/mm/run_vmtests.sh
>> @@ -490,8 +490,6 @@ CATEGORY=3D"thp" run_test ./khugepaged all:shmem
>>    CATEGORY=3D"thp" run_test ./khugepaged -s 4 all:shmem
>>  -CATEGORY=3D"thp" run_test ./transhuge-stress -d 20
>> -
>>   # Try to create XFS if not provided
>>   if [ -z "${SPLIT_HUGE_PAGE_TEST_XFS_PATH}" ]; then
>>       if [ "${HAVE_HUGEPAGES}" =3D "1" ]; then
>> @@ -508,6 +506,14 @@ if [ -z "${SPLIT_HUGE_PAGE_TEST_XFS_PATH}" ]; the=
n
>>       fi
>>   fi
>>  +if [ -n "${SPLIT_HUGE_PAGE_TEST_XFS_PATH}" ]; then
>> +CATEGORY=3D"thp" run_test ./khugepaged all:file ${SPLIT_HUGE_PAGE_TES=
T_XFS_PATH}
>> +else
>> +	count_total=3D$(( count_total + 1 ))
>> +	count_skip=3D$(( count_skip + 1 ))
>> +	echo "[SKIP] ./khugepaged all:file" | tap_prefix
>
> This leads selftest runs to always litter the output with SKIP when run=
ning this with the wrapper
>
> make -C tools/testing/selftests TARGETS=3Dmm run_tests

Yes, this is intended to let people know one case is not tested and skipp=
ed if XFS cannot be created.

>
>> +fi
>> +
>>   CATEGORY=3D"thp" run_test ./split_huge_page_test ${SPLIT_HUGE_PAGE_T=
EST_XFS_PATH}
>>    if [ -n "${MOUNTED_XFS}" ]; then
>> @@ -516,6 +522,8 @@ if [ -n "${MOUNTED_XFS}" ]; then
>>       rm -f ${XFS_IMG}
>>   fi
>>  +CATEGORY=3D"thp" run_test ./transhuge-stress -d 20
>> +
>>   CATEGORY=3D"thp" run_test ./folio_split_race_test
>>    CATEGORY=3D"migration" run_test ./migration


Best Regards,
Yan, Zi

