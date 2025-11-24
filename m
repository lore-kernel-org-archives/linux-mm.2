Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 223EBCFD318
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 05:18:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65FEC6B0011; Mon, 24 Nov 2025 00:18:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6108F6B0022; Mon, 24 Nov 2025 00:18:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D8BA6B0023; Mon, 24 Nov 2025 00:18:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3CF306B0011
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 00:18:46 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BF9AAC020C
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 05:18:43 +0000 (UTC)
X-FDA: 84144345726.15.39A9821
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3A22640013
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 05:18:40 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=aZuEx5oh;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=JI+qydaj;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf17.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763961520; a=rsa-sha256;
	cv=pass;
	b=LQH7BV7eLBsOqfom+8yj9df7xVhXTJ1ZOyNleCNfCTx0sR6YdwJACgKShSaq9x1DuokCpj
	NaxMIuA7gIEdcdII5u5iHZ8JuEm0ye1hdBeBRFFtjclgHgI0NLL5lbuuZVsOYM08oukB5/
	HxtRNVqcwpZ6h8edwWmZYAmFzDc7Qjg=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=aZuEx5oh;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=JI+qydaj;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf17.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763961520;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ACzeXKnFtfzouJxR+nwtOBa3zjrwhLZG9KVvJGkACMg=;
	b=tMXRntIDe9Cmb6kS672/npWRRnKn6YhRk6jvRhkUpiufzeCK9xsn+otPuclVVj+xOpqVSn
	ZQgIQ59D1ROp7J5PSp+lSw7uf8E/gSQM5wOLaHZ91eSNbe+Nt2J66trOZsl3sfw9hghIDh
	UCUVrFcEK7DgJJMLftyB1T0tDo+b1B4=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5ANNXpEX3958873;
	Mon, 24 Nov 2025 05:18:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=ACzeXKnFtfzouJxR+n
	wtOBa3zjrwhLZG9KVvJGkACMg=; b=aZuEx5ohxFFzt5SglfsMwjlGpPQ72vwECt
	KigyPDUTZzuH/kQpQqbwNOuyQrqyqXGPcenEM80hQbs/51K6R0eZTqnG8vOWIST0
	NfoKcXC9yNjRSUrPc2iYVR9wObXk90kk37pkallWOSchzlYUEs1zvBsr/3inqMRc
	yPoTW4szhEmNyeL3uo83t6F6U3azmccvqotaSmpFIT/XxzqEoVrfiWT9NvsOIZMS
	i7n632qv2ALelbQ3LWFZdOLM75lMOXoFc35+l0cYt6Hf4an5fTSF+0lRswkg4ReL
	KZxxmhpmV8c2d/FcWim8vbjb7Ym9olIYUhAv2R0BGzcD7qJS+PgA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ak8fk9bs8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Nov 2025 05:18:29 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AO40bBj032644;
	Mon, 24 Nov 2025 05:18:28 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010045.outbound.protection.outlook.com [52.101.46.45])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ak3m7nxgd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Nov 2025 05:18:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nCmXjVxTjI5M8kaoE14IZVLZUGUw+9yptf0w2BbM+X16wF1f30ImBNdEqPyQHJCMzYzbE904jGp5luib7lgyy45v7QA/CDYLW0M26KojlWuPksqoSBuh/j1m7o0EXLaO8jbBSzedn75D0U/mP+F0m1bW8i0ZCVJ19bcjtV/xoGca3QLAvJ/rhKeeQkgrsESOc86GwacdxEat8hOhLRoGBETJTReqjaREaA2vhcy8e7Tzi3ePXIsyZU2JZP4LjMjabJ31etYz6RAvMTZ3X0zCmwgWpbm7zcawRziP91uyI3Rg3Q3kbXDuENEyXkVqsSwEfh6UPZOw0RzYheyYhnNABQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ACzeXKnFtfzouJxR+nwtOBa3zjrwhLZG9KVvJGkACMg=;
 b=o3/4omSRLbeHfBXYmOlITzWJhRVyttnoZ/9DtLqfACGlulY4SxFTSWg+RQppajLVZC7Gj/CViWU7/ujNjej5H9Fy7LFmDawkW/ERA2hNBh+ltPHVDapnJZNmTD7VyVRxJIATeUtRT5sWlv6tz7wbxUMdK8tDKuVFor/6oA0PZIprEP3Im86/0Y1q3/H8L0kM0m1RWE94MVKUG4ZWbXKg5n3yUEEADixpR7PZHCh6EqIXjrKYN6ldfibxFUMa1nAq1iVEITWi8iLN8DujEF1uRUpgGd4KkWLZ+33YCNH734WUxIzIQIMBIiz68oEK06HC5DqKASRsc6qaeOCwya/gag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ACzeXKnFtfzouJxR+nwtOBa3zjrwhLZG9KVvJGkACMg=;
 b=JI+qydajQLPHqe0T4YabKdWQJJPN5jSteI0NyLUIptPzaYS4ECef1OfE7Ei4sEYGVHTsms8lcRuHS4v1T0B2BwlwJzTbgmRoa519R2lqfz/091fTFSEN+6q3GFqHNUz881LLhmmGofhdI/BdEcuYFmxAY3Yid0v2kHtXS/1RGJw=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by DS7PR10MB7131.namprd10.prod.outlook.com (2603:10b6:8:e4::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Mon, 24 Nov
 2025 05:18:19 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%6]) with mapi id 15.20.9343.011; Mon, 24 Nov 2025
 05:18:18 +0000
Date: Mon, 24 Nov 2025 14:18:12 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org
Subject: Re: [PATCH v4 02/16] slab: Remove folio references from __ksize()
Message-ID: <aSPqlBg9y662wHXH@hyeyoo>
References: <20251113000932.1589073-1-willy@infradead.org>
 <20251113000932.1589073-3-willy@infradead.org>
 <aSPDauAEYs_RVNW1@hyeyoo>
 <aSPe5P9Oo9ToafiS@casper.infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aSPe5P9Oo9ToafiS@casper.infradead.org>
X-ClientProxiedBy: SEWP216CA0137.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c0::6) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|DS7PR10MB7131:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d32b598-615d-49d7-b988-08de2b18e09e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?C9bm2caAe10pgrX0SoeEKyAXXSe3AgLFf6luyH1xfTBmDCRG8ZgtZOCeOSEQ?=
 =?us-ascii?Q?MdPgHj3GxH+QcHoFpqCVHrsWvH51I3PfOrelWkgvwyU9J9E1uK4hMJbnqsBE?=
 =?us-ascii?Q?bcluz3QgQT+eZurkdzXJx4qowR0UHjQWpXWUI6E0Tb1fMwVGt/WJltCwTaPs?=
 =?us-ascii?Q?vR3v1BDGdvSgsVeDZlOxKeCPpCfpEqYj/YDWx6zA5QHgnacjZJbRbPgqDjJc?=
 =?us-ascii?Q?bfraZEyXM6vKVxcGEfZc/KkFWqghuk23wCMfFGnmXK+xfG3RukcsUVfqkH9Y?=
 =?us-ascii?Q?ohqHH4SRj0QHVKdvV9GM0wtL7OAAhkPhPkcRdaBEZBPOcEKRacCtboToZ3t+?=
 =?us-ascii?Q?iyft+KKjNreuFJBhfEKOCGs74D0fv1mo2Lphk14ZZ0BsyPBxe2Tv6MC1c1Xm?=
 =?us-ascii?Q?vFUgRd8BMoGDxtmCcEydB25cyd44TM/Trmv3Mjj6LRChvtgWWk7OWBkzTp0r?=
 =?us-ascii?Q?c/1vqK3A4wD4w/q+QR1Vo13rGz6H6BovUOyPT4M3QZADYnbTiDhQE/1uFayy?=
 =?us-ascii?Q?5R22APDo4+6WDRp9I7tKe1rTIvhaOQ6ce+PMZG6Rb87LaS+dlPkvklSXOQrW?=
 =?us-ascii?Q?V+6oW3T28gM1yBzbxa7d2unnfaQMOYJ1LkjFHvP1fvCwZpmL2KcpHAbeqCDP?=
 =?us-ascii?Q?FdfZUPn2VLdfJVIhuoVNNE6XaWHRY8Al3TKK4Fo564XSgheU0zz4ajKMblu9?=
 =?us-ascii?Q?7td+f6A+GfPV1SqC6RBQAk1zvWF4Z5I97YP9SRpIB5c55eZ9Swu/0AQpyUnv?=
 =?us-ascii?Q?rSfSB7dpGl4DTx1otO5px/BtnPrXs5cBUIrPWC1lhq3WRBbSwQcgRVXPRL/7?=
 =?us-ascii?Q?immImGxgB6txXW70msKLEKwUHF3RUM4HspR0IOK3l5xpVnG+RNnH2B2FHhXp?=
 =?us-ascii?Q?U074HxCFo8XmCU9bw4viujGr6ZqribVYY8c836oG5wNhvtYAP9HoVCggLYrE?=
 =?us-ascii?Q?Ws7YlXrrXEw/n+8OKaNa3skSaP410XRFMX8yWcke0i0FC4oPI4sc2DGXFtZo?=
 =?us-ascii?Q?p8an4oi7cM0uhpkYZn6yZsxALvh4oUKCK6veuU/Mw/yVDknxLD31rXjOXN8C?=
 =?us-ascii?Q?zNJLdaEBeV1ynWt6SY3IQeNxWCL0qOiAwkA6rOrBEENThHh5STomi0gzu0TW?=
 =?us-ascii?Q?/fjfgDRczSYKVEcZ0D6dQpc6ayRtnr4o6zO3wq3/e9/QOxRKJ5Vd7onmqiZ7?=
 =?us-ascii?Q?JcvVh9HXYaN3hcS4JQb9ViMO39JqElrFXJwGXqrZYKHYnm9B722/7+Jb/Z8f?=
 =?us-ascii?Q?1gmsuiwW2VEEYKH6BAwQooXJao2lZGm4ImzJWfFj/mBoMwQBbKKrMPic4LNX?=
 =?us-ascii?Q?043WS8D2EHtD9ciutfLDdwxjIBb/RReiaLt7HqZyr+9+4hEPkvVn7fJpg96x?=
 =?us-ascii?Q?KeMU25ApGwmeWvMs1ugidd07xbtH1I3xiZwBodL9OzaNCl9QV6sA92z/ZvGQ?=
 =?us-ascii?Q?mg9955lHcbreKMnv64JbbLO8kQXA28H6?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?C70VnzpC0bampn2eUnUCcwWWYhC/nFSZE9imonXVJxGMbfQiY6EIcUVnaIsE?=
 =?us-ascii?Q?yQrMsiGRsDGY5WpTE8SH93JY7DN9dr1thH9IpTU3cuhN0x70uTs5zhTiPaBi?=
 =?us-ascii?Q?ztfLUWmUEjP0m/gDtjz5xWvytBlbMNs+tOVs90pdUcO9LLTqJiGuvlqgwf7r?=
 =?us-ascii?Q?ysMCrhsBMl55GDCO7/fz0eRfw01qRI8qRKRiKdzmjcAcI8nu05Ce5D9SahsP?=
 =?us-ascii?Q?uJ0tsdXbmL1OPnWILj6bxy8WYT6epObPCy0RlFmgblzr3U/hDXz3xBEP5vtt?=
 =?us-ascii?Q?+TyBopcByeH63Rea1GYePkKBcQTJhFQmclUOOypolYKKdRk4biDrYwkJsOMd?=
 =?us-ascii?Q?uCZm2zuUNYnfCyLal33f063I1cSRRCgIfjb60Hs8UI8cdeJ3wShaLGEi4CH0?=
 =?us-ascii?Q?ghO0etjdWY+MmqkYUpSUr+qkrt/D5EyrvMN3uEvnWtF6ZfN6YJu2H+p+fxCe?=
 =?us-ascii?Q?8FpCKNOYg7dhPdWWTMd8wzwVTFyCtj4Lh1Tp6CS3wrvWtXtCjxcv7QVL/4sa?=
 =?us-ascii?Q?iCIjnftq+HZcmmJWeecwgmhzQ1IxIzG+aFEhTxQxWd2+TRQti62tz1iof3I4?=
 =?us-ascii?Q?5Kjp2qMMUglxbZYvwpgJbHpacLs5AtFOSHHaCR/SrM0IPxZ1Zvm2DY73kbth?=
 =?us-ascii?Q?8gYl+RfbJxly6sO/kVY4vNfDj5VbHUxc34TpVf0UnNobfJBVzIwUbrIZndX0?=
 =?us-ascii?Q?gkJsPsKx4pt8hn4kLefPf2bhdlg1PeuSjwYG/7puHeWvnXAKC0tB+T0d54FJ?=
 =?us-ascii?Q?gKBKnio6u71hqmP5NvyV+Asr3U5Hsm4NRGyC+DmIiXoExXGOkkmUGsIX7Gwd?=
 =?us-ascii?Q?FWjCYnCOehbzeRwZqvpoAMSRBoMsON5FouvE272TL7G3FJTQ96L7IlXT39Ly?=
 =?us-ascii?Q?4tG0yPDuzJki5EBHhRTN5Ksujo6xC8S+r4rlY/AfemqD3FtzSkovBDUnKJhP?=
 =?us-ascii?Q?RTCr+z0Mz1RDandhomRCUi63Kk1vHYAHRBAdSedo/XNBTN/ZfrlgYRxizXcP?=
 =?us-ascii?Q?5Hz8zSxYRzt5SUpbGW7DLnnitAqCvC8nVBgaaL22LA0XZUfT8Q6ZThhtSDFQ?=
 =?us-ascii?Q?MPIKqjV/cYMFy9SdJTo0VzrkioHBjMNTkPMh9kM6s6FDnvbgIz7FudolH7oL?=
 =?us-ascii?Q?Of3eDrb7o14elY8e/40kVKPuz9DWoa/k7/CnJlYswMM2TgPbz8w0ZNr3ZAEW?=
 =?us-ascii?Q?3T+o78fzmmftfyeB8kQO2x9DjFXXplRGr0NukyIZKmkGlG/LnKqsROvFSiOh?=
 =?us-ascii?Q?n0dEaExQhPf9nSiXJ6olHjLXuRRnnsvX0Yg6MoJ96H6x21cn1/Lf0Jrfavh+?=
 =?us-ascii?Q?c5GXNGLffpAa6qvBiQYu4ht3x8Pi9+fEvYXEE9D4PUQ7Y+TTRw0zagKMPCtj?=
 =?us-ascii?Q?aOQGvzwfoKWKkB5xDFC3PpuEXPoEqAKPmMGtepM4wVotwIUksErS8+sAD8y/?=
 =?us-ascii?Q?Gx0M0KaAuuWZysdn5Qfz8juPz3X7ex+aBuzIqf+ynfCooQgmT5cEnYjAMred?=
 =?us-ascii?Q?ul7OQKiNc2Ppb3cimdJo81q6nWQ9WbQaZNjf71hg25EdL6+Pzt3U7Tl6u73R?=
 =?us-ascii?Q?5/GMfUiQ05xrzyeeFY4Dz1dTX3p3a7/9lN1Zw+73?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	G8b7PdyEZ8onBbjJNKU9fJg+9m3sH5fis56z3iVYqlxg6lCQcokK1YH64qMayPA7CJwXBXV8R1PGUCQFr/7gfIieICc36UcesUB6G3lUK+tCIh+nvMcAg6s32IATjsBy+HGRMFa85XbzsR2PjtpgpBt6P60DD5fVSUWVyMjISjQZM9I28kooaUI7UPTBlD8gfY2e/AmQiUJHNgbV8M4kvQYZtcSoIOyU72BP/uFRNHDOsLlRRZCLf1Fiho4V3o8Uo/SRF3u/wkE6tA/em0agFN/MDVswkLfFKJpEM+GobxJpBONlY3oLBRYSx9hJ7MJcDgF5JjrWSkxwNhqqv39j+kkwF7oxe7w/wct2zUAIxD2+84cSvRTcsU0XrG2i4ALKPpmOLj7A8f/XQDHyfgRfhSgXs8qhPuIUjbs/0qw+EzLe1TwW+h1MzuylerAnRn/mXB9VlB/4UcWqN3wKsW1F59juVz2424IO+kJDn/5OYmiY3czK9oTaTIPmZAEe/+2EA7ACKLba/MSsiS6GQTfyQeKRcM2WAAuSnDxaKgE/fVnAOqnKXuoRnPJVfTkEKNgz0jDjPCC4umoG3oz1Hlzvcm8VFX43Cdn9BOVxGNyibEM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d32b598-615d-49d7-b988-08de2b18e09e
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2025 05:18:18.5143
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8AfDPQEzvOXii+Pl+qY0M0DZjTZph/TasxjkgYl2QIno80DbhoWYVHuWW5ONeDnbi8oFEpQTuDFheSosL5j6Jw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7131
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-24_02,2025-11-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 bulkscore=0
 mlxscore=0 adultscore=0 phishscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511240045
X-Authority-Analysis: v=2.4 cv=f4RFxeyM c=1 sm=1 tr=0 ts=6923eaa5 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=zsXFZeAdy_bOo5vHGQkA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI0MDA0NCBTYWx0ZWRfX+UctS1uGCBTG
 9xGDMhOqucs0yO6vr1JDNxRGfzwrEvMAwpiStwYxJzCJwgZexoMu9NsXz0zcAOUy+YM4wfICTZF
 dObutrrfIAYnBq9g9G9ekQKMPw2k53NkfvbSAbD7KXhuHK8xdL4b8turNpz6h8j/7jsMC7Ol1gx
 iblyk64cQvkND0292RCg9xHUi0UP1yTeloKewWl9wu3ClUjhwwQ/l3EjQ9CFpM+JCkTH2HNPI2J
 PkrYCHEPZnAKr2RYAKfkNU3qKKKSGHGiqgLj/2hrkTtTdIgDEB7ll8KPRkz2G4HViQRFwjWG0n3
 BaRO9NobvTv1y6Nga77ziPPsVN+HA/ZH8c2PtkqepWPAJXRranrPpb1NTg4KxKkcQeMaC2LFHTr
 7Z3fxLYjLLst/Ox6NVEN4UvgRyg6Pg==
X-Proofpoint-ORIG-GUID: JEIZ6tPdB5_Z95X6cvDppIkQmPkizuk9
X-Proofpoint-GUID: JEIZ6tPdB5_Z95X6cvDppIkQmPkizuk9
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3A22640013
X-Stat-Signature: x1pub1kpxzskaq3rmsumkuk7ir5ufkq7
X-Rspam-User: 
X-HE-Tag: 1763961519-118806
X-HE-Meta: U2FsdGVkX18jGJ4Ytqmhosz3aQ/aLZAq55STAMb0PML/SCTZ1KmgZxdQNzDv+XGgk2J+wlsM9vb53QQ4pl4tOAAb2g2B4lEVQr1O2WpICdMu6RZMz3LAlVnJatXbPKBPyc8G7q4Bqbh3zMxjAeqBWkT39a+5xsHN+TMB3anjtceDAZLtGmdMtQp7e7/wDdP4ZfVAriOuu4yqlh9nxKtXVCY0hA7WhecwWGkOJRMXM3HbCuCynxrhSyniBIz7RpEzYlPlWLvCPgtLCWgfO4Rr2IxqTR7rhtAUe63/Hss0KPo6+qbFGqNpSUDDSrCr8GFiH31DYxw++vgGf1/lOkFWl1zqnYg7Sn6egeheIhfQN8mNZIt50HKcBAL6LfFM9SUow7plNuBcBk1d2MCkqa9D7wDVYs94+AqbfDOZcwKLTRtIIuCzcH0CFUnUUbXgIPf7qOtyD1uyBIp8tTOXQ+xj4fwgUV0PztVUfWVffUJYX2iw51TJ2BNnopzEVYxRyf449I3Ls65R4ObZLpwBhLGYF7fI553CYumSGFN2Z2NpchLZ3jcD7ubePRElafLK263GyC3F1j0Zn8muDmUYCACv6+IToccgVKd1ncjO6xLOgRPYj/6yeqwQHv6Ta+tGJ7QsA0RKfMAwUWm3yIbotXB2OUD0reYeX4WvZGxige0V6I4fEyAO87kpiOyOVHT2esGu21G4DU0DCxsfg8JdNecbw5H/vPhuzGdmXhW+aQr44BL2qa+y/WzkUJ/zik3EGVsdqCK5t0KJVizla1hkPB3s8fhjIuctPuwoU3mWOpi0DZqFC/Af+uWJqP1uI1aSxGu8QBXoDurdIZKJ17JRhBoPkRV9puQWljLKjj01RhblYjjArTnacwjjYjwXeXUjdClYe4Jacmho4kv4UQitNW/EPxnSJSN1h9N2vUBHXVe4FtOlEYXObRJSixLgRMkso9Syzt5eLz1+V+wtY+Dctwk
 4hRW7qYs
 KKAhmr90fZ/IXtcRbwvZaPP2cStnSnvhszpJKNqia4vP+lQei8mV9wKwq9fxsG41o4XQJAG3s6VQ3FixptIqnUIV7BHByfXEeTm0r4iq1uI3LZqKD+B39xNmiTC3Y85JyeCSiXCk+eGkCdYno45uhS7JpDaJRLqWDwU4UUB50DbVemspaCo7yom4rudEXQKit3QxXoFkoo9g7SxSwEabnyu83rgk7nVcVIDPG55Uul+EzMEdQAwEIjukN8IZwNyayP4q8Ua1kpBNBYdnbfjxc5UCHPw2guxH+wo0QUcJ/C+6J1KSEN4Mn5z6MFaTnFVggoY8URQzV+Orr6l/wHgtnO/hdbF9Ri720k3uEiwjWOhxNSQteln9B4lLuxLfWscgfyERJTMNbu+7xNWOAj2bLZqvPXjDEa0SjUZ/AofTtOK9AWjHsjqd1lExbYj3XTU5qS+J0sQlC5A5UeveDIIRvgtIaVz1Blp5vu/mEktgzMvci+VLlxzp1Po3cAyFWdqXI1DPNBbyXyYw5S/2276mQtd1A3pHy/O3RW++vhUPY83QtkPnpIfSOY9kj5Oyb1WObYnwVVypre+ivR+Gpaz6oV3OnZcsFgBtDxYV8j35yS//R4h9/0Zo4JjfaSReMQtygYHZkIrdMe998YQMPBKPY0vZUtGwtXTUFPWn3ZWrYqllCTnTq7eDgF7dhoGxpsoXSD7Me+l4Vub9kDg0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 24, 2025 at 04:28:20AM +0000, Matthew Wilcox wrote:
> On Mon, Nov 24, 2025 at 11:31:06AM +0900, Harry Yoo wrote:
> > >  size_t __ksize(const void *object)
> > >  {
> > > -	struct folio *folio;
> > > +	const struct page *page;
> > > +	const struct slab *slab;
> > >  
> > >  	if (unlikely(object == ZERO_SIZE_PTR))
> > >  		return 0;
> > >  
> > > -	folio = virt_to_folio(object);
> > > +	page = virt_to_page(object);
> > >  
> > > -	if (unlikely(!folio_test_slab(folio))) {
> > > -		if (WARN_ON(folio_size(folio) <= KMALLOC_MAX_CACHE_SIZE))
> > > -			return 0;
> > > -		if (WARN_ON(object != folio_address(folio)))
> > > -			return 0;
> > 
> > nit: we can still have these sanity checks even when we're not converting it
> > to folio?
> > 
> > size_t size = large_kmalloc_size(page);
> > if (WARN_ON(size <= KMALLOC_MAX_CACHE_SIZE))
> >     return 0;
> > if (WARN_ON(object & (size - 1))
> >     return 0;
> > return size;
> 
> We could!  However, I decided that we had these extra warnings to catch
> some uses of ksize() on non-kmalloc-large objects, and so they were
> really caught by the new:
> 
> +       if (WARN_ON(!slab))
> +               return page_size(page);

That makes sense!

> Now, you could argue that we're now not warning for ksize(kmalloc() + N)
> for N in the range 1..4095.  But I'm not sure it's particularly useful
> to be warning for those cases.
>
> I suppose size <= KMALLOC_MAX_CACHE_SIZE would also catch an internal
> bug in kmalloc where we set PageLargeKmalloc on a small allocation,
> but given how few places actually call ksize(), I doubt this would be
> a useful self-check either.

Yeah they are a bit paranoid and I don't have enough evidence to argue
that they'll be particularly useful..

Looks like my nitpicking failed ;)
Thanks!

-- 
Cheers,
Harry / Hyeonggon

