Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A501AC79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 15:10:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14AD76B0158; Mon,  5 Jan 2026 10:10:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 122DA6B015A; Mon,  5 Jan 2026 10:10:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F122B6B015B; Mon,  5 Jan 2026 10:10:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DA9C56B0158
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 10:10:23 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7502A56612
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 15:10:23 +0000 (UTC)
X-FDA: 84298246326.24.BA3D8A7
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf21.hostedemail.com (Postfix) with ESMTP id 065F81C0002
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 15:10:19 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Kdibfke5;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=lMs5VRYo;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf21.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767625820; a=rsa-sha256;
	cv=pass;
	b=N6uFy4qcjfJ6lFR4DjyFyc8R6d/jXc5fi2QeI4mhr3pEaGO9HraPd6xzexjf76LyZzpMJF
	sEF5/WXqnrXasxMnrK+GvpDT1pLA4CW0rMyNs2CQeF4jT6jlEFkPZ8Or6DTAzzrrPAQ1Rb
	PZ4Zud5PbohvMghdlxOu4AD/iyEIkEc=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Kdibfke5;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=lMs5VRYo;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf21.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767625820;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g8tFVkEp2viVXy6s/wdKZxAbH7GPS5RALCtOP/yfEbs=;
	b=NS8SnKFADvLNxSF2PQivbL+t1v5p7IX9EZJ55rhK6W62x1/wvncP8xVcOjSv6t325ORHxa
	v57IwPvVciQ8kjUgo8iNdfcEuHy5ieWVr6NfTJgxnHlCqqaVvilfg8k9N5rg/jH3fA1eGb
	H7TPcZTfY47uVTi6co88u/0BQ0jZc6I=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6050j4Ce774681;
	Mon, 5 Jan 2026 15:10:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=g8tFVkEp2viVXy6s/w
	dKZxAbH7GPS5RALCtOP/yfEbs=; b=Kdibfke5vjujh0FUjdYRvg96REBvAH1cSm
	Z7Xn8wq7gfLsP465sKbuNncP9asTx2dO74PObT1ih8P4GMtvCKXnAb/8iYlbjnUG
	J4QbHTZKut1fXIZbOpBwkhZ5NXyt7kUKGLATo9KXJ7jrDu73sQRZmEsNxj8OrM/w
	Ap2NwpLpk5XTJnTm9GVP41YINNFs9TjLQM6vmszhGPgg5CGET9fHfVGxxkqFbH8I
	gufiLvK1bOlJU8M1+cFIeKX/CzcyDHi3OpsUw+ejyM2smKmOteZQtMmdlIAz6nRP
	3OORs+OXd/zahYPQOCtbiEQz5s1M7jkZfizVojw5dK8D682XBkHA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bev2jhwnv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Jan 2026 15:10:09 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 605ECr62020398;
	Mon, 5 Jan 2026 15:10:09 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012029.outbound.protection.outlook.com [40.107.200.29])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4besjhfrjd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Jan 2026 15:10:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C73BgU38MnpUlEHd3vY0cxkV8EzZdUcgLwcOe4ZLQ5KMdcGSVJzSfJSfmJXLi8Q6wtuRfuGi0e9Z/CyRhTqRFcOqNhRg0JSIfMCzmiHcWEDO2BIHfdUIKRJFyn4Pls1Goo9uaXW+hCv2WYQNXIPiqJp+YkgXqQfJOjHeLFIlbGWYcrHZqtUyf3nCXxnobZ7fEbxbFjI9gJUS+7xgZ5wfDRoorHOVqEbuK7HpUoF9qVzJ4J8SBGQ2ZvPeN5NIGq/Pys3rMxn0i1oo3yySkCdZq+1jx2lDWDwpfpq2hKGyZYDOQ2h6LzS3LsGTOqdbbPdKZzG4Eu11agLHyWdoSRT4MQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g8tFVkEp2viVXy6s/wdKZxAbH7GPS5RALCtOP/yfEbs=;
 b=VlNwL8SULEoNCaVjt5B4ajFJe7G4hzmaDObYS9ao+V0AXvUQ8FuxnTNyR3JwFg1iUGlJyoX9suvvmELqpOEsu/LLkMryxwwMJDe3cS0nmZ8EwCKakWjmd6Hzo0lpKKByRoI8b/sOjEJrUfQabTWKUjedD++yYkFdssvSsE9SWlGIZByWR9eAaJZtE06TfRU/ryTa6520IWkBTCZoA5yU/K0nsUfBssgZhwWr4+9MFIQGwVR/83MgYpXyEO/Uan9a9TCKJg+/gTWtyxodcruft+Ki8ALApN92Sm5uZfV+Jtoz5PyoWmR1qiOcy3CyuFyaPS9vm5Aiv1MQsIm8PzlMOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g8tFVkEp2viVXy6s/wdKZxAbH7GPS5RALCtOP/yfEbs=;
 b=lMs5VRYo4JscC7zn6KNLSq2P3ZWJ8GLAjmxBVge1HJGGVb+4G/g0TxpwNSrjuS5UZ7PwIuCXkGdEAAKxGzW5TRxgkLP+siY0uZddgT8l+hp7cYtJpx1UblRsReqDKnRGiVNAnEVDGRpLmRgypK0fNCMSYeyb8e4aY0go8b7kZPw=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by PH7PR10MB6628.namprd10.prod.outlook.com (2603:10b6:510:20b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Mon, 5 Jan
 2026 15:10:06 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9478.004; Mon, 5 Jan 2026
 15:10:06 +0000
Date: Mon, 5 Jan 2026 10:10:03 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Alice Ryhl <aliceryhl@google.com>
Cc: rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
        Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Uladzislau Rezki <urezki@gmail.com>,
        Vitaly Wool <vitaly.wool@konsulko.se>, linux-mm@kvack.org
Subject: Re: [PATCH v2 11/27] rust: mm: add __rust_helper to helpers
Message-ID: <is6imcmf5dj6hfmmxdi2mtphodz67mvdprkuvbrcsm4ab3udl7@fbwcmsescdu4>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Uladzislau Rezki <urezki@gmail.com>, Vitaly Wool <vitaly.wool@konsulko.se>, linux-mm@kvack.org
References: <20260105-define-rust-helper-v2-0-51da5f454a67@google.com>
 <20260105-define-rust-helper-v2-11-51da5f454a67@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260105-define-rust-helper-v2-11-51da5f454a67@google.com>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: YT4P288CA0032.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d3::7) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|PH7PR10MB6628:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ed1f521-5f9a-480e-b8a6-08de4c6c8291
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?cjhSQsyKDVuCwbUJ47Rm5kgFpK+mFjN61yw9F37GNFNVQyZtTOaWVr/InEJ3?=
 =?us-ascii?Q?f3kjc5p8g4BzTIRaEqoo1YP3Bxds4z6XofqVcdH94EGZ3ngAUQRFmNR0YjaJ?=
 =?us-ascii?Q?RGaFZMrcKyKp2e6sar4NY973b7vK4zmYPlXKUQJKJis5MkcUfDR4pwsnPFRf?=
 =?us-ascii?Q?thfNvuiB2qN4KyD2bYJ7fOIfBPbNVv8P8HO6dSte9vvPisOJtpB85JzUh7YR?=
 =?us-ascii?Q?Nfd5GuOdGxADAarFz1X0q79xUouYk9pAA0pxvroGmuhrRQ9BXZG5YQTcD3sn?=
 =?us-ascii?Q?85hrD7iOMcF3Wq5+gjMWoL1YEVb7T/MZshR8a4jKWCifxBvWME2f5M9auU6q?=
 =?us-ascii?Q?aesq+pLRT4lrYG6nML3h99zB/JA6ARH4jvn/CK8i4QGMLMNLF7rQrhgUeuyW?=
 =?us-ascii?Q?MT6o/P/Jf4J09zmLLQJf5s3SWji+1GyL9oeLLZTpRQXd+sa6X5EVHIw0icbh?=
 =?us-ascii?Q?ZbXYPrMsNqGfVrtnZZuypK7sNSrXQGUH8nBknkNV7OdjrYW/zxWxTjRJUUcK?=
 =?us-ascii?Q?FVwl8fGaO7++x8zGaM4uBR43QQQPbuJzXP/456yokQFeitBz82puie5/Z+jW?=
 =?us-ascii?Q?Ct4TcKb5TutNOyO8zsuWbBjaFbTnlWtAsjL1AKq9nYVJ6cLieAWexLZj5CpZ?=
 =?us-ascii?Q?FilTH7PVCfDPZcoHElO9LpKmMyVmjv08/itVsrgSBIoLkQbsCQR2lGcU6mZx?=
 =?us-ascii?Q?Q2Qc6MxgYLoH495l70y/g2d15OYbiEh9gAKTs8r5B0u60iQgj9ROA7yy/mDn?=
 =?us-ascii?Q?0mhYXGO+IQDNy6dtkbQphTjrivEsXyqsR+bx8CqvsYN1HuSTbG0Yts3dAI0E?=
 =?us-ascii?Q?T5MKkudYn9/fURPbPjn9QTG2G0qg37WOc9IlN/rPRjl0kKni1xb28+5nUm8q?=
 =?us-ascii?Q?OdkS0QPy2O6iYtGBkS4Tu1e0RgfD+k/YfivuoMmiYj6fmZsmjJ8fuNYXFhRi?=
 =?us-ascii?Q?b20O9Iwi4CNOMQyOw8nyVZdtE4j0blhLYSVMMjmDPxz8Nitz0aFFp9y/apE3?=
 =?us-ascii?Q?xpyDWOQWtdLdnt5r8N+KdXSL5iMtHpNIbnz7RVT/PnwbdnjvBz9kXg6Q5I+e?=
 =?us-ascii?Q?Ufc6VnfZdqwmvuuhz9eGlBjtdv4bweqLyEQjPFueGsUX2r8O8NSTLYbheez4?=
 =?us-ascii?Q?1xoRlr5358VffdQYGYja6JnDoFDcCoAa6r9doHBHYKi6OusZVrvxejo5FvAv?=
 =?us-ascii?Q?5QyPl3V6yIjikwhRJl5donCZQwnx4R3w3EdWosOZ2j9Rg0se9FkKSpYjydFw?=
 =?us-ascii?Q?1AfZJkwyuXlbCuwhZOURPA11+lfNEBEeabsG41vHY+XUBrz3HBSa1Ivw3B1j?=
 =?us-ascii?Q?uZyK0VHfa5FjvWMu13R+lkCbUYbFabd6npBBZQ/d9BNSyY3MFtpoWWfhhMXs?=
 =?us-ascii?Q?66UTW18hXpe2AYvaNJ0FoYyH85JFNdmhsZ3HdRv6G2S7VeRywyWEcgxWgUqX?=
 =?us-ascii?Q?jajsqNGaW8CKjRRPH13S2wnvjRbwGoaT?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4WMjFtdjhT8Vyo+0LHR1Nj56fvwPNokyCt1hdLk5HD3eQaUy1mrvG3XeE7LW?=
 =?us-ascii?Q?fRaVioYJQfdgpjDtF8US6MKh/VhA2fqxkqegDbvIwKTokyE20f2rBZPJwPZQ?=
 =?us-ascii?Q?hGsJzfOWw2aoV1G4YpKPbXDRS82i576noe0DmayBIEPCTw2CjffQs+q3OZ5U?=
 =?us-ascii?Q?dVFtkFpXzPHVCJsmlmVInhW60R7AaLiZFB3EUJfEFsuXoRBbv5YvzrfcRvKx?=
 =?us-ascii?Q?PNgQXyUI3o2RnPwBLh8HJsuA8RteYL8o9OUu6KJ3peLBaL/p2rn786lwPY9m?=
 =?us-ascii?Q?17g9D8R0RoalByEa/JpY1tDdjqWbyzrGoe6LmDQN0CqkkSdJ5u5ZYHTF+Cdf?=
 =?us-ascii?Q?KjAgq/PAnsXeyAXSxH9Ii8Uu6xLM0m/kF4Bs4Yi5m2td3c45VsrmC9vylSUU?=
 =?us-ascii?Q?756/rI6h5OUq2/XXZGwzoBZ5O7mai5DN9R+dACbcP3LlYp7BLU9Bci7mQCGF?=
 =?us-ascii?Q?MQhG58v2RGu8xNChIXdq35J0ZIZnZRyBLsJo+48ApidPCNdFgH+4KJ6WCKIW?=
 =?us-ascii?Q?WkZGU+o2QkWhSrmF4grvCSvxzL7y6zQs7ZIjlAk9p0PB0IpH9cOuyW76exBX?=
 =?us-ascii?Q?flRuLr5BcJZsp4NUz/GH9AdoUxZPJiJWHnje2ObuCDFNdm29YuoVuPUuuluV?=
 =?us-ascii?Q?eF3Xevwawxd0SBnPByoYb1EH1pG2U4SE763LVw4+jJFg4SE9ApFUx9fJjsHW?=
 =?us-ascii?Q?+9Z0Q9weKbk4lInErOF7ltg1pI2sq8H9ZtaS9J4JAnCFli8hSoo9CXYTAOy9?=
 =?us-ascii?Q?x5mVR1eQsOFFoC+ypKBzpP36r9KLaYctFDdbXwIpV1hlMLrFU8fdtUqx2h/h?=
 =?us-ascii?Q?YXwJ93Q/7jEVer8xw+U7B+lmvtavxvCrL3CaqdHJZe8RhgKL5rJemLJFxaKd?=
 =?us-ascii?Q?ShD8t/13TBtigh5aj9jTwM5U27N5ET/bSnRWtstdR986xrqeueNCIoVg4iN0?=
 =?us-ascii?Q?haVO108nyt0Z5OReQpX7AGRGnC4EVmK/TR2JY9c2tc3cOZ38IWMxpNfoovIl?=
 =?us-ascii?Q?fbr05Vp6cUH8jV+GoPAAV4Xb6gZzN4hAk0PPG94pWa/C4B0ppiHoCWVo58Ma?=
 =?us-ascii?Q?TY5vQAZZnykGk07t389fgHfpqGoDLkyuUri853gsItaJhbRN54P8iW5ez50b?=
 =?us-ascii?Q?6C1r+uqMsoE3J7SPr4xIGLzc4viRF9oO8F9tSsFpeFhiO3fZUmwwWguP6Emf?=
 =?us-ascii?Q?AEDrwGqaypK418NeR1y4tHvSNk1HzXRvRtAtHW/9cKCyibD8NtgV4EUdcLwa?=
 =?us-ascii?Q?WuBK0z9u3nwVppcqe1/oyI0tGfGtdHvtNyZ2XmGjtlM+ReAAe/OnwJNztt3t?=
 =?us-ascii?Q?R5pVYsNZyVeQ2UKac6ZsC4AALficPa6PAx9VyiR/giqcIA7is4jN5OKETsCK?=
 =?us-ascii?Q?nGevRGVJciTqCXMN0xmhyA7CWyGzi4WpXQ4B0Y7GWDKuVmupOY6Kgmq1k589?=
 =?us-ascii?Q?CrA6fblZv6ci0DfUXadcpyDmi301Ev8CC+a6JNhUKxg2uyLHBUf3Wd7Pxmf9?=
 =?us-ascii?Q?CNB7Q9dL4mkUb9oZqr9rugwR0BbiXQ9WEqwrwAH3068ddx64+StNuCxD43Wi?=
 =?us-ascii?Q?d3H+e0on0RGp1yaK+DL7qscDSyEO61TCPtSuYFbckZ2FjEp2W3jfYb44kNb3?=
 =?us-ascii?Q?yNX0i6TJV/atqlye75Azvub/0XZuSBD/BIuyoE2JO0P2wys64TZt9NDkQODv?=
 =?us-ascii?Q?MudJbnm6ES+3XrInC2N6Qfzmz5Fq6ZamYQUtGmFAiBc6B/rShrF3WU2YyGgh?=
 =?us-ascii?Q?Vgj9VLpuVA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	71z9k8OXGEfgQn+u3RPmhViTFlq97dic6W/b0gs1TV9w/ZfKwcqg//Wu3gVDdl7gLf8XoZa5FiIqXMSs6vbo8L8AFhbaMnbQAbfg+OrGwZ3eEF8yrWF9+tjDh88CK0pT7L27g9DJqWhbFAp5JzqOQxcI6ST1eD1fRlOadt3NlBpAYXYwa/nEBbuyITTSSf4mgwsvdWbRFKWXGY51ayXDbH9+apvrLluYRYh/bBsMROhM52OmjirojA6H8RiODCEJLNxOkQXEiTQX2YfaDBJvtcbJ0JTHWhbXiiKdtGgsLv09LmCea78Tmkkzn11cHHXu1ek6Dgql8lb7mZdYxk0yYUJEVSKHW0Ymkx2+o2rbS387yRbwOZdfDXL8J3pyuu5tb4XqmbihfcWMGuNW/4AUhJBzLQ+OW8ZjIXlpuivvedeMRZUXML0jhtGUkUHRdoOTYt2ejEiZxJK6Gr6AJMDhoSzeVfUje6Eo9S6JCgAwuvrKPR76ikv11WtkA2YHaPurMFbiUQIeg8abJH2G9TpDBQHG5Vy7Te2v9fI6FgauJwwmooY3wa6XRSlk4RWrl8mJMf8XSPeICp/xBr+tbrk6IaOZP2npAtFTQHZIlH7MwMU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ed1f521-5f9a-480e-b8a6-08de4c6c8291
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2026 15:10:06.5012
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GrgMKuQRJTVVGOPKMsOUcF8k6Ujc666dl0nJ4OFNyHn25tEba0ng73wmvXhs0acUzbQN4Brwpkl8ELdCJFjJNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6628
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-05_01,2026-01-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=779 bulkscore=0
 suspectscore=0 malwarescore=0 adultscore=0 mlxscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601050132
X-Proofpoint-ORIG-GUID: qeQPeCFCsitFnKUI6eC3ATOxbXDaakKt
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA1MDEzMiBTYWx0ZWRfX1qBIO2NRHr1m
 0l62RXFWZMXMSVn06q4PQtMsVrg2Yu3um4ScBUk4Y8k9Evaz00Lmya4u9ZafRUo2PCXZ4vDMZOL
 bNledSpBq6/J8Cc9000ikfR8wrfutDVkXiItcXza4uHhVNC4yG7KiTZ2WDx4GcusGnUZfQyu/fg
 PUhqLa3c6vSWhO7MYF4YxJk0JrYo/hglxgF5vXzA764DE1utrfO/HDmxqlqEfo+jSCk+vAREEMe
 LkPu5mvvmyT/ZCVos9zo4z06tTiuD+zQkHj71vbMXh8rryxu/Yk44WsjlWJGqhww3X2gg/AVYqe
 7G8zkItXg8Rvc5kCjWpb7ljVMYr7JfLEBK2eMmsjrasSIgHJoz4slPy7JBXhMBHu1UIrtDaLtw1
 9xNE+4xLLuDg7CpSRMi4noBXKlr5VgsBTxP+87XvPQwcAmkLiTInEev+BWAgEN9Ku1NlmJTQ5Jf
 e+JVRJcguk7PWcfbtwc/Say4gjp99Ds2ugkQF5WQ=
X-Authority-Analysis: v=2.4 cv=A9hh/qWG c=1 sm=1 tr=0 ts=695bd451 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=1XWaLZrsAAAA:8 a=pGLkceISAAAA:8 a=_2yia0w1AAAA:8 a=yPCof4ZbAAAA:8
 a=Z4Rwk6OoAAAA:8 a=37rDS-QxAAAA:8 a=U1IP_ptgHfQz29uwG3MA:9 a=CjuIK1q_8ugA:10
 a=4yAS8WwzZ1jAEY03B-5r:22 a=HkZW87K1Qel5hWWM3VKY:22 a=k1Nq6YrhK2t884LQW06G:22
 cc=ntf awl=host:12109
X-Proofpoint-GUID: qeQPeCFCsitFnKUI6eC3ATOxbXDaakKt
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 065F81C0002
X-Stat-Signature: jih3y8djke78yffwgqeeibfoza3badwz
X-Rspam-User: 
X-HE-Tag: 1767625819-785846
X-HE-Meta: U2FsdGVkX1+wsPguoOY3L3zHH/Z8nfX8Vicr9qodHyM2ziCrDPbUz7vnxAn6Je5+XGGkZPlsFlY6jeZ4ZaIa3+JaWftf+2QwaU2jwGeAViwcK9RpNhxnC12HWCy+LzV4JK5pHH1zHNslRn+tqB4/Hu1eR2x23FwQ/2QvU1+vZPs/QtDjgzPCFkW/80ctwLq5py4YRdMJKNnY+yMMYiMzQN6mpn9PrRxQp3h3ckpfghyTglRDUO4cni674KSlK5fhHEbdN90LsLaIGokVaWinbFqEAewVbBO8XAaB1ZyKRll110l7+zR/cIixkOTePlZsGeYMaswSdbWxoWld23y+seoeo5WsMTpjOz3vUpXEqCZ7mXjSPEZa5uVnJ64ucw+FueFFphnU+3Ry4/3wXe5vX1WxMl+d7N8YLvTmekF4XvWb8O0LSfQz7WdVco9uB/eINVuRTV39/gMdS8e+5wP1VtgVwWmqKTQ5zfAT/cm0kFqHPYyFS0flvH+MOdzPNpozKSFLL5tFEOxkg3lmQCn/cooyxhxvUHp1uhoQrRuVYhvhGtA72bMGLq6veOL3On+OP0CSEDy6oCHlt2/2Rf5G3OFk8RHooMh2pNjTGFSiIsFolj/2ad3LyWCx916CKCARPTLdSjeCmIfyryYz5m72mvVa/pX/zsKNOiF3Qab+2cLGS5iZJRyV3oDURK8b2xYDu6RJYNKCqUkxVW4uiAf+wyRRtpGbHUMwV/X+UOh/h/GGEzCdpGzMoopn0z3cI8NpFixE0Y3W0DXp0Ht8j036AuUskHjT2U2PHIuoJXtzY4ihMqDSqA3eMKIXR9ey1gegnEdpp2FlTNHpKCoMzTypKQxBtBdhn9Qdr+Hbxre9bJRNcynT/h89/EwIQ2iIkvdZQV1wSa3j/ck4kZj3yz6xoncpusMxiYXkYsZcZECkPoFliuC0c1I27EBQvh3CHx54Fb9C3H9+YZfcWYhylLJ
 hvNPiYSz
 bEIUWrf4Gup7Y5za5H778+lj5OhWEIicowP40iSFb9KiaYgFgroI20OsqngLUTuxltDV4qLjBNy0e5PP31uu+ESDV+f11w8alAEhdYMVZYmODSJbWWRZUchHfXPIXsFxvko5fdKgYlmuezquwRffkd1iccxmkAHESXKawyfq1wKobDmS2JVXyfaqcIsSjbTfJnEF/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Alice Ryhl <aliceryhl@google.com> [260105 07:42]:
> This is needed to inline these helpers into Rust code.
> 
> Reviewed-by: Boqun Feng <boqun.feng@gmail.com>
> Reviewed-by: Gary Guo <gary@garyguo.net>
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>

Acked-by: Liam R. Howlett <Liam.Howlett@oracle.com>

> ---
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Uladzislau Rezki <urezki@gmail.com>
> Cc: Vitaly Wool <vitaly.wool@konsulko.se>
> Cc: linux-mm@kvack.org
> ---
>  rust/helpers/mm.c      | 20 ++++++++++----------
>  rust/helpers/page.c    |  9 +++++----
>  rust/helpers/vmalloc.c |  2 +-
>  3 files changed, 16 insertions(+), 15 deletions(-)
> 
> diff --git a/rust/helpers/mm.c b/rust/helpers/mm.c
> index 81b510c96fd2692dcb7ab4705f790bd3a41a630e..b5540997bd20d4398e2838956ed70b2fb61c5661 100644
> --- a/rust/helpers/mm.c
> +++ b/rust/helpers/mm.c
> @@ -3,48 +3,48 @@
>  #include <linux/mm.h>
>  #include <linux/sched/mm.h>
>  
> -void rust_helper_mmgrab(struct mm_struct *mm)
> +__rust_helper void rust_helper_mmgrab(struct mm_struct *mm)
>  {
>  	mmgrab(mm);
>  }
>  
> -void rust_helper_mmdrop(struct mm_struct *mm)
> +__rust_helper void rust_helper_mmdrop(struct mm_struct *mm)
>  {
>  	mmdrop(mm);
>  }
>  
> -void rust_helper_mmget(struct mm_struct *mm)
> +__rust_helper void rust_helper_mmget(struct mm_struct *mm)
>  {
>  	mmget(mm);
>  }
>  
> -bool rust_helper_mmget_not_zero(struct mm_struct *mm)
> +__rust_helper bool rust_helper_mmget_not_zero(struct mm_struct *mm)
>  {
>  	return mmget_not_zero(mm);
>  }
>  
> -void rust_helper_mmap_read_lock(struct mm_struct *mm)
> +__rust_helper void rust_helper_mmap_read_lock(struct mm_struct *mm)
>  {
>  	mmap_read_lock(mm);
>  }
>  
> -bool rust_helper_mmap_read_trylock(struct mm_struct *mm)
> +__rust_helper bool rust_helper_mmap_read_trylock(struct mm_struct *mm)
>  {
>  	return mmap_read_trylock(mm);
>  }
>  
> -void rust_helper_mmap_read_unlock(struct mm_struct *mm)
> +__rust_helper void rust_helper_mmap_read_unlock(struct mm_struct *mm)
>  {
>  	mmap_read_unlock(mm);
>  }
>  
> -struct vm_area_struct *rust_helper_vma_lookup(struct mm_struct *mm,
> -					      unsigned long addr)
> +__rust_helper struct vm_area_struct *
> +rust_helper_vma_lookup(struct mm_struct *mm, unsigned long addr)
>  {
>  	return vma_lookup(mm, addr);
>  }
>  
> -void rust_helper_vma_end_read(struct vm_area_struct *vma)
> +__rust_helper void rust_helper_vma_end_read(struct vm_area_struct *vma)
>  {
>  	vma_end_read(vma);
>  }
> diff --git a/rust/helpers/page.c b/rust/helpers/page.c
> index 7144de5a61dbdb3006a668961cd1b09440e74908..f8463fbed2a2670ddfd4c23dc922b46b0913c3a2 100644
> --- a/rust/helpers/page.c
> +++ b/rust/helpers/page.c
> @@ -4,23 +4,24 @@
>  #include <linux/highmem.h>
>  #include <linux/mm.h>
>  
> -struct page *rust_helper_alloc_pages(gfp_t gfp_mask, unsigned int order)
> +__rust_helper struct page *rust_helper_alloc_pages(gfp_t gfp_mask,
> +						   unsigned int order)
>  {
>  	return alloc_pages(gfp_mask, order);
>  }
>  
> -void *rust_helper_kmap_local_page(struct page *page)
> +__rust_helper void *rust_helper_kmap_local_page(struct page *page)
>  {
>  	return kmap_local_page(page);
>  }
>  
> -void rust_helper_kunmap_local(const void *addr)
> +__rust_helper void rust_helper_kunmap_local(const void *addr)
>  {
>  	kunmap_local(addr);
>  }
>  
>  #ifndef NODE_NOT_IN_PAGE_FLAGS
> -int rust_helper_page_to_nid(const struct page *page)
> +__rust_helper int rust_helper_page_to_nid(const struct page *page)
>  {
>  	return page_to_nid(page);
>  }
> diff --git a/rust/helpers/vmalloc.c b/rust/helpers/vmalloc.c
> index 7d7f7336b3d2f5a32e6a2b6cf8407da37775cfd9..326b030487a2b2199283b64b3b427e57cf5fb14a 100644
> --- a/rust/helpers/vmalloc.c
> +++ b/rust/helpers/vmalloc.c
> @@ -2,7 +2,7 @@
>  
>  #include <linux/vmalloc.h>
>  
> -void * __must_check __realloc_size(2)
> +__rust_helper void *__must_check __realloc_size(2)
>  rust_helper_vrealloc_node_align(const void *p, size_t size, unsigned long align,
>  				gfp_t flags, int node)
>  {
> 
> -- 
> 2.52.0.351.gbe84eed79e-goog
> 

