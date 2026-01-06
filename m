Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F979CE9D4C
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 15:21:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CB606B0093; Tue,  6 Jan 2026 10:21:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 981DB6B0095; Tue,  6 Jan 2026 10:21:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 859956B0098; Tue,  6 Jan 2026 10:21:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 70E756B0093
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 10:21:49 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 43BD487C48
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 15:21:49 +0000 (UTC)
X-FDA: 84301903938.10.4AD5F1A
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf13.hostedemail.com (Postfix) with ESMTP id BF8A22000B
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 15:21:45 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=dRdXbojq;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=MA0RcQPy;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767712906; a=rsa-sha256;
	cv=pass;
	b=j/v8TORR0bQPB7r19TGJkSz2ieE3xKS5Qg31Z0NlMGwWL20R2OsmiGSi4qaIDcJ/q9lx47
	e4AR+yT8tRMepePBvahHyJ/jnvWA0idIwHx5f0lzV3tzgrlaiXnMao3QxlJQhbGjukDYVk
	jOPDQXG56aIdxNQCgAd/7oCD1enBEak=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=dRdXbojq;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=MA0RcQPy;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767712906;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K3tf7+ouUcpFlNOH4iPndQBJzGSyfKIGvRgbU/JFf5M=;
	b=WOMfmPHoonFcmQODQYd3Pbb9NkLgOLfGvYSQMLW2byvTrFOUfRqoKQLf9pUz3Cc+F7Gi9K
	eQur1+HWKx6Z+qZ12R94H8HVP32iy0ZI5TSozjn35/vBN0jJ1oJ1zXkwb1r5jNYsRz2HB+
	cDytHhou9Fobbxbve/PynOydZ7z5sdI=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 606F52Ev3789609;
	Tue, 6 Jan 2026 15:21:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=K3tf7+ouUcpFlNOH4iPndQBJzGSyfKIGvRgbU/JFf5M=; b=
	dRdXbojqEolJnukEQ82EudpM35RQ166cFCzwNNDPRWtd0ntHB2irqhlZ1TmMgvJL
	z2JcnAr4XVyTYgNtOnrubM0WIJkUWzhu0NxRoSaWDzrNzVS5qAPwijP0QnOha9J/
	fQ2dchaUQQ/32+1Hcgt1WDJes5w9mcCGRXQggXNOfd++PmYVqX/vFk1Bli0BOBVf
	LHfeA+Cn8/ez59+OgP5SClmhpKrwrZ6aitRub2ziknQN7g4YXyGoEUETW2y5jQNl
	4PQLFcYwfJACsVAQ13s7FTfHMBcKCD9pUxYoS5BLvCgpkjg4982dJYzpxOaYHB+j
	ihWLbPXiTZYNSEckNmhCwg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bh4qm80uw-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Jan 2026 15:21:40 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 606DO507016243;
	Tue, 6 Jan 2026 15:04:52 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010060.outbound.protection.outlook.com [52.101.56.60])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4besj8em27-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Jan 2026 15:04:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WcSWN5p1zRpT8+C3yMu77X2QuwnYqGrM+KMtQcCq2JCG7juLn4m4bOTGoj+d9F0MpVhMQVA/jI0RTmh8W3Hy0crDyqs9ZDj7zCI3Lojn1d3Nk2SAn8ELNWSYPLWAfCx3pRmOk7ZSxN8VqmM5nk6qg4PXflPvQsVosAZUa9c+xyKpxVZa8AvQ/LHKRmkpBalXB4yj3AwRk4hRy40aInr+fc691Fpf3b2Bdb/QYqD4MYSdHThKiA0GOOnL3/tmgjszFPPv6NWGsIGhSpXvfvOeOepgpi3B8HMLujjirORSHG5METQyCtJegjsSUkaK6dpE/r0mvpkrM7D/nxW9EbmIHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K3tf7+ouUcpFlNOH4iPndQBJzGSyfKIGvRgbU/JFf5M=;
 b=IQ0MMHNm3DZm+/tDSL1M5SHywk4n2ACk46ZdKud+4Yst9nyAdL6blGNWwcbMSDqTUTM9gK68cs8S6tgcIdRAjusDQ2dFE6VfzxVJAeq9rXHN0hPKKiyZfcN8TqSx/AkOyLMk2MRNNNoAioc6sX2RlSdTmsYmgBH0pAaSnBp8jlCIZyeTxbjDRF2gF56xeCn6C+3ywh2vW5CoQlvB6rbWzwGrdXhizJQc5x5H0Ve7+Igvr1X4hsrHZhy27SmCKVUHRgGsHA+HiPXe4lUQeI2rqXJ2uvxPYxmayuOWc8K8S65ZjinbojnDSAJehEmhTjKgm41z2NS6oB0qxzcKNqlmjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K3tf7+ouUcpFlNOH4iPndQBJzGSyfKIGvRgbU/JFf5M=;
 b=MA0RcQPyS2SrQHeH5U2poajiBBAPDC666+vZYhINUjd/EJBn2IU4xbY8D98KXf5gpWwl5gTiQHvizjbjbFBb2CLc9iZIreJ4G4GGmcNGqdnrpuZrqQV/Uyctul/hzSc8ZAKFiJWxOEiAUOARQBzwbcGHvqzeG4lpzuaSqL+Fu8k=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by LV3PR10MB8083.namprd10.prod.outlook.com (2603:10b6:408:283::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Tue, 6 Jan
 2026 15:04:49 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9478.004; Tue, 6 Jan 2026
 15:04:49 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>,
        Harry Yoo <harry.yoo@oracle.com>, Jann Horn <jannh@google.com>,
        Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
        Pedro Falcato <pfalcato@suse.de>, Chris Li <chriscli@google.com>,
        Barry Song <v-songbaohua@oppo.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/8] mm/rmap: make anon_vma functions internal
Date: Tue,  6 Jan 2026 15:04:30 +0000
Message-ID: <01fb330542cc1b9437c1a9d1f54432b0547a1582.1767711638.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1767711638.git.lorenzo.stoakes@oracle.com>
References: <cover.1767711638.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0003.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:62::15) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|LV3PR10MB8083:EE_
X-MS-Office365-Filtering-Correlation-Id: 7801e24e-b9f9-4eaf-bb6f-08de4d34eff0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?dezpH8Tw7dLuSAg89zIsMlvE/qnIhlFTFMPVG2aVwXplH87nPrZ36jb8l+te?=
 =?us-ascii?Q?Qryyl9Ys+Au5puJRXQUqXPGgdoEmJuFI301yoot+C74MuQhQkLSKosmNE/a3?=
 =?us-ascii?Q?lljDZFgl1TEWW1etcDheO0LV2RjqJacG8Y7ktbjMmhiXhf2nMN2av37ZD3NE?=
 =?us-ascii?Q?UpMn57F4rLk8EBPSoXwb9RPPmmM/Mrci2aDKP/p0jNN0BvgjV8QshKxBoKiG?=
 =?us-ascii?Q?1o7lwioMoxHdeF+08iS5xujiNNlFWxhb930IFR5qvilaccitI5o61mxDSjED?=
 =?us-ascii?Q?AR434j+K9IdFR0gCQYEKnw2R3rypAueOzEkZGqhHZlxJnOuNeD13FYq2xgfu?=
 =?us-ascii?Q?+i30UBt8irQh7cLqHHo5H8p/qG2W7odvBOTcesCspUckU19JOwKICCIO0/9Z?=
 =?us-ascii?Q?BMJl21A74i8Ln+LURKcWN9bS0IKsMWWB3waRxTvWAVGIqTAQ3n6jDMUhTmi1?=
 =?us-ascii?Q?VlmomO3/t39Fj3g+RGOJVRmVH0ztzTMcxUdBfbjjvr8j4l8PK4UsP6eq+NGr?=
 =?us-ascii?Q?n+i/3J2e/rsqtRzvDbDLRToDJKJJh7y7bX9zb1O6KRUSWChUaiGGo5vc37KM?=
 =?us-ascii?Q?TLYxPX7B+9shCF0vuGGp8hSn9SphmXi7jR4rYKQQWaPD+bWO2kfPpiVcpfu1?=
 =?us-ascii?Q?6MwutPnSRvBgKBH0ifNNaa3H+iGL9+n18Iktxb3xOGAlvZ2/xZN3L5Fa8XV0?=
 =?us-ascii?Q?vpON1TQwPvTqUsJ3TUFDe2V1uULt0GihbdSERXBzv0hZ39hvTV5o/BVMwUoY?=
 =?us-ascii?Q?PyaVodRHgXflzYvcUTQO45NeEwNNs9dqv4rxKzaR6LGACHKBCLdWOowrWjui?=
 =?us-ascii?Q?gjEhkat6a6HnXJbzr6C5ClPDu1Xq1vEHh6s5ToE6QKPuw3SQJfKOaNk93o/q?=
 =?us-ascii?Q?V+oXBc3CgUhm41pEJkWnsJoWiz0uLoagu4wiBTKs+3BqbOBGN8qxUjFM+/kz?=
 =?us-ascii?Q?I4w0/G6vVW5UmWhyBKVKSRgKOzpHGiW/3aUpXlOl7aZ+R7SB0bTPPYaOs95J?=
 =?us-ascii?Q?+T5SVI1bPoW+uWVbXjRQgzV7b9cQ8sxPKRjKETDSyGPdP+voPUOIKEQ1Cr6I?=
 =?us-ascii?Q?MC4w5Oh/2FKA7BwjM5YpMlxJS/pE9GNdQh8LmaZs80u599kXe0KbjIY3XAXV?=
 =?us-ascii?Q?ETcWmtr+Ajm0Z3tm5BzRleHczheOMOSDYO6K1CIZ0f0yxlXMzWoHYie6vjJl?=
 =?us-ascii?Q?TVse7L/We5clabdz6R9LK5ibI1TGNBxf9eLzZMLsxfD78eJHrGroz6lqUDvB?=
 =?us-ascii?Q?cBMAM/Jf4waxQowsW2HbSk7qGcLGNxyZEs+2UR6ozvULajib8zSSDvZqgRC/?=
 =?us-ascii?Q?YohcToo/vB6eyyYpumPjD7TJqr6A1unUujbSwj5lmTAb1JvoY0+kRiqkZsml?=
 =?us-ascii?Q?gOYMLmBjCE8gSjEHEwx04Vq/97+gJ8Js8ZcnvdDviekWIA765h/19H2dmbd5?=
 =?us-ascii?Q?6WLtgTwNvAxpafOJ21TcBjsQlLVION+b?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?SVPEKS13APb5hHqufEkeJyiToCPbV3ojUlDioFenFOdrjsyltIWpqEhAXa/j?=
 =?us-ascii?Q?jmrVb5HOk+TKkYKkWawEYJL5fHgitQq90qb60i/N8+t2hg8MLJja9i705OD5?=
 =?us-ascii?Q?9sRsbvjSCUJhoCNRqetTWfs4QZusV+uLoF1Ge5e7G69He0UfIdpUzJOyg4PP?=
 =?us-ascii?Q?ce8BBe5PWN8qzqjfcV8wtauKsKAtuJUZDmdD9nPp4iaxDK+7WqKe04gT8ym6?=
 =?us-ascii?Q?WkdIDnf1xGv6xcASRQgVaV5rYqTK4Pa0CSonKYY/7rNSO85bIsWGnMZ026+l?=
 =?us-ascii?Q?e4TYCrkf3AzuJnhI70cdZxTXTmP9kJRgXAbkUB1UzJ0oX0Eo41HObNzEBSTw?=
 =?us-ascii?Q?zHIsXw/lFjWmROmYO2D10/2JLBo/0dYQv8T43TjdnMBpSzKVzfYL8XWcxDhW?=
 =?us-ascii?Q?n+hVdD+TwB/TKD4qJut6siMQEOI+7qjtTSQhwPqeBnK7YX3+W4uaDD4UVYZB?=
 =?us-ascii?Q?pXwSrAqmSub2ARKmfrotrRyqoVilkeVy1JdPVLkXAACurbOzvn8UmOrtwzaH?=
 =?us-ascii?Q?RMm9OkEaKvecdYNeF1HSManPymVyP0NVQd5OEhEABd2Mi6vdT36wh52IB7j5?=
 =?us-ascii?Q?NuPj8NEG/oBCbQ/tPzqD6/zkL8UdAjT0+MWiB2ISayPVIdj+vUtX/bvSyX9t?=
 =?us-ascii?Q?7QU4yGxdZAaQS8Wbggk/i6MkK88+wLKO47kJI2yokX1K7wxqEt33KBkwjxT8?=
 =?us-ascii?Q?gQnSWK6tFbt8r0z5BD4Xx1qMTsdq2/kuKOEuCgTaIYtK4VusKY+HUaeIgT1z?=
 =?us-ascii?Q?qbmQE7mCFCUUzMuBIO+pKaw/K+XeEOsnld7aopyhn2r2SDzKDlBREkM0GPQ6?=
 =?us-ascii?Q?yln9L0cE1DVjIJ1htCUHP0DifAaeRwFi3J8u0hsSNknx08ymBzP2z1BY66Yo?=
 =?us-ascii?Q?CArwPPcw//iHi728B+hnJkWhS/kPYlw0dMHTWoyzup4PzOzUProHnaW9Xvtr?=
 =?us-ascii?Q?WC8doY+uPs+FFFeggOQzW4UC2bskH2EE+O2YOVWWtgZ58dQTm12hduSqx19+?=
 =?us-ascii?Q?j3mqa9JzNQw+ZegbEWirb5LbNlgKe3W55Hza9B10EQCb6vqlKVVAPmupDiCM?=
 =?us-ascii?Q?wTk9rZS8SK02kiPNZeZFHYA6KGtj+0/kaTdbFzCzc47HChUzW3ux5vQYVbs3?=
 =?us-ascii?Q?2lFVGrPWIIAHzvv3IP+oKf0j5Sj4u+b1IxOdhULUc8ZTeGQXMb9DRebszUPX?=
 =?us-ascii?Q?6XR0FSJS0MsIyITPKzUOObMP2T4DVK8q7mtdmarZuPz1OmOvo/+e9gKPQ56b?=
 =?us-ascii?Q?mniZRbThJSpiSzxN2EkB5Kv44Gbh6bkVNKN5grvQXfaxA8yWvbJLaPdrp9r3?=
 =?us-ascii?Q?uej6Ik0fwJFslAJupVS6bsjk2NaX6QCW6dI+NJ26khgGEKjoda3v5eql1F9P?=
 =?us-ascii?Q?H5LPKoECLFhOQvvbYjZBi3e9FLHCfNhPlFfRUCvnsQjPI+EKeYiCsPJxnzUy?=
 =?us-ascii?Q?5h/dCeJZje996PArvWff8zDadeVdUOBa5LGuJJsdOBubbhel7md4vsqQI7LK?=
 =?us-ascii?Q?VOVgCjFEyL1rxASRFzFOT98ccg6DmYdmxvdfYMBqCCtXO0VtsPt7l9VzUM7M?=
 =?us-ascii?Q?4tizZTIDrmRZAQZQgnl5S4ozkM+6y4Jl+g9+zGzGuJQKava8fsI1RFhOaqyp?=
 =?us-ascii?Q?ybUExV7kI2gPYUFcPM4m/O2igW5E0YL3MBfNSsdrlOl6gD4olrvXQIQOTEXm?=
 =?us-ascii?Q?HvxB3EBmEK2hXshGTVqfsPit2ztl2k4ojqG28Wxm9PPJX8VsbYkiAb6VCddc?=
 =?us-ascii?Q?+9KFEPz6aNIlgAQQSAf00ZZMaw1TPog=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	SRbGkhuPgvY25M2vzCTEYsNvCRvwXtWhJH2oC/2LXaIX7NTO7cXI6MZsnCRh88RbPnFs0waKLs7s9Yo1sFRWDtUTjP1/0MX7ffGHDZc6Jgqx65zCxuwE3JQEZYsWWWjKyd/gp1Y/jNp4dSC3H4Q75Q/xwNpyU54uwOHwObEpQoG9Hqe5qmwz999bj4VclUnbShIusmM24oo/m88xnPAQHK3Tkvor2qY2BEkYFoGgAH3tSueiWxDWEPMtL5NI0UHcU92L/I86lX+V3z6hqItLSwZatjKNGiM7XO1CH72DCwGUecEXPqpNW+cvNgSfsqvLS4fWekE8Scg5yq7Q6BggcbPz/VzHfPM8DEAd/9oJGxgwJRxWcViR2BDvN8E0RQ1S/wVR8hnIgjP9fVNPOo6gYObwMKv5qA3ccGRMEYbOZh28zgZFTh44z1j1+0lA2Z5gnAdUsei1Ad8JQe1RWG+KK9XQ9VNELvln4ZoNAQpV2kV6SnmOvxFoa5uoodcC5CEgEDHmGlZ6XsBVNFhXOB4QWnwNoMITC2bWfRTsgx6XrMcWjw0mAoxWr9klRi0YdxQUzYXFbH1V1pSXbNJscKtnliHz7WiBX6iyJmACht3YitM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7801e24e-b9f9-4eaf-bb6f-08de4d34eff0
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2026 15:04:49.3698
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +8abE7L8kISjNME7ZvDIiHszqxM2QWAtr/70rjYr/+6i6IFMZhc4fWIfQ3C74re9Aq3ujfkZspKJPzSHufanM2OoW5dy0Tuha+c/4YvsjNI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB8083
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-06_01,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601060131
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA2MDEzMyBTYWx0ZWRfX3uSR2CQMAyRw
 ZLZKuGQQf7pcIoALueT7MEUO+y+guOeKBOz2Lk8IrqW4hVDBXx4lZQ8MtFQbTsJM999lAPhX6II
 r3gQSe1DcaL5HE8D4AD3dDkakpqNzZ4bfJ5fjMIGS7ePFLa8SeeOmluSpkxFTseO7+h4Rex9w1k
 pj9Zyc369FSej04YkZW7B2qLEebHqVlplhEGOk9IHceZ31tnjY/bHywXODhMpnJBHXv1nVWD5/j
 gtWFEHt18ZhymPdzL0o7pT1/NwpweslPSzoRkwAPCT1pwq+OyBCyiRlzgf5w7TGuY4d36eNLZC+
 /uTUX2IpW15VbFS+zONYN1wLgHHySNemimtIWn7883YoLNeEzZNM3kuBy6Xoq3/vNMHAurhmcge
 GAogUB/63cJEgsVUH8GF7kbSHw96GPD/M5TWrzboEX4JCt9GV4BCpM2oz+7vcIEWR8ZBUwUalF4
 W/ZXozffAN9rYMysy7A==
X-Proofpoint-GUID: 5ND_We3ghzJJzQNrWb5YhvmH58Ed9SZV
X-Proofpoint-ORIG-GUID: 5ND_We3ghzJJzQNrWb5YhvmH58Ed9SZV
X-Authority-Analysis: v=2.4 cv=NI7YOk6g c=1 sm=1 tr=0 ts=695d2884 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8 a=1XWaLZrsAAAA:8
 a=1PI_McdixYITsgu-vP8A:9
X-Rspamd-Queue-Id: BF8A22000B
X-Stat-Signature: emuit89rqoutodkt57qffq3df6kxjqsy
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1767712905-314639
X-HE-Meta: U2FsdGVkX1+1dCAEJuR51jEUlwS6Nl0+JNVscn9ShUYQO2UZ8asIKpKdSrHmnJmAja2Ws0Gjb8yQ/pTxn0GBJwepTXp4KK7ZqoA0YOqeuEc62YDqZz2bRQixa8mFRZEkgHLymmhPVLx++uR9Mzr7dG4MaVEpXLeSr0aWKtAX0MQVdJa9RWy4SFGH2jGUOGY6GmqXqGEYr3EYv0dbk6DV71l0iA+zD1vgLX8eVhTS2yAqeQxPrPzcQK8HKKeEDBFoYyXvua86+hUHEwUP47TQta20w/lxsYW9slPUb2Bw5Sgj+lEDeaTtmLXWprV7qKgpgZ0F23xVQXz7yDRzwedoWGAdMQhpx/cljRCy1HznibTGsKYAqzox4LM09ZqhGb7WhmxwwmBkXaTOpB8i42OTJLE0CXfjR7bSIiDnlBKK7OtnZy7WEfxvBJ/jrCTxMFweoKXqLRkjiJ+shvKM6ulwL5XfW7XB44T8wbhQJENigjBTF1QRcDDb0OBJtYt+qbNSVJdSmLrLZ7TxmBBYcBu5/MTwCkOK2kLPa2XDI48IFP+3/cqJjsZKR4n/3YHKdnmEe2S/XyTQPI/kkea1GYpGgCadqZajfo2A2QOtXkV4k+NzX1VsMh+OSjpX4+3FF8yQ2awmx/EPdrWAVoZAxozUcKKuV6KZBpb2Ji483ZX/1SpE/XHqRAYzoYh2tbM1GRBAZ4g+kjZlwfASvOZLTFrtLoBldYCovazl9l+bSR0179Q20eMwDPcbpGd5dkOON8yJO4YJupHR8H/tbZFE0bGsqxr3Z94StXOtK2j974qPqPhE3uCt/rHpy4TCSMfXhjgocvj3iADNecM7whJqGnSpOoIbvP4XQZRl2iR6K519JOL19Bmc5kW1FKjCgesdw2DSS3DkzFSe3iJ+RpZA6x4yLZg81xa9X2UbrVay040PS6G3Y7hH5xfUPWgnmiq0VQ64QM7n6peMW0gRaN8xKQ+
 /op4zXwm
 I9Vzd0SPYoBZGHd43DL+ovbk6Pp5pSzOxBaELyr/zmw3xmeedq3ZkPq6ee48H2MI2KRgAa24GlGOTeAAZUu5LOds3ODDH9VzeDDUogRpTrdFMyqS/kF08ZiYvoCdIBL0oGUTCAuUguE+G1Uz3261K3UCarWV6kZJUG7/0aSH7bAh7LsNx7S6fFuGwbofNCGplgoOwEevBVg+VI5aNxZTKFPxfULr+ZtSkdU7SB2DI09VcoLNdgZDGhX93R7rCpmebb5fPE7j05jZUQxkLkJ9skMBIjjikskJkKsG5PKGS5OaYJlmoDogb2aTZ/4stL0Il6+iv72J5/g/FOgOo58IjlSk1o7lkWjUARFn82NMbP876+T/RggHza3s5Xw9RqP2y23QJSxz1WJ/DkT25Te99TT6g5+LfWbdnNzgEeLlytYYVBIwysw84XfJ9xHWQTZsHKQFpwadRDt0isG1R1ZpAoa8Cc5Tz3JaoG98X2wnIwvEhXn/4UyhiV03LO7qBMwGNqyuI6LCzWi46tzvxG658IYu7aYxzXMzhta9Nb9pZy+F7MJR6ifY2p5vXVaDW/r/uC07vmB/YthATQ67RaFnN7XfKhXwx2PdOCDkRzM4KiSGKDitCWYkhRf03HBMmeqoT34esw8uV7YeORLcRRm6+ieK8RfGYRsPoL+gYAAhS6dTl22QAE3uLNYH0KL3VGi+GbJeIL+BatXGhSq0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The bulk of the anon_vma operations are only used by mm, so formalise this
by putting the function prototypes and inlines in mm/internal.h. This
allows us to make changes without having to worry about the rest of the
kernel.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
---
 include/linux/rmap.h | 60 --------------------------------------------
 mm/internal.h        | 58 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 58 insertions(+), 60 deletions(-)

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index 832bfc0ccfc6..dd764951b03d 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -104,68 +104,8 @@ enum ttu_flags {
 };
 
 #ifdef CONFIG_MMU
-static inline void get_anon_vma(struct anon_vma *anon_vma)
-{
-	atomic_inc(&anon_vma->refcount);
-}
-
-void __put_anon_vma(struct anon_vma *anon_vma);
-
-static inline void put_anon_vma(struct anon_vma *anon_vma)
-{
-	if (atomic_dec_and_test(&anon_vma->refcount))
-		__put_anon_vma(anon_vma);
-}
-
-static inline void anon_vma_lock_write(struct anon_vma *anon_vma)
-{
-	down_write(&anon_vma->root->rwsem);
-}
 
-static inline int anon_vma_trylock_write(struct anon_vma *anon_vma)
-{
-	return down_write_trylock(&anon_vma->root->rwsem);
-}
-
-static inline void anon_vma_unlock_write(struct anon_vma *anon_vma)
-{
-	up_write(&anon_vma->root->rwsem);
-}
-
-static inline void anon_vma_lock_read(struct anon_vma *anon_vma)
-{
-	down_read(&anon_vma->root->rwsem);
-}
-
-static inline int anon_vma_trylock_read(struct anon_vma *anon_vma)
-{
-	return down_read_trylock(&anon_vma->root->rwsem);
-}
-
-static inline void anon_vma_unlock_read(struct anon_vma *anon_vma)
-{
-	up_read(&anon_vma->root->rwsem);
-}
-
-
-/*
- * anon_vma helper functions.
- */
 void anon_vma_init(void);	/* create anon_vma_cachep */
-int  __anon_vma_prepare(struct vm_area_struct *);
-void unlink_anon_vmas(struct vm_area_struct *);
-int anon_vma_clone(struct vm_area_struct *, struct vm_area_struct *);
-int anon_vma_fork(struct vm_area_struct *, struct vm_area_struct *);
-
-static inline int anon_vma_prepare(struct vm_area_struct *vma)
-{
-	if (likely(vma->anon_vma))
-		return 0;
-
-	return __anon_vma_prepare(vma);
-}
-
-struct anon_vma *folio_get_anon_vma(const struct folio *folio);
 
 #ifdef CONFIG_MM_ID
 static __always_inline void folio_lock_large_mapcount(struct folio *folio)
diff --git a/mm/internal.h b/mm/internal.h
index 8319a91e363b..4ba784023a9f 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -199,6 +199,64 @@ static inline void vma_close(struct vm_area_struct *vma)
 
 #ifdef CONFIG_MMU
 
+static inline void get_anon_vma(struct anon_vma *anon_vma)
+{
+	atomic_inc(&anon_vma->refcount);
+}
+
+void __put_anon_vma(struct anon_vma *anon_vma);
+
+static inline void put_anon_vma(struct anon_vma *anon_vma)
+{
+	if (atomic_dec_and_test(&anon_vma->refcount))
+		__put_anon_vma(anon_vma);
+}
+
+static inline void anon_vma_lock_write(struct anon_vma *anon_vma)
+{
+	down_write(&anon_vma->root->rwsem);
+}
+
+static inline int anon_vma_trylock_write(struct anon_vma *anon_vma)
+{
+	return down_write_trylock(&anon_vma->root->rwsem);
+}
+
+static inline void anon_vma_unlock_write(struct anon_vma *anon_vma)
+{
+	up_write(&anon_vma->root->rwsem);
+}
+
+static inline void anon_vma_lock_read(struct anon_vma *anon_vma)
+{
+	down_read(&anon_vma->root->rwsem);
+}
+
+static inline int anon_vma_trylock_read(struct anon_vma *anon_vma)
+{
+	return down_read_trylock(&anon_vma->root->rwsem);
+}
+
+static inline void anon_vma_unlock_read(struct anon_vma *anon_vma)
+{
+	up_read(&anon_vma->root->rwsem);
+}
+
+struct anon_vma *folio_get_anon_vma(const struct folio *folio);
+
+int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src);
+int anon_vma_fork(struct vm_area_struct *vma, struct vm_area_struct *pvma);
+int  __anon_vma_prepare(struct vm_area_struct *vma);
+void unlink_anon_vmas(struct vm_area_struct *vma);
+
+static inline int anon_vma_prepare(struct vm_area_struct *vma)
+{
+	if (likely(vma->anon_vma))
+		return 0;
+
+	return __anon_vma_prepare(vma);
+}
+
 /* Flags for folio_pte_batch(). */
 typedef int __bitwise fpb_t;
 
-- 
2.52.0


