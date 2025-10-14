Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DCA4CCD193
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 17:52:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F38C38E0121; Tue, 14 Oct 2025 13:52:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F10408E0090; Tue, 14 Oct 2025 13:52:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD7DA8E0121; Tue, 14 Oct 2025 13:52:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C7FE28E0090
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 13:52:31 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9AC43BC7B8
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 17:52:31 +0000 (UTC)
X-FDA: 83997464502.15.53D38A0
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf15.hostedemail.com (Postfix) with ESMTP id 170D3A0007
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 17:52:27 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ErL55cR5;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=mtS2cKaf;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf15.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760464348;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SxdDrv0MOB1F9sY4LC6Xqz2y5TWtSpeC7m+45pWZmu8=;
	b=hNgabSx3mlL+XBfbOdM7kIpXJ+0uZJe0ny5rwosSoH5DMYNIbzddLYzrFL0/ylmO87l1Su
	Vu+z1c4KhLLU+7vnvhrc4q9OWIY5gy7+iN16aFpAgSfv2683PAnG85psfEwixTY/H3qFBY
	epc+8uRnMDqXQ5oCqCGHESM94mXitg4=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760464348; a=rsa-sha256;
	cv=pass;
	b=sArEMPSjO3/OyHBa0LEzjb4SHrj8ViCzjCc6b+AoxmgPFFB1cmvRFd+ze0LNzgw5ovYhpJ
	P6EuAubnxNFZHTZ47NVuR/dOpJKHrrJFlXFxrc9kuDJ/FhNZQGG93atnyShm/4fN8FMak5
	/1BYR3oCVm7cve+LqmG6sUg5zke2xH8=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ErL55cR5;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=mtS2cKaf;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf15.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59EEfKuh003762;
	Tue, 14 Oct 2025 17:51:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=SxdDrv0MOB1F9sY4LC
	6Xqz2y5TWtSpeC7m+45pWZmu8=; b=ErL55cR5KzZNcaU0PWkWvsTWG7h68d+LP4
	DZ1JLP/YteMcEsVJNzxVdWTYi75AqZ5QPsT6ed6reWXoMFBuRpK3hJyGpcZziYOZ
	eeciyXjUeJLBIJwwxuqu2XschQZE0j8UpFkDM8ZxKAF3TaFxAt9dw6mILoQYyPfB
	JZre1hWvIRLIJ2BYI+CS+M5Yvrr/mXjCvk32Wh6XrN+C5MnFul0dcHSch/6dXovj
	fUoQXeJQaVUNaF2rGpU+Czi0uwaJr7U4gApsHgrx+EzzThphnOKbRrRmlgv4zROX
	afJsC5jRXJWb9B5nbCLqn0sCtfP0WgKS+VpP1e7oxKsCT7JmRTvQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49qe59cyss-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Oct 2025 17:51:43 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59EGmEGc017989;
	Tue, 14 Oct 2025 17:51:42 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010011.outbound.protection.outlook.com [52.101.85.11])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49qdp91e61-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Oct 2025 17:51:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wmk03fExfX7Rs599G6FtJ+jcOctg2xu8kgDKDZdmSx4NwwcU3dImz0faIiDMALd6UJK0IZT9fWnwEliSap3n8A24N2uW07jHFdX5rYb4HXcSMCezTC5dNqj2kcfADCDqaI2rqqLSqwYtp7FpBZof5xAR0gMdcmPvVC6lMfUs38loTu6E/JCyVc7hBCJ8KHDQfqvazQYDr5I416SiIPcYnHnVSv0Q4godoZMpJL6UN6riqjf90svqPGlQKLgslAekp7zPak7gEumciYy2gZ/nkETAlx1kOjnZYl8jsPLWIH07crm6W9pLvpHQdGfsj8wViGDZrosU8KQmAi3OL0VQQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SxdDrv0MOB1F9sY4LC6Xqz2y5TWtSpeC7m+45pWZmu8=;
 b=I2NXpjMR4Pfpbu+VFLznvc+7gt2IXVi844jmRVAqFF24IJYfebcDogo++QVUB86zwTnmktrzuC2TXqgOlWJHdE71zRjVzuRbGjjs/492KzGakELn6hcE73c/xnUsatha2N58w9GleYQ1namdXMsapqWGT3wEZJKVnnn5USffTkbjiQiR0L485PMxM6IsxNgeMc98pNuGE8o23X6M4kV04LbGmRNIH1Y47HaNvPSpXz4WB2NlcTKfEzzjGM2lPSR4GCTXZTKXehjKUmC83QZcFLqhAtxPEiXK+/8IZqlTjZgsaFRcQHNN94NJuQXkz8SYJwuQBzcMEJWnz4ba3lb47Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SxdDrv0MOB1F9sY4LC6Xqz2y5TWtSpeC7m+45pWZmu8=;
 b=mtS2cKaf4nidGnTZ+V3nD09jqC6ktoTySQIVB8e+ZCWsEFHEpd9SCSkSM1GkNvV3ke3t4f3eAWWxtMtM8SbRmOKutW9rwFA0jcKrjw0ik4hl3REfklHzytlpyjnD3m6EyyC9N7FJA0/PlBV7EF7UOJU1M/yFKSBkdBLeF43G3pk=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by CO1PR10MB4642.namprd10.prod.outlook.com (2603:10b6:303:6f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.13; Tue, 14 Oct
 2025 17:51:38 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%7]) with mapi id 15.20.9203.009; Tue, 14 Oct 2025
 17:51:38 +0000
Date: Tue, 14 Oct 2025 13:51:31 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Hugh Dickins <hughd@google.com>
Cc: Kalesh Singh <kaleshsingh@google.com>, akpm@linux-foundation.org,
        minchan@kernel.org, lorenzo.stoakes@oracle.com, david@redhat.com,
        rppt@kernel.org, pfalcato@suse.de, kernel-team@android.com,
        android-mm@google.com, stable@vger.kernel.org,
        SeongJae Park <sj@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
        Kees Cook <kees@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Valentin Schneider <vschneid@redhat.com>,
        Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-trace-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v3 1/5] mm: fix off-by-one error in VMA count limit checks
Message-ID: <kqxweui7gdnnwu6gucnn4ez7cwq57xih43p7dgvqa7tvfc6vjg@b4alxiizejsc>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Hugh Dickins <hughd@google.com>, Kalesh Singh <kaleshsingh@google.com>, akpm@linux-foundation.org, 
	minchan@kernel.org, lorenzo.stoakes@oracle.com, david@redhat.com, rppt@kernel.org, 
	pfalcato@suse.de, kernel-team@android.com, android-mm@google.com, 
	stable@vger.kernel.org, SeongJae Park <sj@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Kees Cook <kees@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
References: <20251013235259.589015-1-kaleshsingh@google.com>
 <20251013235259.589015-2-kaleshsingh@google.com>
 <144f3ee6-1a5f-57fc-d5f8-5ce54a3ac139@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <144f3ee6-1a5f-57fc-d5f8-5ce54a3ac139@google.com>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: MW3PR06CA0008.namprd06.prod.outlook.com
 (2603:10b6:303:2a::13) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|CO1PR10MB4642:EE_
X-MS-Office365-Filtering-Correlation-Id: cd4b4899-11d1-4f11-3ff8-08de0b4a5340
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?MIEFVDod94wU6ggASF5ysNWsEhTAEv6+y9a8ZkykoU+BZftFErDXWUnOUMMx?=
 =?us-ascii?Q?6j1hkeeyV+cYqe+6vvmxodwEsiPbNVZPpSqk1p01RYWeoieJBGLdRcyPkrLh?=
 =?us-ascii?Q?liuF7/jE958bH6XZj8bShRMeWvQWGm6IHlsZ8f3pJ5QV8Pe6bHMPxH/RoygQ?=
 =?us-ascii?Q?XCSIswsiIdyAi1SZt38Valii5qXzhryXSfVynE7the2EJGuE91fMc0540vqm?=
 =?us-ascii?Q?RIqZB9lP7XkafLhPXnOlA33lpCoWGcJEfkmNchlJW/5y3fLVaVGZTTOJ2GT2?=
 =?us-ascii?Q?J25wjLzgZSLngseH49bmimm0EC8TMAeW0122jUhWaJTBRhihRk5q+Ul18BFK?=
 =?us-ascii?Q?6UJCTPY0QS8sdBcD2l28k5BZlhQnr/EqAcaEhQrMmmPpK/BkbYvRtHuPeZ/Z?=
 =?us-ascii?Q?sO3j+9juMEF9veZ/qvZUAon5x11pra1D/j9AW/K55dr1Ns/J/zOeGnE5TXA1?=
 =?us-ascii?Q?EsIkU24fHQH2KQLs55xVlXGJrZM7L3yXPbeCuJiHWcvFVzad+e3kpoTFidpy?=
 =?us-ascii?Q?FQ9RvZl8/nxBHVK0CRMZ3IL6HpciHiWyGvb6W/+DLxDreV7/Q3mLAuw/aKUc?=
 =?us-ascii?Q?Vzu6XcBAzIROeFCESfPxgQImKUtaegSomYDk+rg7JTGAFzfDTDB9/rC6nob2?=
 =?us-ascii?Q?o+5njxGkzF92R9xdJdX94SgkCjqsj8fHncNyuzE2CJ6srXMM+f/7B0ihzh3I?=
 =?us-ascii?Q?dkn8hC9VK5BPLhmsutbWxg7biS6tUyU6Tdu2R9WXHUeMU79vzJUPccJfqGhG?=
 =?us-ascii?Q?jFWbLMADTP7/1J4HCD72xtVxYWKPM9pqkLGwLmzlx2o/6d0kRhE4O51S+Q49?=
 =?us-ascii?Q?iw1zTZsk164CSUjCvgP81Ftzpsm/bzy/WqOW3Cw96aXArFiyYH05QoTHWp4Z?=
 =?us-ascii?Q?07ko4Lrvb8CS5ah4OdIIal3JTIMdxJdmuApPhQqN7kDTfr9PQ8OAzMjyBt4T?=
 =?us-ascii?Q?4fv3gSSKSg0WB59gB7/4Jqo5HNCoIx/65RKDBX2Ot5usGEdn97oMBK9JEpDi?=
 =?us-ascii?Q?kBhwZY5ys5JTTyXjlhWuY9inr61YzoNYxGQ0SmdoYdjmG3W4mXXFwiCR8EfR?=
 =?us-ascii?Q?eLM4REsEFElEtcYY/EGQ5U+wYnmikzxpQTXHO5ZUtcp35ASXD9AgkH2ZWhM/?=
 =?us-ascii?Q?s66arxwYoFKl5U1L2/G4LS2F63kb7XRehQt5g4Oe9z7r5JhBoh9mNSKSm2nf?=
 =?us-ascii?Q?XpAi2KjRzAIQ2qBhxZMFVCsTmL3IssQ/Vl+n1A6KTokfvImVrmyoUXejEp5l?=
 =?us-ascii?Q?xfThYfe76MwuLNWZv2rjKAXWY1Y4R6q0Sk0HmA1wvQkPsklQk0K4sA0TAXH6?=
 =?us-ascii?Q?Lqm2ay0kwXCGtXDHRLU9hCVflt3OKOqnJyMJ0Wa70mAlAHufI4cEmp53KslD?=
 =?us-ascii?Q?VfGNtU9q09w7+QwIlI2zQMYK7pZCIS/1uQ7ZyI8xWpgTf3L6k1WwmHzbEOx9?=
 =?us-ascii?Q?4XrsS2Qh3HYau6BxR2A5OLGX+m9/kZcP?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+gDbDPudR0peEqJOFrFHuwx8XnEDEmTa/OSu5W2it5EjAq8zB1N8VTPZLTQP?=
 =?us-ascii?Q?HDgiOnSVL/aMFY6rOHgkMbQdux6FRaEXPjuhm1kdw34BZzdU3xwcujLObpbW?=
 =?us-ascii?Q?NVfIB3dXWoxfjMW9Y2IloBXgXqx4tZOFAc4TTocM/kHNca9MKyjhUdC8lHk+?=
 =?us-ascii?Q?6YC9lmLd4oK8ba8/lTkAGU+UlPqlqCDUXcZ5cuzRrMUXneaPQUlVAz5p57SR?=
 =?us-ascii?Q?N5C42Qx0eA86qL8+zv0SAaprmeZewCOvAT8Eo81q7FfiWRsFh5qj2820nrMS?=
 =?us-ascii?Q?TQK4FTojg9rUVaw+tkn0mp1TlRLqhBZafulo2+7LqNEwSpfBcFuZgVnwjCQ4?=
 =?us-ascii?Q?bu+n7nfJ/bk4S05TEaafiMAZbmsq1bjcQt4l2Z7T7symW2BMQ00YyyEUhdwI?=
 =?us-ascii?Q?BcVJGbfspISoC/6bpP8Csrkgt1DxoHU01g1ERaasgDyXPRXc+wzhvrDTQKHw?=
 =?us-ascii?Q?oa+mF2+ImJBDgGm+icAGDJaNcJnZmDPAaTauY6MHwbo7hdGePVyV9wPEcoE+?=
 =?us-ascii?Q?//yK3QSdh+i3UAF89VzTxC7W+hlBrIoE0c8eVZVytRMkEhlcDigEi21AsYp9?=
 =?us-ascii?Q?AKHO4mGsMJxfaQPiH3XpvWpy8T7sj4rHU16YtW1BWSJbenEG5js79XYQE6UI?=
 =?us-ascii?Q?R36kQCM5vq2CoCrFFq2AKHAa+dhRN8PMf+9w+1tiI6HPq300+jc7FZdKHH1p?=
 =?us-ascii?Q?qU/u8WHnphG336KSmujSBoZaoKje2IUVQ+ze6m0xK6GWK6oQazwZMe6BmJyo?=
 =?us-ascii?Q?FWf3h+5Y19HwlJeuTzBQClFPUeI3M7RO1P/uXUfVesQ36FkEMP4QHBTGMg+H?=
 =?us-ascii?Q?yhWaIXWY+MPbkmS0i4SwtDNL0zmqqMezx0jS2BXW5qyes8LtSlJccgF/4pfx?=
 =?us-ascii?Q?YbmB9RqkX9j/0feAxJeuohdRwd9ZxswvMHHomnkGRZfhxLa6+zogSp0R7Ono?=
 =?us-ascii?Q?CPp/ktbEstC7/UbQXcQ+G4fNgP0FmpOHaVs7VZVBMOpB7VRs34t+kcrfNKiz?=
 =?us-ascii?Q?KGeI8MQiN5fBNCRDkD83XdV1jUDTylj+jBJ+rmmNvrwMNyCMywe3+qVXVIpC?=
 =?us-ascii?Q?17W3DXuDYE92u6Zyvvk2t02KTZMAn9YfSVcXRw3RjQKd1gdVdnqdc6v9tx1A?=
 =?us-ascii?Q?SjksT6mAJFV9DXPtvprcAnA2VrJ8N6JqXhTrH9ZQkU7mGlL5ibM1xf27jBvf?=
 =?us-ascii?Q?itHFNbXicTRLO1zxKPuQiSOW0Ml1WHkq31/I3ugFhPG8DnOCTkbpo0ElP074?=
 =?us-ascii?Q?G5Hx5FkpYIZy2jpzal47BYJ6iE4/NzbDn2z3uaw0AXJFBTbbHzjM2LOv+bzy?=
 =?us-ascii?Q?xZgcxsl49BnHqa5NzEooGV1qCUqNReww1QCd2YEPldEPH/55cFnpdr1NIf5w?=
 =?us-ascii?Q?XFqeWUyA/DebQ6XLwsuTzRu/jytFEpwHzx7su4PaLC4sHFr73N5FB+IInhUS?=
 =?us-ascii?Q?Alny/uuHklEQ6eTer7Sypa3gQgdV0k+TX1cj5Fbi/M8UAqE+5UL3GAnTQ+1o?=
 =?us-ascii?Q?IO8TDenvAQxKKiq5cHtQd0i1MRZsREH1JzoQg4iR3SXw8YYc4VIPDUMw4GnP?=
 =?us-ascii?Q?fHOmQkyyp48Zd9Y0ExCdQIqAt5ZPTuKuz8Vc9IDy?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	k9M5A77skYqjNyCO/K4mEEFO7Nh1k7Ty+NLBHEy5V8efGCSmK8BafrhoPRCzmz81jL30woHi9m1sOsYtfnEc/NZEf8nWd+Urw+h5P2YnDXDI0zH/QP8UAZQo2i2dMEYOdiAK6o8dGPF67hOiD7TEbdF02tfTFopANyokt2kdVT2IE4SL55qvrHcil+0qWvbW9fsDt7NfN7vwmLRN4Zlgpm9ooIm6ByTqPFymPk0fbEoxofzDU7nifD96bEHV7vFGMSS1trFkW0+UZAnQTLTQst3TY2Kjork4IOzy4+e7g1EujLlmgI/6VpKog1pSxzv3SqG95jRIV6O94dVJFrqZOZkYHeYe9YSiVtZ12Vhd9756/hwZ7azrd2HT/hKcrTndMZOPZyv2QE/yi5dT8ikGFh9A6aojGYtAqqssuUr2sSlc1QSWIeOXHAtXteS/dJbmpENKMbf20SOfezvOYrMpEdLK+FkfAnBLj3/4JIRhLkX/wA0Xqe+LX2Tx5NPIxRGcJwF1A4YYEyGQDTY21ephcKAYg3rJgAOhzBIYLEIQx6LMnQhG1jx5n9mjbSzp4zyJnf2ZYsrLksbHtYAAq3O6YpBymX7QyVNUYKOycOcSpg0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd4b4899-11d1-4f11-3ff8-08de0b4a5340
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2025 17:51:38.7436
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KNiZdDxLpw1oufAgoXf68RKf5P8UC1hlR3RwjGJ7xn+jww+OUDd1XsL9xHR4bDN59vNiTflSHnj6q5X2Ozx+cw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4642
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-14_03,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 spamscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510140134
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDExMDAxMCBTYWx0ZWRfX2ve63cZoyLca
 O0tl/6UXfjGN2HJHcP+BcxLePaMCZZeTx744JKC67rcetCsJbPup6N+AyVJNggEAqo/jPjZCRWa
 UPt+IkInzMUiN0FgV55D/nhqGLSFF5lEtchGWpIIQ+EhL+c9KgwMCahiwgbgA0X1YtU1Ic0Cvcb
 uPF7KZOhF/EackU9eEOMrawqN78uSwjSn54vciC5nB2kGicHfMUd3Mt9grbQMMAZuZWraZU5aYY
 u748unfxppLA0rzg0OylfhdOrZGHuHWXkj0OJqNUUxedDWMq1EoKA9Qo7WxmwuPVAEySwmvubPO
 Z9kRmm0TMB8ARniUiUN3+tVyBe41Z66xsbZe1u8c/2zx5zm0z5qVG03aT5o7BdE1ZVZDFKtbnbj
 Mb82g4wYMZTJlVmz2PMpop9+d+XigQ==
X-Authority-Analysis: v=2.4 cv=V7JwEOni c=1 sm=1 tr=0 ts=68ee8daf cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=1XWaLZrsAAAA:8 a=6lWQJsO1DiKRgZd97jYA:9 a=CjuIK1q_8ugA:10
 a=DXsff8QfwkrTrK3sU8N1:22 a=Z5ABNNGmrOfJ6cZ5bIyy:22 a=bWyr8ysk75zN3GCy5bjg:22
X-Proofpoint-ORIG-GUID: LEPU_huxP2bxZR9QNUUJI12C3rtvNoeG
X-Proofpoint-GUID: LEPU_huxP2bxZR9QNUUJI12C3rtvNoeG
X-Rspam-User: 
X-Rspamd-Queue-Id: 170D3A0007
X-Rspamd-Server: rspam02
X-Stat-Signature: xmnsde6pa8qcukj5nsk99m8g1hscdmpf
X-HE-Tag: 1760464347-99919
X-HE-Meta: U2FsdGVkX1/hKx1CLRI/L9mNdQINvQjNi35EPexyNjLeLlTXUHAHfe0ninOJODKZK0eYNCmrwyd7GPjTPXqgSy46tnS5I0ya1VWcvZZStVVMXdNnZuSqg4I0JBMuHXxeJzftV5KFxvd47r9WbRQwll7M5S4sQAgtKUQQcC2ZEG9gmTWBVD/RYtwyaunJbWnft5RyiKe1M5yEQDBjhQmYynYvCA2jxh2BfAoAmZMf9j7NLWm52aIrB7ZNLxgefE+keLuCsNY8MwJ6Isy3rCJQiI1IQKCPn60jz1NLE9T3T0K1alfLRpBVUodqIpY73T7f7rNM1B+xhGbsYYRwCMbmYa7Etk4sX7mE9IuwFc6HNXtY6sURv0/yN4wqBnRNkAnloZvhVRfM8g9POsMwPqJ+eldSDVkXXBGAMzkxvPNHujnPOCD3H14Qw85xayMXRXtdX6xnO11CGlnRuDBbxXF5flvlfZopcoEKFKqphGYK4xoNZpp5XqCs1/M2DMf5oVFO5WU0UblT9GxFd+F5R3POBFRHwqpNmR646ptsVgKzHMbyVDflkpvOcpokaZmLChfwtq8t5AH+blF/mItqVm8R5J1W5Qz0Inog3mThn4dEVwrpu/CaSEgo/L/uuyznc7fhJ/5aXbGCi3jzRplETU+53fQRJTYyN2DrODjWuQOyRpG//yZenvNXRdC+rN0V9EErgSS/cGtA797c17PrEhIxsmAC7LRB1dnvye87vl/uzDYKxwKD6+po8BiCjVf2CaL4ZQKPX3K+K5AzkGl8ILGmPc58KBwHe9McJoAenf5zPjs4J4gpaPSNVcL9Izo5l0GCYjilpsMYGCDdGJm+6vLZHhqXbi1oeFsBX9m7N6BphmGItTjX8Cp6DANsTtLRIlQyfrXoTUbMzn2asZKfIs5wAo28Qd3ZxVyLbKKz9coFpYz3jyqvsTjQK2uE+DFSFyuxnYyZswF6fa7/lUc2NZa
 /ObXLmPP
 0G7aPV1aG+ePC3fIxlrmcv0gWROiKLjQ+sDvtfPpOkd6s4xir6X6khSALfmNuHMYjbiBjdZuVCMTLhbvVayG3SJt8+xhV+ppdqrly7QdBAlU2zrO4r7xicVtyLutMwOSVv6ZNZxQ05W2CBfkHTv6otLBsJ638HEFXOByft+Q3G/Z5vUalTqZTHWIX8NOo22z1pTudZ3lIPickVIYdYv19MR4kpbKlfJ0CC2PJgk0DNbZOWh/RRApz5bSFG7eLLV1uyTEv7LuWhxOxVv/RNGb9ZulSbz72HF271Yllcg0vrIFTVP1KEbJ3xY5I9f5hveVcY6xG8i1yvYaUTIo2AufFOp70MJyho6vSb3N8h3DU/SVxfhJ88FnOXBTcYQCHkT3O9JeClRp2DNaFZo5JqGhZs819U2F/+QTJyl+KFGmOyd1Znee+w6CfwI6lT9pxF7uNVw/iTUWVU4fDB5bKniTAr74HYx3dCUt7AYjKkQ7eCyQfPaYY/2RO/z9MmXNIe64QS7WmXXP9b5XlKcLoGiSn21tiK+q8Ru/RCCMfEAMdX2U69BFJKu2gEJzWMzcl4ZDuOJGZ1xf4wE12YKjuTfXpcCqhV64wkOD2vTXlyKaYDGyRpEs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Hugh Dickins <hughd@google.com> [251014 02:28]:
> On Mon, 13 Oct 2025, Kalesh Singh wrote:
> 
> > The VMA count limit check in do_mmap() and do_brk_flags() uses a
> > strict inequality (>), which allows a process's VMA count to exceed
> > the configured sysctl_max_map_count limit by one.

...

> >  	/* Too many mappings? */
> > -	if (mm->map_count > sysctl_max_map_count)
> > +	if (mm->map_count >= sysctl_max_map_count)
> >  		return -ENOMEM;
> >  
> >  	/*
> > diff --git a/mm/vma.c b/mm/vma.c
> > index a2e1ae954662..fba68f13e628 100644
> > --- a/mm/vma.c
> > +++ b/mm/vma.c
> > @@ -2797,7 +2797,7 @@ int do_brk_flags(struct vma_iterator *vmi, struct vm_area_struct *vma,
> >  	if (!may_expand_vm(mm, vm_flags, len >> PAGE_SHIFT))
> >  		return -ENOMEM;
> >  
> > -	if (mm->map_count > sysctl_max_map_count)
> > +	if (mm->map_count >= sysctl_max_map_count)
> >  		return -ENOMEM;
> >  
> >  	if (security_vm_enough_memory_mm(mm, len >> PAGE_SHIFT))
> > -- 
> > 2.51.0.760.g7b8bcc2412-goog
> 
> Sorry for letting you go so far before speaking up (I had to test what
> I believed to be true, and had hoped that meanwhile one of your many
> illustrious reviewers would say so first, but no): it's a NAK from me.
> 
> These are not off-by-ones: at the point of these checks, it is not
> known whether an additional map/vma will have to be added, or the
> addition will be merged into an existing map/vma.  So the checks
> err on the lenient side, letting you get perhaps one more than the
> sysctl said, but not allowing any more than that.
> 
> Which is all that matters, isn't it? Limiting unrestrained growth.
> 
> In this patch you're proposing to change it from erring on the
> lenient side to erring on the strict side - prohibiting merges
> at the limit which have been allowed for many years.
> 
> Whatever one thinks about the merits of erring on the lenient versus
> erring on the strict side, I see no reason to make this change now,
> and most certainly not with a Fixes Cc: stable. There is no danger
> in the current behaviour; there is danger in prohibiting what was
> allowed before.

Thanks Hugh.

I'm left wondering if the issue is that we are checking in the wrong
location.  That is, should we be checking so early in the process or
later when we know the count adjustment?

But then again, later we may be in mid-operation and find out we're out
of room.  Other places are even more lenient and allow us to exceed the
count for a potential limited time, and we really don't know what's
going to happen until we examine what already exists.. So it seems like
a lot of effort to avoid one extra vma.

> 
> As to the remainder of your series: I have to commend you for doing
> a thorough and well-presented job, but I cannot myself see the point in
> changing 21 files for what almost amounts to a max_map_count subsystem.
> I call it misdirected effort, not at all to my taste, which prefers the
> straightforward checks already there; but accept that my taste may be
> out of fashion, so won't stand in the way if others think it worthwhile.

I'm not sure which way I favour, it does seem like a large change to
avoid an issue that never existed.

In either case, it seems like a good idea to adjust the comments to
state that the count may not change.

Thanks,
Liam

