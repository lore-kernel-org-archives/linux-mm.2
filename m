Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DE46F531C7
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 19:21:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A525C6B00BD; Mon, 13 Apr 2026 15:21:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A03406B00BF; Mon, 13 Apr 2026 15:21:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F3066B00C0; Mon, 13 Apr 2026 15:21:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7BFAD6B00BD
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 15:21:44 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4807C140289
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 19:21:44 +0000 (UTC)
X-FDA: 84654502128.20.C1CA9E4
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012033.outbound.protection.outlook.com [52.101.53.33])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6DAACC000D
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 19:21:41 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=JMe3bKFz;
	spf=pass (imf10.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.33 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776108101;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0+HC3XRSMhUBoGzAwri26E5aQw8VzOyP1Ks5RR/GuQ4=;
	b=CB1DjT3TjDvTkeH4B109VHi4CrFQKsCsI0qvXJysMZ1KaCZ25ukn2wiVvY7E30o0xuYC+G
	gPzjIIiJLpE6ysGL6wpBVuvmvpV46+txgL70O3rCfflm0IwVFyRhVkKUGFFMz0Y30/2HU0
	QD7vBZlF53QggD0Q3cc9G3C4fLDiMqU=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=JMe3bKFz;
	spf=pass (imf10.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.33 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776108101; a=rsa-sha256;
	cv=pass;
	b=gVABoPZInx9XLI6yXMaeTSVyjHSIdBobnPmNN8qhdBxA9MuPYiKyRf50wTSFcRjWVTUGTD
	H9qjQcHwreb2kCQ4Mb5r1RDypzG6/fQ75zIJrGAr1NMviEWmtUwj3HOSkIVI70e9Z8gHYK
	8/WMYw/BffBu4R2j4OwH0gRnoEcRvQ8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=To56EoEcLb3U+MWtWRUv2h06gLBeTArjINobbYIQW+sKzs95q68D4UGeEMbdsPp/LpXkVb/nJop+knnqgw6Ie2lVa+lmUmsvOD4z4dxggYbAyVf+g/oJTDOKSH+gecOBurvz/cD5CSjpQGCmJr2gUVsvlIwX2LIC9U8M3jvy+Ga3gthzYUoOUaKCmmRXBiANZ8J7Q6FgvTbjnAN/zs9B63B3+Wy+7s4VM1Xmu3wV7Lv1KWPx/PJkIKBT7cFKhP0UOXpehjBUJIXsLM/FbdlU45Up3HamuaLaC8P6YBBx7VTqgQQVWv9/z5PgeJk+yj7ZZeWxjqCVwuSCE/kEvi97PA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0+HC3XRSMhUBoGzAwri26E5aQw8VzOyP1Ks5RR/GuQ4=;
 b=RCzOBro6JlPdhMimCV6wHKpH8VKAeKpqmVVm0pzJgU8uTOeeIMPreJVAvT+umjcol8pxII/0EJIusO0lmZYTFtkBcFRtfBsxnWQUEl0MH8WPnsHm0Z524SvHQD4LVGv5o5cfQ1fRaAGpNpOjv8BqDXTNPTlc8lnI+QZRRdj/ZTuy+BGDj3K/N5EIYD0GyL91GExTqXaqSwwFW2NKn5GGOjab5jzFFRW1ewFmK2XuOPTxc8Slymr4yTQkF8YYcHQ+fZBR0mE6f4Xle4gdnz2EejAJT3b+paScczJMc7WnGGgCVusH3ydfw7JOXJ2U1NAEaB41Hv8aOHs08bPS41AGqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0+HC3XRSMhUBoGzAwri26E5aQw8VzOyP1Ks5RR/GuQ4=;
 b=JMe3bKFznQgqcvomhBCTFAtG42bvP1VJ5FXCdzOKdqq9m3m+0dXEgXV8fn0cU+BktGL/DoGwnUUcPWlD3pIjo9MErAetT13jkgTX+IGxh8KCaKr/ZFjLS0cFcJ9taVx1UAA7NAh0CE7sqdwk6dIKP1dygDgO902pjQmFTlCDYc57BNYXKsoovJR+lIbG1OzmtnmW1tndw8OOimSoiRLi5kZTkncoxOXH0JuJ25cp+8anFDCeWa4OrPDCv1o/ITH5b0FRUAnASc4WqnE1BS+Cnub//MqqUDcR1/q9j9UXIKd36PwaBOlCun3vMm5Io82ZkLFnpYxmmz99zDIlEuUJrQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS0PR12MB8444.namprd12.prod.outlook.com (2603:10b6:8:128::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9818.20; Mon, 13 Apr 2026 19:20:53 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9769.046; Mon, 13 Apr 2026
 19:20:53 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH 7.2 v2 10/12] fs/btrfs: remove a comment referring to READ_ONLY_THP_FOR_FS
Date: Mon, 13 Apr 2026 15:20:28 -0400
Message-ID: <20260413192030.3275825-11-ziy@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260413192030.3275825-1-ziy@nvidia.com>
References: <20260413192030.3275825-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0138.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::23) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS0PR12MB8444:EE_
X-MS-Office365-Filtering-Correlation-Id: 21909d1c-b390-4951-d854-08de9991c7ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	pCqHdW/Ov0gPjrV5vth0q1i6OcPqggNFlgTvOHo40GHm0PtHqodKiQ+CjY/+HHMyQf1kBc8fMgpqOcH9NeIkbveSqXhfX1wtfdPdmXZ+YDul/enalDHxKrPLFS2RECe0Mj7825YaYgDB/v/HL7FhNQnkgW7ZA5uyFQVJAsj/294K8psttWsYFDGYAjDi+sx6+AnzF1nFvJoTg+VW7YzXzdbWl+4bso5RgQlZ7Xfr09RKSUvFwDrwOG0cnyQxYTfqeLnB/NSyxFj/CFAItkOfsMYWKunphdMzC2n6f8fHGynEvad7ni6cQuljzAtNWb6ynOE3DLORY3FpVZ2kIZHQ5XOJ+Ct8rbvWWbQKoVEBSRKLVC95m8b7CYpKYSC3tOBPxfBjTTaX62Xed5f4icfEtZnm5tcUXMFPH96SXphTKRhbsVJaIDTCZknwhyMqIir4Y3QCcnF3DYWbpppp2Vt1cCvNT9jDwRPrddTpkDa9GhgDAzgmpJJO636YbCUDTB480LCaQwrU2+3qorZKsZbUGWJ2+qJ9YQreth6VC7HFNAJ4cltSdoEG/TeFxbGtoJsOdXgXbWGlhJ7U59gRufC4X3LSZhNP7TVl+XBkGN6cyMu7NxHgtmH0MwEn4YW7uW2KTW55febkNA0fH++PZ79MR1O+rsgNf2ejRRrC1UguID4j722L0L8/ZMhZhJDy8WWOODSaDqIQpUSN9rz6rqPTp7DD+HjnV/VKPK1+XNf5D4E=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zq0n7IuzyxPr6pbtMlG8li1OJSsoI7L+/5tsmBRYdizZA9Yg0nMHbFkFl0U5?=
 =?us-ascii?Q?op/EfEoSW0tC/+MCIRgcR49B8vt/cyP2MzMD6e3iIGU6bZNl+RMf0BDfY/fJ?=
 =?us-ascii?Q?VNm0d1E9qEjUvr70vaziY49A75J0L9BOa2ui13Uinrj6CufsJ4B+iCaYNqTg?=
 =?us-ascii?Q?judrlGolToRZ52eGWQtxQ9n3igbdhQJR7ZNVh9Q6uy1pNuadKNqgHiNNwIJn?=
 =?us-ascii?Q?x5dLlyRlSElOsWPaUnKNzZbp8GAFS5NkePSPgMu4g+qI9aGVpPuBU4ppl+WL?=
 =?us-ascii?Q?9/tQ9IQSEmw4kvgTcS73ST+oaxw05UmiNICdmY80wUH0VtrNajEhgpf4rNY6?=
 =?us-ascii?Q?n/1ngPE27ZBMq+H3UGD6ODOO/yR4Eo/+BmuQAuBaSSdUNbgmqbPgDTtaavSm?=
 =?us-ascii?Q?XUyJoEEUZTYJf3RKMnSoPq+EdHg6EQVDy3zUYrbS2vin2c8YK5EXumgOEZtX?=
 =?us-ascii?Q?GoIWmXAdsuVfzGxcKy5V5TTznySMuVbAETUfnga7KBGMEKK0XJI/HXOhoPsM?=
 =?us-ascii?Q?HZKUMy1Z+EJg9PcAp7QFGNuhFIiYLcgs/U2M5DraZ4t5MClGedkoVufqQs1r?=
 =?us-ascii?Q?mFIx1QgE05/5lyRCraHIsx68szISpaakBgqYDrhRghF6Q7561H4MycraOWG3?=
 =?us-ascii?Q?qtTrXdpiwLCcsX3kz5s2ORvxoLkAnUvKlrRbydT/HawSI+9WlJT+kP4oe5+z?=
 =?us-ascii?Q?PHqFAuTOJ6o92RT8X5e92UU0R608SeetvPydtAlpUC98N5UqXjf2h0MqdCd2?=
 =?us-ascii?Q?JR0CrmbswpeRRdcoYmRPoBIW5JwSfs53YQpvJh9BA4iLCXVt8ge4INzwObmF?=
 =?us-ascii?Q?uAvMtMiG+lakpOfPB/jR1NYpK2Td6P5ykKDybBJtCUys42+7yj3FiZm6cNgf?=
 =?us-ascii?Q?0kIT5iFhkw62vwHqhvFM/5EX9Ezw+qsuNF4cKb2oOjPsNUpIfIlywLkoWJXe?=
 =?us-ascii?Q?eFNlATX20Af9UFU1W6K7uqsTz/ccA5Ucrxs5yhpTLHlLoJTx9X4aDBTis0SZ?=
 =?us-ascii?Q?aBJxv70SJuWGtayCmqrQ1EuDMYKAJb+/bWbwgiC3MXmi7BvvdHdXGRP1V5Bo?=
 =?us-ascii?Q?f9jjuzhdKbpF4fDoFvy3f1GT85Jgj0rmyDHUjJgkM21IjkXQSXXtcRZM3Uy5?=
 =?us-ascii?Q?QdLSSPzVzx+JLXrYcSFRK1cJveQ1Owga3l5Wz2IQtShyUDZotjUvhhe+HTj2?=
 =?us-ascii?Q?cjw2HeSZIecHIq6eBxoECwKmw7xLZplFxqR5jIvL4M3KSYLhHSlgv2q0FPGB?=
 =?us-ascii?Q?F8R6CXFncqbabVYLH7r9s506a5z5d24CRHfGy0SjZwBjyVooqwtTIA9TaVDU?=
 =?us-ascii?Q?g/w2etgzdvFA9CMjNerzgMp+aYhpKOscEHmXUOdh7YW7sgfyijY2c2HmT5gK?=
 =?us-ascii?Q?FtdV7+jf+ATEZCLU3VAtkcpWllVgIfmQe6WhFaakyJ2K5s05AvMJhennIn1U?=
 =?us-ascii?Q?7+kTzhTiwKcTiE3sFIW8lwgHc913OpEyGgP5KynQ7VmQCXFi2Agyxn8tP1FC?=
 =?us-ascii?Q?e7YoA9IgAKMb0GKUN/MDzAMKes/xuSF39n744KBXujy/Tqtphpw7718AyrU6?=
 =?us-ascii?Q?yeQoWzlSDEBTQY9AMPrVUgUVCuZsVbxJr6wiVNPpl5CvkHcYne7vSt87b0C/?=
 =?us-ascii?Q?h3wp3sgEM5MjmaBRk8HTblw6vnJ4W9sxPD4AiZLAAqIRBM5ofExZntA7n4q8?=
 =?us-ascii?Q?n0DDXrjmV2QRveuS1lBBeAHIM67/2Y6rN6YF0PyySBfIBWf/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21909d1c-b390-4951-d854-08de9991c7ed
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2026 19:20:53.8147
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G8DgKc4MLtLKad/NSMBY6vPg1IENw5XS4R5OVCkdtZO2yyCn15uSKQEw1GAWizS1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8444
X-Rspamd-Queue-Id: 6DAACC000D
X-Stat-Signature: mmnttzjjtdpkk6pimyke6predrkjwswz
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1776108101-403121
X-HE-Meta: U2FsdGVkX18o6uqfjZBcKQcdsABN861CZKUkZJh3cxpE8W6/XD/uFEtoYlYVrNZSQ1lKrc1EdEHzFV/5AvQ2BHjomG4gT8Cw0LJK4UOG0CzV32U8kbUVfPHg7LMZfGxM2tydIE2czWWG48dP05hyZoSsliXQaGYE4yqlGRMNU6RQ7pfrwCWSxSufXnecf7RmSR0eva2/nBFCFl47UCgpJQcYpx0dkXdDxzI60HFW3emXX+ERcW4MdWz4VNzPRkUHecspG1c/hV3EmoYYO5mopssTX2E2LyI3HLmkstBGZtPd4wQ82QN7ZMxSshz4Inn4APDVoXVAnlFpXuqrkR4C++hxmXOVZvZAY9A61lSLC2P2igNNNRHrf+8ul/22R98kLd/oD5dPzmdILt0P5oEHrEERy844eSdtWVBM8P5b8XKKlGS3qKCsi5NxBRtATPbEMumKOEBcZu9szZ3QY1UgXJQhEIqGWglGaxkojLvKLfThcmcrQKE4GetxEGvVAHd5H3+6njRHohDJqW2+7zXJ9wJEYc7fDtm+FlWIrrTNESstdijFV9x5MtfAh1kuF9Zkd+8mivS1/AzGJXgXvDACz18ndNbYA6LHSOVMvkwwfxAld3WWF1BgLP6vTrFMnqCO6sWV2VRJoVBlygM2bgVybbxsWrlAoVtez5qQCUrPmnnOYPvlW0t2t6qHy+msKh7ssvZh5wTBOob+UcMW3Q7DuG7XBj9EBRoBdBYCJiyhK8/HSnPff8t0fSH+kDB5LFw3JeiCSoIZgV3qYxWdqUj9et7wl5XZ1R4i1E/6qm+Kx5tUhrW8gFutxGu90kPSsbxldshPrIVOikzAFmofBYhA/jknlD2NTJ9ZrmQdXHroLWZLCAjbbQznwC8AONqdPHo3lO/rvwMSAEBxckwWQNiRLfmtNqFQNuOQ4o7kJZmh2QO9oLktiW8RUqYuQa4+uW91epTUFDDa71sEstnAIn/
 77cikdXP
 YDFKpVJ3E7JSxpnmaLCIA7GRHhEK+7QMZdus/ZLNF217CXmFv5C4wOsx1dz2kKDHhrxITQ54NlPXpMWnMpewB/ojxCCiTATd5EwYY61nyugUzbYYv/aSX+milo6AUbO1TZjN8CyyioTEgCDCOoYtqiCtjav8XY/vRrBpgn320e9NUZv0M6X1NA5t63202JMA4nyDkhzJEuElw4zD93egOGu5aM5HnLXGr23SNwGG0w6JyxkvLi76gVaG5s6pQ1Z84U6csg/RVsgfAcGJl+z5ycs0WvMIf4ALsll7K0Yv4C2q2yB9rZS7rsexS2u8fJfP4Hu83baL+JT0UNbCk4wMrYCWBmWuq8OPzzMHIWXZlcYago6x43ePqkRk3L0LFAayAYscMf8p8tlspuk6aqdwLiXnvONj1o8IwrLTAuVDwioEScRLbGkcqztQ2mpzlhdHZfq8nu+0i2Ge/p/U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

READ_ONLY_THP_FOR_FS is no longer present, remove related comment.

Signed-off-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/defrag.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/btrfs/defrag.c b/fs/btrfs/defrag.c
index 7e2db5d3a4d4..a8d49d9ca981 100644
--- a/fs/btrfs/defrag.c
+++ b/fs/btrfs/defrag.c
@@ -860,9 +860,6 @@ static struct folio *defrag_prepare_one_folio(struct btrfs_inode *inode, pgoff_t
 		return folio;
 
 	/*
-	 * Since we can defragment files opened read-only, we can encounter
-	 * transparent huge pages here (see CONFIG_READ_ONLY_THP_FOR_FS).
-	 *
 	 * The IO for such large folios is not fully tested, thus return
 	 * an error to reject such folios unless it's an experimental build.
 	 *
-- 
2.43.0


