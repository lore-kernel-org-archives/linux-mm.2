Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64FA9C8303F
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 14:27:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B35578E0024; Thu, 28 Aug 2025 10:27:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0D528E0006; Thu, 28 Aug 2025 10:27:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D5028E0024; Thu, 28 Aug 2025 10:27:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8AB9F8E0006
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 10:27:06 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4C7CC83B64
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 14:27:06 +0000 (UTC)
X-FDA: 83826393252.24.A041921
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf02.hostedemail.com (Postfix) with ESMTP id C490F80005
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 14:27:02 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=he5bWClL;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Urbu8g9q;
	spf=pass (imf02.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756391222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NcBY6W4NVuSBfhnIa/YurWyaxTFQfwhL9r2T6fOyp3A=;
	b=30StC1oSKuvi3fnI2kWLGii4WJX75tNdAUrM1gKOvOgOBwg/cBgKUynqA++1YIRFpmFjrc
	JKUNSdSRgbnfM4U8m+Ta2RnGHzB80y6o1lBX/uAPdFvXzZ6PsostinAMXUU9eCCS7UU0e8
	p8Ot0WRCcTNlaaczwEFTBAn2AeD/Bps=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756391222; a=rsa-sha256;
	cv=pass;
	b=ATkQAzuEtuT8z5wS1ser9y09qhr4uFIMK3gGBpXIa3cN3dkA+E5srPqLKxkK3ob8aPdQEK
	qXtQg4DzQsekoCaGeWnJMo4I9u3onwAjpxwxwFR6KqQFR4XuX4txcLbmFG21GjnWHXSNT3
	eH0A3wO1ZbEjfLECeDRcg0YlhQ8Cel8=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=he5bWClL;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Urbu8g9q;
	spf=pass (imf02.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57SENCig016276;
	Thu, 28 Aug 2025 14:26:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=NcBY6W4NVuSBfhnIa/
	YurWyaxTFQfwhL9r2T6fOyp3A=; b=he5bWClLMJhdX6XI4ZLp7Ci9mzLTI730e+
	VERWK5+9ZFwYmfRKtCT7e53DyhjMWT3IhZ4iyKgI0SQ00bGgEh1OSADSKsGMj17f
	5bif2o8zt3C/+9IfpJG/39oTzn6RJGuln6rOwq0sAc/Rnd/SlgeZxFEn4WCgrH1g
	CJaWimP5YBJnJcpJTSOXZCrfGvWnAtAYrvdFs0kVqKc4NNosE6/geXFQLBLd6OKC
	6URZDtDGS8JOLncUyCVDguAyHd1WDgh/OIaKUPWwTWkHBHWWt9KaAFDU0b24JiIc
	Gd8jeiren6gtsCTej7wsrpK13aRg6zOtV235uRLOHlAYe5N0dUSQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q42t8g3q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 14:26:48 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57SEDAeX014521;
	Thu, 28 Aug 2025 14:26:48 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12on2060.outbound.protection.outlook.com [40.107.243.60])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48q43by0na-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 14:26:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ozQFjfTb3NbK9cD7k8c8KX96pjkqO0lLG5YHG/XU4dFqckW13/oxCbMHzWd6ZIGXPKHbRUwmkEIHuLBwT3LCm0yJYZTjmGOJFIO0AKBBGUysNjLpV0269AOczwC0bUrc8nC+mrNp6hwx3YdZdW00hBp65GYpg2eruH1BGnL3ft6ZidrAYMaF/unybsgQQlrnVko2l8A0t9PotvGx+wZrq6eS4lLe14rj3PpUCwmJgR0E14bL/WlbadHGgHlPIiBBiXyaYEZdFkgxU6nLLFFAYd7HPg0cpXUDDEpicYdmPP78nOOACoDuJoJatslYlcIfS5yboTr9E8L/2LiscSDCwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NcBY6W4NVuSBfhnIa/YurWyaxTFQfwhL9r2T6fOyp3A=;
 b=gFKfqud/+TwIDzTuqBxDgBFhtx7b023DkqAuMxITJzbAspQmr1Wft3bUyRAuitdOyL9GADE7m7oMc0Dj2LeW/BaHqAELRRhxkNKQ1B2nwOZzlqOaQi5PUc4TtTFEqNoqxKZffKdygflIlsdmm8Bppm17vN224QcXAwKXUI/AzVwj4EKcNjzvDnhIAU80pQlll8Y3vvd5qhdno8B2PMgtNljixK+whAl7j1u0z+2DNeLrSX+BRde6TbO0e6E4xV2V4ZKttvFnsWGtniwGDcWtL52/bUeBUogax1+PQkmwaAW0fL5FpubBIVamKNTn82vPOIsSZumTFcY6iQ+a8A7g9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NcBY6W4NVuSBfhnIa/YurWyaxTFQfwhL9r2T6fOyp3A=;
 b=Urbu8g9q7af7611r7NRHzrKcv7mVJ9ivLoN98sESloSzYBqpAca91fG9kkkva7ZlHWdWCvjsGk5F8YqPl2uHaTlt8UnOeU5TSgZYd2r2WnfvoQD13Ofm06Lh+V1obTAOQhQKJOQKLf8vobCzDFjEJ3RL/BVyHfwLI8btLsid5+U=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SJ0PR10MB5647.namprd10.prod.outlook.com (2603:10b6:a03:3da::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.15; Thu, 28 Aug
 2025 14:26:40 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9052.019; Thu, 28 Aug 2025
 14:26:40 +0000
Date: Thu, 28 Aug 2025 15:26:32 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>, Shuah Khan <shuah@kernel.org>,
        Alexander Potapenko <glider@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Brendan Jackman <jackmanb@google.com>,
        Christoph Lameter <cl@gentwo.org>, Dennis Zhou <dennis@kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, iommu@lists.linux.dev,
        io-uring@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
        Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
        John Hubbard <jhubbard@nvidia.com>, kasan-dev@googlegroups.com,
        kvm@vger.kernel.org, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arm-kernel@axis.com, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-mm@kvack.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-scsi@vger.kernel.org, Marco Elver <elver@google.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
        netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>,
        Peter Xu <peterx@redhat.com>, Robin Murphy <robin.murphy@arm.com>,
        Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
        virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
        wireguard@lists.zx2c4.com, x86@kernel.org, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH v1 05/36] wireguard: selftests: remove
 CONFIG_SPARSEMEM_VMEMMAP=y from qemu kernel config
Message-ID: <544d9592-403d-4b4b-b00f-250acb593c1b@lucifer.local>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-6-david@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250827220141.262669-6-david@redhat.com>
X-ClientProxiedBy: LO4P123CA0362.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18e::7) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SJ0PR10MB5647:EE_
X-MS-Office365-Filtering-Correlation-Id: b045dcd9-7f0c-4a07-2dcc-08dde63ee7d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4rP+BSTNZglU4x5fp4JbLBq54ws3Jm39LjAlZ5W0Egi2olQ/O15XuZ9tahux?=
 =?us-ascii?Q?p3efaXnzdXv9ibsKp+QrVRVPN+6L55cnqhnF5wD/rA44eboQisDGrTRZR1dC?=
 =?us-ascii?Q?NE5KgozGSOH11G9knOu9YS2Rb7LC436Bhee1FxgfbbmdXG8e08+LYCmsrQh2?=
 =?us-ascii?Q?b1yXtFfMXoNvUgNRt5pAouz1PLB5UaRgHMmk85ti9q88BRt7iMgyq1Dsf9j5?=
 =?us-ascii?Q?qDdOtmKz+FxABRGwADV8b/afkZKGtcXVe3FRkXctvNxgd9WGpEowRGJW0OPs?=
 =?us-ascii?Q?ZuOOlPOEYVwwOsOh8HX5Il/MSG3pmjlOJlOqRO+1U099v0l3uBm89RA7Y65t?=
 =?us-ascii?Q?wjXHdW6RSelrWQcAa+5J8YoK/xWSxKVJIJW2wubx8/Quh1PaaeFiMRIk60zx?=
 =?us-ascii?Q?gufcfpRrk8uic+mEwcIDnsGdaYDH5TaW0Pk0F2ceBZYAf92Y4Rpjz/U3bIWo?=
 =?us-ascii?Q?QaoJXWRcdGOoOEIsa5Haeysp1iZPoiYWMjdHuLlIGbY8LQE4TbLfarDId8fu?=
 =?us-ascii?Q?uDuX/vLTRUvrK9NIvbNGvka3ACS9xy2ecXA1NiwR4qTHDGA0UEQ7h10Dc79B?=
 =?us-ascii?Q?bVKHeuJHgO+bRJVp5kJaEuhA09MgKjbj0msNrkn4g5PGb7qLUuZt8f3Xmd8d?=
 =?us-ascii?Q?k8myA0yVZnq5RXYip/oUFwNoI0w45HwY/bfYM1jmswZ7gTurUO6gxIZ4F//Y?=
 =?us-ascii?Q?6H9k3YD5yNGv0L+JR5cKZlLARRu9pC3tV73HBqYHcGaYJKBt3ujqgYRNR6F/?=
 =?us-ascii?Q?O8l3xN66oKXpSMdQcABRU5qW2cWHm9yVyrV2l0ReLv2FWt8Wt33DZ9fXM3mq?=
 =?us-ascii?Q?05l1wJN1qJt3cU3VSYylEfbu7RsfMZGKDFyssgHtQbkajhlJ3z8hG6ASBN5M?=
 =?us-ascii?Q?m/HZTxgE6jx5H2jRUMp3+YiFVwId270BSRazSwyfuZhsaZXv54+kbPd26h3q?=
 =?us-ascii?Q?bLQoPNy1FRpOx+j/CfenSkfYB7oo52D3XRZ3XOL3C8kJQK23NCRGvJ9txhrv?=
 =?us-ascii?Q?EhHq1+Z3bm0HQFz/hQ8nHdBwJ3avDBkVSVPUIHCoxglkjwhkiPxGS+PA5e9i?=
 =?us-ascii?Q?zV3aNQ0XsIhPBNJzFzMCIQmPt6oIzdsBAceDgpUe7jzIJfsQ+8V8YPUI/Xs0?=
 =?us-ascii?Q?lyQWzkLExWHF42TbYsNRn3TwwTOD2hbzBz6yzLsMeC8vnB43iqbLH9MBUazD?=
 =?us-ascii?Q?BdATDCOZeVPuP9fFntVfsZ9YKI15RD5yGsfuWs6TesNlGRz0sqxozXK6eO4Z?=
 =?us-ascii?Q?CR/96T3GW5c98o/JpSwbIjUbVVL+OOe5ZRU5Ga8UQJLf4WeSjn9DegEqLSnK?=
 =?us-ascii?Q?SX0idhJl8mIAxHRBw5uN9tQyvS6kWbx0sONggCO6h1FpWl9EOTuWocijNvDQ?=
 =?us-ascii?Q?o2rsEDRdM8WqPxByt2Ym6UgPoxmrXETxO9cTKOBYs7YmKvh6yQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cGVrPkKklTEghKOExLt4QtXeBZrrM4EqpYqHTFhXDjWZpXo9fqox3zlaOhEc?=
 =?us-ascii?Q?p2qJcTQgzHk9E9wb2a3hQnr3zs9Ca+9PU/YfpH/DBpcfgCPfjD7eJlflSPw6?=
 =?us-ascii?Q?n0SeGIiFcGe5MuWzXM88MKgorNAorCYmx2ivoDidUeAqgNzx4p3ZKLwDoCKC?=
 =?us-ascii?Q?jp0fbuPKYCFWHJdthln05JfK2Pb2zaK+ln1lKdB7lOBd7KZdHvIVzF+g8l7O?=
 =?us-ascii?Q?tqh/h3lSLLFPUe8wZX+Tr7QTLWEDUmSS/5uRHCzV9hYPRYVFpBbrF+jp24CT?=
 =?us-ascii?Q?r82FYN1quMqR5v20z8qmU3afyI9CK1yGxjp3CpEuCuTPKU2dVW4Ul9J5lndG?=
 =?us-ascii?Q?j8W3tVqf8c5ASKrEgbT5Ksb6vl68NHM4hJKaCkw/iGqtvGX3BsPXTqb/dS/2?=
 =?us-ascii?Q?ISWjRXDXR3oKqtGWf3N6JJkCPDhydtD1FlzlVVEmsmbo3Z0OSL372aAPpSja?=
 =?us-ascii?Q?5ldrdCcxAOjLpTSNwFGi8oQcmsg99H15lHkuRHroihtIKZrzJzsIep7OcUYm?=
 =?us-ascii?Q?M2Bfalt4Veg9kPnGMsoYsfIYxNgH13ggBq9I4hOIqldTlt6Jol8cwNVbspRY?=
 =?us-ascii?Q?esSOBGzkU1bvRHZ7Zw5kkRpKJZci5LIMI7Yo/bWKFFAL7UTjKD9ETkIB8EeK?=
 =?us-ascii?Q?xVL8T7vJQzU20pBTSMfEdiMg+CIWcvqGwBVqpRcVpxajZ1O3lWM9jSAp19Xj?=
 =?us-ascii?Q?rFf+HVbVexr17/Hu/B1+BHw93ud2+xTfkeOIWk38ucSquHz6PN/f7L2YEuPW?=
 =?us-ascii?Q?qBLHkxPWrbDKw5a3n7FDMJFdzg/gNDRyzbqKpgOimVfcngXk/0RU8GD2rYDc?=
 =?us-ascii?Q?r4zzWV4IfD8qiK2IjHsgpu3L2GG5qvjN5tOSWt+QZ3JFXnSu8OP929XVLKje?=
 =?us-ascii?Q?10Gpm7wN+VJf0yALvh34DG6JK7Twfq3MXzESUKKvmCVheFIHsWYi0gf0kedK?=
 =?us-ascii?Q?Uv41NFmRXv2K8WDanDs/m8Kb/BItt9H5XHHHJDvNS1t9tWftahOXYOwwwRIG?=
 =?us-ascii?Q?pdsp78RlKQjHYbzDO/qXcuQLJs5lpX8U6B5l660sjusL3d6FliInfnXuA3yp?=
 =?us-ascii?Q?0KE6v7ECNBtIxIP1ZzkVQ4Syaj14MKaIVpmnfSv7kTmFG/vZFVwOop8W++h3?=
 =?us-ascii?Q?+8TOnlDjqF54Sgx/EBpZDCRa50I933eNBxqwWiozKhNUSo33xZcjaZU552DX?=
 =?us-ascii?Q?TJ2v5CcsGtcSV3lBFxZmuI0RHyYOAwDB6WOiV2RQ9Fia0n3HoBeD0CdYi4YX?=
 =?us-ascii?Q?iyVZd/9yX7ThSYlREil82xnsZt3xaFdiTeWXYkcxy2x6U0knDmNikiLTWZAB?=
 =?us-ascii?Q?gJqoaXGe7Sg78YOfrES/hkB3yfriPEiAdHS+Ncqk+C+ueF7GiWf9aTuZMKuP?=
 =?us-ascii?Q?jGtTqLqToxWJnZyJwvIAMYOU7Oz9XlmcoUwtJzPVlyUjM530IX1vGEJBZ1AS?=
 =?us-ascii?Q?nyBLCV1rpaQccvImYNW7aoDCOKXpw4M/EAmuvXFC18R8szfJG91xf3HhmX6d?=
 =?us-ascii?Q?WR90wkWI3YxIOln2vjPIlodcRZaRXC4FNT8jIUWC278/Snbgc2Au/qO8B/Lu?=
 =?us-ascii?Q?/GQ4t2sgMT7I2ysPcrI+9Qzsh9GQyvYUUMc0h/PY5UY6ec6ndOXd59yJLk6H?=
 =?us-ascii?Q?Ww=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	pYBbZZ6TjeYKiW8mGOEyeIGeLxvgBhSkDF3h3gajV5kuD6u69P9Bsk6XY+kLfKRVQxWgJISpn3cseskbY/ChvxsUDJh2PPHFO7ruSvYcosW+pGfpUxWd3A3r71UZQpi2vVkuiKVe42XTrD6ziCWb/cr047mgs3eU04i+3V0faYveMm89UFhsHSUr+IhX8H6zXtUauusCPVlsUc4LXXBLDguqO1VQk2xgrrKPw8iF/JJAeMNYMZS6TEArommjHan18YeUUEqgdL6tQXqXZZCuZJYi8ysNPzOKf4jVFJvDPBEZdbZk4I5inuONNUhd2eMj3hIfs38jcZnq/w9v0vZJmecBwahbWvmT+p0MlEY+/sIQ5jCTXSUX+s6deznVJ4TNzgun7G+ao8aO1M7KPDEnKPY7H9yyqDNCjU2LjAkzdg+LV7WY1XC82L0Fqtk+XD7kK5v7EhDALPoDID+dXjoJtJctxMqMwmbsfgIgu9JQKmST8oOHZMTNMb1tTSxx2hUi8J5E+gYDUo1GF1YhZCfOzlMClMyavamtaPm0Crxgkmeirt6GLw9V+Fcugxsh5qRHnS03mbdJtHhb4bsLzquUbFcw2YPdukCqgTl1h0j2QJk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b045dcd9-7f0c-4a07-2dcc-08dde63ee7d4
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 14:26:40.8979
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: djPX+92949goFzOQYl23OYBylVFv4oj3LvcLEG0OR6PBDX9/kS6tjYBwV6sH8bINYrWkPmqppNXQ623MzHBIR5r80EUiUFDO07sRb3v6RTY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5647
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-28_04,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 mlxscore=0 bulkscore=0 phishscore=0 adultscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508280121
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAxMyBTYWx0ZWRfXx7o7tltbpd42
 f+nsP6XFTk7CBCMpHQkuWIToo0nhJJQY65f+/yQdbXLq9YDKrJV8ie7OUtkwB3sVKCRJ7XTPvrU
 X0z5g1KawbVSgptNFi/zx4vete0O/sGKQue2T2BppYRp3CAUMHykCWDsihPFAUZFsd7Kh8eosPV
 Wtp1R6kWjP8Zl7YRUIINFnAgPbp99hcbdJVXQCfxRwi2NjhOP0ORUtyI6bwlyhK0Bre2xyk7MwL
 ijGHYAdMXoxmHuLRWvoZnFK0tCOAlb9QnwDhGvED94yLf6H+ByHHE8M8EUR2+7zsJuopVvnDcuo
 lNH6EK+AQwYMxJ2fIx0BGzL5luGzkG2hHFEL1vQ7kHxCsvfg4zexVw/4n15P1A+TVusVBZpGqja
 Pcyns+2sKmeSsdCsb60SUTMA9Md3Nw==
X-Proofpoint-ORIG-GUID: i2yGBj8ahjgvWWiB2BnmajodtLdOpqfe
X-Authority-Analysis: v=2.4 cv=RqfFLDmK c=1 sm=1 tr=0 ts=68b06728 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=UGG5zPGqAAAA:8
 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8 a=1CnO9tvJ3YM9nC-8erkA:9 a=CjuIK1q_8ugA:10
 a=17ibUXfGiVyGqR_YBevW:22 cc=ntf awl=host:13602
X-Proofpoint-GUID: i2yGBj8ahjgvWWiB2BnmajodtLdOpqfe
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C490F80005
X-Stat-Signature: yt98khpyhoemd1iirnz1zo4aoxbg4he7
X-HE-Tag: 1756391222-305685
X-HE-Meta: U2FsdGVkX1+Bk/fmlDwTpZ2yZVzL2X2vctjWjeBfc1PjDZA/Hn3gyn5SqJNtVVGbfGtF1Rop/TAH/IvESFft03+7ZYwRPeRHV89zGjezdbgvoeWd5njzcfDTXRISyx54Zw3dD9C2BFOpYr8bARYOFTk0acuilFf65OMU1v4B7xEybFczYKC8E4/fS5PA+VBvlKoX1PLuJXceALR0rxnsRcHn/skTzJX86heJ1HyRH0u9aOsH9yxuxeZrtkqJNqmaLply/2+vepWNnFpf1hnhMVMQVV6zGHc6qmOX6ipwk234XS3VK3sYq2U7we0vD3aqXFfGGSXZ53CKsau3s0X1i0shNxCVQ4PWCXsFGx/DakO02gyFWYWv7Xl/TVrJ9YPpk3Zg+MFuXIpknfur24cZAANOtCGAJ9FehG3UuhAqrk1ZvBMf6d7HzGt1Rrwe7FAqyP4hlNw4hLJ+1ETnmdcNaMwV0ylA9TSDjfCVoU++4j1fiMbqveQElBl2bUEzKR6X/2phozEbn3WBSKCxSKL72/jF9Fo0M7MmHrSZp+YQ7AyAvtqM8XC+NNELmwVfRKNTsGzHn5Ao4WbaUq1J7ocqy7OfYdAcR9GjexvFrXiu7JcwzPMW9AhS7eiUzLbVebw+eq8BlMkCCBLRdEw0S1NUkdBuVKabWdfNl81sjkXFG40LnLwJduuU4nar8GF/mroOpaEMU11KvrG3OqwIxR8paPe89iUDAqiGvxfcETdCmr8u/udjEXFh4XyyXsA3/RTEPGJn46HhtwNqYtSH8qy9CWgTm7Zs+h3VAb0+9VTe6q7of29Z2ACx9qqTP1opobinthQdye2KfljTTglJh+LRWRh7AwwmgbiGpIvsVjEPYQ/b7VyWcsxuxBX/rbgJg5gBNJNPdBmorkQy2keFT8xlMIgkPdluApXNWOmSdRS3LF8yqO2iKkjtk4uoalEJq0u1BNyrm6niabgJne6PqR7
 ybk1VqXU
 PckKOZkPkkRxmQn3DRX9XdxqbzV+UYm2uCS9sSTucHIQnA8QGOpHfXjkg0qWOEDVYIfpYI0BJKPwzypysLTtaiBqqHneMNQejND+Tfg5OLCSZ2UXrkZC3ehzBgyWf6CeVLoxjJJ8yWUW6w/buRTymS9dnAs6XxJXjCGuPlgallnOniHHl1mD6dxN3l4re3omL9/8uVfBQqDW2ICypzIzOhCaXgVwEQly//KNrFp9Ffn+HsMxFYovr8bTRo0Kw7UrRUuCsT6lvIRGOZKdkYFd53t3z0TaY1UuD5V0yf0kC5VRHO+u69Td+hvfHyhOpwcTxz2XPcAqpI/RgFrsJTRI+JsUo4jlDWOwwRr4v7t3W0d1hpNMeNcJLykME9Lr92OE+v+v1+P38CvZm+ZTk+3diVRVfkRZUpSH0PyIpXzFG/6jYVG4Hr7RAplApL4xtZv8oQ/uBqPKcF3iY4NH9oZ5SpAgqa4gAEDtEmBwy/aozxSiIb2Kkyj/si+BMorjct8dt2QQCbF7DZB7uXR1ZdSNyP5myK8AlUlctUySXJqo7Wvz1rD2rOXCRhUy8VKPq1D6J4ve9KgSOt82uniF6UH8PgtwEzuQiO54Gb9VMp5VKe6eWwNOtRpZmxY/qrL2uFgR2qtQz3igSqUaqnTnxyyZzraNHuohY9QFOhWF8Cg/orAOLZ3j7UhQwVLR5jsMQch//WK9PtLETqI98TAFKd1si8IeGkM+Q25B+d+Js5MDpiyR2ZSdkQPuc7hxZdG2VxmlMhtGASZL7FyOWMP7XM1soQ0pdMWkRtq5llLJU/W9DgeN4NwfPCsbRi+vN5bu8+2LpIP3lN6RmZEQbkzK/vo3SN/lzxM/nk+fQS7jcDaPiw/CtXmGabl9B6X1konQVyxwo+KbhFvvrBjVglqA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 28, 2025 at 12:01:09AM +0200, David Hildenbrand wrote:
> It's no longer user-selectable (and the default was already "y"), so
> let's just drop it.
>
> It was never really relevant to the wireguard selftests either way.
>
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
> Cc: Shuah Khan <shuah@kernel.org>
> Signed-off-by: David Hildenbrand <david@redhat.com>

LGTM, so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  tools/testing/selftests/wireguard/qemu/kernel.config | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/tools/testing/selftests/wireguard/qemu/kernel.config b/tools/testing/selftests/wireguard/qemu/kernel.config
> index 0a5381717e9f4..1149289f4b30f 100644
> --- a/tools/testing/selftests/wireguard/qemu/kernel.config
> +++ b/tools/testing/selftests/wireguard/qemu/kernel.config
> @@ -48,7 +48,6 @@ CONFIG_JUMP_LABEL=y
>  CONFIG_FUTEX=y
>  CONFIG_SHMEM=y
>  CONFIG_SLUB=y
> -CONFIG_SPARSEMEM_VMEMMAP=y
>  CONFIG_SMP=y
>  CONFIG_SCHED_SMT=y
>  CONFIG_SCHED_MC=y
> --
> 2.50.1
>

