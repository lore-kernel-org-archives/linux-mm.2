Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BBCAC83F26
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 12:11:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B83A6B0095; Tue, 29 Jul 2025 08:11:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08F396B0098; Tue, 29 Jul 2025 08:11:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E99686B0099; Tue, 29 Jul 2025 08:11:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D6D986B0095
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 08:11:13 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 87C84B9E55
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 12:11:13 +0000 (UTC)
X-FDA: 83717186826.30.ABA8E47
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf17.hostedemail.com (Postfix) with ESMTP id 32F3040013
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 12:11:10 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=FfV7XS6F;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=gAZTPI9f;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf17.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753791070; a=rsa-sha256;
	cv=pass;
	b=fjgYu5tuIumNc43KqCyzyaS+/3eQBcEvuRpmO1TCVjr+/H+nMKgdiXxp18hx4JsLGnzryR
	owi/SXXmsOlSz1EQ4izXuEt/jEqK2PmK8bPLesa7CvQj1Oi7RbdEUs66Mw9C2sw9vd+5xm
	xAlrUL5KVF8tzL0DSa/se2BfksCy7sM=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=FfV7XS6F;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=gAZTPI9f;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf17.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753791070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k7Zj/JL8+kTpyDG3y/hkaUlPvw+L6tHo/GO0gEJVcoI=;
	b=4Bp5zw5NACtB5m9jBjQNRNM/mCYr1JNAq+/rbXZNGO8q8ICljs06KSma1IuoOff0D2fHYh
	eEdx8SvFC3eNDhliaY/DGQ8Yyseq3D85pjJJbdGOBzocRn9TvVPysrKHYjsLUyHovojXY+
	oHZo+Li+6P3pq5zP3GzaWCJvEhvJPC4=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56T7g62g030166;
	Tue, 29 Jul 2025 12:11:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=k7Zj/JL8+kTpyDG3y/
	hkaUlPvw+L6tHo/GO0gEJVcoI=; b=FfV7XS6F6QiPslkOxshrtBLC+6pzBqJqwR
	ksGqYFlo0+b33iadRtnHGF+TdbxkTSE5Jx96xZ2STlQiM4Lbg/uJ+pcIAbenbz7O
	UnhrMJpvjy7w/peZDkaUNsdrHGYN8sOKYMSkU5MKi9gJH7gqY6k4A9czNGOTQQhS
	UbcohGnwvyPeVMKI0byaVU/fpngbg9XEMOW4gB94EtD1lkeajBYKILQZ0ihnSuf8
	PdDDnUYZH5xPJq5IlcfRrgecLNRXenSPL7Cd5XJGGcDO3nEx8tK3unz7Ro6K4ZVu
	6wWhLFczRHB7Xpqun5kZuPeo3NlAvy0gQPAAI/ki7Jx4hb3WxHgw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 484q5wqcuw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Jul 2025 12:11:04 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56TBbKNa038440;
	Tue, 29 Jul 2025 12:11:04 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11on2077.outbound.protection.outlook.com [40.107.236.77])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 484nf9jsgg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Jul 2025 12:11:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZeGilcDStHlocMxEA5OTxnN6YD0LqifSQQjxxDeQnQZZaFf1dcSK2xedEAwMFj99mOp4/pxOojdOZqFM5C7q46OoGKfUuCP06iP9/+rTLBW5n2PlWEHpguoRUTX+PoVVqmwvqjOEFyUFVpSGw4fPnC/nYkly37PWzcLeKilRQrMhjCCvB++DXfndeYOP5JFpK23nkZuU/DJq++Zglq7ctyjLYrQo7WT9uPAES5AZsahZfkTIWG1Gncb5aSqHXAeUg6mtHARw3kcmNOv10JrL0xa+Gl8agSA7qFty3JFJ1uOn3r4Ub5EklraRRC1WtcPjQg7SvXP1mADmFx9UdRolFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k7Zj/JL8+kTpyDG3y/hkaUlPvw+L6tHo/GO0gEJVcoI=;
 b=Y3BZiHM54nC/4K/yWZCDbqXZnCrj/BEJWZecYxxeVXdSjhuOICY4jAAUPDR2QdDtL5qa70u5O6s+WcuU+Vy591jH0n0dhejn+mQ0SHOKoViBE37flPSApecdUCDMbvODU9bJaKLNnq3urCBdsMvT4AQjC/7VrWPnjEI9AyV2rUaabPSUesUiccNXEyfxPvlgohkmf0HEROt1uYe8rDsG0QS8h0aVDU3nrHsowbf6Z2/TfeBvTNRrBAhRzVz3hiHorXAqyLWSbB1jEptgH9DucbJahTCkurHMG2FHliTWeA+BUK9mf2jQicnPy20utajh2aoMQyHhmrmSL/ZwTv6FfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k7Zj/JL8+kTpyDG3y/hkaUlPvw+L6tHo/GO0gEJVcoI=;
 b=gAZTPI9fZeDpKD3Y5e+tG0K0EkX3PtvY8BLpP7mBigHmVdE9H/5B0hQyj2p0S8Sw/9D27W3A0Tb5OehUa/WHy45KcULfzzdTOxYs3bFsSF7Avpx9VN9njGf9preVxmHyqCnV9xkp05CeS5daw2cPttbxIxyO0/Fwrr5Hg08USBs=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by CY8PR10MB7365.namprd10.prod.outlook.com (2603:10b6:930:7b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.26; Tue, 29 Jul
 2025 12:10:59 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.8964.026; Tue, 29 Jul 2025
 12:10:59 +0000
Date: Tue, 29 Jul 2025 21:10:50 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>,
        David Hildenbrand <david@redhat.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Uladzislau Rezki <urezki@gmail.com>
Subject: Re: [PATCH] mm: correct type for vmalloc vm_flags fields
Message-ID: <aIi6Sok2KmkCaXNn@hyeyoo>
References: <20250729114906.55347-1-lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250729114906.55347-1-lorenzo.stoakes@oracle.com>
X-ClientProxiedBy: SL2P216CA0123.KORP216.PROD.OUTLOOK.COM (2603:1096:101::20)
 To CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|CY8PR10MB7365:EE_
X-MS-Office365-Filtering-Correlation-Id: e4dc8b2d-2a14-4ffd-cfd1-08ddce98fab5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?m9qIfXpfduee6vY/imEdcCqD2H9hbR75h8sfXViO2JsP6OxbWWYKPwOPYZRM?=
 =?us-ascii?Q?bVP3Fs3vpvNUKSpUbDqiXW/lIap/Ed/9WlXo+z4JR1uzUsj8+RuEBEGvmG66?=
 =?us-ascii?Q?NqJvSdSoeG4FCEaGEp+RI805aELX74LzIrzSz7xusr0TalaRVtO9ZXPZqgaU?=
 =?us-ascii?Q?mNt041hTL+1DHHSn6ehIHAXqoZuouhqfeIFfQxZ7I6E5Q3zOkoVJ9M15uyga?=
 =?us-ascii?Q?4xs+OCPIwakb8wIqnEfxTLuO/7Cs1bXJT7QhrlQ+FQW/wecRcR9cTXuBk5mo?=
 =?us-ascii?Q?I1QZ3QRw+D7oWwKxP3lgPi1O0JIab/1v1qg4sbXiE8VzVeyvXVB79V1YTCVw?=
 =?us-ascii?Q?yYxkOzPg3u8pAZXV576kB8nqtDvhXDOG6zv3wb2lNqGhvJsecthgmgScS+rv?=
 =?us-ascii?Q?QF4zbBct0DKNY8vuPpUO+GEM30V6Uz7lVUuaFosPSGA8xtnVY/62pSX83QZn?=
 =?us-ascii?Q?FNGT79euXJMRQcXpJUClJWSOgS3yUecX1Fwkipy0S7paSNr/aqYWlLgiucNm?=
 =?us-ascii?Q?acO/BqzrXEwkVqz+Ga3vj0s2dCuktAvA7/yTRv2jNTWznMasV8cRgI68Ocdf?=
 =?us-ascii?Q?bYTEor2WmxTDuTWpAGEZuPGIZ/NMOXgCiqq3Y3FpShrMxiT2JRstavlk9aeb?=
 =?us-ascii?Q?nBgS+ns/HYslK3QQ04y6y+Z6Rwkk6aza4ddrDNFcBkOzxDEPGFbatPDIVmNX?=
 =?us-ascii?Q?9fae3tIRa72SD4cOQyLpVb/imF2PAS/XN1S80T09dZCEUmsleMChvqWahMeY?=
 =?us-ascii?Q?bMGB0cLmlhM8ewE/gMJ+aKBbS3rZRy23vr3BTWVIDrC13SHol3TaqC1jm5b/?=
 =?us-ascii?Q?eDojBacr+HIPcwJYEw9hG0cAR5he8xwzTTQeWCgqxvrTHoUmTcR+GQ+m4agq?=
 =?us-ascii?Q?474uw4nCvXQWxASOtjWLLS0/nsjHYGmjoKjKl1fcNkfsnqME3ZRb6Um0L+uV?=
 =?us-ascii?Q?FHlY89v2nULcvlJjZPantkWSylFeZLR9OeKSLMHb/D5H47giC4gMld3R7ZX2?=
 =?us-ascii?Q?Sv7Wa1e7Vdp4SQ4arRx8lM4+YIXtryXDuwW665toQnNBVw5JqoaZidm1i50Q?=
 =?us-ascii?Q?2nwZ0FFgOTWSrSYkuQTKn3c2iiuK3s6n3oMWQu/+/fbyfmuXcdR6iDbzsUOZ?=
 =?us-ascii?Q?GCTPbi89wRGu7O7B37x8Ob4Bd0wPRy7lCxf43biXg1vnJbl2FoejHLN6lki2?=
 =?us-ascii?Q?dUrWAVBHmzjZU3/H/ezSwKQfkuG3ML1IejOMEycWWTwP0w7Ff6YcmwrmNYOp?=
 =?us-ascii?Q?o/LXPdzDe2wE6egBHmGL7Y28VHh55uYHEnopXgU8H2Ou/Nd2jeyIUf5bCr/U?=
 =?us-ascii?Q?q8phJyxixAEviuskq7fSQX2Bc7t/MknvoGLL5RrxlCRRXqvh+NwW9KwN+j1n?=
 =?us-ascii?Q?l1RQcWPuRFUOa6dpNn7NWs83Cwh6Ib5GU3CotyQwRO+lC/L8rNogVy/DoJHb?=
 =?us-ascii?Q?iCihtFKYK8E=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?o3Om0tX/YHsC9tY+ViV8e3q/QTq8MJnWaJIVdblpmR63DfUVHFOmi2z45mKS?=
 =?us-ascii?Q?F8My0BZZbWzh46I/D9chea2L8K7SENt43YQvjGzfiraMfjhG1PYuqXMmOz0U?=
 =?us-ascii?Q?cT5eysFG1zg/OxG6rUP7Jc0C+1f9cSpFbXRiRLomLvpgZvkElGCxrBb3qqIz?=
 =?us-ascii?Q?5NWyylPCZR0J0DZ1NpZTwnSqDzQSQZ9R74qZPmL19ptz3ijppiEHVMpyO3By?=
 =?us-ascii?Q?GsFY7VwfJ0MCs7qCsSfpUYAWlyPCxKSJ9kw4HmkTd/Yw0S+Rea7EK7ONaG8i?=
 =?us-ascii?Q?vD43MpD4nbHR/7bRqyk8kq5HGUgu8bc/xTdzTSwXHAV80Rhn7g6Ia/U9tVCR?=
 =?us-ascii?Q?rLXkLXgEMmVYozKUPD/81WZX4eaxlR75LakZ69Hg69oWm+X0s4kQHT3MrZzV?=
 =?us-ascii?Q?r7j6QIB9jLkNHulPkn0QtT13QlgvueuObsBKJc/0+mp8SosHXVTBAMP1tXBE?=
 =?us-ascii?Q?ES3mdH1lRPdaV7KDEGlh6pWjufS4rZarvuC0UEN+sc1GlI+7q7+TdzZ8e1l+?=
 =?us-ascii?Q?LlvNb9XVRWqemWL7iadhCdxiuFJs2e336MMRHTfraoSMyPVy8ZQuv066TGTh?=
 =?us-ascii?Q?qRGHzzz0NUOw794jbm+ztKOtfNL9nrs3mKCGF6LSl6Bojr/o7SIdt8N1h8hi?=
 =?us-ascii?Q?09nMTF3EVcw6eL/jQiquGtbgtJITuwKE8Rmho0qctAXbt5nE2OIIdrejQtLC?=
 =?us-ascii?Q?6kcnKarIuBSwtEn/39HYV/tdOT3TS5xIAueC7w1Wj5FHl4EMxokOKFLO0tQw?=
 =?us-ascii?Q?I/zxNaCjTHMMFiP8Dj/gwLOiBC6c6Szls1C2t3q+5NVvGx2SXPYvh2lztTap?=
 =?us-ascii?Q?sNWWaHbIc8EPB1cYJEywWVw1YxQSZgyUl2ftXt57EiU4+XmNq8Yh2sxvDlwr?=
 =?us-ascii?Q?JI5Wzq3kIx7LmdEA8yhjFDcw8Tn2LaLJstnZLq47sLCw4kxG60ztbP4n620a?=
 =?us-ascii?Q?4uwi078cxw/7XSCfk1LmQ1m8VA7pRTZYfVKO2KGUBy6jvXvP0MJGGOoiiMIY?=
 =?us-ascii?Q?1LjJSfkKx0VClAxD4xWiT1HAaJoJJi/lwxU21zoPPG8k+e3z6lzbzpJLXGb3?=
 =?us-ascii?Q?fHFNNZ4kq8bnd4UbY7tFv3vQjZdsc0Vc0RDhAol2UABr3gr9qGOknjjdIaXO?=
 =?us-ascii?Q?WpuygyLrwIwqB6PvOVQAum4KoxPC0SFOpmyGd8T8V/20rjGJQHAFsPJRgPTo?=
 =?us-ascii?Q?L4cL/xRoi+OLS903RSSmhrCw/JQX0fWvil2NiwgGFE6BVlimtrAyNZeFiK4t?=
 =?us-ascii?Q?4yFrPbs9NNlKPDC2XBGODULyZuTW6ozRJf+vj3EydMQEgqn1tDyvicn39RQq?=
 =?us-ascii?Q?U5emrTvtI3onNEUow+gTCWXP8xWXnUbKyGchAh2BvWQP5pdub8T8HRiDSrQX?=
 =?us-ascii?Q?Y89R2PipC7GRsY/TCtF8bSlsz6/Xg3nzyK1UfeKFRx2iHL0yJjekF4PGnFsh?=
 =?us-ascii?Q?SAT8GVGTBSM2bqWTH7OYz1DlCH9Q8EhWNEpLIBIYMzmq8GRYOSk/kIE6p/RR?=
 =?us-ascii?Q?wkMwQtd8RF/Dsqi/81rSebHFalXXUrdll7KMiF7Epku7hN2rq2aEi2nrW9rl?=
 =?us-ascii?Q?nXYFCK2mjNwe0mXDJJz+qqjANpiNJKiL6oGNe3pu?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	sdCgQWosv0m+MdXndNvAv5UjV7UzAa0fuSyFyZsUJvbAPW3FRmPWL2dG+lS9lI6BBHVkhUNIClee9mzWHyybTh7S7TjJKS/QqzJ5zaMxooVaoNsmFuSfqvKddZ3K68EantyV1j1dGqCKUz1EFZ4hRTuqhG+LNRn5Zpo9tuSShEsIgsT4d9sntVA8wUBORN253ZoGaBlXbBzBmwUnw0ATRMidBpERw2QRTFCoc2laol9/CyL+WeCXrlh1K3X/804HFSeBJ+nB9GPjG/q69Tn9zPnMQnS1Dd2EINvWd9qZwvY/6ek7XRwYX6BvcJUF5s0Xix+EqLc150tr5T/3MP6c9+iDsPb5eQhjVkBJSnAF8kQvIDrwxt0JWkcTvDqu6CCsyY3VXrMHf4p2wXJga1FKlkBCBBejC4hreDOhQmTVoxdZaWYojZK5Ay++91TukCJe/jyzBWXU5fWXASkpWZNjr+O4hTuGg1LUhX6CRqZZtXRqU2Bapwd46z9aeicSZLUSnpyYQQDo16BzYMNVye82kUtxvfptd+/Ae6XdgkK5rpSFhAdQnaHxWK47zu4ncr6CUDpsze5W4CWye0II+2eFCKvoWR9l4sNIXbry1XSmGZw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4dc8b2d-2a14-4ffd-cfd1-08ddce98fab5
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2025 12:10:59.6215
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 39kEvrXwodF7X0PrSIz/cNaifbzsZOnwzjz8tf1yALiaHoS7s9UrJXX6DG8fj10+BO3D8cjGAqPn+2UDcSU+rg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB7365
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-29_03,2025-07-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 spamscore=0 mlxlogscore=999 phishscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507290094
X-Proofpoint-ORIG-GUID: FfT0IRQqa00sHdaMzU6grx5CZRJS6L-5
X-Authority-Analysis: v=2.4 cv=LdA86ifi c=1 sm=1 tr=0 ts=6888ba58 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=H9yKMnI6NqsF4c0nzZ8A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI5MDA5NSBTYWx0ZWRfX7IBEgwfBzd7M
 JzgYhqRHA/ftB3xXGMOStD/jjiU9hy67EViMFrKyyuA9jQQGlL7HhT3oa5jrQRG9CFr+K20hIHV
 X5T/lnbW2hDNVGc/XkpwbTeD1nzqaACVVk87gei50tYy5le5vEo0RfgD7GEvMZ45mOFQePApCOL
 mbqrvkQ41QN1fJwSCFuBqkqveFrWc7aEPgFRpboVU02MfN0QY3jinssKQE1QiGlarJ8ReP44tSi
 ED4aMla4+lmcAuGScZ5oE+SQqNzctfj9imdskePd4XcnAgGLg99OUbDOxrGaZm7iS7fys9N0YPB
 w/XrIsgnKTYhnHHoTf+6532Vo0MenB2pWqZ39iDZ9dWwOA0KTEhwKbaT6oEa+03qj1em2GxHihS
 /2ZjuSXlLxkUZst55Mk1MNlxytg9coqhWsj7xPeUtFCw4kzJEVhrmRcg3OKNBT9xGCydA2bG
X-Proofpoint-GUID: FfT0IRQqa00sHdaMzU6grx5CZRJS6L-5
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 32F3040013
X-Stat-Signature: mkj833q1o9yo4panrqhjyn4h76eifuiz
X-HE-Tag: 1753791070-514399
X-HE-Meta: U2FsdGVkX19iDzobWp9Veobud9PuBYIVktv+JIDDnDk9Z3s5VrkmjZhoJn5Tus4ibLYdgCxWL4NbCM3eIIR1GH6rOFeXRiHmQvCZt9s7XsxfG8J3OK9f3VaRrI3slU5QKirQ60MQ6BvByC5mVkVck9kVAVZwkzv74Jg3uES+TZoR9n27mb4zBxa9xJs1XoMniK0ybwSp88lFCTfqxJcl1Fc/IjsAnmgmeAPIna1a7AQ9YSahYoCRyZG7iNJlEUI1MDei33AD/HAgO+vtrb5Xk2t83k4rCl0FyI3Px+fzpLL6YvQKZb7wlyucKjA2ogAAtfJjOBmoctftOxG2DKL3tUkhOESGa2NjKBQ8g9xBB6nOXZRiX2/yJqOFvU1yvVvyVnJF4BWuLnNkOLVPjTrV5vUjFNvgpXsKgXpwU+wVa3wbDvSCdnxPAvj3FklBu8nBlQzxrio+yGdLeoED8Qy+3oSGMdMkDNYZruZVyWUfDHClpbcS6vdC6+1tHkP5yDOMtQftHAW1hwMorx62Mg9lA8/vMVK66vyxnY5HjBtNuYLDDdTLW4gXrqFYR3t/0COIQadOcxi/hcO+hH2dPF08jv/599m1Zo83nuAKyb7RSRXA7xTmUalkHoqs6WImXBw1k4B62ET8HmKZaV/msyVPeTfgqlVRAHmn3nFu+cuHwmeyzo8blNh0ykRpLjkiocvw2sirAK7sxxZmZNeSDFc0mzg09Or4elZWnCbVaDisFYPpfrhi+BnLUpPC64pTrOUcpAl99iD3tbUM7BEnNwUHMkMTQi0sj0dODwqnNvpRSVoEjnwYaMDzECtOWA0OBlsJERnDGgZfZmiVgRsk0AQ9UAJfGJhwR1bEyWQJ2awCdBWojYoh9W4wNOhAI9LThV6s6UeEX5Xi/DhLz5G6/RayrslJSBb1BS2nabPkt5iWBRi7lx1RJbfjzmj/pUNHNcDdkMlqqGEzEGCH7VKU/Ej
 LlWGPgYT
 SNOsaxCtfrsp9Du/c4zk901Hilzc5eIguZf6z9v4OSgFkjOUdzh34PNHOOgRbqcH5F4AP3TSm9cdAIa1amVInpn7pSNDAfapZ2APwI3nASZb4mPvTHHetc+uLDSu2Az8FYiP1E9c6V2HsvYRVhvh65GEdnXyEAxH0Oswy0Hp9WRFyHDeEXmMCzqWEKhKMo30qdwvasm8x731fI35Wz+eKvTHxcyUxyFLfqrZWNCA9sA4MykKwJ2A6oM4AlcetnTLxku9atxZHiFOV5+ehkONIFqKZflaQuPzEJrRhZqRty5kSJh/qAeMSudkUjSTUoEupGazER6ckmN/vaH0SSFg/0Ym997Sqr8TL76RnnuBM7WVmaHtCRZWR8dRo36DlVG2Bli468L8zDFi3a0CQ6FbTopKur5Yn8zgyh8deFwjHDTls70JaO6rkWvLiC3GCvsApIgbudt6e8LEWIJMIhJD9mIWXd+A6Mgm0OLR+jwj7DLzU2pBtkHMqpRKFn8RD4oqsfdf3/kqG7U2BOf1vYJOFulI+XbTsa9mElNz0bRxm8k7FlYgNIlLlUo+/8zGNXGgGntOTo2+Xkb3R5CuAnnKzbNpnmE/FQrhvCWpnf7nNlafFfeolIo3AenAFqUpVAjRDox3VBVpwOZqoaEUGoTNx8W1wdXIgBmC+22Qnqp2wfbQ63RW9HxkeHnjp/IzdogcNgdXEMdKn5E8ezdXnLfvPHLT54190xTi+NN97OPs3cAFVxd/MlUkx92MxG6IQNQm0b7326iTorkboNzpomMtN0/eiNH2U9eGVXnyf+gc80gBbsLH3OxADkjT0uQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 29, 2025 at 12:49:06PM +0100, Lorenzo Stoakes wrote:
> Several functions refer to the unfortunately named 'vm_flags' field when
> referencing vmalloc flags, which happens to be the precise same name used
> for VMA flags.
> 
> As a result these were erroneously changed to use the vm_flags_t type
> (which currently is a typedef equivalent to unsigned long).
> 
> Currently this has no impact, but in future when vm_flags_t changes this
> will result in issues, so change the type to unsigned long to account for
> this.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Reported-by: Harry Yoo <harry.yoo@oracle.com>
> Closes: https://lore.kernel.org/all/aIgSpAnU8EaIcqd9@hyeyoo/
> ---

I see one more thing in patch 3 of the series:

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 8fcf59ba39db..248d96349fd0 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -720,7 +720,7 @@ void mark_rodata_ro(void)

 static void __init declare_vma(struct vm_struct *vma,
 			       void *va_start, void *va_end,
-			       unsigned long vm_flags)
+			       vm_flags_t vm_flags)
 {
 	phys_addr_t pa_start = __pa_symbol(va_start);
 	unsigned long size = va_end - va_start;


With that, all looks good.

"struct vm_struct *vma" makes it even more confusing by the way...

-- 
Cheers,
Harry / Hyeonggon

>  mm/execmem.c  | 8 ++++----
>  mm/internal.h | 2 +-
>  mm/nommu.c    | 2 +-
>  3 files changed, 6 insertions(+), 6 deletions(-)

