Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A8EBD65559
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 12:27:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DABDD6B0096; Wed, 17 Dec 2025 07:27:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7F306B0098; Wed, 17 Dec 2025 07:27:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1BE06B0099; Wed, 17 Dec 2025 07:27:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8F0086B0096
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:27:45 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4C79B1608AF
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 12:27:45 +0000 (UTC)
X-FDA: 84228889290.04.676F9CE
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf12.hostedemail.com (Postfix) with ESMTP id C604540014
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 12:27:41 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=lFU6YApG;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Dwqgnekt;
	spf=pass (imf12.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765974462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xi3B2de2d++3HecIT0WKfvdrNO+Q7eWcJW4Ra+AG6DM=;
	b=iIhO9WHy09wym/U18/+Yoas81WX+3MGSmDoTLDB6NEd60g7lEMEO9i72lcfZLSv3w0ApJh
	+/wIiz2afd+ZkaRGcNEPs6J7iPioVsLdq/NLkTR8NY+wKfMKpyNrZh2rU2VszinAAIG8fr
	2OcHh9A4b+LEQ1pWc5li+OfKaqdB7xA=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=lFU6YApG;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Dwqgnekt;
	spf=pass (imf12.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765974462; a=rsa-sha256;
	cv=pass;
	b=HoW/xY79ud01kfWN1HSZOA7mXTWYb/ALdoJO8FWWB5Ofg+DvfxGaueiG7Q5rkAeM98oyaV
	quzGg/61jEBlo5GY7bBSFuFVHVce8+E11HSAskDnS7HTk1aKdDwpAnvPJLBqy/F7BJUE2g
	Ws/8WQ5w9no8Cl15PZ4UkbFDmNl07NQ=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BH6Ncb42068664;
	Wed, 17 Dec 2025 12:27:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=xi3B2de2d++3HecIT0WKfvdrNO+Q7eWcJW4Ra+AG6DM=; b=
	lFU6YApG/7DkgGrL8zVyYtX4R7BeC9K37SRkzvUYJLG4UMmK+eDW+xHRceGwBgzy
	9wYYyhzqEoqJCSVX4XV5pMP1WIlpl4hBi2MrOJ2bixtLBKY1TI7/8uunx5cad6jM
	kNvVxsZZOcGD6Mwf2zO4dqzLOQs0nxqexUIICYGFwEx8J5+KmyEmvLf+hx8lvE6q
	RP9liEX9bA/zHyNZPQKK050JgFUAfuSD4BUjDxfmzMww8rDPLDx8gHWcEcreBFJk
	QC4P9iTzXD34SmBOeWHHyeDQ6lmVuk014x9cvfkjSh1EMBXLcJpBma1ac2/rIExj
	IWNPUWqKDzk6R0n+NWs7Bw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b10prnquc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Dec 2025 12:27:36 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BHB7E9g024495;
	Wed, 17 Dec 2025 12:27:35 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010055.outbound.protection.outlook.com [52.101.61.55])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4b0xkbq6m0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Dec 2025 12:27:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hOlHDYbXUIMV0Y5XGLBE9ldXRJ5PbFWhpC2pKmGtOg+fRSj2KvuxfCtHmaQJj0Ne0RDPe8BI9tKwjGx2aleYnZI4BqUzAMOUEYQBoDf9imliXH7VJ+vi94r/FJ+jjr0jhTOOihaA6s6OJ+wVgZE8phgg3dhSeLvp46khpd0V8cA0Z0aFHCOXwmIrbdqgAudyfvsmOmQrzo4lUirbKlXHwZ7iRwjKUot82GP2KHf6Y6IXe5VFfkya7qq5KbQtHK21SWXHeV+cl7sTl/d6dTkoJVDJlv2ahc7waey9rSUI9JzQ2E5a41p6GixZU1gM3PlQAtZLcb0SRzlIAXgY7oLETg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xi3B2de2d++3HecIT0WKfvdrNO+Q7eWcJW4Ra+AG6DM=;
 b=U/R7NIFzaXiACYC+JY7tFmMLTkXfQUghpOtX066zhJ8OMCZAfYFUi+/1B5icdCAmjb9QZSYWhJutyArseu4A7B27vVN08zsenuZFoJAvguRszbtz/xTNemmDLfDdhog3M+qmkELDe59zFngy45srORLTZRTdOx72RDTnlzgyoVKZtQpnvs1b+RiEzksuLgMzcHqKJidXi23hgup/+NP5904hyhhzu9HaiftdaPERV7ab8BONW633Yd4I35bICyegPHfnKiVKbxBr0mmY06i6EPPzZEuE0IWA35sJ+0XfphfL3mfm0ShY3s57uDhpuPXNvoB/5jZT3feyFHPHfedIoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xi3B2de2d++3HecIT0WKfvdrNO+Q7eWcJW4Ra+AG6DM=;
 b=DwqgnektXpW1djw7Fztk9CN6BiSznTQQ2GHPEiaNH9DyEVFwVK1GwKVyNsp8nZwjpE+9N4VKLKdz5SFzZ+Bd3h1OMImtGbn0kJhRGxr6guUnZPgcHK/ZRsjexO4AWFhVBSfpbmHbzEtDaWD2QD6F0tbx0iAQV8Y1Ngig7wPaNBc=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DM4PR10MB6253.namprd10.prod.outlook.com (2603:10b6:8:b7::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Wed, 17 Dec
 2025 12:27:32 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%4]) with mapi id 15.20.9434.001; Wed, 17 Dec 2025
 12:27:32 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>,
        Harry Yoo <harry.yoo@oracle.com>, Jann Horn <jannh@google.com>,
        Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
        Pedro Falcato <pfalcato@suse.de>, Chris Li <chriscli@google.com>,
        Barry Song <v-songbaohua@oppo.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 7/8] mm/rmap: allocate anon_vma_chain objects unlocked when possible
Date: Wed, 17 Dec 2025 12:27:09 +0000
Message-ID: <4ce4ec09b92664091e8935982d83dde3a4c7f898.1765970117.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1765970117.git.lorenzo.stoakes@oracle.com>
References: <cover.1765970117.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0562.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:33b::12) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DM4PR10MB6253:EE_
X-MS-Office365-Filtering-Correlation-Id: 17201a52-3b7c-4007-ddbe-08de3d67a70c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?23Jbh7Z+cY8Zfx4WXFv8pXAJxBj1C/VSNe6EiV5ENoi0qA2YfJq0MsWZ/21V?=
 =?us-ascii?Q?8T+s5KQgYdfGbdBjIT0OvQ6/N+Q3ZV5lRS6vlNr6B5t8xRuA+x1mwbIRsnx8?=
 =?us-ascii?Q?jU+TvLbJzGAdQOxSG1+0OpwuQKobHSVYI53m3xDenoShX0ZSUlU2FRGWoz9F?=
 =?us-ascii?Q?mzg4Dt388k/IEdqLHqKmKa13ULKWVFhVsnuQdCbTTXMG0fmHu6CWePNs7GC7?=
 =?us-ascii?Q?5tPtuNuEbKcbWAMFyYXR+ZvTZ+KmckgomXJjfmq+N13cOy3s9A8lLCGRGlCx?=
 =?us-ascii?Q?Qr0fBRNfoZulqa+rsmFTB01H+d4oJQlP6phFr4o0MQjwwgOM9xpoyxpi5Q+S?=
 =?us-ascii?Q?o0nTOEKX6I1PkGOlmdBj5/StguyVBRT3OpU72RMcqgNon8K2QfTpygiq3aRl?=
 =?us-ascii?Q?Ax6iAjGyaj2wrpV6TY+TB/52kH25EYKfrXneWpdmLh3X6vKiPPT2S38cstQS?=
 =?us-ascii?Q?hijqfU/CW9Nqj+tfYgrpquXK7CjrMmx6Z1Uv7UVAE+9IjG8RXdXRURIL6Yeo?=
 =?us-ascii?Q?8vROx+ewDw562eruSnB0vNhMmYCFmlDCP5/y/WPau8Pf83fhFOnGcb6Fz59X?=
 =?us-ascii?Q?h0R+MG4J3OHEYw0Tv1mOHcz0bimCB3qjEcfqUyG1tpf2lb9PCKri2DYDDAbO?=
 =?us-ascii?Q?2zRlTtGinWWxbSYr12adKbD84U7xw8Fjsx6GBbxNlfr4apGu6Uyco2q8+H6O?=
 =?us-ascii?Q?/S6vsvPNL80/OoNNy45+HiqBOnef8FoKbDBbXFxETS9Iu6B+2qr1pLflMOzT?=
 =?us-ascii?Q?MbRbUEZlo0lLedzbZyxJZvjkY0oGM/MPvRXhHJKPUZf7uEzJuUM9Nv8RAE7B?=
 =?us-ascii?Q?mSg+GlkLdjmvPcc6BlTHAHF9YxXSad1oUt8RIHI7zIBmU77mAvQJZ8/VUkfQ?=
 =?us-ascii?Q?dqUMWzxvP8KYyIB0SuFlyGj3My5u9cM7p+aj3e/xqntb98GfePwxvY5mFmBk?=
 =?us-ascii?Q?9WINEeP+JyME/srgvnW32nBXPI0Jjv7Dvr6Ycl0BDXdOsNx5CeioRLwAkgiU?=
 =?us-ascii?Q?bY+Ck8KJjlY9QqgxxO9kqOermV5HHtoR9p9wCH5u9DTY1hSE79g6i7TNZhfw?=
 =?us-ascii?Q?gH/pJj1CuUwiyJcrlMjXv32pkXB9OGWBIG5QIC4crMAY8n48FggyyRAAjOhx?=
 =?us-ascii?Q?Ul5aLCKP9OLc+wBPbPCqVh5kKTYifz+qRDWLGRRxDz81ctVBvknsjDe+4Myc?=
 =?us-ascii?Q?7KrGRWTyiPSBtJOR9SRtQcrUD35P47rOE0mopZx/94xbUzSgqqAu7ZJnKFkM?=
 =?us-ascii?Q?g1JmjhcfNmI+ZOievun4z8NBFTZaq9/ospZHf7PDMmL0S0N9tKYWmaDxCywT?=
 =?us-ascii?Q?SHYQ2HyQ104GIbqUDwyqBWveSoAZ+vpp5piY2Uj78HEOXg3h9bhJKYz/CAnc?=
 =?us-ascii?Q?rkp0HI5EP8QAHsTVkZM5drccZKYdfUr229fuepw1IHd1u69zZVhhBPM19qJ2?=
 =?us-ascii?Q?NkVeYXtJFTvTq3OeinV3BhpOkrcxja3E?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yB0ie1g1CmzjYVLVSyTfhS7zFWiSIKYJbkgAClXP2w8Eguk14bvGlVzFotkk?=
 =?us-ascii?Q?i3T+la/w2yOwlgYcWrB47U3NWwU0jk/z3AK5zuemFe2AOFIiMTWTNPqqocMs?=
 =?us-ascii?Q?06DeRpKvPxGbetX/PSkX8Yw9qbe1dJXC25TlhnTU6bcHPtunhQhuJCW5p7EK?=
 =?us-ascii?Q?JYAMwhfK90TkSSPV11a2uWxb1CvZ/Nud2zuBmFu/Yaswz4O8H9KkzejsWF2t?=
 =?us-ascii?Q?4UHft4oyVcQca01YiuwW9ZYJNlA7qQVVTT4UJxesVqOiIRPySofk/VWZ7IVA?=
 =?us-ascii?Q?HwOZl9w7a9TUNSf5VoS9ZLSjKjC8VWvEAmHwZIqA5ONZUU1XxGXZyrR+x3G0?=
 =?us-ascii?Q?YCRhuc/fUDcUGAk1mvIMf66I1eazCC0s6r0fyWAIK2F5gURDDNWQe54YKtai?=
 =?us-ascii?Q?EeHg2+f2mgjES9jwqpmQ1PdaL1VJCQdRcHwBbCqo4UCg3zSRi39JIhN78043?=
 =?us-ascii?Q?oOes6FrqzDg6L3dYNV8NUJHgXoe9BAvtjGly2kOJ6SwVm7c51LFZ58z+Q4s9?=
 =?us-ascii?Q?0pHKLW7CCyE6bIGtZ8EKpzJP18jyKt6MqQVdV5Tfz+Eseu2CcQFUnom+FvZs?=
 =?us-ascii?Q?mtbvehMr0B60Y/bE8sxeY1S+pG6JA2BR4gfHAasLVqzYeZXQFTa3JQBrumQA?=
 =?us-ascii?Q?7rt4ZftXx0Bm7TzAEvkBSJjMlzrQ7KeZ1WxIsYfkhJJ/AWL+3oF8vDzP21XN?=
 =?us-ascii?Q?gF8VAjQ6kfpXGq/pRxzlKly7pfbMhzUmBUbnHQQAOQ6RZ/c1j5foc2j74l4c?=
 =?us-ascii?Q?F6UX90bBI+RLtAvMRNr5Z1GeYAOZJu4Lpnr13F+IpuUSGAiAi6Yp3/vOyvTd?=
 =?us-ascii?Q?85mAhZjPzhZFziQuCT0MAtc1wM+o7GEYNS/Pl5gv8gClandE6ZSPpzuIVJ6g?=
 =?us-ascii?Q?N+7cHCam0z20UJAOOppXEhFJ6loWUt4dfGLT8SmDhfhphwnRyNveKdyC/uRJ?=
 =?us-ascii?Q?zj0117IbhAkoY5NouBFsU21M6SeM5hbMg6Ymcb8A1HTj9EdsiAO7t+bFlvZQ?=
 =?us-ascii?Q?W+xG665A8FYu3fhX5pmMmgZ+UIg2wCM53GQK5cj4kWT6sTAKsoSSakPto+lQ?=
 =?us-ascii?Q?NQMxRd6yHzwW6vpTIZoFG/tBT5Ii3RIUJITZg27ZD3sc1oie9oGd33lQxVqi?=
 =?us-ascii?Q?u48H1BgcAU/GAZ4ILIt4gZcVmrnCngm5wpXYT2ji13dd4N7pbrftahqq1Zdu?=
 =?us-ascii?Q?N3WldxiGBAulctJRcnDtVXOFlcgIatbieLMQj14d+z+BbTJpokwpuu2gfGFT?=
 =?us-ascii?Q?UmxQ61m8376cmrRS4DMMB9FSCcHQAdsQvZB9GV8MOsAqz2wNBORBDFsGdOyj?=
 =?us-ascii?Q?IVCl0jdSVSYmsOs2DUIpbRyb6bPHkxk3gllzCu6Dr9r2sGlmO7+sj6Byvh/H?=
 =?us-ascii?Q?B4bFv00mI/T5YoSD+zyQaYosh9mHlE5USZM5+Je/F+nkVHWpaimDxf4Al53B?=
 =?us-ascii?Q?aE51PWGDTK+9KXcyOFZ7VfcTzHfcpci+4jhGWelnn519AEG4933kJxkdDIPS?=
 =?us-ascii?Q?ixDp0ZNJ7jqyA/uacmrF5k6A/1l2xcFqZMmHGvcY7Y9TdHYuoVUmtF0xvMif?=
 =?us-ascii?Q?jhWX4/MFYdPr21IR3VysAdpVntXuPC/kuNp4lLFH2f7rgSPd/w2ORmq4WTy5?=
 =?us-ascii?Q?Gg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	6eXvyiX9MFianTz7FPCyuUajyKyDu/23K3Lg9I5MMpZxQIW2KjPjcQNnk/JSjkr/pLkZXVl8DOJbhlcDX4qIdD2uYWtSI4UAUbkf7X7umqWwkhtkh+XEtxs+tRfz4yx8LZfadUw0bu0oLwbK+xjuSrT7Er7HKnfhapJUEF29YIofYzitlwBGV/D0dOJe5qFxJINvG/aURncMV0NhlwTdX0k+IhQmb4/DS6tjgI6od1A0//CRecmxXEm+KdcriSEGvSyehQz8X26oGuPqbNrISopfepSKYq3TX6FCqRQaH3hbUDUkOBjYkj7BziOXYLWxlr0j2m7xck0PlOQO0txmGomCS6GxPsJnKL+gndaM7thAmSzpGBVj5Vm03V2IUIAQFw1bk7Cofo8dwUT5YE+HWrX/VWNmJrJiEPYWgI6klCvPDiY8Cenj371B0ZvocTJYm0wwXz8u7YxLPFTejPFenv2D+w9qFCE5MsR4YMnpfcfYYyf0nAuUlkiCf5GtFqnes7JIIaub4qraZDKCAaxm+yt6caqFF32iJT8KnIWJdDhInqveC/Cm0BWRLW9P02g+2Rvr4L17/mV3Q6ZsY/imOa1ShPliWyllIc3r9fkmNMI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17201a52-3b7c-4007-ddbe-08de3d67a70c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2025 12:27:32.8026
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6HX1BM8H/tOhk4lmCT17GZ6ppV5K83BzpobJZLw4s4KYVaD6EGrd9Y4fmHanovStYFs8WII4mR/ljp6df/E20KJSfhORdx+AG+qTKcBEazw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6253
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-17_01,2025-12-16_05,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 bulkscore=0
 suspectscore=0 phishscore=0 adultscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512170096
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE3MDA5NyBTYWx0ZWRfX2JLHzXlFD682
 XAzhx3JXrl/JVgCZ6NWUkDfKei/lZEqhIINZWLT16weG4/IYfngo9zz6QIoKxCtWxRsqtdNsZIF
 wuIAhBZ5BkKU93Kwv6tQxlR7scdhmVy2NzygnueU5qzKXuGrYMvuvIrfQtHIhjhTjSl5RTQxlfQ
 QoupfJkHneEtVfyqAqdrfT6opsrMb604lkC4dUBe2kLV/ajdr//XB4TY/jdmZjIalAyHHNNH0ib
 P1Y7rw8eUxmyFVsshr74u+lSKyi1HJYE7u13D6qMwfZSYPcAD8P/2hPlmvinE+6j1OI54poqjg+
 2Qc06kgwVt22RrDOJwSShbgYv6xvNaGhXhd9+Bk05uiMLSRFPcIIpWYzB2ttAvJYDNqp4Q0IZMT
 Q5DEF416CQJ6B0xK55U278q/0Md9Fg==
X-Proofpoint-GUID: ga9Oz49VbQF-wr0u9UfBj5rW4BN3Ae7g
X-Proofpoint-ORIG-GUID: ga9Oz49VbQF-wr0u9UfBj5rW4BN3Ae7g
X-Authority-Analysis: v=2.4 cv=dParWeZb c=1 sm=1 tr=0 ts=6942a1b8 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=wP3pNCr1ah4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=kN6XwLchXLQ3Vj0rqgIA:9
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C604540014
X-Stat-Signature: y47o67ryfkgesuekmn8rk9yqeyerqjis
X-HE-Tag: 1765974461-260739
X-HE-Meta: U2FsdGVkX190HSOSCNjpFLsnzfdJ7ish203og/oq4tKvtJIpLKVcKVwJUdn2BZPqwm/Oou+xAPAL8jEQhC9GYOg/h1zcqdy+Sz11W0C+jL/jLGiARdXo9mJ7Xb4bmqJwKYDV0DAVi93slTWb/JwPrOQUXb8eVh4KCFaS7jMUiGteDDU0bbP5In4RNhdrEAiiUkSO5m0zOySoqtkfTG0l7cyiduR9+WGgF/Yy0dDBDxqT+Id8YDbH3bIGARK9v+FGdvKoRE1ia7+t3fq4JhFfAFF9zQyNQlpRVklP43WyCTrqr1QumiBXLrBl8SWY9nbMdoNBnshyINejlxpvedu3oITpJGGGY4dP+gTokfu3jAm0m5kOUiLH+KTHrKzQq6IK/6yzqrjFoPLYwGXGCTbch6oZAIZCmFmzF9UWo3TE1JaXT2GtmA+bTW0W7G164QzZ8l8EQgxtgg6rI4eLa5LTy7WhBKsOlfwYw4qMIQ4rKL8BZVgc0D2/4z1q+GZuXkppQJEoUAkTJ3xxA8lOFy0cjNmKxoL8T+fm/A41Ax5tYKbmUvOA21em2WGicIqzFuUPbQsWdiuthefFas3Umpb3nfcepHCRgEhqsbm5dmfSMYT2UslNOs6rGdgO19xHLb4WACnnyRlNf3GZZtQNyHs+knH/YIOq0t/7WEswbC3dWGJyDUasdSqL4uH4TPMDWCqLAInVee7/esYs5h2xho0Iip3GFeLFF9HrgShO+BeUUFiruxhvlPxdRWkEuRDXIKCKT/DhI24Ac6p0MU7q0MT+BR/Pxk9/MkKu0BJhOZi/bU+W8NoRttdAJ0hc9ENzvvOltFOiF43SGVDBhZLD5DwsBaAPtUYeZzzv9ZB460udDRzqM8hRpqHkXC2fU9FYjOsA96z7NHeWu5WduxrQTchL5ifo5kTcTn6j9YfOSSn0AnCEKejrbGrV5uuxrky4abkTIRNkDGRH8bxapZjgQkC
 OXBBww/6
 EO6B5xW1zVRVRPncbUCguEugr6CWcULo+AVZ3av2UGDJZ3w1SVjTpJvNb3BPJ8vDcN+iy32ARnZa8UU7biUi97WO0+V66PMLZ8M9wbPqw7DylW8bhRWEZaKptbslaBn7ejiz/6xPUA8d+MS5P0oIi9H+YRYtSz0QsLLpOV4L09+FAL/wOZ7qJuP3f8xdGToMGYDXZqheISto177VyYl3nmm2dXdMtLjt8jqwwGzANIcloDWHwsxqJyGJBa51ye0Iya3VUfdPIE6hodays+LKql9QAftAcHsdYQEWl+FZ+duztVIFIEnyF5eVVdS/6fAvMO3BVxtVCXRJ8x9INhSYDCbIuJBIvyeJaLdnHLyWm+98tp/pTMy6GfeOL+6HUHKLrvqNRDjB44T1MjpmVdCg1JPDx6k6YGihUsmr15VDzqDqjRbAIf25M8NoRHKA+Nk4OXeT3olZ363/NNfK571nyostghWe0A1ET6bcXxujsPqMlIIqxwwc7lTZZi8f1FfpM2N478Zf5/1GhrRzNM+i7i5iiifj94R+sadKbaoFxVfgFvFlJjKf1HlpAhk2W795gLLoIY8axYH/JW22UAhnQu33VrR7aJVyfWLG/OrZ85jXZi5IlqfC9mPVsE+R0bx0TRsoF08TZ3AXg0+X4dUdwsxlZDg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There is no reason to allocate the anon_vma_chain under the anon_vma write
lock when cloning - we can in fact assign these to the destination VMA
safely as we hold the exclusive mmap lock and therefore preclude anybody
else accessing these fields.

We only need take the anon_vma write lock when we link rbtree edges from
the anon_vma to the newly established AVCs.

This also allows us to eliminate the weird GFP_NOWAIT, GFP_KERNEL dance
introduced in commit dd34739c03f2 ("mm: avoid anon_vma_chain allocation
under anon_vma lock"), further simplifying this logic.

This should reduce lock anon_vma contention, and clarifies exactly where
the anon_vma lock is required.

We cannot adjust __anon_vma_prepare() in the same way as this is only
protected by VMA read lock, so we have to perform the allocation here under
the anon_vma write lock and page_table_lock (to protect against racing
threads), and we wish to retain the lock ordering.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 mm/rmap.c | 49 +++++++++++++++++++++++++++++--------------------
 1 file changed, 29 insertions(+), 20 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 60134a566073..de9de6d71c23 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -146,14 +146,13 @@ static void anon_vma_chain_free(struct anon_vma_chain *anon_vma_chain)
 	kmem_cache_free(anon_vma_chain_cachep, anon_vma_chain);
 }
 
-static void anon_vma_chain_link(struct vm_area_struct *vma,
-				struct anon_vma_chain *avc,
-				struct anon_vma *anon_vma)
+static void anon_vma_chain_assign(struct vm_area_struct *vma,
+				  struct anon_vma_chain *avc,
+				  struct anon_vma *anon_vma)
 {
 	avc->vma = vma;
 	avc->anon_vma = anon_vma;
 	list_add(&avc->same_vma, &vma->anon_vma_chain);
-	anon_vma_interval_tree_insert(avc, &anon_vma->rb_root);
 }
 
 /**
@@ -210,7 +209,8 @@ int __anon_vma_prepare(struct vm_area_struct *vma)
 	spin_lock(&mm->page_table_lock);
 	if (likely(!vma->anon_vma)) {
 		vma->anon_vma = anon_vma;
-		anon_vma_chain_link(vma, avc, anon_vma);
+		anon_vma_chain_assign(vma, avc, anon_vma);
+		anon_vma_interval_tree_insert(avc, &anon_vma->rb_root);
 		anon_vma->num_active_vmas++;
 		allocated = NULL;
 		avc = NULL;
@@ -287,20 +287,28 @@ int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
 
 	check_anon_vma_clone(dst, src);
 
+	/*
+	 * Allocate AVCs. We don't need an anon_vma lock for this as we
+	 * are not updating the anon_vma rbtree nor are we changing
+	 * anon_vma statistics.
+	 *
+	 * We hold the mmap write lock so there's no possibliity of
+	 * the unlinked AVC's being observed yet.
+	 */
+	list_for_each_entry(pavc, &src->anon_vma_chain, same_vma) {
+		avc = anon_vma_chain_alloc(GFP_KERNEL);
+		if (!avc)
+			goto enomem_failure;
+
+		anon_vma_chain_assign(dst, avc, pavc->anon_vma);
+	}
+
+	/* Now link the anon_vma's back to the newly inserted AVCs. */
 	anon_vma_lock_write(src->anon_vma);
-	list_for_each_entry_reverse(pavc, &src->anon_vma_chain, same_vma) {
-		struct anon_vma *anon_vma;
-
-		avc = anon_vma_chain_alloc(GFP_NOWAIT);
-		if (unlikely(!avc)) {
-			anon_vma_unlock_write(src->anon_vma);
-			avc = anon_vma_chain_alloc(GFP_KERNEL);
-			if (!avc)
-				goto enomem_failure;
-			anon_vma_lock_write(src->anon_vma);
-		}
-		anon_vma = pavc->anon_vma;
-		anon_vma_chain_link(dst, avc, anon_vma);
+	list_for_each_entry_reverse(avc, &dst->anon_vma_chain, same_vma) {
+		struct anon_vma *anon_vma = avc->anon_vma;
+
+		anon_vma_interval_tree_insert(avc, &anon_vma->rb_root);
 
 		/*
 		 * Reuse existing anon_vma if it has no vma and only one
@@ -316,7 +324,6 @@ int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
 	}
 	if (dst->anon_vma)
 		dst->anon_vma->num_active_vmas++;
-
 	anon_vma_unlock_write(src->anon_vma);
 	return 0;
 
@@ -385,8 +392,10 @@ int anon_vma_fork(struct vm_area_struct *vma, struct vm_area_struct *pvma)
 	get_anon_vma(anon_vma->root);
 	/* Mark this anon_vma as the one where our new (COWed) pages go. */
 	vma->anon_vma = anon_vma;
+	anon_vma_chain_assign(vma, avc, anon_vma);
+	/* Now let rmap see it. */
 	anon_vma_lock_write(anon_vma);
-	anon_vma_chain_link(vma, avc, anon_vma);
+	anon_vma_interval_tree_insert(avc, &anon_vma->rb_root);
 	anon_vma->parent->num_children++;
 	anon_vma_unlock_write(anon_vma);
 
-- 
2.52.0


