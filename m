Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A5E6CFD623
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 12:33:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB3426B0092; Wed,  7 Jan 2026 07:33:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B61956B0093; Wed,  7 Jan 2026 07:33:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A181D6B0095; Wed,  7 Jan 2026 07:33:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8D5156B0092
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 07:33:29 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3043F1A0332
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 12:33:29 +0000 (UTC)
X-FDA: 84305108538.27.557D603
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf08.hostedemail.com (Postfix) with ESMTP id CEBC4160009
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 12:33:25 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=DlCACsJu;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=GdpGxp98;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767789205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1Xptg16BMA5T1yOQnRVBKkkNmiuMKYWAFU1h3aNYN40=;
	b=ml1uMac1WEbaAJW4CbOMxYLUv6Zezy1zLl6bSKKdGwdY2vfsA4Ig4VJFfO4rFO/3wGQM5t
	lyE0vEz5xY6dO7fTiQWxsIYw0k3Z1zSANWQrUq80N/uNqa0Vte9T+lgNBR/T2G+tOltPrA
	KdLEbjWRfpPUZ9Io2YCEulim6AVM3MQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767789205; a=rsa-sha256;
	cv=pass;
	b=g97dMrmg+d885Flp7Pv1lLYBvdHMIiIWrAuK3n2YcM6z/Nie6PRrP6fsaM2vV0IWabTlxP
	N9nH0GVZS+6n5EsaY1XMT6+brrRwbUscatQmKXPUChskR9g+0fSZBsTY1pa4LWN0RTQCxN
	J6NPGE/0Rs899XYagSSOOjiA48zgUbg=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=DlCACsJu;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=GdpGxp98;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 607CSXRi2010672;
	Wed, 7 Jan 2026 12:33:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=1Xptg16BMA5T1yOQnR
	VBKkkNmiuMKYWAFU1h3aNYN40=; b=DlCACsJuxLa4WMb8Brb+lAArHlYYu4RhFH
	00O16z50odF6Fl1KL8oPzz5KV1Gfk5XYnhF5Ml//V5WHjLlrbDeSi+LJRcQNf3zy
	JTRRuMcO4K4cTKh6YNux8h/kI2f/Xug4J4EzluS7HoLhymslS/ymN0kKf6n/3qZj
	7qnmsUHKPFE2FV+Calu4Q0DF9GHVD0ijGHxQTHFusZqumCimjMZkp25J+cJbBseb
	wCPwcW84Gwe8aRw6z48dQET3tEx228p6cz4/sZWn1sdH1BppFvM64VdFPEPEzV6K
	aF0zzuph2zUpDgjkYjZZtQLEruuMJkX1OYtis5EdkfxtnDwx/ytw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bhqh5806e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 07 Jan 2026 12:33:21 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 607A6uYd033897;
	Wed, 7 Jan 2026 12:33:20 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011069.outbound.protection.outlook.com [40.93.194.69])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4besj9t0xy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 07 Jan 2026 12:33:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OIrkap5cKZ9OH4G/PQmkh4fdYLJjnkVn5oG8IzyDhL5WO7A9MIFNff4qCl2kSGXSh/Pf9g6JWmbuvJNUFParIE5O5SgOknSHfbsmE6IhvA93TOtevPImzFXx/chGl7bHxuTD3ZmQk342VCxr4MIf2us4pdlIHTAZCsGZ6aEvhp0kzxLLTq6MIN/zuopyU3DmB334Wl+29AscdSQFhLdXcPCBbcal3ZZcBQ2NrGtAlRsg+KSFq4uxFqP0o6VOMjQppD2ip0zc3VkMl3DDjx9CBAOCeqPkrbieFyvZDMt7YInn8n7lu5r9Dg/UdBeXh3bME3Efm/Rzq8FSBZCq0kCgSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1Xptg16BMA5T1yOQnRVBKkkNmiuMKYWAFU1h3aNYN40=;
 b=hzb8JRJ92tK7vO3ysfuuoZ5QkuyAjS0bUBxuW0NkXEXHo5oD7+OTRoqB4nRaZIahSRnKteee+p0rXgGmM8EGrELxOaPsBcCGOJB4yKwF0sjDpOzWqPU8zj4k8HuLw/A7/aA4B03SVHUFm+jPPGc+ci/CI6ISDrM7hHKRyKdO9pZjLsRkbXsMM8scHgYTgW0b/LTpQd0Kre1JWxGMFrJpVJQe+ciYzFe67hg+eTexEUUjYAsPVGBxeVo1ALpL+CE+5E0YzzM65ubAQfkj2LXcSFebVJTyT8YSXNLWNOxba+17HZJnOsqGBzfagcMyRijejcMkF+q+NZSw9SJMFKYd9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Xptg16BMA5T1yOQnRVBKkkNmiuMKYWAFU1h3aNYN40=;
 b=GdpGxp98RrMGSBSTs92CDdKVE/+M2OxaYkdf9i8Z2VRQqnZnblbenXeMEE0miOGMtiLaMhS/8l0TVXs0tg5Nq1Sq11L52dyUOVsWw0YJQtFS84TVpHhANbR1fI27OaEnLMffuvOTFWUKSCOT/Azf5sfImeSyawcAn325Ap0puqk=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SA2PR10MB4649.namprd10.prod.outlook.com (2603:10b6:806:119::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.5; Wed, 7 Jan
 2026 12:33:08 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9499.002; Wed, 7 Jan 2026
 12:33:08 +0000
Date: Wed, 7 Jan 2026 12:33:10 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
        David Hildenbrand <david@redhat.com>, amd-gfx@lists.freedesktop.org,
        linux-mm@kvack.org
Subject: Re: [PATCH v2] fix AMDGPU failure with periodic signal
Message-ID: <6aa1dc31-cf8e-411c-b149-9f06edd790a7@lucifer.local>
References: <6f16b618-26fc-3031-abe8-65c2090262e7@redhat.com>
 <61c3d41d-602d-4dfc-872a-873acf653b6d@lucifer.local>
 <20260106101249.be7514e75c09a928c6fa71ef@linux-foundation.org>
 <52bffed4-d9b0-4ec9-85a6-ba70e22106f3@lucifer.local>
 <20260106125912.a4975dd1919c913c22fd5101@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260106125912.a4975dd1919c913c22fd5101@linux-foundation.org>
X-ClientProxiedBy: LO2P123CA0104.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:139::19) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SA2PR10MB4649:EE_
X-MS-Office365-Filtering-Correlation-Id: 5124ec8e-db1a-46b5-0016-08de4de8e9cb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?B2U3KFBtyzgiKMJQ8Xo8RKuv5XTmDyvzFgYfqbBhRWAwo5NEP28RyLspKcGj?=
 =?us-ascii?Q?p+jUrjZ9COjPcNJWeLIwOHXx9fyvpNd2CS0fd21rQpIaF7AeRUQ0M4HBPVmj?=
 =?us-ascii?Q?Fj3jxHiA8KjNqy2Fa7uzKJlw6fe2ZDTXroLsiVzpdDFJ8Fdd9WKLNPoh0Am1?=
 =?us-ascii?Q?ikosa30ikdVchT3ag0OZfxQSFO2tjcNaTOc8HATVUgXKMVH9M3oP/unMdcB9?=
 =?us-ascii?Q?4FKiRCrlfkhIVE/h1iHTX6041WWyIi02IoGxPMaJhtb3n0/dJy6fKpyc04Xx?=
 =?us-ascii?Q?5h4SPzKcOi3er91xt6UjX5h/dNBOcG8ar2HFbu3pS0fsAVNQsR7nmQc9exWO?=
 =?us-ascii?Q?EwEroKOw2/fbA4U6JbV4E+YrIZoJIL8fj6/CAL14NpakVzMK8Ws2k5/cu7hx?=
 =?us-ascii?Q?yFg49A1eZKNbBCmSS6M7uKKTtXyO/QFjQVWRcnjNLYmiVcxeoTXqny+TeJME?=
 =?us-ascii?Q?y9brOaKrLlUXTJ+/T5MQ2EI+iws5D9yQS2csqbyt9vfA34MbmeDLV93EQJho?=
 =?us-ascii?Q?9keQg2y6AWZvsg/7v2Rii7mmw+y2BodXt8vP+EYOyeqTULgeIoQx3UXeks4q?=
 =?us-ascii?Q?XvXV4o31PKupkc44Ti7AcXvJ47NpDh7vmKrITAL4jUhSEPs9PE4brq0MOsvF?=
 =?us-ascii?Q?OsVxfbGV5wYIw81IcGCXF7NZdmPtdnqGsuwzWJfE4n3C/Deh2G9GIRxynqhW?=
 =?us-ascii?Q?++OYHosUZg5oNsw/CYijlQ1/3a5S68AbaEJhIzTN779gsWKW/6VAcmPQOXei?=
 =?us-ascii?Q?Yv6HMy6KLAn4NWgHhHM5Ryv2ApmsQj0AarUG6f9Q7WLsvWfholv71ewatTag?=
 =?us-ascii?Q?oqdKiPBREnYxyaCVtf107fpWTtPi+fuabKg+eTHlsldmjIOKA+omckLV6P5M?=
 =?us-ascii?Q?8zCEoYvdjS+UWlT8KIlXHFWHbYCshJj4eHd9nDvmTdLCsGGYX/hc6vxsRc4S?=
 =?us-ascii?Q?K1JYrpojiGOe1Soy3gJeee7aJbNzZS1s0dvY4HhqiCJ6dt9I8UMWM+7Ws0ZP?=
 =?us-ascii?Q?ALcpoHfYL+oL7MlNwUY7dLmuH9pGWy+Mz36GZMHx6zmZHqQzu3YdwPCvBc7l?=
 =?us-ascii?Q?nwNSj5mNBFoJ/E6ZAyNBnhMm0dbdOJl1Z9j3WXqo8gGVpNrDI9ZZA4mfk5b8?=
 =?us-ascii?Q?5F92bZeaITgOx9TfFCt3mAZDj0Vm2fUER1Rm/hHXy2zYZ4cOLvQPRlBZcANQ?=
 =?us-ascii?Q?qqOoxXiRm8Udi6WbCxhLqG7qTSDzVbUE024cILbjTGFmXylG/QgfDK1ekIYP?=
 =?us-ascii?Q?ea1ZCfIhnBiSSHhC51rSaTEbnD350SH/hUVHnCSyUDXQ6a0Iqf7DjOLfF6lQ?=
 =?us-ascii?Q?hrGbduGcaS1SHpQvnNJhe8FuIEa8qfIemmWDtiFzvajSBLI9qEJ57VmQ82Ww?=
 =?us-ascii?Q?WT7HPhQp4mwBjceRFssclm74kIPe3XFEsqfVaKv+NjswmKuih0vG+dCI659Q?=
 =?us-ascii?Q?6MUrw13fWO5Z55QIe1QJaPlUcqatTiSQ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hV7rYu9KFblTeTFyo2QLPpUh9y3/WYg0pmt1EHQOUEhmA8a/zZ+m4iQYT9GZ?=
 =?us-ascii?Q?0NiQ7EMcoLA5IOHEkIKF97P+bGGsJGqWjxG9PPzTXL/7aZoKtRh5Xu68YBYp?=
 =?us-ascii?Q?2YMtAp3qCjYqCQb7Buaif/ZCHSkA4Yxsc1Di+ocTACCdZ6iZjOZDZjKtnSjQ?=
 =?us-ascii?Q?RpNwdmg9UAHVylJOeXsqEvNWljWkOEl9Wp6k0CkBlUzoDpN/hj7CJBKHtidL?=
 =?us-ascii?Q?RAcT3KnzD05kKB01KaMXYoya04X/9Dk25bGUiNIoR3MxSOVQHjjKC5Bu/cFy?=
 =?us-ascii?Q?l4eMAEggANmOMYB8nexE30FKmzME240or2pUk44R44l+3qN6Ml3PcZqiHXun?=
 =?us-ascii?Q?PcQ6HBhXj0B1oz6m/ThtzyOfTjTea3pe6qFg4Pys1OHhwzYWNbg7lKIjovyI?=
 =?us-ascii?Q?AmkvHd+XUKoz1QsLGBTTcdsxgu5fc8O30CN1D1xA+rPRS8VocAlKgm6KBSo6?=
 =?us-ascii?Q?wDAR72HRIT4CrUTi8DCQefVlW2NAih/zu2JAzBVWa6WMSMAvThwvETAUZMHW?=
 =?us-ascii?Q?gFkMlgdS8AC15hNVSxeZWGd+GARI6KyyB2R/RWu2AqzYg2u1j6ybtqAVlEQA?=
 =?us-ascii?Q?ioSRMzDZI2y3US+VzagUBJtAuRJatg1h/yowU/eA59gzi4Xj74Wx1d3biCbd?=
 =?us-ascii?Q?lYkaz7qQUjDvXCqoHnmcls9LplSDhYbQ8/7ILj9mQ2VnylSGbfQPjFx4BSnG?=
 =?us-ascii?Q?Loh4E9njEpTMc8s7Psx47mbwzvLUM61BOX3UzoEjVhMNG1c668ahlIbyuI9M?=
 =?us-ascii?Q?ztsL9rj74yJbo3tEhmcs+4idYg6MvlrW4kZ+HQ2b/X8CBWFD+bTipGR0VTYQ?=
 =?us-ascii?Q?F6W7XF0NgM7ZrcGDUQ/5/apXsRqTm18az0U0yQhBPhKOdPguenGINnQuLc/8?=
 =?us-ascii?Q?aiosmqgUpeSR82nsgjCvMgleIslV7OBc0Gj5DKNsDHrrOcUJZrzzSO8LLYZO?=
 =?us-ascii?Q?bvh0oKXbyPxT75RhyCs7sP6fc/yKNSsBsuRmZAlhTZj/+GmlHZwVhkpXRJKh?=
 =?us-ascii?Q?egAZIMQlaUos66GT/fqLw+KE9w+eH31B3FsMzImUMwqloe+g77rAzXrrSkgd?=
 =?us-ascii?Q?5o5Qyy4ASlbLpgocr99NApmZaDHuIh8pWVyPLEQQHGJiWB4CbBDciHmoUghN?=
 =?us-ascii?Q?5HW3jazvhLy9ZZ97C/1vrODKvr/4mui2svscuCsDUtzJWazNtTDVNcSZiLfH?=
 =?us-ascii?Q?0S+x07RYzK6mTLsqa5GKRqmYilLjYaf22jOXhOAYae+0BeeeYqxJVonXQ64w?=
 =?us-ascii?Q?85fJk+b9aFScuV0Wc2vSgu/y6FegTi34dDT3GbW+M1EYKhFgFk09+pitwbtT?=
 =?us-ascii?Q?z3pvw/FBM1Q7ZvA+JJ+6dbtcCi8g13rW4NqjoitzStUe7yIlWn3dZSoK0ym+?=
 =?us-ascii?Q?mGcv0xRtRTnFrz7r2J3alDA27rfEr6lNQhFAP3tzo+6qTavl7W7H5Gqolbxd?=
 =?us-ascii?Q?kl6uhgBnHI2p9XFZWuQLZT/wvboRe0TRQxGl9VxITsX6O8jRJZ/Dp4VZ4kkf?=
 =?us-ascii?Q?F//PYKdDs0jqlJdaotFSb/w9ezxfoYhZtZxmq+w50VKPGz2quTlznKCLZ1ry?=
 =?us-ascii?Q?H0HOM6abvKWNog3bdETJu7JNFuiLmPCCaVkxsGJY7pa1IknPlALCB36x/ldW?=
 =?us-ascii?Q?hUunSZeJNgjA1qGfXHx/lWwx8CMVrMdUuZTomsrda3xVa9mKoDRMnWVEb9ej?=
 =?us-ascii?Q?P+2/5MMK9N7hDY2AtHcKwZr6spfEuczFmJs37yfA26vWLdUjoikqzOVPCRY8?=
 =?us-ascii?Q?wLVOwKR6+dE6FnJRUIu9KECwDYWOu+E=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	qZtoWcPC44Lph1ZF6Qym1p74SrW6NcxiVZbu+1HEpHJHjo17c6GEF4czjmApexv4YR9guV/44NrMncGcpY8Fw/x0+9dJFy5ULnZ/dat/d6vtMfi4xfV43ITBZ5dJ8aCQ2AQYLQ4SKSROg9P+Q4MMoaeF6G5qJ48nof4uoSWgYUazBPhvx/Pd6ZmPlI6VMi2IGFrPY9wy0TQobyW+SnA2VWJxWPT/w7NCoCWhtgti4wNLretnwRPtmsTjfonACkL+9Pd0y3F4D8cuso41dP319IM2zNXsxx1a2pUzUjGSurmYCdF/XMm4TcM9Wltk67J1PE08qn8epgJ9cVcgIlbZ/z3mnYCAGUtl3H2ujIFd/R3BNCAo5aOmHFp+e5YowZz0CZTsiBegvLJUgK3eUB3iyJTtnWgFdNf0VGEjK1kHDiSulfPftrkrOA33ioL9KIuxOw5UvGzXuh6xHoiuZVqEtCo8B0gA3Ookwy+45NJ+e1ZqwJ4J+YeObxRgPuZxUZOiB5ljaxRMrBLhvjiyjtrllgFcFgNb2pwkr//vUugR19YvTuW1800DB6G6qCoXsmNZWlQWFDG3CUkFD59SMrdoDUieN7Sqh7jASiHrWqxdgWA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5124ec8e-db1a-46b5-0016-08de4de8e9cb
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2026 12:33:08.4218
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s7SWW8ErguBTFJ/XDJoZ+UgFEtB8d0M2vnl3bukBQV0ow2IPDOuo0N7rvBrP2kQCz5BBkfCBtIDOslM10iDYEx+8wIGTGMGM3HYQqDtidgo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4649
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-07_01,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601070096
X-Proofpoint-ORIG-GUID: SzfKvN_Vl7v6lDYb8q6KBZG1MuyZO493
X-Proofpoint-GUID: SzfKvN_Vl7v6lDYb8q6KBZG1MuyZO493
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA3MDA5NSBTYWx0ZWRfX5AWfWCUbu3O/
 3sEeebm4TXBY9DJ5djSB1/RoeO4JlYVDiFpVRF0hRnGPEsJzQKYIsUjdDWeR/Q+35yJC9ie39cA
 JHinX3SFQ+MTceKlBYQOG4nSgK6DLdRgGNmyVw9h7RTTVVhcNn2jn8GO5jVJWtN90Iz1GdPwkb0
 LoHR+0uq9zSFwiGRMfSbyyGC4ryJWSN6Y9vibmk0RXoOjRVWT7SD7wqba4D1kVhuGrcr39rP58/
 JtJ+o5RZV4TzgiolaQHK2LjdZ8ZQWvv10Gyp6+FPyFat3H3+pmwplj8ruJW0eeFd3YTwKn6YYa9
 DIuQTftK8Ugq60xZQJ79I5/Gtc1nvA7OesnO5IQbCpYQEKbJLpSkRuo8dCo79RigdAJdpIMZ4VZ
 IvCXWjNILl8eSUGbCmnHF6GbyMyYnjMjeiPBQ2asWI5vG2cAYquiQnGwijJJ6hg3rN5sbml7R0o
 fufBWB4PQ/BfJ61elVQ==
X-Authority-Analysis: v=2.4 cv=A+9h/qWG c=1 sm=1 tr=0 ts=695e5291 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=XAnEcf3Kla6l3f1awEcA:9 a=CjuIK1q_8ugA:10
X-Stat-Signature: wbnwj6rb7z8rfyxisegknk8b8tsikp3y
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CEBC4160009
X-Rspam-User: 
X-HE-Tag: 1767789205-456423
X-HE-Meta: U2FsdGVkX18eDwbTWjzJrv/2hxm9lnEDEnTvmfInw1j04C3tZw2bGJODboP7qF8LYNCH1QcoEk3xhO7V0ngS73gYbZQ4RoBz7pseuI7L87G0k6G7E3R5PlMGo/6zbLXcnWZxAAWZAm1IfaHtRCRHAJTfmDgCcrNNk8mHpqnniFBOoeG0Z2EmHRT9BsDUGV36+C6AfzmOeI3iLXirl+49mzEd5Mb09Wla64r04fLvdX47J3e4RXHViB3Uq1DPd0FYrTxbaVg5kxlsr5p8vMlgfthOQKry49BZPdF9PTGz6WVP99nOOy9b2LD7Jt7WLn91EOWV26hfhQ8JXDxfz8ZXM5vDZcNtLQwB2Sl1F4TrGkMmC53KEx9TbWzeMRQAAkqYlE4HdjfRwepGaCaiztx4WE4Qm2fOrQB2jJKGRUoza3tzBvn22woKzG5yiRF/Rm8b3FdhbZRhzzyH/whCyKZa9DFWabacpOY/j0vPHB1hMleiPlLkTgJ5ngjN/WeE6+5FiFq8pknw1hP3Khiku/kr5ykhsb2YXHfFsg21Wm4NC8zw26A5qcxJG68kBjLGCt5Ln7d9ZVHzqOfLhbB28c8s1mhCyqh+4XCH/9c4GTaEy56RDMasqOckYxSPISVqYmSzUJWJyM/IaEHFy38XrDXvWeCEnn9att/8ZvYl3NCgLhREi879WOfrmwQYe4Wl5EtPSOixE1dzkV0BRFAF7DjovWl+ZDM30KlhCvDafdngsKkLVQUlrM643UiYFNcdyAcJL4L+jE5FGEAALAm1f1qzIDPHkTFvapywwMxT1xL/Vid4tB1rILHdjV8Scdjii3Vqig+u4bavVaxJdixEbEsKAQaqxtH9FLmSkEDOQHOrADb6pyBGKEsj+9a2SsjyvBh1HYwNdYrDYEah3t0yjWZQbi+VRPsDBUpEQiPKnv0+3h330pIfBAv1DthaqjuB72m+dEeL5s9UX7eBXiNx05V
 Z5DdCCL3
 AasD5Bjqss8ecwXxRooW1+/PHvQzYxU89aINXvQhL2NSl7BFoXDzPtfcwCqdvgk5iHFOjyT1ZM5akcvesjL10npfMrSQBP8g+8LbNiDU7KtmqSc9UdDx5Hq6Swv8+GZ9FhrepBWKoL9YcbV/cHFq1blik8HiK1fBDi8F1jzjD4FfZG+d/DlbX3CfKSWDwnFpJVcissBeQ1tFecAGkcEEAG3TU5wliaqh1oUTArH5T5i+SORTjav8b8/M3lHLDGfDGhTClzbEGQla9qGQL99vgcJzBbKQM9gNSakhIwCH6/1duVIb1upRbq6Qu5H4j65xb0ttfrsnaBdfLJ5HZ9xOYRwKXwXMNANYgbqnLeulodWfJ65G1LF4JSGlule+R+S2QiDruXiqoLDNjfLnnNZPW4Q/W+jm5sNyWRTP5hvXpERXoOKGiVZ0WwGhpRi1d1It8CQpBBXGuRjDPSk4vH1AnLW26kZmK6KaN/vXXpFxryuR0TV8vz2IAiq061WxxOkD+dvqk1g/0R2oUBfqPoHU3uTMOek1BOgUKLUtO/EnikI4r8fJjNI3FEXTdV8LEWUqyuUy/QvBHhq8JNBLfoSaJqY0e+iK6Nyz0JIzbD4MYyn+Y2R7bdZ7OEh+xoqjtNcnQt+y/WGKsPHa/vvQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 06, 2026 at 12:59:12PM -0800, Andrew Morton wrote:
> On Tue, 6 Jan 2026 18:24:10 +0000 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:
>
> > On Tue, Jan 06, 2026 at 10:12:49AM -0800, Andrew Morton wrote:
> > > On Tue, 6 Jan 2026 11:51:49 +0000 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:
> > >
> > > > I'm not sure if the git repos are lagging vs. quilt, but as reported this
> > > > patch breaks the VMA tests, and the tests are _still_ broken.
> > > >
> > > > Yet it's still in mm-new, mm-unstable, and even mm-hotfixes-unstable.
> > > >
> > > > This is interfering with my work, can we please drop this.
> > > >
> > > > Also the v3 is currently being debated, so surely should have been dropped
> > > > until we have this resolved?
> > >
> > > Well.  I don't drop fixes unless it's decided to be a non-issue or
> > > unless a better fix is available.
> >
> > Even if it breaks the build and that's been reported on-list?
>
> I addressed that.

I don't recall? If it's just git tree lag fine.

>
> > >
> > > I've done this for ever - I've held onto "wrong" fixes for *years*.
> > > View this as a weird issue-tracking system for a project which has no
> > > issue-tracking system.  It's to prevent issues from falling through
> > > cracks and getting lost.
> >
> > I think a lot of the issue is these processes seem to work to you but those
> > on the ground are finding them not to work.
> >
> > The kernel today is not the same as the kernel X years ago, esp. in terms
> > of sheer volume.
> >
> > Having a patch that none of the relevant maintainers/reviewers have seen
> > land in an -rc out of the blue is a really serious problem.
>
> It isn't in -rc.  It's in mm-hotfixes-unstable and it's marked "acks?",
> which means not to go upstream without further consideration.

OK this is another inscrutible part of the process, my understanding of
mm-hotfixes-unstable was 'will go to -rc unless otherwise noted', now it seems
to be 'maybe rc maybe not, but unlike other series, negative review will not
drop this from the tree, even if it causes compile issues'.




>
> > Also it was taken 2 months after it was submitted, so nobody could have
> > _possibly_ picked this up by reading the list. This is why I am really
> > underlining this case.
>
> That's why I grabbed it.  Had I not done so, this issue would have been
> lost.  What I do *worked*.

Um what worked? You didn't ping any reviewers/maintainers, there was no
recent mail on the mailing list for anybody to notice, your process would
have resulted in this patch going into an -rc without review right?

Was the hope that somebody would notice in a release kernel that something
was broken at some stage? I really do hope the process isn't to rely on
that?

It's only because I happened to notice this (it broke my tests) that
there's even been any review, and note that the patch itself was broken (no
fixes tag, numerous issues) + has caused much debate - that was because of
_my_ efforts.

I think the problem here is your processes are pushing down work onto other
people. Merging patches without maintainer signoff forces reviewers to jump
on things out of fear broken things will be merged (as they have been MANY
times).

I would humbly suggest you listen to the people doing the actual work
here. It may to you seem that your approach works, but if the people who
are doing the work required are telling you it's not, then surely it serves
the community better to listen to them?

I am for instance no longer going to be checking mm-new, and I feel that I
was one of the only people to actually try to report build/test issues
there.

>
> > >
> > > It's unfortunate that this one causes disruption so I guess I'll loudly
> > > comment it out and track the issue that way.
> > >
> >
> > I think we need a better approach, yes.
> >
> > We in mm are really very responsive compared to most, I think asking people
> > to wait and resend if somehow it got missed is considerably saner than
> > 'well I'll take any patch purporting to be a fix from anyone so we keep
> > track of stuff'.
>
> If someone wants to step up and be MM issue tracking person then great.
> I don't want to be that person.

You're not tracking issues, you're tracking submitted bug fixes that may or
may not be valid, and deferring the actual work of checking that to others.

I don't think arbitrarily accepting fix patches is helpful here at all.

And surely keeping a list of submitted patches and a reminder to ping
people (if they were cc'd...!) to look at them is not too egregious?

I could take a look at doing that if you're not happy to do that, though
I'd really want to feel my work would be appreciated, and that's not really
the impression I'm getting lately.

>
> And let me reiterate: had I not done this, the issue Mikulas identified
> would have remained unaddressed.
>

Firstly it's highly dubious there is any issue here (see review).

But more importantly - this is simply not true, you queueing this to be
merged without notifying anybody, and the email being 2 months old, meant
nobody could possibly have predicted it landing (you'd have to be reading
every mail in mm-commits too...)

So the most likely outcome here is this would have got merged unreviewed
with nobody realising, including the people who maintain mm/vma.c which it
changes.

Again it took the work of the actual reviewers for this to get
attention. The correct course here would have been to ping the memory
mapping people, tell Mikulas to cc- us in future, then await maintainer
sign-off.

Thanks, Lorenzo

