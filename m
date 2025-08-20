Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 792F8CA0EF8
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 10:43:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FDBC6B0089; Wed, 20 Aug 2025 06:43:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D6016B008A; Wed, 20 Aug 2025 06:43:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 076C16B0093; Wed, 20 Aug 2025 06:43:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E5FAE6B0089
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 06:43:39 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9F6C8835A2
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 10:43:39 +0000 (UTC)
X-FDA: 83796799758.10.73993EA
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf06.hostedemail.com (Postfix) with ESMTP id 281AE180011
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 10:43:35 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=PU9X7ORq;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=q0fzZ+EJ;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755686616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9IX4ibkzKrCP7DzT6I09QcmAjKytIpk2QmHXb+0v9fg=;
	b=IVEQtV/OXdH2rSebL9mZUPcRYP+R6KNrwuIZ3RJwBFMVtUN9tDTcae/0Wq/rw45iZrFlpv
	AKxoT/+nNAEFAWPKSP8WMYqBVuw9/JR6cPcr7BEF4Yz+jF04Xbw4xasuuH+bZtiF6SGi/Q
	RWITTc4X8bL+lm/qZs0TYyf6fCmGhRs=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=PU9X7ORq;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=q0fzZ+EJ;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755686616; a=rsa-sha256;
	cv=pass;
	b=NFmtnsk8RW9jGzcTfJnuD6ngwEo65mYzgf68P3fNGZ4GRDRJDprGbpTd0M3Ir0nGvE9Fpa
	nm/H+6Wsk4vHhAoOOTeqkPP8fIDpiaR0V4wbB/SKsbYyO39KYnUtfvsKanPvZ8za7ifhLd
	MBwFF2Ft5+ZHLyY1mKsRhQrOCaDO+ZY=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57KAI658024578;
	Wed, 20 Aug 2025 10:42:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=9IX4ibkzKrCP7DzT6I
	09QcmAjKytIpk2QmHXb+0v9fg=; b=PU9X7ORqkLMeuDOliMoEpqIH9Up0sypZ9b
	0Ji1QoLdCben0wl9AAcOCvI6ZDaLlLcciq+l+af0/xlEDJH3Eqjd5P8Y6A9p8tS0
	1/QGjFtxF2B8OhfyxExEqnAgZqGuNXkq+eDFuwpa3feE8BBKJwwYe7+So2yqS+I/
	tQ0+ACvVysW9PEL/VEwxiKxk5HhJ7LsEZJlsLtp8mpVmjzW4YB63xrGFEe9A6xsH
	VeKQeUi5goFwlPixp2iwEqgbX44mhMoUD/JllMBgTXpKU3BQSw9Cmn2uBU0714Rd
	fL0rjjegiWmsV3dnexmzT91pp2qFVIo8LuJ7uqepQ7Ncs9YdR3Rg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48n0trs0cs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Aug 2025 10:42:45 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57K8o04H039466;
	Wed, 20 Aug 2025 10:42:45 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04on2062.outbound.protection.outlook.com [40.107.102.62])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48my3qkceb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Aug 2025 10:42:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sGS1PHQqChJJIIc/BN6+AEzlifXTuFWtmUBQrzIEMupFCLs3kbGgPpu7SsmS/NgNpU3ZpTHCKZM8vHxfXs+bN4UfC9//rW1wTv1L5B7Ff4OsTapBio8uH7oGNNkgcA9N4T2mL96X78ZIgcqRKiTA3cVKc6Js3SnyhOBK84rxJSiIuq7uW/smIDcUpzDuvTP/qLmercWSZH+re0ccCqIviNeidt7kLvqVoG21qreXnkcXuwpMz1pdQUaswjaOu+fbm02vQufpS6RbihrUWTdb1k6sPiXLljUSKBDDvTTbv9A8ssik9yymciJLbSn9vzPyS0hxVjgn38MjKc6HUC1/TA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9IX4ibkzKrCP7DzT6I09QcmAjKytIpk2QmHXb+0v9fg=;
 b=ZIP4I4I0TabHIcsq7061SZwSHnWZisjhPahGpiazFu3GGla/Es4OWjNckAO+I5clInjdWH7a8cA0jLHzmRM22OVsSG+YdH+8fJSsezHg7S5fLlrId1vVLRKzBo9pxPZvc+lNXthXOx7Cc8WZHG0St2bslVDdtJbf70y04cL7fO5R8LsxlVd3d+jkVVTn0yh0BV13U5Nj2YRKaxSTFI97c3zPBL0eZgE1jV1OT2vGjzWQ8OqHuVoYJ6jTc/qF0k3S3uS8GWvSFcn//i9KE6ZFNqwVQZkr3Z/HphnF1sD7z1EigucHjjT1LVeAobBVnG1gRupmJjewS+uajgSaz8WmTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9IX4ibkzKrCP7DzT6I09QcmAjKytIpk2QmHXb+0v9fg=;
 b=q0fzZ+EJUei0CgbRm/u3vXY3h5jXXE7KUw/q588BGb0X97EbCXgeJOXKfm0hveNYFXfAvCKDfkjq0OU1ZPJUdwWAb13odBJWkYH/TMAbyYAd2MXpoh6k78csQqyS8z2Nesj6LiA/rnYyqHm+1tSnmnKxD844f9wibl6bmAZ7l3M=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DM6PR10MB4378.namprd10.prod.outlook.com (2603:10b6:5:211::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.14; Wed, 20 Aug
 2025 10:42:40 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9031.024; Wed, 20 Aug 2025
 10:42:40 +0000
Date: Wed, 20 Aug 2025 11:42:38 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Nico Pache <npache@redhat.com>
Cc: linux-mm@kvack.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
        Liam.Howlett@oracle.com, ryan.roberts@arm.com, dev.jain@arm.com,
        corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org,
        mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
        baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
        wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
        sunnanyong@huawei.com, vishal.moola@gmail.com,
        thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
        kirill.shutemov@linux.intel.com, aarcange@redhat.com,
        raquini@redhat.com, anshuman.khandual@arm.com, catalin.marinas@arm.com,
        tiwai@suse.de, will@kernel.org, dave.hansen@linux.intel.com,
        jack@suse.cz, cl@gentwo.org, jglisse@google.com, surenb@google.com,
        zokeefe@google.com, hannes@cmpxchg.org, rientjes@google.com,
        mhocko@suse.com, rdunlap@infradead.org, hughd@google.com
Subject: Re: [PATCH v10 01/13] khugepaged: rename hpage_collapse_* to
 collapse_*
Message-ID: <57f04d1f-9e9a-4fff-bd9b-1bf0f417c9ee@lucifer.local>
References: <20250819134205.622806-1-npache@redhat.com>
 <20250819134205.622806-2-npache@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250819134205.622806-2-npache@redhat.com>
X-ClientProxiedBy: LO2P265CA0347.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:d::23) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DM6PR10MB4378:EE_
X-MS-Office365-Filtering-Correlation-Id: 09af5447-cbdc-4d40-d8d5-08dddfd6497a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?EUT6Oqb+TPfVKVP4pz73B9AbHrXx8vqF9zP1X9Bzn0H0YF7a2Vh65JchhTxY?=
 =?us-ascii?Q?BOgfsyVENpuOZfRNJHAPczGFwBhPD8TVD+bDI164QQf/f0o46YsB+x3if/TV?=
 =?us-ascii?Q?BN9sRyY4jrCJc4S58FII9HlQdoqtL2rMjkdlVDlgQJWyJ2T5HhDT4we07gnY?=
 =?us-ascii?Q?HjueMPEwYyKBbuASu/kBWcfG005FggzDaStAT1IPk2AZTnQHRISUApXo8Z/U?=
 =?us-ascii?Q?jp+LiMZWpzWKKyDVSU5VTmGWStDGYLXYoLyrYIEQF+fFlU9wMX2xsFhvpzAc?=
 =?us-ascii?Q?qWyczIW+1A261VH2q5I92kgHfMVCFGGWk2DLA2s4fr9oCC07ThtGUpA2WOnn?=
 =?us-ascii?Q?TcZ9gdguBao5p6c7JXcClk6x+8nGNvussTdJIgyL5rQWxBJrIFpie4rO5Hvs?=
 =?us-ascii?Q?aKgUip0rIIRwXbwJ5Z6/nqlcUgxf1UJRhWBFG9w4AR+r+5BUbyt31AHg8Hlv?=
 =?us-ascii?Q?DhVM+TBnXk8/Z+EGVuyDkbW4XQ59eIJK4U0qW/8aAgVEHviHLz8aI/Ct8ng8?=
 =?us-ascii?Q?VzXHRqGRdvoqgPNpTvSNbph+wjWcRmyRZTshEws8saQdPUu/7yIVOaZZ9T5p?=
 =?us-ascii?Q?nipjBKW+r92ru6FNul1FwmQxhGZOLvN7f0y0qCobJ/OYxdiJburFUuu+tKgZ?=
 =?us-ascii?Q?M55WuxE4x04xRtXqoGciM8R4O8d3loyPvuU1cciy20Ds5ZL9o5QU8u82L6vt?=
 =?us-ascii?Q?GUsZ/EbTdFhot8wsYPeTn3MKpgvkLUPExadDH7VM5VIWaCPAOezzJ1sv2RH0?=
 =?us-ascii?Q?eH8aEgce1Bq+iy7dgSWs7qcRwrrj31RTkn/jJmwMSwLhB122FSCkqGs0xuzk?=
 =?us-ascii?Q?Ht3x3hXpQJZtgMuv0w9PfN33Ro62FLqDx3copLD2qicPQSD69edugN5Ltdrs?=
 =?us-ascii?Q?sy6t2fdteZ0iLy4YTapQWCQ9Cf1Q7EmUbrJM/mzqZbzZfedX7JVnajsO/g/O?=
 =?us-ascii?Q?Ci2zHcEKXBTbQ2LkBBaNPiWpIeeKq7t/NYkjPB3R1LwhKrudblmbXln8F7k0?=
 =?us-ascii?Q?2hJGkpkpfMigNqdApP7ITXNlhsbF1StcGUlfoJ2R58OKCboG055tWx7Z+rrR?=
 =?us-ascii?Q?Q2jsPaKFwEqmIdpAObLa27lp4TD5nVUj7n6nyH8VYUrKvTzdA3ElcJRKPxtx?=
 =?us-ascii?Q?INkQlyYl7eyhW0Mo1uB43bAQSMCjMNuMJQQfr/IW9+oWsS4+RebsQgfeyftN?=
 =?us-ascii?Q?kKiZ7Ihyb4Zrq3ftw7Rljz/mJvNpuJRbjFDRXXbNzT/50ULq1ThMBXRtwL0D?=
 =?us-ascii?Q?m62TrnE9H+k6tMtSVtYrOcUA1XqfB6jU7GeWau/bzV8eRlOO9dDHgV+B9dIl?=
 =?us-ascii?Q?DJEd1pq3wlEg85IJ37kAjrIH+CjXznBxKM96JvHQz9N8c57BUBv0EAzhPXSX?=
 =?us-ascii?Q?SYM/AErGMa+LHEfZ/5xbdiKhH6UBl87Zt7vC+7Z0J9ORxQODqg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?olEtQbOBJREd6OUhkmwYn9tmcLNDHDq8YFUlo8fjC9pfKU+XXiX2jttd9Z6n?=
 =?us-ascii?Q?uoj1e3P8BCfezNH6V+K3Nr8+aksOZGxJpM2EBsUVqU8F1lKhKlvLffBIIXeV?=
 =?us-ascii?Q?jWum2kYQm31JrAdfCLc2bmYsHyLp8LRUhprz5MOqVqIMPkr7TbTahtb7IPel?=
 =?us-ascii?Q?c3aCZhLwo9tPOYWTWHN97RxVJmrLlSpvoRFtGd84Lq3Yn/UHNVJdeSkoLPfc?=
 =?us-ascii?Q?RbiTQE8Ms+iithsMVw8pVGQbOh19bYJGE+nYJs+D6p/vhmCBkbcb7pq9ECAN?=
 =?us-ascii?Q?BTpeJ8/OsPe2xWxW+3IGaX4l2hqrcXn16U7vD9XSazmi3fV2D+MSzmZvhE+I?=
 =?us-ascii?Q?NVJ2BhGYfEtpCt8IER8MqRJfbVD3TxrzJoOdVyKk0vNtuyixUtGc7yxrlcZk?=
 =?us-ascii?Q?9aGI6KVCwXvemvJr4GKnL7dq9/Qo6ehkfJXOFRZ2QxvVmJbuR585LuNitCjX?=
 =?us-ascii?Q?UxN1PzxUdWXtgEyGu0N6zCBLSXqwi3QRMKLgUds8KmHySO+rjlmZ4eGqyyhs?=
 =?us-ascii?Q?/T/EXc0SVVIIP3QNfF7Yr8Dv+nFtMaTGUT+YhH2m2O+l2RXexHrTl7eYHWgP?=
 =?us-ascii?Q?jY4VwUZJX0xyrS0E+AsLp6+veJ432tJOaXWNpRP0VaMqDI/ZRwITF42zzc/K?=
 =?us-ascii?Q?D2cQ/K93ikIwUYC4XFqghdavGg7ZvWaWvT0a6mRM+J465x4bSWxiCluwrkH/?=
 =?us-ascii?Q?8Ze6cUGVHivq5Ak/86jjqhGtxgMLtiS2eqT6UktDdwbCrXYDAZEtE8U4bdGy?=
 =?us-ascii?Q?Hhh3fOyYi3kzz4mkKoVQ/lnh8g6nbM/P+RSmqzSiScCbTPh1TK6iMOOW3sHh?=
 =?us-ascii?Q?S+TlGVMFFPVtSGyb2pBlVgRQKvvrtODN/21w/j+LGLEuxvsFmPfWTuKQ48TA?=
 =?us-ascii?Q?H98GlNJAxYkru3GwHwIB0LUD8h5qkDrsSQmJd8iS3EMjCSkrAGczGl8a1Ywm?=
 =?us-ascii?Q?/BL8svjM/4d4PilquE9Hnv/V1mb2/vBZbVA9eW5JFuIPwoveqZ1NwOR+dESO?=
 =?us-ascii?Q?q+/vH50MqooQqkdoJ2+LRfxZF1skhsUV7f0Qf4Ru6Skt3Uaft2zXQEMbZvTg?=
 =?us-ascii?Q?ZpA+AYKTcBG6RVNkzS/OZ8WT1nxQoTeK0j4K7WlAgakqKNFqptr0ETnKA9DD?=
 =?us-ascii?Q?b19x1DIcDJCBSjKuJllfwIt86vUlHJ5M7vQitCk7vfPsbhspDUxQtbeoQVzB?=
 =?us-ascii?Q?F+AzpxWo2ig9ge2R6vdNe8HEJgMb8ZiiI1mtV9Kp+xCgiItXGz4gQX+HJmks?=
 =?us-ascii?Q?sTScG+DzoVBW7pYb4ISnqxU3cDpy6QBLf0was6Z6hMTQBJCtUJnfZbMovyrx?=
 =?us-ascii?Q?+cLnFVEH/q1m4xqR5N01a6vA6dGfuihCcjcubHWjsZ6oEiojX3ADztF55bAT?=
 =?us-ascii?Q?7jj1Kd4DazKYnK2XUz5q8CmgKfg7cUJE2YrSQTcQMNTdre05tKHbtu/Oy9sq?=
 =?us-ascii?Q?70aSmZeX5pVFoVOwVfEzaquyHO9NXpBQ025jxCKvl+z7x7p3ubPceioCVdSs?=
 =?us-ascii?Q?vZ9JzQ9do0MS+6U9DFak99O5/Wos9nmhCdy1t1GwSIektP28+4h7e27zxXVt?=
 =?us-ascii?Q?Y3K4+atJ03h47NpYozNVzNIgm/QH1J4vdGHWpsTuTyNkTCmNpq9/8v3usS/a?=
 =?us-ascii?Q?cw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	VjvVw4ibtzS5CTggsKIPgQst3WPSeM2pD0bSmf45UBOAAy8Ht6qQcooxFTgC9Rd/qstXLWNmoBmflQxSrEd5qLvxdGrVptP6r0ANnKNVb6RceWle8N5/oeMev4z7XYGqLUGLgyCC86kPURTZriATFU9OY0RxZLd5yVL+LmSNC16jtXqGxOytTTiS0W5rzoupFKhgf5KLY6jd8IX3CkhVQvadWKMn23dfDqrSSVSgSZihm2MtPdyVxOzaWR6OllwooFrp6RE3FIi1PeQYYj3xlEefk1m0AGPNWuRMvUI8N85xgKmYu0VEACt0MI0tnW0sIDbDoS0pAStQKavUtPU9m1WYK5XnKSb6kxjItdW1pKHZAUSnK40z8KsjOAan1sUukIFelfN8cgVcYqugXfTjTPZvN5bTWewRAEvfwSYJ4EaQr+lqRrVyRfeWOMefqYqvzO6d0nfkhRAeag7sBwMQrq66eQEaxoUxf/ppdn16xjIi/5HUC07cCLcF+G2VN5ATNYQ/6/Z1mXAX83K/gu6skah5TAGT7KHbT3yP2kMsSDoYeRpG29Q6dw3Ki0qJwBqEYAKrGmQk5rC6hSYKi6B4xXPOZVB2vhNVcTDLl+a9X0M=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09af5447-cbdc-4d40-d8d5-08dddfd6497a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2025 10:42:40.7039
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mbcEfIArc4n4BmJ9WcMzQ1LofZIYZxS9f/GkCY+JJxZn7C0zW/Uw1s7S265Cbp/Q0ewn9SD53UUE5HyM2Ca3xmwhsjKAbEdLk9FQrw4PGGU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4378
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-20_03,2025-08-20_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=934 phishscore=0
 adultscore=0 mlxscore=0 bulkscore=0 spamscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508200093
X-Proofpoint-ORIG-GUID: a4tkg97alaFAg4kW8DuvLJOUHhQTBbkK
X-Proofpoint-GUID: a4tkg97alaFAg4kW8DuvLJOUHhQTBbkK
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE5MDE5NyBTYWx0ZWRfXwsvxDsfjuCE7
 8d5dQNU7WzYgMvy+EwNC7IpOwYlLh2mWQXM8w3gbSpoGpAUBXO6ImMQMPTQE8LTwPXjy29MS2jG
 dmPL1njQ95ArUUsG2a4//+bx7uDpXF7heMGOyYcA4xwVhjE9aYE/QhRGvdwTCRl6CRJ51HGdFc4
 4/zBllxrhebeXLQH0Tb2BdhQYAubk6p5G8REJCPwlM+tL3YqsVtc62ykEYXXFTSPZUUXnzkgtGI
 glj2ntFFtgHwLaSzMfZVM92mmwObSwMWye926s9zIw6aUy+oG8sOamcDVZvmGveY16SO6DfUjbh
 PS/+CtVEFN6KiUbHEuBziJQjqVg/sdSrLa/sPR2cucytZydg6phOMNKzc1d9WsZcG1Ti0Znh/s5
 vVoBwuJoB+PTqw+TwOzJyau+58VE7w==
X-Authority-Analysis: v=2.4 cv=Qp4HHVyd c=1 sm=1 tr=0 ts=68a5a6a5 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=Ikd4Dj_1AAAA:8
 a=SRrdq9N9AAAA:8 a=20KFwNOVAAAA:8 a=U-mmig9sJ92NmRzy5GcA:9 a=CjuIK1q_8ugA:10
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 281AE180011
X-Stat-Signature: qs3o4zzzspw1mei1ww95wbhizs91u7of
X-Rspam-User: 
X-HE-Tag: 1755686615-257538
X-HE-Meta: U2FsdGVkX1/lnRyd+OH0EAudEFQmLV/xPT4F2rfJ+M/vk7K2bU9mGUCtnm4HEp8t2uaSwmC8fRNVjv9ICKB8GKdiaQkezrNys7zY5mk0Ig03PQwaSwVEdM+YtcsAkjyWUGL0SIK0RIY3zI/CDGqGGzDL3dGZXyar7PdczhMwAg0dqxl/vVgSL3uv3FG0O1o3WAFz3rLuOW3x42duK9rOG5hnyPUSjO+nxNOBI3ld6N9aEmNVis8+PLWijgplk/NJwmjnBEW0nf1t4qisfhRr43PZZ1YcmPMUWuLly0uTFWvFa8orvnyLe8QSa+pAn6jA4PnRfRIkev282e2ycyxoG+40/bggQC1/pG29qJYSvXcmNOKHpCrPrWqqIbGMJYx8rXqfqM0YQbduJXc5ACny5//ZJZxDZhptQGaVRmGzvJpUvj3dtKKVpUrF6xhB7MGV//KJBoLttJrmKR8BF09MbIbAWgB51Xv6uvaegxX9KjW0xq33e9ja7BTLsoWQPS8QE6UEP5Q+d2p8PrX4kiDsvw9+H+4zA/IWlsBiREKfxrKVbZUvKXhPO4N9oJnkIfmYpCY6rKE/Lcd7vrGn3Ru5gN5uFpQSUW7Vzvf83uVEXYpyWwlZuV4DmCXm/fKqWuad/ocQHtNeKkpEwqI5vAdGLlBd/nM26w3L5zpTR4tQiuRVueKA847gYzdRAqXqJ5U1SlzPSxSZiqK/SgrPQ4GbngGgD/2DQf98fkZu4P9nNgatTnjNjeAZeumrHN5q55NZ9HHTVwVOftdyoPw8ggj+ibRcfMlziDCiJbW2KDR3o4pQADN4IIWxffStjNhUSjwBrG9DcbvJl6PRvRufZI523D+d4T1GBhm08/wLBbEveth5+DbldluueQTxTVX/PreRvgdazXttD6hCFAtKh5oyKqoPMK6ALkH+rh/SbP8/MwVqqzbJNp8I0wmVLbiVwBh3QfEvo3PnGar+e6g271R
 pXSiwvBy
 r9rRTIAFANMOCfcEBrlllS1+2m657/VIx0TkI1AsfAKECAU8G9TSo+wKlaP4S5dnIFkuNdotaCG+AW8+dVs9kC7hNnVlbVlzms4oIVvHa3+FEdB7YvM9d2/cYL6qd16+BL5CK9Rqhb/02zhOIwQSS/Cv3Lztr/L+9nu/2Lq9iO2ktPHPzSBQZx4LOHeNjH0d9D1Pn1K5kxzmtDetZDqD1vRCwrbunjDKVw2V/kkH1JMMSs4GVv7cn/RZ4VpmyzVuDJTqaEKkTy4N7E+q/wdq15yZaalc5WQSlyRwj7MdHix5XQVLdQ/hkhyDuzL+1uakWRwS+m4AM5qPnadvhKjLF0qOrnO4ElH2rsQdtuKwt4GQ141GaRh9Fj0vpUeO4bkZ8sWelPWHDVeuiU7w62jOUfU7nthDqmd41wFxPm25gB6zFr68/GuTW6M6NLYZTMUHhzr7iIMKYgh6rinEyl0kLabNsOeHYSmpAhEEog6Ft9+Uare+UoH971Ebr3odXL+GF/OOhjFwClnMkE6ySicQPAYe+hK8z4h+wq3P+AYwFM2RUs5hrCe2SBSDOLbKs2s518U/++VNOZK9346TAxXogemsq+nGRBCTXL6ssEB4mmE9fJUcbqNLh+oX94ijyQtYSU6Fbaa19Jh63UNionwycyeRGTmQX/rnveR9N9E4zg5xoC6VIyj0s7+poM5Jb8xdllxB1YZ30qNbosRuAGLBkohEUdM5aSeqrM+SdtMKkkm3YsKBxaeonhlcYXFR4tRaVvahs9o+ZvSB8smNVVOPrv/R8TWlo2hbJ8pRSWU3IhlUFcKL9VeAkmpSglesqv+kFcVS52UCbA51C7XFb8stdWnt8Vq+68NwN7dvYbNXOlwkcoBUnxQji1LA5NxWVAMRAHaKwlYdeWnlogWEVwujSfNs0dEgwCN3fyFAQTEytvgmEzu1hzOOaB1ej2LnaKjxOUwbzeoXZM8sTLUs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 19, 2025 at 07:41:53AM -0600, Nico Pache wrote:
> The hpage_collapse functions describe functions used by madvise_collapse
> and khugepaged. remove the unnecessary hpage prefix to shorten the
> function name.
>

Not a big deal, but You missed a comment in mm/mremap.c:

	 * Now new_pte is none, so hpage_collapse_scan_file() path can not find

In move_ptes().

> Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Nico Pache <npache@redhat.com>

Apart from nit above LGTM so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  mm/khugepaged.c | 73 ++++++++++++++++++++++++-------------------------
>  1 file changed, 36 insertions(+), 37 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index d3d4f116e14b..0e7bbadf03ee 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -402,14 +402,14 @@ void __init khugepaged_destroy(void)
>  	kmem_cache_destroy(mm_slot_cache);
>  }
>
> -static inline int hpage_collapse_test_exit(struct mm_struct *mm)
> +static inline int collapse_test_exit(struct mm_struct *mm)
>  {
>  	return atomic_read(&mm->mm_users) == 0;
>  }
>
> -static inline int hpage_collapse_test_exit_or_disable(struct mm_struct *mm)
> +static inline int collapse_test_exit_or_disable(struct mm_struct *mm)
>  {
> -	return hpage_collapse_test_exit(mm) ||
> +	return collapse_test_exit(mm) ||
>  		mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm);
>  }
>
> @@ -444,7 +444,7 @@ void __khugepaged_enter(struct mm_struct *mm)
>  	int wakeup;
>
>  	/* __khugepaged_exit() must not run from under us */
> -	VM_BUG_ON_MM(hpage_collapse_test_exit(mm), mm);
> +	VM_BUG_ON_MM(collapse_test_exit(mm), mm);
>  	if (unlikely(mm_flags_test_and_set(MMF_VM_HUGEPAGE, mm)))
>  		return;
>
> @@ -502,7 +502,7 @@ void __khugepaged_exit(struct mm_struct *mm)
>  	} else if (mm_slot) {
>  		/*
>  		 * This is required to serialize against
> -		 * hpage_collapse_test_exit() (which is guaranteed to run
> +		 * collapse_test_exit() (which is guaranteed to run
>  		 * under mmap sem read mode). Stop here (after we return all
>  		 * pagetables will be destroyed) until khugepaged has finished
>  		 * working on the pagetables under the mmap_lock.
> @@ -592,7 +592,7 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
>  		folio = page_folio(page);
>  		VM_BUG_ON_FOLIO(!folio_test_anon(folio), folio);
>
> -		/* See hpage_collapse_scan_pmd(). */
> +		/* See collapse_scan_pmd(). */
>  		if (folio_maybe_mapped_shared(folio)) {
>  			++shared;
>  			if (cc->is_khugepaged &&
> @@ -848,7 +848,7 @@ struct collapse_control khugepaged_collapse_control = {
>  	.is_khugepaged = true,
>  };
>
> -static bool hpage_collapse_scan_abort(int nid, struct collapse_control *cc)
> +static bool collapse_scan_abort(int nid, struct collapse_control *cc)
>  {
>  	int i;
>
> @@ -883,7 +883,7 @@ static inline gfp_t alloc_hugepage_khugepaged_gfpmask(void)
>  }
>
>  #ifdef CONFIG_NUMA
> -static int hpage_collapse_find_target_node(struct collapse_control *cc)
> +static int collapse_find_target_node(struct collapse_control *cc)
>  {
>  	int nid, target_node = 0, max_value = 0;
>
> @@ -902,7 +902,7 @@ static int hpage_collapse_find_target_node(struct collapse_control *cc)
>  	return target_node;
>  }
>  #else
> -static int hpage_collapse_find_target_node(struct collapse_control *cc)
> +static int collapse_find_target_node(struct collapse_control *cc)
>  {
>  	return 0;
>  }
> @@ -923,7 +923,7 @@ static int hugepage_vma_revalidate(struct mm_struct *mm, unsigned long address,
>  	enum tva_type type = cc->is_khugepaged ? TVA_KHUGEPAGED :
>  				 TVA_FORCED_COLLAPSE;
>
> -	if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
> +	if (unlikely(collapse_test_exit_or_disable(mm)))
>  		return SCAN_ANY_PROCESS;
>
>  	*vmap = vma = find_vma(mm, address);
> @@ -996,7 +996,7 @@ static int check_pmd_still_valid(struct mm_struct *mm,
>
>  /*
>   * Bring missing pages in from swap, to complete THP collapse.
> - * Only done if hpage_collapse_scan_pmd believes it is worthwhile.
> + * Only done if khugepaged_scan_pmd believes it is worthwhile.
>   *
>   * Called and returns without pte mapped or spinlocks held.
>   * Returns result: if not SCAN_SUCCEED, mmap_lock has been released.
> @@ -1082,7 +1082,7 @@ static int alloc_charge_folio(struct folio **foliop, struct mm_struct *mm,
>  {
>  	gfp_t gfp = (cc->is_khugepaged ? alloc_hugepage_khugepaged_gfpmask() :
>  		     GFP_TRANSHUGE);
> -	int node = hpage_collapse_find_target_node(cc);
> +	int node = collapse_find_target_node(cc);
>  	struct folio *folio;
>
>  	folio = __folio_alloc(gfp, HPAGE_PMD_ORDER, node, &cc->alloc_nmask);
> @@ -1268,10 +1268,10 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
>  	return result;
>  }
>
> -static int hpage_collapse_scan_pmd(struct mm_struct *mm,
> -				   struct vm_area_struct *vma,
> -				   unsigned long address, bool *mmap_locked,
> -				   struct collapse_control *cc)
> +static int collapse_scan_pmd(struct mm_struct *mm,
> +			     struct vm_area_struct *vma,
> +			     unsigned long address, bool *mmap_locked,
> +			     struct collapse_control *cc)
>  {
>  	pmd_t *pmd;
>  	pte_t *pte, *_pte;
> @@ -1382,7 +1382,7 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
>  		 * hit record.
>  		 */
>  		node = folio_nid(folio);
> -		if (hpage_collapse_scan_abort(node, cc)) {
> +		if (collapse_scan_abort(node, cc)) {
>  			result = SCAN_SCAN_ABORT;
>  			goto out_unmap;
>  		}
> @@ -1451,7 +1451,7 @@ static void collect_mm_slot(struct khugepaged_mm_slot *mm_slot)
>
>  	lockdep_assert_held(&khugepaged_mm_lock);
>
> -	if (hpage_collapse_test_exit(mm)) {
> +	if (collapse_test_exit(mm)) {
>  		/* free mm_slot */
>  		hash_del(&slot->hash);
>  		list_del(&slot->mm_node);
> @@ -1753,7 +1753,7 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
>  		if (find_pmd_or_thp_or_none(mm, addr, &pmd) != SCAN_SUCCEED)
>  			continue;
>
> -		if (hpage_collapse_test_exit(mm))
> +		if (collapse_test_exit(mm))
>  			continue;
>  		/*
>  		 * When a vma is registered with uffd-wp, we cannot recycle
> @@ -2275,9 +2275,9 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
>  	return result;
>  }
>
> -static int hpage_collapse_scan_file(struct mm_struct *mm, unsigned long addr,
> -				    struct file *file, pgoff_t start,
> -				    struct collapse_control *cc)
> +static int collapse_scan_file(struct mm_struct *mm, unsigned long addr,
> +			      struct file *file, pgoff_t start,
> +			      struct collapse_control *cc)
>  {
>  	struct folio *folio = NULL;
>  	struct address_space *mapping = file->f_mapping;
> @@ -2332,7 +2332,7 @@ static int hpage_collapse_scan_file(struct mm_struct *mm, unsigned long addr,
>  		}
>
>  		node = folio_nid(folio);
> -		if (hpage_collapse_scan_abort(node, cc)) {
> +		if (collapse_scan_abort(node, cc)) {
>  			result = SCAN_SCAN_ABORT;
>  			folio_put(folio);
>  			break;
> @@ -2382,7 +2382,7 @@ static int hpage_collapse_scan_file(struct mm_struct *mm, unsigned long addr,
>  	return result;
>  }
>
> -static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
> +static unsigned int collapse_scan_mm_slot(unsigned int pages, int *result,
>  					    struct collapse_control *cc)
>  	__releases(&khugepaged_mm_lock)
>  	__acquires(&khugepaged_mm_lock)
> @@ -2420,7 +2420,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>  		goto breakouterloop_mmap_lock;
>
>  	progress++;
> -	if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
> +	if (unlikely(collapse_test_exit_or_disable(mm)))
>  		goto breakouterloop;
>
>  	vma_iter_init(&vmi, mm, khugepaged_scan.address);
> @@ -2428,7 +2428,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>  		unsigned long hstart, hend;
>
>  		cond_resched();
> -		if (unlikely(hpage_collapse_test_exit_or_disable(mm))) {
> +		if (unlikely(collapse_test_exit_or_disable(mm))) {
>  			progress++;
>  			break;
>  		}
> @@ -2449,7 +2449,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>  			bool mmap_locked = true;
>
>  			cond_resched();
> -			if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
> +			if (unlikely(collapse_test_exit_or_disable(mm)))
>  				goto breakouterloop;
>
>  			VM_BUG_ON(khugepaged_scan.address < hstart ||
> @@ -2462,12 +2462,12 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>
>  				mmap_read_unlock(mm);
>  				mmap_locked = false;
> -				*result = hpage_collapse_scan_file(mm,
> +				*result = collapse_scan_file(mm,
>  					khugepaged_scan.address, file, pgoff, cc);
>  				fput(file);
>  				if (*result == SCAN_PTE_MAPPED_HUGEPAGE) {
>  					mmap_read_lock(mm);
> -					if (hpage_collapse_test_exit_or_disable(mm))
> +					if (collapse_test_exit_or_disable(mm))
>  						goto breakouterloop;
>  					*result = collapse_pte_mapped_thp(mm,
>  						khugepaged_scan.address, false);
> @@ -2476,7 +2476,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>  					mmap_read_unlock(mm);
>  				}
>  			} else {
> -				*result = hpage_collapse_scan_pmd(mm, vma,
> +				*result = collapse_scan_pmd(mm, vma,
>  					khugepaged_scan.address, &mmap_locked, cc);
>  			}
>
> @@ -2509,7 +2509,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>  	 * Release the current mm_slot if this mm is about to die, or
>  	 * if we scanned all vmas of this mm.
>  	 */
> -	if (hpage_collapse_test_exit(mm) || !vma) {
> +	if (collapse_test_exit(mm) || !vma) {
>  		/*
>  		 * Make sure that if mm_users is reaching zero while
>  		 * khugepaged runs here, khugepaged_exit will find
> @@ -2563,8 +2563,8 @@ static void khugepaged_do_scan(struct collapse_control *cc)
>  			pass_through_head++;
>  		if (khugepaged_has_work() &&
>  		    pass_through_head < 2)
> -			progress += khugepaged_scan_mm_slot(pages - progress,
> -							    &result, cc);
> +			progress += collapse_scan_mm_slot(pages - progress,
> +							  &result, cc);
>  		else
>  			progress = pages;
>  		spin_unlock(&khugepaged_mm_lock);
> @@ -2805,12 +2805,11 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>
>  			mmap_read_unlock(mm);
>  			mmap_locked = false;
> -			result = hpage_collapse_scan_file(mm, addr, file, pgoff,
> -							  cc);
> +			result = collapse_scan_file(mm, addr, file, pgoff, cc);
>  			fput(file);
>  		} else {
> -			result = hpage_collapse_scan_pmd(mm, vma, addr,
> -							 &mmap_locked, cc);
> +			result = collapse_scan_pmd(mm, vma, addr,
> +						   &mmap_locked, cc);
>  		}
>  		if (!mmap_locked)
>  			*lock_dropped = true;
> --
> 2.50.1
>

