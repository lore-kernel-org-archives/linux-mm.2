Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30085CCD1A7
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 17:19:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 625AA8E0017; Tue, 21 Oct 2025 13:19:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FD708E0002; Tue, 21 Oct 2025 13:19:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C4AF8E0017; Tue, 21 Oct 2025 13:19:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3BE8C8E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 13:19:23 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DECD616058E
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 17:19:22 +0000 (UTC)
X-FDA: 84022782564.11.B15FE72
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	by imf06.hostedemail.com (Postfix) with ESMTP id 79CB218000C
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 17:19:18 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=BOFh7J1b;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf06.hostedemail.com: domain of tony.luck@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=tony.luck@intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761067159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t+9xBgreifDlDSQrwHUpv3AcKUKe/s8ad4gc524H/js=;
	b=syqP0p8CYV37aysNh7+JZP9C+LeuCSx2bTCNVedYb5AcI41rwtwqrUfb6MSn2km2RQmR4H
	966rZ5Xmh7ZDtBfSPuKU69CAoMsjK6WRJ16UdjlxlUM69eI6jnIQY3TUPxG85BIIQJfTRS
	JEXC7NszIqh68/lsnp5AMUepyIsrDQA=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=BOFh7J1b;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf06.hostedemail.com: domain of tony.luck@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=tony.luck@intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761067159; a=rsa-sha256;
	cv=pass;
	b=PrASLJ+ETaaaBhA5zCgvwIYoN2lVa/F4mGiWLUYw8uKN51MyE80LdpAj9GWCgFKeS7Clh1
	IMMcnfOsa4ClkuK7fzX6V1P15sbUxfuSuQr4eV7jB890tqRlq21ZDVXFf3YUnSwn8DOgW6
	MlMmBBq8X1IwprNPFhigVNI2QeGlr4g=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761067158; x=1792603158;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4az3NHJ2y/23eeSTe5OVwX4bdf4Vr/2sEl6jU2AW73s=;
  b=BOFh7J1bbIuVTMdAnlXEUc9hXFP2n0SifyK3G7bLU/lrwKmr4lvpUxXX
   WD/mY9v3K1eorCbZuVwL7do64Q6lSEVC8Kd9tfswtTk8YzAGR0i4yftwr
   h0aYe/lQjdI68K0QXcggHg3VVNmyQHeegl6shqcmePyEFkNptx864ETgT
   WM7Oe+lhh/BLdP9Y+DjTjQBVEx5CgOYozj98UM2ZrdNIlRoFJkxMpJy4k
   kgSxUJnfDYGvtcY2AowzZBSGGtYSTaZ2h7mSm2HzjZLKTjd8B+wLRm0jd
   5exRUGUDNqF4bGZ6VJ6HhTQq3MZNhnHcUkTLMQaiNn+xhNZvUxcLWRXup
   g==;
X-CSE-ConnectionGUID: zhZGi421S9K6ulKv3LElwg==
X-CSE-MsgGUID: NWpDK9WDSk2rEJ/zpjL9UQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="63241180"
X-IronPort-AV: E=Sophos;i="6.19,245,1754982000"; 
   d="scan'208";a="63241180"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2025 10:19:17 -0700
X-CSE-ConnectionGUID: x4RnHE38RHy4K8o6PBIWNw==
X-CSE-MsgGUID: scv9OtqnQwWtsZJCTM8kDA==
X-ExtLoop1: 1
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2025 10:19:17 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 21 Oct 2025 10:19:16 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 21 Oct 2025 10:19:16 -0700
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.28) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 21 Oct 2025 10:19:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xWf23ru+kxZmrkas18L17UgYu7T2SE+aRxhs+gzPJct3N7AV1T3b8zOOEKXkX3C43uAF7xLLfdNz8vQwOzRdN0NAbn6QST81sFJhvZJQND0jDvodtRkSEqm4SmJY/+VthFCYuLvTAYuMBRJ6uCi+VbbUOolFb5k+vn04MxpgYSvVbX89zqCLbC7NOF3hWBj6SmM5JOPn7SN0cThu8cpJXq7JXMfDvIcVgGgxl+XryFPbyrvNKAQTOAoqifyZi21FYlvemNm3dilsY6Vm9vjatlY8IE8DmSLTmGQTrg1Q+t75CwkckORlUXAJ3EnquuVac0i4DdsJGfUBTxSveY591w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t+9xBgreifDlDSQrwHUpv3AcKUKe/s8ad4gc524H/js=;
 b=uVW/8GtknoJFsEesvBbdfVASj3ka5ft8MB2BQ099Ok46IupBcseOscolKFM9eSRjOXlbzZGIcPFtWxwCWBAfL5nYAIh1rln0pBspkbeAaO0LnbpGbeQj9TULvvJBdGSDehmqWkkQspc25+W1p0YwI3Klr+a8wR6aBkICyGn4TbWEAN3C/4XXNZjHFE7Zrrluxh0Y4rLad29YNaFe5h8E6dYutAqt3QgLiuTuPBoZW+qxHKoITOXuUZO5icR0B986UdEExFM+DZlvQV6u25WyW/3GP2EN8qYoiZHDTm0NvCgk2fa0gtMvijCwAUy2+GVcC29tSXdvgxgre3cinReohg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by IA3PR11MB9040.namprd11.prod.outlook.com (2603:10b6:208:576::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Tue, 21 Oct
 2025 17:19:14 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%7]) with mapi id 15.20.9228.015; Tue, 21 Oct 2025
 17:19:13 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: "Weiny, Ira" <ira.weiny@intel.com>, "ankita@nvidia.com"
	<ankita@nvidia.com>, "aniketa@nvidia.com" <aniketa@nvidia.com>, "Sethi,
 Vikram" <vsethi@nvidia.com>, "jgg@nvidia.com" <jgg@nvidia.com>,
	"mochs@nvidia.com" <mochs@nvidia.com>, "skolothumtho@nvidia.com"
	<skolothumtho@nvidia.com>, "linmiaohe@huawei.com" <linmiaohe@huawei.com>,
	"nao.horiguchi@gmail.com" <nao.horiguchi@gmail.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "david@redhat.com"
	<david@redhat.com>, "lorenzo.stoakes@oracle.com"
	<lorenzo.stoakes@oracle.com>, "Liam.Howlett@oracle.com"
	<Liam.Howlett@oracle.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com" <surenb@google.com>,
	"mhocko@suse.com" <mhocko@suse.com>, "bp@alien8.de" <bp@alien8.de>,
	"rafael@kernel.org" <rafael@kernel.org>, "guohanjun@huawei.com"
	<guohanjun@huawei.com>, "mchehab@kernel.org" <mchehab@kernel.org>,
	"lenb@kernel.org" <lenb@kernel.org>, "Tian, Kevin" <kevin.tian@intel.com>,
	"alex@shazbot.org" <alex@shazbot.org>
CC: "cjia@nvidia.com" <cjia@nvidia.com>, "kwankhede@nvidia.com"
	<kwankhede@nvidia.com>, "targupta@nvidia.com" <targupta@nvidia.com>,
	"zhiw@nvidia.com" <zhiw@nvidia.com>, "dnigam@nvidia.com" <dnigam@nvidia.com>,
	"kjaju@nvidia.com" <kjaju@nvidia.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
	"Jonathan.Cameron@huawei.com" <Jonathan.Cameron@huawei.com>,
	"Smita.KoralahalliChannabasappa@amd.com"
	<Smita.KoralahalliChannabasappa@amd.com>, "u.kleine-koenig@baylibre.com"
	<u.kleine-koenig@baylibre.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "linux-acpi@vger.kernel.org"
	<linux-acpi@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH v3 2/3] mm: Change ghes code to allow poison of non-struct
 pfn
Thread-Topic: [PATCH v3 2/3] mm: Change ghes code to allow poison of
 non-struct pfn
Thread-Index: AQHcQnTQsdTtPwE0dE6ADFK/CsyF7rTM1xKAgAAAnPA=
Date: Tue, 21 Oct 2025 17:19:13 +0000
Message-ID: <SJ1PR11MB6083BF0885BC19E715C1A96EFCF2A@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20251021102327.199099-1-ankita@nvidia.com>
 <20251021102327.199099-3-ankita@nvidia.com>
 <68f7bf2d6d591_1668f310061@iweiny-mobl.notmuch>
In-Reply-To: <68f7bf2d6d591_1668f310061@iweiny-mobl.notmuch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|IA3PR11MB9040:EE_
x-ms-office365-filtering-correlation-id: 7190e753-c0ab-4d9c-ff28-08de10c5f4cb
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|921020|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?YZUBzGM1B/+pJ9jotXHHsvZw0aYx/ue6B9vWl6CFrk+Kamf+BehyIOqK1m9z?=
 =?us-ascii?Q?QZtVUm2PWN2h3zTKiFisnHJRZk0BiMln9XVUCW4mOKDxt254p2YbNyJG6XH+?=
 =?us-ascii?Q?Ems9zNPp67SOnQ+oIqHsrUgS0Yhge4N9v/fBngZshS6QSgy2HHfq41kUb9XR?=
 =?us-ascii?Q?ceWJkRZpsGcKI1lSduEoNnUpqsE0Z02qJR18fbI6hvbdPZR9vJ3LidnY+AR/?=
 =?us-ascii?Q?qbUYWSxCOG97whKlKS5Bl0avearXDyzI8yj9c0TfKTUiZoABE5dksh11mlE3?=
 =?us-ascii?Q?aOPwvaRmKxD6QVyvkQVXzMsed/AeUS9cZBZG5seD2qnLKNOFhB/o+5i2jeFI?=
 =?us-ascii?Q?Gz9AlH1KHbiuKtnc25wMffUBA8vbEyPJ+aDQPByofauQ4jucibbuFJGBudyv?=
 =?us-ascii?Q?SMoKQKJy/B0zoHQh4CvcsrccpvPaSgzoMy3U2hZklpfEF4pFGSh9qr84PwQr?=
 =?us-ascii?Q?0jltRjDCacNJdGbLIe9mq9h54FOXb2RTTrUk1cWWzZp+6fv6VIQ4etrqvNqK?=
 =?us-ascii?Q?ubIBV9lYrIBLiK/99Vm5dFHF3BV6b1TNBa7L0wMAScEJJ2xy5dO2fcvozPEJ?=
 =?us-ascii?Q?IMMxBlXRRHUZi17/2BxsD+YpWKblF/+g+WxX12RtkGoap/1cg9Ka4U7GegTs?=
 =?us-ascii?Q?cE0ZKpH5aCBhM2jvCEc1jL2he3huaJAEYA8l3iPfMwutHY2gx+VWM2/BOOLg?=
 =?us-ascii?Q?EdphZBBj0tM8iwgQLQJmoH3svhw764NDQ3uCT51cSMHoxybpZS/zKoPWtZUO?=
 =?us-ascii?Q?v8Lgw2ObStEPahJGo4Pr3KpAboJ9urXEVq0Cr/i3ghHkitXTacMpQkrDX2bU?=
 =?us-ascii?Q?7e2N3RI4IblmtJF7T0CquGhAWUHLFl4cKb0BQIDWz+RkiEY5e8IS3pTN5lix?=
 =?us-ascii?Q?6fo3k6QN6pg295d2qjyLklZHzsDf+5YCP78bxEt01p9dlRjh/bfQf6J6dru9?=
 =?us-ascii?Q?HO/1cL8t/6H96yNxZ2Q/O2SokUiK81sleeC15zlctr9RXEoIHnKXyURh3zH/?=
 =?us-ascii?Q?b3/ASYHAaWG1BOQsiKjS2smumh/FmSPOiAltEARCo9uVUEhVJsaZlaWxQBOY?=
 =?us-ascii?Q?uBO+nu14KaCxzZBbx8vvrQFvF6AfxfGwQDurvodwklRZ4BA+eXePtGVqsGtG?=
 =?us-ascii?Q?Mh0R/CP8b3eeN5PuHHOuCgLmUFE157+hZ15R9vavUVbyXX9fjv5PRW9aPKVH?=
 =?us-ascii?Q?ALEtRfkduHiGz/4Gc7TelQvh5qmi2RJg2LHvXDBEcJHvrELB+4O2r1sWP7sb?=
 =?us-ascii?Q?Jgkr3gPEkRf4DCZus23PZ5uIH9ldwB99KS0st5fk9DpGaVQ7uxzl1IZUvVw8?=
 =?us-ascii?Q?qpmYAYd9Rqs7Tj+r152YY76MTzTuT/L46wvwi2mFmm4hjuu0ay2l7jOpKys/?=
 =?us-ascii?Q?2e020XwIyUSiEiMHWXUM5h6dIEIphQmoGadRHEP6ascEMSJQ4KExVBp3GPWE?=
 =?us-ascii?Q?n+n9zHMwB+wTZAtbZMnmiOr/LZ0j/ltv/zMgysxx7HCBiEWjE5JU98xVEHmG?=
 =?us-ascii?Q?Hl+MzG9+xhldqZbwHo3OoOVccGB5h+5TlyQj5bB+SSbd/8HUhmrU2LiOqA?=
 =?us-ascii?Q?=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(921020)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?YrzWFBkjVR9jaYLQvPIfiegGT0QT3Z9aMVUoowjcpXX2lSm/NQIGOYmqbR/y?=
 =?us-ascii?Q?b16QrhzMyuwKGvbDF8oAqQu1nlOxpI/SAhAvP3Ii8udHpMz/D8CJdzmsYAWc?=
 =?us-ascii?Q?aZLRHPvU7kZeGw866sq5aCmud1/uY4iLLUlmt28VX92FdNl7bZCA5My1H+V7?=
 =?us-ascii?Q?RNZgTc4QVH/6fHj2FgjsYrvtoG/hsYYeB2xKFTyGycv/TkxogHGzhjhFGgNE?=
 =?us-ascii?Q?vq2569V+KQ33sT8V4fb98k6HpCbUDii7z0yBAFgEtBzU1s3J8x9iQG93ByIE?=
 =?us-ascii?Q?QqHEgQme1HXUVhsDYjoCMpHFhEI9KC206MkDUr2DH+BfrYXrQNQ+rjdZpyXf?=
 =?us-ascii?Q?ILhZpXIlunxV/eueZT1KbpwjqjgIFDLmVM+AWrAoCzH6b04gCk1NqmWmKl/9?=
 =?us-ascii?Q?aUW2IEzheMl9nQL5p6CwJt9/gB7NTOgjvBmZKCiJk/g33t9KBvWoJCYYQX0k?=
 =?us-ascii?Q?C31dYolRDW+XJzni7whclc4M9iGpNpPUSSbvs0r24XpCBib/8DQXVukxLHbL?=
 =?us-ascii?Q?TUDFI1WD19eKJwTCYb3dwREPXWlHIyqCMku1iUSO020KHhYH5+pdmgQN3Kz5?=
 =?us-ascii?Q?mPmwnZU6o4VxmNHsQSEd7JX5KFc2Gxp03BdLwExfKleT8BZ51VzK9I+taWS0?=
 =?us-ascii?Q?OTrdO4GdsuiTB055pIBal8elJPvIo30IGy00m6rPvd1IVCVdKYXi1QW3dheQ?=
 =?us-ascii?Q?YwVMDh2NmRva84cnnItuvEvGVR7XxT/xm//MAmJlyNkEC9+LtxRtFzvFmM1c?=
 =?us-ascii?Q?GmuaiIb2hPvIrw/bl0NCTHGHMUn7+SKk0B9oeWMl4mmpDtUfyWG8uPtGw/fz?=
 =?us-ascii?Q?Zi/xHQvlrrs4xDHzjPKWl+bLPrQ2LBjqUz2Z3uiToWM/Jc83BFLcfW/B9Q2M?=
 =?us-ascii?Q?99gn8+6IwcncJo537q+sbVvSK38uVk2L4+mADqgOLuQrPqztwNlaPF5rMQ22?=
 =?us-ascii?Q?fqoNPWDDHNTX+Rt6Ce1x9DYy7aLSiYD3Kh4JbED/miyLy663jTTyzpKmJ7Q4?=
 =?us-ascii?Q?EtP9iyD4Yu4nx8LSj7ecSs9rd+F7CHq57ILfy/ZNt2tLerZVyoDjzoYULUXW?=
 =?us-ascii?Q?yV9IMopbf2pR57ZlrZXZqrRL63Vk2h09iICfvGg9xwJ1wOxzecukdhSfT3v0?=
 =?us-ascii?Q?zFmNLpphnAVBoJiC2ZzuNJ8drak57FRFDH1kJ1iETcjKTwoSKymrSWgoYwSO?=
 =?us-ascii?Q?D9XWrfO+sJtNql1wwME7S6Hu0ZdhipQtkLWkpr/6yT62nHuT6PvSoD+xZGxZ?=
 =?us-ascii?Q?56WQPzN7JujkPN2GM6RMjKjEHrJw2/BOgepomxnrjhfJnZRkTFzwwg8FajB8?=
 =?us-ascii?Q?XmN5J2NirgnU1DK2xgTiv0ZUNc8JD+vxQhlqOtxIb04MQIrdtMrgyw3gnpyp?=
 =?us-ascii?Q?VnQOExRftx/+8eWPgWKqOkHsKHqIkgpY04llsFOxTdBp2OboLqpdyNRlIfap?=
 =?us-ascii?Q?V2naai6E4VsQrGmzbysSutelXl01u3O1YN91d3G+Z1LfiB74mOKWrAFqEsoo?=
 =?us-ascii?Q?bp0GeOmP+QzLexpen1vr3TgIFjVGB+ZzOzEIqO8uTSDcfemjuUV3yz2A2cmN?=
 =?us-ascii?Q?0sQ1hXjOiZ6i+XHst9w=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7190e753-c0ab-4d9c-ff28-08de10c5f4cb
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2025 17:19:13.4722
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gTJGp8UwJ/UFGBiXSwY+t1jU63FZrdzYhtlYKe9igQHb7K231TloTWsq4iYpINdXnuVkb1PcWllMIfQw9p1qfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB9040
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Queue-Id: 79CB218000C
X-Rspamd-Server: rspam03
X-Stat-Signature: rb8mo1d14zydau64pc38kzw3jc138z5m
X-HE-Tag: 1761067158-330677
X-HE-Meta: U2FsdGVkX1+5qR3e/3cH9IYbjGZGeG0DuaT7NP8cadwa3iKghL7ivtoZ9ku2Zd+N/KrOczqBCsToLWMfkKzUlVGzTmAW3n+9mO3YRYhL3vFb35/4JF6XXZU/UfL2jfkpgzA7zEK8xvA7CPMiWDADFYTjz8NYExZz11572AulRTmp2R8849zrS0kPtZQh8mh1zsCB5lsMCZzZBkhvyZE5fwyLGWtYt2Ci1AybzG5m/vPM6RVsr/7QvAmVUxneaFocsjElPcGaLOB6mfLORiLoikhyEwensS2M2ldR0SCHpitXadGaowYXsugFJuACMNAIHHbhZ6Hk8MQZhqlabwrztYVdm9jJAGtvSvcCehaBZ2MJfXCHcmVsZNTtEamMt20WH2/X3swKIXbhAtS0hjcGsDDba5bcklOTfNFFZP68aCm7XLNWADfX2sGlq5fo+tuPwY2FfeMWGQ1aeCi9ooesYEqsuXXNrfSQdKc5ziyUtCqMUTOd3Hk2Vzi6eFygshlIwxIXPso+K6YgPyftsAbfUkKmpS2Jr6cYYmrtgans0neX/u7s/P3BeqxnvN/EwGqDEYY9aDJdGHRQIJJ6V41KEL+XNF+VuGlnIV0Sk9Q8n+A6RoXMdKdTDLZzFiclwWQD/uYHm4h4jqDff/U5F8JpUD9oFm22KUKPWLtHopDxehNqRBNLunkTQW38SuSdENHMFw5HvtXSU7A0yirfVfS1yLAkQTfy1A/IndplSkiRJQsE9F0J/tmC1FhKn/vClco1fxUFEUVkqYbcnlovz0Up5q8CTLPoqkxSGUYvqm8pTng41ti3o85rupyPG4KMhnNX89AXbyBE7PVG9tvsylXHSZiLjGZbWF4w8l2jAVHte96/6ePKPDowgcViqKeuux0oJ+ZEfb0vIGpgGVZD+GZGx6b0MOLLJN5X0oF3sYVBtWjVMBxc4haApIxIiEHbSxNxuhEr87hoBUMxcoyMT3G
 nTAbQfsm
 gSUGwSpdbt15++tSXpeq8asNKduGkxAUh05XLjUjC40OoPsfUJzhuC0HFRvRhZU12P6HT+zKS0B+zOkwGYmTtZ3ksWufKxbXe5vVdI2SSz6QsF//wzT7QC1w1teQ9+n46sIB3wI0fJeYx3xGTle6xjiJwe3VjAy6d1IvcW9gj0RFHHhPp0nCeq1U4ZhYZ4jaNtIyQ/NW640cNSi01wBkzyYeaXBMUGUpZIErc5gwPkhLq/E6aqcVzz1kDZScUcn69xqZqPT1veqzGocg6AuMEs6gUp56DA0q3alSZi372xl7MQahncrANoSQvNOaCFWfJtsT/2V8JPDqMgLPzP/bHT0F9a5jjlv64P0ROd6p6/ml81R5Jjs3+zEJryFG6dxnKo5x8i2rr00W8r/1O9plV0fS6SXM4G1+2Vid717bWMaZ8uS4USH1Y5yDkApfKixBxTXZP0NhvWl3d86VEvZlOB5nZsDNlxHLNfMAQT3cNDR8AzsX/v5HbtHRT2qkfYp/ovZCjCLCEP5T3UxuWb/xt/Md/HEce9lPPqARhy53mwm5GLF/5a9eYsJ+pZ12lbbK51srAADpdouOvMcM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> >     pfn =3D PHYS_PFN(physical_addr);
> > -   if (!pfn_valid(pfn) && !arch_is_platform_page(physical_addr)) {
>
> Tony,
>
> I'm not an SGX expert but does this break SGX by removing
> arch_is_platform_page()?
>
> See:
>
> 40e0e7843e23 ("x86/sgx: Add infrastructure to identify SGX EPC pages")
> Cc: Tony Luck <tony.luck@intel.com>
>
Ira,

I think this deletion makes the GHES code always call memory_failure()
instead of bailing out here on "bad" page frame numbers.

That centralizes the checks for different types of memory into
memory_failure().

-Tony

