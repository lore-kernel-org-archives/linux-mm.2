Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F06E0CEBF88
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 03:32:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 247226B0005; Sun,  7 Dec 2025 22:32:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F8196B0007; Sun,  7 Dec 2025 22:32:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E7456B0008; Sun,  7 Dec 2025 22:32:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EE30C6B0005
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 22:32:33 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 751CF5BC6E
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 03:32:33 +0000 (UTC)
X-FDA: 84194881386.24.0BE992E
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012028.outbound.protection.outlook.com [40.107.200.28])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0AAAA14000A
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 03:32:28 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=rMaMRJpz;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf09.hostedemail.com: domain of ziy@nvidia.com designates 40.107.200.28 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765164750; a=rsa-sha256;
	cv=pass;
	b=hSL7ACWGnOXlRppaEiuCf7D50+Y90Jq8soWH+RfIy3nNqvrFG2dg6SCmwk2SUfJ+G9wREU
	8ifLRFPFtbdWyjDpYsTxno4FmKjjALgH5lTgOd9a8Bal1Q5guaWdTnUtCqXhhW51Mx0Z6d
	Y6xsmbPovl4ghuBGejWmUPpgvoxNZY0=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=rMaMRJpz;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf09.hostedemail.com: domain of ziy@nvidia.com designates 40.107.200.28 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765164750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DAIcMrxadr1uWGNA9PgeNU/o+EU4Kc6CYuLckVe0JIU=;
	b=q3NaVcRcLZAPyr+SSfhr1noS+vqQqNxUU33bpTWCYGhmN+CA5YbUy3iNZSivdDXlt/4mAT
	SRe48jbwgKp7tUR1UHTS9ssA2b+ZyHOCsFJlfrHXJT5tJOFREsRaXbRVUm77KkASpKh8+D
	y0mCGNQrLPEq0yhYOwRgrwDdvsT4J/k=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aE4YnW4Y87xbSREAcIkNHOTlLJNwcvhDFIvUyNDfWgiTLC7YZzyWmkmnJWDWefRZxFJGJloDw+TWhPK9tuICnQvBPWzvwU1hsWe4OurMwxBl7i4yTG64tRnhbmkqLXDUi1zsPURQZ0SmLpccPovQkXVkquQ7hNQsVomkldG908ayflT5ewoZ7W8dNQNy2Qv0qVd67/1/hgAW5ukZYPnEwJ2gumGouDx7zm848+2LoeiM70UCBSchjXmgQALjNUd1u80PiHt9+RfaFpDJ6ANioarMZ+NCrvMYoxVeKirac587ldnE9Kk/10PnDvetlFrEFsnIPmROCs1zuoD6lndfQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DAIcMrxadr1uWGNA9PgeNU/o+EU4Kc6CYuLckVe0JIU=;
 b=vjgs5GvaCKP4HjxukyBdU8ZfNh9tV5pirw2YhVGoezS/UYQ1iqH1iJOpcsTk/RBDjPCVRV0s8Z99G2xYQozu7DR0tOW/spobqgy3F8lcBMsdSjs1wizTpOKxAEWUTyk6m75csK48Rm7C4jVHRDS8I6rDcY5Chr5xRG5Y+PTj17y6qofsX0hzwQjbEaRJl7G1RbDKDJ7E+l3lVVs/sQC2zLrV4LhewmUw7lLHH1wBFx0MbmUfwirStneKS1mOiWqKqp22NCsjpnlk0E94ZG3AjVkl5ucj+xIkaE8m8Kqz3iQg15IGZOlxD3A5KjM2jE80FIJqU2kx5wOw+M2z9k/sDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DAIcMrxadr1uWGNA9PgeNU/o+EU4Kc6CYuLckVe0JIU=;
 b=rMaMRJpzejhV54oBEnraw2ahBcj+b0bXawevOUIWzjTTRbcRHjAkZlvvg2uH2nOdOxhMhiu9Pp16kYQxiHjBA+fhGVl0OxLxMVJDpzzTis/WnDmKWazJnL97yTtqRyhoxzExWo4NpRoQpwuG7adWdXATly0tnfBlqc8tL78rr2JcTPooPhJmYIPIBVJWSXcJklRyyD29S5dz9mvmvglqZcYlywBEyemOfaU0HO/wff7sLN/L5z70/Oe1LA+zVIw01f9D0Qdxaf57G4IrHCGj+b1pM9gy8hToA4WzrH4xOCQyL2K596CrmHrf8rJgVySACiGUxK6Q4B2uXBVUrgIJGQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SJ2PR12MB9113.namprd12.prod.outlook.com (2603:10b6:a03:560::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.14; Mon, 8 Dec
 2025 03:32:20 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9388.013; Mon, 8 Dec 2025
 03:32:20 +0000
From: Zi Yan <ziy@nvidia.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: willy@infradead.org, akpm@linux-foundation.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, david@redhat.com, michael.roth@amd.com,
 vannapurve@google.com
Subject: Re: [RFC PATCH 4/4] XArray: test: Increase split order test range in
 check_split()
Date: Sun, 07 Dec 2025 22:32:18 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <E3AB23B6-9B6C-432C-BD92-27520ADA0739@nvidia.com>
In-Reply-To: <20251117224701.1279139-5-ackerleytng@google.com>
References: <20251117224701.1279139-1-ackerleytng@google.com>
 <20251117224701.1279139-5-ackerleytng@google.com>
Content-Type: text/plain
X-ClientProxiedBy: MN2PR20CA0043.namprd20.prod.outlook.com
 (2603:10b6:208:235::12) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SJ2PR12MB9113:EE_
X-MS-Office365-Filtering-Correlation-Id: 3fa0415e-de58-4507-a802-08de360a6507
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?v0JtF1F0pRf9iOaAVY7L0626FXKU3U2K0GyJE1S7rT9wGkTaHHqH9UnhIBBP?=
 =?us-ascii?Q?hVe4HqopF/XZEAtWHJkNMAcuQgEGNO4yk7d05S1jUrTl75s9E7KGx53AdCEo?=
 =?us-ascii?Q?xY/TghprLH/UYtFlVTtxgL6YbW7WE7fRGItbSgXhdOr6b5u+UenHKMvSlkf2?=
 =?us-ascii?Q?3f2NEAPVwAjaIqrSs+sqQ/uIMc9/3ifLuIQSIDDCnhFaLPnTaRDuFe08pou1?=
 =?us-ascii?Q?CncltQZmc58Th5h4RxAQHPbwMRF+0ZnTto4WJjH1+2AcRUEwe+YQhtKKfTat?=
 =?us-ascii?Q?mmJW2SLrviFtcV/LgTQwxZNblkYDgr43ulh5q2GG79NAAYefetJBqRtSoQ2l?=
 =?us-ascii?Q?F3bahSJhQuijHL+iZgI0QTAo8pjY8M1XM5Q+ktxwyaQQuuv40Ob2PsHREtT3?=
 =?us-ascii?Q?kHkN2NqAJiD7wOV8PV2CKMaQZ5Xbi9p8np+2YD8cBlRn/v0ZwsXOn7A8+vSY?=
 =?us-ascii?Q?L2L9TNAksl1cpPoieU0ou70vnOf7G3c0EGtrL8iq8IW3cpTQ8Rim4P39cw70?=
 =?us-ascii?Q?AVQP8FDaCOxSTprLzDqTRycEjCLgpx2HUOhMQlMQLNXXbaNT2MqGo8XbEFhp?=
 =?us-ascii?Q?Gyej+8HU4Y5mx/S5YoPGajoM2QnxnH8Y7+cg1deuqzNBHtn3BPp5VVuf6VCk?=
 =?us-ascii?Q?ka69hQbuG/rsdo1XIVnt94fMvuvAhFfzGs/9XF8TKFQRoLh7UoureD5EeN1g?=
 =?us-ascii?Q?3gNTs7blXf+FgFTyq8x9aWSGcSqMNceZCpHB8/bvljRYezCLvq23b9vacoca?=
 =?us-ascii?Q?mqV12I5Xf3m73FRqVu9j0mbfl0mTuBhLMR/P+YK+gZKpjV2bQACyzr64g4oq?=
 =?us-ascii?Q?Aup0t+VOtgaeQj5QCTeJ2qN1sh7tlT86cIi/RR3UelwJPZWu2TeCw2OHGpLf?=
 =?us-ascii?Q?zg+IgRAfEWh3f9LUNqNUTdR/zngGjOgLuH/6hIHdRqs+tGEkVB2MMdt0V20c?=
 =?us-ascii?Q?vMc7oa1SB3glT0p0yXvAc8WObz/jywQoMGFybVldAI0GRFI8z5LzpzCG0imf?=
 =?us-ascii?Q?j0Jw5IV8zCqPjUk0pQ/IEOOWTviU3TBShuOuvefqcts+0DEexiL4FInhE+rI?=
 =?us-ascii?Q?aAG83en1WHdwYnV/v4TiRzpC5GMHM5MfCJxIBhjxAkDzxE1sR5SKIQD0iyQy?=
 =?us-ascii?Q?Lfl8quuQtVVRu9AFozhTy6j00l2FKoZSJbqUR1LLTEBBeBL2T6KOx5UakOj0?=
 =?us-ascii?Q?MiFY+djOUUgzUJlysVrLHqI5QigSXok3jOc4+N0koFs6/DaJgHW7aAO2KhWq?=
 =?us-ascii?Q?tMtSQ3MYsRL8es/63QGjeLbTKmDtEqcY5YPDWNYnH05r+2/8CoBDn8gIay3w?=
 =?us-ascii?Q?au1H7eTneVMOpsK2UxZ2f1ffP/horU9nhV25o0neVX6pirh2jEH5ePZQQQiA?=
 =?us-ascii?Q?IRzy2N7z2/Hk3RGGPEC5k1MrdHH3PEERvlN6TV7NvmPeyTKIoP+Z9DTbgdio?=
 =?us-ascii?Q?awZDPIch87O9wAaJnwLLG3a9ijiI6gIF?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CZ2SXGOWC/nmeHUDsd5D3AwuGGtbXY6mRaMpCvicZEMIKcB0AnfVQ6ey+T+H?=
 =?us-ascii?Q?by+IVq4cDf9nDCJXjnaPgGUDYJrKbzdJHiBjyPuYi15lNymBQX9h6YVlFkdl?=
 =?us-ascii?Q?uGtoEdZQRNGb28uD772Dhy+ZttoGyefTRNSPEbZj7+qAfHjEKL7mdSlNPKBQ?=
 =?us-ascii?Q?l068Hg2w3sYjRMZIIcZnxNpGVb+9P/JAIx+/8pArNUo/eJqD+yzFFY+mjRw7?=
 =?us-ascii?Q?fz4crTlWMa25Na958uzJtYx56V7gBO3R7KNvKcd5wbTA7IyGugQGzORr/qLO?=
 =?us-ascii?Q?V73NaL0l4twnncSZSVMghRW0jBIXrlHKxXmsKjtd04plbEzK5GHRjRr6HSy8?=
 =?us-ascii?Q?xxbL87WK44fmc5CBlURmkNppUMu4+H4wvtV+J4i/PpEtVLUh79Q7MVTtrZXU?=
 =?us-ascii?Q?du6slS7PFuxsFEvjwwXyBGZNs90w2Q532lh8mVzXo5iscVU89MswjxIMLaEh?=
 =?us-ascii?Q?Sl9midPefk8t2Z0vpx0GGi3fvwkc66fQ8Yki+c+oOuCWSaCfPkhixFed+E2/?=
 =?us-ascii?Q?eq81tjXo5tm/rxUaOea/ETR3TJIfrdIa3MC+AtwyFZzoP/ggtsNM/Xw5hK3b?=
 =?us-ascii?Q?kd4aVeKzT+g3Z6aEesqaFbGyfqsW3IBUiqfxoUtYSnBPPFSjHnN3ZPeaqT2/?=
 =?us-ascii?Q?74SwCYBuSe6tRZM0tgaDYXzBRw3po+Wo0mEQDSL9JRoBb4QfttNZ22FOP+Gd?=
 =?us-ascii?Q?0Vth0ErhRU/2qyltwGs/3YWxcqY13P7fqJEt1rVeVjKcIK0unm6xAe6CVF30?=
 =?us-ascii?Q?paS5Uakb5pmvwnNK4kpiaMto1+Z11aesB05jlr92QlgPTjGHtLdNEnI4dy6y?=
 =?us-ascii?Q?+sbccdqmSKp3zmphs1NBxdxwZg4OpVtEvE9ZBZt/Csa1Rf/ablMJmpOgvvlI?=
 =?us-ascii?Q?/bE50d06V+uGvDNTw1yNnM1lzMZVXevtC2b2En7jCU3y5GUbvKLfhUPlTzAS?=
 =?us-ascii?Q?DhninTr0NRnfWCLLUDya8eYB8NxKNFsDjPbLJamDryL1CwucTO3UNJJdW31x?=
 =?us-ascii?Q?X6SQi/ch59ZjNoaEAwfLbFAyzC0vy3HURcuKzSLOgRSzjpq8Es3z5gQmAfRt?=
 =?us-ascii?Q?w/iLADspl1i3ew3CK2jO0SZsiknTvzhv4LVNafr5445VtY0+RWTlMg3M7J+j?=
 =?us-ascii?Q?NiHTP47nH7mbNeYxP9IVnu2V+XUHskN63LJLGRMN1dmPLYzc0tOj6VotNEZ3?=
 =?us-ascii?Q?Rz2J63u1wfzAv61hKdV6sIkICVSWJCdQzEkVQmrBwmQx0brlR9k1Yq+iZgn/?=
 =?us-ascii?Q?wnFuolYbOq2hRLNob/KlUBpJHMd97KHS3XbBuvaGVOBBgFrak+IYEvJEKZV4?=
 =?us-ascii?Q?rGy6zlVo9H+Mn43K+uozOULnmshaxl9IVRgXnyLdMPVzTu9/s9VckISfCpP3?=
 =?us-ascii?Q?3dTbPk4RpBh3Z7FvFtW050nyfWshJIRHv9o55Wijn3evFUIvCn20gzznQSj5?=
 =?us-ascii?Q?UwyT1NInitNG2k93z/48U3I1V9/M1Bc0+KXvqODUvInMhSyjf7s7/IsYKD7y?=
 =?us-ascii?Q?56Ouml49CzFVdy4FHUEF5QU58OsDobcCPLzFxxcmbRAAJTI5858MM0V4eD4F?=
 =?us-ascii?Q?Rf8nlagJeVeqKR48aE8=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fa0415e-de58-4507-a802-08de360a6507
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2025 03:32:20.7165
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PFSp8aHrdpJ9T+5tb3rEUW7iMecx6a98inUKfCTJJY+mDzpt1BxL3BXrAoPSaEpn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9113
X-Rspamd-Queue-Id: 0AAAA14000A
X-Stat-Signature: u5c63apene8z76kindnbtwe1iip8jhw6
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1765164748-995471
X-HE-Meta: U2FsdGVkX18XP+rb9DG+OT1Q3GpEjDkvwogdLudimDYhgbNlXxwmJefP7koOZqM0aYG7DKqnB49JLimeA/s+xhXpNrTD3ahJwKooy757zLzNYhINLNFCMLw4jIlEfB0Kv5Tf692ILMBF4KldSI4xVLQeNl8TivFnQGYokOVXi6pzEBUPNYRLccpT/Z1Vk4kBx5Ms3lg5PD0APjOy4WztAj4zydRLfgNVYDXpmafIfyvXU2AqnZhe+RtWACks9DXNJ58Lwwcvz6ABFfA/AuagmvadeCpSnZGMeiZ/+PyiqdggfMQ5mBAttbyzC4YZn2WryX8uPgUCJMFQp8q4RSjLqKMvnJVMUqoJoPNSFxyXCZSjZvOnbiUlVam6UV201/ksVMcKuoJEKf/afjtq1Rd1hdh5bnkzMH9cUPsiDY0rXQjkjh+ADWL8newcCMOfffkIPXvgvLYDFv6zLTuLVmrYQxwElVNW7neerPoMkLP9wyN6DS6uwbHHkSteyLn8hAC8EgVI0JSLqyg/2QgiA4RarP2rgaFxbPS2ztCe6VKBkZwV3wHUyvpBWorXEMdt9Z6BrCiMMgmdlWQgBFEyrUfecibREWRrcctIRQkHEzJ3HcG1AOHsCftuDebA/NjqGkEVPa+94vXPGr46vY3s0sB5Oi2qDBmJAuVloQV61jOxDt8YRMwPoG+m41ZE4kEunVp7EN5SNKKe0LWUs3POAH68LC2fa6vpdw7cVijpRFoIfvXmiesX15EgigYMCDo0Kk7ZNL7H9O6w8cT/2z4R82kuFYbqUSZ3+fpWMSkJym2TE/88oTuMcC3SMk2enJO5M8LMLtQ5eWKr+adgEj7pytyT4p8JR+MVCi7FpeARV69oi56mW5FV7/o99N5+aEj9aKJytUDXiewXA54UUjPOKxe/XYPPq5BBYpxAIlrUmGSW/oTtZRj9xBuNhOBeSug8w3z4M8lwsDyhBWAWPMoGLp9
 i9r1gJTi
 S41RA5P0/NiaONFSlgX3Jp6yMIjVLgqs/3JziXA3N7MaQQdIK5BnZv67E4nr5KUf9aJlQcUzw+GLqVQtvThBz57PCerY9SON5xIUz23UqmrB96goKIdygkPxlvs2LfkF/Smtdg09JpZm9vW+nTTZ7bWAeGckvgLFodMprrRb5Gbslvmy0HWrC4vfK299t6jWsxtq7vQRfymgsubC2ec2Q7dPZmN+pZDqpLPYwey3cgBlw1NGz8ZOBrL2rVMyE+7R6x3HKvwCHWQ0YffSY3b19vhjgvBLDU0WzV0vpKetBf1TXUhowIZkP1xd0eTBLC0m4Ok0YqONsaijnCcPZWdQZWP9xLmMBAD1TBkmk6NwH3DjbINpANT7ngv9iX/X9Y1JLuR6HiEh6zCUcAZI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17 Nov 2025, at 17:47, Ackerley Tng wrote:

> Expand the range of order values for check_split_1() from 2 *
> XA_CHUNK_SHIFT to 4 * XA_CHUNK_SHIFT to test splitting beyond 2 levels.
>
> Separate the loops for check_split_1() and check_split_2() calls, since
> xas_try_split() does not yet support splitting beyond 2 levels.

xas_try_split() is designed to only split at most 1 level. It is used
for non-uniform split, which always splits a folio from order N to order N-1.

>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> ---
>  lib/test_xarray.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/lib/test_xarray.c b/lib/test_xarray.c
> index 42626fb4dc0e..fbdf647e4ef8 100644
> --- a/lib/test_xarray.c
> +++ b/lib/test_xarray.c
> @@ -1905,12 +1905,16 @@ static noinline void check_split(struct xarray *xa)
>
>  	XA_BUG_ON(xa, !xa_empty(xa));
>
> -	for (order = 1; order < 2 * XA_CHUNK_SHIFT; order++) {
> +	for (order = 1; order < 4 * XA_CHUNK_SHIFT; order++) {
>  		for (new_order = 0; new_order < order; new_order++) {
>  			check_split_1(xa, 0, order, new_order);
>  			check_split_1(xa, 1UL << order, order, new_order);
>  			check_split_1(xa, 3UL << order, order, new_order);
> +		}
> +	}
>
> +	for (order = 1; order < 2 * XA_CHUNK_SHIFT; order++) {
> +		for (new_order = 0; new_order < order; new_order++) {
>  			check_split_2(xa, 0, order, new_order);
>  			check_split_2(xa, 1UL << order, order, new_order);
>  			check_split_2(xa, 3UL << order, order, new_order);
> --
> 2.52.0.rc1.455.g30608eb744-goog


--
Best Regards,
Yan, Zi

