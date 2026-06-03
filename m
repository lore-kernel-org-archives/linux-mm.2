Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF1E4CD6E64
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 10:43:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DD4B6B0088; Wed,  3 Jun 2026 06:43:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28D926B008A; Wed,  3 Jun 2026 06:43:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A3BE6B0093; Wed,  3 Jun 2026 06:43:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0BC4A6B0088
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 06:43:57 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6D61C8D182
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 10:43:56 +0000 (UTC)
X-FDA: 84838266072.20.1E61C3A
Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11020130.outbound.protection.outlook.com [52.101.84.130])
	by imf11.hostedemail.com (Postfix) with ESMTP id 67CDE4000A
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 10:43:53 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=codasip.com header.s=selector1 header.b=ZAwgEnbd;
	spf=pass (imf11.hostedemail.com: domain of christian.gellermann@codasip.com designates 52.101.84.130 as permitted sender) smtp.mailfrom=christian.gellermann@codasip.com;
	dmarc=pass (policy=quarantine) header.from=codasip.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780483433;
	b=8I4Ky1azqFnppwZHSfMQ/s9MX13mqPVcAgSt2wWxuxSvypwtLDj5YqUuAVj+bpHwSJIDoy
	iEagISImLy0+gnHUB+1J/ofYiKpJM7RUBFh3DGUUdFFXbPMsatIkCjtaO01PItjTohyK0D
	OE39PEwZUnT0VivkXlEWFVuZNzYgLFM=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=codasip.com header.s=selector1 header.b=ZAwgEnbd;
	spf=pass (imf11.hostedemail.com: domain of christian.gellermann@codasip.com designates 52.101.84.130 as permitted sender) smtp.mailfrom=christian.gellermann@codasip.com;
	dmarc=pass (policy=quarantine) header.from=codasip.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780483433;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o4v9/IgDERqVqKcJXgAO44ONXqJsRcHAFHlsh97PBeQ=;
	b=Twwp9k/K3kjY1xoxy+kDLLXGlzqKnP1E/Jd7DC6lOAeAWKMvvGZzgnzIsolkzue192azqh
	bQ0KYhT9HoiOtFsn4BJlvSkhnht5aEKNrIO2H4eJGuOcOMsW9DwIIBROf4+DWfT8mKFFoc
	7HQKaQ5ws/vRhDDwt1jwQSQU5P0V1ag=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Xf7VdEY8zefAAvqDSmbTRJGOo9BghUp1UE/Oxl9hsWRY7ROeZ+SqI2PojyXDtX0zjakNB2RHRtBMr+UYFEJX4M8W7o8i7h9y1MJFGkABrEzKiUS8frDaRq7zBRYWepzN/BZQ7YfBdk7awcZVQsqJiprTrmh+5OyLJPLhcptsSQ5ymhXUfPzHhyIiW7KlGw6uj3iFhHXCMEY61qil1hW2/f2eROznvn0qR0DC2zoFzEHiiukT1ULjRDmOoiDz3nFFuXfDbsGZw3j0/E04ASCG+w4kFU1e9jW1KBH0rowkn+c4MDnMpR+Xp6HXm07g9pK5rY5eVoxKhUclBZSEqf/BGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o4v9/IgDERqVqKcJXgAO44ONXqJsRcHAFHlsh97PBeQ=;
 b=aOYkrljdd7Lk3b1Gi76jjxXktjSxnpVPfFxByMZY1nukUQpRahuYm47JjK9g+SxErkHy5tEkNxxQ/Dux3L7YZxYNJ+VM35uFCm+P0buITYMVnE/mlJYvq7KNeK343/jd9NSjbP7LqOXizI7OVQ8178dycJQrg+5W8If2hHw/o4L+MQLtCJcFrKDcYZqHrev/yzG2afAZ68uGDaYJlyevA5lHfwe9XLn7KMFCBcwZYWA9pU3MlIVx1Uy4NyeWrmU8H79N6t9AsHVYDKHkVW3IpR5tl9OyEvgsaGtf7uW3+aBH1eS9+QWJEk6Ma4AdE74w08aeD2R9ZB06aU7gWrTayA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=codasip.com; dmarc=pass action=none header.from=codasip.com;
 dkim=pass header.d=codasip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codasip.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o4v9/IgDERqVqKcJXgAO44ONXqJsRcHAFHlsh97PBeQ=;
 b=ZAwgEnbdiPgOu5fGnRL/xNbZmNfnvuybJDUzvXT4M7Ct1+WxPHI0q5Iyl0VafW3VqgCRoN5Vu4fbAaNuh0J6Dy8z8zaRxzKLLmUv5VOxgUPH7AufQ77r/27OWg5wIdQDk+aOXWtkDI9B+kXFo3YpJd21rpSY/n1FB40g/jhPwki1QaZwBUlSNwqoFq/taUZPEXQDL3/DjCwcbBR1y7XfQWc/5XxkDr11R6cSPmWe1Yng9Zph2Lo91+B6VmaQqRQ8V7bpYMOwzqC/pIG5mRBiAHOmiom+6XXNc8Vk9g46mky/tCROZRBreb5oGAySiTaw1ixX+toGMNtxr/Yrk9omSQ==
Received: from AM7P192MB0787.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:17c::14)
 by AM9P192MB0903.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:1cf::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.7; Wed, 3 Jun 2026
 10:43:50 +0000
Received: from AM7P192MB0787.EURP192.PROD.OUTLOOK.COM
 ([fe80::c1d1:f20d:9fb5:72d3]) by AM7P192MB0787.EURP192.PROD.OUTLOOK.COM
 ([fe80::c1d1:f20d:9fb5:72d3%6]) with mapi id 15.21.0071.011; Wed, 3 Jun 2026
 10:43:50 +0000
From: Chris Gellermann <christian.gellermann@codasip.com>
To: akpm@linux-foundation.org
Cc: brauner@kernel.org,
	christian.gellermann@codasip.com,
	david@kernel.org,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	mhocko@suse.com,
	rppt@kernel.org,
	shuah@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v2 2/2] selftests/mm: Fix potential wild pointer access of getline due to missing init
Date: Wed,  3 Jun 2026 12:43:10 +0200
Message-ID: <20260603104310.936706-2-christian.gellermann@codasip.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260603104310.936706-1-christian.gellermann@codasip.com>
References: <20260526113409.ea65314eb1da831de7c90ca6@linux-foundation.org>
 <20260603104310.936706-1-christian.gellermann@codasip.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VIZP296CA0010.AUTP296.PROD.OUTLOOK.COM
 (2603:10a6:800:2a1::17) To AM7P192MB0787.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:17c::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM7P192MB0787:EE_|AM9P192MB0903:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b0c5305-8303-4c5e-02f1-08dec15cffe6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|366016|376014|4143699003|56012099006|22082099003|6133799003|18002099003;
X-Microsoft-Antispam-Message-Info:
	EvSyr2kiDwjnoSI4z6nawwy6dLb3d+ox58qHyq+8CfyOGfzJIqPAQDvQVkBkK/hfhkVh8J0nW3S1GMz1adC7P/b6fOwCYAU79QJn6hzaxEVKyd8q8emjOCxwhe+YzfZQThRB+iuj1bhgV24UyQmXzLjvP2Jicm6tpzuPPNE3LwzOHq7OVYj2YjL+vEi+W2uoxbGC1eKGyXtBGjY7DyI883irLg6815biDaWDU9seX68IZQ+/cIKqt5ksDHKRq4GHb4hV1H81pW2S5dr2QBhiicyQdcWzHMp8ivpAgIzJyRkgHSIQ2eOICj79jpBliYYFnscIb0CHuk4h9/wn2KWYmfQPgQ2rDn+EpyMIBdeuhEchorUSNJOPd+sBqBeuigwLPoHg58yjRh2X3BRDEDiuPcv/VX8xKvr3voLsUWDmpUvOaxmsPC6wav00gdAslG1dZTFloDe8GcU+iZNlNQk/Awqcw6dvOrZ5H/0keReLP4DwjcUiR0UEElFN66+ekWG12CwdqcEa++vPMyewJjrWnCrd9/iSE9WmUC4Ri20aA0l69ZcJr+LN9caIfTcwO2UJPGgr1AqqsZM0aLR6XeoUC7hC0T4fUgwTMKle3YPYk4US7CPztGg+Cu40gBpqZgvL9DtaFjtIk23n4UOKjFg15n3fmCYHQIhWpFZ8k3LBMvdv29ES/RgUCliDLEXTQtbyjzk/T0tnMzBd4buedC6NtQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7P192MB0787.EURP192.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014)(4143699003)(56012099006)(22082099003)(6133799003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9ofhA8KCayQtqXoCFPszoIGcA4T/9OaI9UpStrkQin8b2jzAx2Dd7jo3iRiP?=
 =?us-ascii?Q?9cX1Bv+HD8cs82ETuC/DaJiQ0r2OMBKiHVU0LmjgzTpo8jgCAbbo2OyZnRmK?=
 =?us-ascii?Q?MgK3bw4mXHyZiI3VnitP29kxd4d2XXHmKMQV6Ht8Bw44J1a+NQIa1lNpZlrQ?=
 =?us-ascii?Q?6lCm+0khIyPKj9u1LOclqU8MRUyhTZ2R/6jVkvCZ7B18sZObp0i9pNY3Tm44?=
 =?us-ascii?Q?crgqItd8ml/wxuveD3LjV9X77mx13qul6gdd35JgaG4QeOk2/8uQu+k0P8v+?=
 =?us-ascii?Q?+a8YaGTuUTQjod6rlZ8gr1bKzL5qit8d8hid44xXN1i+vOCRQP1jVWJ1yr35?=
 =?us-ascii?Q?/zs7ZxVXMA/PNOm9WlWXzk59rkG/rFx0kUFNX0kOz/RiYpNZCcYcVHMDHdQl?=
 =?us-ascii?Q?aPgytpmfxz4iJ5gj/+KCIzcarnrRy6iG+4JLiRFoFh1jm5XD0dyC0noZxBm6?=
 =?us-ascii?Q?tH/y6YTSA75AfA13vUtAGr4HOO2yS8aKWuLuYGw4z8a68dvyY5PYl94pbDrp?=
 =?us-ascii?Q?lx42jfS8XUwio3mBoko6fgjcKD1+glf8BfqJfPsZYSGvX9YgPJk61MDV3xfZ?=
 =?us-ascii?Q?GTQlsOAFpT8ZUuGZK+x9jRpt36VeZ+Zqpwsukv67eFx98+xrcxNu2o33B9aS?=
 =?us-ascii?Q?pflyWwpV8a+BFzbRiFRl1AWTQk2FUukNwFIifRU/1gylVwxhbEpps2urzl4u?=
 =?us-ascii?Q?JiQSeOTj+JH8VR8Cwu6O1P8leElgOczW6GCNRd0os9FFjLO1PFhZh4LN9j/b?=
 =?us-ascii?Q?6wbYBXF8dh3BSa5OPhyO5qvsU+ZBI/VSyeyKj1fBYPjM7OppXR2iLiNnRuFn?=
 =?us-ascii?Q?Pan888KS6wkmedw8QB/3aAeSy3ijyAXeT+X8ZDC1Je1naap4zYBhj8kfepcT?=
 =?us-ascii?Q?ZBZaATnAlNDfTfU0m/j4hfMgKmtad0pZmNoFPNUdxebahlLvDMkK+zLAVzmT?=
 =?us-ascii?Q?e1CcY5YRK9RFQyC/QART/6HwnwkR+VDly473Y+UHLXgi8zjdVP4jfQA8CJ0G?=
 =?us-ascii?Q?kTDTvirfQbClhZNNh0Pc6fdnyy0focvnxUk/2VLOeHclSHkYP47338pXHDXb?=
 =?us-ascii?Q?zXcOsLlLNerqiX5JRlTrAj15mHPCfKtEp2tnYG2nPNd67NdaIoWLuHyODnvS?=
 =?us-ascii?Q?KRk2BONSuX57SkX+FHGvL5diV4XAqb2hPBFjPewzDRSY9PXzS04E0WvAyseF?=
 =?us-ascii?Q?a1kSVUuTU3KGL5vzWa378IdWL369RFMudM8A/0tCADCNxbNDnqxIoHqqERR6?=
 =?us-ascii?Q?x0ZUPm9SP6y8LFrMoVYnh0qCjU+04e5ZkLpm7JwUscd3eIsMu6Ios7CWyx3R?=
 =?us-ascii?Q?H2+cN9q5gwKQmUr86HvaH0H/K+oqZWZs1weljOrFpp/rugnYnGjurxBeOcxM?=
 =?us-ascii?Q?RHFsncv1eD/NdGx3sd1VMlS0IVQrfZKmHIusdl1Mv1L7AvoViJdWwUQ3uwGw?=
 =?us-ascii?Q?mm+CqHN0fomP5Yd96BGZyYjX3HdWmS8WSvskfiyv3KBblnzuKQBdholagZaN?=
 =?us-ascii?Q?szjMWGy4zYuTJOK9O5RiLlX1NY0qcwGKC8NyO2WiWGyTmFY8TFflDFbIMpKf?=
 =?us-ascii?Q?H6TFY7tLMhpuaqsiXYFtlVeCoDOVhekwIINAbfgX6X1hqYdRw3gEsLZeIML4?=
 =?us-ascii?Q?/s+xgB8OfqP17Darozwg8i//7z+mp24pA5yc+sVvsQO84b3YtCgtyTLZNDHK?=
 =?us-ascii?Q?dtgzQf0SoAvMg8p9/crg1nK5WQUdSc269jpPFH/P6poLzcbkNsK7d22xIyce?=
 =?us-ascii?Q?JIrsKI6gOkqxp0paAVHBBWThtRxvKqg=3D?=
X-OriginatorOrg: codasip.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b0c5305-8303-4c5e-02f1-08dec15cffe6
X-MS-Exchange-CrossTenant-AuthSource: AM7P192MB0787.EURP192.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2026 10:43:50.9056
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0d91ffef-bb81-4cbd-b9b8-552583685f20
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tWkp4ptiY291AvHUlWHmsviPhZ6eNuuERcgnvojo/N/hyqLuph11SRfPdOPbVh8dTBa/iQuYA15GmejpV1GA6RZfTpeTmUJYgpCdKvR2V+7SFqDKAQ9Hv40rpIoG3i6S
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9P192MB0903
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 67CDE4000A
X-Rspam-User: 
X-Stat-Signature: 7kkxcst3iy64ntcfooseu7xkb7henn8z
X-HE-Tag: 1780483433-524363
X-HE-Meta: U2FsdGVkX1/HuQTqhf7oeyQrVACZstqdMTVPVWSr+iiL/URCJORIgHw4uAYzMy+tKXjhNbz5OAUABYxtBPZHdTIQKKcTMgknB4iVHw/0HJxsXLRgKLjb3lTFSYxW8ASyZguMOpdSgyediozT8aoQcSgZDDxLgclL5FuSpHcZ78BO7QohiUrja/PV8QP2H9iSkVna7tobiBLgEsk639IZZ7I2MFV8R6jjhZf7y0wCX/T4CJq+4ym/JUu3aGbf0GA9zsyV/EKmjhm5e51AfZp9DcIP6ztDHDzsn++S47gZemM2RY4wI2WTYm8/2LP4QrXODuT3tZI38X8dZEnATKVJbm2K9qo4rao2Yl+dlaU7hWAl0YGFYI7wCh7qQRAj+yH+nf5cCeiuTTL3yeEYsxuY9liimj4/0nelLaCWbjqVdYac9CS32WwoKsfoJmEV7+hzF5aXKhQteeWuT6dtSgq4zLlf8T/b3Do1Fd3xsEFCtdYj0S8BYl16nFhrpHyrkLf6TUV2rM2AJrB92AgUcHgWDZM/dOH0zhawSaxfUJ/r6n5FlwMuQpOwMypBo98xYuDPOJ3CnBSttGn3FPpxhlNdAC+prGXEqFtQ+hALz1/aLA6p7wcEckBgwR42sv/kqlCErbku2Q45iQU/OymEPb2xNvvHkRAp+CKRiDBcVAVUfRcYJny7FSK2LxvJon4QC0dlW0SnTVtxBWuqddbZi5VevWc+s/hh/wDGUhKAVboaeW96Tv/8RP5ktcdVGk2yqD1Bb/KpuTFRVtcpmvINgtoC/tb8HxZFdzkuHHKiHXBEmWLVenTGNHQ366qTExbVV5CtFpkL3uxD0GUwWu2Um4n111V7ehYzO6mah1aUFT5zC0W5p1kN0Rsd9LmmSgeRMRih/Bx4JcP+5LaEL7w0G6ERpW6nbYOtnNXPtj64Hrj6e0wBtwyIBQzdoBz6L72xRlcTvkqPWW+6Fh/aflRUhRI
 +MAheuh+
 pWMvoXRGpFlLTx9ArDsIlN9RzHPsu4P4K0jNKbSfFjvGqvaEwZ2uB2u5Xenteti0HpUPwVs67AHROSeu4TQEwjudYYPCqP0XM08ZvIG8fDeJ2FmITDwjonqr/T9tE98b3zUC+ur7zRQVTu+4FNm30qkM5PUgQ5hfG0pXNbqWZbPu4PEBcCqCLd49hVbUKrEquosZwXcs6JCak43BLGp25e12ELHtL7F585Y1GrDzVe76VvbZs0jX8Aeob1hH0+lNGDRqfjMY6xMySFTtEqbfy+n45yq8OqA4lDL/198fzEJlMqUxyxAJT+Jv3RSM5YVmnlt4vi9Tv/VwWOcnFPqSOupK+98pDWILaCqNYpsPd3R2wtuldlov6SrxAv7cVWE2QXXQkyDQ40EwsQ+RUK9x21pVbS9Ar6g+8lpNbGYwxivflUtp33Oam5uyqCiMUDcJc1kC6Uduir/IRa4qKWNqulj3P58XpBDvVNgqanHo9YsL5parh7nJilsTbV4tOHakMRGoARFT7s4AYt1XY+iPDd9juJCZi7BG0zFrl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is another occurrence of using getline where the code assumes that
getline allocates memory to store the line, but the pointer passed to
it is uninitialized and potentially a non-null pointer. This
violates the Open Group Spec[1] and caused a segfault in a similar
situation in selftest/clone3/clone3_set_tid. Fix it by initializing the
line pointer to NULL.

The issue has been found by simply grepping through the selftest code
after running into the issue in clone3_set_tid. Whether it segfaults in
its current state is unknown to me. But it's good to be addressed due to
defensive reasons.

[1] https://pubs.opengroup.org/onlinepubs/9799919799/functions/getline.html

Fixes: 26b4224d9961 ("selftests: expanding more mlock selftest")
Cc: stable@vger.kernel.org
Acked-by: David Hildenbrand (arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Signed-off-by: Chris Gellermann <christian.gellermann@codasip.com>
---
 tools/testing/selftests/mm/mlock-random-test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/mlock-random-test.c b/tools/testing/selftests/mm/mlock-random-test.c
index 9d349c151360..16294bc7dae6 100644
--- a/tools/testing/selftests/mm/mlock-random-test.c
+++ b/tools/testing/selftests/mm/mlock-random-test.c
@@ -84,7 +84,7 @@ int get_proc_locked_vm_size(void)
 int get_proc_page_size(unsigned long addr)
 {
 	FILE *smaps;
-	char *line;
+	char *line = NULL;
 	unsigned long mmupage_size = 0;
 	size_t size;
 
-- 
2.47.3


