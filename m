Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 726B4C9830E
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 12:47:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45C216B0088; Fri, 25 Sep 2026 08:47:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40C476B008A; Fri, 25 Sep 2026 08:47:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D3C26B008C; Fri, 25 Sep 2026 08:47:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 06A0B6B0088
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 08:47:45 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 911F11C3368
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 12:47:45 +0000 (UTC)
X-FDA: 85252261290.12.B6624E1
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012026.outbound.protection.outlook.com [40.107.200.26])
	by imf20.hostedemail.com (Postfix) with ESMTP id BE8E81C0005
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 12:47:42 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=qFXfRGIJ;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of jgg@nvidia.com designates 40.107.200.26 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790340462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UbB4+9/cozYapayJ4Jqz014qOvCBTPo+sRJasXirSnw=;
	b=7NFwReoW4v6KNLZqTnQtUNChOHcj932gI+nbK5I5QYaA6bmXmbwIGl7kfavE+01HPL49C7
	1IJlFCNnJM5fGlV3fBmathMqdyMhSd2lmmJj7sP7DFG7siI7hAA1rwgqQFD/hOBt8Qdt53
	qYUKmrbtRDtP9mG1yEDCJqN+iC3tH2s=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=qFXfRGIJ;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of jgg@nvidia.com designates 40.107.200.26 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790340462;
	b=igiVhH8o0Ii24XdZkJdgh3hu/333BON1A+r9EMx9jcphzlEgm0HtGkeoFVjQVAerPr6s+L
	Yt0ROpooBNm5CGdQgZXPdwewP28LkwwVUaFzcde2e8+eFQcc6W/xFfyDNvJSXwYoR0nSLW
	gf26VV4lrH6k+9qOoyWpIHR4G4gAM2M=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RWKPLmMKnNbe9DKhWwfKPkb/vCuda9ajWuKfQv7hrMEyayaXpXBnlDZMyv2joh2dvIcsAUBUu5M7XKBq2C1GGtLD32kPZm7xUQzR+SrTFn0qLKwqwHSbAOebv2Nu91xcIuYbXWFr88mvQIAzNm4E8K7ztXS4CGzyJcVNBNW5qA/nDPAtx15abqKt/GmQQvZMAMz/MMu2GDlZUYST0JI9LiHlKZSuUYt85nNFAu4il9sKEWvIHyiD5tT5y2uvzAI8bxG4aAqlOyJOfX8l89O+ARJ5m1+l/UtQvHcWEiBvxLsLr5m/unKZL3IAI102fREITLK2xE0aJ+rufdUj1wlqyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UbB4+9/cozYapayJ4Jqz014qOvCBTPo+sRJasXirSnw=;
 b=Ra/b2idDxK4vHTGQKCypsqjJEGp6fghzPiWHV6kvmHoh6WbbdbQJ/I6O2kR4GsOQf+NZ1aDALn1dk+ruh9CB5yNeE230pWqnUoc+GqpsJmU3wgVgmFk4wXWkpvzaQoc/ACay2+eEgt2+O9M1/g0T1mscYIloM5+l0AHfNGl2EWQQnJCyJPVetQn+/8TMMZ0ruHFeuepgjze+0yehk3cOt+9dOb3+sdsET/5S4d4IpMu3BmnEondtI/yBxmSlDVg5EO+QjW1NN/kWDerP8B0J4zKw1Oy2GS66xweWYBsUXf8n3vHXU2Gx5RPKtxVb2wRgcyNKLf1f4iGhJjZgvsfXFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UbB4+9/cozYapayJ4Jqz014qOvCBTPo+sRJasXirSnw=;
 b=qFXfRGIJHy0pd+WdHOeUUWa9oeG+fQno9kF2UIYebPl6+Oy7hglvIKSL0Jcn1vR0Dh4y4qP1+Qll0Y2JUFPhcxlENXo4COJjoqJf1cRt+t0JNleVydmTiDSSLqX54pMrTVfnpU4HXZBVGUxv6SCr0WxgISmq6bw1d91hGtCHl1kqnvWvLnQrQloY+Xf5DM3jXzhQb7HSMa8y4EAUSfAt3SL5fTNOZBaZc9+9p0kFaEYhLIl/GbgD4ZGljPNBGRADav5y5JYdDOU99LoDRgCdirPewoIDHSy0hmgTkAF9R/PX0E9hksi6jW46YwkTqdSB1a11Jta5lqKMqS/+yjyQ+w==
Received: from LY0PR12MB325698.namprd12.prod.outlook.com
 (2603:10b6:408:3bb::14) by PH8PR12MB999319.namprd12.prod.outlook.com
 (2603:10b6:510:40f::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Fri, 25 Sep
 2026 12:47:39 +0000
Received: from LY0PR12MB325698.namprd12.prod.outlook.com
 ([fe80::b65f:1548:5b35:e2b5]) by LY0PR12MB325698.namprd12.prod.outlook.com
 ([fe80::b65f:1548:5b35:e2b5%5]) with mapi id 15.21.0451.014; Fri, 25 Sep 2026
 12:47:39 +0000
Date: Fri, 25 Sep 2026 09:47:37 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mika =?utf-8?B?UGVudHRpbMOk?= <mpenttil@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org,
	dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org,
	linux-kernel@vger.kernel.org, David Hildenbrand <david@kernel.org>,
	Leon Romanovsky <leonro@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>, Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v15 00/11] migrate on fault for device pages
Message-ID: <20260925124737.GL9354@nvidia.com>
References: <20260924065313.899730-1-mpenttil@redhat.com>
 <arY5zKsLuf7f_EYw@infradead.org>
 <65c5c412-56a7-46a9-b22b-22077a8e9727@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <65c5c412-56a7-46a9-b22b-22077a8e9727@redhat.com>
X-ClientProxiedBy: PH2PEPF00003848.namprd17.prod.outlook.com
 (2603:10b6:518:1::65) To LY0PR12MB325698.namprd12.prod.outlook.com
 (2603:10b6:408:3bb::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LY0PR12MB325698:EE_|PH8PR12MB999319:EE_
X-MS-Office365-Filtering-Correlation-Id: e2eb7730-3fcc-4a33-7e03-08df1b032ef5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|7416014|1800799024|56012099006|4143699003|10067099003|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	X7qyqQS4Oow0HlOco6BtoWzyhKSlJBbO4c937mjZfkhtOme86TOzq9UMlUIxSerTx8YtT+Dsl3pQXd3morWNMLNm3cYWqJHH2YmcFgUVkcIEiHfCZPB5hlbg4sQbEg46oUeih7UUEcR7zFVga8Ulxd7+nHPLd/wyOTevSpEOxDJxAmn1XdyQwzeTLJky0kDP7fvmEmbHBlas88i4oiY9tfmcGjQ+AC7Y8juXndiagzID1U3ixB6z0+MElIDlR6zPR6yPV24fLF6DjP/jdHkB41FNWHVHwitfB7Kiu1WBHKd2bZfdx8AbCYrOWFOK2gmIA1WoLkeDQEu1cfuAskIpEH1NGDS25pMvDc2ZqdE+TGFdQOTKItCkG71R91S8YOZ1Lw1YrQqbg3m1QqdWClxGP7+ZpDdZHNVRxCiTTISkn55RPk3/Rlvogwj1o/GEAtY41bTfScS89jafgacCdwBkzmI5uHqM2uLWI8SavP5CJRVX6VSBoTcYyiIg8wz9WKwrtRZeVexDKfpyLwgtaW7Ej6bvws41vQ5WmNJ3lP7ncLURdfhWvYKsTXjBhkLd5rD4lESA6T41wufY3sgGoYTueysuvZajZ6YmbFNuYH+DSSeyhmNCjSExNuZu1hSK81T5bsDDFfe9BZ3byPRpwwM6ZOMNkS8f/2w2djb/FZ0PWlo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LY0PR12MB325698.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(7416014)(1800799024)(56012099006)(4143699003)(10067099003)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NzJ5UFBXT2o0M1hVdWUvd2JSbDkxUXZnQVBOc01wYmU2ZHVqM202cEFnaTE1?=
 =?utf-8?B?UHZYcWR6a1NxQUVJWVpuNlh6R203RVJ3UzZya2pNbVZrc0FETGlxS1hJL05M?=
 =?utf-8?B?dEhKcElCRW9JNTVVeGh2QTRaR0lQL2UyWk9WWEw1emRKaC90VCsxTElhY3dX?=
 =?utf-8?B?d1FzUG1JeENBeWJjTjJma3ltV0FQMFVFRnQ4cnF6SWJqaHIxQTFTdktpVHY1?=
 =?utf-8?B?OGlMeDdqTnA1R3VZcDZQTThESys2TStIanh3U3FpYVlNR1RlQzA4ZEFZTjlB?=
 =?utf-8?B?OEdmTWxvbHh0MS82RTYzMU1CbWR6dVB4by9lS1IzaVh1cFJOR2xEc1I3aEQx?=
 =?utf-8?B?eEFRbE5FSmdmRGZKbU9QTGpXRmpCT1JJQzloaXkwZ0ZtUnI0Q29uT1ZpZ0U0?=
 =?utf-8?B?b0dZVDVQUEZpVTdFTlhtZ2djR0Z3eEZjSWJDS0NIaWhqWWVVM1ltVk5HWVpM?=
 =?utf-8?B?d3hLWkNFZzlxb1NycDNpaVlJQlBjTmk0eFhjek5sS3pSaGlOU05uWjNHemIy?=
 =?utf-8?B?b3d5VjYrMDlsOEp6WlFDSkZ4MlRGZGoyeXNVKzl3TG5GUjExdzZKY3FQMGlG?=
 =?utf-8?B?RlB4VTVwTU52RHhxVU9yT1QrcVhUc3FQZTlvSVNkci9obXVPMW1rd0NnQUdX?=
 =?utf-8?B?SVRRRGtsZ1FmUW9OS091Qlk4ZlhJdG11Z0MrUTY3SHFGUER3RjdUU3dnZWFl?=
 =?utf-8?B?eExjdGU0cWpydDJ0aldxVGFUdlI1aDlQa1UwVVVxemVUeGUzSmJYdlNrdUR0?=
 =?utf-8?B?ck02SG5Sckd4M0IvU3BuSmxqQXplL1NJaDQ2NjNtazFrTFg2YjNZWnM4MUFp?=
 =?utf-8?B?eHRKQmpJUUp1ZnV5SFV3d2x0ei8rUGJBTmZMMFhmRzZUUjAyRktSOEhkeERh?=
 =?utf-8?B?WDIrbWh2TVQ4d3llRG9LSW92TVdJSlV6SnBlMUorTVlOcEpzUndqVFF3WVNF?=
 =?utf-8?B?RUJLZFQwSEZHZ3ZQdURRV0ZDSlk1UFJUS3VoZ1RTNFRZYzR6Y25PelJEVER1?=
 =?utf-8?B?dlV0MHFndmtlelRveTU2V29xOEMrVUhYbjFoTThoZm9jZ2laMUdGa2NwS1lh?=
 =?utf-8?B?eXZESzErMFJYTXJOaXdkUytZRitTdWd5VTM3a05McDY2YlR1NDhTZjJCajIr?=
 =?utf-8?B?YXNudDN4UEltNjJsR0FxWGpNU2dTclRCTnlkeXNYeitRcDBKUnVSb1M3YTJi?=
 =?utf-8?B?M09nQ0txRGU4a0pDclFnVEVETmE5ZmxKWjA5dXRRbHIxTnJpTml0M0lDUk1U?=
 =?utf-8?B?NktQS25uSnEreUN5eTk3aXNYRmpjRmRkT3VNYkhTMzRXRDJXWDMwdUdIeHZ5?=
 =?utf-8?B?bnBJN0VkRElLVEJubjBpSkpZaHhhMWtsSXFYVDBUbkEvY2poTytlSXpaWHdW?=
 =?utf-8?B?OHNEMjZrb3I0Tmc3UG9EcktaUDNQYmxSTjBHREhZTmcvVkphN0NydkNoemNX?=
 =?utf-8?B?YlRTRmVkT0N6cVI3VHdxL0c3d0t4czhONnRNQ0RjaG0zOVViRThyRVZPZXZh?=
 =?utf-8?B?aVovRFhMQkppeEk4SjFaUndiSytURitLZjNQL3EvQUpIV3FaTWtuQkZlem9J?=
 =?utf-8?B?WG1BaFA4WmdJRWRGYzA1Uk9GTEpkaVg5S1hCcXFRbHNzenJFYjNKbktoNkpH?=
 =?utf-8?B?bTZlTGxlOFBMNlJucUExNFE1b2VJVmFLSEJJTURmbVBMNGJuREI2SHJCS3A4?=
 =?utf-8?B?b2F3cmhmclBUQTF3N3IzM3Z2bzdvemlWNU95ampUeW9WMTFyYXlVSG1ENUd6?=
 =?utf-8?B?dWtldDNlTUFGVlkvQ25OM3paV2ZUTmZ6SXZmd2pxazBxaHh6TTBtOVRTQTFK?=
 =?utf-8?B?TEEzYzFGR2ZKSEQ1V0FxZ3ZTK2hHTW5HWVZuUnQyVEFLblpMUGx4SVBTcjBR?=
 =?utf-8?B?YS9MQ2dSclhaRGlBb20xNU9oTDRGYVBuTmttN2ZYNERrakszNlA1R1RvVWFw?=
 =?utf-8?B?a0J5eHZ4UnhiQVBubmhzWVpiRFdOQlp5Z1RUejRiZHM3TlUvcXlId0lrVjNi?=
 =?utf-8?B?MU9odThBRDBqY1FaZ1d6VWpPZXFMK1Y4aUYxQ2NNZUxiVG5WTHBFakowaVJr?=
 =?utf-8?B?eVpZVTFTN2k4MzV1Z25mRlhzRVdRV2N5YktwZEFjS3dOa1ltcjdKQ2NUYjNU?=
 =?utf-8?B?WVppOXVxNWg3SFhOUWZmeFdsRUhOZEtQaUEzeFFKKy84UXhrMng5VkpGSHRD?=
 =?utf-8?B?TU1pRTRydmtQN3NzL2U1ZFFKaDZaRVRTMFRLSDRKMU5WR29YK0VRZ1BBbVNo?=
 =?utf-8?B?TnVTOTZXcnFWMTF5UVNranZZbXU5amxGZzcvZjBPRzB5TlpjVmYxYklmSzJz?=
 =?utf-8?Q?ujMrO1eivdWJXENKh+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2eb7730-3fcc-4a33-7e03-08df1b032ef5
X-MS-Exchange-CrossTenant-AuthSource: LY0PR12MB325698.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2026 12:47:39.7211
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3kpiSoSCP5hEdH7xZrkZjIlkJ5H7LLt6vFqj/bMOLjsuEwX5AvWdF5zOduvbDdlR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB999319
X-Stat-Signature: jc5htt3oizoep3ae39ktjgz6o5miarmg
X-Rspamd-Queue-Id: BE8E81C0005
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790340462-781462
X-HE-Meta: U2FsdGVkX19EyRuGd8HC1nFQjq4MGOcLUqHmCAf62D3CosVkDuEXRkKwqfctHzHn2UpQanrhZ5D6C8koEXYIoc4SrKCxWbuob+nzH6XYn7AvGvOY5cUEbAokho9uu7fxCPlNRPtw/50uH/Yy1ezYnlwNLAVi6YCHtasZ6WhSvvVG58LYd5xfcatQmPY6UolFBLLf42okON37DL6P27qKgFHGUAuDZVVVlGRHrfHWDTUPIIvI/exPE1X9Zd0sPwtw5yVH0VjmvcPm40KWCxa+OonBUCjOgDBGSVJjxG0abByo8mhCwrrKcei7vIpoW1T5eJ4ZFldoSZ5qUbWo9REeCMGaRICv1HR+HN11anR0i/8Fdx9aOgsJlSdognInFI6C1RyrEhwQ0E/L10VymrHF6qsTlvutSbxOk6xjpDKixWhrBzXZ05FSBvM249uFujK4kh26g1FhexnBtoP8rRHOFp5FGV4c50JU09YjUh4Mw8HaNwPZBP1abYEOJ6CywvblG1ynUM9+cCyaiKkNA0rhI4MiJ/P1wZOEoT0Caq9n0zcnCZjYXFSqLJtDKtvB+Zvp0lWnBJ4QNYx7I6xQELUzkjKE8ec0FGAV4Y+oBZgt+aXso/CLjLkFjVP5jmbEgr0xS2oR49z6XOCBhZ+FMSsV2d7izpUXObPBfL4K7lIY/39uzKWjdZhBSMO/4M1vBjwM9gbiNmfEFEOcgRn49KvpEF39UcQiwfY62qsMz33zfDmim1n/VM0+3VxjtdkB/hbED3jx4mmzujSsXZTjfe4uh5ubvq9zgfXARSu+ht8gvXVRzVAZKGenc4UTeRS1yCxsVZ06jCAscc1OZCyzNcmjoChc5/Ojjoh+H/dNrkGwdV+7mMGJ6iiRHfWJk3OBst6YlTt+irf4yRD0Idr1eL+DHdgcngKuw750G70wxiHdyC6nVA06GggsNZmLNUmTdszZLKWczWafXo621x6e7TQ
 72g+I8Kw
 YXzxFRvMFds6wG6aM2qmcY52n9vuPishATp8pM47E8RJnpZhdKzQvnYYMgA3Ez8zX659EAhGTFERXnTh839TETadsJ3CPDyr9Y7I2oK/lSfiDJJKwxe1xZb67zfIbOtzeDCvgjiyleB4Al7iSdpCerGjyxYsrJ8gEi+qSVgWFmry2omTXs1QnX/y7+BChBFIcxUPDFPLMR0CNA4UhgpQuFVP/1E8z6uC9adGQHn4wCAFV3MUaDbf9Ppt8a0DjM393VDaNDVPayLgTBXzt25cSDDEoHWhzZLBAKHw3gshx2z8zCUwETn6LD7oV/oRLpgXwcc5PIMdYj7y6DrI1WdxjgZYX8/1TPyhsoLDyHgL5ZgLvUQxn+R4HwUh1uhGI15pjcCaUDb5mMVnxDkPeaR2yfZieWOQlHymz7125McexdCiVAl1zreS8s5rRcnKBI5vJLOttwLkxuKfNNvZImy3UiUjU/YfXUgNwSW4vcXNcFqC25qq4BDsCaAQgUu4ozDpnIYv6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 25, 2026 at 01:23:52PM +0300, Mika Penttilä wrote:
> 
> On 9/25/26 12:07, Christoph Hellwig wrote:
> > Who is going to use this? The series seems to lack an actual user for it.
> 
> Two users:
> 
> For one, existing migrate_vma_setup() callers, unchanged. The series
> reworks migrate_vma_setup() to collect via hmm_range_fault() internally
> (it sets HMM_PFN_REQ_MIGRATE and calls migrate_hmm_range_setup(),
> mm/migrate_device.c). So every in-tree migrate_vma consumer — nouveau,
> amdgpu/amdkfd, drm/xe via drm_pagemap, lib/test_hmm — runs on the new path.

So split the series so you don't add unused interfaces for now?

Jason

