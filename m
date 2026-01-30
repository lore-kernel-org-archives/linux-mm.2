Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8D2CE6BF10
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 21:01:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A82F6B00BC; Fri, 30 Jan 2026 16:01:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34A6D6B00BE; Fri, 30 Jan 2026 16:01:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 100B06B00BC; Fri, 30 Jan 2026 16:01:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E69896B00BA
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 16:01:15 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A7FB68C362
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 21:01:15 +0000 (UTC)
X-FDA: 84389850510.20.EFF69E9
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0892E80010
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 21:01:11 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=dM3jaSYT;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=pDKiOnPM;
	spf=pass (imf02.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769806872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5NvHNWgh0z3jOXwBLQYSIoh1Rxui+PQGVsVsGs8wmOQ=;
	b=LG9usv0G0ISbw6aoONhFQuRcuBrGA20BDgCGDbETvfCG4ehhSWf/8C0pWn1yyCgNL2l/b1
	Sgj/yfZ9Mk5IOa6nOo877vF+jM12xaaLpZhKtGpwzLPfS0eL4RKfm89mVG0nn+KhwAb+kI
	dW0b2bamtiMP1eYmJ/OiOtPTqNs+7DI=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=dM3jaSYT;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=pDKiOnPM;
	spf=pass (imf02.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769806872; a=rsa-sha256;
	cv=pass;
	b=XNuEcwxs6yH/Gvpw5KhkdRtHuzUKUmdqWQGVpkLA+wnSeD3wj4UsmsKb0YgNuCGhUMWhh+
	xLzr4u6j2Sibc4QnMpuo87Vv3tuBhWybEYiMsTZCm2g9yoPTmecDDWUwtlSP8xmd7iC9N5
	GZtQ3+O4O4GT9DsfwksHLZh1xjOdReA=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60UKDVsR3538874;
	Fri, 30 Jan 2026 21:00:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=5NvHNWgh0z3jOXwBLQYSIoh1Rxui+PQGVsVsGs8wmOQ=; b=
	dM3jaSYTdXuHrOM6C+XpVcN0PhCHtq+fEq9Jb0xqcI3+1TulBMpaOX2xUpWc803o
	KtKTyaJkze41k5kN1Ump//wkCKnHBs7Sxg683SsS163i3wZEf4uG6s9t8MtZ/HCY
	5n4Yx5q3JI9rUP1UdWX2Ysc2lSkSY36Kgwi8EKllIyNBYpGo662sepUndSFVhEme
	DzwiyK7z08XjahGGiv7JhlOicePbkDexJlp5DfQaRXZZLCBevNaI7Gmo2RGUXFgG
	mFsRXlACjZUW0oqDx2MbBV3kh/qox9/hYJCibI/ZETlnMcyk5PaszwhmuHvtkfw8
	g6jB5wJz6pAglWbPNbvddg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c10b2rcrk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Jan 2026 21:00:34 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60UIkbKF032726;
	Fri, 30 Jan 2026 21:00:33 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010008.outbound.protection.outlook.com [40.93.198.8])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmhe4g0t-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Jan 2026 21:00:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Az9LG3CTYQao5L6h3n48pvqA4jzvmJskNl4zZtls7QJUlnxAC/b42WXg+QwYo9Xem82wUCNGzUO6NVrnJDI/uY7F0cVsXaXBkOTM1XXNAiNF0GMFlzJczj3HELn3PzRrns8dnZF5w43YenVeCNtmar2IwEbcMUBxb/kG0Vp293nu+n5q/f0NG7AFfvfFuPu6j1ZkJmxavaYKGqTLdKhOAymn6v1GsKn5CzGQTMNJGp5TzHSnDzElrklkskN+dPqRF4xAeODgWWNy3R+BzCe2aJTWsMG5OYT1pceOE3+WGSc+Tqqsig36AJbCykI1IkfdZ4Pg5xT60sAzzsdkFv0hyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5NvHNWgh0z3jOXwBLQYSIoh1Rxui+PQGVsVsGs8wmOQ=;
 b=ODrm77o4VJglHeb/cQJEmoE/zfnkGJ2UnE+auyuD4fWwO0Dqet5nRDdgyw+vqawO0m67nqnhXshGLhh6gJOqRtl2rUF2L6NgtImRTBaKkwGuJ+QykkHno9BP4eoCz/tPFaKfxwRXlNPb7/tT1e2I+FZsypKL2cccxW4IuAKMLcJ99ufyIqza73f+eHlwHgdErsZHmJA4SX9zOGrooN5U7b7TU4ynnb2Sjc4dO3gInsN+Y3ZqrZaE/xtq9i1FCizvNptX7AMxaNtMZCl+4pDDJjR4+9yht/gq7vrBpLqXB40MYSOhHLqhS972khner/pBjicHKCL7Ne6JFeGsNR7mRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5NvHNWgh0z3jOXwBLQYSIoh1Rxui+PQGVsVsGs8wmOQ=;
 b=pDKiOnPM8V8RS4DZcrc6tYC+iizfPtlwzEmRwXHcXuZybWGORvwGhYgDQuTvnj8saxybadvtkk6fycwkYFNed3c3jLBWDV7XwoDaEHeAYeoEzxl9LidAvniFeUcEYF7fJqV3qAntYXh65jvnjwe7nGBPFZ3jHLCxO/jwbItL3Fg=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by SA6PR10MB8061.namprd10.prod.outlook.com (2603:10b6:806:43a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.11; Fri, 30 Jan
 2026 21:00:29 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9564.007; Fri, 30 Jan 2026
 21:00:27 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Sidhartha Kumar <sidhartha.kumar@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Alice Ryhl <aliceryhl@google.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Arnd Bergmann <arnd@arndb.de>, Christian Kujau <lists@nerdbynature.de>,
        SeongJae Park <sj@kernel.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH v3 12/30] maple_tree: Testing update for spanning store
Date: Fri, 30 Jan 2026 15:59:17 -0500
Message-ID: <20260130205935.2559335-13-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260130205935.2559335-1-Liam.Howlett@oracle.com>
References: <20260130205935.2559335-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4P288CA0034.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d3::20) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|SA6PR10MB8061:EE_
X-MS-Office365-Filtering-Correlation-Id: fd270d23-05b5-45a8-462c-08de6042956a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?pXg5sBUZms0TfvqFsVMivqM5n643y7K31+pgOAFgGAyar+cfyo74WENo2B7v?=
 =?us-ascii?Q?i/i5Rx1wJJ8VuC/bTQ3ZZ0PNVGJmdn2H9kbCtq6FffQ6UddlvcxO8Wlpkvd/?=
 =?us-ascii?Q?bk594anzwAwF1YCCUwWoynB01nn9Rf7WoMjZRxLYPvSC9jBJxFrkT4UokDYu?=
 =?us-ascii?Q?AncZJx1pbk815Hatu3poVjgYPFN0/f8lOJ57RLhkSBngy414G4wWib/4PZ3M?=
 =?us-ascii?Q?kyNc8KzhwEqvwTVu4eFWy2A3hT5spzKb7N9RN49se+fn+QmfPcAVQ2SFlTKC?=
 =?us-ascii?Q?igPaj0sDZqb6cSyarJn8HepV+8d3RBzU87NTLr7N+hiHrMfYWYEIB3arS30I?=
 =?us-ascii?Q?hJ8GFAGhKaJOt4mkYqUYW5y/M0KNXVGeDPCST6vKYE8bsQ6Xic9LCKSlGGTp?=
 =?us-ascii?Q?yU47+tS3McAwXj7Z+l/9Vy7Tch8Lm8Yz8wbw0UP6oXnEoZ/Pb9cNUmAJECEh?=
 =?us-ascii?Q?tWoxuCxlRTHqPJz+SfvW/oVWDKp7ITgZf6pulB6piM9HgwPOdJoXfBmYVCTy?=
 =?us-ascii?Q?61MdsPLVYTY7Br6yPCViAx5XczoDIMwZ0o/ragQR1dRMvxuTqfIb/E0wMhhT?=
 =?us-ascii?Q?ukb35+NoO1VlyOyuZvu1XVrHE4bxUDyTjYavggZC4fG6xrCr6pK834bub/cf?=
 =?us-ascii?Q?VgBBktQ48sIO52TRXl3z81uF4tqpVSu6mZVyDOfXHsRMlT7sflF2m2cwAt2h?=
 =?us-ascii?Q?Vedt5SGsKdAFQkvLveD0KV22vE5Rcxfnnmc0uPGFp2wdlKy8BRCqLC27Wxtm?=
 =?us-ascii?Q?wn091Tbu7QOC9ssdrvyfKslZygnR+TYQq3xKUVR+6dCcfW9j3QLJrGyQtUiW?=
 =?us-ascii?Q?PGaWGGlfbKqTVwxj11DGlxQxjqKP5bewzassrLe3fDyLieDE5bA2PFxK+AKn?=
 =?us-ascii?Q?CVNeXff4zaZweReMNUub87jZ1Wwl1luG5sgJ2+LjMPmE8Cm/A074D+RfQdPq?=
 =?us-ascii?Q?PRxRZzCgUVS7IQBZDrcuEIdIEYYPlsxrtrNsLTgil/CEmxNIkG7QXx7PrQXD?=
 =?us-ascii?Q?CbLwwrDcjRdZxEaRDnyGWDj+TFshHHbmfHTgfTKtAEAHZWKR51dxs+uQ2NW/?=
 =?us-ascii?Q?QreAmXTl7SP1miIOw2/jaIpjCnVXLK22FPnuqWxczaJQQRO7OIyUidLtFWYe?=
 =?us-ascii?Q?J0EeOZCvu+/QJB0HTDDmNzC6zafm3y0Dn5s1kbbR8fpgagE19mtPx/58+w62?=
 =?us-ascii?Q?9I1NXWqePyQOHSsrcRyfJ7ioX3PyJhwbI4GcLpO/wRdWoTFh8Vm6Db55lEy4?=
 =?us-ascii?Q?h1JDX9jkXqA57HX63rBEFrZYlk9n4N9fNqPSZyi8xdUqwI0zVmbn0oTMuqLj?=
 =?us-ascii?Q?TcvzsOuCIOw61duDqTYHJz+K89tWxMwX4ttSCdwVXuXyw47fTSPa/fZSl8a6?=
 =?us-ascii?Q?UlKtJVd3OKu+drpk1j4pRf88dvaG2kNeVzAkKVc5HegVmzqHj1p+dSApmMF7?=
 =?us-ascii?Q?/w1iQ9IpRxJSAwDmoQl9+qN+W5n1LrIpS/AirubwEAdoQOcg+xk8g4rPVt7s?=
 =?us-ascii?Q?y4LXQp086WJo4Sqal/oH2ZKYSVyzI/J2KC4UxZz0Y1hpd1ndtHSUaNQ8mp1d?=
 =?us-ascii?Q?04A9N+WQJoGBxPvGxlY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hvTLHFb58zkX68LhR2AI76iThncnWKnemRfuKtdag6pTCRlemXTR8NgpI3DP?=
 =?us-ascii?Q?rxva1G7OpnI7AdS/Yaee3b7Oq7QD/LK/W7Epfu3VodRGUIK0x2ldWz5EyAL3?=
 =?us-ascii?Q?JtktI2b+2rj7bgohGX0vJx8q3yeiK7P1N5QSK38TO9+3kFH9IywrwHuwMJ7J?=
 =?us-ascii?Q?quheYeGatedCKkWcmzs9bkBImS3GqXx5FB6Wb7VUiEwaJvpBL+2CUAZtxE0T?=
 =?us-ascii?Q?YVIX/boU9ccNNNoGquUcCZvEaL1tpqq8i8mCO+/NzHzdRlRJa20w7rs3DFSd?=
 =?us-ascii?Q?KI+pAyDEcq13nlKcVjHDN+ff96HJXl80E6hljardB+bCKBx1GS6I/YfxmpdN?=
 =?us-ascii?Q?Y2gVtz0aaElX8EeydSqCI74lXEMzBPjryu/FRmCTPasOp+Z7H9thWiqcqSXI?=
 =?us-ascii?Q?QueA1S+xxIFQxNvWp4s+JFY56d1Pz2hJQ7IuOM7VOygk/E+oZY0MTXhjR6B7?=
 =?us-ascii?Q?QdQT8+Rwjs2e/72TOC7DsetwpBATl/kvSRFCBa17dl+JXFw7/Kw4MVRSB16O?=
 =?us-ascii?Q?IgbTjE3lBVvrOLGa1IqkxX5tiAfnGL3KM3u8RHW/h7hxxUBH40orkNdOnOBW?=
 =?us-ascii?Q?pSIhFDDFaTB4xZLclqd43QRLObHwy6Rl30kDWQNB1XM5S7DBi0TT+aPQNG/0?=
 =?us-ascii?Q?wjGi77syWhTnvKWP2kD1/wHcYf0Nl+rAwo5VTZC9rbaCrt9bsVOlMSlEDnTD?=
 =?us-ascii?Q?JkSUYy4teU0z5gPvOANJeuVUPn4FeeP/vTWrBQu9jndy54VEN+9/48tig1Fb?=
 =?us-ascii?Q?Bcnw1FjbzgNmyXUZGAw4/TdMla3EVeeFGVC6DVe5qVv1HhdpEM/ANy94nYs/?=
 =?us-ascii?Q?kJoeU7e/FYNuwbFbgqrFCieTNqQRVdOz/pkDPmLvXDqUT5jXA2rDhKNGAmIz?=
 =?us-ascii?Q?3VWdwH+ptquyn/Yow/a1i7YlimiBwttzKOWBTuQCy8fC525Qi4eJgn/apFau?=
 =?us-ascii?Q?PZYydRP7hpK7gfwXqRLsNm0schtHnxKK0jSU+btWJ+66j2p9rbn/QVcYUxt9?=
 =?us-ascii?Q?KRoqez/0dK6B4qPTOutOlFsoD/QxK/WesWVR13qyORHobGAJUePUDPdx629+?=
 =?us-ascii?Q?w7jC9l5xBbg4MIaHDTb/RvBtPWG6vitMKL3VEtvK5BVuu2AAh9rc8/RQfX1W?=
 =?us-ascii?Q?WhPWg9pgDlI4CBUkgMTwTMz1Z7itDzxVn/0lKiOhxqBhioZnoWwahsjwfnbK?=
 =?us-ascii?Q?x5Bxd6LgwYm7qp3D2SgFCOew1nbH3d8IWrQeez3L1H9sdSoXw3X2UnXH3r/3?=
 =?us-ascii?Q?yGKQf2IBXoU0mT3H2HsAC4yFD9hqZTymALGEPlf31yHfRd/95re/S+QRTKH/?=
 =?us-ascii?Q?Vb25qMf4s0bAXV6td7D1sTOXIMI0t4FK5K9Yka7P3YSyLJIPr7/+SGj330oh?=
 =?us-ascii?Q?hy0QakZqF/Rwa/wLjgHDI9VD+BykSdvxfTmWJH4EBoSivJM6VXZ6cNEBRnZR?=
 =?us-ascii?Q?xjHVPnGbHk2JqH2r525qtM1XzelkIFZosa6zYfZbjZECUfepq/O7VNH+l2IA?=
 =?us-ascii?Q?zaomVHr/iUdG6b8Fk0/snPMKE2uC7jGKIpbbRsdRVVyyIvmAFW3IzzdrExWe?=
 =?us-ascii?Q?JLSbLJdPTik8zgIo5aCoZzmCzA9eZTHI6ahaLhf6an+far105nzzQRTrnNwT?=
 =?us-ascii?Q?+1L5rfuJXz1DUZzFT71yjjH2m3qf+QlGg1q+tnv1Of9lungwnVFWS3uhGj5C?=
 =?us-ascii?Q?8vkbXgyIYduRG0mmqulVFmEqY9bt3E4YPTQ3pnnkbooOxmgppOd7W1yUBmaK?=
 =?us-ascii?Q?8DMJ93ZmlA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Ygz44e/cS4JyTdUCPS8+tOxUAtCL8qyft0zw5bmtg7Fo9gIsaLRTv7TOSbVMGqLphqBOjC8xnAKTAub+sOPk36c1q1mQQNsFPaN0JyqmFgUZr0kKpWNOxWTP2jG/yIld5bFrFIRnSs9UtTiqPrIBj9sovX/eGld4XHtcB7hp6ZqJHPaVlgYD758wQNQ7f2s1cxkIKtadwRFGd+vRd0qX76wK3UwtWe7d764u6NpsE8RGJSzar9czfyIB+3Ee8ZctrzXRpVoAW0WvL3e8Q0j32mIIZwwvz3Kxsuka4LDFf9IGPDIe1BtyxJsVyE5RLZXctYHOl4FQOJgq6/R5+0PEXLh54CZAz6/RiQbC8pDHZbbAiviv9ilUkMvtNdZq62/xUwpQXHHQtofEFWhiU4tLLDIHzMgQAxr+EIK6mJvf//BloHtomhsTs4bDw03dSegW8dO5v1yNBcJIfksGCPGSvVlW7F17RV3KZUhOaXjgvdG7EGOyXjhPf1tNx8hru5yet3QGAYqQTqZDtHWoJvNjOtFc3S8liq7v6Ui8ufazfUh8IEge/yc5nsqHJdZWSH/t/Ri+An8DHHi96SWcDaXlPCwueGtxJTzB993Gqh0IMyE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd270d23-05b5-45a8-462c-08de6042956a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2026 21:00:22.6103
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aafhPqdSvcTaxBTvwgw7y/sxf3Q8Sa3zq1nwKMnRmX8jmkkp5WheDL8+OaVQfe3wABCsVrM87DtQRu4eTJFjkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR10MB8061
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-30_03,2026-01-30_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 spamscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601300172
X-Proofpoint-GUID: 4l8rU8vcVpnbecyvpt072QTHKlLJyL4E
X-Authority-Analysis: v=2.4 cv=BLK+bVQG c=1 sm=1 tr=0 ts=697d1bf2 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=t0zg3OoRVwqkdlAMXQQA:9
X-Proofpoint-ORIG-GUID: 4l8rU8vcVpnbecyvpt072QTHKlLJyL4E
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTMwMDE3MyBTYWx0ZWRfX1lsOCmATPNg7
 aytRZS7LUP0K13Y8iRxIAln6J25Aw5R1jcgt8qwfnLXDNT3I3R/0dTa7RJs7xIA/KuJ0I5B2O+P
 u7N7q1e5WxGyaadksEgFgym0AvDAJiC3hRtMXk/7BhSn3ikhpChvbf7z5UgObWpnwgOGUIvDkXy
 VNX8O1fbssJPdxTGPVsIhc8WsDlSpouns7IC/N4er1AeM+ul2nxJkUXDJRwljThdlz2sp1aMd3P
 jdInWL/mw/GeSJTXarBHjcc6hViZPjugK8QJlbMl9buds7tBtcXLuXpmTa5AGo9eNIqVOfmlhKZ
 wwWxP2rxZeW7CrylL+bcSkmLMAF5fgWF9gC85mZlT51kRNHpnpjz2UBe7zswMQcg4nhQ0JMtDdN
 kOnEZ34o7KrKpFjGMfJP9YkOWMlq5w5NMK03lcOQUUdIeCHjyP2RlIjvuCQivRKgwRnrdhYzpjh
 ML0eIW0iKw9JX4ek5og==
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0892E80010
X-Stat-Signature: 7puzkeodred9hcmkcqcu3o1zmeqfndzn
X-Rspam-User: 
X-HE-Tag: 1769806871-908208
X-HE-Meta: U2FsdGVkX1/Js8FdtdXWtmCy90cz7S0N+wypwk3P1/Mb3LfryRZh8q64AT9KhesxKHJJvxoIaZVJDgocrDv3hWo5vPr3E4lO8nIgcis4YcQsVXVvPmQB28U/weSwx04Eb3UMB/EJUFeRMJMcWHeRJRem3bgjS0F1Z7LjXLgpLOrmWBgGNrOdyC8tS7kRQsm0Yg2kxjBnquOpJrmhoiokSsr0yS1fXkfWfuJ5cS+/LVP4hQu2jBmhTVDF+1A71nbrTBHS0AA8RO+Kfo+Ee3zOloQteyT3PeLFQO4XxlLWbH4LMdmZ1qTsb6VFSOlSlEVwwWehjsLVMPNtrE8MOKuC3918riVloCXnZAIDzD63IXuIbbdGGK5+ORsd15vuSPvrQZeoh/t+zkNp4/KZyaFeC/HhoyLjUwX8Le1SgYzed6UHTqWCFu1rHhu2QyfarcYT+J+EFTFZQbNDnNce645mnqgjGxA768KD7zCzS8BPTZPBDbwDmQHcfZN5Vl4kWJGKL7RU+832Oc/a5aG/+DHSKg9MmEyYuvv9uOos3iuAmxuKZ0UbgD4ObbVzHwPQMYoRh0i2NYKyz+Q43eDo8DgYsN8fXwQSTsBrXex6Xc7wrimZWbayY8xTBDMoBPV8BUpOIbnSwGtfwOdzfbmO400TwvXIUdRgU68y0hOR2YGSbckNZzVI/wvrU3Esh/OpyJGXXPk+zAFMs+rGBE3nXE59aJbPhltyBMWVPYQPUrcnrTl4j1QnBqDx8yFM91mjYjPgqjheSkAc0rPzsgUeObfnrYjcx/wvZzf1htBnzNkAqYDcE0fEw5aJ74k+Rrygch43ml/4e6GsPbPQ7HWmUdM9k9vnALPFw4x80jHSYk4vpF7Nv+9cXBTvoCZCEv3jDF4lHm1yKePT2e0ofW3nWrVpyx+JqKEoyLDV5CNhipx/rbVKCbViz7iC/TJ0JC/z76Xmhg2Y15W4Xci6LkdtClH
 T+w1WIli
 UilAAn5pfQqxbVo/2PV8qTwY4vGKMa6Tewvr4WfnCce6WS/MEO7PDEOmjYZysZhQ/0UIFc4QoPbmGwX2U5AOFDUoumrLKZOUPXU8SMV273HEHqT0pfxsz8WzQK2xlIL7B/GcZ+hrMXSQYcOZ9l0XtHdpv1I3xOmfpDuiPoPORfoKS/OTAJ7GKhtbJM7KyWvn44lw45w6OtRD1PpILK7oO/UNmBPNPY7nWy1bf5Fnv93QOnvuDLLI6ge5c6Mz/EgEPpN5mZ0y11cGofgi0lbZwL5nuypG5wB3fWTJEa8ZQ7nPMwUOLJyykQAH3Qxk3X0YKyHHbEt/avdf+o2nzwJvGiJFhoGQRcNza7+j2W9Iih8EPmnvwhyK0P4rGaKRJG1PK1iB1SClC+2w9T35YTctQpDUrrTZN+VFRXtLwzCQLQb2nscSYGBxM4XQeW3j1jWcnJ0fpVh19hcxF/sZ3bX4OxhhIaSDIV6Jn2/HZ4aUUq9sVVC3YrIi9v63wtzYkUqggf/dYSCVIaFKj/gFEvUiUYIaqAffbukvC6WibwCJ0dyH5mvAymKbqLdlAtdyCKG1XEgBbvG6brjnGnbMAPkYFcrR4TdsSwJCIA9+enCVHzCRnCIwwhdhKZZp4oKTOKUTYmF8Xj4VycPEBJqlgdvb7U4Wtx5e1omSsA1/Ewvb7jbhaiYjxmO0/ubRIKi67yHljLzlK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Spanning store had some corner cases which showed up during rcu stress
testing.  Add explicit tests for those cases.

At the same time add some locking for easier visibility of the rcu
stress testing.  Only a single dump of the tree will happen on the first
detected issue instead of flooding the console with output.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 tools/testing/radix-tree/maple.c | 172 +++++++++++++++++++++++++++++--
 1 file changed, 163 insertions(+), 9 deletions(-)

diff --git a/tools/testing/radix-tree/maple.c b/tools/testing/radix-tree/maple.c
index 5c1b18e3ed210..85fb5616c133c 100644
--- a/tools/testing/radix-tree/maple.c
+++ b/tools/testing/radix-tree/maple.c
@@ -38,6 +38,7 @@ struct rcu_test_struct2 {
 
 	unsigned long index[RCU_RANGE_COUNT];
 	unsigned long last[RCU_RANGE_COUNT];
+	pthread_mutex_t dump;
 };
 
 struct rcu_test_struct3 {
@@ -33997,8 +33998,25 @@ static void *rcu_reader_fwd(void *ptr)
 				}
 			}
 
-			RCU_MT_BUG_ON(test, mas.index != r_start);
-			RCU_MT_BUG_ON(test, mas.last != r_end);
+			if (mas.index != r_start) {
+				if (pthread_mutex_trylock(&test->dump) != 0) {
+					rcu_read_unlock();
+					goto quit;
+				}
+				printk("start is wrong: %lx (%lu) vs expected %lx (%lu)\n",
+				       mas.index, mas.index, r_start, r_start);
+				RCU_MT_BUG_ON(test, mas.index != r_start);
+			}
+
+			if (mas.last != r_end) {
+				if (pthread_mutex_trylock(&test->dump) != 0) {
+					rcu_read_unlock();
+					goto quit;
+				}
+				printk("last is wrong: %lx (%lu) vs expected %lx (%lu)\n",
+				       mas.last, mas.last, r_end, r_end);
+				RCU_MT_BUG_ON(test, mas.last != r_end);
+			}
 
 			if (i == reader->flip) {
 				alt = xa_mk_value(index + i + RCU_RANGE_COUNT);
@@ -34014,7 +34032,8 @@ static void *rcu_reader_fwd(void *ptr)
 				else if (entry == alt)
 					toggled  = true;
 				else {
-					printk("!!%lu-%lu -> %p not %p or %p\n", mas.index, mas.last, entry, expected, alt);
+					printk("!!%lu-%lu -> %p not %p or %p\n",
+					       mas.index, mas.last, entry, expected, alt);
 					RCU_MT_BUG_ON(test, 1);
 				}
 
@@ -34047,9 +34066,11 @@ static void *rcu_reader_fwd(void *ptr)
 		usleep(test->pause);
 	}
 
+quit:
 	rcu_unregister_thread();
 	return NULL;
 }
+
 /* RCU reader in decreasing index */
 static void *rcu_reader_rev(void *ptr)
 {
@@ -34119,13 +34140,17 @@ static void *rcu_reader_rev(void *ptr)
 				line = __LINE__;
 
 			if (mas.index != r_start) {
+				if (pthread_mutex_trylock(&test->dump) != 0) {
+					rcu_read_unlock();
+					goto quit;
+				}
+
 				alt = xa_mk_value(index + i * 2 + 1 +
 						  RCU_RANGE_COUNT);
 				mt_dump(test->mt, mt_dump_dec);
-				printk("Error: %lu-%lu %p != %lu-%lu %p %p line %d i %d\n",
-				       mas.index, mas.last, entry,
-				       r_start, r_end, expected, alt,
-				       line, i);
+				printk("Error: %p %lu-%lu %p != %lu-%lu %p %p line %d i %d\n",
+				       mas.node, mas.index, mas.last, entry,
+				       r_start, r_end, expected, alt, line, i);
 			}
 			RCU_MT_BUG_ON(test, mas.index != r_start);
 			RCU_MT_BUG_ON(test, mas.last != r_end);
@@ -34180,6 +34205,7 @@ static void *rcu_reader_rev(void *ptr)
 		usleep(test->pause);
 	}
 
+quit:
 	rcu_unregister_thread();
 	return NULL;
 }
@@ -34329,6 +34355,7 @@ static void rcu_stress(struct maple_tree *mt, bool forward)
 	test.seen_modified = 0;
 	test.thread_count = 0;
 	test.start = test.stop = false;
+	pthread_mutex_init(&test.dump, NULL);
 	seed = time(NULL);
 	srand(seed);
 	for (i = 0; i < RCU_RANGE_COUNT; i++) {
@@ -34414,6 +34441,7 @@ struct rcu_test_struct {
 	unsigned long removed;		/* The index of the removed entry */
 	unsigned long added;		/* The index of the removed entry */
 	unsigned long toggle;		/* The index of the removed entry */
+	pthread_mutex_t dump;
 };
 
 static inline
@@ -34506,7 +34534,9 @@ static void *rcu_loop(void *ptr)
 			/* Out of the interesting range */
 			if (mas.index < test->index || mas.index > test->last) {
 				if (entry != expected) {
-					printk("%lx - %lx = %p not %p\n",
+					if (pthread_mutex_trylock(&test->dump) != 0)
+						break;
+					printk("\nERROR: %lx - %lx = %p not %p\n",
 					       mas.index, mas.last, entry, expected);
 				}
 				MT_BUG_ON(test->mt, entry != expected);
@@ -34854,6 +34884,7 @@ static noinline void __init check_rcu_threaded(struct maple_tree *mt)
 	vals.range_end = ULONG_MAX;
 	vals.seen_entry2 = 0;
 	vals.seen_entry3 = 0;
+	pthread_mutex_init(&vals.dump, NULL);
 
 	run_check_rcu(mt, &vals);
 	mtree_destroy(mt);
@@ -35250,6 +35281,8 @@ static noinline void __init check_spanning_write(struct maple_tree *mt)
 {
 	unsigned long i, max = 5000;
 	MA_STATE(mas, mt, 1200, 2380);
+	struct maple_enode *enode;
+	struct maple_node *pnode;
 
 	for (i = 0; i <= max; i++)
 		mtree_test_store_range(mt, i * 10, i * 10 + 5, &i);
@@ -35410,6 +35443,128 @@ static noinline void __init check_spanning_write(struct maple_tree *mt)
 	mas_set_range(&mas, 76, 875);
 	mas_store_gfp(&mas, NULL, GFP_KERNEL);
 	mtree_unlock(mt);
+	mtree_destroy(mt);
+
+	mt_init_flags(mt, MT_FLAGS_ALLOC_RANGE);
+	for (i = 0; i <= max; i++)
+		mtree_test_store_range(mt, i * 10, i * 10 + 5, &i);
+
+	if (MAPLE_32BIT)
+		i = 49750; /* 0xC25B */
+	else
+		i = 49835; /* 0xC2AB */
+
+	mtree_lock(mt);
+	/* Store a null across a boundary that ends in a null */
+	mas_set(&mas, i); /* 0xC2AB */
+	MT_BUG_ON(mt, mas_walk(&mas) == NULL);
+	MT_BUG_ON(mt, mas.end != mas.offset);
+	MT_BUG_ON(mt, mas_next_range(&mas, ULONG_MAX) != NULL);
+	mas_set_range(&mas, i, mas.last - 1);
+	mas_store_gfp(&mas, NULL, GFP_KERNEL);
+	mt_validate(mt);
+
+	/* Store a null across a boundary that starts and ends in a null */
+	mas_set(&mas, 49849);
+	MT_BUG_ON(mt, mas_walk(&mas) != NULL);
+	MT_BUG_ON(mt, mas.index != 49846);
+	mas_set(&mas, 49876);
+	MT_BUG_ON(mt, mas_walk(&mas) != NULL);
+	MT_BUG_ON(mt, mas.last != 49879);
+	mas_set_range(&mas, 49849, 49876);
+	mas_store_gfp(&mas, NULL, GFP_KERNEL);
+	/* Results in 49846-49879: (nil) */
+	MT_BUG_ON(mt, mas.index != 49846);
+	MT_BUG_ON(mt, mas.last != 49879);
+	mt_validate(mt);
+
+	/* Store a null across a boundary that starts and ends next to nulls */
+	mas_set(&mas, 49800);
+	MT_BUG_ON(mt, mas_walk(&mas) == NULL);
+	MT_BUG_ON(mt, mas.index != 49800);
+	mas_set(&mas, 49815);
+	MT_BUG_ON(mt, mas_walk(&mas) == NULL);
+	MT_BUG_ON(mt, mas.last != 49815);
+	mas_set_range(&mas, 49800, 49815);
+	mas_store_gfp(&mas, NULL, GFP_KERNEL);
+	/* Results in 49846-49879: (nil) */
+	MT_BUG_ON(mt, mas.index != 49796);
+	MT_BUG_ON(mt, mas.last != 49819);
+	mt_validate(mt);
+
+	/* Store a value across a boundary that starts and ends in a null */
+	mas_set(&mas, 49907);
+	MT_BUG_ON(mt, mas_walk(&mas) != NULL);
+	MT_BUG_ON(mt, mas.index != 49906);
+	mas_set(&mas, 49928);
+	MT_BUG_ON(mt, mas_walk(&mas) != NULL);
+	MT_BUG_ON(mt, mas.last != 49929);
+	mas_set_range(&mas, 49907, 49928);
+	mas_store_gfp(&mas, check_spanning_write, GFP_KERNEL);
+	MT_BUG_ON(mt, mas.index != 49907);
+	MT_BUG_ON(mt, mas.last != 49928);
+	mt_validate(mt);
+
+	/* Store a value across a node boundary that causes a 3 way split */
+
+	if (MAPLE_32BIT)
+		i = 49590; /* 0xc1b6 */
+	else
+		i = 49670; /* 0xC206 */
+
+	mas_set(&mas, i);
+	MT_BUG_ON(mt, mas_walk(&mas) == NULL);
+	MT_BUG_ON(mt, mas.index != i);
+	MT_BUG_ON(mt, mas.end != mt_slot_count(mas.node) - 1);
+	enode = mas.node;
+	MT_BUG_ON(mt, mas_next_range(&mas, ULONG_MAX) != NULL);
+	MT_BUG_ON(mt, mas.index != i + 6);
+	MT_BUG_ON(mt, mas.end != mt_slot_count(mas.node) - 1);
+	MT_BUG_ON(mt, enode == mas.node);
+	mas_set_range(&mas, i + 2, i + 7);
+	mas_store_gfp(&mas, check_spanning_write, GFP_KERNEL);
+	MT_BUG_ON(mt, mas.index != i + 2);
+	MT_BUG_ON(mt, mas.last != i + 7);
+	mt_validate(mt);
+
+	/* 2 levels of basically the same testing */
+
+	if (MAPLE_32BIT) {
+		/* 32bit needs a bit more work to fill the nodes.
+		 * The two parent nodes need to be filled (they have one space
+		 * vacant) without causing a split at the store locations (or
+		 * the siblings).
+		 */
+		i = 44426;
+		mas_set(&mas, i);
+		mas_store_gfp(&mas, check_spanning_write, GFP_KERNEL);
+		i = 45126;
+		mas_set(&mas, i);
+		mas_store_gfp(&mas, check_spanning_write, GFP_KERNEL);
+		i = 44790;
+	} else {
+		/* 48950 - 48955 => ptr, 48956 - 48959 => NULL */
+		i = 48950;
+
+	}
+	mas_set(&mas, i);
+	MT_BUG_ON(mt, mas_walk(&mas) == NULL);
+	MT_BUG_ON(mt, mas.index != i);
+	MT_BUG_ON(mt, mas.end != mt_slot_count(mas.node) - 1);
+	enode = mas.node;
+	pnode = mte_parent(enode);
+	MT_BUG_ON(mt, mas_next_range(&mas, ULONG_MAX) != NULL);
+	MT_BUG_ON(mt, mas.index != i + 6);
+	MT_BUG_ON(mt, mas.end != mt_slot_count(mas.node) - 1);
+	MT_BUG_ON(mt, enode == mas.node);
+	MT_BUG_ON(mt, pnode == mte_parent(mas.node));
+	mas_set_range(&mas, i + 2, i + 8);
+	mas_store_gfp(&mas, NULL, GFP_KERNEL);
+	mt_validate(mt);
+
+	mtree_unlock(mt);
+	mtree_destroy(mt);
+	rcu_barrier();
 }
 /* End of spanning write testing */
 
@@ -36029,7 +36184,6 @@ static inline int check_vma_modification(struct maple_tree *mt)
 	return 0;
 }
 
-
 void farmer_tests(void)
 {
 	struct maple_node *node;
-- 
2.47.3


