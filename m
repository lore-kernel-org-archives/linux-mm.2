Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03DA8D19503
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 16:29:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3686E6B0005; Mon, 26 Jan 2026 11:29:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33FFF6B0089; Mon, 26 Jan 2026 11:29:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F7896B008A; Mon, 26 Jan 2026 11:29:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 091FE6B0005
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 11:29:56 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8293EC2926
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 16:29:55 +0000 (UTC)
X-FDA: 84374651550.30.BCCE4B7
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3DCC74000E
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 16:29:52 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=cAyzOmUU;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=nCHObsJB;
	spf=pass (imf07.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769444992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xKBGvQ+Pg7CHqg8qE0LaW3qUsEXlIWdybBV76ZF1UfU=;
	b=iXHN0gTg2bhoQ/i1ivsPZ6cxzCj8QT6DqFIrfjxNyNW2eCaDM5nHiRdfd+otswodkOc25v
	ZsrH7Ylt2tGgh0cx+h4HHn8A07CFi6lyI6FISFDeWugUn9HstwVOnndmsjqyxzKYwEyT9u
	frtmF7UkWVUVnHMDKtPE6IR+qvoFPDA=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=cAyzOmUU;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=nCHObsJB;
	spf=pass (imf07.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769444992; a=rsa-sha256;
	cv=pass;
	b=O8/mYJL3mz5hCfOFeR8MEXc1ZzyinKhjtoOzbfqZmVB6utJeAgUKc6SIDtNrvAeC0cIw/m
	HjcGVQedfW3tcUY9uAkcmZgqg99DPjNZ+HMiCAATRbGNCB1BjbXPVelcJZgoBVDYTOetqu
	8eEzubhLITp5LdsWvXrvec3Dmf8rGyU=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60Q4bOnT488946;
	Mon, 26 Jan 2026 16:29:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=xKBGvQ+Pg7CHqg8qE0
	LaW3qUsEXlIWdybBV76ZF1UfU=; b=cAyzOmUU4W8p9SrfrQio3IHkOnlsKNivyV
	oqu+MKOUJ1yPPrrBwWvuDp2/h314xqcHUGXG+tC86k2qK3zNaBlgTlrbaa0GC4gl
	VLaUCwt8HHQORBSvaaIj+/O4QQt2rQDXW/BBBbdyUpKJvUh/9xc/DotOT9Y9XMiI
	ryjvplYL66aKj1RaKZdsXF16VnIJk+rylIG8Y/lEkWkq0Cxp/1l5GITJtE1ZT3Zy
	lAGV/K7DmZX8g+OxGJtdeB3PLevZvypAKWAQIBecz8PvzUsZ+4t9TmOIps7LaqZL
	Z8nB3EujuquuRrIdFM77UsP1PAv8pco+ohKV3gEgT1goUZ+AoY3Q==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bvn09j7b8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Jan 2026 16:29:25 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60QF5Iat036177;
	Mon, 26 Jan 2026 16:29:24 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012025.outbound.protection.outlook.com [40.107.200.25])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmhmds6s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Jan 2026 16:29:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=V5E185S8XCFxts/fHsC9BiCfVIWVd8AbeA67Y2aJX1HIGW9U+GEdrpVZAkoVGzrVN2rYj0lpQlC2TEGWD0AbJi9jtk9coS4rtZWH/5PbTIStea4DBFfUkRGP6NCq+O0f4XseTVl3YMEvZs8EtOfspM5xcRAFmoUo3aqWiW5Wzn8vrQR8bUfBi4W2mDyzDGZIubIwho3P7l3hBSZzpdLInPuN1zj+45nQs9+HyZ5UZ1mXn633KtarbPJDHN43tSEOJzXQLjsj12ZwglkrrilHXZQh8T1vHy3t9qxVB7WEoNSpn+FgLDjJzX24ptLS/2S/i7oQLVlZWm8AOi5yXI9h1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xKBGvQ+Pg7CHqg8qE0LaW3qUsEXlIWdybBV76ZF1UfU=;
 b=k9cqOtzqd6ocZTNi8eUOW7RW6lWRRFayrt/zr7G3hZ1jQq+V0T65UrF3etKRYQmkMEjW/ylTr/2Qg5fOThx81g9DUXeASRxXMpo8JF3xjnzh/Hxd4l21br81MWsjH15hRJmsuUMkf9hOHaID9+46d/4OUP7JL55MzZ/NcDvV2BC/5DcUnL6t5oRZwytZEGMwV8bZS6tGewskyPRPwTzBvEj2klozUt3RVgPrMD8kXtLVJUEqTCvi/FbSVTMwAfJPHsftj4V+mZ6N1b7yL5UhfQt9eP7QcsxJJi646kZF70e5tifkdUWIKg4f1+HHEFsypxOsYrbajk7o7Cv0h5JWVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xKBGvQ+Pg7CHqg8qE0LaW3qUsEXlIWdybBV76ZF1UfU=;
 b=nCHObsJBKEtQ4Utiex9unBw3meJtgZFgOoyc2z4KPf65xCkpXekmxlqMXyQRj7PlSJPqdxSFncNrK8DcLVGAsItRuXOqDTZOF54BPonUMk4E2Ob0jSb7YtNHjOHJ6FvqvmRZrSbMky4+Cy0m7ke6tfg7DbTGZxqr856YJuAHLS8=
Received: from CH3PR10MB8215.namprd10.prod.outlook.com (2603:10b6:610:1f5::7)
 by DM6PR10MB4266.namprd10.prod.outlook.com (2603:10b6:5:210::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Mon, 26 Jan
 2026 16:29:14 +0000
Received: from CH3PR10MB8215.namprd10.prod.outlook.com
 ([fe80::4ef1:fa49:5a08:c1d9]) by CH3PR10MB8215.namprd10.prod.outlook.com
 ([fe80::4ef1:fa49:5a08:c1d9%6]) with mapi id 15.20.9499.005; Mon, 26 Jan 2026
 16:29:21 +0000
Date: Mon, 26 Jan 2026 16:29:18 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-rt-devel@lists.linux.dev, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>, Waiman Long <longman@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <clrkwllms@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v4 08/10] mm/vma: improve and document
 __is_vma_write_locked()
Message-ID: <6444753e-1df7-4732-912a-0ea441f76cb1@lucifer.local>
References: <cover.1769198904.git.lorenzo.stoakes@oracle.com>
 <ef6c415c2d2c03f529dca124ccaed66bc2f60edc.1769198904.git.lorenzo.stoakes@oracle.com>
 <47eafa10-6d13-4324-830a-2e7cf4e67f2b@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47eafa10-6d13-4324-830a-2e7cf4e67f2b@suse.cz>
X-ClientProxiedBy: LO4P123CA0217.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a6::6) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB8215:EE_|DM6PR10MB4266:EE_
X-MS-Office365-Filtering-Correlation-Id: b5412913-8f5a-4175-3380-08de5cf81032
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?mnwRhi5hs3VvMkaLuYnX1efNUxmQb9SGv7TJsPVsUp3pO2BgE9MGIWKiXxbo?=
 =?us-ascii?Q?6R4kaN2Tlu14nSuHk5n5/bvMH+nBBMu3rp0/qWKtqDaUxjVKxjh71hpbeadM?=
 =?us-ascii?Q?i5DBRYuHcmKkGqStSYTEDry+Xh46cwrprrd+mG49Bwsgk3aqsfvdCR6a/xM+?=
 =?us-ascii?Q?OjNRUxmxAnPKnFLkrL6vFmvnjIVSoGpZLj5t+ifWRVh7XQ4adYfyeOohVX9W?=
 =?us-ascii?Q?Eg9c5955L57sornuWl9tybirbK7SRLLofUOI7JR+M0VaMYYSfwN4S3LueOxu?=
 =?us-ascii?Q?MPa3bzNDBKmEH3sccElvHVHtZwfIUe0oubqs3zyyLGVUFGtRj/Xk2fYCaPgQ?=
 =?us-ascii?Q?WhCwAktd2ofyTes0c73lGr7KnAGhJm6F31gSmv6wTXMFvX8nDFDKB6FuO6Dd?=
 =?us-ascii?Q?CWhW8cFWRA4xzX/NN298mE8TTMePX/fMo67PHFANd7yhsSE6eIMxpHc59G3C?=
 =?us-ascii?Q?Y0u9fQI/91bmdy/ftTE/POWKPek1dDHDUfldq/rpoL7i8g1sd+RWynjgKU49?=
 =?us-ascii?Q?PcDo23eRRvTOVHvShdgOIZqLPDouH+34stzOd8MvD/v1l2CCivq4ZH+22pUu?=
 =?us-ascii?Q?96a6DdfQjoh4PTw5mwgzgVOkTS7xfdSvqkBRNQPOljRzmDW/9m5j77j+61Mv?=
 =?us-ascii?Q?IRvqVojKpCEcR35nQ1EEp/pP6gZ+IDjDUpNMyaOvUlXZgwuOjUaU51+eXdwL?=
 =?us-ascii?Q?8ybnN1jIk3eVgbT6Ha2TZ6wH7jR7V89dJ9T+Y6MOuYO1Lf0CvAqYIhQKIqiE?=
 =?us-ascii?Q?x3eUsVrfGxkyCN/7akYvunCE07IlaZX5XZhFho0nv18GTG5SqLxKOTUKxp+4?=
 =?us-ascii?Q?UVhFo+ih4R/n6dfQCNqMrKTKfkp2UAzPTnPDJ+5rcW+xf6i5ynbQUmz32dHw?=
 =?us-ascii?Q?w5KNIxaq9tbv5cOKo4oYW7pYnNK9CJeSYi50Ad2Ys1vpfcFvtDQeURojN9Xi?=
 =?us-ascii?Q?EM8fPY+2hPSYhBJlI16b9Crs/+aBZJEnJtoB40KEY/9ZlTAzFNSsK78UQD3n?=
 =?us-ascii?Q?Y+SERx0C6/tMUVHQ5QUaKknmBKww/PuzZAJvOeG1lD/HS6oO23V9YkjDZ9n8?=
 =?us-ascii?Q?LfmwaWnWrcd+zDPQKOs9iSLvGRYCWaxeeNqj5cjZLZrrEQVvbguHOqrLtgRZ?=
 =?us-ascii?Q?nFupz1q8mGT1A2htPeJl8jHDTcST0YFLDIQfgZT/Dop3mAVlLF3yK62sZvWt?=
 =?us-ascii?Q?JB4CNWAL7xwNE7Y7fDctpX0wyuIDR0RJcVGsviuo0dYBWq3TMheoHxzbFEr7?=
 =?us-ascii?Q?ZRiY+iFFuscR3BKCRiZb2D8YskLaU9UFa/E9/ij17knRvM/XnISJxSiR2bN6?=
 =?us-ascii?Q?qQC6UUPDHIoz78JEOeUjFDSuCPJRgg4M+mmxkvhOmZk/4QlbmRzvuivM4yNg?=
 =?us-ascii?Q?Ep5hJij25Ltv9E4IImQLAPhazyK2KuaFg/SYUsvy6mh6YlINcqt6Z5lKSBDM?=
 =?us-ascii?Q?f9dVEoZEl+TQy7qgpxofnTFfnFlGewEiwJTfGFb7sJcqI/t2CRCf0QO73CIR?=
 =?us-ascii?Q?ZHaWaSL+XUvgz99ckVwIMMgSareWTwsmAuLm0JXDyHqmPSABpmPO4XOaLoz9?=
 =?us-ascii?Q?laq1pJIiy8gU9QDDpT8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB8215.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?defSe4UuND2pfl/UM+T2YlSJcAUjpzqNAm6RQJUL75TAYMIV1xdhJcWEuKgj?=
 =?us-ascii?Q?OzD4nI3sFpXYvWKtExfD2ZRX2abDORcajxqyC38NkYGXxJXHtEpHWmY1i0Kv?=
 =?us-ascii?Q?nZ9F1nTb5sCLXWFDKmTAPtQsE8wyqZfGAq7RauMCl7hzXpu9fUp+2vpNeGG5?=
 =?us-ascii?Q?MV3ZUDjTeXDYS4hhI5iCG5qjYxgL+du/3kRXqVzj2YtM4AyD9NTVolSVPwgf?=
 =?us-ascii?Q?Fg7Gqsg2QMALnvwX3B2Va9rXaWvW6CAbU9dM7FQM6yFNNb2aw0ZvT+AFFtvb?=
 =?us-ascii?Q?R4z49vhOmOZKlNut4qfl6auC7WOq6MscVcFPhRqkalMgz5momD9UNQKzkwov?=
 =?us-ascii?Q?qmGqLp008TPT5/4j9QdkHuajsOu32+4NU6VdG//6nVVwgVQCgrWUPoUp7+fl?=
 =?us-ascii?Q?dfIqwmorI/fyI3Qj49WFA/ZafnM2b8QnBXhgmaETfouSdmyfgPjxqfXXLLUV?=
 =?us-ascii?Q?kYBLPA0tVAvZKoejhLQgw/BWVoZpV9P1ZyqrvXdyyLPaCKtNpbQejYH3k4Jr?=
 =?us-ascii?Q?VBD51QlMoD5dtED7SMurxIxwgbFKWPUdImzN0a5CvvuvDJIB7C22t5FgiK0a?=
 =?us-ascii?Q?RsNjSBPJqPZSkfxYW/f060+sPXF7QbtVpG4U6bzoaW/GmCseiEyLXWcQwUAs?=
 =?us-ascii?Q?q/zpYhcjafRllbw5Ecl2Ayf8JUF1YihkP6fvBkG69HgeFJIQx1lGpeiwXyW/?=
 =?us-ascii?Q?Gphl3Zvx/b29jSGwIO2uRRdbtINFD+z7CV6ScLGjgkuxH8S66EqJASEjJse4?=
 =?us-ascii?Q?SX1pZK0mQDBeDzhIFiHuzPfIep/z/dGVQiWoVKe+vJA3RV5mzCK5rQJw0NzE?=
 =?us-ascii?Q?cradMxYJvjt5Gfa9hKR43CVV+k1u/LR5U3QMLMDEwPa62S4u2a7w2Tt29odl?=
 =?us-ascii?Q?Zs4owT6RtLh9RudeX5F5dbW88aczBzioorLWYELC87uYOUt8xvQIqBMgVGlt?=
 =?us-ascii?Q?F+MqFSimpclwUkipSjH5MdlMXMNO2ZIvp2r46x3aRdMb/BPIyDLP91LaQYuh?=
 =?us-ascii?Q?MdAQb3Bis56HRvukB27njPt5C6I6zrqZq0PGIeGGkUIa42TFDXWye+auXakr?=
 =?us-ascii?Q?e50S7tx0AWh3npV069hKqeWuHlwXpPMiPyGefYGxNiQza5Hcmh2hVJ3q/BOF?=
 =?us-ascii?Q?Zh7h0BUEF1vPDIy6lRJUZZ+S6HeIoR0/c2pEO2weLiQ+fuNFhGVdoA4sQuR4?=
 =?us-ascii?Q?D0+2RZBpYx99lNFxzuGbBidMO0z7MaE1ciwYHzO5hKgabvRqnJ5nrYdsHzX4?=
 =?us-ascii?Q?lBqFIh8i/pWCntL+GQfU8nS6zg21Z85p2x0WY0UiX8Ua80YFE47Hx6B6yFHT?=
 =?us-ascii?Q?Jg7RbWATu1sfQ3baaE6p5TLCc07vqVRRBIYgP3LYHSnXrssFaDzMiMgMM7fa?=
 =?us-ascii?Q?pBrAX9kIcGOoKcjVmwk3+dO1VqtCPRjaDcA8mFNA+7yzVZM7hnGgOoOkfYuh?=
 =?us-ascii?Q?DkiR6ZQevE553FOfBDNK+0tKTTuS5ezJ7bTxsZKT80kj/268NUG/UUcBuGQL?=
 =?us-ascii?Q?0JIzcLmASppf2l+31isywFicm2rq9GEJqo2q31n4XQL8b/gqwuXqG+WRlGEi?=
 =?us-ascii?Q?KoHsXV9+RCm/2+r1pezc7di+AQOhu/pWc1j7Riu3pJE/ugtCI71j8wqd9Ohj?=
 =?us-ascii?Q?byoFnRjloOoGPUDbQU4oYHvVJOjUtOH++KinyxzlUl4QT1ywTVMu4USXOzb0?=
 =?us-ascii?Q?eTk1JvznoN2/OwHHcyx+lK6I8Mz2zUTEkBwNhS4YSbd15AImBicWRFIfW8iw?=
 =?us-ascii?Q?regu8OZOZS41Vnm3f4mCABROU1/+bOU=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	pAS5XhZ7quMFvX3hmxjaV37pG0CBG9acIZI1vw2NkH0hPbHHz2cJ9kvlEHar4E5WeDt5sNLyStCA66Rro+2p+WzPjcRBmLfEgHc1lUipagOW+7Vt5gXNGA4+x8CDyN5MYudA2oVumEg6SmC8M4xUNee5ofskqyZ8NGC6C3UpPV+IfvnraOz2Cq9yFFnDJsglYk/VCsuNf3G4yMLFct2oxe7flI2APLFLQgifMMOZA+hxu9o8hZ6ZvsM6RYXmCX38hRN8QOLMNuvcW24vCVl5QUeBAeCgtiPD/WUAsmMJPXcU61aRIi6hSUhWgcKsuLdnrHGgovcFqjx569GGGK5JqFdcplSD7w+QJ5t7hQVJzF/LXvfOdgvHVtOY9EDsu94BkP35RAe3atcGEbtCJqEho9Bsp+gpWMBDNzw+K9ERJhtY2TVKTgign9eJUd7sDCght2s3dxFREq4iyBIszQNcZ8ACqajY+LOxMB7iSnA5HfzfJgeCGV/TopQIAKaAtJxxWIkX6lu5UCkJ8+tldvylpzCBzs1xXAQXWuDK9ACvgZ9A9Rj3FXd7dJkZnQMhorr7hpoLkYbCAxA2cWj/FKDMAdlScsLHeU1s3PyNbpPaLXA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5412913-8f5a-4175-3380-08de5cf81032
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2026 16:29:20.9647
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: amRUpasGTfMdznoYDyCWuzvuSRFwSewafUG4OyaYtOtTFcVq0Lc5h0J86CxSlN2rTMBCLyM4GyehMX7o0bu3D0ux2oOrc+7CWm7Dx90SJu4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4266
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-26_04,2026-01-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 mlxscore=0 mlxlogscore=999 phishscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601260141
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI2MDE0MCBTYWx0ZWRfX2bIrcmPk3OAe
 zD1EcVD1OQ1Y2YznRmi5xZUJakzIcbfq8MdVnSMJF8S+zytD2oQx7nLbHqqeWsgDRCeZqjPAYya
 vEPgYPbicrCO4Zg/FaeOYhkvgW3kjGBOkFwwg7MIwKIBoZqCsXWz6TOnpsw1e0nRUWV2OE73PQN
 UVGcMdpVNPwHD7PzoboMaLZ1zTeYmLKxX4r2RwwixnSTeE3SJKMC7C5ukt30WUvMaG+2g4b8zKF
 gmrTZycWzJQXYaRfC9hzyOp5lG1gyLUmVjdGKtAp/eD4GFqJj5o+tQT6aUYvAVdNCWMLcMyYpB5
 cvRrDm7yy2zvXo9YFKkhyWG6FF0pxM7bn5j9fqZYhk0K4qsJoaKpMkJ6xQcsp7ENR7vVwJ+grdW
 6kVRwaGkTFKC53qxy/TtLbPBbjaB6gkg4zGOx3mDeSzkRCqX0QwD504kLo9jC2Y0c9/IM8uBRte
 SjuWF/0F4cusOqfCUfUQ9C5dggQyUOlJb6MBaSmw=
X-Proofpoint-ORIG-GUID: -fBZXDZFKI-RGi5WauhHbq8fSt-njJKh
X-Authority-Analysis: v=2.4 cv=Rp7I7SmK c=1 sm=1 tr=0 ts=69779666 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=KKMQIMVjfXzP1t57fCcA:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:12104
X-Proofpoint-GUID: -fBZXDZFKI-RGi5WauhHbq8fSt-njJKh
X-Stat-Signature: uirk6qakcqtaf36t97tiqxqpbu9e4m6j
X-Rspamd-Queue-Id: 3DCC74000E
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769444992-578269
X-HE-Meta: U2FsdGVkX199r1IeuA295FAKXvBRbLY7WehB+Eu/4NhUR+Qiv6DKC4U1b1oCNocfrIZhKFUf6h2lQaV/ylTxgcfsknFEXeOJJfRL4exvuHb4mamOQvJl1G9ewPXlVccl2Cat232636ZEPqsqZOHo+Lu1YFlXnoratTEEu3s4EMC+ePsWLWM1gQnMXuPq+4FC3lPm3sdHpjJX2ia3KvwPam/Usty52DSLhBifdaS6nK6i7FPl10fBEiqMbKcjdrnfOVJUsL/Kd/dqN6yDtpPYIo/8Eg3SZwFgny+Le+XXQMTmQouXHVXlou7U95d4ECUSFny3DVFV9u3klWNsBeV1FXcii6nyqWTtkecGcdn6fMHN2xNZHGL/mkhnPSgdPRYYvx36PH0SIx8lKz4h8mL0keReOOlG5RMZNNPQjdSVKdO9gBcZvb2/xpZBUXnq6TQmWT1ELB+2On3BRzh/gzwgNkCuOmqXSwoSpv6czwcB/FkFLFPAasPMZJHx9P9GBH5Zz0zDL9T6L6/PO3B/Rj0FZc1bhEhDRsKCUwSLM8KEvjHMErwH6ekfpJmwiqCM9g5ksveDpL9/YvD8W0XfIh50CGG85EePQsU2xNmYonvddiNitWuqCpZ5SmULri2PBXZv6M8SfVeO4wDgVsgx5hHx2yIYx0jtU/m7KBTknR6liSZKJSjYPEbun5O8Lsr2t7K1307VsLOMiaEHbg22rc1TnuYNkf/OnGU5sOQVilz1Tt6SfVgZDDd63NAypJZA9/ArZWrUEGK4vrKOLksWA4t8pEqMEv3J8fIJJi2cuxa9gr5O5X5XvAMrVrl5BtUHM043d4U6FLiLNAOsN79gWL1nThxq8gzDrjvdo4ehIOV3lnXb0lYKk/o2+6w/mc6B1lyXv4Unyn5C/JcGtI/vJvsTbL8bbHoTmxkU/8oT2WqiNw9E7egJ+mr2W/lxrGXf7XfVj88Nt9kuOWn8Qdzd2o4
 /jj8NGUO
 aOvbIRuj7ANDswcHau5Cp0YAxc7Dh2MHG+zCSY0bwKP0u4Q4M/sgby6S8vSMoTeB7ug9m4AhccTVteA8Y2319omEDFP+Vyr2OuTDt4Pff6NvJe3v//llP8f6lg3fefWW4fXZABg0wwLPzUGGOJZaA84f2K+gjwTe4wbb/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 26, 2026 at 12:30:04PM +0100, Vlastimil Babka wrote:
> On 1/23/26 21:12, Lorenzo Stoakes wrote:
> > We don't actually need to return an output parameter providing mm sequence
> > number, rather we can separate that out into another function -
> > __vma_raw_mm_seqnum() - and have any callers which need to obtain that
> > invoke that instead.
> >
> > The access to the raw sequence number requires that we hold the exclusive
> > mmap lock such that we know we can't race vma_end_write_all(), so move the
> > assert to __vma_raw_mm_seqnum() to make this requirement clear.
> >
> > Also while we're here, convert all of the VM_BUG_ON_VMA()'s to
> > VM_WARN_ON_ONCE_VMA()'s in line with the convention that we do not invoke
> > oopses when we can avoid it.
> >
> > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>
> Reviewed-by: Vlastimil Babka <vbabka@suse.cz>

Thanks!

>
> Few nits:
>
> > ---
> >  include/linux/mmap_lock.h | 44 ++++++++++++++++++++++-----------------
> >  1 file changed, 25 insertions(+), 19 deletions(-)
> >
> > diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
> > index 678f90080fa6..23bde4bd5a85 100644
> > --- a/include/linux/mmap_lock.h
> > +++ b/include/linux/mmap_lock.h
> > @@ -258,17 +258,30 @@ static inline void vma_end_read(struct vm_area_struct *vma)
> >  	vma_refcount_put(vma);
> >  }
> >
> > -/* WARNING! Can only be used if mmap_lock is expected to be write-locked */
> > -static inline bool __is_vma_write_locked(struct vm_area_struct *vma, unsigned int *mm_lock_seq)
> > +static inline unsigned int __vma_raw_mm_seqnum(struct vm_area_struct *vma)
> >  {
> > +	const struct mm_struct *mm = vma->vm_mm;
> > +
> > +	/* We must hold an exclusive write lock for this access to be valid. */
> >  	mmap_assert_write_locked(vma->vm_mm);
> > +	return mm->mm_lock_seq.sequence;
> > +}
> >
> > +/*
> > + * Determine whether a VMA is write-locked. Must be invoked ONLY if the mmap
> > + * write lock is held.
> > + *
> > + * Returns true if write-locked, otherwise false.
> > + *
> > + * Note that mm_lock_seq is updated only if the VMA is NOT write-locked.
>
> This line is no longer applicable.

Is there for nostalgia's sake! :P

OK maybe not...

>
> > + */
> > +static inline bool __is_vma_write_locked(struct vm_area_struct *vma)
> > +{
> >  	/*
> >  	 * current task is holding mmap_write_lock, both vma->vm_lock_seq and
> >  	 * mm->mm_lock_seq can't be concurrently modified.
> >  	 */
> > -	*mm_lock_seq = vma->vm_mm->mm_lock_seq.sequence;
> > -	return (vma->vm_lock_seq == *mm_lock_seq);
> > +	return vma->vm_lock_seq == __vma_raw_mm_seqnum(vma);
> >  }
> >
> >  int __vma_start_write(struct vm_area_struct *vma, unsigned int mm_lock_seq,
> > @@ -281,12 +294,10 @@ int __vma_start_write(struct vm_area_struct *vma, unsigned int mm_lock_seq,
> >   */
> >  static inline void vma_start_write(struct vm_area_struct *vma)
> >  {
> > -	unsigned int mm_lock_seq;
> > -
> > -	if (__is_vma_write_locked(vma, &mm_lock_seq))
> > +	if (__is_vma_write_locked(vma))
> >  		return;
> >
> > -	__vma_start_write(vma, mm_lock_seq, TASK_UNINTERRUPTIBLE);
> > +	__vma_start_write(vma, __vma_raw_mm_seqnum(vma), TASK_UNINTERRUPTIBLE);
>
> At this point I think __vma_start_write() could just perform
> __vma_raw_mm_seqnum() itself and we can remove the param.
> It could possibly make the inline code smaller.
>

Good idea!

Will send fix-patch for both.

Thanks, Lorenzo

