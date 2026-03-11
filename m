Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 039C3104951E
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 09:43:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 218666B0005; Wed, 11 Mar 2026 05:43:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C6EF6B0089; Wed, 11 Mar 2026 05:43:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 053446B008A; Wed, 11 Mar 2026 05:43:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C75746B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 05:43:14 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 61C1759FE6
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 09:43:14 +0000 (UTC)
X-FDA: 84533293908.23.7631401
Received: from mx0a-00190b01.pphosted.com (mx0a-00190b01.pphosted.com [67.231.149.131])
	by imf12.hostedemail.com (Postfix) with ESMTP id 74CD640006
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 09:43:10 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=akamai.com header.s=jan2016.eng header.b="AnXim/Xa";
	spf=pass (imf12.hostedemail.com: domain of mboone@akamai.com designates 67.231.149.131 as permitted sender) smtp.mailfrom=mboone@akamai.com;
	dmarc=pass (policy=quarantine) header.from=akamai.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773222190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8fUwIsJ5MMk7XXIJFgjioe1rTDuEZYd9UPgT1/TULtU=;
	b=sh0lZiqO2IHyoPeblTbBKS1L5TKZvHdxDx+DyHcQyNjo0J+KC9hD2ucEyzwyvlFi3/kbID
	Dqiwiw9z4GVW7wCtxHn+IXgZVffwAzsEFpSOZlYZ05fCYAQqgmyAJWCyAZ6bYjk6YO//f8
	UDaQoWYP7EcsS0NEhLcJ2LZh5Gq9EDk=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=akamai.com header.s=jan2016.eng header.b="AnXim/Xa";
	spf=pass (imf12.hostedemail.com: domain of mboone@akamai.com designates 67.231.149.131 as permitted sender) smtp.mailfrom=mboone@akamai.com;
	dmarc=pass (policy=quarantine) header.from=akamai.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773222190; a=rsa-sha256;
	cv=fail;
	b=gegKIuiBATs16K9TuRVLoY1+hIoqOG0IhKtZP1zDrVV3fulSVWx2P3VDlD7942XcX0GqYX
	OKPMKgvt/+BxcHOnVXpOSre4PNLMTBev3C8jFoy9r8T7XfC8NpkOcGtxcVSgyuu8rY5zl0
	2mRtDXt+XSy3TjAJ6mfoTSNbTqQLe38=
Received: from pps.filterd (m0050093.ppops.net [127.0.0.1])
	by m0050093.ppops.net-00190b01. (8.18.1.11/8.18.1.11) with ESMTP id 62B5mO8t2799182;
	Wed, 11 Mar 2026 09:43:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=jan2016.eng; bh=8fUwIsJ5MMk7XXIJFgjioe
	1rTDuEZYd9UPgT1/TULtU=; b=AnXim/XaB5Ma5uA9ETvIrUpm8tklWQN7P2dDrn
	w82a6XO9Vg+nVS+Ozo+cB6NXM1WkorkduHB5GtSW/DRfTD1uzMh5yycWp0mgwuFn
	7/2nyg0LnAed2m9kTR/bAmKsfxjMYLYhB5r03t9PifkJ1FAOZMcuZVXfL2Ez4u4x
	ig2/Odv6G2hbv/+AJ3XJEFd2o/DkdHH48P4zmcIfJSgt5vuK0AXW/WsLy/7RQx78
	zqqUWKJhA1d3Ih4OSvDLWwmPXJ8ogxdzEZA6XPWubzy/mWZJNXG75OhyHx4OtQfB
	TvDzvTkKhwwarjuAkSs8AZZ0SAST+d8tHc+KYAJzgy7P2y3w==
Received: from prod-mail-ppoint4 (a72-247-45-32.deploy.static.akamaitechnologies.com [72.247.45.32] (may be forged))
	by m0050093.ppops.net-00190b01. (PPS) with ESMTPS id 4ct25r139q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Mar 2026 09:43:03 +0000 (GMT)
Received: from pps.filterd (prod-mail-ppoint4.akamai.com [127.0.0.1])
	by prod-mail-ppoint4.akamai.com (8.18.1.7/8.18.1.7) with ESMTP id 62B9XvxH008261;
	Wed, 11 Mar 2026 05:43:02 -0400
Received: from email.msg.corp.akamai.com ([172.27.50.220])
	by prod-mail-ppoint4.akamai.com (PPS) with ESMTPS id 4crg807xby-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Mar 2026 05:43:02 -0400 (EDT)
Received: from ustx2ex-exedge4.msg.corp.akamai.com (172.27.50.215) by
 ustx2ex-dag5mb3.msg.corp.akamai.com (172.27.50.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 11 Mar 2026 02:43:01 -0700
Received: from PH0PR07CU006.outbound.protection.outlook.com (72.247.45.132) by
 ustx2ex-exedge4.msg.corp.akamai.com (172.27.50.215) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 11 Mar 2026 02:43:00 -0700
Received: from CH2PR17MB3797.namprd17.prod.outlook.com (2603:10b6:610:80::18)
 by MN2PR17MB3774.namprd17.prod.outlook.com (2603:10b6:208:203::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.12; Wed, 11 Mar
 2026 09:42:56 +0000
Received: from CH2PR17MB3797.namprd17.prod.outlook.com
 ([fe80::cf6d:89de:646d:d1a2]) by CH2PR17MB3797.namprd17.prod.outlook.com
 ([fe80::cf6d:89de:646d:d1a2%5]) with mapi id 15.20.9678.017; Wed, 11 Mar 2026
 09:42:56 +0000
From: "Boone, Max" <mboone@akamai.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>,
        Alex Williamson
	<alex@shazbot.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Lorenzo Stoakes
	<lorenzo.stoakes@oracle.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        "Suren
 Baghdasaryan" <surenb@google.com>,
        Michal Hocko <mhocko@suse.com>, "Alex
 Williamson" <alex@shazbot.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>,
        "Tottenham, Max" <mtottenh@akamai.com>,
        "Hunt, Joshua" <johunt@akamai.com>,
        "Pelland, Matt" <mpelland@akamai.com>
Subject: Re: [RFC 1/1] mm/pagewalk: don't split device-backed huge pfnmaps
Thread-Topic: [RFC 1/1] mm/pagewalk: don't split device-backed huge pfnmaps
Thread-Index: AQHcr+1eklEgHPr7TUGT7iw+X10ZcbWmpDOAgAAsNgyAAKuYgIAAKNeAgAA99oCAATQqgA==
Date: Wed, 11 Mar 2026 09:42:56 +0000
Message-ID: <6CBB0401-26DD-4EF9-949C-54BEAD3ABA33@akamai.com>
References: <20260309174949.2514565-1-mboone@akamai.com>
 <20260309174949.2514565-2-mboone@akamai.com>
 <51eeb09d-d3f4-412f-85da-690fdc0f8e6a@kernel.org>
 <CH2PR17MB3797A91D5107B6E347EEDD97BF79A@CH2PR17MB3797.namprd17.prod.outlook.com>
 <da2ebc9f-ec82-4c55-851c-b27110efdf8c@kernel.org>
 <83842620-AD01-4619-845F-8DE7DF1F8F31@akamai.com>
 <0a652e7e-339e-4f98-b591-7fe5680e2006@kernel.org>
In-Reply-To: <0a652e7e-339e-4f98-b591-7fe5680e2006@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH2PR17MB3797:EE_|MN2PR17MB3774:EE_
x-ms-office365-filtering-correlation-id: a0739317-3875-4b46-4577-08de7f529300
x-ld-processed: 514876bd-5965-4b40-b0c8-e336cf72c743,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|6049299003|1800799024|7416014|376014|366016|4053099003|38070700021|56012099003|18002099003|22082099003;
x-microsoft-antispam-message-info: RQ0ZP64t3OBAE/POsnKj9hk1C6E+0LiPeWcfw/yY3zGcTjiohX81BFOZPLLfnwhJFJZk4dREcUexcyQqUeSiGdQsMP3b7SPQeeCGXpbxWfPBRb71QDNOgUYkLVGqSE+uWBUqPWBtgD2H9Rkfy9XNgk7v9c/ZkHSwSumvkQl4xATOmrhsHPDDxnKogb6cRqp/8xX+i5JVaO2dDqw24XJr7kYklwYUo8sEdJYEZNiiZ1BLp68VzetBjn4D2wzVvsYVUrfUD3VuYpDuDuxunhojMEc8ho2rQZZSGWromQn0cD1zwFp+aeBxSXlXsiUmXdM1i4Qe3cFd48/FhgOcsNDZ9/fj1GnySorOvmwiL6FFxPPhtpbzyEd0ESAlBRRbImW+TSghz1tDLd3LcXPFMNe23bbdatqD+ygQj2Vca9Ufgnln1mYTRCg6FG6MqGI1f5EUY7v3V2vLFHN1yUhR3oocCdCAv0RAdFXNdK0KhBCBycvksYvCb5k1OeQvkGtdxFyc+Oo5C/0A+lyDnNxn9hnz5msK8xNU9RvTe+PMmQl+1x1gL/SR6rtCbetuABYedJR9+vCgcukTjcXqqRUvf+ehqo1sUuiH/dGOm88qL8FdWtUBULBkbLE4VGbFXVzlS418FpAWd50uddpyfyMXgPU2gd8DlYC9WbopPEZhc15++noOqxfTlWVL5TWoHBvH1yU2r4bMvlXWSNHONinnqTVTDf9D2TjOtMoyEgqPV81adCt8qf56ppNRhdYhFdoWZvX/9IH4vqYtSbv9QtJvr8J1ulDlGyDb9sIHJDeLD9y9Auw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR17MB3797.namprd17.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(6049299003)(1800799024)(7416014)(376014)(366016)(4053099003)(38070700021)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ODdJUlFTQnFZeE1Sdm8zWUI0MFBnNHgxdXo2T1V2T2NBY2lEa00vUWlLQUs1?=
 =?utf-8?B?VDVDaEkwUmZKRktybk05SGJtemdic2NNaVBWLzZzN3I2Q2g2U1VGUS9CQ0hp?=
 =?utf-8?B?emlhY1VKMGthWUQxZlUxRU5kL1ltTXJqZ0Yrd0tGbFVQcWgrY3RSYTJDUURM?=
 =?utf-8?B?N0xPWndpN1VRTlcrVzZlUU1sOXNla2lVbXZHZnorUXpEUkxibGc0UWRUZm8r?=
 =?utf-8?B?VDZWcm42cm9QdjY0UEkxSVJueVp3Z1pSbHlmMlFudzJSc1ljSGhSQmFsZ2Zm?=
 =?utf-8?B?YUhqNDNBYk9OZ01adllxTDR3SmNqTmZCSmJTVlp1V3Q5b1lZU1p3T2hudXJk?=
 =?utf-8?B?L1BwUlNhM0pXYm9rbVFIemptNGZxNGc0SnAreGdmSytIdmNrV2xLaVpYWDM4?=
 =?utf-8?B?aUx4SWE3ZjhDb2F0enF0TkVsOHVPY3VsR3dqUGNqR3JDSHpmNUpOMXJKVlFL?=
 =?utf-8?B?ZDhoM05GdTQ0VWFEUDI1UHlhVCtKcC9pbkMxWFl6TmxERVAxMFA4NzBmMit5?=
 =?utf-8?B?ZUhiMC9KU1dvbFFHYU1EWHRFajY4M0dDSWJtL0Z5Q2VsQk1vM1RacXZXT2ZC?=
 =?utf-8?B?aFJmdnQ1a0NsQXl6TThvS0VOZXdJTER3bUZRYURlYW9oN3JlYnNlMGkyVEhC?=
 =?utf-8?B?eUt4bkNxMDQreTYzdnNCM2lFZ2lKRW43UTJTQUliOWgyclp4WktZaEI4YXVo?=
 =?utf-8?B?SFF0MmdadlpSY3RSVFBQSDNWZ1pYVDdVUzNyandGazVNUnF3UGlmYWRQRVRo?=
 =?utf-8?B?V01tU3RDR3BXL3ozOUE0dHhxVGROc1JvTDYzZVBMUjd0NTU3ZXNiQjM4NXVT?=
 =?utf-8?B?YkpsQ1JPWjNWTFFUcmZYdzNuQURDRTRVeENpUTByejlNWDJJRFVMWlQ4S0ZQ?=
 =?utf-8?B?dVpOaDhQRTRpbjhIeFJlU2RTVVJhN0ZRQkwvZ1NrYkl6QXpTMTlMa2FSZzhi?=
 =?utf-8?B?M1pPTThkdHhFdys0U2U5TWQ3NTd6dVhsUE9jbEx2amhwZm1NMDVnQnRiNVI4?=
 =?utf-8?B?d21PeXlEblN1OVl5dlNOMjRMcUJyWkdIMmNWR2RlOEQrT1ZEQTVWSFd4ZDVw?=
 =?utf-8?B?Rk0wMGpZWUhld2dwcElYSkY1MktJVzM5aHc2RmUyUHJEZmRUL3A2L3dtcTZQ?=
 =?utf-8?B?MXJrTDRIeHJmd3ZNZDJHMVJza3pOV1B4TUc4VGpGajU1VGFqeThrOGQyNlIv?=
 =?utf-8?B?K3lFQWRudjhQbEhLSlQrVHVCbjFjSmpjbkJIem1tRzlLQTFyaUx6SXlPQjJI?=
 =?utf-8?B?VEdJL1BVRGh0SVNCOTFPRTI2Y2xreEw5b2xnKzBaTmM2c1dJdStnQWxmaUp5?=
 =?utf-8?B?WmxhSGZXam4zMStqV1VzNzQ5L3Z2Q0UrT3JBN29RNWhkcjg4cnhTYWc4OS9k?=
 =?utf-8?B?UDhwZ1hFNHlEYmc0N0FGcnFjekhxZnZKSHdoQkdPQjZnWjFnUStCNCtEOHd1?=
 =?utf-8?B?YVpjWmQwTVFmbXRScndlblQwVTc5WHoyc2M4NVpHZUJUWUxtd1dCcWhjaUty?=
 =?utf-8?B?Mk5pVHFCS0oyd3BubG5OSTMrVzk4S3NGeUlCUUhZRUh0UWV3b1A0cXlLbmw1?=
 =?utf-8?B?dXJYTGdwajhhZDF5S1FDUlorSVhJeUJtenM0RXlNNEljd0pYMS9mS0RHdnoy?=
 =?utf-8?B?R3JWQklVYnIzTmRFa0t5QXdsbktxbTM0cDJPM2pQSHZ4bVVkMHpIZ2RnSDJX?=
 =?utf-8?B?U21kN09wUS8rNlhFTjNmOUttcEt1Z0g0Ty8veXNvbTYxUjBpeGpYMW9WbTdn?=
 =?utf-8?B?YW9oaG5uUUZGZi84VEo3dFE2Ymlzcitrc3BUdThtK3NqWjdMcE9sMWxLQnZa?=
 =?utf-8?B?MWVyUWxVQlRhRFlQWTk1ZXFIYzFNUkNNMlAra3VCbDRWMWI0UHJIMWZac09F?=
 =?utf-8?B?MzkyNFhQeGJCazFKa09oSjl3cERMay8rNFVycDcxZlBQbkZ1aTdESXppM3Jq?=
 =?utf-8?B?VjFCVW9LN1BJUFpUMnkxZVlpc25XNnNRWGJKL3FWV0licUFuRElHaG56RGpk?=
 =?utf-8?B?MnhqT1ZzQmFIOXV0RjZBVENyNG1ZbFNVL1RuZWMrczgxTGRhdUVuc3BPZWFR?=
 =?utf-8?B?WTVsVGhrOXZVaCtsd0NtQkFvTU8yRWxPUUlSR0tOc052UlhlZldNL1crTTdx?=
 =?utf-8?B?WTQ3cGkrR1owY1phU0Jpd05KWkxGd0lrditSWnFHRCtIbzhPOERKU3BZVUVv?=
 =?utf-8?B?S3UvdWRTWXpIMFh2MmVBZkpIc2EraEhnbElNRURWa215My8yVkF3THBFZmFN?=
 =?utf-8?B?MTUxajRrZHJ1T2NNRjhTYUJ3V3RjeTg3QzFtL25iMHhsUXpiRjI5Y1Jzd0Rt?=
 =?utf-8?B?aGUxc1cxRGpTZWw5WHQ4Z3FWREpmTkFBU1dBWVJ6ZVlmQXVDcEx0UT09?=
arc-seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z+1AnVVoSJ3y3ZmKHWKtYS+MKVQRbtdQkl4gqDosSLJ1ndvp1oilUV7Ch6Nrs4UhhP0lEHnrh3521v9b+FvDqEp6fq3InVJqPMZ5kfgFKg3BLyA7r8XERRXj3h7vQVQSK2V5lPqAwRx0LWefOB82El9izM0IIKtL3+OvnGiAGnQb/InOWjfkBMKwZvH2hcOuvZmyHAYjWAik5LcfqgKNDfQTkdgSFy68/ADAkKuluSnykJ9fzrLyVQJqC76eFT1Gvi59B1JBZ2taSFqDjqRx/cvPDT4sVXJ3WxNlSPEn3wCcr9hCh7uZel9XTrVppNWr4f4atPX4Joq8Kt5uGVgBVA==
arc-message-signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kiTOwyrWJ6OGl+Muuqu/6zFEcnwt28bju6hR8KBzYpo=;
 b=GuygSrtaelQUlafrvp4eccCRhDPPeNGrJ2u9jsTQ5vlFLEj07+BrTjpGACXu1TnrnxyXCWjk3nuxp2R60grs3tA9az+lxhov0BXx+lP1XJ3DyzNVvt4RC/JAQzDX0LDofTTvAcGc3c3eiaIHdG3FlO2OBkzByfxPDZ0Rlbjs+SCE1X5W8N+VuUol62aL8M54WP+r0dZqhKV38A6BSz+zaBMZ8ZadezVwEki4z+Zj9fawmeRijjRs+P+tp6g6oBkwgKdqBndcSMjA7whF1fiifugKvQEDwdt+JAjHxXbfmTDmY/kXEsnRDpW8E+OqGPXyY5fIeP7zeUXx5RkXuQ8RhA==
arc-authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=akamai.com; dmarc=pass action=none header.from=akamai.com;
 dkim=pass header.d=akamai.com; arc=none
x-exchange-routingpolicychecked: ZFhbq/G6SDTmRVpXRRKsEspO3kFlrcyO7fS3wtVw0+75cd4V2cDPI4kc0xTjAAhBjeaZru5yGNJP3KJiOlDiG/eDm6j+ydzfes6fgJFba+TS6hl7bc8tTcLafRf5xqatpxxm67ZrRiQwhsc59rcEWauqCipBhA9S0ldUfxeRAVBJFMNUCUWC2FWBTKkU0yyzuYhLXIfzWhKq4G3wlV/QF6hlfr+G+XdsTuedEy3pDfVE3F4lF3pMrpQ+38WlcOk93hQtwG9AYamI1SvK/VHVULdIq+mf+m8/B3NWOf40kSXln/XF72Kla9yHJhXfd1YvAGzvGSsh5izFW75qLn1rmA==
x-ms-exchange-crosstenant-authas: Internal
x-ms-exchange-crosstenant-authsource: CH2PR17MB3797.namprd17.prod.outlook.com
x-ms-exchange-crosstenant-network-message-id: a0739317-3875-4b46-4577-08de7f529300
x-ms-exchange-crosstenant-originalarrivaltime: 11 Mar 2026 09:42:56.3243 (UTC)
x-ms-exchange-crosstenant-fromentityheader: Hosted
x-ms-exchange-crosstenant-id: 514876bd-5965-4b40-b0c8-e336cf72c743
x-ms-exchange-crosstenant-mailboxtype: HOSTED
x-ms-exchange-crosstenant-userprincipalname: xq1arOMsSUFndYuqm28QUkZ8uI6QMwl+MsIDaFMZpuYDCmrv9xQr5CSmf+dJdYZVi7YAPCUNgYOMdynF1Ntf+g==
x-ms-exchange-transport-crosstenantheadersstamped: MN2PR17MB3774
x-originatororg: akamai.com
Content-Type: multipart/signed;
	boundary="Apple-Mail=_C4E92512-2433-4D58-BCE5-E5CCE563A1B4";
	protocol="application/pkcs7-signature"; micalg=sha-256
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-11_01,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxscore=0 mlxlogscore=999 malwarescore=0 bulkscore=0 phishscore=0
 adultscore=0 lowpriorityscore=0 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2602130000 definitions=main-2603110080
X-Proofpoint-ORIG-GUID: ahc_g-aozXhe-9G3a48ihZjYfudMuCPb
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzExMDA4MSBTYWx0ZWRfX9+xj0rFQO6U0
 yPN3vtoW+QMssEUtgSs1TjrJ4v3yqxRQOdZNmFc9DbQZkSaK/vWb9ch5qZrTmRlLB+gfBVhiYQz
 Fy9GcKl1h/8P0LeToKET2fFJZqHleMR/eWjU0fDhpIXS7i8DrbWOHQa3/cgW6WcVamIIvL8zi2/
 9Hk6FZaQfqjqnYhSWW20R6epSq0zSSkGzUAdWpa/NTczdtPtHvZJ4gGJ4m7Qm/6PDBewYR9FthH
 x09ukGnsZUdw5mmwCTBbwslmqDb4DvrVH8F2nQIKYHjl7ZKwMJzdM/9ZNYdZEurrh7nAiKBga/2
 te0962Gu0Ts74wXPRvjv0oXg55NgS76Wu8c3kTMEND9nBoSJSvDtmjKpUbh7u2yYRFVtVDGt+Nd
 2QsjIsp+QptSNwgrpslxlzfydQcZY3SnNBxYtCzbmUfkjchMYePgSBT2Cm8UBHbi8uKbUbPrkTC
 APl58DkA2QK0uXXK3BQ==
X-Authority-Analysis: v=2.4 cv=JNU2csKb c=1 sm=1 tr=0 ts=69b13928 cx=c_pps
 a=NaJOksh5yBwW9//Q5C/Ubg==:117 a=NaJOksh5yBwW9//Q5C/Ubg==:17
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=Yq5XynenixoA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Ifg-1AOnLHOf1gn6spyb:22 a=d4nn1RXdvEacMIURMw2s:22
 a=VwQbUJbxAAAA:8 a=968KyxNXAAAA:8 a=X7Ea-ya5AAAA:8 a=hoJ6AWInUe9SO-5oncMA:9
 a=QEXdDO2ut3YA:10 a=aUQEjLJJORIxqg3IqZUA:9 a=ZVk8-NSrHBgA:10
 a=30ssDGKg3p0A:10
X-Proofpoint-GUID: ahc_g-aozXhe-9G3a48ihZjYfudMuCPb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-11_01,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 clxscore=1015
 adultscore=0 malwarescore=0 phishscore=0 suspectscore=0 bulkscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2603050001
 definitions=main-2603110081
X-Stat-Signature: 83otmmuqk3x6hxn3e4ojqannas8waqj1
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 74CD640006
X-HE-Tag: 1773222190-660289
X-HE-Meta: U2FsdGVkX19I5B2U6ZKhCO5QB0NKF/aZeT9pjVCc+w37wX/soN5nbY71wukQHxEsXbTqoT8F3e/oH1r2MXpeU/D2ywSohdCXtKucCZOILc+LWktfYRPiMAsgfEmGSTFv7/tc6xEtBbPs1kGBJNbFgDr7zt5KNEDn0NV8qmanv+4sgqat47X0qWVN6RsSBfNvF5vXvuA3fAcr85A2pLtXlj9ZuDsIqgfMg5tGITKRzGek/uH+alRZm+SDusOd6n1McbQFuz/ecEwzt0r/xCv99Lnt0U69KQ9Wi2mOW2+AH1a9ff2tCmieu2vvcPBhXx/gxIO5B6YcDfghTkbolPDiwxCyX5lw6NPzVlps37VFR7AC+iY6NFrgQDl/KpRV0QUSi3gRvCz+rBmQJ/z+bcMWkOE9qecY/rNaJZPYpk6BMi4rIXbOn//fiep5FFtGaASq1kXQwvmuGpDSN1ZdQu43D8TCmYp4da6EcOAdii74r5rYGwMYjZncPBqfFSSaU34DecVOcO8n/ro7d2Wjs/5pCMP5XxKzdZ4YYnNOotdG1oMHbVo6lW+ThxsI++CfZTdb4ZWw8says/T5iwRFL4f+A/aq+HFDi7Uo4YpJKICmbIjGn3ZvpDxzhen9AzytqMwYpBdAlZoyJi5Jj7daWTnOlvSp4Ufx8EfpfA/9/DzBOOVaKx6T2HIxqkSasicRit8xPvasIAS2ZxlX6J8lqegjacbYdwOHnZKkohnr4am/hAXP4Xn6IoT3wsqW8rrBg0SLeYbO2upOYk3mGhw/5xI3vr7mXDsuLpFmTxB72ZW27OnFBOgK/Bpgdgxcu1UmnyLsCSbNZCnGJR8Ne8jf5/XgMWdJBRsJ9xdFpfXcS80dBkOokt5cvVroyU2ib9uEfSdnATgiGKIe1pxWTBBcdfZKegsrZcizbnR3ObY2kzjXBmYnkXt9ZoJdxwgOMdveWAvcsXbQF7A8epQ/3D4rAm/
 7RD7CVLD
 nPuqlZjp9owNKHAvGesAjZ29hJMLJoqAETiwIiLinQBbD+VbFbTuu+IEAfKvecwBZRx+OsNc56224kvSg9QonOVWm/suALR3h0WQgSZ1XU8aGOxSJIeVZlnV/dOXr+3GfdMk//qBXzehpxI+lSyJFJPYcBZlb9KfpNIUvgYXH2jStRAPEEoJaorPw1K0yv61ncIvNBFpeZo+Z00cl50+0CKObQNVs9Gbthm+e78uz9h7G3rdvK71JyNh8jXUMkTHCD0or00KZH/r4utcOuOmz9pmkwJ2LjKC+/Z1Mt+4wdp0HtH7XtBRRte5rqnNtfrVY5hL5X/IXOavipi5TkbmYDHrIzuhksSJQA24G0dn0gJGZTW0X3NySFXqShvXDh9/9+Wrrblj08rNZTn6nheyqOwDnlcCzAhX9mzYUuPM32TsJdSpMyquJuJOCIITxwB1HHbFMiaWYPLURp5MiCPHreBg8WMKNZyAoNL9+obQTX74k2YlbwVvWdy+wdybclVIaPEA79fs/XZguHlmq2U0IGM5f2UoRjUCIHjOrHhDVOO2YUu5IrD8KSBJrnyFDRB62AvSRMGVievVq06ROShi69XzBPZyDGBhBN/V77nQg42Lc1ZemEoOKYSVVRtyZ2dqTx5dcHEzzT4Bkyc3lw5o34PmSVQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--Apple-Mail=_C4E92512-2433-4D58-BCE5-E5CCE563A1B4
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8


> On Mar 10, 2026, at 4:19=E2=80=AFPM, David Hildenbrand (Arm) =
<david@kernel.org> wrote:
>=20
> !-------------------------------------------------------------------|
>  This Message Is =46rom an External Sender
>  This message came from outside your organization.
> |-------------------------------------------------------------------!
>>=20
>> I was previously testing on 6.12 and didn=E2=80=99t see any changes =
to vfio-pci or
>> pagewalk.c which prompted me to check whether I could reproduce the
>> bug in a more recent kernel. =20
>>=20
>> However, when I tried to reproduce the bug on 7.0-rc2 (after adding =
some
>> tracing to get a clearer picture of the sequence of events) it =
doesn=E2=80=99t happen.
>> The VFIO DMA set operation is much faster on 7.0, so possibly the =
race=20
>> window is too small for it to occur in reasonable time.
>=20
> Interesting. You could try adding a delay to a test kernel to see if =
you
> can still provoke it.
>=20
> There is the slight possibility that something else fixed the race for
> your reproducer by "accident".
>=20
> [...]

Could be that the race window was made a lot smaller by [1], I see that =
the occurrence
of the race also drops significantly already when I=E2=80=99m just =
adding some extra trace
logs in the VFIO DMA set functions.

[=E2=80=A6]

>=20
> Just to double-check: is that expected?
>=20
> I wonder why "-EINVAL" would be returned here. Do you know?
>=20

I don=E2=80=99t think it=E2=80=99s expected, but at least it=E2=80=99s =
an error that can be caught in userspace.
I=E2=80=99ll do a bit more digging into why and where that originates, =
but I think that=E2=80=99ll get a
patch in vfio.

The -EINVAL originates from:

vfio_dma_do_map -> vfio_pin_map_dma -> vfio_pin_pages_remote
-> vaddr_get_pfns -> pin_user_pages_remote (mm/gup.c)

Possibly that=E2=80=99s also the origin of the concurrent PUD =
modification that requires
the retry in the walker in this patch.

>>=20
>> For my own understanding, why is this patch preferred over:
>> - if (pud_none(*pud))
>> + if (pud_none(*pud) || pud_leaf(*pud))
>> in the walk_pud_range function?
>=20
> It might currently work for PUDs, but as soon as we have non-present =
PUD
> entries (like migration entries) the code could become shaky: =
pud_leaf()
> is only guaranteed to yield the right result if pud_present() is true.
>=20
> So I decided to instead make walk_pud_range() look more similar to
> walk_pmd_range(), which is quite helpful for spotting actual =
differences
> in the logic.
>=20
>>=20
>> I do think moving the check to walk_pmd_range is a more clear on the =
code=E2=80=99s intent and
>> personally prefer the code there, but I don=E2=80=99t see why this =
check is removing the possibility
>> of a race after the (!pud_present(pudval) || pud_leaf(pudval)) check, =
as to me it looks
>> like the PMD entry was possible to disappear between the splitting =
and this check?
>=20
> I distilled that in the comment: PMD page tables cannot/are not
> reclaimed. So once you see a PMD page table, it's not going anywhere
> while you hold relevant locks (mmap_lock or VMA lock).
>=20
> Only PMD leaf entries can get zapped any time and PMD none entries can
> get populated any time. But not PMD page tables.

Gotcha, thanks!

>=20
>>=20
>> Anyways, regardless, this patch resolves the bug and looks good to me =
- what=E2=80=99s the=20
>> course of action as we probably want to backport this to earlier =
kernels as well. Shall
>> I send in a new PATCH without cover letter and take it from there?
>=20
> Right, I think you should:
>=20
> (1) rework the patch description to incorporate the essential stuff =
from
>    the cover letter
> (2) Identify and add Fixes: tag and Cc: stable
> (3) Document that we are reworking the code to mimic what we do in
>    walk_pmd_range(), to have less inconsistency on the core logic
> (4) Document why you think the reproducer fails on newer kernels. (or
>    best try to get it reproduced by adding some delays in the code)
> (5) Clarify that only PUD handling are prone to the race and that PMDs
>    are fine (and point out why)
> (6) Use a patch subject like "mm/pagewalk: fix race between unmapping
>    and refaulting in walk_pud_range()"
>=20
> Once you resend, best to add
>=20
> Co-developed-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>=20
> Above your SOB.
>=20
> To get something like:
>=20
> Co-developed-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Max Boone <mboone@akamai.com>
>=20
> Note that the existing
>=20
> Signed-off-by: Max Tottenham <mtottenh@akamai.com>
>=20
> Is weird, as Max Tottenham did not send out this patch. If he was
> involved in the development, you should either make him
>=20
> Suggested-by:
>=20
> Or
> Debugged-by:
>=20
> Or
> Co-developed-by: + Signed-off-by:
>=20
> See Documentation/process/submitting-patches.rst
>=20
>=20
> Let me know if you have any questions :)
>=20

Will do, thanks a lot!

> --=20
> Cheers,
>=20
> David

[1] =
https://lore.kernel.org/all/20250814064714.56485-1-lizhe.67@bytedance.com/=



--Apple-Mail=_C4E92512-2433-4D58-BCE5-E5CCE563A1B4
Content-Disposition: attachment; filename="smime.p7s"
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCCCcow
ggShMIIESKADAgECAhMxAAAAIa0XYPGypwcKAAAAAAAhMAoGCCqGSM49BAMCMD8xITAfBgNVBAoT
GEFrYW1haSBUZWNobm9sb2dpZXMgSW5jLjEaMBgGA1UEAxMRQWthbWFpQ29ycFJvb3QtRzEwHhcN
MjQxMTIxMTgzNzUyWhcNMzQxMTIxMTg0NzUyWjA8MSEwHwYDVQQKExhBa2FtYWkgVGVjaG5vbG9n
aWVzIEluYy4xFzAVBgNVBAMTDkFrYW1haUNsaWVudENBMFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcD
QgAEjkdeMHsSTytADJ7eJ+O+5mpBfm9hVC6Cg9Wf+ER8HXid3E68IHjcCTNFSiezqYclAnIalS1I
cl6hRFZiacQkd6OCAyQwggMgMBIGCSsGAQQBgjcVAQQFAgMBAAEwIwYJKwYBBAGCNxUCBBYEFOa0
4dX2BYnqjkbEVEwLgf7BQJ7ZMB0GA1UdDgQWBBS2N+ieDVUAjPmykf1ahsljEXmtXDCBrwYDVR0g
BIGnMIGkMIGhBgsqAwSPTgEJCQgBATCBkTBYBggrBgEFBQcCAjBMHkoAQQBrAGEAbQBhAGkAIABD
AGUAcgB0AGkAZgBpAGMAYQB0AGUAIABQAHIAYQBjAHQAaQBjAGUAIABTAHQAYQB0AGUAbQBlAG4A
dDA1BggrBgEFBQcCARYpaHR0cDovL2FrYW1haWNybC5ha2FtYWkuY29tL0FrYW1haUNQUy5wZGYw
bAYDVR0lBGUwYwYIKwYBBQUHAwIGCCsGAQUFBwMEBgorBgEEAYI3FAICBgorBgEEAYI3CgMEBgor
BgEEAYI3CgMMBggrBgEFBQcDBwYIKwYBBQUHAwkGCSsGAQQBgjcVBQYKKwYBBAGCNxQCATAZBgkr
BgEEAYI3FAIEDB4KAFMAdQBiAEMAQTALBgNVHQ8EBAMCAYYwDwYDVR0TAQH/BAUwAwEB/zAfBgNV
HSMEGDAWgBStAYfq3FmusRM5lU0PV6Akhot7vTCBgAYDVR0fBHkwdzB1oHOgcYYxaHR0cDovL2Fr
YW1haWNybC5ha2FtYWkuY29tL0FrYW1haUNvcnBSb290LUcxLmNybIY8aHR0cDovL2FrYW1haWNy
bC5kZncwMS5jb3JwLmFrYW1haS5jb20vQWthbWFpQ29ycFJvb3QtRzEuY3JsMIHIBggrBgEFBQcB
AQSBuzCBuDA9BggrBgEFBQcwAoYxaHR0cDovL2FrYW1haWNybC5ha2FtYWkuY29tL0FrYW1haUNv
cnBSb290LUcxLmNydDBIBggrBgEFBQcwAoY8aHR0cDovL2FrYW1haWNybC5kZncwMS5jb3JwLmFr
YW1haS5jb20vQWthbWFpQ29ycFJvb3QtRzEuY3J0MC0GCCsGAQUFBzABhiFodHRwOi8vYWthbWFp
b2NzcC5ha2FtYWkuY29tL29jc3AwCgYIKoZIzj0EAwIDRwAwRAIgaUoJ7eBk/qNcBVTJW5NC4NsO
6j4/6zQoKeKgOpeiXQUCIGkbSN83n1mMURZIK92KFRtn2X1nrZ7rcNuAQD5bvH1bMIIFITCCBMig
AwIBAgITFwALOJfLRtbGzZc1dwABAAs4lzAKBggqhkjOPQQDAjA8MSEwHwYDVQQKExhBa2FtYWkg
VGVjaG5vbG9naWVzIEluYy4xFzAVBgNVBAMTDkFrYW1haUNsaWVudENBMB4XDTI1MDgyODA3NTYy
OVoXDTI3MDgyODA3NTYyOVowTjEZMBcGA1UECxMQTWFjQm9vayBQcm8tNDZZVDEPMA0GA1UEAxMG
bWJvb25lMSAwHgYJKoZIhvcNAQkBFhFtYm9vbmVAYWthbWFpLmNvbTCCASIwDQYJKoZIhvcNAQEB
BQADggEPADCCAQoCggEBAOX+npfSrX/rwhOySq6aejQMUVslPFpNvXdEnmMlnEjR95gq0Ygp+wQc
Sde+JGBpGHsPMzHT1Nd3V1acm4cW1WB1aRqJOMfSLifg6SLkq2EM9WsftEiA1G4BT4UP0PFZY2Os
6TXvebAuVg6LwhB417rEJ2kuS/DKpiG8trAVDR6Uy9vbSMBp6iIewBc9r0CjW8l1zgRr+uQpXEUP
mF2BV0l3Qo5r0nhPqTWR9oAX4/oTqnhbEhQ3tOFYTjzO1K9DdzX8mVggVSZz/M0v0gtkZVvO4B1t
3Sh+1lla5eMY4hlVHW1/FKqMe4EMXmDH7goTEuXPpelJiNRdBh7ud7xNNFUCAwEAAaOCAsowggLG
MAsGA1UdDwQEAwIHgDApBgNVHSUEIjAgBggrBgEFBQcDAgYIKwYBBQUHAwQGCisGAQQBgjcKAwQw
HQYDVR0OBBYEFO0y/xWMpkyOUMuNKmuzNtjXpdtRMEQGA1UdEQQ9MDugJgYKKwYBBAGCNxQCA6AY
DBZtYm9vbmVAY29ycC5ha2FtYWkuY29tgRFtYm9vbmVAYWthbWFpLmNvbTAfBgNVHSMEGDAWgBS2
N+ieDVUAjPmykf1ahsljEXmtXDCBgAYDVR0fBHkwdzB1oHOgcYYxaHR0cDovL2FrYW1haWNybC5h
a2FtYWkuY29tL0FrYW1haUNsaWVudENBKDEpLmNybIY8aHR0cDovL2FrYW1haWNybC5kZncwMS5j
b3JwLmFrYW1haS5jb20vQWthbWFpQ2xpZW50Q0EoMSkuY3JsMIHIBggrBgEFBQcBAQSBuzCBuDA9
BggrBgEFBQcwAoYxaHR0cDovL2FrYW1haWNybC5ha2FtYWkuY29tL0FrYW1haUNsaWVudENBKDEp
LmNydDBIBggrBgEFBQcwAoY8aHR0cDovL2FrYW1haWNybC5kZncwMS5jb3JwLmFrYW1haS5jb20v
QWthbWFpQ2xpZW50Q0EoMSkuY3J0MC0GCCsGAQUFBzABhiFodHRwOi8vYWthbWFpb2NzcC5ha2Ft
YWkuY29tL29jc3AwOwYJKwYBBAGCNxUHBC4wLAYkKwYBBAGCNxUIgs7lOoe41C2BhYsHouMhhtIP
gUmFpcMQmtV/AgFkAgFTMDUGCSsGAQQBgjcVCgQoMCYwCgYIKwYBBQUHAwIwCgYIKwYBBQUHAwQw
DAYKKwYBBAGCNwoDBDBEBgkqhkiG9w0BCQ8ENzA1MA4GCCqGSIb3DQMCAgIAgDAOBggqhkiG9w0D
BAICAIAwBwYFKw4DAgcwCgYIKoZIhvcNAwcwCgYIKoZIzj0EAwIDRwAwRAIgD5UL4MI1RXeg64RR
kifZAeItCnkZ4ecrqSEGpLcXV+ICIAdB9vZdM1WGxtag0rlqG0j0FBrCWixC0cdHNpFrqNx/MYIB
6TCCAeUCAQEwUzA8MSEwHwYDVQQKExhBa2FtYWkgVGVjaG5vbG9naWVzIEluYy4xFzAVBgNVBAMT
DkFrYW1haUNsaWVudENBAhMXAAs4l8tG1sbNlzV3AAEACziXMA0GCWCGSAFlAwQCAQUAoGkwGAYJ
KoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMjYwMzExMDk0MjQ1WjAvBgkq
hkiG9w0BCQQxIgQgeusbe69mlHKMlSfoSznhTfD1D86TwpMfQXcu0mKPpvEwDQYJKoZIhvcNAQEL
BQAEggEAO2bM25GtW+C2+9G4Z0J8hauauikb6xSc7RzALuVXuJpT5uZc6L1bGDgC96gydWsjz500
4ZaQDKXM4HksiJ+HCHNzrEJzWtWWqeXY2UxSO7ppOWpgy09z8crDvyFITUdUo9iOo26VtroA7Oy1
e4mjPiEy4Z5+4lSGdLxBsgSA3skNoYS/UskxjtvmJamw6hrcO7X+LqAFcCEgoAXC1laA7IRO/qiV
MYP7tEChXlvLJv8VknT072IfuQAmapewddmPuJBxiG0ZWlxOWBFcRi8UOFzQUO9JOx/Idi3n1h65
yMRCFEhJoJamdkVOcOdtMnosDWH5Bkpr1oQWgizcqRHs8gAAAAAAAA==

--Apple-Mail=_C4E92512-2433-4D58-BCE5-E5CCE563A1B4--

