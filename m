Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61462D2D8D4
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 10:18:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C629B6B0089; Tue, 27 Jan 2026 05:18:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0F776B008A; Tue, 27 Jan 2026 05:18:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC7536B008C; Tue, 27 Jan 2026 05:18:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9B5086B0089
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 05:18:00 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 65564D3F61
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 10:18:00 +0000 (UTC)
X-FDA: 84377343120.24.98700DE
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf11.hostedemail.com (Postfix) with ESMTP id 27E3D40009
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 10:17:56 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="pcVnf/Ih";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=LL1q4kIZ;
	spf=pass (imf11.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769509077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kgK2OjwMlvOdfPWaxF4csiCJYKUpOIkB3bnTEJ0+tIw=;
	b=J3fgP4XbJGSE7TomzrdTptkoXOWIUbnzuZgXvM71ifDrnhoOKrchgpiHAbNaZFQUjXxNov
	Z04phuAIMgGcffVJfaFO8FuwIWZeJMWyvNUskAvwrDYwir5g1O4KB60EXf05eYGX1OqDhl
	Z7ybSHkIH+AVzAk/+e0FCywV0kh9DfM=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="pcVnf/Ih";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=LL1q4kIZ;
	spf=pass (imf11.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769509077; a=rsa-sha256;
	cv=pass;
	b=ZsJ/kzx8Q96pFXnPOfnvL0Qs4lUNtS5KAa44kcbDqvOfg+0WZ29Bir+Dfq1b2hfy9f2kxW
	5q2W1v9lkNAN8Pp5tONRls0si/FAA4K+faSfc00reYHCSuIPZT+R7x+7RJ5Qgs29HyfIWk
	rJUySeeYquHE84ZZGjJWjF0VCtysaBc=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60R0ZFwA895636;
	Tue, 27 Jan 2026 10:17:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=kgK2OjwMlvOdfPWaxF
	4csiCJYKUpOIkB3bnTEJ0+tIw=; b=pcVnf/IhQn0pF7Sk+k7dD5/tVZOU4AoPyN
	vKYOsC6BYZTyyodsDx47hIUtaGE+2xnpCOORBsZyLS+Mw8kb8cYUkUoy178mjX03
	yQRatQgQOH+MvmmLaeOH3XduaqA8cnnh3fyFoKboQN+QI+/mEQrl/jRBA2FZJKRv
	IhL/maUIBDeV7099YPsWQ7SJPqdd4SXV3LHZLj7tvI1+DX+ueuWFuyPe2jkCcPsY
	N7kC56Ex7yh0n9H+Syf9WQJiMtdbMpXS6/EQYlJNo29tQ979KYAbBqmbEErBAb6I
	C2TqnKks5iyDyNSZShUSnusTmrU4d8iFffP9JwKMgMi1C+nK0khA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bvnpsbr0p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 27 Jan 2026 10:17:49 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60R9F24D001857;
	Tue, 27 Jan 2026 10:17:49 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010049.outbound.protection.outlook.com [52.101.193.49])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmhdr5ha-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 27 Jan 2026 10:17:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wRYWPZV+eQD6pGOAmat3Xt7LOZGQrl5Th4L49S5KtvYYnarWos+1MXdZBmU5wIlKx/ViJIDrflc6ia+JYoYN5ByA6EJukpRK5qKcACV/NQjBJMg//HReEDwdL40+2Wn07loZHc9eF1Uw9Sth/zsjDKGhZ3+9ZWJCbyegonP4dmx87MPtUkHUSFDIckhPpx107xmuzyxsxi+F0WiVOErr7cfrDVMloiIkf7VTWGtx3siFHBiN5aLSddwX6SWV28d4nXgtPM8sqkoGIhRTH7P1aAsO+jJhXRcxd8PdfpP1pX+deOcRGWWDrV2/f4+gSVrJZoePcGZ/J1PGV6QhM3aOYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kgK2OjwMlvOdfPWaxF4csiCJYKUpOIkB3bnTEJ0+tIw=;
 b=xUtaattjB+Woj5x/hUisW4xpOqgoXhOubN6713kHT81jmiX7YaeWfLr6Rw9bskrOMKuKiGR0emXuMT+qiFhJO8AiqOtxxXeNERdardS4IVW+7k+QPJHsPc4j9TRD6qjyCm+RvZcs1ddIwwF6DVWvqldGrJ8rwX+a5r/xn+MSKTxGs78Kx6EZbfR4EuliHXrFEKHNwtxlkM8t4O1kSpOig1H1kpXBIrzwAWpowFTHIJPFxG6R0c73go+eo113g0Pa6HkfqWVN3uBDcHq/k01E5imIVcXgCYlW43VYDSTVB3bvQ1HqJdeIGSB1MnfOYY4vH+AOgUaV8GByWMcC3gJyvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kgK2OjwMlvOdfPWaxF4csiCJYKUpOIkB3bnTEJ0+tIw=;
 b=LL1q4kIZ2p2n50UcD23vDAliFlCvr5rk/Xhxr5Ydq/5bi8vT2m8vnai7j8f9NgolNS7u4rdChlBOzc4/ooDUjcCcityu+XXE8U9AFdKqFr7BdzxxFGX9PO8c08q4kLyQOWqYUH7iNa2TAhjYW1jgq+udWzlCZH8bfTZFQlx2Y20=
Received: from CH3PR10MB8215.namprd10.prod.outlook.com (2603:10b6:610:1f5::7)
 by CY8PR10MB7195.namprd10.prod.outlook.com (2603:10b6:930:78::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Tue, 27 Jan
 2026 10:17:46 +0000
Received: from CH3PR10MB8215.namprd10.prod.outlook.com
 ([fe80::4ef1:fa49:5a08:c1d9]) by CH3PR10MB8215.namprd10.prod.outlook.com
 ([fe80::4ef1:fa49:5a08:c1d9%6]) with mapi id 15.20.9499.005; Tue, 27 Jan 2026
 10:17:46 +0000
Date: Tue, 27 Jan 2026 10:17:44 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: kernel test robot <oliver.sang@intel.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Barry Song <baohua@kernel.org>, David Hildenbrand <david@kernel.org>,
        Dev Jain <dev.jain@arm.com>, Jason Gunthorpe <jgg@nvidia.com>,
        Liam Howlett <liam.howlett@oracle.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Vlastimil Babka <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>,
        Damien Le Moal <dlemoal@kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>, linux-mm@kvack.org
Subject: Re: [linux-next:master] [tools/testing/vma]  28d7ff9930:
 ktools.vma.make.fail
Message-ID: <36add8cf-86dd-4dc2-a538-a4b413f54e96@lucifer.local>
References: <202601271308.b8d3fcb6-lkp@intel.com>
 <8b1135d4-387c-4c4c-94fd-22bc433a0e6c@lucifer.local>
 <a87f818d-7912-4d2d-9f96-11a57ada296c@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a87f818d-7912-4d2d-9f96-11a57ada296c@lucifer.local>
X-ClientProxiedBy: LO6P123CA0009.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:338::12) To CH3PR10MB8215.namprd10.prod.outlook.com
 (2603:10b6:610:1f5::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB8215:EE_|CY8PR10MB7195:EE_
X-MS-Office365-Filtering-Correlation-Id: b98c444c-ffd0-42d3-488a-08de5d8d50c0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?pu2bGNMzV6TgGbpwY2VAf4WP+FDwLPJyMImgP/qu9S/n+FKQ4FmXoUwg5usc?=
 =?us-ascii?Q?eO9QvO7XTTT20vkmzdMUHe+y1uXNSe2F1Ld7HHnnaxHkNv7gpX/211L3XKfW?=
 =?us-ascii?Q?R9D8qNeFNuTsSRIdjp/Y33QNvtWpLzyw4JVsU5jmkh7bf6iOJNBPzcxLZQc2?=
 =?us-ascii?Q?NHOiphPgaAPay2dlwcbX0SIJ3zqf7VbTLCWs2vYNCZitj4O0/VzkISRTV+37?=
 =?us-ascii?Q?wRcBciTidB0IMIY/z//a0oGMOkvQmvi8NKky+8f2Fq7MD6kRsXsga09d9yPI?=
 =?us-ascii?Q?Qd2EklJz+SPerxm0hTZjx3GSgtU3umFlgl9gC8rnjFFXEW8MjT2vs8uptBsg?=
 =?us-ascii?Q?J01Wd2Y1eMjfRfDsPGOvZoJ1HGqsyjE07UfVAUXL2Uau23D8tGIkxXPTySRU?=
 =?us-ascii?Q?hjdQIOL8zaknO6lQ6uJxl1r7Rh3q3rWvU/UGdOGyDQOf7nb4VYH6MlmsMP0p?=
 =?us-ascii?Q?KqsB1kg7Io6If576yGxxpptqZmaZt2jZinuvzrt+G7Uq3pJZKO9tykFN75zF?=
 =?us-ascii?Q?w3VEZSNcV45EEqP1HsPCItF6U/7yfpav295gKCUCSxb8xvAvxHZHufIlxDTI?=
 =?us-ascii?Q?4AxOn/H0olp1b32s36/MG1E7AwEw7TqQ9jsbrMAQDHuwfPvfXfPSoNkdWpgS?=
 =?us-ascii?Q?Z9V9qyoYopGKTGLz6twrdzorzNVfaOJW7TL+Tpe7NXKLhrJNvN1Dz0Vcamyl?=
 =?us-ascii?Q?4oCT8RKov7JbBNI2lDtYCtUp4nL8Owp8RrifunJnbgMx18VJAxrAPb6ZmeGp?=
 =?us-ascii?Q?dCh0RIPj6L0HreyM2Ma47JxOAwtYT7GGMGIsDLdHvKH2m4HpDs7yCx2TmDEg?=
 =?us-ascii?Q?1HbsjiL6DFDVIs9kyEW23IVzyqjLfT9eAFw49nm31OJ+NYhU0XSv3gLSh6R2?=
 =?us-ascii?Q?aqMdj9+rjGvJoH3LsVIYoJHVn57AjHaRmwj688/vsuTszUTxabApm03on6WC?=
 =?us-ascii?Q?qZJwiROViOZCqEnVOB0JeCV4jX7COZqfhr/1TPT8E1sYjCwW6+zoZPP5VIi5?=
 =?us-ascii?Q?kcQddFInDu5fmbljpQrVJouS1VgBq2dj03TCD+t6R06qPTe8KHU8EejSf7Sj?=
 =?us-ascii?Q?5pCLigr1M4AO3gPn4abUfN5SVYYV3R0Q9AwhdDbcZmADkw9NyYvdfNk8bpeK?=
 =?us-ascii?Q?dXRPJ6y+/5vx6oVzCRVE06bxggpei8oBfEjDtbYrVS29b8Yp+xO2cxSlw1F7?=
 =?us-ascii?Q?s8QU5xKfa8Fb0op9l1xStH+sEOll66CDP4+DckjftMemmAQSYDBCXlBbenr7?=
 =?us-ascii?Q?GfyFB1IaJggm8r3hvkpNYREUSP09G0Ri8hIYFeI+td0pCP+jb/Lf0bpqud6Y?=
 =?us-ascii?Q?OgV3482jbxBxIjEp10HdcYBcUexk9qa7RjB9lDyp+408jAZBnLQ/Jy2c+UI5?=
 =?us-ascii?Q?+8Ki3HcS4kUUa5ScwXjrwRBPRE+b/os5TYfTjMAEd0elc2uM59+B1cuBqn+F?=
 =?us-ascii?Q?vLWPCb5z5ZccE6a+Bf2cEXKmlQkns+690arNsJDCT6u8G/YkUwzme1P94k8I?=
 =?us-ascii?Q?uelTedyVN+k258MMGXHb9aa8yx+0PDIwgpA31wC4NXTQZh/PKeIpf5j+p5le?=
 =?us-ascii?Q?4HYzg0j8rlJmLokj1b7CZixKG6MmOYxB8ebwAN4w?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB8215.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?D4Q93Zyu/QYTOmNp1JXdJ90v53+49jRdmFHrYmkLnPptnvgHV2yl57LsS0sm?=
 =?us-ascii?Q?2fNkaLZ99KO9USpocSQBhYNgCTYZnHYkDwMLGGFwg6o6dfKkVB1Ch+rrujdm?=
 =?us-ascii?Q?SielAjSxGX1WfhrIYp2CB8Fv+7zs1CQRLfA1IDtdZbHEFOqpyEU9RFCwnCZj?=
 =?us-ascii?Q?8LGyymvJysEeBG+s2giGQvmk0n8jxTn+F7BMbhI6vuxdbBc6ng74Og0oLsnA?=
 =?us-ascii?Q?hVoesx0r56jXEhk2EkUbcrGafPEVmQ0ardzVblj4P3Bj1/XpdGKfFu8taVlu?=
 =?us-ascii?Q?RhDh2Ob0DXphsoCXG4ksnDKDfVZXpnoOzWIV39AV92zdUn+rzZlg0Rc/hBEh?=
 =?us-ascii?Q?09XluSoZ147UCmbsrYFh4O45GzbLVoqom7TdCNIsVJuSi3H17bxm9WDVLIyM?=
 =?us-ascii?Q?IO15oaTsIyq+gOcECcuuaglkPZDS6+oBu5KYGZjZQc47Zq/FqnBC6Zh7c/Vi?=
 =?us-ascii?Q?JP9qwtuup9OW64t6iVhET3ZmlnFKc0Zj+wa8MxvRG8Ur2D9lQB5cavjn2RjY?=
 =?us-ascii?Q?xk7kPsZ+HQJluxR8apKQliA8BhZXbKy8Ssjv4uny8Ose4WZ2S4Kl8UsJ7D18?=
 =?us-ascii?Q?Y/xpqrFBasO1sjkHmWHENGzUy2cIVnwKgWUBf9vwAQ8eU40CpPrgnVG9fpJz?=
 =?us-ascii?Q?V6PK+Iip6fAdd4CGRGu4YKSMHo0KZpunldFS9vNVKUQbRQSgcS+qYI2MB9bC?=
 =?us-ascii?Q?kahrkF+i7NLOVBIrUxdIQ2ZCp5nwkJiqL2wQWVEGFogqnscae7LTnWtEjRLF?=
 =?us-ascii?Q?1PHJrvTLR0hpA6bDzv6cFb3GDGy6IRBDnqdSxEVDGf7/ivT9e12kGhKNxfi3?=
 =?us-ascii?Q?W3NjlWzR0YEg6c5CaAuBCf6J2MuW271oxxIlHObzKhwu6fJHnNUWQaqnP4eX?=
 =?us-ascii?Q?kfRhymu9HsjinN8IALyeFPcxOkB/fzSgREN5UdhBeo/wpUZNUgPjoV4Qt9Ym?=
 =?us-ascii?Q?jOECbQrItVQQRcVBt7adELu2g2NZC3tuwgivMrWv9QGqylKKAkj3w8ZDhdxN?=
 =?us-ascii?Q?qYxiCS36ZKBG5JtSmBoZdiMenAA6sOtBXcq1UOkQMpoXzOlMskdL8aHQmMRl?=
 =?us-ascii?Q?JMMUnggCmTwv7mqjMMsEzxXiLoDS/LSjz3Li4ddt+mOwLLnP8MNvQpPkvC+L?=
 =?us-ascii?Q?nW39dlgJymepRq4Sjfc7an8qk9ihJ8fKrjolu9VtQ7NvbRUXMAHfdg5iXEUe?=
 =?us-ascii?Q?Pn32vhzCcOqD7YsbDWxSJtyjYOfEpiu/FkiCWhS/JcxVDyoPa7G5gXVAaJ1/?=
 =?us-ascii?Q?tQBM2eCuIrp0ZZvN/zrFn8XrNYJLpTMPl/TWhmTbUDElERWmwEYNANaolRDL?=
 =?us-ascii?Q?HI+Om35u+51A6/NWBUxl79K83j7RW7L+paLx0gZLzyJHWVpscECq2u9C4eE0?=
 =?us-ascii?Q?qi1V0J+vzQwLGS5JemmJygiNKjjW6BNt22CnqwO7FjYkvjSM/SpdTiummC3X?=
 =?us-ascii?Q?qBEse6lKtitoBz4+pW+EjNP+i9HI4ftDpGtNdG9XDF7uZjDoCgtMuVGeWlMs?=
 =?us-ascii?Q?hFjH93iPUnFvaOwqLFyCa+UgoDc64OWSYCXhM8hGGHWL6ujaZ5AZV2wOz/tw?=
 =?us-ascii?Q?MzCjVxbR0/g+ZNs/Rv735PvC5/hJhcUL9JKaxzGWmvMrDHMQZIdajGwwXolY?=
 =?us-ascii?Q?ZUBGQld+haRxZ2Yo8OXFjvWQzohPvjonj4Ut452KWJYdRSYjPBnQmx8Bt72k?=
 =?us-ascii?Q?9LcLpcN2KM0LXtSXrm+AQytc6t/qEV7bXEH3rrb6sydjIkQeCSlK6/gtwlbW?=
 =?us-ascii?Q?5o8x1lRL4N59oYVBn8YinE5YjnJPswo=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	RIUdFk0KLjj/ysfs8L30+BOpWkaMU5KbOR23jaFQQYw1G+KI/4RHS0QPePlYApIdtJVfe5AWxhxgdyrI8Ua91pBsqwK+H28cqJnq8AZoBC/M6xNURdQssUvxJe0eMGgwKbCNdFqU+pcrOIBK7Pee7BukYScycK/KleX92uZB0M0IGn/3oFNpaDb8xVePkQeawkR3idGQHGyJrZQwW3IjxT5ojZftY7fOhCQpIkkrSapBN2IthKwI0/JQgDDtTicfp/iiKjkIxWdPgRRHB8mgWXiOrWvRi3qc8Ql6q6OzKTpP5uCVLs4OlEKtSMeJudvSbWCy97ijAzH1r909SltJAU/wBa6QG6ae0tyPgkgRKUUZrVpto3D0+ZPCWjx3tq85w12V6RaaOfWb+qiets30ZftZjHOMrBb9S0A7VXJyHhJVBVHjMC8Q4NuSOJ+cp68B9RfNXkWG0yrI5V9wYZCeCAgDvqgevqFwN1+PgM5oogifdvRIWLNc8Q8bTqDYbHgWz4J8CQBJBOUn5sjmZx1tEOY5gNnFLL8QQEQPZMC9isbwIz2nBgA4mu4GIqrIeKI54rlE3/yUNXybel9mspHWojvVIQPlU5Rbt46xlGWEIgE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b98c444c-ffd0-42d3-488a-08de5d8d50c0
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB8215.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2026 10:17:46.1076
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3xe5CW6vzxGykeDnI75vg906sFozjgGwXnoxKr7rhVQhaWl98dZLnBGgK9xPREEaMheKR5TeASLHHqSgt6MN9BdHJwhJ11/kY0bMBybY+1A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB7195
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-27_02,2026-01-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 suspectscore=0 mlxscore=0 spamscore=0 bulkscore=0 mlxlogscore=829
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2601270083
X-Authority-Analysis: v=2.4 cv=dY2NHHXe c=1 sm=1 tr=0 ts=697890ce b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=Aj8mH27R4A_JzjEsgYAA:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:13644
X-Proofpoint-GUID: hSCnXrWP01fLRPj-bONQ_DSqraRPyX0z
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI3MDA4NCBTYWx0ZWRfX8BPhXcfyNPzt
 UcIBj6FaCQ3+IKn1y2WcnGttPbSjNC6sJhYNk6oVKZ5qTzyA1fYuNRnU6VQ6uSMz5SQAIvgznOw
 TfbywPD1gSq/y+tmBuisrlYdpbH7hzcPhsQbUkeu4FgVoTkbVi8FM9Wgif2swz1oPCS1kk236Wq
 7k2G12I4FYwiRecaWGTlb/5NvfTHFs7SxivOevukRZorDOqjFdL44OJ3bFrKvovTQ7RZzwQVHwx
 OxucEBzPhJV29Wys8WRTrzHi1FRsh9XKsILnzI/gBJQJdUNhQ11SR3H9ALN72jh0fKooCSvsGnu
 g/dhz5B2U0SjcMCrkeU9DLSSeBCX9IcIBfWaA5KBHKQWvl/ZEPNRO/3U/c4EIpf4cop7z4vBVIV
 rNC7h8I0G78ngBHA7bW/QjOFCCvLoOwF/bC/StpdEqBGjb0aDUr1BH/wY5mJli7pdjTCM54ICe+
 xifU00CSoQOFIyhne3dBwFinp67U60jT7yuG1HAA=
X-Proofpoint-ORIG-GUID: hSCnXrWP01fLRPj-bONQ_DSqraRPyX0z
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 27E3D40009
X-Stat-Signature: xfju1xt8se3gpbaijfo74k49nq35dx86
X-Rspam-User: 
X-HE-Tag: 1769509076-352776
X-HE-Meta: U2FsdGVkX18VP37oj1CJJIWRWek9uEqY+Jb8Oz/UyiwT93kzMmJW3kZxN+/pUSN6vsDVdSzBI81KfTnU1rrQIm0qSMzy9KfaiOwvGqnYbd6mr/IkcE8+bTnKeIm1y8UkrrinsZdFsn/MESCHw1IU96jIbZhnJS4lcz9r2Q5jxFhXXZIADb2tPUVIL6X498h78UMxJOtx9ZuE3+tq32fp6kT6qu4hjxvNRh0RreV46v1NWJ2qhFgoM87zQrZe2anP8KQUdjfuw6NZq5v8K/IviYH9QzCdINmemenn5MW+9kjmME5VfwkbOYCYqPAZLFZArEI5gY3tFO4f9VVoXwxzCBVV2edh0N+OhxFEbkzZv0S0NTv7bF4gRqHKaUjAdgTqbwv5mvCCG99W4FIdR4Nrdu71VPO7HcLk3LdWK/K3a+k1l02JmWyzPH4ix334OT2DS8pdf6DldCe2NfJkY0VW/VCEMl0sNRY9YZi4DLpNChIrOyOqsRTnOhjdL5g/2vH0MYLmsIwICOVOUiAG8pX+LQmsHMmTtkEmeEdMBZ8+D+yy1FsolCgfCK/y4oV0sV3SFyPduhZM9Yr2DcGP8n1ZtsoO9yqzK3z4bs0GK2ORyvuAyTHp1IFAvuDunji4U82crbFCOOVBMpOJsOsnr5Hv+TrG5J/Oyf1lQx+StXVSMikjMZvcjhVfg95U9kBat9XGLj0OP5/LkIfmKgpVgdqh0D84M4SVR5poj2H72iMRxFBRnohbVprhtyDmcYXs0kGw52nsMuJ+XThWfvxqhdv7/tuIC2Z1aeFcRpYv+R80JutlTn/8GR+EsXxvYCjhrpRvSBzSxyqMZkZBIWUP9AKOKZolUHpO9y70J+4/Vo5CXJ6EuHRCkI9l0ng8fjuTaInEhxwbs13TDLS/qg0W/xv5xvhZnitProiRklVf2zCET9m/0OvbPEwVWtmC/3myiUZTPFWBU1Ca+UEWfhnT67p
 BgE1DYm0
 /Iph17IBMdgijH6EkcAgfEMYvM/iudWPyphr2pw9N88s1HSE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 27, 2026 at 10:05:57AM +0000, Lorenzo Stoakes wrote:
> On Tue, Jan 27, 2026 at 08:18:12AM +0000, Lorenzo Stoakes wrote:
> > On Tue, Jan 27, 2026 at 02:13:11PM +0800, kernel test robot wrote:
> > >
> > >
> > > Hello,
> > >
> > > kernel test robot noticed "ktools.vma.make.fail" on:
> >
> > Thanks to whoever set this up :) so far VMA userland tests have not been
> > exercised very much and I've had to find issues manually :)
> >
> > >
> > > commit: 28d7ff99300f3a897eb6419efafdbcf96978f637 ("tools/testing/vma: separate out vma_internal.h into logical headers")
> > > https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master
> >
> > Hm this is strange, this works perfectly fine locally at this commit.
> >
> > But it does seem this is duplicated so will fix-patch at this point in the series.
>
> Fixed at https://lore.kernel.org/linux-mm/1e032732-61c3-485c-9aa7-6a09016fefc1@lucifer.local/
>
> >
> > I notice the build is broken however at tip on next (will bisect), I guess the
> > bot hasn't got there yet? Seems somebody added a compiler directive that is not
> > stubbed out yet.
> >
> > I might simply fix by adding to this commit as a stub to avoid hassle with
> > chasing down the offending patch...
>
> OK so the other thing needs a fix in a tools header, so will report separately.
>
> Cheers, Lorenzo

Reported at https://lore.kernel.org/all/0c2d9b69-c052-4075-8a4b-023d277b8509@lucifer.local/

