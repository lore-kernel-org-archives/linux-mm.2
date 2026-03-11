Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF59A1062866
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 11:23:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC9C16B0005; Wed, 11 Mar 2026 07:23:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B77A16B0089; Wed, 11 Mar 2026 07:23:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A59196B008A; Wed, 11 Mar 2026 07:23:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7DFFE6B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 07:23:53 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0FF3114012A
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 11:23:53 +0000 (UTC)
X-FDA: 84533547546.12.CECB5B3
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf13.hostedemail.com (Postfix) with ESMTP id C65F220005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 11:23:49 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=MSs1jmpr;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=qB9u1HsA;
	spf=pass (imf13.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773228230;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nSXgHFlonvaVEZ2o1L7FefWOlGjDk9hUvyqdHMR4D+o=;
	b=sGmJVo7TrZfUYbci2nvRyljLY61QZN4tT7XppjuQ9nThJl/r1ojAW9UF0hkDqI/YQzHMmN
	B39PoNAC3ZpGoJTSz85hvdZraOhA11zOK12k3oUlBU7MbjsYOeJfF6yHQy0fHB82A5OaGd
	ETu/TLK6nbVTE4bJPdswgzWTIraQgPA=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773228230; a=rsa-sha256;
	cv=pass;
	b=NFpuTcsbus8UkEQKxMAreqFRCRPNDb6oajnUio2E8YuLyup2RW5Bg8X7I+G1ZUFS3WSn5X
	r9BaFgT5Egc7OTgHYNeG0oNWMOScX3h5VaTarFxkuULd+X8o0ZzW3cCnYgSKBJ4llab772
	GSgGnVcMBi5GN13s24r9ZXvxa60vB3M=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=MSs1jmpr;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=qB9u1HsA;
	spf=pass (imf13.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62B8K7me1398447;
	Wed, 11 Mar 2026 11:23:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=nSXgHFlonvaVEZ2o1L
	7FefWOlGjDk9hUvyqdHMR4D+o=; b=MSs1jmprbsl6QjkJqwdWD7txuKbepx7tM/
	zAi1POcaH6cM3ZKzzREK8YZf0FKp1IGIrydtBf0ZuInU9XKxlesaJGBtzn6YcaDL
	kJqJdkjOU3esmoYcYKhwEa1UoYAuA/PgEjZtwLGO7AKEDt83tIjRzAkR72zB5Bxy
	8NnyzGMYgsKiBmwpyIltNoqvZG+v/svswcscL8PrnIqSjoj5zmq0MdZvPu4sKAKf
	OY420sGk8qs8hfzXty0wvL1znvGp0Ay3WvCwbzb+kiAl1lMBbheFo4Mlc/fdE881
	hN6ZWKuBj476SF2SxSDyxyjTfp7XzJTb/zGP9js9inWyL3yY1eug==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cu4str7jj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Mar 2026 11:23:42 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62B90FOB039620;
	Wed, 11 Mar 2026 11:23:42 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010071.outbound.protection.outlook.com [52.101.201.71])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4crafbf2qc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Mar 2026 11:23:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rZLm1EkS7Mev2JcLGeY44z90hFPk7nLrGDkNbXeXfIYIN7XHQINOaY7KrfC7AVZ/U944EDkii4XNfXpgP5onuDLYe+IdEiqrzl+xgjC9imv98dgxrG5nvkBrgKurxKgIEscEA7EyU3b4B1LhZgFXIbRpkV9I245MBEhP1VWIwouAG4meKhc0+pHOfbWwnF59VfjJ5sIywZCBe/ECybgk5dYpsuIqzD/C97KFL1bzoTDG4hEhfPPzfOlNPzdmJFTOPWOJhvGIh9zUFDbH05o+smCf7VPARJpHRKvt9cstKvH5Ntjt+CUs4kvf4kzyStiZ+ydkFu/MAKTN94dkVre+2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nSXgHFlonvaVEZ2o1L7FefWOlGjDk9hUvyqdHMR4D+o=;
 b=bR5Rw5bvpSvtlHbcc0q+ReDiV2XaPSHQJvt0J5t/UimwmuB8Ms+4miPBLVdCREfR31v0+UyGwWFax2thWwBnk69fw8Ypmhm6CqhsUTHTvHn7twgWqFWMUIMyRAS4gRtUVS3Cq31iLqAUO5hF1hHLg2pCdBpQhVdvfqQaOfk2Hyg3M09i3nYiFKRlg04dHwVg06QUfmJ9y2swVYj5C6PgPWKkbPglgnGfP7NIgcfDLX/Rz2/S4en+pJda/Aufm9DVZmqhJXnaTfo3TaJkH8Kvd1UnpqG9ZsQSiFCUF0wq+W4stS1PB1LOr3gI7ybtaA1m0zjps6Lz0+ChFOhTRb8Jmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nSXgHFlonvaVEZ2o1L7FefWOlGjDk9hUvyqdHMR4D+o=;
 b=qB9u1HsANtMrPDfwfMsGsOEEiY0o2IRJIm/S3sSFCD8R/v083OqnU7K/zZb+NoJlzn/x9ThP2zbmZ3RSmHVF6Xi8N+3l4yKzsYF0yLFZQaCgetxHYe1nHvA48kkZ4Zrw7Yc9tX0Y5dW5IPOsZtHMdWqyLDowiZVDua/R6peJPoI=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by MW6PR10MB7549.namprd10.prod.outlook.com (2603:10b6:303:23c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.12; Wed, 11 Mar
 2026 11:23:39 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9700.010; Wed, 11 Mar 2026
 11:23:38 +0000
Date: Wed, 11 Mar 2026 20:23:31 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Qing Wang <wangqing7171@gmail.com>
Cc: syzbot+cae7809e9dc1459e4e63@syzkaller.appspotmail.com,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org, chao@kernel.org,
        jaegeuk@kernel.org, jannh@google.com, linkinjeon@kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        lorenzo.stoakes@oracle.com, pfalcato@suse.de, sj1557.seo@samsung.com,
        syzkaller-bugs@googlegroups.com, vbabka@suse.cz
Subject: Re: [syzbot] [mm?] [f2fs?] [exfat?] memory leak in __kfree_rcu_sheaf
Message-ID: <abFQsxz6pp8H63Te@hyeyoo>
References: <698a26d3.050a0220.3b3015.007e.GAE@google.com>
 <20260311104855.102050-1-wangqing7171@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260311104855.102050-1-wangqing7171@gmail.com>
X-ClientProxiedBy: SEWP216CA0030.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2b5::18) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|MW6PR10MB7549:EE_
X-MS-Office365-Filtering-Correlation-Id: be1ca5cd-8233-4a8f-cfed-08de7f60a443
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	02djn0tjef4OYP+yy8N1ojGS2QnlUAmBsSqj5oGQuTV9eM+8NAAx+CytfhFxPZhiv9GBe47rRCZoNGa/de4JHVvZeeUijxvG4gJ/UdcIno96yx7e8GgwUGZS4DE2MtLNv7xDn+BgQKBOwBhpsJNaWKScX9JbCqp2xskZRSexAx/LsAYeWGT6AoonnvXBuNdqQ1gLj1YL1FxDnFBJNDRlNnCAMhVT8Vc9wVYFioaCSQejzpOMmqHnfSQr70viopUVgC242L5/aWOQ5YPkbtH/xWDiQlTT1ARtOH15rtfBJC2GLbrzrnSUx46zQ2EXHaaYK6kB5098Gl2MOW+lb/4doUcoKI0OQQkDCHEz3CeW3/lRHyWMI6+dx521e4uYXPSgDxC90iUyRMO1SUgzGvsk1RAqcmVecnsS6R0f6b2IcqdFmwh7H8otHe054yf4zlEiWGJXBILEkExFRWeR/Z18DZD1YMdcOlEu28FY5/jvRBN9ZGT6WWeZFM6pIadlEdniG97AlA6X1aV+hXnwQZKSW8fcR7SwvLWG8V6/HUfOK+/PCWqvENZNZEkAUOrFA/iI8zuXnPyfA07RJxLlWVNs9wr1wGAIsGWYDojjqAB4jhBOdkmgwdqgYU40DPEpe8wyLFiWjkvo2ndfxHjTXOIo1b5B2fM25QZ5ulGhWz7Hky7LNy/KwKfnihgANWjZBDHkRsFABHYJ8PTc4gOR6gootdLoalmAOH22n2o4fe7sKsw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JI0myKfPmKFl1GqWi+APOh3DA2PPHWB5lxgYBmdlszxudyH0NljZ4xsIY76V?=
 =?us-ascii?Q?WG2xbRHQqltuYnthqmXPmsmtCe0GqsxPPoREjmvlrU7P9ZhK+pQBjOimqavT?=
 =?us-ascii?Q?CoFNbO5Yv8kXTXExIwBf5B/3GCPYNY5C58iamKiKqTQJ/G4z1OyX/VgMdE2W?=
 =?us-ascii?Q?W1lFC4gepO+jNPtwcuFbxtz9wHNnvrDiBrs9UC/t/IG9nstuMLcx4/QJQnDT?=
 =?us-ascii?Q?u4EoB9QfxhApP6ZG3nn8Znh1biRNadrM0NvfPqsuapF0kfdF0Qa3UNECfn4u?=
 =?us-ascii?Q?1VLAoPpWx7BVgjxUiHKF/po1W8kHHpbUsGiFV0S/QRYnB6z+dX3oeRrEyK6s?=
 =?us-ascii?Q?cYfT+nPHdekPVbJ0QS6PlYddYVcU+Xl6syZyUD8NL94KuK9xOz4Sz6zsyoHS?=
 =?us-ascii?Q?O2hF7kwEXi8t8Ee7fMEGbJQgWHbCZgVIvSnVZ1JjuvSishjCLAZ37e9jELTE?=
 =?us-ascii?Q?bysJ/IfytU5qPjD6KYS8hyAfFKB2Ul52V125G5C/ZDHOHrK3E4gBArBgfMOD?=
 =?us-ascii?Q?TLOn2W5izkk1WpqY0xsFJm4nnHEqWa3y3T8EwhIgW1Jt1ryQsFKMZjBisckG?=
 =?us-ascii?Q?4MsqB6FZioJ+4VbSLHrGp0BbBIPNlmwDNietnSTCD+EOD2Z+9bxw6tOBn08d?=
 =?us-ascii?Q?HuifE7GNr+HuhNJdU9HL22IhwIg9JEw898OqiwYUhRl8SkA1o+pImwEAy99b?=
 =?us-ascii?Q?5NTF/8pTazS/oaWOE1deIU+Y6DgmMMyDIveloayOvMfZ1ojVqUdvF3KoyKFh?=
 =?us-ascii?Q?aRWd8yalIWm0w3fQntyLzKD8u37jAu61w1w4/2LcuIEZzDH7KABh905VOxtw?=
 =?us-ascii?Q?pa9NYtLs+ZR8dPJQJlWBXj1sQ+RpQvgEvMqU2o78Be2S9KWG6AYlRIWpKFHz?=
 =?us-ascii?Q?1Vo1Kt/DT5x9kRcfp74bJ2uKhYG2OVvGOkuH6osKixFw6o0H+eUGCXS1xA8A?=
 =?us-ascii?Q?6K883wdtuYZh7PgfXbA81jfMKm3dYE4+AGE+PeE1GHpwfmKZAiJN0SsWK45T?=
 =?us-ascii?Q?a0VYUgAekkK29rnP83+20F9rJZaMZPafKATbRmV9ZEsWk0ECsGPIJsERiCAV?=
 =?us-ascii?Q?l7iOCmraSTfBH9A4OzsrhJ/Ld0ysYGbymnOMAfytZUQsRCTZ3NEVWnqjmw91?=
 =?us-ascii?Q?HQjHqbAduTa47TkKkwCNHam5t5rGJ6412x8lbH9Xv26oYKRhFhuwm0S0tBqG?=
 =?us-ascii?Q?xHsl/+LsJLgM1DM+GzfglcaMtCVL47iJ6uH8ZYzu7KFdKWj4RPPlPszfOh2A?=
 =?us-ascii?Q?KE7EXjVSNVXxuVa0GoSTWcp5RYvK0uUHi4WmfryuN0UqArSejJHkurm8rt0Q?=
 =?us-ascii?Q?Xx8ot5/Wa9AlFdNwGsq1cC9paZlzOcavKXrFpUa3yo46rq0l7AyVQLj9ji6e?=
 =?us-ascii?Q?X7uhuSxLfsELMLo67i7hfcGrUQ17WsPjgK5x0Drjfzf5Hv+3hPtbXI6LNpkA?=
 =?us-ascii?Q?OrKXIcr1PgYtNSWlOeTEUEGqFi/KliBkIStDFPrx4medkmiRr3AlxTbk0Qd8?=
 =?us-ascii?Q?qIh0x3ure1T4Op+wLYHXvq6dWE8oBkvsJBD9+JkWY68kAHBJ0ZX+7YmSZe9l?=
 =?us-ascii?Q?5con+Hs9Mptj6kxxN7qzUcxOyYQLJKqJlawABrzMYxAFhwcSu/zH3vb3PmFk?=
 =?us-ascii?Q?5S8qo4Z8JlUWYkgxW2OpXSo45ju5ZW0z/2oKTnMcbXGu7dVh+Qn6SfKdEi3W?=
 =?us-ascii?Q?wmGgno45+20COmXvQ3L8HYlUR2PeHmPeXPTCe1dCKok3R6YYDr5YgoKVBmOi?=
 =?us-ascii?Q?q9GWkRjHCg=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	IUDLyR7RVY/uTMxy8trq2RBF85EPIXvjcOZWlr1HsMXiC1Uu2LVYyPjffQc6zG3rnOUk9/af4aqbDzQ5w6pVDV7FaJhZYiZJUuSe43IN04DZotu5Nm2QG3muikwf7t1phA045EfvQzbo81tijlUQwY+/glC96b9oq5tCanX+wZQOqxl6WLfQRS8JC/tqQREdGL6yQ4hAGLZKCRNg3YJ/2NmD7nse6TvT8xgs+unfYnCakOTTat829kicTtd20DNrKQCQDxzTIAeVLid5FjRHCkZdenrrh/LJOwt1soYJaUJoFZMGi0zrZIlbH3pNRqKDlLTMVCnGsWLgLAiSkFr5fQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	TBlbFH+1NHLybmDrra7IHIjPRzoyAe6g9hxM0QClqyaN5vXvuumjbcSKs2MRDKMH5ukzbFTuy5hpbozJhL6bRCIfOo+eAV59zxyWWc/9JkiyUIapBzg+VMwCKQSPFk3bWjHLMyR5Sk4+e+2ICDo+YXEYMvDndPjY+KnHH3OurULaf7qxba/ng/IWrWnMYTRs1nwl8Y1KmKDIgK3nSLyInBTDL3487+OPZBjsjJdvw8GPnnDRUm61JqagwNhhC9amHKbuGA+qo3sIWTz19QTPz/wTrHsxBk15JmTI4XIRro3gYEeI9KsKYhQKjPnmYRlZUus+VvuIyfslJ+s4FME9TxeMxyq4xXsaDT8PB94oT6lr81Im/99a7sG/sRN7ECk1/TlaVZ0c5N0xaGriKD1Gd6U97fTgtLe/Bmi9n1HirQEgcTPIhajKXBXEs8aIs385dq7ywbG0UwoHReGMWHij4l/6vWZpWj0yLDdgP/r0+CPrUCvReysQnqSXj691gvVMglqFOiMvy+Dpi8MW2ro0C73FTDNyCFl2IcqmUmqzHk+CKNmHqxlL2EPane/C4OCYtGO6B5EsZOuS7pd0nAppMYzweDvzG1vxhCBNSS6ATNY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be1ca5cd-8233-4a8f-cfed-08de7f60a443
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2026 11:23:38.6260
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B9yd/nGA/BGl2GbS4i9clVnao9UEYAyxzHqDipi/yEbMHVtPL1cy8qvuMwM5sBxBD8KVyXcRWcu1Fv/Nlye8VQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR10MB7549
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-11_01,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 spamscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603110096
X-Authority-Analysis: v=2.4 cv=Fv8IPmrq c=1 sm=1 tr=0 ts=69b150bf cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=Ef93L0gbSnvVx2YvGFEA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: JRFCWYAn0fOn7MTCGCJDUNsbPgq5kg2f
X-Proofpoint-ORIG-GUID: JRFCWYAn0fOn7MTCGCJDUNsbPgq5kg2f
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzExMDA5NiBTYWx0ZWRfX6npWWazh5mlF
 TOM9EydbzzTTPqwjJNNw2AmJPY61dSR9hfqFyarIESqNptcWjFcApSqra2YzhAzqdXniN5V74T0
 qNqXNBa2u+OFiyeFMMpQQrNKu29yCx1wtp2zhK/AYzYVb6jSKwQhd51xFfTgE4anfjeo3Io+jJ8
 mFz+mKsxge9U0ppI7xDcpU7dd5Sho4xoFRbu3aQOjuCLJ7IJZ+1poEkQGQraA8UV03KVLoXGr8T
 3wL//EoZ6+qKuOpsJp4EqtJzBQcvDSw39WNgCGGo5JOF38EtgHz4PkkxLIClEDG05jowFGRMBgY
 xQyq/o3+7CCxeJ7c2QOiTWRmLIRDeNPyxSBifYcHPAvzHgUp+qVCuyASXoBb0a/5VzAP8YewVEK
 9RRvGU/pjEbpMbmiKL0KB7DMBqf1J8uCp6vp5SBKJCY2HcODvxZHaw9mKfAxNCe4qczo2MjJiSk
 gYbjCx+W83JCqPrmDPQ==
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C65F220005
X-Stat-Signature: ygfinfyaat5cp7tq7k8x1baiz57n4rqr
X-HE-Tag: 1773228229-460705
X-HE-Meta: U2FsdGVkX1+iPPPaNlG0qmmaWrm2wVoxkP0db+lq6W98YsodatufWft2CmcDfddlOkiU5H5lv4HK9oTzh32akVjgFwxlzY6Zt1lESKXTogb98s7X9NrIj2Suwy5ujLHQFXMylhuUfUDQzzB2dA0XeFZgNbuY5W+n+Yf0RYq5oxp5YE+ISpmqzqsiAg6pt5wHdJ/16gZFRmTQN584KimZO+nCPUjNPC8QNN5NuNxppGTqfmtS6guVDIk2BTdwpKPVWGtVW9ZSKV5v97NTnxLrakiMddG+jS32gZHUFz7kSxvVFSd/se4DXNdxdcSj6vsyH25hrGriSJu8oPTXG7ewJtUS+iPuAsi7bWrNibw59biDPfreSXVAEX+h/zMgZR7pYL7+uLoU4nmJqpOcViGSj6QGnm8gIvci+sO70dhTj8r8me+K+m67y9e+tzjIUtoG/05QAA7MzNunmy/fKXoXdEYarrAQ5d1LCDGbLfF5Q2N0I9GimoO3WQjBjeST/5MQnmw58D8fAQWR5cqelAxZxlFHoU0tE+xD/m+NMzQXKtr0olqQqRnToZO8cOY+uCWHMRzdYRCxLUN+b8Mdny/trWM6/4LL6IxG10I2Sg36LUkPryI6gPL+R8nIempSaOjlB5VwExvthLIsP2PYZODCVr2yCJjeNh99rszo2b+qhAWaPYilSsL5y7+nyDswPW1YhK3d/ZnsIOXL+Ff924Y9TK0ETtPDlu+kANPmyyQXAgx5T63rIEsLjCvRxxFZZF78qyaUWaHMoJTvjxb3k4NveTt8fUPsT9+Z73gLYFgxNc1ZbzBtFC+uIHVAWA65nrzmAiLumZc/BQ69EtY67ZpjA6BGnZYiuRx523M42uXyUgkb+lbgjd4/Zcjr3NHYv1O58rUQDoH42ruPTenNEy26xxWnoz8yXYsk+2HP1/ZZu2zNK0ru9r4BeG1cR5li1a2kR/C1Z+6CkJ2Zpzlxs7f
 GM27OPpg
 XwNrOlmpZeXy2jWx8UZUJNSES6zNtX60dwU48v029WhwpuARiA0PwoM5N9sNIRKUmjjyVCOEjyN6MfbJOyf63wRYCTyeC5gM5lD+qxL5VqZSA42hFlmm85c7pWJ99LyW9K2X2838hojwUTt/f4SA8sr04g8mtBF8rd1pB9Qm9xxweytTb9fTLjVhSK/tK/45x0iGitvPjxfVmYlSIReQp2zCRj/DVcFBkZQhR4+SEio8a5waI7rFp2kBvnhTpaqkCdQMVc+dSiekzBA8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 11, 2026 at 06:48:55PM +0800, Qing Wang wrote:
> #syz test
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 20cb4f3b636d..73b2cfd0e123 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2797,6 +2797,7 @@ static void free_empty_sheaf(struct kmem_cache *s, struct slab_sheaf *sheaf)
>  	if (s->flags & SLAB_KMALLOC)
>  		mark_obj_codetag_empty(sheaf);
>  
> +	WARN_ON(sheaf->size > 0);
>  	kfree(sheaf);
>  
>  	stat(s, SHEAF_FREE);
> @@ -2828,6 +2829,7 @@ static int refill_sheaf(struct kmem_cache *s, struct slab_sheaf *sheaf,
>  	return 0;
>  }
>  
> +static void sheaf_flush_unused(struct kmem_cache *s, struct slab_sheaf *sheaf);
>  
>  static struct slab_sheaf *alloc_full_sheaf(struct kmem_cache *s, gfp_t gfp)
>  {
> @@ -2837,6 +2839,7 @@ static struct slab_sheaf *alloc_full_sheaf(struct kmem_cache *s, gfp_t gfp)
>  		return NULL;
>  
>  	if (refill_sheaf(s, sheaf, gfp | __GFP_NOMEMALLOC | __GFP_NOWARN)) {
> +		sheaf_flush_unused(s, sheaf);
>  		free_empty_sheaf(s, sheaf);
>  		return NULL;
>  	}
> @@ -4623,6 +4626,7 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
>  			 * we must be very low on memory so don't bother
>  			 * with the barn
>  			 */
> +			sheaf_flush_unused(s, empty);
>  			free_empty_sheaf(s, empty);
>  		}
>  	} else {

This won't fix any kmemleak reports because kmemleak couldn't detect this
in the first place. kmemleak doesn't know that those objects exist
until they are allocated and kmemleak_alloc() is called for them.

-- 
Cheers,
Harry / Hyeonggon

