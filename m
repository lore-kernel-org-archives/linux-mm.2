Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CF24F364A1
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 16:42:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB3CF6B0005; Thu,  9 Apr 2026 12:42:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3D9E6B0089; Thu,  9 Apr 2026 12:42:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B7306B008A; Thu,  9 Apr 2026 12:42:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 71F686B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 12:42:40 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CEEB88C48A
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 16:42:39 +0000 (UTC)
X-FDA: 84639586038.23.AD71BB0
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf21.hostedemail.com (Postfix) with ESMTP id DBB031C0012
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 16:42:35 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=OcVlKgRJ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=lgOPP4Ap;
	spf=pass (imf21.hostedemail.com: domain of haakon.bugge@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=haakon.bugge@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775752956;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4/jCiz0PYEKRAclFAmFW68+5jd+17lc+z8Q0/kkcZuU=;
	b=wZtqUYfcpIm+cYbzfbtvDgfj1UHpcam2ygak7mfDF/qntHOJSvOOEIw6/ibiOrDyCeC257
	gPg9Y630wuKztJtdg3G/sIfe52NvHhg99CCbf8h9ONIDx8RRFf+Hc061uf8okFmaB5cGiQ
	uEQfLeWvzuTHyQINxlwse8fBXWxGxdg=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=OcVlKgRJ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=lgOPP4Ap;
	spf=pass (imf21.hostedemail.com: domain of haakon.bugge@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=haakon.bugge@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775752956; a=rsa-sha256;
	cv=pass;
	b=YKprUMROQH2KVM0D+T+6JcAxMyb44P+Psy2TuUPiI6DyWLcaA9GHuWJBsIKMZMwBJmofuR
	/60a6sYcwPPFrCxy3a0SZFxII99hm6Vc3bHmyyn0dU9gKtsJWBVp/mSi5X4cQsUzzV34lJ
	OIW+2YZWWsQdWUGsmgAf/KpMU+qUEZU=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 639DXWF21886309;
	Thu, 9 Apr 2026 16:37:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=4/jCiz0PYEKRAclFAmFW68+5jd+17lc+z8Q0/kkcZuU=; b=
	OcVlKgRJQI6V6C/dYTK1U+i4jxmYoXQR8ctSh0D6rlQmUxYVIkUaPTtosLCskTAv
	ijVSCCpx95CrEOIZpNZwzEUXCox/ht0urjee3/4S8Q2uzZebQVcZRTaA0cou+qH/
	qgDj6YDokPDUGGWzMVyGJYqtp9FFTgfpn7kQEJAPIROgjH+bcjm7tSG4tKfwin/b
	eUK6tABo3Wbl+n0w6nLhCWyoU4T3BpFzBoLxJEGOKMoshZAv1hV7E6FzEUrznt1U
	a4qeykZy5Rx7ySuJtrP+F98LKEb1/oEAXG/r4+p5YxB8CcUw+F84HIQXBA9a6HN/
	F4wO8qoEo/AeEZ03/DpdYA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dcmqaqceg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 Apr 2026 16:37:26 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 639GNDdF005258;
	Thu, 9 Apr 2026 16:37:25 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010067.outbound.protection.outlook.com [52.101.46.67])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ddgxs3sn5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 Apr 2026 16:37:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bNO2Qg3ZB4rFYIzHMAQN3+tKAOelSdn9m1hSmrAGpOEs4kWIXTgW2G9Pe5Gr6EL0NLTsJqxlIA5JPqJ48LoZutg0y83Dx1yqbUq0ylZiihKMd6jgQDGC4EfFkMKIhDVIS3YMOZLCH/NDGt/zbcxJKlb5Qf1AchM2gCYTd/9Yimi5JFjOjrKF/zG9zZJSL/97XEQUyPV4MGDIxYHmcNYyB0nCm60C+GtWHJJbe/1vyPqoF8AdvJmBU2N7X+aJXVDynUIQwb8u6gvuIh1iI1vI7tgoKtNpTMqvekpcwvaTvOTAXLJw1+fIju9J4tDojf8pfcujjxC3c3SAy7GoZruJ2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4/jCiz0PYEKRAclFAmFW68+5jd+17lc+z8Q0/kkcZuU=;
 b=K6YRcvySRmJJDJ2OyfpRqfmfvmdw7fm/5H5vJC1JDCVwmfSmRnvMUkrUeJWt5OqMuvnrg0PPAcU6WED7M0HdU7Hscy3idEzJsIy0hiGacLdKffjAUKYa3saRwgPpePON0RIDqaGAmORGE435y3g6LBL3Rg2G8fMRuqwNR9+hwfJUpjXoSL8Sv2aAcKu24CHGZ6d/DaDXXsvd30xyYrDOSMREU57Rl32cfRBYeNCJN5WOd/SS30HiaKBTkMR7x5XcY/dOXE+FdqdrzgqevLtNu2r3lcENObWuxatL96wZ6u4wrjVO0YTKdf++/Hgko5umaeQdfNZdgLXl+caeaHo3vA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4/jCiz0PYEKRAclFAmFW68+5jd+17lc+z8Q0/kkcZuU=;
 b=lgOPP4Ap/BO4yEjs8LRppZlvFnYVWqk3VnBzL7/vEMNW7jueXGxqJXM0x6wzCqoqdO91MLGJpt7ag11yLETk99fGngmQCH44bj3aVHNNK5kVplrJyk5hgQ450RvCxkGtUpYt5PNI5e99zpOT9WWKyDTp1iocEcxmlCnO189SHAo=
Received: from CY8PR10MB6826.namprd10.prod.outlook.com (2603:10b6:930:9d::13)
 by SA1PR10MB7789.namprd10.prod.outlook.com (2603:10b6:806:3ab::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.20; Thu, 9 Apr
 2026 16:37:20 +0000
Received: from CY8PR10MB6826.namprd10.prod.outlook.com
 ([fe80::f9d3:19ef:4ce8:4d63]) by CY8PR10MB6826.namprd10.prod.outlook.com
 ([fe80::f9d3:19ef:4ce8:4d63%2]) with mapi id 15.20.9769.018; Thu, 9 Apr 2026
 16:37:20 +0000
From: Haakon Bugge <haakon.bugge@oracle.com>
To: Joseph Salisbury <joseph.salisbury@oracle.com>
CC: "David Hildenbrand (Arm)" <david@kernel.org>,
        Pedro Falcato
	<pfalcato@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Li
	<chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
        Jason Gunthorpe
	<jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
        Peter Xu
	<peterx@redhat.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
        Nhat Pham
	<nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
        Barry Song
	<baohua@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML
	<linux-kernel@vger.kernel.org>
Subject: Re: [External] : Re: [RFC] mm: stress-ng --mremap triggers severe
 lruvec lock contention in populate/unmap paths
Thread-Topic: [External] : Re: [RFC] mm: stress-ng --mremap triggers severe
 lruvec lock contention in populate/unmap paths
Thread-Index: AQHcxsqSHFcuQatuO0OmOSWDaeK0ZrXUIsyAgACto4CAAGmqAIABtogA
Date: Thu, 9 Apr 2026 16:37:19 +0000
Message-ID: <F72E050D-BAA4-4D5B-AFDC-5F8A20D8A70E@oracle.com>
References: <a3474fcf-9f20-47ee-9d15-233e5c7e3f83@oracle.com>
 <k2ldf7rk6mogzhoe3r7a2hpcc62x2uqqpnwk3czbet4shpirs5@sqfzsqpdc3fk>
 <639f20f3-9e65-4117-af9b-e37af0829847@kernel.org>
 <ebbd4c39-859f-4a10-a9e2-c0e9cd1013a9@oracle.com>
In-Reply-To: <ebbd4c39-859f-4a10-a9e2-c0e9cd1013a9@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3864.400.21)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CY8PR10MB6826:EE_|SA1PR10MB7789:EE_
x-ms-office365-filtering-correlation-id: 6c750bbb-33bc-4300-e958-08de965644d8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700021|56012099003|18002099003|22082099003;
x-microsoft-antispam-message-info:
 BIlczk0+vbzzmRM6STrXrlZp8UDDK17J5mb7OEiUQMdvrpunFqgl9ffA5wx5ufmcs7De28ddOhnhkb2df+2n2/MpRCuCmGrGqS8bCWq8xfTSFu5rhVNYQkPrJiVaPFzXILUll7EC9kWnCuE1jdwGQqaFE21EorHHwjurHYt1sj4CzWbjhjRwxWnDfREZWwb1xnZKfP4VWF2NVqiMDIAnYjUcclg3tcuRWqRYW1lr6ad/Ug1VIAYpdWUuUqz2eUlv34LGUqjy3MTmSkGS+lrwTnoDYn1FhO2qDrXzL4n+DLYqNcIzFCooGpA0RunVF2yjBxdew3/25tcExRVvoiOg9cbuIroIVa5P8FUyFgg3JpE1ZG4l8vz78opMKN7GnIptyl7yeS6cfykR4FaIzRj4a83KTnoVMJhniPbgZpOpAzR/jqY0Tzf5/GsOu2Mx5Ier50vheeOWrnf65cwPDSx89XRVNPzwomoZqHo6QWDzqdGIBz8QvpVCraNCjdYMgorCPuJWK0HfYgNN+P/pGuGiKtfI1Wam51kkYjZ2M/Bf6/dxZ3xseu0p2Xqsgt6WpTFSXkcfbArXC3HVVvkPVHXDfQfW6cF+F4LBRKtW8eJTAfzcjUHeHdBFbJseW13MDJmQVINhOir8M3JwWNuputtZHxBtYIOmod6ithmrpUnCdFnKZaQUqwJLUGauUp8mmKlrMSM68TTGI9JvuDnScGXtKFCSwLJSIOtxVkxYFlcmTDqEC/s6vEMt6HOZhbzaAVu7
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB6826.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700021)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?U2gzaGorK0tzNDdzZ2R3R1EvT2lYMzhLS3FIOHg1L3FxbTVPUkc5ais5VGlI?=
 =?utf-8?B?a1NIbUpwOGlHOUJiZ0MvaDU2N2NOMko1azRKcGJxZFc0TmhFWTVKOHpkVmRR?=
 =?utf-8?B?aFh0ZTdGbUZVN24yeVVhOUhUN1FPd2RXVlkxeUJzSVVwOHExeTdzL2FKU2Vl?=
 =?utf-8?B?OTBrZ1pZa0F5cnY4NVVsR05ibyszajdzRzR0ZDlyTXVhTnlWSjYxcUs2SC9W?=
 =?utf-8?B?QUkzeDBjd01KZ3BTT3kvTkpBTWxBQ1ZDRU5jNW51b3c3dHVYMExrK2FQMzkw?=
 =?utf-8?B?bjZISXlwM25tbFI5LzdYNC84cFdZY1E1UDVlb2RaMVVCY084OFN0bDV3VmhM?=
 =?utf-8?B?Z3UzODgva3lxb0p6REs0cys1SFE3MUJSdlRTS0o3MENJc003RmJxR3pyTTZG?=
 =?utf-8?B?Tlc4QzRTZFlxaVdkM0lsdWVTaXN0cVI2WUNxeFZFak5paSt6bjhDSVI5T2lQ?=
 =?utf-8?B?NnVCelJtdzFLT005bXJySGI3azV5dExiTEtNUlR4NWVuRFBETndZSnRHaGdr?=
 =?utf-8?B?QWh0TnNiQ015OVRpVTVsTWx4SWdCYU1QSXhSNEhhRkhQSm5KNkQxMFRlOUcw?=
 =?utf-8?B?VWF4TmE1aVNnc0FzYTNncVU1MzRwMWpiSEhOTTNaNTY5enJEQXFTTlB3T2RZ?=
 =?utf-8?B?eFkzSFI0L093Q3lwc3ZBbjFPOXV0NGJnQlFtS2dHSVpyWldLdzh4OWRjRytV?=
 =?utf-8?B?YktQWmRiRzdQbWtlOUltWjlON0ZLVTJSN0NyQU1yM3hlWkNwbHQ1NUxMcUtk?=
 =?utf-8?B?UjhOZnA5dWRBMjdaeGJjbTZseDJMUFVKVGFocFZmNWVZL3BxK2R6KzJ5U0Ri?=
 =?utf-8?B?b1EzOC9WMlZacmc4V1hvWVJpcjQ5Rnp5NEUxUUF4dGRLQ3V2ZXI4aW9UUG5S?=
 =?utf-8?B?YlJ1RlE2MGFUaW83bUw2QkhLTXVFbE5meFRFR3Z1WGlwVjlqS05jT3c4NEQ1?=
 =?utf-8?B?QVNFejlBSnRUTTFjUTZlZVlKWjBDc1lCd3FaRkJTQUJmb0daOVVNUXBpeFJT?=
 =?utf-8?B?OEZ4dFI1djdFUlo5TWhrN1BWUUVjZDFuTS9RRFcyQWJLSVptajMyQ3pNS1Ev?=
 =?utf-8?B?eGJWVCtiVGRJaHFwaWpwL1p0U3NveDQrNDVZNmFKOUFnVGhQUmJZTkozR2E2?=
 =?utf-8?B?KzFqV2lVOGZqc2c1OEFSWjJFS1lNd2FFVTROaHNoNWRna0U3UWh1TFZKVXRk?=
 =?utf-8?B?aE1Hb0NFbjZWc0x2RWcxSnNURU81cDdlaTk0SXVhRVlLSmtTZVU3MXNJZlVS?=
 =?utf-8?B?Yk1MTjg5MHRvRHdjV0JJcDhTVW8xRmRwYlNZTzJTRGZXQ1pEcWlrV1I2M01j?=
 =?utf-8?B?dHRXUGM2VkNJTGw5K0NlUFdFWTlJY2pmY2QvNnJXSzVCTG92Z2dxcDE5dGZ1?=
 =?utf-8?B?TjNLamRudUhIQVUwNzFhWjRudnB6TWpuRjR4dlVPTUZackl5ZHZydTE0NmlN?=
 =?utf-8?B?dUdtLy9sQnA5Uk5IMWJDcmRkajlBdWhxSGNmREo2YUxjeFZWYS9aZFh5YmVm?=
 =?utf-8?B?WDEyakNTMVBOdlFZeVZ0ZFlCWlVYMlZrVjNJanUwdnhwL2VrUERhY1Y0aTds?=
 =?utf-8?B?WUU5azZSYW55UVIrZFh3TzUxWVlBblI2cm1OYUMrVk4xamRicXVMVURKaUxI?=
 =?utf-8?B?VWNhclQ4SkZaZ0RDZG9nRisvenJ6dU1RR0E5RHRRSm1rVTgrUnBqSk9rOUpp?=
 =?utf-8?B?YmUrdmxmVkpueXZmTHZWSzRkSVpsdS9vUk11MmtJbDI3YlZONzZ2T3JKVTB2?=
 =?utf-8?B?MDMvNGQ0MmtJczZHYjM1a2ZJRnI5MStNc1VDRERTTDVrWnAyc1pBNzlnbkZl?=
 =?utf-8?B?ZmdVWUJQOVNZcnFab0laVFJjM3dBb29FK1g2cjRWYkRWeHJBUmhzOHlnOFo2?=
 =?utf-8?B?bDEvNjZIRHY0S0pVZkdmMTRyYzU1MnN5d2E1cFI1Z29LNlExR2FmcUhoSlJn?=
 =?utf-8?B?QmJjUFlKNm02b2szc2xRZGZ5Mk1oTGJEN2RBRE83Y3ZEcno0VVJqbEpmRlE2?=
 =?utf-8?B?NXdwSkMrZWhQWDRyeEpraFN0ek9WbkNsMzFnUXBLRXFOMmwyL0pCL2Q5QzdX?=
 =?utf-8?B?WFIxN3FIRFhEcUxxakhid241WktUNlF0em5HN012TTkxTzc3czFCZUtaQWVB?=
 =?utf-8?B?NkVtc25tdWk0KzV4bS80QTYrQ0ZHV2EzRDV3RTlOUUo0WGpKM0ZsZkFQL2Fj?=
 =?utf-8?B?ZkVMMGZveE01eC9DYkJCanFoSWlrNGY4TlZraWR5b2NkLzBzM3VFQzhaVHZ2?=
 =?utf-8?B?alozRG5SdjFYNWVOSmJBREdoc1BVOTdRdnd5dGJ0MEt2cDBxOTBDRlhUcGNv?=
 =?utf-8?B?Q1JhWkM3TkRpOXd6WnN6Nm0wQTU0czR0N1Y2TndlNkM1d3U2cmU4S3p4OHBC?=
 =?utf-8?Q?hk/6lIE2P83X3kXg=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1ECDD4E30B1BE449BBDC857B148FE28E@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	erWXwt0S9bppefQ313ruB2q5R7mqGIEU3NiPGjp/wgqGnxZ0bHbK2BjXlrTstjaaL8VKIhmKJlkf1Y4XeFwJBAEIE6TC+DMjlPtSDaB4sjMqoN0EHfjzsoqkPU8ppeoUVgtgKO87Cj7A02OoPTT7KTezYuREVh2SK5pndsyvgCweOQh6xAY+7DlTdgd4aR4QWBNI54FxVAXfMNudpuB7MrklT0u/xasfSOIuEeuAeM0r06ZlDva/vC8OcA03j+ls0S8EQW4VAk0XTOpYwtpHX8bsYHev50GfL/NprErdUpnI3SStTcJzeue5lWEAWhoDgFQOjahDKJ4j5GljgL1W+g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	zo3UROP/Lrdjwh4iP+Sn9QqetXsGEODc97ppArAO4XoVsqnuNcGJfH+ad1qe0atxe3L/6qFQUH1zAJW9summSk0pANdHjWZUvOTQMvDndsr1uMcprKKzOH9E9tT4RxMZH6bEm8oYUjc7ANN5d5lR4pupAIRBx7+YasLjbTnddyhJ2PNeEmfI+lcWTD407QXP7VEyojxMj1reU3e3FwAHoA2UnpR1G1XVuYhEaXs7o7liEue6bKsJC96lvUNEZysgbRONwf6uOHXREzHkA4mnhdcGeIySTyrKGjISLl2OzpRTs5esqGXQNYbHl6TGxRcRvGDMDKTMv3mlnLrCCfEkMnA5TVwWqpu8o7uI8Id1lU1Jz6zA9vXqIml9hSXu3wukdyosD42/xFn7vhf+uX83hdXShaeFIh8dfoFDZeJ8GAU1Mbyx1TGQmm9LUSaOFyBlkhLCtmHr6XS0gAbPpeUR/TQcrL4+TTDrLWRSW+FzB+VQwS36/2AOGpE62YLnzlGn7i1SXAoGxClss1zMky//L7+AT8ir7yDWJIaOA5fbGTjIwjCCJj6VsfLTMk14cIHPi2W0vvMtPRic3Fi6X7WGx4D1linW4kW0vjXgxJujpG8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB6826.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c750bbb-33bc-4300-e958-08de965644d8
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2026 16:37:19.6829
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: x27StI6GYNKefkNHMevoLO3G5yVVswH3GORtv3N1FHE4J0Nsfnc90krECf2wHsXJKfQN0wwSe+e9gcvGzwZGQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7789
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-09_04,2026-04-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 spamscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2604010000 definitions=main-2604090152
X-Proofpoint-ORIG-GUID: 0J59sLIrGfoSGqEwOYZVgwTPSD2gxl4_
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA5MDE1MiBTYWx0ZWRfX3uxyJ1HsfXFK
 +woK44wNcLcHg/RIGdv8iT23CBO3hCT8QZ96Z1J6jEUUTEfViOc/sCURTcqApiKDoAc3vi6nBS8
 H/OwHF3o4YNZUewkkaVg/lQhxdk8yORPA+kxFV2d00pRAfUQ1ZBLaPFPFjlRD8TgB564xbGl29J
 0Q1+xy7EFH+gyev7TJJxA6dXWjJWsha/CBKU/+y+ZFntz+n1DcTbwbKOjuEOWMFPzPntNzB5k3f
 DK94HrkYV70BsiggyLfkexBSNBduwEIaFwBYeJ0V1eKXpLIZBnVFDn4khXyLLNsfXa3tTmd29BZ
 eVJz+6+/kMJRQoY895OMcZf56zdVtv2ivCBHxHdmsFZG6e24bU8r0DjWEPMd3KrQ6OaGrEkTgMp
 4WYVj9lqhC/CF882dTZeDxqE5LMYH3alO6fyelO3siEKvAWw/7XW72VOHIKSWnoHZw0GsEqrFxB
 1YC8vTAyLvsrrg6CLzA==
X-Authority-Analysis: v=2.4 cv=AsTeGu9P c=1 sm=1 tr=0 ts=69d7d5c6 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=GoEa3M9JfhUA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22
 a=D19gQVrFAAAA:8 a=yPCof4ZbAAAA:8 a=ONQT9Uw8gA1pWIMvVIoA:9 a=QEXdDO2ut3YA:10
 a=W4TVW4IDbPiebHqcZpNg:22
X-Proofpoint-GUID: 0J59sLIrGfoSGqEwOYZVgwTPSD2gxl4_
X-Rspamd-Queue-Id: DBB031C0012
X-Stat-Signature: ub5ju7orozxofjw8z8nywjn7ueq5kppi
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775752955-843041
X-HE-Meta: U2FsdGVkX19i38b/iDVEG2lWUtqkIBhBYyKyy2Rk/8QqUO5mqzSKXa9gel8XvkTMWOSKGgqcFm9c+3okFk9Wr9fBq3vOXB7T5M+ImaFcgZc4zS/AydO94FKaoQTbGH4ky9/LHq2d0of4R2jWRKT9KbSkGuxWn4LfgVso68smalLzk87BXl3333a2u6K5vYk79BqJGlTek5aYc8+/pOYTJoD6oLeL6ec+f7p0+GSJBuLNqqdD+4vsqFOu/Fbik6Ke2kFGZafbLhlw1WYZP1cx4T2gzTK4A3IB+PIkKonzYIdfV4WZAlmsXc4MZzWawksr7b8igpX+8NhzjVdcc2c+RibzaxpRqj/GYp1vGtzdLuAWObJchMSqlFDTNmc16RtwSTLHDRN4FbMpvxz5Rhjt91XfbP0YYugf5U35QBYM1fEG0krjcAp/llBnCaWLK6gITFA7qAY/egtCYpvCGbpNtv5leCqF33CDLKUm7IFKLxHVayYrLg3unIJ3yob5z2UcP4BwO3Y5JzKL3kWPlNBRrFbLAnH8Mgri4gj6TLH1Y8M6x3Ouuj5uoZ2hM1UuZDv/tyDj3uAD45GNtPWX029wCZV+Mm17cp15QEL3c6E1ePmE4vM3XTRxcYX2zozL1v8IkfsbDv+VUt4/k8F8a0GFjz6MXo3yydqjORuFZIsjp0sKGTD8JdVTAK9hslSKP7V3oKUqOVwBrHxhyCwXdt4nKong3dPg201hswk/gBYAigz2m8UaUhfs7BW+GZkFV2ajSBarW/MH+e8/HcghaI+1e6xbQl4chZv/1CPjxMbQDH9Pdp8BtYDwDpcGwVmnWaBPlDkTmRtNxoxHtmdCK1mQB1tQHjB2MLkitW/5GFYb1ZsvDLfJrsYlJp06zBx0RM7wB4Efu20SRFu5HQIfjQREngTDRJyWTXDVuHCaDvffVMr69cK2cYlAHsuaYRKx78Ovwmp2xSv+calgocV2KAI
 vus6vn1w
 Zy2R2pD6tiG0sq9PsBqig+py6SUUUqbYjT6EM4Ji6IpB1KZ8mxqt4afVuY86+gHOk6DocLCCrMQU61orrfQO2YRjpfT0tdY1h3rwuW2Tefv8ytJD2Y3Bir/SvJLIig+8ZmGIG1A+r797QwsFGDyCCtvm3EoLuaoPhqcn4DJhBsDktfr60p9KzaJK1n1sj0HcdTjQnIUk+/vbc6BwDzWwiGPSdSZ9JHAekqujqbwrU8Ephjjk7OTAp+zywbrWW81XcWf7bqRLEUgEIchmU6K8rC7SXHpvk4PCsiSVZ7EIrZ0amMjTp59Bay+drYW5z/q9UZzk6lb4ukT+H3J5Am4rdJVn72QB1sJ0Zh1eRMSzzUEanONthdcs0Yq42ezR/myfMUou3jObPPLCzmV8l5mz2aSbZ3HWbLEtxy/68SCzVtMAJ6g61BCGRkeAfGZTv9kbrps0g55CwVYG3X2kuCa2H4aSWjvjml5fYO1g45pAZdYQKzXXjSh4X0jMQjsoapkhT2vTdkGsJRQ4MVTpK8uG3DkxT1rKYtFHXTUafoR66ZiqpRA+Q+7VSa0LNncTEF723oPiuFxEOgMxpkpJAIJvEXS5gJEe1/TOnOP//jI1/dLqJru1c4rWsxWwMXc5z9JyJ9iVxc1VFqxeEaunbpgA36+BHNI/weNcZXW4AgWKn46S2IBj7ZKKqIGboIqbKznrFr56ZwKVdmi09L8HXR/5kH9mGMH0V8hiyrJNL6CgnCWwRwKQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DQo+IE9uIDggQXByIDIwMjYsIGF0IDE2OjI3LCBKb3NlcGggU2FsaXNidXJ5IDxqb3NlcGguc2Fs
aXNidXJ5QG9yYWNsZS5jb20+IHdyb3RlOg0KPiANCj4gDQo+IA0KPiBPbiA0LzgvMjYgNDowOSBB
TSwgRGF2aWQgSGlsZGVuYnJhbmQgKEFybSkgd3JvdGU6DQo+Pj4+IEl0IHdhcyBhbHNvIGZvdW5k
IHRoYXQgYWRkaW5nICctLW1yZW1hcC1udW1hJyBjaGFuZ2VzIHRoZSBiZWhhdmlvcg0KPj4+PiBz
dWJzdGFudGlhbGx5Og0KPj4+ICJhc3NpZ24gbWVtb3J5IG1hcHBlZCBwYWdlcyB0byByYW5kb21s
eSBzZWxlY3RlZCBOVU1BIG5vZGVzLiBUaGlzIGlzDQo+Pj4gZGlzYWJsZWQgZm9yIHN5c3RlbXMg
dGhhdCBkbyBub3Qgc3VwcG9ydCBOVU1BLiINCj4+PiANCj4+PiBzbyB0aGlzIGlzIGp1c3Qgc2hh
cmRpbmcgeW91ciBsb2NrIGNvbnRlbnRpb24gYWNyb3NzIHlvdXIgTlVNQSBub2RlcyAoeW91DQo+
Pj4gaGF2ZSBhbiBscnV2ZWMgcGVyIG5vZGUpLg0KPj4+IA0KPj4+PiBzdHJlc3MtbmcgLS1tcmVt
YXAgODE5MiAtLW1yZW1hcC1ieXRlcyA0SyAtLXRpbWVvdXQgMzAgLS1tcmVtYXAtbnVtYQ0KPj4+
PiAtLW1ldHJpY3MtYnJpZWYNCj4+Pj4gDQo+Pj4+IG1yZW1hcCAyNTcwNzk4IDI5LjM5IDguMDYg
MTA2LjIzIDg3NDY2LjUwIDIyNDk0Ljc0DQo+Pj4+IA0KPj4+PiBTbyBpdCdzIHBvc3NpYmxlIHRo
YXQgZWl0aGVyIGFjdHVhbCBzd2FwcGluZywgb3IgdGhlIG1iaW5kKC4uLiwNCj4+Pj4gTVBPTF9N
Rl9NT1ZFKSBwYXRoIHVzZWQgYnkgJy0tbXJlbWFwLW51bWEnLCByZW1vdmVzIG1vc3Qgb2YgdGhl
IGV4Y2Vzc2l2ZQ0KPj4+PiBzeXN0ZW0gdGltZS4NCj4+Pj4gDQo+Pj4+IERvZXMgdGhpcyBsb29r
IGxpa2UgYSBrbm93biBNTSBzY2FsYWJpbGl0eSBpc3N1ZSBhcm91bmQgc2hvcnQtbGl2ZWQNCj4+
Pj4gTUFQX1BPUFVMQVRFIC8gbXVubWFwIGNodXJuPw0KPj4+IFllcy4gSXMgdGhpcyBhbiBhY3R1
YWwgaXNzdWUgb24gc29tZSB3b3JrbG9hZD8NCj4+IFNhbWUgdGhvdWdodCwgaXQncyB1bmNsZWFy
IHRvIG1lIHdoeSB3ZSBzaG91bGQgY2FyZSBoZXJlLiBJbiBwYXJ0aWN1bGFyLA0KPj4gd2hlbiB0
YWxraW5nIGFib3V0IGV4Y2Vzc2l2ZSB1c2Ugb2YgemVyby1maWxsZWQgcGFnZXMuDQo+PiANCj4g
Q3VycmVudGx5IHRoaXMgaXMgb25seSBzaG93aW5nIHVwIHdpdGggdGhhdCBwYXJ0aWN1bGFyIHN0
cmVzcyB0ZXN0LiBXZSB3aWxsIHRyeSBKb2huJ3MgcGF0Y2ggYW5kIHByb3ZpZGUgZmVlZGJhY2su
DQo+IA0KPiBUaGFua3MgZm9yIGFsbCB0aGUgZmVlZGJhY2ssIGV2ZXJ5b25lIQ0KDQpJIHJlcG9y
dGVkIHRoaXMgaW50ZXJuYWxseSBhbmQgaGF2ZSB3b3JrZWQgd2l0aCBKb3NlcGggb24gaXQuIEkg
dGVzdGVkIHY3LjAtcmM3LTY4LWc3Zjg3YTVlYTc1ZjAxICgiLSIpLCAiQmFzZSIsIHZzLiBkaXR0
byBwbHVzIEpvaG4gSHViYmFyZCdzIHBhdGNoICgiKyIpLCAiVGVzdCIuDQoNClN0cmVzcy1uZyBj
b21tYW5kOiBzdHJlc3MtbmcgLS1tcmVtYXAgODE5MiAtLW1yZW1hcC1ieXRlcyA0SyAtLXRpbWVv
dXQgMzAgLS1tZXRyaWNzLWJyaWVmDQoNClN5c3RlbSBpcyBhbiBBTUQgRVBZQyA5SjQ1Og0KICBO
VU1BIG5vZGUocyk6ICAgICAgICAgICAgICAyDQogIE5VTUEgbm9kZTAgQ1BVKHMpOiAgICAgICAg
IDAtMTI3LDI1Ni0zODMNCiAgTlVNQSBub2RlMSBDUFUocyk6ICAgICAgICAgMTI4LTI1NSwzODQt
NTExDQoNClRoZSBzdHJlc3MtbmcgY29tbWFuZCB3YXMgcnVuIHRlbiB0aW1lcyBhbmQgaGVyZSBh
cmUgdGhlIGF2ZXJhZ2VzIGFuZCBwc3RkZXY6DQoNCiAgIGJvZ28gb3BzL3MgICBwc3RkZXYgIHN5
c3RlbSB0aW1lICAgcHN0ZGV2DQogICAocmVhbHRpbWUpIA0KLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCi0gICAgIDMxOTI2MzggICAgICAzNSUgICAgICAgIDI0
MDQxICAgICAgMzIlDQorICAgICAzNjU3OTA0ICAgICAgIDUlICAgICAgICAxNTI3OCAgICAgICAw
JQ0KDQpUaGlzIGlzIDE1JSBpbXByb3ZlbWVudCBpbiBib2dvIG9wcy9zIChyZWFsdGltZSkgYW5k
IGEgZGVjZW50IDM2JSByZWR1Y3Rpb24gaW4gc3lzdGVtIHRpbWUuDQoNCkkgc2hhbWVsZXNzbHkg
Y29waWVkIGFuZCBtb2RpZmllZCB0aGUgZmlvIGNvbW1hbmQgZnJvbSBbMV0uIEkgcmFuOg0KDQoj
IGZpbyAtZmlsZW5hbWU9L2Rldi9udm1lMG4xIC1kaXJlY3Q9MCAtdGhyZWFkIC1zaXplPTEwMjRH
IC1yd21peHdyaXRlPTMwIFwNCi0tbm9yYW5kb21tYXAgLS1yYW5kcmVwZWF0PTAgLWlvZW5naW5l
PW1tYXAgLWJzPTRrIC1udW1qb2JzPTEwMjQgLXJ1bnRpbWU9MzYwMCBcDQotLXRpbWVfYmFzZWQg
LWdyb3VwX3JlcG9ydGluZyAtbmFtZT1teXRlc3QNCg0KKHRoYXQgaXMsIG9uZSBob3VyIHJ1bnRp
bWUpDQoNCi0gcmVhZDogSU9QUz0xNC4wTSwgQlc9NTMuNEdpQi9zICg1Ny4zR0IvcykoMTg4VGlC
LzM2MDg0MTNtc2VjKQ0KKyByZWFkOiBJT1BTPTE2LjBNLCBCVz02MS4yR2lCL3MgKDY1LjdHQi9z
KSgyMTVUaUIvMzYwMDA1MW1zZWMpDQotIFJFQUQ6IGJ3PTUzLjRHaUIvcyAoNTcuM0dCL3MpLCA1
My40R2lCL3MtNTMuNEdpQi9zICg1Ny4zR0Ivcy01Ny4zR0IvcyksIGlvPTE4OFRpQiAoMjA3VEIp
LCBydW49MzYwODQxMy0zNjA4NDEzbXNlYw0KKyBSRUFEOiBidz02MS4yR2lCL3MgKDY1LjdHQi9z
KSwgNjEuMkdpQi9zLTYxLjJHaUIvcyAoNjUuN0dCL3MtNjUuN0dCL3MpLCBpbz0yMTVUaUIgKDIz
N1RCKSwgcnVuPTM2MDAwNTEtMzYwMDA1MW1zZWMNCg0KQWxzbywgcnVubmluZyBCYXNlLCBJIHNl
ZSB0b25zIG9mOg0KDQpKb2JzOiA3MjYgKGY9NzI2KTogW18oMiksUigxKSxfKDEpLFIoMyksXyg0
KSxSKDYpLF8oMSksUigyKSxfKDIpLFIoMiksXygzKSxSKDEpLF8oNSksUigyKSxfKDEpLFIoMiks
XygxKSxSKDEpLF8oMiksUigyKSxfKDEpLFIoMSksXygxKSxSKDIpLF8oMSksUigzKSxfKDEpLFIo
MyksXygxKSxSKDEpLF8oMSksUigxKSxfKDEpLFIoMSksXygxKSxSKDMpLF8oMSksUigzKSxfKDEp
LFIoMSksXygzKSxSKDEpLF8oMSksUig1KSxfKDEpLFIoNSksXygxKSxSKDEpLF8oMiksUigxKSxf
KDQpLFIoMiksXygxKSxSKDMpLF8oMSksUigzKSxfKDEpLFIoMSksXygyKSxSKDEpLF8oMSksUig4
KSxfKDEpLFIoNCksXygxKSxSKDMpLF8oMSksUigxKSxfKDEpLFIoMiksXygxKSxSKDcpLF8oMiks
UigyKQ0KDQp3aGVuIHRoZSBmaW8gdGVzdCB0ZXJtaW5hdGVzLCB3aGljaCBJIGRvIG5vdCBzZWUg
dXNpbmcgVGVzdC4gSSB0YWtlIHRoYXQgYXMgdGhlIHRocmVhZHMgZG8gbm90IHRlcm1pbmF0ZSB0
aW1lbHkgdXNpbmcgdGhlIEJhc2Uga2VybmVsLg0KDQoNClRoeHMsIEjDpWtvbg0KDQoNClsxXSBo
dHRwczovL2xrbWwub3JnL2xrbWwvMjAyNC83LzMvMTA0OQ0KDQoNCg==

