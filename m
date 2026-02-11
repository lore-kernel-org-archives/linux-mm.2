Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B71AFECD6EA
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 20:29:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D251D6B0005; Wed, 11 Feb 2026 15:29:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA8B66B0088; Wed, 11 Feb 2026 15:29:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B21FD6B0089; Wed, 11 Feb 2026 15:29:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9E1606B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 15:29:18 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 07E5813B1C7
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 20:29:18 +0000 (UTC)
X-FDA: 84433315596.21.CBE61FC
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf08.hostedemail.com (Postfix) with ESMTP id 870A7160002
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 20:29:14 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=KVSG8Rlw;
	spf=pass (imf08.hostedemail.com: domain of Slava.Dubeyko@ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=Slava.Dubeyko@ibm.com;
	dmarc=pass (policy=reject) header.from=ibm.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770841754;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gQjFfFTA04P3KBaeK7u3UMjQvBwt1othUGLU01JJWD4=;
	b=UraGJ8rd8pXl66UzJQo+9H0MgWlCUAcicVohBYs8L1i6o96OKEmngvs1A9wtncjrsoPufw
	jVicBQ7m6xlcF3n3+lOT4LTA0azGKvWp1Y9ixrsTx+96FHZeOZAVOXlr70rJmJTKXxDZKu
	G84gBGR2gAooMoeu17f2TqM6Fir/51Q=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=KVSG8Rlw;
	spf=pass (imf08.hostedemail.com: domain of Slava.Dubeyko@ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=Slava.Dubeyko@ibm.com;
	dmarc=pass (policy=reject) header.from=ibm.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770841754; a=rsa-sha256;
	cv=fail;
	b=s1dXBrYa9TqCxUtXua325ptJipN2KVxZXKKyWsGSgtJl7WUeTaqeVbQF4J9FKEgfkueuT/
	vDMpwSVIjxeh9mYSzk+qe4GR+TSUrOMakAIl4r/uaF9n49i+fkBrMfAnW2LgrFkhedilaq
	i7L1d0nTCNEonLxMDOxBxP9wDbrXMDw=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61BGsGfv2890525;
	Wed, 11 Feb 2026 20:29:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=gQjFfFTA04P3KBaeK7u3UMjQvBwt1othUGLU01JJWD4=; b=KVSG8Rlw
	6by7cDqQHFNctoyNN1GxRSzzjovHRXa3pgvdz1Ynechcga5E55k48EiK5ZHyrP5K
	DiQ2vVTiiBgVOupo8xGZZERnU/ZS34FjC7oOOQLxoPsRpTWFgCXDKKWK3YApUDLJ
	RkgMUGzpcgt90Y+A4mr2ejYW5AX8pDhuXbps9xP7mT4SOa7+3/OLCtX8TO5YSEG5
	m4dqSmDT9Rk7WH06XZDNO2dFNqhD04ObnXTzrSyYt/EWezDjX/jSEvFgMk0DQ81E
	t7cyNZUczKprSpM0BCq2LzoB5f8SMReEKpkMtZdR8R1a7jE9PLSEKXzcSog4cyeg
	6KtQeJL0EjmZtQ==
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010050.outbound.protection.outlook.com [52.101.46.50])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c696x0j38-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 11 Feb 2026 20:29:10 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lZkIC0XfMbrFS0GyqzR/FFFufESdFijYSAWF0nb2crDIfHhrGJvdfJz1V/iWPGwLhYB7A/A2jEMf6LDHCfm6ijuFWdqF+WLdgMsStEQmWju+Hi2jdaBPzpgcd+w2yijpn+6Hx4sO0ra+p+1vbrncjiYPD3L+fvVvL7vlajw0y5Ia79F41ivMiPo+7hRhokjOPkLRZMgB5cWOIT2l8D9GdKo6CcjlnfAHEaKAXEqiaaWugzAdfTbVdgr+xh5wWS33htoMMGDFYf8kI9JroorYDZJptZMeTDXgXMxFG024y1D0OWtnyLe003XcKyby0AdoiyMI4bK63GyCbgqyycPSZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gQjFfFTA04P3KBaeK7u3UMjQvBwt1othUGLU01JJWD4=;
 b=DqgvMMF604UKu5F33lka+XVx3a6BjktC0+hU/rbGUecuayodkeUfhpw3xcDAw3wscBf+89KOzbDazvZZTGZkMJr1Q150JQzc8Pt9LHREsq9w6xWdujJNO0cDL0AUw1ZyMeJGGNJSDk1z9iHi83OAY7QQLqoKq6+b0j0WF73YoEBJ0ee6ghSNh3UCPiRuJO/P2S1ig9F0oN7G76/oHf4rvKogb9w1ZpW+6tPbSvPpG07jp0hVrrG6tBHvYTM0rWo6fhTdm4FlFsEWEFniPjICgoj2Rq2pXfNjDBIEFWO0I9svZLKa46qF7o8mQfrEkhCL9lWOn3zAXOz5YC5jCSCuBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by PH7PR15MB5476.namprd15.prod.outlook.com (2603:10b6:510:1f4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.10; Wed, 11 Feb
 2026 20:29:06 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539%7]) with mapi id 15.20.9587.017; Wed, 11 Feb 2026
 20:29:06 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "sj@kernel.org" <sj@kernel.org>
CC: "jack@suse.cz" <jack@suse.cz>,
        "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>,
        "chrisl@kernel.org" <chrisl@kernel.org>,
        "bpf@vger.kernel.org"
	<bpf@vger.kernel.org>,
        Pavan Rallabhandi <Pavan.Rallabhandi@ibm.com>,
        "clm@meta.com" <clm@meta.com>
Thread-Topic: [EXTERNAL] RE: [Lsf-pc] [LSF/MM/BPF TOPIC] Machine Learning (ML)
 library in Linux kernel
Thread-Index: AQHcmpPXPV+chNeGskiA4zJOQ4d3LbV7+8WAgACKfgCAADCiAIABPhWA
Date: Wed, 11 Feb 2026 20:29:06 +0000
Message-ID: <a8a3b50620945dfa3ded3d6cd91c5ef9fadfd55e.camel@ibm.com>
References: <20260211013039.68143-1-sj@kernel.org>
In-Reply-To: <20260211013039.68143-1-sj@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|PH7PR15MB5476:EE_
x-ms-office365-filtering-correlation-id: c97e469d-1605-4c11-a368-08de69ac341e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|366016|10070799003|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?T3lNT3BpTTdaVm9iN3hnTjJ6SlRmZm93RXRYeWVJOFJqUjBZR1dDTkduTGVL?=
 =?utf-8?B?bVBMZXh6ci9PdU9RT1kzbWdBeVY1cHZLNFNVZ2M1SFlMc09rbnZINFV5T2Ru?=
 =?utf-8?B?MXU2YmRISTlRMVpLcWFyaE95ZUFTTTdJTmdRZDFsb1hOczI1RGRCV01zZGVN?=
 =?utf-8?B?YTljMFpuQmMzVURRdGZ4Q21pNW5FejRVTTlFOXpxd2ZXZmNoc1NqejNmRDQ4?=
 =?utf-8?B?MEFRanFtYUFQZGJpbURlN3JvMEp3WDRaYXB6aG9ra0lhWktnazkxN24rTUpk?=
 =?utf-8?B?NnhLdUVVUVlNVEtrRlNzKzFVTXdWbEhkUjJTYm5LcmUxcDBIdUpQVi8zNWFk?=
 =?utf-8?B?YmJBVTZtWU53d0d5T2lIQjkxdFhHNUpHLzllTklaWDJxaDJ0MjVuYzhnSlJL?=
 =?utf-8?B?aElLRU5jQ1ZSQUxqMmlPRlpPYVU0cngzSXRmN2I5dnNoTmFCNXpLVVY2cysv?=
 =?utf-8?B?MmtjTE5oZTVzR0l3eU8wb1RWMlFEVmw5MTU0YkFIOXZMNk84VDYzcTFaL3ZO?=
 =?utf-8?B?bUhRSjQ2Y2pTNjFGTnYrTU1OdUZLWkFHWHBuT0dydUJSMTd0aVhHR1BxUTZj?=
 =?utf-8?B?dkxDdVhIeThYcTk0SDVPMDhvY2tpTXN5SnViVFMyZTYwSmdxb2swVDRENXRT?=
 =?utf-8?B?d1F5L3I0QjYyVTgvajI4aDdSMEtXS2hvU0RLQk1PTTNGdW9STUQ3MWVLS0hT?=
 =?utf-8?B?TVlzVFdOYStIVzN1b1JheWRQb0RHMFdWZ3BveFV5TGgzc2FZU2NtbnZtZzFP?=
 =?utf-8?B?ZnJRQ3BWZm92RVVNNDlRTUZITnFCS0lhNUVlWEpIV1JLOWJUdUZoL2dUUGx0?=
 =?utf-8?B?RUpPcjNqUVMzZXRjaHNnOXpQZGE2VFNGVjFhZXFWUFRyQWN6UUl1ODF2NHdY?=
 =?utf-8?B?RHpkSFNaMUFIRFdDR3pwWGwrY3ovUWtkUW81dHZZVjRBc3U3bWEvN20zU1Zi?=
 =?utf-8?B?Y3k4aTY3OTd0YkRNWlVzRE5IamRoeld0aWt5ZzRwNk9xWm1FOENDTkt2Wmp5?=
 =?utf-8?B?bUtrY3Y2V0ZHMFMzYkdGaW5Qdyt5NFZXNGpmeDZFUXAvcDQ5KzZ5R2RqZWw5?=
 =?utf-8?B?NjRCdENaQUhGWFhxOXB3Z2krak5Zekw2dmtKTWdiMExTc0VVV0dRUi9vSTM5?=
 =?utf-8?B?VElkdXpwT3Q2VnBtU2lvZW5GOTBOeEEwLzNvcTh5cFR5cUlJT3hVdU1TMkM2?=
 =?utf-8?B?MWhJZEhVWmNhVTY1YWVFUE9PWTZyTUJqQzZlQ0FJR08vMmxMQTJDOCtXY0c4?=
 =?utf-8?B?THU1ZTRLOGtBcHdCRE5Rd3dWK3RxbUZoTlFuM1JCZVdVMXl3TDZWMy9JU21T?=
 =?utf-8?B?aGxyNHZvNllQMjVTaWgvYzA1QlJ2N0t3MTlzemlIaVIyWUQrTHMrbE5kQml0?=
 =?utf-8?B?WmludG16ZmQ5UlpyYnhXaDM2Ylk4bmxJcEZEK21LV3VlOFBDS0hEbWxLeTVK?=
 =?utf-8?B?eXluRSs2VTBWRjdBaVJQbFZyVnUyVDI1dXNQZjFSbldGcVkxOHM2eGJ2azRL?=
 =?utf-8?B?K2Y2TENKRXVXSTUrcEt5NVZsOW5Ha2hHMStVUmpOOHJ1dVBpSWQzOWlDYjUr?=
 =?utf-8?B?YUkvbVY4OHd6QTBuWkIwOU8waVVUYUFEL0JRNW9SQTB3Tjg5TDZxZzBTK0N2?=
 =?utf-8?B?eHhBdlFIK3FaTUtDM3B0dWpIUitzL3E0dk8zaVVka3RTTzBvalpkRTcwc0RL?=
 =?utf-8?B?UktIdjlTRnlQWm5rSDNOMmYvVUZLdGFEdWVIUjB0MzduRVVCdVZGK2lDdUdX?=
 =?utf-8?B?N2Nac2o0M2ZMUU9qSkMrSXJ0V3Y3SkZpQnpmNUdlK0dTbkVsZUQwb2E3UUIy?=
 =?utf-8?B?dXlSdkpmM2srQ2d4ZU8vYW4wUkRibU9KdytZb2tzUGxCSldBc0dRcHQ0UC9j?=
 =?utf-8?B?Qm14aUFDeVBQT1JvbFJZV3lzYzA3cEx6UWFIRzZiRm1idzZVSVF5RjlWNkNM?=
 =?utf-8?B?WGtveGxTckw1MUUyWFpLVUFFVTUxcXduK0JpUG1QWElhTXNoZktRc0kzQmw5?=
 =?utf-8?B?Ykk3UmhSbzhnM2cxaGFlZytEdTF6SjJEUkRGVzJUTHVPdVBZK04rU1I5eith?=
 =?utf-8?B?bUdjcDZodTFvRlVVQk9mbTFQSFBlK2hPam44aUNORkh4UXdtbUVUcWhRZjJo?=
 =?utf-8?B?L3o5Y1ovT3ljYmhHWWpmVjJFbGMwNUt1ZlAzc3U5S0RkdjFxS21xVDlsTVdD?=
 =?utf-8?Q?qUUlS1RbIpjF+k+ZvYFbrio=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(10070799003)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?UWlxS3MwSXZrWkdPUktPSDZ1MnJmS3RLY04vMTFEdWVlc09SOWl0UHVoVmkx?=
 =?utf-8?B?WWNaNk83TVZmTFBLR0pDeUFEdVU3ZjJrQzhsWFhoc2hoQjN3K3E3TWFDSldI?=
 =?utf-8?B?NEJoREhFUm9ZRkFOVlJHRHpYZlJLcEdoVGdYUjIxdjY1UjBySzRzd2dUK0N4?=
 =?utf-8?B?Z1RGQ0I5encwME9yQXd2ei95U1czUS9CK1ZrTEMxeWtybm8vVUZQSXJyaDN4?=
 =?utf-8?B?RHYrbzVrbTZDM1RQNi9JNjVXUUxwa2J1QzJlbk5GR0R2NWxLRVJXak41ekp1?=
 =?utf-8?B?ZDVIOUx3VFNBRmxIZm41RlBjdVNCdU1DclByOVk0NjZRemR1b0pRYVZZQWx2?=
 =?utf-8?B?ZVVGZnBpMzVtcTYzMmFndGRvVXVyVE5CSlFEZ0VUOEtaL0V3Q2h0V2hoN1Rz?=
 =?utf-8?B?MmZWeEExZDdOaUREVVBwbENTck9pWlpTZGJaYzRZc2lzR3NYczdxcUgrWXZC?=
 =?utf-8?B?NTNDNDFIT1Y1MnMzSFpxWTk4K1B1KzJ1eklDUzE0Y2RwdFIyWUJyZFIvREdW?=
 =?utf-8?B?di9LTmhXR0tpNTlLcUs5cUpYaDJOVmR6WU8rSm1GUEtycSs0OVB5TzlaYjE4?=
 =?utf-8?B?OXIxVlczUkFNSkxaR0lSYVY1STQ0ekIrTVo3NkovQm9zTjJqdTdCYVdHNXdJ?=
 =?utf-8?B?Q1NNSFZQZ3gxMS9TcGE1TW9BQm1adHc0bEM2OTdyckJuclcxOW0zSk85R2hE?=
 =?utf-8?B?QkQ1amFBS2tGZTlqZnJjSHQ2Wm5ZU3lUUlUwZnlhNU5wSUo1M09mdFlQRGFE?=
 =?utf-8?B?VTRYdDhEaEtaRSt5NHI1Rmp2Q3FycTU2Q1pwem4xS1dzWEx2OHJVYlQ2c2x3?=
 =?utf-8?B?WEx0RHhzOUFmYmUzbWl4SmUrUnp0cDIvVm14NWIvR016MGVoUHBNUkMrVmxL?=
 =?utf-8?B?MzVSMmMwOFhmUVNsMGVjaHhzNVBydWorUWN0V2wyTGZzdHhkREZNcVAvcDFw?=
 =?utf-8?B?L0FQS0RJV1MzRUZ3OTNpNWp0M3htWFp4cElGejVJWlhnT2F4NkZtSU4zb2po?=
 =?utf-8?B?VlRvVTg3aEhRdzBQb3QxbTJRM3ZIdEF5bU5EK254QUR1YmppNDFOaVFMOGYz?=
 =?utf-8?B?TG1ScW5jSUducStsekJNeVlqZEtxbFlRZlk3VFdmdzJnU3lVOEVsWEhyeXBU?=
 =?utf-8?B?Rk1JTGlnNEdVWU9iaEptUmJKWjd2M0lNY0tvUk9BYkRFUXczenc3OFJ2RUxS?=
 =?utf-8?B?MWZoMjIwb0ZyZDRHVTR6Vm03UVlGS1dEYkhUMFYzY0o0eml4MWFkekdlb3Rq?=
 =?utf-8?B?ZkRHMFdFcS9obnNCVm43LzdtQnkzdGwwMmRnOU9ZU01PaWd2d3BXMFk3aXlr?=
 =?utf-8?B?QTJNVjJXYXB6NE90ZEVKaUlLU0hYZzg5cWFPbGFGZWdWSkNPWTNyRFZWeDNo?=
 =?utf-8?B?dDUrS3RGVGhrYWVsU01xTmxHanVJUTh2dm9rL2xzL0ZjZHZoejVLTjZkSzd4?=
 =?utf-8?B?U1l2RUNCWkZVcy9UbEVBU1UxdHhHSlIvU3VFaDgwbDBLWE80T3JBRWt4d1lW?=
 =?utf-8?B?UjkzWnFVNTdsT1NPSysrc0MzOEJ6SytHV2NHRHZGUlloLzQzdmdINWo5Q2Y5?=
 =?utf-8?B?a3FSVWRrZkxITERBMnRjVk0rRXg1V0t3YUdyaDNBNUpZZVl0WFJJNnQwNmJB?=
 =?utf-8?B?OWdEeVA2bHh5UzYrODdEYWJwQmZsL1JON0lac0ozcnJQMlc5Z2VBR2FVeS8x?=
 =?utf-8?B?TmZDRlhOWW9LenYrRTRqVFFLTXJoWjY1cEg4YUMzOE9LYTF5ZXlxMno0QkhT?=
 =?utf-8?B?bndVT3ByMkZ2VmluMHA2ZTNLSGwxVHdhMUwzbm9TakZ2VHNWc0dRTndJQUlC?=
 =?utf-8?B?RmpQVXloYjg3bGExR2c1TTZSQ0xvVzFhQTlJZnpnTlc2VDVVeVNIc2hEL2lx?=
 =?utf-8?B?SVEzU3BLcFIxYWxIU2NYSWlOcTEzSDFkN2dOWXFoL3hwZFZLL3ZhaFRyci9s?=
 =?utf-8?B?OWhFanlPeWxteURiSSs2WW1jVW15Qjh0RGcxV2hIcHRBUkpVM05GK2xORXpV?=
 =?utf-8?B?bUFKSi9jQnM2N0dNQU5zWUF0Zm5ZU0ErSTBObzErRC9WU2hLWU15dkQ0WEhM?=
 =?utf-8?B?bHlPdlFJUm1SV2ZTSjZGZjU5anp3QnQxU0NGTWl1dTV1UFlBR042QzdQNGx0?=
 =?utf-8?B?NEpwWktRTjFHNm9lYWViYWovQ3lIWm5OT0c5TUd6alZHQnV4NFMwK1Z5N0JS?=
 =?utf-8?B?SlozSm4rU24yZmVRYWplbllBRUFiVDBIb1pVbFpyZlZSSkh5c0M1K3R1UGFV?=
 =?utf-8?B?eWVhQ2wzQldPeTFTakluNm5nT3RnNW1rU0pqZG5jZVZ6dmMrNnJ5cWZPSENi?=
 =?utf-8?B?aG1udVhtVW1xOXdxTkVId0paMFZuc0dnU1c0OEpzU0NUeHV2Wk91TzZSMy9S?=
 =?utf-8?Q?f+QY5sWpfErTFaS7GDhWJYu20g1fXzNAcnepF?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <07993F6672033C43BCB29493C2FFB436@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: ibm.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5819.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c97e469d-1605-4c11-a368-08de69ac341e
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Feb 2026 20:29:06.2154
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ChBtsQj9Qoqp2mgEhDKpSi6ivB0jQWEn0QtHYvCmiyCo+4kTuUbl1o3YGK8qBNydJVeXtKAPR2L5oHLP0yEcFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR15MB5476
X-Authority-Analysis: v=2.4 cv=WZYBqkhX c=1 sm=1 tr=0 ts=698ce696 cx=c_pps
 a=MMVmnpyRbxvAcRc6a9dgEg==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=VnNF1IyMAAAA:8 a=xACqMCxL0gE2XpbJGaIA:9
 a=QEXdDO2ut3YA:10 a=0lgtpPvCYYIA:10
X-Proofpoint-GUID: ChX0-z9AB94aNATWjSTns6ZHmk0KmXA-
X-Proofpoint-ORIG-GUID: ChX0-z9AB94aNATWjSTns6ZHmk0KmXA-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjExMDE1NiBTYWx0ZWRfX0AikS8KE4Yee
 JG2Toc6Vv0jP7yUhwH+5nWcRq8e7DZQwd7sp3uP7p3L7qRWj1J+NIRwJkENLs3qvMgbP0/folKs
 2YZzud2vOFsN9YvnXif/f8lXwU+on1Tf+3fWC7Ed0B2bl40TTxShGmN7fi9P2wPnoF1z/qn9sAL
 qKx80eydvK7q7opYu+BwRavsjtaIA1zeNcv6xDqElYzZemKazAxnnIcQ878ZqDAdq+zAEaDEfB0
 rKji7NO1qrcwjnLwGqNVdpia7l8wgmQZ0krlIlICItJjLih6MQiuRBZlRFd7Ysy+J8kkYK1wpn+
 KS7R7yw0qHB29Jj/RxEua5ywbPOr+K+AOWEjtzpxUbZWP0Nd/CkPlLgaFIK7x3V8M8jUECwHpML
 /9u5talPkTClK4TsK1UVKZX/q49NDP8b0HxRK4iKWHNr86F/UqY/LitkG40vWP8J2e2wzDDkLVG
 zmOXtL6g/DmRf+w45/w==
Subject: RE: [Lsf-pc] [LSF/MM/BPF TOPIC] Machine Learning (ML) library in
 Linux kernel
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-11_02,2026-02-11_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1011 phishscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 lowpriorityscore=0 suspectscore=0 impostorscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602110156
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 870A7160002
X-Stat-Signature: pku7c8r856d79htb4acqayu9gmz1qmub
X-Rspam-User: 
X-HE-Tag: 1770841754-154606
X-HE-Meta: U2FsdGVkX192KixtwVXeSCySeTSmiwBMkVf2LL/1MJce0U+Kh+j/eLsfGQgxP8k10Pvb/riZzvh6ugUA9ryRkpDZHph2qBkq9aVqRdQ4Gzbnbleo+i5CCGjsfeGqCuYRKt30NWPW1CK77z4y2+3JPrTESncv/G9MS209mzXC8IF2XbnkOVEhdpSpSRmYym7xbp2RbvyzxHx+GtAyCRwXEwbqKm3vlsgp1V02z236MykOEHWON3wxe9DTStjHUVYrAHb/hFQdrggUng1X0k0NSobB5Kuyy25wtCozZdfGzuIGkox3RomY1L14G0aHIPpCGPimNYOEg6qK6JWNvfiwCi5NWXvQoXMwqgPJiYwmfZ2ucNKPqUeEpPGQ4a/mz5aTuy0HTWVppk4CcYRZ7szqsB3mFAr+u1iI58jIuFX5lKqkPzdvqdbhLsn9f8WWPj/RbI8/sPI19x7b7zV4sTT07mhejl7dATLxpdBnmcFnKsRDj90QMaZ8F2Ii0oxhlELqfCTNdHKovPSy6wfiJAK+J3CXllvVBUbKhkqEHw7MHpc/w2qbHQj/Ir+SDsR+xeGQWSkbx9/g6G16vLhDBsT1JBkU9Cb6RzXU4o2heClgyOHlBaqxFvG+aLmhZHG6LOLfUSVKi2QUSIh5aK4eCkzUkSaHdGx6VRlVpbpyEbA6St2svaPvNgd/ALIpeB7Iwg1ilEQBeg5r8x4WxSFprcNMNvDE5bY0KYyo9aNkur7+Vs2nqm+Dfsr40mDYPrxdWiCj5qi6L91tdq1XHdcZlqIUWGg23rcqh8EXlNFsgM+Od9szitFxZS8zb8j4AIOwr9sDQjSAaBuj5AiEfLfcE8qH1J+gzCmnIjDKIJCfTTKufugWZVI9m5otnGge2KBl5kWyveEwCGMC25fp9qkF+3jU/6FcyXl2Wl5axIhaau/6MXsF0MH5PoXrK0fD7XrGSrQqAcdQQK8v4evUfZ327dq
 K7n8Zh3e
 lY0wJcsGlO/jLiHMGVEe3oNfL+5lwUtZyqQz0FplPeeBJtvf2TNvb586SZHhTFyA+AxTBb5Uo4/9gFNBcCwSCfF9tGp8aC/CKMkCnKKJqPpNRBJ+Z5GvbBVzZts8dFu2lir9qM6ltbOfzEWbIFQptm7LwymXzWlWT+nc/KpUcYziCSpRKjHdGzsWrEJTQpADZm9HFQfXM6F9gJMRJxC/EyTZxIhjybSHJpeyHAKH5jI6YCluyL/SsCPf7BjKNjvLzxv4gAG1VHjWguut+UQkPM3V/5cRqjkQCw+fwj+z/IxSkhKgYu1xtsZdkwreyD8CMBaP01hT/iGFfBv2sT6k8sRFFfhZPLpzr/x1JTq1Ajdap1pSQhfn/qYWEZ540DsJX3/DGe8jFny1mIGQC01pzEqdIl9a11qIuUvd6GT1xPmIQxP5wSRuz9Rb1Jpl9No9HQ3yaFdvIOGjBt0cETZRQ2WGn0FZl0EzccqPbQr6K4idTDKGTMyObvtHUAdzG0iJytLDRYLuMAkB1wZhZ9YQclMcTSdhdQOe+1qPBh+ck9siMqLTwx1sgl0OqSuRyErijrfZNXosHklS1NRL7H+b7oFS1sg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

T24gVHVlLCAyMDI2LTAyLTEwIGF0IDE3OjMwIC0wODAwLCBTZW9uZ0phZSBQYXJrIHdyb3RlOg0K
PiBPbiBUdWUsIDEwIEZlYiAyMDI2IDIyOjM2OjM1ICswMDAwIFZpYWNoZXNsYXYgRHViZXlrbyA8
U2xhdmEuRHViZXlrb0BpYm0uY29tPiB3cm90ZToNCj4gDQo+ID4gRXhhY3RseSwgTUwtYmFzZWQg
REFNT04gYXBwcm9hY2ggYnkgdXNpbmcgTUwgbGlicmFyeSBpcyBteSBuZXh0DQo+ID4gaW1wbGVt
ZW50YXRpb24vZXhwbG9yaW5nIHN0ZXAuDQo+IA0KPiBHbGFkIHRvIGhlYXIgdGhpcy4gIElmIHlv
dSBmaW5kIGFueSBxdWVzdGlvbiBvciBuZWVkIGhlbHAgZm9yIERBTU9OIHdoaWxlIGRvaW5nDQo+
IHRoaXMsIHBsZWFzZSBmZWVsIGZyZWUgdG8gcmVhY2ggb3V0LiAgSSB3aWxsIGJlIG1vcmUgdGhh
biBoYXBweSB0byBoZWxwIDopDQo+IA0KPiANCg0KU291bmRzIGdvb2QhIExldCBtZSBzdGFydCBt
eSBpbXBsZW1lbnRhdGlvbiBlZmZvcnRzIGFuZCBJJ2xsIHNoYXJlIG15IHF1ZXN0aW9ucy4NCjop
DQoNClRoYW5rcywNClNsYXZhLg0K

