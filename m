Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEE1DD358E4
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 09:31:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E45D6B0088; Thu, 29 Jan 2026 04:31:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3678E6B0089; Thu, 29 Jan 2026 04:31:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F4706B008A; Thu, 29 Jan 2026 04:31:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 07BBE6B0088
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 04:31:08 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9F65CD47A7
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 09:31:07 +0000 (UTC)
X-FDA: 84384482574.22.78CEF95
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3713D10000A
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 09:31:03 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=cuwJy68+;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="g/DjT30V";
	spf=pass (imf14.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769679064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ikqqL4W+3NwoGmOmUeBNMrAHxpPOEStNvtJAjDRoBaU=;
	b=QfINUVreod3c/VzsEXFsa0zlneRJTVHiluja1uxmqNM3IyflOSaxNELzUncm8c1w0WtJyB
	d3yZXNDtE2d05HDn1A6V9OpIA7GAJTlHO/Ug1Urn62aCX6cJyLX8DgKmkjPTFXA+u30n4Z
	+5wtj7Mefdpw+L6xzkdLi3kCSaGCudE=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=cuwJy68+;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="g/DjT30V";
	spf=pass (imf14.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769679064; a=rsa-sha256;
	cv=pass;
	b=UEIfP+REu+BwCFRt38PFQ+wpqGdp7yL2XYgWSwFSdZJdLrVyRj1LmR1+ltNyTnWBBkKtyS
	K+7NMufC58V164RTErFPA6C4xBnPhrhlX+A5e54TLNIEvHQ6EbXs/32vinMU8QjP+La+mU
	TlEYtEKFMv8lBTyLDVaFfZVuRQn6l20=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60T77dUI1562769;
	Thu, 29 Jan 2026 09:31:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=ikqqL4W+3NwoGmOmUe
	BNMrAHxpPOEStNvtJAjDRoBaU=; b=cuwJy68+d2p0Kc3X0s3oAj8CvzIUZhBUOt
	BGWPJkfI3IUxit0KKroeQ3sKhI1W/zHpp6NVzFYrsHp3JqYg1ZgLj/QRa0htt71N
	SfC608sm0808C1pjvsjVLiwhblFByY0Juo1BnapNblpSHKsmSc/1K4qA49MpuFEg
	vLwGwQn1RdunkNDsDDnoywcAXvozLz+Lmnr1NTF3XRirblc9oIAu86bVouOeizLY
	TP6abk9vn3cUSHDjDCCkN3oC+jC/OoQS+77CR9UPiTjSvG9Sz4NWWm89XBEwX9pp
	zQzkeKoTz3QM2BSacBtyuG1ulUhqrnXH2k5Um4+AfLVcaozeEPbw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4by2vgjy1w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Jan 2026 09:31:00 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60T7UFLO010283;
	Thu, 29 Jan 2026 09:30:59 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011043.outbound.protection.outlook.com [52.101.52.43])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmhc4dmw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Jan 2026 09:30:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QjSAl3nn2J0KZAfADLn1DFpoANycgVOHD9UTDbL1SA289hwMx5PhBktofLNvdA0arm7j4pyrAJSYwmB5u2He9binE33uEG9IiFb/1qTx3ZbyUMXljyzfROoGPFmRsHbI+HLzI4Ae5Gu1Va3cuB2aODrGxb13F8RQcYpEpb9HWOsR3xj9lEnOWg2f3xjuaIkifLMxHKzcEFUdSc+8/OmWw/4Q6l7fDrQaYjUfjkmeLhQdO83Bl6DXAuMADqs0j/CXINM/w8X3FVBQd5czfs5xhFaHhvHn+KbInNWySZOMF7y37X/GShBG0YoeoR9Mo3rYbvZRb2NiG/CA60Bl1oTvHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ikqqL4W+3NwoGmOmUeBNMrAHxpPOEStNvtJAjDRoBaU=;
 b=YO3Hk1UQfe3sh0H7g3yC/RXZgd/mmELfnaTuflSGtGEkj5UXCxb4SsM2+0pl9KYS16ZNOd6dMmnv1MRPNLfO0Fn0lFVtFugERlJ8pDwXLh95DprXDO2ljdGM6Q5W4gDQdLdw0c4Zw1JH3dQyofQswAyYJeV1+DmvQi8lQKirpexlpGxZwX7I6sr6klTmZsNlNUmIuvJh7niZi+b13pRpSLxcTRXM8yTjDsj56dtu3qBoRSBOsOCZlWGn/Ul4OAduOFICVvuE+ObBQ7Yxa/AaaD5634KlO/XCS8DH2nZbiN2q+87qXqZZX1D8J0vZwwRcvooFujA4MLIWMK/CX/Medg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ikqqL4W+3NwoGmOmUeBNMrAHxpPOEStNvtJAjDRoBaU=;
 b=g/DjT30VETQTgYfQ07Qv5vxW8oqw4wJQHuSKfxe40P7VgqH1lo/pseOI1w+X1CzqHl/dup76hQ9m8VOc6ZwcC4lk/YD6LSk7zMOdZM1nDgVVB4JOzbHNnA67yMW5T69ABU0Mu2y+A0Pv9z4fL/Mbnl2Tnn9vy+SXw5WSDefyNM0=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by PH7PR10MB6336.namprd10.prod.outlook.com (2603:10b6:510:1b3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Thu, 29 Jan
 2026 09:30:53 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9564.006; Thu, 29 Jan 2026
 09:30:53 +0000
Date: Thu, 29 Jan 2026 18:30:45 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Hao Li <hao.li@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>, Mateusz Guzik <mjguzik@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        kernel test robot <oliver.sang@intel.com>
Subject: Re: [PATCH] slub: avoid list_lock contention from
 __refill_objects_any()
Message-ID: <aXsoxRXloFrvmOEL@hyeyoo>
References: <20260129-b4-refill_any_trylock-v1-1-de7420b25840@suse.cz>
 <r4sorjw4p62mk2pvnjfrfx2w3zmwcz5yuflmcewll3jsmpju42@dniauu6pkm6j>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <r4sorjw4p62mk2pvnjfrfx2w3zmwcz5yuflmcewll3jsmpju42@dniauu6pkm6j>
X-ClientProxiedBy: SL2P216CA0190.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:1a::16) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|PH7PR10MB6336:EE_
X-MS-Office365-Filtering-Correlation-Id: 9fa309ee-2d5c-4495-4f68-08de5f1918fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Pxn1TTNLzoyMEVnw6wDaRdZtVLiXjG5M6ZWNLyUYAs3CmCapQBCJbK4Rdyz6?=
 =?us-ascii?Q?C8WcZ5gAIpuhxNrgaUabxV3xBHYkUvRvuznidOMXcBZByzhP5wPb+iPpc0du?=
 =?us-ascii?Q?6O+pax1t/8jxWtZdUN4VyZhJlZWHTvl0eov++0gMJvY99hzIctu4nqFCJ8C/?=
 =?us-ascii?Q?jMNOsPhTjPAAnikcH6SaiqYnWoMrTyNfkKwNCTo6lBj2APcwasNqWZZLxnzM?=
 =?us-ascii?Q?q5iZqd/abIPgtyBMFu1xl9rQxMqI3+gS0OVrUzqvIeOBcnfUgKH2LpoU63ix?=
 =?us-ascii?Q?bG0B/E3PIysI/A9Qnf380tTUw8dhluuFoma12lzjaAskd5pOXS5Ljqe8mi9/?=
 =?us-ascii?Q?EK5OLS1RZ9UuU0w5ACdi8xRcLbm9IFQHVbmNt19rt2mOgomdgbhesB6w9vOE?=
 =?us-ascii?Q?fNjrLU/xCVa+Zwru3IVCLcNeDXz5+yuYqhO1iCjqMV6uLkSdjQ92XQs1mxoB?=
 =?us-ascii?Q?Jy4+hDvCIHFs1oxpKSvOO9FkKcVL66hzbaPImp93cGU4PhwDp4ySnaZbbZcE?=
 =?us-ascii?Q?b74pnXPFTrRp8YBOJwV+Z1ybZCAooPkiUy7qDmn22HI3cAZgV1h3ylFgBUgK?=
 =?us-ascii?Q?xv09g4Oyh+AaD5odXqrdUHM/pvJyS4QFuiTLCY/KlOqKclceQ326cu22oRrT?=
 =?us-ascii?Q?hSDRoSH5Cd4nmRrqd70X6cjLO+uJ2wtixMmUDTW81LUiMjPhHStxnw5np/8a?=
 =?us-ascii?Q?5vdgAa4Yimq9J0L5r23iThUHzzvE5lsz73bbFqS2N9sLgbfiWmIO1GvtbHnb?=
 =?us-ascii?Q?fhhG1ORmrYL1lqTbMSpjae6A+t4mQrRPKkkBv5S105uV9glVKQWtOCSWHDm6?=
 =?us-ascii?Q?LE1rW01+jjs9/XgkRUXWu78AD+j184fb5OKlNWvixMRjnKGWlstJcfuEqbRk?=
 =?us-ascii?Q?NpdE3ZguGIhjavDs9VKmhpCkt2VhT4cp0E1+ydpZlG6K7za2oLxbW6SZ8GN4?=
 =?us-ascii?Q?SyiYXLjLdBtOVDGXHduCBZwF64WTlV2y0QcvT20eGMjTdyyLjit1H8mQqmvR?=
 =?us-ascii?Q?3xS6l2TNlBniT5QYEtjs+SAB7vDCl/v2RB0PSqju2ELvHD4suSXO1Xf6qmZy?=
 =?us-ascii?Q?eCnPtqoZXgOqNlZ50gyOeNlv1eDvOmxLn/vjpvZn0guhdBtVgV1Wlu0XD3EN?=
 =?us-ascii?Q?Zq7jU7HHYY5u1raJQb0f5q9dh3kSu3yQQh8tiubnHrymHvRK1Ig8Wywer+hT?=
 =?us-ascii?Q?pVZYg0gGkqDZ1bUXeuHlcQw8VolSqg9BER7bAwn2rACCmwWiJc9cmgSLUKdB?=
 =?us-ascii?Q?vG1y0nn9iiy9ro4MPuUNb14FLYcgjXB8sAJywfz/L+tqukZcPDSYeTygzyLI?=
 =?us-ascii?Q?4uoQbFUmvIkrngBd8FwkiL3v+jLiTpVri85gdiJhxkLcVNpgUVuhAHe+K5Ry?=
 =?us-ascii?Q?01sJQxi5q4C3kGZjFjUO30BsqMO6nA9vETKgsfsSIo5uQghsIkl6B2/JTjdV?=
 =?us-ascii?Q?ZxIlHkTTrgSvrRWyVvUHOgKKc0y2Xrw+3pceX/Ip4mGLZ6idoVROn8EKH9jO?=
 =?us-ascii?Q?aPeEgkRK7ieAd2bY1RcXEYUpwOKLkdpZZtSZDbINIs+esmPb5SjMCFShxOXc?=
 =?us-ascii?Q?YfctUcMb8O4q6hjN9U976wz8OANPPeVoOAXHjsEF?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Wc6DMz6ilEEdn8NvdU0KvYagOxYjipVG07KnBXF25WkYFwzRH/OvTkxM3fTn?=
 =?us-ascii?Q?KIAIQonmBViNxHY9K8Mled/lAOmfTwPDXfL8R0jBWzRkx7Qzn7jovp3gQ9Ws?=
 =?us-ascii?Q?Z0FvWGOkgfefw+2FONFt715xPCnhv6BEk9s0gwAJfNntj3FhgyrnfF+jXHWk?=
 =?us-ascii?Q?11FM5I8bC5cDcc8R95FwkURdwYxnCiv6N23mXb6oSFEgBK5u/JslD+yY4K7f?=
 =?us-ascii?Q?Zd66qwO9Fxsvqn2QRMcRogJjz6zMP7FgNfsunZiMq83ivSP/aUeo5kq8WKgw?=
 =?us-ascii?Q?IfSCiOcXKhqWygqqiQqmlfnS6zDqAzYj4ROm8zSibNuVgj8COJ9/G2d2p1NW?=
 =?us-ascii?Q?NhNYmL66WkSyiqhazuNjHbH5Q7Q3qkD1Pe+zd+Fy+4HLSuLuRHcl8xKtKwQ1?=
 =?us-ascii?Q?xe17cSN7TVVPCHUYLpe48uBpzKqGWEKFDfCglenxPBmfXydDn7eZLefV3buX?=
 =?us-ascii?Q?+odQIBBnc7+Levi4Z19HvEWGXefO+fgfA8219TCYbozFVYTLJqzYCms4fLgr?=
 =?us-ascii?Q?kqWXvo3Lm78U7BoGN16dYhIMZqHIz7fn3Z89M0j9VnnuuZnX3N3Ogq9oQj3y?=
 =?us-ascii?Q?ENu1MxeoEtRzQHrNU5r7oEJm3pF+IGcg5rmJ2vBqTNeg9TS32if7wpGH0UgC?=
 =?us-ascii?Q?j8k+sYZ5ShNTF/cYe03n9jduk2hvj9jCai6zT5eRB3OJl18960T/y490oh1I?=
 =?us-ascii?Q?XBTzIwNCQdmsY1DtZeYCaG/7NoWXHWxDFaUgLyU6L7mFFIWSnnZ2fUG1Bx8N?=
 =?us-ascii?Q?dsIfxQ/CTE2seAWziLEKfnhrutjN2NPpCSjxqzkyftCqpFdkzJTXJ8UGrbYx?=
 =?us-ascii?Q?U90JjukPaFw36QIT2OlkoAGjuaw+qkMa7u9af7NOj27Q++w0vlChckiiycZk?=
 =?us-ascii?Q?TYcNGYT2Rb/gQcrFCHiwjemM4+SUB+cQjGealDlP8HQvfyd0HlPjX92sbmYA?=
 =?us-ascii?Q?1r32NYOYtN09snKoNpK3eVF0g80H8vXvp42mk7fN2OqQ7kebUH4n6Elcp8Ag?=
 =?us-ascii?Q?VdyMUkiFi+cSMffY2DikbMQVWPsjRnsHxGVUxgSRgQxm1B/TMPX5Qnj14cao?=
 =?us-ascii?Q?IqQ19IUBIM16JeRNeN3D+0ohmGCNd3JFwp/F4y9hq6sd/uo7ir2CM8kHnLHY?=
 =?us-ascii?Q?/yjr6J3IyWce/oCXwCY0wzHiOF51f7RwyNLjQvfcU4XsbOWNMHygFgQN0HmW?=
 =?us-ascii?Q?Zc3UXHFuK6qbsG3GoB3eqSlRlImt3/PYMvRmr/FFVEfMGHuEWlFFXG86mg4I?=
 =?us-ascii?Q?o+Se0q9ENgTj/1/JnpoNLx5xlBTveF2ZKVRfqWo92T1B9abRjwZdxtXyGc6p?=
 =?us-ascii?Q?8eVlCkAlkx7mlVneflUFTIZAcjszwYV5EO2NIS8A5FMhVjQeKi1C940PVATL?=
 =?us-ascii?Q?szxaxgq+cTaNm86yoxsmvTeGCsk/9/OvTColSoCxEXU3hCmNkWb3Pmr7ZLdA?=
 =?us-ascii?Q?dpixhPmmKKlJccmC1AOFjBCfAQhZHiCS26jw9Ynh2jovdeK35COplcua0KQ1?=
 =?us-ascii?Q?m8HVY/asC/2TG+RlmYcCvS9yl6Z+KbmRbKcUw0E80zo7l0f1CKyi8ZzGKUOy?=
 =?us-ascii?Q?vmwqp01fGGuhIUK7Aqi/dE/ztogdAszzzXu/0Da4LDNyx8N3NG54cXpEHcZx?=
 =?us-ascii?Q?FcG4mjTx6cx5h8cuTtQEIUFDa0EfaXim7Nlg/Y6YaJjOBMoGPYwJTpVIdI9j?=
 =?us-ascii?Q?US+ifiSUlIzc9zPEEaOJOl4DtgyrxugvYsDnUTYWp1pCZORTANlUe9Q8jRNb?=
 =?us-ascii?Q?1MVKvUNl9g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9/FOrzX+mB6TjXuBgOy4zDd7gLMlDs8FYa+MElNJVKUUJ444HOF38O9d1xE6lSIcsIYERTrWKER1RUU+XNfb86QvfeHT+eE9ryNUZA4PCM0kmTAZGcGhZDpqqEAVqZeY5vUIotHi4aKQOwtSxBYuYrKdMjlabXVdb8P3avvJ4GLJhJslwSXhUEG0ONni/ZKsmBAHDSZWXTFDzb6pLyrDDkp651JqawIhv3UsYNS1pGiwOULF8UhTcgRkJLFistxl42STQtS7OHK6RUzWNvTYgFN3IuV6XJFHkTUApTfEamR0d8ciZCGp8IUqvM0OW6kGWQgONBfkNfG8upvaxpOEUHE5pLlAs0c/Xs1eBJdbZWU8t6tCGpjUY7pMWGXIYb41vHU6dN/tdw1t/Mju8YCdvgx7lFeqaoIxKaNaytLmqlXJqRsYKN2CstZ5lsnmlAQpEAqiftSerXl/gTCQIls4QJnHcuMdYW8CiJAwUq1W5V1sNDiMZZpERzRW8/fBJm0s4Z9rK7Cn1cyrDnuDPPrwr0Av2sRilV2YijsKBqDInlHKdmJ6l5UzssmXy68Kmq+oGgUJWGCBHq+kuJeds/zkuDOn1AJcqkWfZVKE7vbg6Rs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fa309ee-2d5c-4495-4f68-08de5f1918fa
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2026 09:30:53.3983
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p/SwWcV/7uMXrPOKq7Ph1p2JSnBxHLt6ipmFl+cGVw7JMv6bGUg/p5Kaj5dYhjTdmAhqZiOtB85EQDmMlCB5og==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6336
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-29_01,2026-01-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=696 malwarescore=0
 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2601290060
X-Proofpoint-GUID: YLKmLMvPKw_-vFnf7IvhQbEuNHtGplj1
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI5MDA2MCBTYWx0ZWRfX2Xas5XbcT5wI
 WGYRKYKrG9mrycKTwrVLbyjKCBheq9hi+6QLAoQSUjiJd8stD9tD5wQlvzHyi6Qsehf0PMf/uXp
 X9nhGTivZSDl1RSgDe+oLTZN3gUsI4rNwrJ/1k39p9OBnMD3dNXcsxu+ctRxd5ilQulEpUFtnH2
 Do9plPj2KURHaTrD8Y5qZEKxWWB18IWwePiYkBrFdSMpwUBrr3tuQEkevE94LAdZC3M8rPf8YCJ
 SsktllSa9yRrmbTW5Q6C5+Cl3d/NaZZMnhI52ZNvTiNnWsVnBWa80IpLLboEW7QzAme1AFGRzc8
 Mn8y0nIlhyvzRRq9q5Vc3LxjuPTTJtCVQzhWBDTmKPI5oxNTFod/mMtaU9UpY3MoxPT6xYc/Px/
 ZKiv4geRKFpmnbfpHDBLX/0qwFL+i6QEopw+BMGBFKKJ3l3UfSvUlQOue7ReVgLxPH64DQnKY/j
 vKYurRBTTI1LnuBla2g==
X-Proofpoint-ORIG-GUID: YLKmLMvPKw_-vFnf7IvhQbEuNHtGplj1
X-Authority-Analysis: v=2.4 cv=a7s9NESF c=1 sm=1 tr=0 ts=697b28d4 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=YTbBVgQv0Tx9qBHkx6EA:9 a=CjuIK1q_8ugA:10
X-Rspamd-Server: rspam12
X-Stat-Signature: 9mr85r1zqoga4basbitr1hse4pb6ian6
X-Rspamd-Queue-Id: 3713D10000A
X-Rspam-User: 
X-HE-Tag: 1769679063-915644
X-HE-Meta: U2FsdGVkX1/WgB5+5CvtPpdeIjQUmap09ASgIdhzeVeYV+EOEJw+RWrwn4Nsf0MvFgMHq0BuHRFUYFO6PgilrgYMFVqzynTTH3wMHlJcklYPg/g3Mjz+XCAU84I27RJ83clvWMOXM7mSfmdbj3ui2hjOY/7NW9Ce21VzPe+bPPb7F/CU7t9o8S8QoCC2j9FpNsVj7HudoNxtzUSWCoH8vxXs+MbpHIuBEl09ocKsnGefyy2U8mzyyN0i9dEGUuRP7ULcM2yMQoSmKDOy0bYn4MFABhN1HNyAKKlXl6uU/P+IDck8kamyx1FNZnmKVYB6awBXVmqyPNwcZu7DPPebvvVy5lskd4di2MwFNtP0qG5XEDApd0OtAi4Qq5VUEWx6P3ORMsDz5INYSpnoHFYJyq3fqKV/HX0RRlXqgkQgSaac++DubQC2pcsWuNofFDVof53NR0/yDYnSSggb+cg0zwEq6NPl4TrCWVU4ZtfnzoPL0CCZN6uVIxvybuoLaHPDtxMl+oou7A4/BFWc9IGf6+Ys+gOIDw+r9wigdZyetpAastHr8sjKl3DbNSUOkTPgQNRTBXMLwox2YD9gdURFFo8oy5DELY8G7faiUDyR2GFzZPpYRUQB934BshpjlLEov+d5u0wK3iUtQj+smWgKMo0FmXQwF5rwOpiQEPhNNo8dBqBiOt4oG8iVHzeGglfvg/ivBmydBJxEt4stnOlf+M3HhczZqoPBY5fkD/2gQjCLo48JxkMMqyqtem95OVbgHzVhnSifwlJOIaRWikslt0rfRsJuHlHS42i072aZaB5/26+LOuo6HxvKn4nU8yGwAkbFqIvHQGKNItqy/mm7F9nnbTN12c1NBtGNyF+GtkMFj5Q202MAWdpPV8IhrT7YC77GptIluqvrxlRXhc9nLf9WIzy2eY6kd20+DtosieOihq4vEbKQg96KHqgFeBaohaIuuG/8pvhgVwE5u3D
 csKLLhzI
 N8rXWfSwhJEhnmx19te1vJDvjOQlT79snx0s6sXH6kRPf3eywxuPdAAA6CeC973Y3O/xxqeInNUIKIcjfDl73xsvQw4DcF0yt1WjET84o1ArA1WDDZZfqFtxLqhTH9XKIOcz9pu6ccvJlJ1QMydc3h/mpnnarfxzSBpa3MC/D5UkgyNk4v5o8mHi3+7QA7HdimdzhuQyn1/9xJmerRbWpR1uliQMg9Zkv6eksGkfmQKBfSkx0vAiyHdekDs+FYDUl8Cse/4E2nc5GOKQbSe/5+Lpz2a4ms0SZ304AWhTUTVFrenruTIC5kk71qOK62BSBc8FId1TF/ogr5MZ6+lwnllhPNT3twK15YiGq3d8mtooh2RqwABThr9ABsxUDdvndYVEbV2iNb6Sk1nShx85Mz+bbO25EMWi1A7u4/xwGF369lf22i5Hi/NHJkbiuxczp09nKeZkZhPAE0JZem4BeNri0gV9nxEgYDJh0Ww+HDCCjSDdiKtwknPDHp4joonSu15SzaTGeqXaJIIJo2ktld5iY8sl1+v+CVHYJtjn9ROLXVDjP5nZR9KZKV/YyvOBiE43bumPojlfjM5GnYTfKRdbUsOddmkALg1y4LuRHRljS0JCEInnA8gCihbMEMDp9WTeOUlHTI0yzX2hU7lTK3gA/bcUcQSBcdMClEvxF6/CoahYd7eSFJ69PkepXps7y06RuDXl9CarpvCtNOAhiyUkdrw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 29, 2026 at 05:21:21PM +0800, Hao Li wrote:
> On Thu, Jan 29, 2026 at 10:07:57AM +0100, Vlastimil Babka wrote:
> > Kernel test robot has reported a regression in the patch "slab: refill
> > sheaves from all nodes". When taken in isolation like this, there is
> > indeed a tradeoff - we prefer to use remote objects prior to allocating
> > new local slabs. It is replicating a behavior that existed before
> > sheaves for replenishing cpu (partial) slabs - now called
> > get_from_any_partial() to allocate a single object.
> > 
> > So the possibility of allocating remote objects is intended even if
> > remote accesses are then slower. But the profiles in the report also
> > suggested a contention on the list_lock spinlock. And that's something
> > we can try to avoid without much tradeoff - if someone else has the
> > spin_lock, it's more likely they are allocating from the node than
> > freeing to it, so we can skip it even if it means allocating a new local
> > slab - contributing to that lock's contention isn't worth it. It should
> > not result in partial slabs accumulating on the remote node.
> > 
> > Thus add an allow_spin parameter to __refill_objects_node() and
> > get_partial_node_bulk() to make the attempts from __refill_objects_any()
> > use only a trylock.
> > 
> > Reported-by: kernel test robot <oliver.sang@intel.com>
> > Link: https://lore.kernel.org/oe-lkp/202601132136.77efd6d7-lkp@intel.com
> > Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> 
> In my testing, this patch improved performance by:
> 
> will-it-scale.64.processes +14.2%
> will-it-scale.128.processes +9.6%
> will-it-scale.192.processes +10.8%
> will-it-scale.per_process_ops +11.6%
>
> Tested-by: Hao Li <hao.li@linux.dev>

I wonder if using spin_is_contended() or spin_is_locked()
would be better than trylock by avoiding an atomic operation?

-- 
Cheers,
Harry / Hyeonggon

