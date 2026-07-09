Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30FADC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 19:12:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0325F6B009D; Thu,  9 Jul 2026 15:12:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 008BE6B009F; Thu,  9 Jul 2026 15:12:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E13456B00A0; Thu,  9 Jul 2026 15:12:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ADFE26B009D
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 15:12:24 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3857D1A026B
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 19:12:24 +0000 (UTC)
X-FDA: 84970184208.27.8AA121F
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011046.outbound.protection.outlook.com [52.101.52.46])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4E961C0010
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 19:12:21 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=oFwUuA7M;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.46 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783624341;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=kEEY3RpJ4ViD0lrIGiVuLp9delb4RxLFIw0p43qHzEY=;
	b=Fe7tuEx72e+RaKYzC5JHMDHiI6sUvNGvxxPi/mLvraOW0NC1bJkq8L3NerRTpDW43GuVOg
	NgUkd+swCAGxpV6Asy9GtNkWZeIUrmU/Npeyn/qjeMfx4mXJHivUphYWdRV1UovO+RYiMN
	k4GrcZY56Vd0Pt8Kbv4rTwq1AmxyEXc=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=oFwUuA7M;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.46 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783624341;
	b=tWXvrk/d6isNSQn3IbxDUCWIuqXzqnRXGqSiW7xx5sslsDcswJrbNXyzLBSuR9r227JcE4
	uRidw5fBr/9guw9/8K8fXNWO1YIIY4PhGaVHjwiSJzm1V5uaxwo6JF+eiv7x054MDh7co6
	xFsKae0wqc7P6X5bOg1/3VUmvX/92Fw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hz4tu4SghpUCA5LqnuvfAuEJCUO2VrhKdYgM8M5IP8JqoflxhonAcrktRb38ipdP9U2/2aDfB/fcZnWtQAGC8Z1DcMVqeEgHG1vbxzMrnNtKC70qcdWStBeNfGcLttT/Vz0ZJ15dDg9L3LK9tZTHpYgah+vydEQPTMLM+3cPHFHICTAKeFfl0JinqLj/bbwT6kPAzj8KKazi3A04E6GThymgR119Siu5k9AXMprdJTYl2YESuCilgyQxsvyCBuenfjZE2rOelty6Ac3U//IpANUZWHbLFvvqpOHkpv4Vn4rq17mld/6WPJOvVpN1gSjl2TUCLWV0dfxo0LcB1aPJ2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kEEY3RpJ4ViD0lrIGiVuLp9delb4RxLFIw0p43qHzEY=;
 b=pQhxalBiKWLGwiYwe0yvqdaVrU0309GggLA/1XTNIdwjZ+RGb/FGdMh0oawQm6Mm7hm3eD5a9+DjRyhvvt125ZLnHlkMn8eu/VgY0f6LdIK8RnpnTnlTPn7ojZJTXqs2bL9PHh6CQZuzaWTVSnNVE1gVI814GBiUgOx+JVCPPrzKOOu6u19l0LnSQFJLYCpBVs6ShoSHQ9KCTNlMuh9/lgsOwq1AtKZCBKPTdjo50qAConJtdcy+qD0Oi69lH0ydvAucfaITfsXNEoRDUsbBXBj2lfchih6uUr0D+VM2YBiNbt6jSJLdbbFVxs3+toB1KPlg75MCQOFtYtPJwS4cIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kEEY3RpJ4ViD0lrIGiVuLp9delb4RxLFIw0p43qHzEY=;
 b=oFwUuA7MDOVPuTP9ydk+zOH4RQoGiI1y9w8bUOWwOVtCXoZP3KQDmEzxhjCylBnk2rIlNY1hvIDNXPi7Qj4bXklx6BUFESGJ+H+tga5UlazPewP0slyl74QPjhLzl7KxWW5fUW09zy6iLL1XVkkmWgsSpMs1hyJefszKc8nUAL+Crw2z0pySJqvOMvsvWXsItU6pUB+PrgkmQ2B6niWQQkGt5aPDvylq7u1EvXhcX9qgkFysKwA8exr1qyX/IXvZl+EoeNAwY0LfyXyPnMRoJDfxADkK1qER+NWsCSLzSnRHWeoUGy8oiP4AlUUUrFoDe0BJOOPiZGs0Umnk4xK8WA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by MW6PR12MB8664.namprd12.prod.outlook.com (2603:10b6:303:23c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.16; Thu, 9 Jul
 2026 19:12:15 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0181.014; Thu, 9 Jul 2026
 19:12:15 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Thu, 09 Jul 2026 15:12:01 -0400
Subject: [PATCH] mm/percpu-km: fix bitmap overflow and accounting in
 pcpu_create_chunk()
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260709-fix-pcpu_create_chunk-in-percpu-km-v1-1-1f64745a84cc@nvidia.com>
X-B4-Tracking: v=1; b=H4sIAIDyT2oC/x2N2wqEMAwFf0XybKAW1sv+yiJSa6pBtltSXQTx3
 w0+zoE5c0ImYcrwLk4Q+nPmX1SoygL84uJMyJMyWGNr05gOAx+YfNoHL+Q2GvyyxxU5YiLRGdc
 v1lNwbbDtWDUv0KMkpNYT+fTXdQNIB/XgdAAAAA==
X-Change-ID: 20260709-fix-pcpu_create_chunk-in-percpu-km-6dfa8f28b175
To: Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, 
 Christoph Lameter <cl@gentwo.org>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@linux.com>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Sashiko <sashiko-bot@kernel.org>, 
 Zi Yan <ziy@nvidia.com>
X-Mailer: b4 0.14.3
X-ClientProxiedBy: BN9P220CA0022.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:408:13e::27) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|MW6PR12MB8664:EE_
X-MS-Office365-Filtering-Correlation-Id: 225a16d3-dbe1-4db2-8fae-08deddedfcbd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|18002099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	Y1REvUd+ZNRkRTgA2VS3ZWRb1xd6zj5sEik2ZDTmhRiW7NBK8wJa2VP/Fk29A+q9K2JVDtHk0GD7JSZ0Tp/8bjsUHfhllxg0vUUexX2C9qGpT5ijwCe1FVuwOCCEUGJbfE8Fr40E9BY4VDPhD7qP/O2tQonx0oFsuuY+l5uZMnU7N3HbS9Hr34pCOdjFeo+vV5R1iADc93lkk9pjAw7ZEGUA4Jgx9yQyIcc+yzHV+y4MAysSk2pUkj7jqH2/Uzx85GHeqogUR9rLdhcqRTLGsYuOXso6tYN57XdyAtc7ZWo9DAi+8sLHbQWSExmlW4gG7MkOALkYqYO/XfFtga702E8sneHDu2Uk6aM6y9CfppjPSpTcIXl+O/3c/kpNY9+fgzQvDbIcbnuD1+Ar00uOtUbYr3Hzc6GNAnFPgCPN2J+SH/kjrp8GW0RisaNESNgdvsGmtVLgdMdLnxNuvD4BO82t3Xq6/OjJFlBDSjS4WP0q9FwzvdIPlDtzXpxVZic7GLhn6OtgpCCfgYWu7qcsg2D33qJ00YwgIcn7wbpKeAFuGo+bh16cZU2E+gYtSIEvHzAlj9hjDATTbmI4z1EagDdCjQidUxyn69fvhKaDghEbj8WPufWYm1WmFMAIH9cKQrKEq7UHQ6jqlphDv62+a5oqRyS2gSdcMa9vQZFTwSM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(18002099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ekFlb0JEcWRLbXlESE5abjBqaklSOGc1OWFFWUg2RHZIeEJXaEpvZ1JqRHBz?=
 =?utf-8?B?RENlRXlsTUpJTHRKclpGaE0yL2pFeXhRdklxU3hmelZ4YjJSbzl3dFFicjJJ?=
 =?utf-8?B?YjJpbjcvR0pleTF4QTFrVEdXWUFKSG9lNjA2bEt0OVk5eFlXTlBSYlV6SFdu?=
 =?utf-8?B?bC8xbmxkZXFib0lEOGpBVUpKOFY5N2lBMXg1QS9BTVh3TGZwWEpVdzlRTzdZ?=
 =?utf-8?B?cENwdVVrVmI4VXF4NEZVODdKdjRaemdxUW9qVUJFdXFOa3RQUzFHUmNwTXYy?=
 =?utf-8?B?eEtVbWc2WWNtSXBSK1BqOGo1VzRMQWtVUmdENFdBNmp4L214R09kMitvODQ2?=
 =?utf-8?B?SStNWUpFY2VPV05oMjVUY3NmaXVGQkVleE4xV0o0dk8rako5UitzQmd1M1dV?=
 =?utf-8?B?TTFJK1ZFYkFTTTFILy9xYXkvM1ovVkU0enNaRU52dTZsK1hHRHhFV3VNUk1Y?=
 =?utf-8?B?b2FnNVM5eitaQys0UVB5TllsNXQxN1h5TUNSNStEbWxGem9adm1OK3NWVjQz?=
 =?utf-8?B?ZHcxK2RwSlA1cVVqQzZoRlloVWlYNUhvQi9BRy9oRjNEbjkwcnB1a2YwQW9i?=
 =?utf-8?B?NXhsWWVPeEJudVFjRVZGZEdmYncyQ012MEpoNDJOV08vSllQWTIvTVhrekw1?=
 =?utf-8?B?WmNBUXRTbloyTWRQeEliSXY5MnUvMC9wS2ZOcE5md1l4Q0FKZE9HajlmNklU?=
 =?utf-8?B?aVExSWM4MEdlUXgrNjBKcEFjTDUyUVFqYmN3RDBrOGgvQm4zYWhVcmIxTG1j?=
 =?utf-8?B?SnI0bjk4dXRDd1NKbTlBUEVPVDNCNUhVZVZJeFlQT0o1eTBTVjJXL0l6RlR0?=
 =?utf-8?B?dUpPeVdnZ0lEUVJKa3VlL2I3Sm9yN0Y3bURNcWh4RHdCOTUzNTFMRkNiMjlK?=
 =?utf-8?B?MTdLSjZHMVFKTmN6MGlwL1hna2ZIeUt5cHYrYVluUUpiMkNuK3YySGlXQjZP?=
 =?utf-8?B?c0ZaTndsQjJoWGt0aVdMYzJ2elVERmlLU3BGdXhvRzZ5dFJMMlNhMFljV2hC?=
 =?utf-8?B?eHBHMEpEb0dxaXVtY2VsTEp0aUpQM2ZqMW1ucVpRQ2FKTXRaOEtSOWdHRDhY?=
 =?utf-8?B?dG5UR1hlNUY4QkdlUXFCSWFmRXZBaldTQmh4clFBanhTMlJ0WGgwT3QzQTFP?=
 =?utf-8?B?KzA0cnIwT3hGKzlCeDRvSTNoYjNyb1BUdTJraUJBWWhXSFN2ZnJUQS9rdHMw?=
 =?utf-8?B?SmJuc3REUFdCV054ekxuWDltbGxIOWY1ZnBjbWNIODYxUE40TmtTamZ1Tm1N?=
 =?utf-8?B?Rm1pbHhkQ1pOdDRYZnBQcmdRY0xhT0E5V2FHeFFGdmZ3bzE4Q0U5OWxJK2Fo?=
 =?utf-8?B?M1dOdHc1SG9Ibk5yaHB2WngrSFdxVlNRa1Z0SG9Ham84UUpOeFVRcE85L0tk?=
 =?utf-8?B?cWE2QnNFR1hpdjhPSnlsQzVIME9VMU1GZ2t6VHdsSkNCVEpHZHFVMGdzbXE5?=
 =?utf-8?B?d2k1UTZNYUhTaWc5dzI1dXRXNUdneEJjRDI0TGRzQWw4TUt2cDRueEp6OE40?=
 =?utf-8?B?NVdXQmxqWkNySm9CbHp6M2ZHWUg4cHduc244ek0vVmxKM1RuckVRRXZkYThw?=
 =?utf-8?B?R3FtRjc3UzBzK2pORFJyRngvL2pkd3ZWTWRJWnVSVzlCR2hraUdtbGQvMkxE?=
 =?utf-8?B?R1pSVGJoQTZSZjFISkgwRnpHOWF1dkUwT3hZdi9lVHhuTTdOZ3ByYkZtdkV2?=
 =?utf-8?B?UHIrazVqNGtGWlFLVUNHY2dhTCtjSVdNUGcwQmNYYjBuUzRWdE9ucFh0dFJv?=
 =?utf-8?B?aVVxbDRBYjJscHJiOVVTTU8xLzQybDBRQXN1V2MwK21paVRrd2VLTHdSSXp3?=
 =?utf-8?B?Ukp4RlFNdXhXMHdJbkN3U0NYd3ZJZWJubjJKb01xZWUwVEt1dmVnVDRRSVRJ?=
 =?utf-8?B?eitPVGo0NjByOFh4NkVQRzd3ekx0RWRvUVFaMktCdlFMQ2FHTDhReUJXa010?=
 =?utf-8?B?elUxOVpOQnlLWUlGU3RqYTlaZmdJZUMrL0RnRmwvdlMzTTNTdWFldEFUTm1q?=
 =?utf-8?B?T0kveXM0WldSbkIxWlhuQ29FNGZLWDlNNkJhTHF5aXpNTWU2MVBicnFTSnZn?=
 =?utf-8?B?WVdqM1R5TXZXK0ttcmVFUk1ZVzJMSjNERXU5aE5od0puc1RlSFpIOW1NQ2cv?=
 =?utf-8?B?RWdvWExwejdpQ2dUeVVrUmtPbk0zMHBDTWZoSm9wRWZ6cGtodk1xb2RwYVBl?=
 =?utf-8?B?a2ZNMG1GTS9XYTAyc2FGR3RCRHVDdG0zeERKOVpPS0dpM3ZZL0dpRE1RVVI0?=
 =?utf-8?B?S3ZybDA0MWpraGk4Y0JJZDJFK0RNR2FEN0txZTJlNVEzWHY2aW5oNS81bEto?=
 =?utf-8?Q?ESr28nCP5M6UNDWrQC?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 225a16d3-dbe1-4db2-8fae-08deddedfcbd
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2026 19:12:15.1907
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hys4ovxgKBe/GLO2YZOyal5Q2ajLNrzlTgRRvPfNTbP68W2ZttfUF3zohRiYOY6H
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8664
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4E961C0010
X-Stat-Signature: 4bosm8ibttoy9xssbxghjkfpfibp4a3o
X-HE-Tag: 1783624341-566175
X-HE-Meta: U2FsdGVkX1/fdLn4JBv6+KI+imYBGaF+infHzp0xj9VZS/e2R+2KU5kaDxY10nTzIVvKPcli8b0nSMzp5r8+8UUFxT2cKccdJoetqswkEkdreMd9VLpIPw2q1wSGfp31F+kkkWzVX6daGGuLK00LrJ5uwxhoqrTn+TBEmib2ZnNm5Uv70/ytt+ONUU/LBt7PcbT00UiwApLUmdj6XGSOUnb+lpquI76vYK7E9sBUacsqZk0S6K3/9W9UouF6IhpLr5Mirzjj5O8wa1dK9krM8QPFgAxrLi+yqpaWhuZ6N57zB7vRkLgX3/j02dC3acmAqNVdbma/gfkeGZv3vYMJk61pjOmE2L4dbYsu65+VAY/1L+v7p5WJGiGHlKVEm0FtEs+T8KqKhzHZqBY0FEIggPI1cJVrUF7P9D1y/I+7qY4dFYfZh9rRQBCk2YibxRAFN06BFPGkVV9D1adgKw/Ygz4IlXRmzDVGk5oLtV5uhacGTNyH930lWqgTy3jhyY6MEucQR+OExLgBFMd6yE5O89WWJOB6f4kwLsu7Rkqhv5xx282kkIJaJFJD4IDTHsrUtAvbdE1q2rP7MQ78TBE8plXE2wOiiDjRHOPp1dKpzyIuslNZKI8nitgUSdvC+cB9FX5+LrPBGmjAs90i97uE2g5kBM/dqoo1+gzlZ/hE4fqUeY0UJiArmnW+s5JCHJDttOYiGR/KqzCBeANP0y+Z3ouxchFS2ijyPqC5WrQ/+ZwDre+Tf5wdJhz4AjKZ7XzUgIcKHihotNfOcUUO8NdVTmgc6cT+GKzbU9GXDsf7NugKxMEv44xHBjmNobjbwS4KGwdWaP18jlPAwCzKw0bnOK/Zx6DeRAIvUkEBOIoGYMkAtxvWueRgGVft9MZGQ9VghpN+o0lfQ+FVHjfC0uhjCOolTYIPjbJEE8TEsLhSzxQQN9XOGpnJHXGxFH/TUGF/Nccfa5YhA5tnk58R0EY
 odvS937X
 B6RWFVBQDsRS1WRtH85pu1HBojDlUfzdif+LIEOg0jghbPYLrdODMFXggF8w4E5vnNHeRvmqVf5yJMnbGQ35dUVpl/r9db+zssMzyyyZiHj/sYZriBvkBguABWg+7Kz91WlO199/O6wa1zlViTw9ocwkXPjO9xhcPkbGK4icHHgEBhVYZbZ7nNYrIIDFqzwfCbTj4Q/RU9mFMKqOR7749Sle7n+6tS4P2ajQP0rgPUsY2tKfJXAnVcFM/sfSV3qXHbFl28G+NgLd1Ce/qc6SpwkfMVFWfJa+zKiI/gM5jB9nHgYukRl3Gq5JCmfs2yEYA2GUIOEHmUT1JIXH/QMQHZXApS2HsJgll7rIVfR8z51+FCNPWasO7js6yYuDdCrvJTl9C/WHwVhkVAS+7SpPggevw7XA/81E7ZYT6OHfqhkv7wY1Gmlf3UXY40NviIq/o4P3iR8+kPX8i6dZ9YGdVKXp0x1DYqWsz7RixIowlWts7EGl+WQmxlyGcB2xmnOwSp4UASkpttGKruvU5vSNbYl4W5A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In pcpu_create_chunk(), nr_pages is the total contiguous backing
allocation, i.e., nr_units * pcpu_unit_pages, but pcpu_chunk_populated()
uses it to set chunk->populated, whose size is pcpu_unit_pages, bitmap.
Since bit N in chunk->populated means page offset N inside every unit is
backed. When nr_units > 1, the function writes beyond chunk->populated. Fix
it by using chunk->nr_pages.

It also fixes the global pcpu_nr_empty_pop_pages accounting, since
pcpu_balance_free() only iterates up to chunk->nr_pages.

Commit a63d4ac4ab609 ("percpu: make percpu-km set chunk->populated bitmap
properly") introduced the bitmap overflow issue. Later,
commit b539b87fed37f ("percpu: implmeent pcpu_nr_empty_pop_pages and
chunk->nr_populated") added pcpu_nr_empty_pop_pages and caused the
accounting issue.

Fixes: a63d4ac4ab609 ("percpu: make percpu-km set chunk->populated bitmap properly")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260703-keep-subpage-private-zero-at-free-v2-0-2970fe777dd6%40nvidia.com?part=1
Assisted-by: Codex:GPT-5
Signed-off-by: Zi Yan <ziy@nvidia.com>
---
To make nr_units > 1 in percpu-km, we need SMP && !MMU && NEED_PER_CPU_KM.
RISC-V can have SMP && !MMU. SH J2 can have it too. The kconfig analysis is
done by Codex.
---
 mm/percpu-km.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/percpu-km.c b/mm/percpu-km.c
index 7ffe84adadb9d..65fd5580e4472 100644
--- a/mm/percpu-km.c
+++ b/mm/percpu-km.c
@@ -75,7 +75,7 @@ static struct pcpu_chunk *pcpu_create_chunk(gfp_t gfp)
 	chunk->base_addr = page_address(pages);
 
 	spin_lock_irqsave(&pcpu_lock, flags);
-	pcpu_chunk_populated(chunk, 0, nr_pages);
+	pcpu_chunk_populated(chunk, 0, chunk->nr_pages);
 	spin_unlock_irqrestore(&pcpu_lock, flags);
 
 	pcpu_stats_chunk_alloc();

---
base-commit: 59e34180e138a293260301c139cf7ee800978533
change-id: 20260709-fix-pcpu_create_chunk-in-percpu-km-6dfa8f28b175

Best regards,
-- 
Yan, Zi


