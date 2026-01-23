Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D221D74EFA
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 16:16:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAF2C6B0509; Fri, 23 Jan 2026 11:16:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5BE06B050A; Fri, 23 Jan 2026 11:16:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0A936B050B; Fri, 23 Jan 2026 11:16:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8B0CB6B0509
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 11:16:06 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2879213A540
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 16:16:06 +0000 (UTC)
X-FDA: 84363730332.01.111260D
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf02.hostedemail.com (Postfix) with ESMTP id 033AE8000C
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 16:16:01 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=OXmJEdn6;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=PLMc8F9w;
	spf=pass (imf02.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769184962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qp9yJxr1/reERmJSlhtdgUldOvgDVVUm0CdJn/CtOJM=;
	b=R2AwnbPjI97Ni8sUgAkbJQid9dqRupskbW1t+AlndjbjfkfgnrAj23ALUrqer4Plnw1vrq
	dsfN6Fmsxv3ddj6YfBYHc+808/kKAqSiCxMom9tVkeYUZi2g6/YnFu3HBhUG6wPrhVghFq
	27uBC/GTI+C5VeZ6xCb1Dr6L0hr02XI=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=OXmJEdn6;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=PLMc8F9w;
	spf=pass (imf02.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769184962; a=rsa-sha256;
	cv=pass;
	b=d6NpwP3GhI9UNo/51waCix7VodVYki2daoc1qOxGEl5YCd+1a3P/oXHnHeGkjNnxtis410
	0Lx/XAD5kgOW5xA5qoZ+x5L1lf3sCToIiwVqjxjEp4vzYJX68P6aXQwHupyE9ngNV1AedV
	tZ6bfTC6X2YlaU+IbNrAekutJihVsaM=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60NFfWPs1631823;
	Fri, 23 Jan 2026 16:15:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Qp9yJxr1/reERmJSlh
	tdgUldOvgDVVUm0CdJn/CtOJM=; b=OXmJEdn6HFGoR4b467mBbc3rXBigGqH/KR
	fNzSz9Ttenqdnhh04flWmMKgtiA22TmUpu6KwaLggjMhSgjK1QfSurigWHtVCtyF
	jFwnbZXn3whjuVTfqkYyvF9d0Z4tBNgrGT/QKkMOurdVact0IwtziVYoD37vSoMs
	FbU9FpYIiH67cVzC6guSy5e20t5NJRRUKQw8j+A5P3CQmaR6gxL0mMNeBSnT3OYs
	moHVBzhVb65Hhwoi9N1dYPYvqKn9Jpej2GSzY1eJacU63pKnEtqIDUTPgxr0Y4Nz
	/ApkPuI2+tZZmHN7FHAZNyrJsevGpcoi/+6Pdql5XIbMXdn0iqnw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br2yq2je9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Jan 2026 16:15:49 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60NG8ThE024893;
	Fri, 23 Jan 2026 16:15:48 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010010.outbound.protection.outlook.com [52.101.61.10])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bujd1mk3c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Jan 2026 16:15:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pN8AUZ8QgQK0ju47CyuiGZP7KBFDHuufi557WUZftRNzHKCLgmoxIYb4R/dXREm7fVEZNLXu/F6FHF7UaMf/pJ6jLBsuvkZDZrGqhyXeSobF1vs2lQdO44OyeQTF5SMCSKKvT799gt9/q6hSD6Gck54SZv1Ak55hG1gnKt3FgTiY1QWPfsEvGQGdxcdKpf/cGJT2hB6zCF/I0QvIK3bjwJCxMiKJTQjEPOwPxqYSK5PG3dF84+acFf7MQ9oEwPEwYgRnKdxJXOZ+/mt3x1r3E1IL0S1l54+kxvSID8kmGmH2619ySGkrXpZ5iD5f+S2t7Bqb/+P4IDCInnRrqMS5jA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qp9yJxr1/reERmJSlhtdgUldOvgDVVUm0CdJn/CtOJM=;
 b=b+vhDzTGmeVilHn7QaY6MnftFK5S+CAN4TjDtlpAzwLFci0QF1rDEfudQ77ZMLTIxgEIwZ7UukU0robrLw69qmFBGLEipuwqYcc1PeGETVUVg0vywwdT2bQSGOnprtu5ZXhwXDt62+0TFgq2hIQBMspV4HG8tF3SZJbVtGGHKX8AKuh3pkk5TNbYmvBiJ4Jb0Yonwhrqu0T+znX4XUq5uWj8U8nnggFnJuolheCz8heFcLV30+y88tES7O8f+ru/kup3eWTnIDqmBRLgADglvJSC4SY/V8DZWkFV34+9q0eq8bANgXGKTkOjDYqnmT5l2HF1ox3UFUJMX8F4ElHjvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qp9yJxr1/reERmJSlhtdgUldOvgDVVUm0CdJn/CtOJM=;
 b=PLMc8F9wySbuHUsmgQHlJv3KL7XCDp5dYZ36k0wvebZd3ZrrGJkMjlvnw6XRz5DFjChtiJF7vH/Rpn33IUX0l8Y1ojfpoPeF42D6AWegwNjW/sNu6EN1qyxYxTWYzWEnBxJF1e0xJhU00ftkioJcZ8UgpatDb7/Ncwjt4K8jpxU=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by IA1PR10MB6145.namprd10.prod.outlook.com (2603:10b6:208:3ab::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Fri, 23 Jan
 2026 16:15:45 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Fri, 23 Jan 2026
 16:15:44 +0000
Date: Fri, 23 Jan 2026 16:15:47 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>,
        David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Michal Hocko <mhocko@suse.com>, Shakeel Butt <shakeel.butt@linux.dev>,
        Jann Horn <jannh@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Will Deacon <will@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
        Waiman Long <longman@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <clrkwllms@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v3 06/10] mm/vma: clean up __vma_enter/exit_locked()
Message-ID: <78a0c54e-6e8e-49c3-b2b2-e887c9f71ee0@lucifer.local>
References: <cover.1769086312.git.lorenzo.stoakes@oracle.com>
 <f1981963e3c9421b6ffef19f15d87953895cd0b5.1769086312.git.lorenzo.stoakes@oracle.com>
 <CAJuCfpFFW_tcHPMtryoVcSKigEGZxfn3Bz=8BUtrJj8kgEWDJA@mail.gmail.com>
 <20260122125529.1f4a1806fd918155e0a5824b@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260122125529.1f4a1806fd918155e0a5824b@linux-foundation.org>
X-ClientProxiedBy: LO4P123CA0311.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:197::10) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|IA1PR10MB6145:EE_
X-MS-Office365-Filtering-Correlation-Id: 0534ed37-cc94-448c-c2bb-08de5a9aa8fd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?JRabIOQlw9+ZJzNB+AlQRdP4b0KQnYT9HP0BnxQukmhIupImWwK8dMSvAPjn?=
 =?us-ascii?Q?coxiDnLQa0vZfY1OO27AmnI3ESaKV8JzygsTZbe+drBsLsDUOnah9DgvSZ83?=
 =?us-ascii?Q?pqd1Zlg9mkPTdPVEdwUhvJzM3zKqta0+VZJdNK8RVNWipNPna6yHii2gkJL7?=
 =?us-ascii?Q?Yzi82n8hS79/ynxv6QfChtX8RWRng4aPbMouvXUVWqYUeUv2n0FJ9uLCTZMy?=
 =?us-ascii?Q?tbNFaKfoKuM6WGO6V4ftmmxcwNbiQbu8YE5tuCUQ1ybK8DDivUb01IlAIgeT?=
 =?us-ascii?Q?tn5w2ML8sbYMTHiH19kJ6UKrXAF7BZRly46pO2cOG7ISdPT3uIesJs1gTV3w?=
 =?us-ascii?Q?bcCGIaMJfc9XgNKrJsB4NACCaDhhH3EnnFS6wUIGTnYev6bHafbt2fYUQPDJ?=
 =?us-ascii?Q?PW2xqMHtMYopKV3qTdGiuOfCNr+HuCpGR/Rz+GPu1Pzkyfv8qVVdIJCzJL8Z?=
 =?us-ascii?Q?q1kkQ4gjlM6+lqzTFdtCM4tyZdM2GvfNyn/7l24/qcoOeHLlZS4oDSkTCReA?=
 =?us-ascii?Q?bP0bTOujrsxvJGY65isoEKocj6+Uo9qhexvtURBaznAvMiIBaccW4KW6uTFG?=
 =?us-ascii?Q?UaBikJ3qlkKqLXBUS3blkp7cslAn5Z9RlEDJp9oZxkwkHXaumCJOOYI4MtSd?=
 =?us-ascii?Q?5trGmK6+bLaNskVDaZ97I75HWrqvhgZm1Ama/0w+PTwJ4M01JTmGFCkTnFRM?=
 =?us-ascii?Q?6d/uHp9ysrueM5KE90AmSm7nX6AyQAADw66WdCGe51EDI9xBSWCsKwwQyz6k?=
 =?us-ascii?Q?56DqxxQvm64V1NKOnRtzRA7smgrTTwV3ZmnXYie6Z68B8xb6zXalWGbW8yB/?=
 =?us-ascii?Q?PPWU+ElUWNyUyZpsmCSv6er9nFtlMzUdbW/yFwpevtAGRkGvwMEV1bdA0Ki0?=
 =?us-ascii?Q?s4w9hkDYet9GppH+ESPrAlBJD/ItBF9sX7FswYgoQonOlEt6o3ogDVcs5w1P?=
 =?us-ascii?Q?DTBzAzLm/DOfGogkac5l6CqlYNxwhwRZFm3LW8hZTk8ufi6C61EOo3atTin2?=
 =?us-ascii?Q?ar8mjSQKp+rqa+V+gDSBuQQ2nXXdROTVrNNiSllNVOJaxqwPxGFmUNoMrho9?=
 =?us-ascii?Q?Xod6JPf/cMurnlnbhCjo9HVXP5YDecAPBs2MqGYSq9Du7/hFsoqKrZHCjOvs?=
 =?us-ascii?Q?NUcDH5kBRXKjp4HnuYOGkhIjoT4k7sMv40QzAQ7bHsnu1sHv9Fuf1xzsdiqi?=
 =?us-ascii?Q?cnnL4JwWNhYP/xMdlZszeFvFFSMXgF4YOkvKTI6vYUCQyZ0oWk+eWCMjeOl4?=
 =?us-ascii?Q?qxIq8w04VZG5VWWiw8iEoztdI0KzmPTWJJTQq0qS/UWClvcyxKTQd3yRMluV?=
 =?us-ascii?Q?MsvfAJli1yRyWD9HrrMThDfJNj3ML5mjNXdbIfsuhiNk7reD/i7YQQMivyZ8?=
 =?us-ascii?Q?UrDL2hwWHokQav0/iFh8cRb6wxDudAQlaQzPQEvYjLyiqYnQ5GQXiHjVTE7I?=
 =?us-ascii?Q?iWJaMi1lCMBsM1K43XLGOfKffziEWdKStG5h+D4R9+TeEkBNsf1fF5kNN+tA?=
 =?us-ascii?Q?uKwMXLIfEYK7qjg239XlPRexNLT/8kz2s29EEAMebf20fY1RGj3sSTnmhJ+R?=
 =?us-ascii?Q?3xqDgLaHFTBBh1rTlOI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Ju9gE6QWGl+I7Qkz5OGo9vj+76jv6NOI/NToXoy5G4tGKIlI40Zo6RFimxOY?=
 =?us-ascii?Q?TMholKELrS5arKO8Ncm6XWu9PPA0gk2dO1DC67+xZSPGVVeJdQEhABecfcTB?=
 =?us-ascii?Q?FXGNBLDG9cPeLUcWPohonUkJ8mvhwtjyJ+fXLj0FneyPkROGFMOMocpksqLg?=
 =?us-ascii?Q?SjAzjepeXa9yiKuDrumWNzxJ812OwLRx2OnbN3Ttu5lgcHbP7tTPTq+PkmMs?=
 =?us-ascii?Q?be0gUHsbdlDcXLU1ahYTNq21sbzepb0dhruSEvf/KwmjeJg332e+Pq3SpWt0?=
 =?us-ascii?Q?FtLDbm7wghdt1iKnbRev3PnM77w3GftIoonJkudMj35JMMCjMEQyEi0vJ/Wd?=
 =?us-ascii?Q?e0/TDmQx8Xl4jbj+t4T+prsCv3li4HG1kCjg0k40KYxdWomjyG1fdxnCbW8p?=
 =?us-ascii?Q?tq8fLECSV/r9tW7LXUrf20uxoOzzvaX3CWaPmJL8ab+xpueQLAAMRe2RgOA0?=
 =?us-ascii?Q?At9R0NjML33dadtj5//obFWYgyAXWxv172Unb4OYQY0h5kxBHGOHSm2M4EWS?=
 =?us-ascii?Q?8a7XeOFbltM6euLLx6efpt4a0gub+32WNotmB+1x+2fKFhTVlEnDrC1KxCqk?=
 =?us-ascii?Q?bVjrWolJF/m92nVozc41VeVSauNJcQvU53XNm9zpy4MmZvSZcWkiSVwgMPdF?=
 =?us-ascii?Q?tvZ8QghP1/cG0vu8wHfKuvL9W5iPszDtZp9roQyeYDoh4Mjjd8/LSpHy5gPU?=
 =?us-ascii?Q?XYmD0BKw5ODyLaYueRgO6h2n1UWE6nOvxJBHDfxS/oxvEgcDKtpZKBHF9jBG?=
 =?us-ascii?Q?8guHIwAz+GQyl8iVWf87GElx81UkNSZGJNvzE4Q2HnCTaEkkge0tZbK2TqJx?=
 =?us-ascii?Q?DoebtamkPaNfVAv84IR7TUsK11/kVS3n4y7G3VLcgztvsrGOqVesSy8JfMYk?=
 =?us-ascii?Q?BfayqFIG9R7PgM3It3Ran5WxFS+5uTVF/ia0PSdqBfYtx37Jnbt7qMHn28Qx?=
 =?us-ascii?Q?afTSWt5i9lh/3GOVRil0cGso15KhwHCryfHJNcLtp/y6gXmidgW+kME8EbfP?=
 =?us-ascii?Q?MOyRydnCRDoqEq7DQbWZk5iF7UrMJQXh70wzaVEEGCZgiPxSgzARJ/UWP0iR?=
 =?us-ascii?Q?4J53r7KFkxrcH49lMrV9S81hd57BEvUdBf8eQD8n94PYhEHvxJrea0ZofAbu?=
 =?us-ascii?Q?qym4OtV3emRTW8lXhliG75NgOUQG0GXrxAOWl86PsNutE7O+x3S4n5pXwn4Z?=
 =?us-ascii?Q?APwXYD3DIYX9IeN/dH2Zm/3kc7994rVlJPn4n1Q6sKbqSF+sNn+hSKrDr5kz?=
 =?us-ascii?Q?EH47bnLTO3WtZ+ev+d3xRi50iPfCz6bB48yymCCQVeOMcqOeNYKrZNokGX37?=
 =?us-ascii?Q?H6vdVBmLm0u/EFvvbb/Jj+HRVmnUdmGyYdIvdXpphAJYImjA7L1nZ+eGj5h8?=
 =?us-ascii?Q?bJA7RkK+bP6xA2wXwub1GI8okppOARS6qjRBJk7FU0zJcLcaNHDqwKowY6U8?=
 =?us-ascii?Q?kBMumxDQtP1KqY95IKZJkwrCwfwK8TrRK7EMzbQeOvdjeSauhuR7c6GuXuKK?=
 =?us-ascii?Q?ZDdN2RIgn9Zwgplhz1oa5K5lSSQ5UgdKFaleppmfxSxBz9nJ0JfQ3j+vHFeo?=
 =?us-ascii?Q?7O/DtDj57xV8Umr3v52GZJtejGzgUvAbn6Z39mA8h4Tq5ZfG7YdPZNPkEvLo?=
 =?us-ascii?Q?U49piX2USQ+YkPBlAZmKFwOZnsKIoYRKiIDyfBeUTovW7Loidh4GabfbeZoY?=
 =?us-ascii?Q?xaDmX96M9+oDDciwXcLkP3gUK8o4N/VAFIlnE65JDMasdpQWWUBUuv7x+9Jg?=
 =?us-ascii?Q?YJbMjbg76Ic1T8PQzlsDxQ9gsfN3wXw=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	HkvhOs0dVYJUkE9eWpwGrDFXLEPUDoJNoM3CtApOLcO/Oglc97TEgZnI7sj5+8E1mt1Q52u/rbh2/ciDBzyBiS4pvTBbuic7SN1YJgWwY19/7rseW+V9BgEkVaNnDyICupdL/svlcoe0qGm32z6rmDXIpsCklrRkLBVAx7URhFdL1iYbcwsPptmyj1vjyajgktsjuAv2fiPWy0a5hLlceRfD8r3FPfBankTXrXLRNZyptmSYhb+i3QEN2x/Ka0LqSO5UrYN9MACgygB0/pOtpCBh4zvjGVCukaKrFtdGRu317YolrDtXuIfFXxmkcLuVYXg3+7Y+f+tL9NL/jf8GzplNs89811Hh2FcFFgeSlojU0Z8R28X90pp6K5aaxeREF9Nqj236brD5ZfFNq2Nj6INQOhIRgofTmz74ngQM2Yw79lRAZJpB7b/GhAUiNrp5sL4GDu38kA7OMAnEdkrKeOREpaDLJJKNRJbL5g2XSQT3SC2pU1bj/HiXE+m8qc50aoIfJO/+cjaut1+l0lroIMkIVDqkvJ6DVia3r1YVcwLY7Up5ctKu0739w6FgyH27H8Gj866zLhs4oOyTYfI2nYCJwui/yhhdjNQcSAqRtrk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0534ed37-cc94-448c-c2bb-08de5a9aa8fd
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2026 16:15:44.1028
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 51eFOouSQ+i8XKTFS66hcIJFxjrHTNoK6e0Y6kKGJAGfm1po/tldoGd5eaXt8spptQxe5vc4KFPbVx/e6PQ1Pb9/7d4RzU1DnVdYalobsRk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6145
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-23_02,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 suspectscore=0
 malwarescore=0 bulkscore=0 mlxscore=0 mlxlogscore=615 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601230123
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIzMDEyMyBTYWx0ZWRfX/y6+SC2Hy23g
 1RedMPONkrVmbJIC3XjRNRyaUkSyFU5EZHy7I6Ocsu9exfe/UWk7RJ69Iml4jEZ5MFBHKwJLtwf
 PsVD4M+VSseWDS0hAt43r9ZFEnWqHjVGQDIT6VbG3eNy78f9naozTsRwRQgAU6gShvgZzeOeiRd
 3iQykTzp4OELWQHY5yW4Uet9z2+3xkcq0mIzBSPJkiwqWn6GMZvdyKXnnkHxYw89aWQp2yEnESI
 63jjIyR+jDIb10vvQ97kKx9QMVl7vWcP1LiVhdK5NpTiSjv/2nDLnKN1Yo39rnk/UXHf15BabS6
 tRLJCsiqSOXgazaE2ZWNprJGe0/9Qwn73jyvWcRKEWrpD1GBfCIZ2qiyTzsaVcuXb33UaJ5wFk4
 43AemQhHRFbuBtSagPidsHqLJ3hnT+8tQH8PrYoOM+bStOyU+nZe1br6PgVY5+Ogt+LZIl4wxzo
 gseGDgUmM6tR2plT06USqrb3F0x55iAEW2nlR7ZA=
X-Authority-Analysis: v=2.4 cv=de6NHHXe c=1 sm=1 tr=0 ts=69739eb5 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=1XWaLZrsAAAA:8 a=yKp_zfkcNqtROI0eOGcA:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:12104
X-Proofpoint-ORIG-GUID: O2I5MTilSTcB24oh-5TxEWWq4FT2OTIh
X-Proofpoint-GUID: O2I5MTilSTcB24oh-5TxEWWq4FT2OTIh
X-Rspam-User: 
X-Rspamd-Queue-Id: 033AE8000C
X-Rspamd-Server: rspam07
X-Stat-Signature: h9bepx6g8imunfejtiti3pzejehxh6cp
X-HE-Tag: 1769184961-875624
X-HE-Meta: U2FsdGVkX19IalCzrlWxc7Ew5GWOTC2lCKv0r5c+72SG5PLHdyaSTO/z7uwyNlSdEaL0PPPQSacUSy5/DHh26Q8jEeZTrEaDr/cUOjWxhRSqwjcMhmHY8Clqlj8NZFx4S2oVGfWbzsDTBoD9siMYHXBMR+Ch5OOPBofbsYcb3R1JRP2+dexxA2h6MEh80OEPK/DatV5pwQ+HQmQ9GgmOrbW9D9nwEqHUPkQe/wx+Wi+yF9KhcbFzQk80mFFjf1jLr3HEdo3KfDiJtvoAc5enrHPZjv4NN+tH8T2Ir5AJ8dWVvxQbheRSpugDoAxbwYGGfD7L3OsuVTQ28nAWk4ZYcm7HIebLkrsOfZb2bMBkbyTfzlhmizbOGMniW5xY+ezzDTIbrMOznxlC8uNXGYhnbkZEH27QkXHuuYq5zm7ibW60xIzUEO4WDaEiey7qTlZRkKRncdITPqQfsgL+51v2NVyFPdIvenwy0BEYhHN0tPfDRKEQjFt0cjrNbPi52q3Gdif8g3uUmrn+SJzKMB3UMJ90XLigqPCzbMwyy6YblHb457qgPQUZk1TNtXrvPxNy8b8JiA+lNUTr7JxljCB2n1i8S0f4TIllXqnKGC2dJ5zJR0TShXzX5vqsKpKkqUOMv+cdpPFW3QDddRHFm80U02X3c8IyL2DVDicQiJBMIW2OUA8hWedi2efsbl9zQ5QM4xeBRCesLOpK5OvJdrLtLtYlnzNi+X9gR7WEy5sAl60Li+tgxF+SdUmEIz7nna01EZ8ZcGGkhvpZiyjHl48zxTos+ct9IS4kjWnBf9VoKIUtseZSMCHIpOjZOEjIqTRshxddz/g1Od0AMet1mVCa0tY+pJANpqIEzfsc0b5BdO6AtMH4y7kM2QFHl+RXSjk4DDESOMUGyTDYQNubkJQD0NIFtOFqKHIWmSA/ET7DGJFJl6xK15EYU8GoJ8DvfKqmVYnTdNve8FJ95qp1xXU
 nWM9N3do
 G0hUZGCPB/zVsS18HhkI6/ospgpDrJaLrM/cNnJuc0QITomZkz0Yqt7rVC3rIDBuMz2vXN0uedC3GpXRIo+2lYKr8ZWhhsUUaYpBDSjPbOyCzbVjOVdrW01aH6gJBRSUBvIcAFZSqrRuSqBMvSiMSfrDzdpkKfdfmg7V7A036lMnEylM7MTE8d6HaPM8p/b12RreTvJKqT6AKGU2jiINxDtbdBAYhdxXzJdeUx7cAGJl1t7z+PSzip+kqsOVZrbh98KO/CucZGJrlBK3JjyPzaxhEuCJHXWN01YxbnfvrhuVL0rTcjZjUmsM0X1RBYnwXjRYR8Hact8TE1eh7fDjNleQxoIfKxskK/8QTqaTvREgvemp1Xlpg6Em+VFY5KwywZh3ntXhowgnewBLPoWveTWRjpSuv6mlvmtVgL6HXoZIgi+sAGK+sKybWHjzxO/P4JDCXOTRT2P0UyLgKmxdG9uvzDLzbl1oOz4nRRLUh7gDZmKWTOaq2J+/ZwwurO0wM2TA70bsbnjm8/MDOjUMlbzzUhMXCyjnJvZOQ22t2HnK74FaeSorSH29nryLiOshmhAoeHWX7spDCyjC3+wAHKOyyxhTmBnuhhsGbq0BhNq6huFozX6q9gFHbcr0YTP2f0Yw+Gi6KyYCmW1U+hzn275dvG/LKcHCyZHczmw00VVs7bNyydbVJcmdLyAngy3LFuDPD3/ieOyR74R1p6h4iJeQDV6ddv5hks56UCz4VIQZoBpT7zn2oh8/Qvs1Z4OhtDlLx2q/bvdkmpO4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 22, 2026 at 12:55:29PM -0800, Andrew Morton wrote:
> On Thu, 22 Jan 2026 12:15:20 -0800 Suren Baghdasaryan <surenb@google.com> wrote:
>
> > > +       /* vma should remain attached. */
> > > +       if (locked)
> > > +               WARN_ON_ONCE(__vma_exit_exclusive_locked(vma));
> >
> > I'm wary of calling functions from WARN_ON_ONCE() statements. If
> > someone decides to replace WARN_ON_ONCE() with VM_WARN_ON_ONCE(), the
> > call will disappear when CONFIG_DEBUG_VM=n. Maybe I'm being paranoid
> > but it's because I have been bitten by that before...
>
> Yes please.  The elision is desirable if the function has no side-effects, but
> __vma_exit_exclusive_locked() changes stuff.

Ack will update in this case :)

>
> Someone(tm) should check for this.  A pathetically partial grep turns
> up plenty of things:
>
> mm/slab_common.c:	if (head && !WARN_ON_ONCE(!poll_state_synchronize_rcu_full(&head_gp_snap)))
> mm/slab_common.c:	if (!WARN_ON_ONCE(!poll_state_synchronize_rcu_full(&bnode->gp_snap))) {
> mm/page-writeback.c:		WARN_ON_ONCE(atomic_long_add_return(delta,
> mm/page_isolation.c:		WARN_ON_ONCE(!pageblock_unisolate_and_move_free_pages(zone, page));
> mm/page_alloc.c:	VM_WARN_ONCE(get_pageblock_isolate(page),
> mm/numa_memblks.c:	WARN_ON(memblock_clear_hotplug(0, max_addr));
> mm/numa_memblks.c:	WARN_ON(memblock_set_node(0, max_addr, &memblock.memory, NUMA_NO_NODE));
> mm/numa_memblks.c:	WARN_ON(memblock_set_node(0, max_addr, &memblock.reserved,
> mm/zsmalloc.c:		WARN_ON(!zpdesc_trylock(zpdesc));
>

*Adds to todo*

Cheers, Lorenzo

