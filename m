Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C81AC44506
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 18:52:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA8526B00B0; Wed, 21 Jan 2026 13:52:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B68CE6B00B3; Wed, 21 Jan 2026 13:52:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A16E66B00B4; Wed, 21 Jan 2026 13:52:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8C92D6B00B0
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 13:52:51 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 228F78CDA9
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 18:52:51 +0000 (UTC)
X-FDA: 84356867742.16.A3B04B2
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7A2A640009
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 18:52:47 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=V9dA8tei;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Yiw59oLc;
	spf=pass (imf17.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769021567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6/cgBEbEUGwvI/ENT9C63msM/f8MCbO4yHwLd6KoO4E=;
	b=UkaLmBXQIVVryNovLzvUJTTkrrTVH6qurUflhBgrHynbwoLEF+szvxqc+LcwSL+xtuWL8G
	CZMDCKfdLYo/gp5zKrGpDbZ34YMqvXfPJ1fPJ427Mt6oEAb1cmtUKct2APTPwZ43kFYYH/
	J8zgU3n7NBydEQVIRHkYFvU/AyfXUq8=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=V9dA8tei;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Yiw59oLc;
	spf=pass (imf17.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769021567; a=rsa-sha256;
	cv=pass;
	b=6HaQvv5qPmzG6zhQ49fipNtbxdwQS+dzb5TfZPjzP3wB8/LHQOoJfMfxFN/uBUXoU6UBfQ
	VGKzD7DH1McIDQ9huijUtLiiXGo+2eluTJwXPbsWnL/pemYPvdVQ1QlzilsFOg/pGehSh7
	qQzVECIU/2wtf8fQwXYSEz+VCqCHVcA=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60LEKeeh3265014;
	Wed, 21 Jan 2026 18:52:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=6/cgBEbEUGwvI/ENT9
	C63msM/f8MCbO4yHwLd6KoO4E=; b=V9dA8teigof6G2TiOKfFOIKaVkeeKujnsv
	Pnr1/lKlIzrMdt1uWhv5MxPwnWRsRLDFO8dIq5vy8EirW9nQzQ7C4quSGEAgVycK
	1e30PMgGMXPn1Aeh+wdjz2pO2UVOjv3Is23Pv77RlgXqZsWWlad6Xiy9n3NUgotE
	6LLufUA5dO6I3aKNVdCtwrOJp88HbFySLFrZ0RiFp3FFlmc/cXCNFNSlJ4hKNath
	n1EBVwy3HIVJ+pS5MhY8vvSh/Z/kkqvL/GowWV/SeChreTiSUbzCTYvnUzcna8m6
	7UdBQqS23OFbbcVfjhqw1Vmiwl8rDBmTn6UoTBEBKnSD4EP9q/CA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br1b8efby-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 18:52:28 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60LHjTBQ015756;
	Wed, 21 Jan 2026 18:52:28 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011071.outbound.protection.outlook.com [40.107.208.71])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vbp6xu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 18:52:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u9oKZVN4ztZ+s6nVzk4Rv9LzU8A7QoAzg8XwRVCzuNAFHyUJqMS47mHRz09aAlOg0LeNqQLWmSLsZnZmNDUteuNdoa+FXNuDpEfomIgvNH5ISXViebY67w572SLfO/nWTO3KrBQ4NWdlFAJHjHzR1kmmMxvNL0gg1E7EkZsTgHYntVdfGlblttYE06NVn42ytTBKhcismzmeMSP1g2PJSCHcHox58hEYrQmaTAkXm2VjD1Byowk383VAC/V7VuTPzePllUbwCfAjkZk0ZKUr6cyn32VxvIGbQ1Da1A3RaKfRilWpL0gVEh4aKgT+yp7/CgOt8GZfddWaJX1w9RMLzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6/cgBEbEUGwvI/ENT9C63msM/f8MCbO4yHwLd6KoO4E=;
 b=tJvyMHyLNXIBjBhXGEyiI4Sn/VciZB7Bon5HqD0Vonw2UtVRAXbpIzec0vdV7XDW09DG67FgvMt0NSRfjfFt2koeKC255VH6Ghnpo5n51x92vLySGbUVIvYRiDWAsxhzAU8Xvsb+X2Rqqeptcrad+fqGkiEVSFpnqn4AVCR1c6fa0PnurCUvUWUncegu4VSUWy683fCmqitbEXKstYR0og+SE8/IuzAFuKBH2u+On0vGjHOeXhfm2j7P/8axsKQMO7UR3DflYM6JRCbSgE2J8qdiRBGnTV8pGWrbQMUt7Ve48Ll4oL296DT/PtArL7moQBcQmcKi6OIJHnzWw1JadA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6/cgBEbEUGwvI/ENT9C63msM/f8MCbO4yHwLd6KoO4E=;
 b=Yiw59oLcGKOdMnukbVYZh2KEN145v2xOaxVW3XGLiyE5iPinx4q+pqZs3/Q/aiRXCicm1rru+uqMIFfds5872slsIsFYWYQND4EUVd44+UG9oLSozixYumCkuxbexv13iYxGuIwU0K3SEYUOXC1arBU4FhNN9mYF9DovZMLCesw=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by SA1PR10MB6518.namprd10.prod.outlook.com (2603:10b6:806:2b4::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Wed, 21 Jan
 2026 18:52:25 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9542.008; Wed, 21 Jan 2026
 18:52:24 +0000
Date: Wed, 21 Jan 2026 13:52:21 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Pedro Falcato <pfalcato@suse.de>, David Hildenbrand <david@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, shikemeng@huaweicloud.com,
        kasong@tencent.com, nphamcs@gmail.com, bhe@redhat.com,
        baohua@kernel.org, chrisl@kernel.org,
        Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v3 01/11] mm: Relocate the page table ceiling and floor
 definitions
Message-ID: <2gkqk263l6iedpudwsvnspumseugbz5g4qbqzkrworqm3ch7mz@idsaxf2c5xpf>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	SeongJae Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@redhat.com>, Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>, 
	Jann Horn <jannh@google.com>, shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com, 
	bhe@redhat.com, baohua@kernel.org, chrisl@kernel.org, 
	Matthew Wilcox <willy@infradead.org>
References: <20260121164946.2093480-2-Liam.Howlett@oracle.com>
 <20260121172618.39532-1-sj@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260121172618.39532-1-sj@kernel.org>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: YT4PR01CA0491.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10c::28) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|SA1PR10MB6518:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ae054ba-a3a5-419d-a402-08de591e3754
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?DDd7W4jvJisf0iW4bfYK6fQw80d0Q17a+iPShPa/DSg5ukxsm23J7JA/Opeh?=
 =?us-ascii?Q?o7gN4ksXffYVrS+tU96wqDwsDVdjayCDePwJhsJsuJGY8TOFLN1xz5aW+PNF?=
 =?us-ascii?Q?aDK3NZ3PLBLwpLmfBc7OJrnKjd8oMMFBktpeDNxvWVV9H4LNSrIJ5j4A3zGJ?=
 =?us-ascii?Q?WHwJRu4FRw1ZhHT2WmiLigPvbfIyUKx0ZJiHY438aqT66E13EVvHNsiwnrTh?=
 =?us-ascii?Q?BaioXeg/HAOfiLgeNpguG9X1cD8clWs6ZMxE9FdZKUfQHsVjMxCQHKdVp0jI?=
 =?us-ascii?Q?EZryvIrH20dU6hqWmI2+Z3n8H/RGG4KD0q9PbhyHhf/g8/+3yMz+G5Af13lm?=
 =?us-ascii?Q?tn8JOts3iJoEsiPrhdPj296WqqdsP5Z/+Ut3IYxn07oNPbVirT2swiOe27WB?=
 =?us-ascii?Q?a6E50SjO0jWK2zYcX6FwJjk/HAmZIcfNep2J/CU+6nzDI1mh5KkGRw9gMnSz?=
 =?us-ascii?Q?L/lsWfi06cmkDtnz76xwnACEBHiCIQFr2TQD5x8Pb5DzeDGQSVqmiQVrOdj3?=
 =?us-ascii?Q?zqpuEotl/5BrDBB/LOs+x1uinZaUPfcKWewbSHYZP8txrwnlDHvGyPy2S5JB?=
 =?us-ascii?Q?lvG7Lrpf6al1S10WqOfLDSD1+3PpOpIwnUoIbscfmHSgzn0SKU3DASmAbh55?=
 =?us-ascii?Q?aJfmGUxD1DWOmFlogYl4hGn8UJ/SFV173VKmP5V77y+oM09duc/mPas+WEa9?=
 =?us-ascii?Q?zLYlm+2+R2dot7VMH/LpqJ2OL+QDr1mfOCZ1hDmUtGNZvKInRgLlHcHz9rLo?=
 =?us-ascii?Q?rp25AbeoO/jeSJZiVCra/iUkRT+lBAuEg4ltReoo+UOYfPHKYLiNZNT4uYIY?=
 =?us-ascii?Q?vGlvd5sgoFH54RUS4SrDBEq6/fadWua4fFO6J0R2KtZ8uMBwTTKI2DQ2PICm?=
 =?us-ascii?Q?JvmlEQBYcZJhPXsZk78ecIEKISRIjjFF81aoLdsxKt/eQ0aqdpPASuZ5Qb1J?=
 =?us-ascii?Q?+3KTkM6jZzvydFuoGC2pOE/okkauuc9mlbjM/JtUmsnQLCtfUWnWG0uapVO6?=
 =?us-ascii?Q?Ct/xCfpRk1Zs+yh/g5dYAmX/HItPivewUjGd/SFREKQunsPELTxcWTelCm1p?=
 =?us-ascii?Q?XyqY0INLs0BVj89FaI453UwGCsi0DhHpx+WOcYTcgjZvUo4dtQbdEMijb76T?=
 =?us-ascii?Q?R8OvF8USzy9LiC1JjhgXMPFkTARPF29de8YTqC0EhuejRQj0shruqVecKXf6?=
 =?us-ascii?Q?UZ2kVx48CJwaKFaYWomcec0Ug6bYPULRnvV0YVMjI7TGiAD+UKuLNVqcH4iE?=
 =?us-ascii?Q?ypNzyjibVaaxSELko9zxdmYfHBVxCXiP4kT5GE2IHQJfp0OndW1mKs0OdVoc?=
 =?us-ascii?Q?J4OlPFnhNTkyyh/D8AZPp1+SJiQX6Gkf9pdtHp+OggTuxYa/es2eJiGKUfBS?=
 =?us-ascii?Q?ALEQfW+CwRWWfkkIcB5ejvL6kWxM5r21a7JrYAX7nJhpl+s1FFcYKJbSBIn4?=
 =?us-ascii?Q?DfJaU4mndCdSEebf3di26USKRFX6CrpzaiEs8ocjY2qFQJ8rT9zYjGSL2bZk?=
 =?us-ascii?Q?wwo8GohHijumrbJC0WwRWUM69seBfs0hoxurjcxC2ldOtJLSmf8czy73uTuC?=
 =?us-ascii?Q?Z5PCCbBX83RsuX7Hdn0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8fc7QHSqtQkzXtOcTkBuFMhTCmofDLWcAtZv/p0qy7aVc8OxAGPsaXqdaJsr?=
 =?us-ascii?Q?/BHK22p27rfk3IjxSkLIW0JQM79rs7+9YlYi8FU+r6cuuHjWck2oluEvpJAp?=
 =?us-ascii?Q?RP9ONNDNH1zIMIesFGk6hOaWRmJFxzA6B2QoCPqErGHKHjKMZuflqKqeIAxb?=
 =?us-ascii?Q?2miT93OslpZYQAlfYQ6Za3B7wn1cnBbojgewvvipNT76nKzXcJqOsE6yNrSw?=
 =?us-ascii?Q?6hF7GDZXVTSnPLa7dluu506a0ZcoRvWNdgbgbkif7527q+sOWeTvYh4848ec?=
 =?us-ascii?Q?JnARf8bzwC8N2Qh+WrAgSqlA5Dw88Jvu2g33+A+I4MiE4AjRaLzwD+miNcdb?=
 =?us-ascii?Q?F0X6SZiECpqLeSZHPAh69vNMFl6P5Ij9vzMn63/ZqqMHKwYY5HWAu3s3uH15?=
 =?us-ascii?Q?1l+BI1mHDb+OXyv73oIKGnacLpGJQhDtdb9Ks8oQCFnKhiYH43TLvePW1lVW?=
 =?us-ascii?Q?pK1vJQeH8eqw1G05FNr26vRKF7BXs4IHkPaqANbGAnCJxej0xJ9qCUSI47Zf?=
 =?us-ascii?Q?RJwRorK7XwOhSf/T6U2clGCB0M0gr7LuC+3XaVmsSD/bjs5WffqMv2qbKfaj?=
 =?us-ascii?Q?8NGp/q9u5mLmSi6U4j0M/IM+p8KaBCcqnQtM1WDrEBoMCqNMJjGXaq3zhtjr?=
 =?us-ascii?Q?UoYAH7sKxsWFG0mZy1ExVC/p5/e3G5XyM7eEKq/pC4ufMIKJ4S8G1TmE7P9H?=
 =?us-ascii?Q?YVCpwkdvrSfeE8+tuy6cjh5Mla5N6xJ55blaHNaD18YjY1IuHF0rgDo3PqxA?=
 =?us-ascii?Q?txEBXc5h6nLdFtZEaJWYm/i1yPcrmYs0zbnZabePudoCIhwACVrTUaJNq91y?=
 =?us-ascii?Q?g9q5Ohhmw2CPajdPAwFhIsOYUGxptzFo9m3cIuP5nFK9DhN0FInXakjXwRuK?=
 =?us-ascii?Q?gmKPlJN5F8uruqBUjFRhUDNrWP5kB0rpPJyHFkjbjKDojnsnvALKfjQtaZSv?=
 =?us-ascii?Q?Z+E7nsvRkoP56zjfoyQ2ETKRPF7Q5AKL+TbAffw3Ofeh29MSgiliEd3V07GT?=
 =?us-ascii?Q?Qu578H4pFAKelE4rTBXwJ2kq4+dH0u1TzPXbeP7AfjNqy9Z/xNZSRUR/SHYt?=
 =?us-ascii?Q?W+Ct0m5NtDZloI/MTyQb0YVyxyUNq3Hdyr/nsy0GYM2Xndkdh8iHWt0XWwIr?=
 =?us-ascii?Q?FJ/8rs2fry7CTWd+WrVv90esns47j9bS2rVtw6XAe2PyOdJTUplL+dohMNjO?=
 =?us-ascii?Q?nwWlamApMvEUNmXoprDKUJlLOZbhQ4uLk2IDYj5VeKl61iNydVKCp35uA9Td?=
 =?us-ascii?Q?POuY1CqyRUUeou8kcWwFKChgYxJMIgWblprbPgnaxYb3HyQyNemoW8Bb8WOM?=
 =?us-ascii?Q?J5tNFvNXgkjASt2G6YafmsATbuiTi6XGTB6ogA1nqrZCpWRiN39otmVJHUJD?=
 =?us-ascii?Q?XjhjO0zhkANRBjbzFDgjno9WoJT0WBxch0Bsdstrg7C/gGWxZKsKA+ly+cpJ?=
 =?us-ascii?Q?uhWDmx/72t6xKPtfzk278zHdV0It2YXV0NPWqxz2h64d35gW7BlWDfNO2ReV?=
 =?us-ascii?Q?IEqA6if616TKIz5VaBCGGc9/mzwiQu+REH/LuZ6KPXbEMZmX4jthnvSwmTgi?=
 =?us-ascii?Q?a6cxrvnn15D4e7IgA6yjvLLU4wZoEsE+bSWVvB61+VoMyY4Yn9fSWY2NbZ2e?=
 =?us-ascii?Q?LavFYWX2sZDTeuw0AaisoDfg0naZEUB72QFPhvabqo8ctUV66vWc9hxi91me?=
 =?us-ascii?Q?tNa4XLpDoX2rQ8vDghhBiY9ku9pfSnx9LJm0FSmE8FgYYyP+tec4qlasG1Rv?=
 =?us-ascii?Q?W3K55du+ww=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	mUHEZBUN188ERs6kMsKfJcJwWAylH+WmwBe2y/wwS24oFF1zuBdxDOvB5jXkkTqe/onAskTvyi/mJ9OAF/7FgA2hjegrcz+0JQnAtCW9gHnjO19BbZQT8rL45i9DtcQTC6FJcVUuWd7BwleDoeSZQaI7mnXXsoTMl64l7PHmp8THDA31Mi+7gJKFb28IbejK8JW2t8lYGM74WUOOl1Dtm/siZfBQmVTRGq4cMYNJof2XdoZfy3zuZteqJlJa5u/7Cza8rHqRXmJRODp0iUG1KW+U0oLb3mQN2bQiLAoHwSZ5Hfd9mOE1sfFzqd9CQDLGAUY/iP/l2fAAjwwRsO0FzY7elCLZ3oNFfLJJKq451wlPcRmgGaJMxOWyMM7GnzA7HP4ne5DZJGdKaPlyLnb0d5U/0Vtnur/WIpVSXY0Q3urDA7mNhe+ynKoBnxz8V8ftjCtwQKcImh5PPvVccKiIFncjsJaov9whhCDbs24IJGUD1SlApZfXjQhgOTUgHKxxue5s8olmN3VS43PInSS24DTjIlk1g4m1Rx4OhqrZwKZ5Sg6qeN+k2FPzKgKpbVwMkQ9w9FhP8JWMjpPg9r7iJScW7isSedGjql9SQIIEaYk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ae054ba-a3a5-419d-a402-08de591e3754
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 18:52:24.7392
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aJnFh7ixrONqeUg5+afZKgOuYOS2ojKR+9M+GkPoG6zw0EocyIU8pR3o/l8CbT1Vp4urlOaNlpTIKUrY8k+SVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6518
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-21_03,2026-01-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 adultscore=0
 phishscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601210157
X-Authority-Analysis: v=2.4 cv=WbcBqkhX c=1 sm=1 tr=0 ts=6971206c cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=tjSufP2J2ur6p9p-CWYA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIxMDE1NyBTYWx0ZWRfX5On41BVIGTmv
 vcO5thkOSIoA5IO2AJMrAkbjhgUQk9SsK9+KorefGQV8992ssxbtEQn5litVVlu2JSwWVlwuwDG
 g4sAnWYCgwf+I7DKt0rNe5zIrbB+3cNO3P9UEuL9JBwlazLJpnxoRBH8rBXB4nIYe0X39zgnDpo
 ApQMx9rFcaB6W5gqdSLco89M+3yg1wH8ilFGoMJf4gm56f2b7GWDXOGXtmJ/dOAc1QVP2qCsr3J
 tMr30L97mZ6a+yJ4qccC4I6gvN2Qgqu4dCu/5FbR2dnZe3qsokZ9yCbA2OgPWHsDyV1IppCvOSf
 KiIcwCsgW+4/eGQrYvEnUvlXsZPqUBL8rrp1GTyamNBQQOepgk55A6fI6ulWmAWTcexI2k9Cfkn
 K/07YRGnotFnigob/n6TDwayh7bX8Y83aan0pg+uBIWwB0V8Uugrwt8ZZqIFk/uRtkV4Vgu8MEA
 Wbmo9gozKWDn0IS0jNQ==
X-Proofpoint-ORIG-GUID: CSZwKG2YiQRo6AFx1v_JgK1nCQ1FG5iV
X-Proofpoint-GUID: CSZwKG2YiQRo6AFx1v_JgK1nCQ1FG5iV
X-Stat-Signature: fwdh7mywwhn31ohabfue86cqei9zntdb
X-Rspamd-Queue-Id: 7A2A640009
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769021567-884260
X-HE-Meta: U2FsdGVkX196MiT1CL0FS5XAgpfwFA3/mF2L+MtG5rMClAKBVbDpKC8JQHLahmju9MpWYiSL2Gyvo5BcI6GyYfX3k7KJxeVtyBARdziqtShOQ3ChTNHUUP9Jv7NdoDrn/0Jvf9EPbS3IUn1YQcW6zRUja88a/ecYYELVyJ54ui6HRE8NH5Rp6bU+6PSRaqMOymyCiXt4sfemmpKHezGG6xRaTxws1Sv1yPdD0VHtrqzuGo8Tjlwo5f8lXbBEbqQ5I2aM//9b3V9Y7ZO9oQGG5QSuDBzM0OpLjRf4zuLdji7k0+aQEgttYv9EF+T4c0liQXGmwM66lJvi5MUgqYyhgIhvH5dGBy0WLSC8o/4MdvmSg/pcGSjt05wvXhNnJSBOo6M0NgRHc4clZVTW3DGQpop5f9TElvgocAaCQU05ugoFHi4KII0Usw2TpUzx3wjGvZysUUfjGr3BfdJTiFFtmYK+M0J82QfuWohy/Vfje/ap61VqVIfEvkuxnI7wrEpHPFbrO8myt47pFSpCqUMSbo7z399paWS4zRYjnf9ScgHoHOCZrvzqzUvH4BT26XaUuyO6affs19EqCnd5KjD60IkoINmUjM9x3kEcOro86DIogbw13p8fzWPhs+yujPBH0v+4XDO/DqvHs1yKop6hRM3PXdbC59iBOslazHXFEwULA6PU/MkOeuub/DzSZ10YvWdb3wKJeWFslE0scVZ5RdHOKYGPfZW89EBuMbeBHxeKthwNCYRMp3GsauzsxoMYz+HvTJUFOM+1YbAvol/OwB+iGCocbThwF/nqkvBy9E3ttdK/abgqP0qmeNSDEKe+ZbFGqKGOEmFiNLkveQWkFR9SMDZRPaeP0xzLxHvbFmqKOh8wYqfBQxTXkL6s9jnRx4diT4odmPyqnnIFqBgS+3LtNszWuQ1alaAoZgafN1YBDb3Gi9+aiJv9UT1yMFxyGxZEt1MC95MdM4Leytm
 Ysi5Ikjg
 hF7aCWAixNPhHV/nOnHHfO+tWQ7wnrwfcS1k8/Wp+vyI0RCQaE/TGBCHghTNs374pXlcw0FjEC8aXj+MAB2vlLCFo8GMq9p2G9m7GnOXDW5FewtbVJN1Tw7qz8fitqXL+1nJUhu7l8c0p/ptNdYJNaDvbE9iCKNI5i2VgxMsyPjFZklpQsRv4FRpNMDMJJH9gm01mAT8EpIvKS/MLnIy0Q1nqCMkauwcKD8Wk43tecOI/K2P80Gp0wvffBvT/A3GFIeoqjKGXzE7R0oAIh5kY6ImmliDKi/Enhiay8SJFgujcQkEvBCbG6lPwZ0mpqwMGhhIuiZnibGmPSQEMH57vqpMsDCafl8+Mv1ooQYvQrTpcoIn8begIMPW5NOkw7SDhuhx+VWPXUhRTptopITFhe5Mm6ymFs1vABnUb1gGTFfMjPi8VlfnruX9+EmpBiMDoChvYnQz+s0s6neWNRKsqQrERma0pgY0UepUg+zJ94nDpC16+XYLEb3wrmIYDmvEV/KbPWd2RNwJ0chOR47wSxKSTK3hO4aHm+3KFzxynU181AIYLEmWTchKLDOu1hvxEsnf5YhQixNLgdDgDh7o6G6J7Sf/GQ6qDHqqupW63x5F5pK3FFovZoFAWx8iy0lkhK044VmCM40Hq3YA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* SeongJae Park <sj@kernel.org> [260121 12:26]:
> On Wed, 21 Jan 2026 11:49:36 -0500 "Liam R. Howlett" <Liam.Howlett@oracle.com> wrote:
> 
> > pgtables.h defines a fallback for ceiling and floor of the page tables
> > within the CONFIG_MMU section.  Moving the definitions to outside the
> > CONFIG_MMU Allows for using them in generic code.
> > 
> > Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > Suggested-by: SeongJae Park <sj@kernel.org>
> > Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> > ---
> >  include/linux/pgtable.h | 39 ++++++++++++++++++++-------------------
> >  mm/vma_internal.h       |  1 +
> >  2 files changed, 21 insertions(+), 19 deletions(-)
> > 
> > diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> > index eb8aacba3698d..557ac918bdca6 100644
> > --- a/include/linux/pgtable.h
> > +++ b/include/linux/pgtable.h
> > @@ -22,25 +22,6 @@
> >  #error CONFIG_PGTABLE_LEVELS is not consistent with __PAGETABLE_{P4D,PUD,PMD}_FOLDED
> >  #endif
> >  
> > -/*
> > - * On almost all architectures and configurations, 0 can be used as the
> > - * upper ceiling to free_pgtables(): on many architectures it has the same
> > - * effect as using TASK_SIZE.  However, there is one configuration which
> > - * must impose a more careful limit, to avoid freeing kernel pgtables.
> > - */
> > -#ifndef USER_PGTABLES_CEILING
> > -#define USER_PGTABLES_CEILING	0UL
> > -#endif
> > -
> > -/*
> > - * This defines the first usable user address. Platforms
> > - * can override its value with custom FIRST_USER_ADDRESS
> > - * defined in their respective <asm/pgtable.h>.
> > - */
> > -#ifndef FIRST_USER_ADDRESS
> > -#define FIRST_USER_ADDRESS	0UL
> > -#endif
> > -
> >  /*
> >   * This defines the generic helper for accessing PMD page
> >   * table page. Although platforms can still override this
> > @@ -1660,6 +1641,26 @@ void arch_sync_kernel_mappings(unsigned long start, unsigned long end);
> >  
> >  #endif /* CONFIG_MMU */
> >  
> > +/*
> > + * On almost all architectures and configurations, 0 can be used as the
> > + * upper ceiling to free_pgtables(): on many architectures it has the same
> > + * effect as using TASK_SIZE.  However, there is one configuration which
> > + * must impose a more careful limit, to avoid freeing kernel pgtables.
> > + */
> > +#ifndef USER_PGTABLES_CEILING
> > +#define USER_PGTABLES_CEILING	0UL
> > +#endif
> > +
> > +/*
> > + * This defines the first usable user address. Platforms
> > + * can override its value with custom FIRST_USER_ADDRESS
> > + * defined in their respective <asm/pgtable.h>.
> > + */
> > +#ifndef FIRST_USER_ADDRESS
> > +#define FIRST_USER_ADDRESS	0UL
> > +#endif
> 
> Looks good to me :)

I had it at the start of the file but realised your change was more in
line with what the file already did.

> 
> > +
> > +
> 
> Nit.  I think just one new line here should be ok?

Agreed, Thanks.

Andrew, can you remove this extra line?

> 
> >  /*
> >   * No-op macros that just return the current protection value. Defined here
> >   * because these macros can be used even if CONFIG_MMU is not defined.
> > diff --git a/mm/vma_internal.h b/mm/vma_internal.h
> > index 2f05735ff190c..2da6d224c1a85 100644
> > --- a/mm/vma_internal.h
> > +++ b/mm/vma_internal.h
> > @@ -46,6 +46,7 @@
> >  #include <linux/swap.h>
> >  #include <linux/uprobes.h>
> >  #include <linux/userfaultfd_k.h>
> > +#include <linux/pgtable.h>
> 
> I think this might be better to be done together with the following change that
> starts using the ceiling and floor from generic code, or mention this change in
> the description together?
> 
> Above comments are for only trivial things that I don't really mind.  Please
> feel free to proceed as you want.

I was also debating this, but the impact should be virtually unnoticed -
it's included in most cases anyways, so arm32 and m68k would have the
extra define.  Tracing the reason will have the cover letter in the
change log as well.

If anyone feels strongly, I can respin this in a few days again.

Thanks again,
Liam


