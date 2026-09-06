Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32CBFC79F99
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 13:02:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 233976B0088; Sun,  6 Sep 2026 09:02:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20B206B008A; Sun,  6 Sep 2026 09:02:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FA806B008C; Sun,  6 Sep 2026 09:02:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DA75D6B0088
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 09:02:12 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 55F96C0510
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 13:02:12 +0000 (UTC)
X-FDA: 85183350504.27.DB253D4
Received: from CWXP265CU008.outbound.protection.outlook.com (mail-ukwestazon11020094.outbound.protection.outlook.com [52.101.195.94])
	by imf17.hostedemail.com (Postfix) with ESMTP id 753F940008
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 13:02:09 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=garyguo.net header.s=selector1 header.b=xKYOvs7g;
	dmarc=pass (policy=none) header.from=garyguo.net;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of gary@garyguo.net designates 52.101.195.94 as permitted sender) smtp.mailfrom=gary@garyguo.net
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788699729;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z5sHOADaRnb4q6ggfAZo5w0PFsTjdXn0aCEfA1hegTU=;
	b=hcsIFttIfcT6sL66FpQwVNqKXzddrFezG0KGck+YkguOFQMdJtljML+sFxmgqztezUtqdR
	4FtNzKAHN0olv4wm50zu3Y7xLrr+Ytl8ccuYtuS00wUdlGvXQyTSxMtrCkWtbxAl1ESfWL
	NkK1sxxCG4mOoxijukywaOO6ZBWNdl0=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=garyguo.net header.s=selector1 header.b=xKYOvs7g;
	dmarc=pass (policy=none) header.from=garyguo.net;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of gary@garyguo.net designates 52.101.195.94 as permitted sender) smtp.mailfrom=gary@garyguo.net
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788699729;
	b=6jLv2DgMg7RJZx8yNgz+xWS/qrQTvb/gQ9+1835SJ4vjsukb/NN2FQpuHcXnfPQ41izjBx
	uQ61vXxEc+ilQqKjcjRqzc0TggkEivJAseSTSw+MuTHd5PaKeRH63A2L4wBPQzo9ab5/6O
	R1g/3yiN64hUdpQJsXNBZwaybBRMY4U=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uQVqy+M0uVhT5ynteeiQ3lKchUaXYVU3FPnJjiXMv5SvUtDXi8jTtGJf4bgToXeLRJ/4eESX72gh/TqLEQMXwEDyOe3Cc12uJFERefYa75enkgchOW78IlXHgGM2XjzcBL+5tfcO/N3gmRS/qtT2LLIzBoLHvk+6oFRosd90XnI0oZdeMDZIpu3rMNVZ8ODPqE6XREzxRMcgY6njDu3R/1HbmFYv1EopTapUixOOMZz4gkMobyn1ZRd0zrQan015+4uOwfk9wVZzz73sfIeTDytE+WaQvVfhYjlT+9xxgaaRRilXd2kmlSuZTcpn8gsIikkdSW4P8rlGCS0pBX5Ruw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z5sHOADaRnb4q6ggfAZo5w0PFsTjdXn0aCEfA1hegTU=;
 b=R7T5ugPbZo1qJP9fGmNOolgyjtZ2N6P8/JmGS9AJ0pTmVX8mEMU7I0ltKIkGpOowH0GHnLsdHnp2ggFPAm4KmMuOx3f2aQEXayDJmgTOd3KahN/yH/8gwdR1Nd4+gHioDZ+FtfC90jfDAzVuft6DBI99JGJw0vGXoP+SK5nVeDxtf9TJ8+BV+5/sotyiWzO4NCu42fYEQt+yhR+uWLFR7Ed5BM+RSEp3Jcckp5gZ/TaR3cPbmLNBmMXK3ya2Vl9p/qgQw4BrNnN+W1hsyawRO3ymkw5Rdkxvn3BAL37AFs0qa+3igvivc+WZVPizqrMp+2SJBUHLAowbWceaM1ag7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=garyguo.net; dmarc=pass action=none header.from=garyguo.net;
 dkim=pass header.d=garyguo.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garyguo.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z5sHOADaRnb4q6ggfAZo5w0PFsTjdXn0aCEfA1hegTU=;
 b=xKYOvs7g6y5D5MZ5R27QLvf29Ko54FtUx+Dzkp25bgN08q4GgbU3LRJLmoJRdI8UySTHimMB7ODvY32GJHKRZxhXHw71GsrbSayQh/WbQkhJYYmtRmgIKuT7OUD+1Odb8Lzo1x6FWoBoix+V/lryYRHdPiR8smWrUyIYvqIu2u0=
Received: from LOAP265MB8560.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:4ab::19)
 by LO0P265MB2635.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:14c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Sun, 6 Sep
 2026 13:02:05 +0000
Received: from LOAP265MB8560.GBRP265.PROD.OUTLOOK.COM
 ([fe80::f60b:1537:68d7:4fc1]) by LOAP265MB8560.GBRP265.PROD.OUTLOOK.COM
 ([fe80::f60b:1537:68d7:4fc1%4]) with mapi id 15.21.0382.014; Sun, 6 Sep 2026
 13:02:05 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sun, 06 Sep 2026 14:02:04 +0100
Message-Id: <DL894TFXM5AT.2QOXN683UKXIF@garyguo.net>
Subject: Re: [PATCH v20 4/8] rust: page: convert to `Ownable`'
From: "Gary Guo" <gary@garyguo.net>
To: "Alice Ryhl" <aliceryhl@google.com>, "Andreas Hindborg"
 <a.hindborg@kernel.org>
Cc: "Danilo Krummrich" <dakr@kernel.org>, "Lorenzo Stoakes"
 <ljs@kernel.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, "Uladzislau Rezki" <urezki@gmail.com>, "Miguel Ojeda"
 <ojeda@kernel.org>, "Boqun Feng" <boqun@kernel.org>, "Gary Guo"
 <gary@garyguo.net>, =?utf-8?q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, "Benno Lossin" <lossin@kernel.org>, "Trevor
 Gross" <tmgross@umich.edu>, "Daniel Almeida"
 <daniel.almeida@collabora.com>, "Tamir Duberstein" <tamird@kernel.org>,
 "Alexandre Courbot" <acourbot@nvidia.com>, =?utf-8?q?Onur_=C3=96zkan?=
 <work@onurozkan.dev>, "Lyude Paul" <lyude@redhat.com>, "Greg Kroah-Hartman"
 <gregkh@linuxfoundation.org>, =?utf-8?q?Arve_Hj=C3=B8nnev=C3=A5g?=
 <arve@android.com>, "Todd Kjos" <tkjos@android.com>, "Christian Brauner"
 <brauner@kernel.org>, "Carlos Llamas" <cmllamas@google.com>, "Rafael J.
 Wysocki" <rafael@kernel.org>, "Dave Ertman" <david.m.ertman@intel.com>,
 "Leon Romanovsky" <leon@kernel.org>, "Paul Moore" <paul@paul-moore.com>,
 "Serge Hallyn" <sergeh@kernel.org>, "David Airlie" <airlied@gmail.com>,
 "Simona Vetter" <simona@ffwll.ch>, "Alexander Viro"
 <viro@zeniv.linux.org.uk>, "Jan Kara" <jack@suse.cz>, "Igor Korotin"
 <igor.korotin@linux.dev>, "Viresh Kumar" <vireshk@kernel.org>, "Nishanth
 Menon" <nm@ti.com>, "Stephen Boyd" <sboyd@kernel.org>, "Bjorn Helgaas"
 <bhelgaas@google.com>, =?utf-8?q?Krzysztof_Wilczy=C5=84ski?=
 <kwilczynski@kernel.org>, "Pavel Tikhomirov" <ptikhomirov@virtuozzo.com>,
 "Michal Wilczynski" <m.wilczynski@samsung.com>, "Ira Weiny"
 <iweiny@kernel.org>, "Philipp Stanner" <phasta@kernel.org>,
 <rust-for-linux@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-mm@kvack.org>, <driver-core@lists.linux.dev>,
 <linux-block@vger.kernel.org>, <linux-security-module@vger.kernel.org>,
 <dri-devel@lists.freedesktop.org>, <linux-fsdevel@vger.kernel.org>,
 <linux-pm@vger.kernel.org>, <linux-pci@vger.kernel.org>,
 <linux-pwm@vger.kernel.org>, <linux-usb@vger.kernel.org>, "Asahi Lina"
 <lina+kernel@asahilina.net>
X-Mailer: aerc 0.22.0
References: <20260824-unique-ref-v20-0-490735672187@kernel.org>
 <20260824-unique-ref-v20-4-490735672187@kernel.org>
 <ao2WubjLtDuHvRzx@google.com>
In-Reply-To: <ao2WubjLtDuHvRzx@google.com>
X-ClientProxiedBy: LO4P123CA0491.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1ab::10) To LOAP265MB8560.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:4ab::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LOAP265MB8560:EE_|LO0P265MB2635:EE_
X-MS-Office365-Filtering-Correlation-Id: c199a891-13f7-4282-70cc-08df0c170d38
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|10070799003|366016|23010399003|1800799024|6133799003|10067099003|56012099006|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	oHZczSBmuvigdmwE0JkKMQ5z49WRn/lY+qSO0sohdjYq3x2ORIlQGt1RQ9jW6fRR+wWBtpgFwNEdbPuMLgE/NUNZRJeZILiYO1W0JwdrP8o465ggDu52dcmrEbnqv70SE1F2XJmVnoOhjSpMC62OA807bkYachAhXHzprZoLG4I3yhS62gX+IrgoydfAWWXXH/aBzAzdKITRUU+TOAzNZd8mQzR6Q1LP86+vFCsOdxAStDYCCwq43GCKxb+eoU2T/N4dFPTE1o1b5vOYr1ISv7ZUJJn7Y1EkY7c6+MDPLqtWKyJxyu6ocKB5CWiOyqBv1puQlt1c980QfgaTuAv9NhgtTT+RjUHuvAFYS8jTcUhxQwjMVFqkszUY/ujBBBYJaFoY4nTMb4P0j+zO+afd/iQm7H0sf+rI9SmpIWs6z7D5Jaz8js2HcqDDcDqFmjYF4pFyxy33dA8RO1WJ1xbn8JLMgeWt9KUdZ+MAwV8qy2YkH3CZNTzr5JCfzqC6BZxEG6W/7iQrHcoAvMjkkgNg8JwpBs7jUzaiuuNudacWfVtbXZBbWBFIHau3esnsnCBz9at/JziMPjCDu1Arn+EySzIkfwYwscrSwUsSP6rZHDGdgip/fNzKpaRa99S2D7DeeRPAGi3HU7zFZZPM+neP7aT+ImZrgmsBDvWcaDFosaY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LOAP265MB8560.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(10070799003)(366016)(23010399003)(1800799024)(6133799003)(10067099003)(56012099006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OFlaNEZsc2cxUml4ZC8zOThBVnEzUElqNzFSZTkwR3FPL0NiSm1wSHJENEh0?=
 =?utf-8?B?NzgwNGhyd2c4N1VCS2hvU0l2cjRwVlhPSFY3b21iUjV2dUlaRURpdGg4SDJx?=
 =?utf-8?B?cTBOYlIzRmlRMUFLNkFlbmFuUldxUHhMVUVXeUlXUjdVUUcyR1AxNk5nNGNX?=
 =?utf-8?B?aXc5akdrV3lFczQyenNjVHdwZm16NzFKWE8rUFF4VVpjdVNyekJaeDlSOGFX?=
 =?utf-8?B?bDNMNkhpRTdwbTdWR0plVDlPZ3hpV2F6S3ZkOHRsZmdpMDdXTkRhS2RoWS8y?=
 =?utf-8?B?WG50bDlzVkNaSGdCSTJGVHYzZEVYR0R3QVZmQ04rTTEzVGlZSisxQ2hOeVIy?=
 =?utf-8?B?R3lCQlFwdVpKbFN3b244RW81ZEhodUl0QStBVWRWdHJNbWlmL2Z6Y291RDhT?=
 =?utf-8?B?SVFqdFg0R0tmUnZGeW9QNDJ4QVhuN1F0bFVYVWZUQ0FSRG5rNXZJTG9ndmhs?=
 =?utf-8?B?d2pLK09MaXFsRnRPcnRMSWZQUWppN0w3RFI4L2hzTGp6dDRJeFFxNkxYbktq?=
 =?utf-8?B?bTVWZ3hmQTZDSVpoV0M4b1lDY3R4enl1VDVZNlgwZHNyL1g0OXprUUVPYXNR?=
 =?utf-8?B?RWVuNDJVZHk0THdMOXBKTEFvT3AvL1ZjTWtha2loUDNoY29rckx5a3RSVUVD?=
 =?utf-8?B?TU5HNll5b0o4a04xV2c1ak9TQjUxVGxyN3Fvd1FuZ3FHOEFUdTJQekFNSE8x?=
 =?utf-8?B?RFlTanBBZTljdThGNUhiM0htSHllNlpORm1jUVZLZjJpanhUaFd2QjRaa3J5?=
 =?utf-8?B?cndqdWRVSFMvQmxlb0UyNG5MLzlTLzdSeUNDQ0pWM0FWdVZCNy9ySjU2MHdV?=
 =?utf-8?B?dVV1cWVYUnFROWpSUys4dWZUcEV2SGdsZzJWcnA4dmFyOFlJeVhMYjJUZ3RI?=
 =?utf-8?B?TjZuekdaTkJoNkZuM0plMUhZTmFKYTBKRzBxQml6dkhrZm56YURHTittWlpu?=
 =?utf-8?B?VWVrUWhPODlLbkxWQnlCTm9ZTmxhRzN1eVc1ejAyVUc0ZDI4aFdUamo5d2NW?=
 =?utf-8?B?cjZ6TVc1a3RZUndoVXFveEdMNEsvWjlpSTJzTGR2SUZoeSt4bVA1Q1VPN2I4?=
 =?utf-8?B?bVl2cFVIU1FXOXNQL0RIUXBINlpZR3dsWldsNnAzdTF6N2NLeVV5S1QrdDV6?=
 =?utf-8?B?cVFNSXpRUXc5Y0MrTnNsd2k1QXdvMkkxOS8xZGNLaktHNWNrM2hmN0tScTZG?=
 =?utf-8?B?bGp0WlpMN3NyT1cvYW8xVlR5d0tleHJTZ0xjSmx0RlBsMjE5YTUwTTQ2eHht?=
 =?utf-8?B?NWhsQndUWUVZczJ2R2R5RFdtYWtFbG1JRU0vV25iL05WeHJINkZZVDZKRFRw?=
 =?utf-8?B?cWUvRDY5RCtOcERTNHRLdWJVb0xvb0R5TEphc2poSEM3UHM5Q1A1eXNycXdD?=
 =?utf-8?B?SmZ4bzdXTkh1VzFTV29NTlEvcjlNcUJjdEVqSGlhMnp3TGhCb2hiSU1HS3dR?=
 =?utf-8?B?VXFPK296RDVqVFRhMGNJKzFCckVQQ0w2a1k3Z1F0dUhnUkRrRnZxMXNkQk5m?=
 =?utf-8?B?ZHp2ZyttaThsZjIvRHJtVDZ2VHRRdjFWNWFXK3NkY09kTENicFZxN1Jkc1hL?=
 =?utf-8?B?TlVMRDY5aU9SQWVNMThuNGJLYUZ5TjJRSHJrUjErQ3JSbjAwbVdQNjFtQ3pS?=
 =?utf-8?B?UzRTc0VVbUJRZHhPSnhJZkdBUWpCVlVXMkZ1MnFhcm9mQjVRQ0NhbGpET3VN?=
 =?utf-8?B?NGhrZU5YSWpISitzUXl1U2xXOWFLdVoyc1RVdzZCNzRXdmhIVHRWU1NYTU93?=
 =?utf-8?B?cTdaYksyRzhmMDk4UTFWSmpLRTRHcWlIU0d0TzlnTzExckpodVJ5bnA4enhh?=
 =?utf-8?B?OUwwK3pmUGd1SjJFU28xN3RWc3FFaXBoQVRRcGNCN0V1aGZNck8zTHFVakF3?=
 =?utf-8?B?c250OEpOUEhhVmRRR2xKVlIvK0RWWVdtdC8yNE1oeVZranE2RmNiOG0vRndS?=
 =?utf-8?B?RkdXdU9Zb1I0L1FQcUtxNk15NlV2bjVzU2YvUmd5aXlvTms1VmpxQ01hQmdS?=
 =?utf-8?B?KzZxM0VvTXVZRFkvSjZHWVdVK05mQ21naldmUlI5d0QvN2Fzb2FOYnE1Rkhy?=
 =?utf-8?B?Z3NOMVNoYmZ3MUNFMk5QaTNCVnZhcG96TlFlQUdHK2lOTERWZTRZbXJIOWEw?=
 =?utf-8?B?MG4rTWdWeTRJRWEzTDUzZmdkN3BHaVF0WTQyTWRBNlFndEVhQnljeWd2cTVq?=
 =?utf-8?B?WktMQklOMGNKMENwWC9pMS8xU29HUEp0RWZLbS9yVWRQOThFM0NXa1VTanZU?=
 =?utf-8?B?VFFyMzM2cEw4MG1uaHRpd1hCM21ENTE0cGUxWDM4SHJhL3JwRFppSVViNzFM?=
 =?utf-8?B?V002d0x6aXNZTDdNOWpnc3ZjZTZvcEtURzV0OWphbWE2dGNVaklFZz09?=
X-OriginatorOrg: garyguo.net
X-MS-Exchange-CrossTenant-Network-Message-Id: c199a891-13f7-4282-70cc-08df0c170d38
X-MS-Exchange-CrossTenant-AuthSource: LOAP265MB8560.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2026 13:02:05.6269
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bbc898ad-b10f-4e10-8552-d9377b823d45
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AkauLTZx4X5Dz4gvyJANoeWosPMdYVkCsolGiDnoKV15dWosTp0jrJx8X0MuQySK6grKcr5AhOiWH/U23Qp8JA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO0P265MB2635
X-Stat-Signature: osrmwrta56rg4rxscy86js6g6e8gd7ob
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 753F940008
X-Rspam-User: 
X-HE-Tag: 1788699729-34913
X-HE-Meta: U2FsdGVkX1/xDcmLdEEFw1UCni+t9/vVdY0rMb3nag3cmHFPDsTYzzEv1IAsZn5aiNyNhPDCKDNfsFixQktqAn0IOxbg5f0pYvA4JNYQWmXWgVmR5ZhX5U21WMXvSIAAO29jYDYEG+Y2uP8HlYERh3a4jFRglTtI3NIuCQ5vHV+o+f4WIaHdTO20yoMMEs9PuhFCXyP13iNPLMpFK4v6I/6X40C+WvNXUaqehY7/q+sNUJtAv9IkTnjNk9EoIvxqimMnRySuDug2T8PlZE7xDB0j79ju9j6t/di+2uCEBapBnM7CKmlKnqKd+jEp0e2VBzIyqme1Oxy134XVwmole4DL8cc5+6C6WBlX4NJPKgWTznoAIE6wFLWSa8jBcE50UdhkcZ95FecKl8UOTyh3ckH0pUtqogoG/dApNIFSbCkw2Rb2Nj9RTAu6wrJyIwX4AlNJPAdYUFLFqOeuFPkk0wgLqwJ9vS+pXx1x4NQ0sGrtkJ8N7fiztBUhmFunjd5UsBlMF6JIYsjZq/fijEu/eZJBbOFso/A/SeQZqOpfR0ie/F3ekbx64n/LVt/3vFD2QnCEM7EfvVbJM8wQwSqe8xbPWm/ECwcN/eRbB6IWgmriK77RKRIud4aYWNxVSJAo22v92Zch4eOPe1AHkdCqn/bvUDP7wpShO8pSD0uxOF2c5iNdYv0jR9zPkv/c66zwOM6/CC62jOgFlvX1JBff73pkKKkmgZL/AgyDd0H9iic68lJaNGxFYO3X0SfyIHkTK7TxxbHLDaczq8nPwDbTMGnnB2zvZ8c/GNS31OMuTTsIqqtETGGPgCY8QS18FNA5QL09/JhsRRlLLaqwTHFjFXTZcy70qTNj7lqCXfz0SNPA8JN0aMm+lVXe1+UKU8ya6ZPXMkOXfR+GjbBPqCgxl/vdHD4c4vxOPrvaDuj+kbWwaGzkT2SYP5mNXFU836Be5WU0/JT8H2BqsoVBthh
 edDGR+d4
 1D9/0FzIMjgaFlu5EBKdsE+1xHdvCq2MNI2sMgwIjYKyO+b0uSEt+Uil0NWjYHQcSvOPgtIfzipxdRjsX29W3HRjzr5/vjIOuwbqQvNy9eoTSUsXZqksjHOA1CNLJZi121aCXEWJNPsTFwmIwrQzMzhinQdcXbgjcFnKP4vb97Aur0RBRKpFlF4Kpq0PyXpnNY8zrl6WF9kYbdmWbwYpbmDOT9xT7VeAzD6eRvZiap1PND+GS1VXIX+aL/wy7guUAdkVeGUrlcLmDSjV6M5PCFPYGFqthdkpveOUahdQjt9RoXJhjo3bKeeoWu4PiWBN5EU1mMwYoK4YYxh90RGRqFyJ5IASsr7D33HWPI7u3QHMfZQoeX1ldQBx2eeKldOOH4LWZe5CN/8qFpTnMEuSq+FPkXvthgjwMRStEqf4gkxqnGghhw4k8M6tUqFZ9A1lKNJcH8InrYM4sVYYCQYF9yBAP6q8Y/aQb3Y7JAhOGs7ZVP+Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Aug 25, 2026 at 2:20 PM BST, Alice Ryhl wrote:
> On Mon, Aug 24, 2026 at 01:17:56PM +0200, Andreas Hindborg wrote:
>> +        // SAFETY: We just successfully allocated a page, so we now hav=
e ownership of the newly
>> +        // allocated page. We transfer that ownership to the new `Owned=
<Page>` object.
>> +        // Since `Page` is transparent, we can cast the pointer directl=
y.
>> +        Ok(unsafe { Owned::from_raw(page.cast()) })
>
> This doesn't satisfy the safety requirements of Owned::from_raw()
> because the page may be used with vm_insert_page(), which increments its
> refcount and causes it to be shared the vma system, and this occurs
> before Page::release() is called.

I suppose the existing vm_insert_page() abstraction we have is already
problematic, because it uses `&Page`?

Maybe we want to change the API to use `ARef<Page>` so it already has to be
shared? Conceptually it takes a reference count from a `&Page`, which isn't
possible because `Page` is not `AlwaysRefCounted`, so it needs a `&ARef<Pag=
e>`
to be able to do that op.

Best,
Gary

