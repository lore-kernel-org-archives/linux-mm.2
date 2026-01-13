Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF758D2D109
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 14:05:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C1E26B008A; Tue, 13 Jan 2026 09:05:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AC3A6B008C; Tue, 13 Jan 2026 09:05:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 277D96B0092; Tue, 13 Jan 2026 09:05:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 18A6C6B008A
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 09:05:55 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A7AB8160188
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 14:05:54 +0000 (UTC)
X-FDA: 84327114228.11.0085B94
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf04.hostedemail.com (Postfix) with ESMTP id ACABD4001F
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 14:05:50 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=WmrSXtug;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf04.hostedemail.com: domain of philip.li@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=philip.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768313151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h92eR5jlQEr9vn2lRFu2fM5nxTYzBi7cnScp74bStY8=;
	b=XxLMuLZlDVzPDuzDOrL90ZbqXmiFXjOcZJ3ahrAwRfkVF9jBMTaCzjdOJyz/64AoBl6fXm
	/jCRrirhdpB7MhBsIycqKOKtwy02/HsiUTK8X5ZGZFNRsUbASDnbIBuiwiYODdcA3h0AyE
	wusdpXTUQtomryxmbVSEcDddV5+yXgg=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768313151; a=rsa-sha256;
	cv=fail;
	b=1tDZTJm23dJcgAVsb5/K9PUNy7lY3Zu+CAM+Xygo98Z40uqrpGfz+XiY2oxhxqLkK+hj9J
	mvmO8e+FWa1FzQh1xVTX2If40Bzjik9qrJtLZaNvInc5KCfKxZ1HScd1Hko9oHyRKYsq9V
	Mg8/6TIBPgONXp0Q0VT4lVGPFHWlWsU=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=WmrSXtug;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf04.hostedemail.com: domain of philip.li@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=philip.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768313151; x=1799849151;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=t4TBotJTsQnMgICDqR1pKeq3peaD6GlrFEMtzN/CecE=;
  b=WmrSXtugTPI8w8aSHivWDj6nALlcbV/lhl9t9wX/dtaqbISVTM/3Z0F3
   TJOmY1+o3QLlb2Uxr81cB8DQcXOzt+sD80rAbLOiBhpS7jeDMLBluqgLa
   WDz32HabZdWKACZo3pcX5nVLzG7IRlP3sOiQYHjGIrRywsItAfU8rxjsF
   v5Yf+xDzRijmb5KPk2zrSxO88kfmTuky5eLdsWUHmv9H83BbSjetgyKyx
   drZDWGxmAbsZq7hLI/bL0kBBIXJ8R/7bmGoVDm+9VmlLFLh4YiFwftSWl
   QXW8edYuC66C+S8WPG/BL7zNCs4ARD4tCs72+q45FUXW5RwP8WMsHtgiX
   Q==;
X-CSE-ConnectionGUID: NdJcUVKwRH+ZIOA9OVR6KA==
X-CSE-MsgGUID: +chamsEMQNWqiN2w1g/kSg==
X-IronPort-AV: E=McAfee;i="6800,10657,11670"; a="80242302"
X-IronPort-AV: E=Sophos;i="6.21,222,1763452800"; 
   d="scan'208";a="80242302"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2026 06:05:48 -0800
X-CSE-ConnectionGUID: jIyZAisdTpOKbmW+ZKM7BQ==
X-CSE-MsgGUID: EF3S+AxNTzeuEyIS30a4Dw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,222,1763452800"; 
   d="scan'208";a="235644716"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2026 06:05:48 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 13 Jan 2026 06:05:47 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 13 Jan 2026 06:05:47 -0800
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.52) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 13 Jan 2026 06:05:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Gbrqog7geV+hXA9zktcpdVcR1pOdp8C5mNApFG+xNn6p6+nYSnzkuep3LFlbmsJQjn4d4AdjWTOFYyP7B3Ev51BkaA0XRSTCIV53X98B4alBxbsMHuz3XocL0Z+StRYa/SsThvDW3jA5RAbPsixXUOUAVFkQfZ5w03AYE1doklq3H2GH1qHSHNbwV09Kyv+R+eZmfYVjfKLU5fzErilfxyjun6+k88HuG/ZYtEKHS1dr7H66DxH4GHpmn6sqn9o5vqaWC0cSW8oSXykOKQAjN6ovPD/jmI9WFNU2Pyg0+Hg8aNnS7xwOptzImyynPrPNbYszmkeSVdHQfKRfmuIRiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KLYYNBU7CUOPeLQrmbfdHCzQPUs4MEPOdXB5qFxldCE=;
 b=lYYFEbAcqlysCtQIr6C9Rix8XWkTffATQjjtzXB6SduTWzNOr89lAJlNhdhWglktHyOvZDDv5IM1AFXkR4QSLLUjQj2ufzOuTCTmVsFh1JUnTMAhLFcUKCy8qikQ7Yh9AFpwwbcE9U4oquEEjV0bLCrLiJ7mJWPW3kENbvfxuae/K6jyyWtn/9c33OEqLeqjyUlmLqg25oUWR6s6rE3VmeqF7l+WN/1UbYq05NZN4EKVXo1oM1lnYLoZvZH3x3XzEBTpxqtN8NEn1RyPX9viBsHSA4LKZSFP7SET0E7c7AYwgcP1kuCtWQ9WKKBKDwkXu4rkSAgnojIu1scbgqmU4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CH3PR11MB8468.namprd11.prod.outlook.com (2603:10b6:610:1ba::19)
 by BY1PR11MB8032.namprd11.prod.outlook.com (2603:10b6:a03:524::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Tue, 13 Jan
 2026 14:05:43 +0000
Received: from CH3PR11MB8468.namprd11.prod.outlook.com
 ([fe80::8188:d688:bbca:2394]) by CH3PR11MB8468.namprd11.prod.outlook.com
 ([fe80::8188:d688:bbca:2394%5]) with mapi id 15.20.9499.005; Tue, 13 Jan 2026
 14:05:42 +0000
Date: Tue, 13 Jan 2026 22:05:30 +0800
From: Philip Li <philip.li@intel.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
CC: Miaohe Lin <linmiaohe@huawei.com>, <lorenzo.stoakes@oracle.com>,
	<Liam.Howlett@oracle.com>, <vbabka@suse.cz>, <rppt@kernel.org>,
	<surenb@google.com>, <mhocko@suse.com>, <nao.horiguchi@gmail.com>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>, <akpm@linux-foundation.org>,
	<shuah@kernel.org>
Subject: Re: [PATCH 0/3] selftests/mm: add memory failure selftests
Message-ID: <aWZRKk92pYvwBLj6@rli9-mobl>
References: <20260107093710.3928374-1-linmiaohe@huawei.com>
 <9413a995-9182-493e-a28a-6d2d3a17236b@kernel.org>
 <2ae04380-fd60-a8a1-6217-386454fec610@huawei.com>
 <693dc9aa-cf86-48c7-be9c-ec554f9da855@kernel.org>
 <d958d80a-8412-6107-e144-975b8d545568@huawei.com>
 <b258b6c0-7af1-4443-bd81-2722dec610f7@huawei.com>
 <d6a544a5-9d22-4c89-bd53-92330f4a9f51@kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d6a544a5-9d22-4c89-bd53-92330f4a9f51@kernel.org>
X-ClientProxiedBy: SG2PR04CA0162.apcprd04.prod.outlook.com (2603:1096:4::24)
 To CH3PR11MB8468.namprd11.prod.outlook.com (2603:10b6:610:1ba::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8468:EE_|BY1PR11MB8032:EE_
X-MS-Office365-Filtering-Correlation-Id: c7498849-69f5-4700-5a0a-08de52acd6b1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?GAScgfl0ZaWYNib50byxtBhXfmFy7TX65vjznXEuohWNDiNNa1bj0DIUqr?=
 =?iso-8859-1?Q?uuq12ur7HQXiuwqP9s6TtIMrAvyMk9Dh+dTUldBP+jiiOYj81SluQwKNZe?=
 =?iso-8859-1?Q?Kj+hdf77wLYZ/uRv34cASinbPHivlbrd184bkt/XgN0WobssZR6TglInBh?=
 =?iso-8859-1?Q?qqGvUrtr42GmHAmLFsWXVUN31DqSs9+z0P/9bpe71jeNeNUjruJKj8wyPm?=
 =?iso-8859-1?Q?FafqOlj+BbW/Q0R6dLvANfJN5Sf7MqMwUiKeaIb9x4pMFDyRarmi3VnN4B?=
 =?iso-8859-1?Q?QKCXlbdFcZ988ay9Lg3TvZHDTDBzucfMGjKGGnNndBmodx7wEt/hoWcofg?=
 =?iso-8859-1?Q?4uTFg/yOGeBGaxhTc0w7Z5bFyet24PrQsAgIskJt8GIXeoagS3Akk74Vfk?=
 =?iso-8859-1?Q?XUrVbUoDbPSzchz1QPkXjY2Rdwm8k6+BiUOiRnsGzGvYyE/Q/AeQW/k29V?=
 =?iso-8859-1?Q?D89v9XkPfNrRzizqOCGRVRf/bHD78s2w29F7Msda+QL96FyXVb6Jmx84UA?=
 =?iso-8859-1?Q?7ZaV2GH2phUOOExGEVvQv2wNT9MrYqSCAXCT3Uh1nD8E8chb/6UKEY8KTx?=
 =?iso-8859-1?Q?X1fV2ordWeRYqIPM+TzjyBI2vX7QzMJt8AVVr/j/fzGbInS9+g18eIZbtI?=
 =?iso-8859-1?Q?Knweu0HU4K0tMlXER2rPDQRxwt9CNugasouK4yk/1oV5RseuH1FKHh9g9I?=
 =?iso-8859-1?Q?XQkKZ0oDRH20/zvVI37hNKmlwvoSToI+JRjPxKW8M39eBusG7GuPiUPUAu?=
 =?iso-8859-1?Q?dQk5OpXz+6n/Q2JaT8oKBsaJcyd/skCGlMZZIIQ+eTOjKIb+Lj4XFAcbHl?=
 =?iso-8859-1?Q?XZK8sD6lj0VN2ZcNXgRnhdSoPZN1kBjT5ELneqPDLVdivlcgAfJ8RlLCsk?=
 =?iso-8859-1?Q?u+7xxSWqUfyQJ9pCUwp3CGwC9lxdZ9nGZ2kMrB1wbUplJmVyRFtsrTLWp/?=
 =?iso-8859-1?Q?whDSX8uy0ger7WP/D+85dzWRKWAesWi6uPIxHWxLBa4MX+2blb3rLBjl3l?=
 =?iso-8859-1?Q?Gjk110mgrwKAedhfm03T52Z1p+pPPZUAZLwlz7o6oo4jb1rY1PwcgHJAfF?=
 =?iso-8859-1?Q?B3zVP5jqb9aLHSCprN2kWA17QPZWWQ5D+37JSX9A91RQA0In9Za0fTlEUF?=
 =?iso-8859-1?Q?UdhiuIKRXJg0kawB8AtcmCSHTua+JedE7yMmf4FUKb6mncQ0QYpZANcR11?=
 =?iso-8859-1?Q?ljVAGqfXsJF0EtqSddGKHldI4+DBRZXusImHQ4OO1uIys4WDpN+IO1moUP?=
 =?iso-8859-1?Q?nYm1g/1MdrkqMn7XxSYEX0pR9ISVDQ+88dE0tYE4+xlw0188w56W1Fl7+O?=
 =?iso-8859-1?Q?OWb6xgyIZg6a2ok9Nd96hiSwX+jWSXoVhYAhfuhF/qWpybjYk06COtCK82?=
 =?iso-8859-1?Q?ZOlooAdvaignA6uvUOQMEy3+1EkfyNXSdCswbRfROlYemKOE+GO03zJ7Ow?=
 =?iso-8859-1?Q?1Ncwy4RrRe/1SxZeGDJnTUeborKY9rwzT6TBdJKu+vRlnJO6R0JzNQ3Yfr?=
 =?iso-8859-1?Q?oT1D+OHTZQHAwLu+Cl10Vj3blR3l7fV6TvCrPjNkn35A=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8468.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?nWmRudRWd+hq6SLLVwSE5ONb71aECajKz/ntb1bZjKSj4832gAonbGKhLR?=
 =?iso-8859-1?Q?edAk78sqMc9cTNIjPA9zA9FlpExdTZkWsG9hJy68Wd7TwLLoWTUAY9q2kC?=
 =?iso-8859-1?Q?7x7V93gffXwgJcmMLuNYf6GNp6P+3bAv00T2FuznM4aJMAecZOkPdsu0YC?=
 =?iso-8859-1?Q?YVG3AftNCO+i28sZdRgoBqFvjDHRriUJMPvEzzDQWAvzYbknB5xaV8XHnU?=
 =?iso-8859-1?Q?4OOwyb7PvDDaCTZUXHiTAu+kdjRMSHA00H8pV0E7j9Or1KtaDbFt7pc9ue?=
 =?iso-8859-1?Q?r3/vM9zyfo55IVlJX6nsDYgrHyPkf8VkshOayyJ3ycGXHCIdhlE4h9X2cD?=
 =?iso-8859-1?Q?XTVlhuBkcoK9CEfbAh1yq0Nk2XfZDPFdvRYTVxBr1xRr+stHNzvVwkX7Ss?=
 =?iso-8859-1?Q?lqB7sRheHWBAyAU/DBTUQYkxmS876nAUKz6mkzGbOMjb50a+Ym1Gw2uwEK?=
 =?iso-8859-1?Q?2tVo+ZbnvltCzzLdUE2iZS1S2t0BOS2Cch5/GmHqWllYIlyQPp7Ou+SJ2U?=
 =?iso-8859-1?Q?ur1a/+2OHg6hVPKBMizFtFBmE3En1NYtJi6sHligJz9RWkDVueo2cW7IR1?=
 =?iso-8859-1?Q?R+98sPg+xYE8LFkQr8aEXv96C4uzjnxYf7NFgaUxgL+AmnMH411vy/mk83?=
 =?iso-8859-1?Q?jhw62Iv5gPgPnNrulzRtawY/4UJo8zVA511iYZ8iD7lfgYHp7NKE693Hbs?=
 =?iso-8859-1?Q?ei2s3vvQEAaCgHPayb5zaVzdVY/zxwmAEzZqf2wlAkPVWwHk61CYeUw136?=
 =?iso-8859-1?Q?TeYNzeQWzTGzvcExdsxGtQd9wyfsDNwvMSOTON2cklUYoFR7W2dUnZnKLL?=
 =?iso-8859-1?Q?8seMSwJcCxs2sqFjW5ay8ca5In5ClDZXA8SZTRPouwSzu+f8Wj6+WdpvOh?=
 =?iso-8859-1?Q?lJN3gx4eYCZyTcRLwa3XF3QLyvE+4NblTEnzcNiVqfe9Z0FDye4zCTbGc/?=
 =?iso-8859-1?Q?mxQjaAtW68bptOCnrILhuujPqOu+5P6NhHPR52+EE8GhAenKWb4jQK+79a?=
 =?iso-8859-1?Q?GnpgFp8Dnt3PTI7QflmeJ6HMwrFyhhUD+7QI0Aw26+dHkDcHM9dBPoOhGt?=
 =?iso-8859-1?Q?H0xuSO3yVvAa6aY9Vf17rd7Rsn1vWOXKpd4kzocU38VKO3RbLOEzzreyD6?=
 =?iso-8859-1?Q?+bp19XqokXE6yEMNGW5lpTrcB/GLaxp32HtHEbrrAOUEXD96nQqkDHNR71?=
 =?iso-8859-1?Q?X8Sg2ZYAR3RuGf9f1zxeuzGUXq8PCWagvk3MYEjYA9cb1wh1hFdDpGDwb6?=
 =?iso-8859-1?Q?8GBPorTnZ5WLX/3mtgonKuh+O5hjMZPPuc4+Y/qZnVvs7TF0eeXOgrNBxf?=
 =?iso-8859-1?Q?Eonir2+nNqLupArjkzi7abc6UVmOlJnP44dJECQE0uwpnU9FTEREWFTziW?=
 =?iso-8859-1?Q?0shJ5V5Fi0kDti7yhFGNXuykDE+jHBUF1t6fELV0fi6KbBztfVSO2NNkaz?=
 =?iso-8859-1?Q?0Y2QlZ+4HZrgxzSwu0hbZ6AvVgJJrvnVX+QBMuKyp/aEtcPpHNWtpnivkd?=
 =?iso-8859-1?Q?okH+7F+EVKy0wQb31wdwMCnX3OLeUOwmkOj2irwyJJnRMYcUDI6G5gnsso?=
 =?iso-8859-1?Q?7nR7zU8e9og/1T+ptumpqEeOKWxhrSiawCl7mCBjarE8iu+2MOvoG69SHj?=
 =?iso-8859-1?Q?U2DITh7gx58iFC306rrcOj7x2rbt/E0M2vrDSJCYoporMPBBtr707zBe+b?=
 =?iso-8859-1?Q?lsYbPO/mygWU0YeTCsMjniSwJ9VZOVRIz4o7YCBHw1Z1jT34zX4UWg77G8?=
 =?iso-8859-1?Q?MNtNdHpOPart8vU+FdIMwq22A8zSzAzh1Hx1nZ7mUnV5n230zkaSOnzdlX?=
 =?iso-8859-1?Q?zqL2ybgQZw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c7498849-69f5-4700-5a0a-08de52acd6b1
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8468.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2026 14:05:42.6477
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xJ09Zjwqb9CErOSBNvCIQW5bAlviH3wjGuzZlgZrMMas95Uv+yPOdC/7o/7TOJ4XARvPEnQWbdrjhbUe50RKpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR11MB8032
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: ACABD4001F
X-Rspam-User: 
X-Stat-Signature: gagguipafmrttdfdtnb8e7unnca7kapz
X-HE-Tag: 1768313150-603624
X-HE-Meta: U2FsdGVkX1/pLA+z099LTxVfq+v3jMWwlHxBItPuBBJsnUJhljB6O3YfaHYV3q1WMJtTf5Iqq2de22JaZIRnckDCdNvmpkJdqKGOLaJrkEgrqu2+Yzd1ZUXZ/oKYz2eXCsuCOEV4D0Ea7yDOnkDfLV303YRXGUG1/JwVzeWix3qC5d+PxCh22Ow6csWCDDQsTzmHu5WFEpaJ8YWDKSavTY9BxAeAaJd2ZV9jyv2LuTMrE4uEVHtUwaLeDWHUTUeaR5fBy6oF/FxxAndEv6pWfcwWNl/GLC/XQWgtBLs7U9YVTerHFcpVk3fJ4pAi3QmIDItB7aCoSvKD4nE05oAKXsZzgqzbEN7j5sYOw0NR3vFVQKqjO0iSnsGpmPwmBHviHnMPXN4v9UCSUIQSQvQ8jevW5rojjH5yay8hn/tPX50b2CIXXKrMOr17pF02kGwxIHEDM4HPm7BEdaN25wogvoQ3uiFGZ+XetFrI0ponyiEK7JsTjKuH7z0aLLssI6fo1/hm0ygKNRK+DzaTBlatuV23vHLbxP5Lq+MVU7nGnq9U09bWaC57jKQ0bYTAjwAnfvlzXA7hNcDogNP8r5+0s2NcLToudmnjJjQN0AxRPbOUijGa45a45uuAeRPYTv1B3hYNmvvar92xbZ6PJthPiCiFRWsIRtNAOW9/GBSkmKds7HWx5BjvarSg5PdOE1TKSVG8s9XUhbl3PCjJow0YDqj8uXi3ImYpzjjgBJU5nmS9CjAk2QgB0EGNxlI37tq0KZNrlzaagSZQUU/RrgkSyjIuxdBnh2vO1NKcn9l3lV8lQV9Ew7AvxKT9Oeqm8+j4AWJXrfFl3QaI+/BvKSltC8X3u2JW9BLozU0q/jTHCx9ysFfztqAKCBYffY2+KkK8eo6qgAbxuWhVaE4t8HGcqavky5RXZ8KI5upQpOhQwIfe6PruFEryecpXoyn70Eb3ghZ3AdJFEpKtXnj13CL
 VlC2TASd
 WCba/dA+juKLyU9sDDhgH4WEqyDx6iIsEABb9W3DwBC/VFmYhc5lcV4U5RIQWqXAg0Bz8gA2urJP/EGZLXiS40vSKT6FEDB+rVIDTp/v3eCVRzgPZpZoVPjFgtCFgRLS4WJLS3bZ1eayk3nrz1igzJL/7o76zJ1/7wiYHMFwp+mMaQVr5YuYsz4aq6Ew1fMFnB210/f/yd+pdles2mShGbbZwn9XUHZbLJAwkEQMZ49EQR2sXfg07lHgK9ZJvYk1hgl30h8sfcunUijE4yNvlSOtIgED8OqHqCCuDFUo3//Lyb6E0qFg2ZES6rf+5VXclKjneHYFOT0Q2hyKd891C5f+PAowSjEJuSQpaIUTLXAtNXVqNfmLHgHMTah7Ebj8+EPdL4XvyU2rgTWEZSG07uymlMXuq55WWVaqoSijPq02Im6ROY8SxfPph+VGoyGciVw/4AMIePZfwzJfU8tGrN9cvBdPs1wNCf4vQ1eU7bCIosjb1xdcFyv80xyJGBt6xS3NtPVOAO0vJnawXhRU1pcBlvdQyogHmJTrGSvDz5m0Pr/gD3VB+aaa4OjodpCU/o4Njj2d19zjQ8CwJ3bO2NU2FTZkGdmnnPXCdKmLf96w890l8G3HMF4dsCq12CwKb9MA0+6tB3oWKOmdj5V5vEYd9Xg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 12, 2026 at 08:38:58PM +0100, David Hildenbrand (Red Hat) wrote:
> On 1/12/26 13:44, Miaohe Lin wrote:
> > On 2026/1/12 19:33, Miaohe Lin wrote:

...

> > > > > > # # # Starting 6 tests from 2 test cases.
> > > > > > # # #  RUN           memory_failure.madv_hard.anon ...
> > > > > > # # #            OK  memory_failure.madv_hard.anon
> > > > > > # not ok 71 memory-failure # exit=1
> > > > > > 
> > > > > > 
> > > > > > Can the test maybe not deal with running in certain environments (config options etc)?
> > > > > 
> > > > > To run the test, I think there should be:
> > > > >     1.CONFIG_MEMORY_FAILURE and CONFIG_HWPOISON_INJECT should be enabled.

in 0day env, the configs are below

CONFIG_MEMORY_FAILURE=y
CONFIG_HWPOISON_INJECT=m

> > > > >     2.Root privilege is required.

yes, use root to run

> > > > >     3.For dirty/clean pagecache testcases, the test file "./clean-page-cache-test-file" and
> > > > >       "./dirty-page-cache-test-file" are assumed to be created on non-memory file systems
> > > > >       such as xfs, ext4, etc.

this is a problem in 0day, the test is running in tmpfs. Let me further check
to correct this.

> > > > > 
> > > > > Does your test environment break any of the above rules?
> > > > 
> > > > It is 0day environment, so very likely yes. I suspect 1).
> > 
> > Hi David,
> > 
> > After taking a more close look, I think CONFIG_MEMORY_FAILURE and CONFIG_HWPOISON_INJECT should have been
> > enabled in 0day environment or testcase memory_failure.madv_hard.anon should fail. memory_failure.madv_hard.anon
> > will inject memory failure and expects seeing a SIGBUG signal.
> 
> Good point.
> 
> > 
> > > > 
> > > > > Am I expected to add some code to
> > > > > guard against this?
> > > > 
> > > > Yes, at least some.
> > > > 
> > > > Checking for root privileges is not required. The tests are commonly run from non-memory file systems, but, in theory, could be run from nfs etc.
> > > > 
> > > > If you require special file systems, take a look at gup_longterm.o where we test for some fileystsem types.
> > 
> > And I think the cause of failures of testcases memory_failure.madv_hard.clean_pagecache and memory_failure.madv_hard.dirty_pagecache
> > is they running on memory filesystems. The error pages are kept in page cache in that case while memory_failure.madv_hard.clean_pagecache
> > expects to see the error page truncated.
> 
> Maybe they are run on shmem? Good question. (@Phil?)

yes, it runs on tmpfs, let me further check to resolve it.

> 
> > 
> > But I have no idea why memory_failure.madv_soft.dirty_pagecache and memory_failure.madv_soft.clean_pagecache return -1(-EPERM?) when try
> > to inject memory error through madvise syscall. It could be really helpful if more information can be provided.
> 
> Here is more information:
> 
> https://download.01.org/0day-ci/archive/20260110/202601100241.326d7cce-lkp@intel.com
> 
> Unfortunately no config yet. (@Phil, could we provide that one as well as
> part of that bundle?)

Got it, i will update the script to upload the kernel kconfig.

> 
> -- 
> Cheers
> 
> David

