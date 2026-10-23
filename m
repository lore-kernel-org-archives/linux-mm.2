Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9051D606A336
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 14:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=codasip.com header.i=@codasip.com header.a=rsa-sha256 header.s=selector1 header.b=5pi5x4wg
Received: by kanga.kvack.org (Postfix)
	id A8AE86B0B76; Fri, 23 Oct 2026 10:15:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A60A56B0B78; Fri, 23 Oct 2026 10:15:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9506C6B0B79; Fri, 23 Oct 2026 10:15:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6AA536B0B76
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 10:15:09 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C9098140438
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 14:15:08 +0000 (UTC)
X-FDA: 85354087896.19.7D56ACB
Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11021090.outbound.protection.outlook.com [52.101.65.90])
	by imf05.hostedemail.com (Postfix) with ESMTP id C171C100005
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 14:15:05 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=codasip.com header.s=selector1 header.b=5pi5x4wg;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of florian.schmaus@codasip.com designates 52.101.65.90 as permitted sender) smtp.mailfrom=florian.schmaus@codasip.com;
	dmarc=pass (policy=quarantine) header.from=codasip.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792764905;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k97wc5/Nr9btLhTHuYwb5OSjrCgMvPEhSlRXPZGbixI=;
	b=HCPrI0GxhzkJbKVUCBQrxFleZDbE4uVxsRGk+lbdRhpBqBooB9WU5Ke1T/PRAnJ6Srvioe
	jJ5Y0MSK/bLX2nPi/LVZqvCwpt/bzDMgu5KvwuyLJk/3QS9kqEpDNRFrs3jMl0IPL8jX46
	/1HPz2W0xyTqQx0xz/EPSBAumfO0rk0=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=codasip.com header.s=selector1 header.b=5pi5x4wg;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of florian.schmaus@codasip.com designates 52.101.65.90 as permitted sender) smtp.mailfrom=florian.schmaus@codasip.com;
	dmarc=pass (policy=quarantine) header.from=codasip.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792764905;
	b=KPz+aqhDqk66YgHx/C2rMQXoDHmMmmbZKt3C9NkxcicjZLi6CsFukwIhc1eVsy14d8hEgx
	wjV3J4GIc0es+zwyZjfTZrzdk89cGuyQn8uxAJZxahrVFf9nlS6et6GEUQGYNhmG7XENPJ
	0iZMw6WE1PCMfsbiceiaCXK07qIkhJA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZaOgKcrZQSWHXiF4craqyLW902Iafqq9hnxNG7qdkNh6sWzxligEL8i4SKImT5g7MqvhmuEqxB75+WFoD8L+fU3U/B02dqVlz4EbC5ozjOqy6DjtaejEbVNIPe3GqHFkW5HGF6psz2JDFIu9ZbfgJuRYLpiWFv7OD8ZSG7YlfvrbZZUainu5M14xpkGQDyJU/bj2sqQZc69Y4GARm8LBo+ea3OMIpSkVYD5ZA0fue9jNZD+a6Gnny/okLVqXTFBvpeR3Gtnkx7ITGe5/NmDPv1p0RepgEYSbKiZwSM8RixVfp9bn2bjrvlgyL3EAz/pONhrzo0wQj8FhvMUqT2gL7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k97wc5/Nr9btLhTHuYwb5OSjrCgMvPEhSlRXPZGbixI=;
 b=qCq0A7epX5g10eiuaXevAWu77Gj74s6CGukNSXXpT06cX2GqC3ICfoiC6itebJGyY9BFRu41HGW9Q0LewU9aeUj6ZtWEJsXQSss5j1xfJwTXbwrc52dAJQMxLC5OZVc3xHVgPfwLZE1eAS+nPI8mHtHomZlKfmgiBOBafqULIwHjhTvcBmQ4qIBpJ1vGaYio+lbXu3SinbOPa8yt0VEwM2Jck/N4+OMhSq71T6WMFDVDX4t3iMNM75P9USm8rd576x4JLGt9pj0I2ER9GGXkA6bAEcaTKuAu2b74t6NcKkClD156cKxRiaXjxdNU7f/6eflukPO3Wb0Zk/Pw5amuCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=codasip.com; dmarc=pass action=none header.from=codasip.com;
 dkim=pass header.d=codasip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codasip.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k97wc5/Nr9btLhTHuYwb5OSjrCgMvPEhSlRXPZGbixI=;
 b=5pi5x4wgniZwf3IuYHvq80Dro9dZnCZ6Nv152Fa7lIhAZQM9HbspMSyhEPldkG2nmWx8uJ7IkeV3k92ZYHWzyED2y9FkY/Yd0lY6uiiecpJ8Xzx3dlKshpccI1jLbUUF+O+YFH2lOsmhme7sgCAO6pRGur4mlV5pfd4YZ2H+RvJuDMApq6O3/QoRXdSdBy8G2mxmSeA6+9RvIOt5vX4NWTVYnCodhFCp7PcE9H0TVPxoDNDNlyiNFOftI6d1T5E/qmuBrRhNq+XXOvRJKD+vgtBCt420ZTpKN/E9uIm0gz8EnJV3re+QRNWumylWXm6QSeRo+hQV3Uod4k+uYGk2NQ==
Received: from AM9P192MB0983.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:1f4::5)
 by DBAP192MB1003.EURP192.PROD.OUTLOOK.COM (2603:10a6:10:1cb::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.18; Fri, 23 Oct
 2026 14:15:02 +0000
Received: from AM9P192MB0983.EURP192.PROD.OUTLOOK.COM
 ([fe80::f0e5:8465:302:9a9c]) by AM9P192MB0983.EURP192.PROD.OUTLOOK.COM
 ([fe80::f0e5:8465:302:9a9c%4]) with mapi id 15.21.0546.017; Fri, 23 Oct 2026
 14:15:02 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 1/2] maple_tree: fix maple_range_64 crashes in RCU
 mode
From: Florian Schmaus <florian.schmaus@codasip.com>
To: Dimitris Charisis <dchar@cslab.ece.ntua.gr>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Alice Ryhl <aliceryhl@google.com>, 
 Andrew Ballance <andrewjballance@gmail.com>, 
 Suren Baghdasaryan <surenb@google.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 maple-tree@lists.infradead.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20261005-fix-maple-tree-range64-rcu-v3-1-ebe7fb278e20@cslab.ece.ntua.gr>
References: <20261005-fix-maple-tree-range64-rcu-v3-0-ebe7fb278e20@cslab.ece.ntua.gr>
 <20261005-fix-maple-tree-range64-rcu-v3-1-ebe7fb278e20@cslab.ece.ntua.gr>
Date: Fri, 23 Oct 2026 16:14:48 +0200
Message-Id: <179276488829.1655926.3574695443723279308.b4-review@b4>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=675;
 i=florian.schmaus@codasip.com; h=from:subject:message-id;
 bh=3zN1mSF2Z8tUlPr4aYzAo/bhPH13d4YAk73ZuXSncB8=;
 b=owGbwMvMwMWoZLn8xddWhSDG02pJDFm3s59w1C+oyq3g4ll1t6fjeu0MQbO74tm/vyxSOPt3w
 vzN5/LLOxnXszAwcjHMFFNkmV7KOt9K8c7D7Ce/18EMYmUCmSIt0sAABCwMfLmJeaVGOkZ6ptqG
 eoZAho5RPEROj0Ejs7i4NLVIN62gyCEvvySxJDM/r1gvvyA1ryC9QC8tM60kIyO/qDgVaIReXmq
 Jpbm5qYGppZuxo5Ghi7OroZmTq4mbk6OrkZGxpaO5q4WbqYWpkYGpEQMXpwDMNX+42f/pXnArn6
 dqxyscoDepUrdUuvpKX53mpWnKLiFvFrZfW8TxRVb/16H1my/EG/dPnrF/wfcU3fAP+VO0T8npl
 p6Y+ubolDrGnaxvpybbzy2+9Zv/kPe+fYnnL9kUvX+d1xDPrJI7dy7bO73qqpN56yR3KKYvubv4
 bdap+PUV/bY/eLaKn45R//Vj7vR1oTy7e1/d892pFvv7x02nnyeOz5wiYCRs0CHwP4VntsGdVq0
 bt19Iah0Xa9Znqzowbe6zpOU2e9tP6Ow2Ynh5+nPhXb3pZ+/mxanlvW/oaNyz3PT26a0eMWdfrv
 0vm9xlXCN35uZWJQuvjamH3t8sqmsuTKh/b1KfGZjlMaVJ7PD+mKViAA==
X-Developer-Key: i=florian.schmaus@codasip.com; a=openpgp;
 fpr=1357B01865B2503C18453D208CAC2A9678548E35
X-ClientProxiedBy: FR0P281CA0102.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a9::18) To AM9P192MB0983.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:1f4::5)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9P192MB0983:EE_|DBAP192MB1003:EE_
X-MS-Office365-Filtering-Correlation-Id: d0eb627f-d370-4b1e-eb88-08df31100743
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|376014|7416014|366016|23010399003|1800799024|56012099006|10067099003|18002099003|22082099003|4143699003;
X-Microsoft-Antispam-Message-Info:
	uNQY6LaFqhSaDtyTsZOasYuxEbtJa/PUHKg5yNr5ZXj/+L8JkRYPhMrgYowc8JQzr80XZiQqaOmdq4VjZtpLxab6dtcIO3ce4N3dSF4d6DQdI8xXWaVriwYSXnJuue+SIOLXI/u5ivxBb8Ul0V+e+C9UaxT2PgK/a+sTl6c9Ov8saE4ilPdK8RV2PytIHS1CO4cPqZogcSJssrL+2X0H0qdiA2ZzVTeTbxmA7AXdpyeDCkd1EZVpNOD5L701d5/mG/FIMSagm1B2yQmuM4CRZJMSPweEhN94kmnGGoUNA/7HzwnjUhA4L4+5dTK1tG1hsvwNtavqNmo6aLSYPpJD83OdSA451tckIOk3Hk7C4KUS4fls04STLlcwOJeylxpPw+Bi+u8JvnsJcAgdkBgQIk/zVy8zeOWPFFe9yGJ0RtaCQIlETCEwIsvJDzZj65bmF1YC0N9tqaUdSLbfUeLtTC+nwVA5PoYgJHaClxSvJV0KrfO6E1ifSUmIoVshzI2pKby4r6bmbw1Ls3iT96aorwoSSdCjDABorbPlwdUc4O7ztaNkWToAjPUyCLOFeX7HdKJLDCD7P9INonC32DRJe5GmCTKIjkdI4aboDSQ6OXPPjYMG3C1tQ6CSDpm7f51a5uXiqU4iWepS5hjmCuQyyb6aRktcQS+MfTRCfcpOfEg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9P192MB0983.EURP192.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(376014)(7416014)(366016)(23010399003)(1800799024)(56012099006)(10067099003)(18002099003)(22082099003)(4143699003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SXJrY2liNGlHb09jVUhrRk03bFM4b2cxeXNjOE5FdlRtamthajJiSGhlTmRO?=
 =?utf-8?B?c01jQXpobSs5TnllVVVZRVJXQXNzZTY0ZU16Y2NWUVpwdkRKazJDQ0ZhVWRE?=
 =?utf-8?B?VnplY1FWQ1hJQjNBOE1NQjBCeCtxdkE5LzRReUtFZUdaOUVVZWVSVlFHalc4?=
 =?utf-8?B?cUY5RVQ2UHdOR1BNVXFvUmVSc2hVTzJjcWxzTVBZZmpacFB2T3I4bkJVVWlF?=
 =?utf-8?B?a2VTYUpabXNUamdpY1pRNzJFRWJ4TnVqMlpyRXpIUlFvMFB2V09tM0x5Vita?=
 =?utf-8?B?OWtGbGZYOHJ6UXNyY1V5UlRYTlpEc3BOMDdHVG5TcjladHVYNlRRY1U1cE5L?=
 =?utf-8?B?RUdDRmxqTVVnaHJETDdzYWFiSE01ZUFpT0puTDVlUzFGUlZNNDhQcWhPVGtS?=
 =?utf-8?B?NXZHRExDUTUwUlJNN0FWYlBOVVcyZXNSOFVNQThoNWF5bW5reW1aR1ZGZUww?=
 =?utf-8?B?WDBtSU9LeEswS3RaTzc2SUVMT3BGTGxEcXZndHlrUUFNdnFMMjBDc1BzSkVQ?=
 =?utf-8?B?OUxTVXRjckJNUnlTWTFNWXdteTNhZTZKcVJhQWNpcUFGZHpUY20zRWVDdFVI?=
 =?utf-8?B?UGdDRG5hdEtTNnVrSUdMNkc4QU5RT0ZzTGNsNERXMEhzczBoV2E5RDAwWE00?=
 =?utf-8?B?SmE4d2pGVTRqTGhKcWc5YllWS0lmVURQTXlHeTRZUFBiemcrdFR0RTlxc0dH?=
 =?utf-8?B?amVlMFU5U2pWWkRENVAraG5wL2dwQXU5NHpBL2RuVHM0VGRQekM2RXBMdWJD?=
 =?utf-8?B?elEzUXUxaEVlYUJOTDBTR3BNV1picWN6VWUrdnduaHFmR1gzSzdmcTdIcHBF?=
 =?utf-8?B?cS9xVndxOGhBb1BtZzY3S2xMRG9RL0xOOFdXeGd3anpaZUVybzJhTUpIbkpL?=
 =?utf-8?B?QVlydDZYUjdJWHEvQUdXd2xKNStyRTFUblAzV3BoMWhPLzlZa2FkMEVpVC8x?=
 =?utf-8?B?RjZLQXk4OVRTeVJaY2JtQzROd3U1M0FVQUhNTklWWUJwc1NSNGd4bTVjaWs2?=
 =?utf-8?B?YmZqNmJlZXlGMUxzTlZlNmZLK2E2Ny9QWFNvSU8xMmZGWHRjVlhVdVdoeWJk?=
 =?utf-8?B?N1BGcHVoQmNnRmFxNjZxcEtpaklvN0MrRlRMQXN5QXFuVmllWkxGaXEwbjlL?=
 =?utf-8?B?ZmtDVGV2WVg3TCtreWtCaG15Sy9YRzgwQWNwNDMzSkNSWXd3MVlvQVdJRFF2?=
 =?utf-8?B?VGRUdjFPcXB1R0lUNjJuanYzSnMranZpUGx2MmdzL1Nrb3BTMWNrb1VHTDF2?=
 =?utf-8?B?Q1dTQlZvMnp4eUN6dnJiTUpWdzEwN3M5Zk9DUUg5cFdwRlFLMVgzdStwOFFC?=
 =?utf-8?B?anNpNTlqSEI3NzIvbzJhdkpJVFN5QUwzRDFaMFRtUHp0YVh1RUpEZVc5SGRE?=
 =?utf-8?B?dXMzTzFET3Uwa1ZtVGk1VDdEL0JQa3RuWi9QM2E3Nk5RVHlaOTJHcEZNQjBS?=
 =?utf-8?B?MUxyUmJ2K2V6c05PMDVZcmRuMWw4OEFsN0dhekloaWtYOHpUa09KTlRtd0s4?=
 =?utf-8?B?MUpRWFlBYWxSaDd4aWg3VHpJbkwwR0o4dVVjNDZvbWx5bmw2VU5UdEVKd2dy?=
 =?utf-8?B?WWIwR3hGMzdyVXNPK0ZBamhHQzVYUWREaXZ6WWVJbWhGQ2k3VGxnZFAwOGZl?=
 =?utf-8?B?UjkxOEFiVFl6QlJ3eTNHSGxmRC9iNGV3QlFnNGtMVE0rMStpcnVHWXM0c2Z5?=
 =?utf-8?B?ZG0yUnBuYmx0R3NpY21uQWQxZkVHdHlaN2pLOTZwWTlJQUhicUNGUllkay9C?=
 =?utf-8?B?YWg4QUVBSkFzcFpkMGR2c2laSjhxcllXQ2FOYkFlRXhHcGRiMXZzbVhRYy95?=
 =?utf-8?B?K3dWYzNjVFNIbmJybEM4cWVXblJZeWFPMnhybndwQzU3SmV1QXV6L0VPa2VM?=
 =?utf-8?B?eVJ2U0JvaGlhNFlHbitlMEpmcENaTEIvbVJFcWRSYTIrWTFNOHluVkh0ajlM?=
 =?utf-8?B?U0F3OUhqWDNnSFpTNHlhdk1CelJKemlSVmdRNFlqc29ETWIzbExxeC9YSVNL?=
 =?utf-8?B?enlnNCt4MUFzang2WXJMbk1PT2Y0dTU2cU9sbjhxV0NNKzR5YVlHME9PNkZw?=
 =?utf-8?B?aTJDMjNBZjl6a2VIc2tIbTJVbjBuV082KzJRcnhzRWJkSWp6ZjdHWlpvLzdI?=
 =?utf-8?B?NkkzT0JSOFppcGFoNnVscHRrU0VwZzVNaUhOSGV3Um9IbEJ0SStieXJQdm5j?=
 =?utf-8?B?RWVKaG44aUhvVTVlUTRjbkdDMStqZEM5K1BnVVd0MWh6cUpGTXJEUVhDa0Fr?=
 =?utf-8?B?M3NmVFBUa3hzQzM5ME1WYXRaNDlHVEhiQmNGTVBwUnE4bFM0Z2VnR3l3K2gz?=
 =?utf-8?B?OEpSMS9Kb01ZZ0ttV0JkN0gyaUpBWUw0c2crRFlWcmRSc21VTmRObVdVM05L?=
 =?utf-8?Q?2RptXZG7mAIQyejEQ5LmyPy9Mj/xrvzh0d1I/zfwtAqmV?=
X-MS-Exchange-AntiSpam-MessageData-1: wpIln5cUrXNybdC0I6a2nSnVp4GSb4QV/8w=
X-OriginatorOrg: codasip.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0eb627f-d370-4b1e-eb88-08df31100743
X-MS-Exchange-CrossTenant-AuthSource: AM9P192MB0983.EURP192.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2026 14:15:02.3919
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0d91ffef-bb81-4cbd-b9b8-552583685f20
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wAo2zxLBAuuMa1kaZ/AR8IPxfbQHC6/tZtiRFdZJdLn3myNY7vQzTVPND501cXfd4SEUC6mE08SqUqJvWbcVDal5OBY2gtAvIzW1ktJfmO0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAP192MB1003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C171C100005
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: bhfkndbh4gdy9p5xxew4bpc6jh7so9f5
X-HE-Tag: 1792764905-980082
X-HE-Meta: U2FsdGVkX1/W/SD0Bv9c54rxFyicnEfiUngbW5BDNuoou5BrS7rrZfkSjX8K0JvVDL+TdTDgQ+gGwl7BD8KEnEqI4zULYq/C+HtFN747Gbezyhfa9DNA9Ula3ADGhoRJr4GNWfq+Kg2SV+92WHCyNHwbyFp2FRivvGq/JhQ6E73/de/WM3lS3muPuNy01kv0PN+QLtrbTyF/VizC0ToMLfeh7esOZO55hhymtemKvbam6t/nRwUFAMyTPTUjErOiRFrPXHr8tckK7q8BQryLdKD4zNF1i0wPxh8Gdgg8SKZcw2jT8KxkkwcgfKoRJdCykmqMY49c88Ko68v9QwXoIZ+C8amPg4j3lsoqY5XhxdqZw6l/66wXlS07uTwPKmaeZGuNBWk//6YeFJR6P+UWbVlgC2dIufPl9K8UgFS6OD3VQS5A4TJYpOtou6BNjAh7UP1RrblqHr4vbuabRe51yTxI7nTH94oIkqUlc9fW/yXSl7hxzHIVSRFvhYa/nlwo0GWStrsLRtUWkzvtRJBMX+4TZd6jqghX0HK0h96YFGDnRoIvoJyzL5wlEALFoaGvXlX+cuAIlAm6JgvAvby/49ra52CJtrutf88lXTXACMwe4gerMngCCHu/vZBc6GAnSubIcC2sscp+0rXEejEktxKeAwRiKaNvDIcL+4vLsUYzi5MsIXQgE02ttChxJVloyCtg8FNf1eM9uh7X9ZqFlOVZYQVG/smpUhuUxRF7alhKViDG45qdPQU8IVRFU+hWcGrH9r3ew+s7YF/ZYxgCgWsslAs7TiwiDGbNjyLn3c5btSjj10aspqHa23t1d1/44Y6J+emOYWpUH19bIe5VoAb9ibYedjnI0fsaegqx5xuVh8k8CJISr9P9D8BXlcxA9vwtAys6gLVrE5QRTrBYKy6dYxQvaikzuevutN9RzAdeXSZhVBsjtjvxeKKGuUC/r32xHST/Glzr0yWdc8Y
 3aUpVQtG
 Qy/hlMcy7cH3kU1cmizMdPqHJ4WPeN08xpVCKscpf1+3eMDixackB1Ac8AtXqjsHht02iuMYUam8D5GDI/Aj7rKjps+ZvXw/DEmBH9sTkDGe5gXUd/pf+fO/hYbOFExpS9ayQfD8VPL3QoISi+IumXHOo3h/laec9q+DFbNOZJSs3G4zPQUt+MFy2GJj1JmQdA9tZ4C08WLhKQk2Vs3NNLMDT/0qUg/N8Xa9kKIJt4YiYEPI6aFY3+wAMvdwnlQYWEzMew8V24DlnhRT9srziXmYNRSW4EJIU8/cGNwdhJ17FwGX9kAD2DWB0I7g+j8KwuVTYMcQQ6OtyEYluzOZ0Htx3lNufflY5h8jo+PkcQG5NnlHAIIESlSz6Z7u0QXckpZjbUUbeMQCuvWsiytkBKPp7r90vLK7omg33mSUgPsl3ahTdJk3U1CnT2c3tCFkjKEdu0vfwh+qfs4GO6QqVJIw12voun6S5eiE9HF5mYttOtkV0ULv5c8I5zFW7XLwJ0l/GdqFAm5y7d1cwRc11E4i347r427+LeKHyesCx3Z5KnTM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 05 Oct 2026 12:47:27 +0000, Dimitris Charisis <dchar@cslab.ece.ntua.gr> wrote:
> This commit fixes two issues in maple_range_64 nodes under RCU mode. A
> maple_range_64 node repurposes its last slot to hold metadata whenever
> the node is not full. Both issues arise from mishandling that last slot.
> 
> More specifically the two fixes are:
> 
> 1. Remove mt_clear_meta() function. mt_clear_meta() decides whether the
>    last slot of a maple_range_64 node holds a child pointer or a
>    struct maple_metadata with the check
> 
> [...]

Reviewed-by: Florian Schmaus <florian.schmaus@codasip.com>

-- 
Florian Schmaus <florian.schmaus@codasip.com>

