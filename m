Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D6C3CAC5AA
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 11:57:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C48CC8E00FD; Thu, 18 Sep 2025 07:57:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF97B8E0093; Thu, 18 Sep 2025 07:57:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A724F8E00FD; Thu, 18 Sep 2025 07:57:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8CE3E8E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 07:57:53 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 410C0117947
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 11:57:53 +0000 (UTC)
X-FDA: 83902222026.06.0D9BECC
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf03.hostedemail.com (Postfix) with ESMTP id E1CC720010
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 11:57:49 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Lo6SRfJj;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=IcMhDwWf;
	spf=pass (imf03.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758196670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2JpGTWy6AoOweanP6t+7YZwtbGrBCTui5TJchDuRBeE=;
	b=eZggxHcSFmaW7Zsb6BAVbB8uFDta2LdJp8XvMGhG5NgdprwVhDQWktIkNRp4te/Y1RSj8i
	V4HXYlsrpp+VMS9/CR71VPVTXNmdgb443fDe+hYmQFVt9ZW+weRp/aMtJ4XpNfkqlhmXdS
	uuhyKloSvSVFzjuBl9sMEyYI+ykC6KQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758196670; a=rsa-sha256;
	cv=pass;
	b=5UMFJUpgddF8zFc6HMr2BiCy+MK0tRO0rSyOZZS7dM3T/R7tWkffXbkB9WxRN6iN8H9/TY
	rpgajrwFP9YpLFs4PwL6SSJW4amrma0XyiPkviMPrZZvdKm50qxmnUEHB9uylD1KVrPpmf
	KjJCcI2B5fdHAW7w60ITYZCDKsDi2Os=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Lo6SRfJj;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=IcMhDwWf;
	spf=pass (imf03.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58I7fvJ8007030;
	Thu, 18 Sep 2025 11:57:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=2JpGTWy6AoOweanP6t
	+7YZwtbGrBCTui5TJchDuRBeE=; b=Lo6SRfJjj4tHm0SF9xhroasOnV7l0NI9ED
	6O1xLkIkCxy2LqQQKJraNKnGbJ+v/3dJZRI8LgyXAIs53kbXaiZ/ocD6E0UdyFQt
	C0Gd8yzmcFKkPeHxVfRpqYGPcmnxNZw9XAciSw2U1iiFJvzN6qCXfNiD4Fml2ZPV
	vb4IUIkONFU+q5mcFHHmq3ZePrp6MMqns+ihGWtoiU3QdzBSEcKiWZY9sSu9uYp4
	DopX4Zai+lucxqglXaUIDNXkZfqSYyrmbBP+RfT7iRUTJ/Av4KKZpPT/L9rCfDMs
	ncTXs2FCltiZiSghID6V5md+z1iVCpJBZL/UKTIfPcIoMtsgV43w==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 497g0kbbfk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Sep 2025 11:57:44 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58IB1pn5027285;
	Thu, 18 Sep 2025 11:57:43 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012051.outbound.protection.outlook.com [52.101.53.51])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 494y2n9vpu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Sep 2025 11:57:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KBvwCmV0NBR/O9KzuDLv2v7uAhSjWrjGmzXUGTh3xsJ6mXBn7kGrcrFcEZ7vxS3Zj2j21/6UeOPMymMtX9bHZlQJV+wkAse9YwFg5LcrVw53kn/67y6Q+tDTpilIWucdqrR0OD2TH36svB1bDG4jYF9Viz8Qr8KjAgHdv8oeubMGZGU/QKkC+tyZZl4WxtJRg0kGFstOyEwtLUnRcmphxkI/LRl7prW29I4q2j4nb8BjoALAFWiq16iP2C783Wnj66IY9CkYJyW5KmPcLKxuSQjJGZS+0dT9wT+zsPgC0/pdnqFCkxUgwsVrCR+K2JLTXofk9V2UjgsGY3yUlUk0KA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2JpGTWy6AoOweanP6t+7YZwtbGrBCTui5TJchDuRBeE=;
 b=jNxCiRN18IJD7cSdAP7XvL7bIbEPgAiNxQV0FUvvHgJJddOY9i2XmC733ybt6Mt8bBdMSTiuGNR0YT9BW7AbkDm44QyOujkhEZvzBfo4nk+kSvT/l9wrQ2kdvmftTQNY4JwwgxHfFugqyD/0UIJqxRlslIv/UPs+LucLE0TG6qhVlUfSZ/lb9yNWoTVItnUjasKaXRzZXY6khDWdZYTVECiWqSWToytsYqLgg8ZvimhCs1NXz1EzxYbrYMJdxMwCAch7EEhaWsh/2sGLIxmUwTWbYs4VtRjoaDEDasbboWUnPBcodJwSrofP1xx2cErjw70zOPDabzyjZrFQPKWCdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2JpGTWy6AoOweanP6t+7YZwtbGrBCTui5TJchDuRBeE=;
 b=IcMhDwWfnOSiWjoNa3AH2eCUKF1CYt81l0FUYZKjam5MN1kLc9xJbR1QYmYwueuTZlYtEhjkgmQSpw1Fzh43MShZQnv/Q7LhvuTdSqE00cqoSwBd4yny9RSEjOc8wr4VqW0ikkrR7O9jsO/3CVel+JgL6HowKZHfmfX9fFK3nE8=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CY5PR10MB6239.namprd10.prod.outlook.com (2603:10b6:930:41::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.13; Thu, 18 Sep
 2025 11:57:40 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9137.012; Thu, 18 Sep 2025
 11:57:40 +0000
Date: Thu, 18 Sep 2025 12:57:32 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Lokesh Gidra <lokeshgidra@google.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, kaleshsingh@google.com,
        ngeoffray@google.com, jannh@google.com,
        David Hildenbrand <david@redhat.com>, Harry Yoo <harry.yoo@oracle.com>,
        Peter Xu <peterx@redhat.com>, Suren Baghdasaryan <surenb@google.com>,
        Barry Song <baohua@kernel.org>, SeongJae Park <sj@kernel.org>
Subject: Re: [PATCH 1/2] mm: always call rmap_walk() on locked folios
Message-ID: <0ea92729-2403-4de8-9ddc-a1c7bb2121c3@lucifer.local>
References: <20250918055135.2881413-1-lokeshgidra@google.com>
 <20250918055135.2881413-2-lokeshgidra@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250918055135.2881413-2-lokeshgidra@google.com>
X-ClientProxiedBy: LO2P265CA0059.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:60::23) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CY5PR10MB6239:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ad381b1-0971-474a-262d-08ddf6aa915d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xdzlyMQbMkW8GsU0sY/S/0LRFRzFnDOGMtNTwze4MfyLmwz+SE+VrcOL/rkC?=
 =?us-ascii?Q?d4kKRfu8JhBm5peEvJfiRXV8bH3N4Eg1E8CnAPBKnh6dxh/VC7G99QGWa30H?=
 =?us-ascii?Q?IT65o/16FeU95EJEmjDrdnleyP5vqHQneXfYwLdxJJja8CxqELAq0/x+1fNV?=
 =?us-ascii?Q?sdItOw1k8AeChmtpatj2JDrg7icjBacbLG2mtwzg+KWQ1eQJ9ryGrc6v7Y6z?=
 =?us-ascii?Q?Hlx8AryLmeWZqkLbxqsQpcvvsT968oiTyHtxk6ap60k6h99UfuLUpiKuFPYO?=
 =?us-ascii?Q?T2uTPUy5QO3xF2+oQi/aYLigT0bAWZmu30i5UnsNMu0KbspFXP/hy0bWeJr0?=
 =?us-ascii?Q?b7kfSR0PGW08mzTOi0v3z0Dk6fjuvHavrRxrN1aeSZcgoIrRTu2Tyj2n0aS6?=
 =?us-ascii?Q?470bWkG957zBXZxtxHFZoz3+4CMoILM+3TEL7lx4wXGRTBgBwapxHUvQfDap?=
 =?us-ascii?Q?dirhdzt6CYXMZI9uj3TTXyMy+4GAJ8w1V+1lJfOaOc1fwGSkotYE4ppU3Pcp?=
 =?us-ascii?Q?HL9OxAG+mMDDK5oW4mi26d2wmps9LjuilEP53Jz1reo7yJgLiL3Bn4iZpMhL?=
 =?us-ascii?Q?oU3EIVO+QAaLQL8D9LxZhUuge7k5QIt9CiPYqRTad3o+va0RHFQMWInjPikn?=
 =?us-ascii?Q?dQby3MWLDsbXYwzjchSYc9LvdKEH2uvdmKCJSqJzYPmXxRBS39+TxoiA71Fz?=
 =?us-ascii?Q?SPkbXTa7wWOOjasdtU4kqToX7eGCZyF79JCiFvTgA+xcd40b8Ayxe89tfibN?=
 =?us-ascii?Q?XEBsnyJyFdlBY34oKRjlSNoyscBFPwhM0pzm35eU5GNIPMnJJtMyczPMZVEE?=
 =?us-ascii?Q?O+MCKnOuwOWg7fClDqmCVkJcqMkIgVmiN9WSzhMMXdlewtiHBAW00MFmH1fL?=
 =?us-ascii?Q?bbV1Wt11uafwBkJl31Wbt5cP6VjtDAnEgNuVZrEhDMZji6whae6Dn/gT/7jn?=
 =?us-ascii?Q?JpDVLDHse7k/MezlnKaD6AoDNUgXEEfSETk5pFuY31La6SX2kLbzMPCq9qRf?=
 =?us-ascii?Q?q2kzRPDgXYhvo1QHUtTQJ9Gh4PGzL7Tr/Mk+aa0OiliiqpAhaiceYdFBiJy6?=
 =?us-ascii?Q?xcCMU8yYtrsO+tAa6Ozsq+ekbWCBRCgBPM6vKJZMwW1xvM5aDlbEXHIlmoLp?=
 =?us-ascii?Q?+R9v/1fCmB/SIGQ1BeJrQ8+U43oAMes7YOfSOnWzUD8U0Ap4oKnYJZJfPqXn?=
 =?us-ascii?Q?tdnhkLoiYHpyuVqGODHp6T8kTgwXX4Q7NSypyYAshskzcH/+gyUpgEvRx7Dr?=
 =?us-ascii?Q?/r/lkyYfDdCNQqUt4tii9AUPGe6qSJw5k9B2oAcF3JvvFIf3lSc4sTahYbGZ?=
 =?us-ascii?Q?4bT0Oa5VrW9o0AGzVagIOMBqhwgbBFv+QGeDYYXDfEjlz4jh5ikCXDrzB5+s?=
 =?us-ascii?Q?v7oMrlw8DWfTb5pQumMy5+zoKIN1dyg2uTd4tqi5WBzIxIbAuoSzoBXdA8Zd?=
 =?us-ascii?Q?ODVKHjOXh5s=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZiT7zCT3HzJL3oZkw2FN+eMZsNFPkqBrz/VI1WliUN6VfYRKR2kV0GWiurhj?=
 =?us-ascii?Q?idtm9AN1grB3JJoi0W47dJr8uPCJ0inGWnjuAyFaI+cJmyvsjLSU+AAOOsOT?=
 =?us-ascii?Q?Hm5BsuyPqLqqCQkiryPnYuYoY8QFR+Lm5S/uvHyzmGYfK9HbD1DGJZaHEtn1?=
 =?us-ascii?Q?LHm0Vowo77EHeBqj6mhhqoyZJcQWDv18x90Uq7yFDkfs7bYcYfHTRu0hi46q?=
 =?us-ascii?Q?Qdo00RIIkcSPRgs+49P4j9QYoDywKQM7JxiBgAIGrJXPjl2dv4hJ4GDTKnHn?=
 =?us-ascii?Q?lUJ67ZXBng4arlnrJMMcbcsnedoQPVaWsic+cg6l/Xl4VRdZfl5qoWb1LYdp?=
 =?us-ascii?Q?V9HBwVScsj1LWihAY2tgmgitBVU3JX+ucRpLL2sDCkVsu9X/AaqRkjLjGfI6?=
 =?us-ascii?Q?vY1Cm07oQ+NL1+IbQY+Lyy6K3fR9ZI8KpOcZfixyHR6gjzH9w0o6oDRnVgPt?=
 =?us-ascii?Q?djxDBqwht3R2JgcrE0fTuuwNlUqOwRNQUDlcTsQjKIQ24Clxgk6/LZEdn6zR?=
 =?us-ascii?Q?Y5m9W9UVFSENh8ER8u1/cksQff9o056ugIWqEsQxOU/yHKvTy+2f4nyu+ZcG?=
 =?us-ascii?Q?3zEW+9y1n4UnWi0QjgkxMLmp062wwOJRQcXuTosjSwj2MZMaaTJbJm/40XoY?=
 =?us-ascii?Q?HY9yaqNYG+g9P/Vk/Cp7RTzfb8je3WO66Y6Fh3wRiQ4/YcddUlRZ+VnTHGBh?=
 =?us-ascii?Q?PM8iI5jsel6kem/zV7q/daWJjtr6ZPrq1Z3358AcpqRCzvDmodP3BQV76asE?=
 =?us-ascii?Q?a4mAUvBaQur7YYhdAarmVl0B0KQepTriRKQ9mCpUnsye1KNmR8kDIwbaUTCo?=
 =?us-ascii?Q?N/BFFPiOo8hqWqqYL52YE7VvFABcBXGQCJayzmpYXmXcmlpGc70t8RKY+I4g?=
 =?us-ascii?Q?AmeJfXdaj6fEnxofqJAKCKpqyv/gWo3u+wlstjw0eX+Oy7C+HZ29aDh5JYrG?=
 =?us-ascii?Q?KNplGNt6UDZPb/4wx91eRkP+1lNJlRiiOJK2tzvDvTP8dst1AHKh78PTzfRu?=
 =?us-ascii?Q?tpBh/ORLKnBxkZZX+YIq5M/TmEeYDwAPfhfy8pRPRsl1LfvckcOZJVrTHA0s?=
 =?us-ascii?Q?RkcI0n/4debgOx9aqo9OQeQEYuhWFaQGLrGI9w5697a29StJJZhtQEfMGG4D?=
 =?us-ascii?Q?X+lkbHcXfy3ZK7pFYZoC/mvRy7gIniGA7xykN5UBMF7t1AjBcsiNRDas/cmn?=
 =?us-ascii?Q?CyZzbp0tYAx6g3GRHJXkuxcUY0ih8nO+kBOB/xnAMO32VrPxhNt3pMDVSdrG?=
 =?us-ascii?Q?vhOCxa68O6dqtRnDa9uTg/HVU6wR502M/9boWmjXvOMHOlRTQFRPjRokUNOv?=
 =?us-ascii?Q?8zInpwbH+eCRjkBAti+cRbCdHsWhPL8P9XJuBLGKSHDKMUhKoVyPjJeIqQMa?=
 =?us-ascii?Q?e5T+F1K3v8WG5V6qwiWRVRgjY2dAR9435eK9nXpNzvRvyPcZvMnozNM5s95r?=
 =?us-ascii?Q?Y0YeY75rPKcurKJDMo/8Y5sUqjjgUoV4hPqcvf+86WfyrcM0Nj/EieG+inK7?=
 =?us-ascii?Q?NYtL9wCbmstX2UxMDf7vPCLu4wuB3D839fstypVsJbIGWVaf0sybFVOeXayd?=
 =?us-ascii?Q?8m7xy74nF57H4uQfXJhwcqJnL+X6GQLSSRfNOdns656MaS4eP2LRd+45cQUV?=
 =?us-ascii?Q?uQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	YYoClksO+qVy/4H82vTA/PZbUp061AoU5mUw/dacw/t6d8R2RXX2IeESar/FRcY1C7k6V/PFJB5AQfjF6LcaTOAogiTa6UUIV4CzDtWLMwLrqvML+xur9phcCDyxiaKfHuqonPFZMuuAGZJ91NBA4xoEJdsBKy6Vs7SYhFvw8hABdmkwbiBC16jPaE4Jfo6yIw+B8c89rmNjRSVC+NHySny9WBPtVXLZJqloJxOhiyo20zAlWL4KjvBmGGu3DBB9E2cr4PCHPl23xh44SdS+UpvXKbqSd66AbDMVFNoZBx9oWnP8+IK9Y/ar/ztM6bgtQCFz4tq+pifUWXjuGDgsFttvlfN75grjEkzsd2N1uTAaJ5N0n83J6HT9BJhmSW6a6gjMomeDaUWowztd2Q56QmCtH5S7cwihy5S6Be1DlzfAZJLE/kjwuXNMgFc8UkNVkfqmr5fZSR5mYUjhxqXlSSJe9PuzkJJph1Nh9mMhxtKJja0kbqA91D+a2fVTM9riLViM+SbF7xjSetjuMQxOZHPc22LPZkTkqoa/SKIWnmKkY+MGvDMOx6KXKCCJq70kr8xoLc0jRPj/9ehwTUeiIVD8Q8JFaikEDsZ/tzKCKxw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ad381b1-0971-474a-262d-08ddf6aa915d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2025 11:57:40.2007
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rQKn6J0UqjOH1JLKSnK9fs6LKuRd8qcboCvvnqSPVg+BRx8++cIe335mDGugXgqCDAcOPXnnpTIZLChtjCZj/9YvF6T45En5EngxGOh/DK8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6239
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-17_01,2025-09-18_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0
 mlxlogscore=999 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509180110
X-Authority-Analysis: v=2.4 cv=b9Oy4sGx c=1 sm=1 tr=0 ts=68cbf3b8 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8
 a=1XWaLZrsAAAA:8 a=VwQbUJbxAAAA:8 a=R0XzeT9y-8mepdCEVgQA:9 a=CjuIK1q_8ugA:10
 cc=ntf awl=host:12083
X-Proofpoint-GUID: mNg646waSH3JevwXxqTMZQ1eq8D9Wecb
X-Proofpoint-ORIG-GUID: mNg646waSH3JevwXxqTMZQ1eq8D9Wecb
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwMyBTYWx0ZWRfX8UqnrvLrNnhi
 D2mHHtDtPEJtK7GDqkcgmrKC5Jn8qoK//OSyKHg1V6faVpylZx2YKu4yCJxGlhLa5208HjquA+h
 zHW+0l8jT5JNniwJyign9NQhclK5OpyMSKoVyOzIntN6916+3KnjkldBzit+TWnNidm1xsPU6LY
 /HXiuQrT4iScPfWFl4EwwRY15mu+CTGVzQnfrGRRCPIhRRIWEwXr4jNP36QElbpyjzWLe2Wff3R
 w42hyyC4qqwLtUDHy45+e1Vc4D5FhI+3etbh0fKqHp7Txss1oORghjPeURYopGfDciJv/Cvaxx8
 x+POlJ+m+x5rWoa+TZ1NTLCGm16alzdyenAwjazNDESkXqtGSYjM+4HYwvcVzrxTdnvZ+UKj6Fq
 Bb1r4fX4UAoRys33eKsj0KlK5AiUmA==
X-Stat-Signature: gntoapm4mcf5n6q465xta8inbbq7ebzt
X-Rspam-User: 
X-Rspamd-Queue-Id: E1CC720010
X-Rspamd-Server: rspam10
X-HE-Tag: 1758196669-588322
X-HE-Meta: U2FsdGVkX18Qk4lkPhgoUqSwaiywRJ/0MwrqcPhiykP//hLT9rTyT0uHCrkMaSXOBMTfgOJ9eCORmAnaVGQB8gHch2zdtnubPWbRieJTWL6eSRzpylbYa3cjC/UmuuewkyGbvrH/9Swg25a/3dtGRLJ/iBwihlHF3okcxoOW/f1xQxRgdtfi7orqn/Etz4MK4mr1DE1Q/fmbtgyUWi2I7ijZwwkUrjhERB5YXJfM4q6mqfoV6XtENeVY1XnWZqUpKvKdpZn6dzhyjJ+pQ/p6J6Tz2/7IM35OgjjJpFWfJUw3UbvHLfRfoE5MsSbIizOCclV8+TDiDnIQLn4gsMrDhTuxlCSqrDxg9ACGKEc4TOSZpeO6rWMb79Qzgn/9aEoxOMlD+fCQCA3+cAvyestBSxYJ07e90+eo0zO6HWqXjy4JwVTKNCxXT6QAXcrNjjEpuQnjO+O3mCTSjWcFmyUNbUjzMNDzXateAV9LjmJZ7sBXK1cs2jMnstKZxrAbRSiouPp8oQUC6iQJh/qcltWDuzlcDRviFMSr2mz2D32X3uaMQ72+w3l8gzwyI+tXcqA1NV/FAkCtqZRnHrKPcjo3kn/dmH2OVQKdkzgnaj27Yhaaowx7i5huflyfIOxRjIsfroY6i1O7EDS1Hf5INhISJ1PI6Cf0cHUZnRQW7HuvATkuAbFScv07Wy8ZHay2EIbsgWv5JoFWqTU3UTc3AA72JlC9na2fEeai4L6BcmsDR4F9rR051sgorV9nUkQB/78xeSIqRAJ8bUGj4gmHzepJIPbUr9qv92j0DoopKXXTAOv6In0HdenMPuVk8i6zMJlIekx+bhWFOIdItGFpn9XDLP6SxmFBrOIPxkzrJ6r3aPg8Ede31Lxl0LZXkRqmSUF9ZaQ++MOnb/gRerBLlpEReJ2yoElKDWYCs3wLo4Q03Ar/uS7hPjteOMGh2zY/IxVKqYzxYlIse86gC5Unyl4
 vY46s3+J
 3npA1os8rrOwChdwzaHkG+tnwPcOFwJfYUz2ywiJ7dEtXpAbyAjcBRjl45wBE4oaqaZy98NQT75ctSdP+9NcDLUjxAA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 10:51:34PM -0700, Lokesh Gidra wrote:
> Guarantee that rmap_walk() is called on locked folios so that threads
> changing folio->mapping and folio->index for non-KSM anon folios can
> serialize on fine-grained folio lock rather than anon_vma lock. Other
> folio types are already always locked before rmap_walk().

Be good to explain why you're doing certain things, like adding the folio
lock to kill_procs_now().

Also worth noting that you're going from _definitely_ locking non-KSM anon
to _not necessarily_ locking it.

You should explain why you think this is fine (in general - rmap callers do
some other check to see if what is expected to mapped did happen so it's
fine, or otherwise treat things as best-effort).

You should probably also put some information about performance impact
here, I think Barry provided some?

>
> This is in preparation for removing anon_vma write-lock from
> UFFDIO_MOVE.

Thanks for mentioning this :)

>
> CC: David Hildenbrand <david@redhat.com>
> CC: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> CC: Harry Yoo <harry.yoo@oracle.com>
> CC: Peter Xu <peterx@redhat.com>
> CC: Suren Baghdasaryan <surenb@google.com>
> CC: Barry Song <baohua@kernel.org>
> CC: SeongJae Park <sj@kernel.org>
> Signed-off-by: Lokesh Gidra <lokeshgidra@google.com>

OK so you're making:

folio_lock_anon_vma_read()
folio_get_anon_vma()

Require folio locks.

folio_lock_anon_vma_read() is called from:

connect_procs_anon() - changed to take folio lock.
page_idle_clear_pte_refs() - changed to take folio lock.
damon_folio_mkold() - changed to take folio lock.
damon_folio_young() - changed to take folio lock.
folio_referenced() - changed to take folio lock.
try_to_unmap() - ???
try_to_migrate() - ???

9I note that we allow a TTU_RMAP_LOCKED walk in the above unmap, migrate
cases too, wonder how these will interact?)

folio_get_anon_vma() is called from:

move_pages_huge_pmd() - already holds folio lock.
__folio_split() - already holds folio lock.
move_pages_ptes() [uffd] - already holds folio lock.
migrate_folio_unmap() - already holds folio lock.
unmap_and_move_huge_page() - already holds folio lock.

Can you:

a. Confirm the try_to_unmap() and try_to_migrate() cases take the folio
   lock. Explicitly list the callers and how they acquire the folio lock.

b. Update the commit message to include the above. You're making a _very_
   sensitive locking change here, it's important to demonstrate that you've
   considered all cases.

Thanks!

> ---
>  mm/damon/ops-common.c | 16 ++++------------
>  mm/memory-failure.c   |  3 +++
>  mm/page_idle.c        |  8 ++------
>  mm/rmap.c             | 42 ++++++++++++------------------------------
>  4 files changed, 21 insertions(+), 48 deletions(-)
>
> diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
> index 998c5180a603..f61d6dde13dc 100644
> --- a/mm/damon/ops-common.c
> +++ b/mm/damon/ops-common.c
> @@ -162,21 +162,17 @@ void damon_folio_mkold(struct folio *folio)
>  		.rmap_one = damon_folio_mkold_one,
>  		.anon_lock = folio_lock_anon_vma_read,
>  	};
> -	bool need_lock;
>
>  	if (!folio_mapped(folio) || !folio_raw_mapping(folio)) {
>  		folio_set_idle(folio);
>  		return;
>  	}
>
> -	need_lock = !folio_test_anon(folio) || folio_test_ksm(folio);
> -	if (need_lock && !folio_trylock(folio))
> +	if (!folio_trylock(folio))
>  		return;

This _seems_ to be best effort and not relying on anon always
succeeding. So should be fine.

>
>  	rmap_walk(folio, &rwc);
> -
> -	if (need_lock)
> -		folio_unlock(folio);
> +	folio_unlock(folio);
>
>  }
>
> @@ -228,7 +224,6 @@ bool damon_folio_young(struct folio *folio)
>  		.rmap_one = damon_folio_young_one,
>  		.anon_lock = folio_lock_anon_vma_read,
>  	};
> -	bool need_lock;
>
>  	if (!folio_mapped(folio) || !folio_raw_mapping(folio)) {
>  		if (folio_test_idle(folio))
> @@ -237,14 +232,11 @@ bool damon_folio_young(struct folio *folio)
>  			return true;
>  	}
>
> -	need_lock = !folio_test_anon(folio) || folio_test_ksm(folio);
> -	if (need_lock && !folio_trylock(folio))
> +	if (!folio_trylock(folio))
>  		return false;

Same as above here.

>
>  	rmap_walk(folio, &rwc);
> -
> -	if (need_lock)
> -		folio_unlock(folio);
> +	folio_unlock(folio);
>
>  	return accessed;
>  }
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index a24806bb8e82..f698df156bf8 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -2143,7 +2143,10 @@ static void kill_procs_now(struct page *p, unsigned long pfn, int flags,
>  {
>  	LIST_HEAD(tokill);
>
> +	folio_lock(folio);
>  	collect_procs(folio, p, &tokill, flags & MF_ACTION_REQUIRED);
> +	folio_unlock(folio);
> +

Good. I hate how this works.

>  	kill_procs(&tokill, true, pfn, flags);
>  }
>
> diff --git a/mm/page_idle.c b/mm/page_idle.c
> index a82b340dc204..9bf573d22e87 100644
> --- a/mm/page_idle.c
> +++ b/mm/page_idle.c
> @@ -101,19 +101,15 @@ static void page_idle_clear_pte_refs(struct folio *folio)
>  		.rmap_one = page_idle_clear_pte_refs_one,
>  		.anon_lock = folio_lock_anon_vma_read,
>  	};
> -	bool need_lock;
>
>  	if (!folio_mapped(folio) || !folio_raw_mapping(folio))
>  		return;
>
> -	need_lock = !folio_test_anon(folio) || folio_test_ksm(folio);
> -	if (need_lock && !folio_trylock(folio))
> +	if (!folio_trylock(folio))
>  		return;

This checks folio idle bit after so that's fine for anon to not succeed due
to contention.

>
>  	rmap_walk(folio, &rwc);
> -
> -	if (need_lock)
> -		folio_unlock(folio);
> +	folio_unlock(folio);
>  }
>
>  static ssize_t page_idle_bitmap_read(struct file *file, struct kobject *kobj,
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 34333ae3bd80..90584f5da379 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -489,17 +489,15 @@ void __init anon_vma_init(void)
>   * if there is a mapcount, we can dereference the anon_vma after observing
>   * those.
>   *
> - * NOTE: the caller should normally hold folio lock when calling this.  If
> - * not, the caller needs to double check the anon_vma didn't change after
> - * taking the anon_vma lock for either read or write (UFFDIO_MOVE can modify it
> - * concurrently without folio lock protection). See folio_lock_anon_vma_read()
> - * which has already covered that, and comment above remap_pages().
> + * NOTE: the caller should hold folio lock when calling this.
>   */
>  struct anon_vma *folio_get_anon_vma(const struct folio *folio)
>  {
>  	struct anon_vma *anon_vma = NULL;
>  	unsigned long anon_mapping;
>
> +	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
> +
>  	rcu_read_lock();
>  	anon_mapping = (unsigned long)READ_ONCE(folio->mapping);
>  	if ((anon_mapping & FOLIO_MAPPING_FLAGS) != FOLIO_MAPPING_ANON)
> @@ -546,7 +544,8 @@ struct anon_vma *folio_lock_anon_vma_read(const struct folio *folio,
>  	struct anon_vma *root_anon_vma;
>  	unsigned long anon_mapping;
>
> -retry:
> +	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
> +
>  	rcu_read_lock();
>  	anon_mapping = (unsigned long)READ_ONCE(folio->mapping);
>  	if ((anon_mapping & FOLIO_MAPPING_FLAGS) != FOLIO_MAPPING_ANON)
> @@ -557,17 +556,6 @@ struct anon_vma *folio_lock_anon_vma_read(const struct folio *folio,
>  	anon_vma = (struct anon_vma *) (anon_mapping - FOLIO_MAPPING_ANON);
>  	root_anon_vma = READ_ONCE(anon_vma->root);
>  	if (down_read_trylock(&root_anon_vma->rwsem)) {
> -		/*
> -		 * folio_move_anon_rmap() might have changed the anon_vma as we
> -		 * might not hold the folio lock here.
> -		 */
> -		if (unlikely((unsigned long)READ_ONCE(folio->mapping) !=
> -			     anon_mapping)) {
> -			up_read(&root_anon_vma->rwsem);
> -			rcu_read_unlock();
> -			goto retry;
> -		}
> -
>  		/*
>  		 * If the folio is still mapped, then this anon_vma is still
>  		 * its anon_vma, and holding the mutex ensures that it will
> @@ -602,18 +590,6 @@ struct anon_vma *folio_lock_anon_vma_read(const struct folio *folio,
>  	rcu_read_unlock();
>  	anon_vma_lock_read(anon_vma);
>
> -	/*
> -	 * folio_move_anon_rmap() might have changed the anon_vma as we might
> -	 * not hold the folio lock here.
> -	 */
> -	if (unlikely((unsigned long)READ_ONCE(folio->mapping) !=
> -		     anon_mapping)) {
> -		anon_vma_unlock_read(anon_vma);
> -		put_anon_vma(anon_vma);
> -		anon_vma = NULL;
> -		goto retry;
> -	}
> -
>  	if (atomic_dec_and_test(&anon_vma->refcount)) {
>  		/*
>  		 * Oops, we held the last refcount, release the lock
> @@ -1005,7 +981,7 @@ int folio_referenced(struct folio *folio, int is_locked,
>  	if (!folio_raw_mapping(folio))
>  		return 0;
>
> -	if (!is_locked && (!folio_test_anon(folio) || folio_test_ksm(folio))) {
> +	if (!is_locked) {
>  		we_locked = folio_trylock(folio);
>  		if (!we_locked)
>  			return 1;
> @@ -2815,6 +2791,12 @@ static void rmap_walk_anon(struct folio *folio,
>  	pgoff_t pgoff_start, pgoff_end;
>  	struct anon_vma_chain *avc;
>
> +	/*
> +	 * The folio lock ensures that folio->mapping can't be changed under us
> +	 * to an anon_vma with different root.
> +	 */
> +	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
> +
>  	if (locked) {
>  		anon_vma = folio_anon_vma(folio);
>  		/* anon_vma disappear under us? */
> --
> 2.51.0.384.g4c02a37b29-goog
>
>

All of the above actual changes to the locking logic looks ok to me though.

