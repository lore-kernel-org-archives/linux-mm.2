Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F8DFCCD184
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 15:51:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EA328E001E; Tue, 21 Oct 2025 11:51:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69A6D8E0002; Tue, 21 Oct 2025 11:51:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 514068E001E; Tue, 21 Oct 2025 11:51:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 366F88E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 11:51:53 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CF6EFBA47B
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 15:51:52 +0000 (UTC)
X-FDA: 84022562064.09.7C8F01B
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7B0B180004
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 15:51:49 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=mwu2wG6N;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=xBAO0IkD;
	spf=pass (imf30.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761061909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uxBV8uYp8G1HWYXf0ubcfQnxdgz53tp6cgQm4W/WHo0=;
	b=efcDfti7htb1P4PsNkNeRPjxxJciWeH47YLY0ncfBfTTXbiBCzAfyKTKZAlxXLTMyEO9rO
	78p79t5581UuPwSaDOEfMEBrePtNrlQlt8AeEt9pKiViPjMmjR4nKp9kWcF7U9yFGE6IaI
	FGim4pC2YiMRYwEeFmLMdElGOjQ7uUM=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=mwu2wG6N;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=xBAO0IkD;
	spf=pass (imf30.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761061909; a=rsa-sha256;
	cv=pass;
	b=ZGHXJJFQpy+KnmzOKZBc33/MeoQikF4V7sEbSDnPAytx5mifFSNyQ+USpitFRz49TResl9
	ZOfdTg7eDe8em/U3LvfDdwkYpnQkgRX5Wkp7n4Yl0g0GSjp5EaU1iEw1NYIR6JfQwI5jGA
	78Zh2zRxpqdfbmwsrecpYWrSHnrcwz8=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59LEIcsT013637;
	Tue, 21 Oct 2025 15:51:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=uxBV8uYp8G1HWYXf0u
	bcfQnxdgz53tp6cgQm4W/WHo0=; b=mwu2wG6NFqEIfY4DVDoHZ43GzTpmkmk2Bo
	x5AV+pv05SvLJx2//0iebjQPHeEpskMTVa0bN3JQlE8HkbWAgUSauSRHFQlEk+yw
	GVcNsSmeh+G4fX79S+sEPMUz9vKfQaQURZe8alqvmtvgMss2/qNEbysdJZe8X8su
	YvSU5PrDRowWP6/nFbI8mB1EI1+LrTihMocmhFYDIsq6OiV7Fp3hchj7yqAkMZxq
	FeIzYnN0YDxYqwHqdXYjELIohLEDe1dq6XG6UzG5WiAHWVJFwcpjaZLLt/zOVDki
	m2lt9IEmuBbKHavadAlFs08Q7bC0JlLC2pQk8qpJixToqQgHeeVw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49v3075q9u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Oct 2025 15:51:42 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59LEU7ul035341;
	Tue, 21 Oct 2025 15:51:40 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010037.outbound.protection.outlook.com [52.101.193.37])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bd1x00-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Oct 2025 15:51:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ts4qMZtmSYeDFp5pVUtvxBO0YKftKrqBq/49+qUhvSWoYBBtUmE/KNGr7G9nxitaWk2Nv8b6iW4mOs9iu3BYbi11kEVQuMzoWhiIh/PHJOVA4evKkl2EY4pzrqgEAorLvoNYwLZ3oaBgBbQMRj6GwECLS7aQLqZfnv9jPN8ibOGPik9XSr85zEelZxQhomcjHgYgT5lqzTORkaWw7lmpmGs7hh82YqrNSo9PdU1WnqKuPimo4AdDGE9BZW44sdLBN6cAHZKikdLaSJfGnUUTT8uanu0qn1mRed+nF6CtSnKXmInlcFbw8i1TtCENM0NXjiVPVRxzQAku2f33aoSx9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uxBV8uYp8G1HWYXf0ubcfQnxdgz53tp6cgQm4W/WHo0=;
 b=QYWUFSMkMD/+zOp+s+NZwr8QVIWruSpSKoPE4nu0zMyJEmfiJ5lpkoCTk+/kzWpsFSumE0/Fcu0slknJYPPRrV8XmV9AyXvS0ik5LQNUsmA9l79SJnP1OuaFbKGXIA8l2DrpX6Xs9zDiTS0APqtGQOwiBg3+W1yf9NTRB/cK4q37i8T+Z94c22SnOZ3YCgcN4CfgPTExAVQQ1pBOll97kIR13o9I+EVRysKuqDbnzA/eIdL/a3ILhot0pZuhpNBGPP9NVOacTN73owkHst2meRSLnLWSeY3UNMSuWPn5cmdV2aDDyqiee7YW021Zb0EcosbjvfuUYmm8srJ05RcqFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uxBV8uYp8G1HWYXf0ubcfQnxdgz53tp6cgQm4W/WHo0=;
 b=xBAO0IkDdjhtk2XSoGPMhtvXGqlky6RAcOz7erSR3H/m/1zaN1w3fa/7PUWdrDot+dZk3pJPtkALWCMrvHF2Jn2ESC1AxjIPSb7KKhBNVA/C6qiM4tKkjp+hzSTj9jAV28hHHyHqkrMbfbtlw5FwkF8dqj+TgUncoqkqFma2UOk=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by CO1PR10MB4612.namprd10.prod.outlook.com (2603:10b6:303:9b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Tue, 21 Oct
 2025 15:51:37 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%7]) with mapi id 15.20.9228.015; Tue, 21 Oct 2025
 15:51:37 +0000
Date: Tue, 21 Oct 2025 11:51:33 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Peter Xu <peterx@redhat.com>
Cc: David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Mike Rapoport <rppt@kernel.org>,
        Muchun Song <muchun.song@linux.dev>,
        Nikita Kalyazin <kalyazin@amazon.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Houghton <jthoughton@google.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@suse.com>,
        Ujwal Kundur <ujwal.kundur@gmail.com>,
        Oscar Salvador <osalvador@suse.de>,
        Suren Baghdasaryan <surenb@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v4 0/4] mm/userfaultfd: modulize memory types
Message-ID: <dtepn7obw5syd47uhyxavytodp7ws2pzr2yuchda32wcwn4bj4@wazn24gijumu>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Peter Xu <peterx@redhat.com>, David Hildenbrand <david@redhat.com>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, Mike Rapoport <rppt@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Nikita Kalyazin <kalyazin@amazon.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Axel Rasmussen <axelrasmussen@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, James Houghton <jthoughton@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@suse.com>, 
	Ujwal Kundur <ujwal.kundur@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
	Suren Baghdasaryan <surenb@google.com>, Andrea Arcangeli <aarcange@redhat.com>
References: <20251014231501.2301398-1-peterx@redhat.com>
 <78424672-065c-47fc-ba76-c5a866dcdc98@redhat.com>
 <aPZDVuscFsYSlQjI@x1.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aPZDVuscFsYSlQjI@x1.local>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: YT4PR01CA0053.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:111::20) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|CO1PR10MB4612:EE_
X-MS-Office365-Filtering-Correlation-Id: 83bb963d-a466-4589-642c-08de10b9b7d2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?d2l79mvRw3m3Nu05WvOY3JNm1VR+RQ5z0yuPX4bzRbLxkgZpMQNLqwj9IBoi?=
 =?us-ascii?Q?BFBTOHPd11qC3WCX91cPhfLlLWiiRKMVWGhAUa3oOGyIC7mROLxVNDz10HjI?=
 =?us-ascii?Q?+iMhEn7suRZ3/qqsqUrwxWvs3gB9MMiXKearZzS+l1GcBsVT9eKZaEw3LdUd?=
 =?us-ascii?Q?dTSNw0jpenbELHs36paWlRrDs9avYe6h8yG4MAR6MuQ+Rw3JK4mWhGOlMvfo?=
 =?us-ascii?Q?jxU4I+/hTa+gRg9aptOMkUUxyhKBdnTEyuUxwIGbKz5DW+KmqwdrKTss9Gnv?=
 =?us-ascii?Q?rYstPcxdlLZ2cT9zc82t+k6yQvuNoGShjJwtqWiCInUkJul5FSvFoZQEeP8b?=
 =?us-ascii?Q?/F6MFU7lWDv1GafDVDxhjzgDEoU16vJTCCkiGiTNlGIcST/HTPslhTco/jTP?=
 =?us-ascii?Q?EVWzspe9kHuD/O/fmCRcZB/R74gmiBtAIsBQ2BtS10YK/iJQHtxGS0LvXIeA?=
 =?us-ascii?Q?9uAHzXUhshG77LWfQVq3KyzrTlbYcftANN/SO2IrGkp8w1M4nAykxjAIZEa2?=
 =?us-ascii?Q?iJCm1Go5P6Lhe184/KUZrJeUdbHqXP0HyybdnQ1n7QLEvyaQSys9jb4uc/wb?=
 =?us-ascii?Q?WzUswImRfe/X6b7myVspx4rWZpEJ977UmTl8GdLjlN2h5r3uGEg9J/uCPi0g?=
 =?us-ascii?Q?wn7+HLCg7UiBVq8HD4jDfjVDTGBAuiyy/Z+Yzr97h8UhgxZfbUfgFUsxzgkC?=
 =?us-ascii?Q?La7uEEiC2xvAnESzH92zwzjrc8XK4qGDhgufVOXBF+PoCLdRKvZpv7VHQOin?=
 =?us-ascii?Q?aI2XSwXLvUftU2ep7K4SfIEKADR4EcacPzUqSn4hWMihAvFSjbSpfDdYiDyS?=
 =?us-ascii?Q?7lKihBF0P9hHvzDzO4DrgiJo4/1VJvf6oS7Xj1reTZBJN428PRxFt/gH/kxY?=
 =?us-ascii?Q?FKahDYAx76HTLmTnaSo3nOnOFUrdkXZaiD9/c1kdOT1AxIUgp3cu45hjO7Cs?=
 =?us-ascii?Q?u6bLht354QBw0Y1zy+kVF269tOh6wC7ZKxOJEaXrI2guACFFxZmwHHq1RKyv?=
 =?us-ascii?Q?SWMc8OJT3MFVhn/npqT8Dg45blE+vNeudE7jaIGtuPaVLJJR9U6kIu0nacch?=
 =?us-ascii?Q?wdzTmdMCvPXRsySiMX6jeWfBwaimvyeyQI6Q+LvBQQcKnSPUVU1nX/M5b0gt?=
 =?us-ascii?Q?WxEEhX0y381w45RqbZWdCLYQ+bPiieb8jM8QU18m6SxLLQqeiAF7154TtRQN?=
 =?us-ascii?Q?k3vISHHw870ZbxGgOSWJmLNTZdvy5hTyXt1QXx/+6H3PqmUz+p1qNZtf548p?=
 =?us-ascii?Q?CKggTPbkbvF6ovCRSta3P1GcrelyCLfjqJm5P2gOr/B+WJm2z1aPCGXmI8LV?=
 =?us-ascii?Q?wV8Eve0u7IgoyVQQ/lNQmkP0lgyAHANYf8NizmgF5zc1cqgjvahH0+cuSydd?=
 =?us-ascii?Q?ndUH0jeA2CKFf4lsNyo5Kxd0Qtn4gEXuTWvj0XW4L4mk1hSstbMxCZ5x13uw?=
 =?us-ascii?Q?JefubrIVOhMO4Eed+/P2oyUtE2g5kn4pqtlczlnM3RB1xggxvhtc6Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lGDH8TD+iT/nmAXF85VEOB9ILC89dMuEkfFjJ98PcF0fC13hubkbYqMi+EnC?=
 =?us-ascii?Q?6lyr9nZNWay0Y2WMFZWkCo9pmIuYprMoJkV6/DZCHVYwXEX6H8cO6KT1pThR?=
 =?us-ascii?Q?KN/PPkqn6U7+A8MaYZDdpBjUfIDr1Bqbsu8PerI73yFq3IoJqCloYL9u0/xN?=
 =?us-ascii?Q?Lt1NYLbWkaJHf/Wf6RA6gNZOqNCBJgn16bKYOVVIHqkIyoONuXyPnEbxgkPS?=
 =?us-ascii?Q?PHQazGZDiReXKYRpPJv0Ao5sK9vHWa4ATt4ehYyStkcsenyB16oYCpP0LlKR?=
 =?us-ascii?Q?AWeGUCC/VLhDQYtd/JniF7ChJz9TLoOrCbAXIl5XUm9hOMFb1ySDcYgKYva/?=
 =?us-ascii?Q?MNw2l+5m8XyirJ0WPf+Qrhnnb9e5uc395/jGyvHuIgZYKyIkKySn/jGsaihR?=
 =?us-ascii?Q?AdC8hsAFdWCkQRHEn5WQOElm4j1CKz5dklMSelIk5COJR/n+cuaKCwg6e5BV?=
 =?us-ascii?Q?6tKY8BaMlxdZie+7oRS7i3BcGy6sh5SDNo+UiteShig+MqPPoB0uSdis/6kI?=
 =?us-ascii?Q?FfuNBQQ9cCLUAMzLhSaBa0D559ZRFd6yvIF5bpfpon3cwsvG8GA4VcWtxNsd?=
 =?us-ascii?Q?i1G6b1kI/Dvm3hniJHxyKnw83TM7Xnv1tO+lteSOxAYivV1JumVa+vZYaN7k?=
 =?us-ascii?Q?R9OEOr74U7kwXmBoO4eTsRg+2ohz2WTh1RLwu4cWRmbyNqhz0U0q1l/5HfLZ?=
 =?us-ascii?Q?jB6pqk7D04ebA/S1q2PFXWvSGtvH1hWiasJxyUMAcIx+g/kqng8IKCue+NSs?=
 =?us-ascii?Q?5dEbI4wEnuIjfeLUkjqGjp8pVptqdDix/lvR0M4lzld0MUnA6APivdgq8R51?=
 =?us-ascii?Q?n5wHS8FiZnwMNebkBoxhs9NZGf8ASmql3W/mtCNi2UkAQK7FEgnRiDLoaxJj?=
 =?us-ascii?Q?YT2Kj3rQiSQrsvr4IM6pu1YKbh40UgVDtix9eC3A25qHfiiZQ7pzLqatc7y4?=
 =?us-ascii?Q?7kn9lsbtcGZUXv0gurNGsv7x1iT9F/4yYZTNHpVHYse+8Eiz/Bd1qPR3u3F7?=
 =?us-ascii?Q?prKbmYAnv8YO84ClgKtLE6EFtAs9QzSW0TMNHsHiaWAGenqwAdOOxeC2Toxk?=
 =?us-ascii?Q?SMUQRUhR7kpMBpGJGxBl04A1aB3YIbDO4l0hqAo7ID/BAa9gkANmsjx7LCLz?=
 =?us-ascii?Q?dRkOp90mRs5w1UOiea31624L4cBM/pWueGFc5VmU8NOmujz5fHDOQa97KZ13?=
 =?us-ascii?Q?bp3FtN1pATNFsKAPPTA1uPAUWYZZwp8wOPLz1ohO1hPe1w1ndILGNw8wS0OO?=
 =?us-ascii?Q?ss0Ps9apKB3ZSPtEcD+wXWQ6UVpVB+frUMYSi/F0Zb+G1UbNT9Kyc+2qFCoi?=
 =?us-ascii?Q?Y08mZ3j8aCoSe4SrVdqFsWIol0bcmZ9q049B3FBMUYV391seqSvzUICSigg/?=
 =?us-ascii?Q?AqJf5JYganKUyZaSonqXG2j9dFgSOGrCKkvJIO1ofvNv8VN5zZCGcR2Uc1Rh?=
 =?us-ascii?Q?Mkz2T9lYWNLR8AOA82E826XSjiPO45goLurqI7eFhnb8ZpnsqWhCkXtp1oEg?=
 =?us-ascii?Q?K3RRkYFvzd8K9A5Tsw4naTx1gYkQXKdf5oq4ol3xiMqgkldNfMrczukcAMWm?=
 =?us-ascii?Q?BCw+aobjC/1xc5SLjdug+ISZAjvJEw8IRoV+cV6O?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	JUbjE6sIEIo1PvJ8zw53G9Ojf37FjTUlo+VpTJe/1gSp0LkOfPlxd2Aduzd22X3bhUAgIhRsNfb+eMwE02g8YQ5M37DZ8QUcAyijscOUmBGk4jlVG78lpb6QjdX/VXY3qnpnZTXvrCcScaunpYdl7NVJpd2puY9VjRVlLT1PuBeX4QD1eFSOOHOa6+5TL1ybDroVBiQ1lBQVq8TG3106/vqwYCJPdLEjZCfjqZuWMjLpVgEZ8tl8VEW2lR5yozup+GtpVfovmw+IH6WndGdW1qtydwYHtax1pFOFP5kGHxn2j91LZ2OjuaKF+ir/d7sokaYXaH25NxzKl9oxdOP0FdL1HmO4ML89vq6N8yeQTPpsIASvtBOBGjgX95fx+fhl2lhRnUN7XjayBQQ2mSZG6Ry9F5Od0ye7JWfujQiGc5tOECZ+5YP+QXiMUh7zLMPVhZHc7+1aVR3I4M3qrsPtQ++4LLOTb1S1e46ENhzkE18lgdqpFM7+uOonB+TVFxb1bMKnIMnPbQ+CwGQA5gdTdeDj6bOMY41gOxfuE2+v6i1kTUjqy+TPPMxZtD0P9o/mVI2DH33YGsaA7iYEpSKhFdRy2Rqa7K+2aKp6kPHf9IA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83bb963d-a466-4589-642c-08de10b9b7d2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2025 15:51:37.4692
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iVeVuykaUR9lWtAj37F+Yr2x9qol37Hsjp/SKAffCHrOOxDrElUDiA35yIcnnHBxj99wDIjTTWLCuiHTSR5PzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4612
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-21_02,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 adultscore=0 bulkscore=0 spamscore=0 suspectscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510210124
X-Proofpoint-ORIG-GUID: gJPIG7DfTRBVRXqtUM7eeutPCS5skCYP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMyBTYWx0ZWRfX1T36o7jbHqSz
 leTKma5eJqMKEA2bWdI+5iGOAEGyu1nCde3nKEDojhTMr0rF4EmKzdS5ZAZGMF8MoVySgYLREvG
 j1b1Jd35ZsmTtmf9EzZVoDnpREo3hfKkitMvrtq/Fc98hJNx5zqdHrAH17vHkmhCSkxG6/U9NPu
 kreNZGPM1CTRwsvdlid4mK499U6y4Ec8B4s1+UxA5qgY0jr/if3nrBZBYCxEk7lw7IoV+le9sVN
 vn6VZx2tO01qmDE1o3oPs634Npmqc660/q0U117pSlj1zUc3X869AY9PgwoAnEVs7xbWTPtFoJi
 nnYAXRXTLgkwY3+izG/Ia6O5DFV744Buw1JEmE4jcpzHMzNOQR/ArcEfwRlje+33oPDdUGPqysI
 fc9dZly0WkjdwsvAOoPf2a+mevPlcka9YGmZTvHw4h4sRjal9/c=
X-Proofpoint-GUID: gJPIG7DfTRBVRXqtUM7eeutPCS5skCYP
X-Authority-Analysis: v=2.4 cv=csaWUl4i c=1 sm=1 tr=0 ts=68f7ac0e b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=vggBfdFIAAAA:8 a=8YDB-RGHgHhoYU8aDVMA:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12091
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7B0B180004
X-Stat-Signature: gnsoeijrua7mg1erazy7cpjk7jyy6fy3
X-Rspam-User: 
X-HE-Tag: 1761061909-937316
X-HE-Meta: U2FsdGVkX1+fqtoaYNsw+0THBKYa3BYp4adHWLAjYHzuV2E1j0oXsSUfMqyy6brKlf3osbuhqvG0CHNjuDxVa1nbqLJeRMQIyrA1irF9doTD5ZemPOK+3wwUxPP5LN6YfW0BCYuNLKQ2nlHT6msMd+/quek8LlieT7GWQ7hcNDuzaFCmYEwxivGGkm+yt0Fycd6FafPAm73t8RtzgDBot+UX2MLYkxPXxebJ3B+Y/Q63s2c3JIJCOfMLc3yfhX7oM0+XX52DXTkhVKt2L3sHmQ5S3s87KCmjuC2heMAiDXfkyRFlRDm59iRPSBv5XTK/fBKdZeoH7a8KQvHNPl3doaBpk1KYhk0p2ods6BvpoJOC15IELSQuFxj6YX1Rg84xIOuKluY7xWofvL5VkIA4ugHznMaAVTbG/zhq17CbdNrQqR4KOSiC1QRS5HNqUMKqUUFjknJKhSDOzibsOhbUTd90RSIx8ryVkTmijrOsTaxJjkRmzDGNsgA8guyEVQPTSomwqAAe4GHF/pge0nXDfE+j7q+XzDt6vyYHQ0ac+DMePruaGLkuxKGR3PmeryeDnwar4ujJ7U7ErjqOYkIulxHJHBEPdMj4RJ4PYrcHg6YcRXWtAq3jsvSnJTwc4p5HAMuZ8SA3Q1SOu+2LE4sZYIcgLq66S3UAc5u2cH7AMLOlq6H7YOW4K+/fTEr+KgsOghrAwBaWX53t+yUoMSDHOrt2SxhG4V+zOIQcBbX0DM+t8biHsS//WNOe/gpiYiiJ/Q/cuPuvdtN2e95YO99hrr+OkC/n2ufkITZzwEKvEmcthTEUyr07IL/Zm1Qwzp6d98nTCK0VXSUqEBIqFLOByTYaHffmAWAW19Xs2MOaPpXHhn63J9UbPhKCdi4k8BHzbFHyQ06rcplvcGcG4awZPOObJAnzzy5ee8RYtg7+ABUGgGt/NnBMc43pRL43ULxrgDBrcDXdlLgMvaaQCAx
 QzfCeYyH
 EAadjZ+LyChhOMjdDG0m5J4yBcKr7Dq/A8fVWfMJnjbCp711L4tUb6Xh4ZbjhXOa4f0f73ZOIQ840IVl4heFpaqFlWjlSD8NMKOifEEaC7VAKIvzN3DBQxOe2fQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Peter Xu <peterx@redhat.com> [251020 10:12]:
> On Mon, Oct 20, 2025 at 03:34:47PM +0200, David Hildenbrand wrote:
> > On 15.10.25 01:14, Peter Xu wrote:
> > > [based on latest akpm/mm-new of Oct 14th, commit 36c6c5ce1b275]
> > > 
> > > v4:
> > > - Some cleanups within vma_can_userfault() [David]
> > > - Rename uffd_get_folio() to minor_get_folio() [David]
> > > - Remove uffd_features in vm_uffd_ops, deduce it from supported ioctls [David]
> > > 
> > > v1: https://lore.kernel.org/r/20250620190342.1780170-1-peterx@redhat.com
> > > v2: https://lore.kernel.org/r/20250627154655.2085903-1-peterx@redhat.com
> > > v3: https://lore.kernel.org/r/20250926211650.525109-1-peterx@redhat.com
> > > 
> > > This series is an alternative proposal of what Nikita proposed here on the
> > > initial three patches:
> > > 
> > >    https://lore.kernel.org/r/20250404154352.23078-1-kalyazin@amazon.com
> > > 
> > > This is not yet relevant to any guest-memfd support, but paving way for it.
> > > Here, the major goal is to make kernel modules be able to opt-in with any
> > > form of userfaultfd supports, like guest-memfd.  This alternative option
> > > should hopefully be cleaner, and avoid leaking userfault details into
> > > vm_ops.fault().
> > > 
> > > It also means this series does not depend on anything.  It's a pure
> > > refactoring of userfaultfd internals to provide a generic API, so that
> > > other types of files, especially RAM based, can support userfaultfd without
> > > touching mm/ at all.
> > > 
> > > To achieve it, this series introduced a file operation called vm_uffd_ops.
> > > The ops needs to be provided when a file type supports any of userfaultfd.
> > > 
> > > With that, I moved both hugetlbfs and shmem over, whenever possible.  So
> > > far due to concerns on exposing an uffd_copy() API, the MISSING faults are
> > > still separately processed and can only be done within mm/.  Hugetlbfs kept
> > > its special paths untouched.
> > > 
> > > An example of shmem uffd_ops:
> > > 
> > > static const struct vm_uffd_ops shmem_uffd_ops = {
> > > 	.supported_ioctls	=	BIT(_UFFDIO_COPY) |
> > > 					BIT(_UFFDIO_ZEROPAGE) |
> > > 					BIT(_UFFDIO_WRITEPROTECT) |
> > > 					BIT(_UFFDIO_CONTINUE) |
> > > 					BIT(_UFFDIO_POISON),
> > > 	.minor_get_folio	=	shmem_uffd_get_folio,
> > > };

I think you forgot to add the link to the guest_memfd implementation [1]
to your cover letter.

> > 
> > This looks better than the previous version to me.
> > 
> > Long term the goal should be to move all hugetlb/shmem specific stuff out of
> > mm/hugetlb.c and of course, we won't be adding any new ones to
> > mm/userfaultfd.c
> > 
> > I agree with Liam that a better interface could be providing default
> > handlers for the separate ioctls [1], but there is always the option to
> > evolve this interface into something like that later.
> 
> Thanks for accepting this current form.
> 
> > 
> > 
> > [1] https://lkml.kernel.org/r/frnos5jtmlqvzpcrredcoummuzvllweku5dgp5ii5in6epwnw5@anu4dqsz6shy
> 
> I have replied to that, here:
> 
> https://lore.kernel.org/all/aOVEDii4HPB6outm@x1.local/
> 
> If we ignore hugetlbfs, most of the hooks may not be needed, as explained.

Those were examples.

Hooks allow for all the memory type checking to go away in the code,
which allows for more readable code and less operations per call.

> 
> If we introduce hooks only for hugetlbfs, IMHO it's going backwards.  When
> we want to get rid of hugetlbfs paths, we will have something more to get
> rid of..

This is just wrong.

It is far easier to remove one function pointer than go through all the
code and remove the checks for hugetlbfs.

Are you thinking the hooks will just point to the generic function?
This is the only way I can see your statement making sense.  That's not
the idea I'm trying to communicate.

The idea is that you split the functions into parts that everyone does
and special parts, then call them in the correct sequence for each type.
New types need new special parts while using the generic code for the
majority of the work.

In this way, the memory types are modularized into function pointers
that all use common code without adding complexity.  In fact, knowing
implicitly which context from call path means we don't need to check the
types and should be able to reduce the complexity.

Then adding a new memory type will call almost all the same functions
except for special areas.

Removing old memory types would me removing the special areas only - and
maybe a function pointer if they are the only user.

The current patch set does not modularizing memory, it is creating a
middleware level where we have to parse a value to figure out what to
do.

These patches DO expose a method for memory types to be coded in a
kernel module, which is fundamentally different than modularizing the
memory types.  Different enough to be glossed over on a ML by looking at
the subject alone.

Yes, one value is better than two values, but no magic values is ideal.

Is it a significant amount of work to remove the magic value by
fragmenting the code into memory type specific function pointers?

IOW, instead of decoding the value to figure out where to route calls,
just expose the calls directly in the function pointer layer that you
are creating?  What is the minimum amount of function pointers to get
the guest_memfd to work without this value being parsed?

[1].  https://lore.kernel.org/all/114133f5-0282-463d-9d65-3143aa658806@amazon.com/

Regards,
Liam


