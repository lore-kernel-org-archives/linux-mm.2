Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69079CCFA13
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 17:09:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D50986B009D; Wed, 29 Apr 2026 13:09:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D27676B009E; Wed, 29 Apr 2026 13:09:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEEB06B00A0; Wed, 29 Apr 2026 13:09:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A9CC26B009D
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 13:09:47 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3C49A120380
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 17:09:47 +0000 (UTC)
X-FDA: 84712230414.09.2D615D6
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11020079.outbound.protection.outlook.com [52.101.46.79])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5062040008
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 17:09:44 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=t95vopLV;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com;
	spf=pass (imf12.hostedemail.com: domain of yang@os.amperecomputing.com designates 52.101.46.79 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777482584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SiGy7egxy0O4EpOLGBfpWgtxzEOEvzGUCa06Lm+Fo4I=;
	b=3miYQb99l2wkhEipLx/HSZQVc31gMjHfRTzTIr+m355RT+xmo8Si3Rdb3R5JfKajzYHt4V
	Qfv3/Ez3A14ufAvM73n4qcguxDNe+J/2QDjwALP0l4jIrAx5ou1LXxlB1AV5gYjzEwu4Zp
	aBJeWDbNpHUbo+Xn9J81UZ7EiZD7yAs=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777482584; a=rsa-sha256;
	cv=pass;
	b=E1cV5UjwArsnwbFrHwhbiPA52lGn2G4jk/N3RPzOGDYZYf5Ms4jqYagHMISyUmbHL/+yEN
	9B1pJVzo3BcXu/1hVQx9sf1tVAGv55ADzhnBVAmpZigdTWHOXpMPf5M380BfoR8ELVRd0q
	gkEHPCsii8VT5wuUFG7+/0nhz/msML4=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=t95vopLV;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com;
	spf=pass (imf12.hostedemail.com: domain of yang@os.amperecomputing.com designates 52.101.46.79 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oU9cQce4i/k25aW9cJgNjNwUdiWPBigXylZb5BrgRJNlFckFu+rVJwQTfrUdm4Wzu/Jn/lb6bCVGVKXYaLB8sgqUrCaRv5XqRXUaAbTiZyYs9C91ieFo2Ku+RBxL5IPhkNr7Laiugt7cRBs2x/Nm/at0ERFBBQvbIuQaVePqzl/0UpX3Z5PRGmwP70+G3AK5OtyFLRS2gatD7gNnA/zxtprftT5DKXQUVlfFNoKTedPgchwKF/mAHrtpeIDt2oXeKqzI86H84pWVozAT3PmCUZmewyW3UTFA+DHs/aHD18k/VcUn8ES1xK2N0W+KdWtCBeH5xDSIIsUBaU/QLhnUwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SiGy7egxy0O4EpOLGBfpWgtxzEOEvzGUCa06Lm+Fo4I=;
 b=DHehpoJmr22VkWIzWyfrZOkWc2qfAkcxVugtKWDONEo8z/wYFCRNUy3E07ZvUnPbFZ6FMuZNQESiJDtRf2/Tgh7yjM6vcb0TuQxyDX9CBNKTt22ightsuKebObjdsrYFA8erAQFAPOWbyDy6VoTLtgLbwUmTB9I0tddyhOIvOXp4CBUrBf/DXqE9YWWIGZDe/yMS3DJefHofZlo/8n8Q9nESs53p0FpSCfHI4nHhsGSpWqEJ8RsroDzc34TSTqAQo5glJ7+5g2s7kXQCD3sTkGTZJPYz0SiIY/c5XGYBlWj97ZD9U2Ia6IWXsDEr35yiGqKf6Hl5zgqnnUUtjHZ32A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SiGy7egxy0O4EpOLGBfpWgtxzEOEvzGUCa06Lm+Fo4I=;
 b=t95vopLVwF20znmQ5cgvziQfKTlrIvkk4+vOuMl6HXdq74xTpavtn75EJ45pKSUsvLwSdoBWoAnzMytAFI7gBLnsj0UQOLa2dyUBzqRB5GiFYwM8M/PvqICbWy7vlISSvzOVvjEgRs+1YRdkvqAlX5QydaRC6V8qkTu1U1DCS2Y=
Received: from CH0PR01MB6873.prod.exchangelabs.com (2603:10b6:610:112::22) by
 SA1PR01MB6671.prod.exchangelabs.com (2603:10b6:806:18b::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9846.26; Wed, 29 Apr 2026 17:09:01 +0000
Received: from CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::46eb:64a3:667c:c1a0]) by CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::46eb:64a3:667c:c1a0%4]) with mapi id 15.20.9870.020; Wed, 29 Apr 2026
 17:09:01 +0000
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
Subject: [PATCH 05/11] arm64: mm: map local percpu first chunk
Date: Wed, 29 Apr 2026 10:04:33 -0700
Message-ID: <20260429170758.3018959-6-yang@os.amperecomputing.com>
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
X-MS-Office365-Filtering-Correlation-Id: 08c5c55c-d498-41e3-89ae-08dea612022c
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|18002099003|56012099003|22082099003|55112099003|921020;
X-Microsoft-Antispam-Message-Info:
	Qz7sknmep2dfSYpdqqalk6WBFwT5oBVrUfEYcdGVUMR892m7YzmNuqsPSrrIE6KLKcNRJ4umh2Z47QnYO4kPwPFDwI5B/huGQtY5zWTbwjQ+h1ytyRs7e9iwdKc9ay6K6TiNSpP13UTXDXK3CmtQJnE9eYqQxhJeU4niTuOkE5xJv3TyJwr4XeExxobJx46n4pFLBIgoCcn4uJz3vH8pBvZx3h+/sXnYUlTOcpcIHIvn468vocxPKgeWs/+hwZWWpJRX1OBHiRMJqVcPZcj88PFgFGAzbwnvAwH/NOMAY9uj8q6UA0cHBZS/xr9KjXZqOvciZohytDCEXhZxyFxf45u9OFfXeQNRCzh4qmNdxTi6F59pEY8I7pRID48Bfmdq8aNJxwhnmGPs9EONaTV2un4EQwZv8AtXbcmLenSC1s4KOMUoF1nZB/yehEZl14rz1Drldnrk4yNQzXoGgfCVgIEJmWYGt/5qTmtXPB5uH7tTjO0YPfpWwoct9xVDl/9Dp6KikFfVYuc3AcSXJIQ2S/6LgZn5b2IuzJRtW5OtUu+eSwvJFgxrhizHqQmK4rKkj/X3BeZogAELsZYL+cZE3G8nbg2fgULr0DFsBCQ6q/+WySHEcW8N1ElWLnqdrDEva+DXVNP/Et2+oTWO4dN5ls8yh0UwelR6n7QimXOk7cd3Q/fYREF4k+Vn7TEnI21VjpYMWtfPnbZr6R+I5Tml/jdy2D5E3vXwTUEuXEQ12jQOhwuA+7TrdF+mP+WRqS7/+JKTO9dQ7uExdZAkKlmnIw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB6873.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(18002099003)(56012099003)(22082099003)(55112099003)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8TLkSBJ/Af+NFTfsXEaW/ZLpUqZyb+UVVMEcAMy4V6tqSGatvYe+mLHV4dCW?=
 =?us-ascii?Q?052xSytGQTkYv/LEVy+2aXFgL88r5BTKV+ILG7MNMR+7lwJJIXf2lpggYQyy?=
 =?us-ascii?Q?PhyU+YDXY5f9/IsVWefTNXWMEd6VT7dsl7Y11CWu3C0jvPnJS21yeKcT48NL?=
 =?us-ascii?Q?zFdg0ulzpPnfMVd0SyoKhiIbrPY5mXcjVy5YxS6MVfUjtJvBD9BrWmJh6Vem?=
 =?us-ascii?Q?gEzuNDGQo6NZds2VBih15nxIhfoeBM49AUOYViKVnPp4Ycc8bxLbGrUr11bo?=
 =?us-ascii?Q?RUwt9+QABrAJHWjpB3ZSRke0qckeOeXGc0eTVCGge18ZphTWBmx4ZlCwc56U?=
 =?us-ascii?Q?Y8KWhv3DDIxgbFKbgTTKfeDNqm2V+QO8T9Tl3adCx+Qq/bgKSyror/p/7ieh?=
 =?us-ascii?Q?dTajbNr3x0XSoYH93AOsUZFpI7XRDPBofS7PJrELS1LGZaQ0BWcKaZsRppHd?=
 =?us-ascii?Q?hP19EXv+pW9sB/x7WhitA3X260gWuXa7Jz7jaIScuhkxZNJSJVtmXoqmtW0D?=
 =?us-ascii?Q?bwjIRAzP84LThRZRxPN8AfbmsKrMlZnrqDrCQMDc04JD1oGBeZjexru3Q8en?=
 =?us-ascii?Q?bKnQ/TmMHEzGhDHLec2aDKs+v0TUDvCcv6ZmdElf+rwzWZEhY3jXdDf1tYWI?=
 =?us-ascii?Q?bURNRgJc7vi2JytyslT6bAbBpPP+YdNwOk9PV+l0CMCkJVsfvf+fll/VAJoa?=
 =?us-ascii?Q?oYGUt4pu2TpztqcXkeDGJfMLoTwqQUkMz41KPQ/BaxiPoY4fIpm+9soVePlS?=
 =?us-ascii?Q?BpOqBiEmIsYj75XdPbJvYl8j087dbD6swHMih27ukgcEXaf+jxhEy4nMAltL?=
 =?us-ascii?Q?F5+ycxyFJ1A3Um2spraYVjXhaIvnzbMP1m73t9DspUTfjYgnNLCRRXjulXj9?=
 =?us-ascii?Q?KTbxw7BsjYuiJff2WTJpq40ko/Y0BATTlqv5qub+lbB63DH+ykc1y2VihzoY?=
 =?us-ascii?Q?u7E4r3nWIHEgBTPY82BGkM2XLBIpaA5zwEeGlEs6ywuGxtWejs9DAL+jbNFe?=
 =?us-ascii?Q?DdUCfybjulCK/QBshLPl0qUB+jxXM5N4+J4tdbf2gLNVTbiXnILEYC1ggWdh?=
 =?us-ascii?Q?6BHyJRCR5zbpXm4CNIfO3y7ouDT4z2/X3lVKa5dbZNyyY28S6idQ4CkZEB3R?=
 =?us-ascii?Q?FFNXgLfqu6wpaGn+7vd3+aHGI0nFy/J52BXm0W9BJwLr/92Jf1Nj2vurGtZm?=
 =?us-ascii?Q?hvvgwskwO6coXmpGGFfxDbpgOY/qmigBLDuYMyy4gsXTH9ZUQPcd3PFEvvxM?=
 =?us-ascii?Q?mUjCLbVwBT8fw5+QhKzF7CCCIAHcR6LawFPNsYZAyG4G5WS09xztEkoRZbYI?=
 =?us-ascii?Q?23YpH0rA6AahK50Z9ets1AYPoHjB9oatuo2BlF6ivGYg8nW8opdRgs0kpN2l?=
 =?us-ascii?Q?Axl/YDkL7zYN6vGVPyhc+87frEEQB0po6oORvs48wWVmc+V+T+BZUWZzVjto?=
 =?us-ascii?Q?lKikrt+rzSLKPnkxGU6roPZQ+nk9qtCLBDwSNW2R/c717mepssjbY2sW5ncB?=
 =?us-ascii?Q?5krnLvtyHBuneMluze5u8i2CTtugSUxy3qkHUUTsWhK+5Q6jDp6oVcC4Nt/f?=
 =?us-ascii?Q?NkzybRuulNkvlhXDFf5VDQpQHMrpqeF3r3qgRHdf205BAnSUGSfNw5iNwfZv?=
 =?us-ascii?Q?8oMBrxOtYCbGPH5EyN4rMB0/t2PWR7qOtXB0vUA/mNQ9jsyRGlJI88+nP7Qu?=
 =?us-ascii?Q?UMPljsngkqDhPkHJgVBOX5fm5gnQz9vyxSTJF1WKLMuKXD6VUqSrwTxyu1GK?=
 =?us-ascii?Q?67ejBIpYdVImPNn4+JfhljtsvOF5VcE=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08c5c55c-d498-41e3-89ae-08dea612022c
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB6873.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2026 17:09:01.0876
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m3/eSET2R8K5djKvnS5RoCPUbYZg/nbkRzmoKxGgbEDCvLP+plQGLX56ZDXbnhfzJ0JOPYIMtIeWGGc/AaAm1VEiyDIHNDkAUQTu6Mxl8W8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR01MB6671
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5062040008
X-Stat-Signature: 1u7uibyx56pht5ou4mot3md4zr1csa7i
X-Rspam-User: 
X-HE-Tag: 1777482584-735220
X-HE-Meta: U2FsdGVkX1/ct7dQ/YmukuidEMUodZbkD3GlnG4fC+UNfKMhWt98zUV2N3TBzgWHHTgwrSPCWfXCbn9MLRQW2d+UJxLouGiUEAvDCmDwLB+miY3a0GB4rXEfn6/KB+Jdz9cEsAgdJYRf2d4Z+POPSIYYC1eVv8TP3K3oFmTy/H9Xu/njlUTt1wCHwEs4F4SO+/DYjiMEzH0LWOFcygQt6hR0AgSsT8hT1RwrnZCzIp1a6Nf8EK2i2ah4pmvcNgc1dvUEft7X4VCEJsU3boCd4oeGvfF6DMlAcC7V7ewJx55aIk0h9bOm0Z+eqydcFDe4yEUuhYnbynQIRPVuoQJdH4cGEpLDk9BRgUhfdm20CbTMO29uyr4AVvtch/ACoTalJCKchI/Vw627mPq1Pn+sfT7SE6qqOZNN7LPZYW0er/qDQck63D+aVoseZKQhLq05g3lEoIOsxeTfKiOIiSOH3fYKU+F9B0fuiCnG5jinkJtPhxj7t/9XYyXAzXuJ9FuJ1HmN5rw3YhPBmJXj8xP+Cz2w81ZnYwJlRzCwq2fI0lDi9xm6njS9LTgCl6eIlr6E9aM5tzPaHAR3c5ZTCtr+VWWimxCaa3LY48Y5TI85M1rRmTZjd9W345fZrq0qufh22DNySp63R49P7KM+iz97ea+aAS4aIRpljaRe6HSSWNeBCJrjnoCiCC9xLTc3vpZgXWFqhtDPgu1IgTAy0LhZUiB3OVZgvJF0u3l7V9W/v2bKarNr4Ey5lPv0VVwlp7DbsQlbWFbW2pJZGwzSIs4jP5fybWonBtwzSfJ2YGbGCBp6yz3Ojk14S8miQYjLGC8SIKYN4E2wFFRSBr6wmhfZdWUAV5CAk6/zLEz1M9LCouzUkGp7zO8dhIIwrOgFsSDwB67ujNsCddD6n9Wam97jy86deOi5gsSQ0COmxKZBUKNI8ZIU4JVipiwA89DsZwLFqLaBnPv0WhC0FpDYXfP
 VOwvT8+G
 dzXNhM+NDESm2dJbTrWeuAjEiz9nqMuvRqS6AkvpZaj8NcAVXKOfh3mX3RHWxAfvzNx4AZd+VuFor6PE5VCO1EAfZ1/0AeKNr/IPJfmoHmN3AzxaoWr6z9j/jSv3Xk4lkGBD232J0s5xECMJaXPLK10hMqZCalyFuZEekcOXP9z3TsWLdG08CpAOFlIaRKmop1yA79Y7Vz2j7y10teSrQ+Z+PLDWqRRswwDYErYC9gkJx/ZBnB8Jm+6EUrUo/zL+Fav+BhhT6N4YlvBN2li26Aen4jzUSoRLLTsKfNsu8mcwnsmShzQUHIsvDJrxNVtZdk54XxutRZlsL0XdK9IFXx75UzFvoEK/FsqBU/G3LOHDQyENfB9C5a3TSqD4HrtGujyp/bhGutAcampOGrotlI0tSPZ4UdBfBVclFGES5P14Zq8nQwcT7eIaPxjyNEP9iHRAUNC+4wKVYN6X2MpsbYy1NT3ZBKoeIlJ6uifkutWfgNzQLSvkOgz03CGBhrZFjFJLq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Allocate local percpu area and map to percpu page table for the first
chunk.

It doesn't work for PCPU_FC_EMBED because the percpu base adddress may
be in linear mapping space in this case, it will result in returning huge
offset for percpu allocator.  So percpu local map just can work with
PCPU_FC_PAGE which allocates percpu variables from vmalloc area or the
dedicated percpu area.  So unselect NEED_PER_CPU_EMBED_FIRST_CHUNK if
the architectures support percpu local map.

Signed-off-by: Yang Shi <yang@os.amperecomputing.com>
---
 arch/arm64/Kconfig           |  1 -
 arch/arm64/include/asm/mmu.h |  2 ++
 arch/arm64/kernel/smp.c      | 25 ++-----------------------
 arch/arm64/mm/mmu.c          | 18 ++++++++++++++++++
 mm/percpu-internal.h         | 12 ++++++++++++
 mm/percpu.c                  | 13 +++++++++++++
 6 files changed, 47 insertions(+), 24 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index fe60738e5943..0e12e531a5b2 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1525,7 +1525,6 @@ config NUMA
 	select GENERIC_ARCH_NUMA
 	select OF_NUMA
 	select HAVE_SETUP_PER_CPU_AREA
-	select NEED_PER_CPU_EMBED_FIRST_CHUNK
 	select NEED_PER_CPU_PAGE_FIRST_CHUNK
 	select USE_PERCPU_NUMA_NODE_ID
 	help
diff --git a/arch/arm64/include/asm/mmu.h b/arch/arm64/include/asm/mmu.h
index 8ed3b5f3cf84..d81e5c483b55 100644
--- a/arch/arm64/include/asm/mmu.h
+++ b/arch/arm64/include/asm/mmu.h
@@ -73,6 +73,8 @@ extern void *fixmap_remap_fdt(phys_addr_t dt_phys, int *size, pgprot_t prot);
 extern void mark_linear_text_alias_ro(void);
 extern int split_kernel_leaf_mapping(unsigned long start, unsigned long end);
 extern void linear_map_maybe_split_to_ptes(void);
+extern void map_local_percpu_first_chunk(pgd_t *pgdir, unsigned long virt,
+				struct page **pages, unsigned int nr);
 
 /*
  * This check is triggered during the early boot before the cpufeature
diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
index 0cc8f4a9efa7..4caa6ebec12f 100644
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -831,36 +831,15 @@ int early_cpu_to_node(int cpu)
 	return cpu_to_node_map[cpu];
 }
 
-static int __init pcpu_cpu_distance(unsigned int from, unsigned int to)
-{
-	return node_distance(early_cpu_to_node(from), early_cpu_to_node(to));
-}
-
 void __init setup_per_cpu_areas(void)
 {
 	unsigned long delta;
 	unsigned int cpu;
 	int rc = -EINVAL;
 
-	if (pcpu_chosen_fc != PCPU_FC_PAGE) {
-		/*
-		 * Always reserve area for module percpu variables.  That's
-		 * what the legacy allocator did.
-		 */
-		rc = pcpu_embed_first_chunk(PERCPU_MODULE_RESERVE,
-					    PERCPU_DYNAMIC_RESERVE, PAGE_SIZE,
-					    pcpu_cpu_distance,
-					    early_cpu_to_node);
-#ifdef CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK
-		if (rc < 0)
-			pr_warn("PERCPU: %s allocator failed (%d), falling back to page size\n",
-				   pcpu_fc_names[pcpu_chosen_fc], rc);
-#endif
-	}
-
 #ifdef CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK
-	if (rc < 0)
-		rc = pcpu_page_first_chunk(PERCPU_MODULE_RESERVE, early_cpu_to_node);
+	/* PCPU page table just can support PCPU_FC_PAGE */
+	rc = pcpu_page_first_chunk(PERCPU_MODULE_RESERVE, early_cpu_to_node);
 #endif
 	if (rc < 0)
 		panic("Failed to initialize percpu areas (err=%d).", rc);
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 7708dcc1b6a9..81b662433677 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -1044,6 +1044,24 @@ void __init linear_map_maybe_split_to_ptes(void)
 	}
 }
 
+void __init map_local_percpu_first_chunk(pgd_t *pgdir, unsigned long virt,
+			    struct page **pages, unsigned int nr)
+{
+	int i;
+
+	arch_enter_lazy_mmu_mode();
+
+	for (i = 0; i < nr; i++) {
+		phys_addr_t phys = page_to_phys(pages[i]);
+		__create_pgd_mapping_locked(pgdir, phys, virt, PAGE_SIZE, PAGE_KERNEL,
+				    early_pgtable_alloc, NO_EXEC_MAPPINGS);
+
+		virt += PAGE_SIZE;
+	}
+
+	arch_leave_lazy_mmu_mode();
+}
+
 /*
  * This function can only be used to modify existing table entries,
  * without allocating new levels of table. Note that this permits the
diff --git a/mm/percpu-internal.h b/mm/percpu-internal.h
index 4b3d6ec43703..b33d1f5aba1b 100644
--- a/mm/percpu-internal.h
+++ b/mm/percpu-internal.h
@@ -5,6 +5,7 @@
 #include <linux/types.h>
 #include <linux/percpu.h>
 #include <linux/memcontrol.h>
+#include <linux/mmu_context.h>
 
 /*
  * pcpu_block_md is the metadata block struct.
@@ -162,6 +163,17 @@ static inline size_t pcpu_obj_full_size(size_t size)
 	return size * num_possible_cpus() + extra_size;
 }
 
+#ifdef CONFIG_HAVE_LOCAL_PER_CPU_MAP
+extern void __init map_local_percpu_first_chunk(pgd_t *pgdir, unsigned long virt,
+                            struct page **pages, unsigned int nr);
+#else
+static inline void __init map_local_percpu_first_chunk(pgd_t *pgdir, unsigned long virt,
+                            struct page **pages, unsigned int nr)
+{
+	return;
+}
+#endif
+
 #ifdef CONFIG_PERCPU_STATS
 
 #include <linux/spinlock.h>
diff --git a/mm/percpu.c b/mm/percpu.c
index daa2c88e6971..59682b77089c 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -3194,6 +3194,7 @@ void __init __weak pcpu_populate_pte(unsigned long addr)
 int __init pcpu_page_first_chunk(size_t reserved_size, pcpu_fc_cpu_to_node_fn_t cpu_to_nd_fn)
 {
 	static struct vm_struct vm;
+	static struct vm_struct pcpu_vm;
 	struct pcpu_alloc_info *ai;
 	char psize_str[16];
 	int unit_pages;
@@ -3247,6 +3248,10 @@ int __init pcpu_page_first_chunk(size_t reserved_size, pcpu_fc_cpu_to_node_fn_t
 	vm.addr = (void *)ALIGN(PERCPU_START, PAGE_SIZE);
 	vm.size = num_possible_cpus() * ai->unit_size;
 	vm_area_add_early(&vm);
+
+	pcpu_vm.addr = (void *)ALIGN(LOCAL_PERCPU_START, PAGE_SIZE);
+	pcpu_vm.size = ai->unit_size;
+	vm_area_add_early(&pcpu_vm);
 #else
 	vm.flags = VM_ALLOC;
 	vm.size = num_possible_cpus() * ai->unit_size;
@@ -3270,6 +3275,14 @@ int __init pcpu_page_first_chunk(size_t reserved_size, pcpu_fc_cpu_to_node_fn_t
 
 		/* copy static data */
 		memcpy((void *)unit_addr, __per_cpu_start, ai->static_size);
+
+		/*
+		 * Map percpu data to PERCPU map.
+		 *
+		 * PCPU_FC_EMBED can't support it.
+		 */
+		map_local_percpu_first_chunk(percpu_pgd[unit], (unsigned long)pcpu_vm.addr,
+				&pages[unit * unit_pages], unit_pages);
 	}
 
 	/* we're ready, commit */
-- 
2.47.0


