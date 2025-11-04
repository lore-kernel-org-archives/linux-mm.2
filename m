Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A7DACCFA04
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 17:21:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 886E28E0005; Tue,  4 Nov 2025 12:21:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85F408E0002; Tue,  4 Nov 2025 12:21:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74D858E0005; Tue,  4 Nov 2025 12:21:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 620928E0002
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 12:21:37 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 373BC13B4F4
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 17:21:37 +0000 (UTC)
X-FDA: 84073591434.11.CD35632
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013032.outbound.protection.outlook.com [40.93.201.32])
	by imf22.hostedemail.com (Postfix) with ESMTP id 271DFC000B
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 17:21:33 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=QcKaDDsS;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of ankita@nvidia.com designates 40.93.201.32 as permitted sender) smtp.mailfrom=ankita@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762276894;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BaWCUII8KFPm8OgP01kgg0Tb81fAOtly/XPNjLrKrTA=;
	b=lKW93YYxrIvq4b9BuODH7/GcaN4/DcdL+6C5lOxpbngf90e0a+l9mICp7aA5Df++bDzvk2
	f0mprqTZkwdAa0WSLRq8RQiXNsbp91JJBZBKlbnkMjzMljTNzd8oOHleIPo9zzseUzI51w
	IkpmPtlZsn6AVAdCAmcRd/nDWz6+bNo=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762276894; a=rsa-sha256;
	cv=pass;
	b=EfSMgs7dyLOYQe/zappbnjKSBC7ZFag6iamcIRTHAv72J35BFzIBO+ev5ITCze7tpWfxnW
	8ONBDhlXjZuFDrIzwgZhjQ5wSPgZWo3hjH5rhVcdl5wBCT7sWXP8M7AUYSPuwctQK7oB99
	OgXhPgVD3qV5iMlv2hm0DbyRcCObwbo=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=QcKaDDsS;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of ankita@nvidia.com designates 40.93.201.32 as permitted sender) smtp.mailfrom=ankita@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=V23mR4tU2B0ymMIm8Ayj1gGMdzOSGcY9jrSiXYzQperHMd8FmtPiwnOd22syfFBYwuGaovUPyJCmIL704vu/qyaT86zZ1xg/CvHEfTJn2qKfy69LKlClySreA5Ccl7lJmlhCGdvy6fdnUqoYRM0SnXaXtgon81ExUGOMJ1J7UBXuyUlgmB2EG2ZRzJNJsHEnJOnWmViV9E0qolZNJ2NK62gbopiPRINC8Y7zOSDHV8Cf31j71Gqx/ccZfE5Gdn+dRa656dmvqggGaNCVyO2xxmCzGHP0bgeLoxkNm7V1t8P+5TBxksxb1ywRHwnTQuQdg6nRzUFKBqu61b8KJqjOvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BaWCUII8KFPm8OgP01kgg0Tb81fAOtly/XPNjLrKrTA=;
 b=JGN+/SVjX35M7qzIbw9/bNq8H9vsiLCJ33UH5aIUO60U8p/FhH1QXqaGszWRJ0IhhtspYurfL7Pc6izyFqLFgCIfKE9M2buJ+yklaCkc8dvQF6UuVmcBq2J8T8mQst9MfCSATlBRKnxCP6XHTdRPDIdInvuR3RfgG59/V65U3eNC3LF9rIEsAUHwsgj/2Pbi6RhEQBWbMzqEsl4rA6fE9Kqyx8kFqvhc6aZ+xGz+0SIP6nJ0w05BfYDfouknbqWSsoczZxPnlkoncwBgJZCDOkww6eO3LVRzv7/8cA39dOIiJ0cCgSbMjBMpQtCHWz5sTQTCz7dEyFL4qdbgLSpJ/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BaWCUII8KFPm8OgP01kgg0Tb81fAOtly/XPNjLrKrTA=;
 b=QcKaDDsSxDrzq4xPPBk7IvlOOhDPSDyBHGlYQu7OtXHmDpZDAPrUVVqiyIAhl7b4dYVtITe16LEqO+LZ1fqVI2aN0aUkeFsWxqRPG6YEMj3MqDR6787K6Ru2Zehqehvp//RkCxuLv104k4J8iM88YHewuOJHoUz5dKlmI+peRRic5aQWKpbikKlV5DLEYvyKrofoySU0qK7lLNZb40RQIg24jZQ51CDid6tloWUhXPIj3WzHoijDxdOroUehSDabytaz5a5OKIfjFwHyzcvNx6WkGOZNSx5B4oQvvCpo42LY05ye7d1iULALlElaEU3wzMVuWzNvFwqMJ/Uvrihlew==
Received: from SA1PR12MB7199.namprd12.prod.outlook.com (2603:10b6:806:2bc::21)
 by BL4PR12MB9477.namprd12.prod.outlook.com (2603:10b6:208:58d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.16; Tue, 4 Nov
 2025 17:21:29 +0000
Received: from SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2]) by SA1PR12MB7199.namprd12.prod.outlook.com
 ([fe80::ae1b:d89a:dfb6:37c2%7]) with mapi id 15.20.9275.013; Tue, 4 Nov 2025
 17:21:29 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>
CC: Aniket Agashe <aniketa@nvidia.com>, Vikram Sethi <vsethi@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Matt Ochs <mochs@nvidia.com>, Shameer
 Kolothum <skolothumtho@nvidia.com>, "linmiaohe@huawei.com"
	<linmiaohe@huawei.com>, "nao.horiguchi@gmail.com" <nao.horiguchi@gmail.com>,
	"david@redhat.com" <david@redhat.com>, "lorenzo.stoakes@oracle.com"
	<lorenzo.stoakes@oracle.com>, "Liam.Howlett@oracle.com"
	<Liam.Howlett@oracle.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com" <surenb@google.com>,
	"tony.luck@intel.com" <tony.luck@intel.com>, "bp@alien8.de" <bp@alien8.de>,
	"rafael@kernel.org" <rafael@kernel.org>, "guohanjun@huawei.com"
	<guohanjun@huawei.com>, "mchehab@kernel.org" <mchehab@kernel.org>,
	"lenb@kernel.org" <lenb@kernel.org>, "kevin.tian@intel.com"
	<kevin.tian@intel.com>, "alex@shazbot.org" <alex@shazbot.org>, Neo Jia
	<cjia@nvidia.com>, Kirti Wankhede <kwankhede@nvidia.com>, "Tarun Gupta
 (SW-GPU)" <targupta@nvidia.com>, Zhi Wang <zhiw@nvidia.com>, Dheeraj Nigam
	<dnigam@nvidia.com>, Krishnakant Jaju <kjaju@nvidia.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-edac@vger.kernel.org"
	<linux-edac@vger.kernel.org>, "Jonathan.Cameron@huawei.com"
	<Jonathan.Cameron@huawei.com>, "ira.weiny@intel.com" <ira.weiny@intel.com>,
	"Smita.KoralahalliChannabasappa@amd.com"
	<Smita.KoralahalliChannabasappa@amd.com>, "u.kleine-koenig@baylibre.com"
	<u.kleine-koenig@baylibre.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "linux-acpi@vger.kernel.org"
	<linux-acpi@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 2/3] mm: handle poisoning of pfn without struct pages
Thread-Topic: [PATCH v4 2/3] mm: handle poisoning of pfn without struct pages
Thread-Index:
 AQHcRoOUWJnftWewAUixSPYj9sJbdrTWte8AgAHBIgOAA3w5AIADW2ZmgAIB0YCAAI6SAIAAgeYAgABvJ8g=
Date: Tue, 4 Nov 2025 17:21:29 +0000
Message-ID:
 <SA1PR12MB7199A46AD4CE574F5200A5A6B0C4A@SA1PR12MB7199.namprd12.prod.outlook.com>
References: <20251026141919.2261-1-ankita@nvidia.com>
 <20251026141919.2261-3-ankita@nvidia.com>
 <20251027172620.d764b8e0eab34abd427d7945@linux-foundation.org>
 <MW4PR12MB7213976611F767842380FB56B0FAA@MW4PR12MB7213.namprd12.prod.outlook.com>
 <aQRy4rafpvo-W-j6@tiehlicka>
 <SA1PR12MB71998D21DD1852EB074A11ABB0C6A@SA1PR12MB7199.namprd12.prod.outlook.com>
 <aQjy0ZsVq7vhxtr7@tiehlicka>
 <20251103185226.fea151c58ce7077b11b106aa@linux-foundation.org>
 <aQnXYsPR7zkV_ram@tiehlicka>
In-Reply-To: <aQnXYsPR7zkV_ram@tiehlicka>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB7199:EE_|BL4PR12MB9477:EE_
x-ms-office365-filtering-correlation-id: 8c9f8999-81c8-4202-8959-08de1bc69772
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?jkl4ZX+YiQAW87TZAdx5tNg7vQPCxZLX9sGx5xxcB4s6hCqLVIrV886MCC?=
 =?iso-8859-1?Q?/8o8n2njaS6ZbTqdlCGqJqHvgg/ceib0uxyQgvQf1LAfEbM3HsEqn0jqdN?=
 =?iso-8859-1?Q?30vZBg3hjhZ4HAQvZtf/0fIyy7oaRuCTK8taurFM8IaD06idGFpG3HheNZ?=
 =?iso-8859-1?Q?vfdWLO26jYyOU9gkj20+oWwIjr95wtElmFTkfIJVr8NRFl2/VLMHNjZrLN?=
 =?iso-8859-1?Q?qSqyecWmMI8LdzhC9BaWuJsOxGQix6HRC0xJbD+rBe8FfdIkkudLb1xLoJ?=
 =?iso-8859-1?Q?bvkABTnyjJLU4+4vp3LM9krPvfLvVydFZ+qsUAPvWRx3uwIbKd9XBtFZic?=
 =?iso-8859-1?Q?+CvBrF2Yj0OwMzNFUC3x8sKeAUWabmh29Cpql8aOsGdkkldwzu8mYRIfBB?=
 =?iso-8859-1?Q?gRU1XtRoLU1Dq2pA6al11WhPOlIE8knpvQZrT4+RpL1YbaRteCnOIm0UXf?=
 =?iso-8859-1?Q?6bfyOad0Gl8omyVMpn956y7coGS7owQi8C8oLXxLVlkZAi4/eOKFjrwpWo?=
 =?iso-8859-1?Q?vmE9D2kUdcgTvQMMQUxgFJLb1J7U4ssnG6Tx73sxeaWYx5aKTwxvxttSNP?=
 =?iso-8859-1?Q?ICD9dxSWSkZo5TzgKbrNQl27XFlxnE7BhZ5sUQ4cu7CNUuYl/ZkMTU6PSy?=
 =?iso-8859-1?Q?VoKZVb4KCcbETX43vKI1ROWdZbroNtCst7AsjvY21sNEbyuD9BYlD75zVz?=
 =?iso-8859-1?Q?hN7lqf913MNctkNo670ARYPszDqkG4Ia/F6kuo/4JQboQ2JsrFFR2plfju?=
 =?iso-8859-1?Q?DFp0kQtRh38n/RLufsnt6pOFkHzyWxRpkSkqfqTwEpvl+2uGFugJQrXX+k?=
 =?iso-8859-1?Q?G6d/jazcNlsu3PQFqhQdnBIyRhjiw8mi0nUFlvmgcHIr81pPAwcwUYQGHj?=
 =?iso-8859-1?Q?0sxjP+YUkKVpnBHuRENkBcarX4QyOpXGNBvGU4EH5kU6+R72kvUYfIAAqX?=
 =?iso-8859-1?Q?WAHdKGsjFwXEFxF0msuKliW1YoXY6zfZOPTHw6S0oIpZLrMB/7kI81Vlx2?=
 =?iso-8859-1?Q?7Et8ziJDchguKVG7WWZ9LhSeLjKkwCSjaaCx+uXTiKJ+Uvb6o2Tj3gow2r?=
 =?iso-8859-1?Q?ySqEs3s11jLBzHFNDqsM4vZiB2sPIihLZ52aMii6SjngrVhekkkPmfl9/+?=
 =?iso-8859-1?Q?Hirjpe1S8U90QZIfSrhJ7FL4JQRZRX1YfzoNm665z069+MaThlOCaYkOXn?=
 =?iso-8859-1?Q?AGVgGRaFlzOdm365Xo5PzX3vMfwQAjaY5gpgLZ1i2F8oWWyhAY720tXibr?=
 =?iso-8859-1?Q?VpwbNFb56S8sL8PS9UuK9KAzjSDQirasZiDizebSBPPgkSegQLZqDT4Fq1?=
 =?iso-8859-1?Q?whiFaOwhSY3iksiVEx1s4FY5FQJjfseC2OJRgPZreZhMYlRY3Av9ZVQwFI?=
 =?iso-8859-1?Q?ecRwF714uqndNyannn7jd5hEePGRuMqIPQr3ukWzAo+jVxfHv0Br5ISDFh?=
 =?iso-8859-1?Q?RceiHoJXO4sfxxt99DKpzhZjL3sNcvG8V0s2CZPoYXfegH58/81PzC8Fet?=
 =?iso-8859-1?Q?aVKYFLmwQ5RQpTIlbUQlOXcW3m+h2ZvBoj4y1EI/AhLWpZwapaC/icbXpp?=
 =?iso-8859-1?Q?pHTDsgEU1WBHSjZRznziWZXkHBA/?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB7199.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?/3SCakLceFm3DPRN6fjXg829gAeTh3t2pJyT+feYWs9gNV2jGZDAenyMLg?=
 =?iso-8859-1?Q?ARPA2EFjvM+rxBYRgXFEqv0JzwtYavezV7SgEJMDPE2NOAnYSdw4VsOm2W?=
 =?iso-8859-1?Q?LuROohs4PTgkjXUaf+c+Tv+/J+LbQCxJIaOHyUkjNyoGEcZW5ssnu6Lxv4?=
 =?iso-8859-1?Q?kEGVzL02aEE1k/qnJqAKzuphZg1khq88iYLl5WoJ6BsQoPGai/pa+/m38c?=
 =?iso-8859-1?Q?vfWCn//M8UJHFm0AwXkQtZRjWYiwt4P/eMcJ4uA8lS4y+cLhfTI0bgYimK?=
 =?iso-8859-1?Q?c6lUdg5z5VYzrteZfIe8l/83t++NI4hD2+zgWw+5ws51T+Ps4cQHxmjkyU?=
 =?iso-8859-1?Q?bOqKpefvxKD4n16d951lo5KHUr68C5NRoglb7Nyhy5o8IIyeFaAHPgcGAj?=
 =?iso-8859-1?Q?rej1oxFWlAN3OSDSGlUX4J4L0BkpRPWNizqOdFBEyRdJeHiDOgbMtT/Ok9?=
 =?iso-8859-1?Q?RgHAjDgroW+HDWtBhKymu0twnYxNKP1xBetK2ZnLyvv+6UtwnYK2QtyqD9?=
 =?iso-8859-1?Q?W7qkIXWoVNr01O1D1oBf6ts1C/TCSY58rQVxM4BFRbIko5lNjuytNZPheZ?=
 =?iso-8859-1?Q?vrJ5q381SUHYQ6yOIKXJpLltfsgAGhFYrJqEIXIp5JiASEItYT8KBO7fo2?=
 =?iso-8859-1?Q?eYdOLDddsRvC6Ku44rff95LY/Cbyu67/voRzZj2yD+jN8UKMUD+DmOHGUF?=
 =?iso-8859-1?Q?A7BmBgJZmHxDYhMvCiZxV+xnDWJI23o/PWqseqb2RDYqaFc10V532eMgHK?=
 =?iso-8859-1?Q?dg1kWQU0c2gjwUKBEK2RU8BO0i4KZgeN65T5jk+VbxxUdtNB5XoHX1EA+X?=
 =?iso-8859-1?Q?InGz/DaBGtJNU6Uyo6MzeTaGDDt2m93Df3M3z8emDLdWiBoDHflqULnKDm?=
 =?iso-8859-1?Q?yjoXAVHlNDK++1KEXhgoLi7DqKPvpA7Z9IzFasK/YIcPdnkQ6EJGqNcjYM?=
 =?iso-8859-1?Q?AGROv+Sc72vFEMX9+vNl9KeC95KxcngAX1K4U+xxHKW4aDfw4JcCuWChdj?=
 =?iso-8859-1?Q?ReIhBOnapO+zudTp+Y1cqNYKyusey5lHFDVgQo4ygho4OI7+L3B7YuJffB?=
 =?iso-8859-1?Q?hywsShJBH++LNYFsV4TQw+ZkrkZNVm5qsIo9fsht9f599H1RruFtwDHXy0?=
 =?iso-8859-1?Q?KDBbOYf9nEN2pIzQUPHVGUsXRLMycW4JxPGIsHm9tt9bsSu18aWmbSguK9?=
 =?iso-8859-1?Q?XyCrkJ341KtiWZGjxnauJam+4iHpzbSsEcy2syr6+bXs6uICJxk7IoAEVf?=
 =?iso-8859-1?Q?Ri0U7qaBA37bjg8+jwBeQLi0AmKG+im5HBckBblaTFLktxnHBubKRqc+hv?=
 =?iso-8859-1?Q?CAbGIxgPYl5gXugl+R7JraiNs5xOeErQI/8nSPvV17XP8wc9FRzu5PbooV?=
 =?iso-8859-1?Q?B/eg3SRx42Sr+o58qmqbrpMfzPAsE6PMJh0yJnIUcl8jZVDAKwYxXB45Iv?=
 =?iso-8859-1?Q?WBv+pXh6hvZBPguSqPdKfR4VyMN7sZCvqsC8tZGboI2LExy69uBWhipOHW?=
 =?iso-8859-1?Q?jeri9rrRy9u4tKL//2PbHHo1mf+Epby7q5FCQO92yhDr3aj8NmW8ZBUOZl?=
 =?iso-8859-1?Q?ICRrlHpw4JJbXDFQ62yQeHIB1eXWvt74mGCzmPcvxJpNUYt0AlSca1KkjR?=
 =?iso-8859-1?Q?akXFmGChFwCDo=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB7199.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c9f8999-81c8-4202-8959-08de1bc69772
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2025 17:21:29.1508
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2PTWNQBN26MwNLj3jdjMGb9gdHgpdG/LKgPztnR87qSIUcY8Vdf6CRdxUEcLO7nXQHXm5aN6Pz7XcrDAHHxVQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR12MB9477
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 271DFC000B
X-Stat-Signature: comdik8378agyhto6nkacqoobggrbiah
X-Rspam-User: 
X-HE-Tag: 1762276893-660533
X-HE-Meta: U2FsdGVkX19tJHdJAbczUgf51blhMKibQKBV3lYXEk7bgCBsbH3EJANUHskVYCSB6iicbqe2a0m132/qYNpZdAH4s8132v3v8CSiJkTtRYI2ZiNKYYguBarH2yZs7ypc1TJZ/bE5w1167T7p+GRuYAXhsGFnH69xCbQ/eTp5l8rwvLek+Cb+tqrwnCxOFa22HkLgUC4yHKrPDv3CF4ekw6Sj4ZG3UbFhAnxca4Q0WyvnVDX2AljbB6xi9mjIAVl+HCwHkk5XN4u/LMjNjqbK20gXbD28tidLvysRf++2U8/Nmbs8GfysV7+HcAtg1YQ/ezBNrl/9RqYcgjOfXf9Z7RoAEEtdezMsIm8kyEamwtLBhpYF7HSWu9DYtmqVXs7ysMp38GbkitnQ7st1qsD4ncqNAc2mTphTtouYZidF6FnyfwodDEicNvciVONHYx/EsgkyxmJ9j+UJl0vqaH+2w+86IMk9mu9Syz7zCmZwZAlc2wYorO4frN/G884UXG484c8zqBomMsvlTMvJQ0jOl+t9h3m00V7ldCKEmokgfgHdlfHSE0rFVbglqvnPwsRSK99zp75wkdd+eR8g8GNMQTiogE81R6xFA16QWhxI+dTIWq2QszgxZCynRvxHc10VPu4jx2VGmNXqJgXEPQX9oHa5WMAFqbxOMce4PCNXjdKcbvGHWULWQeYJ3hfdi4uvcwtxx0ng9pVSGPO8A7/Z5NZB6V9MXtEMhTK5hlmStJGJMGck5BzW2CL3Q+cdQxnN9kWHRA4wC++ttdtv+Gt5ygE0ZL/N2N5OsW8lq4ERjFHj5/XGFleiNCdoxlThrCdg3KDHhB0ewn1PtQ4hvXa88hfhoVPZmAgzFj57EhZjFp+uMqvtOZzY5xupOzC2Issv5+T2/yceVhb0KPPtA0CPQoid03QESJR/172f9GZJpZsbRrDixFk0KwVcvnDuBkc1Ee6sUIHDQYaErEt/IgP
 7XxdpAV1
 Df31wYnnwzWVwOeTR82PXPr1yv1DHSzgAaROoLiMz8fAWYj+gFbEfs7HVfvf4/2sxt0VTbBtmLX6Le8NLVbfnFnMe0pSKdK4cnKkVf9QMfpS8IkVBzMBaX2TM6khY6sTpt95A/rQDgQuDUcCWC10q7Tae9rvFseaIMjGK9fnkB33DPJcOwd25JhaOMVHIozxduBvJ34x9NhKQQjUc23DOB3PBk8iOHBfB9hzuQnksOO9WWiTxwiPWjLwoLY35rija5eFHExa/LvY1TVx3r5/mVO7kAbr3F3KtptPNiNguW5EbmPWqVa/qrJZXHZU+h+waPIsKxUEMLMyKuYxa63ZaPJbRnRCqs+Ba2i9pnj/Wx3187v1AfRSINxL1KrdqgTiRCQMqC3QUkpzSQFG9+EZ0/znX/UrZvVp2m4/RoYlLChn25pFcznvPTOxsdqVMj5Lqd+hkrhl/Q898P88o62ZGLnahnSbQobq86f3qD6yEkuVtqIs/mTgwY4bFec+B8t2M20QnqzYbyhaFIIl+UyNvRcZVAnYLAzrlYKcPDFA9cdnUVkOW0hcagVIWPlElAnx1j7Mz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> > > Hi Michal, I am trying to replicate what is being done today for non=
-PFNMAP=0A=
>> > > memory failure in __add_to_kill=0A=
>> > > (https://github.com/torvalds/linux/blob/master/mm/memory-failure.c#L=
376).=0A=
>> > > For this series, I am inclined to keep it uniform.=0A=
>> >=0A=
>> > Unless there is a very good reason for this code then I would rather n=
ot=0A=
>> > rely on an atomic allocation. This just makes the behavior hard to=0A=
>> > predict=0A=
>>=0A=
>> I don't think this was addressed in the v5 series.=0A=
>>=0A=
>> Yes please, anything we can do to avoid GFP_ATOMIC makes the kernel=0A=
>> more reliable.=0A=
>=0A=
> This could be done on top of the series because as such this is not a=0A=
> blocker but it would be really great if we can stop copying a bad code=0A=
> and rather get rid of it also in other poisoning code.=0A=
=0A=
Ok sure, I'll create a separate patch to cover that and do the one-by-one=
=0A=
process kill. I think separation might also have an advantage to isolate=0A=
regressions if any during verification.=0A=

