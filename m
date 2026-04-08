Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5B4210F9963
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 18:06:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 078006B0088; Wed,  8 Apr 2026 14:06:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 029246B0089; Wed,  8 Apr 2026 14:06:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E59D86B008A; Wed,  8 Apr 2026 14:06:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D451F6B0088
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 14:06:09 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 14C83B71FE
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 18:06:09 +0000 (UTC)
X-FDA: 84636167658.24.61A85E5
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011032.outbound.protection.outlook.com [52.101.57.32])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7D2A6140005
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 18:06:06 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=GJ8Gks5V;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf23.hostedemail.com: domain of ziy@nvidia.com designates 52.101.57.32 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775671566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MT6pX6Rbd6Wo3Xa6D7Bj5mjJ0/5kR7D7I+oZbEPbrEQ=;
	b=Mo3ZLP1QiiIzLO+Kkzf/05lVhoYCPEzFmVYThdFEpMd2k9KP7SvNC1LZT5TVCilqFrkiK1
	V3BWbJ/VtQjiJEDVIqkZdH/WUydL4PVR90e8MfO0CULjM5prw4j85DDXsAti9AIuYnKxYx
	VzzjHmCS9CWKf7CcK9/+CDlHh1UKIYI=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775671566; a=rsa-sha256;
	cv=pass;
	b=AjZvGAZb5DXP3wgkxGBy1qUUyUNfUrWHkwdP5nCcmv9VHZTTYKI/wkBqi1SUpFvVnjpNt+
	6uTN9oKhZkF2T+Hg+w4B4KE1tPBy4nIogIBBUcTVau/a61qQ1h5GjVqYt16qe0N6oIQDp5
	3W3Ozb2Dnbmt6U3633bpTwnphn1PU7c=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=GJ8Gks5V;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf23.hostedemail.com: domain of ziy@nvidia.com designates 52.101.57.32 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FCQmo1H+turJNUL8qfMAlbr3cZLXF1pyYtbWYPhsrMrlqBO/j/ZeLjyMoJ3yx3TkTQ3weTsAlHJ2KfeVnfRCXdkP3HL0p52dCVyUM+zQ+HqlXbOU7kh2MXOwl7M8lj6TLsnUT0DEvYyrTZDETd+dAiMNsir2xpjqRhsXAoNg8RFCV1NNVRjJ2x9PlHNTx806MGbP5cogIV7nPhUz7ggSE2s/xScIcVebeb9cMKfuL+BTTNXra/burvNxCMGWX7kB3fJDQzOHQnmEelG3dZcLcboqAW0OX5Xu65uYPZgqveC32M+6qRt0hkAaslq9hK6vr98LxsSiuSbRI1oD233KGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MT6pX6Rbd6Wo3Xa6D7Bj5mjJ0/5kR7D7I+oZbEPbrEQ=;
 b=XUCU8FXOs/m40WYr35v587WEorzqdAFR+c7gfo91IBS3Kqrm6Pq8preq9BGuiOOCS/qUZ45WSor5QmzJHYxL0ELu9K/Sqj8JwV4XplPDmELkn6ed+57n54uuov1t2U4lmpw4xWd9ZUxE5L3yqm5qXIKh+/0ePIdUpM+9RoI7w5XDLRFnqI1/uLzCbgSPt3K2+1rxtk/XOjRDZP6oisf+JTgM9WZFtIDu4ydCrSwhMBmbOKSkxcKjR5BLGX6kONTP8IrEBHbyWig0t9rrKoSOTR46aMaznEXAi1qMJrHP8xJHxBBx3S9dvlaPTyOWLgUM5kgq96DuwPRixtzL4ZvlxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MT6pX6Rbd6Wo3Xa6D7Bj5mjJ0/5kR7D7I+oZbEPbrEQ=;
 b=GJ8Gks5VjtMyU2nvi4kpNJydeaGem2Ei4DkQfzCMQhzyX2obE13CKFPnSf8knRWBjO08aIpndH4nHqQaxhXz9ZyXkF/9JdxTVk4IcWZAJzt2rKfq0ZacWi1WdEXRA+L/5P70SULnxpIxaqdc+vPUSq/xVPZKDi+7VZFXBj+0HEp/06yW0T/JPlHKdXWxU3SYD2YjmajBUn6tSogSgP0qP5KYXMNWqVNKYy2jLh1I44tBxu44lJu69XuU9iFh8uZ5XBTn5O2lwkKOsDRyQpsv4Wf6n4NGfxrJ/OQkANwQi17I3jr4QZETrto/9E40nu9oJ8kf+uvEyFRdri9irWRsow==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 BY5PR12MB4194.namprd12.prod.outlook.com (2603:10b6:a03:210::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9769.20; Wed, 8 Apr 2026 18:06:01 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9769.014; Wed, 8 Apr 2026
 18:06:00 +0000
From: Zi Yan <ziy@nvidia.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jackie Liu <liu.yun@linux.dev>,
 David Hildenbrand <david@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm/mempolicy: Fix weighted interleave auto sysfs name
Date: Wed, 08 Apr 2026 14:05:57 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <4A90BBC5-01C0-459E-82AC-ABB0520AC2CC@nvidia.com>
In-Reply-To: <20260407141415.3080960-1-joshua.hahnjy@gmail.com>
References: <20260407141415.3080960-1-joshua.hahnjy@gmail.com>
Content-Type: text/plain
X-ClientProxiedBy: SA1P222CA0032.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:2d0::13) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|BY5PR12MB4194:EE_
X-MS-Office365-Filtering-Correlation-Id: fe197f52-4922-4597-f472-08de95997d9c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	x1M2Q+4WKTEOC06yYCRpO3xOjcGgwMjjul+BHsnzkP++L6mB7ujs5tdihNEmWe83mWDtThVIU/31HsQXrpFw645xx6a2Dtrhop+/8T2lcB5fJRLFzbVGK6sJavvrQOUy3noBfdh8kYqjFMkpV+IiQzWwffvex/MPqO4KE1ux0Pdp24y3AFQPtNDFzb9IBCmefAjlJ+8YjO0ysTsJlDgI5aNZU1h2tKw9RMEYUnkbj6EDPPx6sKsM1y6Zwdi+aBVoT8fs+RUQ4wzBJQuJTqXZ7AYOKuQSaa3I9xvKLMTW3MisLGivN3xcV2mG03M8gmVrftfsGBOwdXF33GpBWLAfB875vLRuSJ5VcPLWTfnBvIc9Yn3KRvYkpI5wUtMP3L8Zos/gRAdA2lcfqUEYyPa5DDGM4Wgm3vgWShKV/koHdPIjjTiCXkDK6sJV/YAFI3n8/lcSBNw09nm6KwPYLveHC/iVlzl8WBM+m9ilJ8l0O2lui5wiDrvLbwZXs4TNwTtacSlK6ylrHygn+G3/zt8T3r5kLObNpYWoJDIRN6k33caW/tjZ7QPLjI0nLfrcGPiTP9Dj+JLBz6+1W/anVvj0/fzeJurgEwNyyZX8OqdcGXO+WwBOAi62HLKr+X19l0PThEiFAqIpbBuxjQfon6dfIAS57ISw5QWbxUfyKZwRguXzeTvZa6eAnnYE28mOs5k6rffqRdAsZ+YoZ7de4wiYactHBDiRBK11xZUbLVwukZg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?peufNmRnZK7KVN90/QS/Z9/UQCIR09wNqGiy98M9AOJY7dsu87aL4NhknMu9?=
 =?us-ascii?Q?ljpKO2xg2WKqnKekpFyEztYzIZiEktMM3xj3q5eGHuTv0coA0JvjTcWUqmMJ?=
 =?us-ascii?Q?2d52BAJFNCtu/C9rdCaveEQtB0eNGmXjEajj1mrp5UaUXz695ulg+5TYwAbE?=
 =?us-ascii?Q?Akl0kzwvIJHKWCrmNTGTv3YQSjcVlDkFNYqAK+5s0mQb/fdYEvBKood2EAYe?=
 =?us-ascii?Q?M9/fzla21Bn/laedWru1CdedV3BV4FDQrGJDdPv7wUVGezuiMZlKDG0+zuKy?=
 =?us-ascii?Q?ajBRHVUmG/8Q0zKXio+Jhc0MCZYpwA6geMDR+glS5zGB9yrcVJ035n8PBhuJ?=
 =?us-ascii?Q?s3R1suzX1C/cZBCPHILQ5Nl5hf5aq3eADKISe2NPe1ly3RX5sG3yXruTgpLQ?=
 =?us-ascii?Q?c/OOoIqJlMZXMGbyRBAwg42FkNGOH1TeOapaW9Wwaksfmmj0qiILbZHRw+CB?=
 =?us-ascii?Q?J/6mKCNOpdFLabbPJdvZjbWouq1Zqxq5nHXp+SPKIZyMAAkwOHW0MlG2A0B9?=
 =?us-ascii?Q?VOKaNNq8izgI3OiY90v0on6v+8/ugbhcSXLFjW20AfO4b2BbskWqRI2VQ8Mz?=
 =?us-ascii?Q?BM4NcIVCIalFu4zdiEEFNj3tItT6DC4ydOY/M+bxBUFcTVhjPmA8JJhjHhwa?=
 =?us-ascii?Q?qPCNCRcUB00So3pkz7KHGa/3+MNKvluuMC3eBj9XuPiO/quDJiEvgzPVWJGb?=
 =?us-ascii?Q?t2SMx80VkYZBdF+d+Oh95GQOyI8nNxTZFymZQL+RAnz4RDO96wCjs58VkRPk?=
 =?us-ascii?Q?tVzzh3XLUmlGOudpCEVubb+VGsmdBdJW5xaghHo6epWCbeFYh6ulJ/Uvn9eM?=
 =?us-ascii?Q?fneg4VGpXJfHuVG+mMt1EDYtWSCcojMwoMmwe+eZMntdX9Ca9KoAs290rCjH?=
 =?us-ascii?Q?v49A+v+N1mP2lFZ4FN8GzIMdJnj2eFBv+rlcrI/MU90I2l8rZe7DUXT9o2+s?=
 =?us-ascii?Q?0VddEUlVnGJZ5vHItQhIdNUw5jHgn9jcgEZEncLIbMGIkHWOjmnssXc2bAP7?=
 =?us-ascii?Q?EBOoA+37WcH1rLv5rfVbg/7b0S2wgN+X5vlUgwScY6eUkjcASDJIuQUYcDdB?=
 =?us-ascii?Q?15lTgOe+LVREsApSYfF1AnUk3/fPIf5xBfRMSj9P6zpg2dxvUQONrq+9enAC?=
 =?us-ascii?Q?Ed0r8TUTWc7VN0mMm+P/3j6alVvfPz6JqnHOFCHBb3d2blhLh3ueCxdRzALO?=
 =?us-ascii?Q?Eme3kD/AWEm0QugsJbN1rL7Hv3TXpNlszjJUXdHujcT1jChVdjYP/YuVCZof?=
 =?us-ascii?Q?19KnIW4A2TydEOmmbBsfLrnDc7DJkoymdqTU2RV3m9TVT0R1FbrP59aT2Qg5?=
 =?us-ascii?Q?4AvpfH6pt/3Xq0rrjECD6CsVVOOl73o4c42qtSx2hkHvX6x1jtNyhhFsAk1U?=
 =?us-ascii?Q?0/lS6gk1IGLukSCeSzeSNAvv9yQPg9LneQMOO0Yvm4uFZ7MItt8XUQtArNBU?=
 =?us-ascii?Q?BhY416aTcVal437KlGHsF3CvrsbaWf8Oj9GglWnKc9NM/mstg9yaS2oHeAWK?=
 =?us-ascii?Q?M7ao3wObB0+hKAuaXfEnGqpZyJT3Ao+h+BwrdW0nKu0nk6b2rfWeX1M2sbyf?=
 =?us-ascii?Q?+u3nWSM1hbpykVap3DYWmrxPDMi5Eayg862X1UBiT8j839U9i+gRFnDta3f5?=
 =?us-ascii?Q?Lww8IEsbFonEYt2oAWb2dXBRpvNZKYYIzMTSMO9WrUoEp4GTNiTvHCQ2ESh7?=
 =?us-ascii?Q?v4CQ/jPdE82SdjHJfTPO5t8YfncRA1C4DtiNM8iPjxNfj3Pu?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe197f52-4922-4597-f472-08de95997d9c
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2026 18:06:00.4588
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lOZ06Gq3R154QohYIlg5xp8orLgiPgx3YUhCJKdvw2UKIg7tn9axo0GX3QsYPUwL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4194
X-Rspamd-Queue-Id: 7D2A6140005
X-Stat-Signature: bindrr9emxw8ubkmdro1ie5kj3b11h3n
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775671566-91376
X-HE-Meta: U2FsdGVkX1+EZZ4Z2pVg3TDtrxXpTtiKCjaopBcVJ1/Ttnx1HHhaMCsiE1x6vWOZ477WFwPNJkkPRJ9Hivk/TuaHaM87fuc/4xVFSyPYmLAC+S0uL6OqbLvEigd1z2kjCv1BUTqH7YnUTY2AsooI/WI+aDIjTvxKhVGyTMEuU00VneLYlgInS/sDLCjEL0OgedCWy6yqWPDVbDvk9uC5k/uyu4IpuwIBwC27RfIZ4ef5akZNU0oAqTt6YPA5gwBwCXUobvhNAGXYq/izxO2WGF1NtNlT+rChFRYzgZr3Xd4iCbBgh+XqXMafGlkMjF/a7SWF7GmNnfL3lERng8uwjUhC06IZhIYv/bC+5PPzxgu6uYt6zF4LJ9rxt+E2nqPo8MdLrYLRLafMthTg9XahXEqTWR1PIumaxDWwD1U2irYaGRyF/omTOrFntHicHLpQL+H06zFVqIb705RYOxM8xKhL0rYD3Jyfe/IryDGT8Q5t/9u3aaImFoCYPBC+VUGG4aOh/rOXAu9xRpHo6Se/Yj46/CVDXJEwfVe9HgrMSnxWlnxAHqBEihJAXwilRjPrD2BiWOgPYYUFrcKb5EWyYcEtN/Ny7gFD3O94uCUggvR5UQSyk6UCAwzfFhiHO87kGojUDduMLEITj0zdwL/byMmx/UhyQLIPzUI10cF3Ad6zH3zMeVFNP/W2rSV05TS6aHIGFqTyu0WiN/tShwajsxrkA75QND1c53mc4yDb3f99bFU5P0cQ5ls5AKqeLwIBTbtk/KlJINFrcJVTBfNvWhagx9uEycRoMuOUVLuL4nJNZVQcAAP73A+6dW+Y7dT7O+/RCmIrn99gpy1aJQpIgItyBh9W/xyKgiHvEYhvDle6z76xwnNvYza3vs3sZf11f/Z6YgRBe3zCvPciOFmCk8Cjypkkf0mv3YVgdlptl8MvCRzQETkDGcuTukxs9efy7olJgDoQB806p9jaro7
 0LvZ7Uvm
 bXwjB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7 Apr 2026, at 10:14, Joshua Hahn wrote:

> The __ATTR macro is a utility that makes defining kobj_attributes easier
> by stringfying the name, verifying the mode, and setting the show/store
> fields in a single initializer. It takes a raw token as the first value,
> rather than a string, so that __ATTR family macros like __ATTR_RW can
> token-paste it for inferring the _show / _store function names.
>
> Commit e341f9c3c841 ("mm/mempolicy: Weighted Interleave Auto-tuning")
> used the __ATTR macro to define the "auto" sysfs for weighted
> interleave. A few months later, commit 2fb6915fa22d ("compiler_types.h:
> add "auto" as a macro for "__auto_type"") introduced a #define macro
> which expanded auto into __auto_type.
>
> This led to the "auto" token passed into __ATTR to be expanded out into
> __auto_type, and the sysfs entry to be displayed as __auto_type as well.
>
> Expand out the __ATTR macro and directly pass a string "auto" instead of
> the raw token 'auto' to prevent it from being expanded out. Also bypass
> the VERIFY_OCTAL_PERMISSIONS check by triple checking that 0664 is
> indeed the intended permissions for this sysfs file.
>
> Before:
> $ ls /sys/kernel/mm/mempolicy/weighted_interleave
> __auto_type  node0
>
> After:
> $ ls /sys/kernel/mm/mempolicy/weighted_interleave/
> auto  node0
>
> Based on latest mm-new: 96881c429af1
>
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> ---
>  mm/mempolicy.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>

Acked-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

