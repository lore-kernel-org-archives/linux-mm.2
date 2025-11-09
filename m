Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63900CCFA1E
	for <linux-mm@archiver.kernel.org>; Sun,  9 Nov 2025 11:16:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC1FB8E0012; Sun,  9 Nov 2025 06:16:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9B2F8E000C; Sun,  9 Nov 2025 06:16:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C5898E0012; Sun,  9 Nov 2025 06:16:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 60A7E8E000C
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 06:16:38 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 08D59160912
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 11:16:38 +0000 (UTC)
X-FDA: 84090815676.08.9C3E420
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf17.hostedemail.com (Postfix) with ESMTP id 93A844000D
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 11:16:34 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=dOb1Acyj;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=APeD3YWS;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762686994; a=rsa-sha256;
	cv=pass;
	b=m5D17jKaghJUW+RJsfR3NnohMcKQaiFYyvkyp/u4i0mo6/8myeS1PHxgpmVgiOw/r2uT0T
	/181VOkiFJ/0SO9sWSKPbAC0QDyN4DEAUr5Wd/gAQf1BJgve0/c7o+8ayX/CJTPma3Y24B
	C2uv4e3rr/xKbizNOcjHqLkt5++Juy8=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=dOb1Acyj;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=APeD3YWS;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762686994;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5/1uDiVMCHo5gUj0IjNrrQ9S1x+HUJUrTLxagpQs0w8=;
	b=vLlL+gvhsXZ2kfUKxUR/sV9fzbWeaemrAUx1dzCZuGkhsEzSO7IW80Bglt3Yj9crl0xb+O
	4CxHUggVNM+f5W8qNLFJsdOcULzGJeJ32FY4NOlHAnzlC4qgvIjdu/Ht+w3F7So+rCok6n
	G87/RrsCWSjBJLVKYN4V1yMsoADjsBE=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A9B02Vg022883;
	Sun, 9 Nov 2025 11:16:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=5/1uDiVMCHo5gUj0IjNrrQ9S1x+HUJUrTLxagpQs0w8=; b=
	dOb1AcyjFDIUX9yrYQrZA2TwQucakwA4hCpUKgRXWtPViElV3MN3KYiswhA34KoH
	IkTYJ2fdosD9jABpwbllfQnnZczdr3LwTnIBfbGXx1jENItUTnkbgnI7OFQJZVCD
	s9E5ewOAD8XX1H4LwqGqHWGCxlIsis6sURUeoqBR0+YHNxf0su0sh25wDnRg53Kh
	NEdtrGgDoX6ZxmSKgDlYepI25HlGe2XjvOSF/7lnWn6G6WuuhT60HRg7bybgC6ZR
	QLRd3zXVAtFC51qKnBBHB04aXnHloscDXzVxk3VqRhicgbHivTWunSmguW918gsG
	5CHt1duYkBkmAbHdKY3mbQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aaspt808v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 09 Nov 2025 11:16:23 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A9AacEX012715;
	Sun, 9 Nov 2025 11:16:21 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013034.outbound.protection.outlook.com [40.93.196.34])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a9vaap69p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 09 Nov 2025 11:16:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ncbNbQLAaQqh1wrSFthHvy8wd5TAqa6i/tN9POjgMaob8tRELqCd0rT6aXGde24pSy9Mutpzq+9lIcSmBrgn03C3u5R7UADvlnkg8UWH4NnqV5V3+AcIXUp3h3KXHnEDHp7/GJzTR0e0PJ2P/GFTO+URt6NQUw1zyWWdtSmi+4piQrolUhSLzE4PG7aHJAmLiMmKt6ExJs/18QmHYCO/18mMYcMP9OKUD4b8uIuXXy2JLzD2Z0W+AOKi4yYDd857D3W/kVemRBRBQ+zCisf/iw42UeKpc8EACQc5gubDYofClZp2/h7Yir/88yfm1LPE3N8Ur9P7Xy0ttgwcCAk0Lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5/1uDiVMCHo5gUj0IjNrrQ9S1x+HUJUrTLxagpQs0w8=;
 b=nmQrTFqaq3QoJffVSWt/jL9wS+2aS47Rxbqz7iZfrIUT63+NdqLRKoKiyn3ClQJwnh/vZa1ks6ZdBSFBl2ygmPL4upROuT5Yi8p+tYlicp7S6QaJ+uUcjT85hePfO9Kj6JO+Xh/9yxekCMERp/mKLCdhmD0bsvROZwZzH7ZPiZgYmY5ivZ8OFzCniMZONi0OUY6UGuzJAk2JIVksie9X7FXdB/m9E4UDwP3Zj05LXW1y4aOGgvcr96goj9rigJEK6zf4lQklumY/1gLwZYjH9FPrlShJ49Y6WzVxbrJdfYQ3jpcaWCSik2j3mse/H/9xH6rk899dPcTpZUxrFhtPAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5/1uDiVMCHo5gUj0IjNrrQ9S1x+HUJUrTLxagpQs0w8=;
 b=APeD3YWScAFmHSn8UAC2Fz8rpAu8rbWmMvGwHllSqQTd6tfEdfofti8KK0OUZUL8JgAfvPtSusF15l5Gq6GH8ZTGNIIhDtIQeRKVuRDhHTF1movyPOy/noYRN4hVPY9lK/6YBJxh7t6QLy2rIOegEtrs+Cd8+Ix0gskst9zNRy0=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DS7PR10MB5197.namprd10.prod.outlook.com (2603:10b6:5:3ab::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Sun, 9 Nov
 2025 11:16:18 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9298.010; Sun, 9 Nov 2025
 11:16:18 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] mm/madvise: allow guard page install/remove under VMA lock
Date: Sun,  9 Nov 2025 11:16:07 +0000
Message-ID: <d246c206e2df45cf15ccfeb33124809dafbe1eba.1762686301.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1762686301.git.lorenzo.stoakes@oracle.com>
References: <cover.1762686301.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0035.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:151::22) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DS7PR10MB5197:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f058af3-1698-4159-339b-08de1f8167cb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?R1zJHumE29kGRiWRejW3csp8oVN1a+BmsQ856+OAUN3gNkzuzbzpdq9Tx4yf?=
 =?us-ascii?Q?N9K38ftIb7YpeNZjlizB6AYl60j4B8Ir2y4sVtu7fY0iyiTiwOehz2lua/DY?=
 =?us-ascii?Q?aE61K2J76ikBtfuNshg/OjCjMZqdfimeC1VTY6omiJS9lkKbiT9dh/OQQpT9?=
 =?us-ascii?Q?J+cr83dzKYlSQ04JqAp8ec2YJtuWqvJkRllp63YRQxALmpAybavYqKoE3rgV?=
 =?us-ascii?Q?5z7EddO0sj8Ov2INXIwdSaMJB8djRptQrYrkb1n++hfPzO55O5ZWxU//UES3?=
 =?us-ascii?Q?jm+zD3277uoAfwJRMl2EtvAyZcahnOe2ZsgWMZpLeyD+z5Khg1/X9xDigXpm?=
 =?us-ascii?Q?w+FtJpyFOYTwVjQijUNBblFoI6MuE/qAD877fBD06VgMSoass/Fst8OTXGUn?=
 =?us-ascii?Q?gckCP73lWpqcyBWqOHRcOL7yGinhsiaqECqh8nsQf+tQfSxS43iB8oP9/Oxj?=
 =?us-ascii?Q?Js3Ugi1189KbWqJijwd5abvqAGBHKUwYJSHogEgYwgt/djJdRqRbHuj3pjjz?=
 =?us-ascii?Q?1Lo+thLGd0j6pq0LbgcPbAfueb67d03JuFpmW/o5fWZ7yV5VIQXraS0hgJRe?=
 =?us-ascii?Q?Hei6NbS0lBx434wGGUNeHW5fR5jSXcZTkKiyCEKuNEBwV0Wrq4dFRv8NnTRy?=
 =?us-ascii?Q?v2haNF4c5wuW3hJQJbtNMAKez4VDPit0zXCMYDERKfnf/u+u8Z05K+B3s3/3?=
 =?us-ascii?Q?JT//A9DUOeSeV9LkxQ4VSnot3B1kAC7l4FPhn6I9T0aDCjyf1gJizZI4hH5S?=
 =?us-ascii?Q?n33KvxUeb9XE/ei7UxT+jDuSZzlVSXTMnQhX/C8YAks5u3d4WwNtMII/zmr3?=
 =?us-ascii?Q?PKJgGd3/gg7kPuwzfAuFjEz57odcIuAk+o4+rhGrrnEvEerCWn8lmZGUQETx?=
 =?us-ascii?Q?eLClHh37XANxpMIoThGA2avY24kEX3gOF8og328ptBTLF3bI2QL/KSqfRfEI?=
 =?us-ascii?Q?qgoUVdi3mgj8bp7ipbATUdPv9Bl7+8SkCMSzHXoY3BUS/2vd03b/rVhR9faL?=
 =?us-ascii?Q?ThkbztSthrvFZgtmojoI4PC7t339BpG3qBm7fNuTtIrPNt8L0rtg5FhumcVK?=
 =?us-ascii?Q?bbxCK4e97wsqbPJczcvP1WEhvGg5taeyzLECfmrJt69Rs17heoAvOdocibyx?=
 =?us-ascii?Q?tbZ98ovZ6PqU91ApEiL+GVQZRzjszmiqJIhU11qg9JLkjPr3pqMYoQjNIOvD?=
 =?us-ascii?Q?jNZHPgJblUk8HZ5kv/I2JZvxF944+MliulIZkVzX4PVoCGLqR/6tnyMOFsj+?=
 =?us-ascii?Q?yPsl7BKvwPi9IvbU3RgolKCevEzCzOmIagqfpYl17wjH11lPoIAegc9ZY8uI?=
 =?us-ascii?Q?6LAq1TFD+fjvYjt60/ThwH99LbtCmMwkKaQrqkXRZNSAAJXgc3MPZ7nsOaID?=
 =?us-ascii?Q?QsjLOVd1y3yP280JBYrkZjjuI6NE6d/8q4Abtu6nZGXpt1FBOH6LQFq7miz3?=
 =?us-ascii?Q?kPhxX8vrXI+L2CeNmZg3QvSFArLyTFVN?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ewppgwDwHloswvMGkxe9AEw1/O5Yys+nKaNsn6DTxX9uC5NkXi3oBkQHnbcv?=
 =?us-ascii?Q?BDI8bV2i2rSkfM//SARSEVh4jQpSGtut1HTQYtJBQE0LodEb6MgdE+yq3cdx?=
 =?us-ascii?Q?DgB9OP23VmOW0kxQ6I1IrSNYT9YxM3ycQE1WtME0W9FdIIcaiazX+U7jwiPB?=
 =?us-ascii?Q?eYC6qhsGtuZtP2aJDh9jMtCKPfKb66pxZt9FflMtGPSSb1iJ6Lw0UcxIKsQg?=
 =?us-ascii?Q?1q5Yk2+eBVL51f0xPtnfAwzYlEmT/+9GihZLXFIbNilKca7yodO4Lyg3Hn41?=
 =?us-ascii?Q?/I+Wcsbs9MXs6UjY+G9lIIfs8ngFoRC+M4UH+BOuGZvEtmqIISDYgoDB37c1?=
 =?us-ascii?Q?SpOTXGTTy9AlVnXVEL49wcL0w43ul7ZGWMiiE0m7OfsholEHB7JtnI/OZQDs?=
 =?us-ascii?Q?/Oz5QcUoaAd8x2ICCh59PiTyCt6GIAteXd+Sv1z9n1+n/7afadwnVM6Px7x4?=
 =?us-ascii?Q?cBPm5y/BAQ2oT8Qkme4AoPy53udu6LxCmQYrGwddwBzcDDsI0kk6g15Rulmr?=
 =?us-ascii?Q?E4MartnwzEJyoqqtS6a48V2TZTqW3xN+G0q8b4PGLzt0WDzVi4tPY6SM+N2p?=
 =?us-ascii?Q?Op7+crqSIvpVMqRIj1SOgre+u7zEwrSvdsMivmt5Z0k2j2t8gtGadTPYSSQ0?=
 =?us-ascii?Q?SAzJeT2RbfkHdzHetVubmyXqPBsnXXLiXvgdJsK2pXTILnp0A4J9QWWkgz4F?=
 =?us-ascii?Q?/0nhVY/1ntoFA0t8gclbC7uOQDfS+B7vDZEQx1VjWLYPLpHi8Inw26+Mbfqg?=
 =?us-ascii?Q?NlL8vxXkGtt+cZyWyix3Q59zgqXJMmpB1ZvRhJYed7hjZLqEGeS7YR37gHVl?=
 =?us-ascii?Q?iGPA8CUt6MEec2ypahBCpKFhEdzK7guHa9tBrqLqL4PXSgOY6fqlB+Sf+2FI?=
 =?us-ascii?Q?8hhs/n2DEqQHI36iVMyqJLe8UgA7fxASvK1wFbxNihAHf0t9X2e43wN6bUex?=
 =?us-ascii?Q?a8RiNRlFsod+ZXlQ58gooTW7dFi4rjVi0AN+WwQ5DeNnq6foZrDrHCrpGfe9?=
 =?us-ascii?Q?BDdP1+TuxfnSeanr59+hYrwPtKyF3nSRibqT+SoX7Is+In6jGz8jaI8bDnI7?=
 =?us-ascii?Q?bhwaedFihK+UNCr9JpWlrUx3O/EITE/J5pvYZ+Y6HlL+g3wnGhN7lNO9GUqf?=
 =?us-ascii?Q?i8FhWec6o9zvmkmLCrG/3b4OiX5EUgJyyHQHrqkpZsM4ga5pNqwxN7xJ1ZPj?=
 =?us-ascii?Q?zdI63HF4UIwJqu8f125+6UKFE/i+rMRfcNU3eNigMFUypW47iF/y+ibErs7R?=
 =?us-ascii?Q?8VXqi/0Ydx6UsLfD2kQ3P5p/brDmPuIi5atselsIxV+FM2ensiULQSWQyvMV?=
 =?us-ascii?Q?KX2IgvEqm/U3mLR0aPVVtHbOM+QADtILftRr3Vw6lI+psrhoygFhPm+u7tym?=
 =?us-ascii?Q?xd6/gAapQ8aeLSvfDZjlJipEp7JeqWu0Coz45gY9P4DK+rtNfK8w5ifCTZUc?=
 =?us-ascii?Q?dutgQrIsLzco/fKIsc7mX0AVRmVqYF9MpjDcMKKgKUo7v2yeiKxQHNDqQosi?=
 =?us-ascii?Q?ZAnNjpPDnLK+3lCAPuZxmBKbcxXHLsevMBvAvj6mtS6en7uR95LYw13h9YlG?=
 =?us-ascii?Q?AXE8bdyTlP53/GNs8rmZekT2uGuiVkC5NFpbeTqZvplCijNOFp7mz/haozn9?=
 =?us-ascii?Q?pg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Vliyk/Uz6I0qBaZyUMUkj57BJp7Bk6RItlvKBkq1dLz/HGxRbkAOo32idYY/Iz6CqGZRyB2TSu759Tj/9UbB6YvFHkFg/w4mMg1uM+b1gxFo9iNaGmwbiExlIaH/mJc4M8DNyCe8m6Dxe9b0qgAGKo8UCkRccrAdaPIxkCD1IkA0x1qGacR/pZJhuuzi42I6pWfTQKZ8GbjcYLVrxCaBAmBSmOINDEfJgY9YfCOrtBT/pmkQ681xE3LIncbJbYgYHyK6fn8IL4+VH8k3PnJKLWJ+MrC/exp8nN3yJDxZXvG/JlYodLl9o5Y9NOkhtrPoksO7nHpFKs2JfPoLSm/2FnNST+t2SlE3hk9bsre2+xGWbujHi8VDlSMc7BqxcyEnbeVHBJSFgLbBKg8sUKqkTeMm2UYJ4Fh1qG9GTEso4/Ly/GpPc9FMkHMmGdnHl+meoGX2tIc4ichn4j8ohV+8ngeONlpgGrD2oiYogGqwa0eq7GgC+bUbNnhNLEs56fR7BXlW/vTXLh3+OqT7OTMfh70AIQ7Vho9dyxc64zfrvcCN35MlyhDDokLVLxSkD65w1E+cI9gEhPgukIn1cnYvQG9JLLfwcnZJ1D2iMmEN5ZY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f058af3-1698-4159-339b-08de1f8167cb
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2025 11:16:18.7357
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KDQx8Wfk2Y65YXAks8ZVabl8fXEPcc4A5TO7VrUmm4+yAjgYPq4oXnXJGYWpjd+LIbJiO3rRMcmXjdR8BZGBjlW1qdXRLW2o925CCeoRUVg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5197
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-09_05,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 phishscore=0 suspectscore=0 adultscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511090099
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA5MDA5NyBTYWx0ZWRfX3XKO+xOAARvK
 IH1qHrcndYJ+tK08/wmSLxi4JNKsSgJsBbh+/PncNb0Qbq+CMa+qohhkUzqdH/gcWcD7eJGWDGE
 EWSPC0ssQEwDJuutHU2dvIOLq9O69l2f1f9h4Qa6BkR0gMTK33Br3dyqTS4a3V0vmblEGGflQeY
 +6KIGlek/9Q8uhEIHcMN65r+evr1OZ1/cPqX6hMB8tbRPICjexpGgBD2vfN8sJ2vOUYI6qyDzEf
 i8s4qtI8DEoYuPebwml6NC3Yxw0edZbcu5C4/vRmXPHXQxsxqN6rpAtXKVA2yrPOWoltpz9MVAG
 9q3bDJbfSKmRWBnVO2+PQPl/UHtVz3H9WXs9rC+EqzoTvDMvg1OFc6xUp5J+piSAZm+4Hqi4UaC
 iSI10EK66GB/BAHtWiuMsrweS23flNHNUMsAeDNCyTrYqLVAm7c=
X-Proofpoint-ORIG-GUID: ZW1TbjWfMlxklxYm_C4aWW0038eAnqJd
X-Authority-Analysis: v=2.4 cv=FpIIPmrq c=1 sm=1 tr=0 ts=69107807 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=Wu5hNObr_TVTc6B2G3wA:9 cc=ntf awl=host:12096
X-Proofpoint-GUID: ZW1TbjWfMlxklxYm_C4aWW0038eAnqJd
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 93A844000D
X-Stat-Signature: yubzfwxhtcpn3eeugm18f8hepjtku5so
X-HE-Tag: 1762686994-625181
X-HE-Meta: U2FsdGVkX19YrfL38eP1XiG2ml7prPytTxsKpKIn9eH54UerGLs7tDCuw2i0xCBseMTk6bXrN8QNdAI6Qgr2eMfZHMshjZErp+DZPW/I4LAxJ9aPGuC5Dfog3rL/L22kbzC63SQfOv+MmDJAbjDumu01Xx9aEnhPzAhiOZHrDSdDiaJ4grc9Blzo+sBVZQkcSnzZSwCeB4r4i8bF5W2u/G+6dRIyLDzGp8wESYO5C8wNvt+Cy2dQHY92Ml79P0wLwfzdE/U3i3sM5OOYUm6HrSw6mNa/7nfWdZ20WlxSeUGfsePxgbt8j0EpvKcWRmeOuZmUJynjnlwlSt5srJ+GBZ/s6/hERDIH/K6lAnn9MLSFykf/qY6JpCgh8/28F1C14ii+pLOFo075slCDAnfbv5Yj7VkDuJhrCks9EjWX9fCfZoXEbHvUr8SV1ZRnCeYLEy+7cL/ykJlIUPQGe/nf++hEWcow3/Y7bakBmXkI4uYpvsjvkfj+eQrTDXXoRyFOttNKhytZ8fBD2IgSQIN6pgIicF5sdRDENmGONxBd3deNeJeBODe5KJEUPBtMtaCeKM8W+cpN7Z0qyVQb0NyyNyh+cB/GhcZqMiiq2jxNGEoXZOt/v6ULrRMCUqk/HJF1eVSEl1/LFtkdZBivIuUsLM9pkcoK05pr9gL9Eiw/qd4wCDuIGG1AMA9Ap3AXmD35gL5qgfDFY5x45u+31gY01mnUg+aMgqaxhcmVF69dnQ9BdU89BbiF7elTtA1DPx6/P8Rc1vyM5CpdVD/wtqXZ3GQwjoD/RhAhZCBY6dLyZeqdJMcSQFUNM8ck6tdPd5nqLieEFfoNeSMHgC6Vfv0yQPEZbdWdI+iphIF7/3h5O96XuM8dqCodgGz4337ed3Q561KZy6Wh8j7npVPaGCSUCXl5WjX8AjhwBYhtGRJ9psygYNJwZoXFn9OdOiRrRzjVLLRAq761O0nkp3ztfzd
 IRb+0c/8
 q/5Okg53a0accgmohsV4a0dYaVmdz2DV3Uz5wCf1JoJl6amQqUE1bI3a1fpjce/jQkbXSQ6a6bOhq+AOzie3CnCDmx7kKGTMJSdVigX/hgzMRzcQtdIIo3eTmUC9roANzKUKckfYOkPaNaWLN2ESJp6Y+Uv/yH5+bLdeErcq+f5BXKbluEqgwRP7ZxIfBnduP0UMMypRrUq4L29unvebgg6PVOiMFlQdJ1L7Qz89egkUIMoy5rdnrnP5teOtLvCHqz5yDU4Av9sGQmW8izxbPo1U97NHJHWLg4sJB6i8pINqspW6M6sOBmusqefcSL38mvb0b3x2gG3Ky5M2U7FJQv+hPwJH6BkxSGMv6hFzllogjZGgWa3Tzk+uZmIpE+exf8rEjrijiSQKFDGwURgZtWvhiGNC4CLH+FDAi+S0CMPJ88ZYmxZgNEcUSXK71dLVdca39tVvP0kyLmtlpVVMcE5u1+KdWTgPpA3LU0RRO4V/XdXrRf09ymyjQIqKakhN+ABiy6t75C1j5A5UvALDVjvTA/Ubi2V4vKnL5DZtm7iLzuHJYGiGyq5WMu4Qc+NbrET6SzDQAtxDMh1g66MfS7Bf8SVABDGbc5NA4z5lmelFgjwAQkb6kkkuM2bBp2qt2E57VYwUaEpuevWk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We only need to keep the page table stable so we can perform this operation
under the VMA lock. PTE installation is stabilised via the PTE lock.

One caveat is that, if we prepare vma->anon_vma we must hold the mmap read
lock. We can account for this by adapting the VMA locking logic to
explicitly check for this case and prevent a VMA lock from being acquired
should it be the case.

This check is safe, as while we might be raced on anon_vma installation,
this would simply make the check conservative, there's no way for us to see
an anon_vma and then for it to be cleared, as doing so requires the
mmap/VMA write lock.

We abstract the VMA lock validity logic to is_vma_lock_valid() for this
purpose, and add prepares_anon_vma() to abstract the anon_vma logic.

In order to do this we need to have a way of installing page tables
explicitly for an identified VMA, so we export walk_page_range_vma() in an
unsafe variant - walk_page_range_vma_unsafe() and use this should the VMA
read lock be taken.

We additionally update the comments in madvise_guard_install() to more
accurately reflect the cases in which the logic may be reattempted,
specifically THP huge pages being present.

Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 mm/internal.h |   3 ++
 mm/madvise.c  | 110 ++++++++++++++++++++++++++++++++++++--------------
 mm/pagewalk.c |  17 +++++---
 3 files changed, 94 insertions(+), 36 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 479234b39394..3702fe4a4bac 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1655,6 +1655,9 @@ static inline void accept_page(struct page *page)
 int walk_page_range_mm_unsafe(struct mm_struct *mm, unsigned long start,
 		unsigned long end, const struct mm_walk_ops *ops,
 		void *private);
+int walk_page_range_vma_unsafe(struct vm_area_struct *vma, unsigned long start,
+		unsigned long end, const struct mm_walk_ops *ops,
+		void *private);
 int walk_page_range_debug(struct mm_struct *mm, unsigned long start,
 			  unsigned long end, const struct mm_walk_ops *ops,
 			  pgd_t *pgd, void *private);
diff --git a/mm/madvise.c b/mm/madvise.c
index 7b938ff44be2..ca369f22d28f 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -1120,18 +1120,17 @@ static int guard_install_set_pte(unsigned long addr, unsigned long next,
 	return 0;
 }

-static const struct mm_walk_ops guard_install_walk_ops = {
-	.pud_entry		= guard_install_pud_entry,
-	.pmd_entry		= guard_install_pmd_entry,
-	.pte_entry		= guard_install_pte_entry,
-	.install_pte		= guard_install_set_pte,
-	.walk_lock		= PGWALK_RDLOCK,
-};
-
 static long madvise_guard_install(struct madvise_behavior *madv_behavior)
 {
 	struct vm_area_struct *vma = madv_behavior->vma;
 	struct madvise_behavior_range *range = &madv_behavior->range;
+	struct mm_walk_ops walk_ops = {
+		.pud_entry	= guard_install_pud_entry,
+		.pmd_entry	= guard_install_pmd_entry,
+		.pte_entry	= guard_install_pte_entry,
+		.install_pte	= guard_install_set_pte,
+		.walk_lock	= get_walk_lock(madv_behavior->lock_mode),
+	};
 	long err;
 	int i;

@@ -1148,8 +1147,14 @@ static long madvise_guard_install(struct madvise_behavior *madv_behavior)
 	/*
 	 * If anonymous and we are establishing page tables the VMA ought to
 	 * have an anon_vma associated with it.
+	 *
+	 * We will hold an mmap read lock if this is necessary, this is checked
+	 * as part of the VMA lock logic.
 	 */
 	if (vma_is_anonymous(vma)) {
+		VM_WARN_ON_ONCE(!vma->anon_vma &&
+				madv_behavior->lock_mode != MADVISE_MMAP_READ_LOCK);
+
 		err = anon_vma_prepare(vma);
 		if (err)
 			return err;
@@ -1157,12 +1162,14 @@ static long madvise_guard_install(struct madvise_behavior *madv_behavior)

 	/*
 	 * Optimistically try to install the guard marker pages first. If any
-	 * non-guard pages are encountered, give up and zap the range before
-	 * trying again.
+	 * non-guard pages or THP huge pages are encountered, give up and zap
+	 * the range before trying again.
 	 *
 	 * We try a few times before giving up and releasing back to userland to
-	 * loop around, releasing locks in the process to avoid contention. This
-	 * would only happen if there was a great many racing page faults.
+	 * loop around, releasing locks in the process to avoid contention.
+	 *
+	 * This would only happen due to races with e.g. page faults or
+	 * khugepaged.
 	 *
 	 * In most cases we should simply install the guard markers immediately
 	 * with no zap or looping.
@@ -1171,8 +1178,13 @@ static long madvise_guard_install(struct madvise_behavior *madv_behavior)
 		unsigned long nr_pages = 0;

 		/* Returns < 0 on error, == 0 if success, > 0 if zap needed. */
-		err = walk_page_range_mm_unsafe(vma->vm_mm, range->start,
-				range->end, &guard_install_walk_ops, &nr_pages);
+		if (madv_behavior->lock_mode == MADVISE_VMA_READ_LOCK)
+			err = walk_page_range_vma_unsafe(madv_behavior->vma,
+					range->start, range->end, &walk_ops,
+					&nr_pages);
+		else
+			err = walk_page_range_mm_unsafe(vma->vm_mm, range->start,
+					range->end, &walk_ops, &nr_pages);
 		if (err < 0)
 			return err;

@@ -1193,8 +1205,7 @@ static long madvise_guard_install(struct madvise_behavior *madv_behavior)
 	}

 	/*
-	 * We were unable to install the guard pages due to being raced by page
-	 * faults. This should not happen ordinarily. We return to userspace and
+	 * We were unable to install the guard pages, return to userspace and
 	 * immediately retry, relieving lock contention.
 	 */
 	return restart_syscall();
@@ -1238,17 +1249,16 @@ static int guard_remove_pte_entry(pte_t *pte, unsigned long addr,
 	return 0;
 }

-static const struct mm_walk_ops guard_remove_walk_ops = {
-	.pud_entry		= guard_remove_pud_entry,
-	.pmd_entry		= guard_remove_pmd_entry,
-	.pte_entry		= guard_remove_pte_entry,
-	.walk_lock		= PGWALK_RDLOCK,
-};
-
 static long madvise_guard_remove(struct madvise_behavior *madv_behavior)
 {
 	struct vm_area_struct *vma = madv_behavior->vma;
 	struct madvise_behavior_range *range = &madv_behavior->range;
+	struct mm_walk_ops wallk_ops = {
+		.pud_entry = guard_remove_pud_entry,
+		.pmd_entry = guard_remove_pmd_entry,
+		.pte_entry = guard_remove_pte_entry,
+		.walk_lock = get_walk_lock(madv_behavior->lock_mode),
+	};

 	/*
 	 * We're ok with removing guards in mlock()'d ranges, as this is a
@@ -1258,7 +1268,7 @@ static long madvise_guard_remove(struct madvise_behavior *madv_behavior)
 		return -EINVAL;

 	return walk_page_range_vma(vma, range->start, range->end,
-			       &guard_remove_walk_ops, NULL);
+				   &wallk_ops, NULL);
 }

 #ifdef CONFIG_64BIT
@@ -1571,6 +1581,47 @@ static bool process_madvise_remote_valid(int behavior)
 	}
 }

+/* Does this operation invoke anon_vma_prepare()? */
+static bool prepares_anon_vma(int behavior)
+{
+	switch (behavior) {
+	case MADV_GUARD_INSTALL:
+		return true;
+	default:
+		return false;
+	}
+}
+
+/*
+ * We have acquired a VMA read lock, is the VMA valid to be madvise'd under VMA
+ * read lock only now we have a VMA to examine?
+ */
+static bool is_vma_lock_valid(struct vm_area_struct *vma,
+		struct madvise_behavior *madv_behavior)
+{
+	/* Must span only a single VMA.*/
+	if (madv_behavior->range.end > vma->vm_end)
+		return false;
+	/* Remote processes unsupported. */
+	if (current->mm != vma->vm_mm)
+		return false;
+	/* Userfaultfd unsupported. */
+	if (userfaultfd_armed(vma))
+		return false;
+	/*
+	 * anon_vma_prepare() explicitly requires an mmap lock for
+	 * serialisation, so we cannot use a VMA lock in this case.
+	 *
+	 * Note we might race with anon_vma being set, however this makes this
+	 * check overly paranoid which is safe.
+	 */
+	if (vma_is_anonymous(vma) &&
+	    prepares_anon_vma(madv_behavior->behavior) && !vma->anon_vma)
+		return false;
+
+	return true;
+}
+
 /*
  * Try to acquire a VMA read lock if possible.
  *
@@ -1592,15 +1643,12 @@ static bool try_vma_read_lock(struct madvise_behavior *madv_behavior)
 	vma = lock_vma_under_rcu(mm, madv_behavior->range.start);
 	if (!vma)
 		goto take_mmap_read_lock;
-	/*
-	 * Must span only a single VMA; uffd and remote processes are
-	 * unsupported.
-	 */
-	if (madv_behavior->range.end > vma->vm_end || current->mm != mm ||
-	    userfaultfd_armed(vma)) {
+
+	if (!is_vma_lock_valid(vma, madv_behavior)) {
 		vma_end_read(vma);
 		goto take_mmap_read_lock;
 	}
+
 	madv_behavior->vma = vma;
 	return true;

@@ -1713,9 +1761,9 @@ static enum madvise_lock_mode get_lock_mode(struct madvise_behavior *madv_behavi
 	case MADV_POPULATE_READ:
 	case MADV_POPULATE_WRITE:
 	case MADV_COLLAPSE:
+		return MADVISE_MMAP_READ_LOCK;
 	case MADV_GUARD_INSTALL:
 	case MADV_GUARD_REMOVE:
-		return MADVISE_MMAP_READ_LOCK;
 	case MADV_DONTNEED:
 	case MADV_DONTNEED_LOCKED:
 	case MADV_FREE:
diff --git a/mm/pagewalk.c b/mm/pagewalk.c
index 6b6ec602a916..977b06acbe89 100644
--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -694,9 +694,8 @@ int walk_page_range_debug(struct mm_struct *mm, unsigned long start,
 	return walk_pgd_range(start, end, &walk);
 }

-int walk_page_range_vma(struct vm_area_struct *vma, unsigned long start,
-			unsigned long end, const struct mm_walk_ops *ops,
-			void *private)
+int walk_page_range_vma_unsafe(struct vm_area_struct *vma, unsigned long start,
+		unsigned long end, const struct mm_walk_ops *ops, void *private)
 {
 	struct mm_walk walk = {
 		.ops		= ops,
@@ -709,14 +708,22 @@ int walk_page_range_vma(struct vm_area_struct *vma, unsigned long start,
 		return -EINVAL;
 	if (start < vma->vm_start || end > vma->vm_end)
 		return -EINVAL;
-	if (!check_ops_valid(ops))
-		return -EINVAL;

 	process_mm_walk_lock(walk.mm, ops->walk_lock);
 	process_vma_walk_lock(vma, ops->walk_lock);
 	return __walk_page_range(start, end, &walk);
 }

+int walk_page_range_vma(struct vm_area_struct *vma, unsigned long start,
+			unsigned long end, const struct mm_walk_ops *ops,
+			void *private)
+{
+	if (!check_ops_valid(ops))
+		return -EINVAL;
+
+	return walk_page_range_vma_unsafe(vma, start, end, ops, private);
+}
+
 int walk_page_vma(struct vm_area_struct *vma, const struct mm_walk_ops *ops,
 		void *private)
 {
--
2.51.0

