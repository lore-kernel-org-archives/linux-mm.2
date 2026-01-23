Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52F46D74EDC
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 15:08:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B44BE6B04F2; Fri, 23 Jan 2026 10:08:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B02916B04F4; Fri, 23 Jan 2026 10:08:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 952376B04F5; Fri, 23 Jan 2026 10:08:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7DEF46B04F2
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 10:08:36 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 28F008B5A4
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 15:08:36 +0000 (UTC)
X-FDA: 84363560232.29.75C91CD
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf03.hostedemail.com (Postfix) with ESMTP id ACF7E2001A
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 15:08:32 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=XewEoAnQ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=S4uNNioe;
	spf=pass (imf03.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769180912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cn8S6yKazsNB3ZsR1lwUkouMLh/dBNXpgKcpNkcpvgw=;
	b=JdqWpgLvm6HVqXbxLKQYDtT/E83gEqH8sPCuZlRfBAufE2lEjgWBkUEIG7Fpu5ecdS9tLk
	rK4KegblSNaurT+080XggaLe9Vi1yga3tF0nO7YSaHeH/pr2RPWTfpFJvA8cTCvAbTRfgW
	uJo2yp6Spn66SfRWu5VUATLF4T8C3PA=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=XewEoAnQ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=S4uNNioe;
	spf=pass (imf03.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769180912; a=rsa-sha256;
	cv=pass;
	b=Q/TU2NWwDDc1dpfsAfpd7h6nBz8QZgpwoGjHcGi0PC2ki0T1+JJ+Bx+4yNFIrpYDeQal3U
	2Rf91OgyMVlqaDE2gBS5YAyMSVUTpKhGHhwdtmC89MT8D/RMskU3MR5d9NYJ5ijm51gwF0
	cxqomv0OZJXQHzCpQAvWS2PiJ12bRC8=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60NDoveg1884098;
	Fri, 23 Jan 2026 15:08:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=cn8S6yKazsNB3ZsR1l
	wUkouMLh/dBNXpgKcpNkcpvgw=; b=XewEoAnQKLFEg7p4bN4N09F7Bqu6IDyKke
	nTkhhkCLqh6xuYp5vxtyne2iIHGZEqc4W7LYqLK/qmxLgYi0e8N4+cz0V86WIemX
	8+/Y7k9bxYq3lyGa7igK4zosGaqYDjtR95+nmnfHwINs6cVeORDtbt4EIN/63vrX
	NiUZQykp6NyvnDPrXqQc3vRm1sBFfyPiGElyI6jrmlGqXnc/pQny1jbSW63BK8lK
	l9rZ1vpDpiK6q8+BV1EVPYAEFL1wEoU7k1ZDJ5sbknE+60uQwUgCVUmX8vd0PsQ3
	+viDe1eaWqBV3IVFz8s3swGcJeM5LRqLAq6lUk83+8KU0kZlzGhw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br1b8jhab-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Jan 2026 15:08:18 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60NEhB05024906;
	Fri, 23 Jan 2026 15:08:17 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012045.outbound.protection.outlook.com [52.101.43.45])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bujd1hwnk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Jan 2026 15:08:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Uza6OFe7wGRgBQNex63UoKLexr8yZAdBaGbYy9IQkmzcMMLpt25QdvAae1MpR7boYgbJRI8FVqqbNbnQ0setKIw7FVoLPHGv6vQiYVePKFABVSdG6Iz0eMZJKrSNZCjyGPLdbnYAkexTztl5kElq2krbbG+cU/3Naltx1cXMN+Q3b27HR+uuThzTUJ8E+mgBV5Bq2KpK6L6o+6cZ03Cb+jqulGpM1cpYHxtXkOxhpLGyeQb6PpPb90n9MTIX6h7tcWY1uTkLT0Ywdgj1nBQw8dJ7qapIRqjUQOR0l4RDpT4aL4hOGpQs+r0TLFe9VV7B3UUZljdYGLhmAJkLD1YonA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cn8S6yKazsNB3ZsR1lwUkouMLh/dBNXpgKcpNkcpvgw=;
 b=FBoUwCEs8NkGxCoyDZPtT8McAjSK/SJIDZ48xhKqGzd7vuS+cv4fuZXQSr0ej6ceV/DMTFg6wpHE247/xtOLPDn04y2IkASqjUjgEB7FnlZTr/eTv9QPRux7LUXfh122Ll3nqAbkAk6nV/THf5n7vQWXnBMcI6FKAn+OgzX5e4kJgA9gRhf7YuGrfZddVmoLakeDQ1qwHp9ea1abma+yxAp/pD0P0Dqgn4FOJZMR+Hipg9+iX1UhcWe8Q86TdIOa3q8sLzquSF+G3cjKyPrikYj1ToPnTHACfAE0/O+C5U0G1t1s0IHooT2XD8ezRbOU+CbpV+48ONeCobYPX9oiWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cn8S6yKazsNB3ZsR1lwUkouMLh/dBNXpgKcpNkcpvgw=;
 b=S4uNNioejvn/S6C6KRzW4UmaMaIPhoAKq56cJrC76QivkhAO+FdbNPcaJGT1JUTNpKDBJ4+FvYYkUJaUAcpesK7YGic8061fZtM06wrQQB5bRijPHeV0lM+FaMfy3fh0jCGJLQP+zVUxc596UMgFERJ4g9zmkWO5sIQ7yJDd98g=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by PH8PR10MB6672.namprd10.prod.outlook.com (2603:10b6:510:216::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Fri, 23 Jan
 2026 15:08:12 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Fri, 23 Jan 2026
 15:08:12 +0000
Date: Fri, 23 Jan 2026 15:08:15 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Suren Baghdasaryan <surenb@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
        Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-rt-devel@lists.linux.dev, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>, Waiman Long <longman@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <clrkwllms@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH RESEND v3 04/10] mm/vma: add+use vma lockdep
 acquire/release defines
Message-ID: <471fd771-7809-4f18-b9a3-8caca8f63b9d@lucifer.local>
References: <cover.1769086312.git.lorenzo.stoakes@oracle.com>
 <4703b7320796908b9a0827c3d42d74d11b703714.1769086312.git.lorenzo.stoakes@oracle.com>
 <CAJuCfpG+H=gRSWuhLL=NHQAQzrbF8Jku2qgRHv1moLPRibk5TA@mail.gmail.com>
 <CAJuCfpFVqmHnUVxZZLgeCv7QdPUH3Bv5tM=uOzPWuQgnx2zFvw@mail.gmail.com>
 <4b0b5a72-d4a0-4e40-8632-d2f9268e9e09@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4b0b5a72-d4a0-4e40-8632-d2f9268e9e09@suse.cz>
X-ClientProxiedBy: LNXP123CA0012.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:d2::24) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|PH8PR10MB6672:EE_
X-MS-Office365-Filtering-Correlation-Id: 14da41ba-3b89-4603-622d-08de5a9139cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?XQuMCKGYlIlEAQuRipTJJ8T0sRVXcupDyhQMBvXyAfH9/ZUBQoBhsY4JSHns?=
 =?us-ascii?Q?8Bw2Dg9M3CjO9ZZCXh7zteaKC2tIOUfFVGVLNXNLVF4GfrQV334RrG2XzWis?=
 =?us-ascii?Q?89omRNNjo8EtR6rGL0SbZlOOLRV1yGhWhHyOMUUtyJdJz/5cJ55fWapdbqjQ?=
 =?us-ascii?Q?4LEZkfUGos+Ry7TgT1jUUuZPNU/i2oeMVr8sw7pcdI6tzy9JJEO/SpSXXG1w?=
 =?us-ascii?Q?1/RnYFWLW844nZJhwChNhr1OeL+kqjDec7gGy3k/cyEm8QIf1Z7wju8UIrrn?=
 =?us-ascii?Q?b87J0Pc0xPCMmQ2zmoqHcD+1slaJe/7iMnnH/tFwk800tKFjZS4ZZiUNgVhD?=
 =?us-ascii?Q?M3PzqXlSE5KeDngti3x4FibMEKAXx1+/99EL3doEwaqrxuke30K7/ZwFaqDL?=
 =?us-ascii?Q?bqiZTppqWpD1tq3brx/IYoGBk4LsQGQruW85E9CXXB9Q/P4YCV6Gc9nN/Ozc?=
 =?us-ascii?Q?gPBGORagTrSHjdp8vBh6163j8XtZ0LSTDw6ozEwSoXu1u5elh6fLIUh4H0J6?=
 =?us-ascii?Q?d/CIVAQAUIFVLy5uzYylwFX62QhxSAh7v4MkJ6Cmo+BEBIoTXTy69fgX7bCj?=
 =?us-ascii?Q?yNNTPVJ1KU2A6d4CnWizekTrAlxe5TXRt8xh5EKNrl4uvA7jLl87q89JrtZl?=
 =?us-ascii?Q?ph05xGu/V8OASqYvgH8dIZzv1ZUdP8tUE4rcY+w5HbRRl9ms8Da6IPE0N4Ct?=
 =?us-ascii?Q?NCUNHC5iRoAZUO4hmTf/7knT/3x9+vr6NZMKuLCGHfm2W4HaZfl6AZ2NMq5B?=
 =?us-ascii?Q?UWUAspmwRxkJQXbZsyxcPmvRtaAy8W8iDVwky1+6l15olxw1hoRswm/xOMH9?=
 =?us-ascii?Q?ZmhjQsZKc2n3rWp8zOc5Zpd8jHJMkbi7Uq6E0ha58oMn1TiS8SKj2ru+rgLd?=
 =?us-ascii?Q?tUva+Lh/aAZEhFi0e281IaU6j+PynvFsHNrUbCTXm2zkHvW3YkbB7/02MlL2?=
 =?us-ascii?Q?SziKmLNukV39rxp/ywpeyIJ1hGjCIDfpFyxHZK5oqYbG7Bff53AxYROGj7kL?=
 =?us-ascii?Q?UgcDLMtERImBvQIHeKMBAutmlV1yv9iJ2y87C6B5H+XIUxCZQJnB4oh56Fon?=
 =?us-ascii?Q?Ie2B8A+kdoCW+jDsUYSeQ73+9ghZaNe7cWf6/OPsqK8tnCwadLmfqearz4dR?=
 =?us-ascii?Q?Pd/b39d9VsbpBPvTgIy6EL8ysquqXJ8KcMpwyKl5CH8QOCqd5iSnO+Yw43s3?=
 =?us-ascii?Q?Wz65ueUzUbzehkc9IE+gQ047d614ivQs72coCi2C1igPOe6EBFWUlmAoAfD5?=
 =?us-ascii?Q?Yshdw7XJyzOJRjpV0El+WLlalhaSfpqvHhWQTn41WPxN9czNjpNlpR7Tk5CP?=
 =?us-ascii?Q?elCK1ZpNTkzYwbCfme6SrkqceIUEsA/3iVbu0Lm7srFVhHbd6kotE7nZqxfY?=
 =?us-ascii?Q?ey85hc95mqlS2Oim3VzEI7QqYlpnyoPPnDkKYZekuqll8mVlfFUtUL1G5qxB?=
 =?us-ascii?Q?aUgjH+C3Mkdz0e+X48uxgdmNyh2gqYreiZVIfDjVq9PHMiP3+FggrqhNSQnJ?=
 =?us-ascii?Q?illb4I5azFYO5FAsdqoCDb7KRBmDbGfCsXX0yB4Ahm95bRRyyCHk/sFnlrKg?=
 =?us-ascii?Q?zFckbjKlHV9/0QgKXc0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CbLiCQULb6lWao2pQWJExlYSTysSCr8stIrVAPGHMk/DbTfjV95HwtziN3y+?=
 =?us-ascii?Q?ZwhsDTJ+vJ41qwhV8YzTNRX3NLqQsAyJlJ9lmJp/ceSBpTrBlKoi6X1+Gjw8?=
 =?us-ascii?Q?+FjEY7sKDf2ZQlj6rqiotVD3fmblsrmCh9FOaYLdA2NCjRb2EZ2ZUTWn3bN3?=
 =?us-ascii?Q?nLfxkS+80PKK8U8D/eaRtfQnbjRbb79rKkHJWGZO5wJ++CY/os3eIjw4rYQT?=
 =?us-ascii?Q?PDmgEchqe86tRTtyiAxZB8KnYxKYLd0rf6ojyqXUuWxnP6hNzAECVO6/WhfP?=
 =?us-ascii?Q?ep9pYgwai9K4LAlD+BRM0n3MDMx7VBKHdCgXZ9gSGjkFTsnbu7FG+OjI6Ibk?=
 =?us-ascii?Q?sZFdxt8ipXa/mP590WWPibIRmDZvy5q3eQPrHIQ6IwAuqkSftxGKhauQrTzs?=
 =?us-ascii?Q?t19xaFTU06/qXKtHiO4SZQyRZhzCaIqYaGAe44vvX0gWdX6e7DrlrkqG01BH?=
 =?us-ascii?Q?LwdSvCtXEOz380vZG/gB1RxwYRnHoGqdkcoPXPMsFiHn9GkO0v6t7ptFH4dL?=
 =?us-ascii?Q?STVKMnvWwsFbHloVGJXgjOJfXZnLZKYxlphjN64Q3DSA+urWZFXU/fBxtxlM?=
 =?us-ascii?Q?nsmydCsy0EDQaPxX72WqFaM64ZEOvq4zJPkKEEsiOjb96T+vNtceAeD6jsw3?=
 =?us-ascii?Q?+0xvCGqDjtKz/C+F2gpf37fXpXUI7gNscpJ69cBQR+Fgl3KrrG1Ayo+4poh8?=
 =?us-ascii?Q?JwUK3r2I01Ff8bV+JPyJBqRt+Q1R+riarXABgWpAVbz4iipsA+mINMegNMLo?=
 =?us-ascii?Q?LQBUdQo3AWJVFDiO498n7nISnWddXysXkGDVsGri9isW6071gN5IBLl4rE5W?=
 =?us-ascii?Q?GlknXxjJqe5oab/VpQddjwlWV8ChrEWpmePMhQZ4eGIDZEER2w61lxqkuwuw?=
 =?us-ascii?Q?+j0sTRQIbuuZwX4XkiVTpRuwK9Fc5D8vuvAI55zAwL21J7aOk2aH5IDXS7ny?=
 =?us-ascii?Q?zYtsKkmUbAPn8672Zz+jLs3rEa5rPRQQJUkPqvQAj+ffFTc4VZtDIpuiwsbY?=
 =?us-ascii?Q?D5HrgRfZCPuE5C0XBYoTxbv9VRIq2nlVhqsx1BreoQdnrVawbfMSGn3ClxsJ?=
 =?us-ascii?Q?GU6cG1DUkRvXVUq28Q9GXfCNcvcguag7cdCbXxfPRhS663W+Njn8z268horS?=
 =?us-ascii?Q?CGcrb0NXVo15qVdc4BXj4ZEyJTH5mCBiAt7QeHiiOBcZmzoVi8nPyHX4GVEi?=
 =?us-ascii?Q?G7Z40U0+WD+mVODUFsCro3DbrMbMF07YJ7bzpSJanCP/F5RVZZ0TbGxwEbDE?=
 =?us-ascii?Q?pp3PXX06wOWwlIpAc2THQu8BsJBsnuXiYFE+3g0OA1YTqCLBiKKEMYE1GlYT?=
 =?us-ascii?Q?4GVD0r+RHVIs5Sg63tMCvV3yGi9C/yO6DOcELCJ0Tlopj3p0xSBrQqXypsxc?=
 =?us-ascii?Q?T3qWiA9pTtlj5sRaV3A7NnFZknLksNzxnyl9cNsKr0seUXidfUrFEIJ8StVl?=
 =?us-ascii?Q?oyxQsKvs6SvnPj9V9g74HEBdMiyc4AmEcis8vQXG3+zNuKICaw8yRazmZ/JX?=
 =?us-ascii?Q?4BPKzlAunrkOFK17mTJVw5CbUgcYb7a7hp4PrwRT8mWguKhQv/PjqQhrNwbw?=
 =?us-ascii?Q?EyexBa2u11yZmGTa35uCV2QTvjfGg2WqMYC2HvuxWufHSk48+Z5dnyDboTDI?=
 =?us-ascii?Q?d7M+wpt0QXOYbKQB5g/1pVuTDAtpOfN9a+t262ejf+KHmQj79CJEl8BY61B1?=
 =?us-ascii?Q?Wr0X9Jj8G16RVCsdiTil0em3OrI6f17nlUsgGtlJH5NUIUDsn3Atj9pjnJ0C?=
 =?us-ascii?Q?82UXTQJLKuNs5k+nC4hTkOUuFwb4uVM=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	7821fExe335jui18VicxnJlOY5k4U0AoPPsTxEOagjmmWiQhc26bR4RqcTWfuJUfR/QediYS/crtywBT8taXkXOpIR2ZIlH5jUQ3OzCWBfAaM5WKucX6BDpvRZiEbTbnaFcRHvctOps4M9sGw++djKnaiGbbHErFOQ1TyO5+zZ1nWdr4MfI7JICdsmC6cSP9wK2p2ph17+KnXWwes45RZkOL9k5tY2oVwc8kK7f4VpkbABQ36FQmqqMClJpPRxrcxY6NfRa1KHAV2Xa/74jMWbruBvGMY6JE6JhxSFMXyQmlN430UBUBSdfHMYPzaGhtxYmahVQhjRMJMj8g1QxeAs/5RzkEGmcUU9be7tpIVYArUau5MIhQDYdvoNsQi8wIfBYX7jr9QgFipLv67p3R2x8uE7nUE8DbbG4oLOzuRau7fdnpl1eHQkO8o7/t2snCVQQVJS/28X8J08LCI3WXqaoEGwMqgpIf55j0NWGbpcWIV7lXaQaYt4PKv0zgcF/+VD8U/WmtFOhJIbXHRAjoWE4bfWcyNOLOmiYe0cmJYSPWcwaDJ/nTxoV1tDWcsader028Sf52jk0lsfryLBHdghlSmPu0kmiVz/Cy1JsxUNI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14da41ba-3b89-4603-622d-08de5a9139cf
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2026 15:08:12.0557
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aQ5vXZRXtUfDIA+QBgvKkt3WJWiCyMMcK6/Dw6JKOMD0xYc4syBTy8xAKsklrNREA7xFgMALZFi8awH1AhnTkc7tF0ea1jEmzx7WYkdykuk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6672
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-23_02,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 suspectscore=0
 malwarescore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601230118
X-Authority-Analysis: v=2.4 cv=WbcBqkhX c=1 sm=1 tr=0 ts=69738ee2 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yiRAZWEDLRSJIkgqWuYA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12104
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIzMDExOCBTYWx0ZWRfX7osoYPXukDJh
 wIIYTlGaM1qGtKNfKOKcv7F9IXNbQM7bzYGuU5YzhMvEZS2R/T56r3QTl6TCIfFZU71ooszaZG5
 qEwXYjqXLZCVsVlRgmyCeF1HPNRTi+RnDVzWaWKNO8qfdYD8rmiU6OdIcjKwKwT7gwv7pEq3UBH
 aIgfHwQPbJTxI9GH5VUwPkChmoU12f2Qa3tJgsNkVMNjaB20A2CvdrFU9tsZwl4Z40Ku/yx6dm0
 87HzA0hnhVz9qQ9YuPQPJiDqjO+Intk3eJ0yRrRT6giid64IwhRopW9qJsW0uwiIS5gAmMMSzMn
 j0rjXI/qjFfQdJSF2XoBQb0pgC1r5hi5AI8IGsVXThVKAGDeTZwtjC9JfX3ZxIJFvmslY1UYHgd
 E1dKvU12wbgNiPSnfs2gTX5KEHX9lQlz4AkxcB4IzI2lHD/jzcQ2OFdjzF5P7ivTGKUCoOT74zU
 hEx6rUeRHc9Hd9F792UuZ8FOmTihNnLx5pKBqbDw=
X-Proofpoint-ORIG-GUID: CK9N9mN-XomCfqrObXns2b1glWp64IUL
X-Proofpoint-GUID: CK9N9mN-XomCfqrObXns2b1glWp64IUL
X-Rspamd-Server: rspam12
X-Stat-Signature: 9a3dtk56njd3q89fnb3hnyt1nk486z69
X-Rspamd-Queue-Id: ACF7E2001A
X-Rspam-User: 
X-HE-Tag: 1769180912-802247
X-HE-Meta: U2FsdGVkX1+8sY94IROXiLhA/4Mb8ZTBs+cc6wRjD5aHg0uTQHm4lT67HxQPLKNvWppqPwz4TsmLG8F4ANQYqRMqKNu6uf+QLXNDHmAxQrwefkWIWanfTP16m2tp7ziO7XAJEM+x1AyqXTxso6Afzk7u42MEveXdgdOcvk3jOaK6HeZEew/yAHMsgck8U/OVftlfSAtVoSPNvcEgGYFL5ndr9owsQeiN6Jdt49Vo3Ob6VMBYbpF0EUKQtg06ZtIUB5YySHH8zf8LC6IFoc2XDEJuI2dDwE9tKt9fsmMoF350KxGr2oL37gsnFqPDH6ZlWqdilKaHSZTtIuay5i+pTvjrpec/fyiH97N8LQLvuFaQyFWtnM6jtCWhNVSAThsc3x1m1fVKTImbnMEgk/oSjvioG8Mosv4LN/AtqLkmpwJ8YBFeKdV1EHfeyxFzuiGxcrD3B44t3yaKDW+22DdNRsODhNLiozKQkQbU9MkFjVIx9lvTsFFJeBjXt+ldBf3yRyJNxWevF0RhTI06Toyex7IBiIKEVWQ+vt3aBNIn/plb88y9BUlyfKn0+htYBL3vpcMS6BkObZmKaxmm3YNeKUPL2f5tAFwSBolYKRkK+sgx3Hjef4OwOSkbMDqi7kURKwFHq1X2Tm68KsMSXNCiTogyS40Dkf9YkIIIwj3ay5Gcd8tPx19qWMnzK7zFjR+pi8vHrPvB0q/9eWRQNmC0SgCm0PDdq/wshD/dBhWAsd0lVFlxdgE34x2PT71HezT9MEUGnlolDtE5WF5sJ3JvY/M6njXTfOCG+5NeFizviA3X8PQdgQZisbECPFKplS4T5f/eH8lYqkKdVD3GtedsyYjFJy1WYr9LP/rygEJUgvVlYOOXtiwGtSF3Dd5dPfMf2xY1AZcLhlZjiucP9QzPzU0wrGGcvUh5axe67asXSJLz5RZ8SIE2dRVRkR1i25Z5YenSn3EvHBICJoc6C39
 e4N4EMI3
 kjmBfyCfnKqYHcqyo4duLZquhpDtHKp/VMrwyVgvnd+bWH5FTT3ZqqbUA+KXn4370A0YK5OY1XAQt4wDx87Rwsyjt04CjC3hS2b2GxC3Ja9cgJIiC5H35CagEoOf6/6jZP+15WIchL5mMq2NDQZkos4aKtttYwqfQIIZAqYRF1k3meDLB7W8EXL+xpAAwjeum6kf/xu6zyCAHDmOPLagnHB7/sGaSV3oHKCJ3OQOS24VvNEx7akFhjBZ3uTQB1v8T6n45puWBi4s3+4abZGlT30d4ZQUTKRY1xiEJgQ5hg1D29ZBUQw+z2aJ7vqPCJUjSV80NBK1FrR92xIDaZnR1glKfIwCLm1ZZfXNCUgDAZ5zkl5BmYn060+MAhv2VaVT89nTMzciLdVfMkGoggVxAhGP7N6yoKX+3TLmfdDOx7oDuH1yGBX1wFf3TDFhF2ub+uGP9AUtyeGrGD1liHdXp47Y5Xv/JBEUqX/GVbJbi+3xeGwX3sk/XSkXFsfYzj2WniGAeDENCPaXics+aKHZDy2JGXXMpQBkmqBNDn4iH/SMipl3i0lWYOIlhPjrdn0+Mcai+8HmHNjrcHzLoIowCbh2TfC7CnEr4sm1PrvWwcmaD7K+YdCLOujm59tTnU3Sd0uKYo2F5hCpTPHYuZqaBIJ3NT1A8QP2Z4vFsts7lQuZT6tpVrkFfMKtryVcbDBWyAiNR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 23, 2026 at 09:41:24AM +0100, Vlastimil Babka wrote:
> On 1/22/26 20:41, Suren Baghdasaryan wrote:
> >> > +/*
> >> > + * VMA locks do not behave like most ordinary locks found in the kernel, so we
> >> > + * cannot quite have full lockdep tracking in the way we would ideally prefer.
> >> > + *
> >> > + * Read locks act as shared locks which exclude an exclusive lock being
> >> > + * taken. We therefore mark these accordingly on read lock acquire/release.
> >> > + *
> >> > + * Write locks are acquired exclusively per-VMA, but released in a shared
> >> > + * fashion, that is upon vma_end_write_all(), we update the mmap's seqcount such
> >> > + * that write lock is de-acquired.
> >> > + *
> >> > + * We therefore cannot track write locks per-VMA, nor do we try. Mitigating this
> >> > + * is the fact that, of course, we do lockdep-track the mmap lock rwsem.
> >> > + *
> >> > + * We do, however, want to indicate that during either acquisition of a VMA
> >> > + * write lock or detachment of a VMA that we require the lock held be exclusive,
> >> > + * so we utilise lockdep to do so.
> >> > + */
> >> > +#define __vma_lockdep_acquire_read(vma) \
> >
> > One question I forgot to ask. Are you adding "__" prefix to indicate
> > no other users should be using them or for some other reason?
>
> I'd say it's the case of 'it has to be in a "public" header but not expected
> to be used directly" by the end-users of the header'.

Yup, this is why I did that.

