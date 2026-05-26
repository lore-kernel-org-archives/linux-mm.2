Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D1C8CD5BD0
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 11:39:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 897306B00B5; Tue, 26 May 2026 07:39:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86E5F6B00C9; Tue, 26 May 2026 07:39:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75D106B00CA; Tue, 26 May 2026 07:39:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 645896B00B5
	for <linux-mm@kvack.org>; Tue, 26 May 2026 07:39:14 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2184D403D7
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:39:14 +0000 (UTC)
X-FDA: 84809375028.11.53C0EA0
Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11023074.outbound.protection.outlook.com [40.107.159.74])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4F3E1100005
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:39:11 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=codasip.com header.s=selector1 header.b=413oVPBX;
	spf=pass (imf05.hostedemail.com: domain of christian.gellermann@codasip.com designates 40.107.159.74 as permitted sender) smtp.mailfrom=christian.gellermann@codasip.com;
	dmarc=pass (policy=quarantine) header.from=codasip.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779795551;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=9ARl0AdwGZl0HIO0Ere5h0vUw4IzCF2C1uNyfPp5DhY=;
	b=ZaQRDgLOXSGjtVjb6hrbHH+e/YMQWpeyT9EApQwK5LfS5w7pI3vHa0e060dyhGZWkQV9US
	BNEm1g2bVGbIBtYZl97UucVSGn1xhTRuzXfRlGbjOPsPhiEnfEAxq8Fr4e0sJxVtQ4a3WF
	SkA5B5L82x+Y6s04r621eDXdmRBIHK8=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=codasip.com header.s=selector1 header.b=413oVPBX;
	spf=pass (imf05.hostedemail.com: domain of christian.gellermann@codasip.com designates 40.107.159.74 as permitted sender) smtp.mailfrom=christian.gellermann@codasip.com;
	dmarc=pass (policy=quarantine) header.from=codasip.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779795551; a=rsa-sha256;
	cv=fail;
	b=QbywF9PTdK28kxcK0odl2iCyN3zhyZy8FgWiQ9Bk9tjR74PMTbKY5b64RK1PsDEurP1jTB
	DRXKM5Ih+xtyoqY4UtXs522J94xhabLfVsYAwa1yojYB1bEpfPJA06yutcv/x2fa4icNzc
	IrsQezjaHwI2qwL7e1EPCAbrWMBYWrE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Gwpf9pwRb2zXK6Nr3esY4Y3EG0mxI9vr/Y6ADCb9BIGZ+GRuOza1fWR+HKMy/yHn2WISyePCF2M/jCS/rlF42ODJESS9N5HtMUCuv/04r5S5aa2vbT8SA4/NFDxziXVIqXRZnxZMeIvFLVzrjUznO6u4pb4sqpXnuVO2uF1cOYbRbsdxWlTu4bDSl+hN2tCEroAlfSrD4M/vFHjjwrwoGABM1Am3C04+hnvM4q844RMrLQWvjov9q3yRiElbPQRcrKivWmD/TlN5zZOrWukG4qZ5wpp0rm6vF80EYWU5tbjcudhFiLdxDBlRuucsIXjm2aigFYzOYWIrkURMdl9sMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9ARl0AdwGZl0HIO0Ere5h0vUw4IzCF2C1uNyfPp5DhY=;
 b=UhQp7yYnZVWPSfSCtHFsdxKbpFo3EMldZvdqfCod6zpcxBiOwuUabZmBdwGnIs9MFSszqNIN9g+YD2Z4sK/279qugFmzNfUA1DIM+mHRbmYtgU9MAdLdprm+KMfX8zTNgfPeCeeDn/DRpB5mvwVSUDDR2tb8WV6gX8NsdR7Sae6esfXTMvH/rQSnwevP21ceEF5h/J8jGRqar7o1Zp8WQL64g+kIMsCJ5Taa3jChd/Qn66nA5rxhC7xSMmQvxvETiTnaR858794QteiPIKm+YKjkFPF9IdkgzILX0FdYrMkP5LvrTqpb3waIWPKdEk9uEYEJbbycvm6B5L/KsZV/Yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=codasip.com; dmarc=pass action=none header.from=codasip.com;
 dkim=pass header.d=codasip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codasip.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9ARl0AdwGZl0HIO0Ere5h0vUw4IzCF2C1uNyfPp5DhY=;
 b=413oVPBX2DoOnNBgF0u16NbgzDW+ATcXgX75KJYZ2RLcdZMrIsRwjFZilJYfWwGYUGZNU8O5dVNj/kb7F1acavn1dejVnDZldAlIwOsEtO1sYOZDHdzZG4+1Ts4vR+TSvqarKfHytijfBL9dShgaRsGlxpgLNTO1L51oh4WSIq4VvYWH15eV8kIVCkXXlqhL/drSk52/wk8yo/y7kVRyiSLposdwTBwPqTiQE24ZiWsK75pV05ZA5i6fECNj2/AHobTs3OrN7AkME98PdGjIEd+72vqrWWgPf6O1RUK8pnJ5e8055NK1WHqgMU5UtGxKhXEMHWbWrJ/6KfRs5gw5Rw==
Received: from AM7P192MB0787.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:17c::14)
 by AM8P192MB0866.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:1e7::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.11; Tue, 26 May
 2026 11:39:06 +0000
Received: from AM7P192MB0787.EURP192.PROD.OUTLOOK.COM
 ([fe80::c1d1:f20d:9fb5:72d3]) by AM7P192MB0787.EURP192.PROD.OUTLOOK.COM
 ([fe80::c1d1:f20d:9fb5:72d3%6]) with mapi id 15.21.0071.010; Tue, 26 May 2026
 11:39:06 +0000
From: Chris Gellermann <christian.gellermann@codasip.com>
To: brauner@kernel.org,
	shuah@kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org
Cc: ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	Chris Gellermann <christian.gellermann@codasip.com>
Subject: [PATCH] selftest: Fix UB of getline due to missing var init
Date: Tue, 26 May 2026 13:38:48 +0200
Message-ID: <20260526113848.530105-1-christian.gellermann@codasip.com>
X-Mailer: git-send-email 2.47.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR09CA0153.eurprd09.prod.outlook.com
 (2603:10a6:803:12c::37) To AM7P192MB0787.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:17c::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM7P192MB0787:EE_|AM8P192MB0866:EE_
X-MS-Office365-Filtering-Correlation-Id: fee621d2-712d-46ba-334d-08debb1b64d7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|56012099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	fz9T/K4RsUnZw1p2jbx8Ottlx37uFnoFXLbxse+s4Rb7eC3P21l5P/wl7ftZj+UMQxuEXpUbRepnqt8chUbFoQ9hAcI8s4JyZgtBXNIdFheRdjIAo+vo8s1HNOGvRcZPv+L/eMSfvYIPU0xS1MHgAJs5kGLwOWPW1vUkjTC+4Kn7mTw+xdl5mImGteTJ1EvT93fK0v33q99Bk28ERz5Xx9oDlulWLTb2hpCSIkb3ESZHrS6B045nfwWNVMgX4rUAD2ZxxiifGYD8lDdRITRgQG57BoNELf/3e8qFSaR6JjSut4SZMcQWQEEVpeniZG4dQJQ1QfIb361Diud9VZ9cSer6GilSpR3dAgbL3H/mxvOjUbGW6U12ZLmI78p3uJzjS5IMKgBRBpX7v9KB1Ew2t80R1NjwGrZ//oGi75dEiWzzPNx2VRT79GMoDxPwiQmYAEdZRlENiFmggUDLeVOVaOQ6s9eSF/Up//gb0X28V2xnu9l/GE74VOpTZEimhM95xdZWiot71vrLmusHRD06sSix3gYVN+BH52zHWk9KEN4jYUraBp9kMGdCXEYEEDuNIYmR9Dmwo6eH7m35rMrKHsk21VwEMYKd1NBAxnSvuVfhBwOPzNSPs6dwYbmPcoBf81F9Xp9q8MVXw1MDqIXlJQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7P192MB0787.EURP192.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(56012099003)(18002099003)(6133799003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RMfPox71iKizB8XYnb7fhv/0BlGA610hoyusf+WLnYoLvKZFSqOvM5Xg1Ffc?=
 =?us-ascii?Q?2ZgzSbKVMxBO053YBRgi/puKbMZf4nZ1hgSVRI8Xycb1yuQgNI0JmIJhIsdL?=
 =?us-ascii?Q?5hQ0jzqlBwR+yMmNjZcVJbQPTQW5O9jro9VVmQq8LNXHLftCTZrRO0ar/3u6?=
 =?us-ascii?Q?4gaw2Xu1889PlaS8ZZLa4KIIkP8RmKOe+1UQxDOTYjQbHiz3p3BIOijCAeSY?=
 =?us-ascii?Q?g/8XWoMjKOhH+uQOE+8bDXyCL45h0tuU66aydL5YqpMAwM6W1mUSRQdxLnmp?=
 =?us-ascii?Q?ehUmjnmnTaCgD7obnDX71iKYMouyUz8Qweiz8eU/bm48/xvfSCcwnu2rlHnW?=
 =?us-ascii?Q?yWLbCjfwIcac8Jij2f3nOpDwZ1KA1yryASx/rzXvR/JEsswo8SdxbLzMsdd3?=
 =?us-ascii?Q?s/KGLSWxetBJzAqnaiPqiDQHhG7X17dcL3ozapLFaslaIm3g7KEXewLGu6Yx?=
 =?us-ascii?Q?GveiLJXTpf4dsRa4dK7C5jiLU2T3Pir9q8WUGSr+dAujna9V0g1DAAnMhFNJ?=
 =?us-ascii?Q?r4G+I3ttD/b4pWt+dJmgzDTI8rXHaSgbaNwoMp+2lAmJkG9/WT9aFnK1ILdp?=
 =?us-ascii?Q?YPQVtnAZAWYBe5QzDwiJpdwR5OqnCgOcGApuK3tUrqVGV3Cyp8OMSr1CAQ4L?=
 =?us-ascii?Q?0FzKLimBMc57MGWCTdjcWLlde2B4LNcSqlkS48kHnY2GCPtHT+dBDWEUW1/p?=
 =?us-ascii?Q?29t0uJwyNLcAe8lcUoYLLuOub1Z4HBcAzEb5CZn0QFg15Ydo/WXmh4rywj/7?=
 =?us-ascii?Q?lOES7Maxa4WrPAp94kP5QPUuGL8Iwxfb3VlLh8UaHl3m6TO9ww6Q5hcHtN5K?=
 =?us-ascii?Q?Q+E2AeFE8ZmbMf/+0cNzo71U/fneHge9nJKm3ugm+y5/m6Da0IkF9bXF7EUM?=
 =?us-ascii?Q?nhVfi8QFExtI7q5NRF1+9xFBZjM0lIjuotqwpLiUaY2T3zoFGlgVeYYFi5DF?=
 =?us-ascii?Q?N971688NCYycoWMdd0uz2k2Ow0+qDXR0fXfObsWeeIuse92M2iFkUrtJGY1x?=
 =?us-ascii?Q?5hWRqrISqme/SWKZKyrCpmdwjPWfqVMzsotHWtKYle2E6cYH9s5qS0wE/h/Y?=
 =?us-ascii?Q?8Tlc90cmZztVRaB9KafoAnSFeMECCZoieAMfBx+jS1qMfadZqsaqbf6o7kni?=
 =?us-ascii?Q?GDB/ef7vHZlReMNIY7jaBiI4ksEiSVCAZe0ai0TPfw2kNlZmju6tyrzBl6Ud?=
 =?us-ascii?Q?ygxfKMlF5qOmdno+C2WeInNKIEGztKeYAHJ/bbeyuUj2q5Xc3R0y1r1DcFZy?=
 =?us-ascii?Q?AeT3SunOfpU8MJb+SYRJPQQa3i5pIw4MHRF2E/XFEaqs3Gt6ofrzrOIiDbpM?=
 =?us-ascii?Q?BU30S/+6klsM/qEmpc171iw+xwWcqHAxWt13IS1R6a9u1KrTakRKoXoOYwgz?=
 =?us-ascii?Q?jZgduSJ7er2kOQxGQWssxuoAydatGg47626ea6OOudVPq55fR5BTCB+MJV/o?=
 =?us-ascii?Q?JLaqHsNeTy5qEvZklIjeSoCB1MuFnNVykNPTctRrBuzMBXxk8N7qqRK7YvU8?=
 =?us-ascii?Q?RQXRFO9+vXoaQNevfRuo7+lGaOn87MzzL40RlCwJPZGo060ayS879raE05tt?=
 =?us-ascii?Q?IMKiCJjmag/81Q/kgpPE/Im2qzRet3lN2j0oIWTZRIgGfriobl6dLEls+0LA?=
 =?us-ascii?Q?qCT5pbT9jLspujEYxOZLu7R34ewBEro3xJHypuNfG3Xr7buXsNXy3Swe/TJ4?=
 =?us-ascii?Q?Vc8hPMApheq2Xl/eOwpPqqi0FOnAo9WgVGkhczXI+oYWmjRepICwnEb2wpBR?=
 =?us-ascii?Q?Bp7wjxgX8IW8CWu2Ag9O5SbpeBxhmW176EM6+3ca6LQvMhabyyT0?=
X-OriginatorOrg: codasip.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fee621d2-712d-46ba-334d-08debb1b64d7
X-MS-Exchange-CrossTenant-AuthSource: AM7P192MB0787.EURP192.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2026 11:39:06.4243
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0d91ffef-bb81-4cbd-b9b8-552583685f20
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5m6kkJ8UIyb+dMdbYXy09sEpK6Myr22AK8BgbbmXpYSUdMy4yyhREUJLDBAFNvYvJuDD+f+fZAyUWuxMcklKFL7R9Eey/UCBVX9ogsriQpZgZ/54fbaC9rYAA8z4UzG9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8P192MB0866
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4F3E1100005
X-Stat-Signature: 6ymzthp551nnjc6g4wm8ibng6runhtzi
X-HE-Tag: 1779795551-975096
X-HE-Meta: U2FsdGVkX18krJfcHLB3YYAi2zL8bw/623ee9m3tFN5T/9AZXFBv3nkK+kH+Wf444GCYgQXPBg+a9pKqe0v1s+9vkMk9FTqn3Svw2CBfZFsbtzDu3hF1g0KCctd0+9QsEJM4ryK8cw204LgfcRoMwMQSetqGMtx2P5N+KPGenxsJ18Pc1tRky8Gh4XM1lP+mXXdqaX6pqetf+2pv8OU6qLRlATP2ATwUpg0TnQweqwgdIioH3CfqCjK2ngiw+iA2OQLYw8QGHabKkdnp0pbDSsm1C+ciEWxD+kVVekCwtZyyf1iXjACkx2KlYlWQoBWWb7LyrAH4sXJnhRzTNKhDJQRxWPTWceTgvxETpbSb9MtaXbMPP0Y1cyBKjCY4tD1BbADno+A+HfwKi9qiJY+qhS8gXl9u+RqPJnwrSDNjY4jRghNzayB0Ia5DJOhP2CnPyvmS+FG9C3PxYJqXeYhzoK+ELAesv7izT2+fhq0ZYNRLumaUYaDDXZPZI+WNqQcSLECIHy0CxtrNgj7S5JyQgRLn3M9abi/m3HgeucYT/CbFabBV8JLKVRedy6xkgsIPDtw7/AFnOFJDc6dT0U8OXVdyNi6PTy69koDJiuKqI1HmbwM7v/nNTYrPB3Tkoo0Fjms4S8iD+J7E3ARIRG1l0goSiv3ih8dvFPbGOQfYZNsYX1CYmkzurv7U4tCwLSq4HP8o2GvueFME0fMklT9feMTPRoFGjGC6OQU/2uW4GY/7WowKAlrEjZsOwiErtzcDO+BGd3n8XBsseB0uMK/+MST5uNRiqYU1hFasvr/nEk2iPo6cN5mNgiE0brcTzRjyTWiIA0825idvoXcgK3WVhKFPKbXmp/8EtbIeJIXFtUjPfkAHF+Cc+JEl57NVux7nqO6A0z5r0foAAyUpFvqVYlxQ238CKEuThCC6AgpMtSze9JjIuAs3XV1uuv/kp0tk2zWpgJQa22bsuKaGgzc
 EIZNar2i
 SUUiBwS+O35Qxzw/nNnTNal//l0SoOFrTxFr3qWSAJ/AiRHV5BOqySE/TPGrCnTuS/cWmyFAxvvBm34tR/V3J8C9iKlZY+sZ596N8nOvS94tbvZukmEa06Lube2Ztl8AAzZj1AxCHUBGlQWuBvD11lIBNInXu3IgQvtzGWJR0x5yhLezCuZyhTmpHdpn7lHlGaej4WGFcxK+LtnW6MypKVNq0ulbx+vk2m+e1hzDt2DEnH8cFcSVPPDKIANUFBC3mcir6JRuJiEhLdMiHxf3LzHQL1YkMvmCqiQpAqkmq4+euAa0bqdbpomoWYGIJicbLYSK/hAutL3AeQVlurfZ8LX13QJJuIRzYhHGKEKmbQx/xnvplRuiqRB9/DwsxjolHHluIind08YozZASTK+nAmq3x2aNoNj1f82WssexpqHIA8CUEinnduITOmadjeIWhd4TIZ3/q+vjU+8KxUrAqXKCI3nroj2FxywMVyEuFlq97cYzHuO6sWjwgOm5lh/vTHLOU8yHC9UyAlq51MV1oCi0I7NL7Iqd2Xn9Xrqqav6ldA3s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Clone3_set_tid uses getline(&line, &len, f) in a loop to read the
child's process status. The code expects that getline allocates the
buffer for the line on the first loop iteration. For this, glibc[1]
requires char *line to be set to NULL:

> ssize_t getline(char **restrict lineptr, ...)
> If *lineptr is set to NULL before the call, then getline() will
> allocate a buffer for storing the line.

However, char *line is only declared, leading to an undefined
initialization value. Fix this by properly initializing it to NULL.

Same issue fixed in mlock-random-test.

[1] https://man7.org/linux/man-pages/man3/getline.3.html

Fixes: 41585bbeeef9 ("selftests: add tests for clone3() with *set_tid")
Fixes: 26b4224d9961 ("selftests: expanding more mlock selftest")
Signed-off-by: Chris Gellermann <christian.gellermann@codasip.com>
---
 tools/testing/selftests/clone3/clone3_set_tid.c | 2 +-
 tools/testing/selftests/mm/mlock-random-test.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/clone3/clone3_set_tid.c b/tools/testing/selftests/clone3/clone3_set_tid.c
index 5c944aee6b41..485efa7c9eed 100644
--- a/tools/testing/selftests/clone3/clone3_set_tid.c
+++ b/tools/testing/selftests/clone3/clone3_set_tid.c
@@ -141,7 +141,7 @@ int main(int argc, char *argv[])
 {
 	FILE *f;
 	char buf;
-	char *line;
+	char *line = NULL;
 	int status;
 	int ret = -1;
 	size_t len = 0;
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


