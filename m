Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D361BCD4851
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 05:50:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 417D26B009E; Fri, 15 May 2026 01:50:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C8B96B009F; Fri, 15 May 2026 01:50:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B7556B00A0; Fri, 15 May 2026 01:50:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1BDF86B009E
	for <linux-mm@kvack.org>; Fri, 15 May 2026 01:50:44 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id ADDB31A086B
	for <linux-mm@kvack.org>; Fri, 15 May 2026 05:50:43 +0000 (UTC)
X-FDA: 84768579966.17.F8B8BC4
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011067.outbound.protection.outlook.com [40.93.194.67])
	by imf25.hostedemail.com (Postfix) with ESMTP id DCCEDA0009
	for <linux-mm@kvack.org>; Fri, 15 May 2026 05:50:40 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ThtPa0MD;
	spf=pass (imf25.hostedemail.com: domain of apopple@nvidia.com designates 40.93.194.67 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778824241;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xHcfokJ/S69O0PYCRmfwfgiI7HRJGjr8fs2A1RKh5ig=;
	b=cuBVRwtEn0yuX0jj1JbJaM5ymAmF0VJ8sRhmaD7jP9igfATmcGxmjhv8ScQw8AjjD0AS7p
	WhptP8ESZ4zduoSww4k4KbscdvintmcMvl9ZuYiUWF91QdEM9eKvwu74yIggdPdTmrJI3x
	VBAl4BxVuB+MhgtdSY4CZx6NsCgRFPQ=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ThtPa0MD;
	spf=pass (imf25.hostedemail.com: domain of apopple@nvidia.com designates 40.93.194.67 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778824241; a=rsa-sha256;
	cv=fail;
	b=3uEhMlTX/jYJscDvDynqK+5MW8wumMTy99tdhVSd/+VEXtl+3D3swOe+uZFuOf4kcYRW5/
	SMzgNJWrJszYBRtV5fevNLKjbV6fE7DMhCFDKhoMsT1uH1Iviuf80bWkQmheMpdwIaoMou
	qBpBaTYjoDr4/bz0b8T917u9pXaPCMM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XJnvOyJovVFgpdjRQ/0Xd1lg3iTrjTYSZ2Fqxn9br2HH1QDDSE1uiHUeOKI5UCQwVRDMFv0+tpXpLzV5eri2OLuXQDQN+Y4z/0RYOZ2XuetKFP6QUESd7ORChkRReUsdcYZgaWpUHeOg1v4imX1Zc6ql+0F07EDIKbOq/UT/KmpFLECCJfiZUBmZNPZVbZdV57B/BstJG+1v+YKDAuRtPCRvgiXPgf86dTq5H03/0potN4p3GgiS5MPmdvVtvzKDD4v8bft34GNBLJq6ebH4XwIErG4RHNFRD0w1UigzYT4qxFeaFfMsze9SlWkpgj7R0uXX6pbzUcqcJBqJO72NDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xHcfokJ/S69O0PYCRmfwfgiI7HRJGjr8fs2A1RKh5ig=;
 b=NEkSwTJcI6tgn21vg8Hdy+w27Xba1dPghQuf1eZJKBgYSUoxJtlTT2mR8GxD0bsUfagl4Ry72oy9I6kkfhXL5vvXRFg6saifsZ6zglXf9yMOdfmTdrwECMhGivbv0DF4Vlb93z0Wdd/qtukZi4e3k3/ypxk2VB2EfVNPcWUrQSxyumRq/i2faHThuHShM+ycvVdGLTr55qxxFXgCnOR4R7VAbk51IpsDv1E/VziwO9eTYXb1wRildiUVT95NalQKm6X6M0qA/ru0qydtzHhEW2V/+PLYR4MezB7K99ceaqWUTGBMFIdW2cdnLGNss0RY4JwoRDqQtPLmVR6bwzyu7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xHcfokJ/S69O0PYCRmfwfgiI7HRJGjr8fs2A1RKh5ig=;
 b=ThtPa0MDg+X9FvQlPQqjrJCgO8v/AMemVtJcjmTRBseDf7YQml7U6z8jZ/V99M2afZMRVydsuCj4gww5beeJDoa9abWHyLWWmv1xSMHYsRJ2obvfrIwDUL2woKWPkZgNFJFDkmGpSpy4HHN9zJqAx2m74avazMckoUIkJvs9rJizPwCIwCQvpLKtXKxrRi+FxpEUdoGhVKabYgZm+gHBs0tlIXuA6hvxT3Z9CJdbcoeNzUXA0RvplwQ0QGXU4+x7n6LhLD7INMXjJCiF4RITYXCTeJ9RYbr0fyJt3O0tf7akWLJ2+sWlA31c3gXH5ZdR3Ricxuv7Tk8+5QdjytlCAQ==
Received: from DS0PR12MB7726.namprd12.prod.outlook.com (2603:10b6:8:130::6) by
 MW6PR12MB7086.namprd12.prod.outlook.com (2603:10b6:303:238::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.18; Fri, 15 May
 2026 05:50:32 +0000
Received: from DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0]) by DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0%4]) with mapi id 15.20.9913.009; Fri, 15 May 2026
 05:50:32 +0000
Date: Fri, 15 May 2026 15:50:26 +1000
From: Alistair Popple <apopple@nvidia.com>
To: liuqiangneo@163.com
Cc: jgg@ziepe.ca, leon@kernel.org, akpm@linux-foundation.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, Qiang Liu <liuqiang@kylinos.cn>
Subject: Re: [PATCH] lib/test_hmm: Check alloc_page_vma() return value
Message-ID: <agayR-p7WbncrRCf@nvdebian.thelocal>
References: <20260514032345.32256-1-liuqiangneo@163.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260514032345.32256-1-liuqiangneo@163.com>
X-ClientProxiedBy: SY5P300CA0072.AUSP300.PROD.OUTLOOK.COM
 (2603:10c6:10:247::9) To DS0PR12MB7726.namprd12.prod.outlook.com
 (2603:10b6:8:130::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7726:EE_|MW6PR12MB7086:EE_
X-MS-Office365-Filtering-Correlation-Id: 2059bbe7-f1e8-4d2f-9668-08deb245e05f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|11063799003|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	uchAtQ1ArWMLrVD4746dFvQ3kLZ7izlKyWRjipF3XBWhBhuGc7g8djzAuG48+v5tng75qvpZJlqnpDtbcyFmb3mbTHMJkKeT8OOVOe7zio9+cg43+s4UBDnQs9SIq90TW9BetUreUyA3yk4QVGdwPI/ewk5bwJgGTCDMWOeEFjxE+ruWbBu7bGsi5GR6CV3T70HYXodSfnpbPdN0g/9CVzPHUzZ+ZH9mHTNHdqKI5RFxdDOFZlKz3g4GESaM7XFZ92CMeXwxmRvjPjgxUeEo5SCtRJmBtzENI6/xWWC8nZazR7tKCSGjD1lonTPEYb4SkwmZRljBEzW1UVnm9OZmSBtCyWGQYfVrE1EniXnZTB5juirXg27aCLnpktfgsC+WGwiCHDYLqxlKXGP2tYSagi0y+lKNmgAVMkk9l1nA5qk5XKVbP+sTlx495uBHbXOw7h6JCqbyKIFJ4woPqsLBItO0nZrDpZyF5t7bTb5NQIYnst5T00OConKr3seRkckKzODol268eK9Re9jM1q8XvQmsNJK1BmvIHhU0+q+7RdLcovTGaJ5eRFWsjQQzGXCHSLnF1vQEVav40M+I8wVGRxJAFxch0/3moBGEMnkBDmpv+Yee5Pa4V/ZWy2C9lxqo32kShyRRzFBlrnxxt2C1+Njd0ZsZrIiEy5x5vMXWD6eeFAJ+RO//c4ktZoMIsgMv
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7726.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(11063799003)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gR+NNHcMml9uJPjBIXBbYhtfxF3kdaJPftpo6cotiPWE7oFs9AwWAQnmOkrK?=
 =?us-ascii?Q?5YFOKmziWahuhEI7r1pviDr7Mj2Qea9k0pg6+R/GsR3uhl3K86H+IsjhF/4D?=
 =?us-ascii?Q?0jiG/H0pMh8zXl9YeYqzYsDkO8UdlDqLgBAF1qrEVxCA0EVppN4sFgoYym4h?=
 =?us-ascii?Q?ezfLvoOyAHta0r+EDdD59dE03h4ngcXakOB6K14YePXOQuxhpwml3MuY9VNa?=
 =?us-ascii?Q?EOMIdoN/7eZh5f6VdLVUqf3y5lVAExgMoZJxvCbnO223JW/R/rFJ6r/kCBVG?=
 =?us-ascii?Q?KE54u6fnD3q2ElHWBA7W8Hk1S0ASSOVhp7gkFZW9XksO1/Tj8n/wPdR+1AbS?=
 =?us-ascii?Q?kaFJLzs1UX+guPBNPdp2Es7DJLcJH3zZxl8ceqsdeChJ5eOV7iTNBRG3SNNn?=
 =?us-ascii?Q?4iJPXAEWMmx5Y82r5v9SxpnIe3mwRbn5MWl1MhWEdRnfEahT7+QbNgHr6ENY?=
 =?us-ascii?Q?x19NRVapogPCXmiSvW1iGxBBavF07N58f8eKEzRj9GB5re+KUcMESMWV4skt?=
 =?us-ascii?Q?cD6M2AgYa7iTejq3PDAPtrEqjFtUPWDDgBIFOCMvMj0RFq/9VMhfmeBZPsCV?=
 =?us-ascii?Q?4yqwySA1XDD00cZF5RSlAnP7lQdcBtpRl0FR3BLoqeVTevtxLQpwSxnJj/bV?=
 =?us-ascii?Q?/PDIG8RI7oO12C6YPWd8blKI0KgKpc8ktSldZqb//VCP6fV+znkF8fGyuL3f?=
 =?us-ascii?Q?YS3E5KkgXXjfGVnUPO0ctBTJtj3Bxi2bThAcVrXeVyKklYlQff+BTvOpvraK?=
 =?us-ascii?Q?rNhlvGSuA8NXueq6TKROQNtQNQIJZ/TA5GwXiEonJd96vSCFN+Xn42usAHpd?=
 =?us-ascii?Q?I1nbQay2vCotBES5iIadIVKnTaM8JwU37jGKLuT+N861T/SbPMm74QkN57PS?=
 =?us-ascii?Q?ZkG0bfuh8VbU+sfx/jbLRsMjE+dOEmLudnML3iXe35p+JxA6A6ySJOeClm/R?=
 =?us-ascii?Q?20YuJP2WdgsLva3S9X5YbokH79jxJBXo3lEQNvjrloCNA2BuyYc3fk2k9Fab?=
 =?us-ascii?Q?TqfoSEnw5S94nCDFE9rkf9dbOFJACtlYsH6JFrEZLvFoIOlqILPAzRWh0j+y?=
 =?us-ascii?Q?fqUYIEzOQoJ8lfvnJxAubH/QQ40WpEt2eUp9XZwsCLJkaY0812VJvwyLDJ3E?=
 =?us-ascii?Q?7y91PbBUO/VqmuEkZjAofDg6mrYlK3q2P3Tv0fNl2VrYzGQWPJUDk45B7pJ1?=
 =?us-ascii?Q?qe2xPlbOx6GYCQo7Jfap+Ow/pjIrqsvX2jR3BGKcvJW+AtJ04OxjtfoXRHiQ?=
 =?us-ascii?Q?9uCJlvA4bbBhIRNtbszXG2lvgmY1gkLRJ4XOSvpQInNzlwpzXFfWyP9px9jQ?=
 =?us-ascii?Q?okaQp+7BaoOeYbGxA1clKegXDVLJthkgZNoScvFFMNLoSjRGzI35/5M9jbPh?=
 =?us-ascii?Q?eyr8ebMdPPvAI9qJcnDrFOmaT9i+jxaUT+8aextyHuGJk9QbpZidBx2kSWf0?=
 =?us-ascii?Q?+C+McmhATwg9XzglcjnMd4fEVrW9pAaof0p3p4urreA37f6Ti6ZBDSqkBItx?=
 =?us-ascii?Q?rie67DkFlIhBwFJkI21K4wOwmfwTpv+5ZPWm2W2arDbpdGEApMZ0aenZujnZ?=
 =?us-ascii?Q?Htwmm6AF7odOEUsE423W5UD19AD9ds4JpBJRmh2yVA7wsL2aVhBVpNwzlnVx?=
 =?us-ascii?Q?R09PEJHn1n4AuY7W7QOBueRJTSiJZOV0cmnwJA7t8A58O92DRR7qcvH+uyVv?=
 =?us-ascii?Q?AhQAj270u2PFaO8fP+sFQyHaO4LUIyAiq05kNoJ7OFh/Fznp0vI2cEi0qX1Z?=
 =?us-ascii?Q?eDcccJM29w=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2059bbe7-f1e8-4d2f-9668-08deb245e05f
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7726.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2026 05:50:32.1959
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZVJVdD2tR2f9kmFmnpC7GL5/xD3hS3xpQa5lNIYWq3vUMQc8yHIRIIro84bFLEw/oG7PearkUTMlIqefsDbH8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB7086
X-Rspam-User: 
X-Rspamd-Queue-Id: DCCEDA0009
X-Rspamd-Server: rspam06
X-Stat-Signature: bw7ra4kpekcf47ri6pg39yrqze9dj3xd
X-HE-Tag: 1778824240-689047
X-HE-Meta: U2FsdGVkX18W6PJZx/unIy0DFsAaFR52krOeTh66vUs3QWa2Yr+8Yln2QR6Q89GQDjOJbsPV+xrTO1DysAFVbCI7Yy/jaKLRNiDfUXiX41UwPd6GguLmedUKe3d+Gl+y8HaRiA8NOj2lq0Cx9OYSUJR8mXUQhHdhm/O6Z7NqjdLRqYRl4HIVztcKFtXssfpPLmsd2nHkkerLbf8JcasJhKq6R4hm793rwQujpV80S3ShP2Ed9MEfo/CZFJfeUMEvn9a6ISJ29p6ew9YujoZ3RBsOO2J1tsbWbIOWchwZdH1uWvbp0PtUTXdtpY3eASTXxLRQ8KeDGe5guKZl7cTYRkqH/uginWy880xAuL10GCpfBan5b+OXG1qFF77m0POnoeh+xhHcEhMBZbCkq9IkJ9RVTuAI9fdll2VzRrvvF+wl1IZREHT2gGBh/S3pthTwy8PT+Hfap0a0PX0ivAGINChHCpLN2o+WUiwniCLCVcSBu8AIh25TxxD7VvuxH3OZNdPvtgoHyPDi+5TEO4I4u6ZPDQISAy84qrDXudbP1VC1A1PejkcfxH2+CHb0JkRsnH8cnV4Xgg2fbJd0OHCz46CltHu2qFzjsfCCFeDGtsEMGt8udcjtVxo5kSj0JrgK2s5fgVrGJouPwtpPKWAHj4L9FIGeUgBgwPbI8Zu9izIRFly0sKii4IpZ/5WbwUMohuucnAhWjjNt0ofllDEQDdoY4lXx+pHvE27MigpLwUHdFlqs17WwZL6urBzJmsY8F477GIVe7FhWBQk8rphLrFk56GTGJgTNpsFdN8U0An708SlZUM09qOeFugx2lIvD0GWgpkZH37gnKKxEfFosaxM3yD3ZUhX8+Bp03myzeeI5za2txyqAszfWti6I47yoJS0HyIpbOWWs4wPSRor9qKIq4fzbQcR90Hpn1s9+SY1HX/wRIFkjFlHvjRdSM8vJJuzw+E4bq6bZ/iK0FUe
 byaGkxL2
 1hgfS0P5Vg1HoGTc6lu5TEzWdUaVeiQYEMzCieDhsdGUygp/q6ORIZilkou1taf/nWZvbIdNgB4u/xOQB6oGsjzLIaduaJMo8HlVHuIMfqGxDOpeAe1FUvDWyJo6gjVoFtgJay2iDeDv16CrcVh+gDyGyNkALtxbpDzq4HBSySyy+vicgPOWEZXTd9303fZsfU+/ppUY3yrOE/mOX1R/b2d+5WIo/E4eDBDk0SUxsc+JURFAOqhECcTs16HzLUA8P+sx02lEyC8PL0CSuLS0k8+6/i7poZtxQMmDHa8Z9gRrkLbFj0TJfFwZrYfaJ9Jgxb8+N7n4EYQBbmBHd+C6Zu/6hbuAIJst6b9MtQMGTem0aTo724Nb3YJCbFj8g6GGlWswjzp4eGCM3OewvBFieNtQmSEpNG9SLhfHONTmK+9INUbhSjP/pLN5NhxNfd77SICGav7xD7v2qxAZXdbpiG2CEWw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-05-14 at 13:23 +1000, liuqiangneo@163.com wrote...
> From: Qiang Liu <liuqiang@kylinos.cn>
> 
> Return VM_FAULT_OOM if page allocation fails, which
> avoids a NULL pointer dereference when calling lock_page().

Thanks, I agree the NULL dereference is a bug and this avoids it but what
happens to the pages that may have already been allocated and locked in previous
iterations of the loop? I think the subsequent migrate_vma_pages()/finalize()
calls will do the correct thing, but that would lead to a partial migration.

Given that's not what we're explicitly testing here I think it would be better
to just unlock and free the previously allocated pages before returning.

 - Alistair
 
> Signed-off-by: Qiang Liu <liuqiang@kylinos.cn>
> ---
>  lib/test_hmm.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/lib/test_hmm.c b/lib/test_hmm.c
> index 213504915737..f8b43d6eb261 100644
> --- a/lib/test_hmm.c
> +++ b/lib/test_hmm.c
> @@ -1063,6 +1063,8 @@ static vm_fault_t dmirror_devmem_fault_alloc_and_copy(struct migrate_vma *args,
>  			/* Try with smaller pages if large allocation fails */
>  			if (!dpage && order) {
>  				dpage = alloc_page_vma(GFP_HIGHUSER_MOVABLE, args->vma, addr);
> +				if (!dpage)
> +					return VM_FAULT_OOM;
>  				lock_page(dpage);
>  				dst[i] = migrate_pfn(page_to_pfn(dpage));
>  				dst_page = pfn_to_page(page_to_pfn(dpage));
> -- 
> 2.43.0
> 
> 

