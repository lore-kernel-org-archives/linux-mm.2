Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDD43C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 15:05:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6FE66B013D; Mon, 29 Jun 2026 11:05:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C46A46B013E; Mon, 29 Jun 2026 11:05:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B11566B013F; Mon, 29 Jun 2026 11:05:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8A51E6B013D
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 11:05:44 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1212F166860
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 15:05:44 +0000 (UTC)
X-FDA: 84933274608.11.DDE364A
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011009.outbound.protection.outlook.com [52.101.62.9])
	by imf18.hostedemail.com (Postfix) with ESMTP id 41AC71C0007
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 15:05:41 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="qybNC3/0";
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.9 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782745541;
	b=F7O/m5wtPd74n7RKswtR4lfNjxGw/dU58t4yN6bv/Ba5tr3vQb8qC2M/G3edyeHy6t+z0I
	1nV1/Q8qOuqH1UGpeho6G7GJoN4OEPRdYo47KJogZWhsnVQswg7l0gCwcMvuV7Q+AMic+x
	FOi6pHc5ZBS2sBg8xLR3f1G5R21VucM=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782745541;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=goruWoZKFx3fwB4VkFUgTY6Q7nwFo3OVqAwt94qcX4Q=;
	b=yOSC+Thp/7qOuDMXlfUVD4siLAonzn5wp+yRecAhiqLlhED5oS2vQ23NOP8g+z43FB2jAD
	WsmGSbebuahRvIctNNm3P5YsfX1GSwpqkkF+WqZG/v69DYomDcokVxHj+gHE6pRFOXxfv5
	TfX5WysQ/5ADSnw9zZIB2N4kqMLIQ4o=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="qybNC3/0";
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.9 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MYRJQ1A5oc/jeW/dFHLAJrH6QwE+DGGugmGIs/Pi0NHROxSTpLlL8uLQ0GhTFhXSN5xNmeJYSvypEiiE9KuAulkjoHU8muB0xR3UYiVL7Yl99AT7biu/gZVhX2L0ETjN4HSboPwU31AHsKMqLDw6M4KG60tu6UHrhAgGNKQvZKa+JGOxy/kbdwUIfWyu0PRljjbYLwHjG/FZKxD9mvnAB5AH+UyQGU4zs8QX3O/zIcJxdhLf1t7NnCMS8/y1zYVt82qoPW70Rltm4Vyo+f3JM6Z1cQG2s4J5am8leb/fpPWnjonwsC+aML4QsBQdvnrZTdjOTn0UgHhH5N8QUdEjmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=goruWoZKFx3fwB4VkFUgTY6Q7nwFo3OVqAwt94qcX4Q=;
 b=KY37gp78ew/X7ITp5za1ntrCemkOuaRvmeyOzwKayQf/wqWge7nY/EpZ1eQ89zU3MuCBxXQ7Bd9FjIRxbyDqyz4jdOtnmtql5cEEkgiHjKTS/cJf7DOb4ZS1ld2DZDaFcGlycwES0qMSG7Rtda3PR3tCLhkVzRC3aj/9DNTT5YsL1WXxayjtebnKF0EBJzwCUYcom71EeR/tSFq+00SHwJ5JyGUnYA61tHWR4cbitYYETXuhAhrVYjJXdlg9DH6/n2kj7rX92z/r3WVzCKuGw71uTh9F1Dth4mFNj8ZXt3QvrIyeW9Mz7uf31WMBWeQ4i1a/+eu61vn2I3ZExI963g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=goruWoZKFx3fwB4VkFUgTY6Q7nwFo3OVqAwt94qcX4Q=;
 b=qybNC3/045TriVezQ2wL7Rh1ow8CubGBYwgmesnWjuivGrWdYQzKlwpGG9tT2iQmN//9/s2c1NQiUmZbK6V9mspLg58ls01GyLr3VM88B4eKPWd7HhfXXg43Up5KjYLBMIyZTr3JtAV/wwY0IyfHVse0UM/E4gQdtttv/zeXxRnLQhMtuDbyODr/HWjpzI5Qha54F/r1B8ZATYyWO1Z+cO7HFxlCQea2xeKwpz8PpsauFOtyvc7c56q3MEe+lMaEqrEZ3reTmtehE2X3kQB2W/jkAqdop9nElNk65zx1vv5AynsyPyZMh8gdYRQn98Ycu9+P1OObozL6wdZmdfxYrQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by LV2PR12MB5990.namprd12.prod.outlook.com (2603:10b6:408:170::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.19; Mon, 29 Jun
 2026 15:05:35 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0159.018; Mon, 29 Jun 2026
 15:05:34 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] mm/huge_memory: add page->private check back in
 __split_folio_to_order()
Date: Mon, 29 Jun 2026 11:05:33 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <F050B6B0-AB3D-444A-AB40-380C7191EDBB@nvidia.com>
In-Reply-To: <9fe5173c-4beb-42fe-8f7e-385c609f899f@kernel.org>
References: <20260628-keep-subpage-private-zero-at-free-v1-0-f4ce3930d10f@nvidia.com>
 <20260628-keep-subpage-private-zero-at-free-v1-2-f4ce3930d10f@nvidia.com>
 <9fe5173c-4beb-42fe-8f7e-385c609f899f@kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN2PR11CA0025.namprd11.prod.outlook.com
 (2603:10b6:208:23b::30) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|LV2PR12MB5990:EE_
X-MS-Office365-Filtering-Correlation-Id: 12e34135-4201-4159-8986-08ded5efdef2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|1800799024|366016|18002099003|22082099003|11063799006|56012099006|4143699003;
X-Microsoft-Antispam-Message-Info:
	udu8HTQIZBLj7rhqJWpTjLsWp0CMRcb+TcDIOlt8NLNU07LpvseZsKaMI4tfHNj7M/17GPxXauEEV/PlW95xUir6fVwzcjfG4/9hWGhRxXnezCeJvgMYEdyb9lhJ4MxYQwjKeQ1NfFdw8b3OMz7bg2x4OV9ve5PPo7EihUxNoZToQ9HFOKx6h8faZtGn77mCWw1wiUg90Yk+Qf0KI71BdHxn/UuWc9m+fY9aG5QowlSXG89oXPSGm1vYSXrzOkz7GN0V2moyx/U4mXtdB1vXZ79cUXceKizJcFR4N9BsWKRaz9W7G+5oonbglyYmT+ew38n439EAUdko1KhV/HRognE5JDtTxRufArI+2SIqYQZsnXRQQCwghaehL7Ek0ZjIYj3ig6N1PzTx75Ef50vrzEw9ioGZ6mEl98SdjKIbtLkyCJYQ5N8zTJf3tJqZsI9hxdH2jyK8r3RosLa6yjZqEVTVYgbOXs9BSj63MqcVHahj6GlXXPxZqgJ9ky6ooLpKbcqllX1DDJJK44NuUF1dP075DFsp5SUYuUIms2jc5dMFxzt41JARAbSHznA/vW+OY9Dco9yaJwCuPdjHvnSk8UjzQSV2LHuouy/5hGZx5Kps/pEETsSDT7Lqa55zMLc4Z7u2l92TkzhIuV76nDFRYZYPqFbgW1r+UbSCGpBaKfY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(1800799024)(366016)(18002099003)(22082099003)(11063799006)(56012099006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?IU7MOurdNYm6htQMk9zJRyoGv9sLyMkBpO5kcc58W1TCdiCDlJ1R8J/BUOql?=
 =?us-ascii?Q?8kC4GdQytUtmyWl2MX8Ui9+QRQ5seqTVrnKFv+Q5SdNORWwQyH1X02W4yNjJ?=
 =?us-ascii?Q?hxICTBPA+hEP6T4WHyzqQIhYYn1s9vUUZMbG/TYQYOhy+o+YkwMPGwYl00YX?=
 =?us-ascii?Q?WAfRb461UnF/lReZpHg6ROzbRfyiuXNMBS+yBXlcXQVf1OyXmg6iHnQmLs5p?=
 =?us-ascii?Q?9s7lEXG8wyJczeMkZUhiSlO540w8vsNRFSJjRfn7Wqqxa51TgJX6pH1a+o+S?=
 =?us-ascii?Q?pZRHvSrp0KggBuZbE9c+P4DSXIpIAO6lGkN/wWDNXR4Y3J79ATQxy2MY3FWX?=
 =?us-ascii?Q?zKqXwF8iTCuyPSfSFPLfb5cwmWQMCR4WchvlH2zINfcHpiKT9Z1OExuVh1HA?=
 =?us-ascii?Q?EZHqssxyWyrzkZqWuzsXCogA0jpxqLGinLb+4iyO4oiEF/qPfQ3XiPB7WgJF?=
 =?us-ascii?Q?sV1MJsOPLn253wvvS7zQHkjijiG/w7wKklK7IrccCmMIisuxqFhooCrQTb/Q?=
 =?us-ascii?Q?rfXd1gs6YrJVXCyt479anMV9+t5oxjoSU1U0U8V76aTBV72FUZtftDU99u2s?=
 =?us-ascii?Q?O3Hr3Pgo7+l2zR65DPsIr1f37lvPl/2hbBNMGUTUbD5UmOGAbIzG35KEVV6g?=
 =?us-ascii?Q?o9vzpauaNm/XIJcBmRA0VJ4wam6vxlB4Zsiq36VqUC+Fr/jEvYTQMvcf2hTR?=
 =?us-ascii?Q?LwAA6iIe71WxMcIZQnQ6rfQVl9fkCwt/b2KfUCw6q6nrT1N2Wg9WsEvecep1?=
 =?us-ascii?Q?+xlIUc3F1R1qzwHUSvyIWj3ruNGygiE2vF/kCUlMTQAUwbqTZswR4EtU7XOi?=
 =?us-ascii?Q?tYyJBB5TMz61fE5hU9Qum1+JYNAhRGK6DtVG9k04/PSNdXDTO/+B8vFUoSUh?=
 =?us-ascii?Q?LYxH9Xql/9E1HKatr8SjBvst+AP7yXG2Yfb3I/fc/2WzRAffVYHt30sJVnwc?=
 =?us-ascii?Q?rfJWwTuVLr+H4DlHfDb239p3kYWpY9Io2HHivAfdjz1ysZcJ5MPqgEjKSVNO?=
 =?us-ascii?Q?LJxGXuKvMGrLUx6PzExDxRtEr5DyebUeh11o77YFw50cKc+/haur4+qT0104?=
 =?us-ascii?Q?muc+asNniHwyqutwKrydxbsVzchhFBmLG17RhsY6iNjPRUW9Xnpbh/MPB/eN?=
 =?us-ascii?Q?VEnrgpCOZzoULbtAT72xK1Loya2503jtkx0XU0HRbokNueLeHAPQWnU9VPmP?=
 =?us-ascii?Q?7iaTxE0owD7sbNiIMjGW6E9kJfC1C1mq3+6n5G0GKNa/ZDrWZgmJMpPgDJ3F?=
 =?us-ascii?Q?z0C0PAnFdRlKypjk8F2escS7K5guP81ctgCkK0vmUACg9ZC2wUe76qZWVr0E?=
 =?us-ascii?Q?Y4KXy3DLTRYPwbuSMS3U7sVUYmGTuN9CyX2A5rRZAXq4u49DjSqVMDO8+5e5?=
 =?us-ascii?Q?I3dcK9zoi0e/qQsergGGeozjRDezGnTxbxRSDS3shx1702c3yV2Q1/jjh/qd?=
 =?us-ascii?Q?KT5MWoq2JTzal6IxOSfaCj0UGAfITIr1OYsGRGEJlnnoTfWPFSf5YAF7pnae?=
 =?us-ascii?Q?xJmwVnmHdHlG2bZSLRZP/p5CGLKU3MAYp1zZ6aHzl4mwTtfvnibusW4lcLIr?=
 =?us-ascii?Q?UMuh0LpGns+0lqx7ilm184SPgm5Hn8cUZTLzUs+Nbm7S0gSDtMyl7i78KUlx?=
 =?us-ascii?Q?y2rPGX5BEKY5k9YW9SnB2JduTo4DVkjf9SQ6Sy9HgmpGknCjggS3bM0Me101?=
 =?us-ascii?Q?VNsJ3W5cMcLnWRXnP/WP+4YB+sG/22rBM6x2UF45LiDc6UpG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12e34135-4201-4159-8986-08ded5efdef2
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2026 15:05:34.8764
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4wz1pN1ff7yPrl5418NlmGaBeDmpPD0TqLUXcQ89FAzipyu5q/AO/VqWjC+1bLJQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5990
X-Rspam-User: 
X-Stat-Signature: 4gwpxe3ab68cxxr4o411jxiyz5hzbo4n
X-Rspamd-Queue-Id: 41AC71C0007
X-Rspamd-Server: rspam06
X-HE-Tag: 1782745541-236231
X-HE-Meta: U2FsdGVkX1+4O/mONlDMzofBpo0KzIFMySTf7gfJIU10forAfh2HjHCCtqZIRghZdixU4jldyOeNOJXtqp1gAhvD22dNDscy5FlGLknJx29Riz8EIE0FTHrTkdFUFAHQxlXmtSjlr0sVzxmCPvem1jkK7ZP/mEAB4TUjk/5hRxoK601eJIBXxp4QNTemzZ9rTPMNFwaKd0cOV59xEUV9mLWRnaMQ0eJSyWZMMmfv4ifyUm77cDMn9Fqt072X+wL9XveGHqBPLLDVb2b+GE0XFk/rY4p3uzxWyG+zFJpfZoSOFQYonpWX3wqCfxjh+AYSVDpJ0QhWFw0B3SqBWdVlLXFZFcUSALFowydC8/purCSXqXCOpvrlAVQZjj1RRvd/yWx+SKY/7wvLjnt1swQmx4smUkE9uxm1uuqO72MllWzM0bAUetJoSSlBrnXWQSmOcXzHu+Hl0UkCTkL1hAZqN+acSCyXEjyZgtzqmngyhiOK5D2sR495rmewz2P2udTTWhS3NEmZn7Kq/OnUIUv9tshApgRer6t0g8iXNPK9I0jkYUHqdOAatLVeiNOsW98KMC44wNOLnErsa8idwcu1dbgdZCpcZqT5glJp02AOkFLdGDKx/z2+cMF9TX3B0YGpVQjwZlIePpbldhzXSQO8gTI38ACy5cFpGPLllvxjCQIYQr4DKiOEQj09qpxcrwjy1s9fDtVE/RZzeJCUN0p/IK8LHxhFvf625zKWOQge4zGF5ci5KQOFL4zcgI3WEBdFQpgWRLkflNHSHXole+hmHPwYe3ZH+uOCTMkqPjP+c5/ePS5SoqbQ5V+OEHtHBxDB1aehkK6nqxbussjMTZjvMR9QhVTmL1cAJEiShtk7AEWyT69+9dK/hj+pdnXKUyKA0muIsY5MHSSxe+thJZTLESuXmMOZMZl3Aln3OFiKux48XGcRPemCi4LCiWGc0v+pD97d1oRACU+SKCHUnSN
 vEsjG2hX
 Wa6Qt+930fZtNPnjkWYczkikzHbCtzZTNBwc+4QeOZVyS9Ff6vaJjONs3CeH1ZptLe3JTGD05bA35l7humWNjwk4FrVe9hylPzTzIDkT2zI956B3GzRXTHzbFOY3ygJzjB5nEXkrYE+8nO61ymUZU+gubRTGpULTSxjp1b+n7sgTiXAc+gh0sqN6jCOu/NB3//LntkuJWhdDIyg5cPkWezRGTww+Xt+n201NkcqCpPDw4QK+C50zehNEbp99DdVSqb0NkOG5IFNPeGYBaw7tRUgd2u463EScza6yvkr1DPr1K/vZK86aPGw/bHL1qDxxs3j8mgmIXgPML/gO3FwljZ9k3rvgKSUzwDd/BoWzg/m3S3niZ5urjwRqumZnBlLQ/FkZVgui77ItZG8k5RzUbDZQ33+vnUeXJwIRVlpwMfWQpiskLKGHRyKW88g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29 Jun 2026, at 10:39, Vlastimil Babka (SUSE) wrote:

> On 6/29/26 04:56, Zi Yan wrote:
>> page->private should not be set in tail pages. Commit 4265d67e405a
>> ("mm/migrate_device: add THP splitting during migration") removed it
>> without a proper reason. Add it back.
>>
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>> ---
>>  mm/huge_memory.c | 10 ++++++++++
>>  1 file changed, 10 insertions(+)
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 2bccb0a53a0a..037d67fbec6e 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -3594,6 +3594,16 @@ static void __split_folio_to_order(struct folio=
 *folio, int old_order,
>>  		new_folio->mapping =3D folio->mapping;
>>  		new_folio->index =3D folio->index + i;
>>
>> +		/*
>> +		 * page->private should not be set in tail pages. Fix up and warn o=
nce
>> +		 * if private is unexpectedly set. Do it before swap.val assignment=

>> +		 * since private overlaps with swap.val.
>> +		 */
>> +		if (unlikely(new_folio->private)) {
>> +			VM_WARN_ON_ONCE_PAGE(true, new_head);
>> +			new_folio->private =3D NULL;
>> +		}
>
> The unconditional warning means this is not expected to happen. In that=
 case
> it's odd to check and fixup always, but only warn with CONFIG_DEBUG_VM.=

>
> If we are reasonably sure the current code is OK, and only want to catc=
h new
> mistakes in development, we could just VM_WARN_ON_ONCE_PAGE() without f=
ixup.
>
> If we are paranoid, leave it as it is, but drop the "VM_" ?

OK, let me drop the fixup unless others have a different thought.

>
>> +
>>  		if (folio_test_swapcache(folio))
>>  			new_folio->swap.val =3D folio->swap.val + i;
>>
>>


Best Regards,
Yan, Zi

