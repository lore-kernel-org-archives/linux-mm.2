Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86595CA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 15:48:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 266AD8E0022; Mon, 18 Aug 2025 11:48:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23DD18E000F; Mon, 18 Aug 2025 11:48:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 105FC8E0022; Mon, 18 Aug 2025 11:48:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EE61F8E000F
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 11:48:30 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A0C151A09C3
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 15:48:30 +0000 (UTC)
X-FDA: 83790310380.23.A174AC2
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf07.hostedemail.com (Postfix) with ESMTP id 573BF4000A
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 15:48:27 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=fNf+6wpr;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=phL+G95k;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755532107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SxRj91lb2oYh1vFFXmWnFIpuX8F51KuTE9WQ8jOhrhg=;
	b=qzVLoikFYCp6TkqFHMnMX2h5c8QZz2gHX/OvYgrekI+aJyIyWdB2WdF2H8bTWoMv+VMjG7
	k+DYzxyXTTpFB81eAy+4utFF7aqXcZMeFPxY0WTuufeDwcKjrh2WARZWCdLZtL11Pc4sS2
	TYbHzXxEq4B767qDs/XRITSBfVCRrGo=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=fNf+6wpr;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=phL+G95k;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755532107; a=rsa-sha256;
	cv=pass;
	b=kTYZk0ONqjcloGC9hybuWBtmWeu15b1IwZCxUPWT0d17Z+s2pX8NplygaSPZIu/5mMoQRV
	Ltbx0ehEnWUrcgJ/D8GNiQLlDmgwDrtEYjw1hqF2UeALoYo1hcmQzWBoLjfRN5RyEHyP/E
	28iSh7zhJL/f2Cl4FtUZbU/nYbMfYG8=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57IEtnXU020147;
	Mon, 18 Aug 2025 15:48:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=SxRj91lb2oYh1vFFXm
	WnFIpuX8F51KuTE9WQ8jOhrhg=; b=fNf+6wprkkuCIEpG0zzBqZ1U+jgZoc08bp
	Kf38HASgvTrLwSR4NmuFrES1rCaKLXq9J1u5U9fS+4YPBflYJ6raJcpwFK4hRA+p
	NhrtB9lLLiQfKQh5D80cxvqqmrdx6jCgkdtnvTEyozu/bqxMZQN3/HvaIDDqrnaN
	Um5rEh4gJTBJNomIruRsXfovSv/1vpzPn5nitFST53jHFSKf1CIeXrWAxD5Ra8FL
	j8NxIBYORqbSkmg+wEIWEY9s89v5U+Tg8A7sybj3cIxO/+RIKBAKzJp3IaV1sC14
	mJIBT+Ncia5Xvbxf2n+48R9n47iv9AfKjrZErsbNREAsNqriJ1AQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48jhkuuccy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 18 Aug 2025 15:48:12 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57IEqaku011367;
	Mon, 18 Aug 2025 15:48:12 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02on2079.outbound.protection.outlook.com [40.107.96.79])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48jge9ejnm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 18 Aug 2025 15:48:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NAxFpN7xaxUl3tJPyYtRd7FbJfBXi1oZQFezzeyHIYxsRZVm2+KVMJJMlzEgw6jvDRRhY9c7v1k/gG4N30PMHob8J4jyHqpeWxrRGVgLUW8GFAge/0rqveTpWcjDLKylaKPnm8MZ61DkTEdjRhcx1C8dAclariRX3rvLi2sPqLPcqcxIJYvqggvIvAdhYHwnLe7NXhUWj7meB3yEM98zBqbpZf1mlTkatN2EBn/4KRHX4DZ3Kr2HlHJjr0cJ8f5+o1EONL93Q+fncS2dwi7/UgdoHhjeaXcQCPuKjBmDN3Sx3va03uPgCK+dGevzWqpK6ck0WVDNuF2TyNqouuKZCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SxRj91lb2oYh1vFFXmWnFIpuX8F51KuTE9WQ8jOhrhg=;
 b=X9dpYH6sPhmwZ5HY2aYGDqslvZW13T+pvp7warcn0EBca7hax/IOmeZyX+PzDC0+lRxQ+nhepibFKageUBa8rA7nZAKhdNW6c8mwyVEMG4zz9QSq+Yt3mM18kRIlXix7ebdL7ARtq9/FXfjrppPi3Ahf7LcwhJQZrG8jjnpxC7xTyVZQoE4t1/0A9UEXaXgdRZWRojpYqKD9d1SDitmXi7ZQGS4kPpGwQesfEq9O+fI7iaXd788HqYHUXjuhDDWT7+oPbnqxY5KLe/KITRMLDSwPI9j6UI5X2Ej6L9wL2TumFUIld8L0EmvCj+cAmA0VlZ339U14h7Y3XLOsreodFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SxRj91lb2oYh1vFFXmWnFIpuX8F51KuTE9WQ8jOhrhg=;
 b=phL+G95knwVZZxc61Gdx3TtsUupmMMCPI/vte/Lhd5jHQoFnLMMwfWLgCsY3FgunPIxueyIoyEsyH9RbYPQj/cdosQ935Q7jFzh/6Ru2bYG76GDUKhIO9PxwaHFKkCZlJZipaTWnPdBZM1lm48aW9gPkvKQpXey0kPFqdVq6KCU=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH3PPF67E073224.namprd10.prod.outlook.com (2603:10b6:518:1::7aa) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.23; Mon, 18 Aug
 2025 15:48:02 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9031.023; Mon, 18 Aug 2025
 15:48:01 +0000
Date: Mon, 18 Aug 2025 16:47:58 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>,
        Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        Charan Teja Kalla <quic_charante@quicinc.com>,
        shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com,
        bhe@redhat.com, baohua@kernel.org, chrisl@kernel.org,
        Matthew Wilcox <willy@infradead.org>
Subject: Re: [RFC PATCH 0/6] Remove XA_ZERO from error recovery of
Message-ID: <1e26e895-cad6-4920-a9df-21619777d25a@lucifer.local>
References: <20250815191031.3769540-1-Liam.Howlett@oracle.com>
 <3970cd97-2e9e-403f-867a-3addfbe399dc@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3970cd97-2e9e-403f-867a-3addfbe399dc@redhat.com>
X-ClientProxiedBy: LO4P123CA0180.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18a::23) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH3PPF67E073224:EE_
X-MS-Office365-Filtering-Correlation-Id: 297973a7-2baf-4c57-a8a1-08ddde6e9cff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?mRYscFMXA+W5gGwXGAKCybNk/tkZY0nJzZ6MVJbavE5TPYj+haCrGxyf8Uqh?=
 =?us-ascii?Q?DNqL/gMNExbCXMPaayER4K3HZ+q80CRoJUxoL1s3nfFqjX+EHbQH0ATKXGFi?=
 =?us-ascii?Q?Z7p6iVaHah3S4VWQNpEPjCPUmT4+QOiYnVL68plMcXNkx8WmEg6mMplO36Tj?=
 =?us-ascii?Q?xlNt6udr+EZIk9IQv4pnwIuQavvAz5oq5baeV4p4k1o0tgR1qi13dQ33SF2q?=
 =?us-ascii?Q?2V4GjPqbRqMV+EG2Js7W2g6VD9kjtPFBSinHXP/CYYyoHKEUrs60QzZGRyds?=
 =?us-ascii?Q?2soPbmaUivR4PH64QF3Q+gPqqnZAjTGNkelcJRY9U4Q71KWdVplgsKi5KGYZ?=
 =?us-ascii?Q?CWGfyS/DzseMY9OCE09B2Esf7fKOPc/ie6XNX3P0zM91YI1+OrCkbtG0qKAn?=
 =?us-ascii?Q?324XCKUTV0yVVdH/lpj0eEHt62M4IadjBsTJ2xBnAVIbqz9u9o/YtkZRbxA1?=
 =?us-ascii?Q?Y5hSDuEuAVd98cOSbK1rLygM3J+26TuGtObMoSjHV7io26vzUY8hiDOwNR8E?=
 =?us-ascii?Q?1bRSUA/M67HxpMXBlpPjt+CSIjWmh0rONwkMShkyN8uqP9lcXG9XiJlhECi+?=
 =?us-ascii?Q?bBUc07UFleVkeIX23uXPv5aTHjX3ohsjz/CsQl2MEqNrOJUCixX51rd1JCXP?=
 =?us-ascii?Q?7XICT2C7EAJRrf+6m1Sqn0pAWq2TPSjJt0U1anGPJf+O/i27dIgMqKJSKcQ7?=
 =?us-ascii?Q?TSFaF3AR0B0P5wOHda07scyvOw1J4AxprZl8+zWpUVpaOhVPKmoH6j01grf1?=
 =?us-ascii?Q?wC0UaLSYtNUMRCtYNh1/abh6fWRVdYVttYkVBBYbDZvccE6kBdMRRKCiKf+7?=
 =?us-ascii?Q?CUE9OLf80W5OJoGHG5AZ14FQsFyviH6bjry/xCzHSCpRVwHJh1xn8/MO+Mai?=
 =?us-ascii?Q?0IV6BLJjPGdwVBZFXaavJIgxz7ywVRH+VmwfU4xTaQlIvqGGfBP6rQGbZKa2?=
 =?us-ascii?Q?9Q+J3abodxRNWLib8y4/64eoOzdv87SP1RgrzJlAVMj3ImtW3DiOWEiJrt9I?=
 =?us-ascii?Q?eqKyzn+2mS/kz4GsgwTmRW6WcmlBnsRzkGwbReEffqmR4skzTytvPf9skcOK?=
 =?us-ascii?Q?7Gu4GDHjWZi89TQ8MRxIiuRMJ9+c9dkpOMLyLk5OaSUwspQ4muw5cfzXVULy?=
 =?us-ascii?Q?EBKp7aj6t+V5qRLZ3ucgn4Uzf9+5FKJaWNjzkS5S4cU2SvKueq9aatlnDRm+?=
 =?us-ascii?Q?yB2c7FrJeIX9fEQWb0GchywrBBhrWT6RKFQGUxJ26BrjbBJ2NibOYE8Zipuk?=
 =?us-ascii?Q?J+kkKa+syRilnXO70Qmr6mwDI2Y4DjsINcNA6CgT61q4dr10IcU49fIaFaV1?=
 =?us-ascii?Q?DUeLkz/5CN6ksFrkWztRjLp91OLUkp9VsZHblHHURvaNX8mHNNB9bEzVTwJZ?=
 =?us-ascii?Q?TK39NnI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?uq8M/xBqWlRfID5n2KVRfttr2Bed2dZ8+7PEiad0PX/aYk3CD3N9jJ/V2JKQ?=
 =?us-ascii?Q?XQGZiw1dy1mMEg/F5BRyXnSQqOXFJ26nwsFgJ6EyBmdvQfOjxsyFVbMxbF/w?=
 =?us-ascii?Q?sV+tgVXjJVgbR3g3awLuYZ2j4huAuw1s/pOxEnwTzAw1xae+wNbAEb1u0uFz?=
 =?us-ascii?Q?yjmi7K4JNzQw5GHy1YEDWWcID52v1FyaMBDDJCKY5HNjPvjELogYxe6lEsLU?=
 =?us-ascii?Q?gYzFO+ElEypbNc6pCJtGHZzWTbo1DDeWDFOvYcpPdYNHVJilSzAahMhD5veX?=
 =?us-ascii?Q?sm5NCE0WT+XLrG3EuIzFffG7mOwKfkHsnU8HPyJW5lf4R2hfCHLX1zNj9Pny?=
 =?us-ascii?Q?1HIh2+oS/G9RbYb0NJIL6QuByFPZtveqO/x+SHdUr+oEcjwLbFmysgNYeiGP?=
 =?us-ascii?Q?T8dGNoDo55RaDBAJVucYMk6B1IihGkNJ7Q5gJK14LHcgFQ6BtUq1NfgAK4wY?=
 =?us-ascii?Q?lR6sKINSga6mwj7xn5DPEZsgDiQElGAZZR1TmlR7+Lk8pMgyDR7uMbnM4Fng?=
 =?us-ascii?Q?fDkdRU62NK4dDLVxh5htVDi/iYycxqVDob9MltMWuIoH84jknn3nWhGrbvd/?=
 =?us-ascii?Q?T0MpLWDiDA3vQzGrT18ssKXDLlCPtHKbp4ozewewExPBFlle3n0SAOw/w6yU?=
 =?us-ascii?Q?s1hbhrd2i9xQYT45g6k2j2bD8RRmmkJp9dziYzz5GHZKCcBIiV2lOIjY+CII?=
 =?us-ascii?Q?1d9mkmM5cvkInbw7QBq4FC2JYR/nCCwGshYIpCV4Nj0iK39+BanGzkm2J2UA?=
 =?us-ascii?Q?84V+dpcQ1kIEEK4uanEN7qlvfs2ezzQjGQWne14ITy3vjZc/4E0Wdjv1B2NN?=
 =?us-ascii?Q?470oLtPNujRUO1vMW405f9u7cYbZE+vWIE8n7HJASTMNieyAJVrlGBa30Ylw?=
 =?us-ascii?Q?FbOKX1WJrAcpNET/oe7OosFNFPrlpNt3F09hgbAPHwYnX9SDY5HJ+CpDJtj+?=
 =?us-ascii?Q?Ge+ij19Ark3C/wdUezTV7LpkGjC9RE9SrQDheQw9ssQJliLTJlxeDw6QQQMM?=
 =?us-ascii?Q?1hqxPawzoKltS6ZjJYWJYhNTO0GLe0vgi45dfjY23w7sfVrxlkKSNgoJop3u?=
 =?us-ascii?Q?2YmVNXCdewg9pL/bNihPxEN/VLJMjLdts/CGQ1LFX9CyOD5Kju6UomU4T3Sh?=
 =?us-ascii?Q?9r660m1ndQjI1fF2z0hKKy6IKrELb8bRD/IvOCAqJqhNlxh56ruzvDpfdk89?=
 =?us-ascii?Q?ld4jt+u2qz8d8VxAqrsFcwtriN3hjusivGVTwab3PsDZ8JdbuZrlQmm6dXw+?=
 =?us-ascii?Q?PTYvaKe7Wrjuk6xVJqbHl+F9Sx7NO+rVJlg4Z7qASWSi0LiWtdXJDQxVrL95?=
 =?us-ascii?Q?hZczt5OVw8QaX9agA645XM2MAP2LDB0gv3QpP2FT4EH+0Nr+3JPj7u/PD+xw?=
 =?us-ascii?Q?LWv8EcJR/aExyI6zM/fDAvX1N+TJaqHBbLHL1LZ+bPx3FL5sEEjvT3Bw8sFJ?=
 =?us-ascii?Q?AXdHBUtA4OIkh07LUNxPasWTS+BwD8Jwl+/BIYI03NvEF2xwpsmmAscpYhG2?=
 =?us-ascii?Q?Y44xQToibABZ/5kPHF0CVTwMfXNMyL2Gu/+TtNPM0vYUrQi2MpygY7cYAado?=
 =?us-ascii?Q?c7WnpJi0PxpYl3BrThjHUn1hCkytML2bMTluH/ArwVhkz3C7cjLHnwfXF+14?=
 =?us-ascii?Q?4g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	WWv4Kzsv4ZxHQP3OlbPMMtnmHcxykGX4BCOIw+1N2RDJ9TQGT4b9k72ZWYYP15+Focf02gZi6qmlf4E+hLv+yRUKbRJZyRzr6ipVl5k7EtF6fpN7+xpBM7ugk8uLcp8b1LYf/0Ejx+1G9Yo/CzR1JRYW2U6aFBWoxGpTOoRmz4NdsF/b/CGGGRG32x4CChAVu4AqDMNADLew/jX+a2YnuTU7dTZyBdz3h2PnAqkFyhcdOvWwnMjcEeu6yUHaRMAT/5EgJtGC4GuRXiLa+vr1ylT0JH1c1IB95Rmc3fKFoPgOXyRWyNgLf5vmKo9FAruVBMaBUPyACHVQTCtkgX99Mq2R/Bz0EzRY6cg1M1GJkpc4mFzyY7NnHBlfVs0slyZ5XZ7yfDWSIBMa1vOh0Zh/0oui/OrtgJZHj0n6tsgdVWrsWpVT837nXSuE56Yro024zZXyjinignQisZC1zS6UnMle2O1Yl6tsey3fY+XNjgd9vp+TKx8qEUzx3faM+vpeabtMKncC44wj9GG+f452tG5ZLW6jZYXhfzmZT9X3w+8XGl1pY6QDiQOZoX7qcMLAA//TvrCwlx2af6FO4FvGUH27uaX6+f08FSitSNwrh1k=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 297973a7-2baf-4c57-a8a1-08ddde6e9cff
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2025 15:48:01.8900
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XaG2t1tcdhaX6jU668E6cH8pqm3Q0/SkF0I8PLtDK6dxe6A56nIoslIBCflqAv8ek4YYcNVfsOw2maSeajMFxN0/6wiSjv2e4vfzfE6heg4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF67E073224
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-18_05,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxlogscore=999 adultscore=0 phishscore=0 bulkscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508180148
X-Proofpoint-GUID: LAFjyK_4w-bm6RmskUVEEoFgPIVjCLcr
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE4MDE0OCBTYWx0ZWRfX29O8WXjHiuY5
 TUFf7izpBpKbPwOQwVeNm5U9W9/w6gxlNA+gqGbReDVn2ZIywIfXUL0xwGUhfJZ5Z7IVn6EYhNE
 JDpuslq4GP0hfKN7aDEE6Vf+yeXFG3Va2QVgB76GagAfRXRI5dSHtTwwiTS199Wcoio8vBXllYj
 Dp30uERKARUIVLD3/vl8fuO6OchoF5E5S6rHcOtZUR/lEospBvO8UV8w91H/77ZY6zVLiUvOcvC
 tO60K3lsGIXPFSl/q/bn+wRFIFLZ7BheZHwS3Y9Vw+892h9j/fnA9gGijwko2X3sEaqt8zyQhQc
 bZ/F+bE4gWU742vnmBJYXNCFnkD+Y1jnEbMkWTN2W7Vo+G0TTgB3fwRBNUnBq+NJpByiuB08L48
 ZhUaUFXRL3sya5UJiAiEvn6Wh06HX0uFhhFk2sR0HkH6NSRRGgXGw3IFI/wDYpBjZLqfVfJU
X-Proofpoint-ORIG-GUID: LAFjyK_4w-bm6RmskUVEEoFgPIVjCLcr
X-Authority-Analysis: v=2.4 cv=HKzDFptv c=1 sm=1 tr=0 ts=68a34b3c b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=COk6AnOGAAAA:8
 a=xPrUTxJFcWhoDamw8IkA:9 a=CjuIK1q_8ugA:10 a=TjNXssC_j7lpFel5tvFf:22 cc=ntf
 awl=host:12070
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 573BF4000A
X-Stat-Signature: em8yyof9xypa7cqm8cxhq1xd61zgjw8a
X-Rspam-User: 
X-HE-Tag: 1755532107-27456
X-HE-Meta: U2FsdGVkX194Fskl1j6Y4ZXgl0tg1ou5iHm9Cu3nqcyZD/t9fj0nKWWniRdI5gKIU2AL4pbIP6pyhBhLIzE/GpWCsnOCmRQKMY4JXDL0cGCby43/nfVe75EH0NFp/yXcIX5spQ5yzxa00HL3K7JRdwVFKfeCRr/DxzaCIyZFktYInpImbOnB4AGOoBtQZk4USMtvZxE63Xwfql5OurYuJ6qTYn2MxwK8CUCb8+L0yBE64fumX3oxdQGKNJMQDFLckV/MNXmaKc7+AV0T9eJ/QKiJObH+gbKdOOeuK+UjiHlKkIKyXKYDdJXslH0/Lh54USN2cPtFmboCmWa4/Og+EJzCv5oNeUUuXzCS2sxEO7HzKA4k6s89Nf/0rmjow5m6tcRdggO3IrCTevqLmK7dtgYQF9YZ6G9KTDRiHksP8hGGARdVG5bqEEN0GYfUpiT+Jf1qXKMXsGF1WTEpSli/jPWfBml9JvpUTta1pI0mJG1ZQ/l72I5ZkkY5JcZxedj2xitepGfC1CoHqu0bkFKm2KtWYjl/NCeS1kTyMlqYRuJE/jG+JoODNVDCG6DQWK79p3xvbXzn+NVXGXdDI3dmYecOVS2MVvMywqP5j9rYUHnbOcEQEv7E1VBdo8NBdIt86zGE7DQxuVOvVAP/R6Icfj7cVLv10xJ63cM+BAAqxhlH2+RFxMXdqRZmNObTipCFM3pEA62+RyZkYegkoBJRboVbXF7GUqKRaRvcU/zjUxzww23hsN6GLQ12UdqwesAtyIE4sBEO90RbUaDMmUoSqFljcKDjOTFv4cfbAPVm8/VZoyivffViNA5/8dmnx4NR84VLJiF7DRGjpsAqWr7dDjZ8fjmqmZlU3CdjP+MkbXz8WsKavPqguZ9ukjpzHc1yI7XQwwmF029g5GtLrIuo1OKar5lHhj3500uIEEK6TR8HV/nNv1ZOj3eri6Qq3U08qRxVe73X7QeUB9RfM+d
 u3+r+kq5
 07GmBcMW+KGOX0aiINe7W4z/m232yycUyTlFCKFCYdcYxkM2obRbwZV543oNOykTyalf5Wu+tq/EczG3KVlYsdxaRXm2Ld/ob+OzmJjBYmX4ckIYnx32hVRNCpsdQXaWOWlGKq4guLsCWQcE15eUKGJlBzQPCqM0GuVh/sjEAwCNYBRTrueLb8/9YZi6M6GcNjY0CnwiVVpr8yA3/WsLAltlQnCzkA1TnYbZyqyiZsH6vZCeVVs20SjZobMUddGOBNj9851mR62ASqxI0xtL9htRv7hQ7Cdq+MD/ZksdfDbEdGLpKYqcCtMIiwH894eAYuiQ0eN2YdnafugYlqWO+jhBr5Vv7eHcwmM6/kSdx0n4Yie0+pQvt/jfpmimQr5CGKxxT7RVW/1y6rdVTfWUdJ3MkrXj/euet70EUFZGYjC74kQMI0CEdHOjWj0hChrznzynPZ+Q6gHF1c4FtyJJdVuylDDWsxlMjrJsL6lPzLTZP3m9oBNr1SiwXtn9yScGrrzIe2UuaJuSwZNVaHzWOYi+m7WLkvHwx/5o17DJSBbp1Fqfn7ug//MsPqONsV9lCPfGx7V2vAC5lg9OBCDmM2e+Dw1QhioeZCP7b5KOmjDD3Gk2S6AwrK4gYPn4Ah5RLR/4aZyxLmsRavHqc4qiErDpJV/2/SJNCBJ1BvxbtyAeVpKooLogxZDOSBywNwkFhbIKHjfrvFYbEY8gmkkxbPXBINTnnF2ff3ZIyyUAIiFNCU6HO1nLpKgvpdF/M/Q8dpyuGe2F5JXbX0mk8RijzoE6OgsktgatlqsQXeUM87KsVjt2DNosbwFF2e5UhJBhp7UA8+SVk4h7VyK672EM8Rkt1r7yZQlTNtEYxFwAFF3GSI4bdhueyCcm8rYvXe1RQIPcM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 18, 2025 at 11:44:16AM +0200, David Hildenbrand wrote:
> On 15.08.25 21:10, Liam R. Howlett wrote:
> > Before you read on, please take a moment to acknowledge that David
> > Hildenbrand asked for this, so I'm blaming mostly him :)
>
> :)
>
> >
> > It is possible that the dup_mmap() call fails on allocating or setting
> > up a vma after the maple tree of the oldmm is copied.  Today, that
> > failure point is marked by inserting an XA_ZERO entry over the failure
> > point so that the exact location does not need to be communicated
> > through to exit_mmap().
> >
> > However, a race exists in the tear down process because the dup_mmap()
> > drops the mmap lock before exit_mmap() can remove the partially set up
> > vma tree.  This means that other tasks may get to the mm tree and find
> > the invalid vma pointer (since it's an XA_ZERO entry), even though the
> > mm is marked as MMF_OOM_SKIP and MMF_UNSTABLE.
> >
> > To remove the race fully, the tree must be cleaned up before dropping
> > the lock.  This is accomplished by extracting the vma cleanup in
> > exit_mmap() and changing the required functions to pass through the vma
> > search limit.
> >
> > This does run the risk of increasing the possibility of finding no vmas
> > (which is already possible!) in code this isn't careful.
>
> Right, it would also happen if __mt_dup() fails I guess.
>
> >
> > The passing of so many limits and variables was such a mess when the
> > dup_mmap() was introduced that it was avoided in favour of the XA_ZERO
> > entry marker, but since the swap case was the second time we've hit
> > cases of walking an almost-dead mm, here's the alternative to checking
> > MMF_UNSTABLE before wandering into other mm structs.
>
> Changes look fairly small and reasonable, so I really like this.
>
> I agree with Jann that doing a partial teardown might be even better, but
> code-wise I suspect it might end up with a lot more churn and weird
> allocation-corner-cases to handle.

I've yet to review the series and see exactly what's proposed but on gut
instinct (and based on past experience with the munmap gather/reattach
stuff), some kind of a partial thing like this tends to end up a nightmare
of weird-stuff-you-didn't-think-about.

So I'm instincitively against this.

However I'll take a proper look through this series shortly and hopefully
have more intelligent things to say...

An aside - I was working on a crazy anon idea over the weekend (I know, I
know) and noticed that mm life cycle is just weird. I observed apparent
duplicate calls of __mmdrop() for instance (I think the unwinding just
broke), the delayed mmdrop is strange and the whole area seems rife with
complexity.

So I'm glad David talked you into doing this ;) this particular edge case
was always strange and the fact we have now hid it twice (and this time
more seriously - as it's due to a fatal signal which is much more likely to
arise than an OOM scenario with too-small-to-fail allocations).

BTW where are we with the hotfix for the swapoff case [0]? I think we
agreed settng on MMF_UNSTABLE there and using that to decide not to proceed
in unuse_mm() right?

Cheers, Lorenzo

[0]: https://lore.kernel.org/all/20250808092156.1918973-1-quic_charante@quicinc.com/

