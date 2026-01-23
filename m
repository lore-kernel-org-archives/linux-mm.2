Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23CFBD778B0
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 20:13:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78BBE6B0562; Fri, 23 Jan 2026 15:13:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73EB06B0564; Fri, 23 Jan 2026 15:13:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 603EE6B0565; Fri, 23 Jan 2026 15:13:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 442386B0562
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 15:13:48 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 10DA31B06B4
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 20:13:48 +0000 (UTC)
X-FDA: 84364329336.23.BCF5BE6
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8849440009
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 20:13:44 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="WD/+qxLw";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=zQERS4aH;
	spf=pass (imf17.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769199224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T3KuqJx32leIB0fpbeGBrLLI5lncU0eEuCoijBy7kkI=;
	b=ZEm91rtbMb3Y5nfoWZ+CNBl1CuQzRjCKALCStPt+jEm1ZV0E36bUVk3rDmrQl7Rt5xMQUg
	meH8BvSScEjSg/GrJIP82D40MCSREBf63O3OwhQ2GSy9wWDXLHOz/ClmRycrYHMd3rToMh
	FNjdyb9G+cw8X6LnB3e/HFvA3VqECzU=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="WD/+qxLw";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=zQERS4aH;
	spf=pass (imf17.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769199224; a=rsa-sha256;
	cv=pass;
	b=HsXW0zHjSlI33byDU0aMgwyFdJYXbH1Z+/jvTNhzTaBvx4i+DzakE4HAHeIFIO+pCRdyPx
	iZZ9Gb/dwMik/RNAhMtp8BIYQ20p7hhcbdolXR7hkcbKrUcr00Z5hd/B9T7/cogdSJd+v+
	f5Nqppjz1HYMkUWEs6G1pJ5WlEvQRdM=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60NF7UJt2173055;
	Fri, 23 Jan 2026 20:13:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=T3KuqJx32leIB0fpbeGBrLLI5lncU0eEuCoijBy7kkI=; b=
	WD/+qxLwQ4zB8QOZ65JVNkoXFxduLlLrQyRJJry6lGmcrQA9HdAcIfxB5Aq9+ZoR
	kaFlDvcBODx8TbuWl/KnBIVm98ovfSC6L7R+PBN3lytExb41Woo1dGqT7s0U5eFX
	9hJArDmka371ByaNy/eLmJOXzqC2ukR/OTLJ4ISb93jb5iEmRP0x68kSswoY9xZw
	TC/fn5rFOXN+euPQGfDjWGGTKnQPw9yMGXQ2hJFRbqLDZ7IBsrMAyuBwnndJdV/w
	z9cR9b6qgk/dElLR5SwdzQdcdOA2js+qSnksX8LX8T7q7yMEvqBMlwN9MDVd3vez
	YFaKAMY0mGDAhE9CrMC/xw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4btagd7k9u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Jan 2026 20:13:34 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60NJQv5W024865;
	Fri, 23 Jan 2026 20:13:33 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010053.outbound.protection.outlook.com [52.101.61.53])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bujd1xfjn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Jan 2026 20:13:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U1GhDPIjDajvvU4lFWp2NUgPcgBgJj6Pti9qwq4YUS94VBFyyi+FTx5odESiDsvBnvc/JXH/QroSK+rsg1hhyXBNVzqquj54qUKhyTr3NYdpcFagWx0iT8PRlt7OyPvr9tGum1l9a/JJMEeE7T8UNwDgy2a1alQzcAQOkNy7HZxkZPrWA9s+xqK1ZH/7nBbLbsQKHlKWd6l1uZtyj4rGHxrYk8W+s0AFCotk96FtVHTia+ee/Kx5H9QFs/97fHdvRxnSsoVK9yy60s3LTbRxrTLTCbFzUCRTDAf6LnfJ8C0K1XZPgsJWcXzZEnDpHpt97dDcxEtZl84HVOAGFN8Nvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T3KuqJx32leIB0fpbeGBrLLI5lncU0eEuCoijBy7kkI=;
 b=dpMqZa5Ijjw/F1yCcm9i+ONoUo3QNixH2VZsd3OpTdfql3C1LCcqzTELyedtOKlExaIN3SyWjY1L5dHWPY259cmo1UFRzu6X/MOsRXLHT5v7QtzMPWa+rany6O6YsdiiPtVqeY2JAtKPUd67ly3tFAi0FS5Gb1CbHyhHAnbKspRwMj/UXbSunJnP78lJ6OJNphVcITpRbU6CwsysEd2QC5+c5OK5cxNxxeKKzoslnsNtQzjsWjB5pifADdPJs2BV+4zRjQPOGQYGC7zjChMaD9Ei9t9LMez/ZJQGwVjh2XYDN0VWUlcLVM2IshG/QrPV5NSD0JjqF9FpoFRVdzA2Pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T3KuqJx32leIB0fpbeGBrLLI5lncU0eEuCoijBy7kkI=;
 b=zQERS4aHltT3+kbGK0m6rCfgYgfR0zq7OUrQ2ARw4NuCQveSsWMnuyiczFS8wYQSqrgvb2EeVGR1ghxcnNHpx0nehHIRtAlQb/dyhmZT6Xzp3n5Gw0i5ja7/6Bv3aTW0br/vZcNUDxmY/tPHrzZIrAU68Aa7ooVqaBYv9jMI1xw=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by IA1PR10MB6877.namprd10.prod.outlook.com (2603:10b6:208:423::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Fri, 23 Jan
 2026 20:12:39 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Fri, 23 Jan 2026
 20:12:39 +0000
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
Subject: [PATCH v4 08/10] mm/vma: improve and document __is_vma_write_locked()
Date: Fri, 23 Jan 2026 20:12:18 +0000
Message-ID: <ef6c415c2d2c03f529dca124ccaed66bc2f60edc.1769198904.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1769198904.git.lorenzo.stoakes@oracle.com>
References: <cover.1769198904.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO3P123CA0007.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:ba::12) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|IA1PR10MB6877:EE_
X-MS-Office365-Filtering-Correlation-Id: b39aacf3-2bbf-4b90-39ae-08de5abbc155
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?aXhqZq/g/sd2U7iPFcXleJqC3FwQ1emho8P1OdhCIvzagXoBhe7kk3x9Dyjs?=
 =?us-ascii?Q?kl7iVMLZCx10xl7683uPA5Bxyzi8JKNMwoVmKxpusaxdDiWnZZ1M2tpxIb+s?=
 =?us-ascii?Q?cHpil7XtrK+yrYA5dR9kBWPyUISyZeLdCNN0UViSUgFl8SXI0iKaIg98QxVw?=
 =?us-ascii?Q?TltfwhRKQrMU3Fh+dxHW5qxiGKHv0OanUOKaLcTF/SEvyx5yviXUa3HUXVdk?=
 =?us-ascii?Q?Dhgi/tl25uvmjuW0YXlOcaxIrMa14PDc+ONCdSjabFkHTM6EfCjT7KVZOenR?=
 =?us-ascii?Q?RACmJejyA7V0tgWwUxxToFMr5fG9+uVkLm1F7KGzYK7hXdTFxZj0H2khTFyo?=
 =?us-ascii?Q?SapQiyZBF8PAMoqrMnmz+k8gCXlfwTWy8RLrsbQdUl054IT8oSDCjNg7gzWh?=
 =?us-ascii?Q?F4Wcc7r9pDX6xY/M9H5cZojq8uizYZ5WSvUnpI90tylxj+9G74oCmHECof4t?=
 =?us-ascii?Q?yuyJds2nHLNNSzTg4aSJpFd0DcpiFP1y7VBMjvmsv4Xg0q3MrjZPb53qxQ4C?=
 =?us-ascii?Q?2MT9Mkr8/VYpXx6WoGeMEQWxhoh2pFMDUeXZw7g8oE+ivdn4Zq21uBEQG/X2?=
 =?us-ascii?Q?6bDYYJ+6hyFV+AFyT2Kx5rX4J5/yA/etEBARu/b5JoGw7SC4XJDAaj8s7IM2?=
 =?us-ascii?Q?pnk3G8j9mVIzQ4FrpSI4vGVRkAq3A1r6P/F8dn07IZ7heFaBlMRd/pxz8r3O?=
 =?us-ascii?Q?SKA22GTwOXCXQy2WNIISiTdO6GBduoSvRyPrv55jCtBrSiET8ouxg3/vQl2H?=
 =?us-ascii?Q?oHo9IkrlSw6TlfbxhVGH/AlyjPzWgRiIoNZGKtOI+egA4LMrKhUchcKNs+GQ?=
 =?us-ascii?Q?Z91VLtaLkVCfDlCfn7a0sAJy/dUd7JITptoTrW1WCrDQqzb37jC/sOXaPvrf?=
 =?us-ascii?Q?10rOboUCdbFRdNgqixoiRq4Yhuf/f/IKqR9Cjp5mWutDu4bcCVqM3Hr7X7xk?=
 =?us-ascii?Q?WWkpPLgRDum75Zcoux3PQBDp7YVxGFmtUqEaE+yS/n7qnObvKditnggBE8MR?=
 =?us-ascii?Q?phkFaMiOndfGasYQjxWjLpfvFJBQTZBRd+5pJ7ekLP2DB+EXpwUPCsSU8MbF?=
 =?us-ascii?Q?t54no/nbVNk33c0cGeU49hLL1/2mWGTqChemnNdboubsRt4NDx2MrtduS0Zf?=
 =?us-ascii?Q?gJjihyf9VfUZP0hqXb3ApURK/VMHVRF8mXeU01QdFdCHZg2gpDMI2tnHIFdP?=
 =?us-ascii?Q?CyGsRHwzBIwM50QzXXRzF9Ai3lkxIF9xmLZkWiNZFAr3vIRyYFsgmL/BQljz?=
 =?us-ascii?Q?i9oXGLzvR9N4NpffVDCqCrg7OfRk+MZ+TFvPRy21Fh7RtEmGoSo7+60IVr5Q?=
 =?us-ascii?Q?KTXFFioLfxx1kfpgHbmLjTAaONv2Ocx+KS9AacxH3UjEttovYZH4E3+tYIzI?=
 =?us-ascii?Q?9q1TF9i9hM7/ro6yOsvnzMMeI8F3dCEW0NS0Y1QlfWMtMiqHHppQPo7/JDqa?=
 =?us-ascii?Q?OdusSKhtt3NfgNzpFPHJk5oJlgxNxjLoVwRB7Q1dW1M4S1TKlaMzGSI8s1Cj?=
 =?us-ascii?Q?O4RVYmFHnJAcL5enRSdvCDzo/ZuoSnb5ML0LYMRV1722/fnqhmlen620Udrc?=
 =?us-ascii?Q?dDtkw6ikx1qWLQ1o+Rk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?koy5ieHj8fg+pb+h46cX3w4HUFctMhi0oaRDPv3UA7ESshIv+FUjF0KH1Gzx?=
 =?us-ascii?Q?RCZKOYuQRUnwzd1u06GMfg4Vy2yqMT6++2e7CEMM0CD9JOYXEJgQM/Wgj5M/?=
 =?us-ascii?Q?BRtJAyRdvc5/HWzX0TGgLyYpROeqEQe6VAMTcGYPAdL6P6mdN/lZqAFSoC6V?=
 =?us-ascii?Q?tjxQa9Lih9XrthGpM7Hbnie1Tnfn9JcGTaFp/tCUaZdtjj6mF+wucETsxt77?=
 =?us-ascii?Q?/kqc96xBVPXb9IZiahRW8BsjuwjqhyZcS04Ee5xXWJZksIM9ssPvG3TCJ3dX?=
 =?us-ascii?Q?Sb1Lxj22WcP9+6maKdF7oEMS2fKwfl6vvnqTTw69YJkEQleyfP4/MZK1d/KC?=
 =?us-ascii?Q?zNDnQH0OEl/xFqt6YfmqiULrMYxOUtYKO7Spxn+sBdgUgsv+Z/q7w1s1zGFg?=
 =?us-ascii?Q?iFJhpnWjOGRQW+Qwp1Uk/QJnajq02BqNHFvuoRcWYcD19848ZeAcwI3pOt2I?=
 =?us-ascii?Q?kosUi57taHiGRhSFEOxxTy51eL7dCA1bemXmCdv3Y6+38K25EL0aiPIh2IFA?=
 =?us-ascii?Q?0s4HrBy9Kdqn/0h9JCvF/QKjFcxpOstXV3+0xW4pCK/JVJSlLEcmT/Xt5tzI?=
 =?us-ascii?Q?z7HrvdhlD7LSiEYb2zS/714erWzUjIDvg4weet6sNBkLgbDlWsYIZjfh1ey0?=
 =?us-ascii?Q?cp8Z9/aG1WjogI4JMSH6iGilUbFr+13Ul2xoZYbxqD9y7p5ydjZEUspU9P4h?=
 =?us-ascii?Q?cEQP5d9fhe+F3KQ71pEvIXMxKH9W35CBUZNVAg+RAixzPOSGDQ8khH4j8L8k?=
 =?us-ascii?Q?s5mEZUJrWzj62ERIQx0YYHfkjummZ1zRm4QGs1d94s5grTdj5eNTTk5VTsy5?=
 =?us-ascii?Q?2DKyPY1Nd0QvjDbBoQMPob5xpGOqbR6yYHsYd6ruMmGFjiFUpbhDpJt7yR9e?=
 =?us-ascii?Q?CuxaJduYC8ov1YtyhYnZ7Cvv/faKxSLh8BhZiyRRR7oUzrxeiqVYmcu9ZZ9x?=
 =?us-ascii?Q?qOdPyIuIVHr0gH6zBuyt8nB4kbhOzef2zkU1SCAeQERLDiHzyJIYZV+k5tvO?=
 =?us-ascii?Q?HHNrQg8kXLJV6AmYC7lODpvZuojpSDUT0F2y5W23Vn22Imjx9CC4Bjwa86dK?=
 =?us-ascii?Q?5zuD8NRhUA++CC2d8lDlkur7g8La/j+bzWjM3aP9BMldQUjxV6YeDRxB3hmE?=
 =?us-ascii?Q?F/H0dGFN4lepWbVBQtCV4dCHDUK3+aPEKtne+6qM1lkwIwiVyD1jfoX+ycJ+?=
 =?us-ascii?Q?d5U9Juiy8hABypVWwrpaE1OvIrJ1aLA9/XtZ9wVAnWhpn9WIKTIxT255xZ+h?=
 =?us-ascii?Q?U9W2AhNiaHtaZzNv/dOr0dJ51v4rtO7GHVzNyXeMOw64fqX5SKdmayGjqZph?=
 =?us-ascii?Q?G97J9ngULIN3WL/tl9U1WmeT2NeQ5onrbOOxoUDllRlBecelySWQdVOhKbHj?=
 =?us-ascii?Q?ZjXj7xg/s0DufJkWm8uUqJXPalnCgA1EhNpxW3DS5VT4cNavOjKlrSvBGJEE?=
 =?us-ascii?Q?7dI46nTZD2/B8pfDPa0Tnx+uWR2JhusTjLy8g643oCa0DrUt3Mn/3KLK9iLx?=
 =?us-ascii?Q?FFV9DtijPLHuH8aDB4xhaqsXdHDZs6O8k0kaBVJmkfPuV3Mgz1bqCO2QM7sB?=
 =?us-ascii?Q?qtm/QBLd0QbZMKLO99c8iySsQ4Ok/WakGUU6ecDFuxVzDtijW9ajaB9Fuh/S?=
 =?us-ascii?Q?L/oj3NCz2w9ud7luduF/4u5PDVi6h8CxeUP46UfhMYTuS8ct3y41y0e1QfzH?=
 =?us-ascii?Q?cIzBDs1unWFcTj2rh9so/3/GLJA1WQpCE0irhtZu8SaE9iPOdw4nhM6K+FJM?=
 =?us-ascii?Q?nXQ/7rNB3EtV7nFn+CcLkppFKIdaQdc=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	F7zShFT9ZtB3JxTzau8BMG7uDZd14NkZmUQNOLfmfsebFaPXZLpmn5Qfi1V1J7TQgzIxsCWR0QcaC/tvrpkQqPd2tjCybGKJm31af+9yQUXqz8dn2uy+FCL43Q6K2sg2H9a1bRiB2s37Xyq09ABAoiwGIXq/kC8s6b7LV+oOueZTVf5N5GJmZxA6jgjfeKTcawuUaow9vFUs6RHpvbO+Nrcgz7m8Ya08myrp+xzspHu0/pFfgMw7VL8gRr6uY+uTToNbcSxLIIe/j8FyS9BFHZYW0Kf/otE3hgbm+kELAwFr1E5LqaAGpeObwOoeZpKXDEHVG606ZJM8EdnZnC8iu3VirRsgmPREv1f9nouyIoLrFEHvmO+VyrFrlsA0BkxfvGugb7vsWasUB/5/jTqnQIxvWCXcp1gJ/iKOhsLHscJUVs2pnDVEWRJhVMlZMzgPosie2Alyk+Nzb41OSOkbqMn/bmyTx9HTbbe+Gwrhi496LVNg6MgZXSOzwTfd/OYiE352r5f//VvGLPJi1PPP2K8z6puCiEKYE2KOnileQUaj1/Fb60inYLgY7JcMyZDla+4Z8Ame2KkV9Uj/xxuiKlm4fkGn833BDDnhQP2ULE0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b39aacf3-2bbf-4b90-39ae-08de5abbc155
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2026 20:12:38.3504
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pV/hH/yZse+cYo/HXW9LWknHiBTxtoMK31j8qZbR7SuL0yWa0EXul1sQrPrES6uVp/P5By6dANRQ0XWwjI6h6v4JqeHPuCP97gjSMz8zCS8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6877
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-23_03,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 suspectscore=0
 malwarescore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601230155
X-Authority-Analysis: v=2.4 cv=PqqergM3 c=1 sm=1 tr=0 ts=6973d66e b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=JWTSAJLagyWKeDSnsJIA:9 cc=ntf awl=host:12104
X-Proofpoint-ORIG-GUID: 9G5AwYFG6RlZIYAWjJ8JPpF90-NqB37t
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIzMDE1NSBTYWx0ZWRfX6Lw0m5m7zRoS
 JxcIz+MQZR5jQ+lv3HLvzyLISrNc0qnWNgZYzjX52urta1i6C246r5bgZvKU0tCkTGvjEwFwP4G
 91lX8V8llAOmVuAN56JM4SL7FO9Q+O5gaIjjcmeF6f2G0cqctGz2rd2tGPufPwpODjdkc2gumxU
 Ymdt1opyAxmaXIiRX3dEcXJf3jz52R1JgOwSVcqGh8GpXg7XtI5DOsy92fi7LPK5o3UexkE2Djh
 aV+Pz9lKVNqCQNdGg6fA8ElCdTtx7GFUvvKlxYiBKN8FkM3ScHg/4aNJLxSRV+4HdLErMTe1KJo
 lP9YQrzx+q0lING3CGCwvFk+Z0NtyrAeC3spyQoW2mjaN9QwLz9qlhdtL1LtsmXvHPk5ti0Eav0
 N+8nk05d7KjiVLk8bPpUUg8zicnpXJ+tXKG71N6AIAlbfAfYXLNsOYLhDgN3Z0nhuwpAc4mp6va
 XH4E5ZCQaG77v5Tu0jQ5ANOAm0pByruweTpdDhr4=
X-Proofpoint-GUID: 9G5AwYFG6RlZIYAWjJ8JPpF90-NqB37t
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8849440009
X-Stat-Signature: d47xgbmdb3fkx1icss5y8iy78eyts6dj
X-Rspam-User: 
X-HE-Tag: 1769199224-5539
X-HE-Meta: U2FsdGVkX18TDzxZTAUsDhyLR3zniXrP5W5X6tw1IsB9Uo/40HASLyun747OBV163GkIcTPLffGWLbZ+qHvsiSIHKqITn4PcgSVi9F2/34iYpmMOhbP5EqbYfjtLnA1qzjm8ezUT++LIOwtoYmGm35BSOf/6lPeO++hnXDtSRLn5CO0ziKmjaQMGMO5E9ZDHEe2to8aQdbBHkOGlHgQWeG1HnDHCTX6LKaXKDt94wQgQzE8ozqlDOOOy1h9xRe6ZuVddO798YW99kEhsBTtvz4llPBuSvVJSRFwlC1b+QV4jVhC/uwPOPy6UUDSJwhBUGRtdsgBCoC9ukHeLAzEZRsv30MwXYY68grDBlJ7KtCwjsXdxcYsPc6TBu9jMGioRnZa10OtMFis+vPeY4xnAAe3fbekDrVi4GBhOQU/7H8njNfhw1I9shOFvqR+bbl22Mv5HZc3zBc3aRQGysXpc5QdE5fpl1xN6f/lbliyNM9cw4MjI/CMm/Kh37MeDONGKL5gPNTyKm43r1E9GUX1lcdM3oG4RvY/tSpkSx+IakTXJkRkeLf6oY8Z90/cTj6GFh91vG/kNW7o26gp+nO8FwnaEGRGoOlInCImiRXcXdUruFxU5ti0L/FRkenqK6FNQTTwOpRpqzA6MauV7nCKEPFNz6IzJFHPkVBg751UGinbgqpd+NJdJIYTTmvgLalPXuvtN/9l+GcUaQXYFZMLyvpoZeWU4pqhW7z0RvyYAPF+Gz19DM67qYs6SUfsautv9WlbH+i+//cwDphb7avYcbs2EfxeKg9hIADaCCTQEXQjr2e2CymqgOLGPsaFfYvnQxgcVnZr8GoxL7/W6L9HyZK4Tb7lTd1W8OInUscUL83d8oBDhuxCe1oHMPJxtI8DK14qKMDr8icPn/YFe049jy+GBov/dgbq+JJSP88TZrULQhMngzKu1k73ZzD7E9ZL+oOW1eLTdyR9wZfjPpjL
 BvmGlPNg
 KGchSwRk2MI5CAZlHkR26dFqkgImpsqm90GYJfAHKnx1FQqXQAg+kFbY/zFMvqVdoIB2ikTi1jjU4b/Z0zVe1r9iKTJhXXsjYhJB12eLI3XK87l0CZ82EGn/YJ63Tb+hthRO1ejYCbs1idVZzO1qZp+9R65Ac1Su12SCG5KslbjaELKEhp6TdYA2AqGJRhkUJ/NpBvseW1kSXAd+VPjHHIRVc6mf37RCno1bY4rL2156fk6KY6TULDomazY39d4f6J4RrJeQhjcAd35sWFI9xU/UGliRZ8+8l8GTkdHWwEtPd0N15E1ibJjCM0InOBSQ9f5IpknQt3kY0BMUFT4T5TAgrDJJ4B8b18vXzkzlnIva4byiTgJQ8RsW+x4Zpeb/pMmJP9jh3AObc67mCxfJ8Qxd2pmBHWj3QkdHc2kdeD8zGMUQ4K8Ucp/dDx8LQVBsGUyeaygBXE1wmYYaxo/fZyjGFpeCX8vCo6D7Lh4xFHGaR6Af20GTSbKQQDfemaWUgzBYv/BZ3NXSphVvlZe3gEJjPJnx0B0K54Lh41HGdcsz2VcLvc4JiLNNq7FTah0WRtLiQQwPZ6mJ6PHZcsd9ce1g7EPh68xxrBzV/C37NRe2ae33SQZnkKsFUEoAUAtu46/SwPlVTi3eZS+5yOguHyqkYbFO4VRV7r0nzRkbQeNL3uC3liFb6eVlLYWlLjAB/guxY+xXWiQQsQ6JI9QIIhFG2WVaV0B+shPFb6ZxobZBROI2dZGfi19FeUSrSjqOaEgMcyICyOnvE1rByR5Lca5zAFrb7909p7FnB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We don't actually need to return an output parameter providing mm sequence
number, rather we can separate that out into another function -
__vma_raw_mm_seqnum() - and have any callers which need to obtain that
invoke that instead.

The access to the raw sequence number requires that we hold the exclusive
mmap lock such that we know we can't race vma_end_write_all(), so move the
assert to __vma_raw_mm_seqnum() to make this requirement clear.

Also while we're here, convert all of the VM_BUG_ON_VMA()'s to
VM_WARN_ON_ONCE_VMA()'s in line with the convention that we do not invoke
oopses when we can avoid it.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 include/linux/mmap_lock.h | 44 ++++++++++++++++++++++-----------------
 1 file changed, 25 insertions(+), 19 deletions(-)

diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
index 678f90080fa6..23bde4bd5a85 100644
--- a/include/linux/mmap_lock.h
+++ b/include/linux/mmap_lock.h
@@ -258,17 +258,30 @@ static inline void vma_end_read(struct vm_area_struct *vma)
 	vma_refcount_put(vma);
 }
 
-/* WARNING! Can only be used if mmap_lock is expected to be write-locked */
-static inline bool __is_vma_write_locked(struct vm_area_struct *vma, unsigned int *mm_lock_seq)
+static inline unsigned int __vma_raw_mm_seqnum(struct vm_area_struct *vma)
 {
+	const struct mm_struct *mm = vma->vm_mm;
+
+	/* We must hold an exclusive write lock for this access to be valid. */
 	mmap_assert_write_locked(vma->vm_mm);
+	return mm->mm_lock_seq.sequence;
+}
 
+/*
+ * Determine whether a VMA is write-locked. Must be invoked ONLY if the mmap
+ * write lock is held.
+ *
+ * Returns true if write-locked, otherwise false.
+ *
+ * Note that mm_lock_seq is updated only if the VMA is NOT write-locked.
+ */
+static inline bool __is_vma_write_locked(struct vm_area_struct *vma)
+{
 	/*
 	 * current task is holding mmap_write_lock, both vma->vm_lock_seq and
 	 * mm->mm_lock_seq can't be concurrently modified.
 	 */
-	*mm_lock_seq = vma->vm_mm->mm_lock_seq.sequence;
-	return (vma->vm_lock_seq == *mm_lock_seq);
+	return vma->vm_lock_seq == __vma_raw_mm_seqnum(vma);
 }
 
 int __vma_start_write(struct vm_area_struct *vma, unsigned int mm_lock_seq,
@@ -281,12 +294,10 @@ int __vma_start_write(struct vm_area_struct *vma, unsigned int mm_lock_seq,
  */
 static inline void vma_start_write(struct vm_area_struct *vma)
 {
-	unsigned int mm_lock_seq;
-
-	if (__is_vma_write_locked(vma, &mm_lock_seq))
+	if (__is_vma_write_locked(vma))
 		return;
 
-	__vma_start_write(vma, mm_lock_seq, TASK_UNINTERRUPTIBLE);
+	__vma_start_write(vma, __vma_raw_mm_seqnum(vma), TASK_UNINTERRUPTIBLE);
 }
 
 /**
@@ -305,30 +316,25 @@ static inline void vma_start_write(struct vm_area_struct *vma)
 static inline __must_check
 int vma_start_write_killable(struct vm_area_struct *vma)
 {
-	unsigned int mm_lock_seq;
-
-	if (__is_vma_write_locked(vma, &mm_lock_seq))
+	if (__is_vma_write_locked(vma))
 		return 0;
-	return __vma_start_write(vma, mm_lock_seq, TASK_KILLABLE);
+
+	return __vma_start_write(vma, __vma_raw_mm_seqnum(vma), TASK_KILLABLE);
 }
 
 static inline void vma_assert_write_locked(struct vm_area_struct *vma)
 {
-	unsigned int mm_lock_seq;
-
-	VM_BUG_ON_VMA(!__is_vma_write_locked(vma, &mm_lock_seq), vma);
+	VM_WARN_ON_ONCE_VMA(!__is_vma_write_locked(vma), vma);
 }
 
 static inline void vma_assert_locked(struct vm_area_struct *vma)
 {
-	unsigned int mm_lock_seq;
-
 	/*
 	 * See the comment describing the vm_area_struct->vm_refcnt field for
 	 * details of possible refcnt values.
 	 */
-	VM_BUG_ON_VMA(refcount_read(&vma->vm_refcnt) <= 1 &&
-		      !__is_vma_write_locked(vma, &mm_lock_seq), vma);
+	VM_WARN_ON_ONCE_VMA(refcount_read(&vma->vm_refcnt) <= 1 &&
+			    !__is_vma_write_locked(vma), vma);
 }
 
 static inline bool vma_is_attached(struct vm_area_struct *vma)
-- 
2.52.0


