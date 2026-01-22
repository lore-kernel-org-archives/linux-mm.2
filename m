Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DE1DD3EE60
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 13:02:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72C626B019C; Thu, 22 Jan 2026 08:02:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 714A56B019E; Thu, 22 Jan 2026 08:02:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48F786B019F; Thu, 22 Jan 2026 08:02:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 24DD36B019C
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 08:02:33 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DD5E713A8A5
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 13:02:32 +0000 (UTC)
X-FDA: 84359613744.28.AEDDCB2
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4FD9240007
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 13:02:29 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="Xa1W/CKx";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=K9SczQB3;
	spf=pass (imf07.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769086949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HIMLuVVTSi12AhCgxMX/1m2syQDYlw08cP3yXSHaXxU=;
	b=H919bpfiS+OMWGvrg0+ezfRkEiz2Wp255tp/IkX6KT5TF3VLswGwAQyC/W50mdg0zhv6hh
	KXJgMakbMW1UiKASoq8kRp3dTtgIH4yRzv9Ng8qFI9K1F2zoIpKAuI8Rv6wB2LdnuV7JeT
	1i3su2lvWDe1XBwByMrRSOqx4DWd2+w=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="Xa1W/CKx";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=K9SczQB3;
	spf=pass (imf07.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769086949; a=rsa-sha256;
	cv=pass;
	b=nojnxotqwL22x84po0/MX8W81JZ6HAYMV46749mU3Fri78I8rms1A2exg3WjsR7dpbSDst
	Gn+8Lo4vU8XpHk6zWp4/M2JnDI+vbWVKpugvcue9Fi2vWsAqFR/u0U6d2ZD5oGmxJGcwxq
	Jv5/SUUxkFsF1LPARHYTCMhkmlAT2FA=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60M0wk5w3031717;
	Thu, 22 Jan 2026 13:02:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=HIMLuVVTSi12AhCgxMX/1m2syQDYlw08cP3yXSHaXxU=; b=
	Xa1W/CKxDIyOFWtMTjLJqvfBmuHjP9U5fHtmIJXw6BhPGkSQAO7SBkl11K7jURnz
	Xx2PbAY0NpFJ63JbFvCAlQCBftKqVjM2Z2R4MH3iCn6HJO+ISnDK3prh+IFj1PaL
	seGgTefZ/4jKBTCfyavT5TKeawq7cF6F1QUStQ6J5G9ZHGxfrMXglHpe5mDAA7D1
	CRr/da+RLZXZJvEMS+ZiM8InkxQkh3i8MShPgFZH5eVUM2DPFxkY3E/E7EfR95ml
	ujpUshHkNuc/oDwyDH0ZeN/+6KOziSyY2XNKzuzqlFk9nGMruGI1KYsXZm74kNhQ
	h46Rso1gW/htm3wEN3ECEw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br2ypyjfe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Jan 2026 13:02:08 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60MCQMpK032121;
	Thu, 22 Jan 2026 13:02:07 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010040.outbound.protection.outlook.com [52.101.193.40])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vgkfup-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Jan 2026 13:02:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VjnSQYiCPHB4aHEzswQBl60CP1G49+9HXNT6p1+6djLfIwLZRryHjXmm+BVcM5yWObxGSv3e5EZrx7uPCT3+cphEX6m/NNqlLPP1FqqgglKQOCDe/FPuK+uj2VwCKijE6bjpZjzojDPX3vsX1PJjFbJsxW1Qbl9p3jOzNQWRrLE0oZhe6atJIUoYVjjzCAORX1r9eDZOwCT9Bkv1LLjb+xPtk7f+q4nYGOx7j5UjRWL3LeL8I5DNTDV3gxzip4Nes7dPR8XOm8sdJOeSmlDfhQCEtJDgSW2dkYzbC9pydBuUUIosLggH9LpMnXGNRStCfS3hov/Fx2b289DdxdpQ9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HIMLuVVTSi12AhCgxMX/1m2syQDYlw08cP3yXSHaXxU=;
 b=E06nKOTAj7eb7QQSgp/16elhQmxpNaUSN06pz8VBoNVqQyIq5zQgcTCOwFREshD1L7biyjAdeJBJX5HmaLWzNcyOMVqtKeNj08Slz6/vp+klAgtytcm3XH9Sk+goNbvbeyA/jjFcKJ7aEyAZ+hg2BmlUtvP7juGCbQ9O80jOeAMqaYB7Gm4KHM8NIzO+Lf2a8uZ2eiT99EWqSIkve3Kr7Km4TPFIChIM0dlxVIYCl+tw11j5b9pjbU7RSVsbvsQcxvGVNFpJEGXiuNJwYagbCVL1M94++UE9q0K2WM/An5s/Sx5Qrbs9P5FwcuDWlovzPJrfdNbpab3RE9S6Aypg5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HIMLuVVTSi12AhCgxMX/1m2syQDYlw08cP3yXSHaXxU=;
 b=K9SczQB3h/XhfbRkeLQpg+GZqpzf0/Q7u3ovqCVy0Z9A/aI77Pw2QcHXEu3Gan8OA7NTWVPv0T79hoAzxwvXuY8wFixCjK4ZFa0APsunNdtvtsWyw+J9+n1t8Tsr/zYIjVHbhherpixKcjDuc6VMRgmolMvYMRjnUqfymJIXBoQ=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by PH7PR10MB6529.namprd10.prod.outlook.com (2603:10b6:510:200::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Thu, 22 Jan
 2026 13:02:03 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Thu, 22 Jan 2026
 13:02:03 +0000
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
Subject: [PATCH RESEND v3 01/10] mm/vma: rename VMA_LOCK_OFFSET to VM_REFCNT_EXCLUDE_READERS_FLAG
Date: Thu, 22 Jan 2026 13:01:53 +0000
Message-ID: <f637c1a5c9ea237aab598bd8885df48e21497635.1769086312.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1769086312.git.lorenzo.stoakes@oracle.com>
References: <cover.1769086312.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO6P123CA0016.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:313::6) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|PH7PR10MB6529:EE_
X-MS-Office365-Filtering-Correlation-Id: ce8e70c6-22b3-44b9-fbf9-08de59b67047
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?XmndNR1c7ngI9UhCvSUMgAQ4xuh2U2vjLB+VdMhxLLTXbrTplSQN0crMtt5J?=
 =?us-ascii?Q?nvkeGkBe1Qp2ZxCusdJjqz2/dxMxUe8ztg/W/VeHw35q/DobZNaIBDXwOEhB?=
 =?us-ascii?Q?+icmm/SHbPtFGkjNy4Z6INsY2D/xVrz3kNPnrkDnmbA+HnAjW9vvBItNfl6b?=
 =?us-ascii?Q?mKyFYhC75aJYMaOSnMyDx3s1f94qRhmoACIqq2/A9a2b3GqB5HjWeI02a4Qt?=
 =?us-ascii?Q?w2LCgqPYbOM/N/piFYPn2PrhEbv2h/p79Gy8/vjuEmRpgH/JB0tntLoFUJ+S?=
 =?us-ascii?Q?PUp2DRI6OXqFpRM08Cuu4GV33P3T+rzfuLRehVCshTKxKnwWNTRyMs+PD3ZS?=
 =?us-ascii?Q?2G7YcL15kg4LVicRI0LRZa4YpKkV0iOxM0E96Fsbuqjc42R7j4zFRheU9ZAd?=
 =?us-ascii?Q?a6/NJK9cOtAeA7KvnTTA2lT0XgZQi90E9dmnLYDwXvSf9HbY5ahOB6QW/2n2?=
 =?us-ascii?Q?LqFew1nmoZOUpmrCYVSM8Dfa8Mg1uKYVmHihQg6q5mtP1GUpVrLl7jGAWiSt?=
 =?us-ascii?Q?UpcKj7G/HuAtvf2ENePEfCZCNo9L9mwubQdiihk8R0Nr61MFnC47kB35/+gc?=
 =?us-ascii?Q?5jJ85aUUq2ZojwINYAqZU2PaIUUHYQw6urj4B7MpmoasEEFefiHeOaR11xFT?=
 =?us-ascii?Q?img8565Olq6P0QykdLPGf9HcNgT62aIsqAd/+AL5fjmQ6EaN1CdiUD2HybM1?=
 =?us-ascii?Q?SPIDPKpWO05XDCSlBeCJU8rhC1KYFZuaC4/i5Yny3Aoc8Gd4rnAUyZyEbRRH?=
 =?us-ascii?Q?BUBHR3dY2ej2eF6MUKBVLHhTM134Ihk7CmvvA2nDmIOkTB8plEY6yLP1Gtf0?=
 =?us-ascii?Q?sqE1J2WT9G5auUkop7es9i5Nx9HLEV937ThNj2mqUPCXkSxhwXUSbSxT7lf2?=
 =?us-ascii?Q?a1Y9E3wQ1BZoY3vv2+pjpu+8tgRZeD7X5BxiZ1PpwzQHgGQxzHwyXyMrWmu4?=
 =?us-ascii?Q?WScbRZqovg53nOVziR/HDM5iDqfXK+kEomyekGyt42LIZy8KPzIe6ZHuILRr?=
 =?us-ascii?Q?qVCRoVXamjQdawAK1K6PQv1hjNxitMxZtFp/fY5QvX+kPJxqMqd8+KblXczC?=
 =?us-ascii?Q?7oAjJQ5mQ4qDVFe8FRvlpxqI3ae3ia6Dy++puD7tdwxR+LhlC853FJIjTvZI?=
 =?us-ascii?Q?OZlqPCkdQ5GzmJq2rK2HMqyt1tcD1R0rFzCPtSQmlbh03npGtOQr/iaudJRm?=
 =?us-ascii?Q?gQRQOmChSb1PZJEbh4hRlsWxYxnnK3ZNuCiXQGSdyQ0wSXKIoaAjTENFFVY5?=
 =?us-ascii?Q?G8PWtDfEdnIzN+hXcIjzsozs9S59eWaJcKvRHtdPJWvK+rC4Km6duRJDVVjh?=
 =?us-ascii?Q?9HgabKN8IoXM8lKEr9FKi7CCWkoH6AFIk7qt0yB6yz1YvwHCacBtDaXNN02f?=
 =?us-ascii?Q?S4yG0s/a4hwWnCDaGamfp9moWdvI8GWEh+pysZzcLH9t1dP7dB2pBLNVuU9e?=
 =?us-ascii?Q?z2f7VSgkihI+1X13MdyW3a5c05fyrMWyEVc7X9GCOOe7JYtuJ4mtCHAbU6J8?=
 =?us-ascii?Q?Yx+wVLrtryPvTeMqHA23/Gye1kf5XMOWJRPkYAx7qxy2jAJNkB/+5DurrHrK?=
 =?us-ascii?Q?RxQuUK3w35IO5unFbEo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6XBIjyZztCS+pgtHKdWcZucKUWTwT1CZHaUIujdoxyPF++6StiXn/ILFJaUg?=
 =?us-ascii?Q?Qp2HOh/qSt+LvSKuvQ5FelUZdrk6SGts0lpo+JgE7W425Y5ToZTjo2ZR+SoX?=
 =?us-ascii?Q?3A1aEysCgbyXI2NEeuY522bXzVINJCa3JLsfC5Re7a88RhFe03YQqEi9LOQw?=
 =?us-ascii?Q?C7gJpu6U/H9YyiUOCI4aeAmMGrosKqZ99xu9D/MbVdbhHNlWsKwr5EzOQhJH?=
 =?us-ascii?Q?hukk+DvfQWTD3JZawwFdvxwl5YiHQFwf89s3nOl664JQDYC1SRQd6qTt78lB?=
 =?us-ascii?Q?YFs4CnZgOaUHqH+Iqs9Q7gzBsN4XwnIOh6uFVrOuMHfQj9B/OFSmRYmNlVGO?=
 =?us-ascii?Q?8ZYNpSYwU3VY41GzriWYK5MhVb3/9sFkT6wtNhcwBrkN3UPGkad6tCa+/gT6?=
 =?us-ascii?Q?cn76qo1IJTklqBAl7YiVtby1Zp4A3HgaivNlywBy+rwKXlQsC6xe1SuhsOeT?=
 =?us-ascii?Q?hazG7xczVHntFL3cKUD9ThNXvXrPslDF94YAXSUNdEb8w1yvd9VLqc722Dke?=
 =?us-ascii?Q?FY0dJ5qE25i6JBU31f+MuL7vlts+U3cwo86XVDo3y0vSzpSG6jFccH3DZ8re?=
 =?us-ascii?Q?3z19S2+ipwSTAYA8bsnByOW3z3gsguFVJi3N182duq74canB3RCtZGU2ELJf?=
 =?us-ascii?Q?wFVTrBxY0mwGUqbk7yGqst79Tucwhv9bc6Nj7zr/Z/owImNHTgYDJk+tx2fh?=
 =?us-ascii?Q?nJbBG6oZws8Y1Mc8HQZiD7oWORtbIg+REjZ7q+YE7TWkPmQjVehIo9N2X99Z?=
 =?us-ascii?Q?Pc8fRLCdpI6tjSHnPfyTtg1wCtC0+W/Zb+ZwelDC40+/IgvCuF+a8vWI+azd?=
 =?us-ascii?Q?mRao2NwQNyYTT6rCParj1aRC3a8ONwMFlsX+wuhRMQu84nLpF6d1BmnPayap?=
 =?us-ascii?Q?t7azzFqcyCTdG1FLaqbWCeN3q2T9INZxyEiilKgrltlMaQxiOdXUnekllNgx?=
 =?us-ascii?Q?P2Q1MHsmtXJi/3v1BHDgbRnsPpY0Wj6ZQ02MZ8BYPLAIl4uh3fZOCf9gsdJH?=
 =?us-ascii?Q?gpnDLNs2gwTWhC+PYBuXL5VPId4D72kNl4OTVbZ2mmXeMTb7NAnyhJYW2StV?=
 =?us-ascii?Q?lyQRsW/JzS0HreTuuzUbhnKPGPl2kJNYx8z+hBBn75W3KsLPCGbriE3b6+YO?=
 =?us-ascii?Q?P5W45aUi1w5XwRvMEZ7P1g0gzcqs7rLqVQDS9RibEzlQFRQ+wKTkTUooCBxb?=
 =?us-ascii?Q?XBWSpjoaGeN/CYkoc7VMVg4yksr/UhQA7Ts5PMfPhMljX0DKpIRPp1P2Be2X?=
 =?us-ascii?Q?NG/puJbnwfvOaK9qwLLHBlcv9uEuPsf7imXURYAjKYEhrpvYrT+XNBpMVLAP?=
 =?us-ascii?Q?JWTpEgk5b5Pox3eXZhV73Gq+dwRhY6jhlIwt+aujCYkvFrHTYplQmI3/ZUD6?=
 =?us-ascii?Q?QmFA0o7onsE1lLg4Xsc7lPRIOG15ehCS75TMgYOLVI1NB03ZDROXZWBv7FNY?=
 =?us-ascii?Q?HgYy730xCm4mFNKM5s9Ku2nD5SE3/NaWoupmhh2WXaXlHh7Xubnidl4q8lY8?=
 =?us-ascii?Q?TWDBjbyfwjsBM4r5k8OE7oVXqXV6UVTNfijU94b+3rAiyHTrrYPAdMeaSf5v?=
 =?us-ascii?Q?+i4lA4vmOzyy7nwbQMwwlOGJ0PRMXDZBRyxj9jK/3JFCpTGDhHtriWX9tWBE?=
 =?us-ascii?Q?IjCaDWuOOQ7STFKNzbF2a+pcqLAwU9St0qVYBBkauMGXsdsQ7xIZUYxrQ8Bl?=
 =?us-ascii?Q?YFt8GgPd0s/T3Zm2hC3kFgGlKBsJhGzwfxAd6nBgpu5/Nhq0gGM8GLw/oTmC?=
 =?us-ascii?Q?lnbyrM445rlt1FSbUSI2Ix8+8OfEd3M=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	TRpzp9A9S20uglKXMpEc0s93jUzWd/Sk8tsDAg+/RGlfJTXDSO3TNbqI1JVf79R0qO56vfJUiiM9fJed5wAO3qJ0kgoD62l+9bpH8iK7EdogpIjZNhRXVzSymVLeefpXm3zKwMPSZuUJivEeo9WPU5B/7drmmAMupVw6h9UnYoBZ50e4GhJlht33SmCHp05ITHlo7r7BaKwza9XJKEz/kLvu//cKgJ5nZztkP3M0WCYR+8CDlaELGLyKHKQj5ezOjZTwNUlKXjrRvfc8Cw9tHlDXOn4N1cphbtNo/WwKMQLJJ1d863tpuNRFR+ENx2r2lLS+JZ2G8AhehmlCUcvjE0YZK5LEE4SM1QMyMVMVUlF3EXoi/FZumXysPwWjJoXcW8K4jLKNOiPrkuUzL261NTDv6JbUJ3mb7+SsUB5BwB5l8j75Eut0Q+zJ7SxFGPWjj2v8bwB8nIcuT0pwPi8VdFOKg1x6QB1ODoKl0aEVt8uBpagAUY8THIF6t/yD+04S28Zj3ZVRkYbPbjG4DgY+oo5KS9PMgwURTchJ6AO86ylQ/ts9UdQeXYFCih3ydor3Gy+FbxqRAu6thi995qqSQJyFFKbu2CwUI0Tg4lSe88c=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce8e70c6-22b3-44b9-fbf9-08de59b67047
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2026 13:02:03.7009
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sd+6G0rZA1CGs8K9c6vYVv3Guq6UdWJjsNtbiXl3Dt0bcbMfdTI4re1GhlDqF+1iO5c/37uOo5p+AYPch51vpGVnAjoVxd7XfnOBKUpKB+w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6529
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-22_01,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 adultscore=0
 spamscore=0 phishscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601220097
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIyMDA5NiBTYWx0ZWRfXxAbaao2gftzj
 StVd2p1FKfkzOFGMrBJVKTGnPyWBC34eEdLV4M2X2eSBdkEOFlXCBd+pneOVQZ6JQJAz5J+qVsw
 3PK/2F+r5elw6F+yIjK6/nsWFteEOfBvptYe8O6PHtlS5QguySvKVZ4/lvoCFsvf7AZoTdLXWqm
 kM6uhLN4v0ktycjVq+x96ricQT8JkMsH1ynn2hWZJjmfRISeZPWMw2hiu7XmesVcs/HUaJoO/dd
 jp/XsAFevmCsSmYIYq1nVgx9gVL/S4foNJgXLKPxS/xbUSV4WnRm0HnQkG4EWUXMKGfLpL9kgqq
 fI/rUKdTf6fjXpA7hWop/hlWudmVNjVdF4fTsIxpSSeQcXPE9YMSrlK9fpLaw8AzxfbFkjcCZPx
 8QRBHX7WeAk0eKIbBAXxX6P6ZPfYXYSl3UCaStkNO7LGHvO0NV7OLh5ismlDcsqKgM5uEAXISBv
 PPU3KJp7BjY3qHz0vqHRgcMhX+hzbAOqhNOqmrs0=
X-Authority-Analysis: v=2.4 cv=de6NHHXe c=1 sm=1 tr=0 ts=69721fd0 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=gAv80hG6EH1GC_EPz9AA:9 cc=ntf awl=host:13644
X-Proofpoint-ORIG-GUID: FhmXN2h0A7SrXvNkO0Ruy2T0WbtALHS4
X-Proofpoint-GUID: FhmXN2h0A7SrXvNkO0Ruy2T0WbtALHS4
X-Rspam-User: 
X-Rspamd-Queue-Id: 4FD9240007
X-Rspamd-Server: rspam07
X-Stat-Signature: wxi8pfqbyzjjmwmfxz7d5x8bnne4d4ea
X-HE-Tag: 1769086949-625048
X-HE-Meta: U2FsdGVkX18tzYj4oVNCOeRIcNWqzoNOPRwse5k9RNLzbKlnKVkByk7sxSFS3h06hUFtqFHiys/uxiwjJoeh5NcCaErXnEGHGahyeu/Ix/UAiLnCjxLFVPOIAZI8Q9MbiJusi8xo6jDxDSC8ZzLqctkd3xBlt8n8DfS2/sMWqHxEYpA0SDrvksCO1InGU8v8lilzskislbvxtUvcX2tFRps/XjvpyYQhqZixjNjJg4mtY6YBbZUPRgbt/C6G0jT8KyLOmKiq4w5REwhAs5YFzErb4MulcChKakHckQjugOf2izaRTg8ktQkD3yxlP3XGpxuaFtOI+5BbEmp41URO0V3vdbcSnIOnZb/EFKkzr9Pqz3wQdo9A7/SqBfXgGsCv2PGReI9ps7OjovTPg+P+w1+GSXe2banOxHVOjAUOAscjhklg9G4VX5F1tt3hIEaZOa4JKIC4bmU++//sQ+/U+iW6eAEHNA21jO6T3gDvBzrxQ9eFm9NZEUGNMWh0MTY32VBdf3Chwgd6oZDHwM/hxSFQ2UxujsL6smCQeV2glQdxmk5xU20GqL6k5KJFxK+vVISxjUQjWJDA3sD59hGDeRY2zpXxQgLGnbKNjYGRie84OBW6cTJtSw+qe+BDoG3ZWzebICbDDr2tWosIUEEeXgj0i13WF9mIHAF+VttUqy2F5WUnfsMle3TVmLev3XuvQgZcAXAwMTscmGL7KbtQXUr+9yCquy5ACIAJ8HWeIQakjXsnyAhVe+FRgbS+f055ZlHj67Uxl5XG1OKv5okuH4nfznwFbtVnDt5upD2bbefhjJ3YzqNlDRgxePuWV3vRMgyjyIBduP8OwcgxNKKc0iKfmH0bBF85DdzGL1Tu0w7tzE8X4bp6KLeiPo8JPZfVKu1PsjQTFP6xzifq6NM/KxWSXPfM8cbdezR9aJ1JfhkyH6Mvub/nhu1N83A6v9PR7eajlxVxCPpuFTpssad
 PP6ntfXP
 esqTcOI9QEaOT4jn+wKICY07q2brJg3vjsX/Za1hWguzpcZQobwAbW9efbNpr2ooMACfz5+Azmi7+wAqFN84Smc1GjIGps8EF+CeUji1MB6oPVF7Z6d+rX74gy0PyL8/JpBXCfzjWPL6BJZnfC2tMSRF9Pf/NMfOMfWTDLDMzgoYz5Ah1PxBqK8ifi5K7wYe6Ylr5U2/IdSkIGrsj7Dx59HSjZ4jv6jmQl7TyK8Osd5jGyh+URBV/VuZgG8+qL5I8947Q+V4Tk2A4eMwulDNx78zC+f2FiKDYa3ZplnoLBg4hwzLnCqaUj7CDtTGgx+djsOYjJPmdwidtfVM9g8sQA7u0YE6TtdgkVDyOhoBsx6s0KwAJZrypy5XJmTnOq5uco4FQP+gat2YSu9gD0R51JcYA390XjkX0T1q6OGODSJmbRjGYyY+ZvLCAYd6m8pa3GINM2cC6Na4pEm1wXJa+9MVsToKYtxrpBubxkEuyH4ty9jf3SVaBX/jwVFWL7nrys4YMdpw57X3HvPNJ3BT6sY4yE1fT/F5+xFkCrECajPIMQMe5O+FqFwlCxCRk6NFs9rclhJik9sJOBCVMCwwEzIe2CkwnnqM7x/JQPqO+DZzwx/lppmG4HNzX8R+JWVdbeQEutKaLkCZHMDAQo2qR/xxkv+JO0K6g0+/46bowmgnc8/oUF6FAToQ9YT6Uy/7IyDMAjXcPkZxk1XiRT6m//skI4mwvUQcrD5LTJ3utj3MSiCSOsom+yAVnPaJQNb47KuDRn8nQBo2NPbZjCPHajbCO3JwTiEKbXYLP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The VMA_LOCK_OFFSET value encodes a flag which vma->vm_refcnt is set to in
order to indicate that a VMA is in the process of having VMA read-locks
excluded in __vma_enter_locked() (that is, first checking if there are any
VMA read locks held, and if there are, waiting on them to be released).

This happens when a VMA write lock is being established, or a VMA is being
marked detached and discovers that the VMA reference count is elevated due
to read-locks temporarily elevating the reference count only to discover a
VMA write lock is in place.

The naming does not convey any of this, so rename VMA_LOCK_OFFSET to
VM_REFCNT_EXCLUDE_READERS_FLAG (with a sensible new prefix to differentiate
from the newly introduced VMA_*_BIT flags).

Also rename VMA_REF_LIMIT to VM_REFCNT_LIMIT to make this consistent also.

Update comments to reflect this.

No functional change intended.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 include/linux/mm_types.h  | 17 +++++++++++++----
 include/linux/mmap_lock.h | 14 ++++++++------
 mm/mmap_lock.c            | 17 ++++++++++-------
 3 files changed, 31 insertions(+), 17 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 78950eb8926d..94de392ed3c5 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -752,8 +752,17 @@ static inline struct anon_vma_name *anon_vma_name_alloc(const char *name)
 }
 #endif

-#define VMA_LOCK_OFFSET	0x40000000
-#define VMA_REF_LIMIT	(VMA_LOCK_OFFSET - 1)
+/*
+ * WHile __vma_enter_locked() is working to ensure are no read-locks held on a
+ * VMA (either while acquiring a VMA write lock or marking a VMA detached) we
+ * set the VM_REFCNT_EXCLUDE_READERS_FLAG in vma->vm_refcnt to indiciate to
+ * vma_start_read() that the reference count should be left alone.
+ *
+ * Once the operation is complete, this value is subtracted from vma->vm_refcnt.
+ */
+#define VM_REFCNT_EXCLUDE_READERS_BIT	(30)
+#define VM_REFCNT_EXCLUDE_READERS_FLAG	(1U << VM_REFCNT_EXCLUDE_READERS_BIT)
+#define VM_REFCNT_LIMIT			(VM_REFCNT_EXCLUDE_READERS_FLAG - 1)

 struct vma_numab_state {
 	/*
@@ -935,10 +944,10 @@ struct vm_area_struct {
 	/*
 	 * Can only be written (using WRITE_ONCE()) while holding both:
 	 *  - mmap_lock (in write mode)
-	 *  - vm_refcnt bit at VMA_LOCK_OFFSET is set
+	 *  - vm_refcnt bit at VM_REFCNT_EXCLUDE_READERS_FLAG is set
 	 * Can be read reliably while holding one of:
 	 *  - mmap_lock (in read or write mode)
-	 *  - vm_refcnt bit at VMA_LOCK_OFFSET is set or vm_refcnt > 1
+	 *  - vm_refcnt bit at VM_REFCNT_EXCLUDE_READERS_BIT is set or vm_refcnt > 1
 	 * Can be read unreliably (using READ_ONCE()) for pessimistic bailout
 	 * while holding nothing (except RCU to keep the VMA struct allocated).
 	 *
diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
index b50416fbba20..5acbd4ba1b52 100644
--- a/include/linux/mmap_lock.h
+++ b/include/linux/mmap_lock.h
@@ -125,12 +125,14 @@ static inline void vma_lock_init(struct vm_area_struct *vma, bool reset_refcnt)
 static inline bool is_vma_writer_only(int refcnt)
 {
 	/*
-	 * With a writer and no readers, refcnt is VMA_LOCK_OFFSET if the vma
-	 * is detached and (VMA_LOCK_OFFSET + 1) if it is attached. Waiting on
-	 * a detached vma happens only in vma_mark_detached() and is a rare
-	 * case, therefore most of the time there will be no unnecessary wakeup.
+	 * With a writer and no readers, refcnt is VM_REFCNT_EXCLUDE_READERS_FLAG
+	 * if the vma is detached and (VM_REFCNT_EXCLUDE_READERS_FLAG + 1) if it is
+	 * attached. Waiting on a detached vma happens only in
+	 * vma_mark_detached() and is a rare case, therefore most of the time
+	 * there will be no unnecessary wakeup.
 	 */
-	return (refcnt & VMA_LOCK_OFFSET) && refcnt <= VMA_LOCK_OFFSET + 1;
+	return (refcnt & VM_REFCNT_EXCLUDE_READERS_FLAG) &&
+		refcnt <= VM_REFCNT_EXCLUDE_READERS_FLAG + 1;
 }

 static inline void vma_refcount_put(struct vm_area_struct *vma)
@@ -159,7 +161,7 @@ static inline bool vma_start_read_locked_nested(struct vm_area_struct *vma, int

 	mmap_assert_locked(vma->vm_mm);
 	if (unlikely(!__refcount_inc_not_zero_limited_acquire(&vma->vm_refcnt, &oldcnt,
-							      VMA_REF_LIMIT)))
+							      VM_REFCNT_LIMIT)))
 		return false;

 	rwsem_acquire_read(&vma->vmlock_dep_map, 0, 1, _RET_IP_);
diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
index 7421b7ea8001..1d23b48552e9 100644
--- a/mm/mmap_lock.c
+++ b/mm/mmap_lock.c
@@ -54,7 +54,7 @@ static inline int __vma_enter_locked(struct vm_area_struct *vma,
 		bool detaching, int state)
 {
 	int err;
-	unsigned int tgt_refcnt = VMA_LOCK_OFFSET;
+	unsigned int tgt_refcnt = VM_REFCNT_EXCLUDE_READERS_FLAG;

 	mmap_assert_write_locked(vma->vm_mm);

@@ -66,7 +66,7 @@ static inline int __vma_enter_locked(struct vm_area_struct *vma,
 	 * If vma is detached then only vma_mark_attached() can raise the
 	 * vm_refcnt. mmap_write_lock prevents racing with vma_mark_attached().
 	 */
-	if (!refcount_add_not_zero(VMA_LOCK_OFFSET, &vma->vm_refcnt))
+	if (!refcount_add_not_zero(VM_REFCNT_EXCLUDE_READERS_FLAG, &vma->vm_refcnt))
 		return 0;

 	rwsem_acquire(&vma->vmlock_dep_map, 0, 0, _RET_IP_);
@@ -74,7 +74,7 @@ static inline int __vma_enter_locked(struct vm_area_struct *vma,
 		   refcount_read(&vma->vm_refcnt) == tgt_refcnt,
 		   state);
 	if (err) {
-		if (refcount_sub_and_test(VMA_LOCK_OFFSET, &vma->vm_refcnt)) {
+		if (refcount_sub_and_test(VM_REFCNT_EXCLUDE_READERS_FLAG, &vma->vm_refcnt)) {
 			/*
 			 * The wait failed, but the last reader went away
 			 * as well.  Tell the caller the VMA is detached.
@@ -92,7 +92,8 @@ static inline int __vma_enter_locked(struct vm_area_struct *vma,

 static inline void __vma_exit_locked(struct vm_area_struct *vma, bool *detached)
 {
-	*detached = refcount_sub_and_test(VMA_LOCK_OFFSET, &vma->vm_refcnt);
+	*detached = refcount_sub_and_test(VM_REFCNT_EXCLUDE_READERS_FLAG,
+					  &vma->vm_refcnt);
 	rwsem_release(&vma->vmlock_dep_map, _RET_IP_);
 }

@@ -180,13 +181,15 @@ static inline struct vm_area_struct *vma_start_read(struct mm_struct *mm,
 	}

 	/*
-	 * If VMA_LOCK_OFFSET is set, __refcount_inc_not_zero_limited_acquire()
-	 * will fail because VMA_REF_LIMIT is less than VMA_LOCK_OFFSET.
+	 * If VM_REFCNT_EXCLUDE_READERS_FLAG is set,
+	 * __refcount_inc_not_zero_limited_acquire() will fail because
+	 * VM_REFCNT_LIMIT is less than VM_REFCNT_EXCLUDE_READERS_FLAG.
+	 *
 	 * Acquire fence is required here to avoid reordering against later
 	 * vm_lock_seq check and checks inside lock_vma_under_rcu().
 	 */
 	if (unlikely(!__refcount_inc_not_zero_limited_acquire(&vma->vm_refcnt, &oldcnt,
-							      VMA_REF_LIMIT))) {
+							      VM_REFCNT_LIMIT))) {
 		/* return EAGAIN if vma got detached from under us */
 		vma = oldcnt ? NULL : ERR_PTR(-EAGAIN);
 		goto err;
--
2.52.0

