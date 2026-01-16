Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15EDCD47CC3
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 10:28:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F7266B0088; Fri, 16 Jan 2026 05:28:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A4EF6B0089; Fri, 16 Jan 2026 05:28:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64EF06B008A; Fri, 16 Jan 2026 05:28:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 51CEB6B0088
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 05:28:31 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EB4E716061C
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 10:28:30 +0000 (UTC)
X-FDA: 84337452780.01.6D9F0DE
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8D61680006
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 10:28:27 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Ih698SV7;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=IzGGCiNv;
	spf=pass (imf02.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768559307;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=rL55WPOhWR2DuZrdAr2d6yaYFu60sjja8gXey1RyCdQ=;
	b=J9PmV/Znjph7PCN5zn1u+PmhQmlaFJJN7TIlzM8+2g6M5wD6Y9p47MtuPdf3qGcYTi/aoe
	UFQhMt/mUM70HsqUbqwlIyDVmP2+Dk0MWdp6yryb9YnyIh6TcZLUREF/QFcgDVMJAERDjZ
	LaeoX/0fzHThy34e15LCM4ILMhlRUlo=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Ih698SV7;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=IzGGCiNv;
	spf=pass (imf02.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768559307; a=rsa-sha256;
	cv=pass;
	b=eg/y2qrpWw1v2rBKEm+NmzpjOZT1gbwU970wOahri8DY54YJYiKVb8kBcYcqetCyzqUUHK
	xYgQfiiJnbVpIBO27Eh2nD2YMTw0gSeDVKuKFmTKnwxbdfPibzuiGKFfuoIKCmmHWBUUt9
	TFm4zc2j9LVqrcMt9TMtVQGZfpIipbI=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60FNNEhx1655167;
	Fri, 16 Jan 2026 10:28:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=rL55WPOhWR2DuZrd
	Ar2d6yaYFu60sjja8gXey1RyCdQ=; b=Ih698SV7aIJl+kQ6v5clJ2+XnLXbd9dB
	CgWiKMYTAGmf6wEAVKDMNOrEghiqFWBmRZYFvTH//swqva0a9X4HWwkqj0yFa1LQ
	zBdpQ91Pe4jP42sewMfLpb7Z6VCQpHLKzOfn2nRqlsyP5k1YDxgfh8PjQu7nvoqN
	CK8t64FLZUB0AI2ddZJ1/bNPNrmi+YKHyG1YjpMtROphqVhWqmVfjrTmDf5H2Kst
	1buh07xuBHh8hUlTbdq4FiJ7FioeXqtg823LPWIGmpmzeQMOq4HOmaMXuNenXeLA
	cEFHmRL8ydOGqAJOSK02BzZtq3x0k4OBVyJlTxxzPVtF/+kRcWg9Gw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bp5tc5298-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Jan 2026 10:28:22 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60GAG4Xl029363;
	Fri, 16 Jan 2026 10:28:20 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012001.outbound.protection.outlook.com [52.101.43.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7ph50w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Jan 2026 10:28:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PA26+bKOPRJaqVeiVSR9pVrOUGRuKElBvk1d9zEuR1ujWx+4LTXhQynOexGPKXbue89xMNcm9ddRKuGQ037LBQL0+UnZn7PqXPzx33Zoq+PmL1sbcT+0i1OUh7QbCPwQQD+DErzUhxoenCmxNIvFF/IfbrJ8LLJKZxfOLh1DYA19IqCJ0cxXj2fHXxp/cbPWHy4V22A1bmRXVtgBbGk6dg8WFxbyeLi1T/mVIPTXGKm2jqikqpPbl9pUtC8jmGfyExVjgNbdeBekbnTblQC/hjQepZXCG7OW0EEC0hj8uNV2AVxqR2QJgDCNKJNGIerG4xPYJ5NqUN/mg0Rer4+yGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rL55WPOhWR2DuZrdAr2d6yaYFu60sjja8gXey1RyCdQ=;
 b=M0jvx6epDi+ohtYu5W8XjnVLBBuMkOBqIMjpKlw2HF/rPCet2247iUBeq8GDcPGCl/YTDEuc8bdbsMNw55K6MUTT12k/pLA2QrVP4JvHX2uNtBuOZ6dCsk58Q8EzEdkeexol/nxRj016+pOGw1WsselPb9IGPqKymnUABgvhjR82yKbbRNFRO0jSM0oeNKHuDDOk3B1KgysKZDYcp+EH0SQmQSJMh8EBFZgAcL6gNzcy2WPrEd3dkE1PfylhUy5RSLr6JCVGUn416VhciIWWf6Jf43YJGaLADa4JPt89d6V+JAi1yve805cJmOHew7EikiRedMgIKpMmnyhUhBdbqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rL55WPOhWR2DuZrdAr2d6yaYFu60sjja8gXey1RyCdQ=;
 b=IzGGCiNvYPg67FWCoqoLF5hQ8gXWqzOCBUI6bAQI38+bTG/vBZcqocXEx38ybX/a1U7w6wIWNZQpwwAaAuLHH9io7dyQFHTZF4aYbgzuOFwSFluMac7lbvGVja9omtuTGKQNshsUbP50rq3/9mbnv/KjEg6yo1ltyyL/FSn4Rt8=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by PH7PR10MB6084.namprd10.prod.outlook.com (2603:10b6:510:1f8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Fri, 16 Jan
 2026 10:27:56 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Fri, 16 Jan 2026
 10:27:56 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] add and use vma_assert_stabilised() helper
Date: Fri, 16 Jan 2026 10:27:46 +0000
Message-ID: <cover.1768558900.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.52.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0203.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:318::17) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|PH7PR10MB6084:EE_
X-MS-Office365-Filtering-Correlation-Id: 3bd04540-3466-460a-9ab3-08de54e9e95a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?87ff2GzFkm9ZokusqiuXBijSJ4kp56bXl9rqdzB6cGQfOj0kdY2cSbDqGNZw?=
 =?us-ascii?Q?/xO0BU7HafejQFivpWDn7RBDLmW+06Hl3XAxoo+lLfuNMdaV4AQa5F+Xssu+?=
 =?us-ascii?Q?VR34dV72p9Wc+LLpgW7gGFMmnFkUAZSmi9Xo/I0S8LrM8YM3L1fNGguHT57G?=
 =?us-ascii?Q?YPkfXtrCOndeGtWM5F581SPJ3zxXSLOk//HRtL93zvKxRMJybTVox0VYIeHw?=
 =?us-ascii?Q?/mAyF+QeVCNE/QlnNAXJO5ZzdZvhvGocRzny+VWFI42+QrPju5iBkT2cNNqd?=
 =?us-ascii?Q?iSBpEL5kjxGWAXH2R7lb7aZeabt0VLvUdjhF+qovn9wd/HDqPMmXC4AU9LOp?=
 =?us-ascii?Q?4nCpK8y5LgovKeo2Va2hEghDDtf3wO8TkYwe6ODbtk9yGChL7kbD+GLyL9lm?=
 =?us-ascii?Q?324F5z+LuYC3DtkI6d0WyObL7BO0+ihfVf3w8xlMjpDtNGfGgKsjPNSNXwUi?=
 =?us-ascii?Q?Maevd7z8uEb6wxHdsd/bBzWNnmKojKHQBmTM5BF74Znz2eRW/z/bj2FwNVpt?=
 =?us-ascii?Q?5MnmbuHKVrF8eSCj2pXCwYghW7LPwDZqwxBR1sX/ET4IxVaPkfn1FhFOmv4n?=
 =?us-ascii?Q?6ji68cGYebNsbA3ZJomBP76wc+xX110naOgQ8N3MoNXKFZnV9lC/NvliBTVr?=
 =?us-ascii?Q?BJzjVoa86xaeKC0Kff+l/vIRes0+iqNGutg5NQ+D0ZdeD3CJMfDZSHgpJcHc?=
 =?us-ascii?Q?TQtP1pyu7Ra4ECfFhaDxewqeo7lWnrDgetwT1TFs6ptWv2Tfm9VJikROzxO1?=
 =?us-ascii?Q?Bv6mxsCVsO8xZw0naI4YPGJdlbFutn4YnqGfnTsty+7eaHGHAfav60f22f0d?=
 =?us-ascii?Q?L9j0J8bNXpNRQiPmLSe/H5GUFWIxbtALffmgroYfrIx5Mj+DA6xV4AcLYNmQ?=
 =?us-ascii?Q?s1R6hRryDIpk/h7+pf0RH2ptrZ8C4DkPkIkmOCW3ysDvcKOxOCybRV+DnvOr?=
 =?us-ascii?Q?orVqRT3eq7+8y1matN3pvdR7SlJxDCMapFWOSc4MvFWlTnCqx7LBZ2r301xI?=
 =?us-ascii?Q?mNQIAZvQma20+ksMgDakM7DuAcKLyeQLPo9Y60lYqJKdp226DoU1SeIrfAHZ?=
 =?us-ascii?Q?wtOZTxrtpmQNnm+FeJ+zP0MDTVH+o/9e5v/8V5z7wDlitjwG3AugOEwi9GBG?=
 =?us-ascii?Q?hhIFnCQYg+U3QYYy/TE6jdaOu1bjD9S1x7rSZHg2sWV57k3B9QP+1WZt4OqW?=
 =?us-ascii?Q?eWvA5FbY4Lrhd9opBLA+mmvrPLl4O0OZDnmYhhmE5Ab1hTZu05gK5tV3U2bF?=
 =?us-ascii?Q?nue0vpkrdwgmQfJx4fkV9pjREFhTGR8HEsj3ZMIJprQGSOfcK0og6WYofx8R?=
 =?us-ascii?Q?iDlSfalZf7w+J+kYz1qPtObN/TFfHBSlzyA8LhLGmxAsQLjUlm3nXUDLYrPe?=
 =?us-ascii?Q?Aw7RRBr4MgyRl/qUtVwWWBUvZapAgftDFuP87ZwZzjQqdfR6ttyEtHYj1wZk?=
 =?us-ascii?Q?k11xD8pWHLRzDsA3qP4AT9jPz9gacIwGwHFU+lOEee9+IDTZzU4pKAkgFRFN?=
 =?us-ascii?Q?L/qp85/QBjFFtpmS6+upxWjgvcta+lcC/yubAtD3Ma8qKjWS7Qag/ZQFf9hN?=
 =?us-ascii?Q?FS7xl6oW8UNZYjW+jis=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Z/k6V1RvDg2kmQUMVEb6htfnt3/bfe8+Nu7W5JkXTAXFWALHd2u6mSJmjMXP?=
 =?us-ascii?Q?MT0/BdZXK34MHAOMB4kZEOZ21ZNZWWFYWDhV3JDscFKfWAMFnClTcnRR/lOa?=
 =?us-ascii?Q?3z37POt8WH58HfJX/Hg4CHpgLyg+lwx5LH1+aeLmOjStcEG8crfP3Jrq7BNq?=
 =?us-ascii?Q?fwzrnpm/JXJscpX3QAz4zxOzQnZRhbOVmppTWxLm+B0cWlDwGALjtsjfju5/?=
 =?us-ascii?Q?WvkgeZ9pWxzOADDM33OUIhKegOLdJpCile0mZZIuniNVSL6uyoz2gzE98xXO?=
 =?us-ascii?Q?tggOIWK+b8aQssLfLStP0GjInWZ92eFhuFS8BIOn5Xgl1S4242pKMC3xCGxg?=
 =?us-ascii?Q?ghoQWzk6yXteI/gRePb7zXUXHEpePuUZG3vjheCDM0h05J52rxAzjZmfiPdQ?=
 =?us-ascii?Q?l07SDTGvgUI+1RxKgqCUbKY2XkmDfyfrmm7P5Bxv4TGrGdiU+04cPkddky9g?=
 =?us-ascii?Q?R8cWEtefnkAZtBipeerF0eWqUyn/s915jOnshT8Dw8CXWSdN9noXqVTo7ZLW?=
 =?us-ascii?Q?pKKI5lF0YMXuITu8ZJThX+EeOUgm/qVWFPQ6Iawq5c4x7Wrjnx8dU5P5XpPr?=
 =?us-ascii?Q?7f3jXuAuPUMtE2zjauKeNRAGiq/g3kbad9kBn3KCj0M/4vh/VvjVjAxA/e8S?=
 =?us-ascii?Q?gmKHaoKZos7gkZdooeEBFYcqIRw6gZQuCsV8ltbC1KiihWtplEAC3UfYYzbi?=
 =?us-ascii?Q?whKvcTR6y1/rD6iUXJfFZ7sw2kOcth6EcfDiwOwXcYaCMOgqRmVdn7UvBKca?=
 =?us-ascii?Q?oj6Om+SDTAAn0W6QJ/3RTYbsT5mfVO4GUAargKmf4bh25wT7w22w7oNIft+H?=
 =?us-ascii?Q?VvI2Hp2SgmrCB0vcLg01UAkI+ou5VXaWEe1c2c6egodfwq8gV7bEZ9YoSF5m?=
 =?us-ascii?Q?vtqRRlCN/Z+eAG/16eLk9ue78exhjMxqyXRLL6v4g2HkGh0IpFhaoWJYDJfF?=
 =?us-ascii?Q?6vTsADIa9Nlq8rNA2cih/d08tyeSDolmbQzYjOdTRCqbR7iegH/hKacr9dhe?=
 =?us-ascii?Q?6lLK02X4Fv6UI8NmmdolG06hasef18S5S7SGvZm8zURdFcaI9V5v64HssBGy?=
 =?us-ascii?Q?+T13AeGpM7avKoo8gf9H2ZIeGwxJLKdnW7unjVGoDb6KTs8iR3bioebIsiIE?=
 =?us-ascii?Q?amCJOCmkEBmbZimnxuRqlNxM/pp0dLZsJKJfVhG/ZLdu30YmQgR2FMWs1BKl?=
 =?us-ascii?Q?SzdND0EssJqprNiTZTMaX1JLePo1LPZAyJe52kqSJ3cXJfZzxuQ3Jn0sFc51?=
 =?us-ascii?Q?kfPwCxkdgEepZAbWYPGe0AfkR1BfHr28XQDhNv2aak7WY5mxiUO1MqzyyK4y?=
 =?us-ascii?Q?xHxFLbKiAdHu1qdQxLCSecnk1HbHMXvn7Zx5EMtDyEwFCsZnJ0nLG152bqgR?=
 =?us-ascii?Q?5/L6N/lW5x9OCmIzOTagYc7lC9Ut1KCrxyeODk0byeoyx7gXgV0qwIaDnpAS?=
 =?us-ascii?Q?FdZYIWeJX9hs1dk35q3AmncoDOHQ8oCbDYynPNUUYtPZMd8VcVRFjLODQ4GD?=
 =?us-ascii?Q?BXB2h86scmGdMjtGJvkj0qBHLKZi5k8ex4pWCm9hjQ29i45N51hrVlAFvfdt?=
 =?us-ascii?Q?wJAUaOH9sGWcOXNkyNglm26cfSAqmIBqBcq+1zjQ7HXKy7ABKuwNE0CUnpzW?=
 =?us-ascii?Q?NW2K2+sGXf0vIyGuLmmM2ohn6RtiNRGhw+73gGuo8Jo64zToIbHaVePuhqlC?=
 =?us-ascii?Q?2AA4EsTVMIJU32s5HLqc+0WHtN7fcmgB8sggYMfftrReiEusWHd8/ZtK+3pe?=
 =?us-ascii?Q?eQBr4Bi4Nx6xZRlsIueN7oGJpkBqceo=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	WkQslPLpSVISXyL9x1Q3xsEcZ1Cf0LEHjEpPQ5xeMwti1t1IH15aC8N3KJhJgSxSjmnYAhfEGodfuTfYunhAFdTdD+3VoglHrxJgidO+6eFnChQ9suBM+kYpTxOCKjmUGZkaaDPK3tPgykcf54txWSzaSjVzKsBngmFLB0c5YvPzaSSl87l70ZMGkNlCkrpEBMfEosPam4kHeDj8h5hJNRECI9Yr+uaxfqY5fvjFC64h5vQkAt4ZAyfaGPkJAWqUFUpmgAzukV1LXs1HxRyNo7XtIaDF3tsFCAzIGzIeRPAcXmrbDDNNJvuR4AksakTf17K7Arxq7jnc7ix/WoWRIebz7eUlUt2n2/H+zaQ51m/LHI4YY1kVrvCKYHeGQm1wCsSx0JT7EABXmd36Sm8RFVQuMzueRqeiUpKSWVTAlIwNhU/5Y0BFsQ10IRxJq2SkOf0EkoRm09SI+TujvECCZtDiFmXtfuD8cbhDu++2/U2tcZA4Ym582hcIrZ4O4IB4fgynbWIX31kw/kL+YAJEvHGtImXscMOo23QshTCccBTMFf+bbwiPSaOUtSJcFMUuBDrcWIVlqOEfNwMyExGXcYqRdbYtF5wpp17/jhnWZak=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bd04540-3466-460a-9ab3-08de54e9e95a
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 10:27:56.3965
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IvOHmD06pY5AgnyRRMcEaxbVQ2fW4tHRTr4Wgn/xIlglyGJe0XCDKWxE8WwEJKBLDKnLminE+yX7J9z4YsdypTlIYfd/Xgfpzi5FWxtdDpo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6084
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-16_03,2026-01-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=450 suspectscore=0 mlxscore=0 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601160078
X-Authority-Analysis: v=2.4 cv=XP09iAhE c=1 sm=1 tr=0 ts=696a12c6 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=9-ADcpnOrhHNghHbY4EA:9 cc=ntf
 awl=host:12109
X-Proofpoint-GUID: sgRAW1RKWSJsiVwQojtOGrCXJ5cZXU6y
X-Proofpoint-ORIG-GUID: sgRAW1RKWSJsiVwQojtOGrCXJ5cZXU6y
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE2MDA3OCBTYWx0ZWRfX78q38+pomwLW
 mEhoNyVXkHjlIMjHzJi/knnPrYiHbNpGivwFhMp0O9o3Zh4ZsvXO9oQJYYxy+0lZJjy/M4cJvQS
 wXjxgQ2ldQeI49QSJPe6fV23a3ey4pqYNzem0ZTZv0mg5WyW2SZ/FwZx15YZdQOwza7WjZ7uSD4
 pj5WxO8X44wr0W9hw7MrbmzZ8vR6yj9r7GwECADJY2QDTTKnj9QuBH3ohQoQ36rqNWBa20G0+pm
 h4Z0gybPhu8XF8BgxYfEl6NrQvfAHsKf5QaUGuAs3tj/yoqJDRZZE8bVv4YfFbUcmPsuT1h1wmS
 pXmB+zCzVk5Bt3DXkHEelH930foYeVHYv4+5se3WEyYEjRj9tHsxufcPTYOy2yUwQOEFerFjZMp
 GiKzrIkxPd3CKtFeScdDrf36Jdoqzn7jN580CQgSoNWFH+ZGz2pDS70rXddzeDGa7zjLVVXJEm2
 xfNKB0fwYHpRSZknAZLPvpR9E27nPO+/JoDZhbew=
X-Rspamd-Queue-Id: 8D61680006
X-Stat-Signature: zknc54p7ercwohb4q8xxdnso9t4t8kyi
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768559307-795675
X-HE-Meta: U2FsdGVkX1+MBRqQr265XCcgtJ/NKVIoLhyjBkopKljTFVCOYjps3ePi3YB/NPOgCDA2MQ/SZHAxtJU7qqWpedOsQ2BqKKxWMYVJLyrda7ahZ87+O14NdOfNGvG7d29kxlDR85zzGWEpYAfTIsVp8wOsrzbldDi4ptOE9UZmA22n5DZPhAT/lxAyi9/8To8OqCSu6L1i9F8t83IyM+MEmj4p7bNXdQ2QjQRw92LU1mgP1Q1NSp2u/aGAZArFQRutMAmdwNhgRTb0SVSrqQ5rUgwd9z0/qCgU/ygPudT7cYQdGcVJKKRNBc+LBgCNXb/fvCbYnnNX4CPEVYMGc6Qy9C3GJNmjAm2lCwWpWOobRGL06PrGuGDExtoMKs2x3AHY7ZF1FEujd1NfivrH4Vs62v16CWFs0PmvvlMO1YiKJa6kQP6QdTwAUbFvyBwja9WGdtfxCQfGSLqhfFSeGpAl2kfOz96h2kbx1NkePge7v+bZ1ym0eszm/IPtV35bvrh/u0sYK8gXgJZSKLHeziK3L1ODmBa8B6SOyne3T22y26C28sTYqCQZ2vR6kdoXRnXA42ZN7gWScoNR9k4SW0Lr6eQjFIP94A25lsm8wXhjNvYk5k6CwNyszLU2oPsTRU/sOjGJf0W5iygM5F3L3zAEA16KZ26eSfmURGskxmbr3ajHCBrgBB0exdG0oq4iEVcu54XhV7Ng8RUPh6uBiqSShkjt9QqKaD0BXbCV2pVc9TRWEKfHlQ/nA+YB5WqYa99CxQpVEGRYUKe/CMfKldQtFpIBU0PffZQgww2PTZqo4hLszQa2NHdWDowZFRqIA+vZs2lF3E4LS5MDOjKZ1CSwF3LCITbbsyTBmf3bsOx8hmeaMfDr3V0eO7X1qSejpIzpQsw1bLC3Z6dRxVIesmbUEMXTjEPwN/qmWwomyG8mj+azEQWB0lD/sgsW1JheXcjoZoNU/4J7DBIQOF38nsx
 Prsj0/IP
 trgKmFx1knKwRjfqdckHWIZ2bmqlL1pZOSCZ6J18XWve44GGJTuMxV99bMfBGDvtD5iCMRt+zy8Dc7Y4Sf/r/Kof6mk9lssKK406Nh7OxaNrBFFHzQH0VJnl9MuqNpnFkYTvsaC8Qqr1JU53AbDYmi0TLaNB0w0dKVsM7fwqocyAXV/UWVRs+G+usXiMdlce5ytqaqGzO8ey6AddsJb9/iRUK9VRfA9xi4K1lfnk/okxGOJvY60fRtht9x600WFEPPkrqv6l6WU6SP0TfHY60hheEQN8mWkvpyIJTbQKCbyKDJ+s3H/VbESUjyp8aNthvYvbcHZNHzcmad55vyREJXZ6mkTYJKfpXRhugoynXbbkdeLNzbJ3XkaA3oXv+u4ccDto9n5zX/7TAGCZPfjUYaPahfAVE8sex7CKFeNfWm1KqSMjt0TgeUhONH9T+kvgm7bOFyJHI6jFmdpGG++s2sWqoKg6+wBGdSTxIgJq7XQscxHX0bn/aIGV9Ug/AB6/hzQyq2CAZ9/ITJWs6v5MoyXIHNZUoObkaIV0I7Nsql3HYNTjaPapHBKIQtc1oZ4fvMUXtm6dZoo6KvBBp6UGWApedzICXnoVuJsCPQCvBx5YTg6jxLyERkweNEVAOkD36+JdoQtkv9Z1thzczHEIKEK/LBuzkDwht594U+vN5My02whv12QhkY1LW5WoQk75PYpb2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sometimes we wish to assert that a VMA is stable, that is - the VMA cannot
be changed underneath us. This will be the case if EITHER the VMA lock or
the mmap lock is held.

We already open-code this in two places - anon_vma_name() in mm/madvise.c
and vma_flag_set_atomic() in include/linux/mm.h.

This series adds a number of pre-requisite predicates and adds
vma_assert_stablisied() which can be used in these callsites instead.

However the asserts implemented there subtly wrong - if CONFIG_PER_VMA_LOCK
is not implemented and the mmap lock is not held, then we don't actually
assert anything.

Since this is an assert that only fires when CONFIG_DEBUG_VM is set and the
test bots will largely be running with CONFIG_PER_VMA_LOCK set, this is
likely in practice not a real-world issue.

In any case, this series additionally fixes this issue.

As part of this change we also reduce duplication of code in VMA lock
asserts.

This change also lays the foundation for future series to add this assert
in further appropriate places to account for us now living in a world where
a VMA may be stablised by either lock.

Lorenzo Stoakes (2):
  mm/vma: add vma_is_*_locked() helpers
  mm: add + use vma_is_stabilised(), vma_assert_stabilised() helpers

 include/linux/mm.h        |  4 +--
 include/linux/mmap_lock.h | 55 +++++++++++++++++++++++++++++++++------
 mm/madvise.c              |  4 +--
 3 files changed, 49 insertions(+), 14 deletions(-)

--
2.52.0

