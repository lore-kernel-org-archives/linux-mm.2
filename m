Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D094FF8873
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 16:08:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8910D6B0096; Thu, 30 Apr 2026 12:08:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 868566B0098; Thu, 30 Apr 2026 12:08:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77F2A6B0099; Thu, 30 Apr 2026 12:08:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 672B26B0096
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 12:08:39 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F1623A619A
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 15:27:23 +0000 (UTC)
X-FDA: 84715601166.10.ACF6A22
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011000.outbound.protection.outlook.com [40.107.208.0])
	by imf22.hostedemail.com (Postfix) with ESMTP id 189A5C0016
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 15:27:20 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=KVtkkUUt;
	spf=pass (imf22.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.0 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777562841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n3t3hMyfA33PWUgoPeaS95ciJU2v1WEcNA4bnVWSH6U=;
	b=fTmqZ4kp1LUkmlPYx7+9OntfMeHcR5R7EDi331o4Z8ggHrhZR0PU5V5DOWQElFlHXwOnSn
	EYSUyXkTjZ+RSLuHa58ToyLsC2Pc0NXhrA6zrrjpds4Fw/awqY6VktMGjsrXhyfsCaAXwu
	idLDlRp89P4muY4QqDIdo/brQ0GqnB8=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=KVtkkUUt;
	spf=pass (imf22.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.0 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777562841; a=rsa-sha256;
	cv=pass;
	b=yrusQmiZXWPbxiRGKJCVYXzHN9XoQvluDsRiylxc6ACCfrPZi7BItkgDxPBoMItJEnxZZK
	6KF9y+MIsHsFNL2cVr7F0QYVDcSatYkZRBs/c/83+q69bEcMyhP4OnJCfJmNTL/JVxCnpK
	BrhJGGAmM2wgWfd2cpx/0k/48z6JAb0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fh2y2UYBxtF8ZNW0OBjcb2XHl3znr2pr3gcE0jPIHNHuDOhNRRyM4tdasBWjm13Po9FNudrxiAHggMCSNmAFCpGFl8vWfM0m6G1AfSj8YkeTsX4b3VermHOI3fpok1fm30+K+zzkbwynOpZFmg5XOJ2yVTMsHW1OAcS0JBdCAyrcflCQ39Y0DPU0kiykRWTP3req1a9Hr9BGpEspOXSnv0eg5dTCHBOSXOiGZ3AnlwkfwMuuGFKObpl3ME6AyvgGOS1aX909PPiQJ+MwmDSS/gjnLEmmhLhZ1521FBLfgmjcAAkE02bFJcGlApXrGNZntl4QKprcl7PU2Agp8/7WcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n3t3hMyfA33PWUgoPeaS95ciJU2v1WEcNA4bnVWSH6U=;
 b=C3RmCmROV2t63x70VVLKQ2g1Cac352ajHSnc2oRdblkBoC7J/ArqEPxNNbFUHTsPdzXel5G5T6L2gzkZIewrwXzb5Ze8WHSXRNW4+RcYzIU83d3iH0yeFxGY/ri+e29lyH587KI80r2oR3JqBcGK91WzG/66Lzf0/8txlSmKxieJJ3AXLM4L07UdF23ISA+v3200SGl9dS9a/2Vba/h+iCkA4rE/FnFaBlXreQgNps3qD/Tl853e+x1uDoPE5oXnp36I17Fd9/kxPBTZRZeafmeJQI9V+67Tl14x/G3OKzx0pYjWH2L/sIbKWAixfWm1PkRjhtyd57CEw6NzmEIXLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n3t3hMyfA33PWUgoPeaS95ciJU2v1WEcNA4bnVWSH6U=;
 b=KVtkkUUtxqmnIuFw7nHd1eMSUSrwp+4GTKL5MbQTypzlmrcBexSXYcUb3WreFqmQDBHdZJYHxdCsWpESWmcXI6XuY0NcW8STWQ3fRRuQUP92hOoehj9Yia0ERc8k9rUqR5UpFYCBqLVG7GOFYADBpBe65eT3XCmgILFRPpJa1K1dZWf1GuqEiX33wJuDHZ7z6Y9EtdAy7fa710eA7Ne/3FD4AGOTZZRybhri746Xh5bdPpDIG1/M+ASp+TiaUGqSlNcRNAEbZeRFyDJ+RqTaLcwp+L2sGZ7DFW4yFswGhDyKnx57Wpf8k3skXqAIvhQLBU6k/v1j8ZkJtNaohgmDlg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CH3PR12MB8509.namprd12.prod.outlook.com (2603:10b6:610:157::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9870.20; Thu, 30 Apr 2026 15:27:11 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9870.013; Thu, 30 Apr 2026
 15:27:11 +0000
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
Subject: Re: [PATCH v5 11/14] selftests/mm: remove READ_ONLY_THP_FOR_FS in
 khugepaged
Date: Thu, 30 Apr 2026 11:27:03 -0400
X-Mailer: MailMate (2.0r6292)
Message-ID: <3BFC4C26-1C97-40AA-B4B7-7472B9768565@nvidia.com>
In-Reply-To: <B1D68BA2-11D2-4053-B715-F7704ED784DA@nvidia.com>
References: <20260429152924.727124-1-ziy@nvidia.com>
 <20260429153538.727855-7-ziy@nvidia.com>
 <B1D68BA2-11D2-4053-B715-F7704ED784DA@nvidia.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: CY5PR19CA0009.namprd19.prod.outlook.com
 (2603:10b6:930:15::6) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CH3PR12MB8509:EE_
X-MS-Office365-Filtering-Correlation-Id: 74c54b67-8230-47a6-dd5a-08dea6ccf313
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	Oi0lZh2tuwrSa6IgQyffCwIFgr1Pww0SscGuxJI2xtjOuZ/ZDgSfnINu7xWaA7r60zglb52DoGRF78zuIGH/heWOjL7pM4ajJUpG/xTtZ9BD5cd9LO+AnVmK3FHsMNqwO3YBHHPDD7VXorOfrk4z1XqrhNYlxyofexxUSLWPYh3bZecMbaNdpmr0pmrNnQI63lxP1OrVbrDaFS7PFOpN6LIg1AWo/RnVBdpKbiplLCfxSDKfpLhjcBUhysMWx51AR907mEBv/mF3HXLC3LnocGDl36eZjU/q6Dgv96DWzd+xXyRyOfjvYFsKKmtz/oMFlPicSfDOUuF96ySEuIR8rToyeUJDh2CaI/4iazPhQYtCHhnExDPwfRuawOfB3DN9AzpUqAIbFZoJtJLr1Zm9SLgYWHIGdIJXV+bouAYSvSQZ2g14bjbA+9PfcRsRhYmcsSMpUQQ2qcuT4qquGFLdn0CxQFquPCBjm4TOL4DZjT/epiZ8uqO508trcBnOmFAxis5F7nt4SRFnFm4wnxXxYFTfZwN+ylqP/gB6a8QjWuKM0Z0fatpfyeRjBtFJlaxWOAHL/LTlEvMbIcNiXJeP/oHImzVzSHaHK4HOlcki8vpFjyGrsqnLWwAJoXblOLkzsWsHtRWlgkauD/HnoVyvBYq3ncDsDewJToTaU+f5DiBGnDQUkHuViafMP1Xy7N/WneUNEIRsr5cqTEfomY4TtMnjfery7cy63ZOMDwAsVG8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vVnTHWklJaMTKLk+TzEOfWjXn9rdhW/AYZi1POIoVgFGb3FdvdQc6xlleRBo?=
 =?us-ascii?Q?iB2je/3stiUY2GyH0ffrMTD8GvsFzZuiBwRM2tpN84i7CediAdXveVHVTWx1?=
 =?us-ascii?Q?FXaZVmXvh9dq9g7PYSFgH8rTZ0vEUDpR2AWJjpR6XimMlv/rMIr8Qdul6+7c?=
 =?us-ascii?Q?KSObiLWo3SopU0HGat649zdGjpKl9M8FeQe80u+R7jV8//nwPrx21T4dS6+m?=
 =?us-ascii?Q?E+PPV+hS9A4h+6Ez2ZOQmiMSpfd1kUVI+9kaqXBX6qIcJ4r1E52YBZBgd6fm?=
 =?us-ascii?Q?/OWIU/fNUIuqslIBs3wGrYco6rKCyKLZyJm9DiBLs7xPQePbrWGHxmSlDEeL?=
 =?us-ascii?Q?ZlGiNcMduf2J8hV9JzUg/+cWsjkDurq5fX5uDyPPmE0tGPKzCT5DeNctLO85?=
 =?us-ascii?Q?mmI1PimnUnnsEIygXZILAxDJI27yuArm6KPO8BcDlqggeL3faY3zlHDqf0Aj?=
 =?us-ascii?Q?4GTZGtkMg+wEi5fQBBkRQwHjbjn7kO+62QWvgmT8pbSgXl98PdMFkd4o+jEL?=
 =?us-ascii?Q?/qYovM5MN7McAelTu4bfTrX5+qfQlDued6b7Xtws7FfUh8IpqxULqyfhjTHj?=
 =?us-ascii?Q?pta1ethh8P+yjlM4YAWEzD9g4mXZjs6Lk8TyUtywL54DNLSodLlL72UAsOKD?=
 =?us-ascii?Q?WNspBgltelUFSppWLguqDYA8BNd7ytoHCgd9jBTTZEbXiUvbXdfHoCMCFmX6?=
 =?us-ascii?Q?3QuHZG/g9wLScy+iVcA6V23bnX0g1vrF0VrwUtT37J3mbDGMPTmZsXQIOzvk?=
 =?us-ascii?Q?b8jdSWyfxZU9KTFXCU+J4QIhks8o6Y8jYzZAiEUqEi4yIwkWGS15ICAIyeEV?=
 =?us-ascii?Q?yenQ/5IUCdvUBH4qFbmrdrmHt7LCna+BuiI+yAiMJlSk7hm/Cxrvp/deGVYk?=
 =?us-ascii?Q?szfbc0/4eSU9zr9oakJFbMg2CUZaL0yVc2DdyoxqP8C398s/eV9jWfg6eCeh?=
 =?us-ascii?Q?7G6eiGOwNWrDKycVb11DJzf0A0eWR6f6SphgFyZIWF69NZFJEwo62zbylpKK?=
 =?us-ascii?Q?UsetQOd3YQuQ1SeWN1oQeCwTuA88gsK8Likjq6p0CTPzTjKjtfXlOZG5T2c3?=
 =?us-ascii?Q?jsyNR/Cmew1FZ2uljYCCQCQCBWlwhCPLJegYRc5y1+qkKJcWn3Xpgm9pMnC4?=
 =?us-ascii?Q?z7p8ROt95nU+SnwHLdT4f2KlnCRvW0TSYk72Z7EdHExa/mtUCGzfTKRhPjBo?=
 =?us-ascii?Q?dX2FyFKNgwkWi3cPaGRyEghBTDErgw00/0M08sZTPykzT8J26wNSQ3lTaqRb?=
 =?us-ascii?Q?ZEOiu0lYuCnXfGP1emPiXqrhIAqtH7l9BKJmmcVopWz7Czqt8NiGzFY34ZN4?=
 =?us-ascii?Q?qwwqIBMo7Npej5TpnLdIEb5cOw/j61A0CXifY0Bkp9jq8nb21se/yxJOIJW3?=
 =?us-ascii?Q?qHxiHopwEUWMTYor3rQW4/mydzc4eZYtkVsJDB/O9SKiRl3keLmpSJvpRp9q?=
 =?us-ascii?Q?SdHXghoZztL1jnfmYsL6+WMe6bMigHW2DLQWYJ5wA2WNrMaKjCMA5jur2dDh?=
 =?us-ascii?Q?lpQQNyPYf0uaz/oklqS/7UfCODZGFdkzynFv0dkucIzAsOECyblvfQf4sKIZ?=
 =?us-ascii?Q?g7tY9Y1VuJl/njzzvvd98ZLlNyAve5eSAwExYj/J/ceZVKN7T53jj4SrPF18?=
 =?us-ascii?Q?hw/+dZsdpMuRcdcDOZRwLsl+XqwUn9DIUv9P8mkDDpsxWR7HlQ4QpLmgkno1?=
 =?us-ascii?Q?ICNXrVeHKCEUCuqPqezSOIePEmg0F42o8i5Z77igzt7+IvgJ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74c54b67-8230-47a6-dd5a-08dea6ccf313
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2026 15:27:11.6339
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jNqUVAkrxsZ0u+iThvcKmCj2tihdzrn7qycXeRSe0pHBxPizRVPepS9xkCmnRtXt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8509
X-Rspam-User: 
X-Rspamd-Queue-Id: 189A5C0016
X-Rspamd-Server: rspam06
X-Stat-Signature: 7fqbyan3ohbjgr5tdfn44qcs5iyz64zw
X-HE-Tag: 1777562840-76728
X-HE-Meta: U2FsdGVkX1/LcEBmlgDRO3XnEtOzD2h/so7GqJJXem8eKDkMyEaAEfHIGagISD4c3j8m3jsuljF34Jdc6X1J4pIP2wUKUp6JdvbOX0243uqaGdFls8ogxytyxBVBu1Ac3Mz6ZLbtLGa8s4ezcHDPGFgCPZvJ9a55D1Zx0buOioAz/nSaLspSrY+Ek/xwSX94v7c9PQk+1Yf4NbLUPNIpoZKNWUTtZueWa17Cif/KkL1lfEL1pVp3j5Q66oM6ceJEbgiA+s5/f5bVAv8a8H9LuosRXD3W0O+R2W9dy+cHsuseVZIwa9WJmNvgXUKp9xUAc7Wx4JW7qSPMj5E8t/yy+SyqqcnJAcDUXEcY8rgEQobzjVfHfcEDx+KWo0HObv9fiaMStpNbEGfq5nkua94A+gTbjX2vk9zg6th7OECqIpnmOb0JnKaBAw/wItuUpyMvqrLjHE3PbmmPXhJSbCGyK9DtJ/+RCIiukcCCg4d3RECRJYG0IIHWy9yUAnYUit6XafvAmdzMeBKcLnEqVAiH819kVQI84Peal8M+zygKFyMFbefnPB2WrTN2uI5MqaRq4RaxFTXapCeKo6Nwx52zmX+fyakpmtT9WtOKSSHsSJywaNt1pCBpdsiDkif/A9Z4v7mUgWTUH4rCb6h6cHNfgHpt1NFjl+eyv2TBb7NdUiY6JeU/qWuYQaxRb17pl9aHzEqXSyh7o/4fgTjpdHVOsu67kLIVTcnbX9C6CEf54LP1qy1Nqsp1IgW0Uucv1BunPcdXoGuidnr7OQL2CMSQsr48jl9/E3yedobA1J+wXcefm0tOj7BlSXabFyxy1PaI5HBc37s0KXITg8mGNYdUaQ1HDzqMfbk/Fgf8fx5XbEEgdSNHPXaEwYKjAYysZbjDZ1qxtVP0tkOGaf9oHBe6vdgVd63cgsKwNbX06CmAcntRzfmQ8tFdvPB4Gn7pn4R+DPHmwNwzd8/IUpXE04R
 HBQ4zPyg
 eMUDjAjxnrZquGsgOUnWIJRziGwWslthwhbbqbbfVGRdK1GeiN/jixkSp6u/BXEdU+VrtAYNkg2gUuoizCwih1T2UGvf6RgdBVPrWCvCpWJtYeTkm3E9zE0EsMhDFnFE746WFgtXzkyRmZG+ojAKIH3lYDu/hgzjTogpoaVjmCGNZcqV4ibbEyvX2hm/UlviVg2TlbaYDaDiejkaGVnplFdWM2qjUZyf0mP54HeDlA05JLeNRRTmqdynH3v9L/romzt05btzAZAHe0uRARz0JEFkDkbwjU0k8DUHkC6796Zhcey9mEXCd8oF4tBKXcQ22y1QWmRBQpchUUZjxmv9tJA0SvXxGlGtqFH07n/i+qouOhU/wJ4lw1Tuem4wEl/+sDa03xw1l1aaBLKy4D4QJWEGhy/cRleZWlV0atvz1QXgrpx9EGMeedhs2Bg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 30 Apr 2026, at 11:16, Zi Yan wrote:

> On 29 Apr 2026, at 11:35, Zi Yan wrote:
>
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
>>  tools/testing/selftests/mm/khugepaged.c   | 131 +++++++++++++++------=
-
>>  tools/testing/selftests/mm/run_vmtests.sh |  12 +-
>>  2 files changed, 102 insertions(+), 41 deletions(-)
>>

<snip>

>> -static void file_fault(void *p, unsigned long start, unsigned long en=
d)
>> +static void file_fault_common(void *p, unsigned long start, unsigned =
long end,
>> +		int madv_ops)
>>  {
>> -	if (madvise(((char *)p) + start, end - start, MADV_POPULATE_READ)) {=

>> +	if (madvise(((char *)p) + start, end - start, madv_ops)) {
>>  		perror("madvise(MADV_POPULATE_READ");
>
> Sashiko:
> Since madv_ops can now be either MADV_POPULATE_READ or MADV_POPULATE_WR=
ITE,
> will this hardcoded error message be misleading if the write fault path=

> fails?
>
> Answer:
> Will send a fixup.


This is the fixup:
=46rom 76e301cf5198f33d07492e224ec627b94902b4b6 Mon Sep 17 00:00:00 2001
From: Zi Yan <ziy@nvidia.com>
Date: Thu, 30 Apr 2026 11:22:30 -0400
Subject: [PATCH] selftests/mm: khugepaged perror fixup.

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 tools/testing/selftests/mm/khugepaged.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/self=
tests/mm/khugepaged.c
index 80b913185c643..97b8fcc490c76 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -445,7 +445,10 @@ static void file_fault_common(void *p, unsigned long=
 start, unsigned long end,
 		int madv_ops)
 {
 	if (madvise(((char *)p) + start, end - start, madv_ops)) {
-		perror("madvise(MADV_POPULATE_READ");
+		if (madv_ops =3D=3D MADV_POPULATE_READ)
+			perror("madvise(MADV_POPULATE_READ");
+		else if (madv_ops =3D=3D MADV_POPULATE_WRITE)
+			perror("madvise(MADV_POPULATE_WRITE");
 		exit(EXIT_FAILURE);
 	}
 }
-- =

2.53.0



Best Regards,
Yan, Zi

