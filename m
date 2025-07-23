Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7387EC83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 10:16:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F27F28E0002; Wed, 23 Jul 2025 06:16:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED8C08E0001; Wed, 23 Jul 2025 06:16:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC7808E0002; Wed, 23 Jul 2025 06:16:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CD9B68E0001
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 06:16:20 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7A0225A0D3
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:16:20 +0000 (UTC)
X-FDA: 83695124520.17.75E662E
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf27.hostedemail.com (Postfix) with ESMTP id 063004000A
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:16:16 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=TBXN9sqz;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="K7bNMw/A";
	spf=pass (imf27.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753265777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o+pmAz4BV1yXLI/ncaRRjp1661M8JK55wBbKiZK4YqU=;
	b=TdYcmuajaQj5ESwjQleIWMQlvY1UiRk12sqVRw+aAuwZjwuudy8V/PBHy4MG/RQMlqEOk1
	hRlcG1Nu6DZI/89Nha4fNIf7CBdr3b2kCjUQ4j/0KBnB2LC//mZ6wprFxVtiszstDCVIIa
	0KILoKcMWtSkHHZS7/z/oP1D3r2XRj0=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=TBXN9sqz;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="K7bNMw/A";
	spf=pass (imf27.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753265777; a=rsa-sha256;
	cv=pass;
	b=pUXcBxG5MjK35lIkKwcydNHV+nP4aei6ABhVmSIzAuGaddUNoxtnc6JQe2PnmS7ah3CWD7
	t/umKKFLyeJsG2ZmnrchGcnUqCMi35s5Jt2BIyPv4zASyLdtouSL1elFos5pn/BRVchROM
	L3yZbnom0Azl64TMUdHtC3MjdgNuy3Y=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56N8NJSR023498;
	Wed, 23 Jul 2025 10:16:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=o+pmAz4BV1yXLI/nca
	RRjp1661M8JK55wBbKiZK4YqU=; b=TBXN9sqzrJGcopVHMyznKytl5xkTfXyrZc
	CSxwDt3kmYc1YiUWO/cVpRwrblyKyoYh3dKZKh2YmprOuhLF+eBYyA/HFvESoM5n
	HxxHPg/0ArTMN1A14SDNZzzuCDCgPXXzoHxqcCAsu9SF+YEPTLDyHHC1eBZv6j+q
	xI1ilclsKkJbZuuFI4FdlheiDOAz7bHE93JI/zoNS1Q+V0t9QYyofdfk94FKEYHV
	yj7JtfyP6gFKs6Egdg4f7zDuAhKNkRzZVWlCcrGSWRSzdO8+nwatpfsRIDv5dnpc
	NFc1UaRdPPIlwloLtQGcVWlgbieTpV3jcEzB6NbXd4VvpmBq/PVw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4805e9q9pq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 23 Jul 2025 10:16:13 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56N8X3v6005987;
	Wed, 23 Jul 2025 10:16:12 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12on2056.outbound.protection.outlook.com [40.107.243.56])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4801tadsc5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 23 Jul 2025 10:16:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CM70nonvjC0Pycr9sLYHOGN+UB8CEfAsxN9yOiHQE7wDdxK5j6XjsgJO1lbhJFMQB9+Bh4TrXXhZmlF32ti9GGiXFJcRQKNbrzZgWRKqm04dddVQgCDp8V3ODsbwZFqY1ZCTr1t84j0PH49416h2bIyB/y5sgShqr8OjdZJ1LVjWODE/k3W0SQn0S5aJIecGT9oSaMp2YPZeSohXdLQlAy8Xi+U8Sz5T5hIaIUbfOe9T8B8R5KydAhKO/5u3GexSL4HV5a0NXkql5hD+w8Z22QHNV93IYWYh/r1nlIv2UjyaLZEr1yfjLglcM4Qg/Xu1iNKZ7Z9kcAAhIl65roM2ZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o+pmAz4BV1yXLI/ncaRRjp1661M8JK55wBbKiZK4YqU=;
 b=xybEj76vot9VuJ/yADSVhFj1LIqVWVgsbxpAd6GTXgWuCa4Z2n+8TH6NvgylNJoV7wWVknPk3LTaqjhU3kvxwlCR0LE/6/7W39X8mvWWl4H/fO730rH/oYDPDEwW92fxohvah1mQQyr3g1vmlBvcHvcDD4q2VvijtlcKBjr5rvO886jqWmG8bXlnB/ScTarOAtP+3/biuLK9MciHyWnnXh5bmRk2/RF1Na5fBUblgfWN67UJIBM1+6z+JSkwWIN+ldn2lQFKf4dN7jYiOO84DLG6VluQwJXVW6j9PBZQv8zIuwsy12K2FeKlSOeAveAxfvjNPeRXnZY3rxb3VkizMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o+pmAz4BV1yXLI/ncaRRjp1661M8JK55wBbKiZK4YqU=;
 b=K7bNMw/AJIQiJOFfqjbWqxDcCBi7wwGmbLySxP+idiEMI0SjSHsPHoJSQDC/wwJXR5AYBBASYzwyVL4drvb8h4/aGkwzC0f/JudY2XbiKxXLLa/JOM3yipgnJIv7FYFLGCoSOAggwisDFaFlcRi8Na+byEMcAobdPiW55Eo/Tg0=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by BY5PR10MB4130.namprd10.prod.outlook.com (2603:10b6:a03:201::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.21; Wed, 23 Jul
 2025 10:16:09 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%4]) with mapi id 15.20.8943.029; Wed, 23 Jul 2025
 10:16:09 +0000
Date: Wed, 23 Jul 2025 11:16:07 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Harry Yoo <harry.yoo@oracle.com>
Subject: Re: [PATCH] MAINTAINERS: add missing files to slab section
Message-ID: <0008a3ea-ae9b-4425-b3e8-c6eedf9bb7f3@lucifer.local>
References: <20250722175901.152272-1-lorenzo.stoakes@oracle.com>
 <a3f60194-3498-4dce-b0f0-e16e706f66ee@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a3f60194-3498-4dce-b0f0-e16e706f66ee@suse.cz>
X-ClientProxiedBy: LO4P265CA0180.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:311::11) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|BY5PR10MB4130:EE_
X-MS-Office365-Filtering-Correlation-Id: 2a9c14f9-c5b9-485e-bd6b-08ddc9d1f183
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?U5CrClNaMYb+1rCOMTvePp5wfXqFPHKI9qGhbSbi7LyMn++l+M0QTyI+H4LO?=
 =?us-ascii?Q?N+x5wk8YkJ7+T14pWYLyqYPbbIs2qQr1DnOKbxawDgg9VppSwGguDLrNsyPQ?=
 =?us-ascii?Q?JULAZWuVS45UuZyivw+E7zuXIYrCzLWNWD65A0IVs1LCQIFPXmUVSLTBcbGX?=
 =?us-ascii?Q?8NZxlx/+QLOUwnTpNuWieu6mxc+nNmiS2zQgeN26mLc2hvIL1lTd7GyEXs+F?=
 =?us-ascii?Q?+OTDxPJq3oOGhDiSQR8OskdaM6MsQrRk6ZpgYBMstWGl7+a37WEfNNI9Wk5T?=
 =?us-ascii?Q?lRis5bU5QOXPdlgWljr1PmIJZCBP9XvymhTA1zECzwVZ49MVDPbyqKj/eqxv?=
 =?us-ascii?Q?aKWIHiSerf/d67pTQt7Kx/GYMvQZCn2nBpgqE+AbV49edo23BRwQ8IUkzOeG?=
 =?us-ascii?Q?izGuyk3ru7ygr5PoLcH5YkMWFkWpLT+oor4S8HQKvUJ4bJtV4OkNO1+9qMBb?=
 =?us-ascii?Q?dHmfVehi2tXbab2E1HWLulFoKCoj1Pk9gHfU2TEwS/q6J54Q2i4BoxDLmR5Z?=
 =?us-ascii?Q?HSAjp5lJkB42JRfqZDHvh/xpAx7gilikYbybN5QXEvdktrkJvejc4W1cAvpJ?=
 =?us-ascii?Q?VgtAD2AsK2ZNzIWXpMBs7jief4oQHZUBPhdCvFrHclOnZsWU28rvnFmBblmn?=
 =?us-ascii?Q?VTp4Bctf/MCa8Xko/0J44myJSMcru1djkhe/chPTGUQgx56DCI7RNZx9pwBy?=
 =?us-ascii?Q?L3rfsvhG4ZkUmemeJghCkqgllgA3+Dx4vT444BKcVC6oOwXiLhvlXQeugfNU?=
 =?us-ascii?Q?Aql7PYoe03HJJxVSPXfV1t1k9EqT1y+oIygGpqD68uz4xT+U/eu9IZKdGE9V?=
 =?us-ascii?Q?fbO5mVpCnJLmnXXCwHq3i0n439PtpTE4NWJr+1A6VPtANgVerAauz3Qba/Hw?=
 =?us-ascii?Q?SD0WdGYWrV4+9B2ki3SiPilP4PVt8ZL/SAyUgyw90tU5nd0NrBDXUEzKAxsx?=
 =?us-ascii?Q?csHMZjo3vprYvna2ove1IWxqQLa0bEpjZO5cYmX9PrNomvJcscc7c7j8rlwH?=
 =?us-ascii?Q?u8jYq1MEPgNdJ9QW5/2sCDeo/yhHoiCZCeO88SY5EkSqKI/6fnHznUM0dyIQ?=
 =?us-ascii?Q?hnKIuQUQSgbQDzkxOsvDqkoyYTu18r+saAu4wuA8W7Id5+GwANACF3Wl2oWc?=
 =?us-ascii?Q?wCoHy+ceK7cu5hD4bgbfjPQoiCjmjc98BtqIpOthulmYaS97IqyCstYZXm3D?=
 =?us-ascii?Q?2KuAm6uCXzKy9X9tWwMyH3xukjY9ZkS6nZ+FMSEhEmmO5yHoi6/mb/JzyARo?=
 =?us-ascii?Q?Wovfj59+h3L6dI6/u5iCQdMAVTQIP/W46mmJZSGXIq31eXVZZJQ8UXFZc4i2?=
 =?us-ascii?Q?NCoKNu+uSUDj8/lOnCAuo3b7SSuUJs6yyG8DgoZ8v3N7VycwxZxA2KJ2apZH?=
 =?us-ascii?Q?f4Omp5jLYccT1D36mzHfwmnoJJbylazOKW6PGMzxzetn8+pn7J27b8AiFBiz?=
 =?us-ascii?Q?9g8KxmuC/Fk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lLzoqe6m4P5uA0BQToGb/eM2l2QfUi9zqdXyKUbSiAnG/u2pUqAjKZwpmxzl?=
 =?us-ascii?Q?+ynevzinYN4M+IGOaFzn9yQpta3QCYHzs/9WuFxUY/HLmCo8Oc7A73+6zAND?=
 =?us-ascii?Q?SCbEtTsaJiyPSCKuTMK3UxRMdnfllw+XyV2GFY+ppa8qKJ1NiBHejrHtHbBv?=
 =?us-ascii?Q?CsR/2wxoXfNr4ffWrNuFfamaTgprXytE4hV83/mCFHwuR/G2+7UD7ijl3ZK8?=
 =?us-ascii?Q?jsWBBZjv9APrHszzgsT+PGgpJ1YX9rOSEkz2YH7hwSZpX6DUw3nrwyqtS2N+?=
 =?us-ascii?Q?v2qarAedE0VcZaHIm2DtOeNoi47bqMIPgoegrkhzOLkV4D+d09LmbkapC6wl?=
 =?us-ascii?Q?LRqQO3kLf8N+uQaof8RsPCtcK2drDNKR130YwCWTdaLLJ5CTPGjaFHH9gl2s?=
 =?us-ascii?Q?8EeVnSNi0sJ14NUC9VxdE+PZDvEMbVr969EDuotDsbiQn03xSC47v+3D5JWq?=
 =?us-ascii?Q?vFyH0Z6Ugi3G/ag2In51EbCmIBsWDirrR8CAcyJBwhdHk1DRTZYw9LNwZZBe?=
 =?us-ascii?Q?M4r1fuMUwAIIAPzDNzzQB7BKLpePJS7Fd9iekf/ok2RtHuGzSboVDZWzgiYJ?=
 =?us-ascii?Q?JvVXyoxaIpx2dQ29qwK++JmHFvM0Smb/MVa1ZRK4t3gZHRk+njZ5+SebLxxW?=
 =?us-ascii?Q?TIGA3jvCJpvJrahXIW4zaGiN6i3qfORrggXht2Tzd1oork0iCAHNsHhWUMu3?=
 =?us-ascii?Q?eF7y2uusuHXYBfBy7uaRhaMbcJReHADjeRY7FAu9f9Fo/WvdFM744wnNKuld?=
 =?us-ascii?Q?b7rC2we3JTEP+Q8MHNDF76icE+hMqTvxwtCTJ1lfYZ5WFzoIU0PhpZBH8HLR?=
 =?us-ascii?Q?5yyLsfO3KkraTtfvcBv7mpRqRPy0NdfcJ3gk86ooX3vN3zoXrhlT7lQrn91l?=
 =?us-ascii?Q?6W4wjaA5SnTO1ohigfDMW3Atf2qlsz02bTXUS+WtaMvSiN8ka7WPSkuIhD8b?=
 =?us-ascii?Q?xa8SFfVr5jWTbXFGUo3kT+ccJLgiESVoDQVYC3Q+1Q3MatObKBIBoMUhJFKu?=
 =?us-ascii?Q?wi5SKXTm4yg/Z0TFVvOrqnxUcYQ/FYx2pI4UbDydHNR3dYyBwCZj93FKjRzM?=
 =?us-ascii?Q?zAWpeqDdXUtfQsYN9lli3kvvGqgns/lSHX43KoRGECH35MeTACzbdODacTRI?=
 =?us-ascii?Q?zJuecKofnrEm1KH4hdYvYGWJot6GyptstGbDlMaSffEyBEBdsnclHGMWxhsl?=
 =?us-ascii?Q?em0S9p/zHJ508Dh2VyVWUrR7u6GCmf+E7VEfwCCWpeqNpx6iCfSbyQAKNSHK?=
 =?us-ascii?Q?LyQ/FyZfPie+rR45RxeJK6/HxzipCi/wpjjzyda6v0eCEw2DeKabZUcY8aKO?=
 =?us-ascii?Q?gjHSlHwp93LeAjJBqkXhY1txEsQtAdg0ZkRzWI8Rln+QGT2eqr+6VhKsJZ9I?=
 =?us-ascii?Q?wc/Vvm5F7vP+n3+ALQPeZZ9tR9s4ydZcnLjdrImsvuep7A6fNQAogInBElv/?=
 =?us-ascii?Q?PzPm1od9rIfsA6Z04yXVCuvM5ISIkRNdVawuhvwHSrWn304mpfdwalMo0rEP?=
 =?us-ascii?Q?am9kGLfwkayuas4jb0NihRoVDnSt7zFULHsQ+H2d3vHeI0jposMo5s6bgaxr?=
 =?us-ascii?Q?eO3BUAW00qWeqGOKpJKlxUdvO8Y6S6LF7gYrlwLDhcFvrrQop60zvmSJHp3w?=
 =?us-ascii?Q?IQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	uKyqLeZrXeqZBSPWyhOnlSYxqaFw1aLSGMVy1RWmB6/wiZaepMg2smZtpDfWALPASEm7LXS04yr9q0p2Jo8i8F0LYz2QO7Oc3/b60CgmHNt0Jr8f8ko6nMUIftZHk1jVBHBp0U4Zi8AcZFWm9lt4Zo5qoKusBFfT8/TF4hwVmbINCeo3nFLl/gzKz0M2zl4XfepMNVLYYbvJSs7oOCin+7M0Ta/Y7T7zxXISGDoVOZQHSjKHfbmtwc4d0DOUXf/DCcJGP9pVHG04uulW/T4hMUtTOTIyMD+aKGwCIvpkgbhIwyCxjH7VpR/pEnCyQQvZFwS5Qhdu8YEhqBS4TGw0D3SSAqOirOdyqwIWFNrbCGudRYAqZs3L+RBnm1PTu6G3X/qLZkwYV0SO31+fOmH2OwgExIbcYIlmMpNFrsCvQ4KJ51X+S4Awk/cwqqCoU0FB+pBmS4BsWMD7k9IXKpm5wJkROatnXK3guXFJr/Frdezyfojyk9PyPvkfvm+WwzB6qXx5p6hpYAgPbTXf6s1PwygyuwC6bFm5KFZsmcS7uOWjmQ4iTEHQo+oDjSBS2SVa9DaVmtlNP/JMv6HJNl9yNZ9OKPGvBF8UEt9HGlldK+Q=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a9c14f9-c5b9-485e-bd6b-08ddc9d1f183
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2025 10:16:09.4326
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CZAaIyhvxuHaxvPbVv0AKQ+6LfwjrU7IRDdFUKuSS1AIe+eJsnbTwAN/NR5GLpa+g+hjNrKywyNLlo1m8zefItcjJhO8q05MiWBC/fw8ZLU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4130
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-23_02,2025-07-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 phishscore=0 adultscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507230086
X-Authority-Analysis: v=2.4 cv=eqbfzppX c=1 sm=1 tr=0 ts=6880b66d cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=yPCof4ZbAAAA:8 a=VwQbUJbxAAAA:8 a=1viIwJKtdOlLoCLg0icA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: uircEZWVV4SAdAXCVZKEuW-2hvuXpaK-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzIzMDA4NiBTYWx0ZWRfX3k0ldTDXIDi7
 6KzUUnPRuzimf5RuWjI58ceJ4y4yFuuie23vwn+0Exm4exDlx1I9D5vuUqtiG5zWK2zuHxqXken
 wfy9MvrxTBKNy2AAneo70s2aSfMCgmJd1ZUGwMFUXdcI4mFDv/zremy7jdpG5tIWsXfSOXABWoQ
 1F93aP/FyMSyM0eOvNY3xfe6ZbkCs9WGG/z9ty1Nc1aulmXuDHTae4TVpbAxcRqD20oZ709zOfE
 VtBe+KaYAjxBzmT1aZ1S7LLu/uqn/D8/WYjkEGtPobs6iEFmc7D81tCpdK2f9ZbHVFHhvjM9Ey4
 knYiHfAJI5jH1+isHVHWUA9xm6FB7qA25nrZ0vyhBy2B5QHhjgxfnQSW45RF9yAGzTb1bwJ5l/3
 HPAyEJ7Uq8nxEjZhUZFdE29IKU+AEtThxC9NY7yatV4lmUUtW9lYkpYug28gHlstPdLdo6et
X-Proofpoint-ORIG-GUID: uircEZWVV4SAdAXCVZKEuW-2hvuXpaK-
X-Rspam-User: 
X-Rspamd-Queue-Id: 063004000A
X-Rspamd-Server: rspam06
X-Stat-Signature: e4rn6kk7dpufn5upfmh8bt83ncpd5nd3
X-HE-Tag: 1753265776-903286
X-HE-Meta: U2FsdGVkX18P1jp1uWEUp23G1hhB3lOju6H0M6Vg6bHkjGaIcTNPcMWArTQLLyBoFBjLipf/F128CRtVWnNqmPUZs0UOYE58HqcWMQxizf2/hKlboM8rL4n9PhRaRVkYxtRYrFDhEl/XuVjSR4mgr/3rCKmj5828er+2OplMs+GdHHnBS5uloTztD3nOpBeV6Ghp+BAtAfL7MR0SwdRcefv2qpJrhi6xLfxr6qYa5aKLpdNPi4x5MDSZYwcg+zor8PGQG8wAUmG01Vc9Pzq//GdgzcC2flNezgmWDztundtIXYgNxBtu1cEkwo7w7E3Mjcq8rKOBTdXM1/iDmOIdT0kOOIAGQjBkkLv8U1uYKcUWkTMU+3DUB2nGZi3Q3ZqXRtCJWWSL+n508LRGyMCPAXa99ZJTULRePgFYIP9HEqeDiynfgYe1rn/ATF+JXDuIgOI5np9Nf8/BmKlUpIvEX6o4OlfK3f79l4kY7fMjXiawQN6SUDQzzO1QD5iP3B1LtooIZ3pZEjkRNa9CfPUF2eRHoyt5xKRnxOOrDSRcLEat1kex+WJKXwu7zEJM7hM4QDugBVWjvAdCynLzXTnqqFXrt6ZGE68jeVewBl/968e/+HD9jJ8JhElsD8NI5ib1vQrz83k1LK/fzwGRxLEDkBF1TfUUhdpKibvdDr2WFOK6Bmr8sXgJNCyQ44JSbpCLEC91S2dpoWXQyLjz5VvZmEWqryAgvd8hWbb38HRUkkgEXdxZAMo/FXAyk2GGDllfBIzvFDB2+QYdvvrlUm6up+NsaxC4nGsRWlTSZ9fBiPPUwn/BL7p0D52YctCnypkjXOI8t7hJAMso/1pVToTq4hMeWif6QTrwXsITx2c7XgO5hAC1/IhFCW0TKf6oh5r74m9CYVz7zXt0PGvxIYJ6zScc9m25btBaSoKmX3nv782/WBh3fwCB0KDmzwSmWfT1j48G0yMGR8VEJThP7hg
 VXOQLUVy
 pl/D/j90GJ/l5iizuxExS5EI6z4Lr0AO4NIYV4NiZrMNy8xP5cfpjbb4tWXVhAemQspKHZQxHR1OMZAp27WaAONUXl3gYCJxEagCRpaS9GDH1Scu0QV/7Hw9uYU/CTf2Hc4Hqz2XoAI9uEkgYSDWCjOHWvApXxLYqm3bIO8xmOvNkaZo2Oa4vuE99MD3jHFDbzPpAMk07TZaZraOkUqWt+bobMCTGtxy47FGGyLxbiyLN7kW2bZejNunOHST7K4NjwYyIeNulfEKtUZc2RPKofTOE2ZyOiLqKXKlx1PlcPv0oI0duhPZSusoPECcwLI+pRNIauo2sKyOgANuuYWCtKhKnrAjqLX5BZZWtWcqSy2nhwMnOwRsr8kqgGN2VtCaBhM7QPhdrldY6iWlTFttKnTBXkGhbwxZTLkZPd1nyMxT5HqkKgbv4iMaXbzAhtlmp8cxj/0q6OgCUZbBUNde/ZSZzn+mPYST8WqSlqsBVo1dqDWOg9wL4kpH0XXPoV4GzGVGT0HA2UqYlDr+1d9U0cLq2q2+O1LSrQRlE9wrdMpg26dvRACqvVTH9VA3I6gmFHC4lHI+QR+3tT/mlHd3smbrTPU4A47UkMcEiuULf3SVmfxJZrXVN/Kaxzr2KcixtGT0rO+2oNwndSP18iNjTWfHWRKKBWqQGpQGeyMcKN3C5/xVPb2mAmhg/vz5YnN9RlreOiFknKr9ZHjk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 23, 2025 at 12:07:39PM +0200, Vlastimil Babka wrote:
> On 7/22/25 19:59, Lorenzo Stoakes wrote:
> > The failslab implementation implements fault injection for slab allocations
> > so seems best suited to the slab section.
> >
> > The mempool implementation uses slab in the backend, so that seems best
> > suited here also.
>
> It has other backends too but perhaps slab is the most complex and David was
> involved so seems acceptable.

Thanks

>
> >
> > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > ---
> > NOTE:
> >
> > To try to reduce conflicts with the latest batch of MAINTAINERS changes, I
> > think this is best merged through the slab tree.
> >
> >  MAINTAINERS | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index e55accbef..2d5c844ab 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -15738,7 +15738,6 @@ F:	include/linux/memfd.h
> >  F:	include/linux/memory_hotplug.h
> >  F:	include/linux/memory-tiers.h
> >  F:	include/linux/mempolicy.h
> > -F:	include/linux/mempool.h
> >  F:	include/linux/memremap.h
> >  F:	include/linux/mmzone.h
> >  F:	include/linux/mmu_notifier.h
>
> I'll leave out this hunk as your other patch moves the header entry from MM
> to MM-MISC (maybe it could be removing it there while at it?).

OK let's just fix this up later potentially, I don't want to create more
confusion at this stage :P

I guess with this being potentially used elsewhere, this actually makes sense.

>
> > @@ -22831,7 +22830,10 @@ S:	Maintained
> >  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git
> >  F:	Documentation/admin-guide/mm/slab.rst
> >  F:	Documentation/mm/slab.rst
> > +F:	include/linux/mempool.h
> >  F:	include/linux/slab.h
> > +F:	mm/failslab.c
> > +F:	mm/mempool.c
> >  F:	mm/slab.h
> >  F:	mm/slab_common.c
> >  F:	mm/slub.c
> > --
> > 2.50.1
>

