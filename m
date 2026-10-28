Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE975606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 14:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=nmK2sIs9
Received: by kanga.kvack.org (Postfix)
	id E0E4A6B05B6; Wed, 28 Oct 2026 10:00:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE5976B05B7; Wed, 28 Oct 2026 10:00:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAD946B05BF; Wed, 28 Oct 2026 10:00:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A82EB6B05B6
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 10:00:44 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 141F2A8B65
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 14:00:39 +0000 (UTC)
X-FDA: 85372195398.12.3D18724
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012046.outbound.protection.outlook.com [52.101.43.46])
	by imf06.hostedemail.com (Postfix) with ESMTP id C05C418001D
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 14:00:35 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=nmK2sIs9;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.46 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793196035;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8y9xn6Yu1oRWAftqzyoraLKXUmvic9ds88bl1dOwKR0=;
	b=iAHL0J2kYRoOkz4Z0u0/rtWRIa8ZcIu2tbJbpTJ3dU9wJ69mr1SBYQIHArX77BAMa4BP1R
	NxcF8mMO7o76u9toF08NavL8KFfqWhwf9NOjxm+nFcrdyFRn3QKQy/0pon4d9TtzaFf4Dq
	O1iI0aH/MgF7tWIZpj1kHVUiCNPtC/E=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=nmK2sIs9;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.46 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793196035;
	b=eQJeOJqVmrT/i3ipe+M0cpEz0Qz3PYByJ7czjKYMeaN4hWhjs2RNAP4nfOb7/UqAqkQgZt
	M9ed6PdhEVwrpaR7aXhuWS8a/D0fcBCnAmWG0AMoJSZ7/aCZ7/Rk/RUggjVu9/PFfqO/X1
	lUoQ7WMIh4rbK3Nrj/2TeO/JAK3x9kQ=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Or2Uj4khw6mAx7NcMFQCG++j5pn+UjQ1uPsTxVbtIB5lgfZYGyUHULWduUvE+ZmzlnNqUnrohfDHRtad7B5MM+PgIkruZ8xcwNa5armM6etRAV/Ny2adTdFyNu6deHrsAp+zbHr4n5f9KO7DLGWUeqb3fnllWkpW1BeoWwLxFMbGBHkFQhufjaR3z9svAZkJQ7blt6+WIwReN51lwJpPRD33laR1Lz2SJQBc3W0oQxPad0Pcdn+JwcE3iDf4tur8ZsJFed8sUsoUXAWCZt8vEGSP8Mjur4lI/752ukCx2V7T5Nm06nUk8yGXBdevsi4SyH+6kBgz/O7pjF4Cx0cGMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8y9xn6Yu1oRWAftqzyoraLKXUmvic9ds88bl1dOwKR0=;
 b=dmhXGdPA5yQhN0AYQO2ztMrhCledxAdfRILgqH8kLcULidISAO/kS25osLJhgD9sG/crJprXuxDJdCZej675W/M1RYZzXX4LZIB3fz5xAnF56rJ2WJslfS05ZwTmPd5YxHM3dPqk58IPsAEDYoNQ0GFpaQg8mUE/9/LHdNjq9y9vwxf4J/FixLQVQQuPFFtkTht0cA3W19+FL/0+zbpHEC1ytVHOhLzGqq0PzqozjnKG39QD17bB8m26QdDarXPXLq6brgfPEtBmcvlvUJQbo2mdvTSbF3eT2bVWLLGmZlEdyd1kT0W4XBoMk5NpXgWjHfLRonM/kNh0NwNUrpzJrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8y9xn6Yu1oRWAftqzyoraLKXUmvic9ds88bl1dOwKR0=;
 b=nmK2sIs9dANX1kIQQe8eRVlEzVe9neJQlylHh93yF0DuZkRvvkIC7CBQUGhxRLAq/04cyZozgVqtyqZc09aCW17Fsvf1d+NPMoV+3WHX/fse+3gw1B+jRYa9G8IGAetdwdx7OkLQR0SrpAwFzk7mK/o3GVds5/efI3th0O3AbRuKYWYNkj36P33MsSD0Nt+hgPYCrskqWQe1e6JUF4cKbL0mnpKuHfJVHhfcXKfCYZq6Oh7W0NLuxS+oVT0iByUc5E95CGdiV4oFgpjqP9ybLmk3Hc8hUDmcCYKHIxhoL06hNhY86yQGJVUk88DVvZOU/qWmlNQxV+ixNliy0e36qA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by LV1PR12MB392019.namprd12.prod.outlook.com (2603:10b6:408:514::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Wed, 28 Oct
 2026 14:00:29 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0569.007; Wed, 28 Oct 2026
 14:00:29 +0000
From: Zi Yan <ziy@nvidia.com>
To: Muchun Song <muchun.song@linux.dev>, Kaitao Cheng <kaitao.cheng@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Mike Kravetz <mike.kravetz@oracle.com>,
 Frank van der Linden <fvdl@google.com>, Michal Hocko <mhocko@suse.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Chris Down <chris@chrisdown.name>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: Re: [PATCH 2/3] mm/hugetlb: preserve CMA flag when returning folios
 to the pool
Date: Wed, 28 Oct 2026 10:00:26 -0400
X-Mailer: MailMate (3.0r7032)
Message-ID: <379883F4-4F55-4206-98DD-CB10D5DAF0FA@nvidia.com>
In-Reply-To: <0005A5C9-47ED-45EF-BEA8-2693DAA7C46E@linux.dev>
References: <20261028113319.38544-1-kaitao.cheng@linux.dev>
 <20261028113319.38544-3-kaitao.cheng@linux.dev>
 <0005A5C9-47ED-45EF-BEA8-2693DAA7C46E@linux.dev>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-MS-Reactions: disallow
X-ClientProxiedBy: MN2PR08CA0007.namprd08.prod.outlook.com
 (2603:10b6:208:239::12) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|LV1PR12MB392019:EE_
X-MS-Office365-Filtering-Correlation-Id: 00893eed-180c-49e0-5202-08df34fbd2cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|23010399003|7416014|366016|261026140227099003|4143699003|261021121427099003|11063799006|56012099006|261009223027099003|261022105027099003|261021123027099003|22082099003|18002099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	3cDSln/TE4Xtb7iuTek8vSpu2tm6ET36f5WlQe1daY3zXL7Lwhfs7TwWrvBz+bT9AVwRz6vqCZfuY0rx7bCZqCnLOHaFz7IbYRodrs/mJ2/f10VXJfYdLoPX/WhnDrZXGMKVVRAszapsReouJ/EhDQrFKsihHkvdoDTzx7joIsLMp6/J/HJ3N66tcryM45Hmruh1/cbzVoNxc1j5HWww3KlacgLN0pDQmd26DGvWnHrEFtv4h/UcOkVneSTt8Rumqro0o+EGguoZObJv6yPIlv7xGFjcFaPALzo/y3TeSmNfH840PlM2uN5A5pFrYyTf1HisVbFNy7Jc0eV/WjVCmwHUb8vJz7dGGimYmi1BaL36KWKdnOrMySsCbC2ShW2Mm0mjxS0EpPDPSDBpQ1iUOIadEKzaO36Fclolr6vfnLGfsbpcyBCDW50t8yDvuUg5lOtMWyOFU5RX52asCOSE2Cnif3sEhALwee6sPOoNXLwA9JTNevcvjJEOF2l19vdlIItfi02ZsU3N1tUO4lBEaBfTSTQlHRiak4tjJDdC8qADpCDZSROv1/2IOLSGYv6SRoJepcKQQOmei37T0ctRd4Qi7ktb7iC8P4lhZFx7UG4P0aqqe02pMYpHEuIknVkcWaev+4L9OOprRgYMPikaRhAPFTEjDzQhkTweryfkT+I=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(7416014)(366016)(261026140227099003)(4143699003)(261021121427099003)(11063799006)(56012099006)(261009223027099003)(261022105027099003)(261021123027099003)(22082099003)(18002099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zXEFne5c7hFViezA+/eisHTEC79Ya6gzmyNx6s9WoCn5/4QveTAljwSK9ux8?=
 =?us-ascii?Q?4TfVAe8uSF0GRDvhr2TuIIyt9EtXKE8oOOQdOKj3+f3nKgCsQFINJs3cbHti?=
 =?us-ascii?Q?Lro6jwDUhHyb3N8cdepahNTfNqxKkaxSPFfnX/qR0VjneB8X5TFn2EB5ljma?=
 =?us-ascii?Q?SrFUl4iyYwHHBY6Hc03/ei6wNwpCyXtfwwug4T+crrelnp3uy1NYyT96+JEt?=
 =?us-ascii?Q?K/ME20nA0oXTU7dmD7kYRBGDicGmMvfnGQSXMg3a4GWxEFrO6qS8r2IIqb9r?=
 =?us-ascii?Q?WDfzH7PiLqdEnEzp/f1dUIjIz1NDQhMs4M/QvpRRSgv5QIJbvkiUDlSD8ZO7?=
 =?us-ascii?Q?BgBwRLaZE+OQY8KDxiyj3zmlXEN1mwt0nSvtdqJd9DPtKp0SEGignXLz1Rjc?=
 =?us-ascii?Q?bSNdhdRGjRAhK1sDFAKRiYIxIVHodQgpxkChxjTbmz3sv6cMAcL6/GQCCfZx?=
 =?us-ascii?Q?S+BR96tY6DXbkIVBmiFlTabhuCgkI0tJtmMw0+dWQKY6fx45FLy6YzWeg21x?=
 =?us-ascii?Q?IyQBTW0mSK6s9oMAW7S22nVQq4Clih+IaBFZC55COFr1N6fphI533+pXyTHA?=
 =?us-ascii?Q?I3LXHXjINfUFZlPakKG0HnWMLzDPwB6CMkYxajjfJxRSm6ze0MW6ei2dzwsw?=
 =?us-ascii?Q?br6cC0FGXcOciLtJeklsdgrAzJcxspPQmx5j9yg+8rdG1HJQPZfa150GZHT0?=
 =?us-ascii?Q?7UzODhwimjLerE/0dl2Q4da6YKCIiQlsQY0NIL+88YrfFB3d/e/N8oZY+vG9?=
 =?us-ascii?Q?incAyyej2ZvGaUppqlkXVp+HivTjvs9NVnwedc+IY6MirJdZa5uUdl2vL4eR?=
 =?us-ascii?Q?t6VFhLGdpl6MWDNBYWvx9VV6GhRvcjHeOApSOR5Y+4BwYuor7RMTO4V0C4bD?=
 =?us-ascii?Q?5KtNHarC41Mp59cf7ReJ1seQkGXCqsBRfKQxUaadabpalKbLLrr9fcvUPRNU?=
 =?us-ascii?Q?dYx4VUKDs6nxGKm9V1/bHSn9+OW8jqpgCT82Srzi4ByYFgDBuo2IoA2t1boq?=
 =?us-ascii?Q?TO1dD7ScyRrM+hp7+OV1wZqGjhgKtzMJ6jbxyBMcHthurNmhgqs5LQq7UlsB?=
 =?us-ascii?Q?Ek9GzLcO0F145Vc0ItcVNZXearxTZnmuSRm+w69rjKeagXH6U9qHgQFjfyKS?=
 =?us-ascii?Q?705U9o6GsU3Uf+ISRnksGATkFeOxGjh+ifABk+Uj5493rMk+Oz0utEVf4WfJ?=
 =?us-ascii?Q?ZLa/OBk9wl2xMX1bXOo/IMPxmdWkQyFDe5k8L0SdcUkAwWzZgeSR1qWpGqZ9?=
 =?us-ascii?Q?qPbWP0UMZ7IV8Pt0OTNFPpz3DFfBJfHkCxV/rxumhceDLeVPsZ5XXS/DWsRz?=
 =?us-ascii?Q?K/RdMxnEKNpyXACJ4bt0cOh5EaGF0a+RIv7DDs8cKZW/HwBDLv6jf3/ziL8z?=
 =?us-ascii?Q?sBu2WMHGlf7kiFK3HrGsWEx1teAFh/kR6AW1ihmPH8EOs843gYm1xnzLFaOd?=
 =?us-ascii?Q?8QDAOzJ1R3pzPS8V9TZcm5yUupYIA9LbsvoByIqIexA5oD2AHdcM619A2tCG?=
 =?us-ascii?Q?5um0/mv2ZPsfYCEazJOFQpZRVILo2/B9XaDzgEeG+of9AFxq+ydsuMdvmDBg?=
 =?us-ascii?Q?VyfbLELRfNIldCLVytOV3nCBHr/pC0mf5rscnxxhNKBitlZJ3k6x9/cNIWTd?=
 =?us-ascii?Q?XeyCG9TvgbOhNq5xiCEPT6owgmff5NLNYVrRUdusdD7i/xZ9fIy1FG48feuR?=
 =?us-ascii?Q?iS1GmWrz5yGbrnJIGteEOWAmKZ59cywMk3YRJcRqeDZgRJZqnF9nY6JBOgQM?=
 =?us-ascii?Q?MDsJ5aUYWQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00893eed-180c-49e0-5202-08df34fbd2cf
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2026 14:00:28.9968
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8wasY80EsDgZuZNXw/uLEFoszTSkrVUsqvCLEhI7sVKXtIL0Wgis2vE5jR5G0g2x
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV1PR12MB392019
X-Rspamd-Queue-Id: C05C418001D
X-Stat-Signature: ihspz1rxzpbyz5k41f5msdatzokz9t7j
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793196035-609467
X-HE-Meta: U2FsdGVkX185tWoVuh5DV5ZeVdBr/rglaJxPdjqdmUHvT/NCl6etpiVZnCfRqC8rI/MLjVsrVxKBERJxVRn+5oq7DRFjYHfx9tVFy4Iv1nxfRS+zTAklsfK4FEOw/iAxwYiNlRsufbbr4lfjdq2LCbG35/bnzhwr3VwF7gyh24XCjlVMhKrk1hKYuyql3/xLb4bWg/wsmZKyscFcoul/0K1CmOxQSEWC0BziNXXGwxU20MdEW2KDz/aOAIE23DTc1q6MLhzGWhnTJwJRf2RLIQKVbFcAs5zuH+uEc5gHWeBpkuGPocUwPnZOLfll7CqJ7GuY99TtLKVgF4oRuqnMHxevgSBN9MrsE+Prr41DSwAh6NE8poc8HfQkbLME6kFfo32VShb0jPPXzdT05nOqFnGZcSYWIZSnc5JOddYjWMqO3vhzrqw+dv5F3FAp/osq1dZ/d5IKmpaSM5G3mTf5O0A2tSnsY8UG6SW1Y+foFqW+nbIDgNX1oSfVPWZ0Y7+dKz4MsJZpg/O8WkoYfgMTA+LZxiuB39kCeULQHbDSPN9c7P4PrsedGAAVbooYyaRJ339cwd7XZVeuuulFx0tQbcqLvZjgJRSkvMfHyCMThrBrLOZQ27GHnnH0yF8Fnc9Kjyo62Jtzpd5lAVRGj84vZ2T3wLtQ9Z/BxaYPTIlGn1+PRBBE5gFPZ9Esm73gp0mzMwcOklNfSZbUJifp84e8UW5ZhSV7vCS/nWN59rK2w6z/jEHwFOIioQNlZpAolGCOWLv2uWOqIU0/VjZ+6fk9sqJ7XhmTr70wxFTBV0ZCVqcSavxapYFlRCm2DDWKg3evkwBVpGN8xF7SxDzeD84idoQ7kWi6lrEVSnGCw8pdHZQY5VFRJuQ7AKTi4oYzXpwzEDytpW1Muw8m0kopsbwf99SvPh+EXlhvV7PFo6N27uLF4G4retonq/2UVZ6nsJqwGDCPzr75PsZhjXo87VK
 WNHL44oF
 VP0YB9rwoXgdsnl8Xa+ZREV6Y2GR/mzhn+aH5oAzd9p6IeZ/ilujVPm6q0q7rtWmbYmInpuztTfngigS7Zhl07IggffWLRAeEqnkLqGdj8lJIo/19ICGRtQ+Wt7GufAjitaCYMAzXIhGloQdXE21vcRCXEnvNzXaEUNROWj5t3vyOYSOO77jlH48Q4+9InmudtT6kqBgtviYknboyYu9a6cfK7pFtBUTsxu89QcqiAcZ+gHBa1CgXPyys2pH1fTmP33h/z+aEUzEUTxOy+1uu+FUn36AeMJkv+yet8tbRKi/tHFMDWYRiZrDAEYLjkFETAHGjVtpLUg2987FaO8JLGyVt6+v76Awa6npZ0iKfFN7hqvPDn/APpQSpcMGX+0JLg0sVPbjQaZ7UbYVe1CTDFR12S71qmT7EgOBLiXNkw5Q9WhPp9nUCgAfDoH4lV+WcGTdqjM5JR00Q7ptI7Fe2Qhq/kXlvJyHePjtPz0S+m3uES62kdndq4V7Vzdr/7E4lr1ZdVntu1sF2ypRqBSxmgIWRT1is2vg6c+KowhhbwF6B+rU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 28 Oct 2026, at 9:56, Muchun Song wrote:

>> On Oct 28, 2026, at 19:33, Kaitao Cheng <kaitao.cheng@linux.dev> wrote=
:
>>
>> From: Kaitao Cheng <chengkaitao@kylinos.cn>
>>
>> When vmemmap restoration fails, add_hugetlb_folio() returns the folio
>> to the hugetlb pool. It clears folio->private and restores only
>> HPG_vmemmap_optimized, losing HPG_cma on CMA-allocated folios.
>>
>> A later successful free then bypasses hugetlb_cma_free_frozen_folio()
>> and returns the pages through free_frozen_pages(). The CMA allocation
>> bitmap remains set, so the range is unavailable for future CMA
>> allocations.
>>
>> Save the CMA flag before resetting folio->private and restore it along=

>> with the vmemmap optimization flag.
>
> We already knew this issue. Cc Zi Yan. Seems he hasn't sent a fix.

Thanks. No, I have not formed a proper patch yet.

>
> But we want a different solution. See:
>
> https://lore.kernel.org/linux-mm/A1A14368-7A43-40ED-B2AB-C2EC2C5FFB1D@l=
inux.dev/

Feel free to grab my version from the link and add
VM_WARN_ON_ONCE_FOLIO()s Muchun suggested. You can add
Suggested-by: Zi Yan <ziy@nvidia.com> in your patch.

Thanks.

>
> Thanks,
> Muchun
>
>>
>> Fixes: d2d786714080 ("mm/hugetlb: enable bootmem allocation from CMA a=
reas")
>> Closes: https://sashiko.dev/#/bug/linux-5363eb09-9c3c-4f8b-9f3c-a998a8=
c4b258
>> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
>> ---
>> mm/hugetlb.c | 5 ++++-
>> 1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>> index 4a008afaedf9..8da4bab676c9 100644
>> --- a/mm/hugetlb.c
>> +++ b/mm/hugetlb.c
>> @@ -1437,6 +1437,7 @@ void remove_hugetlb_folio(struct hstate *h, stru=
ct folio *folio,
>> void add_hugetlb_folio(struct hstate *h, struct folio *folio,
>> 		       bool adjust_surplus)
>> {
>> +	bool cma =3D folio_test_hugetlb_cma(folio);
>> 	int nid =3D folio_nid(folio);
>>
>> 	VM_BUG_ON_FOLIO(!folio_test_hugetlb_vmemmap_optimized(folio), folio);=

>> @@ -1453,9 +1454,11 @@ void add_hugetlb_folio(struct hstate *h, struct=
 folio *folio,
>> 	}
>>
>> 	__folio_set_hugetlb(folio);
>> -	/* Clear all folio->private flags except hugetlb_vmemmap_optimized. =
*/
>> +	/* Preserve the vmemmap optimization state and CMA allocation origin=
=2E */
>> 	folio->private =3D NULL;
>> 	folio_set_hugetlb_vmemmap_optimized(folio);
>> +	if (cma)
>> +		folio_set_hugetlb_cma(folio);
>>
>> 	arch_clear_hugetlb_flags(folio);
>> 	enqueue_hugetlb_folio(h, folio);
>> -- =

>> 2.53.0
>>


Best Regards,
Yan, Zi

