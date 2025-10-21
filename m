Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0D41CCD1A5
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 22:39:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E56448E0006; Tue, 21 Oct 2025 18:39:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E06CF8E0002; Tue, 21 Oct 2025 18:39:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCE508E0006; Tue, 21 Oct 2025 18:39:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BCADA8E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 18:39:00 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 30414BA9FF
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 22:39:00 +0000 (UTC)
X-FDA: 84023588040.06.23D33C9
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010001.outbound.protection.outlook.com [52.101.85.1])
	by imf02.hostedemail.com (Postfix) with ESMTP id 61BFD80007
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 22:38:57 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=bzMJPLDN;
	spf=pass (imf02.hostedemail.com: domain of jgg@nvidia.com designates 52.101.85.1 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761086337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jQQV5iz3xqeY7mo2lCPsIziBBJLO9r/FHtXGcJvk0is=;
	b=RPfM3r6Ykux+4RWMhj4zkbav6GKfi6vef5yZn/VvsefheSjZvonll1+xKuzs5+FIdcIgmg
	X+XS2vrV9PlEu6/33gzTmTek2koU7HYoixJuAL//i096R0dF0GlTXnxiBron0obIcOWo6t
	+X6ZMRTGO6ayqSv+2fgMucggs+IW6hg=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=bzMJPLDN;
	spf=pass (imf02.hostedemail.com: domain of jgg@nvidia.com designates 52.101.85.1 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761086337; a=rsa-sha256;
	cv=pass;
	b=ITr1rzTn1B4RaM98IHJE9bgdxXaVqfM/ILCZzHexCJQUpB796S/I2GTO+p+n58z9Sl7ov4
	gAWQkkN0Bh5hpaANEQIIR8yiw5p9cRG4iym2dn+xNFUmOmN7A+PyXai3hWazly3dnYioHL
	dCFcQ2X2nxRB8eB/oQ87lOPNtg6ijOc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aKyQxLjgcoGjMnBd02wf8WbIWUrnSog/K4EMvlQBJgSPh6FKZicE1bRBkR/3XNxAt/gswTzHGGuMbpc9Axf0FUWPmYskHLlH8QthoKAeSA/lYUNjICCxeZarbWRpzw9DDPIKnGhlV4s7UfuSPyUmxRS6+wLeURCB3sNKEi85x+l6AXzMvzMW8ZjOtHLdaJCaWInCPs3meM9UPPTO/oTn4QEHoJiNT6UpUXVMMyuDO6+PDdxdHZXym0902Dp8xsAcXp8SJqGaLrKf43as9BiWUhoZ2rNAAVnSSNlw7QFRp22fbVp3rTqMKCvnYC1NABsF7EdEzpUaISQJ4XwYBzYvaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jQQV5iz3xqeY7mo2lCPsIziBBJLO9r/FHtXGcJvk0is=;
 b=QCBJb0Z8+PHdP2lQy03+VytVxkhiDBtJFDoz+XJgKHDhxKrRp7R8gJ4XNUWaj+ZcI+S7DvmHYZFcn9rzKVuQqbnz3LCGuDr9meW6uDrHInHh4CMPvDbcn2ydtm/nY854qW3QwywyTfc4Xk+ggVU7NM6qsRn9pzK/hunp1XZPsV+rJhH0qI8egjrjuh69E7Kvje4xpo5mXAY/j3F2dIP4sY1FB8cUcx2hkJQo2f7Xm92E3In1r9539hMDm/SLq+T9KNFmP1IKaWCeUGyFKbc5jndv0aMQmMLlnOP3+rZ0GPpC3IQ5yZqpvJSnowbT2fKadWPbL5EvBfP+bmauiwsl8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jQQV5iz3xqeY7mo2lCPsIziBBJLO9r/FHtXGcJvk0is=;
 b=bzMJPLDN+rIfORerYOSHPyS51mNBZ6OwmlZ5IKJu61NG8RDH0ls6dM1LhGhiHj+EPY3xkvs95uQ4fC7WVNOgkCc1E3W7kKoAxdeU8E5QfObQvfJTzd7D/gfyshAqShzmU4//Xf63VdXJPPiQTknn/l1aqsfoJEuHy4gncbe1KtTh/DrihPa+JAXMrh/hUJFORlyTrkBTEV+z5bzLAEyLeZToRdXuKuPYDmvr9oF6+YcSz/cZmp1fUboW2AEl9CSx3GPcLviQin3LNMfqkOSZZxy705y0s2MIuD3f11QbH443wdTELwshWy/0pe01+1vpOsiIROYpEEdRa4bRprG/5w==
Received: from MN2PR12MB3613.namprd12.prod.outlook.com (2603:10b6:208:c1::17)
 by LV3PR12MB9330.namprd12.prod.outlook.com (2603:10b6:408:217::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.16; Tue, 21 Oct
 2025 22:38:53 +0000
Received: from MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b]) by MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b%4]) with mapi id 15.20.9253.011; Tue, 21 Oct 2025
 22:38:53 +0000
Date: Tue, 21 Oct 2025 19:38:50 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, ankita@nvidia.com,
	aniketa@nvidia.com, vsethi@nvidia.com, mochs@nvidia.com,
	skolothumtho@nvidia.com, linmiaohe@huawei.com,
	nao.horiguchi@gmail.com, akpm@linux-foundation.org,
	david@redhat.com, lorenzo.stoakes@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	tony.luck@intel.com, bp@alien8.de, rafael@kernel.org,
	guohanjun@huawei.com, mchehab@kernel.org, lenb@kernel.org,
	kevin.tian@intel.com, alex@shazbot.org, cjia@nvidia.com,
	kwankhede@nvidia.com, targupta@nvidia.com, zhiw@nvidia.com,
	dnigam@nvidia.com, kjaju@nvidia.com, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-edac@vger.kernel.org,
	Jonathan.Cameron@huawei.com, ira.weiny@intel.com,
	Smita.KoralahalliChannabasappa@amd.com,
	u.kleine-koenig@baylibre.com, peterz@infradead.org,
	linux-acpi@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 0/3] mm: Implement ECC handling for pfn with no struct
 page
Message-ID: <20251021223850.GA21107@nvidia.com>
References: <20251021102327.199099-1-ankita@nvidia.com>
 <hbk4hqrdaz7qipkpb5g2znhva63sghwsiqwlyf6pb6xccjtp47@vci5e4vbkjqo>
 <20251021164444.GB699957@nvidia.com>
 <3ss3epklrmwallhd3nih5qqzjk53dcgns5igudtsg4vnnyjyri@ektyavsup6wk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3ss3epklrmwallhd3nih5qqzjk53dcgns5igudtsg4vnnyjyri@ektyavsup6wk>
X-ClientProxiedBy: SA1P222CA0144.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c2::22) To MN2PR12MB3613.namprd12.prod.outlook.com
 (2603:10b6:208:c1::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB3613:EE_|LV3PR12MB9330:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b1401f0-da71-494e-f947-08de10f29c57
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?f3l//33xWaJkBoM7T4IsT43IoqlvmLAB1SQRqEXN4jA4hrbZkDzEHdsjyVbo?=
 =?us-ascii?Q?McendHsn0Un71DeXIMv6Kb4JPtpAEqe5Ml45ps+0fnH5akZaXM0HpPAz/G4l?=
 =?us-ascii?Q?K3R3FEQ8vPKBT2Zsp+8YxYz1z6uOu5f+2kViOQJbyDB/+HlC7MzdUHKPbftM?=
 =?us-ascii?Q?RNf0QCGjdMJF2zJ9WGyJfVueffvApTOKgiATfxxcY1nIScxIbMJ7HPpu4SAR?=
 =?us-ascii?Q?PaSzo9i4L0i0ACESeq0v8ZFkVeBWXQZTwFe5vX+TfFiynawjkuWrlz4pEkVR?=
 =?us-ascii?Q?GTEne5rDVtxgQokBa6rxKFdbYYklZR1+7Knc9oVv5wdM175w0lvcKuw9wKiu?=
 =?us-ascii?Q?QzllVlM7ccYwIx+8dn2KwoF92DhmNS2iWPPOsIhofz7IXEcWH20DucZe3zbU?=
 =?us-ascii?Q?G1QuNfbWveCE6tQNp6T9+dQmHy5+Zf+hJy/7RVGurhoxkl670hlsmBoUrk5G?=
 =?us-ascii?Q?36Z5Mrcu24PeC7NnqmBJQT6+nNuYvKxdNUAj8MEU0GdIsr3RaXx+EkoisE2P?=
 =?us-ascii?Q?8bTRkxD3rOZ+9GE0QZGdvx/ELGWMweAJBIktfgOxVcwvGf/1KNXT59bu6+Sc?=
 =?us-ascii?Q?Jic56bKnf18e5IC2B1AiSOgkAgjR9z1scr/pIYtLXzjSEdz/szXqJjvxa/Sg?=
 =?us-ascii?Q?h3gAGQcIQN05yUF6ZpC7GvXDjF79dXjX7r/bwlndkqH2fwPDJevtrI7BGURd?=
 =?us-ascii?Q?hw0asIg3uiSIfrWzmO3V5bf8MKg4pVKTw4LHI71cw9GUoNv4If2Ls4CZeNFn?=
 =?us-ascii?Q?uFdJiLJ3vOMeuFOWMsyDPNoSqx6to6WiL0ldIAnoMGgp4NYnXPbqGtDQ7PRN?=
 =?us-ascii?Q?TPH7NylxVjvjoOQh/v3n9dsDjDYczYZQpaLyhlhpnGjV6U/ibpo3a7CzKjfI?=
 =?us-ascii?Q?dTulrHcHdcdrKE/Lq30m8VuDrCYMzDlMa+o/Ck28w9IlHO3I/rFnWalFMYh+?=
 =?us-ascii?Q?Dw5syZ1HWntjl2AR8TwTwbo2WVv7ZiRpTFKkKe8X1xJVkCquY9V8fTI1pjFf?=
 =?us-ascii?Q?dlZmx3CKKMlRNKbMdyPPUBblOVXl0V+gL0eA/tL30GeHH+QKCtKLMcXFOJaI?=
 =?us-ascii?Q?nRkNnQroETje0y0E1Tw42dfOubwGUM2BwIW56yXydwwzllN8+xDa/QpkBgrR?=
 =?us-ascii?Q?pcP6nTJE6B5whAOEQBIgl5X8RXzUwXzdSUOo0wmp+zWs892xRdvmQsIQXhp1?=
 =?us-ascii?Q?ZIL4CaYzMSsWu00YpAm4MOLyfOKcwKDzpjOyWDs2xuFLipWvTgfQvM+FwBjy?=
 =?us-ascii?Q?WxfdIf3A4s6IM3axcmYe1IgwOYInhNffiQBXMpEQf961w/lmcXUCauARowEd?=
 =?us-ascii?Q?3D8cRhyDBhrFRkMtj0anYPtUkIAOCRJ8K3nDfznbGUU3++/9PY8/RgfKQOB3?=
 =?us-ascii?Q?rq/dQOWycAjL0et3cdgILulCfF4eorEJhWbdiPGPj9Hgr3G/zm2VFTnLTnNe?=
 =?us-ascii?Q?zaPrh/JBjxZvI7/kh7hN7+aDKXjkN+/kxsWZegIE1RMxpbA9Br7OBgcFKD+r?=
 =?us-ascii?Q?YEvuBxNA9satjL8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3613.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?SLRnRmnFqMp8YALmwZvuktq+s/qbQfEINbYxcYK1Y3qgfGk9r0Urej+pzXGV?=
 =?us-ascii?Q?ii7VKAXeUM/dvlElbMyq1h2YyzprUnB3m1wh7dGJLKItlt4ERFTQVsipgFe3?=
 =?us-ascii?Q?qPDIXC1rMjXt4hpc5ycE/cIupTnAmOzgqxeHhW5G2qgf87tFmarhfBe9vXLa?=
 =?us-ascii?Q?EhZ0oSaLtR65Og2/o5xfjkeNnhZB5T50rgwgCZl/zfnC+pj2V7z2Cty0eqW3?=
 =?us-ascii?Q?EtdfRBmMx7SKYy93L8D/d0mbh3pIFB0zfFYfEteweo12TYGiwiyy0IG1lFU+?=
 =?us-ascii?Q?Q4I02YZhRCB7HN+pZ5dkO4AQl2CveawSLLxK1dMqN7mEFRGtwIBLcfHSThH0?=
 =?us-ascii?Q?50wonK+Gs2m51KtO5cl5xA/X3PoIivSdbMucSOzKU2PpdJgRLK/0cBjfEesF?=
 =?us-ascii?Q?2lkcdBS0U7wwlpeXCQDjfTCoANAoz0o1jUqiUs/6jLhlIdhFQ6nQTv2BwKRJ?=
 =?us-ascii?Q?F+5QUtlXHWJ/gnriT50c38BPwyjeRzo1sxXG+kIMMXup7mZzEF29234lDzX/?=
 =?us-ascii?Q?+g5Fc/9hUlypcb626WzQBQv/fR8dizhjmB8zK8z/iOU/69+KvIX3r8OncMrc?=
 =?us-ascii?Q?Z9CA2UMVN4vgQTAuqH9Xk9dQkgV0FRh5WaoXMYLugoRxdYPhkqCH+/7+/t+k?=
 =?us-ascii?Q?ubUkX5HLcARAKxMUzsS2JQt107a4RKqh1wyHUCZKwIfcC6F+NiLvCxbKeTRz?=
 =?us-ascii?Q?F3eTMotbRyw5OA9PVrAy3aZB0hfH1XCG/ITI0sdyInlsMp+vqQhUEriqUJ87?=
 =?us-ascii?Q?WA0Cm/3PsG9xPOvJc2n9Gg5zkS2OnA1ZdZ/zK1ICsz+EEZxn7mfslSgQgiYX?=
 =?us-ascii?Q?oAPv1cmVhVa34VywqEnLr6QH9JTBxdnLB4jCk2hipWBST46ZKCsWyEDrjhtD?=
 =?us-ascii?Q?+GSzGwHs09R4GDiWQYxQiqGxLnldbGN9MsR6QZq6Ss+U5XDFzQBw2DAyl5rQ?=
 =?us-ascii?Q?kFzFZ/Ri3uB1QTjxgKl/UjWPcnlKS85J7A3LASy/xAEppx71Z+qTzwTnF0Yd?=
 =?us-ascii?Q?cFt+VsuUGLKxGdc3EjaSvP50Urfjyfif0ppnUWH6Ol2xyglg4k/0W3+AnW9p?=
 =?us-ascii?Q?AdSwOEeQ8XRLZr2IXG6be2/dc4sFK1vb1TSlFCruI9sSGvdCDaem3/lMaQS6?=
 =?us-ascii?Q?zXxKpwdfjEllMhu6h/o5T8FQG+qe1XjIKIL9OMT9DTVFzJEEP3UoVRr2sXGb?=
 =?us-ascii?Q?2dkTUJKJSfhWH8yrf8XvolD8Ff1gDzg6D8bmctDezKu9MU4iWQFyPFUowpmG?=
 =?us-ascii?Q?LrLz4bd20P8ch+BHjFx/b9DRgTI3tb0nz16VA4pGRXR2z2C588Uv1MqNRvCV?=
 =?us-ascii?Q?qhQmUX/TPYLT97Fgq/fJUakzzz/DCKU1XXdPEYOogUatouhSEgLY0nm9u3st?=
 =?us-ascii?Q?iDfE4lPs9BnXuQpCnBYFbqKeYPP0GQ2mURUIAws71RI8lHmtyeBxFFUrAJJG?=
 =?us-ascii?Q?Oe+MI9YvdlXZCO9bKvuTFf6iUj/bHRkCdbibNA4Hs0Fy4Nm2vx8l0cNehN7x?=
 =?us-ascii?Q?xzpxV3rWOGOmhqLGTVl2mOyPiy/o7RqQtz2CTnTPn6KLP07CYZX3njp9x8Bg?=
 =?us-ascii?Q?9U/qASFrWgwJkhg6g9igV/H5IfjHoC1+gtRYgFPx?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b1401f0-da71-494e-f947-08de10f29c57
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3613.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2025 22:38:53.0600
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QKsYb5Gf8RldHSfE7ZJFYtohxR5IHocetgIHiEM/c3p7ozWNjvz5byab8vKRumaI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9330
X-Rspamd-Queue-Id: 61BFD80007
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: wxhtdhbib6zg9zeakinayy3m8cna5gjo
X-HE-Tag: 1761086337-855236
X-HE-Meta: U2FsdGVkX1+P/j+dwkb3ev03Ya6pt44u3Wme60Zj49prvF1xxiDmD625Zq8LoEDvs5nZU2skcIOZ5iOHFWBiVywF+bNKy7NRtiEQwaz1uxZClh/S/p0l2JU35N0iY/LMRiYlPP9gi1sfXQ7W6Xlj5r4kJtnuGM0c3jATTJTLNCw6K4V5dD7sYdGrctjfz4hRxtDvZO9bHbkYbQLMWC1r6i3FCvFMeE1hYLEySAalcFbaO4H7y++mHfohXPBdWeOxFnnIrDkJdWrhZKh9bwt73Y3zzKN9xIqaZE8pBjAA9mO6MmIBshLqv4A2eUZQsDDE64nxrjifqD7uW5s64Wxg9dwTkhhs6ccaX7iHf7PKrEJrpKp9ENPz1CBDDJkmFacY4Q5i6OJIBRAt3yNgckbHlDyvRe7A+ihrbt7b3LIKniv1vz0HOdQk4P5tKfG5YWkWHeArwXXUddDyixRIb++t0Bz7vRo37UlUo53HEvMMmiCJIpCgjiEYkASSiEGU+dBd3tzcXmeBJnuLpjv/MN326d7qhkngJboo0ssFGEHWEPRBWhMTBW9AtV9eb6DzVGtggeDCpLvEfeffIthQuMxnnNv1+JNN4yuAzmyQk2aalvQ0rz76OVNaJR/e4Xv0Ov64Up+G4JxeQIC4O6eErDPq1RAd/UK9Xfaei3eCcmAIl31LAG6KdaDeABzIPK3tXmE+1Ke1kbN95jiRU980cUrMgcKhNduTed5aVn/Bj+J7RzVSr769X2QG3hgeSffW/UKKLo8qyrjme02RVv63kP/xpZcLrepGH+CIGKO6b4RYnHIJQW1XH8CVGMY25HoEX0/giG6oa49f3FzDP/prZ3qvAdSdNLk7pT9TBHOBY4lyM3sEOXSKANBbwyRIfBOvhaNfvC0INizXXuw3HfnQEWqEH8FY7lhVQ55ojUWZZvS+ufWPOEp5WS243ndgcgfLz/Ei951xyvX9zOoy0Ui9K+7
 LkdrF36g
 U7yfY4pP5qC+ngmK6jZ+XxdlVV1mHFvATC7rK1Yy03XgLa6IUPDT8W31CZUD4km0c0TXHQqG51aLk2ysCFTa74yEGjyovMS39zzr4XxAP+21xG642UX1R8NgKjnrO2EwJjcbX9p6FhZA14/y+IkTJux/uvWVfODg+txu28MKANcVtfbZAQ2Q+c1VmBg/C+YlgVWPDfYzB9GvZwjJotGvmveSoqk9+SxoVfPsyr6jSqPVWqoxnwtlcj/2/QkK7/MO0eUBlsnA5a53VO3FLoL71Sjl8B5GukrkOMJShvcU1s1siX+YnigAgM/vic43Q+Q0ZcVER6Ud6yT5E915CupGGMlH3iKHZm4We9/Ais7YHGV9DGv6ncDt5Oe8ORXwwlz8NWbHktb0I2SXQt0dCwT647PlY/5rLplgf1XEIROQbVv1jjQCXQk3Jrq79X3AublFuajT3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 21, 2025 at 02:54:10PM -0400, Liam R. Howlett wrote:

> > > Surely it's not failing hardware that may cause performance impacts, so
> > > is this triggered in some other way that I'm missing or a conversation
> > > pointer?
> > 
> > It is the splitting of a pgd/pmd level into PTEs that gets mirrored
> > into the S2 and then greatly increases the cost of table walks inside
> > a guest. The HW caches are sized for 1G S2 PTEs, not 4k.
> 
> Ah, I see.  Seems like a worthy addition to the commit message?  I mean,
> this is really a choice of throwing away memory for the benefit of tlb
> performance.  Seems like a valid choice in your usecase but less so for
> the average laptop.

No memory is being thrown away, the choice is if the kernel will
protect itself from loading via userspace issuing repeated reads to
bad memory.

Ankit please include some of these details in the commit message

> Won't leaving the poisoned memory mapped cause migration issues?  Even
> if the machine is migrated, my understanding is the poison follows
> through checkpoint restore.

The VMM has to keep track of this and not try to read the bad memory
during migration.

Jason

