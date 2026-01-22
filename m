Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F8ABD3EE60
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 13:02:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5C486B01A9; Thu, 22 Jan 2026 08:02:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD92C6B01AA; Thu, 22 Jan 2026 08:02:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F5496B01AB; Thu, 22 Jan 2026 08:02:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 703526B01AA
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 08:02:52 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 36EF4160317
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 13:02:52 +0000 (UTC)
X-FDA: 84359614584.28.0B57C27
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf29.hostedemail.com (Postfix) with ESMTP id A8245120002
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 13:02:48 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Aqxjwwhx;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=vVfmzLw1;
	spf=pass (imf29.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769086968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7RBkACBSpdvuYCPvlFWkQvgehMBAdoRwLW0QOdffuZY=;
	b=yliyicjlJNIo/Tu3JLzXahsxztDBKV/Ytits+2Cg4hW50QNijql7eEPZr88ZXe6K38s0RF
	RMnJH3jSBpXrvWitXZXAxK5HpfKkT0eohcuaq/pvscLb7mBob+4mdKWbNQeyWXkSiuXev0
	AnsXK82lJI/o+P3vsRV7ktXxDUzbe50=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Aqxjwwhx;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=vVfmzLw1;
	spf=pass (imf29.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769086968; a=rsa-sha256;
	cv=pass;
	b=SkZhwOz8Y2wP+/aBqGI1bScZVnSzq7ADxrI/9EImV4Cqj9+1xu63S1rrws9yltLzmdWTOC
	k8wKA0nMVHB8PZpphnlCl8p9zsmh3I62DsTIG+dhxapj+ySo5O4Ox9hT6hqsFabESgykSO
	lvGBNj4bIfyDyViw2P6/1QDNmsTyW5w=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60M0SXKN3028845;
	Thu, 22 Jan 2026 13:02:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=7RBkACBSpdvuYCPvlFWkQvgehMBAdoRwLW0QOdffuZY=; b=
	Aqxjwwhx9NgdV5sBA0wA6WPMuqZC/lwk5uYD6wlG96gXv1bM/xnCFL6I0Qk0C68l
	xbtYEIzb58JUSrIGxeFWo1R5Xxw/jOpQnkxH/ONK1Q6SIEql4O+KaESKFWyi7tJq
	ym/uo5pmeJcgg8lez2KPYMqoeQ0GHyN1/Tmey7T6jgjhK01r2o5PVxO0tO1dQIa+
	1p209ykg09n98ijvN0MXbtQsMkR+xdVqV/jXE5U5WsxjEh6OYHXQ/JEV9eUMJ0Ii
	2JGw5ouVtBnZ6CMcy9akft/IkNAhhKqkarq8lOdYLhrOEJpzUzMcsq+WKnBoisvo
	N1Ppzqq9uLCFkme3xSwD1g==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br10vynqp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Jan 2026 13:02:09 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60MC52mP022610;
	Thu, 22 Jan 2026 13:02:08 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011051.outbound.protection.outlook.com [52.101.62.51])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vgjnvd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Jan 2026 13:02:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=azkGDkoM8DWcPuwGpG8ZFUded77pdBWdppH+tdSL+jnrmJ4WPRwClkrD3w3FISygm/99Jt7jL16gKMEJ0xc/BdAs9qFh3rKtIzAAZZtlvgZa0Dd6fDc4TVWqcXow9rEwSn6WRHCZMVTe8nQNRw4SqhW7IhNIJ3l1ITd1WrVgSY0itWfi8HdN3pB5EcJA/AokFxjIt4plyYg0Wxsz8OKLc+AnbVFn2Hs0UCyW0WY5drcb0tCs4ZMEwubM3c0z9s7FhOLn6Op/ZmSUwyJNIZdetyfUuMP3MHWY3WIegemj3wBJdfU0yOMY5Xuk2otFdt9voWo82USMgLBc8Xi0nD2a1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7RBkACBSpdvuYCPvlFWkQvgehMBAdoRwLW0QOdffuZY=;
 b=IjjZl0SG66IFL0q9j1USJdEBpMKTk5N5OIpOFOq9ziTBDwjxoE64JrtuM0ISiBRHYkqwz3cAz473pOhfST8qDi2ZlOHDeY96nW+PVOGeyNmfVjRPWZajn4poWnYJqbh3A9fxhqjGsS6EcyeTHFo7BGJXTyKn0E4o2N0/WwYgdicGxORTL1KdqMGn+R3kYXXciabM6zMrTcSzcbhdw4AzwEH48ikdilNa7C6ZKX3d1AyB7JoWxGN7WLNpTq304K2vYXN6BQWX60kQEOo7qZ0xExYgzkRiAR5C0+VMDxwncBGob1MNFHhE3T29P9nfX2zxrrK4eRuQfjT6pGs5k6VB+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7RBkACBSpdvuYCPvlFWkQvgehMBAdoRwLW0QOdffuZY=;
 b=vVfmzLw1NiPjVNdcKZRXTjP4PG/hgqWe7LUqulaVBO6U1zed4C4pChJjjb/i29ygOGxxQCws1l8+ckhTV3NyKFs3MB7Qh4xW76fOJ3anOxpfj/wrLXYJmWRdfKtksygZn03iAAk5roj0vEoHGmmFAOZIVZfnxP7nz6mdIgJXXRU=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by BLAPR10MB4883.namprd10.prod.outlook.com (2603:10b6:208:334::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Thu, 22 Jan
 2026 13:02:05 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Thu, 22 Jan 2026
 13:02:05 +0000
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
Subject: [PATCH RESEND v3 02/10] mm/vma: document possible vma->vm_refcnt values and reference comment
Date: Thu, 22 Jan 2026 13:01:54 +0000
Message-ID: <a28f56dbe5057385b07498684dfb105918bf3644.1769086312.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1769086312.git.lorenzo.stoakes@oracle.com>
References: <cover.1769086312.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P123CA0001.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:a6::13) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|BLAPR10MB4883:EE_
X-MS-Office365-Filtering-Correlation-Id: 6738896d-43f0-4440-2edf-08de59b6718a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?F2B9q4xK9cJJkkQChRLieB8aHxFIpoG3gyeR8g8S5oX6PFHN8Ri7jXlnx7GX?=
 =?us-ascii?Q?ztNO1c6ZG0fXA3t4wOZOG/xVO44ptgLVS/SvExIkIMjYakLePsofp+NXVADX?=
 =?us-ascii?Q?ubvPRkqKidFqPfeIdk+HskaG0u5sVeLkNJkuni9Wee5U/MBO4Wmpm7nfFu+I?=
 =?us-ascii?Q?4WVGH57GvMUK8zTLbgBMYopotQZ5BLfToj57xGIN2X7zxMmGnJMT3Zvzknrs?=
 =?us-ascii?Q?Pgn4gEffZlFanaKT2cg2rxl261GjBxQs5JLuayAFXkdHVLqBK+PiC+SSqrTy?=
 =?us-ascii?Q?JMJBhozuxQ5TbGShya5IorEb4DNXbCu/tFii46hfefXaaQB0SEDT3oM2ZFwI?=
 =?us-ascii?Q?bgE2fQmwotVluZmTj/rySN1KqU9ti7mVFzAO9bFuUgpTKDBtKpaGb1FBHn0y?=
 =?us-ascii?Q?H4vytAVXbP8Kdq4YFpC4sWpKmMJU5X36NoM19vLDixrML+rV8dd3CrAfL/60?=
 =?us-ascii?Q?J/BFTUnK8B1POQMEH7LB5GOAAAM3gK0TqudGm0ENe3eBdRa36sir/7HgD/CR?=
 =?us-ascii?Q?oF22ARmnKH4NdbgQASMYzI2bWPKPtEx1zkCS8k17ZH1p0Tdzv/IdzkOkc+aq?=
 =?us-ascii?Q?UJDV3VO0jpEdHufnWt1KauEpC/JqV/99QCVzOL0c32aPHWBEWXh34aMSWFeX?=
 =?us-ascii?Q?sb5j+SC2LPikz+X2XB165Pky+00mXOpsHOKq0GeoYg7PtVUtw7hv5Qe6j0Fn?=
 =?us-ascii?Q?DrP2o/Xgspp+0fdA9uAuH79lXfcKZ8+OeCaPjvvB2zevfUZaAqVPDd4y4vWn?=
 =?us-ascii?Q?n2kVNpy85tUnezJyR6MMEUgeYbCSLWqijvnht2I5SKZWic9Faw9Ujr39J7/j?=
 =?us-ascii?Q?UQzgzvvcus2SExGHKgoXb1+VTevFxdRUyvygLJq1PifsHuDfyS4Id75k5D9i?=
 =?us-ascii?Q?4cNrLkln9ErWEH8+wh3/CrCXkq6hAO7U1gor6abEcw9sMZAdcjpZg0ZhPUX1?=
 =?us-ascii?Q?pNQxBWoVfPGgYLm1eJnT0u7fT35E4rViWKHKxI6ZyadCWW2vtMB9Dx1Q+q5M?=
 =?us-ascii?Q?ApubdVpG/CK2FjVL6x5F4HNNMyr1lqudSG8NkxHA1rAc/yNxCIfiqV2lnpiW?=
 =?us-ascii?Q?YUuGPYRNrON5SPFu+0QwGP4UBrCtzJ+5QrJ8Ek6Mxte3XSqcwMgYFICeZJEX?=
 =?us-ascii?Q?/XPgiuAMIRKge9auqGaSkksTFKEZGmo7DxNtrp7Q7u5/17xVzpEpeu3djf6h?=
 =?us-ascii?Q?5f8olqNoPbt5YHpeF/gDNz5zaUkidOJz33uqsphi2ymdRedL1I8Duop4d0UI?=
 =?us-ascii?Q?zAPIbqJTBBFIjCuXO366lDbBmuua/AJD5srsnytM3TcltvVQ0qI5GdaH3d9m?=
 =?us-ascii?Q?ife766DBpXwH0XW2DxiqOqvWjcs2pJFnayJoHUVy6N1nFJc3mH9pK2RTCqa4?=
 =?us-ascii?Q?uWwZpmgFokq3fX5YArBWPicmEKiPGi3TT6tJsIrgSlOZmAg+2PQQgI6MseHQ?=
 =?us-ascii?Q?aJLxcb77zKAQtrwPwbkmjRBuovUjKQ+4W5HdKscZQ7MUlTs10CHCKl8K+VQ5?=
 =?us-ascii?Q?X2GXAQFqODa8epZXzcp8tvHKp1e8n3N9T+VaizlEsQme53ZY+XuvDplPD1YQ?=
 =?us-ascii?Q?RwxRioDfZiE+52ytW0U=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?IjOXgSL/EPsDNLkEdn4uSYwVH8VOaDZxJw5p+4VwmnpUXcpu8UPF1qMO4b5v?=
 =?us-ascii?Q?lqZJFBpfVwQF221hcY9Ml7Ju4W/+btGFE5fZhngFSvxHTCixIQ7brA0PiEtd?=
 =?us-ascii?Q?qKYA0kQDwVscq17DJUHQYJB12Hlibbxd/dCyTTBHOSY8Ee5gnzXYg7nVM6T9?=
 =?us-ascii?Q?7C9z/2y5WLiBqSVl/0xDupMINyAg1ygy254gnQFrVAmqAm6AH6Pt2c9nyOpa?=
 =?us-ascii?Q?bMZcV/tKQ+o1SM8LvENYrZ7ypFM/f2UJtUnya4Er/5wRVxPPILzEKH5Tbczb?=
 =?us-ascii?Q?cItip7WsuS0k2k7S5iHI3fNdKOnPglGbJCLh7o16Ax/cjr6w1QfDwDkx6FcU?=
 =?us-ascii?Q?M6+rKNkLTEoYokSBR8zw9FiH8dZIQ6uj3ka2wJfIutmfaVMcZdm+Bs8eYTnN?=
 =?us-ascii?Q?5T422defqxxSgS0g1BDgSkovdVucLKImVXl9DNHEepxUl9FqG9+NfeXiYChY?=
 =?us-ascii?Q?GcC+bdL0jDG5Rt5A9vBZF/xNr395Zq0XU5oFM/0BDel0IR8E5e6xqsSwyG3m?=
 =?us-ascii?Q?HHOqgun2fGifQ+4eBXWuMQE9vdTs+QDlzEQtio0P966eiCyhKrIgWzf5QH4Q?=
 =?us-ascii?Q?c1BpfMhiSzPmSu+zREX+5c6Gzo8Kiivp2+HOAVpGY8brSVmS7+JPOJ9Tw4kI?=
 =?us-ascii?Q?g91utgWmgDTgK6RMBJtO0jQRQyqV0AgukX4OIffn/Ee+dkI2FdSpSP7IRz5f?=
 =?us-ascii?Q?DIHeeHgmh5ZafVSKPvPlFhox8LP+CN8vRQLjpqwHHUQ4z8MKcobbj3zvVGWk?=
 =?us-ascii?Q?mXpX2NQJWy+gMQpYr1VRTGbFF++UOYsG8s9vfSohxTGQm0SZqyXpZR0eOH9Q?=
 =?us-ascii?Q?6vtZlg5Lb1InT/LB3YukR1Jh0jdPd61mOa6EQqCxaUbaUVxKRnvCkGQ9tUTU?=
 =?us-ascii?Q?/f50yC4oFrDoGhZIXnGiI5Wjrc3y+nTYAmhgFw1PbDBFXxyTtVdw3lzpxHhQ?=
 =?us-ascii?Q?mMlcynkNKPH/ikcczCMO5+mbZAfzS0kBF2xWqj7D1UY1pUyLnMCUDzI5VgaW?=
 =?us-ascii?Q?n6CPCy+QiQe+lpu2A5s9s7u0BIckiaQAUdL09Momcqm1/Zf0lbG17/0uTubz?=
 =?us-ascii?Q?XiqBA2eyZJpFD/ngZ+WVUPHlhbdZqXqI1bGGgE5gh54QYwPlBlTmUOrfxbeD?=
 =?us-ascii?Q?hQ4loRyG7av0Nt/OHeD7IoAAEe4GqIKzi7XIsc/EfaIFvdeMtbS+pQdGV6PI?=
 =?us-ascii?Q?GdiuTlLJMoQ1fLoiX5UkU4JgTw/bWHWm+OWquUbp7Jg+Lnz/1SNU0C6iUQoN?=
 =?us-ascii?Q?JEhzmpv78DIi05R8kEYA9+bbeh/Hm1bII3ZUtLLZnyONgN8Hd09DbWU9rLU0?=
 =?us-ascii?Q?UN6Ofe8W2gHnaiIuBVDIlMGq0/kkQebjxeKZ2e776hldvyPYMzt+4CvcyNbn?=
 =?us-ascii?Q?wl9b5SwB1VaFAfhcPDj9y5fcAIAj28F5qd9uaCD6KlEUblzAPqKh4iA5tcM7?=
 =?us-ascii?Q?UyVa+l+UohN5Tb+fc6CW+bMkImTC30iR5NzHSLMx24TOnwLIJKvC2J+6VMTK?=
 =?us-ascii?Q?lsY/wPtXwORFctl4ZrfNgnr9k5QPrYRnMGfGqLeOSVzTFqqjOa5g2BRssIvj?=
 =?us-ascii?Q?FtWgVXIDkogpOQccbSCmuJOsE3N3VNnE/bSp07WRC5WDtyi73tNET6M7T6dE?=
 =?us-ascii?Q?GiNIwh7cPJGE56nrfu1jaotRP6atQ+vT5rWV3seFzLHFOTFTmJjRR6ivfysL?=
 =?us-ascii?Q?+V1kKf1gFtS/WsNUfJeeYTmYrsPBvg8CYdH6njZawyk0ImjjjRH+7H+JazSV?=
 =?us-ascii?Q?Zh1nt2MJWeJtgZxremlpuZylGwIcgjo=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ya3Uxhxdrww+AhXEPxH/XHxnP/MRVJ6zU6TtrQUt0n/nglU0T3tsvqw+p0haBn43Np0pKGm5jLekqtstaeqbP1uc4DJ4250F+dvDAVo/o+GyOzpOfdZTlEha902way2en0wx6fF8Qe9z4RizEaE6EEkUvB+kcTXJvxfRb2l+iApR2R6PaBfSp0Cy2Qrz3sImQWxNgZVpEZ+h5tFLg44mxieksBGbYltShii80T4HwjGLC5I98uk+pJdIuubKVrdxNV/Myo/8DqKiwUrj1YNOObwLqPVErGCrLGJYOPEAkHp+ifm27NZ2oPnIYcicykwW2RzYchl5idC0YQcxZZCmT9ioJd0Rdd5Ogrv7r6k5hUveNWWu27OO0qFxuIgdbYd5PrWLhAWp4cwmtzPKeRNwNo+zTHt6Y8HuoDtwapr5lW1VBQXDRm5w49JPJHeenzDwPonDiepaKbEjJtNuGzznkzwfue/CEwzHvCrQUuxQtHiLhFs1mx4bajoNpRxXHEvf0Ym0V5phsj5QDYsaA1CV9Z580/S46Ur7XM84dwNbgq8OixI+U1pE8QXivyCvxzq1fi41W5e0m0ZTRhRaDraBc0vTd/zGYaVWDT+rTz6O6wY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6738896d-43f0-4440-2edf-08de59b6718a
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2026 13:02:05.7833
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kC49dEypxjnBLaCJt2b18XGS4+ZFvpjLRh601O+yUJcJlDCf/c5QPUMu1H+xOzPeXkKRngPx0josjhlwTAmB1ft7dgkQe1H9C9fIJQSi3rc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4883
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-22_01,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601220097
X-Authority-Analysis: v=2.4 cv=H4nWAuYi c=1 sm=1 tr=0 ts=69721fd1 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=px5gXGW_QSS6PAkXjB8A:9 cc=ntf awl=host:12103
X-Proofpoint-GUID: t2uOjZzRd1LHl4JOAW71lsUm_AXN5bXX
X-Proofpoint-ORIG-GUID: t2uOjZzRd1LHl4JOAW71lsUm_AXN5bXX
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIyMDA5NiBTYWx0ZWRfX503/btu6FzuO
 JK7pAWSahL1afwlTdZQI9AI33ExtR49P2P372f74Z4466d8wWccdUu21tfGqfS4ReCQIgjPDMnf
 POXJXw7eYWAywGLRLgZDfcgQPXLeglt6xfXgwqeQNS8H6gWo1dahcRUWempqQb5/TFFctkk3Ias
 Jsi4xzgOzV8zFboAL9xrtDPAADKlr8luzupKWxzQw+0mXEc8MtHIUqm6Gyz8Vxd2B1eQvDcqTdP
 JPm9P8ZTvPRmQrXFDwgpGZRIB+DLB5p55KCp0EDlmKMXjbSojgEtYZDciudwxGkI4V5omrOmGYD
 gVXscId+I1onSLkQ8GcLGLCmIy8H7BMJthlLr9KOp2EhpKCQUiaDoQIonECUX6VwteBn7zDTgqc
 WdocdQI81s4zNY/ix2WlvDJVlLjjDhk9rJd5LOU2Zm1+vTHr7VsTDTCbDgDkvv/rnfpBbxCtLlk
 JCaK/n+WaoYF9LYs+vAYtvX+TGjR+wulaKm9bArU=
X-Stat-Signature: irgejdch1sb6wgnzjfskzsmdndkdyn8y
X-Rspamd-Queue-Id: A8245120002
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769086968-879045
X-HE-Meta: U2FsdGVkX19VVuwbI4Q7ZGNgrw72WWf9r32msIROuIGdlDgbrsLXBxr9Uht271kZ//6tBczds/5ThmniG2zwQwL6tQDXmov4QDJsg6v7JLAufieo1rW/z8/+tI/SmMTsaGoTvrlJqKGBqfOhy9tbAw5GWtZR1YHCH9pdrj20F22LXTZa7aolnhfEKLuUSczSGjzIYIcvWxaHpCqH5gJbzvA1zDRHXLLSZ/N0+4EeWBXrDtdNPhE39fK9colECb5j0p0C8EBF77/RqaG9GTrAxgbY2Bx2UvE8D9pK/8N2bxjWDrbCg2XxpxfukVUYQ4Lj/Sm+kJKut+2gcOvbFk9x7VkpdRZQEyRCDqVZRB39p4Z1EMY/BHKKPHEB26xMmyk3dWt1R7YOB10R3FTYMhFxkcjHCWwuoUxZNA1ACp5y9GhADNcL8BnFwckKpxWWNFY+RJK5DBLFBfPfUXC6cOqljZHWZLSEApT0EHTVPQXXvr34PgHfzgkYmD4vOlq61Vvx7YiC2qNR9edfFkJPzWmQjhAuu233L4xtaQp7OgZQhxLgli8qQ9agbINtvuCx1DhV60uBPvTOW7DzRxuxgVYQVC+fSAX37YJT6/wSAtzEnJLzTTQyTERYPQ/HnAAefDa4e3UoqhI2PWH9G6zm3BqvQy1QhUl0J/EU9dlk2lQD90rediBsiFLx7aHEbM22QwXufzkKra7GYYoH7dFZ1AktPGQtn/5DlQZ8KseIrAk99Tw/YJW/piO0wQgjaR/PWBx1bU4dALe1i7QUJDUd0OLAjq4u1SYWM9oqjCK6YbBiFUgObTFW4d7fzsyztZOr/RHxCZSIabwO2qtyxcf48nBC0YNTpHN6GY2DnRXeeej06M4BcY7LX06CxR/pbeQGR+hzk/csLfaSw8ZgalMgHMQZbTtXmo9Mgw+Tfu5mmuuxatf1A9fuQ600qd9eLzOQ0tLjudoef/Qh6nSYJc1PkU6
 N5ToK9sS
 3djuR3qmN5eVPZk7iAht6H3sI2vGjY5Vjb49tgG5u8QL1jXU1t68aTwTpD2i0L0uJe0LqJ79r3nU5NZaMSK6kiSJeCEscnZbQ1hsgjOaePHwyzx2aMBFQORR+syXyKgkXBhFlyOIhAYUi2u7MU2zcuUYCBaYs+D9rvFE/f1mfNofuUkv5BfH3CD6KYyrTKIBK1FsGc99yY0woYwZyVNtCH+NkOEtFntWU6nuS69wi/Bc2+TzNNKFM+l5BsYgtrl/VNy6bBAWOaflHXfAa8hAl7HJiIk6BzrkUvT9elNiWrtXoJyD3VHbMuvrQm5WL2u7hMo8AULP6VHNPTxovA3Yzx/0TRYLo/+NPTke68l9fLj+i+X9uzLn8T8cnNoY88rKZ9hMvk3bWVvfI9pBbkdx/Y/tyq/HAYEWEUW/O81bpVt9ajMbcLAia9g0AK0gHcBOXg3fWHfhelzZ8Q/0UNjTOTs6uZkIAtjO0DL2l+yUpXosZ8ekFpDlicLRBXKfNjVqsDKjbK2fiHYSLjYCcvW4gXZkQBF6lE5ev5tdvditmjXi3uBIoi08KLKEBQe8MuakTyXdAzaLgag4wRxuomh9dzn9/WbFUqiJlUoJ5xdS96+QtOn//yEvXqyjqkJj0dEdXpEzqbv7uHYvBnLuulVluZvmUSB7dkCuNSeZHbJRJKnoohR9iSyq3YMsmYjJzazYuDGa0+RUid+Gao6ySBkJPjMXlczvK1cyDvlrgq7n+yQhVlO3daLVgopu88PazHc6S3AmJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The possible vma->vm_refcnt values are confusing and vague, explain in
detail what these can be in a comment describing the vma->vm_refcnt field
and reference this comment in various places that read/write this field.

No functional change intended.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 include/linux/mm_types.h  | 39 +++++++++++++++++++++++++++++++++++++--
 include/linux/mmap_lock.h |  7 +++++++
 mm/mmap_lock.c            |  6 ++++++
 3 files changed, 50 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 94de392ed3c5..e5ee66f84d9a 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -758,7 +758,8 @@ static inline struct anon_vma_name *anon_vma_name_alloc(const char *name)
  * set the VM_REFCNT_EXCLUDE_READERS_FLAG in vma->vm_refcnt to indiciate to
  * vma_start_read() that the reference count should be left alone.
  *
- * Once the operation is complete, this value is subtracted from vma->vm_refcnt.
+ * See the comment describing vm_refcnt in vm_area_struct for details as to
+ * which values the VMA reference count can be.
  */
 #define VM_REFCNT_EXCLUDE_READERS_BIT	(30)
 #define VM_REFCNT_EXCLUDE_READERS_FLAG	(1U << VM_REFCNT_EXCLUDE_READERS_BIT)
@@ -989,7 +990,41 @@ struct vm_area_struct {
 	struct vma_numab_state *numab_state;	/* NUMA Balancing state */
 #endif
 #ifdef CONFIG_PER_VMA_LOCK
-	/* Unstable RCU readers are allowed to read this. */
+	/*
+	 * Used to keep track of the number of references taken by VMA read or
+	 * write locks. May have the VM_REFCNT_EXCLUDE_READERS_FLAG set
+	 * indicating that a thread has entered __vma_enter_locked() and is
+	 * waiting on any outstanding read locks to exit.
+	 *
+	 * This value can be equal to:
+	 *
+	 * 0 - Detached.
+	 *
+	 * 1 - Unlocked or write-locked.
+	 *
+	 * >1, < VM_REFCNT_EXCLUDE_READERS_FLAG - Read-locked or (unlikely)
+	 * write-locked with other threads having temporarily incremented the
+	 * reference count prior to determining it is write-locked and
+	 * decrementing it again.
+	 *
+	 * VM_REFCNT_EXCLUDE_READERS_FLAG - Detached, pending
+	 * __vma_exit_locked() completion which will decrement the reference
+	 * count to zero. IMPORTANT - at this stage no further readers can
+	 * increment the reference count. It can only be reduced.
+	 *
+	 * VM_REFCNT_EXCLUDE_READERS_FLAG + 1 - Either an attached VMA pending
+	 * __vma_exit_locked() completion which will decrement the reference
+	 * count to one, OR a detached VMA waiting on a single spurious reader
+	 * to decrement reference count. IMPORTANT - as above, no further
+	 * readers can increment the reference count.
+	 *
+	 * > VM_REFCNT_EXCLUDE_READERS_FLAG + 1 - VMA is waiting on readers,
+	 * whether it is attempting to acquire a write lock or attempting to
+	 * detach. IMPORTANT - as above, no ruther readers can increment the
+	 * reference count.
+	 *
+	 * NOTE: Unstable RCU readers are allowed to read this.
+	 */
 	refcount_t vm_refcnt ____cacheline_aligned_in_smp;
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lockdep_map vmlock_dep_map;
diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
index 5acbd4ba1b52..a764439d0276 100644
--- a/include/linux/mmap_lock.h
+++ b/include/linux/mmap_lock.h
@@ -130,6 +130,9 @@ static inline bool is_vma_writer_only(int refcnt)
 	 * attached. Waiting on a detached vma happens only in
 	 * vma_mark_detached() and is a rare case, therefore most of the time
 	 * there will be no unnecessary wakeup.
+	 *
+	 * See the comment describing the vm_area_struct->vm_refcnt field for
+	 * details of possible refcnt values.
 	 */
 	return (refcnt & VM_REFCNT_EXCLUDE_READERS_FLAG) &&
 		refcnt <= VM_REFCNT_EXCLUDE_READERS_FLAG + 1;
@@ -249,6 +252,10 @@ static inline void vma_assert_locked(struct vm_area_struct *vma)
 {
 	unsigned int mm_lock_seq;

+	/*
+	 * See the comment describing the vm_area_struct->vm_refcnt field for
+	 * details of possible refcnt values.
+	 */
 	VM_BUG_ON_VMA(refcount_read(&vma->vm_refcnt) <= 1 &&
 		      !__is_vma_write_locked(vma, &mm_lock_seq), vma);
 }
diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
index 1d23b48552e9..75dc098aea14 100644
--- a/mm/mmap_lock.c
+++ b/mm/mmap_lock.c
@@ -65,6 +65,9 @@ static inline int __vma_enter_locked(struct vm_area_struct *vma,
 	/*
 	 * If vma is detached then only vma_mark_attached() can raise the
 	 * vm_refcnt. mmap_write_lock prevents racing with vma_mark_attached().
+	 *
+	 * See the comment describing the vm_area_struct->vm_refcnt field for
+	 * details of possible refcnt values.
 	 */
 	if (!refcount_add_not_zero(VM_REFCNT_EXCLUDE_READERS_FLAG, &vma->vm_refcnt))
 		return 0;
@@ -137,6 +140,9 @@ void vma_mark_detached(struct vm_area_struct *vma)
 	 * before they check vm_lock_seq, realize the vma is locked and drop
 	 * back the vm_refcnt. That is a narrow window for observing a raised
 	 * vm_refcnt.
+	 *
+	 * See the comment describing the vm_area_struct->vm_refcnt field for
+	 * details of possible refcnt values.
 	 */
 	if (unlikely(!refcount_dec_and_test(&vma->vm_refcnt))) {
 		/* Wait until vma is detached with no readers. */
--
2.52.0

