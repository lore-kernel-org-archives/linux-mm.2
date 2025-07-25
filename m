Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3730C87FCD
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 08:30:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 742316B008C; Fri, 25 Jul 2025 04:30:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F58B6B0092; Fri, 25 Jul 2025 04:30:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 593586B0093; Fri, 25 Jul 2025 04:30:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 46C3B6B008C
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 04:30:29 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DC1E9160660
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 08:30:28 +0000 (UTC)
X-FDA: 83702115336.10.4186DD3
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7BD0A12000A
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 08:30:25 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=QUfmlprc;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=FxxSl01E;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753432225; a=rsa-sha256;
	cv=pass;
	b=Ki/Us6E8Y/+OqARhEZawdeTHO2p2A40tlNaMf8qq4uRcDywFjXMYIanC49Byd2ACjgQxVI
	BNnYzNN7tP1XFwi2Ez1cIfpsYPdukFLRVTVLsX0woLqCxQxEEPSL3ayRkTrG0/25kQAPAV
	zbiLCt2atjKeHzlZSNOD6HbzlRjpCPA=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=QUfmlprc;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=FxxSl01E;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753432225;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wR0snfGmDiCfzvNhAby4UIbwGB+nh3BIn9gP1LXbWR4=;
	b=KvbafBh+R7afxT1mEZBLrzJmGs5oAqmGQA+xQRpPksPOT21P+Pva+O8p2Up5GefbfFrOrR
	nO/NfhvB2FAJR+o1xktwqKBZ3ckrPrnF6t/la2OxvjSj1zrtCItBqKsxM5LLZAqsAjpmVA
	I/CREz+bg90rzAiKZ1/ACx8Wg83bR1A=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56P7flYM018556;
	Fri, 25 Jul 2025 08:30:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=wR0snfGmDiCfzvNhAby4UIbwGB+nh3BIn9gP1LXbWR4=; b=
	QUfmlprcZQduRkfavk7F4V/rDyhuxsw+xTdyCNulFTzfQDh0Rd13MZQBRwKHk/oM
	bkGa35Eug21hq36Pqwek5sGZvWYsuOfbLVSF84++pGUbmZI4xYoOPw1vn6z13Mmg
	YKYvBAgwe4Th1gZeT5JFVHSlcDwrQ2fSEvI6z7yXB/oDoAszNR2ZBAirXS/GLp0q
	T0fxDqwG1W/OZEJb6NlQqY1ZyfgnTg5j12YJdswIosq6p83pl7/quMzV6aJNdjUm
	7eEY72LYJCA6ep+WLUTDw9kJEOPHH+yVVFC7RtvhOlMMvqv6pgfB2Q2Ga2xs/ag5
	aMmzg6F7wIRWaBY1JMn5vQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 483w1j0m0k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Jul 2025 08:30:20 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56P6NX89014404;
	Fri, 25 Jul 2025 08:30:20 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013018.outbound.protection.outlook.com [40.93.201.18])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4801tk5gfk-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Jul 2025 08:30:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aKB05g2XZWP6wQBH66wU4hdIEbES/PX247vTVA0AN/cbtV73RKtBdd25HfsoDFegRdSEeW1Jyg+rEQC8pGGz6qgC/YXq4HVx2KLx9W6MnGtYooQNGrKD1/dcCAqmwFoLgPSmJ5/LTEOh8apqaBHVEHiiiFnAHQvtIMuWGp7UlOeJOQh1xu10IjeQ6q7t4aYOfyQrgrkpOmtDgso57W6zH40JA3yr1dkaXe2KYwGd2FsRw6kDcTgX9Cl9J7foMntrJUDeWBOp4gWAm6hrEa+ohfnijgnWPxBxwSwlUuepfq/yvRs8NNZeVxDesatt/1/6SnzJWa456RnFEH9jSHKnsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wR0snfGmDiCfzvNhAby4UIbwGB+nh3BIn9gP1LXbWR4=;
 b=zOdycFVllOq7gLCXLi3iZl62jBi225WOr4vXAuwd3LpdFQdpsQAboFzQx7VCAIsyrEddcslwP3Wvzx8CvP45tkYLMvWtbxjQbWFMtLtd4RvAlhkL3ztir9s9xs17euLqEq0CBRh5YqvOn7H3FZzGTFHNtj9s2jo5qGtFJpflLwD5DwcZHJRxyZEihJ1nL+pG3gHvHnxDNrzN2I4imRIcrgZZrEnPK4Jv4TGgFliMoXYviGP0OvE7juwWzoek8iwZMURNC87I3hKw3l3U50KAO5Oe8jhINfYJM93kInVtYUxwhAVZLQeRYkCO3Jy/wJzen+gnPgrZvG2BSrPLnpUNAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wR0snfGmDiCfzvNhAby4UIbwGB+nh3BIn9gP1LXbWR4=;
 b=FxxSl01EcJmr2n33/v0PpD8DYe45k7VPz6jPFyxs89A9tYGHbvJNHD0b/BCFNs3YW6+o2JYZ1zp/XTH7x2VGBeH+OUHkwHe4gzRBPUiUHUbtgwSYgchQ8XmkujXTwhRdWydrw3xvOcVkZnfAqK/UgGzw/ouce2j7XccjGmkkiaQ=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SJ0PR10MB4717.namprd10.prod.outlook.com (2603:10b6:a03:2ac::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.23; Fri, 25 Jul
 2025 08:30:17 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.8964.019; Fri, 25 Jul 2025
 08:30:17 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        David Hildenbrand <david@redhat.com>, Vlastimil Babka <vbabka@suse.cz>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Jeff Xu <jeffxu@chromium.org>, Kees Cook <kees@kernel.org>
Subject: [PATCH v4 2/5] mm/mseal: update madvise() logic
Date: Fri, 25 Jul 2025 09:29:42 +0100
Message-ID: <492a98d9189646e92c8f23f4cce41ed323fe01df.1753431105.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1753431105.git.lorenzo.stoakes@oracle.com>
References: <cover.1753431105.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P302CA0042.GBRP302.PROD.OUTLOOK.COM
 (2603:10a6:600:317::14) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SJ0PR10MB4717:EE_
X-MS-Office365-Filtering-Correlation-Id: d7ce52ee-b5f6-4b89-6435-08ddcb557c4d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?pags53ZeiVBh5UrYmImKEtiq3fxjW4n3QqYlXX4zTpVKdztQIIG4FUDbGgYC?=
 =?us-ascii?Q?onEn9Y0GfwTclhYJgAQueTbSY/vrtTxXXa+Yu7WSClEMxNOpJdidIgyiSnzb?=
 =?us-ascii?Q?X7tsX/A2BERJ4wHxxqM1AQV5X/DIAISQYGiJes6qUz834BZcosnBGFlXn7SY?=
 =?us-ascii?Q?Ox5eji91j+q8bkuuxLxIGMpn7Me2PutpM6jKY7FABEVxiEOSVmCzdAf1v/xN?=
 =?us-ascii?Q?0LHBzoiltc2GTuzmfqXwRk5MLxqEw9T87bMZ+SnQUSits7VcQYJpA49qLT2o?=
 =?us-ascii?Q?mRqJSyA/hYTMMc1GkRqXwaun99DlFQCVFZdweqTQVlCcnCdIT+bs9lfSwUf+?=
 =?us-ascii?Q?wt5zLOWADyjo22uGSezkjvhEg5cINpJoL/uVopmx8XFyQxWV6EvgPBHFlKfM?=
 =?us-ascii?Q?MIQEAsQy6RWWp7oRmQ6+/qCU/ZsUf69ROXiwMoAC0wxTGobWlSwwD4JywsAt?=
 =?us-ascii?Q?n5e7lihmtcWzKxjxTHCeBtSZY4M8m7YPInpZevQ6S4Xlz3P09DMwTrdCPA07?=
 =?us-ascii?Q?Bl+tdBFeNIGL26Cedk8NGzRdFCRYBbUqyPjvDxzXAQw1SoZBtsR9aVOt6+Xs?=
 =?us-ascii?Q?ShvytqJA6yLJApDRQorPe1CWJq/xkCxqR9DG5tn3qVIyECXcs9AMkF+bOYFu?=
 =?us-ascii?Q?uyAKPqmiaY3YpiqegwbfvHm7rHpgEtGO1ucsX7YZZbYLAIvIq9RgyRPzUfGM?=
 =?us-ascii?Q?diuCyQh0XuVv7BOc0TWJIG1/Voq4qKNMVUn6nMCy9QzjkzIJNLHddNF/yEHK?=
 =?us-ascii?Q?7+MZQsLTfqtLjGSPfjPBikdsvfFw6RL2fE9MceQcRlnKKV887fCPFWzPUM2U?=
 =?us-ascii?Q?WXhmcRZgXYIOCW2aZtNZwscfzvoSa2dPfGuPYxKQvhzQ++4bzl/utIR0mk04?=
 =?us-ascii?Q?78WqFZUibV8SHoanh3jloBf9JA2iuRmuXlVjUs58QBW7LgeUPEzfvgZ0ov11?=
 =?us-ascii?Q?bVbE/6m1/CX2jJjHSdu5p0YbwYFdbPfl+fgbuLA6y0UqKVzxi4cmqyCOKgI+?=
 =?us-ascii?Q?3KOtIaIzIajpso3mT22nyZLoO9t1ty5QtdB7zBr66zDBQdzgPOosiyB4u9d+?=
 =?us-ascii?Q?1s2LKcXhZM3cJ2HfYQYE9yDRoaHFN2U9X/tPVA+G2tU9PByjVWEsAfeagBP3?=
 =?us-ascii?Q?3duzEo7kd0HyN+aCK9+dWfzdC2LgyaWtc09g6eun2GPEXE2oWFRl+LnYu22u?=
 =?us-ascii?Q?0J5htj+2UHuCawBbF1dRlYzvti4LL61+3xDK4o3cmG3P3IAm6J6/O3jFzV0F?=
 =?us-ascii?Q?BxupZgHMVm53riKIqnDjapJUhlkQcU69R8dCt3tVdQiW9WGvbAlVjN1LvF+F?=
 =?us-ascii?Q?yc6VHTpd2nCYXvWOSsyIi+Qnq4tm6LRwVQtGHiIYIdpCA0+hQ9AGX3zUNSlE?=
 =?us-ascii?Q?gcrZOqUA5k/FcULut6pUahozLnv8LrwF7eGZpIbKAxkD7e9mrEY9ZJ4EnnGR?=
 =?us-ascii?Q?ya1LCpBSHgw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ATEHaOq18buKnGLHhBHNolh+nQXPKLJ0x5XiWpaVUDMZM0RgW/4szvGiu6no?=
 =?us-ascii?Q?osmEPX8be5324XwsAyLx46Cdnev4HY+51NAcLcrdVF/ewC5b6/tcqQdXYrAB?=
 =?us-ascii?Q?kn/bdZnpDBpJ2IA3r4VikMSqGr0AsPdG5C/Wj2njozn2dSNrmwndgkxudcn/?=
 =?us-ascii?Q?yz2cIJ+CNRIBn4u2mES81D+TtPWAPbdXW6Q4NkOUBHnTT70ashbuETR0VHFH?=
 =?us-ascii?Q?+Zwfuqw7aN62tLEmc7MC84XzSa7xbHKkAkIXiSKf79I3JcUqP9ZsC4Nhc34d?=
 =?us-ascii?Q?+W68kG7Jh1V28KmlwszDzIaRLj0epO/wwodFO/XaiVCBJGv/QHe9ud3C9Ovg?=
 =?us-ascii?Q?OZCiT0bDEf0kEXMbStTA/12cCsmbhtWDUdTY4ubcuXaLb+Xb7MO/GX5Q+Ynx?=
 =?us-ascii?Q?c4W4/2/9FDhoFdUPvf4UHJfYVPl/kY5PvZhTkDubaqMvDb5ip6CTV7sM+rmO?=
 =?us-ascii?Q?+QniDSqo+nC/u+7nzEb1dWHn7uKMQXiZsVEVAE6jalxKSmeQRXfKO1EQgZOf?=
 =?us-ascii?Q?AVUNUHIHhqX+xGtK0ZKEY7nBLSN9ZBuq25H2pQaIrLJO40H8uSR9s14R9P/M?=
 =?us-ascii?Q?1Uzfi0AR8ysnL7bVZ8GWSS+fnBTO4ydasMzwP100/cki4BHd3YvZOkPUm1u8?=
 =?us-ascii?Q?BqsjhSf/lES/Wa7yfS7rxTy86rjDjwT/fKnhVxrw0mLA94tWr+tDt41HlXct?=
 =?us-ascii?Q?ZbPbaW/lGNjCCEnHm/7+4dHpigbTeyacbUf7hl7G9bbUd0ZEYVfDJQm4V/TC?=
 =?us-ascii?Q?oQBYRJ/D6ZSazouOskC0cymcYucrv9Zv/6eAL3IEeakPz0BLVtCFDjN3m6zb?=
 =?us-ascii?Q?v0UBouQNT8fsFArj6FwqzjLMuGu6SKDD7k2jbk06NUiCnyDArxFi+/cO3oMV?=
 =?us-ascii?Q?dmj3MpM8Qbls9vf+/zGh1TPK6qQVm26vF5lm7Rlseucc4CWzb1ycLbSh1gj7?=
 =?us-ascii?Q?5RZWHHs/QSiXNoULzYkW1Vk1/KyttmhqV9ViGWNUa9beHZ32h1j7mdCNqKe+?=
 =?us-ascii?Q?vyHOAO6T2Q2yWhUl3qua5LTqIBM2UdzGo+u4HaAHGf3KzKvwhmK2ZuQWgyuM?=
 =?us-ascii?Q?Dp9Ezc4Pcj/Le4RV7sti+2aPKBfL8R9RsUiCN7AsXyBhh1/lQzarGdcy9Fe8?=
 =?us-ascii?Q?Fv7yjwMWIpJJ5K2NzNkF1uWmxj66XXGNAKt2rm9bdKLHv7ffyLClRgxH8hQB?=
 =?us-ascii?Q?fqfSa1JyemdMihlzJcGW38+ZGS1x2KbzLtWxLKndX9jW/nADe6qTWg6tRXkh?=
 =?us-ascii?Q?s0A9wusTpLMPlBCVRjX6djL3T9TjQUgZGchtn+p+djU89k6SdJpPZuXoAGAP?=
 =?us-ascii?Q?CGd04tu3m+bhfWzM9p5S0T16B2W9VGqGD2z5Q3kbn7POtgYOzaczfYSKolnf?=
 =?us-ascii?Q?ATLoRhwN5+OSXujwIxHzipUmIxjaMurKLY6HP7mgF0ufd+UWWu0QVdT2S/5e?=
 =?us-ascii?Q?ZHaOiJY3we337fAzOfiQuzkry1jq/0918B/zO1HDuM5RxcYfjbTEOVjtHIhO?=
 =?us-ascii?Q?AGDIOvXW/xC8GTXvqU32TPLNfO8VRoVywJBaOGF37Ajh4/AVkSp7n7GLrrDh?=
 =?us-ascii?Q?h0Jnev2Pswgjn4O/8szjxg/k8EzLPEpHG5k1K2EL9xWbQmcG74QmGbt6Z9a0?=
 =?us-ascii?Q?CA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	hb94XB6kuPWRyOqWExsId+aGrmCdbQm2CTmd63nLrmMdetWIz8IWMh+3GDnKBz9Cj4lQO21SJRK+FT2P5eERp5jdPdjFBA4CjRNLFiOBTUFShQezMBxtVA1OMWnyC+AQuF4SaYxKQlRyvBZYnNjN6jpXkUdeZiXZtU60/tmsRxPGEcZ9MMvqDZiaxFqI4TCQc++660QH9fg3YDJ6Az9JyRDuct6H3N2Z+LYTupj2k6mK0q1cK9zpxtuC87VNaTeB9yRkeaAIYMdoZsfkMQ22m93dj2g7o+6V/FmTuLJHY1Jca4eKxnToV1jYHcoowzjKNNqMT80GV55OjsHPOCI8fdl0s6IOCkoRGvz+deZv0VF7cPCZYy93/idFTyAU5DfEUOjj+twHaAIroUxVlWRoHhzSmfDBxNc95w4wPOUTIm9fil6uPSSK0CMdBWFuOZ1T/ZVEl3KtQfy1X6phHEHO3mUMqaVwmvMRcIl3ac13BX8yWz0cSp6gpMvZ0KNSCqp6aMwoKlF53V6LoRmUVXvNoM+yq67GfWlNkjyvMMMLQ86UkltzhtW4xRhAnVP+0EmsphQhXuLnRY4jBdHgvsy3nhMseEl6eQJOnnLWxnbeIjM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7ce52ee-b5f6-4b89-6435-08ddcb557c4d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2025 08:30:17.5228
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IXoaEuMgopyDTjSKypGqZReHRn4LeAMu8ipkC127rlydVXtz0gAWLR4dIOoneuqRlGmjVBxc2v/K4Rbm4ynpe9OcIut/KgD/i4txsfilAB8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4717
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-25_02,2025-07-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 suspectscore=0 mlxscore=0 phishscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507250071
X-Authority-Analysis: v=2.4 cv=Jq7xrN4C c=1 sm=1 tr=0 ts=6883409c b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8
 a=20KFwNOVAAAA:8 a=Uh2AKMTr1b2LxUsTHJEA:9 cc=ntf awl=host:12061
X-Proofpoint-GUID: C78ZR2XCkjUwr8F-nqh_ejGrDlteIBNr
X-Proofpoint-ORIG-GUID: C78ZR2XCkjUwr8F-nqh_ejGrDlteIBNr
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI1MDA3MiBTYWx0ZWRfXzg4B0t2Jl/uu
 M26M89g651DpjRkV/RRAxIPyACVXJCEYjXM47/KnopduLlfcSn4Tqr01xNYMzunEYFsv5p5cD52
 TaAtvOdnIaCgby3L+M/B/vGSlPHeOyMvRv2TlJtKyxqJXv9M38vu43hjTc5td6LjGW0N+ufIWgD
 nUG9syiJqYLNjppU1HNBgSNT3MZKZe7P5eejlLjKUxd3lgSEk6/TXev2Kb+nmh2TOLtEP9F39HN
 rdqFuC2F2qodurwgCgkaFJv9fADev3Y7tq976O2QtU0DaW4tOiNnt3eJ0cQsf+wRg1ReiuUddek
 4s6vReZwLAt2Ntv8VBXEaG4Fi2ZjyuqesmyuC5AwZx7dJmSfP6nlnIrb9MyOfIPsVt4LYQ10gia
 m3wSVMQnmRBAAhu8kvlnhy1Gnn4LScMrHCBQ0u3A96zrqaqFRFYNTLAyH5OHpNTNrMpeupxx
X-Stat-Signature: 9yfhhdo89r4zj5tefew1ozrfagrb3cas
X-Rspam-User: 
X-Rspamd-Queue-Id: 7BD0A12000A
X-Rspamd-Server: rspam02
X-HE-Tag: 1753432225-735228
X-HE-Meta: U2FsdGVkX1/VxYrfV8ngYQ3AU8T5GbGIA+NRucWZKA2wFDGbSZhCFQijqjpa/YiqYzMYZVkXGWz8kOdaHcwGRh1H0R4umEsDvOYLh2xULK0Kk6nx3nzdzR6KWidh470B9alXRgtjNqT/d38+BLJ7CFRaRFKXMtdZVaxjixZUmpy4c+CvEZxZoaa7hdsWoMfuOdcM5jcbnE4FLWPgktTjt2pGwdivecEFK6L7/imLPQ+kUlkeYwdsNBvjW9kSnb4odCQyc5oFxN15uqQCgVHHXesZqQxi98CrL/XjQOfhZjdmRkZPoEVXgcCbgCoeKUrLQBFhzYOmX71L4qr3vL1TqsTUvpKEPcZNhd5KQ5mYEvcDiEcRTnD5NxO7oGCGWHMhAfyxHkyJHx4PZeksKe85KqRRwRClDWX7HzVXazE71IcUABuaqclYtCjgPWGWt+xFKdMQ/SMqqtoH006/MP8qgZH8/JReO1jho9SSHDNZChgW5Cro+M8/46BdqALpugx9rg5t+OAJNC+mez6RaKYPFms4uibb9cAJjmf6nZukWzdHjDot032VsAIK5b5D+wr8NZy7NR52l0G5tW4vLu02KJkbVd0Kce2BlG/XI3CpP/AbQhaVH577zZ9DK4XQJNaITh+14DCfz+OT2WiNNSmDjnvdO/QzI5fTzQjLZpNYOcrCBFsT2HoPCKk1uKhKjYRmmsdBoZL3HZGOEOuAtB86GfTFujLe4qQRLFVtYW53M7dJatglT1KYdyYqpRb1q9JoAMimeDPhCbDifRSck3ajztcnctTkOyjcgUQyct3ZK+2UfQyjq8Hf0AvnYxBdwFPUXu9KysDAxNNtaRohHoOMTZ//oEU8Op1WlkB3f1yVPLHUUHGf8UPDJZqyWFbUwKmRJOH5nuY0s+JaStsv6RalI5kudlb1YxM+o3Za7tC0ETCyPXRevJUb/xs0YouiBt+pn71B0OrBUMIJVhkG5hQ
 vhjXbhrm
 Wf6s7u4vXQ1VyuOgkJxlQ8Vm7gwGv+8v8U0SFDntJ+ve3S3HGoxdMwZAZOBzD5r9kq8tl2aBmaEAvihnDh/xLKgPp5sFy404l0sJ636B16JjE51V6CT84tscyFBGEOulEt9QpDX1oGleMrluA7Jp1rhCem8Arb4ovGq14BgCqpGjgnGZw+D1moIq+vLKN6yG+LzNX+/JEp/kvFnwMOwIl8IY6S3aQMjwAcP64GzOyZ1s1BsjyuBh3/VzMuDyjuRNBhDF3l3iQGO9QaFPxKoFyeI0r7QJSopyZNYmx0y6tPIA+qYmJTVNBtqxed5YXcnzGQGLwxX333ZwoCEJKzyu+P1NNRGLMjANP/FsQ9r/LRv/3ARsTzjZEhNcs7I9bW4la9rG1QOrOP5Sn1M4xa8VsaYWcP2UF50mAgDp+H2kBQDcE1xGmcGkrgIRNvxT4Q46Y/pfD8uM63Lld+CnfYz2bqR3F6Pg/9o/YyF88fkGSPpkdGEgsVPoeBYH4zo/FkEN2G58jw+uLwsOjzDprs14sOM2nLwWrFFQxUD8/sedxsRI72G9uW+Ryp9tEwp5Hnj1nqzff2BOUqsUc+SjVdzgqWHs0DHD1c0J0J39dblyqOLREeiAGMKhoLwU2lwo2Q5A/QIt16lrNhCt0dQanvpcyCUlf02/9w+qofEuM8vc1OmZ+xkGI4K4MLbehaim5cqg0GvNKYxCltPsSh6EGLdjK8DHGV8PWNvPgWXxJn+6Lfo41q8ygaE3xI1Yw4oe88HuiY9pd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The madvise() logic is inexplicably performed in mm/mseal.c - this ought
to be located in mm/madvise.c.

Additionally can_modify_vma_madv() is inconsistently named and, in
combination with is_ro_anon(), is very confusing logic.

Put a static function in mm/madvise.c instead - can_madvise_modify() -
that spells out exactly what's happening.  Also explicitly check for an
anon VMA.

Also add commentary to explain what's going on.

Essentially - we disallow discarding of data in mseal()'d mappings in
instances where the user couldn't otherwise write to that data.

We retain the existing behaviour here regarding MAP_PRIVATE mappings of
file-backed mappings, which entails some complexity - while this, strictly
speaking - appears to violate mseal() semantics, it may interact badly with
users which expect to be able to madvise(MADV_DONTNEED) .text mappings for
instance.

We may revisit this at a later date.

No functional change intended.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Acked-by: David Hildenbrand <david@redhat.com>
---
 mm/madvise.c | 71 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 mm/mseal.c   | 49 ------------------------------------
 mm/vma.h     |  7 ------
 3 files changed, 70 insertions(+), 57 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index bb80fc5ea08f..7f9af2dbd044 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -19,6 +19,7 @@
 #include <linux/sched.h>
 #include <linux/sched/mm.h>
 #include <linux/mm_inline.h>
+#include <linux/mmu_context.h>
 #include <linux/string.h>
 #include <linux/uio.h>
 #include <linux/ksm.h>
@@ -1256,6 +1257,74 @@ static long madvise_guard_remove(struct madvise_behavior *madv_behavior)
 			       &guard_remove_walk_ops, NULL);
 }

+#ifdef CONFIG_64BIT
+/* Does the madvise operation result in discarding of mapped data? */
+static bool is_discard(int behavior)
+{
+	switch (behavior) {
+	case MADV_FREE:
+	case MADV_DONTNEED:
+	case MADV_DONTNEED_LOCKED:
+	case MADV_REMOVE:
+	case MADV_DONTFORK:
+	case MADV_WIPEONFORK:
+	case MADV_GUARD_INSTALL:
+		return true;
+	}
+
+	return false;
+}
+
+/*
+ * We are restricted from madvise()'ing mseal()'d VMAs only in very particular
+ * circumstances - discarding of data from read-only anonymous SEALED mappings.
+ *
+ * This is because users cannot trivally discard data from these VMAs, and may
+ * only do so via an appropriate madvise() call.
+ */
+static bool can_madvise_modify(struct madvise_behavior *madv_behavior)
+{
+	struct vm_area_struct *vma = madv_behavior->vma;
+
+	/* If the VMA isn't sealed we're good. */
+	if (can_modify_vma(vma))
+		return true;
+
+	/* For a sealed VMA, we only care about discard operations. */
+	if (!is_discard(madv_behavior->behavior))
+		return true;
+
+	/*
+	 * We explicitly permit all file-backed mappings, whether MAP_SHARED or
+	 * MAP_PRIVATE.
+	 *
+	 * The latter causes some complications. Because now, one can mmap()
+	 * read/write a MAP_PRIVATE mapping, write to it, then mprotect()
+	 * read-only, mseal() and a discard will be permitted.
+	 *
+	 * However, in order to avoid issues with potential use of madvise(...,
+	 * MADV_DONTNEED) of mseal()'d .text mappings we, for the time being,
+	 * permit this.
+	 */
+	if (!vma_is_anonymous(vma))
+		return true;
+
+	/* If the user could write to the mapping anyway, then this is fine. */
+	if ((vma->vm_flags & VM_WRITE) &&
+	    arch_vma_access_permitted(vma, /* write= */ true,
+			/* execute= */ false, /* foreign= */ false))
+		return true;
+
+	/* Otherwise, we are not permitted to perform this operation. */
+	return false;
+}
+#else
+static bool can_madvise_modify(struct madvise_behavior *madv_behavior)
+{
+	return true;
+}
+#endif
+
 /*
  * Apply an madvise behavior to a region of a vma.  madvise_update_vma
  * will handle splitting a vm area into separate areas, each area with its own
@@ -1269,7 +1338,7 @@ static int madvise_vma_behavior(struct madvise_behavior *madv_behavior)
 	struct madvise_behavior_range *range = &madv_behavior->range;
 	int error;

-	if (unlikely(!can_modify_vma_madv(madv_behavior->vma, behavior)))
+	if (unlikely(!can_madvise_modify(madv_behavior)))
 		return -EPERM;

 	switch (behavior) {
diff --git a/mm/mseal.c b/mm/mseal.c
index c27197ac04e8..1308e88ab184 100644
--- a/mm/mseal.c
+++ b/mm/mseal.c
@@ -11,7 +11,6 @@
 #include <linux/mman.h>
 #include <linux/mm.h>
 #include <linux/mm_inline.h>
-#include <linux/mmu_context.h>
 #include <linux/syscalls.h>
 #include <linux/sched.h>
 #include "internal.h"
@@ -21,54 +20,6 @@ static inline void set_vma_sealed(struct vm_area_struct *vma)
 	vm_flags_set(vma, VM_SEALED);
 }

-static bool is_madv_discard(int behavior)
-{
-	switch (behavior) {
-	case MADV_FREE:
-	case MADV_DONTNEED:
-	case MADV_DONTNEED_LOCKED:
-	case MADV_REMOVE:
-	case MADV_DONTFORK:
-	case MADV_WIPEONFORK:
-	case MADV_GUARD_INSTALL:
-		return true;
-	}
-
-	return false;
-}
-
-static bool is_ro_anon(struct vm_area_struct *vma)
-{
-	/* check anonymous mapping. */
-	if (vma->vm_file || vma->vm_flags & VM_SHARED)
-		return false;
-
-	/*
-	 * check for non-writable:
-	 * PROT=RO or PKRU is not writeable.
-	 */
-	if (!(vma->vm_flags & VM_WRITE) ||
-		!arch_vma_access_permitted(vma, true, false, false))
-		return true;
-
-	return false;
-}
-
-/*
- * Check if a vma is allowed to be modified by madvise.
- */
-bool can_modify_vma_madv(struct vm_area_struct *vma, int behavior)
-{
-	if (!is_madv_discard(behavior))
-		return true;
-
-	if (unlikely(!can_modify_vma(vma) && is_ro_anon(vma)))
-		return false;
-
-	/* Allow by default. */
-	return true;
-}
-
 static int mseal_fixup(struct vma_iterator *vmi, struct vm_area_struct *vma,
 		struct vm_area_struct **prev, unsigned long start,
 		unsigned long end, vm_flags_t newflags)
diff --git a/mm/vma.h b/mm/vma.h
index acdcc515c459..85db5e880fcc 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -577,8 +577,6 @@ static inline bool can_modify_vma(struct vm_area_struct *vma)
 	return true;
 }

-bool can_modify_vma_madv(struct vm_area_struct *vma, int behavior);
-
 #else

 static inline bool can_modify_vma(struct vm_area_struct *vma)
@@ -586,11 +584,6 @@ static inline bool can_modify_vma(struct vm_area_struct *vma)
 	return true;
 }

-static inline bool can_modify_vma_madv(struct vm_area_struct *vma, int behavior)
-{
-	return true;
-}
-
 #endif

 #if defined(CONFIG_STACK_GROWSUP)
--
2.50.1

