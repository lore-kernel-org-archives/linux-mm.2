Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85F43CEACEF
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 11:41:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8E448E0027; Mon, 17 Nov 2025 06:41:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C66018E0003; Mon, 17 Nov 2025 06:41:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B06188E0027; Mon, 17 Nov 2025 06:41:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 98B688E0003
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 06:41:27 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 453CE12F6A1
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 11:41:27 +0000 (UTC)
X-FDA: 84119908614.09.7DD4283
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf09.hostedemail.com (Postfix) with ESMTP id 17C5F140008
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 11:41:23 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Ti7XCJj7;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=v8KNJ6r7;
	spf=pass (imf09.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763379684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mpGF3iaffGiMycS8cpr3eUFxoMA07tWDjUwpkMPdUGo=;
	b=7umbEwMd/OsT3l1Z7OHZdWzyOvk8EEVOnV1uDa0amv8G1sR7fnRRv2w6owaMjpwUAdBiKA
	ZT0nQhZ+PnTHEpwiTa9+IBW8iXfocI9unWE6IhDK/ELz//WdfLewjwo3WtztmKF9sqUN7Q
	7y7cW7f2EdL7noTuyo3NfzI8jeYxRBM=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Ti7XCJj7;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=v8KNJ6r7;
	spf=pass (imf09.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763379684; a=rsa-sha256;
	cv=pass;
	b=lUgdvj3B4goOGlEC/+ah7N2el63jDJE1hU/objl8V5urPNujT0RbIUdKBiMm/upQ6YJ6Jg
	XIvjT2eQu46hP1rLHq98iOagijIpn0Q3d/KoDngKq4T9nks8p68eN9fEnpRgVFRD7+QYL5
	4iY+hHQ09VjZ+9W7bf8KA63YCdjtpHA=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AHBNXnW012678;
	Mon, 17 Nov 2025 11:41:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=mpGF3iaffGiMycS8cp
	r3eUFxoMA07tWDjUwpkMPdUGo=; b=Ti7XCJj7lKpWtqC+q2VCUJ9jauPUAW/9ap
	XPlMZY01Qv3YD1vP1S2Sm0RRGgdZVBaKW5Wb5PmSocnkkxJJ3/lVjhJSVYHJgYI1
	5+IcFdTYpvDwKPaTPITwj9ZFUT0SRe5g+U7wy+yMzCOMGDvKm0mFQhGuzRyGVKbO
	CnkT0oJPEl46poUqksyupSh7L003P1gk+Bs41FQNcO/v6/rLnvZ3zc1coTL0mbVT
	s1eGdyNimR6KaHrVhQYLTFul9n8InicTn66ALDldBIrepoWt701dWcEdWX5f5o7q
	TY77nuV/ZXaGgny2QcnIG1bdHF+aPb+6RI7/hzEB1vjmcDHmM4Fw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aej8j2avc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Nov 2025 11:41:19 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AHBCcRs007884;
	Mon, 17 Nov 2025 11:41:18 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010001.outbound.protection.outlook.com [52.101.61.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4aefy7jvs0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Nov 2025 11:41:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=npk2IQY/PA5lcHcJbofMlXf59FhBDPjcIIqe5K+cXVawYltIGrFXAwmpEoWaQKRSB2sVbmUPG1Wyms4VVLvRi3FfFidYu1WwwDl9gOuLWzrDVS/SEDNno5dYCh5YgcCxIfYm5mOK+ATTpyYVnsiFWt+RMt9NHEiadbhzqKyNrHDX6Z8WrHSdB7kn5yVvMM7qckApNfYcNqQZUVU68UT4CgkmXFwJcobDSlVnr6ZJOy8QkNL0lPvPE1BB522Lb04kx0TW+1KSgBY4Vr4btn6F+7unfUaUvXwYeeikfj4e90JEYY1DxtCC/lhaJlh+vapIGSMlObRxZF9cbjA3e+AoxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mpGF3iaffGiMycS8cpr3eUFxoMA07tWDjUwpkMPdUGo=;
 b=LUNGifN75ptdn+1xrQpg3qCOlWSlsf1EZ5U7fzFa5p/lIVSaWiIq74BnueKns1a6F7KY64SLy+rc8Mi1zlYTCJsFn7oH6KlF5/YnwcZ1GDGd3ch7oki3v1PbxV1vUI2gocoUyXdBHIfb/h0a4VjnZSdu3w9Hr6M+ceFT2WIVHT9Y9ASa7HAbN1n2NDd6oUi86a3c26XoMcoUgchTWUhSQkSHvQMMav6yZ79jY5oRXqWkZPnw/faFnsALqwiSXRiKu62d1/vUWtorzLm67Nd0u7vs5+m0xNhYBOmP7VSuFyrrbuBWm/xqm3I3Jonpm54R1rLFd3p+Lc2eSohTsEPyEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mpGF3iaffGiMycS8cpr3eUFxoMA07tWDjUwpkMPdUGo=;
 b=v8KNJ6r7o0H2JJf2X70DLc4/DiJSPbQJUDqd7o4yYg63H/XPN9HWumpr/hiyERNw0Uj1ndbz2y6ASAwFuxaNky6KeeC4DT+/sLvof7TLxnrAepIAAW6u1lPEKHzKeJo+oBWdXECYqCj7fFWG5ivajBC9l2kpvpkGSyDuhj9lhwY=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CH0PR10MB5004.namprd10.prod.outlook.com (2603:10b6:610:de::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.21; Mon, 17 Nov
 2025 11:41:16 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9320.021; Mon, 17 Nov 2025
 11:41:16 +0000
Date: Mon, 17 Nov 2025 11:41:00 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] make VM_SOFTDIRTY a sticky VMA flag
Message-ID: <e33d341c-5939-4e0d-bb73-cf73a756bcd5@lucifer.local>
References: <cover.1763142412.git.lorenzo.stoakes@oracle.com>
 <20251114135303.878b52f6db3dea4596f4c11a@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251114135303.878b52f6db3dea4596f4c11a@linux-foundation.org>
X-ClientProxiedBy: LNXP265CA0038.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5c::26) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CH0PR10MB5004:EE_
X-MS-Office365-Filtering-Correlation-Id: 47c1b695-0287-4617-964e-08de25ce3779
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?kftF9l6xwFucZApTPD9hHW67KnqJLYo44yApRzGzMPNFeTALc2UepOE1xdR7?=
 =?us-ascii?Q?byV1xaiAfQvupFAqcfQz7rQ7eviNnP/KdYrETiwSlL3cb1mBME2AAO2KNq8R?=
 =?us-ascii?Q?0zkYPjgx6eONzpJIsA0RdXYS4jE/JsUJF6g11cvmNy0H3YqWWWGoMX248HeB?=
 =?us-ascii?Q?JzxFxe294G+5jJjHdj1+0p9tHiSTK6+V52y6D240swzk7KTWRxn6gfyMUnHO?=
 =?us-ascii?Q?fAJ2BGEvhqwZgEWbN0ijppiIKPM/m7GnyMMKdiTuBGB/DgW76jZ7imXvh8Jw?=
 =?us-ascii?Q?Bu8Hxi6TkItSBGAvauHhiVBRj+C7m8EEalSqbCHgvkLX0JJrjXnEqCheKbDy?=
 =?us-ascii?Q?AA2p1M77dFWnZ8wVRMAVRarfJS87BE+J0RTAYd3Kaffqn35HbodNmt/4f8qU?=
 =?us-ascii?Q?RyQUZuA/ERjdSlQ1Cyr2H8cgPWCUU46qk96HtQZd1iaJ2FKcuidjsv2E+81Z?=
 =?us-ascii?Q?0YFf6MJAG9GnqUHP9uL9A5f7YJ2xacELfBykZhV9gIyLv8sprmoMLHND2qjN?=
 =?us-ascii?Q?gU16e8ylzTuzyjhE7MmcJbyZqSbCE0KONDKsaX/3hDy76ye2zZ6ZdzmsXrED?=
 =?us-ascii?Q?38oPmfUhOxu9U9tWfCh2huC1UcoRIRr2Ng7YCQYgLeVDNyyW1t1t4XbtQyOA?=
 =?us-ascii?Q?I+M/d4XhgOVpTNZ+c0+0tGXKDHn4CSGyA6anMclNZCWIGJ9MOqAXJXebM3x5?=
 =?us-ascii?Q?zh24v0Fcu4iMVW7GameQwo2sk7EDbB0H6jAvWEzqbUpBIdOutMi0rm3tiYEO?=
 =?us-ascii?Q?k8tcO9241VALyE6jzwjDekLYzcYeEuh3yXMlrDuV1p0jstn/epEJvrik3bSM?=
 =?us-ascii?Q?vOaO0nmQMLClJ0YeeyZWVL5ldQuHX4YzJRxe9hDOO4cBwExTDx+KVKyipcMD?=
 =?us-ascii?Q?25n7AdcjzIsrOshhRPtkIyb1PmXhSDLCtRo57IMGFCAWvKDdrnER2XjyYxjm?=
 =?us-ascii?Q?PysoauoaAHZNbjnT6TV7eyLwrgTltjrlZbciAvwhfrFlYWVA35YTIv0JPX9d?=
 =?us-ascii?Q?ZQPMceUonMLyu87gFl4cEmQo84pawHrP8SLhsLPd78XhSYBCqKLauNWsHwUg?=
 =?us-ascii?Q?6BuxGmCiLxiRBcrZF4th6CDY8MSGTggnJZNmBX/THHJkTrDFDA3/8fc07CpK?=
 =?us-ascii?Q?2ZA5xfVEPAzM1//KG7HedyHauoaEyS/Pzb/u7Ke1iBK+uzTa+I0zKEwCdwWb?=
 =?us-ascii?Q?orIJSo66ENX79VnU9bo+/EStYfrpEg/ES1Bz6rMlGaQ2lAxMZr/tDIa0z8wl?=
 =?us-ascii?Q?WspKBzW4qdNZXmrF1gG34WLJOQRj2OICkPfp8Z3vSuQq/nJa0pgMe1yeTTcf?=
 =?us-ascii?Q?1h70GrTF6mN4nmBO2KTyaqybf2jaC0h2j5bOoGlhMqKWhN4VDE742BfqYjrS?=
 =?us-ascii?Q?z2mF4Ayo7/Qu+meUS+YepfflxwdzAKXl6AkzIbWsYlhK/iSkrurB9XEpGDOD?=
 =?us-ascii?Q?KqoV90H43SYrXYitZ2xMwjOHG2yGPMhG?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?L2604a/XEkJAO14bo+5VN4ubJWIZc7o143OfL+1PS6ZHupgkCqhRoZN7X4PO?=
 =?us-ascii?Q?H4olxNJOZC4Kve6j4BZkd9LNpP8J6BKmpUehwPV9zD+MbzLevmNBCv4VBkBr?=
 =?us-ascii?Q?xzQ/elYm8BgV+9RX1lY0IwAvv2uQYD9Qz/IcsH8q7m8o4IxFQezyA+aG5Eo9?=
 =?us-ascii?Q?P8+SLGk4mDGFhxKyRTBrWFeGZdOQZn5ob15M3/b6/TnV3C7ZsRNa2E2mmu/7?=
 =?us-ascii?Q?s7y1ePPeeZ837mmsA7109geFTZ82l8n6nx9z1r1RqoPuk/JbO/ppshdge/Z7?=
 =?us-ascii?Q?f5y2c/3hKEYD61Wwd/fc9QTjIXOl1zZzhsrN7Rc3QCmuov3kWke0W8jr323j?=
 =?us-ascii?Q?DagrnefHIJiHzbLxdXW3f38HerSUqvivgA/Knmw44VCakbKtXOlfvmPNY6CP?=
 =?us-ascii?Q?AQ0j0tpfWVG4IE3/0BeDdETSNCZXo2CO2EGdUWlLRLXem6AOld/hlYsBGdyL?=
 =?us-ascii?Q?5krmBdAND/zQBfcf3/vUx6PepDEjC2TYo4qFfkEnPQtGF3K+n2UNa5VcsgLO?=
 =?us-ascii?Q?DI/XHAH1BgxYMQLY+Mn6oLBz+An/z2h6a7rHCYP6/Y56bqQnjihIGuoW8MVR?=
 =?us-ascii?Q?F9uht/lbKSZgzzV54IlLlEncsSCnqfZjR0D7w+nXYjbVhyQg+R9KatezSlU6?=
 =?us-ascii?Q?Czt7plg000BVJ8KuosrjXOc89yjU+5GiqauR0KxtWy1lJXpO95fS0+o0ipmF?=
 =?us-ascii?Q?9uBdG8dljlde7IXvv33JAZGndwI+JUbIOXzDDk46zV2xps3lcVYi4C8130CK?=
 =?us-ascii?Q?b7KraR1cXyE9VSBhCBhHLYz2SMmAf3GFUpMwR5I226PIL+saITQK5ajLtCQu?=
 =?us-ascii?Q?LDdi5V0LxccuMM0pnbJwgqNcnt9SVAcIBp8T9c/meX/eGA3HG/dzZLopuZwC?=
 =?us-ascii?Q?SSrDpKeZDWr+1CTpDQUOqibMN7AYV5jHJ/akiXkBCmb8aN3z9e7QtAXkayS4?=
 =?us-ascii?Q?9zwcUYFlI+OFC6JtieErnyaEuo80zo1RBHG7tQQD+WzHWUfVlUlpUsneWXcw?=
 =?us-ascii?Q?aHEA1xPFGgHqDTkXI5nEzA0+jOEj0ccIttYexBbiXhUKYR8KLZzHc2WJrsf9?=
 =?us-ascii?Q?kXMwcfax4XZwPT+pQwF83LH9U+VJM/AedBKXzOvFeYVbqU5niEJB+V0eNV31?=
 =?us-ascii?Q?r4BmFos7iHAukEO/fShe/mqWFQY5JOlewvUZZBA5EKwfHudzaIi/KufWKfGJ?=
 =?us-ascii?Q?DSyMi7UbTWZzNA7eLW8iGYPjcxwgkBPiskEd88sieqtP6wIxffd9zorE0yJC?=
 =?us-ascii?Q?Za5YPXAu3bTJmB+AlcMt915lsjbWjbv7m3irYWLOmEinc+tGHqWDLXtaakjv?=
 =?us-ascii?Q?8COAls3TgloVDzyywb2G12ick9lWChCGpnf8+fLpVqfHKRBiHhNdcWm6aFRq?=
 =?us-ascii?Q?8KmRuzpXiwc2qGNfgS1ukQ1aOrZ9A20K81t33dt5U7JwhxN3WmWmBZRX8JPL?=
 =?us-ascii?Q?nOFhmruAX3jyASuLvBIPzg3koZ9dGlSjFzNlG7QuNcxJDYMZ4MhhBR/Oh6Kx?=
 =?us-ascii?Q?KCpr4by+2AjiU8/zxqc0ZSGaNAjPXOZjlxfoetN5jf7qkYteLT8nKsk9O8Ja?=
 =?us-ascii?Q?AcVRFoo2kcM6Dl/G0dr7af2ViZ9xoGIqiKHosEfrl99g9qi0rP6RJkPsPqj7?=
 =?us-ascii?Q?Tw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	QHtSAtSkS03vOZ7OCVbvq4Rk+OM+CgG2x2zyhpBRrSRJcfCzQjCJqoBHabURGjNgX5iak8fdWgxU5CnDlAPZ07q4aUjCmBQdOMakyI4LQGNVq+SBHOx4mMAB+uCg2771RegDXPFfYrKcoyytfg0IIOL6zC0wOLb2JkFEprrxmksREPFt2/CjTroRU5swk448bToivjH2MCAZ7r2gNMX/4z8XqnOB44RscOq/UYBsafu764Y0gbP3YN+5fKDNjrbY842m7RxAGoQS/6eU6AUzwsqHF62DTWUBKMO2lVs3Ic0+m3Vl3/4uCIkM1GR4+cUAEeh1XpJUmiX/8TCFRyRovJRlYFzbWKz2rtX9jG3zFDMf6u86CaPcg0yzvIX3c1NnBFVvQ5KPvysFSH7RW9y8NdVAbgdey4scf1K2x6FHdc8q5V3LRF4DsPOdNnTAZptEdUwJqd6QHcbYehFuHHd7iitoQV6x3RpkoWG/ZSlNX2E8kc/dbG+y6hS7NYYoY1rtTc/59iZN3Jt3ZtARmiyClDm1CWVGd3QQO/MYN1wZFetylmjve7d0P/Q4KvmfTvzneaBjJ99jFcQx2gWL88zq866UUvIDCKqXQkDOwHxeAKs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47c1b695-0287-4617-964e-08de25ce3779
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2025 11:41:16.0642
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 61/20CVEnDyRED3NYv/upM8TlQMjBUHN6pvQUHaGFtnB3AhgbkK8bP8dHRjfOl72rZfqSvq6ZXKUVP04rfWdDUg42EcSiJGGyZvz9pL7fbw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5004
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-17_02,2025-11-13_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 mlxscore=0 malwarescore=0 adultscore=0 mlxlogscore=676 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511170098
X-Proofpoint-ORIG-GUID: owjQjrzFdHrrVt7YSMlmZ3JROh88YOYw
X-Proofpoint-GUID: owjQjrzFdHrrVt7YSMlmZ3JROh88YOYw
X-Authority-Analysis: v=2.4 cv=I7xohdgg c=1 sm=1 tr=0 ts=691b09df cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=IjnFJQVy4V2Tn0M8FFYA:9 a=CjuIK1q_8ugA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMSBTYWx0ZWRfX0StGZjtfgzVD
 pAzUYhpv765AgiVR0XknBGY6CEoKzbNQ3HJGAxami7eremmuc6UHe6363ftwGpr0OTceJJsNBVx
 gWtklWtYwBVOvbQj2wqRwPZQuyqo5PRi6dv0zT2/s6RZqt/pvu0K//6yJtsMj53WGhvhpOM+bfN
 z5VEVCA3lNo5XSXn47sPIbB/hMeGcMejZu3rQJC5YzuMZAN7iVPDKn8cNXBa4OwJuy8p06hga/M
 jEvSGDOgh6s39O3oyxwDJwTW2eUqLdZp4yxvkISiyMgnIdJ3dIoG1oBb+iToG0TSamMU1djRDin
 oNu44LXH42vXWpgX+cRmE5TSmRzD3c1VByX0HEnFAnawZ8tECRvhi+DjoeVj+HzHnWCEnNQXZ3E
 5YwtpcHfr0pOc4xJDgLzxGCk3K+c7g==
X-Rspamd-Queue-Id: 17C5F140008
X-Stat-Signature: nof5dxnan86pa5xnzbp3ngumzstwyiaa
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763379683-92065
X-HE-Meta: U2FsdGVkX19gzUgzClG6gvlW9jqpJrT1o4XLw3L1gTLtpkxiLj9iZkk16WwEmYtsXgOaSCUFSf3Gio29TZw+CJy0Vd99UH1EAMmWdVSbkoVRdIkU6Wsb3faxhwvpvv6ctxu4SWcg3VXpNe9CooVoaHA6jLBktWq3egTS74EpgzUBFgJdQSBKhNzR5xzcBvOPUkCn+2D//wvaL3nzkIOUM43lXgveiEi613YChlZh+TnSm3YK86OfWbJSTkc65ozlr5worpEFb7cJDMbxwlkyLFfQ/6VWLaZOqyTQh1CAnVtNMSbavVFLijKerxxrefU6Z7phFw8qMnT8m8kVOBptFAl30xOJT5f/j0KfnZV4by3gyMYvXNiLwTsyHeN2m9aqmVeIuwYnOmQYYsFN4tU2KjLHJ5b9GiLyNMFnIxceHL7lNBCS4MkEQR6VVx4eQIpnhz7Z77S4MlGFb/goxyZzkSNJKHrRXqLD0RwknLKGl3nxoey2+SzMItCd/oxkKS1dxnrgn7CF6AbSI1x5DVvhi4MPAVhS3Z7wPkdvqt98XEUibk8cqvV1Y70WEjlm1sMMF6L2EBJDy5uJxSi9kIWJJQIxmobpRw2RMnU/E+XtRmRqh/zDbagB0pMU8boMvHPfw20dEOdz0Y9WzxgLXE6exupPPOnFTQ/L0ArZVvGZiO5jvckQ3JWzWk3DrXmoxSuiroRQ0ZVHeEcf8n8Dy8jLBXPq8EgjUz+javGSwDWqhZgBx3p6+rvzTKm/wygs95VwglkAlJUkbPDPm+n0V+NaktfnNb9MAS51J++C6mlWVxDinyjB9fKhyIN3JbNrukiKr7B10MjdQ+aumiDulejc2vr2chh4MQnBzmaARxph75N7NpI7KvkJB2K+7ChK9i/b+hcUtBzlZTn5gwn9M3TgS/NkufxGLY3bpEjYRKfVzeqUjK/SO8HEQZtwOzNRwa1VfYKm409uIeqvfYYuy/j
 u0QjHy8r
 MHgCeqOtmP76jQQixSk2jaxipE4qgu7NOKbxXeMy8NlI3FYUaQm48eh+r6COjr5Ejfhn9sr1udcxDTiXXAb4rJ8meTg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 14, 2025 at 01:53:03PM -0800, Andrew Morton wrote:
> On Fri, 14 Nov 2025 17:53:17 +0000 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:
>
> > Currently we set VM_SOFTDIRTY when a new mapping is set up (whether by
> > establishing a new VMA, or via merge) as implemented in __mmap_complete()
> > and do_brk_flags().
> >
> > However, when performing a merge of existing mappings such as when
> > performing mprotect(), we may lose the VM_SOFTDIRTY flag.
> >
>
> userspace-visible effects?

Simply more correct accounting of soft-dirty :)

>
> Documentation/admin-guide/mm/soft-dirty.rst tells me that this can
> already happen in other circumstances so I guess it isn't very serious.
> CRIU inefficiency.  perhaps?

I don't think it should cause inefficiency other than us already _accidentally_
being more efficient, see the discussion in thread :)

>
> Please review Documentation/admin-guide/mm/soft-dirty.rst, check that
> it is complete and accurate?

It LGTM, we are changing some very specific internal implementation detail here
which I don't think is worth mentioning here (effectively - 'we used to be wrong
sometimes, now not so much' :)

(Staring at tihs I realise I _probably_ need to change something very specific
in the original sticky implementation. The VMA implementation is so
finnicky... will send follow up fixpatch/respin on that w/details)

Cheers, Lorenzo

