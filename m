Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A836FCB601
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 14:46:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 675876B0005; Fri,  6 Mar 2026 09:46:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 620856B0089; Fri,  6 Mar 2026 09:46:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E15A6B008A; Fri,  6 Mar 2026 09:46:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3CE526B0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 09:46:29 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DE8F759738
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 14:46:28 +0000 (UTC)
X-FDA: 84515914056.22.A1F5C57
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010058.outbound.protection.outlook.com [52.101.46.58])
	by imf22.hostedemail.com (Postfix) with ESMTP id 32BECC0003
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 14:46:25 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=QGE+19JU;
	spf=pass (imf22.hostedemail.com: domain of ziy@nvidia.com designates 52.101.46.58 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772808386;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MP0FegGoTq1iZv6LVh5iqUid7FONXHDFWOT2EN8jwWQ=;
	b=Ql5zJ5KuZMzs67hjHCiMMoCIjcKIoC24Z6hp8qfu5kQiBIwsVNqRCfeK3HmdIkiF/4y52o
	gqHtNYowkzz6JELdRZa1Vo9CBCFKv0qaThksxwHlzWC80mrC4kNlSDQbLe/O4RUIE3iHK9
	4C62dFw2W2OcA+V18zAuKSryFBbmD9g=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772808386; a=rsa-sha256;
	cv=pass;
	b=z4mSSY7U5ThiSZfXXUTmf6ztSoRnGEW0O69X/cEQg25k1Wvvkl+SabZxmXVEiK7AfrlhK3
	wjBbYBbLpCwUwckxrsgkHB5xdskEa57gOf/8/cgFdJ9ElXgtGs6dNIM4EgZhUi9vsjQDIO
	5oFvMSEY6JyHfmTvnMIEK4t2EQSSsyA=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=QGE+19JU;
	spf=pass (imf22.hostedemail.com: domain of ziy@nvidia.com designates 52.101.46.58 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pYAyyQB/TE5lRLt/kP4mNIFw7yyyzsHI8zh975TJfNhr29yIRU9W5AxYJVBqOjn/OJFYTTkMm99ieP1uxK7uTmNZFgQHL4eVZXbTTP/U3qVQUYc+ZZQol7tVtolzRs3Qf+4OMDcfg5MBRiXb2zddaLduCyXE4fbfl7rEkVnwTdW0K3tV8MpntPIwALcTrK72rNHBKVuACKM+i1uaz/GIkgbrDMD6A+D/Oj95HDzK5wZaQbY0qyJO1jkf+1sMbcrgKNiZqDEWBI+ogHtRictIloKYjP45oxohFJ9leauus+xyQpuaxNJvaKrVeecv1ft/ccFSs07guRzKzo7PvNzeLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MP0FegGoTq1iZv6LVh5iqUid7FONXHDFWOT2EN8jwWQ=;
 b=zMK2hTuyIUuLD4aGU43kbgRfskOyCcoPGrvITbSzM6mez1OyrV2eYmRFevnbt35U9tc30nEPeHJ6/1RwV6W++TSI7I6rUCR7jjqyxYV5rx7LOgLiMjLOcnryxrCaqTAnHBn38Yn4xceK/qXvXbqfL245bGuMRtluUv5jS/t95C0zelIAHrtuJFwYauE3vJ+MTYCrJ10OhD6rzcRZsrwTQBsBxBLSMCJ7VgYWRIeo0msbglGFIPS1GKez7YSOfP5rh4yBwnlriF1F1+GpcIO0vsM1qxV/dRyGmB02dEAQfeO2Hu9LxySAfh9qQ/KiKbhbypBO4TG1tbLEQigGWlruqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MP0FegGoTq1iZv6LVh5iqUid7FONXHDFWOT2EN8jwWQ=;
 b=QGE+19JUWAjt4QiytrIaEmWNoupRTq7FuWksa/PuJcaUe8muHJ3/l/xHoRDiEKI7iVlZAqzG0rvUX71RN6bDX/cevPeSXRQeyh3ikpyJWNNVOOqfTY1pL73w0KyboKSljg4+iKGENwDZ2sNwBNNUtpIq0y+XvSEXHl3nB9jb3R/pSRJinwfOUd1WiZpfO5sfmB/1GxC4Y7EZH99WMF+KrZ0OvIXIPUg2SgSXpth5jg6ks1m+z6efS2al3EPCDyNMDGp7fMXV2+sYScfC02Bzw7XtmSdTPc5SpLNPnkOfA1ZgTze4Nh8OM6k8vCQj++8O4DBK3y1ZoEQ2hTL7fJ9UOQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS7PR12MB6238.namprd12.prod.outlook.com (2603:10b6:8:96::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9700.6; Fri, 6 Mar 2026 14:46:20 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9654.022; Fri, 6 Mar 2026
 14:46:20 +0000
From: Zi Yan <ziy@nvidia.com>
To: Usama Arif <usama.arif@linux.dev>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, npache@redhat.com,
 linux-mm@kvack.org, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 hannes@cmpxchg.org, rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
 ying.huang@linux.alibaba.com, apopple@nvidia.com,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm: migrate: requeue destination folio on deferred split
 queue
Date: Fri, 06 Mar 2026 09:46:15 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <993B37FF-29E1-41F5-A1E8-F38B9CD24478@nvidia.com>
In-Reply-To: <64051a59-680f-40ae-b291-b884aeb7c77b@linux.dev>
References: <20260306133556.2051251-1-usama.arif@linux.dev>
 <ab22e50d-3af0-4acd-9d7a-a0e86d0c4fbe@kernel.org>
 <64051a59-680f-40ae-b291-b884aeb7c77b@linux.dev>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BY3PR05CA0005.namprd05.prod.outlook.com
 (2603:10b6:a03:254::10) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS7PR12MB6238:EE_
X-MS-Office365-Filtering-Correlation-Id: 86a78b33-0c93-4e98-d977-08de7b8f210e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	3tC7UmV5k3hmTcUo5An8AS5kpjELUaYwcx4R6TpsWTf7G92Kkj5LdGN28yc5FuArXlA9gbGwQM+zKvwHKW4Z7aZx9FTYdFIZrE8T/gna7V3Q+L5i4aUckF5PbC1zyRX0WmLIvPI0P6MudDQTPBTZvwOEeGv2XhoFKQwvrozC08kgQe16JYkXJSKFHP01fhXseyZv8n/mu5cAAcAEe+O+QDz0KKHgbzXLb8FRAjWGuQQQpHtzASNQ2YUMxWaaq3+GlxUFzZ3x+ftD7mTH91HjDVwPzSbJ0Yah+RB9gGJu1mku6/dadSfiaK2m0n4bAxeBKGYxQHFt0VOLYIBj3mneTuaS5hASkDJxM4jZ1Yp9HSHrgYmI8zdCSQAipLsqQOdh0OYuDYN4ekkb/5D0ztcOIedolgMyt+ObYxcxahugMZdGdWASJ3UQ5OkZfldjz5liq1iqDzTKI3NtY528KNZUvGRe66+Ut4G9vl+wq+1Wg+Fn7DLgMDW9PrZIQlnQaxT285MOUfcdkcQRoscgb7cHdQDKnGj7jMERmZaHyW0nzW8rlDxI8Yhw9NX0gIcr3kuHNEx8bWpYGJmDB47BysoNq46SUCxUoLau02sMHwkVR53a3/KkCZqPayatwsjR9DS0FKNZcz9ndyQvUEMgp5L3oVATzXDK6NzxQwgPV9G3hgZwGgm2zYcm0eimp8NgSh9i2P+1cq0Zr2EVqsbwUXRbephPwJ94dxu1CovlkCEB2xU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zvcIdEX2vto/AE0WSLdejZ1icxAY7MrslFhmwU+q49yBXKBEIN4BGcSiK6lK?=
 =?us-ascii?Q?qTrsm7q69LLF8ivo2wJ2px637BgXG75rN9kQhYuQxPkkCX7aTv1kDGazjAlu?=
 =?us-ascii?Q?BOP+0p87j8S0Rm6sh3mN2vuaF1Af+aGIU1k0Trziv+Mn9jMeVwwE3k2UFGlB?=
 =?us-ascii?Q?g0VNeaXeJ1n9bF8eWeZCRMOkNUDRvsGNjItrZeNY3ooqRDaI8GNLDVszuDOF?=
 =?us-ascii?Q?F+8AKFIVYER15OvxD101ChgrHOaltb8Y0ZhssrFE8L2bi8a0igzNpRkZMrsx?=
 =?us-ascii?Q?q33WC5HMEmamTWl3sXpfa318wm2lCNeTMOqVqe7ivs0wWqkk6C10vpiZ18Y+?=
 =?us-ascii?Q?6R1GG2m9Y6zSEXsdaJ9yBSD2RqVB1/iwK4iukyHcpDVh4OaKRlxBQjxtylkP?=
 =?us-ascii?Q?wdveVbQplsK8Lq+c+KkyMn+ONBsqJF1XJGyu/POOAUDAjpHykPe0+UzYLqYP?=
 =?us-ascii?Q?mMp8oSSTZhszd1qO++f+GdNbczQYsZstiraDj0u/lBK5kq9D3i+boQ88woGb?=
 =?us-ascii?Q?/tf+IUMTydCS0FDN29nJontf4oXLkP/vDMGxnnbzVwCYCovA85Iyt0dncj+e?=
 =?us-ascii?Q?89ONLMTRQ6XWJkE0fANQIfXuYVIQZjh+dH23oOXA7Js99/fXhhJAHXbOmvnS?=
 =?us-ascii?Q?yZc2SccXDupUv53uW9PztJqWRAoOSLkDk7lN+mAR19JSWncEf+HITPDu+KqC?=
 =?us-ascii?Q?qpOzQiO8h6SexmN2SX3WIZsJz7JE0p4+oIwQj/aysKegrkXXI1EivRpVLyMb?=
 =?us-ascii?Q?DQYMvCetvyB3ScCDMc9yQNvGd0Ba9O1AAOGmdyociMXksTp3BHwNlE10pjQf?=
 =?us-ascii?Q?gfIfB0S/jBHawrgZ1ZcJuNyQ4xpTXjdaqIC0eQAqvvGnNLftDeQj1ITn4VVu?=
 =?us-ascii?Q?CB7She44HuVndWV7xv1pdjM+qo8hUT9ZsXzamayygCDZ/UuEQh73ed/+ss1G?=
 =?us-ascii?Q?O2tJiQr1RKSzfx/jXcjxQ8W2WcUtb3ZJhZYlcjIgwP9vp8Pd6Nqu1gVRjlJI?=
 =?us-ascii?Q?CBVd9BkV5Q5Z5U9FFz9S4kNDkJABUbyM4BY+Nk4SRY0SfbGAHJYkFD6D8PS5?=
 =?us-ascii?Q?/t4k/ssp+yspIj1HP5247m4Vb6QgVmqgU1rrgt9BZoaaIxOsluI1C0hov/Im?=
 =?us-ascii?Q?6Wocf4dETemOvafT5qc1j/jm7B8qQrfpD13ENY3BiY9I3FHMNGqJu0VpqLuS?=
 =?us-ascii?Q?F405vQ0v38FsSg42ccdIPzkxbB3sb8UWIncvsm6HtzqX24mgfM/FRU8Mvg/N?=
 =?us-ascii?Q?2b75WD9bPCbPge7fZRvbxH/RkHiq496dQ9F5lrtHycw4WMkp/nnbOuYyA7om?=
 =?us-ascii?Q?DXf+AN8OqC7rVJOCXGjcXUJ+f5xgJU/nTu33GY30UMgpgKowf4pX6mtGampo?=
 =?us-ascii?Q?c3T8U+i9xsLEVvlWeHjzKaOs1ZwDR9xXsCGtCbYr+SdEpEJWV/+ynOGsZ5eD?=
 =?us-ascii?Q?PqiSh9pKlORVn0PdUys6zWIjGZt6Iw1n1P128V/2OPUC60OibZ1hEO/eBZON?=
 =?us-ascii?Q?2V49aJfaMCidlDaioXIeaoxzRTvkk2v6Y9jXIlCdRrl+yCrh6ZJWvStf4A/t?=
 =?us-ascii?Q?aGwGuR18XuORpKtjMNdzCZb/q9AAOuofStXJkDiLIv5NbaFCQkS4Y4z2P8or?=
 =?us-ascii?Q?psekADXmTKSErrskUtOJDGZ/B6WqyPCfcvBF05T9VT7cJPG2P6/dL8mWxNBy?=
 =?us-ascii?Q?r9p8X8mHH7eSeC+yJ1UTS0IDE3BDivNSqsTtox867Evr4zbW?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86a78b33-0c93-4e98-d977-08de7b8f210e
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2026 14:46:20.0592
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J800b1v6TizBUQNH4viEB+32O3NZ0gyZq8T9gDSTkXAbfLdKtQzys7e/cDEI9et3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6238
X-Stat-Signature: dzomj7addu9d74tt78jggk84wtb751xi
X-Rspam-User: 
X-Rspamd-Queue-Id: 32BECC0003
X-Rspamd-Server: rspam12
X-HE-Tag: 1772808385-254031
X-HE-Meta: U2FsdGVkX18Aull/II83rqw2nvGnmKGyQPgESQATPojpsWr3qw5TseWfGJ6qOuWgyvtYRfhvHBqVc1e5Wqj7WxYP1JMZzta/HLPPEVqDO3DJMlVz6R9i1YDvZkKl32zGu931oiyeMD0cOmDn5d8ZRtZ0IckbP1DKexZ5P0VnOZ84mOlNcqS8kSOTpDdb2GIhFglYpWbbdqWKqImRVUF4Esixs8JtpOiOOJCXOe2rX9QVnmundkeAlaN9RSJx309haOf129wQ6WdRMmy17y9a/I62OdwZEjaciFsj3sN7Pjh8Ztv60vOQYgzwmqsyGLMwqmbUg5xiUTvk5/fuH88HCRhgRtj3cJ1Y5aGLeUtOolPdBW7Fbv/ybYq0GEj3khL9nOMgruK0Zi7R/WFMIFDukbFmuAKfVekKiPopryspQQd3Ef+gZA0Ffb1TLdZq9BSmkN7/d2FEYX/p46Sy0/XAe7MknuD2yH5hm+lJl+sofCUsSHEgAPgvWii2pG5dsQGvIqKmkF07DYbygwcRAU+2Y/NfSinFZijvibsg9SJtQKFw2ZM79FiiSoAC+MhdRxWhMGf0AIgul3ZMFGOFMGkiXowEVQbTpZ37p8aeviB98xzJ1y1gTY1VReNMGUCD7ohw+f+KS2Esu33MKy1KIk+PGG8LgmbPTOixA4zIy2z9akY5YMhDzKZZT+KNICR8Y+/uDPyeLLmQCsJmEk4pVxIvTBDXhY8feB6MUYQz1zc2cSfn8gMNF1x8uAP5arR55r1xYV86HXytiBO7cvfYVoowMg7RbRmlMNLr1ZeGkd4AUOgBu+0onUiaPcXJv7YHu1wWHNkdHD34RX1uLXSuU7NTx3EG28n8Nh8WmxS8mIpo7UPkferR3zu4tBE43bH8qIuk0IezofSceGj0Z/jBvcmXvgilRF2F7jWiG1yuess26RmFgngOnRc8DP9FTrNUAd628omVHYcuI/7RNeEJGdB
 MN1mEiwK
 lN7rQKc/s5xNO2W5p2QDZN17b2DS+V18gV+Y3bvvBXYeW5RI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6 Mar 2026, at 9:12, Usama Arif wrote:

> On 06/03/2026 13:49, David Hildenbrand (Arm) wrote:
>> On 3/6/26 14:35, Usama Arif wrote:
>>> During folio migration, __folio_migrate_mapping() removes the source
>>> folio from the deferred split queue, but the destination folio is nev=
er
>>> re-queued.  This causes underutilized THPs to escape the shrinker aft=
er
>>> NUMA migration, since they silently drop off the deferred split list.=

>>>
>>> Fix this by calling deferred_split_folio() on the destination folio
>>> after a successful migration, for large rmappable folios.
>>>
>>> Reported-by: Johannes Weiner <hannes@cmpxchg.org>
>>> Fixes: dafff3f4c850 ("mm: split underused THPs")
>>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
>>> ---
>>>  mm/migrate.c | 11 +++++++++++
>>>  1 file changed, 11 insertions(+)
>>>
>>> diff --git a/mm/migrate.c b/mm/migrate.c
>>> index ece77ccb2ec0..98d0a594f7b7 100644
>>> --- a/mm/migrate.c
>>> +++ b/mm/migrate.c
>>> @@ -1393,6 +1393,17 @@ static int migrate_folio_move(free_folio_t put=
_new_folio, unsigned long private,
>>>  	if (old_page_state & PAGE_WAS_MAPPED)
>>>  		remove_migration_ptes(src, dst, 0);
>>>
>>> +	/*
>>> +	 * Requeue the destination folio on the deferred split queue if
>>> +	 * the source was a large folio that was on the queue. Without
>>> +	 * this, NUMA migration causes underutilized THPs to escape
>>> +	 * the shrinker since the source is unqueued in
>>> +	 * __folio_migrate_mapping() and the destination is never
>>> +	 * re-queued.
>>> +	 */
>>> +	if (folio_test_large(dst) && folio_test_large_rmappable(dst))
>>> +		deferred_split_folio(dst, false);
>>
>> Doesn't that mean that you will readd any large folios, even if alread=
y
>> previously taken off the list after scanning?
>>
>> So I am not sure if your "if the source was a large folio that was on
>> the queue." comment is accurate?
>>
>
> Yes you are right. How about something like below? We also won't need t=
o check
> for anon and non-device folios with this as we only set the the flag if=
 it was
> already on deferred_split list.

BTW, migrate_pages() tries to split partially mapped folios before migrat=
ion[1],
so what remains in the deferred_list would be:

1. partially mapped but with a pin,
2. fully mapped but potentially underused.

I wonder if you want to do an underused scan before migration and try to =
split
underused THPs. Or to avoid this additional scan, find a way of detecting=

zero pages at page copy time and split it after migration.

Anyway, it seems that all large folios are in this deferred_list. Maybe, =
like
David suggested in his LSFMM proposal, we should scan large folios on LRU=
 lists
at reclaim time instead, since there is not much difference between defer=
red_list
and LRU lists right now.


[1] https://elixir.bootlin.com/linux/v6.19.3/source/mm/migrate.c#L1840

>
>
> diff --git a/mm/migrate.c b/mm/migrate.c
> index ece77ccb2ec0..9e0780d380e4 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -1137,7 +1137,9 @@ static int move_to_new_folio(struct folio *dst, s=
truct folio *src,
>  enum {
>         PAGE_WAS_MAPPED =3D BIT(0),
>         PAGE_WAS_MLOCKED =3D BIT(1),
> -       PAGE_OLD_STATES =3D PAGE_WAS_MAPPED | PAGE_WAS_MLOCKED,
> +       PAGE_WAS_ON_DEFERRED_SPLIT =3D BIT(2),
> +       PAGE_OLD_STATES =3D PAGE_WAS_MAPPED | PAGE_WAS_MLOCKED |
> +                         PAGE_WAS_ON_DEFERRED_SPLIT,
>  };
>
>  static void __migrate_folio_record(struct folio *dst,
> @@ -1373,6 +1375,15 @@ static int migrate_folio_move(free_folio_t put_n=
ew_folio, unsigned long private,
>                 goto out_unlock_both;
>         }
>
> +       /*
> +        * Record whether the source folio is on the deferred split que=
ue
> +        * before move_to_new_folio(), which unqueues it via
> +        * __folio_migrate_mapping().
> +        */
> +       if (folio_test_large(src) && folio_test_large_rmappable(src) &&=

> +           !data_race(list_empty(&src->_deferred_list)))
> +               old_page_state |=3D PAGE_WAS_ON_DEFERRED_SPLIT;
> +
>         rc =3D move_to_new_folio(dst, src, mode);
>         if (rc)
>                 goto out;
> @@ -1393,6 +1404,15 @@ static int migrate_folio_move(free_folio_t put_n=
ew_folio, unsigned long private,
>         if (old_page_state & PAGE_WAS_MAPPED)
>                 remove_migration_ptes(src, dst, 0);
>
> +       /*
> +        * Requeue the destination folio on the deferred split queue if=

> +        * the source was on the queue.  The source is unqueued in
> +        * __folio_migrate_mapping(), so we record and check the state
> +        * from before move_to_new_folio().
> +        */
> +       if (old_page_state & PAGE_WAS_ON_DEFERRED_SPLIT)
> +               deferred_split_folio(dst, false);
> +
>  out_unlock_both:
>         folio_unlock(dst);
>         folio_set_owner_migrate_reason(dst, reason);


Best Regards,
Yan, Zi

