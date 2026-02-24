Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07372EFB81C
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 16:49:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A2186B0092; Tue, 24 Feb 2026 11:49:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17A6B6B0093; Tue, 24 Feb 2026 11:49:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0274E6B0095; Tue, 24 Feb 2026 11:49:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D947E6B0092
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 11:49:29 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A09C21A01FD
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 16:49:29 +0000 (UTC)
X-FDA: 84479936058.12.835C356
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11021084.outbound.protection.outlook.com [52.101.70.84])
	by imf26.hostedemail.com (Postfix) with ESMTP id 71012140008
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 16:49:26 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b=R7aJ7tit;
	spf=pass (imf26.hostedemail.com: domain of ptikhomirov@virtuozzo.com designates 52.101.70.84 as permitted sender) smtp.mailfrom=ptikhomirov@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771951766;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9Db4jRs/EFk7zsEF/qDorpLvIMXChA5tbTmpkO6HO7w=;
	b=3gORZsuVoBPj5ah6U0YP6k1sMOdVC9I1d6TNNNgOsb2mj76sQIRLIcG5lDlvt5er1ZFPKJ
	ZbbVAxpz5jtj+pDb1zgD1rSz/TzHML9j0PgHseLJeoDSQOaVREv/nPs/Zl4dqyFzyqrAzO
	JCQbBpcspaS+VG85cA7YVpyTeMu4yvs=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771951766; a=rsa-sha256;
	cv=pass;
	b=1CLr0dvibBIJR3NrT4HKQQ69YvU7g/CDI2PqAYSQABApEIXmZkvKx0n73rewZ1iC293wgZ
	rk0Dc7soMZL/KGzl/wY4LOy5wlTeqW4890PNzclu5KJNY0he/LDgET5Bjj0RC3dHQ0lmst
	D63B7VnLMESEstf59lcjTMBhij7u6Ow=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b=R7aJ7tit;
	spf=pass (imf26.hostedemail.com: domain of ptikhomirov@virtuozzo.com designates 52.101.70.84 as permitted sender) smtp.mailfrom=ptikhomirov@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ouhd7eRKEWjtI3nbdP8HmlcPBp2xd9FYDgSyaCPcm1TksmNct8Gw3Qryfu3PR4jcSxZLixSGTddNFx1supXw63PRqNMyGLEWittu1VPLtHK7NvevLbXWpyogS05NnytG3lxrW6MscsbHeVPYZIRaZ/6B5o3VyIr2DWNJrdSKwVSLR29x4MC4jCXYmMcsYu0Me41UrWK4hbVKMd0coe0lLX3KVfuSI9rp0JFxP3vgSDTDD5XWjbiueuDdaPItpcenz6Dv3xvTnlrWmvZ2D55PUlTuIwVTiZD9jA5ygYx6FzpYzKhBGufWriUVF39qvcZ21FRVCStvfOW29EaC21QVMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9Db4jRs/EFk7zsEF/qDorpLvIMXChA5tbTmpkO6HO7w=;
 b=D6+OMQziib36xSucI5Yw8MhZu3mmmbin0fKSCmiukm6M5PyzF71i36X6oGSYhiO2pa3jWR+2vkZCCAtDlGt//l06tu8EzrWtf/DLZVyWhc/C9paN53Paf3wNFmLiRqa2UreLn9OpL6RyoDA6jWCnWUYD9Cb+xddklcrhaodz7FX4HWGZ7Zr+Gx0WMiN6HVTTHwO29oJzVYKk/DlEzpSHWguoFS93DnMteqWvZavMVnE7E4JoKNQ+yVaHV46WSynwVjKuQOudiXw13GATtlZt0vIVkGf792YaJGRN1fVPOLFUD77YpVo5BQQAECtYKMyhAYQ+I3dfaQWcGBiWk4t6zQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Db4jRs/EFk7zsEF/qDorpLvIMXChA5tbTmpkO6HO7w=;
 b=R7aJ7titj2u+mhvL693wZi+3Sm7L+ZQqjCMVrdhX4fzeTXG54gqi1kuK1T3dfqJkZfbfFmBJI0/WoIrkERB+cbu522sPn+317CFaWIaFR0N+/wjmaeb7CPO8Pdjdp5Q52r7WUelx6WYDGvgYcAbVMdV071zBRceFazEcRzGNJDPhSd7PkiMx5kY7Z6p5xAzF9LWFz8QDH5JVKZU2VZzzpPcJFMLmW71SVIuKvcI77y5NtpC2E0Zdg8fGg2lr+RdahIaE6XmaqebcLrkH+TBEeh4hVe2TyovJKs522WhPXjIb8sISvXUdWXTtiRGDZRa+yCKhVjSIgQIPb3OUNZnPmg==
Received: from DU0PR08MB9003.eurprd08.prod.outlook.com (2603:10a6:10:471::13)
 by DU0PR08MB7763.eurprd08.prod.outlook.com (2603:10a6:10:3b9::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Tue, 24 Feb
 2026 16:49:09 +0000
Received: from DU0PR08MB9003.eurprd08.prod.outlook.com
 ([fe80::3470:51d7:36e4:36d2]) by DU0PR08MB9003.eurprd08.prod.outlook.com
 ([fe80::3470:51d7:36e4:36d2%4]) with mapi id 15.20.9632.017; Tue, 24 Feb 2026
 16:49:09 +0000
From: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
To: Christian Brauner <brauner@kernel.org>,
	Shuah Khan <shuah@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Jan Kara <jack@suse.cz>,
	Oleg Nesterov <oleg@redhat.com>,
	Aleksa Sarai <cyphar@cyphar.com>,
	Andrei Vagin <avagin@google.com>,
	Kirill Tkhai <tkhai@ya.ru>,
	Alexander Mikhalitsyn <alexander@mihalicyn.com>,
	Adrian Reber <areber@redhat.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH v3 4/4] selftests: Add tests for creating pidns init via setns
Date: Tue, 24 Feb 2026 17:47:55 +0100
Message-ID: <20260224164852.306583-5-ptikhomirov@virtuozzo.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260224164852.306583-1-ptikhomirov@virtuozzo.com>
References: <20260224164852.306583-1-ptikhomirov@virtuozzo.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0147.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7c::14) To DU0PR08MB9003.eurprd08.prod.outlook.com
 (2603:10a6:10:471::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DU0PR08MB9003:EE_|DU0PR08MB7763:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c64d73c-a2ba-4d4a-f41d-08de73c4a1af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|52116014|7416014|366016|10070799003|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?tO7WQZkzq7qSNmCMCEYVK1kX4bDbgr1bJiWBKR2S8ZYRiFTXb8nGerYuGSsY?=
 =?us-ascii?Q?lZQ951Y1Y6NQ/xpYwH1XmqRP2eJxLlkUJmYufAzYG2iAMF3mCsqgpsxQYSVr?=
 =?us-ascii?Q?sahVEEwxwC4lSg3g8ZJiVRnnxiKOMB+jMtvaQ6grifsTkRzGco8YTpfq1Uj0?=
 =?us-ascii?Q?nWKBLVnbMjDiXV6SelT+NVczCwmEEQ/t5hg5qgNAFJw/tTD0W+Iy4tHVlV84?=
 =?us-ascii?Q?qPoEWlmUXErUaezpurTMgJb78BxvmuQBvKaqBBL3pKCXj2s33YkMw90CnIQu?=
 =?us-ascii?Q?8KD59/OnBysL9C7BUUKusd+oMOJlsFXA3YnF+WLxbE8dFYViRWPBVSO6AuyZ?=
 =?us-ascii?Q?lcZjmtxfAaPnRus7Op3uDn8D4IKPcI5kdIVDrSzOc0B38hX+EGvB43wJssIF?=
 =?us-ascii?Q?D5glKQaRKOhIpdwN15NAvMz7o7NpTGHrrlTEdj6+c1mwYgkraSobNWDmuspQ?=
 =?us-ascii?Q?sz5DG2v+mMk1xliAJXu4YDc1/xTzTLsSkeie87LYfK299Z3cZCwU42pUdbtz?=
 =?us-ascii?Q?aaGJm5QtQ/pU6zgM7CU5mFSmt/Ml3m9k1rza1jlw3W/7GkcU8avtczsTwU2+?=
 =?us-ascii?Q?ZgpJZ8x9bQR8RbqqPTx56zWWwgOTvZTK67rIflFWMT8i31TuYMOb23S5KfLZ?=
 =?us-ascii?Q?eynJNKXiV9bDvl2Tn2yWKxvOPoU4VT+0HIMYa5YKF/QZNQDFS2chQeDLWqsX?=
 =?us-ascii?Q?mQMwDi09yzfXL1rOO+jL9maqADPHVhgLmM+EX8oFRfn7PMOIYiRKslofA0TD?=
 =?us-ascii?Q?u/HmRtL+PVd5Mu/XB5B7lJWXXAMh++It5h0ehDApJNBHc+sBGlB/ToDAYS2A?=
 =?us-ascii?Q?4o/3Mf3Ula0D4NU3PAk2bisYi5Cg5SvSjzffA1SCGsBQnZpVo9DR1VTKUR/Z?=
 =?us-ascii?Q?iEL8VSp5dolJH4wkseFR584MZ3OZiDbRWnv8Tw6GawEyaRf/F0aQzD6WTC0Y?=
 =?us-ascii?Q?3ab6ddZGUvHGFxfvB9kLBBkgWSL8c4lbKszvUmgOo0GiaqEkbzgppSAMXnU8?=
 =?us-ascii?Q?fnzDw+eUBt1B11Nx1vFWi7dOS8WZUMGLcQ/ZigA/cU5f8wnjYG0K+TtrA8CJ?=
 =?us-ascii?Q?3kzWmL0xZDbk4q/kL5ldsnDFo2cZlXWuT+9ZGhgBBIG1PIdT2a5Gk2+Z61dX?=
 =?us-ascii?Q?wHvwW2sSyfdWIbzxr7bpbYD7IxBaujSTymcb8VLPXIpopvSk7w1oV784yukw?=
 =?us-ascii?Q?1t7ngcvNTe+Dsqo20rxOdIQk2RjCg+iKv8UVm93xKr9N6qCk90x5HdvhWsxs?=
 =?us-ascii?Q?OfPQE/rVbwBgnH2M1b3/zC2dHheFqDzuUlLVd5Fmb6iB0JiK4k/Mj0L/M4T/?=
 =?us-ascii?Q?wU8rvchdOdW5OkkQT7FszjWSP6Bk0dvNlhh+wT1h3FkpwR87CjZ1W+FjidMv?=
 =?us-ascii?Q?jlGbHwymGlvpuMbiRN9a4K6yMU4gmurKWvUYB5ZVjvdtoHZAPyrVwTSC9mgy?=
 =?us-ascii?Q?uPzhVgIwj7YZBcXDHd53JvdoKI9SpWOf3cHZmdiEYw6GD/+8ldxPm9ObVllk?=
 =?us-ascii?Q?o2cLubzZUVkWf0XH6ngExGhdfin7M6R+uaNjVk3mtE3vWKTywHZ+h91GcV4l?=
 =?us-ascii?Q?daKiCZ0kv4a7E+P7CdY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9003.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(52116014)(7416014)(366016)(10070799003)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7Kf9r3W2pho10yIor9hbmiyrbWAJ3FdHnWFk7UUKXNdF7KYdYsvIxfGbMePh?=
 =?us-ascii?Q?01W+32ZoXKuGNqVqZ6OirUxX6/1IlxEHJGu0ucjX6Ym64eBzWTI0dljxhhJZ?=
 =?us-ascii?Q?S7/7etlyVLrJiY35nG+EeG0EDlt0Og1RSxc2uEBW8NJ6/pd9IIaGGoiak5Q2?=
 =?us-ascii?Q?0PPYUYgOHtzPbx96RZXVfktfIXi209fKdiwAtJnUi66MzDkdDZ1Yxf2cCPCx?=
 =?us-ascii?Q?BW0kcg3yIbOgyIo3peRZs54eDZbTqAhbRv9TeLlNy73NmFOLN1Ra2TrKAZv3?=
 =?us-ascii?Q?F/jhFgDqSPt1lamS2DncZqmAoMQjDmmmptK83q70vaADNPwrodpZ2sAQgajZ?=
 =?us-ascii?Q?JIgHZWgs4ewzO2Lql+8tIu2ctr6YtcRgJC480qqG2X2IPZ66l8Fn2HScZpd5?=
 =?us-ascii?Q?Lgk6ZmLru8HWgIU67reuoC/UvNW3MwGUzyffdh6WZ86977FRZ34jy1MZ+okw?=
 =?us-ascii?Q?dMJ5e1386qZnWn7H9udFxpiCdXNhgfo0dOnRn7x6ogxQgUEDbfTekgKrhr1B?=
 =?us-ascii?Q?nHaIR1AZXamGCS3NZnFQV7p1DRzl9j+/cckw5Ae0xHVH8DxJznqUfefT1/5g?=
 =?us-ascii?Q?f/QtxnqQpMJlLwqgBcaRCuApf0cPlhO+gnzg7vDLZ2ES2kZPjywsx3nEOaRp?=
 =?us-ascii?Q?KUQWBxEoGZXPue9po1b+dPNh1d7PZG3IxkK8r/5/+TPLwrnfjicAmoBkGjV6?=
 =?us-ascii?Q?cPTNDUcU70EL7uPhWnoDKWI61xZ46z0BmlnbCaN/pnjdi1k4Tj87LF4EAQpY?=
 =?us-ascii?Q?l92/AOWmH0TT7VniFKb6IEkCo2ctu/ZrI5TvhDLrZMarLgNteIhlcy0149DG?=
 =?us-ascii?Q?TIriPRWv7gI6wxgtEaCFPfTm48EezTrNAm2lerDe1l262hzrh0eUswGD9rNB?=
 =?us-ascii?Q?XND8c97AQtuQaB0m4SB51VtWwZEy/IbJSyCf7lQ+m5FE6x+OJOyvokKz4vZ1?=
 =?us-ascii?Q?NroRLaxpBXEKGVUF8R/wr55UA3eY/guFXkVsp/rPVPaWp1gWJvn0m1m6qMH8?=
 =?us-ascii?Q?/KSzmru2Fhgj+UnqAAGq0WNqMFemqMjXWBuasAPlxVsLrrv8oXPN7Yr5mTsU?=
 =?us-ascii?Q?3aNtjPZ5NhHsx7xuSm0pzwLcGI6255J7hA/FQKoOhB9J/aa0j0YwNpl9s4Gi?=
 =?us-ascii?Q?gWRBB/TuTeZVA+2DaPmI6ZWycNvEGjYS/EGnzkT7bghE6zYP8hrRhJ4IBSjT?=
 =?us-ascii?Q?7dYhzB0FaYBis3O0IooIvr3DV+E0KYq5GbZblI2N0bgRUHh7q/fKjaoqXk2c?=
 =?us-ascii?Q?R05bEge1aqVz6p9+j8deb3eT+sGxLUGGePA3WY2/lElUdA9yhWgpvJFp7yEr?=
 =?us-ascii?Q?R1qfpHE/01qjee1Vig/u7aMar8vRpgRoj7AtypwVQ3+Buswbjn6XohCKwloi?=
 =?us-ascii?Q?Nz9zYlTFOqdEDy7NQYVU3cjvPxkj2ddyuZm/SfasuAawPGpO2f1IFkLIxC3K?=
 =?us-ascii?Q?lKtH1OMpJa3Rk9jxepEVyOeaZNmqIC3HM8T5j3teMhxeA6OqE+wgg2k3Qdbq?=
 =?us-ascii?Q?fSEmhhQamakjGrH5Cz/4Lhjky+W7HcLoi+l4TDVHATKKjK+qdjdOYlbUX9xW?=
 =?us-ascii?Q?2m7/kiub5TXg72L6z75swsN4c/PQxK8YVEiVC9WKSZdptfF/9QEQ0pkkspKs?=
 =?us-ascii?Q?03veGjaXAbGfmPOTBk+L1bKaMhlzlQYpsX6wNkwkAQLIOIolK6pjQk3oOQNx?=
 =?us-ascii?Q?6FJLvWAmBfy19UNq2j+DtYLQh5rmmXL3cT73BYTfql36IMRY8uHWjIy0iJOc?=
 =?us-ascii?Q?bp5397hho+IoTtUGtz/OX9Npf1kxMMtwgi5AOvGbg1dIkDO56s+UTPqUs8jZ?=
X-MS-Exchange-AntiSpam-MessageData-1: ratr3z1EF3+MebwfLqgdy8qFV0j7sUgtTKU=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c64d73c-a2ba-4d4a-f41d-08de73c4a1af
X-MS-Exchange-CrossTenant-AuthSource: DU0PR08MB9003.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2026 16:49:09.7853
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kAGLjWGEQZrYtn2aEJTXRs1TdTy44VLDyll1iHFAQRurb5NcuNOyyRc7NRev4IDZOLHcqzhxo6svLycvZBLOzjdO8syfTKo5XhFA0zcOUqE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB7763
X-Rspamd-Queue-Id: 71012140008
X-Stat-Signature: ur1asfugemu6yna3zpk3sn53rngwdcc1
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1771951766-788211
X-HE-Meta: U2FsdGVkX1/fJgm5+YbM6TSHipUAlVUe/fiDQn+sb4WoIX33VcK4O+i7ZWm+tdvLuHIe3CarFJM3lxYQc21be5sHADkZHGA0+APVvmAExG5UlQD8MKFLuFtxzGYweE03Kv48DAIg30n8krgi6wpixts/B/gfp8bORfDxHcSawok1NMpw/GThhuAP2Ap96eaVMKa8jWzb0CmbDldYykQKi04ldSMhVfPwv978yNdzy/6k2LN0Z+zIp9AMjz0QEdw2ACMef3WcOooIT+Lfpor4STZ11JzsIRc1eXa5MHwE1aO2DOc1htp4cOZfpucO/zz3mtdKHzubdWAWCQilA5pOvlzZkiyhEk556A7OXNJcuUiEEoJ6dvoJE3WkJO2KLGMOpzeIIR7ZJEiufRfDb62Eq3VPuJMGx9/m0Q3/6zwiF1wNk3Wyw5quxMLarH/+EiE+PwF7U8trFgU4MgIsnbA6qImKnXDjCWwXxDYrpt3RpzNn1fogaffP0heaQiv0u20gwAT3Kwb+y06WlmaRbXZhzgqm9HA+jUp5fe/yRadNxBcPmAvWX5z9K+qPJ/sf+nW1nWGz2PLDnMZg+vJ8UJ/xhTDNQO+TkOHMjHGsi+XgGBzUHfBGfnts5Ofg3cghoeV4KXYXCkK0kFjQSw48nspcKLIMVFIE/cje+KEp7Gyt5tk5/u/zywOG+NUUp4aWMSw72lM98w9T+OyCXGFPLJo62SrgWyYm0HHYBxPRvJrV24m9xomVbXIfDhyIQ9h1fSS0OBl2MNZTTLpLkZYdjqYr2lE759kJKTUfDVWcedOopHYJCwu/Zx9DdiUSu4D52bMrsc5vwupOxG9eipjPAzdjMgdEqRzSNbp4XLxGRjIhf6seqsEpdx+bXe+haraJcMMHZzLvZLq8FVxiuVKAyhgnlyFl9AD2nFM9+8g4ZsZ7mnkrdtxVdfALdqTnPZybltz+nl2RX+VtxRiNKNSPg/h
 ME4fnzls
 d+hAoGR1m+DPPsWoVnQnu2PwSZ5pPVXcbq6RsuBGEKAj5FPA5+MgAV9elB1nJyZlL9/sG0nnEhkpi3Yo8R/gl8iWOfvN5D9D7mCDPPgxIF3KKhmgP9VI5XDxzh4l5SNMBoKbeCswRl2FeD9sj1Cejqmv5jEmaVsLkbXHT1ixCwwFiUpy0Vhed53y4bWL9i2PzA8di6d3fxUliOf7qYe8OjxD4Y/cmPTuR4xJXYv2qA7C5yft+MSifsy+5ItVTN3FCWmidppooGOlqgoWde/z4ZgrcRr7VVD05KnkbI+hJ+qMVekURLT6vvWnN5wqwqb7OavYA1ZNu4CjT9JeFpJVMLjCdwdH3kP+P2fF10GuUUMmuNjlloWzsSfFmauwCQgaq+5WwfkPEz6eckARXVr/DlJlhFNU/x3NUsU06LyavsQI9hyttnXcbCQZUTQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

First testcase "pidns_init_via_setns" checks that a process can become
Pid 1 (init) in a new Pid namespace created via unshare() and joined via
setns().

Second testcase "pidns_init_via_setns_set_tid" checks that during this
process we can use clone3() + set_tid and set the pid in both the new
and old pid namespaces (owned by different user namespaces).

Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
---
 .../selftests/pid_namespace/.gitignore        |   1 +
 .../testing/selftests/pid_namespace/Makefile  |   2 +-
 .../pid_namespace/pidns_init_via_setns.c      | 238 ++++++++++++++++++
 3 files changed, 240 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/pid_namespace/pidns_init_via_setns.c

diff --git a/tools/testing/selftests/pid_namespace/.gitignore b/tools/testing/selftests/pid_namespace/.gitignore
index 5118f0f3edf4..c647c6eb3367 100644
--- a/tools/testing/selftests/pid_namespace/.gitignore
+++ b/tools/testing/selftests/pid_namespace/.gitignore
@@ -1,2 +1,3 @@
 pid_max
+pidns_init_via_setns
 regression_enomem
diff --git a/tools/testing/selftests/pid_namespace/Makefile b/tools/testing/selftests/pid_namespace/Makefile
index b972f55d07ae..b01a924ac04b 100644
--- a/tools/testing/selftests/pid_namespace/Makefile
+++ b/tools/testing/selftests/pid_namespace/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 CFLAGS += -g $(KHDR_INCLUDES)
 
-TEST_GEN_PROGS = regression_enomem pid_max
+TEST_GEN_PROGS = regression_enomem pid_max pidns_init_via_setns
 
 LOCAL_HDRS += $(selfdir)/pidfd/pidfd.h
 
diff --git a/tools/testing/selftests/pid_namespace/pidns_init_via_setns.c b/tools/testing/selftests/pid_namespace/pidns_init_via_setns.c
new file mode 100644
index 000000000000..7e4c610291d3
--- /dev/null
+++ b/tools/testing/selftests/pid_namespace/pidns_init_via_setns.c
@@ -0,0 +1,238 @@
+// SPDX-License-Identifier: GPL-2.0
+#define _GNU_SOURCE
+#include <fcntl.h>
+#include <sched.h>
+#include <stdio.h>
+#include <sys/types.h>
+#include <unistd.h>
+
+#include "kselftest_harness.h"
+#include "../pidfd/pidfd.h"
+
+/*
+ * Test that a process can become PID 1 (init) in a new PID namespace
+ * created via unshare() and joined via setns().
+ *
+ * Flow:
+ *  1. Parent creates a pipe for synchronization.
+ *  2. Parent forks a child.
+ *  3. Parent calls unshare(CLONE_NEWPID) to create a new PID namespace.
+ *  4. Parent signals the child via the pipe.
+ *  5. Child opens parent's /proc/<ppid>/ns/pid_for_children and calls
+ *     setns(fd, CLONE_NEWPID) to join the new namespace.
+ *  6. Child forks a grandchild.
+ *  7. Grandchild verifies getpid() == 1.
+ */
+TEST(pidns_init_via_setns)
+{
+	pid_t child, parent_pid;
+	int pipe_fd[2];
+	char buf;
+
+	parent_pid = getpid();
+
+	ASSERT_EQ(0, pipe(pipe_fd));
+
+	child = fork();
+	ASSERT_GE(child, 0);
+
+	if (child == 0) {
+		char path[256];
+		int nsfd;
+		pid_t grandchild;
+
+		close(pipe_fd[1]);
+
+		/* Wait for parent to complete unshare */
+		ASSERT_EQ(1, read_nointr(pipe_fd[0], &buf, 1));
+		close(pipe_fd[0]);
+
+		snprintf(path, sizeof(path),
+			 "/proc/%d/ns/pid_for_children", parent_pid);
+		nsfd = open(path, O_RDONLY);
+		ASSERT_GE(nsfd, 0);
+
+		ASSERT_EQ(0, setns(nsfd, CLONE_NEWPID));
+		close(nsfd);
+
+		grandchild = fork();
+		ASSERT_GE(grandchild, 0);
+
+		if (grandchild == 0) {
+			/* Should be init (PID 1) in the new namespace */
+			if (getpid() != 1)
+				_exit(1);
+			_exit(0);
+		}
+
+		ASSERT_EQ(0, wait_for_pid(grandchild));
+		_exit(0);
+	}
+
+	close(pipe_fd[0]);
+
+	if (geteuid())
+		ASSERT_EQ(0, unshare(CLONE_NEWUSER));
+
+	ASSERT_EQ(0, unshare(CLONE_NEWPID));
+
+	/* Signal child that the new PID namespace is ready */
+	buf = 0;
+	ASSERT_EQ(1, write_nointr(pipe_fd[1], &buf, 1));
+	close(pipe_fd[1]);
+
+	ASSERT_EQ(0, wait_for_pid(child));
+}
+
+/*
+ * Similar to pidns_init_via_setns, but:
+ *  1. Parent enters a new PID namespace right from the start to be able to
+ *     later freely use pid 1001 in it.
+ *  2. After forking child, parent also calls unshare(CLONE_NEWUSER)
+ *     before unshare(CLONE_NEWPID) so that new old and new pid namespaces have
+ *     different user namespace owners.
+ *  3. Child uses clone3() with set_tid={1, 1001} instead of fork() and
+ *     grandchild checks that it gets desired pids .
+ *
+ * Flow:
+ *  1. Test process creates a new PID namespace and forks a wrapper
+ *     (PID 1 in the outer namespace).
+ *  2. Wrapper forks a child.
+ *  3. Wrapper calls unshare(CLONE_NEWUSER) + unshare(CLONE_NEWPID)
+ *     to create an inner PID namespace.
+ *  4. Wrapper signals the child via pipe.
+ *  5. Child opens wrapper's /proc/<pid>/ns/pid_for_children and calls
+ *     setns(fd, CLONE_NEWPID) to join the inner namespace.
+ *  6. Child calls clone3() with set_tid={1, 1001}.
+ *  7. Grandchild verifies its NSpid ends with "1001 1".
+ */
+
+pid_t set_tid[] = {1, 1001};
+
+static int pidns_init_via_setns_set_tid_grandchild(struct __test_metadata *_metadata)
+{
+	char *line = NULL;
+	size_t len = 0;
+	int found = 0;
+	FILE *gf;
+
+	gf = fopen("/proc/self/status", "r");
+	ASSERT_NE(gf, NULL);
+
+	while (getline(&line, &len, gf) != -1) {
+		if (strncmp(line, "NSpid:", 6) != 0)
+			continue;
+
+		for (int i = 0; i < 2; i++) {
+			char *last = strrchr(line, '\t');
+			pid_t pid;
+
+			ASSERT_NE(last, NULL);
+			ASSERT_EQ(sscanf(last, "%d", &pid), 1);
+			ASSERT_EQ(pid, set_tid[i]);
+			*last = '\0';
+		}
+
+		found = true;
+		break;
+	}
+
+	free(line);
+	fclose(gf);
+	ASSERT_TRUE(found);
+	return 0;
+}
+
+static int pidns_init_via_setns_set_tid_child(struct __test_metadata *_metadata,
+					      pid_t parent_pid, int pipe_fd[2])
+{
+	struct __clone_args args = {
+		.exit_signal	= SIGCHLD,
+		.set_tid	= ptr_to_u64(set_tid),
+		.set_tid_size	= 2,
+	};
+	pid_t grandchild;
+	char path[256];
+	char buf;
+	int nsfd;
+
+	close(pipe_fd[1]);
+
+	ASSERT_EQ(1, read_nointr(pipe_fd[0], &buf, 1));
+	close(pipe_fd[0]);
+
+	snprintf(path, sizeof(path),
+		 "/proc/%d/ns/pid_for_children", parent_pid);
+	nsfd = open(path, O_RDONLY);
+	ASSERT_GE(nsfd, 0);
+
+	ASSERT_EQ(0, setns(nsfd, CLONE_NEWPID));
+	close(nsfd);
+
+	grandchild = sys_clone3(&args, sizeof(args));
+	ASSERT_GE(grandchild, 0);
+
+	if (grandchild == 0)
+		_exit(pidns_init_via_setns_set_tid_grandchild(_metadata));
+
+	ASSERT_EQ(0, wait_for_pid(grandchild));
+	return 0;
+}
+
+static int pidns_init_via_setns_set_tid_wrapper(struct __test_metadata *_metadata)
+{
+	int pipe_fd[2];
+	pid_t child, parent_pid;
+	char buf;
+	FILE *f;
+
+	/*
+	 * We are PID 1 inside the new namespace, but /proc is
+	 * mounted from the host.  Read our host-visible PID so
+	 * the child can reach our pid_for_children via /proc.
+	 */
+	f = fopen("/proc/self/stat", "r");
+	ASSERT_NE(f, NULL);
+	ASSERT_EQ(fscanf(f, "%d", &parent_pid), 1);
+	ASSERT_EQ(0, pipe(pipe_fd));
+
+	child = fork();
+	ASSERT_GE(child, 0);
+
+	if (child == 0)
+		_exit(pidns_init_via_setns_set_tid_child(_metadata, parent_pid, pipe_fd));
+
+	close(pipe_fd[0]);
+
+	ASSERT_EQ(0, unshare(CLONE_NEWUSER));
+	ASSERT_EQ(0, unshare(CLONE_NEWPID));
+
+	buf = 0;
+	ASSERT_EQ(1, write_nointr(pipe_fd[1], &buf, 1));
+	close(pipe_fd[1]);
+
+	ASSERT_EQ(0, wait_for_pid(child));
+
+	fclose(f);
+	return 0;
+}
+
+TEST(pidns_init_via_setns_set_tid)
+{
+	pid_t wrapper;
+
+	if (geteuid())
+		ASSERT_EQ(0, unshare(CLONE_NEWUSER));
+
+	ASSERT_EQ(0, unshare(CLONE_NEWPID));
+
+	wrapper = fork();
+	ASSERT_GE(wrapper, 0);
+
+	if (wrapper == 0)
+		_exit(pidns_init_via_setns_set_tid_wrapper(_metadata));
+
+	ASSERT_EQ(0, wait_for_pid(wrapper));
+}
+
+TEST_HARNESS_MAIN
-- 
2.53.0


