Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A890C5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 05:25:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB3EB6B0910; Mon, 17 Aug 2026 01:25:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D65046B0911; Mon, 17 Aug 2026 01:25:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C53346B0912; Mon, 17 Aug 2026 01:25:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9C8726B0910
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 01:25:39 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3435480648
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 05:25:39 +0000 (UTC)
X-FDA: 85109623998.04.BF4505B
Received: from TYVP286CU001.outbound.protection.outlook.com (mail-japaneastazolkn19011039.outbound.protection.outlook.com [52.103.43.39])
	by imf20.hostedemail.com (Postfix) with ESMTP id 269471C0002
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 05:25:35 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=OUTLOOK.KR header.s=selector1 header.b=CsC37m5a;
	dmarc=pass (policy=none) header.from=outlook.kr;
	spf=pass (imf20.hostedemail.com: domain of seohyun.kim@outlook.kr designates 52.103.43.39 as permitted sender) smtp.mailfrom=seohyun.kim@outlook.kr;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786944336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=d7FGSiD3x8UKkh4uc/CjnG5LJxB7va8eT/P/KnW+UiI=;
	b=c42NzM2Dv0vmh873aAlK49TdY0SlH8fCRe70ANep+UtJkHcpEXLXptkuVV+9KGqSVeuNwV
	u2ujx1d9jy/fTSXnM2lnD2HIdKW8XH1GNFrNN72nomZvECG+QhoVPIO1l2dJGPCugegs4W
	23cYT0mxJmNka0nZdPqqvOGolSyXH5k=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=OUTLOOK.KR header.s=selector1 header.b=CsC37m5a;
	dmarc=pass (policy=none) header.from=outlook.kr;
	spf=pass (imf20.hostedemail.com: domain of seohyun.kim@outlook.kr designates 52.103.43.39 as permitted sender) smtp.mailfrom=seohyun.kim@outlook.kr;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786944336;
	b=zbEe4yGLBN3210cvKG6b+j/1ii9jGNje3W05/7Otys3AOxeaBvx1Q+FpP+oaZwZRI1ps6t
	qkJTnXg7RFYsoYpyuwKRbKdAuLOLo2ql5zhUPUjmohUNpp0W7nhzdYcgcHxh84Ius/GjNS
	fm6VPGYZ1p79PUz3ui3GZmNx9AlKQtA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dEOhpJtWql2Af53p9C8bKSSG0DZYkCi5haPyGmJediNKkz2BKr8kzMI6SMX1Fizub9YQKR7Jdk8RMaEloKes0FQAyW3OxdnPW0TnIn3h2RiXdCnEjWXUa9JYwOUusT/QNP2oOEdpWt0xX+Cm3HZynQi4DEu8KQolqiDfFRl1I70j6NN+9n9Pmds5la9RvW8iBzpVPCE7aXZEBvpgtj3HBcjCQ0MmiiweN5z+WmC6YpDneNdB7CU05QoX9prWdWgj4s8+PoRNaz5/z3WT5fDXs8U/yyBfUWQG+P71CRcICADHkZezmV1PHvlXDLYVShk0vxYzGc01ZnmNZdZKMi5cIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d7FGSiD3x8UKkh4uc/CjnG5LJxB7va8eT/P/KnW+UiI=;
 b=EbineJKuLawKUx7DKVWubL2kkiYI/tFsINUJQshO6K0M5Pf00f2KFwLeRIFUn1dPDMJLfE62OrfAuugRznuQHWfDVkMfTj4q2MGx4P+2sEvEDsQlFkWsmb+wP/jTNyZewAln6Z0kqFpMyBhvFSZ7MBSl4/LxL37YE6va9nQc2f5QWq9PD7Z1/ggHf1hgqWXhqILZN6qo8aqv/RG6NdokQ4fT9Ehig/81qQlzlfs661tmT57R/sF/bBy6AzWlFZhAzgcK5C7K6XcPVf3qlgqItrjZbXxcr8OvxrXHgIVI8GF55M/n9N/8PtwM7w15pqDqOk+DWQKBYbzgu5Z5waIG5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=OUTLOOK.KR;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d7FGSiD3x8UKkh4uc/CjnG5LJxB7va8eT/P/KnW+UiI=;
 b=CsC37m5a2tmoxF8DJqV1FRIP75OXQ0n1VWrhDQtfpjXKZ9Auf3SL22prEkcWcy+uAZHn6A4Eckq6UscYWw+yO99jw45bB1ISfYWCjEoWDnsKcIzJMEPBpocfoGwMCSfYihipJKsQEfoO+EpfrM0yktuEUh68E8Uo05syEn9dmIPWHLC2YtcDgTD0xt2rgvCGFKUf3fLw2xY9NLBGrGSQYKn7HYTIWjO1l0BlZkk/5ExySSfOqdU3bAdoqQuaTpM4eTL6dStJ/sWimzqFg+dyVsMRiFiZFvDYd85Fpw4L+HGMRkgqv9RY3K2qEgBahtmVNvcMkGb/4hIThskPqEZfHw==
Received: from OS7PR01MB13914.jpnprd01.prod.outlook.com
 (2603:1096:604:36b::13) by OSAPR01MB7302.jpnprd01.prod.outlook.com
 (2603:1096:604:11d::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.17; Mon, 17 Aug
 2026 05:25:29 +0000
Received: from OS7PR01MB13914.jpnprd01.prod.outlook.com
 ([fe80::641e:83cf:743b:85bc]) by OS7PR01MB13914.jpnprd01.prod.outlook.com
 ([fe80::641e:83cf:743b:85bc%5]) with mapi id 15.21.0315.016; Mon, 17 Aug 2026
 05:25:29 +0000
From: Eric Kim <seohyun.kim@outlook.kr>
To: akpm@linux-foundation.org
Cc: david@kernel.org,
	ljs@kernel.org,
	riel@surriel.com,
	liam@infradead.org,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Eric Kim <seohyun.kim@outlook.kr>,
	Barry Song <baohua@kernel.org>
Subject: [PATCH v4] mm/rmap: synchronize lock and unlock target in anon_vma_clone
Date: Mon, 17 Aug 2026 14:25:11 +0900
Message-ID:
 <OS7PR01MB13914C76BD66EFB5AE2BC8F6C96A72@OS7PR01MB13914.jpnprd01.prod.outlook.com>
X-Mailer: git-send-email 2.55.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SEWP216CA0060.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2ba::8) To OS7PR01MB13914.jpnprd01.prod.outlook.com
 (2603:1096:604:36b::13)
X-Microsoft-Original-Message-ID:
 <20260817052511.4761-1-seohyun.kim@outlook.kr>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: OS7PR01MB13914:EE_|OSAPR01MB7302:EE_
X-MS-Office365-Filtering-Correlation-Id: 846b4eef-73a8-4961-07b4-08defc1ff333
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|25031999004|23021999003|25010399006|5072599009|5062599005|15080799012|51005399006|24021099003|8060799015|19110799012|440099028|3412199025|40105399003|2607281247196008|1710799026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?oj6Uqqq2SI0+ZaPBR5WxBMKdFb+KXFr2wR8oKsrmc9ayKDhASHF6H1hIpjHY?=
 =?us-ascii?Q?/nK42VBTxl/vYYuIJtdl5mcgoi/BCyn/ozqzvaN6oXYDwZsCtASaYBnH0uxH?=
 =?us-ascii?Q?h5Tw0WjnGwfojS2vgyv8mIn1rIg/C/NzDRfoGounh6QKK2Piq1r0eDTE/rJI?=
 =?us-ascii?Q?HWh7GMvWKQMn7aZJfU0UcANy6DyEdM2zBx0Wg8wpJvSBPaUqFGMr96KndUI/?=
 =?us-ascii?Q?axjq2RiuO452t0xnxpb8yF0/6gN6Xri9acFF2zHafp0C4qLsODL7AlkCl+e8?=
 =?us-ascii?Q?sszyEb/YFOo10EW6HoTvdJJmnnLsnT0Y4sRgxBfI3ZJE1N8ElE7p0IPDgQWQ?=
 =?us-ascii?Q?S89HYNT2T+C7tCHfQcwTfNDPQWr9aOMoxzeBeG8RtwFpIjk/zeec8gt7ZyGI?=
 =?us-ascii?Q?yNZcI9rib20FvCTzWzikTICnzI1CF9zsquFlUueeUaFOt0nES0X1GPB3LXSa?=
 =?us-ascii?Q?lo8tdMz0j0Ns1LGTra9AbyNWBMhwuTXUea/uJRUyDZlSA/44+7Zar4eWmL/O?=
 =?us-ascii?Q?hH953VOTs7RZJzGyMjy2kRhxPQlHYPIq3fjcFXUod59XOsjKAb8Yq/5kuEuS?=
 =?us-ascii?Q?Lg86bqq2lumLiY1N2uHi08rK+vaxzMvYf+f0Yhbr6vmtme4nv+5ovgH/RDEM?=
 =?us-ascii?Q?L/vrH6izVZ5CQpO4vth1IA8QvdzWcYa5/nzqm/NC+GnXJgWcJYbvTSCe2wVb?=
 =?us-ascii?Q?LZX5D/SupM6Ga/pKpHHZL943ATDMDZqo98PX0wcWsNSN8BWY0QJz4YI7sZai?=
 =?us-ascii?Q?p7vh0xYqmpX2QXDWX7G3n+rYp+cEE4hs6Gn8myrKpbR2IKpBHSDfyJIqsYQg?=
 =?us-ascii?Q?s6xk0RYallSy4YpNLBs72Hikgsd1mdUtuAB+cE8Q3H33aJOx7JTYb1USmt8C?=
 =?us-ascii?Q?ytNa+i6tdb6ZsbuEh+PRT9S1YH8fGt7JJGVTStbUW/xVIVvAZKqYAmjTIKxW?=
 =?us-ascii?Q?EYOC7rlZLxxnDfq538IFfCLVuh3IhYbRS7rWtzWF68mymHPDaHAOZ2Zx0EEr?=
 =?us-ascii?Q?Im9lL1mn/c5TJ2odQ5aitE7wQg=3D=3D?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sxA6vUrFTTjD8EDjLc8BZOyrqTEXy5sT1DqoB6ZEr9HQ1zgdMJXzOUyxHRC/?=
 =?us-ascii?Q?q+TL8VKxqf7fWBJ2R9yQO8kUvdPXSQG5A3W6sUV96ScZvwvKhxvTCCP/EbQ8?=
 =?us-ascii?Q?04GQKX7CpOQPwawecwIHPgGzNaPnPap5dXfE9g2EIgazUG+61LPsCOSRJHaf?=
 =?us-ascii?Q?7BZtIJzyCWDMYY4dF4MgrFxkQUAExNuW5947r8linlnZkwp8pC9Z4tkb8u/a?=
 =?us-ascii?Q?fxl1UFEvfr/1IXpcz380csFw8QZzFg3wbTVM9TDMEY+KDN6CA42OsEu6N4WX?=
 =?us-ascii?Q?3APMInC73VEbXXtoslBbtRIOXB5VuWPEsWmBAzhviN4Q5C71G55jL0jMfP8A?=
 =?us-ascii?Q?p61ijI1AAQjTxcAPfbBIKYbAKwApZYdV5fbw86RDFgXsMAdEzqHfeFnNmhud?=
 =?us-ascii?Q?vI1On2/DF5ygapinHLUR4DmT6ClHgOdMfsPESQ1UzDt2WvjXNe5fk3MprPpu?=
 =?us-ascii?Q?LlPFZhUi2DR4ADrJn/jKiS9Tp6ivpICj1cb1U0ILipK4l+QV8/h0I2QSPQQo?=
 =?us-ascii?Q?agiCrWoeh9YrVFeg6W8PdXRFZXeyz7lkZVWkBeIQcKp8H7h6Tx2GEXz0LF7y?=
 =?us-ascii?Q?w5/KrdxOaZDovpz7q44EiWSV6gpWibfskoFXsd9JYCqnmk48KxDqcvXWyXAs?=
 =?us-ascii?Q?jd7pNf+uQD1wqsoVYG4HVHrSQwqymYPmxwyoL1vdnvBfVG5O8NPb0qSYSJTt?=
 =?us-ascii?Q?0v469OBlMLodiQsY1SGXBYrA80WZjcocyC9kPbEVqmZq2Pnf+TJo918JILjL?=
 =?us-ascii?Q?HbPjUHHqs8BOEOxOGs+X1MdPxNzyf3kgJ2Sm0+Cvcb+4Fkxi01C5Hwbh9Fgh?=
 =?us-ascii?Q?3mxSoBL/7tP9W5A7X1vrB3N2ZmNn+rPAyhh013YKdn9q+ueVqIId/5aPV8Lj?=
 =?us-ascii?Q?Xb0tq2wlbTB78xNGl0J5fylskC8cyxZAixMMeUUaK+dHpjSlRIBMocA1gQxl?=
 =?us-ascii?Q?Fok3KZTeAGyc8AWto/vvp3xnX1kr61d2Rc+4coG+qjc2rf3JxtwmWMuK8qhZ?=
 =?us-ascii?Q?Fv642Q43G69+kXezPPOtmnynYXIg63oRIdjupqSXfyCfBB18q0sbdcmjfub2?=
 =?us-ascii?Q?NX+T36d9crUOUdJb5QfrhM9U8KUBcD9dhrW+O0KVaJ7cliX91qkEOOxD/ozU?=
 =?us-ascii?Q?jbtndtL52B6Ju/caSXlD9EYyL8YljDYLyM8Q/Pag8qQ4JCXLpxrZYOzyLnIW?=
 =?us-ascii?Q?YT9CJtgpFCIJrkif/W8k88ehqvY/NI8vDuC/PimLYS6ZLim5BE8AzQhKKuQw?=
 =?us-ascii?Q?RhnPqj9x/yMut+1jZ4+t4uhak4oscVGFxa+eKxFoRqv2Zpz0GnLDZH/SZXXV?=
 =?us-ascii?Q?pkDL7jMQcIckOvmcFhHbeKdMMzIYwvlLrjHAxBMlaJWt+Mgw+wlaFhkHxUnY?=
 =?us-ascii?Q?vKO4cbSAawlPLRgC4x4teUV3lyB+?=
X-OriginatorOrg: sct-15-20-9412-3-msonline-outlook-b83fc.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 846b4eef-73a8-4961-07b4-08defc1ff333
X-MS-Exchange-CrossTenant-AuthSource: OS7PR01MB13914.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2026 05:25:29.0258
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSAPR01MB7302
X-Rspam-User: 
X-Stat-Signature: zugnt1euig4eaz4np1o691si3ocjat6i
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 269471C0002
X-HE-Tag: 1786944335-535112
X-HE-Meta: U2FsdGVkX19OlqDrTCo72EP5N/lG07pmHKtQe0g9OUqYGn6Y87P0apP8QbFi1onksXkvhHgqWd/+PqsvBAiTSsun4KEIHEFUoPjcQuWflTbX8Lg1B0Z4l8J52ZnW8WSp9pWvfaCRzv3uv+FoBasn/0e4KASOu/r8ITmhZ9bjwshiQ2LydTNfBIFvnI3Vue6Ig6tJymx5DuPxILQojPbMcL52i/+xmy2i3Jvbp7ViHT6IiAnaX1jl6Wv80NI3CpDuygBkIwO+2KqAueZXq00s5zMSNNvyLlkIdye1SipbD9b4JAQ75bXcnLc2lDOJyHuEjec7E4b9c4U/V29WTgYvfTpfzRJgnkNo48edA9Q9VOzQ0SirZl06IIYUMpq2JQI7SSbyRC2HjYA0lQ5uGNMpRYKZIIZ/w3qRaGEMzFyCkJ8D/GQ6Rb+CbB1gnZfJOFcVKieI+N8mPIOoZaafyOkQ1grGCLV//BmijQPw3/Hs+8sdxPraTKVvDVpBuESLYp+HauxUbb5FrsMD1s+BXDjGhcOerBAmEIKbeKoxJEnonJmq3FmaEF/0vIEPH3cLG7FMKjPOWkJcAKdiShjVdOgCmu9m5S4LGN1MF1G34gXCm5k+/YibrQKA4LQXBZBnXEzeN2+3a3BPZpTmsBXy5/c8tY2ey4NOxIzSlXzUjbOb6Y0HWrg3whor99kn0czSVnELyv+cdfz9i1vJD7xvNOZra1TX0LvLToVwUZ8Y4yqdZn6zD0Zvf+BNr2iB1SDLguowz18p+A3p6r/oVLS47j4UWNJL9sXFRD3T9k5IjpX+/3IFDWDY7RGL1+UkpVtnRCTHdKcrtk1icFO9D5xhTSjmd01Nge5oNunih158V2FEzlzYDqr1e9wb8ksJ8SukVGh4MQuofrOtgEReVbOQMuc2GRImXbjHnk9LHNgb2XoVPxFXunIroM1+O3sy2NEI2V+fgFNDoPE6fkeiWoz+njI
 KUEZ0XBq
 d90x2a4UaOAyYtnSOegt047l+eHUpewwmBbxbMWL2iLzzP6TSKqUl7rL9WoONKTtGU+cEG7QLTC+p+mNkuEQcND1WmZ2seeiQZ836DbzausZb0sILNxxGCP1COz4OMN6zsRBwtfGJH5CqhgHsZw16XE0/2Al4ruZZEbjuvKeedawJO+HeBefsDEr78670ZtnrXxj5skyd22IZ+t5I/A9OD4BLtvMWhMPYmmWJig9auRYKIpRsZ/g8R5FYvtkk05fTPNupomv7vuHVtgEloHF1SfBxjTjiBQ5iXcERp87FocwE63UIVb8jEYA1Qt1tzRwmUZGcfcRecp2sbCYkxlxdVJh3Fl2IqAqCPoMQHBsWa1vAROhzG9dm/rzyxHV3QXmfbjLl7CSw0nEochsazeKLtPFqiR9CjLVwKTSyBiTypHxQK+dKNRaDYpSSYlMn3JNQ0F61IxAlotzcGpRm1Llhbct3ml2SkhBGLm/WUuYtq3v7sb50X6BFL7SD4uhzqoijMKrHQyW5Kq6IotamtJhLvftdjdSoMDwixuDX+XCAE5C3AR0ro+u3NAiF9q9gljCAdSDMhxkNv16Pt7qnX4U+bN5yIhYQXWf8+NjLF0qaudry8rQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, in anon_vma_clone(), active_anon_vma is assigned from
src->anon_vma and is used when unlocking anon_vma after linking
new AVCs. However, the corresponding lock operation uses
src->anon_vma directly.

Although they are actually the same thing, use active_anon_vma
consistently to make the lock/unlock pair explicit.

Signed-off-by: Eric Kim <seohyun.kim@outlook.kr>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Rik van Riel <riel@surriel.com>
Reviewed-by: Barry Song <baohua@kernel.org>
---
v2:
- Clarify the commit message to explain that src->anon_vma and
  active_anon_vma refer to the same anon_vma.
v3:
- Carry over review tags from v2.
v4:
- Clarify ctive_anon_vma and src->anon_vma refer to the same
  anon_vma.

mm/rmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 1c77d5dc06e9..f3fadfb69c7f 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -350,7 +350,7 @@ int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src,
 	 * Now link the anon_vma's back to the newly inserted AVCs.
 	 * Note that all anon_vma's share the same root.
 	 */
-	anon_vma_lock_write(src->anon_vma);
+	anon_vma_lock_write(active_anon_vma);
 	list_for_each_entry_reverse(avc, &dst->anon_vma_chain, same_vma) {
 		struct anon_vma *anon_vma = avc->anon_vma;
 
-- 
2.55.0


