Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60470CCD1AB
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 11:31:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE3AC8E007C; Fri, 24 Oct 2025 07:31:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBC0D8E0042; Fri, 24 Oct 2025 07:31:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A831C8E007C; Fri, 24 Oct 2025 07:31:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 932898E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 07:31:17 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3E93812A220
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 11:31:17 +0000 (UTC)
X-FDA: 84032791794.27.F80BFA7
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf18.hostedemail.com (Postfix) with ESMTP id C2B411C000D
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 11:31:13 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=jghT0hJg;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=mh1VzhGJ;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761305473;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4+4y3JW8sM5X9I7LN6QfQtPWT0Dw94VYTEr4fvCqyXE=;
	b=gjAkbBq8gQfmCIAMjPVLuYXrAg/LSfqtujeGjW/P8F6Kq94nfmPko7xlJy1JRNr4Alwd/a
	lquFYnIiLiAq2+mNC2Tw8D9exhmj9VJbJeXBhIK/79hU/68hVXSxAMw/04XkcWJLv73pzi
	g9dHsw/IDULHjQ4yjBOZQggDu+TWrak=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761305473; a=rsa-sha256;
	cv=pass;
	b=V39xb03TXoP7YheDyDH/xLn/dCVvOnvIso/gtxC+quw5DjVqEs54c+AhBMU/bGIS9HrGDq
	j9hbbiAu2ahMLXiMgB4/FH1hnzEcmfJzSo0HBQ2ybw/OhGgAUpI4q9UMZuwlywFTVqzLS6
	X5SnEUdBb49mlZy0UFzSypVsJvAxdgA=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=jghT0hJg;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=mh1VzhGJ;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59O3NRE0005591;
	Fri, 24 Oct 2025 11:31:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=4+4y3JW8sM5X9I7LN6QfQtPWT0Dw94VYTEr4fvCqyXE=; b=
	jghT0hJgz5kUdF+9T/WE55suGZhSxvs29J8hB04vfA+qz2ULHC+00NoDg3TbWdXQ
	Fs4/cgDfT7N6sk8wrM7VynRTDpzNhIL/+0DgTdEfFt1WysU4pSoHjTz9n9mL46H2
	BAONcmr0bTWvChYbDWezupxJsqlvxk0RdU284m6sBfBaS6/djd43h11CEwnRhBCs
	ItzGuD5+LWjF5ZEIhzeL4gLrHPRJzKYgbrZFHJCFyJKlPlZIKxYQPbEI786zIXrE
	Z8o0AwbxiiirmnhGbiiUOi4vuUKrCNPRPrMHzf86h+QNTG0H+Q3/vW4KsSxQatL/
	cfazs1suY+zALHit2f2ZVA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49xv5wmfrb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Oct 2025 11:31:09 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59O9U0Ia030495;
	Fri, 24 Oct 2025 11:31:08 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011004.outbound.protection.outlook.com [40.107.208.4])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bgty1s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Oct 2025 11:31:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aGrWV7zpAbTc69mN2LCDUR+3TW5lWAA1ns64Jw26AM38ulnMVGuETN3SEHRoEKyIfr6fOlZU8als4+7jElWEOk89NiO8HxRw8d/80fL9/TjAfXLuDGiWl+as63UuwAo8KZ2TVT20MVQbFbh2l1ZAjEpCpwe0Q7egKElCVciwut+LZxiHWuhHI7dmhYi9wSqTW3i0jRtKlngyPHxJkwaOY9oXtl84zs0AJEFndjv/CVYKnhq45qs2InubLtriPA69A0+bVN7ifxWethf/u5teNDYw0K5e3Pzt8392tbE7UNoGNjEp/z+EhOdQp6nBgObFODKFZX5AmU6EvAwKt5hHEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4+4y3JW8sM5X9I7LN6QfQtPWT0Dw94VYTEr4fvCqyXE=;
 b=sKpRjHNevqgjnLDT1dZtjpXvrl7EQFsIUZo3yNo3EjmNKC0jVKu84whC7z8VvbW5OFcfYDkiEdoqpWCbMT8C3z93a0bkMHGH6PaqoWYEj8OYqEt30czlIlMHXvC/Jg9nkHyMjL6HX3dnWPG8hs5GKqhFsPoLvmw/SpV2htHoIrtS7UThXryS+0KGRy+YdjDPBh382NrlmUxZCy0uVyHVXf+XxSHmCv60JAx1Nr3ugfzTH9LOf99dDXWNPqln2p8iJY6iSodn+DB307Uxi0zLRO6A7ROn8HQY+gfw2Z6+L4W21+mDF4NkjQptwCngcPK8BBUwji1xOqJRzbL2pNQ9eA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4+4y3JW8sM5X9I7LN6QfQtPWT0Dw94VYTEr4fvCqyXE=;
 b=mh1VzhGJDZobXSG4wasxWBDFd9mOfDaxDUq2ERxq/P6PR/VylCyrmH6m2Fy+uLQ7fpF8ZtkqvtMTQhRtx9rp9FEpjaWqZriZGNCmOQwOzViqsqL23nN1i0+yzRRo0VjOZMrDTv0DjSMa/2K+4pypKcKfssC8MJVYVsyRum2FXtY=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by SJ5PPF972B28679.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::7ba) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.13; Fri, 24 Oct
 2025 11:31:05 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%5]) with mapi id 15.20.9253.011; Fri, 24 Oct 2025
 11:31:05 +0000
From: Harry Yoo <harry.yoo@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org, Harry Yoo <harry.yoo@oracle.com>
Subject: [PATCH V2 2/2] treewide: include linux/pgalloc.h instead of asm/pgalloc.h
Date: Fri, 24 Oct 2025 20:30:47 +0900
Message-ID: <20251024113047.119058-3-harry.yoo@oracle.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251024113047.119058-1-harry.yoo@oracle.com>
References: <20251024113047.119058-1-harry.yoo@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SE2P216CA0035.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:116::16) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|SJ5PPF972B28679:EE_
X-MS-Office365-Filtering-Correlation-Id: 123ea5ed-afc8-4e1b-2624-08de12f0d180
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?bGOzvSNTR2tXlQWIsWbFZaKV/OKJuphbK34M/0OLH2pVRh1OhJZD5UCG9fEA?=
 =?us-ascii?Q?J1WhYZNipbvCPWIlDwQkD/UVHFkBt7bmyv4kIMhzsgNIz9ciMyaqOFpzYX9e?=
 =?us-ascii?Q?EeoiAwbGLZ2YK3NRSBs3hiBrjmSLIuVPNkR8K5hUMspAfA4/FfXJLyMuND6S?=
 =?us-ascii?Q?RXbyRInJtx1BOu0JQltm0G3/3TTvBV7KxmzOZOAHsjsqL6SzNW7kWezQUjqu?=
 =?us-ascii?Q?cTofPO1G3tUhaYRNGnzsYnDUX9v7IqmQMa4spTYDxqHHwAetRDKoO/Cq5+dJ?=
 =?us-ascii?Q?QAGuvRtUhx9yXaxNdngPIoN5++LJDEwc1HIufB1GXYBslUdveQrFQybYnHVr?=
 =?us-ascii?Q?QhtmFMBhl6s7szrupfsL8bI35FlWX8pe4XThtzHUWIXa6ietTzg6pJU3BlfN?=
 =?us-ascii?Q?hfRviVD4lJCPqLgULrmNUNrU1zyRW4WLicXXw1kxPPkTjd56PaQr5IlqtTWY?=
 =?us-ascii?Q?cBYJ52HURyYSDxlnGBD3rRonX5LvbMSlq6Fv4sRlP6YO21Xthc/i7FTlTk9b?=
 =?us-ascii?Q?NygDwCKe9pERiYRYbmCYhf+IbxxjqoFUqK0Dp+vjL3eVXU1gOG8o6DMV4ThG?=
 =?us-ascii?Q?74BSKnNZyzS4MtAPsdyvB5+JsWJBSKi38hY4xVneY7XCxBnOWM/ScXFhqVf0?=
 =?us-ascii?Q?oCwcgR3Xke3NvV5U+3AQchAYK/qgKujfKYo/a1kuR8rGrhdbBb29a5+Y3dBh?=
 =?us-ascii?Q?HPwvSeRbcu+FwIMYwmYA3sQXQgh1Z6FlGJGsHWx0woUS+ffHCXIj1hrqM4TF?=
 =?us-ascii?Q?DUwjjiXLwY6UqlFL3svXpOoCvO66QYblezQyFQVoiRyNtrZ5tnlqgYjnfWjo?=
 =?us-ascii?Q?uiXDolWvqodgnGBWyEebXlgtQi6yxsgIrbu05BZfajLCyLlhF9O+Mw4OHf2p?=
 =?us-ascii?Q?k4XP5kkM6zDOL/4uLNiaQxYuSPEi3OLGQ1grjMa6zt+9eVoY9OMTYPKdysIg?=
 =?us-ascii?Q?HDVs6uzItjAH1XxVXE+PSBgYUc3S6t7qj51U87ILX1WhZIFqnDZyZSd07Iiv?=
 =?us-ascii?Q?wXdhcNjFjDGUPOT+QIFYmw8Ditz6OGxhO8Pyn1twCbuEAcT60A9lXY5gKEAT?=
 =?us-ascii?Q?kjhzhPbTsT+vsqSlKOb7D4N0JTAoT0ql8ZoihYtetn7CBNPq9cS6Dr2G65wm?=
 =?us-ascii?Q?y5oCJ6GygzVwmpmBPjGU7juQrwzN0QabHhRt8s/jycWp5giIxarnAvBENH+e?=
 =?us-ascii?Q?FSmgZStU98VuwvXUOOWIKK25ksInSFm50UqT5j+pGA2REUbhq46kQvHWnDC7?=
 =?us-ascii?Q?gUF6KfsxuvlFCpALnTDVCnnYutdQe8DRfjDH0bgQiEDi4NPQSflyYZkTbr0n?=
 =?us-ascii?Q?ZAUxNa8PxaNQYMHeJSJ/TOBlGs0/jX1okoSk6zSFw9LpQziiW9eF85y7rOuX?=
 =?us-ascii?Q?y0E91BURA6gRG0HrUaj1li0xk2KNLcHnlFSezr/akk+h6K0i3pcMH+Lyiwb6?=
 =?us-ascii?Q?ks4pBl9er9cxr7YNnfHkBN4+ldhWiPUX?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZmTcrFe44eLvyt5cr787OfoFa6QxzbCR7wYZF0x8rBIhgqrjUcED4gJ1Hfrl?=
 =?us-ascii?Q?lATHw/nUBuc1Ou+Vh3PqkTVwfxWuYlmVctRAb88LfJSLOHyREfwuo9dOv/P7?=
 =?us-ascii?Q?wSCyIgfNvD7x2v4QvzbjeAhAc+gb8GaESAe29ZPrCTf3BVubzazPlWFNAglo?=
 =?us-ascii?Q?vBKaKoU/CGyc88PcwJBJDEICPTWVtYSJeviD24uspOnWbGwG3Yz8KJ1HCAgi?=
 =?us-ascii?Q?UuZJb390y1Y2O9/LiPPfCXjF8e/FqzCYQ9F3MFjq9+mLgEwL/NOu2HIgZC3I?=
 =?us-ascii?Q?VH7KANjf7BZPkGqNoB3xLTdAK8TFRIoD2C/ThrGksf+ZQrHWfv4Aw8uIExlZ?=
 =?us-ascii?Q?qaSeY4DtIKRYrr250BEYiEWl8Qzrn9ivSzV2uhse/RU9zs903CE+wWn2/D2I?=
 =?us-ascii?Q?KzqQtVj8FKSU2uiyZMq/Sfavg0OnKPzI0ePAyrSgPda6yGH4hXL/KhqoxFN9?=
 =?us-ascii?Q?b/n6QWwWSbWrjJT5CkkmGBZIQ2Z/1PCrOfIve/DXiynMJYjI64+zpee1Ndju?=
 =?us-ascii?Q?5BD2U00tkGgxwM1ijVLyjxXRcK91f23uqoAGK9GdI6sWWzOT2Ya7wVMNbaMO?=
 =?us-ascii?Q?xQ9JREIWGCOPBZTvY+8cad3ZMNggQ+biyp2me90m++8JKR6fEcQkUByIux4s?=
 =?us-ascii?Q?BR3/+PzhsHIMUtN2L+U7FtYUY4ZX9/nTC9eBauw+BBk0RjaswzV/Yl9ew75e?=
 =?us-ascii?Q?84qTvDO3J31feZsnrdg9Uk14n4+Z34bKl0Mh+deY9H7HVAgJAPrIyVgXddj0?=
 =?us-ascii?Q?5NheISYXflb5PQRl4bcGHr58CMczHW4ftwRqfxD75bEraoF+gcPKy5x1P77k?=
 =?us-ascii?Q?Xf5ezS95fayXNbFuq7tG11V5ihR67jra9zi2LMKRfTOKrLt+Pa9c0FuJG/m9?=
 =?us-ascii?Q?e8Ix2Zat4Pniex9YhgjHiDzTwHaEGqL6YLY65Z/qBGBuFY3LJ9JN6MxhpkBf?=
 =?us-ascii?Q?8+KJkHou+pUVWkXPKbkX+Ts2biCQxe2KCE8TxVEFT31ob2Hyuq4vWgsJFMcw?=
 =?us-ascii?Q?jXSlvA6QI2fo5owlf5PhCcauuh4c0icNSBh3RBQFyGL+O41A0U9v2ueB5rJ+?=
 =?us-ascii?Q?hUagUV66r4zo9J57ohhw4A9rexRb4wOah3CGltNkUSiS0m6vG7rcqRCWrwfU?=
 =?us-ascii?Q?9zibjEpNa8hRNEh8eknixb8MMmVoJH2ebBChaf+dm+Qq/Jv5eFzqJE9h8qLf?=
 =?us-ascii?Q?++u1o+ue822WcxrHKwQan8rEp2zJup7njDVIyH1JEPx9FbW8LAoRTjRYaT/P?=
 =?us-ascii?Q?LyafHHe6YdR3IcQb8guOOk/0mgzpurMuvJR6FvQcs1uPt+7IZZ7e18xfPPvo?=
 =?us-ascii?Q?lk1nW7R2+YyLdjYN7lTMGdSieItpGeIsZcoRnK/pKVIjFuBRbdP3GJsY6uDX?=
 =?us-ascii?Q?fSVPS/IXQjSQDotVlDkLlOyxlo+Kv9ECWdtgVfaZuQpSRgn76XHEUeRov85d?=
 =?us-ascii?Q?04OoKgoX/++9+kVXOR+gscYgPYkDN8QdU2ccx708W8KGxCQasyWtHwGPqe7F?=
 =?us-ascii?Q?4tPTxMWqsEkwsaL2MiDDATsK3UdHlHZIc+kQfXit66dJfmSyUCWbMJ5KgJgQ?=
 =?us-ascii?Q?zdUG2QG+3eXS09h3on3KSlJpO2cJxVVTYduA6fbY?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	x7Qc1XmFuzUEjDBnX2NKyX2Yw3GVhRZb41tv/eibVjokGKxxZQUKyKiIvx/Q1EWNXUiZkRhd1KPCxPW2t1FJaWvhuoDUpiq9Zo7I2LsCeeORlgnSHqkKZ0xUVXa7QKcVCiASHpgnrucN6wdUUsGOLEtrEv3rATgJook3QZ+hhP6wavpryxpPlnaZlc2FBn2aawk9CVbG7SVU810keH/uvGsmiOtVSxaQkRxKEkdA3faJydbzOzIGhsu5Zx7/MyihwMC71p+6RKHqYcTXYs/XxLNwMXfF7K7MxALn/6vgRLhyunfc+1j+GAG9sDQ8B78DVKKGaKuxrxDbDDOMVn/+EXK8PWAyToJbbmjHUA8zP0YZm6FuRKltKAb+R6iKPBqJWaEFRh+IQEF0l/XXi69npzJRtP+SVcD6Flb/plWfIL0FpOEF1GWMvcSls+AiTpjhiJ/oR0rRhkFZg6wo/+12RPT43yD/g1mVFF3PiYg9a52CT6rJbWloqP2XQm4SL1FoTzUBXuLY/BLDSk8ntpsnr7zc8PS04So0mfJNySiCq8eg/5a53/Ls9x1i10oTEgzrO/VpMWMic0CQ1Z0Yy1ncY2kQuAE2DrqSjbCwWYSI0rE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 123ea5ed-afc8-4e1b-2624-08de12f0d180
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2025 11:31:05.1163
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YMXfYZg+4DUlyoTkQkm6VHqL3Z5I9OBhXs5SWIG5vetT3OgqYtNR+Jm9yunoHKwff0578jFslOcEe3anSqMJ/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF972B28679
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-24_01,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 mlxscore=0 adultscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510240102
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDIyMDA3MSBTYWx0ZWRfX2jCj4ughUOg6
 ZZosDTTjXaWDu0pujlfuv4ejXWgUZlBBD/YIrnEHn4cGlnVEwkW0TGIsvHC3L8Tqxa7LYR2rCVX
 FpdEohqwMvi2ZXVbQxDDK9SJK1HajH5wFgk76LclQx/3X1oXLmk9e3wDOBmiSsCE6QCdsrp/U8M
 DbQhX40S/Te02JbPGtnPmp5xRvXdFlSkyfLiohTM4S/Lp88msJ1HDaMg+was9SlklTJbLbVXWnj
 HvlEjMsuzrK+PjoiXcmvpzkaKzw7KYj/21DBT/WBUqvfMMBnEMEizCMpn+mTC8Ze0Wgrise7Epr
 taOZeoA8l9jUDOaItXMlYGhj42pSvfGmaz2Gt+rzGr0gcvJVFiZBVy4ugNNYGYqRv5rvzB+56Nc
 McpApAFtZu4ycno52Uwm+yM8SaA5NzcEntS8mS0o5irIwBlAVoE=
X-Proofpoint-GUID: RqHPyTCVfCWT09CIumfh6vV1tMNJj-sm
X-Proofpoint-ORIG-GUID: RqHPyTCVfCWT09CIumfh6vV1tMNJj-sm
X-Authority-Analysis: v=2.4 cv=RfOdyltv c=1 sm=1 tr=0 ts=68fb637d b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=x6icFKpwvdMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8
 a=VwQbUJbxAAAA:8 a=H4zga-h3nqlSih3o53MA:9 cc=ntf awl=host:13624
X-Rspamd-Server: rspam05
X-Stat-Signature: yt189mrfo8o84pqsbqyetrobes4i5kuf
X-Rspam-User: 
X-Rspamd-Queue-Id: C2B411C000D
X-HE-Tag: 1761305473-189722
X-HE-Meta: U2FsdGVkX1+k5rJsEIf/84mj100FUVK4fnb+zhnYzL0dpkzQ6U+W45bnkdmBLKCMWgoKpFNf0Ea3eJ/UdJsSLI97MUG7zU5cNZv5fZI6xtc7f7F+l6YWlYU6HPBGTDLzXKY5CekxMBSuw1yOsL6z6g+9c4M7cpvvLcH5ukNPdivl6OhM1fxVjBySVY4vQ1ZK2v/Q6KO57yhL7XF6JZOyrRtWS7fG9bxUzgj163KXmXBfEsx2SpxuYUbRnWeXmhh559tTifJP2iRUGWfoCtrfovAWRlqMjyl1gVQNzhTozwlXOr5uaO/Tb9Z80z5IrX4oYVEVY2d9MAGVTSf3PhcPYL8Z6nvsbVfQdDXw5MatlKW0uYWCkpQo7RvzS9bbwQFDomrCS/AtUGFb0Qu9FOGJEq96YGfAAiTwKNO8sKvzUmNUoYheFlK59p/rsgq16OvFwhPGde4z+4u3KYboog7zf3+W0GESoOL605+TLNEhyN283PGFDe/5mV0B/P6to7S2mQ8TqaLt24HxfWplSfJi81jch8NEVqd9KILSwJywSDMIE+tAzVtwwkb8AZ/FrupMpYzYQgsHckIe9Qt2vbJhIe2VA8slFkxTm5V/zN6VPPBotXPH5Zq/nUHOi+dd7hU5iwQ+gaG35ryOJpxl9nrBCsAJDm5n2AuassXi80JIn07YMhwcn6Jsbp7IJgKc5aywZbWZHJhtz1ZPbm+Y9tjuZWOv/TPskah3t8Wl7uEQ+UDXAIpy/KR3ZrY2LGJn4G2Jsl01/74aPS9x2/r6X0TaaNRaZChqJCSOPrgoqyMbL2LN6XsAK0mh6ohJF8ojJbGNuxmD9qsogsYkBQH/L4gsxJajP6RtivrxOXAb4Gq5rwCgk8ii/xb1yn6bm8JT2U/ktJeBezVd/OXlWHdjrJnxbI+Glq676rFTer8pOjvyQhe2/6xPG1gDF0xNgR9zitaaylTJKcL7wy/+tYXCFo4
 5BuqLKev
 vZno9eeQK87+beYZbru9V+TGi8uCOWtkXJOzzu8uReEwhJI0u5b+R5QbFcXSY07mb6Q0s6uGGRF/HMiNUqqfktmqMq/o7vXNACX1CKOrZqn5VbBocoyI4z7DFaaVf2OKt2EdHo8zsjL3wK5uTGipZJ15Yc5t8dmuX0ZskO1NDJwRUv8VWrp0XtA/EnJUpxHmRinJnxO3DwheCToIGZUM1IEyyAUwXyUUrtcZLuFZMTVdwyFnKaZH99xQkCXIi8EBZTCH3BCDlj4S5PIK6E9tAViVGyKUl+cnul6+rShswKNOSjDeAY6GDgjvyLN2OOabc+8V3bHc/7EzThaJzEekVk6PIpHVemQOjH0Rpn0vjKW/U9sga9/tnhzPwuzy1e5m6gtMFkjN9tJJKW3tjAr2QH8rRI3cxK4ctG1hbqHXsnqDioN+rLIvySiEaU5pqPjKJYUwcp1EuSHjbjic11OS18npCFDgsOyYOkmklY3UpSKkQdVfDKBxuRbJi5Lbyw2vMeoarVmD5GK88+QpzjeLtkMVtyrmek220FHmIGmx8TRsKLnlrJphXw0c+Q3TKDslJEyKgQ/bxfvb3A3HG09/m8Khd+V77+k7BBY07mbRJH1YgeZkBEBJBONhAOeoKZeP8B7bkumBdqPXT+pQT2Iq8qGEF67N9W7TqmtEswi2901V+smIkbgv/+qfHaceYY3mJzEpK5yUES0wt1EJwPSxJ8f70oQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For now, including <asm/pgalloc.h> instead of <linux/pgalloc.h>
is technically fine unless the .c file calls p*d_populate_kernel()
helper functions.

But it is a better practice to always include <linux/pgalloc.h>.
Include <linux/pgalloc.h> instead of <asm/pgalloc.h> outside arch/.

Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/firmware/efi/arm-runtime.c   | 4 ++--
 drivers/firmware/efi/riscv-runtime.c | 4 ++--
 drivers/s390/char/sclp_sd.c          | 3 +--
 fs/dax.c                             | 2 +-
 kernel/fork.c                        | 4 ++--
 mm/debug_vm_pgtable.c                | 2 +-
 mm/filemap.c                         | 3 ++-
 mm/huge_memory.c                     | 2 +-
 mm/hugetlb.c                         | 2 +-
 mm/hugetlb_vmemmap.c                 | 3 ++-
 mm/khugepaged.c                      | 2 +-
 mm/memory.c                          | 4 ++--
 mm/mmu_gather.c                      | 2 +-
 mm/mremap.c                          | 2 +-
 mm/pgtable-generic.c                 | 3 ++-
 mm/pt_reclaim.c                      | 3 ++-
 16 files changed, 24 insertions(+), 21 deletions(-)

diff --git a/drivers/firmware/efi/arm-runtime.c b/drivers/firmware/efi/arm-runtime.c
index 83092d93f36a..53a5336cde5a 100644
--- a/drivers/firmware/efi/arm-runtime.c
+++ b/drivers/firmware/efi/arm-runtime.c
@@ -12,18 +12,18 @@
 #include <linux/io.h>
 #include <linux/memblock.h>
 #include <linux/mm_types.h>
+#include <linux/pgalloc.h>
+#include <linux/pgtable.h>
 #include <linux/preempt.h>
 #include <linux/rbtree.h>
 #include <linux/rwsem.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
-#include <linux/pgtable.h>
 
 #include <asm/cacheflush.h>
 #include <asm/efi.h>
 #include <asm/mmu.h>
-#include <asm/pgalloc.h>
 
 #if defined(CONFIG_PTDUMP_DEBUGFS) || defined(CONFIG_ARM_PTDUMP_DEBUGFS)
 #include <asm/ptdump.h>
diff --git a/drivers/firmware/efi/riscv-runtime.c b/drivers/firmware/efi/riscv-runtime.c
index fa71cd898120..7ceb02bc57f7 100644
--- a/drivers/firmware/efi/riscv-runtime.c
+++ b/drivers/firmware/efi/riscv-runtime.c
@@ -14,18 +14,18 @@
 #include <linux/io.h>
 #include <linux/memblock.h>
 #include <linux/mm_types.h>
+#include <linux/pgalloc.h>
+#include <linux/pgtable.h>
 #include <linux/preempt.h>
 #include <linux/rbtree.h>
 #include <linux/rwsem.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
-#include <linux/pgtable.h>
 
 #include <asm/cacheflush.h>
 #include <asm/efi.h>
 #include <asm/mmu.h>
-#include <asm/pgalloc.h>
 
 static bool __init efi_virtmap_init(void)
 {
diff --git a/drivers/s390/char/sclp_sd.c b/drivers/s390/char/sclp_sd.c
index 129b89fe40a3..7a791cb35aea 100644
--- a/drivers/s390/char/sclp_sd.c
+++ b/drivers/s390/char/sclp_sd.c
@@ -17,8 +17,7 @@
 #include <linux/vmalloc.h>
 #include <linux/async.h>
 #include <linux/mutex.h>
-
-#include <asm/pgalloc.h>
+#include <linux/pgalloc.h>
 
 #include "sclp.h"
 
diff --git a/fs/dax.c b/fs/dax.c
index 89f071ba7b10..1c78fc02462c 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -24,7 +24,7 @@
 #include <linux/mmu_notifier.h>
 #include <linux/iomap.h>
 #include <linux/rmap.h>
-#include <asm/pgalloc.h>
+#include <linux/pgalloc.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/fs_dax.h>
diff --git a/kernel/fork.c b/kernel/fork.c
index 3da0f08615a9..dd0bb5fe4305 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -106,9 +106,9 @@
 #include <linux/pidfs.h>
 #include <linux/tick.h>
 #include <linux/unwind_deferred.h>
-
-#include <asm/pgalloc.h>
+#include <linux/pgalloc.h>
 #include <linux/uaccess.h>
+
 #include <asm/mmu_context.h>
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
diff --git a/mm/debug_vm_pgtable.c b/mm/debug_vm_pgtable.c
index def344bb4a32..e95ba87f2431 100644
--- a/mm/debug_vm_pgtable.c
+++ b/mm/debug_vm_pgtable.c
@@ -30,9 +30,9 @@
 #include <linux/sched/mm.h>
 #include <linux/io.h>
 #include <linux/vmalloc.h>
+#include <linux/pgalloc.h>
 
 #include <asm/cacheflush.h>
-#include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
 
 /*
diff --git a/mm/filemap.c b/mm/filemap.c
index 893ba49808b7..b7b297c1ad4f 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -48,7 +48,8 @@
 #include <linux/rcupdate_wait.h>
 #include <linux/sched/mm.h>
 #include <linux/sysctl.h>
-#include <asm/pgalloc.h>
+#include <linux/pgalloc.h>
+
 #include <asm/tlbflush.h>
 #include "internal.h"
 
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 160a701b13d1..900ae5dcb6fb 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -37,11 +37,11 @@
 #include <linux/sched/sysctl.h>
 #include <linux/memory-tiers.h>
 #include <linux/compat.h>
+#include <linux/pgalloc.h>
 #include <linux/pgalloc_tag.h>
 #include <linux/pagewalk.h>
 
 #include <asm/tlb.h>
-#include <asm/pgalloc.h>
 #include "internal.h"
 #include "swap.h"
 
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 86e672fcb305..1ea459723cce 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -39,9 +39,9 @@
 #include <linux/memory.h>
 #include <linux/mm_inline.h>
 #include <linux/padata.h>
+#include <linux/pgalloc.h>
 
 #include <asm/page.h>
-#include <asm/pgalloc.h>
 #include <asm/tlb.h>
 #include <asm/setup.h>
 
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 96ee2bd16ee1..9d01f883fd71 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -15,7 +15,8 @@
 #include <linux/bootmem_info.h>
 #include <linux/mmdebug.h>
 #include <linux/pagewalk.h>
-#include <asm/pgalloc.h>
+#include <linux/pgalloc.h>
+
 #include <asm/tlbflush.h>
 #include "hugetlb_vmemmap.h"
 
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 8ed9f8e2d376..4f47bf2dc541 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -21,9 +21,9 @@
 #include <linux/shmem_fs.h>
 #include <linux/dax.h>
 #include <linux/ksm.h>
+#include <linux/pgalloc.h>
 
 #include <asm/tlb.h>
-#include <asm/pgalloc.h>
 #include "internal.h"
 #include "mm_slot.h"
 
diff --git a/mm/memory.c b/mm/memory.c
index 19615bcf234f..39e21688e74b 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -75,13 +75,13 @@
 #include <linux/ptrace.h>
 #include <linux/vmalloc.h>
 #include <linux/sched/sysctl.h>
+#include <linux/pgalloc.h>
+#include <linux/uaccess.h>
 
 #include <trace/events/kmem.h>
 
 #include <asm/io.h>
 #include <asm/mmu_context.h>
-#include <asm/pgalloc.h>
-#include <linux/uaccess.h>
 #include <asm/tlb.h>
 #include <asm/tlbflush.h>
 
diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
index 374aa6f021c6..247e3f9db6c7 100644
--- a/mm/mmu_gather.c
+++ b/mm/mmu_gather.c
@@ -9,8 +9,8 @@
 #include <linux/smp.h>
 #include <linux/swap.h>
 #include <linux/rmap.h>
+#include <linux/pgalloc.h>
 
-#include <asm/pgalloc.h>
 #include <asm/tlb.h>
 
 #ifndef CONFIG_MMU_GATHER_NO_GATHER
diff --git a/mm/mremap.c b/mm/mremap.c
index e2a1793b43ce..a0c641cf579e 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -25,10 +25,10 @@
 #include <linux/uaccess.h>
 #include <linux/userfaultfd_k.h>
 #include <linux/mempolicy.h>
+#include <linux/pgalloc.h>
 
 #include <asm/cacheflush.h>
 #include <asm/tlb.h>
-#include <asm/pgalloc.h>
 
 #include "internal.h"
 
diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
index fc7584841c8f..d3aec7a9926a 100644
--- a/mm/pgtable-generic.c
+++ b/mm/pgtable-generic.c
@@ -14,7 +14,8 @@
 #include <linux/swapops.h>
 #include <linux/mm_inline.h>
 #include <linux/iommu.h>
-#include <asm/pgalloc.h>
+#include <linux/pgalloc.h>
+
 #include <asm/tlb.h>
 
 /*
diff --git a/mm/pt_reclaim.c b/mm/pt_reclaim.c
index 7e9455a18aae..0d9cfbf4fe5d 100644
--- a/mm/pt_reclaim.c
+++ b/mm/pt_reclaim.c
@@ -1,7 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/hugetlb.h>
+#include <linux/pgalloc.h>
+
 #include <asm-generic/tlb.h>
-#include <asm/pgalloc.h>
 
 #include "internal.h"
 
-- 
2.43.0


