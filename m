Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 686F1CCA470
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 07:50:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 699878E0003; Wed,  8 Oct 2025 03:49:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64A708E0002; Wed,  8 Oct 2025 03:49:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C31E8E0003; Wed,  8 Oct 2025 03:49:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2F4738E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 03:49:59 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7CFC8B95DF
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 07:49:58 +0000 (UTC)
X-FDA: 83974173276.12.A96086E
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf07.hostedemail.com (Postfix) with ESMTP id 068C340005
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 07:49:54 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=SMHPVzNt;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="dd9mpNL/";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of vegard.nossum@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=vegard.nossum@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759909795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vl4yLwQsc5xROSNGBzYEZAWbsABo+W3zJFDbXVl0Vng=;
	b=HRj9PUOKjOrFyM/fJU2sb9g0hwBatwIZkWzZKz5y5kCOExdVIKuZse9FT2ZNX+liQezL1m
	dM/Z/gQhMLVsVbLdzQacMUjG86YQ9A56Ix9WUGL4Bcgzvr0hx+BM8t/U7O+RRLCOyDiSS/
	zm50PBYsS63+QYlYPWxn9+FveYfdqc0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1759909795; a=rsa-sha256;
	cv=pass;
	b=C5sdp9o8e/ZbLy7KCnsMSoscsIu3d4JgFxZauPnfnoIDB0HfFimlJA3tWOMpGZmG5nON9Y
	hJK4SJObkLnAE+iw+cVobUJrLkAH7JmbDBA58Ez7cbV3Nfy+SvMgYxYhMTVNsMWDO9nPhw
	h1nWaZap1XYMVmJs1FW6hGZ/6r43ToU=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=SMHPVzNt;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="dd9mpNL/";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of vegard.nossum@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=vegard.nossum@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59879hVT011384;
	Wed, 8 Oct 2025 07:49:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Vl4yLwQsc5xROSNGBzYEZAWbsABo+W3zJFDbXVl0Vng=; b=
	SMHPVzNtVBV2R7V3lOoM/rdS+Uk/W8H2PXV4WvB5Vc5Xf332EtL+WQtZgmHjQ+pt
	X9ZhUPdJMkgIgi7CqZHdp30TU3SzqlQC5yYfpbq9KdnE/BsYH146r2Gxcu0axDms
	rev82sg9B2TpSViGmDahCbhGoAithvynIpKFkPaAgZUnjWhihWF+Pha0Mt0CzM/t
	B6Mskyji6GPg7DpGAG45JEoSOZSXW/uJ6Nmv2s6FNuLdbDCDiZOjoBSeR+CD41PU
	RRl/0WNo0uckeZDH+9AS6KrOIU76Tm7d06NdyUvBWm0B46FErwzbaO6jw5HXpSzN
	m5h6H5XGZ6Xkc1HVxoQqSQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49nkap824k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 08 Oct 2025 07:49:35 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5985Toog040946;
	Wed, 8 Oct 2025 07:49:34 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011063.outbound.protection.outlook.com [40.93.194.63])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49jt19h3jk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 08 Oct 2025 07:49:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ULtjBB6w27xHpy1jih5SYGRzc+bKnBopbPEBdcCWEknK/yJY/STTatQFRLXvblgdO5ko+eV2Z3GZZkSKLQyjSqotBvcXH+SmpPpkfEGr20zDgJsyLvGBlH9TU3B0kgL6Yt96bNNV6YoXTIPxJCzItbLivqMbx06/8U6U8EDuNApK9L54ZSno48JD+IHYCqdGJKJvLCS7HOUtvIFcIFtQPPkb+GDeT0+1fL/qv6ZtrTbGYHMnYBMS0fcpXWzDkaDV2Pe2Vl1+KA5u6mbGNUSlDfvtkEAIM2fOT4Laou3CcFC8zALtCbDfl8bOvtTvxOjRNTvilBNMaPsAnJbp1VRvxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vl4yLwQsc5xROSNGBzYEZAWbsABo+W3zJFDbXVl0Vng=;
 b=Epvi2QdhaYquLVmBYCYyGYCEDbi4M+FJAzW153y+EwcGbhv8isYvFFaYpSqdHQPcamf6rAlsBwWmS2or6gOak461XpQUjjqLqNsQzoU2HlmRrfTTNEFn1YO02m52S1al0FX7EhdZDCb1fgZJ1V5egxYdn8R0U1b9m0SeHPkZUCgCsfgPzpWHdFztf2lVBnuYLRpB3XLhIjLZwy1Pn8tvgYH81A+nnk4Nu6zZfm8cSfDUiLIsGZ+mIN3kLtLxWINzTrT4YhCX0PCzO+2vo42DgUvqo2Kc/b+4fRNtc5hAffx69jmz31kPl88+Xvtqu+Cyh/8LRS7Xwc6VJtIpcm8tOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vl4yLwQsc5xROSNGBzYEZAWbsABo+W3zJFDbXVl0Vng=;
 b=dd9mpNL/RM9B9YzaiFxJTE4GmbksrlI1CbUjq1O37t7NDisPKy//X+/SgtVFgyX+xM5CSeLDyai1Ps1oX5hzHrVn9xhclvv8GiQA+Bdjdgh0JmgYUmz2X2Td+2PETtEezWBQNzPtsZmlYbKestk5JCZZuMSQnxG+6Eiz8Jcj04g=
Received: from PH0PR10MB5433.namprd10.prod.outlook.com (2603:10b6:510:e0::9)
 by PH7PR10MB6484.namprd10.prod.outlook.com (2603:10b6:510:1ef::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.9; Wed, 8 Oct
 2025 07:49:31 +0000
Received: from PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::47be:ad6e:e3be:ba80]) by PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::47be:ad6e:e3be:ba80%4]) with mapi id 15.20.9203.007; Wed, 8 Oct 2025
 07:49:31 +0000
Message-ID: <b17ab23a-b0fb-4fab-afa9-41dfce65675a@oracle.com>
Date: Wed, 8 Oct 2025 09:49:22 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/2] slab: Introduce kmalloc_obj() and family
To: Kees Cook <kees@kernel.org>, Marco Elver <elver@google.com>
Cc: "Christoph Lameter (Ampere)" <cl@gentwo.org>,
        Matthew Wilcox <willy@infradead.org>, Vlastimil Babka <vbabka@suse.cz>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Bill Wendling <morbo@google.com>,
        Justin Stitt <justinstitt@google.com>, Jann Horn <jannh@google.com>,
        Przemek Kitszel
 <przemyslaw.kitszel@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-mm@kvack.org,
        Miguel Ojeda <ojeda@kernel.org>, Nathan Chancellor <nathan@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, Jakub Kicinski <kuba@kernel.org>,
        Yafang Shao <laoar.shao@gmail.com>,
        Tony Ambardar <tony.ambardar@gmail.com>,
        Alexander Lobakin <aleksander.lobakin@intel.com>,
        Jan Hendrik Farr <kernel@jfarr.cc>,
        Alexander Potapenko <glider@google.com>, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org, linux-doc@vger.kernel.org,
        llvm@lists.linux.dev, Matteo Rizzo <matteorizzo@google.com>
References: <20250315025852.it.568-kees@kernel.org>
 <20250315031550.473587-2-kees@kernel.org>
 <aOR15Xb6DfolYM0z@casper.infradead.org> <202510071001.11497F6708@keescook>
 <e019c59a-ba8b-ec04-dc5b-923cf9dd9d9c@gentwo.org>
 <CANpmjNMsSGY+QEn=GV8S2sXuuQsioikPR+OhGa3+6EoTqYPkHQ@mail.gmail.com>
 <202510072114.52B93ED736@keescook>
Content-Language: en-US
From: Vegard Nossum <vegard.nossum@oracle.com>
Autocrypt: addr=vegard.nossum@oracle.com; keydata=
 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 8A==
In-Reply-To: <202510072114.52B93ED736@keescook>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PAYP264CA0010.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:11e::15) To PH0PR10MB5433.namprd10.prod.outlook.com
 (2603:10b6:510:e0::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5433:EE_|PH7PR10MB6484:EE_
X-MS-Office365-Filtering-Correlation-Id: 216c280a-5855-4104-33b4-08de063f36d9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OWp5Ly9DVXAzcVJ0Sjcvb2FTY0U2NklGSFFLNkY3amZkT2dOS001eXRPTGdu?=
 =?utf-8?B?YUIrRUV1aSs0VXVGQlNyRkRYc2dKL1BvRVl0N1RiWDZBNnBVT3pDZ1lVUkRq?=
 =?utf-8?B?YnRPVDNoaFN2YTNEd0tXS3BOODNFRmgzVFlNN0Y4ZHlvY1JDcUlObWE3dWpO?=
 =?utf-8?B?ODhDTHBGRjhDcnl5dEJOZlJlVWRhaEVLbENJSDR1RDUwUUFTLy9PQU5kUkhs?=
 =?utf-8?B?VFQyN3c4Vm1yemdLTTMyT2lxZ0RlRWF2Q1RlaHZVbHJYbmt4c3RoTHViQVdL?=
 =?utf-8?B?YjFHMFlaR043anI3WURaOEsrZjJJRDc5QURBL3RUcXFHUkFXVk51RFVweSt2?=
 =?utf-8?B?bDhCMXpyUWZ6bERJNlY1U1ZONSs1VWFrcHVpZGZHN0hYeGd5Z3FEZmZFSGd5?=
 =?utf-8?B?dXlRaHBGVlZjdXlINlNwVnVKU21GTFcrMWFSaXVOTXFaWkV4bFcrM1BNZEV1?=
 =?utf-8?B?NGw1K0VSNERyVitaRlVwN1VRdUpUS09SV1g0N0dwTUN2V00zaDVVMEQwL0Jk?=
 =?utf-8?B?NGFWRllRamp6a0NGSFpudHVZb0pBR2k4ZytqdmdwTGhqRWs4TmJMNmtRT2RY?=
 =?utf-8?B?N0NNczJlMkkxYm13Ulg3Q2xqODhkT0pESTBkTCt1d3Q1OHRLM0JOdGU5SnJV?=
 =?utf-8?B?cmxhUkM0ZGVxMkw4VVNvZHMzR0lvZno0dmVuT3NJK1U2K0djVCtRdnFUM3B6?=
 =?utf-8?B?OVVBSDREQjdxY2ZkMVhYVFhjb2pBQzljdlQreVRQOXlUWGQ3QWdqKzdUeVhI?=
 =?utf-8?B?bjhLZlhXT2I5ZzdrVUhITFdXSjZUSXVQS0oxOWhEZUhkeklOdHJON0pTRytp?=
 =?utf-8?B?UVY4WmNqMzFlSlBGWVM4M09HcXNxN05oNGhCSFRUSUhUQjFDeDVWd1Q3VkpZ?=
 =?utf-8?B?RjI2Q0tuUWxaT3U3d0U2dFd1ckVaeThnWlBnejRRUTBPSk9XcFZHUUNXZ3Bh?=
 =?utf-8?B?ZE1Cb0Jwa0UxOGpTZERtMWlSUUR4QmhrcXJMd0h0V0JaK0NkUUF0T2JneTNP?=
 =?utf-8?B?Y0dhRHBVb0drWFN3bm1qTy9LRGtCaGw3LzlEQXZJcG5zZ1c5WkRKcWRDWW0y?=
 =?utf-8?B?d25CSDNFYSs2RzFuV1RzU1NYUFJNMGlyUTRVNENiU2xLMy9aNGpOak1vM2tR?=
 =?utf-8?B?M3BCejlPR2l5b2dyMzNwc2k4TWtaTS9MT1Y3akNvZ1ROZ0JmZHVoMUNhTHBM?=
 =?utf-8?B?c0c3ZWlmb3htMFBSNzdGUFpkTldpOSt1ZFVMblhKRWxFMlU4UjVNZno4djEv?=
 =?utf-8?B?YURrY1ZTS2dIZXdBOXlwK0JrYXVSc1RpVTlmeUJ2RnRDWUxrbVl2RXdzZEE4?=
 =?utf-8?B?ZFBUZHlvN2VDaEJ1aCtQcVFVSzc1OTJhQ1pHQk1Zc2pVMlc5ZXdENlZZYUQx?=
 =?utf-8?B?MjBRVyszdDgydUx0T2t6WFRwaXhXOTlNQndmbDh4NS90QWZmNE40TEZ4ZVVj?=
 =?utf-8?B?V0NDazdDT2Vrb25EN1hhWEg2Ui9HTWNjM3NETlhiNkNYSG5tMzRSTjZUc1dM?=
 =?utf-8?B?ZC9nbkdiREZUYzhXTHV2N1JkR29lNURDUDhwWTdZeVN0QWhQckRRbUtYaC9Z?=
 =?utf-8?B?S0Fxelo0N3VCb0FBdndzbFFySS92dzhRcVJRSUFuTjgxdEx0Tmw4Vm9GUGJr?=
 =?utf-8?B?dVU1SkpRUGNYcU9yK0lMRkRYUGdUQ29hMXFtN3o3UENtU0dHbS93TGUxeGZM?=
 =?utf-8?B?NWRSYnlNSkU5enJnbkQ0N000Q05Sa2JBZzBrL3M0S2U1SVJFZjRMZVUrSVg0?=
 =?utf-8?B?OVBQKytXWFZsL3k4UVhFSmNZL2psQWNhN0dRRjNNOWRFdTFuYlNZS3F5bUcx?=
 =?utf-8?B?bG1vdnpmbkxpODhQaGU2WURldVdVREY4QVBIazd4anU0SDZSUmczcittWXJP?=
 =?utf-8?B?WnUvZ0h4dnNnUW94UGh1eFhiZFM4d0JlK1BMNkw3WWF4Wnc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5433.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZXJhbi9DVU9KN0l1akFEb1I4b25sYkhkZ1dqejhHK0d0Y0x0RVJkZ05NUzJV?=
 =?utf-8?B?WTFPeGpyRkNQZkxnSExxV3FodXBtZW9hQkloYXpOUm1TeFhWYVRDd2xsdXF1?=
 =?utf-8?B?RlRvRktYNnpzR3JpWkFsTVNzeUEzazhLMmtzMUtMejU2TkVmZldpVk56bWhI?=
 =?utf-8?B?NXo0Y0J2VGhhelhJZkFuU3pybXBpU0VjaUZTdTlZZ2xYU1dmRnlvNXo5dXlQ?=
 =?utf-8?B?emlNb3ZHT20yK2VTejhsakFTUGZzUzdTS2dGcklmR2dncXkyZlA1ZUxYM0xi?=
 =?utf-8?B?dytGR01xbStyblBScE5zbTh4Q2hMeXhtL2RpN1J5YmVPTThkbzZsR014Q1VQ?=
 =?utf-8?B?RXllZ1llWkxBVWJBVnB0QVA2Z0w2YkVJdjA1Wld6MHl2NUU2R0hlNGpoY0tV?=
 =?utf-8?B?VUgzbUk5R1JrK3o0U2tMRWtBenRHbmRKZTdXc2x5VW8xcG56UkZwYzFQSHJR?=
 =?utf-8?B?Y3JVeFZYNXY0c3JvNWNEK3B2SXNoa1c0VzRyejJ1eE1FMzZ0TEhONTFCTGxQ?=
 =?utf-8?B?eDN0dDZwU0h3ZUdsWkZGV1U3TDEwb2U3dFkyYkYrRE1VTzNNRUhkZUpVWGc4?=
 =?utf-8?B?N1RzRmtRUWJSWC9ZaUh2bEh4cVcxSTFlNFdjb2t4NkVpeW93bkQyUUpkV3lW?=
 =?utf-8?B?c24xajU5azEzVXBYZXNFV3p0QlFBTlB4eEJxdmxLSU9lNXdGVkRuQTJKeERC?=
 =?utf-8?B?Sm13dHdTZ2NodE94aWVXdXRDWS9UTndVMjUySnhwZkJka1RyUVhQU2Rja20x?=
 =?utf-8?B?TGhRYUdvR2ZDQWlsaVdBUGFhcmVCcmIvdE1sbFphTlBWRFA4WnF1ZW01WXg4?=
 =?utf-8?B?cmRhMHhzYjExbzBJVkd2MkNiRW54ckhHZGhPK1pibE1zdDVzQUlIWUh5dHd1?=
 =?utf-8?B?MVZyUGJ0VTJpbTZFMys5Tnc4YTM2RkU4ZFRDeExlZ2V6dFE1T1daMjlnemN5?=
 =?utf-8?B?R0d0aW1jSFpOdmRUeGNxbEF3LytwcXFaaSsvR3lQeUhDYXBFNVRRSmNNWWRv?=
 =?utf-8?B?ZmplbERaQUIybUsxMk0vYkdpNFE3ZHhUa1kwMGMyMUx4c1IxTEM4WG9XYXBx?=
 =?utf-8?B?VkUybjdZd1JkbzhrUVpFWkpScGk2Slk1VEtsWVhnVmFqc2pBbExwVHVYbmJT?=
 =?utf-8?B?TWJya1daV1BMcHplYWpYNlcrTS85ZzQ1cUwxd0wxWThMd01UMVFGbFpyb2h3?=
 =?utf-8?B?WXNqclRTa3d0ZklUTjRSN3BsUU9yZUNjSlc0NnRVd0NLYXprajdIb1BjMjVy?=
 =?utf-8?B?Rm51QU5QbzJGTmorc3lKQldxd01jVG0vVDMwL0tINm5kb01lMjhHWXVVQ1E0?=
 =?utf-8?B?RWpyZ3BRMkZtcnhqb083TXN0VUV3ZUtuM3dyYXd0ZjZGNmJVRkIvWktlNi9l?=
 =?utf-8?B?T3dmL25IV1hHTEhFZmtMWTVjTUIxU3lleGZMQjRSemNTR3B2dFVwQUFFQzhR?=
 =?utf-8?B?cXhBeSsyR3BjQ3VxTDJqVTNQVDVmK1NZNVA0RHBoT0ozWmJaNitadGhRVEpm?=
 =?utf-8?B?WjFXMTFTblVqcElZZllnZ1lad21QWDdFenVvdVRjZnI0RFd3Y0hPWHIvbFJG?=
 =?utf-8?B?SUNJRUdNS25IZHRPWDJjaktZNzZHaEM3MndJbElyN0ZqdGEwM244OTEwVmxN?=
 =?utf-8?B?VkZoVXhua3FtWjJyb2FZTHJIaW04TlQ1eXJzVlVQeUNVRVVabWVjbFVLR2c4?=
 =?utf-8?B?MDdkWjBMalBlMkRhUDI2SVIvU09NSzdjQ0l3WmcxVXNkdzVpckpndDJFYUU4?=
 =?utf-8?B?T1NiYjl5eEFtaW1mRWdnSFErU0hsMnNLOW02OEtUcEhONURpNkFBWE9yWTBz?=
 =?utf-8?B?RGJqTFVDMFF4Yk1GSCtJNDhQS2VRclhvUFN6dUdONU5Xait4QlBpN0dGZ1hi?=
 =?utf-8?B?cFo4dkNJS1ZZNXU1VVA3L0lDYjJ1a1g1VW5BendNY0pDRmtXcjRVcFd3aDl6?=
 =?utf-8?B?SGRpTkxYN2lSelVoYnJtNEd0cXdlN2wyVFlXM2RwSXlGb2lzeHcwZ2xkT3Ny?=
 =?utf-8?B?UWhob2hibERzSjM1cVkxZWoxR1ErQVR3ekRwQXFFc1lzWTFmSTkvSXB3Q21y?=
 =?utf-8?B?NHF2Njg0ajVpcThVcUtNVWxCSFNKSUVlMjFwaEpITFJOL09CdVFnTGFvMXlN?=
 =?utf-8?B?cUVRSzhZRW9DaFJEZElVUkgzZjRLZVFONkZVblUwWjZaaW10bk9xKzRhWFlB?=
 =?utf-8?B?Z2c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	98WabQAyd9OPKtsx/r1IcynZmpecyyp5hA44eFWctmPqT49fAi4W5JWDVRIk3D0wADgLM2rUhau9nNUFgMTd2SUSYA0r2y1U1sC3Zr6oPcBgzf9hKLSpHgqPhjXS0Nj2+6/csmMQpcMhvZSHehM0JUR2aeYYT9fyOaPXDPBcCKJOIb7aZPpSzK+c7D721K+uEPpt9UjioZ2PHa0kuowC970mn1sG+94TBi2hTjAwSOvFgNvctmx/fa1vgnhQHfEmWzRg9tLF/PwYpO7KbCo+Um1rV9S2+KHQ9rgLCfv2VCqZvOIVjOmSekDpQS8nXzFyVjJU1ZmUyxyMZsyei4cx5x83Y9WbSaQpiTq9lDnbY2lSnjDYC4kAu1tgw1PqE58EmvoMS1fgqooOEE7M/fhqRSPwoNPiZ3y1e8KzXvJ9s9v3lRFdQUxVVCRET2Ok/y4j+ru1EFBcBsYSIuDC7VE4k7zO+Afh0H9uRjK/9mqc49eGzZ2Khyoui1518d488XWbxgxSVsqkYW3VJyRy+0VgGdmgQ0UQcP0pIXLlnMyB9tAJ20HxmGGMUWUJ2jCbkxuNv99g+aNqrVLiHhi8h7g/+dJyNkmG69KoE+XWXHnmVqA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 216c280a-5855-4104-33b4-08de063f36d9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5433.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2025 07:49:31.2064
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NdqJjEeRJ5LEA5iPQDqR2sxZh28/zH+DCv5TUQ41/rd16UZn4f7UlLKXhUS9U9Vag7cyGrlOrD0eKvSacI8Ej4IC5QJDXjvGGdrl3+fLBh0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6484
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-08_01,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2509150000
 definitions=main-2510080052
X-Proofpoint-ORIG-GUID: Evr5S5FmMfNYDnEJ0H90kVij6ZWHXbr5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA4MDA0NiBTYWx0ZWRfXwYRUEb4t0xHx
 zfHrUne5j61KSMAiHgVz3/VI06Tu3JuZbohWpws/EKSWAH0uZWrnbrjNKteU2usvXYv9mc8AH2+
 ZXv1eUuiwgnKqnHqPGwCMoBmJv2xBETLLyHyv3JurEqSTCGIDwoG8SJtsWhnEIal3Lpclli1X8c
 NUqRyhQppXg5u8hhJH7YZVuDvt54/iwq/sm594bMPOccBbR6j6fEpIB4Yt2oayqmh8VFHCkB6kb
 ZP01uzoakwEpMpVa6jwVIv7TWqdfXqxaY87ndf2ZQxDuRnMwqIy84dMD7WqtO/nfVyGe0XseXTH
 j9xB7Pxesjl1vTdSiJUbzGiVIFy6ZH66tcCJjviMft2a2uuUXbM0auuPSNMUhJIlWbau43oVvcN
 ur2beginaZ8sgNiFOm8hvGPHHf2/Yw==
X-Proofpoint-GUID: Evr5S5FmMfNYDnEJ0H90kVij6ZWHXbr5
X-Authority-Analysis: v=2.4 cv=BanVE7t2 c=1 sm=1 tr=0 ts=68e6178f cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=t-IPkPogAAAA:8 a=VwQbUJbxAAAA:8
 a=1XWaLZrsAAAA:8 a=PeOOapuUAAAA:8 a=PuvxfXWCAAAA:8 a=3lLqkXNGFaJaQfs6N1kA:9
 a=QEXdDO2ut3YA:10 a=0BaqRfgCL6CLbWgV2pdm:22 a=uAr15Ul7AJ1q7o2wzYQp:22
 a=DXsff8QfwkrTrK3sU8N1:22 a=Z5ABNNGmrOfJ6cZ5bIyy:22 a=bWyr8ysk75zN3GCy5bjg:22
X-Rspamd-Server: rspam05
X-Stat-Signature: gb3ur7bnqgzpji4cxhiy4gurehmr3gq8
X-Rspam-User: 
X-Rspamd-Queue-Id: 068C340005
X-HE-Tag: 1759909794-748120
X-HE-Meta: U2FsdGVkX1+nwmN+j8gKGiY337eINmEPoEibHdwBBtaH6EWQkbJmZXNsFb06OY3fAvmyI56G+tDpSvramoBVCMs0qAw+92wu8/e1n1ytaRNcDNnZkhqKlNsm8+q4omS6ewUysJ8t2PnBcDRfFX4UgxoUsPnREOdOL1YH7LPyIfh4sgiy/Ot89bmG0Ax3dWzk/EEBbs+PdKSvazqUJL5RLVT/zwabfZ0syEjyEhZgxAHk2NbCKPUwyOQopCndgH7dtZFyiNNKf/Lv7wPKWOk+jLyW/4LUwSx9Is1hB4852bL4TNWbf6ZBdcGszN6J37IceGcp9+nkxLUBoST0+TkmfmnEdcr7QDBPafYmqf0RXs0gjqwu61M3GIyt7qvD7JFc5dTWvfVoCR1r2xVpWenTZ+HuCwJfuJyvxjVR5LH3Msogiu0JmkexKWnKuNtzfVFpLDPKWqx9Q72rxVhQ8/jc0oSIpnoDGSW7CRLgy3q9ILrPcO1gPzA8FwYH5FvPUuLUg3s8mVwZAkVC5ODEjvRM3dWr+yyLmFNhIKrVIzwg8BDIv5ZrbeT46EiIBG8NsgcK+nGk77OKCjyi51OK890ZhwQtTs4BJSgzcOl7sPtWXdO4kKLYS7y7wQ/0lxCsLGu+WewsBlQCSJSLSZ/ZTTckhUQbgLKGw2IuHp5AKPo/1a0GS/K3s3n/IcgIk2nWe7uM9A6I2M+ze/WsfEWzpncNL6OwOwOQ+hhx9yhmb3X0jIQqr8Dpkj9gAawKnKJEc+HPea4F9GFdBaqvbdoLl9Em83kNVD5jSyTNd7FXLyI7B36lZESfYpxZfQWtFrwBfsuZhe7t0340EUmxm5vG4EBgo7TxCCQ1KqF5mDqmPFgV+HwKRxpCT6LlhrTSwCd8E/fjW1BqQXjadJqPhzrKkgunDGLENPTLTSAIxTr2c5gc+1qOAPteSMSOClhScy4XwtFQXYlPjWFXfh9l0E40QPx
 rNqUenVR
 chpI/u5RBYorZ16N6kW1b1reG/RQM6J5WI82S44N+Siu89i7IQEhtJgBKhUXa6/nM7ZvXw2IES0DTvMdbd0Qi9z0Sm7n4mx9ZanUoC3bcrvVGY2eEr+WNMNU0AGNgFsgwChFMLCbZoHR6c+C7T5tUc2CkHk/9uTOmMZJTDS0z2dlqLvbKJhE7B7oxMTeGdedd3CiP+nEs+X193bPVCsNFwKRLVNX1B2bka57UKQ7NOFLGW4F9zJLjHQG+ND1/N79BtW9Ay9eaD9v3FN0Mzh/m7fFe5+UVN+yAHn+X3pjcJ2GIRcfAfjDy0vb1exToj6Vj4Go0CfhKmGrMK1ZXMIs5MQT4cjP+HbEAjMDcC+fnK41F5rKAEcWdT0xtRSU0AIGaoUY5omKmF330x/5b5tBiaU3sQQqhuIRsEcaAna30Kcqyhu1jDNqcf9gFbHyfG4dBJWpqVsfEg34ArGKfb8yyYlWYMxxgX6V3XQ6DUqfvWyFPZx9pVtbXqcUKAc/Fubcc2F8wcgqLz9M/FKKfXHFusWNQEf1UZCSpFfgnaLX4vJXVyl1AI5foo8xXjpVTyMzA6A9iLy48Y2bDU6pOi3UCfmUzbQrKhgXS0zxHwEWnqhvMIioqz6OnFlRHQhSsQZSNQqDorphov9MD8k09pSKXLJ96TrHMypbmPQ8J3Rl4YK3yuTd+oqQE2dFTU8D4pIeQcqKGZDx0HR4peUOqSt7hnvOxEEXflrtZKqNFGfwF/wA89q1xtGhptYbzSDCoWaHkoLNmEfvkSw1e+lVc1hWqwR7yBAeoLqVR2xoMXaKslLU4meXIbrKtMmL530Ka5cVs/4uKCHa5RxtQmV9hoFL8WuSH6pM6HAVFFbhs4fWHjwjcXn+x7dFxEtw07DpLQwGX0dm8oE6YrKtT+D1uM9lcMLEDGc1M5+KPmIjujwZU5ilIdWjYO/zsQpkI5uQ6JveRfXO8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 08/10/2025 06:20, Kees Cook wrote:
> On Tue, Oct 07, 2025 at 08:18:28PM +0200, Marco Elver wrote:
>> On Tue, 7 Oct 2025 at 19:47, Christoph Lameter (Ampere) <cl@gentwo.org> wrote:
>>> On Tue, 7 Oct 2025, Kees Cook wrote:
>>> iOS did go the path of creating basically one slab cache for each
>>> "type" of kmalloc for security reasons.
>>>
>>> See https://security.apple.com/blog/towards-the-next-generation-of-xnu-memory-safety/
>
>> We can get something similar to that with:
>> https://lore.kernel.org/all/20250825154505.1558444-1-elver@google.com/
>> Pending compiler support which is going to become available in a few
>> months (probably).
>> That version used the existing RANDOM_KMALLOC_CACHES choice of 16 slab
>> caches, but there's no fundamental limitation to go higher.
> 
> Right -- having compiler support for dealing with types at compile time
> means we can create the slab caches statically (instead of any particular
> fixed number, even the 16 from RANDOM_KMALLOC_CACHES).

Maybe I'm missing the point here, but I think we can already do per-
callsite static caches without specific new compiler support:

struct kmalloc_cache {
     const char *type_name;
     unsigned long caller;
     unsigned int alignment;
     unsigned int size;
     gfp_t gfp_flags;
     // ...
};

extern void *_kmalloc_cache(struct kmalloc_cache *cache);

#define kmalloc_type(type, _gfp_flags) \
     ({ \
         __label__ __here; __here: \
         static struct kmalloc_cache \
             __attribute__((__section__(".kmalloc_caches"))) \
             _cache = { \
                 .type_name = #type, \
                 .caller = (unsigned long)&&__here, \
                 .alignment = alignof(type), \
                 .size = sizeof(type), \
                 .gfp_flags = (_gfp_flags), \
             }; \
         (type *) _kmalloc_cache(&_cache); \
     })

struct device {
     int name[32];
     void *priv;
};

int foo()
{
     struct device *dev = kmalloc_type(struct device, GFP_KERNEL);
     // ...
}

// initialize all static kmalloc caches during boot if needed
// (requires linker script support)

extern struct kmalloc_cache kmalloc_caches_start[];
extern struct kmalloc_cache kmalloc_caches_end[];

void init_cache(struct kmalloc_cache *)
{
     // ...
}

void init_caches()
{
     for (struct kmalloc_cache *cache = kmalloc_caches_start;
         cache != kmalloc_caches_end; ++cache)
     {
         init_cache(cache);
     }
}

Godbolt for playing with it: https://godbolt.org/z/E1c6q9avn

If you really want just one cache per type, you can funnel all the
callers through a single function (single allocation point)?


Vegard

