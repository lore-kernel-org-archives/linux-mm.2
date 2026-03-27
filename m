Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 700FF10BA438
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 15:13:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C816B6B0099; Fri, 27 Mar 2026 11:13:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C32206B009B; Fri, 27 Mar 2026 11:13:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B482B6B009D; Fri, 27 Mar 2026 11:13:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A54266B0099
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 11:13:00 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4CBC61603E9
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 15:13:00 +0000 (UTC)
X-FDA: 84592185720.18.6207CFB
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010049.outbound.protection.outlook.com [40.93.198.49])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8C32A40014
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 15:12:57 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=e9hR5kZ3;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.49 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774624377; a=rsa-sha256;
	cv=pass;
	b=M3FHuEvqNplkfu7bzASKIS/yO5JoOtWXfNkrfynOlTW4GxC1Nb0CQvDVP9m3vmWvMhT67U
	T713IcsF8r2Nf4ewBWhi+Gz6VQTTgke0IGJba+OwIUS9O1l5ikHbhpBXdW0py0yCwfZVpB
	QSgYV1cKRMh2Vv84QBB4HpXb5pCai7g=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774624377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8sgyVu3BLpLV50ujzlFNQlxtD0aZ0ElwJb147GhSxI8=;
	b=XMDjr/ZhMuQfjX9WgkdhrKbkQA5mA6AfYJHYk6v2+rAm+Kl7EMfWV0kvBQWpthb17V6I3B
	EDaH2+1pn9nyiA4bpMEzVht1smlaPEUiOm1BSslR/ShJw+EvSZVS/6DC6+qxTfwgHI7ENp
	GbckfkXHMpQZmdvp9rVTnHCpXCy85GU=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=e9hR5kZ3;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.49 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=urPsqvOFrBIkLYTS7OLsaJgQvo47OUMwa0AdC0zaj9zaqWSNVCTUSJZe29CpnTrdm0LZfX2bO1fjlbf/LsmAxh52RwqnRwCz4Qafdn4QecoqIqQVdNxbqU3jSo8yU4fjJ0U1bDvSnwLQssJTfa9Do+VZdi4S/gT3tYhtf0hDS2lZQVgq62oskiFyzcCqk0YHCYWUo3f36ped1nDDxOs8Q+meNC2oMZFBSyLpcQHPpnL45xBj9mq3OP+60B7/xu8oBzyx7ekLIv0rCAEZH2tMZbD9JtCQjcKUjfMavi9/94oQzZh8+/ZllYWW6vAhvMfqM7D1eKjs9ntvhBL5sMLUaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8sgyVu3BLpLV50ujzlFNQlxtD0aZ0ElwJb147GhSxI8=;
 b=BfoQZLVb9kn804mC6IpuuT+mIi7o4TJgqBM16MW2yn+HbInNTqnUumdF2mU+7fMIxj2Xb89Jq62QZURuHSBpxalmrGLIpfwpVz1OcoR6cUEEIusmeohg7sUcL9eFA42T6CgqKPYkOhC147cVL7enLozYgqXYS4A1BeJ1PBHrZzTGx+u9pJx+j+z3R/z5C1R9y+0R4dWaEFybatZXyB0eCznHACaP5P4yfnBdSettX4a7FV1oM0aF/1JZFUPI7Xbk3DzFy3Q8uOwwTLwJxboXZcdW8gJmJxVR8ssGLiGFPuQg+jmti9B4oGolF1ds1H9QwBe+fZTyjdHrMjqWVrPNNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8sgyVu3BLpLV50ujzlFNQlxtD0aZ0ElwJb147GhSxI8=;
 b=e9hR5kZ3HQlXKShdcZtcvz0mCKA78QrgPQKUfpgEqV3kEYCJAjEw+TZ+N88FR9i7HemAQ1MSe3w8XW0JYSDYaixscm98emy5Hq6J9FpgYGwhmR/1bGOVZMxcWsJZuN3qAv3YMq2ZMHdpeGI28h4p47hVlCllLuJ/qhjevdVz+Quira7aW5q8H98HEZ5CTtpr+DYvuvbAwVcIufenGRoMR9J1c6T5rusK2nakQGdituGnwvLWOHin5qH+Bx1vZC89VKFfBH40uRxNW0wZIaeVXZBaRsxJT/wcpZrgsC5FQlwjPJYILNb3UB/bDDsRNHIiydIomC9smv4vC2xPJ0edzw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 BY5PR12MB4113.namprd12.prod.outlook.com (2603:10b6:a03:207::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.10; Fri, 27 Mar
 2026 15:12:50 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9745.007; Fri, 27 Mar 2026
 15:12:50 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v1 05/10] mm/huge_memory: remove READ_ONLY_THP_FOR_FS from
 file_thp_enabled()
Date: Fri, 27 Mar 2026 11:12:46 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <075A4C69-B386-4557-BDAA-4038EB36370D@nvidia.com>
In-Reply-To: <5ac47338-1954-43ce-9984-56d70f7c392f@lucifer.local>
References: <20260327014255.2058916-1-ziy@nvidia.com>
 <20260327014255.2058916-6-ziy@nvidia.com>
 <5ac47338-1954-43ce-9984-56d70f7c392f@lucifer.local>
Content-Type: text/plain
X-ClientProxiedBy: MN0PR04CA0009.namprd04.prod.outlook.com
 (2603:10b6:208:52d::30) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|BY5PR12MB4113:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ec8f197-ccd8-480e-c491-08de8c134fc6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	MXlvvn3NDPKoO58Xv8YwTgu6tVKW4aV5R+KzgTFaiGB9KQtaADDBV/YcC29PY6LyzcJ0AcghNQIiSnGzNEJ+CJI6lCX+eZT4azLmTL2hXhSg6L66Pxs2gRjTFC5IQyTY+z3kIempTqSztqf4LTIMJY4oQUBSumI9JdOVqJUAqgcP30v2fZxtGguDVl2rZDObHE3A/ZJm/gO3fZ49rzqe2++q6GByXTe0Fv6+Uv8G9krXcMKhGS+88Q91stPD03whbIuwbRsBKIlGAxXjfWLHXOYwX/Z1jUmXAfr30Dg+dS1W6Q9ZwAQ5s+pWjfHnwVPFR5q+1WW78nXkDjebjxEthlMeAr4hK4LXBrGmqWcSpwExQ6ZSqE7AlmqOVe7jCa663ZE/Ge7kX5s8DwhUDcC/cJF0flSMoJWlItorafcU01lCoqds3CZzW5rny//TzfrTrCetf6bWx3W8v0UV/7sVOwSaR3/4s3eKsNtdvcHzSpwFvIBLEUEXe+CRNASIuAUVsYsE3XY0ysfV0+M1B+wMD5vwEJjy0SWHIWTr6DZE1VCXvmPYKdV29T4ZetNhQjds2q9WH0h8XNPGa23hp8Kf6n51A/4109rF98cdGLc88oOx672t3OVQaq0r6BCbbcPxNZhgvt7M9NUDU98iqnCX2cp3Nscge1hx+57hXt3ZSgaJL/NkuLTKf+lwtEZkBO4wbO/s3SE4M48R3gZH0CorojjvyVl7c53MXmy40jAhvWA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dKfRzqJyfpor2nOGguT0y8XBUDeeXZY7rVduxy8W4DAtHWHFFUJco2Ams6qV?=
 =?us-ascii?Q?EHWHWTZznfWrkuYAPEF1AOwzXG2oTFTET2FzDcTkZvUjl1qF/mCOOvbYnIqP?=
 =?us-ascii?Q?t4t3wSO8bxfPUYY4H8Ti+SsDtZjsqdqDOdIt+681vk76FS+LIQo69LlbxBC8?=
 =?us-ascii?Q?9RBZik4rLUgZgGT6ihPkQt1UlqMRoLrQetRWP19KRmnBY2Y2E31MbXKlarZ/?=
 =?us-ascii?Q?5gTD9EaWJJ/tC3Yjq9XS/EtwiMIRUFo8HrloJJeBa39cYZMY0R1NXWY+iN1y?=
 =?us-ascii?Q?JdPypNRAqyCztX0AhnzzpH6pk6MTs+XF/L+O/USSd0sR3OIc3QjNXDXYMZvW?=
 =?us-ascii?Q?I1s3v46uaDKhkZXHMuv2230uyrJOiuIh5rvZqj2m7Hd/Uw3CUrNrPa8Hn3VE?=
 =?us-ascii?Q?THuWqH//CrD5j7g9+Yv4HCGGKoV0VxnSRcAm7aB712Gsf5LaCU+LIRWL9FM3?=
 =?us-ascii?Q?H8BuXC+GDHnPm3NnhKwHcMsXtu2VW7eZsqMFpmgdUr0JpqAoAF3tReg8BfkB?=
 =?us-ascii?Q?yE1pzkcXu7ZvyrPjMPJCcZm99r4ZnjwZroe7tXdpxuZbf/3gDRfK02bd9Rms?=
 =?us-ascii?Q?2YUxxaYTE5a0pZhto0kwXRpu/qKDI/iTLPE2TWuu2px3R5NzemUNy5S4o6Wg?=
 =?us-ascii?Q?MjqKaRQvdTMWP9qFqM6Eq6G0axJWrj7RE+TZmYzchviRE2mUpUI3F8Qb72lu?=
 =?us-ascii?Q?boLJQh1eoAeL3wmqgQ+X8Bubf4eiMWKWLKKtVEEYHQ9njs0hAjxcyGzkLW4Z?=
 =?us-ascii?Q?VsGwvP1W0nJkiEi0Mwmxyfly+U+yU3sWq3aDZ08jj6T3GSU9V/qBRfwwRAnL?=
 =?us-ascii?Q?kawhmq/aRjRoVp6bmhGpzjz1B7WZbYFYTKbVUf4tJRhUrwPIMqShxfV0ZNYN?=
 =?us-ascii?Q?kMurRV1pfCQZt4u4wwyTDKPl+0hUjlSyzI+In+vvVep7li7Yqxyt3BjLCCHx?=
 =?us-ascii?Q?5Q3fP4i1lDoEaLeKHYa0iD9Kl4n3QNNRTTKVNUKtkjy3YPorYxdmWjfmwJ95?=
 =?us-ascii?Q?Ra08fkR4nvaRpiW0LG2UYFVO8Gvx0P8cKry8gYxi+zNe3ixIDUVcob6+YluX?=
 =?us-ascii?Q?65Sb/VIjoc2Bk4g4Qv6JriOnOJf2MrrBoRpRhHiROOwM1lIHFeaj7iQX9UPi?=
 =?us-ascii?Q?9/vGBs5krJCstI8H8pOanvTGyq9baTmluaepwrYI3FckLKGz4YfFGSG3V6ei?=
 =?us-ascii?Q?/zK1NNl+k8UWNTeyx9a1ClvY9xXbrykXFFe0dAlInfuYdwTe3V/naWVeS6+T?=
 =?us-ascii?Q?ojB1KZag/CzBZ7ywVtUDh42PYmofXxiro7MyQTXIHla+Vanp4szTPtA9pa6f?=
 =?us-ascii?Q?TGM24Lp22dEPr2AL0/g1rgmgcwx6DGC0Pco47TGmit2GUo0S2Y9LYNk+q0HQ?=
 =?us-ascii?Q?Pipg16aRSjCS9XafPFJlx9o4qySAqLkJgLOYZb8wPEyIy+HjHZdGj9yxiPqx?=
 =?us-ascii?Q?GbCoWHnt4rgZO8Rz4AI9k+q0/6tTW40rcl2rfWuO4Jcg99360y+06Yr3quls?=
 =?us-ascii?Q?ZPwousTF9j4WaLfBSMhbrRt8q7JpO1aeHaDkvJc1TvjiOoqgtyjiyb7vKbJs?=
 =?us-ascii?Q?elw646S+X2JIFlQokCeZUr6bEQOHF3B36jcxJRXRvNtBSRjISKmtuA/4hpyl?=
 =?us-ascii?Q?XfXFRwbzzuw9XR94x0FeNk3mHw4GEIHxo9lZH8wlffu9aGVZo1QI/X9CESgZ?=
 =?us-ascii?Q?uvrNJLQ45wfdJEbjTXKrW1yXbAQg6KfCBUctQHZz9thm6PPO1LffXPqtIcPu?=
 =?us-ascii?Q?p3XsbXEsNw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ec8f197-ccd8-480e-c491-08de8c134fc6
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2026 15:12:50.5817
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b/0vQ0P0M9Gs5wElcfAVT2euAl0xisf2fIID3DZ8HMrYlMnucUUuYWINjF+ZqakP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4113
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8C32A40014
X-Stat-Signature: zkgt4z8m13dh5m5ju7g6crtthascccu3
X-HE-Tag: 1774624377-651330
X-HE-Meta: U2FsdGVkX19AYjqG+P7nFvf+F5siJh/Wwa69UK9eINH1Cf9hAHcNWiLhTV+RBeTrIf974YrkFeR70I27DPLgx+pibktClINflpAzaNJqwGmF4BlbWYv/geWhNLH6596yYofJ+bXavr2+Myps/1ys4akPBvzIvi3pZEQBRUX24E0Fry6WM70M97z8rnLQACmLPpRdQPNx50bU8KhpP8wEh/0m2Bj1V0rzd6n5OiFwsC/mdqTG961WzNL3RVK9A7uK+UmX8kxm0Ai2jZj7mdoUqZmAiBXVdbUrREtjW0WFY6WnGFUgRL3/zFbEwzKt+8uW2ngAyJ4QVI9SOhTSR4nBj8Fky2d133GjEEGKtmq7P6rL1Lhjgbbi0TnqX66O7Cj+mz6I2DhHDNFoybw28GtquaKNQii1TajUgfEsREWND0i6OXlJtqYEC/RNR6AR7ERx2e2psmfUInIiyq/UIcRl2jkKkPluDPDrGAkZr+o92c3i3Beytxp1ZN64pYHSL0Tv+AlC8TDfobuktyFZhPLQeeaH8JU8J8LubPkYzCT5PTUMgicQ4wbiSTlMo4IM+AD2uWjt5JW7jbNqi0O0vX+/BnRS+q4gN1+36BmJYfQXSNw4RboEiLjE3tK8eWVBELo9qpW5cGvHwGScWF2zYTqt79JGnQU2uf+HakxzkJWIMio7IrlXlHoORqm8jvcLk56ruVn9fwuGdAYISmc63mnkI63jtPctg9/f3RI9zCdbYQBt28JxZ9WGeMZaGqFnZsOKRzjKxokwrP50kvwq5Q8jd5nbGN7HTAXA11Mjwss5TIvTl4KM1IvJeyUa1SKjCdcJ5DTMP5o8nwFcsZDcps6V7Dk94q+PUdS6GK6xjgwXHbuPlYkkFBIp9kXIry0jRaSpiOINRWhdCt04zj/IkZKw7CwurDVsX+QgAg1nqewE1km9bmU2nQ5Yd4rKN9foPhrMKgFPbcjC3oCkK4VQAn9
 f1jdbUbl
 Wh1rfbMh9HCIq4LwzfPFKpO60gR3UnIAFX5lr0+Yi5E07byXgNEjvwFNnSQgLD4j0dJZLug1KeHi/T7x0VSlNv5HmJ5u+pkb2yqBaLNkjXc6lfno64Iel8hepvWjnGS2JYtOC7q7jr/0OXVT/u6AQThyl2w2IzZo/WBY1GeMj0lnNIyNxIlS5wu4EhdKxWMm69OEuCGxykVv5VsGC6CVrGng2QNVzAXa32i/H9zjaB0/bKkYqICOwVWQvEJjSQaT+mvmlHkgexwUkp/jtOHd8sJUdEFOElY4eUO8sGW9fwuIegcP/wbn4UfpMo+cdf0WP+tMkgxosbJ+JD8gLlYlTJFM2+Id6cwd8KBcSeVTPfx0Ebf1FY6T9RNAxDp1FdzFXsonGEgP9LJz1xjY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27 Mar 2026, at 8:42, Lorenzo Stoakes (Oracle) wrote:

> On Thu, Mar 26, 2026 at 09:42:50PM -0400, Zi Yan wrote:
>> Replace it with a check on the max folio order of the file's address space
>> mapping, making sure PMD_ORDER is supported.
>>
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>> ---
>>  mm/huge_memory.c | 6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index c7873dbdc470..1da1467328a3 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -89,9 +89,6 @@ static inline bool file_thp_enabled(struct vm_area_struct *vma)
>>  {
>>  	struct inode *inode;
>>
>> -	if (!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS))
>> -		return false;
>> -
>>  	if (!vma->vm_file)
>>  		return false;
>>
>> @@ -100,6 +97,9 @@ static inline bool file_thp_enabled(struct vm_area_struct *vma)
>>  	if (IS_ANON_FILE(inode))
>>  		return false;
>>
>> +	if (mapping_max_folio_order(inode->i_mapping) < PMD_ORDER)
>> +		return false;
>> +
>
> At this point I think this should be a separate function quite honestly and
> share it with 2/10's use, and then you can put the comment in here re: anon
> shmem etc.
>
> Though that won't apply here of course as shmem_allowable_huge_orders() would
> have been invoked :)
>
> But no harm in refactoring it anyway, and the repetitive < PMD_ORDER stuff is
> unfortunate.
>
> Buuut having said that is this right actually?
>
> Because we have:
>
> 		if (((in_pf || smaps)) && vma->vm_ops->huge_fault)
> 			return orders;
>
> Above it, and now you're enabling huge folio file systems to do non-page fault
> THP and that's err... isn't that quite a big change?

That is what READ_ONLY_THP_FOR_FS does, creating THPs after page faults, right?
This patchset changes the condition from all FSes to FSes with large folio
support.

Will add a helper, mapping_support_pmd_folio(), for
mapping_max_folio_order(inode->i_mapping) < PMD_ORDER.

>
> So yeah probably no to this patch as is :) we should just drop
> file_thp_enabled()?



>
>>  	return !inode_is_open_for_write(inode) && S_ISREG(inode->i_mode);
>>  }
>>
>> --
>> 2.43.0
>>


Best Regards,
Yan, Zi

