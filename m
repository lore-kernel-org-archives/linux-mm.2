Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CFE9C44536
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 16:56:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B3986B00B9; Wed, 21 Jan 2026 11:56:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 068C36B00BC; Wed, 21 Jan 2026 11:56:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E57FF6B00BD; Wed, 21 Jan 2026 11:56:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D04506B00B9
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 11:56:15 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 907D81407CB
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:56:15 +0000 (UTC)
X-FDA: 84356573910.02.1359350
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf29.hostedemail.com (Postfix) with ESMTP id 44A7B120009
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:56:12 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=kosUefU0;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="NZAPVEd/";
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769014572; a=rsa-sha256;
	cv=pass;
	b=dN1pjrV/NlZeADv0hpdkxNaRgzMEQ2FOlG6DhHEf1UsmSasVbMqnxjuZNkNuBYAelIhwF5
	7tPgAmpz/q+tuQQTBP0LnicZLdCVztLZLjnqm9jNSGBy8ZedjeQ+DlM1GevwVayggc5LEh
	wUfNIIUQG5CwEl4dgN6yghakpKgCRKI=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=kosUefU0;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="NZAPVEd/";
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769014572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zhpAJfpAPXrdJKoa4BdszQkSHMW3Ti4W66jte16TQrI=;
	b=ofVAAr/mYXosUe/ZYHkJ9CBidm9R1umkogbln7j7RUqycK0wT/4NhbgzrvjXGkm1ftC+Y/
	NMQk255yqs4zckVTlBEatdtGLZ7akXcdpF2yZHbO9ZSNvPAMxadiVQBIqALefZNotMY0ad
	VoshzaDZG7/d99Oc12tKltxpXoVH+hs=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60LGOLGT420702;
	Wed, 21 Jan 2026 16:50:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=zhpAJfpAPXrdJKoa4BdszQkSHMW3Ti4W66jte16TQrI=; b=
	kosUefU0dI0p4OHZbGZuEQ4p73tVvqFuZGoIZ+Mm+D4B2Fvki8WC1CZc8/eCpBZP
	E3ek9wSUqGivTAgB5QsoiUzFrTWytwqJRDU+CyMedHYGIi1gCCo4ehTJehm4EMnB
	Z/yTwlVVLToT0XXjM9Xa9yYJLmsdi6NLgHyjYIF3kr+hhuwm+FAGdlYRzJWqyi1v
	Bha5IBw469pNtD/fwUgjs7t8ghYTp6E50YFNMozA+1EK5ri2ItblPgGC5t0yyxbF
	lUsoD6R20oX6nanWCNe5Lg1iWAvXbCHGRjdHN+RyD6DXhfxtv5OcWgynNJ/voMuN
	7bp8z1VYGOyluvPNRrqptQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4btagctsyj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 16:50:56 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60LFUo9l021914;
	Wed, 21 Jan 2026 16:50:56 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010022.outbound.protection.outlook.com [52.101.46.22])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vf9rbx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 16:50:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iyPhD6taCAIjPsH8zx2SNEnwGN9Wnk8tKslX+iQgHxcUd+gX1sPaIS7hKLGga6ZlwpbVA5OSUqAdg4XG/9ZawQvABA+jM6N1pmwKL9duLjATkc/aBwyYKyuhVXWoTIkH8TIgTMMEkTlwqKxsblp/WxSRczCVp470h/hKM3nsf4YgIBRh0IFjy1V8T5aL62eLI4LM3iRUiqFlTi6fPDvxY0Wcxmf//q76dIu+HKlOE+vFhHvwysIaxfWAy1LkiHMmP9B/0dgectwAAj9kgmrI6MRH/d3Hv4+cRja5ZsPK/otn73x+e6u7j33BP8FPVfdzlF1VlRMe8CHf1P7H75lZjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zhpAJfpAPXrdJKoa4BdszQkSHMW3Ti4W66jte16TQrI=;
 b=rkrcvxNdNvl863wDn0ykkFJw/6Vj+qST/BrXMyTNn58X7dYJ0Jrf0DXEgnjedida5YxOJAbNTAi8K/W76I3k5XYPZK6zLioRw17HIXu9Qap396zh1ou8yxQlkL2cbgf7w2/Bh4w/CP/0Th3N1WR5sWBNo7HwcCCXKNXAgTV+KFLv9mAjWiMbOSYm4Tblb6+6o8G8JGJ4zaB+/TjQzHTwKnzzWowAFPBuLa77Ixog/9eEV2TKX85IxAzNMcwnFZ+3zeTDwfifYuHH0gaFiBBS/1vIKlTV4PPpbzBm+B2UbMZOJbcufzxgVtBPPBQMuX2d7HPi1lGpFbjQ4ZdHXwSBhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zhpAJfpAPXrdJKoa4BdszQkSHMW3Ti4W66jte16TQrI=;
 b=NZAPVEd/TzCYq//M3yinHOv1G5Nlf+SDjPe9uFCnBR5cm0QjVf7rEXAP9iYxQsbf18YbOUPVJqtURfLZl0hkHgtMu/tkeMvV5LegUAKuEtV1S54UCcwxjb5s5GS1pkIUijRGSmPIqGF9k10KSRKfObw+IWC7U4P1Pq8TdQnC4Zk=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by MN2PR10MB4255.namprd10.prod.outlook.com (2603:10b6:208:1d2::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.10; Wed, 21 Jan
 2026 16:50:53 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9542.008; Wed, 21 Jan 2026
 16:50:52 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Suren Baghdasaryan <surenb@google.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Pedro Falcato <pfalcato@suse.de>, David Hildenbrand <david@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, shikemeng@huaweicloud.com,
        kasong@tencent.com, nphamcs@gmail.com, bhe@redhat.com,
        baohua@kernel.org, chrisl@kernel.org,
        Matthew Wilcox <willy@infradead.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH v3 04/11] mm/vma: Add limits to unmap_region() for vmas
Date: Wed, 21 Jan 2026 11:49:39 -0500
Message-ID: <20260121164946.2093480-5-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260121164946.2093480-1-Liam.Howlett@oracle.com>
References: <20260121164946.2093480-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT3PR01CA0139.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:83::31) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|MN2PR10MB4255:EE_
X-MS-Office365-Filtering-Correlation-Id: 62c5ef69-511c-44a7-a156-08de590d3d1c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?GuUtLM6cLzy1kEwEvzIxUA+ozCr6MRTtTOvh4U4c8InNRY7uKgNSWOxk+KTo?=
 =?us-ascii?Q?DWr5oKGCBWoAVkIZ95Pi4W5PfOrDV5z093ddlcypMiT3Qp3HgoUaGwYfOlxW?=
 =?us-ascii?Q?MFSI9OA62XRYHnY3FCY7Q69yDnEHbUHDz5XRIcleLhigCtcpmyvflgPgGTX7?=
 =?us-ascii?Q?mVQbP1EC/5l4NiYKGv6aX+zVRlQGXNT6Zx8Cw6DuX2gPQzltY5Ba4coSh0uw?=
 =?us-ascii?Q?kgPZJ00HR7if3SXtCbAqkCPJ1LM8heHhpWF4R/P4biC2SYldLf9YQpyDp1kK?=
 =?us-ascii?Q?rZfaH53JCzF5fzdxvAga9pN4D9VCLkuFkl7Jy4AihyGVoeEIuTwH12dBGgUZ?=
 =?us-ascii?Q?tyBPHCRiPJnzTvN2MgtYBNJIl7bx7alSmasKtNOnE4GuE1CjHMlGcmUHrFDX?=
 =?us-ascii?Q?w62zcl4f1VpjZpXbGZ5ycajVe6xjAzMsekovkvVuv4GXmWQ7ZFC4t/25zn2W?=
 =?us-ascii?Q?ek/OlOjETqj3gf0ntQjf1xPpOSXI4xgrp7MqvSoV9jSWwq+8uUVcalz+OPl5?=
 =?us-ascii?Q?XMsV6Q5S/xxVqkr8RXTHt4uHS/FolxUNOAE3beVja+9cek2wbyOBmMD3J6y3?=
 =?us-ascii?Q?4Ltg+Jjj7V36dhF2KrfApVgCHpxNlWYkFBD99HvkrnkCVYILPAuf/Vm2QVB0?=
 =?us-ascii?Q?i86nvc8e44Zj2yeqYvMaRqLq6dBAefvNPCF6BksJWvcxvx7LM5l7f7PqFj+l?=
 =?us-ascii?Q?2AOGHgT2kiISx2F9jYgwOWp5dwzmmiOj9aW56XIJcoXrB+c7A/vOJiLMWbLn?=
 =?us-ascii?Q?S5kCtbCNkXapVKqCYGsaXB5XZc0g3F8DYIMrJq1kHbzRBl6FYrH15dI/jj5G?=
 =?us-ascii?Q?TH+6PngCuVBeSxuTACTMIvQeJUm66p+SdUty/dezE5wdZW85sCL4YgJyH63E?=
 =?us-ascii?Q?5tjv3qciB6R75yjzPiRaXLhJy89d7VGQOiGSGkcoq5W08T7eN2gB1jDC/K1h?=
 =?us-ascii?Q?dAGPNK7WGjmvT0xmmKmwY8sFw99AUIbgsnN5kL5MVX8vjj4tdSt9F6V5V/nu?=
 =?us-ascii?Q?nx07un4F/rPKAPpDvI53Re/L+7goeDvkgyji5z6UtN23i/uWSgFNLvqHXbas?=
 =?us-ascii?Q?jVocpuYbDPav9gQFrVQKAu41rFFXRR/iMBJxiWKRd5YgpSFeUkUZw7TFhkBa?=
 =?us-ascii?Q?JtLK0GiEIPPqNBkCVVfjl3saRjXBOKzvpSGVfXfnbBKebIQTdW5vzpTgIU21?=
 =?us-ascii?Q?zyCb+sZx2n5Alvu/GNrJ7n8WAxYmp3My80KHF7dPktOFZkbcR323JPzhBETS?=
 =?us-ascii?Q?1xWXCGY92VYDe45ctvj2kcma2uuj0/Ute9bQJmjlP8RNPLVixGlv2rdJz/a1?=
 =?us-ascii?Q?NU8T1jH8J83fJCsvHJGpx1b4s1z+TTcwN63UNSNpNnDZQNj65fT3nU8z+TnJ?=
 =?us-ascii?Q?7IPkaANh3+0bOXeI1iwEnBjoPgSPS5uuW+zjm5WXg6jsTuFqiEWYPQF9lUIj?=
 =?us-ascii?Q?2nCWAVCPnIE/uHt8PgtNIG1Z739S1oi9jxHx61a4/gZXuAQk0yqgJNZdSUCt?=
 =?us-ascii?Q?+/XN32LYu3kZUMiQnyWHBrTQY7pNoLbqKbDmXvazFyAIdA3pyC3etqfD2TAK?=
 =?us-ascii?Q?9pb8X4l29FMmb3VbMak=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ELbHOrgXP0IB8LOyv1RqI6v9ftbLkhom1nuJVUhMT5VM3MnAYXct2eL7mXfH?=
 =?us-ascii?Q?8jJnAYyXSJ2TE/QDwNqVNUHjJNZUSNHa/Kw9mRnKnyc4YFFR83GCFx10aK+X?=
 =?us-ascii?Q?It2sxNFuIpqhubSqRXQlJD/3nnCRkeQJwj4kLU8TKa9kbNkoyiuSsgC+rrbj?=
 =?us-ascii?Q?p3k0HD1JIrOgv1uBJr+GL9rJ2kw6qjQPiD/sRrzfMGcCXHeO0tY2Qxzn6VOr?=
 =?us-ascii?Q?lnC1smq3o6ooErd5ho0814+NluFVah90bibn2wUfp4NTzen7aaN4re2/h8Cd?=
 =?us-ascii?Q?inpyWFRdvyAO6S0qOk3ntAMUsVA47wOYa+lD6hBSWpR2u/q+7T8Xe3YFEhas?=
 =?us-ascii?Q?yt2RgH+CU2f9W7zTzIDfHBEqqtbk1dRJAWALqMZT4aJyZn7iRY6RVfaLyGW8?=
 =?us-ascii?Q?w/BV8myZ5PODymj8QlYcOzWUK7jJ2Y/LXNQ7vaV6zTLSMECOQAEF18NYRyr2?=
 =?us-ascii?Q?CaNVtC9HGZYZGTar7YxypWeut3BIHfcfHDCTXVmdrSWKrK1VuVZ3H4H79NUP?=
 =?us-ascii?Q?Fd6r8j1rgxYSiczaVgJkO+znOMjKTSDAl5wR/1qkl1rvZrM2CVRXQJXXz7qt?=
 =?us-ascii?Q?USp8z4UU+3oakQsjosQ7KmamlHCSW/U3JKExT81/ndc6TwfvECpmyW6LADbZ?=
 =?us-ascii?Q?i06OdUG8qb/xVDfZwbqQ7IrKFySBsxuX1rHNLhmnhbxTrUg+QbO7K6U9u7jq?=
 =?us-ascii?Q?wC5UmY4P1uQIUKwHfg+NALsLlHM4+x0vjvaC5la563u2E1y0asO/a03DqBKW?=
 =?us-ascii?Q?WgkQJu8l9KMf9dAtFQaq/iagvhKRCY3PrxWl/wEbXADKYANAy6rHae7ZjJ15?=
 =?us-ascii?Q?sEa/5SWwIrsgDEaNPEvbQArRVgs1His082cQLhLgz443Cyka+KY02fHMgzeq?=
 =?us-ascii?Q?qzVyXUs13bkE7W3TSZB5tzVb66JvN4H9OUeKWenQhGhznJcBolSBK3H5QwmD?=
 =?us-ascii?Q?jJdZsxoobbHJ6t3x87TKuIr2Bf4/pq6faSjZAEvoy2hDKdIcUuXCRHJBI4bO?=
 =?us-ascii?Q?8oRi5c8ErPpHM+YKxnfGuDhkc9gozmqkZTnmUbaRtwnd8+NeKjot20ItvCdl?=
 =?us-ascii?Q?s8VTDu8hacxvPZLXR1PjsEafEUcn2pv4IsV3vtjrY3lHQLId8uDjp5vUkpCK?=
 =?us-ascii?Q?g9WRKDTOyIFsfnMrL10WVcXF79VcJigMmEDFZHLNxm+d+zDMZopQ6LuJOa24?=
 =?us-ascii?Q?u8gGONJVt8GX+QD6iDygvDJaHBOFaZMvzpFPGvEk5FR8woPrv9rKNveE/Hyf?=
 =?us-ascii?Q?VZo7iD5KxV9cxX/MV1KQTYIFmT4mg6uona7vo/wOsKwmCFHIFDhI5fbG+h0m?=
 =?us-ascii?Q?rsPYmIF1e7lCzYAotLnNOhxVdUTXjwcs5HvI1qX/HRgpFuTcl6f9rP+8nHNP?=
 =?us-ascii?Q?pkQerNEVqDOY+4fOv1TDlZ0h7hgRP1M57ys3bOjaXfgeVEPshDBN0uNNUVeE?=
 =?us-ascii?Q?tRELxQJ8EYXU6B7S67N8w2e4YIuiSrtVWNq0ioC3YsWYQljuvJWpAyseqqyY?=
 =?us-ascii?Q?13FyVD11pBZ7kKUUHvenEau5DIuDSQ1w6nfGbpYO5vpODoSBbpSiAOXHvnJY?=
 =?us-ascii?Q?9J3oEwA0lkcm+nGTOOw2X0SuHmNvGXCIU6UGVQ4QcgfH1qDhEyo0si3Vd8LU?=
 =?us-ascii?Q?u7aU0amvidCsymDWcbhOdZfAWTxkmWf0FQQpJp4CsWvinmdXR5jZAJMhtQkV?=
 =?us-ascii?Q?k1OHeXzlUkoO0jkPbszcP3+9CLb2HW3UtUt2HQ4w17EXaMDBx6bPCk9SFAfQ?=
 =?us-ascii?Q?T5xzC1tGHQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	grcyUcJoCIwkPIc0CUzGKb2FArJjs1foYZcHbqpKLvXW0I20UmijMJozO2zkfaMkJaX5dcqPR/6V2WI7I/LSHgaDtBE5SytsOa6+E//uC3h3aSCxBxYu2RhAS3UaXZ9viDdJOJwptqwNgPdAnYKEBhQHtBjgF0lZAOMzT4Amin06h4KipJkVTeNgzAe6WDZclU0Z3nwCPMBSQglh7gFbjUQeCMxvpT7WoboNsdinCF8DflrHS2G5NJRe8SUNaTA0Kz5lEx5YgTxyh+AGaD4ffGZ45w6TMOjePqOKnRt25oqQOIE8Qanh0u7qbJauzJd9Tvz2v6X76AmIzrok2tQAZg9ojOe0paGKOQxs6fP0sOwB71ong+RhaUiKI8CZ86pWDahMnC2d1phhbvnQNbVS2iH4t5NxnsyAkeq3tD/KmcQIqOzaM1dfFg+q9qbpZnu4cx7zxkORTXaMTRyBGRk/eCRljQd0MtnKv+PS9NpnWMKhuEdUGWhL39QcNJlI2RO5ZhFat0pGFsb1VaaUxs5M0BCb6E854+k1rWq/a5v488ssLquuj3MGFEu+5IHpdZVPXHAMMvz4LlQ+SLRzdcxX32uwfG2CBiDVVB+f8djVmk0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62c5ef69-511c-44a7-a156-08de590d3d1c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 16:50:52.8853
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o/uG9CadIEynXtM0djWOsUmvWkKZsYO0F8PKkacm/reUPs3X+0Ru4SW7lbulGxKs45HSL729tHoEez0yg6DFjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4255
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-21_02,2026-01-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=776 mlxscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601210142
X-Proofpoint-ORIG-GUID: i7Z6eZxwjpl3q8BhealFkKx-f7AZNHXN
X-Authority-Analysis: v=2.4 cv=IsYTsb/g c=1 sm=1 tr=0 ts=697103f0 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8
 a=1XWaLZrsAAAA:8 a=q4Kie02juo130yM_dUcA:9 cc=ntf awl=host:12103
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIxMDE0MiBTYWx0ZWRfX6zC/9QifV7+l
 CQctjnuAzoyL2vGv8Zu+5GlbFYfi9NzM6wpyhyX/3N/MiBO6Ldikv01M5gA3ccJOs0mF61Efm4Q
 pmGrtq9TcHiSr+q2LdjjTL4yqxx4V0NRSIkeh9NCqPwR//Fb5GEE8vjVdcnYJBO+ijb2gr9GcnI
 ikoviJ/5ZHzTZ+MuCq1GX578uS2El0tfc4jrZDNZnf5hlD6AMrXj6jL5r2TETndt9nx6nQiQ4Vo
 A1o6n3hQidUJauv8vqsw2R7yTjoKgz6o6X1rHN3e6OGnH9NBYFmgxBFEJQZeGVCSliX+IMQT3k2
 ZoyKVXoS6njhfYlxXRcwK2ZHbAGIGC/xHqtUQHFufD69nHjiIJIjBOzCNryDC9pOM+gThqrriKW
 uhYLHDBENE65QkcC9QQ4cvhcQHNeYEXiYy9KB/rveG+F501RHHhhcRJO7EaI49VYs+uVtiWCrI3
 prhaX5J/G4ekSDXW8n18QXT+cRyXZsgLcTnlywQM=
X-Proofpoint-GUID: i7Z6eZxwjpl3q8BhealFkKx-f7AZNHXN
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 44A7B120009
X-Stat-Signature: sfeoocj13sw3mi7aprqnqhoakuye5tio
X-HE-Tag: 1769014572-32682
X-HE-Meta: U2FsdGVkX1/nGXjc6evHx8yW8d5im1aLALoM1UsOFTD9sl6OWldG90Nv4qXGEIfMzN/e14EHrmwfGdkURnsABuVWREWdJ/RgQcZfMCTN89Pxes92KiXKBmsZftiS1VxEJ2jwWgVWOxArmdRBvDj2RUiJKt5vwNNTunkb3yfp6bk50gq+9NA667dnpZoPzO9E2oXqANjCIMBHp2uE4lOw8wBvbTJp5LQCWxYcEMzpW9icZqs/NPXSM+va2H90GECPpefuG108thQWXv7FY2tdA0wRxM+74MpEVqUSEo4QyLgtgJV/1IUfmvjPLPaRozXDb/qgjF91wLU719MYNElpt3v2Fd+AofmvVG1Xzo2HRRVH61tTy4wg5qeNHzA4ZlOCX1Yk3k9ejKrgK1rtJUF5IlvT1A7rj9ncDfGmHPpEbJScZPfFZ/3GOAwpez6HCN3NmkdKhWwE+ipaovxhRGSl0RfuhD27VyhtxdpZU6QXhOSqoe6rZEXBFqvXoeEsbz+7AUQghEAnfRyM9niV1I9JSq6T4JCuTK4aZdWxQYopmUsNxHKneVLZVJa4XNRAQsqK/gSnEkZgYVJU5n6TyilT+Nus6QLOEi4u4nce1bEz6X7O92fpA7LsIk4749/Az+0R8zGX/V1eDn4XYJU6i+hy3fjSr5xTZw9bHU/Dvr3DHv17xa3u8mz7Cl18IOpqzPS1IV3FTs9qHzZzXIXFialkiF3NWqdNTsabq7XY6/5QVZY2bdYKPMD7yG1ZbD+tv8LrGZixqBmXH2tGR6LoFM7witjjrD/3jv5ZCtgTd9K8lhUgDzRwwbU3niqUu5vvVze4KxZddMc6CyXiL+G88NSleW5b8BNZd/AmwsSThLcpq9Z4c4msTrrlSamTRPbR7JlEuowuqPxpt2LC4cwyTzDO4ccQMwkGH2OZAsq7bW8yec/jpbmEIKzk4HXbgrEfiyxSCi28CBJ0UNlD3OzbyUa
 d8YOAug7
 kC8EVqJa5FQKUCwoOlFWXFGGza70H83S5eDksXeSdfIBU1E6uGR2uh0jSRzICvQ0RKTsy8eCFI2TVNOo0Zh3gRXiFAJp+wb0Dc0PuxzmpAhrCjh17m/45n4e38ZfeE+B/mHra8Qdn85wR7amsRkqBdjyW6fFYZ8c7/IjzBcZQDoMaw+pPAf5qSyW1ZFg3lRqgg3v8WCKg4dfq+ljJDBn/UV70O9M3d5zfjayZBk55TukifGoqzhd4dT2AMNVmKmJzZqilpeSchzA/zhezULEy1JhjZk2YqC9ZUtCBhDwEdCTXqWW5rZz/BNOIjdMf70UrJp4i9DL2UK5CmZWkx3pZHGNRNa2UAIwbYLRd+Pk9pwNFBdeSIbc0GtJAqxjBBML485WUUhw7Sop05sBZk0eZ7ROouM/XZGGcpS5QZo5XBi6TvRcyOzfr0ZUJ072t8BA69PR1lCnhUsTZEFD3iJE8A8n5uKceUnPF0RKGPCB3PL6rvwzsdK27bLIkG6iUzuUbPgM2edctLX5m6MJjUxbXEXlShrVM/aiT+0ZhUL2XhTNi315Lz3OJpLLroLSI71opMF0vmjNC5l+le+8j+vS5XSzQHZflHWySnhRZjqZeQzZ6yKpsOXiFMZ07sqkzMKiW33QTgWqsvAEUL7QzxJ1appXOPhvRQ+WAtsMg7YztQYunrGaBZyHVqKCrHKwlHDbZYIv65kElHetov3ejfy2nZnwcIfXduXZ4B9wtVVGhFO8bcTnrea0nQLJrPS5xWQXm7AOdNJlEHpuNL+k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a limit to the vma search instead of using the start and end of the
one passed in.

No functional changes intended.

Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 mm/vma.c | 6 ++++--
 mm/vma.h | 1 +
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/vma.c b/mm/vma.c
index 3dbe414eff894..0c35cdc0d3b7b 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -473,6 +473,7 @@ void remove_vma(struct vm_area_struct *vma)
  * Called with the mm semaphore held.
  */
 void unmap_region(struct ma_state *mas, struct vm_area_struct *vma,
+		unsigned long vma_start, unsigned long vma_end,
 		struct vm_area_struct *prev, struct vm_area_struct *next)
 {
 	struct mm_struct *mm = vma->vm_mm;
@@ -480,7 +481,7 @@ void unmap_region(struct ma_state *mas, struct vm_area_struct *vma,
 
 	tlb_gather_mmu(&tlb, mm);
 	update_hiwater_rss(mm);
-	unmap_vmas(&tlb, mas, vma, vma->vm_start, vma->vm_end, vma->vm_end);
+	unmap_vmas(&tlb, mas, vma, vma_start, vma_end, vma_end);
 	mas_set(mas, vma->vm_end);
 	free_pgtables(&tlb, mas, vma, prev ? prev->vm_end : FIRST_USER_ADDRESS,
 		      next ? next->vm_start : USER_PGTABLES_CEILING,
@@ -2466,7 +2467,8 @@ static int __mmap_new_file_vma(struct mmap_state *map,
 
 		vma_iter_set(vmi, vma->vm_end);
 		/* Undo any partial mapping done by a device driver. */
-		unmap_region(&vmi->mas, vma, map->prev, map->next);
+		unmap_region(&vmi->mas, vma, vma->vm_start, vma->vm_end,
+			     map->prev, map->next);
 
 		return error;
 	}
diff --git a/mm/vma.h b/mm/vma.h
index d51efd9da113f..e671adced3a03 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -264,6 +264,7 @@ int do_vmi_munmap(struct vma_iterator *vmi, struct mm_struct *mm,
 void remove_vma(struct vm_area_struct *vma);
 
 void unmap_region(struct ma_state *mas, struct vm_area_struct *vma,
+		unsigned long vma_start, unsigned long vma_end,
 		struct vm_area_struct *prev, struct vm_area_struct *next);
 
 /**
-- 
2.47.3


