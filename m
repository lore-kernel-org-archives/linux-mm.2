Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9A82CCF2C1
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 20:12:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 458626B0005; Mon,  5 Jan 2026 15:12:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42FB56B0093; Mon,  5 Jan 2026 15:12:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 311286B0095; Mon,  5 Jan 2026 15:12:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1F0166B0005
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 15:12:22 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CBC641A90DF
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 20:12:21 +0000 (UTC)
X-FDA: 84299007282.17.1389B50
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6E57D1C0008
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 20:12:18 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=cDqeftdX;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=G3i2X8jE;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767643938; a=rsa-sha256;
	cv=pass;
	b=6yBxemi82tljTFHWhpNTC4iOoBO5TIHHmIcjmTGh4lTRN928pndISW/M3oq2DaGGDMTmEd
	vARdTmIvkSbPhR4cueUkaw2FfXSRvXxkfggUDuAerfzfLWRZaiiZPB0x9eVrZXHDiEoYao
	4itWc8kRoE6aveoVNg3aQRfGm4qov6Y=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=cDqeftdX;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=G3i2X8jE;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767643938;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=fB9GHhc3aL4KpVM/3mGMyhYIXFV7YRlOWvYX+3XOfHs=;
	b=cvn1wK4EqM30oiZ7OsilbetCIgttT3pHq6f7KCcKGlBA/EpjKiCmYyuHxpl5Z27pRIKVvx
	3mygDcbhvzUnRZSBxGz4K0j7e+cwCwFK5UIlbzpNvsVPivnLwuNvn/Utf7lXKnhQVxcjXH
	BOxNhmcdr8RLBJpqvNG23FVM9rYJvF4=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 605Jpk3W1920741;
	Mon, 5 Jan 2026 20:12:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=fB9GHhc3aL4KpVM/
	3mGMyhYIXFV7YRlOWvYX+3XOfHs=; b=cDqeftdX98WILE1A2pLUvz+aqBQBbdg/
	myiarhShYnXZ43oH3HqG5sinpA+Z0i1gmUZ0jSo4M2VAm71EspQpFyL/Yht9HPLT
	3/NRE/qcUpB+b5BUM//+a+rbq/YtABy2FFE4qMzO0XZYKla5DtLSPqKLr7Ev4D1F
	+TcfcS7I9HMioAJi9geATyZM8OZLau9jFcA1lfA5CIUoA6Q9y92bUk2fbuQHU+/w
	/2PxJWa1kevFLx1mviRdCmFEWV5KRJ7pb1CqwqnZxgteBHlMiMi6crzf+FE0jLyR
	T9ssV908W6xcNbXmbKfv4wB28isfvNHuP1gG6XhH9GmebeGMSUiBZg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bgktm80wu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Jan 2026 20:12:07 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 605IcKMR030787;
	Mon, 5 Jan 2026 20:12:06 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012009.outbound.protection.outlook.com [40.93.195.9])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4besjbsxkc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Jan 2026 20:12:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TlvH1uJEnSqwaB/7FtSi4akZvh2g8xX+akg7aYulfbwAUB26Br4Wy2jb16gSO/1vMJUbg27wiCRnXL+FAbCy+L1NHmhx9744qT3oRYOCo8LmPmsZdyKOgEu05ZGyp7A1ViqyQdiAzjCGyCKWTQ/ICsvJtZRhzaErwhIQbaNTOsqO2UU5HUCAoueLtUkJwjii1Jezp8YEgr0wLGkjLpsa76UvwXK/8BN6qIhUVuW0sVLYecwgdDbjwoNRAz+YcijwL6GFnBFha3tgcwDjnBuY0+1jrWC6EYY9uPFmm0nvtM/VlfN24aw1EIqFiUWOXmkGHMLtDApAfTBk9lGB2Se5NQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fB9GHhc3aL4KpVM/3mGMyhYIXFV7YRlOWvYX+3XOfHs=;
 b=c4rZD+l4u0PVN6SAR634Pa2AzKfeNcXi/WrtK4ChQj06KKMsFk46xAhLvzZcf62lodRD4HhWcQ6iPw02AL3nR5kd11n1ds4s2qvCYTu3AJJbk25tKfHr9OLdxMiFdEdx20aGrq0aBg0POil4oFeBuk79WfGG3aM/XaaVaPIRf3ek17Dh23fmODOzj/PBb2VxgiXpgrTYPJwlqYbUdAiPbQNtIgeai1VKNA5AYeSgoKMdhOUJcScknRKNJ0G4A2RTkV/d1Yk6tvIDzBvPRQbFiEKLRZePoLGfp96ZzdaX2QH2m1+BunDco/FaZqLDw1DBOHwwMD4AeEKGy0T+B/dSnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fB9GHhc3aL4KpVM/3mGMyhYIXFV7YRlOWvYX+3XOfHs=;
 b=G3i2X8jE3Kb+/7BKW+AqTBUOqmnUnum+eu6GUqPTwQSgVBnoMZP1WL7n526bmqNJk9pQCy5AC632NMbEpzbqyn7PyFk8pF9Zq/jI0hmDPpSS0IFm2EjoisB7gbeU1XRdEMQvDB+SFHwjvhm3GJFQmgP25UhO5otKVZgWImlKd8s=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH0PR10MB7077.namprd10.prod.outlook.com (2603:10b6:510:286::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Mon, 5 Jan
 2026 20:12:03 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9478.004; Mon, 5 Jan 2026
 20:12:03 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>, Yeoreum Yun <yeoreum.yun@arm.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        David Hildenbrand <david@kernel.org>,
        Jeongjun Park <aha310510@gmail.com>, Rik van Riel <riel@surriel.com>,
        Harry Yoo <harry.yoo@oracle.com>
Subject: [PATCH v2 0/4] mm/vma: fix anon_vma UAF on mremap() faulted, unfaulted merge
Date: Mon,  5 Jan 2026 20:11:46 +0000
Message-ID: <cover.1767638272.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.52.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0127.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9f::19) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH0PR10MB7077:EE_
X-MS-Office365-Filtering-Correlation-Id: 433c3150-ed7d-440d-cd4b-08de4c96b11a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?BMFneicQSuIAms8MTSj3q7pdWGmU5EiQ7NlD29/mua7GueuZ4X/QRvXRuBHq?=
 =?us-ascii?Q?rv3LrTUWoxhN3EHKntDOV74x7iMIEERSb0S0NxTTcJWl8VlsW+GQieNk69WM?=
 =?us-ascii?Q?fWsSeTVwIDxMA0fsqxV0dMJfimYTeJmweYwy7FMc4O0+c3Y/RcRUgMVEQAx7?=
 =?us-ascii?Q?6/L0vf/VipHdrZ+MraTyNLFAXUJfKjFNv3Bwx2Mtkr7gKEk/T4GKRuG5im/h?=
 =?us-ascii?Q?Zs1IhwjeXJZq2lrUTc1D85ghOyKS99RKJgeeYnRcks0g1jwfb42Ap0+DRKVV?=
 =?us-ascii?Q?bPbjh9IDIbYyhNeUz4ifVNK+K89+e/mCCsx9I+6A4y7puw45v3N95Xm7rrvF?=
 =?us-ascii?Q?9ozJ47bQyrSb2CrS/hgyCpyAVLrSblLOb4F6IeD0yivDCay4sVyxIvca3hKv?=
 =?us-ascii?Q?/O3lviDnTrFYZXZ8dfOj4Q7qAbHGUVWawwCJkPxFiky5RaTjOKohSIGIdsKY?=
 =?us-ascii?Q?7YVJy+ETqTuWmVeOXqbgVZ7IIPXsRn1UKWWzy2Z3DAkpQhzGiHz/SACy+N1Y?=
 =?us-ascii?Q?D6fMsaOe9Wq5C9qq28my2/pML5/WXFQEKEeVLD8rkQaj7vv1r+Lg9bX62YJd?=
 =?us-ascii?Q?DALyCycBqZXGTHDCaczT+RjTQkoNuuxKld9zCcIYYGuVjm5CYXlwHW/gQwae?=
 =?us-ascii?Q?7q3goN9YuA+HXduoubapotySD+s8RSyNRusmzyCKP/rehgOP2esIkl7u2ade?=
 =?us-ascii?Q?e9bxqDEW3sP2ioDg/QAKjmR8qIGKcD/xBQ/urL4rmnP5u3XVP40oXUBovl38?=
 =?us-ascii?Q?Bc2WQPILa1ZEO2Qxp0OO+YM0dLqa8NSXIZp7vsvo9kfWfHSFXcMcS7bmjFHG?=
 =?us-ascii?Q?v08DCw5KWzUIatCj1mghKhK0gwedrUwNZhfOid3f0+d8MChdynEt7LIvGj3e?=
 =?us-ascii?Q?cqEbOU069EJsjUD1vo2YjRild/0yL3E7pVrwERLwKTc3BB2SPjSkMzSqElF9?=
 =?us-ascii?Q?W8PDH8BpMb+CvCOGRjixDMz/pwCIQ55CuIAgAWGXu8ZEC/Ze264mQjUAEfnb?=
 =?us-ascii?Q?dutl2nX6r3nOc2UyrrX+uYUBVR2WwrLDTEBG4EDcYGV+LpGjFsT4luGI6vXE?=
 =?us-ascii?Q?ef0FszLMAf6/90YLmme7jm/dypceYvxXZTRaXbzW0mIQx0ZrVmLa427zCPKu?=
 =?us-ascii?Q?BVAXQcZ5qZcply0+AAN0Pd3WRMusQJLXrfcVFZN6OmDH4FU9Ab9Yw9Mod4gH?=
 =?us-ascii?Q?cS+DB2rkg1BbCyAU/kq36+guesE+ijahKNWKcn7uqr+Qp24+s1eXgKFOiJhb?=
 =?us-ascii?Q?qM6+q05P0SQfYvankQScTKpTA6FWDyfbvf78kJxgrck1R67iLrwJHLFKxFYL?=
 =?us-ascii?Q?x/meDAshLVC1zgx1FwB8Ut3ooxGg1BFPFjrQYa9QAIPh22obOY9Xb6ULEefj?=
 =?us-ascii?Q?ZV9RqwEjkAiPzSWlbN0uTc+3DQvODrCSSSl8u/wBOocxgSZqh1eDLsZDKLyr?=
 =?us-ascii?Q?hgb6aCE2coC1tddC9hDX0owUu5Tw5Dj0czsp0hubPN0bd5gsmXmfRA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gaPu0RUEYIZurHLO8sN4z5m8l8hl3qicOq1b3Bijli2SQc1+PcE7zMYYF906?=
 =?us-ascii?Q?wjU4B54l0iwJUKSzJYz3JThorxOR6zdv3SLx8SgkBRi/B8YOhfqv9N/GugKo?=
 =?us-ascii?Q?xxgEgqMqfX0N2zdD7LoTzPOJq/2EbLcZ/ytks2XWGwu+1gYvWBuYUN378/ki?=
 =?us-ascii?Q?n4Yf0hk/ZVwnJeWPloHfr0c0uMxx2zgSewoxmzQIPr73HeNCvXYASquJrrIW?=
 =?us-ascii?Q?Hwk0TIMo9p2T7a1UmxZJKtAk2s0daeJhOYCKqStC1VYgKhz0etzmKJHmiguG?=
 =?us-ascii?Q?KS0DOeUwqivMkKKIzMKnJ7r+qo1wUcsWto6PW6rcjkwBphEf3sSBIfCh2SYg?=
 =?us-ascii?Q?IxQPI0gvnRQdSKgCKGDjmOkXQJsO9MNergqK4NK60qhSxX9PBgTIS1VB3sdf?=
 =?us-ascii?Q?xNakpc0qYoYPWxjZq8PxrZiyK1WT0EZKjFRS5W4sxWUTFH9NMNo3cNWOENSK?=
 =?us-ascii?Q?9j4Isz4YqR8mzN1I3oEPb1AYVC/n7438qcsaGX2R2Yzg9KOExdHQKq+AC5Z8?=
 =?us-ascii?Q?I5iErYqiXgVth6AEPGv9u3HcEgyAxf3U+2rqEwijpCu35HHzvwqsTnkKF8dk?=
 =?us-ascii?Q?OS2d5u6limbVYavaXJR2pqzXuA1krXcLXtJ2L1CJOuKqPJKCQuDIs630IJnu?=
 =?us-ascii?Q?VjCWm55DGNH3lI7t6L2Q2qa6zFtjjKBmvJuRU6OTJaGOURgZdg5Mx9o8BUg4?=
 =?us-ascii?Q?EJuhoIKfNlNW/B/Jc8ojmyfMFG49pW83niRtx/J3TPL8b/Ex4jHfife1qPgq?=
 =?us-ascii?Q?WiKpl/8xdcMsKxPpjTHLWZUCK0csEEYeXTwj8V7igUORvyS7uq/udfm8Ifqe?=
 =?us-ascii?Q?BTfZCHHyYn+qFVhpefoyNOL/mqmxRAZnx2eeJMQcGXy7+TdYbYRK2DSM/jmo?=
 =?us-ascii?Q?8gH8xY8cK/phHCbAkqEpHpA6oC3kMK81OquTLeBKZ/J1syNYaYOdY741nlOc?=
 =?us-ascii?Q?QuBrBvr7tSPCdWtti28rPVba+uUtZr6FRQo5V6h6iQQPhv2t0KqeLmTyNI5O?=
 =?us-ascii?Q?EewV6tnHUAOajcpJiLid9I2kYy2AmKQvmiv2nJL7jrQMvPPFQsK0CEDAlsJX?=
 =?us-ascii?Q?f47hkoctw6sYTK9ATqD54UbNhOq4gpS9YLyBbKubgZcAfKlF8ngDFzqXvqMS?=
 =?us-ascii?Q?IeuLRgchRYwwnGtjuzdxKdhA4I/Ni0i2wYhs2Dn4YRwB/kb9+e/xFHUWMMyA?=
 =?us-ascii?Q?geIARP1QHPDNy/k0ZiQ3kJSd934VLTn059f6mTE52ihs0XYMDergGtNFWr7g?=
 =?us-ascii?Q?fU8UXbGwkbUPo1HGxJBcmMOPPmViIwXzDfHCvVOz4ZNeaxR02J9OHZW6FscV?=
 =?us-ascii?Q?dCW/XgbqkMn8KbFKXbyX2KG/qRBUcFJBQ0SbheSspqHLVu2hQp9p7D5DOkOm?=
 =?us-ascii?Q?1FVvkk01Iho2ulCVUVz9PF+aCUi5Yv6+REuBjGlkAPyv2fUVjjePjxYBxpvG?=
 =?us-ascii?Q?IDF0HtIKWoV0WEgibKPag14oanXJWdAcntFMynENdnZlpdhNRc0AqtEAfZEw?=
 =?us-ascii?Q?rmS23zKtAQgH7/B54wZvIoRCD78SPOpuMSzyfkSKGgd6sy4yCD/qJEpNptxj?=
 =?us-ascii?Q?kcKImEzIKJRADu2qQxV+d7xPC9fLF8z/tJTIcPXC0uYXU4FhpnGsI5k6T38G?=
 =?us-ascii?Q?BstHJoC+EZXYDGdz9Os9/yPtxiRjprdiB8mlvPGwxJabRm0ra4Ci/H+qJXoI?=
 =?us-ascii?Q?NBm4YdwbbY4PIlQzUyEl+1JiHyagzBIqH7cC1eWKaKDgmO0SMxotnQ66c/5Z?=
 =?us-ascii?Q?4/aj97hqLLh9tJN56c3rrUbJMF+NJZo=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	8LAVUZrP9/R63AacKCFGbVM+TPj89+0i1SjrM/DKgCmjK9UwivI0T6+n9p+3yi3qDklOYHZcOoCZeDWkflb2/2eaCOUaRlDKW326veDc/fDawL5zjXzZop0rwkSs6PMqtiGTWaZzAySDFEkQ8YtRiHXWXqlSLfUys10A2Ohiqh+6c/WXr5C0v8/k/FKnetbR/zi7RwmORiwJ9zxfZ1fDoF9EzRpNbaKETX2UGsfx+jpA/SYikwaac4VDaxrfUOKjy2NnBj08ogbo4s+qxZWfY7Eh44G45E/w98iBN/XmbgFIh2By9JtlWKJW/B3WascGjbsmoybdmWloGcEXJchp1n5PUAS12kf/+4OFNgSS8jDnC3Qp0yfUb0vGp3suqo63V14cU/k1+66NeHkfmJjXfze0VW1+0wlSdfVxzw+Ec8n5tqCPvqe8FQDFWf1mixwV/E2cNNwm1QAkRd0kDxmp1WVRPH+URZSI9Gqfr8uNlmoT1abTEKSKahrjzxl9TdI5gAbccJpdvpaue5mA55Z13pzO5TaMHU5n7IvQb0NXqXcqsrWk2GV5gdI7l8R3YENKqZFi1/vod2iyXCLM8wtdZXDBxFaEdplZnsqbdvRfCKw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 433c3150-ed7d-440d-cd4b-08de4c96b11a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2026 20:12:03.5344
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gp3FU4GxuyF0oyLXPpoE/ZK8tKj3GHMdcLy1TqpLqJRN3nXLVTdclbmq4ko3bxbbAHI6bLXwSOr1trH+Rk5uCsRl4dpFr9GDcBlZRj1x4Jc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB7077
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-05_02,2026-01-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 adultscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601050175
X-Authority-Analysis: v=2.4 cv=RoPI7SmK c=1 sm=1 tr=0 ts=695c1b17 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=YK1q062G-6bWT9dfoIAA:9 cc=ntf awl=host:13654
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA1MDE3NSBTYWx0ZWRfX9QD0NTRtlrSj
 E2ZmKbHMItrWDZByTgAKhcTjoQ/iYMl8f7XEPW4ONwSWSl3mvtbP/tcK7oh6iMmj6kfKH6eA5gT
 H4uMizGL2nbaDxYDv1Y99nyYb2yBs9diDdNCprznFazyegVjghvpk292i2H9Azj5yzCCsgLDgra
 21X02ZmB09LRkEVUhxIixOGHkAdw2l/ZojQbgsS6X/pzNtvA8OZXD2IY122/8tomiOqPE8braT0
 yQ84JB/wcqrCf/B+GTbQJs0dWqir4jy1gLC0Kq1gUbq3yFUpT8/VUEgW5gKsHBAVGdaUsS89dM5
 0GpjgMz8p38kDlRL3teMmkX9fK9HAUofq30jVVy3+6biYNwvMlVLHZpTSTXjERrWdNBsj9DPYI/
 CK7atpgBLK8Z4XwBDHI0n/fD3zNAbQJNG6zS0HQGfoIkXxfyuePywQ+Qyg9/gtQu9HQ3FJjazsA
 lUPUz5TPKcGlKJLmkYFjKkgkgVRHRi/bKBDGlij0=
X-Proofpoint-ORIG-GUID: wyIOq6-P7ODEivNjpeRpWpY3TKwcwVQr
X-Proofpoint-GUID: wyIOq6-P7ODEivNjpeRpWpY3TKwcwVQr
X-Rspamd-Queue-Id: 6E57D1C0008
X-Stat-Signature: af3fyy164jn9n7q7xt5tc13ikrbypxgb
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1767643938-859974
X-HE-Meta: U2FsdGVkX18BajfDgdT7q2uD+WhZqXTH36SPqGi5UYjBrV8BoWBbpe6F0nbFhSsOU6zgeowx0yio9BAZKCJ+X0yGJuCxBeUeAd/zhdG0n6sm+ToZx/SIYXby1GW3jDFxIeonvswheF1Se5/ELhF+XxHIzRrAshEWXhYrq5jzDmZdzQTNbz76UZCxiYrYVoW+JesOKQUdltBU2/PZDgOCfxIeq/i3lDe0+g4+eEIEJx2p4yM/RP3A+rIS5SxkYzH7Av7ZzG0c5dDD1M4NR4Dz1CoIHntfaulo7boPXaHnfQF41J4/sn3IBkR3ppMF+gslbCmzrl0POJs/Xn9AfiP+Xlta62GxsPwq6Lx/8CtMHwyCTIFgSu+L59p9JlsFiMJYmCpw0+BjkV5NakspDSBHJS6kjRS/NcRF4j43HOf9/dlJPAmBPG4yywHO+Z/ZCjJbj5ba833QmL82Q8aLsasbJ0CAMmwoQxXYcEr0Q3PhTVTyMscVecaovvQt5Te2hYiqLXQT1y4YHrnIyONTC6Y6mwKGT8qfhh2P07vCnIsjw4WJ8Khnq3Bzs1YYLST2t7BX5zUUKoLlYVbeVaF5h9HyPK3WcMnp6bqQMjl2W7JKRlKOL0jyshQAdyRav27kKQX9A9iyIWD/8JFKPm12Hhk4lLDteKpZpejKcVgXs+atdaV+Ht5hyIlYc/rb0sgcY6fwT8YHq/WS0mnPEgIim385xVOzY6f5Xp6GpO/svIJEIYbM1gex9knuE2YZH2n8ttChOFgxELbgX2+oCPwOCBc0dt1LGxIgMJS69S2GSRRLUVvaZvKz00U3/Fadjs3+5Ib17DQWUb9usfHYsyjkDfUtMAqeLD1mbROZk/QnobsQwdv2/K5deotO9MkeWxO3tEVOPs9jJk7tO0sgPpE1H6xMSKNUMR36zqRWzf4+9NFbQfC+fV0fE+wWQ1o05002Jg/jGaxRBm8DoLJXvza+QQ2
 oMFyblRo
 2PPLE2w0Hp9v1UDr+GP38Sg24B55DLxiGOaL9V2FJmlQeyS3gtOl70ozAywxm4jVG8rz8rN6tbNU97fwA1o0t25HH1BqCSpjrJpObhjpucl7UzlpDByql6Jj/BnjEiF8pEKcROB3Hx6T6i+fIuW86XOrqaXf2gXlNuAtnbHLefYWEcN7ua/5tMw174tfjw7fRYmbYCyRCqTVjfeNzjtjwxif1ijChSx8j9iZfcq4ffMIYaDt8K+hc+N6Gxz7UZJt3TWpcQvO0CgjQv6FTPifAXVCb5W5eupEBHS3kTewT1BZ0HPUXkjD02jxE4YwyGQiwxiE5S78NCNyxB7/A9gNkpDQ9IcT2crqSxKuI3eneNJvXlLSPZ5iOG2QmIlkkVdP3Nwe19UHyqct3q61PIvC6O2gFxvRXPEdzVv8F8/6kozKeCM8qVpnz5efnUFQncoeeQXXNEGCDAGBrGKoozAl7pvV1st45rGlwE64UdFhY91Qatp8CRNaQk3dCboDPxFurjqneJAuRDXgH96stwvu2r2Ykd0r6wBO4Rjck/WovxxFbuI1xLPumvsi4t89ul8/gVQ7IdX5hRgdG8Y8TCSAS3v4WiEqn5Ts7go7djdedhtUyMfzI9vkjXySuSB/8q3iLnL+CTbI5t0ztqpJuyDQ8ocXQIoIOysEtx5WA4Q0RsRJw4rc9FIX5v9fcsjAISRtuNnBbvH8moLYYheU/R5zsyiC3KA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 879bca0a2c4f ("mm/vma: fix incorrectly disallowed anonymous VMA
merges") introduced the ability to merge previously unavailable VMA merge
scenarios.

However, it is handling merges incorrectly when it comes to mremap() of a
faulted VMA adjacent to an unfaulted VMA. The issues arise in three cases:

1. Previous VMA unfaulted:

              copied -----|
                          v
	|-----------|.............|
	| unfaulted |(faulted VMA)|
	|-----------|.............|
	     prev

2. Next VMA unfaulted:

              copied -----|
                          v
	            |.............|-----------|
	            |(faulted VMA)| unfaulted |
                    |.............|-----------|
		                      next

3. Both adjacent VMAs unfaulted:

              copied -----|
                          v
	|-----------|.............|-----------|
	| unfaulted |(faulted VMA)| unfaulted |
	|-----------|.............|-----------|
	     prev                      next

This series fixes each of these cases, and introduces self tests to assert
that the issues are corrected.

I also test a further case which was already handled, to assert that my
changes continues to correctly handle it:

4. prev unfaulted, next faulted:

              copied -----|
                          v
	|-----------|.............|-----------|
	| unfaulted |(faulted VMA)|  faulted  |
	|-----------|.............|-----------|
	     prev                      next

This bug was discovered via a syzbot report, linked to in the first patch
in the series, I confirmed that this series fixes the bug.

I also discovered that we are failing to check that the faulted VMA was not
forked when merging a copied VMA in cases 1-3 above, an issue this series
also addresses.

I also added self tests to assert that this is resolved (and confirmed that
the tests failed prior to this).

I also cleaned up vma_expand() as part of this work, renamed
vma_had_uncowed_parents() to vma_is_fork_child() as the previous name was
unduly confusing, and simplified the comments around this function.

v2:
* Provide more general solution that fixes failure raised by Harry (thanks
  very much for raising the issues!)
* Additionally discovered another failure case (prev unfaulted merge with
  faulted). The general solution solves this also.
* Reworked vma_expand() to be more logical and understandable.
* Added vma_merge_copied_range() specifically for mremap() so we abstract
  out the invocation of vma_merge_new_range() to make things a little more
  straightforward.
* Added exhaustive self tests for every case, including unfaulted, faulted,
  faulted (which was previously correctly handled by vma_expand()).
* Discovered that we are incorrectly allowing merges between
  faulted/unfaulted mremap() for forked VMAs, so adjusted
  is_mergeable_anon_vma() to correctly check for this for the mremap()
  case.
* While I was there, renamed vma_had_uncowed_parents() to
  vma_is_fork_child() as the name was confusing, and removed duplicative
  comments.
* Added self tests to assert correctness for the forked VMA changes.

v1:
https://lore.kernel.org/all/20260102205520.986725-1-lorenzo.stoakes@oracle.com/

Lorenzo Stoakes (4):
  mm/vma: fix anon_vma UAF on mremap() faulted, unfaulted merge
  tools/testing/selftests: add tests for !tgt, src mremap() merges
  mm/vma: enforce VMA fork limit on unfaulted,faulted mremap merge too
  tools/testing/selftests: add forked (un)/faulted VMA merge tests

 mm/vma.c                           | 111 ++++++---
 mm/vma.h                           |   3 +
 tools/testing/selftests/mm/merge.c | 384 +++++++++++++++++++++++++++--
 3 files changed, 434 insertions(+), 64 deletions(-)

--
2.52.0

