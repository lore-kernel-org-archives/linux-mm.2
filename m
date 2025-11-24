Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EE24CFA466
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 05:39:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4AB46B002A; Mon, 24 Nov 2025 00:39:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFB3B6B002B; Mon, 24 Nov 2025 00:39:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC2B66B002C; Mon, 24 Nov 2025 00:39:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A8B896B002A
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 00:39:42 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 46EA9877E2
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 05:39:42 +0000 (UTC)
X-FDA: 84144398604.11.E1F56EC
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf30.hostedemail.com (Postfix) with ESMTP id 865428000B
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 05:39:38 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=qkvP60ZY;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=UYTpXLBf;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763962778;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RMxVW9wipJKKtt+fycjOF72FZv1v14538nMV5eL+Hic=;
	b=c7wMhpXISkNwCNp0Ds5zTk9TNbii2si4rY2A5/uKtoVa2jwJCd9xEdKw/jj+JdWvyCvd/Z
	R4Zw57w1EmM4OyiivruBfCcfWDikgqzIzTgL0kE+u9EW6pYw8LayydqrGS8UwzGEBNEP7H
	kodK9wwu7maEU00KpvrN+DAOFORcG6w=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=qkvP60ZY;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=UYTpXLBf;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763962778; a=rsa-sha256;
	cv=pass;
	b=4wefVMnjFjm0BvMhFcBle7xgb55gmSKHUgaOOiJHh4pKs/DI6KLPFMzRjAsVxDNp2gDTC1
	QKKx5fB76fBAcOzb9WcyRvIWPsvijdd7lT2DXNqanXMub+8Sm/zqUxqs/VEZATm+3kkvoW
	cewEqftUwMFKHCyrETky1qTL5g+tNKs=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AO1Tf6B024864;
	Mon, 24 Nov 2025 05:39:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=RMxVW9wipJKKtt+fyc
	jOF72FZv1v14538nMV5eL+Hic=; b=qkvP60ZYvBWXEdyQH8YY4qMUloTWV+8OVm
	O8EgAQkPNgVNdOtvjU4vmSWOP64rzaj5SgGS/M7TtMmkRc9QYBSi9sIH70y65mP5
	kUQ8dxlPL2UQu6hOzme5nwOuW+tbhO6Jqr6yWMFdKqiFPJ7LeHGcxUIR/QxXesMw
	ZNkyfnq8BFPKQxPuHTL2bcgLwoZwlaHMaILHsSkqqoBl56nHNvph5bXrzSnsYUF9
	L1oluetjBBtyjckFQNr6hKp17OT6dMsJGYiKA4/f0cHQrhJ1mqYrnHcJr6bYd97l
	TlHFCmvypeLGz0BLvv7GVaKFOE2enSv+f3ZZ9tSeNu2FX2ZkeHRg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ak7yc9d87-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Nov 2025 05:39:30 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AO2tTxe018873;
	Mon, 24 Nov 2025 05:39:29 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013025.outbound.protection.outlook.com [40.93.196.25])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ak3m7pene-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Nov 2025 05:39:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K7pCDj1xEtmBZYn8EUlSHO03j3YwFLHCUJqC48t98a+O/u9oPHLf7fe9kR6R1vz7shgZpDTBnb7IZSxQbBiwmzChvqiQtBUyP3QVIXpfipLy5CB5hHAAo+gjOC6FKQYC0sWIciUbdIwiWjQgmRks4oK1Zwlra0Hb4jKrqM4sAwh/nyi0hPfAJoMkWaC0Aw5QqTDwJudQZO2CoCI9soBIysn0mQcn4/9/zpYBDSYXJa1PWaQK8PwhbEe+12+OoNsibHbHXYtgTRbHi1PUefzCYQ4NuC0XHuoKucnWXNIaX0r/qEPFCNDBjc/kkC8Gxwewcxyqqaj6Kxc5fg3HndpfbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RMxVW9wipJKKtt+fycjOF72FZv1v14538nMV5eL+Hic=;
 b=RRexegOKFDhrhvuDSDSsvSn+ipZKKkxtCDMQZu3KphFhDWnkTFY3dPODCbrBWBpDMHSUJQGk/u6clCSRfaE3GRBzOnaK4+3Us19IaREVfcGtkWuZIFXFyC+MUb2f6EZ5ojzeomtuXzZeHg4eXTCmyjqAHKJw+81Q5YybNJAnLZ32wlMnUyXy28rPm189kG5MWmtUw1FW8pHA0cCT2ONfIUsGTtdfGO7fOJiDe0i0HPrfO92Gyx5H5Guyh6d3XhNF+XpHsNg39k2j84MxAxFLsKZ+HcXVUjLB2dUdVSeYMHstLeB9ZvNqFJV9DrihgNL75PDgr67E5LJuy7C0ACu2jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RMxVW9wipJKKtt+fycjOF72FZv1v14538nMV5eL+Hic=;
 b=UYTpXLBfeQAuJND2+LZZV/dToOjUT5GgVNzUPw7weIlDlPuuhCuDybIP+4qSnEzGLsjzNzy3Uv14CLynAwQhGEM3V/Nq2ECDXumMyJrn/65y8Riltu8ojoy3cQW/0nK0pjgaPWFmcsE3YDmQI7KbbZC9b6uJmXjr0cnjswQ88mI=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by CY8PR10MB6658.namprd10.prod.outlook.com (2603:10b6:930:54::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.16; Mon, 24 Nov
 2025 05:39:22 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%6]) with mapi id 15.20.9343.011; Mon, 24 Nov 2025
 05:39:21 +0000
Date: Mon, 24 Nov 2025 14:39:13 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org
Subject: Re: [PATCH v4 08/16] slab: Remove folio references from kfree()
Message-ID: <aSPvgRQKAKgnAlih@hyeyoo>
References: <20251113000932.1589073-1-willy@infradead.org>
 <20251113000932.1589073-9-willy@infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251113000932.1589073-9-willy@infradead.org>
X-ClientProxiedBy: SL2P216CA0077.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2::10) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|CY8PR10MB6658:EE_
X-MS-Office365-Filtering-Correlation-Id: fc916c15-7d8e-4afc-8bbb-08de2b1bd1a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3YVgWl9eamnB1B3imyWnmb2BtwgAIuVdu9C1KiWZ5EnD9vOYQe6ZczBp5yY0?=
 =?us-ascii?Q?4v15kwz9/PFZ3DLSLVXJvSHPt98o7t+mrql+PcTqaoo5dvOCWURcn2rP7cwF?=
 =?us-ascii?Q?XN5RMdyTvNSHw0v/DhXMf8je+iphx1fvqBMaywHK2DoR5nAmV5UpL7nghPbn?=
 =?us-ascii?Q?ajRQ7uaJ++xrABSstglZAXQtHoA2O4Yfi6vXWHSRjmBTjTgP2U1xvYEouvXb?=
 =?us-ascii?Q?JTpCqA9s9rX5R2eBnY2Uro2YdQXwRZvsz+N2GcxjTeBPNZHuVqLWLy9AnAhx?=
 =?us-ascii?Q?+8OqvzvGEtbtTZl9jAb7urHXY6F/5DbW8VHoS0qidWECngHPfJHAzD7Ts60P?=
 =?us-ascii?Q?VsXuArxS2tRbsnVMmsPEYS2ncj3h6rhTM9yAxEDD1O6z3z71vvO329sBycqA?=
 =?us-ascii?Q?eqEuRtlHTvnoiSo1MnxbLs8tIEGRwQMcMbnIisOZWdhbToE7HX67xNM+qPUC?=
 =?us-ascii?Q?Eobi+JwYzVt1MPwiXhmdKGx+G3mI+iipeqAFbaUaPjYYvMo/fKCMcEMGKnPo?=
 =?us-ascii?Q?B5zf7NPjDgv+O9TAOVeEdfxWlOmrgFstbBjA4+KXn2jcom0UCiOnscScBP0+?=
 =?us-ascii?Q?8rZbHR0AFeMTOoRqk7uh1wXORdVBYY/QpaWfoH0Rl17r9JTOC9SExK+YqFI0?=
 =?us-ascii?Q?znL3KspfdYratpH42kHBXuyX5AgTvVeLzSOlSg8SWbSmqncZ9HOYOXuiQiAN?=
 =?us-ascii?Q?TfDHgjB5xkApoCV0llw+Zlgmr3lT+PMxQcMB6jxKsAlDnc+/fB+I8W16BPcs?=
 =?us-ascii?Q?rHk3w/k1pR7/c9iOb8xVfHfjjQPkMmudkNbcWSA8RVQaa25uQ0vAIa057jUL?=
 =?us-ascii?Q?TGGQ0b77kgzkXi+mCz2TvaW32u3Sxgf3O3Vj14M9FiS5n1somE1Vk1l+BmsU?=
 =?us-ascii?Q?hFQSF3dSIlR24uDoW5D1hC7vDVgqtbnJAGoq0MAufFK0MsUDNrC32Kk06zDu?=
 =?us-ascii?Q?fBjT4ZCwji0C+GR1wJix49NT9wkSRI5di6tDV7VFGkSonUjGai6P8oM4VMux?=
 =?us-ascii?Q?g9xUYuhrFuIKde7ZP6wNCbIROCmn88IUpBRmpkRvGl0erKpHVMjquBggjgYI?=
 =?us-ascii?Q?EVrCbWgVt/9zFz8bYx3GG2JPbp1yhuoWTOto1gfwbl7qI5a6CgepNnuLNFcv?=
 =?us-ascii?Q?fYyTSEwvLUgo9HMO9jLQOxludbbvpH18LkHyKbZmlUgTTLp2/M3KDkhfqSPK?=
 =?us-ascii?Q?YtielgHQHqfuaLQRVASLdKRIfOSiHDYkOQn2nv2xaCgWi3NbXG5dy+R9F9ZA?=
 =?us-ascii?Q?pSXxcMIQRS9X4kkCj4uUGcs/I2XQyyxgGpQt/a3iHFvPC7y90dKXczuwjRj5?=
 =?us-ascii?Q?3YsE8nwyrZz6yeSQKh6FxYEyJVPVX3ostbN/hxE6opIPFhroVW5IYMbBqn+J?=
 =?us-ascii?Q?EsZXM5XSXuO8AmNRDPw8xFzjQJMmQTDHgfpLRnM/r1/dZDlx5eiIXy7StPNA?=
 =?us-ascii?Q?WcXGK2qsHu3WAejEtIaLxG+hqeOvs8yq?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zy4ql+ZasKOsgtbMNl4RvCOxDLRjLzda98cd/VhtwuIu6xxnJ+XtzhmmUcb5?=
 =?us-ascii?Q?CJnxwWaR5ldKqcPFULGpl2PFwwwVMfsDlc7gArgarcf3Ix+ipXdX4Q7x7osW?=
 =?us-ascii?Q?FrXhiRrdnVSiMonLf8nRUVwe4p1tOtV/7puxSnmXTLeeHCHzi/66lXGMKDDC?=
 =?us-ascii?Q?6vMLG1lsjPzuSbr06zECFlyHQBGlMigye8MBNP9Q3Jas5oOg3XQDNUcQAj1w?=
 =?us-ascii?Q?k3kGdAkXGEKG+Iuf4VRYyEj2FpOxuYDdVDNBnzsra2UNyJtMoW4QNCMYX1H1?=
 =?us-ascii?Q?ZybqKTImtcA6oQPFuQqQnxDI8c6gbuOz5OclrMoEid9a0bbWhwOrLNk2wRtH?=
 =?us-ascii?Q?13+CZ1T57ncAkwPPw5yb8vE9ZNvHdXdhiaxKiAXHI4iyLTm7DFoR5p6A/fU3?=
 =?us-ascii?Q?hRgkH0eLXav5QH/J64bU0O0Vov4WuZR2DbkwgUl4pYaKfy1XjhPuj4IUuN5L?=
 =?us-ascii?Q?/RCAOKn5bRI8a10jXR3D8E1BUyokrwdJARidl3J1oBZniCfXxSxOhaUHssiU?=
 =?us-ascii?Q?OQUpzTu5b7TvYaUv65t/GGsaaeDuu5votzcCP8VO5zuA5vcuPfLf+JvgTE9p?=
 =?us-ascii?Q?G7W4gYV09ZGsXsi8jXUvQNqecD8A/iDnuP2TrXdEfy8AW9oAK8eAmOUeJR+V?=
 =?us-ascii?Q?ku5MTsXsSZh7opb7j5OwUTD2PsmWS3all/7ru8iYrIPNnIUQqMJwbXIb136A?=
 =?us-ascii?Q?AtOtB+qWEuUxpvcQwZVwlFXb+rbJEzKggHeIhYD9RgcJe6u7xuvSEzS9BNfl?=
 =?us-ascii?Q?uMELUSQkQw6s61jNdjV6w8+zrXa2uQLlLM/3N72jO7OJwXCHRfyjxq1R4tJP?=
 =?us-ascii?Q?T+zd1HWZPYHTlXbdTde3tgUo8e7lOPbO8RAZ6LVW6NyowuCUCsDRvx6KyQGd?=
 =?us-ascii?Q?nYqPhNmI8afRcVB5UWJf+xL/vmbLdtBp1gow37j9pXsAskkhsKAaKQTeDyAS?=
 =?us-ascii?Q?miY+Wo+eTYNb0xnqN/ARtss0K0Us7TceseWP9hI8hpvZMUmttcFfIju39+r0?=
 =?us-ascii?Q?xBXetF3UNlGkX0TJQxwdW1/3BYBTs6nL1mSqDuw9uAVs857c7lIXFFVwv9we?=
 =?us-ascii?Q?UOqhM11/sx81IM/AIlX1p0oSyTB8STmSqs7cfjO0hf2gnWycMVmOt6PU127C?=
 =?us-ascii?Q?9Lnt2qruvREZLp2ot18jo22Ur7G8MLq6+x4t4hIvm1tzBHhGyCoIwcdUO442?=
 =?us-ascii?Q?pP59prIbcS7SOqZERdDhEPf5m4p1GWrifx1T/8eePumbMrNblOYnvxsw3Tal?=
 =?us-ascii?Q?eS+ZOI2jtW9t1UTFxyOpyUZSjiRfDOdX0uz61MBjpWSQ26wnQGli/I6h3iYX?=
 =?us-ascii?Q?rErNQrk35MyZbqIZ/BNxtMo5g9eHI78sTrb75a5zp0q0rkHmdthcuhdp2KUL?=
 =?us-ascii?Q?sbQiQo69PAjIjdh/Kp4TQ3twkSHdSM1mTeXv4Sl1a+MeMUazlUlt8DoXBWJs?=
 =?us-ascii?Q?Lu1rzj0akqIFqARiqK6BgiAT4dVfSXIJtiVes+IXtC3c9j5JcrOsERt56EGM?=
 =?us-ascii?Q?eHbUVvkGQJv1p0E0dZycF9bmgVdCJ3GFUu8nRItWDvaeuLxY8GYlogPngZ72?=
 =?us-ascii?Q?ATMmtJar1flH/VTQMjkLLI5BOvp+qKXu+lvo+LKV?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	3voahW8wCXVO1opahFsiNL2O+TS//Tey479Vq+Bw2oCJfVnF2XXdUB6ertmX6UOSdAa7NyaTbK8da6ZVV5AHvm3mvVZcoH6R1pus+d+Z7IJ+O+R3ts5kcOVz6q5zKx5AY9bq96kg73zFhLP0pJVr3g56mfTIRGpHtJDHkOoTr4y5kipLFnPMVU7EQVGJLBmvn4qRw9Nz9fWMnijcgbEw03g5VkgEU6iVYtMWQ5IbexLp+J+qL6kIk4ysfF0LAcbkjWERy8DM4x4aUqY4cfn5be9DaKFhLvU4/TqatSr1jqeC8H7THwDf1/Htu+vbYuIirQY5XigoaPTnbTnf4wBseMD20vaV6iqqaToxEp0gvDBBXGqMgYoKbn/NJyTezBlFE07J42ylQtLYPOVbS60mLDLcta7BBv0Thj6vs+jVbfr99jGa0dOPsF1Hi4Xi+onRyV3R+DabaGl4MR2/yBd8FkNCIDGaqvPJ/Kq9Z76wxtp9B03Qs2zKTtBalQxramiT6KEq61/o2S4svrVHra5DPFlgvEzmf5JUYQiMd9o14kMy712ENpmQLIqv3tczKGBG13jmrAXrrIZmXYOGgU63nhl1qqqK6Mf9CSp0De0+Fok=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc916c15-7d8e-4afc-8bbb-08de2b1bd1a3
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2025 05:39:21.7855
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wIm2eUnfHAWHJlF+gu7PZy2nb/xKlXHtVMwPTGdvrex/0KCJraWbmPBGfoARQYWmQqgSZCcGGDiC4J5uBAe8zw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6658
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-24_02,2025-11-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 spamscore=0
 bulkscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511240048
X-Proofpoint-GUID: TffydDWFiGT5C02PcT5B7LtLmR_xkeah
X-Proofpoint-ORIG-GUID: TffydDWFiGT5C02PcT5B7LtLmR_xkeah
X-Authority-Analysis: v=2.4 cv=RofI7SmK c=1 sm=1 tr=0 ts=6923ef92 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=JfrnYn6hAAAA:8 a=yPCof4ZbAAAA:8 a=z1Oi_9SiYilVYs6Xc04A:9 a=CjuIK1q_8ugA:10
 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI0MDA0OCBTYWx0ZWRfX9fH8W4OsPPBf
 cfyM/1L2wQ6OEL74igy/HTzYy8pT9dNdIKPlKmVMRP6aLs/+AMqdjd9Iyld6hS3JQ0MNvnFU6Rz
 rYRdesyTi2lfpUKoUHxjbo0fSN7cvAyIWakBea6r/XRrHXL6IHQKYZAItd0VDbqYCwHG5EbQiRR
 pRFLVx1NlRy4AtaKm+NWJA52pDJ9Rb60wsSd9pPDru1MdkRUo+gzuo7hnrMLdWzaMjeFtvq7rIw
 2gyjodSilHvbLq07/Jzch9eflo9GbqueSwF/c+CpGXh24+9/bd/+m9up76VJrNbGd8/uqCwV71K
 9uPUAAELH30197mzuMwK3GbKZwowXDwrVac9qJM5kn44r+n9S9lzKUaSToPMI4sCS29a+4oBWYT
 nebKfzy9u6e1oon3IPgNavVA+SyFTg==
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 865428000B
X-Stat-Signature: 1stbsew5doirmtjbgigdbsrtekkre77m
X-Rspam-User: 
X-HE-Tag: 1763962778-679626
X-HE-Meta: U2FsdGVkX1/ocozcwxJCSPojS3JcY8qvZN5p0d0JJLJlaCZ8vc+UgH92BkmkxkCQjIXuJv4tQ50q1HUGK1+/Qr/bOZF0XwW9PHeicKUVoSWHbCC/Rv6abxH1JLNtx5yMPJ3AOtZm9mQ5lPxaxNH9RrJ7QN/RlB8Ufh2jT8jp3PD3f9ra2cvbbCXtpqJwpYumuXhdRxlSqS5TKj5u1KxM1MMYoYLMvam+IvRrsb+Yl/hmakgeotiO3npXa4/uteOtBdocxy6R4ahZZUE3LhP3AF8mvqpiDcSzIBtfhGysmI3c52cOpDQgJpUHfd3G8MDOCna0iRVJbfuBGbDwRNW0zKzs7Rwo7aXmJjIculCytFNYgUjK/ACvd+9nlSNN+fv10x6/MwvIOg28IffvTiLxRD7kJUTSedMMpiqGFF8RyvhkSk47GyOArJzpzIw7z8VaMsmk2Y0mMS518uy3reQBt50mPwWbA6/Am/hfXJkdu5nesqzOqQ/fMGJ87gzd3iGiCmJ6CdDx0zWngEcgLvPBzrJL9111zJZjhtMl6tPZa0W9+oST44K4dobja2TChZhitO2YM5xTyd0MMITo60b1omtElTPoonIE+bBKVvqu9wnepYVbeZ15lA+H0LWmf/PEFj5Q/Z/DIECRYotBHxhoajxB1ob3Q17LRu7X+FTqYHDBGyLNFNlLoykJqMWP0cT5jlk1PFmDWKfwc88sAMfl7wWpCrq0GlxY7DEpw5g5gSDUkYVvWDlw6ayVW9X772i2eg9WGNF6nTfvlWOc7UCCUUOKOL6HT0AU5ONuK6XCNdbqNucp6Wi6sL/AFaHKn5sqP+HA/HsgN8u4Od/yG2gI1+/OyYAtLPY5l5pI3FxI6PKIkx1MiVZDqCWoC3MS/czTbot7d5ygEB7LEpntNE7hZq1D6hOjK0vBELK67vT3UZfnquZWUony4o8GnQCngXy0ovIiTOf+lZf77wY2Rij
 bJQ/sf/A
 FqPDGhLUAE95xgu3rwTm1kfEGFvCdu8V/c5Hu+ygbt291Y11BoDPXSHpWiVHVgZXFbSiFxlcRNRk8QSgYqi6gGO9/5+UiG4+Qiz7xlWbBwFWmmuBzSRUUG6qrHrsGgNqAnY82pTKNt7an/Pohod1+L8zNNvVo2nShWki1CAG9Tkc/tHe/iiPw6vIeEqxkj+bFAPYDSJuEUE8XVjjS35ot/Qd8fX9MUPF+2OMJmGIgxqsYPDfYIt2Ar+TAqYrSQJ/yIrUVZaM3A3gAytxOugezWkxT4ouVmdTCZZ7mVJBZz/G9G6YxcfgEb05AWYwTa5JUwijD5gOJg0gnZxiBvds78P8ZA9EbNrlAh7fmWqsgg75e8gytyMt4VHUzfYA0AhxP+viPSkKlnvsfAfVDYohjC6JTweCd6mxb7e8WnR5g7u1Z5BGcgTxPTsZZUMTDbSL+GsbJzenHgAIxreWCFv+NmHJwPh9doT99NBbcka7h23NFQaIFNFr+GDQOadRBOZJbmOmzM8n2U+JN+xQ/3wA5rcBDRWZWhcJ++zMVFfYMlcyyIE/str+/i2yKzepYD79sFUY4XI6UszDNs7g7YO3eVcSpLHb0BnvJQQqPE2aFU05gsDf7XSuDeu9ZzYn9uqH/pOWlau7VFoYISD8lilwxTwQIWHM6YiIShKwtTTiUMirpT7cY4+kTvGWcEBdUBqxAQuPGcDLe06jVaDM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 13, 2025 at 12:09:22AM +0000, Matthew Wilcox (Oracle) wrote:
> This should generate identical code to the previous version, but
> without any dependency on how folios work.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---

Looks good to me,
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

with a nit below.

>  mm/slub.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 976e116580a6..184bab91e0af 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -6866,7 +6866,7 @@ void kvfree_rcu_cb(struct rcu_head *head)
>   */
>  void kfree(const void *object)
>  {
> -	struct folio *folio;
> +	struct page *page;
>  	struct slab *slab;
>  	struct kmem_cache *s;
>  	void *x = (void *)object;
> @@ -6876,13 +6876,13 @@ void kfree(const void *object)
>  	if (unlikely(ZERO_OR_NULL_PTR(object)))
>  		return;
>  
> -	folio = virt_to_folio(object);
> -	if (unlikely(!folio_test_slab(folio))) {
> -		free_large_kmalloc(&folio->page, (void *)object);
> +	page = virt_to_page(object);
> +	slab = page_slab(page);
> +	if (!slab) {

nit: is it intentional to remove unlikely() hint?

> +		free_large_kmalloc(page, (void *)object);
>  		return;
>  	}
>  
> -	slab = folio_slab(folio);
>  	s = slab->slab_cache;
>  	slab_free(s, slab, x, _RET_IP_);
>  }
> -- 
> 2.47.2

-- 
Cheers,
Harry / Hyeonggon

