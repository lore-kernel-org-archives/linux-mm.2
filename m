Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6C39CCFA13
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 15:03:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0C4F8E001B; Thu,  6 Nov 2025 10:03:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C98048E0002; Thu,  6 Nov 2025 10:03:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC2098E001B; Thu,  6 Nov 2025 10:03:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9355A8E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 10:03:33 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 17E321DDB0C
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 15:03:33 +0000 (UTC)
X-FDA: 84080501106.02.C0EA5EF
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf01.hostedemail.com (Postfix) with ESMTP id 59E4640012
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 15:03:29 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=FvFABXw0;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=tfYkeFYJ;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762441409;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N5qKG5ljRnXobdU3Hfbbg/N+BQZMohDlUypDvpdeUGw=;
	b=rcDSY6scONHSiOmd0uwq86BWMJBK7IiIi3/802DQm+sq/yHjb2yXhD0qLa9Kflkr3jtBrJ
	gtL2tOO4jDcGYl/I2Ys+LpQPND8SLRQoEcfZmfXcMUTH0fFcORjlPJvOiNeyzFx0C0O1tN
	TSQPXq3rRW6d4trgBuyDakgVIunFeps=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762441409; a=rsa-sha256;
	cv=pass;
	b=jaqOHV548jA3CNgGf7LAM1dK9g1GrZZigRtfSFLqIBbWFaUZeAhzShmSi60GG6ejWAiONf
	w/HDgIsF5jZ1t5JePZibF+B0/n2YdL7TyyTRbF6Smrx3WGVivbjzbBLGrrG+LHnjjz4AyR
	MmKaBK0rXVay0GaqIFboYZVMtyNu1SQ=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=FvFABXw0;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=tfYkeFYJ;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A6B6LvN031510;
	Thu, 6 Nov 2025 15:03:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=N5qKG5ljRnXobdU3Hf
	bbg/N+BQZMohDlUypDvpdeUGw=; b=FvFABXw09MEhWPLe1VD4/L88atjMR4hWOK
	aRT9/8Yg/GCfDCWfatv4VfjDpHYWnkcCw8F3xYHrIQdueG/SWAd+t2O7haXeUKPJ
	s6Pe6qnHftyzulGltYTJ+rMyKiqQLAXx/4DfshawK054wVHeZwBcgJL7lAMJTnXf
	/7L7nyGNJN2IjfN2PFsUqs+BAmQxtz5Ak/ISP/4HUUsAKxNEFYo8PeS8nk9mU6k/
	SXgte5RtfynuULuz4sL9u2NGfSRdI6mmOVrFh4pHo6sfn8U7GIdK+d65JDidIGW7
	ymHpUUAGZjpf8ZIhXzrfbVBZ0rRdHvulKi2QNYSY6O/WQXa7IWSQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a89q42dve-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Nov 2025 15:03:17 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A6EAr8a010866;
	Thu, 6 Nov 2025 15:03:16 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011005.outbound.protection.outlook.com [40.93.194.5])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a58ncgx1p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Nov 2025 15:03:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uVIs68LXmufyZfZCCruVx8vSH4pt6nvgBhLul1XtKyhigdFyF9vRuhuYkaj7WW25gK1d6Ai65q00SOSw1K2ffBw4B7TjmvtlW1ZqY78XrL2aFKRrS9kEH1s4Hero5N0EzkZlwQBH0ZKEoCHwwTk4V0ipeIDzDAZzNpe4ZrCiym26T8Nza+elj1f1rFlGWilnwCcbusSAXZO9Z1xra3AsBkOuq81f/lZnXV2wznib50ksJFZHuyQeXuWkRSnuXsrEifDXUkN7B8XbA8GVX1j2fjcOcc9glIxELU3z8cMmqg1fnJuSOU1YaEelekkUp5S0871XCYyKIUlBZ9qfcr7+sA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N5qKG5ljRnXobdU3Hfbbg/N+BQZMohDlUypDvpdeUGw=;
 b=kGULpwl00YNE9PGqOYgNh6H8tINCEAhIuyFQOThlCjwGao5/MnRI1qwVe+b3Ftw7Td8uE5nEfo3TOJnYWxlUo5Kp4E2TpR7NPIE5y5T6nAuCSux9vg6/wg3Lz/xblPc+dyJiYCMNY8vl/lnORIfMAjuHkvkieQo/TGgBEI6LKN6IXn8hJh5Gg22TW4q7jRSU2VooL1NUZKjw82OVy17EUtBcu6/DEm9yv/Y2l7T4OSUw9qATKsIwRq2C+9S/mfowiFqg7Shg4aGvkHStxL6ymRze6OmUsKle4+rFz6jEVOtm+ijXNKYiJ6qvcbRDGqgroOvxm/UEjMOYvEcRC9c7dQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N5qKG5ljRnXobdU3Hfbbg/N+BQZMohDlUypDvpdeUGw=;
 b=tfYkeFYJn5dWYoMbE9U8p8BYdelMsFfeBuvfC8N/B/NGznlb/uIqA3MWMO3WjmR3p2yNzIoV4CxxNI9Kl4JRDf3AYJCV2FOQ1/du50Y7BK7OU7rEwxBdlx6rUX3jH+ynueInUfXL+/z3rnz5Bet2oE7jxH9MC6yyFTer5Z21Xx0=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DM4PR10MB5920.namprd10.prod.outlook.com (2603:10b6:8:af::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9275.16; Thu, 6 Nov 2025 15:03:11 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%6]) with mapi id 15.20.9275.015; Thu, 6 Nov 2025
 15:03:11 +0000
Date: Thu, 6 Nov 2025 15:03:09 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>, David Hildenbrand <david@redhat.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Jann Horn <jannh@google.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, Andrei Vagin <avagin@gmail.com>
Subject: Re: [PATCH v2 2/5] mm: add atomic VMA flags, use VM_MAYBE_GUARD as
 such
Message-ID: <69c73e1e-c520-42e7-af0a-65f17f5e081e@lucifer.local>
References: <cover.1762422915.git.lorenzo.stoakes@oracle.com>
 <94935cf140e3279c234b39e0d976c4718c547c73.1762422915.git.lorenzo.stoakes@oracle.com>
 <y6a4qchmj7jnaogx6u5a3i6lni7v54lj25ipwb7tdtakcudakr@vm6vt7eumxax>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <y6a4qchmj7jnaogx6u5a3i6lni7v54lj25ipwb7tdtakcudakr@vm6vt7eumxax>
X-ClientProxiedBy: LO6P265CA0026.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ff::16) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DM4PR10MB5920:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d6c68ff-f767-4a97-33e1-08de1d459a2b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8c5DQj66QxDb8NnzAVzRt4LvqfPmbfMuno2z6rFg5aEyWaL96Le3FrXNPMV5?=
 =?us-ascii?Q?jB/p81HlPsscrJpuFTnL1EdIXzF/ylK8lxRKTRWmqkbdMZcbBaMdd/kFirdI?=
 =?us-ascii?Q?5dnSYz8/wyTY1HQKFpLcJf0uhNeWgK3H/aPflKaLYgT+PxDr1BMmKJZwnRc4?=
 =?us-ascii?Q?i8J9AQQrk00aOWUFvs3/F4/h5VbCr5V3eyqfTwQM7kxt0D2Gu7Wg+EH5W8Ja?=
 =?us-ascii?Q?S2WQDV/Ydc2+IGHH3Lm17/E+kWJKcr3y0kNF3Z+gpugg2mwMJVCCEtlLHCRD?=
 =?us-ascii?Q?rKiDgq5Ub4DkT5HNmzhESTvdbu94Y0h3QIwm1gM5uPuAxWe26Wnjg0nLZtbs?=
 =?us-ascii?Q?nnjgvHgzV2lV/mj7GuMusbatVvbiPD6w0vrSL4GxJbyCS1ggYOBr/KH+f2iu?=
 =?us-ascii?Q?WCYsY3+5+2OTASEjty+y9TExno5mojw4heWgEaKaVnun23QjSMz2nWZW6sFa?=
 =?us-ascii?Q?kkdEPJTIQnO/KMbJd0E4gFWYj3iYjVDA134oDb8k5Yb97NHVJBjAeqvdV5BK?=
 =?us-ascii?Q?dXK8PP+N1vZ4FSvodB5HCeLbLpNaNra1k4wXkbbVAw87At3H/QgGlFenNfLa?=
 =?us-ascii?Q?qSjQGN8pJ/OpNe5664NuGUZdV8NH3yQDTOtCvFZpLDEp8RSVxoW6Hx2pDKKB?=
 =?us-ascii?Q?1ABi2lN/aGTDoSygHWZoSGlywYylPqeVTVKV8ew+uMExPVxW8Qj2c0lMefeS?=
 =?us-ascii?Q?QQSJn8hixpC/LIvim8r0G2azbMRnigjFWI15PVKVOkwtWZ+KRgzBuumVA/2Z?=
 =?us-ascii?Q?HRLf10XJDm7OYtvpcrHsbbLeaUPWE6xTT05RkhDDXU8d/Cdmr+WF8U6sWyDB?=
 =?us-ascii?Q?66N6p7D/vLuK39W+CcWCFyuChx7K8Ym7ywaRoHA9R86im57TvRCCmuR8Lb3G?=
 =?us-ascii?Q?nNmCgbp3Yq8Fzs9R+VtmYJ9NGkNHOSdHTV2f99Cis2ew9vciUJ0J5QG6/q/e?=
 =?us-ascii?Q?R9Fgj8JrBb4e1nNomIAhANn3PcSpb/OeNbCfTCtuwTOSYUeLWWX8OwDPAV+Z?=
 =?us-ascii?Q?CaAeoD+ui90CtnIMxxis3x+8G3+r98QPJbWy6RqeZ8sP7BkUEAk1A7PvtGr+?=
 =?us-ascii?Q?W/9sHKVypGTmduE+mxXYi3ZmiBpm0DhbJmOqJ2SY2CbPTYtdqHlkWDzlGxEe?=
 =?us-ascii?Q?Hl2UanHYAXMTmQ5KELESTenLWAMMNiQonh6WfzjZ5Lqo0e+67/3+MPVwTeSo?=
 =?us-ascii?Q?b4OdOdI7JOfW50z+rWscsNj59A+u7pZkVHJwiGricGVIQsjF5XLv7MISU9xt?=
 =?us-ascii?Q?7UnSbH6akGXMmKRnpzDVdZ66P61/gdcQQPr30P9ivxvIXPGY3ix/hf2W8lV9?=
 =?us-ascii?Q?bj3+ENSjBPPJhPqJ9yZ3J/UuV2vYUWxmfrQaCQktIAWwvFDBA54SjAJnRFSR?=
 =?us-ascii?Q?SAMVmKmi6YEDCka17Mq+aO1TRH7iHiFeeB/bNGZr82LwsOWYGw3ZkE3wQo03?=
 =?us-ascii?Q?oz01Fp9/8o0r0HV32XCg374qvKz0h7aCrIb2zMOhSz+OaOfK02vBSw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?J/AGah4rVl1Ydtv65n9hphPi2uFcmWPBEwFq4RIF5Zg7iO28DXGri9Uu7B0c?=
 =?us-ascii?Q?22LsdoZWo1ZMxXeOEA3N6VUDRZp8nxHMl79myVI4uDn3hVJHQXUCkNho+O/b?=
 =?us-ascii?Q?vqX0pVUa3Kj6uCP7y/RKRWAT0ugAamNvTaLosEPwHQHHV5EtuOCrY2n4Qrc1?=
 =?us-ascii?Q?tWm6jDHRuEAiQ7zADUzTjzdvwSP3Tvlh7zOirhvzos0djdt3C5lTmay4BxV7?=
 =?us-ascii?Q?8TFa5oWaS7oMjF+W7qb46iDhJMxkkQ6t9rLX8w/8PWWFVLd1cUeQVYhBxGGD?=
 =?us-ascii?Q?irJ5eykAuKMGNiwm/ves0x/Am/GMlAFuTSBAXv3OpF4kvJZI/Rv/70ZitNpP?=
 =?us-ascii?Q?1USw1ubGLqClzE5w1e4d1xBVNE08MQjCD3RfqeRBBakT81v6FdWhxVHNdUgH?=
 =?us-ascii?Q?YuaP6jSrEDMnKnNiuYBlZvK3wIYGZeLW/DfZF7rfEshNPioSSFjqsx3ASJEn?=
 =?us-ascii?Q?6btj0MD+zpMdbQLnrJ//BTJQ/fgasD5FyFeCW4vsOM5eGI1TKsFsbT0YtaZp?=
 =?us-ascii?Q?BibHDZYR++3pfJIFZNK/qXJQ6RWRQuxq2jYxabjiekhQ2wNQNbYDIMO/uPrs?=
 =?us-ascii?Q?ab9qQfZNhiQsiMtm036JzGoDj9JwPfelTgKZLtnQNxaAdBtU+T5LxT8cLuN4?=
 =?us-ascii?Q?hkdE4OLnnuUxtgK/cyRt4vfuUX34uwo5JFloaqSqHGqr2FTcwKorAnbCO8iZ?=
 =?us-ascii?Q?F5EXt6r3s0BF2lR31kTDP05u0cEGvChts0/wGlRlYHrqvIvRM6Tc2JBsZN7i?=
 =?us-ascii?Q?/Gtr65y74j8li9jIRWzQfRe0eMDSb+HIPCh9lCw3XP3fH5xi+QW/a4RPuxAz?=
 =?us-ascii?Q?QbrtZgqn7J2reLqYf9KSSffq3iz79JXZtgJRQ9JpIe5GrkIbejI91XidZsgu?=
 =?us-ascii?Q?spMcd9CFteVLGOuv3RyP+j4hlyifkVyOtLcaj3EMiZ1H6nOobLvNpJ2i3//t?=
 =?us-ascii?Q?ikRqfj7vtNikN41vCfg2dBTBOHxVWso7DcBCIHgGG1jJmwTbP1Ipc32640KF?=
 =?us-ascii?Q?Ojn90iFm6lN2Sig7Gk5XLKo+6s8kEIy4kD4QvO3tQWBl4DId4I2Uegv3MVwQ?=
 =?us-ascii?Q?Yot7iCkRCamY2y0TORLsUAIMQtl8wKrJhc7ZrnwP7BIfs/oDvttmRJIwz/tg?=
 =?us-ascii?Q?zIkAszpIwu6l3ozdO6B85XL/fJ8qGnaZaj4Zb5r5IvKF+boPCt8LwIXygXlW?=
 =?us-ascii?Q?THyx5L4u2f0RjQvkavBUJ/NngL8fikxpG++tTdXrRrbqJvbiIuUtZcTeqgAs?=
 =?us-ascii?Q?fCyiI0h8sKXrZqLr/RB/5cVP52+Vypa7Z0PgPwGaAwP1sQPVLoEBhvln+zR5?=
 =?us-ascii?Q?hgvVfA9ScZYA8ek+4vMDPmfmBK0OPHnc9tbSh8W2YDfOTTvrbTs7MaHV6hhc?=
 =?us-ascii?Q?TRLbbngvXghlkXGosYfto8KutqwzkotHnqiVXaV/iQHDaXfoEskTQMQD4Shc?=
 =?us-ascii?Q?TZV+lXJGkxfv4yvwN9Gx57a69KcjuGbEUUdMqS+rQPcfCkI7GnH+e1bBACtr?=
 =?us-ascii?Q?PV0O3tj+MTVDeMVHEUpNXr7QnjswXUtp5j12W/kxI7DKKUa6F/YYrOmJyp/e?=
 =?us-ascii?Q?AQkQYtL67VocVS8TC+LfpamkU0AEGKs5O2l5sQFqavxAK9nq+Gnn/KSmHM/y?=
 =?us-ascii?Q?8A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	rynpJxXeJyscVwp1w1dF5unZBwuTknSlVWIc3dlAcZ2lZFDrwQbS92Zm5EGw4AscoT/LQogDwev/hBz9AZeflsTDWgr1tmQ7xQVemvQzabGJn+cqVscY0z8jXuBENIxzDKijn5In4amjueyzN79LzRZ+3ySWpKCZeAs+oHIrSVcjtWg7ctwa3M5m7qch5unLh1/iVFpt11rSrSf9HDz7feMyQvDOqNAlUVPL4HWUaCWnn8o1nAY1G7sZ7/pnK+iYQzpfPRZ0HyigMgFKEui01kvBdgXSFaQ9BJrhxVgIShmBSy4/JrFU8/WM4oua9CiGsd0maceubeuQff6ugiLHlasMDCArUvj9UVvt3El2qgqDwF5cjC/UXC9pWrYh9TotU/attSFvTaQV35pUCbsHrZnflbYZimiUt6FFX1w/e2N/Oc9Xg9x/SSS/jBDO1eVjL3lCeffcevnMKvqLhNDXfFEY+3z4DqB4zhXx6t3mxwO48x1mukf1ooqCFwm+tM86XB0UlwW1s0bwiaIsVtdzvqh6aTXt0dMv+ghNHbt8nHSihd6c2cMBXP7ExSrnbX/eYW5xUrE7UDfC/6uQz29RQN1MaN2stcmRw7REdfLUHjc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d6c68ff-f767-4a97-33e1-08de1d459a2b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2025 15:03:11.1262
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QrsfvruGpRYzMSvk6EevECrAWGsIgaqnYHzpQ2ewhY60oTUuK5V8WcYrdaIlFSKpX2RuTbMU5vhtKQYVFAgw/uuXpobCVi7YXvNC7WrsepY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB5920
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-06_03,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 suspectscore=0 mlxscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511060119
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA1MDEyMyBTYWx0ZWRfXxsAX5RCd3B0K
 joxlrFeEjp+vXeH+jKZ4wDSb8m12wnmlRz7PfKrDXjzgszpOzvwR+rrU2z2+uW0UDkZaFSCEtcU
 eqs9tpqof2W1qt0zSUuJfjX87fkH1LvtdA9uc6Ws0nwGew6Qk74e/oBP922Du3i29mDoJSCiTnK
 LLUfE9+ilnd0U2QdZPJgtQa23GszbBzzG6tFpiatLmA64H82AdJzD9A14WEWpGD1rWXywK7oDeY
 UWeyVADEVnaRUz3NOdqPZvuPprw3gJ72+x7EvWRNeJdQLHNJbHsBEzPb+BOuEruoalrbvtPLpsx
 2TiXc+p5llNilH8cmCRIjiAWQV0FWyJvSSg1QtJ11skGGMq9lHiHYJX3wJbX6QpbE+xdA1XnWeO
 JF8VUfoj5Q9y9ra0MbxjPwj0TSnmEQ==
X-Proofpoint-ORIG-GUID: rbvcI_Cv0p-T_X3EBRmoh2kxiQuYlw5E
X-Proofpoint-GUID: rbvcI_Cv0p-T_X3EBRmoh2kxiQuYlw5E
X-Authority-Analysis: v=2.4 cv=PcPyRyhd c=1 sm=1 tr=0 ts=690cb8b5 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=ZlKvLt9NEAVkraWw6nIA:9 a=CjuIK1q_8ugA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 59E4640012
X-Stat-Signature: mkfi4p79zsypfkiq17cj47r693rqwt3z
X-HE-Tag: 1762441409-60943
X-HE-Meta: U2FsdGVkX1/+lv+8GBPK5DR7cBcmcH6iDI8G02mgb3nzhDBj/nHmbwDmL+kkocToBEu51rd9UNs+04Eh22iLymF4jmRCSTxNa9CWJofURfRJsxq/pk8rilVkoKdeYIPf78BS30+XoFUxtbQC7Vhp7afk9sM/eO5LefegkaDZ2Vrnq/Sbn246POqWo516fbhVmSbGkUqOhgQCN2aAsdupA0Q1SulBwKk/T3SM0D9T0prLu6A1x4Pxm0SHb12jkrOcEG3GzqLUiICOsUoN758G7BO+if18lckQN3RVKVFHH+UXGj34+SrTn+TH9Z6KdjaS0LDQXmVTffMWYzqhnuqQy1E6V+Bs6WceOYb+OooE90xLM7tlioHMjnlsM8fN4Wrg5Bw4W/LMbbhr1sD+oxdNXAZd2wvDBuq5+s2bnOaCuesrSLXmgzGnnPn08AYUouzhzsdto6HEHt+30pH8cfmv+5E+oi/oD/ApdepyR4VuePmg5PdZA306TdaX3wwY+m+qX5h8ndPH9uJsCnFxMCMmb0QDFiDTtEzeizKCAdseBKqOlMLq7yrhIBTrsAM96BA2HkPMCHHMSpCZ+uK5AzVaFrwseGxGQQLdOkipKG/qmjpnQqbK5x2ZpMVTvVPysYDig6Wz4SciKAEWl/9Drsjkk4KVJHLRBXqi0SX2x7Gw3zrGLDSZI1WDiF2grY59/FwEKmhDIyaJXJWj/fyfn0ixqxeYpf4fMFHTUgioYugGjQ7isS06nWTrZtJ2lsAwO0Jph65ZnomsgDNu+yAA3MTQP/BDOhWQhiGyV9EYtvdLuegiDUA7tmEoDcQxL++ufnOGgrc4giceF7gr1vhuztI3OtOln3UMb/Ziigw099gelBjumIAveWh1/47Dtf//I0lIcTyD1k3p2AvIejHtB+9AIiIlfsKVpcvdW+jqre7x2mKcz6KqOY3bMAIUxKhi8hwVlV9fDMA0AA1M+Sr68dA
 +QtHid6m
 rLpnvFpF16TUrIC4yIpe5WVaFtdh7PkQ1O2hvN9B+g+lLL9DLfkepNNaF44XJK8TVELNNnGyTU+0OBHn+7YUdn/ot1i2Z6pSv30Wu6N3AXM2S2ld9pxgEteTfusPo665rJRvPwg54NT324EEYR6nRkCnqBQAb3ygAIp2LD2t/Kc0wjke6T1NlKT5EE7MRhKrTLNYvHmlbc9DFro73SAbC4tQUwq55A0T+zM2B8cFCXYngLmrQZBbGsvnEFW9nBHauYfWuYntEJAKj+tNQ6kQOcOZG3jUK1CtrMZW1SM+JfeD6tzKPkbBGspl09m4cFWKkSg8n6WcqSxw4n8wjiG75J6KHUExFtAHiUEdquiKl4wHoR8/JrJC8YTNQKxfTuh3DkfDGaFY9m+Ck+Hn+E4dLLkF1KK8svYRfwl55+AfjY5gt6AvY1+Dy00N0mX3duAJr3CTfOF52tEdjHoV8836on4lgvnW69dLYrSXsh/l8Iz3SmNq5XvIRJloQAGeKYAeGn6cWAiWmxz1V4vRCM6UPY47WsKU2NPdqtI7ne9hAOi23axZs3tBx+LnM6tHXPlXcq/DxJITb89fbGSeKZ6QM18aECdwoFu2QhydjEOP9i3QKgSJUfg9nWVqegAHHTMC0wnG1tFnBq5KjPrppuieboMzco9noiLU0OymgtKwO6v78bftTUzIoDp6jfQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 06, 2025 at 02:45:06PM +0000, Pedro Falcato wrote:
> On Thu, Nov 06, 2025 at 10:46:13AM +0000, Lorenzo Stoakes wrote:
> > This patch adds the ability to atomically set VMA flags with only the mmap
> > read/VMA read lock held.
> >
> > As this could be hugely problematic for VMA flags in general given that all
> > other accesses are non-atomic and serialised by the mmap/VMA locks, we
> > implement this with a strict allow-list - that is, only designated flags
> > are allowed to do this.
> >
> > We make VM_MAYBE_GUARD one of these flags, and then set it under the mmap
> > read flag upon guard region installation.
> >
> > The places where this flag is used currently and matter are:
> >
> > * VMA merge - performed under mmap/VMA write lock, therefore excluding
> >   racing writes.
> >
> > * /proc/$pid/smaps - can race the write, however this isn't meaningful as
> >   the flag write is performed at the point of the guard region being
> >   established, and thus an smaps reader can't reasonably expect to avoid
> >   races. Due to atomicity, a reader will observe either the flag being set
> >   or not. Therefore consistency will be maintained.
> >
> > In all other cases the flag being set is irrelevant and atomicity
> > guarantees other flags will be read correctly.
>
> Probably important to write down that the only reason why this doesn't make
> KCSAN have a small stroke is that we are only changing one bit. i.e we can
> only have one bit of atomic flags before annotating every reader.
>
> (Source: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/kernel/kcsan/permissive.h#n51)

That seems a bit specific and technical though? I guess since Vlasta is asking
for maximum commit message pedantry here the more the merrier...

>
> > We additionally update madvise_guard_install() to ensure that
> > anon_vma_prepare() is set for anonymous VMAs to maintain consistency with
> > the assumption that any anonymous VMA with page tables will have an
> > anon_vma set, and any with an anon_vma unset will not have page tables
> > established.
>
> Isn't that what we already had? Or do you mean "*only* set for anonymous VMAs"?

Yes... I'm going to expand on this explanation as per Vlasta to make it
extremely clear anyway.

>
> >
> > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>
> With the nits below and above addressed:
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>

Thanks, though I disagree with nit below.

>
> > ---
> >  include/linux/mm.h | 23 +++++++++++++++++++++++
> >  mm/madvise.c       | 22 ++++++++++++++--------
> >  2 files changed, 37 insertions(+), 8 deletions(-)
> >
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index 2a5516bff75a..2ea65c646212 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -518,6 +518,9 @@ extern unsigned int kobjsize(const void *objp);
> >  /* This mask represents all the VMA flag bits used by mlock */
> >  #define VM_LOCKED_MASK	(VM_LOCKED | VM_LOCKONFAULT)
> >
> > +/* These flags can be updated atomically via VMA/mmap read lock. */
> > +#define VM_ATOMIC_SET_ALLOWED VM_MAYBE_GUARD
> > +
> >  /* Arch-specific flags to clear when updating VM flags on protection change */
> >  #ifndef VM_ARCH_CLEAR
> >  # define VM_ARCH_CLEAR	VM_NONE
> > @@ -860,6 +863,26 @@ static inline void vm_flags_mod(struct vm_area_struct *vma,
> >  	__vm_flags_mod(vma, set, clear);
> >  }
> >
> > +/*
> > + * Set VMA flag atomically. Requires only VMA/mmap read lock. Only specific
> > + * valid flags are allowed to do this.
> > + */
> > +static inline void vma_flag_set_atomic(struct vm_area_struct *vma,
> > +				       int bit)
> > +{
> > +	const vm_flags_t mask = BIT(bit);
> > +
> > +	/* mmap read lock/VMA read lock must be held. */
> > +	if (!rwsem_is_locked(&vma->vm_mm->mmap_lock))
> > +		vma_assert_locked(vma);
> > +
> > +	/* Only specific flags are permitted */
> > +	if (WARN_ON_ONCE(!(mask & VM_ATOMIC_SET_ALLOWED)))
> > +		return;
>
> VM_WARN_ON_ONCE?

No, this was on puurpose - I don't want drivers (incl. out of tree) abusing this
so I think this should be runtime and explicitly clear. See Suren's comment on
last revision of series.

Obviously we should never be giving drivers naked vma pointers where this
matters (and actually not sure exactly where it would), my mmap_prepare series
is working to mitigate this though it's in a situation where the locking doesn't
matter.

Also you can't use VM_WARN_ON_ONCE() that way, for some reason we don't have it
return a value, go figure.

>
> --
> Pedro

Thanks, Lorenzo

