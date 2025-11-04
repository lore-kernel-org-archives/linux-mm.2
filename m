Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03326CCFA00
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 09:01:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E8BE8E0102; Tue,  4 Nov 2025 04:01:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BFA68E00E7; Tue,  4 Nov 2025 04:01:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 487718E0102; Tue,  4 Nov 2025 04:01:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3249B8E00E7
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 04:01:53 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BBBBA13ABE4
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 09:01:52 +0000 (UTC)
X-FDA: 84072332064.14.6734958
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3C74814000F
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 09:01:49 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=qQ4GfNYg;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=czparLQ5;
	spf=pass (imf09.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762246909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KPdXOynJKsDeQR3/nSk6C+nJ6ctBGBNSHzO+RF46lVI=;
	b=fEQRLBB3nAxMuLY/yyPDRWjLuA4/617RKFdqNAczzftZIWEB4alfRnvXE8riu8uBSx+w68
	goeXSieSb6jGZ+7F163+YogCck2UrUVMuBy/Ly7iMddDvzcWVGB4fjEHMSxpsDKRQG74EN
	5w+5K+KQF8n8i46jZ0zXeSQmQMUh9Ns=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=qQ4GfNYg;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=czparLQ5;
	spf=pass (imf09.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762246909; a=rsa-sha256;
	cv=pass;
	b=39fZkiiE/Ok/E/zEPBJ2lFtFbtSU9uzxIsMzwKS8sCQKn+8Xfmipw1rJAoEPXjXBzA4SGr
	Zqy2zjTIQrufDhtnJa1MfRIQdmrBluxiKqGP1jgZfVppNnITgI34kAcfodf/T0DgdzeXXE
	0VyKvnCfMhqkko9vgxZb2XSOnQetMGY=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A48sufE022229;
	Tue, 4 Nov 2025 09:01:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=KPdXOynJKsDeQR3/nSk6C+nJ6ctBGBNSHzO+RF46lVI=; b=
	qQ4GfNYg7t4FDO2+AEPRpFt5LlKHft9I91ETpgSrJWovLTdwV6TVkjzvxkHbkxAP
	ZZudS/8WCEZW3TYDZEV0qUCnhGmCGFBpkG93ZvdzbOG0jy2mosdtfL7VJZNa7p/C
	i0QrkZ4HfQcnD2ChqxPWAK9CYro5nRyyyJ+i0VPjO2K8su0ZHB4qrD8koNQb6/lB
	Y9rHL+XAS+gCunHUrMKmVoIlzhEmeLcdPWsLqLYBDr4OjupZjrsEbakICkKmMzG8
	WWLscVxW8SS9mc0DIcw35d0NC7va4CA+jVvPF+QtXvZFufvNtIaT9uAtEpwDxAaX
	t4uI229DADtDMvl695NqxA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a7ecvg0gs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Nov 2025 09:01:16 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A48xUHf019930;
	Tue, 4 Nov 2025 09:01:15 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013032.outbound.protection.outlook.com [40.93.201.32])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a58n9aqj7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Nov 2025 09:01:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yi4CUkayiTF7LtDVLJkRurSrfDtqlQ23Mks4CR8bu6htH42WSBcNDrR5qVN6VYOOB15wtyVtMIAnLF4wrLGtqiSsKXfhF3ppE3fU2XZp75nuUbkIS6gMGTY+pGMtSNyypgm8ZzTSaJydzNIQzX/TikyTA84JRHQd3M8bFuwfzlZV7WdxfA4Y+BKG8HiiVRiID+y9UqH1N0cbG76sztNAKzWv0eRGz44vlnS3QRN7g2Aj8iCrvx/Ui6a9IZ/Lo1lAALrDbakq295OhZltZIKtHfvZD22Fa+mVRtLqonO5mjuFVibpGFOlpYFtV3JHxeur4yrzjPqkx8wP+b0cGUHDdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KPdXOynJKsDeQR3/nSk6C+nJ6ctBGBNSHzO+RF46lVI=;
 b=a0Vbbh25PY1aOeCZfUx79oWVu4J5EjxrFHYzeB1TqRow7hY59G2kMSCcKhBwf2mMjVjM7ekNlNJTCBIoWF1blNW4EDumMkx43c8Yh+GzMfw/Z5nItQ+iLrm063vX6KSnGCWHjbuGXalo+66EumwJ8gzKdSBMqV4FR8FPO8dogp8av14j6aaGXKFEGHBj/7DR50BO1PQZdgHLsho1pul51fswuJDbkS0reENrIbRF60DEgjUxMq4wjKBqmfQ8liChlPgxjhEh/YV795Q2zdlL77c/e/BsYx/fknUK/yAJblwunIQqMiDUTU4JGH7GKI0nHlKNl01j5R7I0KzYv+4IEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KPdXOynJKsDeQR3/nSk6C+nJ6ctBGBNSHzO+RF46lVI=;
 b=czparLQ5NKGCff31Wl+sQ88L9uAkzGzBrc6MEV6X56EaPa9pmvI/R5eeEoF+f18Vm0OZIhPpNvuhFZdPhPECcnkHHItPJ7a4E8n1k2oAVftzwGI8uBLtnphOir1Y+QAIKHFwwwlFW6y+RZOwD5dNTgs2jdJPVJOz9gucm1ZEmTc=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by SJ2PR10MB6989.namprd10.prod.outlook.com (2603:10b6:a03:4cf::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.17; Tue, 4 Nov
 2025 09:01:12 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9253.018; Tue, 4 Nov 2025
 09:01:10 +0000
Date: Tue, 4 Nov 2025 09:01:08 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Barry Song <21cnbao@gmail.com>, akpm@linux-foundation.org,
        linux-mm@kvack.org, Suren Baghdasaryan <surenb@google.com>,
        linux-kernel@vger.kernel.org, Barry Song <v-songbaohua@oppo.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        David Hildenbrand <david@redhat.com>, Vlastimil Babka <vbabka@suse.cz>,
        Jann Horn <jannh@google.com>, Lokesh Gidra <lokeshgidra@google.com>,
        Tangquan Zheng <zhengtangquan@oppo.com>,
        Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v4] mm: use per_vma lock for MADV_DONTNEED
Message-ID: <564941f2-b538-462a-ac55-f38d3e8a6f2e@lucifer.local>
References: <20250607220150.2980-1-21cnbao@gmail.com>
 <efeb3350-fbdf-408c-92ef-c6eada4a5755@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <efeb3350-fbdf-408c-92ef-c6eada4a5755@huawei.com>
X-ClientProxiedBy: LO4P265CA0058.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2af::8) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|SJ2PR10MB6989:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a402091-cbfb-4ed4-141d-08de1b80b314
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RHIwaGxja2xUa0wxS0Vxb0MzZHRFTGU4WFFheFJ2Sjh2NUN4Ym1OZTdqd0g2?=
 =?utf-8?B?Nk11bi8xZllJYWUvQndQRmVkdS9MWitpMWYvN2hJTlRieDdIK3ZoWDd0VlJy?=
 =?utf-8?B?bG9TRC9uYTk4djEwSmtBRkltUjAwZVJleW9vMk1jRmJqcG94QU1vOU81SzV4?=
 =?utf-8?B?REpKRE1XSnQvV1RaaE80d1o2d2pqSVBHM1QxSFJiY2RkNUw1d1haUHprSHV2?=
 =?utf-8?B?ZzZZanBQcHVTdnVJeURIZ2JJdTBZOFF6czRTY1ZBOXJ6MDFXT2VJcDEwcndP?=
 =?utf-8?B?UElzRGl3d0Nqa0h1dkRCczNLK2xKT0RNR0pBb2x0ZlJGQVFCM1VvM2p1bGF5?=
 =?utf-8?B?MnVkQ095YndOYVk4WTZ1RE0zQyswOExMNmdOZmtSVVNsd1AzNnU3ZkZhVXlz?=
 =?utf-8?B?MWZVQlR4TklPNGlkSld5UVZkWkU4Z2J6Ty9oaVRIeG1ESVRSRW9DbmZ2eTBO?=
 =?utf-8?B?bHJHZEMxdnFHWU8wTHlqYW05YkRpNytWNEdlYlZWU0VBWGZndlU1RmtkS1Nj?=
 =?utf-8?B?eWd4Z0xmSnN5SU85SDZJSnNlL0Erc2VOSUg4aWlFbWV3andNY0t1d0liR3Vw?=
 =?utf-8?B?SGxiUmpSQmJ1N0ZoZzJLbmFCcGdHRWNjQ2trQ0ptcWp1dVNTMmRNeWlTbEEv?=
 =?utf-8?B?dXBnQkdpSUhPT2xWck5mSjBUSkFOS3FvcCt2b2xGS0NVbUxHVERWMnBLcHA2?=
 =?utf-8?B?NkpiYStVQk1SUWJ3RUxETWhPd3dTaG5zdnN6MXdjbitacmxxVVd0OHYxT1Bt?=
 =?utf-8?B?aWQ4SHZhSmxwcWRkMFVzVnZnTXdGTHplUTJ6ZDVrZVd4Qk1DRktvK0xJZGtL?=
 =?utf-8?B?OUxDRjRxNkVYL0hwakNvaFdNR3dBemN3d3l4cXBnSm9HQjdvRS9GanFtSVVs?=
 =?utf-8?B?Qy9IM3cvM3Rvc2RydWNPek9DVGFraktWTEN4VjVlTiswZVZ6dWhuNExZQThP?=
 =?utf-8?B?NnAvbDF2aXpOQUFtOHF4RWk5Mk5Kd1U3M0tROGJycTRsbFZZRGxlcnlPem0v?=
 =?utf-8?B?M0E0cE5wZFlvbGlwaGI0Q3FOVlM1ZVB6aXpTcS9oK2JMK2Z3STBZVElLS0k2?=
 =?utf-8?B?L3o2ZExvL2RQV1BxbDc4RUtEbGJOWTdnTXdDZWxPSkF1Ym9jTTNKYnVtdFhP?=
 =?utf-8?B?NDF0Q1YvVzR6SlY2TTlzanRtSTk1WVB6UG1xYjNFeHl2YitSUEl5THJDYU4y?=
 =?utf-8?B?dkpQRHJRbTdFa0FxYmUxN1JJQWoyTnVxdGUvMUhuWGVZTU4va2xPM01tdWNP?=
 =?utf-8?B?aWxRN2o5M3FoMCtGdDlhVzV6WnZrQ3hkWW1oZWVkWnZsUW1ZOWwxUVlHNFYw?=
 =?utf-8?B?eCttQ1RJYXpYSlhQU0tjNXFETUFBWmJCL1UwYW1VakFVRWNsdnFEd1V3Mnlk?=
 =?utf-8?B?L3NXMEQrYlpnL3JiTm9JclIvcGdUVkdiL1lqR1lyVDBpVXRYSVJNaU0rUXFm?=
 =?utf-8?B?ZnNPbzIzTXRnckdKQmVqNG1JbUJZaWYvRlRTeCtMN2FndjJmMXRwS3ErTjUw?=
 =?utf-8?B?L21FQTZUSEN3ZlEzbEdqQmMxdkhzMWRNODVrNWY1S2hDUVNjb2NRS0RJdVdF?=
 =?utf-8?B?aDc4KzMxMDk0VzN3RmlrNjVpZTJ2VktPLzRrQStSMkJ3Ymh5R3JPYnhiNGln?=
 =?utf-8?B?Uk45UVZqQWMxdDVDdUZnM3hzZDVsQVJYM21pSWYzZ253dGVPemp2ZzY0SExZ?=
 =?utf-8?B?WWkrb2k4emYrWDRhVWFxVVFrOEZwVDhYWXBQaVA5UHdmWkFCNVcwSmtZdXJy?=
 =?utf-8?B?KysxNk82OFkxWHBaOHZCK0R2RWRRNmw2SmxLa2szZEl1MVVHNWpUcTY1VWw1?=
 =?utf-8?B?MEJEQkgrY25MWUFaMGtvY1g2U3BkMnJXcDFLNE5WNHdBZUgxQkJUZjkvR1dl?=
 =?utf-8?B?UUhTUUppTXUwVWtORWNDTjRvMis5Z2o0SDVkdlUwNUJyYVNtcFFXc3Z4S2lM?=
 =?utf-8?B?V1FFT2RySU5KQUFHNHQ2N1pvaDRFTjZpaXkzSHVmSlNqVmtEdDZ3T3RvbkZG?=
 =?utf-8?B?Zmg1WGZoeFlRPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VFUzM0xReXBtYTV4WVhMOWJBam4wTVVuMGNDYS8zM2YxQ1liZWRXY2hiTG91?=
 =?utf-8?B?NjN1Q2M5ampYVDk2T3VnS1k0Q1dPQTNJd09yQmk2b09sdlNuWEgzbTM0dFdU?=
 =?utf-8?B?bVVJUzlvUm1HYUJSYm5qdkorakdyWVd6NGFwTmxzS3VEbDhMTnNLY1Qzd0dh?=
 =?utf-8?B?UnpOVGxLelF2Wll5LzY5dTdtUkFJaE43VVZVRy93RnZXcG9makx3VzI3eENY?=
 =?utf-8?B?RjJIM0VJL21KQ1VaV2N6NDdHUlZ4M1l3KzcxL1owOW5JR3pJTWlmREp1bXEy?=
 =?utf-8?B?K1kwY280YTRXRVJzMXdYZEtvampGV1g4cjJlcFlXVDc2NXFzTndrR09BamVh?=
 =?utf-8?B?eGtRcFlza0pIaDBMeHV1K3h4Q25Vb3pGWS8yaWxtQnppaXh2OGRZcEFTa3BS?=
 =?utf-8?B?Z2NEUTl0ZU5uWk1qaUxYTzF2dks4TWp0RlV6Qy8xc3Y3MTl4R05RYXFaTlJB?=
 =?utf-8?B?UjZnQ3NwVWNwYkVBQ0M2c3FEbmtiV0N4TllhT0ZRVk05OTh2aEtJcmZqSWoz?=
 =?utf-8?B?RnFXaFcxZjVTM2hNVHVyUWFsMmRwdzdpa0pZbit6cUFHNHNCT1FaTkpaQlhC?=
 =?utf-8?B?TGtQNlZrUmZNU0pNUFBQSTVabDdQci8vUWQrMjEwbWNtUnFLRWZlUEVMMVRR?=
 =?utf-8?B?RnpsK1YrN2lpUDkxOHh1Z2dlVWl4LzFDWXZGVUtwbUpFd1hVb2tFaVkzTEo3?=
 =?utf-8?B?cU9Bc1pNOUFFU1NHVHVqUFZpNjNoRGtsT0ViVFdEVERxMVRzTkdCMlRxdDJZ?=
 =?utf-8?B?RUZjSnk5VXFjS3lhQ2w0aUMvZjBoM1NEbWpzT21xOW5HSFpjc0o3WFdzbHE3?=
 =?utf-8?B?UFZodU81RFNoMjE1eDVocHFhWVhMMjlHM0Z4SDdneWs1MmI3V241bXMrYTFi?=
 =?utf-8?B?dXNQYTNkUGFxbkhzVWJFdThSZkMvYXBUVXRuS2sySVR1WXdZeloyenZFbWtu?=
 =?utf-8?B?QzA5RSt1UHRqSmYrSTE4bFJRaTgrcWJDT3p4ZmhWMzNBUk1PWktoN3gzb1Q3?=
 =?utf-8?B?b2FhZkl6OW44Uzg4UWhrU2ltSkkwYTQ1MDBydXduZ1hwSW5FV0ZMcThVb2Ur?=
 =?utf-8?B?cG9iYmVZb3FHVW95Rk5CckQzNXJsRVVFMnpMdm5CUWZOdjNaK21ySDNaZDNo?=
 =?utf-8?B?eXdkeG1kTmZySkVwNDhPalRsMEk0WnczNEYxNzNMdW5HSFl6K0IvTTJOY1hP?=
 =?utf-8?B?WDlESUl4STlQcldJZm5xcDlaTzJDNmRwNVV2SWNGNTUvOXBUVHRwUGVqY3FE?=
 =?utf-8?B?cmU0ZmN3c0hyMWx2MHBqV1JmNUFWaUdDWTVwZytlaEtkN3FQanU2MGJpKzBi?=
 =?utf-8?B?eXhSekFld1hIejRYdDQwTGV5NFZqd2RvS0tPSFBMWU15YWoyN0tFODVMbVNV?=
 =?utf-8?B?OVY0OUpWYUp0TmhSYTliQ1FLdDUwSjlSTC9vZEFyNHp4NjdrdWQ3dWVLclZU?=
 =?utf-8?B?Z01DNjJkR3BpaFR3SWkzNlVSdDltRXBPWDhzZndLUE15UUpzZVh1YUptSTF3?=
 =?utf-8?B?c3RtWTVFZkJGYnB1eW5KMG0vL0xJRTc3Q2dTY1RKWEo2c3ZKZVZSZFdvWEVH?=
 =?utf-8?B?R1daa1dUWi9UMVhUYnhWUURYV21XS0VVRFdZTmZPSWp0S0pDekRPQmUrRStM?=
 =?utf-8?B?SUlMaWRFRyt5Q3NVSHJZazhPOWNqd25BTFh2dG05VWRxK0ZiMHRiU1AxYW5K?=
 =?utf-8?B?NVR0TElNdGVkUmYxdzd0MlAyd1FuUTZWSGxNWndiR2s0M1ZNVGFJQVpSQVpv?=
 =?utf-8?B?RjlKWWdjZGVSMEZ3ODgwZ2owZytqSG5SZmJFNDA0YTBjWUN1cm1EcVpENkpB?=
 =?utf-8?B?eC8xOEZBOHNtT1AzeDBSVSs5NTBqbUx1YW1DdTR3bWpKT0h0T3RqS0toK2JU?=
 =?utf-8?B?QUszdTJkRWk2MDJBeU42OTNZcVZxY0lpK3J0SzQ0UWt2dEFrWWtTVENrbHBQ?=
 =?utf-8?B?NnJVZjg2VHF1RlhWWTgrQ01vV0lTeTREQTJmUmVEWDVaektQSmZUYVdudHJo?=
 =?utf-8?B?Z3ExeEtpNU4wbmwydkpRU0NQMjVPUDVERWpaczQrQjdSRm0rVHBzZXJsTVlS?=
 =?utf-8?B?UlQ5VnIyYmppTUxIY0RwQ0FDdVhrRCtheDNqYUNLdWI3ZmRYVlkybW1oZEZ6?=
 =?utf-8?B?VTc4VDFrcjVFb2pRWXlIQjdML1lpUHNDVVZ1NWxnV3JVTW1POWdEdDUvMDFv?=
 =?utf-8?B?K1E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9dkUX1w32Kv2YaNcbqjMd2ok1LANfTHXmSTyG6nNjjKPfxXil6hLq8WardAiLSq+D1VOcsxwmVxRN/DCpOWT6W4vaFpQXFQRSov0vT2Atm49fP20QRiI/rlijQNQmlSHD1lqim/XiI2AvYLsh+VsyJOszW0hwHUiuYIYwQvHZAJRnwurqeuQeikokJa7HQfhVDqS3hFgoj7z1kI5YQiDHKLddgcQoSo3bfUl7Rq5FpazbYu2qgyYLOTStmZWYnU+mxSCGKF+MZf3QmUHgTVBNynvt1NKo5SXPPziz/RvREdcP7KjBpvft9QqN/eb4DkSd0PXbRy6kggye5WEoQfZAxMZ8XjalmnqGzyWB0RMjiK4liPyI6PirAAEW8hlRV7i6dPmm+XOQLQDdhDiO5hRB67qrvzhIowRe//xkP0k0J6OC5edD2oCORIQQFohra37BXyWq2T2jktOutZUR9RrxSXfjRv4QcX8H9t3/qUQzVkw8C85hjfzcrE6irj0sVRRoTtnXhl+3scW4xAqenEe1+76VWj5B0vLodCrqWwtbbnkj9CXl+ine1XUe3wCgMQeR8p9f3I2eN69gthyupotNxfyXjGupASGhRS1zclabDw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a402091-cbfb-4ed4-141d-08de1b80b314
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2025 09:01:10.8661
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DDVjPBATjM5LFVNxPVwnfM/Vbwxzc1k8vDFyQalM+fd3/RREMRUC/c8J3J6fkLbD0J/YfMudRkJc/jFarWz78shIl6NcDiRccp7NHARuinI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB6989
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-03_06,2025-11-03_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 suspectscore=0 mlxscore=0 adultscore=0 mlxlogscore=887
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511040073
X-Proofpoint-ORIG-GUID: Z3pMT9MSabOuTds03RkGyiQXsSbWzHhR
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA0MDA3MyBTYWx0ZWRfXzhAusDM7LWXN
 CD6jvyey1O7e6jkaN1WcA421e4DeIHYQyPRjtrZDyPbbaqDsUEvU26NrkzEpvTf7w3Hxui1cQlH
 RpWsRADBJMSMBC8V5PXB7hBe2AAYLf9lP8g+Llo1xRQGhi+BvnCwovIxzzvTpgy8Qn3bEshfXmc
 3zNsX8CVuC9vMIg36Y/t2Sfic4Y73/oAX6nBtDH6Fv+xMAjar9fdZeJtQVtTUYZt9JJs8XHZ1ZX
 +dyJMP4uNjmb0ZKoCl6Ssrrc2mv2/MbUEa6/SZMDAQk0nIzH5bcJl1FrZqGNOBWRMJBKUNU86zl
 hIWMHq/j7qNZjkhSdjsCxWXU0pp6KKBoKvidOs/VgFuexHYDpxySmfrJ4DCRgciRJ3NlyhZOKLi
 Q9/LrSa0EOiI+AKRixHoqY7aDXSquw==
X-Proofpoint-GUID: Z3pMT9MSabOuTds03RkGyiQXsSbWzHhR
X-Authority-Analysis: v=2.4 cv=U/6fzOru c=1 sm=1 tr=0 ts=6909c0dc cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=jWP_v_svwnqAmsBH22gA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=2jmYF3J1Y9AA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3C74814000F
X-Stat-Signature: qhtuoinan3gohcwfttwoiqmgec4rrkds
X-Rspam-User: 
X-HE-Tag: 1762246909-848880
X-HE-Meta: U2FsdGVkX1/fr69fvzDOgkqE8stNr3H1iUQ5/gvjGRpnI8bXt7+JBkDqdFDImV6Q6u9t2lwLyFYFJNSghEAZtenkwLFlWh48+ESI0SfjMkOwZjFJAuzayALtDq3fPvVbqAjsfZ78fExSW6GtyPL+LeX/TSmU4DYRg9H7ahUqZ0jl8DwosXLEpzrCpQ0d2H+fgNKuJEwnuHOjNcHy2r/9RNBr0eL7bk0FVcP/eeGHInVSl9frJj6rs1D+KyXUeIbGz+heb/7GDUBVa33QyEvXiT/uo2n3lWU3PPxYFRY9zIveRtQLWC+Abiq+IfFfquzn9WjZxG9uhh9rYeGvaUActWeM0t50fu29f9Bd7oHx/pq/gQfT5zxzlnu9om0kIwQE3p7qy+j3kqIQHDdwdxyMu1XfaKBYesGlO30t/fl++xgL13i4cp53654EJf0POFH6o0vhLNm4mQS797W3ty6aoFC4xWD3SDdQrM+0k3MkbdJg0pc/3N6Bu/L/d2jMsa+68jbdYAVyUKjiIzoSgxv3nYGIZjbHA4C4mywtjIQVBskLwpS4SLFwFAM8cOXJSXpf67dOkNcRIBXpw5rr0g0DUN/HgEZPtfY2rak99tG9Kg8u+iyA/DJRIUYRWgt7wXo7Mu+YO4sJBmKtmsKMUytaOkwzIa1vy1+SRPqb1+LLDQ/WF/qaixHSJLIbdTiM/EGXIfNdcfG3iUXDHLOyo+62Xyn0qQFiqUdTpWRMDxNZW+4YCo35XMSf16K6aN6fSa7nf15ztH0y4VD6GUbWN73R3kmNLEgOIMNzpAD9PzLb8eFQTLpek/g8p7ehlV60JQg/8TuWnZyp/a2VCZfTU8iLIb2/QH4CPolTuOy7QlM/CgFUzOyLUjQyISwMc5DCBTqORCi+aLESHDSaACzu3CFPUBExWHUyMWYRw10LumKVDPVHzRLnR2gOft2pHoZWaEoSBA9m8MiaVs0LeZ6vP7i
 uXjdZNNw
 HZ46RjG2fnKEzy9rMPOHmlJ63reHmYDyX4i9oN+i/yoJYVbMseB5lwRDFAzdG4HISyoq9BKVx+NGN7HPzHwIWhzX4EH+lDVfSPLKHlOXabarPZV2P5a3dB7Q16fXpFuWTea3PCv95tk6lI9Y8UhRD8HNvRuRzZbp//FqBYpSMGcivzX8G7lppQ/DitBEfYmaHvW7hPqwaCr9KsMg/9ecJEdI1107UI9Es6wW66um6pXWcIA7+TJXZyjVbEfgNhU9oyTG/z8MFaHH2JJFzlULXi/Kx/IjFZzo46KKMVIGgFPUpB6RVXGWhQefiWCtEoeVC+XQ+kO5CxrpamjMAKXaFiLWLhuTnloDFRxQsvQSvcvjC7C6LHqKOyehmUQIdImnSvB58cWEHTckgs6PKMMhWHLmWYMwIqucnj7VQ8x1HEBxp/OdYjOKJZxR1WrcMFpYL3D1gGiOtvLNIiaCghXHWmFIHZN8NU+dFyRvHxhlYuGH7Mwxg6joQXL4ffArt9KQ+iblF3qmTal26FOURfTiCApnoHGu8s2A5IOF49C0sj6qgoIep3MlHRRNOBOAiqs4w7JqtOEukQEm/d4JjRlKMm1gfWG1/ebk1fRGbjOfXBrD4bmAVgAWAtJ6+mDlGvmR8J9AFFmM2u4kclprl8WalLfrAiZjMweAcvEqmpPetLsYXPsnpwFBqMQSL4cdFoCfY/fvWIaG2++av6DZthek9LZUpjqhcyV03SOGQLnJU6OfGd60=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 04, 2025 at 04:34:35PM +0800, Kefeng Wang wrote:
> > +static enum madvise_lock_mode get_lock_mode(struct madvise_behavior *madv_behavior)
> >   {
> > +	int behavior = madv_behavior->behavior;
> > +
> >   	if (is_memory_failure(behavior))
> > -		return 0;
> > +		return MADVISE_NO_LOCK;
> > -	if (madvise_need_mmap_write(behavior)) {
> > +	switch (behavior) {
> > +	case MADV_REMOVE:
> > +	case MADV_WILLNEED:
> > +	case MADV_COLD:
> > +	case MADV_PAGEOUT:
> > +	case MADV_FREE:
> > +	case MADV_POPULATE_READ:
> > +	case MADV_POPULATE_WRITE:
> > +	case MADV_COLLAPSE:
> > +	case MADV_GUARD_INSTALL:
> > +	case MADV_GUARD_REMOVE:
> > +		return MADVISE_MMAP_READ_LOCK;
> > +	case MADV_DONTNEED:
> > +	case MADV_DONTNEED_LOCKED:
> > +		return MADVISE_VMA_READ_LOCK;
>
> I have a question, we will try per-vma lock for dontneed,
> but there is a mmap_assert_locked() during madvise_dontneed_free(),

Hmm, this is only in the THP PUD huge case, and MADV_FREE is only valid for
anonymous memory, and I think only DAX can have some weird THP PUD case.

So I don't think we can hit this.

In any event, I think this mmap_assert_locked() is mistaken, as we should
only need a VMA lock here.

So we could replace with a:

	if (!rwsem_is_locked(&tlb->mm->mmap_lock))
		vma_assert_locked(vma);

?

>
> madvise_dontneed_free
>   madvise_dontneed_single_vma
>     zap_page_range_single_batched
>       unmap_single_vma
>          unmap_page_range
>            zap_pud_range
>              mmap_assert_locked
>
> We could fix it by passing the lock_mode into zap_detial and then check
> the right lock here, but I'm not sure whether it is safe to zap page
> only with vma lock?

It's fine to zap with the VMA lock. You need only hold the VMA stable which
a VMA lock achieves.

See https://docs.kernel.org/mm/process_addrs.html

>
> And another about 4f8ba33bbdfc （"mm: madvise: use per_vma lock
> for MADV_FREE"）, it called walk_page_range_vma() in
> madvise_free_single_vma(),  but from link[1] and 5631da56c9a8
> ("fs/proc/task_mmu: read proc/pid/maps under per-vma lock"), it saids
>
>   "Note that similar approach would not work for /proc/pid/smaps
>   reading as it also walks the page table and that's not RCU-safe"
>
> We could use walk_page_range_vma() instead of walk_page_range() in
> smap_gather_stats(), and same question, why 4f8ba33bbdfc(for MADV_FREEE)
> is safe but not for show_numa_map()/show_smap()?

We only use walk_page_range() there in case 4 listed in show_smaps_rollup()
where the mmap lock is dropped on contention.

>
> Thanks.
>
> [1] https://lkml.kernel.org/r/20250719182854.3166724-1-surenb@google.com

AFAICT That's referring to a previous approach that tried to walk
/proc/$pid/swaps under RCU _alone_ without VMA locks. This is not safe as
page tables can be yanked from under you not under RCU.

Cheers, Lorenzo

