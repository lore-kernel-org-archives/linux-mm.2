Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4587D3EE89
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 16:29:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3C536B02A2; Thu, 22 Jan 2026 11:29:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F13AB6B02A4; Thu, 22 Jan 2026 11:29:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DED186B02A5; Thu, 22 Jan 2026 11:29:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CAC556B02A2
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 11:29:56 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 97A6113AD4F
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 16:29:56 +0000 (UTC)
X-FDA: 84360136392.07.E46A29D
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf09.hostedemail.com (Postfix) with ESMTP id 27F7614000B
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 16:29:52 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=fWCbhucp;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ObATRkAS;
	spf=pass (imf09.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769099393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CUioa117SRGneeloZw0y7SurVvLf6nMAmprk90Zmrsg=;
	b=MTMZ4ZGox03+1E7hI+Ud8kELY3C7aaPRK0hGUhLAoIO41HnPT0y6UIwfV5OnMEKLu6Byiz
	m78E/iySlGnC+34dtUnh5hlqAq1+RIEsTPEdjPsX0aaAt2bB5px3Ptxf+ZjG5xTqV7Sv/d
	um5T/zI3zBTm7Mp6z3+IQmrtYX7j6Do=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=fWCbhucp;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ObATRkAS;
	spf=pass (imf09.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769099393; a=rsa-sha256;
	cv=pass;
	b=UMbb4999pTSocMQDor0WUv1B+rXip0rfzDqKPTk/wMPofLwK616xvsxR0dvv6puBNyiMjm
	199YevQ8hijSDBU8nk/DWvHxjIYamA3+kVG0rxsRuAqkMeUX+C45sxUEdfOfw3DYBXB3wO
	qsm8lBrmG9ZgTv8m3F2RWGzDPSknEII=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60MDgIdj329262;
	Thu, 22 Jan 2026 16:29:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=CUioa117SRGneeloZw
	0y7SurVvLf6nMAmprk90Zmrsg=; b=fWCbhucpgn/8ibEeJGOkMao7/Dn/9vgBri
	zPdT8lNd3B3BB3Xn1b07ULxfXxZheDXDk5RUVqBlCClAo2dnUo33f7vF7m5zReOM
	klIn4z/+4LvC6qTHGqJZlIHee+9JUi6QTSEp9gDX6XROXBbsxCBfllBH8xUTnDxa
	AanBF0nXiZ6fErRptOs+LV5YJY+zYOyAD0RuDBjevAShesVQT5xXez2GbmyZVjfg
	XvculZthq0t0RzpSw4x7K+4ptlfwQrp1lfGGpCZ3pVUCABcdrla1Iy/+8TKO2dyu
	FhsA+JV0ySn8i7PtBafg8oc3JsZwADkAoXZ7Mi/jl2fcj7WSVzQg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4btagd4htb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Jan 2026 16:29:42 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60MG1nF3008426;
	Thu, 22 Jan 2026 16:29:41 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013023.outbound.protection.outlook.com [40.93.196.23])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vd3rpu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Jan 2026 16:29:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XWa0X/9/Cxv/LGq4AGJQPBZpwVCJwwzTNuIZQAChXztMhpoQVFZre4yVDao4w2tXumvOXTCMEDuWuwMNlVPMMJVQf+YtbTOyNzZW4qXM/po7vUBX/FoqIFId3C/v5wZI3zjCNL6zjqIvvjxIhSf0nE2nhjvlgxPDyjPgvz/Liyco9FNz7hyxHac46tOEhuclvo8AMxtgT7l9VTXE+cyaI3dM4DWU9b7oluSpGA1LhHZJJXlnSw1h7CjbjS3+0TzyJXVelTPlu2v6m2mrn26l5oRyR3VOu+nw6+/qzYqj1FFor8OmozPl+StLrGcN2jdWfP96nZXeOKu0fcviEZcHpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CUioa117SRGneeloZw0y7SurVvLf6nMAmprk90Zmrsg=;
 b=LGh3mFmmMW6a5CXtTu3CsVW+gBN4g+gCy8xlSUgt1umKjPNfdwJ+SMHxhqASjYJKt5PeFQbRQVxDNX7cvHTi6ovL3HD054l8ZrhgHmCk7oOo9EFVJpHbldfU4d/NjK4r9nrniwoaYbwSTYyJQi9nDfKFUfY+2kvy2gkCVEguAfM6SxtDsTBGIlkSlT5ii4BpEknN/O807HWGUevYVK0O2cBjgwNnH9TMqkemxHHqp934jxRTyqGZ9esuqkAOTwoqsWy5GR21sMjEIzucoxCe3Zs9vmtfwzaKLG+QlbC1d3EOH9ijMZ29SwRCG0bIJfksfnFFq4N8RATwgfLryVMlwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CUioa117SRGneeloZw0y7SurVvLf6nMAmprk90Zmrsg=;
 b=ObATRkASZp02U+TNEE5hw5Qtsu0w2r+VdPX++M6qk9A4DM1fdQMm9wqJUZpOdmS00KCb3Zd0HT217m+UTZAEA2XZCXWdFaBHuANYaeFvArz5/BfksA0i6GCoa6Hg8qyI6EQhpjkOLgVTuDFnNQ1rkQWuQ2CubfOn2CrJhC31hFE=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by MN2PR10MB4301.namprd10.prod.outlook.com (2603:10b6:208:1d9::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Thu, 22 Jan
 2026 16:29:37 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Thu, 22 Jan 2026
 16:29:37 +0000
Date: Thu, 22 Jan 2026 16:29:35 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-rt-devel@lists.linux.dev, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>, Waiman Long <longman@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <clrkwllms@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH RESEND v3 01/10] mm/vma: rename VMA_LOCK_OFFSET to
 VM_REFCNT_EXCLUDE_READERS_FLAG
Message-ID: <3ac3933c-8fc6-46ee-adae-e7609b5f6d4d@lucifer.local>
References: <cover.1769086312.git.lorenzo.stoakes@oracle.com>
 <f637c1a5c9ea237aab598bd8885df48e21497635.1769086312.git.lorenzo.stoakes@oracle.com>
 <6c8b63cc-d357-4e70-89d4-07afd004bc83@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6c8b63cc-d357-4e70-89d4-07afd004bc83@suse.cz>
X-ClientProxiedBy: LO4P123CA0628.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:294::6) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|MN2PR10MB4301:EE_
X-MS-Office365-Filtering-Correlation-Id: 94b18820-153d-4e8b-d527-08de59d36f2d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VA9n1hnqMiv6aXlvxl9NJ8XVaGHTx3p8YyyL3NXSEeUZzqrU0/OEil2vGsTZ?=
 =?us-ascii?Q?LaA4j7Z+BxOygloyPTtiHAqJJ0aYQfoBNmG9rDm6JWcL4IYXDda54CdlOkb1?=
 =?us-ascii?Q?w73eSS2AtLN7Q/C6iD0upkw0dH7ZlFx9f33NfliE2Oty+/UoaOYNQms93yag?=
 =?us-ascii?Q?qV/Ha8hDzyaolPrCDdWd9J3k0ttHhGycAKQkFFDcZvIkfbIgHVIcYjkI6zDc?=
 =?us-ascii?Q?MJaNWL+jO4KlqTaIN8rGlAoq7pjnqNbNeDDArfvztm8KKD7mPX+NmMlKczeV?=
 =?us-ascii?Q?LeTrWvMFiYDtLw96KhGIgVstbcPkpHDjwLQQnIKSK91TL16jLXqhMBesEA//?=
 =?us-ascii?Q?OQ+ZSqg3EYSfydBJZ9XgVA/0pH98kA8/rCdzsg3I7MsWqi/C1x4CrSP82Om9?=
 =?us-ascii?Q?HruyDyCG8ERpsd3uJu8WZysSNZSkOuRylEMnADMV97oCQDiwE68iAwlLsjZw?=
 =?us-ascii?Q?8274Pfes0ZmvlQs0UUQznbkIX4k2o1wG2XpSVRbFCqL8euQTHHBjSODXjeG2?=
 =?us-ascii?Q?anKsPxxHXodDYxp+UvVA+1038UnRk/ohGo56vn9tLr2sojhEvMCwO9LSOFtm?=
 =?us-ascii?Q?zw4e+VdLkjemCYyeTpmxoIWASI2A3E6SS+e5kXn7rY4iFKd6T8Q0Pmt49Tf+?=
 =?us-ascii?Q?SKQyZvpQxGoxbsjAW3jsaKP5amW/FspVGNfIX1n6Z0KuSojJz9ap45pq32sS?=
 =?us-ascii?Q?aKI5Gy09XeewscdWEa0HuTLFXfFvO9BMFQrjklbcnnjVIc0aGFYJvHJhqEpI?=
 =?us-ascii?Q?IGKRp+x3AOqPyM9eDsPjoLPk3jNfxkaROLgA4Mt341rhn1zVgCqRjHbQedGZ?=
 =?us-ascii?Q?T8b6z+MPEVjRLnLLevEHrVEHTqdFTLTN0pp3g8GxdKFlPSwoMyR46ixi0chf?=
 =?us-ascii?Q?CdrR30RzpI/9cCnLQGmcIoz6rlWv7FVpNBiQo8g1+UgScBl2yBVXb3XWLm+S?=
 =?us-ascii?Q?GdyPt/no9SKk2UjOqUflBSxtedVTVLFZXwA2pbC4Kb/z6wg7p1bKJqE9oV0p?=
 =?us-ascii?Q?GPx+G+SYDB2r3kkH5FTvbHFaCqHcaXmpj1gNhfYNEg+zEJATp6ITsnmi4QJ1?=
 =?us-ascii?Q?qVl2VkRNT/iO9h9gAntoVavc82nGW0QUgLJ8z9SlEHIhe790HYeSArKBJ5xP?=
 =?us-ascii?Q?CljX7oReL6Do4oSYguNYEP3ZoQT0Tphyex7PPtJFUmJCV2Wsdmqvexfk3EKL?=
 =?us-ascii?Q?SzBFHKzbGex77cxDJLEnRcAhw7vnXoK6bH16sCDYrpp06kUtXpiJdpaNRt1Q?=
 =?us-ascii?Q?hCCiQaSEcJ6f6suEu1GLi8wwYObXetlWUNeA2Y5kGNbGf6p9oYj2YLgupBOV?=
 =?us-ascii?Q?kvC8Tlee2KIIKiaET5LV+KSQiI2diVBHrGy7jczUUJQdJTRVnvyxLOMzBU0B?=
 =?us-ascii?Q?ikcT5InR6GvRS0VpcdQ/XiaqOlueBuqnUvjV6rtyb2QlBXokTheINBM4Bamz?=
 =?us-ascii?Q?NrL/m0BhHU6CIR5cTbCAH7EsdoRbQvid9FEpRe04uGdLU4t9H2cP2j8EkWy6?=
 =?us-ascii?Q?cC5uABBB24l4JTmzSDUFmk9RsmljrNvahAO/KMC0BBzcp0BAspPsnlBr7blT?=
 =?us-ascii?Q?4jKaakmYtRv9y4RJTEo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fVYwzOk9i/8PRz6dfLNuTVGvlPodN6ujyo2Rt/N2Nln26YGf04gigC1pdu5s?=
 =?us-ascii?Q?Y9ymE8dzo5cnSjEtbXEPQnau73bpi4qH6g+C20FwYZGnxbnMFsptSnVln+rx?=
 =?us-ascii?Q?AJjWCvFRD7vNBFWtOvGL+VoznSTJBNCieppNMjY6N9A1MdYCy0XLgJe7OtCc?=
 =?us-ascii?Q?PMzQV8VdibfvtBN9N2m/qw+g2UYYQLlsLjZFxwUXXR1lg/HIGc7hiHzKZOQv?=
 =?us-ascii?Q?qSHRjnG9qKbx7YejDcUXDuspUnmttKuQLX4HAsXyrsy4GJhDjGlKSYhkL+bj?=
 =?us-ascii?Q?SLUBRC3ZTe/nG40WABQ7SssL7PbLnZ8J0hmhRQYCT15a2ifNy6vuZVYKNbLH?=
 =?us-ascii?Q?KCttkDzNUQGVUDOyUQatOcsQCHHIu++YtazAUOHAgjDGDaMTFBxYjORVuDx4?=
 =?us-ascii?Q?M6Se6gVXM97t8Z+gwJLFqYJDV1SRru74Xgc8NCldsk9cgfXP0z/UC2UHVqOA?=
 =?us-ascii?Q?meiXPfwynnlLO1u75AXB6EFQR7QGkM97WXamB1GeUobOXfD8BlVdcs4Nluvw?=
 =?us-ascii?Q?/hcXBBJTP1aa1rCV2WWouPHgGhAQuYLbBWBP7XQzhukYvLF8i2XITHG8LP2d?=
 =?us-ascii?Q?+aSY4umGVZoWxAuxvJExoPl3CIxVmhrwxuDTngXdaZDrOJ23mrIAvolqHGys?=
 =?us-ascii?Q?Llb9dkTWYsmcfNwppilKMpBPcj0hli0vztLrVY6k0c/Er8A55iO4Y1x57B37?=
 =?us-ascii?Q?lICpiXpmSZ3kHY7XN6gjYyfD/cbHDSuzoAJJE0mlqo8W91b+5PPLWvsCWa1U?=
 =?us-ascii?Q?m/BrrhxRf4x+njkmxXgZgjRI8NMlhKU8qF1YAoXgEayZzXQADM9O+5wG/VFh?=
 =?us-ascii?Q?GjtO/NNwdwLG4ZEdrgTpqCzwHlz9TO0IZtx5BpyRvyzvGIChk17qbb9jqaAY?=
 =?us-ascii?Q?l87ukLGEcOFgg6hF6QI5LEJHepBkxzcTac5zc0YJP3IdITLusg9ZcO+gCu2m?=
 =?us-ascii?Q?TYkQDcUdujvRano2caQ1djwpMCJZvFCXuDR+KJrIIakv5u/++zlY6ufOxhs9?=
 =?us-ascii?Q?TXk8FtuudHURfLOaoUi5lxxiuZ3zo7fE/xFnaAMSifw3mXSPlzxWLenxh/nz?=
 =?us-ascii?Q?uBesC7edCB+YAx8qHTRPscRelul2ehC3A5AIakma7rRnj3jtiDZkw0RJWCMM?=
 =?us-ascii?Q?XrT/1uzkSJm/YEAH0eYy+Ji7bwvbGSBZtHZS222pN7f4wNNbBukfSEbl6wEp?=
 =?us-ascii?Q?e9cpvVZ+9QtUyDxZA3NvPekC3lQcHALgWGzTXh+MH35blegF0gR8dyaXzdyx?=
 =?us-ascii?Q?VchvxR4BjIf3gjbiEp5FpPznopGpY4SIscYCmqmk2BBqHrz4aBvUgF1rx9D6?=
 =?us-ascii?Q?lv4RGNxjk2g46hUE0+VigBvjHAHyy+P3mPjkkN6uYWk9w/cng4nqTVdEkp0E?=
 =?us-ascii?Q?R59N2F8ozaPefzLDx4BVHegFC311H1NX7jp5FyiEzDAsCzMethTSB52MYo43?=
 =?us-ascii?Q?WzEhdloNl99g3Ah5CER2+adFY1Pe9aw4mIHjkcVOxDZU46TKgVK9+iSr7OX1?=
 =?us-ascii?Q?cdzgEsf4jX5yLZkhUlmzIEvBqk7gCwZHzezmI5pvm9sFOAaJ+NzgDUVTDfSt?=
 =?us-ascii?Q?fbanrxQYxKR7olMGaInzC7V0d1hujsCGcOB40I7Q7VWzPXp7JDrmDEwl0QGB?=
 =?us-ascii?Q?wQJoL53zBy1SdZjn7TMSAXvYlGCwIq+zhYl+7UPX86MQQCHhSp2Tf/Ezwa6a?=
 =?us-ascii?Q?1Gr2h4gXs9Y8cnr9E8MwjjwKhXRpZl+qLK009mX3NWYsh/Ez+DBO8RReehFv?=
 =?us-ascii?Q?oXz0HaYS83JJv0CYdkBgQb2eS4mqP58=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	KWhdoWtk9dHAfE+FlM/2YnzgyVHvO+RX4XTwDei6jsnp+G/0SAga3mfUXudHjOOPyq8p06mKS3mi7sxWwRmAgHwypUerzIjjMPFM5s6MVhsIE43WHjvwoOeQ+7ikC+oKKcybw8vCOGO1JXCVgazS4XM/j69chzSyIjo1NAAf4kt4jI29Ht9m27L5boRouYwy43zWpMQGfPkVhbfNXjV07gGWwUB3Hhp5KHvEVBesh5hvTKRnWAqUwT7u0E9HUHPGh77gpcLYTjKMF21+SMRy7EqN0Ys1zEwKPhaUr+/1vmp7GVCsDSPOIKLt9qDy6HHWI850ZgBwKb6r328Y0ebRkrAbRqmaNyP3kUguF3Aq2J6DZSyl5WUcewLeXXEUsekoMDj989raXxEqDzC1sMoGWrMkdoxOcjvqbzcyj7ijPkk9YjnClIqm8qsah1os3dcyVYEq0a+rG/jUe5va9mdFqRvIqG5PTc1dMv4ROvMB4zo8g1i795wTrpE54kRBep2eatnwDYGp+2vWItCv8q1g84O9gRyquwyzdJtNOlthxKsNOHzru6DcS8pUahbWS++i4CnVkbA9rPlP//ggaXH67Sy+JO/ykbZ0Ttofx+zEfUs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94b18820-153d-4e8b-d527-08de59d36f2d
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2026 16:29:37.2449
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BjK3AXd63yPASQC32Vm0Pc0OlcVn+YxOrVFl+g3SwUwl1QEid6tV3HaRweBA3cIbexS5gPdol318zGvDNa2wRg5A9zsj1u2PS6p7lpEO+RY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4301
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-22_02,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 malwarescore=0 bulkscore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601220126
X-Authority-Analysis: v=2.4 cv=PqqergM3 c=1 sm=1 tr=0 ts=69725076 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=WoGeRpuAiGcKsidhEm0A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: daRAB0bCNuJ9ivLOuHautnOasQlIhs2p
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIyMDEyNiBTYWx0ZWRfX1EjHnS9CWjRf
 sWRmVINhOXQnWg9grB1kw3lSIVxtqtc1nQFW80NwkPJ/rkXEkfOiiGCY7G4h04M/todkmJKBr6l
 na/1bCld+aMD3032CxksxG9OAVKB90/HJb3112dui1CPIe6B6MRhI4gt9HpH7tO5VBFauvwoIuk
 SBhdLBZcRhYeriaPjkws11lnXtXuHSk7sdOSQFvvIUOHVrirX1YIQqjpEIb9RvKpJ1h48D7BZwp
 7s+yH0ITmHwTcNztYXcdpmB7GSMLLwfOJ3hHM33TmGjikPKeCPVAYar2ekaPwqufkVfDewSvyO3
 wQPizgl4Ko/FnvsXAWLw5Xg4eP1pBntf1FQuVUiL/81hTRYtWO8glujBvNijBQTVBwbdVv/W1nf
 iXxM8wwEfFUgDNRR0s9vHVYkqTFUy7K8Zhw8Os6fdI7N5VsQtolg/Bc6RizPh5KcaqCd1AcTRIa
 WKrYUESiTNZU1cEkaug==
X-Proofpoint-GUID: daRAB0bCNuJ9ivLOuHautnOasQlIhs2p
X-Rspamd-Server: rspam11
X-Stat-Signature: 4rmimb95i79ra4rdmzoxz88nrhbx8qx5
X-Rspam-User: 
X-Rspamd-Queue-Id: 27F7614000B
X-HE-Tag: 1769099392-56847
X-HE-Meta: U2FsdGVkX198H+U4YAEwESQHWnBoNbb5bx/8GpwZ8jNfHeM6sKHUmHyYP8QJiApezsyqBghBw3FEJPiXZTHDFsHulLRldwl9xqw+fzt0pvlz1RaM2odUuBukwWQrZJDUfIVXmwioCi1I62XjGPBhjDwMaqG/n2AZ3BCDJKhJshxsJfzoscAKA0wpFxdtYVUh4a5EfkWtPRUS3vAYeegyHJPV7LforyjejiZ0Tfda+rH7Y0Py5dJJqGaru9523flIQmkc/hR3cTOdUXAC/d0pHJsZmKQD9YElfmp/EHT+P+xXDouvQq+aukWvbuLxRIQpRtAZ6h1EUeg96+ta5aKWLw5MrNNelAht5oo6vXTs3eoogBL+v092ecyJgT8Z8vMUYazJkQ/kjGivvxRfdFmeAwRcjl033aOloaX+x+bcOwY+B5ERa3siHjWrPt1L1Z5wK5nk8HPJx42IEzSgpVb91gkLWFWpj5rJzyJEfPw6UBhhpez2LPtBORt7ZLIikHq8WR8CK+0x2Rh/ygq2wCHjlmO/t/5/kxasbGnajNIO4uXI3jWDh2+M/564AebECubJjOLvVD4Y+bM0V1geQkcKirNNjWxkbsYFTkm3ttnChB0i/K9cyZVsHiuzojJ9JLNbFRNqyhfqR5QhslLtiz0yuPrYBLrfwwUxKS5S5Mz4hQpQD7KUDCjt5VyH6wiD1tVGLIDk6/IqZTr1jYcs11wthKsYXIj7VStF6VRouaV7MHCS3b7rWzVeRfqYKE5Py/7ewnVWosk+mXdAnUsH6wipa7Z6fiokpCfNRgdiR8rrlzg0A6qznszJGA+jcRX7RlaYuQxgb9d3r0Hr1sgMvdEmHYnWdYQKCSELTzf+xFndrtYnjn3ZX8j5wWPjr8RQqAyGbTg+tkQEH8baGu0qzYwZDeTbMO3IhmwoR/krWkS9JjNQWK98bF1OnKZD7pSJ4DQL3fmq+4K63brOh5LDaSM
 iqjHMSkp
 L7+Li7ngSRQprUceMn5+TgJGTVcPClZ/Bjq1c36ST1SdLxc6Jo1VdbrgCzahU8xY2NTY2V3GVrupKMGm3rzdt/XJn/l+6QPA5Y81BaLZLSWGtStVObSLZPUYT0VHyFZQTcTaitS7jn1V3mJ/AZUWksV9Cjv7geX3BEeVMR0KJE79jG+3oQe9jvH78ZgldoRS91lt/OHyAYCCbzyo44CQr0NXdGZ2KYn7h/YPTYIK8eM35NicVlQrB9tlMtustFcVH5nbWxgYvklMJn/DP96m9NPSQHtmdVTbVgBJyytN7FomavFH9Cvbgqcmh9q8mUDXY++4QHMBlPGa7eUJtI//DvkFFMFhBG/CfzDfvW+FzvT+zZu07PHozjDYz/d58kKsQwEzAazfB81bWlEHt4Rid09WnQDe5YjyNGsdOEfcLfxjfo0ZSJcfn6RD8ox0U4rggprjb6McgMbFfoKAgsp4ZpxlUrBr9Zn/LaVU9GU13je9/aZ2pWZoEvL9UTqgHP0sK4NpcqHFtGQWQZxKQLDhqh9QdukzPmebz0UF1ShDD8DFvDAPBJohmhRQz8ZPjAStaZpuKAvbgccAFStx8jdxCVNVpOzjveSkAY3UtY2Uk+2xNGmE1nuTSjnHTIKmaXofgmbSQ4+pnsY9FPNh8tr1aNpXT12QXBriVQNaD0dfCYs1OZH1CWxuY7I6VvGSvLUkcQqE732JzTe6Y+HOGk0yutZs61yxes1KVtG3s
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 22, 2026 at 05:26:13PM +0100, Vlastimil Babka wrote:
> On 1/22/26 14:01, Lorenzo Stoakes wrote:
> > The VMA_LOCK_OFFSET value encodes a flag which vma->vm_refcnt is set to in
> > order to indicate that a VMA is in the process of having VMA read-locks
> > excluded in __vma_enter_locked() (that is, first checking if there are any
> > VMA read locks held, and if there are, waiting on them to be released).
> >
> > This happens when a VMA write lock is being established, or a VMA is being
> > marked detached and discovers that the VMA reference count is elevated due
> > to read-locks temporarily elevating the reference count only to discover a
> > VMA write lock is in place.
> >
> > The naming does not convey any of this, so rename VMA_LOCK_OFFSET to
> > VM_REFCNT_EXCLUDE_READERS_FLAG (with a sensible new prefix to differentiate
> > from the newly introduced VMA_*_BIT flags).
> >
> > Also rename VMA_REF_LIMIT to VM_REFCNT_LIMIT to make this consistent also.
> >
> > Update comments to reflect this.
> >
> > No functional change intended.
> >
> > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>
> Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
>
> git grep tells me VMA_LOCK_OFFSET is still used in
> tools/testing/vma/vma_internal.h but I guess it doesn't break the tests?
>

No :) I update it later in the series but it doesn't break the tests so no
bisection hazard.

Cheers, Lorenzo

