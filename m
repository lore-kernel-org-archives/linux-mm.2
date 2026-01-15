Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4245D41179
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 12:23:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2868B6B008A; Thu, 15 Jan 2026 07:23:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2509A6B008C; Thu, 15 Jan 2026 07:23:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11E2F6B0092; Thu, 15 Jan 2026 07:23:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 001DF6B008A
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 07:23:01 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 96B64B82BB
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 12:23:01 +0000 (UTC)
X-FDA: 84334112562.22.66944AF
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf30.hostedemail.com (Postfix) with ESMTP id 598C380009
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 12:22:58 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=JNm6Fr9H;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="pzYZ288/";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768479778;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AG6cfbhQxZnoqFb3Mdt/j794Xp0jQbE5ty3ALR6itkI=;
	b=g5zVz4wbmmx89TAXo2OtUUQik4d92iaWgKeI74c4YBX8etWqYX9ONyJjJGLuRcBpNeyO2B
	/0c+AxA4VxcIflIfrU5yCJ968ekFxpt0bjqMFi22bCEHIcxX5DRoUBsQFsaaJW088JOF2B
	wOD4f1iXkRVZWHZeUcxqoZyen9vHkqw=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=JNm6Fr9H;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="pzYZ288/";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768479778; a=rsa-sha256;
	cv=pass;
	b=D5Lf3UsEPwlAe/H/qnSt31ZzZlGKhcjMXymAnFC5GwfpMjwDpZEbi04xXu+VGUGNEpJxrH
	o5jHlEKthdaPi6wso8zilrvZaMrfwcPq1GmgPCBF56YOE8FW7os0elP0eX8nvECbrQg933
	Y8xu65YgBnRLOEcipOWrjnWO7ZXznGk=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60F9amZJ1098168;
	Thu, 15 Jan 2026 12:22:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=AG6cfbhQxZnoqFb3Md
	t/j794Xp0jQbE5ty3ALR6itkI=; b=JNm6Fr9HiEXnVxnf841jQboqo0/XVrGIB/
	pzmbsquJLqMtjoBcuy7R0ZZNGpVPf/gA781rTR4wa+Cn5UH6Ipqu3xj5iTWrqQq2
	jx9W5J0EJ2WWjtxGN8mcgS31q35WpCuY/+ukKE4b6T9htpDdw9FhBh4tniZbqcBj
	aM3qVOBkZwwdHxQGQp/Vy1RTLmmPyt4vnkf6LigbSj1JT9aA20LMI4R//xlVA9Zc
	d4GXWFY38fq0jj4OpJ/9MjKmUW5wx0QRtSPQ/Vexrx62/ie/zwmlHg289s2GmF0X
	W0+newFiQ9riuEOICOxm7S0i7z9REX/V54531HYsSu7w4bHLaWSA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkntb7p2n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 12:22:44 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60FAwTfV035224;
	Thu, 15 Jan 2026 12:22:43 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013015.outbound.protection.outlook.com [40.107.201.15])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7b9f1x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 12:22:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q8dowmFPacCc0y6od5pazENdwDZtBs2/3M2DYL6uuy/kY70WZOEN2lyraJ9GBYDzZe9CqgL5gjAo2TYqXexuy2b1DhcetyCFXHK76+H/IUHQf/+Mm0343k5flFbAozCsauW45KNaWxPkC7husm//mwmYNwcVXXANCBQ35QHZp9u4PF++Dkbjpple4DUXa7zYyieJW3FwO1HjmS7FRS2/l+ix8QoLYae8eiirDEMmXv/EQ+pxTak1VF8rcFmCfzSoaFFvFGQEkLNkDjq+DKwjIxwdcfFYM98MpM15A4eJrPrSdYmbvQiuRjVdscMafs3rdewaSA9+LEvuB6KwHwUEvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AG6cfbhQxZnoqFb3Mdt/j794Xp0jQbE5ty3ALR6itkI=;
 b=mu7IqrRBAGSdWbUe8lSqWjQLK02GMHMnnZTQWJNNIsBd6xoMgQlgiCOaYB48w0EPsb9QxlDLkJ+ZAotkgOkgAOt0efZgyhz/zg9L+E+rSRh5NZtg+d7iyikU+8uJGM+516rXfXpp4gdxxIxmQVNWvClVRKoxJ7GTtM7t4NKZV9HELUBeqcPxM52IgfoVP+L4hpAmQwXodCVZBHJjg813NFXYGz40+0gNCwer71d/8Gght2Cge/ft8A7R9bSBjth2tnINGKVU4q7j2hhDaI3gXYV7ekXe2gEp3fl2xpZ4zpa0HD85v8PxiqEXIl1F9j6U4BA99TczsNWEQG3FC6sxrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AG6cfbhQxZnoqFb3Mdt/j794Xp0jQbE5ty3ALR6itkI=;
 b=pzYZ288/uo0269oHT9VeO6hR1DWtfze7CTD497JeoILjms4AvI31tz4LcyyoPXlzYwxNAwSxaBITshoyzaYO4tizNX26x/LVDN7Uc2bF03tog9yFHmHUSvvnFlJmBFvvy6gpD2TahW0c9OxHKZjZcNXSrx9nP+BpIwCnAq6VA0c=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by DS4PPFAEF42CAE1.namprd10.prod.outlook.com (2603:10b6:f:fc00::d40) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Thu, 15 Jan
 2026 12:22:39 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Thu, 15 Jan 2026
 12:22:39 +0000
Date: Thu, 15 Jan 2026 12:22:42 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linuxppc-dev@lists.ozlabs.org,
        Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
        linux-doc@vger.kernel.org, virtualization@lists.linux.dev,
        Andrew Morton <akpm@linux-foundation.org>,
        Oscar Salvador <osalvador@suse.de>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jerrin Shaji George <jerrin.shaji-george@broadcom.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
        Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH v2 09/23] mm/balloon_compaction: make balloon_mops static
Message-ID: <e353de9f-5e7c-4c6c-b34d-8ac6fe66506a@lucifer.local>
References: <20260115092015.3928975-1-david@kernel.org>
 <20260115092015.3928975-10-david@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260115092015.3928975-10-david@kernel.org>
X-ClientProxiedBy: LO3P265CA0010.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:bb::15) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|DS4PPFAEF42CAE1:EE_
X-MS-Office365-Filtering-Correlation-Id: 42067825-c761-4a41-ab8e-08de5430c665
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?gKWsbZ4eeJmU1nAX/mmi9m+9o31e9c4unrk8qjukLehrWbU2SsRoBCxGn9KZ?=
 =?us-ascii?Q?aOUZGZf54CglRaOio7wR/Qrps/fKOjYHLSP5/6r9uX00FGFPuJxv8+tVRNc8?=
 =?us-ascii?Q?INvyaZke+RhSEg6LYzeGp6dN6qlgxayT2tABdCB8O++NmvOKZqZtjyVsweB/?=
 =?us-ascii?Q?Z5D15YmtgGJM9CKsCARcV3fntwGWAmvoeTNdfacBiYr7cfr+laIHjNYYpu48?=
 =?us-ascii?Q?TlatQpux+7B9rt/kRav6xmdWvdORheNqZqmCmQxAc/OGNM0lX0DOosAX1jOT?=
 =?us-ascii?Q?LYuQJzhxqCWvx9ISwOexNfS8ek6OzLV8Wn4nDeHU24WaMRT1TGLB4nHmFnT1?=
 =?us-ascii?Q?bOgap5HiGOQjGon6wp5kib7GBUDVtKSFdHHOt+oxl9KX7oTcmZLWHun1hsYJ?=
 =?us-ascii?Q?CCkttXZ7B6TYJGckUJ/1dRzjDQO7tZg/QbUHQzCDiADJlswb9zDvEiyCVyVR?=
 =?us-ascii?Q?DeoirCo6HLHPkWpIJzkiupvZIOT6hGCOghOQyCUoremXqLv0ItespvolmDve?=
 =?us-ascii?Q?yJAEndw7HCu1Cf1KxCjymDTP9Dk2fu4U3AFcjNMOVjLnYkvtWc/CUvrtp2uV?=
 =?us-ascii?Q?/ODvJMQ2w1iOg5qz8vdQkFkriodgx+PQHfmUwhj9LxXLdKKvmYkIsFX8F/ZW?=
 =?us-ascii?Q?bUSd4Fd9D+1s/NYjaSA/7R3302rYEoBFJDrmVm8QMcDYDqDnBbmQHSF2B/M7?=
 =?us-ascii?Q?lSOWz/G0KDTeA7gI43ktBDk56x04mWl5+Ceba/OauHlwqsPeWS9Ab1mbgLJb?=
 =?us-ascii?Q?K0MPXXkjBRAEUG8ECznVRXD7gC9MnekAAMS3BWR8/s0FF3rb3gj1TBcwccu6?=
 =?us-ascii?Q?xQyvd4pxb3YeWepHjaOU0qOnc+bvf5uKKs1Bxz8REgOu/USneah6m8phpBAt?=
 =?us-ascii?Q?rXEmqw9UhFxUi8rM0mCrv2IBP+mwyVJz55788IaZlCqLwlFGaZnvMnWhsy8B?=
 =?us-ascii?Q?2NJYo1WotS9RY7ikigIgKNuFxNT0sDSdpQgzUYy2gDdF1dNqUmISr8/QeXZZ?=
 =?us-ascii?Q?H2WFb6L5FiUk0m3TNO9IujXrL/6xcnzeO7k8EWuMEW19sSdflM1703chHzpA?=
 =?us-ascii?Q?zuTnKDQfSgae9GRpBiKz/EgOYIUZ48qzk3BQ3J+/YATQlIukc+RI6eflbHL/?=
 =?us-ascii?Q?isqE/88+F/BPOBk7s4DPik0/dwL9euWCE9I/AbLSKZoJcXdEcU3uf5jCNrNj?=
 =?us-ascii?Q?d79ZJ3xsCMweBFF7Z0sAPARswxQtt5jy+qwNRaoBv1cAm9wWRYyvBg4b03bp?=
 =?us-ascii?Q?cJKZ00AlklEwEm9dptTNanb+vq4P7HmkqxFJStE+SJXIsCGWq4Iszoh4cLK1?=
 =?us-ascii?Q?NALH38OHeQvn9A5lqbhZb3WDtpthekNNtQ0A8RWQdvsy3Xud5bO9xh6hTtxi?=
 =?us-ascii?Q?mGROcOM/qjlVn3cSTD6yWOLfXDR/AWGLZc1GWAsYSUkNhn8fxvK2hot+TsF0?=
 =?us-ascii?Q?amw86hM7XwpIUk57rseFmaxU8+uKSRmC1DphItvy5kgdxb0HtEhiL7TS9q/t?=
 =?us-ascii?Q?byDP8LIw+0EY9QHAAyP6fFj0DZmYVUEkQfE7Yrf3m++/EQVFd5aoW9ncxWtL?=
 =?us-ascii?Q?xEcGP6Twy3JMGCsBuo4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?NVFfwotN/yoP3Js6Gs1xOZ3MgmFS3SaInxjgAG1kefxPPh/vxzymwLDXKPVD?=
 =?us-ascii?Q?WdKysGY6uiluz7TI+FG8OcwFL7LZa6QgsN3+0m2rygH36B8AGjVXC2X7iRBb?=
 =?us-ascii?Q?yFB7/rdyU5qsXePlOaCc+2wEohxOF/OkselL3eUBt0xJb6eA+y1YPD+9f7NU?=
 =?us-ascii?Q?CfsCD4HUaSfzEztA8kvH+q8x1rQj/Hjis79YazqFpot/9cGbP6TKBF4Xm6dY?=
 =?us-ascii?Q?y6MFUdhJjYTSRCEFpVbcxKCTPO8d2r8ocEq6LrWHiWyaLF5PAaFnWKyD6bbZ?=
 =?us-ascii?Q?XhFhD/MvKKCDLdiRuusMW8LlU54yrDQtXixTe7bt/djcUwumUG90BlCjVRza?=
 =?us-ascii?Q?aZPYY0u9DKq0Hv5Yg9YIGA5ZzKExGmdp5fYLjO0zO0s3GfTg4E8Ly4fNpoW9?=
 =?us-ascii?Q?k1J11tnfjrgq4Wn1hTaPsHwGRu2lPo3nMsyqfKhKg7vbmh+v3UcOu+KIbBQm?=
 =?us-ascii?Q?BZTG4/ymAE2XPSatCuQvNO9M9QtR2b/F1hoyiu/3CpMj8k92xtwwem/kOTBk?=
 =?us-ascii?Q?uRweNc3wbwkt9i179g1zzMVjsK4/L0C0yqvo5y9DXHE5LFZkiFwEjQatzu9U?=
 =?us-ascii?Q?1LdUHLiVwUOOZ6ZrNMI/EwECShUcNJi8EH/e8H8q1EbqgybBnMGKqVb8qMz0?=
 =?us-ascii?Q?mGpy2x1w/JDL8ZstEdDh71nOVqNTpW2BzjuYi8oSkovvy3bkFM3Eo7/En9IJ?=
 =?us-ascii?Q?bMaPZuosNoktUh/t7k0OCWqOUZzk+xm3UPoImfsjv0ubJIZEQGZnN4/F3MEO?=
 =?us-ascii?Q?a65ftRS0d7TGT4QxdabeJyKJ8k5JK7ddWlsj6G6lk8Ohw+za1hxXZOWbMkTl?=
 =?us-ascii?Q?j6kX6O/7wE0Nv287w5lBJweGCcyaylfLEZqNQ3YFeQcpolRtomkLS92+9qT8?=
 =?us-ascii?Q?PqcVskRZ02vAGsvdlo0RmtDMBZd0oWceVJ5dxQ0dY0qeeJOv+jPiorzUCUSX?=
 =?us-ascii?Q?ld4EeNCdFKhQaM0lA5MV4Fpg0u/XxITp5ZabJpFaJPtWi9gGxz7QKr6Mi2Iu?=
 =?us-ascii?Q?rlNjFeFy4HOLQf+5u/YY91Z6LCjFZhb5TtlaIQ5tAhdadMzTt+X3vxSQR3LX?=
 =?us-ascii?Q?TG9gnhrsxaqcmFWzRJ1AHLj4JHLqZHDw9WtIe92qHm2VNq1Lr/gadIrs6UxH?=
 =?us-ascii?Q?NLsMvM2sTjEzmqs7tXd4hL0RqKlOOOPSNIipAfl5VuAyaTjrsRSCF7oSAR+A?=
 =?us-ascii?Q?0fOAoX2LqRRzL9rwNeNNK2hzqZ1mb3GwZ826jpIhBaySv9r7qCvoYuMqx8BR?=
 =?us-ascii?Q?ax5jzs2blE30fo2dE6aSyRLW83WUfgL/SaGSp67yqQY+LRW44C2Eg9JH6p+F?=
 =?us-ascii?Q?BZ6U5sTJ61BQKfNRD4DHWlHi/4nB8u6i0AUxwmAUXsivxEKbTnjh5tuMx1BV?=
 =?us-ascii?Q?nIl10tCokz9tPRSN/GRQy9l8WT/ALsUduatAsE32UxrR7ZLnMJ+dcVSYNNAP?=
 =?us-ascii?Q?y6Iz/ZrM7O/QNgPBdCBKR2QXIsYK1M+AJqlVfOdULCA3xZPktgDRt+gEiA6j?=
 =?us-ascii?Q?NeaxCI777A3CNuUSNL6FdT5YCKf3XewmsMeeJ5uIYj8JS7AkaUNQ0LaIuEmR?=
 =?us-ascii?Q?Iy/y/o5VAkQRRjqM+TlQ9LIO0F7B9do5ggBFPBMMrMpSfFgFi4MilzLRJFEF?=
 =?us-ascii?Q?+tJFmDO/N3E3QfuBPW5fAahoqL4Ic1WrQBsxRQwOOpkiA+qiJM4FDbWAIgiL?=
 =?us-ascii?Q?dHd6Uy/UF1qdLA5GtTJk34BBPGMABBJKzOgEofKfDpqvrMH6DyZdKb04H+PN?=
 =?us-ascii?Q?Dx517UVb8f/NuDJki/sRijLMh1cZ4ns=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	kCTtZ0jOGNRFbyIM1A4XCLFM09cfLALXkuurVwxu+klQ7IdSUKloGfldlfn/tDXZJKZohNF8jr3CMIUPb/e28I9mZujmJZIeGJh6SNPz9Pb2Ia0qTDEAx8GvBd9HyekLX3e68VBnqjSUG5A7OZx4nPaKj/dZTOh4U0Xhl9mlwZiNmEKv4ASE3vW5mJQBLviM//daw5Q03FkmcDpjoDPlEkbwdr/6dCibqlmaK0l5OCU9xlm7pECgXSDfGDQEpHpfN/pBBKHkeLliOh/7aAMj9u3VgVb2RoQvZLOaWQK1ih9Pj4Qiaf+muJR2C+W/oZrMAJAdTxkvEcTb7drLxD66OVgrjP+pdadPDcfae8WgYEeuAMU2dellvD0yu3vU9CJsTi7yB71t1Vc/xDvDozcuBZYuDselnEpc8F/9mQXluClUsHy3Zwsf94rmhyr2z4l2/l51b8Y7dPXicPlIMvFDo2YOaze0PhMCE4CgtMEpDuocxKu12CiPomoXfpzfrFgSB5tOztlNV2Pt6o9ON9KBO/uSeFxRer01aKV7291xhyTcL6bXjVwu/8f0v5OnPzHr8fhE+OO2oyvebb+IskK7U099YNotLVcy8LuXMPSLMiI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42067825-c761-4a41-ab8e-08de5430c665
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2026 12:22:39.7828
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y9K2qvJ47HEBvbxfEHhnKnH13/tZwmDtL8r1279I19nUpnsHiVbOzbyG8OIuqnCNV9cDwJt62mAxL0ImqwRIYtD9lnPn8UJt5Mr9TRAANqs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPFAEF42CAE1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-15_03,2026-01-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601150091
X-Proofpoint-GUID: MD12lT3b-SJjtLS27x7oDJ4Q-dKw-Baq
X-Proofpoint-ORIG-GUID: MD12lT3b-SJjtLS27x7oDJ4Q-dKw-Baq
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE1MDA5MSBTYWx0ZWRfX0mV5/0SSq5Sd
 4JK1aJZ8T3RmVfL10/X6EGd5pz7jqr4jQpxg2CFkrgOTta3WuenJD9/t93ZhQb1azW6F68mxYf9
 XaIbMDxvLcbgaKfs5mZHyVrJQs4CLAEcwLv62me7O/nHLb6UrJeRRs1KCYINna5x5fygeNxXVAQ
 1bUSn8jz3rGLxmURkkJY5HpZpwrGjGeD+K2eH5ai1waOg2Hh0z+AqzKYpMkceu5+0KnmE+GbfSq
 /kaUdmjlwiUMsmGOO9uqPCC2C/s61p+CF0h8GJQsK/MohNPad5CpxDXcQgaeGsxn4juYkwtu0OV
 Mgzf3FJ4VzB28yF2LIvUpuf8vgO0lbSA+EzDNlNhKyHk8b8ht2i9m/qNUri6E8tYycZDlQPC97c
 Ci46/fPU6qwQAjjVa1Vu/ZTRfjiL0ABAgwJnkbhb0D0c9WQym641hfmMO0oHbiiaS0oCZzIZX+D
 SijopFbc8Y3Qfk1OebA==
X-Authority-Analysis: v=2.4 cv=fIc0HJae c=1 sm=1 tr=0 ts=6968dc14 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=3kQC-zgHgdl5dC-dhjQA:9 a=CjuIK1q_8ugA:10
X-Rspam-User: 
X-Stat-Signature: kff7qazfmui7u6zcmjkwyast9kcesr7h
X-Rspamd-Queue-Id: 598C380009
X-Rspamd-Server: rspam04
X-HE-Tag: 1768479778-631612
X-HE-Meta: U2FsdGVkX19whE+kGZEwhNWQf6P027guF986tfj2idXfZ7o6bXP6adgqSqGF6g03t9LJXzmHKx7UGIkw9NJ8D9/WDM72hjC62LQlPpz4zbGdS/zWDGbG8xMpuW8s1f4aedlihOwSjk6vd6b2Ui087AHcusSc/ltQqWmhdCRUjl3I5O+TF2uapLjegEFdS3e3KFKWzW2rNs2jsB13WuDHrUEs8jZRkLtUW14buzyCOM6N0+8wzytLtEB3/Uh2ZMWj8ELvJ/SEJxXkDZWBbh2ySuTr0so04ObHwf/X/rGKFJkXUCf+P1FtGhz8FcEp6FaV0x/l0AT+Zo4qjvbsjEEqr2MKuN5H6KmavjnNkT6qM5FS1OBZ0IAMIpJSTPXSR8rl8YHLkcwOxt0rimIKfUPVbE4T/DCTZONT0rdRkuXcQZRl3JAk2R6RXoWJ86lTCBaC0EVm7YXt1Op7ELlRRQDl27+6hg9W+wsnQZeqQUtQ4DornQNGRPsqzcbwVH3GPeJ8sP5TXoV76IHcxVtxOtFPi3MJ/m9Kr0yBal3hf9D9fokmA1EQJc7g8uZfhBGzZfQR7OD6u+F/9/g+Vw6vCVg41T5sUohsNu+5aMC7OjLHZn2RAbfEGtkaoKA/Sq+HwUM8VYUBNrReWF3nXf8o2uECaP/BVLFPOFYwu4gDUtsWdJuPP/c/q6TLr97NJZmft8Mx+Lxe0KZ4rCHpQEOw899pRdSjOtj25/XI+MFFv5LEP3g4PnrGNk52ZsCpr2v8Mlekf1oEf3r8RNvi3lcWotB8otGCJJtcckr2iYYyJ0c7F0EfSmHYraXK7p7un+3sHwFOShAxnbjrnFINey6BfcKWz08yp7jECPJVfp+2Hta//CZXXbVIEv8AQPJ2aKar6ZM3VZgFWKvgYdmhHiG9oap0MKDW5KB4LyBCw1g4/XPL24NFPnEu74t18dRh62t3yTTsCjnaz5e0mMOtl6Qp8F2
 dTnFc3pm
 BjiwZqxjOJxwmbTyurjoNQgaDhmCR0XjEGO7UdHN8tcbU44wtawXkSFSNPzczjYkz39SUhDz4We2aEqOWc/ALCPtpIc8jgah49zV0AZ3eUAic4592yKv1Y+3YJuisylTD73+Q63hqP9JNKa4CJyJRxphU5sMB6opZDwVW30ghbKwOaAvb97QPIC/dec5DY1bQS60Q3lwVimyrwgfLDQ+o966aCtV+J4uh85usOazEe151GKvjbdgoLsNVNz2EFJxB3whLqNJJozksJPESxsdSYGsRwcCxh2lsj/0F4OjNYmMOTQAYXnAFka7GIrhsholqCTuqa6e5408e81qAHQI/PE+0idjjAuK0mZSmtBtXvH76RmbrLI35I2WEPAg4ROeKDHxKoY4P/UgVngsE0fJW7npdMkreG8rLSJjzTd72jgRUlbQN2ym0A0Wo3SB2zL9IhyJyvL5v7wjmYepEW+BFB0E342rRFsWsB7UEpVkSNyuJX9ZmpeYIUVHORfxmW/noZMwwsfulISBX/U+2rFWpglCbvVNR/rOo2s/UTMryR85vXuJBo9dmclrrpW5cw+qSupO6UzQV05OL3EfzBqo6YDS7QtRn3CcSbQE4SifPUEBvAwOYqYmHa2WZd4l9SBCoK0yMR0OkLQ6rBGWLhkMV8xbXzVdBhkykz24ud0cLuD7pM8D4kUourQytB33vlfXHV6IUHzsHbtNLQYDgPkKrNL+WLA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 15, 2026 at 10:19:59AM +0100, David Hildenbrand (Red Hat) wrote:
> There is no need to expose this anymore, so let's just make it static.
>
> Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>

Seems reasonable, so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  include/linux/balloon_compaction.h | 1 -
>  mm/balloon_compaction.c            | 2 +-
>  2 files changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/include/linux/balloon_compaction.h b/include/linux/balloon_compaction.h
> index ad594af6ed100..7db66c2c86cdc 100644
> --- a/include/linux/balloon_compaction.h
> +++ b/include/linux/balloon_compaction.h
> @@ -78,7 +78,6 @@ static inline void balloon_devinfo_init(struct balloon_dev_info *balloon)
>  }
>
>  #ifdef CONFIG_BALLOON_COMPACTION
> -extern const struct movable_operations balloon_mops;
>  /*
>   * balloon_page_device - get the b_dev_info descriptor for the balloon device
>   *			 that enqueues the given page.
> diff --git a/mm/balloon_compaction.c b/mm/balloon_compaction.c
> index 28ef0cb6b3bbc..c44e0b62203cc 100644
> --- a/mm/balloon_compaction.c
> +++ b/mm/balloon_compaction.c
> @@ -286,7 +286,7 @@ static int balloon_page_migrate(struct page *newpage, struct page *page,
>  	return 0;
>  }
>
> -const struct movable_operations balloon_mops = {
> +static const struct movable_operations balloon_mops = {
>  	.migrate_page = balloon_page_migrate,
>  	.isolate_page = balloon_page_isolate,
>  	.putback_page = balloon_page_putback,
> --
> 2.52.0
>

