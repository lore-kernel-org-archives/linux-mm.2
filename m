Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABA0EFD375D
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 13:33:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A0806B0095; Wed, 25 Feb 2026 08:33:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14AC06B0096; Wed, 25 Feb 2026 08:33:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02C7B6B0098; Wed, 25 Feb 2026 08:33:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E41F46B0095
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:33:15 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 81A60BA1AD
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 13:33:15 +0000 (UTC)
X-FDA: 84483070350.17.DDB3EC4
Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11020104.outbound.protection.outlook.com [52.101.69.104])
	by imf10.hostedemail.com (Postfix) with ESMTP id A44A5C0012
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 13:33:12 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b=Q2LRux1N;
	spf=pass (imf10.hostedemail.com: domain of ptikhomirov@virtuozzo.com designates 52.101.69.104 as permitted sender) smtp.mailfrom=ptikhomirov@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772026392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7nTz8Q8VQf+mb3M5st1ZZIpFUQjbjbQeKbWx4c8w5CI=;
	b=oa2lvDMLKMA8GJLCxZnIesvDEueeZ1nNlTmlkbJB8RqSAK4tvrZFwx8Im5sG2G9O95fyX1
	aLUTqL3L8qZ3L1da55ktB8QZ7ojh04EHLcg8Llda7g2tzuZpH1XXVm7tmrVluNjAhTd10k
	hKdtPA7X3tPeyyFkHSpp2z6pLn4ZOJU=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b=Q2LRux1N;
	spf=pass (imf10.hostedemail.com: domain of ptikhomirov@virtuozzo.com designates 52.101.69.104 as permitted sender) smtp.mailfrom=ptikhomirov@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772026392; a=rsa-sha256;
	cv=pass;
	b=yYuk74SyDaKrScv8MNI6xZClzS4EJR6auYkmEx6K6anU1E3ufEyxLamNofSfGRSU+DZJBm
	fRCBqnnhs/lkPGZHUD/OzYvQn/Ikr2IgOXQtE/3F16k6tOti2hk/3NEa5odxrLAcNugUzV
	969uo9vINVshXSYEmajYfI0qk0Av/M4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HxUHXRcNgu5r6ZId/hKTVmloiDzVS5AcCQJEW9Rxypmcg59dhwiTLwpYGeLWCcaYJmPi+kCbg7N3opiy4tPoDQGTW611JYoO3LNmXfQ9Do4pYp0T51atLGDFS7FoN/i2o30bfnxMXOj94MSfO+/sk7I4dvEbhMdDs0CMoytrNqZ0xYWRIXe+ug/NnX5E/Rpj7QQH8iISTOm7eqznzKgiww82iRzrhNKrPYjQ7QvY6/obYkJN2Iop3Fw2Qy3fce54HPFbkeTXIUal/ID+2IAGp4y4QkR4JZP0UP7t+O7P7jFa/337Luf9rCqTeNcyc2YHcxJ8SUVHfrZ3u6/SI3A8Ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7nTz8Q8VQf+mb3M5st1ZZIpFUQjbjbQeKbWx4c8w5CI=;
 b=ypd/3D5/Gl1jkWjh1w4coVrPXoCu5ECyMLgUPeX8AZjS5+2HoCtzHSqZAHmOptxCsFHlKKD33NvEiYezqJPs2QJGwmvK16xHUoglAo1lcif3ymIvKbVreig9C6O7dYhof2DlJiRmW6l6GEupRNH3iHn1JxSi9vTSYaOXHclsE7KR/wqHlOwtfHUmYTN/G+RkUrlCqibHlAeh3teXQ2QuBebFPW/SkSEHzTotWO0U0rHO/2lB9j8H77kVUDvL9xZwcO3mn2zDp+1rdHidI0Siat5x93qZCFshwj30/vV+JgB1j54V+8cz9fpKhsE7IAzF4bqj0FvjU2hkYfUuJgBEGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7nTz8Q8VQf+mb3M5st1ZZIpFUQjbjbQeKbWx4c8w5CI=;
 b=Q2LRux1NC16oparJR/Byw5DDS0cFuCfEDMM9cxyzom4J6m60tz2Pz2frVi1chlqwUCkAlkX3S7+nyay4MmHy8mrAaRHxfQgYqZfoc23JRJnOYjhKNr7pXq7v/cpJHXdu+oBgCcRx5hktpilwF2URMjjgT9RINXgjKUWjGBiEx2SzjQv+gKHGmqDkNli9KFLovogmiET/OB4bp/nZ3zeMhOyQzsvkGWPn9Qb7OFhc1LtGlnL5dkovqdhETtWiHw2F8U+UuZoUpS+sCW/6IAB0LsfOCaWyEsm9MosvCaxnDxFRIOn8Sr58NQ2uYYwVXtQAd614zHB5pJgm3Y+omw9FUA==
Received: from DU0PR08MB9003.eurprd08.prod.outlook.com (2603:10a6:10:471::13)
 by GVXPR08MB11715.eurprd08.prod.outlook.com (2603:10a6:150:317::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.23; Wed, 25 Feb
 2026 13:32:55 +0000
Received: from DU0PR08MB9003.eurprd08.prod.outlook.com
 ([fe80::3470:51d7:36e4:36d2]) by DU0PR08MB9003.eurprd08.prod.outlook.com
 ([fe80::3470:51d7:36e4:36d2%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 13:32:55 +0000
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
Subject: [PATCH v4 2/4] pid: check init is created first after idr alloc
Date: Wed, 25 Feb 2026 14:32:24 +0100
Message-ID: <20260225133229.550302-3-ptikhomirov@virtuozzo.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225133229.550302-1-ptikhomirov@virtuozzo.com>
References: <20260225133229.550302-1-ptikhomirov@virtuozzo.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0277.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:84::18) To DU0PR08MB9003.eurprd08.prod.outlook.com
 (2603:10a6:10:471::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DU0PR08MB9003:EE_|GVXPR08MB11715:EE_
X-MS-Office365-Filtering-Correlation-Id: 18c6300b-8866-4ab0-6f5d-08de7472620c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|52116014|7416014|376014|10070799003|1800799024;
X-Microsoft-Antispam-Message-Info:
	fp2I2omKJ5dNplKB5zA4hDtG9mgexg6w8H5/fURLXnJGQ8rd0guM7hWY/Akc8LzcDz1+cw0kafJ5m/p2HMLkix2/dI3pMxufk20iusm99tcZYWY0rdZEND/fVwW+PTkzv20E+WEZ3USdzEkL7Zd3WnS02F7eLvRThpYTKnSNtI//D3mEnIlXfDCoAOvkkCaYfACUQ/S74IWVbQGIcIXstrwC6fjmx3CVRQu1GPOk8fN+RTH+TOgqoQkTNBzJFNwFsHHB702IbQSWXeaXp/4czxtfFB8Y0MGcddLuSykv73TPVUseiHNlsU93YUv0rj3Ia+L3UdNrcSoiq4dozQOSjJvc9zmtOKO5IgW8UUrHBFTyraNeSRB1ODsTCglyA08dAhRk7REzjxXZ5/NTUgAUKqWB5D5azDeox9N5HuK1TxYQ2ql1bK7Lu8eIAcLst6pD4U774QIbrMoZaMVq+AvlflCtqgefXH7/Pe5qtJJrKi3tGZz1vrkiR/r3J2S/tqt+n5IT/uFXjROZFINrmt1psP0q+BSWAMFLk8xR2KV6cRQrG4rKIHi9porkcVW4Z1Tr5A8W6FLtE/pkgRo9+TMjhb+yg+VsiB70G7Wm471XyzjKKqHstNYRULSAC+4613vC1WmtoXkSAtg1dKHP7f93IyivQEO0uJEJqbie2TtJh5WIj09BWfFMfRqLDxLmzdM4NFzhjqvY/gY80ireBcqY28hilDGMcLUhoiS5PUlD4t0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9003.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(52116014)(7416014)(376014)(10070799003)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yYt94g3T1gGuXmjx5T8IyqokBx5yhIXj64sT4em2nbyg8axUu5zjm0EbmMqV?=
 =?us-ascii?Q?IcpeVz24OnR0E29uXWvqCAp+3r6maYoQY97aaAbm8aVrcu2WIC/eWa3mbHqD?=
 =?us-ascii?Q?Zubu3AECKfKOWUgPHgYdsNe2Dfl3nNbLqsp6fyDaZ4JXpPIrJweG/X/upNf5?=
 =?us-ascii?Q?0jO9PugBRfm2q/DBDH+Cb2AY6NZhTUchGp88tgOS62DTRwON6qr0MPstuDDM?=
 =?us-ascii?Q?/+6aw6VgxwP9HGbcpWnKYXH0iWCeMH9NpgFHYmqhQfxJb6Rp6OIlBsoyBSoh?=
 =?us-ascii?Q?8gAq+GsydLWJvcHcJHcMh7ZuKkiEErMzzRwtXbRpZEBYqGm5z8IT3kc/c7LY?=
 =?us-ascii?Q?H+MnSXxLu4/SghOVjNwahH9ve5uzxRa7916mALyKy5J252DCUvclPPFexGmE?=
 =?us-ascii?Q?Xn9NoUS7U8xGqKYMYYF0TVkbgfjGA9pr5qdXminlgsYoL0H+dxHGCBs36t7F?=
 =?us-ascii?Q?ougjm7LIHH+prGW9u4mywIH3IC912yU2ZCiwsRHGItsfcixvQKdA95h220V5?=
 =?us-ascii?Q?luW4oD+fHLAsfo7XGOn8e6fADr58ISRWqnsO7rWepOLIVqCUIDUbLFQMEcK8?=
 =?us-ascii?Q?YOa64aA6+e6xztNRqzfZyNncssXHfXAnKIDWV4+BFraICqfkmCMeOA4AdwAb?=
 =?us-ascii?Q?kt36+JtZyBqReb3dXBYFx8cvzVT8pKFmUu3UEGKm8KqLGlxCsNuhMRqGHQDQ?=
 =?us-ascii?Q?cKuKvAtKG41u3ZehmJ611F/heEj8bLUg7jGmg5ZrbUjrNDHyv5M4L7IpcC5w?=
 =?us-ascii?Q?ykMgsqjdBG5H+65+up2x7AK3j5Or0QLn7fSeNLGTzebPyrkuXD4o4+yeBjjK?=
 =?us-ascii?Q?PqdMrAw2/ATqj/+Eni0YfnXYkBdI1rutqA5WPGC/Z1cFM6bgE/K1jtCJHILs?=
 =?us-ascii?Q?IqjeJY28z37SGTdWYHJrBQhHJ4EAS/y1Wit4XX7fng6xEo9fWyq/YYu7aApS?=
 =?us-ascii?Q?5qkIwuI5B3jH/XdjD1dxqgpvJj5C824qs6oFBjMqRmx+6FUwaRZoYAdi3xKf?=
 =?us-ascii?Q?MaT51cW/sJeJs2GacgOvxwISmjlYCHsK3WK+AO6IMHfkognKWukyfcCMQ7si?=
 =?us-ascii?Q?U4rs0oL2OxZT/g+BwHljLFT5c7jvkTdVzU68FNpLTdhdtJ3pAqcf+qX1BYa7?=
 =?us-ascii?Q?KEprGKBAcllOb1739Gs7SnhGuyR/sw3ThZWPlhZt2QGOhi397Q10wkJD5/TH?=
 =?us-ascii?Q?VP87a4C2T2vlgDy0/alpl8U4cLmpNg0qUEfT2hywCbrfmlvmlX9pxLytkvUl?=
 =?us-ascii?Q?xBfKwna/FTxd/+NiApjUYw+BAvRjBNkfjCjtcw/zmHQzvYiYdDhuQ48ORHH/?=
 =?us-ascii?Q?eP/A1esdjVeqRBnJcKaJNU77NidCPcUmIxHlblKGbBxtferpR2rGNTmjAi29?=
 =?us-ascii?Q?aitUTWt6nrqe9hYaQgXIWDnNOgJFkomqJXGYWvNq9CqC5xjGmeGrhXa0J4/+?=
 =?us-ascii?Q?FKtsRk4dRxG6c99quQB3zWJ5wRAVq95jsQk+LJ0KKnJdxARWaWC651IipCRM?=
 =?us-ascii?Q?qHs14hvCvfjyu/bogMXTC34jcwOLVXaU2F3KM828L0INjgms4OXx1XjFGTNY?=
 =?us-ascii?Q?QEZsW0WlVIiXkMtDGkzazwILsBDWaSASWfFe7UPXcfuwLAeLhv1Lxakhs1GV?=
 =?us-ascii?Q?MWNQfklj7LkDcMhxV8648Ctumcf7XMErSzx5e57u2OYgJ3MMbkQxWxFwXNQX?=
 =?us-ascii?Q?RPMRimAzXE0OzLKpQYRbE9nuUheKbkC84fA7nIFVkJqf4cff4FUy7XziNjwv?=
 =?us-ascii?Q?25bG7kol7zlNLWrkatWAIjKX8hCIObvDM2uPwTva2q6vCg2+rzASgCcSKQy0?=
X-MS-Exchange-AntiSpam-MessageData-1: KtAX3RqXf2ppHNkw62o18ZT9cPGW9z3asDU=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18c6300b-8866-4ab0-6f5d-08de7472620c
X-MS-Exchange-CrossTenant-AuthSource: DU0PR08MB9003.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 13:32:55.4440
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: se9VOrX0LkC4PNtWCSyn+VufMPhYN0SQ4EQ4r3hWnUGZiQlXBsdCN5YmSK1KKoqedJPHGtOD93dmg8xnbGWkvisL+p2dAZPAUSjapwmlBBQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB11715
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: A44A5C0012
X-Stat-Signature: 1p6ft3ufjkj5yf1jgb55sfrd6hnj3sgi
X-HE-Tag: 1772026392-412499
X-HE-Meta: U2FsdGVkX18HL3O5/iYMmfAkTaRxwf+K5LEq/XwTl8IkObKhE/yQW8npS0EPdTp10k1xqQAfCggFCCGQQkx3oW028Mhai0MyFkf9xRj+8ax6PTJk/E5k/+wHmHCOhWfUwd7kF0/rL7CujZ5GnhchxkVRTw5M9JtShoyiWUGTk6Kp5OruMyqK+wgM3eBPzEuRe2smmyGrhkYAs2qgwrJOqKEujTc0bl1IQzF+FYWIbyukhAY+BETddTyisCEGSbBB/MUIZJ89/3kvAXaZBmTR6COBeLXMHMTBJ204RLik0j/yMdI0JjcDYqNQvRdgzNA7QmI5S0D135LuBW3OKzOwNQAcpZfc+1leD9XDaOkAyehFHZoOaOVn0iclI9aESLAmtE9dj4xCbYnazFVccJIgJ/vm8R/1d4rmKHBuXJyC/ud6YnU8Gd98DvnWHmMWeiCSdThd8WK5MTR4xpgQMx7T3cZo0jTq1QrbZpfGsw3w+5Sa5eIepm+BH3Kc71goZCS+iZhVqomqjyFBVbbxjjZIKGO/tqtcoyl4Bu35glv3Mh18lTRC91auKb3uS7tNXGbYHwgqgzLjaCPOgmFC2jtigvJO1wcS486u+1gEaRXJjTo4OO9N8fPrqtX08nzmOmcEVS+GZdy+Wbwt2AUXhOIHG7HPaiahmHrn1dw9cz55QFJAUxZWZxFN1Oe4OSjhpLk4nji5G7rCc8ysDWc2+NT3k1lYyuzLKcGPUQFGHA40b6JwxxUzOlv2aooLQwRWnJSkpPBmEnSexergTEYW8eqYOKCRh+C9/HYF9RdGzj7AhbtnPQYYVYL9OUa3d2mLdc7aHPh0MoNuYGPhH8TDbBH77WbnXlZtZdyAiiWqTgS53/Gnzewb2WWGseT0k+t2EP7wZWI351AlzxG2FH6XVXldbDtmv9ZaiHTxMmhpCG7PBZnX8s0EsOWH0kS3Dqhbnj6oj/VpG14DK3pDHVUjufK
 qkfrlLb8
 wwTfe5s5tSOMG2TLlrrVSo7//j37b5KMFYHKe//1kwAi4zXWS4DTgdSivWK870Xk49+Ew0mgemqTJegP96F+wTemsfME/i5BC2w9qpOBqEPkIv1tz1gXa3FdYPbvcK0CtbDujbzCZHVWoYqHs41bdbWsGNu2iC8TsiM/IDKttAGPM0mKqnQsbFxfdfr0CuBguyPC8qvw1hNL/RHSbg9IkSoMdks+wm/vbN6nBeFfOEByH2Xi9D0iPncglaDlSGh8DgdiBB8crepCg8uNEDI7Qe9Sjb5Fo/g3vU1cjHB0ydQ8U8m2TI0zIPvttfKWfWXYVDPtvwGPlErsclYmcvZALjtgMupkbZgW3+yOg2YaTk3pg79D/CBaxreiQO840HxGfCfkdq7eOK+K06iIWPVVhirYcPCBfc2wGn4PjsL+w1hUURBa8b2l7DlnrUxxtg6ZzJd4qdQqt088meo8I4Dja/BLdbg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This moves the condition (tid != 1 && !tmp->child_reaper) to after idr
alloc, so it not only covers that first process in pid namespace has pid
1 in case of clone3(set_tid) requesting wrong pid, but also if idr
itself gives wrong pid for some reason.

This could've been the case before this patch, when creating first
process the alloc_pid()->pidfs_add_pid() code path fails, so that the
idr->idr_next is non zero anymore and next process calling to
alloc_pid(), will get 2 as a pid from idr_alloc_cyclic(). Though thanks
to PIDNS_ADDING logic, free_pid() disables further pid allocation in
this case and it does not lead to any real problem.

Note: This is also a preparation for the next patch in the series, which
will introduce an ability of creating init from the task different to
the task which had created the pid namespace. Needed to make sure that
init is always first, even in this new case.

Suggested-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
--
v3: Split from main commit. Merge two checks of ->child_reaper into one.
v4: Update commit message about PIDNS_ADDING.
---
 kernel/pid.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/kernel/pid.c b/kernel/pid.c
index 76c2744493e2..ebf013f35cb3 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -215,12 +215,6 @@ struct pid *alloc_pid(struct pid_namespace *ns, pid_t *arg_set_tid,
 			retval = -EINVAL;
 			if (tid < 1 || tid >= pid_max[ns->level - i])
 				goto out_abort;
-			/*
-			 * Also fail if a PID != 1 is requested and
-			 * no PID 1 exists.
-			 */
-			if (tid != 1 && !READ_ONCE(tmp->child_reaper))
-				goto out_abort;
 			retval = -EPERM;
 			if (!checkpoint_restore_ns_capable(tmp->user_ns))
 				goto out_abort;
@@ -296,9 +290,18 @@ struct pid *alloc_pid(struct pid_namespace *ns, pid_t *arg_set_tid,
 
 		pid->numbers[i].nr = nr;
 		pid->numbers[i].ns = tmp;
-		tmp = tmp->parent;
 		i--;
 		retried_preload = false;
+
+		/*
+		 * PID 1 (init) must be created first.
+		 */
+		if (!READ_ONCE(tmp->child_reaper) && nr != 1) {
+			retval = -EINVAL;
+			goto out_free;
+		}
+
+		tmp = tmp->parent;
 	}
 
 	/*
-- 
2.53.0


