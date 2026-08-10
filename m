Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8ACEC5AD4E
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 10:01:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A37E86B0092; Mon, 10 Aug 2026 06:01:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E8B46B0093; Mon, 10 Aug 2026 06:01:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D7956B0095; Mon, 10 Aug 2026 06:01:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 54A646B0092
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 06:01:53 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5C9ACA2976
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 10:01:51 +0000 (UTC)
X-FDA: 85084918422.28.CBC999A
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010017.outbound.protection.outlook.com [52.101.61.17])
	by imf19.hostedemail.com (Postfix) with ESMTP id 541FF1A0004
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 10:01:48 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="qrUN/bIr";
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf19.hostedemail.com: domain of Christian.Koenig@amd.com designates 52.101.61.17 as permitted sender) smtp.mailfrom=Christian.Koenig@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786356108;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EO16WyduuBXiVMI+ZZ4vAVlt3lfFRsogvi1qNj0ZuxY=;
	b=RIJhyYSm/BqzBOSQhxUPEGmCU9sGCd/v+S/A04WIeuT8a5LH6yD6JkvYTzFealphAMlmxk
	YercgkgYXP50ned8ai6SCghR3jQg+S1GChMpThObYmOrEgoUrb1fOTF0EpgXNyWvKks1tF
	32LH0m6TjOwIxbyH8ErD++pEv1wfM0w=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="qrUN/bIr";
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf19.hostedemail.com: domain of Christian.Koenig@amd.com designates 52.101.61.17 as permitted sender) smtp.mailfrom=Christian.Koenig@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786356108;
	b=HVVoGkL/UYRQC0QPeL5tx5ww1nR3UEdqFg8tuKK4xSinjJm5uGZ/+eIuSlV4xhSIeb665D
	Tk2baIsDpaihfP+TiyFroEUz7qOrwV5VrK+0XyVUn9UDGQApPu0QqYztygwUCv3T4l860z
	xbnL6sCHGEu+dTCkH4BCGEsYTMvokcs=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n9k4DTxrPYIoMJiV2e63JvdOS9UHwORHTJhuHyXTcBXqYBHdJHgh3gr2B66rBnEgu4+/2QfBly12ngtSIxHpF1s8ICSP6LQuWdbQ+g8lP1Du4RmmOZFJLMZAwcdFGzOY2I+5r78N/KTHlmOmoLRCkphrfVshlgMuEqqxCNWRrRBOoricRfu7qB7TCx1R6Ki4Q24AIg+CBHmUK0KSfV1Zs1pQGfJjVqtOoyrnF4ftk0GiPXAyusM1Z5nlT1HH/TbWh5s1oPkv5r5lWprO17CAvwdhs/SMXr5Nj/qJ2OSryW0X85sqm1mSctPoj+pzOX8DB0R7XlAXgPVEX+qPQypi5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EO16WyduuBXiVMI+ZZ4vAVlt3lfFRsogvi1qNj0ZuxY=;
 b=E2qvkt9D6UkKevAcn4EHCJjrMIK18L5VNZExdwNEKGTP5OZ4ZhrT6KjNlA+eTirmwFVw9WnTP+TA6ruO6J5Chdyf07CdF0Y3qt0ALL4UDGVE2f84naepLW2w1TbUxbTI7PLEbZ4JMW0Tcb96SDOUeDwwq89WSp/AZ86OKsV1MRCbotSunhkNk5tf/G0kFXwIzBFXAwUoMcO3bC+Nto2qASp0FnbN58EQ20c3oPQeRbt5IDYHAtSArupLQ7Ast6iK5rENnu/zRhgDtTb3uUh07vFArFN/BEOFuFHHxY+89aIpNIxm14Gb0NdEebSCSASKfvHLbe79hAe22mt2fywT5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EO16WyduuBXiVMI+ZZ4vAVlt3lfFRsogvi1qNj0ZuxY=;
 b=qrUN/bIrFxp1fCf7inz3+88pmyVDnZJOro9pF+NniJBlR4sKgP4f95jPYwGXJqZD1bX4pBXjAu5AQHD5ZgdxLzAfBHvTO5XWu1NTOgtIK+zz9rkK9ktp/QCbqz6AvXwj8ptOCDz7a19x7mb1g8nbHOQWUYssWT4vVmOqlPo0oxo=
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by SN7PR12MB7180.namprd12.prod.outlook.com (2603:10b6:806:2a8::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Mon, 10 Aug
 2026 10:01:44 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%5]) with mapi id 15.21.0292.024; Mon, 10 Aug 2026
 10:01:43 +0000
Message-ID: <49840a84-6d73-4a15-adae-800eccfb1c7d@amd.com>
Date: Mon, 10 Aug 2026 12:01:36 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/6] drm/ttm, drm/vmwgfx: directly create writable PTEs
 when mkwrite is in use
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: Alex Williamson <alex@shazbot.org>,
 bcm-kernel-feedback-list@broadcom.com,
 Boris Brezillon <boris.brezillon@collabora.com>,
 David Hildenbrand <david@kernel.org>, dri-devel@lists.freedesktop.org,
 Fei Li <fei1.li@intel.com>, Huang Rui <ray.huang@amd.com>,
 linux-mm@kvack.org, linux-s390@vger.kernel.org,
 Michal Hocko <mhocko@suse.com>, Peter Xu <peterx@redhat.com>,
 Sergio Lopez <slp@redhat.com>, Sean Christopherson <seanjc@google.com>,
 Thomas Zimmermann <tzimmermann@suse.de>, stable@vger.kernel.org
References: <20260804120529.1730187-1-pbonzini@redhat.com>
 <20260804120529.1730187-4-pbonzini@redhat.com>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <20260804120529.1730187-4-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0343.namprd13.prod.outlook.com
 (2603:10b6:208:2c6::18) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|SN7PR12MB7180:EE_
X-MS-Office365-Filtering-Correlation-Id: ab804fbe-e7f9-4e05-83e3-08def6c66197
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|7416014|1800799024|23010399003|6133799003|4143699003|11063799006|5023799004|56012099006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	o0zOAskj9V83ajf4UiyMtQlA6PTxQfCB+05ywWvgYytjvb7a+352hA1BdIX2Zn7vNnHDMZykWSvX2T4ssj4M2etDOIUtFcNvwVdCED8HCw08G6mAqxko3cVVTfAu0hbCwXMDkd0ROjgnDYLoG26/8Cv9JIE+YOArR3D2F4yBmbLnetViW22NGou8bsllCHIq/oLbOg2QPqZ7/7CuNQ86qOXc0Cu9mFnci4khdjM2EV5HRBFL8OLKVH99EHzV+8Ci4O5SdRx4QJRUZgmchSgMo/IqkClXjuPjgdXLYWZLjuqhETHtrznoewWW3Ho+Q3gK2yp3wYa3jORiVnTy14pCOlg3NVk911VksHZOTqzaYiXrjBXi+RSThMyrNhVLD6GdFu0kjCTAj+k6dH1sd2IvRM4hQi/TkdbwS9ABLyVnRsTf0v31uETA9nn17VhdpVaz+/4XkgDoJyRfwHofxbjJwgvSGMeKKjAmIkUpN298joQP8k1exGsLtsQP92tn54tUlDEW7IiCgZw4B4VtD421rwZCLiOoI17HsW8KxYG6QL0A6ty8Lnnl3tYBOgD7elz2duVjEOPfbV8Jqh7khQygeOgMB/HkKDE5fv8jHrLuA+H7GsGY0vdDWst2wzeBOmRkp+4jNU1VsfFW9U1tqmKNm/d5aVDBGEq17e3s+AGuA6c=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024)(23010399003)(6133799003)(4143699003)(11063799006)(5023799004)(56012099006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SDQrTk53dXgrS1FPa0todk5tM1REUmpGWXVYclg4N3dMLzBoL1BUMXA1bkIv?=
 =?utf-8?B?RUVjRDcwelp2cWhrM1h2NGVJMzRaaTFnUGU1UzBoNlg1YWhUMkNaS0xaL3p6?=
 =?utf-8?B?Q3lWaVdiaEF4TkMyWUlyZWtOdHpNWVowWVBib25wQ05DU21sc1V6UE5tZEJO?=
 =?utf-8?B?RUUrWk03NUR2Y2EvZ3owZE8zQ0F1SDNUZDRWZHlsVjJ2UCt4ZWNBeDcxWDZU?=
 =?utf-8?B?TEsxa2FnLzUzOWJCZFBmL3l6WXpQbnRPOGd2bXNZZ21vcjRJdG9aZldRWVhZ?=
 =?utf-8?B?SDEyam1WK2huL3hJK2NhMXcrNGdpblpMb0E1eHhQM0pwd3lqREhrS2djK2lz?=
 =?utf-8?B?S0hTS1N4aW4xRFZYdWF0VW81aGxTYktZN3NBVUxQRU5qeTJsQTJtOHFKQWsz?=
 =?utf-8?B?M1QwQnVWM1lDazk5czJFOTZrUW1laFhpaTFaQlBHTkc5U3BCS29RdGovRjZZ?=
 =?utf-8?B?ZDIzRGMvd2hFNWhHcUdqN2RqdjRDeGQwY3pwUk00am1vTGNmbDhlaFc1ZSt5?=
 =?utf-8?B?c29xK01uZDRBWEErWHd6c1lJQ1hyRUliZjM2SkNJbXJ1RGFTekxWU0Q5cDdl?=
 =?utf-8?B?WkdwdXpNK1EyQXJ5VGZkSDRKdTNaYVJDTnZYcS9EZlR6SHVPZzFwYUpSSXpC?=
 =?utf-8?B?aVBja2l1K2dROWowOFBvMllLa0RhVlczTys0S3hTUmRXSnN0eURqQitidHJQ?=
 =?utf-8?B?Q0Ixczl0VGpZSnRoK2FteGNVMlZZbnpHeGR1aDl5YjJaNU00VjI5SFVlYVJH?=
 =?utf-8?B?QTZ1b2hwQWo3NWg2OEtsVUtaQ3dBdG1Nb0hHQ3FEbUd0K05WamxHQ0NBYjJR?=
 =?utf-8?B?ZlJaWmlnT3VqdVJxSVdLdE9nTUZjU0RxaXd2YS9sbUJsOTZjbmMwa3lLc3lQ?=
 =?utf-8?B?UHV0dUxJMlEzMXpoMm4zanUzL0hhS1h4MnIvVGM0UnhPalQyd0M4R1BDUjF6?=
 =?utf-8?B?M1NKU2hjZFNTSlpEN21CVnNhUm5NNnhCek4yYThGdS8yRlhEV2dmbFl1VnNr?=
 =?utf-8?B?dFdxSk9HbDV3MnlPQmdIUXF4aElCOC9rZUN1aC9KUTRETGN5VXQrc20zUlhV?=
 =?utf-8?B?Wkp2ZE11bi9rcUtVVU00Wk16d0dydFNUQlkzYmU3c1JadDRCcjdiTnZrNVVE?=
 =?utf-8?B?cHJWV0p3c29vVHgxUjFydDFkTk96UUtUSUhPcEtKUHRibWZjUm5kZ09NMUxE?=
 =?utf-8?B?M0ZyQk1sbnhKeS92NkFuWU5RekpLaXVTVitrVnNuRm9TMGg5NlhsNHB2Z2cw?=
 =?utf-8?B?UEpGbjEvQ01lOHNUMGRqdHlvSW8wT2lsWDZYVDRMUUIrWlJXbThhK005Y3Iw?=
 =?utf-8?B?L1ZhUWdBNERnOE10bzZMbDRUL3huZlNyS3phVEo3dldSV0ZVZXlkMTlkb1py?=
 =?utf-8?B?Wnk4OUV3V3JWY2tHRFVVQmlQZEd2bU5zeGxhYlhIY0hVcXBSZTFOakdrSEtP?=
 =?utf-8?B?Nlk0YWl2cncwUm9ZZnNwcFpLVXZ3cjhqVHN4ejJ1ZTFBaTRURkFiQUVXcWQw?=
 =?utf-8?B?aHVnRG1kNW00SzA1MjIxQWJURiszcUFXK0dwYmUyOElQbVVqSXh1dDZGUHhm?=
 =?utf-8?B?aEJTRWJiMHR2Q2w4TWRkcUFhNTlaaml2bmRSei9YeTl5KzZBQzhTNkNCUlRn?=
 =?utf-8?B?TWZmVFBHdFU5UVYyRjBlN3B5VzdEUFRTcTNSbXRTcExBVHV2R2RxMDlZWElV?=
 =?utf-8?B?ejg4cUJBNFYxTVk5ZkcxdHY0NU1hMCt4cVNHdm5LVEkrN3N4dytKSm92NlJF?=
 =?utf-8?B?dnkvZFltV3p5eGh0VFlxYWVMUlpxNExqc3d1TVptMU1SY0lrQzYxMG5vTmtV?=
 =?utf-8?B?SW4ydnBzTzNlTGJ0aGJHS3Fzb0lHcWpkMUJlbHVMSm5jQ2grYWx6bXpUdXFh?=
 =?utf-8?B?SDJScDZGbEdTNW43UjFHR0dlQ2pKTGJnSGNXUldMVFBpUGxSbHJvb01WWng1?=
 =?utf-8?B?WUplNVRFbVRBYm55WlFHMlNBb2F4b0lTTHp3MlFIRnQ5d3hMdlY4d0p3Z2FX?=
 =?utf-8?B?cG5jaWxDVlorTzI2Wk1naEY1NElGZVZybG9DV3NwYXFNN1NDQjJVNzZ1TDVP?=
 =?utf-8?B?ekRUSUNzTHZheXRsQUREaWdzcUJDNDJSK2RuRGVwU3VwVmJhQjBHU2FxTE1l?=
 =?utf-8?B?b1YxMmpEYW9iM3NWd2liMDV0TjJWLzR4MFUrbGdreWlWdE1WSnBKWnZKZzB5?=
 =?utf-8?B?emxXZFQxZW1uUU1vakxPbjZ2ZVdYRU9sY3h3Rkd1ZVg0d212WmhreW1HaHdR?=
 =?utf-8?B?Wi90Tys5Y0k0b1pWbGlzeENQRGViMU1EMEtFaElsRkRQeEhTclJIZm56WGpu?=
 =?utf-8?Q?xLJmRC2xofoZSyNfz2?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab804fbe-e7f9-4e05-83e3-08def6c66197
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2026 10:01:43.7923
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cPyHY4EJUF74HszscAWsFeO9Hfm/yE1fvylYVU1oks44TDkkehd2CQRthUCE3iPI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7180
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: 8k1rnes7tsn78cn347jhp1w1ciydbdjc
X-Rspamd-Queue-Id: 541FF1A0004
X-HE-Tag: 1786356108-425806
X-HE-Meta: U2FsdGVkX18HWN2qHP4r5ZxKryHZdfLahRTs37zAG5rO3R8rmDYEFD8dc3H7Lh3zsCnEQqI3xdZS2bWjSTq/Cvf5hRhrw00fE8XKA41MIkNGkEvvwdkMD4tI3IMiej53VmBMydKfbFJfkBsWR88FJuJ/gfiHnX/UrIDUaZ31EPe5A9+ebs1A1wA+QZzKJ6JijxhMTRgDvD5X2O7vUhq0Qx9OXpY2Qcv2JVOds0pffxyfrmakVLTbRvF3UzWt3xfxruBbW7BcEJJEpFvXg+O/PMMcz4lg5nIcCastezejU8NHpHTKD1NWl01DScZS2vMHG6HcSGJJUwZAbK0dx8AaE9k38uVU9/nQLa9mcxIh/jqRBriTxavAdgd+zimk41LwleZxLbfSHDk3XzfFnGEvWyoYmVoTxcrVxfw2mOKPNfeJfbQ400zHhwpZzR2bW3k0KD4aSCpDW4Xvk+AJXkm7TzChm6RZBKgjsCgjAbT6g7QX6LIV8QoPdvZDf3quvE1xQYs/BYbeNa7++INmQPyAwj0JI9SNHw07Gsx7ZTPmW9NnJbGXElzpuJLqECHjfqrF09joZ9hQS7UVKY+oa1LgrDVdFeRtXdfKB3dQl8wqrQc42SuEXOUWwJ5sDzgcy9I2TB0IPST6ClSGZHCrBMLJDbQ8cibqlPda3INsur8DvjkK5wE2FyN9cyvs6docY+1rVQEigWocUlIazIzOXVMCt0NjqnG11rtIsfhnFAiqSrZ4pLAVnJjxymWHTs3j6maKtJiMZ2pBj5Eh7NBgvSW/4Z5YTv8MMK183CWthJscLvpQQ6pJu/q6hxIhk0XUyUq9AyEYApaEF7KZBkxdGQs3mGAAQcAoqVjpzS5jc/u+1x9su282svGfi8o7AZUAKgWRyy8jeCorVtH/3mqyXFPYaPZ8x1lGdJ97esWbhkNxkA17IZOWhWEpcB8939IPAz5Nad2QACTPTrKz1APZRoR
 lbfxirWP
 xAceZxVFOHYLJ+I7aQhHzoZZTKZRRiP8WFrpMvwl7E5fpmc5VcgitVP/3H/vsPxq8hEAQBAHA2L3GJ0XnrOkdFDtaXV57mCcS6PTKWYon5aKIz6Dc1i1rmhmhYsTY5UMmV5VP+NCynZ72VBABDWFzaZ66ATzEGVkz3W94nm5LvPesugo9kXr0giVYyJMqV/55doszzmLDPKzVCImklpapzgpUmXUID2kobu/zbAWMHtWjqTcvU9+HVj6IpbEm43pla/r8P5UItp7h8Ao2bjIWctAkl4mq2TDSpgO0aT34l0QHZMFI0rT2OUl8GUrb6ppUv35dNaGV/+K+lNZo9CL8i4a6ram1lHagDU1oim0UcmJa2wHicj2Eh19TziBXF5Hy0IUnTv1AiHsZz/sQm7nbiHAbfY5mcAJvvprnK8w8XKYDyg8c6c//7jAYTHrs+7396h91XE8n49FKpOkEgihz1/8h9ZdlU/x9VAxXQE8JNtCwrOBOk4Hf15xC9PelxkrJH2apqsMxSUE8oU8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/4/26 14:05, Paolo Bonzini wrote:
> This ensures that fixup_user_fault() users see a writable PTE when
> they request one.  The flip side is that vmw_bo_vm_fault() now has
> to record by hand the write fault, because .pfn_mkwrite() is
> not invoked.
> 
> Prefaulting works as before because only the first entry comes
> out writable, while the following ones still end up executing
> the .pfn_mkwrite() callback.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  drivers/gpu/drm/ttm/ttm_bo_vm.c            |  7 ++--
>  drivers/gpu/drm/vmwgfx/vmwgfx_page_dirty.c | 42 ++++++++++++----------
>  2 files changed, 29 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/gpu/drm/ttm/ttm_bo_vm.c b/drivers/gpu/drm/ttm/ttm_bo_vm.c
> index a80510489c45..3ebde936ce60 100644
> --- a/drivers/gpu/drm/ttm/ttm_bo_vm.c
> +++ b/drivers/gpu/drm/ttm/ttm_bo_vm.c
> @@ -191,6 +191,7 @@ vm_fault_t ttm_bo_vm_fault_reserved(struct vm_fault *vmf,
>  	unsigned long pfn;
>  	struct ttm_tt *ttm = NULL;
>  	struct page *page;
> +	bool mkwrite;
>  	int err;
>  	pgoff_t i;
>  	vm_fault_t ret = VM_FAULT_NOPAGE;
> @@ -242,6 +243,7 @@ vm_fault_t ttm_bo_vm_fault_reserved(struct vm_fault *vmf,
>  	 * Speculatively prefault a number of pages. Only error on
>  	 * first page.
>  	 */
> +	mkwrite = !!(vmf->flags & FAULT_FLAG_WRITE);
>  	for (i = 0; i < num_prefault; ++i) {
>  		if (bo->resource->bus.is_iomem) {
>  			pfn = ttm_bo_io_mem_pfn(bo, page_offset);
> @@ -263,9 +265,10 @@ vm_fault_t ttm_bo_vm_fault_reserved(struct vm_fault *vmf,
>  		 * at arbitrary times while the data is mmap'ed.
>  		 * See vmf_insert_pfn_prot() for a discussion.
>  		 */
> -		ret = vmf_insert_pfn_prot(vma, address, pfn, prot);
> +		ret = vmf_insert_pfn_prot_mkwrite(vma, address, pfn, prot, mkwrite);
>  
> -		/* Never error on prefaulted PTEs */
> +		/* Never error on prefaulted PTEs and never map them writable */
> +		mkwrite = false;

As far as I can see that is a really bad idea, we do want the prefaulted PTEs writeable.

The whole prefaulting is essentially an optimization for cases where taking a fault has massively overhead (virtualization for example).

Wasn't vmf_insert_pfn_prot() making them writeable before?

Regards,
Christian.


>  		if (unlikely((ret & VM_FAULT_ERROR))) {
>  			if (i == 0)
>  				return VM_FAULT_NOPAGE;
> diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_page_dirty.c b/drivers/gpu/drm/vmwgfx/vmwgfx_page_dirty.c
> index 45561bc1c9ef..3099558c0762 100644
> --- a/drivers/gpu/drm/vmwgfx/vmwgfx_page_dirty.c
> +++ b/drivers/gpu/drm/vmwgfx/vmwgfx_page_dirty.c
> @@ -398,15 +398,33 @@ void vmw_bo_dirty_clear_res(struct vmw_resource *res)
>  		dirty->end = res_start;
>  }
>  
> +static vm_fault_t vmw_bo_dirty_mkwrite(struct vm_fault *vmf, struct ttm_buffer_object *bo)
> +{
> +	unsigned long page_offset;
> +	struct vmw_bo *vbo = to_vmw_bo(&bo->base);
> +
> +	page_offset = vmf->pgoff - drm_vma_node_start(&bo->base.vma_node);
> +	if (unlikely(page_offset >= PFN_UP(bo->resource->size)))
> +		return VM_FAULT_SIGBUS;
> +
> +	if (vbo->dirty && vbo->dirty->method == VMW_BO_DIRTY_MKWRITE &&
> +	    !test_bit(page_offset, &vbo->dirty->bitmap[0])) {
> +		struct vmw_bo_dirty *dirty = vbo->dirty;
> +
> +		__set_bit(page_offset, &dirty->bitmap[0]);
> +		dirty->start = min(dirty->start, page_offset);
> +		dirty->end = max(dirty->end, page_offset + 1);
> +	}
> +	return 0;
> +}
> +
>  vm_fault_t vmw_bo_vm_mkwrite(struct vm_fault *vmf)
>  {
>  	struct vm_area_struct *vma = vmf->vma;
>  	struct ttm_buffer_object *bo = (struct ttm_buffer_object *)
>  	    vma->vm_private_data;
>  	vm_fault_t ret;
> -	unsigned long page_offset;
>  	unsigned int save_flags;
> -	struct vmw_bo *vbo = to_vmw_bo(&bo->base);
>  
>  	/*
>  	 * mkwrite() doesn't handle the VM_FAULT_RETRY return value correctly.
> @@ -419,22 +437,7 @@ vm_fault_t vmw_bo_vm_mkwrite(struct vm_fault *vmf)
>  	if (ret)
>  		return ret;
>  
> -	page_offset = vmf->pgoff - drm_vma_node_start(&bo->base.vma_node);
> -	if (unlikely(page_offset >= PFN_UP(bo->resource->size))) {
> -		ret = VM_FAULT_SIGBUS;
> -		goto out_unlock;
> -	}
> -
> -	if (vbo->dirty && vbo->dirty->method == VMW_BO_DIRTY_MKWRITE &&
> -	    !test_bit(page_offset, &vbo->dirty->bitmap[0])) {
> -		struct vmw_bo_dirty *dirty = vbo->dirty;
> -
> -		__set_bit(page_offset, &dirty->bitmap[0]);
> -		dirty->start = min(dirty->start, page_offset);
> -		dirty->end = max(dirty->end, page_offset + 1);
> -	}
> -
> -out_unlock:
> +	ret = vmw_bo_dirty_mkwrite(vmf, bo);
>  	dma_resv_unlock(bo->base.resv);
>  	return ret;
>  }
> @@ -484,6 +487,9 @@ vm_fault_t vmw_bo_vm_fault(struct vm_fault *vmf)
>  		prot = vm_get_page_prot(vma->vm_flags);
>  
>  	ret = ttm_bo_vm_fault_reserved(vmf, prot, num_prefault);
> +	if (ret == VM_FAULT_NOPAGE && (vmf->flags & FAULT_FLAG_WRITE))
> +		WARN_ON_ONCE(vmw_bo_dirty_mkwrite(vmf, bo));
> +
>  	if (ret == VM_FAULT_RETRY && !(vmf->flags & FAULT_FLAG_RETRY_NOWAIT))
>  		return ret;
>  


