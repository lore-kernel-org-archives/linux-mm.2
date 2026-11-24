Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC99C606A327
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 20:50:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A92226B085B; Tue, 24 Nov 2026 15:50:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A412D6B085D; Tue, 24 Nov 2026 15:50:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 909206B085E; Tue, 24 Nov 2026 15:50:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5EC0E6B085B
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:50:56 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E5242A0908
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 20:50:55 +0000 (UTC)
X-FDA: 85471206870.08.4BD1FAD
Received: from LO2P265CU024.outbound.protection.outlook.com (mail-uksouthazon11021090.outbound.protection.outlook.com [52.101.95.90])
	by imf24.hostedemail.com (Postfix) with ESMTP id F1E15180004
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 20:50:52 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=fail reason="No valid SPF" header.from=atomlin.com (policy=reject);
	spf=softfail (imf24.hostedemail.com: 52.101.95.90 is neither permitted nor denied by domain of atomlin@atomlin.com) smtp.mailfrom=atomlin@atomlin.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795553453;
	b=n6vDNv+2yRBlmJDgV+blLdD+jw9tDfYQtcCwcgvCy3sVGT8phzn8PyakWdGCUtavhWEi0z
	ObmkaB3a7tPbJk+YQCMnmqdHbAj/Yf4rSZCxhMcnBcTy+ZvuJCWdPZ92Htwk8/2MeaU1qt
	E8oDR5phQUTntEeoeCtuJoj2i2ud5cA=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795553453;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=Z/SFmkZJf5LvDuConZslxk6OAqgmQR4Rr1QwGogCSPI=;
	b=AJsipzGb/XpCI7ucWuyebbpW2WTNbKXCYEyNNcwdDp4ssIOCrK8wJc9EbZO4+7PXx7yAhN
	Z80HHWqlGuOy4Xz5/yupCqFlXrqm/0UJNhFMZqoOrbV2M72KlkI1ZwpuKetIJ3tNTSOLVJ
	9/vMhW/KkLCHDFPUYxVY5ILl3JVrFpI=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=none;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=fail reason="No valid SPF" header.from=atomlin.com (policy=reject);
	spf=softfail (imf24.hostedemail.com: 52.101.95.90 is neither permitted nor denied by domain of atomlin@atomlin.com) smtp.mailfrom=atomlin@atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lldtRC8u+9rP7/7GcvJMOrbya2++MXwklHNHheOh6AUIKiweAW43Ig5zy7BQfqBBwlNZfGrhIhE0Hk70nOPvC/6NNDp6HppSlXcFA2ESPytJfSsy8CLmlii8Dv6C0Ehsnt2JkDBZpFcwLITSgpD6tpcjlbMLL2PiFCWp5SaTFHXo3tKsyfY4gWKfd8urpot+AzCLmGY3K70OKV4wFAQ59DVkseUIb71wtO0pk0zxZoejBo/HeUEFpV02Wr0mmym7l0Gy9UcYFcG2INwE4daCMdZHlcSAl3VdKcqmuXjhd8fh8BEk5arZ/LvBplavtt9oBEujx+B98Nou9FLFgWb6ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=Z/SFmkZJf5LvDuConZslxk6OAqgmQR4Rr1QwGogCSPI=;
 b=d1topqYPekPO3yj9Y3uejwUR5QbWd4g43ndJQFyA3YSI3DnUFFy8GF9Jxkz0viwLq3VpQOa5T55u/H3XAh75K5GKlYbo6Jy3wz4/tPwq/qBUDXRAFW77Rq2WV5e4a02kDG6RTUT66TmDbv/ZNlWVsGUZWIi8buE2OP6wUnwNXkTPfYaW8KCo4M2cn2GZsSEko+5ry0WN8y9BOV5HDMSusnGrjlaDEma2IFV5G8NV7cWtPFPKApDpZvQgxIy4PxgAww17RPDPC1l3XQ5/8UcPS4O5wBsvb2umxBAWv3TTxrNQ3RssiJHoxN9OrVAmCgaiJhE61hbz9GPryppPnSsq0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Received: from LO2P123MB4190.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:163::8)
 by LO8P123MB7876.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:3ad::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.4; Tue, 24 Nov
 2026 20:50:48 +0000
Received: from LO2P123MB4190.GBRP123.PROD.OUTLOOK.COM
 ([fe80::f71f:a9f:c4de:687a]) by LO2P123MB4190.GBRP123.PROD.OUTLOOK.COM
 ([fe80::f71f:a9f:c4de:687a%5]) with mapi id 15.21.0639.012; Tue, 24 Nov 2026
 20:50:48 +0000
From: Aaron Tomlin <atomlin@atomlin.com>
To: david@kernel.org,
	corbet@lwn.net,
	akpm@linux-foundation.org
Cc: ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	skhan@linuxfoundation.org,
	rdunlap@infradead.org,
	rientjes@google.com,
	shakeel.butt@linux.dev,
	sean@ashe.io,
	neelx@suse.com,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org
Subject: [RFC PATCH] mm/oom_kill: optionally log victim command-line arguments on OOM kill
Date: Tue, 24 Nov 2026 15:50:43 -0500
Message-ID: <20261124205043.1010247-1-atomlin@atomlin.com>
X-Mailer: git-send-email 2.55.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR07CA0001.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::11) To LO2P123MB4190.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:163::8)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LO2P123MB4190:EE_|LO8P123MB7876:EE_
X-MS-Office365-Filtering-Correlation-Id: f9d76868-4fe4-4e93-555d-08df4a6c9da0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|23010399003|366016|6133799003|261009223027099003|18002099003|3023799007|56012099006|261028144727099003|261102123227099003|261022113327099003|261026140227099003|261026121527099003|261022075727099003|261021121427099003|261022105027099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	0v//ZSOMDS5KAFwmf0P5uU16Q+zvstHbgdhHCC7q8eVpfC77qhRDU7CUahtYBpRFXci+YfNNKFATqfn7nux2B1O5Q4xde/qwJH2NUXhk8CL3Gwxw+GSeLvp1AfNwp6T/HpkIL6afSjMzK9SIjgTVd38qV1z5gwkmHpM1LXW5Tfdx07eRMlC4a4JWGxJ1i/qWqjUheVzKcv9t1ej19r2Q4DXg3sTUMCG7GwErk1/P/eVIotJ77HHsXb+nN3aUok7CHvwuYnTkuxqEfp95mVZX2/1/9MCDV4EBUaLRCrcz1wwKK8BgJlj3xe8/sQVw1kjo2wozxDCBnwxgAaNLZlr4DsX3REXSLUl8jaBAZoOPbz7eKmoW85kS2YrvFVEvQbUIxcO8uzP8OTEG55TXn1sXMZuAWpyiicVddvRGflAFqO+0DixRyrhuV+ZnoobKwdqqVGx5wjGsrQVuJsIXvE6+gE20M8m7l+xWR0mgKXDGhGo3hnUVbOt5AXfEf20gaxrhLllaKupxpJf3ZSY3Wq4Wixz/J/HOZh8oQL2n+fufq07r02g1SNLWLPxDpDV5IgehwPyuZuiI+YKGMNHaMW3DvNLEVKWjAjHhLQbgoHRwc5rez95yoLmfw7DWjdqf+yJnrnI9VPfrFvdz+0T9YdEM2n220muft2ffXVG0gbE9V6M=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LO2P123MB4190.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(23010399003)(366016)(6133799003)(261009223027099003)(18002099003)(3023799007)(56012099006)(261028144727099003)(261102123227099003)(261022113327099003)(261026140227099003)(261026121527099003)(261022075727099003)(261021121427099003)(261022105027099003)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?je7HLyCJKFmRHmxNfNlYm8qWzQ9lVe2cyVjnlr+OBPokjpA3PaCEMUNG4wrJ?=
 =?us-ascii?Q?IJ+nR1GxiL28A5iN9xH/gFklt+25fvVSK0fJVnva3zD2l0NSYMYx7ERFmteV?=
 =?us-ascii?Q?rc94HMPl3i+culL93qNQLy8vO1PeL8Q0PxO6uktpslUDLXEaqs5brj0plw70?=
 =?us-ascii?Q?nBjbQE5cJigBxJ6ZEVM/+wNT5f72ghMPrHXG5ju8iTZ3E+x62yMuL8WRG3or?=
 =?us-ascii?Q?I4+MiqWXpq/gzkhVTes0WlZKT24t7JoiOXvErd7PhvNfWSV1XaRHtHCat5fk?=
 =?us-ascii?Q?hqXj4pvkLdmqj4r/mrRkP1GEyeQ7wKcl/lU1kU0jkUs/m+0UWiHJD6vtkoVx?=
 =?us-ascii?Q?g0eewcB4pxI7dbBOa19LSQpYbpeRY4/djWGspWs7XYhKLzDZwu/MvpFQGDzS?=
 =?us-ascii?Q?3n+R/IasBsrv3fCkiLhrGMgG1U1l9iADX3bKWkzN0hzlogWULZOriV/W5PXr?=
 =?us-ascii?Q?JLDEFTcQsS1FdFx9Z3zmtZG9UFhjQ41C2wMrrG8J9ZFhPZ+ZDtTFD0NfseRh?=
 =?us-ascii?Q?30Ag6xjy6Rwb23oSdLTsAsCujsmIB4jF5J7mwjXXibGVCS/wcKQw6zLA6avp?=
 =?us-ascii?Q?sEaU1aEwp156aZm1fTsjGVNUO3ZixaxJNiUH5Pr7MuEbjojOwrSD75kAbaUq?=
 =?us-ascii?Q?DfoqXcAgQpt8N7wL7jiJBCaQC+Cm4tqbv2qKfJaiwFmlXUB/KM+pv93THaZf?=
 =?us-ascii?Q?cwKmwsDK3odHTdQj5eo48Um4sD6spcoGfx2cdXEPlv9LE7V34GK7KPZWahNp?=
 =?us-ascii?Q?czesn/iX49Iw8z3NAl+nlC7dctEmDJaF1llQuE/sdTxG2IuvGS6s87HqpJBC?=
 =?us-ascii?Q?3o7TGuaMO959rN7BessfMAYjPzC0iEdr/qkx2vrcgzgpiTAZCcEl79xIsu2N?=
 =?us-ascii?Q?2Zbx9lXlnoLqxwpUoTBFWs9jSpoz6Yk1s1GX5jbOOmJePjhIk+1q4Q+2IqOi?=
 =?us-ascii?Q?fW+UeouG4E8nnCbCaq7WaxPb9lu8o9zY6BULdfPvYCtF3FaiPoy82lb69jNi?=
 =?us-ascii?Q?sw79iYbzaJlDFxFR9L0jYhPBrioFRbq8kk6V2ncvJ0O3Ul99uvABsIzB3lut?=
 =?us-ascii?Q?T1N/uSaXhbHL3jLkRGova5ao5nXqvNdetVg9kFhbQf+euJpGqNXa5srwTcm3?=
 =?us-ascii?Q?0bG8Lx848ebLemFM8f2wyNnHXPhPdNQQ2vaO1HzEKR8Fi6wWbIVv/H6yVsti?=
 =?us-ascii?Q?TjGN1A+XABUmUkjG94D/P6slEpoO2kLOsw6OJSSNl1ztSDayULS4hY2uh+4O?=
 =?us-ascii?Q?22HEIh1mmPmy/lfgg5pD4NgDX8iDrha4J80fDhwF/tKHctz5q1CeyUv4niUE?=
 =?us-ascii?Q?L5y7XneBZtvyG8mES0Z59PzEzMpYxFSEaWs2EcRtn+yY5mDIwSqpZ/R5/Mbl?=
 =?us-ascii?Q?GZzABJpcZheB35lRO7uBS6Z/2UgF/1qOovpyYWJPQnBMNK9d2ecCLPJJL4XT?=
 =?us-ascii?Q?FxL6YXgsqdUbamF27eamdnDCY3VNPYYHzI2gpvypdpA0txIJPtId2/xE+d/Z?=
 =?us-ascii?Q?jsHcnpFsTzBN/ElzL01INn8lxnDWGCv2vKifiqi3Z100tj5HULxPOInmoa7d?=
 =?us-ascii?Q?rBC+VLfpqCOhsr8v9pvjOy/gOzrqK6gErV5swZV/TSaFW0m5GIljV01T6bn5?=
 =?us-ascii?Q?MdnEVYFrzZa3varjEA7DcwSmeSAX0ep9q0uVT43Hft0Eq+pt0jUot+MqjCEM?=
 =?us-ascii?Q?MHQDA70HIWzCcLCQUvqlYwBJMQ1PIgFCnMAGZu7rPmEwBvrAhML2XVDcL9op?=
 =?us-ascii?Q?zWzMweLWXQ=3D=3D?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9d76868-4fe4-4e93-555d-08df4a6c9da0
X-MS-Exchange-CrossTenant-AuthSource: LO2P123MB4190.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2026 20:50:47.8951
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gy2eSRzI9qMu7MkRGoWiuA4yDMf6LDGKQzvdlUJNCFptEWww53xLlcR9dh4PKXppQrV6WI0c0azC62QvVPG3pA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO8P123MB7876
X-Stat-Signature: ocjxg4iprahwdor6xk85yzspxpfbqiet
X-Rspam-User:
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: F1E15180004
X-Rspamd-Pre-Result: action=add header;
	module=dmarc;
	Action set by DMARC
X-Rspam: Yes
X-HE-Tag: 1795553452-932669
X-HE-Meta: U2FsdGVkX19U5jcIe5O/gjC+nKO6Ui1PuauFEWSKxF7q64xp2Ho6jaLfKuhjYLXwVkpFQgxQE4xNCnhy8u3o8AeipcWvAg2uXj0fMYDIaGLTZKBTmAiPRm9pL4DU9JxoulQy42AC+PsWalIWl5tTcnyfRWSrBxrNLRk82vCltv/u/j7NuoNWl1urRT32L0b075HDBGMIjg1wYmi/7YKtlhzOqiZQI+M0Fij/4AQoEXrhokDMByyPjQtQP2rRT+EThevR/5FDCXGq2Le7AjbgmCmQqNdA6G125CRqcBwMh3MI0aSTEgrjtrURrBwMxKtOf/9O3BklNsLPFOgpUxdzlSTr/MIU8rtmAUSgVc10142Yu2AgCuUZHZ5zbWcOVvawEAfAqroYzoAeBEN9q2/70rEdmRSSOsi0aMHI/U11mvp5VUdsbT8NJY7730LWTBLmsT9v19DrVrgRu+Fubjl5iY4iYlMyMYqCESAGgMfd1hQrBWfdWFewUatKkpV37Pq7ujZ5lwq0Kb9TEpLwiMXRL1s+7uAzqX2MBSN4lOiiiJLUYCsAOdQjPHBxR46KDETG0vwFNlz7vGFkh6ase7HT/fMlI0cN1uJ5gCGgAPXi4ym1vT1XINidXSQCglpOQwta/xyo9R56YbuuikOWVfBirmdjZwW2uFkXdYqpwtWJBqXzcNQcaNBC/YCVSTwayI4rx/uZBfRgBylWa2e0s49wUa9GasMApi7zmCCattTFaCxcrtHMa9a30ZPPVowxFOJv7SF3WnfVidPh1KB2HTWz8CkBtVq6sEYIpYEe8nmCcSEvJlxPI+285y0IvwMZ74N1BMtV05krHHxH5TIQrmgYqcim6MJqEuMv9RapmHgt+rb1UH6rpcogORUkEdbL8toMwfJGpP6nnyaByw++DytkiUZedSXhn349nlAsTrxCbZYCFsvdhClthb92hcgBM6iu80mHOYAnom4ioH+aYT7
 HWkuNWJO
 KIAWPh5ikWMkl/8Qgxtm1PK6aI3tcCrE272P6o4QeWJef+yqqa3jTYy1jwGEOkwa/7gIGVoBZukCey84WqbuSqPB+435wWCAR+UjxEqafNJP8KfNuH9D/b+flFvBu9X1YmNrP4kcrIHESfz+eCqU8QegaxGbgyDrtsjIkffjIcGYkwmheKTgC3ou/nmMMe/SciyiQvVczs8JLpVhnm6VaSvn7bLBnOjlSDbYFXQJP2GkUGUcMacT7jBWM3AcVylzQ13RuiEDOJ/9mvs05FXdEDoDaaALAXQZFUzd1y/r3wLhdhbjZAZ8DE0acvDo/X1UnqWuUKdwW3taNQkCV+Zjblg4FV3NA6D6mpaN6/jekLCG9lpn3Xs6BsCUio17mKLcVz/cbB0BysOCBLghQ2rAcI72lGtG8Luqd0biyR75BIORBxgZnUszbfvXq7Ah+PZX3J5hGtnhlW451+oajnkdn5NJ1Zfq5ZAUIwvkSGDjYorrttTVOihx+KUmYffwr94YMT9lXBktX4w6puFBLIME1KSw6bOi3k4uTjnqMFoq+D7Qw1NUSECI5zrxMMAN3+z5jbeZa4pvqSXhsQPRNZaskJlquC+BUE6zfZwdWRnYresB0aQXH35DPFv/qBXn4yfaOg32oIqFyBFMBLuQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When the OOM killer terminates a task in __oom_kill_process(), the
kernel log records only victim->comm alongside its PID and memory
counters. Because comm[] is truncated to TASK_COMM_LEN and typically
reflects the interpreter binary rather than the executed programme or
script (e.g. "python3" instead of /usr/bin/python3 -sP
/usr/bin/firewalld --nofork --nopid), identifying which service or
worker instance was killed during post-mortem analysis is often
difficult once the process has exited and /proc/[pid]/cmdline is gone.

The standard get_cmdline() helper cannot be called from
__oom_kill_process(). OOM kill paths run whilst holding oom_lock, so
blocking on mmap_read_lock_killable() risks deadlocking against a
thread holding mmap_write_lock() whilst waiting for memory allocation
on oom_lock. Furthermore, get_cmdline() walks user pages via
access_process_vm(), which triggers page faults, memory allocations,
and swap-in I/O during an active OOM condition, and drops an mm_users
reference via mmput() that could run synchronous exit_mmap() teardown
under oom_lock.

Introduce an opt-in vm.oom_dump_cmdline sysctl (documented in
Documentation/admin-guide/sysctl/vm.rst), disabled by default to
preserve existing behaviour and avoid exposing potentially sensitive
command-line arguments unless explicitly requested by the
administrator. When enabled on CONFIG_MMU builds, __oom_kill_process()
attempts a best-effort, non-blocking read of the victim's resident
argument vector (including setproctitle(3) updates inspected via
arg_end - 1) after releasing task_lock(victim). It snapshots the
argument and environment bounds under mm->arg_lock, acquires mmap_lock
via mmap_read_trylock(), bails out if MMF_OOM_SKIP or MMF_UNSTABLE is
set, and walks only present, non-PageHWPoison() anonymous page table
entries via folio_walk_start() without faulting or allocating memory.
After dropping the page table lock, each pinned subpage is flushed via
flush_anon_page() and copied across kmap_local_page() and
copy_from_user_page(), and mmap_lock is released prior to calling
printk.

To preserve backwards compatibility with monitoring tools that parse
the existing "Killed process %d (%s) ..." message, leave that line
untouched and emit a separate rate-limited companion line sanitised
with %*pE when resident argument bytes are recovered. For example:

    [  124.819203] Out of memory: Killed process 1482 (python3) total-vm:184320kB, anon-rss:42100kB, ...
    [  124.819215] Out of memory: Process 1482 (python3) cmdline: /usr/bin/python3 -sP /usr/bin/firewalld --nofork --nopid

Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
---
 Documentation/admin-guide/sysctl/vm.rst |  30 ++++
 mm/oom_kill.c                           | 206 ++++++++++++++++++++++++
 2 files changed, 236 insertions(+)

diff --git a/Documentation/admin-guide/sysctl/vm.rst b/Documentation/admin-guide/sysctl/vm.rst
index 3cb0138e850c..55f76ff25955 100644
--- a/Documentation/admin-guide/sysctl/vm.rst
+++ b/Documentation/admin-guide/sysctl/vm.rst
@@ -56,6 +56,7 @@ Currently, these files are in /proc/sys/vm:
 - nr_overcommit_hugepages
 - nr_trim_pages         (only if CONFIG_MMU=n)
 - numa_zonelist_order
+- oom_dump_cmdline
 - oom_dump_tasks
 - oom_kill_allocating_task
 - overcommit_kbytes
@@ -784,6 +785,35 @@ Default order is recommended unless this is causing problems for your
 system/application.
 
 
+oom_dump_cmdline
+================
+
+Enables best-effort logging of an OOM victim's command-line arguments
+as a separate rate-limited companion message alongside the existing
+"Killed process" kernel log line when the OOM killer terminates a task
+(available only when ``CONFIG_MMU`` is enabled).  This helps identify
+which script or worker instance was killed when ``comm`` only records
+an interpreter binary name (for example, ``python3``) and
+``/proc/[pid]/cmdline`` disappears once the task exits.
+
+Because the OOM killer runs under ``oom_lock`` and cannot safely sleep
+on ``mmap_lock`` or trigger page faults, only a bounded prefix of
+anonymous pages already resident in memory is inspected, with
+non-printable characters escaped.  If ``mmap_lock`` is contended or the
+argument pages have already been reclaimed to swap, the companion line
+is omitted or marked ``(truncated)``.
+
+Command-line arguments may contain sensitive information that would
+otherwise be restricted via ``/proc`` mount options such as
+``hidepid``, whereas the kernel log buffer may be readable by
+unprivileged users when ``kernel.dmesg_restrict`` is disabled.
+
+= ===================================================================
+0 Suppress OOM victim command-line logging (default).
+1 Enable best-effort OOM victim command-line logging.
+= ===================================================================
+
+
 oom_dump_tasks
 ==============
 
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 5d48bd862c27..46d22c7b3f37 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -45,6 +45,11 @@
 #include <linux/mmu_notifier.h>
 #include <linux/cred.h>
 #include <linux/nmi.h>
+#include <linux/cacheflush.h>
+#include <linux/highmem.h>
+#include <linux/overflow.h>
+#include <linux/pagewalk.h>
+#include <linux/uaccess.h>
 
 #include <asm/tlb.h>
 #include "internal.h"
@@ -688,6 +693,191 @@ static void queue_oom_reaper(struct task_struct *tsk)
 	add_timer(&tsk->oom_reaper_timer);
 }
 
+#define OOM_CMDLINE_LEN 256
+
+static int sysctl_oom_dump_cmdline;
+
+/**
+ * oom_copy_mm_resident() - copy resident anonymous user memory without faulting
+ * @mm: target address space to copy from
+ * @addr: starting user virtual address
+ * @buf: destination kernel buffer
+ * @len: maximum number of bytes to copy
+ *
+ * Walks present, non-PageHWPoison() page table entries in anonymous VMAs of
+ * @mm and copies up to @len contiguous resident bytes into @buf without
+ * triggering page faults, memory allocations, or sleeping locks.
+ *
+ * Context: Process context. Caller must hold @mm->mmap_lock for read.
+ * Return: Number of bytes copied (may be less than @len if an unmapped,
+ * non-anonymous, non-resident, or poisoned page is encountered).
+ */
+static size_t oom_copy_mm_resident(struct mm_struct *mm, unsigned long addr,
+				   char *buf, size_t len)
+{
+	size_t copied = 0;
+
+	addr = untagged_addr_remote(mm, addr);
+
+	while (len > 0) {
+		struct vm_area_struct *vma;
+		struct folio_walk fw;
+		struct folio *folio;
+		struct page *page;
+		size_t offset, bytes;
+		void *maddr;
+
+		vma = vma_lookup(mm, addr);
+		if (!vma || !vma_is_anonymous(vma))
+			break;
+
+		folio = folio_walk_start(&fw, vma, addr, 0);
+		if (!folio)
+			break;
+
+		page = fw.page;
+		if (unlikely(PageHWPoison(page))) {
+			folio_walk_end(&fw, vma);
+			break;
+		}
+		folio_get(folio);
+		folio_walk_end(&fw, vma);
+
+		flush_anon_page(vma, page, addr);
+		offset = offset_in_page(addr);
+		bytes = min_t(size_t, len, PAGE_SIZE - offset);
+		maddr = kmap_local_page(page);
+		copy_from_user_page(vma, page, addr, buf + copied,
+				    maddr + offset, bytes);
+		kunmap_local(maddr);
+		folio_put(folio);
+
+		copied += bytes;
+		len -= bytes;
+		if (len && check_add_overflow(addr, bytes, &addr))
+			break;
+	}
+
+	return copied;
+}
+
+static noinline_for_stack void __oom_dump_cmdline(struct task_struct *victim,
+						  struct mm_struct *mm,
+						  const char *message)
+{
+	static DEFINE_RATELIMIT_STATE(oom_cmdline_rs,
+				      DEFAULT_RATELIMIT_INTERVAL,
+				      DEFAULT_RATELIMIT_BURST);
+	unsigned long arg_start, arg_end, env_start, env_end, arg_len;
+	size_t to_copy, copied;
+	bool truncated = false;
+	bool proctitle;
+	char buf[OOM_CMDLINE_LEN];
+
+	spin_lock(&mm->arg_lock);
+	arg_start = mm->arg_start;
+	arg_end = mm->arg_end;
+	env_start = mm->env_start;
+	env_end = mm->env_end;
+	spin_unlock(&mm->arg_lock);
+
+	if (!env_end || arg_start >= arg_end)
+		return;
+
+	arg_len = arg_end - arg_start;
+	to_copy = min_t(unsigned long, arg_len, sizeof(buf));
+
+	if (!mmap_read_trylock(mm))
+		return;
+
+	if (mm_flags_test(MMF_OOM_SKIP, mm) ||
+	    mm_flags_test(MMF_UNSTABLE, mm)) {
+		mmap_read_unlock(mm);
+		return;
+	}
+
+	copied = oom_copy_mm_resident(mm, arg_start, buf, to_copy);
+	if (!copied) {
+		mmap_read_unlock(mm);
+		return;
+	}
+
+	if (copied == arg_len) {
+		proctitle = buf[copied - 1] != '\0';
+	} else {
+		char c;
+
+		proctitle = oom_copy_mm_resident(mm, arg_end - 1, &c, 1) == 1 &&
+			    c != '\0';
+	}
+
+	if (proctitle) {
+		/*
+		 * The NUL terminator at arg_end - 1 was overwritten, which
+		 * indicates setproctitle(3); treat the buffer as a single
+		 * NUL-terminated string that may spill into [env_start, env_end).
+		 */
+		unsigned long max_len = arg_len;
+		size_t n;
+
+		if (env_start == arg_end && env_end > env_start)
+			max_len = env_end - arg_start;
+
+		n = strnlen(buf, copied);
+		if (n == copied && copied == arg_len &&
+		    max_len > arg_len && copied < sizeof(buf)) {
+			size_t rem = min_t(unsigned long, max_len - arg_len,
+					   sizeof(buf) - copied);
+
+			copied += oom_copy_mm_resident(mm, env_start,
+						       buf + copied, rem);
+			n = strnlen(buf, copied);
+		}
+		truncated = (n == copied && copied < max_len);
+		copied = n;
+	} else {
+		size_t i;
+
+		truncated = copied < arg_len;
+		while (copied > 0 && buf[copied - 1] == '\0')
+			copied--;
+		for (i = 0; i < copied; i++) {
+			if (buf[i] == '\0')
+				buf[i] = ' ';
+		}
+	}
+	mmap_read_unlock(mm);
+
+	if (!copied || !__ratelimit(&oom_cmdline_rs))
+		return;
+
+	pr_err("%s: Process %d (%s) cmdline%s: %*pE\n",
+	       message, task_pid_nr(victim), victim->comm,
+	       truncated ? " (truncated)" : "", (int)copied, buf);
+}
+
+/**
+ * oom_dump_cmdline() - best-effort log of an OOM victim's command line
+ * @victim: OOM victim task
+ * @mm: victim's address space
+ * @message: OOM context prefix string
+ *
+ * When enabled via vm.oom_dump_cmdline, emits a separate rate-limited
+ * companion kernel log line containing @victim's resident command-line
+ * arguments (with non-printable bytes escaped). Uses a non-blocking
+ * mmap_read_trylock() and skips logging if @mm is contended or already
+ * being torn down.
+ *
+ * Context: Process context. Must be called after releasing task_lock(@victim)
+ * while holding references on @victim and @mm (mmgrab()).
+ */
+static inline void oom_dump_cmdline(struct task_struct *victim,
+				    struct mm_struct *mm, const char *message)
+{
+	if (unlikely(READ_ONCE(sysctl_oom_dump_cmdline)))
+		__oom_dump_cmdline(victim, mm, message);
+}
+
 #ifdef CONFIG_SYSCTL
 static const struct ctl_table vm_oom_kill_table[] = {
 	{
@@ -713,6 +903,15 @@ static const struct ctl_table vm_oom_kill_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
+	{
+		.procname	= "oom_dump_cmdline",
+		.data		= &sysctl_oom_dump_cmdline,
+		.maxlen		= sizeof(sysctl_oom_dump_cmdline),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
 };
 #endif
 
@@ -729,6 +928,11 @@ subsys_initcall(oom_init)
 static inline void queue_oom_reaper(struct task_struct *tsk)
 {
 }
+
+static inline void oom_dump_cmdline(struct task_struct *victim,
+				    struct mm_struct *mm, const char *message)
+{
+}
 #endif /* CONFIG_MMU */
 
 /**
@@ -944,6 +1148,8 @@ static void __oom_kill_process(struct task_struct *victim, const char *message)
 		mm_pgtables_bytes(mm) >> 10, victim->signal->oom_score_adj);
 	task_unlock(victim);
 
+	oom_dump_cmdline(victim, mm, message);
+
 	/*
 	 * Kill all user processes sharing victim->mm in other thread groups, if
 	 * any.  They don't get access to memory reserves, though, to avoid
-- 
2.55.0


