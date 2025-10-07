Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C704CCCA470
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 18:47:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED1128E0003; Tue,  7 Oct 2025 14:47:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA8A48E0002; Tue,  7 Oct 2025 14:47:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D70548E0003; Tue,  7 Oct 2025 14:47:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C31078E0002
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 14:47:08 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 761241A017F
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 18:47:08 +0000 (UTC)
X-FDA: 83972200536.11.EFFD898
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf19.hostedemail.com (Postfix) with ESMTP id 12AA31A0003
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 18:47:04 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=FD6uE13M;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=KBfRoZ0B;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1759862825; a=rsa-sha256;
	cv=pass;
	b=dyUuxBLFPnfTHYFJbywzasgYdg4JvkdxvQOkxsr+gUWiSVTJ2hsktRIM7QOquxpGBPvCh8
	Kj6JY9566cOCvTbnwcqdeiuiCM9mhvaepDpJZKPH+BGmjZqPot386civeLRzbGoS/BC/dK
	JjfmKGkFxOSptNi+2CsreJPitoPXpvQ=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=FD6uE13M;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=KBfRoZ0B;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759862825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Strh90qUCmd16EIz1pq+atC1aLzWsfq2txj74tmpnx4=;
	b=kvT+hzMc5jNgg+txdwAEp+g1QFKW7iECgN5CeDIoyXtg5NZn06jq3gnYLWcF//u3rHVBGJ
	G5Cr2A0z1eAp/tOC/WFyoiNU9qDSd83xfhqIP27ycwAhSbX7gasOOUY5TO9KEMEq1lqQWk
	me8sYZ90btK7tTdcfw63ZmkZJu+pl+I=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 597IWhSs006929;
	Tue, 7 Oct 2025 18:46:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Strh90qUCmd16EIz1p
	q+atC1aLzWsfq2txj74tmpnx4=; b=FD6uE13MWcpbKVVwK4yI9wkpPvDTDynGiN
	qZvIyfl1izT8r2VEFmyvgMIfPy7SDd3tUL3jhLKy1ahvsGrR0VsNdlYKl2pEUGbk
	nB04ZGf3TQPTQqkDoD8jSF5zbIr0fsubGs9b6ynEzMLIbkUQz/x5Yar5CGU7+sKY
	v3N26LkrmcoidCPNCsGknVMrQkR/oEAneVu+obcSt1X8teXuhUjukP5ZBgpzmNue
	V1n2iqSTYMS01rth3l7Ki0S35wXoKx7jLiBhQy12btJmAMljDp6+hnXbDQmWHcYH
	0oXySW5GrjnYDy8DRb/fiZEUoqe5rNekhJymV7khjyZt5r/VzpIQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49n6yg064p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 Oct 2025 18:46:59 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 597I46NU035503;
	Tue, 7 Oct 2025 18:46:58 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011021.outbound.protection.outlook.com [40.107.208.21])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49jt18mbg7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 Oct 2025 18:46:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qXzWVWjsgJM/l1LELmDzZ75OD6n/skY+hKymUmJTqf41ppFS7RZLCTGnnUK7Vhd4lllztq4mHd3rfFDSRPvKQE5GHyA4T+TgxU92zopf42b+OD6sOusOZyMPZbdHpCuX12p/XoWr1rA7IGvTYBRHMTNN5AupLhsgeLkZd/Ej9R7BgvZeJHQtPiVmryoHXEgCiy34pwBnSoNiRAtWWDTBYd2OkKoRE8gwm4GPp7jHd0K3K30NtoqpMAy3VfU8X5bIkF5LyShHFvoRp1vmYcZzjj30+bk0qRVc/2FqzP21KiMiz9oeTja0we40jA7k0+rKBiRrL4SHW9B746wImDiceQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Strh90qUCmd16EIz1pq+atC1aLzWsfq2txj74tmpnx4=;
 b=Tra+gQUnwuHFCWGOGv2ZrGweGJM+eZXJ50dB/v/4m5Kzm2VZXH6RBRCc9Q6aTn8nvuOSKwnYIxtNz7pYmvYnChExKcVbPmYllcCHgai9zrhMHwVTJHDvT/wL7GQ4PFaUXnPaAxKnoFebRxKeMKaXLzrP+w0NzoLso+orUkLRy0cjF6u0MqcI6sCJc0sSDtb2QnYCe3xHGVvhV/C4yB/o29bqsu7eBYfvV95qwee/6Uby3kkkRP+0uNRQIZLgqODi9F58C6pCfgv4Gvi2C97D/Go5VyNtsVNgqLCIq4P3p2dtwdQay/QaT43Hkzvkyl/VEZ4Mq+f6WyTjUafH8MEBfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Strh90qUCmd16EIz1pq+atC1aLzWsfq2txj74tmpnx4=;
 b=KBfRoZ0BL8TU1k6YhI/jLL3FC+kRIdRcNz30dRVC+PwPbT6Lleo07esUKjFFMNs4/M2hB6zA9wqOjViJEWPCEGRS6VxOsJbWuwJzSrUeCiQ5k7h30pZ1qRIkUxPLeGt2uwOfsuruZYbLfUOtPbNklrPK0YRNLfMaoyPR7OVoy9I=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by BY5PR10MB4259.namprd10.prod.outlook.com (2603:10b6:a03:212::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Tue, 7 Oct
 2025 18:46:51 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%7]) with mapi id 15.20.9182.017; Tue, 7 Oct 2025
 18:46:50 +0000
Date: Tue, 7 Oct 2025 14:46:46 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Peter Xu <peterx@redhat.com>
Cc: David Hildenbrand <david@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Axel Rasmussen <axelrasmussen@google.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        James Houghton <jthoughton@google.com>,
        Nikita Kalyazin <kalyazin@amazon.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Ujwal Kundur <ujwal.kundur@gmail.com>, Mike Rapoport <rppt@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Michal Hocko <mhocko@suse.com>,
        Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>, Hugh Dickins <hughd@google.com>,
        Suren Baghdasaryan <surenb@google.com>
Subject: Re: [PATCH v3 1/4] mm: Introduce vm_uffd_ops API
Message-ID: <6csw4pmymno4kdtlbzd74posr3dekamq4zkje2mfkmbg5q7xbx@y3o323tbm7h3>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Peter Xu <peterx@redhat.com>, David Hildenbrand <david@redhat.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Axel Rasmussen <axelrasmussen@google.com>, 
	Vlastimil Babka <vbabka@suse.cz>, James Houghton <jthoughton@google.com>, 
	Nikita Kalyazin <kalyazin@amazon.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Ujwal Kundur <ujwal.kundur@gmail.com>, Mike Rapoport <rppt@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Andrea Arcangeli <aarcange@redhat.com>, 
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, Hugh Dickins <hughd@google.com>, 
	Suren Baghdasaryan <surenb@google.com>
References: <aN08NxRLz7Wx0Qh4@x1.local>
 <ad124fb6-a712-4cf5-8a7e-2abacbc2e4be@redhat.com>
 <aN_XZbQjuYx-OnFr@x1.local>
 <cq3zcvnajs55zr7cplf5oxxjoh54fb7tvo23hehd5dmh4atvum@6274mneik6hu>
 <aOQuZy_Hpu1yyu29@x1.local>
 <akld3v2mtnjdqvs5dgwr4gnffdqf5dojwhmfylq3mkfzakjj7j@5oqqxsymkcbp>
 <aOUa8C8bhWvo5TbV@x1.local>
 <frnos5jtmlqvzpcrredcoummuzvllweku5dgp5ii5in6epwnw5@anu4dqsz6shy>
 <9089d994-262f-4941-8bed-f3c6ee05a769@redhat.com>
 <aOVEDii4HPB6outm@x1.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aOVEDii4HPB6outm@x1.local>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: MW4PR02CA0028.namprd02.prod.outlook.com
 (2603:10b6:303:16d::7) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|BY5PR10MB4259:EE_
X-MS-Office365-Filtering-Correlation-Id: c669fb1b-aa4d-40fe-e153-08de05d1e065
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?fw4o7egsl22MfuWq+fb/d02Ci/KoTQrkKl737AeJ9b40+x2F1G3ozynDpIln?=
 =?us-ascii?Q?ctBzkMGjCPPK0oGAhNuZ9LGSO7d1B/zPPNjgAQ7vbEKSAHB0AU2/NZDbb+cO?=
 =?us-ascii?Q?2lrJX+QC892/RuBos3Til66eTnvje5EjaWk9nOOLLpeaAzLS7+tLK3VHOxbt?=
 =?us-ascii?Q?auSnP7dZIckq8w2ektw9gYqzC1z+xYMlbLApcXVKggz3Zo5uq+ESlq9XvhM/?=
 =?us-ascii?Q?v54SYvJfHnh7IuspkbHeQdxKZqvQNct4NfWDNU2S7sOiM7Qel8R9Taf1JZf2?=
 =?us-ascii?Q?mI6KawFSVxppQDJJyhR7va9QVMu6qZqLBHWRo7jF/Z9lf/5KBHlsM4mrSN63?=
 =?us-ascii?Q?VPhKMX/NW9ScqP+ocAZAU/kNytzorPPwhYhc6MaUx7LXKmpJmjUgBIEbENop?=
 =?us-ascii?Q?P+yPqOJGzpu2aQKP++nxjmbAApoIXfApZwua6yXisHRp8295d8OEDShcdDJ1?=
 =?us-ascii?Q?vrnw55QLhzX5G7JDuNETCrdNcqwO8/hjO8kBiZlewmzfSucAsuYu8TxxYsMs?=
 =?us-ascii?Q?nwbCAc+o3S0mpxTPXjI7TFF8geKRIMJMeVKlMO05Y+aMJWLKivlloU1kyeYd?=
 =?us-ascii?Q?RX+tT8St0WjzLtpb+U5gPn9doFDVho7YiW/hp4kZ+oZEEWyn/3uh0oFxVrD9?=
 =?us-ascii?Q?C6xBoL79jR4/tcpkjqjBc/4DPu/YL6yLiKBq69pcwMT8Six2b8su3IJMtdTr?=
 =?us-ascii?Q?+4p4z94+IBL5QW8WJo90e1G9lvfw60zvqayJMburlW5VANbFzxJTfr80gpN5?=
 =?us-ascii?Q?xI4Y2NjEZkedvWpjJmEmaU/cldmLL0OebvHOGwWBXIscWhBVgiwq+ZcbGAY5?=
 =?us-ascii?Q?9TE04sESnzCwSGUlgNT1nVcG7UYqcJe1JrH+JYmYmQhj+9XtBNM94L0drjet?=
 =?us-ascii?Q?Bxzaj6W+yuiBsigpqZCPok4sksAfCH27/BAIniG4yTJDUrezgNzO+JhuKExA?=
 =?us-ascii?Q?2qUhdi1yR8jhC1qIJo8GZhNLfnu9FAIVJhXpROksFERY+soyDMvTODBcoAhr?=
 =?us-ascii?Q?fcDMLt+HvictPJmcJhKfm9B36ZXEOH4MoxpYMZgZbItg8mgDIhJR+B3464J/?=
 =?us-ascii?Q?4CnJzmq8zx+PsS9pxxpD8NT981DQVPMO72cMOtHHC6d3BPUvfCe2Tz2yX5xW?=
 =?us-ascii?Q?NSqfuxJZHZL4Aec0Fnl/uTRbguCgsKjjH+zYTSTPFhPfg8Ra9LPkV2MEnbB3?=
 =?us-ascii?Q?VcM/MOulWv49LMe2xcD1qq2+eGoCyY0nbihAW076wT1Dom0iiLIuyCRi50DL?=
 =?us-ascii?Q?vpTH5JSzy2l3KVi9BGcllIqT3sucPnga6v56o0UbGr0gQM4eQBctMcbgtHSo?=
 =?us-ascii?Q?1FOgzcOnHU9F19QdPD0OMuPo2gCqPxmoDytSI6dkJbdBjNkqlqIJ7NJbzxVI?=
 =?us-ascii?Q?yvaqA1KpToLvwikyfcRZckVNc1NuOIHXiGGnjmBQ05eO1ybFlEzSsNEsTFyC?=
 =?us-ascii?Q?KAgk/tWezc2+tEcqiTw036gFnr2rXi+PMcX52qRMrmrL7bDGfgyOZQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qwj5ZqP8QAetfaTObY0OBRafZ9xtVwhBfDS2pvN8NjZ8fYTnvQP4Cw6AqDHJ?=
 =?us-ascii?Q?3IaWOX3Mbbt2BEkQqxsyk89L/RO54ZC/YjbfJaH4njMSk444uVdeOIqzTwi/?=
 =?us-ascii?Q?+pyKo77/cZr/v7BXd1y7uEQJy7P8m8eBiUjd+QsTF8WW7KyW4kwrdmQN1TTp?=
 =?us-ascii?Q?3LpwckqibEOvZSe3PvYtktfll1Kdi5aBGQMxYiEcneqLVzgYDS/b8KGLfUBh?=
 =?us-ascii?Q?oUrv9rJqss8Qmk2WVBOYevmQxOEP3gCAR02/QVxow6PYKkwu70boJdtrXz6D?=
 =?us-ascii?Q?TQPWKGK3VeTSpbs983vdpoevjA6veAtCPHWRklFZ0ptGF+fRZ/pZQeytP07L?=
 =?us-ascii?Q?A4XcwEJAYzozJO6VovWr3/pL/0mJGO2sx1P8M4g5wQ4vcPlussrZPtUmtrp5?=
 =?us-ascii?Q?8hf259zO9gdvMGxMkTXcA8Xe9c+C6ceWA2GJ93qSqjHSDEIk1LluH4I5ZjA9?=
 =?us-ascii?Q?a5kcwI8VdMyROtU2cs+q7ubx98nmT+hn8yoEa56eRuz+fdcr+RmzcXDtK4g4?=
 =?us-ascii?Q?HU5Xs0jm81D2T0J3sSDTCHd3V7iojrLtU4FFmjdhBxq1o28NtMNCco/TWpIv?=
 =?us-ascii?Q?GeomLmDNlSXdbg62mYY9LIw20N38BeZBQq6sZ6YCsdsUEq3CPfvkPHwR1RPq?=
 =?us-ascii?Q?oiOV1jxgiIIT6Hf3P7fZp7XWAQJXPGXaHrGiveLLjhcC/EBObdDOm4jHcjjk?=
 =?us-ascii?Q?pr3W871XmuC+4vxsev7xqSVatGSXC6LZxcBgPNzPiSXaxQ8zD5AmPvyNMq03?=
 =?us-ascii?Q?OyuCALq2dYbDZ/SpD5fWgwIAdX3f4YCeSkU2VjgSIZnqKsZ0TkoHl8/ChUVj?=
 =?us-ascii?Q?FOqfiN14m2+4VnxM3+J+qMvXKE0fgxeKPcPmBhdFz3xELHWLwn8cPXBILSNG?=
 =?us-ascii?Q?I2Z6ooF+AUbPmkaYFI8IquYvKEV113JzCKwhcqugYKiTqW0NvZtLhxojvv5O?=
 =?us-ascii?Q?qd2r5lyAAfDBn9HhIWnjgCSQWYvxqVHyRLlEPq91QPRn7+3lOToZJxYc3Q1m?=
 =?us-ascii?Q?piMrOPsO1hQPMuW30LDQOEMucubB6SrjrxDT2JzXbTaDm9xtJ2Y/we0eaPmA?=
 =?us-ascii?Q?cfpxzLyldUk243fB1R2ZyThAN5P9mia/LetnkHdic5IIGV8CyaUbDwj1FWtw?=
 =?us-ascii?Q?ry10DG6JYOllSMl7o5AONI1pd99BZ5BKBYNmKOPre9Dc/emW6eUWc8FcHSQw?=
 =?us-ascii?Q?HW0AaP5jFVIBcb+3tQMLNqcNZC3MsLblmpTb3nAYy2L782X1a2nos2dZNlsi?=
 =?us-ascii?Q?MNzVDGIe7X09/pJWBYpTUcYBAvacVRhd5+s+7dDlfBWOVYRB7okKxCirNl8D?=
 =?us-ascii?Q?PE37zSXwuwY6INztUaPyBb7ufoNzrMhOw6aMdAtASjUnlUt3h5Uzb/dWE03n?=
 =?us-ascii?Q?6wWFfaZkU3pbdoAIxnaD/PhNc9Fv6r62m2GpoPvqkstDvNqMIx06DRUQTLEC?=
 =?us-ascii?Q?++7GfXdGaMiEG2WQJzAyVGHafpgYBaqPLFCjNZb48XUBen7DkUAZ6eoJAiTI?=
 =?us-ascii?Q?SKwvbQtm1NLo1VQl7snZA5SZYicq48viAsrbP/vIYFXzDI0Y5OOnw8nUinvS?=
 =?us-ascii?Q?z3tsI87sDCG8cFaKCiHxRswe4ZdiWFOZyeW5pLyL?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	PYBlBGcBSR4yZ2OPzvWvczTwyMGvvOgdfyZbdyFxgQhwUZ2N/IdeEM2vu6kGrmLOlQM0v6FTyqlSF2EPpiSvmU5vZHhOD2oOGVjVbiwjKaocQ/ja81V41l3kbhFEta9DyAFjnRTzqbra74cS5HfwecQ3kwB0Jfa7h0u12mh0/XBvoCbUdtO3swWsxsPFZ/xtBYht0UcV/F8i7HXLXwLkB9nWLXuKvk0l8mjqkbclFQ0g1/xJVFDOqxbbDCxmse8f7Q1U8QiKBgyDY0Vn/RBaneVSvz8OkDMeIxwCNVYr6IYuxUe+ZtUL/P5sesurG1cpJ4czSYujiyGeAa+RdOQp2xa8ShvnWG1bTfZJhrcdljisnlf4+birUDSt2Wz8GdhCjhy0opFPJcMEeI043QJvQUln59DpGfMQGWS5CsJQ2qHj6SsS5F7ojqMlRJ7LO5xZ7AgupQenPVsPB+6BDpXgwoTH1MNtSbPL65P8YK/YUdBRLOMymcZiiGqkLasZZhPUMMXA6NUcLP3ipOpDzfes2NWRINzwOPFy8DyhqqMrEKhYtVE4MWNUWt37U+qPJUxYKrmFINnGLQdj3NVkSFEn2uQ3CdcxLuUBQVCpXnWT5qk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c669fb1b-aa4d-40fe-e153-08de05d1e065
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2025 18:46:50.7001
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SdO4HtdFSqZLX3d+fVCDfWaLFy27YH5njqrwVjL1dvPtAzhcZEUukEYmxJG+6f5Zu9XlgOMhfBMTtAksHLhA6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4259
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-07_02,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=602 spamscore=0
 phishscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2509150000 definitions=main-2510070147
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA3MDEzNCBTYWx0ZWRfX98bnvQI/bd+T
 LceETjZ8Y22VhEZOhw4NvU0biQxX7nCaftLr+PjrfynLfQPqa4WHEdwjmfhBduEiIR9HmtTxAYy
 vZq6EWOHg1iOpGhdSoJFxSc8XB4w5r/pO6eRwHSy31GXjY1WClf4/6CV7FRSzMxeT3A220xqSw7
 P3vZbgyt8PVSuXH9QeRn3tGw0JT5QdMO3D0dAGK1SEbUtGs4KTTM7A7XVxiXjOtNAd1MW/nksc+
 2r2KrFb+uk7s/O5BllKD/W3HZTlhgZwEsISMkO0M4pkZTdRo1e1jTKc5ir+T8S3T0bsvcrcbljk
 XB4dGXyXq4rvnIlPekUNP5fxPjyCfwGobJHv3QWbL/sIQAlKUY1AIHmdbxOT/ReHLsrUzOho3wW
 Y+cLfH0K7ElnjfC5+S+rxXaEOCXYfE25LW5CgBypIWj+gT3ZzwE=
X-Authority-Analysis: v=2.4 cv=VpYuwu2n c=1 sm=1 tr=0 ts=68e56023 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
 a=vggBfdFIAAAA:8 a=1THOcbknKnyru7S7G1EA:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:12091
X-Proofpoint-GUID: emWSrAwLHFY5Zi5YYpyeNDIJTeykcL3J
X-Proofpoint-ORIG-GUID: emWSrAwLHFY5Zi5YYpyeNDIJTeykcL3J
X-Rspam-User: 
X-Stat-Signature: rhbyo9amjf1dsenqdd16hkt1tixae3uc
X-Rspamd-Queue-Id: 12AA31A0003
X-Rspamd-Server: rspam09
X-HE-Tag: 1759862824-176809
X-HE-Meta: U2FsdGVkX18Jw8WYnWuYcwXIARF4w5sDdEQfE6ysOJfL24F51xFkKWC26KsceP/GPf3EeRk9/IIf2BLMTYKqVB/XRwL9fJpVI3GofSDkYZCRMbYvM5x0cNDOBG3fxx3+tHBLOPgv+SEMEIHCOsad8p4OZncLQxbkKbA1SaHRwtsUhsjTxtK5gGCGIDjF6sV9Am2mhmmUsBDiijpEfiw6TT4u03VfM+aPWOUqeXvARMokipL0ZX49ZJpQcO/0rxabur0zYOAvL4Q1Vq1hFbHdT2NMPGekukIVQZxfS3egQc4LVSkqbnaeAmuHQeuCzDLmUM8ajt8dINIvKanNsW6RM/34qaD2OzM8SSk/KiSAmybA/HgVXTp3L0QSUwLrn3F9fRIHHfdkZM+Ufb1BmHPqE7L+rFPpR2O1zoqjOQ/Ef3PPzGMSZ+mhPi7RxfvyHE3zVAybkkXlEamvQ9KpR06FTQlMwUhiA3BAIkk7/X6W/CD4ahZnbAG6ekgHfqjskDFBJWxrWyhqIiytktrIHGv/txmvgPfj3HuCZpgE0PI9QbIoFEr9WNbQ+Gvb0mfH1dD5BdJUM2Ra5wBU9ddP305Qds3H4ogdWtJ6RgW/PLJ5zsi80i7jI9ek50Tiez8jq2kFIWmcGvo25xWYQfLKaNvoAFeHbSpLIMqh68WUvZ5e5meMA+gQha6OgvOVrSu34+vufPgYzsDISaIaM9FBYDnJTiQznH0T4msBC8PCfnZREHVyWJQlYIYG/zWHm6Hm3shRUjvM1UOftaw9ip2/7KUPqDL40v6vvIpQ+JKeaKRLT13A/sTeDGG0ndy2NpM4u1R66Me0oltCwtKVpF3udK1VNW4NMyNsJJNAVnp0XfLhGWdzpKL5t6X+TUIkGv11AQY8y2l8L5giO1Zg6yYhUFcdND6ne/BGjA+yuENX+5Lokhupu43Jhr34Ls6K98v+LibKNSLIU/fBXsSWoPb+4X9
 dqzsfJ/0
 qW6lE26TWFhpZ5NabcddOBG1V4V5N6j2L+azj7rqLkvTFEeG6BBtp11fgUK9US8vgDPKlzwL35srLQz5VH6A5CR01swEJpBiw+CP75468a83RlY+BLwnumInG7yxNynpgILj9mGfD4bZj3tpeQ39m/WTO3kRwnngnfr/g8W5viGRXA5BpSLouVeBLsQESi1Tal+3tCub42fnZNtJ+PBLnjak/r5cwH0akk3NW+HaGfewJ3b8RGGNHBp489Udc+3aCZRtnP9yooeNyebVNoH758mFMx1wnkUOmuuLE4cmJFRP+9HZXMfGzUzpsFa4usb3tzl73Bo06zz7W8zc8cuOLbICR2Iti/xLn/HLhjp+Y9yNpyGiC7XHObhY809niGnrFTeBAx1FvfAu9PbTdyhELkI5tALA6CYvYEy3uBx3O2GZ2n067QoCd+0cu/fB2xIrriYR3ZdM1kRLP9dXoFa7zr6YJ/nwRXH/wpMdaOnq0/VfwywltB6gtdkR0bAZYvKtx+xmIhIS+XVjEVJuXMB6+pqhqVRxLKZbwGo5DMu2C2N1NThjihuU+YNr59HxnUrIDZfq0HPkhAAgWvQaXmzvHk8c1cPAkhdQxc7eMRe+KtBTybSAYNgSndI64OSa52iYCF5I2EiLMGleBKrmDTzgJPVQDOcC8rm0r7Hq2+PP9PmL7sh5i4aCrOc+iGpedWgJNx6Ltm3Tii4brHeqhyWRQz/Zt1Y3MEYCn9foGb4G9RlPCk7ieFLQRqVfUrO1gEO8Fr3orQks+J23/sU8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Peter Xu <peterx@redhat.com> [251007 12:47]:

...

> > > 
> > > This way is_vm_hugetlb_page() never really needs to be used because the
> > > function pointer already makes that distinction.
> > > 
> > > Right now, we have checks for hugetlb through other functions that "pass
> > > off to appropriate routine", and we end up translating the
> > > ioctl_supports into the function call eventually, anyways.
> > 
> > Right, it would be great to get rid of that. I recall I asked for such a
> > cleanup in RFC (or was it v1).
> 
> I didn't send RFC, likely you meant this reply in v1?
> 
> https://lore.kernel.org/all/0126fa5f-b5aa-4a17-80d6-d428105e45c7@redhat.com/
> 
>         I agree that another special-purpose file (like implemented by
>         guest_memfd) would need that. But if we could get rid of
>         "hugetlb"/"shmem" special-casing in userfaultfd, it would be a
>         rasonable independent cleanup.
> 
> Get rid of hugetlbfs is still not my goal as of in this series.

My example picked hugetlbfs because it is the most special of the types
of memory we have (so very special).  If the interface works for
hugetlbfs, then the rest will use a subset of the features and be happy.

IOW, doing the hard thing first makes what follows easy.  Doing the easy
thing first may mean rewriting the easy thing once you arrive at the
more difficult part.

> 
> OTOH, I generalized shmem and removed shmem.h header from userfaultfd, but
> that was prior versions when with uffd_copy() and it was rejected.
> 
> What should I do now to move this series forward?  Could anyone provide a
> solid answer?

My understanding is that we need an interface for memory types so they
are modularised, with the short term goal of solving the faulting
support for guest_memfd and the long term goal of code cleanup, or at
least don't make things worse.

I think we all agree on that?

I propose that we need to add the minimum amount of uffd_ops to support
guest_memfd's specialness without creating an interface that makes
things worse.

It is very difficult to see a reason to pass in two variables (modes and
ioctls) to dispatch to the correct function in a struct that could
simply point to the function in the first place.  If we can avoid that,
then it would be good.

Looking at the example you pointed to here [1], It appears the minimal
viable product would need to implement this:

uffd_ops = {
        .get_folio = <>,
        .minor_fault = <>,
        .atomic_fill_continue = <>,
}

Then shmem and hugetlb can define these and end up calling them in
today's spaghetti, but we are free to append more uffd_ops to reduce the
spaghetti later.

If using new #defines to clears up translations of features/modes and
ioctl codes, then please do that.  These should be removable once the
uffd_ops grows to support all necessary calls.

If there are places where you need to consult the modes/ioctls and a
translation does not work, then you could add something to uffd_ops that
is NULL for guest_memfd and use it to determine if the code path is
valid.  But this code should already exist for the other memory types.

What does everyone think?

[1]. https://lore.kernel.org/all/114133f5-0282-463d-9d65-3143aa658806@amazon.com/


