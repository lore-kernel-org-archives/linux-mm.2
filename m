Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8C8CCDC196
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 13:05:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57ECF6B008A; Tue,  6 Jan 2026 08:05:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52C496B0093; Tue,  6 Jan 2026 08:05:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B9C86B0095; Tue,  6 Jan 2026 08:05:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2568D6B008A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 08:05:08 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CBA8E160545
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 13:05:07 +0000 (UTC)
X-FDA: 84301559454.08.B80EC36
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf18.hostedemail.com (Postfix) with ESMTP id 515E71C0011
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 13:05:04 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=arliCWvK;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=fLcFUcdb;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf18.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767704704; a=rsa-sha256;
	cv=pass;
	b=tEbwMwh1WdFuuwCWywLkFfqBe3lPvawErkuZgUxUIf3WanhuqAPnHYKTe8L3siwEH40fGM
	n0cUE5P/VnR4nN2XalttIwUXBX+zQzRE2yThdLtTxrUvX9GEfkZpSY1viGLscc65eUT5F9
	qX8/7/FGH0L43N2vkjR7Lyn7C0SUsFo=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=arliCWvK;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=fLcFUcdb;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf18.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767704704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E5V8OAy76gs/TULG6jbbt2TllpHRw9fmjCVoyJRgQws=;
	b=MGBsPNA35fcAiOwEgzlu4655Gu5foewN2ngVff/cwkEddORGTRup4gVMT+rHE+1B684mvC
	QJ95vQe7v+KWN9HwxVfHRl1YdPHkNYEharORSJI9iFHkkK0CjtSfGMaeOVs991u8f4GAz1
	yMPEDrU9foq3bJPVV0LCzRvNUEtksJA=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 606BIcaV3417449;
	Tue, 6 Jan 2026 13:04:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=E5V8OAy76gs/TULG6j
	bbt2TllpHRw9fmjCVoyJRgQws=; b=arliCWvKqubjRLy0ra8+t72NHTkSu//edi
	9eoA7WZ8gTAMGn6IjyJVE9Yglp5USJBAXoddrSVh4FIXMRnq38z4wVQlFVoUe4Vx
	fnUFrCXk3+jfwBBWP8R9oOhVeYRI2PjXvbTWbJsOM0nTZPk3LDmbz20BqI+Ed+Ld
	vGHtwuisWYfVTAW4f8gdiE0DwlHGNnCPi2xTPHgZjhtYUYsjDJD54lXRmfYbf+qF
	X15R9cXKVH5jfIZOpk34FRcC+kgf18/ZhGf75gHL/osPVI98O3b6lbf17hC9Z/I6
	LVP4zrxhp2zF8yNrssN+sC8EbaC5iLbOfzzTrZuH3XO69Pwfxf4g==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bh1ddg336-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Jan 2026 13:04:58 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 606CREAn026293;
	Tue, 6 Jan 2026 13:04:57 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011011.outbound.protection.outlook.com [52.101.62.11])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4besjjtw5f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Jan 2026 13:04:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZxM5sIGttmueUWRmeYxQiUZlj5Xh2I5YQGa0tgmTCqIW71PETVt0CzVSkuEYLat7vrzpuxuhzpMhCGOl3kPPzwwN41Y30G+j40KXIRJT+tJzEsRd/IfZtZL5YQRfvKFTQ7J4VXErDHXrFVIVxSRFIEFw6YaYd6vlfqsIyiIQgPOhut1H58duffUQASVJW0Rl91oOQocFNxFjqOOPrbv93WnVp6q+wQGehQsocf+b6FTltom98MYAwGnZ+lcHGloByxx122qP1xMD53cq01yBNWOV8lSIAEBmp/LNGu2i/uZt4ngwGSdBnA90+7v1MGQ/0dfn/Cbfr1WRexdOTTcR+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E5V8OAy76gs/TULG6jbbt2TllpHRw9fmjCVoyJRgQws=;
 b=rJBF1v8zAn44NN55S8hYt5OYAg2U43JyqrTaYXZ0c6Z62NY2Jr1ZHNkb8l1KfNFwYFfSwVRkSG19U2kyEoNMk0QVdyu6plFKjD3hfiQf1IBaRfffFEA02Gs3ZA+wP6lHV1JTsJyT4G+edD6YrKlsfp6+FIoyLlqxAXFfbQLJ8qfBKanQ94sQET1I7L9V6nGVO3gxVK6uWc7nlgzLs7rsGkG16E3YBZoDTYsVIOP7oa9UK+Dh2Cmf9I/B9aOAs+nZRHX6KvPw6E3f39S0dNja19AHyFD+t8+aKxZzzTYfhSYUH/wOqN2sNfvlowY3VFIKxaj91cYeA/FxBUgXLv74Vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E5V8OAy76gs/TULG6jbbt2TllpHRw9fmjCVoyJRgQws=;
 b=fLcFUcdbA4avIymo5p22/l82oq+vHhI+8NbKginZNX8L097Jcx2Zsamhjwh173MjJIWjDHqfu+IWJv7BuIVGabX+DG4Na6dXGUI4gSH5v7kYniD33osZFjXIJ78gCfTyL4UXEKpB/JvecFD7z7n3SARqx5kQlCQE73ctcw9EOyw=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SN4PR10MB5542.namprd10.prod.outlook.com (2603:10b6:806:1e9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Tue, 6 Jan
 2026 13:04:25 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9478.004; Tue, 6 Jan 2026
 13:04:25 +0000
Date: Tue, 6 Jan 2026 13:04:27 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>,
        Harry Yoo <harry.yoo@oracle.com>, Jann Horn <jannh@google.com>,
        Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
        Pedro Falcato <pfalcato@suse.de>, Chris Li <chriscli@google.com>,
        Barry Song <v-songbaohua@oppo.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] mm/rmap: improve anon_vma_clone(),
 unlink_anon_vmas() comments, add asserts
Message-ID: <aefb737b-5b82-4681-ac84-798425175ede@lucifer.local>
References: <cover.1765970117.git.lorenzo.stoakes@oracle.com>
 <3acc90a8613d5e2ea8882d60b5677228e6fe624d.1765970117.git.lorenzo.stoakes@oracle.com>
 <fkgm4eqdwymljueszhsfyvm2zksc6x4vagca2mlnpl7vtawap4@d7obev7d5hce>
 <CAJuCfpFYQasYVb3ds_-55aqhnjBaX2oH7fJ_wJSPZQybiSrAPg@mail.gmail.com>
 <13c66c95-ca0d-4711-b755-676ec4066811@lucifer.local>
 <f5291639-042c-4ecb-8e7d-8d0fbc8b80ba@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f5291639-042c-4ecb-8e7d-8d0fbc8b80ba@lucifer.local>
X-ClientProxiedBy: LO4P265CA0318.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:390::17) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SN4PR10MB5542:EE_
X-MS-Office365-Filtering-Correlation-Id: a5620060-1a5c-45bc-d00c-08de4d241e12
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0tbf8VMYpoaWDRHXbNSIkS8/aHC6zUI5Riz8EXdd8XmrA2H7lq9gRr0kYeXX?=
 =?us-ascii?Q?tbI/9nyxxHl51ho+EF69kydGj7iRCYRQ0w2Ej7kmXcUfcN9uOGeG9EvCZYoO?=
 =?us-ascii?Q?uF6vFyAUAGLxWMBDqzavxCUB803ty/0XhvQEDjAAJu/aK3Gdxo86FabFEM1D?=
 =?us-ascii?Q?F9j+rBf81/erK/frWshX3RzKaRwBswOVhfOhJtRF/mPjGQuRjrLBmWeUjECn?=
 =?us-ascii?Q?bspfwZhiLD/00a1xarTOlTZRMps7GogEee41zbfMZpu0hfuAn40T/Yiu+jzw?=
 =?us-ascii?Q?oOuoC8dF2PLyNtvv6dhpN07ZT51S1Vz9QZTyYhv/gtMrtfUBeqPrvLG3sXUn?=
 =?us-ascii?Q?PUq+zjovUOFboK4pjcdY5SDejLHjSG0/ovvK17q3EzbChNX29opVNKJgCeDe?=
 =?us-ascii?Q?d9OfSeIMeB2fIN7mUbO4n3j9JB1HjmW2Lih671vb1vvBDDUfM3oGXlnLRnt9?=
 =?us-ascii?Q?BfbaQO5L/F92argdn0d1MbwLi7ecFHbbfnTPZtinGdAX/LzDbCRrRol+30fz?=
 =?us-ascii?Q?ob5kjcBqc1CJ9HYrXUaCitVZyvdeEECopRVJ5Bapb5dLFkhj6xUGUBbSLFAg?=
 =?us-ascii?Q?/SzgoKrrIBetAeR0f4PKYLWeT2K9Kz9hvDWGmO3XRJoIXijqwvaElLLbcref?=
 =?us-ascii?Q?uqngyHT9zlBGoNv3XXmbVTtuoK8oLMtUxFTr/q0cBDatxdByKbAIx6lLXVFN?=
 =?us-ascii?Q?Vrlp7Mukk44CVL+OkhOo02VIcHh/pR+GDJqy91KQKioGufvkyP9xJ5N/beHe?=
 =?us-ascii?Q?QGLAS7TBin5V7VPhHm4TTVjyKJ33AcdmZt1gUs6nPZbZtzQe6CooVasuBqsI?=
 =?us-ascii?Q?kGDRg82FaydQifzosyOPBWrQmc7V3N+3H2YrdOjisaPXnOhvJtiBiUlRUPCl?=
 =?us-ascii?Q?laoS6I2xHEtj1xIUOoyyWwjX4FTz2aTjsuYZlcJ1OEGCxh8ibB0nh/H+zhIu?=
 =?us-ascii?Q?PoXnh+WEQGNrX1D6VecZzsUkQdnMFFyLGhj4w4PYRI2nmxKv+m9GDj4h1V3F?=
 =?us-ascii?Q?c5l6PFKL2J7pOvLoy9PS4ovYGZODVBYOplBT7pjQ5ue7J0D0yPHrn/NMxGvY?=
 =?us-ascii?Q?VvJwmXRUSG3KowfessZpdMo4TIjmuqJQNE7DAZyY0kzJ/ZWwJihgIKhz809w?=
 =?us-ascii?Q?U3TfCSIEiayu0q4tDSANNMnlD1jEfn2uIU1sFvF0gFrNLKiW2lZTr4ZKC47U?=
 =?us-ascii?Q?rkbjyG3r3MiTvdAGOrP9yA0XDz+1Rv3zDIPcTvio3vN3Q/DBxSAbRmlkrwy8?=
 =?us-ascii?Q?/ver0YxaxowHtgtjzEA+PtZE0etNcNLQ/4LrxdA8ueq1Nmu+LL85dKY+p/EV?=
 =?us-ascii?Q?wNkOJ5PyQUG3a0LQQSCv0XKffwaHcQwqV0GM+n/JxFs4CqS01x0F73HoWhyb?=
 =?us-ascii?Q?+iaGlBfuSVy+3EhCrJcpi+DGULhWWpUwk30VYUFTIsg6FwbS+sPy1/y+XOcn?=
 =?us-ascii?Q?R6W/BLHoiXmyKn/PT6xhhcb8Xm644xxy?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XFFk91udn57yPj41otxhrPWsV3s+pS2HQTlNWyC8MR0vBaeFEKfi/gcEGzwj?=
 =?us-ascii?Q?yKU8g2SSEnkMZgZHa1FfaBzGggvKCRLolWUyKwpgqsTgkoQ8zrEtTcFyGiN1?=
 =?us-ascii?Q?sgkGanrKC3m3SwRspyf7OgRujQBO883tloksOR7RzFR+yxW0aKBf0HQNnazZ?=
 =?us-ascii?Q?Er1DHfTAg5278FPZLZ7Q36PPSIMrmquVhsp+tEgl0B9B6cHhih3/3HGEtUQF?=
 =?us-ascii?Q?Xk+6I5t6ipM6RybpKBx4C6JT+q4W37y6T77ya0MD6vE4tsEyVKpWUXDhOCIS?=
 =?us-ascii?Q?6W9C4WNgcZHVUBpyKDQ678kTyVOvvkGrdftbJ5zSR69guFcAit7U9LXbFrVX?=
 =?us-ascii?Q?e6q7x1nlSTyrZrymGsUDkdB8TTyC49rY6W0+T4i524N4DVZzgZtlzDE/yP+d?=
 =?us-ascii?Q?Io2CounDMmIeWM/AECh3fgIgnJRPHG9Bf2SeDjByhnJNffiEFdnrf/4+/KHr?=
 =?us-ascii?Q?GtUhb1Ir/miK/AtPcNQrTlWSiBBfje0pTtIbKwQ4vLr3pkfqRp3072s1vKQV?=
 =?us-ascii?Q?3+dEzOH1WMy/UIjQYLNWZ79PcJYqKg0SWMD8Ws3ZF1Jym7yq9ggG/Ku8PsxJ?=
 =?us-ascii?Q?yi5v9ogWDCp9Rwj/mviCSePt+47/75K68is1ljIIDGQYYY087UV73s+Gijfl?=
 =?us-ascii?Q?aYIxGjz33AJr4gr14Equ+OQ03hEyJnei4Wyie+Oz98DdjFHPBpV90oNO6sh7?=
 =?us-ascii?Q?KZmsNKxkMMhlUlu+LD5SYpymmRYWG2Bl6D/LxaTQ9FVGtCEN2hdHGsOTW4bZ?=
 =?us-ascii?Q?zPqSB6WPQJHNiwbOY2z2sT3wcXrEpsAGZe1KjnbO4dQxE4YEv1ApVaEWdTEk?=
 =?us-ascii?Q?42wJ7vh9i+AazYhpIbxamaDQh8bZlPlBlqoWooBG/a5LsEjWt9zCuQ7k4u6M?=
 =?us-ascii?Q?Y7WBkGsLSV6qwb2jyIUYDZV9V8DCoKp3tqG/Yrb4N2X46X5sXBS/6L+nmpJV?=
 =?us-ascii?Q?3zDjcwQODcAJpm5WX7444n0HRjXzMmBwjCxPFZTyjrNdlWE4wQ80A/HZ5aal?=
 =?us-ascii?Q?DOx9Al7CN+9f6M6sXsTa1fCeVddiNywGEYv+RtoQviWRbzGyBXD8ZNVD/KgB?=
 =?us-ascii?Q?xfjNtvgK3+z2Ov7muC0zkIpoNfO4YoNXI0LoABkHiB0YApI5nJ6Uu57wcnNq?=
 =?us-ascii?Q?fHkWSQe5RHdtW5vapA0zWHrLxjDLfADeA+KCVEFiTePxYi4zxFztjaBLjZQ9?=
 =?us-ascii?Q?TDKZKBX350+CpbDgSnbflZTFYF7bQFx9XfFALkiyPlyTNSy241jvQCnZ8RGp?=
 =?us-ascii?Q?aFkFbf7avmqLyrgDa/F58dzCLFqDk1UmLZy1TGW5T4fQpEXLq626bDv01H0R?=
 =?us-ascii?Q?uoocIhmJBk5ODYrnVtyB612zgaYWs2TerMjz6N/Bs7KmGyTNbL9Lp3NDFO4I?=
 =?us-ascii?Q?ewcnh6Lyvirlu3LvLXu0ZGJZv1vc+7p4vxMBRDS3PUHjRfiPCV2nlfNigoZ7?=
 =?us-ascii?Q?sK/7q87VgVmd0go5jiU0mU2UPBKvhzmTScjQ848SOJh2ap1w19F1Amg871sk?=
 =?us-ascii?Q?Uu9Xuby2avKqe6VDU+2GMi0Z57daxIgY6MZYaAEJVw13DZk4A+RwOxAdv/7J?=
 =?us-ascii?Q?0mJFneqLEu7W0BzqMq11FGQpln8F+WxD9gMLzBtU1xXXRQwkKGDuTNnccjdX?=
 =?us-ascii?Q?KXTYYbf6bIfo0eeejKOlDJTOaZ8/GAqAnBIBAVlwpsCsfRDCsdyAhcH0HR8T?=
 =?us-ascii?Q?hhMaj2KrdmB6GSyukczmJYGtz0aRLKC6iG9qFso9njrmTu5VPeysvTFNTvtj?=
 =?us-ascii?Q?R7A43BqZSLg5/HU8Myb20cHRkRWvF5c=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	4W0LgC4GFRA64yuAUFI94mTVAoL19IRJlk0offayzrdmt8qqKGANLXXNk00we3BZQm6R4I0N4aSOvOL9xOYNQDgf6o4RXbqu87HOCrwDKcXcS0JQCLPmN3ewfNHKLDAy+b7epxx11A6s6ah6AGxbpd1Is8Au0huzvA8pc5KRi/8laRXK44tKHV8wQONIAYE5ogqYRpS0Ul9dVUBtNw8yC2PmNdeOn0htAkoGJ3IdCRdftJ39d8A/wWeZJ75c6TNCIwPDYCNnyEjohTtKINyifdz2k0d8HU/PsT9im0Oq2wzMKHC1N4hMHCwqnNdnyGZD1rw+bxwaSf0LIfhIszIYWeAaMb2cwi1bPASN6g4JaL6RZbeCwFXXxe2P9WnnRaBCB453i63M8iFlWkzY0IMYz1RcZ9rlZVRK06rrc3kkgg0YZc65elFvpXfNwxWv7VdXSeiAhGdL5SSc+rH9mL60AO9KbY5m/hn93A9/CF3hbxQV2zPYrH+WAEJ0/gd2ozKvueyywbYYpWcOY6kCZNSznVjjIz8L5c5EN94HqaMq/E8y1k1Xtq5yUf7+ZohVavA66PJbsWPREaxCSEfv7WY+VzabaQ/narys8ckLTb74KrI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5620060-1a5c-45bc-d00c-08de4d241e12
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2026 13:04:25.3322
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y1j/SC3CfVyUTZTRcnfHhg9yd5ukbpBL1fmlOWEiYkya18SiBpOU2IrT0KVNTbtrDihsaV+ZwlWcDC4mpUnbW3TKTlr6rY5ZeCiHC9nNKpk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5542
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-06_01,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 spamscore=0 suspectscore=0 mlxscore=0 mlxlogscore=414 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601060114
X-Authority-Analysis: v=2.4 cv=donWylg4 c=1 sm=1 tr=0 ts=695d087b b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=gCImj9bim_luLxg-OYwA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12110
X-Proofpoint-ORIG-GUID: M4sBmWttVfjbZx4NN74J3XBJ2OYISqd_
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA2MDExMyBTYWx0ZWRfX9x+OZGH5JFmx
 65PMwZm86/4oPrvFGSPlJwdcTlfWrq0R0dOXvVnJ5PFQPsXqqY3UgR7mgA0LD9xMWR3Q06jkKai
 afBBVy3SYnoOaETMIaoiCgzvcmp+El8ZleowAKEdOzFEwe7c3eyrI4ynFlSfOzvAOvZyP4KAlYC
 n44JjzDZf5DoRCyG/eOK+znq6baAx8b5ZJWpE91avs5zpyMCPWigogUvmS3RI+jBfjOARd8JefW
 RMeUrVaHgLN6F1B+HtC1pu1GGNmdJhgN3ni+zVmdeW2KApasEieYiOfo1+D9tGB/Uz7JrTV0MUt
 k0wbVTZIlSoqKzXFkTaDc+Av38xI1v7zphGITkh2QOuDsfW2UXH4UbdDG5st+IdlLOMGpbAH274
 Q+nLHxUpzmfgNOyYloPlr+jGYxafoN8EYoZ98PRla/ZhiBbFRqUZ6ToNXyFA1QV8/kUPo9RVzc6
 66TrQWChj7P9QWhntqyrqdqC3XEM1SBZsipzQtmM=
X-Proofpoint-GUID: M4sBmWttVfjbZx4NN74J3XBJ2OYISqd_
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 515E71C0011
X-Stat-Signature: h3frw4aki5zrmbqh78d9eo4f4yfuxsd1
X-Rspam-User: 
X-HE-Tag: 1767704704-72926
X-HE-Meta: U2FsdGVkX189SBWDK9kbkK2tS7yXdxHMUcPqKNDBUQclEVp4KKHGfk5z7zaEUKp6MSejlq6UkAO1x0E3ksdofTIDl8AjFJ/MmgcfcqqH9jRf07ClMZEyrIvEIBRk2/7PJ4UvNhEM2Ua/7GnnJxPBkmGK30wZNXVbm16uUpGXpkCaXFNWnFUf2G5jHUaCbQoWaCddinzOj3kkxqrpPH9jWxY1mpHHTXAzrH2fn7Jcfo1lRVdkaQx+0NbLDqktATohtmdBzmYJGMCGDUrO+9iviSMtp+gQArV08FUeWoPDEH0ssI/dOau1vp2Pikby2KPjCdzmZ8Av7si34FwA9bSHPWY+Ld5fck9QmZbaYmUjvZPpxvgU8OnwAfY7uUDcpPmkek2F9IGRYq5IL/7lSxIY7Sok065Dta3JE6/P35uSlUJOMWP2tOyfdaLOTvPTAP1fwhZ+7986hXaowG544tZA4riI2SokpD8UUYTz0wf0YM0JaXnJyGl+6M31fZ158GtwQOQ0ioQ3fOZdbfoOXpWwqdLBx3FX9uaZpY7ohaYvNforPqTcEXcYII9Z0XM4F0bfGf8kmeMMWcoripRsNzydWmrcxaJKTNgasJ7touzPidlUNkCNlPQ73FdRfM9iyMyJv1aXFrYzgzEPkwb68qOERte5TIP9WPcAveuG3C9JAcl6Q338XWxan8Z0gBzBX6NdKwjOC5jCLroVlPwWOFnpbj03nTWRc5CmOTXq5Kzfzz2y0N7ywO4nEzzFHMqKteLtUI0C0xqT3qKBhAFXYk67L9+eYWeo1xbCQ2XT5p/AwawnqGeT/TephVqcLDfCuDYFOKimu1V1fojQg0AxWoPXlyItjiIIgonFr/VFDzM3cB8JyMT6SonQlf2jXm+5ni4V20zxnjNlE+4to7NjnqQDOEeFxHd/E5x/6SrqMyIemScXWLwxpCz3CYlA1FxXrQssWOcg3s6IMviXZ89OI1n
 Syz+1d6i
 kMfh9GfGcH2N4iTDi3mggBgm2Qz8GTduKeT7W6kkE99yRb6MmG2hbWWb88CpUUs61FphLH3yOwxwM2adfV8FQccn4tgE5qKdvurj0fvOXl/IdsTNY0a8JKfFhd5yZ7Sz6vpeXnvc/avVWYzB68OSTjxshCnrimAID7wEwny0dkfFcZ1mKoxIpXjRtYGU0mWffVlmCB+ihdRvVdvQ27WUUAk6tydFVUq3ebJWZnVtOs180HauxM8iG6+FsNE44hhl9mTbPHAPXr9OnhrL093LXiJTCqsISCtyHwVCZOutWV7U1no/4NLJ0MKmpy9i6WhE6wfSOtLcWKQRFSaw6RN5IABFgRvqvaDaMmeYgsxRtr/7ZMZvL9vdCjjEIF7r8qbj7a2LA1WS9cK9wrdfOij0azzZMYo7/sKOneRv+X04q2KtUNzPkkTS14CC0+JdloO4aSGehZvF3pfroSqZOs0GXiHqnXJVeCwNpiK+R9kWRw5qq9s0tW8B3clgeh3IMrpulkr90PMtaH6uNqoiIyYVo2GBWk3G95DDsPNwFFsuoprjGQ3aoYHV/H74XGCm5IGpeedI/k0wvwJbtBjwa8nku+3q6OLGritOUlLbWfGZUM12NvJctMwOAcYR0WA38/75V6RH0RpnR8c6Bgkos6QDbOQCn9YCD6JxQr6DLB5FYzoggC3E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 06, 2026 at 01:01:15PM +0000, Lorenzo Stoakes wrote:
> On Tue, Jan 06, 2026 at 12:54:17PM +0000, Lorenzo Stoakes wrote:
> > > > > +     /* Unfaulted is a no-op. */
> > > > > +     VM_WARN_ON_ONCE(!vma->anon_vma && !list_empty(&vma->anon_vma_chain));
> > >
> > > Hmm. anon_vma_clone() calls unlink_anon_vmas() after setting
> > > dst->anon_vma=NULL in the enomem_failure path. This warning would
> > > imply that in such case dst->anon_vma_chain is always non-empty. But I
> > > don't think we can always expect that... What if the very first call
> > > to anon_vma_chain_alloc() in anon_vma_clone()'s loop failed, I think
> > > this would result in dst->anon_vma_chain being empty, no?
> >
> > OK well that's a good spot, though this is never going to actually happen in
> > reality as an allocation failure here would really be 'too small to fail'.
> >
> > It's a pity we have to give up a completely sensible invariant because of
> > terribly written code for an event that will never happen.
> >
> > But sure will drop this then, that's awful to have to do though :/
>
> Actually let me just update the stupid hack exit path code to increment
> anon_vma->num_active_vmas in this case, and do it that way (so
> unlink_anon_vmas() drops it again).
>
> That actually makes the whole thing _less_ of a hack as it really makes zero
> sense for the anon_vma not to be specified but to be working through
> vma->anon_vma_chain, and that's a very important invariant.

Scratch that, this error path ruins the whole thing (we are assigning anon_vma
later, because of course we are). How I hate this code.

Will rethink...

