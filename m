Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE7AEE94614
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 22:07:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E28436B0093; Mon,  9 Feb 2026 17:07:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E007E6B0095; Mon,  9 Feb 2026 17:07:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C84636B0096; Mon,  9 Feb 2026 17:07:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B2A7E6B0093
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 17:07:48 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 66EF0B7F2A
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 22:07:48 +0000 (UTC)
X-FDA: 84426306216.08.CC7327E
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf15.hostedemail.com (Postfix) with ESMTP id B494FA0002
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 22:07:44 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=O5MXzddt;
	dmarc=pass (policy=reject) header.from=ibm.com;
	spf=pass (imf15.hostedemail.com: domain of Slava.Dubeyko@ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=Slava.Dubeyko@ibm.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770674865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l6VZblG1hWIHHOOwvL8rd3As2ETqOyGW9+A4pt6touw=;
	b=0P381J/NIvvki9wYdaYaVMr/z15rHMbNo3uQ8mZcEW60PWDlHbKadQXO8XxJZcPqbhnibM
	qDVCgGmhIm2HGRkng0Eh6vJ1I0mDMBaxhkyB/91+XO9YiZ3WQU+CV5jgZx6hGGUCeC5UxB
	3/X8a6o9c7yl7xadpJSewuBS8MrpQPE=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770674865; a=rsa-sha256;
	cv=fail;
	b=EcoiDez2/gnOXYhGIRvknMMVd5R7EjkXkGSpgAPNk6OQCKjRWuLaru8yKXdXzfb6/7v+Or
	aN3NX9LyWcf2hKXW+m7ZwcSywDIHA5lJjtuSd0TNjCJIIU+X/cq7QbdHPHmQs8W8cbWWEQ
	8JzoruEjWUB5QwcBdsSNeg2dWguhvRk=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=O5MXzddt;
	dmarc=pass (policy=reject) header.from=ibm.com;
	spf=pass (imf15.hostedemail.com: domain of Slava.Dubeyko@ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=Slava.Dubeyko@ibm.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 619Fevl2343472;
	Mon, 9 Feb 2026 22:07:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=l6VZblG1hWIHHOOwvL8rd3As2ETqOyGW9+A4pt6touw=; b=O5MXzddt
	x13vK56XcH4zLhut6lueS4JEMEfunpH5/p6fqxgoJq+GUHG0x5F/WM5IIYQKVcRE
	bypx1+QQos0VOcMenR8htQJdo5L231EbbcmaJaaOl+YyOfyFXi9R7JRdqFMd42Lv
	uXLs+sWU1NXekIym6oSnOppU5qKsFuvwMtn4TL5J2df8qg6YvwYhoLKuhFhM+aSQ
	p4xMXlEjtgEkw/itGvN/dFrXuIgmurERF1GuJIk8KieIL/mvupJcPHitV0z6B0OV
	ObC4MO65Oph2mZXHW97NTfX+PC1qR0MGfho4ocuG3lkDCl7/VN8zqU7fMOTFzPFp
	wSGcQRlLWfcIdg==
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012044.outbound.protection.outlook.com [40.93.195.44])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c696u9e6r-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 09 Feb 2026 22:07:42 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xKVpeJh4t67+jEE9kCxc8ETcryJsENpGMEcgk20h8h+aUw0/ERB05SwYuFmZPWCsKl/VKhCHFyYXvqwlC3bjyR6Tgw5UeDA1nGO/7uljZUJU+rsImsbViUE5pCmD6qxw0f5q85Q/u5q9oFrdy8jvP/7qsERqL6WptlpzvBjVV2chHlWDF4PSevji9wi792USLVjNIEAmoO+ga23L5crs+gfLoE9mstt7XmVz+lVuqjZwTgcticqi6GI2nDEQHl97LjNWA0M/aTsbd2UVw7zHEJ7umRs9s8xoHSYgJsJRcFjAfwb91hOYjDNbtLeht31ju9NORovvBA1w9wnlp6G+Hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l6VZblG1hWIHHOOwvL8rd3As2ETqOyGW9+A4pt6touw=;
 b=wVY1NAxgEcIT/ACoBua2RzCz1p9G0UPKsaj0svtSvPadrhhZ9/khIOupG1np9tBjg6HspBm+ZmBFJOMirZVAjpQ/iSodmyrpqGWCst3B1IRcR2Fq2C/g3yt0Rl1fMccFMjPqZtbD/jityJUm7KVJ7LpSTpqEL2rTt8JRN4ieCzm4iTmgWywHswZtoJruDcV/xWNZwlSp+Lv2K0dgYRDJGAB/1p7Drvj9AW5tMEnNVaDvWtkj4eWT5x4I6lCRjuPxhMS43Y3Jhe4PcY5lmR4yuLlvNu0D5gimMe8r1CyzP53L8GQnoLqSV1eBZzEwNunlyr8Di047VEfD3GOEe8zahA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by CO1PR15MB5066.namprd15.prod.outlook.com (2603:10b6:303:ed::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.18; Mon, 9 Feb
 2026 22:07:40 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539%6]) with mapi id 15.20.9587.017; Mon, 9 Feb 2026
 22:07:39 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "21cnbao@gmail.com" <21cnbao@gmail.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Pavan Rallabhandi
	<Pavan.Rallabhandi@ibm.com>,
        "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>,
        "lsf-pc@lists.linux-foundation.org"
	<lsf-pc@lists.linux-foundation.org>,
        "bpf@vger.kernel.org"
	<bpf@vger.kernel.org>
Thread-Topic: [EXTERNAL] Re: [LSF/MM/BPF TOPIC] Machine Learning (ML) library
 in Linux kernel
Thread-Index: AQHcl6AqIZ7MB3V3T0Kp7gdR9aR7gLV6LZWAgADELIA=
Date: Mon, 9 Feb 2026 22:07:39 +0000
Message-ID: <83e395c84c9bfa52f1abccf12ff6d39547d6bede.camel@ibm.com>
References: <47d21a6821c4b2d085f7b97bcdaa205bfcb0e0ad.camel@ibm.com>
	 <CAGsJ_4wgG6-FvDbLw4De0r_vPO1fTH_69A2VyntabmS6H5ZM8Q@mail.gmail.com>
In-Reply-To:
 <CAGsJ_4wgG6-FvDbLw4De0r_vPO1fTH_69A2VyntabmS6H5ZM8Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|CO1PR15MB5066:EE_
x-ms-office365-filtering-correlation-id: c34b5732-bbd6-4026-6170-08de6827a41a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|10070799003|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?cXdUR2UvQWY1ck8xZVFjVE5KaGtSK1RYcXN6N1VlY3l1ZktIYlEwOHFsK0x5?=
 =?utf-8?B?SXphNkZMNm1Wei9kS292L3llWE44VzZ1aVoycUVtcEwxd2djdFFKUzcxM1FL?=
 =?utf-8?B?YzBjTWxjV0VMQXY0VExtNi9CNWxrc1hHYkpqUDIzaG1ydml3d0lZaTJ0cGda?=
 =?utf-8?B?MTRLZVNVVzhqZ3JXUk55NlpNYkpFTXgrL3BBamJ3c2tBR3pxSlk2dmN2NTNQ?=
 =?utf-8?B?MjhiUjhqeWIxeE1kNk9tSzdJTUdDRExvZ09yWk5DWGZMUHB2Unp5TlNSL3dL?=
 =?utf-8?B?Q0JZQ091azRhZGYxYVFhVzNRZFVrT0o1c2g3c2V1ZHFYMHllZDZYZUQ0MlEw?=
 =?utf-8?B?SE9MZmUrVXJjRDZaQ1ltQXJjM3E1WVVXSWZTTThidWs3RXVzQUl5V1ptNXlz?=
 =?utf-8?B?TTBuN2wxRmxqSitPNWxNc0RzSldyODB3QXNEMDJGbWVnTjdEMkZ0V3VPV2VB?=
 =?utf-8?B?OFR6S2FnclltdDI5WnFTbXR1TzZSRzZEZWNzcjFvbFZTNm11empMOVFFUWti?=
 =?utf-8?B?NSs2cEZnckI2VDN3aWtwRzFtTXIvZWhMN3dieG1vbVlSY3ZvRFZ1L3dQWE5m?=
 =?utf-8?B?dTdSYzBaU1JUN2RaNG9Uc20rTkl6Q0NxZGMzUW9raHdnTmdLWE4xSnRPV1o3?=
 =?utf-8?B?N1pHSkdGUW1sbEEzYUwxYkdSeGYyaDEzRzlwYnhxVmZIYktRZ0h3ckU1WkNP?=
 =?utf-8?B?cWlhcUxXeHptb21XK242L1g0ek9LOEhNbnRJZ3dXVTZYWWszT3J3Q3E5bGl0?=
 =?utf-8?B?ZnVxNGRxNXd0SGFOTFUwNnlSZXpIZ3E0c2tXclltR3M4cGUzRlVtQ2VQTmIw?=
 =?utf-8?B?R1hzblFPMXl4LytOVWRIZTI5dkRkUE9WbU5IUG52UUVaYXg4ei9RVGUxNjdw?=
 =?utf-8?B?RnI5MnhtbkFYTmlabitmUG42Mi8zcjlsN3ZlZS9YUjl4dENiejBKZ0tuUmRP?=
 =?utf-8?B?QkpzTjNsRHcxOFkxbWN5eVRZUG5Ga25vZVhsOUJ4Q0gvL2JxK1pGcldVODlR?=
 =?utf-8?B?TElHZXlrZHNHMzdpNFB1TENxZG4yYVBkbnFGUFZ1M0JmZmpwQUpsZ3F2SVJB?=
 =?utf-8?B?VUMrZ1pYMUtjNU9NeUhDay9oRGFUTnR1VlNpTmxqRTQ4MGthSjFTWVZtdVRP?=
 =?utf-8?B?SlJHbFZyRVpyODZqS3YvNkJvUmd1bktxUGliWEM1WU85KzJrc2pGNjBtZC9x?=
 =?utf-8?B?c0pmTkc0eTUrVmFhV1NNQUZTWjRHSTZlVk9RdXMrN0pKRFQ0QVlydklQSnhw?=
 =?utf-8?B?b0RLWGhNNWI3UjRXNmdJTXRYOHZPZ3gzNWNFSlJGYU5UMG02RWxzQURHVlp5?=
 =?utf-8?B?aXUyUXRScllJRmx4NjNTbkFaenhJYldBa3JreVZFUitxRnQrSWVDdnozOHd1?=
 =?utf-8?B?b015ZWVrQmkxK3hHZnVsRHlYVlNoZ2lLWFUzd09Zci9VbXBFSC8ybWI4K2cr?=
 =?utf-8?B?WnNhc09pSTZ1MERYbHloWFRuN3NpZlp0Mk1OK2w3UkxiVDFQNnR1OHVwazYv?=
 =?utf-8?B?Wkxxc2IxWWs5T0dkMzhMZGJDdFZIcUZ4MEdFMEN2KzhiWGZBbGVEbHdKajMw?=
 =?utf-8?B?R3JTYi9tZTRtSG00TFJHT0pvOXBZNjdJd3l5a21RSHB5NGR5UElLdlNBWXJy?=
 =?utf-8?B?MHVtRWxITzRXTHBSWUoxeTc0K0xlRThoWDQ3ejMzOHV6Ryt3a28zaWhhdkRY?=
 =?utf-8?B?V2x1L2ZWM015UUY5QnRsb21TMWFXRTVybUhMTXdpa3RJRlI2UzQ3Yml4ZFBI?=
 =?utf-8?B?R0FMdDhWMDRDQWd1ZzlxdUhTTnEvcUd5RXBwTnYvL2liZ2w4SGtkTXNNbVdC?=
 =?utf-8?B?WllLRnJ3K1NVNFVvYUNmUWhNRzBGMlh0TjlLaktOYS80RlV2VnNmcXdXWE16?=
 =?utf-8?B?Sml3NHk1OGFNQnJFV1VuUkJ2SUVhbWlvd2R0MnhoVHJIRjdWbThML1JDR050?=
 =?utf-8?B?TGRPSmIvRy9MMDQ3NERVeGNGZ0xLM3pwSStrMzZoZ3NPSVhGRVhUUU5acmV3?=
 =?utf-8?B?ZmdTQ01PcXpGTVROaGtiSTN2ZUY2WC9YanBNbEU2VFJJVUJIeW5pbUJJS3BS?=
 =?utf-8?B?Kzh1YkpkMGJTWUJnSTVkV0ttdUV3Zy9jRksrNTh0VFRDZmFGSEFxRUtBRGsy?=
 =?utf-8?Q?z1xE0yZmdI3UnqZfORqhtZ7JW?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Z0hxRjBBeTd4UmpzY2F0bEtyMlZzRHIzZVJyam9sSGN3S29tbzR3Q05mbmZj?=
 =?utf-8?B?dEhwZkJNMnJmNjE5Z1hOeTNmcEFCelRGQlhDK1ptK2xIRVNBVGxBbEtBRExU?=
 =?utf-8?B?Wm42Tm5uWm0vc0VOT0h6RWU2eEdTczJ6eFlsQXFWNWYyckxURTZKakIxeDVZ?=
 =?utf-8?B?cGlqMVlqRlZvVVBQRUYxdm90cllVWmJYZkRTVzZJRGlLNFRHdnNlZVkrU1Bo?=
 =?utf-8?B?N0pCRWozZFVEWnZHTk9hVHJHRWZPa2cyR1h1bjlCK0Q3d1hXQ280d2I5cEEv?=
 =?utf-8?B?djA2ZTFTRG5iaE9JQUJwbEhlc29VVmJKM2J6MUtQemc1WG91eGYrZHB2S0ti?=
 =?utf-8?B?ZmVRN29FQU5ab2k3RnNIYTZPS1FScWhveWR4anFUU1M2M1NPb01iL3VPVUta?=
 =?utf-8?B?cVdoYkNlaTJ4SU9EOW1sNW82ajI1cUdaL0dtNXd6eFNKa043Nkx5UXdMZXR2?=
 =?utf-8?B?RlN6eGFTbG51ODBnZUhpV3ZvY1o0Z3BPRzVmSkh1T3hQRFRjN213cjdKL0FF?=
 =?utf-8?B?d0YrY2JQTXNsNk53NGNFNy9zcmNBQUxCNWFxZmtDL01tQnI5ZW9EVmVZWXUy?=
 =?utf-8?B?eUFPWGpxNjhva1BFbC9NaGhTMTVmZDZ6bVhQWld3a0dtWG5ZeWdaQ2ppN0lK?=
 =?utf-8?B?MFlqM1ZqN2VIYUluMGNROGM3MmhYUFd6NWUxWkt5cnhFVGR4YTR0M2pXb2cy?=
 =?utf-8?B?UC9iQUVKNzRIMWxDallqdG9jcWRUTjh0YWEvWDROKzlYaVlMdy8ra09lK1NM?=
 =?utf-8?B?dW92MVFLYUg1QUVUaUNNaTZjVlA1V1doRVJML0N0clVKWmxpMVhlREJXdHNX?=
 =?utf-8?B?KzNpSzFyWVluNE9vM3B5M2hyR3E1V3FlNjlWVWxVVVZYc2pYTC8wN1JJMWxN?=
 =?utf-8?B?ZUJtSE5PV2doMjFYWGpHUURTREdyb3VZVFkxdG5kVkNUcGVzWThuc0VpRm8y?=
 =?utf-8?B?azVjNHBYLzdPaU1wYWNBelVUMjJUM0hMejVrZ1JTVDBuY2VaYzNBZDU0em5B?=
 =?utf-8?B?QUR4QmxhZ2xVSWE3aHRET1d5a3RoWWNPazFYL01qbUZoMjM1ME1lRCtFRXU0?=
 =?utf-8?B?ekZ2ZnAxZUJCVUlOR205MFZRWVB0bDV4L3huN0VoUFU2TEZsT1NJVWVOY0Er?=
 =?utf-8?B?MTBFeDVBMWRqYWxPVTBZYmlpbnVCeThoeUJsSS9objZpemhBMzQ2OTF3dzBS?=
 =?utf-8?B?SzFxYXJxUFdacDd4TGVtT3dYcG5Nc1k2MGU3cW1kOVZOMkg1T3ZGVnhhTFdF?=
 =?utf-8?B?R0E3MU9ldVFtQklsNjl2ZkxENHVIMzNXQmprRWx5UHhEWG9YV2RoYytQa1dV?=
 =?utf-8?B?YXBpcmpiYXhVLzhwL25zdXA4ZjBxK3ozTlhPeFFRd01VWnB0SGkrUTN1SUVP?=
 =?utf-8?B?T2N4d1NPWHpsVFM3TWRjZHN1S3M0d28yOW1sNDI4bG1FY0ZUV3B0bDdvQ1N1?=
 =?utf-8?B?SVlKR0NFZW9EQ0haMDVObzByV1RQVnBxbTloQXhzNVE4V0FpUWdZTVczcGFQ?=
 =?utf-8?B?c1FGaTJuaURSenZGbGYxZlhJNVdEYUFzZTlneG5TZGo3c3l6UGtCckdwMXZr?=
 =?utf-8?B?RXNrOEhOYit0RFBMOG1MQXlaZTFPbU1sWW9ZM21iK0ZxbFFoeXEyM21xc0wv?=
 =?utf-8?B?THJ4d1NhdXhFN1JtMmlCQi9yWU82RGl3VVhCRUxtTlpaL1hVQUtCVTlYSVIz?=
 =?utf-8?B?V05maHloT2tDeW5YTVFMYlRlOGhsR2tTeU4vb1BEWmtVRU5PbEtGK3VSMEtP?=
 =?utf-8?B?L3Z5c1dWWGhIZ0dXYW9DZlhQamVCN01kS0JUY05PS2RBVW5OOWd6THpBaW1M?=
 =?utf-8?B?YnFrbzAzZWZHZ2lQWk1JTkRXOGxYSkpKcGJNZGNxWDlQMEFCQjQveWhnZDFP?=
 =?utf-8?B?bFNadWhqYnFsNGZkUVA3RlVWLzk5eU5NVUZHK2FyQ2MyUW9xRzV5MUVYYnZs?=
 =?utf-8?B?RHFhcmZUR2lJUDh0L2F6TTNPT3BzMEw2T2poVFBvTlBwY1Nqd2FNbDF5QkRD?=
 =?utf-8?B?WWRmd2UrVEE2UEdsU1ZzZXFtV2NzcUhiWXFreGdjOGlNOG95VlhSVDRNRU9P?=
 =?utf-8?B?eFZnSm80MGpnMXFSU3ZLOGNmZEFvT1dYcTVrSUFYeUYzMW1pd3E3L0xjeXFG?=
 =?utf-8?B?eGFTaWJkYk9tTWlaaytXSWp4cEFWQU9Lc3A1WUpZREVGcFFacVE3US9sNXFQ?=
 =?utf-8?B?bVB0RjZmaTBrSHNDS1pDNVErenBJYnk5UW5qbFB2eUhPMndPTUQ3dDVON3FG?=
 =?utf-8?B?ZmpScENBQ1A5ejdoWWhKU3RlRUNGL3N4YkErazhwYVRXZGtaeXJSbEwrMmo0?=
 =?utf-8?B?RlFNSU1YS01ISk1qNklzU3lKR2RaTkw5dGZScFlNR0R0ZXpSSkVteHIxUGdv?=
 =?utf-8?Q?ejKPlgLW+xQJY0IfNXyR16FHEfFWF9FcASitF?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7696E28FC6FECB49A1948E2490D78A16@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: ibm.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5819.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c34b5732-bbd6-4026-6170-08de6827a41a
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2026 22:07:39.9313
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yKt95tFLkrbjTEArV3i89HsV3YW7vmhxDL6HVqGW5Bc19eFvXbNdFfJDLWt9tr38WqKX8ePEIz8liy3L/DyTVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR15MB5066
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=YZiwJgRf c=1 sm=1 tr=0 ts=698a5aaf cx=c_pps
 a=QCcpiOQK2QUg/MYG9+G9Tg==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8 a=wCmvBT1CAAAA:8 a=VnNF1IyMAAAA:8
 a=KguFhG7oBYGv1dtFOLQA:9 a=QEXdDO2ut3YA:10 a=6z96SAwNL0f8klobD5od:22
X-Proofpoint-ORIG-GUID: B6dhgnWJcExupVxg5uL34ggnhOUbwZ-V
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA5MDE4NCBTYWx0ZWRfX2KA1x0FYMCBD
 mrDwV8rWAmLp0ZK7J0WAGhYc1+kJSeX+lbcjMuqyZ9ui4tjeM5Gj31VXQFuBdcR7tKGzA5nQNVo
 xJB5E79KDNer6ziw9ovkSOY0RPtZO33/OfhfeBlYXar7gCOtHWYd62hGAIl2o5JrYmVLwh01RYH
 y/FJutUe/NI/smnjCib13J7ugnTo4OMPg//ifXJHxefRGhSMSFnfEeUlnoiIxQOVe24KfaGFQoV
 sDC9xygpdmx48icTbyrd+l9h1uRf/FPHX3qY/+ET/XSCw5hTKwXZZlTeuDza8O4UzR+FZLJbcbr
 XdvDrS8e4w3BWAXDpa6VQv2SxVtoHrRSz4JTgny5dw+CTdYrW5b/pnrj9KOQIwQJtScFadDK0F+
 Ci9F0by9/JB2eJc41EUNkNrMZuVgYTqpZw4Z056783k6zYI+CrOCz7XiUjR+bbNsckttNXtRsba
 9c6A2640Lbd2oenCyzA==
X-Proofpoint-GUID: v7N-go16bKoIaDbY_M7xwVcqm5KlleQR
Subject: RE: [LSF/MM/BPF TOPIC] Machine Learning (ML) library in Linux kernel
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-09_01,2026-02-09_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 impostorscore=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 adultscore=0 clxscore=1015 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602090184
X-Rspamd-Queue-Id: B494FA0002
X-Stat-Signature: z75spdy7j6gf5xs7eatxg3thuzhswxrk
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770674864-583862
X-HE-Meta: U2FsdGVkX19d6UrrFM7rB39O9n+UlLLngTXSLRfSH+qREQEbuSujtGpVLvyQjcA8bySpOgRZvi49SgRHQWb+4UO2mzwkJo+QBsAhFgebonfvR2OKk/RtrJ4b6YxCfcpM4i36ivs77c/LOR6A8MWiUmGUqZGr7FW4X5nijQ2aGPwS0HcFbO9fYfz8LQA5Zv8SrhkWnVQbqbtpeMpSJqoAtQqtFPhWfm2NqlVknL8SvwCYOiM0Qmm+xKys4wIXWLmcKpzLNQFqw9cdJpn6ShAu1hlCC8ClBLWdJadm609klaxhIbMv6ue8KLuRibvoGE8ZHL5ES66IbofhhlKyChsLMzKSf7rxWZ/Cq4R6Yn406Ea22slZikkxv6a2U1DJqSpza8hIQfbXBCDXJ+w/a8hDwp3IX93gE2F3/tTSbYyyLI3G3ufjR06Fv2nwMZ5QdTQSS+1QwkPNvfY+UegEbkIo8UKlAU3vitVC+F8t4TWd0aVwzMj5KjlzirIKKdB0oqyRQR4IoMyBnewf/ffxRLpUkU+To/9WppZsywsjlILhvo7GUMeghElKRFGkhZWcRMi/0Cd71YyGSukpN5/YgnCuBVB/OOtekAvUyERiYYKIG6Dxu9Oj2eGVRPi5V1oztGL2DET8DRcD8+Pg5qolzrdpFuaCmQA8stj1tFz3yc2/1+PUK9msvmLJh1KcZdmnZ6w4zHzzYHCUXB1z8CDXUmv/lKsngJqjUZh+I/+tJedvkpDWidsdZpxK6F825ShrYA8xEBfwH2qPAYy41zDEdQ6vvzJUDIavKsOvXX+x8J+YNc0OQzJGSqetOuN1RvnvC2yPxfb4I07eGzdTyEByxnmN7f5apl1Ivb9vRXn5vZCWLeRoSmDjNSW2LoigMc446rYlPZBUv44XafBDrm2X1V2UZC2HfH9SBZ42qLAECNrDGXFXpUI0SJA87zCkaINQn22Ana+mj8I74ULeNjqE4X7
 RHisPHSz
 IdSBYQnbQ07rgVPb5ObVz8+muR4XBWRoGIU8GPdnEG2hFs20Gw+yhLZVwRKuP1Hb0MDj4WNmdttUBE0Eg3Tm+YLPTCNjkcpqL111q42/wqWgjJfr6s69cGD35dXuzU8lWeqKMUqwjsuEAdQTrJKagscJAhI8dH1wr3kAz02QoFJD16JbabFW4eEEV3webwE0azQPfaq1alil0W3yGLIiqaydtu9DEzCsk8zSillp9pMA/jGrTPu17WgLv+hAwZJEkwtktX0/xv7+VeTeRo6ZVFLnIWubq7ey9GWuHabg15m4wDmue443bpUTWjwgubsuh3IM04VS02UOosjlnHl/K6/QwYP/yBojR9NsxxSkvIdHda0BM4GxC8flrXOzluJY5gBSN1DlP8CXxf7l7sm5Snb8GYrvgl4n4CEGFaiOVSAdvCyLrJBKPs7nfWde6dH+xhaZ4QuBeF14w/lTxytXjAqmRjy5iVadvNdBFGCvoCf1PMMzKVxVxdLMF+CBw1zn87+XOVLMxIgv7KfYn197Uh1AbVRKA+uxGPiEmZxPkcAEt15LuVpxelNjSHxEeAqE5yWUCGhw4iaQpPqNdCuUIOE+wQhj3SuCOpL2U
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

SGkgQmFycnksDQoNCk9uIE1vbiwgMjAyNi0wMi0wOSBhdCAxODoyNSArMDgwMCwgQmFycnkgU29u
ZyB3cm90ZToNCj4gT24gU2F0LCBGZWIgNywgMjAyNiBhdCAzOjQw4oCvQU0gVmlhY2hlc2xhdiBE
dWJleWtvIDxTbGF2YS5EdWJleWtvQGlibS5jb20+IHdyb3RlOg0KPiA+IA0KPiA+IEhlbGxvLA0K
PiA+IA0KPiBbLi4uXQ0KPiA+IA0KPiA+IFRoZSBjb250aW51b3VzIGxlYXJuaW5nIG1vZGVsIGNh
biBiZSBhZG9wdGVkIGR1cmluZyB0cmFpbmluZyBwaGFzZS4NCj4gPiBJdCBpbXBsaWVzIHRoYXQg
a2VybmVsIHN1YnN5c3RlbSBjYW4gcmVjZWl2ZSBNTCBtb2RlbCByZWNvbW1lbmRhdGlvbnMNCj4g
PiBldmVuIGR1cmluZyB0cmFpbmluZyBwaGFzZS4gTUwgbW9kZWwgcHJveHkgb24ga2VybmVsIHNp
ZGUgY2FuIGVzdGltYXRlDQo+ID4gdGhlIGN1cnJlbnQga2VybmVsIHN1YnN5c3RlbSBzdGF0ZSwg
dHJpZXMgdG8gYXBwbHkgdGhlIE1MIG1vZGVsDQo+ID4gcmVjb21tZW5kYXRpb25zLCBhbmQgZXN0
aW1hdGUgdGhlIGVmZmljaWVuY3kgb2YgYXBwbGllZCByZWNvbW1lbmRhdGlvbnMuDQo+ID4gR2Vu
ZXJhbGx5IHNwZWFraW5nLCBNTCBtb2RlbCBwcm94eSBvbiBrZXJuZWwgc2lkZSBjYW4gY29uc2lk
ZXIgc2V2ZXJhbA0KPiA+IG1vZGVzIG9mIGludGVyYWN0aW9uIHdpdGggTUwgbW9kZWwgcmVjb21t
ZW5kYXRpb25zOiAoMSkgZW1lcmdlbmN5IG1vZGUsDQo+ID4gKDIpIGxlYXJuaW5nIG1vZGUsICgz
KSBjb2xsYWJvcmF0aW9uIG1vZGUsICg0KSByZWNvbW1lbmRhdGlvbiBtb2RlLg0KPiA+IFRoZSBl
bWVyZ2VuY3kgbW9kZSBpcyB0aGUgbW9kZSB3aGVuIGtlcm5lbCBzdWJzeXN0ZW0gaXMgaW4gY3Jp
dGljYWwgc3RhdGUNCj4gPiBhbmQgaXQgaXMgcmVxdWlyZWQgdG8gd29yayBhcyBlZmZpY2llbnQg
YXMgcG9zc2libGUgd2l0aG91dCBjYXBhYmlsaXR5IG9mDQo+ID4gaW52b2x2aW5nIHRoZSBNTCBt
b2RlbCByZWNvbW1lbmRhdGlvbnMgKGZvciBleGFtcGxlLCBNTCBtb2RlbA0KPiA+IHJlY29tbWVu
ZGF0aW9ucyBhcmUgY29tcGxldGVseSBpbmFkZXF1YXRlIG9yIGxvYWQgaXMgdmVyeSBoaWdoKS4N
Cj4gPiBUaGUgbGVhcm5pbmcgbW9kZSBpbXBsaWVzIHRoYXQga2VybmVsIHN1YnN5c3RlbSBjYW4g
dHJ5IHRvIGFwcGx5DQo+ID4gdGhlIE1MIG1vZGVsIHJlY29tbWVuZGF0aW9ucyBmb3Igc29tZSBv
cGVyYXRpb25zIHdpdGggdGhlIGdvYWwgb2YNCj4gPiBlc3RpbWF0aW9uIHRoZSBtYXR1cml0eSBv
ZiBNTCBtb2RlbC4gQWxzbywgTUwgbW9kZWwgcHJveHkgY2FuIGRlZ3JhZGUNCj4gPiB0aGUgbW9k
ZSB0byBsZWFybmluZyBzdGF0ZSBpZiBNTCBtb2RlbCByZWNvbW1lbmRhdGlvbnMgYmVjb21lcyBp
bmVmZmljaWVudC4NCj4gPiBUaGUgY29sbGFib3JhdGlvbiBtb2RlIGhhcyB0aGUgZ29hbCBvZiB1
c2luZyBNTCByZWNvbW1lbmRhdGlvbnMgaW4NCj4gPiA1MCUgb2Ygb3BlcmF0aW9ucyB3aXRoIHRo
ZSBnb2FsIG9mIGFjaGlldmluZyBtYXR1cmUgc3RhdGUgb2YgTUwgbW9kZWwuDQo+ID4gQW5kLCBm
aW5hbGx5LCBNTCBtb2RlbCBwcm94eSBjYW4gY29udmVydCBrZXJuZWwgc3Vic3lzdGVtIGluIHJl
Y29tbWVuZGF0aW9uDQo+ID4gbW9kZSBpZiBNTCBtb2RlbCBpcyBtYXR1cmUgZW5vdWdoIGFuZCBl
ZmZpY2llbmN5IG9mIGFwcGx5aW5nDQo+ID4gdGhlIE1MIHJlY29tbWVuZGF0aW9ucyBpcyBoaWdo
ZXIgdGhhbiB1c2luZyBodW1hbi1tYWRlIGFsZ29yaXRobXMuDQo+IA0KPiBIaSBTbGF2YSwNCj4g
DQo+IERvIHdlIGhhdmUgYW55IGNvbmNyZXRlIGV4YW1wbGVzIHdoZXJlIGFuIE1MLWJhc2VkIHBy
b3h5LA0KPiB0b2dldGhlciB3aXRoIGl0cyB1c2Vyc3BhY2UgTUwgYWdlbnQsIGhhcyBkZW1vbnN0
cmF0ZWQNCj4gbWVhc3VyYWJsZSBwZXJmb3JtYW5jZSBpbXByb3ZlbWVudHMgb3ZlciB3ZWxsLWRl
c2lnbmVkLA0KPiBodW1hbi1jcmFmdGVkIGtlcm5lbCBhbGdvcml0aG1zPw0KPiANCj4gU3VjaCBl
eGFtcGxlcyBjb3VsZCBiZSBpbiBzY2hlZHVsaW5nLCBmaWxlc3lzdGVtIEkvTywgb3IgbWVtb3J5
DQo+IHJlY2xhbWF0aW9uIGFuZCByZWFkYWhlYWQuIEkgdGhpbmsgaGF2aW5nIGEgcmVhbCwgZGF0
YS1iYWNrZWQNCj4gZXhhbXBsZSB3b3VsZCBiZSBtdWNoIG1vcmUgaGVscGZ1bCBmb3IgdGhpcyBk
aXNjdXNzaW9uIHRoYW4NCj4gcmVhc29uaW5nIGFib3V0IGFuIGFic3RyYWN0IGZyYW1ld29yayB3
aXRob3V0IGEgY29uY3JldGUgdXNlDQo+IGNhc2UuDQo+IA0KDQpUaGlzIHBhdGNoc2V0IFsxXSBp
cyB0aGUgZmlyc3Qgc3RlcCBvZiBkZWNsYXJpbmcgdGhlIE1MIGxpYnJhcnkgQVBJIHdpdGggdGhl
DQpnb2FsIG9mIGRpc2N1c3NpbmcgaXQuIEFzIHRoZSBuZXh0IHN0ZXAsIEkgYW0gY29uc2lkZXJp
bmcgb2YgdXNpbmcgTUwgbGlicmFyeQ0KQVBJIGZvciBpbXBsZW1lbnRpbmcgdHdvIHJlYWwtbGlm
ZSB1c2UtY2FzZXM6ICgxKSBHQyBzdWJzeXN0ZW0gb2YgTEZTIGZpbGUNCnN5c3RlbXMgKE5JTEZT
MiwgRjJGUywgU1NERlMpLCAoMikgTUwtYmFzZWQgREFNT04gYXBwcm9hY2guIEkgc2VlIG11bHRp
cGxlDQpwb3RlbnRpYWwgcmVhbC1saWZlIHVzZS1jYXNlcyBvZiBNTCBsaWJyYXJ5LiBCdXQgbGV0
IG1lIHN0YXJ0IGZyb20gdGhlc2UgdHdvDQpvbmVzIGFuZCwgdGhlbiwgd2Ugd2lsbCBhYmxlIHRv
IGV4dGVuZCB0aGUgYXBwcm9hY2ggZm9yIG90aGVyIHVzZS1jYXNlcy4gVGhlDQpnb2FsIG9mIHRo
aXMgdGFsayBpcyB0byBoZWFyIHRoZSBvcGluaW9uIG9mIHRoZSBjb21tdW5pdHkgYW5kIHRvIGVs
YWJvcmF0ZSB0aGUNCnByb3BlciB2aXNpb24gb2YgTUwgbGlicmFyeSBhcmNoaXRlY3R1cmUuDQoN
ClRoYW5rcywNClNsYXZhLg0KDQpbMV0NCmh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4LWZz
ZGV2ZWwvMjAyNjAyMDYxOTExMzYuMjYwOTc2Ny0xLXNsYXZhQGR1YmV5a28uY29tL1QvI3QNCg==

