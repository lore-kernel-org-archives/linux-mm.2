Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96171D46951
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 16:57:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB67F6B00DC; Wed, 21 Jan 2026 11:57:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEE036B00DD; Wed, 21 Jan 2026 11:57:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB0786B00DE; Wed, 21 Jan 2026 11:57:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 96A526B00DC
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 11:57:39 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6656B5AF37
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:57:39 +0000 (UTC)
X-FDA: 84356577438.29.EBE684B
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf15.hostedemail.com (Postfix) with ESMTP id D4AB6A000F
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:57:35 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=m+IkXWAW;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="P/LgEAk3";
	spf=pass (imf15.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769014656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B6Z5SxwQfElT4VaOYM9aDStMqZ0God7JWJKVcnEfPJk=;
	b=FVaIlqWix4zQ4OtqSxZUcu4B7h9MSU5EIC5E0Xz8LhcI51Lpt96fDHnpn4mcF5IOeEF7f/
	d/Unvt4ScAad7c8kX/ALoVzcBnpqXZlNUJQUb0FC5PkZEd4g5y1ACr65sTCh/fCi6ERZFy
	ej0fAYqNfCwhWAg6KCX6tsMf4Ss3lk0=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=m+IkXWAW;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="P/LgEAk3";
	spf=pass (imf15.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769014656; a=rsa-sha256;
	cv=pass;
	b=BiiVvFs0ZmPT0xeRVfgdXZO0BOpgWHTdk9w8y1aoTgjQJGq4AOqadb5d6gvTxeHlgQdggA
	tGLAJ/ndzCh5cqiQdYca2qmwP5Ore5i8Y0NPF6Y62gsEKBs5wANqHvWhDbuAutyNU+0xfL
	kkUc3EoA1xcim5t5ExVzh2FbPJk4TD0=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60LF9Jv23031586;
	Wed, 21 Jan 2026 16:57:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=B6Z5SxwQfElT4VaOYM9aDStMqZ0God7JWJKVcnEfPJk=; b=
	m+IkXWAWk3WBbdJqjDiY2qLUmaYNaTzEKYcL5QWXDe2+ag0Td0SskIj4tVsyKWNd
	f09pY+Jh4cnvroZP1VJyP/9PM6O6IzsDXJA949jVpcr83KXlT7ZdqhnoVtmSAjqv
	lkZqXU4suC+YsgkXjQbSniaHZTV3vGvNdIix5wBKGM10GfpPVxMUTC0Pq/23cwCu
	Jb9vP/f722Glp3C6YnfH3nR00AptFx2F6SkvXzYlFhi0fPcivaBpvx03zI/rTTLe
	a3ab/wWgon9mSHa1AjnE9IFr1QvXTNZqZLOEf66pQlChRG6WvDs4kcA5K3hLjHBM
	UcTgEKUesPdJDrvieawc+g==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br2ypx5ay-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 16:57:25 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60LGWLCu019002;
	Wed, 21 Jan 2026 16:57:24 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010016.outbound.protection.outlook.com [52.101.193.16])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bsyrsbwa0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 16:57:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dlrAResh/gYuQCm5zeJYG0WNfWuR+gmVNUw1cX+xAuC7cuqp2/YOC3mJs2wMAzEUt9wx5Uia4A2W5v2Kx/8X+O5a6oy5NFuEJF8zv8aeYvbs4u0d/4Fnq5Ln+kI9SJP4YW7Z6fwnDbrgsqw7hREv+2xXTTBiSFCYyd5Y5T/Ul9W8rXzHHdsNRq3Sw7ZgCxeDBYMgMLw/tN+OA0wxLh0U+10JEFcvK3ikI5nik7Th6JsIky2Jx+txHNfPUsx+68fWRzo0qNVS+zfiaotpmigi6XMd/SmfytsewJGS2dJsc/KSaVzS9c7SmrFFQxwlISAdPFXUR4KScoeggiEy7GifNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B6Z5SxwQfElT4VaOYM9aDStMqZ0God7JWJKVcnEfPJk=;
 b=m5OtZaTir3hBU9vI53T79X3o7mSj44vxtFlbYarnjQrAF4tBGXKewBD0Si/HYaFm2K2+FbyKIZMzk9Faf3pTg4dloFIfQv3+G/5k6h0sp1SJGJ9koUfKt8QLnnQs7zOusnLfFbjf+xhL3ROiLznARC1hnDcpPVEhbjNJ5OjwCCH4epcnQ64CEWDttx095tVp6JhhZXPb0UW3c7+hjdF5xDA6wf/YxdSxk1+am2QML0d+9TKa8xXua49PLqucMaaPDOgo91tXECcBqALFXwHnUn+eEs0X8yB22FHlhaTBedy4sDjesTlGmMDJ5qEi3xhn1UfklWPBgBhk+fn+n75fuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B6Z5SxwQfElT4VaOYM9aDStMqZ0God7JWJKVcnEfPJk=;
 b=P/LgEAk3vaM7p3evxD716tftAqbj09faiFS58W6oUKAz4JVLrgvZB/8EjJcGO2K8RN43hSbG2MwJrfmFKwKMPGAMFrxIwrX2O6zaCalRJ03JFY+18hH8+tIrWel1YTyMlwNuyY0+jcT5m1Pa2Dbf+3uQmPES3AAsfITUHpInen4=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by LV8PR10MB7727.namprd10.prod.outlook.com (2603:10b6:408:1ed::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Wed, 21 Jan
 2026 16:57:20 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9542.008; Wed, 21 Jan 2026
 16:57:20 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Sidhartha Kumar <sidhartha.kumar@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Alice Ryhl <aliceryhl@google.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Arnd Bergmann <arnd@arndb.de>, Christian Kujau <lists@nerdbynature.de>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH v2 17/29] maple_tree: Start using maple copy node for destination
Date: Wed, 21 Jan 2026 11:45:14 -0500
Message-ID: <20260121164526.2093265-18-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260121164526.2093265-1-Liam.Howlett@oracle.com>
References: <20260121164526.2093265-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT2PR01CA0006.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:38::11) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|LV8PR10MB7727:EE_
X-MS-Office365-Filtering-Correlation-Id: 5cc1bb77-3b96-4580-cb59-08de590e242c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?d/2jClB/TIiOIVVHJiGgLkhV28UOFDvhv9+Vf/I00TsunHjRM+sqyqU+jBF6?=
 =?us-ascii?Q?HjF4GcjJTkxqnvweM8DI/3EgHcXpZ6cWk9UFNcOH7g6rGkKauSvQ3bNOsyV/?=
 =?us-ascii?Q?Qdwfv5mafO/991nuXI4XRfMCkQODwpG5fcGuMhAWVI6QNL88sKRmEVGswKEV?=
 =?us-ascii?Q?brxiEt+wbICMSVgtlWC0m0FXq56AZUutIVTdHrZLUzeHpYSK4zwfVnnRr4v8?=
 =?us-ascii?Q?Al9h6ZKDMbREHx9NgySFDtm4tfysI9Xdzaqjp1JUxzWV5maIS9UtRFxIxy/j?=
 =?us-ascii?Q?KbnPit5VSrAyolhxMJ3JSBa9cdUlY169QRTg5TlbpORRC7oF928hmITHMmRX?=
 =?us-ascii?Q?4Pj2WCqOz1u3w0iPPObiMP6slhTuZ70pTpPzzZ73azXLGM4UUOg6YyDWNdRa?=
 =?us-ascii?Q?q+kj7s7V2bJTJJ71pPZ7Fh1CKkafliWv3lbVcjJEv3aLvpUzUo78Owg/WfSM?=
 =?us-ascii?Q?XvWbn+7dePf1d5Onq+HIR53PLzGHOL0zF8pjxp0nvK0J7J5q0LmWGSUfhtqJ?=
 =?us-ascii?Q?T6A0vJ7TH87FG8mYrcZNcHpOguP3Rke5JH4YbMZOAgHw2+9vU7xZtjTtbhFs?=
 =?us-ascii?Q?VKgiaKJS8cc3ZmWsVT7lteM8Uqw8wk3Xq2o2Smrodk/CYroPe6qchyuWIhwp?=
 =?us-ascii?Q?Kbc1cfXGQSXkcg8heX4UvzkoUE9hN411t9DjvqlcnSrE0iLfU+rbWbWHMTHi?=
 =?us-ascii?Q?fAvTmfUhxYQKB+Ajn/9hFSt9WKVocbLhUD6Wa+O8ldiofrwbQTZzK7UNwU/r?=
 =?us-ascii?Q?e4uboyIpg/2EfbX9zF7pjiPtQoA0gr0Z9L6r/lPFQ7Nj481FhFvz4MeorSDz?=
 =?us-ascii?Q?qyOH022T+I/VXKzIQOvO0AKnWLdQ479eBDiCHhMSDFCqMnX3PyZKHjuTRfvm?=
 =?us-ascii?Q?ilDu4JHqJRozB+ddSzJ2R9tzyNPDHPu2Ua/1pq8HSBI4Y8/MjV1ipfd2fUDT?=
 =?us-ascii?Q?Ugeoyna8VdSoOozBKxhZ0qCyD9KWPBcBEmsFHWkZE9aC0hMEHnd/hI1DLmhD?=
 =?us-ascii?Q?s9Il5g5rC2DFlmDI77vg65Ww3RoAWdHJRufhKHjmJKwfZpcPoRFOfs3IcLcJ?=
 =?us-ascii?Q?5m4BJoRWZ0PwdVMYVdYuJUu/jvc6ww1sgxRefCMGOcvdoG59+xluFhQ4ZrMN?=
 =?us-ascii?Q?GrfbAd7bPKel4gyuvfQs7mXzf7xdoPVnHpE/Sqc9cB1rNo5GvkYSmYhkSyXZ?=
 =?us-ascii?Q?RLH+ljwFl55HGxMprUWlXXTXJxAhxJzpRG1pyy6/N40xA/wtu7aXp8Ex1NFr?=
 =?us-ascii?Q?CmNzXzozGbdELOthHI5Zny2ZiCsSp5gAEKBTPRap0Q9PK0cUn9L8zBTGIF/H?=
 =?us-ascii?Q?IWf3K/nv406W5r1PR0au6eVwuGNEElozs1lkTZw+mb8XAKGKCyuwLZqDXk9f?=
 =?us-ascii?Q?Ky5TX0nmNgTgbPZhpEX4gckvM6kzMjM1SM7k9JdNZCVWOwG5Smx4CJwSnT8w?=
 =?us-ascii?Q?v1KSaKVYeoTzbvdRmLJtQL3JEYVW7FhATPaFAd1ZUVMrJcktku6zpAYszBaO?=
 =?us-ascii?Q?FJDnW8y2Th1b65ButtM+gG4wJLMlwn9w7ls4OkNEuOLLGDNojh5N0cnsO2PB?=
 =?us-ascii?Q?V224uESS4kMAANk3eko=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5lx3LH0TgiZ4VLNN+XOzjfxGHewMKj3XrfmNBUgaSE9bh8rjP8RJr+YU3UwY?=
 =?us-ascii?Q?p3xxSnWvosaKqMewl9/cnH/bUxyheJ85+LVBh+LCTGb0/xA/+hJ4CefTd3FH?=
 =?us-ascii?Q?dQQewv0hDWZAiOAZYirLR1IckZpaHXhLDzsCuIBRGSvjabiAYPDqkeNrrlF0?=
 =?us-ascii?Q?eMh6/nLAd/OGR9PDN+YafTTSU6q4kz2/0DI6kauRUdI7oIBQGdmidUfb3MPx?=
 =?us-ascii?Q?jaW+aigcvSfYldZzONVHqJ5Kgcr4RwjrBEJ2ymmeX/p9o4Ho6e1iUJSEuXmG?=
 =?us-ascii?Q?YgKKoFbJKG9Y1yad+tTKg2NnXLmYxcU+j9QUHBs4//mHAHCqzXPRvHaYYNvK?=
 =?us-ascii?Q?UDF/wxbFMxOwbkDNutH9YlVfVtmOhvF6Iz45axueAokOWYJC3iA6zRlvzroo?=
 =?us-ascii?Q?9Sa8t584Ju0D16UsArcnEoDeZp4ukZzDZ4DlWb9Qq+G4njiQ+ficeOux4fdg?=
 =?us-ascii?Q?CmoB5hchlD2Lge7FzU39hTbMAz5SlviEZu4602dlrF33DwWOL9tZ4AHQgf4W?=
 =?us-ascii?Q?FPGKXATnvorUeO5k1I74sz7ynT8waHzI0iOq37LOZgr6aOObBPSBP2POnJGx?=
 =?us-ascii?Q?UQn0eRlFMkLf71Lnp/V03V6hSp7tdq3Ndl+ZyHXbKieC80m+uC0+Pp65B7FT?=
 =?us-ascii?Q?E6sVlgVfGmR3ImyFo1gqwxezvZ7lwu6LIj2qymIhQTmyXLnA5Tbwsuko8WCJ?=
 =?us-ascii?Q?nSmatarkDyQz3I/0aDe04O5/HB2BjsD5Hnk5zdVJLLDpWeYmKb9ZrkzEeC57?=
 =?us-ascii?Q?mGk2FytOAeGA/AimHmE7fH397Kmyl5zaJseKelWjR/D9ENtUVxyINjHpwpLN?=
 =?us-ascii?Q?/a1+Qn7JtB3yur5B782uL/c/Ah+YVs5RnDkb4whclFJzOP18R4kEYZTcKehV?=
 =?us-ascii?Q?+HQYONX/YoPsPjEFDWqh/E/ZjtljVRqhXpnN4eybhzvvCAKqiWI/Znw8OOg3?=
 =?us-ascii?Q?ZSFS4DANqamI8gJpnZHIbIqfMze8SkjquyemEAMi3ld9dG5R3UcYT/hUVKgI?=
 =?us-ascii?Q?kM6N2/Mew+fGkdLbP6K4omq+XqKnAwe04mNFflVhI0K98w2IiuCSTgdzo18F?=
 =?us-ascii?Q?+les8+UzfbM30H6U8soH9jorZzwKfrrCCTqoTM3lvJkUmv5Sm5w1wNEPdTiV?=
 =?us-ascii?Q?9UkULpd1Dfy0oAyMklB0U1Du8x111gZox39zp6gZgIJkkxPPO8N8tkdvPxac?=
 =?us-ascii?Q?lZlwfkJsBxNh2H6WJQYQ//zIB3jz7V3JPdoKyqd0qISpHcj4gP38sQMtTdtV?=
 =?us-ascii?Q?uFdM9fyj+ULpcr8ciUunupvBkB+j1SDjtyNX3kuD0g5FxbX5effriSUmUMq1?=
 =?us-ascii?Q?xHSdi9Fgpv8JXzt7W1SgwWKAKmOrf4cfDSQ5tc/8jITIpEkZGwcshC3WLNis?=
 =?us-ascii?Q?nw24QnEiW/MQdrK6yod0OVziGz7x/pLyY22G27ZphG9gB98MRK+L/cAlD2RG?=
 =?us-ascii?Q?akG381nFY+NaU7IOfjZrHirQOZs6FfhY4wUsVvPEFuLSupTkzNuYI/JgPqjL?=
 =?us-ascii?Q?SYSpNRGRbZNtW0rCpE1xJwiyqKRXDHJYnbLaRXgsU2r8SNCPiLO4kNP0+ypQ?=
 =?us-ascii?Q?qJyREdJSnZqbkHEATc9zt24T4cK/zkV58mBX5Geq6WiNRn0WSPnbOpqyEmXh?=
 =?us-ascii?Q?Wc7yZP5f9/m8JR16XAGYeV1Ufq1GtVUdFcFSoeR5ED2X2tKCbHotY6ONAL0c?=
 =?us-ascii?Q?SdNr0Qu3HqNlLOQkHjoaV39ghm7KvpS7VSv98wYyYLVnVnYQ8wC3dsbFyko+?=
 =?us-ascii?Q?zYj4Lj9rKg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	kwtMRxnOZT1JMqV1vy5VpByy+fMqEEM6631weBfe3VCS5VTXGsvKQPYbgCzxARmKegRXwhpKWfGdbZAXq34chmEwIFJvSu01adRXuuOnGWON3PXUtirBTifbna7Rprq8mqa7RQbthixdsaCVDMvA/lka6imoD8ffXtMNX0sm3hzoZRKDla//umRnDui9toPXL3fHgmnliF395kbU2NLOjSmUk3uMs2jOG6WwWwdiCpHdFz/+nXygmH3qxn5LYYspKnheiqsiGeY4X+JN6JsZ9wszVSIiguDO51gMx5WdB3TbFl4vFBhqFRLQAx+KJryBjwP4r1t7YXjQ/6LdWKcswCRRYpYWs88TWa8vCGgAJ+o3qoUqWd5Zy4rN3rDEYjjQULfJ/tAcFtiPaWzClHsKkq8iRDQP7Shc+YEhkjoV6mtxCmi6CVSo9KJEBAj1schZbHmEu34E19wUT3ws5XCfCb50nZun9pCQ9LAiZlmC6JQOrTxfMarGffTY0Ema1rVuAeHP9y3Q0dPnu1wu7LfAfmeLFNVlFhCPVW9hPmIPRhrr0n0KMsoIx95WRGKEvodaTQosiNGSQeYLNvFVW5HkTb7iMXr9dbrJgdkzWDaciRk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cc1bb77-3b96-4580-cb59-08de590e242c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 16:57:20.6769
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +G/iKeIo1iP2r9gNzVSTGNT/rqeXBPqCmLu7zFQ3wjYJF0qTI2cxV2PjGf2rcjE98u3PJuvcipJsPRF3+y/boA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7727
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-21_02,2026-01-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 malwarescore=0 bulkscore=0 suspectscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2601210142
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIxMDE0MyBTYWx0ZWRfX0mrqECt/eett
 +9ymdc6VxVpvTDP0sXk+UCNiYfuMhXtNqpfdKf7cdMAv/JSw1w0IdTHSFR6qCbOvHYxxbXz4WG8
 HfxIv7jv8RvhhDroPSYwzBlCn02+g/rDGENIvMOu3w5doY78/oAktJzwLXuJbSYRF9vOz3K3p/Y
 KeTwJ40PuoyhOJYBo9DzIaZI1/f3A96n+B36nkCqW4gOqFqt9pRfND8wC0cDB/LChp6eD5VhHVG
 T1e+pLKhWquOhKfmTOAmEteMzTA7nxMjKEkvEKdsGUqvjqcKq3RgSyrLFZsqPfZG6r+ZTXla7eg
 FQ8nsh6wR7IiTxJNaNqDFRKFaDq4lekgRKp+Fhh04gHN9U6+Gf3PFXKNJLPc+FCDLsTed1BGCVl
 pn6jtOyYzhGhFEDR6j+Nn0XqkAkz7NO/zroy3MeIMP1DR0A3MC8UZ6nZuVfhK+gIfMXQcnpzO/8
 ZHtPhAklisyV0hqhdTfosQoZwqoCWhL6QdMMVb3w=
X-Authority-Analysis: v=2.4 cv=de6NHHXe c=1 sm=1 tr=0 ts=69710575 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=ftHlONicu1wf5FYgji4A:9 cc=ntf awl=host:12104
X-Proofpoint-ORIG-GUID: pfH68ws0uOOge2b5uKX6bm9Wkp5St58Y
X-Proofpoint-GUID: pfH68ws0uOOge2b5uKX6bm9Wkp5St58Y
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D4AB6A000F
X-Stat-Signature: w1gdstawbiu4a8i38nfqt4zrw6n7sj31
X-Rspam-User: 
X-HE-Tag: 1769014655-810823
X-HE-Meta: U2FsdGVkX1+qaCNHuRb+jKfVokpB9mvpGbyy8ad6T6EOFDshySGM2K3pTBkI9y3T7t/y1Efjd0GBBt2tfq26IbzmWDoqbrl4R0uv+FiMnkXg7J8k93FxgdEoxQzl8lcHHEM0VSe0b/z/apy/t6Jcb4qZRWsj+nXQ+v0K4xKPifl1DLKcARuCLIMdnApE+dFkUwna4002gsLo2htEMGXpaRnl9Hwqzypjqhsp2C0yhCbsIuqQtm5eqfTAcqx9A6o3q2+fsjvGCKiJEvwK83qalVlugxNahEsxhi3c1uh35iNjMvzJymbheDCVnMQ/V5U9ExvA2f4xTINQ3Q4HiodDawnArpaJ2DHMb3JEkNT8B0zeE7uIf2aJm/pPXjP6iTrdFIDaTsyJ7fgjfILAJAMZOnUlj6j9Kt0OjlwaKblyZfdJHS6XdSztcgixGcWOq+dR/30DAPhK9vex3MZSyiYK0SwNpG7eyjDbyNpbvoYznbkrp1Vb9O+LDAAohX/4k/nGPHako4gyWWQGCJZXVIxAdfMd8nQeAMpjZLuQSzipFvGoa+/PaNegUNSAjvbAm9v4Ssaj0wW2oHfZg/qO4FTsSoirjsNXDcskSlNIIqobX1bYSx+Vf1yrnpAvKifDHCad7KK+eQYeJz+qG70VusmT0pZQLSLgSsza+8F61k0mW7Wyw7hOH850H10Lq8Qwh08W8PGRIa7n4+jdw5rmu885csuNMMU+tr0Jsdxd8QLnWJSM+UFtj38BVCZXKr+K0CoksZr3br+vjr1WOO9SbZU6/LetXPgXV80qI+pf7CvMSxujMPDXvaeujpiv0LhlCOp0uJ94nmsglX/rKX9g0JyzlZ7gowJidGXsksMDKHp7MFdla6Cv73UEZv7wbJ1ByYYajS0xoDLyEr5zlLt8ciknqk4njTKObCTiVc6bDmyMuSabDnvm5VbO3CXye7rI9XL/A1cthNsix+miGkdRToa
 b3IMNdo4
 8UAG3bVgscMZKE+NfbWC1wUjmzWNujRgZJJaf5EguAXkkNO4lD0cnafIV5A/QN7kj3zFcZ+nXNeAWmovSnBIU1A77h3nhQaOqDmeVXi7Q0bL3tg2YSmA0J41seCKcC4uAxNP83z1HtQMkZiFF+w4+Dpib+DNWAMo82urVm299fDPJvYjDHc3HFH59kGQCWyMd/0RWg7g/I9EApdrgXcCR1GtOQpGxUAPH8AyFZe9umiaiSkerYeyqlEuykN5hlJsh5GFaf6M/qdPJEGb8vSY2YmuPsFg5JknDK15AV6ntlIAzLC4d+hQUDr/6Yx/qfut8d3GjWSQ17XZgIP4j6BDw+MvAlfIUBKW4i53vpFlykWxoxrCrPJJcOF8sdXboY7zIaAS6ftgKXu8K3Hy1cHYL/2FMKjbnfnZa2z5K7ShD6IO8n+ILrSnlJ9BcFlabemZQnyYzrr5IXyFyTagnry4Snukl4aUuMX8+OYGsFKYvA36OQpIkAWfavXrTGUCMoIEFO7VMEpTa1IKUFKpbwjLOoJxgvPkEsCU4Y6A6ww+iW+33/OQeG6L14yECWSStMChHTaVdVNlCnOP5it5pV5zh0DB9FdRLH7u9syIDTLBpiHVbLBdjWeYtlLPoS35AcVsEHQkDX9CgMlswLY2OflE0gELYOx1gA1Oc07yl8H7ByIGUKQdl8IAABiDXEQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Stop using the maple subtree state and big node in favour of using three
destinations in the maple copy node.  That is, expand the way leaves
were handled to all levels of the tree and use the maple copy node to
track the new nodes.

Extract out the sibling init into the data calculation since this is
where the insufficient data can be detected.  The remainder of the
sibling code to shift the next iteration is moved to the
spanning_ascend() function, since it is not always needed.

Next introduce the dst_setup() function which will decide how many nodes
are needed to contain the data at this level.  Using the destination
count, populate the copy node's dst array with the new nodes and set
d_count to the correct value.  Note that this can be tricky in the case
of a leaf node with exactly enough room because of the rule against
NULLs at the end of leaves.

Once the destinations are ready, copy the data by altering the
cp_data_write() function to copy from the sources to the destinations
directly.  This eliminates the use of the big node in this code path.
On node completion, node_finalise() will zero out the remaining area and
set the metadata, if necessary.

spanning_ascend() is used to decide if the operation is complete.  It
may create a new root, converge into one destination, or continue
upwards by ascending the left and right write maple states.

One test case setup needed to be tweaked so that the targeted node was
surrounded by full nodes.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 include/linux/maple_tree.h       |  14 +
 lib/maple_tree.c                 | 618 ++++++++++++++++++++++---------
 tools/testing/radix-tree/maple.c |   2 +-
 3 files changed, 452 insertions(+), 182 deletions(-)

diff --git a/include/linux/maple_tree.h b/include/linux/maple_tree.h
index db6a02788902a..0c464eade1d66 100644
--- a/include/linux/maple_tree.h
+++ b/include/linux/maple_tree.h
@@ -156,6 +156,17 @@ enum store_type {
 };
 
 struct maple_copy {
+	/*
+	 * min, max, and pivots are values
+	 * start, end, split are indexes into arrays
+	 * data is a size
+	 */
+
+	struct {
+		struct maple_node *node;
+		unsigned long max;
+		enum maple_type mt;
+	} dst[3];
 	struct {
 		struct maple_node *node;
 		unsigned long max;
@@ -178,7 +189,10 @@ struct maple_copy {
 
 	/*Avoid passing these around */
 	unsigned char s_count;
+	unsigned char d_count;
+	unsigned char split;
 	unsigned char data;
+	unsigned char height;
 };
 
 /**
diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 9c701ee7412ca..f694a38ccd4ba 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -1320,6 +1320,21 @@ void wr_mas_setup(struct ma_wr_state *wr_mas, struct ma_state *mas)
 	wr_mas->r_max = mas_safe_pivot(mas, wr_mas->pivots, mas->offset,
 				       wr_mas->type);
 }
+
+static inline
+void wr_mas_ascend(struct ma_wr_state *wr_mas)
+{
+	struct ma_state *mas = wr_mas->mas;
+
+	mas_ascend(mas);
+	wr_mas_setup(wr_mas, mas);
+	mas->end = ma_data_end(wr_mas->node, wr_mas->type, wr_mas->pivots,
+			       mas->max);
+	/* Careful, this may be wrong.. */
+	wr_mas->end_piv = wr_mas->r_max;
+	wr_mas->offset_end = mas->offset;
+}
+
 static inline unsigned long ma_leaf_max_gap(struct maple_node *mn,
 		enum maple_type mt, unsigned long min, unsigned long max,
 		unsigned long *pivots, void __rcu **slots)
@@ -2507,6 +2522,112 @@ static inline void mas_wmb_replace(struct ma_state *mas,
 	mas_update_gap(mas);
 }
 
+/*
+ * node_copy() - Copy from one node to another.
+ *
+ * @mas: The maple state
+ * @src: The source node
+ * @start: The offset into the src to start copying
+ * @size: The size to copy (non-zero)
+ * @s_max: The source node max
+ * @s_mt: The source maple node type
+ * @dst: The destination
+ * @d_start: The start location in the destination node
+ * @d_mt: The destination maple node type
+ */
+static inline
+unsigned long node_copy(struct ma_state *mas, struct maple_node *src,
+	unsigned char start, unsigned char size, unsigned long s_max,
+	enum maple_type s_mt, struct maple_node *dst, unsigned char d_start,
+	enum maple_type d_mt)
+{
+	unsigned long *s_pivots, *d_pivots;
+	void __rcu **s_slots, **d_slots;
+	unsigned long *s_gaps, *d_gaps;
+	unsigned long d_max;
+
+	d_slots = ma_slots(dst, d_mt) + d_start;
+	d_pivots = ma_pivots(dst, d_mt) + d_start;
+	s_slots = ma_slots(src, s_mt) + start;
+	s_pivots = ma_pivots(src, s_mt) + start;
+	memcpy(d_slots, s_slots, size * sizeof(void __rcu *));
+	if (!ma_is_leaf(d_mt) && s_mt == maple_copy) {
+		struct maple_enode *edst = mt_mk_node(dst, d_mt);
+
+
+		for (int i = 0; i < size; i++)
+			mas_set_parent(mas,
+				       mt_slot_locked(mas->tree, d_slots, i),
+				       edst, d_start + i);
+	}
+
+	d_gaps = ma_gaps(dst, d_mt);
+	if (d_gaps) {
+		s_gaps = ma_gaps(src, s_mt) + start;
+		d_gaps += d_start;
+		memcpy(d_gaps, s_gaps, size * sizeof(unsigned long));
+	}
+
+	if (start + size - 1 < mt_pivots[s_mt])
+		d_max = s_pivots[size - 1];
+	else
+		d_max = s_max;
+
+	if (d_start + size <= mt_pivots[d_mt])
+		d_pivots[size - 1] = d_max;
+
+	size--;
+	if (size)
+		memcpy(d_pivots, s_pivots, size * sizeof(unsigned long));
+
+	return d_max;
+}
+
+/*
+ * node_finalise() - Zero out unused area and populate metadata
+ * @node: The maple node
+ * @mt: The maple node type
+ * @end: The end of the used area
+ */
+static inline
+void node_finalise(struct maple_node *node, enum maple_type mt,
+		   unsigned char end)
+{
+	unsigned char max_end = mt_slots[mt];
+	unsigned char size;
+	unsigned long *gaps;
+	unsigned char gap_slot;
+
+	gaps = ma_gaps(node, mt);
+	if (end < max_end - 1) {
+		size = max_end - end;
+		memset(ma_slots(node, mt) + end, 0, size * sizeof(void *));
+
+		if (gaps)
+			memset(gaps + end, 0, size * sizeof(unsigned long));
+
+		if (--size)
+			memset(ma_pivots(node, mt) + end, 0, size * sizeof(unsigned long));
+	}
+
+	gap_slot = 0;
+	if (gaps && !ma_is_leaf(mt)) {
+		unsigned long max_gap;
+
+		max_gap = 0;
+		for (int i = 0; i <= end; i++)
+			if (gaps[i] > max_gap) {
+				gap_slot = i;
+				max_gap = gaps[i];
+			}
+	}
+
+	if (mt == maple_arange_64)
+		ma_set_meta(node, mt, gap_slot, end - 1);
+	else if (end <= max_end - 1)
+		ma_set_meta(node, mt, gap_slot, end - 1);
+}
+
 /*
  * mast_cp_to_nodes() - Copy data out to nodes.
  * @mast: The maple subtree state
@@ -2684,6 +2805,7 @@ static inline void cp_leaf_init(struct maple_copy *cp,
 	 * result in buggy code when a compiler reorders the instructions.
 	 */
 
+	cp->height = 1;
 	/* Create entries to insert including split entries to left and right */
 	if (l_wr_mas->r_min < mas->index) {
 		end++;
@@ -2726,6 +2848,100 @@ static inline void cp_data_calc(struct maple_copy *cp,
 	cp->data += r_wr_mas->mas->end - r_wr_mas->offset_end;
 }
 
+/*
+ * spanning_data() - Calculate the @cp data and populate @sib if insufficient
+ * @cp: The maple copy node
+ * @l_wr_mas: The left write maple state
+ * @r_wr_mas: The right write maple state
+ * @sib: The maple state of the sibling.
+ *
+ * Note: @cp->data is a size and not indexed by 0. @sib->end may be set to 0 to
+ * indicate it will not be used.
+ */
+static inline void spanning_data(struct maple_copy *cp,
+		struct ma_wr_state *l_wr_mas, struct ma_wr_state *r_wr_mas,
+		struct ma_state *sib)
+{
+	cp_data_calc(cp, l_wr_mas, r_wr_mas);
+	if (((l_wr_mas->mas->min != 0) || (r_wr_mas->mas->max != ULONG_MAX)) &&
+	    (cp->data <= mt_min_slots[l_wr_mas->type])) {
+		spanning_sib(l_wr_mas, r_wr_mas, sib);
+		cp->data += sib->end + 1;
+	} else {
+		sib->end = 0;
+	}
+}
+
+/*
+ * dst_setup() - Set up one or more destinations for the new data.
+ * @cp: The maple copy node
+ * @mas: The maple state
+ * @mt: The source node type
+ */
+static inline
+void dst_setup(struct maple_copy *cp, struct ma_state *mas, enum maple_type mt)
+{
+	/* Data is 1 indexed, every src has +1 added.  */
+
+	if (cp->data <= mt_slots[mt]) {
+		cp->split = cp->data - 1;
+		cp->d_count = 1;
+		goto node_setup;
+	}
+
+	cp->split = (cp->data - 1) / 2;
+	cp->d_count = 2;
+	if (cp->data < mt_slots[mt] * 2)
+		goto node_setup;
+
+	if (cp->data == mt_slots[mt] * 2) {
+		unsigned char off;
+		unsigned char s;
+
+		if (!ma_is_leaf(mt))
+			goto node_setup;
+
+		/*
+		 * Leaf nodes are a bit tricky because we cannot assume the data
+		 * can fit due to the NULL limitation on node ends.
+		 */
+		off = cp->split;
+		for (s = 0; s < cp->s_count; s++) {
+			unsigned char s_off;
+
+			s_off = cp->src[s].end - cp->src[s].start;
+			if (s_off >= off)
+				break;
+
+			s_off++;
+			off -= s_off;
+		}
+
+		off += cp->src[s].start;
+		if (ma_slots(cp->src[s].node, cp->src[s].mt)[off])
+			goto node_setup;
+
+		cp->split++;
+		if (cp->split < mt_slots[mt])
+			goto node_setup;
+
+		cp->split -= 2;
+		if (cp->data - 2 - cp->split < mt_slots[mt])
+			goto node_setup;
+
+	}
+
+	/* No other choice but to 3-way split the data */
+	cp->split = (cp->data + 2) / 3;
+	cp->d_count = 3;
+
+node_setup:
+	for (int i = 0; i < cp->d_count; i++) {
+		cp->dst[i].mt = mt;
+		cp->dst[i].node = ma_mnode_ptr(mas_pop_node(mas));
+	}
+}
+
 static inline void append_mas_cp(struct maple_copy *cp,
 	struct ma_state *mas, unsigned char start, unsigned char end)
 {
@@ -2813,38 +3029,153 @@ void multi_src_setup(struct maple_copy *cp, struct ma_wr_state *l_wr_mas,
 }
 
 static inline
-void cp_data_write(struct maple_copy *cp, struct maple_big_node *b_node)
+void cp_data_write(struct maple_copy *cp, struct ma_state *mas)
 {
-	struct maple_node *src;
-	unsigned char s;
+	struct maple_node *dst, *src;
+	unsigned char s, d;
+	unsigned char dst_offset;
+	unsigned char data_offset;
 	unsigned char src_end, s_offset;
-	unsigned long *b_pivots, *cp_pivots;
-	void __rcu **b_slots, **cp_slots;
-	enum maple_type s_mt;
+	unsigned char split;
+	unsigned long s_max, d_max;
+	unsigned char dst_size;
+	enum maple_type s_mt, d_mt;
+
+	data_offset = 0;
+	s = d = 0;
+	/* Readability help */
+	src = cp->src[s].node;
+	dst = cp->dst[d].node;
+	s_offset = cp->src[s].start;
+	src_end = cp->src[s].end;
+	split = cp->split;
+	s_max = cp->src[s].max;
+	s_mt = cp->src[s].mt;
+	d_mt = cp->dst[d].mt;
+	do {
+		dst_offset = 0;
+		d_max = 0;
+		dst = cp->dst[d].node;
+		d_mt = cp->dst[d].mt;
+		dst_size = split + 1;
 
-	b_node->b_end = 0;
+		while (dst_size) {
+			unsigned char size;
 
-	s = 0;
-	b_pivots = b_node->pivot;
-	b_slots = (void __rcu **)b_node->slot;
-	do {
-		unsigned char size;
-
-		src = cp->src[s].node;
-		s_mt = cp->src[s].mt;
-		s_offset = cp->src[s].start;
-		src_end = cp->src[s].end;
-		size = src_end - s_offset + 1;
-		cp_pivots = ma_pivots(src, s_mt) + s_offset;
-		cp_slots = ma_slots(src, s_mt) + s_offset;
-		memcpy(b_slots, cp_slots, size * sizeof(void __rcu *));
-		if (size > 1)
-			memcpy(b_pivots, cp_pivots, (size - 1) * sizeof(unsigned long));
-		b_pivots[size - 1] = cp->src[s].max;
-		b_pivots += size;
-		b_slots += size;
-		b_node->b_end += size;
-	} while (++s < cp->s_count);
+			if (src_end - s_offset + 1 < dst_size)
+				size = src_end - s_offset + 1;
+			else
+				size = dst_size;
+
+			d_max = node_copy(mas, src, s_offset, size, s_max, s_mt,
+					  dst, dst_offset, d_mt);
+
+			dst_offset += size;
+			s_offset += size;
+			if (s_offset > src_end) {
+				/* This source is exhausted */
+				s++;
+				if (s >= cp->s_count) {
+					cp->dst[d].max = d_max;
+					node_finalise(dst, d_mt, dst_offset);
+					return;
+				}
+				/* Reset local src */
+				src = cp->src[s].node;
+				s_offset = cp->src[s].start;
+				src_end = cp->src[s].end;
+				s_max = cp->src[s].max;
+				s_mt = cp->src[s].mt;
+			}
+
+			dst_size -= size;
+			data_offset += size;
+		}
+
+		split = cp->split;
+		cp->dst[d].max = d_max;
+		/* Handle null entries */
+		if (cp->dst[d].max != ULONG_MAX &&
+		    !ma_slots(dst, d_mt)[dst_offset - 1]) {
+			if (s_offset == cp->src[s].start) {
+				s--;
+				src = cp->src[s].node;
+				src_end = cp->src[s].end;
+				s_max = cp->src[s].max;
+				s_mt = cp->src[s].mt;
+				s_offset = src_end;
+			} else {
+				s_offset--;
+			}
+			/* Set dst max and clear pivot */
+			split++;
+			data_offset--;
+			dst_offset--;
+			cp->dst[d].max = ma_pivots(dst, d_mt)[dst_offset - 1];
+		}
+
+		node_finalise(dst, d_mt, dst_offset);
+		++d; /* Next destination */
+		if (d == cp->d_count - 1)
+			split = cp->data - data_offset;
+
+		if (d >= cp->d_count) {
+			WARN_ON(data_offset < cp->data);
+			return;
+		}
+
+	} while (data_offset <= cp->data);
+}
+
+/*
+ * cp_dst_to_slots() - Migrate the maple copy destination to the maple copy
+ * slots
+ * @cp: The maple copy node
+ * @min: The minimal value represented
+ * @max: The maximum value represented
+ * @mas: The maple state
+ */
+static inline void cp_dst_to_slots(struct maple_copy *cp, unsigned long min,
+		unsigned long max, struct ma_state *mas)
+{
+	unsigned char d;
+	unsigned long slot_min = min;
+
+	for (d = 0; d < cp->d_count; d++) {
+		struct maple_node *mn = cp->dst[d].node;
+		enum maple_type mt = cp->dst[d].mt;
+		unsigned long slot_max = cp->dst[d].max;
+
+		/*
+		 * Warning, see cp_leaf_init() comment and rcu_assign_pointer()
+		 * documentation.  Since these are new nodes, there are no
+		 * read-side operations that can view them until they are
+		 * inserted into the tree after an rcu_assign_pointer() call.
+		 */
+		RCU_INIT_POINTER(cp->slot[d], mt_mk_node(mn, mt));
+		cp->pivot[d] = slot_max;
+		if (mt_is_alloc(mas->tree)) {
+			if (ma_is_leaf(mt)) {
+				cp->gap[d] = ma_leaf_max_gap(mn, mt, slot_min,
+					         slot_max, ma_pivots(mn, mt),
+					         ma_slots(mn, mt));
+			} else {
+				unsigned long *gaps = ma_gaps(mn, mt);
+
+				if (gaps) {
+					unsigned char gap_slot;
+
+					gap_slot = ma_meta_gap(mn);
+					cp->gap[d] = gaps[gap_slot];
+				}
+			}
+		}
+		slot_min = slot_max + 1;
+	}
+
+	cp->end = cp->d_count - 1;
+	cp->min = min;
+	cp->max = max;
 }
 
 static void mas_spanning_rebalance_loop(struct ma_state *mas,
@@ -3000,173 +3331,98 @@ static void mas_spanning_rebalance(struct ma_state *mas,
 	mas_spanning_rebalance_loop(mas, mast, count);
 }
 
-
-static noinline void mas_wr_spanning_rebalance(struct ma_state *mas,
-		struct ma_wr_state *l_wr_mas, struct ma_wr_state *r_wr_mas)
+/*
+ * spanning_ascend() - See if a spanning store operation has to keep walking up
+ * the tree
+ * @cp: The maple_copy node
+ * @l_wr_mas: The left maple write state
+ * @r_wr_mas: The right maple write state
+ * @sib: the maple state of the sibling
+ *
+ * Returns: True if another iteration is necessary.
+ */
+static bool spanning_ascend(struct maple_copy *cp, struct ma_state *mas,
+			    struct ma_wr_state *l_wr_mas, struct ma_wr_state *r_wr_mas,
+			    struct ma_state *sib)
 {
-
-	unsigned char split, mid_split;
-	unsigned char slot = 0;
-	unsigned char new_height = 0; /* used if node is a new root */
-	struct maple_enode *left = NULL, *middle = NULL, *right = NULL;
-	struct maple_enode *old_enode;
-
-	struct maple_subtree_state mast;
-	struct maple_big_node b_node;
-	struct maple_copy cp;
-	unsigned char height;
-	struct ma_state sib;
-	MA_STATE(l_mas, mas->tree, mas->index, mas->index);
-	MA_STATE(r_mas, mas->tree, mas->index, mas->last);
-	MA_STATE(m_mas, mas->tree, mas->index, mas->index);
-	MA_STATE(mast_l_mas, NULL, 0, 0);
-
-
-	memset(&b_node, 0, sizeof(struct maple_big_node));
-	mast_l_mas = *mas;
-	cp.s_count = 0;
-	cp_leaf_init(&cp, mas, l_wr_mas, r_wr_mas);
-	cp_data_calc(&cp, l_wr_mas, r_wr_mas);
-	if (((l_wr_mas->mas->min != 0) || (r_wr_mas->mas->max != ULONG_MAX)) &&
-	    (cp.data <= mt_min_slots[l_wr_mas->type])) {
-		spanning_sib(l_wr_mas, r_wr_mas, &sib);
-		cp.data += sib.end + 1;
-	} else {
-		sib.end = 0;
-	}
-
-	multi_src_setup(&cp, l_wr_mas, r_wr_mas, &sib);
-	b_node.type = l_wr_mas->type;
-	cp_data_write(&cp, &b_node);
-	if (sib.end) {
-		if (sib.max < l_wr_mas->mas->min) {
-			*l_wr_mas->mas = sib;
-			wr_mas_setup(l_wr_mas, &sib);
-			mast_l_mas = sib;
-		} else {
-			*r_wr_mas->mas = sib;
-			wr_mas_setup(r_wr_mas, &sib);
-		}
+	if (sib->end) {
+		if (sib->max < l_wr_mas->mas->min)
+			*l_wr_mas->mas = *sib;
+		else
+			*r_wr_mas->mas = *sib;
 	}
 
-	mast.orig_l = &mast_l_mas;
-	mast.orig_r = r_wr_mas->mas;
-	/* Stop spanning searches by searching for just index. */
-	mast.orig_l->last = mas->index;
-
-	mast.bn = &b_node;
-	/* Combine l_mas and r_mas and split them up evenly again. */
-
-	/*
-	 * The tree needs to be rebalanced and leaves need to be kept at the same level.
-	 * Rebalancing is done by use of the ``struct maple_topiary``.
-	 */
-	mast.l = &l_mas;
-	mast.m = &m_mas;
-	mast.r = &r_mas;
-	l_mas.status = r_mas.status = m_mas.status = ma_none;
-	height = mas_mt_height(mas) + 1;
-
-	/*
-	 * Each level of the tree is examined and balanced, pushing data to the left or
-	 * right, or rebalancing against left or right nodes is employed to avoid
-	 * rippling up the tree to limit the amount of churn.  Once a new sub-section of
-	 * the tree is created, there may be a mix of new and old nodes.  The old nodes
-	 * will have the incorrect parent pointers and currently be in two trees: the
-	 * original tree and the partially new tree.  To remedy the parent pointers in
-	 * the old tree, the new data is swapped into the active tree and a walk down
-	 * the tree is performed and the parent pointers are updated.
-	 * See mas_topiary_replace() for more information.
-	 */
-	while (height--) {
-		mast.bn->b_end--;
-		mast.bn->type = mte_node_type(mast.orig_l->node);
-		split = mas_mab_to_node(mas, mast.bn, &left, &right, &middle,
-					&mid_split);
-		mast_set_split_parents(&mast, left, middle, right, split,
-				       mid_split);
-		mast_cp_to_nodes(&mast, left, middle, right, split, mid_split);
-		new_height++;
-
-		/*
-		 * Copy data from next level in the tree to mast.bn from next
-		 * iteration
-		 */
-		memset(mast.bn, 0, sizeof(struct maple_big_node));
-		mast.bn->type = mte_node_type(left);
+	cp_dst_to_slots(cp, l_wr_mas->mas->min, r_wr_mas->mas->max, mas);
+	if (!cp->min && cp->max == ULONG_MAX) {
+		/* New root */
+		if (cp->d_count != 1) {
+			enum maple_type mt = maple_arange_64;
 
-		/* Root already stored in l->node. */
-		if (mas_is_root_limits(mast.l))
-			goto new_root;
-
-		mast_ascend(&mast);
-		mast_combine_cp_left(&mast);
-		mast.l->offset = mast.bn->b_end;
-		mab_set_b_end(mast.bn, mast.l, left);
-		mab_set_b_end(mast.bn, mast.m, middle);
-		mab_set_b_end(mast.bn, mast.r, right);
+			if (!mt_is_alloc(mas->tree))
+				mt = maple_range_64;
 
-		/* Copy anything necessary out of the right node. */
-		mast_combine_cp_right(&mast);
-		mast.orig_l->last = mast.orig_l->max;
-
-		if (mast_sufficient(&mast)) {
-			if (mast_overflow(&mast))
-				continue;
-
-			if (mast.orig_l->node == mast.orig_r->node) {
-			       /*
-				* The data in b_node should be stored in one
-				* node and in the tree
-				*/
-				slot = mast.l->offset;
-				break;
-			}
-
-			continue;
+			cp->data = cp->d_count;
+			cp->s_count = 0;
+			dst_setup(cp, mas, mt);
+			init_cp_src(cp);
+			node_copy(mas, cp->src[0].node, 0, cp->data, cp->max, maple_copy,
+				  cp->dst[0].node, 0, mt);
+			node_finalise(cp->dst[0].node, mt, cp->end + 1);
+			/*
+			 * Warning, see cp_leaf_init() comment and rcu_assign_pointer()
+			 * documentation.  Since this is a new root, there are no
+			 * read-side operations that can view it until it is insert into
+			 * the tree after an rcu_assign_pointer() call.
+			 */
+			RCU_INIT_POINTER(cp->slot[0],
+					 mt_mk_node(cp->dst[0].node, mt));
+			cp->height++;
 		}
-
-		/* May be a new root stored in mast.bn */
-		if (mas_is_root_limits(mast.orig_l))
-			break;
-
-		mast_spanning_rebalance(&mast);
-
-		/* rebalancing from other nodes may require another loop. */
-		if (!height)
-			height++;
+		WARN_ON_ONCE(cp->dst[0].node != mte_to_node(
+				mt_slot_locked(mas->tree, cp->slot, 0)));
+		cp->dst[0].node->parent = ma_parent_ptr(mas_tree_parent(mas));
+		mas->min = 0;
+		mas->max = ULONG_MAX;
+		mas->depth = 0;
+		mas->node = mas_root_locked(mas);
+		return false;
 	}
 
-	mast.l->node = mt_mk_node(ma_mnode_ptr(mas_pop_node(mas)),
-				mte_node_type(mast.orig_l->node));
+	/* Converged and has a single destination */
+	if ((cp->d_count == 1) &&
+	    (l_wr_mas->mas->node == r_wr_mas->mas->node)) {
+		cp->dst[0].node->parent = ma_parent_ptr(mas_mn(mas)->parent);
+		return false;
+	}
 
-	mab_mas_cp(mast.bn, 0, mt_slots[mast.bn->type] - 1, mast.l, true);
-	new_height++;
-	mas_set_parent(mas, left, mast.l->node, slot);
-	if (middle)
-		mas_set_parent(mas, middle, mast.l->node, ++slot);
+	cp->height++;
+	wr_mas_ascend(l_wr_mas);
+	wr_mas_ascend(r_wr_mas);
+	return true;
+}
 
-	if (right)
-		mas_set_parent(mas, right, mast.l->node, ++slot);
+static noinline void mas_wr_spanning_rebalance(struct ma_state *mas,
+		struct ma_wr_state *l_wr_mas, struct ma_wr_state *r_wr_mas)
+{
 
-	if (mas_is_root_limits(mast.l)) {
-new_root:
-		mas_mn(mast.l)->parent = ma_parent_ptr(mas_tree_parent(mas));
-		while (!mte_is_root(mast.orig_l->node))
-			mast_ascend(&mast);
-	} else {
-		mas_mn(mast.l)->parent = mas_mn(mast.orig_l)->parent;
-	}
+	struct maple_enode *old_enode;
+	struct maple_copy cp;
+	struct ma_state sib;
 
-	old_enode = mast.orig_l->node;
-	mas->depth = mast.l->depth;
-	mas->node = mast.l->node;
-	mas->min = mast.l->min;
-	mas->max = mast.l->max;
-	mas->offset = mast.l->offset;
-	mas_wmb_replace(mas, old_enode, new_height);
+	cp_leaf_init(&cp, mas, l_wr_mas, r_wr_mas);
+	do {
+		spanning_data(&cp, l_wr_mas, r_wr_mas, &sib);
+		multi_src_setup(&cp, l_wr_mas, r_wr_mas, &sib);
+		dst_setup(&cp, mas, l_wr_mas->type);
+		cp_data_write(&cp, mas);
+	} while (spanning_ascend(&cp, mas, l_wr_mas, r_wr_mas, &sib));
+
+	old_enode = mas->node;
+	mas->node = mt_slot_locked(mas->tree, cp.slot, 0);
+	mas_wmb_replace(mas, old_enode, cp.height);
 	mtree_range_walk(mas);
 }
+
 /*
  * mas_rebalance() - Rebalance a given node.
  * @mas: The maple state
diff --git a/tools/testing/radix-tree/maple.c b/tools/testing/radix-tree/maple.c
index 85fb5616c133c..dfd7099f0d8ef 100644
--- a/tools/testing/radix-tree/maple.c
+++ b/tools/testing/radix-tree/maple.c
@@ -35508,7 +35508,7 @@ static noinline void __init check_spanning_write(struct maple_tree *mt)
 	/* Store a value across a node boundary that causes a 3 way split */
 
 	if (MAPLE_32BIT)
-		i = 49590; /* 0xc1b6 */
+		i = 49430; /* 0xc116 */
 	else
 		i = 49670; /* 0xC206 */
 
-- 
2.47.3


