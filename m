Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 130CEC44501
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 23:49:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF61C6B009D; Tue,  7 Jul 2026 19:49:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCDA36B009F; Tue,  7 Jul 2026 19:49:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE37C6B00A0; Tue,  7 Jul 2026 19:49:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A33776B009D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 19:49:33 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1926B1405AE
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 23:49:33 +0000 (UTC)
X-FDA: 84963625026.27.6660E10
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011049.outbound.protection.outlook.com [52.101.62.49])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4FB85A0007
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 23:49:30 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ZDv5Uu8C;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.62.49 as permitted sender) smtp.mailfrom=balbirs@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783468170;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Eg5GQEE6Y45IDyBExRx0aJ+khpkhsqARkor+2d8RvH4=;
	b=IUqvhGoHlr8ZSOFakSdh05IBR+LrD70XjlttExg/bw2n7FB2aNvsvBemBKI3X22IenXj0V
	oVnTQuHmGIXsrAfyL7/HdriZWRDp6pq0KqGUHdGHk73E87NqIIdlqd652zWC9jc4m5K9qg
	LnF/K5JXnUf2KA/5TrhhWqVbj67QRWU=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ZDv5Uu8C;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.62.49 as permitted sender) smtp.mailfrom=balbirs@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783468170;
	b=QcGm35vgdFzYek3Cwj9/GhBsztcdZYX1hiRnJd655DKIF9xFa3xfzWPGeW7VO/z/3a8xo0
	B0Xg7rcygC2HTowf1hLuAYyFd4SvHFEexiSYRn91yTITgh1ajEV2zqXOgZ/jGAN+znbPdJ
	7abMJJAr81+/vDBMpH9A9JumoXMpGxU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hoitmmBjft92hNzQwe2ldxqmexQr7vgB341ZZoU0nlg2G/DU1Rn1BFbcbcVmC/+fJY8vXt0a0MsrKOCPVBUGG/HPPLNqTwjJEsHirSIrm5GuoLjBcLEci+TeZejBmAgTVqvFI8CjPoPm4r3HUs0brVGf2N/yVp+dWjHs1h3gsFo9Mp9Q/RWg47qLzsQn0csynxSITQsW//rx2WKk07NgWqOKEsIOfLCYrQT84zkO+UDe+e1AakQ8hbuhPd4QJG/85736Og/8tPJdwMNUKGE8Dy4ZHXy0NyhysaecGWOoupYq+te4yfjXY3fnT0HpbLbjXySh6NDNiwqUuFdftFePxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Eg5GQEE6Y45IDyBExRx0aJ+khpkhsqARkor+2d8RvH4=;
 b=WzALlqoZZLKr/cAv4mAw95nJZq1TazjqO152gHzqEtOSiH1B4Vt7dvCRx93ri5gjrrN09nmSWM7xEF5LX+WExLqIuU6DV5uetnsDFnYRkL6vZFyF3dpebjrjKSPsWadW5/JXhxxS2C+KmT+6tLbhHEUEZ6KXivCSOQ5GyOMmikZyEuaxBm1BoT8Cqg0BiaN4lnZDIvrsTGlI0KsSWA9fpwpgvhhHoedApSqPI0ZbdUmlIa9IkH6xpGsucfM3SM32sNHiagfZLuYYqzBYleZoMqrR/mqUzbwphuhvhwgSQGwTgVB2RN5IITaOtGjJQUpE68PCrT2jfvVVY6C2J5yEfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Eg5GQEE6Y45IDyBExRx0aJ+khpkhsqARkor+2d8RvH4=;
 b=ZDv5Uu8CSMZHc//HXzoYji2GPVAV9XcKEImi864msbzolK0KWjcZZmCkrFyFIhf1xwu+sUx2nkZU4qFB/UpwqyhdPOvDMovWDnSYM5amUhhHR+xBd3LP6in3UEcgKeOhaAJGqLjqmtC77txBfYJ90YUfVGnoJdjLL/p54v1r5aVs8f125Insr+AOj7DbBOZ1hScN+sOgBkzyczdYOEeBBpdyPN1ilBNiGf9n6gx8Ga9XdcLP0HTKw9toeLJRoUmlUnz6IWcxQ/UU6DHAUF8hgS7V4Vp0ajQ6AxnND6g0JlDzUeivbGQRy/xV4I/G3J1m9c4Qd6gDy+EvHm2S0q1H4g==
Received: from BL0PR12MB4995.namprd12.prod.outlook.com (2603:10b6:208:1c7::23)
 by PH8PR12MB7110.namprd12.prod.outlook.com (2603:10b6:510:22e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.14; Tue, 7 Jul
 2026 23:49:25 +0000
Received: from BL0PR12MB4995.namprd12.prod.outlook.com
 ([fe80::dde:9068:4b1a:53e2]) by BL0PR12MB4995.namprd12.prod.outlook.com
 ([fe80::dde:9068:4b1a:53e2%4]) with mapi id 15.21.0181.012; Tue, 7 Jul 2026
 23:49:25 +0000
Date: Wed, 8 Jul 2026 09:49:12 +1000
From: Balbir Singh <balbirs@nvidia.com>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, apopple@nvidia.com, 
	baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com, 
	david@kernel.org, dev.jain@arm.com, gourry@gourry.net, jannh@google.com, 
	joshua.hahnjy@gmail.com, lance.yang@linux.dev, liam@infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, matthew.brost@intel.com, 
	npache@redhat.com, rakie.kim@sk.com, ryan.roberts@arm.com, vbabka@kernel.org, 
	ying.huang@linux.alibaba.com, ziy@nvidia.com, shakeel.butt@linux.dev, hannes@cmpxchg.org, 
	sashiko-bot <sashiko-bot@kernel.org>
Subject: Re: [PATCH 1/3] mm/mempolicy: skip device-private PMDs when queueing
 folios
Message-ID: <ak2MUFRwzw1-VyvX@parvat>
References: <20260707135255.292870-1-usama.arif@linux.dev>
 <20260707135255.292870-2-usama.arif@linux.dev>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260707135255.292870-2-usama.arif@linux.dev>
X-ClientProxiedBy: MEWPR01CA0300.ausprd01.prod.outlook.com
 (2603:10c6:220:1f0::15) To BL0PR12MB4995.namprd12.prod.outlook.com
 (2603:10b6:208:1c7::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR12MB4995:EE_|PH8PR12MB7110:EE_
X-MS-Office365-Filtering-Correlation-Id: 8166314b-14a9-46f9-2b9a-08dedc82600f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|7416014|376014|11063799006|18002099003|56012099006|4143699003|6133799003|22082099003;
X-Microsoft-Antispam-Message-Info:
	YrMHpTg7lW1dJq9M/uFVjhLrohvIrJPzUEGVORBQVEGlpKrcVwX2+cV/aV/uDH1GM0sXy3Zpuj+Kw4E0Qjlj4UcHlhS5KB5zNhpQPR0M3+7My8J9ddrJt2lMjspi1rTckzDuneDiLj8sjumafls+x1hGgHJCPhqwLV8cFvl5qJvh1JrzjWlR9/QGfPX/UORgIq4ocXuGa6eVgh7TMs+tRMORMqMBsrjAdWIO/2lAovWCSrGUnfsVFX6C6y3+QZ5flxn5zeYucD/frHwmZ7ybcY8NNuEqiJn3LhcfqDhTZD2Fm3rOuGYHMCB1+fK/Z34InvL0AWM6H310rFxsylWKSTLYJfeoCSjDOTGEVfTieTqKzOojI+w5KR/5nLxsoZD9SAY9BGHPfIcWJknWYlDOcjyAg6aFIYhvaM5VBbbrNN2f7gdjmK+8VAk096/ziRNLquTMXneprTfLrRyEDe1Iu/s0U5AVHkR3lDNrhRQW2dsbvhFaZebgPl9yK3hWC50WHoByR9fFtQAIfnKn6Gy5UZdo2uv6AOe7ffGPSDR12Kd3k4/kyRBC4Rw3V2+87hErbfFlj5mnsyLBcnch4ZT1sx5QgEtu6rY9S6WpDczW7k+0XojMDGrn5BR40XGbiBCY6kTM4RR4oyqwcqpmV1Olw6C02mCcE+e7bAdh33D8kI0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB4995.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(7416014)(376014)(11063799006)(18002099003)(56012099006)(4143699003)(6133799003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?T9CcZiBbO3LT7yZf9cEXSkwrg2bxLjwZTnpkRmy/v4bx43NE38Gil6YVydEL?=
 =?us-ascii?Q?5jtekRuesocegM1I9Ggmmf+LaKfesZh8JcVt2CTiYxmmu5qobN+ScBLzHFXV?=
 =?us-ascii?Q?U6vEYsh3BrbyoqdGI4SbZ8jbkkONZ2FN7b6OFqi6BAgi5l/u0ljHzZijp0aJ?=
 =?us-ascii?Q?PUJQELO2tBZxgt5C4gL8DAqAzgglnIz6IqG3A0t5MRqu9qM5TdhNRy4mZvHd?=
 =?us-ascii?Q?EgZZH1TnWmatVaeEDGRAqFn/o/uHQwfOcX042vhcFfnC7EZf2moD9ujUYpD9?=
 =?us-ascii?Q?y11CZovsanXntXUpvA9kVEd03X6uW5/fBxayN44UQ2oNWEv/edtz8FPtLagI?=
 =?us-ascii?Q?EUIF0IFiYfo/adJlU+mGOfGOWy0lDcIbj9Vy2WiLa2GRbAHJkwJJIqL09ug4?=
 =?us-ascii?Q?5Lir5wRB3YzlF3sOQmLSW1Vb5B0DVQbfFaI0XyUc9kyc1E+zol/zV1nHjCby?=
 =?us-ascii?Q?fpPcq3HxdTV0G2Hwm+z9QCV/rBHfyNb11zWRApk00ABGhS3Tb6iGuS0vI/rP?=
 =?us-ascii?Q?AXzYqTjzBzBesRgU4REzgfy4v7CmBcP0vT1YJ6xeNErAnlVAGKxZFw4dnozL?=
 =?us-ascii?Q?+SawI1KpUcKtxj6QYqDkjdpoTYxV9MGfmpwve8PpSYk7/YL7gcoTyRFTUZeF?=
 =?us-ascii?Q?ADsY0iWmc9COlznqZppuIOrwhyC9r1I6pn+tCYe6TQ8DICnyDm1TJzK16yPc?=
 =?us-ascii?Q?qA1+ruCOBVj5pdi1HFqR12D70ICX3VQSCOb4th80jGIurX9YROL3+gDiy3x4?=
 =?us-ascii?Q?MIAg8UY1Vxeaallwfc657KyYDi8y+pUZD+SWfodz7ljIxiPaviz3tU/LZvrX?=
 =?us-ascii?Q?nxU3i4VKdtwo3OpZjIw3A1TjkKgOdOPp3bDHmFqYHUZ+ftXpxByl0jtaykUC?=
 =?us-ascii?Q?X9rfsAPx6cOAnuvgw8GbORPLW2TAncrDfZTpglNrESdo0s0oooTWzAeuHaJH?=
 =?us-ascii?Q?NRF5nLksypv3YdTIUUP/pnH5kApRV+/NdunNtmpzUA4ANGgjUZYaG81sXtr8?=
 =?us-ascii?Q?44YTnOzcs7KzZbDsRSOQeNK51OyZzYszY4f//3hMQnPc4Z5L0frCQZomrq8l?=
 =?us-ascii?Q?+CX1yMLRxtYcbFvfn9gwltrk04R5kbEoZUHKZ56aUl9uc0lPyDrnU3xLBtum?=
 =?us-ascii?Q?oDKUgmBNunrZllNLwp5g5mhj2PhM2Af6kdXdf2lvtSHwP1qnEhBAXaRD+4w/?=
 =?us-ascii?Q?e9okP9nyIn4fOd/SPPEyzIxEJNyKX6+yEsRACwn8Gr7enxi2rie+E9ifryhZ?=
 =?us-ascii?Q?6dAJ88Yp/0mxOWhFW+h46Sxyx5NrHoHW+EPtn/0HVhU3MmSMYe87WZQrcHYo?=
 =?us-ascii?Q?AjupOSsWdSdQvi6yB+5S1Qg6/n5PCBe5ANY5HnSfqzZoiVfXT+KtLLVuyTR6?=
 =?us-ascii?Q?W2XXOtqdEJDriP9A/lI558VmiqrHN7AMhPt0Tcryp1Or0mkFjRaVpg+8Vebh?=
 =?us-ascii?Q?ZvS+aDtDfdLfRihOS9zmDHQwQpbPHpRas+DIzw1EfCntyt64Bn2sao9OqUL/?=
 =?us-ascii?Q?rLYayNDFc3+OV1UGJxY6elb1N1ElJrp0ehanuTOPf33xhcZIbIlB3cH0Ag2l?=
 =?us-ascii?Q?UD9gm6bjswUpbvZRu9j9sIjlHlXO8l4ZA21gObkT4c3dq3NH5ZIxsp24qZ16?=
 =?us-ascii?Q?kHkdbvM/ibGnt0RrndvdYLS26nwj8vfWj6NYbYsET4beRkUunLRox5EP8l2h?=
 =?us-ascii?Q?N9CNQcAKS0Zae8kZ4IdOIuGfZg5LcNTGwuGtdR5fQHPL6bh8?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8166314b-14a9-46f9-2b9a-08dedc82600f
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB4995.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2026 23:49:25.7504
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7NJqxPDut3brSZSsK4e+z0n/BtsKEbw8+xe1TH6tYzIVeWHNkK35OmQTxqFA5Ww1x/HqPwf5d1J917tBL9CyXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7110
X-Rspamd-Queue-Id: 4FB85A0007
X-Stat-Signature: qa6ycetxpzzpm1fd7yj8syxbwenhiige
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783468170-117260
X-HE-Meta: U2FsdGVkX1+vMbVoQIqz+LaDuojzSniKPjkRnXDS3UFocJWxi/2YoIw5EM3d0x1kNm2aghsGBtl0XJQM7juksNdeMV47mTianx9ihybdaL9lF5PEALjyhuasQ8VM6xzhDMkoDRs450x5cV1iq/sAGeQNUjLUp173UfgTYG6O491QAR36LWfbZqFPMkLFgneeB9nVI+2L6UZsh0YS69MTDuXuSy/+ll1arj1TiQMUj4lL3xjTt5u222/DNNJiYSm68wZtKPtZfv/MEXy8ekAUI8Ut8SOQZRCcX7SrzA0OLGWGPHJRvCqQPzbhlDHwD4kh0jIcYCHvv7/r9w3/gaZIRucMr+3SNJiVVzsld/6rCE89yjJHVtuzDHWJoxC2MbwaSfj7bSnq8P7IHzm0ZPKL5Doyg5iEzDg1oEHK6AEu0/9TpOY2AiV/5S8WWbotGI/W9iCxr4Tz2+isvhumHrcbkO+7G8Kgf+Bx3PQ3c5xa5biQ83+J990K6ySJSGqZlASbks2zcYVvPFutMKK66eE7TFXwxslFOtUCUC8Q+97fbPKh/O5HaT16D6qc+cyQTQSRhO/MKFK1E2qHtAMBpmM1inZrtXk4Gtng/HgR5BSIESF8VMnEcMEsbzXdD6uoXm7x/58xDMhrDpyRmG/CbCkV32qdiSc5WiJBvPKRUvvzeGc8RQ1YMTRF+WCFC295dIKYRlwFiQpqG2cmlZf+f7PdNwWb5KJCA+PREnCMEOgFu+TJxLOjennIXiBR0z08YVw6dYSnN2a8LTpgV1XlyRt7PlPHHnUMpkRhRANwKXKY0ACf2QzUUWZiv7z2lzGWfnwCBfCmEL3+k6ODvi2i52bc/v6ObUp9tETX5J6N3ovejR5NoLy621qQ+LS6PLK4cwRz/0iXvQ7hifeBJrHWAUhH6yh6BY4y5RT7HYtCT+MktVKdgQfeAx1f2DZ/VE9GVvRh7Wizsf3L8qNJZ79IRJo
 6lMZjLtb
 A57hIz+8CEwxtH6q+/+5oM3QwtPOf+56Ypan1jTnjjop4YM6YbFg7KfFOjz9eoTXNFSHWXEakH+Osb1kMB+PMbr1rd3KXoWORffYNhxydUJlTVVNwbH9ineE8Su+Baill2PPSHyO32JXPH1dQ2/lnu9T23MIISVO/1Ln3wYP06HQ/MiISsu/gtGo/BjOg9+q/Q+hpACeNrG9FW6tV3nJUSV8OQM96d98ExtYaMbOG6plu4xweXhiP60FT5KQnB/J40vlisRKA6RInuhEkKrOoAFCDeump4bS8HxVzv0AhI5WaZXXK6Hey5qcDUlPNaoE9WFQacf1MvVoJbm6ofD2t65d1A9uRLPrDzOeb+p7PsKNy2K7j7i77OGxXF9AgPXLP6jf1P/M2uTdXtdvcVLlIdr0MzzqatbetrrEAZjkZ4mLs3luv40k5El+dC9m3F+/ifW/i25kheyc+v4SHeoaFcOOjvT+rAgfArfGZs2N6BmNPeR5o1U/4IAVWzRcM5L2F4yPwao0JTcdMtkQtNmHQYbISIAKVK7OviHFqkgTXlJGW3cJ2t6wZCBP5HQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 07, 2026 at 06:45:07AM -0700, Usama Arif wrote:
> queue_folios_pmd() is called under pmd_trans_huge_lock(), whose
> pmd_is_huge() check returns true for any non-present, non-none huge
> PMD - including a device-private swap entry. Passing such a PMD to
> pmd_folio() extracts garbage bits as a PFN and returns a bogus folio
> pointer.
> 
> Potential trigger: an HMM-based GPU driver migrates an anonymous THP
> folio to device memory via migrate_vma_pages(), leaving a device-private
> PMD. Userspace then calls mbind(), migrate_pages() or
> set_mempolicy_home_node() on that range.
> 
> Skip device-private PMDs, matching how queue_folios_pte_range() skips
> device-private PTE entries by checking !pte_present().
>
> Reported-by: sashiko-bot <sashiko-bot@kernel.org>
> Link: https://sashiko.dev/#/patchset/20260703173903.3789516-1-usama.arif%40linux.dev?part=6
> Fixes: 368076f52ebe ("mm/huge_memory: add device-private THP support to PMD operations")
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---
>  mm/mempolicy.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 914f81863db5..eda817539c77 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -659,6 +659,8 @@ static void queue_folios_pmd(pmd_t *pmd, struct mm_walk *walk)
>  		qp->nr_failed++;
>  		return;
>  	}
> +	if (unlikely(pmd_is_device_private_entry(*pmd)))
> +		return;

The changelog lead me to believe that this is skipped via
!pmd_present()? Do we need to skip just device private entries Shouldn't
we set qp->nr_failed++ similar to what we do for migration entries or do
we silently ignore them?

>  	folio = pmd_folio(*pmd);
>  	if (is_huge_zero_folio(folio)) {
>  		walk->action = ACTION_CONTINUE;
> 

Thanks,
Balbir

