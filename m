Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91719CCFA13
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 17:11:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0328D6B00A2; Wed, 29 Apr 2026 13:11:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00A066B00A3; Wed, 29 Apr 2026 13:11:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3BBC6B00A4; Wed, 29 Apr 2026 13:11:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CFF9D6B00A2
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 13:11:15 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 99126A035D
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 17:11:15 +0000 (UTC)
X-FDA: 84712234110.11.79FC65C
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11021113.outbound.protection.outlook.com [40.107.208.113])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8DC691C0019
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 17:11:12 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=tPlBpKdu;
	spf=pass (imf21.hostedemail.com: domain of yang@os.amperecomputing.com designates 40.107.208.113 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777482672;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JeXCIGnEb/3g6Y3m0Qw1PW4OMaubdiXb/TWbR+VA6w4=;
	b=8FYNJIMLUs1JybQITusL9srqNakFgrCru2ojzEC49cwCerZ5E/DOcpgq8x5tEPgaAkhDB4
	+4wMCOhXV5Gmk9rtsBKrsJaSIbNvD/153UA5rSGtAvIJMaW+IDdAfgqWYUfiyUYk1ZlWWG
	/z1oVdCMDgj3KZwH7jwPtzJOYsbbg+8=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=tPlBpKdu;
	spf=pass (imf21.hostedemail.com: domain of yang@os.amperecomputing.com designates 40.107.208.113 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777482672; a=rsa-sha256;
	cv=pass;
	b=gMzH+r+uwHtnP/7Te9uy5NsDvnzhWyj3MXwyEKlZSzo6f7F0mddNityh7JQRRAq+6WeMfh
	0sBfjOPcAwmr0rXJ+yHWp18eKEM+k6A/G5EqZBANuI4wALR0nUOuf42Y56V4PkBhf2MOcU
	Wu8Z783UJbsrn8Ct+P57S/4jKqdgnzk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZZx1j8gwjleh5BWwHH6ziDcsnqCr4HGpu2TwJ+e+rJzrVL/p+4VV6YeVC/Gpd8RiZhUURm5KfXEVa/X5p/Dcfgy0QlfwdiMPP4pAXjDl9PBaFX5Acj1lk8i08ajAM6K8E1LGvzgEK9vlcAA5zyJskFrYY/WxkHZIXI6lzMSo4jQ7ZPM2h5iUN6qcaoxOlbtDxYuC9O6nYEVvMAvA7/tBu+4YrEHYduF1N+3pCIKE6mBG4e4tBBqzThEFNAf10BjuIQ3Fb48aq3lyVQmEKWCcySYq5Qgh4Du6FDSqrH/ccindsLOG5QBxf0cR/ioCAVP3wZtSRbfiYrAJ/xYfrPl4qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JeXCIGnEb/3g6Y3m0Qw1PW4OMaubdiXb/TWbR+VA6w4=;
 b=KRzaF6crE9H9mluDY8qnJjiEn7Q/WFr0B/GacWtk7fY9CKL5LHHCexedXLHFv1LBr+2ZlmRyG5n0MJuxQ6+GiJFY0pUg6owNI7ECFKSSXZorXeaLwKdOj5CxfzxZPsgmTsSs3rmen44qRxcsC2q7UAMYvuDBuSbxB4UfEFFuyjBmzQfvM+KBdAsoTnV7SJ3NS6d/F5uF63hqgidk3Ve2OmCTGEyhAjfr8uL69MhBK6jmJPjnKOwam97RJ8NWcIavGOPSjEMPtk4eKjkGi2C5v4yYv3OH0dVh9tvjI7vKfx5JTum1LSSctNUMyxAeiAXgtqINUymVoKe6b5pgh3g9uQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JeXCIGnEb/3g6Y3m0Qw1PW4OMaubdiXb/TWbR+VA6w4=;
 b=tPlBpKduJxCVsLu5qYPU2FAE/8jWRYOX+VRlx3JsBQG1xUFvpc5QLHa+TPlhpSRUnbPmG9xg+CAXpcKZPYHMIcXZ++zdKx3xUelGH6OIa7q7aqaDbHFzNITB91+suI9bDyYetZloGApjtsLZFTnRjb5HEg+Ze6nMBPhh/RXJWcg=
Received: from CH0PR01MB6873.prod.exchangelabs.com (2603:10b6:610:112::22) by
 SA1PR01MB6671.prod.exchangelabs.com (2603:10b6:806:18b::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9846.26; Wed, 29 Apr 2026 17:09:09 +0000
Received: from CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::46eb:64a3:667c:c1a0]) by CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::46eb:64a3:667c:c1a0%4]) with mapi id 15.20.9870.020; Wed, 29 Apr 2026
 17:09:09 +0000
From: Yang Shi <yang@os.amperecomputing.com>
To: cl@gentwo.org,
	dennis@kernel.org,
	tj@kernel.org,
	urezki@gmail.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	ryan.roberts@arm.com,
	david@kernel.org,
	akpm@linux-foundation.org,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	agordeev@linux.ibm.com
Cc: yang@os.amperecomputing.com,
	linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 09/11] mm: percpu: allocate and free local percpu vm area
Date: Wed, 29 Apr 2026 10:04:37 -0700
Message-ID: <20260429170758.3018959-10-yang@os.amperecomputing.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260429170758.3018959-1-yang@os.amperecomputing.com>
References: <20260429170758.3018959-1-yang@os.amperecomputing.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA0PR13CA0008.namprd13.prod.outlook.com
 (2603:10b6:806:130::13) To CH0PR01MB6873.prod.exchangelabs.com
 (2603:10b6:610:112::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR01MB6873:EE_|SA1PR01MB6671:EE_
X-MS-Office365-Filtering-Correlation-Id: 7360a4f6-cbd2-4a06-7671-08dea61206e6
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|1800799024|376014|7416014|366016|18002099003|56012099003|22082099003|55112099003|921020;
X-Microsoft-Antispam-Message-Info:
 HgT8Q1KlzpLtEZekpFn5G64swoktl7uhptjQVLarDLLRWdcEMDBUQta8qijwN4fWMR5DENgpNF4ra+U+8jIuwZsuHUMugfXYMFwRzWWTUW4R1lLX3ylQ7IFnP8/xdLIcMCQ5Vxcyi29vOva2dgjk3L0HI8iSNgermdjlMqOYPCa/QFXrMfcmzYpGKtnvGQOS3Ym9u1KMiPH5ASmpIOT9xp2EL4xt4+paro0k95SkQ+gsWrJLuUsOvpYrzvC/XK1Uk1wBM24C02Vj4TbLM5hJU1hoXEqlPW45YKQLaFqSmOE8WYYFayRGHjh1Zc/Cy6U/DQVu0zJJuK0s3hz1Ty9P3KhYxPCGHatkLhGNxrQ6EGyxhYlSW+mDP7q1ms36k29v3A40fgKY/5TnN6Gpu+jPAUFJugsRegLYkRYpry4tWpS7nnwDdlzy65fz0aY8RN88IYUCxsOFQtW+4uAvKCw/iHfAkumdsxwCfTZ/gi2HNzMVGk5WGTSWmbpWtoHf9CddJn27PPH+kWcPqRifkHd058uUrTqCQzBlPTzLilAdxcyM9Ti9zlp6/wiLnNwZDW7MVA+Y0H6MH8BOHlI2bt8WeuQbIL9dOH5XdrR03qRuMbshVv1hk7SGPnZlxINz3yS9OE/kx5BIDhufahP250bBdXB2ZbXWQ9Eou7THw2bqmqbm/uAGWK7JdfwgZHqyRXl8GVeqyQy8ChNH4Eq6OWCrC0SnpYWXkcBE3hBNBrYiMQUj36js8TVYbHoIlomWz0Pd7qrWMVNkChCtCLtB2vYfEQ==
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB6873.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(18002099003)(56012099003)(22082099003)(55112099003)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?P5JQXJKImD4QWlOMN1HwJmGYee69e3vw54P1HoCDd8gnjrFuh0XZAh79LbGR?=
 =?us-ascii?Q?8vXeivZgWzWbLla7Zm+HfT3NCuBW0M28bXXxtmGOBvd+NlJFKIlN16e9L+Rc?=
 =?us-ascii?Q?yDmeXiOT6Pe04YlQ50UJlyoxEs9NMjzxlOgdjVjBCVODNpW7gWp6JDiBQ5YH?=
 =?us-ascii?Q?x2AQgUf57b0UA8xtCRuuqOTzYFLJqqQWswh1Kv7fG3Vg0hXkhntFkr2B7Yj5?=
 =?us-ascii?Q?+vnNQPYG5xAQk8hJ4XLDxmsYnm9PcHLy3gkzWrwTPMBmbFLtC/IkUUsQEn+1?=
 =?us-ascii?Q?uXUq8YIC63NfyzouAYhR4ZZm0XAxg1NC8k9lyrOMhwnABUPMCCWFuajL3g9V?=
 =?us-ascii?Q?GB9VfPGVuAx6+iIovj8dVoKnKFCTUTjx2ixBNyrIR1RMLr5MpqJL74qq2+Rg?=
 =?us-ascii?Q?qxsz5R8map2W845K+dmVXiq6hY+bicTDAKqCkxNT0lvt3X0yElfvz91Nsw03?=
 =?us-ascii?Q?tcH6ZWwdxwWKJxtYvrZu1goc599G8AWoYUAetstStiWyhfnSZUtXo/HmGTfw?=
 =?us-ascii?Q?L4BRXD0H6ngRuaud/KPw8x+dveeOqC62EDh75yW0CXrZX03wPl4W7M+M84+K?=
 =?us-ascii?Q?bS4lh+KYsJoC101STd/PXfsFsRRjGSljREU/yRrb4iJ8q4u8eOm9TLAo8IyR?=
 =?us-ascii?Q?X4ayOySWszJDSCljORY5AGKTRZ7P/MFoQvgXdwjczTfb1HDA6Ycr9oWNLTQd?=
 =?us-ascii?Q?Fg8L8SJ/ygoVLv8AgqYUIrL2kqNa0xgH56JNRgXF3ttJHc0oD0+n05Fk0FDs?=
 =?us-ascii?Q?1FHzPQVGVrS5TcSp8QToC/e49HUVFnlQteRy7sFkrEI/Op6BPxxBAWgpc3W0?=
 =?us-ascii?Q?Xyt3edNBXYuFgukN8cTMdyoVddPrIaKXMXl87RmzfGTcxssh/t8wdvzhrG2j?=
 =?us-ascii?Q?YXP/OkQCF4VGuSUSl8IV6xGGSgnc5nhxmVVx/Mh+uiLgd8Shlj4etYuDyIg+?=
 =?us-ascii?Q?v14yCHKCgNTko3cmAsJpbXPec34xNUmWmC26UJ6XG+WB42h0qy0w782m39IW?=
 =?us-ascii?Q?PH/K8mP3Vn/6Fybh7zpXdM18j2wdqnNgn22ka0lS/Q8eDrzuXjnAmPmaJIvz?=
 =?us-ascii?Q?duW07BT8/ptpPm32IgT5q8e65xOZOgGzrDCJgR1H9y9ry5fIfmSWpRjTJpGL?=
 =?us-ascii?Q?8Ri5ah/+ZT5lpOiMX+sAfuA0gpNxEXrzn/oINyLVaixZlYJ7cs6p0ywGuDwV?=
 =?us-ascii?Q?mUAYLnIztGJ57hdO6MvzrMnHPGK2hL540IEJBjPpYkApXLcNcRr7BKOR2Akf?=
 =?us-ascii?Q?gKp+nC9zuLAC+oSHDVko+cGoFdN+aTEHqQzuvl+hPg94KOzp5AlGDzU/xhNk?=
 =?us-ascii?Q?J4z3PK6v9BRD6//Rjv/n0ca1VT3ITHL4z2H/ww8W5lYmlKhFYmq7wPTp9EcP?=
 =?us-ascii?Q?A5tLusUKI1eIvwR4ikRiA87TctIraAfQlVPJm5qmRHr0fiezjV75ESL2k9DO?=
 =?us-ascii?Q?NWbPV3hDYOFtup7RlIh+L5iVVYwPw37hr742RZPdwjzG6iO9wVj9Kj5XPEBw?=
 =?us-ascii?Q?p1YSN6bY3R0dqVn8lCg+xwIEpqn+X3CbnzluzMk3TiQYVqiI/+h5unCc8EnL?=
 =?us-ascii?Q?jPeyzFIuMahZp+yWrPRGyqt83611j121iqFou/x38mhGsgcexGNVQw8G8D8H?=
 =?us-ascii?Q?oyfwjRTwAg/3EUaNo2Sx1qBII31U8q5buvJpoFUaJlQLOSqI+WLcFCxI4oaF?=
 =?us-ascii?Q?GemdGAXEKyl1Y4pzIHfQsz6U+Qu4IDQvn0IIWS1Z73WtoPW/E6GmANLyErhY?=
 =?us-ascii?Q?qv5pWX9aMCVjqtSeFU6TsSh2Rysjtco=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7360a4f6-cbd2-4a06-7671-08dea61206e6
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB6873.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2026 17:09:09.2459
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C8f1JthR+gJn+fl5oWeAKs+3GCNnMEqDKq2kgnfaJuJzkjPJX91zOJdKVkmeA04S7A74VqyaJCa/NyPKZMaCh8nOGXkEICxdSXw/pQNIkYs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR01MB6671
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8DC691C0019
X-Rspam-User: 
X-Stat-Signature: cx3nfidm81eemeta9h1q5rmcjy8gaorp
X-HE-Tag: 1777482672-828016
X-HE-Meta: U2FsdGVkX1+6Gou/eQ7ntKy5j3o9ybT5JGxDf8GhCqqzJ3yYt5lNTcBKQlW4sFVpBWSMFaISbtzvKs2u/bH7+F96kDs3QviWwo99poG6nOTY2vfL92+ZZDB+9t41O6C+tuAW5yiiTmshcXeCM23Jl53EJC79EmOt1VBXViysHJj2GggLDhUDFkKsMezV1n3/SUicMB8kN3wSk9tHxrPmmROlGebqneh20n5QSlBmeiSJcVmSURVSnMqWz2INHBjiyXqIKeGG+dXI4PeHHzACtvfofA6Fxkm5awygJw19IaYYYL4E5YCqu/uxZznUWrf/NZgIy1bn353HA84/nkVyG6dsN6SvSMBWhqnAMEMy7WySj8vlK2mQcs/lI9Ti/b4IBdtgzTrBoPDY9zG5I+NzKRTIm3mXvkYfJWLSKVJbl03zXFcCBEkZ2ABTCJsiJCL+uh9vnuOrFN8ZjzFNOEY8dxd8oKBYZ6zZxdMvUeHAbzYWkc2uDoS64E4AwyM3RhlF3DDLab6WSd4zHtL3+fb0MTwpjpsmeRu1T/9ElkLBNRjD9vpFKbScItxwV7QouFE1HGLXU68l0znRNhmi7FBHr22JlYQIMZV7m8Vkfpvxcrvp5sOf308msR+USu7jnZJXxOvU4cH3yk4K3aZST/WAY++JaGML+9DbG9+kt0NHoHyzT7zWOVAVg9H58o9TaGZQFwaEOWEsoMdF6vp1JnZBtzer8Nd7AgogSUM+CoZgi6tfIBLuxsmemVdneYXi++6ktpLe2+GArSks1mIK1iaRcv1zYDKpH3V9zP8g6XBw6a1r671tUJG4uvpHxJtBEI4uqcv+CuvQ6Od1GGXm8adpENECMdJkmxcQ1LqcAjUDVAjCNShFSC+wATREoOEb9brR0SHMvPFfkPy7izg+YZtPfHJ/St8I9L8p4tIsLTUpd3LOHVS9Rw2tPzdw2VhBS+6w7NF2cDSkjOqWNbtBTNv
 ZlQ5u8ui
 ea+Hjmx2nVrf2UGrBoq3qoiECMwNboZZpU0/EF07i9KzA69XlL04uejX8X0Qb7TjsvIzWg/moVeYUQKs/BGVccRHsTwb2YMGYWo6wt8k9KmSp2YuS6phnr5Qx7LBeleUGs7XEZlwpK78LOvAMDorymJJ6YVgSzcPYJS8PDKvnQOs/Nz7k+mz5wds4y7HkZLQHWcXB9vVevHhmnbNS9ahjQ+2+7bd97SvTCDBat3UXhr60ztWfz8RjhTZvgaIqGbE+/q+c1lveVUc29kr8+y7qh2Uc2+PFdMGwXd8XTctZUggjfrR9JqDcP0p4zggDqnRIkFF5/UORit9n8MupFZ6T6LDg80xPUxOUbRhvqQmLjWpU7WnLQgN/6sE0tpNoXx2qZgupzXovXa0WrUJc3f5sODPJ87xNmRpY3sFdDBFtHEWerGfPGG94unFNQQTtROPVchOw4mTgIRGkTPgbWxCV0AwHQgPVxu/sONzXKofeuDr+xp6XbDOLZolJofxxQmohKF4l
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Allocate local percpu vm area.  The delta between the allocated addr
(chunk local base) and pcpu_local_base must be same with the delta
between chunk base and pcpu_base_addr.  Each CPU's local percpu area
will be mapped to its own page table.  This section of page table is not
shared between CPUs.

And free local percpu vm area.  Also unmap from percpu page table.

Signed-off-by: Yang Shi <yang@os.amperecomputing.com>
---
 include/linux/vmalloc.h |  3 ++
 mm/percpu-internal.h    |  1 +
 mm/percpu-vm.c          | 91 +++++++++++++++++++++++++++++++++++++++++
 mm/vmalloc.c            | 69 ++++++++++++++++++++++++++++---
 4 files changed, 159 insertions(+), 5 deletions(-)

diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index 3b02c0c6b371..4b53992a063c 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -311,6 +311,9 @@ struct vm_struct **pcpu_get_vm_areas(const unsigned long *offsets,
 				     size_t align);
 
 void pcpu_free_vm_areas(struct vm_struct **vms, int nr_vms);
+struct vm_struct *pcpu_get_local_vm_area(unsigned long hint,
+				     int unit_size, size_t align);
+
 # else
 static inline struct vm_struct **
 pcpu_get_vm_areas(const unsigned long *offsets,
diff --git a/mm/percpu-internal.h b/mm/percpu-internal.h
index 64b48b99ac06..2c560e44ee58 100644
--- a/mm/percpu-internal.h
+++ b/mm/percpu-internal.h
@@ -71,6 +71,7 @@ struct pcpu_chunk {
 	struct pcpu_block_md	*md_blocks;	/* metadata blocks */
 
 	void			*data;		/* chunk data */
+	void			*local_data;	/* chunk local vm */
 	bool			immutable;	/* no [de]population allowed */
 	bool			isolated;	/* isolated from active chunk
 						   slots */
diff --git a/mm/percpu-vm.c b/mm/percpu-vm.c
index 4f5937090590..1e6b8fdcab71 100644
--- a/mm/percpu-vm.c
+++ b/mm/percpu-vm.c
@@ -9,6 +9,7 @@
  * This is the default chunk allocator.
  */
 #include "internal.h"
+#include "percpu-internal.h"
 
 static struct page *pcpu_chunk_page(struct pcpu_chunk *chunk,
 				    unsigned int cpu, int page_idx)
@@ -130,6 +131,11 @@ static void pcpu_pre_unmap_flush(struct pcpu_chunk *chunk,
 	flush_cache_vunmap(
 		pcpu_chunk_addr(chunk, pcpu_low_unit_cpu, page_start),
 		pcpu_chunk_addr(chunk, pcpu_high_unit_cpu, page_end));
+
+#ifdef CONFIG_HAVE_LOCAL_PER_CPU_MAP
+	flush_cache_vunmap((unsigned long)chunk->local_base + (page_start << PAGE_SHIFT),
+			(unsigned long)chunk->local_base + (page_end << PAGE_SHIFT));
+#endif
 }
 
 static void __pcpu_unmap_pages(unsigned long addr, int nr_pages)
@@ -137,6 +143,20 @@ static void __pcpu_unmap_pages(unsigned long addr, int nr_pages)
 	vunmap_range_noflush(addr, addr + (nr_pages << PAGE_SHIFT));
 }
 
+#ifdef CONFIG_HAVE_LOCAL_PER_CPU_MAP
+static void __pcpu_unmap_pages_local(pgd_t *pgdir, unsigned long virt,
+			    int nr_pages)
+{
+	__vunmap_range_noflush(pgdir, virt, virt + (nr_pages << PAGE_SHIFT));
+}
+#else
+static void __pcpu_unmap_pages_local(pgd_t *pgdir, unsigned long virt,
+			    int nr_pages)
+{
+	return;
+}
+#endif
+
 /**
  * pcpu_unmap_pages - unmap pages out of a pcpu_chunk
  * @chunk: chunk of interest
@@ -166,6 +186,10 @@ static void pcpu_unmap_pages(struct pcpu_chunk *chunk,
 		}
 		__pcpu_unmap_pages(pcpu_chunk_addr(chunk, cpu, page_start),
 				   page_end - page_start);
+
+		__pcpu_unmap_pages_local(percpu_pgd[cpu],
+					(unsigned long)chunk->local_base + (page_start << PAGE_SHIFT),
+					page_end - page_start);
 	}
 }
 
@@ -188,6 +212,12 @@ static void pcpu_post_unmap_tlb_flush(struct pcpu_chunk *chunk,
 	flush_tlb_kernel_range(
 		pcpu_chunk_addr(chunk, pcpu_low_unit_cpu, page_start),
 		pcpu_chunk_addr(chunk, pcpu_high_unit_cpu, page_end));
+
+#ifdef CONFIG_HAVE_LOCAL_PER_CPU_MAP
+	flush_tlb_kernel_range(
+		(unsigned long)chunk->local_base + (page_start << PAGE_SHIFT),
+		(unsigned long)chunk->local_base + (page_end << PAGE_SHIFT));
+#endif
 }
 
 static int __pcpu_map_pages(unsigned long addr, struct page **pages,
@@ -197,6 +227,32 @@ static int __pcpu_map_pages(unsigned long addr, struct page **pages,
 			PAGE_KERNEL, pages, PAGE_SHIFT, GFP_KERNEL);
 }
 
+#ifdef CONFIG_HAVE_LOCAL_PER_CPU_MAP
+static int __pcpu_map_pages_local(pgd_t *pgdir, unsigned long virt, struct page **pages,
+			    int nr_pages)
+{
+	unsigned int i;
+	int err = 0;
+
+	for (i = 0; i < nr_pages; i++) {
+		err = vmap_range_noflush(pgdir, virt, virt + PAGE_SIZE,
+				page_to_phys(pages[i]), PAGE_KERNEL, PAGE_SHIFT);
+		if (err)
+			return err;
+
+		virt += PAGE_SIZE;
+	}
+
+	return err;
+}
+#else
+static int __pcpu_map_pages_local(pgd_t *pgdir, unsigned long virt, struct page **pages,
+			    int nr_pages)
+{
+	return 0;
+}
+#endif
+
 /**
  * pcpu_map_pages - map pages into a pcpu_chunk
  * @chunk: chunk of interest
@@ -224,6 +280,13 @@ static int pcpu_map_pages(struct pcpu_chunk *chunk,
 		if (err < 0)
 			goto err;
 
+		err = __pcpu_map_pages_local(percpu_pgd[cpu],
+					(unsigned long)chunk->local_base + (page_start << PAGE_SHIFT),
+					&pages[pcpu_page_idx(cpu, page_start)],
+					page_end - page_start);
+		if (err < 0)
+			goto err;
+
 		for (i = page_start; i < page_end; i++)
 			pcpu_set_page_chunk(pages[pcpu_page_idx(cpu, i)],
 					    chunk);
@@ -233,6 +296,9 @@ static int pcpu_map_pages(struct pcpu_chunk *chunk,
 	for_each_possible_cpu(tcpu) {
 		__pcpu_unmap_pages(pcpu_chunk_addr(chunk, tcpu, page_start),
 				   page_end - page_start);
+		__pcpu_unmap_pages_local(percpu_pgd[cpu],
+					(unsigned long)chunk->local_base + (page_start << PAGE_SHIFT),
+					page_end - page_start);
 		if (tcpu == cpu)
 			break;
 	}
@@ -258,6 +324,11 @@ static void pcpu_post_map_flush(struct pcpu_chunk *chunk,
 	flush_cache_vmap(
 		pcpu_chunk_addr(chunk, pcpu_low_unit_cpu, page_start),
 		pcpu_chunk_addr(chunk, pcpu_high_unit_cpu, page_end));
+
+#ifdef CONFIG_HAVE_LOCAL_PER_CPU_MAP
+	flush_cache_vmap((unsigned long)chunk->local_base + (page_start << PAGE_SHIFT),
+			 (unsigned long)chunk->local_base + (page_end << PAGE_SHIFT));
+#endif
 }
 
 /**
@@ -349,6 +420,24 @@ static struct pcpu_chunk *pcpu_create_chunk(gfp_t gfp)
 	chunk->data = vms;
 	chunk->base_addr = vms[0]->addr - pcpu_group_offsets[0];
 
+#ifdef CONFIG_HAVE_LOCAL_PER_CPU_MAP
+	unsigned long delta = (unsigned long)chunk->base_addr - (unsigned long)pcpu_base_addr;
+	unsigned long hint = delta + (unsigned long)pcpu_local_base;
+	struct vm_struct *local_vm = pcpu_get_local_vm_area(hint,
+					pcpu_unit_size, pcpu_atom_size);
+	if (!local_vm) {
+		pcpu_free_vm_areas(vms, pcpu_nr_groups);
+		pcpu_free_chunk(chunk);
+		return NULL;
+	}
+
+	chunk->local_base = local_vm->addr;
+	chunk->local_data = (void *)local_vm;
+#else
+	chunk->local_base = 0;
+	chunk->local_data = NULL;
+#endif
+
 	pcpu_stats_chunk_alloc();
 	trace_percpu_create_chunk(chunk->base_addr);
 
@@ -365,6 +454,8 @@ static void pcpu_destroy_chunk(struct pcpu_chunk *chunk)
 
 	if (chunk->data)
 		pcpu_free_vm_areas(chunk->data, pcpu_nr_groups);
+	if (chunk->local_data)
+		free_vm_area((struct vm_struct *)chunk->local_data);
 	pcpu_free_chunk(chunk);
 }
 
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 8ef7d9987e18..f224ffec5696 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -4836,17 +4836,21 @@ pvm_find_va_enclose_addr(unsigned long addr)
  *   in - the VA we start the search(reverse order);
  *   out - the VA with the highest aligned end address.
  * @align: alignment for required highest address
+ * @pcpu: whether request allocation from local percpu area
  *
  * Returns: determined end address within vmap_area
  */
 static unsigned long
-pvm_determine_end_from_reverse(struct vmap_area **va, unsigned long align)
+pvm_determine_end_from_reverse(struct vmap_area **va, unsigned long align, bool pcpu)
 {
 	unsigned long vmalloc_end;
 	unsigned long addr;
 
 #ifdef CONFIG_HAVE_LOCAL_PER_CPU_MAP
-	vmalloc_end = PERCPU_END & ~(align - 1);
+	if (pcpu)
+		vmalloc_end = LOCAL_PERCPU_END & ~(align - 1);
+	else
+		vmalloc_end = PERCPU_END & ~(align - 1);
 #else
 	vmalloc_end = VMALLOC_END & ~(align - 1);
 #endif
@@ -4955,7 +4959,7 @@ struct vm_struct **pcpu_get_vm_areas(const unsigned long *offsets,
 	end = start + sizes[area];
 
 	va = pvm_find_va_enclose_addr(vmalloc_end);
-	base = pvm_determine_end_from_reverse(&va, align) - end;
+	base = pvm_determine_end_from_reverse(&va, align, false) - end;
 
 	while (true) {
 		/*
@@ -4976,7 +4980,7 @@ struct vm_struct **pcpu_get_vm_areas(const unsigned long *offsets,
 		 * base downwards and then recheck.
 		 */
 		if (base + end > va->va_end) {
-			base = pvm_determine_end_from_reverse(&va, align) - end;
+			base = pvm_determine_end_from_reverse(&va, align, false) - end;
 			term_area = area;
 			continue;
 		}
@@ -4986,7 +4990,7 @@ struct vm_struct **pcpu_get_vm_areas(const unsigned long *offsets,
 		 */
 		if (base + start < va->va_start) {
 			va = node_to_va(rb_prev(&va->rb_node));
-			base = pvm_determine_end_from_reverse(&va, align) - end;
+			base = pvm_determine_end_from_reverse(&va, align, false) - end;
 			term_area = area;
 			continue;
 		}
@@ -5149,6 +5153,61 @@ void pcpu_free_vm_areas(struct vm_struct **vms, int nr_vms)
 		free_vm_area(vms[i]);
 	kfree(vms);
 }
+
+#ifdef CONFIG_HAVE_LOCAL_PER_CPU_MAP
+/* Find free vm area starts from hint */
+struct vm_struct *pcpu_get_local_vm_area(unsigned long hint,
+				     int unit_size, size_t align)
+{
+	struct vmap_area *tmp_va, *va;
+	struct vm_struct *vm;
+	struct vmap_node *vn;
+	unsigned long end;
+	int ret;
+
+	va = kmem_cache_zalloc(vmap_area_cachep, GFP_KERNEL);
+	vm = kzalloc(sizeof(struct vm_struct), GFP_KERNEL);
+	if (!va || !vm)
+		goto err_free;
+
+	spin_lock(&free_vmap_area_lock);
+
+	tmp_va = pvm_find_va_enclose_addr(hint);
+	if (!tmp_va)
+		return NULL;
+
+	end = pvm_determine_end_from_reverse(&tmp_va, align, true);
+
+	if (hint + unit_size > end)
+		return NULL;
+
+	ret = va_clip(&free_vmap_area_root,
+			&free_vmap_area_list, tmp_va, hint, unit_size);
+	if (ret)
+		return NULL;
+
+	va->va_start = hint;
+	va->va_end = hint + unit_size;
+
+	spin_unlock(&free_vmap_area_lock);
+
+	vn = addr_to_node(va->va_start);
+
+	spin_lock(&vn->busy.lock);
+	insert_vmap_area(va, &vn->busy.root, &vn->busy.head);
+	setup_vmalloc_vm(vm, va, VM_ALLOC,
+			 pcpu_get_local_vm_area);
+	spin_unlock(&vn->busy.lock);
+
+	return vm;
+
+err_free:
+	kmem_cache_free(vmap_area_cachep, va);
+	kfree(vm);
+
+	return NULL;
+}
+#endif
 #endif	/* CONFIG_SMP */
 
 #ifdef CONFIG_PRINTK
-- 
2.47.0


