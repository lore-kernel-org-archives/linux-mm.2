Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51217CAC5A0
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 17:36:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F628280001; Wed, 17 Sep 2025 13:36:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CBE78E0002; Wed, 17 Sep 2025 13:36:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 895D6280001; Wed, 17 Sep 2025 13:36:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 73B2C8E0002
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 13:36:23 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 284E816063E
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 17:36:23 +0000 (UTC)
X-FDA: 83899446246.08.90B33E6
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf22.hostedemail.com (Postfix) with ESMTP id ADD27C000A
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 17:36:19 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=JyvZ06Cj;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=nyDljMqR;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758130579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hZV42UnOJvUnQJK/rbvcsp7vB816684ZTUgviUXT6JQ=;
	b=BrL9N6GtAcHCe+YdaU+O2TB595cHmPJQYxeiqaMQxuI1S2efUbXZq3wJgEBk6z6iNFyfFV
	0o/iK/6QT0j2kCTnQuj17QhlZeCbmOVDCbre+mFXdDmrNNDNMn43NwjLe0w3SbLT+ViByC
	GfnHqBGXGLewTM3TMq01uoYDpl7cO74=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758130579; a=rsa-sha256;
	cv=pass;
	b=RmnmogTHmwjEjQWVCLDo2KCU0rShCTPNh87KMMj2ZN+e4uzVYEnjaZRPhMniUt+EDQJ78t
	SiCJ8b4PyHYY2YKXKQzmaz6sZ9c5tcw8ZVEsQGxC85ZsrFCdRs+20AVDmPTlduwn0IuTEB
	ladHiBEolp9ZAcCo5YT1msYAGncO7ZU=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=JyvZ06Cj;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=nyDljMqR;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58HEIbxt014487;
	Wed, 17 Sep 2025 17:35:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=hZV42UnOJvUnQJK/rb
	vcsp7vB816684ZTUgviUXT6JQ=; b=JyvZ06CjmtkPG+AsMjlCek4SBELULeW5gH
	5PU6TpZ68bFLIqfsOQaUT8g93G7YBInSu00oV8ooJm++jfqHELOVPF1uKCVHwTEA
	atiQ0VglYavnpg2771lbtzD/r1XGygJb9V/fbyGTQZpnosLjpEy4+adsZvKPWmNt
	bv5GW0TkWgIQ3khANJArVD4VSxdaT80n7jS2hl4ApmGzf3sWW0uCae4AfWVA/LHs
	uK1IrE3YOapBLGNO/rNbyDysCxxRjsmYcqxZAadyHYvJXBXnHQKHjw6dVt42AasW
	2ZzKsnRp7Wo90ZJmdkO/PEZDVzlFdqutZorWIjF35SKrHrRy+9hg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 497fxbsvfk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Sep 2025 17:35:53 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58HG0bfg001635;
	Wed, 17 Sep 2025 17:35:52 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010035.outbound.protection.outlook.com [52.101.85.35])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 494y2eafrh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Sep 2025 17:35:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DWifiGBHFnvtOp1CQQDgpQtS95DB9cSwVNzubc4oOewe9qVhav/y489G1nPyeGThSy8kXnkSBo7KYpAjl0gZgNBpys2GHFnHQNQf1g7itvnka2+xyPejR2bXccqaAKWPW2L0tNxHyWJpdW8RE+ekCT30Fda9HyCNiXjFH6ccH/sX0xiDOBxwE+Q+yGQupTtwTAts/8IrJp4l0Gpp2JMXkfzduKt7/SxTw89+Fm83fRZdgc/hcuyhwtWP+7nliIqwYQZcoB8PQKEDtmqbafvN+IkZPVNr7ucmQsPS6y4eVqYPgU6Rk7U6+Ptoo9mug3LWL6E3UoEwXCApC22hvtKuFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hZV42UnOJvUnQJK/rbvcsp7vB816684ZTUgviUXT6JQ=;
 b=Eew7Af+1S194r6/29lyr9hK1lY+DSKH4+ASkpEWCW8BwsxDThgCq4+6Ru8qS5sYzDySlD0pVhfzfFLJgezbzOGT+oqaFmGteI5qdHUb+0DOqrFFXjQm8CbjoJUu4vTEgkmfHRipgMuQLUythAGxO1T4iz2ZWOyj6S8oBdT5XMnpnCkGuAJWdybOUKVEkf4+SEn1/Ib+On7TUmj+G16X617StZtsEwy6vOf6HN9K6cas3XebKPIPT4GBBzRGKYHY23hVg1Ymn+7WqCw7G3qUDcuCOD8N2OOxzhM9uRfY8YqlkIbuFr/I/RtI5QjONjFfXInvM9z6ZtW4/6sW8q2hD3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hZV42UnOJvUnQJK/rbvcsp7vB816684ZTUgviUXT6JQ=;
 b=nyDljMqRR53Sb9Y/h0INq6Dr7acgwMA/1BIln7vosXSzrGHPNbBkQKl7FtQbQfDLqHmwQqH3ZCfHi4LUNo4jpkqRWd2llFackuzpbMwviIBlbdZhTCg+WCdGqkIYNTsL0VfbagOz3uu4/wKg7YaUxxjDOF4k2EB+rQWPHnaI7vQ=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by IA0PR10MB7136.namprd10.prod.outlook.com (2603:10b6:208:409::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.23; Wed, 17 Sep
 2025 17:35:48 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.9115.018; Wed, 17 Sep 2025
 17:35:48 +0000
Date: Thu, 18 Sep 2025 02:35:37 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: alexjlzheng@gmail.com
Cc: mingo@redhat.com, tglx@linutronix.de, jroedel@suse.de,
        linux@armlinux.org.uk, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, akpm@linux-foundation.org,
        david@redhat.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
        vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
        urezki@gmail.com, arnd@arndb.de, vincenzo.frascino@arm.com,
        geert@linux-m68k.org, thuth@redhat.com, kas@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, joro@8bytes.org,
        Jinliang Zheng <alexjlzheng@tencent.com>
Subject: Re: [PATCH] mm: introduce ARCH_PAGE_TABLE_SYNC_MASK_VMALLOC to sync
 kernel mapping conditionally
Message-ID: <aMrxacOJMsTY9O2n@hyeyoo>
References: <20250917154829.2191671-1-alexjlzheng@tencent.com>
 <aMrkoBhIcP37YgyS@hyeyoo>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMrkoBhIcP37YgyS@hyeyoo>
X-ClientProxiedBy: SEWP216CA0017.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2b6::14) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|IA0PR10MB7136:EE_
X-MS-Office365-Filtering-Correlation-Id: fc76d727-5166-47c4-6e97-08ddf610a370
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?co0778Qyn+hsMgsdn0z70lZy7F21FkcW7F3r+mutsjVRltTbzegaiP52uuMc?=
 =?us-ascii?Q?HRJLyLSinr3ZYdmr5AFD41HmYBCLSu15STGl7ho9h5b96ahUvz3NxY6auPYe?=
 =?us-ascii?Q?Xr3CC0h09U0b8kC2pFqsJf4TRcOTNrJL8/p1AemROgqJC+psXgTUtzH0hBFU?=
 =?us-ascii?Q?68N/+h9941EpvD197/ffnDLxm4QqoZ2+EGgUaG7VkGWmhGya45Zl/ks5zMq/?=
 =?us-ascii?Q?13szu0vDr+k0qkt/PA6Z9Rmp4IEH0FfFlEX5ZV5266TDjpFEbEPxPBddz3BU?=
 =?us-ascii?Q?w993m5hK2EfeqcrGLFQ3XWr2POrd4kevoOLS2JXDVSacedgCB7Ny3Y+Lqin0?=
 =?us-ascii?Q?7eZix/Cwgnb5vGilZJ1KocIfn4DpeGuaEBg4b4TTVNG6Ftboknn6KvxO68TV?=
 =?us-ascii?Q?cs10k5czNTndvTDedA+uuLeyVgM3wYDooOlfvHE6gcB2nhJG5G+281oK5xzA?=
 =?us-ascii?Q?f9BMX4xckQC34e4tZZ374msszerOQffJrK7e7xQDpFLc2be5R6Od8R7UlPnh?=
 =?us-ascii?Q?euFxX44EUovEHDCqalzjHLDgdxQ3/eXb5lW3gRJSmhjKwBb8zGyxSDXTHPY/?=
 =?us-ascii?Q?aId2pG/H0VcdvPsovOP7lpGhRIx7zG7rz65FX7sCgYPGTDN3EUQT41qtaQ3s?=
 =?us-ascii?Q?1YN3+S1PGB013o+WgBs988avB6XF6oqiaJIxaRnrd2IikygdBR6rLoMLk61y?=
 =?us-ascii?Q?wkMrYzF6zeojjeEVjk6iDLi6p4C9zIfjkXHap0cS6TGZMVV6qAoZpH+dq1ZN?=
 =?us-ascii?Q?sJVnw94I835X1sjUZQnc8vAX3eUMbZ1Jb0GH97F12elPjwcl6gJBiBW+cK0P?=
 =?us-ascii?Q?2OAbgLVUI0Y8SE24FrsH+Fy80PpNHjXNnJiUGF/gb79RIMwXVGlz2ojTTUMJ?=
 =?us-ascii?Q?Bcwo70iv7si/oeNFQpwf/UkwsEXfjjNuTO1IDcqiakEdex6otodITrLwiYDY?=
 =?us-ascii?Q?qcQs+zpd2PW3dAxZhp0eic6yF+B56CRSVf/A5BQNKCWmhMsEE6IconcFy3jG?=
 =?us-ascii?Q?HSBwy2N49XE4efNiFcDBJANlWIaHEN0AB1+GPtbc0hJWI74o/XElg04LSwJp?=
 =?us-ascii?Q?pYD4OZZow62Gwuj02R+m6NOvycHKc9frlxR07Iov6HH+HuBQOpBdgPxsCT3B?=
 =?us-ascii?Q?qflU8XfLegrLVmUEljcREz8TWcyboL4XYZmguKVzAT5eqbgt02aYYmUUozDW?=
 =?us-ascii?Q?OZl+CG/oiE5sWqCVcrKPzFwAKdyfBuMW3rnAd08oYOZh0gQy4iR+rLUQc27N?=
 =?us-ascii?Q?SRwhgJYpC42KgYlTwEQ25Xz17e+lzzrqF1nyxSdZ91pKtxVLLtSNVpc8gcOk?=
 =?us-ascii?Q?hssXqSLGFyYICseWg7hNc+8kS5klemr1JmvMVry/qP25Tb+LXkllwxwYaRfX?=
 =?us-ascii?Q?IadFAS4yNi+g7vfenpuqt6k5OiCvQ/lX14eFdApBcHPMGaZWkQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kcN4O8iTLYV2jjSF9TfKaLnjnyyH8kbb+mJBxFLEKNEs/FiYn0Bk8StE9UrA?=
 =?us-ascii?Q?WfGxXs6KVQekIxKsPcnVfjJ2iRCQrPkfjhpq7EUiy1dJ75wtviG3fQI6ZCmH?=
 =?us-ascii?Q?qiF7eq4TU5YPBCndvUdBAeJ6xvKNSWg6BnZNH8LkZIVg6W0P/SMF+P7uMzCc?=
 =?us-ascii?Q?NUmakmxSH+2Ve51YEac7hBmYxS3qRcqNqfraModzrbGh0st7syiBKCKOYSKO?=
 =?us-ascii?Q?HBNQAe5+RTR9x7H7ca1e+8LfUUonK+vIzNrHDfA/kMCWqoVMLG5ZT2EXU60f?=
 =?us-ascii?Q?KIV25MGD55aF7UXch6UJ3JDjFtVyfPRgjNInyO3UafvRwSZXJL5eo6SFQoQG?=
 =?us-ascii?Q?iuePJOQ7K9jhs6kfKd91kRkzZWdYNE+FogSqu3FZfjxIGPqbTJ6VpaRvDqjf?=
 =?us-ascii?Q?PdpyWjP39wzl5iAgAVIQ06Efa7/PP7BoWp+lrKXfeSVGAUD62Tsg131B/wxB?=
 =?us-ascii?Q?zsF5//PzNcIkxePyudPbzf4vvw9VXxZ4SxvJMO5fanSt4KKHJDBnygujsvIG?=
 =?us-ascii?Q?OvlhTxa2zb5gjelHICufZKyADH2kJRYe/WRRVwE1gN6czncUnK1odPIgGQMg?=
 =?us-ascii?Q?m8OofBZrgb0+ZBlv1d+St86mVHZ/WvSSDeDMSQ5M5HzvOlrIgWxkJFEmb1Mv?=
 =?us-ascii?Q?LWbgsgTfy/Z9tMgY5Ezc0D8Q96NXFm9cIxcr95A95HISLIQouSN7k87x9mDR?=
 =?us-ascii?Q?CMqrSDL/wEjq0XS1oQ8Z9S0Slr5J535JVKldXb4PL7HikBikgvufl00A+Ucy?=
 =?us-ascii?Q?Z2qUEjvKCmSKJeSjln/Xu/pskuN8u/KovWbilTZcQIxvvzxkJFowJBRIQ9Aw?=
 =?us-ascii?Q?dWMcau808+WxQ00kKsCyzNh6XwmHMwhe8zC4uVG8lOr3iUnSk4Y8HUCrZWR3?=
 =?us-ascii?Q?GlOQmGCoT4Tzl4Xl/Xzao3yKIjU68mDKAS+j5DDWrk1tmO9/BDVdgotKlLjb?=
 =?us-ascii?Q?0sQzQ4x4tKNNR6Z0OtWfRfwiUpsym6D6LiMERZC2IgsK8DarICFtEhr7qB0f?=
 =?us-ascii?Q?O58lDyYAfTyweCc+0slgLiatzXeSv0PxwtTtbvWFNN8XbDDxwc2JiNZ0+LOW?=
 =?us-ascii?Q?R/DoNEXVCYnEGE0qahOEdDzsWQscBppMNO5YNu6gGuHnFjSNUiLbQ6GmyIKd?=
 =?us-ascii?Q?MZU2DSTWhANvR59IGYSVJazOQXtUHoF098orj30FGAdkHDN/+Vq4s0EPunBN?=
 =?us-ascii?Q?Lc9XV8kz+UoHFllNhkTeeGT4SPVffKEsPpIoUGrAfMRSZGdRgsQiIwvRrjAg?=
 =?us-ascii?Q?LKyAMDuc521xn9HW+CnVc+pbml1pCJwdaAEk9NpTw1IpzhKg37L9tDKlZvN9?=
 =?us-ascii?Q?RiMcBfFeJcViAEll2bb3+MKmz7nII+Pzx2WH70MmPhCbsAnplZKdeuRe6dHn?=
 =?us-ascii?Q?WNsbTO4S9cXWbNt1G0OO4GpVGJTW0tDRlJCb9zbWY+QBzBwzZbFzQN23SK70?=
 =?us-ascii?Q?MAAoGl1Ts9y+akMZ/x0XuIgbZLc0qi7NbiHIxUUMrF59vYt0JyrfVvoCkc/N?=
 =?us-ascii?Q?3QGGWJwLNPo5/YV/kaYnf6uh4ydx5LNWTbJpVy5h7sxC4ZcR7aVrb2GBzAvk?=
 =?us-ascii?Q?2M6pHzpXzx2q9wKPOPq5617QuNlCcTXq0pfzUiwD?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	04ShOenl6xVpANhnBEmwEXCscCrL8GLoe0uX0KMD/DVFeplg7azCor0WdxyZjk2bbk2KVu4EjbdMJ5CvWUbrD/tXKJDRnIiZeh9n8zBsGo90wqHmpccAEHbl94mGycU3eZT8e/3MrLDsHeylj04I4McaWrx5HOzKOQ241D+z5rOYGOeGc3RG1Eyvkj/J+JaUkcOt3EQK3ifI5Zqw1rp8dpQIJT+MAlAAA5aKmB8E+IxttYeApOOBKuM9vLzkoYGQW+2Szq9lnJW5nL6M++q+72VUWHurC3fNTusTsdqJrtMIFBxe27eDFcp7VmkK2mlh+J47nIYEu4QwO3iqtxMarBXIKxicvzVJ4Su111tWWH/LQuUYq4AK/N5IAC077XYJ7Jl7hXI1WR2ZmIOYmQWh3BJt+4YlqEBPmcJFc3gyAYwG9t3SR/88J7L8GpIGSlldN0VKAKz7VMWPAtbxLpOAXCclEe5rUmeWlA1zdUfn0sLhevIvNFTXlqk273gu8NvfojVptTX7EY/bva7hhhloPSt3wm0EP+FnjO2ov1mfH1nPbDoVVHkvM/EQiSRA26ZHeh0bFQS6hV/QuDE3VvvJMrkZ2iUJIt5lGHmF5UyNa9U=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc76d727-5166-47c4-6e97-08ddf610a370
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2025 17:35:48.3986
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9PY4af59avpOVwQ0rtyYiDlUe3fOQVXhvEpVLHdbebvZZgF6u3KDsSs1iLMU8pwWFV2KiP+vdmRW7Z8B/gdbkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7136
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-17_01,2025-09-17_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 suspectscore=0 spamscore=0 mlxscore=0 adultscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509170172
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwMiBTYWx0ZWRfX1zA+gCa8aXrr
 uShu+x4ru9gKX5YeTY3c/+3i7TnFvLvKvgbiSyg/uPwEfwQoITd01Qbgr1IiNnayFi8SUbNOCxD
 he9SdIkweXatsBZQ7oIGaH0n/2gv1/ttjmuLs56knUkFPGn4I66tJOBWM1shLBVyPW8Sey4bOkS
 I3YRwxnOthfmfn1LKMV2c/8YwMt5ChXx5jX4abofQMQp9kYcZFYGQST6X8r1PbPzOEytshA/xxM
 PWZ9CUDIdacHaZ+TjDWvwTU3yG8NZLB9knGN1VVPA2CJdXeJQDACsDaLSTlReqkySXyFIcU0VGv
 whF6DGeLmFJOTH4RJEePMTxQJcaki7EfiTsHLmD8aStxBo7KRjGLLqTOEsE3+i8exwkKqVe0VIJ
 odSBAt8r
X-Authority-Analysis: v=2.4 cv=X5RSKHTe c=1 sm=1 tr=0 ts=68caf179 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=pGLkceISAAAA:8 a=GvQkQWPkAAAA:8
 a=VwQbUJbxAAAA:8 a=GiOktInpZuFpSl9g64gA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: X4qd2KcOwISfIg18ye_qHi-yvhwHQZXG
X-Proofpoint-ORIG-GUID: X4qd2KcOwISfIg18ye_qHi-yvhwHQZXG
X-Stat-Signature: b637b5th9okjbxm3xytn5k9idfn1jymi
X-Rspamd-Queue-Id: ADD27C000A
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758130579-484560
X-HE-Meta: U2FsdGVkX19H8L1AdxgVY3LTiE2ryk7loXkG7yCmx1rS7cW3lf1z0Uuq7Nzu3ECh1wZV2MPM/aBpQC9pUDUBwN7YcGlkAlTyKetO0KczRApLf58jW1JH50LPO49q8LBkIfo9YeCOtX9BqggX3voNnZRVOiOwWfWMlcJF/gQOtNkt0TLksSa/GqzQYlSvQZLXP1d0PEpGAl7VC2VQVMWs1usmKNni/K8o9z8kNAx8yvwSvtV8BAUamuHpXofzM6+H5x4maMCETj7ZG43WxsaI69XX+EsNEvVrwY01eQ7o3DapzbuwhvUF1zjUg2ru5NugexolB3jwh8FsqHgyKNK20wdjEuUm9arG9M7KA0svbnGWQ6Z8hY3LFW9POUALzUW0dZP3H8cTobTWRT3hoIPoxAYXELyGklviwbTWX0LZePNA6WL/0Qi9+SwQSCYSZhphNuShOM3KoCx5RVuLDK2s8drU78yyDTaKckuW9f1SeaAXTIMa8VbizxZdxyaiQ8zB/Mo/hgBxgK1yzQi1soWuuF0mzmCd8VlOUSCiBxVVyCji//bZN5R46FI6gCH3abutM83tudukGM4rJHnuemzXv4tJTRpzVN3artWAdCdOj+w9+ery1Z68F41wEra3Ro7VUvg1sD99EEiqA9cR2kyd+lIPbmypEhc+c7KKup2RHJFz9Mmb+vWmJAMO5k78trQXMdRC4ASctZk6suikPCX7QJYWdaBGgNUJMEZvyCd8AtJ49hp/tA9HlH2AAJ7g/ukMrFAkzE0LXdrOiIZKh5sQikGDJotAlP7VAzgAKIv7Yh131SDchiOHH8lz4NVJML7tEufoY5sUIkyq/aAIEcJUk8Q5hN9TBRFhBvkcYUT9eWPpCtTVSMoMi2P60HgcW5gWxOa34aiitNWtXe0cc7iqVS+2ghYBpdV5l0J6T4ONR3MobMetgIt6XUArYuQ8sgPerGM3yQxvBB12kY1z49l
 xS7dhbAq
 qnp1nWI3T3S8qT+gfYXyJQN+BBCJcacCxREf0TAl5BQybQsN+O981FjnhlmUfCQC5Dgq6ZGvXQEn9L6Inxdq0cJtR8PmwfEBW1/j3ZGXjKMZBQzXhTB9PtBIJQCve02+C/v6m9fv4IFsdVN2xct7E/V+pFyAQZn7RL8XjAkBVPCmN1iGpk+69TFMvOI04Bw7D9s1ox45OMZBonyhXXIbcpLjYsEGkqJzj72pB9D6LWSQHs/5CNlBjs8yf5CT4kHzCRAM5dTBYmlyYzLFuuQ1q5FBHMFGnFt7PcTIEYHocU9G6IYDt8REKT2qL0hgi3KCdjFfNpx2vW32VNUn0iHB6QyTtxpNJls9/NMx+bqG3eLDemPYZeGmWGwQ2sfbG5EPvbMPn4ghLXcUNOs7NG3NG3xDHLoDQe5U48/TXz0dXZydM8aEMzXFqnT4oqV18LwLtf2nz5Ee9HWvhgtYZlZMN1cvD3QVbOd+cOAOIEF7McbaVS1UzC81V+5Qs2dEvCNQ68KJ0+LhcrEaKZBmAc/g3ISNZShdi5Y0mwWJxNF6nC+C/F5md6ud9SBcgfd4W0yCdMhK3EOoJR1ZkMkPvr5Dv84Nhcjb+ITAflDeIEL9Jgc8OXNkQ3i8eOm4ZJUKD5TeNdG1N9J3xplcD1pLlvyYp5M/myuvfd1vvhUXZU+tiFWNVGJXD0l4Bxdmae2ejW27bT42RJUXx9tDXDyL8NNZXSobhcu1GzWuO4CT2PqhNhmJwCAvbbcTHy0GLfyZiuyCd7duTU8dScePUBnSIwzNtQAcqEpeJVS63h8hm3CbgcN5pGBvtEUn2JQfKxzPDq/KirK/oH9Mm4ZQQDzU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 18, 2025 at 01:41:04AM +0900, Harry Yoo wrote:
> On Wed, Sep 17, 2025 at 11:48:29PM +0800, alexjlzheng@gmail.com wrote:
> > From: Jinliang Zheng <alexjlzheng@tencent.com>
> > 
> > After commit 6eb82f994026 ("x86/mm: Pre-allocate P4D/PUD pages for
> > vmalloc area"), we don't need to synchronize kernel mappings in the
> > vmalloc area on x86_64.
> 
> Right.
> 
> > And commit 58a18fe95e83 ("x86/mm/64: Do not sync vmalloc/ioremap
> > mappings") actually does this.
> 
> Right.
> 
> > But commit 6659d0279980 ("x86/mm/64: define ARCH_PAGE_TABLE_SYNC_MASK
> > and arch_sync_kernel_mappings()") breaks this.
> 
> Good point.
> 
> > This patch introduces ARCH_PAGE_TABLE_SYNC_MASK_VMALLOC to avoid
> > unnecessary kernel mappings synchronization of the vmalloc area.
> > 
> > Fixes: 6659d0279980 ("x86/mm/64: define ARCH_PAGE_TABLE_SYNC_MASK and arch_sync_kernel_mappings()")
>
> The commit is getting backported to -stable kernels.

Just to be clear, "the commit" I mentioned above was commit
6659d0279980 ("x86/mm/64: define ARCH_PAGE_TABLE_SYNC_MASK and
arch_sync_kernel_mappings()"), and I was not saying this patch is
going to be backported to -stable.

If you intend to backport it, the `Cc: <stable@vger.kernel.org>` tag
is required to backport it to -stable kernels.

> Do you think this can cause a visible performance regression from
> user point of view, or it's just a nice optimization to have?
> (and any data to support?)

And that's why I was asking if you think this needs to be backported :)

> > Signed-off-by: Jinliang Zheng <alexjlzheng@tencent.com>
> > ---
> >  arch/arm/include/asm/page.h                 | 3 ++-
> >  arch/x86/include/asm/pgtable-2level_types.h | 3 ++-
> >  arch/x86/include/asm/pgtable-3level_types.h | 3 ++-
> >  include/linux/pgtable.h                     | 4 ++++
> >  mm/memory.c                                 | 2 +-
> >  mm/vmalloc.c                                | 6 +++---
> >  6 files changed, 14 insertions(+), 7 deletions(-)
> > 
> > diff --git a/mm/memory.c b/mm/memory.c
> > index 0ba4f6b71847..cd2488043f8f 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -3170,7 +3170,7 @@ static int __apply_to_page_range(struct mm_struct *mm, unsigned long addr,
> >  			break;
> >  	} while (pgd++, addr = next, addr != end);
> >  
> > -	if (mask & ARCH_PAGE_TABLE_SYNC_MASK)
> > +	if (mask & ARCH_PAGE_TABLE_SYNC_MASK_VMALLOC)
> >  		arch_sync_kernel_mappings(start, start + size);
> 
> But vmalloc is not the only user of apply_to_page_range()?
> 
> -- 
> Cheers,
> Harry / Hyeonggon

-- 
Cheers,
Harry / Hyeonggon

