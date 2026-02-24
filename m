Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDEA4EFB7F9
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 07:49:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 447316B008C; Tue, 24 Feb 2026 02:49:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41ED56B0092; Tue, 24 Feb 2026 02:49:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EDC96B0093; Tue, 24 Feb 2026 02:49:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1CF5B6B008C
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 02:49:45 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CA12C1404BE
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 07:49:44 +0000 (UTC)
X-FDA: 84478575888.04.E26F41C
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf06.hostedemail.com (Postfix) with ESMTP id 27960180004
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 07:49:40 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=NmIuBNcN;
	dkim=fail ("body hash did not verify") header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=rOK5prCP;
	spf=pass (imf06.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771919381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eokQVPzqcedcy6WXm39CYlHEtG4dgzXbJhKYBABuAz4=;
	b=Tl6/aH/E7M8rg8kE5hGbjGzS7P/EFGJBc+g6f+o9YwkSyTb1VBh6GrsrszdeO6OI3T97kM
	udOx3U6j+uW1AMNHS+U3kvV4BHRpqlTDbaI/D68Jo660IZ4PoEnQszsxaYbk2Qt+hmVfH/
	iYq4WgB/EJsKmSJD+xbTumiqpJdHDaI=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=NmIuBNcN;
	dkim=fail ("body hash did not verify") header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=rOK5prCP;
	spf=pass (imf06.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771919381; a=rsa-sha256;
	cv=fail;
	b=dGjNoVG6vTPT6jv+mAacHQSgg4Pc0a1rb+Iq5kukBPfhtGYdPGTc5EY4retAYP7APjrW2t
	3XygY0ZMP7lMzYATKM1cJweRd5Qw5d1Y04N5FutVZxE8gTcT3UAf2pF9K+QtgbjGXbRzrT
	yjGmSaaBUJ0pW9nS/YrfPcDjL+vROfw=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61NMvNrT2050199;
	Tue, 24 Feb 2026 07:49:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=eokQVPzqcedcy6WXm39CYlHEtG4dgzXbJhKYBABuAz4=; b=
	NmIuBNcN9x2qWU7k/B5O2U+x7Er2VdqkQmKBQvVa0ZFDy6q/Eui4GyKDrtBRMzoa
	ZnbnERVOPEV/GuJEpw0wk2XBnk2uf1F+IVvo0d6zfrjCIWBVcH+YlFGEWODX7Usm
	LpiDFKzJPHHE8eOopY38SNTr6lcp6vhpEkFp7KfHfOMtnE8ja3c/wwe4zIZ0LKmN
	Cok2plmKo3E25mVe3tHxCjoM1i1f+VT6PkHm0Mv1+j0Q5ivG0cIeR13Oi0IHWYi+
	FIbNdpB4dRpA6zpZY4Xj6zWOH7kozQFWNcfynZx4W747MGuNZtCp++jV5mTXAVeo
	QwX4MTpZsbJ4Pcu+jI71Lg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf3a03skw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Feb 2026 07:49:37 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61O6L0bV028524;
	Tue, 24 Feb 2026 07:49:37 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012036.outbound.protection.outlook.com [40.107.209.36])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cf359cp58-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Feb 2026 07:49:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZhcKyN3SK4eTmxqsaC03efVRjQb9fFKS0ewSshi1hf7hil6VCyqkkP742RPyCUT8FA8mKrtQ1mYOXCN1aOH41c4de4he8wS+0Ddnv/r7gG8+PIKlwiCxpIbm25Lot5Eni5hmQDg3LfrsGltmHmqwu50U05+5t/dsrqZ6hBfrey1G4v1sHe2xt4QF8lltPZ6Cx+06bdF5SIZXLAFhG1ZBGiebGKLUmIr5x1bDtgZ9a4MR30pph2OwE4FUknCseP55c73W1+xuH3Ybzt14XDTKg8lQGVDuRSSPiXY5v2LiP1bkuNRQEx1KhizuMEWdjhepP7sM4okvBR3bBdgm9twk/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2OYWpXBHbDCx7MCN/K5/qo4uZRjCevFoQKO9/XvbO/k=;
 b=Nz0sgeKFu1PoXvk9XN3mRV6Z4vFDgpgdhoRpGWgjy3BYwrgNv2+Vz8DFbLBnLiErwpEmd8mdgYGroHdL4yLlGEcQDtnmykeN+an7GK7Bq0qYgrj3JdWUCacERQzC1RQRAXK/wXFAeN+B3bI1yQrm00eN2+j2kfOF3Zx+ac5ipusYDQSCkidVG9yVS5QovebGg8kp6druAi9/cAwUYYqqRb5IwpmvveFwasJ0/4YaTxonONfeVfmiUYeANImHDYND3pEAOJh7YkVn6UbtX7gzXRw5XQMNGv4yZxbsLomkrdon9ytPB2boL1MCq0Rvgu0SEjaP8BgnCv8SP2r6ZAPx8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2OYWpXBHbDCx7MCN/K5/qo4uZRjCevFoQKO9/XvbO/k=;
 b=rOK5prCP0tJvoyiSDHlQgMGJ29zW7+w7NP26OyP69raoKvymWecfbv5IOEp6OG9k+7+FUQs2JXBlLYqHEOOniqNHMO/ydoRv+jijreotbpqFC4nfRjTkpjgqFqKiBD8IR7ILDHD0GA/vq9PLLraGeQ/mxcmpKIscxr98mHkqv20=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by MN6PR10MB7424.namprd10.prod.outlook.com (2603:10b6:208:473::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Tue, 24 Feb
 2026 07:49:34 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9632.017; Tue, 24 Feb 2026
 07:49:34 +0000
Date: Tue, 24 Feb 2026 16:49:25 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Thomas =?iso-8859-1?Q?Wei=DFschuh?= <linux@weissschuh.net>
Cc: Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/slab: create sysfs attribute through
 default_groups
Message-ID: <aZ1YBcDVYrfVmhap@hyeyoo>
References: <20260223-sysfs-const-slub-v1-0-ff86ffc26fff@weissschuh.net>
 <20260223-sysfs-const-slub-v1-1-ff86ffc26fff@weissschuh.net>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260223-sysfs-const-slub-v1-1-ff86ffc26fff@weissschuh.net>
X-ClientProxiedBy: SE2P216CA0140.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c8::16) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|MN6PR10MB7424:EE_
X-MS-Office365-Filtering-Correlation-Id: 949390de-64b9-4dea-8389-08de73794060
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?axTzO+Rn3gRvvUtOCf1o33qLpz4fwotNIH/F5hVsp5PDz8SRW/3F06GCrq?=
 =?iso-8859-1?Q?ljjb8qW6vEFH84RFVpF2wvv5NioHG72uS2luhs5tJzdVdoVb8srEsPBZz1?=
 =?iso-8859-1?Q?iu88k5Bkcmc+goBZueIEtYYG6pnwYO7DSbHKaj/STBjDwQjOeiJ5tTmlxu?=
 =?iso-8859-1?Q?Wi55tA2fb/WQ6lNdgcmdaKAt1PTcidx+N8d5eUnfHLcQ9uxiV+Hva2njCC?=
 =?iso-8859-1?Q?0HPbIBIlKxLmTYaXfaL5AmQp2Ncdumc0CYqxskOG/2n+a9/XpwuhpHDmMd?=
 =?iso-8859-1?Q?dyOlYULSAWBSt8fUManbBNDGY5EV9Qd1OuWhFkGgv8UCdvk2mn7OtWg5NF?=
 =?iso-8859-1?Q?OzOxSceNTurD/0OnGgKrWhKh7xvPX5KqCnPsEGW5Dbg0D5HrvJFRzLEnQw?=
 =?iso-8859-1?Q?JTL4XfcikUpCdmXGcWr/qQ6GqyL7VU6VxyGTGSgsNbQIQw/3zhzo//HNZw?=
 =?iso-8859-1?Q?WFWJrxraLOTbOqB21Khp0/OSJaNYZhfo5kefPeoosCCN1RqVJdMYUciBbj?=
 =?iso-8859-1?Q?AIqJxU0ua/MiSTuQlRBqplL8Ajpzj39QtV2KH3fDC6gw7v3iYm6dD5rp9J?=
 =?iso-8859-1?Q?KQNyJCdUvLOOOea0kH6q7N+d7cMSjr03h6ZeKeeSAUJNr4nqg2/ZefBLK5?=
 =?iso-8859-1?Q?FuE0FAOlGMJuCm1M1xUmqSfL1z9z/e/7Q+RjmClZNVD4u/xsVUwEwDfDiY?=
 =?iso-8859-1?Q?DUJB0lfE50wqg8ESHxht12JoAkGsItZfeltiLXK7zEOPMpIAvMbzOeo6xm?=
 =?iso-8859-1?Q?Juz59TExBpBDSHBzP+HQXprTcaaWgyCHFupTjCJVWyJsuyDyxe5INlw47Y?=
 =?iso-8859-1?Q?JTPiQzT1vzpvyeJEoheHctgJUGZ48Gwkt7jG4dgVdJmB1sxpYV5WAaVeax?=
 =?iso-8859-1?Q?TeKIyDuyj29SOW6NTeHiwew8rey9bYObQdpEnwS9Y5eZ3wQTW7gEJC9uu+?=
 =?iso-8859-1?Q?1L5yRG2TzPGwhYXiga051Omj3MPhldAhWg12/leQkVUAZIFPPnwZzblnkr?=
 =?iso-8859-1?Q?/HarnZMe81ySFuMmPLfEIg1wqXCyZnQr4b2bIku6dSBGpMe0/Hrqr4dvgG?=
 =?iso-8859-1?Q?6qljh2XV6WyUn8c8foo0fX97n3dLtGOG9xpTXYSvdpN6zf/I2KLsyGCbv3?=
 =?iso-8859-1?Q?W2D1jmFJhtiOymzuAbtEwWAbditVrQM/ai31jxkGhjZVvJjIzjSGY2Ld/n?=
 =?iso-8859-1?Q?1EY/KWHQk087CmH+hJyi2ULj4G6HnT+YsYbRwcGMxHkuKP6HcwXdIhHKc3?=
 =?iso-8859-1?Q?iF3Fup4CiU5QHTc6vyqXYmfsI6OV8SJMH7QAYR3D/k+83RPO4AnTa186HV?=
 =?iso-8859-1?Q?VwnXN3zmSwpV68rFzBjG2sAVJeyAy8eaciVHQVOgWdScHVgrUHYJUI4J9c?=
 =?iso-8859-1?Q?nWPHL50+gaPquTSLCi83eZI9p1/NxQ8MHmWZ0Co2QSD6OXb9KgzeKriNmN?=
 =?iso-8859-1?Q?Um59vEWSvj/AoiTT4Du+wutImZpWTvj9AReB+wqDKFzAqkit2djGDirkvk?=
 =?iso-8859-1?Q?+xQL5hQ0H2j5FxDvLXyqoPJCkRtoQgo4bQf/dvGxmlPrK4LeP2Ip+AjBAA?=
 =?iso-8859-1?Q?Xll1RR7OzjikKxGNI/oDvnJpBY6QTt5nZyjrcJHH/jTncMWETw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?iso-8859-1?Q?28c3bBthTNDvokFIr1Wy82ycwaWjfwfBpjAjONsED2jOXtWwQjPmU6ZcSw?=
 =?iso-8859-1?Q?qPMGjdrZQVlPVd6S5JfzTYDzrkZu2zDk1EVJ8uvBBezKPtPA49/M5IEQbJ?=
 =?iso-8859-1?Q?zIdHK+nguqp2qTvryzncmUlYoZphta3yLsE5zbDLAGlywamh3nVjG/QMp1?=
 =?iso-8859-1?Q?LvaQ3iwfYs16yvo3y0eIprIBJxE7rfDquOkH6ZHcvoxM8kKUxVI0DyAVQS?=
 =?iso-8859-1?Q?d6r7YUDG8xOf7qtwOdOsmEvBSDfhDbWUSVSd0+FTW+EvZVTTWEP760d1YZ?=
 =?iso-8859-1?Q?1LIhdLhv+1+kUzVXaf0I8bV3R9j8em+oTwYLJqmlSWBDD9KPHW45e+42Xf?=
 =?iso-8859-1?Q?cuxpbj4oje2OTqzN92CuSkZqEg/7j9cPZ/8IlIuCuokQUR64hx+3Qg3tcB?=
 =?iso-8859-1?Q?8XR5l1+r2NPBvgHYppDkoYmAJr9mFuJQv0n6I5M+2TX3vegMtILP+Vu0Bv?=
 =?iso-8859-1?Q?X5BF52iP9dMUDKXa6xgoOmq7lIhBOSqy40bivCIc4jU9OXXmKaHQK50vdS?=
 =?iso-8859-1?Q?DJkPX/t12Vs3+wB2pvv5YDwEB1vOrO5GB4fjopeCbwmXjmLHVONr9LkDht?=
 =?iso-8859-1?Q?EQ6VNf8TynldUCX65j6TIc0q33Kp6VZPG+VMrA86ig/xmhJynMj+3Iz0cS?=
 =?iso-8859-1?Q?vGYnN/mDx+K92vsMZwWKMjytNAKQkwvBpv/v5fRRIWo2cB5EpkOYEKG2kS?=
 =?iso-8859-1?Q?DUyue1qvg+OkirD/rwS8Tu5Vq6Lis1AvAgeXwGqN2u1OJQo7/Bsuu/bV72?=
 =?iso-8859-1?Q?9CnODUpx3XqjCeLGOAqvZvRUD4rQEKPpiSb1gUdtw4IZ+/kfR78qu5+D+L?=
 =?iso-8859-1?Q?GtfN1k+52XCV0s60u3vTzWJL+eRgrAhtMPYPZFCg62GL3Guy9ZioRP1gFB?=
 =?iso-8859-1?Q?qGVPhAKns5xdHDWFpFj0O4eMbgxg1srPtYoKGuQ281g0eY/vFueYXw7AAf?=
 =?iso-8859-1?Q?0ES+argKUmkGT/46EY2aPcSGZx5v/YXg9nl5ln98jgXOU6lowPKCH/FH8u?=
 =?iso-8859-1?Q?rzZn0bh1C8HgTrHF5Dmg7GdPPVINcHZoKvue+tWSnqMvmV+ozB9kYVhBM4?=
 =?iso-8859-1?Q?RMWLqJ4mXzzDqIRtX+wmbywvPR2hwgW2xpMQBH7+Q9Wn3AolCgNOsOlX4c?=
 =?iso-8859-1?Q?sj19NS5GpCkH/yquTkUSvFWyUQgE37tVnrjqsQbF31PllJA2NpPvBbTWvb?=
 =?iso-8859-1?Q?cQC92u3x/NKQXiiWFRZBA9PK69cccds6mRafF7i476UVOOi2SrzyXCMGUF?=
 =?iso-8859-1?Q?Xk/XE/v+bpaVNbbbkvUVOITS1sIkTcQ27AtMDws/l4pcRLtIg8oXiTbHyE?=
 =?iso-8859-1?Q?6bnUBjivI/eH2SE5C5HRdRlbP1X0+evjCvd5i3ucMTptzCpNvSCPxAlyXo?=
 =?iso-8859-1?Q?7vxg1diNYfAX2VZTaLF0Ds79ooGWpTYFL1+5beTOo4rlpWBkLIOc9sv1WH?=
 =?iso-8859-1?Q?z8lCr04HOOuAlP1sZfzSO3ya8p+zhPnQBaWpF4YvqDhH9H8yvwWrS4IEKx?=
 =?iso-8859-1?Q?KddyPemZON02X/FWuvr3rRQ4JIvMQoDcqylrV148VAy1tZkCCPiIuYzLFY?=
 =?iso-8859-1?Q?ERr+1i2XEpZIWQRThQvvhYp0CGWwi4d3Ley0yqNWhfVBiCtc6FvN1TtGgh?=
 =?iso-8859-1?Q?LCb7JnM/bXNIX3esNLyJMR141DhFoVq9/oEUIG83mgYfsDBPXVltQWuabU?=
 =?iso-8859-1?Q?SA6Z1tgEB5GJx+V1/qI6t1l/wTsAj5YEPT1VXUs+Y47AcR1JZ1vqATAndy?=
 =?iso-8859-1?Q?wbjb/MmANxzNiJ3RNvtZuEONhGKaP/XzJw4ggavxVUHin9sQgyN8GPNxFE?=
 =?iso-8859-1?Q?q1DVWYsU4w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Y+hR81I9ezLSx3Sqzp+hQpaV25WYPtzyAkiar9xtrk6kktvj32g3f5Yb2aq/IwRpVBU50/FP1nZH/oyPjyI1BtUJO8Je+gMPdSceYxkfwlKRQf0fwVy9nUiLkwIVxqvknbuJUYaHYQb6S0qWuzYvpQdeaaqR1+Hr+RAvpvJHaFA2DEe5xVD92uMSLIrtQCAQv94qQ3DBzqWSGTvLETPb4PX2IiJR6AB3u286u3XhhdBmiNBtpIeMZ4ff1XPjKL4QdwnJ1jxZJB25T/EGYMsgBS9oJbO66b/sMzH+rXq0tWzdohzR19r3Nm1NJ8kumeJKpsdeZQYqgfvAZZwgCf+s5tr8Oz+SWV3H+xxZVp/SQHLxLO8EfaF6MvcrHfuOiU2de5iM4KslMEo86AF2Zhn2TogKcY/w5zVWdUVXEfpwV8WZOFwJge7DP7tgvK8YR1whaefI5XlLrLy1eXf4zLldwWh+3pR/Wnb/TjiCX8jhfIP+wHBt71zYHjkaGUQ0wggfp/LIZS6B03NVd0JIU/CROZwq/ZkYfwSjhqc/Imq6Z/SMSFIipn0XHAOOfTey3IUMrgC5X3VEqQsyPkTMxZLf9ZYbsJxjaEIQh57/CREjMf0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 949390de-64b9-4dea-8389-08de73794060
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2026 07:49:34.3346
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gSC7Nc2RfgbC8UfpfI5u+XgWt37R8N8F/zqTp0hoXN3YjwxEzy3fa7GN4TnHVxr0PSHKFhqbp5ZteDcS9lCdlg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR10MB7424
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-24_01,2026-02-23_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 malwarescore=0
 mlxscore=0 suspectscore=0 bulkscore=0 phishscore=0 mlxlogscore=989
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602240067
X-Authority-Analysis: v=2.4 cv=IskTsb/g c=1 sm=1 tr=0 ts=699d5812 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=8nJEP1OIZ-IA:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VTue-mJiAAAA:8
 a=yPCof4ZbAAAA:8 a=cfcA52adaIA_wEhgsAQA:9 a=3ZKOabzyN94A:10 a=wPNLvfGTeEIA:10
 a=S9YjYK_EKPFYWS37g-LV:22
X-Proofpoint-ORIG-GUID: RjntxX70InYZkdaixt-7Z3EdMrQ1Udct
X-Proofpoint-GUID: RjntxX70InYZkdaixt-7Z3EdMrQ1Udct
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI0MDA2NyBTYWx0ZWRfX7p7MN5jVoUv4
 Jta3+17QeO3ADZ12l4/F/6IATJtrqEcyxTP+bps+LBL8+XzsRbW6XvX+T9DDq6YgJleki0+ArUp
 Ccbp5e5oBMhKXXz+hRfLG6QSURQPL31+jxrq8KIJHjT2DdCGJdISE7SX4e97qsTQHn6lzFjqIPW
 Ga0XkEILR90qimkZ1nCTE2zi/U28Er6Cd/+Y8S/W181hGbKzwWO/i0TMa4A7aCYtFib2LgxRf6R
 efxLU2fUVREJHOdGuOLXAHXz0+b3BYgoXk8ha46ltPfTo/1OqxVSQUYwrPb+qiYB0DXKWX1Fhjr
 Gx07CTPrpLtIqKTErSdI5QA8tFgwAUF/jASOIgl3SMT/GjWP+dPHivp0lAsWLCHs7pt0u506Viz
 NMUWaA7DpEI/7KY2y9/cjQO/EXbCuN3fNEdbtYpbBnU+JsAJkeOOFp+GLdAmsJCyDFJs2C7/sdj
 6JN93ipy6KkDCGxRtgA==
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 27960180004
X-Stat-Signature: gizasamkymn7ykgptsuiurn66yw3kpmm
X-Rspam-User: 
X-HE-Tag: 1771919380-843559
X-HE-Meta: U2FsdGVkX1+H8+YhPlLUVNcB1GnUA8AgRj+t1idzSbwxdG40QKnHMq90MPlDihFgcWInFfyTTU9wlEFPmXJPXyj8IRrb2gaPptMuhNKzQR7DHqV+W7EYM6kTlJvdt+Ow3h9i3PEk8KMblPc+GfeUmexnXwMOVWO8lzwGSndyTsFY2vJKnCcA0mh5bGOz2WSKty9WL13N59cdrrIMSXJICt2lYhTH5sgjFg0qkfRQiLty0LTIepIMOmUlyE8uqtLFjnB7C69a4a0Kn4r5EtjGOa8qJNQ7u2zXik+u1PUobNG3+l1dcWWL7Gc1oLWC/L8yhxb2vJ6T+CMffyDzdbTrKaVabGCPxNSo8ea6JLPibcYys6VpFMOwLhhWCZoKkwb4Sux8maMnbjObeP128xZCEemq2ttyBQZuy5A5EAjYBoa56L3Jx8LctXRD0NL25NGdKeOU7OXPg6aM/zBuQgnjWcEMOBfOCv3L6oTD6T2+zzBn7S5SixNhCpyFxwdT4Xr3rzdyJrFtrIioeUOhH93agrT7QDLa8vd/3U9Cyfb+DfRsqMGwQ+k7C7HCGFP1GZzz9As8CuRa8aUTqkC7/7bTpie+8t50C3+J30MYgeau9p/7oExuLMgZEendEd2Cog22bjOmo2AJAdP9kY4tJX6BCCLsHbkNBlL8e1/Nqx/33hEqo7Iqy7wnOjP19aXSEeBzU6qBYJsOyf3HvGKlz2qr3sYfj7rya98PKJv6wzUrHJ4fKC3KOwauBAK0ywBAuYMSXd8fBUSGnwOT6MnjfzKPJnvwWNUj9D9Pl+0VhUa1XKipnXVaxG8qDa2Z75ZOUGQQwTy4hgDSGL06p9smKQzCMoij9T8kZZk/nvmHPxx7HWMq2KwymlOOr3wQiur4wtUNaim4sn+Q7/ePk4+/1b9jV+uS7R+bN6/kdJxDM774JpwKzyzxtfRKYDDINwtDiquwEzxFx/rBnQHNlH2PBn8
 5+fz6/K7
 thzpgG7LF4ELrnzX/smNXJ47npM5nHbCh9IwKhlJ8WXp+kZLoSt9aocYNF1jo2C1dHS3oPxZDmC8DJaY4AH/mXeIvcTdjJ1N3IxXr4UtZ6fiF45m0i02QLPLXQD36kFa5k70x013Rw0awtV7F95Fu6YnwLYxGIDg/27lgAhoCqaTeIxlXIo0kUfQeaZSAKfLdL5z1sBmd6AoQplauq7a1gwDQ2kqg3Lu0U/yWISRmPmpP4mceBRaEyHOKY+gRSCU3OvScMcRMW14/8tsHr8Po+tNpe/v1zxklT0XdS2030BuMdTmEXwIQ/0ysb2nIdmsxROHudEkBjPFNZbMLxTDSoPSxcSG+Nuun92LHWzVBIIS6/Qr0lz1r2xelsSn75PtAWMbib8jq0DYtCm3QJ75b3kMhg0w7l725RalT3udv50HssHncGUHjP6+Ohrx9WhCiGcF6WOuVn+tcUTejExojIw7MCK8/g3CIye7N+YeLSbmU0m9YSdgOI8BbX27zFJs9Old7j7B2m6+wdWtVp2pn8uV22pAlfIO4N3i704FKaDPH0v8+CKLpsOs7yrGm/UJDov2JxBlZN3LiK1Vr5sOR4Z+Bsd5/GWpUS5KsYmGcD3HNHOzB3nX9sihqgSmoITL35XCLoZ9ZUud8hZyHVpsudEmSUf9tRyL4QohrsdNiYO6g3ghNZW6hrgCyjjTsziIzNyM6D8scGi7NWmi9cldEqq9LWi3rDMow8OSKZ6Ea27s5ZvSxypwvIs4TVFqkJ/7Y86fZeN2aHb+5si6uTzOF2tjLUzunmelSx+ktLNrWd3v+G3d/YTjoHc0GM9Al9QiTcQF37CawiGHbSDxGkkRU5ZJ/jxGViUsIhE2wD2QOB8EiN6uDAKjrZ+yPWF0j7t4F91sXXV2b4qb4oFWjvcOruEo3BkmGiu8R9Oy15/y+hpKGXy23+gpTwB+aBg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 23, 2026 at 10:37:43PM +0100, Thomas Weiﬂschuh wrote:
> The driver core can automatically create custom type attributes.
> This makes the code and error-handling shorter.
> 
> Signed-off-by: Thomas Weiﬂschuh <linux@weissschuh.net>
> ---

Looks good to me,
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

-- 
Cheers,
Harry / Hyeonggon

