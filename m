Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39F10D74ED8
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 13:53:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FEB96B04D4; Fri, 23 Jan 2026 08:53:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D67F6B04D6; Fri, 23 Jan 2026 08:53:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5804D6B04D7; Fri, 23 Jan 2026 08:53:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 416DE6B04D4
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 08:53:01 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D57DD1602AE
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 13:53:00 +0000 (UTC)
X-FDA: 84363369720.05.14D9877
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf02.hostedemail.com (Postfix) with ESMTP id 69A418000C
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 13:52:57 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Uxb6XbAQ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=U2DRGc8n;
	spf=pass (imf02.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769176377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RTFjiiu3wNfdGrxPtcBxm/kxxXEdd5qR+R2B7N+JjxQ=;
	b=m2n/fZdqTAVcbNkzJwQqL52498r9EZojlA0C8EaCuz8FjUcmiM/QA4TFkIYFde6cJPnp/K
	f8ivzEMOjgUTY1OROYVNbnYADvOuFxJ8NWHMgvrZZiODcap3/rYmQN5TQBP5ZwZ+eggVOu
	4rYm1vgJCcLcMw121uoC+pcYE65q9y4=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Uxb6XbAQ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=U2DRGc8n;
	spf=pass (imf02.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769176377; a=rsa-sha256;
	cv=pass;
	b=E1TGB6QExM90YqixmuwsvpzgqqPKs3mO2qUbv3HUnYprf/rO/Ft5LBBWDWo/mtN/17msPl
	F4jqA30C+kfkh5K1Kag98xFZyeKMzS2wreBXMmTjlwEl0XPRg+N2nAIZ1vMwLW2n4Jj6LL
	aO6wpP3f1LrSHkSZHLzdf64ay+hKa2I=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60NCwqMK1675111;
	Fri, 23 Jan 2026 13:52:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=RTFjiiu3wNfdGrxPtc
	Bxm/kxxXEdd5qR+R2B7N+JjxQ=; b=Uxb6XbAQ02uIObV/Avv+IsNIWOwOCc4Fck
	y6IgBQpX7S+kD4ZGWfC+oWPxdxxRrnTgVptoZYTQQdr/p1kO/Ikrpc7ybwFvMPcx
	GouprNci6qp5etNc7MsPwg5a+oJ5t6ksiw9GmYf+Z9YeGwwSdWI7886tna1/Jr5j
	ipLxT0/SImNx4nTmncU7WVxRNUJ7Qk08TPfveutYgcLv8/KadQL0hTpwnO2w47nF
	qJks/B4eMSWToj4S8+C2Imm+pT2BqgqZK+dTrDjq9PRCIAboWlFoKDUHMk4TNUYB
	Rij6kfUpZwlM4JyOCEU7fGcsvuamgTjZ6c6mjhcuQcUaHj+TXYXg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br10w2cvc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Jan 2026 13:52:45 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60NCZ7lF037975;
	Fri, 23 Jan 2026 13:52:44 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012036.outbound.protection.outlook.com [52.101.48.36])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4buswc1hna-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Jan 2026 13:52:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h10+yJQB489achKsx12OWbHaOejZP5Rr55f6rc1tqoYL8GRLHWpCk77zIPRyygVpisHFutW6pfODLdSheGkOBl+lwYy4fWEyyRoMZLcukqXI1wkrPwfZG4GE+7s4mlXbGbLHokSpixVhTALM0E9VfkjUlZAnJa3T95JUrnbainv2E3Ayk6ZMwMq6SmXKSsUW0SBBMuEJ2e59YJH6Y/pTmqNyAYTuaotEHStSi1YXJzzhBOO0HbKPEJwRo2JS95vt8BcO1VCbHEBTCW5EJaPLQFdc8z+9F6GNen84P6JoDyI17SJeTN0VglCxS3uTGAJPAWMDiE1gmWqlL282UYk+bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RTFjiiu3wNfdGrxPtcBxm/kxxXEdd5qR+R2B7N+JjxQ=;
 b=kiqO60pB3GyyUqLfOUkynukqzgWHsWLhnqq/wH01Heu64PMhFxvYx5MvbaQ5SxcrCD7YBQmKgSZEUrkB6a73isDEISLLIKZ31TRj9F0qG5sbN/40ja6VVcBpJVacQlpYYO457a1RE5b5HgERhavdbZ2QF6eSYoLEl5fr387T3gx2Xve98o++YDydHshZ70g4lKfaiFvqe4w5CRw1++DNX2IlkhRhONrJoc2nOUBT+poZcda+r+jkrEL96QSQ2GP7YiSc4GEOPxIP/2rRTZuwQXPIkim5mTSCjAhEu1y0XE+5yQnnVSfLwRgAGSMZawEe79ORHGgrQkYQuPEwMjQoQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RTFjiiu3wNfdGrxPtcBxm/kxxXEdd5qR+R2B7N+JjxQ=;
 b=U2DRGc8nBGQAl5tCkkJj4Jvhir+lQ2YBEvfSji21la6KaketUNdWNCHwuYh7G7+ty7IrzT/y9+F1Mvb2fOjBkYe55VdJE8PoCPs26yar4UtwEv9f9jpaGDNAIBM5YX5+CTFWp78sN9ow5stsjTAMda2yJ2NG8z7/L1GIxtBwgBA=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by DS0PR10MB6751.namprd10.prod.outlook.com (2603:10b6:8:136::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.12; Fri, 23 Jan
 2026 13:52:41 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Fri, 23 Jan 2026
 13:52:41 +0000
Date: Fri, 23 Jan 2026 13:52:44 +0000
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
Subject: Re: [PATCH RESEND v3 01/10] mm/vma: rename VMA_LOCK_OFFSET to
 VM_REFCNT_EXCLUDE_READERS_FLAG
Message-ID: <9f480987-a4a5-4c5b-bce3-a85bdcb487c0@lucifer.local>
References: <cover.1769086312.git.lorenzo.stoakes@oracle.com>
 <f637c1a5c9ea237aab598bd8885df48e21497635.1769086312.git.lorenzo.stoakes@oracle.com>
 <6c8b63cc-d357-4e70-89d4-07afd004bc83@suse.cz>
 <3ac3933c-8fc6-46ee-adae-e7609b5f6d4d@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3ac3933c-8fc6-46ee-adae-e7609b5f6d4d@lucifer.local>
X-ClientProxiedBy: LO4P123CA0606.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:314::14) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|DS0PR10MB6751:EE_
X-MS-Office365-Filtering-Correlation-Id: c40489ae-727b-486a-de69-08de5a86ad15
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?M2f+cEc3GoNBADYQr+cFkNRoNfyzBCs+TeRDYSktSVNwNsPv8KjZ3xMVLASt?=
 =?us-ascii?Q?pkS/bd+LIeNHkrwpr4E0drnYiyGspNk/x5TgxvnX+jI24ZKtwTUheSaDEOVj?=
 =?us-ascii?Q?XjaNz2vVfe1qA/maDhI+iC381B+sJq7dX7zDJP6oBawKZqlaY1gQ2lkoZTsc?=
 =?us-ascii?Q?hTwKRXzdyKk03HGnNSBtZT9CPu1Shs1leJIXzwDLRCBriyqsoVmfVJiJdrQf?=
 =?us-ascii?Q?PiRrB442tlTPzesOsIDwrC2SpTBTgGrTP+3UuYRZFG1fUvQmf0myn4EHxCYy?=
 =?us-ascii?Q?OgBsrAFzCZTz3pw7V1BQraPrM7bWCZ5DyMnBvV8hbjd+Qot9wyJC+2Zd5plD?=
 =?us-ascii?Q?kmD4IbIRLdaLXWM8F7cAxBiJvnaNm5sgv1jaljzDesIVJLk/szjTwsHn469F?=
 =?us-ascii?Q?rtVtRgp6ps6doi6LgE9FCkEqGdFv8W18SB9MV2lTu8VN2vhYSXfyxk0Cxkee?=
 =?us-ascii?Q?JRFhAmmTH+mfS0TTWp6xtx8gGGEj6dwBZG8sBil+9qTMdor8ViMEdI6RGEdj?=
 =?us-ascii?Q?QRJoOCPEJ7KXLNThKILF18qDtrnU+IKD5JXwF9gljlJ6Dhs3n5C8HBvFD6M4?=
 =?us-ascii?Q?VKK1CZxul3j/5y1usU4Abtm+PTRqXocPPx+BcbWYj6QWf8+/gaMgpEwcabzF?=
 =?us-ascii?Q?TWmjpMWbFR33azqp7lw/5yH67qzsf8S/dEbqRLTTH3xOTvTazAduYZAGrXRk?=
 =?us-ascii?Q?312vG+euV5RBK0nn/KSu7SnYt6TVye6Dn8hgZZXgbpmUzDLvaa74mvMPG/bW?=
 =?us-ascii?Q?bSgDVMww2eAUevfUwTA0B4dlbpKw7WSA3gSVVyT35gQFF3jXgy0s27+77OOV?=
 =?us-ascii?Q?DjxhtGXUwBta2PLW7LX77WUAXVhwYWZeGE8baI1BeQjMtPID+bQR75CJbaR5?=
 =?us-ascii?Q?z6ZNyPKo4YER2kq2m3A+vtTbgJAlbri2+yy/6Hbd83ScCg/+ixFxHPsonkND?=
 =?us-ascii?Q?/HcyYIj1Vi7JBbMOHSe9YhjUs4/3nSYxTYUvzu53G/Spq/LEDO5vbZ4S378A?=
 =?us-ascii?Q?obNuCRjsMwR0gh/irbvc8yiU5kSUAu5quITDVNZg8NrxYDiaoZCcdCfeBuGK?=
 =?us-ascii?Q?etEmz4qhODvhJp+06h8ryjwWHU6+PgZfaGWhR1z01ztVLPNbTpklCJRb95lQ?=
 =?us-ascii?Q?mqF28S+I/41ObwV5tFP4/ejlNYd8FfjFW6U+CPiWYXNtmOTY7yz1wEiuQ7nX?=
 =?us-ascii?Q?pqlLXykxORqE2EAVKa1RGcmb7z44l580WYB5V5nKsbaQlJOcOyzcfbKwx2cJ?=
 =?us-ascii?Q?N3DbtRtZwqOBCQYdJ46fisUwzuH9lkeuKcIwJum3n1Bz/+8p7C6X0L1on3p/?=
 =?us-ascii?Q?eaqOgNVE+Mvp5WKCSmMBKNxPtSVyBgb7fb8H7ZgoeVQH+coHmZZSX5RwBZM9?=
 =?us-ascii?Q?vdBajECx/QLXFu/yESuBmqob95kukSHH2x6YWofvCEmMlxEeETUgZi3zX8vR?=
 =?us-ascii?Q?CQkZPYbivw4ljj/pbGywlvflr0iWLthD4TejWMkqHZBC+8ZPwDvWOg893/lr?=
 =?us-ascii?Q?rHEW2xfyIk0qZzAeLlycJnwr3ijFD0EWQ17FDdB3bNfndXiixRWj90/p8Ryc?=
 =?us-ascii?Q?iuduMRXjyXmBk5u6YWs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BHYEj0XNp+R7phZ42Zte5pQp0Z72j8k61IrGZXme6F1JLwbb1AQI1GuD7cyI?=
 =?us-ascii?Q?ECkPVKsB1mvbc4L16y/apdyrjEqlkqecds0HA/UKIsTqBQNXejh1l/QqWtME?=
 =?us-ascii?Q?lQXKC5ZMjiCJV4juX1I3V/y7BIBMQNu7SYa44BBhHiGGqa2W2IkXtBLx+HdM?=
 =?us-ascii?Q?BzL9cEoRMg1I6Vo1CjTRhye58AR3U3ewtMf9DLh8FFKSXd3XwRrM2b+Ctz36?=
 =?us-ascii?Q?CqVisS9gYO1ERxbpX4SbU3rpofHQtQ+KFFpXanCXOpdpO7DTyNwpYS7Xnc4G?=
 =?us-ascii?Q?yCy+LfnNhjkV4/DiwL4TRTo6I4blygd4vH6qAaxHYUu+vO0z0qnEz+9/DJEQ?=
 =?us-ascii?Q?GtswO/lO0ZHp+T/yQl59ngeSg7DLnNRuJq3m5CjtqmmWEsTeCD1iXNHFtMPZ?=
 =?us-ascii?Q?ch+/XzvsTmbP7yI4ZzMftjnyFMh/g9NmlGGPGpcpShVdb+2yUPLdCs5tFFo4?=
 =?us-ascii?Q?K+4uGU/rfE1bRByuEVRAw+fKLRyXualCVi6GWHtckbJTSyStRlhpO/zY5wlp?=
 =?us-ascii?Q?fr9dZXwtKWY6NAUeKMu0Dqt76/pqaqhlxJPedz90HIpXOa0J1gijLjimsUNr?=
 =?us-ascii?Q?pCFhjH93i0sWHtDl6Izo3044U4Oz5RIyvLT+CzgMJFxfe6J2IFq6MIm0wLYz?=
 =?us-ascii?Q?1v/M2FcRpgymIRxSrkgZteEYkziE8Kkcwcwr9SDFsReyILP3hv7pmqKBC+Jn?=
 =?us-ascii?Q?OByPR/9Levt3dbuqP+dhzwKsBAsbsgXv99HG12DNmOwSXgFHiYI/7NuLskcL?=
 =?us-ascii?Q?ui6FbhATXEcPDHeTduJaHki1ziDTYFUeRa1O8gNXKj+0xi7dqwldwdjx3Gb+?=
 =?us-ascii?Q?/xfCjq5NxoJi/gXmSJ7d5yiupdtSpX7Ofs1Xk/x3okmV8MCHcJ9uUJw6j5qG?=
 =?us-ascii?Q?q7htDW6FKGe/75vp5QETv0bmd9UG+5WgYf2ThI8P/ZUB9D6NI2gFItx4Nzs0?=
 =?us-ascii?Q?aXvZWf0tR6WAGtgjObzCFxNjfHEJF20d5S1dxw4gLm+qJ1feXjO251dGgEvw?=
 =?us-ascii?Q?ZVk1ASsOCjn9Vl8dW+qVBbJLAZKWWBPDH59pfXQO7VfE2YfsVEO8Se5DxYH2?=
 =?us-ascii?Q?Nkuf8/M29sLzFAvVLpXb6A2btmmyNUlFozEWKKvhQwuSKAouCAGyG322MtGt?=
 =?us-ascii?Q?aAZD4/GA9ehJ8MFIRhiPkIkZxUzSpCLHDTHd11PA66TP577MF4dkLdWEF6VT?=
 =?us-ascii?Q?am+eKJ5lSQJCqGB/0ULxfC3/FlNdJtaNIFiWkVSDJobNSWNlZflhQdENV66e?=
 =?us-ascii?Q?McwkNXd7Sgu5FqxIg0b0bpaSm8mN6L++CW4F2yc4G63OenLajraYmkET9tTI?=
 =?us-ascii?Q?lOU8bAclqRAQ8rEtikWLPw/34OBds3YnFCZoV0WTXAaRq06/RT27DAY+OaUE?=
 =?us-ascii?Q?SlmBNZdZPAyL944jpn+7CUPOdCqomxquwNHkqQM6jw7IbyqAZ7XC3V7efQ54?=
 =?us-ascii?Q?Al45hnsDCktyYsYYWXXPHZuVVRacTlUAdEWAzZf8fatIkywnTJSJOFPFAn1b?=
 =?us-ascii?Q?ttndquJrIHopqdNRMz9jxwf4cHYbCwxwpKi2r7DVS8j0zaqbKA3AqN4KX2nk?=
 =?us-ascii?Q?C15FhqURl2yRbprOWAEjJ9bOcPwL3fTEALWUYbiJVORSkQjoN3OzTOe/6DeE?=
 =?us-ascii?Q?nBJFnHLorUY9XdYomEfKNZ1mMhA6uhfK6LV4nxqmneu5ZoDkoI+ROAjThhM2?=
 =?us-ascii?Q?ZrwZxZ6mEfGgIOPrSUV2FYSZkCkXCexg5TE+Wv4SvnpMModu+GgtA568Ve8V?=
 =?us-ascii?Q?AbU7RksxxSVX9/cAwGiyl0eQ1Bb3Dfs=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	QE6ER8ddw0sIH3EAc+FhplsOXDyBAcRh5xwhHEnWYICDWmIPwFYOhEUVqaM4j4dXxx0LamErZHxoUNE1PHZ5ixLEe8g/1waWCzEh6fsfAKdg1sG5dBPjD0kUCueNabK2qtHL9uhj+W4UJPgflAhDhGNxF2GnmAuqZNbHAIgBPHSj15yHYfl7PiV28FURiM22b3hgQc6lACJdkUsS56q+E+ICmZtCakoP6K21CfTKSswRFRzw771tY7ONOtfNxfT2fSNtVqFkL6ijGU3Tvi2+TnwdDt1VJz3ygI6C6mjL3JzYMIrFz3WSMoVYeAceN30d+tvbUvNnvXVyhqH5HZw/tct4neubI+dCf/SnFmPl2H/ZARxDjfreI5/azFWSxiTlQZeEnCKp2psBCIZhC9ui+nYGjNZP/w60QqibLT6nPqt9BeNsZZn8MC4vHdTQakrmmzapsV3KIL3kvSNFOpxdjf5wR5tKyheOhcidw9n+mkIdD8yBYiCwFfQqQ7m91yI/VHq5Yll7/KJ6SQ1HRSL923bKpi6IDJ9KeatywLI1TK/ZVoWxp2qFtHvANYmKdqNStPv2OLxab3HVQbVsXUF3qAPlOaGzeuShN9fiTVYF/1w=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c40489ae-727b-486a-de69-08de5a86ad15
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2026 13:52:41.0047
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L6wS0ucUPKfnYZIsZCz7X0J2EHFKvm1aPA67PrQIAwjtEKKx8FvCStYL/EvOEaksYsftuGRovzw8Tp/7M2aMMcEs/47FsH9YK7uvmipRx1o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6751
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-23_02,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 adultscore=0 phishscore=0 spamscore=0 malwarescore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2601230113
X-Authority-Analysis: v=2.4 cv=H4nWAuYi c=1 sm=1 tr=0 ts=69737d2d b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=U2_81TK9sUI5wM7LwqsA:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:13644
X-Proofpoint-GUID: jUP-_4rymMzLYLhuXZOBGwtr-_SKO4ys
X-Proofpoint-ORIG-GUID: jUP-_4rymMzLYLhuXZOBGwtr-_SKO4ys
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIzMDExMyBTYWx0ZWRfXyspwxtC/D8H/
 WOa3XIlnY0IrYjqMN2f+Jpy+GCMM9d0L/TXSX1qAjDyL1jt6k+tA2R6PyPZhQzTe4FgSDsFq9eZ
 MMy2Ph2Bi+lCsvVCUHJTf2dKNBjTYo6UA1Vc3Hi25hqc1Uv85suIVE6zdLwLBm4OEgISLSuPdWr
 RgvUd9DoaB7paWwqOKF4AuiPmP2ZsbRmsci/GfnXpzcRBKUXY1bqK0uvYLMEirPCCTjDAAPRMWt
 CSuIkPnK1Vlx5918Gseu3xDSRHsJu13cDvh6IQBxo8EDvVZC9muuda8/OFoQs6xiL8Ues1Jkm83
 mji9sZgZTAB2d9NA3h9+pnudqI7fl8FKbEEiOkfLLRBdVrGm9V3KNyIRjn0/hF+zPX7Q/oEvZtY
 1zbQ2xIXYMVEXIn+oNKYAuOvae52vqDgXxUkGRE7Ajy/fITaNdz7nbqu14ru7WUt56znMeEJIn2
 MJbO2sjWI3DTZJyCDZS5640OSVHMcxJxVMMKWubw=
X-Rspamd-Server: rspam11
X-Stat-Signature: ymhrdp6ronirmnqsn3zfahzqjbpbnqw7
X-Rspam-User: 
X-Rspamd-Queue-Id: 69A418000C
X-HE-Tag: 1769176377-496691
X-HE-Meta: U2FsdGVkX18oW0x/YIdf+x0YnD7DpvkAeNeTJgrTg+p9hxsMcPAEeV6zaPfzMg/Vuy+Zk+YEa1qVPLFIcyVif7EKgKXYZ+o1u+B+f8CLTczzUQ6cZTQqM7brvJmDcEdAiTrzq/nI2lBDcZLK7tnaj+uJkP5P1wEQbBS55C+wl+Jp4b3YDkXmvqPApuBghQZZm+aIUdZM0DMA7qiz45xQQAUme2dJNnlTlIIBdHGZBYlB5zkijyRmfqriuW1hb6zgQXtWboeDcY+YJGwKM1aJod+lMf0ol9m/KtVWH5PACAeSJpJM6uacr53DGjyLEjnqtZS5P8KOjlkJrbHSqBhxKUzHPermR81sORUQFOh2y2brXw7mVCG9clDbjIx9hH3b4KsFG7gvzdQUiqrVnjeJTco/jjoY2VHbB4Iouue84WV/ZC2uE70ievtTJy+NhuKcx13WH3q3006GC+CFKFy/7IELFbbhoJIe7nXIFWHHMSgCSokAt0x6nFO2bWAAPOxDtPkx0QVjwGGLpgfW3XR2BnwOpWv4c3UU2dG4+5Lu4w6iPoMz0sP/EbE0CIWyi/lPRp1bmRb5FnHwCE5y92lH8N4iVY/7H3+cVE5JLPz6rKGxtoB6mmf2amPEcPL6tluN0+3060e4XTOM45A91Uw84XuC9+t0tqvnQFPtHCYfE21erdslROSyTqXzRORzLykBgfwYPj//sUQEoHLK1ePOr5Os60l9Q2c9sifuk8BsLq3Y6QMfi3yBLGoef/9G8pccZ8xvMuxQVXHnPP7JlZsvjUl+fM3JMkeFP/5J/Uqa78xOLZ+UejDbWV0j76QdoKkY3Zfqhk5ZiM2pbkUuo3s1fE/8OxeNpfRetyzWCLZBsWPt1Aeyk/0SyBxRdErg7c6OsEWi73oFN3irc2wbhc7EDbOKMw+zk95fC6LB1tsB0DqcN5JocdKVbyuu7dmu/c0W4Szx4wuLiJsAdK0liZO
 bkCgHRk4
 XDyn124+Fp3MB2o44biScNxGQUlc3erBjbPdjxbsyHGUiNjW3zGl9My55gEeLgQxwIVv9P6rFilLZwZmQxbAEAWuigD6FPFcmlfIMggKyvVi/3Kbf61fMEYsySaEDQbA4xCZ4gzBoKGoHbWUGCkQBknl7IJPReMa8bSIOJtIY3vuNPdp3NmeZDZUnDV+G8j1UD8q9GGUK8q/v+I8zVdPTZGinQkjjp1xt/p7EtE5DdoGEE3Dypyoepzhg3fVFqngZTpC2ZBa7WDo6v8EAY2yRo4gzGAfcRJmflJolzgyp971UFVZoiQIeXO9bJc4+7zdhUaV59XX/LmitlDRQu3vKTBRDPJR3F2F5Q4s3xA6NQjX4RADheTtTlpP4y7JkdqnEzgcVGwj/yTJ5V0aBwQx/erjn1/bmDiliEoiwYG94Fi3b76RzGqPAWYpRIzbwuqntNq6sBXRkMOSxb3F3C+JrP671aVGKLLYXoGV7fb3L62gSyyjMamLC344AhR2MltGHUfuuIkQ2xeRB1a67HPj7yp2rfyeNSimBVRSqxscYzQIsoK9e5PtCTqM+nBjxyDmp6HO3TCnmxHUKrLh9iBjWa6a6hRyZBGkugkQZ6pBnP08pN0VvJbESIybexubRpx9df088ot24RoV/m5TpRgE8BBuv8tn0CAYGR/kPani3aVjKKrotPVhxFbI1+xTQDx+QbQUPke2fk/gtNz4P9K2CCoW9rrYb4EWVzNId/C+x41p8jFj8hIZ7I8SSti4b/nDZDTfosamqUO1MgtU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 22, 2026 at 04:29:35PM +0000, Lorenzo Stoakes wrote:
> On Thu, Jan 22, 2026 at 05:26:13PM +0100, Vlastimil Babka wrote:
> > On 1/22/26 14:01, Lorenzo Stoakes wrote:
> > > The VMA_LOCK_OFFSET value encodes a flag which vma->vm_refcnt is set to in
> > > order to indicate that a VMA is in the process of having VMA read-locks
> > > excluded in __vma_enter_locked() (that is, first checking if there are any
> > > VMA read locks held, and if there are, waiting on them to be released).
> > >
> > > This happens when a VMA write lock is being established, or a VMA is being
> > > marked detached and discovers that the VMA reference count is elevated due
> > > to read-locks temporarily elevating the reference count only to discover a
> > > VMA write lock is in place.
> > >
> > > The naming does not convey any of this, so rename VMA_LOCK_OFFSET to
> > > VM_REFCNT_EXCLUDE_READERS_FLAG (with a sensible new prefix to differentiate
> > > from the newly introduced VMA_*_BIT flags).
> > >
> > > Also rename VMA_REF_LIMIT to VM_REFCNT_LIMIT to make this consistent also.
> > >
> > > Update comments to reflect this.
> > >
> > > No functional change intended.
> > >
> > > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> >
> > Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
> >
> > git grep tells me VMA_LOCK_OFFSET is still used in
> > tools/testing/vma/vma_internal.h but I guess it doesn't break the tests?
> >
>
> No :) I update it later in the series but it doesn't break the tests so no
> bisection hazard.

Apologies I was mistaken, however there is no impact on the tests and the VMA
flags/mmap_prepare series I sent makes radical changes there so I will update
this at a later date I think to keep everything sane.

todo++; :)

Cheers, Lorenzo

