Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7C92D3EE60
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 13:02:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4281D6B0199; Thu, 22 Jan 2026 08:02:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FFF36B019A; Thu, 22 Jan 2026 08:02:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B7616B019B; Thu, 22 Jan 2026 08:02:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 177CC6B0199
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 08:02:31 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9E9631AF0D5
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 13:02:30 +0000 (UTC)
X-FDA: 84359613660.23.2426AE1
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2C2F78000A
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 13:02:26 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=UfU6ZJhD;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=FYLodfA3;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769086947; a=rsa-sha256;
	cv=pass;
	b=j05AwHrQqAZGhNho6muQdSq4xxbWmQt35EGcTYFU9s4i6dcnWAON6AVbF2Dres1+3UlWb0
	WXezb2OCktVTp8vl1wR6heJ83/AycOZ/eR655rptiHSLEdvvwtw8aIiqBToXVMlBq0mAET
	7lYtRA0Stc4L4I/KQgbfPyP4MuqVLs8=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=UfU6ZJhD;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=FYLodfA3;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769086947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yy0BJd+j2CMRhYrJIQz2+9BlqjIfVO6MZl1p7+ODLG0=;
	b=y11Vbkj0dSqLPIjqQDX85scQRW8tqj644ia6I4i2iPg/MVk3FmV1zzNwLPdRlzkzQG+H4L
	b7z55xCkbrDeIUG3qCyb+CKmI6ZpDwpDr/8ZbDjXUbkjRV+Le8JOx8+xWZeXU9QEs3u/Wq
	o5JA+dbuJlT0TtxF814HqM4fTl1cT1M=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60MBFZUa3523773;
	Thu, 22 Jan 2026 13:02:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=yy0BJd+j2CMRhYrJIQz2+9BlqjIfVO6MZl1p7+ODLG0=; b=
	UfU6ZJhDtO8LNQ+kbU14koK/FDjMoCgDNjEP+puFhUUBZfISjBxml/iTPI0egU3L
	KRGA5Y6OyJarWvI6QKl2y8QdVl6J0+pZNpsPMfT7DU9mQvDTRK266WWZOv2WsVMV
	TuUnG+nCa/xZNuXCAjB8nCnpSGh8sNPOK+w2p0mixZIRvwjw4Iu71Vbu/roluCdj
	Vtj331ITfQ9omQGnVZiSzLtWIJLYGSnIz4D+kfTIXil5zL+4qteaFNy5c50NvCS7
	uFhYJZimHvbFH0KztCyf/Z9vCWPCOcoZw7SF/vb78lt3WkN5BK6c5SQIcWWAESzN
	VmUaCb9zeWH6mZhdKKYYGQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br21qfucd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Jan 2026 13:02:14 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60MC3PN9032149;
	Thu, 22 Jan 2026 13:02:13 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013023.outbound.protection.outlook.com [40.107.201.23])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vgkfyc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Jan 2026 13:02:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EycyoFdgBB27zqm6rrltuvtVqcVQVa8nsa7HowcOLgqL+8H0M50WLIvg6LKfEpeuR4MvwmSiiV32ZLKJ94s6GQmpILloigHkYLCAXhMqRZxm+I+GZKJUHBcZ8bXrHWAg6KQJ0gajH12G7jDm5TL0Xxju9tRDePyB9izZFjAq2XdATOvKkbVcarT93TIybYBMWaj8d2ZU/bziR48FJEwG1W6BWjoOll1BsVVrE3/D1pGX08TK78YQ+fDTQ4ppTr1HOZHvbswwd0AQok64b8C9rzha0dX8NmkLN9v1x8pL6EOs9m/nZCErgyQ1UtnDCQBhv1xN1S5uDji/D8jHAQf+Eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yy0BJd+j2CMRhYrJIQz2+9BlqjIfVO6MZl1p7+ODLG0=;
 b=dTQPIDsMj51ddtDV1nB4kL7eM9q+WZFrGCs7Szy9Pu2dld61ldfvvnJ4bP3EmQ0XQDeawrDMXTgg9PZp2CFkekPisg++Tg8Jmc27FE/lqFF2QWSE55D5VTFabI/htb4VJt9p6DZhz06ULoixjzlTQBA6ngKd0c/0LSJxudeUYuI5k4aTaNhz9e5+cRsYqmAlLwxOgl262Boo3iDhMfJetlHic4voutrWaCb9erIBlPSc8ojJKzEH+DrKWIZax5wLPuGUfDqpV5gmDI5T+5sDqpqT12kwz8OwcVc3KYJeTwkSIOAo7pJFTtIeIoleh/YlDPxIdUHGb7KmuMAi9/P6uQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yy0BJd+j2CMRhYrJIQz2+9BlqjIfVO6MZl1p7+ODLG0=;
 b=FYLodfA3ZBN3kS56ebkNh9h4hpdFr2L8FXmYsPmqyl6OH9C5VWc+Cpg9cgKz2rFvBVf5ZmqUu+GulXdMjo6QoV3/es/JMlVPhXwm4nejANtia+58KDUz+4d0RtRGk8eX9hDMR6GdLO7CwxoNuGYxoHPXavTB5yjehNA9aD8Z9lA=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by DS0PR10MB8198.namprd10.prod.outlook.com (2603:10b6:8:1f4::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Thu, 22 Jan
 2026 13:02:08 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Thu, 22 Jan 2026
 13:02:08 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-rt-devel@lists.linux.dev, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>, Waiman Long <longman@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <clrkwllms@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH RESEND v3 03/10] mm/vma: rename is_vma_write_only(), separate out shared refcount put
Date: Thu, 22 Jan 2026 13:01:55 +0000
Message-ID: <c51d6396d78532d85a542da07ba783bc838b852f.1769086312.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1769086312.git.lorenzo.stoakes@oracle.com>
References: <cover.1769086312.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P302CA0001.GBRP302.PROD.OUTLOOK.COM
 (2603:10a6:600:2c2::6) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|DS0PR10MB8198:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e41ec6b-fb21-4972-5b51-08de59b672dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?lxR2ZBwkD886pQJzLBLCa7zuggEMabd5wKpw6C/vccvIH0CLSTcHIpaQQV5i?=
 =?us-ascii?Q?zf2iNl40fg5yZh+gDApssfYzt/KVbhpDITXfnBVKl0BdoGsHebZhFO4kOate?=
 =?us-ascii?Q?yFd4caX55EYgsM5KRN/06aMvT3bi3NzSQAj5JvacGLU9ODffHEcVDMF5BdpT?=
 =?us-ascii?Q?OrvDT53guhy5oCpyFSWUcjk1Zxya13VFD/UBa2C0s5uFxr7whHJQR9lvq5OI?=
 =?us-ascii?Q?tVwqbO+lpNvdISb6r1K5iuNUvQpf/QuF2EpAi3r8m8zE9AYk2kaksuOOqEWl?=
 =?us-ascii?Q?6jcBYHk/W6WE6XGYd2atQGskXORKgg4vbA5JBUQvTkrAy8pJDXMy2MASSQi8?=
 =?us-ascii?Q?TMBDJrkWJfNqjdqX6De8rypC+5ac7yn3d1vTVKU856ADELUphgmPSJCLQEtD?=
 =?us-ascii?Q?UaF3ONKjVQV4OomAfi/CBYYKC6jiDvW+tAgFaYAppzDM9qxENZ5F3B4KmGGu?=
 =?us-ascii?Q?p0ucV/bHL7ezq4/BmEtt31m26nIg0grt7SCwXpfLN0RN32v5EtkBr9Bd2dQD?=
 =?us-ascii?Q?q8p3s5F4qVRM51YnzkXlnBywvsfX0O4L2DwuSIKYsKTesPWti9+sRBUEtnpC?=
 =?us-ascii?Q?RpHrBQ93TkBYfwKDy3SwIDSukiswjL8kQIWljEoGDc6GhV/Nnxe4JDHIbG1m?=
 =?us-ascii?Q?FQiPjXkrpImG0UuUoOCdF3wXZ1o2JgZlvfVVFJPWuLy3C9W+wTxPuf3OOgmi?=
 =?us-ascii?Q?pvy5AuszLY2ZLBwLfiMzV/qM947qdn0QdOY8N4JsEH3E6qBqDEj1deyE1Ywq?=
 =?us-ascii?Q?ZCDA0VCCrkEsnHNajqBROHl+tJHtOQPt423g/X0CGk7dxOzjNqJUOWc7Ecfy?=
 =?us-ascii?Q?IGxMz4BjcniDEaK8xHDZV+SxaS+3hkTs1R/OY+DWkP3QpuVXdJyu8mSCzmeY?=
 =?us-ascii?Q?MktokPxitnzP+aLGYGnC35p48LYADXqqhSoRDBP7gkD34gkELZkskqe89H3b?=
 =?us-ascii?Q?qpi4jCPWEj29F+qMTOHywGQhPN1S9Lkp12s1XunHcC8QcGvgNx3q9AwGv8K+?=
 =?us-ascii?Q?TOg1eA92guO5Jb8guzcx1P85Y03mYQu6wyVWRWtBsHpkd9AV2hUljsvz/I3F?=
 =?us-ascii?Q?QUcvp4cWKgntN2OV+GZuV8ijKR0mJb65ieuVcYQRFoBY8m13i16he4EvzDx3?=
 =?us-ascii?Q?b4H71/mpBHQ2gLTo/NAeT74XP3RuLWaEaoMRy3xnPWaIiBEs8faNPKULoXWu?=
 =?us-ascii?Q?KpZqMR+yn3d6hTaoj/jS/koJLpRD7wdlor/M892i493ieKJNYqJld4iQeINa?=
 =?us-ascii?Q?OAMHarjU68BfV/hXfH5HAGOTjcu5TP107C5Arz9m/c6Razr26RDZyX6Jg1iA?=
 =?us-ascii?Q?5C8BHMigRWnfh5PdXZNqyA0KoE+Lq8asd00psiZzzwROJxKUt+vULl+vD9qG?=
 =?us-ascii?Q?a+cbI1jDdwpZBSKKQBq6NUiATpnfEStqqDMPw9JgbpQH1QVUOCJ4XKpNRWK+?=
 =?us-ascii?Q?dooJ16iCb2tYgvuFgwDfQZugNbbytFFgtPa0EaN8w0/nFH9m/4OY5BEz9RVa?=
 =?us-ascii?Q?3hOzFtnwbESUDmSu0+hOehVNssJCMAsz+NaVwq1loJ4spjTWhxJylpPdtCwD?=
 =?us-ascii?Q?uGNukTtnPEXcRwoBAEc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?aNrN36spr4Y+WJnQlR59584icuvaqBVfsWFkWffQ+JXeGku01OJMzIIi3/lF?=
 =?us-ascii?Q?i2LOvSRz7sC6KtxeJVMdC/qth18AXd6MM7LxuBfM2d239u8TnZJFb6sWai/V?=
 =?us-ascii?Q?WNZ66wetuWDh/tXeeCTJKsXQLVWwwbgOouzxXhrGXYvxUa9Lb79CygmgtR8h?=
 =?us-ascii?Q?AjVVvopvb4GWryNWZcv2zT1DTgxLcw4fQRYwtV6J4DcZ73+TkAE/0Vr8fldU?=
 =?us-ascii?Q?AMgZJw2IGyZchWSzYpjTXdqmXNfSPNTt/8Wpx1bx4d3hPy1jKbIqznzo7awW?=
 =?us-ascii?Q?RJKb4X1OdxRNd49l1QSvexFXXeJUDh8Peth6O6MGQsNzgkRtecjFoNH7oMIt?=
 =?us-ascii?Q?KevRsIsaBI9ZnrSQzIv5nU/GuGO7I9kEFXrD1boMl/qtPRjOJpJnsH0yGbN3?=
 =?us-ascii?Q?qvbYVKZG5nYffVDydohXKDLF6cLjypogTIQXeDisAxzH1w7RQfB8jQMInWQe?=
 =?us-ascii?Q?kHZ2aYbRvR5oBdkzsbGWjI7xXF/88iK/XDOPjNlw+fL8yN6rnVuaSNmcK+l6?=
 =?us-ascii?Q?MOtWguMbvlF0xbw+z/Jo+9YQdN7Z1VpStExl2T4rMfuZcZXnpeIR6lIU5lvk?=
 =?us-ascii?Q?bsBj2aB78orlGOfWs3Uz7eGcAl7Cg62UKnvdKcLQ3R8u3wA5TehVx2rYU4qm?=
 =?us-ascii?Q?ZzuLVKCLT3GHj6V8x8O7bsXYLBifkLRi4QB8rX1GNjm8XWCoQGlGm6LRIKRw?=
 =?us-ascii?Q?wCpVdQp2EMRSWKipjq3wY3wcLsTBxmTMfyFgh3VuwVYOSjFQ86KnXGGFj1yZ?=
 =?us-ascii?Q?sPa1cVZe+goIJcYteCh+/vx4yyBlIZYK9y7PSYbYLps7Z1uMhoI9Du+JYjVK?=
 =?us-ascii?Q?zLKJnDqmbst6SYFmqIcPON8at5lZD2s0Re42KDgINsxAe9wN8aJIiLYL8kkA?=
 =?us-ascii?Q?pCY2bpXlBFUKI0GzDG0/HvXmULD0QPpjW28S7n7gQHgxlgMcblRH7ZZvkm6t?=
 =?us-ascii?Q?fJJf4aW4oplhtFTrvDCHBQ7HbPeyoMChsJy/bJUne9T6D238+2onnf2JtNAH?=
 =?us-ascii?Q?VmKXDBp56yI+dsVi+/L99Xknk7/Qv3MJfNo5qbJBVbO70xovpGrb1RiNzoFs?=
 =?us-ascii?Q?pu8byzXmE1qRzj762r+xyyYhl+zTpNq/W11DHOoIG008xARSQ11XC3psyNKV?=
 =?us-ascii?Q?y3AxEtYs/zWX77yMTQv2azGvrIXWU6wHrTfRoCNYl1QjuNQ8QgPrqjngkaBX?=
 =?us-ascii?Q?DNeLw94vRkq84v6sZtJCETiD6xQavvtSOkn29AyAI/39jT5JlJqJWWnE+k0T?=
 =?us-ascii?Q?dzZKZBGHuSXsaLJ6guApijy1AC2/Ma8ZwaDo2z1FoQeEjn9414Ky3eYxf3yL?=
 =?us-ascii?Q?1Sl/fMgEKjYXZzbRNLZtX9UfjfApzV2bhJBAGqviyKseQnd2WLPkbA9tX+al?=
 =?us-ascii?Q?9LHcTtsUZLm0+mXmcZDG2BrxPyKRtQZO1AeZOhfiGNk2KkByPGuvvSCD6kyk?=
 =?us-ascii?Q?f31EfTztVPCgvVyQY+mEBWMK9924lL/o31Mu2qweC78iTV8SqfIK1EdsRUul?=
 =?us-ascii?Q?qDTaWifntICFQ6BNN/swdgmz6TmhTdJmLgMGSToQcmzmJGM+Y9ldjRo8t2gU?=
 =?us-ascii?Q?w7ohM9K4jbXJNFCbTgrSKg08WwUeDAczrxkGEbIcgILq3EkRPCPn+do+961X?=
 =?us-ascii?Q?iLWmUeA5vPKLr4yWGIgy66pmZwPOFXseS2W17ERsV3Z0Rwd+LfAT+jVB0gXE?=
 =?us-ascii?Q?UBtidpOoNQdbQf2qQEmiOZyq6C75NmwlPXgGooF/OazOiItQQwzWPDrTwf8W?=
 =?us-ascii?Q?4RdcLBYYOA6NdRw7fCQRf5t9+VeAY+E=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	NbyS5J+zuVixirVWEpDKNYSKB88Y4ajDeyXDKt8oh4bCbbyZrdvrZ69akU7j8T4IhBWfu190m2IwttDf5UgqXP/UZ+EA/LbKPT4V7I4jR9sjFUCjRvKdg+ZMmQwNrSW5LHPFxNc9J2P6jPb39yonXnn2uMh+Bn0A8AOBnmUqwigS5sD3JUtphWxjIzQZlYSObQBRA7+P2rJv+R/ZrOTZLMRMmydTHI33RN8I+HepXM+9Y/rI2xn5zHb1vmHeWEqVjqFWs9Uo8AKM+SXFJKk/0Z1VGPwTUKosRkL0QtS36ywuf5h43T+PQkDNjl0EzqKK9hPx4ln28q5uwLVaMAXV2VN0NRPA/1/B1MUj/fg3QJVavqpuVuMDUYqAjK3gaVDF8T8rTDnGPPYWY7LIn0VlzzYaqsfpagB1Fd2+Dtqfj7gY2LIRt+SUCb1xSqGGTuNdirjkVdwBnDPxcDI/nbsYC3bcSqpoUQ1TGOhUExG57QxaAe1XJqwospNosvac+0qrA1TrTg/RAClfSwuQRleT4y/SYTHZHN3PUDxKhWXx8i017Tc9biJFNuz2Lz8BhHwy1yhBpKvMgnU8n/Lhj59Fowpfqtw4atUZ4CiDfjW2rOQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e41ec6b-fb21-4972-5b51-08de59b672dc
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2026 13:02:08.0145
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hW8pBJlBGcAXiIAFviHYqLi4crFsuqjW5eNAmFUTgYLYbfr5K7UZqrTYsvbvRgDuS7UM3Mq3j/U2+2040gkia9HZVHmvTnA9kxGLOyXRgME=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB8198
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-22_01,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 adultscore=0
 spamscore=0 phishscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601220097
X-Proofpoint-GUID: Yzbw8-qkTF3wNlp_aQ3qMEoXsjE5O7ew
X-Proofpoint-ORIG-GUID: Yzbw8-qkTF3wNlp_aQ3qMEoXsjE5O7ew
X-Authority-Analysis: v=2.4 cv=QdJrf8bv c=1 sm=1 tr=0 ts=69721fd6 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=fUIvD_cNObhrxFjjdL4A:9 cc=ntf awl=host:13644
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIyMDA5NiBTYWx0ZWRfXwoChbHVbWK4e
 8xPT+68e8UZDF5cD5eGL/Nr9p+vJUiTZBTCWm7o+btLm0k9dELP4eJG2pUWVan223lSjPwKSiO4
 xKdtfkJEGsshkUfcI5MNBMZvvWq06Gv81ANEk76CO14gmWyRewHW7xp/Dhs9Vf615iYToJWbKc8
 zmEN/dMQLtWKjzjrYXpz+Ir7KHca45me3cR1+BXZHhLq6MAYHRvITiHB9lILF/vgznN1n/yF7DN
 A+l76Vldb3pxgdtwylvf0zSpuu1oksttVFjg8P7bqkcJqxGyf0f1lXEdJRffNPM7YjXl5OC5eb8
 +n3AMt1K9f1TAFqOLZHm13fMlesvFt96w7Z9RgjAs/f/iqRli0j0tcURX9HIYD4IthxDL7zMrfW
 iQWhNoWQZxAZhgXRQh0i3nLy3SPPj59j7RHeK/eVnJIOWoKLENnAVEuFGmK/HHK5Ny8qf+bE91q
 UK/lrDSCKjX93Q0yOv7wQVL8+2Po0geVuOOgZMsc=
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 2C2F78000A
X-Stat-Signature: xjmhd7jwrwbapg4tih1bpqffntond895
X-HE-Tag: 1769086946-138074
X-HE-Meta: U2FsdGVkX1/aemOFvnoAEiZ9Tb4d4RRqOTu3l3kxvbyyXyvfU3bNr4VGahpf6eNl45IC4kzb7ouYvsP2GtHgX+hlq+SnF65HgopXqvkRDo67LBX+USvRRNscGFC07snsZNmFwbb2xOr/cWe+nBidStH6wb4tM1VCJxom1siziCaLq60qj8UexwL6CWSbqkqMrPWdHWRahHElwyAtqoLKMNPtZZFpNhbGp11iXtgQZkqT2sB4Z26eljC1wYbJErIhgNgcsbu7KVlwkpbuuulUAwDvuF/UuedZPu5ECjHIfcx+o/79zpeAB03pYr4WgFJ5i6f+uOsCqy+aqze/4P0KuhS2i+RsJcytg6T5vqK0LnCWcnD6LXuZuB2ad/CwTWAarGyW3BJ/yZHpeTrxmHbNiuABDsyHOpLEZxo7L/U1aE2yhDXXC+xpx9X34PitobMdt9I8j+6siHaNFylAdCVRq815D7FWwdde26Wx0hYPoW3QeEl+7qQmmZDTQXvJPhtYDRlHeAK8us0JKWn/4LUIN60KS32tQplyMq5AHseT81JdNOUzjjtt8A7wJhWT4mrBbP2avPU6nHzMums1wXu1BGJPep2aDMp6aTZTGJ28+qyo5RO6mN9//HSs2s4gc8EPcNNZ1+I89niG7ziPx7LJoMW4vYQXvuWMBNM5lsSCJHHbPxFbI4rx3VS0HF3swT8nS8V238/UA6Wb/JkzqRIvxkQQ5HTmOVFLq/tGL4B1zhZVIe0pOXrDkETDXw53OntMd8XjcJ9YTVf1Vl0lWy07TH1XZLTsMQu/N/8armw5t6NNNIa7HX1QQf+/b38m+In06Wu2cDHTeLnq5Hil+nct96NuusylaKiEDiXI7cHknXD/J7yelNoiWkilRizYLEsyeuncdDsBF1S8bjrkItYF5SiK3fyS9feO96jjxxoiF3EGP0/R0/btAz3pVBtGGV2Adzo01q3eowCospZxA7/
 2lGnspf8
 9f/v9pHd9QXVGp9vzjjzZfllJ04RHsW/aG/GQ7cGyYOVKUgiirfbOY3fyxfC8FVcxhDtUvO+srWIiaq8wPEJKlwDSILvqlO/q1kSNepODW8QHi9Py3AUAdN+X5iYV8lBTI/aj03hG3mQ4YcYbqcpHihwhFup74TEE9HIviHNNguf1WGbeiVEDZBFHrjDBvj839BCh9OAV7qBgzPvaVgcsJetTaX0PVQg3bA6cBZT7yL5jkdYd8jkx5eRyjywD/T9YDZsCiS8gLUHQldeDk9Q+sAjWtAxjezb4BLUmpWm+njwBzvGKimxAXHzP3jcc8UyIcnjvVly2/Jp/MCHBJo1uKtq1C5c0m11vrA4c8wtczaaKU1mVPMqbdN2Hzo1/BZKpHjik9QkTKJ4R7+CsOs3nRRjydYIUEBauyfONGkEmbz51/6hEqSWU9TrcwbygHKnAvBuJSleXbkSEKzoc1QH8laUi7xPoFotvGosbftIpwLKkBQzRtFQ7Z5c2z1vh1El8FFzDE82PwyXbTkTESa+A2vt9gVCxuiWlG+C+N52Kt4x9LeG9+alA4BsgOGMXb6w7MeglcfEIE113CGrjEGDtQCWUWEjxPKq5+fLogGcI4aJx07amWvwVj3YqjSKuSRLct8FFwsqbXsTUlg5dJ30+ySAuy7n/en1BuJSZFuvuc7Lak7uG4DXt3riZbq+L8deAF+O2TYmC3Ys5dOmdzrt22A+Ao9rs1qVOPreU9vUvWn/RVQRM9q1wFG8GZwY/husZTK2QZwc84tfo464CyOMkxnD5Of+WN0WMxtpI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The is_vma_writer_only() function is misnamed - this isn't determining if
there is only a write lock, as it checks for the presence of the
VM_REFCNT_EXCLUDE_READERS_FLAG.

Really, it is checking to see whether readers are excluded, with a
possibility of a false positive in the case of a detachment (there we
expect the vma->vm_refcnt to eventually be set to
VM_REFCNT_EXCLUDE_READERS_FLAG, whereas for an attached VMA we expect it to
eventually be set to VM_REFCNT_EXCLUDE_READERS_FLAG + 1).

Rename the function accordingly.

Relatedly, we use a finnicky __refcount_dec_and_test() primitive directly
in vma_refcount_put(), using the old value to determine what the reference
count ought to be after the operation is complete (ignoring racing
reference count adjustments).

Wrap this into a __vma_refcount_put() function, which we can then utilise
in vma_mark_detached() and thus keep the refcount primitive usage
abstracted.

Also adjust comments, removing duplicative comments covered elsewhere and
adding more to aid understanding.

No functional change intended.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 include/linux/mmap_lock.h | 62 +++++++++++++++++++++++++++++++--------
 mm/mmap_lock.c            | 18 +++++-------
 2 files changed, 57 insertions(+), 23 deletions(-)

diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
index a764439d0276..0b3614aadbb4 100644
--- a/include/linux/mmap_lock.h
+++ b/include/linux/mmap_lock.h
@@ -122,15 +122,27 @@ static inline void vma_lock_init(struct vm_area_struct *vma, bool reset_refcnt)
 	vma->vm_lock_seq = UINT_MAX;
 }

-static inline bool is_vma_writer_only(int refcnt)
+/**
+ * are_readers_excluded() - Determine whether @refcnt describes a VMA which has
+ * excluded all VMA read locks.
+ * @refcnt: The VMA reference count obtained from vm_area_struct->vm_refcnt.
+ *
+ * We may be raced by other readers temporarily incrementing the reference
+ * count, though the race window is very small, this might cause spurious
+ * wakeups.
+ *
+ * In the case of a detached VMA, we may incorrectly indicate that readers are
+ * excluded when one remains, because in that scenario we target a refcount of
+ * VM_REFCNT_EXCLUDE_READERS_FLAG, rather than the attached target of
+ * VM_REFCNT_EXCLUDE_READERS_FLAG + 1.
+ *
+ * However, the race window for that is very small so it is unlikely.
+ *
+ * Returns: true if readers are excluded, false otherwise.
+ */
+static inline bool are_readers_excluded(int refcnt)
 {
 	/*
-	 * With a writer and no readers, refcnt is VM_REFCNT_EXCLUDE_READERS_FLAG
-	 * if the vma is detached and (VM_REFCNT_EXCLUDE_READERS_FLAG + 1) if it is
-	 * attached. Waiting on a detached vma happens only in
-	 * vma_mark_detached() and is a rare case, therefore most of the time
-	 * there will be no unnecessary wakeup.
-	 *
 	 * See the comment describing the vm_area_struct->vm_refcnt field for
 	 * details of possible refcnt values.
 	 */
@@ -138,18 +150,42 @@ static inline bool is_vma_writer_only(int refcnt)
 		refcnt <= VM_REFCNT_EXCLUDE_READERS_FLAG + 1;
 }

+static inline bool __vma_refcount_put(struct vm_area_struct *vma, int *refcnt)
+{
+	int oldcnt;
+	bool detached;
+
+	detached = __refcount_dec_and_test(&vma->vm_refcnt, &oldcnt);
+	if (refcnt)
+		*refcnt = oldcnt - 1;
+	return detached;
+}
+
+/**
+ * vma_refcount_put() - Drop reference count in VMA vm_refcnt field due to a
+ * read-lock being dropped.
+ * @vma: The VMA whose reference count we wish to decrement.
+ *
+ * If we were the last reader, wake up threads waiting to obtain an exclusive
+ * lock.
+ */
 static inline void vma_refcount_put(struct vm_area_struct *vma)
 {
-	/* Use a copy of vm_mm in case vma is freed after we drop vm_refcnt */
+	/* Use a copy of vm_mm in case vma is freed after we drop vm_refcnt. */
 	struct mm_struct *mm = vma->vm_mm;
-	int oldcnt;
+	int refcnt;
+	bool detached;

 	rwsem_release(&vma->vmlock_dep_map, _RET_IP_);
-	if (!__refcount_dec_and_test(&vma->vm_refcnt, &oldcnt)) {

-		if (is_vma_writer_only(oldcnt - 1))
-			rcuwait_wake_up(&mm->vma_writer_wait);
-	}
+	detached = __vma_refcount_put(vma, &refcnt);
+	/*
+	 * __vma_enter_locked() may be sleeping waiting for readers to drop
+	 * their reference count, so wake it up if we were the last reader
+	 * blocking it from being acquired.
+	 */
+	if (!detached && are_readers_excluded(refcnt))
+		rcuwait_wake_up(&mm->vma_writer_wait);
 }

 /*
diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
index 75dc098aea14..ebacb57e5f16 100644
--- a/mm/mmap_lock.c
+++ b/mm/mmap_lock.c
@@ -130,25 +130,23 @@ EXPORT_SYMBOL_GPL(__vma_start_write);

 void vma_mark_detached(struct vm_area_struct *vma)
 {
+	bool detached;
+
 	vma_assert_write_locked(vma);
 	vma_assert_attached(vma);

 	/*
-	 * We are the only writer, so no need to use vma_refcount_put().
-	 * The condition below is unlikely because the vma has been already
-	 * write-locked and readers can increment vm_refcnt only temporarily
-	 * before they check vm_lock_seq, realize the vma is locked and drop
-	 * back the vm_refcnt. That is a narrow window for observing a raised
-	 * vm_refcnt.
-	 *
 	 * See the comment describing the vm_area_struct->vm_refcnt field for
 	 * details of possible refcnt values.
 	 */
-	if (unlikely(!refcount_dec_and_test(&vma->vm_refcnt))) {
+	detached = __vma_refcount_put(vma, NULL);
+	if (unlikely(!detached)) {
 		/* Wait until vma is detached with no readers. */
 		if (__vma_enter_locked(vma, true, TASK_UNINTERRUPTIBLE)) {
-			bool detached;
-
+			/*
+			 * Once this is complete, no readers can increment the
+			 * reference count, and the VMA is marked detached.
+			 */
 			__vma_exit_locked(vma, &detached);
 			WARN_ON_ONCE(!detached);
 		}
--
2.52.0

