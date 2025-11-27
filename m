Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 696BAD11183
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 12:49:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEC7E6B0005; Thu, 27 Nov 2025 07:49:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9E846B0023; Thu, 27 Nov 2025 07:49:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93EB76B002B; Thu, 27 Nov 2025 07:49:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7CD036B0005
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 07:49:10 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2E11F1A0104
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 12:49:10 +0000 (UTC)
X-FDA: 84156367260.21.01A7370
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf20.hostedemail.com (Postfix) with ESMTP id CB9B51C0006
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 12:49:06 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=eWq3vUQ+;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=x176uusF;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764247746;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n9q5VOXnfR6V9LlOUogGwX+MhDDdVJ0SvgLk0+PBh2s=;
	b=yO4eVXIV4TMeAuFxgZ9pk9yC3KvUlnrkZI/xsHV+1WbF7cXF309JIu8X/c5kw7sNM6Mu4S
	+Lo1CPj9WJkELQslLjmaEmel6bnXGpy5J30riaPOh6GiwKQjvNKj8yFfmZyLpS33xyHLRz
	B0GGP8r4wuGMeqvXpnBB6RO7tKIbLgA=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764247746; a=rsa-sha256;
	cv=pass;
	b=7EIfuz04g/TLGUj55bJ2L/oGRt3bBjMi/QPV+mLdnPLv8R5EUQ1vmMw5Nu6zo4Az3Pr8tk
	BzwU/msUIk4PrYkGAMoU4EzImEAOW8nrBRA7RCQ6kMYzfuEaIzFnjWaYusvUDYIsLbdHDY
	UUUtKEB9ot/dTvvvt6dDt1lLOnrUZw4=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=eWq3vUQ+;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=x176uusF;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AR9fZxd356107;
	Thu, 27 Nov 2025 12:48:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=n9q5VOXnfR6V9LlOUo
	gGwX+MhDDdVJ0SvgLk0+PBh2s=; b=eWq3vUQ+UC9iDGDpTuwCRZlLYMTDZCHD5r
	hHgwOuU0kiIpWeIy7sY272tki3MJ7Iam+F73QNzEw3vPCijCEwxSdSqQCtUXd0Gw
	BVyFSCtwGW7sSPyPVqIb8GqlzG05sxoPnUwxfdl/A/sdRMkGRdQRB4Mdk3tScXIN
	4pIbmWKXXGdJZo5jHG2Q/R5p5oXPLM1m26+40KzMAJe3a3qDLuIyOHhgaIRDjOeO
	vQ9EAahCY3Cu30qVGgZ9lwRUGRoosiR8+jzTfBAvydC1X8OsyRNLSKPsV5iVH9MX
	IlwnlUwAsEF+ZehSzNUjV/GDN4TprTSC60ZsoaAZQ90gPAtn96rw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4apm7ug920-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 27 Nov 2025 12:48:57 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5ARAaC8b032791;
	Thu, 27 Nov 2025 12:48:56 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011025.outbound.protection.outlook.com [52.101.52.25])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ak3mc8fac-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 27 Nov 2025 12:48:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JydJ9POwvlfRVbYO6uxUrTVwfZYziPgjbdj/NkjrPxFAmJBEZHG7f8ezTn2OBYrR0B+aaZSAWfTMR9grcmxvhLlfAnJGHYJXFIRBR3QqjHsN8qDeG42URCN2VbgCZwjLMpmMYK0tfngD9oxvMahuhOBZkxG+ufVAeOWtSL6XpsNTSiwdtuCC0EeftH2FjtiuT2vL5nqcmQgTsFCd9bFN4KYqwpD1kNFuUxV2HLfpDmulCAJplem/trFhCtp9F2X+sAMqJVliidvBP2fpb4V3B6FaRbIW3DwHMAXnL/dWPTeGQzycwy6oQ7P0H4dQ8pEGDmZRQH8VKvMbh+fEfsmN7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n9q5VOXnfR6V9LlOUogGwX+MhDDdVJ0SvgLk0+PBh2s=;
 b=dHvG0+bt/2Ko1+SCjWC3/AxWe3LFUqQlA//C5kf8Ale/PMlrLAB8xDyElaKbqI3yuqFZG9OLYjtlMWPyn0C6RPkCXa0cKxAGMbUx/esarhQGLkV1oaDa5Xphwg+OG/6zHcDWvGmnW2k9K9dVOVsrKjULgmBWPbGrKRwAUtfgkO93lbGhSWXsC9jquUQT78m+5DXh6WCECJ8HKQaBHyg3U670hQbCD2HYT89grHRhyY8cIyotHQ7c7A0X6VTiMh7bIrAUldrSVWk6kcOAd0DrH0eRYDbS3VD5iSHr7uEY+p1eBIEfi6NJrjGCBAK8HIOMXrK5TfB62okBQqcwe3Q+EQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n9q5VOXnfR6V9LlOUogGwX+MhDDdVJ0SvgLk0+PBh2s=;
 b=x176uusF5LK9hWsbPG0lDcedRn8nde7khIfzXhC90OxGYl4QESYVbGoZLTvW+7p97lLvLk4f7nj2x81hwDYR5Ab6u8/fDiFSLfq+lUtBwcl2Zr0NU00H4C038hj4cs24/2oyZERf7jWma9zXrZ47vTMf4+RTnsv9krOyLCEENfE=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by PH7PR10MB7036.namprd10.prod.outlook.com (2603:10b6:510:274::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.12; Thu, 27 Nov
 2025 12:48:52 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%6]) with mapi id 15.20.9343.016; Thu, 27 Nov 2025
 12:48:52 +0000
Date: Thu, 27 Nov 2025 21:48:41 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Jon Hunter <jonathanh@nvidia.com>
Cc: Daniel Gomez <da.gomez@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
        Suren Baghdasaryan <surenb@google.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Uladzislau Rezki <urezki@gmail.com>,
        Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, rcu@vger.kernel.org,
        maple-tree@lists.infradead.org, linux-modules@vger.kernel.org,
        Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Aaron Tomlin <atomlin@atomlin.com>,
        Lucas De Marchi <lucas.demarchi@intel.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v8 04/23] slab: add sheaf support for batching
 kfree_rcu() operations
Message-ID: <aShIqdKesZqEOELK@hyeyoo>
References: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz>
 <20250910-slub-percpu-caches-v8-4-ca3099d8352c@suse.cz>
 <0406562e-2066-4cf8-9902-b2b0616dd742@kernel.org>
 <e988eff6-1287-425e-a06c-805af5bbf262@nvidia.com>
 <aShFKpqPTgqshx3s@hyeyoo>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aShFKpqPTgqshx3s@hyeyoo>
X-ClientProxiedBy: SE2P216CA0068.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:118::11) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|PH7PR10MB7036:EE_
X-MS-Office365-Filtering-Correlation-Id: 3471c8c3-6d00-42c5-c977-08de2db3516c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?MfAgfy58Yqrh/2OMH6LEGPGgh4JP0bNK/USwXc7SbfZ+O5VIFOLe1TL0m8Od?=
 =?us-ascii?Q?JE2VEEWw0RL11zQYVrAwbRMp698An0zZE2gEAI0IJ934+EdNMPCzZsekxNHg?=
 =?us-ascii?Q?JLuB5SjAJq5KHusKZLTIf6g7jLF81Lvn+5hwbmg0ZlwHpdMjyXArd62RAAE3?=
 =?us-ascii?Q?t0bnXa/1Keti2pUvpv6ZW52oHLByPeU/4VUIIqJB1Wf5RStifr1iaaSBU+on?=
 =?us-ascii?Q?Paf7/BDdsaE2r3GTjaEX08J1W2tEe9roquwyjLGz1fEkJR1V57iZR6D2dpDK?=
 =?us-ascii?Q?nVM5pGXncT1QOZ96WHAQ2Q0WDigs7ID2Xvay/4RyuaM6sRHY4QtUTYCuaVUY?=
 =?us-ascii?Q?Sw/1rBqiJaZCA789dKfLghxaP0alrkVst4R0FK4+x/fz+nXvcRbrE+GCF1hm?=
 =?us-ascii?Q?M/UaFNAoPfDjeSzs3jdYGVPqRGw0bQOp/jGlZfhomDZ7IKOYGU4q5tAwdTZ7?=
 =?us-ascii?Q?jqn+HFfGGxc0lFAl0jrd4iytoS4yXDC5lNM6g/IWJV0QLeyikMCdNY2LXGw7?=
 =?us-ascii?Q?VI9NhTM/EEmJ/2T19iIBfw8bBZwMtyreCGoYJabKCZOTf716FQrhWr8YicHn?=
 =?us-ascii?Q?3WWPv1txUh7himXrJaKNDEmT6HJXsP/UpynRA44h5Ot0xZiTQBOa5gcMYcmW?=
 =?us-ascii?Q?QSzCf2fgLifcZ9E0rGRp57FatFdNTZ6g69vTdP4IoEIoF6b+Sow/bWzuv1H5?=
 =?us-ascii?Q?o/zyQPcQbqYQrcJkH9Ks+qsHrdPycjdrw9ajRZEgtm6nvd67pLR4s2gq20gT?=
 =?us-ascii?Q?Jc0a+tsUfIq6oc5ByNXHdqr3y59sX0b7/2xwC7voILqiUxcvxFU/vg72ps6m?=
 =?us-ascii?Q?LmdnKrmxfrkM9GjGyPjVzMvQfF2yih7i9eJaGAzw6Kz5ZcY0te4A4Xcut57X?=
 =?us-ascii?Q?dsGZE8kjnT7dCULBFaJqaqeZnyE/XEGLWtDrccawm36DhRxOl9Snfas/q04r?=
 =?us-ascii?Q?vk2hkYmf85o6Z82fTQBR5Wkmfyuz0c59rr1pHGxmOZsQVUQ2kIjnxKxI4gKw?=
 =?us-ascii?Q?ZAPnzZQ4Stj9QZGlOmWxLk/0DV1XsEJxajn/Q5GKGq+GAeRzHK5u8JDIxo9y?=
 =?us-ascii?Q?sfEOPrxe2EPHqOqknDJjIfyVkpPWNcYDQOvPfHelhFcwa8uMQDU0foEasVOe?=
 =?us-ascii?Q?L2sf/nlTeGjZKBt5rhAcraK25riGEJUwZCBIGor/tGmSi/a91ECIyGv0s0Dm?=
 =?us-ascii?Q?0cviakq3RpTg+ECHETU5kNopaW8UtQbk3Yr4shMEYth8nBiZ6T4tPG22gWU5?=
 =?us-ascii?Q?pTLL3lv03HNKRljDLNrTYBjAh2fyGG1IVR59myPpGFzM825HvrTh0oFehtn1?=
 =?us-ascii?Q?MOeiH6WUHdvLs77rD1IYdaW69RKjiP6V9hpnreEX/pi20GLZbKJ5kuglFRlH?=
 =?us-ascii?Q?dWU7j4NODkuJCPBSFhG+yHGQ2neFe0oKJNbDKOxM9EuCWqNYJlw15NBk+f0n?=
 =?us-ascii?Q?EvD4xf2THy0yO84UJhRiFfDKXxj86HvO?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?I58uubpp6jjHXJOKInD5mrGq5x/inKKhZSmiE4xsDLsG7kI48RzZyfRslXc2?=
 =?us-ascii?Q?DYlFqx0s75VHQiChqG6/Vy1EAQUrIlI2obwhoDEy2VFyCv1zPwzlH/BBLmvH?=
 =?us-ascii?Q?mIv9TcY9drMmFGW9jhhG3vPksO7a8GU+2gOLNtkJzduPszUPDR4u1/EXQwps?=
 =?us-ascii?Q?kGZoO/wzsTxZELMXU2VlMu3otZLwclR2wGV4flD26L+9dQqoCAF6F+Sqsv46?=
 =?us-ascii?Q?rQ66voAR2yMOTqIbuI5w4iNMq2hXHHsiTNLbj4aIqsiuzDgIkoXsAS9yynay?=
 =?us-ascii?Q?dTtnFuQMktKvXWqwDV4pUDXe2/A8P4/Dws11c2VpZfBFiQeNj07nlWkgowit?=
 =?us-ascii?Q?t0Gubrg4Q0uAlIKFHc6j/H6C7ene8BegxLYBUlQqfeBtN+1CRNtXkqr48mKi?=
 =?us-ascii?Q?3dYErcwE0YuEn+BDl/XA+Iw+gCJZS18CerSVdLpERi+MFqQCUH8GVXVyTbZA?=
 =?us-ascii?Q?+vchjby6Yfzd5OT6U3ssAzRem6Vn5cL+2BTI7uZ4glhz235gs94OFL257Fc4?=
 =?us-ascii?Q?Rvrz2JqDdmv+rkn4aPmy2pxs/5YVGp+ibRdaH9Lk4i4R/EsC0pNcYh1ua3TV?=
 =?us-ascii?Q?cig916H25PO+w24funxtfM3ZOoD5kRYZ6xVk+pYrjGW2Ulodg1/CEkhl4u5K?=
 =?us-ascii?Q?L1d+5JFmQNA26vh2x4Y8Y74TXYiVzDZ3fBsN1a+0moRV5dIeR/4OdX6dIogj?=
 =?us-ascii?Q?l6XijxGTDCe9+IX5ZAMW508elkSI23lm5oy8OhiC8aD6pL2808pS9/I4PL0M?=
 =?us-ascii?Q?X6RpiU6nKdNLZjeapHNYzZ9zKz/V/xqvfo2G/VZRrBymRj8cGMs9eeUklwO/?=
 =?us-ascii?Q?o+T+ZNSEZqm/oMP7nurvNhXPRe7SQ3yGKO8qeEEd6OYWSEiSdHEprtk9Wxjr?=
 =?us-ascii?Q?+G3KCG/VZJ5qt12r+JtP21WeV1ZrPeM8ftLQffbW6vzOXQQiOW26iFqR+yaR?=
 =?us-ascii?Q?TtP5QPW+opaMEfaqdsoaqzFKiwvkkICaL2b0tZVfFYew2Ct+TwFQ9YkDdVUg?=
 =?us-ascii?Q?vnVcIkYbyCi49ZpvAiXGF3Hh4XVWkWZUKlWYjL3X53Jd9dS8L6Dg01TQWkrC?=
 =?us-ascii?Q?JAljf1k9jM8diUD85qwS4q6K6Bf4YV+iuLy5kkQzlrRGFjTGYkm+FPas/XL2?=
 =?us-ascii?Q?Xp0Q1t1o8vKJm54jleT6rvVTDmJjglHDd/tuKKq1/1Jg/WvONcMAWn/SCGgk?=
 =?us-ascii?Q?CNV87v/u+xbRU/WD4yUrXT+EOU6K5djIve2gs+tN9rchQv7WZaQro2Q2N61r?=
 =?us-ascii?Q?9jpsqW3ZopsQ82FIeScjUowMz7/J3n6Va/fw+UUiV/uihq/NtdPCXvgDeHXj?=
 =?us-ascii?Q?F5ql2Wu7B3VA7c6h6W+bIOz/n1vhi94n9KPNA/koolFGL3GCggB8vN6dWvf6?=
 =?us-ascii?Q?Cj4PuJ84l/jDF/lgsusTgyeTJMNP7aulFnjMQa9KsDv/IVUrYtBZc9flvyet?=
 =?us-ascii?Q?FQXrPYEBs8+bX0spfrjLLJlEttEdQS7+fJULVVFYoST9+SPsEJ2urUJROngB?=
 =?us-ascii?Q?B95S82apxF4Hcj0BQof4WwLwo2a6nl4kFc5v2exd1FAczKkNL3rvImwoF7MQ?=
 =?us-ascii?Q?xfi5xSuqq58k1FYDwBBM8Xx68x7TwQw3HGrUhb30?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	I4JB0KDCJj8h32aWGQfz3M0de65t/XrSHw0qBxhC/LXZcpPvXI7fsfdxIlgJW3osO12j3tTGg6dm2BO1yDdfPakiDk11UNbQhcCcWUGvVtJp3M9dxO81WJxjhdYOGWkzFT/H/d58GX56IFpkGyrCwLwfbJLaV5rmc1kpYMB7h7spQCDbYqhfU1LfMAwO7f5Pnsfk/w1q8YXpGJz/KxsxA7c5wHDE4+peKITreLhNKRPoP+f7z7/Pe5pTV/gSq7IHIljGqaSnc2LlMmtRw+0XJxFQPdJnlAnkgIOXvtjgwyr7WSGMNpSg40NPZALtX2jqjqh2IkJbBI/J+tyktGeKlzc5N99Fn6RtFowLwvz2e3GVU1+q4hOGRTylCSL24H4YZ9zbnHS2kcgM/U6F4cCfmiMUU/95cQIrWIgU2YvfV4aCKCt9sl/aMhq/1ffjTrg4+5cGKSK4FrWQQ6Qh+qTgb2L73qpkpa/ZEzuL7YokfwimBnGVCqIHQKpvhUQtbxDPQfdPe5ROH/44ABAcIrW/J+00gMVKpLg329mQIjgQEEYptNWj9gi1I3OGnhFt2cheDr4r8sFsIuqesyH/+RCGGclqbiGix8FzZGT3x80abWw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3471c8c3-6d00-42c5-c977-08de2db3516c
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2025 12:48:52.4843
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gtmKLdr3zckkXZeBDE7JwPeWJmK9BNxO5cyrbnN5kh9NPn24kwG3EjWMTmkqlzeff48acyiUVOdbhdJAI3+6nQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7036
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-25_02,2025-11-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 malwarescore=0 bulkscore=0 phishscore=0 mlxscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511270094
X-Authority-Analysis: v=2.4 cv=RuHI7SmK c=1 sm=1 tr=0 ts=692848b9 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yfD7rJDz0UvptAvCqdMA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: l_KxT3fpNlocDJKd0QKmil_Tw3Ae5l0H
X-Proofpoint-GUID: l_KxT3fpNlocDJKd0QKmil_Tw3Ae5l0H
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI3MDA5NCBTYWx0ZWRfXwxjzMzXcAL2X
 ymTnBvBFba+GRuoFKPZZeViV6P3KXGWmf390Va46t2iAswwFjqtVDEqDFJo4K2iV5Dx3RFaVqoa
 1xREGfI4piTFNVFiSx3feVbSoUCcfHZJd1DASjo1AxjhZNx7PXQYwvncyqmUqMNQaZrtXDvoizl
 6zbdgS4qb61IVg1z/ZJElkw9clpth+gXjBnfSRVLhpmYS4rXEZRRrbHOCjRDuvGnXivxdDUJZFh
 wKynUAq8EGdTcmoMDxr1/e6baJ58Aqf4wlognZOy7obc/QJf5OsJBYzeaQe+V/6cxH2udZSClUo
 yNGM9jnR4P3zhvekhzh96/LQJ78UboKeqTK6iKXFXleDLyAqr04Ff9zKM+X0hZaN0W4V9vKIAOI
 8dZeFB+gcGcxt2WlaOI2yLq2TYPK7Q==
X-Rspam-User: 
X-Stat-Signature: kwadjefm16tsgffw56w1xw43xiqt9j6d
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CB9B51C0006
X-HE-Tag: 1764247746-98066
X-HE-Meta: U2FsdGVkX1+NyHN5SyZ/3cPMEt8Ke0PAusEx9bg/HsErzUy3tC9nHYe9L8eGgGIUy3HPx4g2ncrLL5PCyVW5AjUusmTAQLYAUnq/uP2EPFNIpMFFcFsXTLMhn3oIYheHv/vSEIVIiLB++tiocjMTYc5OD0sCeOOUn4NTgtv4iXQsvJsxNt986aA6QikEZv2YzQU81s3x4t2xY8gVAw46MMgZN0r9COYRuLqqX6maRsFWmLOWkuQAY+aVxzpVQVScZlJUxoVQazhlpyfa7EBwFvKyKm2p75nFA67OL+UlPyF1R5Equ6AJRTsDgst9BJgiSD8j8Hw4MuO+ijp/nEIrKAPOOWh0UY80gHInFKUJlYWWmjfu/+MlVMCsZvkrRZZgxrvXbsJh/c7mG9YizxkruQfh3QgqGzCPoUcWArZzfTyHvhk1qxsdSTEsoQnPd/Q06E4v0TNJRfIHeuHQPZpByMdkjPmhrpKxJf5ajUS/86flLmcwjQBjPFaXkY7FlUIiFL6UZdDHtZmFpfgtixmqE9yBSKudbEkAfX56kTARhVKNlNysejP0j+4lxZPGBauWVuvhCNHCa+lrVuD8zNcRn7JDcjRyV352IDCihAW8ntIii5gts6k5WNu34RGeMvVferz8CqRwHo3x9+J6VBPbKEygXe9napuxeQXILmeW9TOf08Nmy+GcgEhKeLCtCM/9msvx6WrCJtlbdb9Zkl1YlXll5zC3qDSxdu3nm3mnx49ayblbz379TOseFL0eGjY3c7yMrB3gyr6RozyB+o5yVuMUXWZRDq32MWYE0hM21xCZxRKQ+kYPc3pgQPmZpusLS1HSgXYeIEWTJXt7/4yBJzTyjwYRFKC0gVNHXkNMdEcdzd8GzCtt73FXIzUa46xc5MwRlQywW4gXPRLN/3eVJseQr/qKNl79CNe+po58CjXQYU+dJcZwIevbxhw6pw+DLBbS8ouRJo+d7zyNb88
 LUAFkHRz
 On6eSawpw/qWF43v9fQ5srjzdDuz1deG0UpKTUM/9lySjMb2FJDtVJCe43EK+igq/NNUYH996xRW8IQfph6eCFbWHaTLu5/3i+8smcqsR45UJVlQRo7ZLh68du9151UeV53Lf1VdPWVUJFu36i5eLka21gr5SYafsYnhS10iWaZLNMUJS6t9RnvmSG/2UBAB0tONAuUr7oZXajN11+KyLmFintISfGC7VXyfszu2sT8JNRdPBZ9ma49pMTdWFiBkh98d4qpEmUpfw6Tka3cLnVc/vqMdE1UKmFYhwM4UPye0nyl2oOSYoNudkTA9B5XghZdWQGkR+Q2JndRRX+Wrzh6jPXXnJ51RQoh44flBYv0CC2yYYwkPHJU8pA6YGV2sqDc9wb54tQdjZ0f+br2Xny7I/Ry5gvAjV9grGKLn03pAU6F0HFb7pUroSFpn0y9waNDHq68tD7jG5LjzlJvboqv58Az20JKM8+rr2KsN9rEeO0TXWXvM+RJKmDnt27eW6q5UnLzs5buWkH8+0a/aQFVnRUoYx76dVsr/YrJE6s3fSVhaRGPy1yvpP9Ttni6ThJUDs25gOZ2Xx3Xs8vNnp/wfKk1WoPBan0LsbvaPix56CiikFHro6l30nxtFyOf8oo+ZRwU1HggqR2AfJPG+x4dIPw15SMSCVtQptHd7g2zdihpGGQiROE4eibLXB+USdN5Uk5TMx8HhqfN4nU+okIaPb5A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 27, 2025 at 09:33:46PM +0900, Harry Yoo wrote:
> On Thu, Nov 27, 2025 at 11:38:49AM +0000, Jon Hunter wrote:
> > 
> > 
> > On 31/10/2025 21:32, Daniel Gomez wrote:
> > > 
> > > 
> > > On 10/09/2025 10.01, Vlastimil Babka wrote:
> > > > Extend the sheaf infrastructure for more efficient kfree_rcu() handling.
> > > > For caches with sheaves, on each cpu maintain a rcu_free sheaf in
> > > > addition to main and spare sheaves.
> > > > 
> > > > kfree_rcu() operations will try to put objects on this sheaf. Once full,
> > > > the sheaf is detached and submitted to call_rcu() with a handler that
> > > > will try to put it in the barn, or flush to slab pages using bulk free,
> > > > when the barn is full. Then a new empty sheaf must be obtained to put
> > > > more objects there.
> > > > 
> > > > It's possible that no free sheaves are available to use for a new
> > > > rcu_free sheaf, and the allocation in kfree_rcu() context can only use
> > > > GFP_NOWAIT and thus may fail. In that case, fall back to the existing
> > > > kfree_rcu() implementation.
> > > > 
> > > > Expected advantages:
> > > > - batching the kfree_rcu() operations, that could eventually replace the
> > > >    existing batching
> > > > - sheaves can be reused for allocations via barn instead of being
> > > >    flushed to slabs, which is more efficient
> > > >    - this includes cases where only some cpus are allowed to process rcu
> > > >      callbacks (Android)
> > > > 
> > > > Possible disadvantage:
> > > > - objects might be waiting for more than their grace period (it is
> > > >    determined by the last object freed into the sheaf), increasing memory
> > > >    usage - but the existing batching does that too.
> > > > 
> > > > Only implement this for CONFIG_KVFREE_RCU_BATCHED as the tiny
> > > > implementation favors smaller memory footprint over performance.
> > > > 
> > > > Also for now skip the usage of rcu sheaf for CONFIG_PREEMPT_RT as the
> > > > contexts where kfree_rcu() is called might not be compatible with taking
> > > > a barn spinlock or a GFP_NOWAIT allocation of a new sheaf taking a
> > > > spinlock - the current kfree_rcu() implementation avoids doing that.
> > > > 
> > > > Teach kvfree_rcu_barrier() to flush all rcu_free sheaves from all caches
> > > > that have them. This is not a cheap operation, but the barrier usage is
> > > > rare - currently kmem_cache_destroy() or on module unload.
> > > > 
> > > > Add CONFIG_SLUB_STATS counters free_rcu_sheaf and free_rcu_sheaf_fail to
> > > > count how many kfree_rcu() used the rcu_free sheaf successfully and how
> > > > many had to fall back to the existing implementation.
> > > > 
> > > > Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> > > 
> > > Hi Vlastimil,
> > > 
> > > This patch increases kmod selftest (stress module loader) runtime by about
> > > ~50-60%, from ~200s to ~300s total execution time. My tested kernel has
> > > CONFIG_KVFREE_RCU_BATCHED enabled. Any idea or suggestions on what might be
> > > causing this, or how to address it?
> > > 
> > 
> > I have been looking into a regression for Linux v6.18-rc where time taken to
> > run some internal graphics tests on our Tegra234 device has increased from
> > around 35% causing the tests to timeout. Bisect is pointing to this commit
> > and I also see we have CONFIG_KVFREE_RCU_BATCHED=y.
> 
> Thanks for reporting! Uh, this has been put aside while I was busy working
> on other stuff... but now that we have two people complaining about this,
> I'll allocate some time to investigate and improve it.
> 
> It'll take some time though :)

By the way, how many CPUs do you have on your system, and does your
kernel have CONFIG_CODE_TAGGING enabled?

-- 
Cheers,
Harry / Hyeonggon

