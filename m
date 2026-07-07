Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA8C2C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 13:33:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A43056B0088; Tue,  7 Jul 2026 09:33:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F30D6B009E; Tue,  7 Jul 2026 09:33:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E19C6B009F; Tue,  7 Jul 2026 09:33:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 58F376B0088
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 09:33:36 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E94C81A046D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 13:33:35 +0000 (UTC)
X-FDA: 84962072790.23.EBCFEBE
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf05.hostedemail.com (Postfix) with ESMTP id AF6C3100015
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 13:33:31 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Ru0Ynl5w;
	spf=pass (imf05.hostedemail.com: domain of aleksandr.loktionov@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=aleksandr.loktionov@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783431212;
	b=oYfRWruRFq2gYsXMQSXbN3JdUrt/x4GqoSkYlH+2yDjVe0uf+eyVLZc0ZGtYumWClQj/Rg
	TlVOf0DmR+fhn87Lo7OIGjP/BKexQcGy8rd/NkiiPes7om1liGmIv/vIus3+IqxGjEp2Rd
	plQY1ni4gsFN+ovONtHmzwivOcD0kZw=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Ru0Ynl5w;
	spf=pass (imf05.hostedemail.com: domain of aleksandr.loktionov@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=aleksandr.loktionov@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783431212;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2b0Ikg9yvvDfcmG768bnHLjRch/eUG/nl1cg1u9Ypr8=;
	b=B/xBtogcizXC86S5jfv7ff8TMDRCfSQtzRzNzrZKKYFVEi8jqCufIhH7A748z6hTcVrKrI
	M2XRqi5OFSVBt0w8S6QUHULAMRbXPWOF8RHpwSNhW54xQa5M+VZFLIHydKMKiUYxFiLQU8
	N9AYr4AapUaeyDK81ety5/IsDGIpbdY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783431212; x=1814967212;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2b0Ikg9yvvDfcmG768bnHLjRch/eUG/nl1cg1u9Ypr8=;
  b=Ru0Ynl5wHtSYkYgSbjvlgaI6OG9ssihB3pi2pNcK4ZB+iWWB7qoT0/Qy
   RZtR9ryjQAZoO+dt39OZqH/i2Ry11Rvxl5kH7lAjV1Bp6B9CfkuTz36YT
   By/PHw7l8k5/Gkl2kHFpxr3TR5duFu37BbmoMuMpd/jlYb/insxXN7nHZ
   jzvLjXfDRVyRQDoqE5P5FdX3JQiyirS9onH+ZBReBJhVmtEW2UugrcuRe
   yNYMPrsG4GzjTZQ5itLmwse3/WvGYbv9V1Zyr1dKQJ5y0kwn7dgGLpjoy
   TNutuIqE2aUXUzD2fDR2JixQ+/u4uas+QcfrVwB6hYCMMqtCZgm6q4hoa
   Q==;
X-CSE-ConnectionGUID: G3bJySeaQNK4X3nfrYLujw==
X-CSE-MsgGUID: u6R9tC2AR125lxojFiT2LA==
X-IronPort-AV: E=McAfee;i="6800,10657,11840"; a="84267196"
X-IronPort-AV: E=Sophos;i="6.25,153,1779174000"; 
   d="scan'208";a="84267196"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2026 06:33:30 -0700
X-CSE-ConnectionGUID: FY5M7134Rw6XdDzg4CnteA==
X-CSE-MsgGUID: Yty3Q6PFTI6YT10t+xnRNw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,153,1779174000"; 
   d="scan'208";a="277220523"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2026 06:33:30 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 7 Jul 2026 06:33:29 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Tue, 7 Jul 2026 06:33:29 -0700
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.12) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 7 Jul 2026 06:33:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GWFgmoFkWzrL5JvLcsFRh+RPSpQfzEmG5KB+v0d9Kh+bpNnlCl0I7aS1NsE6ze/QB0VPi+JFJa0tbwgkyrIfbd2Ku7zh2WvsA2PMBnW1vVSlU6jvWQslIW9qSMedLilJiWTisrs81ndsMj1mt224M3PwHHDbkvFY8K+3+VvsmielfIrwRFxx9jlYMW2El4fz0idPUvvLzO/F+YCzjlxBDUW2+CS8/TDhFg5wOqpdMp/0+zo6eEjDM7Ib285BKEiJ9hXq3er+niICwtp7t8maJqpYu8ITHpg89BwXq3XBGq8in1WlH4Bj8rGpjrjJgxZ8thyFfUc7PdencROom3MEtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2b0Ikg9yvvDfcmG768bnHLjRch/eUG/nl1cg1u9Ypr8=;
 b=mZqtO0OfF1i2Nmj+71OCWvHX7OaZltV567KJBHzFrqFPaoIXq0iAh2D5YPd8nG0XeTwIcfByER3/v2vTfq8PHMJwIc7ztqLlNpuO8OzvyaQcVl6o8IUB3Tt/fUeHvtSXKFtKQIHWiv7P1cU/fd3hsTCAtAHfY1ZmTCjfbbttAAP3pdF9nK/8yQ5J6YH/n8sHRQEcU7mL7Jvbb6cnMHIerKyZTEA9PWRG2Opn+4HGzpOpQPJ/SeG13B3fOchpbqjbE5WIikNOXGkjHC8qJu+tdQ0V68WJnG/twsL4D4uZdhvBnIe0MeeL7m2nbyqK5PH76Y7H+BtfxQVAITx+PEXHQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from IA3PR11MB8986.namprd11.prod.outlook.com (2603:10b6:208:577::21)
 by DM6PR11MB4754.namprd11.prod.outlook.com (2603:10b6:5:2ad::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.14; Tue, 7 Jul
 2026 13:33:24 +0000
Received: from IA3PR11MB8986.namprd11.prod.outlook.com
 ([fe80::e6f0:6afb:6ef9:ab5c]) by IA3PR11MB8986.namprd11.prod.outlook.com
 ([fe80::e6f0:6afb:6ef9:ab5c%6]) with mapi id 15.21.0181.008; Tue, 7 Jul 2026
 13:33:24 +0000
From: "Loktionov, Aleksandr" <aleksandr.loktionov@intel.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>, Andrew Lunn
	<andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>, "Eric
 Dumazet" <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, "Manish
 Chopra" <manishc@marvell.com>, Paolo Abeni <pabeni@redhat.com>
CC: Edward Cree <ecree.xilinx@gmail.com>, "Kitszel, Przemyslaw"
	<przemyslaw.kitszel@intel.com>, Sudarsana Kalluru <skalluru@marvell.com>,
	"Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
	"intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-net-drivers@amd.com"
	<linux-net-drivers@amd.com>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH 2/4] ice: use kzalloc() to allocate
 staging buffer for reading from GNSS
Thread-Topic: [Intel-wired-lan] [PATCH 2/4] ice: use kzalloc() to allocate
 staging buffer for reading from GNSS
Thread-Index: AQHdCWGdQuHfYunzc0qBE2Mq9pdJ1rZiF4iQ
Date: Tue, 7 Jul 2026 13:33:24 +0000
Message-ID: <IA3PR11MB8986C7AD43098632586A2B64E5F02@IA3PR11MB8986.namprd11.prod.outlook.com>
References: <20260701-b4-drivers-ethernet-v1-0-58776615db6e@kernel.org>
 <20260701-b4-drivers-ethernet-v1-2-58776615db6e@kernel.org>
In-Reply-To: <20260701-b4-drivers-ethernet-v1-2-58776615db6e@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA3PR11MB8986:EE_|DM6PR11MB4754:EE_
x-ms-office365-filtering-correlation-id: 5d25649f-f24f-4cab-08f5-08dedc2c51db
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|23010399003|1800799024|38070700021|56012099006|4143699003|5023799004|11063799006|22082099003|18002099003;
x-microsoft-antispam-message-info: gpxDzqA2wknvHfr8J+8Jj5frIyeMf02tHHQohN1rqKGYr531jgiXqRl8Gx08jHnleLtw2WAOmq1Ftr4XzVx6/D27kfG70Urn1WFyBvifqy0Vk2JStanGoimAaUnuhy1fQqBHntc8DCUAnBL1CzBLgfgQR+XpoLIPQ21324pe/CZgCjQF31fpMaiX/DNfNh5E5qX2G0IebPciWI+U7q0khiOsOFk9OXnzzg/qv1tB+OBQq01vzbZBbo8biw50nF06SVzBNFfmTiB/cO8CL1ZmqfbQ1Z6aW098TwjuQHDbgt0z+kqAzaHB0reFqi5FAjJRVYJgqrn7TXUlcpr+qQoFuXQOugSsoSwZTjALUxd/hfh0h2Y6zHYnodtmkgVdqaK4KqoEpoD1pyWAHF4Z9qoED44ERmRUVKzrA7Xew//E3+WWuFBh4+ol0Y/GsHBYm9dWPgWHbpGqNADK79PYoWWrtHuoAQ0ztMgelZaRRwh5GeSLwbkKPJbF1dl3Yapnh7U8q8bdgy9GIJF7ywhN6a2O4HQcON+V6HMHPBchcwEqgLeRiy42h/Fs+H+VAlrBhnK9qC4lKbLR4Gm5ptDMSZIjHTDY/db4uNNpQz80CY/UaTzGIslVAfiF2yslaSQaUXB9jgepuW0UJ6kCCl1XVB2m6wer1WZIRauiGyp4ytxLqL9QgHosl09USWJt2Fb0BxF/Wt6QWCHGCqO9oYWVhXZIpvRRVQGkewnVjy1Wi/wX0a0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA3PR11MB8986.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(23010399003)(1800799024)(38070700021)(56012099006)(4143699003)(5023799004)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eUxxM2VIM3N1Q0Jpd3VMcVZqMTg4WkxsS2ZvaDFqekdaR2M3amNhMUVGU1RY?=
 =?utf-8?B?WGZ5QmE4YlppSSt6RHhBbktqbTByNWhYc0EvOUNtb2hGUExjMElWYW56N1J2?=
 =?utf-8?B?cnNJUDloZWdYMmRUYUhtY2FRdW5DZUdxYnRtelZRUjhNM3RVN3FNSFRHdHNR?=
 =?utf-8?B?WHhSSDh5cHZoazFBMUIyNjEvNWV1VFdWQnVreG1COEJZR3dPZ01ZUzlVRGIx?=
 =?utf-8?B?VFFCcm1RUkU1V0k0Yk9pYjNNQ3U4ZVJNeDhDUlFCdiszcXlaSnM1RWxWY2pi?=
 =?utf-8?B?YURjdkU5cDUzcTFnNnBtU3FBZHV0Mmg3TFRBb0xwSS80eFpTeUhzaDJvamxP?=
 =?utf-8?B?ejBxemZ1anZnT3JyaHVxeTBWcittMmsrNDlUREZ3MW1KWmlnOGVjWHdiQlJq?=
 =?utf-8?B?aGdVYzVMOVVRZkdWcU15WjkvTG16U2F5VW5tSG1xdFovakY5WjJPVnhjNklX?=
 =?utf-8?B?dmtqUjhERlByc0RCekZicFpjU0pBczJqeWtMTEZOcHUxM3BJRjBnV0pBQzJR?=
 =?utf-8?B?VndUSUYrRzB4c1Vodm13OUV6UndCQ2xncHdhQU11Rm15T3pRUU16blM4U2Ft?=
 =?utf-8?B?bVh3YVpxZWt1R0RLR2ltbG01ak5CbThqQXhTT0l0RmZEVmp1bjM0U1pCM0ZF?=
 =?utf-8?B?TXI5U0dMY1dBMWxNUld0M01XeGxNZjA5NDJ1VzVvb2g2SWpVb0crZnpoazRG?=
 =?utf-8?B?ZmlkN1Jpa0tYNFVSdlgvMkt0dWJhOEFqamk3eUJnK1lBTlJEQUhaZC90MTJC?=
 =?utf-8?B?RzhHNlpDeEQ3bWdLZE1vNERBSytPSVVydnRwdjdFWW5sRU5MZ25qNlVqRlRW?=
 =?utf-8?B?ZTB0VmpvOFpPUkhxK0I5bnZDYXptWjFOcVBIa28vT2l6b2lLajZOQzVPQlBk?=
 =?utf-8?B?MnYyRzl6aDdXdlZGa0NRd09vSGp4NnNWTFQzZ2xTS210enFhamtDejVCT3No?=
 =?utf-8?B?YXhaUGJ6MTd0cUdDWnNKOU5TdWhyVGNHWVVkQXNCUW9hOTFWTGtvUGVKTlIx?=
 =?utf-8?B?MHZaZVhmOFF0bGgzbkhnTzJhTzRjZTlQL3FjSlRxTkJCMXUwYTN1TjlpT3Fj?=
 =?utf-8?B?bXBCN1BpYWxzTElHNWZDWFlDbU9GNlN2V0VQaWROYlllM0xIUTg2RWtVaEpO?=
 =?utf-8?B?R2h1VSs0THJTd3FBMVNmNDFlblFZNmY4SVlTUW5YUzVET1NIQ3NkUnZNd1BE?=
 =?utf-8?B?d2o3dFhVN21OdDZQZ0I4UG02SW1QV0dVOUZmZmF2dFBkY043QnN4MlIyeWtB?=
 =?utf-8?B?a1FxUVBxbmVOOW1Eb0pNV2FOSU9sTGN0RlN3QnBpWFhkL2hkTnlWOVQ1MHF6?=
 =?utf-8?B?azJHZmpKNUl6TURjMzdJUzhCcnVZRHphUFVDZHFNbTFXVGZ0aGxRSlJLZzRw?=
 =?utf-8?B?SDN4alJlbjlJMVNySWVLNFpIc3RFYkpQdmJ2U3lDT2FXajVvS0J5ZXRBVVJZ?=
 =?utf-8?B?dDk5K2pzQ3R4cjRhS2tITkNtSi90NmsrWmtVZmZDUWhXdXhGQkxsS3RSSEk4?=
 =?utf-8?B?YU9JNjd0OWZZdzJRRTltdk1mQS9TZW9aUTR1Y2U4enFsVnIyNWJud0RUaXpV?=
 =?utf-8?B?SHl2QlptVy91THpsR1NSWmVHTTNIRHl2Mkp4eEdwcjZNOGtpN2YxSXdWODhM?=
 =?utf-8?B?QVR6c0c0K2IwVEpOb3l2RnVBR29Xd3lvbmxVdU84VkFJbmY3eUZVYjRRUEps?=
 =?utf-8?B?eXliR0RzbWNwMjh1SFh5dXlFeEVMbngxbDVmbzU4QzB4akFqa3UvV3pqTmlI?=
 =?utf-8?B?Zys2MzB0T1VzSUtNODZxRS9TRC9ZVUc5aUdEa2RpbFIvN05wRllYd1haSDZy?=
 =?utf-8?B?em1yVDk2TVh6NDdXNkgwR21ZdEpzM1dRL2FKdUFGVzUrS1dGVWxEZEM2Y2tu?=
 =?utf-8?B?ZTBvdFhJK0NUUXJlM3I3Z3ZCdW5yMUFQTm1ZQTUvNUlpUjJUT2FGWHkrQ3o0?=
 =?utf-8?B?eUE1SjNVQW5jRDgvV282MnloY2orWm93TWc5SlhXNC9LMyt2aE1NeXZxanJS?=
 =?utf-8?B?cmIrcVZLQkJ2QTEwRUppRjVKUTVZRW1rbXcrOTNVQVNDaThEbTl4OW5YblQ0?=
 =?utf-8?B?WXhEOUZqNng1QVo5NHkvOXkxQjFVcTk3Q0cxUEFYZWlYcDBrWkQ4MVYwOGdJ?=
 =?utf-8?B?Q3dqM1RTeVJtajZ4RlhyZ2pOSC9aWWpCR0pETFE4QTBQanNnR3czcUl5bFBH?=
 =?utf-8?B?Rk5YcWsxUmYvQUZlRUZ3Ym5VNVhxQ2Z4R01Hd1Y4N01iQlhRR203ZEpOb2Ni?=
 =?utf-8?B?MDQ0SWFvQWhlTnQ2TlZjUHgrbkttOFJCbmRVbWFWNnVXMW9JQ056TmZsNkh5?=
 =?utf-8?B?VXJYdkZCTVpSMi9wQUJFbWRsd3MwTStoWGpsS2p0dUZhMDBVYTJUUE5MaWVp?=
 =?utf-8?Q?mPjJ51N8rIGFb9rQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: OrjcA3rtKSS1Ywz/Sv+1gxK5/7VTLqSU7EDlgKIcNReZqD4AsWSibKMC7xcjCPshB6SadAAfeGlwbW/ZmFCzwDCD7VHA/ysuluYBmA1zBmkysoSPXu3X2SxhQ279uPGlneoBBatRvXm9HvdkU+UDtnjfNau9ulOAFTj4BNHovSY9YO+wFktE+B+s6ScqqvaVGxWMNbTvAhPse6hG1P8DkpEJ+NkHlFXtnehi+Kqe9jy9vfXqWY0aV6kjajfDOY8TaqK9En+XWK9LEr607TA3JJCPUo1fe38zyGweJ5sNf+hCG8EReK/9BMODKogs4GxYeRAuo1tK8rRH/Be3B0Vvqg==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA3PR11MB8986.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d25649f-f24f-4cab-08f5-08dedc2c51db
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jul 2026 13:33:24.2991
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0DQ7HdGuiMXsNbv+GFrFXw23hdZAlt8wu2tqHHxOz83X0ec0O9UI8xxOPAogOkvunr5kK3GMAptEA9w42RADQiICxSsbkDzWVVta4jWtnFs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4754
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AF6C3100015
X-Stat-Signature: rcsbcpqze1zcytxj5a3irsbtcdm89mc5
X-HE-Tag: 1783431211-100588
X-HE-Meta: U2FsdGVkX18r/YWztZHN00Avq3ms7GhzwEZXg0uFJEcLjZoj+QLQwrwpgyBw1+t5bqndxvGsonq5zbfO3aGkKWTIJf6ZiTKWl6cqhqNED4J+XRVihXt7/XI8gy/BEexQ9PEKx7C59EuZOJ5E2xhVquRiTrjHC7TT0NWfMlcPOpWv6EBV6BTaH4TBAKx7NJ0wOq6nFAj22mxRv8ZCFhno1LWKKmVnrQx/Q4UPu2Kfe66/A7Ul+ILKwJGkmU9TE0pTXl5pn+w7YFsT3KqaRVl5yBcLiYj/+jgs4rgPOgGeQzEHO8nNw6ZbpUhJfFecfBw/UQl2e9w0nbFYV5frZkqwHFgNnkbLaw1wIrR7RlGBZCEJe0BfyOF5NDEqW511nOAkjdsuBBsh4YCHaXxOFTL6j0BO8XfjrLv2sHk4nnLgfVthOJ+8H7ILwqnmH6r1bDv42+Vprx/hD6ARnrAw2aWcW1STNlLi5Pq4dR0HKPGIzsnut3KJ31nlWTb50dor2/se6tTuNwAad+UfahqFw7PfdJfFZJTb6pwU5n83EYLbBL+57vdSwZMuunnO4c0Ikl2Y/brc39zeWySLHT7lOcrs9jmiNH+hXwV3ov8/TFu70+xsFp2yR8hgyJyAWgTPP7OKW4fiqmENbptEjK7sGx51OaOVBNcb02gdyNc/dRF/1Mk0zcNFLvEfU/F/f9D5A4h0NGnG4ulOswKUTU56JOLfeSx4M83YqeBxNtk3avQKQxbk1mVhrneKkBYxcldq5L6GO24wTWn9m6fHH6EQiPqw3PxBKuY3wR8esGeeK2+RUHWuVBYbig5aVEnCZ1dp9t3VvGyNoE6dBw1axSs4V9vnjAE4/6b0hLF30OjtKS4Qxy4pZaJggNCxv2xBniQP7ZGgYKNtDqCiNnpl2gFMxXZ9sm+tNiLGZWzomi9q3aYxX10c5ThlZpjGw/BSxGNRxOSR/ZMcX0U9zbNkPZlX9W1
 LoaEeWX3
 2FlFDRUDBlsUwowP6DOmHrFiA7fZO3ZvJPW0FWLYoWJdjFaa3FFeO76NfI0EVYpgDS0mpm+6oxVnjD222J6r4tVrvvJakdW+6IcWa0SIAwxObjaF4lUWcyQPjKjrlzj9TKRRQ9hEryf+/Xd4CUF1r6rdgjBbtOMJqAmHnPB23N5vX5U6kanBON7jh7x1PQjrD0myblbKGKoLF+BuHLen/uAsIyclqryWYF6FNvlRuOicKBvepnCGvlkyuN4bqz+3NudmVjju7w2+wep793qIQdYl5gINkEKTS3O7CLVe7cI/yedmAOuZk2wPnU7bGYHtEHgD2UvFtkBJ0B0wIs573tPHSozQL+y3ziqxIhGyhTKYls4yW5mNwUY3wHVWhHhMpCY2WgjHprfRuYxMz4URXk2iRNUFSCCYM3zaUQxbY3KMFwIT21flVkFSW4AGDWo2p9lMKZW0bSULx+8ZLNtzs6y3+iZhVP0gJvnMqOsXZZnMtsOj9gqpqfIh7qivzIaj4W8RskgUCiim+PPTgyLiWUUl7c6hgkLO4dWVOfWYGWzbuoJjXR/jVMHJYsQzhNvyvoqC3IB3A774bDiHVvDohv1oRjkWQWZDbczRnTdcIRRZLBDt7+TCLGJ2WhbL03iuvn5tBFD0bWJ3BMcH9317s9tO3oleOxxffcJeF7ClLJ5CWg2vn2GC9Ku/Y394fNw5e71MPVjmEWZKlBh4TxSBamjbXgC/cfupD4za5/Fvbt+0M26ogA4A6+6JoSZiMCb7sRH6ZSCt3aMUW5+u9c7dWnoDw9eCih4dnxshvlVkX177WCK53TIlNOuy+T45fltoPKY5SAaytby+KDdiaJtaNNXYQjTFSqW3tV18iiUv0Bt45XJ3sVZokI2JaaATphr4qY8rA7qa7lfCjM3si9ita0Lf1zQcU9iHzKrcZvXddNcMlTUjI3C0Q/tW5v40jCMmnNPv3tg6DHdXLrnt6a0qre3zUmGCY
 rVAjBBLk
 t/sGFS/tla0rJ0dytw6Ru2hv2mbAi+L5SB3ViOIOKOkk6bmYqfE8y9aTjbvL/NJd8gee1fDzK+sDWsdEFpDZgg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSW50ZWwtd2lyZWQtbGFu
IDxpbnRlbC13aXJlZC1sYW4tYm91bmNlc0Bvc3Vvc2wub3JnPiBPbiBCZWhhbGYNCj4gT2YgTWlr
ZSBSYXBvcG9ydCAoTWljcm9zb2Z0KQ0KPiBTZW50OiBXZWRuZXNkYXksIEp1bHkgMSwgMjAyNiAz
OjU3IFBNDQo+IFRvOiBBbmRyZXcgTHVubiA8YW5kcmV3K25ldGRldkBsdW5uLmNoPjsgRGF2aWQg
Uy4gTWlsbGVyDQo+IDxkYXZlbUBkYXZlbWxvZnQubmV0PjsgRXJpYyBEdW1hemV0IDxlZHVtYXpl
dEBnb29nbGUuY29tPjsgSmFrdWINCj4gS2ljaW5za2kgPGt1YmFAa2VybmVsLm9yZz47IE1hbmlz
aCBDaG9wcmEgPG1hbmlzaGNAbWFydmVsbC5jb20+OyBQYW9sbw0KPiBBYmVuaSA8cGFiZW5pQHJl
ZGhhdC5jb20+DQo+IENjOiBFZHdhcmQgQ3JlZSA8ZWNyZWUueGlsaW54QGdtYWlsLmNvbT47IEtp
dHN6ZWwsIFByemVteXNsYXcNCj4gPHByemVteXNsYXcua2l0c3plbEBpbnRlbC5jb20+OyBTdWRh
cnNhbmEgS2FsbHVydQ0KPiA8c2thbGx1cnVAbWFydmVsbC5jb20+OyBOZ3V5ZW4sIEFudGhvbnkg
TA0KPiA8YW50aG9ueS5sLm5ndXllbkBpbnRlbC5jb20+OyBNaWtlIFJhcG9wb3J0IDxycHB0QGtl
cm5lbC5vcmc+OyBpbnRlbC0NCj4gd2lyZWQtbGFuQGxpc3RzLm9zdW9zbC5vcmc7IGxpbnV4LWtl
cm5lbEB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LQ0KPiBtbUBrdmFjay5vcmc7IGxpbnV4LW5ldC1k
cml2ZXJzQGFtZC5jb207IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogW0ludGVs
LXdpcmVkLWxhbl0gW1BBVENIIDIvNF0gaWNlOiB1c2Uga3phbGxvYygpIHRvIGFsbG9jYXRlDQo+
IHN0YWdpbmcgYnVmZmVyIGZvciByZWFkaW5nIGZyb20gR05TUw0KPiANCj4gaWNlX2duc3NfcmVh
ZCgpIHVzZXMgZ2V0X3plcm9lZF9wYWdlKCkgdG8gIGFsbG9jYXRlIGEgc3RhZ2luZyBidWZmZXIN
Cj4gZm9yIHJlYWRpbmcgR05TUyBtb2R1bGUgZGF0YSB2aWEgSTJDIGJ1cy4NCj4gDQo+IFRoaXMg
YnVmZmVyIGNhbiBiZSBhbGxvY2F0ZWQgd2l0aCBrbWFsbG9jKCkgYXMgdGhlcmUncyBub3RoaW5n
IHNwZWNpYWwNCj4gYWJvdXQgaXQgdG8gZ28gZGlyZWN0bHkgdG8gdGhlIHBhZ2UgYWxsb2NhdG9y
Lg0KPiANCj4ga21hbGxvYygpIHByb3ZpZGVzIGEgYmV0dGVyIEFQSSB0aGF0IGRvZXMgbm90IHJl
cXVpcmUgdWdseSBjYXN0cyBhbmQNCj4ga2ZyZWUoKSBkb2VzIG5vdCBuZWVkIHRvIGtub3cgdGhl
IHNpemUgb2YgdGhlIGZyZWVkIG9iamVjdC4NCj4gDQo+IFBlcmZvcm1hbmNlIGRpZmZlcmVuY2Ug
YmV0d2VlbiBrbWFsbG9jKCkgYW5kIF9fZ2V0X2ZyZWVfcGFnZXMoKSBpcyBub3QNCj4gbWVhc3Vy
YWJsZSBhcyBib3RoIGFsbG9jYXRvcnMgdGFrZSBhbiBvYmplY3QvcGFnZSBmcm9tIGEgcGVyLUNQ
VSBsaXN0DQo+IGZvciBmYXN0IHBhdGggYWxsb2NhdGlvbnMuDQo+IA0KPiBGb3IgdGhlIHNsb3cg
cGF0aCB0aGUgcGVyZm9ybWFuY2UgaXMgYW55d2F5IGRldGVybWluZWQgYnkgdGhlIGFtb3VudA0K
PiBvZiByZWNsYWltIGludm9sdmVkIHJhdGhlciB0aGFuIGJ5IHdoYXQgYWxsb2NhdG9yIGlzIHVz
ZWQuDQo+IA0KPiBSZXBsYWNlIHVzZSBvZiBnZXRfemVyb2VkX3BhZ2UoKSB3aXRoIGt6YWxsb2Mo
KSBhbmQgZnJlZV9wYWdlKCkgd2l0aA0KPiBrZnJlZSgpLg0KPiANCj4gTGluazogaHR0cHM6Ly9s
b3JlLmtlcm5lbC5vcmcvYWxsLzYzNTQwNWU0LTk0MjMtNGEyNS1hNmU3LQ0KPiBlMDNjOGVhMGJj
YmVAcmVkaGF0LmNvbQ0KPiBTaWduZWQtb2ZmLWJ5OiBNaWtlIFJhcG9wb3J0IChNaWNyb3NvZnQp
IDxycHB0QGtlcm5lbC5vcmc+DQo+IC0tLQ0KPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwv
aWNlL2ljZV9nbnNzLmMgfCA1ICsrKy0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25z
KCspLCAyIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L2ludGVsL2ljZS9pY2VfZ25zcy5jDQo+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwv
aWNlL2ljZV9nbnNzLmMNCj4gaW5kZXggOGZkOTU0ZjFlYmQ2Li43ZDIxYzM0MTdiMGIgMTAwNjQ0
DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2ljZS9pY2VfZ25zcy5jDQo+ICsr
KyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2ljZS9pY2VfZ25zcy5jDQo+IEBAIC0yLDYg
KzIsNyBAQA0KPiAgLyogQ29weXJpZ2h0IChDKSAyMDIxLTIwMjIsIEludGVsIENvcnBvcmF0aW9u
LiAqLw0KPiANCj4gICNpbmNsdWRlICJpY2UuaCINCj4gKyNpbmNsdWRlIDxsaW51eC9zbGFiLmg+
DQo+ICAjaW5jbHVkZSAiaWNlX2xpYi5oIg0KPiANCj4gIC8qKg0KPiBAQCAtMTI0LDcgKzEyNSw3
IEBAIHN0YXRpYyB2b2lkIGljZV9nbnNzX3JlYWQoc3RydWN0IGt0aHJlYWRfd29yaw0KPiAqd29y
aykNCj4gDQo+ICAJZGF0YV9sZW4gPSBtaW5fdCh0eXBlb2YoZGF0YV9sZW4pLCBkYXRhX2xlbiwg
UEFHRV9TSVpFKTsNCj4gDQo+IC0JYnVmID0gKGNoYXIgKilnZXRfemVyb2VkX3BhZ2UoR0ZQX0tF
Uk5FTCk7DQo+ICsJYnVmID0ga3phbGxvYyhQQUdFX1NJWkUsIEdGUF9LRVJORUwpOw0KPiAgCWlm
ICghYnVmKSB7DQo+ICAJCWVyciA9IC1FTk9NRU07DQo+ICAJCWdvdG8gcmVxdWV1ZTsNCj4gQEAg
LTE1MSw3ICsxNTIsNyBAQCBzdGF0aWMgdm9pZCBpY2VfZ25zc19yZWFkKHN0cnVjdCBrdGhyZWFk
X3dvcmsNCj4gKndvcmspDQo+ICAJCQkgY291bnQsIGkpOw0KPiAgCWRlbGF5ID0gSUNFX0dOU1Nf
VElNRVJfREVMQVlfVElNRTsNCj4gIGZyZWVfYnVmOg0KPiAtCWZyZWVfcGFnZSgodW5zaWduZWQg
bG9uZylidWYpOw0KPiArCWtmcmVlKGJ1Zik7DQo+ICByZXF1ZXVlOg0KPiAgCWt0aHJlYWRfcXVl
dWVfZGVsYXllZF93b3JrKGduc3MtPmt3b3JrZXIsICZnbnNzLT5yZWFkX3dvcmssDQo+IGRlbGF5
KTsNCj4gIAlpZiAoZXJyKQ0KPiANCj4gLS0NCj4gMi41My4wDQoNClJldmlld2VkLWJ5OiBBbGVr
c2FuZHIgTG9rdGlvbm92IDxhbGVrc2FuZHIubG9rdGlvbm92QGludGVsLmNvbT4NCg==

