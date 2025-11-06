Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98F83CCFA03
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 14:58:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFD5A8E0010; Thu,  6 Nov 2025 09:58:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E87308E0002; Thu,  6 Nov 2025 09:58:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D277A8E0010; Thu,  6 Nov 2025 09:58:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B82298E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 09:58:48 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 71593C0136
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 14:58:48 +0000 (UTC)
X-FDA: 84080489136.17.00C38D0
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf29.hostedemail.com (Postfix) with ESMTP id 29DA912000F
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 14:58:44 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=MvO4mbIt;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=CZmKDd7q;
	spf=pass (imf29.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762441125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PKRz3rp5rZSKzM6o9e5Sj+JmtYSreneGcfoHOipR7k8=;
	b=MMfncoSHkp0KHVKSU4wvSGnxrzrJdTnSjEg93IwqefZf6IP5jPzOxiT+p30LFRnKTizFSk
	l0osXpacEsO0pDvCrRYoc7HPiC55Jw0FqAJ1Lz1lURR9TnfXLEofQS5WYbs4BunuzYkhot
	9sJlAXaACbhepub7Yba9KRSpujApLHU=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=MvO4mbIt;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=CZmKDd7q;
	spf=pass (imf29.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762441125; a=rsa-sha256;
	cv=pass;
	b=18eta01Lh7DaX+mLrclatyTsH2YGCBDP3xruC8E9RZoPoYaCRwdnfxz/jL6Hu9zyNFtVL+
	2tTryZg0+e/UsSYLH/JE9tDdSSRJOMQWfc3tRtFzwjAuzX9mSJkc1u8NRXz9OdrOcL+oCs
	LICZH47/5BTFETg2OX6Mk5sjwVz0ZNo=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A6Bl30f002469;
	Thu, 6 Nov 2025 14:58:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=PKRz3rp5rZSKzM6o9e
	5Sj+JmtYSreneGcfoHOipR7k8=; b=MvO4mbIteaHy0N5uu1giDhGzUCz6SyJFlJ
	HWdG2SQ8YqPQZFenOUAaRVlaUZcwN7jz57Rqf5JaubOSbo0Bfblg+bmOjxdtpp6X
	OmwIy4Wp25l9E0pQx5JnIPQ01jp2UcaiwM0HvSw0RJQDAMVk5/y60BrsJioL3W9j
	LTHolo3Nc7+ONBDlPYLf4FRaVG7Rn8BeKAiQ5n7wp/cAbwTs68N9btWKPI0nwXOe
	0m0cZ08k2NPBerqDRAwjx+TZydSUfKkVPMHmB8X53gE/KItUL7CUS6rYJRljxiNi
	/2oxxdvRwVcChK7gXmJGl0WdSeSGXS0J0mFohFblNBty4lovkP1w==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a8aqwa764-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Nov 2025 14:58:34 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A6EXKPO010908;
	Thu, 6 Nov 2025 14:58:33 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011021.outbound.protection.outlook.com [40.93.194.21])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a58ncgqea-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Nov 2025 14:58:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P5fVzMuu2qMJivjePuvlwi14iUPv5guJzkZr7r74l0sn1+mt4iE0sPk8o74o1mx2UwXfHwufRIOtYrW0qvMizm3yqXv133Z//vnj2FXS/pL8SoM6tkzxZBj1+bw9KM/Nxi8bf0qYVWvyrBTtDHv0yZCczzz8vRnNGG1DFdvcQW9aM/0gXn9ob8GrHtslhvXGjr+EYPcZsbF7BlxXURLCPNJ8gxTXWc73IQ/tpErveFZAiM15UNqtwNnTfW3Qswfu16bGk6nD7ag3iDH7nHXdP7x+VY8smaQLf4Yg2VQsCbykXuUC78F7O4VH5LS3UBzncEztca0mJsKMloI9GgHWJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PKRz3rp5rZSKzM6o9e5Sj+JmtYSreneGcfoHOipR7k8=;
 b=hvwQbZ1pq49P9+NvNfZk9xmgeXVhEWZON9fagJjSEE4umrXU19GQJ5iCrokUhkB3jV5GadRmpC7N3ChYQ95f9KRsmNqa4YzvKPKmx+oXT/Vied1FUFiMrGYQZ2YFux2vqFKNV5igvZW+KmcHmL1JQHh4OkDIGZZVPYvtozNvY0x/pTMD33e2znwJO0bMT3SU5yyfGBbSJd6YxaAxTEkAHIMDMJ5IyG1uDG86ai35CzoaILIUzfS8YkdAFpA0LW3UQcC6IVsibfLVX1LGxOeNBt+M+DhGoKc/BaQMviFzrnYDZP2lYxpAgYCr4ueU/HeTyiYZs2C3JLyK/RKprHnJ/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PKRz3rp5rZSKzM6o9e5Sj+JmtYSreneGcfoHOipR7k8=;
 b=CZmKDd7qMS+njqOZWaysdWqDrEikniluA9zzM9T0VpfL7g6EgwnFNTgO0nIgH4x4I9/5iAVVdQPxhAiVkPgIX5hklkzr2/MTLdii1Y68/QawbOg3vQr7BY4eOPT2tUG7i2T4BKUJFht3wdiFZ3KaxNxLEeAsLVUYQDHUUru1OqE=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DM4PR10MB5920.namprd10.prod.outlook.com (2603:10b6:8:af::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9275.16; Thu, 6 Nov 2025 14:58:26 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%6]) with mapi id 15.20.9275.015; Thu, 6 Nov 2025
 14:58:26 +0000
Date: Thu, 6 Nov 2025 14:58:24 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>, David Hildenbrand <david@redhat.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Jann Horn <jannh@google.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, Andrei Vagin <avagin@gmail.com>,
        Alice Ryhl <aliceryhl@google.com>
Subject: Re: [PATCH v2 1/5] mm: introduce VM_MAYBE_GUARD and make visible in
 /proc/$pid/smaps
Message-ID: <a32e718c-e3fc-4f9f-9cb5-3df539664743@lucifer.local>
References: <cover.1762422915.git.lorenzo.stoakes@oracle.com>
 <fe38b1a43364f72d1ce7a6217e53a33c9c0bb0c5.1762422915.git.lorenzo.stoakes@oracle.com>
 <yja2mhwa4bzatbthjjq5rolqlkfgcbmppic3caaiwi6jc63rbc@cims6rqnotvj>
 <043dcbdb-e069-46e7-8f79-8fdaf354fb44@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <043dcbdb-e069-46e7-8f79-8fdaf354fb44@lucifer.local>
X-ClientProxiedBy: LO6P123CA0014.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:338::17) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DM4PR10MB5920:EE_
X-MS-Office365-Filtering-Correlation-Id: b2320b23-ff59-4723-65db-08de1d44f058
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?SnDi3ol3cK0Vb6OqmgWyV69dIEh7WvmVzLyxA5IdUt/E4NM/GJ/Hn1+7xoT7?=
 =?us-ascii?Q?dVaSKh+e0/urk0Hw9oOy6c5Jgo4TdLn4r75RCeC42Nq8FM6k9ssr+pBzqoFJ?=
 =?us-ascii?Q?Fbcv/WUnfaBqBfwzv2wK0h8KSVjUkJqO7cxI+ZZmoM/gfqKztfUxCzJJbo6w?=
 =?us-ascii?Q?xIcs5RMWDhVjoEH+cq1lTpKQfE3WZlp5Z2feV9oy8NAhVwV8xjdit90A4dx+?=
 =?us-ascii?Q?DUXjdhqsIEmkcLB4e5D/JqesmEyN0z1C0FIYy4/8cuwLw/Oj3u7uYkVmH49t?=
 =?us-ascii?Q?LVnV2SWSJS1XHl7/rt9BmIH0M/SfU4bcZrQscNSUr5Ygp6KhX4O+4eibK1x6?=
 =?us-ascii?Q?+kZ/AqnOlK/LDP9mjdJKTox9hNBUMw90KxQgn0K6TfC5Sc3em/36E8fU2NVT?=
 =?us-ascii?Q?8pS4oXEwcyfptzG3sO1FX9HlAU8QLp2zBC/iyJ78J5Qx2gzoktHZP3/FiSV6?=
 =?us-ascii?Q?fKLAj/GdXVHUveWSCeio2Dj44yOK5VznXKtUFr5FCxe9S0bayFbLR+18qMUs?=
 =?us-ascii?Q?A0PEF4xI/TS044nzGL1RlOkaF00SUDxSKGJzcoTrD/A+r7/RAiDJ2bkRXeHU?=
 =?us-ascii?Q?XOgbBMazuI+x6Q9M8uOahD9mwJFC3Gfh9zLqR+h63X5So0w9PCYSM69kHnuu?=
 =?us-ascii?Q?H2PsteDeUrbDBJL6POQek662dzoW4sb8qbx5LJQQeL0O81BufYgT9jFrAJpU?=
 =?us-ascii?Q?9/2wBVj9TTDXcYGSxPt9WrBfXfprXkjW59WR/w+j47nzdNjf8haEjBpBi5/D?=
 =?us-ascii?Q?o//qZMck/mZoTi7kZNJD/InCvM/+1ue1xelYkjkqMG+IgTWkANs758iv8Trn?=
 =?us-ascii?Q?bcmMpCMys/EOkCeHU8ssFScq1E7UQlWHtRpHYmFwDfoONfDL2I+ipjrWky1N?=
 =?us-ascii?Q?upcaov0dE+MckaFLKcQnqVFqxWbEs3eTdB9HP40lUhjGSHQeWTW6YbJDuFgY?=
 =?us-ascii?Q?8V3qNspTYaPmHJVgojjtF6qvJA1yg8CCYWtJW8xgMN8rQIvH1PkW9b17d5pH?=
 =?us-ascii?Q?/E4C3/H/yDRZgRIDyFS0vJF+WvmwB4Rvq4MmFlmiIoa851AOtK1UbxWAGjMo?=
 =?us-ascii?Q?/GX2vIOwBkLhSiCusIUxwIj+Wg5Hzf0ISJseSLdLSWaKecekinnKMzWUaoTE?=
 =?us-ascii?Q?OMqIR2sWS9MUxqtYtv7WiQWwgMHeTJdXMq5QKn9pRUQxsOSlebr4FK5NhCRu?=
 =?us-ascii?Q?MjulVv7P9qIwaCZrw8xFJOwLjrjc+BcCEE7R7i69Q/yrnDuS0rBjt7YDSeKl?=
 =?us-ascii?Q?3ksBd9qUXMcEZOznbZjHlIXS7stYVJ0LhqRUO6MWzNwRZoJWY82lwzgz/iHo?=
 =?us-ascii?Q?JFwgLfRaDPiOsnx6/eMwAxb1emfN7keoeQjTKts74+pMuCm4BOWtaH8p5khq?=
 =?us-ascii?Q?9ld0LqfumP4Mh6Y7U/f0jVLtxILPlJ6ZQtE1IWUpL8rMnBgjdf26eo/154h8?=
 =?us-ascii?Q?sObTjvkcboR2LRBsNfoFUzGEjehOhjeH?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rmCO23fP2BvlZx0RqP5yf/ELWMJGuFWVT+FHPfgyEJfaa2A/OWUhrDKwnxYh?=
 =?us-ascii?Q?eB63glurTrhfVr88MndoyFl1UbS1OZ9A/UoClsBZOcaornTwVedBJ1IET0Ww?=
 =?us-ascii?Q?0LfOTu+toeE8m0LcdSJLnFQLx7ictUV24NNKI7X9cvQPioSroUhjyUI/FZAr?=
 =?us-ascii?Q?/f0CsXtG7WTfyqOPzEb/F4iq1UugVN+HRfyIHNusv2Om0wbrrB9pIhw1Z8Jr?=
 =?us-ascii?Q?9bWKYsBh3zbXaafhywsM9vn8o0kzwzLLg4qQBRMzIkrdpQku1ULTAzJVshV+?=
 =?us-ascii?Q?3NlffS5qy5HFGOUk5mcM9t/Eat3AiRwc+kx5MTawYNZKsh4PWu3KGNUOFDcs?=
 =?us-ascii?Q?nMDSghN2oQDgbqHPT8WkWt0g7OIj2HBTfyhaw8MSqvIWTJY09rIXN8uagR4g?=
 =?us-ascii?Q?ppxH6B4X6bdxasrLbr0FcAmWjOK4ozuJwh+WCPhqtIiEIlUn+9XBJV7GUZ/r?=
 =?us-ascii?Q?fgbceI+J2MyNAMvMibKi8LmGK0c+2YYEtAkCb3o6EiTHLwunplAxdU95fGMb?=
 =?us-ascii?Q?2ropb4PDqC0rq/85Vg/KQNq+SRGFFRYHThZegqt5Ky9aHp9/L9FqhyanOaip?=
 =?us-ascii?Q?/z8e80DNTOvKsIVCkeXwuEWDnrcNgFWX5e7GsF5hK2zLfZbe16ZoOBoD5/OK?=
 =?us-ascii?Q?PYHelbG/mvMJ9TXgTXHjvAMLy4wPnEOE2LwLz0Y0REPMR4kNU0oI2ywNN0C5?=
 =?us-ascii?Q?k1EkFp3B5HLFDi1JfejQdpyJXLmX+HLmi2+zLWVfj/Dpb44R/Onlwxn9DhIG?=
 =?us-ascii?Q?iTbwhrEWdNEKAiQgoY991wrHupZAnXcCseOiIvr+u62a0vdIUKIxD+KvDYyh?=
 =?us-ascii?Q?MhPAoukq8B5fPuoBO7lUeZzXzTSFxAJnhqlX9yoBu5tZ9Tpu0V2sDUrWNWkk?=
 =?us-ascii?Q?wu9QF4VCoNDdAIhC7yShXSMBqoIB0ykWXxftQx50vkTue7icxklGcEb0bVn6?=
 =?us-ascii?Q?OWe09KGep/6c6YVEOpUspKskNFbxvkm8I38MJc7wFdaDG+oYhOFo2h9qrvaX?=
 =?us-ascii?Q?kzjpTWTz/A8HIMvuhijtMTtclDEbf5oXllIjG9pWJB5yIjs/Xy7glMLwoWZ3?=
 =?us-ascii?Q?8LfrlSRPAJB8Ai3mufV1SOlfdbyhZwPc/RexiGWVkzpvIzNCVf9qw22R1hmI?=
 =?us-ascii?Q?41npphN7TXssZve2P8D32dDSGqGHFN6miHwdYJt2sdG+dme27UkfNSpttAT+?=
 =?us-ascii?Q?eMEKk/rPFLaITlsM6+aUWU1ZPuVa48Spe62SALsP4rRQ1UpQ3VBbbhrRE/xV?=
 =?us-ascii?Q?Jz6srIvpEbnvMfYr3D+JQTBdsSUqR8ToDMwQT2EMnoLWJStiGSeL9yjDYyvy?=
 =?us-ascii?Q?SfKOtlIUFh60Y7TjpqD6WPQsFS2g7TTvrUGVeE4H6Q9ibY/nUgnBOHH//Vs/?=
 =?us-ascii?Q?JfVA6h3Un/G9ltB5f6juodjqI+NhGxbeFIxtkDJf4rC1JL8N9yBfDY9o/X3N?=
 =?us-ascii?Q?XSQYEcI/nlNXASpQMrsZ9/CzwABqeTTlepazdv4D0ukptE/8dGM2k4q9JqDG?=
 =?us-ascii?Q?nvYM4MLpl+/Fpj4MCH6yIH5BrcE//BdiOADb43mhQ9xb7QTlg/MpYfQl9gXZ?=
 =?us-ascii?Q?DmKf+OgVgMqWS6nZBe6Ksr+R+UpCOv9W/eaTliTNvMiPDBXYBYmfncnSqxle?=
 =?us-ascii?Q?8g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ycOML2qyhsun8oZeiptclrJRUx2mSZZx3RtRgA0RrvtZxTJ8PcTzqBLlmwR5wRhDCkF91E0SJZdwF5QKUugg43sJi32Lt5TKzBGbpTaqOchgIaSH6OaN5MBp+BDxUrOvP0TBN5oCcd/aueBeFaIBDVVg7kbb9GdyD6Z+murUwy6qqIUiuSRJi9rp01gk8RsjXWOcOyOL24XFqrcs5ZXqRM6X/zftHgKg8hBCVwV92BLCt7yAbHhFCq8dh8SoA4rVyUPmnEe/Rnbvty6dSqYKA3mr15NN2JTEwCLb5rVfOaKxQt5C7NjR0qU9eAnuGpPNBx4TcB3TltPr6u6oC4NYXpZuDLzA0nxTT8iZ9YPouKKRvVVbD2yA8OEGORCGp8HcdJ84nNsvZ/sq220Qgx5LeAO/PCnK2JX0akHcPw46YRjPX6xUYKvwORgOD+hAfQyTnIVttgNRf57cQshkcxq7JTwqGLUISOZ/8v3s91WvMVG+k+WeEVvBxDlJloFTvsjNh/YYhf9en2q0/g7NJTahWf1dvVNvX9nt7Xtm3ZDUb1TEghRRxcHn0+pVv0+QUpXhprJzbmGUB8/KgPSNMaksyf/Cir/6BldTcC9Ufo3qSFo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2320b23-ff59-4723-65db-08de1d44f058
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2025 14:58:26.1128
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KBM5Yqg6XevtueD5zmyTMGGSVv7aQzoeOkXiVO/plRK5NcTu7PwcQjBTck+FdaorlSjzaoR0X23KPk/u/3R+Nm2HGqsgqwaPFZ5fADLDmws=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB5920
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-06_03,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 suspectscore=0 mlxscore=0 adultscore=0 mlxlogscore=916
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511060119
X-Authority-Analysis: v=2.4 cv=NajrFmD4 c=1 sm=1 tr=0 ts=690cb79a cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=aW0p9SmapDEG4HrRwxUA:9 a=CjuIK1q_8ugA:10 a=nl4s5V0KI7Kw-pW0DWrs:22
 a=pHzHmUro8NiASowvMSCR:22 a=xoEH_sTeL_Rfw54TyV31:22
X-Proofpoint-ORIG-GUID: D5W5KRgNUkqoSg6OahrveQfJeZeXfMh-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA1MDEzMyBTYWx0ZWRfX8OxihnpxYsB4
 4EQ4qZc/n5zViKEy31h8XIG72KpVoO8/aITA/oTseHwByZqYjOVtQ1LLpV2ituRw5q5YV1XFuq0
 WM+G3D5/2frMalP3m8vVv/Vk7n2MnXkTQGiQN/+X/+fPsAIjH8NVqCgkqtCtMwZbO8mUDtIgace
 s7C7tdwdvM5DCYvGUHAv4NJcR5tQvxau7SOni/d5Rt3rvSGMeEbq+0DVemdzCWKl/aQ597X0URB
 9OKmEr+b7FmdYNyGNGDdue6wInwt+WmYVjsREG6bPqr/aeHQ2oibBsMLYR/9EJpQEVLbWlT5J88
 Pm4Q7bKV7QNoGl1YWsxIAym2mxGx30SOBKJCPHVyh4jXfdEUanlxKCva3wIbsVYiXxGBbFQ+7gh
 Quxfj5jsYTtAq9aYkgqXeLfwR+F3zg==
X-Proofpoint-GUID: D5W5KRgNUkqoSg6OahrveQfJeZeXfMh-
X-Rspamd-Queue-Id: 29DA912000F
X-Stat-Signature: h9mcii3zw9x94bxxcttxtycwgs5nxisd
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762441124-489329
X-HE-Meta: U2FsdGVkX196mqilSY7RRmzkRnEW9CGfg50KMAPMZOnOFDRHPi6zIachb4T94/SAKobfGMIeqAyYaM5ZaYEXnaGr5NzRcfvqWhHzw030L2r1mNCPMiYz2fktjigHIq0xbC3KvwwFLsuDauGmFCi9NsU3lCkLnALt5+2sZOawufSqxXDIAKI7Zrx295gdAXOht7wTJEekEyGXQ3bvppguC2mcbODtzvlTvyaUrq+tZOC/3dey46jF+aMUuGRyGi1jKz7zMLzb9TrRjsGMrk8UZONAQS3FkW0FqAu90Kr051i4FXbRklpgGZpyWmqXDHqYaR+wUXDSsR0QOgPdYBC9X/bmjxhEVDtCzqhPHqUnbDVB/opISCQ0IKeuE7SdO6YM+b2DKsc2e4H6TSoaU556PjsefUYVnvV6R/Fb6LkejPGIeXnklu1TTHl6LvWpQsjdDG7TVa7fjj4iem65yO87rqFrRgmuuynQcftcdhRV3gdwho8GoSfhX2MTlxyntnaWFH3aa/1SNlDtxS2K0KfKAkDtTZcZCmd9VhzDKLD5MQBXbJJSWUOAHPu0xkez08ZROTYRz3VvcodnJ33W77dwS+FsFW6w3v8QNm4WVwR5O5skFFfh2T2QQhKRBc6hCfJsLO2fkM35LK3yxUQg/XwetKyaQkw0xk5wVDu8GEp+kSrILFrpFgnPewKkh/4QnqW+ujKI3cgGcI47nd+s7pFBOipCnkXk+XekuHZTGXGJxS5BJWL1kBH/g6RDRhmK4u/rc2T6VktLS7Gch+imddDYQ031EwVd0iRFVWASAuPB5XC26H9wXa20hkDJyyJ2K2XwumBZ8mVDLDf1aEKgw2vbiGR4IYLC2HzLf7LuwB9NAEH/90Zlu/98ew/OHR3MfUXdvF95C5qRe0PhgM9o9R5/vZF4t885vWCKXkHhdcwpPr9qm4mMiw+JpL2t2hvHRA67mEMOYjw6aVnr9eQzvrf
 OWRSluTD
 nq2Z/fZoEc5z2j/9LgKEPrMetNLVIT/UKT6uOCx0/jeSyuv2dThBT8UdaVxikz7GkwSisBde+0N7HSZBsS3QmXAJ1j/ZwfPVlrMDBNVnLJzjF22GB2k1RYV6SadMaDmjgz24UvuNXFzuTCzeR+y9fA+hIVgK2/vb6oAlaqXHV8PqhmTNkqMJtf34NAW0Wdf8ZFQkTUawW/rpXtrlS94lPlFchyhj05Dv3sE/T+fye2lJ+wg45FECajLbK2qfw/89QC6CkaWAQvkr9pXupmVb1D+hYX7SxeCLwUipmGm4GSY7eFKHr4Cn89ys+5WQNeR2nqKZO0DJiNFIylJBsJ4p0UaFxEwFlYTAo5wg+fFmprqT/YjYhieaPIR7yCeCMc2EUEJT0LbxbyvzKCo0KbJro6Hbsz6q5yzf6ukI0cMN0BDrF11OqZXYd8sGH4rp5qbMc6VSobEd8qQeZn2441zkarYfAtHazFReO9urIPSmmIReGBD6JK9ZImeRAPX9zesoqkg3oYN3/Fgm/9mDrAxMdsJKb5NYQCHwtR5NSmux2JdEjYn9IyUMlEwK4h4rPpCms50N96hiSWJ6YoXhO8OymBwBY3V/AE+IU12VVI4UOePiugb9yIN+/c4Hh0BMd0joRJhmu+25xXxUWvbbU4bRvRBzHpXmQscgLj+eHsvU+BWwqx3zoPFjYCArom4X4mN3j5HQNmG05D7YW5GI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 06, 2025 at 02:54:33PM +0000, Lorenzo Stoakes wrote:
> > >  Note that there is no guarantee that every flag and associated mnemonic will
> > > diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> > > index 8a9894aefbca..a420dcf9ffbb 100644
> > > --- a/fs/proc/task_mmu.c
> > > +++ b/fs/proc/task_mmu.c
> > > @@ -1147,6 +1147,7 @@ static void show_smap_vma_flags(struct seq_file *m, struct vm_area_struct *vma)
> > >  		[ilog2(VM_MAYSHARE)]	= "ms",
> > >  		[ilog2(VM_GROWSDOWN)]	= "gd",
> > >  		[ilog2(VM_PFNMAP)]	= "pf",
> > > +		[ilog2(VM_MAYBE_GUARD)]	= "gu",
> > >  		[ilog2(VM_LOCKED)]	= "lo",
> > >  		[ilog2(VM_IO)]		= "io",
> > >  		[ilog2(VM_SEQ_READ)]	= "sr",
> > > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > > index 6e5ca5287e21..2a5516bff75a 100644
> > > --- a/include/linux/mm.h
> > > +++ b/include/linux/mm.h
> > > @@ -271,6 +271,8 @@ extern struct rw_semaphore nommu_region_sem;
> > >  extern unsigned int kobjsize(const void *objp);
> > >  #endif
> > >
> > > +#define VM_MAYBE_GUARD_BIT 11
> > > +
> > >  /*
> > >   * vm_flags in vm_area_struct, see mm_types.h.
> > >   * When changing, update also include/trace/events/mmflags.h
> > > @@ -296,6 +298,7 @@ extern unsigned int kobjsize(const void *objp);
> > >  #define VM_UFFD_MISSING	0
> > >  #endif /* CONFIG_MMU */
> > >  #define VM_PFNMAP	0x00000400	/* Page-ranges managed without "struct page", just pure PFN */
> > > +#define VM_MAYBE_GUARD	BIT(VM_MAYBE_GUARD_BIT)	/* The VMA maybe contains guard regions. */
> >
> > Don't we also need an adjustment on the rust side for this BIT()? Like we
> > for f04aad36a07c ("mm/ksm: fix flag-dropping behavior in ksm_madvise").
>
> That's a bit unhelpful if rust can't cope with extremely basic assignments like
> that and we just have to know to add helpers :/
>
> We do BIT() stuff for e.g. VM_HIGH_ARCH_n, VM_UFFD_MINOR_BIT,
> VM_ALLOW_ANY_UNCACHED_BIT, VM_DROPPABLE_BIT and VM_SEALED_BIT too and no such
> helpers there, So not sure if this is required?
>
> Alice - why is it these 'non-trivial' defines were fine but VM_MERGEABLE was
> problematic? That seems strange.
>
> I see [0], so let me build rust here and see if it moans, if it moans I'll add
> it.

I built with CONFIG_RUST=y and everything compiles ok so seems rust is fine with
it?

Strange that we need it for some things but not others though?

