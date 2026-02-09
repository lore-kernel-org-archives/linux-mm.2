Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCE08E94605
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 20:48:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCA3A6B0088; Mon,  9 Feb 2026 15:48:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C779F6B0089; Mon,  9 Feb 2026 15:48:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2EC36B008A; Mon,  9 Feb 2026 15:48:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A43206B0088
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 15:48:32 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 631E3C1624
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 20:48:32 +0000 (UTC)
X-FDA: 84426106464.11.AE2CCD2
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf10.hostedemail.com (Postfix) with ESMTP id D5B37C0009
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 20:48:28 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=otXljRGv;
	dmarc=pass (policy=reject) header.from=ibm.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf10.hostedemail.com: domain of Slava.Dubeyko@ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=Slava.Dubeyko@ibm.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770670109; a=rsa-sha256;
	cv=fail;
	b=lvBy/3aFTxvPAs+8eb0Bz69RMX630d9Ylh1LJ+gzQHb2bYorGf7qsLlt+H7aqDE+sNkg7r
	njN6S/B9U0CfgWWLyvdJcbuoljitFOX6soxmdl7W5ITsK86nc2Y+vkQtWvDnJm7QO9vQ94
	uEGnUxBbreysqG4rownVXLaAzGFYGm0=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=otXljRGv;
	dmarc=pass (policy=reject) header.from=ibm.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf10.hostedemail.com: domain of Slava.Dubeyko@ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=Slava.Dubeyko@ibm.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770670109;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x2WkhssMXBUYazAQO5Un1wKlnVVfhpiI6M3UIW7R9t8=;
	b=yaNlUJUt5D7SkcR9CULWEtJwI/0WhYi1PEGzKML2PGID9whWV0Q4J6sKpaA6D2fEgu5TvQ
	PuqxZSyLLq6mrwB591pLyfPRqMqHyeATSBl8gVVA0WRKdbgYh6RenRhCWdINyvC0fgmXVs
	uWUPFMxREs5ayt3HURcjxCDS8CpF+y4=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 619FgauH451836;
	Mon, 9 Feb 2026 20:48:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=x2WkhssMXBUYazAQO5Un1wKlnVVfhpiI6M3UIW7R9t8=; b=otXljRGv
	h/0C0rGywxrA5IvSODrDquBJl3Qv0L0X41C4wbZYOK4ppV9R+Cm3zHUczWYbeYgb
	kRScUx+vuo5lsBgCQ5LFe5X+AUNGpTvBaJmARVYpFJlp0GcODVfPZ4ltJKTgEPzO
	rI4u4z+F4wA5F5DSVZZcEjFzzNVwGp42G3BMUQPIRCac9QBFZr9pjAS2LV1zIEG+
	KTfpmTKOUqGsbU5VZZmEdO8JDyXjDFFerKHWFK4LyorBM60pomyK1f5EAXGd7eqs
	iV+IJmjGTvC+zN/JO5fliix2D9P7E2RKTuOF/mev0M5qBW3h1USAbOnozlthkriL
	V2iAktiO4XqKkQ==
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010033.outbound.protection.outlook.com [52.101.85.33])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c696u95yc-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 09 Feb 2026 20:48:24 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lUVANzFDNxgo2qCHYtiPCQmzwRPbCuYWgrR9OgIyvTxVjpiX1HPYU2OIuQaFIS4qmi/5FDwfkZ7vfE5Aao1nB55KayCplUb/S/RC77/jiLYz1reQ/oMZIYiG1YoX7XJ9SGzojOVaQOJ1W4Ka8SHvjQRTEKhYzNdgcEAi3LLkBFOwTiu/Xer2oAHTKxIubrk6bU1aPmPReNfdNwWf0WPKgDu+Lsvq2qwsFRUTXnXKLrr/JGUIbke0r+Nz+BfzR0Z+jzIxObH+zRZFngKt37J4OEoY+8Or+xjzhQUNMs8pX5ECd5eIbn6H8JfYjK7+0LpjM1OsFxfpdRza5DzfFBb+sA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x2WkhssMXBUYazAQO5Un1wKlnVVfhpiI6M3UIW7R9t8=;
 b=rUVPDY4KszsnwMJZEuaUPpoEIbRs8wOawm4zJHjBIDE9ltrFN3PjGH2H9PEYYZlp+3EvX6ICEruQV2tN5oa1HA4op04PdobDySDPDngVb3wgyy5x43mMBMxqD4PsRNb+KLYlJI5xj+YZquJ/eTVaqWU0yG9xBsbY/7zU4EbAUOj/GTsP8dvTofXMTLA8VPIkky1m5s0WJaW3q47g3xMWNXz+lY9XV423XIcl739hIPlhVjVdx83UyFKrEbUa1Fy7fbkjk9fR3fr0xBza3YGfj4OlTDSAf7OFYg9U/JG6ckf72UK0LJdaD36M89uzeehBBdfZQy2OiOLcfJ1zvjgGkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by PH7PR15MB5425.namprd15.prod.outlook.com (2603:10b6:510:1ff::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.18; Mon, 9 Feb
 2026 20:48:17 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539%6]) with mapi id 15.20.9587.017; Mon, 9 Feb 2026
 20:48:17 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "slava@dubeyko.com" <slava@dubeyko.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Thread-Topic: [EXTERNAL] Re: [RFC PATCH v1 1/4] ml-lib: Introduce Machine
 Learning (ML) library declarations
Thread-Index: AQHcmEnOC00VEXnru0q06Eiq8znH6LV62kAA
Date: Mon, 9 Feb 2026 20:48:17 +0000
Message-ID: <46449ed46d60767bd13b980e5ab63faf4364f718.camel@ibm.com>
References: <20260206191136.2609767-1-slava@dubeyko.com>
	 <20260206191136.2609767-2-slava@dubeyko.com>
	 <2026020756-remarry-declared-9187@gregkh>
In-Reply-To: <2026020756-remarry-declared-9187@gregkh>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|PH7PR15MB5425:EE_
x-ms-office365-filtering-correlation-id: dedf63ad-da4d-490d-9dc0-08de681c8dae
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|10070799003|366016|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?bnR2ampBWjFyWUJvRGtpTW16dm1sbEdFSVM2Uk1xcXMzZUw5Q2VhUnV2UmVt?=
 =?utf-8?B?ZUlreXAwVlJJb1RXMGIrOEo1ZUJ3d3JBMzJ2Z0VPZHBmblJCd0tpTzJidFVY?=
 =?utf-8?B?Y2d5UnAyRWVMQS9nRmR3amF1QXllMzF5THU3M1dlb2sxNEJXdGZCaE1ncnNT?=
 =?utf-8?B?V01OZVZkMitLVDlBN0JuTEc0ckNiR2JpZnYrMlpFMG1rYjBva1kxZWE0M0ls?=
 =?utf-8?B?QTh0V3RxL1E3VFB6SE80WUVzdWM0bzdDaUYrdFE0b1pQa01mY3JKTjdYbk5V?=
 =?utf-8?B?SU84Rk9HZ09peTBBS1p1SmJhVFk2NXF2UTAxaHVVdmxuNzB2Tk9NZ3hTZVVM?=
 =?utf-8?B?ZWp5YzREWE56QUlPRzRSL0hubkNSNDlkaERiS0h6VDVUbVVuTmpEeTl1RkRj?=
 =?utf-8?B?akY3RmNvTFNZTXdvWHZpMHZ1RlpDekhPSzhEWVF0L0pmM3VBZnRWUGhvamFF?=
 =?utf-8?B?TDBzL0oya2tlcko0MndUblRMU3FFRTE1L2ZsWWIrNTBiL3p0ejNqbDNhM1Er?=
 =?utf-8?B?UHZlYTB1N3FkR3owK2V4YnUwMFJpcFNFMVpnZ2dhcG43YUY3RjBobG9QQmti?=
 =?utf-8?B?a0V4ZklPemgxaFNuZHFXT2o4NCtZa3ptYUs2S2hDM2tmdFJmdjNKOEYxVVpv?=
 =?utf-8?B?Z080N09IYXJEeDgyUjROTzBDbE9hbjMzdy9ZWDBaclBzNUIvZTUyY3RTcC9U?=
 =?utf-8?B?UGNDS0NCTTVmQm5pbHRxR0tCSTFJTmFhRGdxS05xZzdSUFpJd2JlZDVPczlT?=
 =?utf-8?B?NG1LeEdybmpZelF2K0xyZUhTVm1HaGVJVFN5MzNjUG5KZlQzajZSODhiUlAx?=
 =?utf-8?B?cnljWE1DU3lZbWJwUzRhWWE3QXlLMmFIYU9yUWVmRmtCcG5hYmRLNDQvMWRK?=
 =?utf-8?B?WmUxMlp5SUlhRTRZOVRhNERKL1FCaGVMcnhyNmdhNHZPaFlxcmc5SmU1RDRs?=
 =?utf-8?B?akwwTElkSE12SmVMYm5mTTlCTWx2bXhJeHFWeXo4REpTU1hyVjhtR0RVVlMz?=
 =?utf-8?B?OStHcDZmN3I0NXlMVVQvVWtQcEYzVmdaLzlOVCtCV0xpbHRwamVJcktqRUZj?=
 =?utf-8?B?TmhRQ04zMTdCYnJrVlFFbm40Sk9uTFJ0WlkrRVJJL1RUc1l6TTFWSFdCQzFz?=
 =?utf-8?B?RG5Sb1lua0Z3ejF6eFFrbjJZUjlJcTVZNjlLR25RcXk5WTJCdUNnSFcyb1Jq?=
 =?utf-8?B?dHIzMlV3TlEyeDh3N1h6UGlEYzVjU2R0a0pnVnZVYXFBS1ZjYkxJbHBoWm8x?=
 =?utf-8?B?NU4rZDA4ai9oMTF3WlJKTG1RQWkzOTd2TWtJVlBLaFN5RW1HUE1CeXVZWHFW?=
 =?utf-8?B?WlJCQk9rY2RDYVdOYUdQRVplV2NidFVrUVFTQTJnNjZ3Uk5kZm12bmNCcWVY?=
 =?utf-8?B?RWRGT3VITnhweUJDTDF6TkEwNnpmM2dnZGVxeitHb3NOeG9uTWFGcUJGQTMw?=
 =?utf-8?B?ZjQ5REVSZmIxRWZHQVhONVRmN0sya0oya1BIRk5xRFQ4MDU4dlJTOFh3VTQ1?=
 =?utf-8?B?R2N6SDM3N1BuZk4vdTB5K2d2bWZOZVNDRmR5Qko3eXVMRDZKVU91NnhlRUNa?=
 =?utf-8?B?UEtQTW9JT0RYWWFlZ3VkWDRJazdHSC9YNnlxeC9OSnlPaGR0SGRZbys0SE1N?=
 =?utf-8?B?NnI5a1g2cWdvTkRZenpCcEtuYW1RSzdDMlA4SG1URnJhUUJMdEFNMVRXY2to?=
 =?utf-8?B?eTN4SWRWTUtNQ2pBNTFIeE5KK2M0US9lM0NiZEhvbUlqMXR5Wm81aitiQjZo?=
 =?utf-8?B?cDdKU3c4MlhLZ2sxbVBOSUM5bWo3czJsY1A1cjdsZktleUVSVDdQVWV2Yy81?=
 =?utf-8?B?TnBYbEpEYk1ENUtqdXlOZUprVGs4SmFOL1VDNVN6U0RGdmJic2ZRbTU4bjhM?=
 =?utf-8?B?S2hobVpOL0R1N1VDU25PYThpT0U4bVFBNlRLQk5KV052UXFMbDA0SWdteDgv?=
 =?utf-8?B?eEIyRUlTMklJWGQ2ZlNkdElpT0kwcVcwZkt0MC8rZ05jcnIzdldKU2dGYStv?=
 =?utf-8?B?R1ZzNUgwREVCUHpPcHhEbEpNL1ByRG80eG9yVnp6OGEwQnRUdkdtV0FNSk9L?=
 =?utf-8?B?aE8wQVFDR1hFWk5DbTdFTExGeDZRMldJR0cxSFlHdWJxZTMrVExLb2JaSFRQ?=
 =?utf-8?B?R1c3NURFcDY0bytuOVZidkRSc3dMOFdxd1VzK1ZUTkJ0enhCSDNvVVRHMEM2?=
 =?utf-8?Q?MG/cKynJt81wh2dzR/aLoDE=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?TmRHRVZuU1lsM1FybThlY1Z1azdpN25OZzh0TkJJTXBZMEhmdjE5RWJ1VDZy?=
 =?utf-8?B?SmEzMXd6V1VHRTZEZlFmUVVnRmpPV0NnZ1gvcGRDekJETzFvYUNWSzhIUThm?=
 =?utf-8?B?clBxMjRlN3pkV29rM25VcUg2MUFHUnBjczRnOThMVGxJSkVodnpUQ0NORDc5?=
 =?utf-8?B?QzFFcCswZ1ZYTXpBUFA5Mk9jb0ZzbjN1aW16MmozL1YySWt0RkZ0VkF4UkxW?=
 =?utf-8?B?alpZWHkzSFNtOS9vZWdJd0ZmUUtkalBzNitOcHRIZFFVZVVsQ3dpWHRCaTFW?=
 =?utf-8?B?azFiS1N5YktybExuZzJPR1FVTGxwSnRQQUtySzEwaEJUNzRiTDJ3QjBhSkZo?=
 =?utf-8?B?WHUrbm5KanpVMkZmYjRVbW5iMEFnZEgva2o4cWdDK1FiVXF5ZDdVS2MvVHFI?=
 =?utf-8?B?WVdldDhpV2l4bEQ4WVY4aGwzQ09uYjN1OE5wazAzcGllVmhxVnRDeHRnNzdk?=
 =?utf-8?B?OW5mNVBsY1ZxY2FjNk1kYTIybFJybWlFSEFXQ0xEZWpLejgrYjAyd1ZydFBF?=
 =?utf-8?B?cStzbWR5WTVjYzh1aHZLQWRmYVlDZnorQXNPb3VPRExIT0MweWFQVjJ3SkVt?=
 =?utf-8?B?elNmeEkwQzlGU1NUaVZIYkpJMDh5Tit6VGxsNUJQNGJXVGdONkQrb01uWjdO?=
 =?utf-8?B?S2NOdGdnRS9ybzNkZkVld3pmdCtjTWhNM3pBZFRXSUFJdngzS1lla292OERI?=
 =?utf-8?B?VjRyK1hXS2ZWWE9GVXZoMk1KMmRQOGFzOWpNUERSNHdwZk5yTFlSUG14L2g3?=
 =?utf-8?B?ZDVzT2d6U3liVkVlVnB6Z3NDdUh5ZWxWeElpTytIWXc0U2YvakloSjdZVzFO?=
 =?utf-8?B?V3FhdGhqMHdIRSs1VkJTQzZLaU1oUjhwdnR5V0p0ckhLV2UvbElRVmJ3Y1VG?=
 =?utf-8?B?SXY0NnlxbGpuNmdqRkEvZkcrNlY0aGlDcUYxVkFJVEx0ZU9YOFJiT2ZGZzdE?=
 =?utf-8?B?dEFRV0dwb1NJeFI0TWdLRjlxWGNEUkhJWEMzcFI4eml3OVdyOVBjSHV0RU5G?=
 =?utf-8?B?ejVGK0ZMRXJmR1R2ZWl0ZXdJNjJjVU56eGNxUzdmd2p3czdiWERvanFnd1JT?=
 =?utf-8?B?REZmVUFMSWJqU3Z4MnZTdzllYWtSYWhzWmQ5bUw5MVYwV24yYVBNZmp3RXI0?=
 =?utf-8?B?ZlpxeTkrOVJ0RHJnZC8rVkYrekExdXlTMnB0TnBqai82OGVkeWhvZGo2OC8w?=
 =?utf-8?B?NzhnY09XZitWLzcxTWxPaU02cUp5R2RMSjRJRHUvekpXWDJ3Z0Q5ZGN0bTFW?=
 =?utf-8?B?REordnRTcDBKcDZLaW5yUG04aWNDbi9sbElPZXZPWGFCQzBVdkVLeS9qTERl?=
 =?utf-8?B?WDVHSWVqZmxzV0JyR29iL1hzb2hDQ0pMZVZkUWtUalNKaUZGcURQVm5pOW9R?=
 =?utf-8?B?V1JpQXk5S0lvQXcyeVNuaExwWjljU3N6QmVpbFpvY1h5Q28yZURhdVZLTjFR?=
 =?utf-8?B?U29jdG1mRnJhM1hiODBjcTVMNVlvbW0rbVlHT2t2TWdJbWUxVlEzMzh0Zmt3?=
 =?utf-8?B?WGtQQlo3S1lpWXQ5N0M5ZEYrOHJjNWV1anVTUGxFSW0zWHJVMENHeGZHZHF6?=
 =?utf-8?B?OUpOekhUSmkwMXlNNTdVeDc2cVc5K0pLUk9IMUlIMmtORjhXMG1IUTFrY0Z6?=
 =?utf-8?B?STF0MHhBQ3RsNjhiazlzTmMzY1FjYWFvR2wyakNKWEZyTFhMTDFjM01vRU9D?=
 =?utf-8?B?enJrakwzcFRFM3gyK3ZvbElpcWxBNGh5d0tNK0FOV2w3ZmtNWnB0c3oxYTcw?=
 =?utf-8?B?R3lqMXZiZTFjbFNXRTR5bUxVMW5mRnNtcEs1bExkY3VDeE5xc2dxOXNNOERp?=
 =?utf-8?B?eVA5QnY2b1dxUm83aThuNnNMOW1aTEh4R2JXc1o1aTJwdi9HT09IWEpwYjFB?=
 =?utf-8?B?T24yVUpCWGVzWWpGZEMydHpYeWF5dEVnbG5paGl6S3ovZHVZYllEaEtEb0Mz?=
 =?utf-8?B?MUNJQlBzQmhvK1FQTU1XS1RteG85MGxTRmowUnRwNXpLUFNYWDllRk5VdEV3?=
 =?utf-8?B?OW1tcnU4d1RlUnJKaVpBaFM1RlBsQUZ0MXNFcUxBMGhlUCtrUnN2dm85SW9B?=
 =?utf-8?B?anphaXcvR1I2UUU5VGt6V2hmTXVmSGY3T3VYWnFid21XanlidXRzazNPM0JH?=
 =?utf-8?B?RVFQZ0JNdm9nUnRvNVdxZklOQWJ6bS8veTlMQmdmbFIySURLaXpDQmNyTG1R?=
 =?utf-8?B?SkNBYWVZR205YkVkbXhibjRwSUxUK1JtR0s2YWdkTVRUa2lwRzd5STBtREYy?=
 =?utf-8?B?dU45cjlxT3E1Qit6OEwyMmFoZmhwa05IWWYzQmtUQytETkZoc1RYKysvRWZS?=
 =?utf-8?B?UFlpeHZKN25nNnpuZ0RHNzFURVhyaUxhOU94akRZc21nU1RTSjhhNkZ5VkVG?=
 =?utf-8?Q?rb7t0jMntlS+6MkkWN30c0Y2jltUv9SauQh2X?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <96C3D05CFBF4D34F827A3BA1DB7B2610@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: ibm.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5819.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dedf63ad-da4d-490d-9dc0-08de681c8dae
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2026 20:48:17.7585
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: agzzbzGvxtegybyYqBXg/lAY0JTPZTPK474LRNSpoLBccK0vRji0Qtjrgp/xNbupSTD7VZCPHfa/8IvD0XAnkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR15MB5425
X-Authority-Analysis: v=2.4 cv=YZiwJgRf c=1 sm=1 tr=0 ts=698a4818 cx=c_pps
 a=+v7uXpzEFv5PX1YPhMLqHw==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=JVKeGIjyCkZ9bxHkncMA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: 15WC7yQ2yVCh3-FqsYd9oOVWAU4eX6pO
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA5MDE3NSBTYWx0ZWRfXz9u107MTDlke
 KuzZQqx2BtLJnAZZyPwVrlQTizeJvHHgZPSNFe+rY89zzWmFh1Ar34VzNe0HBU0MXQskbAJd8h5
 CMUh1236abhQM/OknoVS/W5iy7CCSGuuqqXxlQpjbhidRbOSOIbHya1voax4vSC7FahjHyQuxfh
 yhfxsuXLjQq61xqMy2AnnzAB91TzyeXzW0XdDXe3HqThr3R1Q0t/LhdIy53K5yHLwYD2s8GBh6v
 I569I/jqaXsA4d674DpD+TxVLQcnnO5dGdncT3nYF5Wj3zZbCDUC3bwlPM7bBGqTIzSmFh1kbTw
 Vb+Imr6Z4hnJywLyP/sgf+tuKLkpymO5cwtP3nM53q4cqRV0vOjlBoVhq/rrljmBcpVvkR6T4h/
 l8aeFWmyBb+yLtEAB58W6TrdkKbDCFTZ2izrPG9MWxs9L8SZzxIpmfBUWo42GMvoG9IZYb/HIld
 8u5X75S8buatctGyHrg==
X-Proofpoint-GUID: 15WC7yQ2yVCh3-FqsYd9oOVWAU4eX6pO
Subject: RE: [RFC PATCH v1 1/4] ml-lib: Introduce Machine Learning (ML)
 library declarations
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-09_01,2026-02-09_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 impostorscore=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 adultscore=0 clxscore=1015 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602090175
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D5B37C0009
X-Stat-Signature: axwn5aaohji1xajedsfjjkhp6oahrtyb
X-HE-Tag: 1770670108-152149
X-HE-Meta: U2FsdGVkX1+fHl92dDfyGYZnrehGLQsAyxo76g170JusrmxfrDL3WZtJWwe8KUFmOB+tO/ssWePb3AP0v2jmGoCf9sIfPnaZiOZZiOLIug9b1bH8l/brb9bIfNsbTKiiBICggwFx31tT8FONpLt3wsKNwGGrGYJJtijLXr+HbGncEVNJ4ZB4fAQLG0xAH8K35SC3BDSnObE0XjN+F75jZXmre8BlVHB85WK/PeMUfJPGRvwV9xFRi3iyZpXzXGWtUU6aBm2GWJHOjPvP8U6PB/YfQo7Y1fPeDkYdf4dlnOEMAKwkBiINTNfjmx3CsQhQk2nOpo6/RpLRY1fxr9wuaBc7js6FOAQkCDwfsqTOP/YvPvTK+n16lYAnAf7LM8hP6i5CU4KXXQFJuBXrpKdgA8NRDekJyn+D9SlQU9ba1vtsUfDKMxf3MGMCAswCj/rQuLoJN4UNfJS7yoFndkZq4xSqIuHBSNedKc8B7xobAz5T2+5g5J6u8z5Uqni9iSFcCIwUPLXtXWawxinWcRPulC9w85TNyMd8fbHHf7OsnIXDEVTnO4fGpK/FvZYlKlXh9oEfk5CX/sMxx4JPuN2NSORC/+t53dO3upiSrBism/h3cqYjzR4FX+zpIDnqASFeU+da5ymRQtKSci97Zerg8eCB5NIx+vi5gf8F1CLEgRvpWLl/OFtMyQi9yWfn1r6sKYPyL0AcXlLfGUJAGlvmt1qLjS3iF0QhH2Lx8hDeEWKD7MK46ZUdW7kEkRqSeW3tmMRxHdm3R9V+xIhtCDVcY5lDITW9+HDRyI2wPXrnjdKJUHcMYJ4HNWEuU9nVo/IF5pbsPmKG9Bx4Rvlo3/jD8YHylw1CXs7YW6Lk08x7qm8HWrBk8zhrAMIFLHLoU3rtmfv5KGPud8Yy0DMSuz6iCfUuRnLDEGmxlDXMjf7/Dyb6xHBuTgttTOlQda5L8z6/MLHAMv4+k+XVpjjn2Qk
 W2my+GT3
 9hQeM2R0blNquRr67iQsKRc4QHPCKu/pDuv1ZfdapZRVMJC+T0NGN6JMLeFSIYjrcEkIpvCuNutPJc/xmFscREnbHtL2GLBN2xWUyIj0t9F7cqf6g2BV9ucK3G1YPFJa8ggHBPyZXNLU9/6e4s/V9sgdzuygNfdhiWJX2y07sEjYhpb0bHOLRY10hXAPmUldn7Jv51sfZY+DcDUBfQs9NgpK/Uh52vpdFNZvIDA0tQrxw3H5rCqnUWCU8sMCk8QKOE8gjv+MFLO6x9t2ykqOw/HJ0+ZLdrNlGD6tA2rqlTkIbs3PN/DWcGlxIn1s9tDjlg/mCRdL0QDa9W8jF3JZ51thZzdyYsIHoqZTZknVycYyBwpCjlnR7pr/uRXN6LarxWE4LkM2eQtlHBJWSYuo8zqu5qPJK4QkZ8XPpQT1E0YraMRPKGjOmyoFx+5fAqi60bFnuZbfQuXPHhltDVys33nuF8kd8n9TwoJ0I5WpUiXe1NWSQElnX5gs+HwMUihUJcmkt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

T24gU2F0LCAyMDI2LTAyLTA3IGF0IDE2OjUyICswMTAwLCBHcmVnIEtIIHdyb3RlOg0KPiBPbiBG
cmksIEZlYiAwNiwgMjAyNiBhdCAxMToxMTozM0FNIC0wODAwLCBWaWFjaGVzbGF2IER1YmV5a28g
d3JvdGU6DQo+ID4gKyAqIEBrb2JqOiAvc3lzLzxzdWJzeXN0ZW0+LzxtbF9tb2RlbD4vIE1MIG1v
ZGVsIG9iamVjdA0KPiA+ICsgKiBAa29ial91bnJlZ2lzdGVyOiBjb21wbGV0aW9uIHN0YXRlIGZv
ciA8bWxfbW9kZWw+IGtlcm5lbCBvYmplY3QNCj4gPiArICovDQo+ID4gK3N0cnVjdCBtbF9saWJf
bW9kZWwgew0KPiA+ICsJYXRvbWljX3QgbW9kZTsNCj4gPiArCWF0b21pY190IHN0YXRlOw0KPiA+
ICsJY29uc3QgY2hhciAqc3Vic3lzdGVtX25hbWU7DQo+ID4gKwljb25zdCBjaGFyICptb2RlbF9u
YW1lOw0KPiA+ICsNCj4gPiArCXN0cnVjdCBtbF9saWJfc3Vic3lzdGVtICpwYXJlbnQ7DQo+ID4g
Kw0KPiA+ICsJc3BpbmxvY2tfdCBwYXJlbnRfc3RhdGVfbG9jazsNCj4gPiArCXN0cnVjdCBtbF9s
aWJfc3Vic3lzdGVtX3N0YXRlICogX19yY3UgcGFyZW50X3N0YXRlOw0KPiA+ICsNCj4gPiArCXNw
aW5sb2NrX3Qgb3B0aW9uc19sb2NrOw0KPiA+ICsJc3RydWN0IG1sX2xpYl9tb2RlbF9vcHRpb25z
ICogX19yY3Ugb3B0aW9uczsNCj4gPiArDQo+ID4gKwlzcGlubG9ja190IGRhdGFzZXRfbG9jazsN
Cj4gPiArCXN0cnVjdCBtbF9saWJfZGF0YXNldCAqIF9fcmN1IGRhdGFzZXQ7DQo+ID4gKw0KPiA+
ICsJc3RydWN0IG1sX2xpYl9tb2RlbF9vcGVyYXRpb25zICptb2RlbF9vcHM7DQo+ID4gKwlzdHJ1
Y3QgbWxfbGliX3N1YnN5c3RlbV9zdGF0ZV9vcGVyYXRpb25zICpzeXN0ZW1fc3RhdGVfb3BzOw0K
PiA+ICsJc3RydWN0IG1sX2xpYl9kYXRhc2V0X29wZXJhdGlvbnMgKmRhdGFzZXRfb3BzOw0KPiA+
ICsJc3RydWN0IG1sX2xpYl9yZXF1ZXN0X2NvbmZpZ19vcGVyYXRpb25zICpyZXF1ZXN0X2NvbmZp
Z19vcHM7DQo+ID4gKw0KPiA+ICsJLyogL3N5cy88c3Vic3lzdGVtPi88bWxfbW9kZWw+LyAqLw0K
PiA+ICsJc3RydWN0IGtvYmplY3Qga29iajsNCj4gPiArCXN0cnVjdCBjb21wbGV0aW9uIGtvYmpf
dW5yZWdpc3RlcjsNCj4gPiArfTsNCj4gDQo+IERvIE5PVCBhYnVzZSBzeXNmcyBmb3Igc29tZXRo
aW5nIGxpa2UgdGhpcy4gIFBsZWFzZSBtYWtlIHlvdXIgb3duDQo+IGZpbGVzeXN0ZW0gb3IgY2hh
ciBkZXZpY2Ugb3Igc29tZXRoaW5nIGVsc2UsIGJ1dCB0aGlzIGlzIG5vdCB3aGF0IHN5c2ZzDQo+
IGlzIGZvciBhdCBhbGwsIHNvcnJ5Lg0KPiANCg0KQ3VycmVudGx5LCBzeXNmcyBlbnRyeSBpcyB1
c2VkIGZvciBzZW5kaW5nIGNvbW1hbmRzIChzdGFydCwgc3RvcCwNCnByZXBhcmVfZGF0YXNldCwg
ZGlzY2FyZF9kYXRhc2V0KSBmcm9tIHVzZXItc3BhY2Ugb24gdGhlIGtlcm5lbC1zcGFjZSBzaWRl
LiBBbmQNCnRoZSBpbnRlbnRpb24gb2YgdXNpbmcgc3lzZnMgZW50cmllcyBpcyB0aGUgZXhwb3J0
IGluZm9ybWF0aW9uIGFib3V0IGtlcm5lbA0Kc3Vic3lzdGVtIGFuZCBleGNoYW5naW5nIGJ5IGNv
bW1hbmRzIGFuZCBub3RpZmljYXRpb25zIGJldHdlZW4gdXNlci1zcGFjZSBhbmQNCmtlcm5lbC1z
cGFjZSBzaWRlcy4gRG8geW91IG1lYW4gdGhhdCBpdCBpcyB3cm9uZyB1c2luZyBvZiBzeXNmcz8g
SGF2ZSBJDQptaXN1bmRlcnN0b29kIHlvdXIgcG9pbnQ/DQoNClRoYW5rcywNClNsYXZhLg0K

