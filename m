Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CD3CCAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 11:54:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79DC28E0008; Wed, 24 Sep 2025 07:54:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74D368E0001; Wed, 24 Sep 2025 07:54:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EE0D8E0008; Wed, 24 Sep 2025 07:54:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 454B28E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 07:54:34 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0F1E1C052D
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:54:34 +0000 (UTC)
X-FDA: 83923986468.26.9325FE1
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf04.hostedemail.com (Postfix) with ESMTP id 91D934000A
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:54:30 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=EcuCNo+Z;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=kjrsJOG8;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758714870;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jWyOQy9ro9MyaDoo2EXklZigeYwRgWVwj+C2nBOhiRA=;
	b=Omi2f9FvIYCCzBNpi/dIugX5u5BuCrb3kt7khFX2lLIclPtP3ErNPTN51SXXogqrCSN0c2
	ES9dOdnaOhV+8R1nXHXPbyfD2VJnwOipUy0dsy/cN3YItlBgy6EbmGK/sN7b1ueZyYNsMb
	vMZMST+/vCnB2TLgwMKwJiaLA9bwiTk=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=EcuCNo+Z;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=kjrsJOG8;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758714870; a=rsa-sha256;
	cv=pass;
	b=FZw1Wob70zqj7P5jnWGk+tELeHaD/mDvgg7WQUdwYni5f0JkBsherOQlpRTkdhCxUvYYIv
	C4N431wy6Lgx9a68kV546UwoJGlIH3voA0yYdyEThZ/UbvL0FTS9uF1pw1PBSTOnEKfFaX
	FjO6jNm24G/yWDqOlXFes5dZ+IT1nOE=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58O9Mqrd010920;
	Wed, 24 Sep 2025 11:54:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=jWyOQy9ro9MyaDoo2E
	XklZigeYwRgWVwj+C2nBOhiRA=; b=EcuCNo+Z4EENFpq9w4FHDej3WnqKqfpKJv
	8WkzLGh0ctcpWkWcSdn789NlR0azMwCfQicfbzmck0acAdCv3IS/puCNLTNZnMTS
	J+DvgVcpcnwiANf9tPpl18jiyNrsbsP7eJfzJe82oyAo7RcsW4WkNwO7neQzw76e
	GaaKWMf0ofVbaNmFtyWChVWxk56Y46RQEjtm3qZdqO/obnSomSx65EpjEEQVVUSo
	z9KTJDM18+TJr35Izrz4yF6P2s35JtCeqBs7hsa/tREKwvzfskPRMTzG0tlssBPn
	sF3YgbB3ulJR1AU7O5nSnDYOCZf2wm0q+VndxmDdr7j3AEQndbog==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 499jpdqeqk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Sep 2025 11:54:19 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58O9beUS030818;
	Wed, 24 Sep 2025 11:54:19 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012070.outbound.protection.outlook.com [52.101.43.70])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 499jq9u939-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Sep 2025 11:54:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pTVk/yWt5XsW2Z5fuUjcssztuFHKbbbcvZ73uvbha56tNUYmUK0DVLELHDQM15d2h9GpeOAY/2E4G90nUTXWneiLdDDvSHvQFSZjTZyQgJ27a0QNkVg2cFinnOXp5GfO1K+CZlQABQpeP5dXvz0RZ4YxwxkQ8pSxqzyJhfIsdumtC4p5/VsJ7mq0BYosaX8rV7QREh+ObHChb1O5r7XoZqBLDYFNsB+RCyRfUwLLxVYInMrgwoJZl3f1XdJnLE7bhIb9NJVgInsTQyLbviDZEQfEtOZ6GR8ed+Pe+uaA139kMZFZqvlseWgTnmWsBnP7eg4uI1lwc7zG3TENY3E5Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jWyOQy9ro9MyaDoo2EXklZigeYwRgWVwj+C2nBOhiRA=;
 b=M122ZhIN7Qtk7QVAkUjkNdoZHjx1bou1GLjtpmM2ZBkccE3ue6F+p1juFWWcS4iOd28M1a20mFNdZn1EOoQoszsfciClGJ8+Yd+ATRLbN27JFW1U+ok0HvMwWVIubyuY8dYH0w3EoYK9pm82YQ5UQ5pJkItfj88RYMcLn3Q9mLYONqtIsi3nw49mtCddaQYtv6u88YnJaH1umbirQ2ums2kTKCJME/Uzhf7hoTtuaqNbuwQ3rze/QI4IRIQ5RPz/Gq88Z5mmV9+E1MXE9X0F3Ff8CGgqrnUfmztPefBO6PNyh/ehg/+76/vr05ErcUH3ra8F3NT7nxDQLWMxkAyLZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jWyOQy9ro9MyaDoo2EXklZigeYwRgWVwj+C2nBOhiRA=;
 b=kjrsJOG8TC9bwmxJKeLqbwlnXKvcirK9zL69LLrjWV0Z+HHFMVT91IWyOw0+UfmAwqVH+q7CqjBTmGu5ZUVjnScBZRQ4qKniNs4pabZQLVSfw98w+IzrAZ8cgNoCYijn+Q9TQnplymeqP6FR6Z1MLoX3ymeoXN30fkN3XbhUBS8=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by CO1PR10MB4498.namprd10.prod.outlook.com (2603:10b6:303:6c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.9; Wed, 24 Sep
 2025 11:54:16 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.9137.018; Wed, 24 Sep 2025
 11:54:16 +0000
Date: Wed, 24 Sep 2025 20:54:06 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Lance Yang <lance.yang@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
        Hugh Dickins <hughd@google.com>, Vlastimil Babka <vbabka@suse.cz>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org,
        stable@vger.kernel.org
Subject: Re: [DISCUSSION] Fixing bad pmd due to a race condition between
 change_prot_numa() and THP migration in pre-6.5 kernels.
Message-ID: <aNPb3qVCZTf2xMkN@hyeyoo>
References: <20250921232709.1608699-1-harry.yoo@oracle.com>
 <b41ea29e-6b48-4f64-859c-73be095453ae@redhat.com>
 <aNKIVVPLlxdX2Slj@hyeyoo>
 <6e4f6a37-2449-4089-8b3d-234ba86878e2@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6e4f6a37-2449-4089-8b3d-234ba86878e2@redhat.com>
X-ClientProxiedBy: SE2P216CA0133.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c7::13) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|CO1PR10MB4498:EE_
X-MS-Office365-Filtering-Correlation-Id: a919f0c4-07b9-4a0f-a964-08ddfb611622
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?E5P9JeKZ6dQEp/bwi06ToE1CN5+g02UXNfE/Vau6n5WGYYN99HlDTdX4GBXn?=
 =?us-ascii?Q?ju3Xur18F9YAXfGhJ32Zr0TGEUdMWVVkX+uz3IH5bJkZZe3J+1/XFhqV4S1i?=
 =?us-ascii?Q?eqs2VIuLbHDYpzoMtDgfL5Y6v7mj9L0Msw1j71+N7d3QY6rBbpqa9cksI3iy?=
 =?us-ascii?Q?upnIG+oOlBo9d9xO7Sds0nWVi2o8DVdoEmAAhay1cIdynPA77Jpymvb1sJPn?=
 =?us-ascii?Q?vVx/xIt0zZPshgy7RzFTz0jKVVKNLLUFF/wcd8lY8UyQM5Y9MyNq8NBqTd28?=
 =?us-ascii?Q?wtIkORlg0jcR0wnY4uNB7MkqNzesiztXEzMptl4WrDNE4lOpsrVTQ3LR3diL?=
 =?us-ascii?Q?j2X+0E7Ea406keTjOP1y9yC03GvGDb2sCvLBSVTkoJZkZnzNyMCOFgHCfDsc?=
 =?us-ascii?Q?xTrMHfeAoAicawdSTry5OfG1ZmpQcbPcysFmLr3rNlUUIR0Efd0tioY+MphW?=
 =?us-ascii?Q?6G8A7KL8EzmSx/TFwCZrzWZLPu64ZUQ1LGzEHX9Y/Ofj14lQMoWfdAH3Kz+t?=
 =?us-ascii?Q?V1lgMhvSMu+myfzP6umAyUHbKfkoRcCm+tQgRjDEsPywzbd/ewcMpbDt8jjF?=
 =?us-ascii?Q?i9+D06mmfAdXJJcpm/8oohDK0H9/BQP+vS5l9kB08xu0nG/pYDp2Elt3hOc5?=
 =?us-ascii?Q?ANsX8sy+ndaAmW+jZ5HenIbpZ4OA4C/6DZA2PekYlLLHZEfzpuK1pYjbzMgN?=
 =?us-ascii?Q?YmT3BJ1JkfqCfmxMfXk8y2IemChRRFS/B7fxSHpKJ9SvSBir+scR5utVrzjr?=
 =?us-ascii?Q?K5histL0ENodKX5/IHFwK8fQ8UuVb6lM5U0KaEkrb2nVnCfRsbfQGbNZ7i+C?=
 =?us-ascii?Q?xMBRJXBSaC3h/GdfhcBu68DiEZ9Jb6lsgv4dbSGsgLWTiPsW9jwCzFWkghcc?=
 =?us-ascii?Q?Or5u0hbvsaN0kVTcAAQOUALCaik45q6swovvEQGLKhS3S7i0liJp5OQUzkid?=
 =?us-ascii?Q?JpSoVKnAiiNPRGmXH8D2oNCTBKXGhc/3XkLIBWTm+KBwHuclagj/XybK5uqG?=
 =?us-ascii?Q?VW496CB6R+HWGfwWdEVTgdB368KkpJtfOv0Po+j8rCBzDCPjR0Rj4D/CQ1d8?=
 =?us-ascii?Q?yX1xMd+mh5zOVoO23dzPJNMSX1vzeQHpIO5XLJqD47bbsxxJ4l9sipuSvIba?=
 =?us-ascii?Q?AEoUT1AQvemE3Xx+jER3EaAUtrFtao8gmGeIyA0wEilrGz5c23wh04lFX5Lb?=
 =?us-ascii?Q?tl3Cuoied2AZ0nIK6NmOsT2PcKiMrI9ATFvVZQO6Kq6ibek2BAhM+NlBucsT?=
 =?us-ascii?Q?FC1B0kTXBMhKYlEV/dxmTqmj8xRj6uh/wF93D/rQgXFpDhOMhgOfO5IBbeie?=
 =?us-ascii?Q?lz1BPb492eSarLp9yJkXOfpI+qUbCNA9EvabO0sJI45GSO3UFZvwQjQHRwtf?=
 =?us-ascii?Q?l7UCg4eEBGVlH3UEJI4phivAce2GNsW0Id9DGXV1zRcZvwxLOw9e6jDVFJ7b?=
 =?us-ascii?Q?w+dabmtU3oM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TsVUhKLlzv/ke+ne9yS+X8KV0G5H8Dveyu+GRkahukj37FQIb4/6brpk1OsQ?=
 =?us-ascii?Q?krTULHeb8pe9V29ux8f1j2qF+IJjfhPpxeRZbS9T8IJpal+uh9rbT8L9aZPw?=
 =?us-ascii?Q?D0iys4GnAwcotFjioIVzR7PCy3NsI714wtlhaVbPkjK3xf9W2k+eWbUMXIWq?=
 =?us-ascii?Q?tCBeKaJ/gCwCWKAzF/QfPmsi0hZA6zRSmH7oXFs3YrY+CmDkqBtjIAbelwFR?=
 =?us-ascii?Q?/amJ9rJMpndvWsLHMAfoz4Q8wEvTGCuPpvwNTOhgq+MlSsfTRXaDnFjteg0/?=
 =?us-ascii?Q?0NullIY5Zz+fUBl1uGfRVkH5h2ytFIQzgCXPNWB37RFTqwCRl4CwLs9k5G+Y?=
 =?us-ascii?Q?DH8t1C01GonpJ5JWePsI8zS8hnskzxsmLLS6O1zVLMftHel6VDGAvBuoDqjD?=
 =?us-ascii?Q?mT5EIjjXuejmby0e/sw84xq7jiru0owiavx2EVHni7ZOw+WuOBqMIP8Z+W2K?=
 =?us-ascii?Q?aovBw8qJHGRiF+wxLcF3Of2ZZhEIBO8dMjgiwOONKWvebp2VwIhCGrNO9r76?=
 =?us-ascii?Q?zXXJagULfj5Eu28yW1zWLEZGNk4YkGe4PIoEY5zRasSZr1wOwaQCVS8q9yGs?=
 =?us-ascii?Q?2TyrpTRK7JwyTPkOm/UPZkaR7qyaviCqpICBgcaAzFlTNq+8V639WJBqPCur?=
 =?us-ascii?Q?saAmcqf4V5ry2TbxgG2WmlMUqBJLMXppeJoMzVc0OY+X4PB31DzuBgKHn7yw?=
 =?us-ascii?Q?Agp6MSxjWS6qmr0R0nApD7hikwIttb8JK0IvwCAy/U6uKypUAgAqppjOd3uz?=
 =?us-ascii?Q?9JBLik7vCgOeDjGfG8OTyTfyUm8oUGebmlCUHXn4vxhu3c+PKXcdgIrrRuY9?=
 =?us-ascii?Q?W6Hzvr4PKW30DlL8jRHB6MpwjJ7XyPxLwEGZW6WWx2MF57tbiJuuE+qRiVb2?=
 =?us-ascii?Q?9jcgFHW492qZsQIfl5QNql8tbghlMWDxVRE9Ho7e/Sd+7nAKf4dmabryHXeB?=
 =?us-ascii?Q?x4S7Q7fmZw9XNPxMtpkwyPZZb0ASzCKPFw1IXj69PBFQ8GVX/rAzKZDbJKIE?=
 =?us-ascii?Q?OrqRStNTfCrcXIQkfxiPNugHVSviz6ofuJ03POyZRSR6ZDyh05dX1m6ptNxp?=
 =?us-ascii?Q?ofCgFP6UkhtvRCbUnPVywbR+gDHlFKHBVMUi4136yvZc9oXkOspsITefdltz?=
 =?us-ascii?Q?ARbrF78E0Lou3p6xEeMtQYXq9IVrdRdW2LbVDGWelxjGYa7rthnmcSgyUhL3?=
 =?us-ascii?Q?v1KH0YbnOYNCqjJnzBed7Ysi8xvn13rMqCSCwkrkf8KKBiyl97pWicK97WQf?=
 =?us-ascii?Q?mTSW7LDjTRz5KF8Dm7pFTmdvys4vBlIVh4XZ+Ts9GPt885GG9xHnUTAInOnK?=
 =?us-ascii?Q?6sWmxiodnwKoXc9p6Ma4snlhxeXQO7p53S+FuZlXhkZuB3IStDg4ovgMngu6?=
 =?us-ascii?Q?dc5xvK4zlB5WthzHmDAvnnVPIcmO/7nJALmkYddgCl/wYmuZ5IXDGpJ+A05t?=
 =?us-ascii?Q?681uixuRlrD2AZ51oF7BVq/mVopEsYxeiPYQ1aCnxpzGqbzl44dwkAE3isMY?=
 =?us-ascii?Q?yOzaPdgBU0ewgxGUbFh4XXzOkmxt5I+oic6Ptw4kV7400EJzaA92VQ24PWdY?=
 =?us-ascii?Q?QV6NEDOIbHXvVMEW3n0hqoSigCfn5z2P06y20KMH?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	oFGnZgqrFjjCIOHLWBFNbwVv6huVsF0DJoCwQn3Kk5cg9slGV5mOWG1lfT0V9hJq0LDH+GbdnaYgQOmcACIjAo5OFUBuegp/qEiGCyl7/J8F2gs7/B3mk9uCEkIqmuik7C8Gp81UHOXVmjRHdcUVKhXP2KFtur/upkIQyXFeNYQAOSIk7WUDo2gLuA14bEKphuHpy/VzrF6y0bGrunyt07V2pN3G+Bs/xfLpu/UlR5m0gAaDZ/Wt3SBnFV41e50Dp15jh+pbMAS9PsLf101a6TrU4St+HX3g/BYkZfQ3QbMnDAn9qTeN2xHHqR+Z7g6Zfx5akiY3Y62I2rRrjHmAfliJB4/ROpBByhzt6hTz9lO4H5tydSNTrf+DfWxjwtU/Lgcd2w6E/lpSbGHdLCNzXmJllx0SLT5dB8GfcXtfMQWMiubJ7yBjwAHdofwrkw0Fhssemmer2FKixyF9FVIhpGnat2Fr1D6TRT4z0Ump96SBZ5XtG1cyjQpOI0PDkWMIbfAS4m1rprnzEA00rwaTIlWA00t8lF231W4jyZq3q1Ez55ywBH/CsyrKmzrAjJ/bByD+xTI9CIl+h+lF22LMPJynOWctfGz1bxVyZKTcJiI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a919f0c4-07b9-4a0f-a964-08ddfb611622
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2025 11:54:16.2587
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MzuYuWLFUul6mdl0MNvbMTLl2LwaPN6IxMRkv4OB7hTInKuNE5XjO+c9h7fXr/TjskjgCBCuv4GhwXc5rfNIjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4498
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-24_03,2025-09-22_05,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 spamscore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509240102
X-Proofpoint-GUID: Ipv4Ml-jr5fkAmoI0bsJvP9LkJ5gPAkX
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTIwMDAxMiBTYWx0ZWRfXxHyta9hZ/BjO
 gFqHSsHE15Jm5cjuq1FOyVdVfV75Ulwf8S5gzrYVk2hqjtBkUw+XDXyATgw7PBOnpJx1ymaSw0F
 F/B4UBYWjLoB9w9GRXRsaM83lSiR6K+2/78iBXgb/OS8wmBsgBAgT0XKr6LYKIneelOnLTfQTSh
 TcjhH5q0H3trlF1CODbMnMorJt/crREKFQfN+qO83E6YpHk0yj0ufOrhntO21Zyhdku5EBwRLz0
 jO+eeTH4Icqvy4kWDIz8+LFEaDZYdWbtQJdKEDlPa8c9gKRlOffsFQnnqwHj0SDvwJul8d9lbOR
 Bg8JScITuBSmmIYiCzATqQgIdTFDtygRuYtCQuB52w/BAg/p0EDOIBJvt1lRu4dKBAtyiMRS9Ys
 2nPOMefx
X-Authority-Analysis: v=2.4 cv=aJPwqa9m c=1 sm=1 tr=0 ts=68d3dbec cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=5sqfT6X9urALqBKsuZUA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: Ipv4Ml-jr5fkAmoI0bsJvP9LkJ5gPAkX
X-Rspamd-Queue-Id: 91D934000A
X-Rspamd-Server: rspam05
X-Stat-Signature: ijj37nu1jump6msz6uf63q4k1e3rb8oa
X-Rspam-User: 
X-HE-Tag: 1758714870-669032
X-HE-Meta: U2FsdGVkX196o81/1jIJJCG0pt/YlYubtfEsK+j1ybW/Mh7omSdMgciXT7mk3rtiQvwkl3AW8QbFlAtO86t0UvH4SuI/2wbKQPGzjMooa9vr7TFeKE0DJvlcu2ZoQ+UNO5cOBVnNUTL1EgTv2ITOslIdHvJT46sXL0pruCLLfhnHYmpKn0V/CB30FxvpzWFvWZl6FF05lT+bo9MMDmTF6vwt/oZWfijW6UAbfWtTSg0oYkGUQQsdGbpTe4C5czXfEmJYVgJHGnaHAFSEPdwOFJp+D/FZeZRqkvf3pUzKo6KKa7p0IXwxB46u3zmELCwEUFw7vkHLfvSMVLQF1iVf8ZrMpUKrzTgmWFh0km99FFVS2pjRz6CV96MJEb0NpNenU2DXWf6K48jzlJwKSFtV4SuOvSxRDDIfYewyXA6V7cY01xt2mwbbS3+EI8sJbf2/9bs/z5RRyerWAcg3+cLjVP4U6U9Y1AXz0s8WNXedh9G4vFS0+3sOfJTQaqYmh0mFUJffA5BiUcGg1tRLW388HLDSNM2omSjye5XiAEEypygpF4kXcrekTwj6MnhTkt/D9z+w3kwNoDSwGCIYTtoQDfjPAQ8jUo59YjCFcxfsrj5h9NWdKTIj884NfeEfrESVkzXrktKnUU6sB9wpOUYzPGGYfqEM4NdLw6KvzI3pkwQ4+8QxR00stqrr38xsborM/zXLNlNowAjJPZKATXXie/R5tf/45yFgPe8QOIlHfO0mp+vaj39lbxlpExxAUb2+XrkN+GVWaUHYRYkzYlL+ploJu/HlS14sAjkSgq48ToSpMI+RX4RRl2uErNrZzizgAcuV2VEgj9pk7cX+NNR+DfW43bTDolZ6D5tJ0n48vrcvtv2m4d6yeqpKt9fRrXrRKMgbiEXsaT/AhtnTXouO3kbkZkaYXE7aGBLvBfo8/4XjTUAcvBc3blEGDn9IFe0YR+jtm407RStExKaoAF0
 fO/7f2m/
 eHcSgBDV+LjsD11uDLtuOE9/oWxXtzcOEchAWXcRHiDRv3uuahHLnUyqWSNt1vD1vbB3AM8wmlU52gWtVNxe5k2fzhtHwJRg2yOROVtsmqHwRE1OzdIUoM1xjSqt54HhNAvhfnMmoFpC9Hg6VKG1/M86wQ1b7zS3UKJms8IeqC8OftAqv473TESafFXpQkDGHaGa7W8IG+uG9OUSH31BfLbutkY1vuKFCY+NiFgg3xKCnfVQBRyW8h+Mvf3ulIVjfLpZWlUxIuJRAOt0QggYLdbGhA7NC/GahRsmsmVd5c2rgvRmnKuNJK2fzWOzbQlopfkobEMSBr35RmQd8QTR3QvDeCFURS58kmZnnnSilaeVe9y9AG49ylyn4fQkXdFwowLZ1G3rGpLYxbf5okiFJeJsm513H/1zVvrfoDYUJw1EaW/3/s8iVZ9EBZ592GFFyYpafOD3ojf3idDznyzTd26+iWTpbYMR5uncQN60n+VIHRMd3wYGufTxpVlaRQ/SMMns/amP19tUohA/pZE3Wy6It4h2DzkMCf2p/h1dBYVti6TGv3SDkZxeOvFHacDaM4/zFQJOusn6GRRlDirfj/J8D0Ot+6ZPv1iqUTa8yB6733vM5ZHHmAijOpRfV9NqH07R8MR4ctmKZsDIKZ8KYoD3w2vr2zg/rfbMTG2zTFQ2EHBKBcySu+SsVrziDd/mJIfQXK/lmRsXZ/Nb6evsLekdbTQmy6FQNxKnVcBZd8aPe0W3PtT7W0sxpk6Zpi5F5F4paoojxjDrIxFU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 23, 2025 at 04:09:06PM +0200, David Hildenbrand wrote:
> On 23.09.25 13:46, Harry Yoo wrote:
> > On Tue, Sep 23, 2025 at 11:00:57AM +0200, David Hildenbrand wrote:
> > > On 22.09.25 01:27, Harry Yoo wrote:
> > > This is all because we are trying to be smart and walking page tables
> > > without the page table lock held. This is just absolutely nasty.
> > 
> > commit 175ad4f1e7a2 ("mm: mprotect: use pmd_trans_unstable instead of
> > taking the pmd_lock") did this :(
> 
> Right. I can understand why we would not want to grab the lock when there is
> a leaf page table. But everything else is just asking for trouble (as we saw
> :) ).
> > > What about the following check:
> > > 
> > > if (is_swap_pmd(*pmd) || pmd_trans_huge(*pmd) || pmd_devmap(*pmd)) {
> > > 
> > > Couldn't we have a similar race there when we are concurrently migrating?
> > 
> > An excellent point! I agree that there could be a similar race,
> > but with something other than "bad pmd" error.
> 
> Right, instead we'd go into change_pte_range() where we check
> pmd_trans_unstable().

Uh, my brain hurts again... :)

In case is_swap_pmd() or pmd_trans_huge() returned true, but another
kernel thread splits THP after we checked it, __split_huge_pmd() or
change_huge_pmd() will just return without actually splitting or changing
pmd entry, if it turns out that evaluating
(is_swap_pmd() || pmd_trans_huge() || pmd_devmap()) as true
was false positive due to race condition, because they both double check
after acquiring pmd lock:

1) __split_huge_pmd() checks if it's either pmd_trans_huge(), pmd_devmap()
or is_pmd_migration_entry() under pmd lock.

2) change_huge_pmd() checks if it's either is_swap_pmd(),
pmd_trans_huge(), or pmd_devmap() under pmd lock.

And if either function simply returns because it was not a THP,
pmd migration entry, or pmd devmap, khugepaged cannot colleapse
huge page because we're holding mmap_lock in read mode.

And then we call change_pte_range() and that's safe.

> After that, I'm not sure ... maybe we'll just retry

Or as you mentioned, if we are misled into thinking it is not a THP,
PMD devmap, or swap PMD due to race condition, we'd end up going into
change_pte_range().

> or we'll accidentally try treating it as a PTE table.

But then pmd_trans_unstable() check should prevent us from treating
it as PTE table (and we're still holding mmap_lock here).
In such case we don't retry but skip it instead.

> Looks like
> pmd_trans_unstable()->pud_none_or_trans_huge_or_dev_or_clear_bad() would

I think you mean
pmd_trans_unstable()->pmd_none_or_trans_huge_or_clear_bad()?

> return "0"
> in case we hit migration entry? :/

pmd_none_or_trans_huge_or_clear_bad() open-coded is_swap_pmd(), as it
eventually checks !pmd_none() && !pmd_present() case.

> > It'd be more robust to do something like:
> 
> That's also what I had in mind. But all this lockless stuff makes me a bit
> nervous :)

Yeah the code is not very straightforward... :/

But technically the diff that I pasted here should be enough to fix
this... or do you have any alternative approach in mind?

-- 
Cheers,
Harry / Hyeonggon

