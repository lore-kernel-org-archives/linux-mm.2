Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF846CEBF93
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 07:33:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 381CB8E0027; Tue, 18 Nov 2025 02:33:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 358FD8E0005; Tue, 18 Nov 2025 02:33:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2211C8E0027; Tue, 18 Nov 2025 02:33:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0DE5F8E0005
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 02:33:41 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A5AEAC03C5
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 07:33:40 +0000 (UTC)
X-FDA: 84122913000.28.F4E8C3A
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf26.hostedemail.com (Postfix) with ESMTP id 25A12140004
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 07:33:36 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=OKvHpOH3;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="ozuQcM/O";
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763451217; a=rsa-sha256;
	cv=pass;
	b=CkokhYn/IB0BWf4TfLKCv9WdVyz0z9rwLXe8PrYwsFA6R0vNPimfPtvBq4lP+kK/4wqJgn
	cvUaHxjBbQmeAJNG278BawxtCQtMd9xFaCxBClMVpVVS8FEe+MvQS4wg30Eh1AZ6f0eqjT
	1N249EChfVdh0d+NC/I1do2ZsOYCBZ0=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=OKvHpOH3;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="ozuQcM/O";
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763451217;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DrmnSujz/deh49cFYjnnCeBJ3kgeYiJaKBEXVFh5DK4=;
	b=sRSpycGOPj2haoZA7K1NTva9frZtBKe61spIPyoh96YCZtz8C6d+/h7oSm2TcMeCo87uQk
	m7i1D2IRZf2z5N1EfCq/cPp9XH5a+MFFYxZBS7SJd+/ZTIJnbhtox3dVxbIjJxJlfeCu+b
	DfUpPzzyd2+RxTgE1rFwBOWIwiHxkQI=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AI6NP1K001881;
	Tue, 18 Nov 2025 07:33:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=DrmnSujz/deh49cFYj
	nnCeBJ3kgeYiJaKBEXVFh5DK4=; b=OKvHpOH36Kn2SzqMoxYg3MvqThdNTJPJR6
	wFFWIiqtBj8siyXYwkU74cDr/kg7E5w4v4AheY/cB+oo4hFDUgus0EoygHjb3qJn
	rOvP3bl/p99mYtsZOKlv3fr67cR3kO5mMoO2lU5HHMrPat2hSRRSKw3rl/35AeEy
	carjCa46Pz1n6O7g9nFE8kqI2bErLf3u7qEDCaD90qhxn508r4G0Bj/afFPF7Upu
	FvPp+h20587npIQWrmBrOrMKFHfiIQoY4sDoARThnW0rdmJXotcVouszYHiu73JB
	NOYD07I//rZdCIkEZy0kpoxHizwMaYsbYOzxnzaLnmHeQ9aGu+gg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aejbpv982-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Nov 2025 07:33:26 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AI669FJ004363;
	Tue, 18 Nov 2025 07:33:26 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012013.outbound.protection.outlook.com [52.101.53.13])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4aefy8hfwf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Nov 2025 07:33:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Qp9L3XuuLuf7vG/4vvOH/oTRBxySB2JlDaIM2WSBhgQiscLjmtsMGojzTksKxGpRrpu0/sanMo/uRI3x2uQx2lPB10XwwYscyvpWRUkH0bpQaYa94V69wsXJULxhlD71x3pTxTOha8NNILD8NK9taDq7j/0ip1bY19d3O9nefVSLeIptCB63JoCblVjv7hvBZmS8GOc/+SAZgRQRIOLe2jTRJOjZhNMCps3wkLLbl3tHqM63QkwjvD+095vywj2+cTcDi1e4wnU3EozerjmRp57x8/yLKZC1Piksf4ABVByF4f7ykWpviAk3tLOnq40erA8VIG4Lbyf1MOQ6euMdTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DrmnSujz/deh49cFYjnnCeBJ3kgeYiJaKBEXVFh5DK4=;
 b=beNGAyUnTM4hVIKeZAW4SOrILgrtiOPe7LiARAZnwvVWTfwtXr0FuIKSC7tlyeHbzFdRpZy4eRd8yFNA/+kieFbd1Bv6SFdb7V9kC/9g+iwEnlTwcJJf6wXMbTK63YOPZZyK2EL/uEmIMk+NAn5dcoLc1+Oos5/oukgsxIvps/h9dnulZT2M0Mi5lH3YqkeJGcl2UBaivOKTcP3xYML7BK942Z6n68l8VbrUsNeuc2+RmpiY8iW8cFXp3lzpDrWr5l3lE2hxBWFeq/akdr5BrAiT+fJxXYkU7l6Fsg1IjuSVHx1xwZyMVxllX2hvchAmeS7lN+UBqz2onFOgpO12Kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DrmnSujz/deh49cFYjnnCeBJ3kgeYiJaKBEXVFh5DK4=;
 b=ozuQcM/Owafl9Lf8sTmpI4wlHy/Qg+MAKRgrtBZLBjLgBSAHAJWoe/03sqLV/AKGBMJgLskg1Oe7MHu2WN31mHfDQqrNp96a18KKdIVc0sKVtMRyEgqpCqUVSySW81ZWvilYN7C/f+Vd8lmP1MaYq0r/g6SmYiFKMi0UYd1ENDg=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by IA4PR10MB8634.namprd10.prod.outlook.com (2603:10b6:208:56a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Tue, 18 Nov
 2025 07:33:23 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9343.009; Tue, 18 Nov 2025
 07:33:23 +0000
Date: Tue, 18 Nov 2025 07:33:18 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: jane.chu@oracle.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>, David Hildenbrand <david@redhat.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
        Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Lance Yang <lance.yang@linux.dev>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, Andrei Vagin <avagin@gmail.com>
Subject: Re: [PATCH v3 1/8] mm: introduce VM_MAYBE_GUARD and make visible in
 /proc/$pid/smaps
Message-ID: <6ea6d33b-be16-4a00-9b0b-ce4a5dbecbd7@lucifer.local>
References: <cover.1762531708.git.lorenzo.stoakes@oracle.com>
 <94d1e9c6c6dd8a4de1f2a8022ca92e2e320730ff.1762531708.git.lorenzo.stoakes@oracle.com>
 <1c4b521a-f84c-4a3a-99f7-ecb9ace3baf1@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1c4b521a-f84c-4a3a-99f7-ecb9ace3baf1@oracle.com>
X-ClientProxiedBy: LO2P265CA0194.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9e::14) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|IA4PR10MB8634:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d03e4dd-e369-4a46-4909-08de2674c0f5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?LHW6zXGAd6SQEQOGfdrd+qTFJhYFkVMvgAGrg16D7ADTqolsjXXsQ7y8qChc?=
 =?us-ascii?Q?sHN4xh+xZCifqulEw2d5GePDNcxI6gVZh16ChqPKpP6Rnevsem9SCub08x6W?=
 =?us-ascii?Q?MF6W8/2L0AuBH8OEiKo9v/NNT5nfg4b9HZ3zoHIgBMdN2Uth7Oo5sOCJGvHo?=
 =?us-ascii?Q?3wh+icfjP4JIHFSB1qNGsx31/74HgcXzaOZx+FXElXF8QFKh61xYVd9NtJOM?=
 =?us-ascii?Q?o0nmeBeu5h8et2i5l48svw5mXvzmhs0Q0n7ZkKCZ20z76u19b7n7KzSt68Rz?=
 =?us-ascii?Q?Jvbl782K0XHwsD62q/pvUsUeONcZiOqJZ7B5U7eHyQmnT8ykydwkh3wuENLj?=
 =?us-ascii?Q?SNOQ1d/YYpE3J1DJH2a0OAaj94rR6exjWXXSWVzYAQGiz9733UZNTXait2F8?=
 =?us-ascii?Q?TE1V8ULO9YoN/CJYpoXxwNsIWE19nHQkB/NS6TN4KovIM8Z9W4WKQwoRAGVS?=
 =?us-ascii?Q?d27bZcQwvNdYLBvCB04oRMLsJxgeX9SNqGDAoqc5JXPV4ym6rtHxaAITv0sp?=
 =?us-ascii?Q?tNxpHXQrjCa7Tcs43yZYXLSPwPzQYR0SujkKZlqQ69nYsUogNtbG4xATqIM2?=
 =?us-ascii?Q?7IwS+IFbQvvADeA6XurXpBLfIefVgOo9y7Ceudiz+AniTYc5+MuHLKteTdOd?=
 =?us-ascii?Q?GOtpuM4WiYLp88rsXWeAB97Kz80+BR++dwZnYHKqrZn62R+Lok1Rz3JkBl4Z?=
 =?us-ascii?Q?Ur3JHYOwnYSNn+8vzM8ytOXBr13OMI4uNw21IzIukcZHpwnCwIpCHcnZqBtu?=
 =?us-ascii?Q?LDQxvWr02L3TuVVYoJUNX2zXUsrdX8jiQEnOG0yIlSBBi3n20evPZXGUXnla?=
 =?us-ascii?Q?iriR2bZPH+3aQSg080iz1JuASfa3PwPVkt49TKWuSMIxwpAMCaYUwf6++L+/?=
 =?us-ascii?Q?3tfrLyiKnCgitET6S5rn3aloYGCyZ08oHxJB/yqAwP467f9ZX/oVhB3t0g7E?=
 =?us-ascii?Q?rZg8NOj281B/ugf7JzZwPWMtdX01WeMDrCeJbNLRJ7DbMP7r2gl5zLswO2dC?=
 =?us-ascii?Q?dIsg+BlHFRGtpglsdDneS8/C0SM6Qo4e9OqhpvFwQn1BdyEHL2xBU9Gk+Y3Z?=
 =?us-ascii?Q?EesfVF0NgEuDV9sa6z/R6J5gKKW/qeiEY3AyptmhWQLEp7moUPuCqQ1J/Oim?=
 =?us-ascii?Q?DS9HDJDd1Y3F0MULGOcki8SQzV0YnENLdKNPREEx0SMgoKxojvtYt/rYYToj?=
 =?us-ascii?Q?Qc0kEPueVX+SRBzJslFqvTmKOZnJBi3FB2OIJN+gDk/89ZLHZBT770p1d6Dh?=
 =?us-ascii?Q?Q0VqmQfSg4jQg7NYlmOLUvSTeMxvh7YeMwuBfQISAkgGx0s0FRAuqLwTF0wl?=
 =?us-ascii?Q?tOpNKfgUC2YTrJ8q/QZWMJz5Rb2P67AZx+LtpJSurbOAPATFsjchWYCQ200B?=
 =?us-ascii?Q?ejL/uG9LikE+rQeTFW0d4nG6X6HZ/OHPD6HRDGehtG2uQpIdy/VF5cbPBwdm?=
 =?us-ascii?Q?cLB1JBREfMaRSAiH/yyPs/Wyfa04CAEy?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XOxa1TE43NZDhm1Jnl6lSMtwY03cuoSce8KmAgPV4Gdbqk9hOLhTwvPG8PK2?=
 =?us-ascii?Q?Xj/zfZlSgZdZXpfTeHy/GZAugIJtWcM9uhp07+VCAU0iV14Zap1ZdQnNWrSH?=
 =?us-ascii?Q?tM8Q4+z5e9U/2juG7wEcCLRuJEzMgaYUBdAL4fHIX2f22e6SJ2YmGY0Ew2xn?=
 =?us-ascii?Q?7JQRNOt+M4xAjMF7pvc+pD75XKLVS/H8+45ip2jQ4qfFtf8WzCdt6wPYMaM7?=
 =?us-ascii?Q?U8GimCLR6fJXBl1yh5tUBH2z7n/kwZ2KqgkcLdDsrpZJInZ0Icd7rS155USM?=
 =?us-ascii?Q?2v58B6z4lRWLec9IYe27W7pPVM1J4wvzHOF+RSd8WcWdbytoBGl2tE7I/Ew6?=
 =?us-ascii?Q?wRoJAEgnsJ7olU0cNXP4byYcmEr6Nq2DdfRi9sIaV5yWFKyXYVXldoVNjMHp?=
 =?us-ascii?Q?LANCJE/qHZXWsbNS0ASe/bax59+LgunYyMqxaZ6QLxe8XeeCMDaxibGi6URb?=
 =?us-ascii?Q?dDi3NPNU1tggmDgM2SgyIzWpI4nQZBgf3OAYpMEE25NJ50WV2KAqLKXFVn8E?=
 =?us-ascii?Q?o62MMeRbhGXZ8B1CQozaohmZrFay3dn0sJcNye+5QAt1Y0OTcfmS6GGnb+C7?=
 =?us-ascii?Q?j56TlpOvc+VZoOiDHzrK2IFlG5C0OoajZJQ8GG6RF+wvQop0qgGtpuVfpFNu?=
 =?us-ascii?Q?22psjNjy/xXG1wMObMmN038zdwKGxBnOiZjwCDtZ5Sd2tN927CCaNOZutoRo?=
 =?us-ascii?Q?29n+w0uU+v8dYjQ3fVZeHBsIcNHAiTSCEdb8CAYbPrOId9XzTaathha2NlBq?=
 =?us-ascii?Q?ZRNXwCj5x9KqG0EMofkRB9iRslDnNci3u6j0dZtEJX5hKLiYeh0tUht7sskM?=
 =?us-ascii?Q?OlQNu8tOal6TR90mlZzdsFrZwFP0hMNERhe7PGAk+OEpdRYPaDmZ55Pqp6LT?=
 =?us-ascii?Q?i7DD8Q4s9yY1jxKBrbZYjh/2oTrGPinCxSzdWqtO+EVpKXx0TptuYX7R+wVI?=
 =?us-ascii?Q?v2DIa3wmbungfaCkXKD3MxXmr11WNudvt58y7bOK4eqIak+oJAu91ZzUgD2V?=
 =?us-ascii?Q?AZIbQEV0HcndudHJD4ihykahGOj4a99SOFboWGMG4kSebdKshITNc880aXQh?=
 =?us-ascii?Q?MfO0n1gevqjr7tfL2Mry34vMK7O2uDG0m73KX/YcYHkNf0FCfyWE+zIqBwsL?=
 =?us-ascii?Q?MZ8Fwd4n/njiZ2oVj/32C/7LxrziCgdTB0iyq3T1PYTLRY2O7MGRMBMhjdWO?=
 =?us-ascii?Q?SCOxFEhxKZg+U/Q7DSRzNTqebqQBXMFzuWdhcl4VV7FfizqafGm3S294Itbl?=
 =?us-ascii?Q?y/0iWth/BzBCuH7g5oMJfi18xTypmN/PFgsLLDMEzvWE2k7eAP8H/TCx0qhq?=
 =?us-ascii?Q?jC+RCDWbdVfQYTtxmFXmw7mVA2AucHmmLVqk2a0mxdr/pywGmg3ldxIHy++E?=
 =?us-ascii?Q?mOmIT1qoUpx7fahKrCJnmXgTgw6CBxycYcpPQnkb2Y5IeXU0RDyWH1nlwStQ?=
 =?us-ascii?Q?8iqz9pNXkfU9cjMMqK7IRDoKsQlPGXQiNzK5CFOTkdPV9xrsxcoWruPAcV+G?=
 =?us-ascii?Q?R1L/9O0gfKkvdKSgHlkLTICODPig3oYXRhbAQLvFJsGKYDju/TzXJOagMfeC?=
 =?us-ascii?Q?Ej1cTitCmlRDBqyo4l1GjoFoRJZed0BAFx72g0Zo8UVOJHszwkMNNz/C8Z3e?=
 =?us-ascii?Q?aA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	aJUSwD/VRCYXVD2CQ0n1GTukObnQCMUqojEcaNktoQeSn8g9FjamAMKISlGgpXgImKmpN43yVFGHaV7H7UwnvYqOcR6BPmbNyZNuyy0UtZXuDGMcSF587Dm7r+HjbNjJec3yPi4c2oGB8oNdI81VQNqJ3QrahUrWFNZf/TnwEPvxATJIvCd8SloUp2x4APTTHBQh2Fc8/HA54P3qK5df2T4zzTVNCaOeWEhK/iR8DYbVTI8boHWoCm1nn2jA7ONU5FZa0SgpNfMPT/6VIyKmq1TkK+VE1PJ3NwJbc2J7WPzYAesO2OD1wOLbcUQ1NhdyV51/i4xWNLc4Main6e19+p5ibasVrgD81HjVvta3ahGFCshD/oHiBAi4lnOrf4HnYoXedNmHxR5uLeziT0h/HdYZPH/S8b1z+p6wiGd5d3re3a1relWXMzWQ2nYeLyxlcBl0AtZy3D05ZuSOxdrUqyqMwatrsC4haBk9SrkSlNCO66100GPU2SPEBZuYBTFvrTbu3Pqg5vgMxqjSUQ1SMy40xrmrmWBdtSTW0AxPffOl7FreUiqZFhRPs367NUa+KdyGmh2r07aiSaanpYglD6B8hgp7t1yfv+kKtHNRUKo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d03e4dd-e369-4a46-4909-08de2674c0f5
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2025 07:33:22.9360
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 74gmcQBUhW7+J5DTCg8N6Bk5WubM4cYJ67dRlkBW9RtUdThR9ZBGffc5n2vuzyDUzVZ9L/CFhxeBml5SFVOnR4oNoJuvQh4DB9uic2c0zR0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR10MB8634
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-17_04,2025-11-13_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 suspectscore=0 malwarescore=0 mlxscore=0 bulkscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511180059
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMSBTYWx0ZWRfX0+1JvP8xSL1D
 fCUGOE7Opr9JDDLZkbQxYChYmKqEMTvl7v22le+ro9k0EDrif0eVrgaYW9eWiofyRR7rSDIbbZD
 JW/MMHBKvqsn1OKrtyjc0SRLw7oZS4KfppftKwy9M5LefcQKlEmRdhHjENXSEPPCWZXTlHMnGba
 KX9iMyXKOLR7zFi6LG93p9EEYzr+Z4XsOAxJvYYFNeYt/nMejIQDtYgF/2rfMt1Aj1sNFvdZ0UZ
 h5pV18zWIdr4klAfGyCrqOK7E5NbTYcSlF185/5HvdhXzUyY4YmkGst7DhwPg9j1dMt39Z9x+n1
 9YhFQsIr6kMQ2rzyPzD06hTwM5Dcn0mjFnvuUBZZG94scRovPoe+GgQfMGsZuEXgOz/ag1DXBeQ
 gJ7BrFOINd6oQCwvFxixmuGcAGqFLQ==
X-Proofpoint-ORIG-GUID: feu9JS-bZz63KYV8zJMT52cJzUSebpOv
X-Proofpoint-GUID: feu9JS-bZz63KYV8zJMT52cJzUSebpOv
X-Authority-Analysis: v=2.4 cv=a+o9NESF c=1 sm=1 tr=0 ts=691c2146 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=CJ09Y-ZBmrjvR1qJUpIA:9 a=CjuIK1q_8ugA:10
 a=nl4s5V0KI7Kw-pW0DWrs:22 a=pHzHmUro8NiASowvMSCR:22 a=xoEH_sTeL_Rfw54TyV31:22
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 25A12140004
X-Stat-Signature: x6tpmd4yroskwsndbrntjo99qynn461p
X-HE-Tag: 1763451216-295305
X-HE-Meta: U2FsdGVkX1/vvh59ERJ7eBUS3bu7PHG5TV2uL5EgIRsk2qi9qK34R3eneGckJ1HKe4pxx5QLa8weafUhxRJkaINYHc+QDAkrwIO6+Wn2QaR2EUhQS70Ju0N2aGPKwXPSOSDPr68zLsklcTAmmhsZatL9SyOchWgY9LAZdDu115LoSX0u2wNDpvsOY1tGLFNS2SlV+3XOm664AQk4+uBGDp0ijf27FSwKD+plY0CRCeiNsgSaSrrBYZwoHW8FSMFEiPVrPtvep23J8096+FpRCkRNpu8kRHd7iowFGVRXpfQAnF1pxDxgGn1hdcMtQhxJXplsucTyxxRVTy+3OO6LQeU6ypbLt2xbo6N+Au9KeTxiBwF79qSYjEmHAeb99fP1PvDSnRgQdA49upz24Wi+wHlaygYqbUB7agHTgcWHxiEq/KW3RtSAAwrMTqzY/0PKQAXf4POtXbdrB00pd19PTCRDuDpkYhSsWYZ1vHnF8r6sqW30Ujaxbh/mXAVlnQX0ruQZAAh8VdK5kHqloV4UnOqffBeLwtcp2yR4YPvRmbI+8J+Vnpge+9/d7ce0Hy8uBbnxjObPVYRPpbQaBA0S5FIFQu6WBdi8Pp4juf4wTxXD+7grMwS3JSPw9Gg/SIR+CuYKszVTmOrLPnoe7BrKz2Ly3vY+WkVyJN+nz6owdFSeLwoGUTbvTNPA8twafUKEhk6BrqLyMUKVTbhQODITHDsGFDEatoJuexjj4VfAcgjFKLwVA/r49aIMArm7yJbx1xNsPykVbtQK0DqR6FAxD97Z//5oe+nf1owoCtm/p6hi+Oa16JAdnfr8yNWbNx8pdl2i5ubqmlr4POoECd+vPGBzZSwjMZ5oAjHN147kfkkRA6JfwOn8V2fkanFdxjbh/rmIJQExXHBWYwT5SZ8xTK4yvmIQd/gH348Z0i4ZZY8QIxjygqf47vJaGx9c3A4RfUxwCZ1jLjnhQYyUNVk
 +GzOAOfq
 FJLC37rofKQNbSh/AjtRz1t+Jj4ucLFR6XcgEzMk+fjD0l+MEq4Fmad42AjUtmxqhYfDFpsUtNBSkrEhObRA0++bb5SIaUO1npuhKVLrrdkZIUHB0MaeOzKV0aMSwfVjCqmwCaISZFQl1z4aOgQGaozxknpG6RTmnvuxs1iQ0F3xkWxve7gdXok/sAngNK2zlq3zecAk0L4ckI54Ge2+0cYpMghqy05Ri+HX0f/29yMBz02+t08mKoCpZQLjjWsQuiT3D5sih9Sk1rrnZk7cfHdzFY+s6zX6K7YKJgwl6do5rmr5tbD7WU1HMMWYxFms/M+is033webn2M/yRufGz6/z94KEjvQKHowRfsNAZZxYpXr8QFHR15Zc138u/hSXVrLn4ZZAz+yg18cRFUuE5xTamk3k1NwR5gc8iSRDAYpIGk+V9Bli7rVPvcvDIT8Vf8VfGamQDK1E1jfZdId/OCR/5P8epZWfqG/nogE4jp91kYqJpz0hJ+vLZpouQ4h7grclSBDf2UD/4ra8sNo804C/29rUfGLjDD8YZPgSXHDKi4O2h5EuiPsvbla6mQBzpra5x6zmDDqfhL9FpllLnZOHV9Upnd37bEm9hganBdOKRm+WgLiYg5yMUkWi7jr2fyEoBWor5NvAEy9q9oQOCP7rUINCbnm+fHXeqZZRex+MZehMNHrwQYTvEPi14CmpFXTWuDdl8+In6RPE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 17, 2025 at 05:05:26PM -0800, jane.chu@oracle.com wrote:
>
>
> On 11/7/2025 8:11 AM, Lorenzo Stoakes wrote:
[snip]
> > diff --git a/mm/memory.c b/mm/memory.c
> > index 046579a6ec2f..334732ab6733 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -1480,6 +1480,10 @@ vma_needs_copy(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma)
> >   	if (src_vma->anon_vma)
> >   		return true;
> > +	/* Guard regions have momdified page tables that require copying. */
>
> Nit:  s/momdified/modified.

Thanks, Liam mentioned this too and I forgot to fix too, going to respin and
resolve :) I must have been tired :P

Cheers, Lorenzo

