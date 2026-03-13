Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB669105F781
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 09:24:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C28C6B0088; Fri, 13 Mar 2026 05:24:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26CBE6B0089; Fri, 13 Mar 2026 05:24:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 145346B008A; Fri, 13 Mar 2026 05:24:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 032286B0088
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 05:24:30 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BF60D1A0872
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 09:24:29 +0000 (UTC)
X-FDA: 84540504258.18.0DF4E1C
Received: from TYVP286CU001.outbound.protection.outlook.com (mail-japaneastazon11011018.outbound.protection.outlook.com [52.101.125.18])
	by imf20.hostedemail.com (Postfix) with ESMTP id D1CCC1C0003
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 09:24:25 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=bp.renesas.com header.s=selector1 header.b="MFPWf/+L";
	spf=pass (imf20.hostedemail.com: domain of tommaso.merciai.xr@bp.renesas.com designates 52.101.125.18 as permitted sender) smtp.mailfrom=tommaso.merciai.xr@bp.renesas.com;
	dmarc=pass (policy=none) header.from=renesas.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773393867;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b08ig8157mSeMq+Nfkl2mx6KrX20363GFDTCLFHh15M=;
	b=krE8/8WfijTCICUTZ6I/IPu3pVNxkyctn672p9fKOBss+eirSLge8uFXCSMrCrIhNEYSk2
	+rboagdtFDY4cG3+xHCalqf99MzIQ748qJn3Eu6sxnK0eKxslEZO40Z6cI4Zs5QirGPREL
	gfi+GqHbtr7cZ4aaPH9XFJTCkOVNc5U=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=bp.renesas.com header.s=selector1 header.b="MFPWf/+L";
	spf=pass (imf20.hostedemail.com: domain of tommaso.merciai.xr@bp.renesas.com designates 52.101.125.18 as permitted sender) smtp.mailfrom=tommaso.merciai.xr@bp.renesas.com;
	dmarc=pass (policy=none) header.from=renesas.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773393867; a=rsa-sha256;
	cv=pass;
	b=DeuYi1PGDxgSrm94VzOyXevujpxxsk/nJs5cWmLclaDp2fpfjn6ZAH4+ZJL4hhoVCcqkiS
	e3JteC1v3Iv+qJKfBI5wZKAyAyXlGL85J+Z99WBxswKgt/CRafdBzpG2TsqhLoblZd8JtN
	BwPAN5gjKgd2vowwGcfB0e8zH4vorAU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r6lwrc2IsHdaPSbsq4WYIcGVs4xXU1kPfflkvTK6UI2yMgvp31lp5FQ6tpSLi38uXbAHxgQqGC+XnEdyTc74V4bnyEsDJbp93eRpzHb94zCOkNeZ3aEQLRQCwfhbYTKLMEBwAx4UE0G6sMd6h0vFGui0Z1yq8ZaYB+k859fNvPK/K9rcCmCztCQ/+QUmmR5JAxFitMF9VneOTqNn4PGUP2oHJGT13E0FSx4IAeLwY4irov8/WN8n/JeRpTBeuKoNVrCQjP6Wx8PITnryy1FyRYw42mywD8I7Pi91v/FIsj7kLl+QqxZ1un+mIW0SOdd3VhDq9+OxMU6pmTFQZ2xAMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b08ig8157mSeMq+Nfkl2mx6KrX20363GFDTCLFHh15M=;
 b=cIagmDxznNUhsaKdh525dxf+x6idp4x/f3jG1Vx+0BbIDB100Vm2NZoEw7vau96KAsWkmBPMocNhDbejSatdMaE1AVnX030cnWOTVmNXJZQPplcfqeVJZLXJ06nBpNfwBrtvv7vdtIW4FhbHkzY2SneQQ1+4rPhQ61eVa4TQAh1tWUsr46S2P5bYGA9+o2JxivHUs1bM+n81UySOrtdLJm/ehGntSU8FL6rjSbLBg/+nZq+WTQGusBbVvknFcyHNOuC6L0lDsdrf7aNyq9NuTN2AuCEwKmgWH7Of+jKmLhVJStH77IRa9Qw5AOWniM2F6EqTEgicKeU66xqH06L2MQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bp.renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b08ig8157mSeMq+Nfkl2mx6KrX20363GFDTCLFHh15M=;
 b=MFPWf/+L0y3xaBhKxKRauDh45WUvSQLlvV2CWZzeoE5EHB8n2V2q7IdLWtJhO0vuDpWwigR+HlgddbI1NJIn/jcSeJtPt+NF4FXiiWJ7aYJ4Hp859mzdS+K4vhEUF7G02N51MfgKtuNQsBzGDf8sBHimju31gzeD7AXPbTpb6K4=
Received: from TY3PR01MB11948.jpnprd01.prod.outlook.com (2603:1096:400:409::5)
 by TYYPR01MB12777.jpnprd01.prod.outlook.com (2603:1096:405:158::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.15; Fri, 13 Mar
 2026 09:24:10 +0000
Received: from TY3PR01MB11948.jpnprd01.prod.outlook.com
 ([fe80::b718:17d0:6c0f:1495]) by TY3PR01MB11948.jpnprd01.prod.outlook.com
 ([fe80::b718:17d0:6c0f:1495%6]) with mapi id 15.20.9700.015; Fri, 13 Mar 2026
 09:24:12 +0000
Message-ID: <a364ed87-aa63-4950-916d-682271cb5ff0@bp.renesas.com>
Date: Fri, 13 Mar 2026 10:24:08 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 5/6] drm/gem-shmem: Track folio accessed/dirty status
 in mmap
To: Thomas Zimmermann <tzimmermann@suse.de>,
 Biju Das <biju.das.jz@bp.renesas.com>
Cc: "boris.brezillon@collabora.com" <boris.brezillon@collabora.com>,
 "loic.molinari@collabora.com" <loic.molinari@collabora.com>,
 "willy@infradead.org" <willy@infradead.org>,
 "frank.binns@imgtec.com" <frank.binns@imgtec.com>,
 "matt.coster@imgtec.com" <matt.coster@imgtec.com>,
 "maarten.lankhorst@linux.intel.com" <maarten.lankhorst@linux.intel.com>,
 "mripard@kernel.org" <mripard@kernel.org>,
 "airlied@gmail.com" <airlied@gmail.com>, "simona@ffwll.ch"
 <simona@ffwll.ch>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
References: <20260227114509.165572-1-tzimmermann@suse.de>
 <20260227114509.165572-6-tzimmermann@suse.de> <abL5rcYIaFFO3GW2@tom-desktop>
 <TY3PR01MB113460CA616D3576DA0C3FC698644A@TY3PR01MB11346.jpnprd01.prod.outlook.com>
 <d3818663-2673-4de4-b483-557602f6e8b9@suse.de>
Content-Language: en-US
From: Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>
In-Reply-To: <d3818663-2673-4de4-b483-557602f6e8b9@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR0P281CA0069.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:49::22) To TY3PR01MB11948.jpnprd01.prod.outlook.com
 (2603:1096:400:409::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TY3PR01MB11948:EE_|TYYPR01MB12777:EE_
X-MS-Office365-Filtering-Correlation-Id: b647da94-233a-4ccd-e34b-08de80e249b2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	3g3zt8QeIDAQGsAduxTFTZzLX4sdp41dngVIVsryvdOgU7ELnJ6g/nKkBcifVY6MD68luVjX1nfU41rECHseRA4I8Aadjr/CY3YAFkToiB2qxdorBY+IqfJ8RJlFeIqJBCLxxsYH52deQqpRR3yyDNVe8EpmjWIJjNHoArIZgGZaC3Mn/AZjUEFWMYiT5h7Nj2kDKqk5RMd8KuG8aXtMMdRdJKBwCA0sh9AXQExRweAGhvlwmAoRvCxVq5t92TrEHLeS9G4DVyua2ZIUsxtGWxS2CgQjmZWrLkJwEDai8i5xvqLqGRQh5VtuZ7U7MISZgG8P371MUHaWJm5OgYEz9g6/nSplAAMrOE0/nMOtD/nraZ5hjxHmGIz4MdbeJ2BRunAo8ohb5vtK5Y/UbOEU6EvblzZ1nOg2rVbZMqLbHwfiBFK/jLFShI2CZdyJ5Eq2mmu3MT+eQY7PUdUzdZH/GlYOfRS1okS8wrH7AsX8X/+tnQDY94yv8Pok8LiiPvOOyHvdXN1diGlzbIYLJhUjyT/f8VRyVPT+4iDvtjWJ+rZAYRTtiYn+cNv7Rxx/Qyoof4/H5W3NX/wgctSJH2fVhI5SRUTjdPxtJUbvNIgXyeQikGC7iceialhsh8An28vMhfCYgGqvFVmDKHCRPzVdsyGLj0VYiw0yTv247c0n2glHCU3758m3s7rIYHhJP/L8bNwxsw5gmusv+KqkOISuj9FC9+UO3oV3V2gXpRXF7CA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY3PR01MB11948.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?amtyUzFtdU5wKzhBUThHNjdiVWhNczZudGM4aHpicGVpY0haTkllSGdUWk1D?=
 =?utf-8?B?aDF5M2FDdnUzR2JMakozYzZtSmphdW1NNnNqb2NteFg2OG1WdnhPRllTTTBJ?=
 =?utf-8?B?N29JTGF0TFJHQzY0eVh3UE45MlpwNFpoM1o5eTRJNE1zS1Y4dmxaTnFIYUdw?=
 =?utf-8?B?QUdqKzVDdm9yVHVYVGl4ek40NEdobm0zOUIzNElOM0FpaXZYTm9vZUwva0tF?=
 =?utf-8?B?SkhiMi9hM0s5MW14dWU0cXl4Mnh3dFhkVEdvYjRyQVY4Z2pYbDBDQVpNbWYr?=
 =?utf-8?B?TkhyL0RmN3MzSFJoL2hTeGJzeTdWZEExdDlTWkhDQncxZ1oyTjVWUkZNaEg5?=
 =?utf-8?B?eXppR1VVcVFRQy84RmxVYjdoVGVIY2FaZ3gwblU3RjUrWmF6MkF3NVZoamhX?=
 =?utf-8?B?UHFNMzFVTDFkWUJML3prS211ODdXd2FaRkxVZE9ubjJPUlFUQ1BqalpRMkpK?=
 =?utf-8?B?OGNzUkJBUTg1eloydllKQ05LRUplcEtVWEd5djZhaTNrREh5amMyeXdDd2tw?=
 =?utf-8?B?Q0lJN0RKdTlsTWQ2UUpsYWJVdmxxelRzM3dvTWlUU095UEdxYmQyQnNmem4v?=
 =?utf-8?B?WkVMTVhmTXpXUXd3MmlvRmpRWHd6aVhFRTQyVnpjYitlZUhRaHU5bCtTblVw?=
 =?utf-8?B?YXRTSFlFUHBaRjloTHJTL1lqTUJ4S3g5bFdoRUxPQ253UWM4Y1R3dE5ITnl6?=
 =?utf-8?B?Q3d6Ky9pWU1yOThNQ3hTYUVMQnd2dU9yLzhJUEdSL0t6cm1CbnA2UGREK0Fj?=
 =?utf-8?B?WHdPdHlxNEhmZ0YxUlpIQS9xZ3ZJUldobTJDZlhZNDdFSDZFL0R0cE8wbWp4?=
 =?utf-8?B?TVpiTGJCQk5CeGpmTXo1cFVucGs0ZWZJcHBxeUdILzk4Wk1INlREdmNjeEZq?=
 =?utf-8?B?RVExL0Z0SUZIZzE5Rm1VRGFrYTdhVER3WWhvVGpqZWZDSitjczgrd3Z2RzFu?=
 =?utf-8?B?NjgzUndVS3F6Vm42WjJZRFNIaHNCRk9DT2ZJaVVJaG1INzJpTWxZVWNWTEtL?=
 =?utf-8?B?K29VUjhvQmo5eTVSb0oxQ0F1M1hxbXptWTFWSGNrSlgwWFhmV0YwdmcyZmFa?=
 =?utf-8?B?b0E4dmNnQkt0bjJmdzZKNkxFYVMrTEV4YXBha3BuTHVYUG5JY3BCWm1PaktT?=
 =?utf-8?B?ajVvZDZoWWNObkY1d3N6QTRUSEVwQk9jSTBvNUw3U2FQTERXZDErd0p1SVdT?=
 =?utf-8?B?a0lIYUU2Q05kbDRDZjEzcW1KdjZRRHhoREt5RWdWblQranJHeDZyTmFaYUJ5?=
 =?utf-8?B?OXc2dEtUTlN3QlYwa05wL3BTM1NyTzVwR2x5ZW1Cc3kxNFdUMHgveWdsNFBQ?=
 =?utf-8?B?QWQxbnVQOXN3KzBzeTdtTWdHbHA0aFdXNFJOczAvRmZ5aFBDK3dVK3l1ZDlW?=
 =?utf-8?B?TnNNTGlaNUlRdWZ6bkhtN0xiTlQrSXJpTm1USkpVTDlNOEVtZXUwRko1Ukwv?=
 =?utf-8?B?UnJ0U0R6MVdCbzJubWRoS21UVTViNERHNjJBYnRncUs1dEZsUEZTNnYrMUtS?=
 =?utf-8?B?bjNmVkVsZisxRlgzKzkvREJ0TlpBOUlsSHNlQmJxaUFEY2E4V3lad096d0lZ?=
 =?utf-8?B?K2Q4TlJkbzM5WVBkcjd0cW5DMVN1WGdlRnl5RnNKS0F3UXBkSjlTZWlSb1VU?=
 =?utf-8?B?bVRUTWV1TG4rUDFmQVllZmV1QVNuRGVjTXc0ZjhHOS9nbmZKMXFocUx1OHpB?=
 =?utf-8?B?dXJUTDZ3aEFjci9qT3VycXllVE5RN2d0TkVwTVZTTmxmZG92VkFoZnF4blNI?=
 =?utf-8?B?ZkJOTm9XWVBvU2FRdnlUSDFvZDUxeTVNeC9OUy9xbk9mYUExdUlLSEF0eHVo?=
 =?utf-8?B?WjlhUFZ3YzErdWUxd2hjOS9SM2J0MHRCdnlGckdXWENyaGVjTmt5QzZlZ2l0?=
 =?utf-8?B?SlhhTDFwMnp6ZnZ5MlIrdklQLzVkTVNwcUJFTHdnYXduQ0RRZlcybGhXQUQ3?=
 =?utf-8?B?aWFMMkhPN24ydmNoSEU2elJIbXdaTko4bUZPQ3BNZ20rK3ZlSDNJRHNNWWRZ?=
 =?utf-8?B?ZmVEenNYeWU3eUhYQ011aHBFNkJhN2c5TzVKZXE0KzRXMWNUL2pKQUNqRkpi?=
 =?utf-8?B?eFlBNm9oUy9tc29OVW1FWHZsU1ZLcU1DWjhsK0pIbWxSOHludndUNXpubUFH?=
 =?utf-8?B?dS94bXNQelhRcTM5RmxRT1U3SDRvRjJVQUxsMlJhRGlrTGViVVk5Mm5FTFEy?=
 =?utf-8?B?WHRwdTdJakVobjhScFdmMEdIY0tVZWlXd09DUUlqNFV5MFFkaDRFOHhIMWxP?=
 =?utf-8?B?UUY5SUlGQ0hzbFZlY0t0ZVBTTWI5Ly9UaTZHTWYrUm5kZXE3SWVFYVoxejh0?=
 =?utf-8?B?UXdTMkdlbVNiQkEzb0JPclQwODBvVXp0MTdkSWZNVlhyVFQ5VHU3NE5XbHho?=
 =?utf-8?Q?OOAnGP9Jtb8ATTKAYmdEyrrHPNgAKeC8hD2vM?=
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b647da94-233a-4ccd-e34b-08de80e249b2
X-MS-Exchange-CrossTenant-AuthSource: TY3PR01MB11948.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2026 09:24:12.4287
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AMBK2M4rcM35ttCoxAKImMx7j8qXFYV0iRm86QyEVw0eutleiPbz+LHgtHnvzEL9GLF0kaElMADblOYAHriFhWhz3U3FrrS5wM7+LlEy6TfVeDKZoxE9YyapM4z29LMz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYYPR01MB12777
X-Rspamd-Queue-Id: D1CCC1C0003
X-Stat-Signature: e3rgy8uy8rs6khkmxyon7bwhfhoemojp
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773393865-103183
X-HE-Meta: U2FsdGVkX1/sChEv/k0dAJisWLbzWHUwB2HCQLQ0POYmOTqKUEn9AJNcH4SG81reVjcsNPMVIk+yhc0gOzm2LyaN5Nv9oRMBY8io2esRguBCF3g4fp/pdvix8x7Ml2t74YyeV9/A0daTTnlf5y7zJ9oRiOZ83kr+c2iPAqAQqEZFeXYMV7UBp68wxoGPi1Ugm5hiwPU3FQoXXUoVGn3CQmGvL6tnnuqh+39fWTl30AjVscuO0gvP3rpHwargz2hOpakqFRFVus4i3gZ/ApjAjHYm3j+sjYqVlAT6RBPGNsOlnwopvt7iUy09IqCB9bxsdf4hovstio0UYXlsyGEntIK6YUeGjfUc82tSsaL+U2KqWVStAxZv0qhUg+dPKAVtVPa1muLi1ySqiV+WGbArnWQ27++R6yTtQnwDsvJKQp64htnmxRqRgq0sAyPeGRkurKi2rYF1DQzka5Sn//3ZXdBCsNY6chm9U0ydtT+mSFQCgTWMoClFIsmw3u3a6YhVgSfJdiX7giv/Wy3L1u+8p2jw5h1djI/Osw9zufMphw6nu0yNcypIc+RS5kIE7fN/rGTFkbTxvocKq/iwKRc5KFPESkSZJ8PPbODLPG+3NXst+4LE6MUfDXc/iuKqWPizIYqj3T768YuhQ4/zKRm4i9A5A8q/ubuZlcOI0oMKSQuNILcambt5QTsnKBBgGH2jkIIJ1gvhLj1HpHl5G7h1i/KPGLTGANKNdl91WycGMYt1EqtpWiXVbvCXZZB72dJ+rAEN1oFhc+sqW+Ztl4BnjE63yB2V0gEPSzjtLLpkRhxbehpYm37bnNFknTKnaFm3WPvUGYFSCbwbu+IJ0iHyWtKZbmJaTMJGNeq+KnBXyCLPhrJ6YDIwtFF8tuVex1O7dom7wwji8PIySlAnUoExov/UBEzuj6cqyDW2zV/mrVQK8V6HmW4VOIUDlkk4gMpw4qCWfN/NRwr+3PDeri1
 QtsJHiNf
 hFKsmGJgPO0sYGflHNGmg+aJVhjZKXrlBPZpJJGtT5OzaYOpEzpSj7PRKi3bud3uflygv/lI4EFmpXdVN7j0UxZ5sK3Tmgvp9dTZvPQ1BEiksqNHMzEWNQJle9aCw9CfRFwIChi5wMHtp6F47QjRBj+EJZpP6ONqlZElpTLmHwYI0VUtooHXnXgaKlVamRh+YmePKO/x5mgEZ0ToY5QK2Z2/Zi6+D8AaEep5MSx9HXdaL498EDLZw4J6xBpl00wiq8QO34AkdYJBO1kQEVotdTTqFF8tcZ0MLGVHPZyfbYYhgs8rp6+61xWtBqAG0c8wk31ww2wJqca5iIHwBRyh2g3Ldvp3oZlR79ibmARxN1aGtsD7UCaZxrnAHR6jGj9a7NkX6NUeKJO9xL/iZal6YjC5+BeTNkywbjzo8kghwI79cmMbkreDekynNznXzaVBGjL7EZjwNv9dp1+S3CSTr2feHgElxzPETW8CdKTRvjvjLSIUuJVuDfRB44M5XYcer+oye8Mk5KEfZm5oQMjCf9dPkrwAhhk77q84r9aUVAhbawLsrzjyCTOsixBUox0uv64j+uDvLqou0N3KMECOrNbgyD13Wb2yTEjP3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Thomas,

On 3/13/26 09:33, Thomas Zimmermann wrote:
> Hi
> 
> Am 12.03.26 um 18:46 schrieb Biju Das:
>> Hi Tommaso,
>>
>>> -----Original Message-----
>>> From: Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>
>>> Sent: 12 March 2026 17:37
>>> Subject: Re: [PATCH v4 5/6] drm/gem-shmem: Track folio accessed/dirty 
>>> status in mmap
>>>
>>> Hi Thomas,
>>> Thanks for your patch.
>>>
>>> I'm working on DSI support for RZ/G3E from this morning rebasing on 
>>> top of next-20260311 I'm seeing
>>> that weston hang on my side:
>>>
>>> Reverting this patch fix the issue.
>>> (git revert 28e3918179aa)
> 
> Just a guess, but maybe vm_file is NULL. The attached patch should 
> handle this. Could either of you please test?

Same here, no luck.
Thanks for sharing.

Kind Regards,
Tommaso

> 
> Best regards
> Thomas
> 
> 
>>>
>>> I'm wondering if anyone encountered this issue?
>>> Thanks in advance.
>>
>> I am also seeing same issue on RZ/G3L with weston.
>>
>> Cheers,
>> Biju
>>
>>
>>
>>> Kind Regards,
>>> Tommaso
>>>
>>> On Fri, Feb 27, 2026 at 12:42:10PM +0100, Thomas Zimmermann wrote:
>>>> Invoke folio_mark_accessed() in mmap page faults to add the folio to
>>>> the memory manager's LRU list. Userspace invokes mmap to get the
>>>> memory for software rendering. Compositors do the same when creating
>>>> the final on-screen image, so keeping the pages in LRU makes sense.
>>>> Avoids paging out graphics buffers when under memory pressure.
>>>>
>>>> In pfn_mkwrite, further invoke the folio_mark_dirty() to add the folio
>>>> for writeback should the underlying file be paged out from system 
>>>> memory.
>>>> This rarely happens in practice, yet it would corrupt the buffer 
>>>> content.
>>>>
>>>> This has little effect on a system's hardware-accelerated rendering,
>>>> which only mmaps for an initial setup of textures, meshes, shaders, 
>>>> etc.
>>>>
>>>> v4:
>>>> - test for VM_FAULT_NOPAGE before marking folio as accessed (Boris)
>>>> - test page-array bounds in mkwrite handler (Boris)
>>>> v3:
>>>> - rewrite for VM_PFNMAP
>>>> v2:
>>>> - adapt to changes in drm_gem_shmem_try_mmap_pmd()
>>>>
>>>> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
>>>> Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
>>>> ---
>>>>   drivers/gpu/drm/drm_gem_shmem_helper.c | 22 ++++++++++++++++++++++
>>>>   1 file changed, 22 insertions(+)
>>>>
>>>> diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c
>>>> b/drivers/gpu/drm/drm_gem_shmem_helper.c
>>>> index cefa50eaf7a4..1ab2bbd3860c 100644
>>>> --- a/drivers/gpu/drm/drm_gem_shmem_helper.c
>>>> +++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
>>>> @@ -598,6 +598,9 @@ static vm_fault_t drm_gem_shmem_fault(struct 
>>>> vm_fault *vmf)
>>>>       if (ret != VM_FAULT_NOPAGE)
>>>>           ret = vmf_insert_pfn(vma, vmf->address, pfn);
>>>>
>>>> +    if (ret == VM_FAULT_NOPAGE)
>>>> +        folio_mark_accessed(folio);
>>>> +
>>>>   out:
>>>>       dma_resv_unlock(obj->resv);
>>>>
>>>> @@ -638,10 +641,29 @@ static void drm_gem_shmem_vm_close(struct 
>>>> vm_area_struct *vma)
>>>>       drm_gem_vm_close(vma);
>>>>   }
>>>>
>>>> +static vm_fault_t drm_gem_shmem_pfn_mkwrite(struct vm_fault *vmf) {
>>>> +    struct vm_area_struct *vma = vmf->vma;
>>>> +    struct drm_gem_object *obj = vma->vm_private_data;
>>>> +    struct drm_gem_shmem_object *shmem = to_drm_gem_shmem_obj(obj);
>>>> +    loff_t num_pages = obj->size >> PAGE_SHIFT;
>>>> +    pgoff_t page_offset = vmf->pgoff - vma->vm_pgoff; /* page offset
>>>> +within VMA */
>>>> +
>>>> +    if (drm_WARN_ON(obj->dev, !shmem->pages || page_offset >= 
>>>> num_pages))
>>>> +        return VM_FAULT_SIGBUS;
>>>> +
>>>> +    file_update_time(vma->vm_file);
>>>> +
>>>> +    folio_mark_dirty(page_folio(shmem->pages[page_offset]));
>>>> +
>>>> +    return 0;
>>>> +}
>>>> +
>>>>   const struct vm_operations_struct drm_gem_shmem_vm_ops = {
>>>>       .fault = drm_gem_shmem_fault,
>>>>       .open = drm_gem_shmem_vm_open,
>>>>       .close = drm_gem_shmem_vm_close,
>>>> +    .pfn_mkwrite = drm_gem_shmem_pfn_mkwrite,
>>>>   };
>>>>   EXPORT_SYMBOL_GPL(drm_gem_shmem_vm_ops);
>>>>
>>>> -- 
>>>> 2.52.0
>>>>
> 


