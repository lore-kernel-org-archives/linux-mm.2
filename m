Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75368C87FCA
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 16:13:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17A9C8E0007; Thu,  7 Aug 2025 12:13:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12A578E0001; Thu,  7 Aug 2025 12:13:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE5B38E0007; Thu,  7 Aug 2025 12:13:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DC9108E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 12:13:41 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 94CA4BC611
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 16:13:41 +0000 (UTC)
X-FDA: 83750457042.08.2270634
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf26.hostedemail.com (Postfix) with ESMTP id 20F9914000B
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 16:13:37 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=gnYLMWeQ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=plmaZUll;
	spf=pass (imf26.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754583218;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4rZTGDQyP9H/uUzS8oPppQyGqizWxTdCCL3PsjVpJ/g=;
	b=LFHXS13d00UBY5dX5fBOolQEiLAS4ysF3f0LORX63gY5HXHKw4+NO5m2V0bEocAJO86Rf3
	JxxfxvuHkPtsPjtGwJm7+Rp5+vhQ+8EDFk0FAqXZHdx3Otv8lW6jLOa3M6O8/wbuZWcaQX
	H9IUhTB9cxc6L976WDVqv+vbEtNxQLw=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=gnYLMWeQ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=plmaZUll;
	spf=pass (imf26.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754583218; a=rsa-sha256;
	cv=pass;
	b=8T6zyPUrqLn7LsrVI0atv//Livv+ZntP8HFYHWIA0QZjXF+6+G0rtlxT55GaCsWl5ht4vq
	Dut7OCRKN6QeoiVH7a7gkcULdFd5/zIT+FnWPqdzESd0HrIBwG8l/Qt61cFrBUAYte/G7v
	NShPCtuOXw3pG9zh+vVIXOefTNtRRs0=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 577F5vKH007327;
	Thu, 7 Aug 2025 16:13:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=4rZTGDQyP9H/uUzS8o
	PppQyGqizWxTdCCL3PsjVpJ/g=; b=gnYLMWeQWnN8l/MYlDkOohaqRtdD6y8j/J
	jy3kOCkRz+z7L+oWvbQer+/si47zYK80SMOuyq1DRvtzLjsj4N6td2x7C6YryjrV
	NmjFuQgG1vILakGRlkG1GlQMHSkFBDjRxxAXpZnofoKyZoILvvHDI4HE5hxdXYiK
	XJ7My87pyqzVCLBl1Mjg40gjhyLzdgixuIYL4hAHOgSl71tDyKq/QKhS/x9cVLww
	NoATRBzR6+Il2VQTLkV8hXzCEJflAEflEMuxwjJnJ52rXu4WNkQgAeWodRCf6j3W
	sBzPs0SYkcgqTMzg5+QHi0Xu0TMHJvQpWS9B5PPRUpfi9BRmoyWA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48bpxy4mbp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 07 Aug 2025 16:13:30 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 577EovDt005661;
	Thu, 7 Aug 2025 16:13:30 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02on2085.outbound.protection.outlook.com [40.107.96.85])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48bpwynea6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 07 Aug 2025 16:13:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QmT9EANWHIVu37OlQTapVFZ4FZKoNg3l9BrQW0TDfEnzCu6dJDLK8C/i9zt2p5ldWoNAwkVODu/Y3mJ9YFJSwXAJknbzCK/Afu6h+jBgAl/J1ne83/a9YNASrs1s5xHCQAb0byQgnBP4qDnHQfVIIdPVYbY6xlt9v2XqOq/CoTujD/tbTJoMAMeCTZ1li7fg1FFB+ugyrAftPK6eucbOx/LOJFU+441SzBU7FCVW8CVlW6yl2DArZQVka24eGS+2hFpopEFqt9ZoTvf6Ufl/REt0x2Wac+5YmBuA+IwGKi4qnHYvspb/AeSF4OvlK3hjuFJFIDwlfjmXx/Mb5qBb/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4rZTGDQyP9H/uUzS8oPppQyGqizWxTdCCL3PsjVpJ/g=;
 b=HMNxXL+a+LFD6csbujtbgwWJZ4MTCgx/jfD75TcMfJybltFgVQcLjclMW0zFR6g//9BfZtCejlIgqiGaLpCq0NeWGfNplm+RblCohrP2R7IllVq8TnLJtwAkR9rv3G4xIbb6jnGCrQlIAIaPN/5huiwnvRbx4gPp5wL39g6C9bfrrVBj0d3ajkH0KzhSQEsFr7cKrG0si3wvugx2BtjmYvQc60ZAs/1TF4FjRFmHSgm2IfS4+qGrandLncy2kHR4FoicXfF4Xb9CBXwIAkbu9hdy4YGyz99X/TaYVRacJdRVHvb7VPcaN54cDX1EcEy7VUFIk8aRArh/HSNX6WDSQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4rZTGDQyP9H/uUzS8oPppQyGqizWxTdCCL3PsjVpJ/g=;
 b=plmaZUllT2Ko+s+0iMd/4F03Wj3HpvqMSO5KdP48PrwopuPz38gFXU1CjUFEguMiQf6Sky1K98sBbMxasdwQMihkiWfwAWC5xb5FXux7Ikdm2Qps5iMsv5M61iQL8Uuh5UIm501t8TI25L2iMwI5kLk/AFHePWxwxsUDfobKwWc=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by MN2PR10MB4141.namprd10.prod.outlook.com (2603:10b6:208:1df::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.15; Thu, 7 Aug
 2025 16:13:01 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9009.013; Thu, 7 Aug 2025
 16:13:00 +0000
Date: Thu, 7 Aug 2025 12:12:47 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Miguel Ojeda <ojeda@kernel.org>,
        Andrew Ballance <andrewjballance@gmail.com>,
        Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
        =?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>,
        Benno Lossin <lossin@kernel.org>,
        Andreas Hindborg <a.hindborg@kernel.org>,
        Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>,
        linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org,
        rust-for-linux@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/3] rust: maple_tree: add MapleTree
Message-ID: <t6lhpij2tv2y3cbps6g3mu6boiic2amy3xx6ppkksrb2625odo@6plivbxstgkm>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Alice Ryhl <aliceryhl@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Andrew Ballance <andrewjballance@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org, 
	rust-for-linux@vger.kernel.org, linux-mm@kvack.org
References: <20250726-maple-tree-v1-0-27a3da7cb8e5@google.com>
 <20250726-maple-tree-v1-1-27a3da7cb8e5@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250726-maple-tree-v1-1-27a3da7cb8e5@google.com>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YQZPR01CA0069.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:88::7) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|MN2PR10MB4141:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c360d6e-c8e3-4f46-179a-08ddd5cd47d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?BdZfaKY+Ew4c4KVlexTMHRqC5Ixc/Qdnzvr+7j9pZZ85xalEmRsbHtMceIae?=
 =?us-ascii?Q?Eg1zE1SbB1ThI0hC3bvgloSbfgEeIKuu+oR6QtkOqKcrcsm+vPLPyWRvLzPh?=
 =?us-ascii?Q?s6o/l0IYEByA3DkVdtADPLkCm0BNooSdtmIMxvMOut1Vev+Z2apfrTyQ0VoX?=
 =?us-ascii?Q?aCZed6PsRuF+wCh34om3Rk3IztAKkTv0lTk2aRoV/4pMHKSaboNkXnRgs/UX?=
 =?us-ascii?Q?kYXiWhDlvdh8vQrWlFkZNChqiOFZgQggQ4hknF8k4IJz1RLAVxPM0ze6j0Hk?=
 =?us-ascii?Q?FjV+G8DtI70qspHG7RZqVh6Ms1Yt2oIM8EcAhp2pTAcKGMijkYMNwH+xbr2J?=
 =?us-ascii?Q?SSIy8EtVfZ4XL93u4dMAVTcf/6miRXgeqdeNzjCEr0VZLvEIM1aEtXb0XXj/?=
 =?us-ascii?Q?gJmYLjr6yW9pjRtlmFkEFpOoA0cwk/E14f5aql8KWTX54tzvKX92m/TVx3zH?=
 =?us-ascii?Q?z1zoAws0RDHUbklS7ZAz6XRL7i/CBVDiz28Y1Uu8Sj7l6OzWEY2fRJI4aNqb?=
 =?us-ascii?Q?39F+wMWsQFfuwSpbpg7137MTvCRrgJneYoT/d/wOslGdY2pCS50/kQGP/TJh?=
 =?us-ascii?Q?Y2eF/LSZXZCjbJdmZXICon3S88ZRwkYFcwEuBIEmQTBRBLsU12JX/KM98BHE?=
 =?us-ascii?Q?f7PhIb57keN87vy+Wp9zW26EknIFFMkhWn4e2k8pXaI0kFFo4VGhl7qD6ZtQ?=
 =?us-ascii?Q?SLIj4KW19XqXLbqsCF1YkZ5HsBmN1tSE9/M7+I7FeGUFabZiL0AK5ewis4Wz?=
 =?us-ascii?Q?6JBpvnaQgmz0fQRDd8BcarSuBSMkrw6/pYh5lAwaO7dST4z3N7/GpEst4p2C?=
 =?us-ascii?Q?pa1v4vw9iPXrx4bFOpmcGLizdq2baL4kAF9NMLdN2H1mOZgASGLRU54KOm7u?=
 =?us-ascii?Q?oymtH5O2qu+vHDFpE2gOGR1Z46iEiE2MmQs2Mp59K+whPrtm1Uck9ru+6bmn?=
 =?us-ascii?Q?yx+Bgh6abJ8jFlHz43SFNnucpuFqoVwK9GIdRGmooCREDT1QQ5Q7iE72zgt2?=
 =?us-ascii?Q?G7VPbJ8ZCs9WneMVGsZZ2qNJXhFmvFBxMFMKtRMELPR/5lYGwwXktfYXx35V?=
 =?us-ascii?Q?3g39FXAIvqyKGFNeOP/opP+2miLFztkT61ZQzoCzDsMLF0PH/L7fntc+aaWR?=
 =?us-ascii?Q?P7QP19U7Ol1uNvMnmPxVbBLdHmYaPtWX/cFgo3vE4lTzwd+b8Sjtql9cJ/vW?=
 =?us-ascii?Q?rvDUft5kzP7eTX2xdSyV274a7uE00fiuClWl8Aah+Y7eXBGaa9e41PaPSJHn?=
 =?us-ascii?Q?b6vPy6U1FGoHYmY6hBV76KHoirLUiXCm1G57N2YE/uLed2jcOagaGrL7JVQ8?=
 =?us-ascii?Q?GsEDUJx0DWZf+voq2JiaCTsUhayi0lGIc+WNNwTA67ymwnGJ8aiaSNn2MOmR?=
 =?us-ascii?Q?ZPJ5qYk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mOK3rh6LghXMdo5/gCRmEB6AGpAfYB56qtUl/uEFbVHIYMDGLdFoo8eyeZUh?=
 =?us-ascii?Q?Y4X8K/74Vx6jOOLiOzXBY0uQck0cQSjsGlTj8JcYTpFoZ6W9qi5zsyuUW26t?=
 =?us-ascii?Q?XJE4sI5GYX9DsJgBRKqXfyyK8YA+Ex+8REepvCK8/i40LYFcfmOQhiSkTTrR?=
 =?us-ascii?Q?ISJ0HFVU1rIzhsZ9zj00ih6lWm0pCA4QLGUOKSMEepj6gAxNNhZcOgt8SAut?=
 =?us-ascii?Q?V4qI4SDa2mwYJmLBBPxRTcY85XOyZImTJFagG/pTreZ5zFMfM8r/qJNiT26r?=
 =?us-ascii?Q?OALDGln2Qxjc20B3AR+r6ziXqoVcjrrGsIn9PSQwwA06fXIoCtRF1ehoDtGY?=
 =?us-ascii?Q?bzqDlmiLj0q71G56ZftFR/1qROWGe3B8C6sQoCgNudv96FArTrK649gSuBud?=
 =?us-ascii?Q?ClTml/ZvQtAyZz+ZFzQiJRlw23Ldr72BIAqkL4QOh4V9fYtcWru5w0FD1Q5F?=
 =?us-ascii?Q?Hhfacnsc04txXdf5i9VHX866Ya8512jlZBeh0YZPzRcKQTI82lGZSIxbqlwk?=
 =?us-ascii?Q?MqEhN74faKUZmTMB+jGnlk5CfoyCcxiUPybIUCowYtlZbDYS3F14LXK1gljA?=
 =?us-ascii?Q?FKcF63g6dnOMDHBozCj0Lo56KTQaqoiG4q2Ina+5c6eXGAsCG75AnnZRyaq8?=
 =?us-ascii?Q?jk4h/ufGJwSSYpsdskQ7OnocWwqTizKxiOVnzGsWRCTAMvs5VdDGTGbmC5e9?=
 =?us-ascii?Q?iCOaMXtdhM5PejPERJFcqPnsXg9hV8KSlKUBdx1XofFXqh1Q1J8zPdK3A4DZ?=
 =?us-ascii?Q?ojM+rGSE8ieBaZZ4Vo+/eTkzN/MD5pS8oUgVKIM/faPG0KyS9q8LAyO+wRbw?=
 =?us-ascii?Q?seup5qHA7m4FlF7zuZ1qAWeEOuW3H3l81IxDyhw2P+AhdWdJDcsMWwEsEjqW?=
 =?us-ascii?Q?3WWs95vKGvKEGMyaiUsfpJUnegarxh639bPUb7L0DfSfYw9baYg43UU1scs1?=
 =?us-ascii?Q?80tUcg/EF1p6DPpiU3gSrYhpVn7iRNSVFIG06L0eAf8gVKuIYQMDz5dXWimo?=
 =?us-ascii?Q?W42BZ03Kz+fCadyQwncbtPQizW3wxp2ohDJ913r5y/uK3VMMxPIdiQ0FP1OC?=
 =?us-ascii?Q?wavHEEvoOPuMmZ1JINAk+G4BwcXUUPugpnom+yJVCbJSZwEjOhVcmJ0517bx?=
 =?us-ascii?Q?WhfrxvFbcXED/X8J8NxUFf/Un3oaOAPRbaKtB68uqhsAGQzLPxTFTOYwOm22?=
 =?us-ascii?Q?uWnlcnkgg1aoCpzQ+fwjN4XCBObOl1gdS2qRviS9UgyhOgyyg0RwCzfcuIy5?=
 =?us-ascii?Q?IP3Tftnq47FjZhrxG7ptf4Xu50rEeng/RnBr5vbhZWn7xVScyUcYSdMYeAew?=
 =?us-ascii?Q?aWpUXLlnwfI5OINxe1oYc09ezFzcHxSS0hdBPw36hm7zRN2xeRUTO42xUmwu?=
 =?us-ascii?Q?H/y3OuMM3JbAnl6VABHzc8ksiKmzV8zo+JY9t350/dt/QP2JnLcXF38cq7Ay?=
 =?us-ascii?Q?PCNT7MloRpxP8npcNcf8ZDP0vJm58Ioh4VI77pkrSCc3OhWkTZI0pBi1V85k?=
 =?us-ascii?Q?aiHDO2HovZ8/Q9T+O+ZG7Y1K31jSMoyjlCCujE6j7DB6hWMvpzUsDXqB+QEF?=
 =?us-ascii?Q?jhPdaskTgePBtGqkGG1PHSbLIrvIJcdAGjEsrSr0?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	FE5ZHidk5yJWdXRjPIOVYDeH6KLnm05jiFuKDZpHVM6EuC5Tu2pExuAxhkv+cprTXh4nadGsMd10/+nMTpoi8r0UdiTxm5comOILKtGPRCSAv/x9KhRK68rQmqc0Dg4UvvgUgNfIBXYYdfyP1TsFuB0WkbITartEq4gfDBnRkcxS4ruyneFxT3s64dURGsFmV9Kd9zsQ3DKrA7q3uZDv0ueT/12K+Wcq/4Xf+ZbkJl4zmRO7l05r4H5A5k/niRTfVjdLPWPmeE/Bsp2beYKwrx00W5q+Y7Dsf6KRBjaotfTyzBtm3XUKf+UyIwlDmcmg7U5iyYJrFUiOLHu2OjHmuke6cYolR7nxZzSO31Gl9ulJG1zI3kTcHY9V63HqCgIu3IoDNiiPGoQ33/se7P5iLx+6RsCIJx4cZJ8GE2X3egLSbpmQt8ptIG/SktEWzUjuaXvbrZZ35LS3hztS8KRHjI6RLCYnnEw+OV6RyqzweSMwIkGMm/FLkY4CZ9q+3UXRDoInHO+ymbnckSwnE3aw5RUeBvdVMOWpR5wtAtz70OMg0CBNdSeaDckQhQX4/L67/svVz35HHD1zWaJ5q74AszI1+GGXft0rHDQlQylk9/Q=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c360d6e-c8e3-4f46-179a-08ddd5cd47d1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2025 16:13:00.8148
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OtVFvBC4O4EqMpsdzmDZ9cdIhagvFm6IlSDNGotQuoMRmknHz9YImY1XEUljVHZ+juqXgxL/Da7Mf7Ubgd4DEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4141
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-07_03,2025-08-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 spamscore=0 adultscore=0 phishscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=746 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508070132
X-Proofpoint-GUID: 0TPgCniPhkNDXF4GNJMaooVqFEFZwH9n
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA3MDEzMiBTYWx0ZWRfXxk0CPiEHlTIJ
 cAS8IH0jWUR+LbsoO0ek1dx8s/jEEOcPqxg7niYvtOxe9VztGPufPo6HqDmxVEvT0qYeWojy6HD
 VXPNUqwClr9SaHJc98BxySzsPV4X1XC3udM/A5y8Cu8lWsLY/ZJEXm98RnbjkAMck+IGL3y3Qpj
 FjIE6ZAN+x7wcgOeKq+sRtxWOPEhqKHornQp2kwgXcFyPMXOe1q0oWmcPmMa44VjEAPaOBgdAx3
 h9dQWR3R2AQqx45A+J02PSA5fwRIf/ztHcOrRwvai2pYi6lKJ9dfBYb7jXxAa6gWsDXeRP8ZTSl
 tP08UJnUsYSKVqAZ7QYdPqB1YBtnvkuRikSD2yuN2Igd55yP1SnCQnSjI9ltFRh5ysaBILjFxxw
 FYk9+rQPINqK4ycdC3H/x8LMEFwzTFJ8bIAiu9h4yTjcI3NA2NYpFvbwsZAbgVPDBwNsnCsf
X-Authority-Analysis: v=2.4 cv=Y9/4sgeN c=1 sm=1 tr=0 ts=6894d0aa b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=1-S1nHsFAAAA:8 a=1XWaLZrsAAAA:8
 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=fK58h-Zuf5DRtu7DNMUA:9 a=CjuIK1q_8ugA:10
 a=gK44uIRsrOYWoX5St5dO:22 cc=ntf awl=host:12069
X-Proofpoint-ORIG-GUID: 0TPgCniPhkNDXF4GNJMaooVqFEFZwH9n
X-Stat-Signature: 7m9ynehxpweocxtewmupjtnyh65ihq4m
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 20F9914000B
X-Rspam-User: 
X-HE-Tag: 1754583217-397778
X-HE-Meta: U2FsdGVkX1+yXOao2SCeUChtr2E40m8vA+cPOwRwyq0hCP3Ti2NVpcK5SL5TFE762EwUI0Wp/0w/jHjT7oAM0TbpfX2nwugciHup42rLNncYZZMHLAg07hMiGrjRxfWa4j9cZQTgMNS2JQDtbGQ0Lrm1aQELB8LlGKnEbZk6kFGDsL9MT3xICXhRdnWK1RWbD1RD/6I/uKq5J4E550Bma6qraf7S7Gxvuy2E0nKYeiD19FNfS8vyOeERcbsu+FbK4tcUK/TWYfAJDW2uRuJmBe8erERlsqX9bC1/8OZwdhluq6hcG4AdtWv6kYEB3jx41Dr3LHvlYVG4lPp3P3mfj5gUqQHIG+FfCzz8J/F2w7cbpZpK2YtYryT3GvOeX8f4zlu9CPJNFQYvQ4DMnCfbT30E/D5EVmOgkvTeqaPEfltxj+2H3+aZvqEVsJOcCcsZ9b48sA97ae/c2E3Pgx615JxuEtGAG1PIfKgLB4Dwp4rp/Bzta/nOgLIkc2G5JtTEZetP4f+ZEMPHr4Oujk4/I+q+08j0FhiQbAXXYklXdav4GCBTxFxSHtk0cfgFwm1jnh6vXJ/gpcEPiaicGuWpv41LStuEzXJs7PaFpncwXqcccSE9HNr8EUeB2h0CitujqNrmoDfKIXnxzsVPIyeq9sLMt5VbssA4V2AvQxEHmuY6C6D2g6pqCz7gGFWLHu0AVlDXT3RpxKXoqaaj+mJKi2MRkHRvyXB7n5RRdGA0P2N81bl3APk7m4TogDMYrLyOnN/BqzTf5EeReibCbnhoAGcARPj0ocUi/RlLo9Ed8rzCQCyohB0Ln403GQNqryZqv6/Hgy/10UpOAeWpw4gLk2j35YiHl24m9itqx+muFSJhyaVxfxIRasrWvdyo69lGIhDX4C4Eu/YTKVorvOb1GdmZaDbLPoldB8HtxxhDXg/BhbwqKoTJMz/+vTvDrqSsfEpYPe4pWdDhXjdLCR4
 fLpYYnGS
 El52b7gxHRCzvm5XTZQ8mY0+3anjYwaS5e5qecHCLTqgyGcPqDd5VIHXowJd4+sOwPtmkLtmH1UdoHw8jcSYbEzUZgKe9SXRdLImglWXpios3bZfxRn/hqMX39mh3+0hrnGLjTwD3rvCNOvJ7K1cJCH8OhgfhdX1MFM/+8+Up3oQ3eWe00kOiBHNfeBxNQuR6U1gSdB36ebLX9MkOIcuWx9wzAdtPclaFLj/lZwy5FqyB3fzDINKjpA1z/ZcSnx9HT3JDWpeTb7ZkP6llr0muXEiPg0GjnQZax24PUoftUP15c4306oQDMfp2UJQViCaQrBDGk/twYxGcxKCBF6Q6vvZ5Q75vlA3R/EB05GHD+6Qf+uga1UvNAFT3qzeEo/8ubo3WiBaOkJLMm7MsGhFlAWCLwsnQdnWUZ6sT0Uvg4EzayZ50MfmBibLwlFsULcH6HyGXi5qYAd2PkzcCsY8FVRluVQ1o+tTztkMJhq4No0Nuw420BOaDIL1aJl9fcBgzbG9fJwYA06whzq+FML1PmNc+OxGrWZO2wz4q4ndmUseW6Yta0rzNB2Io4qlJ2xwjdYrBd6kIneojZBI3zNo0LG/+1b4g1nNGRhHYNbQhqGdLaMtvTBJLlEcIc7nyyQDUCmK5dZIkxDWk+KOBsJ+jnnnIbbz7UlhhZjPWJtPjFf3ei17c7qeSj7hDUo2LZN1hpf8+tb3d+/piWX6TN+lVO43DcrnWHVLBr1gvw607pv3R37olKKhHvMAoWXuqSjoA6ZTX3oQ7viFlE4i/eonq1sQX/f2hGYUYD5LKzyWtsf6KL36/BXfuQsEFTvGsFA7dXksIbDz/vonJjPRhqptUZ/vMkk/wEPUMeXsFueckoRfBe+5Zw0R911n/Pdc1H+mAspYPa/KVAZm+Pa3onYnOse+2d85lFzP+kh/qq/ZqAv88QfvqUPDBPWnAi9m3KV6tbxMcLNTKu+uLRVzbKs7meKP22w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Alice Ryhl <aliceryhl@google.com> [250726 09:23]:
> The maple tree will be used in the Tyr driver to allocate and keep track
> of GPU allocations created internally (i.e. not by userspace). It will
> likely also be used in the Nova driver eventually.
> 
> This adds the simplest methods for additional and removal that do not
> require any special care with respect to concurrency.
> 
> This implementation is based on the RFC by Andrew but with significant
> changes to simplify the implementation.
> 
> Co-developed-by: Andrew Ballance <andrewjballance@gmail.com>
> Signed-off-by: Andrew Ballance <andrewjballance@gmail.com>
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> ---
>  MAINTAINERS               |   2 +
>  rust/helpers/helpers.c    |   1 +
>  rust/helpers/maple_tree.c |  14 +++
>  rust/kernel/lib.rs        |   1 +
>  rust/kernel/maple_tree.rs | 286 ++++++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 304 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index dd810da5261b5d664ef9750f66ec022412e8014b..b7e7308ce07c050239c14c4f3a0fd89bdd8e8796 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -15956,7 +15956,9 @@ L:	rust-for-linux@vger.kernel.org
>  S:	Maintained
>  W:	http://www.linux-mm.org
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> +F:	rust/helpers/maple_tree.c
>  F:	rust/helpers/mm.c
> +F:	rust/kernel/maple_tree.rs
>  F:	rust/kernel/mm.rs
>  F:	rust/kernel/mm/

We should have another section for the maple tree, since it's not just
used for mm.  Your stated plan is to use it for GPU allocations and the
code doesn't live in mm/, wdyt?

...

Thanks,
Liam

