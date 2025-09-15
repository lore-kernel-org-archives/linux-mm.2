Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B177ECAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 10:56:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15D778E0015; Mon, 15 Sep 2025 06:56:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 135CE8E0001; Mon, 15 Sep 2025 06:56:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3E838E0015; Mon, 15 Sep 2025 06:56:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DDC3E8E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 06:56:34 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9A44186A65
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 10:56:34 +0000 (UTC)
X-FDA: 83891181108.03.DA89287
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf24.hostedemail.com (Postfix) with ESMTP id 07F37180010
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 10:56:30 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="US2/B48b";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=QJ88e0Vs;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757933791;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4XoqpflHZC//ogNDre9By2gcvcm3Eg+oxXZKQV/RVmE=;
	b=nsoAAkvYEwloZGodNVN1KzkEbZ4R7HC2rR60x3QUYZH15YJwRabh+f9OH10QYWL5BKKOXQ
	9oR0vdpJbUCkSk9ct7eKFEFyGUoMpySVDh8AsFegQ8zxagDJPU1F/fP3kwQGAgRyWapZN/
	JWjZ4mO9X9WkW6IoHYXz/nfyE/HCwvo=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="US2/B48b";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=QJ88e0Vs;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757933791; a=rsa-sha256;
	cv=pass;
	b=rMfwm+FF0PUQACVkWjtzzOxx9nYs3U8N+G+XL8BevTk0lIhRVBrxUDaVcEWFh/4zgoHFe3
	a33Pmnj8THAYbi5mrvSI6tDH3kRdWbc3Tx02JlWcuQr6+qiYiBsEXPkPEeJIZYzV0C4Ie/
	cQb/g6GwbGNInzZ389FXGPBlEgrbddI=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58FAu2ql028269;
	Mon, 15 Sep 2025 10:56:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=4XoqpflHZC//ogNDre
	9By2gcvcm3Eg+oxXZKQV/RVmE=; b=US2/B48ba53jAlGA50CeUBIQPK7fF1AYW7
	U2yjubMmLpJRMv2fNzPuFWeKuGFNsJvHkzzbcW1lEIZSljSD23P9FUu04G5vgA5C
	DMYRqbGrE9jDL1XrTB8LJeoq1npmOSrq2Q9gfKhK9HwF20PJAwuZjF9700ihnvJk
	pBt2WeclPF/oEJwz5sGQyxHEIP++3+oWHDHSBAp6EZZGn/N3m/uKqvJn+k3xKv4z
	1yvi3I5OMvvjlNxc8brNO7+WH4zfCzisoE22qES5Etnwt0miEnOuKPBr+h+WYOMk
	KaEeWWCNqLCiQAJuujWFQlIXyjm3RAqQ3AbG6lhaGqyJ4BwH8Iow==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 494y1fj47e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Sep 2025 10:56:23 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58FAjnxt021395;
	Mon, 15 Sep 2025 10:56:22 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011014.outbound.protection.outlook.com [52.101.52.14])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 494y2aumb0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Sep 2025 10:56:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=beaWRcRJlu4XDkyn9Yr7HAunQGuKYCe+796BAKNcywUTg8WQqEgyZIlBymmYT31KNe2NR5v056ggFeo8ZSEs++sH7d9RZKpNvKaZRfMePMrOuX/tr3FSw/2jRGUJUqp6gevpTT7a3YF1/6vtHheZA5T+BH99/xG3z0pMj3aDM2MVlVzThe5Siy4q0XMvQliKzq80glhtEid5q58ED2D2tPvCK+LjAPxo5d5kWOIyz7QQ8g3TusA7EZJPdHwNI372bipdzJFGcZ4T8E7tA2UqJdGhoO0qJy2VmONpAgcrj8v2AUf82P0HO3VdHWJVu8SSu+75/Xf+i/E5Gn91vVSi4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4XoqpflHZC//ogNDre9By2gcvcm3Eg+oxXZKQV/RVmE=;
 b=frWqbQbd2HiUgpNquUaZ6T2+/QmrIX0gSq3eOZIyLP3MXHaXXoaWMLb3Y7O1msbn9ySp3pjcaML/0bHU+JLR80yExkQX4uQ/tnej/3uYUXT25X7LvRF96KhSc6idpzBbTC1IG3UBxheooKA3NxlNCASjwgnCXAmJlQm7K3cetD5KlLiWrxXS8qBhy76LnRc+dyOaqQ+FPHZXMDq2UQt7qy0vCpjkqqTZDvzsi7qSv4AuFYhIGFlYwrWVJdwCFuBXdle+ybUXXMvIguAe4tAFZbi94niFlBmCraAVx9Hgvllf6Vy0Xchzo/rsIwuhkmiX7polIy4JPU8BwL3se5WaXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4XoqpflHZC//ogNDre9By2gcvcm3Eg+oxXZKQV/RVmE=;
 b=QJ88e0VsDAUE9Q+3d52FM2qKFHVp5WManyd7nKk/kmQenhuEuxguXTUy3WJE4fkmbSpw9obHbVV44H5TNwq3EeNC0t+E9nLlQpxLQfDmbdHJCQ93xhb3p7aoW7wVCKJzYxcmxnXOVGeOzEWSnXfRvSrEh3y9GakSH334zxs+67g=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DS7PR10MB7189.namprd10.prod.outlook.com (2603:10b6:8:ea::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Mon, 15 Sep
 2025 10:56:19 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9115.020; Mon, 15 Sep 2025
 10:56:19 +0000
Date: Mon, 15 Sep 2025 11:56:17 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>, Barry Song <21cnbao@gmail.com>,
        Nicolas Geoffray <ngeoffray@google.com>,
        Lokesh Gidra <lokeshgidra@google.com>,
        Harry Yoo <harry.yoo@oracle.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@surriel.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        Linux-MM <linux-mm@kvack.org>, Kalesh Singh <kaleshsingh@google.com>,
        SeongJae Park <sj@kernel.org>, Barry Song <v-songbaohua@oppo.com>,
        Peter Xu <peterx@redhat.com>
Subject: Re: [DISCUSSION] anon_vma root lock contention and per anon_vma lock
Message-ID: <23980405-700a-47cc-a5c3-cb207a338b1b@lucifer.local>
References: <CAGsJ_4x=YsQR=nNcHA-q=0vg0b7ok=81C_qQqKmoJ+BZ+HVduQ@mail.gmail.com>
 <aMdVcH7KCXBvLtFP@casper.infradead.org>
 <CAGsJ_4xDRB_F-T42WnhqpmwLyiZRwLGqx9vDf_d5TFALsCRX4A@mail.gmail.com>
 <aMd-2argDQCHww_Q@casper.infradead.org>
 <18361483-5089-4414-b974-4c481189b9fa@redhat.com>
 <585b0ca3-cc56-4f74-9950-800d6faf8012@lucifer.local>
 <8fa35236-23f6-4cb3-8e8b-268bd1aa09ba@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8fa35236-23f6-4cb3-8e8b-268bd1aa09ba@redhat.com>
X-ClientProxiedBy: LO4P123CA0568.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:276::18) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DS7PR10MB7189:EE_
X-MS-Office365-Filtering-Correlation-Id: 44403f9f-29b4-456d-5c26-08ddf4468057
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0ZU9Ebdl4VyiV3MOcWwCpPhep+Hk29gcgT75k8UzGtS6aAdbfySTrNuZfSEn?=
 =?us-ascii?Q?KZ53CqTNpK8Q3VCl6YWt7o7KSpzIryNm4AoUOGorx2F2BwPSTZmIJ2TCvsu0?=
 =?us-ascii?Q?iP+cLtooJ3BsbX4BOUe64COJSWsNJrT5NPPUD469JjQuSOKzplrFgqdWQG5v?=
 =?us-ascii?Q?+gtsLybnnYbOIyeNYdijjohnNNHP03bn0PVfeiuYOsxJDwLZIMped4+O3TlZ?=
 =?us-ascii?Q?0Sgsef8Oyjy2e0tEEL1FOQGyY2oRgpdD4Wj8gpW8Bzxp+zi2lUbhBlx4BHFG?=
 =?us-ascii?Q?UV4YhVoTFytnoQe5wr5i21jL6gR0rwKxiqvnKJDGlw1Aq8D7zt93V2+tKeu8?=
 =?us-ascii?Q?CQSnDyTmL711sjPhyDXWFXQq4+kmahaJMULR+WCb/qDzh7ho8P6AVzTDJCFR?=
 =?us-ascii?Q?/uqaSrN3Er2BR1In4dQMZpiEAzIjl82TbDHcSXeUvsSwQcfVLUx1By5iF3m2?=
 =?us-ascii?Q?UyPQhMjoAsMn4QIkRzVNiHn9cS50Wr6Hn2BQqsmpPzc+MmQzy8HRODfR9h5q?=
 =?us-ascii?Q?wKbBfiEHWIr+/8mxLp/Tq8k3wodVL0qGnk3IQ6ofYabyv5GZtv22wJbU+c2Z?=
 =?us-ascii?Q?jv0m6uM/9UilZWdaThs2Gr1RKAceDd96hp7ySmHWjz+LM0Jc49xHoszc8hQg?=
 =?us-ascii?Q?1/m4/dYfpxFriRwv4fYhQ6D5Z6VdCSo9dqjngzuGkq8L+qOAx0zclgVfcXH/?=
 =?us-ascii?Q?Q4Brwyvw+cidWhCMOB6cOrNB2xRo2mu6MmNHMBV9AJbQzLek3O6byeo9dDI5?=
 =?us-ascii?Q?D52Z+IV8ZnVp4FnYY2H7agYyaGf0A5irjp7olAbh3ajjS9gj83Z5EJPz+Ken?=
 =?us-ascii?Q?Iz4IE2SH4bpWHjH/4C1LNJh9WOQqiqb5tQXhHNxtOoEWOug+pyfAkxB6e59q?=
 =?us-ascii?Q?tL4RmzWFG05MyNckE8jmNnNVJu2DvuKuAUsraNY/tTyZnjfLNYr+tnhk4DZp?=
 =?us-ascii?Q?ZDooHdSHofSEwI/TOxB8Jz1MWW8HdfEMfqUTcls6vO4kLqUAlFaGUe0u3qqp?=
 =?us-ascii?Q?GQxwDA17HdmUbpMQRx6Q88wZkI4DGp8rC0ECYzosZKIMfxE/oo2QcTVob3Ga?=
 =?us-ascii?Q?RL5JxBmZOtWbSj8QsqGzScMTksD3mYhIBed/f/Ey4n6z0BdRBf6rsjt6t1fN?=
 =?us-ascii?Q?BVG7StUB1nIwTC01oLxOHZzMhpCNTb4uDP5gM5vWmIBLlmG9OYLeCt74zCxu?=
 =?us-ascii?Q?6UqB2nsZmvJMlsbrWaVQ+HAFFoMayEcyUmPbMqkuKwYRt1B95gEusXbdI1xi?=
 =?us-ascii?Q?K/cdFOFn7JAAdcmOasnyNJZ88KZIF0PzTN3yXB6qAYqPq8sadO5VW/qJP7ev?=
 =?us-ascii?Q?JhdEzz9QP1U/LbIHdwbgpdCmkae7rnmcdkETQSx3evI0OUJQJM27qNFkdJqQ?=
 =?us-ascii?Q?gEM6M855qxT93TJeP/EPmpIkyagG29xiohF8EV5DmSxexsWJnSlYgTf4Xvqm?=
 =?us-ascii?Q?zpkvCw2VPUQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gC8tMwBOZ78tXCrqPxPn3P6cFcfVxl0lBsbhCd3mBmD4shJQOxLvHKTjuSZV?=
 =?us-ascii?Q?LKD80yODDSDM5Y2N7BQTzcKQF620F40UVpCjBpv+6CtGB7QA/WxXyDRpqtnb?=
 =?us-ascii?Q?jx++pFAsq4tay4Isp57tavJMPN3Ue4Kb1k0GyePHSEeK4gtZYkaDavVV4ORb?=
 =?us-ascii?Q?NNUjCxviRndC6IU1HsJeM3izjxsCorT5ls1RwI8hNMF/NcXBREr1Qb442Tfs?=
 =?us-ascii?Q?YBLuDE6WpJDobsoMFFDwmuqAl2s4bjqgNutafb2o+Kv6Mx1h5Aq8YYgRYtbr?=
 =?us-ascii?Q?1DOdCtne2DGZMlprhzSAuDHL28txeoYvX8Ssjud806fF40vpoArizTrsyHsV?=
 =?us-ascii?Q?S286p8bl+mQBUxCHfU7Xm32y3m93mLonCmtI1l69PzHiUMm0UXWilBp8P92C?=
 =?us-ascii?Q?2gwGPB6pSGjjfvvp09Um8ojfqW+2ljP+Zk5sy1mU2IGNrXU3lCon6Ec13tf2?=
 =?us-ascii?Q?02CGpqt357OkC6ubre/zmgKBX5qbHXOF8q4JEMhdyvkGZTRZzjFlyfR/WOvL?=
 =?us-ascii?Q?+PzqgYwRspepyHPmkqx1BcM7cuByfSIEGzzs2zFZu0gIPrA7UdnAr3jHMRk9?=
 =?us-ascii?Q?e72qhKD/05WLVusP0jDz+DHm+QFafvyk7OBMXgHnPQ4J1mh8F1ViJTzFX3jB?=
 =?us-ascii?Q?GsAjtPcjIfhs1q29sV9nWsFrtGXr9+dE6ymxeW6lNKlpUaP1YSox1gcJUY9r?=
 =?us-ascii?Q?VYHkWkwxaje1UPQCrmHdj5mWYjyq78UtVhnL0F0+7MdTMDy+qsnKyhL9OXVI?=
 =?us-ascii?Q?c6+Q6kyXAf7SKdOlIauYPccPKsxxgHWwv7qfeg+J0P9cxOOntGzL2fis702P?=
 =?us-ascii?Q?vbzvck8mnnObIHFMQx3kvtBf0PLCv6BmQY22SdUEbJkfmqOP6JtHO7mt8aOR?=
 =?us-ascii?Q?aIN4RXRHfGYc1vqqPhA4J2jCgk1m8JG7YlBT2PXL/RSMtbmH+E7ewy9aDH/o?=
 =?us-ascii?Q?9255CQBsF5Yrtcw6jD/vs4gAL6ooaYFyjwpzfBsU8Eq9immNNkLwQSFrtyWC?=
 =?us-ascii?Q?q8L6w5DFhgCCxmlbn5H9A3dMil8zpljqT6cWVgO28H/i80rbCo2N/UCYwjVv?=
 =?us-ascii?Q?mnHuK8+qLLwQr3uPpjdMFKp5r9tApKia2JHmVTzBiPC09r5NkCLYh6Cr5gds?=
 =?us-ascii?Q?HFULiuDCyfJ/G8uue/r5kCyUucWuOetZQBXiJCI55vI+DXHOq1SDGdKTka1L?=
 =?us-ascii?Q?Y5PHDGO4YNK/o9fga0d1B8ZFuACpQ5fl8sdJIbWrYm/tq+2T6CESNRpzyXNu?=
 =?us-ascii?Q?pRZP8laQg+bvDnDW4BeVEvnmwcJC8WR61QKYa7BTU19Bcbv2VC7kVxRdaE7U?=
 =?us-ascii?Q?ifST8I5/BzLGxGk2ni2z60YtLT2KJCtNqXF0KW/TAHO2SvLEpJ/XFkjD3TiJ?=
 =?us-ascii?Q?nGJrcVS74tWxodvQLX+LLOb9q2kEckiC1H9XHoR/WQBMR4PNOksWVY+peJ41?=
 =?us-ascii?Q?8Gqw1nVxBvMSzyqBKEd7W+LUZi7504JE7aojksJ81Ko/YNTN0x66sbLhY4lS?=
 =?us-ascii?Q?M4ult23P1rPkUTy5BJEJnzrdS8d9l1Y4d+s9//awGJt+dE7KxmYn0XPHme0A?=
 =?us-ascii?Q?jcTA3TOa4XwGhpAge03Geb8A184hd1CgIUe8bQjR+viWQyrCIgTApJSRHjo4?=
 =?us-ascii?Q?8g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9S8fOlKybNvfISl+hjGPQih/eoDTCvrj5fV9E5nfkXfSHWcq4axZ8oDYjuDzmtqutxP0d6I/1/qxbdF6ukMnJpWzO8fLoEkjZ3eyhdrqQMU1F0P78L0kbiI4D/45Pccw+jpR6DxsfU5dTHSmak8aRQzid3LQJ1k2pM2y+5xe7OclbKef6Kl/rtlNzrmNBk4D4iBTBhZz1XtJTBMSUjxfpgSDHQJH86Yf7Gq0X/fF0fZM5qIKhK5CnPrP1C/JqDIOZ2pLL4laN9bMuGrV/DjcuY54tw0HEV04b3Fnnpjrev6KoMY9RUicwm527zVarY/U0FUOTJK8lIZPaIYk6aKT64Lpz63v2KfhL3rVKapPf38GY9HWiwz0kC6TUC7CclCT2vG3p6VQDOzOA9uIEpA023Kko1se0kjdbtrieIgOKdswgCPAiLOTuPWdoMjRZzJ2KPj/o3HlkM8mM6dVGXPvJ4tMpjCZ3qi0DSeQ6ke0wFaIwc074l24vjUvCi6lH6A/NqfzfdlJ2g+KbDeuoyL422oKJk/vuYXE77L5IXU4juVwft109kp5tdIJYEiryByNUd2o2qHR24CI9g4gcIUZI86ExJAGNRiEgNDeWNoDZFM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44403f9f-29b4-456d-5c26-08ddf4468057
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2025 10:56:19.5205
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2WFzz9lpJH/ZBWPyz02etWeIaBfyYmuUv3ITWHxLL2jWheBkNKPCiVA05mI8UFW81lx6H+bcECP4kSu5dmP/wj8+IR1fbGeaMmQESeTcB7I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7189
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-15_04,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 phishscore=0
 bulkscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509150102
X-Proofpoint-ORIG-GUID: LS37AsW5ER6BdWHr-tC_d3AUZkqGkBxy
X-Authority-Analysis: v=2.4 cv=KNpaDEFo c=1 sm=1 tr=0 ts=68c7f0d7 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=dusFI_Zl8bLTAxYiiPAA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: LS37AsW5ER6BdWHr-tC_d3AUZkqGkBxy
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTEzMDAxMiBTYWx0ZWRfX7eUhYSwJUE6L
 tmXwYLlAnu1raS1JAW9fTfmXdiYybKY1oja/6YMpwZiCUN2pxbg45zWJjAONvm9O9sKzLqqch/2
 LidKZmi/aL4jtoNrJDvKt1sHtU/ZMDXYm6nL7/QLW+zztS+WfkUDnDngzLEUXdk8i332b65sVcB
 C02c4/KxpFvvn2NuCTieG2UXTONglnbEkd9vyPiRSowictC32zmn/2r4och1LPYwiXQr3uXzG/4
 k8hl0COZmExtjeMOYxTcToX/0gxD8mdnT5HGxtvDXpwgQ8Y/gudPYcS2QQZdYb7pgx9t9zxlCKa
 WYkQKXVcqvboACTZUV0+KFaVj80s3OGGjNQJWJ7Pfksl2JaNfuUZyY2hOy1PyBW7qw9vpgRVWJB
 CvnD2uYb
X-Rspamd-Queue-Id: 07F37180010
X-Rspamd-Server: rspam05
X-Stat-Signature: 43p5r3goysftgkcdbk6ub9yf5d38eb6e
X-Rspam-User: 
X-HE-Tag: 1757933790-500417
X-HE-Meta: U2FsdGVkX1+BGNNlUBAfECMq5T0uiBedtlTEnvz1JGbQUwpQQ6HmykROdGosO4MGN8fgklqmucxbpARoKWjIqNRL+QQH843PO+jrazqw3Lij6uDc52vpeO7/nEjHiurWqxFu+EPaDENW0UlNQYgZD5pF33B6eYqMjC/hKmsnlcCsPQrAbeP7qibW3rOy14ZyfOf/eh7swH4XgcvqoAN9MPNbgqi34nICIRdB1UorNhJtSoMpnC+PTX67IB7uq/szyB8LgyiHc3ZtV+Cj02nD/iJHKqB6Kc6oKSZ8OVxznTCYuGcdPKfwzvCKO2T7ZVjVZEmY/6TYfX3uSHCzJK5uTdy9PJ3V2hqhbiLJeyjOMNa9nXDPg/qAHqSDrGyBKWtOSAPW0AwmHX2w1C1M/0nnmG3o+GNZmb8WeBcJMZxc5C2lTxWdT21ebrakJ+lJbTCoRou9S3Ei7Tcr2mQh/CFO74+QS9Mmk6+CBBr23DvlQ9nUgw/Ux2LzSHfYJhUQ+fUmf8GwZtPvQurpfRCjgQSwXKA6fSJwSncHm08dvs5CFNcwYv1lMmMhbufTEFlfdmRQ7/FonitO651fIlupix/A/x9eEFZVwa+uZtIkZjxZcoPeMB9Cpl38rhbwk6JV+GqW/M0oyMUYN/efKkLox8S9qHa3KNXCcMlKOAvyHfPFy1AW9W+iqBC4g/jf+fN65poxoBsGKw/RVAXrYWtCzcADDNem6jGQu7BIfNiOkYXTi6v8qtD9t3UarlXUmamX2h8fzjwajWwOWww3dfteH/MRr2t0KUVwGOulo+LBN0gg1wpFtlgj572ji1cCQJGK7+7G2vidWr6qpoDi1BineWb+eOJfFe08AzNh3fBBcMxMY/DC4DIkIlIecZr1NYueT+kEBMPYS3jETm+l5VlfTQpt75K1XhhlpIraVKflyvnkHQySRfqQUIhmoNCzIgIvCFbh4KdxqOpXC2sOZpNmXFU
 fr5h1y1w
 AkS8bMT6OlvqtdhWy13izrWi6giUOL5T5XJZZAQPuqqB8xJBDXF4zIzzl2eISywVvP27IbVD4ODdeE/qbqJeWJuy14mZP7U+i0lxXxVqTPbVARWJ2DwERyMDusahFgRUH81spTxefTCkYXuyGS4F3LErA+QuypT1Xf8ifP06gEykr85yAg3MArY15ogfs0c6a4hkuaN2EnxnJ+bAbSY4aLjqGbsroLZbJPkz97sF2pIKrqpDCk0H0cYdD4ymn1x+y0mzag1NdLJPu3FUj4rhR6WI1SM5HPA3c8PY0jfECkYCZfRe0jYrM15zX5BSB5+Ap1IWbwiePCavlDqQ4BPF8OdZKCF3+h65JIZV9hZoFRBreotQcq7mAJdDU0fWldZwgRxZZeBHeI1I56pvSfgeg3BcwehLunZuyTZg4Qh5eHnsWMiNVyoaUsKqIfUrsfYefkl2cLI3vwcdN9mTleUXxoW5zs+j+LLwbPndr/umS9IlOg/ZKnWMFVyHZi0x2+tfMAUPvoBHL3pHrnAJWzzjsqNFOybiCSmKWrahMHZzQlO0wRkIuowLCvVd1sf43L0LBWwEraMfW+OGQ0b5ziHW0OFVqwttv7vE6RMf6S4G/wGUpTTVsMvtmDbT5dZ7s0xNg4IN/K6wudy2oB9mQJXEaFNx6fxixN2NDuxiXOBpz4Ye1+Oqg5jAnESe1lDu3nYUO7uaTv7sTuRtmZEDjKpoKmxfTjtCZjD8NYTsT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 15, 2025 at 12:29:50PM +0200, David Hildenbrand wrote:

> > > MADV_UNSHARE we implemented simply took a range and one could apply it to
> > > the full process by supplying the full range.
> > >
> > > But yeah, the downside in any case is that you lose
> >
> > You just lose? :P I assume you forgot to finish this thought :>)
>
> "you lose the memory savings of COW" -- was still tired there.

You and me both, bud... :)

And right, yes agreed.

>
> >
> > I wonder from rmap point of view whether you could actually simply check to
> > see if you're fully CoW'd.
> >
> > E.g.:
> >
> > 	madvise(..., MADV_ISOLATE_COWED)
> >
> > And have it take the anon_vma write lock from root, have it walk the rmap,
> > go and check to see if every folio in the VMA is now CoW'd, and if so,
> > detatch the CoW'd anon_vma from its parent/root?
>
> TBH, this all feels like things we should be optimizing internally somehow.
>
> And don't get me started on
>
> MADV_ISOLATE_COWED eww
>
> NO_COWS eww
>
> COW NOW eww

Holy CoW! ;)

Yeah it'd be nice for us to do this automagically. But I suspect anything like
this will be quite painful.

A kthread to do this... hmmm... Doing it on fault? Expensive. Tracking it? Also
expensive.

++lorenzos_grand_rework_goals I guess...

>
> >
> > This would be a sort of after-the-fact thing, but maybe could be done
> > periodically.
> >
> > Of course then if you had one folio that was not yet CoW'd, that'd prevent
> > this from completing.
>
> [...]
>
> > > >
> > > > Another point in favour of COW_NOW or EAGER_COW is that we can choose to
> > > > allocate folios of the appropriate size at that time.  Unless something's
> > > > changed, I think we always COW individual pages rather than multiple
> > > > pages at once.
> > >
> > > Yes. khugepaged will soon starting fixing that up later asynchronously I
> > > hope.
> >
> > But only at mTHP granularity a. once the relevant series lands and b. if
> > mTHP is enabled (I mean for sub-PMD sized/aligned ranges) :>)
>
> Well, we need khugepaged in one form or the other form mTHP in any case :P
>
> And the glorious future will have all sizes enabled as default.

I look forward to this glorious future :)

>
> --
> Cheers
>
> David / dhildenb
>
>

Cheers, Lorenzo

