Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43C9CF31E28
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 15:25:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81D8E6B0089; Thu,  9 Apr 2026 11:25:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F5AB6B008C; Thu,  9 Apr 2026 11:25:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70B1C6B0096; Thu,  9 Apr 2026 11:25:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 61CB86B0089
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 11:25:44 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 06ABA1403F5
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 15:25:44 +0000 (UTC)
X-FDA: 84639392208.08.608D496
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010039.outbound.protection.outlook.com [52.101.85.39])
	by imf10.hostedemail.com (Postfix) with ESMTP id E4243C0006
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 15:25:40 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=fJcqFucm;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.39 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775748341; a=rsa-sha256;
	cv=pass;
	b=usAViuZCT8F5mK0fJnNvbIeAlW0r8x2AtQD5To1UZYhCIP3OFyNaOLDE76AoutIigkNbjD
	XFbMr5O7+krJpaj2y7zEsjIqTfmwHFNukcMu/HTAriZogZiEdxlTtlzAuJsJI/iW5k5t/+
	3SE+JG00bSNm8ZuGwTC6sqIiR0m2+E8=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=fJcqFucm;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.39 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775748341;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1j2iBXnnSCqwQf+QiZbCXmxDGwpiTnceh3wtHr91rSA=;
	b=09drWmto7x2i/EA0qRko+mNlIE5ir9RZurFiS/xQKW+VBRqq4AKof4tZiDWz4SNzy7vVey
	4ZdZijRuSzQEyaz43KfJIVPU1dTpW1vyVl2zh9pFc+TgAfcwU8mP0jpC+csE1LnkxdAhUz
	LIvNh1rlF/RW6QlsnCyVuiFMeGnTcJ4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ri6qdFTE2KhsyWp11iqLffAh1DQQe77wbEvWHNRj7Y+XVigIdz4pCK86OD5cf+O/bZCuUFxLRQwspV0oxFCziLLubkgEjxevX+498QQnsl01fA0lYW3LYbI//7dphp2JQqT0mdLzZ6zin7BY+AhCmN6I2oZWTOFaHm0FEqCq69u0zT/jzYm+uEsM3RRcFPMQvwp5lJ6cmYNwcL5vsBWxYNXqT8a7B/rejo7qFJ2QyVpkizT3u6hJY75qLELW5Et3PZp8VQOb1xybN9Aoi2UiPtOfjnahckxfZXmlBZZIrhvztOavhiwXPAvkZXEDyK6nUZ2QVxRkhLD4T2gfBvO4og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1j2iBXnnSCqwQf+QiZbCXmxDGwpiTnceh3wtHr91rSA=;
 b=cRto/DuqX6pNwALhk3cqIn2PDH3zoWlr8RC/NA+/JRs2G8iN3mPZV+S/PoFL2lixz664KVKC4wzEKsZMmOryCbyKWfONIc+PVf0bXRLSR80hDyCEYZfZu69C8/0MPYQgn0317qWa0rBodfbcn5ea+v1w+RK6YvCD53RKAzxy/7zxB6YbkmRztsir2zALVTTwUxxx08Pydnb86zsXc9mUHkUMifabNYIqD8juhYWqhWqBIktNwK+1nC12+qTxYj8JP2vgMzlae4COmzcfix5bR8QgSbiK38TiEldHADJsldBPOEeVsR/HHTaFcJ4QvyQ8oOzmdzRjCnhRUWyBhklbPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1j2iBXnnSCqwQf+QiZbCXmxDGwpiTnceh3wtHr91rSA=;
 b=fJcqFucmIYtOusqnzflrAIYfJ67t0QUspM/7s/SRwDczUDFv4aRbIT8YLApbNT51/0g0lwUkodjXt5xJ7+c6Fyg4rB7znmcGe7XOG5heNsyRDUYdQGHaQrBKWZ71MXl+AmLATOYEgDfuKlpU0fo2Qa9gMExDIBGvvyZWztCogTm9hEW1HP5bXxQ1aI56O9h6bEmj8k3Iu6TnmrBPQK+zH4vjTuI7V+UxvxIEz5g8Fb8leSeYk0G9EcxbpGhAr2t1J8uc12/WNA5FcJsgXnLCflpxCCCHrc42b2ec8zcI3hK2PvO3BcxE96Sd31L9FS0E71CNi5AIDBiR1qlJgHo43Q==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS0PR12MB7899.namprd12.prod.outlook.com (2603:10b6:8:149::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9769.18; Thu, 9 Apr 2026 15:25:33 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9769.014; Thu, 9 Apr 2026
 15:25:33 +0000
From: Zi Yan <ziy@nvidia.com>
To: Luiz Capitulino <luizcap@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, david@kernel.org,
 baolin.wang@linux.alibaba.com, ryan.roberts@arm.com,
 akpm@linux-foundation.org, lorenzo.stoakes@oracle.com
Subject: Re: [PATCH v3 05/10] mm: debug_vm_pgtable: use
 pgtable_has_pmd_leaves()
Date: Thu, 09 Apr 2026 11:25:30 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <E732F4DE-3CF7-4B58-94BE-371A0F3C05B3@nvidia.com>
In-Reply-To: <18d82575497d06a4d18605ae33f9c22e08a3209e.1775679721.git.luizcap@redhat.com>
References: <cover.1775679721.git.luizcap@redhat.com>
 <18d82575497d06a4d18605ae33f9c22e08a3209e.1775679721.git.luizcap@redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BLAP220CA0012.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::17) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS0PR12MB7899:EE_
X-MS-Office365-Filtering-Correlation-Id: 24929883-0244-45e7-a5d5-08de964c3dd9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	qkXX0Nr+1SbUhQvdOxqF0aLrQZEfUTT+idXYJflePnbRIyFXz/CxMF5NN5lmDQbWtYVAiWIJBio0jNIr6y8V+NPZ+lxeTboZ6dkCOUHDNlxUKNWilmUHNe0ljrw2IjO/f9nt14KQ4gPOtMsD86yv/opcl3qQuOSPeOtawe3+7+Q1mLk6WG/lPallb36pTFdPcukEYwl1OIXprf+3o0XZbfdXOlVb2z6lCaldEtAmrQI7T6lRAbcHKR+0NxKe/H4iP6BlfcJPugqgCwcJvdmQ/xsigXx0BJOBnYp5RdcH2xQY7Z/WZW4OUI8TnaIdCIV7unSfHTOS4XnobOUIf3TMl/ogJbyiDybMr0N5ppljgxUTRl9HaVzyFxE0F933YWYST2Wsgb4NcwihF4GUZIc2CA/hRofitP5of/oRMdLCwVQOoUxpQOn16LjHGUVw+aur7RnVvGDvoFXsH0KlMB8sJyCgHUUpeAZcC98Z1/ipccPXqNIUOTZyXSuDx0c5tao5VewKepFGhikxdJxqI4oEKPEDeJl63Q0yzzgD5RIeSlxwW3mBfrjNhUtR/tOilrPEDmWAzg82yRrogWRyafi6T0oEZPR8g3NmJr+Tad/3EjT0NMeBGOrpoqfOwj7apZw43pQc7Mpgq2KQlrtwGta4y7BmUFLfodEJ/t53ER5TJjPVH6tmC9EiVVeAMBwe8E2v7GbJa/n+2u7s+W9RTWk8PYqeH8JIVqPUU34VqC2XMKU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2UaEghxzlBnRvkQ6Zfo2tBr93IB6HerdYsYw1OQ8Fow9UohfuDkYMEboFWAY?=
 =?us-ascii?Q?+gag4zzZPLAQUgACsPPkb5e6nAlyX/UFYvjo92AmHN9+R88wS2tZU8S0mZkq?=
 =?us-ascii?Q?8V5XpFI1NKEjmFtXvChLbmQ/JVeWvr3LeaYQ4CMeTW58smGrf+mpeqdMC6B4?=
 =?us-ascii?Q?HctIB+AiCglgF/FXt7mdIrFlfiIbrBEq8lnkcJlewKXttLoSHoPl1mOETstC?=
 =?us-ascii?Q?OSj3XZNw6sU6zyfWMVzFMicgrMWsqOEbKzwtP2Xm1GWqcMIQhIK1xWgQoMbb?=
 =?us-ascii?Q?7PsJDjF+67WDeiS9W7FW5HMrc0XP8njZCds7g6SlhDq8p4+Why1DBqbHSQo5?=
 =?us-ascii?Q?Ibap3IJNEDoam5CjXEg217oas7mn8FHBydBaMRYjeNuy6R/VTzp4sFzkqbaj?=
 =?us-ascii?Q?+2ONW/9EQIgJyM0zjlogsU4rEgRJqVPRqTyCDEfOKTBxC0Ug8Hf/WMhvm4rX?=
 =?us-ascii?Q?0+st1gPwLtEVAyMsKU5FwVX3AxqaOex/k+8lYqOrs3WcVtvcAxcLiFYFoMLi?=
 =?us-ascii?Q?c/moufkSJ8RyW49SaN31BTek07cTP/sC1i7S3doykXwEM51Hwii1Bg39jz8I?=
 =?us-ascii?Q?V7b0ganMCWjKzR6VhWc8ruVuktRAGkFVNOsV5QlrwOpJ0X5I+AObDI1rSuUJ?=
 =?us-ascii?Q?5pkyDMw9U/r24iHPstv+mYa5/P2Mky02WZboW33IwNYPv07XHUPgflo+EBya?=
 =?us-ascii?Q?SJxhXc5ig7n8T84jlyYlf6pd8DN2zqcP4+8NJQzc3ExA0l4BqDzKk6kyQ3fB?=
 =?us-ascii?Q?2lkiqE27FfBrl9N+zwz+eLC9hMwBUQRzfGAnr1JUCLUiCWHTEcDC+Uej9wBc?=
 =?us-ascii?Q?XWejjU1oMvUo1ctxRo2Ap1QionHKcUavT6G6IEGA+wlcr5XJbnYCrc9PhUIe?=
 =?us-ascii?Q?Cyt497lvbvPTj7T/uA9rxRkSRbkeuBsoA6bLEM9Tt7kZY7QaY4KdJymqKxBJ?=
 =?us-ascii?Q?05559btna43F46jHVxQpMenUx27xMO+ACtCNPdDwJKZ+ON5AjqfhgZMqmpfi?=
 =?us-ascii?Q?mBsptNxYkZd5UikGyPteQHlgPnaGwJyePH9sGUHVnhtuVgrOM1AuA7yJc/4a?=
 =?us-ascii?Q?3xafo5u2PoT1Z4ypnA/wyeTDsogyZwn1Xku0KA9PY23SC2SQCyiL+VNo1c3f?=
 =?us-ascii?Q?XVKy6nnNh0yMnRIIqkzrPZu0Ljfotj0/6K1w9fBa8HszyMA/6w/gZhap0uak?=
 =?us-ascii?Q?eDjPPtS7gawQcWdnlEJF7NED+Do8IoDe3TOpjafLz2ZohatHMMNi9KnuAfN9?=
 =?us-ascii?Q?kFvNJ4hyLm97t2MHixLw0dCjxl4szczRQy8N2VdZEyWbN3TpgXwf8yUPr6gp?=
 =?us-ascii?Q?vAdESQ4Q1sCXgiJy9TX7Au3vsB0koFVWeXfn7uBV2PjweIbpcAW62HK/axxl?=
 =?us-ascii?Q?OL+IvaJPpyoWaqQxjLqZnOcofE7jSmX65b2y+4/s5BfvXYOYbMvb+cXmc/4L?=
 =?us-ascii?Q?HxME87T0W4hEVSrEZmQvc+OW/+0Z4vAwESR8BsEN8r/op6pAdA3cELfr/6GD?=
 =?us-ascii?Q?XlVBHOVmRFR4m1uMRM/W4x+glvC/gL3JuF4IgqH5l9F3xKUHG+gJBkGdRDK6?=
 =?us-ascii?Q?3DMivXyViGC//fzRfE/kMbIwJzTRfcKYN15gLmDW8z01RZ17hwOf30kU0xBi?=
 =?us-ascii?Q?5lZk+hvwW5MY7Tjkqafolmn8IHFMd2hyQgFHPAvpn3T2VChyZpK7VkWSyaFe?=
 =?us-ascii?Q?KbiuNTZYNaPd0Q/arZaCWXJkVT9d96HcqZUNJAvXH1OTdlWz+IT8uWY3CgKV?=
 =?us-ascii?Q?xafHKwU2Ng=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24929883-0244-45e7-a5d5-08de964c3dd9
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2026 15:25:33.4170
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pZ1Pw7+S9ckYcbOw3gXxEtE5mfQFOOFedFY0FUF56+v968OSd3BYGuIcwVxHFRWM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7899
X-Stat-Signature: qpommw359z7yhnih4wz7dkb46mdpfyb9
X-Rspamd-Queue-Id: E4243C0006
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775748340-130479
X-HE-Meta: U2FsdGVkX1+55ww7yzprA36Sp8s9qjfpVTWaWVCg4BPPYHG7sC+ODXMCl3VBrhqKhpTYbh9EwL+lSagtd/DZRaGg5bbxsop9hC+qFxJe1xGu38A8z3fdlQ1Oyp2USzdfzeDRxTQd4ZjqFfkiCXjhI5kliYLHL9LltDb+gJE7iaui6Tygj3CkmZ7Y23v22jwsqAaCZlhiWLPw/04vuAEf6dJeYb94qwKoQJF99M3xL4ubxQ47y2pkwr5t2TiWkQ9QCxVwvmp/6SCO+/bUF7ZPlmifbylGY4m/+qUGvYCJ2MK5954NZXwwX6lYVCritJBfoxv8zMT0XQGGw5PMApSBZCX1DpbLRSbmtASn7TOUAbKqjnpJuRVO9zRnoWf6/iufxAFZtYebQ4k1CW/2PbeyX6VS/Bg/aoY1cNLDWObLu+eVgG4vjh+41OW5n2VxFNnKrA37c/YMwUHPNfZYXNrWd8BHK12TPMKbyb1H+6oIJw+pcKTE8YLRZLR5yriZJw9z/YBiqj0RVNwGGpjC8PDUlzZxcqFFiMU6/+Po11tkpbWV+/6T/mpvV24tGPl4esa90giM+gLo66r7OYD0qRtLbLjOmXP6QGVNCaGs6SXA7/st5Ww8YnAPadUHImFGBZuapDwzzQndtdpS8qefQYsPkcLAZfRzGX/1pP41/t0G+qrnPUGOmK1dCL3Hw2WYGZMzOm8g80SLt/9anH35EtKSRdLQsqd3YNf3rznsTyk/61fx+fufs/89i7cl0vDC7hk6UFkR4sFR5ct0h1onyWDrHW8FYkpciec6vLZgli2uXASzgleISc+GsaUAXjBKd0b6mtZe+UlAU/Ua8ly3rs+BlCZYZMVyY0oMhwr7NNKaAfuOLoEDmmKk7fP/PNUEdVvoixibg7jqETjm5FWj4sMGLqsacegaWrWpFP1Es6E975WuDDBT1e5VZ61Xjydk6DUmkHicFr2ACN7Gyayswlv
 14nHuXN3
 9Pi//CMIstr3yYobiYVqXifPEd9tJ+zKYE5nSkqgzMn//E5jh+czLdZ/xq97cgS1KwAfCSteS6FnAJ9XLGoasTXUKPsLtq1u2oK7u8stMQqRnfGkMH8WbmUop0YyMAwR0PqNM+bfJ2WhNS+9vEG6JSGINFyubsd/ku8Tja6UgHN4h2u+4G7Z57bMXO6ZBPxmuTZxPXBtvs3magU0LZEJzWzhyVAgc4lIv8TvAiG5hQDpRboceg+w8Sy29KzHLoCoHeDv4jgUNm/x5do/dYwPni7i1jFPEBxYV5TqFIL8Mjh2Tvz3mkyOCiWhrKiLGJlywdV1wvXw6c2eDnNkgIiK9L4L+fay588vzJ90N4wnbnuXfGy3niWgeb2Pls61id6ZdweA6jf91/XY1isY7cSko6RxsOSUeD+QFe2/fHIlfeB3SCslJ7H2gVfAla+neaVQ3Q5NVJ8FnGRrFskY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8 Apr 2026, at 16:23, Luiz Capitulino wrote:

> debug_vm_pgtable calls has_transparent_hugepage() in multiple places to=

> check if PMD-sized pages are supported, use pgtable_has_pmd_leaves()
> instead.
>
> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
> ---
>  mm/debug_vm_pgtable.c | 20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
>
> diff --git a/mm/debug_vm_pgtable.c b/mm/debug_vm_pgtable.c
> index 83cf07269f13..b3e30baaeceb 100644
> --- a/mm/debug_vm_pgtable.c
> +++ b/mm/debug_vm_pgtable.c
> @@ -177,7 +177,7 @@ static void __init pmd_basic_tests(struct pgtable_d=
ebug_args *args, int idx)
>  	unsigned long val =3D idx, *ptr =3D &val;
>  	pmd_t pmd;
>
> -	if (!has_transparent_hugepage())
> +	if (!pgtable_has_pmd_leaves())
>  		return;
>
>  	pr_debug("Validating PMD basic (%pGv)\n", ptr);
> @@ -222,7 +222,7 @@ static void __init pmd_advanced_tests(struct pgtabl=
e_debug_args *args)
>  	pmd_t pmd;
>  	unsigned long vaddr =3D args->vaddr;
>
> -	if (!has_transparent_hugepage())
> +	if (!pgtable_has_pmd_leaves())
>  		return;
>
>  	page =3D (args->pmd_pfn !=3D ULONG_MAX) ? pfn_to_page(args->pmd_pfn) =
: NULL;
> @@ -283,7 +283,7 @@ static void __init pmd_leaf_tests(struct pgtable_de=
bug_args *args)
>  {
>  	pmd_t pmd;
>
> -	if (!has_transparent_hugepage())
> +	if (!pgtable_has_pmd_leaves())
>  		return;
>
>  	pr_debug("Validating PMD leaf\n");
> @@ -688,7 +688,7 @@ static void __init pmd_protnone_tests(struct pgtabl=
e_debug_args *args)
>  	if (!IS_ENABLED(CONFIG_NUMA_BALANCING))
>  		return;
>
> -	if (!has_transparent_hugepage())
> +	if (!pgtable_has_pmd_leaves())
>  		return;
>
>  	pr_debug("Validating PMD protnone\n");
> @@ -737,7 +737,7 @@ static void __init pmd_soft_dirty_tests(struct pgta=
ble_debug_args *args)
>  	if (!pgtable_supports_soft_dirty())
>  		return;
>
> -	if (!has_transparent_hugepage())
> +	if (!pgtable_has_pmd_leaves())
>  		return;
>
>  	pr_debug("Validating PMD soft dirty\n");
> @@ -754,7 +754,7 @@ static void __init pmd_leaf_soft_dirty_tests(struct=
 pgtable_debug_args *args)
>  	    !IS_ENABLED(CONFIG_ARCH_ENABLE_THP_MIGRATION))
>  		return;
>
> -	if (!has_transparent_hugepage())
> +	if (!pgtable_has_pmd_leaves())
>  		return;
>
>  	pr_debug("Validating PMD swap soft dirty\n");
> @@ -825,7 +825,7 @@ static void __init pmd_softleaf_tests(struct pgtabl=
e_debug_args *args)
>  	swp_entry_t arch_entry;
>  	pmd_t pmd1, pmd2;
>
> -	if (!has_transparent_hugepage())
> +	if (!pgtable_has_pmd_leaves())
>  		return;
>
>  	pr_debug("Validating PMD swap\n");
> @@ -906,7 +906,7 @@ static void __init pmd_thp_tests(struct pgtable_deb=
ug_args *args)
>  {
>  	pmd_t pmd;
>
> -	if (!has_transparent_hugepage())
> +	if (!pgtable_has_pmd_leaves())
>  		return;

Do the above changes require additional IS_ENABLED(CONFIG_TRANSPARENT_HUG=
EPAGE)
like the ones below? In patch 4, you said IS_ENABLED(CONFIG_TRANSPARENT_H=
UGEPAGE)
is needed to preserve the existing semantics.

Never mind, since the above code is guarded by #ifdef CONFIG_TRANSPARENT_=
HUGEPAGE.

Reviewed-by: Zi Yan <ziy@nvidia.com>

>
>  	pr_debug("Validating PMD based THP\n");
> @@ -997,7 +997,7 @@ static void __init destroy_args(struct pgtable_debu=
g_args *args)
>  	}
>
>  	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
> -	    has_transparent_hugepage() &&
> +	    pgtable_has_pmd_leaves() &&
>  	    args->pmd_pfn !=3D ULONG_MAX) {
>  		debug_vm_pgtable_free_huge_page(args, args->pmd_pfn, HPAGE_PMD_ORDER=
);
>  		args->pmd_pfn =3D ULONG_MAX;
> @@ -1249,7 +1249,7 @@ static int __init init_args(struct pgtable_debug_=
args *args)
>  	}
>
>  	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
> -	    has_transparent_hugepage()) {
> +	    pgtable_has_pmd_leaves()) {
>  		page =3D debug_vm_pgtable_alloc_huge_page(args, HPAGE_PMD_ORDER);
>  		if (page) {
>  			args->pmd_pfn =3D page_to_pfn(page);
> -- =

> 2.53.0


Best Regards,
Yan, Zi

