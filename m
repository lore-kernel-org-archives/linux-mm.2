Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F41DCA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 14:01:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE5D88E000C; Fri, 12 Sep 2025 10:01:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D96898E0002; Fri, 12 Sep 2025 10:01:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C10C28E000C; Fri, 12 Sep 2025 10:01:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AA25C8E0002
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 10:01:45 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4971D1DF83F
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 14:01:45 +0000 (UTC)
X-FDA: 83880761370.22.79E9D45
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf08.hostedemail.com (Postfix) with ESMTP id 86D3516000B
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 14:01:41 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=rIuqf+jA;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=RwBvAnlS;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757685701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7X+xoKuXbq1dokEtS10f9am5D+FDYo9gHwQ8rxsJsg4=;
	b=JF80mhdKHuFJAZpqvUeuh/6MU/zVER/W//OGebxZTRXtxkdsa/KI7kKw1Y7rF7tJKKEB5/
	gVgGHI56W7qguRdqzJ+06ZWJ7L/0n9nuIvZhHKzj3YY/RgMag49/YqDyPPSjN5UFm8tToM
	thk7YBy1JlODTewSRFEHKZpsDQ8Pblo=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757685701; a=rsa-sha256;
	cv=pass;
	b=qUycW2CmjKYPuOyUVLNtGfNF9wCaaevcKmxFcLyqS470GWu97H7MEeZ45SkeX1V0zTnnYc
	XJ0rfwjGaslsN1cZDBZXjBNPYJYenLJBBVGsViKLeD7sDJ7iAKbNZ/2VcwGEBa9kFK8jqE
	Ia/P81WgcIWfthCC9VVDdTbPsbUnW1U=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=rIuqf+jA;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=RwBvAnlS;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58C1u83m008817;
	Fri, 12 Sep 2025 14:01:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=7X+xoKuXbq1dokEtS1
	0f9am5D+FDYo9gHwQ8rxsJsg4=; b=rIuqf+jAvtvnOZOhUnigZ1kDxdJSzTU0Aq
	9BZQa4G84xnD2WYU70HsGQxxHpbRC2oPRpK0HbwaA/JQwZ43FizfioEp7YfL6/xq
	ic1yvNlNh263+QibLpGmeWzAidxY0dx4sVwJn/1vTlDVLPoXYQ/JDmImqvsLuyGm
	xaCopVOSyois+989EMlkRExKYWkDMdEtyiYRLiqIb1Gv+FlMYrfSWZkF73PO9xjv
	Z6sJhH6WcjmDn2gL2ZutOSd0HMmXRfKk1f7wjz+Eq8tj5bWuFK5VyT2k08GXVDdt
	Yco/pCPl5nplGKsTT/cD6QfPMu6ni7UCK3aQRkDRR50EsVslwncQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4921m308r0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Sep 2025 14:01:09 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58CCuN8H030737;
	Fri, 12 Sep 2025 14:01:08 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011037.outbound.protection.outlook.com [40.93.194.37])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 490bdduw7m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Sep 2025 14:01:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B84ewTFCa6BNFOH6CKcP+S6G951vaF01x6T864hcqqpVXCyystzmOnlhxZEqiEenJObswtOrw08b5teFb8eOWKdpZwVzimcv8+aiZ4F25lNfhnpcTE7URwriN0lxM4zEUu+R1uKSNNFYzO08yl/0KEy5PfGnpaqiTp/Gj1T08HRwPwa50U4IFu5vxnSaMtMULqMVy2upXgV4bTTdTNxAdGF1fO75v4phoKA6TCa35e0V+ueeNu/QDN7bgkfUy/ccMYBL/mA03DIQDelEo2ZGaUZknIQn2BbAeWIzJN17VQ7FC9YRx9nFHjnwL8DctU2zAbGEVqIdXzXjYB3XPbzCkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7X+xoKuXbq1dokEtS10f9am5D+FDYo9gHwQ8rxsJsg4=;
 b=qCSAjNblPwtyEko5VC7VsfKitYe76ONPXNwI1hv+jKvoCrdpVHQYJtTMwjBswupZedY+jFmNf4Px4hTvLnQmw1czQ2vVqFKWOGlAsEEHM706Ui5msnij6o6nzRLQ1X4UxR2e4BjhR3r6lvqBU7dPAkTZST576FttCDG7C9yQodRawHI/fHIqZ6akgmvOuyDQ5KZmPWy9YN4TK167bQ8dFCh1LaXd6aU8xNhFm/bwSW1rlnIvS/ycSg5Ee2waz9vmccamZirxrYTmsf3Djsu46RvzO7netuiY6X96VePAm1BcNbcSOtuycYWvsD6KUwd0ZtQ0ipqZ0ZJ9B0VJv/jH/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7X+xoKuXbq1dokEtS10f9am5D+FDYo9gHwQ8rxsJsg4=;
 b=RwBvAnlSW+prCWuQLHOmP/RjWczWcKdXm9RdbPvi783jiEsNYOzy99VRhuSZuddQ4nlQLGjsQ+hB6AUNO6OoixmOIksycK5f5cr8PDHc3ncHcpFBmaaJT3gRb6QADQvR2bS17jzPXeIcjsCPdOnbtM9BFRTSJaZI/mHn+JbzPTw=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DS7PR10MB7373.namprd10.prod.outlook.com (2603:10b6:8:ef::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9094.22; Fri, 12 Sep 2025 14:01:04 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9094.021; Fri, 12 Sep 2025
 14:01:04 +0000
Date: Fri, 12 Sep 2025 15:01:02 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Kiryl Shutsemau <kas@kernel.org>,
        Nico Pache <npache@redhat.com>, linux-mm@kvack.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org, ziy@nvidia.com,
        baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
        ryan.roberts@arm.com, dev.jain@arm.com, corbet@lwn.net,
        rostedt@goodmis.org, mhiramat@kernel.org,
        mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
        baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
        wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
        sunnanyong@huawei.com, vishal.moola@gmail.com,
        thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
        aarcange@redhat.com, raquini@redhat.com, anshuman.khandual@arm.com,
        catalin.marinas@arm.com, tiwai@suse.de, will@kernel.org,
        dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org,
        jglisse@google.com, surenb@google.com, zokeefe@google.com,
        rientjes@google.com, mhocko@suse.com, rdunlap@infradead.org,
        hughd@google.com, richard.weiyang@gmail.com, lance.yang@linux.dev,
        vbabka@suse.cz, rppt@kernel.org, jannh@google.com, pfalcato@suse.de
Subject: Re: [PATCH v11 00/15] khugepaged: mTHP support
Message-ID: <bd206c0e-3d99-4656-ad2f-f57316232498@lucifer.local>
References: <20250912032810.197475-1-npache@redhat.com>
 <ppzgohmkll7dbf2aiwhw7f4spf6kxjtwwe3djkx26pwy4ekrnd@mgeantq5sn2z>
 <d0e81c75-ad63-4e37-9948-3ae89bc94334@redhat.com>
 <20250912133701.GA802874@cmpxchg.org>
 <da251159-b39f-467b-a4e3-676aa761c0e8@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <da251159-b39f-467b-a4e3-676aa761c0e8@redhat.com>
X-ClientProxiedBy: LO6P123CA0045.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:2fe::14) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DS7PR10MB7373:EE_
X-MS-Office365-Filtering-Correlation-Id: 12740f7c-1ad0-432c-a26d-08ddf204cfec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?sUnINvOW1bdzjJTiANxyBUk8Z4uZoZgaT8Cqj4d1HRV+OuloZG4lJRLx9bBH?=
 =?us-ascii?Q?7KQtT2i0quc88JYdSVa2gZcTnJb1+Z02PgYtl/YvecC+t1XlFhEhvd/bXXy+?=
 =?us-ascii?Q?q0MjGcbaa0jlpfpHd3uT43Q3N9kTdPM0W/fu2Xb6AJ2f897ZIpYPGMOqhdh2?=
 =?us-ascii?Q?Dw6xg4qkyVE2HaqXfWIH2zzgC3KTRm5626XUUueAyZxgf4sB8XYiEkFmmbiJ?=
 =?us-ascii?Q?F0Z/TSqELAK03YzU2biueKUHDyjhA0Pqgi6zIwxYrAtfhSdpvr0gMTR66sIa?=
 =?us-ascii?Q?k9pns0vbafh7K+15EU5qhqRbdOnGbEIXtrAmSHlc+5kkm+sL53ZO+oXwCeRr?=
 =?us-ascii?Q?zHzUj1gKInILegFzSP+fayWmhRMeF6sXIQ1JxCnXlatnWjR4hbdeSpKuUuRv?=
 =?us-ascii?Q?VxuxwJL30xbyd5f8FHDnLFOn+g3TXCJ4J/qVEIw0yKhd8pl3liaM2SmrvuRR?=
 =?us-ascii?Q?/630p7v6UGiYN1tzUn57VoNWLAVXFRuFdUERmPMm2gP9ApnYw1hB+OeWLBZD?=
 =?us-ascii?Q?lcng88bYXLauU7JElca7UbPjWH/LjrCXo0fOMYbeAOU8Bg9lf9P3NxA2dTZk?=
 =?us-ascii?Q?v0ZDv8NzhNW71k7PFcoHP9HsePq6+VPJI6Tjgldlm4s/ww98P1j1auFzm10Q?=
 =?us-ascii?Q?AZrVKUU0mw/RqcXgGvSw5nhckHttcY0mOP4AePGT2a4DTnAKl9OoaJxIdko3?=
 =?us-ascii?Q?ccbo14Q8A9pffov6XSgVmGM9ZW66x2rggnY4nyOA37Aoy2NFe4gNdh9pmYY/?=
 =?us-ascii?Q?Q6flHv8MyKXC2nQZ5JEPgrixTwvgmcQDveH9PQDeUFYbwaITq15wBGH+ArQr?=
 =?us-ascii?Q?hy5ATMyhPaOoJP6FEZXbKK3qtimcU227Ryn7QYUwE2z61XHp6eXAh55OnKzI?=
 =?us-ascii?Q?x20jcJXVCZ1nAbygpyrEy4/WH17HMS3/bXTavPrjDdqQy/AyaNf90wsom/dD?=
 =?us-ascii?Q?KMuqJq1unaYJWY5cZ3T7kCPROPXzChmNLj8YMToxGDh/gAkoAZ9EgYivoEbn?=
 =?us-ascii?Q?KJlWhfVRTsmVZWcApIjnATLMtBMr/h5QVsBQcQH4L/yeKrE/G37tSqNMd92o?=
 =?us-ascii?Q?+bSPffIOurk20OmANuKFN1klD8T2qzZb4VXsgYWE/riONxA2qOzvO1SKDBGL?=
 =?us-ascii?Q?VDEdOkUNO6+84HS86HolG8YXJjEdb9oYieMAxWSjiTquxifP5G/D5eAj4jEf?=
 =?us-ascii?Q?RzoawsC/4KtTseUwL4mBqcPB4gT0GfBrVBvvP955+geocIcy6Z9Hq8Azf0fA?=
 =?us-ascii?Q?M6QFj6qRIrs8haTrNgbcA4aXNJZb7XfDFVe1lXEowkTftz09pXnDXguNVYMV?=
 =?us-ascii?Q?4bPqbr13Q8In5HtCiIqrI0YNpiGNLVJ2ftcoRoD+QJxTNSUIM5ZACppvQ3lJ?=
 =?us-ascii?Q?LvH/5uiUzArBxmZyUo6zVgIs+Ywioi4yHW/pt7/N3del6jRnOr0r61JqCPQn?=
 =?us-ascii?Q?zZfQbTN1S4Q=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?a4Ef7dj4//6XOF8YP4SXggrQg0PeyA1+N2dT5rtWxy3F6Za3wSUTyq3ky7FB?=
 =?us-ascii?Q?wEE7qiw1yn1Vp1dx7gOJvXV+CpWLr5D/LD4wndT89QLzOKoOG4SIH/PrQKQ4?=
 =?us-ascii?Q?67WVs6as3voFZWzd4tA5S481lXC8RpeXjxhR8hFhSlYkQUJWZ5YtXyuiedm5?=
 =?us-ascii?Q?vZqwlGuBDROcXqIN3KcpKTu+Vl0TUVwrsE5ueRB4qYp9YclcwiXAsI4UQ7Dk?=
 =?us-ascii?Q?SI0fXMy4c7CLYRD1jBLuRQh8gjdii7+/F5CZqQS6x0CQPWdGzw50C1QH2U47?=
 =?us-ascii?Q?XsJWqjP3zFPYWbBIy2GWL2wa3CBq6P0A1/3SNMAeoUlw2y/GIXfLMLtU3vHU?=
 =?us-ascii?Q?cpWHKgHqPv+HY1wDaHEjCQEZnTwfqNGdK2i6ckSIqK21F52e3ZDsfGunq4P5?=
 =?us-ascii?Q?f/bHN7mNmc8dprjsVwM14+oYV9dLdK8KGXTaf6GAQqQfqx+0mWYjNNR/zI/T?=
 =?us-ascii?Q?SWnjolulpxSt2lPJnKpJTho5sW2nXXlz3HTsptWDuUJRMC0BSY3YQMA8lzUp?=
 =?us-ascii?Q?GQ0eeTvoyzHgIQcKHdCCFkT7DTnkzAKfeE6gtdsbKUfe+/IpjKs4wPrA18wk?=
 =?us-ascii?Q?gwraSZpK9O36dNsH2MkKw8mfeUP9IVsfzUKLxhiWFqH5vFJxO5PH/DfcIKcV?=
 =?us-ascii?Q?p2TSG1na/ienrPeORXXe8l85ANInwJHsHeRGXkrgZYK7FpKyea2q+nPcHaWD?=
 =?us-ascii?Q?5JLmSp1IJAzOxhIWc3grw4ITtet6ubUpZXueeUMnRjtb9REIdRIm90XVUeb7?=
 =?us-ascii?Q?nnVxyg1HaJ0Mi/zasXiSG9+qyMUR339sX2cKrOsh5T88WxoR5D/sTnOWEyN2?=
 =?us-ascii?Q?4jpu70o6Qj5s56ZvWtX5QIywCfx3PRiqj+QR3XIGWd2h/IuRy5LvLAV0uV2g?=
 =?us-ascii?Q?0IL2nOrCOauhMQOa+/EXkK5AzZ00+vVWM6KFTJnQuGCISah13DgFTt7xvtLH?=
 =?us-ascii?Q?6i0eyccNmEhYpaw6HFP3UqWJymr3N+dQ3x0S9g+hyGbYAEiXocxZCd4PpOu5?=
 =?us-ascii?Q?x0STIOYqGw7ospZcseH0Vnf8Tww2nSvfDCcyqTR6/cHejpLP8BD39YC2K+Au?=
 =?us-ascii?Q?UZMj8qV5IjF4oU6DXwjt0UyxbLWVXRu/IAkZU47fOgVn4N84Q6KUvp4BWIqi?=
 =?us-ascii?Q?TNVCyVi3PE3gZnnRFVxdipBG++G91L+gDAb/4QhzUoWJXneT/U8FKKC/PoZo?=
 =?us-ascii?Q?P8guVCPMC3cuKIavqFIruVvddWfBLxtcwGlr1ONxSM4AlnYkEf6KSYQybyKG?=
 =?us-ascii?Q?fXEr/FEe+4jYzlm1812ypwhqCbLcyL16EqSi7NXCcx9YvGJruFxux3XTeT0v?=
 =?us-ascii?Q?AToR6g4K3VviHpTIjBjIgy+j9bNceht6K9o9cv3z+JmDKDGS7dKXY+3F5lLw?=
 =?us-ascii?Q?Wy1U4nT0Xnczcge8WgCwCvihAotqpK/i63NVxWc68v9z65R2MUoxyJsFvJz1?=
 =?us-ascii?Q?hR8uJTDyhQkm8y+QmsZ5azLLZ5hiHX3p6w6FVt2hA+b/pYRbmFQM4VXx2wHz?=
 =?us-ascii?Q?nTqe61FVXO/V0lCHOvmcVhUoWn78xDjQqS1JVx9DusydsPUqKwc26vTrS/mX?=
 =?us-ascii?Q?w+tIc9nalpC27OsJL9KPxHLwNZTH9Iu61UeA5P6e23dIrm8y2zela5Sbe6u9?=
 =?us-ascii?Q?Zg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	DLoB7yPLccqO8OEj7F90BYxurqKD1UEJpikzleGqegBAU/zPUu2doMpPKl2G3Uf3Ct8f+9cMzrIKaJ2LagpVAARNFWpWp3fg0pB9H72sF1aJsYC8NkxC60RKzb/Jl9K+7m/5yz9K2OA2dgHY0awZw79g8eB1Nr+aXZFAifRSTRPuUMIlbgz/T+gBbKj56HOs081HvmjHWdYU0kvWuf+Rw+QLwRP5WGOa/214CDCeyZCe6BsLkBZsg6erUjFDBTMpSUcaM1uH4VCinihVj8cOO6FWvz8KZJk4sB2Ae/BFUjbedW3kl6TrkaZhuExvaGvc54SrphukxyB4YNQ67Haah2vpjZs1JEyasakw7tAw/tlSybVqCQDK6JXhzX0eeb+xY6/tvUH6ItetqqKFMTs/ihcl/GYy7JjCcOzmbd0urgiDc1d6glWtxlWL7MLVzrZxjr5FWsoWETTOab7R4nNSsR09gMObzYm3tfMVOZcxy5iXUn1Aitc88MITkkCg9EgAprKntnHMLg7mBaNTBkPHzDwdnzZKZFPf364Q+Rp/7DRfsQ5SrGKXrQKZXSNRMrhFEViP41E74hR0zOoqJzuA0elgcEJCCdVlonTrx1aEuAM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12740f7c-1ad0-432c-a26d-08ddf204cfec
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2025 14:01:03.9723
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y3b5oLGyiy64BNFseqHOkrZxls+2e4J60LCA17QicqL3yBglwQoRqc0/JhFbkqlpKacJgaS5v2mECYtElKaTphrg8hsvi3/0eCztAzIDdvw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7373
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-12_05,2025-09-11_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 spamscore=0 phishscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509120131
X-Proofpoint-GUID: OMi735b2bsCrkOYFCrxjzWRu0tsm9jD7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE1MSBTYWx0ZWRfX37BT/hGHWDNS
 m9F4tc+Nokg9De0875SLW+7Nb62ugfe5YFIg/LrYkuMDYvTmeaXEgH28S3G5xt/2iUub77kotRD
 E3Vs4S2fz9ct2Gv3KGij5Csl3N+l7qINjW8dtaBmNr68DqI9tv6cIq28uBvbnPugkxwcVXhseXp
 Bo9ZxDguRB9ogRMQVvXWESMhM1PN7AWgvplAtT1lgXlxJBmrSmyPJX5spn0VGeH3r2Dw1whPxq6
 OnQkWNadI8YvB0hDNWak5XF1MbR3GoQYXZN04jSUuDxqSRgate31YWYW4XSEV1pC1XNKHJkzPgZ
 O/DjbHr5dN+qqAFj3/XLMk7RSkPZq6E1Hj8TQMeZ5+HeYPqB4+TfiP/enPhTPEAbOWNIhIH3vSo
 PVXyITuw
X-Authority-Analysis: v=2.4 cv=Dp5W+H/+ c=1 sm=1 tr=0 ts=68c427a6 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=Km7n2Ji0yQxw7v2hIJ0A:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: OMi735b2bsCrkOYFCrxjzWRu0tsm9jD7
X-Stat-Signature: 3g7ho45ugoqdks75o6kgxicy8kb9pcwk
X-Rspamd-Queue-Id: 86D3516000B
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757685701-762899
X-HE-Meta: U2FsdGVkX19UYDzY0k8KB5ABJ2OJXeJ/EzFj2Vb64z8jMzTp+2rIjmgeHqTEwP8MmzH0T1Oqs7PuhQIfMfxm8evWGOpyRBonQCnmpueQaQwTnkhREErDE9p8+3B1mcpcCllWj8xtl6x0CaR6pBYmoPwC3BIc17S6wW+9hSV45MjcsP3oNbMRaMmsdMdcFrYnndt2NnZn1ZqXzWGHk7Lwi/VmYxet1yS03iWiNiciug0oJq4tggQxnTOJ1SC893D75LXtVMZHf/tNMMu3MaqjyoymnfhD96oIv+oAEVdBI94GvGj5DR/g5CTtlUMI6z2GTzhvmSWlum5F9Rksv1R20NjmT45FfTaerohY7Iw6Zvdf63aOTxe6dIwqwZhJFziwH0SFfn+Vzd8tMox0wP7w3BqohF0PnoYmLb1ttU+Doo2UK1eW160BfK3gyuxK2TGixnTZXpRUo9X5HW2kTViDO0cTeTQ/ga3NFXuGrAXZxZxWCct9vGc3lWISpbuthxsu4ZpFby0JQdP3DbR88rjGT9DGU01+8PJ0q8s00yHkiZFfMScXzoJRx+hAppwJH66QSPzjyMqTMIJWs3yVYzwkHVh0YXsHl8KApmF6p9v6Yzqbg0h3uyetH+QRLuencUusRF/UoWTEubw05/Q3m+keUEU0195LMHEw0m32AD1DYiKYp93ioax1j32Gin1ZClxVFRqNBE8ympGuwWXSRIy+0fAszCPD1cdoUaDHIYUMmckdyhPKy/b7b7UOIydPLLmD5JzjeidjHCPkcKx8nZPUovp1ct3LozNdwNNv/KT6YDEJOxA9E/1VPtNWHJLooOu9xXuW98J9LEZgPV1qHyZ1obU8EAbjUQ98br60+GLWNNCbAVYrqfKK6RxjQTEHuzG1IV79KZ9godqyrJkVqttw0riWBUp1mosjTaRJkxech8CwkNTS8H7kpNVKqwyS71K6sjPJ2xgWk15eOw1KNAH
 eATaqI4e
 kNMk4xaoSwyaccDWNBCUQcahvf3EP8dNtJMv/8krUayhfGSSTQI3ejNmgdJIEVrQnjpiFwIZXu4ESYYxhpsOrDdAH748F/OPaZzHIR0QJ02swq8F9/N7vGtuEkxkp6Hrk5bYMM+CZNvLb5a5qI8KFosFCSogh+4Q7fpdGoVcRHupfEHYsTQkVJamrHWdgzeAFYt5mK+68IXQCWjph/2T6BWTSqhYY639y0bgHEUOmOBujqMkS9WbhNq/pVKs75uEYC3Byyr0TuwCCrzWOlmkUOeREryedSEJNUpyJd+3+tknJkF2cDTJiOPtsxtUvHbrF1Z0bOvIZ0vWa+GOLt+LNiVIGgTgyseJ/ZGYFeMEflnOggfBBT5IxjABoi4psUKxc/DNmKJ1xmGf6v9hNNhKdbLImn/Z8Zy6WLC3wWjeNdOQg3fW6p8VcLtV8TSAmo1+F9H9uygOPsn/73RsVxL8SZYCczZw/7rkqng3vZZOBHGAcP8weuN7q/P7hVOZ2xaS8l8E4rA/FJt4410IeiQumVPFxf6Ek7poSETThsVzEMa0ecqni1he7fsUOCT1d1k+0G0wJWXTMOLmVOb5pRJcCyaOdxphPtVHoBB7r7XeQX1qhik1PGFCieQ8dVgSdlLyjVEV4fc9VFq0sGTrg43tKj//9c2tCYnKWy226lMvUOQ6D0MEjl1ti3OcgXtL2dJQ4SaLqqRJq9Mt+ReLwDdKXZRQwfJrnF9G7gvhzRDAsToTWmM/0tjymabfGbQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 12, 2025 at 03:46:36PM +0200, David Hildenbrand wrote:
> On 12.09.25 15:37, Johannes Weiner wrote:
> > On Fri, Sep 12, 2025 at 02:25:31PM +0200, David Hildenbrand wrote:
> > > On 12.09.25 14:19, Kiryl Shutsemau wrote:
> > > > On Thu, Sep 11, 2025 at 09:27:55PM -0600, Nico Pache wrote:
> > > > > The following series provides khugepaged with the capability to collapse
> > > > > anonymous memory regions to mTHPs.
> > > > >
> > > > > To achieve this we generalize the khugepaged functions to no longer depend
> > > > > on PMD_ORDER. Then during the PMD scan, we use a bitmap to track individual
> > > > > pages that are occupied (!none/zero). After the PMD scan is done, we do
> > > > > binary recursion on the bitmap to find the optimal mTHP sizes for the PMD
> > > > > range. The restriction on max_ptes_none is removed during the scan, to make
> > > > > sure we account for the whole PMD range. When no mTHP size is enabled, the
> > > > > legacy behavior of khugepaged is maintained. max_ptes_none will be scaled
> > > > > by the attempted collapse order to determine how full a mTHP must be to be
> > > > > eligible for the collapse to occur. If a mTHP collapse is attempted, but
> > > > > contains swapped out, or shared pages, we don't perform the collapse. It is
> > > > > now also possible to collapse to mTHPs without requiring the PMD THP size
> > > > > to be enabled.
> > > > >
> > > > > When enabling (m)THP sizes, if max_ptes_none >= HPAGE_PMD_NR/2 (255 on
> > > > > 4K page size), it will be automatically capped to HPAGE_PMD_NR/2 - 1 for
> > > > > mTHP collapses to prevent collapse "creep" behavior. This prevents
> > > > > constantly promoting mTHPs to the next available size, which would occur
> > > > > because a collapse introduces more non-zero pages that would satisfy the
> > > > > promotion condition on subsequent scans.
> > > >
> > > > Hm. Maybe instead of capping at HPAGE_PMD_NR/2 - 1 we can count
> > > > all-zeros 4k as none_or_zero? It mirrors the logic of shrinker.
> > > >
> > >
> > > I am all for not adding any more ugliness on top of all the ugliness we
> > > added in the past.
> > >
> > > I will soon propose deprecating that parameter in favor of something
> > > that makes a bit more sense.
> > >
> > > In essence, we'll likely have an "eagerness" parameter that ranges from
> > > 0 to 10. 10 is essentially "always collapse" and 0 "never collapse if
> > > not all is populated".
> > >
> > > In between we will have more flexibility on how to set these values.
> > >
> > > Likely 9 will be around 50% to not even motivate the user to set
> > > something that does not make sense (creep).
> >
> > One observation we've had from production experiments is that the
> > optimal number here isn't static. If you have plenty of memory, then
> > even very sparse THPs are beneficial.
>
> Exactly.
>
> And willy suggested something like "eagerness" similar to "swapinness" that
> gives us more flexibility when implementing it, including dynamically
> adjusting the values in the future.

I like the idea of abstracting it like this, and - in a rare case of kernel
developer agreement (esp. around naming :) - both Matthew, David and I rather
loved referring to this as 'eagerness' here :)

The great benefit in relation to dynamic state is that we can simply treat this
as an _abstract_ thing. I.e. 'how eager are we to establish THPs, trading off
against memory pressure and higher order folio resource consumption'.

And then we can decide how precisely that is implemented in practice - and a
sensible approach would indeed be to differentiate between scenarios where we
might be more willing to chomp up memory vs. those we are not.

This also aligns nicely with the 'grand glorious future' we all dream off (don't
we??) in THP where things are automated as much as possible and the _kernel
decides_ what's best as far as is possible.

As with swappiness, it is essentially a 'hint' to us in abstract terms rather
than simply exposing an internal kernel parameter.

(Credit to Matthew for making this abstraction suggestion in the THP cabal
meeting by the way!)

>
> >
> > An extreme example: if all your THPs have 2/512 pages populated,
> > that's still cutting TLB pressure in half!
>
> IIRC, you create more pressure on the huge entries, where you might have
> less TLB entries :) But yes, there can be cases where it is beneficial, if
> there is absolutely no memory pressure.
>
> >
> > So in the absence of memory pressure, allocating and collapsing should
> > optimally be aggressive even on very sparse regions.
>
> Yes, we discussed that as well in the THP cabal.
>
> It's very similar to the max_ptes_swapped: that parameter should not exist.
> If there is no memory pressure we can just swap it in. If there is memory
> pressure we probably would not want to swap in much.

Yes, but at least an eagerness parameter gets us closer to this ideal.

Of course, I agree that max_ptes_none should simply never have been exposed like
this. It is emblematic of a 'just shove a parameter into a tunable/sysfs and let
the user decide' approach you see in the kernel sometimes.

This is problmeatic as users have no earthly idea how to set the parameter (most
likely never touch it), and only start fiddling should issues arise and it looks
like a viable solution of some kind.

The problem is users usually lack a great deal of context the kernel has, and
may make incorrect decisions that work in one situation but not another.

TL;DR - this kind of interface is just lazy and we have to assess these kinds of
tunables based on the actual RoI + understanding from the user's perspective.

>
> >
> > On the flipside, if there is memory pressure, TLB benefits are very
> > quickly drowned out by faults and paging events. And I mean real
> > memory pressure. If all that's happening is that somebody is streaming
> > through filesystem data, the optimal behavior is still to be greedy.
> >
> > Another consideration is that if we need to break large folios, we
> > should start with colder ones that provide less benefit, and defer the
> > splitting of hotter ones as long as possible.
>
> Yes, we discussed that as well: there is no QoS right now, which is rather
> suboptimal.

It's also kinda funny that the max_pte_none default is 511 right now so pretty
damn eager. Which might be part of the reason people often observe THP chomping
through resources...

>
> >
> > Maybe a good direction would be to move splitting out of the shrinker
> > and tie it to the (refault-aware) anon reclaim. And then instead of a
> > fixed population threshold, collapse on a pressure gradient that
> > starts with "no pressure/thrashing and at least two base pages in THP
> > a region" and ends with "reclaim is splitting everything, back off".
>
> I agree, but have to think further about how that could work in practice.

That'd be lovely actually!

>
> --
> Cheers
>
> David / dhildenb
>

Cheers, Lorenzo

