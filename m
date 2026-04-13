Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDE55F531D7
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 21:33:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C78106B009B; Mon, 13 Apr 2026 17:33:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4FDD6B009E; Mon, 13 Apr 2026 17:33:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3ED66B009F; Mon, 13 Apr 2026 17:33:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A20096B009B
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 17:33:05 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2F1C316015E
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 21:33:05 +0000 (UTC)
X-FDA: 84654833130.21.C247E96
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf01.hostedemail.com (Postfix) with ESMTP id 73EBE40003
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 21:33:01 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=mZ7ejmxZ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=W9Kpn7JG;
	spf=pass (imf01.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776115981;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7c/h1lkaZJyTh3z/0iDBCTW07EMpXGp6O2Gu78v5J2s=;
	b=LCRwxlYxatBSJ941arAn8h20uACeIWP5ST5oToNCxsVJ80PbqEUFlBG9O8eLi+uwoNnIoG
	k1yOwCbszGHpDWR6mzWyoaxTNlWu+Ikixl4o4WVxEI+hrcV3yEtvTEgDVNN+BMAl2uj/2k
	tyYXI2wUzNFs7/w2O8WAy+WTXHhUvds=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=mZ7ejmxZ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=W9Kpn7JG;
	spf=pass (imf01.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776115981; a=rsa-sha256;
	cv=pass;
	b=txP+zGLcaFhjsxosJFI3pDHi7A47ATNYphZ7NsmXk/fSfoPRsCxxzP4iEGdCoPiRPzSrQd
	QzqE6okpwR/e4eJYcPmEDv1y4ngoVnJhhIgbxqVt+9X/h4m1587L2IIFQmDSZk/Gs01QgI
	EGQUzkBMFURfdMDRhyJ/vTQTL6qRURc=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63DLAjHv4056462;
	Mon, 13 Apr 2026 21:32:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=7c/h1lkaZJyTh3z/0iDBCTW07EMpXGp6O2Gu78v5J2s=; b=
	mZ7ejmxZ2N9bgUrSUpdZ+2+lRWsuQhMDQZljlwNPjEMdTJpcLBnsM3Q1xiLOnc/h
	2rKkaKIgeT0GdsOVvtdJ6lGxvcdUBe9r4EhnaqybmIm4vQGjvO0ev5L5WbZ4jedl
	CH8vjfdDakUD29Nz5wiLRqxoZVvzmC17dohOpZhDqXOeEIizptg2FF/fZht0xvIS
	yvFr6DlsXA5CIhT2XO4uszGPh+DdASIJxz7Vf79b+3H1M9lzX/Uxw+5e8UthFfxw
	ipyEzRVLiolMKgTuFJq0Svo2DKZOYrfr3iV43JFSc25/Bslqbp086CMhUil8wmUv
	SP1GzE3DOJZAzfFSmtUVpg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dh85q835f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Apr 2026 21:32:56 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63DLTPpQ004162;
	Mon, 13 Apr 2026 21:32:55 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011001.outbound.protection.outlook.com [40.93.194.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4dh7nkjxpc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Apr 2026 21:32:55 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Uy+gew4V6JMab438FAdPnC32nUsV2m67tN5yOaL/EEBuJlzQ2C1HAjWO/iWuLPmvIGLsf15uh6ql9llDQAKrrCQG3639CZV9m1woFlSPINXGlYllHT8yq26jmV2ZSTYhH3e2a+nkOaE5BUNNGNvNZ9IrKQ5II8A6I/KnlMh3Up/Yg5v7R9S5GbOTCeBs8FgkqOZox9xDh1mnweOlzhyeLENF3foPWlqabfcVdS89oVJ+MrmtgowJB1grbFxrMEdkXVqm4OCV0BUliIy1uijWBM9XmKA9cpcXJkiBtkSnBlDGuGgowueOqQuf2KBPtPHsBoIqxnhLfYH4JLRluURKkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7c/h1lkaZJyTh3z/0iDBCTW07EMpXGp6O2Gu78v5J2s=;
 b=HbSQV3X8qrvGeme1Ghvn8MpnfB9O4ysqsVmbD0AjX72qI+bMPl7k0ZSu22UYQzwvZLylBCkB/79Ic6Ys1m7K6d9TXLc45qTDcLRMUzB9HawLoUhiTdn0PG9F2XOuUV8fEF+3m4svJrJzatZsTcLnNhGjGm1WtJ8LfjUkrV8eJcDu5leoIiLsiVO10fc8IZK6diSEln96d8rPT8VMXBhTNbYtU166axjY/F+3QcCRHuIpERf4qJ792+Vxs7xfaUq2GgNTeCx1w1ekClJ+rUVhn+nCOLyqbm0ZRva+4L7FDAEekEAnztsQghtI9sFJ9ID06ttYJwq0kfy4Fz8twRo/NA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7c/h1lkaZJyTh3z/0iDBCTW07EMpXGp6O2Gu78v5J2s=;
 b=W9Kpn7JGEUPgOZdWk0Pi2nM35osPx6U887Dz6cU7PqV00iNVOFzy52K/rM19pgoadigshiNs5EspiBYkYDuoT5YgZEnk/UCnZCw94BwKmM5yDjs7ARx2WtUdO36BsUTpZc3FTNP4jo5+SevZ9rx/bztBPxoFnXSMMsVTikOXUTQ=
Received: from DS0PR10MB7364.namprd10.prod.outlook.com (2603:10b6:8:fe::6) by
 CH3PR10MB7630.namprd10.prod.outlook.com (2603:10b6:610:178::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.48; Mon, 13 Apr
 2026 21:32:50 +0000
Received: from DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::a4df:c903:e1aa:322f]) by DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::a4df:c903:e1aa:322f%3]) with mapi id 15.20.9769.046; Mon, 13 Apr 2026
 21:32:50 +0000
Message-ID: <dde32efa-e02e-4e44-a705-f558e0caa869@oracle.com>
Date: Mon, 13 Apr 2026 14:32:46 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/6] hugetlb: make hugetlb_fault_mutex_hash() take
 PAGE_SIZE index
To: Oscar Salvador <osalvador@suse.de>
Cc: akpm@linux-foundation.org, david@kernel.org, muchun.song@linux.dev,
        lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@kernel.org,
        rppt@kernel.org, surenb@google.com, mhocko@suse.com, corbet@lwn.net,
        skhan@linuxfoundation.org, hughd@google.com,
        baolin.wang@linux.alibaba.com, peterx@redhat.com, linux-mm@kvack.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260409234158.837786-1-jane.chu@oracle.com>
 <20260409234158.837786-4-jane.chu@oracle.com>
 <ad0rUB4FuNUOJ1pN@localhost.localdomain>
Content-Language: en-US
From: jane.chu@oracle.com
In-Reply-To: <ad0rUB4FuNUOJ1pN@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0P220CA0008.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::17) To DS0PR10MB7364.namprd10.prod.outlook.com
 (2603:10b6:8:fe::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7364:EE_|CH3PR10MB7630:EE_
X-MS-Office365-Filtering-Correlation-Id: 75d8074b-0a3c-4b44-a474-08de99a43648
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	5tRdedEkZCNITJnhPD7jmX2g4hM46p8vkL1+JctW5ZUXZNNc27ef6qCDas69lh8BeMXl//MN5rv0ZozVg33wBd9k6JRHmCclMTLiJItooC9LqRHm7Tj8VzBEGgncMOzSc0q/UqQQl6ArQlf16UWjVa0uQFTsMTGjm/D9/5SvtIv7c/FpQu6FTlVxIiBXVCEXHUooVecCtq1Z5ns09VAK45q0bGTiGDGDchY1y9PIdYTO5Cc+RwbAUPxbR/hAgITHVuotPazJe9KAEgt4LxJ9KFgjw5SmDm72Iof4L1P3711fgRg2XFH4KQvh5Ri/DWyv2BXRBViW+3FuG69dwIq62Dvh/jAPqoxNYCiaOpOqCCkEiK2uXPC5VZ//xFgmdo19wuThALgZuUix5rbhbmBcbTszgAGWoABk9xzhFi6iPwSL6QKga927ZKDPVs8Bh50HZghx4VkP7uQYZqQ9TgwYPu/zwk/dx554ngfdV2h1K3Q0J+nhWaYlwVEQYGUIxrfDlzS2gy1ceBXUTmT2wLCYFRdl2Uugi/zUEM0ZryPOfz0UaxT8XWkPGd9Xlit4RLOVLMCCna2B8i9JqMVOiLgM6cJ1fykZe4iHXZ97YHuYRfXfSPOaQIDyidKeYkz9xrXD9KkWhRxOw+3rh52a45mGZU7DXuxO9tgyaXSu3HQtARjOVqzhbhB39WSMxbAo8JM5W4VaTLjisLzV+4md3ju5nVK0VE0eyAsiNuYowjbiV10=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7364.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Y05aYUV0VDdKRlJLTlgxdVFwQ3psQWh3ZVBYWmFsc0tHYWpCWHNFRjFmYk9E?=
 =?utf-8?B?THlRYlJNTzQ3dUUwT1pQZllHRnVVdFVNSmJzUGlBVGhpZFY4UTJ3clR6SXlp?=
 =?utf-8?B?TC91eENRbUlEcWRZeTNnRlNqeHNoQVl1QzVXZzZNMjZoZWJRYXdydmFvaUQ2?=
 =?utf-8?B?QXR0YVZaT3VoR2ppRjZ5cEtKQkRWeHkyT3VRVjZRbUtxTHFBdWJ4djlzd3M2?=
 =?utf-8?B?L0FRN0xudGczMWJueWF1dkRpV0M0WlpWZDV1dmczMjRUNmpjOUxRNjluZWxp?=
 =?utf-8?B?T0VDeHQrT3RRb0QvSm0zM3Jlby9VL3Q3VDYxTmtzd0JMWG5jVnp2S0EvUFJP?=
 =?utf-8?B?VG5RSnNPci9yekxjcVlsNFhwSC9QL3F1NHJsYU5nNlp2OHB5ZEM5dXZKZGNI?=
 =?utf-8?B?c3lKL0owWG1Xby9NdHlEZi9mR2YxRC84L0c1UGlRQ1RxU3NEMlBrVHJWTFVq?=
 =?utf-8?B?RFl5ZFh0RWllb3k2Wmgvdk1tZ2dHR1VmTGNoZ3loNHdCeHFObnB2cndnS2Zi?=
 =?utf-8?B?Y3d1MXp1ZkR3Y0VLQ0V3UmYrNm9jYU1wK005M0p1ekNOV0s5SFlHTXA1UTNQ?=
 =?utf-8?B?VEphTmtiZEpGUzhkY1Jsd2NuQ2lXWHB0ME0zbTVYZE13UjhQYktpTHBxY3Fa?=
 =?utf-8?B?OWM5cVV0b3FHTVBYbjFIWWIxM0N6K0lNODJnSVdpNEF6R2lHY1NzR2IyU2VI?=
 =?utf-8?B?cjF6aGgxTmtmK3k5cjBwNFpKRTRNYlIxZWRaQTlkSytDTmNvRythVVJ3bVJ1?=
 =?utf-8?B?TUNyOGlvR2lmWHRYdUdJYzhOQi94TjhtSXJJMTlRZlRyYWRNa0IzaTVsTU0w?=
 =?utf-8?B?WFNiRURlV01KbjBOczkxRGJjc1JsR21zWmRHMWgvdEFhdVFMRmxhaUdITHUv?=
 =?utf-8?B?N2RpOThWOVBkZ1B1cGxQM0NHbW4yR0hVVFZ1bmdBNEhRNXhSdzRUbWhKZHFk?=
 =?utf-8?B?SXU5NkJOcnViMjM1ZFgvbGNYUDNKaVM5cGwvRGJwTjFTWWRYVk1maFA5cjFu?=
 =?utf-8?B?ZDhid1hIaXFYaUZrVndUNVBBdENxSWdyZWRWOXYrSnM3a2xCUXZPZ0RKQ2hi?=
 =?utf-8?B?dU5yclJvNE9GTExGVFByT05GMnFtZmY4UGFJYlVtUXlaN09LbHp2S0pBZGtl?=
 =?utf-8?B?ZG5GeGR5SWJYL2wzcDJUZks4NHBveko1RzJXRnBZaHFiN0dRVXBQT2lTS1gw?=
 =?utf-8?B?YjBJN0FwVU1IR3pLZjVrU0pKVU0vQ3lLaEJKK3d1L1Q5bS80ZndxU29TRTdo?=
 =?utf-8?B?WDZucHZyQTVBSVd2bmRPNFZwbjNBeDdtOE01YmhzZGlXcjRPSVJIc1JBTHll?=
 =?utf-8?B?TU1MV2V3cEhSbnZCRGJYejY1bFdQNGVFajZOR2lrR1pLU2tIdVBXRm9Sc0dQ?=
 =?utf-8?B?THYya3piVjhNMW9Nc1VRelhKdk9XQ2lyWml2Q1IzQVc4SXlEMzUzdEFKdzlK?=
 =?utf-8?B?bEdrS202MEs3aVhkaE51VllmRXJZQllCaHJoNGVFOGZCazdIakVqMmJHV0Qr?=
 =?utf-8?B?ZkIwNi9HWHJ3dGJTb08vSnI3ZGZURnhmMUNJOEh1Z1ZpUVoyMk5oSGpMcHd5?=
 =?utf-8?B?MnBjME9XWVcxa0d6YjVUTUZkK1VwcVl5VE1kR1l5bEV1a3FLcGVmUktKc3Z5?=
 =?utf-8?B?akczRCtLZlIrRjQ1Mks0M0lJNEIwNko4WVFONGl5bVhCcEp1ZWJia3dNUG1v?=
 =?utf-8?B?NVlYQktPenlMckxpN0M5WDJFYk00cHFRemRFbUZYQ2RxRDgvdm05WHREL0lG?=
 =?utf-8?B?L1EvWXNtcmJXL3BpczFXOUZneUk5emdrK2RsZmc3akE4M253RWU5YTU3MDNw?=
 =?utf-8?B?K0s0U3QvL25VSDZtd0ZPQUI4bmhQWW5VNVYwZzhOK0kvTUtDcTJkZzRwT0tE?=
 =?utf-8?B?bm1IM05uLy9wTG5vWXlpcG9oSlNJZGc4WS9Kd1ArU0ZRbjc3REh2MUNjNi9K?=
 =?utf-8?B?VGNUM2tmaHo4R3k0YVhENHR1TjJmZ2MvQmVoNDBWZ0xPZXpUMHJhNmplMGFv?=
 =?utf-8?B?dXlUZUxzQjcxRTJqbUYweGRoUyt4bkNCYzNLODVlWG1OUCtLbTZUUERYdG4w?=
 =?utf-8?B?V3I1d0sya1dWK0Vsam5KWGNzSVpNOXdLTUVZQjU3cVM2V3NsQjZ6Ny9jdXBw?=
 =?utf-8?B?OWNZVFpKeFpHbGNSQlJ2bU91cWtTWHcrRHZEUFc2T2JJRVBWZUVRaXZxbUNP?=
 =?utf-8?B?bHpxd0RNRElkWjNHYnJscFFxWmpDY1dBN2JKTjFoVkVWeW1ZTG14MDd0ZG92?=
 =?utf-8?B?ak4xZHAzSTV6TjduSmZCVG5MUnVsZnZPVkdhMTBPSHlwdzJ5SE1sU1k0czd5?=
 =?utf-8?B?M0JYbVBsRWNSOXVPNjJyRDZXTGF3ZUl3UmZoVzlJOGJTMHZzWER1dz09?=
X-Exchange-RoutingPolicyChecked:
	acYto6lcWGRcWLRp9uKbElqFfUGTqOrVmIvbJnveUV4/tLkmSadbwOg0azaS3N+LeWF2uR3OtMmINEd65sZJfJIYWuMS+srQGFH1lPZq1RxtZlmrU4wWEgw3+ckEFe5S8Y0D3lTgbMV75s4RMp6sRuNizOhJoCk4qPI5BbjXNg+nHC0qZVucMqbTiRw9PpVlSus1YbhKr3UiP9tSD056brW56HzC5C+ANVywjgeENiPwPXJamkCcg5AmAIh658CKRCo2HeMKfsPJpvaKovfT8TSgz2CUAY1MNv7MzfKn4rOmrtzNti3DA40LK1rgYoNYukoxlCQNflSh16jCJxo6nA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9n9q6dirBmL2MJwj6ut6eyUSA/NvqtcrIXGa+h+z85ba0qpoqLqFdCJCvtMvSXzATgzYugolqEm2w8Lu5a9PMewQ1MCeJl7hieHbmLyMW3VDW5pEPSjLfLwpidS9Xf0vACEjAe38mOcBDcl+PYw2xoOPnIQbAXdeSk+ldo/4P6dsNzitxuYgP96NR447ljAS3Ol7kw4qUOxu/PdRQjR4BAq5jhhawcrMenZEdzUkVz061T8kGPFM2B8gqOhFm/SJ2hQgkzPD2Ye8XLlCK1BxV1KsTXiJbszel66W4EIW8k/vsvQq5D0nXeySabWz5aw+NA3ASk4VG5r1zo2XeDWfpAs/B+iMtq4ptjDCw14VHBgPB5rOv9G5Cp4pHvbx1MtBOqsSw6gptJS9P2dS0aC/ATfoPlkilD9LB4zC3Y8qCkqtQGraXvMER2Hcz5QDySmU40lhH+soWYw9jQuQYte31GkyAR6Nr7CyX6N081/443RCO9aCYOV4HrPghVLxXeKApBKM7GE/eYKYhd8p8JUl6MYx7whJ/Gyp3oPmlJ1eisN+Pmur+nIdbj/DcJPqwwozH785AghLkvahABYcIGOnBItm6uYF07j9pyQJgMpC9ug=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75d8074b-0a3c-4b44-a474-08de99a43648
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB7364.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2026 21:32:49.9916
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o8u4QbMizYrcqoDC18bU4GLxf1yxJsJaJoaBcDI4z+e3w3QOAtawS1hktyrC8GSiwTiSqSVBF7GdmQIBSzgPYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7630
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-13_03,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 phishscore=0 mlxlogscore=999 bulkscore=0 spamscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 adultscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2604070000
 definitions=main-2604130211
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDEzMDIxMSBTYWx0ZWRfXwFjR896pZB91
 n2g2L5HNDTDgVCGMdqxvKpk/1C8WPt0X7mwZHwR74q5oS0HN3r6vmPp7ony1kqZId73b5driyII
 MRleTDegJwemYV4E6B/goHPz1FKuwgHkJv5tNx3R3u9GhA2MYwcXWtcmK77IBt1UQ9vlxqf3BhP
 GywAGNWu3rEQHmAysL/47SqN3pK9NBgDynvWYfIkm0RQIrsy1HZZhEekMhXqTMAXiUMZFOZuP/I
 mkVHrP6E4efJT9pHDP/ecyTaAek85tIqu8ZbPLqf7rGAqvbHJEkeUzKqvkEX7Oeg6CGl6f4a1xh
 5MRllgfN/a4hAh1DduFlxG77MEy8rRxC1Z9uZBogYRvRcYAH9ptliYuxaawF2h9yRt48rgtwSr2
 nMD6uDlnCO8KovHD/Ij6A5L26XUi6EUkhf43FHMpJDPeu8x8czolePpyuGMR66T99WiKgPW4gU5
 N2QvQavPwD/b1w3Ztm4hCc9dHvZQgkJqrkRwmGfQ=
X-Proofpoint-GUID: hRZ5L36MB3X_A2EowyEPpM21YNtBZpXe
X-Authority-Analysis: v=2.4 cv=V49NF+ni c=1 sm=1 tr=0 ts=69dd6108 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=A5OVakUREuEA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=yPCof4ZbAAAA:8
 a=n9LEFJtGxd2q4DQI_msA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13825
X-Proofpoint-ORIG-GUID: hRZ5L36MB3X_A2EowyEPpM21YNtBZpXe
X-Rspamd-Queue-Id: 73EBE40003
X-Stat-Signature: woxw7997cooiqepa5bi1uadskdhncoff
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1776115981-824347
X-HE-Meta: U2FsdGVkX1/oKRyy+Dy8At6KWPdwAgqIPqYsDq2yGvRJi7BLX3GVkSv5Uamdg9EsSa4/Q8fAIW/W20YyWG7eqWMrhQ3d7QocUPXrTvgUEp1NhQ+1n3f5wQcbg4ui9I+6pNPcTjozYdb1lPwzDYcr1rnaHNpFOjHb6hJ7gDiBhyp3CJgGyXH5SHHaXRwFy4IGhH0AKua0hHrIvnbFW0dXE31EF1eDqERpyWW2wxSqasmySw1wr7AXnxFNi3T5LfpzHsZg7sn+audacY6w6ARzk3rD0iu5Cwu6xUIGN2UQ8o1cuAhN8dtG1dHOBtE0WTxJFomcGdVnElaP/Un3CFdxOMehD5Y8O7poVpec7rBDlScarICArYUW6RyekC5sSaNWfbbD3suha7q8jyOjSffU9GmBxBQ9O6t+X0WjTMfIrx4o6VPAhZXE/+cIXMzROAUa0wj6Vna10FZF2v+ZdyhPmX9uIUAVTVHjgnDiicuZC2j/GUy37HHRovM19KfvpJmHLggmm37ylRRvJoqkkWI3/O+7jlyD/9sOMoXuGVvyX2EMDArSTRvdnbnzJzrhuoS8GsI2JNkf/p+GlhQZEf0lJqYzhHlwtYhIzXrqUAVpORr+MFmXw8/fjR5NA4EjuD3CuI72XkRtqSvDfOnrCWgu+CNmBvBk21YNIffdI+BqlpA1D/0rc729vCM50Cg//+iiLm/AHAidX+XA30cEblInN8JEUTQ6Xll9xEnAtfGM+1renZ5g5mXJUubVW6JQSurqgfJdssAtN2JW6/T3f6XY/FMFwiTP2tI+HW4uMe8XqzeCYxCg/WDYE1c/gvQ7aqHyF3XOkzY0KUjEPLK4oB6aUSTsk2VvAE13ZHLl41z6uUP38bUwr/pxB7u4tKJBC27EYv1JZQ8jW8Y8UlhkCAQ3ZFEpQMvUHR5Q2hMip0OevqHLF6b7yhXRdHeFkX9DISJg/6GgdXk2MIAPwnWUizw
 Fy2LdGoH
 GjA0//xcFrhdOSaAneS9MNtxUJNnSsmRdYddUb4jm2jT/eddAjX4DGMd9Sow+AK2HUAQdaCUaGIUnobsQuleFCPht3o66PtM7MlTTxzdO+FVW/sp1Th5FGlsqlGQW/FdrXEtoSeAAKKiiRaRk0ZqVozT2oaPEl3TMXRwQ1+l8l/9+q7KJwlwI4f7dAJqaMBQcGhNcAbfBUioWAHfNbfaMRdc2dDDxI4rEPseN1gNuCPvNlyRnDOFEaqXIBhPEaFpdlEa53TnQrFnIn/A34bKDYusSI83FeLyq1BBxHOZ0bmRvk1pZBniv6q9FCsnYIQW4q6tqVkrKM12QaZGyTViAtmyoWagbKqIq4KSIpSxK0N7P56E0nche17MUjtiJCMYKQHysdy97ogJhKgRPqtcZCtO5df3oaj+Yg2lcKVBeKj0mdc/LXGrB72r5Rdx61m16xXY1C3D8xV6de8lUY2cTzeXQb/oGPtPRhIkIzosj4KfKkx3wh0Q0ElYgwR/9R7S7/RDd6KtPcDXoehUKxnAvvooTM/Y4vGnWxNj9zsR1/4ZY1i8e5Pz3NlFntywT0JKGlMr6c2yr7pxefznZyPsZqSW27DbL46utDo4+wwNDEsNhJ9L7SWW4AOwLioMwi4BDr6EPnUibiAPYIEDrsSpxiyYfRiavk9BwcnhVkLuRZHtM7r39yK7KVFpTeyj9W6S6FvK817UuS/2MDw3RJSG0qIWTbSVugBNAR9OmgFWj84p8Ds0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/13/2026 10:43 AM, Oscar Salvador wrote:
> On Thu, Apr 09, 2026 at 05:41:54PM -0600, Jane Chu wrote:
>> hugetlb_fault_mutex_hash() is used to serialize faults and page cache
>> operations on the same hugetlb file offset. The helper currently expects
>> its index argument in hugetlb page granularity, so callers have to
>> open-code conversions from the PAGE_SIZE-based indices commonly used
>> in the rest of MM helpers.
>>
>> Change hugetlb_fault_mutex_hash() to take a PAGE_SIZE-based index
>> instead, and perform the hugetlb-granularity conversion inside the helper.
>> Update all callers accordingly.
>>
>> This makes the helper interface consistent with filemap_get_folio(),
>> and linear_page_index(), while preserving the same lock selection for
>> a given hugetlb file offset.
>>
>> Signed-off-by: Jane Chu <jane.chu@oracle.com>
>> ---
>>   fs/hugetlbfs/inode.c | 19 ++++++++++---------
>>   mm/hugetlb.c         | 28 +++++++++++++++++++---------
>>   mm/memfd.c           | 11 ++++++-----
>>   mm/userfaultfd.c     |  7 +++----
>>   4 files changed, 38 insertions(+), 27 deletions(-)
>>
>> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
>> index cf79fb830377..e24e9bf54e14 100644
>> --- a/fs/hugetlbfs/inode.c
>> +++ b/fs/hugetlbfs/inode.c
>> @@ -575,7 +575,7 @@ static void remove_inode_hugepages(struct inode *inode, loff_t lstart,
>>   	struct address_space *mapping = &inode->i_data;
>>   	const pgoff_t end = lend >> PAGE_SHIFT;
>>   	struct folio_batch fbatch;
>> -	pgoff_t next, index;
>> +	pgoff_t next, idx;
>>   	int i, freed = 0;
>>   	bool truncate_op = (lend == LLONG_MAX);
>>   
>> @@ -586,15 +586,15 @@ static void remove_inode_hugepages(struct inode *inode, loff_t lstart,
>>   			struct folio *folio = fbatch.folios[i];
>>   			u32 hash = 0;
>>   
>> -			index = folio->index >> huge_page_order(h);
>> -			hash = hugetlb_fault_mutex_hash(mapping, index);
>> +			hash = hugetlb_fault_mutex_hash(mapping, folio->index);
>>   			mutex_lock(&hugetlb_fault_mutex_table[hash]);
>>   
>>   			/*
>>   			 * Remove folio that was part of folio_batch.
>>   			 */
>> +			idx = folio->index >> huge_page_order(h);
>>   			remove_inode_single_folio(h, inode, mapping, folio,
>> -						  index, truncate_op);
>> +						  idx, truncate_op);
> 
> Since this is the only place we call remove_inode_single_folio(), and that we do not
> the index (at least index >> huge_page_order()) directly in this function, would it not be
> better to make remove_inode_single_folio do the conversion itself?

In PATCH 6/6, remove_inode_hugepages() is changed to call 
remove_inode_single_folio() passing "folio->index" directly,
thus eliminating the above conversion altogether.
I apologize for dividing up the patches this way, function by function,
for my convenience, introduced some temporary changes.  The overall 
resulted code hopefully is clearer.

> 
> Also, I am thinking out loud here but we do have a few places where we
> go: idx = index >> huge_page_order() to convert it into hugepage units, but the casual
> reader might be a bit puzzled about that.
> So, would it be worth to have implement an inline helper with an accurate name
> to do that? It might help whoever reads that?
> 

Indeed, will add below inline helpers -
   pgoff_t  huge_to_base(pgoff_t idx);
   pgoff_t  base_to_huge(pgoff_t index);

thanks!
-jane



