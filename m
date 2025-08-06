Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4C24C87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 19:22:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B0AA6B00A2; Wed,  6 Aug 2025 15:22:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 260CF6B00A4; Wed,  6 Aug 2025 15:22:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 102416B00A2; Wed,  6 Aug 2025 15:22:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ED9E16B00A3
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 15:22:30 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A9FC05AC14
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 19:22:30 +0000 (UTC)
X-FDA: 83747304060.04.5C21884
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2088.outbound.protection.outlook.com [40.107.93.88])
	by imf29.hostedemail.com (Postfix) with ESMTP id F1F81120005
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 19:22:27 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=aTMNFQA2;
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 40.107.93.88 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754508148; a=rsa-sha256;
	cv=pass;
	b=DSD2VLNflE4i54YmxTj7expgWBtmkptfJh51YW2Focb73TmXlbNhovuK1LorwbwLMmkct4
	lxurZ9KfyVxw2abKjLr25mouX7sRlSW5UsZIX2itTIv8e4lyeDCHKLiu72H2RPlYFNXca5
	YlxieuAgFxgHhLzLCOWNfthfJhsqt+Y=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=aTMNFQA2;
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 40.107.93.88 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754508148;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mxINivbthbAJriWFfgkKCieAdI1XZjhlX98+DBtTnFI=;
	b=DTup5lTVsEhEKeTU1H56CHCgrqAJGxr/KSLju/ageSKviIgwgaIqFlw9dtW8smUxrsx2c/
	35oWRteUha3apZM12KttjSqacgkKx1eibA/kJkNFQkqLaLCoXnVDjBEz8psDysWCxBiX3R
	yIxklvxALq5nMuv6L4GIncd65uszIg4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LSCvAuoMUbJyP3jY1ca1botSTUTWTryjN4dHUxCqsXlKpEKWpiONqzeV8MxnsJAWnpUVdgEHry6Yxr+6mmA40n23FpteRhfnAeX4vNHfppmWvGpORf8pkETamTlc5ZH8nl/5y2ZGwSvsgOOtYTWjrNlgDrs+qL+g+Y0L23Hb/rTAy3hSpzZpCaDQToquqGVRwwV7xAcpGGwVX8PwfiAHpbwEGoe/iu/U0Nwk4zsDjjGy57jDaV/tS92xRr5ccmNA8ZsG+u7Or7jhHd7dVkbGnGrFHADvpG5Z1hCtVv+RjwD5bUNV4vf79l8dROKEcl+llQXADPt9Vy3krn4D9GZgrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mxINivbthbAJriWFfgkKCieAdI1XZjhlX98+DBtTnFI=;
 b=Rjf1nDD3C5p0qkD+2P7Kpw4XeJ/TVvKu0YigEqewq0xPqFnbBQmcZptExnDsMeQVi7xbExfVxG29MnfiFjjUwPIl4trde7j1mJb00YWF4NNqAiWT3SQpSUMHNTIcKMpDIb4VO3zYyEhIxncQDSUM6JXKyhXWGVof2bm+LDL+e7BaT/G0t/J9jbsBkuehcofJNh084YLFqRaZx/a5i4QBfGKdnIcf8dY7EtOEVaAe8HUR6MuE7B1dHLntt+v51KPsRvfqYBhSY7EQkHL4B8TigbMlP01B19SgWoqhqNY0XLm/FBAcjw0+KlVgEONzRBmmAyErpABgEcxl4ab1XrxVAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mxINivbthbAJriWFfgkKCieAdI1XZjhlX98+DBtTnFI=;
 b=aTMNFQA2NTs/ID/gJ7wNJ+FpOmiSKJTrrC6yCFB3jxEKKAP9aDnIlC9lRhXnPZhFBex5d1uw4hec00E7WwExEyyGK1XcOhhSa3BDxAhFsB+VzPXWg0SE93w+m/ZAQpdzE+iKxjzoiUrvAjCdslcbJkCIrywBkaVh77O79gxCNXxzy+R6tTlZNQxLy6L24jvId7I+6oNezL88eX22fsE3o38EJU4ZJo7pEHcqh7BYSxcVSa69KZrL5l2i3478M3diIu2hkXm49651wYorbp4FTjfXPLEUUTtBgK4025E8oYAaVW9Jdf/1PhAuPYIrt3Bn4X5F324+qpBFTr+twfFbLQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH7PR12MB7356.namprd12.prod.outlook.com (2603:10b6:510:20f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.23; Wed, 6 Aug
 2025 19:22:23 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9009.013; Wed, 6 Aug 2025
 19:22:23 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: [PATCH 07/11] mm: Introduce memdesc_is_zone_device()
Date: Wed, 06 Aug 2025 15:22:21 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <6FF612C9-748B-49FC-8451-100B549C9A94@nvidia.com>
In-Reply-To: <20250805172307.1302730-8-willy@infradead.org>
References: <20250805172307.1302730-1-willy@infradead.org>
 <20250805172307.1302730-8-willy@infradead.org>
Content-Type: text/plain
X-ClientProxiedBy: BL0PR02CA0062.namprd02.prod.outlook.com
 (2603:10b6:207:3d::39) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH7PR12MB7356:EE_
X-MS-Office365-Filtering-Correlation-Id: 3fdf259f-e5b0-4238-bf22-08ddd51e91ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8Mv/fxyyMFetUdTO0kXinWizXz7RMJk++dbudCs/7KcJEDwyCr8Q/fvzMinf?=
 =?us-ascii?Q?lJJ/hJ56uoghRp8DyNRgZIK+KgaerdHkhUsEVe1+6oaoaJo62iwffre4d44w?=
 =?us-ascii?Q?+357FdYLAN9GIBwqWGUh+kxorMxRODb+xksWKLfnWShnGjtHBWlIzXQTV1hb?=
 =?us-ascii?Q?jkHOGLZkV/wyJTY3Y3Ozx9tL0Wui15hXLB4MdPSUKUNWIly0wufO1XNanWcX?=
 =?us-ascii?Q?9DhD86dsWG3OH0RFqpxf8Y3fWluUKuiU/RZvpYX3KLYrQ0HfH6p2cj5nUobu?=
 =?us-ascii?Q?Wf9JeCjayQfUYpp+7gYv9CS4bMDqazQVdXtMsH4lpm1Xl7vF2RSMLbAcTuWJ?=
 =?us-ascii?Q?kUrJPd9OC8VGNAeTkMSEP30mvF2y3gLW0wYdWJuvTsjOdI+iTCw1neJYWCeo?=
 =?us-ascii?Q?x2YBdLe34hk4iEOVByjvaWCX0fbvK2FXegTl9hyhMc0/e1pZMQ/KhJKRu8R+?=
 =?us-ascii?Q?3ZI8UFfrXTOpHlxYgHG9qcbLx/fByYcn+y4MqoalWeJEQ+HaPtKbGWLCyEPn?=
 =?us-ascii?Q?OiixViLg7A2F8jdApRorHF2MwgXIPCMn8equ7aXX17CL4haJO6//4LogUWKO?=
 =?us-ascii?Q?rTADY7JT0RM6rYPp4x35NcFK1Wm5sr7hdxjweeYYn4N8E4pCjCsHnsHdoDSw?=
 =?us-ascii?Q?ObInRGFTEjfChxTyN1h2ntsPmIx0D2YQ8nR4GaGklIo+ZoLGU+38PYh8bV1t?=
 =?us-ascii?Q?RGlPAXsKGvVHpMESm5l3Azrg83UTVc+ZuRv8Q1n3oniecnWvVvXbcEeggKOk?=
 =?us-ascii?Q?27UX5WfkwGTDETGqdwwZfeDH8KW7xY9H+HEhIuEWgM0XgKpmft0jRIG/YrWq?=
 =?us-ascii?Q?TVJDStmoBKodUQStXO1KObErxejDAKClqeDqXmZ/vKUPpFPq4Xh44I+SVDVM?=
 =?us-ascii?Q?kLFqDrdSNfGJdlU7aiM96OjWlrfoAVhRGwqKqZ+nZ1zPErwnsqF/3YHbYJmA?=
 =?us-ascii?Q?KOvt/3pKqdJz6dz61pq8tcXcrXk2WJ7YLLtt6jt6ArWc2aYVOMbOCZ9lmrdL?=
 =?us-ascii?Q?StC35/ouFvZIXETDcjucfiRwblh3qrBJGUZ8d2AbijBmRwhOEhmHMZho/gjz?=
 =?us-ascii?Q?T8bJkARwm9/xDOXZEejJytNcq2PtVpnXyKS0JyH6dfC+86Bcu8y6Rmc0r8gR?=
 =?us-ascii?Q?QWrXH6e5dntvBnT/VOxyppBLU8tDnbD4IIzD7x5oTS6M4vqYKUsnO5la8sDH?=
 =?us-ascii?Q?J0e12x/dfS/jH9fJgmOnm/uxOofjcK8TB8PKMVrxXNoJZx5Wqtgf844kKs0V?=
 =?us-ascii?Q?03Nu9NRvUsHwtiQWNIRPYDbASR0gSsM5UvaG1jOXhaFEjbNlosKwecL63Fqc?=
 =?us-ascii?Q?Vd073W+fUcntzMlYX65mxJ0+WlPhwr84fzMwnG1RDdgzVIlXVBA1koDMk95r?=
 =?us-ascii?Q?5Z0WaF/dKgjmCrU+9EbnIP2uSDgJvBC7IG11jZ1ohbSHDutOKOGwssy9ply/?=
 =?us-ascii?Q?bj0ZLk/I3WE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KBiTXYRwjiOhNwJeEtM0+Wq1yn1YMaDZ09MQah/Sb2c0PPRqeqVXK26GWM7P?=
 =?us-ascii?Q?xJbbZFB5r3CTx9k2bxlns1PxNDrhg3dvfUdwaZvuyXRg4m9vNvniBAd+qgLG?=
 =?us-ascii?Q?sjZfpXc5qHM/tsd8W0xBCHAuS4KE7mv3gd57ZXShfPrr51A1V4O1EB6p9L3y?=
 =?us-ascii?Q?E0pnofS50YqdhqBijizdSUpD1iW6T9siswB2BRjVfQIufAgVEd7RZL10Choh?=
 =?us-ascii?Q?fdF57E8L8Gc7AbGD4HW0wPo/Pw8CoOscILzn0b4stVZtYv+sHrAIBeSbPjh1?=
 =?us-ascii?Q?TeeA8L5hYXC7m+3aeUKjxV08QpBXyYLPrUc+E/pzGNfsmrDDF3a7XMg38uGK?=
 =?us-ascii?Q?KQbd3YmbbFSV8O7MGIvoOZyOrs99D2Xf3fLtryNttlkceVosbsWYc9V7H92/?=
 =?us-ascii?Q?51J1GxbZs+lAJQisLaxv39HpbNzOhacQZJZGLRVzsREzCvx864u7u9IvMjyq?=
 =?us-ascii?Q?azL5HvwKRSK10zhHnpG8JYFjw45ck8b4mS80xZYLx9s9MrauvDSA0vXtYvL/?=
 =?us-ascii?Q?om9aGSKMmB5X4UqDdoQEENUhydET8yZUqRY8cIZVdy4rK3uI8+VqizAM/lOo?=
 =?us-ascii?Q?tK8pkTEp6H3BtF/ISUo5RZhlchkCCm28nGjb9MHuPxNgb+GhIAsy1J1X15B9?=
 =?us-ascii?Q?AHdNlCbodz95vnhokgGOnJtEkfY67mzQc8wiOvuOZvZg9uEpyBlE92fTcSSG?=
 =?us-ascii?Q?C5C9TFdWHgYn8mlEyfhN3KJ49rWy1k54CDy/fJqqPGv3GMh/0fveo/uoonBw?=
 =?us-ascii?Q?DtFF8gNffFJ5G5u71G2i84IoOf+BqAxTZq+2MnNxdlkv+5pPQhV261qBmZcz?=
 =?us-ascii?Q?MLkOEZPEFbGtVycPsUtk2ki7HHocpR4YywQv7qsVf+Cifha0s41/E0OLF5tV?=
 =?us-ascii?Q?NnK2/jAAH5ResfR6ZuYhLwezFUsHcEjLqXa7B5dod2XPd5qb9sBSuizvJe6A?=
 =?us-ascii?Q?BAoRzjCzDveEcprQnis/sdtZbHwQRocEdM3itYDQ8XB02ehWAcpRv+iBth0t?=
 =?us-ascii?Q?FnI7zsk0ZVmLDVXjRH8iGNNoVVsEhrx8lXYFQU2Uru+WL02baf4/RpcXyGVe?=
 =?us-ascii?Q?NM+ly6TVuTtEtHxaBMk0MikjB8grfpVR7b76ViJxTuuy4VvufYdxZLtSIV0j?=
 =?us-ascii?Q?7QCsfKAt1cQn5L3vd6J7950R27EE7WGVA50xhcQrfAOHrKAGerf5cSd9nZwF?=
 =?us-ascii?Q?vvN9Sa/ytzqPpfPj8O/kGFidYk2VeQwju0CgWZ05cyhlwweKeOwmmpWRGCne?=
 =?us-ascii?Q?ELDd2RNu0jRijlXBMoAHz/gido+TcaGuPKHk4ruYghg0nKOxA7ZDAFdmbtaQ?=
 =?us-ascii?Q?wvXNjbLeaxMH1YFb7HerfC4SCNRJVKvW1G3km1UKTifuO+fxZvlibnyr825M?=
 =?us-ascii?Q?0rhYQjZ8SRv6peUwolr0V7AJwhPj20wzovLty+VKi0gRGl9lU06TnjML+I9B?=
 =?us-ascii?Q?+O+U9QSTFz78UIn235eyps66zA52TWR/EsnJ/51FwwyKzbde3xj1IjvNE6vw?=
 =?us-ascii?Q?aqmjEjI8dzkiAlur1r6rmspskYQcibySsMzaCbtUW4SKmNzaSi1n1R6Og2Et?=
 =?us-ascii?Q?7xJR6vstWurk7Ig2/keiIMGM/IeOrpgg+gI4Sj2p?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fdf259f-e5b0-4238-bf22-08ddd51e91ee
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2025 19:22:23.1689
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BWp0UwvFbYF//Bgg31bLh6EnkUljAWAi8sc3CEAKj7QJY+1vAwoTmt0OyMQCT+Oa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7356
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F1F81120005
X-Stat-Signature: qmwydms18ca1gc5qm53zdzos7h7mmn1q
X-HE-Tag: 1754508147-981520
X-HE-Meta: U2FsdGVkX194b6M+cGa4ky3LzBkT5b/pKEOqyZ3ByePESdBgkpikX8joUuVn+no2zpndGMN4WvxjoFAYM5llcB2SfUMQTz+ftg6TfSri4zNppnwsNlj9Gx+6lII9M5l894rZUCrquKpw2KJ9UwcHafkVp8wvlYaqBFIKXifspRUGKBy91Qk3HJaAk2NBQfR/Lb8wtEMxax/LriV+X6f9QfAmKUTnBcA+XSiv2THcUrNsSmRbPSUzxzzHL9oUoC9H7yvvAHeJsQm0KSo6BYTXEYX7QLb87KkZnvHmYuL42XuCqtGBRcigiqyfKgqZ+bwkzRWkIS6uPSRUvVY2vbAHsBwcMeQlr1UjjrZBPF/JmiWEsO0QGPSFqhC7nE3Bj3CbaPZtKIGu7hi2SOvayvkR49O89Jhky3T2gA7mx64xnvFmyCx6LdZz/TqsLs3CbRUwJ4rjLOa4n7+HjUAh1aSuHzwk5vJQjeh5PAQzSoK78BS4WmtUNSLL3OJoyEj5DJpoJfnKDgc4hUpcJC7MHe+IxCR65Y+e+S/UtaigW6fNE06u93Ud0ATCZ5aUBszBShuR8zHBGlvXNF9ZS7wvzsqdiAYmgL+UXBMz1fgSBooULQ4C1fqeGKM2MgIUq//tbLiq+uJVfK5EN1TfXTWQfsjDX9/F+Ogu68lTUTHVu6BvLVsni0TamuWcHbK94Sa0OsXZFaRSnHj9XUMCNBwNgm0Id3zJ0HHdood+5jWPUbTldlptke+6AO80vYdB6HP9vyNII/K1T2g5i9Z2xM6GX3n5DPfOaAEgscn5Kg6S9GTbqzVq3QxUS1Krp0CMGrd85/m2wNKJJPIYIgY0lRwnY+u0MO7qwMcFQ1LE2tdeQMC1faBkMdnZ0tCYHG6IZ7WQyE6AhLtk9daKoUVf5Atd5HnGfDcCOkcbtIwHTYSf1aPi+4VwJWDr9js/NH7V8mSoDSq+GnxAIWiZIAWFLKVMJgP
 6kWPEziX
 jxFIYMVwvJJycF02RmmgYXqgQPh2v2F940S8j77ZXC6R4rOdqQ/0Qcfg4M2s1M0r7F7gET4BQKl3u3ofiRxUfvRlmhl6vmfrrI0UgRBtz4SHei1jk/eFXX8uF4hIzFfXt4QNuF0U3spILw3WbGmfu/bZ+tlaVu4xhTDdanVRtP+En89j4h6vAtOiGYpjXDOD9KE2IdU2R4nKPXI+Pn4Kij/+XsXB2rNm9sAGR0GHjWlpUbRQL6L014LpdGmR5qQzRT8Hzm9Twljtp0ZN1x2PVmK5sONXjNPHfz3lctntRdpNfmC7ObK+C1j9NXRVOH8WWo9JEp2GHIgeSjrjrvAXZ0lN/BXMZkxstGokIYXJpdzhDhccgO5p2IWP6EMitxsU/PUK7XkUclGAEh4RlZ5ZhMXTGMA6uD5e4RMfygkePBoWWuowNbfMev01wxALV8l3k8EkR0NrbPI0do2GVA+Mx2IInfHpiYLP1qf8naTUs7qwXCYJUSqV5vpSG/mxGs0eqE9xY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5 Aug 2025, at 13:22, Matthew Wilcox (Oracle) wrote:

> Remove the conversion from folio to page in folio_is_zone_device()
> by introducing memdesc_is_zone_device() which takes a memdesc_flags_t
> from either a page or a folio.
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  include/linux/mmzone.h | 19 ++++++++++++-------
>  1 file changed, 12 insertions(+), 7 deletions(-)
>

LGTM. Reviewed-by: Zi Yan <ziy@nvidia.com>

--
Best Regards,
Yan, Zi

