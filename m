Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC5CFCCF9EA
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 03:15:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00B1C8E002E; Tue, 28 Oct 2025 23:15:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFD668E0015; Tue, 28 Oct 2025 23:15:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D77228E002E; Tue, 28 Oct 2025 23:15:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C61CF8E0015
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 23:15:16 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 61FA25A37F
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 03:15:16 +0000 (UTC)
X-FDA: 84049685832.25.B6E7631
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011061.outbound.protection.outlook.com [52.101.62.61])
	by imf06.hostedemail.com (Postfix) with ESMTP id 537CB180007
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 03:15:13 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Q2kDYBUv;
	spf=pass (imf06.hostedemail.com: domain of ankita@nvidia.com designates 52.101.62.61 as permitted sender) smtp.mailfrom=ankita@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761707713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Odh/FuQYrLExuI6tmD7gnBfgtMk2mgaP1sGnsWSs0Ps=;
	b=ZKd68eHuini+BKrauQ25AV81vsSCjoLxF6hCk5eANpLXOjU9gFEA7Lt3Ms0JVjtvQVtU0M
	5QfxDQB8cI4O3s8GjXt+vFbTj8h5kC/LHkcmdY3yIOUHXD3ksMh/SAER56hEouc2T7Ygdh
	98SIMBuV6YMLQx2Py4KjCZ3A2m5QD5A=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Q2kDYBUv;
	spf=pass (imf06.hostedemail.com: domain of ankita@nvidia.com designates 52.101.62.61 as permitted sender) smtp.mailfrom=ankita@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761707713; a=rsa-sha256;
	cv=pass;
	b=KCtzRHPf2SfBn0oLn24KiBPVLqSd3turBaj6k2a9vtD7xrjv6vzWLXsXeXUtSCiJ0Dq9AZ
	I2fziSRZ0wl76iFuDf3XlY2srQDHIdg3J8txN1opo/KpiRGp0KwMf1Vq540XBiKpTIwmmB
	calzVoX0CtUIwmj9g+AQfpgzsDBmpSM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dr7f2NPZwHF/YkHEVXKsEs3cb+OUrITrMFhE63xnoA8CfBJHiwKPbylpV8a+oI18dCOK7VpdH75wtrWhCigkExitd1eBmSrSlCGXyQsdnSEC8hrfddc1mffJvXgf69d1MbOvy0t/ooIRobe9OWs9LL76lwFc54tMgJ8ZrwWToOiBTeFwgREoAL5Odpmk6MGbX2KpM8n2ayAoSqoPnAJDsRWMh0yVyO1ewYLKvToeW5RTXw29BJWXIQ3AFF6WufUzKftWEFf+s9iRR91G9sI3AQ+ZWX7SI9FBJJU8rNi3jEKD+zwkS4Bob79DOdFB4pAlercauKEGEIxluFYVGpRNIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Odh/FuQYrLExuI6tmD7gnBfgtMk2mgaP1sGnsWSs0Ps=;
 b=UX/Dsq3/8fmRrTAq1BijkX6+l4nQXUKxdlLyvHutCawZP0UuUL8ASKE8kShO4/sJTukiYN40UX4WmaubXi+OtvuueEVJvUYvt54lAycIxbXtHeMMYzwKGJhyLcmG3vQ0s+R4HD01tghkk1eoXt+T6Qy3Yo/x8JJgcrjFCSWnp+N1ZGJKxmzXvyvATml9ayXtUQ3aQFb8mmxGBFrf/5yswkAz6y9ApAJ0TqF5ev2Vk07yrHkn7HA4H+Lgw4wA2hsWe1HI5Ze6cykD0ZtbNfKAa2+FRq3BKSWL6vtMFsD2pTLtN7bC1N/k86jqV5Xu28qfCVZvy+AqNn2487YpIQdM5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Odh/FuQYrLExuI6tmD7gnBfgtMk2mgaP1sGnsWSs0Ps=;
 b=Q2kDYBUvboJuG1Q6IxXWKhDufwF/tJlEKiaM8hCJo9NhUaIcrZIrYHKDu7+K2HFv/jISQXx7dQJEcVY/SzX8uo9NgwN5pGdVlaCSs/dQYdkIHGD6VbfGekiJhmTTiruUaJB8gkaxgJ12dwBzLYhr+JK0TD+nVAiaQYZrvm+PleWuePzD6YyvvKaQwE3bOu4I+W7lex0761qjK1NAzcppcR8Ggc/EwXFIpQBIip1xf4E3UcjLFmTbOML3qLmxOP+uuXsfgcepaQLyUJNMj7mhblKN5Q+Tqw6IiV5GPQVCSZa+yE+BYxDvj62e9JpBEHkwNEuqn8UScNdNWVRoOAS28w==
Received: from MW4PR12MB7213.namprd12.prod.outlook.com (2603:10b6:303:22a::18)
 by LV3PR12MB9215.namprd12.prod.outlook.com (2603:10b6:408:1a0::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.13; Wed, 29 Oct
 2025 03:15:08 +0000
Received: from MW4PR12MB7213.namprd12.prod.outlook.com
 ([fe80::b049:8074:780:73f]) by MW4PR12MB7213.namprd12.prod.outlook.com
 ([fe80::b049:8074:780:73f%5]) with mapi id 15.20.9253.017; Wed, 29 Oct 2025
 03:15:08 +0000
From: Ankit Agrawal <ankita@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Aniket Agashe <aniketa@nvidia.com>, Vikram Sethi <vsethi@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Matt Ochs <mochs@nvidia.com>, Shameer
 Kolothum <skolothumtho@nvidia.com>, "linmiaohe@huawei.com"
	<linmiaohe@huawei.com>, "nao.horiguchi@gmail.com" <nao.horiguchi@gmail.com>,
	"david@redhat.com" <david@redhat.com>, "lorenzo.stoakes@oracle.com"
	<lorenzo.stoakes@oracle.com>, "Liam.Howlett@oracle.com"
	<Liam.Howlett@oracle.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com" <surenb@google.com>,
	"mhocko@suse.com" <mhocko@suse.com>, "tony.luck@intel.com"
	<tony.luck@intel.com>, "bp@alien8.de" <bp@alien8.de>, "rafael@kernel.org"
	<rafael@kernel.org>, "guohanjun@huawei.com" <guohanjun@huawei.com>,
	"mchehab@kernel.org" <mchehab@kernel.org>, "lenb@kernel.org"
	<lenb@kernel.org>, "kevin.tian@intel.com" <kevin.tian@intel.com>,
	"alex@shazbot.org" <alex@shazbot.org>, Neo Jia <cjia@nvidia.com>, Kirti
 Wankhede <kwankhede@nvidia.com>, "Tarun Gupta (SW-GPU)"
	<targupta@nvidia.com>, Zhi Wang <zhiw@nvidia.com>, Dheeraj Nigam
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
Thread-Index: AQHcRoOUWJnftWewAUixSPYj9sJbdrTWte8AgAHBIgM=
Date: Wed, 29 Oct 2025 03:15:08 +0000
Message-ID:
 <MW4PR12MB7213976611F767842380FB56B0FAA@MW4PR12MB7213.namprd12.prod.outlook.com>
References: <20251026141919.2261-1-ankita@nvidia.com>
	<20251026141919.2261-3-ankita@nvidia.com>
 <20251027172620.d764b8e0eab34abd427d7945@linux-foundation.org>
In-Reply-To: <20251027172620.d764b8e0eab34abd427d7945@linux-foundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR12MB7213:EE_|LV3PR12MB9215:EE_
x-ms-office365-filtering-correlation-id: e64c2b95-514b-4383-73f5-08de16995d59
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|7416014|376014|366016|38070700021;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?fxzb6hLN/X33IF7vCwlQPHlH1+W8YSy7g5lTr+HFOH9Q2PcOBcb8Un0/7F?=
 =?iso-8859-1?Q?3ue22+vBLuiGQF7TLEv6Znsl+lB5hpxKDANyEQzbRKy2Bh8ZMfNtsc3fF4?=
 =?iso-8859-1?Q?iPWDdUTIF/Gg2H84ERjAA0gw8C5V8CKaWAgBZa76KN55lrIOpXRFktf+qQ?=
 =?iso-8859-1?Q?2A2FjvQBx9G3bRPqJDCrl8tZwpLXUGwEoIKct0nBIMf/K12+nk9q8JP9DO?=
 =?iso-8859-1?Q?qZMQN8rtbVW4XbM0fzBFl20ASXzqOwOn9C0qZ9hyPcOpGOIcA5I7LAbv14?=
 =?iso-8859-1?Q?wBCNu4Gq9rKc5c3D0ujcfVBJXzeIk5SRj1MOZLdWcbsxH9awIvSz0YcqPQ?=
 =?iso-8859-1?Q?Vtc8Ds3+qpqIlSBCoOZv4+UADCIZoP3VAFpo2JZgA1I6qrFrw/1eh4ZMH9?=
 =?iso-8859-1?Q?XghTDO/wrGdqeDMCMJcyanubMqwwBiWOAS0Tkqb0e0xS4HSTEDoPhmqifW?=
 =?iso-8859-1?Q?4e/VhvPm8Z9XBO3d5Lx2lJqhYnpH9AL6hWoyx7wTM6tm8qyF8trgZTCiJX?=
 =?iso-8859-1?Q?rbwY8oasdS9+rIAJdopzUcx95WrLlSqpiUsVCm2tp1n5DLq3pFxPfEMNR+?=
 =?iso-8859-1?Q?5rUS9gkEC6H4pVzqrI4bD/P9i8FWdeZkmp0MJqUrHuFQGwIc5PcyceEtA3?=
 =?iso-8859-1?Q?/ZnVGVa8Md5pPyWK/k+3c4G15OdmrHD8wahiq+C4O6U8fJwjSLz5HrSBzY?=
 =?iso-8859-1?Q?zGgR/8CgigBev5ER72PJs0mA10Mors/1VXIMsaq7JByHl9WyRG8U4yOYLp?=
 =?iso-8859-1?Q?b3Fz4Qxb4SlGPrdGEgzrs56zAFGLhsjSr8WQ660OpumAvDWok3x+nCytqp?=
 =?iso-8859-1?Q?Fw8EqWTSLHWM1jX97WMobjjWlK+TyyCao+qyrMWvePv1RG/SZ49S5RP+Lz?=
 =?iso-8859-1?Q?NN95jN/RETm6gsTD2gk5t+j4X5eOfhnjnH72lvmnZlUzs12J5x9FbtSiaA?=
 =?iso-8859-1?Q?DAtN0hPN9jxXRWZcWYGe9u2sEkRMTEYGrMw3lu/BnLTcI6+BdQrZIepgF5?=
 =?iso-8859-1?Q?tcNWU0t45IzyghBazw3SBJoduK1T209lKHnnEyH1z3FAQ9zBOHzCUT1cGV?=
 =?iso-8859-1?Q?bI6btkGQIEnDo7mfBaXisZr6gXRy0igNL5I/ku9jlDpFJVkWYA34+U4sOI?=
 =?iso-8859-1?Q?BUXPJVWJqwmoIEVht4RNSAsnYtusm2mbEUVYMfGca7jwwZ7IeVX+nK1JJQ?=
 =?iso-8859-1?Q?GbVXsJytfZMEBlTh0fDKof69+NMLxBFoE7iVkA/+N1Ra7EivKoukq7n5RW?=
 =?iso-8859-1?Q?+XEhxbhLF+f0+/s3vULVlUx3j9SedIgJe2CsHdhF3mVBdjs0Iwk93/z8ef?=
 =?iso-8859-1?Q?huG4id0f0jRNRmD7WKo0dO504aa5tysR3cwlvrv+iPCpiu9ZZFJ9b0jRS9?=
 =?iso-8859-1?Q?9J5CUDM7y3etwsSq06sn9nwtgajxw+nzMiu1UX2Oe0ltcAIXn3Fa8gs9qC?=
 =?iso-8859-1?Q?K/xT0C/oj6PEKuNu9YntFI0VEfH4uFIFkCQtv/rjxF6fgR+0YdKoEAwByM?=
 =?iso-8859-1?Q?6uSPslSKeh3VF5tf2hStSLmWBCGbww6M2ayPeLFNaFDGZ9rBAtDUNCRflQ?=
 =?iso-8859-1?Q?dsShLZr7b+qsOEl2vf/dPp8egKkp?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR12MB7213.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?ZU6aly9yW4tpgo6d1N2hvw4HzK+s5p0GzsNz+3Quk6kT3rNcGz+N1AMP/k?=
 =?iso-8859-1?Q?d5Teob8fYfIe85iSe9uSMt1c10ToB7pV7d22AsAQaX8hyOM1zJ6PFaDV9R?=
 =?iso-8859-1?Q?J/4GTt5c1KIaDagP/TZ2NcWD8ibQ/q5p3BbzgLRMsaw6zjs85PrQpwcg/L?=
 =?iso-8859-1?Q?PU3QTEEuGnBF8pGe/z+1blu57O98iOZZZetmrvnDML+jw69svBsoyeO4Vn?=
 =?iso-8859-1?Q?Iolsheo10I/a4ZiJbE/tq7AI36lVP4DJJlbtzizDf0TWWwMdmghmny2J6g?=
 =?iso-8859-1?Q?RsghWfVBcJhHMsHmTzIY5qmuZTwm9vb4WtEOtBHfG8VR7VaLARl1Bo83/I?=
 =?iso-8859-1?Q?G7dhaxAVX1Rz9rdx5y5EA1hz97dWoUQ9z2Oci3QY0A6w5XsNKA3ChC0F+z?=
 =?iso-8859-1?Q?tn53JFFvgwbEeWp58Yk4Wu+k+KSKLvD8UqmQjTuVqiITkg8dodGTi2nY/+?=
 =?iso-8859-1?Q?Cp0Dx6iwNYNnDpSzP07sdeVQzz6i8JWmzvyfQSznPYf+Odhx77LlN5ubDY?=
 =?iso-8859-1?Q?KfnFOK9jPiIEkNOPDkpcpTBYvi3ihUbKqELYJ4ic00NsEDHi7ofYrBlXoY?=
 =?iso-8859-1?Q?7+W4Ef6UEQoyUJmGSP2pSAAq2B18atRSamOMKMOJDwnO21zmLl1w/vUk0x?=
 =?iso-8859-1?Q?SSDtwHWX07bXPNgSVxHif56rXoUa4bI9xzdeZEPlYBVoNIejYx+3OagGS3?=
 =?iso-8859-1?Q?jZ9aQHcBcYYvOCjtNFzjkIF+Z7DIEbYg//ekr9VoUflrnebALZNuMt0Bli?=
 =?iso-8859-1?Q?kf9tAlpk+TTZKP2Jkch5HzPeXY67bXqyaUoh+USmWtSN5aQKVoJZ/rz0sc?=
 =?iso-8859-1?Q?8PcLSa2RNLQAPY2tNKixIOKu5pSaXZfyr3Nk/VeWAv+YYGelepu3o9KQa+?=
 =?iso-8859-1?Q?+55dtm2lb2Kmyv2xXHtgq8Lf0Awla9wnFTVhp3Ip37ZiyM/9MfpZm0l+3i?=
 =?iso-8859-1?Q?rkULce6BZHXtIFyvBQkyhjpXGy01iyLb0ArwplGaQBfUS2doRBFXhgLC4w?=
 =?iso-8859-1?Q?hf/mxqY8A012S29co0nnOWyuZs1DXtXVdMkN5STQrgsFLssBuvS/5VNidu?=
 =?iso-8859-1?Q?CFGNzVQyT5Eg+eeH0+Z33V32WMzFQNiEDq+bSczKWT1L46U4R5nG77AVG/?=
 =?iso-8859-1?Q?05oa3VmBCV8nM4fml1i7e2n34+fl7c9Mv/DVnvhm8Jd3piixqhJzT3bISm?=
 =?iso-8859-1?Q?gUA+JaIhIjhP2BFgD3JyEnqNrww0W03QeouLTyt7ImSIA0/gIXT+SbLaaj?=
 =?iso-8859-1?Q?iGYqZ77bMJ+BND53tieWCkPsAS2w2TJH/DHJEHMY1FeeVhmscC57UWWk7J?=
 =?iso-8859-1?Q?JWqhIh0hkUeOuFRchPk+YtZLEI7/AgBVz0hRKZcvKW/ZGmEKfiox6nDJzW?=
 =?iso-8859-1?Q?mLxpHYYu1ETTWtlm3V3RSYVySITukfiSWLL3wh/xnqdklmtlQiZCUKNXj/?=
 =?iso-8859-1?Q?6mf3WrTQXzzqKCYz7/3DaTmkTSTqyzXLxduh6b0dlY8mKySqWkvUvKIOGS?=
 =?iso-8859-1?Q?Kf0Qv9ISmB4sBDbKrhVlmIvyCsBWwYsetoKUiEIz/9bz1w350XkM7DzBoF?=
 =?iso-8859-1?Q?3fTi5JR+hNan02OtqfpZ7xo+pKc+rf6KbzhGgUtRnBa3GEmrE0Q8LgbMIZ?=
 =?iso-8859-1?Q?uP7fy29kn+XnM=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR12MB7213.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e64c2b95-514b-4383-73f5-08de16995d59
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Oct 2025 03:15:08.5046
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z/gfYyXRtDdKK5WAmHsurhYHyxc6xmeW74LliUHj8JqHV7ldOfadFGDQ1FWwJfadg3Mr2evTTnACLNHC/dFgJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9215
X-Rspamd-Queue-Id: 537CB180007
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: doxnsjkojybf4w7jx9dfmo73pjs7aawg
X-HE-Tag: 1761707713-32609
X-HE-Meta: U2FsdGVkX1/y0PfymgqHPT67xL/NlEe4idYu9acq9kSydjtB7sBPj9r8dvGF1HL22hXwpYQiB3mvgnt7yjMStEft93oiOJac3VbEfvvl3/J754QXtZj9gPXHmkslgLreOS9jwgOXqANBWPhLrPYSl3sWQROtfhSDlLTrL39+GJ5qqHXO8/oBrnrNndUfNkSQn4oYc1cWbNBH8qbT0+zzgb0lqw1aFQa//epvWhZ8CU02GNktWNqLev66F6WzpTo6pBvMAmDC04OoF1DHVnMMz+KphCdm8BNTgHWxNfrczIwO2a3ZpNx2fJ0kSm5SARxV47TawIr17SdhL8AZFlmeVvnEpum4KwOXJ4JxaYn2RlQrOAro1g0uIurPqJu39z1NoPjTu6BBqLuwz/3ksf/DsmxVHyPyB2QbbHcn7d8K22P3L3xOlqEhDcfrgAYVmiZpgf33VnSQdRR71BI47kRI/peAcPg9zA4hDAYvkqPfP6lUWfVvVYBRgHQNPyykOzpll1M8+0LHJCryt5I7/1vsK9VS9bzij4w28M0YShcQvsrODjGz6v9fEup16pv9a2Bl60jUOrh2pelQbQXeNRcK/LtsIGM0tIHapcbtvOQilgGDmahttrVVLwcze6NY7sWSASeDhCxAKcfbpONvCUTsWjrG7WjhabeyUuH8w4TDEuVPa//CaPGujmYJ7zNz7IhnhDLNipcckLjn99hMXKvSKoaXN8yWdv/BYRG3oIc+eOZfBxcp2mUzMrBKNApxcyaaeUvnZ3jFoLOMfDv4moyoB3kwMW4PhPxlNO6+YGtqTkC6Lhq5/s+ulEtj6E7k1is2O5uzCjb1sNzhIjbMvixsp9PKTL6lgNTdgS6LU6KywO5rYB4+c+cQAcPLKayazquorCrrmcSPcntg8upI1CsorsPSgjD0XpOPrUaSLguqTpHoez3hwqqSTvOXE7FVxX1DgOsNFS7Ze/PmzprvUMZ
 nl/h6eBH
 KrMYUYZSiS0KOcRQ/+Hg78FKAanwC4Fba8sg1IuJUWmhQNL0pA4i+HE+Bvlx5DSEzfB1xxiE3Ddzh9QvWQehrAS5kxzy/WRPElEMvOuesr8a/AS6kg9pJhDuHtv9XofA9L4Qutz0o2wEfK2y90Fd8tGxbUofLq2tLXGxhS4LJvrLOdkCPLa6ELt9EyEwmlOlAjnWRdvsB41YyVzw7HURFREBSkOtLHjsvsl24hHbIThZGtP6uNZAFkln9sBEUAttU0LdDDewAUu5iduPcTyOmRvL94zo9MnfvMt72GKedFVpdSk6qLeWa+tPngVUpN/OQGBvCUZjn29gmSMzlYnmG/JF1AO/p82zMzB47Kfx85dobjLiQ/jPncYbEwDULVTo6j4V4CDv3+wGNAl290lRHhLObWCUOaYH7qBnTgAa5at8SjgBRTsosbnar6pM+L1t1rnF4JzmWfwkB/0qayW8xoDDP42iXeXwiGIzHgaBxJ+qMdbYknP8dc7XmP3Y7uG8BOExGY6Qq5kjAuco=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks Andrew for the comments.=0A=
=0A=
>> +int register_pfn_address_space(struct pfn_address_space *pfn_space)=0A=
>> +{=0A=
>> +=A0=A0=A0=A0 if (!pfn_space)=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return -EINVAL;=0A=
>=0A=
> I suggest this be removed - make register_pfn_address_space(NULL)=0A=
> illegal and let the punishment be an oops.=0A=
=0A=
Yes, will remove it.=0A=
=0A=
>> +static void add_to_kill_pfn(struct task_struct *tsk,=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 struct vm_area_struct *vma,=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 struct list_head *to_kill,=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 unsigned long pfn)=0A=
>> +{=0A=
>> +=A0=A0=A0=A0 struct to_kill *tk;=0A=
>> +=0A=
>> +=A0=A0=A0=A0 tk =3D kmalloc(sizeof(*tk), GFP_ATOMIC);=0A=
>> +=A0=A0=A0=A0 if (!tk)=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return;=0A=
>=0A=
> This is unfortunate.=A0 GFP_ATOMIC is unreliable and we silently behave=
=0A=
> as if it worked OK.=0A=
=0A=
Got it. I'll mark this as a failure case.=0A=
=0A=
=0A=
> We could play games here to make the GFP_ATOMIC allocation unnecessary,=
=0A=
> but nasty.=A0 Allocate the to_kill* outside the rcu_read_lock, pass that=
=0A=
> pointer into add_to_kill_pfn().=A0 If add_to_kill_pfn()'s=0A=
> kmalloc(GFP_ATOMIC) failed, add_to_kill_pfn() can then consume the=0A=
> caller's to_kill*.=A0 Then the caller can drop the lock, allocate a new=
=0A=
> to_kill* then restart the scan.=A0 And teach add_to_kill_pfn() to not=0A=
> re-add tasks which are already on the list.=A0 Ugh.=0A=
>=0A=
> At the very very least we should tell the user that the kernel goofed=0A=
> and that one of their processes won't be getting killed.=0A=
=0A=
Thanks for the suggestion. As mentioned above I'll mark the kmalloc=0A=
allocation error as a failure and can put a log message there.=0A=
=0A=
>> +=A0=A0=A0=A0 scoped_guard(mutex, &pfn_space_lock) {=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 bool mf_handled =3D false;=0A=
>> +=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /*=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * Modules registers with MM the=
 address space mapping to the device memory they=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * manage. Iterate to identify e=
xactly which address space has mapped to this=0A=
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * failing PFN.=0A=
>=0A=
> We're quite lenient about >80 columns nowadays, but overflowing 80 for=0A=
> a block comment is rather needless.=0A=
=0A=
Yes. Since it passed through the strict checkpatch.pl check, I didn't notic=
e.=0A=
I'll fix it.=

