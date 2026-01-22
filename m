Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98E9ED46952
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 12:51:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AFF56B0186; Thu, 22 Jan 2026 07:50:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 505B16B0189; Thu, 22 Jan 2026 07:50:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6A926B0184; Thu, 22 Jan 2026 07:50:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CC5F66B0182
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 07:50:57 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8989A57F1F
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 12:50:57 +0000 (UTC)
X-FDA: 84359584554.16.3B41BE1
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf29.hostedemail.com (Postfix) with ESMTP id 02759120009
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 12:50:53 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=PkeCqsYP;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=eGJevzbR;
	spf=pass (imf29.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769086254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HIMLuVVTSi12AhCgxMX/1m2syQDYlw08cP3yXSHaXxU=;
	b=rz6ILTvrVukbOBdbsHUKEtr2GmoyEZ0wuWwScu/8ZysPXR4VrFlkxVlrYFtGnwFpw77Dfe
	tTKlUghWxuM5cdNQna5a8s9HRys1almle/Mj/jdJDPyWYp9MFZHYQnABvrR4Hfw9bFg7Mo
	Y61LZT9/c8GWNdWC7ccLjxndbdddmHU=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=PkeCqsYP;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=eGJevzbR;
	spf=pass (imf29.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769086254; a=rsa-sha256;
	cv=pass;
	b=iE09cV//l+eXk9Nzh6IqtiDArqC2r/1LLZG7rFctpSmnoSiiqyz8473yluOCrQXiEOL7vM
	3wuYOX2zsuBiT9aqA4n0gw9TM5JTlS5mLLmcnjS/EH0DdVJr2xFKcwC9w/X/0ZJeSRejq0
	9pNojldF093HTJi7be0xp2Lnn0bCKPY=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60M0lgB83264931;
	Thu, 22 Jan 2026 12:50:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=HIMLuVVTSi12AhCgxMX/1m2syQDYlw08cP3yXSHaXxU=; b=
	PkeCqsYPFrhOi4fbnVCeIZNlYkF4q6iCpBSdNDYk0XjwVwZ7ff+X3CIyHDAc7hkt
	RBJcZBVw0StQeGL74UIBpY3XxByf1ntDDqTd7ap3WwlEEy6s0ZLx3fsINgCNvfXV
	auUqmkyTKTKXQxR60ZAZw1lYUeHhoCceOCL8xI+bc/MdBOY7kIrVFUs6M2D3U/Qx
	COjxAHtB6eseB6OJTsgsfPKsUn/mL/Wj0+OASfHOZV7A6JfV5CxogtZt/Y2Yu0qV
	wjleu2DLBtb4TSCCIxBuP/JZ4nNrh1qcO9ShHkxRGhglSByviidE7gIf3GFpCyTU
	dY+YA9y4CT6i65RfwJ2PXg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br1b8fntk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Jan 2026 12:50:35 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60MBCOIk022532;
	Thu, 22 Jan 2026 12:50:34 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011017.outbound.protection.outlook.com [52.101.52.17])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vgj7pa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Jan 2026 12:50:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=os/wMUio8hm5j/apRYgr0OaTmkewvkW4zJrnlBhDu+PFXMCllfi36BDALJNpPUYFtZ2k8Bb/pNwmfaYxrcmppVIRahbE/uQHSDOFBwBHYslDa+nG3Pe6r0jKw0UmICTU/M+earoUnjphzqgaev4qi5fxNxpm25eSR6K2WvF8MD0CblmkLXjFfWIMhyhi3rp4MUaPM8v4av+5Fq4+IzLC4jbLRThKEnt3kHUPiyqwD47Cy1M2fRxZ+riRnYb6Ic2IIKNF47YLQPnvnpmaTnwnJGOUjTDp11+Jmaser7glVNHya/nwsghKf175+hZugRvJBlkZfvUHIrvP9+6P9Z0JMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HIMLuVVTSi12AhCgxMX/1m2syQDYlw08cP3yXSHaXxU=;
 b=gNQz3p3mUcxSSm2ac2kDEFdEwH/gS4rAXqt89KVL9HaKS9dSPJ8tLfGmnYykrRqslcT8c36f4MYuDXuKeTnd9wRXWAEX9+szIANvO764rQx1NIey22VNqfSisQC/64PGbVjK/CZy8py5G0XwEZyTT7pOCDFoC2jQNy5hu3ugYMmZjaLyCckDFCJUkZm5KGhyV1S0LX+YJU8LdMznmfEocUU2PQ4wr0AqwuMJOoyeagpXftBJXRPfO2ER1IA+bDvbFZSpsMwCzHef6laoaXirlqzwkFtJ4pQ0ENuIpbYRooY0CVMdwwFyQVuiEeqCOeAvbtddtrtipkWG0jK2oPpNoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HIMLuVVTSi12AhCgxMX/1m2syQDYlw08cP3yXSHaXxU=;
 b=eGJevzbRFG7KXjbXaq4opdYQCfO9o4zYyPFcYxPfqu6ql7wgULM1vMdQOlC9rRjwxTHBKXKvd3GixPh7EhEHq7cbXfvkxcxlPXP/cqCzAa93XhF2E1d+2hLdlFfAEBs1TCQzGak9WqPqD2GaHffGrGBrc97XhSL3ow8B4uzFSH4=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by DS4PR10MB997622.namprd10.prod.outlook.com (2603:10b6:8:318::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Thu, 22 Jan
 2026 12:50:32 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Thu, 22 Jan 2026
 12:50:32 +0000
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
Subject: [PATCH v3 1/8] mm/vma: rename VMA_LOCK_OFFSET to VM_REFCNT_EXCLUDE_READERS_FLAG
Date: Thu, 22 Jan 2026 12:50:21 +0000
Message-ID: <f637c1a5c9ea237aab598bd8885df48e21497635.1769085814.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1769085814.git.lorenzo.stoakes@oracle.com>
References: <cover.1769085814.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0508.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:272::10) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|DS4PR10MB997622:EE_
X-MS-Office365-Filtering-Correlation-Id: 95830078-25da-4283-aa24-08de59b4d42c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?IdHLM6u3DWd8v/vQvA0P/+m8jpGOiQBL92uOyZQlpxRhkQZbsm/0YK6iBwcc?=
 =?us-ascii?Q?Smy/gU+OQbdNghjIuNPrRwJ8JQtDGxl+qnMKdcS6SejTLXS4qp02Dm0v/0Oy?=
 =?us-ascii?Q?FHWUcFEtvBCv+CsaSMNm1Z1vb3Up3Mn3e3HfCv6iRCCg9G0KQzpyGJGPSr36?=
 =?us-ascii?Q?YOdDAiXa/WshbmXLP8qiqaeEOA3YdGrfi9i+vBiEPxlDFMe54/cVQ/EmjVaP?=
 =?us-ascii?Q?cNnRarGTeXD0X3vbvwzlu6GiR1cKW/1EEcmSSUijwxksYQof04Ryam3U6Lhv?=
 =?us-ascii?Q?8V4qVKsUVpM/Es/HyCeVJvjYtCyrQjOa87/xJUdNxgc38jrtFP1noV/0VGBO?=
 =?us-ascii?Q?wwXoOTodjbXWUmi8gblUUpIPfDQDd/R/pvUwNnjypa54UwGobRx/sErZyIPp?=
 =?us-ascii?Q?M8d/KuGHypPkAEwsMbAroFMhDU4S/roy6+IBKhHo+UTGmEcAxzOZiJGUP4A6?=
 =?us-ascii?Q?TUL+QnAEuinYCrpoCFNQHKeOzbjdeAqu2pSKaB3i/6f7MtzIpwP3uCv4gVw9?=
 =?us-ascii?Q?TE2cLlvhPp9dYzwYPdLZzmB/pGslBpKyjX55OjWprMEY0X8Vleuc1MczE7jC?=
 =?us-ascii?Q?pkaiyAY43dAQaSj5qNpnzoVXPtxDvs6qqbqTSN1qghJvY9S7hGfL/EBfGFEf?=
 =?us-ascii?Q?nUY62GWcdxxchQZU80ohLHTvcTlrPd4QRAVyJVXSdwbE91pLvdxVJSEcE2V2?=
 =?us-ascii?Q?JuIsHIfsj1SR84r2BkyVO1W0n+6xEhYrJrXtgNJLPsVpUe/3KjPfgkyTDFqm?=
 =?us-ascii?Q?f6aod2htfRJ6JNgJojK4JEZy2nUZw7TuhBSTig/Lu8IbPam8EzawZ89dujRF?=
 =?us-ascii?Q?kV1O8l/9HsHbfrVBIoGbR4jfp2KTeQjwZnfdC2iLYqq65nZye19cb2TTi+tv?=
 =?us-ascii?Q?ZLm7jKSTT5AfJXdRzHY4zOmo/Rmshtk5K89Rz8BYH938s4nn2QTvxKKzJHoT?=
 =?us-ascii?Q?I1iF6v8wS0uE9ux2qqvd3lKL9IE/Xi3zU7pvmi0ehQl0132C7S1CWmMsUjwC?=
 =?us-ascii?Q?SdDrwmE7YvOaiwa8m1cSPJxkdf6Vdnq6RXHig107Dhe9LIU+uWkHxaOpH97O?=
 =?us-ascii?Q?StqdD9wHWm8rcc6jdhIbTbxmVniST0G3onfj9I38gNzWmztQAYbOdIAbGYm3?=
 =?us-ascii?Q?gtx2oZbJgF9UzYeuIi3G1xEqbfLUAMVGAesLGBu7Py28j5qozVgnkOU6JKd5?=
 =?us-ascii?Q?JSiToq/HAYrYnGXAoCIxg1j9dDKbmzsLSIAT1SpoFK2652evQsPedO5mVswm?=
 =?us-ascii?Q?feco/MshDR6NNbwVue9j7pK6DtVWJHoIUb0cjmyizBnMFQEpGnWBIEgPncIH?=
 =?us-ascii?Q?01AmCFF0eYLYGc+MGL1xqkf5xxar1UApGgXKGKxeHkFsffxX5bduIWv61WfP?=
 =?us-ascii?Q?owJxh5zaokp9cGSZzNMRLQWZuR8znUPTmPslY1ML+Pah0bN1v+YcwtM55GuD?=
 =?us-ascii?Q?utxuC9XEc2EyVdhOFWshW3SeOY3JWWXLaZ48+XHda6FymUSawQ42drdL9Y0n?=
 =?us-ascii?Q?WWjE3kDYtfxqehVOgzaZm/1LtUmkQ5qdrw9QiM9dLdTejMhiPB3tQ5qYRRtb?=
 =?us-ascii?Q?n/Nt4ZcIObBRqYMP1u4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XflPKDO89fcA7eaC5lOLBTU8eQ4RUXtJInuNe0V96ff15oJt/1kGtqHiSMva?=
 =?us-ascii?Q?kFegEPnbjUNuq/hdF4xlt5UY59wSzsSUF44MkiKQ+bjEg3IWBtXdNuF7yuLv?=
 =?us-ascii?Q?0gU5NCPssfPH6u/wybDD/gCp+WIDe0bRhMejivVRsFEyg6ZMLJ2/T+76czKJ?=
 =?us-ascii?Q?70tc2f/2g5z3fCwzkatrbrrBOOE4fpmCnWUDHM6L6z79H8k87F0s6YcdWL+Z?=
 =?us-ascii?Q?30Eu56fhhweb7yFRXoQiluaj6r+3MsjKGPIAty7RVFlm3TXrRT50SywUerIa?=
 =?us-ascii?Q?7sBNcmOj9G+L+G08dftA2nwwYbe2etd/oQH90pFanlwr1+qoMbTFIhb62rTe?=
 =?us-ascii?Q?tCJYbAh+zDpmmHUbFcA47lDs/9g0V4fru0GrQhrC1lWo7a/Yuee7bXa2RoU/?=
 =?us-ascii?Q?4i95ltd8b/1/vX+5A9fuW8jCb78mFMcxdB3EAajlMUY0+aNhlQ0zQuTZx/B+?=
 =?us-ascii?Q?moubCiF8FcBlSRMfrYnfF/VIfWBj04h3Fd1eGxLlo5FqL2iD89NVgZHcOURG?=
 =?us-ascii?Q?7VoC6zG7eSPhPZlsHwDnC6h4XvM8zN7WciCCErmNhDLh0sL3/eY7W1toGJoE?=
 =?us-ascii?Q?BrO3joNtJZbxB/R6bfoLv2ouWKSgLh96D8uzNyquKa5FUh5SRt44km515gCz?=
 =?us-ascii?Q?Hlmf2ezz73gpkuEaTiEHSr/TJKlLZx83uzD9okR0t11udy4ECpRnqlRX4/C1?=
 =?us-ascii?Q?ILgenT3oheVqoc7O7oiCSbnobqvbvtYiTFgkni7eaDYZcxlEyDsnJEzhp7u7?=
 =?us-ascii?Q?TdTPZNIBL8bLqfl2LSRRFIZv6Bg0iXysbUL/p/gCEHWQi1Dt2MRI/CeBACQB?=
 =?us-ascii?Q?tbb+/ukqCmWeWi0MxpRFbR+kbAtJYpuODooKt8CchzsSmzITX//t4+6bLD1D?=
 =?us-ascii?Q?RES3+J4cLZvr4NMyeOrMT4/vkGwnqRiXrU3+xIbjSpNxgz9yxPN60r2BdWsr?=
 =?us-ascii?Q?ebkVagXP9t5sVdCpKXzbvE/s10UnNFKWeGfpR99U3WvaVtm4u9/nbwM0y3qA?=
 =?us-ascii?Q?F1eMMCq8UHmmLer3iwpD4u0vaR430ysPNO7frw45IOWOLCUvY+LkQr6XR3fZ?=
 =?us-ascii?Q?36Ex6+iw2HlNQRyY8iMJhnmTDRx2uUUix3jBHCVFolSnO/JpIVdrbVXfl6FA?=
 =?us-ascii?Q?lTziNyKQdZ45019tGeR/dGnma9YB60bQzO8wn160erfZfgGeiG6M4/TJgL5Y?=
 =?us-ascii?Q?B/35Gnqhl5YGnh4GTmxuIypV+rlsg6wEQOsc12tXbEb1rC/oM0kTpP6U0dKA?=
 =?us-ascii?Q?U5cXtdekDbATkn6AreVa9nNJnWyqyg40sz020HZLM+1ZXclW1apqmJAwtF00?=
 =?us-ascii?Q?CKoNv+b4xGc/5ue24O7FXgpxmxI52LEpoJYU9gV9bT4xB+APNdeXciJpL8vf?=
 =?us-ascii?Q?UIdGNXhLQGefV4vIf+s2HgCDlfpM57UX+OrpsO9FPvgHY8WYS1djEmO7dq90?=
 =?us-ascii?Q?e6m2bqyLVbo5Thys9YXuBDkksNlF/YfQW4/ltRZdkkmYXCU4dV7/1mLfxA9f?=
 =?us-ascii?Q?hHL0mYmBYzR5WcDER55cNNoTNU+7O2cBTbmOQLxWatSID0njrB+hfBMtoK3P?=
 =?us-ascii?Q?al2DWPpjTcw9/jdBQhXNNexqWp04BVz81/KQOQcyE2ADzSgeiZ/VjoWUyPWi?=
 =?us-ascii?Q?tFm2G4rFhFqWa1toIGapitS7h4iYjQYZim0YkhQABbFKa+dok+Aq7SogRkn5?=
 =?us-ascii?Q?eQU9gTtRJtreY/r85CsDI1sChnkmnjO6JFd+4HkWH9xEYDogCqkzsUA8T7uG?=
 =?us-ascii?Q?He5SBgiIYnk2QLwL3/QHrfImBAjnMRA=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	s6E+KFWuTfJDiTx+X/S7XUboUmHPaq3djI4S08Yu0DVoDKCfwRaDuhHqyqyo1jwmoSrmZ060/XVzyRfLlHQH58OMSKlwY63hvu/k+z0nlLTz0DUSc4/+uqnYxdFLcM9a7fI9dq/aGegYqovpk88QQ1n2hMh7MAeaYBdIhHJea5FVsqB625IrO8xkBM4PcjLIgpvzCnB/8z2crizFnxCePlt54kNHi14bttZAgpZIH6QXEUwkVeukq9oErSPLloU1ULHiF4l5DTgDI8L4yxLvioSPBId4SHhhHiyFQkBFHvqVUY16uuPF5bJyOZKlUU3h9BGHMc3GVAyNcNFX6fu4VjBtv+ZOgzI9RodgxoQdU8vVpv6lKYHVZxMBW7yfhnMoNJULcHOBFOYkiRXMU+3aARqtfDqXS0hUTBzQjAIZx6wuDWIbWNVs0snEbPKrjusnnPiH13+PdhV17XOaLpcYEG3+0KXvjloQv+hhiCncwj3GJ2CANab9tJMwRnU5zLnA1If0kUpJHUth0HDK7rbeJ7a9xi86buX1aIWXDic+As0RfQtoXKkyWNZHCghNbOUthJyp3tN7rXR9aanSWZSRMk4LZiAsXIvqcRgQ53zJKfM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95830078-25da-4283-aa24-08de59b4d42c
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2026 12:50:32.2764
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sHGA0emT/yeLB/jLf0xG9IwXQnLtLzwYtzb9WOdnzYBtrMNuEVJnV14RmMj6tNgXfMXuFOcB5zC1dk+fm7RNOEmMW4U/sN5uP412zb+WgVU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR10MB997622
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-22_01,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601220095
X-Authority-Analysis: v=2.4 cv=WbcBqkhX c=1 sm=1 tr=0 ts=69721d1b b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=9TB_ZDaqR0cpHShmxdgA:9 cc=ntf awl=host:12103
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIyMDA5NiBTYWx0ZWRfX814IEdOxyhp5
 hozr4iCF1jztmw/G8m1vCWqfL/ifxPjWbfh1LQzVD0dJEFOPtRGZGRS68tbX/twY/TO50TNWLFN
 ZO7ONFZvYGsi8MLGUZfC2HD2vmT2CA9offkROG0aHCr3i3tK+3fUp0tYLRB3Ez1yfydk5ViSP1H
 WDh9QewQ5pdzsf3ae/6N7DxJPzTbIbh5m2g4mWgGOw0ngTfPuVVCcdLdRzkP7xLpg8ElUfaww/5
 7xsQXCGaYabKfxq+j6ISNVJM/3sHAx8LB8LhyI4ZKoQ/z3gSB6/+80oo+if/W5lHlWWnnC7Sj3m
 bPLfepx+M+elVgAJZRIyoL5l2W1lG5758XgVSrTsMiqoOW2snI8DFbW/VIo08ygYbSPGXME9lg8
 IIylDV201GJBZhFfLcdbPv6yRcRC8v6WfxSWYiB71WvyhyMLoS5hXdWOaPo4Hpmm/kJzZJeQTQw
 KIOkS8ua8UETTeSYe8KJXKIfQt3iT1i+ST3lZZqM=
X-Proofpoint-ORIG-GUID: DkIVRS7K9SLjNYtwheL3U8Nx2nSF834-
X-Proofpoint-GUID: DkIVRS7K9SLjNYtwheL3U8Nx2nSF834-
X-Stat-Signature: f7n6ypo38r6s5wgdpt569bptp8t7mmdy
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 02759120009
X-HE-Tag: 1769086253-944344
X-HE-Meta: U2FsdGVkX19En/SIrlthRxCqW7fPmWDDcKOPGTAv3h7ZrVfSSiIFFqEk7k85FOrWwajqL8gNEwOQRyNlDjNDpbwqKbA9KXlCmwWTNnoiJr+3zvAQZIdsm9OMIKczZs+hY0udCVrZKJ65T28u+64rzNkE21KMu10Tj0EQBTDTcJmzoo+gXADmSHJ+vWwo60IdaS21nOgJ3NR3/lZHNeD2pq5mO9vdh7vf32kgu/Odkq2z22JfDQa+yrbfhU8Q8NH8G9Sr/KefPkTFvg2oUABa0jhS+Y+aPCfbiW16kK8j+IkaTyshdoMgMxmtp+64vNly96Dpg6CdICapq+g5pGI0e5M3wma5ZM8j2Xz6x6AYldUT/oXZmlxxA7ShiGV5bAhnIbVZ78jft4CjQukwe+p02QM6xkV5yCequ0Yp5Lm6NNIRuU6T/qzrRdi2uSLV0UGlB0DlRUygRV0nT08aKRgdc9id05JVauBvW3yXGwszcKKpM1N3A+e9lJ+hKctpceza9oOep2bJrtLhUdF4Ou9ib0zylRmpy97re/Ho9Z3hK/01KxkgBxiCLNlr5h1M15Dnu/VK6us4AKcHE8b+56lfz5thvd9QSaP0aIxV0+V9v9oSleL/sU2QGTflww9upU0BOFe7NeB+zUX/9S7r5X6SBlqNXExkzn54i8VOgUXezh+4RnnkUDQ3KtiKewOWDpbNA6LF4EPIKYH98JiMBBTOprUMt6QPUkk7LkYxW3f+KwKuPoJTmeZhIKXYNTxrV9ANSgBFUCFEoLbJ4rPkDys5wDFyCKy4B/rsjEIULF3v10JFGonStv3SCsQYIEhTyb2O9bURgQy2FWNkLbuu13vYMuQJkRPFWGb1b8SJFXNscNb2qWhKYefZXf7Ka6QmEG/OUwkJ2QsVRvx6dXk5BkGROUuPH1rXIlk213N2o5KYZplPpCMjgdAsJEj3qQY1l7liufrBpzxGCBMqAYToEig
 AphXL7Hw
 vxb3RkUV4s2sDPoWfEUE6yMDMXnzOuOKBQmZwzt82ZndfdU2S5qNi0njZfuR7ISHpBWvMVn7dsR9g4aku9H9LYTSnd3jIVbyoJHX8zoeK4rEOAeBY7eRKEwwCbd6w7n7TW7h7NretSauNhRCNBaHHnN08LX4XkXBt+KDP13ea2h9REqqfzedAmQnQgB+580VXl1sLAb94W+iPrXqwz25WLKUmwSY/XEDXfXAAnGGpuQ5FD+DSQIaPY/fugNG1FSu27o3KHyeAfK8A6o9bZoGZxDEg73xot0UobFjHck74JLWXhccpMO8twWE60UOOXFL2FKBHBkpbAu0RgVOW7P6vqgZducayU2sYRtd3M49IqiwdexGZLJYLwIpDUba13BxACkLpEumUqYF+s7MsvLI05WY3ia7TUuyGE9HLq98RvBw0kjDnNt7uiKoPuV00PcDehScEa4VrhY3scB3qGQb/rymJ8WgwOBlLKlQWJNG4aed7GbUooEBsOC4HIE9VI4fOfe9JcXnU39w8wr012NW/1piLo4ZN2e0QJ2AszvnG7AZYT1/x1vaNDAU3vU70ykDfKvZYl9NnY4C1A8mZsQLZjUIPOkCg64dRlqS3VgR6BbP6AOPAPFhUbNHijO9AdMH94NSiSeN8io011cUbQj9YC072I8uebsf7PifUpGaxO2oQpuK5Ucby2hV/nXR2DJtfcxa6y/fIjI+Kgu2iHHGFgioVAtt8e17uIoYqkuxpDxE7urWshWsiwT+MSh9B4B3xqF826+yjl3I/vzaVNRbTBlyxVHj8hIY/9Z24
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


