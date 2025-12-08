Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7201D3B7DE
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 09:46:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCAA06B0008; Mon,  8 Dec 2025 04:46:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D54946B000A; Mon,  8 Dec 2025 04:46:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1C166B000C; Mon,  8 Dec 2025 04:46:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AEC506B0008
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 04:46:20 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 26A36C0A5C
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 09:46:20 +0000 (UTC)
X-FDA: 84195823320.24.046B42C
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf08.hostedemail.com (Postfix) with ESMTP id C8777160015
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 09:46:16 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=PiKnUqyb;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=qmPe7imx;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf08.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765187177; a=rsa-sha256;
	cv=pass;
	b=EsmfpF2LaFBcweIRho/vwFD4UFqrBmT9ggb018GNMxVp9bTtu7xAd/o899URU3QY9GLbeY
	W+y+UV6CenWFPCJJgeiUtGDciVbKW/J5lQ3f26no67YP+GRI6XNx9rLHSfTQUs0FVKoyX4
	uMcTfU3UExP/Cs+h0pzkHlVsaN9G/Eo=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=PiKnUqyb;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=qmPe7imx;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf08.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765187177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=46g57orQdT0aAfPIGnKSRQJOcVW9cAixsYamF8Myxz4=;
	b=SDlIVQtAayrSeIzLLKP5ilGG+w4F5ke4WOa3RLMPdQWtwx2qiBqdHeMuL9oOq4OZk3H0Rk
	THteaUFwCtD07UF/7T4chgfFvko6OqrDS4vmwBo9gKJDkcknsW4PKy4pfmsabzcbljSBC0
	BytZND68r6i8dr6sJhDjrf5ln0BgAyQ=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B88vHVn2123563;
	Mon, 8 Dec 2025 09:46:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=46g57orQdT0aAfPIGn
	KSRQJOcVW9cAixsYamF8Myxz4=; b=PiKnUqybRjxNwKsSbk2W/N/Q8rJa4S4b18
	9hSrdUW3nGR+S+27EIeaV0GuAIRuOouEOXNSVfoqwTJipap6lO9NqRk04+BjkCnO
	EUKqfyjgQBP2e/fx69lHsS9uvlzkuC8dyo5/IZvhxJzHgY+kberR/36PvZ7Uw/5R
	ijTLeOZKhDdDHxKfLmjH1Z+T+5/g8nZGtCJ1bn64CnjBM1ND1q4K8EeACsje3F1D
	tign6BB6ftAydmbbcT8eNwVyVbSuhA2/pcmRS3S4LtZgYEE69AMByICVg1Ns2rLv
	XrgTMl702D3aFAzWUYHmW+8d355YhVZqJUUPWE3OFCuvX+CPiUZg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4awukw821w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Dec 2025 09:46:14 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5B89U46v020900;
	Mon, 8 Dec 2025 09:46:14 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012012.outbound.protection.outlook.com [40.107.209.12])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4avax7hjw6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Dec 2025 09:46:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=drIKx/l2/22NHkt54DgIoWU7xyBGzYebMIpeMH7qb690PD+tCP38G2MCJn4gXAmuJGxzytNwgFoO9DUYspurcs2gBhNQYRmn+PVfmUPaPk6qRcTE3e9CmgnFL2lE64HPKcULplfraLgcfHwbUpIoZe2qgr5bLuoc3nuqk8/xEMy10zY97xll7hPHST6d+ZynpzJGWYcD9NKEM0CpZ0p7wo51mcToCdmlH2V7rmaiMOyFiZeV1eNyQPM5auPAw4MVzfpnrg1kpvnUkJiyVFWuWf/1cWUojH7PLRc4ZncoHpBN7Hl1a0fBOrKKDO9RYATkn2WB1jzsQ1T8ecqhQkmNpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=46g57orQdT0aAfPIGnKSRQJOcVW9cAixsYamF8Myxz4=;
 b=WM7+LmMtCz57B90Ek0NBhBxB8qm7j+Oyoma4pbAs2VEkn8d2xNm1Wj1/qHkUXpDUecz29jqKJHZq9r4s5XzNFvZlBi4NdWLqXmqBXArvc8mBeAzsnAaHp2XH08Lf4SxSG8GkEwxNbOtI8AeVJEZetF775KpXGr3fFBaUBnZIRd9h9W0DIVv3AdmhutYQN5S6vib+r13M1Xm+Ed+XpfNfWiFljT8mskJ5BJlMkSf8bqo3VztstX06I2Qzr62iuR/dCoH0DMt8MFBa0FL/7RDc219uEoqxTVWb7MdVqSRZ8C79Lzj99VcXOysy6+aSfCxtWS8YbqHmnum8DEKlhgRdGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=46g57orQdT0aAfPIGnKSRQJOcVW9cAixsYamF8Myxz4=;
 b=qmPe7imxO06+cCiqxB9vOeR0/KmfMzeV7jOUKlnDp0AKBDrMax3A9kri1NpULc354ZYF0riNb3xmmdhTB5skIxK/wZu76Y60TONR861m0ZKTPA3rZ1X0VRDbF6rJnO63zpZtaQejrAPqdHMbe8+xJa/JYwRGZ6yy8IoIHyrRxjA=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by SA1PR10MB997580.namprd10.prod.outlook.com (2603:10b6:806:4b9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.14; Mon, 8 Dec
 2025 09:46:12 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9388.013; Mon, 8 Dec 2025
 09:46:12 +0000
Date: Mon, 8 Dec 2025 18:45:52 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, vbabka@suse.cz
Subject: Re: [PATCH] tools/mm/slabinfo: recognize --partial/-p option
Message-ID: <aTaeUEnPFIO0lxWX@hyeyoo>
References: <20251208091018.2701315-1-kaushlendra.kumar@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251208091018.2701315-1-kaushlendra.kumar@intel.com>
X-ClientProxiedBy: SL2P216CA0189.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:1a::20) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|SA1PR10MB997580:EE_
X-MS-Office365-Filtering-Correlation-Id: 176367c9-0beb-406a-d237-08de363e9f92
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FWf9Z9vP1CrfRuTEIWnX5d8229rQYnWrUSlBtQuDJBYEiYS1jg8TBwOGuKw6?=
 =?us-ascii?Q?eNIeuclELf8I4nq6Nrb4T1n9kN21oa7i16pbn6JSNohk0+QOxmQfzrXHK/K1?=
 =?us-ascii?Q?HrL8E4uJ+wnqCQoZylLT9xVqXku/CbvbftjyBmhBXRxrhi0z37ShjdcVdHhI?=
 =?us-ascii?Q?3DmTT8y2B+LirAhXVMvWK46qxenMLJxPz/dwNsdTqcGZpGnWkevnz7OTJHOH?=
 =?us-ascii?Q?1p7AmaXIvFS2haPRSjrN+EDMQ7dQHi/913E+YdSVhruBaElLETohPWTmdtgZ?=
 =?us-ascii?Q?chuFk2OfvdLaD4TN7NUhIvZvSB4VWOb9eaMICWSmdpy6mWReiQBecRKfyapx?=
 =?us-ascii?Q?YqByXZFiWfoBec6GYAtz1Q8m1iG0AF8Lc70xE+wXhcfRxJ8uVFTZ0t2s/r3F?=
 =?us-ascii?Q?zZKWEl4dFKkE1YFtaJUTp7TKsF4mNM2WPFUWy1k9nkwmnus/tHImfvxLB8Zt?=
 =?us-ascii?Q?VWseLukpqfBShAVbfhhTewu2AKWV1wri91SOV9hlNPXKioVLrUjWb8aY5VXR?=
 =?us-ascii?Q?BUm6QnwDUb82XtaMTu3ISma0asQWl2lVkN8ouuaF0XgFwM59rNJE6V/hB5il?=
 =?us-ascii?Q?oGKDJ+86MeX45vo66SSYRNLksQxFtRx2F7qODyMN/LThJ9yZItcqMDIhj8ic?=
 =?us-ascii?Q?wmNzzxuU428hZuSWg5BRddbRZ/KiAGp3iG5ytZOfmM29Qb8bTt5KhjFwQo6J?=
 =?us-ascii?Q?PtapR+LeU9pmvbVUVKWzxsz2OKqyfgFjSQ9UCoV/gT7nWKbKNRlIn6lWKEYU?=
 =?us-ascii?Q?+HHJcxzI/Ahed2IdA0kUIARQLYQ/3R5Une7s2VjslMjleF6Ch5a4XAnqQSTc?=
 =?us-ascii?Q?7oTF+66N0SYP2p1xXtjS14EkNX2TcOyz2Cwwz6ahaCgnY6qv2H3oLzPKWq0M?=
 =?us-ascii?Q?4kGsVHVsZgObx0Rae2JbJPmsnEQhx8Z56FGOhi9RwN3+qOXZyXRplbII8AP4?=
 =?us-ascii?Q?WwT4+ul4dWzcWD7SpslTqys0Vi0lTKjOIhZsRuN3bByxZrKCdJOg92JLxMFj?=
 =?us-ascii?Q?e+ytOkN+PsfbSgwrLV/uhrzS6LowIddxarcVk5ZFqPKZoMDc+Kv0WbULofX6?=
 =?us-ascii?Q?nlLmFKaQafyRHACIoGoQuW+SHoLxFsPZqvnLqr2xu5OK/LXw0VFOpxivt1To?=
 =?us-ascii?Q?zxdknYFHVVHYulJGaFPXUMGM+DCls/4Q+C+2O5SXCHf7DO3C9Z7cgb/f1vYX?=
 =?us-ascii?Q?2o3wU30+DNoP7k12lePtA0uXbL9zilfsoIM337Se9JjW6KjfC/4vEqYKtYeh?=
 =?us-ascii?Q?pefJHPGGCoEQGW85Vj5bB0sEXcQvoWKM09tcrc70s0qkwkQwiGLpXRZAKFYn?=
 =?us-ascii?Q?gUoeXtUJ+VVxYK0/a0ZR0TeTYn1weS+/fn6hO4czqlWm4uJn8O2P9rXqsjQj?=
 =?us-ascii?Q?C7VPsUpln4V1+kJ9Rr4cTnkvCPBofkL1/IAK49W7HYqdn+YK3JhKPl1rKVhQ?=
 =?us-ascii?Q?XGzSz9HI4EisF2FAXii/dZv74DR8kdUp?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+OtFBed3Hj4H9jUfyJBvCyaszpoDi2IDIQveT//Ptb2AyTI2aZQcKZ+V77vS?=
 =?us-ascii?Q?lIOmV003eLx94U8anr9TO+AtXdshV8iR3xTdy3kyingj+hb/kXLFkWlVLHw/?=
 =?us-ascii?Q?vXhCoHoOZERVx0wNpD9CZYCBmwTyypR+ZOnUESxxthHYvkAuMr35FRlstY55?=
 =?us-ascii?Q?3+fDlMvHAHJSIYGReon76uUX7IVsFabcehsmaBqHDpPlA128fLh8BfEE4WZa?=
 =?us-ascii?Q?mK2YOEoUyTjYkc0wK05prYIyk+npPkMUF7EP38pJiDVgEHEDrvwJpgCqConm?=
 =?us-ascii?Q?G5933szsrcfCz9UeD64SJegz3Fa5XvzWi365LKQJt8HtqaUOXKw0p9+4FM2u?=
 =?us-ascii?Q?3Vdy4FZ2H8YKxiCpZXgkGd0cdiPzMDtQODCLekKqxZ9hAmPhtm1LumxlB6Qd?=
 =?us-ascii?Q?i8uFsxDgm9pFH3mUkoRs6nmnl2ItI1qXdxsNW7IrNillXlFLj7JziNFA5K+8?=
 =?us-ascii?Q?aNSXNQiT+M2OtCJNXQnW8+Ro9gXVsn8b7377lXljqPCZsSFKkE0pqhvpbQi+?=
 =?us-ascii?Q?PTJXanipARhUKyEYFcS5XADTlVqDURE+xInMYIgbocwIyIQFJukWpdaGqN/E?=
 =?us-ascii?Q?Rgq4UeOhQ7HTW1cb9fLsfgSeDjIrrmj0ssBbCS9ofqqDLIrCH2h6zjdZrNxj?=
 =?us-ascii?Q?v3iZZQdLxaq89ooyblsIVMgubfgvL01UJyzn3LUGkrg/5cCdgVluUd3YcRZr?=
 =?us-ascii?Q?8CzZ2pK46RNy94/I+Edj5ENxifOwFPsdTZj+bylUK4sV3HI727dw+1148anq?=
 =?us-ascii?Q?PeS1t2n62BWnn2+OCFRWouSl2jd82UuQwOzFMqENkrXQz9bQqQ/rdc2ZLMHz?=
 =?us-ascii?Q?WtrCgIUAXpN/G3NHcXWmT+JYJlxMU4Tujp1P5xki229aFwYsT6Ge80rq02RN?=
 =?us-ascii?Q?E4KuFYGFcZph62tDc6wnGeCKtjdeVYQtYJjuw9yRHLaQ1yBNvnvOdhokNAmI?=
 =?us-ascii?Q?tm3yKJQcKVdqHBJyb5+a0zfmMeU/cPYG3/3/cz0H40PBy3nyjTrHe7ZIgmOF?=
 =?us-ascii?Q?UbDf7fJqwTpM59AQSkefQp7LGa7uA7U9kp6CQ1IUNhgGPNonXtpYQTl59UF7?=
 =?us-ascii?Q?WGt4sFvW6Ru3t8w/5yyTOJHv+ekXmrEov2Ju6ozg1EDxXweDkI3ruMrHIVoJ?=
 =?us-ascii?Q?xMgdfCemxEjCJHVAj3MgfNmFdBQWASIyngg1AvV1ANFJfaGHcpsRommHygFL?=
 =?us-ascii?Q?L7lQ6gy4n3Lc5hTHocAJofdhyqZBbbBdpQEQTuNGK3Wu92gGtEZnAca+KyRx?=
 =?us-ascii?Q?1BTPcvKWYEsbypvcK/FAX80pc/Qwo+52AMcoT/SDxJrF24nPzyklul35J5tU?=
 =?us-ascii?Q?VpvV3JEiv5FLmt1Nm6aLgpmzGTEWLUvjsdPbJ6IBcfSiGLatLXu+tckBL7gZ?=
 =?us-ascii?Q?Sc8PX61NqoYR0S2IgGiDoKXa+SpdqwFY5kMSIW8XwETx0XRs7yIXKnC6VSzX?=
 =?us-ascii?Q?NsWmnLiwJdtaNaHi2e4i3sakudltNXLtuDG8qMyYLqDTeuqPfH5os9uqwlsj?=
 =?us-ascii?Q?rsKFhVimGVTqPw1NF3RdiDQX5qIbuCru6oqzmOWxNAzxVATlMzvGT1yDCdPk?=
 =?us-ascii?Q?hnXiqN9lYAMhtO4S/nzZfmzWP/7mTuxsHPiA18UP?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9Sl1JElm/tz+Qf92iHJypKV7bk83bkPTYqoq4fVPMwq7EALJyiCc+iSkSKX3wLPSZqP8Iqo78A5Wo6CK+nLUe+uY51OHDs7xVkZaSQ1oOLapw5a8MLHckwcnQFivyvVhp/yOYzMhXiRQScbwWJcqejUooMPHe0/dydlqEBguLC9BYEnLN7SUapLhSLspgnyUHxcx6GX5mH6sF0Kk6vxLjET04x0KpiDJlidtO229Bx/9GbADiEd9YzC+AEx9siyHmy1MwAN3M1OYI0au2HziPLh3QgaCFvP9laXou8NmgWz+2aoSIfAVO6L5pKO2YchqPmQMzi3Uq8NmzzX9BDi9kpOrAEiN93L5oS41jcvv+kRE82MMrwYVh1t0NfHkoMXSFnMhl3yLABv2CiVLewT7WaCLLaqRz//wqhPwAS11B7GFFHu7uEorWCTiS7tTspiK1Ua2Xs74TzsPxwsDtLX7nHCtucqY0JVUdqAg+qA2WrWmc/GM3Vv3wn8PJblnA0Z1jK0MwVg0vwRf6+8X4b85IokpZ1pJElDvH6tGd5roAp9A+ZfwgzS787Zxyueo+8q5zTD5riV09V8F1SmPqTcYAPFcM1uWL1i/l8i4AehwpZY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 176367c9-0beb-406a-d237-08de363e9f92
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2025 09:46:12.7354
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tt6Puo9NJZqU2HNeWGKFTF+Ry88DuOuhBefPkZCQ38abaJtoQskdDTNp67LruUopm1TJf5VLPmnfk9UgncqA8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB997580
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-06_02,2025-12-04_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 bulkscore=0 spamscore=0 phishscore=0 suspectscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2512080081
X-Proofpoint-ORIG-GUID: occGXDP21zcjk3UJfZNo053Jkhs7ps-6
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjA4MDA4MiBTYWx0ZWRfXwWPHwb1aSQz1
 pHVx+iSF224FZs4DhCbrE1uFueMgcqGcw92HZRzo1FqMglONYy0gzHdqsFfPizkXqVGAZzgc//h
 xBZVg4n+EHFn9F1Yd3vLihEpE38fPFTwowHCO3oy0h1STV8w3VLIw7rNLexGij3HRplVJJPmeCg
 1PPeINTu2GZMfRwDE991FDkIZCGD4QjXZtGZBef0JjF0289ORI6uLWTNS6CE7QMf9bmQ7IrpwAa
 ibuvAcP5re9NEH3m5A6wvyqqsJFNpscXvnvP3q71B6SmnRaLmwYiFUfw1RgHQXTHe8xLtEKf/Zt
 KKd96D7Rb786fLB67sQUJwlGQNHv6G7qyoQZ7uSexFoyRaDEi9B7DllWTqc1NNsVT0eEIEkPmie
 JQv90ofLb61aGCWeVLTIYrOIn0vphg==
X-Proofpoint-GUID: occGXDP21zcjk3UJfZNo053Jkhs7ps-6
X-Authority-Analysis: v=2.4 cv=A5Fh/qWG c=1 sm=1 tr=0 ts=69369e67 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=QyXUC8HyAAAA:8 a=XG062h4mmmCNBh35suQA:9 a=CjuIK1q_8ugA:10
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C8777160015
X-Stat-Signature: b4yzdtonjqzy76oaua33zz3oqh7nw7g6
X-Rspam-User: 
X-HE-Tag: 1765187176-791708
X-HE-Meta: U2FsdGVkX1/cvAE7dYQswtpysomBYohA9o6zsaP3M4lUBozVszgLUmpUddohKf7PdY/grSbdyJb0xfQwb8/VyHsJ4m9BkptR1vd6qEYcVgialJM3T969a2Sd9imkwLFWQ6zqLQU10citoE0Of3A7wSYlhMFkciqLl+lOhJeHf/3kcYqQK4ofxb0QRgSqzI9L3cS4qhbOL8f2Uk5XYjy0/+CcR0tvIUzry7ei1XlQ/9bjIdP3VE0uDvGJQA2NkeR5HQmgWOpHy0eenqTu4osBoSDYCwTrGwy8y/wp7iy7yHI7smD3kF8ChEHlG5JP61IZ+1wIpRtgkqTxMqMCA+6qbIVwi20Z54kX85QW7kvic3mBlIFvzCxiNkwAE6oxJR7S1+8YAk1iY6QufeMgeJ8vrXjcZkQHsrawGyn1TEy6vLRTo/ZDz4tIq9WxspiySuzFUsfjsygG5MHDIs63ozWKCEEpL22Hi+XA85UcW3kMj3FnFmWxsIV0P0Mx5i7oibpSzQdROP3841Ya9MaboRwrcyN7ZZV6M6N12DWTBKLPiuc7dmaBu2jd0BnXT9famcl4e1KWKRL8LnuuejNqJYcXEWIEDDvM0Q/SBYNUKq876DD0G1XX3Uq6hM9x0wZUtCuLxV6BuhmdSOxg8kpDhfpTCvVZwTX+kBo8kJYbk0RFaU1bPDAN5H8nwe0/8pOweOlElTBdxC74Gu2+y6JNKcFxdjVuH3H+Y2wdeQUhvnSJxBuqhgYc3QqmMPZt3+XAyjMzmu3JUv3kDdeFSDEaF6dh6OibEvK06VyOcQ7iDrCaeE6G6WBZR4ecJ+yMr3kr/ZMYxf7Rz8Lq3CTiRZpkoYh8xexcd+0LuuhMHFe8mf6bZprHuVRLb7CimIfuxS4ue5t2tBgz9EzY+LigyiBNdRvbMpzWQHsq/+ymAlQtS5NOFUsi+rM7mve0g9XovuARzOmVzAurisTfQcTIzwl2lz2
 TjPlA1yC
 BdUvVDgawFhy4T7rGXRmkmRsMdvk6dgKWY8gsuNanAyV9K2t9O+Vb/wDrA7jRFW7PQ5khBPpKZk9qKp8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 08, 2025 at 02:40:18PM +0530, Kaushlendra Kumar wrote:
> The long option "partial" maps to 'p' but the short options string
> and switch handled 'P', causing -p/--partial to be rejected as invalid.
> Use lowercase 'p' consistently in the getopt short string and the switch
> to enable sorting by partial slabs.
>
> Signed-off-by: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
> ---

I think breaking an existing option -P is not a good idea.
Can we make --Partial work instead of breaking -P option?

>  tools/mm/slabinfo.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/mm/slabinfo.c b/tools/mm/slabinfo.c
> index 7c51d283504d..7f239da26ed2 100644
> --- a/tools/mm/slabinfo.c
> +++ b/tools/mm/slabinfo.c
> @@ -125,7 +125,7 @@ static void usage(void)
>  		"-n|--numa              Show NUMA information\n"
>  		"-N|--lines=K           Show the first K slabs\n"
>  		"-o|--ops               Show kmem_cache_ops\n"
> -		"-P|--partial           Sort by number of partial slabs\n"
> +		"-p|--partial           Sort by number of partial slabs\n"
>  		"-r|--report            Detailed report on single slabs\n"
>  		"-s|--shrink            Shrink slabs\n"
>  		"-S|--Size              Sort by size\n"
> @@ -1427,7 +1427,7 @@ int main(int argc, char *argv[])
>  
>  	page_size = getpagesize();
>  
> -	while ((c = getopt_long(argc, argv, "aABd::DefhilLnN:oPrsStTUvXz1",
> +	while ((c = getopt_long(argc, argv, "aABd::DefhilLnN:oprsStTUvXz1",
>  						opts, NULL)) != -1)
>  		switch (c) {
>  		case 'a':
> @@ -1481,7 +1481,7 @@ int main(int argc, char *argv[])
>  		case 'r':
>  			show_report = 1;
>  			break;
> -		case 'P':
> +		case 'p':
>  			sort_partial = 1;
>  			break;
>  		case 's':
> -- 
> 2.34.1
> 
> 

-- 
Cheers,
Harry / Hyeonggon

