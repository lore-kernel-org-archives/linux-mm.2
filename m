Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65BC0CCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 17:08:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C940F80189; Tue, 28 Oct 2025 13:08:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C44A78013F; Tue, 28 Oct 2025 13:08:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A979280189; Tue, 28 Oct 2025 13:08:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 913118013F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 13:08:34 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 61166881CD
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 17:08:34 +0000 (UTC)
X-FDA: 84048156948.09.89D6908
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf28.hostedemail.com (Postfix) with ESMTP id 007F2C000B
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 17:08:30 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="BXMR/e1y";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=n6DpIGdl;
	spf=pass (imf28.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761671311;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rV2Jxn1ohtJdYj058mudr7w0KezLXdv45s1pumsKccM=;
	b=zeZZQHaHk3JeQ/G3SVkHPvbIyVg5DX7VrMFiq/fqDkathGPX8aMLqhbTZ2uUOcOgsV9DSs
	9QCRbiRxosfRy5pa65xAiO4TmA/LakOFO10ihRA1x49h+fjippzVSaPExbSHTQK6aGhrpF
	WG1Ce6Rzi+9ZY3T1sUh/tQZfqJ/YVlo=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="BXMR/e1y";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=n6DpIGdl;
	spf=pass (imf28.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761671311; a=rsa-sha256;
	cv=pass;
	b=qp2CCYU9qRDR8x29e04Ls5ZA0kbEy7KtW0HYLeEqQl92ZsTBAGxrpA/Hgd5WYX00b+tK16
	xhHhZjsJP0lJXgufLy3zkyomTBcHEHxfDNULyxsFijRlOu0OcXQndx8dneeZRHXgXVICof
	dPkRJi8bXhLBekZcd06Nw5ynZhEAuuA=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59SBDXYE019344;
	Tue, 28 Oct 2025 17:08:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=rV2Jxn1ohtJdYj058m
	udr7w0KezLXdv45s1pumsKccM=; b=BXMR/e1yi4Ppola/+nwYvgrEMgCRX8AV9o
	FbgQi1gb1bC8ddVIRteFrvY9K+8EzwaUUgRPFSt00zWiUmOJ1YV3IMjQEMaJSn7C
	YtNxDq3IzwVCIvniq6CeswrgI+mhSx48PDmjGJJD20L8W+jwgxyUQ0ZDzjQDaqff
	SNlZJv6OhEMl0P8dBrZ2COis25ItZ9S8r4XCFcIqDCBNXd9GCYz72dMXF8b9ramW
	C4zIMphoVdwSgpgROHFOZylXKjFhG+BmxSxn61VBBdhsb8t+9+m5AYoge0QME1gN
	IAfoH9NLbrdILIJJU50ihVQOwSO8j0W28bMPgKOZIvEBuvKIplEg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a22uwm30j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Oct 2025 17:08:08 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59SFhEOa034865;
	Tue, 28 Oct 2025 17:08:08 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011006.outbound.protection.outlook.com [52.101.52.6])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a19pfvv5j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Oct 2025 17:08:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zJYek5PRrWgV+iZJesP2nV/Vbu0o5C8elRAxugIPdzYkZyhcrB65jQDCjk6kFbpeuCM7vbfOHfz0EN9ZrD/DxVkRiNdUaLGgcaK0y7RuCW7e5T+W90S33KYESQ3vyd5AAOvZ2FdkcE+XNGK9xA7Vif6aIIPa/TVH0i7g1OIsIqzkg8Zr5dwp/mbXccBQC3tcax1grK9COXBdAs/bw28cP50W10EaumbJo50YjQXI+JA04aPoT8k/TtzpubWmnKOpc37+TTGrJ09IHY+8UqSdiJD4xBBoTYMkZNZ55YqdNUD17NAH7/t8gf6J7UjDPVC7g1++DWJldjNT0muscfaPKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rV2Jxn1ohtJdYj058mudr7w0KezLXdv45s1pumsKccM=;
 b=k4quKpRvLDkZ9bqmh1AvdkK+FhMUBaL9SpQAh9jSc+Rx9uniTiUxs2ZHtNqorav0GIirtJfa3sSnTBs5WBt9EPxsA2NaapFAlS3Q3/Uxwj6sWVDmpNu89+KPhb0AUOJETPFOQLehNdkOHWGKIcItTPCPvxZNZZtdHUyZFodgPD6tU6Czga/ZcVVtYbS+suPsHbaGTWVHKeXwe0YutLy/8j2Fu0HNm+Dj58rvbn2xfdVVcDcPC9O+7vb/5PcSlEEHjochSVJpX89D4AeYaD2D2+g0MGNQWqnuL3Tz0DDXhSvLHxPfDT6Uh6mwdv6U58DKz/Rz1Re8bIqShXV/uAxSSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rV2Jxn1ohtJdYj058mudr7w0KezLXdv45s1pumsKccM=;
 b=n6DpIGdlWPbaFb5vhFs0VXHWVxnJmwOSLZRS5ie8SM+fVZN4WdnNY1pZlawI5XMm+C0bfebeyWAz5kVtjPdIfGvhIKTuEJxK++Ih8LoJ2M/lBQG6vTDz1jfueGqcBtYD24a2at7TqETM8pZvpbN0ihDQMYUulAFywEWnqabpJMw=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by IA3PR10MB8640.namprd10.prod.outlook.com (2603:10b6:208:583::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.18; Tue, 28 Oct
 2025 17:08:02 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9253.018; Tue, 28 Oct 2025
 17:08:01 +0000
Date: Tue, 28 Oct 2025 17:07:58 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Nico Pache <npache@redhat.com>, linux-kernel@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-doc@vger.kernel.org, david@redhat.com, ziy@nvidia.com,
        Liam.Howlett@oracle.com, ryan.roberts@arm.com, dev.jain@arm.com,
        corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org,
        mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
        baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
        wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
        sunnanyong@huawei.com, vishal.moola@gmail.com,
        thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
        kas@kernel.org, aarcange@redhat.com, raquini@redhat.com,
        anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de,
        will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz,
        cl@gentwo.org, jglisse@google.com, surenb@google.com,
        zokeefe@google.com, hannes@cmpxchg.org, rientjes@google.com,
        mhocko@suse.com, rdunlap@infradead.org, hughd@google.com,
        richard.weiyang@gmail.com, lance.yang@linux.dev, vbabka@suse.cz,
        rppt@kernel.org, jannh@google.com, pfalcato@suse.de
Subject: Re: [PATCH v12 mm-new 06/15] khugepaged: introduce
 collapse_max_ptes_none helper function
Message-ID: <9a3f2d8d-abd1-488c-8550-21cd12efff3e@lucifer.local>
References: <20251022183717.70829-1-npache@redhat.com>
 <20251022183717.70829-7-npache@redhat.com>
 <5f8c69c1-d07b-4957-b671-b37fccf729f1@lucifer.local>
 <063f8369-96c7-4345-ab28-7265ed7214cb@linux.alibaba.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <063f8369-96c7-4345-ab28-7265ed7214cb@linux.alibaba.com>
X-ClientProxiedBy: LO6P265CA0008.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:339::18) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|IA3PR10MB8640:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c128cfd-e02c-45e9-b429-08de16448ccd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Rp6AQ798QHjbVHylSKqwZKv+c7yJlKVPDxLaA+O8k266uyErxUCGb/yvriQ5?=
 =?us-ascii?Q?00qmEHmJ8vuIuOl0gSzXk/QurosMv8UPO8hpjkMbQ9zHASW0D1j+pE0HvTNx?=
 =?us-ascii?Q?oj8NDZRXLdvVqR3xbdeQMrg+S6Pr9IEpCDXL8R3upA96JZPIrgnWjKrsYc0N?=
 =?us-ascii?Q?I8FRiYp0JiMo0IlUbKH5kDWVLPhezFQo56/ljvDwCaNDKqE09KwEjC45e02s?=
 =?us-ascii?Q?CcEBXWIcUqusX1EQp8IZtzGc+lYbX8oJORm7Nrd0kjZH0AW1CK0feAbMeZq4?=
 =?us-ascii?Q?UdzwMScJF22p27N5ds8hxW9PaSA7lkI5ycGsr67LgX1YgIptXV5lFhqo0e8L?=
 =?us-ascii?Q?+cYuQ1rQKnc1AMG7HNPnxJQF8EzD4T8j05CjedS0Eg7bDtua9GB1ZnxqVBMo?=
 =?us-ascii?Q?F/ctOnK+N5j/IiRrT3/j8U2Hedi6el4lo4SnZEKCDmdr0W1JziZm7mbLm1AE?=
 =?us-ascii?Q?2aNmHi00ZUbjWhKz+2JVxFwoKb9XkQBcFEKmXfvwBU+hcYjJnWAH87UoXS3q?=
 =?us-ascii?Q?olsf401Iu2b6dLa9w8Ixnqy5pj1j7KpmYG64SnZhM2dGqGUKmzK4VY/9zDlE?=
 =?us-ascii?Q?qFNaZsdsQb0lpeR/WLsaTJ0fFhArpqkYb3TgetStRUJiKXrgXqoFKFmAV/Tt?=
 =?us-ascii?Q?gj7Df095MXXBGqJZPjelkUhlKZZpp78TU9/k+19NME0/AlfBGHFfKlyhlf2j?=
 =?us-ascii?Q?RQiil7dfXq/vZPZ3W6YJUae+IBTBVbzLhly6gn43xZlGrXr5TPsQT307s1pe?=
 =?us-ascii?Q?JEcVyePFuITjDoXZNCCb5uafGnJnbXCAj7AXgTUtnmDuIPrYv0+nkozgpIvE?=
 =?us-ascii?Q?keyZopRABhiZFq5mN/pXZQX/JzYWgRd6wqf2/vbSqvUeXKLsO3+48X1if3v0?=
 =?us-ascii?Q?BHjlGENSPagmilW+coikT8sopI0hvnwABf+kCAVHjgxrZLaUClkTicCzu9xi?=
 =?us-ascii?Q?jh14cebkR3+scz2yb2v81EJ8cNRfD36nsDkVJDL/08uBclLXjJhPcMBf3Icc?=
 =?us-ascii?Q?i3E2dQTmvijtWBwllcvC18orArUIfe4X3uesZjdPVqLN3gKmiu/XKwfsckJ0?=
 =?us-ascii?Q?Nx72Y7rqwow7DJprb/13cCDDxvZ7bcIikcTS5uYwv8pCXaQ9R/J1tnuy1WVw?=
 =?us-ascii?Q?QbLk+2eb7Cf20Y/Hb6vnhcCWFpezxEDmupVApvkKcOdW28HAWxeV+Tr0e5t4?=
 =?us-ascii?Q?Sl2zgEKrJsoE26yKqrhJbcTehNau1fnHXddo+la/3oq2UORrxapragXfwQHI?=
 =?us-ascii?Q?EH/MEqN8LSRjwgDdEFofAzY6nkFhyPxX6EHlViYnSl/H14J314VshbDU/M9G?=
 =?us-ascii?Q?PEx+dfdAxpAOK8ABTfcDmmPIT05MNWvN/WqugugNvRVlyKlhnT049dWkYHrb?=
 =?us-ascii?Q?2f/BxbYbaNXmhA2tZqRHyEk4w/KjD6bxCiwSgdxh+5ZcWJHrLK74c0bj/BtA?=
 =?us-ascii?Q?ne15TrTUPSHCb8Me2UM3sZmqJr/XiNXU?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RUaBN3aNnX1CtWXWimHemPMUVnVD1WKIKKLqmVsFsBHfQ3qipU6JiMnPmS5f?=
 =?us-ascii?Q?mpQb7uI63ptd/J8Ac6pYLpE8Zxgr20kBZyOku5KmTQ101V1YF0DFxM63nvn7?=
 =?us-ascii?Q?iMIGsAvzceo7GENJOsK0tOM+4QmkpPem/es94eWkNZO28WHRekpKPgqfaDMD?=
 =?us-ascii?Q?M0TZGFyTL4BmEJ9v4s6mKvcIZOxzVAyC5yb98CYqUnRKiIACj+gw0+DT+9lh?=
 =?us-ascii?Q?LzDQM8bDu/pPxsycmbHjCHmG9RcNNG2eGUYGOULFkZFdk2sFDj6Yb4BixCY8?=
 =?us-ascii?Q?81Wvfzu6VJDuFARBiRVdqnobFz6Y9McoJEpiR6elBHONJhNTMy4AgAVoJf31?=
 =?us-ascii?Q?CUQhaWmfEEHyhjYVPdbGF7TxaEHE++UGCLUuEHn26zntkjXi30jKnOubBEMz?=
 =?us-ascii?Q?x9LedPiNNBKMNnJdTaQS1AjBDQM/1ZJOWktcHcckLP6Mie4GP1Ve+ZNRSFWv?=
 =?us-ascii?Q?Z2kiT+nGsyfz6XfUg1WgIMlgqhaKEiv243eK1bbsN6heQUx0DypNGKuGtfOi?=
 =?us-ascii?Q?jo4VRYC5Qw8ABSf3UOOMBmdDa1uV7V2G++qq+0hZICgVtLSLlNHdJXa7k4jC?=
 =?us-ascii?Q?nM4Y8wi+s9xf3D67G4+rdrbN8iJNNw8igUgvr23kVRki9ju9Zpqv8LO33zr2?=
 =?us-ascii?Q?LB1ZhdTBw0Imv3GTZzP3MhkVQlmLdp8xeSL235bYRL0SEszNchxa9D5udQnw?=
 =?us-ascii?Q?Z+5ensuPd44jUNBocZqYygCz4BXAFxAqg3iKyr+fMfHXZy1YX7iU3YXdOGhH?=
 =?us-ascii?Q?JkC1coV1sUMW0U4TxUFs4rMJXRCMMMkg87kfss4hDCZFrUDCKWZk2APvUHeg?=
 =?us-ascii?Q?rwKrQtaiPL8X0PEe5cWqgygcCF6UPCgxwFqYr+TNexMqG05hAjqFIVsnxl12?=
 =?us-ascii?Q?S8I8ZKFa0jYko4q3ax/N54MVKUz3IBmd5yMekASdNYdL1zVfPSNfG0nFb+So?=
 =?us-ascii?Q?vQ7g6XS13ysLHV5F5tCQb9XuOEfDQOMmfm8H3FzRpOgjQyNsdl8w2pjBRx8y?=
 =?us-ascii?Q?7eA05aNmJW+tb2MRmQpWobDrJp4qzBwkufDgEGKUMI0tMdUF7SJYMbXHw6yb?=
 =?us-ascii?Q?gqaBoqQL4RpFdv1FSuS9gzstm89HOzQFttbqTmNNkoNWcZSY+2cO7goxakqZ?=
 =?us-ascii?Q?OM1d+kLbQ8mjX6nAaX63SBZou3Xzw/m0jQe1JcffOP/0rIqz0U2cqvw2KxGJ?=
 =?us-ascii?Q?FeiN0Dc2NQvbCWYtIKWvxuQmJprzMouAia3UhHlenp9V8Q6n4Ne7A8Jtjygl?=
 =?us-ascii?Q?d0heU3QNEczs67+oaUqrF4QD4jM0W2g144UJHQzib3BlRG3KfrFOHvDYItUL?=
 =?us-ascii?Q?MrLr1aNOTdvItNLEJlNcn5zjdKX3QyQTfhldM4paO+7LGEye/oeszfC737F7?=
 =?us-ascii?Q?Q3+aRQAbV9sb23/j0u26oGJ8BRhXwEwBfSB1vJzaAitPn3ah+mOGUrgrEaTm?=
 =?us-ascii?Q?sdo9U0SzoSznaVRZfrHkHzeUVfmfom/SvP6m2t77qGLwH9S1wa16Vtfi8WIo?=
 =?us-ascii?Q?t/EsbgzyRrlwuVoIds/n2IjcfAoYGFizFucQ41jpayJZJS1LDepZ99YlJs0/?=
 =?us-ascii?Q?f0C0xY+NvlwQTRmfcOWbEdtinQiAtf8LHgUv8Kb12rDqKYIxezC/a+S6qTTj?=
 =?us-ascii?Q?Lg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	LN8vvrAMpOuaI+Xw3S16/9Bal1z1fXuIhPvOKQPTDKW19EIHelq65H1PPOvAHRre+9RlVocEivrW/EYMxtbIECKdEGLAQH3J49qgiQWHoToflQ2F7L3Gke3i8832k1d4NDDR4PfOqSFkyFsUwYBrYGIYHNKqn6Bl98vKsoOHxSVAcj+X6yFtrBpG0abYNdHdwdr+BCT08mxjKHybKckoRfIoVc94dci29tTUgQrl9NmLoJN2gbgxjbARbQyFNa95iDfQ63M+qIXFuxdmXCAsAz9msxHD0hPz2yM6J3micWskZ6sFtR86AE1IN453JwpK6LxoVWHjH9adw4QJDmlNtC6CfqGK4fR92R7Me+v7WKV/p+hQpe15W06EaFsb0KRsQvLIT/YZhR6gSyWMzsHKNlgK1XnAtKWnS8/HXpMH7BzLb/iPzXD4CWT4pbuyvN9bK0vlRqUGHgHo5XjVZCX2GFLys5u0OuEBCvrtZ9hgAIXca0FtDUcg8RrhVK8R3U7HCqFXZudyxVJvllIAHY+1RoI+ZfRICZfCTOEEU2xH5fzQj6BG+InfheDSDtJn1Bz09PacCWU3Gkw7PqwRouf5sk6B+0WkFXzrcHPIoLJ/8b4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c128cfd-e02c-45e9-b429-08de16448ccd
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2025 17:08:01.0638
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9sMHza5Rqy+b8+gXAUnDV96RUmp6FrPXVL4q6pGhZn10ZJJKIQJ8XIRX4gbNmlkixSthxMN0vRy4HOz6CZ/2Y/GUJeHvajxbZBPlkvmMBdM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8640
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-28_06,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=999 suspectscore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510280145
X-Proofpoint-GUID: V1qVx-SHiA9UPQGeZJNCcaXXPPKKNWwm
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI3MDA1MSBTYWx0ZWRfX4XagA/XIodda
 Yjl3oWenSnxmMTfxRX9Hz7prdammnl9ZisZ23MvhXroOA63HF8aFuEyTIUxCOrVbcnVZJELwZbQ
 MAxfw0u9tZ0b7ocqHWfGG/cGwWGBqjkpOb5kX+GLvFuYlUEmEhlo82IGwqJNUGRufEL6y68KnmK
 qQFyAVjYlA59ZC1hA4ciTVNCuLZPDkyXYepN5gkS1UXrsbhDNuaAvjXkTXXfIOJQUPBQzWne9K7
 QkYYpPl4m7/5ptJs+B2qyAdXKc9qaVdUZabsL31HtKJKY5lUohMEJeznDi/3jRiZ948/6lWHTRJ
 DSbBIFWWyAZx0MhKBGLA8yUmHU27c6FGRSePgeqkmN91s0Dfec2mLBKHXVubFivdfsQlWhVxFz3
 8LPemVQnKrz/hv+a/MrywMkcsgj/e0nx4k7m5Jw8lbSFbtl3EjU=
X-Proofpoint-ORIG-GUID: V1qVx-SHiA9UPQGeZJNCcaXXPPKKNWwm
X-Authority-Analysis: v=2.4 cv=Ae683nXG c=1 sm=1 tr=0 ts=6900f878 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=20KFwNOVAAAA:8 a=zYfY9bxTfZ9WV4dr0c4A:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:12124
X-Rspamd-Queue-Id: 007F2C000B
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: q44m3kc975pz73bbzzq478tk3xxewpho
X-HE-Tag: 1761671310-815237
X-HE-Meta: U2FsdGVkX1+qPZNS5Hq6iF6DbYBc/4l6lgRWcdd+fbr+HlMoiTNqsShI+w+9QzaBYbKchOr33NJAylnNY7PUGHeeaZe/fyjBiGNPi/N2cgnidgMsWADVhXdJkp9N7a/un6Wt1XFc2FNh8JKUEzOB+9JdurmLa93w9oEvScO+0GqbGVZEjeo/zetr50HB2HxuaLDK8E+dH4qcC608nrQNge+yfAv4yvjqIZt7hKYeCq2BvGRWhu/rWoM23LkPgqj3y3spq+zMhcw8K59Rw7jLUPK748n79sVa4kfG36gejL1dniFyLMBMzr+8XsycIRs9kbbSEHurqEEVOVHmcYzryjv7YJOD0KFgx8azmcidHxiydEEiuVWJ7J4MJVh9E++kjZjn7FuyZYlzoMPc17+mTsLpMheAn9G9CGpRRECBbBayuneCbBEmSoi/JeduOsifdi3Go98GgYQAYGzYMF0S52S7OoPWejZzFR67UbqyA37JaiDvn4XJo5b9ebLJpO45CEAlfPVL4mngcy9GYwTeWG3poDGA36vCq+BmHC8Q91yFbziDAxpuntNU+iSJcP0UkZ77FwyW+6yM9doHcbyNGgzeTi8BF17lCaH9S8S2woESY6iF3++q7ma8lakyovjbQJjwRQxa2dkfbZGuLXBio1ZpVSO9ZKoM1GDX0nrBKGtIWDtfU+gXK3WdtQAtrwE/R8QakJlmL6jt1AHBeoP2fEYuVDjGsnq7JPR5+sr6idAziCCkI983yQsoRTYB91j5J3SU0++1bHduIPTtLuCD8HmNln5qWgitERW6QtKo2/XKc/oOeTcCudxVD/h5m0dDs1FQu/KL+AkMkVqr5psbRubuVrr4QJ7CMt0ibpE8FZXRu+7HTRD1PLMrUSC5bDghnZBDUVzkyyzETbjBqnMdlpIVL0R1/Q7/cv9fTNKufwj3+5xq+iHh1dJCjfmhPwyi8KdfrLqC7Fx6dn1YmLt
 ZhW9YomS
 gLwswRiiLtyFQrv2zWCfGnxO6lJzSCnHcAeqsoNp7Mw0basPI2iwuB1rbR9VLYpOVl4/iTZMxGDuOGDOWxsEU8Rv65hkrznooGqhSoCEXupvwhIoXaICceoU2MWs7rso284poVON1jHpxjQlmmmIv+zKTFkxjpmh8zY9jSRHJdPCp+1d1ZkSdEZkwMrD9YEzYHPDy080LcMl9qQK8nGfBLcElqRCEpz2zl01fpxiiOqGZrWkJzUlt1tOYbwJ4xhQkWIYXDDqH2SE/YEe/nmosXv8XmQ/XQ0c915KPin8CtlvrPr1/FkKfY75A8gvQlpuo2FPhWPpXhZem2NN2Yti2N0IfLEKTDTSzX/Sk50n5+TIijU+cN1CzlCuFPRzCFbPUkC/PqPtBP4qX7SoPvXxvDPgSQRcOGgt1OFh/OUbE4jHBnQOgimdt0ZrHg/66mVfzXmQOcm/+9nP9JEioWmeahwpBA1xtmWJo74iVvwq0IXUJP0Gd5lROeJclExLAwMXtX1nRXeQShr7LqjkdaiMRDStIrxfU6E+tKq2Z194msrRLsN4IxqKpYUpZptyQ/td9EteQgS/mox3w/LuPNSgvjNZgXkutLzt0Bt3xyS+zbS5psj2PJ7r9QRW2qh+zvlxXoIaB4Ih9JWavZXJVBGfL1I7TYY4OwQnpzndlLKkCNV2lBzmkGQZTykHgV9N4OowsSuz+JNvF66qUxxktPhSrXq7csXWb2sv5i4PvRicLlqaO7RrhO8ml4EDMHdkdbjdc9DGk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 28, 2025 at 06:09:43PM +0800, Baolin Wang wrote:
>
>
> On 2025/10/28 01:53, Lorenzo Stoakes wrote:
> > On Wed, Oct 22, 2025 at 12:37:08PM -0600, Nico Pache wrote:
> > > The current mechanism for determining mTHP collapse scales the
> > > khugepaged_max_ptes_none value based on the target order. This
> > > introduces an undesirable feedback loop, or "creep", when max_ptes_none
> > > is set to a value greater than HPAGE_PMD_NR / 2.
> > >
> > > With this configuration, a successful collapse to order N will populate
> > > enough pages to satisfy the collapse condition on order N+1 on the next
> > > scan. This leads to unnecessary work and memory churn.
> > >
> > > To fix this issue introduce a helper function that caps the max_ptes_none
> > > to HPAGE_PMD_NR / 2 - 1 (255 on 4k page size). The function also scales
> > > the max_ptes_none number by the (PMD_ORDER - target collapse order).
> > >
> > > The limits can be ignored by passing full_scan=true, this is useful for
> > > madvise_collapse (which ignores limits), or in the case of
> > > collapse_scan_pmd(), allows the full PMD to be scanned when mTHP
> > > collapse is available.
> > >
> > > Signed-off-by: Nico Pache <npache@redhat.com>
> > > ---
> > >   mm/khugepaged.c | 35 ++++++++++++++++++++++++++++++++++-
> > >   1 file changed, 34 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > > index 4ccebf5dda97..286c3a7afdee 100644
> > > --- a/mm/khugepaged.c
> > > +++ b/mm/khugepaged.c
> > > @@ -459,6 +459,39 @@ void __khugepaged_enter(struct mm_struct *mm)
> > >   		wake_up_interruptible(&khugepaged_wait);
> > >   }
> > >
> > > +/**
> > > + * collapse_max_ptes_none - Calculate maximum allowed empty PTEs for collapse
> > > + * @order: The folio order being collapsed to
> > > + * @full_scan: Whether this is a full scan (ignore limits)
> > > + *
> > > + * For madvise-triggered collapses (full_scan=true), all limits are bypassed
> > > + * and allow up to HPAGE_PMD_NR - 1 empty PTEs.
> > > + *
> > > + * For PMD-sized collapses (order == HPAGE_PMD_ORDER), use the configured
> > > + * khugepaged_max_ptes_none value.
> > > + *
> > > + * For mTHP collapses, scale down the max_ptes_none proportionally to the folio
> > > + * order, but caps it at HPAGE_PMD_NR/2-1 to prevent a collapse feedback loop.
> > > + *
> > > + * Return: Maximum number of empty PTEs allowed for the collapse operation
> > > + */
> > > +static unsigned int collapse_max_ptes_none(unsigned int order, bool full_scan)
> > > +{
> > > +	unsigned int max_ptes_none;
> > > +
> > > +	/* ignore max_ptes_none limits */
> > > +	if (full_scan)
> > > +		return HPAGE_PMD_NR - 1;
> > > +
> > > +	if (order == HPAGE_PMD_ORDER)
> > > +		return khugepaged_max_ptes_none;
> > > +
> > > +	max_ptes_none = min(khugepaged_max_ptes_none, HPAGE_PMD_NR/2 - 1);
> >
> > I mean not to beat a dead horse re: v11 commentary, but I thought we were going
> > to implement David's idea re: the new 'eagerness' tunable, and again we're now just
> > implementing the capping at HPAGE_PMD_NR/2 - 1 thing again?
> >
> > I'm still really quite uncomfortable with us silently capping this value.
> >
> > If we're putting forward theoretical ideas that are to be later built upon, this
> > series should be an RFC.
> >
> > But if we really intend to silently ignore user input the problem is that then
> > becomes established uAPI.
> >
> > I think it's _sensible_ to avoid this mTHP escalation problem, but the issue is
> > visibility I think.
> >
> > I think people are going to find it odd that you set it to something, but then
> > get something else.
> >
> > As an alternative we could have a new sysfs field:
> >
> > /sys/kernel/mm/transparent_hugepage/khugepaged/max_mthp_ptes_none
> >
> > That shows the cap clearly.
> >
> > In fact, it could be read-only... and just expose it to the user. That reduces
> > complexity.
> >
> > We can then bring in eagerness later and have the same situation of
> > max_ptes_none being a parameter that exists (plus this additional read-only
> > parameter).
>
> We all know that ultimately using David's suggestion to add the 'eagerness'
> tunable parameter is the best approach, but for now, we need an initial
> version to support mTHP collapse (as we've already discussed extensively
> here:)).
>
> I don't like the idea of adding another and potentially confusing
> 'max_mthp_ptes_none' interface, which might make it more difficult to
> accommodate the 'eagerness' parameter in the future.

See my reply to Nico, I disagree that it affects eagerness.

>
> If Nico's current proposal still doesn't satisfy everyone, I personally lean

It's not upstreamable. We cannot silently violate user expectation or silently
change behaviour like this.

> towards David's earlier simplified approach:
> 	max_ptes_none == 511 -> collapse mTHP always
> 	max_ptes_none != 511 -> collapse mTHP only if all PTEs are non-none/zero

Pretty sure David's suggestion was that max_ptes_none would literally get set to
511 if you specified 511, or 0 if you specified anything else.

Which would make thing visible to users and not ignore their tunable setting,
which is the whole issue IMO.

But we can't do that, because we know at the very least Meta use small non-zero
values that they expect to be honoured.

So again we're stuck in the situation of max_ptes_none being ignored for mTHP
and users being totally unaware.

>
> Let's first have an initial approach in place, which will also simplify the

Well hang on, this isn't the same as 'do anything we like'.

It immediately becomes uAPI, and 'I'll do that later' often becomes 'I'll never
do that because I got too busy'.

Yes perhaps we have to wait for the eagerness parameter, but any interim
solution must be _solid_ and not do strange/unexpected things.

We've (and of course, it was a silly thing to do) provided the ability for users
to specify this max_ptes_none behaviour for khugepaged.

Suddenly putting an asterix next to that like '*except mTHP where we totally
ignore you if you specify values we don't like' doesn't seem like a great way
forward.

As I said to Nico too, we _have_ to export and support max_ptes_none for uAPI
reasons. And presumably eagerness will want to specify different settings for
mTHP vs. PMD THP, so exposing this (read-only mind you) somehow isn't as crazy
as it might seem.

> following addition of the 'eagerness' tunable parameter.
>
> Nico, Lorenzo, and David, what do you think?
>
> Code should be:
> static unsigned int collapse_max_ptes_none(unsigned int order, bool
> full_scan)
> {
>         unsigned int max_ptes_none;
>
>         /* ignore max_ptes_none limits */
>         if (full_scan)
>                 return HPAGE_PMD_NR - 1;
>
>         if (order == HPAGE_PMD_ORDER)
>                 return khugepaged_max_ptes_none;
>
>         /*
>          * For mTHP collapse, we can simplify the logic:
>          * max_ptes_none == 511 -> collapse mTHP always
>          * max_ptes_none != 511 -> collapse mTHP only if we all PTEs are
> non-none/zero
>          */
>         if (khugepaged_max_ptes_none == HPAGE_PMD_NR - 1)
>                 return khugepaged_max_ptes_none >> (HPAGE_PMD_ORDER -
> order);
>
>         return 0;
> }

Thanks, Lorenzo

