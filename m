Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29269F364A3
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 18:16:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 330326B0005; Thu,  9 Apr 2026 14:16:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3079A6B0089; Thu,  9 Apr 2026 14:16:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CF256B008A; Thu,  9 Apr 2026 14:16:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 09E356B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 14:16:09 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AD143140177
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 18:16:08 +0000 (UTC)
X-FDA: 84639821616.12.9040BC7
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf18.hostedemail.com (Postfix) with ESMTP id E249A1C0006
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 18:16:04 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=L1HlPuQe;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=yojrbCpf;
	spf=pass (imf18.hostedemail.com: domain of haakon.bugge@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=haakon.bugge@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775758565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZkriK4QGdX9cGxkfcRg14bScJgmz2ac0grmnqRphLNw=;
	b=lsDyMnThAKdYK6PN8itAwG8JROqdXwXxj0f9z8g2Mw5YIlqVRu7/TC0O0uxMvnFnHjQnOV
	Q6PDcsXMKr8/idBuWoUG3QTJNHujmaD9k2o8+JkKh5mOVZT3vIyt9xKeGOxkrABaOFbWJR
	5YQfmq2sCZdYGn/DQGEsYp1IClQUf/M=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=L1HlPuQe;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=yojrbCpf;
	spf=pass (imf18.hostedemail.com: domain of haakon.bugge@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=haakon.bugge@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775758565; a=rsa-sha256;
	cv=pass;
	b=xlB8oCs/ZtK3mer/wc41YqRC0DdMm/rAlJ7yHq2zKB6FEOPSf3UeNg5Bcs5pkziyA6EI0N
	vHfeNgLsk2tDSKFN7rBpKX83ZKFTAZPsQ2AS55zaJgLL+hHDIPpfElIqCsTY0k3RtUuX30
	zBz02zveLAhwtRoqOxMtVkLf1cBDn0E=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 639IBvab2848482;
	Thu, 9 Apr 2026 18:15:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ZkriK4QGdX9cGxkfcRg14bScJgmz2ac0grmnqRphLNw=; b=
	L1HlPuQeC2geJod2dBfotFqxvvi6Nl7z4OG3L4pdVsQiyPJEDjKs9icaZvvsDiAt
	PNdZBmr9J+ZXTD82sLzNURqnHh2tfXr766Rki8IKrbiNJDPGLlcD8ghUVXGVoU5p
	j1TDGhGeMrHJ2S7JPVoUbbDfFLvEgEiXsUyMidR7YT7FDyLbybn6sA1oRB3TjL+u
	naYLwVWoVUF3DMyPwEojECkC1pn7+9YdZVIoSwGPDFaSo0iMZHI5U7XrOnFWWrRx
	dmca4FQRAZJ+ZFmYb17+ePIgQQIXsD84s7QtYQCJuvktdPr8kH+VN9PITi84n8Tr
	Rvhxk7s6wBGBK6dW5Op0nw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dcmqefgjq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 Apr 2026 18:15:55 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 639I0Pi0040148;
	Thu, 9 Apr 2026 18:15:53 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010068.outbound.protection.outlook.com [52.101.85.68])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4dcmnb80we-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 Apr 2026 18:15:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ikOwPiUiupA6sxa2lXW0SPdsiYKcHrYW7RwCVfGyTEetF8Axp6gid7ObGSGRCxxWl0Vv//MuV5Jau+cj1hgXe2ZF3B3QYvCdoqnZdmIFi4pU6JoR/OFMu7Yy5799kj4Cp/30Nra4+qki3Yp4jUGfXfYwaZZjoEUi7sR4ds0rR/6o2gwvRfvvRN0Fzh/95dA3L/aPTZn5hB4vwIv1G5HGjciClaccL1Luoj7T7HzDYvbfq/6QovVYt3VJud9aHEt1iIRarIMLZFzX3JyhLEXWRLqVH5iZcEfkzXoKL0fkx4zfF2gOGP0lpZfgvdyD5K5K1UJYVYzN3D0s4swFMQtuOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZkriK4QGdX9cGxkfcRg14bScJgmz2ac0grmnqRphLNw=;
 b=WjpopkWlJZjfI/OpNFkCz0zclGsSpbNrGSS/qnvUee+cJLm7oIOQA8VOz1MpcbDKA8G8qrXwUQFZGL/be1fE9DkKvaSI7DJ8+UjSyr1WuQv0rJ01ZBgjffVTB8hpJrSXHdwk6PfXo3R22t3xMePo72bgrm8nGnUkv3oqLRdOkyQEmJz53qxVd0V4aL84SE+VFM9nNtNjxanmqlbkHvPca/ejjZfOXJVDQWEyycEu772YE9meSEABG5Js6wsj+lMqPuZqqisbLFkb+9LzNrGycLHwDETmz4PV3R80TVNL/oXV/FNfQbYQ1IxxmfW7c3L9bVsW/cc9qdqumLmZkUdWVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZkriK4QGdX9cGxkfcRg14bScJgmz2ac0grmnqRphLNw=;
 b=yojrbCpfzq9hak6zyU3qkMFBQMjcHXRV7TIHl+QdocIXgUknkIyCFK+AoGi+Q85n9PaznPnp/Jw9CRAQTP/1ttIr0d8PIF8+F29qDLdqDK9VeQ3iYumVO4nZeoZjyWuP8kUvH2zB4E+V/x1X+ChEHuWFnPq7kVM8VjuLEMblskY=
Received: from CY8PR10MB6826.namprd10.prod.outlook.com (2603:10b6:930:9d::13)
 by SJ2PR10MB7015.namprd10.prod.outlook.com (2603:10b6:a03:4c1::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.17; Thu, 9 Apr
 2026 18:15:50 +0000
Received: from CY8PR10MB6826.namprd10.prod.outlook.com
 ([fe80::f9d3:19ef:4ce8:4d63]) by CY8PR10MB6826.namprd10.prod.outlook.com
 ([fe80::f9d3:19ef:4ce8:4d63%2]) with mapi id 15.20.9769.018; Thu, 9 Apr 2026
 18:15:50 +0000
From: Haakon Bugge <haakon.bugge@oracle.com>
To: Lorenzo Stoakes <ljs@kernel.org>
CC: Hugh Dickins <hughd@google.com>, John Hubbard <jhubbard@nvidia.com>,
        Joseph Salisbury <joseph.salisbury@oracle.com>,
        Andrew Morton
	<akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Chris Li
	<chrisl@kernel.org>,
        Kairui Song <kasong@tencent.com>, Jason Gunthorpe
	<jgg@ziepe.ca>,
        Peter Xu <peterx@redhat.com>, Kemeng Shi
	<shikemeng@huaweicloud.com>,
        Nhat Pham <nphamcs@gmail.com>, Baoquan He
	<bhe@redhat.com>,
        Barry Song <baohua@kernel.org>,
        "linux-mm@kvack.org"
	<linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] mm: stress-ng --mremap triggers severe lruvec lock
 contention in populate/unmap paths
Thread-Topic: [RFC] mm: stress-ng --mremap triggers severe lruvec lock
 contention in populate/unmap paths
Thread-Index: AQHcxsqSHFcuQatuO0OmOSWDaeK0ZrXUMrYAgAAe2gCAArc/gIAAA1iA
Date: Thu, 9 Apr 2026 18:15:50 +0000
Message-ID: <AD19A104-818A-4880-9172-0C8FCA6B4633@oracle.com>
References: <a3474fcf-9f20-47ee-9d15-233e5c7e3f83@oracle.com>
 <4a4f5b48-8a1d-48f8-8760-0f5d43b5d483@nvidia.com>
 <982e5964-5ea6-eaf7-a11a-0692f14a6943@google.com> <adfhGOHcg4AF3IFn@lucifer>
In-Reply-To: <adfhGOHcg4AF3IFn@lucifer>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3864.400.21)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CY8PR10MB6826:EE_|SJ2PR10MB7015:EE_
x-ms-office365-filtering-correlation-id: bf59a279-c26d-4bd3-e7af-08de966407d9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|7416014|376014|22082099003|56012099003|18002099003|38070700021;
x-microsoft-antispam-message-info:
 tx0/nl3a3tY1RXOTujvp29iJOAiJYJRBGADeFsiKWlTr5zy4q+SXYshkMGroA7Q7mgLZrhsKC3uvMoCnHcM4Z2/92BskQGpT3y5eRcP5CBj9pjDKBX1o8cjdp6cGRlraXzLpDLSknyFQ0Hf5dnhfM+Ee6R07KMXc4++wck1sAOo+xpj63URtdOBe4f+YpDk2oHVdz1A8A0fBtU/tH7uwxeds79x2/q1pob1DOzzx/SdNBzvNNbei3AbZZm9A8qUs125lquQLvhgIKBXABl+ZrUduLdXOfgUE+mXlnxXKWug8mKu1ojKpVIrM5cx0i3t00OVLIaIwd2o/QLlmwTVYSf2xmjNiKwELvvvHB+5IQ9xMN8yUIsJAnqjnh5glnQaYU/pKN7CsApH8aM5KlhTyy5qtTeZOUw2e/FFBtk2FrlevvZDYS7uwBkGXzcFDW7Vb/qXgHsBPfVSZPar08gX4AdpP1AOJ/wudak4jln/rWMHCeboNvY//WM1852NqaCep8gTupIfZUwWM1zEWaOM+ZM6djaaSwFh3HKNXr5UsbVpvhNJGhALkqMA5OxUb5pN/2QgUmd6QD2tW8aTGlQJ3jAK357VnR93e92fBNxubJk+9h4tZrofEIj9OPdqAEpColsZWpmf8YJ10LX7kKlvSgy1OQOFqS2sJRORjovu1McYof3yapEEoYuUkvCukmL2OYwvftuCJhbOEUuyK7kHXddAKXqIagKUHbtpMNydQgpqgrKtzgfWv2YfV+cqsIGS1pYcuAdlySIXchsbgOn5Xs7Rt1/SlwhC2yXRL4xJ/wLM=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB6826.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(22082099003)(56012099003)(18002099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Sk1HR3NQMDllYjR6OC9FUzJMRlBCU0YvMnpCN0JBWG1yTXFISnRUYU93Smcy?=
 =?utf-8?B?emt3dUx4OGJHSG9BR3lSMllqTFhLS29sRFF3b3dQOThhdDdWR1lqQUVjbzFq?=
 =?utf-8?B?Nm5lS1d2TWRVbkd5SW5nS2pPQWJ6MXgwZ1JnKzJmcHJhR1N1TExTQVZrSEJj?=
 =?utf-8?B?KzJhdDFpbzhKeGJEZFBZbEtTV3dhU29GQXJuZVhENUlRUnlmRE1Kc0U0QTZZ?=
 =?utf-8?B?SmE4NytqQkh4YnNUUVljYlZhcjNSRitRbGhoYVhINzhtaWhaZG90Z1hnTDNj?=
 =?utf-8?B?dGEzK1czcUwzYlBCRU1uYThOcmVqSkk0UXpEeDJ4SnBJallqRnMrSk5SUFNq?=
 =?utf-8?B?aUtQMDdWWXpIclJXSk1XclNXVUxHelN3eW9kL3lZeWN2cWJnK08wS0tWRVM0?=
 =?utf-8?B?YythdElHS1BwQ253STdPWVlXcCtseWZielVJdjJ4aUlEQTJmb1JQUCtCeS9j?=
 =?utf-8?B?YmQvNUlkcWg1VkM5UHAxUmg1dUdzRkp4V1JzN1dkRFFEZlRjd1IrSWtPNW1q?=
 =?utf-8?B?WXlVejVlajcvSklydVdjeTZLeDRBNmxhR2t4Ky9WdS9PR2hOTnF1bnlJTkd5?=
 =?utf-8?B?QjNrZy9XNHVpNE9qakgxV1ZVcExxUFV2T0xYWEV2bVJGckUvM3U1SWNGOWFX?=
 =?utf-8?B?WTJ5UjRxVWxBMVRhVTBxRWVOOStXcmYrQWlNdTIzN3Nid2VJc0FNTXdEa3Bs?=
 =?utf-8?B?VDV3Q21VeVp4RmFjN2xFa29iWkxNZjJEYnVEQ3NqeHRpTEZ4N2F2KzIwZUJu?=
 =?utf-8?B?SmRESVBFMCsvOUd6RytRNWlhVmNzTk55OUY3NmZ5aVhFeFhnNEg3NXkvZUVp?=
 =?utf-8?B?bWdsQnF2K0tid04ydVp2Y1hmcW5oY3hwVnpMdFJMdUVSWUFkdkQyd09XUWlH?=
 =?utf-8?B?K1h5Um5DZXVQZ255SDZmSXlURGV5ZklBTWV2V0szQlJTYW9ZYUMxaWtjRjRS?=
 =?utf-8?B?UnJubkF0S2dKd3pkN2pVUTZMOCt3OG1XZndqeG9RQmpnVm1EeGxJdmw4RktR?=
 =?utf-8?B?L1c3R3JvT01MekdSdnJQOUxCM0pRa2NPUTBKN1Npb2tTM1NvVGR2dzgrMmlL?=
 =?utf-8?B?NWZWRVlFeU1uUXluNW1WN0N6NFRDQlVUQmRpTEE3eGttNlBPbFpFUFZCNktp?=
 =?utf-8?B?L1duamhTU1JsSmFORW5zZGpZc2NKU2twcSs1OXU4bU1wME4zZWoyR0s1aHg3?=
 =?utf-8?B?Q2dSaXRFdzJpbW1jZzF5RlByK29wU2tHNTg0MExpc3NOVmppdmQzK3lKUFNv?=
 =?utf-8?B?bzhwSDRJOGEwQ2cwazlPUE4wcU82dHAzMlovUUJ0UFBVYldjTWVVTUZnMmRk?=
 =?utf-8?B?OUZJVk8xODZiMTIwQ1NuOHV2bDhWdzJkVUFGWlhoVTRZZDBOc05mRHJJdlZT?=
 =?utf-8?B?RitlUnFaZTYzRzlGRDhCeHF1ay9uc1BJSUlXWmF6NnRuMm1VdTR5MnhVM2tR?=
 =?utf-8?B?VUo3S0dyTExMUlFtL2YwKzhyS2NwZ0R6d3REblU3MENOUm5tdDZqWHpMWnZx?=
 =?utf-8?B?NDZKT3NGWkJKOGZOMnVsczdYOTBmUkNzcnU3K1ZIcVJuQnMrN2QwR0tsKzFp?=
 =?utf-8?B?cjdaWFdPZjhlcVBRRUt3REZQazd1Ky9Ic1VtS0gvd2JXd3FkbE1BdjlubG9B?=
 =?utf-8?B?ck03UTExeVlSYjVRVWhtcG9Bb2hHK0xmUE9iSXArUFdSRDlCLzVGMDlkcU5o?=
 =?utf-8?B?bS9zYW9ueS9NZ1kybVJ3RUxycEsvUTByWWpuMDM5U1Q3SXVNWGxqVEtZUzNz?=
 =?utf-8?B?VVhhZEVwOTlCck05OThSazBoSGJITlZDcGd4WUp4T1hiWkNYWXpzd0x3OC9Y?=
 =?utf-8?B?dWdlVVhGT1RFbEREZ1EzUG1rS0x2ZnhQY2pyOCt5S2Y1R2ZXUGJia1ZwbEc5?=
 =?utf-8?B?dWtNQUpwamZpTStXbjEyRDdwbHlyektiaTFpVThmSVBDYTd3TUJSRUtOalZD?=
 =?utf-8?B?SHBJOXJXMkVQUE9ETkZzUFB0Y2w0QWpnMHBXSWgxNWhDcjN1UnBTbjFWamt5?=
 =?utf-8?B?c0JvUkl6Y0RmSXVYczNUdy8rVVZJSnkwRWZ0ak13MFhrNGlCMzNzRXhVODNj?=
 =?utf-8?B?c3VlcVNya2FqbU94bmpZQjVIUHR5VGM1dnZudm5VaE9kQ00rUklMdytWS2hN?=
 =?utf-8?B?QmdsYi9NdGZkVVRnbElUejBudDRLakkrT1RzVENJSzdJODNXRTJPdmtwaVB1?=
 =?utf-8?B?VzVIUXQ2TmpzODNEUGtSdWdqTTl6S3J1OWJxRjgxRkZjczN0YURiS1RoN0RV?=
 =?utf-8?B?QWR3TWRPSExMQ3ZwajhDMTZwVTRvczY1bnZUS2h1clRGTjRwcThOWWliWjZK?=
 =?utf-8?B?TGN3ME1yTEg4OU1DNEh1UlRmZ2taQncrYTVKYXdESXdicHMydXUxSnA3b0sz?=
 =?utf-8?Q?llP1XLmGti8ldeUQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4FA8325C9A09784D9E00B6AF08CD19BE@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	l5fuz7lg5Gd3eiwzOr/DNwqJ29k/9Y4ujKvxAi3eqLnb8RPCQ2AwUO/Zh36leKDNrSnSiARw6gGtTLCOsd1lCcV+SnlSHArzfdCnkjEt2W5oizKpM6eT8KTcXrKZwPb6J0Vp20NZOoLdq/uCmXHbzB4AcreLVqOEgKlp+FuyBfbzAOMthoOL9Udr7xrZIkuJYSW2n0bkuY3wso2JH9PUcJiesRjfSlNoEYsU2mL7pzGOvPNiTBKJrMEJKUZVyzyMfa6J2nZ/f3r/jmAiR0X5iU1BCeIQaCJl/OLdpjmgJFe+pfTVTzvFdXhIwgbmtprhaeyxUD27wuoaUBdvOYnuvw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	XBxnmylkiLOhRRHswsUEN8GJ83jRpSYVnAQyZmABZTGN7W1Y03jDhtO1Y4VDIL5qo0MrsgUllIQbhRyK3X+gu0iYTGDroCCoCyjfw1xhjRzmixlp5Z9E6PrAtbBjoU7whWeWH+GED660hlWtAzdXXVfITqLHox1OiPnvnT3HIy8cEOLDJNcA3DvlCDpHukloJJ0dgLbDVSVHSbSUxrriYXozTKjdG8iOkkab9USooBaXPFnGZnGxLxEQ5Dbxgsn4Pd8Y7f/Ek5FnWjI19rljfhldNA2yzAITbhqGnaHRUkJi42P4Aed0dpFm8QvdV/izXPKnveVZlrsSoaqs5bgR9NSgk4aiQcALxOtnTsHb7o6aoyMaodz3ZQyvXU+GatU4i8WzBkPoQX0MPBAQVUSOHwq3WqhzxM1aUFGJrQNECWlZ4liEwwopri/9RfRY4eNg74cA8JklY8F84A0e+rQfoRfPCmdFaucbT5Zk/aBWX8sQ68dNqEMhAG5IfnajxOfPEkOiWC7zc+KipRAlDWgRZWncgybE71yJkMsNhodFHIbw6W1bazwkzoZVEzQ2+4/TcBS4HjiiYIm9ZdBwjVqPj1g/3xzrKYszTPl8xfhMpjQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB6826.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf59a279-c26d-4bd3-e7af-08de966407d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2026 18:15:50.5209
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: U7TkcYwetdL/wHjT1yhyWf+LchDwUNIl63ksNVmRUfCs/VK6EEjvGhdwlrbe/vfrccgoInzp6S7eBcmiqQlzVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7015
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-09_04,2026-04-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 spamscore=0
 phishscore=0 suspectscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2604010000
 definitions=main-2604090167
X-Authority-Analysis: v=2.4 cv=MtJiLWae c=1 sm=1 tr=0 ts=69d7ecdb b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=GoEa3M9JfhUA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22
 a=VwQbUJbxAAAA:8 a=Ikd4Dj_1AAAA:8 a=1XWaLZrsAAAA:8 a=8h_mUQqxP1H6UVgDT4UA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: zOH0UtrV7rzwSa5_eEBB_eWOvaI_1CZH
X-Proofpoint-ORIG-GUID: zOH0UtrV7rzwSa5_eEBB_eWOvaI_1CZH
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA5MDE2NyBTYWx0ZWRfX1sWRf9QTJz+e
 ze5N/H4wMc0p4cknicJ07rmKGc5Nfhc/bI8Bf5JvRO1olC8UXuKc9BRwZKp4xnHrpgp4lFJ47AE
 9T4N/oANVh63rvgBHdPN7W6GaqDzXeGmbW8VaLUCaVfbcyaYZhjKvSptgoN4pY/ge7YptKKZ6G7
 vJ0061/pzt2lqhj0uaNuwf4LbZwcfmfdObZMZcU4XnYEroewaW3W1nlB3qTwgHX2GGAFQ+JYRMG
 ql+vYuW6FVmuERfbShVpcdo0SCnz+jtnFtJ/rYCn2q1EPU0aIwy6ONvPK2AJnAbOuDzsB2G6REl
 ieavCHKZRWjgEID0I2nKEzLYbcM9OXPGyNFmQHDYWUk5eKZavsWZa8gWsYWpLMACIZ/EEh3byQW
 hek2+pwIYL7Kk43r+kDxcQFyuobMDcqJAHrf3mpscvYHJq9q5RKcxcs2Zi7MJASdhoTiO5ztiCR
 9bfaXa15EFXsdWcnIWA==
X-Rspam-User: 
X-Stat-Signature: i6kag7pdxu5tnnp9ijehons5wdeedpth
X-Rspamd-Queue-Id: E249A1C0006
X-Rspamd-Server: rspam09
X-HE-Tag: 1775758564-667129
X-HE-Meta: U2FsdGVkX1/LUUUByof12ugKkCQhL1y7Hi0fA66f0fn5l6Xzqds8D3Q1Kd4skiwk8MbkwAOBcOw91YaM+5f4KUIJ7qtp9OYZscY17T+wiiRFZvAiN8VN+ZY0dBfE/Sm16yMbaXcRASUuRaN3UmPlU4kaCQ2MNfZ9YHyi6Fhjb1N5OV7rkFWsVRpTDQ1bLnbDt0qPSJOpsicBactRaiOAulmqiFDeAfZTw7hfZ8hVmecE0QqYkddTHGIrmNWsqBbORN01SAbZo+3sLlHSnXp/M7Ju1k4GA7g35dUHujowzDMorthL7SuEJlRgz9SI24HRxyW7MR4KJBweUHnqjPjm17sDyMQ5aKwabMmhA4nQ/A/+Ae88+4OeIX3XaNa7y8k99+f0kVXBQf7AC6N4HPDXb12IV7kDVnfxk3HGFU8I65bCXRkTzxq86AS6++Ny6vJNRMsMlg5Zg9hYRalUpr/8xHBeG5ndmT02y/c55tLNwkHC6HhqOEfgX3zj8g21xR7/OadJeauDhqFYdVNYMP73NBJUuwc8OHCLDwY0fdCrWfq3hUFsILDyZi6mCKLMPoRxxD26v3j0FMqQwpdA4QUSUT4YKV9MQ09lYrDSsxZUYsImr/RXqht6kFoaz5aTRqCKBZq1tK3Q2PXAC5p2+LzvmIss4R9mwD3KAylarjfMNzsvq5qC/p2N4SPELrlVIDBEjk3hGhIOtBeKc1aoz65HaqoBIhhbJB5h/3dCQUXVZ6cs8iRbIHKAd2e8v4dK+2GLZGH3PbVlpBdqTmr5bYjRcwK9Bi5E6GO6cAxg+bP42AmIcdpRgJ4ZeSIDZRtkaz1iQcK1cj1Fk5iUzpYlPb5uPN0YmS6TTBBn0Lz7FHwqQNem86l07VnaF8EtcA3kv0/0aoJ62oOqFYGXG6eTJ9oXjqKOgrLcrApfVyFdFXgtV6nwUIYvkZWOQIKwKZGIhb+kPWnAzZXD7XS6kjx96xT
 HUJc9snn
 KXwP+oLoOFkUgU0EhqITfoNIbodfz1LYvuI+jImX7GpzxtRJOEbsD9egpNi5Y2D74lYsLXKZONjLgFPZIUShr52Q+0NwMu4ebxLIoyJLXFdijzRPlAZmM/gSa9IDAznYO7c88hZKOn6WV77voADsykgJ/Yy8Q8VyN1a9QGRsHa7UUeCwHNFE9b4ocszl6dnLI9BS/27fzhHf7L0GoxmCuOsahXMT8k2NAkx7qAdaSz5b6oZdF+DHdyw3SHURZOmEZoGfMmLsN11DDkOmFmkqZx4ql/CtGbN3Hcd/h3sHHeHxJR9g9Z/Cc6R9i3jJkhgru5mU8DC2amBWpjWDQ+ZNXcHh2Va32vAjRs5bY7+W1bg5zuMHlLoUBIlrCT/mXLDoTLrTEUXvUDFnvyPJlcs/cJijsAHMsskJd/6Q53NjN57IyKUYsMs86MGlTZGbDs6uDfhlLMeupJ3D3OsKgOZ8qTP034wCS62P5LVztF218zWnPEQs+BOu4sm0Y1YDar/6ECWVTxoK0sQj91Qm+BDjvIMmUIX1JAtuDVf3r8qgr1AoX2DkcZlbPKy2bSpNohFsk1Xxt5ZPepGVm0cY/EysZ4hY1zVU29LluYIvkeWcJSsr26gfyATMT07sOXgBisKd7l3PYcrmgib0A9qERWa5ffZ7nBQmorgMNAqWuHG7mO94HNtmXaU/YzYqxDNrv1apNl5TCyTxe/W472kmHn4F6HBdEEdF05uAHcO3EW276w37gwJ65U8DV+NL0GTVetkmPZkZrOfY91lOVL1Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DQoNCj4gT24gOSBBcHIgMjAyNiwgYXQgMjA6MDMsIExvcmVuem8gU3RvYWtlcyA8bGpzQGtlcm5l
bC5vcmc+IHdyb3RlOg0KPiANCj4gT24gVHVlLCBBcHIgMDcsIDIwMjYgYXQgMDU6MzU6MThQTSAt
MDcwMCwgSHVnaCBEaWNraW5zIHdyb3RlOg0KPj4gT24gVHVlLCA3IEFwciAyMDI2LCBKb2huIEh1
YmJhcmQgd3JvdGU6DQo+Pj4gT24gNC83LzI2IDE6MDkgUE0sIEpvc2VwaCBTYWxpc2J1cnkgd3Jv
dGU6DQo+Pj4+IEhlbGxvLA0KPj4+PiANCj4+Pj4gSSB3b3VsZCBsaWtlIHRvIGFzayBmb3IgZmVl
ZGJhY2sgb24gYW4gTU0gcGVyZm9ybWFuY2UgaXNzdWUgdHJpZ2dlcmVkIGJ5DQo+Pj4+IHN0cmVz
cy1uZydzIG1yZW1hcCBzdHJlc3NvcjoNCj4+Pj4gDQo+Pj4+IHN0cmVzcy1uZyAtLW1yZW1hcCA4
MTkyIC0tbXJlbWFwLWJ5dGVzIDRLIC0tdGltZW91dCAzMCAtLW1ldHJpY3MtYnJpZWYNCj4+Pj4g
DQo+Pj4+IFRoaXMgd2FzIGZpcnN0IGludmVzdGlnYXRlZCBhcyBhIHBvc3NpYmxlIHJlZ3Jlc3Np
b24gZnJvbSAwY2EwYzI0ZTMyMTENCj4+Pj4gKCJtbTogc3RvcmUgemVybyBwYWdlcyB0byBiZSBz
d2FwcGVkIG91dCBpbiBhIGJpdG1hcCIpLCBidXQgdGhlIGN1cnJlbnQNCj4+Pj4gZXZpZGVuY2Ug
c3VnZ2VzdHMgdGhhdCBjb21taXQgaXMgbW9zdGx5IGV4cG9zaW5nIGFuIG9sZGVyIHByb2JsZW0g
Zm9yDQo+Pj4+IHRoaXMgd29ya2xvYWQgcmF0aGVyIHRoYW4gZGlyZWN0bHkgY2F1c2luZyBpdC4N
Cj4+Pj4gDQo+Pj4gDQo+Pj4gQ2FuIHlvdSB0cnkgdGhpcyBvdXQ/IChBZGRpbmcgSHVnaCB0byBD
Yy4pDQo+Pj4gDQo+Pj4gRnJvbTogSm9obiBIdWJiYXJkIDxqaHViYmFyZEBudmlkaWEuY29tPg0K
Pj4+IERhdGU6IFR1ZSwgNyBBcHIgMjAyNiAxNTozMzo0NyAtMDcwMA0KPj4+IFN1YmplY3Q6IFtQ
QVRDSF0gbW0vZ3VwOiBza2lwIGxydV9hZGRfZHJhaW4oKSBmb3Igbm9uLWxvY2tlZCBwb3B1bGF0
ZQ0KPj4+IFgtTlZDb25maWRlbnRpYWxpdHk6IHB1YmxpYw0KPj4+IENjOiBKb2huIEh1YmJhcmQg
PGpodWJiYXJkQG52aWRpYS5jb20+DQo+Pj4gDQo+Pj4gcG9wdWxhdGVfdm1hX3BhZ2VfcmFuZ2Uo
KSBjYWxscyBscnVfYWRkX2RyYWluKCkgdW5jb25kaXRpb25hbGx5IGFmdGVyDQo+Pj4gX19nZXRf
dXNlcl9wYWdlcygpLiBXaXRoIGhpZ2gtZnJlcXVlbmN5IHNpbmdsZS1wYWdlIE1BUF9QT1BVTEFU
RS9tdW5tYXANCj4+PiBjeWNsZXMgYXQgaGlnaCB0aHJlYWQgY291bnRzLCB0aGlzIGZvcmNlcyBh
IGxydXZlYy0+bHJ1X2xvY2sgYWNxdWlyZQ0KPj4+IHBlciBwYWdlLCBkZWZlYXRpbmcgcGVyLUNQ
VSBmb2xpb19iYXRjaCBiYXRjaGluZy4NCj4+PiANCj4+PiBUaGUgZHJhaW4gd2FzIGFkZGVkIGJ5
IGNvbW1pdCBlY2UzNjljN2UxMDQgKCJtbS9tdW5sb2NrOiBhZGQNCj4+PiBscnVfYWRkX2RyYWlu
KCkgdG8gZml4IG1lbWNnX3N0YXRfdGVzdCIpIGZvciBWTV9MT0NLRUQgcG9wdWxhdGUsIHdoZXJl
DQo+Pj4gdW5ldmljdGFibGUgcGFnZSBzdGF0cyBtdXN0IGJlIGFjY3VyYXRlIGFmdGVyIGZhdWx0
aW5nLiBOb24tbG9ja2VkIFZNQXMNCj4+PiBoYXZlIG5vIHN1Y2ggcmVxdWlyZW1lbnQuIFNraXAg
dGhlIGRyYWluIGZvciB0aGVtLg0KPj4+IA0KPj4+IENjOiBIdWdoIERpY2tpbnMgPGh1Z2hkQGdv
b2dsZS5jb20+DQo+Pj4gU2lnbmVkLW9mZi1ieTogSm9obiBIdWJiYXJkIDxqaHViYmFyZEBudmlk
aWEuY29tPg0KPj4gDQo+PiBUaGFua3MgZm9yIHRoZSBDYy4gIEknbSBub3QgY29udmluY2VkIHRo
YXQgd2Ugc2hvdWxkIGJlIG1ha2luZyBzdWNoIGENCj4+IGNoYW5nZSwganVzdCB0byBhdm9pZCB0
aGUgc3RyZXNzIHRoYXQgYW4gYXZvd2VkIHN0cmVzc3Rlc3QgaXMgc2hvd2luZzsNCj4+IGJ1dCBj
YW4gbGV0IG90aGVycyBkZWJhdGUgdGhhdCAtIGFuZCwgbmVlZCBpdCBiZSBzYWlkLCBJIGhhdmUg
bm8NCj4+IHByb2JsZW0gd2l0aCBKb3NlcGggdHJ5aW5nIHlvdXIgcGF0Y2guDQo+IA0KPiBZZWFo
LCB0aGUgdGVzdCBjYXNlIChhcyBzYWlkIGJ5IG90aGVycyBhbHNvKSBpcyByYXRoZXIgc3ludGhl
dGljLCBhbmQgaXQncyBhDQo+IHRlc3QgZGVzaWduZWQgdG8gc2F0dXJhdGUsIGlmIG5vdCBJL08g
dGhyb3R0bGVkIGJ5IHN3YXAgdGhlbiB3ZSBoYW1tZXIgdGhlDQo+IHBvcHVsYXRlIHBhdGguIEl0
IGZlZWxzIGxpa2UgYSBtaWNyby1vcHRpbWlzYXRpb24gZm9yIHNvbWV0aGluZyB0aGF0IGlzIG5v
dCAoYXQNCj4gbGVhc3Qgbm90IHlldCBkZW1vbnN0cmF0ZWQgdG8gYmUpIGFuIGFjdHVhbCBwcm9i
bGVtLg0KPiANCj4gc3RyZXNzLW5nIGlzIG5vdCBhIGJlbmNobWFya2luZyB0b29sIHBlciBzZSwg
aXQncyBkZXNpZ25lZCB0byBlZWsgb3V0IGJ1Z3MuDQo+IA0KPiBTbyByZWFsbHkgd2UgbmVlZCB0
byBzZWUgYSByZWFsLXdvcmxkIGNhc2UgSSB0aGluay4NCj4gDQo+PiANCj4+IEkgdGVuZCB0byBz
dGFuZCBieSBteSBjb21tZW50IGluIHRoYXQgY29tbWl0LCB0aGF0IGl0J3Mgbm90IGp1c3QgZm9y
DQo+PiBWTV9MT0NLRUQ6IEkgYmVsaWV2ZSBpdCdzIGluIGV2ZXJ5b25lJ3MgaW50ZXJlc3QgdGhh
dCBhIGJ1bGsgZmF1bHRpbmcNCj4+IGludGVyZmFjZSBsaWtlIHBvcHVsYXRlX3ZtYV9wYWdlX3Jh
bmdlKCkgb3IgZmF1bHRpbl92bWFfcGFnZV9yYW5nZSgpDQo+PiBzaG91bGQgZHJhaW4gaXRzIGxv
Y2FsIHBhZ2V2ZWNzIGF0IHRoZSBlbmQsIHRvIHNhdmUgb3RoZXJzIHNvbWV0aW1lcw0KPj4gbmVl
ZGluZyB0aGUgbXVjaCBtb3JlIGV4cGVuc2l2ZSBscnVfYWRkX2RyYWluX2FsbCgpLg0KPiANCj4g
SSBtZWFuIHllYWgsIGJ1dCBJIGd1ZXNzIGFueXdoZXJlIHRoYXQgX3JlYWxseV8gbmVlZHMgdG8g
YmUgc3VyZSBvZiB0aGUgZHJhaW4NCj4gaGFzIHRvIGRvIGFuIGxydV9hZGRfZHJhaW5fYWxsKCks
IGJlY2F1c2UgaXQnZCBiZSBmcmFnaWxlIHRvIHJlbHkgb24NCj4gbHJ1X2FkZF9kcmFpbigpJ3Mg
YmVpbmcgZG9uZSBhdCB0aGUgcmlnaHQgdGltZT8NCj4gDQo+PiANCj4+IEJ1dCBscnVfYWRkX2Ry
YWluKCkgYW5kIGxydV9hZGRfZHJhaW5fYWxsKCk6IHRoZXJlJ3Mgc28gbXVjaCB0byBiZQ0KPj4g
c2FpZCBhbmQgYWdvbml6ZWQgb3ZlciB0aGVyZSAgVGhleSd2ZSBkaXN0cmVzc2VkIG1lIGZvciB5
ZWFycywgYW5kDQo+PiBhcmUgYSBob3QgdG9waWMgZm9yIHVzIGF0IHByZXNlbnQuICBCdXQgSSB3
b24ndCBiZSBhYmxlIHRvIGNvbnRyaWJ1dGUNCj4+IG1vcmUgb24gdGhhdCBzdWJqZWN0LCBub3Qg
dGhpcyB3ZWVrLg0KPiANCj4gWWVhaCB0aGV5IGRvIGZlZWwgcmF0aGVyIGRlbGljYXRlLi4uIDop
IHNvbWV0aW1lcyB5b3UgX3JlYWxseSBkb18gbmVlZCB0byBrbm93DQo+IGV2ZXJ5dGhpbmcncyBk
cmFpbmVkLiBCdXQgb3RoZXIgdGltZXMgaXQgZmVlbHMgYSBiaXQgd2hhY2stYS1tb2xlLg0KPiAN
Cj4gSSBhbHNvIGRvIGFncmVlIGl0IG1ha2VzIHNlbnNlIHRvIGRyYWluIGxvY2FsbHkgYWZ0ZXIg
YSBiYXRjaCBvcGVyYXRpb24uDQo+IA0KPiBJdCBhbGwgY29tZXMgZG93biB0byB3aGV0aGVyIHRo
aXMgbWFuaWZlc3RzIGluIGEgcmVhbC13b3JsZCBjYXNlLCBhdCB3aGljaCBwb2ludA0KPiBtYXli
ZSB0aGlzIGlzIGEgbW9yZSB1c2VmdWwgY2hhbmdlPw0KPiANCj4+IA0KPj4gSHVnaA0KPj4gDQo+
Pj4gLS0tDQo+Pj4gbW0vZ3VwLmMgfCAxMyArKysrKysrKysrKystDQo+Pj4gMSBmaWxlIGNoYW5n
ZWQsIDEyIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4+PiANCj4+PiBkaWZmIC0tZ2l0
IGEvbW0vZ3VwLmMgYi9tbS9ndXAuYw0KPj4+IGluZGV4IDhlN2RjMmM2ZWU3My4uMmRkNWRlMWNi
NWI5IDEwMDY0NA0KPj4+IC0tLSBhL21tL2d1cC5jDQo+Pj4gKysrIGIvbW0vZ3VwLmMNCj4+PiBA
QCAtMTgxNiw2ICsxODE2LDcgQEAgbG9uZyBwb3B1bGF0ZV92bWFfcGFnZV9yYW5nZShzdHJ1Y3Qg
dm1fYXJlYV9zdHJ1Y3QgKnZtYSwNCj4+PiBzdHJ1Y3QgbW1fc3RydWN0ICptbSA9IHZtYS0+dm1f
bW07DQo+Pj4gdW5zaWduZWQgbG9uZyBucl9wYWdlcyA9IChlbmQgLSBzdGFydCkgLyBQQUdFX1NJ
WkU7DQo+Pj4gaW50IGxvY2FsX2xvY2tlZCA9IDE7DQo+Pj4gKyBib29sIG5lZWRfZHJhaW47DQo+
Pj4gaW50IGd1cF9mbGFnczsNCj4+PiBsb25nIHJldDsNCj4+PiANCj4+PiBAQCAtMTg1Nyw5ICsx
ODU4LDE5IEBAIGxvbmcgcG9wdWxhdGVfdm1hX3BhZ2VfcmFuZ2Uoc3RydWN0IHZtX2FyZWFfc3Ry
dWN0ICp2bWEsDQo+Pj4gKiBXZSBtYWRlIHN1cmUgYWRkciBpcyB3aXRoaW4gYSBWTUEsIHNvIHRo
ZSBmb2xsb3dpbmcgd2lsbA0KPj4+ICogbm90IHJlc3VsdCBpbiBhIHN0YWNrIGV4cGFuc2lvbiB0
aGF0IHJlY3Vyc2VzIGJhY2sgaGVyZS4NCj4+PiAqLw0KPj4+ICsgLyoNCj4+PiArICogUmVhZCBW
TV9MT0NLRUQgYmVmb3JlIF9fZ2V0X3VzZXJfcGFnZXMoKSwgd2hpY2ggbWF5IGRyb3ANCj4+PiAr
ICogbW1hcF9sb2NrIHdoZW4gRk9MTF9VTkxPQ0tBQkxFIGlzIHNldCwgYWZ0ZXIgd2hpY2ggdGhl
IHZtYQ0KPj4+ICsgKiBtdXN0IG5vdCBiZSBhY2Nlc3NlZC4gVGhlIHJlYWQgaXMgc3RhYmxlOiBt
bWFwX2xvY2sgaXMgaGVsZA0KPj4+ICsgKiBmb3IgcmVhZCBoZXJlLCBzbyBtbG9jaygpICh3aGlj
aCBuZWVkcyB0aGUgd3JpdGUgbG9jaykNCj4+PiArICogY2Fubm90IGNoYW5nZSBWTV9MT0NLRUQg
Y29uY3VycmVudGx5Lg0KPj4+ICsgKi8NCj4gDQo+IEJUVywgbm90IHRvIG5pdHBpY2sgKE9LLCBt
YXliZSB0byBuaXRwaWNrIDopIHRoaXMgY29tbWVudHMgZmVlbHMgYSBiaXQNCj4gcmVkdW5kYW50
LiBNYXliZSB1c2VmdWwgdG8gbm90ZSB0aGF0IHRoZSBsb2NrIG1pZ2h0IGJlIGRyb3BwZWQgKGJ1
dCB5b3UgZG9uJ3QNCj4gaW5kaWNhdGUgd2h5IGl0J3MgT0sgdG8gc3RpbGwgYXNzdW1lIHN0YXRl
IGFib3V0IHRoZSBWTUEpLCBhbmQgaXQncyBhIGtub3duDQo+IHRoaW5nIHRoYXQgeW91IG5lZWQg
YSBWTUEgd3JpdGUgbG9jayB0byBhbHRlciBmbGFncywgaWYgd2UgaGFkIHRvIGNvbW1lbnQgdGhp
cw0KPiBlYWNoIHRpbWUgbW0gd291bGQgYmUgbW9zdGx5IGNvbW1lbnRzIDopDQo+IA0KPiBTbyBp
ZiB5b3Ugd2FudCBhIGNvbW1lbnQgaGVyZSBJJ2Qgc2F5IHNvbWV0aGluZyBsaWtlICd0aGUgbG9j
ayBtaWdodCBiZSBkcm9wcGVkDQo+IGR1ZSB0byBGT0xMX1VOTE9DS0FCTEUsIGJ1dCB0aGF0J3Mg
b2ssIHdlIHdvdWxkIHNpbXBseSBlbmQgdXAgZG9pbmcgYSByZWR1bmRhbnQNCj4gZHJhaW4gaW4g
dGhpcyBjYXNlJy4NCj4gDQo+IEJ1dCBJJ20gbm90IHN1cmUgaXQncyBuZWVkZWQ/DQo+IA0KPj4+
ICsgbmVlZF9kcmFpbiA9IHZtYS0+dm1fZmxhZ3MgJiBWTV9MT0NLRUQ7DQo+IA0KPiBQbGVhc2Ug
dXNlIHRoZSBuZXcgVk1BIGZsYWcgaW50ZXJmYWNlIDopDQo+IA0KPiBuZWVkX2RyYWluID0gdm1h
X3Rlc3QoVk1BX0xPQ0tFRF9CSVQpOw0KPiANCg0KSSB0aGluayB3ZSBhbGwgYWdyZWUgdGhhdCB0
aGUgc3RyZXNzLW5nIHRlc3QgY2FzZSBpcyBzeW50aGV0aWMuIEkgZXZhbHVhdGVkIEpvaG4ncyBw
YXRjaCBhcyBJIHVuZGVyc3Rvb2QgdGhhdCB3YXMgcmVxdWVzdGVkLCBhbmQgdGhlIG91dGNvbWUg
d2FzLCBtZXJlbHksIGFzIGV4cGVjdGVkLg0KDQpUaGUgZmlvIGNhc2UgaXMgbW9yZSBpbnRlcmVz
dGluZywgYXMsIGlmIG15IHJ1bnMgbWFrZSBzZW5zZSwgaXQgaW1wcm92ZXMgSU9QUyBieSB+MjAl
IGFuZCBhdm9pZCB0aHJlYWRzIGJlaW5nIHN0dWNrIGF0IHRlcm1pbmF0aW9uLiBCdXQsIEkgYW0g
bm90IGludGltYXRlIHdpdGggZmlvLCBzbyB0YWtlIHRoYXQgcGFydCBhcyBhIGdyYWluIG9mIHNh
bHQuDQoNCg0KVGh4cywgSMOla29uDQoNCg0K

