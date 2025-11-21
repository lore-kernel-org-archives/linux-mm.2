Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4CCECFA753
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 09:10:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 315FD6B002D; Fri, 21 Nov 2025 04:10:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C58B6B0030; Fri, 21 Nov 2025 04:10:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13FB06B0031; Fri, 21 Nov 2025 04:10:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E138D6B002D
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 04:10:48 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 040E1C04E8
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 09:10:45 +0000 (UTC)
X-FDA: 84134044092.26.891EF6A
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf13.hostedemail.com (Postfix) with ESMTP id A492B2000F
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 09:10:42 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=SkoTkaCY;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=mkmBwieT;
	spf=pass (imf13.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763716242;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BQJLha/934dLMALYEob5gX0sfp5xQxm+ygA0NAXPGIY=;
	b=Jj8fn+YywNcQDWujl0CmRfK8xSdPOtcuuQ24xSV/cWao6EQvhm8VNsFyKRaUE1Ii+4UZ+l
	VuB8SejTUnUPD4nfGSKHJQW3WZmabuvX5mIw+4J7flN/IXrUzxsF4HrDnik3u/bOj7L5l+
	BRKFPl0ex4KWosvnnqUzvNMagqQtTYs=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763716242; a=rsa-sha256;
	cv=pass;
	b=AOET8wWVnF2bJ59ibiI/F4laCRVadWU9BveTpvGkrn7RnA7FwtNausYkSARdsl/f5B5ZXV
	8Erw2K+MlU8ymXRJRhkXA2UvL81Ct0q2jlEvYuieIg8N52eaHME9o/bZz8/NEcyZg2efhE
	bY1wmdqRb+7+SFzSZssrEQroiDXLK58=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=SkoTkaCY;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=mkmBwieT;
	spf=pass (imf13.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AL1ujhZ024731;
	Fri, 21 Nov 2025 09:10:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=BQJLha/934dLMALYEo
	b5gX0sfp5xQxm+ygA0NAXPGIY=; b=SkoTkaCYTnj1+oa2GjyCNpvjVUBjg/+ebl
	o2XfWMjq8EsCNznd/b8y/lZgqjs73T0REYMiwqU0N1sT7ecUqFQiB27m/hRJL5uh
	rqamJBvnWbpaEmUPELF0xe4dojwrEYxwj1rv9qzURauX4TYi1l2Rr+cTPLz4Ejrh
	h4g5VjZJvKVwzU7Jhc0UP17Wdo7impsPFTuyqqHR3wK9qcWM6KPGug7JzDsz6hom
	f4DyHr5L9YxGye1xemFwoHDuB0q1ctyxV+J+X0NqzHgCY0Ubazmrq3MsWOTBhAGQ
	tG9jHOcihzIrRr+iF48ZkcvKyoppJwdFPMujcUlk5L7/lMAamvZw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aejbbk0ta-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Nov 2025 09:10:36 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AL7K24M035868;
	Fri, 21 Nov 2025 09:10:36 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010050.outbound.protection.outlook.com [52.101.193.50])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4aefyqmbyx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Nov 2025 09:10:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Qi8b9v3tkCVoLxRBt10kyiAjpMS/AmT6C13NrLAF7vHvymu1NfEoqgwEKoWBz51w7czQq+lRJBu0lMEtcu1/HLWrx+Jw6dotffYtV7JFnYEnwG4rM0/PSB/dDU/ubR3q7A/op/1maYk8OqGBabto+YQA10h/XYXhevtgiEzBiToto7Py6RXDAwG541va5s9v466P6bOQTmOW9qTpPD6iJp1bKeAh2tfEYR/I4iDk5PKI6vRoBLHNepcoeG+HN2QoB5wAwQDpVrFigMF0Q0xfzjOBljSUVZ/V3ipXZ48zbLdlkZpg8ygc8aXlHgGMftYKyq47ykaCX+AGWJS27cM4Og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BQJLha/934dLMALYEob5gX0sfp5xQxm+ygA0NAXPGIY=;
 b=mjmZvVz09RceALjhT5OIneMaMD1O+DDqcswdBnBGFTmQdRte33dGZ92zm/CjalZpDBZqnWHKk0tB1uhFy+1Ln/vCi+D3QNPBALBqMvx5eN/5Xgv3rKnG25LK51OMSeD7mEEYcNk0ullVm0LomS3z2fN1quRtsrSf7OKFRIhwEgKUhHGddAaH5TG19ot61iOsfXR00jo8oMyTho18RsvmV/rsvEha20B+b6NPIpjSklai026bFzrDL8oO2pYsz660gBuBFJUymZRWPiu3tuccmE4MdEZm7vpWAt0RV9hJBKXybB1kv6nqwHOEibPjJkNMmEMLUI6NFggEb2ZHWiCiBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BQJLha/934dLMALYEob5gX0sfp5xQxm+ygA0NAXPGIY=;
 b=mkmBwieTHEAjT+KOWLtILt7zgb2nJQs+6UK4jFw4ed2L/VgI+LZgRG+eBP1x20ZxrW07CgvJ50v65GDE7fUAz2WXCP9pVmiOHErZc4zsKKLVeyZLNi2AcyQs53A06uU0GHIe+ESyhOosvULavjRDpomd/FmIwEjqIk42yCSyIxE=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DM4PR10MB6184.namprd10.prod.outlook.com (2603:10b6:8:8c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Fri, 21 Nov
 2025 09:10:33 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9343.011; Fri, 21 Nov 2025
 09:10:33 +0000
Date: Fri, 21 Nov 2025 09:10:27 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>,
        Vivek Kasireddy <vivek.kasireddy@intel.com>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>
Subject: Re: [PATCH] mm/mremap: allow VMAs with VM_DONTEXPAND|VM_PFNMAP when
 creating new mapping
Message-ID: <a752bfd5-92ad-4283-959d-37f39bbe722e@lucifer.local>
References: <20251120053546.2885836-1-vivek.kasireddy@intel.com>
 <976e9916-c949-4fa0-b92e-87f6841b5cbe@lucifer.local>
 <6e415c85-9ccd-4029-91fe-557d3946ef51@kernel.org>
 <4fdd31d7-2814-43ed-9674-d4b15b0ed780@lucifer.local>
 <584eeddb-9a21-4eff-a5c0-446204f9e59d@kernel.org>
 <75dc53b9-bcd3-4271-ba7e-2762bec36e3d@lucifer.local>
 <cad8a1a4-8eb0-4e18-99cf-e19f23cd8a0c@rsg.ci.i.u-tokyo.ac.jp>
 <9bc7573a-ab70-47c9-b6c2-4269479bedc6@lucifer.local>
 <c6dc4179-b2c8-4991-8bbe-662dd32a31f5@rsg.ci.i.u-tokyo.ac.jp>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c6dc4179-b2c8-4991-8bbe-662dd32a31f5@rsg.ci.i.u-tokyo.ac.jp>
X-ClientProxiedBy: LO4P123CA0535.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:2c5::20) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DM4PR10MB6184:EE_
X-MS-Office365-Filtering-Correlation-Id: 184a5f9f-2d68-47f1-5231-08de28ddd337
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?iy4Jwcx1IOzkEDG7DKT/fO9u77j+zLD6bcCd72BVnMTC25Q0a92g8gTj1306?=
 =?us-ascii?Q?kG9yZ7xeRj2Cbrwpsh0gxyQMfCl543NPqiBorYqT8qTCa+JkMqlXhNNeYKKm?=
 =?us-ascii?Q?8h4+E48jE4v8n65NTSk+Fwc5o32j0TkCRN5SeXeMWL9iuxwC4EFrjoJ4xoXQ?=
 =?us-ascii?Q?DZo+G3ixNkEhdAdcmDsl0ceTp1Y4RTyQHGObiwf/H1htWINxII0VzZ0yLvTJ?=
 =?us-ascii?Q?hwiHoAeLLZQPokpyYs1A5JPWZX/qM1aWBoQdo/uZpt56N0aYPvH4pua9aGlH?=
 =?us-ascii?Q?yy8fQxu2fm17YpTA27+2lKKITRd8xCVMaEj0ST0kXN0JlczgL8LMLI/oCgDv?=
 =?us-ascii?Q?eK22KcvtcEcLzxKtZvWf4W/nj7KodyCJVVajIjo5iL848RTSzcVWKehQ1S20?=
 =?us-ascii?Q?N0xA3LVt3yPhh2pJB7aVY7AisyhaosSWzwtFM55Zuu3iJVQ6NK9grjmp8tEQ?=
 =?us-ascii?Q?z4dThOA3m3ASh0MWw2AUnSAeiV5cVJXfEfLsnvK2F/rdqfm5Ii0lDSnyW55K?=
 =?us-ascii?Q?z7hYoWnwgGtSKDRCaUKoKMzG3EeM3L3HDtQzvWWhOZs5xeUqfranO9ervE7S?=
 =?us-ascii?Q?finHN0IGxR6beX57m8V4L718c1u+CWQR56q+WjaaAh1Q9kq5lyIET0H2Dxay?=
 =?us-ascii?Q?vwsgMO4zaMt5HnD05fdi+xbKIrh+28MmEU/tujxjzyuX+1RXQGZOuNsot8X7?=
 =?us-ascii?Q?DAgj5j508Wt7GQj4dJtmRENI2cVfRgEsUrEpXJmetUThKUldzDCJ1RDu0y+8?=
 =?us-ascii?Q?4EL34jmERlVlOHOqwXd0wArdROb7Rjnpo+mWKO4Xxpz9l2lGTme9GiJ02LSy?=
 =?us-ascii?Q?wCc9rFv4odq1EUh3rH7jYphcKpBPJdJjYDjRje8GdzYOlUGvqTX+1pPLRKB9?=
 =?us-ascii?Q?OMGAkYHbcFUJKX/7gCBMULIkXHqwJk3mRqtSXz4DAMn8ZehQs2FJv+EUuOcZ?=
 =?us-ascii?Q?tNEmtnRnhoV6br4/HCx3DbK4kjZFi05vNQupu44TdVhy0JKBnAgJE/q1tt5N?=
 =?us-ascii?Q?9A1mUPDCU/a+bL01J7U+BI+odyoE1OJvO9HX5s+qSMKdWrZ5IFqB2iD8RORy?=
 =?us-ascii?Q?uF68cbtXkPq3MQRO1OaAmX9QHblZ0SX8kUNKSmtcxGYANZXRPZKZFbyJgCkE?=
 =?us-ascii?Q?GC7PUzz8GEbcg7ji55yJhdpyE2XxoxE2c4Lx1cKQ1lA3SQ80lEOG8vxze8XR?=
 =?us-ascii?Q?Yxc34jM72hFydauTB/Vdw5zUqDqJoLRCOcY0IyZK01yVxNHh4zPuiMGCUvM+?=
 =?us-ascii?Q?cbnZN04cu2sKhp1nh8v6emYvHROhDet7bLPdCDAXuu9BISFy0G4G1FPS0IXL?=
 =?us-ascii?Q?JGeXKmHV+konDEBr4n3eqS89M3m5NqKLzmxfQe/DVpIvsSPJrQOWk/2t5Wxb?=
 =?us-ascii?Q?H8dZ9KVI4yIHMCTFp6gN/2z6htbjiyfWA/SLhkPRHyEiyRQQzH8RR42ZRhD9?=
 =?us-ascii?Q?mH/ocsEwBaA3jyh5b3rEWg+cXRbBxrCi?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vt/1hNtRDWUdHNBhEJCcXzXZXN9HtbchlTpRQMehT9sxqeLtQEwBaReF5DW6?=
 =?us-ascii?Q?2ehiYBvcpn2BWdunQj69lmVzDq/hvL22dQGssFDUWlztGKL23ABtWs9r2gU6?=
 =?us-ascii?Q?8vvI3I35wBQHNV6H0AG+emN5JAePQpZhkokgBcQnyMSyLc7YlnQRwdZxUqwe?=
 =?us-ascii?Q?FKmmLlE34bAp9faITddePvznJEOEhktmZErb6ri+69iwWu38nCj3J2foieds?=
 =?us-ascii?Q?/HfcI0sig8c2mwh74vLP3yZj530+W68d8bP8MVHyxxXJkwFfBtMVjJQkg0uF?=
 =?us-ascii?Q?2/fr5dNysNe5eqIx7IbvJPks5Wk+Ad1UM4K4uV6SAoHZYkpbg+p1laqTYC1q?=
 =?us-ascii?Q?0j3nBBvvsJie76VHZ9SMo9x/OI7cXwFRLTVb83vBCjQWF28fXXIpDdE3Xmhn?=
 =?us-ascii?Q?n4gT5+WU84UoLIerDNhwkbyeFfZ3QgxZGZP4gQUKoPvLnQ2Uf8U/w5cXcLWd?=
 =?us-ascii?Q?IkH1rfbBMNbWU+PGAYeGdIFuO99nZHZo/kxHuEjbkNcrv+EbG3kwCaRt41ql?=
 =?us-ascii?Q?Z1bHJq/1nEl/krrZJd4lYUAzk4c0foA6h+bFp52lBNC0sYqBaKqEsnl4imNW?=
 =?us-ascii?Q?nGvzQfV63C3CeacL7fIhDD5wQt7MULmXNT+Vhv7m60adAqP2xmTH5FZPHCY+?=
 =?us-ascii?Q?vY5zidqW24QK77VQPUTl50Y+xGVC1BI8RFV5d0Gr6L1whFznQFYEXabmDRi6?=
 =?us-ascii?Q?nEBkomKXBlQQW+FuS3P6Sx3RJmYdK2XcbYvChtpz8/EAsd0tzHcMm47U2DAJ?=
 =?us-ascii?Q?QC6cc/Dpw+2gtFdh7EyB/ejoj2sf7e5gYslKsJ+/7KkeJVGQ8VXh8CSq1lCW?=
 =?us-ascii?Q?a1b9AWJJZrU+M1H8zKS0VmESnj27iA7wbkm//z1usPXTLbAHiXnnpYlGKwEY?=
 =?us-ascii?Q?yRSnOp3t8z4W+GJuzJFoPmq/5qppb8+XK4Er+5iTRI6Mgs4sJwg9DIWCjTYy?=
 =?us-ascii?Q?yNHd7ei8KPRhki7nqKu/ufnry4TtQEXSXALfGoFMTC5ddcINXv+J9x7VpaU6?=
 =?us-ascii?Q?A0yYthS5WjZPUK/fQ/UCTSuUmu+b8qEH+yGiI0f+mji/TztNEPVsofCrCdII?=
 =?us-ascii?Q?GRkGZ7m1mudw5qQ0umPIDtagClmen3CHvc3Fryh04oJZbbmNFvEtKJEoNZdS?=
 =?us-ascii?Q?y8iAHId5jmzc8zBF8vXoS+klAwrRuwDYAsNmMjluKu9ygKu9Pdw4Kz3Ul0QD?=
 =?us-ascii?Q?YKSALxTVkRvA9QkLVzuCgHXTmeey8GS8TI0ZM7O5pMOsbLWw/6VoYtIvaq3D?=
 =?us-ascii?Q?rUboz1xC+8xjPGybDi3a7/42PM8lwbpi/Djr0R/E/b37sZfvyMUOaEGyNKAp?=
 =?us-ascii?Q?N+wUZS1jcRxmcR8XhCKJhS5G305D9Ghv3kL62u+oymDG9bfEJDnN8oOw4vPK?=
 =?us-ascii?Q?eQtV6ahaxnuQHLnyqwkVROvw/NhwdQSObKn2h18dVvx3Qnusi/efgy5TtcFu?=
 =?us-ascii?Q?r1CLku1oSmnnCCu8hpkdmiOwh0Bi3kpXvSf4Y7hkRioZxu4ojpzHtrfgD2fB?=
 =?us-ascii?Q?hFtmRjyccCfox5y+UbBNQhBqcAPHtoAlhReR4B2ObU6/3/4BlaoSCqAjF82H?=
 =?us-ascii?Q?vG/mJm8G+oJzEiMpT+HzHcXv4G81p39Eil9f8NY0z/F6VnNNTKhfeOvLND4/?=
 =?us-ascii?Q?wA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	8Mwq/sIOj5jDCx5DviLhxsCo1QNtdJaVCfCNHLOouugyosTHAJfT3C1yCaKbCJb7bBHDuxGqUI5vio0HocC3IOtfEEwgYhwlmiQINfQ2Re5rXh2YvA/UPB+OBft4zN1d/r+eVnNILyFk8ZVObw5180zB6+7jTGuXcfubnSZWTumTwfPwalhfErUUSVtUQJThE6EL94YlbJwdG4GyOH7ohJKhgO9+xm4lveqv1jOpQHSVS+FNZk9v24is7HXzbKqecN+b0qtDPZyU0eMhvodnzqf/a7R+kJAQkbYCSuAGyfubTFLqIH16psvA5SWp+dRSlpbG4jD1+UPaZ+7P0RBhZjflIHl9HS6ZqUmHb0zVGIPjTNzJDc2JFYjK8yHR64s96DVx+NsYTlowgg0h5EUAdfZY0YbsW+3lTJODR+/e+GvFdaFf3+0zBijYWV9SAlSAgECmANKcHwenFdDG0aGfMZ/4nTd6Pmmoshqs3b+33GUN2Hb7XNcp3ofr+OVmpTolIiBeO5piqszkrBNSyDt62xQJ2qlRQ9C6LML+tT6jg6IwGQtsXwFI+IJLswVVxH3wnjI8hJkEcEBXFyZMC2tomX3CSGF9mRjAL55JCCy6YwU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 184a5f9f-2d68-47f1-5231-08de28ddd337
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2025 09:10:33.1537
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: li9AvueG9U+vr/tPMLOePFdmWiw/LCpBYn6yKTsVwkEAy03d7SWKJ+jIVlx2IwgRSeTrGyTgeavQ9qvUoqVTkEi3vZcuCnVDzNP4oRgT8QQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6184
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-21_02,2025-11-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511210069
X-Authority-Analysis: v=2.4 cv=BoqQAIX5 c=1 sm=1 tr=0 ts=69202c8d b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=pj5SbZ1fNckGF4lwIfUA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12098
X-Proofpoint-ORIG-GUID: jhNNF2PNQbgxi66YBIg3vmJbo0Hozzzd
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMiBTYWx0ZWRfXz7sVopz1Cn3U
 8j+jGclAN0CVnDWPtbbgpSlvXDNnt4cMMzamOxBWd3IIW5kw3Drr/DgrcuOyYksI+NWOGZVLdH8
 +o+gJB17vcqh2GhRLJWn4cKrne0jmTuiBTmzlTGQfkNiXRtYgH9xDn0/pKlwov7tBYY73gaEKjD
 VypHgpnhi9C0N56WRjWiX5p0Ldm2Sk7ggjwyQKwDgbZOWZ7w8jQbb7FCMJ4yJM8LMAEP1+bF57Z
 MzdkcbQCy5i7HjEOYhRmMleoFRU6BBKj/MHXp4xRbUo17ZFf94ux2ThCI+fZGOr2ru5LpD7xJ4F
 u/Jc3Lp8XKWNeVssmQrJXgwUZi/PxOZKGoGy49jT5WU8T8vPLRZrcwayuDVDEy1QGwoBC4an9n2
 3x9hW6fGNsLRgwPDuDkZg65PiFc4qyBh7O5MfkFVcfEiKeorY98=
X-Proofpoint-GUID: jhNNF2PNQbgxi66YBIg3vmJbo0Hozzzd
X-Stat-Signature: giuezikguzcycooesuciktcsfgutf9m5
X-Rspam-User: 
X-Rspamd-Queue-Id: A492B2000F
X-Rspamd-Server: rspam01
X-HE-Tag: 1763716242-592848
X-HE-Meta: U2FsdGVkX1/0Yy64wKiu1DpT6q9DPVaWZmDKxZIT75J/3+7f37xdcozQC3kbPxLWr+L2DkE7ACmvJT6FuJHLci/RiXormRyeTn5yS1G2bJayEC56uys5N0kA8loSsDUNk4DfNcwipdnO3qv1CUVW/j5Za+b0dcWQQQL+RvpinxBFuyDe0UfeDADnoJTXE+pbhMMIFhKBgXlNL0JtVUnl/M+21ZHwMzLOfVeW6CdBGkHbRQGhdhA6EZwGlSJ7fC3GQkXoJP5iAkWbmUM9reLlf9GE7GDzWZNgWmB3n+eKaRAZzOEixIZ3DZAsmB9cvOgCTJFWuiOWIk1pZRpYBr6N6JtysTk8iRn0VM9vyITKoi/XOYpR8xS6njLSxspkH452+5bSdvc9/xgnbcdu2Bzbr6UyFZcp31UJqOF2nb+3wdle+gOjBBYl3tWpWWfH9+QZg7LgloLL8ZsR19gIXTUNJ2bFoZJx+YFV2TDeBCOx1mx/AHn8x6gihLAUTAOPTd53AuGsYtSvTuWA65HPT0NWEfVxbgib9eZp40NBXr6Pej9awnVXX4dvWB7j9LmkUSfn9kHDtIH59o/+Fu2pYr90FbqbfY+9MlA+0cMlL3mtQvcWYoZ2GxZ8oHQe3wLCOaA0opzYeUdsTHZzoXq5rnTQpTGf81ndoiKVWlPGm0StoynYhc4tZxMcNh5sBmiAxIPqFJYYrMWZUHuo272kdRhH0gLqYoX6RWEns6S5qikkvLPeqopmdDKUk7QiHBuZucGR9d51+Ft3HYggXn01EpThvUUvkP6Ievm8y0+0Z1CXtb4gJCX9NrwC6hQv9HINUhumMIjp4MeKUsP06BnTPiwFMabmIRMuT88bdnZ1htTjOUpWeNJijCbBhXM6s1Jfaq8qCtRFv6csjygCki0EsModpzjva9n3HsuFMxWQnXjMbb7g8FmyD+o7lhagKz9xr+5Iq3nyeZwpJ9Lkq4FIJ8u
 0durAXmU
 g1bK3p4yqbZgMuHHXiANn1N0lqrEIVfTYfUFc5tmvK5xKx3+ABSjF7AiqcjUdB1wQhQnVEBeQL/daiCIEwUe3O/IaYuZFq4ElaVbx29jzYaz83dWtb+6xahi2AUEM+18Tn8dNOvEJDIysnzvu+i1jbS/b1SooGHwMYe266btwbFBhbUV9tDM0XCSh+FUbhJ9ymJpwj7dclAo2XmuJJbPGqYpaEPHzeouKBf9dwH/aRBs99aRrgMRZpJ5IOw9Ww0euNNt2JVgE6qGkcDxVfk8NqWos5/oQwLe15Tp4AbXNEt/oEPLoYp23vdMJQyiccgvBAsI2mqdYlwGnHPWZVPLN6NjeyHkX2piSl7F1b82Nvg6zBnaZ88ss+X3q73QlzUFW0V/0bN2XA57a4+3AmmxsLLO2LfAsW87xcQJ8HI6BKXtOI7Zbob9/7PPLjGWfT21MEp1pduQ+tIkbRhacBDQAbpIrA1FRQ+/EiXgh1j+JrOGxow5vya3N4w0t887a8qc9LssujbfqnKYQfKfJLLemr60HLa28TzONYM52ScYhbqfuOXoalWTAtpoKJAczwe1deI0KOSxhOEkmBKAi9cem1roHeCdoVXbLokLEFOkYKXIAs+DCb051UuRXm6K26CdpfW93W4DwDQcDEhblyLNJ7o3bE+4SWvxvBdmhgDD8CLO91Fw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 21, 2025 at 05:48:33PM +0900, Akihiko Odaki wrote:
>
>
> On 2025/11/21 17:03, Lorenzo Stoakes wrote:
> > On Fri, Nov 21, 2025 at 12:05:56PM +0900, Akihiko Odaki wrote:
> > > Hi,
> > >
> > > I'm another QEMU developer who have been discussing the problem motivating
> > > the mremap() usage.
> > >
> >
> > Hmm for some reason this mail hasn't appeared at lore how strange.
> >
> > > On 2025/11/20 18:58, Lorenzo Stoakes wrote:
> > > > On Thu, Nov 20, 2025 at 10:49:59AM +0100, David Hildenbrand (Red Hat) wrote:
> > > > > On 11/20/25 10:35, Lorenzo Stoakes wrote:
> > > > > > On Thu, Nov 20, 2025 at 10:16:26AM +0100, David Hildenbrand (Red Hat) wrote:
> > > > > > > On 11/20/25 10:04, Lorenzo Stoakes wrote:
> > > > > > > > Hi Vivek, thanks for the patch.
> > > > > > > >
> > > > > > > > In general though, let's please not make a fundamental change to mremap()
> > > > > > > > behaviour in late -rc6. Late in cycle/during merge window we're really only
> > > > > > > > interested in existing series, series that are less involved than this.
> > > > > > > >
> > > > > > > > On Wed, Nov 19, 2025 at 09:35:46PM -0800, Vivek Kasireddy wrote:
> > > > > > > > > When mremap is used to create a new mapping, we should not return
> > > > > > > > > -EFAULT for VMAs with VM_DONTEXPAND or VM_PFNMAP flags set because
> > > > > > > > > the old VMA would neither be expanded nor shrunk in this case. This
> > > > > > > >
> > > > > > > > I guess you're trying to be succinct here and 'clone' each input VMA using
> > > > > > > > the 0 source size input.
> > > > > > > >
> > > > > > > > However this can't work.
> > > > > > > >
> > > > > > > > This operation is not equivalent to an mmap(). It may seem to be for
> > > > > > > > ordinary mappings but in practice it isn't:
> > > > > > > >
> > > > > > > > (syscall)
> > > > > > > > -> do_mremap()
> > > > > > > > -> mremap_at()
> > > > > > > > -> expand_vma()
> > > > > > > > -> move_vma()
> > > > > > > > -> copy_vma_and_data()
> > > > > > > > -> copy_vma()
> > > > > > > >
> > > > > > > > Essentially copying the properties of the VMA to the new region.
> > > > > > > >
> > > > > > > > But this doesn't work for PFN map.
> > > > > > > >
> > > > > > > > At _no point_ are you invoking the original f_op->mmap or
> > > > > > > > f_op->mmap_prepare handler.
> > > > > > > >
> > > > > > > > And these handles for PFN maps set up page tables, because PFN maps
> > > > > > > > literally do not exist as VMAs which have properties independent of their
> > > > > > > > page tables like this.
> > > > > > >
> > > > > > > vfio-pci is a bit different, though, as it uses
> > > > > > > vmf_insert_pfn()/vmf_insert_pfn_pmd()/vmf_insert_pfn_pud() at fault time to
> > > > > > > insert PFNs, not at mmap time using remap_pfn_range() and friends.
> > > > > > >
> > > > > > > (see vfio_pci_mmap_page_fault() )
> > > > > >
> > > > > > It sets VM_DONTEXPAND but is fine with being expanded? :) That sounds like a
> > > > > > bug there:
> > > > >
> > > > > Yeah, I am all confused about expansion. The example code looks like all it
> > > > > wants to do is move a VM_PFNMAP mapping.
> > > > >
> > > > >            if (mremap(iov[i].iov_base, 0, iov[i].iov_len,
> > > > >                MREMAP_FIXED | MREMAP_MAYMOVE, cur) == MAP_FAILED) {
> > > > >                goto err;
> > > > >            }
> > > > >
> > > > > I guess the expansion is because of iov[i].iov_len is bigger than the
> > > > > original VMA?
> > > > >
> > > > > Is that maybe a bug in QEMU or why are we even expanding here?
> > > >
> > > > We're going from size 0 to iov[i].iov_len, which is saying 'please make a copy
> > > > of this VMA at a new address'.
> > > >
> > > > There's never any moving, as input size is 0 :)
> > > >
> > > > It's a cute corner case way of using mremap().
> > > >
> > > > We're basically asking for a _copy_. But you can't get a copy of a
> > > > VM_DONTEXPAND/VM_PFNMAP because you need to invoke mmap_prepare (or legacy mmap)
> > > > to get something sensible and you are bypassing that on expansion, even if it's
> > > > a 'clone' style expansion.
> > >
> > > Apparently fork() copies VM_PFNMAP without invoking mmap_prepare or legacy
> > > mmap unless VM_DONTCOPY is set, so I wonder if mremap() can use the same
> > > logic.
> >
> > It's because it's literally copying page tables in the exact same range exactly
> > as they are to the exact same virtual address.
> >
> > You're asking for a _brand new mapping_ of effectively _any size whatsoever_ at
> > a _new virtual address_ while _retaining the original mapping_.
> >
> > Also note that you're copying the VMA exactly as-is with _all internal private
> > metadata_ duplicated, but now in another process.
> >
> > It's entirely different.
> >
> > For better or for worse (*ahem*) we've given huge flexibility to drivers to do
> > what they want with this stuff. Which means -literally anything- might be stored
> > in page tables, whcih means there might be alignment requirements for the
> > mapping, which means that page tables may be established in .mmap,
> > .mmap_prepare, which means that internal state might be tied to the VMA that is
> > only correctly set up in .mmap[_prepare], etc. etc.
> >
> > So yes - if we exactly duplicate this with everything virtual, metadata being
> > _exactly the same_ in a _brand new process_ - with the driver _knowing_ that a
> > fork might happen (and setting VM_DONTCOPY in cases where it doesn't want it) -
> > then we're good.
> >
> > But that's something very different from 'allow arbitrary copies of the VMA'.
> >
> > In terms of mremap() this is very simply an expansion and we won't be supporting
> > this kind of operation there sorry.
> >
> > I may go work on an idea to allow this behaviour via a new approach, but it
> > won't be in mremap().
> >
> > Note that I replied to Vivek with some ideas as to how to do this in userland
> > (thanks to David for suggesting btw forgot to say ;) so you _should_ be able to
> > get what you need here without needing mremap() to do something different.
>
> I understand that the logic to copy page table cannot be borrowed from
> fork(), but I thought that copy_vma_and_data() could be extended to support
> this scenario.
>
> If I understand it correctly, it does almost what we want; copying a VMA and
> page table with a new size. It also calls vma->vm_ops->mremap to let drivers
> know the new VMA. However it doesn't copy the page table if old_len == 0 and
> clears the old page table entries, which prevents using the function to copy
> VM_PFNMAP.

It doesn't almost do what we want at all. All the drivers known VM_PFNMAP and
VM_DONTEXPAND will _not_ be mremap()'d so unless you have a time machine I don't
know about we can't in any way take the existence of this callback to be
meaningful here :)

>
> So my idea is simple: change copy_vma_and_data() to copy the page table
> without clearing the old page table entries if !old_len && (vma->vm_flags &
> VM_PFNMAP).

No, absolutely not.

I already went over the reasons, but to highlight:

- There may be alignment requirements that are no longer fulfilled.

- There may be metadata associated with the VMA that no longer exists in the
  copied VMA.

- There may be some requirement that only one mapping exists at a time of the
  given range.

And who knows what else.

we give drivers a great deal of freedom to do what they want with these
callbacks. We've built in the assumption that:

- VM_PFNMAP means .mmap[_prepare] will _always_ be called for any new mapping.
- VM_DONTEXPAND means that we will _never_ mremap() in a way that _copies_ the
  VMA.

Now these semantics are non-obvious and may be inconvenient, but that ship has
sailed, and trying to do something different now is broken.

I don't particularly fancy auditing every single driver for this behaviour
(inevitably missing some) either. I am already having to do this for .mmap in my
.mmap_prepare work and that was... already an 'interesting' addition to my
workload :)

Also to be clear, as perhaps I've not been quite firm enough - I will NAK any
patch that tries to bolt on more 'special behaviour' to mremap().

It already has enough of that, if we had that time machine I mentioned I would
never have allowed this ridiculous 'cute' mremap(ptr, 0, new_size, ...)
behaviour.

Note that we explicitly disallow it for anon mappings, so there's already
non-obvious caveats on top of caveats on top of caveats.

There will be absolutely no more of this :)

>
> Of course we still need to respect VM_DONTEXPAND so it should be also
> checked that the new VMA is a subset of the old one.

Yeah no, sorry.

>
> Can this work?

Nope, but I + David already suggested a way forward that should work - just
mmap() something new utilising the existing fd.

You could even explicit try to do this only when the mremap()-clone behaviour
fails.

I leave exploring the details of this to you guys ;)

>
> Regards,
> Akihiko Odaki

Like I said, I may look into adding some _new_ kernel functionality that gives
you what you want. I will cc you and Vivek if/when I put something forward.

Cheers, Lorenzo

