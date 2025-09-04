Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90561CA1013
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 18:17:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D77B18E0009; Thu,  4 Sep 2025 14:17:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D27208E0003; Thu,  4 Sep 2025 14:17:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC8538E0009; Thu,  4 Sep 2025 14:17:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A40308E0003
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 14:17:28 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 368E913B05E
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 18:17:28 +0000 (UTC)
X-FDA: 83852375376.26.2DEBBAD
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf23.hostedemail.com (Postfix) with ESMTP id 96A0C14000C
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 18:17:24 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=m1ScARBX;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=yPZvJmaa;
	spf=pass (imf23.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757009844; a=rsa-sha256;
	cv=pass;
	b=DXjCFTQu5eYU6xK0HhiM7s6gWEnpx7Y/NJia5H258dk4Ab91hQfWpXjqr4SwORPu8v1Ki8
	AsrMtOkGFbRspDUlooYp0VG7RHNggIVUTJuvNclx90MxIU8r7fbG8Ai79peYTxhYh6RH8k
	9+FfTFnCO6XLUFLfmQNIkX+vsX09s8A=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=m1ScARBX;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=yPZvJmaa;
	spf=pass (imf23.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757009844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EwuDdOXsuzDXyffVKnNCHQmHft9yXo1lcdPwaSEh3ac=;
	b=skIu10GQvpQRYlkr9NNVWAU4F7uZvcU9pWBs5D5PU19aj5+VlugE7BNIJCix7DeF7KpbKp
	DRH2vLmy8tcQDYOQsG0KyYvNJ40frnpyzvKdMWkFyIxEkSHY8nd6Pm8F5z2S/9KCHdLYD8
	IkBl8pNalBswGIpaTzqNwBe+ZNYZ928=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584HOtZd025318;
	Thu, 4 Sep 2025 18:17:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=EwuDdOXsuzDXyffVKn
	NCHQmHft9yXo1lcdPwaSEh3ac=; b=m1ScARBXfleXaDK+WLNPOsk+jHpo4y4b3Y
	btRTGBt9QFcjZyxR8ss+5M0sk/RdWkZ2yf9RQzJGWN1FUPzgQnNpgXxzw0aA93AZ
	ZZc67JwNlrNDoCO2Y0NYynz9ywBB/DgoNvE+17ZrjbJCwZ9QYYTx1qo1zoKxuxfd
	yZ+6FxXV1hXSmMzdX0wChBOJBONMno6Mj5T1usqJKLYFVhFa6ns49BCrscXfAY9j
	Ei8/7V6IMdms+NSOB7S13ETULbxDdG3tm6F6aI4ym+fvsfQ1UNA51Q1Bgr4Z3fxU
	i6EgkllODiX29qIRGs/9vT6W6wieSNJ9ijzkqFY7AN0zigOLYC6Q==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48yf5183b9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 18:17:00 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584HcPwq040046;
	Thu, 4 Sep 2025 18:16:59 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11on2046.outbound.protection.outlook.com [40.107.223.46])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhy499-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 18:16:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dWXNxBOikh1ZeBpslAbb4WI5qgpypeeDARP5OGSkrxo4hTHGCLqKw1TB6VuXtWqqvavrg5Cu2PFkKq8bYhXow3/ye6d1VBYddDo4TOIhcdZDhNDYphz55eFHY3MZDEnLkpDgnIQKjvjl/UYdfjylHvJvPNDeB6lqi6a8LpkG9WhPeIWtkUhVTwVb5DUfzn/c3Zz1QrQf0ShzTLG+m7Gy8BFePdd+Z2IK/W1gy4ZaVc/9KkgrxfdoUFpKqf68+ZSlGHx7j3MlAKqiHH2bsjjyzIuiQ73GkhNKel8y4z5nk3uh8YEIfPDLAKLnLkTfC2V2tkzuluT/EsipCNCdMUAs4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EwuDdOXsuzDXyffVKnNCHQmHft9yXo1lcdPwaSEh3ac=;
 b=sAOxaa/XFSJ4nJoAlBFE/k0lcdHQCRjkPTzAUIGiyTJud/M1EeTy8WQB26c1e3hPSeJj+P4ePS06vR+Up95GZxKcgUF70Xg26x1zmUVa8CJiSVeLLD8hkLWIZvmLxMPNb+aI0nYHnZXLhGU3Fl3kkiUkU/OmX3v5Mc4BEtPOX73Xa7xqffsHcw9kGg2DLQQpV9RrNm74nyxjFu+WZHs6sNNv7MoaeUNbrmRzpQ8iEx2FWPk1l8w0PpIC1t9VwzZiGl6m40XapYnO1nQ3rTCnfZkfB0gk28HRxlcZlqGVva7AVR+tXZrJqiJV7n7QeUlskhf/EKYX+56h1PtSQhsvAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EwuDdOXsuzDXyffVKnNCHQmHft9yXo1lcdPwaSEh3ac=;
 b=yPZvJmaaUUckhIBcVlUOq9y0wKNU6bSJO0LMSuukWidPPXLgtz9tWOAAsNpU4n74bFOf7mlgETPV7x6ySRIjIuGjGD7e0L00nuXihJUpjib3k6EgRk88aIUNKH/gyq73unY2+C/g052/8BezqZfXQjoinqmZ2geUCB9JChdzb7A=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by DM3PPFDEB3189E6.namprd10.prod.outlook.com (2603:10b6:f:fc00::c4f) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.17; Thu, 4 Sep
 2025 18:16:55 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9094.017; Thu, 4 Sep 2025
 18:16:55 +0000
Date: Thu, 4 Sep 2025 14:16:39 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Tony Luck <tony.luck@intel.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, surenb@google.com,
        "Anderson, Russ" <russ.anderson@hpe.com>, rppt@kernel.org,
        osalvador@suse.de, nao.horiguchi@gmail.com, mhocko@suse.com,
        lorenzo.stoakes@oracle.com, linmiaohe@huawei.com, jiaqiyan@google.com,
        jane.chu@oracle.com, david@redhat.com, bp@alien8.de,
        "Meyer, Kyle" <kyle.meyer@hpe.com>, akpm@linux-foundation.org,
        linux-mm@kvack.org, vbabka@suse.cz, linux-acpi@vger.kernel.org,
        Shawn Fan <shawn.fan@intel.com>
Subject: Re: [PATCH] ACPI: APEI: GHES: Don't offline huge pages just because
 BIOS asked
Message-ID: <brfqzhbipg35twgv22vnnotbv3t3grwh2dxugvtbgqduuhsvst@f7exibz7i7tk>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Tony Luck <tony.luck@intel.com>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, 
	surenb@google.com, "Anderson, Russ" <russ.anderson@hpe.com>, rppt@kernel.org, 
	osalvador@suse.de, nao.horiguchi@gmail.com, mhocko@suse.com, 
	lorenzo.stoakes@oracle.com, linmiaohe@huawei.com, jiaqiyan@google.com, jane.chu@oracle.com, 
	david@redhat.com, bp@alien8.de, "Meyer, Kyle" <kyle.meyer@hpe.com>, 
	akpm@linux-foundation.org, linux-mm@kvack.org, vbabka@suse.cz, linux-acpi@vger.kernel.org, 
	Shawn Fan <shawn.fan@intel.com>
References: <20250904155720.22149-1-tony.luck@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250904155720.22149-1-tony.luck@intel.com>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YT4PR01CA0345.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:fc::26) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|DM3PPFDEB3189E6:EE_
X-MS-Office365-Filtering-Correlation-Id: f372f2c5-ff35-4036-9362-08ddebdf3aa8
X-LD-Processed: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
 =?us-ascii?Q?yruHJ8mX4FULuHF2sSiAxBT2bW5G/MSPzlguW1rcRWU0kB2Omffk38wVkalV?=
 =?us-ascii?Q?ARJIIEqcSZ2A5LdgYKcOAVJSzM0yVB7SUvnLSmms7TdXXKWhVj/qOPScq6MO?=
 =?us-ascii?Q?KnAmzOKuPyO5HZMTK1DEi5Q3MJdztNpD/pp7ETcfngKRZuvmU6PgiNWkG20W?=
 =?us-ascii?Q?cU6Z2wMC8nPw0yLkri+9tPGhMQlFmtONhNqyYEdMozQOkGCLfnTZIk9SV1sQ?=
 =?us-ascii?Q?dMWQuiMHkNZNaY6IpRoHsJjPRUtjAIAocygJsoAPQqIdhtvd+1nxAhXAflUa?=
 =?us-ascii?Q?yk2zYntcoioYrHfwCFvTe0Dc48DqQ2gGKPpKCgFn/qMs2obJkDt7zOY0h8Zj?=
 =?us-ascii?Q?+a+qZGiwdl9LamVK5Lrw7z1FkIV5j8xNGK5RoxmsKUh8qjfUciKKzOsKHGjh?=
 =?us-ascii?Q?rtgWt/yVyDAwBbzG4ZF+PaZO3wrsnzOlT8KcoThUhCk2rqF+daYUwXyoMK3Q?=
 =?us-ascii?Q?t3RBnnlahNSrL6sMrkfzPN4RldWIW7ezD5sYpOJEyoOIJJUh5PjMOSovAwir?=
 =?us-ascii?Q?jRCkM8IZgYJXsuEbWpRwnRleVNyrZsLiBpEs0OoDHsaXx3YZokUSJIxEcmlF?=
 =?us-ascii?Q?F8ZTCc0/VxiuP97Ll0ZRmjrUBmX7fXVNRp468OPbq5BjkxslQF6dcr+i0hLD?=
 =?us-ascii?Q?euELTIz4Rv+fkKgXNorVkPfUREwv6+R3g0pERofB0l1/uHF10RvDUZEhpGL4?=
 =?us-ascii?Q?T3cyfEMwhGscSnoxp4IsU55wcTydMbDZZ/YlcG7F0lUmzOmZY10stsnqiEuz?=
 =?us-ascii?Q?GsByqYph1uCtH/EpWPbs/i7MxzvFuGNN1WvCjm8St26ELW71IkuyD1k4wnhc?=
 =?us-ascii?Q?aTmX6ifQFaDmxXMsI9DILhUjB8cjoQ9XhdmC+6EbDIMjbfi0t03+ovxdocsW?=
 =?us-ascii?Q?0p2fBJ7y+AofT78tKTsw4xBP1dykdwzFXv59N1suscXRJKlS1Ed/DZDqcbWL?=
 =?us-ascii?Q?MM4+4vL7NYJRxgcOZRdBQAZmJT+yGEl5mzgkdySSmi8neD0wnpkD4MTv38Ly?=
 =?us-ascii?Q?oljhZwx/A6S8WJ+r9gxrAzZDWOCMPyD6yQ9aX95Q/0QhOSbbE+L67xyX1p4u?=
 =?us-ascii?Q?Z2CPpfyuHOA6uUIdvy/K6geCEXEnN6mU3NgqFeY9ltDEuW+dPW2+EQl+Ghp2?=
 =?us-ascii?Q?p0tIoAWqPJ5D0b0494RvQrG0sdiuBgc9+XGuUDwsX5LKGU66o7/r3+ysmOcx?=
 =?us-ascii?Q?rFhC22jxQ7jywLO1GEhH2DEyVdzKseW+1Y/6cTZlvlr1w74MYi3bpBDN9HwN?=
 =?us-ascii?Q?I7e5bc2ixEXloUo2aaj3IobCGTJ3eHdWiKMsn6ln+vXnd8SmjQa1BfbDfubD?=
 =?us-ascii?Q?nv2DVfB1KScYcGmK7uSd58mONK7u8gv0i7zTXHRv3DzCPrgLvLFfPb2rBkOa?=
 =?us-ascii?Q?fKG4Gxv5b1AWa+VoKgFgp0t/5+MDMMD+788/fswzIVNKWGeBoU/eHzoROwA7?=
 =?us-ascii?Q?b1fSvofQnGk=3D?=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?FvuArYtcbZimajSlyYzfPtc/jasZKfUFYdG4FQP/EDL+L696Ici0hfxdBzQN?=
 =?us-ascii?Q?/AtbAe6vIT/TymteVwjeEpirBFYJt5fLx6/OReZ7AjfDZLEIu4uXP9ShYcg5?=
 =?us-ascii?Q?XTQLzPHjLTy8I2Vpm0Go1M7If6IClu5xM0pF8nxLymQwchTorbY0CWZHqrI4?=
 =?us-ascii?Q?jFi1scV/iaqvdaZeWiOe37saK6hCpcejBWbhmcH8V5rcyXI50VFnw7tB/Btw?=
 =?us-ascii?Q?i/194MMQpkUKI5kB6LnyJurUk0xLlRV8o8RtturUR2ehoA50svC+WWEQTq1l?=
 =?us-ascii?Q?i3Y+iZpv1cpAS5he589KH2brWbxCahrlPEyYdw1lOqjq+lMYKjTvprmdASQk?=
 =?us-ascii?Q?lj92HRdNO7rrX+FBBzYOjt/HVuC2fsdUFdLizCa/Pcj1mcwiA8hoByKxzUw8?=
 =?us-ascii?Q?1/3F/tksKB1wdqjwWANQzGpilWMFukT8QNgo31W9+GyNeJeSIE4s5K1nkUTU?=
 =?us-ascii?Q?zz/XmJo9cptkCcKk2pSCMsLDHeOYMyDTZUCqpI4/rY49S06HSSAGiX+7w9Pr?=
 =?us-ascii?Q?DdP/uXJkV2z7cCe2DQZ2OHWHt9vN0TS4WhvqMqtnOsgOvVJE17E1XlAhY3tR?=
 =?us-ascii?Q?dxclW+KZtXoMCCkQwZjDe6n4XPAwmgEw4ipT4xYdEsFgzedz6oDkU1RiTzjr?=
 =?us-ascii?Q?vOkh1tRBFyM+81nd/Z2Bzte2rcUcFLZz+1FgZWph5lZaV0gPHt+qRvhsg4YF?=
 =?us-ascii?Q?Kn6yHeZoXIfiiw29iJdCV/Bl8twL1TQQmY4kJWUXy8a6vJC0Zq3BfZIMXw3a?=
 =?us-ascii?Q?DRTP/A8eHazOBOfzjb7E9m1/x42UljOMj4+QUMd4SP1UDwo4CjsmKnHVnKzU?=
 =?us-ascii?Q?vRXfy9H2PM3H8i7KdJMXUksnOPFyzlbKrLj+euDPQ1QTgOTBtW7EKlAivLhm?=
 =?us-ascii?Q?140b02Npg6MVT0Gk8JzNULLA3imUjdinKNRr8zAKt+aJLmpucvk4QYdnl3X0?=
 =?us-ascii?Q?M8bfQziu6jNYX79+l7R7Hpp1HsuLG+sRX3YlAWUFfV/5njfNkwDS7ku395Ad?=
 =?us-ascii?Q?VLQLC87Zr6vp20VlzynhfdbSgPFZfZpEcvun8cj+T7hoZjVJa+7cetIP7Jrt?=
 =?us-ascii?Q?EpNBJcV/eyr+6C0BTTiDTMPuCItl/9/Mqv7evSyOV6S2ZB7wmqYyMR6Hk0wH?=
 =?us-ascii?Q?h5BYbXUoYbcdnnsaDbY2Ki5kJ+M4i51/W88lT6zR9ldpw2T3Hde9y44DyKrw?=
 =?us-ascii?Q?GSAKLyvJS8161b3UxOyDWwX54MHSMbauEMc+enhGEJM34ZDEBIfpW6WPJr49?=
 =?us-ascii?Q?mP4wW/9z2LbZlYw8rGpmFPmANHQ1x7tFTvyyOa/vdBY+rIXrjRQoVPxQHQYE?=
 =?us-ascii?Q?wXjMv1phEHORVfhmsWM+bSM5tmQfjgPysuZ5kUhuX2x6qh6DjAEiTZDoGjjL?=
 =?us-ascii?Q?tl83oXaN+PMDjxuT97S+41Y5zDPq68BtpLIr10Cg6BuzQjw+D6gi8GvkL8LI?=
 =?us-ascii?Q?2qxJCyDZ6pZ8nFA2FAf3yDHN4fceg0IOrTgxD91E3whiYUHStKMiKEwyVseh?=
 =?us-ascii?Q?GoNM6Q/AMbD3OIgcvbe4He9Jmmjf2yXxL6bx0VOCl2eKOxMquuhb/Q2RMwL0?=
 =?us-ascii?Q?TVSV491WU2kYBQjzxljVtrrqy5CsYBaW+Ji0Rl1s?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	WYPRFZKjQeGHuFDQjmkTDc3FFJyU8iAeM4iGGAMASkL+asJ2qNS6lyqdhmIRvOZ88N1x41FS8cW6J5QOkvNidxwoccNiZXdDuaBGe6ry0yj3o+LuDt3PKx80ORZiGtyKkCulO+s7gMGPIZWd02Ubtvl0P1TzLmEKpIZk/qmb43BXqMXQEckKVkGPh2fAeiYGK5GVanC9hPupc60RoDSsL6GJsnptY6VjU/rdyyVVwbp0f27mjwcxVnGPR3S0W0ha+bSpBiiXOf0t9tKzGdX2tOsjXoYaRVsjXjyh27Fs6ki6uBhcRuewGNBR4BMKmAhhVciNKaNXCsyBCLrLQJOVEVB83P0wt++A/1/4oiqKBZFPK+16idGxWqVn8dajT2zHgHZy2Ayn4ukrMdzyKJVQ7aOC03HwhOpbIxXtRr5t0GiApFlqui5RWtc7q9VezEg3hnfHb6JOz8zOOUXtJApAqK3LwJf9M8d2eDF65svbJTj+RIRJVHJ3OaDUUj3So/ohLvEjkIQsa1S1OO/6Lb9ikmpO3j4ULOlpPWgJc7AfnplrzfBYgfNqZnyRD4wjRF3tBOxx8eZztRL73nvezQmW2EGHMc2FdCE9Qlggt+zHl6w=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f372f2c5-ff35-4036-9362-08ddebdf3aa8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2025 18:16:55.3337
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z8tL11plRYQ7XMxeYqURnp4vgiRagFG1wK3aBf79A2sXa2Gt9HBDZ5xriVTEaOz90OxjGMCseMrsnVaxhRq/gA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPFDEB3189E6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-04_06,2025-09-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509040180
X-Authority-Analysis: v=2.4 cv=b/6y4sGx c=1 sm=1 tr=0 ts=68b9d79c b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=QyXUC8HyAAAA:8 a=OGYlSSuIQAbOMy2gSrcA:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12068
X-Proofpoint-GUID: KoktjEquomAcrmFKnfQLladSks9BxBuf
X-Proofpoint-ORIG-GUID: KoktjEquomAcrmFKnfQLladSks9BxBuf
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE3MiBTYWx0ZWRfX7RnK1I8Ul8Xd
 q861zlRg00nPrFmRoamems3CCQFEVKJKyjaCO2vBdsi8vRAP2JVcZms+X+/QcOmFboup8ClGLjv
 a8Wa8RGCydmWch+Ikeq9C9KTriIt56OKDOMdq8WgnLrIIj4jDZ6uqfOAQUBDkkayGsm0qcCFlci
 v2Nc5Nx/661gcrlZ9iNF4nHiQPWcnHsuoRq6G7LVmpfwfb5nEgu7pbE/2rXfWGrfZlczP+DMzDw
 d+ectKzp0HTtx6Kuibkvz32bVk+sS2dU2dVUihphIXatdxI1DDH54MbzOl4GvUoqTWwXnJkcYKc
 r2FcCiyvMSju99krJz4ULx7VtobzO5A/yU7akyCZGU2uFvRnj/OsSrp5ogZUZEZ251AJGvH6MHK
 6CXckwhCHoaawtg4BRFuHEyoOdIE6A==
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 96A0C14000C
X-Stat-Signature: x6utmxkmzh4oey58uk4esacowxxbmq4g
X-Rspam-User: 
X-HE-Tag: 1757009844-320885
X-HE-Meta: U2FsdGVkX1/ZCY73wXBjLMCVkoBMToZ/xwZTpYX1VVEeyVXA7gdu/NB7gzIx03Ixno0gcGdi0l4hr+OQOQMr3IhrArq3qy6UnuWoDkhZnCvQIZ2Z1MraKa2vbO2vBR9sCmwBLDHz5APCenYOrHBzNwVss1aWOaCudZx0K72/PMGYTH1+I+y7s81ndTI9kirqjv5snEaWsQHWFy8rYwBPZbj4l1mi/368HL65PS9ASVl8YIRLc1YDFyb0Os2ozd82xPHYu6Pk+y2sw35KP9Oyidrfs7UNuIEl25iYVK+oS5zpy2gNknMGQPYRNzeGIWu7racJ2s8/OnHUWP+QuAzgJ+99YCSUR4lvZ38TmvivP9Lrjwokgedax05sN13g6Ymek3csRFa4bwBJv3EcGzYiHCIkGAQoHD40VpZroT30pw0YJruI5V76aNW995X81je/obbBtpjvkxOm8hJji0ynPa1BnGdnB8ZvJaA9yM/YTetA3Qp2wCEZ4OmVaizqwhOz8LyrwlUG3FDMJ/VE4w8WmP2kv2tMNYRYtBzQ26kjHcZSJZsKbRYuvlCZ3ZZPAZmr2EaxbiPpCC1TITg5NEvIRoc2Sgv/YMEj6cJQtsjQWuEmfOYeLmikdLqienWx451UxF+gLijO9YaQ4NZyRnWM85yJRjwEkpTbXcw1UNL+7FWQ6BhH3+GTsNMywRgph1bJOPA3TOTw8oCOMygbu1qiHoyRDxPJBSOpib7F4BPaiPsuMPMNRlXNVnh04Or9RZjWHUhR4GdG6AUb0ju2whPxGYnIh7p52kj2+R5dnie2vxiageiu8zut0Vk1HUD1GHAP1G0Y0AhGR0u/PfLdVGpC1mENyOseBoRliYBrA1btsqDtl46VfPk45nxmqNlTEFyodc5DtegSBho34DujOHHB0FwqQ+f4b+MCbwKEf1WMOh5Q99QbWk4O8pXTBHUdSTUWk+ZSQyUuzIcqYgpWnCj
 UxyG82Wj
 Qc9Ma4Vg7965yMesGLh1Ysgo5+3VwAH4VclKB11Tux5xhbM+haKiIqjDX6itN3MCZ5WJwuFwyywORwqQLwvPwQjpaZgXxRIc4mYmJSsZwy7YYqHh2Z9rLDkeiy/Z84oZH3NxuPymdVdQl0bWLQLTuZzbydBSiSwJFnr0eaH3OQunVyNP1vs1zTKZdV/jfnp7hOE88xXZoRPVTJ6SSmG/vxV+/IjkzhtJkbL57YqOB07hoxV7tW1T+1k+z+UNiuB/KEbZfrvUnRvsj2r7z9glEjurxIuWyq/WUKAyc8n7+lx7AYlECBNzeuFPjLkw5VT/wUiXKaRcJKYfgTgG/JJJef9XYxHm/yHadr4GDVa/acY6Q/5MuakzrKh8R5vpBemvldG/PWJGfaeBV2kovn1W0as4mDIawV2r6xxi3rHBORAnJPigMkvMlZBqg8ZC/c8zeDNrjurOsbBpfX8b87xbvMLUWN1FN81mo+vY5H4Llw1EvWeQdzQGOjdjlKQjCYc7fwPcdizB7cd9B1ZjEcS+nv3FDbFS2zHO4Ja+x+/NwBxDvSDqu+yMDK+BPYDGTvKYyGxVaicYmBF/JWX8cBQYeU/oA3U1/o9yr8K5o1fo57LG6dv9vYX23bW9nyLVU4UfmuegNSVLa88T38QZo9IVbeRE+yF1uAFQ/MelUL7VVMSDSJ+mCd/fCfX0KtutGBjEW18h2bet4bbGdpeNCPDk80ojJJrO3GY9tsvzMsI3VUKvgY3v4g8BlqeKXYzIAsOG7+o7zIW/2VShvH/Jlc0bGmJpglD6ToLmNebCB8mjfTDuFPRxqn/0jDms4Fw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Tony Luck <tony.luck@intel.com> [250904 11:57]:
> BIOS can supply a GHES error record that reports that the corrected
> error threshold has been exceeded. Linux will attempt to soft offline
> the page in response.
> 
> But "exceeded threshold" has many interpretations. Some BIOS versions
> accumulate error counts per-rank, and then report threshold exceeded
> when the number of errors crosses a threshold for the rank. Taking
> a page offline in this case is unlikely to solve any problems. But
> losing a 4KB page will have little impact on the overall system.
> 
> On the other hand, taking a huge page offline will have significant
> impact (and still not solve any problems).
> 
> Check if the GHES record refers to a huge page. Skip the offline
> process if the page is huge.
> 
> Reported-by: Shawn Fan <shawn.fan@intel.com>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  drivers/acpi/apei/ghes.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
> index a0d54993edb3..bacfebdd4969 100644
> --- a/drivers/acpi/apei/ghes.c
> +++ b/drivers/acpi/apei/ghes.c
> @@ -540,8 +540,16 @@ static bool ghes_handle_memory_failure(struct acpi_hest_generic_data *gdata,
>  
>  	/* iff following two events can be handled properly by now */
>  	if (sec_sev == GHES_SEV_CORRECTED &&
> -	    (gdata->flags & CPER_SEC_ERROR_THRESHOLD_EXCEEDED))
> +	    (gdata->flags & CPER_SEC_ERROR_THRESHOLD_EXCEEDED)) {
> +		unsigned long pfn = PHYS_PFN(mem_err->physical_addr);
> +		struct page *page = pfn_to_page(pfn);
> +		struct folio *folio = page_folio(page);
> +
> +		if (folio_test_hugetlb(folio))
> +			return false;
> +
>  		flags = MF_SOFT_OFFLINE;
> +	}
>  	if (sev == GHES_SEV_RECOVERABLE && sec_sev == GHES_SEV_RECOVERABLE)

It is a bit odd that you return false vs not set the flags and continue
the checks.

The control flow may cause issues if other checks are added, and only if
a huge page is hit, which will be difficult to debug.

Looking at the code, it seems fine now, but when we don't return false
(as you have added) it looks impossible to reach the line below anyways,
so should it be an else if?  I guess this is not strictly an issue with
your patch.

And if it doesn't solve anything anyways, why aren't we just skipping it
altogether and maybe logging it?

>  		flags = sync ? MF_ACTION_REQUIRED : 0;
>  
> -- 
> 2.51.0
> 

