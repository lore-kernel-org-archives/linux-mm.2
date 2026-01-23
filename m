Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 903CBD74EDE
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 15:10:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3A0A6B04F7; Fri, 23 Jan 2026 10:10:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE7A66B04F8; Fri, 23 Jan 2026 10:10:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9EA76B04F9; Fri, 23 Jan 2026 10:10:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 92C0A6B04F7
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 10:10:50 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 13E9CC1AAF
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 15:10:50 +0000 (UTC)
X-FDA: 84363565860.13.59510F7
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf15.hostedemail.com (Postfix) with ESMTP id A9F11A000A
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 15:10:46 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=hvQraJkG;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Es7LGWAE;
	spf=pass (imf15.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769181046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D55Sc87f0fWkAsY+IRKeR1mmxaMgzqIYn4mNxmKzINo=;
	b=7eMebUyjz3SRrkEM4KIwvsatSsXwPPWWULlw6DwilmPelxeNEXbA98ymrYLmK58zfcqIfh
	Lmylmj8SHgH1K8Y+Zj9ZhmquIy71KP5vBNi5L/ykW81uakEbqqpZW9+XhajOBEffzsFcEj
	aswzzNmJpQYZETBXrQnFWCIii8TVb+0=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=hvQraJkG;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Es7LGWAE;
	spf=pass (imf15.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769181046; a=rsa-sha256;
	cv=pass;
	b=cnMI1CmlxM0FcLibIlnGTiU4YxouFmjMFTp8YaQ+rB9u2h5MCrY4/ll+hfJyJMR0f6+f/q
	f0o0ayuPnuA2W7PTQW4vqYfPZJ6VKHPD+SPkhcONAxD7m93I9iuuYo50DHH5Lu5YMQaYJC
	RieUfE1Gpk5aHs5MWFGzGyEQvLY0orE=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60NF4Lx21674968;
	Fri, 23 Jan 2026 15:10:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=D55Sc87f0fWkAsY+IR
	KeR1mmxaMgzqIYn4mNxmKzINo=; b=hvQraJkGg3oUvyjlR9cFVxJajBUvd010q0
	WoVZuzfQBWDurrNMSgemAaLtsLHrP/yWaeaBho2IdnBxCckl5rRPoyA/7HHEGRxA
	ory1TgnfrJBNSqEsMea7rBUQgwdzmhGQU9aysydbaFEk345SPqU/HpnAXYa603w6
	i24qOM3h2sg3hfd5rs4BC53wtvOVa8i3YvNH39Y+o2WNCXaWGsjXjbgpss5sFoOn
	xqO3DOvdHNoMITAwaMVcrDwNzuosru7FbKPI7DyhSni/DApDxvkEpfxrB3Bax3GM
	3QtPTacOEllnuJB6wQtSzQLa6mB91y8wym1J9qr39X5kRr3V1VVQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br10w2h54-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Jan 2026 15:10:36 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60NDE2H3038299;
	Fri, 23 Jan 2026 15:10:35 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012071.outbound.protection.outlook.com [40.107.200.71])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4buswc4e0d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Jan 2026 15:10:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k3tbx0jh/o5147tTaQiPedBEI9ymvDbhaN1b3apevenddHVw/xwCC2XprjVDOlLPuP2Y7bjyLDkmGPGbgv+nFXrpP1fHsCfSfHKn4BHuBXGLKnYVWpUa85JEqlJaVJTj8pTkmnjSf3tuebPf99oPC8u4kKh9SD8iOpqJRt7RVfO9nVyELvZYmD7Dbvt2dBWiAxG+83QfOB+ZFAIKvqTA3OTi/gPPP7u5lNoJvXRKhXikwCcpwZIHJd+kXjufiEaAne1gP33a+FvLRqZSGnrx42DLap0Sj5P9LlhJ9JMSiYaT7SCWtXxAQjZ+aBJo9K6EytIv9bqtOoCfB1NTMPvMsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D55Sc87f0fWkAsY+IRKeR1mmxaMgzqIYn4mNxmKzINo=;
 b=kRHWUygjqjo13OPcS36b/jFFQqPkdg/zhPCI0AFaO1+Ih6XN8/JsQwB8YGBJTFuumKXxCpx4VXB0AurQitvdkhtuZ8uzwQIEALreqOFVpcMbDTyUVIqt2ywVh+AMFSmqTea5uIw8g1HuHc7jsTU1XMmkl615C3kS4S0giKLDT2LDjvc0PqUopYvWYBq93wLL0g7PhYMvFuU8lUsJPGkOLdpKWy7vMJgluSmY5hlpEymJDKn46O5b5WH7V8NsZ2xjMB6hQbeoIWSHMOUdkHhwnkUUItNdLL9tlEx9fJL/MC9Rzx2lXuVwvTC5MX+ajLxcbcBA0fjft3/JFIMaeuzPqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D55Sc87f0fWkAsY+IRKeR1mmxaMgzqIYn4mNxmKzINo=;
 b=Es7LGWAElM08b+7Q0u+TLJO+lUyYftK4ypzK9lG5PqEwLMvxsjr3N0bDIul4vyZs+xP+gtNPqJMR1vvF0A5wVGLqpNfpCerZe92KQUwqT9BXew/mveLRd+bv1DOMnoGgocWHQDhHHA8PY1URk8Dy9rRXV0AqkIL0iiL73yAU5tM=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by PH7PR10MB7768.namprd10.prod.outlook.com (2603:10b6:510:30d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.12; Fri, 23 Jan
 2026 15:10:32 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Fri, 23 Jan 2026
 15:10:32 +0000
Date: Fri, 23 Jan 2026 15:10:35 +0000
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
Subject: Re: [PATCH RESEND v3 04/10] mm/vma: add+use vma lockdep
 acquire/release defines
Message-ID: <1fda7a07-beb7-4591-b7d2-d791c67e808a@lucifer.local>
References: <cover.1769086312.git.lorenzo.stoakes@oracle.com>
 <4703b7320796908b9a0827c3d42d74d11b703714.1769086312.git.lorenzo.stoakes@oracle.com>
 <763b5f50-2367-4a56-9410-5636458ca2dc@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <763b5f50-2367-4a56-9410-5636458ca2dc@suse.cz>
X-ClientProxiedBy: LO4P123CA0222.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a6::11) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|PH7PR10MB7768:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e5f01fb-3312-4c3a-a432-08de5a918d3b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4XZaK4KNeInzlo958/E418CbfKfUVBlLZ9fnrcyUxwnMd36jGwkfdAg3zPQK?=
 =?us-ascii?Q?g7i2usEQjkzQrZ7HWbhNwsVcU7nQQC7Fo2oWDdIGa9RhfNUZWUBwkrWYIO3R?=
 =?us-ascii?Q?C3LFxhHwWojqd5LIoB/jlieK7dA6WAb8nFVBH2enqpy74RE5vVZ6uudTZnBR?=
 =?us-ascii?Q?eE8i27RE+5gnGOPAkHVDEnQGw+OWg6i1HRxl9m2ykhSWpMtqvXv2JwFkOsp3?=
 =?us-ascii?Q?XIpapH+HniYTgo55IcBXEvvCCy2OgD58385gxakDeE1vYrbuKwfrRGhn/glS?=
 =?us-ascii?Q?SCVb4tI3PmZ5EftkOrC6lCb8Thy2HZiW3UU04NDoduf+gg/Kdhr1xEHAsIAl?=
 =?us-ascii?Q?dODUpUZV58w5/+Q+DO3INtYlP+CjkuZ/BiiuSVp8uO4Z9P5RCCFG6secByiX?=
 =?us-ascii?Q?DkHNdXE6n2G78ETwm6Hbvj8tnqMw6RiGe/AT824LxaKLG4nykCRI/Btg7cEp?=
 =?us-ascii?Q?dSJGylGBLg9h7RDFVLWZACMEe9YTEoDyykILRf2sLKazmMLjq6UiG0jd7sZJ?=
 =?us-ascii?Q?ZVgvQotZ5gFsDBp32x8UhAoNV4niH5dBDxg3KLiu6iK1nHG4ovTkHE0KjpxS?=
 =?us-ascii?Q?ciNmUgCQsq1nvtyyhzMvZFKek7s4qfFrO+kW/vyezbwkyd1qduDSjC9p4xsR?=
 =?us-ascii?Q?pqX4rcfxYSdVS49+aF2eTUvzAwc2gZwkG4bS4RpoDJQca5fjT5fMKtbCFZCA?=
 =?us-ascii?Q?h7NddVGOXtOVfZBPV8C4/6UIyCML+DWycpoPImV/8PTHObvNTIlfKS+Ozxmi?=
 =?us-ascii?Q?j6jV+KNeaStOw7RuOoFKbFgdxMmepmVXBOoyW/foqdlFDduO/I0pFC1N3ESg?=
 =?us-ascii?Q?Frjufq7+V7+JOC9gmEuUXLXi7x+tx0aNKThxWa+WomwacbEMkghz4zgvEBly?=
 =?us-ascii?Q?BoX+5otLuPGSSlAMFUMLw0tEjXimq4w1vvCaoOXA/VTN/ZNVPNnC+zfWTTSN?=
 =?us-ascii?Q?PlYs7FYi4dvT7IssND92LXWgUi8SGExSPNLxPRtkypllFIiFBwRFYSZ45Dzf?=
 =?us-ascii?Q?AXOw/a3A1/BZCREyNre/O4Ubp4mI1GYX1H10aKT+kHzvSpu547FIWDlIX6me?=
 =?us-ascii?Q?YdqUSoJNzzIpnDmqevNe+iFYK/5TAgF3uyHniL4vD9kR9o/rZsRzKZ7Lltn8?=
 =?us-ascii?Q?0EMrgkTMI8xv/EYv03ncn8R2vW0AFjHDrU5+DUeMiQcRYOyPtZMqse1iy7V9?=
 =?us-ascii?Q?KbxQYSZSP2LGIbh7TvFl9MA8ZQfVxM2KgNjyp77l0qLCY/NMJgwyqrG/KGGp?=
 =?us-ascii?Q?DOf8DKxcwbhVwtuq89NTVNbdC7U4Uu7Bh6x9a2rUdn+KvykmNKvnrBXyiFQr?=
 =?us-ascii?Q?KdeC7d6kWqvy9EYt2VPcUwC8QlGT+ePlN8RezU5Oefly0RXsLj+XlueIgSy7?=
 =?us-ascii?Q?bYCS3oSs/BHN5ZNbrbW5gBrcBe98hAoFL04BMxIDTiXsfyIuhHuz63zCZZNp?=
 =?us-ascii?Q?075/Suyxz4XAR5X8HexBH+IRtKXhHJ8WSPXnSQMXAsnjjkYuv5u4msXvovm5?=
 =?us-ascii?Q?8vxRtxD43emICWDKlEOhtvL+tF87yKDFrD1RnFmsYtTPcI1XDpEvdqq5s4nZ?=
 =?us-ascii?Q?WvJO2Ih8fD8GOFAYv5M=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DW9wfEv0JK3V3tqNpT7+zQs0lV4O82NX/b8Xlpauld9rTo2xtpm6SRr+KI0d?=
 =?us-ascii?Q?lDxOosUL6Io9wrL1+tvUgDU9GAl+zADDT0syKFqePJ9UPOU2PK9a8xGxesgr?=
 =?us-ascii?Q?tII/ZD1oCbmsCFZ7rd5pBgmUUab8MmcnOdjZ4VU/wTEelYzsMoVMGSart1V3?=
 =?us-ascii?Q?RzlapIVFV9bJVHnQ7ZOe4uIhkW6WUGcyxYnYYNEQPx95pCPlujdxAp+HktnO?=
 =?us-ascii?Q?FrLwHS6L2dJRZRX/FKIRd6gbnSDeN99LumIFKrz+F7O0QR7ZiZo6IlfrUYIX?=
 =?us-ascii?Q?i6hS+jm5p+Yn/koSc3KdC7zZuxUSk0FYB5KYVf5O3u69FT4HmKUdi/6jNUGj?=
 =?us-ascii?Q?MBCbpdzdW/4V0/vCx6lSmUphqWnVdnKcr7r27drMEMYrwUspGXE3zNEDSUkO?=
 =?us-ascii?Q?5eFAestPlhPgQ1qH/AtS+wRWMeAgeN9l+rNhMFab1uE+qcTeOrBBE5ILOsH4?=
 =?us-ascii?Q?P/whQRKZP2fwJGEmhuK7p+SEO1OLadJrQoVBJ9wKFfMGqtL/lt6a7miihnwZ?=
 =?us-ascii?Q?VH7kE93VOXSi2qw7grQRpKySA/0H1+eBq7vwtYmVN9PXIcHYocnKr0Iuh9Vq?=
 =?us-ascii?Q?XJLZSeuHDKI4VYY4Zv6f6e14yhz/cLilWo9nHPGti0baS1ezwvV2fsMrcTGG?=
 =?us-ascii?Q?skjl28n7EbqJ/9ycAgRQ6jEPHwRxYU26TJc2aTtKmH9Kx5s9yVxKBlbqjTRC?=
 =?us-ascii?Q?hWWIFlrkqzbAcD3hEDJ8GftGW6HvJ2XLN7s2P3SjSW9OBJaL9IFrfbyxZifz?=
 =?us-ascii?Q?9eFAbQNpCbngYPd5BYmpir9HjIHFacU5McGx3+S0c980uWp3wtSQfIIMQyRh?=
 =?us-ascii?Q?dRc/nh/8MaDjTYdKoBly84bDdzCykf2dbq2oEREYr4+sanHhc9MmJ3PzuoTQ?=
 =?us-ascii?Q?ZBjBWiF1INI9QuAIMVsAOGfYhati5XnjVYi9/hWccIubQ9Fn3oJzBmobLZNa?=
 =?us-ascii?Q?yhN2rHoH7BSmJoda35vs+cUHekv0OfVTpSJTV31HlNfS/GVSNJCzRK07YjLO?=
 =?us-ascii?Q?iQW3LIwtdGZN5W793NN0Wu6lVys/VwNmIPw7/Two8taArwxNVLo9snvvsbO6?=
 =?us-ascii?Q?vBeQNTy9cTCxWBIGmouE7SOJdYP1ngvyKgBlfHosMBDywa5wzZUmXqiecMxO?=
 =?us-ascii?Q?9tzV4k4pr+yq0oTcDD4yPpu8c9P8N7avIYgzVAob45eweQg6cVvs31y7oJQH?=
 =?us-ascii?Q?iiOm2K3B93MwcRzf1S0dCRN2+tf3SOtPXFsoy+SkkA9mfDPGo5CAWUDnuveI?=
 =?us-ascii?Q?XqYZV1TCh5JLWP6IOiuktx+if1SQqE+Woq6aoDOypi6H+9w0TZDgUsDC2g3/?=
 =?us-ascii?Q?tApCyw2hEmb7Fk78LwZ3VWjNQdY3sYg78A93IKtyBjYDBsbbMFGVZwtZGXBy?=
 =?us-ascii?Q?wePZL5Zom9OoWEsaKIj4XzE/SI02iWhHnDSEbbNiTQgezgCKgEMHiFc9LpXf?=
 =?us-ascii?Q?/+sUquMSTOgjqjIu+EQDM8ZZrRDJh3z01Pm7Ro/L1GAVvSRySZbZkyEOJZwL?=
 =?us-ascii?Q?mJpzBf20s6VPk2EyI+g8StPDwtPaCpRoIXqJmzAH7qqLBHV5cLly8UNF3K/k?=
 =?us-ascii?Q?KEOekmPzDKoEt1mRTnxgRwgFdDbbMIjpbYuEmH8uji23DvKY7ncA94KorIAQ?=
 =?us-ascii?Q?KHVSVwRWXBhaidmUb0O7Qcsdeo1JJu1nDczAcTKOZPBCLxJ0CP9DIoqH5Nmo?=
 =?us-ascii?Q?GRwwurrpMrQ/FkrNKwXjmRkGT4dW0pMG+tOqySO1ILz5/hS5pq32gSCGsRxg?=
 =?us-ascii?Q?r+PeP5r841x9IiMJo4pM2+s4ytAPP8g=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	NROwQGpRFNE/B6kROlzJUlekB/x85xenXYCdY2wydsemDAKUfAsNDC6XXyTgp2cPdudaFCuTsxnDLgKDdIRvKFgpvnDSHSlPXnIa2F7ub0w6tAvscaEVpFqIlM/8fd5LxCJ5rL4x2M3HbCTGT+WxttbGbPhrSD5bhBYM6kOjvOeB0WSfvrwptwDrttQ6lRquBTBRI3o1ZxRAvd0D9Tqa0fA62n5aRO+7SAQKWSHlS8MF8QwsInlUi+cGIHAqpAkZGZ3BfElmnagQxAXcJxP466bmiMgJsCAWY0YAeCNV9fSDWf0uOwhGPdhRKvGHnskRye+U+hnL5dXSG72RmR+pzCTp0nbtDz/EMts5uRfZ+Gc17s5Pw7SPHYMNbzo3OcBp9DdFwGFbNgSQrDT/Hkd+tyvQ23mLmjQeQeJU53pqDCctWcKqq7v4/Z7icPzqehStMhCTENGBgnMUAB3HSVphx+c7uNuZG2nsjQrqYy7Pe97BYqsxlAFEq1/qFwZ+BBpAAo+flExXCzxXG+VojxMqOAKpSOGtmGs33c6C6NjFJNb/fZYpznX85DSEqnEc2gkTNe5gESxXHxpsyTbybGw/9x5Hn5Y6BCZvozZ3hWbWTDA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e5f01fb-3312-4c3a-a432-08de5a918d3b
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2026 15:10:32.0816
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GfN50B10t1/aXa2ovjdODA9M0YMw+0wjHgQ5Fz34wuOc9w8tI7vhtKTB7BVelbL3wy7yIExYhXeHpqkhHFcaTXnDNcbcxcDEY9s5dR2skSM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7768
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-23_02,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 adultscore=0 phishscore=0 spamscore=0 malwarescore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2601230118
X-Authority-Analysis: v=2.4 cv=H4nWAuYi c=1 sm=1 tr=0 ts=69738f6c b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=yM-_ay3oZLHf1c5WwsoA:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:13644
X-Proofpoint-GUID: KRWtmJP3_MqJ9OGe1mCMy2EFHemW7kaU
X-Proofpoint-ORIG-GUID: KRWtmJP3_MqJ9OGe1mCMy2EFHemW7kaU
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIzMDExOCBTYWx0ZWRfX47XHQvG9v4wh
 OFYN3/eAHBI8/ENYe/eUVhfM79zIu1AN2PkHHD1DbUqMExR+AGXldwAEAG9IlzdkDkXVARV6ebz
 EbhKkAq1csaAgNqGvyffGGkzl906SMvBKLpaQS+Wd2k8Tre34MEpuyCv5Zi35UFGnsO442bCYkP
 CcLme64LUXYulOJZRo73A2xDNjjSV7JrOJ3vxYM/fb968Hab7JvypHZf5L/0iVxs49IExFAT7m/
 rDW0bXvgj2lgGWHP3AH/VzoogwFeS68xzc0brPdpTlReR/9Jf3Mlme6cyLK4l5CaKee4gp3aZxB
 oopmMfT+tr+4Ree2HwplX30PSdyIbx6dfMFQ/sjpcUN1ndk6lOqGXMUZPezscopuTG9HynqBW7Z
 qKPnoabdZ2gRWREC3haeLvARo2HB7kHAEzngfz/pXWNDsMqrV35wvhNegA84XTN3v2wSMUjDH8A
 tYROlnCVMxqamTiw+SBhze2Qnche6cJoh/vdaHEQ=
X-Stat-Signature: p9w8ubgu73bw5chcgqf8eacyryd7w8je
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A9F11A000A
X-HE-Tag: 1769181046-664563
X-HE-Meta: U2FsdGVkX18IdMWAwbnfzKN7xiNFP63eu7BQ4zD7maA9Ck4U7LnDQ9LCp0/W8zZY8m0W1B2bkCSZDHljIEZ/VqGkmHzzn3fSkVE9DjCKfLZdboTH9pPRZhXQ9mySukBMiMDVUfyL46TV57wEHDaAwb/i8UwrIW4bj2cj7GpOkFw5AfUGEC0xGUYZCcjtA0c8vJdOSsu9UPVb/TcJbwqJsQiU7MX2vU1lPUcO/kNI3tP8on6GIB1PJHx6kIAJdtcAiMDgl4oQe0Wwc0hJ6zhFPj6z8hP7nPA8+Dgv+YhtCAJjafL62HltzQOhYXYjO1b3jVKZDD+MAvTT/vpKdBPWP+fc8+4c+BsPq834FjtaCe7hwYw3LUQA49BoHGXvutmYiO+mol+50eyVQ8idUFdUS3lKQphAk6UnGn+AGrocqaOanGdxunLeNRvqwvt40+P6cvInOgZN7DQ6OeM+e7blxkfUuaiL9yMcYW1sOIZ1cZ0y4Kj61MPyOxc7SAsfNGfaJ4674XpTveIMyVnb8FVFZQZK5VpdF6EA34z/nUVMHENO3BORaqc/vWDpIx8tOTtVO9/ae3W7rXUHTv+T329B45ciYzPXfAXVZ9Ngd0wUzOLh7o28yl8wQJU6AhOD0L7g4FCidBYmpYBZC/7PN42q9gvxGcJ8Kmwu5MLYu489sX5FxS8d7EZKyz3rNZDzdS49uv905/NVl0SmSorgBUVYHnlh/tcp73x0wBHYHgz7wDHnYd37s6S5koTF8wlxQpw/WV9LL25peNeChXiPBNypj/1jGTqf57AOnQh99dxANq4ad6Rc0sh5LmrNHZdbgWiZPUu8ijdufu+Yz5Q9M+5l5/qivf62QBfFb16vz3B/zLJSorgmSkFaLlJrmP8JjRFOYomXn1gE2/HM2TrDPqMKzyl1BxdJ103LPxv4MMpDg+XX/0f3mVLmbQjrXFC4Ff6yQZTbE+4/RqoJrnWmyZK
 Y6COIjAl
 D1Vvlb69A+QP+Wyk2d7Yh99P8nG7tdH2oOeqUvaXRBda9mWi9lcVfRqvxy98+gAGjEhuM/y4J7UUEeU9XjK/LQVjn3EO/WzfIydtwu6vIKK9IbIHUeGk6h2t9JMudXysGIkabWDp1jp62L3a2sQkU7DQ9jzrNK7kXawaTbZViXPQmiTeYjmrAevAU/sUiJ4GFS6Cd8XI++UJkE6J2JyHbTQRQ3ONUSoR/RAljbODSfVmHlBbLQ6FxSMzGmkD5ikpVyxy6bClh4FE6BtXwB8P6MW92bpLikhvymM99WWRpyz/VpOBoFn868o528+4R4o5blIPLSiMoqkKmeW4sf38siL+A/w6r2VGEP3vSevpJYddSA55LIlgHbYRax6a8dK0bJ2UMmy5RafltHiazZm6w85bNnHMhjwyCluXMDuVUYL4TmKy6oDiKDCPxs8+4G8ID4b9kLU8T4BZ2xxVIGvuYEpoJy+tl7sFoLydWs40UrUNDq5MrZPNX3fFr8Tkv7gYFLRHMNy93zfwwVh0H7sa++UeEVtUbLFxr+OxProfPf7uwpYQh6OwxFVi9B+1dIv1PD4e5i+Nyox6cgVt/Jh6pB9+2pLamQKVLo2Z8G5upZoTSQhXNOE3xYVDX86PkXT15zD5v/EpfE5G9xMEOPfUSIp6CSwCC9YkE9I/fooa8SetrmYThvh7sH/MSqzlEQhtFGcBeyNFC+krf3bHmetMyLlxcew==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 23, 2026 at 09:48:28AM +0100, Vlastimil Babka wrote:
> On 1/22/26 14:01, Lorenzo Stoakes wrote:
> > The code is littered with inscrutable and duplicative lockdep incantations,
> > replace these with defines which explain what is going on and add
> > commentary to explain what we're doing.
> >
> > If lockdep is disabled these become no-ops. We must use defines so _RET_IP_
> > remains meaningful.
> >
> > These are self-documenting and aid readability of the code.
> >
> > Additionally, instead of using the confusing rwsem_*() form for something
> > that is emphatically not an rwsem, we instead explicitly use
> > lock_[acquired, release]_shared/exclusive() lockdep invocations since we
> > are doing something rather custom here and these make more sense to use.
> >
> > No functional change intended.
> >
> > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>
> Reviewed-by: Vlastimil Babka <vbabka@suse.cz>

Thanks!

>
> Nits:
>
> > ---
> >  include/linux/mmap_lock.h | 35 ++++++++++++++++++++++++++++++++---
> >  mm/mmap_lock.c            | 10 +++++-----
> >  2 files changed, 37 insertions(+), 8 deletions(-)
> >
> > diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
> > index 0b3614aadbb4..da63b1be6ec0 100644
> > --- a/include/linux/mmap_lock.h
> > +++ b/include/linux/mmap_lock.h
> > @@ -78,6 +78,36 @@ static inline void mmap_assert_write_locked(const struct mm_struct *mm)
> >
> >  #ifdef CONFIG_PER_VMA_LOCK
> >
> > +/*
> > + * VMA locks do not behave like most ordinary locks found in the kernel, so we
> > + * cannot quite have full lockdep tracking in the way we would ideally prefer.
> > + *
> > + * Read locks act as shared locks which exclude an exclusive lock being
> > + * taken. We therefore mark these accordingly on read lock acquire/release.
> > + *
> > + * Write locks are acquired exclusively per-VMA, but released in a shared
> > + * fashion, that is upon vma_end_write_all(), we update the mmap's seqcount such
> > + * that write lock is de-acquired.
>
> de-acquired -> released?

Yeah don't know why I said it that way :) Fixed.

>
> > + * We therefore cannot track write locks per-VMA, nor do we try. Mitigating this
> > + * is the fact that, of course, we do lockdep-track the mmap lock rwsem.
>
> "... which has to be held in order to take a VMA write lock" ?

Slightly edited to:

 * We therefore cannot track write locks per-VMA, nor do we try. Mitigating this
 * is the fact that, of course, we do lockdep-track the mmap lock rwsem which
 * must be held when taking a VMA write lock.

Cheers, Lorenzo

