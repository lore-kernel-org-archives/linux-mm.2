Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AFAED778B1
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 20:13:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 608D56B055E; Fri, 23 Jan 2026 15:13:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 551AD6B0560; Fri, 23 Jan 2026 15:13:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E8866B0561; Fri, 23 Jan 2026 15:13:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 142FC6B055E
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 15:13:02 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C76338C118
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 20:13:01 +0000 (UTC)
X-FDA: 84364327362.08.547F887
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf25.hostedemail.com (Postfix) with ESMTP id 74786A000D
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 20:12:58 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=c2IFA8V+;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=SH4QMJll;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf25.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769199178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3p5SP+1Wriw8mDDMWvOT/aOkh2Wtc/2J3Ux09Vp25mY=;
	b=SSopWaTgsuhHPnJ0tS72oEpABOPF5Q1YO00/Oqdbd6ZRUpVZgmTKtb1z+kkgsP6d+yDxsc
	c3Rj1V3poP7QuMxLfz3Eo7Ie9sQIha/runuGrKYvYhx+FjGtLK7b10tCmXxuhZwi1aOgW8
	ia+jNwKm6PRRmSJBob9w+d5FORwDXa4=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769199178; a=rsa-sha256;
	cv=pass;
	b=I//hagyhkMWCyIT7FKNRqhIx3Ab1T43wNwMhEa3AMbcrO/m5Hhb9DdQ3Phc6OS0/OdQy/c
	D+XhVR2VwI2ptNyPha8e8pDknwLZNAfiXC6s0M0k/8EQXDAFdLpkrGQXYsVQ82MAeRPqJW
	dgSk3BjN8Un1DSxuSI7I2wdT2u4G/NY=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=c2IFA8V+;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=SH4QMJll;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf25.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60NEQHZ62405273;
	Fri, 23 Jan 2026 20:12:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=3p5SP+1Wriw8mDDMWvOT/aOkh2Wtc/2J3Ux09Vp25mY=; b=
	c2IFA8V+69pmVt2MOu9cjeIKEdEfDlhXiyJ/0CDT5APzgzv8FwYuRWd5MR4k8b9P
	mgcc/Ayas2qEoRzPmSrXDFLLp1341sfDDjZNtoFvX/3qCZe527YubnNEww8tNLvL
	+SctbTLvVlb7bpgmk7+EGOl2T6lSBg8kBQWOZDjPkRSgsCLFhsMp7NRoEUXmCqWs
	585Guwu85X0NCUMeyf65IstwJadWe6W6fwfT4enggGrslOj5DVIuA12ZsP8Vg1+9
	58IVIW51W8odlfCnlJtzSKrYgnMwf6bUR68Vlfv4zBG593sqdHMaxV4O8mIvuC/R
	gI94Bqa5xkYczB4wPkdDJg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br21qk7ch-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Jan 2026 20:12:46 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60NJ0iOg022514;
	Fri, 23 Jan 2026 20:12:46 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012024.outbound.protection.outlook.com [52.101.43.24])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vjmh1w-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Jan 2026 20:12:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cMnd0hf63zDm+EZ+4XHB5JVjPQirv9SipA8kTJsoVa7lcawsX0hctiq9mrtcwOPsu7rPwGsAJ6CzMMzADmkRfpuvMPXIUMX/LKcV7vguD4IlPW8PBLWwSsJHdiMfDi0mp+0jO1yBUP4FWzkYPVcdtcWE2QdbijdlyGkFsgaZ6pQkd7DFEf6GdAvVNAU5Kld1wZYyshp4jkiWA1c/9hOAQm1YRyETzU4k5jZcAfTmYCR+9W6hNICkkETtWjOROs85x8ww5hylOeVPSxheY9/2rd8HbXWm9d0BkaoxyDGYYihECGC0EOhu6z/aDkdN9YkApLEK4PUEFtemKRq5++uPQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3p5SP+1Wriw8mDDMWvOT/aOkh2Wtc/2J3Ux09Vp25mY=;
 b=EmxmsfLAe4b3DrRamuf0GenrOEs0FFTpCP8FHsg6OR0//D/XWEwZNClyS8QLseSNihnHQXbcc9Q43vCq/DakxyN2g7GSZg5SWqe0NUwVUR22zmbiGZY5FhGIFw41A9cuqdGz8h8MoAF9t7vk+JWurHQ3uOsT87r2k2gaGS4DwRGEfeJOu8zBYBe/2cE6CEgRbKWq9aHeb9s2ZRQE32gVC5R+v6W11vHrwZOUx43vJ+NNhhC/cw8qOk1KhKeuneK/MZFadGmGJboy+FKgtru0JFCowJlB1gIu9MYg3q+XO9DoQ8qaz1oS4i9IAXTTVP7/078Ii/LVhtidisXXijqxUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3p5SP+1Wriw8mDDMWvOT/aOkh2Wtc/2J3Ux09Vp25mY=;
 b=SH4QMJllTEvPTyKbOTUrVilxPgyx1/EkSQqRkszzLu36t+RusL482C1N14kYq7/ivpsI/FRdGK1pudJQaXmNzqPkLYE2byigDZ/tnvLfSgk2C1+yzLu1kNt6U0VfoFyjaRN7jdHKDS1rS6X4Je0vWxcBqe33pdicllO3NPVeaHg=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by PH7PR10MB6555.namprd10.prod.outlook.com (2603:10b6:510:206::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.12; Fri, 23 Jan
 2026 20:12:42 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Fri, 23 Jan 2026
 20:12:42 +0000
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
Subject: [PATCH v4 10/10] mm/vma: add and use vma_assert_stabilised()
Date: Fri, 23 Jan 2026 20:12:20 +0000
Message-ID: <6c9e64bb2b56ddb6f806fde9237f8a00cb3a776b.1769198904.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1769198904.git.lorenzo.stoakes@oracle.com>
References: <cover.1769198904.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO3P123CA0008.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:ba::13) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|PH7PR10MB6555:EE_
X-MS-Office365-Filtering-Correlation-Id: e3cd37a6-1908-4b44-312a-08de5abbc3d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?WNfSlVLwEhHlwYcRvmCahyoBqIsfFxCV2nDctFXSKTIJhrJE/geT7DhSFuZe?=
 =?us-ascii?Q?NwxxahnwWlWupxkcYkQRQzMOLsBrj7XXxF59FGW47dqS8DGHSe5f+mh4GsCd?=
 =?us-ascii?Q?v2Qyfl8Q9zn7JUmXL8UGRsXBr4sboxkt48BdSS9UMS7DV/GlAZFiJH0ZxYLV?=
 =?us-ascii?Q?rGvWt71TkoF7Yd6MhyeBQl6GJVxY4id7QlnPhm3O+KS/ZXX5nnApMcmxeFOX?=
 =?us-ascii?Q?BI7YSwA2UCI/oSCR6SrZqkUzGUcpSx5W3gnSSVk60FDn1YlhXKJMzUYUCuBE?=
 =?us-ascii?Q?iEO5ATGdPSivSi+axHClHAUhigCRpsSQGdeM3HIGJyZf5dXK4Q5NBy6qTyOZ?=
 =?us-ascii?Q?fW0DqwPWn0G9b9hSEnBL8PGy2FPNXqdwRW60eifdV9+cNv+RCktXjDBxpX8S?=
 =?us-ascii?Q?5OOIK8ZJVQW+PVrRqYoeObsPFMIZH1NdLU5gUhy5Gi8/Iof4O57rG5tIH1SZ?=
 =?us-ascii?Q?87W17Ip3DQ0IHkvPQ2a7c/TzLwNV1MbLOzj/O/hWssZN1g2QCoj8mRuATFQE?=
 =?us-ascii?Q?zko517N+slvhgJXATV3fw6plgDrkCNSwtkqEpXdi3kr/h9LqydHTgxBPvvbW?=
 =?us-ascii?Q?l732s8EihAmM+cIHwrEVm0gzOKNhsrEU/MGH1bGs7IwJ8OvlbTG4NyC5ggRL?=
 =?us-ascii?Q?yPlWCDV0GP3k4SaNfpNkzoYH+kh/mx7I7Ui3vLfVFUXUJKtNwvsUAyLeLSMx?=
 =?us-ascii?Q?PblmVAt4WP3SP4KlT+HcVgHZGjWBH6XS5ZqA80IjGIYO9MKt09SvLHLO3V9Z?=
 =?us-ascii?Q?AZQjXqJ/CaFHmcBWT173b+NuwNTG7GquIdpQLCxJqvrK2Rb6NdrAD9JxB1ap?=
 =?us-ascii?Q?UM/QK2PTpaLgBlCOATmACfZtLSTxbCVSVPijXK4aemyX9YJMpJKMBjnHyKSR?=
 =?us-ascii?Q?lIrYleGiKMw/K3XofAC0vizHwEEIwhSUUi+fqPegxlD4obzBGjk3HbKx8csK?=
 =?us-ascii?Q?9q8SVd/q4NGE0L01d84O3L2k8sZXnzR+RBQphn6XH8amSZ4hgQX/eOV3dVQq?=
 =?us-ascii?Q?acSPAIxlhJTtwpWnSsPQVu+KGUfGGMjrVQ1LxXxb4OdfHSBxW1tsFb3BP1cP?=
 =?us-ascii?Q?4hZTtqr1LljPOIFAgOG84TL4uJu5rc9KFBvrS5WlzBVjWT3d1QPkEsK8HEMM?=
 =?us-ascii?Q?doqltUCWh3Q/IM0CIYo0Td6F1UhyAMxqHl/601vkHuHaH2qTvTTKrhWK+/p8?=
 =?us-ascii?Q?EyEUvu5RmA4qkz4T3BpCb+c+9faVpPGx9l81w7N3Nbv9JTf+RZG6QuVIGhOS?=
 =?us-ascii?Q?kKphNv0oygrGarV+dzcbgfMftKxFNPH9pWEZ5qEMIBOvubPJVqX4WFiUIdcb?=
 =?us-ascii?Q?ISJTlMaS4Nvjste3nWtORldjYhZce0SNbHv61ey8A6vJzav5kAYvJ//tYf5i?=
 =?us-ascii?Q?mqO97kiEPTA0zMNfuhwR2wo5DfjbKaHgoF8NlNMD7Itaf+wwTVvN01FSnpGM?=
 =?us-ascii?Q?fiIXjnRrnGt1mN4mlcEr40jXqwv2Py3do3gLfLsG+r8CRFpxsnJFtmSkJmSB?=
 =?us-ascii?Q?MuNkro0qoNFN8e/t5C5K6h1ZqNJOoMRe4wwcVwAoij5cYlpYw+94lgppYWXR?=
 =?us-ascii?Q?9dPk+It5jXh0fa97j5w=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BlgRSaAK/PYBTEwZ2VWaOtXjKeABTvnHnOK5TVGRt6PXBtLJ2oDNcvuAi8x7?=
 =?us-ascii?Q?y+PLgxqFGafJ14dQdtjfFowPiGPDXGsLsCfdZZB2tGtEQ3GtHYl87AB1dIzD?=
 =?us-ascii?Q?KpzubuP0yOPND9LZdLqWCjH6SZ+/s0gq/9/CT5roY/PKB97oRLxSkrBUDsSR?=
 =?us-ascii?Q?FpeFsCRNpwl4qnAlbEoAO7IhCrRCj9s6ahNfZfLr5yHFJri1YSKgaWJyuofe?=
 =?us-ascii?Q?t3j1+aRuWqwzL/YNQPqWJrQgABJ7d+uWadEA7Ov1BXnJDh9UFkfqDJpy6taq?=
 =?us-ascii?Q?KBju4WX+eSnMhJKdBdhXxdtjXeTEDYhWkILPVYzlNs28ukrBF/w7uzBQ/1Ds?=
 =?us-ascii?Q?olYmV+kFAXg+OpAW2A9RpRh1auvHZumRqiOQy/SY/1lXoVTUtHtSPntjUUBR?=
 =?us-ascii?Q?9ciFIRkF/VG1NMXs24ORtC76keFKk2mjIRSK83ln+Z8YjhJgFaSs2owZXweO?=
 =?us-ascii?Q?eGooHmlwdR5QMB5CzjgnaQ7vEw7qu+IS5dR1mlBUwqEkKXVEz5oK6e+v/0/R?=
 =?us-ascii?Q?2PALI0utSMGMM6qXoeEn76i6CaJ2Vek2TnJ4xNnVma+3bdOL2x7AYoVyo5Zh?=
 =?us-ascii?Q?VdhMWPBjPqi/LLgipVrzmTp92QITCG0N7u67X/+Pwpafcb+PUIqPeguKP6q1?=
 =?us-ascii?Q?YhqSHdRtukIBf5Y5EGx+Zyh4vNifAn+DGc5bch+jEOuUByKeo1WAthK5fUC/?=
 =?us-ascii?Q?q6FFHjsf0eI6sbLy3IOjBKo55QFoihluk+wRwlhul7bh8nFQ6EjKt8wjLopG?=
 =?us-ascii?Q?HwAzOn1sHOh9w83tDjlzlVNEZ/G3s/I7RJ2lP3oEBz3XRYaaGl5tC18Yq3ni?=
 =?us-ascii?Q?mJCAmN1T+sZ5SxKNWsMLMfbSUi9iVMeF5LV0eqwPkxuarNC07DFczRKQbd+S?=
 =?us-ascii?Q?sxzGubfG+4wGRR7XmQRHREKwn+hvTk5jIHKzpxndPwmSZxriFG+xdZAHfLWB?=
 =?us-ascii?Q?yyMmm+5k1G7coyD5X/uMTYIygvjdVa9zMsVAkca0bbPZLn0egAR/4TAIq7fM?=
 =?us-ascii?Q?Uyl+J3/284DUxaKgSNzNPYF/GA/TdScu1KqDM2Jsu9W5WCllIx0BTQrNo+PB?=
 =?us-ascii?Q?ITDVkRy56TdGwSixw809Ent3LMUNceFPRcz7x49kj7J7ALKdn/9mNaWS0RI2?=
 =?us-ascii?Q?rAcJnu2eKAaFSSmBLp6Qy9FlSu/+Sa0kprqaskOiBwL8oBCC5ihoQi62iANv?=
 =?us-ascii?Q?6Pn9AV3Omv39OctHZvTbyvIM4HpPm+f0vFieJBSU6wkE293fBc7YcgciV07U?=
 =?us-ascii?Q?nC1ZZlJX1MgTr6BnMjUyufMQZhUB+gTx4l3LI1eXM2teEXkqRYeTRZk2u6xF?=
 =?us-ascii?Q?EPkP3oIoi1tabAqnj1kqz9JD3xnWpY82ij7NGTBg/oWY8T2ZP3Mdbuwcujd8?=
 =?us-ascii?Q?PBGrXDDy2CJBtsfVSkToPm7IpSY4N2XzzuQFeRlPeU2vzTPTzFgPNWi+pSv+?=
 =?us-ascii?Q?ukDe4MlX9sHDo7hRHd6WIomubl+QoYqpuQ4jar3XepeYgSINQPsHa5qPwJ0L?=
 =?us-ascii?Q?aE9Vr7IF+GzCASQ7DAcVcqVR9rSoesLdDoCgPC2GFzFUJLCnI5xDP8FhX7JW?=
 =?us-ascii?Q?LlSXchiBv62iuPD92GSzV4FLISrH6xUjLofs76IrfHo6NZBSH+D5D/6wDmtA?=
 =?us-ascii?Q?18gNfcUFSWfuoqrjSIQloRHkmzttpcw0XRsrMQj6ssL4yBlzyodZ17ReZAW7?=
 =?us-ascii?Q?4WgQAOgPQTOIIhEdAs4bMFypALVoo9nP1T60fwoum+evBaKUPY6+nLBFq73E?=
 =?us-ascii?Q?woj7X1BAKBszGzQv+HPtTk8EyYOTfA0=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	etIi+sbqrEOLgT8xmc4KkpCxN2EAcSZV1mgFgWvGl+qnrC6rfYfsjWzAd9LGBc/oszibE9rYlQHu0HVifdY7zI+Lgj9YMnjgntMM9ZIbxsMI7FHOqIlyEjdj4yjHuOEXyXXlua/4BD2TZeiHONL3E0gn5ScL8D5ya5tZoXPOzzMqvXTHSJv6waCypXD+/mmPm4HHZ+2jVBejkmwYD3015yYudiiIzgNec0SmGpKmxbj+MTvzIBiAssnAo8JgyrUiVRQc5W+v+KFbmw6lHYwufUQuVgqlPYgZNoHvPgLldVdbJQzTroBt586O0N/rWN9W2K80IdCBTsU0MOwuYnC1U0VSGra6i+I8WVOGw392K3BfBv8yhpUsLDkh/hcg52KXohJWtqz1Lo1pKz+pJqyefB9icOQbfTnUeDKChg2N6zmkqV5HimzzskdoAgzXHF5iq25vCc2Qv8tI1RSNNJyfetMOC/MZjTicCUEcxY9S+cIHvNYNUzOeoLHsT2kzfDIVq5lSixmSf/DS1MSCHa7C46OxgcHc3mA/vbdFa+mB5+BlsNQHr+DWKVmSVxBLoh1SQSa9F4QXIrgs2J1xePuFXjU6bUFm3o9ckaSiFtAeMSY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3cd37a6-1908-4b44-312a-08de5abbc3d1
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2026 20:12:42.4675
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QcBNdcW3jbtqdGq57PrN703Ugf8V5BGgqwvBYmOhaPcebQSXBszG7LtkHLKp69E/EKwHiNYuFX2EoSatGo86epQrxOErd4w/cVvci/LltHA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6555
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-23_03,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601230154
X-Proofpoint-GUID: KtkPmpKtUmQ_axVhYk3x2vY4ak-BYZvh
X-Proofpoint-ORIG-GUID: KtkPmpKtUmQ_axVhYk3x2vY4ak-BYZvh
X-Authority-Analysis: v=2.4 cv=QdJrf8bv c=1 sm=1 tr=0 ts=6973d63e b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=1XWaLZrsAAAA:8 a=yPCof4ZbAAAA:8
 a=myXMqSKX-38MvfvLfZoA:9 cc=ntf awl=host:12103
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIzMDE1NSBTYWx0ZWRfX85VF0euR5hdM
 CwKYdKvM4MBMXr+q4bFR+NrjctLFBRtQrbyslYsDBBcUQpFLcAjFbFl7HqzHWi/RBJ3iirBlGqy
 Z+kuJjGyhwVeZd9d2iYCVaVkyTmvISSOX3WKORMSgjgE237D5m5cmlTopQl9FjQuAzfESTslLKj
 jewV/7l6kS8ckxBt3lpg7E9jPIQxDftOoTyYQmJ9ENn4AuqnPNlE+0DVACPV7gthC/74st2fzOA
 57HtGRaUOEXm707NQL99uMe7esdSeRPbqLfSAnH4HpF9og/2/kFoW7TfGYjCiCC5w2IFgCv822O
 DzrsmtfYBmuc+PLMwmFI2wZb0iDCP3X/ap3dw6bEBgIJi2dpQdCyYZx/mIgmpkO60gMTDfuoaqx
 nm9Wd4vVrJ0BjWs3JXJkXebsiWlCsIH8VylE6/mzk/STNHUf94r+PBNgQsATlIqQAs5bgZqZi7g
 8fNUJMC6MG3904i5lF6KBzR4D6b4auJIJW7JFNis=
X-Rspamd-Queue-Id: 74786A000D
X-Stat-Signature: hmemgorkypbsydbyum4oah6t4pm7r7a5
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769199178-27403
X-HE-Meta: U2FsdGVkX19aiWW59f0PHyl1yg2qQZmeIO2OeIONomyzty7YAYBlQMjEJtll27WEogXRPTGnjEd/d8ZJL6iZg2T06A7vZWa0MB+gmPVd/SNecBGZBlqOAFVQ5mF2+jmgd3Cg9TD1DOTQXEUnuqeNJRIFDw81/75mHDwFGzIvbGG6fi0ynY0cKARsQV7maaH0CF9HCJrN5l2Hw5HrhVO8bAAcYi7q5fx7XVB93zKrenksT4xSF54xu47M2XmtiT92zBlRuufW8eM5hfUQI5gvjtTi5CiqjdoPxgMiaxmrdUtbY9dF6oxlELGIWUwSJd5C/+HMh2x+/h+bET0lfUM6w24EcqjFS+YBxZNlMoecsaSeKr1iZkpYw/N8GV4sa3IK2D5FSpGXrJyLxYygqo9z5G2GfKowvVztgY1XW3/qkhDpvUfBkEL3mpG98TLSnXf9sFlEoJLwXrphny3tMzX/qrLf6z0UiJ/eioTA+utmXHDoQWO/AIZYaqMfAqtS4rvpR9j+NjUfiFx8xq3Z/ZXbCUvbn1lksin9H5haMKT33dmYYi2ts7oZ1QPZ+EKzMq5mqusmDu8gGaxW8m1H4Ijf7huhsQEIcd//PCceZOxg47pssetNeO45qylDh9Jq2EAxYLkHcc6iZR904678nMEkkL6NgUgZFxwNiscb/du2hvrMg//iKPEvtmGQl/kxtew+02c0uDbe9T1bcK+oSVN7rBmKcces/KUEghie5Z5aPgJqE/rO0MF5TF7DGMet+mwSoiDWYY9JfykG7QLnE7eNrDs7GNk5BthrAWMKiHKwZ0G35okBjevbPxu94dqB9hgMaK8DubVmgqY/5xht/mk4PZgA4ZsqwEdRBguCuz4tBkLQktubtV/1rDwbouxvXK9ZQ1BNMSFrA9xXXr3V2AvG4oOKzvuLSXMWVBQ0bZDtt5ou/ZrbtVGUhp2fnnL05TRiHuB2InBHVncS4cJIaql
 CEv0eDVf
 bmiPQfDjMKDMR8+TaKj7TiB6Q1uG4Af6rOL2t9M7CAcxh02QnGfRuZQI0XsoNgnQrTH66tbxccEqQN5+zkwrcOa9MWtAisK95gWLUatED1db2B4SL7LuuxiICKh7+IgRRS2R3+poLVrVn8avQwvh8498gXanBnhEJ/rmPWLNT3DrFToLyFyMLFfGLC4BHEdsoBK3OERqndbQ4V7kvONa5aWVbR/aAAwZoNvbAbqs8h9qje/J/uYp9Q3RvhbyRVycv+fVLsZTqutW5gSHS0CMzNN1JMDq4NOk5+YScL6rpGCLTmhFfukgACafryPEXnm0Z1siNc0fx7TeW33Lp5S67cVLHx10JxpBIR6uuOGH8GN+K5AX6xoxYZ3vP8B58nEJ2aNizEwQAEAwERbitPB4L1nR8wr/3rAskxfS5O161E70HOIqMGDq2ou6GaYtPKmGMat5ckQ1BHHB5EbC3jp0Zf8FOzO+K3gEssyW+7b/58VPPgGUGbKjThVG1pGW5LMtHnpXHPxDuETKevrce28JPCEQdpv8oOjoX51HWDWFo6W0rb8S13afS07ce8n6z11W1H4JXSjEKr8wyA1JjGYD4gCC8k2qAzZlApUfrJe8/Ri33YyuzSc8T9k0cdYwrGfyZvn/RVBl9bYUZ9HWH9UjEWVneTRXIHZKVkFTy1oi9LjlXyBAj4wE6/ZCcr7BEZ1vCDtJftSPesYbzZpnXd6Amh0ZGRcx0Xt6YZYLGuWYa7mro5y3N/jka05NkjueoytHW2yI8h6WmS5X7RUYm3qUZjj+NtcVTcsAFFDCsOYL8SNaU+F5GFee2qETrwtGgc6zGimMD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sometimes we wish to assert that a VMA is stable, that is - the VMA cannot
be changed underneath us. This will be the case if EITHER the VMA lock or
the mmap lock is held.

In order to do so, we introduce a new assert vma_assert_stabilised() - this
will make a lockdep assert if lockdep is enabled AND the VMA is
read-locked.

Currently lockdep tracking for VMA write locks is not implemented, so it
suffices to check in this case that we have either an mmap read or write
semaphore held.

Note that because the VMA lock uses the non-standard vmlock_dep_map naming
convention, we cannot use lockdep_assert_is_write_held() so have to open
code this ourselves via lockdep-asserting that
lock_is_held_type(&vma->vmlock_dep_map, 0).

We have to be careful here - for instance when merging a VMA, we use the
mmap write lock to stabilise the examination of adjacent VMAs which might
be simultaneously VMA read-locked whilst being faulted in.

If we were to assert VMA read lock using lockdep we would encounter an
incorrect lockdep assert.

Also, we have to be careful about asserting mmap locks are held - if we try
to address the above issue by first checking whether mmap lock is held and
if so asserting it via lockdep, we may find that we were raced by another
thread acquiring an mmap read lock simultaneously that either we don't
own (and thus can be released any time - so we are not stable) or was
indeed released since we last checked.

So to deal with these complexities we end up with either a precise (if
lockdep is enabled) or imprecise (if not) approach - in the first instance
we assert the lock is held using lockdep and thus whether we own it.

If we do own it, then the check is complete, otherwise we must check for
the VMA read lock being held (VMA write lock implies mmap write lock so the
mmap lock suffices for this).

If lockdep is not enabled we simply check if the mmap lock is held and risk
a false negative (i.e. not asserting when we should do).

There are a couple places in the kernel where we already do this
stabliisation check - the anon_vma_name() helper in mm/madvise.c and
vma_flag_set_atomic() in include/linux/mm.h, which we update to use
vma_assert_stabilised().

This change abstracts these into vma_assert_stabilised(), uses lockdep if
possible, and avoids a duplicate check of whether the mmap lock is held.

This is also self-documenting and lays the foundations for further VMA
stability checks in the code.

The only functional change here is adding the lockdep check.

Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 include/linux/mm.h        |  5 +---
 include/linux/mmap_lock.h | 52 +++++++++++++++++++++++++++++++++++++++
 mm/madvise.c              |  4 +--
 3 files changed, 54 insertions(+), 7 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 6029a71a6908..d7ca837dd8a5 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1008,10 +1008,7 @@ static inline void vma_flag_set_atomic(struct vm_area_struct *vma,
 {
 	unsigned long *bitmap = ACCESS_PRIVATE(&vma->flags, __vma_flags);
 
-	/* mmap read lock/VMA read lock must be held. */
-	if (!rwsem_is_locked(&vma->vm_mm->mmap_lock))
-		vma_assert_locked(vma);
-
+	vma_assert_stabilised(vma);
 	if (__vma_flag_atomic_valid(vma, bit))
 		set_bit((__force int)bit, bitmap);
 }
diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
index 4a0aafc66c5d..8e31c5dd0adb 100644
--- a/include/linux/mmap_lock.h
+++ b/include/linux/mmap_lock.h
@@ -374,6 +374,52 @@ static inline void vma_assert_locked(struct vm_area_struct *vma)
 	vma_assert_write_locked(vma);
 }
 
+/**
+ * vma_assert_stabilised() - assert that this VMA cannot be changed from
+ * underneath us either by having a VMA or mmap lock held.
+ * @vma: The VMA whose stability we wish to assess.
+ *
+ * If lockdep is enabled we can precisely ensure stability via either an mmap
+ * lock owned by us or a specific VMA lock.
+ *
+ * With lockdep disabled we may sometimes race with other threads acquiring the
+ * mmap read lock simultaneous with our VMA read lock.
+ */
+static inline void vma_assert_stabilised(struct vm_area_struct *vma)
+{
+	/*
+	 * If another thread owns an mmap lock, it may go away at any time, and
+	 * thus is no guarantee of stability.
+	 *
+	 * If lockdep is enabled we can accurately determine if an mmap lock is
+	 * held and owned by us. Otherwise we must approximate.
+	 *
+	 * It doesn't necessarily mean we are not stabilised however, as we may
+	 * hold a VMA read lock (not a write lock as this would require an owned
+	 * mmap lock).
+	 *
+	 * If (assuming lockdep is not enabled) we were to assert a VMA read
+	 * lock first we may also run into issues, as other threads can hold VMA
+	 * read locks simlutaneous to us.
+	 *
+	 * Therefore if lockdep is not enabled we risk a false negative (i.e. no
+	 * assert fired). If accurate checking is required, enable lockdep.
+	 */
+	if (IS_ENABLED(CONFIG_LOCKDEP)) {
+		if (lockdep_is_held(&vma->vm_mm->mmap_lock))
+			return;
+	} else {
+		if (rwsem_is_locked(&vma->vm_mm->mmap_lock))
+			return;
+	}
+
+	/*
+	 * We're not stabilised by the mmap lock, so assert that we're
+	 * stabilised by a VMA lock.
+	 */
+	vma_assert_locked(vma);
+}
+
 static inline bool vma_is_attached(struct vm_area_struct *vma)
 {
 	return refcount_read(&vma->vm_refcnt);
@@ -476,6 +522,12 @@ static inline void vma_assert_locked(struct vm_area_struct *vma)
 	mmap_assert_locked(vma->vm_mm);
 }
 
+static inline void vma_assert_stabilised(struct vm_area_struct *vma)
+{
+	/* If no VMA locks, then either mmap lock suffices to stabilise. */
+	mmap_assert_locked(vma->vm_mm);
+}
+
 #endif /* CONFIG_PER_VMA_LOCK */
 
 static inline void mmap_write_lock(struct mm_struct *mm)
diff --git a/mm/madvise.c b/mm/madvise.c
index 4bf4c8c38fd3..1f3040688f04 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -109,9 +109,7 @@ void anon_vma_name_free(struct kref *kref)
 
 struct anon_vma_name *anon_vma_name(struct vm_area_struct *vma)
 {
-	if (!rwsem_is_locked(&vma->vm_mm->mmap_lock))
-		vma_assert_locked(vma);
-
+	vma_assert_stabilised(vma);
 	return vma->anon_name;
 }
 
-- 
2.52.0


