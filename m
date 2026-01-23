Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4011DD778B0
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 20:13:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EA476B0560; Fri, 23 Jan 2026 15:13:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 987AD6B0562; Fri, 23 Jan 2026 15:13:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 869266B0563; Fri, 23 Jan 2026 15:13:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6EB8A6B0560
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 15:13:07 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2A93114062E
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 20:13:07 +0000 (UTC)
X-FDA: 84364327614.17.2079B92
Received: from relay.hostedemail.com (unirelay02 [10.200.18.65])
	by imf09.hostedemail.com (Postfix) with ESMTP id 68FE314000D
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 20:13:03 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769199183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=47gDud7KbvmsdvrL1+IOi+cZg98jjbixyWYKeeebeak=;
	b=XsSch0I6V+80uzge45kf04bhHgPDdMLnINAxYeIcpWc7xvbIrR6XLAKdeaz+mevPmlETvp
	hzIX9URUclqNHmcAke4HkvtNcRVPeDJcrIwlPHQg7PUgO6tuvKGsXbeOJzta/t0T/rAAhJ
	mrATOCDTJJzKPajbrnzydvOYHKkF8q0=
ARC-Authentication-Results: i=3;
	imf09.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=2")
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1769199183; a=rsa-sha256;
	cv=pass;
	b=Sm2wLRHdmyxuOeFZyjnsEuq66XX2bsuWxLN6eFVHmsaI6m5+SophjoahSofKLILpASi3ne
	SY3VWYM834hhw46nBXlMvOZl81ECNyiyLFrAMpQBUgQqxkYhUUnPbQ3O4SInUed0x5CNbm
	3OKwZmS1EqZauBgoH/FBkKfkbt/BAG0=
Received: from relay.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E496813B49E
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 20:13:02 +0000 (UTC)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BC41759C91
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 20:13:02 +0000 (UTC)
X-FDA: 84364327404.17.8E121F6
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3FED31C000E
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 20:12:59 +0000 (UTC)
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769199179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=47gDud7KbvmsdvrL1+IOi+cZg98jjbixyWYKeeebeak=;
	b=7Nc0nEm1+jgmMPcDNpwVSsuTV37cXV7lEpTrju+8rpNTMY+iC7HvjErN8xwbO2psSyZCdj
	VstQGOWevVVtpMcuYnApi3M3YdxDgfXTFFoq6lRgYOJtsBkVi6dwRbeelUIRHAWaBWxPON
	RAglY5UcT4Sm3aLERRvks2yPgtsENns=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=FDSeldMW;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=kWbBOZdR;
	spf=pass (imf21.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769199179; a=rsa-sha256;
	cv=pass;
	b=j0f8BGoGkXn2bGt8E+gL6LpMSxyYhICnlWHQBMF5TC1ZVEghClsqkFQ8/HHsnb+m2gyEdB
	FJy8wbbsFqc0lOwu81CRg21bYCgbBsVYLtb8wERC4i2bVny4K5YohshI0GNddXjfIwQwsQ
	+zO53td/xijOAiywTpzqgBMWor25+24=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60NF7e9H2973460;
	Fri, 23 Jan 2026 20:12:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=47gDud7KbvmsdvrL1+IOi+cZg98jjbixyWYKeeebeak=; b=
	FDSeldMWE47xWGSzfOb7Fts7Kn9i4zNKx50sMitY3O8P4IEbtgRFAFEuH0BcaRcG
	jKyAyehVLwpFrWgGQ68wbjruUkqLZp7gF1BkuDsTkO6Nj67kDG5+IagHwhVgXPMm
	hLaCGeAyOadEwzucfmzGQzh1X4V7+Uot3wqne9PwHv6qaMdsyC96taYDeaentUDk
	u5RtM5cgs+eTY8FHZSeE/P+Pc/AvJb7rmEaKdXaWmXWhihxzyLgSKoajF5u/pryl
	KP/GyUskdkE7Ctt+kyJVXMokMuv9yCbtQ2FE3wrQI3gTrkThlbgmnTV7QFmpe7a2
	PR4527U4I7fmHXdVp++WYA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4btagcynpv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Jan 2026 20:12:45 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60NJ0iOe022514;
	Fri, 23 Jan 2026 20:12:44 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012024.outbound.protection.outlook.com [52.101.43.24])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vjmh1w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Jan 2026 20:12:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mJyINRMq/YYlObKgtaE9aZKQDT9k17YD+bv7iatIuthwbt90PFZUBpxB6fX5qraajFAVlnuuLKbSokzXi9WAV5asQWX9KTKCHad7urkOkztRN4Iucza/j/oUbVypFFWamwhdIq0N5CO3pbCF4Pg40AbJLbU36FlAd9KSMfjkyJZ/2ndqNiZAY7mqyP4+L2aqLMee2+LgDNyCk5lqRca7kBBsQ36i14bnCToJSxfEE9GI1k+yvTD2Hq8AIi9HpZqzPHKpPeyHeLyIVdYdO/JyLjA5kPfYn5EVgIY3+7hgFI9qkKSQGCzOOiF18Q5KOzgzFrzIcYLzwyV7SwZhY384bA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=47gDud7KbvmsdvrL1+IOi+cZg98jjbixyWYKeeebeak=;
 b=GwNS/+Zz/WiDUeY/HvlVEwBYxSrEkLChKhNEixf9aAcar4o8tFNqCF9zrP7hMJ+XbVALebS0uZROP72Z5h6wxgIHwwFxPjLpNsJdx0eFciI9O7ShROADMHZTRGE9NOoYkxxTwmdeLRylRrTwPXWDwU8o9cjyZ0+m+wYIqEKVqV2VliwS4GkGH3C8p29W+Gl7UjrK7fb6zvvgPWw6M5TBkI1JDU1Bp7MogwRpIdFll0rCRO7lJixBK6UZ/wDfDvbnxhb8rfX4/IobUI7s5lS7EmpsP8hMsUoUsFnJEU+sbE2vDrNpszGPYZ6TzJ09LLg2LaBs20i4x9pS3BBtcWBvnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=47gDud7KbvmsdvrL1+IOi+cZg98jjbixyWYKeeebeak=;
 b=kWbBOZdRPpJIxb/oXWaHsC6mgpjRcqfkFF8LdM66aO8ULd4XQRaXh2lcUKkLuAZpoFcm23A8BgPaWb2ZdhYfgPTeenQlpiRCHZNdOGP/JmvZCaZyjOM5OL1qg/72JnNnK1eA7Cy/wGmAYYljOw8Uxl2oj2uEwY7UGMM+LPmZ3lU=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by PH7PR10MB6555.namprd10.prod.outlook.com (2603:10b6:510:206::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.12; Fri, 23 Jan
 2026 20:12:41 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Fri, 23 Jan 2026
 20:12:41 +0000
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
Subject: [PATCH v4 09/10] mm/vma: update vma_assert_locked() to use lockdep
Date: Fri, 23 Jan 2026 20:12:19 +0000
Message-ID: <538762f079cc4fa76ff8bf30a8a9525a09961451.1769198904.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1769198904.git.lorenzo.stoakes@oracle.com>
References: <cover.1769198904.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0663.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:316::10) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|PH7PR10MB6555:EE_
X-MS-Office365-Filtering-Correlation-Id: 8374492d-7788-429f-6e4f-08de5abbc2b5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VmAJjrQWqvR7lyQhy+OD9nSJXnyAm+0uxIl0DRrDG0fXJXPPADKFCvamSTak?=
 =?us-ascii?Q?9rHRFSCghV6ngB5W/q8L7x/59KzXbBVqLLpxeSvzNdo5PN8UPGlNS7bZqeTd?=
 =?us-ascii?Q?egRZkveD4xsoRGJ5oc5W1JkL25bCp1yuOhasMllhplzhOpMp6+zKqK6fcq0s?=
 =?us-ascii?Q?upZtRdxQW5Wqu8iP430dw6bOLthrf27qzhlyVlCs9+iRO0c+DAQXU/S3IYBX?=
 =?us-ascii?Q?zmwREKGsw7XiV8K7dND1SuZN3z/kDYd1IlemU0baDR8LI523bMsv2WWiTzmN?=
 =?us-ascii?Q?7D4JlUqhZij5dfRDEpjPUZiJBCVqC33oc5WsEfHrx1FUNE0UwoJ81ayO9pvs?=
 =?us-ascii?Q?56CTgYjvWklOwRk+d0y8XUNJ+lVDxL/Na7g0biK72iwtoB0uk+m1XSPHisDx?=
 =?us-ascii?Q?6RKJHjfkzz7cw88RrV0hBiW/OHSNiUxrMzFg1CmLxvd/2J8Z8TS8R2qYIJRm?=
 =?us-ascii?Q?1uod/qg43m1fJ76Wey5YxudC68jk6pdQ05YFSXagSQ68lwNYpgkhG52shgNZ?=
 =?us-ascii?Q?isfZDfZ3h+9yOPqOzQcnioJnLg9QTmmy4irMaDRFrN+k9PnZJ637/1JoHGCb?=
 =?us-ascii?Q?WoqYZmXVXlIlzP830K68x8uShpbuTtaOyLPWcqu+u9Om5SqoVoOFskVS6HHh?=
 =?us-ascii?Q?gHKRFnc1s3/kxoOXO4lmCiYQaqYkez3WF/UVaxg0Mqc5xTOjgq11APL3Z3JI?=
 =?us-ascii?Q?Gis3fAwf9syBLqBYYmGx+g2bHvECvDbFjPEGJuHX8VgOGfvX1cfYWhwFHf2W?=
 =?us-ascii?Q?cGqV6v0Fqcwmqw+mBzzyp/1+wUKCodhS8DIU+FzhS76Pd3BOtebv5pCdmBoK?=
 =?us-ascii?Q?WOq9SOrS03lear1DU4fyD1UBjrszM6OnDFVQ2gRIKJbhYwogRZtMGfA0tHot?=
 =?us-ascii?Q?jCNOURrAJzR+vx8EiaTywNUZbXYfNVVZKemhm2aX9pHtXpBAojmtxEKJvR4f?=
 =?us-ascii?Q?yIrwfFhvm3vYbb0uBtAkbmFdr5PoEoyXoN21kWQAucWQbamdR5MYddMqd8aP?=
 =?us-ascii?Q?2pm1Ka3MVrzeTZ3TEtrXGx7XVLqKsDBKyigViILFSzysNCpY6tNzrxqZUm+X?=
 =?us-ascii?Q?vssRKV2Rw8kWoUxgAGaNSU7DZk1nfxNqGeC3LfGMc/Jxy1xoj17Zh7wa2bQ+?=
 =?us-ascii?Q?VRLxRTpatsFgYs1kX3NK7ewrafKxX0F4zrWzAAPmW+nKUbPZw+T12/7BsI8U?=
 =?us-ascii?Q?4lZyr3GTEbN3v8FxuaqUEnZnv6Lk6DJWdH45u1+NubvbhVPnW4+qx0tDEcsk?=
 =?us-ascii?Q?2o+azKcHSB7I1OymZHECuhPzjG/sqmgFP9oHh1XwUUAtx8fEwJBITpabgXch?=
 =?us-ascii?Q?dkgBpUze/PeOnAektsk9UYbRvSo9yFJ/d7qu4vQaAfg5G8LhR+ylW5h0/3t6?=
 =?us-ascii?Q?Fm2ERt/M6Iok1sFtwnybbrI/yfQEq133DghNvuTc/GhQLaO6qGO03f1pZZwo?=
 =?us-ascii?Q?UIoUzxJh5G2B0sqQIkRAU8hV0UIylQLHHqz7Od1sSedikxaTJIeHtCF1r5aB?=
 =?us-ascii?Q?KY/qFayIGG4AuZj5E+Ijb/BlCnTMBuoOfcgpVQjNPsxwz4pkNePqPKYX023U?=
 =?us-ascii?Q?1FQ3x5iDwi45SGrqRUc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GEOgVbFS/fLsxOwImrDFHLQQ6iwB6bjF4x18MI6dSYD81/RavmeG8hihp3u0?=
 =?us-ascii?Q?wk4Ua9SAfVyqDKlweRE0FEOq6MHaFliiBC8nfJyzRgv3j0QytSVHDkl4yvdM?=
 =?us-ascii?Q?pzVGGhCMCX3Ety8uhz39oSV3NlW4fY3jNnjgOEUN/p0KxKgFXqVy6xhGEyO6?=
 =?us-ascii?Q?JMpnoxTsUqpyHq9oEXAjdM+FSXQk/x/Knpu870Z4k98d7njx2/sXbn+EgnGY?=
 =?us-ascii?Q?UOy1DwKoowciVf+XriuJL6NhIbKMtJ/FIyIWAfu7YCFlRpqWOaD4iiaNV1QJ?=
 =?us-ascii?Q?+2Y8ec2oNqk3jj/gcSq7FaTse52FfX3q+FjpLjFYXX2QQyzSpLlh4zkxnGpR?=
 =?us-ascii?Q?LS87+pIkocB0e9peDGD7GuAMzNEN+5Pr1QPpJizzG9/WKGTLqFlIM9jB+IS8?=
 =?us-ascii?Q?X58kBwSxYo2E7E2X30U+5myW4Cmd/BvRvCPm0m1oPyV0mEzSMtzLbayvgjPY?=
 =?us-ascii?Q?Ceg6OIn/n9eSGM2pXwUzlDQemYYZNISgrvQGcUsOkuF8LhmSaHiU9KTZRmRY?=
 =?us-ascii?Q?jqGvz5ShrqejqTfJE2ncE2FSsIbhUYmVM9pTKt2D8yfVcFMPIP6tqsf81PM/?=
 =?us-ascii?Q?Vtc+IP2FdOByRHubsLTJTxraQ58t6mOsAN67cXVYnw+uceIEx6NUNo4fh1zA?=
 =?us-ascii?Q?uEboPaTC46+RlTL2JmSBQMLqLqYvfaubci6qu6JX3r1t0pW+B148Z4E0xF6K?=
 =?us-ascii?Q?HhO4fuCOcamKJ1Ar7k3Ggfm2piLZmzr0sJRvZj8O2hKjtN6rUXUwtGIyasNH?=
 =?us-ascii?Q?Gv4LzbGOk06CV/9zoFDeweF4Mo41SfaJoId4RpCPUvfL3CkjuUuVCco/Klrr?=
 =?us-ascii?Q?jKskKVHM1/PYlXng2cECBw1ZJQTnd8hyfzcgjbDpek0x5tzBzEjemUVJlJpY?=
 =?us-ascii?Q?G4e2H5XEiYuZcEsFiA3+C8y1y2Vb+JTPSzu6X67lPonn+nbryveWAHovT+6b?=
 =?us-ascii?Q?CfVPHLHo4UGSo6eZ5vXg8W1JjAhWjna5FpFMjMsmNyX9K5EP0G85WcEBzZ6u?=
 =?us-ascii?Q?5UimDQvRN6Dy6krWSHlKpLVTjQeAa+26BrtPcxBONGhghZHG2R8Ira+UDtdR?=
 =?us-ascii?Q?DZiIXdSViZJ2YZ8tFb6DhLyUtL+I+N0pPzJh6XIp0/YFWKfxYItatvCUlsyC?=
 =?us-ascii?Q?e9aM6Swzu3frDql72nzkuz+MtdFJRZSBlZ7KDUqFkX2etyQVDPxmXoaA27xI?=
 =?us-ascii?Q?BHn9S/Wn+eKdqlgKYv2YELOduX8HUrkelT0HUIFBZ+IWNwjAW2S2pI4LMkaF?=
 =?us-ascii?Q?KEKukaDbzcUV/CAnyOm84Qg4VggVCKYUwZrdM17M3uJ0T/AINqGzC5nsSIAc?=
 =?us-ascii?Q?5RhgU+VjST4fMtDWWFpSyXP67paCM4jyUtb5VO7Q/Ntxva/4VF7rYRZ9Fccl?=
 =?us-ascii?Q?A+CVxXABjZjWrmVPmmtN72ZhZoZI3AFDNY/uzMq46PUuyBPQnCse73p/49kV?=
 =?us-ascii?Q?f7zvumDJC7Z6uATiSa1/Q5DFOzAwZULFKXve+eKzJsn/b2VU8mqdIeKwfZC7?=
 =?us-ascii?Q?Jla53+Wyu2DTgZrIgWotw0NWtYaFvedPZMNITZFODdY0FYAMlSzwG9zc9Gsr?=
 =?us-ascii?Q?79Qzmcjyt5N4/k+ise0gaI/u5evGLNbUYPZ2bC0AHXV2ueWuuIZVIL0iCBcg?=
 =?us-ascii?Q?uDPnRFj9mdsIAbKhpP4kKZK4sP/k/C+KWX1jzZzeg86qJYlZD6krEHPfwUon?=
 =?us-ascii?Q?+zl0WD9ULJ7cCs35B8mvkCdnKRKdnMMA6URaT7ZQ3yxVJGOAHH5aYo3S0U7a?=
 =?us-ascii?Q?hIUnT3AT/8CajJWoaucjze39wIvPG9E=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	GffRX5BNZ9yAHTpyawPhu0SZJOFEwv+c77IXUsgoerGiXRnq3yzT8gLuduPBymGzaXLI/mRs+F2X/pNaWrkrAXoKOfiboGP7I3KhhORVxrSLI2lnnIwRhjKbKbwE1db0IR/k0uO4a+sxzj5LT86RMMx/vJDWi1vNzjFR9sOqeDO8hANLtgTkEghqpzBC1fQ8sgjdNEkhbQ0LgbC+ebakVhF20u+KzYK2w7mmhMMZyhu9OcNAcBBpXaaevbhuaAXN6C7emud8CyFVfBnSki55y1mCBXZqC8444M4DTCzUVjsHhGY5PheLRaO2BsEgeEkiSHGP/WFquy7lk7LXdMa6iwfnGQNwirGQlRPnv/f6UieVGFxbYMwioZBWomGH6BddUXNM18pMfPezHxY2YErKop2mFuza/dEbaJJNOnTI0DVPsBmxjZve8nvKnHP41Ps+fYPCVucbm0PAy05RQWkIYni9GU0G/Gj9RsFiAOQd/kTEErtOxLyaBJ+8uO3TdANf+DNYmtDhK7USxfTLCasklp5xY6uKrN8aKSK1Jc/8IdzgI0nU3KNEDuUS9/luv9nIfpw8eRt5Ai86Y2xW4qcc//Vc6ufeVv5bAIHPKFJaRQU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8374492d-7788-429f-6e4f-08de5abbc2b5
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2026 20:12:40.6264
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 269gVi6p06WFC7jQoEEKcBxZUWcQnI88iSHjhxazQN1F2DVlgaFj8uBFUqbz1NyL3CkoFLAqSa/nkI9UmDLBHtf7fBfTuw/uivw2rR1TS+M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6555
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-23_03,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601230154
X-Proofpoint-ORIG-GUID: dEtBI5x8G-CtQArbqA9pUSPMt-KElKo8
X-Authority-Analysis: v=2.4 cv=IsYTsb/g c=1 sm=1 tr=0 ts=6973d63d b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=1XWaLZrsAAAA:8 a=yPCof4ZbAAAA:8
 a=t-UrVdh-U0oxC4GB6fEA:9 cc=ntf awl=host:12103
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIzMDE1NSBTYWx0ZWRfX5Eewi1HV7BL8
 ZlwTIB9bYlKncutMGr48BKrKKl8/uqrRaTYaLgSwQPcDlH4+1LF8XS5eFfBWHWDngHs/S9w7qOi
 5TDg2FWE9qJXyJ2eiM5wb1NVrqgYvCFu/4eYCAWy4+wvGdgBugIy5mWzpHWBtm42A1lnLFk+Q70
 IlBpLDbjrUUpfRR0BLMXy/5or1/hLfjsAdB8GXd0h1LXjZgoc9NxzwP7HslxqsewPlyMFNaI2LP
 TrdlrqAWiloGRr30g4mWO/2v18z1BPS9qFVez7+jNAITgLXsctDrQM6gHshNV0TRONvj0w0CHUL
 pn7Rp3byOybeANMe0Bt/lXix9/yps9lty8t1nL1eO+e1r/It8Xprl3Fl0KlEejwLFZauDXMgHyR
 hEke988s7B4G0UBokQO4d3m5HQdezgH3zHjO+TcAqTnD3yX2ZPV/26AGF7oYEVZJbEdvZVC+v5e
 XvXSdy0rIciMJq2dQ4hTbYnswIKJ9DgvPpbHiBO8=
X-Proofpoint-GUID: dEtBI5x8G-CtQArbqA9pUSPMt-KElKo8
X-HE-Meta: U2FsdGVkX1+awLUUmtFs3ZYbQsatT3MfcadMWTa5X6kgMlREZOB0awtn5AzP7CZOO1ZAW+twJ/evOp0Fa8T2kVHJ8aM9ODLM3Qc/Slq5fHr+HA+y/Dj8Dutu/iCAH9SN4mmJmLUhIbo//rC+hBc9NH9/BFGAoTAJigxHkpgItIrUa+7QxROKhtJNv7a6LJYxzhpTp0S68BgFiDlYFYBnNp0tbBOgN422zOJiQobLR8TvxrGlak5QuyK75dZxMZsLbk8T/NGHX9xE+B+Z51kNottesybExhhTINEf+wO9TJgNZyegLX71S+eCcVlL6fb0DpeyTovkDt52CjZL99agIc0g4eBz2ml2yejR5Z6v8dRupZqxK+rsar9Jr5lZJ3PW5iSDA9sWxS0sYyec/Uhy287f/880qpJKr36AElTrNvBhD0uWQoDi1PXgc88KUUJJUpK/oS6Yv/rbJITXg51FovseO9tpHXmlep1hX6uoBBA6XTP/vNGK6FUhDgbbshRrXRL5fJ+EzyHAXkPlTnY+RK0M+csgKqUfV3e6mpLSCJD547lP0wpoFN97bN9p7OBpYs562/3yOOLxr+R5P/IDGGdWm6yllg5qNdUmDikx9NTrbbODjme/s74BEAGiza2HJS/8z3DsaWrzawRpgzy9N0LTc6gkJoDUGZnY2qSD0ErgcID7TZQiHDHHE9/YfqTQW7F2b4wQj89BS9Ej1TlS/ZvvDqXrAHSldiO8VnnkJPWxOzfxI9k0pQbdeDakdnkH2fxfzJNbidFIUg8n2ZO86ljU18y8WokP67cg0fOALLeZBhcsC62ThvWXA8aMWWdQlaGLfxQK0SPnmsymoxfiUiDHAc7r2tofRERtgrd+UP+03vRFPPN6rVWoZ05RuLaVla8FpKMOwJRTSYuQryb3cum3fx+OryvidF7x9+u4GeXVApAxqeL6t3cw7d+EUq9XTqVEsRUx+jTQs1fhad1
 30b7/MiV
 FxzJ1rMDohpG0Gxoa/BMMQP148cJtNX+DKuwiQe6nJ34d74aij1fArqL47cTABHKyVRRM5fuZ//9O/litKjWVLhaf+CDxjOwcBwNG3Os8nW4Wh+r5rq6UEXJP+Usg9YYWKVE+pm42r43bUgXPB73ld3/5VuMhredRXH+RNLwSquc7Gtn/WxeMjmAJx/OkuH3ck96sL7QbE41HZYJhxMtRTrdP2NMEzoXlrc6jFnc9Q2L4IB4jCnrZjNwnt6XsFV+R0riiJ1dUfrpsJ/HG0mOZOHNuZF5RoXUfObXPkLB3DewbwnFd1jrDAUj7VzxU8/5XPElfrmbb2OC8ATFfMdnQAt7pl0id/ADAjC2XxviHK7r5h2YlqIH0o3amP77BiVECbvJHOMSDT9oTONWXTwx8Go1LrSRZHcNoeEWSRgx3+1Cv2ruTJLvG12D0vpOtQ5C5qQkQBk6kPXnAayLwtX8W5euTExUeZHoHLEA8sWkU+N3pNDqh9XwS5t+WR9yXjir3r6hymBE5jLq0Ng0rkhsLqBFibliyOjRkYJ1Whi2uPZpsuQna+5QDbLaEmR2d0bqr1dnvCkjFLYtoV0bWYgCm28JXb9GLWuf3nDXMRB7rg6kEPtRep3WU55LML32TZcH4XP6Xg3Y0TTvyLslE/fWcMQBiMZ6cu9n75ZUrMyGcP4AzgU3CfVk6dpncDMC3zYbg3L4fSJLgeCBTPhdyFkuCLyK99mjNbUHQpBXASOIrUabpEPwZCgw64qhzVdk5VVfQY83RUeu7hYD4Hc+xKdZ2l/HVWw==
X-Rspamd-Queue-Id: 68FE314000D
X-Stat-Signature: js9ttx8nzet5qkc43czgzcprejb9tzpa
X-Rspam-User: 
X-HE-Tag-Orig: 1769199179-896762
X-Rspamd-Server: rspam04
X-HE-Tag: 1769199183-374054
X-HE-Meta: U2FsdGVkX1/xJudtmDAhXsfAkej/eCdjjLCpp8Gv93nEBFJ2weD3GR5rYLCFimctVNp0Hm6EHYtxYH+yAr/NHqTy7iWuNURPoqiHnoRclhY55JMd6gHGdotxsc9zYfdoTRQEiuNGHQtOlj4XgQGmScV7lXHN6bBW9cKGUGLX051Uji31Idnd+qFcGhUI3KWbPTsDl/65S4W5T5XSmURBz7VJAhVYv4hAZyabzjyjc8mPaMBG2Lh/a8sxSquyimno5UQOg6Ao32oy4Vx+ASiiCKOVZuwMyX9ExmU8jfIMQ0KFvrm3euwKtJZbtkBVdZ7It9stfAKCqKbMnuDILx2t1kAD00xQqVOe8jIIyTZ75/AHBsMqk8kUlGLNuGOxZAVDkkVZ3pm8ALD1nq2oihMjS0Z3QltHvL5QeEVRcMgXLbwBmE9HFOXLUmnVeYGmUYX4hGC8bOkxkGZopPw4064KutYPvZpq0YS6h/yFV8UREjzxvD1wds/3m4BYh/Cti0/dDGATsX9MqP1LaFt1CiavKijB9jY8wyJnxvlOVVBcidD41iWpUn5elOnyxCuu5sqf13gxMJX8Nqvsc317/tdpIChmuNZKJ2MrdraRCCoCewKRSaf+eukVrMQI4yl6QhWIX/xH7KV7yC/1hgeNaAvxdr6qPqNaTQd5Y7BZwjOwj0ICTrCDeia6vAD0/bopRa0iLOhtpubVDXCRxrzRBE/oVMZf5RiDtW7QpU9RsS47eoSHw1Hq+MhbHmEA5GvKgFtsrDqFtU5M5+5bwpg6SwLKM0CC8hPKJzxHG96u9YclHvc0HPw+8ts9IWGoVC7SYidRO23lRPpCP9YaC575chYQ1eDmSnYsRjLZJJxFUQLT/fktek2KbeZ57mlOHqSxryZVIzrRwRbnyr6H+TEAWQeW3lkNtD5JuF5kbB29GEHJUe3avelfUVrqRzhnnhQXEZ+EmP7VrtVSiiqmHCccY+1
 3oD41iyD
 BC0E2cfgZ2fPuAfItTrTmi+Wau3cyLfIYS60gjrhhc22AiVM246P/Nh2Z8RhaecBsKaqJOKZwJ2bWdiSUAz8KEGg2uNvoG5wjaDEyEzz+9GXe27RhFXAnf1QorJUlhRw/hN8DeeHdAXxaR1wrZft0N+sbj4xR4NGhXa1Ry/b7FK53bSojEIpeo5h7p1wGsGLovtv19yYdVgEaUFE3WzltaVlEFgDhjf3icaS3sukrtKPQBEcKT6o/G2PAROykKWI00vBdYyQENiTjx4keACQgtdGo3Ruu1OLcNfUTcc5sTGLd1MccnoXVTaVq3J3kpg8lN8Dr2XNOhsFvgDOzi55Mrvt6KH//3vz2uONBnEB0AJpz5H7JViV/7NUhL0MrfER1zR2cgO5nWTfPfPs0lCmIgtZGn+t64aRv8F0b4A9eava1EVuZuhc2nvmfaTS0PYJQch2ZR7GgHRVPwM+19mTiZA6fp3DOXwtb2CtCrtRRklK+ilk5GwLPH+0rNt8xOqdlbf1xV9baa9DQaFaIEdoAxyLdEcNd7Q73Spz1UHCmvAOJwf4yZo6veQE7uw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We can use lockdep to avoid unnecessary work here, otherwise update the
code to logically evaluate all pertinent cases and share code with
vma_assert_write_locked().

Make it clear here that we treat the VMA being detached at this point as a
bug, this was only implicit before.

Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 include/linux/mmap_lock.h | 41 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 39 insertions(+), 2 deletions(-)

diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
index 23bde4bd5a85..4a0aafc66c5d 100644
--- a/include/linux/mmap_lock.h
+++ b/include/linux/mmap_lock.h
@@ -322,19 +322,56 @@ int vma_start_write_killable(struct vm_area_struct *vma)
 	return __vma_start_write(vma, __vma_raw_mm_seqnum(vma), TASK_KILLABLE);
 }
 
+/**
+ * vma_assert_write_locked() - assert that @vma holds a VMA write lock.
+ * @vma: The VMA to assert.
+ */
 static inline void vma_assert_write_locked(struct vm_area_struct *vma)
 {
 	VM_WARN_ON_ONCE_VMA(!__is_vma_write_locked(vma), vma);
 }
 
+/**
+ * vma_assert_locked() - assert that @vma holds either a VMA read or a VMA write
+ * lock and is not detached.
+ * @vma: The VMA to assert.
+ */
 static inline void vma_assert_locked(struct vm_area_struct *vma)
 {
+	unsigned int refcnt;
+
+	/*
+	 * If read-locked or currently excluding readers, then the VMA is
+	 * locked.
+	 */
+#ifdef CONFIG_LOCKDEP
+	if (lock_is_held(&vma->vmlock_dep_map))
+		return;
+#endif
+
 	/*
 	 * See the comment describing the vm_area_struct->vm_refcnt field for
 	 * details of possible refcnt values.
 	 */
-	VM_WARN_ON_ONCE_VMA(refcount_read(&vma->vm_refcnt) <= 1 &&
-			    !__is_vma_write_locked(vma), vma);
+	refcnt = refcount_read(&vma->vm_refcnt);
+
+	/*
+	 * In this case we're either read-locked, write-locked with temporary
+	 * readers, or in the midst of excluding readers, all of which means
+	 * we're locked.
+	 */
+	if (refcnt > 1)
+		return;
+
+	/* It is a bug for the VMA to be detached here. */
+	VM_WARN_ON_ONCE_VMA(!refcnt, vma);
+
+	/*
+	 * OK, the VMA has a reference count of 1 which means it is either
+	 * unlocked and attached or write-locked, so assert that it is
+	 * write-locked.
+	 */
+	vma_assert_write_locked(vma);
 }
 
 static inline bool vma_is_attached(struct vm_area_struct *vma)
-- 
2.52.0



