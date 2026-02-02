Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03209E7315E
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 11:37:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5779F6B00A9; Mon,  2 Feb 2026 06:37:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53BB36B00AA; Mon,  2 Feb 2026 06:37:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 414276B00AB; Mon,  2 Feb 2026 06:37:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3045E6B00A9
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 06:37:36 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0846CD5331
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 11:37:36 +0000 (UTC)
X-FDA: 84399316512.25.FA4FF9B
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013001.outbound.protection.outlook.com [40.93.201.1])
	by imf21.hostedemail.com (Postfix) with ESMTP id 393FE1C000E
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 11:37:33 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=mvwwclhb;
	spf=pass (imf21.hostedemail.com: domain of jniethe@nvidia.com designates 40.93.201.1 as permitted sender) smtp.mailfrom=jniethe@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770032253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6KVUnngYFaJYOup9A96XJHa+cqRo0HNWCHKjm2hPPsY=;
	b=j0dfwwRCc9GcSYytQQUJ+UIAbGfmRU2s30BTanLoz1sW6ZwpYowv/7ebYZ2m3OPmu/DUnx
	k69caHdfBexP5JzX9uG4S7TsfTsUlXVo2Vmnw9xryYyaO5eMQHDfM2owAaA9q+00g1jVJf
	nV+hPPFDt+XGPq2kZ4CAGARrO9tizY0=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=mvwwclhb;
	spf=pass (imf21.hostedemail.com: domain of jniethe@nvidia.com designates 40.93.201.1 as permitted sender) smtp.mailfrom=jniethe@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770032253; a=rsa-sha256;
	cv=pass;
	b=x+Td4OsxVRVbF9M/EV+FYYKkCYtu9zRlZEy+9lietXxhFjl0yVLvPKYtl5YNpML6aSdseS
	sskzV4RbVfyu81RaV87KRG303KjLEz/qdbmjuxcXXViJWldBxj2txacIkhP1eiWvMGf/pL
	/R1CbD5cHic6AP3UXi9AYmLAXia3+hM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CyXKiO9NVFTcQoBF7oB0fAy1qJJtSEr1VdvJjVWnmi8kSGm2amUrCXK8uop9h0hyz14DxXeGQBu14jP7CbmidNz/fWOPYdpTnpFAg+RaZs+wB5KmyFZCZS4eqadiKUAcN2CUemb6DHPc3RGhj9WN7ARE1NNz97mtavWsrkrT8e19zentts4aO3CznzS2drDOU2XbJoC31ZTcqn8SxXrYyt2wEf5zMBnJPzL08wnUHozBLs9LUH6FdoKEU1Z4tyvjSV6BUHN3NMmuMddBz+WzZ07puDufxOB6nhNiE9YIllb9+GNMGCCujNGSjxj5AI+DjiK2xpq7X3H09yrqXlaMPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6KVUnngYFaJYOup9A96XJHa+cqRo0HNWCHKjm2hPPsY=;
 b=h2V07E/oTdNFjhDBDLJWSXaqH8kq42KNxLT3jq7IGSmTQKAwtu3zsoXwSV/tdui4vO0zmGUxTphuvtVqTE5nKaYMDkK2+NUjH0WDpZamw1DOhKIixy+yb9FFb36t7iWekJip4EuvtxzP7IzHamKCDOhvwHuXoVS78+Hrk9qEdss0sQGH4w7Q/TjaBGBVWdPNylCVYwCfGwPNM+aBlwv9qZK7Iab2qso6IM6E2/XTGfLMsAXHUb3qEacoDCCVleMSk7NQovj8JuNCrEk/BWaLzat1rQL5MD5a6gLmvHFwsPg5bIFMgyzWBs7hedI8Au4Xgg1xnpbP+h4Qynnh9b+rHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6KVUnngYFaJYOup9A96XJHa+cqRo0HNWCHKjm2hPPsY=;
 b=mvwwclhbbthcQFbr2cA65ONiF1K+CK4GW/UZdabAICBu9CDyLg1xAvFAK/GTLkPu3gUegSNdJeMrMyjmNij01X6EHscEZRtbwtAw535jB61nTm3EuZBeKNQdvhz2Jjg0Y+OvMVN80QvJUYkaXmRIfaPqn84wOYWrbUa16wes8hi1SlFGGNaGlrag963o/XsRXqkygtOEGizhtqjgkOKJ/tyy229P84nz6TWpc+sblcoN2bHGxmkW2k5eKfPxf9RowwvJDV9fxBcx33mKl+mgUwOrrHPp5NeiC7mwdffKcehrg6rXxos/NM+UGKU8zWoSd0VH4jk+zHBe2Jk5j5w58A==
Received: from DM4PR12MB9072.namprd12.prod.outlook.com (2603:10b6:8:be::6) by
 LV9PR12MB9758.namprd12.prod.outlook.com (2603:10b6:408:2bd::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.16; Mon, 2 Feb 2026 11:37:03 +0000
Received: from DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1]) by DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1%5]) with mapi id 15.20.9564.016; Mon, 2 Feb 2026
 11:37:03 +0000
From: Jordan Niethe <jniethe@nvidia.com>
To: linux-mm@kvack.org
Cc: balbirs@nvidia.com,
	matthew.brost@intel.com,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	david@redhat.com,
	ziy@nvidia.com,
	apopple@nvidia.com,
	lorenzo.stoakes@oracle.com,
	lyude@redhat.com,
	dakr@kernel.org,
	airlied@gmail.com,
	simona@ffwll.ch,
	rcampbell@nvidia.com,
	mpenttil@redhat.com,
	jgg@nvidia.com,
	willy@infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	intel-xe@lists.freedesktop.org,
	jgg@ziepe.ca,
	Felix.Kuehling@amd.com,
	jniethe@nvidia.com,
	jhubbard@nvidia.com,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	ying.huang@linux.alibaba.com
Subject: [PATCH v6 05/13] mm/page_vma_mapped: Add flag to page_vma_mapped_walk::flags to track device private pages
Date: Mon,  2 Feb 2026 22:36:34 +1100
Message-Id: <20260202113642.59295-6-jniethe@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260202113642.59295-1-jniethe@nvidia.com>
References: <20260202113642.59295-1-jniethe@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0032.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::7) To DM4PR12MB9072.namprd12.prod.outlook.com
 (2603:10b6:8:be::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB9072:EE_|LV9PR12MB9758:EE_
X-MS-Office365-Filtering-Correlation-Id: e960bc4b-2899-4c44-67ac-08de624f6306
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?KBAqkvevuG35nWhxFjUW92fSEg+6gsr0v43zQrrlvmq5SYF3z5+XTyJjewnx?=
 =?us-ascii?Q?ohdoj8JhXyxbuqe/poPcW+IXqSGLaSQSt79TUQK4S42H2DU+MmAm5+3807sU?=
 =?us-ascii?Q?6SlV6HXFajwf/SH4nOiwGRtqbv9I31LuJLOLXKJsaaZG0Seu2o/td0HNmhA8?=
 =?us-ascii?Q?ubPJROFHp/W4fDm8oEuK30qMlicCJJcqlxKzHV8oJqS0fKG6e8aTyVd/NJdE?=
 =?us-ascii?Q?t244O13leDZ/kBkg1ZDgkAVjqBy22fbwhRbzlbRsoHY60FGRtlizZPfre7uG?=
 =?us-ascii?Q?KqU8Rw3+BZIsJEpbxBqq+uq1S/Rq/twVZV4YXxpI6K/Py8fewrXHlQS3b+RN?=
 =?us-ascii?Q?JCGb65hd2caVb/cHM2vkHwaImU467RHpzM9ArjxpfENH7LJISLxPDu6UnJUc?=
 =?us-ascii?Q?9olivxdbO9SxWA+EqKaaErVzysp6PLN++T1UDbJYQgQZmaZTZF/d9vs2LZQy?=
 =?us-ascii?Q?0o2/2laL2lvfHfNU9a8TKuZ7J0u1O75gQeuE/lSg/QmRD/ICSQcaPluztsA4?=
 =?us-ascii?Q?/6/EhiK5fsGgfmueXLj5MseeOWUqEZ9zdYthBaz+PU6k511ERxA57Pa8Ztk6?=
 =?us-ascii?Q?JrUU9Om6DZ3gCDHLtLa/dR84T+TRQq08LqbyjytAmH7Bcgwzs6eCvtceG4ag?=
 =?us-ascii?Q?+JH8y7ltWFQSkOmHt07SIxRsK0byeqDgS6ncHCuqnNkSTFgBkyd/wBXwCQz1?=
 =?us-ascii?Q?nav1DkHouds7+1sJJwocnugVcnWl2ELtMsaRjKt0Uwy/5Un8nAy2VNGrRhbD?=
 =?us-ascii?Q?wZ1BSOf8A4z1sVz9jP6O4Ub0u78v4xpH/9Y2uD57rZj9ez5Rx6JlvtzFYsO+?=
 =?us-ascii?Q?oU8P3qj5eAysx4pWu9OvK+kU06Nk5mPsEWJ6Dcek/z3d3iU5sJWuvavacoro?=
 =?us-ascii?Q?TlqfeQzdvdxh2SCRoh+N+Wow5KZlpDvg9t0wRysyE4IS/5dlWwp4xtAaBWXH?=
 =?us-ascii?Q?A21iwXsTpdSTwEFUGHYATe+RKpfp7KyP0nO7inVa9sPsilsQpUiKY3bsU07v?=
 =?us-ascii?Q?URTx6KAd1dF8gvSGAEp2h7Lc0epP/oKIMTE6kHlHcDdCtDILhp0VTdxuUWb3?=
 =?us-ascii?Q?LHTPmLOnEM5xphcvozITo+kJzqGgTbiSBmktMzKEDF/UcNyGjCnx7nq0oLek?=
 =?us-ascii?Q?wuP6l8Kgq6gIagOqzp+Ii1IqFMGinXSP+E1P6tbgAqc6NJB4deK+M9CRw1N0?=
 =?us-ascii?Q?MXSwg/dqAfZ+PszODEt1L1OYSMRamc3onSJawyHkQQHA+lOg6OTQhXBKBR/2?=
 =?us-ascii?Q?q264Uc+i+d7idwM3bL8w0kTMeOLpKCPFyolvf4cqXdRibNfVVMLldxiHdYs5?=
 =?us-ascii?Q?Shi0VA19+Rm8SZGHdR4H3+DYJmfrXrftVclUxVNU7IEJzeHvMAMcsHXHjDMK?=
 =?us-ascii?Q?PA0713EvMCIyGXaDydrWWbcByzTs5JkDE7v0de2AtnC6lcvS0nK7xMfOX0Um?=
 =?us-ascii?Q?dZmm0ohB7Lbk8Fw0bjNctuICEu+jyRgOdSjY8Lfu4Mt0w1svjuyqjqIg4xUL?=
 =?us-ascii?Q?n0AjasyyvQ/l++IDjz2s1ZU2CI10huaeX7tfHNitW3Q6qrZKnxJ6gxgXsOzi?=
 =?us-ascii?Q?Mb5ChiQCi3ysKhJs0kE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB9072.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?N1fz5EZL6QoiktK35pieK/fk7RgZ68DjpjalxUNaGt0ZcoqoECPgwC9M5oPc?=
 =?us-ascii?Q?83zwKvifD/1DlveLpCq73/cDONe+QQLCP+hXBelLo2l1bigiaTAc9fPQjnqK?=
 =?us-ascii?Q?Bl7RrIIdJ6YNuR/7IMirY4Nd4/ZokRUn8m/ZunwxAf615SSoABvJuwiawsS7?=
 =?us-ascii?Q?GJ7OOlFI706Cc4v8qOdn6Shplskek3Eo6d7dzaxzVxeDc/irTTXluOW+u/JM?=
 =?us-ascii?Q?EAjkuQKvXVlj1JopWJHNDyyB1QRYo/fiOOnItFoQtYb8mU26RcTECrwRComD?=
 =?us-ascii?Q?cFJioxKaP1Osi6qRfgPpvuuZ13Q+zaCqwTd98GEJKnIY+gO/IDh7nF1A0+TW?=
 =?us-ascii?Q?e0Lb5YBMgU5EoGFKXfXjiYMBYBCR7KOuuxslKOABacl12bozs5REqJ1R7K6t?=
 =?us-ascii?Q?4dudiUexyvJ3QEKt4H5vAYywCaJ4ULuPZOvCZYQuDWFpYdEjaWboQmHKs5PE?=
 =?us-ascii?Q?xTXugEbT0YIFsZbj+Ah5DqW/TGoIgI5sYzsWjbfprrglZyEjjlEfli2MncpK?=
 =?us-ascii?Q?8sORWf1iobN+4YKLjy6p6dJ6j9ONAQj2koHey46azo5JcE5n9znho+oXTFRd?=
 =?us-ascii?Q?6SlVTrHHv1OOo1MoNdNfrSeYZUtbMvJMSlKzrBFtfs/fwttIwhytODaHCUjM?=
 =?us-ascii?Q?083VNmuPm8Ojq1cbZ48U513QaCqjP0sMwIn9mpM4pBJquIxX8rwTxbriudYW?=
 =?us-ascii?Q?N9joHoOnOE+6pwXPljIfwp6F1t+doNcv6oyluas4ydfldr4OAURavgoNfUf2?=
 =?us-ascii?Q?JD9QhhIDHsFT1roi106pXTWa+RNCvH9NwcPioQM9Nff1p9px6kUU02S4IEIK?=
 =?us-ascii?Q?BR7IX36ZzT40X9oo+/8XMXOiS0VXmEoOvXyOQlyWBHQzMxFRfgvOAMPcJZGO?=
 =?us-ascii?Q?ILhAFl3YGSCwFeGxJHvROgCmLq8QQcPjbBU2L5jafS2/bTHKz9bYiRnipoOU?=
 =?us-ascii?Q?oVo30l/Mx/d7p541cO61WHyd5SyZjDzB1afeWLR8hR/W6US1XcMcwyxo4qen?=
 =?us-ascii?Q?/ClKbS3D0yc6k1fUEgm3IjLcUjFbvZ2/qQ5S9puzejB9N/u4KXlPFqNGea/c?=
 =?us-ascii?Q?MCwdao0vXr9V2er24EMKlXyx7ajXAjl7Bk2FSOhoPl8AqCXQtxPGjEIiW7Yu?=
 =?us-ascii?Q?rDi9fFt4NPKUgWpZ2dwFq0yJ5zZt99P7YmUHB+huIsI1amr6J5y5a//RItyf?=
 =?us-ascii?Q?n4ogrCgGhtGlaYIG66gV7w3w3hdIc9IVN3wwWEVnAUsZRJeV/FqLHqHTNK/0?=
 =?us-ascii?Q?94QX2dYuTfZngfeFGkN+Moaea7nf4TcPMV6ki30KYq2GyKik6uIOGb8nN3Yp?=
 =?us-ascii?Q?3g5UfjebM+SS5YQvW/csOHxBjI/KRX9AAcCimOX0OJ5G621lqOZoRLmvdRee?=
 =?us-ascii?Q?dhJB0SY8GUvOMn1WOpEtga9+9FWE1rSTdVxQRrjf4nSnwcEHYNnhaz7DYSe2?=
 =?us-ascii?Q?CE6ctp/eBhgqou/HO3EHpaucsx8IMK0arluMmlb1qie9Gvhe/GBY0e/i6BB6?=
 =?us-ascii?Q?wPG8FahNF4owr91FGCReyKH2I4cgmtcMJ88wqyzRRwAEt6AlGkrC5rnv46eX?=
 =?us-ascii?Q?RIU9ykMogeyr6Tus0jSm+AP4eDp7xpGB0oVJQULBmKMWmFXaKhjCN04RQ25b?=
 =?us-ascii?Q?NvfY+c7Y84raLcBgVvJ8/ooTgyXcvV4rVam4uVL/VqFIWrLSmzeCk34GHe7R?=
 =?us-ascii?Q?tJyJeJsm/QMkV6kHe5MYvvy/ENZQboTIy/SNYKyegX/Caym9uxIzmxgOOI5T?=
 =?us-ascii?Q?GNFOha6mnQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e960bc4b-2899-4c44-67ac-08de624f6306
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB9072.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2026 11:37:03.7664
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /fceedoX3ygUx56TtbDRBAio6vOb0VUcofZb2CdcXmCSRZqjv19qdkF1HGMIsK/dfChHrGKKnRqgr5yZIPZiuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV9PR12MB9758
X-Rspamd-Server: rspam12
X-Stat-Signature: 88n5idp76z3o9uaqx3dnuakiyde7mrue
X-Rspamd-Queue-Id: 393FE1C000E
X-Rspam-User: 
X-HE-Tag: 1770032253-72185
X-HE-Meta: U2FsdGVkX19t0x9YK3kP5YXhL/+bjRKY35BomS1nDBvFtx3f1cBsDPn2hCE4QD+g1UdfA1EyEBGV4XiKKwX4xbt3eEERhN1fLk1zGg36ffpQFsZx8zT2gzv/tFQ2SZ3UMcme4ht45hsiUqiAp8mGaoXQ43MfSkFoZ5RqTrBbqxDHwVVcFzVj29r7HpNao5uW8US84dWH2OtzBAjTYMAA4HAd1OnidyXZKw1YBb2OUiIuzNWbFkh4hzPXNKFrHmhaP6ch/uSJ5wTJ1uvx0wuq8E438VU8/rp4pspKGuiWfXvZTASr1KePnU7lMgog0yj1jdoZGQuYAMHiVUURx86i3uKliqyWpYloG0PzpV7U4U2zFIEomhdw+hipdPbONKKhg65jRuqKcfzGO/BxBNf1eUzf5HYzW8VvmEcZxxmzk0YV5L0MZ7/d64AlolqNvYDRjKgcJ0/ARDaz4Ekm+hBxSscY1IU2dM1fQQ12KlgDwGFmQg5c99ptTotmFOX/LI99EkPgifMB9YgCk2pXtwUsBSIwVxpPVgBM7M6fl2rhiZV/ObQ+CE62huV+B++YrOKh6KGD/B92qkj+Eby0HfNru/jjsF8mBdxjMdC9Nd8iaPiFV4JrwfeusJClJd3QGtHR9/eK+jCUvCMuUPZZte6aYqbCKxWN6DN9b7SkFeQwmU+znmcQprFOc5dbWBPvvCoZzjuMax+yID0Hm0DiVlY7t/UrAafMg3RIJE1ITRzoLwAtdoFI15HsRIEr69Y9Zzn0F/NK+zr4I6PQjLXmH/GHZTEfqMa/4Qws/thKOVkX2uw5ftaKtlqjx602cC1C6BTo0Syz0NcumrRU1Lb6S3jzPk7UuqT0JZNXkG3Xdh/iz2htzrGZaPUgKVM1JGaao7YIWSKRzl5WdWPQM/V2j0FfHyG+a7TuoqeIN6CR+83/JZr3LPDW8d7Nh3KVQtIh5mDsn6o3CISiDKKKR7l5MQB
 xK1S+dS3
 at/kpIPerAErFQ5axjRGzLauKH7MUfSYznGj3Nhv1ycFTfxdAW4nqQHJeHC8WJ/0GpZ8GTXW8mySyu0bK5oNXC+choKSZdbqc5bIumU/vP91x8SOmdzUD7dJoRo2bhdPVo8K7NLsQJ8rqxSIyFr1/mOFi7GwLPEx0pizr6YdfAKSXxKP3wB6w79NFpeZAl2KG5trAXGVNZfc7mvi2BRT+cj3abS0zrXlkvb5A0uUiSnrdMzFbXwLSlpjcS1gccZ3EGGjFt0pavU2M2EUI8Piv9W/El4y46gSM0tQ/yHmZh9yWeTGuHKiURca3CSqAgRz1XE81SYQ//MbzRoaAvCjTsKdOz839wqfp1wClV2bRPHmACNBbv89a4UGNStvdA9iKTgNxl8pntR8ndbSarcP/fpQg9j2tFZRASCliFRR1IoCVmGf8YIzOcDDboJ7CF6eu7JhkOvEk+RUeTWKGxvlX+Ys0fpf8I83sreo+9SAmJS2fcLXGoZlQva/P+0XKjlCg/vkrBzmF0vpkbXzEOelnde5YoGr96tCNE3VAe4Z7wimPfkwGLc9s9lvlahya6kHwlh0FRcPGDdzV9Sd4R7C10+pXSbpnv0Viu5pHVYMxWlaIq9gfqA4BO4FI35OJT7QTKJKa
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A future change will remove device private pages from the physical
address space. This will mean that device private pages no longer have
normal PFN and must be handled separately.

Prepare for this by adding a PVMW_DEVICE_PRIVATE flag to
page_vma_mapped_walk::flags. This indicates that
page_vma_mapped_walk::pfn contains a device private offset rather than a
normal pfn.

Once the device private pages are removed from the physical address
space this flag will be used to ensure a device private offset is
returned.

Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Jordan Niethe <jniethe@nvidia.com>
Signed-off-by: Alistair Popple <apopple@nvidia.com>
---
v1:
  - Update for HMM huge page support
v2:
  - Move adding device_private param to check_pmd() until final patch
v3:
  - Track device private offset in pvmw::flags instead of pvmw::pfn
v4:
  - No change
---
 include/linux/rmap.h | 24 ++++++++++++++++++++++--
 mm/page_vma_mapped.c |  4 ++--
 mm/rmap.c            |  4 ++--
 mm/vmscan.c          |  2 +-
 4 files changed, 27 insertions(+), 7 deletions(-)

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index daa92a58585d..1b03297f13dc 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -921,6 +921,8 @@ struct page *make_device_exclusive(struct mm_struct *mm, unsigned long addr,
 #define PVMW_SYNC		(1 << 0)
 /* Look for migration entries rather than present PTEs */
 #define PVMW_MIGRATION		(1 << 1)
+/* pvmw::pfn is a device private offset */
+#define PVMW_DEVICE_PRIVATE	(1 << 2)
 
 /* Result flags */
 
@@ -939,14 +941,32 @@ struct page_vma_mapped_walk {
 	unsigned int flags;
 };
 
+static inline unsigned long page_vma_walk_flags(const struct folio *folio,
+						unsigned long flags)
+{
+	if (folio_is_device_private(folio))
+		return flags | PVMW_DEVICE_PRIVATE;
+	return flags;
+}
+
+static inline unsigned long folio_page_vma_walk_pfn(const struct folio *folio)
+{
+	return folio_pfn(folio);
+}
+
+static inline struct folio *page_vma_walk_pfn_to_folio(struct page_vma_mapped_walk *pvmw)
+{
+	return pfn_folio(pvmw->pfn);
+}
+
 #define DEFINE_FOLIO_VMA_WALK(name, _folio, _vma, _address, _flags)	\
 	struct page_vma_mapped_walk name = {				\
-		.pfn = folio_pfn(_folio),				\
+		.pfn = folio_page_vma_walk_pfn(_folio),			\
 		.nr_pages = folio_nr_pages(_folio),			\
 		.pgoff = folio_pgoff(_folio),				\
 		.vma = _vma,						\
 		.address = _address,					\
-		.flags = _flags,					\
+		.flags = page_vma_walk_flags(_folio, _flags),		\
 	}
 
 static inline void page_vma_mapped_walk_done(struct page_vma_mapped_walk *pvmw)
diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
index b38a1d00c971..039a2d71e92f 100644
--- a/mm/page_vma_mapped.c
+++ b/mm/page_vma_mapped.c
@@ -350,10 +350,10 @@ unsigned long page_mapped_in_vma(const struct page *page,
 {
 	const struct folio *folio = page_folio(page);
 	struct page_vma_mapped_walk pvmw = {
-		.pfn = page_to_pfn(page),
+		.pfn = folio_page_vma_walk_pfn(folio),
 		.nr_pages = 1,
 		.vma = vma,
-		.flags = PVMW_SYNC,
+		.flags = page_vma_walk_flags(folio, PVMW_SYNC),
 	};
 
 	pvmw.address = vma_address(vma, page_pgoff(folio, page), 1);
diff --git a/mm/rmap.c b/mm/rmap.c
index 7b9879ef442d..7fa976b7fb5a 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1871,7 +1871,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 	 * if page table locking is skipped: use TTU_SYNC to wait for that.
 	 */
 	if (flags & TTU_SYNC)
-		pvmw.flags = PVMW_SYNC;
+		pvmw.flags = page_vma_walk_flags(folio, PVMW_SYNC);
 
 	/*
 	 * For THP, we have to assume the worse case ie pmd for invalidation.
@@ -2298,7 +2298,7 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 	 * if page table locking is skipped: use TTU_SYNC to wait for that.
 	 */
 	if (flags & TTU_SYNC)
-		pvmw.flags = PVMW_SYNC;
+		pvmw.flags = page_vma_walk_flags(folio, PVMW_SYNC);
 
 	/*
 	 * For THP, we have to assume the worse case ie pmd for invalidation.
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 614ccf39fe3f..101e1a16d75d 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4203,7 +4203,7 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
 	pte_t *pte = pvmw->pte;
 	unsigned long addr = pvmw->address;
 	struct vm_area_struct *vma = pvmw->vma;
-	struct folio *folio = pfn_folio(pvmw->pfn);
+	struct folio *folio = page_vma_walk_pfn_to_folio(pvmw);
 	struct mem_cgroup *memcg = folio_memcg(folio);
 	struct pglist_data *pgdat = folio_pgdat(folio);
 	struct lruvec *lruvec = mem_cgroup_lruvec(memcg, pgdat);
-- 
2.34.1


