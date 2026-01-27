Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82A9BD34097
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 16:23:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD6956B0088; Tue, 27 Jan 2026 11:23:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A841E6B0089; Tue, 27 Jan 2026 11:23:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 906EA6B008A; Tue, 27 Jan 2026 11:23:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7C1CA6B0088
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 11:23:42 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 34E53D31CD
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 16:23:42 +0000 (UTC)
X-FDA: 84378264684.10.5553814
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf27.hostedemail.com (Postfix) with ESMTP id ADD8040017
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 16:23:38 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ecxy9GQY;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=l7oKcr7z;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf27.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769531018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K1Drd+vR1JZNiY0xvX/P+1Ka86l1Nw7bFsy8Cb1KjLk=;
	b=ZyFu/Kz6oDQM+I7tYg3aiurtzKrIcz1TsfGiD4oQrptcLXgGjn8GM15ikZyQmqWMJ3dJ3m
	w2/LpL/zmavJGmewKQ6Bh5NQjvpggjfapRMzylS7ViUlw9pleDF3ZoKPeVBarUjsdUPDcV
	OooTXznEFgpDtq9/SFTV6btiFx1VbAg=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769531018; a=rsa-sha256;
	cv=pass;
	b=nVEVuNgPB53DZ2rC/2TPHAYnFWFE2yA0nT8PtUyvQPbphOGwUYLVf0H10DL+WkyW46zCL1
	7K+/y09iaVTqL+dp9I7yOd3IU1/sO2BNkoDcT8L2Icp7/LKr5KHR1OMs3+cCdP5rTYcQ0p
	AxJKDoX1y6TlhnXKpGE3AmbGqDpB4/4=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ecxy9GQY;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=l7oKcr7z;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf27.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60RBF4c4456433;
	Tue, 27 Jan 2026 16:23:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=K1Drd+vR1JZNiY0xvX
	/P+1Ka86l1Nw7bFsy8Cb1KjLk=; b=ecxy9GQYs8W2ozX8Ge7vaFgJB2xji4Dgtx
	Fw9dcTUme224mynhI3rgYrjujCOOQbF6w922fEooPpbWmZSajQj1pI/J9IfgkI/5
	OBWUR5gZ0RjUmUpGVAecsyzRSD47pjvY4otHp3I8iDp1ECywMEhVMdVqkaf+iI/a
	9cHguAQ/FnVnhF7z2/GcLTfhHK8qks9hepXaNEOZHhz8dS893zCa8R5lWuRfyjzp
	65oQwf8bHebFeivPwqRW8NqzfaFVF4Arqx4BmYxIYB0WX+R95Wjm7OnxGN942k/F
	zjek/EdK3pcolbmQxs/fRnZtBg7YoHQr5PMPpa8bvjVOpfOz9gkg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bvp4bvbxw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 27 Jan 2026 16:23:33 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60RFhOX8019784;
	Tue, 27 Jan 2026 16:23:32 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012006.outbound.protection.outlook.com [52.101.53.6])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmhexa8f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 27 Jan 2026 16:23:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F7IIyc887Kwnm1hEZOAAODEShgXLaArlVfNITAwDpxiKI9Xvv38FmgoRXHKItGz3HxaAZx8A0jiFPO4DJLcjuZAj1EQqp7cWgDoAPpgMtHpbCTgzW3dLjcSctB9JS2Giac7lKW49gKZ4lIK1rQYBTD/VIwSrKME+xUq9PFuA1xLYAjUzNMvd8Hro/b1EdzWBRpn/s0chFZdlh4xXQw3YWF7c2P/8+f3gNBS1VFAG1fuhz4FQJXCIpNJxYRSQT2QRe+/qfJdyCRf5yiAR8AHHnEvA6pnSoba8CfqKZ/GHsQQlLxm78z7G4qhdQaupPJtVo2n6R5mSV+Gp7TnDI2pzpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K1Drd+vR1JZNiY0xvX/P+1Ka86l1Nw7bFsy8Cb1KjLk=;
 b=MUZEXz5F3PI/v1LwmAfji1qRote0g4t6Ld6snMBkswcUpcyuw+Z8aPcI/i9CT4OeB+3xU3zSPBwj8Ymg+8uA++38NPQVrHmDzvYVLAWK3JsCddLKbqkaoA3XoTTzDD4vEOAthWB3qPJCaiINaeUbo1+uGOvH6gWMaot8RzZzHQ6MT848Bo7osDmbSHwIR1V23Ak3hPSBe18XNvnMWJJmLwVKIX6rhutFJbHTryNAWvVlmq63CjUxUcP3mRh5k4WIF6gwCFaPR1UXhahjbGn9J+D+gsLv6NtOR2htRPbaNE6gh0dktvomU2IA3cjjkVtUE6BOUo82BukWcShK52h0pA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K1Drd+vR1JZNiY0xvX/P+1Ka86l1Nw7bFsy8Cb1KjLk=;
 b=l7oKcr7zbKgdqgAIcP1PwviXRNfJwLmqsG4FysqHuq9TNDfvE14jfARtdQhU6ti5Vegy0ibo6v0rvLKuuL7jokmruR2yNc65xSok/gbIvyDGwRgwc3/5IaGxvqRSJbPDl9tsvyJXaHMqhAc+nPc55CHlHL4Sqp04La/E/kqWXeU=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by MN2PR10MB4287.namprd10.prod.outlook.com (2603:10b6:208:1da::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Tue, 27 Jan
 2026 16:23:29 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9542.015; Tue, 27 Jan 2026
 16:23:29 +0000
Date: Tue, 27 Jan 2026 11:23:26 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>,
        Uladzislau Rezki <urezki@gmail.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
        bpf@vger.kernel.org, kasan-dev@googlegroups.com
Subject: Re: [PATCH v4 05/22] mm/slab: make caches with sheaves mergeable
Message-ID: <iumqtb6shmu7q2dgd4pdcl5n52qhawdjv4p3h26moqnxfrq7q3@54lzpzd767yp>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>, 
	Petr Tesarik <ptesarik@suse.com>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Hao Li <hao.li@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Uladzislau Rezki <urezki@gmail.com>, Suren Baghdasaryan <surenb@google.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, bpf@vger.kernel.org, 
	kasan-dev@googlegroups.com
References: <20260123-sheaves-for-all-v4-0-041323d506f7@suse.cz>
 <20260123-sheaves-for-all-v4-5-041323d506f7@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260123-sheaves-for-all-v4-5-041323d506f7@suse.cz>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: YT4PR01CA0363.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:fd::12) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|MN2PR10MB4287:EE_
X-MS-Office365-Filtering-Correlation-Id: 48dfc7f9-a950-46a3-011e-08de5dc06812
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?JdcijE3hk8Jt6x79aQK3fAFFL3VUORXvl9j8HeWu0TpJ3vnGCccaV61aOtXP?=
 =?us-ascii?Q?WgtNtadqL2lg95L0Wuuu79WZOdGvb54xgDOqAYj3swKxqfcckRNnNyqK+Lvg?=
 =?us-ascii?Q?8NoR2Kyvejcza+E31XtsaJ4FuTdDwv5IeSW6hx9crfL7HTAfgq2HuSbQUnhn?=
 =?us-ascii?Q?zUUIn8RBXrIfcivNxzbKc4ywNtcBNPC2sfQJL6HzKezKlidXX6wfgirR52gK?=
 =?us-ascii?Q?4CwJFGgrlXyKCBSM4hx5lmUMdDv6aG6bt6GYKrnWFoMbVYvxqH/veoTcrpX3?=
 =?us-ascii?Q?MHX5eXVRvPuxXKOWAbSPSttt9tlnaiFap/q7xqwS977qPiD6+pZFSuLKXt3F?=
 =?us-ascii?Q?Loac6q53zyxNoKs27+oxGSKaTZZpcsQPSiyvPceUw91hTWiw5sGmTJk7xXhe?=
 =?us-ascii?Q?RCG+QM9c/v3D5sn99phlx8019td6wr4fISC3gFDkgQiUKnABz8qh+b5K50Cn?=
 =?us-ascii?Q?q74FCIKyeKx5JBKwFrK7NK4Vbp++/wlKlVvHzcOt1kvpC0AK2pG6vrAVd9mZ?=
 =?us-ascii?Q?GruPAhC427TuJFjo3uEhziOub3kpA/7s5t5wYn5VPAXgdRDm64ab7oEyyrgJ?=
 =?us-ascii?Q?PxzWdEchXtFr/QgnxpZo35eRZX0OH8lMdYl9mkoo/xY+oLz/fJcphQihHv6o?=
 =?us-ascii?Q?5M4ObHF9Ho3R5RU2JguOwPbw4cGadX1wA3ljMJL54miR3hKRs/WDCj4aNWq/?=
 =?us-ascii?Q?115Cfbr6Cmo2dkPyXFQBGFc3rhADSkoFHOOw1UQcK5zmkGXkiIqak9zbsPyT?=
 =?us-ascii?Q?6kMnwdO6S2qKwQHIcRhpejtNiOI2t9mcv+W8rzYCZNcUj7UeC3JyZw0T/9ef?=
 =?us-ascii?Q?Y8tHE1Ivz/a6lAUE3g0qOlVkVOU+9k5FP0yL//Tb7UsBCvgDyXA+IPFJ8UBg?=
 =?us-ascii?Q?Rbdv1RSQAJgmcmtOLKvsBB/RxCUmPQAYpkslm0sJTosibJ9GuRs0zF3Ql2Ql?=
 =?us-ascii?Q?VImHRRQYkhoV8aEWoKKssg3qRKWYjxAhFhd7xihQrQnqN7x4MdfF4dv1I1Pg?=
 =?us-ascii?Q?C9rC6+9iwGa1e8R1gY7Gnr5JHGTRPYoBhr+xDFxoUapPSRmAxujrtXy03oRc?=
 =?us-ascii?Q?81qr2RNKmpxnZn6YS9vx//pNe69hgtXTJk+2Ypw75hwnh8dx9ZYuiwsAWyqY?=
 =?us-ascii?Q?tb2zVkEIw4199xb5DUxtj22rqcCck8GQ2ROQrG9PJ8hJuX3Upt+QR2vwCvyB?=
 =?us-ascii?Q?kiUixDBNmHgaUi/qsuWw250QVPSegBUS8q4/BiigxqB5zYgHqHdBnH/OuqiA?=
 =?us-ascii?Q?YydHDuzA/IlEK8cG/qW5v7isQZus10+yzBclg64ntk4QeuGzCu/qkTNqRJUz?=
 =?us-ascii?Q?2yD9oUZTVGnDa8Z1sSCoLvf7HiNtJGn6XHxzAygyuHGc2P9Z6KM3L0uxl0AD?=
 =?us-ascii?Q?lZ4Ku6k/VjbJBzXhx/zEccdJSithgULvo9HQo3PCnwJFL17S8iyo9kavjRa7?=
 =?us-ascii?Q?3JvJhBOX8ZApgee4IiaBKz8Sk/+WixXdYoUK4rSCpUQLJcnycIpS0t9V5RbD?=
 =?us-ascii?Q?2ruM0Y6AscIve+2KSH/KUtXyKy0XNzSuFtBZOl0iJSCMpRxOLnsZnx7WveDP?=
 =?us-ascii?Q?AaOj7Sx0/CQA2kFEtW4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zZ3ET06ebIdS0BAuO8XcL7fGbZJgw+2Nc9rhmFmnrT96vru9Vg0oC829IvPv?=
 =?us-ascii?Q?w4zLQqNaF9wgcWW3iQa2y5JK31k6NQbzasRaUXXpwiGlrwylK/Gio5W9+Lh5?=
 =?us-ascii?Q?mL9cKBfkAnQsB/ykpETaHUPw1jUszrH4rhvHIEqIxDLzkEHfYg6Pct0wYKVO?=
 =?us-ascii?Q?lcdrtVWI6EOhPSEbkyvCu+ztCJ9DnsxCKfaqZ+Wx3TpII9yW5bcCove9suUc?=
 =?us-ascii?Q?Siy4ap5cFdYoDmw7ez3MFQH865iLRvvi4lp6hGN/7vlCn4IlpQ0/RwaTfQHt?=
 =?us-ascii?Q?N1Kr6VhRIszne+kdMONVTt+EgSaK3hQZgYxJR7YD9HTCIFZtxFfm6hDZCskU?=
 =?us-ascii?Q?2QFkA7r3aNDgP3dxrb1lNP5UJtNeCec9tRG/biGPYT03vmJlYqRJeNVnrWMd?=
 =?us-ascii?Q?2F6xI8XVQ69Ytj3iLgr9nv9c4tvCPluHIsDvf3rljw3diSPCZRcWrsXjJwmk?=
 =?us-ascii?Q?cSaoDiFJVLfMA++/1+UTXvLBeQanTR82qQx/U0DjzkajbELRVGCh6HvgqHBz?=
 =?us-ascii?Q?IDo0RDI5suR9uoUwLn5kCx4JKqPz4eniUisWD19FDL42tWFnUI6M3eIJC3WK?=
 =?us-ascii?Q?FO64+JfzDG7FH/YV1KAj//ZfWEzBfD65feIQQ6dFA+aTXYi/LR4WrBQRlxib?=
 =?us-ascii?Q?7gqEiJxVdlz59lwtGmjN1FWatxnyXEm7yLv9aTT527zulV8yNkV0T4+IZukH?=
 =?us-ascii?Q?SsWh0nrTrt+rECQ+zRfwXoIwTNB6xLzT9Es/PZC91v46SLui8SvisM6F9BN6?=
 =?us-ascii?Q?PWxsz5FpMEx0KlmAkAn8JXGVu+Ib6YiOlIoRJm71nnWi1OkJKb6Jlfs/qKu4?=
 =?us-ascii?Q?/s99ou1pHHAielij9bxGjegKlFJjDsUSpsPblrTzh7her/YOztC9rIkF1SaD?=
 =?us-ascii?Q?lknirYE/bwPknE/8Yez8OHbFuVK5utyxlExFCU8jEzUPz6zk47a2zTQn3itQ?=
 =?us-ascii?Q?QMzdi5cNqb5JNIhWAo3cI2W2rJcSPrpjoYjB88DjzQhofXQtZYYp3abMcA39?=
 =?us-ascii?Q?BjG8ITA8sMoozyGRj2RzFI7v0nBhjbhFYGl3KJPzuWo78sdFtXVMIxWr1rJ3?=
 =?us-ascii?Q?1jYhhmME11/7EIIV+cQgsbOr2Ke46NTbdM826HC9QEl+Vd1u/ZBzgiNsfcUK?=
 =?us-ascii?Q?Zx8y0L44aDRw6vjKkaPpnB1D5GPrsrt/py8g+edJWqs8FdS1dHF2BCGObXGA?=
 =?us-ascii?Q?viG0W6caRY7KZ4F3XLR38mYATI2zC6SbEd8iNNwuy2/T+vaFAbg1FF9DdlA4?=
 =?us-ascii?Q?9861q0d+f6MhzLZIkRMlZkbXBfHIUFeLV9dpO71e0+2K1IdPHee3x4jeZu6b?=
 =?us-ascii?Q?BqaK6KOMM4/DpjigzTJ2+7dtSI28daAsiapvu9wpCWkNEp15A/eIWA1sxjSc?=
 =?us-ascii?Q?xDD9jpGvcfe/ru809Z77SFmuxSpM47yzlks1ozXjlw4iwz8GfCFQ0mUP5S0J?=
 =?us-ascii?Q?WZhrEZ4cGS+PP+J03bA5+gIXzbKAK5RTuBS3kKhI2BroYh3j+ezcZSJaGIp+?=
 =?us-ascii?Q?YHOqii+6WhsUXz6ZoPKk5oRd5Ysf0KsK51JGr9RVB2U3j93Ni/FEfVZ2njtZ?=
 =?us-ascii?Q?fa8G4cdgOYfdzngj7OAqKCJSXizHamgrf6bCsR+WDnM6gHYdd34NBdAIBlKM?=
 =?us-ascii?Q?aZheVFSTBGSnJUHAxmRKtWlG0/zGNXE7T/iemMwjAQ4gdTr85scH0Ip9tU2x?=
 =?us-ascii?Q?ij6dpigTlEQCyVerx1rgKAVtvGpYgRfQeUTsJE0uM8DDGRayaDlBTPjlVLZw?=
 =?us-ascii?Q?PmgvkY7JoA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	L/HEJ6IeozZfI90TVX+mzdtGyjpPKTHBln2ZJxM9c8cosi2Bo1z2jkvA2j9frfQUrEbJnPGo6kBNXigcJ9Vn3khCljdxsI8/WD20kwh4iSwAFnNaVATVOIN1RmMZfcYvgwhcc3JXeDPUdtg5dASIyL9HOjqbUJWWa5FPWki8RGS4A8MHJMoyauXL8ERmPXXS0gDqqHBXaw93cgopXAw87M76/Tl42X7+VIZdVMLPZV3Xsmqw2626uBeSOzw4fWM46T+VPkReMp+Ik7anNM7ry0AMhLtr8vn8+Ib2aX/AFmpQSfqHEdWKvIPagTgQkeAQdg496NEMFTHxqoAW242OUhjY84FKCHokjD3R3AACqJErhEXeEd4Pm17IrP5/XwKSiMg/mh0ywY4gSbxexfvHkdOnL4xAtc4q4xRZazzsLtZ3cByI68amB801SrVCN9+4CviylmprglxU2WTQIDiS7aqodmiqoaDPJaBMvH5ZSk7ByymRBuSJ4oH7IQgBx3vOPd8kLBNYOtzhmc/nJ/lCosV+jfbalxhlOSBYP76NJ+kyiv7fT5xnuzcE1okeeHBXYrWnzObCSMql8NVTinb4PiyZqHIYKlTAWFTlLghMeZQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48dfc7f9-a950-46a3-011e-08de5dc06812
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2026 16:23:29.5801
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZnK0BzgPjIbq/2N4dmXPU2OkuCwYB/HsjaCNjkijcHWvWDechpu4c03KRzLNeIBeJDE4BYanzWg9BgqsSb4Y6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4287
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-27_03,2026-01-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 spamscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601270134
X-Proofpoint-ORIG-GUID: xChBaeXn8tsw3rVTfYs97MeilS0KJFeJ
X-Authority-Analysis: v=2.4 cv=StidKfO0 c=1 sm=1 tr=0 ts=6978e685 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=Oy7RBdJ_-iLdDo7p6TgA:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:12103
X-Proofpoint-GUID: xChBaeXn8tsw3rVTfYs97MeilS0KJFeJ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI3MDEzMyBTYWx0ZWRfXynAK/4HdwvhG
 jgw0FJ0dLvnVp9U1xV1ZIPVJqOxicy5gvrG+NgaQMJniUO6HpRiCsmWfTeIkS6F6Y69JUZRPBpc
 06KikkO3ATSV4tLDhpFWHuI6ScrFtnvjc7a4sv7rihkqWWk4QHU9IfZzzSug+EtKn6RIiXw4g9O
 qnfgNk4qUYSG/93mu+jgq0flxaKoMpJCV6g5wQdxJiUl4aKhHWkmgjhzIjqzpQIZ2nqQdZ7Ouyu
 aKdCTj4apaj/8orqDg/02GHJVJbw91C9vw5+P4LV8WcguBTtq0+fmPAazCYT08SA2NV0Xf+bLoT
 dPVkZn+jfVxF53eR0x6GvPjdTNQWjvAnlLYuaYH03nmgJAftWCuveKvziz19OP52WNxx64b3jMu
 tBRqv6rjAOHBXELJh7verl8Zy9Y/pSxzJ/CLf/OZ2HvxbizbkBVSp8FPULjTuy15rUgG2GkzJVq
 v9SKsg1nd6NwsCqM/9Y9ejRYN+RpirJErZ205M5Q=
X-Rspamd-Queue-Id: ADD8040017
X-Stat-Signature: ohpgmaapxz5sd57bz3i8pspk36sht3um
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769531018-431057
X-HE-Meta: U2FsdGVkX19NHYx3fD0XKLCI4azBYilaRDFQ9QvrlExBXc63dU/fkIqNdTA1+XIKDC9YsZrFSyOy+Y0q/fjx4O5sSlPbRBDC9QK8KruGHVdBqRsTRMra1ks856+afnmwrf47iREuvjU47eCVU7lOhfF1H7xaau+CT1LiV/upa7P9cGQga5PPXQQ1o2VjyvIHuIkEnz9iMF9LDMap0zh/XWTJFvWPZrYFu0Bnnunuqq4gpUOjqrNOxHxNKEuiwoZ4fQ6tHO/zRCdbbk6GI/oZXKI0RiTPn7UZATWoz2M8obvJjV5nUXkdb7MknPRM9k9NHfJjFn4k52y2dbtBY7/B12NS1QKmKtBMW2Q2ZgWiN0cq4GfUk4R2GWQl/L2trrr53xsAEi85HPXzl6/NDMS5pzDSc3FIbNqGkrj5X1YH/1p9vzOL8DEzBPvclOyQSwOIrSANuiuHwAJiNY4Vsg91Rat132okxOSg3kyT1ttysDDzxD4R6VjACk3sdDAHO7CNx9xnEilyF/epkGaxYa9THin/4lqVaguLjgJlzcvIO/2PGPyINAd9X2PgyxK+EV+a0L191ycoKXPGK7esmwjxuCuGCzKL70V5Q3UocpD+hQ0HqYt84/5XvMgt+Eoyu8PxczmlpXpRVkSWKTu6EfOEE4VrwSsQujBcR+nZJlwgpe28puHwAaOgnfVs6gKruLnUHsYAdcPTBoQpgBxLoEJqm4moemUSql7RTWuV1hgFnbc3Jc5Qs3rwm1N81mHzOjuJNhp2Aa+TOCKxKXYFYpdmVke1S35Atp2NyF4VLdZxfYUFCTjGJcABayjHvpL6Gjpb6ZTKggSPmivgErWE1EJcba5mISZaOO/TL+15yqnkfl9I4dT8ynt+KbAvVoHhJDThpILS1BFTOPxn2ZXhMmOtgm0FjvCdZAO4WAeRBJLXKeUK5vHKUKqj3EOsLApvP96jVaTiXp06Ccx5VPIOFCF
 yKUxO9U9
 FI+KPoPE8TYrEgNYQEvnQcGNx2VyRA9Pm6rD9DwwSzFBzGuQmaG1IzW9LjdR2/RQtTC1cIFvZfxe4ZGQA1ZutWsit7rDcrHqhUDISJu4Z9+OCzqGdkkrftD7Q3QMbpWKwm7vWFZzF71vH3rpnJBqO3YJYuvFuTOgTZfD4y6gd6z+d9rqt784+qFKUvVuDUUQLiUgtWD4xE1b2rdwplvg5XKZCcLnxBe+GJQV1crtsyQvhoB4iTiLeiyU5dQOzm7kvEVJYVRIz+zXSD9lq3dyLcO6F4P98bcofNNUO6rSfhK+CYjH5XJ8weRWOl1geRYs1vPPnGCzi//+ECWofDPcefnwG9QMqlUfCddGxqcQuXLkPrn6zfyBG20wrEC8x1+Uat0DQkPIp5T/203Sr3dftc5FSuOANADZI3jncAc4zgTBdCIoUruiP1YqwmRI4IAYmJDlZXnyokEXhxbWxdkcXhqWlQlbe6z2/jDHCuFDKKHAjU0FYL1UvvztvRWxmgwSqUfafOUcHIo+PI5xzKYnk3nPoi3MTAZWd0SMKPevtjxKzOdnMeWJJQae9Z5HccpTEH2Op//QN9oH+cG1MhuIsdCC1Rv9OjsyK3mqmuO4WUe5Jg6Nza3BIJQLP4A4asFHJo0BWBDQNtcCcLuHn8M3NI+m4FqRATbeHAyWWzpVNoZ4I/snVEjQOQT1fPg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Vlastimil Babka <vbabka@suse.cz> [260123 01:53]:
> Before enabling sheaves for all caches (with automatically determined
> capacity), their enablement should no longer prevent merging of caches.
> Limit this merge prevention only to caches that were created with a
> specific sheaf capacity, by adding the SLAB_NO_MERGE flag to them.
> 
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>

> ---
>  mm/slab_common.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index ee245a880603..5c15a4ce5743 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -162,9 +162,6 @@ int slab_unmergeable(struct kmem_cache *s)
>  		return 1;
>  #endif
>  
> -	if (s->cpu_sheaves)
> -		return 1;
> -
>  	/*
>  	 * We may have set a slab to be unmergeable during bootstrap.
>  	 */
> @@ -189,9 +186,6 @@ static struct kmem_cache *find_mergeable(unsigned int size, slab_flags_t flags,
>  	if (IS_ENABLED(CONFIG_HARDENED_USERCOPY) && args->usersize)
>  		return NULL;
>  
> -	if (args->sheaf_capacity)
> -		return NULL;
> -
>  	flags = kmem_cache_flags(flags, name);
>  
>  	if (flags & SLAB_NEVER_MERGE)
> @@ -336,6 +330,13 @@ struct kmem_cache *__kmem_cache_create_args(const char *name,
>  	flags &= ~SLAB_DEBUG_FLAGS;
>  #endif
>  
> +	/*
> +	 * Caches with specific capacity are special enough. It's simpler to
> +	 * make them unmergeable.
> +	 */
> +	if (args->sheaf_capacity)
> +		flags |= SLAB_NO_MERGE;
> +
>  	mutex_lock(&slab_mutex);
>  
>  	err = kmem_cache_sanity_check(name, object_size);
> 
> -- 
> 2.52.0
> 
> 

