Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FA50CAC5A0
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 12:38:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50D848E0105; Thu, 18 Sep 2025 08:38:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48C898E0093; Thu, 18 Sep 2025 08:38:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 354208E0105; Thu, 18 Sep 2025 08:38:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1B9368E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 08:38:44 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E13A416019D
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 12:38:43 +0000 (UTC)
X-FDA: 83902324926.11.1B5665B
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7A094C0002
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 12:38:40 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=hD8h9H4t;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=wc2Blxqs;
	spf=pass (imf28.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758199120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+LjtEf5Je8HEGksbgZAyTLWVabvAmeSyiS0XOLWGpsY=;
	b=YIDiJqEBiFm9HGh9CVwCGNkcWxAmEWsybaZI+YTulvnWdMpkzXj7sIdfjbty7jyN+QZWeD
	DBUgDsJiXYpBgIMFEQ5rJPMwJnekjXgRpMNwY/a8/MXvU3qeRIJFwFf4Wz6WXgxUr0Lt1O
	Sp74/jE1egd3VCeQPjlcVVQxeqOFujo=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=hD8h9H4t;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=wc2Blxqs;
	spf=pass (imf28.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758199120; a=rsa-sha256;
	cv=pass;
	b=FIoQAwunEKBRe9kjS5LWFAtbEHA9wu13aK4GBg2mz5XL7dy3r6WS2Jp5iUviQZ4NFfBn7S
	gQNfI1h1m0k/Cl4pXRpvhytewZsTxoRxECiOURi7I2adnQfyTEqQfsX/kzHFkuBVisCqk0
	7aqq8APSy0CdibXFSe07w243X3aiveI=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58I7fu2R027262;
	Thu, 18 Sep 2025 12:38:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=+LjtEf5Je8HEGksbgZ
	AyTLWVabvAmeSyiS0XOLWGpsY=; b=hD8h9H4ttxSs7nTX7kiDTfTkTT/3esV6FN
	IVhjEtq4+pt7rDQNbxXkjsMn6I2Pr/Oix6YbHxvg02jdAm/V1nUNRtSN/pvvElYR
	Ms8QRkwHzcofN98JzU5hkhusZVEM3mQACH6atEQ92tTLYnqMHf/kA+oGsROyCz9A
	Wge0x5S9HOsvzEZp3SA5Dj0eQjxWNOTRAQmWomKJXpyJN6XJoOYDJIHPL1p4Ex3I
	wAC2dhEwKpePavEUcTxagKwBNlm/owMpcENqOhHNTod5D6Q+tgpkvM/YUfip7is8
	T6DyDvRiklrE18yQ4pVYmgN8JsvtJ8QPLuEqMUBNS3hH/9lJb4bQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 497fxd3awj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Sep 2025 12:38:34 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58IB2pWV035096;
	Thu, 18 Sep 2025 12:38:34 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013068.outbound.protection.outlook.com [40.107.201.68])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 494y2nc7cq-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Sep 2025 12:38:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jN3bYFen5kbmriHe8uxkLtc44TyjtKTYM9BnRdfbTbzJ3KV+IFz2rNBbC3vbZKyLiO1fNyyI6V0vQLy3c57MnmpayBv1Ks/2JwF6cQflKqU+xsa5Ok2QID4h1Y5r8r9fP4Vm6FU+k5MZqzDQaHVG4zbDNjdFxfDTtvjpYySbhSfD4tp/vS+NKUfDB5a9WKbSGpg7cknLhVxdKXv2fCADoq5kb3rXlUB0d0ZjlUNBTRTnQZJqhxaUH48aJFrekLoXKOChHUtA3rDijONZr/eSlJyV1cwR2r4LYW+s/frnG0YCPjOspHfnJsSmkD+xg/hecwD2zJPKydSQdVID4I2s5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+LjtEf5Je8HEGksbgZAyTLWVabvAmeSyiS0XOLWGpsY=;
 b=jFImY1uBmzo+a2i+awvmCUcbtSqy7VtkE9Qdafg991SeiRi5cJSMOdzsrEpivBn7CtydjSUyVFiCQg7vPPJGvmx5fw9u537LIqJOL60OFX2ZMGMsQOqaYoz7e9N7yhKMV6nTpD9o4klGfEhkPo6VTJMAMTEijRvWOxsYM9EuIZoSfIyL6lrn3HebydN3nR6Zr05s5UYkznmOLG2UcZWapEzcAfvukFbOJixCLNBoY8ISXoyKVCvTPmmxe1HaHqka3NWgOYwSwc8q+r2QWAbX1wFEzBx4Z1U1TU+a9h1upGOayCSKV4YBEVls/mHjVdgdDy5ME53S2IQMWrsVxGnBLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+LjtEf5Je8HEGksbgZAyTLWVabvAmeSyiS0XOLWGpsY=;
 b=wc2BlxqsxQ8E9mdx/yDl4LtMmURmERX5QC3+dNQdGCIKPobQp/xfOKYKMC8NU+b+XyU5mTBnInSkr0mfdCWwIo70fEEDLqKh8ull431xGefJ58pVheDtZEivOmpqUoZZrOxCfjI5zAoQaA9mXmjN7HJHj9NRMvbtFi/MNCUK60c=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DS0PR10MB6199.namprd10.prod.outlook.com (2603:10b6:8:c1::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.13; Thu, 18 Sep
 2025 12:38:32 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9137.012; Thu, 18 Sep 2025
 12:38:32 +0000
Date: Thu, 18 Sep 2025 13:38:29 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Lokesh Gidra <lokeshgidra@google.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, kaleshsingh@google.com,
        ngeoffray@google.com, jannh@google.com,
        David Hildenbrand <david@redhat.com>, Peter Xu <peterx@redhat.com>,
        Suren Baghdasaryan <surenb@google.com>, Barry Song <baohua@kernel.org>
Subject: Re: [PATCH 2/2] mm/userfaultfd: don't lock anon_vma when performing
 UFFDIO_MOVE
Message-ID: <4e4bee5c-c2d9-4467-b7b8-d3586a5cd6e4@lucifer.local>
References: <20250918055135.2881413-1-lokeshgidra@google.com>
 <20250918055135.2881413-3-lokeshgidra@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250918055135.2881413-3-lokeshgidra@google.com>
X-ClientProxiedBy: LO0P123CA0015.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:354::12) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DS0PR10MB6199:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f44f3d8-201b-41a0-d8a6-08ddf6b04706
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4OeRDfDOflnyIMTHiaUOiX1lr+j4RAQO4kdjbAvKrpdNZq8PXeIwVieBnDYg?=
 =?us-ascii?Q?K2POLX2RL9D9wAxK3lptiCA3cb64j1HI8Iqeo/vGtrQgxa7dwvNvH/0X/zUn?=
 =?us-ascii?Q?0AqnbWJQjgqee3MFKYIxra0HRpjb+R1noaiqWtnvem4zCtsWQhWGcQLG9PA3?=
 =?us-ascii?Q?mJMz9XytdACJWYR35cr/pplOwH0JwrluKeEV6Ofc630wWWygEf+d6W8+5X3x?=
 =?us-ascii?Q?b8rsPhAH3Pr3Lgnl3IcqzZDF5BVPf71qoBVMNkra3M/e/QIUmsmdwdImBhnN?=
 =?us-ascii?Q?CdGX2eR9EttLbN0gUkbu0xZ0Y3WNPWG4/cjE4AqjDYgA9O8So8WLbqeJzN1E?=
 =?us-ascii?Q?tNmPJfTd+glwAt1janCEe0rA1h3nKU+tkZJFpI258c7gDLR382ImyO0ZpE+s?=
 =?us-ascii?Q?+eJhXIqFJI6WF3uPm2lyMXpK6DsB4BkbRcqVU1YIZxzjVdIhrBUGYRlCxfHH?=
 =?us-ascii?Q?bKAlxm6i2jcGtEzhnBNQC+kUZNtvKk7EBsbKGlRseL1l9tfw7sxlrPoidenE?=
 =?us-ascii?Q?0FHzqYFXL/ZTNAiGAD1CyLkL0geKaHm7xT2v4STuDGKvCM/eWlKTI5XL+cyv?=
 =?us-ascii?Q?kdt3bG4s2pYjUpI/fEe/ckaiUkUgy25r1Ruu/ghWG+FSUPS9f9nO36BNf/W7?=
 =?us-ascii?Q?ScK2YRvYJJngIT38f5Momep1avJf2mIripuaeEgTJDCunINSOpavN2w+uJTc?=
 =?us-ascii?Q?gA67kBadX0IuviKEMYJWa/zUP5uE3yyoR0LtYBIb5awtlccWrtMwWHGv+rn2?=
 =?us-ascii?Q?/EDEHndEdm/BF339c9HOCxev/5sO2GoOi835tW9sUB33b6Oo8InklTPvzJZA?=
 =?us-ascii?Q?uR0utwLlo+emPYRmCbfixpa0mrsKnCrJBdm50pBJzMRbYbt6ndL+468MzMFP?=
 =?us-ascii?Q?9TmMaCAd811LDwsWKbJKH/EM4Kzibw/4/o+xNqQF6Nu9eMPuMelZE+VLSK1C?=
 =?us-ascii?Q?xXukkkn8DQmJ+Ag5GHJ897XDwfaVkIQVDXH+BSvMmtHmpU5+iAprxZyfFkW5?=
 =?us-ascii?Q?9pIm7bwVoOR54Mig5xctMZIqunaA9tqEZs6lkBSgZi0iVx2EQWkCIPMpuaRp?=
 =?us-ascii?Q?Qny6KsoGyqAEl+r64B+K37DJoeKLGrwEYTIDVdKDONtjZDmVkGSKAtTn9B5N?=
 =?us-ascii?Q?/U7sk7WVIBgygxL1Ytiy3vTzzHJR9u2lLUNA3TijZf8xEh6rtMDnuPEFkM/C?=
 =?us-ascii?Q?4NNjRKrZPExkm80NFENcv2s4NMTwE6FsfaGxNB3fPDXDRcgbp5ND5rZgogDJ?=
 =?us-ascii?Q?2pgGr4YkU1twLGJ/oOq/SCItCoDLwZYtCe9Azv6D44lYpxAPSRB4yit5pE3a?=
 =?us-ascii?Q?0QSPES7GDg07Ertd+tELIuBBVOzZ7seHIqnxmbLtOBLHtHsGM2Oj+hOO/ppS?=
 =?us-ascii?Q?aEeEZ/jhuuVPf56zkn4b9/0YGPXfVcExid4/oKbL1+j6IZEo9qqIzaeQU6Qe?=
 =?us-ascii?Q?5UqT2hS22Fc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pEVKac09oNRA24LZl4IaHokdvNpb+1PPstdjVo4RJqzMUkNeNElIYgThpJRc?=
 =?us-ascii?Q?MwE5EoS0VyH3ScLlfQaXY3nvMTVFE/gC4U9exWMUWfIP/KE5XTiGeIZUNMCN?=
 =?us-ascii?Q?pAm5OM4K2HGTsJGHmkFBQJIf0UN6ykUEvuCIf9zVn+o/taKfy+Fl2yrxdRGP?=
 =?us-ascii?Q?zSP9sRoASx6J+QD9hOqdU3O87NZNKWTmkJOjmVBbDytl6eayOCrrom45HBwL?=
 =?us-ascii?Q?KcAmNkhf9GQ+DDZovC5nH141eyC5/LwjbDKX+KoUD+HVaWUAr4T0jKHRFvJi?=
 =?us-ascii?Q?BRl7XwV810aYOjtyZO+VAbRpN2YlY2j6X1KgIkxKbNOniWYQWbmR7d41Fhlo?=
 =?us-ascii?Q?P7OfNnupvqyz7yMrsv5L+YdW50RYgC+enK0J6M2SfYp0bG1DUv5ekvNhLGfk?=
 =?us-ascii?Q?QugpoSqRWV5PbRKLfkw6fZTrsB7rf2jhNHniaaVG+RcqLQ+bC+Ld5Wo/m8Mh?=
 =?us-ascii?Q?LTGb2wX04yg5G1260+wiK7Qu4GWcTsiJw7xuD2bBDhmIqdJOB0FPaaxY3DX2?=
 =?us-ascii?Q?lN0yDaEvM8oFJFK4I584eioZDTzcBn+imh+5RKRzTfbCIsM8+6KDM58IUbut?=
 =?us-ascii?Q?U33qwE6SeN5SNpLanEVixcY72XSZbwfpEJmDiFU5hWZwX1bSWOd4WNEPWHUl?=
 =?us-ascii?Q?S7Jp6gUtueYckJbinffAkgXGtdFn4xouEc2GENAxG0LsWX2PNb6xNJg76A0p?=
 =?us-ascii?Q?ikOJgR9jZjqoqlTWyY1tPRQ9NJFdxuG+R3vLn66VQRl50mHD3uk73YVPFAmC?=
 =?us-ascii?Q?7RgI3DrRUNLT/mUkj2AIjnCwYA+IV4QFjaMi+D+jscRJS2p0TCTZ0ErTDzf0?=
 =?us-ascii?Q?X6/Ci05foGrVrh16AGujPkAQvD9oYgrM/Nb8a4G/2cqsshBi85djDTc/1NPY?=
 =?us-ascii?Q?WIfttBirhzDv6rhfb0nw2B4N6EVC9HD9OeB98NHKoeE8EJpB9B1M+98a/ufo?=
 =?us-ascii?Q?+AxvlnP9WvoSPY052kd3z+/qYbGnXJAB0giFC1sn/lwRX5iLmKozUfWcj+lF?=
 =?us-ascii?Q?924x5HjSphIjsLRxzR65/N5/pMWWisC2wuWdpCo2z26XFIBuDwPcOYYNiRwZ?=
 =?us-ascii?Q?pZUxIu30su4E3gji41TQOhqrPiOeuKvyqy1M1ngtjzqoiY3m+z97e4LCVAmV?=
 =?us-ascii?Q?cLim1Wqs83q5dASwXoMIos+YRy3V7I8PHN8kqndWij933kLRiCKyoiG2RKEM?=
 =?us-ascii?Q?S3KdYkGK2Ep0dzqhtEulFjF6OzjMA90I9wBI1q76eP+NHIvoncvNqKpx1JKl?=
 =?us-ascii?Q?/cV90f53blgz53l76kEuVFaTHS8Z7AX/AFML6j4NB06P5XSneBzP2whL5czP?=
 =?us-ascii?Q?bvrhIMvrl71pdV26KcAIJVVdbTcvA3//aMJFPZTzPkJO+LBTX8l0vBGU/0jO?=
 =?us-ascii?Q?IZrA9M0fLtgzzh4HxajhIknkyDX7mgy7pZZ0AhZxEn+mPB8pMP/T6Y2Cr/om?=
 =?us-ascii?Q?nXigIyOjf51UnHPXEa+kCGO2hpbg0KOhPmQ4HMwbljBhuX2YPLrtdDVa/JF8?=
 =?us-ascii?Q?yTmwNT1z4/2F6Wwd59kApram0sLWLzCX1DOI7jejf+RfoxtVYkINfZbvx9Aq?=
 =?us-ascii?Q?O16qajZcHRdBUzVFLx1KWWQSkqmcEPf2U5i/S6jKUDt7m727dtSlzFReqNUx?=
 =?us-ascii?Q?tw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	0iDvx7/ICvwWfOD+HXG+GNBA0zMrHqFWeXD0sFMVmvdGX83EYs87B5+C8NzYkRaAgmKJFiSNVE1Z0w6m6IdYz8GBEsZOxr95CAdgRAx1vPvMRNc2hhBXFAo3QEDYaY2uEv2aQm62FTSU4WK4xdmy+Le/vPNRthjjM1yzaE5Sm+uIDP7uuBtJIufXbt3l+PW4xuYOP3nk6vo5HLJgIuQXItDo4/7VGkqjiVXcnrYmhT4TogwXxMzLj9ajg4yVlG38S6+C03YgDA1Rl5JEHlTlMcgTGLHT+Z64SI6Kb6iT7p2ySvf6pdrWnsT9DzZeozUwCMJsh/VV+F4JzDp2BEPMjUUBmc8ViZ6owaij37KbKVAvB063os7RKPCNC6vTUICspWDRxI9pXD4QQ5bXN6zyEh215wA8yvDzvTYsvekbcYYrTcE2vz7/FOntU21Vu5BxHIaOPbuaY6JF4ftJv7ZX8OVaIvNmiHl5M3epDvzEtwv0NjJiJ/3qOyE5vWuT5bELW794A1Gh0mn+dxPxN4FHK3uIumVlyCgmAQnJvpRmZk3KyCaOpkSGJSyHEOY7VEsa3rarz+JsJfev4P+vKaEBDeV1KvlzQp5ZylU6KhkTFHg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f44f3d8-201b-41a0-d8a6-08ddf6b04706
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2025 12:38:32.4600
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fgMYCzCA0JkJD06jAuj1QdAH0QrdrMfPjUd/ZfY7P3/4vQc/lOuN63tOJFWAkOCUcnXWAyPJP7UCb8QQCHI3lbpoyF2DtxdMzWmkEfuMMKA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6199
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-17_01,2025-09-18_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 bulkscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509180117
X-Proofpoint-GUID: d9u1I7SwtVSoJhJJBSdS5BbnWTHu4SSz
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwMiBTYWx0ZWRfX1AEPT+OqeEzj
 dvqxHe+8cLm1Wdz0/0jCHfjY3OxNFwvhQl3sLi1ncqLsJJiy4rwhnT0X8oK0lI7buLTfvDXKcVW
 X1OauGcqlM48l83Fmq8d/E1i/JjNI3KY7DVsLtsb3OaX6LGZCTSVgndXast3sDoMvVbFS4LNbk5
 JMN0+Ot588q/LLjAGZRsibHUZLLrJkRxbcRf9jSO2KW6t1zZbP+ecUSX6ASJHOMHk0v0pTp6xHn
 lFnqrPVP5BQlzYVlxgQKUjoX8k4MfZiyjTRp+eYKHF83A7omMTykqLbw9vW1kWwiRh8ixxEi90W
 96gDl4rTK3o6fJKnCAQbYqwxypzEMy81rIc7OBGJph4uGuShaVnR641qnhjmo850djqYqaMKdTK
 EMHwlJMmFPX8O9ilnqRrntXRuMh6VA==
X-Authority-Analysis: v=2.4 cv=cerSrmDM c=1 sm=1 tr=0 ts=68cbfd4a b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8
 a=1XWaLZrsAAAA:8 a=VwQbUJbxAAAA:8 a=bFBPpuQ32CfVR1azVb0A:9 a=CjuIK1q_8ugA:10
 cc=ntf awl=host:13614
X-Proofpoint-ORIG-GUID: d9u1I7SwtVSoJhJJBSdS5BbnWTHu4SSz
X-Rspamd-Queue-Id: 7A094C0002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: eadxjoiq88t5jgbubmtgfgweppw4bnxf
X-HE-Tag: 1758199120-499639
X-HE-Meta: U2FsdGVkX19aV2sIgdlMr3YtBYE8Teg5sCg0js9T8F+iKEEutjfezB14U3hjXfAMUWZ5wbPjsgaB9gMq9lO+hYO+k3i8Tc9V/QcR3YiFCwS10/i2mvemOz3E3KZg0bRwA5a6aYIPs50L17/Y4MDt8w8TdGfMUTxpJqxutm3uglFexg7Jrf5ciBkqd4h6c9OfRivEYqaDi2W1sDPd4LgeLVX50wD1WN8LKazm0PNs1ytaOXXqYAbJq6z3BTsHjqLrPr7rMZYKR9CKgohdxn/eYKRAV/aTqqes/CaYEwQu/ySpalbNPVYpr9MPYMHFjlsju6S5gNi25PuEmPcCMkHdMVetheOtuAePlC4uZSneAWs8QBvCs58bl1vtjUv0ipOJI0uQIW62/UWc4qM6fmkMv2aa7Kd2TnwhHPWlnLIFvhFlcYH3HvbwdZ0lVClpaCngy/MZ6jy9wMJV9ESBo7UzXorqn1eRbC7fRIXPo66XjvTpFLghvQxGLv94Q3JCk3nuWg8XommA8eAUeDeebWR5itcwCjiDnQPqvcRwpzYU8gZE46ij4K6e+Vrup9ylKmELtgY181ogOaMtOvqLNIrYyywHWqW+W1YKJH46jc9OyyL4iEh1+4/1snYHn5AloYA/wOR9B3jeoblMFiQF1CfEn1F8988Wt1WWlifrZCTaQcADIAQBYGPCbqVpMmqxrnHEHVNXT46AjSTJFAaQwBZMkHADT3tVJ1dBgp4iL3ja65W5eEzOnezhXsYLxaTqYdKmcko/bgFsjqQ8lxKBrxX4M+gsoT9p5b2+Y2Zlu6N/hobZlMo2wQNDWFz5Wp4QdwMb6VMsxhIA7BDBDdeBS9kfkwAF3lNLhXjqMrqRJsW1KfKeXc1rQoBh6azMqHBsYLja373xGI8O/+7VEenWYUwHnnILwZjFgXdswV4YaUrxHMFrTyc14mGnb7tTDhHE5U8LHGu065rS/Inp/KHK0fL
 Dhb4OPYC
 /Rqgw1LdSU7BMEksrb/NNa3DlbALhm+AhJ6L9jMXDqM6qU6BTtWlPz4irWU47frc3hJvRR73zw70wXBO7xcOAe/R71MtyXC+6yVGw4mXxIP34F6JPI4LMqmAPPDNzwGqWKctUAeG7T37CoKQgY0uME4ckjYH+lUHgZ8IEMR4W9/JIDVZ4TSiEpk6cPGx1GVHGoOlY+qfy4uL71KH6smZ1s+gTXI1wnaI4Hl973qc/FvePG1Mq7SrZKuUYPSQpc362DpYMF12TAnUMK2nGodX6NjsFfze6AJFLHsBMupkqHXWCvNepn5RjC8pl3AoFVbJYaYqroabN3uAvIw5+qHLXDBgE5CQcxq5v8fec2HgkXMUPK2ahI/MzqPQRFa97UhS7LqZcU8R1cmAk1e5kB6qcmPfYOb9K+gAV01cNv6XDNuvsf8CbAQ3WtGE+j+Lmo4L0TFM1VV0oJesYz8PxUDNm77s0x470GI0PXVbijiHHUKVoSU+Bt9TfFtroGJgx8NT4ZGItWycpsuqUfDnWfPeYEMt9mmsSqow1V51BsCFIS7yAsd1V8zA5ne++H6FuIidm55zsS5JMWs3fMdt+f49x3Yp5WVo9/FT8vpAGSiGuLBYHC6tkerFdLT36YO+QklUgJxJ4QD37HNOVwVfZCU2KpMQCAXPusLoHjPGbOE1h5o5ExYk70WgbJ9qdt9ftwZiV79x1raCwcgHHDWo7tzQMuqrm1lRIiP1HZeefX3OGFWbYCSWTF6MNMGbClnYGgCLrYPw1+OBcT14EM9wj3FJ7oeB85knfSG9dOMuMJDFXDwJILJaWxLFc+k8i/TgWoFRhoq1V1wNdpmoz4HajWmTGXIiJQcl/hb1YsQNa
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 10:51:35PM -0700, Lokesh Gidra wrote:
> Now that rmap_walk() is guaranteed to be called with the folio lock
> held, we can stop serializing on the src VMA anon_vma lock when moving
> an exclusive folio from a src VMA to a dst VMA in UFFDIO_MOVE ioctl.
>
> When moving a folio, we modify folio->mapping through
> folio_move_anon_rmap() and adjust folio->index accordingly. Doing that
> while we could have concurrent RMAP walks would be dangerous. Therefore,
> to avoid that, we had to acquire anon_vma of src VMA in write-mode. That
> meant that when multiple threads called UFFDIO_MOVE concurrently on
> distinct pages of the same src VMA, they would serialize on it, hurting
> scalability.
>
> In addition to avoiding the scalability bottleneck, this patch also
> simplifies the complicated lock dance that UFFDIO_MOVE has to go through
> between RCU, folio-lock, ptl, and anon_vma.
>
> folio_move_anon_rmap() already enforces that the folio is locked. So
> when we have the folio locked we can no longer race with concurrent
> rmap_walk() as used by folio_referenced() and hence the anon_vma lock

And other rmap callers right?

> is no longer required.
>
> Note that this handling is now the same as for other
> folio_move_anon_rmap() users that also do not hold the anon_vma lock --
> namely COW reuse handling. These users never required the anon_vma lock
> as they are only moving the anon VMA closer to the anon_vma leaf of the
> VMA, for example, from an anon_vma root to a leaf of that root. rmap
> walks were always able to tolerate that scenario.

Which users?

>
> CC: David Hildenbrand <david@redhat.com>
> CC: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> CC: Peter Xu <peterx@redhat.com>
> CC: Suren Baghdasaryan <surenb@google.com>
> CC: Barry Song <baohua@kernel.org>
> Signed-off-by: Lokesh Gidra <lokeshgidra@google.com>
> ---
>  mm/huge_memory.c | 22 +----------------
>  mm/userfaultfd.c | 62 +++++++++---------------------------------------
>  2 files changed, 12 insertions(+), 72 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 5acca24bbabb..f444c142a8be 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -2533,7 +2533,6 @@ int move_pages_huge_pmd(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd, pm
>  	pmd_t _dst_pmd, src_pmdval;
>  	struct page *src_page;
>  	struct folio *src_folio;
> -	struct anon_vma *src_anon_vma;
>  	spinlock_t *src_ptl, *dst_ptl;
>  	pgtable_t src_pgtable;
>  	struct mmu_notifier_range range;
> @@ -2582,23 +2581,9 @@ int move_pages_huge_pmd(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd, pm
>  				src_addr + HPAGE_PMD_SIZE);
>  	mmu_notifier_invalidate_range_start(&range);
>
> -	if (src_folio) {
> +	if (src_folio)
>  		folio_lock(src_folio);
>
> -		/*
> -		 * split_huge_page walks the anon_vma chain without the page
> -		 * lock. Serialize against it with the anon_vma lock, the page
> -		 * lock is not enough.
> -		 */
> -		src_anon_vma = folio_get_anon_vma(src_folio);
> -		if (!src_anon_vma) {
> -			err = -EAGAIN;
> -			goto unlock_folio;
> -		}
> -		anon_vma_lock_write(src_anon_vma);
> -	} else
> -		src_anon_vma = NULL;
> -

Hmm this seems an odd thing to include in the uffd change. Why not just include
it in the last commit or as a separate commit?

>  	dst_ptl = pmd_lockptr(mm, dst_pmd);
>  	double_pt_lock(src_ptl, dst_ptl);
>  	if (unlikely(!pmd_same(*src_pmd, src_pmdval) ||
> @@ -2643,11 +2628,6 @@ int move_pages_huge_pmd(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd, pm
>  	pgtable_trans_huge_deposit(mm, dst_pmd, src_pgtable);
>  unlock_ptls:
>  	double_pt_unlock(src_ptl, dst_ptl);
> -	if (src_anon_vma) {
> -		anon_vma_unlock_write(src_anon_vma);
> -		put_anon_vma(src_anon_vma);
> -	}
> -unlock_folio:
>  	/* unblock rmap walks */
>  	if (src_folio)
>  		folio_unlock(src_folio);
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index af61b95c89e4..6be65089085e 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -1035,8 +1035,7 @@ static inline bool is_pte_pages_stable(pte_t *dst_pte, pte_t *src_pte,
>   */
>  static struct folio *check_ptes_for_batched_move(struct vm_area_struct *src_vma,
>  						 unsigned long src_addr,
> -						 pte_t *src_pte, pte_t *dst_pte,
> -						 struct anon_vma *src_anon_vma)
> +						 pte_t *src_pte, pte_t *dst_pte)
>  {
>  	pte_t orig_dst_pte, orig_src_pte;
>  	struct folio *folio;
> @@ -1052,8 +1051,7 @@ static struct folio *check_ptes_for_batched_move(struct vm_area_struct *src_vma,
>  	folio = vm_normal_folio(src_vma, src_addr, orig_src_pte);
>  	if (!folio || !folio_trylock(folio))
>  		return NULL;
> -	if (!PageAnonExclusive(&folio->page) || folio_test_large(folio) ||
> -	    folio_anon_vma(folio) != src_anon_vma) {
> +	if (!PageAnonExclusive(&folio->page) || folio_test_large(folio)) {
>  		folio_unlock(folio);
>  		return NULL;
>  	}

It's good to unwind this obviously, though god I hate all these open coded checks.

Let me also rant about how we seem to duplicate half of mm in uffd
code. Yuck. This is really not how this should have been done AT ALL.

> @@ -1061,9 +1059,8 @@ static struct folio *check_ptes_for_batched_move(struct vm_area_struct *src_vma,
>  }
>
>  /*
> - * Moves src folios to dst in a batch as long as they share the same
> - * anon_vma as the first folio, are not large, and can successfully
> - * take the lock via folio_trylock().
> + * Moves src folios to dst in a batch as long as they are not large, and can
> + * successfully take the lock via folio_trylock().
>   */
>  static long move_present_ptes(struct mm_struct *mm,
>  			      struct vm_area_struct *dst_vma,
> @@ -1073,8 +1070,7 @@ static long move_present_ptes(struct mm_struct *mm,
>  			      pte_t orig_dst_pte, pte_t orig_src_pte,
>  			      pmd_t *dst_pmd, pmd_t dst_pmdval,
>  			      spinlock_t *dst_ptl, spinlock_t *src_ptl,
> -			      struct folio **first_src_folio, unsigned long len,
> -			      struct anon_vma *src_anon_vma)
> +			      struct folio **first_src_folio, unsigned long len)
>  {
>  	int err = 0;
>  	struct folio *src_folio = *first_src_folio;
> @@ -1132,8 +1128,8 @@ static long move_present_ptes(struct mm_struct *mm,
>  		src_pte++;
>
>  		folio_unlock(src_folio);
> -		src_folio = check_ptes_for_batched_move(src_vma, src_addr, src_pte,
> -							dst_pte, src_anon_vma);
> +		src_folio = check_ptes_for_batched_move(src_vma, src_addr,
> +							src_pte, dst_pte);
>  		if (!src_folio)
>  			break;
>  	}
> @@ -1263,7 +1259,6 @@ static long move_pages_ptes(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd
>  	pmd_t dummy_pmdval;
>  	pmd_t dst_pmdval;
>  	struct folio *src_folio = NULL;
> -	struct anon_vma *src_anon_vma = NULL;
>  	struct mmu_notifier_range range;
>  	long ret = 0;
>
> @@ -1347,9 +1342,9 @@ static long move_pages_ptes(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd
>  		}
>
>  		/*
> -		 * Pin and lock both source folio and anon_vma. Since we are in
> -		 * RCU read section, we can't block, so on contention have to
> -		 * unmap the ptes, obtain the lock and retry.
> +		 * Pin and lock source folio. Since we are in RCU read section,
> +		 * we can't block, so on contention have to unmap the ptes,
> +		 * obtain the lock and retry.

Not sure what pinning the anon_vma meant anyway :)

>  		 */
>  		if (!src_folio) {
>  			struct folio *folio;
> @@ -1423,33 +1418,11 @@ static long move_pages_ptes(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd
>  			goto retry;
>  		}
>
> -		if (!src_anon_vma) {
> -			/*
> -			 * folio_referenced walks the anon_vma chain
> -			 * without the folio lock. Serialize against it with
> -			 * the anon_vma lock, the folio lock is not enough.
> -			 */
> -			src_anon_vma = folio_get_anon_vma(src_folio);
> -			if (!src_anon_vma) {
> -				/* page was unmapped from under us */
> -				ret = -EAGAIN;
> -				goto out;
> -			}
> -			if (!anon_vma_trylock_write(src_anon_vma)) {
> -				pte_unmap(src_pte);
> -				pte_unmap(dst_pte);
> -				src_pte = dst_pte = NULL;
> -				/* now we can block and wait */
> -				anon_vma_lock_write(src_anon_vma);
> -				goto retry;
> -			}
> -		}
> -
>  		ret = move_present_ptes(mm, dst_vma, src_vma,
>  					dst_addr, src_addr, dst_pte, src_pte,
>  					orig_dst_pte, orig_src_pte, dst_pmd,
>  					dst_pmdval, dst_ptl, src_ptl, &src_folio,
> -					len, src_anon_vma);
> +					len);
>  	} else {
>  		struct folio *folio = NULL;
>
> @@ -1515,10 +1488,6 @@ static long move_pages_ptes(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd
>  	}
>
>  out:
> -	if (src_anon_vma) {
> -		anon_vma_unlock_write(src_anon_vma);
> -		put_anon_vma(src_anon_vma);
> -	}
>  	if (src_folio) {
>  		folio_unlock(src_folio);
>  		folio_put(src_folio);
> @@ -1792,15 +1761,6 @@ static void uffd_move_unlock(struct vm_area_struct *dst_vma,
>   * virtual regions without knowing if there are transparent hugepage
>   * in the regions or not, but preventing the risk of having to split
>   * the hugepmd during the remap.
> - *
> - * If there's any rmap walk that is taking the anon_vma locks without
> - * first obtaining the folio lock (the only current instance is
> - * folio_referenced), they will have to verify if the folio->mapping
> - * has changed after taking the anon_vma lock. If it changed they
> - * should release the lock and retry obtaining a new anon_vma, because
> - * it means the anon_vma was changed by move_pages() before the lock
> - * could be obtained. This is the only additional complexity added to
> - * the rmap code to provide this anonymous page remapping functionality.
>   */
>  ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
>  		   unsigned long src_start, unsigned long len, __u64 mode)
> --
> 2.51.0.384.g4c02a37b29-goog
>
>

Rest of logic looks OK to me!

