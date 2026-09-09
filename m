Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7C7CC79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 14:48:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 878F26B0093; Wed,  9 Sep 2026 10:48:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 829CC6B009D; Wed,  9 Sep 2026 10:48:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F18B6B009E; Wed,  9 Sep 2026 10:48:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 436176B0093
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:48:36 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1FC00140231
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:48:35 +0000 (UTC)
X-FDA: 85194504990.20.2DCCD17
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012029.outbound.protection.outlook.com [40.107.209.29])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3153C140007
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:48:32 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=uGE6BNwQ;
	spf=pass (imf23.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.29 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788965312;
	b=OnmyBSKUF8HbVQ1EKwYosCfrkcqUe00CtL4PI7MLtSZRu5wfSkBf38BcZeu2/nvrlY1w5/
	EMipGOTnLzS0YmIu1pRH1+Wu47JJu0WUbexqiASPBmrgwgWy+r21AMXalZJY3iWy7w2KBu
	08ujCxKcQJEbByWkAmEb9+z45b04YjA=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=uGE6BNwQ;
	spf=pass (imf23.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.29 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788965312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3PaKJDXf1CdCLll5w/H0cIiqsEtxn1GDr+VgVQGTUTk=;
	b=0GOsFwC9nRss3yOJsLaoV01vV6OeZt8n9xpsgNKc1VCKZNncsr4+zvkcbl1+gHNXhCUh2t
	0MPYLAuxOpKU93Cky97m5tsxGEpR+8VN+jDwB46cbADYQILxAolrGdzKih6uQqG1eByqad
	EKxD2g14JOyVU07R+rPPUPg8lf+gFoM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DNEu/CEF5RzvyJSrrW9OQUs+hEO/GO8tw6iShtYLkmLTsDK/NHSuxv7flyV+8e5jDAzemqd6Vj0d3SPa+IwZ7H+UXLXYBJSYUgolZImLBBIzAio9o8Mm4G912vslhjdjj2ia2RWLCrfmnDPZB/XIH+4LrclsDj5+2GTkUR+3c/W69CFiJmWVoIYqtcVa5xHv5FO+IZZIeyOVoCBECD3LhOVaiQ6xxikVWNA3DwkX2uquj6PS66RhHc+2dkJ8Z2Vr6xXgMKSytip8F2lsnNTKLufIFGqDjv3ZD1Mwigge+iB0n/ch7WLd8TuF0I383haeoMgL51h7BQU2OXGeBPSJ/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3PaKJDXf1CdCLll5w/H0cIiqsEtxn1GDr+VgVQGTUTk=;
 b=BX2+ISy/alIe2RIYl1SEl0KI8vead9ecFBIMvN7pCMzc4EAeyjdMpGZNEQaMrex9inoZhG+FZWVJHubiUm/WKsrLmJxnlQYZJjyODXsXSU1DOgJT+zQ3lWnCREqlJFHBPLmaZ9VY44yKNUno53TqbvU7sS3ZyoFahVRvtPznQuGYn/reWZoX9l81FQra+ffZCSyLL+asM/Vgnof6rLE6IoQqrwsG6Y/tRD7ka2UTlWTEyUaemzkhBSg3NQAeMpNurxmbvnZwN3jZQjX9IRcLmuPAHxt8q5RH/+KySc7606vDn36gzRezERJs79V4VikhRMG6nQygZpZOSLW93sGJfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3PaKJDXf1CdCLll5w/H0cIiqsEtxn1GDr+VgVQGTUTk=;
 b=uGE6BNwQhF1bEB/3dw25ddxdOn/rP7QGhFVykYprWIjyisPw5+uPRBG3lt8/+E4RRvwrtKLluclaird6eUG+uvF9nM2Ev7xc3LancJw5KZdhA+eohBhLU+9F19vbVLTYzrLp/cO7P9isHyDwEb7/gQAssJAhGJsxHVYwU/tKjzc7ZrXKdcTU1hw8ySSbdTPRwvjEYQV7LQ7YlcA3R2QKwwRWa91hCWiMrTg5WYedV5CzwYguUEk0LJR17vILXPgrvz1k8g9FNZFgljs5aoHIrwfZe0tzSPwiS2a1CEy6G18mo0cxRgI2/cHoedSaq52vOuph62dmOayriKBy1qF7yQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CY5PR12MB6406.namprd12.prod.outlook.com (2603:10b6:930:3d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.8; Wed, 9 Sep 2026
 14:48:19 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0406.007; Wed, 9 Sep 2026
 14:48:19 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Kairui Song <kasong@tencent.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Baoquan He <baoquan.he@linux.dev>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Jan Kara <jack@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>, Dave Young <ruirui.yang@linux.dev>,
 Shuah Khan <skhan@linuxfoundation.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 kexec@lists.infradead.org, linux-doc@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH v3 14/14] mm/page-flags: remove PG_private
Date: Wed, 09 Sep 2026 10:48:17 -0400
X-Mailer: MailMate (3.0r7028)
Message-ID: <1BF58667-A9AE-48AA-BA04-F02FB6D5ECF4@nvidia.com>
In-Reply-To: <d8e9b629-4198-4281-a3b2-d54445201fd2@kernel.org>
References: <20260907-remove-pg_private-v3-0-6ae22f9d9272@nvidia.com>
 <20260907-remove-pg_private-v3-14-6ae22f9d9272@nvidia.com>
 <d8e9b629-4198-4281-a3b2-d54445201fd2@kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-MS-Reactions: disallow
X-ClientProxiedBy: BL1PR13CA0268.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::33) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CY5PR12MB6406:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e36a449-7863-40ee-247c-08df0e816332
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|366016|7416014|376014|6133799003|10067099003|11063799006|4143699003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	gHZkhrlo2Dlduo0qqPNmk/ck3tigfa+qdshlTz7N2T84ki59fqAvUfQ9nIOYdID6QeikvgIzFjXmU7qNjxPh1uE8A1/j6cWDuTE67SnYLd4SyJQ8HACc/ON+AOe40O1WVQuWIU5bxzfmWmfMNgr03SCoyFYPiO6VQJsZ+t6tO9JDfg3/RQb6byplfL3wL1W+OfuHdo9oVw+t8HpQmWTbuyy0rKhMWq4Bi6VqzQf76hiToqjM2FqKZTN7blcqEvyOdjl5fi7oq4mhOsX+Qz+W4cqNCg3CSZLJKNted3Xxfpm4+ODfq1FG8LE+AJ066D+Gj7j9bPUC2imPqyCf8wkfBoZkTKe8NLkhz/ywZMZZKaprdlO8skU5shOcPUusWUcR7MaZ+5Qlu2WeWF9im/s3fzw+EC5/JPoO9oInmuVVQZvJ/nuPEDkL8Spcbkymc1CEz/lup/uCUe0lBoDNJlDjmij4fDppvxgUEvgT9J4s67YtoKQMk8HZbpovl0Iduiie+VwbY8na3+SAcPl5NLf+UN/pjs8Scnl6HRmjQYZOGVLSCl6PQ1MynXBcHg2WaygYXm27TvFraTPH9L74uFRFTE+gChxwhEYbJ7aFwK5QALVPY9SoJuLAGNS0FPxitBKckPipfMwyrlXbaHeziK9q3ZfQH03pOEMdjgGNpiqz0Zg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(7416014)(376014)(6133799003)(10067099003)(11063799006)(4143699003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?an0bGcgXOM433sgRgHC/KNPbThso0gxMPGb6WtE/97slExf2aXADK8QAKBk3?=
 =?us-ascii?Q?zzACDFClnNoPQzoshnfJzHzkFazmE0gIzNl5cEF1JaQSp2WLm45io8nFwRRf?=
 =?us-ascii?Q?5o/xdJBN6pSVBMJbjkAm14W/j5XUHzDhhezdA9LgZmXtZ6E0tPWaedoGm3V0?=
 =?us-ascii?Q?h8sMm2a8788suGTcuSL5VaPjQOuQyEIhqTOv28EjMpd7bUZQQeSEv8wmxnM+?=
 =?us-ascii?Q?QbvKREp3sX8ONRD+3Qd7GAvUw66UflWJ3t+yIoviaAaDrWkDkEumoKVhH8PJ?=
 =?us-ascii?Q?4cOPWqtrZ5In/IXBhTWyBqyIiY9dWXmIJk8h3ZtjcoQLoX/fu/ckQ6X1r6as?=
 =?us-ascii?Q?P1XPq0t4Uo4vuAvbNQNKPGU8zLQFRGM8nrHmijNYjjtpuOTVvWfBI7JtKcC5?=
 =?us-ascii?Q?Eu8tDle9xsoWIS4RqXgSWhmUcaTBfnMczYfSQwM/wQ/+WIeFlsWpDSwNEdnN?=
 =?us-ascii?Q?COSF1R1kzSa9gMiHyXAz2vz+L5tY7xK02F/OUDFRTH2pvZpcrpt23sn0cyQ7?=
 =?us-ascii?Q?wjdozUTfyJNrbsawXMviXeoH+mwsWC+t1fT5f1HX8gqJkxgNXlf0zhDQ2CFX?=
 =?us-ascii?Q?e/ePOQNUG+ZzujrxWg1szfJTS9rGQg53tI1PEcKJYZ21yEIOzPewHUVChdka?=
 =?us-ascii?Q?69mXPZj5qEHS1/uJv5wdOMn0wpmRfZn//sm3QUPSzq55/9RafkwScVRr542U?=
 =?us-ascii?Q?wv1XqTo4YvUrxhA8M9CoQuCgYg14sUDNCCNrAHlm/IRnnFCzckteXfHIhF/5?=
 =?us-ascii?Q?dxEOnUeorsl+Sd17G9Faw3GgYJXZ0eW4BWHFCqQnLm4KPXIAzmz3w1p+oPja?=
 =?us-ascii?Q?yzXwyICIl2zgPCXwcAa91J9Q+rD+8d/IMPav01PiRASHdYBpfCT9GoZ2+vXV?=
 =?us-ascii?Q?j+a+y3y/6t0UATzx35BBln8xcB1LLDcHr2pbZ8r108o+UNEVCCrCWz18q+Dp?=
 =?us-ascii?Q?h0YXcm0KpZsnoGANeyJ6f1xe9h39VPp02m19/vt08snIZGAGx2t0OEpjctKj?=
 =?us-ascii?Q?tn2DhzaPsN/GM2UFwWjC4JzBonvlq8fyTCCnydw0MZB2Nsk/veFDp2jY39/o?=
 =?us-ascii?Q?aB8V6fuEWAKcnHF9j1a/+28e/XKAsR4J9+cAH7S0DGDMrOJ8ZgJVC9g+t3Ll?=
 =?us-ascii?Q?i2lnqGxaOkcF3QpAkBXt1xtu7Po3HZq9PvDu6bais+d56mHTaav7YRyKlkET?=
 =?us-ascii?Q?0IJ/wgGWBTvSQ9Bl/KWPz9unnTwq7exmyslmMwUCQH6wye+WHhT/3avCFFsu?=
 =?us-ascii?Q?ANmatDHksyPhO41qUDSZpmS8V317ZYsDu2R+Os42tnInM940kZsUsHOnf9we?=
 =?us-ascii?Q?RHMaeL4ye3BCzYf/XcqidSXOuNAGFNMVFt/2nqjC/teO3teDqtaGAj7uF4lu?=
 =?us-ascii?Q?rosdEnVrbkqmsBLT5jVNGV+CRoqrSvpusUuM8v1Whp1l+sF+hXg1EvpAKzOs?=
 =?us-ascii?Q?yTL7lSTrCFnb+l17zLcDQxUiQfPHDiQX76QcjmLKPkm5OepM+J5AMIHo+ny6?=
 =?us-ascii?Q?aZBf9WyKticT5KRJ6mAJnz6X54SLTZnR5632dHr7QHOD/7KZ6vddz5Nsu19f?=
 =?us-ascii?Q?yrzEOsb+QgMzuR3P9yrquuzrj4v4Apx2AhnwU8UXRLNAfPon1S4wjGz+nPvu?=
 =?us-ascii?Q?MNOUekqvjU0huUtfx13VU1HxZd6Yqn2e2drPkbmOwusRleAFpwR5yOvIPNbh?=
 =?us-ascii?Q?ZwtBmG+4rx9DEOgodiaO66NbMJ1yj2ZtpQlByQTBYEupTjTe?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e36a449-7863-40ee-247c-08df0e816332
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2026 14:48:18.9376
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pxgnQgbxOAG0LjhgRcQQOrnaJ02IgYw92HStHGX0usgVEjMN4HnukJVwoZCCi2bz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6406
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3153C140007
X-Rspam-User: 
X-Stat-Signature: xxhwkh7iuy1utb34fr11rore1rp48wje
X-HE-Tag: 1788965312-448818
X-HE-Meta: U2FsdGVkX1/h1/nWlKoEMBLfjWF4DsAD8s7yZu+vNNrgXZCjzZ4AOlPkj4qtpPnzt/u1Ii+4IaEQ/4+LItcs4SkN/EsSwS/eMPQqxqD5OlVb3bZncbnEeU6AqmhYp+kfbEONhk0oShBfd4ftqQ5c47aIOFJhooorl08/fiabnYQen4fKZn4f/nycYmYlw6EpafMq5AKG+v3EW53dwI4+G0MrkYwqCXgCslCUIUplUHWR5WAPMWZxVIy4w9dcj4vw8LyHfQmmyaUiXgZxn6UX12OEwrfRfqRmfxooJsR6A84+hL+a94EnIklshXhxpaoxK+z4eZZG3worTk6BAsr2YBU0cBj8My1lOUszzvdG/xC9iDE850SFup8T+ir3x/od5HlCeBHZINavgiOxDowhvPxjHcmF8ZJzsWWdKSz9Z6duMyoWo8QM3mLy4TMFI4Yq9Nnd2KculxyJ0PHB02CotHp1u7CeYpdDWPZDEHawzRddE3QyMUi6+9Uk+kQveahE06OZiaxslkS7/ICa0vHg+0q+rEjl/UVF28+mMuazg7m3cA/cOyZ5MNBbm5nqczTO9Y7SgxzsDj5aiCTzSG/631oAFN1GoFdAiGGSACoG61JG6W2e9k7Sje0cPmv27FpcEi6oDVLytnhOk9HQmzqQjuQpoqPU/akiC3oIaVoMrLciIyftgX1QnE4uyOFZcEUXYjKFU1kG2mAMB544JYpWl98Gy/WxkxEYvIEZ1pjQALPetox0J71DjnixuTIKJ+xLEKwFLqk6/urvxowkgtPzCSD0NeGDNUbp303C6mJ3x4mVzdotwtizLROxRAqjA4eP7jJdEDkXPa9XMMVB4n/o7plTzt6qI7jdGoKVWcPLMrxVmGjozT2yIueT3NK2frT4bxgNYwJG1Om3vaCsggdTbvfS5p2FJM2FARKoe1J0G+Xh+ubxQ4LS6Q1TUXTT19wS8m0aGGLAnWWLy6uGgpi
 e0VSKVsg
 CqOCbOFsBR/5Go6K1KLQfhffhSYuwIeCB1hZyTB3uaYS+r36M6FBf4zl0ynDfRLXHG6HW2vTcHlzocxz6uiWQKXo9iMEmvGO8TlcvXhtAiN21U93vChsxMbWlj4eh6Gv0wgPH+mZbwBcFdaoePwqITPGsTvFfpr0gaaDHAjfcoCEmOqsR+s+KnWn4jW38MLX0jkHRDVrKPUsLe96KPsptEcOStJvjF/fp3lh1TlID87KBuZAI35xx2q3PyggdGtJJT+iJ0DQEP2Rfikvl/Q9xOB1SpC0kl/Aq4ogPAB5VTPBjEpojSvZQ4BXeYdXPe5iu1eq2rdDTZ3MRWCBYYEmB1MoOukQ78LoI1n3Pl/FqJ5Hw+OrYZMJmCqncezdFciss7QOmG6jwAnlI/mbGRXd3Hkd7hVUZ5j6YllptG+x7ZUkDOHq8sqB3WbHAzS/m3ODlNJBPi0XhA8fRiLyXOt5LwyOo2d+NNkly5IdXXpeSdsXS2crnyzdnYjPI/sjDN6LczrwGCyrCqQrIIz04GY5amubwaCSZbiPfr1paOGFwcNB/7jLszZXogsqe2PDyRYwjH+A+dy087EOzJPlzKgW2Ekc851BpRMmc3x7dCtqTFDrjhUF6ks/B69XF5woqPKYu9mBtzr0qALD15vjq3Ql6qvkW7A9jnXxvAimZqHKcZ4tTcCF2i3Z4JFQsaTuPeDGqpZ+N8Dhri1g9XGPEsBCC9FOXhnDyRdVrouM9VColfnCt+D8PVk2R/QKBj/k8aKTgMff2WNkVOgK1w+b9Gt1OYRfhhHufgGvxZgHtnUMzJVN4D7WOm3lCYy9YkUS4cQtX5t986phKsUgYEZE3IXomBI5BqGKGq/6KzjwaWSHZu625Rd2728OzGHvklkDaOZ7tKQFPNSL0APBHUxe0ty4o7XgaSMbFs15Aw92IA9vZcxs5mvrZot5FeVA5KNtNsmwlOvE4JqZwvjyl7Wsmn/XwFHlumGN9
 PQn1wd6H
 11SSvrm3EKbcAl6ibYyvrN/EqSTv1xss
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9 Sep 2026, at 10:31, David Hildenbrand (Arm) wrote:

> On 9/8/26 04:56, Zi Yan wrote:
>> folio->private !=3D NULL indicates a folio carries private data, repla=
cing
>> PG_private. All PG_private users are converted. Remove PG_private and
>> reserve the space as __PG_folio for future use.
>>
>> __DEF_PAGEFLAG_NAME() is added to show __PG_folio.
>>
>> Also update files in Documentation. hugetlbfs_reserv.rst is outdated a=
nd
>> left unchanged. It should be rewritten.
>>
>> Assisted-by: Claude:claude-opus-4-8
>> Assisted-by: Codex:gpt-5
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>> To: Andrew Morton <akpm@linux-foundation.org>
>> To: Baoquan He <baoquan.he@linux.dev>
>> To: Mike Rapoport <rppt@kernel.org>
>> To: Pasha Tatashin <pasha.tatashin@soleen.com>
>> To: Pratyush Yadav <pratyush@kernel.org>
>> To: Jonathan Corbet <corbet@lwn.net>
>> To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
>> To: Jan Kara <jack@suse.cz>
>> To: David Hildenbrand <david@kernel.org>
>> To: Steven Rostedt <rostedt@goodmis.org>
>> To: Masami Hiramatsu <mhiramat@kernel.org>
>> Cc: Dave Young <ruirui.yang@linux.dev>
>> Cc: Shuah Khan <skhan@linuxfoundation.org>
>> Cc: Lorenzo Stoakes <ljs@kernel.org>
>> Cc: "Liam R. Howlett" <liam@infradead.org>
>> Cc: Vlastimil Babka <vbabka@kernel.org>
>> Cc: Suren Baghdasaryan <surenb@google.com>
>> Cc: Michal Hocko <mhocko@suse.com>
>> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
>> Cc: kexec@lists.infradead.org
>> Cc: linux-doc@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> Cc: linux-fsdevel@vger.kernel.org
>> Cc: linux-mm@kvack.org
>> Cc: linux-trace-kernel@vger.kernel.org
>> ---
>>  Documentation/admin-guide/kdump/vmcoreinfo.rst |  2 +-
>>  Documentation/filesystems/vfs.rst              |  6 +++---
>>  include/linux/page-flags.h                     | 19 ++---------------=
--
>>  include/trace/events/mmflags.h                 |  3 ++-
>>  kernel/vmcore_info.c                           |  1 -
>>  5 files changed, 8 insertions(+), 23 deletions(-)
>>
>> diff --git a/Documentation/admin-guide/kdump/vmcoreinfo.rst b/Document=
ation/admin-guide/kdump/vmcoreinfo.rst
>> index 7663c610fe901..5f1df6d080508 100644
>> --- a/Documentation/admin-guide/kdump/vmcoreinfo.rst
>> +++ b/Documentation/admin-guide/kdump/vmcoreinfo.rst
>> @@ -325,7 +325,7 @@ NR_FREE_PAGES
>>  On linux-2.6.21 or later, the number of free pages is in
>>  vm_stat[NR_FREE_PAGES]. Used to get the number of free pages.
>>
>> -PG_lru|PG_private|PG_swapcache|PG_swapbacked|PG_hwpoison|PG_head_mask=

>> +PG_lru|PG_swapcache|PG_swapbacked|PG_hwpoison|PG_head_mask
>>  ---------------------------------------------------------------------=
-----
>>
>>  Page attributes. These flags are used to filter various unnecessary f=
or
>> diff --git a/Documentation/filesystems/vfs.rst b/Documentation/filesys=
tems/vfs.rst
>> index d3a93eec3945f..dec7816303c6a 100644
>> --- a/Documentation/filesystems/vfs.rst
>> +++ b/Documentation/filesystems/vfs.rst
>> @@ -649,8 +649,8 @@ Writeback.
>>
>>  The first can be used independently to the others.  The VM can try to=

>>  release clean pages in order to reuse them.  To do this it can call
>> -->release_folio on clean folios with the private
>> -flag set.  Clean pages without PagePrivate and with no external refer=
ences
>> +->release_folio on clean folios with folio->private set. Clean pages
>> +without folio->private set and with no external references
>>  will be released without notice being given to the address_space.
>
> This reads like it would belong into patch #13?
>
>>
>>  To achieve this functionality, pages need to be placed on an LRU with=

>> @@ -674,7 +674,7 @@ filemap_fdatawait_range, to wait for all writeback=
 to complete.
>>
>>  An address_space handler may attach extra information to a page,
>>  typically using the 'private' field in the 'struct page'.  If such
>> -information is attached, the PG_Private flag should be set.  This wil=
l
>> +information is attached, non-NULL 'private' field will
>
> Same here?
>
> Likely this could have been restructured to cause less head scratches. =
I'd
> expect any documentation that refers to PG_private to get removed befor=
e finally
> removing the bit.
>
> Not the end of the world, just a bit confusing while reviewing.

Yeah, I will fold the document changes into the corresponding code change=
 patches.

>
>>  cause various VM routines to make extra calls into the address_space
>>  handler to deal with that data.
>>
>> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
>> index ce7fccd90367b..7b7783c0a5216 100644
>> --- a/include/linux/page-flags.h
>> +++ b/include/linux/page-flags.h
>> @@ -44,10 +44,6 @@
>>   * Consequently, PG_reserved for a page mapped into user space can in=
dicate
>>   * the zero page, the vDSO, MMIO pages or device memory.
>>   *
>> - * The PG_private bitflag is set on pagecache pages if they contain f=
ilesystem
>> - * specific data (which is normally at page->private). It can be used=
 by
>> - * private allocations for its own usage.
>> - *
>>   * During initiation of disk I/O, PG_locked is set. This bit is set b=
efore I/O
>>   * and cleared when writeback _starts_ or when read _completes_. PG_w=
riteback
>>   * is set before writeback starts and cleared when it finishes.
>> @@ -105,7 +101,7 @@ enum pageflags {
>>  	PG_owner_2,		/* Owner use. If pagecache, fs may use */
>>  	PG_arch_1,
>>  	PG_reserved,
>> -	PG_private,		/* If pagecache, has fs-private data */
>> +	__PG_folio,		/* Do not use: reserved for folio identification */
>
> Do we really have to annotate it with __PG_folio ? I'd just keep it sim=
ple and
> have the comment. That also avoids __DEF_PAGEFLAG_NAME just for this us=
e case.
>
> (sorry if this was discussed in previous review rounds)

No one complained about this yet. :)

I do this because I do not want to change PG_* values after PG_private af=
ter
PG_private is removed. And they will be changed back to their original va=
lues
when I add PG_folio. That PG_* value churn might be a headache for kdump?=

If I add PG_folio the last page flag, it can be a one-time change though.=


Best Regards,
Yan, Zi

