Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF471CAC599
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 09:58:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12D718E000A; Tue, 16 Sep 2025 05:58:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DDF38E0001; Tue, 16 Sep 2025 05:58:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC0618E000A; Tue, 16 Sep 2025 05:58:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DAAE38E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 05:58:54 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8958616093A
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 09:58:54 +0000 (UTC)
X-FDA: 83894664588.27.F5046C7
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1DB3C1C0007
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 09:58:50 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="Y5W9e/UU";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=xsgyFtuE;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758016731; a=rsa-sha256;
	cv=pass;
	b=MomCIuOoCo5NGlV4NxqKiJusPO8/zMUKOCc4GbPFrxriXvVdDz32uWtcLmp7wTM/CFHQPE
	JJwVL3v1rE8+LxPqSPRb5ALhsZjOqH1Hy3XXukTOYwgmcn9BuZAbv6m9bNw/zh7XeJjSvi
	1ytzXky9jV7PlvdwPyV1kJFZ+A8+ouY=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="Y5W9e/UU";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=xsgyFtuE;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758016731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6icQ/YfvyIDtaBeNWH0k9n2hJi2Yam+XWL9yketywP8=;
	b=u0iN2N7f3sptkSbygSJX8opzsI/mWA+UQibWQ/70xhCzG0OAp1a6AF1n3oFv2NrJSsTJBj
	0O5r/wDncr3Zszd6VzwlB0GJhf01YwYytG/Z4XAeOGuJKGMukzkhOH5H5jg4GJgH+6imiE
	5uZrDvm9NifvonysjcNBy9+HTt4l/wg=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58G1fvIG002105;
	Tue, 16 Sep 2025 09:58:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=6icQ/YfvyIDtaBeNWH
	0k9n2hJi2Yam+XWL9yketywP8=; b=Y5W9e/UUChBWtBFy4RabauUHGY18Nv9Rca
	igR24RWIt9/RlixhgNhE3Rqe/LUpoVoTn6lwqXBgsRsIk/ECfr6/3elZRIJ/nJH/
	GKgqayD8Qkv0hGUDVCCKctuzuU19Gtg4g7MM3lBgi593chS0G2dbPu1+KRaZDjt4
	xG2zvA29+++Dbk05kZ2OxT2D6wGCt6J9jc8M6C96K34I9Blc15/2fQyXA0XsqWR/
	+OMAGlBlY/qtCWeNr86JuPiNwQpW1H+M8KXlKQqjKvwnHDv9+eGM/bkehUvoh1k4
	Do0LqQHYnGP1SjUd8Yxp6kF8D/QTngwcjWBWbF78rdmopnJNAozQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4950nf4bbg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Sep 2025 09:58:44 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58G9cKTZ028746;
	Tue, 16 Sep 2025 09:58:43 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012047.outbound.protection.outlook.com [40.107.200.47])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 494y2c5cjv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Sep 2025 09:58:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vymgSWgBpqkvtUIBGo8E4m5stkoUmPJXNp8/BBFBKiRDpveIjpPdxdvWbLA4ucOzY74VqvI66bSeOWFgMDIPjPUPAZJBPuSjs94/AzQyGLUebTpGk23sd9Flh4OMZuSgHPdn5y4HZfPbAG+py3DCCn7BJY2QA5qbSeLvvmqkZiCXKkthaly1LrAUBJOG9q8hWBcPD2RIpiOjDmD5i3DsVmfT3WLzVtqVfwb889gHK4aQW/X67LKeajyAR5AW4hhkWFdNyvzEX0mVs2lLfNtkabb7eH7FSX/yyBKDxcYUWuC00nYcUzZavwn7V1quYDPnvNuNX3BYxqJBElkFvlOLNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6icQ/YfvyIDtaBeNWH0k9n2hJi2Yam+XWL9yketywP8=;
 b=VaIJwGMbtIBUooKnSnCxckGM95Jj7nT53TnDWAY4B3+gMFkEnBWynRcK6LN44ebmRac6zHPZiaQzI/qnprNZv8zVFVuI4MYkK30WLCg8Bvhw+pOwUO3XYa/guDdWet6gZyPqrmAnVURcO9WIevFyj7uyGN7rQXWgwqeVU3ADERViQarunXq6NIlMk4B5MzBVJNQWe+WzYNMQDKNzcL5G8pz1esxFtRyLRpnU18UimPUTSF+sBzkLNix/+YTEZ7/IoDbOl9j/ZdxfX4s9dz+o/lusWCuw5Oi3L2JNkla0XAaLeo8SjPoaIBFiE2AilA1LAbMYijUI0TexmYNVX5osQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6icQ/YfvyIDtaBeNWH0k9n2hJi2Yam+XWL9yketywP8=;
 b=xsgyFtuESBJ1woRluy0viQvwbJPUqUqoiT/e4JSloonQe6EicU0GHFmL9hTlzRBZFs1B1o4GnO8qhienrREBeuDC05fMzWOcU9SOWYNnM8SZ76+GuY1Rkc/22T6DsBO1Sq9/RMxUiBJNe9ZO13cEpZz3DqlkJgzAxQsSBRfyFEs=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by CY8PR10MB7291.namprd10.prod.outlook.com (2603:10b6:930:7e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Tue, 16 Sep
 2025 09:58:40 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%3]) with mapi id 15.20.9115.022; Tue, 16 Sep 2025
 09:58:40 +0000
Date: Tue, 16 Sep 2025 10:58:37 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
        akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com,
        baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
        npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
        baohua@kernel.org, ioworker0@gmail.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH mm-new 1/3] mm/khugepaged: skip unsuitable VMAs earlier
 in khugepaged_scan_mm_slot()
Message-ID: <8cd717a3-b149-4eb9-88d2-ea4b9b1112f5@lucifer.local>
References: <20250914143547.27687-1-lance.yang@linux.dev>
 <20250914143547.27687-2-lance.yang@linux.dev>
 <bc86d5f7-5b23-14fb-0365-b47f5a6f13c9@google.com>
 <a0ec4014-384b-4c04-bf0b-777c989eabcb@linux.dev>
 <ol447ofo44vwtyfwg3zrdtcdlkfzzmx4rre6qhyotmwvecnec4@usa3nonuk2sn>
 <2466c068-ccd7-41a1-bef7-6f3fefc6ff55@lucifer.local>
 <3az7vzkhpa2pup3td5pbrek6ti2fij574qimtnbpecums7ixyl@upabkyqmtiaf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3az7vzkhpa2pup3td5pbrek6ti2fij574qimtnbpecums7ixyl@upabkyqmtiaf>
X-ClientProxiedBy: LO4P123CA0136.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:193::15) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|CY8PR10MB7291:EE_
X-MS-Office365-Filtering-Correlation-Id: e410eea3-8156-499e-a469-08ddf5079cbd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+UEHiJjNKbNrEeuKo68gmrHJ4hRcxj7IVE/wex8ArRfKUPsDEwdw9TdVxb1U?=
 =?us-ascii?Q?8T6ZaUFQYdGpv7gtRXmR5BJ94NmcXFD7QS9X5oJ12adxpOVEFr1sBDcwdKQd?=
 =?us-ascii?Q?SC2cIyEd6uG4NPGpvOf3JjmzEoUBqMoUxC05Y5Ofy7dpdMFhaeNUyQ4mQia9?=
 =?us-ascii?Q?TWHUASjKC90jheeYJQfnrccPJThFY/29DWAQs3BmAYiwlpxzV45MpT4Hgp9P?=
 =?us-ascii?Q?Q2ifmRlK77lt3HcjYmzkqSKzDu1f+0q6ubVwTw1O6cYRBvxO1OZ2tug/Xsu8?=
 =?us-ascii?Q?RrR4kU2emAKMbAp8HJnx6GyE52zj2L40aZiWwsTJXNMnZWsDTawEvHVJA6x0?=
 =?us-ascii?Q?Y/cIJjuT/F7c48+L78l8yyWHcwQGVp7RjMECrEMUCHA7kTKBWIMKEs4EV6zz?=
 =?us-ascii?Q?yLp0W4+IQuNYEuowTHCoQYTqaZJvPY4JVRy5h+aWuezcWIdlP4WYk5XHXsR8?=
 =?us-ascii?Q?DxkuroYIFXOFGwMd2Vh4G1fDTNv3J+yz5EkJDgagEkG/1PfKEpRzSk3QTjUV?=
 =?us-ascii?Q?GZQ54Li0o3et7Gb6/o0Bm/J4LvVQn67mMgOM1LnmbZTZRD978+ZVYXMxQqJr?=
 =?us-ascii?Q?msQ2SXc8C9zu8bbdZ+ZW5k1iYf4kIL37SSfR8dLTQsc4UgYu9VTQxvZBAaYS?=
 =?us-ascii?Q?SQ6VpOPzDHGf2QclIvUKFbmiqUw/9Qnr203VCSunQiEJbNIe82OIbgVOvbQ/?=
 =?us-ascii?Q?pkZmue4OFTrPXFpBtbf5P+WpmmxMz0onu+vKZuRydznsVT5URKzwjIk5RuoS?=
 =?us-ascii?Q?OVHo53BJKRVnnVlhzR73C3dolChzy1TpjNwpsWuygBaCKnRoJ3pUfLp3a5+3?=
 =?us-ascii?Q?INLlxOt5DL1wIlCiSlIVTB6NbjPVFNadAAtrgoxhu1yR+yQP+ItHth8G5r32?=
 =?us-ascii?Q?FA/5onmGenZ7i8wRrk/18wVyrOE/T7rKH5Zf07JE1Lj2TArsECk24o8piOrX?=
 =?us-ascii?Q?PzGbZb+HLvQVSX/Sn68ZgQ0+YlCpAOkBVDUeOgLxAYYjbQpSFRkAta/bb+xv?=
 =?us-ascii?Q?yWReRYc6rUwZzLNV0Y4Y3SK3KmgiaDwguP40R9wwQQNYPRCwgkw9N6TOkanP?=
 =?us-ascii?Q?S2JgbsQILXgXypfydLf36f0ciF0p8+Dg3NUASPfqkUk/0kGxFRGQVNmb3tug?=
 =?us-ascii?Q?Q2GanPgrnJvf4MbOu+sM3HYJF7G6mwjV1kPEd+NuzzKYFbDN2XnHakkEeIhQ?=
 =?us-ascii?Q?ojrng1R1FW3s7Zq6YnJx3py31MCtPLiwnkj4/qb031WHg11NaVdb0wbDWcz4?=
 =?us-ascii?Q?avJiEHPMoz3UpX/HKTzldyyfXSnaJTjGVtAwVarzebeMOSUwzIgh+ju4qpMD?=
 =?us-ascii?Q?HRtKaXRz+TYH1G4jfIIZqFyXVQ7u3XHFp0Rb9aUmgTGmgwdYXcwxfPauq/R1?=
 =?us-ascii?Q?lhUVkSxen6emWxueISuhQyccSqPA1hpGNTajPo+ja7OHhHQV3Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6e7NaLcth/9e80hW+8uguwPZNk6CMqlB+YkmtKX3+ZYYHvNR3kWOXsmMjBVW?=
 =?us-ascii?Q?g0Q0RPrN8Rij43+qhsyeARpvkousN1j8Oz+JNM2p0gMySA+XklV6K1xb2OfW?=
 =?us-ascii?Q?0IhMo/P7zMTB0oDpaIwo1UKs71yQRqHyJDUhjMPHRLs5Ik+q0mv8DsxtZdjQ?=
 =?us-ascii?Q?1+BNNwgfX8gGP1ByjgVvWKttr+CIdKa8BadPta7zrhGqNmKLdqf++QNq68Ie?=
 =?us-ascii?Q?uoqAQgy0/AvfjfRW0r8vyS/cpLTdflr8kOSwJK1UDMzZnzmVGXHaSKW7DaDn?=
 =?us-ascii?Q?MUnwRveVv4HI0UoTx3B9hyGhbChglUkc1djJ7sXuOo33HTgsZ5Jqi4/a1Rpo?=
 =?us-ascii?Q?yfhH5N5x7YMGSDPGR1Uul8TDRfZhT3Wvzw+kzLeB4hdLuJpa4RNSGOgU848E?=
 =?us-ascii?Q?WVwNfHuIEwiHVpRTysh+neAaWux5YiPWMULGMtQhTDqdRGCXuDNqalDHyPwM?=
 =?us-ascii?Q?sjRdmNDmJqObAuk+FnbchA8v7AEDszg8ggmI5a9EwzoCsBmeD59ODnm+AMA/?=
 =?us-ascii?Q?7t9CS4WnLPqG4c4WoZFYjuUCJpaUawx/kfVEECfEeDwXuiNTm1Bs8uyNIUNB?=
 =?us-ascii?Q?BPw1IMIamcwFyWjEgANzbgBFQXJLClblIjmyB+gjMjDVbjLOWngbfFkynjn2?=
 =?us-ascii?Q?JtCH5TGfgoch5S67vLjx4ZYlJ39sswdAn6CR1RVK29J3mGngrHX0Hks+gq0j?=
 =?us-ascii?Q?1ek+s6r7z5hlZaEP9kT7rdLShilEaG4+I4BUIK4g1YsDBBMs8gePdye+Jtbk?=
 =?us-ascii?Q?cn35XCPU4OE8X2UvoofAHH+b9fCSCV2EX6P8Xfh2X9qBYPzJbUPY/cJnImFF?=
 =?us-ascii?Q?BZzV8NS3sInQBDRPX3p0JaurS+BjH9EGPrjPSY3UVRhq+HL07M9tiX42/Dp/?=
 =?us-ascii?Q?gZlKRyB2yi3yXBhJZY0InkuGEAxNhlQpR7X1Idyxpo7DnOSnQFciFd2Knjtd?=
 =?us-ascii?Q?9//EWAJQd+PJd6NYiiytTS3pzD+4829AaCeLY1qDebFBZu71iaXrR212tgxQ?=
 =?us-ascii?Q?ruMtBQ6DJ3PqcOxRfcRJLl7Lp8ZR+6EWGaOXnQlRKPiO2kITLQJDlPrw0vHF?=
 =?us-ascii?Q?LR5TbnCd3pk4Aa+s4WwNTGpc5cEX+RTs9/4zLUyHer0/X6S2vYj15GkqdorA?=
 =?us-ascii?Q?JS1/uh4pRcEIE5kLzvi0cGo1nWqfwuqQt7HG0jZJEZwGAZvQtpEn9geyciz0?=
 =?us-ascii?Q?BL29rKminp4KUiup/sn22xVxDvkpKinWEyR9NOfiE09J1N4ihfchIA8SJREc?=
 =?us-ascii?Q?XLNgiezcBt1VJG0h9Zi+p7tg3LmhQmDOgZ6uu3jK0f8zxj+1AjrALlcokZSJ?=
 =?us-ascii?Q?MgAX6bKMGVEt1Ws4b4+eWeIwxPC10/+vUse1gRolrmYWJqs9xvaXCkgYA3DC?=
 =?us-ascii?Q?GDL+OwC8m0TeCGleV8pJ2SQFk1RIjXaRDyNRoCSr5yyOWwg+csO1AfSsI0u6?=
 =?us-ascii?Q?CkTMEfXTMEivOkO4B/JStal+7VpA6xrYrMi61SO92O/WDGbSkohKKv8iBsoM?=
 =?us-ascii?Q?gDYKxG3OOgyyMITIYnYL258MqtoIn6jCXdgA43NRlgF1z+cHDqf+Rg5Hb6Z+?=
 =?us-ascii?Q?sfJKzFNlGU2R9E77642GigqIwO4jneuUzpc7B8U7/LcaCnDKIuMr+lEP5hBy?=
 =?us-ascii?Q?6Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	WiKPsTnu4Rd/NbBWEIymC5Wgh7waFU1l7oP1eLME7lubI4CjmBbu4jkB0nazg6JnRfJFqtp7JHzjQ/OrStVPw6LauqAFH7MpDgBDnDyVXMANcE5MLGCmIM7fTphrnPIni+96iXUuqsj7ySLIZC7ot/qhgxLmzCzBcfHWdPSH77M9L09gha3cgnwVsC+bH/fs3vv0GLRJBI9Z7Rd1BzKJ/Bk2dAaz4+uCYwbtvAas+wK+VieSm6usIALzEV0MaMDI6AffjWjLImVcUou/mHk91kCp+/yYt70H+0eSZWlIltF4jPNMGbdDx6jugfMNgIgF3tWUI9oy1dn5KNXo9Fv4uMyUYJ/rhSDgLXmD0Lyqvzl37HEj8Q1qMJqk7InMNcEbCuZ2bEdqn71FsRDV3AzChOupsgOOn0Nx32bbGZ3fE3GogNK+KFiG/q0GypurTjxA38JglzDQxytsWJskYnT/rCOKQzr07kR9L9iRbo5Rk295NWzUpAwW4qIGCqsMxQ7OiHxc5rMikXwfl4HS5xzVyRd6cLJIXDNdd7B3Cdyb40K65Khw5Y3vvU7YHxwSWi+3CKWMSMq5lfs0jnt6rgT5Z4Vpkbm5Pu58hlmMKlivS0E=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e410eea3-8156-499e-a469-08ddf5079cbd
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2025 09:58:40.0202
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0/vWmb+8/Go+MTtJFgggGtLBNrTNlZHzEvly2MmIN2Kqvbjwb96HzLdZgk35tPHzEvJZfsLskBnFKKxYi4Q573pZZ6Q/ds+hQwnZjeYz28M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB7291
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-16_02,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=1 malwarescore=0 spamscore=1 phishscore=0
 bulkscore=0 mlxscore=1 suspectscore=0 mlxlogscore=192 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509160096
X-Authority-Analysis: v=2.4 cv=S7vZwJsP c=1 sm=1 tr=0 ts=68c934d4 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=7Be9DysMmW3qWg5aml8A:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTEzMDAyOSBTYWx0ZWRfX1zf1DRKzOjl1
 WyaAdm1zDDgXPaOQ+nv5aH5BjzBaJb0y/66Se54aLI94GTrB+NQsKy7HYhkm6NKWSfJA+w1yOHB
 irWNPCt+FisOokSvL3PDXOSVjyrvp/sBq/2x4fmnBn1j7n4GPcQKOU1wctxk+jArBrTkBjZSTyq
 vH+gdEHjY1Qj+Xx7wNg7A2uWVifAzORrNCFJwlldEn/qXioayxLUKBnLlrg2zo4/KPN5hAYdr9d
 jC2hYov7/ilqfqbLYTO7kp8N6b3/6G2Zn4VbHmiM9k0/H7qaQBnBgWDeFPjYK/7kE5vobX1rdxt
 FQcuwHQk8AhjUIdBjWGL/KK+A8eqX6fldkqN6/OhF+b4j193rZZXRv0OKmTZ6nS3MtluiNEFVKF
 4P+8oVq/
X-Proofpoint-ORIG-GUID: tdMcSKih7S7lXZkYDIHZsYjJO8WAVp2_
X-Proofpoint-GUID: tdMcSKih7S7lXZkYDIHZsYjJO8WAVp2_
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1DB3C1C0007
X-Stat-Signature: tabpnmt5tqnp51ruhjniynrgnx3qum4q
X-Rspam-User: 
X-HE-Tag: 1758016730-305398
X-HE-Meta: U2FsdGVkX1+1cISRMWu0EoCsQev1BIaZ+HeFNeJFGU7f/GRwLzaZgBUvclJsQlNqMVsEyNpVqCqGAEopJq38Yd9DeQpf5KwzHc0/BVFoGcCTuWMXAFEYDGnrnRu4bt9RaTBAj9jUT6w8wx3ReNmDb4cOMQIgk+Eq1Y7Fe5alytuA+9MjJCGneFM4x98oEPwZCmzDI5pSaVra415Ika5SXs/iF0fW99AzZoc1uteDxp47E8X+6FafoISRnkVzTkZbvPKzT9Qeu0gKBauR2oWdC4WCWHBbmjVUFdBe3FI+e3qDE/W8BofIwmSAVRKomjvoOqC8xoQeLak1umMq44vGVURe3dYXCxyKeWSolM7FJDQY2zrso8fjao0YfzaUmEMXR9KooWH6I32oLYNw7qUyYMhw0AVqYsIen2Vln00uoPO8aMX1BAOmmxk5qBC0SOCpzs/yTer8RAhea7fnj0noLLforBpOaNPDF93UmszNZU2rJj3jSjAW4fkO2PZ+1KhZngpIsQ4cAhlTJvRKSzMn39RO6OLaD9K1moNVVD0cBZ6dov6RBofZY6bE/V82jlrQsoZt0XvIbK6rhqOkRCl2VSZqZ58RG+dVxctW2BaEDStVMfQMJlQLjlUVnq1e6F4kfEQj0MtXwg34D60MxLSs4+qlX3OEX5VoczS7PJhVqw3ThPuaYQmaApMdip9bm7/Td7dZC4AO/qNvXwPc89FdjPptSrtYCaGr7fzt3h0nIosQbjwWCLMUdSF05lPx4QRFeXom19e00r97rjbM+OpJsCwA/OEdOQfj8UNtd8cXxVuQhNEjQdE9RMZsF5anaUNeT+n+WyqghrynSYXDm7mmz+HD+L2g225Uz6Vqw2AjXJe/OLebOyWHEFRVKpm1SpH8arGJWpqN3ncg0sgMGZY+/mm+YM4r5siNmJb8SNZLKP4XiZiT4afWEWzxipzkBDR2Q50ZwsqH9iaTD2+siqm
 FimHIUgV
 y9xbkErs0qqi8DsX+Lu0O3gQf3aYcVWQXLWRUTcC9nvzVTeeu8ehcnW8YKP0x9+lmMynxwLA2plRqofJ3DQYbMvW6VfIi0M6uxJCQHBgoeMMYZkZcPu3tbrrdgmZfKg90USIl2i3X/0LCm/oWn4LaUIdrtngg77F0ih6Z4joER8eTLZx5sQK8bnAqBuxujCMP98a5HPDXgSS/nbVTUPH/XqGnTgtPZE0YxEP20vTrWwF5lAoqgl6WEVTsz1h5/7m8Siay+d4JN9xhcjHQhRfN4IuwaFaobOvChpYVsRHh0CDzI/M9NTc3u0si4licZGvLq1o4DvJWXmAwk7zz+TpegDJNmwcB4V7QkWz7D7fd5oMLMPm5ebfbQSkUg5l59uXWh8aH/Z/YGNRM5Vj/JkMjCRidOOWslCOY3GIt2XNv+QQlvjI0eO/zRLpXy2fxsAAeLed9AN2Bd2Iz4MwWaVTpwtvYHvhgKOgbOWv5dofN95yWXuCjqfwvRI69MXdzIswMAiLKSF5Y2gu6B2ep/d2/XR8xH608tUwQuWwDomV14euMNJ/jkEjwvPxwsQ6HzuFAVNRpP73ZtgZ9jvwDdOZQYwWy/UERXrVFXnC+cnD1efSMZNL/RByfGCUEPMWGf2SZRzsfyuwrhzpDOVnTzxA//m9B0LTDaPfzpzaGxL5HJqoF/92k7UDqRfpadQggTJfR5uNQTec8dZf/ZCA3FTouYmN8eid5rH1v+yb5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 16, 2025 at 10:48:22AM +0100, Kiryl Shutsemau wrote:
> On Tue, Sep 16, 2025 at 10:39:53AM +0100, Lorenzo Stoakes wrote:
> > On Tue, Sep 16, 2025 at 10:29:11AM +0100, Kiryl Shutsemau wrote:
> > > On Tue, Sep 16, 2025 at 02:21:26PM +0800, Lance Yang wrote:
> > > > Users of mlock() expect low and predictable latency. THP collapse is a
> > > > heavy operation that introduces exactly the kind of unpredictable delays
> > > > they want to avoid. It has to unmap PTEs, copy data from the small folios
> > > > to a new THP, and then remap the THP back to the PMD ;)
> > >
> > > Generally, we allow minor page faults into mlocked VMAs and avoid major.
> > > This is minor page fault territory in my view.
> >
> > Hm, but we won't be causing minor faults via reclaim right, since they're
> > not on any LRU?
>
> PTEs are still present when we do THP allocation. No reclaim while the
> access is blocked. We only block the access on copy and PTEs->PMD
> collapse.

Right indeed, esp. with compaction being allowed for mlock, I agree with you
that this patch should be dropped :)

>
> --
>   Kiryl Shutsemau / Kirill A. Shutemov

Cheers, Lorenzo

