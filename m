Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9778ACCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 16:35:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 044048E0033; Mon, 10 Nov 2025 11:35:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01B828E0003; Mon, 10 Nov 2025 11:35:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E25A08E0033; Mon, 10 Nov 2025 11:35:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C944C8E0003
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 11:35:19 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 77C95C01BC
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:35:19 +0000 (UTC)
X-FDA: 84095247558.08.C2B3BA2
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf16.hostedemail.com (Postfix) with ESMTP id 12D54180012
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:35:15 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=CDMs7o6s;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=iMVNLhgU;
	spf=pass (imf16.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762792516;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6wyQFYl7HFimEsC0OmjPyPikgY2E3bsBI0Z8K3VPmPc=;
	b=TOtGOSvMQv/ef/4ylCm0cx7wg2NIUsepYblVFrJem0vw8szQU8hWcTw2piUsNX91olpgwU
	mrsrAlifuHWwpUKrgNMBo57QW/qa6MKssgl7gh8srs0uzRHqLjqpA7WScbIBf13ELpmhtS
	CKB+EtBSxjSX5kKD+V5rb313Dq2o/Ag=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=CDMs7o6s;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=iMVNLhgU;
	spf=pass (imf16.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762792516; a=rsa-sha256;
	cv=pass;
	b=tLSkHT/bGustXzqJqz5OuLS5LgJXM01Jueeg6ueEeggzZZnNridcvAXGgsRTVnT2wvjPFP
	YcSQL4nNxhArlCltbR4urRju20SGGwfmbdKFAr3KvOLXiF5Viuacrl5KRUCBRhf13dXgCW
	2lqx/myIphPnZppFK4qH6mvGm4Vi+Pk=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AAGUKaf030958;
	Mon, 10 Nov 2025 16:35:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=6wyQFYl7HFimEsC0Om
	jPyPikgY2E3bsBI0Z8K3VPmPc=; b=CDMs7o6sSWKoonlNqiszK+epQmVKU4BYvY
	X1SP2ReeZenfu3x+tHYeHW2oFXbYPXCr803JgNZkGVe5MxELVikDK9G0aH+a+WQH
	ctduXFS3SmpCxhSTwBBRjPHnhoBsQjnY7ywFsIGrsFL96Uxyw5Jt7ig0kFp/3jOo
	BNnEbCnpKRWRmjWymAW6DNNTLhnDOwHA64gRDk8ULcIEn+8AITQT6dt+jZ8UHovL
	MFfhq9DGJdrD/dSRcZNtEsXim5U7By0H10f8dbjl/SVdBu+UoDLBWoZHAm4YoTLv
	wDqhtk3ZuK30iFYN6XVpSpVfhrBcuX5bn1NBYMN/YvWB8nCfpHxA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4abkmjr0f2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Nov 2025 16:35:09 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AAFjgHq012547;
	Mon, 10 Nov 2025 16:35:07 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012044.outbound.protection.outlook.com [52.101.43.44])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a9vabv6n9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Nov 2025 16:35:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aGD0I4P90ypAotF+lYYVwYQ6yHgXioIumN56W8YtcEFfkU2dAHJiAOQxHsg76x1XYRTlbglT1WiAMb/tY8yhpU74VqWKebt7GIBEc8BkR0w6W7k3elzU5y9Mi6tR6qkKt9lvtTA9g/KGMt4u5Rb3gu4HRh9D59fl6EIhuBtuCkNB0HUP8pgjZQyozEoZYejg/GCzP8HfXYP7EMNKGzIYjxzZED7oglM7SP1azJB3jYmhXA8SOo9JWmeuu9i346FUrzZhUXqSunLE9GZguShQtTdnAhD4zBVTpQ0UEGEaOmT6ryKCJ9ahMNjE9o8CQp1T2aY40MeQ0WNVKQFWNstWXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6wyQFYl7HFimEsC0OmjPyPikgY2E3bsBI0Z8K3VPmPc=;
 b=UXP60Uk060rRAHydwAGKhp9ZrYucO5aNUhiaqUwRKI5RXizWnPPaheo4+uqNTicXcHdEeFaZIwMIwkiGmKbj16NO/n+QAdKQvauuODXOVL/fc5Ikft18Vtjip6bBVyOI/PkGhRQhDGlTuT+y/fX4YP2yYQNoKw+sF8llUOablQ0vh0BBe2mHgluZA5Ed+Pej7R8WaWCuVslOMTMVG+BjqYeSmgdPV0m/Ud41ZQ20t9mOfN22oDcW6sqJM1RQ0QoJpcN1yoJ/0NqX+pS1lYwsf4bwWyLIoYVsGKGqRQ9JyNY2t2jYWs4YvrxoP6jvydPAp7tku7hOIg4/7UjVTR40kQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6wyQFYl7HFimEsC0OmjPyPikgY2E3bsBI0Z8K3VPmPc=;
 b=iMVNLhgUJr0sB1Hy/cWLjbvQkEDGInA38rBIjajtANZ1sXwuQmFM6mME46adopYn1E82trs76AsdDLBGHzxgfAV4D9L3gpLiDJnBxaB9nmfi+FKJdPA2TErHnjxFJ0PlUR43FouwCJ98HItHdN7aiu9gzn2n6ZPx4FtTQiuxwQQ=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by BLAPR10MB4945.namprd10.prod.outlook.com (2603:10b6:208:324::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Mon, 10 Nov
 2025 16:35:04 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%7]) with mapi id 15.20.9298.015; Mon, 10 Nov 2025
 16:35:04 +0000
Date: Mon, 10 Nov 2025 11:34:59 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>,
        Peter Xu <peterx@redhat.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Muchun Song <muchun.song@linux.dev>,
        Nikita Kalyazin <kalyazin@amazon.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Houghton <jthoughton@google.com>,
        Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@suse.com>,
        Ujwal Kundur <ujwal.kundur@gmail.com>,
        Oscar Salvador <osalvador@suse.de>,
        Suren Baghdasaryan <surenb@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>, conduct@kernel.org
Subject: Re: [PATCH v4 0/4] mm/userfaultfd: modulize memory types
Message-ID: <ulpftgdk6hgorwsrbtv2tv47b7usn3cow362knuxlzq2az2cl2@krwo6e3zxryn>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Mike Rapoport <rppt@kernel.org>, "David Hildenbrand (Red Hat)" <david@kernel.org>, 
	Peter Xu <peterx@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Muchun Song <muchun.song@linux.dev>, Nikita Kalyazin <kalyazin@amazon.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Axel Rasmussen <axelrasmussen@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, James Houghton <jthoughton@google.com>, 
	Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@suse.com>, 
	Ujwal Kundur <ujwal.kundur@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
	Suren Baghdasaryan <surenb@google.com>, Andrea Arcangeli <aarcange@redhat.com>, conduct@kernel.org
References: <aQO3Zko6Qrk7O96u@x1.local>
 <aQPCwFZqNd_ZlZ0S@x1.local>
 <d0b037a6-11b9-483b-aa67-b2a8984e56e0@lucifer.local>
 <aQPU-tyo_w68cnKK@x1.local>
 <7768bbb5-f060-45f7-b584-95bd73c47146@kernel.org>
 <aQkUwbx7Z4q1qcSB@x1.local>
 <5f128cbf-7210-42d9-aca1-0a5ed20928c2@kernel.org>
 <aQmplrpNjvCVjWb_@kernel.org>
 <mnjrtg62qh2rd353mbudryvs3neukt26xtovyddm5uosxurmfi@lldnrp7a3666>
 <aRA-se6hJPzHD3mA@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aRA-se6hJPzHD3mA@kernel.org>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: YT3PR01CA0093.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:85::28) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|BLAPR10MB4945:EE_
X-MS-Office365-Filtering-Correlation-Id: e7ded3dc-5070-418f-a75d-08de207719a2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?QzqOdYZxnFHNQX2ynL+KPj1k9yLDga90BKDN0BVqn+sTeLqNULT7tyoX9tdH?=
 =?us-ascii?Q?8WQUmX+fIcQjqbO4U8yReGxEXkd5Q/y7fwfgqoeK2QOAcbdyUp6yUNNj78pK?=
 =?us-ascii?Q?zg5WLm/Bf02csWW2dnYbO5uodSnWDAjEHTjuKRKWFRjo4o1Whg1Hjo3WjXs2?=
 =?us-ascii?Q?a3UBiGzB5lSfKx3voSx2P6X8wJJPI2RFDXiwPEAAuhimJHrLm6JsuUtYjP84?=
 =?us-ascii?Q?a/RGKXoXnMen99OWWHi2aw0sOJpLQMwlaJFJMk8Gcy171FMUysrlRevwj8pI?=
 =?us-ascii?Q?7+SlQgDeNzCVwLthc5sHMTht+HdBKqfkBxMvbtTuoczMwvUO1S+S+xZ9eWfj?=
 =?us-ascii?Q?OegnDuZkBhOVH9COd9/sX3BEXWPgHnH3hH4PgVCGIb124Sk+FczSCHNzR4C1?=
 =?us-ascii?Q?gSmGTAw6lFsCBcRyrMb4G6VG1ILGF59Tf7lr4XiRC7GF25PJQeJdPWIsefm/?=
 =?us-ascii?Q?cTbZa81p5hI02KnIx9QS0i6CX07/LTrJB35HTTo9c35Ao1T5M2hMdRsG+7KC?=
 =?us-ascii?Q?ALaeDTNebaew96rPJSkKfiuYLztXZsyZI7piOLtjWDoDOqm8bEQIqs/BPoDf?=
 =?us-ascii?Q?Gl+5SeHjMy6wVJ7WciwA/47YB1THFwF9zXqwvZWpePK4O832n75y4j28WhT9?=
 =?us-ascii?Q?DhsZ975XNKZZDxojCo3bpXEpzyGenmn88cD1Ea6T8shMD+cv0DeEvzncWSNj?=
 =?us-ascii?Q?Xw59CP9iaK0fhEWCYvUVwzS30xVOxvLcHiMM8LMA0aNiwBxhG0/SYv6pBoyv?=
 =?us-ascii?Q?3FaplM9yjkpAOYlGdXVP2bbuSQO3WPiZvbp5xN0J44jL+CrOe8jNZPTESI1Z?=
 =?us-ascii?Q?IhbjBoIN8CEMCZGchx4MprSil8VXZi5KxG0B7536XrDJ0DJKpy//OKxs6vej?=
 =?us-ascii?Q?3947bsxNBclJ1Mw7oVWPsdUksHGcsTLjdpJ9NA9+orwjLpMDQZ6TKEKxII4d?=
 =?us-ascii?Q?NpvBVdQtxtlIG1S/vfLfrLB3zJL5pz8hoAfYZfNOHnNa6qivPjb4QI9SDUXq?=
 =?us-ascii?Q?wDXDCrRolBVaedwjZMTvimaDNBfJ3k59uxqv0C3h6ZuNElt3O+7nJn2JQTrz?=
 =?us-ascii?Q?C6C+dbzQdB9SszGXuBmAS80jOOqAehpY3dpZfscPwA+cMpNBr0B2ju5xx5gt?=
 =?us-ascii?Q?iT1xoeL/vt2r44MrhkM13e95Vwawi7bqXXy85oR2Hzh3vsdLSlyQaDxeckI2?=
 =?us-ascii?Q?8uzxQI2EsSklIGTIFZ0fevPPZVKYPMHYBQKavJIZOFu/ofH/+X1RJMUrG5/y?=
 =?us-ascii?Q?CRHr79s2/kDrH+IBdTFZuy0erGVG2Jg90ivN1lhPg+XDSqNWCSQqVMNNya64?=
 =?us-ascii?Q?aOsgzdVBOCjAFDQKDmjUtYdfSGQ0dtekmhmVskUD9zqL4clrHkjt1NXDfHvM?=
 =?us-ascii?Q?8mw+YIkXVbFSmv2PkPYpHFdteV7pceD2f+J4JzXjvlUApajaOw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?c3n4rmhJLmgMEcKF2JzHCOLlv6Fmax+ZTdkqXkE+0l+0yU2FYdC/RrPPyUAA?=
 =?us-ascii?Q?QqhtNMIHLEP2v18ja9Kx3CoJJ9PC3+7I0DAMimaolN9cunBH+VXqMiiAdB7r?=
 =?us-ascii?Q?JRSac1+W8zCb8uvhlGLYwoBu+nMORcyQgbXL6SWuM2Vg3d2K58nG6bKPd6lH?=
 =?us-ascii?Q?daGgMVGAMnT9pc/YhhM2HzgQGGPZ/QeqjIzASMO957Ufo3Nx2TwfidWLmVm/?=
 =?us-ascii?Q?sJMWSLWc/AUN9q1MafgtVKowFQUqhFM7qF5gHV+fAlhlNJqF6heOkOnLMUkW?=
 =?us-ascii?Q?EWbMp7GvzmJ1H/Vl8Q03n6a+knmc8NiZoDPY41GSUqkbkQxl652JhEgW99Th?=
 =?us-ascii?Q?9TSwkvym/z3fZ82JSj0OCXtDxy8MRC1skoE6qP8Cpx0Kc7Uce0hLM1vQrEEf?=
 =?us-ascii?Q?K1O71nn6obB8okKqTuUpkTKERHiurN8VOoRHm+c0tDtkzJhuCRuCSAGuXZaL?=
 =?us-ascii?Q?ihnoQeBjZCEXDhUsUNEXCxhukAGlLPtcgIh25Z/8Pr3wDuZOlHK6Lp7/7KVY?=
 =?us-ascii?Q?hMZcJWt0G70G5ngDEj9A0v8XLTfwJK7W7mQAN7DUe6zUJYH56FGgBgQ7mQ/g?=
 =?us-ascii?Q?9Nn+HRel9iZ4pt0yo9Rc2k0jL9AfzmzgTRWqnzE+iDpHq4r2xLrrZoSltVJA?=
 =?us-ascii?Q?4VM2nJ+lH/4tsj6DooGAbNxFt5PzSaqGxbXt8K41JybhNFkvVKU/J7PE6EON?=
 =?us-ascii?Q?Vy+BeetZ8pxutl6Vmg6E04Up2iYn4zN3Pt22hLpTfCxSaPhBERPjVBDtU15i?=
 =?us-ascii?Q?Yl1Vr9NZwMmJHV9f2lLYW248/Id37HWROLOiVrN8YlJCsYVyKAsP3C4JbrB+?=
 =?us-ascii?Q?a4S6vJgyCxtBGbBv8Q4xDWwidaiZco8AicS5uekaUfRDH5b2MTwavl/svwlj?=
 =?us-ascii?Q?8np0nkjAAHIoEqZBCNc76yiVe+VTYXKeiSziRBcuRijQB3KE0DmYlcWJHrp+?=
 =?us-ascii?Q?JTLDvPu3ygeK0GxbiBGyPlQ8Q2jA9LOOuv2vMcOZjT7hliTBzIxXrcJZfNgy?=
 =?us-ascii?Q?I3u86CBO0ocjrRJWTlgdX821M1n4B/qgYrQcbKY53ndNE3EmFH2RG2ffTUm7?=
 =?us-ascii?Q?fxeN5dvzbRSNKPhU2IDE6r+QsSubYsdheL9iAgV0wlwxglBCTxTJeGO/pZaI?=
 =?us-ascii?Q?XmpvkUgWBEvIzVrubN+GJpKORv5v3zG/fARuAgh7eMQf7085P/CYVltTu9gw?=
 =?us-ascii?Q?lik28GiWGSIEOBM0gYHWbtRLgNNb49mEgtkOjhlpKuvVr7X2u6wHLK//8qH7?=
 =?us-ascii?Q?Ofl22hYdvmIYTuxW9Ogo2+8V6Be+i4mGSEX5QYoTHBaaA2UfQ7m0fTT9QaBL?=
 =?us-ascii?Q?JC7LEne/BczUNb1s3k4Ke6JmYu0PSNVEixIKNgiijYaBKB6J5ZWnbgphAqNx?=
 =?us-ascii?Q?CjNKPRPb+kVkyYhySZF/ii+eZXM/+ml7uKXrOgqohkiw2n/eeAbDCR8vAmDT?=
 =?us-ascii?Q?5yk5frfzbzTie48/RvnI0588oUzd2a1WC7oAKCUW0BL8/gd+ej6U8zX6WG0X?=
 =?us-ascii?Q?mO00c+25ynbchzoQN53oAUy4eci053vfU8ftHIoUaP95vWZmlDjmdopsvW6O?=
 =?us-ascii?Q?DIRpR2qvOUUGeWne6INcX5RJANbZzqto8WweNbFX?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	cv0Nt0mGQ9ySKByxhNqOXdq6lXwy7eaIa1MjpI4H8U5J9vvOizdltIXhdcm09L680YddOEJEZa/FIhWgL8JiejlGDCctrPe3aYZiuK5YWLDV9ChyOHiMofBUjDALO5LIsy+AEcEzpatHGJTx60yAmIdXzVFC7mkDRiHFLB5lH5o24ITLCC3ZWC7r7n97HUCYOUG0BB7GwydBXt4KLA1iZJQ3fSw8MuFcgUoC5jzgjNn1FbNFSMzvuu2kazfkLIx9nCVOuKnDgTpJrPcQY2kKNHAt/YcyHCSDFlR6juYRphJDEGcRgawJV/UO/x6OrPyLCzoJ8gMpXATD6jsJooJergCJwWyf7nA4kW5Dg94CoGUfwv3bxuDyfeYxVdZ+Qw4eMnyrmV8wyrAQ8vyKQi2Y/8/KHdQ590uy2SLJRQlJffcroUAgoePnKufSTSprf8Kdxo70ytkAwFxme6JQ0j2e2QDo5q5xXPfDYmczSQ+L6lwes2cJFQrOYlpvWrLjzMBB7eJhDXAAr2OEbRrQlGA3i5L344I4E+kDosCnZLexMwU+HAmsxMffApcQqyfRgod7fhfW3KvvdwEG8elVgtIfqc54FXzhZC0WetWitRjQbPE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7ded3dc-5070-418f-a75d-08de207719a2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2025 16:35:03.9517
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TdVQfQ31f2e+zvFHc7EMW6IlP/WQyYNzsmrbyFFUeliSGi1xnTgEGiU1wkQBrsoKR6rtBh0+l5IzbEBgYBsDHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4945
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-10_06,2025-11-10_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 phishscore=0 suspectscore=0 adultscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511100140
X-Proofpoint-GUID: iqOpbtXUvt3SUeHJ0vcJpdJWlyjlS63P
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEwMDEzOSBTYWx0ZWRfX+61JTPPUOjP7
 eD11b0db2+Q3c6zTZWzEmC8aGPFdConJIR6uM6hdMupVLrd/rAA+9yjzn0FjJuygUM+s+uJ8lWP
 rV/dJwtRmPsskgJ5/oYZbz8VMnpR9CpjUMDhDPYiCbWR/D3UKKJcvDYiUhB/AJ2bNgrYkmmW1WR
 s8d9Q1up/Dnu/wWc39skITw+XchjODbdQ+HEAX0TQB3lqop15WdSoGdJANuCHeo8+VuXXxIkzjn
 dqHBkmESqgPPzjUK4LkOGZVJkcPV2/fr9IYSWxL8eFwQVau7yToYKiqr2fs9T1+oz67JAaXBB/6
 ZcUDQMRyZRZUSs2CzeyNvm5vRC0xzVK1TPzJ5cpBq4w+2fTooQMh1mh0JKPRrAivYb3NAcgvlK6
 3Jerw3QYDpUC7fHQSnrRfpPWdvvb+YwyHubeZFkb/+PvvgTh1uc=
X-Authority-Analysis: v=2.4 cv=U4qfzOru c=1 sm=1 tr=0 ts=6912143d b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=JfrnYn6hAAAA:8 a=VwQbUJbxAAAA:8 a=rFMI78s69ezNWytJ1MgA:9 a=CjuIK1q_8ugA:10
 a=1CNFftbPRP8L7MoqJWF3:22 cc=ntf awl=host:12099
X-Proofpoint-ORIG-GUID: iqOpbtXUvt3SUeHJ0vcJpdJWlyjlS63P
X-Rspamd-Queue-Id: 12D54180012
X-Stat-Signature: txzz9frb44rjdy41s9xhqfpatkfprj1o
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762792515-96510
X-HE-Meta: U2FsdGVkX1+0+PvkVIhJ8sNwuPlVkpZUHv863dGHKdHq59nAAHCsMmGhjunpxXjCjJr4+1zS8uy4VcwJ2nC3aQt3nBLTNCTboR2BE0LlB1pA/iFihmg1c4bVZypT7jkin+mipvoEMQNxwn/FzXhmesecOY7QyQOuC/HTGf5uDgDNC6DpaBWdGUt4EerFDn8V+HnVuIgH12JfIJsJTQNbZsHyZOJXXKCPxokb84cS1rXE9dWYSDmyMqP98EZvDtqAq6ac5frfwQAt7n8jW1ChbodmCUJDKmq1YX698UsOyA2A+SbbziojSJ2VeueK5nIwkWujFlsdjzNsEOhU2uSsFGFuO3X2mAg5CQOof2VYnCIc1jgy0Fdeu4R7MU6MI7aBjJahiqu1fQsb2TKDnQ1OscMXeDr+se4XLyDPJU/7WoTCjXFlMYCzYjeuphJf3obqomGEyRYn5NSoMhIsXkAvbN1HTx3UT/wqSQzRLtNttKmQ3PYo211OhU+LawSXaiNEZ+Cg5PPk21mzwebh878urAmbUvJ2eLwgiiitLg31gAzYE8SFXRTFUpK0aGZtc0UJ/ulkw0kV36b54ZU//n9406csCWotjH+veh/+TnNCd+v5FQ/PVESs4aPlZMzylnkRly3bIFfdtxpxa3TwuG6NPmMnz1fm7LAc7iXhJceTDnR+x9z4Ccjss9/8wsSzXCOqMIWx0rYVqdi3wVbCVINYVWHNnyBFNxiDkP2ol4bKdHXw80zxr3evUE/fQW2D6UvQ83qZlBjhHymLErtNnc9xL1DFUsGkO77QOV4V86QE7zMiblX5tW9ZjYuXqP1Oh9fVcNUelA2HiQrO/Wc7Ueeko4IvOZ/SXJmeyuYc0eAzwF6LrwWdhIT4QVVmN2fnnt0DPUhpDgribn+Wv9PmN9EHe/Ig1jJKTF7gDODLxyuEyHzru7uf8zeaQ9OTrHmc4CAwkd6IfHJcAg9+NIYK2Bm
 +yRvgjdU
 NyoF5GMHz6z28BDgzt5EWxPRxkiGuu2cYV87ykz4QcD5eqZwxBk7s8YqSc/d0k+x94LPlg7XRl7Vg/YMXWXKAmMkTAbqeYJAZQBAbLlGxmIaLXk3BkPZTJmFVJA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Mike Rapoport <rppt@kernel.org> [251109 02:12]:
> Hi Liam,
> 
> On Thu, Nov 06, 2025 at 11:32:46AM -0500, Liam R. Howlett wrote:
> > * Mike Rapoport <rppt@kernel.org> [251104 02:22]:
> > > On Mon, Nov 03, 2025 at 10:27:05PM +0100, David Hildenbrand (Red Hat) wrote:
> > > > 
> > > > And maybe that's the main problem here: Liam talks about general uffd
> > > > cleanups while you are focused on supporting guest_memfd minor mode "as
> > > > simple as possible" (as you write below).
> > > 
> > > Hijacking for the technical part for a moment ;-)
> > > 
> > > It seems that "as simple as possible" can even avoid data members in struct
> > > vm_uffd_ops, e.g something along these lines:
> > 
> > I like this because it removes the flag.
> > 
> > If we don't want to return the folio, we could modify the
> > mfill_atomic_pte_continue() to __mfill_atomic_pte_continue() which takes
> > a function pointer and have the callers pass a different get_folio() by
> > memory type.  Each memory type (anon, shmem, and guest_memfd) would have
> > a small stub that would be set in the vm_ops.
> 
> I'm not sure I follow you here.
> What do you mean by "don't want to return the folio"? 

I didn't get this far in my prototyping, but if we have a way to service
the minor fault for the memory types then we could use the function
pointer as the way to change how to get the folio vs passing in a
pointer to get/set the folio.

> 
> Isn't ->minor_get_folio() is already a different get_folio() by memory
> type?

Yes.  If you are dead set with handing the folio to the module, then
this is what you do.

If you wanted to avoid leaking the **folio out, then we might be able to
do that by having a small section of code live in mm for guest_memfd.
Everyone seemed to have abandoned this idea, but I'm not sure why it's
not workable.  It seems like we have a viable decoupling method here.

> 
> > It also looks similar to vma_get_uffd_ops() in 1fa9377e57eb1
> > ("mm/userfaultfd: Introduce userfaultfd ops and use it for destination
> > validation") [1].  But I always returned a uffd ops, which passes all
> > uffd testing.  When would your NULL uffd ops be hit?  That is, when
> > would uffd_ops not be set and not be anon?
> 
> The patch is a prototype. Quite possibly you are right and there's no need
> to return NULL there.

I might be putting too much trust in the testing that exists as well.

Either way, this approach is removing the growth of more
flags/middleware in uffd.

>  
> > [1].  https://git.infradead.org/?p=users/jedix/linux-maple.git;a=blobdiff;f=mm/userfaultfd.c;h=e2570e72242e5a350508f785119c5dee4d8176c1;hp=e8341a45e7e8d239c64f460afeb5b2b8b29ed853;hb=1fa9377e57eb16d7fa579ea7f8eb832164d209ac;hpb=2166e91882eb195677717ac2f8fbfc58171196ce
> > 
> > Thanks,
> > Liam
> > 
> > > 
> > > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > > index d16b33bacc32..840986780cb5 100644
> > > --- a/include/linux/mm.h
> > > +++ b/include/linux/mm.h
> > > @@ -605,6 +605,8 @@ struct vm_fault {
> > >  					 */
> > >  };
> > >  
> > > +struct vm_uffd_ops;
> > > +
> > >  /*
> > >   * These are the virtual MM functions - opening of an area, closing and
> > >   * unmapping it (needed to keep files on disk up-to-date etc), pointer
> > > @@ -690,6 +692,9 @@ struct vm_operations_struct {
> > >  	struct page *(*find_normal_page)(struct vm_area_struct *vma,
> > >  					 unsigned long addr);
> > >  #endif /* CONFIG_FIND_NORMAL_PAGE */
> > > +#ifdef CONFIG_USERFAULTFD
> > > +	const struct vm_uffd_ops *uffd_ops;
> > > +#endif
> > >  };
> > >  
> > >  #ifdef CONFIG_NUMA_BALANCING
> > > diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
> > > index c0e716aec26a..aac7ac616636 100644
> > > --- a/include/linux/userfaultfd_k.h
> > > +++ b/include/linux/userfaultfd_k.h
> > > @@ -111,6 +111,11 @@ static inline uffd_flags_t uffd_flags_set_mode(uffd_flags_t flags, enum mfill_at
> > >  /* Flags controlling behavior. These behavior changes are mode-independent. */
> > >  #define MFILL_ATOMIC_WP MFILL_ATOMIC_FLAG(0)
> > >  
> > > +struct vm_uffd_ops {
> > > +	int (*minor_get_folio)(struct inode *inode, pgoff_t pgoff,
> > > +			       struct folio **folio);
> > > +};
> > > +
> > >  extern int mfill_atomic_install_pte(pmd_t *dst_pmd,
> > >  				    struct vm_area_struct *dst_vma,
> > >  				    unsigned long dst_addr, struct page *page,
> > > diff --git a/mm/shmem.c b/mm/shmem.c
> > > index b9081b817d28..b4318ad3bdf9 100644
> > > --- a/mm/shmem.c
> > > +++ b/mm/shmem.c
> > > @@ -3260,6 +3260,17 @@ int shmem_mfill_atomic_pte(pmd_t *dst_pmd,
> > >  	shmem_inode_unacct_blocks(inode, 1);
> > >  	return ret;
> > >  }
> > > +
> > > +static int shmem_uffd_minor_get_folio(struct inode *inode, pgoff_t pgoff,
> > > +				      struct folio **folio)
> > > +{
> > > +	return shmem_get_folio(inode, pgoff, 0, folio, SGP_NOALLOC);
> > > +}
> > > +
> > > +static const struct vm_uffd_ops shmem_uffd_ops = {
> > > +	.minor_get_folio = shmem_uffd_minor_get_folio,
> > > +};
> > > +
> > >  #endif /* CONFIG_USERFAULTFD */
> > >  
> > >  #ifdef CONFIG_TMPFS
> > > @@ -5292,6 +5303,9 @@ static const struct vm_operations_struct shmem_vm_ops = {
> > >  	.set_policy     = shmem_set_policy,
> > >  	.get_policy     = shmem_get_policy,
> > >  #endif
> > > +#ifdef CONFIG_USERFAULTFD
> > > +	.uffd_ops	= &shmem_uffd_ops,
> > > +#endif
> > >  };
> > >  
> > >  static const struct vm_operations_struct shmem_anon_vm_ops = {
> > > @@ -5301,6 +5315,9 @@ static const struct vm_operations_struct shmem_anon_vm_ops = {
> > >  	.set_policy     = shmem_set_policy,
> > >  	.get_policy     = shmem_get_policy,
> > >  #endif
> > > +#ifdef CONFIG_USERFAULTFD
> > > +	.uffd_ops	= &shmem_uffd_ops,
> > > +#endif
> > >  };
> > >  
> > >  int shmem_init_fs_context(struct fs_context *fc)
> > > diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> > > index af61b95c89e4..6b30a8f39f4d 100644
> > > --- a/mm/userfaultfd.c
> > > +++ b/mm/userfaultfd.c
> > > @@ -20,6 +20,20 @@
> > >  #include "internal.h"
> > >  #include "swap.h"
> > >  
> > > +static const struct vm_uffd_ops anon_uffd_ops = {
> > > +};
> > > +
> > > +static inline const struct vm_uffd_ops *vma_get_uffd_ops(struct vm_area_struct *vma)
> > > +{
> > > +	if (vma->vm_ops && vma->vm_ops->uffd_ops)
> > > +		return vma->vm_ops->uffd_ops;
> > > +
> > > +	if (vma_is_anonymous(vma))
> > > +		return &anon_uffd_ops;
> > > +
> > > +	return NULL;
> > > +}
> > > +
> > >  static __always_inline
> > >  bool validate_dst_vma(struct vm_area_struct *dst_vma, unsigned long dst_end)
> > >  {
> > > @@ -382,13 +396,14 @@ static int mfill_atomic_pte_continue(pmd_t *dst_pmd,
> > >  				     unsigned long dst_addr,
> > >  				     uffd_flags_t flags)
> > >  {
> > > +	const struct vm_uffd_ops *uffd_ops = vma_get_uffd_ops(dst_vma);
> > >  	struct inode *inode = file_inode(dst_vma->vm_file);
> > >  	pgoff_t pgoff = linear_page_index(dst_vma, dst_addr);
> > >  	struct folio *folio;
> > >  	struct page *page;
> > >  	int ret;
> > >  
> > > -	ret = shmem_get_folio(inode, pgoff, 0, &folio, SGP_NOALLOC);
> > > +	ret = uffd_ops->minor_get_folio(inode, pgoff, &folio);
> > >  	/* Our caller expects us to return -EFAULT if we failed to find folio */
> > >  	if (ret == -ENOENT)
> > >  		ret = -EFAULT;
> > > @@ -707,6 +722,7 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
> > >  	unsigned long src_addr, dst_addr;
> > >  	long copied;
> > >  	struct folio *folio;
> > > +	const struct vm_uffd_ops *uffd_ops;
> > >  
> > >  	/*
> > >  	 * Sanitize the command parameters:
> > > @@ -766,10 +782,11 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
> > >  		return  mfill_atomic_hugetlb(ctx, dst_vma, dst_start,
> > >  					     src_start, len, flags);
> > >  
> > > -	if (!vma_is_anonymous(dst_vma) && !vma_is_shmem(dst_vma))
> > > +	uffd_ops = vma_get_uffd_ops(dst_vma);
> > > +	if (!uffd_ops)
> > >  		goto out_unlock;
> > > -	if (!vma_is_shmem(dst_vma) &&
> > > -	    uffd_flags_mode_is(flags, MFILL_ATOMIC_CONTINUE))
> > > +	if (uffd_flags_mode_is(flags, MFILL_ATOMIC_CONTINUE) &&
> > > +	    !uffd_ops->minor_get_folio)
> > >  		goto out_unlock;
> > >  
> > >  	while (src_addr < src_start + len) {
> > >  
> > > -- 
> > > Sincerely yours,
> > > Mike.
> 
> -- 
> Sincerely yours,
> Mike.

