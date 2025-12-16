Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71705D609D7
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 19:01:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB71E6B0088; Tue, 16 Dec 2025 14:01:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B986F6B0089; Tue, 16 Dec 2025 14:01:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6CF36B008A; Tue, 16 Dec 2025 14:01:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 94DEE6B0088
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 14:01:42 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4EF131607C3
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 19:01:42 +0000 (UTC)
X-FDA: 84226253244.06.E3BAB42
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012009.outbound.protection.outlook.com [40.93.195.9])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7F10B12002D
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 19:01:39 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=f7OkW+kN;
	spf=pass (imf29.hostedemail.com: domain of jgg@nvidia.com designates 40.93.195.9 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765911699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eZjSg7Avf5aj1BMMM2sVXbHQTYZCCD18bj4EIKEByMU=;
	b=Y56DHGAy2C6N5vess+91jpeElg3kFMRlLTLXkfxChep1oyf0+uP/UnSIjGf8UaQ4xEV7ii
	UjcZZrw+cNeQC6WG9vd6F2tRGJavhrRlsyVylLT2ZO9xCTx8/VTZ66O6AtPX24Il0U9B5D
	CPMd8ri6H2I60NYKJseBEtDsH5epyx8=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=f7OkW+kN;
	spf=pass (imf29.hostedemail.com: domain of jgg@nvidia.com designates 40.93.195.9 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765911699; a=rsa-sha256;
	cv=pass;
	b=KzEk2i+TmitnJDPI7Ubi3MUf6pWvAQYcVoWwpOyXVecnAyRI0Alj61rpBMjE/pi8TMYW5W
	EglJl8NJ+O8TSOQLuNHS9ZMfl/5DhUz3NtmyfZtPsf8NE+k9xC4VmskRA31bCJYv27njgt
	5HaILQOrUHN3uMGn9lzRLNixT3Oh8nM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PKC9W518iZWeDMi3hOnFQhYO03QJjsKJqgdbvZCz4mULtYUb9uzxDuZIXtAZB3fTp+wb4MJTUTDCHPiuXjstjbHv2UuhBw85+w5YqIs9chJVqiRr0xG3MTisAnSSKdpALKJUnoWpJcRP9NRU4y+MrcYIOb+QKRievpbP57E1UAtslmZm6adIC/T1B/y4OpqDmDIZIUwRcxLm1fjCEyXg0h34TekaYThbJh4jrwDgvVeAKNmElTGs9+ztWUiLTETGSq79090hoYwY56u3V2W3UoGxcuHq7fNSb5EGylQL7pc7RdEm9lvl7HHMIXN6E4eOFQm4+vWDrFugl8Tceg//qQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eZjSg7Avf5aj1BMMM2sVXbHQTYZCCD18bj4EIKEByMU=;
 b=MkKvQ1v0ApBxhzE7AwT4yRtq3LyzZv4cu/hcgsHhFHdOcYFp375+TFMMiPbwjguhBo26XtOxz3Oab3dkqbMHxsjpJtDDjOSCJ494XK93xvCbgrKa3vOZxCEbirs8cGGHQibgDgrU4Anp+syfyYYwVjzucV6SDeQlLDqcSlYkKmBNkOkuEOQU8zSb+c03Eo4KbsR4cyj3kFT4AuBGqgKiD0A+PMCzxlJBfvfxQ6/PrUlXQ3Vo4QwImH/LUCT6cbMwldiHrLoPhRy43egzMFdb+d46OY9thpluMOur1XLfWGWEpwm2KAS3MMM8iOR2YX/4FB41D9PsvccvspeZYFheoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eZjSg7Avf5aj1BMMM2sVXbHQTYZCCD18bj4EIKEByMU=;
 b=f7OkW+kNmAAZBpHc7gbhhHGMquOfi0lAuwTcFsZhbrIbT9D7A4F8Yzp8q7Q0l67K44gDVEq4euRWcncx88371mUEG8dGxLGyYWBn/0SrVOMS74qErFqY2rGRQYt5EOkCGIaoKtZGyHevL5UCBfEvU5w9zGJA7JsrKnFD+iPBEMt9lj+xOVuAjonVJPrA0vgufo81SsBOcTUIB0fLg8CLCnfPsFZFuTNWl8Q2hCNWhghChzsS2sHOiB0GCltVMO7yr0ltiO9Ai5C88aHjVgjWjFwfQFA8DjiKCCIOkht2F9AfIuroRUm3k2okSCB5zGtktqMQUNZ3+sVhWcGjhtdJNw==
Received: from CY1PR12MB9601.namprd12.prod.outlook.com (2603:10b6:930:107::16)
 by MN2PR12MB4237.namprd12.prod.outlook.com (2603:10b6:208:1d6::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Tue, 16 Dec
 2025 19:01:34 +0000
Received: from CY1PR12MB9601.namprd12.prod.outlook.com
 ([fe80::cd76:b497:475f:4de3]) by CY1PR12MB9601.namprd12.prod.outlook.com
 ([fe80::cd76:b497:475f:4de3%6]) with mapi id 15.20.9412.011; Tue, 16 Dec 2025
 19:01:33 +0000
Date: Tue, 16 Dec 2025 15:01:31 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Peter Xu <peterx@redhat.com>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Nico Pache <npache@redhat.com>, Zi Yan <ziy@nvidia.com>,
	Alex Mastro <amastro@fb.com>, David Hildenbrand <david@redhat.com>,
	Alex Williamson <alex@shazbot.org>, Zhi Wang <zhiw@nvidia.com>,
	David Laight <david.laight.linux@gmail.com>,
	Yi Liu <yi.l.liu@intel.com>, Ankit Agrawal <ankita@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 4/4] vfio-pci: Best-effort huge pfnmaps with
 !MAP_FIXED mappings
Message-ID: <20251216190131.GI6079@nvidia.com>
References: <20251204151003.171039-1-peterx@redhat.com>
 <20251204151003.171039-5-peterx@redhat.com>
 <aTWqvfYHWWMgKHPQ@nvidia.com>
 <aTnbf_dtwOo_gaVM@x1.local>
 <20251216144224.GE6079@nvidia.com>
 <aUGCPN2ngvWMG2Ta@x1.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aUGCPN2ngvWMG2Ta@x1.local>
X-ClientProxiedBy: BYAPR06CA0035.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::48) To CY1PR12MB9601.namprd12.prod.outlook.com
 (2603:10b6:930:107::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY1PR12MB9601:EE_|MN2PR12MB4237:EE_
X-MS-Office365-Filtering-Correlation-Id: 409d1458-100a-4390-bd3d-08de3cd5872c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?jvrsH2I5aLMIlMtRmAYf2072t9mrSrUYP5WFKjk2EDjobNxCrya24sfky0l6?=
 =?us-ascii?Q?BqAhr3z2igEps5ws5dez1CVe3QZor5Kp2bON5XPtfx6ZhObFyPTd5++yagKI?=
 =?us-ascii?Q?H8Q9JoH3EgUYrN23trXGpjmi2O0e7KIZ8MbSnSWJAxh46SRnTrurKjZzL+mv?=
 =?us-ascii?Q?EL5VIG5f4rw6keO0y8JAguO6t+x2wcdFffU7DZDRmdbWR+u84K70gLiwA7gR?=
 =?us-ascii?Q?NnKgpe+nUY45K0kQ1vbAzt6q3eV4+ZtIG6cseXt56jSzFOB8B0ZSFCCXxmvw?=
 =?us-ascii?Q?x/mPZ8zX11Q7x/d5GJ8PUloZX7o4m7bsGlM3xXE1W/gArrkPUiw023sj8Q1+?=
 =?us-ascii?Q?rwjJqt92DCWQcgby6kRBibYG4FVwMUk6BbqBaGuESXLiO9YLSideOW0VuxmW?=
 =?us-ascii?Q?zJju0nB4Itdzkp6XKXekEY6QhwdPwD4lR+4KfE7VZiHMSfMR0mN9F9qMjIej?=
 =?us-ascii?Q?gteJQ8bo9zdfusWPaIuv64+MEEe9s9700wE5TyJzvzePdCEyPNPAjeKqmQos?=
 =?us-ascii?Q?HjQ2z0q5CsHWrjxi8FJP4dOA0qQ1uWvv0VZffWQBs+wBzgYPey0ZJvg4ygpR?=
 =?us-ascii?Q?UPMUdxRAb3dkkYh909ICv+ru/K4oDKw+bPj+g6wiFqIy8FfeQeaf1qt3yCwm?=
 =?us-ascii?Q?aP96VjyMjEfAQyCKvxk8Xmd+8nmzHmh73mxJf0NsOjjMl2BrsIzlULJYfFpD?=
 =?us-ascii?Q?vP2+ky0uoJRVmAmRdEuBfmiD3pbFdd408YANF73WhAmG+PWbrAKHcf/fakkM?=
 =?us-ascii?Q?vHx8nrH1mVnJKJ3fwnS0ycDcm6AoGWHVoDOpGrOHnaMD9boHdaxE3HWZIGlx?=
 =?us-ascii?Q?RnOfW6kB+WREhTWhbUzxMvUsaltkIygjjMSbYDG2mRv/BjGbmUhZ6V5TsfLk?=
 =?us-ascii?Q?4ggJDJZgOvR8arrC1+ZVI0mwVhwsgH3DTu/ktE57z3H2adkL639s2ZsXD/D+?=
 =?us-ascii?Q?mHrZ11d5A+tP6qH23bopAdxWqHzM8B8Zy8/uaz5DBzxxFoHbacqFplwf8BS8?=
 =?us-ascii?Q?oWWRv5H5WnaTBOizqaxJGSLBko5vtylWpwxO+TKruG74Zd/btKOAtBXxipIy?=
 =?us-ascii?Q?uFBPMM8R9x5nf5i8qLaSv/O7ZQIin8J7dXxR8gbOmjP+CUTqrn0XUrFhH6C9?=
 =?us-ascii?Q?xU0mTvkoTsTRoziGJTJ/37B7J4uJiv94vTo+s8Fn31Wthoo57MVZmBEM3CeQ?=
 =?us-ascii?Q?EFPoARz/RZD2QPk0j1ChJXREzpIP6R9euYIRw9c8C7hQbyNmTs0pUaaqJOYu?=
 =?us-ascii?Q?28nN5TMQm80kxOzCOyi+ivVVNkObBzYkUqivYReEaJehNsP4yQThaX7I0u6d?=
 =?us-ascii?Q?ELp3s5Vm0dWMJTPtQsjtnP4ydnhfzXbD/cpkNANDJsERUy7kvuEzkFY0NyTc?=
 =?us-ascii?Q?XorpkyfuLphDCtpDAyiIJTLKepO7yT840L6VPO+cJ2RUQJL1WaQgfDbO8YfX?=
 =?us-ascii?Q?kGWeJGM8u9KtpoG9SdWrXheOfgSq9qia?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY1PR12MB9601.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?iokox01+gXIPf4wLk/Pe1wVBxwuW9TiGSWw43VG1kf7NlpPxs4uwNiEpWY+9?=
 =?us-ascii?Q?ZHNLd1x3PnWNnUxQ19lfhKxCd84LUTsjAme9qgiqr2UNOwRADDmoE2yTAnQW?=
 =?us-ascii?Q?k4tAKxnAAqJ6gcytH1KV5cULF5ysW8T2ChU8ZLFP9ObcaSDJowAo5INJpwUb?=
 =?us-ascii?Q?VssPYqmZ3f3h8vdQ+W/Bw74jDTymqqxoOKtiyY+pWMJ6zummIRwvykaNwTjo?=
 =?us-ascii?Q?rATxaeXihOS4vdbCSA34igHaoA+FOBQObwY2ZarqEVUf7EGVDwuoWD8OSkeo?=
 =?us-ascii?Q?TWsTf9NwjDHZK02LWezd8k/8Qy7GmX7lP0rQV25E5kv5uJBto2SdjafZ89l/?=
 =?us-ascii?Q?zc444SyH/1N5AAazQdc5SaqMW194waUCXwJNJjam3eodhW3HhDUG1ECVN59r?=
 =?us-ascii?Q?p0OHIyuuyvInCRIO+PsOtfCX11XGfcPR8Fw6JirTg3BziMHxkAiOGlHW8l+H?=
 =?us-ascii?Q?2+2J4faExEgf3rf5FHdirP4I2jZ/oVzjmNnnRJeFZXVSEnofV6Zy+vuqTN5l?=
 =?us-ascii?Q?5wT03u57TmTwpe6L8a8MjRzIb/zOSLLWXhVba4QXMwAit/qYxBCoRQKxc9GT?=
 =?us-ascii?Q?SNHa9tpZ24dfDTjJXVohVkyhpcI66p8c4zSB3lf/lFexZqfO2KmRDUAnD2Nm?=
 =?us-ascii?Q?BcpaW2qncBXqJyrHJ0hRyROku8qSpeMCyB6LZai3u3oVRz3aOJtHkgk6VU6a?=
 =?us-ascii?Q?oA6hSLcwbrOjQLNdxCUFaIGL7fMh3oEo9O71MrmgdH8Mx5+1hS1vZ7ckaihZ?=
 =?us-ascii?Q?2y8faWJDfwbiY//WW1RLpTqcCD2Na+SDqRvsbvXOBIrq7dQvwDQk2t5W80nn?=
 =?us-ascii?Q?AGjGRlmGEBtdkQIAd9fUMWz/1K/vVrsPcMZrStRlq65ftF4dKdHM3tHQN4Zu?=
 =?us-ascii?Q?CWoBp/EZaA4lQQNVNJednaJh/hfoVJPWLZ0hEi1JPe8pf3sz5EgWsFDHA0sw?=
 =?us-ascii?Q?NjjUY9Y/HQaLZ9BudaaeoGB/Ny80AmHiPHMK0xN5yHH6Kk48rCju5cEUR29V?=
 =?us-ascii?Q?UM+pldKyvB71hBPSujugpH/Wo7OatmG7K2bP/n+5b6azna8s/YWauXyvHS/C?=
 =?us-ascii?Q?zpo9OQuit4fNYIp2sypswf3ok4lZWwAA3W/hhkV4wWXnTM+YiGbqtSH8aTUK?=
 =?us-ascii?Q?gXfz9vlMuW5pcywbeIZuFgJJbsZgC8yThcnP2VmShOU+1wkHaD8xRQDkuv2I?=
 =?us-ascii?Q?Wf2f3Zwonwjm/gr5npbZRtaRBM4B53BEvFx7MNfUyFicfUf9zK/vF9zcvajd?=
 =?us-ascii?Q?Uxl1+JaYAjF9ElssyLhhEf8/iG1mJ+efEpgKXtebeypIofL4wtcB3zeLsMQe?=
 =?us-ascii?Q?uJF41Zboktx/Iee1vxl/D7Bj02/ekSoQthQYM4GP7/YIEh8T4jKE0VqzAcrh?=
 =?us-ascii?Q?u0zReVYKS3VcbQgkD4EmBEa3VuceaX75xrObEbcd9GWClKvlLmlRP6Y1eHJX?=
 =?us-ascii?Q?qRNNA1xB81oCvWpUN4p9OOebFf5Agui6/UFpldIeRw48B1bMvmn9spzkqyto?=
 =?us-ascii?Q?QSUba8R4061GYTknnB+oh+iHWgbmO3niHiyOQFz2tNOskq3vOT2hUxIXln37?=
 =?us-ascii?Q?/jCDn2XqS16y3dAFkq+vcc6zC8y9SbHqMX/YpEyN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 409d1458-100a-4390-bd3d-08de3cd5872c
X-MS-Exchange-CrossTenant-AuthSource: CY1PR12MB9601.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2025 19:01:32.8909
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Adq0Hr1f1OFf5xiJa28eo7LrkbLr2xTZqNPv+zM/LAF5a0T2DXgGIo1QKEILh+nT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4237
X-Stat-Signature: mr36qqzn1mf7nrsdqm96eehb6wroffuc
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7F10B12002D
X-HE-Tag: 1765911699-723935
X-HE-Meta: U2FsdGVkX19KePfp1u7KbqwWJmalkB1ev/TdmdfXP+RDzQ3tyQ3hfnBQ4qrZj6zpOpM1akJQmLoKYmDwZhBMQmCb9ZH8ZtO8MwEAoYXbhGB3o1Rbk7AYNJ3qAH7p3eukdql39PKtkRJ/n/4JtkYMi6OBL5Ry1OsfLFEXGlpJXBai88iRcLc1+ap9J/KFBVesthlZGGvmaGdMKHTTr3TgU3223oY+lah7vkQgdO28It47fDJcfzfbXnaxcBzjquatWziv0OksVtrbPR53rO7iVj9Rwlb+lVGA3f56GbtP0mgKIHhKoOc+2Wf8UTN30oEv3BffQmMJRn1AUC0QxHEC6e7E3mSTvzbuWGvBHsDGYjKvizYjiPMrqlh4tbs3AsiEHyP3O81EOnMa4qo9eVbnJoFULp3PdI2n1GoEUYfDOHTKrtb+QCjrH1EIHqpCK05KyVWMFQWq/28LTrQ7N53vVMZ/mXCoarB14mvF79PxX+76S3cUbzaaOkyKsk9e1Fqg8Mm1V+bUcFK6Cl2+3/KVkZkAXZlY9v1bcERiiH5HqGe6Fp35PPofs7Zw/ww5f9IvPH6gOtMGyPUFQjRESrI91m9pXn2kqOxQb39RtQsUDbRiD4J9+t5AUt4mv3myevM9epT+nttwrC6E3evddtJHd6RWebuQDea3Rds1IER2tMpwNE6og7EwA0RrePH+BlXfiDNq5PpdSuyAG/3jlhMMOicw2kbDsIW7dpAZ1IZMLfm4b1JF6b70M5XkHdV6/scgysD7c0LaHoxHjJvSiQYSvX5eFQ+lApFNlhX/DR6f0/qKO9JJpPxTykDHLerBmR3ZvV0XR202GSod9A+7Wa8SOuL2SBkxjfPd+ZdzCRUJGs1O1QXfY2XuxSl+G1iB2uhE5q3b/7aZjKnwfPBgOEbwz6dQ//64o8jCGwhoexw/I4sWoKRz+apPeRdw7pVluZW2F5W+rnSKadsXtsdC/ci
 tUlX8s1K
 pm0F0OBHsO36AsHhYwmhcaP3tjsN4pQI2E7JZFitNXeI3RDhyFZdTMG0Tk/W6XCbg9bWvI1uXA9noWtdZqO4J4dnkkcEc0b5fq3FjsA0DrDM6dJPBUCr9DJq4k4tQBfrhodciQaypjBfvLFvczDMzl2H2y29awhGFaI/dy+wLB+igKHOIZZXLG78UDb9gWRf2fkZOPwewzNKmJWfS8X0e1rPMu5WYLyqZlEWdPax9x2a6scwm/9ivAyFVxM+aMInCSA/lTefXS3spFjGr5zrjt5yujOf3fTy4YJpap8BvQr9wVoP1bv/NT0bJ9CnV2jgOfQf2NWuaJLy8dp+uzufFqMPLnv4tDFqmS8coUBcWE6anKJpzWT4Mc6JpHJlDKUz+eyXLTWdfBq9zFtb3rBtw4jZB29uE5EAmdxV1onI60MxBNZ/FqY0h5XVJBVMlHCNmwshXUsioyNg77V8iwNZnnFiUzigWnCWftu2AjPfD79Q4xtfS2DhwxWKFrZZisB+w6k0gsntw3okfx4aWyXP8NpLqXchmM+XeIS6d7CWP3xDl9pKDsgqwuUdRr5YAuLryX4vj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 16, 2025 at 11:01:00AM -0500, Peter Xu wrote:
> Do we have any function that we can fetch the best mapping lower than a
> specific order?

I'm not aware of anything

> > None of this logic should be in drivers.
> 
> I still think it's the driver's decision to have its own macro controlling
> the huge pfnmap behavior.  I agree with you core mm can have it, I don't
> see it blocks the driver not returning huge order if huge pfnmap is turned
> off.  VFIO-PCI currently indeed only depends directly on global THP
> configs, but I don't see why it's strictly needed.  So I think it's fine if
> a driver (even if global THP enabled for pmd/pud) deselect huge pfnmap for
> other reasons, then here the order returned can still always be PSIZE for
> the driver.  It's really not a huge deal to me.

All these APIs should be around the idea that the driver just returns
what it has and the core mm places it into ptes. There is not a good
reason drivers should be overriding this logic or doing their own
thing.

> > Drivers shouldn't implement this alignment function without also
> > implementing huge fault, it is pointless. Don't see a reason to add
> > extra complexity.
> 
> It's not implementing the order hint without huge fault.  It's when both
> are turned off in a kernel config.. then the order hint (even from driver
> POV) shouldn't need to be reported.

No, it should still all be the same the core code just won't call the
function.

> I don't know why you have so strong feeling on having a config check in
> vfio-pci drivers is bad.

It is leaking MM details into drivers that should not be in drivers.

> I still think it's good to have it pairing with the same macro in
> huge_fault(),

It should not be there either.

Jason

