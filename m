Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6439D65559
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 12:27:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB7A76B0093; Wed, 17 Dec 2025 07:27:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D591D6B0095; Wed, 17 Dec 2025 07:27:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2CD46B0096; Wed, 17 Dec 2025 07:27:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A8A616B0093
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:27:40 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7F8701A0A35
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 12:27:40 +0000 (UTC)
X-FDA: 84228889080.18.9730D9D
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf25.hostedemail.com (Postfix) with ESMTP id 0B6ACA0009
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 12:27:36 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=f78eDhUI;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=y28fa9UY;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf25.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765974457; a=rsa-sha256;
	cv=pass;
	b=5C2TG1ikH8WjQO5fUpl/oh1Km4GZ0t+pQMfh1JUk2+f+tmGrJZaomZLml2ohDlFGiwWdpb
	C5MxX3K8qjxc7JNlcANoKA8TGE1IE+YMm8mQk83bhFD3qYn2FP+81aEdbQv3pzn8Jnf5AY
	tfBWTgMVlWBEvcDg414X5P8zEciJnKI=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=f78eDhUI;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=y28fa9UY;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf25.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765974457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rJZDa2n9ncVkb2QNlDSl98BB6L47oBiLUHJDc+rdApw=;
	b=kk1xvZDgHlxFAAS9JHW0VM/zWMjYngO17DxBwxWQ2ZwQVmdV7u0syuTTNupNMzQBvGT/pY
	bQ0gg/LFyuFArWsQ+ToObZ0VZNnWPLXUEXm2l7a4KwCpFT3e1Pp+UrBe9nAGkwWj23LanB
	tD0DiEJlHDLEhQqCUqsd+jdYpCqR4cY=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BH6NJFS2005411;
	Wed, 17 Dec 2025 12:27:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=rJZDa2n9ncVkb2QNlDSl98BB6L47oBiLUHJDc+rdApw=; b=
	f78eDhUIRUIzMtn+dYhxrhggyDtKyjWYvJwbptkrQypSRZe8ly/4mC9qe9S8aKs3
	CrYn0T7I/OXWjbm7UiYQoiRQIB/KKBB7SekZTgVJQreskHCM3tVD4wMtTml6bcfD
	4oHXEtNBQ7kaMZFt0IKA/9h2wy5f+Lr+Alrk82GHar8PggXHVp3nfpgneNS2KB/I
	BdLOyHrngYYASTcat0RsKcmtVB4ByFeWQRHLbmy8kx7vatKYOnHQSGUmbfUD6JB5
	kvxsLrWpsPX3DCCQoALalMLDW5mTLZ+VsGfBBpcfD1S9U18OdWigG+xArKYRHzIr
	vOlcTmjt75s6YJqdGQfQZg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b0xqxwv8y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Dec 2025 12:27:31 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BHB7E9e024495;
	Wed, 17 Dec 2025 12:27:31 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013050.outbound.protection.outlook.com [40.93.201.50])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4b0xkbq6hx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Dec 2025 12:27:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LXvJjSWyqp6ElJB+2V0Bj61VKAmf2ijLMB89h9s3gZ/ENxhBMM4HL21xiO4mcAyva9/fAo7JQFGdkcWUfabZiN5MU/422ntMTsrxIPXoikshN6AYzQ5L1xqYHE2jYLSAgUESJHAMfJmNOkTX+dFK/TBVXbxF2T5C8W1gtMud4ZzUg2GFkTLlzGCEivFtuMwj+IeVjTVaIy69JcaYhjkmipsuKO/i1QNbAf6cn0DnfWn7G08a0vlXluHkysDmcoX2wfPOokLhc8QajDzNIxoRfaNReN/g6dPteMyvFZ5h/641cw4k/NI8mqdjCT+NQqPKzAnzeuEezemntT0RtsRGOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rJZDa2n9ncVkb2QNlDSl98BB6L47oBiLUHJDc+rdApw=;
 b=QjDDDoTSXFaf+famHtvQYoVNWfvkghGrAbStkyyLeoYNFRKGdN/xKAO1ZpWiKDuVL2l/Y7TWgBYx/nIa4W8vvtzyRf9+9UeXB+ZSjK57Hj41mi4/aprB38sTdVfGGYBnn9A9k3TBqjzKEneOeh+3yOUhrB81ao1Ex+eeAE7aLPuRBjN1XSUjM3M7hmUb/HW4ZL5qGHT3t62vzHngvWS6TeOGD/P0uur1MP40bUvAGofwYOUwiIzw/ntra0hOyqfIGN8CpMn5enVQcqXK1hjrmVNV/M7bNAMhcb8lmk987XRC8iCbL9TPFI6gEB56I2+3f9zXf85o5/QPvuvQDxrVOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rJZDa2n9ncVkb2QNlDSl98BB6L47oBiLUHJDc+rdApw=;
 b=y28fa9UYWEmb0Y07sTsU5lRi/c0XdJA+mN6ouyS9Wpv1KRP5bHUWUhVRyCZ9vShyPxuu0lLtBOmhd5+kkazsWdJXnaTPaTX5e+mHrBHoD5RN8k329u+dD4hdYX/Vtg4/p+tYXzqbvVOosSY+D3QE77QvTTC6jGZ/KoJTAEf0Zt4=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DM3PPF545856187.namprd10.prod.outlook.com (2603:10b6:f:fc00::c27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.7; Wed, 17 Dec
 2025 12:27:28 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%4]) with mapi id 15.20.9434.001; Wed, 17 Dec 2025
 12:27:28 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>,
        Harry Yoo <harry.yoo@oracle.com>, Jann Horn <jannh@google.com>,
        Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
        Pedro Falcato <pfalcato@suse.de>, Chris Li <chriscli@google.com>,
        Barry Song <v-songbaohua@oppo.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/8] mm/rmap: make anon_vma functions internal
Date: Wed, 17 Dec 2025 12:27:07 +0000
Message-ID: <ff68a8f703701c8e626f0cb190c845c5d883c88e.1765970117.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1765970117.git.lorenzo.stoakes@oracle.com>
References: <cover.1765970117.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P123CA0056.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1::20) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DM3PPF545856187:EE_
X-MS-Office365-Filtering-Correlation-Id: d8aa79b3-e27e-4739-42f4-08de3d67a444
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zAkQHySXFRs3vwem1uxEj1uY0RScPFN+w+gjwE0sSm6oilNKhKf4LO5t04Ch?=
 =?us-ascii?Q?/A9L8qvr344Et6ht4WgUxJKp0aZUUbVr1zwG4I5IQclEJJQHQ2U7d8Lj8gOL?=
 =?us-ascii?Q?AnOikzla9GiNOYce0qlLY6TqL+mPexPGqep6k4TqFdaY4sYdqR7WfRuLAd+t?=
 =?us-ascii?Q?6h8TlTUZEIgwrHCPfSyfzKhpff0XMPEOL3VprWuu9CmjEoUN7nvyDJxF2KRT?=
 =?us-ascii?Q?uofSS7mbl3DIO2bJkTKpD4d64JBfenW2c9e20/njErs/7o7yQQBPop7v6WGX?=
 =?us-ascii?Q?sph/4PPKze+AjKKvWtqajCFyPTB4YfhTcQ1psfqUTT9RgDliefefP5HyFdEP?=
 =?us-ascii?Q?+2fZjV/bAR5XSby4IXOHCOAzGhT602eac8sI7hdaEXvkiEucpjrSLvuCFDXk?=
 =?us-ascii?Q?xqD/C6FkDp8pG+WDpR2BZ/uN4mExmUURoUk57vwOEblZAihs9TC5c6RoFDAL?=
 =?us-ascii?Q?wAD3E4G8X0s+xOLn48ob6ryX3tD6zpXHlnWP8rtdfaMBgbQw3q6unT3B8Y79?=
 =?us-ascii?Q?lhgVXS2Syf7CIveUtnUD6hHCfPNpFoQZCUGfBEuGasyvG/o15wOl+9ht2be9?=
 =?us-ascii?Q?QnitHQ3o2XxWd2hE3JY/tfnk63GqvqMwwjZQotXPjkUzyjDkI8Ho2RP0n12Z?=
 =?us-ascii?Q?KYEFPOVm9VOpgiRYMxLJZMxkKKcdwWtb3HCrfj1sVcDzogLPz9+Zrg9zR5Sj?=
 =?us-ascii?Q?EmZ4F+l1MS9sTV1L1Gvxv63nkN808y+0SpozVrwmjOHe25ApyOnF2TmnrCnr?=
 =?us-ascii?Q?skz3/8828pIfwNcbVuz6FeaPTl7pHKc3RWkOy1esoaHsOmcHUkW/9j+xEg3P?=
 =?us-ascii?Q?beIoqTS3jwQZs2NXfmJ5zW1B37z0nBV/LtcOp+k/7h0B8vkpv+M93cNimnAO?=
 =?us-ascii?Q?/x2Ki/rJigf6vIQEVC5gc/pkXkLTivKxSft6fQleA3lgwiHz2t0U6PP+wd8j?=
 =?us-ascii?Q?Xwrk9K6HYPl/ZyLnQJE3+vpW15slgvA+ymMLCBG5v+3YCDer9r8ba+NbBl9N?=
 =?us-ascii?Q?8JyzSW7vORQenHYEtiq6Dh49WjFK654Y9qV3TEVzeXCnBIkEy5a2EE70hfKe?=
 =?us-ascii?Q?n1bnoHjFn1ceN+HfKjRgK6ViewlxTda8yBtPhYhOXKZfzzi0v9iblelmky0U?=
 =?us-ascii?Q?pndC4XQdUXgpKCzrSzAN2WARc+yjisiIcCYhia5YlpRW2JvfLPXGgdFRpMla?=
 =?us-ascii?Q?vJluN67f0HR+v9GRY9lKtQrQfGcrI7Up3B2mz/ZfSmE9AIsU0DV5BfLpjYTZ?=
 =?us-ascii?Q?cGn/7+fRRccYsonwkOE/Yr6Nw4VVVwQ0wSZ2Li3G7Cu4KKx6QnhYwGJVSi0J?=
 =?us-ascii?Q?FmBdZRC8ENYecZSLiMFUWUP7ScdZNCxFcqMrHtXvZklvTdOptr2pDOzJz8Jm?=
 =?us-ascii?Q?/4uV7l2Q3xi0NinRG6XPA3lR9V3OCa4BOupU6aeZikOcm/KxS5X3O1FLbYgJ?=
 =?us-ascii?Q?sE8zrC2UwDhHPxqiCbem0GTHn2HYvh31?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?no0OO3f9elAWows/MHG0U0Kmtz1vTSsR1h5c/ZykgI6MvQtstjCK91jawSl8?=
 =?us-ascii?Q?uXV2Ar+T9O//AEGGlpgmwye3pEf4KPAAJdvjysVvYt/WjDoXOo8c2UCLpL+2?=
 =?us-ascii?Q?4F3vG3M0nBvOA8qNYao1StyuLS+xTE4J+f5CM+9Q2z81nCrpyqjLIAJXY+mb?=
 =?us-ascii?Q?Cgn7JBYGSE8eJI1GsgxCZ9mGk6zj5RMBPdzYgpOB2P4oKDf3zrYC56hXpvJC?=
 =?us-ascii?Q?iKqBjqXONEV0JSjWYI2Ql/b3RoEk69djTMgz8AzJtiubv8OwnyCBH1OohHN+?=
 =?us-ascii?Q?SJ4WkOXmidqXlJCVqAGe5xYZ+pFcqPJDXqWAwXrQmMl9xTTFslnLZg1NHsHx?=
 =?us-ascii?Q?3Cp8RJ7vxNwW71i7n5VCCre1qzVzZ9IdX0CFVEQw75CO5t1Pu3QuwNQkY7S1?=
 =?us-ascii?Q?E0003FaQQqVxwV3MmNrrXOlfvGz3zIc72m6lscngcq7cW3i8EMNyzbM8+OQI?=
 =?us-ascii?Q?XHJbmJMbSzEfSUzM+wUDeqoNzXR1qys2pe/Bs823c2zqLS/u0SDWUbp3T97A?=
 =?us-ascii?Q?ecT5s2Jqnh3MOfyCZ/Me1uOWHjW+QeqXCuwonjxjd0lRX37i3FHkvIS2RPEb?=
 =?us-ascii?Q?azyhJxMrzElf7z2rNj3hc0Cqbf9Yd32HkgGwUmncs7LGpMHjF73s5+2JuslG?=
 =?us-ascii?Q?EcfQFiF2gXOSKNqGiAATGMjrmDqspVJRrsRR8qUAJBm1w2zu341NFGeX+2VO?=
 =?us-ascii?Q?n+H83njMm6807gzwUVg9p4Ucf+SttMitZrvmL53hZC0mwuxmvE7CPOFjEJ90?=
 =?us-ascii?Q?vz7PFiBHWESF/+JydBPtDRofsrW8vYOD8EgeH9zAgtvMm5wOe3uZN2HhlNIc?=
 =?us-ascii?Q?LOPIrR9g/PNxEWpcxiPpMU38xyUUIC0ZIRogYyaqSbkabOga27gY6tXBgsZP?=
 =?us-ascii?Q?kJKTBjP5enAKdjUMzaEJjofVJx+7RTZ17ibMUZ5m5Lkg3mVA4JVXN9+rcT44?=
 =?us-ascii?Q?dz6vQ34lb8aR726ytXyedyIJ0g0w3KbjV/7xHL3ueikP3RKaLKrNKRcvg+CG?=
 =?us-ascii?Q?XqwpN27rzn5wR133WdDy3J589YW8+K4NpSAmjo0sNYDiMpM78/+PWKHYtqiK?=
 =?us-ascii?Q?m6yjEQTyHeQ9EgmHr095bW0c2OASYzeDNwd4Z+vZXHT4Tp5oKPig22hL/KEA?=
 =?us-ascii?Q?MlHWKBiKrDkE2oMzFKB/830+ExDX1dFvfdKGNAwuoUbxb42ua3aqLLGL8jDZ?=
 =?us-ascii?Q?6jqlbKNP9J0mPTOumImo++9PeQ1RE0+SRXB/wKd7YjvEloxEaVG3wSobxKow?=
 =?us-ascii?Q?PS0q9ddcPxy/2O5sKI5R3pfa6Kp9NAxC+SPa61xk+1LFT77bORir+uTSMjjH?=
 =?us-ascii?Q?XRQs7itMVXHdRHYBf/lxYuLRkvo6QZryCLAy/M5TKxb/0dV11l4/BEtPNOQt?=
 =?us-ascii?Q?KKSd5fXftrdWTidbL3aNV39zbbLXqk0qSolIGv4xvOBLgZ7L7RZGyUYwen/1?=
 =?us-ascii?Q?cPkIA8+76kurvpPfcYrDJhAQL9c5KCEEjx7oq+EdL4oLRX+HQRlH7lMEtvkz?=
 =?us-ascii?Q?BW+RhT/fqhg98BPnfuhX6KjuO9zLeJnJm3eBcNZ+g7sxf/JodojrpIUK/+Xq?=
 =?us-ascii?Q?qXyGkRrPOApOPxyE5eGZAWH09tVaLulbugXuPRz4YIn7v14MzKKcQ+2Z7hTA?=
 =?us-ascii?Q?+A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	yrjsMCkDie/wzHGxGUexJOqj/bSYBsysENtg7ZDe/FI/atgvH9tYpEoFN/RN3cWtZoQpUE0FEbLgIK2GWYMS61M6Uv2O4rYZ45DcVIVIDgMTY6rYxBvTwsptabce4gDdsw9pPsKjI2M5Ij5IcchM7VinBnE4T6hipkFGcZYPbbA5jtoPEL5xWFmuVUxZ1sv5ixSfq4pzQ9jyooc9Hj1IItWvqRgBJ6x0P+hbffqlD2S8minmJUc4Yixt4lY2cBHsjRbNRzMmse0XeD+8ILKc28K6SQDvtBawx3b9eXnma2HP1JRgrbuacvoSaVzP4BiEEie4sEhflPceL/sxo6JGnGBSNjfGvei/TknzUCv99FbnG337h2I7krFEVw66SwEhZPo24MARnMYtcmychH96XDN4OO1LxCJ3z6VeWv+Q33TFkQ3xEGfz19+a1QfcRErJM5HIBasqUs+0zPqFauDnYSl5qYngRcAAviK8/I2XE3yiv/d6TFWjITN4iSHqFQDckiBoLVMTW79R8B3ydDc9ovSfS+DzP7mE950u9VYcmn0T9WG9lJKVgvocaKrHBh9ipdURJXiK75fPfz9V3aY4dAB9GgijsSHNnUGjjBFfmt0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8aa79b3-e27e-4739-42f4-08de3d67a444
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2025 12:27:28.1094
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v+CY0jCaH7Cmo20On0RuinduW8i54bPVCPav0ovAikwUcj8lf/LGD1LCYVguAO6EbhHtqov7ZufgcZ7K0QHqETA5aHOyvAFs/F0x/I+I8/w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF545856187
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-17_01,2025-12-16_05,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 bulkscore=0
 suspectscore=0 phishscore=0 adultscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512170096
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE3MDA5NyBTYWx0ZWRfXxxBtBaTbST/I
 9MlRnv2NJazSlBLsv8X3h+lIsBfwwnMxlgn1cqK+8PLkUqh21bHsIMPlycbAkpA0VTBrQikQLN+
 JUL7yev4DSjcDwYpi/9kSIpLp7b1hhNVRlhZLH8c/pgxJHTyz41ZxOc9BVTWEkBrEMO66Ctmii8
 BuLcb68S0NFafjhRcu+s957J/Co3wKerAivAt3imbzD/+fwo9xpFiJ8ZAvtWe6z2iopZcPTx/Ld
 c21p4lo8kKOx5GbA5u2scYcsoQJ/Chp9QvQAnD7U4rL5ckLnfRNoKpe3pmKpQO/7HnuFz7P1ccu
 kFdszIH+s5pZIOR6zRA+7VGUn91vAvWt5w+fxhdXXP1OmVFHnFgS6g0sHXWBHM1hV5ReuySL23r
 Z4mVpJ12+0gmFDOeDcGV6Tno0U9ysA==
X-Proofpoint-GUID: Ia5bF5c_LDwiPH0TakUX39dzbx1QbLql
X-Proofpoint-ORIG-GUID: Ia5bF5c_LDwiPH0TakUX39dzbx1QbLql
X-Authority-Analysis: v=2.4 cv=BYDVE7t2 c=1 sm=1 tr=0 ts=6942a1b4 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=wP3pNCr1ah4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=1PI_McdixYITsgu-vP8A:9
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0B6ACA0009
X-Stat-Signature: 1io8mbogh1ixz9uaso8wmxec5ouq9oo3
X-Rspam-User: 
X-HE-Tag: 1765974456-976744
X-HE-Meta: U2FsdGVkX1/6SooBPSwqsuUmswl+JFZ8KOyhW8iLSOTaa2XyBkmS6PxVOtilWRkAQn4nBNC2FLgzyFsdPK6/bxHnEbR1Z3dEWiVZeAaDnjB5f4SRt1VBJAATrf0BI9U4788tqCpq3z9sqKLq6XAdlrMr/t+4TqIAVgKGl3eNDPHw5/C7ImmefctHAMr9Ko8uWfg+rxIV6vaiMpzkcqL9/mQ41FqWFNPxj1qlrs15kZLU5R2CLLhpIDXfXpUEHwvBr22LTWrjtN5YVcWKMOCA//Ckm1Ryibjul8MQxo+CiQSV6gN5r7onXHqD6oyZDU9MuMh1pD4vwQsniJqL6cK6I0boTnlOayOjnT8O6c7JWU/cX79o84rM6i9OuqvsctJEqppr4bb6HIQIFzJRhhHb7kXIMLuwKFdBf8bKQWUykMw9Iqd9WUBlkhieMZWvYnq0epSwl3t7e2oBcAU2CDYBN0L35bwYThV0E9AUOplVUi1gblWqtcHyt2FWLQ590paxuhWBJkG7qc3+YgTK4IDXOmQ56ePw3X15yon94rz7UTiVVcoOjPwKeVpPD4gWBo7gObyVYMHZq5grDjidgzWxpiO4XeGyfs1/h36fqt0C2HdUKF+qaIkfIFFuO/WbSuMQoFUoDz1xAI82wvq4/z8hymQal6Hht7NwbZepQqjgym3R8W9LFT7QxbT0k689LE9QfTrJUBz2qVgWMVCsmyKjJFcnFzSrteKm9p4vhhSclOd6ObaPFN1S5PMxEgSU52bhbX81UQ2OTKcDra7ElWRCb9cpvSBGUKersQ7DEWGdcfBjWH4Iy7bQSBN7ClEmwn4Bcyqqz/U0LNfLpLh8Gdz4J4u/AreSAhhbF0f1mBbwJ3Tn3CopJ9UJB4fBxkVnwiN4KNcVX1Uo9OuT3fFQtuhe+7uTRtCi28079+7SoCcvffLVtphCV6cGM28IIg3Mbjn3tIbf0L7opdQkLlw7mOu
 NZMa5dof
 vf95iAj85BK53ZZYxQk+Mvris9YZiJR1texbf0nIT6367XpcnGWMVmiVccfJRD3Z5aVUuW+5du11uQNB+Kl+7IsG7DgiC7h7zu+LQjyrplwUl7yh2/BaF+0J98/NSpnIhH0KlMrUYzcgQU0ZiaxdSqPaJI8zv1F2TmqMvGvL2p6FeHwYw5RU0LSpA55/VSzPTEov91QXiZxKgj5AQdMh1NkTptTDNksSbtOp93TeNvaqpTV65BqsyiCaTXvRjAoAwKmRmi7iEMPrU1h+0qLzU8lqUwsZncAcdczgjOjyi5+RhD07WiqNNXGE6X13yIycLcRlXhjqUEngbfTR0t3w8mq3ySQfrWSrAuOKgLKsYA2NtmPUXc4GwWUWZScWX3ZqNuVyTs0Hv/XRA/iTbLxfCDPR0tRJDA51gYroyKMTfdjyHwub+64Kg9/s0N6HqHQmsQEjPwUQZM4Q8u/RD93ZFSUFi97kaS47LLysx5G4ADSKPBHw5vPrqa6DdrM2uND8e1GfNQ/J2E+H4IV5kAyQOU0HO0Q6Cp5gkSk3OoZIY6zykeOIj3iJJ2YpGYpKxukjiK6iEX2lpwLJXlEXsxUIclsyuKz+KDQ7fiMDtjgt5oTbXLDq7VGU8qrR490Oe53qeMVG0/ZMa4cerIc8accDEh2oGbFYJGm5cfkkSOsSdB5i+lX6QzE02f4jyTw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The bulk of the anon_vma operations are only used by mm, so formalise this
by putting the function prototypes and inlines in mm/internal.h. This
allows us to make changes without having to worry about the rest of the
kernel.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 include/linux/rmap.h | 60 --------------------------------------------
 mm/internal.h        | 58 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 58 insertions(+), 60 deletions(-)

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index 832bfc0ccfc6..dd764951b03d 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -104,68 +104,8 @@ enum ttu_flags {
 };
 
 #ifdef CONFIG_MMU
-static inline void get_anon_vma(struct anon_vma *anon_vma)
-{
-	atomic_inc(&anon_vma->refcount);
-}
-
-void __put_anon_vma(struct anon_vma *anon_vma);
-
-static inline void put_anon_vma(struct anon_vma *anon_vma)
-{
-	if (atomic_dec_and_test(&anon_vma->refcount))
-		__put_anon_vma(anon_vma);
-}
-
-static inline void anon_vma_lock_write(struct anon_vma *anon_vma)
-{
-	down_write(&anon_vma->root->rwsem);
-}
 
-static inline int anon_vma_trylock_write(struct anon_vma *anon_vma)
-{
-	return down_write_trylock(&anon_vma->root->rwsem);
-}
-
-static inline void anon_vma_unlock_write(struct anon_vma *anon_vma)
-{
-	up_write(&anon_vma->root->rwsem);
-}
-
-static inline void anon_vma_lock_read(struct anon_vma *anon_vma)
-{
-	down_read(&anon_vma->root->rwsem);
-}
-
-static inline int anon_vma_trylock_read(struct anon_vma *anon_vma)
-{
-	return down_read_trylock(&anon_vma->root->rwsem);
-}
-
-static inline void anon_vma_unlock_read(struct anon_vma *anon_vma)
-{
-	up_read(&anon_vma->root->rwsem);
-}
-
-
-/*
- * anon_vma helper functions.
- */
 void anon_vma_init(void);	/* create anon_vma_cachep */
-int  __anon_vma_prepare(struct vm_area_struct *);
-void unlink_anon_vmas(struct vm_area_struct *);
-int anon_vma_clone(struct vm_area_struct *, struct vm_area_struct *);
-int anon_vma_fork(struct vm_area_struct *, struct vm_area_struct *);
-
-static inline int anon_vma_prepare(struct vm_area_struct *vma)
-{
-	if (likely(vma->anon_vma))
-		return 0;
-
-	return __anon_vma_prepare(vma);
-}
-
-struct anon_vma *folio_get_anon_vma(const struct folio *folio);
 
 #ifdef CONFIG_MM_ID
 static __always_inline void folio_lock_large_mapcount(struct folio *folio)
diff --git a/mm/internal.h b/mm/internal.h
index e430da900430..469d4ef1ccc5 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -199,6 +199,64 @@ static inline void vma_close(struct vm_area_struct *vma)
 
 #ifdef CONFIG_MMU
 
+static inline void get_anon_vma(struct anon_vma *anon_vma)
+{
+	atomic_inc(&anon_vma->refcount);
+}
+
+void __put_anon_vma(struct anon_vma *anon_vma);
+
+static inline void put_anon_vma(struct anon_vma *anon_vma)
+{
+	if (atomic_dec_and_test(&anon_vma->refcount))
+		__put_anon_vma(anon_vma);
+}
+
+static inline void anon_vma_lock_write(struct anon_vma *anon_vma)
+{
+	down_write(&anon_vma->root->rwsem);
+}
+
+static inline int anon_vma_trylock_write(struct anon_vma *anon_vma)
+{
+	return down_write_trylock(&anon_vma->root->rwsem);
+}
+
+static inline void anon_vma_unlock_write(struct anon_vma *anon_vma)
+{
+	up_write(&anon_vma->root->rwsem);
+}
+
+static inline void anon_vma_lock_read(struct anon_vma *anon_vma)
+{
+	down_read(&anon_vma->root->rwsem);
+}
+
+static inline int anon_vma_trylock_read(struct anon_vma *anon_vma)
+{
+	return down_read_trylock(&anon_vma->root->rwsem);
+}
+
+static inline void anon_vma_unlock_read(struct anon_vma *anon_vma)
+{
+	up_read(&anon_vma->root->rwsem);
+}
+
+struct anon_vma *folio_get_anon_vma(const struct folio *folio);
+
+int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src);
+int anon_vma_fork(struct vm_area_struct *vma, struct vm_area_struct *pvma);
+int  __anon_vma_prepare(struct vm_area_struct *vma);
+void unlink_anon_vmas(struct vm_area_struct *vma);
+
+static inline int anon_vma_prepare(struct vm_area_struct *vma)
+{
+	if (likely(vma->anon_vma))
+		return 0;
+
+	return __anon_vma_prepare(vma);
+}
+
 /* Flags for folio_pte_batch(). */
 typedef int __bitwise fpb_t;
 
-- 
2.52.0


