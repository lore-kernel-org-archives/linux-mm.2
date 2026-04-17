Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B68E6F43688
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 09:28:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 244A86B00C1; Fri, 17 Apr 2026 05:28:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F5316B00C3; Fri, 17 Apr 2026 05:28:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BC936B00C4; Fri, 17 Apr 2026 05:28:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E93536B00C1
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 05:28:52 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4A58A5C3D7
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 09:28:52 +0000 (UTC)
X-FDA: 84667523304.11.BB5D731
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1A76F40008
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 09:28:47 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=h4anjL6h;
	spf=pass (imf04.hostedemail.com: domain of yuan1.liu@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776418128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nf3ajfMtDryIsLzdq5bYiyW567SjEP0KBlw8qL2FOoc=;
	b=NcMe3u+5VKIdCJ69ODyc+P0PZXTYFlZefAfFtsCtZ/IiBC8iKZn/d9QWYgZWVp+arfc4SY
	0ah4RW1/b6kx+mrhhfxszOhrx42bhnP7z4tT3Utp98jKCBhEenFYQPfQLxon/8yy5CLnLe
	scAsxitFPyd4zXOsWG0VQyMA8Ms4wD8=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=h4anjL6h;
	spf=pass (imf04.hostedemail.com: domain of yuan1.liu@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776418128; a=rsa-sha256;
	cv=fail;
	b=p6bO3GAmt7yCymJ3e81tye0V9v52x5k+/wVhaAszoRR3rubpzfXnKb24LOpYj1G+n58iXv
	zS/CoIjb/Lj9ljn8xCOHjf+k5WBub2nN2svsJ2ChluMYsZnfwyRMFuimBtEYGuUeieZ0C/
	mgmq6A/bsjiAy96iYHGztbv6fXQtOaM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1776418128; x=1807954128;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=nf3ajfMtDryIsLzdq5bYiyW567SjEP0KBlw8qL2FOoc=;
  b=h4anjL6hdvz+TgPwQ1K+kfp/Um7cBjVMByxKe5JhiBZo/txxBM8PGMuv
   3wh3M9R81tFTESVXdant8oFpEfxKrpiL9w6kNYU/s0HHd76b269wo70MV
   N6iGrbTaPGfgl4U5Vv7DrdBukF2dJrkxqVC0/Y86kQZFwsqnyYGMEW7/s
   p9qDLlRheUFB2bp4yySczaGVNmrnxRCX7hyziphiOAJ6uSJcTMxGuh+31
   xAfJjYya3U0lLK/saYhtt4DnEOt2YEraTotjpZ8BtDZNg5vA8DHKa/GlO
   tRvl7on2e+CVywVQZbEfNek9IdzPkAMVv5hjweGLaBkx7hwxbQxzValek
   Q==;
X-CSE-ConnectionGUID: 6cR5kjLIRgynO7v8ZAWLrQ==
X-CSE-MsgGUID: FIfcBl8TQ9GNUwv4yCdVEw==
X-IronPort-AV: E=McAfee;i="6800,10657,11761"; a="80020385"
X-IronPort-AV: E=Sophos;i="6.23,184,1770624000"; 
   d="scan'208";a="80020385"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2026 02:28:47 -0700
X-CSE-ConnectionGUID: GAmeXiYZTqevX82w8PG3fw==
X-CSE-MsgGUID: bHNS7ghERruvp/fZ+lYTGQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,184,1770624000"; 
   d="scan'208";a="232737831"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2026 02:28:46 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 17 Apr 2026 02:28:46 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Fri, 17 Apr 2026 02:28:46 -0700
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.10) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 17 Apr 2026 02:28:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bAJCNkHohJQGauUSvwIQT9J65DUzuDZ8pN14pzLPesEP/SGqPnzPHb05myZLQ8YIJBcAWDJGIwHMN0iHYLsM9H41VXVNBzk/wBbEsqeDXEQKJcdjFSgWSSPD4RQe2QBrt0UttRZEVVup4CBzV228VJAIFu3wK1747yGQTg26iIeeJHttoER3f1zIOKm2sTnjhCrr5+mWEQp4foveYe2uYLfQMRTY2O52N8SPcXPp0SYyoOLnQp4Uz5Ov1TMHWVOQ/yd3/VCDoIcBqYEQifeqm17Jzwyj+F2rOXNgJuCxc68QKWPcur9C3RfPDJgLoRtM3uZx/ONwwZBBUHAqCg03gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nf3ajfMtDryIsLzdq5bYiyW567SjEP0KBlw8qL2FOoc=;
 b=TGG6ecN4W42Y5DxzX9Vp4gXHshSiKtiCvyb1CuXfnHC6UoJKoyl4YQ3BYJYoCYqWVLOj1yBktlz8xjDYe1+Fhw6ckYnopbVojAk9jqkRnGKQH2g2ETQyMIJu4v2qVoXTlh72NbgQk5ndNz7T7GrvMi7XPu8+GhPEvU7lBDZZIMJjEnUBwtPsEoWu/U8OhQiBv6vgySHy2aZFywQ+6ynSVT5NEVYZu6G3GnbT3aAQa98dQRsxpv82ph1809i+INhdOJQA+waz0lCoByEShzb/sBlcczXbuvW1bJqJMpY7oN4J9G4nMobKu/0YMK5lx+82/rmqOPQxuoeJdiUVCOJMEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB6936.namprd11.prod.outlook.com (2603:10b6:303:226::16)
 by DM4PR11MB6141.namprd11.prod.outlook.com (2603:10b6:8:b3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.25; Fri, 17 Apr
 2026 09:28:35 +0000
Received: from MW4PR11MB6936.namprd11.prod.outlook.com
 ([fe80::96dc:12ef:f56f:dd04]) by MW4PR11MB6936.namprd11.prod.outlook.com
 ([fe80::96dc:12ef:f56f:dd04%6]) with mapi id 15.20.9818.017; Fri, 17 Apr 2026
 09:28:34 +0000
From: "Liu, Yuan1" <yuan1.liu@intel.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, Mike Rapoport
	<rppt@kernel.org>
CC: Oscar Salvador <osalvador@suse.de>, Wei Yang <richard.weiyang@gmail.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "Hu, Yong" <yong.hu@intel.com>,
	"Zou, Nanhai" <nanhai.zou@intel.com>, Tim Chen <tim.c.chen@linux.intel.com>,
	"Zhuo, Qiuxu" <qiuxu.zhuo@intel.com>, "Chen, Yu C" <yu.c.chen@intel.com>,
	"Deng, Pan" <pan.deng@intel.com>, "Li, Tianyou" <tianyou.li@intel.com>, "Chen
 Zhang" <zhangchen.kidd@jd.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3] mm/memory hotplug/unplug: Optimize zone contiguous
 check when changing pfn range
Thread-Topic: [PATCH v3] mm/memory hotplug/unplug: Optimize zone contiguous
 check when changing pfn range
Thread-Index: AQHcxwYPPar5wabLkEWQfiO/Xde9s7XUxrUAgAIIwYCAAAfiAIAHUdTQgAAptoCABIITAIAALjWAgAAFCOA=
Date: Fri, 17 Apr 2026 09:28:34 +0000
Message-ID: <MW4PR11MB69368E21A959E35ED2D866D7A3202@MW4PR11MB6936.namprd11.prod.outlook.com>
References: <20260408031615.1831922-1-yuan1.liu@intel.com>
 <17b821b6-0176-43d5-92f7-fe2a0c4f70cf@kernel.org>
 <ade6RVeXxDt7ImP4@kernel.org>
 <e86fee84-08d8-4563-8596-e40d8e196799@kernel.org>
 <MW4PR11MB6936CA77BF02BF498BBEAB1CA3252@MW4PR11MB6936.namprd11.prod.outlook.com>
 <12b8ba83-54b1-454e-b787-2d2e967c9b58@kernel.org>
 <MW4PR11MB6936E593C865F4E855CED602A3202@MW4PR11MB6936.namprd11.prod.outlook.com>
 <c03d3d19-a2b2-4566-8922-661b92d06f95@kernel.org>
In-Reply-To: <c03d3d19-a2b2-4566-8922-661b92d06f95@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB6936:EE_|DM4PR11MB6141:EE_
x-ms-office365-filtering-correlation-id: 6dbb78b6-3ff7-47e3-c4d0-08de9c63b2d2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|56012099003|22082099003|18002099003|38070700021;
x-microsoft-antispam-message-info: 6OT6pfeSDmAEjD8RDYWgW7DqYRghHQ/1exi+oUJKrHZSH54kC2i+kXnp6Bn/OAkIOPjitTW2+fdwzNd7uV5oAm34ssK+NvZ0ZqZ6IRVj8Fmm0GYd/je+7f1fSzHEogKGn5muwsqo/81hmgd+p/Ox2dGtoxq+wKQTaEOg8BsLZeHazbCrX4NTVWtHnfagJReoCO7i33IaztVdAhzich4fAOQFZEzn/sflIk8M5JBKNrpDLxa2iUxpBXGALjPB5hTfDJwrpHbqhE43Xb3MC/vqux58XnSC4zSrKWwglaWoIPzVXKix+hREzXv+k84G8zo5muxZu5QzYcLlDBtBy0KThmRt2imT8IqImr/jyxVj1EXmSiDrYeGTMV4LqUFM/HdP3YUccKuV2iEwVwi7abiYI4yMjaqPuVy4D0AwSWd8aTDgw1CLzYWdMuHjTUNW/BUIrU/iK80w559cr7/UEIGvYjxlWkoFQiYjL4/neAiVYSajqIORcd9D4gNIPSw3dhqa2+82QNLN+b8XtlGmL2Tpf3lNnuW/umvjrwccKjol0QXSx10i9+SerNHoQ5KQPg2hQU7NuF6tYdkrPQ3EFknea/wE8IdeA60pQKh07rzQVZ1z5YMIiL8wzJqpsoMjPI9GKdoTvQO/N9Az3YrnnXXNN56SMYIMLYwofD0tqELU/hQU19NDzmtzGyGfst6hu7VDtIMNmLEqLBjOf/wx/C8mhWCpHvRqU9/XsPu2MUZ/B/n2xD+nrvoyYaUFhNUcdWe5Ct2rorKaDsYFNRIYgHYVNxPM4BlXrnQNaLkmnGX2aAU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB6936.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(56012099003)(22082099003)(18002099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aW9Kb2pNbVJzUkZjaUsxdnlyenc1UCtvL3h6c291bUR1b1N4bWFTUXhERVpH?=
 =?utf-8?B?Wk9WU00rdVNib1poZmJkTDRVcVBTQUZnRUNwaXF5cXBWS1o5Q2NyU294dDA5?=
 =?utf-8?B?MzFaV2dNSEcxS3BTZVowRmpDc0dyTERQaTk0ZjFlQVFlVUdJcTBYVUxnQWxi?=
 =?utf-8?B?QS8zcm9qOS9oZlFHcko4aFVVSWxuY2Y0dXFWU3ZPTUNmZmxtNFJTbmQrZ1lS?=
 =?utf-8?B?akpndHk0WVZlWWsxNXpBb2JHMnZsQ29yRE4zYkFxZWJZQ3VLbEFSUk5mYlJV?=
 =?utf-8?B?T015Lys3K1NQOVJ0K2hNcUFZQkI2K1NPNUY3R294a21TRkZ5M1liZ0hsbEpV?=
 =?utf-8?B?Z1EybTNleUw2RVNWNDh6b1kvd0RLUXdybkY4ZndXL2M5WlhMVmUrSlhsSzk3?=
 =?utf-8?B?a1hvb3RESmE4TUUwdEZwVkZSQmdwa0R1eGdMdEpaWEM3OEVxTkJBdnQ5aFhM?=
 =?utf-8?B?b1U2TGVZNkdYSDJpeHFDVDZicFN1eUpzWFQ1QlZNbWc5UytiMGt6NnlMcWIw?=
 =?utf-8?B?ekFQUWxEcEsveElMOEZjWDB1cVA4bHVYUy9lMGU2NERMU216ZlZoRURtZllx?=
 =?utf-8?B?RmQ3V1BraXhaVE1HeE5XUTZrVW1odEFGWm9vSHBnYkhuVzgzRlNhM1dEbzRQ?=
 =?utf-8?B?MXRaZHN1bWtoc2d6a2s4cWpVSHJnWTA4amxtOVU5eDF5OG5mSDlwRkcxbnM0?=
 =?utf-8?B?c21aaE5mc2o4ZzF1aUNyR2ExNm9CNHkvMXEyZ3MvYzRqQnVyQmtVYlJZRUxs?=
 =?utf-8?B?ZUY3ZlRXY215dzVpbTUrbWRla0E4WEtZUFFJUmxlWFd0cUhDSHpDclVoSGEw?=
 =?utf-8?B?UFE0Lzd2MkNoRzI2cEMyT2JQZkg2VGZZazZKSm00eW5UVEh1MUc5cEltZTA1?=
 =?utf-8?B?NGtRT1hUY1YwMUdIQnVFaElobkVtZ0VyRW5pbkZtN2JoaDZpNnV1Qmh3NUlp?=
 =?utf-8?B?NlpUTGxpYUtHMG1LcWQyL0h2MUMyeThhLzd3Wi8wMklTTWFJZ2gvT1hXSDFB?=
 =?utf-8?B?dkphZjUyckhSQVRFRmFVNDBVZVVhZWhOYmkyWTJucnhhOHJwVDRYd1NyZktB?=
 =?utf-8?B?Y3d5aGdLOXJSaEtDWHp1MnNQVWJQbFMwcDBVOW4zejJaekYxcyt5QkpHR1RD?=
 =?utf-8?B?T2VWR3k3SnBJMjk0aTB3MWQ1dlJudjQwOWxEdHcxSTRHTzR1VnhmMzhLUDlB?=
 =?utf-8?B?dVZmMUdWaWRVUTNrZm5aZjJIZWVtZ0RmYVRJS3NPaTVMVGNuVTlaVXliaVFq?=
 =?utf-8?B?c3EyRVNkT0Nob1dPZ25qUXJEeVlVS1FHL1QvQ281TXMyU252WHR3Mzg2cENm?=
 =?utf-8?B?c3FCQ2lmZUl1aVpLWmMwL05RcHZ6eXdEcytaaXdOcEliZFY1OGpEOExFeTVv?=
 =?utf-8?B?dGxWczM4dERXZk80VDRxUGR6SkZheDZPSlRRbjRVVms3WEJvTW0vYmZtdWUy?=
 =?utf-8?B?OGl5WHBOSjJNWnVmQXROK3pUK3YydDZXT2JFTUM1ZVN1WkwxTG1pQlB0OTRl?=
 =?utf-8?B?d05wb2x1UGZObjZpd1p5UmwxbnA1MFBkYjVGd3RoS0JBYkVOVU1mQjB6N0dy?=
 =?utf-8?B?emorWHlrRGo4WVZteWljUGoydXlERDlpS1FSR2lETWNGM2p1RngrNEN5VHBr?=
 =?utf-8?B?ckpzUmg3MGFkeGdHa1EwYlpHeEovR1VaTnBmcHc3cTNPNmVOUmEvVEw3Q0hl?=
 =?utf-8?B?NStZdm1qK3pXK3REL3ZmRXlLaTd6QjlxeUhXNmYvakk2bWI2MW1hTkdSN3Jr?=
 =?utf-8?B?S2xuWTlmak5sNkZYUStzdjdyYUpKUVIyRWl5Q09YOW1DdERoT09wNjFVaHRn?=
 =?utf-8?B?Rjc3aTFNVy8ycWFCT3VMUWo5L2x3MWl4SEQ3Ym55V3FpaHFtQjNwbnhpRHBG?=
 =?utf-8?B?M3hjWDE5TnVtVExIUUIxeVFDOUwyN0d3ck5qNnNmYS90OU5mcmpxOThTTlM1?=
 =?utf-8?B?NERWQWlVVmlzQWpSV3pLdFJFa2pwOHErdTBjdTcvWWpCV3oxM2d6MkFBeTNL?=
 =?utf-8?B?WlQzZ0ZJUzNjN0xpVzBhRUc4UlFUMnMvVnlxOFZIcStrSHhLenM2YUxUL3Rn?=
 =?utf-8?B?L1JFczZvVEU5eEQ2eFVWViswRm5FL3VmZWdGVmtaMUQxOCtpY3Rpczc5VTNR?=
 =?utf-8?B?cFRKRDlXZlZQdXNnRFQ5Smh1RlpCMWRrSXZGeU9IbXJvNEV6YUtsZXk0NGFQ?=
 =?utf-8?B?UlJUVVMweDFYNnl0eWZleVZQL3JDVXpUSEhacFRzSFAraTdmcXBoNXRBS25o?=
 =?utf-8?B?Mk1RTGs5cFdSRVZ0a2UxZURuUW1SN0lTV2NxeXRkaG84b283S0p5Y0R4RzR0?=
 =?utf-8?Q?QmuTcAdiZ/V7WCorXq?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: BwNJWNPHy3xvgrQNtep63ZZ80diSKsaEbMuxFkG+uPs5NusyCPA32XfuMPMOADK9S1k8vZ+rleqfjdFPA1UncrY8Yyi7m4hiNgGCeyHZ5XYucnV1mCbeyA4TZqqMLl2ih5UxZofbKF+P7vj/bTovb26M8bpSLFLwp47VzVubM2ZE+Tc6KtZR4nSSeLWJ8fLTZXD1023dkChenkCC7Ai9yIJWesjJAetfgx83gz7MSXxCutbAWNj2xqEgd2hA2+BLJTetjCkYrEXAeqYxrQ3s4PQom6evxUl27SlAHJebUG7LypPtz/ZodNC1b7K89jvJAVwl1EdnDk/PumE1MU33Ag==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB6936.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6dbb78b6-3ff7-47e3-c4d0-08de9c63b2d2
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Apr 2026 09:28:34.8724
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wWwWX4Q1PzquPUEBgukeYVtslEMy3XRgVaHfKGLBd9j+IfjwY5JOH28Oyh7GzaEPXAxERm/2qCmWEtdEeWTy0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6141
X-OriginatorOrg: intel.com
X-Stat-Signature: a7hsjdqpsm88h3h1ufppifond8knsip7
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1A76F40008
X-HE-Tag: 1776418127-142237
X-HE-Meta: U2FsdGVkX1+9p3Bx8OiS5ly182InldrOlv5NcJcJmjex+zVR2Kuu/a16snMavDp4NINaKk/zjEc9FFcRb6HnPfTIzF2VFfDk6t9v9PUfh0z7Uzxrf//6TF9a+c4SYIjwDbLUbsVk/Yncn/NiIDEKnZDRqqOi3UK7u383M+4U2lfz+Yk0zVkKgWINZv+baBRa/cAEFqJOFb6o2pVFsmSLZc6Gl+YfEvOUgE60qoGagyE2aGYook8REJ67JmJBgPX0hM41YvZFQJKYriyV8iMCaiW3InH1j1zn6GTq9Dvembkd4cLj8wX3OFnI7yLloU0nO8antddyH/0yzfCx1qvJC7I+2JIjRiEIP8i0BxYuw8C9t29JuZS0kJFtL9pdDYuveSh0PCuSdpM/v5vqtGWfypK/iZ4DJ7GBSQ3GeABGl0GsBiUsdvxpm5SaS1JHSSGkTtysk4wRL37IDwdkw8aTDnkPseh0uakfrokPm8EJ7Hxiujmuzba0ftbxjHIBjJ3uFS0cJa0GIXByK8e4UaRDridCsxY52VADjNNRTVAJTyA79gTDcxnuSBXUukqNw3kGRXJdhlATIOtKtWQRraB1I5PUwP3xvrhU2bL8o/jf2XYCMhGXZU34/kzP4K0EdRe+vvXWR9WF6+a5fyDJumWhtqIZWoyfikxCLgfaQpTHqfLx8MFgYmDhwYlNj3POhNi0QAWK+QVu3BUr34t6EIM1b32HegfD9xaQI5zAjV0ZpHCehNpXkyBlcHIzgfrs4eCsFkesnvgSRXyPH5bjCCIIZ+VFyTsvL3+nfwMMf4+rzABoVt3B3gdDrUQ9hq1UbYVOP5vGlgt2XdMV6IVy7QTM7dyi2CPfGFden9QScg9mIFLKMD+u5P8RuIjVytlH6nF48E/x98VLgFrO91gYa3Ej+UdpS4QPw00NejFXq8gDpF31vZInZ4xU5CSXjT0HU1vvxa015q52aVtCgWAGbSY
 1tM/kah4
 81jYSfhoRBK8QPPTC6r7hbTxC4asqCAvMQ3RIhd1nk8dkWc0u+1LSEX3pRn7BOKaqB8D2gGJtLCvUnTq+22M/XF7O2GzpFHoCuMF9E2lIqzBzgGMFYZA6LbLAjoqkFEsHVgL1Xyfm8bZmDwWicK0Mh3w9+pSO2+CfzbAbcyzj7EHwozMD+kiLC2EbCD71Nzk8+Ja8u5mROPxhSfIRfmlAfV6kYaexhmHHZp3HIXKUtWicviPNH89yxd24xWfCrC5la9ZHsEO10t/7uBUMzmVnHs/Ils59S/rBIcbI3Z710jnCwiw8vPBFZQsBvAWeszhFSOM4tGWUlE4vbMXcTjyLuyGSQD3wNgkqL7w5e8Z2PiL40zxPABvfE3xMlNkBn+tAwQnLuiXlpRrjCfd6+2KL+16niLViociymreFGg1cRkSkUJV9K7QmOkl5NbKXVEksYL8JCmNHtBBJ2Y3iSdhEZi4rm0WtxCptpX7zBG85o5Sk1r7KfxymdJbgDg480m5QPv+wWisp7EN1Kt4tarqX2YGFHxYWlCd7WCt7CQMVTN6IvfGc5L3QkdUWgGPFy7Qf1zbfgTHPnxG7z00Q07HAuxEdGdJQLYN4Si1m6NwKuklktM5Hyy4DRHZ5ByKDhaqRw9es8msSfpw5F3MSs/kfBNFp1k9EQlxz7rzJFhozjLdXmspNz/Li2kCFolHuNDYXJKnUu4zNxHFuEpJEwcWt1zITqJbIQdvmfkr6NzNgZz2Lm31l/LZ1iGhRX9c1UftIhE/Pn1+ArC26eBqHao+VnNoc7Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBEYXZpZCBIaWxkZW5icmFuZCAo
QXJtKSA8ZGF2aWRAa2VybmVsLm9yZz4NCj4gU2VudDogRnJpZGF5LCBBcHJpbCAxNywgMjAyNiA1
OjAwIFBNDQo+IFRvOiBMaXUsIFl1YW4xIDx5dWFuMS5saXVAaW50ZWwuY29tPjsgTWlrZSBSYXBv
cG9ydCA8cnBwdEBrZXJuZWwub3JnPg0KPiBDYzogT3NjYXIgU2FsdmFkb3IgPG9zYWx2YWRvckBz
dXNlLmRlPjsgV2VpIFlhbmcNCj4gPHJpY2hhcmQud2VpeWFuZ0BnbWFpbC5jb20+OyBsaW51eC1t
bUBrdmFjay5vcmc7IEh1LCBZb25nDQo+IDx5b25nLmh1QGludGVsLmNvbT47IFpvdSwgTmFuaGFp
IDxuYW5oYWkuem91QGludGVsLmNvbT47IFRpbSBDaGVuDQo+IDx0aW0uYy5jaGVuQGxpbnV4Lmlu
dGVsLmNvbT47IFpodW8sIFFpdXh1IDxxaXV4dS56aHVvQGludGVsLmNvbT47IENoZW4sIFl1DQo+
IEMgPHl1LmMuY2hlbkBpbnRlbC5jb20+OyBEZW5nLCBQYW4gPHBhbi5kZW5nQGludGVsLmNvbT47
IExpLCBUaWFueW91DQo+IDx0aWFueW91LmxpQGludGVsLmNvbT47IENoZW4gWmhhbmcgPHpoYW5n
Y2hlbi5raWRkQGpkLmNvbT47IGxpbnV4LQ0KPiBrZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+IFN1
YmplY3Q6IFJlOiBbUEFUQ0ggdjNdIG1tL21lbW9yeSBob3RwbHVnL3VucGx1ZzogT3B0aW1pemUg
em9uZSBjb250aWd1b3VzDQo+IGNoZWNrIHdoZW4gY2hhbmdpbmcgcGZuIHJhbmdlDQo+IA0KPiBP
biA0LzE3LzI2IDA4OjM0LCBMaXUsIFl1YW4xIHdyb3RlOg0KPiA+DQo+ID4+Pg0KPiA+Pj4gSGkg
RGF2aWQgJiBNaWtlDQo+ID4+Pg0KPiA+Pj4gSeKAmXZlIHNwZW50IHNvbWUgdGltZSB3b3JraW5n
IHRocm91Z2ggdGhlc2UgaXNzdWVzIHRvIGJldHRlciB1bmRlcnN0YW5kDQo+ID4+IHRoZW0uDQo+
ID4+PiBGb3IgdGhlIG92ZXJsYXBwaW5nIHBoeXNpY2FsIHNwYW5zKG1pcnJvcmVkIGtlcm5lbGNv
cmUpLCBzaG91bGQgSQ0KPiBhdm9pZA0KPiA+PiBjb3VudGluZw0KPiA+Pj4gb3ZlcmxhcF9tZW1t
YXBfaW5pdCBpbiBtZW1tYXBfaW5pdF9yYW5nZSBpbiB0aGUgbmV4dCB2ZXJzaW9uPw0KPiA+Pj4g
Rm9yIGV4YW1wbGUsIGNoYW5nZSBpdCBhcyBmb2xsb3dzOg0KPiA+Pj4NCj4gPj4+ICt1bnNpZ25l
ZCBsb25nIF9fbWVtaW5pdA0KPiA+Pj4gK21lbW1hcF9pbml0X3JhbmdlKHVuc2lnbmVkIGxvbmcg
c2l6ZSwgaW50IG5pZCwgdW5zaWduZWQgbG9uZyB6b25lLA0KPiA+Pj4gKyAgICAgICAgICAgICAg
IHVuc2lnbmVkIGxvbmcgc3RhcnRfcGZuLA0KPiA+Pj4gKyAgICAgICAgICAgICAgIHVuc2lnbmVk
IGxvbmcgem9uZV9lbmRfcGZuLA0KPiA+Pj4gICAgICAgICAgICAgICAgIGVudW0gbWVtaW5pdF9j
b250ZXh0IGNvbnRleHQsDQo+ID4+PiAgICAgICAgICAgICAgICAgc3RydWN0IHZtZW1fYWx0bWFw
ICphbHRtYXAsIGludCBtaWdyYXRldHlwZSwNCj4gPj4+ICAgICAgICAgICAgICAgICBib29sIGlz
b2xhdGVfcGFnZWJsb2NrKQ0KPiA+Pj4gIHsNCj4gPj4+ICAgICAgICAgdW5zaWduZWQgbG9uZyBw
Zm4sIGVuZF9wZm4gPSBzdGFydF9wZm4gKyBzaXplOw0KPiA+Pj4gKyAgICAgICB1bnNpZ25lZCBs
b25nIG5yX2luaXQgPSAwOw0KPiA+Pj4gICAgICAgICBzdHJ1Y3QgcGFnZSAqcGFnZTsNCj4gPj4+
DQo+ID4+PiAgICAgICAgIGlmIChoaWdoZXN0X21lbW1hcF9wZm4gPCBlbmRfcGZuIC0gMSkNCj4g
Pj4+IEBAIC04OTMsNyArODk3LDcgQEAgdm9pZCBfX21lbWluaXQgbWVtbWFwX2luaXRfcmFuZ2Uo
dW5zaWduZWQgbG9uZw0KPiBzaXplLA0KPiA+PiBpbnQgbmlkLCB1bnNpZ25lZCBsb25nIHpvbmUN
Cj4gPj4+ICAgICAgICAgaWYgKHpvbmUgPT0gWk9ORV9ERVZJQ0UpIHsNCj4gPj4+ICAgICAgICAg
ICAgICAgICBpZiAoIWFsdG1hcCkNCj4gPj4+IC0gICAgICAgICAgICAgICAgICAgICAgIHJldHVy
bjsNCj4gPj4+ICsgICAgICAgICAgICAgICAgICAgICAgIHJldHVybiAwOw0KPiA+Pj4NCj4gPj4+
ICAgICAgICAgICAgICAgICBpZiAoc3RhcnRfcGZuID09IGFsdG1hcC0+YmFzZV9wZm4pDQo+ID4+
PiAgICAgICAgICAgICAgICAgICAgICAgICBzdGFydF9wZm4gKz0gYWx0bWFwLT5yZXNlcnZlOw0K
PiA+Pj4gQEAgLTkxMSw2ICs5MTUsNyBAQCB2b2lkIF9fbWVtaW5pdCBtZW1tYXBfaW5pdF9yYW5n
ZSh1bnNpZ25lZCBsb25nDQo+IHNpemUsDQo+ID4+IGludCBuaWQsIHVuc2lnbmVkIGxvbmcgem9u
ZQ0KPiA+Pj4gICAgICAgICAgICAgICAgICAgICAgICAgaWYgKGRlZmVyX2luaXQobmlkLCBwZm4s
IHpvbmVfZW5kX3BmbikpIHsNCj4gPj4+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ZGVmZXJyZWRfc3RydWN0X3BhZ2VzID0gdHJ1ZTsNCj4gPj4+ICsgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgbnJfaW5pdCArPSBlbmRfcGZuIC0gcGZuOw0KPiA+Pg0KPiA+PiBJdCdzIGNv
bmZ1c2luZy4gQ291bGQgdGhlIHJlbWFpbmluZyByYW5nZSBhbHNvIGluY2x1ZGUgb3ZlcmxhcHBp
bmcNCj4gaW5pdHM/DQo+ID4+DQo+ID4+IE1heWJlIHRoZSB3aG9sZSAic2tpcCBvdmVybGFwcGlu
ZyBpbml0IiBzaG91bGQgYWN0dWFsbHkgYmUgaGFuZGxlZCBvbiBhDQo+ID4+IGhpZ2hlciBsZXZl
bD8NCj4gPj4NCj4gPj4gSSBndWVzcyB3ZSdkIHdhbnQgdG8gc2tpcCBhbnkgbWVtYmxvY2tfaXNf
bWlycm9yKHIpIHJlZ2lvbnMgZW50aXJlbHkuDQo+ID4+DQo+ID4+IEBNaWtlPw0KPiA+DQo+ID4g
SGkgTWlrZQ0KPiA+DQo+ID4gRGF2aWQgc3VnZ2VzdGVkIG1vdmluZyB0aGUgb3ZlcmxhcCBoYW5k
bGluZyB0byBhIGhpZ2hlciBsZXZlbCBhbmQNCj4gPiBza2lwcGluZyBtZW1ibG9ja19pc19taXJy
b3IoKSByZWdpb25zIGVudGlyZWx5LiBJIHRoaW5rIHRoaXMgbWFrZXMNCj4gc2Vuc2UuDQo+ID4N
Cj4gPiBXb3VsZCB0aGlzIHdvcmsgZm9yIHlvdSwgb3IgZG8geW91IGhhdmUgYSBkaWZmZXJlbnQg
cHJlZmVyZW5jZT8NCj4gDQo+IFdvdWxkIHRoYXQgYWxsb3cgZm9yIHJlbW92aW5nIG92ZXJsYXBf
bWVtbWFwX2luaXQoKSBlbnRpcmVseT8gVGhlIG1vcmUgSQ0KPiBsb29rIGF0IHRoYXQgZnVuY3Rp
b24sIHRoZSBtb3JlIEkgaGF0ZSBpdCB3aXRoIHBhc3Npb24gOkQNCg0KWWVzLCBJIHRoaW5rIG92
ZXJsYXBfbWVtbWFwX2luaXQgY2FuIGJlIHJlbW92ZWQsIHNpbmNlIHdlIG5vIGxvbmdlciBuZWVk
IHRvIA0KY2hlY2sgbWlycm9yIFBGTnMgaW4gbWVtbWFwX2luaXRfcmFuZ2UgYW5kIGluc3RlYWQg
Y2FuIGNoZWNrIG1pcnJvciByZWdpb25zDQpkaXJlY3RseQ0KDQo+IC0tDQo+IENoZWVycywNCj4g
DQo+IERhdmlkDQo=

