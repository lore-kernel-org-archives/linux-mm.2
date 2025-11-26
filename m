Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08C4ED10F58
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 16:18:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 526326B0031; Wed, 26 Nov 2025 11:18:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FD656B0032; Wed, 26 Nov 2025 11:18:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C46C6B008C; Wed, 26 Nov 2025 11:18:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 285B46B0031
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 11:18:54 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C980F4FF9C
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 16:18:53 +0000 (UTC)
X-FDA: 84153266946.03.766728C
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7A24C14000E
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 16:18:50 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=kXO8VlCo;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=VAH9Tzct;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764173930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bBMb6pz1knNTYn3iZQWRKXddSMynyby0yvF5qqrpPw0=;
	b=AkNgcf1fOVv0X65eyOiZblWHNA54Y3g8BX278OtdZdc4LvFg4jxuArOisffoafUdHMCDQ4
	pBmdAeXWbUhn7oAlmx97loCYQcKrHdX1sojS5Ka6TrqN9A/O0ybEN8pASdI80n7FUDu5rA
	gv619SxRG4dEx8XCTmRD3aK+Rc3N8s8=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764173930; a=rsa-sha256;
	cv=pass;
	b=VU5+DHDwz1gg++Pj3203uoTGOjRkQt2L0DDxuOEGZkCjSQ5IuwmrZKrV3ozlJkm8nYAWZs
	v6Km6H9xyAjQ1zFutDBVqrLxw2F/UvRYNUWX+V3ZaCz9Rxlz4t9XJgvotdCZkJIMHYWqk1
	mEsYT1BciZ7yiUSKJ+Hn6BeaLrY1JT0=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=kXO8VlCo;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=VAH9Tzct;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AQGGkr32639375;
	Wed, 26 Nov 2025 16:18:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=bBMb6pz1knNTYn3iZQ
	WRKXddSMynyby0yvF5qqrpPw0=; b=kXO8VlCowcDty5haBRpjaFGjCGlLIzlgHN
	l+JR5PwccRVrMY78o9f9YE/dJWoqoc4GFwcIvmkgI0aQISgCs1GL0PidxDO1F7Ta
	2x48I4qr4nyi2qO/X89n+3ji0XwK4IJeuGGz3pXh0jbJX6k+jvm7StKSzChMi2Ch
	iiGZXTgfhqIhAKvfHhDgmv4dhRhaCVMxpMUuhtjZa5ADng0Zqv+aS+eBR/Eh7lqA
	3267t07tQV0HUXygfK00IWLT+x99B+5+punw3FMbnvCHZQPwRJqpHeqBq/niE6SS
	hDYCi7O63DSFg1rM28w/PLJr0aOfrIFH0uGv/23hHXdu/GjixbIw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ak811vjns-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Nov 2025 16:18:43 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AQFd1hj022486;
	Wed, 26 Nov 2025 16:18:43 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012044.outbound.protection.outlook.com [40.107.209.44])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ak3mn8bsc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Nov 2025 16:18:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h+1ckw/ERt1d2ZW/OQ84qQweid2lA1GJuW1zAzds0xMdtcL0TLemHhcQ0gv+3LWEzM6+mH3eLs1l4rudu7qijzhvbmFU/CzRhinkZws1okbendy27eyTzd4JeOpk9u06Jsm9QMZlwveeJxO3/sXOLF9U1YSnW+JLFSYBTZuJZyywz2NYrbxuC3TweorazQ6Q0YdXpz+m7A+2Hk7OIGXgK2KH1n2zzl/FKzReujXQbuRQrEjRSQfPbyvrMtjD0a1YQjHxULpmbxvp/xci/+6cJr4CtpGMSRzo6wKfl94LBU60vhjbBO1tNZpcDJyHKElaxFoEkmN33ALQPs38rTqYhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bBMb6pz1knNTYn3iZQWRKXddSMynyby0yvF5qqrpPw0=;
 b=FhHM/OImPHLVF/cb5nWLQfD+9Rd4SZsJoxFeKpuzy8wKG2Y/yuW21bzYDD/UBDTl6vn1n3QxgRF+/+iBpflqatBrAkGUYxvH5k1hr4yHJCNdtxUQllDmY1EWgdsxsZ0gbNKs5rHanriC822sV/CyFRoSI85BcbXwA+UHz6QGJ2pJseEmpYzhcOBGouks4tC66uGRxIXzDZ8VVlhrM/B2b0ObjlE0TUzLJBv6XzdmJ451EPtLu1u19JNpRTfAeOsFFa/veFsk8Ymi5LMbBnE8zjBAatvPrJl5M5F+CLuiZXJh0TXBdmsajWs1rg7Uo36CXd0La4yF+HKkuOoLUMMQrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bBMb6pz1knNTYn3iZQWRKXddSMynyby0yvF5qqrpPw0=;
 b=VAH9Tzctx4HdpnUV5HNpTBiFH4RE8ic41rie6UlA2g6a9Mn//MSV6X639WRmltPZe/Vy9jOyvty6O9+bkfWuArdnkv0G71tdBuQ9k1qbJitZvAjNl1VPtfE50n2pmdss6mvKRJswcZYb6EqN1BQQvmymt2PIXLjmxXqvzzIF/80=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by IA0PR10MB7623.namprd10.prod.outlook.com (2603:10b6:208:493::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.12; Wed, 26 Nov
 2025 16:18:40 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9366.009; Wed, 26 Nov 2025
 16:18:40 +0000
Date: Wed, 26 Nov 2025 16:18:38 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        syzbot+5b19bad23ac7f44bf8b8@syzkaller.appspotmail.com,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: Re: [PATCH] mm: fix vma_start_write_killable() signal handling
Message-ID: <a03aa1c8-b54a-4ac6-82f1-40a06dcd7150@lucifer.local>
References: <20251126034404.2264317-1-willy@infradead.org>
 <CAJuCfpHmqy3jA-7YUEpLBe+cf4_4TSbimqZd+9Cc4Z30mODdZg@mail.gmail.com>
 <cc823b79-7a2e-4a73-bd9d-b0aa492807b7@suse.cz>
 <aScXSEY7v7_fcEZF@casper.infradead.org>
 <44f4d9b7-45e3-4d2e-b1df-cab8e254e54e@lucifer.local>
 <058f5858-f508-40f8-adfe-e5de78621d64@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <058f5858-f508-40f8-adfe-e5de78621d64@suse.cz>
X-ClientProxiedBy: LO2P123CA0028.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600::16)
 To DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|IA0PR10MB7623:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a47a78e-3e37-4a36-fcff-08de2d077633
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8NG4sMwSeGpkLlJwYkKz8Mr1Uopf4A/IinDcwjXtkJC8PeO1V4I2WpONWPYK?=
 =?us-ascii?Q?zlc+4wBmeFBvxMPUJKFvRn9dsiI7daVuwvwTcjEnVYNFjSiPrP/98c3Nam4+?=
 =?us-ascii?Q?h/PDMmZ32FV4s8qUHHhzzWPeK4+STWqD3prh2lElKo78GxRNrZuD8CD5IdHo?=
 =?us-ascii?Q?FEnfqTqIfpiqUA0TngYMML2pTvohBDfBTy6vKPdmZKQWbdisea9HYPJNyx68?=
 =?us-ascii?Q?pGrGpAc5cDS2VEjqL1yeUSYytz9gwXTOtU3EK4yVP//X4160vGLMOzcztFkv?=
 =?us-ascii?Q?Pv8JXyQBYVr36yvyYcxbXAOdPID1N4S9SYoCDgnWYPl8W7QJfOAWNjSD/t8c?=
 =?us-ascii?Q?BBlQCGosMJNnELiVQFh+gAL8zAOdA73qeghvSCwcRuP+RrW4ebCynfNBApzk?=
 =?us-ascii?Q?5Qp8hyYRGs5y2D5zPVEcgf6eHxHC+6NTvn/Nt8fgMqqUM2YioJsjINSNVrBl?=
 =?us-ascii?Q?xgE5G4vNWLB7FKf5B3ZgDBtW0Ts/ZUFpZCVrQ6XTvqmNOsPZYzad4E2+xckC?=
 =?us-ascii?Q?qjb/2g1OZ0FYvTCuJvK0DlgVw7VG+j6NqfJ3sbNpEqF/FRYhuEqYXIhJT+eB?=
 =?us-ascii?Q?JWRsbvXY7rb3iNBvUCD5BhfO7CCZfAofJNIRZzX72Jhs76xowkcy0QmEyJ3M?=
 =?us-ascii?Q?ITRn3Xb7hbIlX+KhfyunvLEfgFjnJ6z2Hn76WeBzKYc7HX91trWhGp5xmv4e?=
 =?us-ascii?Q?ClSQ2PIxUKx0GhkYoC7y5Kbol1K54B+hPA90H6jFNtgDRssiWPwNQP1ksNX8?=
 =?us-ascii?Q?4sZXbBYuSnLanTAZaStlMfCA1hAQTKTcioiYAYTvd9sIMDQiz09jpThLWT5T?=
 =?us-ascii?Q?MNkM2QmBLAb1ofRURlhWkYxgMNbXGrcbB1cU3uHMMfBltrkHhbnTYJDyMJLg?=
 =?us-ascii?Q?HNbJvI/0QTACkWYXDDKHOt0Do8cRlORoYOs9eF23SsAkokdvLYrNF7DAS1kU?=
 =?us-ascii?Q?qMwcQO4iz1LtG7Ya1SCksuq9TU1cmhb3Ga3DNwqivXv2iE59iisv0zg/Oilm?=
 =?us-ascii?Q?idfTCDfUatA/TahL9aTBElwEzAbftvgWsmEMB7RAKITF5XKRK0VxmVw9Ond3?=
 =?us-ascii?Q?7vT1t0wrAFFze7cz0VzjnY8Kn8Z1P/OhR2LJFsLFj9vCcGyacJYyZZU69Gaa?=
 =?us-ascii?Q?/QuvqwzWKuY6Uu6KYKzkYa5NwE+LdgjtGjKWQUZUCbY0kWM9wh/pi4ODpikm?=
 =?us-ascii?Q?zFxM/PL8dMI+A7Ft2W1TYL9hXZJsEzk799Agf+VUOavnSSECoYwjLM+ZM9n1?=
 =?us-ascii?Q?/Q19lAtlk50cShZ7I/oEzF5oTiM46bz2cxrOzVMrjt9UmXegrcXT7V2hFbnG?=
 =?us-ascii?Q?BF0or6MpAxIY6dKOfJgXCC/hs0RM2M4FVMycQGq6U9PJTo/ki/4vbpN8djrU?=
 =?us-ascii?Q?JlZEiEtOHC+aXIKAcvrVIz963+LqEAui8OP6fZXJoRsgh183aSAYUUEBakxI?=
 =?us-ascii?Q?ZGFTXod1gAKmltL0AqXDOauOO/LQP5DJ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TCmyy6tfTCWVovzUKurbUifoB5StbfMJIRmpDBjLMPx6+nMtME3KCenN4EOE?=
 =?us-ascii?Q?rkY3YOs2Lgftatxfje4aWUso0KDU113ndoxCzkpak47mJoPWIE412Xb6Ge81?=
 =?us-ascii?Q?g9BnGuppQDmH9cS0IVlcbu13MV2Sk71dOnw7B9Pb1e0HPS0UpKTb+TIzfg35?=
 =?us-ascii?Q?TyjGc+gdbilj/imIAt24zdNef7ywmV3BTG7fS79BN8mf+fqIiuDvfmh9gB/w?=
 =?us-ascii?Q?wzshabV9VSbJJlWM+yt1ELRDFnQbuJvmWtQ+V2xCjO4Bz9F+CPBd/YdbuZpc?=
 =?us-ascii?Q?+n4FFudqqaXKLUCmNGr0NN5BjPdOTNkP3EHw5Pwo4Pt1Sc3OvfvfTWmX4nqn?=
 =?us-ascii?Q?r/SQuL1JuL6lt8rB12G4WPdxa7VqK2wjCI7kLimvoLA85Y11lVtN1SFG39g7?=
 =?us-ascii?Q?/EfBvjjt0H0SYpQC4CKXqd1exOfW9by10FHSxyz+MSMpGEt7PxPjLpcVJzXB?=
 =?us-ascii?Q?ksVuBQn2o6oJx2xVW9so8lfy4Im+U4Oon0k60hefYIikuEG1n5Wz8FpUZVpq?=
 =?us-ascii?Q?w8DLGl1ifQqESbaeM6ElQntpq2NFdv7oTNh/WFa4hPYttbzUM2jCN4tLqDtm?=
 =?us-ascii?Q?XT77vfcew5O0WeI7dZx3q2Z/D8weIZT4CgIChV+FoM4lXLs4mB1odizC+mLe?=
 =?us-ascii?Q?bQUaQBJq1fjwTGqjtF3tlV+eLsFEcDgYR6F5SZ9jngGfw7tlfGHfBVxZ5pa2?=
 =?us-ascii?Q?aM+3faWxg3CYgbUnU9wu83rRxBbdsunn9D9oTRDRtideF2FXNpm21bQgyPbI?=
 =?us-ascii?Q?blwFS+duFIysYl9ISnwN73IwvwiqrRP5SvA84JNzbYwKMyPFQ4yLodUFm29E?=
 =?us-ascii?Q?RU60Y5Gwf+GJmJcM/20V9I640eAP+G9rekRcK+a8b/yNXwxmYOreiBNp9Jhg?=
 =?us-ascii?Q?t7PQSlr4rPynxrv10GduuIT5gHy7HouML9+7SFVpBUblL0zdvCbW/42259lH?=
 =?us-ascii?Q?LpwM/bA/RJeDdJV2x/dN7Ly5O38I408EOIjvbh/lqZaGvzPlgLAFycWP7YsZ?=
 =?us-ascii?Q?8otp4zhfGouLHu3wAkKCldBA/h8G69McPR3QClGdbxYewBn/5ofLo6kfe0FZ?=
 =?us-ascii?Q?uLlrf0F6FuzWsyztl43aeVZGcoa0W1Yv3LjY5AwA1VKZ8hBkQBKSXagP45YP?=
 =?us-ascii?Q?56F6FXU1xxYY/YMo8tLIDcwyTt68MK7e+qD7k4MKVGLKCgOMwGtK7xwABcX9?=
 =?us-ascii?Q?pIyWQ3cHUdeMAgDowsEnNeJxVx/5a5TuVycRwqiW1JFCBsklVLUT85EbieF7?=
 =?us-ascii?Q?qYKCi8njf9CvZiapllEvGtcWEQE9XLBHnPD1IpkjZcYyqE2NZzPXF5/kVeRL?=
 =?us-ascii?Q?mTMUeELdB4QS0nPuYfYbut0JGSqVK3R0uVDMxt8vJeN6vjSbK3SC9iOQvfHh?=
 =?us-ascii?Q?sVe3fLTVWnumY5yri3moI/mryam6OIHfF2GAxj4uOjxdCXwxc9d1aPJ/OB5v?=
 =?us-ascii?Q?Sj7nDUQklE50OvU3MR1ueAtw2v9tAztFPkqMq76OCulO9xpZwe97PH3OEx+0?=
 =?us-ascii?Q?7u42Yg+ym6UWOePTpWENTVdAi8/PUz7A5/dUr1q13RLyKGStNLBiici+ipw7?=
 =?us-ascii?Q?snaeW81JhRh4eG2zVviLTUu8zb+oHLuyN3ZyNeejgO3F6VYqyRSgSIT8/Sfp?=
 =?us-ascii?Q?VA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	J0lFlKjYI0bmj14CoBpX/cD/qviuIR3s3hcQcwBPAfq7KcwxvQmF6bFtBWPmmJxoFseW7myE8HMCOZRf4rvamRheXGW6H2n0q6I8kQVkKG1L4qD7EKDA63XCLTvmrSY/ojnIJT6MOosjSC5/JVqrYAF7AnTYjGhNIyvHEY91kOmH/dMTr0O1loMjCljinm2sdEriZlJ/yz503K/w610bNpTgx1sKnl5Ccw/BRir3fnkMj0mebXgJuDJxn+TNFXChXoM2OppI+1dYM6lkB9UbHuaYeTUxD7Hpi5OinX8Qhl/CbyLxbE0rEmwi2bclbcf92wf0ODhMD/zHnfj13w8RGnM6dzdynq+kbKcsiBPz/tkmpFoDoCQtLmVf+x+e1PFKTuxvsnKQ4xXgJ4X92AvV9XjBJlBhIwzTzSkQ0Mq2DLWnlMLLGCEi4N5FI1y0sJhaU8136fr2ztVQFHSNQ0bYY7ee/7SM2ZqskxBkyLtEFJ+DAUNv+YfrSB8rgcTsN1jfsN5LNwKg3aqDkWlXj1FRoq3a3jYJ2NFJOp+482sfRfwiGk+9IWtnyZeocBy7gdhEkN+9+L97Sn9BIcDkG0H3uLe21PZt/IGOmkB/zMl3GOY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a47a78e-3e37-4a36-fcff-08de2d077633
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2025 16:18:40.6131
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WEwYKEMrAxAFqwMbJtHvmJkzOHJBEvFlyn05QxDPU6Tt5Pnas/ho7x2Ajn8SnWsWVtxPA/Tis6Ewcg8C8z1FPQ9Ku+bpoy/hDznOAsAvgIY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7623
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-25_02,2025-11-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0
 mlxlogscore=999 suspectscore=0 malwarescore=0 phishscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511260133
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI2MDEzMyBTYWx0ZWRfX2UcskKk0AkMt
 Eye+fXeky7Nnf9/Mh6C6d9TsC9sz29JqPRNl6iaIBS3V7HSggNEuOQWDF1dmQvCLs1Y8EiHwRBw
 9c8Q8/Q1gUKyJffQku57L1CbHdNgTB7PlSFNY3Z2gsCg+1RqnAVCk0oRKHp1HkI93v4q4/8adlx
 0ejAdIu8IizElFxlj1ZkAgrjPEh9xShsY2NmPp9ifj1DnmxbGRY+GGiWYGiowRPEJLQ/wE4KE2j
 LUa5W6TSNDhMP9dFNGDrTPKex9r7eEnDS7wG7oGrMc5VdP4EZvTM7GkEbFZrRRcEv2SQpAu2WFA
 IsWJ0Gx170cuO3p5QOZgYA+fznKel6XYQAq9IUNTmK/QoBsKpWLOb7FxYSrqMEp3kndrqLzcu9x
 KiGpN9cmerKHYJEBUdyJXViaS0/OirM92XfkzwtdpRd9qwr09K0=
X-Proofpoint-GUID: QBVIu1bZR2EezmbPw9sa4evvRuJJQmNd
X-Proofpoint-ORIG-GUID: QBVIu1bZR2EezmbPw9sa4evvRuJJQmNd
X-Authority-Analysis: v=2.4 cv=KKpXzVFo c=1 sm=1 tr=0 ts=69272863 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=L6YG94Fz7MpyKO5tJOQA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13642
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7A24C14000E
X-Stat-Signature: i6w3y4osyudg38ufihjof9edr97jzpsh
X-HE-Tag: 1764173930-319307
X-HE-Meta: U2FsdGVkX18N6GJWBVHDApX1NCvoc1LbNPkz40nE07dGR2MiWAwX8ZXt2PUvA+EKKiwXiWSz72dBUo2Qo1BUGSyVsN/zKRjSass/N01IntSS8S6MGOCiIxRf03CugdgiyPxh1Z90iUs3Bvj5k+3g0UaONEeqK3TsC/GnE9Axoq7U9dXOX/i1Q238j26TkkQHvJUjTTNDthueYLqydbTjHfy/hCfU+Kz/ATXOZbDav7iVG2tGi0OLMr+QcC6uSIQB8LFedCHXJ+UcxrzJb8n2fGEd7sPs2ACRZ0RFHbIzsOS+fCNONUpbbPmxLsyKAC2aRN8GvaFr1jZ/Z96396A/6HNCljS/VHfxWJpI27ayT1xc5wb9LNMvJoAbQBG2CtHxCjcrgMlUmuiowC153eek9XR5hxn5qq3IatN2IihsGiIHuIZWn/magOkTRWcQkTu1tCxGuwAw0oyqfPaJzM9FC9d/do3tY17MolqJgSpaKbefFZAh5bw+C2oejUzvuGpH0jd01ZoffYEViNwGLF5xz1oYhhfRQbtr4r50iBbsaNbqlKBgrqlU2DANt5OrLKkfcQwEHUHoIA2MyLNwBpNs8MwDonkgv+r2wQtTyXuehxqj8HzdmPcpIlZmOBDVJFLDJfCBY37IUr4Ha/eXSYTmcrjWp8i8kxQsGcX4YaOCn9fOXXuNljouFLgffpm+cZ3PnfgRvqJ78Ii3ZrBJlcuqaZoir07DgysjF/rLaPbWL8cKSURr9irM1lZO9ozN3eKez9OZvuF2Fz/uhT4u3QDgYFG5KsMGei457b38cXj522pszJGSrYk8qzKvChe3OhHBNTy4uuHrGW9S1BNIKJwI7qVhCXhK4yeRATPk5vARRpr36pqKw0uO9FSJ7I74RC/Y+Nn1R9erG4bL2rewsNe83fSTyKfnmoonOSnUZ89jKJMHEzR9+4B7sCKQfAeYoS5qSISFBtdyT+pvZoZu1/F
 kY/IrvKn
 wn+qypXBmNRL8Isv6WSaRBsbELh6Fiyx+UQpggZQbIoHb9GMLmifOzSdbmS5wsY1L/53s3b0tUd9OsHPiQKMgk9APpovthf1AUkPe3UozPD1zvbfu8oDOr2qp/G7kt1FizzRUHw7bgj4tnDWSu4nWc5OE9EM59MucWS7drGhaglwLWgfRlHGVlFLyWWj2bMMCnU2t8hw49TSF4AA00sCLlSXZbfxBVtA8BF0YCtOmg6S20aovzDFeQIKFFmcUrzrlDNhe4Yotbyfk/j8KopUxp4KoSN25fXIw7wxAg9Oj6pPBQH3WLgMdwHbL6S6PGkK33qlL7tMDiVYlbfIR7yp1p22zgOyyu7GTO8V7Q/hyznVbe1ATVaddRqePzoIilYOXUPgpQFQJXLJ3ZhXf+d3OcN7fvLh32ItdWW0LylUBCWW324lds/G+tulCBR5PTwcmswTasDGVAB8Mi1Hqp/hmS+BoiPqRy+rV8NiADx227ezQykxMEd7RLZuI9sNcZhsMQLubDMCckLApRbHgscsB+nMIrp9OeXzq1pj/x05oM6f7nXvJjuccRNMvq8a/PKd6uLVMAsDS7bQh9WV4+adojuOZ1fM7j7NBKafOvHJJaIFA/Y1ecKdBn/Or+GAnZiSeA7JUrlIeFTBnuQAz3fgdYnC0aaLbGy6dsqR5KfNC74Wfz63O6jAvYqC9KOIP2Nsl8XoJWZmPugjR0mOe8iD9xinFlEsqc1/ZmPSJJ8m2UsI49XvxKQ3Y+Xd1VndT3wISthAXI73gzmFJISY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 26, 2025 at 05:04:09PM +0100, Vlastimil Babka wrote:
>
>
> On 11/26/25 4:20 PM, Lorenzo Stoakes wrote:
> > On Wed, Nov 26, 2025 at 03:05:44PM +0000, Matthew Wilcox wrote:
> >> On Wed, Nov 26, 2025 at 03:36:46PM +0100, Vlastimil Babka wrote:
> >>> On 11/26/25 5:28 AM, Suren Baghdasaryan wrote:
> >>>>> Suren, Liam, Vlastimil, Lorenzo ... none of you spotted this bug.
> >>>>
> >>>> Doh! This is embarassing...
> >>>
> >>> Hand-rolled synchronization primitives are wonderful, aren't they?
> >>
> >> That's why I liked the original approach of just using rwsems.  I
> >> mst admit to having not paid attention to this recently so I don't
> >> know what motivated the change.
> >>
> >>>> Wait, why do we consider this as a successful acquisition? The
> >>>> vm_refcnt is 0, so this is similar situation to an earlier:
> >>>>
> >>>> if (!refcount_add_not_zero(VMA_LOCK_OFFSET, &vma->vm_refcnt))
> >>>>         return 0;
> >>>
> >>> But this means "vma is not attached" not "we failed to lock it".
> >>>
> >>>> IOW, the vma is not referenced, so we failed to lock it. I think the
> >>>> fix should be:
> >>>>
> >>>>         if (err) {
> >>>> +               if (refcount_sub_and_test(VMA_LOCK_OFFSET, &vma->vm_refcnt)) {
> >>>> +                       /* Oh cobblers.  While we got a fatal signal, we
> >>>> +                        * raced with the last user.  VMA is not referenced,
> >>>> +                        * fail to lock it.
> >>>> +                        */
> >>>> +                       err = 0;
> >>>
> >>> Returning 0 in this situation therefore wouldn't be correct.
> >>>
> >>> AFAIU since we started with attached vma above, it's not possible that
> >>> the refcount_sub_and_test here will drop the refcnt to zero. We could
> >>> just WARN_ON_ONCE() on the result (in a way to make also the
> >>> __must_check happy) and then can return err below.
> >>
> >> But how do we know that we started with an attached VMA?  Maybe the VMA
> >> was in the process of being detached and still has readers?
> >
> > So we're talking about:
> >
> > vma_mark_deteched()
> > -> refcount_dec_and_test() [ ref count is zero ]
> > -> __vma_enter_locked()
>
> I think it's refcount is NOT zero to continue with __vma_enter_locked().

Yup sorry, misread the ! clearly...

Which makes a lot more sense when it comes to picking up spurious reader
refcount increases :)

>
> > (meanwhile...)
> >
> > -> reader attempts to read
> >   -> optimistic check doesn't successfully find write locked VMA
> >   -> __refcount_inc_not_zero_limited_acqure() somehow doesn't notice 0 refcount and increments
> >     (??? how)
>
> That shouldn't be possible, yeah. But per above, it's actually not zero.

Yup so this just makes it more likely to happen...

>
> > (back to vma_mark_attached() -> __vma_enter_locked())
>
> Back to _attached()? but it's _detached() above? You mean _detached()
> right? Just to be sure

Yup, I typed this all a bit too quick...

>
> > -> refcount_add_not_zero() returns true
>
> Ack.
>
> > [ process gets fatal signal ]
> >
> > -> rcuwait_wait_event() errors out
> > -> oopsies need to do something, maybe [VM_]WARN_ON() not right?
>
> AFAICS from vma_mark_detached() we use the TASK_UNINTERRUPTIBLE variant
> so this path can't error due to the fatal signal.

Right good point.

I hate that we make this so 'gosh darned' implicit.

We are now assuming that:

1. the only way that RCU wait can fail is due to pending fatal signal
2. and that we're fine here because it's uninterruptible.

I mean very doubtful we'll ever change that but it's still gross.

And as Willy says we're paving the road with good intent^Wlandmines.

>
> > Correct me if the above is wrong.

Yeah I was wrong thankfully :)

The TASK_UNINTERRUPTIBLE saves us, but it's all still a bit ugh.

> >
> > I mean is any of this actually possible...?
> >
> > Seems dubious. But I guess right now we assume it _is_ possible. What a mess!
> >
> > (Again I wonder why we made our lives so difficult here)
> >
> > Anyway even if we are midway through a detach, the detach is ostensibly waiting
> > for the readers to go away, and our reader is about to go away anyway, but the
> > process has a fatal signal so do we even care?
>
> Yeah I guess it's for the best to keep vma_mark_detached() use the
> TASK_UNINTERRUPTIBLE variant, maybe document why. Aborting the detaching
> would be counter productive.
>
> > I actually wonder if a WARN_ON() is warranted to see if this even ever
> > happens...
>
> Not for this path, but for vma_start_write_killable -> __vma_start_write
> -> __vma_enter_locked(... TASK_KILLABLE). I think it still can't

Well if it's impossible for TASK_UNINTERRUPTIBLE no harm in adding it right? Can
add a comment.

> trigger, but since we need to check result of the
> refcount_sub_and_test() anyway, we might as well WARN_ON it.

Probably it can't no.

>
> > OK just going to reattach... my head which just exploded from the above :P
> >
> > Cheers, Lorenzo
>
>

Thanks, Lorenzo

