Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05BC2D6555F
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 12:27:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDC836B0092; Wed, 17 Dec 2025 07:27:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5C4D6B0093; Wed, 17 Dec 2025 07:27:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC7F36B0095; Wed, 17 Dec 2025 07:27:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B1C5A6B0092
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:27:37 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 66B8DC09EE
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 12:27:37 +0000 (UTC)
X-FDA: 84228888954.30.908ADC0
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf16.hostedemail.com (Postfix) with ESMTP id ECFEB18000F
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 12:27:33 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=qJZdWetk;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=RnTqRGck;
	spf=pass (imf16.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765974454; a=rsa-sha256;
	cv=pass;
	b=Spx/tIaOhruwpdgfdaooD48P6XqawIYhd9nOvX4rPYCL1WDNih0KE/nfqcl/YPvvNrm7rC
	apcIx6fxgVgx6Cw6Bsiu41Px169QLwH/ehLaisvw7qNv4DeG8QN6yQ0XrIJpvi5F4bBqD5
	k/wFpNC4HGxWdyCWEGNoOtCUbvOr8L4=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=qJZdWetk;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=RnTqRGck;
	spf=pass (imf16.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765974454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+acDuBkLHkuam8w7oPVOyuSnU9DQJQKCGuQeRlif+F8=;
	b=bDDHd6X/z5OrfT3TZs3Sb+6DXSBYuhn5UPUGNT3bS+EAJwp04dWT3fRZdUK7/mV/I1HhZt
	wbTyPTf8/G/eCXXfFypaxLTMSrxkp7IL7tUwvbK1N02OG18D1NJWpsRlaYCL16YtS4N7Yr
	qG3t462pjNQEYUCpSPW74jK06+L2d78=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BH6NdeS2183653;
	Wed, 17 Dec 2025 12:27:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=+acDuBkLHkuam8w7oPVOyuSnU9DQJQKCGuQeRlif+F8=; b=
	qJZdWetkXLAkEt+MY6qemsMzpyIoDkv3M5ggNMiah8blKbv23+IqJXjkPRJwxnWQ
	WKRT41LKNMInFru/JDq1lKV/d2SNrx6UUf0kPuZ38Z9jY2bb2oWn95BxBpJ6zSZM
	wc8mqiMBF+5y7pn2WxEY3ziJOW5mzIvnF24uFIVKcanQoUnBe8bPUpz4tk3CnZej
	EZboyNxY9f7XND7zbfeOOz5Pm7Bg/b2o1lQHcMHjkkTmHLrACTW4BferShFKrcVT
	gqKlg6V9HwjvPqvw36JGcYFGRqJhN8lYlKMFigW4Wv2E5/DHNlwbzTtSNNttrdXi
	QPwCakarSIayCbVaooq4Mg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b1015wryd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Dec 2025 12:27:28 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BHBW3vx006177;
	Wed, 17 Dec 2025 12:27:27 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013052.outbound.protection.outlook.com [40.93.201.52])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4b0xkegbtm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Dec 2025 12:27:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yIPNnjurDU5cL8HTFlu/VDwL+Ta3PMyjaioGb0bDLJs73dXy2moJyetlZukNlk+UWstlKfr3FP7CJ+PzaBBynpUJGHv+nY41trfPHSJ5+7tMNZVr8LurpWgNWwSnBFXJrGsVBrpWVJpcT8cFLjnq6C9C6s9zplRnWpUt0BuE9AJ2V0Ji3Lau43v1In0J+yKzi/LXipY8mwPikoGJqmZg+3ywyvZNwS4cGrUiqopP6Xat9liIoWYIa3+9J+SFXj5W47n0x0vKk50fCyvG8EOFL+qvpZALCFqGjGdO+aRzXR2+OUVbln0/m01SU0EHGN8oEYFRky9lmhG2+c4qog8WzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+acDuBkLHkuam8w7oPVOyuSnU9DQJQKCGuQeRlif+F8=;
 b=uszXOTGslpBa8FirF09v7gAyCEF4K7Du2CLOkYJu4Ek2BEY7Ov4+JVMl8mNq39FrEapbI2aD1++vSaDYS9Z8Cfqxr0b2qfEhTgHiDdSFQFTUuo0CNFUhcarOZ8Ne2Pf18ep1kYyOtpjVZXzCS3eEvo+LBJazZtpHUIzBLb2YWA6pGnt7a+d4LqvGHn7edRWhQ24cGrGexLtGTRdGsQWUE2HGPGBcbFdwoBKC4Kg0GdAxv6FXXz0i8G7fdcJjcssMx0lSaA1SO/pPWyvURppLkATuH7cldQirZQPmivjfeQYovDcK71RX6XNHfPKe/4L3iJkP8GelEpVqrntsRfaIzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+acDuBkLHkuam8w7oPVOyuSnU9DQJQKCGuQeRlif+F8=;
 b=RnTqRGckg5bdGI/Pvur3HjG+ZRD9yA7B7nBmsSNDU7UtGkITcv0DAKGqC38V1kgcyFI4TJvLi+N3wv98zBeS4uNqa0dXkPXxPJKw61S1Y3xcRqR+voHk1Y6VZpuIU770YQf5e2jhTG57a/RfwOHokKVmmPdMXkK5QiaAq1xEK50=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DM3PPF545856187.namprd10.prod.outlook.com (2603:10b6:f:fc00::c27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.7; Wed, 17 Dec
 2025 12:27:23 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%4]) with mapi id 15.20.9434.001; Wed, 17 Dec 2025
 12:27:23 +0000
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
Subject: [PATCH 3/8] mm/rmap: remove unnecessary root lock dance in anon_vma clone, unmap
Date: Wed, 17 Dec 2025 12:27:05 +0000
Message-ID: <454c0680d4fdd5504b1e90b2fdaa098bd70d4d2d.1765970117.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1765970117.git.lorenzo.stoakes@oracle.com>
References: <cover.1765970117.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P123CA0054.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1::18) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DM3PPF545856187:EE_
X-MS-Office365-Filtering-Correlation-Id: c9b4280b-10e5-487b-28b2-08de3d67a179
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3HoI4G4YQa+IaPldWyvjvpmJggrMYcCtwFTwk0trw+mMbB8Gnwovc8gtDFMx?=
 =?us-ascii?Q?YZbguDMlNk3FD93l2fPNkNX4JiRArnPqxKtC7YtJw/VgxeET1PT6BrgrpsQ5?=
 =?us-ascii?Q?jJCpYr8xgh79mBgGoJnSaEPrKJfcYxiFx3jEXJkh+McKH8t1659rLuPNP2K/?=
 =?us-ascii?Q?NcBZDiuMi4AQRYqPSRdvH36zdbONRQCwknukg0K/VSe1ma2s21p7aAnuLcdj?=
 =?us-ascii?Q?8dE+0e3gsxa03tHpp20Q2UNglj/o9eBCNeNnfVjFTq+gFkpmppKybTdfiSle?=
 =?us-ascii?Q?MR5EPqCsc5Z3Lfb5hGDGgB07wGUrnZvUrvUyUNxScoHM2rofVWQRDjaOiSL/?=
 =?us-ascii?Q?7Iyk3udHEaS98DInQHmNicYKZptxZT2Ae9NfWVNvIa0/E8ajui96FRCvFOZW?=
 =?us-ascii?Q?oM5gRxIOQfM8+T9Pqcg0mPwOZ9Wpx1qWVX12t/TI66KOSbklz95EQ99IPk5s?=
 =?us-ascii?Q?V7/jfmn0BobV6GfTZ0KBsOvbMXldECh8/p+GS93gnPwOjeIf7XvVNFrEBsZb?=
 =?us-ascii?Q?9e/wGFVjWKFf+vBpnDRJGSyKcHHzu1fo3oZ5GgqnC+lLs1I4mQ+yrofTUJJZ?=
 =?us-ascii?Q?9+5LouKlamk54A4E5Ycs3dmPNu67/55whs40JR1Vi8d6kyr0LOBPc8pOHFxY?=
 =?us-ascii?Q?EUIjxojCnOwgtvvCQpWymcag1l9UoE1wGHQDm+BP6xKpU1kp44/KH5NCOS6V?=
 =?us-ascii?Q?Jk0xUWyk5e2aTT8zab6KvaX2vuaUKTIZMOHEKSNfcqtfbUR0KbvoUn6SG6/3?=
 =?us-ascii?Q?V87BK0db7Slfi9wg0qyourKAHkJug6ZSIQxzY+rqNBNTxC4JkVaDkmIcL+7X?=
 =?us-ascii?Q?97H2taCW2r1Ya37hNf/EhsdY6I7fOevXFGkMcTb/QYnoQz8U5R9wEG7Fldwe?=
 =?us-ascii?Q?dIArYZfAPBWBsDrdfj4IiWYuc1vOpa0sBkR1cSmIsxKqcpqGS3bL+mzMD9K8?=
 =?us-ascii?Q?C2MEVevMP+5S3D0B8qYLuzPntGOKWEwkBPbjsFMfOECmh84ODsEecGm7oD+o?=
 =?us-ascii?Q?JfmB/SdH9536ts59wPsmJqOpzRRtQ+EVZJvOSPqFyTjIR2uymoCse4plQ0oh?=
 =?us-ascii?Q?+Fe0F18Sau/h+YDoRfe5d8hk3J52vHNBvg/09vaBgm/KqokXIEo4sQoEE4jU?=
 =?us-ascii?Q?X17of+WQPnKmsPcVrUh2sq0lK6S8dvjKFmSFK5UVyCuXEVjYZeDXPq5NeZBf?=
 =?us-ascii?Q?vLLh9/b3hGDFSCfnQJoL19/UIDmiqK/oOYswsUs3sHhg1YhXznvFrwBfs/gk?=
 =?us-ascii?Q?A8iBeVjUuq4bchWk9ZxLQn6GMLt2a9DycaiLVwOJD5y3XnsiKdL+/FeQIQNZ?=
 =?us-ascii?Q?r7TnyxMfUpBL9jk/IQyss+3eJp4vhGqwJCmSztUM5hCNuRgbNTd7Rh2meH5V?=
 =?us-ascii?Q?G+U5N+6R7eyy4e2iG1fdL/FvG67C82uX14bvJC8V+EUKxhg/G2GVuPG8WFhG?=
 =?us-ascii?Q?S3f6sOjgt/w389bS58xIW2iJzsCY85ZP?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7egctYLeAeMg95vFEkqTkcm5t55j0w7cRAz8CPV4/VAAZim491TJ0k4Ce5B4?=
 =?us-ascii?Q?pK8XZ63FWmaGp2oHE3KCNR6+oz25kD6WjmUrRyayMUYMOJqpUG6ByciOzcai?=
 =?us-ascii?Q?ucGRm+1Gkk6Bm5I3pYlPlpNc/KVyzbDFdSXmqyEpuOx+Ri+0LaEBX3+FECT7?=
 =?us-ascii?Q?g7KMAceYmvxwLcSFmtivIkFfBC4m4HnUo7qHMq8xbaCApOXZ2QFUy9ENIoSb?=
 =?us-ascii?Q?pMF0jvPbTi+7Oq4p+P3Keqgg3w3yERjsAbaiPw0fDMu6pSEM96wNLGfmyarU?=
 =?us-ascii?Q?dpk/8Ia14LnMiIojndJ8BOtGarMb5e9IBaDKlL3KWhxDpSqRkGy4MykCVN1e?=
 =?us-ascii?Q?ErRoWJdm6BItf8bQ97cupFdCI/urXdrbblO6A7FfB1LVJm2risXaM2ve7uKp?=
 =?us-ascii?Q?Hj1i0nvHyCodpm1lFujPtfwiudh24vlM8Nr0YMdT5lbefvWW6JHQG+S/TRUy?=
 =?us-ascii?Q?aI90YvmYR5tAcOYChQM4/oydOFBFHhNbyU465o3rEDHcOheXesvDA6AHX/0q?=
 =?us-ascii?Q?1dUUczCS6yngmIHiHdSI97OJeYRzomE8cikne9SwjnahsXYoJYRBIZe8kwGl?=
 =?us-ascii?Q?zNXcfMAv19TqhxslKo8h4/HosabFkofrh4dRGv0AM+N8kW5MKqXiphR97Mxx?=
 =?us-ascii?Q?A9fAlCV1QteL6lJ89xDhjB13uwQ4TYCXHzHE3JFkfBIBYByoehCxt1YCBPh0?=
 =?us-ascii?Q?l630DmerAhNLJLJbtc0hJbZkwFLxyMqRzD124u+4icioYH4lV/zs9AKarGxB?=
 =?us-ascii?Q?OcqQTuZO+rAGrVUKgKLPbF/QlW/cX7uojOWRjqkqgJznIozeRpavptkR4n5s?=
 =?us-ascii?Q?+BMgjESi9tksfB3zZ8VPB3IM4TmcOIGMrBUfwV4n9/XTGlVHnuKNPGzW+FIm?=
 =?us-ascii?Q?f+NHqgZHUJxgfHhOlT0gi9CkM1YzO8qsh3b42KbH8O3Sq35KqE2IgC4b2ytP?=
 =?us-ascii?Q?hEQCXUorGQxayRykpjHLJtcSkF0/HKybJifJ3SmR7fsSiEfCVu58D9EEWpYN?=
 =?us-ascii?Q?iQmYL1p5hcnr3CSFaCC6fAw7AbhfIPVzSCEvlIAonuc0vgcop1TRO5+8D1f4?=
 =?us-ascii?Q?HwwMOIclVEdPoROnlWfpIicvnICjw1CO+cUI65b1+2VqR2jKUUQzmMJsNWQs?=
 =?us-ascii?Q?9iKIUQ9hMT31zAxeodCTO54BGcP8i/UMOl723hEqET6BjVH2AnDZZGK9OKlj?=
 =?us-ascii?Q?CXjN222L7p+I7PySYa8m7Wu31GOFZUdBWhUnsEq1lqQ/mHRqpAQHs79omHqy?=
 =?us-ascii?Q?TYZVq05Di8pW7gT2C2vMsnrnG+oeOqLSyCVYnp8zoRaFId5PtfcmKwsquuu2?=
 =?us-ascii?Q?hTJhc2/W6+ib9N+jt8EQATWSMQa2w64jkm4MXgTe19dv4S/t24/g59zqcZpr?=
 =?us-ascii?Q?q/yEq2FrldkUy0CQJzzGL3hQ55buDeu2JtKIdC/hw6hdktqEcVlG42Tldg8X?=
 =?us-ascii?Q?M6qtatQYuCL032nzhBmYTgvNce+e1IJcA0cfWi0PIVizjcR6spJt6SkNph00?=
 =?us-ascii?Q?h7CgolBljzLMBAfYaeNVlDF+AQucKP0yHGBpmaRzwZhnt7MJtphkHu6YEFwN?=
 =?us-ascii?Q?EapD211UTZrJYXe9zmzEGn6qbItHVrhsX9NPSR62qlSvp5LoAnA/rrUupP7Z?=
 =?us-ascii?Q?PQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	FwRArulS4wcrOmXIv9e9Txz9n5VamqDsGhf07cQxsw3vRozJ4tLF6Lap6cAlkXIvOVBj/MFezPijZcaJhrFC71wNsxWlvhTFEEyr+1I6jt0Tg0JMGAZ/E4btuj7LX5AJ2VmGXTekTC5MZ2cIidSnJslw4xiNQgwgcZIwsBRqzKZphWmAb4Cp9qkyaBS4a6TS1SaurE+UeX8FOcf0rgn6iVstH0drTgzMpt7dgblXkYcgRycOcgBw6igKko4YvmWG6eiV7xxQQcn5JlJQRlwK7b3r/ZCunqbQBNuFmNbqLHbrKuX77jabcwovhs4cNUiZz9qPMKGriEkctJifyrwecK6Rp0T3EOGNA1kHHmGXVhk5kecx0do94TMI11f6yUsin5MIkZ0RDT7vH1m5Aw9UauIesL7GMAGH6RF2MHznpppDthmaVSfsjacsqOpAs6KGo9qzQp/BxesHnJE67G7tm0OiRK4vw1oQOjh+raIAPlLlw/SSBYbjRRDsUW8EBGNRyNorRt9ZjpNFetLE544j84Hm7l9LP6Mcg0KDCx00FM/X+cui459N9CN8NE9Awrro1kmdu4AMHRYz4gJo+sqIv+hkOhvl0H3tvifXkrjEXA4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9b4280b-10e5-487b-28b2-08de3d67a179
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2025 12:27:23.4206
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cf0mckEDtoGWrsRj7oD5kgWMdBjX0TfEYbrDbUZZgWZv8bxCGA0PQ6TD7msKLxnUlVKPP8kS3ZsaKBySc3qCO7XalTUGOw/7tK69J7UUS48=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF545856187
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-17_01,2025-12-16_05,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 adultscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512170096
X-Proofpoint-GUID: RBbAyt25UsAcQykImw1SocSSskLC6bpc
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE3MDA5NyBTYWx0ZWRfX9KO1ogMbyFKx
 12P/DHR0HrexQjKgR3/mhYyQItdx3dOveEiQlfxPf7meqgXyznw+e5lv0drv7kWrbMSJZd16hzi
 0rQpNR58Y9MCKrINa2G/hGMUSFUsSqlp+78zF/RUg801lBmndTkYwXru6R513mGCHYXhL8sZLNp
 W9/baAvcVDvS8R6683NHs6NVRbw/x2Rl9mIQCAmBPdxRic3ngMJvK4PqIr87Mb/Wtq17u2Olx2o
 vMBaU64WaYqTqjPam1CmZpXUuR4NT2qCYqu5sZecqU711LAfwFXDSusktqdv8cRs2fP8e+KhJJT
 K2A1Yk+5QGG2pjezEe1t9uiORw+0CD5zGmb0o6+V7j1w1oSBIpHcJHXn+qDCuANpI8aVNq2nFUw
 z4XO+uDx2KkspMeGvn46zRUOQGeBAb+NFlLV2aU2jt7qXXov2qg=
X-Authority-Analysis: v=2.4 cv=GbUaXAXL c=1 sm=1 tr=0 ts=6942a1b0 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=wP3pNCr1ah4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=QDGw0KozxnkV29ZdokgA:9 cc=ntf awl=host:12109
X-Proofpoint-ORIG-GUID: RBbAyt25UsAcQykImw1SocSSskLC6bpc
X-Rspam-User: 
X-Rspamd-Queue-Id: ECFEB18000F
X-Rspamd-Server: rspam04
X-Stat-Signature: ikrdwihyssip8jk61oeqij1m6qebbe5a
X-HE-Tag: 1765974453-601096
X-HE-Meta: U2FsdGVkX18sxVUR1qSHnWidX+sQaxlxPOSxkuNNThtZKv/jwxK/0yWeNyZ99qwwhIO4dChY0Ws9vS54hg8IUE3IMLP65ycc+PP9IlgXlEHTZYHp+gp0HLQKzVDX2xhmbgB4nTxq/nAFHeb050JdQyfxmQgLcV7JrhaykKjk2WsfajkXrfWt/1pE52Ino8+RDAooXdpzezLGxGMoCmAI0AxJBjgwSrEmE7Oeugx+OK5Ld+OTqoZ45WwqMmbtBQBeKYxRhY3QOW/zy9r/RZyk+AXw4SsfU4l1VpSVqgQDvVl4YBGug2KYpoXHvnJwGPmSe1WKXW0nwytd2oG5FSWaL8lT0xa/WOJ9xFz8E8AsaObmDyZPnBJND1gl7ScEo29+kexwY9BV19NA9ZmEhTgHMZzOH2QJv9EwzaOm/e2cEWrSodjj8ch1PXEu50uRzpjR+Ac91uyrnqFCOA4IjgHswiZC0lAmUfEl04DxITbgPPWlS1yzWucEpiuaBrnuxrVh/fKUUWsp64wFxtaWj2MENlifEyzsNdYPunXqJXN90K4dvZrb/9q/IldjEEXys91aBkCBdzLR65li9ETBVcnr/JJTziUdtvrnwdw7ZFetPZcrYTZAqHH0V78Z+ox723w2Oq96iMiD+rXWdBMLne2kL1eAwdZ521yYWrMgVtxH+ZfH3cYa3k+obYc5z2s+ecEbuJMeRUEgSssb0oApSBAe9dzLRyTmihTTNM3qJM/mbQhThUdcwpZ9Pa1tbJbXwSXsX5qplqnC1Xa99aZtOjEcCO0s99F59/Ik2JaxoXhTNja0gIONKEVhzIGNWh+ERBPoomJFCJNwm/5qABI1Y5zcsvLfNwZxO1OdID7IdqfI2wp9I2nh2VMt3vFDvEB14tGphG/T1CtYocEfTWeW0tnKIGtq4F4fUEC1RtMCUeHwv7VPBmHhgfIxAqmrfuRm/vifBsEgtqdTorJ2IK4GG4r
 4xsO8QxQ
 hgO3mLZ2fHCiiIltbpUUzmryhF6lQW6rwLAZiqqo6GUrzA+Uv7EEB4By6PBwtxdnw3u+1O6JRARC+77qRl13UXisZAA0C4tI2YnzyQaU5tkvrpZBYVVHce7awEfI0dhpxXt3Cdeolebo9p6/cvG9SHbsAnS/KDIR1Fb70IqWvCnjdH6UjlrtxZf1eZ17DUd7Togpd/rFmD3DzmoEY+jLn97l0AsN2/c/9Ojfwg+CDfHhN4VwPA0IaHcGHKziWEodeHh3RpacYfI+Ro2MI7DiDdPrJVkBpL4JwwOiDkw584PS/SM1y9bsA/SgdQOSYFzabRs13uYWmbJuBeWx3L6eBqPbinz/k8lwjAtG3/fkDcq1wMm9p0EhVVnSLgDkvhL1jSMn061FcXp8tFxRcYtztHFDP0gBsJsbIaANBwD+cVOUrGmkO4TqHtDyiuQlhvhZusBGa7IiEDuA2g73kolSHBux5Wsb+gtCRN2vilzT4HsJP26V2T+PZrTQ7w9whmeQ8QUbzq6wxX5tccQGEitPdr3SBY2j27Ak+dOd8aOzL4aXOC/bdPwKa+M70Vxw9JS8rHxoZdiuUsV6Mraj/2vEExIoo0Xud0vCvuvFuRxCAUbwV3CO5Jf7QC0X6mz15Tt4LqFH16PDUKFRhLNczduv3WbMKAmgfNqgMaF7aShn2Zfna8opmRPZ7GFg8tCa0UyV15jBPhrDQ6dE1isxmiD94ZnyM5yaCyOhXjDjU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The root anon_vma of all anon_vma's linked to a VMA must by definition be
the same - a VMA and all of its descendants/ancestors must exist in the
same CoW chain.

Commit bb4aa39676f7 ("mm: avoid repeated anon_vma lock/unlock sequences in
anon_vma_clone()") introduced paranoid checking of the root anon_vma
remaining the same throughout all AVC's in 2011.

I think 15 years later we can safely assume that this is always the case.

Additionally, since unfaulted VMAs being cloned from or unlinked are
no-op's, we can simply lock the anon_vma's associated with this rather than
doing any specific dance around this.

This removes unnecessary checks and makes it clear that the root anon_vma
is shared between all anon_vma's in a given VMA's anon_vma_chain.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 mm/rmap.c | 48 ++++++++++++------------------------------------
 1 file changed, 12 insertions(+), 36 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 9332d1cbc643..60134a566073 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -231,32 +231,6 @@ int __anon_vma_prepare(struct vm_area_struct *vma)
 	return -ENOMEM;
 }
 
-/*
- * This is a useful helper function for locking the anon_vma root as
- * we traverse the vma->anon_vma_chain, looping over anon_vma's that
- * have the same vma.
- *
- * Such anon_vma's should have the same root, so you'd expect to see
- * just a single mutex_lock for the whole traversal.
- */
-static inline struct anon_vma *lock_anon_vma_root(struct anon_vma *root, struct anon_vma *anon_vma)
-{
-	struct anon_vma *new_root = anon_vma->root;
-	if (new_root != root) {
-		if (WARN_ON_ONCE(root))
-			up_write(&root->rwsem);
-		root = new_root;
-		down_write(&root->rwsem);
-	}
-	return root;
-}
-
-static inline void unlock_anon_vma_root(struct anon_vma *root)
-{
-	if (root)
-		up_write(&root->rwsem);
-}
-
 static void check_anon_vma_clone(struct vm_area_struct *dst,
 				 struct vm_area_struct *src)
 {
@@ -307,26 +281,25 @@ static void check_anon_vma_clone(struct vm_area_struct *dst,
 int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
 {
 	struct anon_vma_chain *avc, *pavc;
-	struct anon_vma *root = NULL;
 
 	if (!src->anon_vma)
 		return 0;
 
 	check_anon_vma_clone(dst, src);
 
+	anon_vma_lock_write(src->anon_vma);
 	list_for_each_entry_reverse(pavc, &src->anon_vma_chain, same_vma) {
 		struct anon_vma *anon_vma;
 
 		avc = anon_vma_chain_alloc(GFP_NOWAIT);
 		if (unlikely(!avc)) {
-			unlock_anon_vma_root(root);
-			root = NULL;
+			anon_vma_unlock_write(src->anon_vma);
 			avc = anon_vma_chain_alloc(GFP_KERNEL);
 			if (!avc)
 				goto enomem_failure;
+			anon_vma_lock_write(src->anon_vma);
 		}
 		anon_vma = pavc->anon_vma;
-		root = lock_anon_vma_root(root, anon_vma);
 		anon_vma_chain_link(dst, avc, anon_vma);
 
 		/*
@@ -343,7 +316,8 @@ int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
 	}
 	if (dst->anon_vma)
 		dst->anon_vma->num_active_vmas++;
-	unlock_anon_vma_root(root);
+
+	anon_vma_unlock_write(src->anon_vma);
 	return 0;
 
  enomem_failure:
@@ -438,15 +412,17 @@ int anon_vma_fork(struct vm_area_struct *vma, struct vm_area_struct *pvma)
 void unlink_anon_vmas(struct vm_area_struct *vma)
 {
 	struct anon_vma_chain *avc, *next;
-	struct anon_vma *root = NULL;
+	struct anon_vma *active_anon_vma = vma->anon_vma;
 
 	/* Always hold mmap lock, read-lock on unmap possibly. */
 	mmap_assert_locked(vma->vm_mm);
 
 	/* Unfaulted is a no-op. */
-	if (!vma->anon_vma)
+	if (!active_anon_vma)
 		return;
 
+	anon_vma_lock_write(active_anon_vma);
+
 	/*
 	 * Unlink each anon_vma chained to the VMA.  This list is ordered
 	 * from newest to oldest, ensuring the root anon_vma gets freed last.
@@ -454,7 +430,6 @@ void unlink_anon_vmas(struct vm_area_struct *vma)
 	list_for_each_entry_safe(avc, next, &vma->anon_vma_chain, same_vma) {
 		struct anon_vma *anon_vma = avc->anon_vma;
 
-		root = lock_anon_vma_root(root, anon_vma);
 		anon_vma_interval_tree_remove(avc, &anon_vma->rb_root);
 
 		/*
@@ -470,13 +445,14 @@ void unlink_anon_vmas(struct vm_area_struct *vma)
 		anon_vma_chain_free(avc);
 	}
 
-	vma->anon_vma->num_active_vmas--;
+	active_anon_vma->num_active_vmas--;
 	/*
 	 * vma would still be needed after unlink, and anon_vma will be prepared
 	 * when handle fault.
 	 */
 	vma->anon_vma = NULL;
-	unlock_anon_vma_root(root);
+	anon_vma_unlock_write(active_anon_vma);
+
 
 	/*
 	 * Iterate the list once more, it now only contains empty and unlinked
-- 
2.52.0


