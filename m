Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6680BCAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 17:45:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F0848E0122; Thu, 18 Sep 2025 13:45:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C8008E00F6; Thu, 18 Sep 2025 13:45:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78FDD8E0122; Thu, 18 Sep 2025 13:45:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6435C8E00F6
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 13:45:47 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E39341402A3
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 17:45:46 +0000 (UTC)
X-FDA: 83903098692.05.AF7DC26
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5F0E418000C
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 17:45:43 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=T6Totcpa;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ljsY66j2;
	spf=pass (imf16.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758217543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nmLltfCzVmsgMb0jCANh0l5NLuK3pf4lKl+ppQr7S/c=;
	b=d1+Qz4tEKLZUspKT25EIW+CSqlQGYwFYqCzPU9fxYEoXEr2e39Bx/yb8WsEjGL+eJ2gtPQ
	8s87cVUQ0J9K/5+UTGf7GxzdZ+LUhS1Sf5JPbv7ukH+wIHMXp23bbvtmHlGOTD/el1yeTL
	DVsnZ+/aUBoQybRniKhuibDpo7Kmc3w=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=T6Totcpa;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ljsY66j2;
	spf=pass (imf16.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758217543; a=rsa-sha256;
	cv=pass;
	b=nOpU44g6mGgy/1h0QFnWGE6AdrjaefbIcr7D+CZWta/rgGtfRlWkrxivINwjzZwBL00LV1
	8Tw5IFfQwAHQh2cDnhwsnJxqG5ZBIJncKbiKOtC4YxhJ1o7z6p7RHLRmZ8EPnYyCgAHHeZ
	mo7CEtsufcrF3QauWXIqqWfodRO5iWY=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58IG7Ea8009024;
	Thu, 18 Sep 2025 17:45:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=nmLltfCzVmsgMb0jCA
	Nh0l5NLuK3pf4lKl+ppQr7S/c=; b=T6Totcpa2LPvlkiQWL2MsXBFhWRer7T4Xa
	t9LjpmW8tj7jT15WsdJde2vwMi3WwVcDNRKqHFlioX7KfUXmw4KgyOYK1AzQVQnV
	7ZHfjZUsw57Wl69q09V5J750ChvlSm+RN4/ml1n4eoYycSEoUjJZVe1DTPkuSeSQ
	W7NF2rid8gYZ7yTnD6pExHRd3lcQxWM47bkPBQUNH+IPVdo82YAokBVqi8Kb3JW3
	6RKqp6jyzmbV8yse42Y4+hTaBUuxR7vwGAdPr75XRPZ2HEvtvTvIdg/887jrPU3F
	4FyifLt8uivxiUFNnAMG6i2jN+HQ5A7FJuUOt3X3OWa7J78RkPWQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 497fxbv21p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Sep 2025 17:45:35 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58IHPcLT033679;
	Thu, 18 Sep 2025 17:45:34 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011062.outbound.protection.outlook.com [52.101.62.62])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 494y2fe4tt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Sep 2025 17:45:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Fvs59G/4DTIfUdoS3QtwHn6YJiR1aYpBLipXmjuA00bnsHrBYuLNHkdDCKPCjn6vTQGu4dTn2UCJbhM45pZtK4/MLY2mnxvS/VXRr5oPHCPWMi5w1eFjj7IvkJsDdLBoHV/N9C05vrf/ocPLPw6pPujZ+4fqKDG1A+P8xDhIXweeGb6s3xJTop6hwzgmpLH4T+DaZyB+QIFLkbrmtYB3GENytDhzWqHUc0mO4ishKI1yt3nQuT1Qi+Z8JxkdodG563v3kHwRg8g9pwhyenlaoVva6iDIVBg1tdFWpsANa6WBkambWhH/O1GUPiqNeezARXcklHN8XrN50IcvWBnnmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nmLltfCzVmsgMb0jCANh0l5NLuK3pf4lKl+ppQr7S/c=;
 b=KWV0QrGCThOv0P6bzgqFb7svkqzCrDcbD+xldFd6bsw/KwhLBHFfMUqDdf3nJsuvhJpL+y6qZPK/mxlSNEFcmP/ZV8jtzhNpzqQ4KTP2zyblKJEoZnJwmTgMeI2P9Tgkt8jaJLH7Zcce5SSm1f5YRSlYKUCzma0tO9eP6uBWlb52mDUWL75o28m60f1be5jCfLAyhwILCn9r7sTfJ+qgzvI05BH4kQu/orcr6KFaovkjMNXRNQne/Az53hw5D87VzueZpYfMdkVRGtvxakmHmIhjtB+EdDJ1mFl4nvSqsrytR0S/M3FM1Zp5fBEWVwrYWp/29ssrJIMk2b7N1Yp2CA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nmLltfCzVmsgMb0jCANh0l5NLuK3pf4lKl+ppQr7S/c=;
 b=ljsY66j2ldclyhZ7xVhBNxYc+nilhsLRVg+EqLjfb5KMdKVurTqgbBbjtXYe/wrCE6/nJyUZKiBXans1ENeX0W4qCBcCwQXTPVHqgtHXr2qsQBsRGsKVsvstOiCJLotcxWRwchjS0Nu7jhasEP1T+mQvuscddp2PLICqXRfGsao=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SA1PR10MB7683.namprd10.prod.outlook.com (2603:10b6:806:386::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.13; Thu, 18 Sep
 2025 17:45:31 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9137.012; Thu, 18 Sep 2025
 17:45:31 +0000
Date: Thu, 18 Sep 2025 18:45:28 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Nikita Kalyazin <kalyazin@amazon.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Mike Rapoport <rppt@kernel.org>, Peter Xu <peterx@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>,
        Muchun Song <muchun.song@linux.dev>, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Houghton <jthoughton@google.com>, Michal Hocko <mhocko@suse.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Oscar Salvador <osalvador@suse.de>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Ujwal Kundur <ujwal.kundur@gmail.com>
Subject: Re: [PATCH v2 1/4] mm: Introduce vm_uffd_ops API
Message-ID: <7cccbceb-b833-4a21-bdc4-1ff9d1d6c14f@lucifer.local>
References: <289eede1-d47d-49a2-b9b6-ff8050d84893@redhat.com>
 <aGfsaIIzHWfjcNFd@x1.local>
 <e7vr62s73dftijeveyg6lfgivctijz4qcar3teswjbuv6gog3k@4sbpuj35nbbh>
 <930d8830-3d5d-496d-80d8-b716ea6446bb@amazon.com>
 <jxekhkhbn7uk23oe24svxrs3vfuhseae57sqagndqgh2e7h33o@kfkygmrvjb5n>
 <aMp-kW3OLqtZs8sh@kernel.org>
 <du5pzxmfk6lile3ykpaloylwz4eni6disj2oe25eq6ipzqemiw@ybcouflfnlev>
 <aMvEu9m7fJLnj862@kernel.org>
 <4czztpp7emy7gnigoa7aap2expmlnrpvhugko7q4ycfj2ikuck@v6aq7tzr6yeq>
 <a1a48a0e-62d3-48d0-b9c2-492eb190b99f@amazon.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a1a48a0e-62d3-48d0-b9c2-492eb190b99f@amazon.com>
X-ClientProxiedBy: LO4P265CA0232.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:315::14) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SA1PR10MB7683:EE_
X-MS-Office365-Filtering-Correlation-Id: 68407d07-6eec-4946-5503-08ddf6db2950
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?pm6R4F6WDuIhuooUZN+O4+yVTZ+2Qof/F2z9kD2efTAKkZQ70k06ZwkEdXhZ?=
 =?us-ascii?Q?4RzOhyMGdbUA6IzIyFbY4sOwHmJKmycwKFaWkYEtG0PalPNP/XsQAKWVxigk?=
 =?us-ascii?Q?PGxEIO3eL4aVV8/q8qcDL4s9+cSxmV79s6x9ac3AUWz47h6laACdx74aevWR?=
 =?us-ascii?Q?7x10GHk2zlwhrWqiaOgr0szf6yhXSo30KoXfqepX1Z10UKyt1on75IHkq3v3?=
 =?us-ascii?Q?E/x1dejuw2BpiHLrb2ellj/lyg1+VLdoFLH8/TcQZbbgyhAZJ9zDmLSC5h8w?=
 =?us-ascii?Q?6DIE+VNAme45YUrqJN6pg3NvIRklDolm+XYAVzKClSr6RP/2QbV3Bh+1ZHRs?=
 =?us-ascii?Q?UdTifybTcXnetNwdK54PssuU50A1a1CCEZ0TDbdzemwe2x/VC3lzeQJM668J?=
 =?us-ascii?Q?75zsZEth3v1XljIf0l2KsewRXKbM5jbtFTMD0IhdwDwZ2wu8TJ6B/CBfpmRR?=
 =?us-ascii?Q?U6C7yASytJCZihqfCFsWS3sgIfwkln23GFxyDuPaNJv8woUPDgrhDx+OsFyJ?=
 =?us-ascii?Q?7Q6T8tc8tskAmQeh/fwI6a0Ytq3MsUuE6cf3RnSOsktO2zeO75MoQsplIBtr?=
 =?us-ascii?Q?LrytVBWLruEjQWZCZSoPXJI4LKTwZIQ91BCJ4gMw7QB6I/+WQayVaW4EvH4H?=
 =?us-ascii?Q?9kizc6SI9lM32bgxdeaZu9scjebC1qqZ2IM7UiKJXpULY6cvWq3zJ6B7zGJr?=
 =?us-ascii?Q?qwAxT+d3PJWJy02bMgh75dSxvi3ihgmEsBKY9dO4zn0DRX7CdjUDKFheYMSJ?=
 =?us-ascii?Q?ZSQuibicnOWm9fAC84APG7BXj8/Kj/YTf2voIo8AfQijXsowTdVLEzqfWf5h?=
 =?us-ascii?Q?pDu66P3/b1j32QvgMd2Tfhb8nzvPHkRtxvE/5oLi4alM2x+JHJzuNbz8G9Wz?=
 =?us-ascii?Q?lSNgbmtUDCksdwTQfSry/DB/h/F+0vJICQhYkr+laU3GNchBkkeKuump+aGv?=
 =?us-ascii?Q?PG9K/PP8i6LAwLKabAWqdH/RwMuZf9DyMrnuj3yhUD7Ji3GXPynKrMD/s/1x?=
 =?us-ascii?Q?pWzdR6f2TTXwJjWu/Goo+UQqUNwOvh5ARhs4omBNMbxAfR1hdMb4WBsmm/kn?=
 =?us-ascii?Q?c+sHHTa/uS1DHUDjp92JyRE/3djvmP3BiWkqUMHdCnGCoPqQc9UqCbtXCF6L?=
 =?us-ascii?Q?kOyiulRxajEfM5Q7x9BBLPdoJ3l8WA9FbOAgn2xQJ8tXsrddPlh+41LmFhzy?=
 =?us-ascii?Q?risTp04BkcAHkfd9HQOYtpRWhwLd+5xo5n2m0Rtc/kAnX7xA4pH7Ev+ta7L5?=
 =?us-ascii?Q?mMW5/Zs+7kAhzzcAnbzJBsODVtmyICzcid22VNSRaAk0KsP0cCaCTfoA/SPU?=
 =?us-ascii?Q?B0gt+aouTfYFLuAKgGMKlPeAo13QJy+GfqdQKHRfh+e1KvmQJoJgf7dHNM5c?=
 =?us-ascii?Q?X6a/GWwseDC0PviIPsbxxYzBGEoc?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vMOf4eGHxAEoejJjHS0wcU/z+W4jKU1B3HtI245H10+AKzV+le8G7lxq+cb+?=
 =?us-ascii?Q?F5Mx5PtzUdixPBmyFUToskk4NGlalh303kL2Gsk+Fh6EZt7eaf6mJoMpIxka?=
 =?us-ascii?Q?7AmPUBkfkN2uY4hJWkk2+OhJhIFt3oMSqQaTSOV7QBPg6onLqsDVDY6FCQF1?=
 =?us-ascii?Q?6gDIsP+9Fg2YSJQbcZ5H2c8GrHF06oCneDrQtSQtM/mgHnyMbTsizqUnM9jm?=
 =?us-ascii?Q?cqOriHYyGafpB4tbx0iv7zjPwcZrTzvX52FCNjU9MGYYxkias0Hm4dkPItUV?=
 =?us-ascii?Q?DmWLiXdV0uT4RZMldm2sb5oi0nu8hnSttqVL+Cxn2sTfN4+YvPVnriZKgQlp?=
 =?us-ascii?Q?gtpsjiCTlxf+jYRBj3xod4qlPx8GpH7n5FvygnC9o7A1XUI1Bw9gJa9lrayr?=
 =?us-ascii?Q?zsOnayH9unTWvbtb7IouAKo+UzbJb0QurZ6JmxhZT0XmxaXV0fpId5F/Rp/J?=
 =?us-ascii?Q?2tHTM3w0rktQ2qPxIDO3GojBp8HxTcWxGUmZ2ZVitZ3fSYYj3RtUZ47DjSH5?=
 =?us-ascii?Q?fABzkvXoUuU1eLvLB60FXPwGHyDkC/5uIsMucLSrZk3ep3eZsvI7x/K3n1VI?=
 =?us-ascii?Q?ulYvs7+fdeTm6LTO5KUDmIbmFQm380Bviygx8NlABiVyYA47UcD8hGTNXlZV?=
 =?us-ascii?Q?fzAV8eCHqSk+10YP5HzjaZubj3VstgOCrYgZQe4LytFIixTETf358+PXBYss?=
 =?us-ascii?Q?4XVTOR+w/eF9nItQvmv7QrSAe4mZvzpfi7NPw75HpxMJ/ds/tVEP7TDYkJKz?=
 =?us-ascii?Q?fe+1+PrBYInnpZIkryKADULsIp89ynTQ3IvfER3D6mu51Fm3mMjZbQxBCKi5?=
 =?us-ascii?Q?jeLmIMruF4U2jiosAXWqWfye/qNWhLyyCbaK5jd4aA5YOTsCWNL6x568XdOV?=
 =?us-ascii?Q?cr4HbRLm7qBj/jUqtyaawgH5zYXkUbj+iquQBVsywIwwPTbPntAOrxkkEN9s?=
 =?us-ascii?Q?RVar67pGw/jxvNZxu7k1Mm7Ky8u1Qtkq3uc788Jqc1/SDP0UnsKdUyyQYCs9?=
 =?us-ascii?Q?EHZM/x9VRXh7Q1C4xwgADt+DYwxlCksLABi3YYXQFkAgJqEbdBg4Ajrm4hbN?=
 =?us-ascii?Q?e6drFWC9bi1ERYAZZks5eeuOa12Lkm+65bqTFre1LL6e5K2elB/CRgirTfV1?=
 =?us-ascii?Q?o9f9qVYPLdVS47IVctBDH+DSA4UPtG5tCxub1QNAup71DcAjxy/Ji2/9YdIM?=
 =?us-ascii?Q?3Z0Pelh6L57lzEvkICx+3SzCSMcwmzBfUQruNedgXOq62qnNWyCcVbZYWjfG?=
 =?us-ascii?Q?cFsLynh4AFq046PZmcg/nLFc+Ptd7mW8iKFhG/DuiK71d4lz1iDC56gpI3SH?=
 =?us-ascii?Q?n+Ee5WusCaTN4z6kZoBdGv3n9WubLbbNO7d3/14jknJPtbvX6cBD5NT3QE2O?=
 =?us-ascii?Q?9eAScVm8vNr2sjHp3JWdLNzckxgQIlfUeVADfTMQsotSVm1OsugIvr9MIa9k?=
 =?us-ascii?Q?ukad3Z7Ha61wnTUduOe3P/rm6KCLs9l0Vq/dm2ACZJv6JfkCJiX5boqGoOtY?=
 =?us-ascii?Q?Dpp2gCKFxTWKZlyYmkzR2nozMCLi9x9MneMQavzVea+OpMh2CVcqXh452Ur+?=
 =?us-ascii?Q?tsafoIZXeOwHqpdsaaAnZXl15o55/kUtScLvsTeA+iGr03v8tC5W01hGaHyY?=
 =?us-ascii?Q?Fg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	xohmE4amp2+cNtt3p81pX9oCGUuOMCI6LsCkxGbam7KywEqLM6lU8Q+2SLbdVvhTUJZgcwEmFcVbMLlUJKVXHwb/f2c9FBgwGNRL0k2uomxVEKVFyYPflZp15N4jDTsZJ7byDqQBDlWpukS2zr7FZiIBxKvU9mtxXZ46epztErgWlqc0Pc7kPThWVNx3UUdK4JrmdjK+J4GCZLKvMb74R2KNxDpRFzqCASXUp3NIk4OS/Ce453ZsSWdKtwFlvjMCVDxMuPzBhBx83h1b9A1WEX40Rw3ggpvjrDdu77huCFQxBgXGIAMfqjCZGYdQHFRrCH46gNlA6c60DysXcHIGCpF4wVw0KGEvcuNb0K/wCdnOk6Qa0MWpqRAez+W729GrOuXHu2NusYMv6uUej2Z3tXMSHaNweqf4I8Zt2aIMmH4UdWKcoKhCXGvns00OramJkeDuUaAFVs6Xxp7QOKwJLqlSAzvRcZxM7u6fs9k0RDVvXXrV5lUmwZCzdK4i+w3IBP4EDM7FTCKMh5lTRwEbhFxF4VrIAHNu8jI+jCmiNcL2rfFj6FL5JJQ3023lvQ23Veb0QAFqO4oC75xy8hS+slXNvN+5iDlou97mYN5PpB8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68407d07-6eec-4946-5503-08ddf6db2950
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2025 17:45:31.1160
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bLmGfH35j8IW95pEYWxnkTHyAUUT8sPo7CWoI8pQ1MgEcTVuLmzUyeFAWNUgjQXNU04GvAwyv8FgTYA7vE9ma7HvBw6I9aY/3SJZ657HLCw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7683
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-18_02,2025-09-18_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 adultscore=0
 mlxlogscore=634 spamscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509180157
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwMiBTYWx0ZWRfX8gJ9IinCuMi/
 RPka+37gbIVxSwzjInMU2ggVNI79P0O6Kn/Wr+Sflzn8dP1RsJilgNHtCeeZlPZFuDtg7ezrLDG
 fn3xUnN9pi4nix7o6AO5DzJF3Yzf7eUMngKQwYtwlKnCM09tW4R69cK8V8KvlZy+fkh8bRgDr5+
 ad9AK1r/LaZ6n0Kr0p/wWOkilAkOa4ZMHYhDl/Lk0LQ0xTX7OGG7PjxpSD5OOpG42JoPDTpy5rS
 isoWHrACPAv4+K4tdufv4zysAt1IgiX9KOqie2VfU9Uz8zcxvviUubZcl0AGTc3EB/FBhXLorvM
 mA5WJkxWOywxW9rqq0Ks4ToyUzRn8U4w9x0SRhvuaT+j/5BwSXVq0T3yu8tRGhBC/10CqYT7+WG
 j/4CLJJP
X-Authority-Analysis: v=2.4 cv=X5RSKHTe c=1 sm=1 tr=0 ts=68cc453f b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8
 a=6afs6eU38MASH10YQcYA:9 a=CjuIK1q_8ugA:10 a=ZXulRonScM0A:10
X-Proofpoint-GUID: -UYcHUTio643O_2bbKzHVca-nAc4d3ST
X-Proofpoint-ORIG-GUID: -UYcHUTio643O_2bbKzHVca-nAc4d3ST
X-Rspamd-Queue-Id: 5F0E418000C
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: i4g9mz3jt3nz4kppwkc5xkab8qjdcfc1
X-HE-Tag: 1758217543-881067
X-HE-Meta: U2FsdGVkX189qVzmDq+n2jRX/GuO2FRLX6au1O1Eik/fQT2W0242ch7cCOY9kw/RYjtG+Kkr2EIg+j1Yr5x3DStFXVTCDnD53QRhzliYkyhtDY26kZAh7Ytz9FO3XsYFzFmQPZc9RBNG82A6WbHHTMqoD/msxOYKVZyJtJvcBddTM91WguE+gexaP4iZa+UiHUWco0UoKUp+U/etOHt20zd+r7ndGM1mWoqzyCCTLl2LuV7EDQTdLo1pNg199ue6t3/D6/LQB7jqkMq7w3UJ/qkXgI/vLjZVMRYqLP7fL7a49ParCfplaHwAKK6j+av8aHn66BB3SN2HUTi86H7bP8U9HDiZnCDRW3ZetfjwJ60jqMKQKYRMajT/qToX0gmQb+XluZ2GV78/YoFGd3GEjuuyOukiZPm0QW3Or/0vHxJ0EFgiM6y1r9xSJ61q68v6LHZ28+clDlL38niBVWTskDyPwaZhV0rphfUOJiVf2n5P2HlkKSASqZ3B2wFrAuTzJT6hwkcgl7K6IbbboRCfPMw5CBGXBOCaiyOumHxTJqy5yVzd521boCkad1dcwe9W/n8Xzzgpju06+EPnO6kCjTK2OqQBNQvo9qs/Ude15QeX9DMJ0A7xApQu3kgv2+99TdgZetw0MQ0y07FHyf3AU5BvoBsPFKKl9gKPSqv9QJPjLn9GrhjE8RnyGbLnpW/bnijiNusAcf08Dqz17m8MdUCFGQ8Wo8a0d9cWgVuqKa3bZVjYDO+xSAxlfA77LO67708tGf7S7ItYFubh2OaYzanuIIn3nGjf0/KKd7BsotkkS57UgljfIJkiEORpLRTDS6YFhKfHBAKEKd/T8DVhSIihQTJKg7+da7kJF9ghlw0tN2sNv8B4Xy1H3CYiXq81fhmmknd36035jdeYi9dzvH/Lp1PWx8TRutPgwGxiuXOJbfrVzpT/95DXdZWVPXg4+AW+7ZkK7xvOM/hGugx
 1QRj0Tye
 IjwhXtkNBePxpaumJpOSqApaxlveKOEWRyHPlwL0Yqq7dG0K1zhto+W+2OH6ejl8Pr7il2/MSUGkmvqYJ85i8XlKy50ufTz3gMG4ssla3PtLIBS2aj9KPhqKZMWkXbUCvODONaobm1dWk7CPmr1a4ZiAq5EEIuxTaqFL8TLRXFCoObHOVul0gPuOX/yqad8vv1pIS0qoYNLaG8OBMFhse+oFiUTbhRNsOyFaIG1Qvef3zTOlKIQD/Z15oWnVOP5LHHskJ75ykOVhQLYITqB6EqMxUVoMIpPZKVL4rLwei5CMuoRt/FGoW+bRV7/mPnlWBLHGnJ2R17MfK907I7qE3fQlw4FcWU9bW1GBkpRKGiJUkSwdJvqQsCEgYhe3OGdnYy1voGIRRHX+krduccTSkmIQtzKBxGEM1sFQPX4303tlw+lUbVEr6ZLqWUfRHeOpygOZkDPbnwvef5uHWvFC05pnrL2EnmVE6qVmXuUGADoeumW5uSsSjRbe6+ESlNO4bQwC1N+ptjQHhBfop5Thb2Nw1qTaZV2gm/MWr2l0u2XgAdJ2OlAXZsyHN8GLHqtjD/b9tBZ5f953ygKKEXXF7CSy0a/l13ECaUHirrd0CTct/+bJuBxr/riM2rTsUyFuI/nm1DL1cXE7bqN5VvzVZUFMwPjvm1xBak0DHu9loTh0Z0R3W9KVxAyaZEH5bATN3t0oLbafc9AUe6S4WVOBN8N4ggt7IixYQPXWnJU+RUONVMZz/PWfhEEyxdQLP9FGxJMPnYbDp+o3UWUTOySu0TLTFxZ0kCkZo17gnQSYzz0ohzLKiP5KwXx2cEbKHwg5dk9NSNfIjqLwfRueL+O5HMc5Ohgel0utebIW2WBpyEs7BUYd7a1Zt9N8YXmwU/79/6cpWQNosRdAja63mdLBbKxwJCQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 18, 2025 at 06:15:41PM +0100, Nikita Kalyazin wrote:
> The other patches it I was building on top were mmap support in guest_memfd
> [4], which is currently merged in kvm/next, and also part of [3].
>
> [3] https://git.kernel.org/pub/scm/linux/kernel/git/david/linux.git/tree/virt/kvm/guest_memfd.c?id=911634bac3107b237dcd8fdcb6ac91a22741cbe7#n347
> [4] https://lore.kernel.org/kvm/20250729225455.670324-1-seanjc@google.com

Note that the mmap implementation is changing to mmap_prepare. It's the
case in point example of where we exposed an internal mm object (VMA) and
experienced significant issues including embargoed critical zero-day
security reports as a result.

I took a quick look at [3] and it seems you're using it in a totally normal
way which is completely fine, however, and it'll be very easily convertible
to mmap_prepare.

Cheers, Lorenzo

