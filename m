Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE38310FCAD2
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 20:33:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 240A56B0088; Wed,  1 Apr 2026 16:33:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 218A16B0089; Wed,  1 Apr 2026 16:33:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 107BA6B008A; Wed,  1 Apr 2026 16:33:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0111C6B0088
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 16:33:58 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8AB97B6E9F
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 20:33:58 +0000 (UTC)
X-FDA: 84611138556.10.FF3CB59
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012017.outbound.protection.outlook.com [40.93.195.17])
	by imf04.hostedemail.com (Postfix) with ESMTP id ACBEC4000A
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 20:33:55 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=A3ACM5MY;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.17 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775075635; a=rsa-sha256;
	cv=pass;
	b=EnKFSc1ijmzPVDobY9jpk09OWs7y/Z/lnzZvXkgZAzFBm0GoLf/Xcbb4sA4IHYUZQOUkzu
	teP0BeZqMGSUdO2L1W4o0/rLCKHz3w/ozsl1kWJJrao9c9fiOVhVk05OuUfzYBsysibfjz
	YXGaVoHhLsji+Jv0QEI1AZLAaf+xDj8=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775075635;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=09/dnBzCbuwdhvc6VknTIFw9sSiv7E8tUCMr1VpTw9g=;
	b=DZTmT5Grw84AkDKzVhR1VTJBYiU/KuTw3fIRut89Owhy4b7RYvlPgbMdkcu9F/cSv26UjO
	8VfaUVfhjj8+PEh4ZpCNdCQioTrvoHTN8qhCbWegPBLZ6eE26PVOB1X5C2Mcn5koBO2VYp
	LKVv8PbsUsrrlwSl9rATNKFZgdlO0LM=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=A3ACM5MY;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.17 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ARO0ed1quhnk1YRrgMAXHr1sc52Cm4vVikL3gSUd8X0Pc1s6BtOJ6CcMIWpTznMMDmd0RJ+/AjuUhEEHj8UIj5dL1tqwqKE2tciu1T7vRadCEW1YWYiowD5YgPCO7/NGCK7axSm8NyUMWedd782U22YqI7p/FBn4DYo7lFXW0eRrYOrmo6H7qmOBe54PNfi+dpi0Kj+dB0agGfqgSpT0eXRnHB6oVhlB3GH1YCNsKLVMrv7U7dTIzTFMzwS/2tw7tsmo95KYaJVpHjt/K4jjoeBCEHF4Ho1Jq0OE7VCv2Wd96zyBFLRXPatY8rM1dI3nnFBUqsOC79gOYCq9KXczBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=09/dnBzCbuwdhvc6VknTIFw9sSiv7E8tUCMr1VpTw9g=;
 b=DSkLN681i5f9J/4sKYXS9/SED1h+L41dXu4kkuG+e6ET9JkzuHT5YtNKZnF+/gpZAaA45Lx3AdZj/+Ek40Ca+MH5/nK9RPURHSFTZoqnoKgy7GQMmyfLEh6e7FEMwvSwYSAD64GbFDI0EiLnCq8d17+cALFDcJy5PqslhGEaxmXmGj59E6AE9M4+VvYy21xByn2uA31z50dbifKhlgWoEDmUXf0XVNAXq0xGyg2VO9295e3A3373PWJQNwetwIDU1wlYcMS0JnRxlDfl+sI9ory3gn2eTW01J3Ss9LES2T0m6UEicqTVf80P/l3UxIzHrxiRD8bl65GoVg3Fd31waw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=09/dnBzCbuwdhvc6VknTIFw9sSiv7E8tUCMr1VpTw9g=;
 b=A3ACM5MY8biPlQ0pf9wKvuuRi4zcgX0k3LmqzP5tr8TnPLx9Ku2iCG1u44JxTl4M0bU3ojTegUwP5yzb6Sr1uQgvHrPBiR0TCt495LlJqbMDqhxRwLmZWBU2mfyHmhFoUN5NXLqxzYufbyQOsbElvV6TfF48PbSJNmnOhZ07bKzl5clvkUXKvGpzV9aQOj3xL1aCN+vL+agXXNb9oOz+gDzI6wsS0mYTKEe9nHpreBu2KsMHjlz4W5RLgxNPKuHhkf6RuAgNIdeCJHbmLkSpkDcgmS4ZeU4kX/NQaBtowA0avRxLdVQFF0N6j4B/ZxmhlyNvBCDTuqMt6u/52A2ksg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS7PR12MB8290.namprd12.prod.outlook.com (2603:10b6:8:d8::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9769.17; Wed, 1 Apr 2026 20:33:49 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9769.014; Wed, 1 Apr 2026
 20:33:49 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v1 03/10] mm: fs: remove filemap_nr_thps*() functions and
 their users
Date: Wed, 01 Apr 2026 16:33:44 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <44DEB48D-589B-493D-A278-4896BDB58564@nvidia.com>
In-Reply-To: <f7e1bdbf-cb88-42f0-ac48-1a273bda2455@kernel.org>
References: <20260327014255.2058916-1-ziy@nvidia.com>
 <20260327014255.2058916-4-ziy@nvidia.com>
 <aaea8ce1-eac6-49d6-8c85-7361977b9a9f@lucifer.local>
 <b098fce7-be16-479e-b9a4-36f0ad71d242@kernel.org>
 <53cf6157-58b1-4539-a276-2486e8796c57@lucifer.local>
 <25899F67-955D-44DC-935E-D7F234BD335A@nvidia.com>
 <cd36fe49-56b6-4ec6-8dc7-9c793f939bb5@kernel.org>
 <EF04F17A-89ED-40EB-BA91-7A82713E28F8@nvidia.com>
 <f7e1bdbf-cb88-42f0-ac48-1a273bda2455@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL1PR13CA0434.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::19) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS7PR12MB8290:EE_
X-MS-Office365-Filtering-Correlation-Id: c919ac02-f101-4049-10a0-08de902dfac3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	KB4XkasZgr4Op2zyL001IQbX5TDTjYlbPQdJ22jIvboTah/RWCbdNv00YSEBZJIlUgoZq9NOs9Gac5J+XvXwQmreAAeb3daL7HJvr4sT4rXO1cB+4Om8LBeOE+NZNqFziUsIxbSVvV52RirSlWwahlGUL+EBUCZZQawIaYot/QmrKzz30mz6y8ZSiOhZDBmnFzJbZ9K7MLvS9qYY1gvsuWK7REA5QGPSgkaPhYRGT9elW4nE3qV42mNF9Q15kU70xSudwDmcdva+OssS5d4ZQkWmHtYNcGqlKxz2ZDzU3uxPYOgDdn9UCXGqfMxhfQv0t5oZYXS+XW5/eqVYSPczRHde4rx+s1dQH48ts2bJL72Qy071DDhIBer/R10RDn73oWTMrLAYwQMbAzQEp8Do5Z9kbAvDf7RzXaEdJNoPUz24VbTen2dBHB6H8LXUCugIwHZz3HBdVDa+4TPetCFeOeORS5h4rcqmpzx1lYndo0iaVAc9mjKMCmwuXsE8eby5Hi37m8uajAb7lasEyu7SgRlA2fWknASAZQvxhc7UdjCiyoimiCQF/Mr5F8FeaP+pqQZqMNy2nc+yltPZUazZupaQzocSm6MNNMazn99X29D3K/HY9arZvt6bCz6fdQx5gStlF77/3mUIbzfF9q2Shro2diJDohhhSzYKCVwKxMhI2esMdKp5WjUWKCXWZDFV2dWpWjD0tBNnGjGzf5tP6AYP9++H9a8Eb4BHTfwMM1U=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U3I0Y0JHK21aU204OVYxNXhFTWdVQ2diaE9MSHJDbXU0d3dDYmpzVXAycjMy?=
 =?utf-8?B?VzBRK2hPNVg3c0loLzZyU1k5NzJyZExuZHB5YmpOS3RNd2s3OTMwMnZob3V4?=
 =?utf-8?B?WVkxT1N5N21oQlhHMXNValVPQUdnMGxVY2lPcUx6WDJzckRZdjlaS3BNUFNN?=
 =?utf-8?B?QTRhRzBTbmNQQWtDTlVzZzYrUUpTcEZoZ3VzNnlsaGs2RVRUczJKdlJlNDZE?=
 =?utf-8?B?cWZXenFZS0srcWovcU45Q1hzQklhbVBveDdUY0s3dWxsU2NBdTUvL3c0TXlw?=
 =?utf-8?B?TVluRTR4emdidU95YnM3WWxBOUNsMEFYUXEyN01Sa2pFWThEaU9VU2Vxb2JU?=
 =?utf-8?B?RUpiSEo3QldyL0FlRXZOeklmWTNOL0lMckM4VnFHaW1PeUtCVTFrdDRIeTM4?=
 =?utf-8?B?MnNrN29vc3UxeVlrU2JTOUt5UEl2OHA2VlM3SmwrRG5jTVdTQjl2b3BYZlNy?=
 =?utf-8?B?Tk9RTzdCM2o4VGVLMVFxVUJqemswOXRsUWtZNnlXTkhTaE1Da3dyUjFiSEdP?=
 =?utf-8?B?QVNqNFgyYjVGaUtwTTUwdUlyZjVUNUJBVHhjSllFRXU3M2lkL2ZLYVd6ekZC?=
 =?utf-8?B?SWJraU91UVJCVHZ3QTZ0WFhTS0d4M0o1MlErd3FQVTYyZlRFM1haM0VXQVRw?=
 =?utf-8?B?TlBUeFlyWW0rZGdrbDI2R1VieEF3YWNrM3hmWWVsWFV0WkxWUTVDWXZ1Rk90?=
 =?utf-8?B?Szc3bHEwNUp6RG1TbnFiRjhiZ0dvdmNGM0pnV1E4QnJPTWhwNG9qWWQ5S1g2?=
 =?utf-8?B?dkxlZHdqUG5JZzdXNmtpTEdFQnN0S1gyODFqRVo1T0JMbzlYMWU3bDZvRWNS?=
 =?utf-8?B?ODN2U1hUVFBmcnRWZ0RuZ3FUVjZrN3JLV3hCUE1WRGVOcjU0NmdQejdSb2lG?=
 =?utf-8?B?QmwxN3Zwd2tRODlLd2FSTEhJaXpLMUJDbndHNndxK1FKRGJjV1doQmN6R0E4?=
 =?utf-8?B?bmV6b2lzV25PY2ZwL1ZxZGQ4a1ZXZkg0UXIzbVlaNzRJL242ejJOQ3BtekVE?=
 =?utf-8?B?VFJBLzlPUFFiK200aXRWcnQvTWNuaTZ6Y3dPclFFSjMxTjQrc0E2OGZ0d1Er?=
 =?utf-8?B?Nk03TlgwSWNaYmQ4YmR6TGlEZ1RWbFJvaUk4M3M0YnM5VzJBVi9CM1ZkQXc0?=
 =?utf-8?B?WnBHUERZR2xsM2Ntc014MzVPaGNaZUhjU29XTkJFbEN6eDZrLytKSk15a2Fv?=
 =?utf-8?B?a0d1UlcyZWpYWmlxc3F1REJYMzQ2d2d3a3NRMWlLbjRuUUVNbDhQaGg2TytB?=
 =?utf-8?B?VVk0V0dsTkNuTVVDVTdhRWxMdHNQVWVkeDFKdHJ2OGNveEMzcnF5OVhXUmxv?=
 =?utf-8?B?aUVVcG01QzN3dXVTemlFSDlyTWQzMjc0R3BaRFhjSnlsZVlLNWxXSFFxODV2?=
 =?utf-8?B?RGpodHFpSUlHU1BUZDJ2bU5qaERqTFd4MmFuNFE1Tm83ZVBnNy9RTm04SWhZ?=
 =?utf-8?B?TnF4b3VZaHg5TTRNUFBkakpaTGdzdDd1SFdvYTVIekxaS1IzeVpUWVRxYkxi?=
 =?utf-8?B?VzZtNlZ5azRvNDZOTWlOM2JScG1kQk85NFBtMlQ2bXlqTlA1dlMyZ01JTXBq?=
 =?utf-8?B?TlhOS0F2MVVHYUMrUnZCOGtaRGV0c3F5VGdPcllnVVpqVk5nZ0dQK0xyb0Rn?=
 =?utf-8?B?RnpSdWUwempEWHR0WFplZ004TXl2L0d1b0xEc24zRm9rcG9CYXI4ZlN4c1Yz?=
 =?utf-8?B?d05GblAyZ3lhS1VFcXF2Z25zMzhuSzFmODRqYVU1U3ZQc1BjNVlRR0M4M0Ux?=
 =?utf-8?B?UTRUTXEwd2NjMm9rTlFJbGVWWTlmelUrQlA3emRmS29ybllEK243Zk1hd1RG?=
 =?utf-8?B?dHowODEyNlJVWUQ2KzhrbG9sNi82WloyZjdZTDQvbkgxcVJUdjB6elF6eUtJ?=
 =?utf-8?B?YmkwMTh1N2VBdDVRK1FJWXEvUHpmUmN2U1hmQWxnTVFRVllkTzVaTE4vTXpY?=
 =?utf-8?B?L1Y0UXdZcmRpaEY2YzFZbnB4V1FmaDlhdWZ0RWZONFc5THZTSFp4bGMvSWs1?=
 =?utf-8?B?V2l4VXkyL3BuVUsybUJnYmJIQzVuZHBodTRzWlFXeFVmSUVzVUxHRW81N1Ur?=
 =?utf-8?B?SzhOM0Z1UDd0N210ZEgwL0s0eUQwUEpCR0VxdUx3L042MU1scUxUNUxQa2JS?=
 =?utf-8?B?NnRzYVF3Ui91amhhMkZDdmN3UW5XLzY2QkdFRzJhb3RHRGFoMGFRZk5VUGN5?=
 =?utf-8?B?ZlR1OHNXSUhFTWZIMzVtUEpRUWlWMzhGN0wyZkhMWVdTVldpVU4xVys5bUwz?=
 =?utf-8?B?NE93ellmTmYxUFU0UVVzUnRHNnlzeFU2ZGVhRnNQWjJnWndHemwyUXBTUzN1?=
 =?utf-8?Q?JyiKxymdRp0R1uwB77?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c919ac02-f101-4049-10a0-08de902dfac3
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2026 20:33:48.9563
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P35KnJGdIDxg20aNad7uxirDNZuU+qIUfKdEPpglH9hhoRucKeDLYjrbb5RDAmdv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8290
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: ACBEC4000A
X-Stat-Signature: m3xur659ah7wk6y46497y9s6hd4h91yc
X-HE-Tag: 1775075635-746550
X-HE-Meta: U2FsdGVkX18Ll34wN1g4Bwvv7glquqVNB5NYdfTALk7iPyiD0ed2X4HLraa3ahI4rHVJ56XqKE1zJ+B9fSluJwLJAxWKui04uF0lwwStIkGsn9J3ysZEILOXAtOjQUQ7wiAJ4lcBcOZeGgKlK5i1vqjW0X6Fom0LMjGvVSgUQFwXYaUNvBOfbV3vjcGPSUkIpIjDS/RmBAomjoUIVQ2B9KU5r2zPUD0qKUIj0X5Sn0sEF0UALcz7jXO0mzPb8vN/IsMf2oVO9knLSJX91UFizMktawf9SZofoNPnYOUWVHwIBO4u+oUME4nswwjW31KQv2DESBpafGAlMNJIjQV9cSdhHcsyMJ9hQ//k8eVQIGQ/xIyFT5I/7eRsNUmuRH1C1Vgjt41jHSoOdg8c7MEpaLm/uV53rX9n2hE8HvzGRN0htgOmjdDnF73zPyrnyT6DcpyxiUsEVI5PmDx5R9yCB1vBgWNJYirQnGrMxm+GPEwpTiTPf/3NZsEsObgf1FojIWUIek25QJplM03RgAs8ibiV0q57ncHP3g2DH4eLtfrq7l0+7YJicE6LH64ulq3/yUxjg5xlr5pwY224JLzhWezzMCX2QfGe7AxYN9Mm6WX68J2rrtjrtAZ3xaT/kiWrV4yMNiOo6xLfcxab9FWN/9AexG2g4vvfCBQbyT5zOvxwhmJuz1eLKFx2l4uJ6rmV64QOzFDTHATBjsZky12/5WiY/9X5AfX2c0O0pmLLyqlcguMjIyE8UKn4z66QtgRHmF1DOF9jTiC1H9aGbKZbGwU3o5Zc9QC8BIX4K8O1q1O2Za9/g33Wf0YijgYTFu+WbapMDoZ5gI/c9h1x+jfKC5kEnqrOjTv1FZyWZkD1TnNbMy3T0HscNZY1xlgrsqXN1m65n8FlTXP/LipxlzjXL5KYvG11ti71zDMYuINDAvKRiyEI2z3SUA59zgAnye4WUWulGempxCBHdbR/QWl
 NWt3GwgU
 cOOFMlhCsuX7mbhCoaIiFK8S+RSThCq47dZowiW2LE1DCvYMTT68TPWoDgpreUqJSnaM7+s4fLIxns04hIDmtwIlFZd5rAaO4eSPz/60u7BPo8ug3sBd759KowC0wP+k69p9Mqxj/2/g4zWrx58GCTZHfrChm/6BHB+Bm5EqZcrs8xyZVShAPimxKztMNV/3wifPbK+pJxMsbXr9X96FO6kiw9oAxLP3KV0bdE6ZPunYIT2//ScLFFIPgTN5ddbRHrLbHM28ryuebd0Pkb9ZS17m74Y0VVm42Z2TUDd7shm+PQqnal5LHKBXkUs42uenpFvyIdjJvATd6mwpegyDbxT0CMDy5ayXY0wAwGlzMSqB92BCVa2kjYpStYFMAvAWDdDVVoxxJpC+iDncrOLoOXni6b3fVU1piJYipKhjAqBwoILD9yEalDZNc+QJX8+tgPmSO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1 Apr 2026, at 15:15, David Hildenbrand (Arm) wrote:

> On 4/1/26 17:32, Zi Yan wrote:
>> On 1 Apr 2026, at 10:35, David Hildenbrand (Arm) wrote:
>>
>>> On 3/27/26 16:05, Zi Yan wrote:
>>>>
>>>>
>>>> But I added
>>>>
>>>> +	if (!is_shmem && inode_is_open_for_write(mapping->host))
>>>> +		result = SCAN_FAIL;
>>>>
>>>> That keeps the original bail out, right?
>>>
>>> Independent of that, are we sure that the possible race we allow is ok?
>>
>> Let me think.
>>
>> do_dentry_open() -> file_get_write_access() -> get_write_access() bumps
>> inode->i_writecount atomically and it turns inode_is_open_for_write()
>> to true. Then, do_dentry_open() also truncates all pages
>> if filemap_nr_thps() is not zero. This pairs with khugepaged’s first
>> filemap_nr_thps_inc() then inode_is_open_for_write() to prevent opening
>> a fd with write when there is a read-only THP.
>>
>> After removing READ_ONLY_THP_FOR_FS, khugepaged only creates read-only THPs
>> on FSes with large folio support (to be precise THP support). If a fd
>> is opened for write before inode_is_open_for_write() check, khugepaged
>> will stop. It is fine. But if a fd is opened for write after
>> inode_is_open_for_write() check, khugepaged will try to collapse a read-only
>> THP and the fd can be written at the same time.
>
> Exactly, that's the race I mean.
>
>>
>> I notice that fd write requires locking the to-be-written folio first
>> (I see it from f_ops->write_iter() -> write_begin_get_folio() and assume
>> f_ops->write() has the same locking requirement) and khugepaged has already
>> locked the to-be-collapsed folio before inode_is_open_for_write(). So if the
>> fd is opened for write after inode_is_open_for_write() check, its write
>> will wait for khugepaged collapse and see a new THP. Since the FS
>> supports THP, writing to the new THP should be fine.
>>
>> Let me know if my analysis above makes sense. If yes, I will add it
>> to the commit message and add a succinct comment about it before
>> inode_is_open_for_write().
>
> khugepaged code is the only code that replaces folios in the pagecache
> by other folios. So my main concern is if that is problematic on
> concurrent write access.

folio_split() does it too, although it replaces a large folio with
a bunch of after-split folios. It is a kinda reverse process of
collapse_file().


>
> You argue that the folio lock is sufficient. That's certainly true for
> individual folios, but I am more concerned about the replacement part.

For the replacement part, both old and new folios are locked during
the process. A parallel writer uses filemap_get_entry() to get the folio
from mapping, but all of them check folio->mapping after acquiring the
folio lock, except mincore_page() which is a reader. A writer can see
either old folio or new folio during the process, but

1. if it sees the old one, it waits on the old folio lock. After
it acquires the lock, it sees old_folio->mapping is NULL, no longer
matches the original mapping. The writer will try again.

2. if it sees the new one, it waits on the new folio lock. After
it acquires the lock, it sees new_folio->mapping matches the
original mapping and proceeds to its writes.

3. if khugepaged needs to do a rollback, the old folio will stay
the same and the writer will see the old one after it gets the old
folio lock.

>
> I don't have anything concrete, primarily just pointing out that this is
> a change that might unlock some code paths that could not have been
> triggered before.

Yes, the concern makes sense.

BTW, Claude is trying to convince me that even inode_is_open_for_write()
is unecessary since 1) folio_test_dirty() before it has
made sure the folio is clean, 2) try_to_unmap() and the locked folio prevents
further writes.

But then we find a hole between folio_test_dirty() and
try_to_unmap() where a write via a writable mmap PTE can dirty the folio
after folio_test_dirty() and try_to_unmap(). To remove that hole,
the “if (!is_shmem && (folio_test_dirty(...) || folio_test_writeback(...))”
needs to be moved after try_to_unmap(). With that, all to-be-collapsed
folios will be clean, unmapped, and locked, where unmapped means
writes via mmap need to fault and take the folio lock, locked means
writes via mmap and write() need to wait until the folio is unlocked.

Let me know if my reasoning makes sense. It is definitely worth the time
and effort to ensure this patchset does not introduce any unexpected race
condition or issue.

Best Regards,
Yan, Zi

