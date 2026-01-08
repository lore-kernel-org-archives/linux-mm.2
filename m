Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA8E0D1D483
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 19:21:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4ADFA6B0005; Thu,  8 Jan 2026 14:21:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 485D56B0088; Thu,  8 Jan 2026 14:21:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35DB46B0093; Thu,  8 Jan 2026 14:21:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 271BA6B0005
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 14:21:30 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BF1E91AEB4
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 19:21:29 +0000 (UTC)
X-FDA: 84309765498.06.2A1C91E
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013045.outbound.protection.outlook.com [40.93.196.45])
	by imf10.hostedemail.com (Postfix) with ESMTP id AEFAEC000E
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 19:21:26 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="V/DPFdlT";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf10.hostedemail.com: domain of ankita@nvidia.com designates 40.93.196.45 as permitted sender) smtp.mailfrom=ankita@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767900086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=llmq9Z18ar0dsWQ6dyCpiQawgDMNrg5xqKE8daOA2dQ=;
	b=m+VLwrxJ8FIaiTGK5NZWBMHXI7ccG4gGZFCbV5X7eJdYTe3/HPGRd4lTBxJ08xVkRN/8VN
	utNjwytgGDVQbnqn5tBbx8zJHoy8os7vDjmKLMYfFTrT588trx4xpr8L07IEUvDKdfXczW
	T+6tX9oXO6iptCU5pn9mSeMmqJgZHeU=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767900086; a=rsa-sha256;
	cv=pass;
	b=HbtotTyk9Jb+UrM7slfi/J6jJfkti4DIIPNippBCDk/mtNuf/dzb0Gg21Kev5gEVMm6jB6
	6N/t31ezh/JBRI7lk5evL2+u/4mHBsJZ/BhL227h/J0hjqwl62cPQvSb8flu9nt4H6ViyQ
	v2BF6Z7Cvh8BL942o6zNDU50oEk8p8w=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="V/DPFdlT";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf10.hostedemail.com: domain of ankita@nvidia.com designates 40.93.196.45 as permitted sender) smtp.mailfrom=ankita@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Nl99ggabRKZ2EkdVJi3u2dv4ndSCYH+9rTxO5mmCx4iwfC4XfhdBVHnRRid5EqaMmWDBc4fdK+sKk2eHlS2UR8m7hwBLw/TDKFPTcC+Wl6q6TsBIBuXclpunOOIEkiMcOj8H0jvumynEIo0bGf57QO4d2u8bWAGMEqPu11kFk8l9dI7fq3jLIi2/CVjphm53szaLVoLGxqKJQZdASw9BC6AoYOmyrP26rGS7F6diE1lKUpcdyJ5jkwulOyBNzGcc0OvcS1dJ05ah4R2FBSWZn0zguIhiuqmRC/3/AJ8PSARe8g4ed8fhAqQy103g+g7AdOgzzEM9qMrgqvRUNizrxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=llmq9Z18ar0dsWQ6dyCpiQawgDMNrg5xqKE8daOA2dQ=;
 b=Ug5uVISzUxmv6e0nvhpoqMz4DLpdL3ne6KnVJdtZwPRnzmGmeOtS8SuMTuDWZCXuM38UuWUgA3Ouwwwxp5o5owvUwOHTTm0qf40P1FGoML94hLFkcq2ejoS2JAeYDMJZOI1ty+nk2zVJS1HlUNOc3/fKUnQR3SDkSm/IEzQC0R5NexnMwVHz16zZAMsZFeSwTKqtXagi5daz5/tNwAaXdE7EuTyfwFK6DHTh3LazzJGEELLJGvTriruv4sL2aXZKWvmB9cj6vJIho3tK+qQ074ArR4GxgW5urhxZHd6Wo5KtPareE8b/Nmru7qafXwg3UsaONFBNYeBgwq1Z5L0nsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=llmq9Z18ar0dsWQ6dyCpiQawgDMNrg5xqKE8daOA2dQ=;
 b=V/DPFdlTgyfPMl0p8sI9GeBJUNUHvIWIvuZHH79/9SkavlZQ6lcWfOgARPkr1LrWFAK6bSTVNQU0OSuYjc5yhXApwXHo/pm8OwTP2+VxpYDSYVGQ5sDW/cjOEZfyPcryYmjiqfI3E+aGef2hITZl4CbKhXOCQbPVVPJbZ1ZQuCQ/n+ryM+GIZ3nIPqoqGifoMnkkGO2CeOc8JBugfPbAhaIEEb0Xp2T4+6R6P4ngb6wsWZK83BIa2zULhmvYm1t/Kf+GnWr88wm6f1MadsUYrSFEDHdnkIW4mruP+MqPc1Dnz4jrzC71TNIXmxpvs9lD8GAjGaCSIswsnD3OLpKq4A==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by MW6PR12MB8958.namprd12.prod.outlook.com (2603:10b6:303:240::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Thu, 8 Jan
 2026 19:21:22 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::928c:89d8:e8d6:72dd]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::928c:89d8:e8d6:72dd%6]) with mapi id 15.20.9499.002; Thu, 8 Jan 2026
 19:21:22 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Jiaqi Yan <jiaqiyan@google.com>
CC: Vikram Sethi <vsethi@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>, Matt
 Ochs <mochs@nvidia.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>, Shameer Kolothum
	<skolothumtho@nvidia.com>, "alex@shazbot.org" <alex@shazbot.org>,
	"linmiaohe@huawei.com" <linmiaohe@huawei.com>, "nao.horiguchi@gmail.com"
	<nao.horiguchi@gmail.com>, Neo Jia <cjia@nvidia.com>, Zhi Wang
	<zhiw@nvidia.com>, Krishnakant Jaju <kjaju@nvidia.com>, Yishai Hadas
	<yishaih@nvidia.com>, "kevin.tian@intel.com" <kevin.tian@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH v1 2/2] vfio/nvgrace-gpu: register device memory for
 poison handling
Thread-Topic: [PATCH v1 2/2] vfio/nvgrace-gpu: register device memory for
 poison handling
Thread-Index: AQHcgLSJfOLPRKJns0STpWKoDbujFrVIfyCAgAAkXSk=
Date: Thu, 8 Jan 2026 19:21:22 +0000
Message-ID:
 <SA1PR12MB7199A597C97F6A0DD4413799B085A@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20260108153548.7386-1-ankita@nvidia.com>
 <20260108153548.7386-3-ankita@nvidia.com>
 <CACw3F52rHjxv8gWzz6_YdR038CiA1=JxUD6YuW4As=rQ2oMdag@mail.gmail.com>
In-Reply-To:
 <CACw3F52rHjxv8gWzz6_YdR038CiA1=JxUD6YuW4As=rQ2oMdag@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|MW6PR12MB8958:EE_
x-ms-office365-filtering-correlation-id: 5fd1c3fc-3251-471e-2026-08de4eeb1bda
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700021;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?0O9ztIC1VH8JOuVxXA0i9VbqRP9ilSHS3QVNyp1M5PO7AqT5GZ8vG7n07j?=
 =?iso-8859-1?Q?hab00ji9pPd4hL4M2E7zcc7LEf5cO4FidkgIt/imVymkSIp40RQI/d1dV1?=
 =?iso-8859-1?Q?Vh6l2nGetRTdxHV+ATTIUs4iObzyObxlAWCeapVrCgewG9FCUfoK4qvZd2?=
 =?iso-8859-1?Q?LjaMM0P9djC4k1fkjch79AtGGLgR4NzIpkbdG+eQx02EBKfSvP0MSAA/Ew?=
 =?iso-8859-1?Q?H7iz38ayCLbbJk5A2FbjeWwwCLu6henccBmzJ6CoZMhVXcj5G7DV+bMaGI?=
 =?iso-8859-1?Q?WoZNWm5sfPZnJXlSr7yUMeb59fUItiOq2ZjcG4KpA7iK3eMzm7Po53qwoI?=
 =?iso-8859-1?Q?XFdJuAU4Rvz4sr3l88tJHDui0KcOo0a8V9rqtOEUQuvcuDqTm5XrO3ApWb?=
 =?iso-8859-1?Q?sac18P+F9pxx1fuf9pKBWXX1smZ2eaqays3G8H2flMx1UbuU9d38zH+uuM?=
 =?iso-8859-1?Q?aD22lF7Vj8RyyWuG45A5NVi/gdlouob0vc0krEhzogRqbnAbbBKDIP3V3R?=
 =?iso-8859-1?Q?nS2rWtGUR8GKzc+C6Kmdx4rOfvD/oGU4cHAvYO/QMQG4tQoqHyf8sNzGLk?=
 =?iso-8859-1?Q?twBe6F1ugZnDH5yT73eCuVaKzSiv/XpF2q+YlGU2jz0fGE4md3dlsqZL2o?=
 =?iso-8859-1?Q?1gaD72saLBJbtQlgbUtaYKJrr+uxjZPKPvroGuCo6z14IVMapcVYPKa7rX?=
 =?iso-8859-1?Q?ANG1e1rXx2Gy5oPNhiWuX4C8Bp97Cube7JcqObw3iumZgnVzB0lAZr4Hzw?=
 =?iso-8859-1?Q?wvrM8LSAgP+gYgvaoCj8vV8LpA9yhdEkmGmm3ecM4G+a9Iqdu0ZMaYNySx?=
 =?iso-8859-1?Q?Wh0zPtHyMNxIbFWusfEVqKSbd8wFmh8kA59XcN3oArH+LvDJZKRo7gI9FO?=
 =?iso-8859-1?Q?qwUD/ZPhwNS5vHS5NNkgNHAuKrlsK/4gD1H8aKz1kJqiE5km9JA1X4rwj/?=
 =?iso-8859-1?Q?ZWFbRZfH9fHEmZXI+8XTEn9yuoyH+Uk3DMjds3Ks6v0btPMI9mXMKb87Ez?=
 =?iso-8859-1?Q?oTG9yxx7hkOGd/dxC1VMdQnY8K7k9FZVacApMSUBzz4iOtiSEhuyHek0em?=
 =?iso-8859-1?Q?URAQpPDirkcz3IG5YWb+5phsTj8pWDo8TjVJlOhpYo8bdZSZN/3vwEhy5i?=
 =?iso-8859-1?Q?FHNRi22D/wsbzL4Vr9tM5J+TDicyNqmrAvr9HvUaUAFZiqVS/H99knBZpf?=
 =?iso-8859-1?Q?3lUfMSNE0D1pJrXAJfzYXyls9wke5nHfN5BSTR/Rm+M2nTyQmNu0etI+j9?=
 =?iso-8859-1?Q?3OFXHvHmCxm9L+SsCU8ZKjsn9Jmci8wra9lpflP1uhdjcE8GF44Fe5SzLR?=
 =?iso-8859-1?Q?PvkYZ/gsTPDt0P/aIsgVi3/ddec9KgSIkIdqOJPl4cPqttDUOYq9iAFHG7?=
 =?iso-8859-1?Q?3QjWXl43vPoXp4Jq17j4WIvaoahzcnov2Q3Wax7FX7fsoHb2bitgX07Y+B?=
 =?iso-8859-1?Q?21LRnOX7PJXVCaAh4VDEIooq/cJE/TMlIB6UPGvtpxTGaXCBr8YyhAPjlk?=
 =?iso-8859-1?Q?FzHWO4L5LefLH5jdFp4ZamrgsC+nMiAvbUzLcb13sXw99oRDygVx6DC/iO?=
 =?iso-8859-1?Q?i4L7Z5HkTT7ZkZ/aRYaYbUlIussQ?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?lFVA0pivc7CHlnJTwfgkYyGNLGmUxRprM8T3/j8SsS4sGZcvPALiZWefwy?=
 =?iso-8859-1?Q?I4m7XmZXEflzTW2PrRhqYm0Wxsw+Vu3gJ0zoGBX4f3o+DhFomlMmWplB+Z?=
 =?iso-8859-1?Q?pyLfaVIQ3dikfVLAZ4SUAPOGqXVCwfsZvvIK/B4c4kbFZJT0xCzfscJdEv?=
 =?iso-8859-1?Q?Qacf50NBBvy70RewHrf6NeGyS3g/ZL4hQJ8EC4c0sYZOzZpNZmFI0ip98h?=
 =?iso-8859-1?Q?1pCQD0ljR0wjFiS87DigWwnOEN029xPbX7dnjzSSzzTpmgFVTQH7JtGdbz?=
 =?iso-8859-1?Q?QS9Mnb60giZJkcXB4v2pk+/wAZjqqLkCyW0ETinLndY9cigq4d0Eb5xhQg?=
 =?iso-8859-1?Q?gzAOJfzAnobl6Tugyx8SoK5B60Mdn+Sl1dTFFO4ymCVBZhLEDGAi0LxMZp?=
 =?iso-8859-1?Q?2vZQQvTWSJksLxHR+yYpMxcFlOeTabynGIDFSkxuVmzOu6WgGQO43XGHVQ?=
 =?iso-8859-1?Q?MfT1vKvlXv7xryVirVXi+YiXqsxrRkoEyQapoUKqrfV4mT4V4zpJRliz9j?=
 =?iso-8859-1?Q?hsnUaHedOSoElZ5wP6+TTKYRJ1b9Pq2Bl8rQS9CN6vyC1Y9xKXrEA+0HW9?=
 =?iso-8859-1?Q?L0aaT9kuYLXGXoSQUufuUwvk2WGoTHt9qZB4s2rN+84lhcOlbtfl2BhXyX?=
 =?iso-8859-1?Q?AaCuqfbmyKnNTgABX9NXbb2QIrTQszYAhSj4MDmCIAtCzfPOVFJ9XddzUo?=
 =?iso-8859-1?Q?7H3Aac0drsPyDNB2gUY/1fB9WRbbhb54fniWAkT6OySwP8aVJr4DR5eInz?=
 =?iso-8859-1?Q?JXFAQepcxDisiQCrub/JOHA7durhZmwwh2USCdOZVYK4ZBewNLUYWmTZvG?=
 =?iso-8859-1?Q?fRPws6N/qkoxeoE9VvQHjL/NFtUFlHIxIL5wg5TUJ/qgQpEEnIv6413uqv?=
 =?iso-8859-1?Q?9ONtxwisrCSfBUqGZadK6dNp2O+h/12YtMzADGMwiG/LhYPUEOcLQmt24W?=
 =?iso-8859-1?Q?lSqGS+Ixjx5+U1+hBOCeqds1JorRf6p2mX1N9jVFTv2LpRYxbLAwm7dBB9?=
 =?iso-8859-1?Q?t8EKZPcdn0dDgZEADpwNo+R1w7lkuZT3YGCRLfgrJd7y/7FfYTRsY8U8aT?=
 =?iso-8859-1?Q?bUTcGlML6S0pEdnhDe2qgHpihGslmhwBBQZ0WkBH+xAFykJOicY7aHxxfW?=
 =?iso-8859-1?Q?VXG6ZSnndqWZfLEqx1/jux/L15wWDREDfg0RVanJVMRPiQzi0xhro10/jq?=
 =?iso-8859-1?Q?jg+bicqh5WxZzasQc3QpkHiJ6x1ETcitZNuoG5+1m6ioB6DM0jofOOCgU1?=
 =?iso-8859-1?Q?/edpTqnRB8sXPYacG2iZ5cGkPq3gXf3t5XyZQFLpWZftKlXMmYg1rnoW3j?=
 =?iso-8859-1?Q?xCM6TzyC0U+sM8i9lWlmar0ZTLzZZwLHVwOyr693kOtBlFM7wtvEBtSXJM?=
 =?iso-8859-1?Q?FOleUcw/saIbP0necsjN6DSxNi3foiqDidXbM9FnBsIrdrIHSlOir07BJH?=
 =?iso-8859-1?Q?jVEd19DUJWQdFyG/+TujYF7VvHZ+blpezMA1Y1BFi3bb8nhb/AL0ocp/Zh?=
 =?iso-8859-1?Q?W7+f0/nlaGh0wEBQRrdx627XqSLdtoiUoKzBBbNKA6XGGVkZi2v8FaQ+lk?=
 =?iso-8859-1?Q?Q63UceoXIiDHCb6/UuVArDLkKFhnxJo15+CDm7EDhnTsev1QcxayK1Rwv6?=
 =?iso-8859-1?Q?N9p1ljNNqg48B8xj0jePV05i5UO0kX+JcmCyfcm7WxmK8pF44cV7tnH/IO?=
 =?iso-8859-1?Q?oAeulYqdasfyAqb6mGy/O8nItHHB1yzD4SgtpcLXkONZj6b4IebK8oxpGz?=
 =?iso-8859-1?Q?0NWtAg0FK2OMx83JIpir1d5Evb+19xy/6+nSkz3ylWEy7k?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB7199.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fd1c3fc-3251-471e-2026-08de4eeb1bda
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jan 2026 19:21:22.4232
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kqfXNgtZ6bKZ7y8X/SA5EDqkfiJYfIiZz6SzGWxbAinHFYYLnmzr7gUdcIWOtR/scgoyyr8lrqneP9afKUqFpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8958
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: AEFAEC000E
X-Stat-Signature: gnncguf7omxkwq3bwz15yyufjwhb1s8z
X-HE-Tag: 1767900086-251206
X-HE-Meta: U2FsdGVkX19SFuuHZvPkIcjv3eul1QawruqyzfqE3tBH8aw9H1cuS3mCIZTragYx6EgyNzFyqaaQn2CIp4e/ipdP/R3esYr+j9j6npO3sMRrTbaJh6VWTDFjCJ0a8NTmHShShCIgA24xSOixk2WlXt8L+Ji+KhX6cHRUZ7DtED1mgM80KRAUkvzVK6MUVTnqzgnX2J2+JKbrIzPhl5AGu/4WcOW0Tb+lB5ByA4srOOeUsZcNk8dJ5Fec2LfBmwuB62U+Ol2kmYp+8oUUPQLNpagL+zrR26FBZTJ2pl4WEpJ3opNouDEwlHgC1SyzVSIKmEJ/51XHDAgkQ3orKDJ8lBUGgCVyYPWnsO4bgo+I9ItGqOR55l0NrNQhfI2GdF/PrvSXFz5et1DcY6RAnmuPsVNMvA/P1k50G2B7PVSzreTBkdILqf/6D3mlklb4y291GxMxDGGEo6lxYzPctFRh08iHG1JXiHvf4UaYy7cfUtYmX/XuWN9IqvYgcFbVqkI8JkWb6Qc4NSdc7x1/jMmPABd7wcDvpxKY20eSKPFWZsAr627/qyE56MaBvU6/KGhN7hm6SleCUJvwsuOiSX6MSjpAezgb9ZW2FtICkJn6ivBDKA/ARBCPEDhiM3c62sITXTgV4shTeQaOMU8HKe5d7a0kgIN8+p1LceNbFiMuDA1XN0+wbyq9hFamBNBo7j0dFDY0GMLrK+rWwRyodrx0sGPcTIgxp7YpyYVhugjU0BvDZW8iTFrsZxuhaoFUqg9XVvdfTHDpyeIwBUV+bGMVUjh4ZG/ipL9X9Hbab3+Gfl0hq6o3rv44X5DcOw3H5ckSB1TtFBPw9zAQaPQtXCtj+CFwdxQsiKn2RSmTiVciCex3xxN6CehYs1WLui/uaJhGvUeUdyVbsTknVYsKP2t5F3etDMSoA+e2oFE9WrtnW1UFkMDBMUZ5Z5gCtQzZUXBuaPFumu8JjnfBS8KVeIh
 PkKCd5Yu
 1+qnNy8BV5+XPyT1OUT25p25pc7Qmp5YdFRH00MHNUk2wgTaviVe0LSfDEl6pPJoy+UxyBoMXjuhGORlSu4C24ye6RglRMyzzATGRn/CB9qt0AqkglzMaYCPqKUgSP8QVndl/R35qWPmqgUCRjTi3GWyJfBhGKlKfzpK4H7mbDa6Z1nLPAh/cuVB8aOGA1xHUHk0Xoj+PFh3ykQ0QYjkd7GgvfUMAq3vRt63XnbK9mfreTzGg2XofpnIvXLz96iu1XNcieAd48dXxWWj6ezcoVWlv3GbAL0bo5zqKv2maW5t4wYM61bmz9DYjkDGeGxatV19rjOEZ/O7Br/0Jx/kTiXoC7SYAHgTP7aq+yBbgnwMDd9pOKbAofIcSR4Gqb7ju8qAdH0qNYDFBd9ER0ZiLnH/YhPD2eYS7LkOetEc8hLkwc780D3FNEap+hOwksajGoJRabhDvtITZA3MZKl6Ugtdne5OHotw9rk34LzcsKpfjL7CytRqqiW2RQud1Cc/egQXweuFhHshwygo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> +static inline=0A=
>> +struct nvgrace_gpu_pci_core_device *vma_to_nvdev(struct vm_area_struct =
*vma);=0A=
>=0A=
> Any reason not to define vma_to_nvdev() here directly, but later?=0A=
=0A=
Actually since it uses nvgrace_gpu_vfio_pci_mmap_ops; which the compiler=0A=
complains to be undeclared if vma_to_nvdev is moved up.=0A=
=0A=
>> +=A0=A0=A0=A0=A0=A0 ret =3D register_pfn_address_space(&region->pfn_addr=
ess_space);=0A=
>> +=0A=
>> +=A0=A0=A0=A0=A0=A0 return ret;=0A=
>=0A=
> nit: I believe "ret" is unnecessary here.=0A=
=0A=
Yes, I'll address that.=

