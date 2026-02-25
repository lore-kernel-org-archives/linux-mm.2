Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4BB2FD375D
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 13:34:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 405266B00A0; Wed, 25 Feb 2026 08:34:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CF556B00A2; Wed, 25 Feb 2026 08:34:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BACB6B00A3; Wed, 25 Feb 2026 08:34:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 18B546B00A0
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:34:45 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C6FF0592C2
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 13:34:44 +0000 (UTC)
X-FDA: 84483074088.29.0127717
Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11023093.outbound.protection.outlook.com [40.107.159.93])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0DD7640012
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 13:34:41 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b=xXrtYVos;
	spf=pass (imf11.hostedemail.com: domain of ptikhomirov@virtuozzo.com designates 40.107.159.93 as permitted sender) smtp.mailfrom=ptikhomirov@virtuozzo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772026482; a=rsa-sha256;
	cv=pass;
	b=tnMzwlVbkryCmzdBzXgD5dR55TjKWh6hNl6AEtXB9/GNToI6KwAbU8QU7zh+VFvadYYlWk
	KtSg/wqwLc1VCeWuX9AOOpE55k/q+Tn8DS6N794IiTWDKYS6PDvN/y7O96mW2+P02mBmqL
	bhz0vB2Ws36eyQhM8pB/y81cGVv3Ji8=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b=xXrtYVos;
	spf=pass (imf11.hostedemail.com: domain of ptikhomirov@virtuozzo.com designates 40.107.159.93 as permitted sender) smtp.mailfrom=ptikhomirov@virtuozzo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772026482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=j91xF+L5ASk/KmVLwlC5zoXqX+ORa3rL3FvCYalXWr0=;
	b=J6m6fNrdQDitJrMlKho4VaQztRaUDgzoNX9x6e9b5eH3e9askZ9027q9ChlRsOHyJaZlAl
	cd0rCssQ9pdvAcY80rl46DNAW7N3AmxulW2hVNWrlnrEyAsrP19WQUqyLxk9aBOIusNyPC
	ezWdhYogMQhbYEeV9jvJmEmIv5ubXW4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h+8ywzEtQNykhLpAEsu1CsvKtlfKvqAUTSkechCo60QwWPN2TJMsEwTu6TOyTJoYq7Klvn+didOXpRc0xl+Zqhqg0APWYpFsEZLsYba+xoUNF9An8zCOH3lLfQ0c3aLgsaDFAz+K1I3pZORKgkyeCSqBvy8VwZjiD4kkgOhFA/IEpilCvCjLsiWGvs8a5g1VSXXxpmsntPdfjPU6LN//BdfNl7oI4SGxAXENs//Zr1PFuPDxvtdkuTkaKKlK0cKY1QSYpo8pF1PFgccw6yXUGso5e/UIe7x1GUSyrkF1FDdiJtRK6gnA6E/GPVda8PQuJzfGYlLLJ7sCKTHrRLgx0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j91xF+L5ASk/KmVLwlC5zoXqX+ORa3rL3FvCYalXWr0=;
 b=BXRm70AWmSQgom3loJWRC+jjZiGFTDG7bHIgOb30XJZMiSQ/r963ROtY8S63YiiGJrNr/EFV9VvclwHrKWJT6O1I8eLjMLp1RU2w8eBEdW3nVwuBkjEGdWE44oZnJXr+WLo8vRWdYDcS3HQBLn30RdD1LQfnMSMEXmfEQMrJ6DNVCKNxcHBxFw5sfeU12OxThljCyO8BSGKMKGccUObVrNy31BoSF762oo8dAOAQV66Ee4CvFQA0ub2nD04J9OeluoRAwPf95DHhFuomL35HSsgDizb97Ll/aYNwvJzQ/m61jl+0+Oj5jUmMDfP9OOuciNJfGFd9Jh9ESiXzhcWpAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j91xF+L5ASk/KmVLwlC5zoXqX+ORa3rL3FvCYalXWr0=;
 b=xXrtYVos3LOdoDrqSqeLk8m4TQ46qL8Ldod+S1eSPvVFRe+j8Y7+OaArMDLfEhKK3KT5OboZRi4jV5eWo8QtWrXDQFsyPvwtAwv2PEbbY/nGQ/l3HamVgYQSxk3uIjYBCfkssxl+vKG8kOxttbqzKsUnNrzqbH7NoPHzWGJnsAE2/E4dq3Obn+G5qOkpLKqIxgr6fRflUtD410azXuV+biJSnTeujYM52rOfqw56e/xp9tV1+1XG1fE7xdwpwcuJTVnYQPXfQ0e0WeUn6ln5yp59uV9QYmB+yCLm6S9Iv7lZGtOcjRBbHSQ8GUm2JxssdskaOMxhKIWUgn7ZaBBb9A==
Received: from DU0PR08MB9003.eurprd08.prod.outlook.com (2603:10a6:10:471::13)
 by GVXPR08MB11715.eurprd08.prod.outlook.com (2603:10a6:150:317::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.23; Wed, 25 Feb
 2026 13:32:53 +0000
Received: from DU0PR08MB9003.eurprd08.prod.outlook.com
 ([fe80::3470:51d7:36e4:36d2]) by DU0PR08MB9003.eurprd08.prod.outlook.com
 ([fe80::3470:51d7:36e4:36d2%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 13:32:53 +0000
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
Subject: [PATCH v4 0/4] pid_namespace: make init creation more flexible
Date: Wed, 25 Feb 2026 14:32:22 +0100
Message-ID: <20260225133229.550302-1-ptikhomirov@virtuozzo.com>
X-Mailer: git-send-email 2.53.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BE1P281CA0277.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:84::18) To DU0PR08MB9003.eurprd08.prod.outlook.com
 (2603:10a6:10:471::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DU0PR08MB9003:EE_|GVXPR08MB11715:EE_
X-MS-Office365-Filtering-Correlation-Id: 45c7f724-1f79-4374-4d04-08de747260a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|52116014|7416014|376014|10070799003|1800799024;
X-Microsoft-Antispam-Message-Info:
	Jol/f9gSC6v9MH8XAH61zwHInpfZ7IgxdAAKM5XMlxm9H4x8bT0VrCcL9Cm1pFYwgtGQr1qlnsW+1ARPrRv5axZCAfSO3+Zli1BCJiBCYSlZL6eANBccioIHiJrASR3dmGysbOksrvIwSmmWQI98jSdOhKTdE/o/qwgkQxUnYxo/sNidF6ktgSTzOAJuBKIkHufeWJtwy4PryjBZ8/wdvUfKMiqp04krITltR2lgOAAT22sso8g8Cejkx0xNoFkjqh4EcDpamSCNu+rWKXZ3HMt2HWknRpyfv/Yr/EG09nXsM9S13G/Libw0gHtS3CWW50cUswD9dhK++iyh7UdUV0M1Tj929wngQm0aS3+TkknWm1E09czgyclkUdSbZ8qBN1uv33OxLNAlGu0XNTa3rE5gP8WU6ld2A+i9Ixuv4cnF4czmM8nYmoIbLB+ex+S6fSW1YU9tHhTnfnD5n9r/5/SB1+Pw4rUkiyS/fkXYI5KnLXxqC15h+bs+QJ3Svv091LBtHvB0yBx6vtPXxBQ0uTohbQIFfX/AnxoBq1AiqN/P8x+fIgkjpgfstjuTli51zxAgK2/wXbjmIZVS3C7kY7n7vePnPkZo0uDmIp78A41BALS1WkKXCNpU4LyonCpFpATk2H96x9GUwhg8qYYpGVqRLcV3AdlknzemfsBwj+qaUxMmYPjUaF6xLIy0Eo7lGNC0FzTUj/KmNDfwibwHSDE80kaDN1FuIfhF3lKLlHQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9003.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(52116014)(7416014)(376014)(10070799003)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dkN1RkFlL1Zuclg0Zk9vWnUvSWJlM1E0a3QwYWt2VU14azZ4UEllbndDUm5l?=
 =?utf-8?B?UzU3eUNucUJsS212c1JZdGR0VE5JNStGVGJFbXdyT3dnbzZEL2loQWx4SnFv?=
 =?utf-8?B?NWg3aHMwRHJxeFFCakZRdWxzRS96UEJzN1JZMnNhSTVxQS80K1pOalJaby9N?=
 =?utf-8?B?V0JyNzRmQk9Walh1SDRsZ1ZJZ2ZyOXpZV1NRQkN5S3dkZ0toYVRyc2pzdFJX?=
 =?utf-8?B?MUVURFVqSHBIWDJEUDdyRkVhRnlYcytKYXJSeUZmOXVSeVM0a0Y5RTNORlQ0?=
 =?utf-8?B?N2EzZUhXTDAxQmZFd0JuQ2djdElSZUhwWno0V2x6d1I0d1NyelkvQSsxMkZO?=
 =?utf-8?B?MXVBc1VnQzlqSExtRHRUOUdJQkJEWkFRb1lMTkxhcWFTWC9kdFM0MVlHcGUx?=
 =?utf-8?B?UkZJRDRzd3d6TG94bnhtYVpUV2xGL1NaRm9GSElMSWd4M1R1RlYwejV6VjVy?=
 =?utf-8?B?bXBONXp2TGpiT3RlUVI3c0JvVm11b2JQbmgyT1hFUmZnVHd2dkEwM2ZsYndl?=
 =?utf-8?B?elZ4c0tGVUxDZlFiOGM4UlpVbmoyekNKRXdXejc1L0lxajJ5dXRSWG50OFZN?=
 =?utf-8?B?Q3JHNWlRUlBhNWc5MlBLTkpaLytHVzZZQ1R3NjBBNERML1VWZ3lZNUl4VTBw?=
 =?utf-8?B?U20rbmZNaUVydEdxWEIyUld1YVlyblBEaVpTUm1ZSHVaSmgzY1BzSHh0M1Fv?=
 =?utf-8?B?Q0U2S1A3aEk3bFBpQzArNGpTMGkxbkVFbTNxNnNlNnlodzhOd1NpaFcvZEVo?=
 =?utf-8?B?U2JjTkFVMXhiV2pLYk5mSzFCdzVZKzI4TXFPcFE5V0hyaXkrMVJPN0xhbzZq?=
 =?utf-8?B?NWFNa0RPZi8ydWoySGVzQTIvUkRXMENxcGlqV3J2cDc4ZUJ3WGpES3JHVDh0?=
 =?utf-8?B?SUY3aFF3WHh2RnJLZnR1ZDB3aDZRWjFuNnlQQWhaOTg1bTdoSjBrbDZod1d5?=
 =?utf-8?B?VkJhZkw0MHZsM0pmb3ByN3hLeVZ0VDg0dCtGeURFcjNlby9vK1VUdE1lZGZR?=
 =?utf-8?B?WlJuaDF4MzZOVExlaWhXUk81NGN4VXZCdGpYOS9RY05pNmp5cDJ3QmpCRW1z?=
 =?utf-8?B?R1BTN0pSZmIvQ0ZXVGZkdEFOTEZkWVVDbCt6emJxdEJjLzhlc1BXOWd1UUxQ?=
 =?utf-8?B?elQrWXhCbUZEZURLcFJtTkhyYytUMHdMdHN6ZW9heHZ1dkFQL0drVFQ0MEQ5?=
 =?utf-8?B?NHFpU1dhZ0lCWG44dlVSdWhXRWtUMlZaQllDbm5DMW9KMmhiQ3R1cFZJRjNX?=
 =?utf-8?B?ZjIwbG5jd0JPcldHMndDbUU5d3YvVnZ4NVhQLzhqbTZkOGNzYktGL2g5Y2x2?=
 =?utf-8?B?S3FQWTZZU1lLUnBhRlhpK0p1SkFDRmdQR3JFV1Q3VXk4R0djYWJuQTBJVW1S?=
 =?utf-8?B?M0J6aWxpVFJwSDJhK09UT3pUOFpobTRhc2lwNS9XVnNxMFpnNElEOGFTdmxi?=
 =?utf-8?B?RkRKK21Ec3MyUGw3bnQxUmYwQ0U3eUZPV0VhTnA5T0VZdHQrRnBEVHdBZWlL?=
 =?utf-8?B?czhnMDN5L0Y4WmZuMkhrcUttRzF2aGFhbUx0L0JWbzVOZjQvOERnR3RFWGM1?=
 =?utf-8?B?OEdDeE5XR2s0K0F1WVk0U0ZmaDl2bVhGb2orWUgyVDh5QTJNRlFvaDZaZ0N1?=
 =?utf-8?B?VlZ5SjZQZmlpbm45eE9EdnZtZWNjOTF0OGVPR1FnazNaMjNXd3pFNmxnQkhi?=
 =?utf-8?B?YjVMRExweU5aUzhMOGRuOW13K25zYkRVUTZHYUVYUDJOV2ljN1NGWDFNZlhZ?=
 =?utf-8?B?akdrY0x1RHRQMmJzOVZPZE9aaFZDMTlsUWNIN0cwcWNPNTNKb3ZTVFljMFBi?=
 =?utf-8?B?RE0rU3VjUVR6b1FicmMrMjJrQWdyM1JYOXJTZXFhMVczSTJxTVJ2OUo3YnNH?=
 =?utf-8?B?NktzdTlZKys0WmNVTlE3MGhiVnFwd05EaFlYNzBTWXlXczExbWtrRUtqVlVR?=
 =?utf-8?B?U3dIZ1RJZ3NwQ0hGTTg5aUFrMFQxL0dNbU1XMC9nY0Ruc3AwdTZDejlneit3?=
 =?utf-8?B?Q2U2VGwyRE44Y1h3ME1tNy9sZm43NmNyUnZ2Z2ZCK2ZhbXpWV293RWdlc3Bh?=
 =?utf-8?B?RTBuV2xUZGdtK3FWZWxYVE5GOTA1elljQ25naGlhSjFHcng3NmVtZytKT0M5?=
 =?utf-8?B?UCtvYVo5RktJZzJGZnlpeVNqZVR3WDFTOTlUN3VoeU9hQ1NKcDZRMzY3RkEx?=
 =?utf-8?B?Q2Z3OGhkblNQT1NaZ0twcmJubTJJU2Zaa3lOUktEbHBlK2hrbkEraU1SN0U2?=
 =?utf-8?B?MzVhZExXQXU4TVdnZ2MyaUtaUWxjQ09QSlJ4WGxEeDRHSHhmSTc5U0w1VDNn?=
 =?utf-8?B?ZFVobHc1MDUrZFQ3ODEyTGZzWmJxenM1UmtsdWlCSzNoY044cGNFbkt1TW8v?=
 =?utf-8?Q?s7VvXENjulu784Fy+vlaAvEPwOk+l0PagpzS7xupbBSGP?=
X-MS-Exchange-AntiSpam-MessageData-1: l7OANYWOSUw2klRx9X30CUeCnmtZmtNVI10=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45c7f724-1f79-4374-4d04-08de747260a1
X-MS-Exchange-CrossTenant-AuthSource: DU0PR08MB9003.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 13:32:53.0877
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JpKJXlKco5WYjx795k/aT5i1F6oG2sXLLghhzgasCE4cDPYI5ZC693WT8gL50GYn49ix1I9wVC4g6iZBlZmAH9QoMCuPWLms28Z7oMYHxCw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB11715
X-Rspamd-Queue-Id: 0DD7640012
X-Stat-Signature: ffwuopi5a9h5js5upxiwx9oseap65mzi
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1772026481-751218
X-HE-Meta: U2FsdGVkX189Bf72I3XmFM28yvdqwGP05dDrskLopyEZXBzTUspq50YtZgpKVApHfCN10wKGg2xuFwdsuyUpEdAi5BF7OM4drz4m6fJvp4Rc0V/5t+H6pd92qe2Mhh/eKzHWaKzujD0wuHE5H5FPesjrDDSsyjGYS8BTDzopZTj17+1XsDxHDzQ4W7MIkYHqCj2Po0frb4vbUVYssEAVRDOhny2MlI/xjvuAXr+qWj308FD7BUzCNApJJCFb5C+tpapzVCRkh5cX8O+KjPYW00JTftxNG1RuwzTCaWvWSyomqQJl0rgUMkdD23nm8F/7ho//fulIBjB2ucl3QxjspS3+4vRTjcx6eP1K/wuIDJ26sk9iUInGT3hXGv6YObMkpc/jWTjQCQhlt91mRhJrTgBGyRUNlbkExgY5RypiXC6IMU+ibTdoerZU5pMNC/4swkCMmYA75GeiNWslqAOai+kWX3TYRBcdNHdnJ4g7lT754axXM2PrREjbnKWkP9rGzNvfUQGm5lEgt7YL9XrIKL2TWQZH5U3JnqufSqLVxFISA3fFlFax8Z1GIcZ+C6n6VcecOHBG25pY7Fsn9PXlaQhdAEnSVf+rXhwOdVA6wviKvvWh7Qgm0jYl+kVbMyrKFfn0uiaTO3VlSsIx0oAX84w5Y+CuJqM8dleGSMwijil6Iq5lLUV+3XdCbxPXntlG2dkuQDGg1mPV0eUDJF+x4uw/BgEMe3el8dc7LE1idhBj7Uua+MbLFhuHaoZzasIHR2rkrXyfQTp9aS+1W8t09e0G3q4wcxeatzBlK3hIiXWLgfbBN5XpqlrInKg/H0afLwl+WeHCDShi/gRqrdoRrG1H20TtxBbud9vqwe220qaEFa5jR7a4VUKsumxsmuddsM7i6EvoSQbMDVHK/RgqdUQWP04GrwhG6E28RLZlkoiUdGjzuYmlZtOaDWr7EWn2FAiBSxzX4SuEaoz8Tss
 8nTr8LTc
 onLvQtnyDXy+cKGBKuI7V0M1/rU43RO/wu1/d1sJoCyP0uBRfd9dQpY0oDugNbywrDXcnCBhLonNYKpB6j6S0NFT0CH87ZpbRWVqHRHw8q/kHufH/t7qCzz+P2Tca8J/2xLmGpZJefs51JSBI406fhS5lkvpw4AuyVdtFCEDT+r5nONH2oYvIkfJYWXRmA3HdIqiAo6qtyL28wmiA0zzTPruvUAOwBgJA2SLinHy66KmfXsRyODgOdcciFcIgvg8rYLRm1BZXAWVTocQ9YrLH7vaQEyP8jjK2hK5G7M5vy5Nf7kXP9bHGEpka/y3IdnRgSBvqNIAFrI/Yyxon2IjSv088SnbRKf2C7cXX4fzt5pVS32X64rLCuN7SaY7MNwSzz+3bsNca8O1hO/aXqoM3A+n1b+tmtqTqOQCWxH0Do6K1PaEm2kwiHghAPrXG2VEYjF3XNq0ujVnPFy6/Xoi/BmsNovrjI5fChCuzdBDL932DOugP2m0nLz0FPP7/CGwd983W0wYWSABwv6M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The first patch properly annotates accesses to ->child_reaper with
_ONCE macroses, to protect unlocked accesses from possible cpu/compiler
optimization problems.

The second patch makes sure that the init is always a first process in
the pid namespace, previously this was only checked for set_tid case.

The third patch allows to join pid namespace before pid namespace init
is created, that allows to create pid namespace by one process and then
create pid namespace init from another process after setns(). Please see
the detailed description in the patch commit message. It depends on the
second patch.

The forth and the final patch is a comprehansive test, that tests both
basic usecase of creating pid namespace and init separately, and a more
specific usecase which shows how we can improve clone3(set_tid)
usability after this change.

This change is generally useful as it makes clone3(set_tid) more
universal, and let's it work in all the cases evenly. Also it is highly
useful to CRIU to handle nested containers.

v2: Use *_ONCE for ->child_reaper accesses atomicity, and avoid taking
task_list lock for reading it. Rebase to master.
v3: Separate *_ONCE change and "init is first" checks into separate
commits.
v4: Update second patch commit message. Include Oleg's review tags.

This series is also available here:
https://github.com/Snorch/linux/commits/allow-creating-pid-namespace-init-after-setns-v4/

Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>

Pavel Tikhomirov (4):
  pid_namespace: avoid optimization of accesses to ->child_reaper
  pid: check init is created first after idr alloc
  pid_namespace: allow opening pid_for_children before init was created
  selftests: Add tests for creating pidns init via setns

 kernel/exit.c                                 |   3 +-
 kernel/fork.c                                 |   5 +-
 kernel/pid.c                                  |  17 +-
 kernel/pid_namespace.c                        |   9 -
 .../selftests/pid_namespace/.gitignore        |   1 +
 .../testing/selftests/pid_namespace/Makefile  |   2 +-
 .../pid_namespace/pidns_init_via_setns.c      | 238 ++++++++++++++++++
 7 files changed, 256 insertions(+), 19 deletions(-)
 create mode 100644 tools/testing/selftests/pid_namespace/pidns_init_via_setns.c

-- 
2.53.0


