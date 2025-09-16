Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 635EBCAC598
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 15:25:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C06148E0010; Tue, 16 Sep 2025 11:25:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB6678E0002; Tue, 16 Sep 2025 11:25:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A56DF8E0010; Tue, 16 Sep 2025 11:25:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8EE098E0002
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 11:25:24 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 497CCB7086
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 15:25:24 +0000 (UTC)
X-FDA: 83895487368.02.100FF89
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf18.hostedemail.com (Postfix) with ESMTP id 99C3A1C000E
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 15:25:20 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=N6EYow8M;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of tony.luck@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=tony.luck@intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758036320; a=rsa-sha256;
	cv=pass;
	b=vfuKK01GuL+L/C1y9KL9d3NG3js7192ulRGyShjCqveL2NciKmtpmiqXkqFqF3frjgHsLU
	gD8AeUfdAk1fBL9GGNxo8QRKwl7mV9qxYrHLhBjSUUStlA7clUX22iH+BuJfSKSvhOvWId
	piE1tLZHxz3ggHVwvpUX1ipmJ0jelzk=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=N6EYow8M;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of tony.luck@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=tony.luck@intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758036320;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bTf3fcQau+LVYwnzK2ZYYqI9NbVOsfkyFmcKgtKSdWA=;
	b=tYveGSNBIfw1FX3eIVsRApZQRX1eF/yN+5dn1LFp/Jl1HMNgwMSWpTR6dAl6n6aBTNi32O
	X40gQJP+H6GxE1y4Nk9LV1Dwn0h+5Ki+oL6zt/ptg94YsKCgCiPmb5ZFo2ei7KKgkRQT0i
	67w1y5vfIJUaxRkrxvz4Sr8LVIPxO4s=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758036321; x=1789572321;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=bTf3fcQau+LVYwnzK2ZYYqI9NbVOsfkyFmcKgtKSdWA=;
  b=N6EYow8ME9QQTwQ+eGKKVYn0OiwyycbTgNeGA7vr+PR7DpQVBqLC0nDJ
   J8Pbjd6U38fMXcB71UrHYJRvVHmvLpNvDpF1nAegsuP6zlGHm6JByRmwh
   3p9v094RJli4YYFqsJBcPoeyiYwlBR4WMrDtGUKRg2i3o+xe9DoTx+ssk
   YLwKYDZPEb3OqubML7B4rZKv6TqpZs59tWRHHvdtOYuDYtsmMJc7Iw8qH
   N+URhlk8owNxAJnUlHLGr8Uo8X4k0G0T5ZXXXwGz88fgSaz5vhDBHI/HJ
   D4AH6zRE0Lq9gNIKeqXHD/gBYrSvOvZ2smveEglLMLFfDr2AA0J0KYIbH
   Q==;
X-CSE-ConnectionGUID: AmjfRC+VQNaqKe46ToHepQ==
X-CSE-MsgGUID: masYYKp5QwOPWPEPryiS5A==
X-IronPort-AV: E=McAfee;i="6800,10657,11555"; a="60390664"
X-IronPort-AV: E=Sophos;i="6.18,269,1751266800"; 
   d="scan'208";a="60390664"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2025 08:25:19 -0700
X-CSE-ConnectionGUID: pE6OAuJsR2qX8vpaoLlzFg==
X-CSE-MsgGUID: cbWJtLiIQfyp8ceVEdH6Qw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,269,1751266800"; 
   d="scan'208";a="205930071"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2025 08:25:19 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 16 Sep 2025 08:25:18 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 16 Sep 2025 08:25:18 -0700
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.0) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 16 Sep 2025 08:25:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qPzeKrwvs8TN17AohmAmXdYwP50N1E0l0itVofOyBgHS7uROp+QYvqEHwPNMPMm1Gu1xfJpwWfbqWMt58mDM/DAWHGXSZfeSsK2LxbWMjUHT9XtFEC0lG2ZLZACdPjixbgo2Y54Sm9lrjnaUgUJAW3KovRmgBaLLErVXM3hZ3P4luzoaP9KKUcApRnyADKWk+PJz5hmltDz3FwNJTPV79MIjNDCSAqrYyyws1bFHMKUi1wE/RbSERNWcLDIy0g7w5kUn0bmlTAp9S0VqAPNng3e307+0BpAvXqL1afIJ+DKl46Rk6EckZmwzo021qFvCv2Hpc9g9S4wrdhv1hMPlQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bTf3fcQau+LVYwnzK2ZYYqI9NbVOsfkyFmcKgtKSdWA=;
 b=eRUTwYKybh2sAWY+HgHirDqsY3BNn9cosj6hy6NLX2b7sR2v4jsS3gZMeLCkvZIwBEQJnkX57ODERkXFqfkXt0TG0NMdPt5rlLxGuhhtWpV+kZFwIMhJmWGRf8+klYocdsVs/gbRJ7RHmXiQ7pkUoaDFLxnNXDyj0zILiCxRfTxU+upT2XQY4EYzjN8dxKMW7ajO91DXOQiLAIrOQym5V8ONNfh2xHp+7FFMS5JWlPO/rhRi0OPklx0umirrSv4BLUhDAEGmnvu9Gw6PloZfYn0x3CSE52R+UsGCRq50i6agVIZz/Zlip5wm+MzLwygm17rOPR/xQoBpuYfNvCk4fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by IA1PR11MB7272.namprd11.prod.outlook.com (2603:10b6:208:428::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.21; Tue, 16 Sep
 2025 15:25:14 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%7]) with mapi id 15.20.9115.020; Tue, 16 Sep 2025
 15:25:13 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>, Eugen Hristev
	<eugen.hristev@linaro.org>
CC: "kees@kernel.org" <kees@kernel.org>, "gpiccoli@igalia.com"
	<gpiccoli@igalia.com>, "linux-arm-msm@vger.kernel.org"
	<linux-arm-msm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "andersson@kernel.org"
	<andersson@kernel.org>, "pmladek@suse.com" <pmladek@suse.com>,
	"rdunlap@infradead.org" <rdunlap@infradead.org>, "corbet@lwn.net"
	<corbet@lwn.net>, "david@redhat.com" <david@redhat.com>, "mhocko@suse.com"
	<mhocko@suse.com>, "tudor.ambarus@linaro.org" <tudor.ambarus@linaro.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-hardening@vger.kernel.org"
	<linux-hardening@vger.kernel.org>, "jonechou@google.com"
	<jonechou@google.com>, "rostedt@goodmis.org" <rostedt@goodmis.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: RE: [RFC][PATCH v3 00/16] Introduce kmemdump
Thread-Topic: [RFC][PATCH v3 00/16] Introduce kmemdump
Thread-Index: AQHcJt6CGFV9LA+gJEOPoFdaXeWob7SV7XyQ
Date: Tue, 16 Sep 2025 15:25:13 +0000
Message-ID: <SJ1PR11MB6083477193D9EF7CD10DE9EAFC14A@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20250912150855.2901211-1-eugen.hristev@linaro.org>
 <20250916074929.xiait75tbnbyjt4c@hu-mojha-hyd.qualcomm.com>
In-Reply-To: <20250916074929.xiait75tbnbyjt4c@hu-mojha-hyd.qualcomm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|IA1PR11MB7272:EE_
x-ms-office365-filtering-correlation-id: 65c83f01-3e27-444d-ef2f-08ddf5353b93
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|7416014|1800799024|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?3i1dWxSy6xfbRXQDcTfneSYG7PU2Sd3DI4V8xptQ6kdxCQVHebOhBntxL4sY?=
 =?us-ascii?Q?7dvxZWr2VmCdlolPDDgudLbrOXEHg+881i913kVheFPgCSZMISNF4leDTKs8?=
 =?us-ascii?Q?i7LT58m/m06fgtDQrPjwIJHH4oHgZTWlWVK6MRDy3T870EWOnO5CHmmevpXE?=
 =?us-ascii?Q?hp0Zq+CsOt29ySPo1T4yyhQ7b4UjdcldIr8KAJZHRW2No5B/n9rj5JuEg81C?=
 =?us-ascii?Q?2n/ZSqe/8vjLkcLqmYG9VXSOKs1tReXctLjxf0O82Ga4gZ7Ft4a4Kfv2gMjD?=
 =?us-ascii?Q?/+gHhA2688fEALshivTQKlB+Yo9vIk3AQDXt5aMWYXOEcBE0oC+3eM+iqwD1?=
 =?us-ascii?Q?Vr8suivp89kqUgEgzplvVrZ4JYQSF8g9e5PLIJ9wmSBy7zMIyYsK4jX0GXKu?=
 =?us-ascii?Q?6EEJXfugwC5pVw/JKMRer6eKUtWc+4AcBRgX/WI3A+EcG5hvUIsLyOGD4Wyx?=
 =?us-ascii?Q?K/ZXrPDI8EYDd/34ObdHRr27IUZuvXC58B9yoPT/U/uT8nTR16+AxEkoeVTw?=
 =?us-ascii?Q?inu2/AN8+yppm7wv3w6lYzSKdN3N9SK5tTViz/4KA7BGMRFOYYbYfYmdoVLO?=
 =?us-ascii?Q?eVRC6+XAzO6sImlN/s2X9dVZyCjR5fSjkRlllQC0ww050DD4TyucBVcg+waU?=
 =?us-ascii?Q?tRdG+Xtt4KsLWD/wejw3Z87mCZVcSchj56lLjwEDSLXzQ1RKeUO+xWtsboql?=
 =?us-ascii?Q?nae7W4UsBKCFRJu8EMxigP445vCWzdVATOlyc6krNf+Pe9NHiYNo4Lqyu8UV?=
 =?us-ascii?Q?Wh6g5nCDImMAaqRBBUHbTRvM+ThNDaz7sKoC2G2AYea6e0GmjqrtYCfAssuH?=
 =?us-ascii?Q?O7Mj4Igeki4H5OuOlACUdaCq2Z6ZBRtWErs5KYzcCkJJh+v51vYQWNhUFPWt?=
 =?us-ascii?Q?ERx9ZRwMbwlmA4xEa162+gjWO6QVuS01bfHETovP8U/b/2S62/3S6OJUCpZO?=
 =?us-ascii?Q?mHgB9hvquBKVAsz74u/TBAows2uP2JcuqoagtHsEaMUVUYwWM8OfBuyMbzBs?=
 =?us-ascii?Q?8YWkblV5+XpEk8j3WzcDkn5KYCCafHSOsxQxwTBgyxjDklL8ISf611JvLYw7?=
 =?us-ascii?Q?nNgb4sd+tztQvYj0nPfoz/BmpRFgKoNxRaX1eRdVA71OA+FuKejWsOaGxr8B?=
 =?us-ascii?Q?Yr3VmOolTHrT9Dez/7n/Kc8H2vkedw/KI0nhdqnftUY3HQtC5xkAb9e2NSKo?=
 =?us-ascii?Q?9zskxdP8ftMgMzp6RkLBevqyp6KQJBjYok3KrOUMvupjn/pvoBSJX24glZcs?=
 =?us-ascii?Q?IQcgcvRy4PY6deS6DGkP7kCXo5K5S6pvXLOXj1j8R7M+7uC44CuKbWidVFlh?=
 =?us-ascii?Q?2d84uEEv2kK3rnYmqgAcUC08yYiuqn5eAAxuMEYhGDfGugV59zVyBFJM1E0a?=
 =?us-ascii?Q?Kymocyvzhc95wbJgRRXkfnmEeJ3kfRow5lPgsV+IWPj1sjNrfkqzcgQAP6ls?=
 =?us-ascii?Q?ipcCCRCmXOtnrzW6Cs0uVxATN7wC6FnQ8U55kZf4DhiyRSwcuhsI9Q=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?WLQkpjYKu8SMAF7gxugdD39VcX+QNzh+zwM63i5/1302pkN1qfNhMqoMyuZu?=
 =?us-ascii?Q?5HPkFk7S0y7os5JhEqjzVuUcYQKPsA+7+i98Oy4VIIRLh7HmplGK2Jl3mBjO?=
 =?us-ascii?Q?jKKotq1G7tnhk2ircKXPMFT9s/P5Z4TbSMuY5VJqXUhQlUeNrhWdgC/vLvSO?=
 =?us-ascii?Q?YSIfZubW4x3vYI/5ZHt9rQbJh1YzKc5TRZzFr+kj2xLamENmNCxRdUctlBSE?=
 =?us-ascii?Q?1BxRx9wplkXgO/L2+yFvNGB8Aggn5bCS2VvXUfO9RAdbvvVdjuc244iW4yuF?=
 =?us-ascii?Q?g+EjhorHhf7Uba97vppx8zA0wjhan2Ah88J23J71fOvHCzG0ExTR+GRMnKE3?=
 =?us-ascii?Q?V1VN5vu7DZ/KTuCXpY6A87+Y3BxLZLv0ObBhmcjxjVAPopbH+WoH8xoQ6/GG?=
 =?us-ascii?Q?QKkQfDeM3fxtUamN4TuEJ3GfwkmVVKd7Xk6yjYjQyG/nvojlouXiJWzYk6pZ?=
 =?us-ascii?Q?cdnaRxGTOCa6gTsiLWNtO06G2pD2dQiZAGpxFLOWrSanb4QeoCoYnQ4GMca8?=
 =?us-ascii?Q?HV0vhF/qEEM5Olx/k8bRySnee/hESBS25PVM9nA3k6Kq5XGtLRf/uY/fLxXa?=
 =?us-ascii?Q?LT8PahQscF+8XnS79nRzHnD0auaWs/ZEQUhni3pJV2IvFTA0IZzAk4m8OA81?=
 =?us-ascii?Q?QZqPqI6iFvXb7KzFi2jWA4GczLkeB5ln4qmM2JTn9mH62O+y1unSgd/7NvWR?=
 =?us-ascii?Q?hZFieV0M5HtRcUTy0Bn6sV3qPZLb9HuSBjRddzJiBAiIhDi6Lf4IM/NarDww?=
 =?us-ascii?Q?MtYpa0w2W1RXph54suvm/2sTRzlQ97olrJbt3I90Us/HhSlKdPzw6Erhw44X?=
 =?us-ascii?Q?9qfvxM8gZOq7VhBe/1Bf8lQnkVe798lNdelPSKp+uAL/4KrpCRalJ4XUjJgY?=
 =?us-ascii?Q?jAmVzQEGXDjedVm7CGnJhCeHDH+edhz5xnI7AZmEuJ45ph89ODG3mZ0YTlQ+?=
 =?us-ascii?Q?QBvPWi7+d92zBR776WqjeysQQcyvzkiJBdqOAKXbyOAKT+15QjkqJ+ZvbYhe?=
 =?us-ascii?Q?Ut5aTdTOvKTkFl9psxhH6GYnGp6j8R1hCBGUX63BS0UHqrVspJ/dmThXuwY1?=
 =?us-ascii?Q?+ll1SjcDbfO8kHtGz7RXM2hpAj6t3caJzs1Ke9Kyapwp3ytboWeyg8q6S7Sx?=
 =?us-ascii?Q?oeiYWDUHYwxXk+7yORAGSiUHktgTz5zcl5eN3fiqpRr6H8Pgk/6IjQUfkgow?=
 =?us-ascii?Q?RS5SKxqfQRq/dgNGDKnhQIlcJEr+vl0hdZ/OUhKkw7sl9lP+OAzE0VoEtItu?=
 =?us-ascii?Q?ZspRjIkuvQE5ylfNRetrmNIQ3jxjL+svA/JlenPwaWYOXTdTQEFdti/Hzzyc?=
 =?us-ascii?Q?ij9cIGTRqAXr5P3YHqpEojQTPXmz8eEEug5W2b7z/ZpxXm7G5o4N3KlyQtOf?=
 =?us-ascii?Q?UyoZvhpQnba0wBaZP1LGFTUGYOP6PlUB64Du/CP26ZaDKA3bfloajJ6AR2jf?=
 =?us-ascii?Q?0wx9skW/8jUVv0V+34DVDde+AAOtmbTkv2yoETebc0fWsJXqqU+uIpkGjmGe?=
 =?us-ascii?Q?EnprfxFNKZeiZaOoNVeRGLdcH3+ATYlfo4mLOCfugTgz84XvTgFkf95HyuNi?=
 =?us-ascii?Q?FPWP0OXcn7Sq+k4pnbnJ0jLbqB2Ix4wipVgUeBDN?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65c83f01-3e27-444d-ef2f-08ddf5353b93
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Sep 2025 15:25:13.7920
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TFxB7x0VsxYfmwuuxixnyQeBlcXjf9dLJS8DZPIQe0qqmehH3tNHItZsU6esLRtHvFydIbfzxPHxDee1ZkNkPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7272
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 99C3A1C000E
X-Stat-Signature: 98rqgdso7d3whb9c58xwyqqfbw5tiwik
X-Rspam-User: 
X-HE-Tag: 1758036320-854990
X-HE-Meta: U2FsdGVkX183oD36gI3NaBSkJw2sTFa3AL67JzJxaBAFYEHSAg77vkBlbdTSMV4hn3TE2t8h3JELGrKjB8oKvTuxnB7Dc2NhQ9yPNfpOwn1UXY0mNRFBsjClQDfoPR5KDAr8BwO3nzn6s1gr4VLBtV/r5ByyTvvg1JCOsxlj86ewXsOCh/7uYaS+P9op7wKZO020uYQf4eg9ir9jyE/pkhmYw4XegZlHEfkU5Ag+1LwTldriGBfqJdpWLhJhAnHM/SVX8XPqViztGsJ4hj39THzuN7waZYD/jVVGvzyqm9oapnaVivFDvk8DNY+3ZYXL05Opk6DttNdmlkri7y0BxryjkkZvBuQmU80sUcyzgiEoCLtvxUZ4nBl6vRe2BhS9TSDuXdNpgek7GkkD+J1T2JVIuhhWvN158MTGTPqIZ7XVD1/8H/r7uTGkiuDZ2wisOawah/kcW/7+3MBzpZxIDqENu/FI3+wez6E6g5WODwQTONmYICpfrl6A3tVXj8F2wd/QsS2G93N6ZwNQ8J5M2qIBJJF09kLBtjxUMlVu8/XLpwo1Pl1+P2+pjAmlPryLPWw2rPXnRea6j03tmcsvJ5f1TmPLp5XoUWywxLyTtZ42I37qjTizI3AmWcU5umALAXgaY9DylEHCPeDeGFauznn2pMfmGDGCfYbJTJGI+ETy9xvCwEvjG/Ygh4RMEDMHKqALiidV6iWWIXE/fPCXQ0i2HuU3tQal5SWNLBu2ZEO9p0bxMQl5i/7xrZa83d8e9UGnDwwEq3tGRXKOV4BGJq49HmOKG7qKBpk/no0t6lgqI+zCUPg6LhPR47rFcQNZPgZxp891s7pwX1Mmi3OeZeFz5vKvWH1j4lhOSl3DryQeoPYq6Nah24xNr2mC/lQyyD3i1HEx1NlG8RpRL1uGMgGUlm+lPM1bZM2agYoK3dq01aUnXEqTStCsQHYvgX9q8owPdgbqJ6Tl8e0MPpi
 mQiEpsk1
 kM7MfKiD+v01AMcUeNpqCgoLlD+NVJiyV1XMTwmMdz7tIjfAPPrsLiADRuyNS+GD05XWsGSCM8yvqAvVITIXVIWSLBWt++Be1kGMOm+obse3fITYbtTL8nrghZCSwS3u+bEMqAdFsw9Wo+HLUFDtQmATgukLDTq1hZXZVxZvcUcEwBqmy5m3Efam0JpeO+yjezZUfx4zRQZC6CM5xQf3DJI1xGxPjuJLbsdr2musoWA/8oDULiC8rDP0P0Vezu24HLqwSQs44fjk24cFvqfAs3JwQVTtjuiVI60zaM7SRn7flfk4SrEaHRT76BRUrQo5o4BtFF+4wpolwQ2opQfBjFWTNhz+grpgg9+QQtEK/0lHP3ujNTQDs7P7byKRfkSBHVNm6uXu6A7utid60pmtM1FN0viTADrxNweEnydSF0e4j9XDDeEQbt/PQj0asC+NIrZ1fUjgylMFCcZfypSaNNTQrv189DirVfk06M4g6oC9aQARvh10DSGqQTT7MIGyuiGId1z8HpiudzvIgNZ6ZMiXxLR/0ag3KTEpc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> +Adding some pstore experts to bring this to their attention if this can
> be followed and if they find it useful.

Depends on the capabilities of the pstore backend. Some of them
(ERST, EFI variables) have tiny capacity (just a few kilobytes) so
well suited for saving the tail of the console log, but if the user specifi=
ed
more than a couple of pages to be dumped using this mechanism, that
would exceed the persistent store capacity.

-Tony

