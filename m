Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44D62CD4851
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 10:08:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D6D96B0088; Thu, 14 May 2026 06:08:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 788056B008A; Thu, 14 May 2026 06:08:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 675FE6B008C; Thu, 14 May 2026 06:08:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 54BE76B0088
	for <linux-mm@kvack.org>; Thu, 14 May 2026 06:08:49 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BF1088D82D
	for <linux-mm@kvack.org>; Thu, 14 May 2026 10:08:48 +0000 (UTC)
X-FDA: 84765601536.21.47C2B8A
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010052.outbound.protection.outlook.com [52.101.193.52])
	by imf21.hostedemail.com (Postfix) with ESMTP id F3B941C0005
	for <linux-mm@kvack.org>; Thu, 14 May 2026 10:08:45 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=JpJmjtKI;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf21.hostedemail.com: domain of icheng@nvidia.com designates 52.101.193.52 as permitted sender) smtp.mailfrom=icheng@nvidia.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778753326;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xWmlYlH9jJLiTBOfxPGO3CfR5xmZuAUdRBiVD3G47bI=;
	b=CbxozssdmP2ICqDx0hOXi6Jb4k8RgNafM9mM+ESXhKyTT7XzCzLdvqpmi755w+f2N+N2DL
	9LAgyurVdThYME3h7d+Y6+7ZWKRiTJhSScPTIg5mw5t5rDX0zrUU19KCs7HGfFh20FJ2A+
	Rzh5f3uOllvtsutz5dFwZcI93bSQ1LM=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778753326; a=rsa-sha256;
	cv=fail;
	b=QrFY/ERotZ3Q9FM8EuNAdfPVIBlRbrck94Sy9rIgtcPHDPJTqs6W3hOhH9+y5ojsIU/fTS
	oL1Bu1FBwtVUYZC+GEGBG7Wx27xxshu9fPo/5NOIiehlVvujJL9Xv5Dc7aAqi5BgbDQ7kr
	QiW2c4DYB7C6NJRtVAwBwcdjvG+UVKQ=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=JpJmjtKI;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf21.hostedemail.com: domain of icheng@nvidia.com designates 52.101.193.52 as permitted sender) smtp.mailfrom=icheng@nvidia.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ausIJT0rMtvxV0vFGPEhUiApNhWNHgVMmQsGpO0SyzsexnR43RgzG74NMqyYNDVIAxnEjQta5WmORmY5RieKGhfnS/fdrKN1Ce2dv/u2efP4hcyANluIpBHbQhgKwNJYe+j0TlEEDDB2s8PYLhPjSeJ2nQQ1HtfmdobedWXanTB6IAAbAHpogIXOoBF7yoOw+KnfVVN3cimLNrm7A1SfMGGRE3PFm8pNhDS8Ko+mVASeFWPfS6Ovled5i7UzhCedIDkEYQ++uCm10IALXCdJbztjwM9wvl2NLUc+QmpJEPwOVOpeaDKS7VXaHZQcmbtz186rX/kNXmcF+Ybr24vMHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xWmlYlH9jJLiTBOfxPGO3CfR5xmZuAUdRBiVD3G47bI=;
 b=l5cFexddDyvsVXTkttaZP7VC5evfX4o6MLk5OXZLs+ExDnRr34oBm1Yi5MJDteAfsjm+qSN4Oeb9Re1FXAcUl8i9o44a8tPmJ/qJTrphj0DaPlYAAykctIp3Us7GXJBbgHsDuNNQdhSDPTw8f3pgQ99XqykFso92LJaleWN5rD3fY+1dA/yHY2O0E90/+OTvViphwv3ndE8fstaScA/moM8eu74sLzMkX3HykaU7QtqJXBvzafpjxEDzjPhbt45BpH4EWQ9UPRT6KWRsH1Sk73JFVYqqZ2ONS3tG0Hx1bzoxSGWYtggpd57EPL3D9u0Dc1MS6NMXKA7S7S6920hckg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xWmlYlH9jJLiTBOfxPGO3CfR5xmZuAUdRBiVD3G47bI=;
 b=JpJmjtKIWsNENYEsGK8jDhRdgZKkltovlii1BA1wYxWSYKpbEi/PJCzwGk8NgIohu7X64NOk73U3YFukWe8NBpl+XQ/5TPBItx5LsB7DCOoexxhdvlutwuQ9PzBEJHwuHMnoxCRJLM+QyigJzpMQLEMgGTpdPYf7sP/UOESXw8DLPS0fvjtaGlSnyp9igHwzZIIthIq7rHR2lirzp0o+X2E6U3hmi9M+1Bm5S8s22vQ2CYdO6e3T/T275qmgsJ8keNPCkKCZ0J6sCbYoavTaKtqOQDYOsuSnjsZ55EirGQYEEnlK4N/ywN190S5wXwcy1QvoDpdItvayRuW1ogWCsg==
Received: from BL0PR12MB2370.namprd12.prod.outlook.com (2603:10b6:207:47::27)
 by PH7PR12MB7378.namprd12.prod.outlook.com (2603:10b6:510:20d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.19; Thu, 14 May
 2026 10:08:41 +0000
Received: from BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8]) by BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8%5]) with mapi id 15.20.9913.009; Thu, 14 May 2026
 10:08:40 +0000
Date: Thu, 14 May 2026 18:08:33 +0800
From: Richard Cheng <icheng@nvidia.com>
To: Georgi Djakov <georgi.djakov@oss.qualcomm.com>
Cc: akpm@linux-foundation.org, david@kernel.org, linux-mm@kvack.org, 
	linux-cxl@vger.kernel.org, osalvador@suse.de, gregkh@linuxfoundation.org, rafael@kernel.org, 
	djakov@kernel.org
Subject: Re: [PATCH v2] drivers/base/memory: set mem->altmap after successful
 device registration
Message-ID: <agWdpyIfYZb00oOi@MWDK4CY14F>
References: <20260514092657.3057141-1-georgi.djakov@oss.qualcomm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260514092657.3057141-1-georgi.djakov@oss.qualcomm.com>
X-ClientProxiedBy: KU0P306CA0084.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:2b::9) To BL0PR12MB2370.namprd12.prod.outlook.com
 (2603:10b6:207:47::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR12MB2370:EE_|PH7PR12MB7378:EE_
X-MS-Office365-Filtering-Correlation-Id: c4fb2c76-3045-461a-6ce8-08deb1a0c5d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|18002099003|22082099003|56012099003|11063799003;
X-Microsoft-Antispam-Message-Info:
	RmS1eKXEeMqGtqK3OsAAAq+oxy6+XdyxiZ/WEXejKqoKF//YfvMmL80u671xxUlNmskBwuAogb2PuSCmZUiGbcywpUX48s3Rwjmho+COaPrKt3QyGXrBZrxcd8JlkuIbcalppkoUKQsrcDt/+ga6RhY+ZjISiXa5UfQcv6cw4g4mvX/9tmy8Ox6AIqmNTcrRe3l7xYcRa5pDP9by1mOAfIWfpt4kSB1RfwrBm7LO7gvMktnUBd7iZpRLVqbcuXR8SjH8nKr5yCB22jz0wbyiWWXFKudvfQobi7dev2SLTAmOvWasdyRMbN0IouwAUdQRI7scYjtLvKg+UNgw1uJA43zrcTjVJ7qbjvx4wOnCLQ7cBmO7auaCV9UWIoVvbgbYv/2AY7WF6BURqKIgQoc6csGFO2pFAKTh+kPXbWA0LvdTNfc8+Vr0uENGBwg/YFknmqen2/+kfyS3V2Du5khJLfsWkBns0zDmV2LrvQ1sMgQXggjCfg8LtpOt4LZCcftDhqlQb1xky8lo+Mj1sMt9T8GqTo59exGrBJgpOC218Xis1cRPjPrDtSP6rj2eDhm72XNT/FnBD95/vdKAGIxonRXJJpQuyanla4clGIXrgoQZ3kGZzgWCOKcfQcx+RW5+VyYliQc0uzdSO/lhvzUUcJ68cV7/xK4tXd7hKWIYic7ZDZHfAIHawzoA4qobteap
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB2370.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(18002099003)(22082099003)(56012099003)(11063799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Z9GdKVUz0zfxQkbYryjJI5zrCsX0GTGL4KfHV+8Z9/4PglTI3loQ2iDyfWdR?=
 =?us-ascii?Q?+nHAgULd181sNSqpip+ZteLid0uXgd2ji4Kh0FxF0tNSK+vc6uJqnFsBXo7K?=
 =?us-ascii?Q?++zmGj8w06Gi9ysHukzBeBd3Mq9qwoQfLrlDs5gHFQF2Kzb1FnefK8E2Jz3Q?=
 =?us-ascii?Q?9bSfSS8djWBjIJG/r1X+l/nIZQlNIUcS+OVgyN2yZQfvZz51EJej5YiN1r2+?=
 =?us-ascii?Q?E3hdCCHkuY1+rDtWkRA5a7HtEpUxJi9Rjvgxf48j1Flgq0X/kqOR8pOy3Dp7?=
 =?us-ascii?Q?7qOopnNkrolaSR1d3XfmJWn3CRkzb7RH/9QWDuYa/wsE5JA04IRABZX9tWvs?=
 =?us-ascii?Q?H9ZbaM1Zl0275UYHSCTl6YhoKIlOiSk5DyIBSH+ks+N2icEDrFEFo/YL6tLr?=
 =?us-ascii?Q?AXdwe6ndfnCWlpWc0uUCkAN1nE1Wp4R2Oof4gEI8RXFndevL0G/VJkZ4MRbA?=
 =?us-ascii?Q?nw7/YIecC9b4qfLPoUkekY2CdQSEnXrzHWDQhnugITyKUfr452TCV/oFZ48B?=
 =?us-ascii?Q?c3bDy0pkz7+OgwR7a0ayYFPv7YV+wIQkWrwEQT7j5GSq2dkmSMr0J3jcNCJu?=
 =?us-ascii?Q?zSUoilIxCqe4yWksb2NDUIbV4PH8IFFMVko40enVhfWhGHfV3cW75Lzz9iZY?=
 =?us-ascii?Q?fBiXB+Jn9qWjQgJt6b83zJ6t/SSA8J3rtGabEzJJ3YSL+ZxqyfPtqlVrtnzq?=
 =?us-ascii?Q?mTeOO0lbeph6Z93Y3P/B4m5UceVRY+RjIXcIqGrPCeRhaJC7VvIVeL/gMM6F?=
 =?us-ascii?Q?Ha98eTb+aZ+871k4RCX76tRYt0obOP0tHUcG8aqTdjFRQWKBapSd3v6wmsBG?=
 =?us-ascii?Q?ZiL1SO114pC2QqAWF8tlwCqZ1SJ8sJAiee3n5IyJyo0slUKzUDnAG3Yimnz1?=
 =?us-ascii?Q?PgIFO9L5VUCIsDlU/pQeEgQ5pH48DZfVeBiLLRQDscVekW1eN4VFxv5O2zot?=
 =?us-ascii?Q?QR/HbiZC7d9v6pjkuRG2MyFiDtKgISYlFIIhj8/fuAPOfeeplyhjtb2eRNsZ?=
 =?us-ascii?Q?4kNviudUFPIbVKsUp7clpKLAfP+VupChoic6Aok+aIFkp2MSya8FcmMotZq7?=
 =?us-ascii?Q?JN/6W64Drf9EExrIV7c8xNu9OrM4li7MQmqkrCpLNOLqRza7Z5r2I+sL2a69?=
 =?us-ascii?Q?kJr/nrgZlJ6vBc8LXJHKYS5pePu0A1rivl+CJE+rC9R+dW2OQDBgGy6nAc1D?=
 =?us-ascii?Q?c1syn2p7FQGWAdwDxRGXiDtKdG+td8CG/Xr/kn2w5clJTji5/VqkdmXKKFeU?=
 =?us-ascii?Q?OoXug93/QMOxq/iTQvc1WgyEErpoIa9hQ5FgBUG/jLvi5xwJeSWpIHY35m9D?=
 =?us-ascii?Q?pWILAEpCEo4q3ka6EdKoA7gX/IYT2vuSSzwpxPgXmOeJzM5v9Bxy939Mcbqq?=
 =?us-ascii?Q?bG/wocN0Aibw0a32aOGkBr2BEkhgc6KGEhSmXB/eqf+hpTWmr7QhZr0DZu9z?=
 =?us-ascii?Q?8LmCnxy3HebkXhEAvf4FbDPkGzk9z8qE2KEXXsaDn04K+OJ8M+c6ZqhoONWG?=
 =?us-ascii?Q?5kZye+zX6iVkelXzUe6Pl9XAQLVjsNwc3KtcNLJK4lmxr96T504LD5MQ5kQj?=
 =?us-ascii?Q?0ogehN4UOmNwTsoGF0f97u5niMmwp6aYoN3OzSjaxtHsl5G5xSgujK9Q5Lpk?=
 =?us-ascii?Q?GYJtfz45DsurQjXBm9+tFomoAXWx6E36ZXa57CTggKHr58rXRillPonwqrCX?=
 =?us-ascii?Q?0fapyhZ6fHfuO58GSWGRE+6d++LRNIDxMtL1QR2BVNM3XIrYNlQVx+JgSDa1?=
 =?us-ascii?Q?YZij08a/dQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4fb2c76-3045-461a-6ce8-08deb1a0c5d3
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB2370.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2026 10:08:40.8885
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7PHQ85jPk7Qkby4oGsCuTbS0WYXKsEZouYp/lgnJOikwYxR50Wd8XGifK51EO0QCbkNM0vXVVkPu+QEpXNg+TA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7378
X-Rspam-User: 
X-Rspamd-Queue-Id: F3B941C0005
X-Rspamd-Server: rspam04
X-Stat-Signature: wnwnnje99agtd7554g9ghhxrubx3fw89
X-HE-Tag: 1778753325-943484
X-HE-Meta: U2FsdGVkX1/C4xjK1kwN4RPW8DvoNdAGxxyVDb71XMEe6qMqwpZ5LrubfkkjSEL7aFNw9ywWKhnyfas5UYgzxrCKkHKmgOYLyDoMGwqXRdWEHmIowL+fD1vsvQkn70zr8Qmtb+nbYwDtMDoWN+5gc8/g2OZkynv5oK44Vc4B+xwH6syuiWGc01gqYl6Knqu2HypoSBlLBCL9xrvEPzEAjvBABrE5LNsQr1kSxA+lSP7H1yq2hOUoQwEQth7+AWR7eInLXXsHRFnM80GS/u1nOO8Sg2NuH6UnIDUjwFsiBQni4wuVoIEJfHMNQcTTB1st5RVU6PQiIc3KDCP3wgh96SwWI6bFoDBajQsPPe6NvV9QlS1tTo7AxQUqgN72iX29H+4jx3NF+G/hdDvOm3HM+/jOpr+6V5ZQC/fXZbk0YRkRLafh+QXUBNJIuBjBrw9zBhTCTHdCdvs+TULx+vqotGIWhrOtOJBJmAZ/v0nel3/VtXzb+H6lxG7iHFv4MMHQ+cSUgry4jn81twDh8TAq2sO3tqeIlFVOykN2QNbUBM8gDcAlcHuwXrsuenwec1Nt5jxQl7FV7KsgIK9/TDgn2OxdrayQeowrdaeEYnNHDDtRuOTt0aw9Pjl3O377M6Mj51hcM272FTtwlMDcT1UX7wn7WHOxhfOhVCjnvE1gogsjAqB3L+bWJIMhk0dsd5CGJVRECvSDjzeMQpQhn+kEst4ucvDrSafczeDIp1S4UjQMRBWCPPYqtzj+gmLup+MUhu/Y6NjmWrPoPyY4stMcSvHBfZBMZe7+kZoCeQTGbLt5KTW23Hhx7DPIrcbV4jwDv1kHehpaCyGlKGFpoj1T2UOcFXH1Ta1hyBGKYGvv485q9MSybC1Efd+pKvYPSm/GqO7PXdVlml4xuyW9HgUrTErN2kJRz2okj7iUAMupAmdkciHbevSREbmP/tkaoXJr7U287MD1EvYrcDOqgdl
 S0jdHFsq
 9+9bcgDoO/3Ld9bM+hBNakp5lAOx1ZkVLdxKTehop0lADYR613nZmA44eRaEVpga7A/DL+vZ5smRM/VFYy0mecwIWrWx4pRkjdZnnJ0Dp799w+noHlSZzy0saLSarSJKLakOtVuSPoWKLZj79pEH2Y47nKPQ9JkW3mnUi9pF2AhUXaJigeUqxeerlFa08D3ekneQUeF1AqFsoAMmtM4VdQbOFHOenLnraNS0erZv7xrtkfoVo+GuhMb1Q4o0aPSpAIqdyunnqcgp7rJbhyhb1ku9cgytkB6VLSeETmRfhnPhd7006gYogXl9KJCbBnoLGspjWDmwCJfea051XM2TlV+N5ZQJMjHJdC1J77lfGS0GclADAUGIpVcP0GhWxMUN3scgvi9LZNN0tZ5qvgGVkxpuwZ9pXiRQx8hclWF+VXkgzHfrrZSH64No7V1qrRHX7qQfp06+5PVL/TYIWzEHgQ4797ID6yoDMcA3ny9Yz4N2QY3LZMzvuxtq3A4PhyKpc3xsjzizLtzP7d058ItLtGSaoTyBlQIC/dDIuOHxeDcp5Jhk0sBr8Akr+UAlIY1MTfUaP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 14, 2026 at 02:26:57AM +0800, Georgi Djakov wrote:
> If __add_memory_block() fails at xa_store() (under memory pressure
> for example), device_unregister() is called, which eventually
> triggers memory_block_release() with mem->altmap still set, causing
> a WARN_ON(mem->altmap). This was triggered by modifying virtio-mem
> driver.
>

I see you mentioned about some out of tree virtio_mem patches that
can trigger the bug, mind to paste the tree link here ?
Just curious.

Best regards,
Richard Cheng.
 
> Fix this by delaying the assignment of mem->altmap until after
> __add_memory_block() has succeeded.
> 
> Fixes: 1a8c64e11043 ("mm/memory_hotplug: embed vmem_altmap details in memory block")
> Signed-off-by: Georgi Djakov <georgi.djakov@oss.qualcomm.com>
> ---
> 
> v1: https://patch.msgid.link/20260513130900.2204499-1-georgi.djakov@oss.qualcomm.com
> 
>  drivers/base/memory.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/base/memory.c b/drivers/base/memory.c
> index 11d57cfa8d72..78e9600e6d45 100644
> --- a/drivers/base/memory.c
> +++ b/drivers/base/memory.c
> @@ -807,7 +807,6 @@ static int add_memory_block(unsigned long block_id, int nid, unsigned long state
>  	mem->start_section_nr = block_id * sections_per_block;
>  	mem->state = state;
>  	mem->nid = nid;
> -	mem->altmap = altmap;
>  	INIT_LIST_HEAD(&mem->group_next);
>  
>  #ifndef CONFIG_NUMA
> @@ -825,6 +824,8 @@ static int add_memory_block(unsigned long block_id, int nid, unsigned long state
>  	if (ret)
>  		return ret;
>  
> +	mem->altmap = altmap;
> +
>  	if (group) {
>  		mem->group = group;
>  		list_add(&mem->group_next, &group->memory_blocks);
> 

