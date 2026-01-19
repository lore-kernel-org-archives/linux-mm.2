Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F024BCA5FF1
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 06:42:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 390026B011D; Mon, 19 Jan 2026 01:42:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 343F66B011F; Mon, 19 Jan 2026 01:42:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E81C6B0120; Mon, 19 Jan 2026 01:42:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 066AC6B011D
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 01:42:09 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A5A9B140532
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 06:42:08 +0000 (UTC)
X-FDA: 84347768736.20.C37A7A9
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf27.hostedemail.com (Postfix) with ESMTP id 449034000D
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 06:42:05 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Lr8OcrMX;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=XPUvWeSn;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768804925; a=rsa-sha256;
	cv=pass;
	b=obHLJw9r29TqYl2+ELSguto+tfI3HwmRNPiY68nRut88RIq1uc6f7BFncDJh9rKKeEY9UP
	U8OInk7wNSq0H6/rdoegKu2tXNCPSiiVco1uY7pv0+g+rKv9UFoEAt0+9Pjso93UHYjF2l
	BxNG3xmjcd+NkbfzkliqOEcbovYiZuI=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Lr8OcrMX;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=XPUvWeSn;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768804925;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qys+lJv7r3+INwG3kLysHL4NNjlai0WEYBKn2KeAYAc=;
	b=HJpRNrGFAJ4qLRJd5JJZ7+G92iuQYnz0AIYDiX6bej0tpQo3kpe/6cDmVbLnxwcGB6TYQN
	yJXDulde3ydSEHqXOdXdwikrWg65ki6EtyfNmv14x/8CE+L3XpxHpHozt/mS7KMSBFEARZ
	nDUWhR9OXqMP3XMBq/W2aGlRvvkJep4=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60J1cHr2116105;
	Mon, 19 Jan 2026 06:41:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=qys+lJv7r3+INwG3kL
	ysHL4NNjlai0WEYBKn2KeAYAc=; b=Lr8OcrMXvzOPUDzo9cE2lT6hUQk/EjWNP2
	UHOyk2L9WEx1g91GjM+hH2CZfp0t/TrWmPKY9SjclhT7xgo8EjLkaCWl/GxHE5Al
	pEVAwEdhomF/XYGzSpMZnuQZXQHPvyaiF9nDU4uVrdXTaY0fXh/HQkYDbFsi/XdB
	ZC4miXJK+QqzbmylPjRbpU9AoPgBMedMBtCMLFs9lpIFuBea5O1HXbU8Qy8A3g8o
	MvnY7SysF/jAj99CBpJQq2Na+bmXwf+7+LibeBjyEgFZl+pbRYmsxBCeR+nq/x5d
	PlbO+xhL9Z3X45TQ4RZrvc6YNY38H1+pxC6YFjn4gn7o8q/qeWjg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br2ypsq1y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 19 Jan 2026 06:41:57 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60J51fto032836;
	Mon, 19 Jan 2026 06:41:56 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010066.outbound.protection.outlook.com [52.101.85.66])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vbrmyw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 19 Jan 2026 06:41:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X8uhl/U9MawagiGmG9JDhJ0/EE98ges6y9TSXxZIf+5+PfvyhrEUC2b1MHkJVgh5cQOULrhnTcAc3qCDvyMQgdaorsvoGGph5gSuWkAURLqozcH2LWkAyUqzf5OMR4m6XWTwRm/0QFzaNUVrbJwasW7gmUGbwYNiXpmgvfBNiI6h5xTXRNHYgoEibnk2AR+BYKZtS56XrRMf7NIoPoa98QSZVVEPY0wN7ymzccUsAGD2W032ybkMpnGzZw6LXb8QUOlDbCdPS7OiDhbygD/m5b6D1Y9yDisZQMIbt9EB/ijl6kw+XOad+frGiWem1gNmK+zPaXgiwXoTGu7pEuzFLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qys+lJv7r3+INwG3kLysHL4NNjlai0WEYBKn2KeAYAc=;
 b=aYlw5mHEysRmj1WzSdMpQULdx0LOfGa2Orw+WoC0Vf34+xVUWvPCpEhou2dgFJsC4E78CICayHxL6y5COtGMlqc8RtC7LHrUqfSa9HRlhtoglljtHbfgquHHrf78oXbRcIDDwIk1lv/n71LUWva68PVg1b5bI4TQ/whR7UHqd7ozdAZHoa+6KanpvdSWfZgS+w6FvdJW5HPnJw+3Ky+N9jDVK/nKcF6V/YEIjOXva1O9LI/39agTX2uTAzcK7Er2ze3fcTcqqZQcwULO5/uY60nCB2qqq7+5wkdwYHq6w/ezdd2zCUOA5QS3RrIFimsBGmSPQDuPk+GeniQ2/Ngm1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qys+lJv7r3+INwG3kLysHL4NNjlai0WEYBKn2KeAYAc=;
 b=XPUvWeSnNMC/OganzPfKjFfBiX1SsWTr/9p3XduDD41BS8yRRYFGRNAhaI2BkRyankuNH3tFERpTb0mtnh+VmaAf4GrQuNQ+x7/0pOf/RCkiKzdhgmNsAeT1fhhTCsTJjpG99Jw029iU1u/o60yRvvfVrt3IHXJc58eky1ClqUk=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by PH0PR10MB5580.namprd10.prod.outlook.com (2603:10b6:510:ff::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.11; Mon, 19 Jan
 2026 06:41:50 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9520.010; Mon, 19 Jan 2026
 06:41:50 +0000
Date: Mon, 19 Jan 2026 15:41:40 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Petr Tesarik <ptesarik@suse.com>, Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>,
        Uladzislau Rezki <urezki@gmail.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
        bpf@vger.kernel.org, kasan-dev@googlegroups.com
Subject: Re: [PATCH v3 09/21] slab: add optimized sheaf refill from partial
 list
Message-ID: <aW3SJBR1BcDor-ya@hyeyoo>
References: <20260116-sheaves-for-all-v3-0-5595cb000772@suse.cz>
 <20260116-sheaves-for-all-v3-9-5595cb000772@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260116-sheaves-for-all-v3-9-5595cb000772@suse.cz>
X-ClientProxiedBy: SL2PR01CA0006.apcprd01.prod.exchangelabs.com
 (2603:1096:100:41::18) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|PH0PR10MB5580:EE_
X-MS-Office365-Filtering-Correlation-Id: b3f6581b-48e9-4c8c-2dad-08de5725d327
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?aCGvQgb6EpmbsvoDD63Chf4WIc22XHGH6Wcl5IG55lA1YpZf0q3MJ4Hz1Kp2?=
 =?us-ascii?Q?FbzHpvzTGW0P2DIVUmRj94wTPdSWxaUmDEJMokTtQbBmeD182oUlBwVaNeVX?=
 =?us-ascii?Q?KXwdK5nO6/D8oLnMqLXiRk+6n2QYgO0/KafzSptIqL+Cs9YZI9YCCy3RAtsx?=
 =?us-ascii?Q?L8i9tQE5LyFIP7IRZ3ox8CgSmGDrtcXjMx4zp7yNiNI79LjU6oZXLKWPksbf?=
 =?us-ascii?Q?jyP+myvsi+M1GFrnkBuET34lGr5C23b5FvNR8TohSMWMV5e08Fe7gAfL1zEI?=
 =?us-ascii?Q?lPco+XmPuA6sNxlSNQXPoeMS2kxApHxqxhviLsMLO0PeI7vxdGxPRbrhH7Ul?=
 =?us-ascii?Q?yNyer8CiCJSNrnD8cRTlD913qtYgdw9cmzjM8AKczbm+/ANQ/0LAMgLnD7vj?=
 =?us-ascii?Q?c71NpLZXoTRweuAcvk4ZR2JgZhwhVAL8X1F3bJKIdBzPOefLZ0gCq/vu829n?=
 =?us-ascii?Q?NI5ps4tEvhpJ4c2ksYt5b71FxXf1ML3ozXRnBvQKVoY2/WGL0PhFMTJX6fyE?=
 =?us-ascii?Q?3lURkwx41/Hyio52T7bKNxgbFX3+eTeAfQ7pJGFsAMJKYkKI4METC62aw77n?=
 =?us-ascii?Q?A77taBtEc8J2mo0AyEq0ddaoIzVt4028N/yf6GEVPe1aL9ZPOnNAUN5lDeC6?=
 =?us-ascii?Q?PKZBY2UK0WSgS5aRVA3ub2X9AiH33JXaasnIwcG5ngj6lE03xX0dBXcosz1m?=
 =?us-ascii?Q?rgFUytxR4X6eA7i31hv2DgvZl/D153BojEaR/yuXiSAxn/AueYS74AvwJVii?=
 =?us-ascii?Q?lX9JYlcmGMYmJcL/1OmDz5FfjZjTlMAbrW6L9EoE4j5FThj37z7UdP5GiWRp?=
 =?us-ascii?Q?t7aGOpwxMg/KvG1DrmLovK3ooq7Rt36RQIds8OEoM9cn6hiJzXM7lgNNWwqL?=
 =?us-ascii?Q?8/bOgkwcuoKRA+Tn90orzNx0pEWbZz7LoyHqUZ0HwG4J56VrcA1EmNgmYq6H?=
 =?us-ascii?Q?KBnfdIKs44cIDNTYaCcpI1x2ndxN3gZtaUGGG3yQx3ZROLyq2TDSRp2T2XPL?=
 =?us-ascii?Q?T2sU4qX4UvqGrR0Wm5NEEiaLifkemG41WwxuzVHyERJqwqvl+jcKDG7GpAEK?=
 =?us-ascii?Q?KH/QQ0/QmUFsRjBTNwWXPLeniLDdXeOL0qCfzJvHSTFogvnrgGz+KpUvj0IO?=
 =?us-ascii?Q?OiRiirh9rx12YH0pM3OQYlgFWfV0VJn8lGPRTWOjdgD6WmCkjxncexG3Rpid?=
 =?us-ascii?Q?rxYgFzpv8oJUaQmHVzWuGshrLatGaZQgYuX/qAvoRVUGgdYv69QN/rx++2ud?=
 =?us-ascii?Q?//xMXmZ0DJBbonzMchtWBuE0MoqOHpIzyO/g7Xe7SyZtQSS2LvOxnhg3BZiN?=
 =?us-ascii?Q?ELV/YTvSLvyO1DTuRDQ3P4AnDRxScSIBaAPQUhEzseHouBwTQiJtETmTKJZf?=
 =?us-ascii?Q?IgBh038WzrAvUzjizxCk3Y6LXy+rqjEWUJI0OnVPQx0Lzq72Z8Oq98xTh4PU?=
 =?us-ascii?Q?Qpq9magpFVtVfv0j4YwOfTLxSJzzfKlDAkk6ShDPDgQAdFjC4Sw+CbK/vStp?=
 =?us-ascii?Q?f/LVTabpfMcR9CX7u/Ye9mjWvjhxB0fPV79HJm0OTk9EP/JSKJl06pTb1SU3?=
 =?us-ascii?Q?uNxwoh2w0f7kFw0YyN4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?m6UCOBNRkq7/8Tt3pXD51+qzpEOm8lXc4N8eZw497nTjJfJaU1jgUDWWS3We?=
 =?us-ascii?Q?4LoquWMna44il4U1mzOAHuGD2aP1zmqzR9bs2639/4Oa1BIndRsA0eHV4gyp?=
 =?us-ascii?Q?VZohrXJG5g5RtAWogW1dNgXohXJ8cQpfeHoNwLyl8CzN/2X4SK37lGziXWVW?=
 =?us-ascii?Q?Kc0QNMX4xpm1KurZDOe31BnH10Q0nUuE0AzlGHOVej2gXbOouDijbOOgMyn+?=
 =?us-ascii?Q?Yt3KbMlKpScaqgev1+/QAK6aXm6vxphOcs5genydXRFPy7siyVZQvvcyIsIa?=
 =?us-ascii?Q?Wc7rmmC8gcFF2mKNc1kSY0BoMfVK9i/QOJN2z4+6PGkan/7QIOuUdm9AxZVi?=
 =?us-ascii?Q?KPM75ggaobmVJZ8ulAe31C00qIJc0X3lYnTWVZhewAFeJ1P3Mmo3liHhhvLv?=
 =?us-ascii?Q?38mN11PJk6F/FL0y+EXfQLMDlgq9w7Pzb6rt4bE917H1CLYknZWgMl7nM1qG?=
 =?us-ascii?Q?TV3ptvsoK9U2k1kS6W/hKV4IFmAyPiegQIbaAlBqjHATl5tA9CHs+vPxejiB?=
 =?us-ascii?Q?VvO/6u7nezbwe5gq73uYQcpmbTxneTB6K8c/AeSuQWveP/FPz2eQRfcPRgH7?=
 =?us-ascii?Q?zkFn+2KkQQpLSLw1OR2ZB8Rv6msQsP/lKV9WQy1aYho/wVcrYKPGTxYhFZ5a?=
 =?us-ascii?Q?460pLbHxLGVfViW/gfu/QiZ6dDPWC3nvkjj716FC2Cc5L4CQ6wCxop7TckLn?=
 =?us-ascii?Q?X/iaQpMFdGxSUjiX1m7Hd5swjBopQcvWgE8MhoH5iHQO690MCJK59yM6mzBD?=
 =?us-ascii?Q?+RLSgDqxk4G/p4B6xPmR+EwhzaquSha4SFDgLOw4vVmxFRTCBPGtDyyTihnF?=
 =?us-ascii?Q?vf72CoLZ0fIVB7d6XQ1dOvymTitD4Y5Ycu6H8LmVcc93B7SXpg8eWjO0degD?=
 =?us-ascii?Q?MH9nIGrDGlf93Xj+qwtcsl/LTPhs0cDPJAd9IgTJ6/zlRwM9jreosI7Y1fvq?=
 =?us-ascii?Q?wysqeV84tcXu5DcFoFVRhfu/lY9I+izXDQvXDU0KIYcpdYRyA6OvjJ9r2xbB?=
 =?us-ascii?Q?wiwHg4k688Cp9ENIE9ywPz8WNXfpNFGFnip/HPBKyAnwRGnABxfnr+lVJ0AT?=
 =?us-ascii?Q?d+2S3NnT0uPXicfvEqZ90AaX86icPWS+jG/53iLnhLiiGRcQC/W90Z/HGWsT?=
 =?us-ascii?Q?5t7XKSiErnzkMNp2EIlK5ukI5yJ/N21YQhlLZt2exMvqW3zQsNG+CArlSRYq?=
 =?us-ascii?Q?92hA/5zzWBZocolXqJyNO2E2+99tpxZKClSlvnNJlSxUrPM9vxNEqVn1h1uV?=
 =?us-ascii?Q?TWMu5Bp/FgVXEmKNiynp5iBEaempln+4TPPuX9MKiNph6BTlGGf6Bbsp3Xzk?=
 =?us-ascii?Q?sEBXBw3mhsb4CTe7hV4uKY/aRvMXrCcecX/LBu6EffztgD+MNmV4fvxWwfr8?=
 =?us-ascii?Q?ZiSNkYbTtRwb6NKTw7qy39bNXjW9FBYw7tJRW+aaR1mqrUKHfTobPD6/v3bJ?=
 =?us-ascii?Q?U9Fw2hL/yII1QNqrdAZwsA3VT89SsLJWiHXENiNMrxbMqhJSbsjzdCcAqWT8?=
 =?us-ascii?Q?76k/vj9CqixKBVvcySxBk8BaHBfIqfyblacM6zUvHP9PoxljbapWIy9KEXy8?=
 =?us-ascii?Q?TWb/WoxX35EJf3CVGx2UZFB2/KQLsjDM66RD9fWYehsaL2t3vHKDafbdAekx?=
 =?us-ascii?Q?zHmYNDvQ5e9pjIhfekO9AVgRbBllXq2PWx6LRmnXCmjL/cIVXRefPxlzobdc?=
 =?us-ascii?Q?G8jIkLPWE2zooUGdOzNOcUckzCIhWMvBQnTb43+eKSVDEYTuMbKWpGVr7OFb?=
 =?us-ascii?Q?mVd/307lzQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	V2oKc6UW0ucQBaNkVSQT1o7JZlXCnzaypa8z+xgVL0cweP1UJBRirCA2rtkppaS9k9dF5Dz9EHsqC9/oVVf3oLYnqZHAHCEkR20g+y86eH/Icqz3TG8HVzo6IMlU5jA4Z35KOEK7/IRlSNqAtmj00vHGFlIHWOFL5RXpe8BuCoVr1UsasSQkSbMmllQI8DOKrud8CM3eF+afpgpGGKboflc9RQXt4nJKC8iA6CK5UZypR/luj0gpBLZd9uayaC2XUqfG3VrldArzDNMcyzuxKFH1WT1I+Ju0lbtKYh2i6/Oja0OMV1UaEgmWnysvuj5bERY67/bUdTGej/Ifsb4PlxbI+m9hoVeDEX5KQWuyYTZ6pHMrxV8rFHE7mYl+VEwq2IDmDptR6Y99pQC4nyTHOXPKiuEWeGIXxCLoCtVNJq6QfL34opJpNfZhLiM3YGhRozjKJ8ClR4L30fAuqNx79HlJ6EOTPiLN89MjKITtmgH94aa8hL5fc3dhAOycA5Essd+od+qpqLQ2KNPQsZFU6fsEx+8eQWMPyP7bn67cAj80bGRLHlAr0I7Zb59sa8lVEAUX5XgO5L/F0aO2LylVNI1QW42GklfvWtEVjo+fCZ0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3f6581b-48e9-4c8c-2dad-08de5725d327
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2026 06:41:50.4389
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EO7d+9Gbfy5CJ3E1e2JTOT1NQuLyphLywjcudPPXuJwnnPx+Kd7x5JxnHhhwY8s2ON44d0qutSJLPZ/O79jGPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5580
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-19_01,2026-01-19_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 adultscore=0
 spamscore=0 phishscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601190053
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE5MDA1NCBTYWx0ZWRfXxBB8U81HQHRK
 tu8jP6y1MoVygYcD6mujwsybAacV9d+n59x7yny0SsCDFnMDC/XZmNq+fLcKRC1rdgZ4u44aXRn
 bytN3f/vghIQiKP3/Nq20jp85KurFMrTC3t5m0mHgoWkycSzNB5MzUPYigpGn6c/hybBqRzJPrY
 adIh+PDpzlOw8pagjAGBWnpt01G1w4mwUb+GP1AS7l4z2rkoCpVqyHUBR0UrXUX8DSdUP/6AEhp
 vIdVAnyWwuawP3HV1vMMYp+GWLMgNIH3E4Pmx8uoaVwUuSt73qhq5gZJINR+YpY8zFKawVYOnqV
 DumPYUvo4gNcmbvQlSoRvm+vUOCXjFDfpJhIDx5TxQZ39rA4bEt128L4R1tX0fGsxDjGdHbP4cu
 QoH+S0NleqqtuZTDSvmBPVqhjM5yMccK4ZYIRqxBUBO4GtngmfUs/uRKQ5njc4n9+FscFQAoSEJ
 GJjGsSpjFdufMgFRYCNgnGORLOplphg4XQ+VTCS8=
X-Authority-Analysis: v=2.4 cv=de6NHHXe c=1 sm=1 tr=0 ts=696dd235 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=rNssqR8MEun7ibg-cOIA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13654
X-Proofpoint-ORIG-GUID: ioUXTpB2R86zeJ_kpBU3H3-7bp6yiiM3
X-Proofpoint-GUID: ioUXTpB2R86zeJ_kpBU3H3-7bp6yiiM3
X-Rspam-User: 
X-Stat-Signature: 44yjgprp86yn33jzta988njisy7xf4wk
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 449034000D
X-HE-Tag: 1768804925-424800
X-HE-Meta: U2FsdGVkX19OHUEnkyOQ2I7Z4uHVRYQk/YHtvx6M+i0KGMRPJsWqMC7fJ/O+tdGvXmS0ZdnNJ1CmLauerIg6KeGeqeNJ1HhaIyyUxC1xbOvuccBx1HrkfM15qjNIDLr6Tgyc0NxK6Z7Ngb/siBRKa2qjT4xq6GVe6ia4pW05zXZk0OPjWgVDqhtOMLd3JCCQ1NDZiJGJ8ASswnjLnLeI2H5LMypdTW9ooQJWuu+CiwpKnjcnvv4hQFBDmaDafeIseZl/N8zWCNSyiHxbK6jHl8AXZB/YPPF4RpWF+N3xLYPTdwdDldOiXir5O0CvnMycKHLLxfVXn15yQHTnqWQhN/IljXfXvLCInOCK11pKZvoPQMBcTshTHofLn+5xrtsYW4Yasp6Ep+RwCtMFns1lWVGUyhNDY9Au13PsQxBRPKfoxIfJ2O3hUaoLPOpgDIFNrhC6KoVgWYPewD6062WHKYcs4dGx8xM3WV9IEuBpBWZ/8jxEp0yMYc5FT/UG1AnssFOzwX3Gnxz2zhlnVE5HZ47EdHTdXebdt3xg0joTyIRfa7TERBZu4q62QUlEhRgmUKSOlY4J8ClfP34KoLWtSZLXC3OBk6MAF4a4Z0f8zMppQUX4Y4E2q8eVaaRzprKH8EpyMt9xiJrAYr9avAD14sn62uK/qNHNtJDszbcZNbC2MGlw6pnmC831K0YJcd+AmYXmCmqktapG5rCG4hXIHEnLT+lt1oSF+yP89wKtVaG5nBTHxk8XcvZJrXA/EyHdKGn7QCGA26al03QiU3tgc8VIkdBoo3cIg0AhU2g8+TMiwdjpa1TgmUYUDLTyy0g4atzJFEkVLOzS4JF2bEKpzPUU5Hy5iGtCCEjWUkiNnJ0pMs8jQTtUOhT9ogFWvzsbawEiQLHoa7vnr5wUS0QHcNf7T47KNBN6ygVwUWrlo5JE13hBGEqhTeGq9Zkc1oLuwn0X1DFj64o6aEGcmHy
 qnjMnJZE
 2HtF5g4cF9bsmy5N8IS+NFtfRrPmHBisA2cQkTzHdW+yHgqrZNXtvMUl3rase6jGr4bKmb5j/vHpAMUb+TZyqYk7H+m9X5OX2FBDrn/2g6O7gEllURniRnqShtr0Y9n8IJH3czIpwBbly+2q/+dfJWXNdVdYeXC/GXO8heZjXqw2icYpWr8G4juRi1pJF+RYw9TqIw1aHHdasZdw/eI3Wy4htpJ86Pmx4bYIU3suAFiPW+dyCU0fwA1UCYn+vR8wNhFdXewRpijkognVoVd7Qm5HJYRnCziYkwYgROZBdmi+HWEq/kou6udPjBuekvQrbfM+P1Fi4cif6RpqtzV2rAGVMS3ZG7m1l80+NsvK5X6A4NwcTA6+QEdyh9AZaKor3Sp9fHhdvyO8Bov2EVXkVNdCT0DcAUsCnUvkKNuqsIwzPE+/5W6e8c/UBbROJY7mZXOHbQ9Nw7kmofKV2vgRpl0Ppeolp+AyH9q4jMcV7hXb2kxG86QFoz0riWOVbpSf5dpmP3HmjveJlNybP6CYY+Haw55h1jFdeG/FZwdhi+0PdeBZnbUKaJGWowAm2s2pjA/KdqSIOtvxpKxo0knBpZfg+8n+mHgL/xo9XvL3yo0iTNQsw2+Ib2hRRkikdAkMthKagERMUwyqk7lBQiSEcae9LgMnvAKisSKIH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 03:40:29PM +0100, Vlastimil Babka wrote:
> At this point we have sheaves enabled for all caches, but their refill
> is done via __kmem_cache_alloc_bulk() which relies on cpu (partial)
> slabs - now a redundant caching layer that we are about to remove.
> 
> The refill will thus be done from slabs on the node partial list.
> Introduce new functions that can do that in an optimized way as it's
> easier than modifying the __kmem_cache_alloc_bulk() call chain.
> 
> Extend struct partial_context so it can return a list of slabs from the
> partial list with the sum of free objects in them within the requested
> min and max.
> 
> Introduce get_partial_node_bulk() that removes the slabs from freelist
> and returns them in the list.
> 
> Introduce get_freelist_nofreeze() which grabs the freelist without
> freezing the slab.
> 
> Introduce alloc_from_new_slab() which can allocate multiple objects from
> a newly allocated slab where we don't need to synchronize with freeing.
> In some aspects it's similar to alloc_single_from_new_slab() but assumes
> the cache is a non-debug one so it can avoid some actions.
> 
> Introduce __refill_objects() that uses the functions above to fill an
> array of objects. It has to handle the possibility that the slabs will
> contain more objects that were requested, due to concurrent freeing of
> objects to those slabs. When no more slabs on partial lists are
> available, it will allocate new slabs. It is intended to be only used
> in context where spinning is allowed, so add a WARN_ON_ONCE check there.
> 
> Finally, switch refill_sheaf() to use __refill_objects(). Sheaves are
> only refilled from contexts that allow spinning, or even blocking.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  mm/slub.c | 284 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 264 insertions(+), 20 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 9bea8a65e510..dce80463f92c 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -3522,6 +3525,63 @@ static inline void put_cpu_partial(struct kmem_cache *s, struct slab *slab,
>  #endif
>  static inline bool pfmemalloc_match(struct slab *slab, gfp_t gfpflags);
>  
> +static bool get_partial_node_bulk(struct kmem_cache *s,
> +				  struct kmem_cache_node *n,
> +				  struct partial_context *pc)
> +{
> +	struct slab *slab, *slab2;
> +	unsigned int total_free = 0;
> +	unsigned long flags;
> +
> +	/* Racy check to avoid taking the lock unnecessarily. */
> +	if (!n || data_race(!n->nr_partial))
> +		return false;
> +
> +	INIT_LIST_HEAD(&pc->slabs);
> +
> +	spin_lock_irqsave(&n->list_lock, flags);
> +
> +	list_for_each_entry_safe(slab, slab2, &n->partial, slab_list) {
> +		struct freelist_counters flc;
> +		unsigned int slab_free;
> +
> +		if (!pfmemalloc_match(slab, pc->flags))
> +			continue;
> +		/*
> +		 * determine the number of free objects in the slab racily
> +		 *
> +		 * due to atomic updates done by a racing free we should not
> +		 * read an inconsistent value here, but do a sanity check anyway
> +		 *
> +		 * slab_free is a lower bound due to subsequent concurrent
> +		 * freeing, the caller might get more objects than requested and
> +		 * must deal with it
> +		 */
> +		flc.counters = data_race(READ_ONCE(slab->counters));
> +		slab_free = flc.objects - flc.inuse;
> +
> +		if (unlikely(slab_free > oo_objects(s->oo)))
> +			continue;

When is this condition supposed to be true?

I guess it's when __update_freelist_slow() doesn't update
slab->counters atomically?

> +
> +		/* we have already min and this would get us over the max */
> +		if (total_free >= pc->min_objects
> +		    && total_free + slab_free > pc->max_objects)
> +			break;
> +
> +		remove_partial(n, slab);
> +
> +		list_add(&slab->slab_list, &pc->slabs);
> +
> +		total_free += slab_free;
> +		if (total_free >= pc->max_objects)
> +			break;
> +	}
> +
> +	spin_unlock_irqrestore(&n->list_lock, flags);
> +	return total_free > 0;
> +}
> +
>  /*
>   * Try to allocate a partial slab from a specific node.
>   */
> +static unsigned int alloc_from_new_slab(struct kmem_cache *s, struct slab *slab,
> +		void **p, unsigned int count, bool allow_spin)
> +{
> +	unsigned int allocated = 0;
> +	struct kmem_cache_node *n;
> +	unsigned long flags;
> +	void *object;
> +
> +	if (!allow_spin && (slab->objects - slab->inuse) > count) {
> +
> +		n = get_node(s, slab_nid(slab));
> +
> +		if (!spin_trylock_irqsave(&n->list_lock, flags)) {
> +			/* Unlucky, discard newly allocated slab */
> +			defer_deactivate_slab(slab, NULL);
> +			return 0;
> +		}
> +	}
> +
> +	object = slab->freelist;
> +	while (object && allocated < count) {
> +		p[allocated] = object;
> +		object = get_freepointer(s, object);
> +		maybe_wipe_obj_freeptr(s, p[allocated]);
> +
> +		slab->inuse++;
> +		allocated++;
> +	}
> +	slab->freelist = object;
> +
> +	if (slab->freelist) {
> +
> +		if (allow_spin) {
> +			n = get_node(s, slab_nid(slab));
> +			spin_lock_irqsave(&n->list_lock, flags);
> +		}
> +		add_partial(n, slab, DEACTIVATE_TO_HEAD);
> +		spin_unlock_irqrestore(&n->list_lock, flags);
> +	}
> +
> +	inc_slabs_node(s, slab_nid(slab), slab->objects);

Maybe add a comment explaining why inc_slabs_node() doesn't need to be
called under n->list_lock?

> +	return allocated;
> +}
> +
>  /*
>   * Slow path. The lockless freelist is empty or we need to perform
>   * debugging duties.
> @@ -5388,6 +5519,9 @@ static int __prefill_sheaf_pfmemalloc(struct kmem_cache *s,
>  	return ret;
>  }
>  
> +static int __kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags,
> +				   size_t size, void **p);
> +
>  /*
>   * returns a sheaf that has at least the requested size
>   * when prefilling is needed, do so with given gfp flags
> @@ -7463,6 +7597,116 @@ void kmem_cache_free_bulk(struct kmem_cache *s, size_t size, void **p)
>  }
>  EXPORT_SYMBOL(kmem_cache_free_bulk);
>  
> +static unsigned int
> +__refill_objects(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int min,
> +		 unsigned int max)
> +{
> +	struct slab *slab, *slab2;
> +	struct partial_context pc;
> +	unsigned int refilled = 0;
> +	unsigned long flags;
> +	void *object;
> +	int node;
> +
> +	pc.flags = gfp;
> +	pc.min_objects = min;
> +	pc.max_objects = max;
> +
> +	node = numa_mem_id();
> +
> +	if (WARN_ON_ONCE(!gfpflags_allow_spinning(gfp)))
> +		return 0;
> +
> +	/* TODO: consider also other nodes? */
> +	if (!get_partial_node_bulk(s, get_node(s, node), &pc))
> +		goto new_slab;
> +
> +	list_for_each_entry_safe(slab, slab2, &pc.slabs, slab_list) {
> +
> +		list_del(&slab->slab_list);

When a slab is removed from the list,

> +		object = get_freelist_nofreeze(s, slab);
> +
> +		while (object && refilled < max) {
> +			p[refilled] = object;
> +			object = get_freepointer(s, object);
> +			maybe_wipe_obj_freeptr(s, p[refilled]);
> +
> +			refilled++;
> +		}
> +
> +		/*
> +		 * Freelist had more objects than we can accommodate, we need to
> +		 * free them back. We can treat it like a detached freelist, just
> +		 * need to find the tail object.
> +		 */
> +		if (unlikely(object)) {

And the freelist had more objects than requested,

> +			void *head = object;
> +			void *tail;
> +			int cnt = 0;
> +
> +			do {
> +				tail = object;
> +				cnt++;
> +				object = get_freepointer(s, object);
> +			} while (object);
> +			do_slab_free(s, slab, head, tail, cnt, _RET_IP_);

objects are freed to the slab but the slab may or may not be added back to
n->partial?

> +		}
> +
> +		if (refilled >= max)
> +			break;
> +	}
> +
> +	if (unlikely(!list_empty(&pc.slabs))) {
> +		struct kmem_cache_node *n = get_node(s, node);
> +
> +		spin_lock_irqsave(&n->list_lock, flags);
> +
> +		list_for_each_entry_safe(slab, slab2, &pc.slabs, slab_list) {
> +
> +			if (unlikely(!slab->inuse && n->nr_partial >= s->min_partial))
> +				continue;
> +
> +			list_del(&slab->slab_list);
> +			add_partial(n, slab, DEACTIVATE_TO_HEAD);
> +		}
> +
> +		spin_unlock_irqrestore(&n->list_lock, flags);
> +
> +		/* any slabs left are completely free and for discard */
> +		list_for_each_entry_safe(slab, slab2, &pc.slabs, slab_list) {
> +
> +			list_del(&slab->slab_list);
> +			discard_slab(s, slab);
> +		}
> +	}
> +
> +
> +	if (likely(refilled >= min))
> +		goto out;
> +
> +new_slab:
> +
> +	slab = new_slab(s, pc.flags, node);
> +	if (!slab)
> +		goto out;
> +
> +	stat(s, ALLOC_SLAB);
> +
> +	/*
> +	 * TODO: possible optimization - if we know we will consume the whole
> +	 * slab we might skip creating the freelist?
> +	 */
> +	refilled += alloc_from_new_slab(s, slab, p + refilled, max - refilled,
> +					/* allow_spin = */ true);
> +
> +	if (refilled < min)
> +		goto new_slab;

It should jump to out: label when alloc_from_new_slab() returns zero
(trylock failed).

...Oh wait, no. I was confused.

Why does alloc_from_new_slab() handle !allow_spin case when it cannot be
called if allow_spin is false?

> +out:
> +
> +	return refilled;
> +}

-- 
Cheers,
Harry / Hyeonggon

