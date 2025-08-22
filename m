Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0EC8CA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 18:08:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08A476B8005; Fri, 22 Aug 2025 14:08:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 013568E009D; Fri, 22 Aug 2025 14:08:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1D506B8005; Fri, 22 Aug 2025 14:08:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CAA608E009D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 14:08:45 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6F657117544
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 18:08:45 +0000 (UTC)
X-FDA: 83805179010.17.0FAE1B0
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf16.hostedemail.com (Postfix) with ESMTP id D7649180012
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 18:08:41 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Xk3e7fB9;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ptu3CrBa;
	spf=pass (imf16.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755886122;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mKZhMSvoOx/Hsmp7GVT9VDSsa8bspLvRd0Rei3lj7BM=;
	b=z/KdQ+jfAXW0ij9Ls/W5BaVG/9enBZUmgCCzpLimYpiwrbiUJa//cAFo880utTAygXWJL+
	PSx9DDoDn90O2RKYZNjES3DPyhzdACvX4fFKoRyoVEaaEptpNWwK/j6NG8WSpjpi+9kFGz
	qiJrZsN/rkntPcBD3v2m1CoYmba6QH0=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Xk3e7fB9;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ptu3CrBa;
	spf=pass (imf16.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755886122; a=rsa-sha256;
	cv=pass;
	b=2Q0+U+vUEXWWHqcMToOPR9lWndeqpnibfl9eek2mqNmFB9MFpg8WX2B6RMaUEXo1iEFgrj
	FA9R1VVMb9Ji1JdGwNmg5yB00x0ObnK2dmSiD58rIW2oEt1r/YoK3mqe2NABUcTusBl1Jd
	J6akK8L8uXycU4kcUo9imsu/4WcHnPo=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57MHWUPd028888;
	Fri, 22 Aug 2025 18:08:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=mKZhMSvoOx/Hsmp7GV
	T9VDSsa8bspLvRd0Rei3lj7BM=; b=Xk3e7fB9SSq6FCwKEjR62VEjjVwmzX7vHK
	HL8/rafyvJZilfWKwLBUWL9tsjFa3UG7IK+aOdN7zOEkK0A4x36kp9i/nRud3lu9
	isoGfe6wDTR31kXYeC0vLCumMegu1897g4tyqcMrkfwhwH7+QEXdvCRzfCnVtaYY
	Ip9PYKTC+UdbSgAUh7RFgQ2QUeFGEelM16USFMPAgewjine37vzQOIBtQuH+KzTr
	oniN1y0G4simzSXkV140fGCpGxJMxavD+p/vXW2KUqRuWbVATQaZ8OeeSAuKUKhd
	M/swn9qNp8KpgaXadO1ey6r5bEzhBfyjgr4nnqNHG68rofBthkuw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48pw1ag25r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 22 Aug 2025 18:08:33 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57MHiAuF020620;
	Fri, 22 Aug 2025 18:08:31 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11on2071.outbound.protection.outlook.com [40.107.220.71])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48nj6hn65u-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 22 Aug 2025 18:08:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oIidgnBFftzRqWUTUvjGQI4IvbL8sTrdzrjQJA9hMfeIrnZf4mACCcIiwBexe79M435kyI+A+hAKcXaZnDOtj8yARAO0ZVjDGAUGTSJ+IVMNgbEXxEySSKyiZdJtJuuTEDGPmDCTOXkhP6c+MqiHyyV6ZWwZPR0jMxxKoTIBgQDGjFalJUhLu8fyax0iKCc6LmL8ROZpaZW121a+m/e+6XYl+SxyspukULHCnv08l42/n1QcAKC7IJ8ku8tCBkFuySxPQBIz78MdyGneqXTFDJ/eShj29x7tU37kPJUW/Wb/WRIhhQeTgIYJcXtAgGD/B9LnOkiwqYiax0QJ4FStQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mKZhMSvoOx/Hsmp7GVT9VDSsa8bspLvRd0Rei3lj7BM=;
 b=dgYgjUbYfvHpJkLk8bE34iAdvJr60Dq64wQYJ4cBXFgbRVJkszmkCl6Vw46r+wJ0WiHFHK5kN9rnZ/fQcmGnSYQ+hwH0XO1hHJkpi4FHNTZAooN4zlKgCffki9H/jJT5qbmXSZKD6lb/S9FmutJF1CXoJAsAcYdXEP6CpW+Czk4nblMKH/kEjFWDfy8M8rScfEyaKa49AGHm1lJpUOWY/vqxLeT3UdW+6+grLeIb/beqwA8o48nKH6G2BZ2OpvKgK9Yxx0pKLPPH5HKplq2Jy3dhPK3q91mc3qr+76I7O4uw5YuUhucrYKXtoxwmnLPUOrl+2o22ZIWRiNEzkh7cfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mKZhMSvoOx/Hsmp7GVT9VDSsa8bspLvRd0Rei3lj7BM=;
 b=ptu3CrBa2bq0wphR2nXde54LvBtXo4SbtXxRXVhYi+TsGtQyUpDUMoDfESW+fGfnnY/YRgOP5E8eMzyCNdQY5X+8MFy5gdgXxGXo8U5fROXlqUYAhvw44Uz7CVcxQCKMqvxSZsyR13wNEb5VDQyqsnI+2xlV3NHTPxCVZTtIKsU=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CH0PR10MB5164.namprd10.prod.outlook.com (2603:10b6:610:da::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.16; Fri, 22 Aug
 2025 18:08:17 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9052.014; Fri, 22 Aug 2025
 18:08:16 +0000
Date: Fri, 22 Aug 2025 19:08:08 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: Lokesh Gidra <lokeshgidra@google.com>,
        David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Harry Yoo <harry.yoo@oracle.com>, Zi Yan <ziy@nvidia.com>,
        Barry Song <21cnbao@gmail.com>,
        "open list:MEMORY MANAGEMENT" <linux-mm@kvack.org>,
        Peter Xu <peterx@redhat.com>, Suren Baghdasaryan <surenb@google.com>,
        Kalesh Singh <kaleshsingh@google.com>,
        android-mm <android-mm@google.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Jann Horn <jannh@google.com>, Rik van Riel <riel@surriel.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: Re: [DISCUSSION] Unconditionally lock folios when calling rmap_walk()
Message-ID: <13fca620-437f-4105-b4bd-5b0f4e9f064b@lucifer.local>
References: <CA+EESO4Z6wtX7ZMdDHQRe5jAAS_bQ-POq5+4aDx5jh2DvY6UHg@mail.gmail.com>
 <aKisbbkNcuZoT2RB@casper.infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aKisbbkNcuZoT2RB@casper.infradead.org>
X-ClientProxiedBy: LO4P123CA0566.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:33b::16) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CH0PR10MB5164:EE_
X-MS-Office365-Filtering-Correlation-Id: 946eafe6-9f41-493e-c4ae-08dde1a6de3e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?wvucSbEJ2M2zrABR1UldlejKkNnW+QR7kQZ87mKQKW+U/qiCmW+kfeOHW8eQ?=
 =?us-ascii?Q?IJJRa8ejUs7b8FXyH/BA/w3fuM7mXoUe44Ku9SJiPWWHiKXDzYlzMKbf7Ftr?=
 =?us-ascii?Q?lyQ7hx9Z55jei0oy+hwRjZwR1Z4wHAzkXUref5VwGLIOquuJ/MsViZ9kfWUI?=
 =?us-ascii?Q?GKXgZwd7/ymdOpbKo5qi76hyZ+u8RivQd7JLbvq52XJK9ZYlib8LRgcIol7Z?=
 =?us-ascii?Q?dPwoUKc/Zwimjy/NYEP3wQpXIls8+B8Ks1AaeQMrzd+hhM02G8E/QzpvajT3?=
 =?us-ascii?Q?UpJO89Lcq7z8uydv2lMioWX0M+U+gFjaAKWMx9nayPZQER3QRMhT5t1aer6t?=
 =?us-ascii?Q?H5zspGYOok27wtCILwVkPYvBnEu/0ronuB1PKsoN8QFJlPVCbzxBKd2nign3?=
 =?us-ascii?Q?OPMtIRdZcf/aVHICdz/B6se7HPP4/eLfmFdLtVI3u2Z28SRvsypAFJ6oEFQx?=
 =?us-ascii?Q?WjoMKQb0XJQiTG/XVpzqu2FAi6HEdw90T4oGzmkSVL7v79UaebMTOxZGc/YB?=
 =?us-ascii?Q?rrx+tyKnCQRSAE9Fa5CDuBA+9iAyyc2I367gXCqzCxoSsfJ9XYm9il1paujY?=
 =?us-ascii?Q?VFAPwcl7MfjT8NTVWA69D9HVvXqqh0+OQNYcmt79L/7DoFMf6fV76blGPW/l?=
 =?us-ascii?Q?CwBA+fRXAyF5HMpCygzrwYja4uKQF+E6B6VLd9mhHfk4nTEykXQ9oWpS3i9j?=
 =?us-ascii?Q?QXx+O847Al/zhxJRGYvunscxL/ArGL2WPuhIcwPeFhlt7M/rQSfzdSYUUYAv?=
 =?us-ascii?Q?Vz0sQPl8ePAmSMO0oqwiRtSlFaDNUG864E/KQf83JPffn53Xzbsr1sTRBNyo?=
 =?us-ascii?Q?j1LC1Mar4PnXKMw0UqCE5tKUdry5kaZiqvtZZFAuGAC4GDXGSmcn2+Zwcee0?=
 =?us-ascii?Q?k64M55+0sWC4DCsv1zLABHxv422lywWfKB8MgnTQdy5XEgD2DIf4/yukk7BZ?=
 =?us-ascii?Q?cJR7hhENa25bvAY2puNNjWKU616cZQutqg6ocSMv1Dz6SDnREecEy+IcobJA?=
 =?us-ascii?Q?nYT0aL4Ir2lkkm5ZuXEsaBGHzn7bdKLGEkP9+o9bJagsdR76mzfaI9K95oTf?=
 =?us-ascii?Q?4cDo09xbUtllopF5GaWat18A7vOseMXktpuySmbyKMLEIDqIlCcPZrkI68mb?=
 =?us-ascii?Q?PXtR5047qWsBSOg8zaz11aC7EZppo45h8kXu2/5EcDYDSiTx7x+/iI8y0d7Z?=
 =?us-ascii?Q?KWQXANmCCf+8k0lbLASZNebtgdhGXuE3XGatdHqPj3XMjG9ER5swQ6rln/TO?=
 =?us-ascii?Q?3RntHu6g+darlipSDp2Gwn3yQvKGy0lJzSRpz5thL9WgHtb90+Xox1LzAA6L?=
 =?us-ascii?Q?hBcjQvVF4cqdKKibQE57ASRHCmz5onlja/CMZz8y9dS+Q2LtbOCJJ46FHXf3?=
 =?us-ascii?Q?Rc+T/01Ew7oGrlPrtw/NrRWcARM6+TwG8IwfYd9ZQwxDGDcB8W9lXIhiwhj2?=
 =?us-ascii?Q?sguPiiU4kV0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?M1BmeRph5sNO2vm+VUIcLBBY+rjxSJqsu3+QQs/EQLgHQzdTrBLwHwWdhzLa?=
 =?us-ascii?Q?lWOo5hh7pjqTo1pxdsM96xvKTSSLRKTwElae/KFKcoDbg0qMqllQiM5cFXPw?=
 =?us-ascii?Q?dAIvQ9lRjfS1GD6gSStH1dyKzGJ2Yzh4NMbNZp0i8t51sBWwlY3WlhBrdCuQ?=
 =?us-ascii?Q?+Tpk8tDNoyElsr4sJuV0kiFMBNGDG3wN4/SjkBo3glbdMTeYOKRnByOxq8bK?=
 =?us-ascii?Q?5jQadZUgYZyDOWDPGnDPx7HU7dmU/JSQhA2/4KkQD+BLpR1K/UPrDi+OY9R0?=
 =?us-ascii?Q?rea7wA03ZB1Kv+aglYnlHLLpxzpk3Ah5uiafw3NefCb01GcoBuc3Hfh1bvRb?=
 =?us-ascii?Q?eAcu5Bnq+jwJh86aO2WqtUMFKTJy4QDh6+QiFUPrcjpLhoGPGmfoHhhW91cX?=
 =?us-ascii?Q?FN2de1pS3GD5OXB72W9Jeh4TfmBI2TWgX0CMYXRfSrf0+Z350U1y0l71GA//?=
 =?us-ascii?Q?qSmZWz3fd7uZOE1oXaAGq/Ap/5yRnHiF9chAng5T1Ic+BHH4cY4i0dqhubWf?=
 =?us-ascii?Q?95yUe3DWx2y859CcJeppifRfCHMwn/ko/K8P/0YB8YdZqb59KFSsBkaGdpJO?=
 =?us-ascii?Q?XoQMctkhnle9WVZPZ797g/GOpXe8TpxcX90K/8A0brCRfFS9O9UF/rblZbGg?=
 =?us-ascii?Q?w3kqYcTOuEAK4/cWTKlZvCbUGvrTNasmouHVHuO5O5AnL6f/uUmO3OvlUBmS?=
 =?us-ascii?Q?fqFn2NTI5nhIz1wLtoujxWn3YQ1WBYMtfdqztSj78pNrssfMOl96yXJF+f+k?=
 =?us-ascii?Q?Tyn579l6SHj4KjWEr9BJx2ARkFfU+bOS+h/TdB07eDBelh0rh7m+N25g60dh?=
 =?us-ascii?Q?O4XiM1zUGZ0j3rHUeRD/ye6k7WOz3K0eM34krrg7LFuD+ryvNJ+aPYXC+uE3?=
 =?us-ascii?Q?oFe+9uxAmqnmFjHIuqQE1QQM3n1G/rbyUM0EkwMxfCuc/ocGpYXPPwFB0D/x?=
 =?us-ascii?Q?1S+qnXswS6ADMMGGqvS2eyy4F1wF5Wg6yt9vrZHls3Gg459yWZQcCEGkolWI?=
 =?us-ascii?Q?+2XY0DSoUUkGZ9izAbkhvJ22A/ze7aZ76yptM4rqhQqMYltBRkm7ovdIShw4?=
 =?us-ascii?Q?XHi0dlFl4ub2jJ4fWxNnZbfVytEdivlr3x3AdLqy0MOCS5F7kcGp74e8nd5U?=
 =?us-ascii?Q?c/WAegCOlCtKGDw94R94WawssWuzLpC3RMVwf+slOt7fLPsiyp9lSAkJwQOv?=
 =?us-ascii?Q?CTWMTX5Ax5NvyXIAojxiRdcltNYyPd3LnMRbkn8wiBIFQBHIvis71Pd5fsd1?=
 =?us-ascii?Q?e9xaT5BgimCuPxYvPqlfFBmS9FradZA/gwqqNqS2uEkmYjm03wvYcjepL7nw?=
 =?us-ascii?Q?R+PKqttx+fAYI1Cj78p2SQPuNWIZjgr/B/mRzBxlc4Ds7J9IHKb3/4zEH+qW?=
 =?us-ascii?Q?Hmhz5qWcWB3tRmHvwGs+ZAwkiqkJzloVH6ePfK/0vugsiQtFEzPt7nGuzl1Q?=
 =?us-ascii?Q?HY38SAd0zcgz6JAbf4WJkH8nDxFesSmO/6/0zW/7l5knvz7C7A0WZ3YxQqQP?=
 =?us-ascii?Q?O9hk/cI6TsLq4TFmQuEFhOdQmDgnBzcm3OH6a/VuuAXWUdbk6hUiI0kCOrHq?=
 =?us-ascii?Q?5uuQZJAtZhROwMx6aEfIR0rv6dCK4pIiPnzSGshUihrCmte5u0ET8GeIqCLd?=
 =?us-ascii?Q?VA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Fm/+1YYjmeO06iftK2W4iRX5NQX612kxzm9AiwjdYvZ3uMs6aE+t9Fm0acuMiVdzja0+3qotg88aawQbY2DEWDbFqIZLGqV4zk4B2V+rzTDlZ9DfcKajLr1uIvjznjLkb4Oai10aUSO1ANVAeZnxEoeNUe4/OqWSYrh9lcWOIAf00aFfY0yETXeyWWMyt46Xrc2xqHRAUAU4Y1aZEFRo32nO2v75ZB0/kCWjyPnJz4mT7eexQ8K0qmKx5BWpXK7JGOkLvibLjAozjU1LZte9ZoG7JXWnHMhA7zHZ4XdW05Gdq1oIkxBCbWbI7jrjT3hDXf64YzHGFcaXfquFYEBeeScwGv1/BSVihhzwWkNadDIoTQ+xfg+6wOQf2XvLPiAYl8Q2fgpGANG5LB9uZADUsKnQMfRqf64zeqMiNpw00XWdwgkeY/dl3FR6sMr39QA+pD+lJ24IlWUQ3blbimsyRI9VGslsf2DOlvmMnjNHBD6EWclYEQ+jjzk9a2k+J0TGeSlPk18fT+lUrtURE9sWmGAxNrdiQmh4rsUrQ0FWw97zCQv+t0GpOzTL8Itk5954hPI7VwGmGjtlFNC6DRrKKIkPG9nhxo37dcxqPrkrSFc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 946eafe6-9f41-493e-c4ae-08dde1a6de3e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2025 18:08:16.6603
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Eo/MIFLp16ILeiNKkDKrJ2VfGUnQ1Ap8fv8lXwoLUZBNGlrFWbGOQ4dajv37Yl5plJZfbwNGyCyVDfEDeu5m0j3CNXJ9o+QsNLhOxXH2UvI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5164
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-22_04,2025-08-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=661
 suspectscore=0 bulkscore=0 spamscore=0 adultscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508220166
X-Proofpoint-GUID: ScOYCdAHJIE11cSrw3u0iUB_XuZ__L-X
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIyMDE2MCBTYWx0ZWRfX+DAKtZrFMhAV
 lphXe+FF1GGOIHGsMwarx+oZOTskGN7bMpJejq2p+RIz218xS7xX2wu8Jg/u2HBE9SXiYZOuYyr
 Gv5sWXym2E21IqAM/xGg402J8eSPq1EK43YK2H8TtxU8jWsvIcGgkgaI5bk7sT0YS5ZLb2sb9hR
 obL8KUSUiM93I/6ocMpd9h3WbByU8rW/pUPiLJFtzCneY/Plpvg/jJo3l/aQC5jeBAmhQfSKB4h
 z5rlNELXVJZgkoakIDk43IYBoQ5Dl3+Za2riRfVBPGa7JO7UI5HThWQr8FxuhR6RNstLmDJ4JdB
 dC0bZTQcqpoFZ+SUqXS19Hm3LcFdEgKybUFJh2lhS8JrqyZ3+q4xgpvdb6L4fh5LEROYyqkt11/
 NoGfZJwzY2WO58QgLaqQWufen8sjXg==
X-Authority-Analysis: v=2.4 cv=C5bpyRP+ c=1 sm=1 tr=0 ts=68a8b221 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=mAEomQTk-cSPI6Jk01gA:9
 a=CjuIK1q_8ugA:10 a=ZXulRonScM0A:10 a=zZCYzV9kfG8A:10 cc=ntf awl=host:12069
X-Proofpoint-ORIG-GUID: ScOYCdAHJIE11cSrw3u0iUB_XuZ__L-X
X-Stat-Signature: jrp3f19cn9tooo8aasrca5yycgkkjg31
X-Rspam-User: 
X-Rspamd-Queue-Id: D7649180012
X-Rspamd-Server: rspam05
X-HE-Tag: 1755886121-321558
X-HE-Meta: U2FsdGVkX18sTkHInSGglqUWhHmQ+JaBXpp+iFPGqFmsryS8MPmTR675+mQq+kdS5edFPfapWmZVno/Ls+qMiTmX1n1bYLyIDJKUFj3mGo3MMxdy33tHTJmdPoOGjmSUGjFNr/+vSirPvTFDgFaNioSVNEuxxHZMrHk/vcfcS8tBle2URP35TD5MVpV3gWITWBJApXZQTKIk3lLdXGpl+3dQljhIt5k+dvDsNnxXMi2zPS9tSYGyY8lgBGQhyJ1dnyBh0y9IKPtqBWXlv56zS65NLWlTaKc627DT4QcNGck1aTgrWBM2SvovPwl+C6d1SFWbr8GddgNdKCYLfH4XTOqV5JvBF66i4pvHRfr7kc58Valswu/+FRl4R1varYYYFb4a0KVBYkYYllKtQqVTRaAyO8yFwzAHJ4CTdeyYxHj0RlIoXeqtMAKRt7n5M0h/TCdytVKv2I+82/8RxmpExdtjg//TK8SWnAApFDxXko+xl6Lm5QMUMLCNnOft/1c1hUlHn4s/rEeRA8ahx0/+jGBVFWsnM6MjdzeCRVGRa/X9TmFCDvNyF4OzgzHHOYrs+jCkXQgrt7SsDVcEenMbN62aKN1jCWTvCl+xzfVEYUpxzFL2gR8vOJg4VQoQO68IcH8SsPh65p6vNlHCM7fo55BYyuyqZSFlgAp/vL/BAfobBP0PqW5J7v4WnQtgDnXjVLva/Z86KvNRs1w1gXTUlZ8Ni5bAVovuk5hiQsRbC2CkNUQ3j3Hf51sO4bzT7TEherATp9PNsGL5FhrL+Brw4Z7UVrJB0StQfi+ZTr6pyah3JBcQNGCozyNCFFwEqP1ytAUz++LuIxLLZUDycpNuKCm92SCy7BltCy9uqYjZM+aUenmE8SP5SsyiLRKqozGaMRU8d1u1NlA5v/CyhQE5nLDIuvzE/gwxyFJguybln/WcCoOGdSsbfCguUwHJx0FCloeGW0xq+Snf3iqNT8Y
 3A79tYQ0
 /utN4ZlA/73vGOFYWrT9JjhCQjh+zbqmDR6xXc6OK/eBBQFDtvJlBSfA04AOdheOPfHAo4ciVFNdLUz9mlbzB/iG1LLawLzVzfO3OPgwKul1P59AkcDnM8Pwmgt3DOfCejoClr/tdgCJM4vT7Dt0akvCMIGh8+epyUSz2xkXbuOYMsMz4GdggoT7K2OQ67lyMv0oczpZ/MwFU9CvRds56Go9oog8ZUAo6b/wraX+pdShB2Y7cMDD3T6h8EdeLoLCkUVjFtqvc8zBC0cAqGLI4h1sg1y2iH+kPw8v4YpeWetTav6+QStTLFL9Sz7UtLAQm+jiOIY6XJ+RxE2ZFGKnRyFxcEA4m3mzxSjZIppTSELVlHRWTK8h6ored4V6cnm82Meh0rCBLsqVZW0Z/I0+8M9/kXA8cgD9gl2ovXDRm+mjVm62v2AC2wchD1jwOqdlLLxTSACTFUYqS8k5rWF8A+v0DLD735vsUsgIx5C9PIoT66uygmclLu1W+1Axa9iBW9en+Be4y0Grc3BTO99K+nLML8X8pG3gRAcKvGbUTCSxVAcX55UXNdZtNPosCrCjo8gHHGWle5A+GBdbxz+yM5qTN6xU/1mvg0FzrJAVLAInzL+++ComIICnY8+rRU7BAubV1bsoj6+yIQ+/1cyaa/qwigprdF4jkVtQaxuLmoZLG0tc2rfdMbSz7DrFUXMIHlvwz9x7HBqYhZiW8pjBmFCCzB4GuoLr6y0Q8gHn2osLKruIslMYuCbAbMUaW7AkHfvCC21OVpE9zmDImR0BB7y+lMC8A/S0cTcbdTgm6GnLxBIPCfHFZmyWXIg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 22, 2025 at 06:44:13PM +0100, Matthew Wilcox wrote:
> On Fri, Aug 22, 2025 at 10:29:52AM -0700, Lokesh Gidra wrote:
> > Currently, some callers of rmap_walk() conditionally avoid try-locking
> > non-ksm anon folios. This necessitates serialization through anon_vma
>
> ... this seems awfully familiar.  Why did you send it again after
> a bunch of people had already said useful things on that thread?

This is on me - I asked him to resend because the original was mislabelled and
didn't cc the right people, and lei blew up when I tried to grab it, so I asked
various people to hold off on reply/resend replies on resent thread and asked
Lokesh to resend.

Apologies for loss of context. rmap locking is important to me as it is deeply
sensitive and has caused numerous painful issues in the past so want to make
sure myself, David and the reivewers are all included.

Cheers, Lorenzo

