Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1FAFE9A03E
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 23:39:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E557D6B0088; Tue, 17 Feb 2026 18:39:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E033B6B0089; Tue, 17 Feb 2026 18:39:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C90B06B008A; Tue, 17 Feb 2026 18:39:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B32786B0088
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 18:39:26 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3530214038B
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 23:39:26 +0000 (UTC)
X-FDA: 84455567532.27.0659844
Received: from CWXP265CU010.outbound.protection.outlook.com (mail-ukwestazon11022137.outbound.protection.outlook.com [52.101.101.137])
	by imf17.hostedemail.com (Postfix) with ESMTP id 53FE140007
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 23:39:23 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=garyguo.net header.s=selector1 header.b=vuL9G+oj;
	spf=pass (imf17.hostedemail.com: domain of gary@garyguo.net designates 52.101.101.137 as permitted sender) smtp.mailfrom=gary@garyguo.net;
	dmarc=pass (policy=none) header.from=garyguo.net;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771371563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bpig5wIjhVIBBj8PoENiLi/C4aPogynRh9FAU/JLH3g=;
	b=fgvO9frrdpAaCxr1WX+K0pYA9CdcUaLw02tG/6Wk3XDHi4Flc/M6OG8iaO3J9/vh+5l+9y
	uFwcC96+887wP/fMYkJJJP5VylgHaQ0hLUDKsRcEst95FA6nYwKIy2BB04/vDQlEaLIWqW
	SB2HYDISeDfQMnNgidgibqYSMIo5pRA=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=garyguo.net header.s=selector1 header.b=vuL9G+oj;
	spf=pass (imf17.hostedemail.com: domain of gary@garyguo.net designates 52.101.101.137 as permitted sender) smtp.mailfrom=gary@garyguo.net;
	dmarc=pass (policy=none) header.from=garyguo.net;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771371563; a=rsa-sha256;
	cv=pass;
	b=K2M8+3npC0Y5O5KcXwx7iY53kjJZBkjd2t9+osTqVuloUPAzHilClqPeKola2BwEs780+J
	q+c2M32DpJEWoncYlt1LMhxwrfR2kfPr+jrE9em9Z72Cc6XVoiSqQX3cod8aheHSsYNRYG
	6aac8Z+60w/LaGtqFmXdrNaUj4B9pOU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Der2xEtPGGHq4Bk2ZP9XHqtlYql2jB0l9tUzpNxRIEFYfMlUFXuTSa2O5pAar4Yr0X+2K6NDFde29ODWp7dgiHen3YWXLvbZcd0wFUoHwZBke2jDc1n1f3Ia4BT3av/FwNBOeyreq1Tj4eHbjKdBy0U2HosVyqwREbTJWzRtvoG0YN8JH8CqNDrgIL39pggZV8d95zFgJj8dc56kqoQfPICjd9fpTOpWV2DdQ9CKdMc4GMAlUvR1AlPjAAVWU0uPmYIe7f4HJi1qX10uuBwcGRrwOOx66xgez+hy6zQcjAnNbSyfRrwxHIiz9888pkOhClVYMnayrY5Vj8df1IYm5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bpig5wIjhVIBBj8PoENiLi/C4aPogynRh9FAU/JLH3g=;
 b=LNIDGL5jdJ0yvstdGHW+1Cp2BtilB3br+0VQDkaa0Ajjq2A4KDSETDNcBGVELKKhSJQ38Nviyd09VR4PsA6P8bz3kY0THzq9kigF5pFkYNmc6wN60pAqKhWeMlYYTpOCNGyaO4h89rxA8Q+m9kdwXLJryGYYsBwkZU+9W2thMkjHat/dwi3KGTG8NhJdMjeE0QkLw8WALhgoHJ8wD5v0+rxpefI9kj0mmoY48Z9Bn4G/FC+upDywxbNFPVkTIgQNA34toyEkl0HggKEdf7QqpSu2HGT1a/Xa/OV2nLC3NgPSWWwVbvXFhSsBv8gbaJ4QEyBsRoBc+DmLvEWBCP2Spg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bpig5wIjhVIBBj8PoENiLi/C4aPogynRh9FAU/JLH3g=;
 b=vuL9G+oj0QKIH8hwlqL8HyOTC2zgXZUTuDy6jVjMwjRHCRB3GZdYFNwef3E4Lv7vo2m8MeE8a2htaxymk5FXvmlQdUVTTN+HFEi2YQ/60uiearhqnJQE11PjxqyB+9yMBnWTIo3Fa7voflRdulUEyVHTZeH/n361ztpMcdYdTPM=
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:488::16)
 by CWXP265MB5651.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:158::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.15; Tue, 17 Feb
 2026 23:39:19 +0000
Received: from LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986]) by LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 ([fe80::1c3:ceba:21b4:9986%5]) with mapi id 15.20.9632.010; Tue, 17 Feb 2026
 23:39:19 +0000
Date: Tue, 17 Feb 2026 23:39:18 +0000
From: Gary Guo <gary@garyguo.net>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Alice Ryhl <aliceryhl@google.com>, Boqun Feng <boqun@kernel.org>, Greg
 KH <gregkh@linuxfoundation.org>, Andreas Hindborg <a.hindborg@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Miguel Ojeda <ojeda@kernel.org>, Boqun Feng
 <boqun.feng@gmail.com>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, Trevor Gross
 <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, Will Deacon
 <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, linux-mm@kvack.org,
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] rust: page: add byte-wise atomic memory copy methods
In-Reply-To: <20260217154800.GY2995752@noisy.programming.kicks-ass.net>
References: <20260217091348.GT1395266@noisy.programming.kicks-ass.net>
 <aZQ19FEeGgigdwz9@google.com>
 <20260217094515.GV1395266@noisy.programming.kicks-ass.net>
 <aZQ8lJJ-U_8j03Z4@google.com>
 <20260217102557.GX1395266@noisy.programming.kicks-ass.net>
 <aZRHJ7pSzOHruPA2@google.com>
 <20260217110911.GY1395266@noisy.programming.kicks-ass.net>
 <aZRWOIPThLfIZ1Ph@google.com>
 <20260217120920.GZ1395266@noisy.programming.kicks-ass.net>
 <aZRokyTqsd_RwdkK@google.com>
 <20260217154800.GY2995752@noisy.programming.kicks-ass.net>
Message-ID: <cbbea9ecb994df975109d97a7756d73e@garyguo.net>
X-Sender: gary@garyguo.net
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0375.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18e::20) To LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:488::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LOVP265MB8871:EE_|CWXP265MB5651:EE_
X-MS-Office365-Filtering-Correlation-Id: 91a5ef93-3bbe-4953-6035-08de6e7dc555
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|10070799003|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?N3xD9/v083CmN2JbDMIEg5Npe1TqRhjB+X2ZtUaOJA4laculQXaUSceu429g?=
 =?us-ascii?Q?FJgYWPkXdCcIjwIAJ5QsF8Wg0X5t3IDvqnpd6mNf6AEfP7jeVyzrKLTIZsdj?=
 =?us-ascii?Q?TWD7o3SwqVa1RNWkXFJHQjnqiRCqF7s082V+650Vv4YN52DhX+nTk4JEiuW2?=
 =?us-ascii?Q?dLeS3Gdehbsbiz/l1E7D+DDLF4NwNaQLbsE/MIGTRUlP5iCdgxAmsvq53HAA?=
 =?us-ascii?Q?CymC+1+DHY1JDNRQ42XfmPUV0+oNBukizAsp6vax8QOdMUxsU1L9btcvvj2r?=
 =?us-ascii?Q?nXd0roV9wl9VBAdKjFG3ym+zgxn/yUTwY6Fo1PqCYoryXPhgzx8+JOp3A+pm?=
 =?us-ascii?Q?GAKLnhWytJg8IG+m9IpuUltvuFKKI5c8FUcyBlkKk2qGP8Bdorz27vTVVdv+?=
 =?us-ascii?Q?PBbdQ7k+TGC0OD9OhrOZTdoZmAJvkfBbYK10egBEclGujU9scGFP2qLOwIBe?=
 =?us-ascii?Q?q55vwAKLbW/FhwjMz76Hggm6lq1NGBzleJyFX6f7X9KWmsYi/moRyVMJExaX?=
 =?us-ascii?Q?vZzoglJhFd9R82jLOoskMh/PzBccm8YU8u2pYLW1NcCeeSze+Hc5fcuabKdR?=
 =?us-ascii?Q?BsT7MhdNy3olvUq+9Bb88zoSB8SnL1TJssOQ3NHo/yl1udBjZysLmI7AgFII?=
 =?us-ascii?Q?Y3GHDgHUG/+HkrFsXI1veRuOq4QLDfA8mzIDRpojppGGD7iVnR1k2lWBvEdD?=
 =?us-ascii?Q?w2ijGsX3gwP81GbxFG9AMVQiE7AHfwV3/mIPpFJQPm6E0JYm/QoDooy3IGE4?=
 =?us-ascii?Q?5fzm+hC2WZJolvlASyVXdZU/7UkEw5wWhfzwNHCz2EmaIb49KxvDpAlKYHzN?=
 =?us-ascii?Q?tW5zmeDg8gFEQe46TYIDehCE19n6asuTbT3trFz9vV/1j3JMNi8H1M8X/qrt?=
 =?us-ascii?Q?23X9UUPWXb5Ss6yIBBXF0IcUSheVFRNtV6sNB8/ztenPqW3x5kL+gR5y9TW7?=
 =?us-ascii?Q?VBnyRuTvw2ktBIaDskLGhTRFtmJMrofJVlX2PZ3xRxbeitz4PUf9BG3clKD+?=
 =?us-ascii?Q?GZo2kxUVAkinFAoH/+jY9W1HkyfF1TAV+rqstD2fogd2OqemH5D1mTI/MteM?=
 =?us-ascii?Q?RAn3/DD8+31l3ApSHN5cXCwe28UD0KJy7QRrpKjkl+WYKbUuyYD9x9q31unx?=
 =?us-ascii?Q?o9caRtQfECYs3dA+vRhB2eAkJdZ61d9WgSrRrMGjRBn6c01xCqwxwsc8Uuw2?=
 =?us-ascii?Q?+PjNVw4dEKssdp/ltdGKMHXVsZirvaDeMHQa5s2RLuoaT5yDKdsx+a7kOjPs?=
 =?us-ascii?Q?4HRNO2ltVYjHDzsy3+un/cVKOe8UkCKVAK30wPjH5WFtxdxY22iXL0iRFnVo?=
 =?us-ascii?Q?w3s6ynzYYaSL6iMlhpUz0fVGRluuvKr5l/Rc55KzXKMCVbixo7xC7PbGb/mr?=
 =?us-ascii?Q?JQm6HuFpm+by8lJvfzy7e9fA2xdo52H6UF/PzowTo3hFPcueTicABW2K5aSS?=
 =?us-ascii?Q?zjVA8K8VuFaAxdC9SGlMpr/2Tj+N/krewMTLtQY+9bydokLCRCN5DXrZZJMx?=
 =?us-ascii?Q?ZHwIrmriMGzAAJFh03a22sV9D07ROvQR973Y3rDUNDpeJjazbYQQs9tP1LZu?=
 =?us-ascii?Q?CxzJQ4iRYEI6duillKI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(10070799003)(376014)(7416014)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gmiOKhFbOQKdVHAYc0hRxF8zpiGIkNUyZtyQTisnT+zDT7mL82FDQpPe+8tP?=
 =?us-ascii?Q?Hq7AJFEmlY0s0aoWigid9kGf9N96qilhcnEAZZkkvHhkQG1FSGur4NEMGsp9?=
 =?us-ascii?Q?ZJZTvz5tAwsA2VTvK+XMSkHfvQEkduxe/ajr/+1gG9wn8HwEILt+rOU9n93Q?=
 =?us-ascii?Q?cEgt+HCG6rBDIjZpFRAASvJnx3LWyx9UXe7WKQ319Jy5ElN3uZM8wfLuDJ4H?=
 =?us-ascii?Q?Sj40uIhsHI6qpDSoxybhYyAZHY1rgyeBkF13UxvZXyCAwmQuxjZPrtn4VaxT?=
 =?us-ascii?Q?gfyeuTvhGBtqg+ulu4XoAoJ3EoKB8nsg9ca3degJPjouKSLMRgJxolxTonmh?=
 =?us-ascii?Q?XkQmy7uS91FGWRxwQVXcyCqJxAIIm29JC1Sxle+IHAK5dN0/RTds/h4p/I4P?=
 =?us-ascii?Q?49si/21NVy8GjHDNMGEW0SJ4ybyY7tNsMYwaXfXHWbrwPDEO2zdDZPE8aLTj?=
 =?us-ascii?Q?vTgFoZgBYnNC1u0bUX99A4aSh1Xc5ZBj7PCqFA3wWbg053DqmiwtRIReftRk?=
 =?us-ascii?Q?zptbyu/2jIat2V5eQCj31daJIWkNtgIP7mgzwW6v2GL51HwjPGjrXcvk28TG?=
 =?us-ascii?Q?onSlH5aXWbCuqOaE0NggBakyTQhY6riWcs2IX/HKcTL9DB0MnF/aQayNFDyY?=
 =?us-ascii?Q?6sIV8DZnqXETzOL0+hFhDRF7zhgzti7Vwcwl8b2Fd1ogPeKSWj3CGazQZ+n6?=
 =?us-ascii?Q?p8/s4XGTPpXVVutCulPm4mA+Z0745eWHt6NHx31wbeh0m0QZVsNSoonjun7y?=
 =?us-ascii?Q?mFORqL9/XG8mkMDJ6xOBzEW7BOTsRVNv0yFKTELhFZBGSG5WwuXZ7CxaX94W?=
 =?us-ascii?Q?rH2XxgfBqYfAnYXRaD8WyyEq+rM5UO8/yNuvBPIO3KtszdmmxGR3aOLYmjbl?=
 =?us-ascii?Q?XkWSI2Aonymk25YKF2OMjnu6d7pxk1Se5xNiETfxFt4Rqtqexh8wdSaobkYC?=
 =?us-ascii?Q?XVJ2Pl25SlvLKSNNAMOBKqBGNo786exM2kXpFpTMrIVvJ6lGgJG3YrGovdr8?=
 =?us-ascii?Q?LcUQ0uO5cIVltj7pjuNrh+IICvke5kZijjBe/r8e4zh+TfNuViDSeZmO8Z96?=
 =?us-ascii?Q?D8602Z1NriT1q6DOxFfFB1qQ7Vf+ZNksouGrrPsRXSqHzUTzTR3RpAi8IqaP?=
 =?us-ascii?Q?gU7BXa7iuOhp1XLYLR0TKIgoJrvLPmh+pH7+uOM6Suer8lhYZTQqhvp/tHJf?=
 =?us-ascii?Q?ObA751rstQvLqbx6mf37K6awa6U+pvu5VkGkb37f8skwRlqa7BYVGGl5Nv7V?=
 =?us-ascii?Q?pSbRGFq0Ta+ASdOQr25LvMYPo9XX/7IvffycZP7eOedKoVI5ot7RBAmOjaH8?=
 =?us-ascii?Q?zFPIDRZz6i1biflP7DFhbuovqcCtQr0CNwUg8VmSd7CXXArMM+tF7LlSvUxe?=
 =?us-ascii?Q?o3Og9FXQ2nptYSp87ntaBdhhlGfMXMsSyt98xcMJ9a0G56mxXzAaPmtJFaGl?=
 =?us-ascii?Q?aoPwCSvlNAuWfGOfB+lBEPI/6iyPF14br7an78CC8DkvDOEEG2TIBfAyIYpW?=
 =?us-ascii?Q?TBJSgUQUhiDaPdGdY5km76HoQEHMzr1tdWjZV3yQ6vfMViehxhC1jiuEYM7M?=
 =?us-ascii?Q?Ftm9/zT8wrPt2yf6K4dO6Q6wKZoQCDRQdu9amfiUwPwo4qDV0k+gJOFDnhWm?=
 =?us-ascii?Q?shsCphTygAI0g4IJbPrw6m2TidCMDqZXeqxJLZYffulWmo1sZj12sWlSRf9p?=
 =?us-ascii?Q?nBUxM+g0RED43ovm6xZwmQGd1xtnqPhfz4/FQteu6cl4OJTilnDaX7eI1I+P?=
 =?us-ascii?Q?xhEEzL6B8A=3D=3D?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: 91a5ef93-3bbe-4953-6035-08de6e7dc555
X-MS-Exchange-CrossTenant-AuthSource: LOVP265MB8871.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2026 23:39:19.5167
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TZXJQl9ENefj64zGp/FfiF/B0I+8bk3B8SueOx7BphBjE82C2MGPXHrCh5CuUcvEdOox/bT1KYXXM8g5fV4ApQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWXP265MB5651
X-Rspam-User: 
X-Rspamd-Queue-Id: 53FE140007
X-Rspamd-Server: rspam02
X-Stat-Signature: gjc4ahh4ta5ui933da7mf9eiwk1bt1ca
X-HE-Tag: 1771371563-586293
X-HE-Meta: U2FsdGVkX1+daDcZBWB2iLqCG4jJiZJ+18660LZSemSH5J4m+JxO7Xok5M6zHGiyAxZNNpOC0w644TuAdKknpV3DF3qhgl699sV/0KmVyWVGtLPM7AnmBjJrkIyfLpjDX52nZw81dwVBTcpshDNUa3L2fjurqoo757mfwTuROEEuPUAWEUOyU7LS3ZmkNC21st4OJOXMUn5VD2z0kTFmyMEyqdP9xBSYX0SRwPUqJPcDEP5rABMok0lYssVO5fauR9pXQX8wvlfuzcRqptXJHQenP1QD8FLGsigA6fnW6/NN8IA4Bsys21hy08mlknoliP1WjuLi4aLdQqwjw0/XLaWBmtKf0vwzSPgbjtJ6IAFQJm7/Op0tOPyJrAYHLe3wWr2zJAxDPEOfcV/2VUbbeS64IB/ZC4D9VPR1+M+eukvkP/XsacCXqX8A617M1LV9zyJ0VjFgO/nbqO+qsbJpU309BMuBsljIUweO7XlUbk9EJSQEzCpOifyWlWg6opb2SCfSjTr6orCRu4V4Su8gG69RXY/6Xj99RTwEHdeLA2uKnloFOJCMen1KlKTyiesvVwkT6pD+U+MeVdugCTOzFHH+LT6kBmq2Vnb2kRbxXuB/np/iZ/s8dnDsH59FaGaSyPEwXNZQUUIv9rJC2cPg1P23QCByFl0CELzF3eHbqEBE0jamdx01vBFsGuT53lDuFS+k/iuahsrt6fSuSGTMCDtncb8PVnPNthtwHl531MPd1fIKwLXWy5FjdUh0NVDlxUeskDnJ8oUMIyHKPod0Hhy5IZ0wxVqqPfG6wFQG5o37fidlHhpsOP4ZUvK/JcPNNH/UemP2zSzsKqRG6/l5fng+6WemUZRIJflBbWy2RDY6o1/r2cygbl6vxdQhh3Jh5mH3T7EfKaqO1HpzSLPieWMZ4zf0FZqgLGbMP0sH2trA3iB6CzlFRE+AvtpsyTBDTfaPrMVcSLqvLwvPuWh
 p2XHqA55
 XlCYOiREqBl2jlpf9fLQqWg0C2lnJOQimz/SnGvW/tOyXGcUKUsS/FklvjlJC/pG4KxZ+ALcLoYPmkVcm7JCYq0IgC4qsqgAx7BGlyW3tLXIPbc6doVS9VDj5eiH/l81km3cEudAA31uAMRtU60ckOkA353Ujtc1yHjNU1qUx65n8JhTWqpZd2XbLwpoP93Op4dT+MaWCo528NTANTYOPSDEnOthVQkiZySmXgp0xID3gPFigUc7l8DDHtxDnu29uXh50bgdT6eHHPcn2w012rUIF9DoZz4xeVtHz1oWAzjTQ7+pjQYl1gk2VA3Ec0yZDYCtbMlaIxAWpkeFHRXnuA2cEuZJ/5Ga7CynBce8SgFstp1PXPxU0CEKLOgxWvrZsaQ0kV7IlTKynPkiYXZ3msK6Myk9TJ2xexZcTOFYqYyqZqzlZwKLi6IX5upC+y0/Fg69vch7iUHp1PEE+0s2oyxnb8/nJriAKkZMb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-02-17 15:48, Peter Zijlstra wrote:
> On Tue, Feb 17, 2026 at 01:09:39PM +0000, Alice Ryhl wrote:
>> On Tue, Feb 17, 2026 at 01:09:20PM +0100, Peter Zijlstra wrote:
>> > On Tue, Feb 17, 2026 at 11:51:20AM +0000, Alice Ryhl wrote:
>> > 
>> > > In my experience with dealing with `struct page` that is mapped into a
>> > > vma, you need memcpy because the struct might be split across two
>> > > different pages in the vma. The pages are adjacent in userspace's
>> > > address space, but not necessarily adjacent from the kernel's POV.
>> > > 
>> > > So you might end up with something that looks like this:
>> > > 
>> > > struct foo val;
>> > > void *ptr1 = kmap_local_page(p1);
>> > > void *ptr2 = kmap_local_page(p2);
>> > > memcpy(ptr1 + offset, val, PAGE_SIZE - offset);
>> > > memcpy(ptr2, val + offset, sizeof(struct foo) - (PAGE_SIZE - offset));
>> > > kunmap_local(ptr2);
>> > > kunmap_local(ptr1);
>> > 
>> >   barrier();
>> > 
>> > > if (is_valid(&val)) {
>> > >     // use val
>> > > }
>> > > 
>> > > This exact thing happens in Binder. It has to be a memcpy.
>> > 
>> > Sure, but then stick that one barrier() in and you're good.
>> 
>> Are we really good? Consider this code:
>> 
>> 	bool is_valid(struct foo *val)
>> 	{
>> 		// for the sake of example
>> 		return val->my_field != 0;
>> 	}
>> 
>> 	struct foo val;
>> 
>> 	void *ptr = kmap_local_page(p1);
>> 	memcpy(ptr, val, sizeof(struct foo));
>> 	kunmap_local(p);
>> 	barrier();
>> 	if (is_valid(&val)) {
>> 	    // use val
>> 	}
>> 
>> optimize it into this first:
>> 
>> 	struct foo val;
>> 	int my_field_copy;
>> 
>> 	void *ptr = kmap_local_page(p1);
>> 	memcpy(ptr, val, sizeof(struct foo));
>> 	my_field_copy = val->my_field;
>> 	kunmap_local(p);
>> 	barrier();
>> 	if (my_field_copy != 0) {
>> 	    // use val
>> 	}
>> 
>> then optimize it into:
>> 
>> 	struct foo val;
>> 	int my_field_copy;
>> 
>> 	void *ptr = kmap_local_page(p1);
>> 	memcpy(ptr, val, sizeof(struct foo));
>> 	my_field_copy = ((struct foo *) ptr)->my_field;
>> 	kunmap_local(p);
>> 	barrier();
>> 	if (my_field_copy != 0) {
>> 	    // use val
>> 	}
> 
> I don;t think this is allowed. You're lifting the load over the
> barrier(), that is invalid.

This is allowed. Compilers perform escape analysis and find out that
"val" does not escape the function and therefore nothing can change "val".

A simple example to demonstrate this effect is that

    int x = 0;
    x = 1;
    barrier();
    do_something(x);

is happily optimized into

    barrier();
    do_something(1);

by both GCC and Clang. The fact that the local variable here is a struct and
memcpy is used to assign the value here does not make a fundamental difference.

barrier() does nothing to local variables if pointers to them do not escape the
local function.

>> 	int my_field_copy;
>> 
>> 	void *ptr = kmap_local_page(p1);
>> 	memcpy(ptr, val, sizeof(struct foo));
>> 	my_field_copy = ((struct foo *) ptr)->my_field;
>> 	kunmap_local(p);
>> 	barrier();
>> 	if (my_field_copy != 0) {
>> 	    // use val
>> 	}

Best,
Gary

