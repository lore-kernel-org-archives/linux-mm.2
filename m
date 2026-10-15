Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B01ECC6B34
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 11:50:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F5CF6B0088; Thu, 15 Oct 2026 07:50:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A64F6B00A2; Thu, 15 Oct 2026 07:50:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26E456B00A3; Thu, 15 Oct 2026 07:50:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F09776B0088
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 07:50:13 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F2935A8663
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 11:50:11 +0000 (UTC)
X-FDA: 85324692222.10.8CE4465
Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11023133.outbound.protection.outlook.com [52.101.83.133])
	by imf17.hostedemail.com (Postfix) with ESMTP id EF39140008
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 11:50:08 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b=s5iFyO8L;
	spf=pass (imf17.hostedemail.com: domain of khorenko@virtuozzo.com designates 52.101.83.133 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792065009;
	b=0EWlOsgXpflvttSKZsStM3D+urzBJNX8cREeTmbqAa+lZTf062MsRdTSauhFdgyLQ9IE05
	14Hp6lSYaiCZQtLY7KXBMROdGr2+fBi2YCakWzJESL+F8BDNhzsCrZxPP8+xa6iWAaOcxC
	QEWmPFEr7iyEO+QuT4iY6pHyhlrs92s=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b=s5iFyO8L;
	spf=pass (imf17.hostedemail.com: domain of khorenko@virtuozzo.com designates 52.101.83.133 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792065009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/F/QfutoVtb0NefGr+53LzvfokLJJ62aYtcbzphVAgM=;
	b=w2QJi9t3L5ngJe318ceIYqomHIaWc1wgBY0zsjd4zmVInL5DK1qpxYiRJYEokRpxVRS3k1
	0vi06WiLHM+niA72/GlzjleVZBhEEpF9QaRJSiZ93Ae2PxPb1QHBeUaBjw9fpVF8HLC0bF
	4HG9bO1HgSG7ut54GeN51DirMTW3j28=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MLABI5K1NvWy/Q1iQbAyfcRM4CGrRQGSK/f+QMBHs0q6rxke7uv+ufisbdjAOwafOSEjGtuFYqvjbtoJAz6cWjiWo4Tcyog8jTvWeV93ngwjigNU7cm/o+3Q6EB/CMziJCSApvU7jCr4TBAeEGm7e+vf3yz8LvhhsJ/3zsLVBj6okCOlurt+M8DpU0oJko4thG8sX24IHJshPdxe4y67/6opFcNvTUhCKmliX0WYU7c3ikVCcjmYC9Xa21EZ5rTu4UM5NC9Jk/TSDqcSu9TgPoQIXyKghwJGC4VNhx+VFduaZnZiWDMEB9JUnFq0HeXgYuEgJO8eaicABPMmT219rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/F/QfutoVtb0NefGr+53LzvfokLJJ62aYtcbzphVAgM=;
 b=yoIZYDvISD8DWWlaT8rOUpLtvPJsb61aNMqOuNE9QO2IFPSACN+N3w58Dr+StuVNk2+UwbjrT5zvnlAtLBi9NJ686lsyNkwJNbY9iN1/b/5yzsFI59bCi3ur2qymf/Fw+JAHIuUTbejU3UgSelKME6JwsGovGVa0cN4+8R+9aHpLy0Wqyg8YfynMiuAgus+TtYAgsLYmUlCbMXgwlUSyh2f0W2WTVf6u1pxiUteWsalNCDh1MqiQ+FF0z8xSvkFA1GEjHlo2HP3weW3LcrOi/awbf9n+MidFyqw8T30NMHffMQBwSl8tkwyY/ZrgBeSvsT2lE8XtsY0QMSdeEIN3jA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/F/QfutoVtb0NefGr+53LzvfokLJJ62aYtcbzphVAgM=;
 b=s5iFyO8LVsMk20zMN5H/Hf/HzZewC0FBQdm6+gMNike7C5h8Yn8ePVigJyL/BXAA90DD6DLIjAB3NOJy+pc2MIi4JKUhTiTQ1gR0hMzZ7YM2ixI04z7JkzItNvHAYZexsCzPGEmBAJceZoq7sJw5CMSuNahfIVVCv+9MwYZwD3ZjPXpXRiHE24JfbQpTVa+BLlNEoIRoTmVknER7SExWru/ZZETEq6+q+YJZlgX3TZt4OR1v83ghUUDkYAQYbXOxrEWV+lwENmoYbdHhRuIU5EYaRRhM9epwpUCoc/U4Otk35FQZcNtMkpPQPU4tVArmlGCcGjSXH5HF6HHhzgxbcA==
Received: from PA6PR08MB10708.eurprd08.prod.outlook.com
 (2603:10a6:102:3c7::20) by DU0PR08MB9876.eurprd08.prod.outlook.com
 (2603:10a6:10:424::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.10; Thu, 15 Oct
 2026 11:49:58 +0000
Received: from PA6PR08MB10708.eurprd08.prod.outlook.com
 ([fe80::1999:c6db:dc55:494a]) by PA6PR08MB10708.eurprd08.prod.outlook.com
 ([fe80::1999:c6db:dc55:494a%5]) with mapi id 15.21.0546.006; Thu, 15 Oct 2026
 11:49:57 +0000
Message-ID: <3cb6df0a-2606-486b-9667-3952cc631759@virtuozzo.com>
Date: Thu, 15 Oct 2026 13:49:55 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/2] mm/huge_memory: fix the copy of special PMDs at
 fork
To: Lance Yang <lance.yang@linux.dev>, Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Peter Xu <peterx@redhat.com>,
 Alex Williamson <alex@shazbot.org>, kvm@vger.kernel.org,
 =?UTF-8?Q?Lo=C3=AFc_Molinari?= <loic.molinari@collabora.com>,
 dri-devel@lists.freedesktop.org, Madhavan Srinivasan <maddy@linux.ibm.com>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>,
 stable@vger.kernel.org, Sashiko <sashiko-bot@kernel.org>
References: <20261014-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v3-0-85eaec8417f6@virtuozzo.com>
 <F6337325-E635-43BB-9E5E-DCD25F4FC951@nvidia.com>
 <73f0dafd-5b26-42b9-a77b-90c32976942f@linux.dev>
Content-Language: en-US, ru, sr
From: Konstantin Khorenko <khorenko@virtuozzo.com>
In-Reply-To: <73f0dafd-5b26-42b9-a77b-90c32976942f@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4P190CA0029.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d0::19) To PA6PR08MB10708.eurprd08.prod.outlook.com
 (2603:10a6:102:3c7::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA6PR08MB10708:EE_|DU0PR08MB9876:EE_
X-MS-Office365-Filtering-Correlation-Id: 41f4e592-ea0a-4984-8612-08df2ab26fbc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|366016|1800799024|10067099003|18002099003|22082099003|4143699003|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	VHCIdSNsVkEcpoaOOnjateHWJUluDLm2LhtnAcT71KmzJCYoELo+qm8lHi4AAglY/NqPsXHbG8h2kOqqbNsB2boMcrL+2UozLQaxzwfGBKO/Gf9+e+gat9lfx3TsBcDhOswgCw1Tra60FhUnkSWbsUf4citJaMTQqQbbOBhdKhpaY4wSh35Z9OMUMBFt2gwd+roMD7xYd6NJ6IKemtmQail/CeNLbo0P/QffraMzaCgtKzrqbckhj8Dc9JPdMe5ric1Dbdlwb+AxUsYZS18TDvfrKKZwME/00zIZ3qXPXPfBiOCIKaOq2x8fOS/EaoaHS+nZKaNDnNmvKJnNKPWHLyZ+0OpcT3ciaIVttv4Id9AqhnzWuF6rVRrXMhG+/SU9Iu7U1zP2u7qeTzKrj4dhkr8tG6so3xcWS7loS08gIzNoqpITCXthbgPcPH45fuUAaaNy6xnVqgh8Dn+YO9BiQfE6B7mEslLcs3/8x9Za9NUjwKCThgxRKOD7bXCC+mvNV7blqJhgYHjhexYzyLMQOI3qFvCUAOQqh5Ssrvh1Kz28KtY24ULq08BeUKhRlTNk892MLI5BXHhsZUwDKnj7Ed6sbIznL1ioxvWdquNuBc3cH4r6etghhfPjxiAjx3i4
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA6PR08MB10708.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(366016)(1800799024)(10067099003)(18002099003)(22082099003)(4143699003)(261009223027099003)(56012099006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?KzZKUW44eXBBeE8vNGVlMTVIOUJwbGo2MklsTUkzeE5WZmlLeTFocW94VlBC?=
 =?utf-8?B?aks3VCs1b1J3WGNxUXRCS1BIMFlKeUZrdGRsU0ZGZGc1WUJ0RzlqeUlzS1dT?=
 =?utf-8?B?dmg5VzZ0Qk9ReFBkY1F0VFdaRGVuMklMNy9CYk9scjFFaHNUbWlQMkx4c1F5?=
 =?utf-8?B?bmxzdzg2TGQxWXowOU16RUtSRXMxcDkreFZVRnhZbnlhK0ZTWmNnWkxBQ1Jy?=
 =?utf-8?B?YTdnN3BBSkZIU2IrVFptMWpvckVaUVl5Y3dqWXl1QWlud1lzWUl5K1gvZXJ0?=
 =?utf-8?B?c1hDWFNDVnlhTFJybU05TGxSMmw1Z0owc2VGVXczODl6a0NkUHFyaXFuNE5I?=
 =?utf-8?B?QmkzTnpWenRneFZwTis2STRLOUErNjFSS01SdXpFdWdEdXBwQk5wL09NTDRw?=
 =?utf-8?B?ZHNnajVqWmt2bytqb1l4V2c4R2ZzSENuT0NadHl5czF1a0hIYU1qbnpsS0tJ?=
 =?utf-8?B?OUFUbHQvNW1VVERoSkl3K3hFdmdjeDFXdy9weTV6eHRmVHVUMGcyZjFtRnk4?=
 =?utf-8?B?amJxbmR3NUdKamNXZnRQTDR0WnpTcHlCVUVWOW0ycmFsRWk0WFZ4cW03S0dD?=
 =?utf-8?B?WFpaUVcrTE1Sd25vR2dKLzBWeUdFUkczYVNMTnhwVnBFYUlPWlZ3ZjJqSkl6?=
 =?utf-8?B?T1pjbEZtaFY4cDF1WFlZU3lsVm1xRnI2eVFLSUtlYTl6VXNxeHRCZTNYYWZ1?=
 =?utf-8?B?aU1kZ2tEMkFxQThwUVdDeXNoZjZZNHJtWHVzOUxxQkFDNjFxUEhVYisxd2l3?=
 =?utf-8?B?NUx0LzVoUkFTZ1cveFNrNlFRL2Jzd2ZVMWE5U3RXcFpPd0l1WW9CVUVBN0Nm?=
 =?utf-8?B?Sm9yNm5WaGtxSmNJVTN5bkZQb0hrRDJTazUxQVE2S1dFbjRsU1gwSVhvMGNk?=
 =?utf-8?B?TzNoYlZ6cmRUeUFZa042eG4xVno2RFhFeGMxWTV0SkQ2eEVsOElHc3kvcDdp?=
 =?utf-8?B?bTRIb0NVMVdQN2pMZithR1FvcFRTcUZPOTlqd0RwOWRHTGdMS2RUd0txRklK?=
 =?utf-8?B?MUJSZ2NwOEhBNVhNMTJYUXBHS3duZXJWZzF5ZW9VbFc3QTIxZ2ExazU1bHpU?=
 =?utf-8?B?bEhJNXR5K2htRjQyVFFtOC9xVE1qT1FYNVFuVDZhdm5ybTdKbFp2WTIyUzd0?=
 =?utf-8?B?UjJpNWVTeDROdEhBZHhDVjEyYWI2VTV4NXJSQlgxb0h0RTBQNGVYbmRuU20r?=
 =?utf-8?B?d0hEV2JabExsaXNkOUl1V2RWNUZtUmQzUTI0MkQzNFczWFlLRnlnS05WckJO?=
 =?utf-8?B?aGdmS1dQM3FnM3dsbUcvcnlJOE9mUjhvT2pWZXNXSWlNNnZZd1BiZG1TemVP?=
 =?utf-8?B?K0VMcEFNZzMvRWFKUXNlZTYxa1BWbW16VktweFNDYmlMM1pRS2Z2Qjh3YzJK?=
 =?utf-8?B?NVZnVHg3OFJ2b0lRdjVJQ2JhcllsbklGWHJhMnJTbS9zZ2tRSzlsY20zOWxq?=
 =?utf-8?B?N2ttUHV1OSt1cFoxM0FIaW1qK2lleUdIQ2ErU3ZQc09MMUhnOVVFb1FMMVR0?=
 =?utf-8?B?anliVUhDL2tsMmJwQWxZT0Qyb2NDOFBRUitWSkFEVURSeWxxM0JWMzRwZXVj?=
 =?utf-8?B?WjZCOUFoaytLSXByQnBicHJqQUtGdHBsQUlHMURjdUZuVDhoNnJjUkdRNkYr?=
 =?utf-8?B?R1VVY2lGSGNqUVZ6c2s2L3NRc3RoZUtOSy9LT1F3TkRqVTZGdlhxa01Jbm9y?=
 =?utf-8?B?UFdJU1g1UmJyS3orOTJpeWJQMk9ubWhRTFdwemQvNlFSVTdMd1NpNnRVSXht?=
 =?utf-8?B?S2xqc3JXWmdqR09ydGY5aEdOZW1Bd2kzREw2VHpiTURnYlNlRWNEMC9TWUxN?=
 =?utf-8?B?WGE4RDN3TFFEeFQ2YjgrOUwrekdaZGcyNmpldUV4SWVSNU96SzNIUFpxZUVn?=
 =?utf-8?B?UEpaQnZwRDRFeUhKRS9DRTAvKzJCS2IwaWwrQ2Y1ck5rWEtEYmYrQy96clk3?=
 =?utf-8?B?VytsaDQzRytVWGNVMFd1L09FYWRPeVQyN0VFL0ZMdnJTQzJXOFhVQ3FoY0J4?=
 =?utf-8?B?TXF0dXc1VVcxVzZ2MFl3cnM5clVkdGU2YUs4ZFg3cG5HWmlYTlZXN1VjY0dW?=
 =?utf-8?B?WHFyby9NMUR4Q2M2NWM4OWQwVzZjTVZqUm9YcThkRU13SjRMeDljclBoYnBi?=
 =?utf-8?B?Rk5nRXA3Q2R3OEd0WXY3dFN4QTJiVWR5a0cwaGVvbjcwa0h0cm56d1cwRVVB?=
 =?utf-8?B?b1RjNDJIQnpWcUtCT3NXa2p4MGFPL09HUDM5UCtuRS90L0IvRVRod3R5V1ZK?=
 =?utf-8?B?b3JsZ0MvYkRab2h6Ukc4MzlDQ3FjYi8rN0gvKy95RHdYZk5HcUFtbjYxOGdD?=
 =?utf-8?B?S2tocG1wWkthYXpHMzVESktGL3U2bzBjd1RKTGhhTnplTUM1NXV4QT09?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41f4e592-ea0a-4984-8612-08df2ab26fbc
X-MS-Exchange-CrossTenant-AuthSource: PA6PR08MB10708.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2026 11:49:57.8307
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5J1ycRV1BGsx8AO3bWHF61tBNlk3k9lWh9ldJ4ruF0yGUSrc0rChLSZ74CEiVP2vhqy3C4pyL1gEcd1Qsm2Hng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB9876
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: EF39140008
X-Stat-Signature: yo58qgcygsqt5rpx4nrudmqyx35sq1zd
X-HE-Tag: 1792065008-416581
X-HE-Meta: U2FsdGVkX1/GgYPJhrWQVxE4rSRzHaWs08EuvMrnY0kck36kLm3IrCCbkLQgqMQ+3f+3BnE2GM5+iphAZejOSV6mCnY8b6NjjW7kq32P76ssdHQBWgp0to8SZul8qZrlFeCZUS8VWLnfkOXZ54IcDemhh2j9cA+0s0oOFvuhn7VloMY9Ls6oCAgrSSN+Rf7OQ729md4Q91lfBfxrYGmaM+r4IMatWiFiMaKGHh0Nu5y1zaJNzm0Au5U7HU9oSEPnW3AIziHv0c3krTKdb71DS7c6fZkgcjKKUhCD3FnQb5bfq3jhJEDbDkQNN2XWmFePLDVYzcovcu+KElmkbzzUOfJI6IeaLU9bMMJ5hclIeClmetuCuM9vu1ZGnsHPktaGjNnUhOSaZzY1YNHjO3NGHoy3zWtnLKz9K9mFBt+z7rGloYUhyToYSQS/sRLtFiCV8FeHXxsQyr/leUIq7ycd7ANly7DaBB1G2XczPnmjUzvt7rpQnVP8IL6mjvUnO7cXQIJhZ6Z1EwKBThQeB04h77fvmhkfeDqdH2W+ZKRirYk46Me9MEH6NOZRvbILp2HIfwUJh2dy5+GM5+/OKA4FHhDlYqxsWww0So5yANrotnxJXBVdYP9tC5u3XsWCoA1QRLdtZPNb8vXFC+WtSNsCYUedmQ+KdacyFFwh3NuBg40bJczMla8S7af3RotUNKnycIJAEg0+wuFowhwTJ+eFPqretDwo5d+3JiN5yxme9Ie80u4WuC+fnz1fQgpS4avOt7rSSpMygBjvDXt5l6UEqJiWL66bZXfNlYoDIGB0SVoCd/cN5zH4pgB+7ABez7h1ZS88mMZoMehrMO98SX4rY4fkneIWPgb5IRO9W9NblAyPjmVM9QX2DZSKX1psLqotpedhrkGrz/NAEoP7I/n5r5S9qd8DOxUY3ig3KXh+Uu8fYvC8PrNT60ycT/viWcBayVVDOEtlDinir1yeA56
 Nvzx/2eU
 XVA+xPdKs0c/TjCKnpikue12I/toX9+P9wB1IUmL48q4HQLNHwPmWHbbBMR3FkF9Nl/Eq5+S/KBtBAq1UF4iVV1eouG6g9wSLh08pu/B/J5ukiC03QNph24kYAJe9ENIOH8DiNBtad2uxJO6xlTL2UJtyJcAVNp1P9xQZ6Hvn0iBwHjhJEFuuRlaZNMm2rBewwH8GaEJRJZzPd0Sg/B/JnkmMEteyDJ21pjVNMS+v5aWyNoON9w2/7kdCOgII0GvSNv0043vyFEcWn9kXGJJaRUiGKGBK3rrgknl1EU0kp5m5mlo6SRK34Ajm55f/C2x8W4WTCAIwI7JwuKCC4lqdyFLwQxQBwDIiY1zUeiZAU6yq7IIdk2HTtx2Ivf9fmWeCPh97JqPXCu6SRr0eUzJn0Qy6NI3fezpjCHVXHyESdIlqnx6ELMDF0K5jXusWcKocoGyBcbSFcJnD7D7TJkOx6F1B53Os45H8PAWC60dFshy1higjH8JIcqkcCb4jh7vrtTHyNkyEkh6084o1fHbPFo0InUFwAbvvNupF35hZFZASWCnWw8dzJMguNqSQblxpgobapF30WZQN1WcCaScJ4iBd5qA9MiC2Wg1JKz1dOe/adKwaj7tQM9uVbURQm1HShshze45b5NSnr44s+rhtTLE3j3Q/g7fwBf6JunqaQiYY9x7iSiOQPSUOK7VjxsllBMev
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/14/26 18:04, Lance Yang wrote:
> On 2026/10/14 23:57, Zi Yan wrote:
>> On 14 Oct 2026, at 11:46, Konstantin Khorenko wrote:
>>
>> <snip>
>>
>>> Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
>>> ---
>>> Changes in v3:
>>> - Patch 1: recheck the PMD with pmd_none(), as only a zap can change
>>>    it and a zap leaves it none (Lance Yang).
>>> - Link to v2: https://patch.msgid.link/20261014-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v2-0-e1548488fa68@virtuozzo.com
>>>
>>> Changes in v2:
>>> - Add patch 2, the page table deposit for ppc64 hash, reported by
>>>    Sashiko.
>>> - Patch 1: name panthor instead of drm_gem_shmem as the driver whose
>>>    stale child mapping reaches freed pages: drm_gem_shmem keeps the
>>>    pages of a purged object until the last mapping goes away.
>>> - Link to v1: https://patch.msgid.link/20261014-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v1-1-d225c60bc316@virtuozzo.com
>>>
>>
>> Please stop sending new versions of a patchset repeatedly.
>> Wait at least a day for others to catch up.
> 
> +1
> 
> Please slow down a bit. You don't need to respin every few
> hours. That just makes everyone start over ...
> 
> Post a version, wait for feedback, then revise. Twice a week
> is plenty, honestly :)

Guys, you are awesome. :)

Trying myself to do the very best i can and yes,
"too many and too fast" sometime does not leads to the "very best" result.
Set myself a hard upper limit to 1 rework per week. :)

Have a nice day and thank you for looking into this!

Cheers, Konstantin


