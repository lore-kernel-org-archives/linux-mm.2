Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55817CD343F
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 23:39:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACB316B0005; Mon, 18 May 2026 19:39:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA28B6B0095; Mon, 18 May 2026 19:39:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B9656B0096; Mon, 18 May 2026 19:39:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8D1D66B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 19:39:50 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5754D16182E
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:39:50 +0000 (UTC)
X-FDA: 84782160540.24.B3C1793
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011029.outbound.protection.outlook.com [52.101.62.29])
	by imf28.hostedemail.com (Postfix) with ESMTP id 98629C000A
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:39:47 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ZoCTjAEk;
	spf=pass (imf28.hostedemail.com: domain of apopple@nvidia.com designates 52.101.62.29 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779147587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BwHagoP6VtPibnoQUnsi1hi3jFp54qzUJOTz+T+Flp4=;
	b=BdSXdmWQLGQ+7XQyHTvh94D3YYZKHJV8Bl0ATs0CQ4endykd0GwpnyuPdP9aJdGXd1udbA
	3MSS8Sd44vBrO5locD+kcUy0MYwrEx5mT97J/H8sd8AO/9LC/vfYIMCXv0p6ov9LH8em3f
	59HZCAMtLMEiHF1PNo1e0MxQd8PCPFs=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779147587; a=rsa-sha256;
	cv=fail;
	b=ju8PJf4T1I5+EUF9TEMTFsfJ4Bc2pFJRHMycFk51yBGVhqo/AX6GhU0q4MgslCWDL+nJLJ
	luTfJDeePGJWaJtfFCDF8Vl+5CmqbvPBGBd3W7jI7JMY9Jf/SiZGXEipLcZCOwBilDFcuJ
	qoX5A13nkbbTC7u5GF2jrjy1594DHR8=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ZoCTjAEk;
	spf=pass (imf28.hostedemail.com: domain of apopple@nvidia.com designates 52.101.62.29 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NHWwfKn8GNh3sbnhGaSxWyVwU71aT6Ky2D7HUsMeMkQF4AKG8y8l6tu3iqbEehVyhY+1BdC3wwEA9b4A+1qd15+02R1vQTCThrCL0RMvAUhDOczASCJHlWXk4L84dWkq4LNkCr4GSIoqitdhRXkg/95U3siAsrTqGttfajQBG3IHEz/a+GEbrLnKPJanwU4RdFGAqH7yDn2VMGTtjfHXBH1XLptO+f4hvgzm9tvr0k7XBgd4jpXSPh8J9oqMNNpc8ePgprQcOcLYQBqnFaHvxEieM/g5saDamFGG93YMPD7FxSrudqO/4h0iWmkALEfmUDNbY5xQVQIlncOS0OLHJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BwHagoP6VtPibnoQUnsi1hi3jFp54qzUJOTz+T+Flp4=;
 b=mkbVBbADZCAhOrAcplSNyF6f9O7BzQfQVpda/kpuRPHUAzDsWhepBzVhyMWeByG4IStjJsLtvk/TdQka9oY9mAwx0bisOlGEFIqKgnJxiv8u2ovop5jGdvwlZEdwtt7RwxHi2yrL/yPorCfjEi1AudeYTb2AhEUyCEvA6apyYluoYXWcNkNZgH6fW+l3cviP/BW9lYv/osPBQJHMRQdKIcy6IgF8ioqbysSBPEsfhKLHNnc5AFgx5e2b6sEDjkS63MIN2llr97hN/Nzc2WArmtN+3lCUzc2gAUiAjDrwbHWIkhCNdL03dPCcy+3NwUIgxrnexn7UVmO3dk0ta8sVPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BwHagoP6VtPibnoQUnsi1hi3jFp54qzUJOTz+T+Flp4=;
 b=ZoCTjAEk/Dr8xx8B9Euxx8OD2waMZwE+yL7i1A2kSD4LUvyAi5Ypf74sAjjUXRg8/qNhm3c+PQvptyCtlVb+t/zKqY9duIzkvHDdLqRAEBXerrNMsJdHDO55d1yU0bv7KnXELGgN9yaJlhe1ebg+sHmMSNmXTxpvOGIeErgC30ISoWVylyhiRR5DfrcsBTwskrPnKzDZOIY3ww2Scvdw4ospcdM4M0RDlkHJRfYONi9Qnx202A7ajVhz3T6dAyWhUmCuB3heRkJ/7RNfgMLzwfwE1HqePlcKY3bObxRsdNryKJu3VWyeJeq8FFeB0svyZlnnGf9kVBWNzEbJIfQg9Q==
Received: from DS0PR12MB7726.namprd12.prod.outlook.com (2603:10b6:8:130::6) by
 PH7PR12MB5877.namprd12.prod.outlook.com (2603:10b6:510:1d5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.21; Mon, 18 May
 2026 23:39:39 +0000
Received: from DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0]) by DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0%4]) with mapi id 15.21.0025.020; Mon, 18 May 2026
 23:39:39 +0000
Date: Tue, 19 May 2026 09:39:32 +1000
From: Alistair Popple <apopple@nvidia.com>
To: liuqiangneo@163.com
Cc: jgg@ziepe.ca, leon@kernel.org, akpm@linux-foundation.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, Qiang Liu <liuqiang@kylinos.cn>
Subject: Re: [PATCH v2] lib/test_hmm: Check alloc_page_vma() return value
Message-ID: <agugdKKApUGLWkaz@nvdebian.thelocal>
References: <20260518031903.63455-1-liuqiangneo@163.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260518031903.63455-1-liuqiangneo@163.com>
X-ClientProxiedBy: SY6PR01CA0076.ausprd01.prod.outlook.com
 (2603:10c6:10:110::9) To DS0PR12MB7726.namprd12.prod.outlook.com
 (2603:10b6:8:130::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7726:EE_|PH7PR12MB5877:EE_
X-MS-Office365-Filtering-Correlation-Id: 4826e028-1bb3-4866-4195-08deb536ba07
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|56012099003|11063799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	47ed93DT1fxP6shAGLvx1OxVxNMIHHZdgG9dTUk2AAhkxKkbxiJrYtfDCS072/6V9CPK7BVRz7Khy3ynuyd6bMjVNzumzn07hMbeX98m90id2joG6gqikduUDUOf1SeuJe/cl+zZ0+9keH/RjGVZGYGf3wvOauqU9M1x3O0w2zSYNxu/li0owZCidWtSva3zuzf3J9+3qG7jmUpUSj0PBPRiB2PRqJyyZhlArIp+Lp8kuvmcaWa8rNDEY4cYOyBAiBUiIrwJTo0JfnYxQShm1VrVGgjXAn8I35mNWFmWY/ZR4B8VEIEeTkNdLk+w574kP0dSwzoB9UfomNF440UFlSR8Gk4ffDx+N2DA6anuKr1LuXdjTCfF/EiKySzhhVX8thbhqH/AVb4F08PnTgiFloUcKW2Huh/2sgCPyts9EJiYGecnWpKQXvp97+pGRI80F8fFjwkJO/kdg61aiMOQepK8S2gEcpY48p5QwBT71CgHXkG1mEHKDhVOA2HI4apQHh+cJbXchKlcF+bCOwWmBKv/FrdrMAAlLPU1XLREkp1kItYZwV9rpswrGmXPB9k6K1WlNSe8hBITUfq7TBBqY8mPgdm0TP3UNr4dYNi5xRuxGf9mRGeDXsGx5tj5600592YZ+YPd4SMwQt79xlEUI4spzkcSF1c50LglcbkHlqaGXHjURACNH9P8fz6C5eURw6ehOZzioj721CQe2YRRoQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7726.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(56012099003)(11063799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MjRLEsnnigx5n7wKbrrd0YNFLnnwRyVKYYMsjyr8Dknm3qgehgrSkxyGSaxD?=
 =?us-ascii?Q?TxktklOrRVTWJXjE1FhNer2tAi9ER6Kupxm2e6ETKv2tFjKvqvlXMIJl7nR0?=
 =?us-ascii?Q?PSUlKmMOUwki87zSr2Vp2+dzkk/090vppL2H7Vn02oz3Jfx6awoXiQlV/g6p?=
 =?us-ascii?Q?ceOIRQfzlFkaERwqimfoj3X6OIkm00NSkf1FPO1bjWgb2qFoUB4D/9sLbzTG?=
 =?us-ascii?Q?6JQ4fRbbgkpJtznmZ0I6BaZ1zK3pGC0i/4nOfgL1r22yleEkT/ewl3k/CLM6?=
 =?us-ascii?Q?Sqn2R/RemJXt9RcJ6yRRuQIEiR78FBSJ2nRb6lUBKvc9W5PwOs2xUJYW3BLG?=
 =?us-ascii?Q?sGgvOSExkjsXgp0j75Q85n+D9Bay5TkYgZPekagWm5lu2FRn8r74hgC9pZWt?=
 =?us-ascii?Q?aHz7l0ZjdyOf9izhSa7MOV876oV+6NVj9R/A/ZIzuGZ2pOC3bDGWHaQyQZbq?=
 =?us-ascii?Q?UJHwWNlBakUBYjevlHlo0qDMFMqbNPPiCNsAithxkjyCdvnDTw11iK59nARI?=
 =?us-ascii?Q?E/xhCh6Ll8ugsUtLA1eUV8d5tC+2i3L4bGwA7jsLQ2o5NV/zKNjEeRha4Yuq?=
 =?us-ascii?Q?iGm22+t+75y0yoT7yFmTitCUUEvQ1UOijuWDrIpU3FzzGnLBHEnFh9iigGej?=
 =?us-ascii?Q?JRV7ZhLL4jQanoL00GmTHBTpzZGyYtEYXTNymWsif1ip/gGQODLwt8OJKOpJ?=
 =?us-ascii?Q?vANefKI4oGSJQ0thEvIBEWOTqjHYso6n/jnIKcr0vgbOaHeY7m3SWh80Halb?=
 =?us-ascii?Q?UJhIjhKpxMZqYjNzWrDSX2TCDd1WvFTD9OR7FQuWreln4wf46o0a7YLamNrb?=
 =?us-ascii?Q?1cjQzgj+Oux7pyJAXtZ71zxaVBy+uOWtTe9FkBOhewwxUD0ZRgEblVspVO8L?=
 =?us-ascii?Q?f4vXW5t2lCxiHBUvPqYjtWHvOxZSWw+Orqm+Fs3988hzuqW8epQmlwsGjh+E?=
 =?us-ascii?Q?dmGGAiqeAw0lwc2nXmxesVbKJ/tg1TojpXvusgBr/Xq9Ukh5btmHVR30G5Mf?=
 =?us-ascii?Q?6IyqBT2BR6/V1u6tfYUClyWurXXggUzUaKdyAIvdpwu4J3VZWL49IK6vz9kt?=
 =?us-ascii?Q?PqCu3EfgRPihON01JCxZx2d5fpNTvvPireef3lNVf8QKlflyMcUkRLnOHMGb?=
 =?us-ascii?Q?7oV8ZyS8pOOW/z76KE1bB+Iq9DWBxaaS34Aj+vFDYcc3YgDFvz9qH6v5+iLB?=
 =?us-ascii?Q?kQ1pPKBAEdao1pbV7izvIcs8o61wFjY5zmALMs1GZratBtMcJMxfSzspdXWd?=
 =?us-ascii?Q?yPst5HaMA1msb3S3JwZw4X1SdPqazl7d4d+Qknr9v/UFMKoePBPTrF07ox/Y?=
 =?us-ascii?Q?m/1cfupg7JjP2oRuvtEuF9+u7lc2yw6vKiQ3eTMwM1GN42/A3G65j3BIqBdj?=
 =?us-ascii?Q?fbEaHycKvn/KU5pQji6Z0xpHs0ATgyKMGo8hdwx7Ct6Kcg9Qoy+VNdTSBCHc?=
 =?us-ascii?Q?Yy5W+hXogQMVR+yH3Aw8MPRStmISr80TBH9OPcgDahl8phdx503k/LdV5fe+?=
 =?us-ascii?Q?fOtXK859KVN4yLgrDCqdEVtw5wjhTKyVIftb8TDyO6DqaCmlzuK3vuVy3nHv?=
 =?us-ascii?Q?WHZu5xkgSuH5t00aie4QwTlcpweWsY5rpKYZRPwQgoZA5ZjvIEfTD5UOHy6h?=
 =?us-ascii?Q?KFybGEVCw44hExE0E06Kb4tvj0GgSmyvMuTxp92Gwy8QbtwSKHJrier5N/UU?=
 =?us-ascii?Q?cHsTtJhrPaNLDpBWiXlfdJOV1m5xGaIEef+JF2/3BM1eGmWcVwWx83kOvFLX?=
 =?us-ascii?Q?5esVye1crw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4826e028-1bb3-4866-4195-08deb536ba07
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7726.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2026 23:39:38.8994
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V10YH7SEMaT9vav2YEsR45Q8qQjVujky4kq4aM2oFLzdg39406sqfxiqiqnMf0Nc/en/XDe1JkOmvOf3FbkEfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5877
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 98629C000A
X-Stat-Signature: x157egzdzg8uur94p7s8pwgh3r8a6ctp
X-Rspam-User: 
X-HE-Tag: 1779147587-259031
X-HE-Meta: U2FsdGVkX1+dMObL9211Uygl0zLJdGNIM8Y5W7uhy5Gm0AzFb9ebMXWWc61AUP/1Sng8BNQHyOAEDzij+dvhCTspf/UMQ1RG1b6CPTddDob7uT5VEV8RbrE/AIjMjOk388+lCQ2U+X6TE5z+EtTjakF4aivH8YgEfKPRENs0j2oZnFtx1TJ/4/QAIKnrpoI/NvzAG95DnFm9JEtOlh+XBIhay+313SQBqnNhcGXvRkdNa+zxg8CbyKcQhBmKsNrg1EJ/q4qIWniAIOhLoa1plDZoc9B3Azsyu+emkYBgc/Md8SSQc2YsUeFyBPkMJTaXp1vGx1RLKyH9OLcaticgOqPxxzCWvZ7eCAVgS+nROltuzFGpPILpkII3VKATPl+AhduH/okw3jPQPpYS5FSceduowBQynkBGXwJyOin/4DG9ght5RcGdvEWTvcmytOugsejBLtBlEErg1EAfFwm/ktHMHH0K0ahXnDrl5Er5XUxPd13TEgOaq2jsN+zEoABpOpJvusao9c82yoC7MBsPlF76pjjzpmNwj1b/PC1aTzse+ArQNW7lx8pSKZzeym0TjFlw+4Jo5u9wxzt6fI8WoCHMe3F52HQHY1oevQ+jgHOxYn+kxZ+pLolyHaPGgyu0M8awoNIoIaU/NVF71NLyZZQP3N6gdOA+3ozMUdzmAAX540UZr94VuHMP9GxxFJ5ChlFEoKSjYDBUZcmsyDFX/hRHFDjni4A0C5DeVVa8RXeiptB8ex4XWSsJnazKf2xVzKrp3umhVI2KKUcdV9bWYCQm2GMey4Sn76DbqH27niGvTqNUg7Gjznp+GIDaOSaWtfV0TA5i14a12AZeRfUOyax+NWBMQQVkjo+jvhtG110jLnsJm9HjBWi584x1dng7/kmpevcAhKljrLxzYE22lo2JUsWO2wP1DiBBEfAyAsLxPbDcB8IPNUS8nVJOmAwIlmGRDdHkK29EwnJccim
 JU3sukzj
 DnC8ABD9E+Fr5SfgSrb18NgUyQRfaukLyW2/nAuC3F75gye1HHMNpmTp89MMy4icogtubUuVE1MpcnXiN68fzWSoos4dcsLh+U+sFZ4zj1yHu/xQ7/l2FrBVb61m7fvhAvuYHDALVu6+fKwDAdW78DaHSa0SfvPJm4BTrMHVucZNRDrESuVM1xZBit7AARDLwWqVfXEfXSC7Wz0nfJaXSWoJEhrsAQbzfjKNAjYos6CMp2JdRvm02qKevj/3DW75xmEqeroyrbdjJzzXzEolc4rF8uIej/RRNtXLnUreaaKmuKcx+K20kx6j7MiljpxU1iLEhzQsgr2sqjl4NtR2A9+bIcawrRjwi/p+jHE0fCzBz2aab6i84F+1pKBBZX13N4lgofVmxi+yQnJAa6DbN+xrG+GBD/W7SFUKuI78LPjjw3WoVtpbgbG6pC7Pjs7EfG6m1P9H0BdJzbGGGhERhJ0ybYCmtdn8Qb/AKSQqPhjGN5EalEIBkQlViTQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-05-18 at 13:19 +1000, liuqiangneo@163.com wrote...
> From: Qiang Liu <liuqiang@kylinos.cn>
> 
> Return VM_FAULT_OOM if page allocation fails, which
> avoids a NULL pointer dereference when calling lock_page().
> 
> Signed-off-by: Qiang Liu <liuqiang@kylinos.cn>
> ---
> v2:
> - Add unlock and free allocated pages before return.
> - https://lore.kernel.org/all/20260514032345.32256-1-liuqiangneo@163.com/
> ---
>  lib/test_hmm.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/lib/test_hmm.c b/lib/test_hmm.c
> index 213504915737..90aec4ca2e01 100644
> --- a/lib/test_hmm.c
> +++ b/lib/test_hmm.c
> @@ -1063,6 +1063,17 @@ static vm_fault_t dmirror_devmem_fault_alloc_and_copy(struct migrate_vma *args,
>  			/* Try with smaller pages if large allocation fails */
>  			if (!dpage && order) {
>  				dpage = alloc_page_vma(GFP_HIGHUSER_MOVABLE, args->vma, addr);
> +				if (!dpage) {
> +					/* Unlock and free pages already allocated. */
> +					while (i > 0) {
> +						struct page *fpage;

You will need to clear dst[i] as well to avoid subsequent calls to
migrate_vma_pages/finalize() trying to continue with the migration. But then the
whole error handling for this function already seems to be broken because not
all callers do this :-)

Looking at the two callers for this, one ignores the return code
(dmirror_migrate_to_system) and the other (dmirror_devmem_fault) gets the
error handling wrong because it skips calling migrate_vma_finalize() if
dmirror_devmem_fault_alloc_and_copy() failed.

What needs to happen is we propagate the error up to the test so the test fails,
but we still need to call migrate_vma_finalize() to remove the migration entries
created in the migrate_vma_setup() step.

 - Alistair

> +						fpage = migrate_pfn_to_page(dst[--i]);
> +						unlock_page(fpage);
> +						__free_page(fpage);
> +					}
> +					return VM_FAULT_OOM;
> +				}
>  				lock_page(dpage);
>  				dst[i] = migrate_pfn(page_to_pfn(dpage));
>  				dst_page = pfn_to_page(page_to_pfn(dpage));
> -- 
> 2.43.0
> 
> 

