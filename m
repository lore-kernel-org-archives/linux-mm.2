Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FFE8CA0ED1
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 02:39:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08D94900202; Thu, 14 Aug 2025 22:39:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 037218E0002; Thu, 14 Aug 2025 22:39:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1A05900202; Thu, 14 Aug 2025 22:39:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CCF188E0002
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 22:39:41 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 97103118035
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 02:39:41 +0000 (UTC)
X-FDA: 83777436162.14.6BDD08E
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2051.outbound.protection.outlook.com [40.107.93.51])
	by imf13.hostedemail.com (Postfix) with ESMTP id F34AC20007
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 02:39:38 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=f3qfeROV;
	spf=pass (imf13.hostedemail.com: domain of ziy@nvidia.com designates 40.107.93.51 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755225579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=xCH+3Od6gG40rhYmdgxiFcELqny9TrBc/9c9su4QEU0=;
	b=7Lawv7fnFOqqzuH8qCCVp6MhzUjGJGDn+EL508SmAOTQPa5++DfkRO/f1G+NqEVof5dw8b
	FowQ7Jov/ghJSqSMpwHwNZxHE7ia5a404pz587Rt9i3F4UuhqnxPsP0SVhXjaPYF7gb5I/
	j29bke+YYrXyxcQZz9nMfmqHTJRgzHk=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=f3qfeROV;
	spf=pass (imf13.hostedemail.com: domain of ziy@nvidia.com designates 40.107.93.51 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755225579; a=rsa-sha256;
	cv=pass;
	b=iMope7y7i6S2dZ0JmUJkIVIHdx4Q7bTGWOf7y2Bz1Kqa8ys4vYg5EmicABTyUEzjCl95xE
	PczXRFshcj41kNDQdgAiPReZi1Ov34K1Z0po/g7y0xgkZ4tVabos4vI4Dxudc2f4htgAVR
	fvruAlD0yRI6+yFpRnWVIcUvg9AwZwE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=at7CaVE9RsTb8oKHDlWII07cThlLrA7OQ9kn/SO08WXw2Tl7uwPHUC96nij3VogGCUVc8alpTY8tKE1GupV3yRKtFsZ4O5Jb9T3TS5ANH4EnDobbzcHh6w0s0jIqpwnMoHEOK8kPkIHdHkQkXJKPNszbLmJ9a8FWg7Lcqtc2YoE7cxAjAndsJfiwGi3CJE5enveC5HX80n5pJBg0S/AieuixR1v2Hm90HgFNcDiRLioBXHlk9dvbCUrJp7UpPMVUtPuFU1EeXlua1aPio3Dmbro6cI934CgefnjkBkBGAuUFAJF4WgzQm48FKyEDLX7A40Xpjy6BfAIEdfSFFzfu5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xCH+3Od6gG40rhYmdgxiFcELqny9TrBc/9c9su4QEU0=;
 b=C15Gov3XvNvr9v62oOfMD0qy8ZJxCwNSwAD/gLW7irjmmq8CdEdaH74wqfNTnEOQragExw2qUPd2a9QYr4l8gZ0RiEk7+7/HuW1joTDHgPkoGlIOrohp4ieTv0V+yHfr2vc3xyxNZ4uhmRvBadvOjKBYZK+rncZiLtNC5GkQAofinbwSS7Lm+DsvICM/jTypxDMpsA++Z5Unf+xfloiDA+rM6BxTvWBKBszOFPBJo03N/7ffC4H13XADgZJvk916NBcAiND8DKsrN/Sjp5o6865qv4u6aaShyoGILVZUEC2CgXpQZidhUatIvwh+r52JPzYQeic0aUUTA7f/lpEx+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xCH+3Od6gG40rhYmdgxiFcELqny9TrBc/9c9su4QEU0=;
 b=f3qfeROV9HUxMynQvsJRh1UbtE7rSuSnlUIk7rgyxMm0eLn4QTkfSM7Ig1jG+ILwGgkUkeHcd2lIdjU3qDQqb/wGXuoNgbGN/skMAtE8BwB69mom66ugIaiO4pW8PPcv/xCTt44KwdyTh9WgBDLyruJp3xdPpeMyiF2j3Vsvv3bbMwwZGJ4+EVvAHa5AfpjoBysvQmratZf+y/n5ODX+gN44zNqLiAfC3fP6EEXEQ/V/siOYgfiC+r/YjOiCT3QQRRtGGLj4Xi/kYMmfN4kp0Ub90+zsu14vw79i0i8G7rem856jwYRJw2hpom6AB6nJZCdgN/qYo6djJar27QZbJQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SN7PR12MB7226.namprd12.prod.outlook.com (2603:10b6:806:2a9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.14; Fri, 15 Aug
 2025 02:39:35 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9031.014; Fri, 15 Aug 2025
 02:39:35 +0000
From: Zi Yan <ziy@nvidia.com>
To: Wei Yang <richard.weiyang@gmail.com>,
	wang lian <lianux.mm@gmail.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH v4 0/5] Better split_huge_page_test result check
Date: Thu, 14 Aug 2025 22:39:09 -0400
Message-ID: <20250815023915.1394655-1-ziy@nvidia.com>
X-Mailer: git-send-email 2.50.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9P223CA0027.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:408:10b::32) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SN7PR12MB7226:EE_
X-MS-Office365-Filtering-Correlation-Id: 06debbe2-2b97-47b8-5196-08dddba4f8e5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?DaQBA+NlN/2Jb2TSBdaZpYAmzodHChPGDIIN1g8Q8W8/wZD0fG2BxbyhMAZ5?=
 =?us-ascii?Q?7VOb52kTPdbqCejWdk/U3enlkI4v4OZJY1eo9yDCHLYg9Xhd9tgP5A17SH7b?=
 =?us-ascii?Q?7/7i55L9P0ebhYbrpFf6Aeo+zott12yNABBwFvjaSqFEDcH13x1BEKJxnbNB?=
 =?us-ascii?Q?Hqxxjwh07rFZqo9q3CcXIjMrkWx3R+/cfuCdNl51WIt21qTUKhZWPJ1RRRtR?=
 =?us-ascii?Q?yaMZNcLBE7zBSR5/BWPNymmnBdWLBsWmeyWAYJokEGm0GoGjILGiNArBJG12?=
 =?us-ascii?Q?58o9G605pRMJi19e697D/iF97WiTurzuwevdX0fAXw43qd0V8S07vD6lltEj?=
 =?us-ascii?Q?z4C8utBHtQBsPwmpW10FY4bUrIPSfC0tD/mqQRe3Rp/IHayyz6LXEw0G1B9V?=
 =?us-ascii?Q?elaSEMkHMp3k/2C0JAXbtB3vWg5ricdQGfNxBCA1CbcdhoedvW82Eu/nxSlW?=
 =?us-ascii?Q?0Csu+E0qgpw01ZgvekiQLz3kExgAI+6HDtC/M43QBHOuGRKBuG2CxZ4aoUlI?=
 =?us-ascii?Q?o0zrutzt2vZE4N6unV1N0xHPZxtoFz2i+I3z8yEi4Xr4Xtd+eCvmPUekX88w?=
 =?us-ascii?Q?OmIEhLxcMMtBjJrs6+R6ysMonEdrKXGGe+HsDeceFhpKvt6B88TGbrHOp1cT?=
 =?us-ascii?Q?wICkAYW4JAQ6zvoMXfvhFTPUS0nWDWO7+0qDeZ7893MJsPS980zhVayRERY0?=
 =?us-ascii?Q?UFyQvyyxYVOg47HnaNp+Op+vp8mM2wYqCNaJIS9iKWhJFZAD+Lv/xlXV9qQ9?=
 =?us-ascii?Q?LjUcROZXhPTlOIGmR8D1etr/kmsdfSE+21mTDmeTSExfEWT6iKhyzv1eSCKR?=
 =?us-ascii?Q?s4Kap1LFNh6Zy7ueK5kmgwiVy2qCO4HY4EGRCSIAUsgxxBfKXGcc83lB+Tzx?=
 =?us-ascii?Q?2pGZQOk1qP1bGHXj1ypGGbag57XON9p2FU2ZyybGCwlPgb92kk1PFlkV3AW2?=
 =?us-ascii?Q?e2KVA72+4SYmPu17SCz8yjIs3W7nhE2mlnBv1lzzNN4cu0PIDKDxAxR1FT8r?=
 =?us-ascii?Q?cyc+1uKR3AyMeFPVnbWwiDEe/OAulRm+LjP4ksO0+pzP8+sSb46XDXMKUKZL?=
 =?us-ascii?Q?CUDNs5uG6UGrRrEpQxK64S3CD56XRZZ6mESSG90ItZ2pzcdzTdipHKk1nzBf?=
 =?us-ascii?Q?akmtNdIv06pFIxsu2CI2VjWL8L1AgY7B34aD1h0EszGTkYXCrOlZ91sOsiPd?=
 =?us-ascii?Q?OlbrlRRoDv5eC6EII4LsOM/mVwB0Vc5gGcvpWiYrair8bTX3cil2l0huY6Nk?=
 =?us-ascii?Q?c9NRHdfoqGGGCe80PaQaKfUgbq8OXc5NIdBaVIvaNmSj+JUEQ28iD1y3x1fG?=
 =?us-ascii?Q?XbFPyXj2aZZARk6BLuyaNLdVMFDcCYhqraZH2C3DiQuXes0CcddDMbm7bZUJ?=
 =?us-ascii?Q?ZEuzBvpLDkLfPUl7/kGb02LLKVPpajk1eHfEpHSyOpxMlWDYZ45wg1alMyIv?=
 =?us-ascii?Q?FOgv4LN/HPY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zmUNzzp2MOSSmWPzI5GW9EJyWj0h/TRyGvGM6jG9QiBs3PNQIQSQAEQ5Ot5U?=
 =?us-ascii?Q?p0srFrHmUEC4oSB6zxW73TKU/lOHa1Zzex/37GMz+flBrFnx7KEVt3VvQ5gq?=
 =?us-ascii?Q?VczVjpTzsVOvQkk8A8KEc0trJ/FNYuFYjLlhbMYf7QRVNk+jtMr4rvfJIHM5?=
 =?us-ascii?Q?mr3NqeCOXBUcs0Z6+0dSKpg/UmBaSLwxHOZYNDwxM+MiyX4Biowc3Roe1aF4?=
 =?us-ascii?Q?U/9uTc98aBP7SzzT8Rpa46Ytzh5RKpoRWhQAkrrQVdBVkmEcO6opFEk5ojpo?=
 =?us-ascii?Q?UXkD3FcX+TfbpnJ25HxHvo5PKkIoT2dAA5HAAnHgBpVs6H8p85owHmwMw4dB?=
 =?us-ascii?Q?mA+1OoGXRJOt/dl7TrfQ/2A+2MiOGkMokABFIfmRlRTJwuKtRqDHz8OAMKRt?=
 =?us-ascii?Q?rLYYWx9J6A/iKau0jDWMMbE+YvxYfHE2BZTyN9VuTFvZpwnKcwXPqrSApFZc?=
 =?us-ascii?Q?nlKrR4DHsv4A1U+B9+5H9NO/ME/yw9nItADhnTiCwH/ephWz0jL5cn4dx2Rb?=
 =?us-ascii?Q?z1bXxXdUZ2EGrjvuRbeCwFLWRjIZ2nNElAYGz1aHpHhpn9drf/pN/EnDlVO4?=
 =?us-ascii?Q?BNkGhY6n1zI4ES916to+PTk56j5+1pgzv730g+vYFOviKSywOD0r2OGwp8bb?=
 =?us-ascii?Q?I9Opoy60lQIJPgGD7zLiu5gOH5ol0teLXvvEsEMHDoY4/3dVbdZU63pLZrlm?=
 =?us-ascii?Q?v3donHGVm6RIh4yN7CnJEjWfg+Rpr8hb2DbhI+NLrxII/qH2JAvTAUG3Td4r?=
 =?us-ascii?Q?b0YWmBH2ZyxaozzX8juLzwjkdHARUMGS+dD1K/sJikTXfoij0tMHBfhW994d?=
 =?us-ascii?Q?trrZx6i9w0I16yl2MmUjKhXSB4vumAteNlDtjwYhHeboPQQjC2FnEyurwaTE?=
 =?us-ascii?Q?dt6HyAOrgVdvbYCnqHFiVINFo44GlnMWX+c2IYDBrgFhuwkDLikSnN0bKZqV?=
 =?us-ascii?Q?SU4LO/RMSWSshQLxLPQWAP2rm+P7K87RZYeyidtS7MyYCBr7yFSeS5VdGC6k?=
 =?us-ascii?Q?UCAK9P9KGlYR35jufJ6yak34InEn6NQ6kfSwcOPpYbpM0iW0e73NNVoDrL34?=
 =?us-ascii?Q?R7Ej/takeIC0ekeMsf1y0eXNze5y2yy1tpxcP/Yl+anzO8np39IefjLqiFRf?=
 =?us-ascii?Q?HBSTA6TCWRdLllU4Kn5HG6f3SqjWdpX6DCAsTkOMqI0Tnumzdh+PAIVdrE1N?=
 =?us-ascii?Q?p4jQozfvDV4dVXr3XJseu4bScnSxgmu9WJOHPmm0ReS9xjJepxOy/F/KHDP7?=
 =?us-ascii?Q?akPYWDmAWipk9+twL4mvqy0f4E7tEKN1GxXppNsP6r/xbepwVSl5XnQOHFiN?=
 =?us-ascii?Q?cZdRbW3LRjxvGSspWehQq16SKY2IkMpqK+Aqw23ZGgrs3pwtRFZKkj9qmLYW?=
 =?us-ascii?Q?JAaz965HRN3P8fRiKZPS8FEtvwUtxlUt3+By/A0NmFrT21nry3fs3QpdtHdG?=
 =?us-ascii?Q?+yqa1RmXo5Dgo44vUk/IRSCq/SrUOFKA0G9vg8Jhff4g/nbRLqjN0YmmEoRh?=
 =?us-ascii?Q?l++qNnGjWNzOrn8aXafCOoVUVBEBaevqu1OOc0tiowi69s8F5jqWR6tuKP/Y?=
 =?us-ascii?Q?IhYGDUmyWd+l0f7flLroeoSYQwUjeLTuisyohd02?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06debbe2-2b97-47b8-5196-08dddba4f8e5
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2025 02:39:35.4701
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UbvfhP6cj7teNy3Tof0oBH8Ba5nZZvlf7stbOotLDrecAuxDdaFVDBnLZgy3K36l
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7226
X-Rspamd-Queue-Id: F34AC20007
X-Rspam-User: 
X-Stat-Signature: ag97gby4jd9rwhp5i6mw7jukungo3ccn
X-Rspamd-Server: rspam09
X-HE-Tag: 1755225578-466910
X-HE-Meta: U2FsdGVkX1+m66FcS/THynvC2fR3+leLbGdnxCZ1twReRtmu3rLZn38OmYfOEpKEBSHswq3DEtrTI2AerxWkoPck2wqtX6GRYP8hcJD5pXtPl6IVjnjmbpO9u+kPxME/qCQrkfH8HOoKAHOiDnZsFzVI0oarBPHCuH13GufZE/pLWSTvX4y5dM2RUJV5dLC+PThYrU1WRyaOLROyHOPhVMJx7ENwUXIkzggyffuWA7rWXPD+cFCnWpWTpzLtuUhAyGHEvpIom6qhTp5kWuVuSOR6XXXW2OB5CsYcaxChk3wmRsH6p31+aRafKek0NFQ4spG1b2zSy2vI/+h9yJTLZKZqRz/jEVSy14Fm5K/bbEAV+1rvjJgsCHN5jH8uM73+FUfr9FQzoP5zGgl2OloxwC4aDF/3jxLB0E1a25SeOd1a0D8Lvu2PorAKitN3jmNACf/J80WCgxJkMFgnp2AOl+DDRq6suDIPIp3fUTR5aSxLxHZPiWHA9XOsU3wXHkGeW6tKvutxOuKEAX/2l907z5E35WLJWPpvyotsI3CsVh8uabJCfcZP5w37atIVpq5pPdofffGMdfs1sQA8JM9Yk9H+FQTnhK9QCGISEDsITGme1aG/UVPgGZ1E7XtkRWrw6V1KuVAfkyHattxJcL0CGhRPeKgaIzxic6MT1S00ypoITpQtLBgoiTrJc0OROstOHuGA5rmXIId8R62eDcRrE2ktltr437Ytd6nwaeaN16vNYfWSCbQDV1XyoeWFvfhLFrmiD3UCHWKk9zvLfogLo+Q50BqsQDQEOWb1DF9cZiP4qY5G1Ny34lzmI3uHaL3TK3/kYliQl0A6P5MXzrPiCtF0T7/4NL6pKnBY5vFbXqjzq4iIZtzn2bSBaBrj55IxPD5elF+54gBR4M3TI6d//Hkn3AE6PuZp7twbQoh80gqis/fxbaBdTiTj84aMVVqM3RYiJHxLLGyzBSxyh1d
 32czHC2H
 JmT4PaQN06Ux0qfh8Lo2SnwpmnctaXKpmuwoWdNCf9aThMEQwV82BIOFGISa7kVD5hm5RoJ54lMuerMd8W7DSMJxEIoSUZsDwqHB9m7O5ZcAqii1ptn8Sur+bnuf62H43kFVTjfQQU85o/uavntzb7nhNeBgEbul05gjBU8o2Tjcs/HQN5JjV0UWz9nc2CH9g+ib7GPMpLeZ3qVb9crgUurMNYcyv+tMyhcAh2So5VR/6t2SEHZPZU0KEdCgZM8hmuJD5AcidKV8sdm93ExTLM87oix6CqDokEDt+a1TFIMWz0sgveuRpEavhdBEhxO07pfGGevpeHOo1JNF3lLRk/sqn9j5OqIb86AwR4pUIILsYJulKr3SXXJW+XSs6IDAC63LNrDmvjbN3UvD+8x0oiSRuAEbin4Wn/WLpoJZhk9kbicpZ0+vgnDoXVl3QYjKNg3tvu8XEIvMEMx2tBqkzHV7WES1oFx29OkG2Ed2KnMn51E0OoVhJJJfYvyNI0tUKwZvYeWBIgCr4VNtTM5E9uw+oRdF7aDiVsVqBtenZWe/owiY33TcXsak7h6lvFuxZQskis22sxd7Zo98pugfDrVizypRyCqIYusI2ltwxLWh/a+e9uinCUAyd6qTGKdoRECgFp7KHD4FcdG4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patchset uses kpageflags to get after-split folio orders for a better
split_huge_page_test result check[1]. The added
gather_after_split_folio_orders() scans through a VPN range and collects
the numbers of folios at different orders. check_after_split_folio_orders()
compares the result of gather_after_split_folio_orders() to a given list of
numbers of different orders.

This patchset also added new order and in folio offset to the split huge
page debugfs's pr_debug()s;

Changelog
===
From V3[4]:
1. Renamed {gather,check}_folio_orders() to
   {gather,check}_after_split_folio_orders() and moved them to
   split_huge_page_test.c, since both functions are not general enough for
   arbitrary folio order checks in any virtual address range. Comments
   are added to clarify the purpose of these functions.
2. Fixed file descriptor error check.
3. Removed unnecessary statements.
4. Fixed is_backed_by_folio() tail PFN off-by-one check issue.
5. Added a check in is_backed_by_folio() to detect if the order of the
   backing large folio is larger than the given order.
6. Moved misplaced comments in is_backed_by_folio().
7. Added a comment and a commit message to clarify why the split range
   of folio_split() tests is changed.

From V2[3]:
1. Added two missing free()s in check_folio_orders().
2. Reimplemented is_backed_by_thp() to use kpageflags to get precise
   folio order information and renamed it to is_backed_by_folio() in new
   Patch 3.
3. Renamed *_file to *_fd in Patch 2.
4. Indentation fixes.
5. Fixed vaddr stepping issue in gather_folio_orders() when a compound
   tail page is encountered.
6. Used pmd_order in place of max_order in split_huge_page_test.c.
7. Documented gather_folio_orders().

From V1[2]:
1. Dropped split_huge_pages_pid() for loop step change to avoid messing
   up with PTE-mapped THP handling. split_huge_page_test.c is changed to
   perform split at [addr, addr + pagesize) range to limit one
   folio_split() per folio.
2. Moved pr_debug changes in Patch 2 to Patch 1.
3. Moved KPF_* to vm_util.h and used PAGEMAP_PFN instead of local PFN_MASK.
4. Used pagemap_get_pfn() helper.
5. Used char *vaddr and size_t len as inputs to gather_folio_orders() and
   check_folio_orders() instead of vpn and nr_pages.
6. Removed variable length variables and used malloc instead.

[1] https://lore.kernel.org/linux-mm/e2f32bdb-e4a4-447c-867c-31405cbba151@redhat.com/
[2] https://lore.kernel.org/linux-mm/20250806022045.342824-1-ziy@nvidia.com/
[3] https://lore.kernel.org/linux-mm/20250808190144.797076-1-ziy@nvidia.com/
[4] https://lore.kernel.org/linux-mm/20250812155512.926011-1-ziy@nvidia.com/

Zi Yan (5):
  mm/huge_memory: add new_order and offset to split_huge_pages*()
    pr_debug.
  selftests/mm: mark all functions static in split_huge_page_test.c
  selftests/mm: reimplement is_backed_by_thp() with more precise check
  selftests/mm: add check_after_split_folio_orders() helper.
  selftests/mm: check after-split folio orders in split_huge_page_test.

 mm/huge_memory.c                              |   8 +-
 .../selftests/mm/split_huge_page_test.c       | 345 +++++++++++++++---
 tools/testing/selftests/mm/vm_util.c          |  13 +
 tools/testing/selftests/mm/vm_util.h          |   4 +
 4 files changed, 311 insertions(+), 59 deletions(-)

-- 
2.50.1


