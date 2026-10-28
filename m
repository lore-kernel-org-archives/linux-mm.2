Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8B58606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 17:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=DAM4tBgl
Received: by kanga.kvack.org (Postfix)
	id B4ADA6B05B3; Wed, 28 Oct 2026 13:49:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFBE76B05B4; Wed, 28 Oct 2026 13:49:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C4B26B05B5; Wed, 28 Oct 2026 13:49:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 70DDA6B05B3
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 13:49:36 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BA4F380174
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 17:49:35 +0000 (UTC)
X-FDA: 85372772310.05.AE0EAF0
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013062.outbound.protection.outlook.com [40.93.196.62])
	by imf06.hostedemail.com (Postfix) with ESMTP id B3A59180004
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 17:49:32 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=DAM4tBgl;
	spf=pass (imf06.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.62 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793209773;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nb3gNPlyDV3MI7zvrIM9XRvpnoQjyvfCQA3Zm4jf/0g=;
	b=alzpzP8TxiDsuVW8JYlJrGvKk8b2TNjjawCRFGwF4QQCda5eRSksLPEHkiNeTSVz1Wxcf7
	YHbNKQrjbSy1XCunZpplwxU+y2AOWOe5Nzt97qVsfn1fJxhkZKCiNShb5rTwT/x/k2OhxX
	6CN75SejAbvtj1KRMWKgveM1lRmTrc0=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793209773;
	b=vngHpy7XdzohzHNilrdUQBczVMOZ4G4r+xXFsMuLiyU4IJpBuDqCJsDqxFm1eziyYzDd0+
	okO3FYqrerzwEGg0LlooRTi1b6Gz6qjvYuTM5SV/jrXBKnMbxL3vGPOZp+BRQSkdg7D3vP
	DSorPze/PlPSu36rn+mR6UkcgYu9jHw=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=DAM4tBgl;
	spf=pass (imf06.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.62 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Om9d/ODmPC8exuRX3mwo/VIM1tBfzl/NNy/WtVeso844++PIdn1yDFJ2i7r21ap63hJuN9tsC/T8+b2fIeXAoD2MODVe/3e69NbPOAdnD+MVtbMBYsyg021AMaaeMi9ypkzv0vin3sLhW2lbuhANboXXCtwJd5lx32do9gkqwCiReuwtyGCNWa02NUrnQAhOSzh0JHC/AZMGE3ArIUSph97NOsqNGSoyErccN9VokFs9sKWYXOhFvrTYJ2T7HIz73aCOrGfJWeIwM4qERbJrJ74iyvO/hKydVyyXDD63d8t7J3Y27TyV/YlLv5UfH17I2vaSnqPgmeHwtXx4osVqyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nb3gNPlyDV3MI7zvrIM9XRvpnoQjyvfCQA3Zm4jf/0g=;
 b=ji6OMXxn6OFVmXgGmY5UOUu+ylooTtF2mzWpPhVgbbozPEPrvancZk3aYTJoADVZn/c6F4TfwiosxkGnzgclc9kQ0tvkYpU0kpnb3QYZT+FhhxSRgpyHMNglVbMrY9RPYPlmcOy+9YcQO97R1IbU8MMzixbJN6hYJwHDf1Y+kbm36Tvg835wL/TvuItmgaR/SveSYMmj0qI9HtJuSmj9pOsH4BwztkK+E8ExS3PGTBXDEXvQK9WkyoPB25XHId0U+ghL8lyxsabjAGjN0oJejiovg0IG8LSHYuW72kj57PTOKtU/l/3jtfF43uQYkogdNz4K7wCBMZ2TcaIzmB+cAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nb3gNPlyDV3MI7zvrIM9XRvpnoQjyvfCQA3Zm4jf/0g=;
 b=DAM4tBglAu6H4q2tnjytcrg2uh/+Xi5A3o1TBwUj+x9Pz2MfZb9KNr/Gzk1xamrKg2IxLpZOc/MX0hoZfGGCxYSiCa9lunUdbFmzikl+PyquC6/pptguZTc/Y42Oufb+SXT6FriH7rpSvr6nXUG7mA3VjJVq+X7UZK2U3D19GRBboREb4ncipOyF3uZRaH7RVD+Cbq9ue1T8iTmQLN5D6CBmRM+ewyiVQvOR+aEOWrHlwVCExuv6jlkGgin2B1QCAixI/VrW0F9yj8aPnyEs596tPaVF6ZKFp8hWWunCn1OGSmmfDDO0z/D1cFJqFfQUfasEMlTnIsHh2VAHxnNmsQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by IA1PR12MB6627.namprd12.prod.outlook.com (2603:10b6:208:3a1::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Wed, 28 Oct
 2026 17:49:27 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0569.007; Wed, 28 Oct 2026
 17:49:27 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>, linux-mm@kvack.org,
 Lorenzo Stoakes <ljs@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RDMA/uverbs: Don't return the shared zero page from
 rdma_umap_fault()
Date: Wed, 28 Oct 2026 13:49:23 -0400
X-Mailer: MailMate (3.0r7032)
Message-ID: <5E86E76B-F97A-4998-9EDB-8E450470FA4A@nvidia.com>
In-Reply-To: <829c448d-e6e2-4874-a166-7624e87489ef@kernel.org>
References:
 <20261025-fix-rdma_umap_fault-zero-page-v1-1-186255624f1f@nvidia.com>
 <78802ed9-9cc6-41c4-b131-7c7d38f7ff39@kernel.org>
 <DMEVZ5MU1YA9.2X3HCCHNQOIA7@nvidia.com>
 <829c448d-e6e2-4874-a166-7624e87489ef@kernel.org>
Content-Type: text/plain
X-MS-Reactions: disallow
X-ClientProxiedBy: CH0PR04CA0070.namprd04.prod.outlook.com
 (2603:10b6:610:74::15) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|IA1PR12MB6627:EE_
X-MS-Office365-Filtering-Correlation-Id: d97944f0-a7e3-499f-8f07-08df351bcf5a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|6133799003|22082099003|18002099003|261028144727099003|261026140227099003|11063799006|4143699003|10067099003|261021121427099003|261022105027099003|261026121527099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	5AG86MGsyNyH5TsJaOxW990fmNDS67tHWSGFvx//VFyY6m0moPpqhtHio9HWiqNtDfPtb/hEXBgBV0+4zu1ydbxle1yWPYmmiE7APDZkBkF5ctIdZ/04ixo5YNmpXN4i8RI1DyN3628bHGV4Pux3uUuZ5WKZRoBn4XleHDUtomNriXK8Bl65b/pC21q8pb2oY6kSu1IiQ6mPcHFnLOz7Sja/HqVe/wwrlUqaj9bylv/Z7G5URBK6Il4N7crQ/AcDjBAgWA9It9c5iKLv5Xip9n+8aHM8UBsETAkGboUnvEyXQfPei2CFB1VEsNROj5v7FxpQR13VF0mxahMtQrfiYOdXRMSdwTG9W2TdLAPDXzmU+Lojt6d8Ig3+ytQMG7SzOoNxmnzdn/h6fIfkHWdeg89J+sUkDXCYzRzt7cTFLaMNL6BEY4PaDuqJv3ZyJDayTrKqxIlNaH9OpxzHr2FfX94ToT19JeBk8qMy9k20/NIjpB1xA/LSzfCm0EyOS7vTV+IVuQDvdCBCtOe9IgWBFFQOCDDL+5rYCYVlKoeYt5XhtRpKrn35RsJbBmgHjI2+ZL4RmkZmkXHS8NO4AwrXR7pENkNoiwu52qkNEZ2veyWbWm4zrkVUZR/S9f+TB5K4PJa+zy4ev7bPQEJgtpdguNE6+YjmYCfFNkeMCmJs6e8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(6133799003)(22082099003)(18002099003)(261028144727099003)(261026140227099003)(11063799006)(4143699003)(10067099003)(261021121427099003)(261022105027099003)(261026121527099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gvOzj2JK9YG4Y9iecHSwVQvtbfqTLVqVDmrySbaf2RoHeRtjxcJ8VsTe3Egj?=
 =?us-ascii?Q?tJODRDTiRauBWwFzTUlLO6H4QNGNH1anliwMNawkL03pnfE9S7l/CleYZPm3?=
 =?us-ascii?Q?50+SS2CI3wjEE5ERMN95Vv7W1ARSL7lGck6WOuWABfzSsskWdoBM/2LRT7FT?=
 =?us-ascii?Q?YQqyyhVL/1exoZrB3eWkKJrUxxM5Y77Jg391KuTWCuRuCZiReMaFw17DsQUH?=
 =?us-ascii?Q?OgPcQFt0kBh2VyGRgVgkU+vsqk9itjiDJVEFUjZSd4+otgfMITBf+hzncWO8?=
 =?us-ascii?Q?Jhgkt5AmYwjyu4A7ZxYCGeDeTEgW3pEmPO82rxZCtIX0udtg/14UFOk4SVz2?=
 =?us-ascii?Q?/J866TDTKkDe4eNXZTL/Fhq+aK1b7HsJ6OE1gDKVJOTEFF7N5Z9vjdTaSl8b?=
 =?us-ascii?Q?ePfoPewX3LGU1+MYIQqbsaZwUa0q2acKX24drMawon6THhkClZvpPDyKnhL0?=
 =?us-ascii?Q?aTk5CikThb+cbqoTHdtHBPcij0qtTweLU40THJyo5Qe9xJBfkPHbUCwwql3C?=
 =?us-ascii?Q?DCEyGcAavfwVfNRlN8EIa4XhKK+VD62lKjz0fiwrIz24u8RmBRw8p/KglftO?=
 =?us-ascii?Q?Zbq8WqjCFYt5ru5gJTS/fMsJKG+0NT9PBWhlc98HohsfcMteREQtVN9pNWmQ?=
 =?us-ascii?Q?aqzN3dFTDPROcUxOf39EHdjNS+g2H/8YRC1/kjpSSSb6aPrRygzxNg/Mlt2a?=
 =?us-ascii?Q?m4Di0DCUG9upXSwf53B/nOvPsNQJ/bf0YkRekSaIuCcpeptBynmH6K/4Q6zw?=
 =?us-ascii?Q?TB4b33BMEA8db7D1eMN5qWvD4YdLdBOlJ+0dgrHup41CxGbvVu5PvSmnRInz?=
 =?us-ascii?Q?+ci5iVnhOeD/fuKhgoSSsHCewpvax7vel3kaJdVjr/S0wgweAwx3q3tayCyS?=
 =?us-ascii?Q?xKBVJwDpSTwvAVLi1JLNk240kvZVN3hAQwz/Hsx3435iJ7mFvOPstPHQdcdD?=
 =?us-ascii?Q?264GsV2KtZ4qBXTB0URskWspSrXq5Kv7FCZv4eE5r94A2yV9kAv/zEN3Wkxe?=
 =?us-ascii?Q?bqy7ahZutMIaTN20sgZ18VC+Icug+VlQFuAfGKsU6ddIWsn76C2LCj/3S4b2?=
 =?us-ascii?Q?VJTh5ZkKKK3lnYNEZ5wKJf8z02AqeKzlbzeKh7VdLc/FpK/AIaJe1anwD5C9?=
 =?us-ascii?Q?w9cVsY/LH7Hgba/oPXwWBMKZhGJx5HOpJXxrOyiEY8cGGcrAUepGN9R7x+Lt?=
 =?us-ascii?Q?mDs0rgBgEsdjc6RunUVpaOuiEQrpEc/GdJv4Iniu1m7cYA4I37BU8g2+9OOH?=
 =?us-ascii?Q?ZIbRH8cAlFnHOudmrwEE46L6Ux/g33Z1+OUcii6TqSBVRX5DQuflI0jAuHpy?=
 =?us-ascii?Q?a8FrvarRrtDq6UqNws11BgKVje/MRGK6f9ZNZmS0y+4KIR2qXsl8Zu8DjZHg?=
 =?us-ascii?Q?1kEpqI0CkCgGcXqYuw5E4Hzy1NF4vJmlJuCfH/EmMNSGj8AVggglE5DfY/lY?=
 =?us-ascii?Q?pr/aeP1WDMzFv6j9SNcSCDhG3v9s+FQtjkrol5InQ/p+Ju3pDQ1TeN5wY+uM?=
 =?us-ascii?Q?nofZiDESG8DSWM75wAtLYx/7KVThxWksiKOvJMYK+p6L8XpTQakay4rKFN9M?=
 =?us-ascii?Q?M1Kw3LcQa5KDHcBU1s5lRczm3B3RHkNwG+WvGhHHn61Mfz0jUVa0j0Wd2ndB?=
 =?us-ascii?Q?HPgnUJQ+j7xECJEtl1Rhd9GYABvsdneRbhBnwpp1m5pWSdf6FWeNJTwrQBWv?=
 =?us-ascii?Q?0qyiOT4owkIC70Ljf4WrnEC3LDbWlvL7yyymSsBvA4/c3JAm?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d97944f0-a7e3-499f-8f07-08df351bcf5a
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2026 17:49:27.0359
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /6mszMCPkqTL8hrKyNi1C44S8d24zlRYlz9WfSq5Vf/2XxEvNcNeRFhlbfokKvUr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6627
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B3A59180004
X-Stat-Signature: is19xty6ikh15hhc33t7sz6xc6qabebk
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793209772-157744
X-HE-Meta: U2FsdGVkX1/T0UkA6O/l27bke13za5MKnIZXA/RAwR8G6m4N5ChR2nWXNIt0SQZOCzwxv/UBxlmLYZMHMNqzz/E3yEIUCo1TW0h3qrrU4yAN3AFF4Nydt8UZArvpkKTJajMLkgOTejh1ajjCay/2TkJltD4PWphzlWefNLRHovWfiprWZYkkS+XBRXZxCymuvyK4eZPz3PA8w9BwBBen/UIFfizUKGbnoyfvAfrxNgfYB6d4Bqe2vnVG6IuRX9182nrsSpz1sxFG/mxo0tf3XlyRrbXpaiJxcbLky4cCz386uHeJJGX7cgrSJzvLGvJru9n6bTo6W0v9cAApXvlqQjEYnMdhKeApHvMtkMPH/EHl9MUC4PkQhcsRqpbBzw+LSAg8azsf+boYYYjFHmc9B/B4NhqyhaIVIZPF+3XbUVvx3Ezfde0ltA1JfG346YJ46223KBuWGd9/ry1Bw4DCTM648rSn3TDjBoI+xg8vVcO3iC+UXWitC4i2LBtjoS+48V9N8rlit3Bu8cYm2cN0djAxRFkDcKYIhZU9jU0oS1LZ2ox5xGOd7mhQPJSkvEAb60zT+LRh7G/DTMiCEK51svKji7r6aTBkJwQZAw2WbVkA69RzdCJ5+xl4KMgOx12Q7B9DVJGHkHc8BfTvrxmk9QNM6WYV/R1uvuQkfpW9WNxt9Z0+rtp6ZEXy7wRpPdFwcltXnhYavCFBveytwz7fRAP5g5A4ujNrs0CAOjpmGsVAaHrg3WjjwdE0B/J4p/lT1AIAsZ0WHqEaSbOb0stdZr88lGJrRyXQ5wvDF4FxdD8UC4712NOHlWHPCPkEMmiG9YKBsLVz8mVMbnon/+YFVMSww4KFf573LHIzBYtbAft5Xyfi900+xodkb//wvEoMF99PJT3u0+u34tO0mmJATufn8CywbVmue3UWT9TF8ha39db4IzN8S4+MR5K9cNxsUYFdjtGxGByeVMyOK0q
 vwY63Xia
 4g/jFl30ZQeiOMICEPn2SjHDi9bqMnYSiXSy5Y6x0/sWzGjzFs3P91V5WF/AODErx35MejEUch6HUdMfUI+lDjq4cZ/fxi5ypl7iY4Qhth53Dzhr4aNhbgp0qDeQH7i6YDyTVgSffeSf192F3r9b1iIAEKLM61L8r2qHz9a7kzcOPi01uUaKNwbZSmTk4MXzwPocuCKe47tIaY+J4ayX44U7hFtq63IMmfLd4RrGN20lo6badjy6og32vPz4q535dIu8F/fzoQH1HXe44l7y+48+dFPuWSDxJuDLbCrGt7+sHjxfd4jNQAJ78fSyHVNUSVpZXtZojwJlUZ+YhVGd01f5yDKuz/BrjYDOToqFuBLTjaWi+NeFKoDV/rZr+sPawj/UiFB4R81GXZFuMmQtQnDzDlGWZO4Mt9KMS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 28 Oct 2026, at 4:43, David Hildenbrand (Arm) wrote:

>>>> +	/*
>>>> +	 * VMAs that cannot become writable map the page as a raw pfn, like
>>>> +	 * the device memory it replaces. The page lives as long as the file.
>>>> +	 */
>>>> +	if (!(vmf->vma->vm_flags & (VM_WRITE | VM_MAYWRITE))) {
>>>> +		ret = vmf_insert_pfn(vmf->vma, vmf->address, page_to_pfn(page));
>>>> +		goto out;
>>>> +	}
>>>> +
>>>> +	/*
>>>> +	 * This VMA is forced to always be shared so this doesn't have
>>>> +	 * to worry about COW.
>>>> +	 */
>>>> +	vmf->page = page;
>>>> +	get_page(page);
>>>
>>>
>>> This split handling is pretty horrible TBH.
>>>
>>> In once case we take a reference in the other not?
>>>
>>> Why not perform a PFN mapping in any case?
>>
>> For writable path, a new vmf_insert_pfn_mkwrite() is needed, so it was
>> not fixed. I can fix that part as well.
>
> We should do that; returning kernel allocations from this function in ->fault is
> bad.
>
> How urgent is this fix here? (can it actually be triggered?Specific hardware?)
>

Not urgent. Like Jason said in another email, RDMA only runs on arch
with special PTE, so refcount, mapcount, rss are balanced. With DEBUG_VM,
zero_page checks in rmap will fire on the returned zero_page.

>>
>> The read-only zero page part might need more attention, since
>> we just prevented vmf_insert_pfn_prot() from using zero_page. Do we want
>> to add the support for rdma_umap_fault()?
>
> We just have to make sure that we cannot install it writable etc. But that's not
> a concern.
>
> Just have to be careful :)

There is one wrinkle, it does not work on
s390 + mm_forbids_zeropage() == true, where zero page is not present,
and a private zero page is needed.

Jason, is RDMA supported on s390? If yes, it is better to
let the rdma driver to allocate a driver visible zero page to share
across ufiles. So we do not need separate handlings for s390 and
others. Let me know your thoughts on this.

>
>>
>>>
>>> (Does GUP have to work on these things?)
>>
>> These are VM_PFNMAP mappings, I guess not. But I am not a GUP expert.
>
> So we installed folios with ->fault in VM_PFNMAP!?!?!?!
>
> That doesn't sound right :)



Best Regards,
Yan, Zi

