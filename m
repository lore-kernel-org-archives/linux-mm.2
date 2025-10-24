Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 590B1CCD1A5
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 09:09:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBFF88E0069; Fri, 24 Oct 2025 05:09:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B709A8E0042; Fri, 24 Oct 2025 05:09:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A38158E0069; Fri, 24 Oct 2025 05:09:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8924D8E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 05:09:21 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4D497160BC2
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 09:09:21 +0000 (UTC)
X-FDA: 84032434122.16.AA7B0DD
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf21.hostedemail.com (Postfix) with ESMTP id EBEA31C0004
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 09:09:17 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=jx4Vd3TA;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="Wqaxj/WL";
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf21.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761296958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=jLSFBkM0jRnc9Bur8bW8nk/5WCNQvPfH1XvXydXxA1Y=;
	b=Nw0F7uKornxz3i+HlMOBtKrK9B8wHusq3Zr7QDaCBVKD4jzaicyNWsB9B0rvcFqoipbgdx
	dBhcs+vNtjJl1MWj4ySRvEpLOEzJLz1uQCikxMjOaS08gM1BDT7ecRXzv9DVneUbLecYYe
	nf3SujQc/42kz8y/za2yAhf1zihXRr0=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=jx4Vd3TA;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="Wqaxj/WL";
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf21.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761296958; a=rsa-sha256;
	cv=pass;
	b=k6iXcAYR2OtPv5D39sxQvqTsxNeyBslRkvLfw1GhIVxkPwHu1WCWygSwabox1+bhS5We+A
	3FwYUiGbWv3txmyaTJakDiWJZJkNtlmT1oSQy3qNfhvcAbigo9eTSfFTzpD+SaP/kN/BCN
	lhW+ntAkMxD0O6J4BMkc4acK/cedZZQ=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59O3NZ8U019283;
	Fri, 24 Oct 2025 09:09:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=jLSFBkM0jRnc9Bur
	8bW8nk/5WCNQvPfH1XvXydXxA1Y=; b=jx4Vd3TAzFDLK8fhid/ZMkrIxBNgevGB
	cNp/c/RGrEmY+9l3XTSmMK0I93dKQOkqmGbK3mCQkhDuECRARGi8DkuPQC7+oCiQ
	kbKOhzHhCEKI8QKdjCm5xcK2T6DfYZu593yFh1DY9ep7JSehLeS1th55BCTpZ1z7
	E7pQfKNegLHLK8yeTQqXAgIZIqgA328w9IBcg3NU58Hf8XaOangXh0oxOIZ4BmhM
	m2stVKKn8MeD/iljtQn8C6oC1cPQZL+8X7ogwAMFNaMBC9Z0S0RPaSIDtt37REEB
	EFCTDD4aT0mjfvpxn8ex68wQZIkzj+Gu6oBXKPpokiNj/BUCZYKepA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49v2vw3gqt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Oct 2025 09:09:16 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59O89Zhl012164;
	Fri, 24 Oct 2025 09:09:15 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010056.outbound.protection.outlook.com [40.93.198.56])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bfw986-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Oct 2025 09:09:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L21JRrJrViCBTEjxXXNu6W3jO5vxIagsCbqeATGWMDQd5rMlU5yaiQ6phiJKdZbE89xKHtT+xCaBk97qoBV4XzpFBby/OnsjY5wvuE8Iar3cCsIzIjvezrTCxeQQQ/EywTmLCylHqgMKhO8bBRzq5z/YPe6Do6B1f0ozGyW3oBphK7x9PeujC8B08wRqmpGc989GSdq9IXP4FnsPsskR4xb2TqVkN9r92qBwOXIIkJypOTunhxm/m8Fe807sGlmJMKo2YkfA/KI0qrWXyRHMiJ+XC5FfUFDyFCNPvJyk0V2C2PteWx5zl7cQHAr0qBWsgw5JlJfJQdAya/sRwTkbwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jLSFBkM0jRnc9Bur8bW8nk/5WCNQvPfH1XvXydXxA1Y=;
 b=IbAUt1QDBLncFTORAN0rooVIUD6fYsK9y6vRHWk1mPc3QfuqvoOKYe/Ka8/ozLpMVXO+VF64vJ8WruTBA0reHH8CTu32G1bZ/dSSmPatOWmybWQ2R7el0pu/Xk0mIncGr6VhuosuZL61db0xyDdd3nDgcHzM1s74O0DKED6XI3/aHzpSiS81pUPTVP3RIvu0kpaBQXBAGjCZrTfqG05Qf6GhxB+QqSzAxCK3Dg+ZQwsk33Lgt5Ik5/wIrmaehSCWCXNb2uuVAfl3vp7jsyFQulc2a20VCjju2vt5uIKYvnSuq+UFWr8Yha8ttXOLiw6HWcd7imhB5w0QPvwKnkCZxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jLSFBkM0jRnc9Bur8bW8nk/5WCNQvPfH1XvXydXxA1Y=;
 b=Wqaxj/WLbc1/bMBy59pj/OuJex55yg/XO+TbrBcBU/S/53exc0ZKXJa6/LNZ3Cjd6HLST8DFrmlw5UTs48uKsfaue8/SxvvnJ3Uahamh90pcQG8xpptkr/bkbIGk2h7qRjyBu6CJnbYWqWmV7icKwK2DOL4BTnUR1s/0sOlIBe0=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DM4PR10MB6791.namprd10.prod.outlook.com (2603:10b6:8:109::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.13; Fri, 24 Oct
 2025 09:09:11 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9253.011; Fri, 24 Oct 2025
 09:09:11 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mm/vma: small VMA lock cleanups
Date: Fri, 24 Oct 2025 10:09:02 +0100
Message-ID: <20251024090902.1118174-1-lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.51.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0129.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:193::8) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DM4PR10MB6791:EE_
X-MS-Office365-Filtering-Correlation-Id: 178fe300-2cb9-4cb1-fbd2-08de12dcff3c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?j8DlpPrERwmLnY0EuUnF5h3mV1mDrUyZWV3evJS1Lz9OjShlbGmy5oHGykjD?=
 =?us-ascii?Q?EhN+YP7cQhxmys/vZJeR9yelFa6+tMAmeU7d1y//XLzlgBSnmSpTowafCCIf?=
 =?us-ascii?Q?lFvkDHPPy5E49yHenHeQctPm1ymWLsuLP9l0VESl2ZWvbiwpeP6rqZa4SEqM?=
 =?us-ascii?Q?5woGJQ3fTwp7qfsnQeYNkxtmcXzyMKJOlvLXyVCeELd26/Y+/mGWhUmpmfvA?=
 =?us-ascii?Q?f/78c1n3AfUOSFBFrrzGSj8dvfrL2nSuquYtvpW+B+OPStvXjrKKhrI84b2N?=
 =?us-ascii?Q?ibDEhyMp+WCIBK2MCup5BYYarPqLT/LpF4Pv7/IZbsy2MbsqYxGN5bAFrIN9?=
 =?us-ascii?Q?E4eAyqGKHi2s7gnH7ClRzYsqbQjIE6k90gZLSMZY0n2XVdifjKL51nz/EXhY?=
 =?us-ascii?Q?MMVQXnknDX7SMf8nKgAurHl2329FTYdJr0l9o49WuhPMP9+iGoE3AU5KCX86?=
 =?us-ascii?Q?Cw85K1lsd+HLOQdyw7AipOwj9KEZ4LmvbZCHIbjaO6IVz1EIkmL0YnoxHcii?=
 =?us-ascii?Q?mFHP+Ny7IG24iq0LzU//M8d2Fu2iLlCRslhS+VbozC+1hGi2SKoCt7XZYSIX?=
 =?us-ascii?Q?82p477zIpX9iPCaBYIZik1WWRcQ6fBZ3nUSedVht5ZQHy98/wnx3q8pMOk4/?=
 =?us-ascii?Q?hYoVeXFSbfSTthoSvJjyjoRlAKmwnKUPmustOk1NknfvZt9zBWtZdXPBdibR?=
 =?us-ascii?Q?dkEZDwBs+Vl2ObXrZJfWOCRkk8RIiDyEw9EWahsvI+nytbeDoSVYvifD3edU?=
 =?us-ascii?Q?a2hFIx08fEiyzFpRRfh+lWPWXXy2sCvyqadS1yxvIsVXTwKxe26E73KrTg5U?=
 =?us-ascii?Q?24truO3TQVHt+EJcJfcwKMvixtql6hwUOsJ+xISjC4YLxh0PWWokNF946lOQ?=
 =?us-ascii?Q?Yr5o89iPz+M9wsDwm9SunZkw5S3VMRyikcziie5b5kytHy2Krocr6zK6W3J6?=
 =?us-ascii?Q?757Fe2DBIeTcMSMKMVWcM/0SQd+4sdcuQOd0no7LokVQGKTlbWLfIT8lDe3O?=
 =?us-ascii?Q?PI9c9ffhkImOHVJyP8Z3g1/k5ApEsbfQQW/kmG+K4j+zUlScDDHL9oApNDwt?=
 =?us-ascii?Q?3KNJOVKQa8sYOJQGWzQJeovH2/CK2DG/emhyGlL2Ua5ef/w/Tsuw5dhaExjO?=
 =?us-ascii?Q?1oNGux334O2VornY+uNzSu7TzPBzNl3A9OofWCVH9xtSUHdyyLIAKsWg0kEU?=
 =?us-ascii?Q?6WeUrKAjAg+ik74lv6uVsGTkzAJxzjtxOgVTtTDO8EZGsDnP+lzDgDVGxlbc?=
 =?us-ascii?Q?skqwQ7izyzdC5TQRB524fdXHM/MddXQw8SzQ6zz/ul98q4fngw0Zelu/g9jC?=
 =?us-ascii?Q?jfqJxp9sZ1R2aORxIBNQrbt1KLa7QT3P2GuHLSdNaxqG7NpBCWSSuQ3mtfUk?=
 =?us-ascii?Q?SMeuM9ZOxNO1hd/wF8PMzBJHQD4XfddYbby4l5i9VRu8LTNNsiEo3+Rne4NC?=
 =?us-ascii?Q?4BnPP6nSrNkrspBRBYoUCwqWdbU6ZD+U?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?533ve6fX//fHXDBHMtIw6EKxmqsG74xiZ5XUNYRauZ/k81XKbl8I7IOJbwhN?=
 =?us-ascii?Q?rpGQ1b5KIlHimtnemDSW9TTH1U4uSc2eRzb1AhZTYMjHJZRLj3rruCEUDpfV?=
 =?us-ascii?Q?dq81UWF9vibtfcMgJI0WbjnEsoPKPPEPSbQ01NoF0vJnNZd2rGRNamBm1Ks0?=
 =?us-ascii?Q?Pie2rcCRYCZMAXEMPz2WPyxnWyFsqGO+ohbefSxZqRfc8zrcliSw1EWF94bG?=
 =?us-ascii?Q?Nr+xoRfF6XdyKBB5l6oshiNy7p0iy5zrqfi+xtuKrdnOR3vYiLEfuoI6d15z?=
 =?us-ascii?Q?BZHsP6pazBbXrX9pISp/j6dhff/FpbZ6RZYJbSjJk8BHYybMtN+4rbPSKXf0?=
 =?us-ascii?Q?Jdy1UcxHUF3W8w4vQQa+VUUiuuS+lHVloafZCcRg2P/TagtgkDXTN2Tnxxhn?=
 =?us-ascii?Q?ESzvHtLOs5wWt0eyeGmaItwKBGzWRTzGlWdIfVd9iKfAZ6MUx7r4OYTWd3nM?=
 =?us-ascii?Q?p2vfegic9dkQO6OBLlSuKLoK+gI92HoUo3/pK1D2bQkOoZHfMs3bfxgly/8H?=
 =?us-ascii?Q?mAKdzsU9OyFKRblzsU5F6hUqcWno/GsQhcn64I4cuw7jSCE5R/RjTdwt7MyT?=
 =?us-ascii?Q?cWvqSkyP7756A5qMIhDhMwlrgjDnkHSACAWiGc914KQ5++PersgWVDPIW88c?=
 =?us-ascii?Q?6vZGU/tWBwuObkPn61mLy8W2AQcN9iCVER0BdVYl3sBlhpBjE7GJDpYypSl/?=
 =?us-ascii?Q?hni6oGjusoGQYXZuIaAIUIKvc8VtyLmneOorRAtxmdQNkI5RsYrJOu26G+H2?=
 =?us-ascii?Q?oIADUGRhbXXQYyQ4tpkaA3yLnA5NH5gUOgUpb6wjV2AAAU+yQSYVP5kRm17a?=
 =?us-ascii?Q?YJyreLIonnzHYkbqLUyjgZS2Z7B3Ukh4jI5XiqUfwLBaQXk6BqUw04K6cD8c?=
 =?us-ascii?Q?xY0wIfURNDYOGtCsck/Nz8cRE1xJgQeMlrzdqrhvCZBHr0Mu8fk17HZnll8U?=
 =?us-ascii?Q?WEauKO4ZvewSOogMv/Vpe57LB2YY90mUFsND06Z0gJ24mzWpfNGWh7XMz6zW?=
 =?us-ascii?Q?h4r2IUfATMWNWmmYfMHZb5uLaJf/AB3CR0J04bhb5i+Y51a1V358SY9wj2mC?=
 =?us-ascii?Q?KppktX3ANguYX63RmAi3WL0gersZNgvFDtefAjdwH824C58FHqNU+F4HmB2D?=
 =?us-ascii?Q?Oh2sEB5uRSKxXNA4uP4EagJAIVGVL0sjxxBCBboVI4bZXpGs388EQbSq4bIj?=
 =?us-ascii?Q?qGRu2tFfmaZbHWGeeIcnMjnSuBN2rlW+TjNTh0g1/d8Cr2aWKlTFKGg9jpaJ?=
 =?us-ascii?Q?tRWhRDrDOabNO2Hi/DL8lNdjTY9/DhlDIny4eq6AmMWRnLO/rCSykM7nFDWr?=
 =?us-ascii?Q?Toh6cmVZoyojJsbBeN/1q2K3u7SrGK9R2uPI8u5PtnA0B1jHKOON7IuHGNUv?=
 =?us-ascii?Q?WiKb71KtnSOC/wtMoVet7dAdp2C8ybLEQqUXsPS2nNoEnz+zaAtiFcQyW/7i?=
 =?us-ascii?Q?06Yj833vIrJmLpRfRo9pVVu3R7yCmx45PFfn/41/LWfpUB6aXmc6dX6UYatF?=
 =?us-ascii?Q?zJ/28S3wJzMZPqCSTpl6ymXKbYlI/AFQSy5jhCLNXIIzjRCX7gfdNkEQ3OrG?=
 =?us-ascii?Q?W49tIftHMI8ioZ8eYLO1IhDayztO2cvW+hte9bKMwa9ZrMsm2rcMOhkeeUTh?=
 =?us-ascii?Q?6A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	pmhnljX0pAlTjUwCfBSJsR9yny9z99I1VD9UTTDFLKxYgv3Zzzba0+EV4buwEH29YRs00QJ9DuNSHHH7jepDSit7h8TNx7Pm4Y9edpbS3Hog/UIv2o9dgja5uBTaOA4A/N7ihVrU3NRejuPc8E8eqrhfSvAiZgbZS9um86yqQUV1NgiL/x/GaNeXjExZcTqfnA+fH3XenvDGBmx4I9GLlZi42lSZSk3RxJTq/hGHX3pSeY79oZ8Q3zzR4qZZWRWm2dz1d17lS5vhbrBdA97o0P4xOrSNQPphzx+mPsbweWlYVfT8DYb66lLVFDyucGO4O8fDrqeIM+HMdq0HbmzOEP2oc0C8M3NEH+8y1kPgKO4LhVpF84K6p2aL23GHodEzQchupKxbFsRdT4Sppxzc7vZ3Ggp6iPw8I26UW/IXLv2eUwhFwzkfs2U0rR5TE9tkFr9/pviWdS7vwZVPRODNAxOyBOaHi2Hg4vBYP2FQgI+O/e56Sawdt75uvhl4ZUml+QPtbWz/iC01+b+3iafX4JZX95ktjUwxI/pgGx/s9E42OgC0sPisuzpfgYSkdbG6kz6iqsXKr5CM7CLJZnRVcVvX+8a5tKVUnf/UsvpRlN0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 178fe300-2cb9-4cb1-fbd2-08de12dcff3c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2025 09:09:11.8036
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W2B2KMDtxnNasLqRt+d3+tSkxor5X0VrouSEeNnkxW3+6nDh4xqHYzEB+8GG5eZ4uOCcqjK7Z5lvGYkELcfoAcu2bFgrrvZ9EEaAbl//UyU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6791
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-23_03,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 bulkscore=0 phishscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510240080
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMiBTYWx0ZWRfXyWtXk0AmVkVf
 o/i7uOalfikmCBDd+CY61gl4YDqIobFOLx/w0/iGoFybMs6GtH+fyWKA3N2mCLNgMvbZYj+jcbs
 b7tOm7J4pBsdrO68Dnmh2eg+YXS8uGF2x6t3rz0/OSMJZl/E0sWx+QHEQhho8uG4ycm3/P7prxN
 Ak7eweAOBB81DvZfp5ecJNCd4vbtbcC+DjQVYEMR/VvYJrTWPr8aq3dG/BQG2ht6ZNXYobkuVX3
 Qk6PQBcE8Dp5Cjhca1TEeo3OTSW66ZbrHAkuficV+8QL4RtlYQ4HGvOIqKqCgq1ZTZO+N4Vu9+F
 7g0big+DmxPZ0RuWEl4Z9iU4a38AYVCRTaNtJRxY6GBUygc/ZBMS8pvFu7Tq2oYf3GpMOv50bml
 8XvbWXY7AfSwOnv9NfeYcPTgNNlrLg==
X-Proofpoint-ORIG-GUID: TpMfOZVFBtdA9_VsNI-Pkdzu1OfUeN1R
X-Proofpoint-GUID: TpMfOZVFBtdA9_VsNI-Pkdzu1OfUeN1R
X-Authority-Analysis: v=2.4 cv=FuwIPmrq c=1 sm=1 tr=0 ts=68fb423c cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=x6icFKpwvdMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=_qL4ACUGATQ6P4s-63sA:9 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Rspam-User: 
X-Rspamd-Queue-Id: EBEA31C0004
X-Rspamd-Server: rspam03
X-Stat-Signature: re4r7t77xu89bbx9m6fxfkxg7bqp81hg
X-HE-Tag: 1761296957-798716
X-HE-Meta: U2FsdGVkX1/N5B+5+zkTGzHzXZPwYz+gZTZr5Qs0zAbLpVS8OoOzVkmBAYyPu6pWTcZxaHBu56JQJGVInEuXfRTS98bQpWe4MiOQZU0wRcWFdtiBcmDJiYYo+cmXwCBRBNYeQA0htiJmcA3D8vN1YLxliK+djtZcxgPqwMmNqJqRIetu4VVPO6fd5FEcZYzU75dgFSsvx7KDmZSO0EttiiCxza9Nxhbm4A6jGbKMnMAtS7Q8s/5r/atYOtFszOJevDbnMuSs0GEcelVAv/jCMINUCXAORK61LKTNUYAeV/+Dc8AT+D3H8Egi2C20YS9+DHadOtyEaD35K4odjfgindPjJA/E2Q/YD/zXzGvU9OVXGLe5zS4Sraaph5Z7vrFib11n/lACcGf+R6yoUVWKLbkg+o5/9sumlVrE7stVc+/o4E38OIWly8MtA0lsMMmDrvZ37zCfHE5TMc5NwdLjGsPdApJyQSm5YIlGDsH0ZLxoI9IHJ/fNHGkPQOVXeKhpStWezXgLNvx5BH7M0wjE8rY/DG+gHdoDonDZTVyjmCbToyWcB3pkfU2Xj3dj1e2rezvTUWobnanQEtz32Sk5vEzt+akK+pKPzjNowE06WdqN7WMwwBSaqxhytYAlu0fo5wjwUXyttq42L1O/CVPH/y6lHPnsyE+hbL0FC3v8hCyaWpR0Qrc5f9w8TW+s6iI36WtDDe+W+0MtKCwmwH/km2GANZ6Z13K+0A6AVMaUGmP7gBT+2XrVIPwhPkVVCNZWpGBbcFTIkhtiI8hsleIIfe/7FEA6l/QyJzoh7LxQ1PaGTUDvE1HzuZ/2kLaHvr3ACZ6BDxtXnDXos+yX3aqW2YPnKagYxyraFAruLN4HjZo+dgUdA9l2XsTJNJgcwbqXh+KmHwNLucAhzZR4L3QCDAyqXncjcQZacDKmGCxoSnX7NhoiDW2k8QGrazMdUYflzFPR09kv6C5FZADD97i
 iedHwISW
 5JNSfi4VOAYqZ0ZTGaXgxkzVK0i3jWBH2hK7QlOoD89Hqg9KPPZqs1Zd0ETSvdwtBoivy9A6QSVYJgW3RSQzxNX0++6wEv4AT8RCH2xA75I0uPYFNfkapPsUH/kjYXO5peq2goxNoWlVX0sy2C3dYhq5GoQMRaoHx32Tx1LjySpvDj4Lw7fJOJvxwHXDjTrLRipRiw1D7AhQWN0vvmJxi/zF2rlc1kubB4SMsFX6EGHwyzT1ww2hcOoF5YM7zV8DJjWom9wjDeVINzc01iOUEMnhI/InUO420oqgKg/9QDdn0W3PgpsVbpKwBi1Sv9UvIB/1HX6qfa2ho4uk0rvgzLo+rFo7+wm4MrIBt3raY2i54YXolWaVE+lGTf/mFjh0s65wgoouJPeHbOTyYdhT2J5ZLlGjh+EIOJjJL/4g7eCFXk/Ebg66HHCXnMKERh+r7O2s9+t0OvxnAIqhGLUD9Zuwpxr6c83bXFbaDrNHm5KvBlwgAOe1yZ+Y3VnxdQ7sWctv9kvy4VZiwE4H1n6RUDvExjk5dZ/eETpl/7o4MzUJ3WzaSgDwR4eSer5CT8oZZH1wDVgXZV8NLTOJjPD70to+YSee97oifQofVpkFCYXeP9gKI+DltM6J384AUyQZbaaUw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We declare vma_start_read() as a static function in mm/mmap_lock.c, so
there is no need to provide a stub for !CONFIG_PER_VMA_LOCK.

__is_vma_write_locked() is declared in a header and should therefore be static
inline.

Put parens around (refcnt & VMA_LOCK_OFFSET) in is_vma_writer_only() to make
precedence clear.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 include/linux/mmap_lock.h | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
index 2c9fffa58714..e05da70dc0cb 100644
--- a/include/linux/mmap_lock.h
+++ b/include/linux/mmap_lock.h
@@ -130,7 +130,7 @@ static inline bool is_vma_writer_only(int refcnt)
 	 * a detached vma happens only in vma_mark_detached() and is a rare
 	 * case, therefore most of the time there will be no unnecessary wakeup.
 	 */
-	return refcnt & VMA_LOCK_OFFSET && refcnt <= VMA_LOCK_OFFSET + 1;
+	return (refcnt & VMA_LOCK_OFFSET) && refcnt <= VMA_LOCK_OFFSET + 1;
 }
 
 static inline void vma_refcount_put(struct vm_area_struct *vma)
@@ -183,7 +183,7 @@ static inline void vma_end_read(struct vm_area_struct *vma)
 }
 
 /* WARNING! Can only be used if mmap_lock is expected to be write-locked */
-static bool __is_vma_write_locked(struct vm_area_struct *vma, unsigned int *mm_lock_seq)
+static inline bool __is_vma_write_locked(struct vm_area_struct *vma, unsigned int *mm_lock_seq)
 {
 	mmap_assert_write_locked(vma->vm_mm);
 
@@ -281,9 +281,6 @@ static inline bool mmap_lock_speculate_retry(struct mm_struct *mm, unsigned int
 	return true;
 }
 static inline void vma_lock_init(struct vm_area_struct *vma, bool reset_refcnt) {}
-static inline struct vm_area_struct *vma_start_read(struct mm_struct *mm,
-						    struct vm_area_struct *vma)
-		{ return NULL; }
 static inline void vma_end_read(struct vm_area_struct *vma) {}
 static inline void vma_start_write(struct vm_area_struct *vma) {}
 static inline void vma_assert_write_locked(struct vm_area_struct *vma)
-- 
2.51.0


