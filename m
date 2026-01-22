Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17CE4D3EE86
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 15:57:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 461136B0256; Thu, 22 Jan 2026 10:57:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4386B6B0258; Thu, 22 Jan 2026 10:57:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E5C96B0259; Thu, 22 Jan 2026 10:57:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1BF426B0256
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 10:57:58 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3481B160442
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 15:57:57 +0000 (UTC)
X-FDA: 84360055794.23.B99F989
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf17.hostedemail.com (Postfix) with ESMTP id B5EDD4000C
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 15:57:52 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="gQQ/gSXC";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="y14fL/IY";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769097473;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nja7SLR5L1Q3bVItnoypfxWoEL2LqqsvxyNiC9dpjJk=;
	b=ije8qdyr/6ds2wgtfuBtpjm18UQJl0T6XcTknGbPxmxWEP0iYLns1pDPbbFtbnjvRHP5xm
	xdgmJe2YINkcsbBm84XiTtzuZlZfNeFaFKG/gyg+YGSXGB2h4dz3czy/1BAVJUZZYC6oSS
	FNv3ZQWXpXaigz0ck5lBsiCTKIGF4/Q=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769097473; a=rsa-sha256;
	cv=pass;
	b=vdZSecrzY74maOBxjESHk8Y23CCj7rb2cXQqYiiQpCbPR4G5I/gG5Xrm7P8oEH6lDmSlqT
	dPmKs/VJxaiC82MpkTVlRKKtKhx+Hu5xY2hn7RZoZaD7Ecd8iqnNPGA3/qk7AieRcnmeAr
	kkGJN4zLPOeWEuh55H2iReaiuD5EAUg=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="gQQ/gSXC";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="y14fL/IY";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60MDgb93596377;
	Thu, 22 Jan 2026 15:57:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=nja7SLR5L1Q3bVItno
	ypfxWoEL2LqqsvxyNiC9dpjJk=; b=gQQ/gSXCD3PznXSF6Ybjz+4Fps/5qzX/2Z
	RfkjzBPOTfxM71j0H0terERMrOp5wMQ+wpn0Bg6xjN/AL3zFr6v72FmoTKzmH2T8
	2SzfGX267FLpuJ2dyPuN+LsTL3nVoWpmPNNHQdTXjvFT8HYs/QGOA5VeY3pNUFVd
	5H/Dfy1wKChrNHt6l0KzTOhp1hLfmNfLombaomcGaTdoyEbuv3eia371IHfznzhj
	qMwRJ0JDZSNmfgFKfvGENqD0yXAE62SXb05TUZRauX6WQoMflm56AAAYvD+1pGma
	GNCij3Ns5zgFqRfuyfUs7YzfGcCTGi1/zhQta1O9HTLnYKgclGmw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br2a5qvuw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Jan 2026 15:57:38 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60MFdg7S022647;
	Thu, 22 Jan 2026 15:57:36 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011009.outbound.protection.outlook.com [40.93.194.9])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vgt8ub-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Jan 2026 15:57:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H4vgYkzN/NTcn4wxAoOZ3MbznSH6ikZpjkV3bUXCI5b+9gpruDhScNxR+qYKCbMIWGenbMrPkDTka54o9HonGnUOlgo2Sp+6KmfirRDgTPmAcx0VVYTVUjtpa8S302wD6WAs6PtjEkL61ZIFHCPdpihRgbyL8Pjcd45BztJaKktu2Ye1qAVJo9L1cIpU7qJCRT3Jav6zo0wsrN+VarYBeEdExHe32jKfYR3b/JJ3zRGTKnsWFkcyOSLhFhWbuRKUVk2FlkAYaOvLnNSZ/Dlb1pvntKZaLnDI3Pk/24RIrv5lv1he7heT27uuaGXCtw6tIceOzGPMe9WOT9nIg2sDtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nja7SLR5L1Q3bVItnoypfxWoEL2LqqsvxyNiC9dpjJk=;
 b=PqrXT3zK916A63tu395VCvHl8sp94FxHL/lsuge0DAHM+wQgQCTnkqPp1VGpO+iOs+Yt/yMNG4odE3UYcAY8R7gwgmCHrGNb0ynK++PZ1zGTnftyx6V6szYw/012ARJesD5PcVywFfZdJcT/jXTIVIcxs1F9vsBr7NsILmVcW2/dT1OKOjU9oN+RA1sTmQaISjFpESaMchykRDGx9DuUmKTbvhQcDyDlh704evNT9SdkohFlMnSR3MRjKbMba8zl8wyyp0iBKzaT/mkU9cZDo3/aXERLI/SwsH7LRnJ+AjNFrcPB1atTYSbJP2BwkjGb4jwhoTWT/zC4Gbcqa0aqgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nja7SLR5L1Q3bVItnoypfxWoEL2LqqsvxyNiC9dpjJk=;
 b=y14fL/IY2llILRk7Ib9lNpXaK+iyfgmGH9XOnxDm3jj4XhOqUEv3mCEQcZ+86v/Mhr25lG8nlpKYmDoMdvj1r46xdj9ZQDc6Btj6oBE5Ywy7ml6ceBATn2bAXleMeEL5ENhX9RLqM0p0ptezhiGQYU3ZWVZS5zv7ukIl4sMhkH4=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by PH0PR10MB4774.namprd10.prod.outlook.com (2603:10b6:510:3b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.10; Thu, 22 Jan
 2026 15:57:32 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Thu, 22 Jan 2026
 15:57:32 +0000
Date: Thu, 22 Jan 2026 15:57:35 +0000
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
Subject: Re: [PATCH RESEND v3 00/10] mm: add and use vma_assert_stabilised()
 helper
Message-ID: <af4f2048-1176-4b3b-954f-09fdc7275348@lucifer.local>
References: <cover.1769086312.git.lorenzo.stoakes@oracle.com>
 <20260122074807.eccc6080b8d8ca5fc37b2a62@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260122074807.eccc6080b8d8ca5fc37b2a62@linux-foundation.org>
X-ClientProxiedBy: LO4P265CA0085.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2bd::14) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|PH0PR10MB4774:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b694250-a9fc-4eca-6aa9-08de59cef3ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?wPJB8Fzd+u9sVYbdP5rTtC8JB8L7QrbRnDgriRjF/W7NyB6esmUSbjQ+OBvf?=
 =?us-ascii?Q?nKHk8lyF7/UrluKrP6OAIIzlzyTsAExspMwlZfM6NuYEtzqQX+ATIdVbqFYU?=
 =?us-ascii?Q?BYTYsqprFS2M4KZeIGDSS68t6Qs9B9elgkyv65B55n3JHT+A8cDYDGktQGe+?=
 =?us-ascii?Q?mtmFORKd5Cy7tN9Nxs+B2IFfRGs/J/koqtCVnarx0Jh6JriT1+H9UB2i3gYh?=
 =?us-ascii?Q?k1XVtYgBIe5ycToXiPyf8FawZEUYk0BZgZzVOQGPgjqSFr8CXOTw2b4WIVts?=
 =?us-ascii?Q?M6PsfdKhO6SJFDkbCVvO/ZhX9K444aLjCipdShadvT29lg3NRjalcsIlTx9h?=
 =?us-ascii?Q?fPyqzYcz+SLsIpmn88OyJ7npynYUWAmSVqZg+HGmNoIU8B4mzp8BpX8IM0Ff?=
 =?us-ascii?Q?XOZr+fSNpMUkz7jgTwvpS0JiVTFPp4UyP0yW+e2/Z0/gP7I0CQyMFuS3QYoP?=
 =?us-ascii?Q?RhalMB6BDq1siFjLYYp6GvpHpZlAABlsWpu1PXnXUiUWBLIbAIeOY7DXGkc+?=
 =?us-ascii?Q?Liz6KFZbEpAl7ClXAntm46N7kRQ7ck2sjs1/TCzRRqVSQiHCfCSfi6Ko2YOu?=
 =?us-ascii?Q?j1TpPVuVzbPpJ1m3AGWlgBpZzlqVudaM1tj15q4HjP+rPzU1XJZ5mVOaeDXZ?=
 =?us-ascii?Q?zwiwY/UTbSFppr+7uApuuKlc8VFLacIyQTmzamDPnOEp2KIT7MJFxoDPzJXh?=
 =?us-ascii?Q?GD7GxhZrdmqg9k7awQdkmWnBUKygen0Gc+HF/7RO/ND5WYceO7dV7CE+wvB0?=
 =?us-ascii?Q?hzFq3eFKpKX/VGcmyIWEdpLnAZTI+v7BKpKOtlXbtA2jRSI9kqAMgaM3J4Si?=
 =?us-ascii?Q?cWmHsdQfLVS+bsEzd2DPBQNVlTu5rBsUdwQgtPeS8bwME9iLw78LfMVMurOe?=
 =?us-ascii?Q?2j5EpTjwQ4e7iTihynVOVJuK6HDZQgTbqxUMAaXv03p5MQs4cSk1h1kCCNfg?=
 =?us-ascii?Q?a/OZSI6H4+zxWUlKw7ilEGY1ZvzO3IKsUF3byAxfC23fYA9CbJGIgdIWT6BA?=
 =?us-ascii?Q?eq2Qd2nFZWrJLlRRrldSti+SAc32YNZAd6j9dfEfRGcRXEQwKBbB8g+X1F6n?=
 =?us-ascii?Q?tMdP+V2U22hNx60FZ3777sSRx/YpYA2mN8laKz/vJIJdWebcem2CboGE/wXU?=
 =?us-ascii?Q?Fpqepjjp7IuwN2rZ4zoNnKOSvkgA4NoUPeMkvZi7e3njCDkVtUnvWTFUaDsT?=
 =?us-ascii?Q?hNFBjyenE6km9taaH69W7ibp7rHCSXOyE+4VVpU/QrcJKCV1HWxRSEHZwrmV?=
 =?us-ascii?Q?m2M0ZeQYKK472UTuDPXTteXaBn2H9tNjWTV7uUip2HcNR6kC6wx3oknthvjm?=
 =?us-ascii?Q?rIMwTAEHj+/E7Vmtc2SgeDfNTVrfxWHECrb6sozAMErwuclxGRfnPWfHOqP7?=
 =?us-ascii?Q?RKL5Asm+xlWeYUD1T//aoHmOdKIRG4OpugkRnbtyRmtLg4xUreuAgyYFosBW?=
 =?us-ascii?Q?JCgrYfch9XcX4v1Bp2zhPMXezBI+xxUTjiLthO5kt00KktewAWSJc+KrG5DR?=
 =?us-ascii?Q?uwCjKZh7YYpn5wMtaDDlmovvdvw7ZSj6qxBY7rcpCvA2g6qEX/Kymxwfsxat?=
 =?us-ascii?Q?VVu2rcO7IP2kHELY2ks=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5ddGhHouVBOnUIlEM/vWinqZsaa/R6UFaIqVXaeRhSKs2YblbaJtXCdQ6dUP?=
 =?us-ascii?Q?+g2R7oo9UfeO7Pr0Qq/32mqQpjL8obqhAM/Arpxi1Zr3TiOfrao/JmvOd+rH?=
 =?us-ascii?Q?zs/qb8iC7ioMWW9NTSQpkZ2tUNlwyw6sXLDXx+gFMYZE3Zrs/Ezc+j5Wlxqr?=
 =?us-ascii?Q?9vjlfQgTIwbRKz3M7W/q5cVn9SR7MZPtAHRdlieSGIol8/tum69aIo2IMKqY?=
 =?us-ascii?Q?I3xXwyzcbhJyO1xs5oI05lBCyFwOCxY7nXqt6rBdVSaZbpm9rqJvAn+4qXCn?=
 =?us-ascii?Q?xeaz+YlP2EH95p0fH6x+Bm6cBhgU3Za78M9jSwbR7y6sfXHs5LXGeMy7CNcN?=
 =?us-ascii?Q?RAIRzttsQWKw0qhwbaAIK0CGY1yQnsj8RktD4E2Atvk+kFpy4pim61SwdyPI?=
 =?us-ascii?Q?eP/s4xsv8e2Kl5TmilicaAoSuxvuoT3E3S5B95PY5LQHOPJolRQj/ROTZGXj?=
 =?us-ascii?Q?oeTnLNFMnFmgTR4wCidNmpKmzSVdvCn21LMVCKwca+ekt8Km6xDgFVLxGnxz?=
 =?us-ascii?Q?BkFSPOeUgMDjbIh4vFi+UB13q0+TmTXZFEWifsW6W2bhkoBsQO4tmj8ooWI1?=
 =?us-ascii?Q?sT542CgHyeELGddCAowwK9CbaT804DKtF4H3SJCePa4gZ5mVX9RGvOciZCrz?=
 =?us-ascii?Q?kBECJfhJWwii+XSKbNRlIDocnu303Kt18HqMRBNtGxFdv9PQ36VvoMoEYoUf?=
 =?us-ascii?Q?mkYaK+yB3UQCtBQkmsAVFjp8EnN4/rJHymHMs863xvQKeZfothisVFHPLMV2?=
 =?us-ascii?Q?dWU9VN1hXn8EH4irCeepuOo48UBiUF4R3CBLfaKkqaoPIWAdHtRRsIu1RR+y?=
 =?us-ascii?Q?GxrPG13w02Zull5xjFnm19T4S7QJ2FDatgfq/4ykhJdKoJkoShUL+VDrcU2g?=
 =?us-ascii?Q?GbU23oMBi2Kf5RSg+1UqWolPzoT91qWSszybz66qRpWQ22FVAdgIaGr5wHnn?=
 =?us-ascii?Q?CaeFc7hiRh5esCa2XEZYQMNjJvj3wuPguaKb+FuNKYrNRkJb5DQSG5/Hcv5r?=
 =?us-ascii?Q?Q0J3HYveg10cTEjaweg3GGlPlsstw6Bs7V5B6vIwnfcIq1BUVsLi5XQRS404?=
 =?us-ascii?Q?hW9L2MvG/SHWhW5CjnJhhpTt8sQe9Yes+F9XpOsEwD1YdtVb9LjfVu0UcDbl?=
 =?us-ascii?Q?OSF6r2MXyKPDrDltIryL58+0cAFiPQ8i6EwWSO6wBq4/N6BfsY7BO2sZpG3d?=
 =?us-ascii?Q?/oDi4yKQFlkPAQX5DEsUejUbw1wA/D0dz0h8Tv/6eswVq6Y5bp12mWrv7jji?=
 =?us-ascii?Q?QghqmlRu4d3GxSCtpcDiDxAhYdGOod7Ggh0Ks+Oa1coL3/UXYQ0meNkzElYX?=
 =?us-ascii?Q?QS1wC0umAZI7vy0CvIQcfoFJzzmD8n8pkjg/JmW6tn6PsvFtOJH3DtBWmVb6?=
 =?us-ascii?Q?OvCrx4aPROPOcNY4yq7hLVYUAOAA9GAGuDZ+Dul5BXmoI1p6Ltrrz38a9Fb6?=
 =?us-ascii?Q?mP+39RaN8whqvQL5gRSzOvJNghK43nq2V2HmMIOzHn3ys4RTB08h2ovP9Vkf?=
 =?us-ascii?Q?Mj3FqtTKgLqyUV/1sTzwV/gng4Wv04ZTESJ8jOE1bzbxIDwWU/oikAa2IeRV?=
 =?us-ascii?Q?tx4aWoJGihT7mWjD9rI3cNLjfGtFxsx1Kw9c7hu8KGKjewO8YG4rZF/it5xZ?=
 =?us-ascii?Q?4SUv49w79shqz1bM/us9Cs62TZS4vNmLkobgEJWezvgbSM87mUT2XxCHCOx1?=
 =?us-ascii?Q?TG2PnDYLzLPDcUmlJhYA9vRgcXakVfr1iLtG/f0R57qMgQcYy5HNEGcInfmF?=
 =?us-ascii?Q?JogE0XQqJK7if36m7zc1uBDXzlcyWLU=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	6ch6uSSZmlKCjNxz5BLvQ2cA6lWEulGsKHqHbWikd6tGoNUKLC/FiPu6EVdJG8EhxPvA8Xx45s2NNLYwvoTiRbckIb8TRDsqcahQ2x5uOYFkq4apaNUndadShWgun/3juHeYJ2UTNnilJoLMJfEN5zmVC9yEw3GbizzOtKs+9TfJBp2Y5LDbHaWENVDsHJIxD6ckg0Q54Z/tPPehA91jYcSSm0x+pTLaNzThioNUNiNpXeOOIpi079KCVL1lhiXhu7NECnoZTdQh2WLbEBv9kdpVpJwyMuNDDopl82jQ8x+q7wzR6FcSqRmZEgO30u6sMmp5hyeLepJep5g279UAH+WXmE16IZLo7lBtrd62Q/6QrrCHfzb+Kzoo6ISWGzHpy6OhcG6PBoe5ghNA0EDFemwtqy9TX7ObXrt1f+ezg39iJ9s1Q9vbeS9xiM1Fh0SdLXPJcm6o/CRVeG1lQSU7l9zeexJ55Nri989OxWBwccqHTI797OxrASTbpXp2ArD4izudKz7Vl62bfAUJZQOWwIziKwzS6azfE9rCgZIK12kZrimmxptFvDal+uf+sxbun8bR8RL1Me0RcKTWufylgfe0PSvgwT6+NmANHsgmARU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b694250-a9fc-4eca-6aa9-08de59cef3ee
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2026 15:57:32.4658
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xeUJE8ihlqwIPIR6Buto8aHiRLnVU39JXGpfXbDsn5ZzpgGnuxfL0nDaqnMC8oBa/RtKgjuRT2Q8lA5HuTLwjN1Ks81odVEYd7wIKhjyMlk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4774
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-22_02,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601220122
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIyMDEyMiBTYWx0ZWRfX34X/TDCWlV9l
 TnBfsjlhgA1Q0k8cxx70CgSVqoVFPHKb/aSOhDwNS8AoVwMO5OII/Yd2FW1nO+D6oq1z9xRHWe2
 8JfqW6vg6f4QMnbd9y7riY95isooBm9eqhnSCOa1ZRRgdyg0NPurUHrvZsKEtAjXsiZgK0QuHGB
 wllPXZQTS7mluvz5DbomYKHCy12cix1zGt6sgtKXG8HWwTbnmzmstsaBN+HdulHrwTE7sAFoayq
 7HDLZaNSOlCyy/M796J778wcXBAoODw464OZ2dfIFh/mhFZtmvkQo6ROagZcPZyxbE37E2TKBJq
 6MwwranvKXfLvrLG5XSRBqxNB85dJNYQAbWLyiTUC3T/hJ28HEsQ0sbrEESgHSVmdR5wmwTsUVP
 9L9X74F/Cjn3fFlcT4jZ24XqIYqF45ObGuYWt2JxsQG7vl0MbMMdNo2AivgnBv4fYypBura+kC7
 yBR4WvSZOfOWoxMZuv3ZNfDlDcMxWCQKcBH2fjQs=
X-Proofpoint-GUID: wB7NqeWVfNFaLmUFfWoPcgDKkgYg1t7n
X-Authority-Analysis: v=2.4 cv=XK49iAhE c=1 sm=1 tr=0 ts=697248f2 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=za64TVTXhvdPwjOmqZkA:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:12103
X-Proofpoint-ORIG-GUID: wB7NqeWVfNFaLmUFfWoPcgDKkgYg1t7n
X-Rspamd-Queue-Id: B5EDD4000C
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: phm41b35btw9q4ydwh7a1dcuxtanykf3
X-HE-Tag: 1769097472-470424
X-HE-Meta: U2FsdGVkX18gpuJXJarBro39STqzTCk1sQ/KIPnhvihtPTSIGRRTQQbMwTYZmcexmJB8CSpXj0yuNBrE6HmHunDBabFABf3ZJaMDiMRxPjViXrYdXADUflGN1AipBZpXJZWkeoWzPCygN0wQ3mNS1VhKOgavNa/7+a8jedo8q2RQqJmzmRhsouVNtBE50x6XYBHILnRHBfwFMwEW1GMhqwvjS2auIOyVGxEjCY/rBJM4R0r+OB9wtLPJ9k/nIrT+Zdw58IPhcKIeFy5Z+7PgWCkpOsv3UinHDz6AHdwWpdz4dLQVkxc1pGdxgTR59vyQYl8WdGskZEKVZaiLkFoXPy7vPcz2T+u5gUEnMd/DMKaR92YwJ6slUtbgIe3etHeS+piM9NuL+LNFirL0gM6NvFMpTbZj4v5HQ+ZBP1iTS7pO7afocCo3iAAUPWdh0AxBn22eGeIKY0Cf172AsLHpQwXdgFCVQsUrxJtNyI4XE/CG0lLphwE6GRVBOXAbVgTHnNuwn/wcRlNdhyhevHy6eFVqY5Ln6m91tr29ezi0mCEK/yR/Wthqozs3gq+t/dF98qOmL5aA5n9nXB5VEwYv7LkNO3e25BHeL3FynpVasJR+Js4695USj3JLdEJIK8w51lXTzTxrb906TeSmqL+kd3sP9iprA4gpCHDJMoiJe0ZwXQ4UxuSJ4E6Q65/MgGuwaXL73md9ne7T096pVRLSirhYAGJ+FFqGTfG3EgMw5OhuzfLMCP3gGW/tLuWdNpDRlfi28Pewut6kdkQQgozN+IKWzK6Hydx+CQerv4LKvf2ZyXKTq6JHmWsYonfOiG1nk0b/3V9X2i+dzq6f64fvFwKB+jR+EcdrntNHIETVFilJ2O6x7fg2e7kKIeoJguPKmoIrK/SUV+ej5PW7MkOuiJjclj3E/Elk5c4dYpDntF9vSddbdP0l5mHYwFUsKBuPHApP1cYP/A6AY5UVNZV
 nKipQsy5
 wkB/txZ45mKCr917lhDYECLDqeONXk3SO7Npem1ObWWNqbW6yWo3sqFny+nrsHupq9WqbUBLjUbDSbyNqnXIu7Uzw0SeLWZ2+Sb7FkCMTWxtNNBpdvJHvpIHTxQxfTFwoVgLY5YzSpLdLaGKvSD1Pm89heHuc9DadwdseZWH2HJuGLYsrxJVZvANHEZRipIu6VNdSTg8T813/bkCNB2Abqvp9n5DGKY3LHWtymDfDUUX7SFiw06KqZAoOkat+d4B3LM0JSdLVOVh67GCd1t46yYi6K25dnPwdQyPlxPm6lad/G2ASLQLExgnxEtco8FMfMwlAouqRNgd8eU/X6bzVzuKBo6JN/HMVY1FeVF4yLAyk4lJIpZsq4wrvGvvZDpNGEl4lBK072Wal0bwbl+woRs9jdTCbxQQDIbfa9Cs6vgZXqPbpDWJjgHfkvf2r61zIUk5j4/X13NXn+UkSHoIu/yTc+pzIV47iBQ33e0xx7VNndXdfQuF0tU35vcFpzwQQo6G3Ok2gbVSdVdXP2aywHzrL2fejyKG1QvfSd2+3BYqtUM2lBouMJQKrpdGf8dbRLPPNWiMOkdUXZwoiA2h7yjVSpFGR1E6W4F+N/8QNe18DxDm37L7pZEdImKm1K4V95IHHls4r0GgyQ8RYpNrFUT8HE2HIkLf2bl1pE52RvZUZDSU945y5/mXJvSlV+pje3X1iWEWGUP/XTUP4o0jFkgm7cTNgU1RC++ctaDmD42cBnzUnsaxbVk8exAdulWIuO1V+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 22, 2026 at 07:48:07AM -0800, Andrew Morton wrote:
> On Thu, 22 Jan 2026 13:01:52 +0000 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:
>
> > Sometimes we wish to assert that a VMA is stable, that is - the VMA cannot
> > be changed underneath us. This will be the case if EITHER the VMA lock or
> > the mmap lock is held.
> >
> > We already open-code this in two places - anon_vma_name() in mm/madvise.c
> > and vma_flag_set_atomic() in include/linux/mm.h.
> >
> > This series adds vma_assert_stablised() which abstract this can be used in
> > these callsites instead.
>
> Thanks, I added this to mm,git's mm-new branch.
>
> It conflicts somewhat with your series "mm: add bitmap VMA flag helpers
> and convert all mmap_prepare to use them".  I believe that a new
> version of that series is in the works so I removed it instead of
> attempting to fix things up.  Please lmk if I should attempt to perform
> the repairs.
>

Thanks, I'm about to send that.

The conflicts hopefully shouldn't be too bad, let me know if you need any
help with conflict resolution!

Cheers, Lorenzo

