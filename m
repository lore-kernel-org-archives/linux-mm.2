Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E975AF589DF
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 02:54:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C0B56B0093; Thu, 23 Apr 2026 22:54:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 571C06B00A4; Thu, 23 Apr 2026 22:54:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 439F16B00A6; Thu, 23 Apr 2026 22:54:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2AC8C6B0093
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 22:54:29 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E0B6C1A0B74
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 02:54:28 +0000 (UTC)
X-FDA: 84691931016.22.A469767
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011068.outbound.protection.outlook.com [40.93.194.68])
	by imf18.hostedemail.com (Postfix) with ESMTP id 239891C0002
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 02:54:25 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Ui97Mla9;
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.68 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776999266;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=od8P0GmkgYI0ESWXZBNnXFbZ2LfGvFJowPgjDa5gfC8=;
	b=DVk05SNRn+WQiuUBg0hWuCVfTp8SChQ3UkGau4YsKYHIVKipI/vZd3sRWrwfeekjPfAMuF
	sabu88kVT7qmLb5mAIjfEeqzzuoLTwY4Jwz/tft0hD/exeKlJlpccHim4X1gYxOBLliJU/
	GVAqfEn63bHGYC6Ibaq7KtWk+5oTLFY=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Ui97Mla9;
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.68 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776999266; a=rsa-sha256;
	cv=pass;
	b=G4yiTUSFhJVy3lk503eFL39BjwPz+5L0Jccr6Shmfbe8m6o88mgQUP1DJuhF0OAfVuu7s5
	3Lm3zH3Moky+f5kt/1cdODZYRPXCZyoC3AToOynJPzL5kxtf1qvTSErFo6qg1UMg4ko/5o
	22BhnBjkl3mGV5172z7NtcGbgVKzi/I=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=htun2EzaSwJJXbpBII2Z8UoILRHXWHFmoAM3nT+awWxP0EB1kRzpEmwcGh/vvbfe6lgIHwGh5CeB2g14k5Kpp1Sm4gUfSk4QELdahX1WJqsxo8/jjIIpswsbZBnPZiyQPgQm6xe12ZDIyIsFj/Elzveic3KQGonVbZZBRhDs78nK4m8rGSsFoqL0SUcoeZXTpkvsTe11R4PHS8mTYiE2CAZrq/KNclOswR6ku+eOxPyAEMVV3yUgIG40gr4oscqp0+E74/mdOCiJR1WWNQa8OKt5a2gNtU3NTwl1v69TDHUL/i1nkZvIUO+vH5XfzFc9PNg718k4pS/XMqJggn1YlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=od8P0GmkgYI0ESWXZBNnXFbZ2LfGvFJowPgjDa5gfC8=;
 b=BQJjA9deraa/j1DxhCMwgzy+hLPTzehEnDZgveYtWu8rVVQZ2r1ZUn8aUK1TL54Tvm3JHrDrDDRGe/ai9QYLFYLF5PL3PPqAEedSlsa/DSMIoE09f6vnnExl8j2VtqCaOmT7HwgB2gsfRN6PsPOQOYL8FyWqaKtjSoyPmcy8A5qM49j04c7jn2KNRF5vcUNY0b5DA89Fg5hMZfZi3xS3UAvs4Ygp/Sz5zggZ4CLe9+Sx9jkkmFziv3ndQaesXMoLQQqM2uLJ0HUCsSpYVx/HTnFunvLIcekxCHwQHO9+Hm50l0FkZdk1sxxOclpaQTsR4KK2Xu3bdDUjTCcSpUU9LA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=od8P0GmkgYI0ESWXZBNnXFbZ2LfGvFJowPgjDa5gfC8=;
 b=Ui97Mla9HrzUQzX/zSgsFNnJtv5Aua/ogosMDyC2GlhfUQa7xcSAyEnMBCsM1phU+M0xmyW3yuyW/rmEwrS0NkMYxxX5+tyMTzDaRmsIxvKNLz6bhY3CepKUMi2y7SzhUit9ye1LJ98M9ZL/9gWfU05JXifhGLND+j1o5V/oiFDWkDtNh3L3t9M31h14KM12dhpbGk7NqVL+jLjM5voZH7FLmNcTYViIjfNXAYPana8ZBs7BzHXbAy9dOkNdMCH5B8Zxu0DU37tyiQ0vfyfHaq0sqTuSLbw6zH5xawPeNpb5aoNwMKiwaKxG+BZmlbh+85NDseB44qdA12ZMHdbT+w==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS4PR12MB9588.namprd12.prod.outlook.com (2603:10b6:8:282::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9846.16; Fri, 24 Apr 2026 02:52:19 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9846.021; Fri, 24 Apr 2026
 02:52:19 +0000
From: Zi Yan <ziy@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH 7.2 v4 08/12] mm/huge_memory: remove folio split check for READ_ONLY_THP_FOR_FS
Date: Thu, 23 Apr 2026 22:49:11 -0400
Message-ID: <20260424024915.28758-9-ziy@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260424024915.28758-1-ziy@nvidia.com>
References: <20260424024915.28758-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR20CA0051.namprd20.prod.outlook.com
 (2603:10b6:208:235::20) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS4PR12MB9588:EE_
X-MS-Office365-Filtering-Correlation-Id: be5205de-5350-4f56-f43b-08dea1ac802a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	QsA4AxUR9Ydk80oFmIggMk/xJjhpTfOoMKak21AGWQYYN9s3Qkguz5/kKaUupc1CWMnkBAWjCWVUSScTpMbgtFT6FP0cDHycg2zpvdEZTilZVj3MAw0tu/gt8RsyhSa2/UUYovpFhTYvbPC1/8ykdkNr9szJNV1/KETCmURD+El48aONxx7+51upH2LUJ+4HVrK8gj68S2XrV9QJ5w+PeaYeKJHrfxqkUyb1k9kMa11TiMi+luXSJKVO8kqT3rSwmB3ztu7nlh39cDdSSlg9BYkeTL1QlJy4dhW629GiStM+/qZivs1PvAwNLzPym9xWRsTJF8ThrngZDwxKvbvMoCjWP2545ESqx3fQo8Mjt0WplGMPOwv5fvKi4rvhobLoFnKkb6bV2VMfmidwlexfaY/nFom8/R5VSMUTfu11rZ/B3AtR/UOUbcAAdTmggjr/jIb/pkW28p31ubv6VMTU9Rbyt501CAtNoKbH23afPcetk59YSuMtEm8vEFI8N3PFUCVXpHeFQZh322uHfAbhVngdVtVpqqsyNH7WatbjhQIdq/GMEzg9sddkRzOcH/vR01LJPcmGPrOiNVidBn4SirOtSdBwmHsHbeh5pieWZ24o0SPcd5TV5g12G8i6h++rI8K2FXDL9tDV4APqae72OvoKtQLhRhdSZbIaj8a3jVMdHu8yAAHGIZcfxANZb1kZyblwULtwyy3ZkF/1LVQzimLDWB4tQuBT1eR7YHTwk/k=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?S4D90Gchzp/w0aftOWcDBCEZEdo5r3p243NkMsPCu/OlgXGKHEPXK92cQuNn?=
 =?us-ascii?Q?Ku3TY/tSG86U1hsNxCySA7actWcS3Q4zNCjsFO0dzpyeoDEneIfzygpaACjT?=
 =?us-ascii?Q?/1KKTov/3s5Z9TxFYbcakhpRx0i/UuPr3stOMN64Yb6o3p33cXK23Yd3QZCG?=
 =?us-ascii?Q?GqJBJnKYkaeDk4TXnOMiPMf5yDIrFky3uY/znFGU8URYUCCsizg3ea/f+5qS?=
 =?us-ascii?Q?ewaT0VVjZ0ng0qDsS+MjpsSyS2+63twXqlrYHiQ7gPWbYOvmpr2fTgi6/Jtk?=
 =?us-ascii?Q?6/TsAP/+If+eC3DdBZgg4L0eQ0sJml3jof5ylVx19HC4UcNAr/5Q4VRCH3lU?=
 =?us-ascii?Q?/tioAixeXzR5Xwc49OjC1wZpk/b097GDXh+fmMRcAWq/+N84/r0Y7C9JWhcZ?=
 =?us-ascii?Q?zkyU26B9vA241CFVDt4GJMiNKR0/Fqofq2CW+SS4nepAw8lPNRIdecO37RaH?=
 =?us-ascii?Q?fw4bQ9v5uPox3gTnJpZgY3BZ1xGsYJxgzQWLdrnuwC7JTMFFYL/i3nHpU/dl?=
 =?us-ascii?Q?7oKU2FcR4DdCy0lgYlV5Yw42fFkBaCvP/NiV76b/PTLSXt+r6wDbZyR4fNZ6?=
 =?us-ascii?Q?tKLmw/xwXj3yPZiiKkCdP/W/n3Y2opo86kGDjQMf3M1WbQHDwDW+VhFFKA4V?=
 =?us-ascii?Q?V2Mlr7Vkjga0023nynvcv525c9jg5T/7kNo+Zj43aurV6LaNShEXwnLuU86B?=
 =?us-ascii?Q?byGnWuc0W8uTQymMMaAyKCi3SBoZ1aT6zkvPGiwaoNVmE30r6mbMrYE1k96x?=
 =?us-ascii?Q?9QdYEDokL1bBTYIO3OBgewnniBI60cb+GDQp9lA1JHdTq4/AtvLs31Z8F4pK?=
 =?us-ascii?Q?rkpur2Hn76Z+5o14nifHN2oIToUgV+b00RsWwwEXFkF+5SO2FMry7G3xeXD8?=
 =?us-ascii?Q?E6inRyYtFoelWq2VQPsTCQVsg20rxmLkOj4ZrJ6l8guotbAowFvROYw+gdmu?=
 =?us-ascii?Q?GqdYiVvrsocHGni1vzhJIa0HHuy2M0wwTi1Zh7vw048gb0zujOseSrFkICbs?=
 =?us-ascii?Q?0NgYDz1EbkuL6HM73xhRQ6cqHva1j3+TJSQ9hcY/MMwptMD3tk4x8pJN/dup?=
 =?us-ascii?Q?p2w2eOr8Q/QQBOBgwQoya1Fw5IPbfABdNi7reFNfvT+yghGaKRvHTYyj4qpN?=
 =?us-ascii?Q?SMI7JroJ44gukEmUpdoTkX8MYCwxrPMjASt2PNhx29XLzLFSnC9Dg07oxfWH?=
 =?us-ascii?Q?u8tAuXQjL821vm/8yna2nnO6H+xEx68rfUv9AAAVjzWNtJz/ES8lEiK/gpAk?=
 =?us-ascii?Q?Y01jufJ0dhmV4Yx12nLYfUxlOnmvxc5Z9eztAitazLnYbedV7A8xFI6rWsL5?=
 =?us-ascii?Q?WpwiySFNHYSxlKUvySmqR5EH7lA16e+OqCw4BeiAFnyzEfnDjlW1Y7DlMyKr?=
 =?us-ascii?Q?KFPcBAsOPJsoR1qhJj6JoM0cMM052ocAqMnXaA1G+ZsiUpjEzo7Z6AyJTKCu?=
 =?us-ascii?Q?Y3tHZO/oBMDZVV2NRRERZBJKv3dYp5eYQTUiRdLVDQO1/qMhZjJhRDRu1l70?=
 =?us-ascii?Q?7Fpga10cxTbsMhSxDLdpMLKM91ERDOs4r064tPsa8oeOHHNkk7Vfkb6oEe8U?=
 =?us-ascii?Q?F1f/02LtAuaWY0PojgmOQ3Q0T7wMLZbCrhGTAsQM05UmHVTAov5+o9aRzmOM?=
 =?us-ascii?Q?+2lVyRfsf5WsgTdI0o16D8nRAXWLwZ3cUHLkrDzvFWMv0Rfx8cF2NvX8v7TI?=
 =?us-ascii?Q?1TLLvxT8qVJIvpUuWTNWpeCRJuhsshFWv+rxgmRxyHAcHbpm?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be5205de-5350-4f56-f43b-08dea1ac802a
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2026 02:52:19.0969
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TjNohwnG/g05QsBNdye5G4yWy/H66hXIYVDYqF2R6khsMDZywNLL6kENpSbhLi9M
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9588
X-Stat-Signature: ogx4uumtpra5h5b85eifgqtb91ide7ck
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 239891C0002
X-HE-Tag: 1776999265-128092
X-HE-Meta: U2FsdGVkX1/74E1FeCrIJLzEcF84NlwqOFlk2ehdUeGojCo2AvEaI5/PhVyw0Zm5aBlHNNayNkLt7DxqeLPnqxDrspEGJHn13sUi1P4btnRILA9jUCN1WqAk9kLRF6+gvbSVch+llXN9MGRPPP4WWOlWFNrQAmJWJa+zbIJGO3uhTz5nYrr2vypjtpkGYgozG71oXAhQgkjfGM3N4DxO4ojS9kwz4HZk6WSveGBBLXEi9TWMu67f6FCbkgzu03rs5iIH3/0+jZwXEr6RX+BAQ5ozMetVQz2B545iIdHKfPLF7A9i3yDqj1w4Ubv86kiaoMnMSStpaThGOMdgkaJklbK0SjehO6YyQ897e8hosTRvZ/x8/Sbx48TZJzNUhZq6W5MqNItw9rp8s2FBst5AHdSS7lyyOtOEcIwyoaJlNlAEJt1/oU8uWF6XWURmbEnDEimYsLm+F22/ppjSM5ee6LljgchiXu7HXKS4Kcaruu4eTCe5A9+CdYL8rCC8UP6f5f7yof+UlGQGeGD9ARVUKUPZQxy9tZymShkcbP3HZSos9gOb7KVSIVQfshr2scK9qRIhdRhh7fPJ4g6KS1Hi8tViV1go3PHOhq/7iR7qqPsrc2CRPve5Rmg/uAPmQQ+opNbLPHDawG+H+eqj4wixMc3VtZ/uN/d1D3je2DfdaH1f4mHXfgQN/UMz1fcpUspUkyluxde028s/nyMtJ63cmTf6a8xm9BfBDpA+ZklxhSwOvJXAXO/t93vXDGo48NfaKBVuixU0j/R1CVtF3K2Zgir+CghdMlhDQoUfhSD7lBM8nyJcHXzH/qxTJC/3S5D3AbqSDM26EJHNZBYxQQ7BfhKuYE4n0B/qOY+cZPNHe8e9puNGTSHQyaxrVonbE8+z0yoXD8Vs6aitWOP4achAGRbRzmXsed7UilRGUoUTXW5N5DsXjuzo6EDwp7Y+NkSQOBFZMIyqEl2rSbi0sOo
 tUpTyYJN
 cR83g1bba6MZH/A9HqD8gNBQxaZ5Ox7pFnE3hfpeQoC8A6ZDOH9LI2KFihYwF5Wgek1+VYV/G2EJ3Gi06F0aDKhtrPSCGiu0LsHuu+ZXkwCVM1iOOaUonzFGvvEkCADBflD1lly0A4Y8JKyw8j5WUaPORPSJfj15xNSJWK0AGUR1f5qtVvpIAQmc2pJ2fuuQ9fYjCTDRA7k79zLCLNuXLy2WfKMYPWjuAdN2QBrtnA3tBVBk/bngK8PCt9H5/NdGESqXg/GbVr9L35NizcoOg8dTXXGfgxEyk/FPZEjtrE50TbdQLPdW7LsYHCydpy+fBrgq6sqica6FXkuDCpf56nbnGvdRg3NgnjkRU06UTRkNooOLV3bQSSe+hiFVcd/uB3TlTfgf2xZ7Uvocia4YYykw4fpFpFr5ZopB6odhB3fbw1+imBvgIw7aDMeG/L8tRoyCUHQOVJxmN4fQ9jznCGnyN3k8hJ/XSXMfG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Without READ_ONLY_THP_FOR_FS, large file-backed folios cannot be created by
a FS without large folio support. The check is no longer needed.

Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 mm/huge_memory.c | 30 +++---------------------------
 1 file changed, 3 insertions(+), 27 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 8b85a3e58b00..a76ddc63195a 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3832,33 +3832,9 @@ int folio_check_splittable(struct folio *folio, unsigned int new_order,
 	if (!folio->mapping && !folio_test_anon(folio))
 		return -EBUSY;
 
-	if (folio_test_anon(folio)) {
-		/* order-1 is not supported for anonymous THP. */
-		if (new_order == 1)
-			return -EINVAL;
-	} else if (split_type == SPLIT_TYPE_NON_UNIFORM || new_order) {
-		if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
-		    !mapping_large_folio_support(folio->mapping)) {
-			/*
-			 * We can always split a folio down to a single page
-			 * (new_order == 0) uniformly.
-			 *
-			 * For any other scenario
-			 *   a) uniform split targeting a large folio
-			 *      (new_order > 0)
-			 *   b) any non-uniform split
-			 * we must confirm that the file system supports large
-			 * folios.
-			 *
-			 * Note that we might still have THPs in such
-			 * mappings, which is created from khugepaged when
-			 * CONFIG_READ_ONLY_THP_FOR_FS is enabled. But in that
-			 * case, the mapping does not actually support large
-			 * folios properly.
-			 */
-			return -EINVAL;
-		}
-	}
+	/* order-1 is not supported for anonymous THP. */
+	if (folio_test_anon(folio) && new_order == 1)
+		return -EINVAL;
 
 	/*
 	 * swapcache folio could only be split to order 0
-- 
2.43.0


