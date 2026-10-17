Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B7B1CCA463
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 04:33:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4387B6B0088; Sat, 17 Oct 2026 00:33:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4116A6B008A; Sat, 17 Oct 2026 00:33:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D9246B008C; Sat, 17 Oct 2026 00:33:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E1D3E6B0088
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 00:33:09 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 04FF5160222
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 04:33:08 +0000 (UTC)
X-FDA: 85330848498.29.4F9019C
Received: from mx0a-000e4101.pphosted.com (mx0a-000e4101.pphosted.com [67.231.144.73])
	by imf06.hostedemail.com (Postfix) with ESMTP id 534D3180003
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 04:33:05 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=johndeere.com header.s=S1-Feb19 header.b="XWN Qg2y";
	dkim=pass header.d=deere.onmicrosoft.com header.s=selector1-deere-onmicrosoft-com header.b=OIZYaqCO;
	spf=pass (imf06.hostedemail.com: domain of "prvs=3750a1bbd3=bouziguesalexis@johndeere.com" designates 67.231.144.73 as permitted sender) smtp.mailfrom="prvs=3750a1bbd3=bouziguesalexis@johndeere.com";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=johndeere.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792211585;
	b=AM+FM1iL+cbBSw80o32c1GNTunpK9xWPzB+kcK9gjWpl4Sk0CA0Py8pbRfrFkHA1LNhrQI
	hZ1/nr18l2FErtKt3o82E5ixR7Kts7W1S9Xzo7QrlVFgnQ9RRjLTubqgkIBdhOdqvAUeHt
	SpUo7CUUFMN9qO+Qy2ZwLFE8zM4MU9Q=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=johndeere.com header.s=S1-Feb19 header.b="XWN Qg2y";
	dkim=pass header.d=deere.onmicrosoft.com header.s=selector1-deere-onmicrosoft-com header.b=OIZYaqCO;
	spf=pass (imf06.hostedemail.com: domain of "prvs=3750a1bbd3=bouziguesalexis@johndeere.com" designates 67.231.144.73 as permitted sender) smtp.mailfrom="prvs=3750a1bbd3=bouziguesalexis@johndeere.com";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=johndeere.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792211585;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e6yjR8vcqi2B66KyzonZaBG/I4B2tWmR9QejQR3yLf8=;
	b=DTGNJN/tmh6e8M/hSzXE0iwiMXja4D65vub5rCTNNzu2oqc5dh56ZI2nJnxaV2T2NUDnkH
	KxbWdR8c+9ENe8WAZf0eX5eLBWfR9xLKjOIuHpS3jQsFcRiYDclNsbgUYnSsukWUPKlmMt
	SJ7wRpvJIX+LA/m20ZcbZbclsNiKbZM=
Received: from pps.filterd (m0040767.ppops.net [127.0.0.1])
	by mx0a-000e4101.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69H3AInd165021;
	Fri, 16 Oct 2026 23:32:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=johndeere.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	S1-Feb19; bh=e6yjR8vcqi2B66KyzonZaBG/I4B2tWmR9QejQR3yLf8=; b=XWN
	Qg2yNdAnTYChaxjP8XvKpaa6JrrEq4Wz0nv6W3sHlquQQUqDhDEmoRiIUBrxZu70
	jdN0bcNuue0gdDOyeKmT0zNMXqPO258B0pJF4Xt9BxpKeEKMwsNpKMpn/46OpC/N
	sX3jz8xBgUDWHhr9O38w8PBZHMr/wO8oYAWys4gy04gBZouCoejce6mqrQYA+cd1
	taHL7acC2EKT1Q3WtLOata+6R5nd9SEqpUKG0mrNTYARswnrooZJrPknHN0AeTTh
	jjeDBWRgsCFbAWOzV5+sIPF2j37+G0mxdphKpZlMSNqkGb64xoogG85D+M8Y4JCk
	Py7jXMjHbiK2SlHvn/A==
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010003.outbound.protection.outlook.com [52.101.193.3])
	by mx0a-000e4101.pphosted.com (PPS) with ESMTPS id 4hbt46tk9q-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 16 Oct 2026 23:32:41 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Lq9PP4xZj/41NiV3jBqFE+jDTCqksoj6gjJexHPnQNlflopdCsa8RYdDbDj1oG3FbBYIh6rbYQ/GK+cfxMNPt6iZNn8dOZjIlyCPAdSpUD2Tt0mz5OdJqu09+ABAMUqU0Nb8XLzvzmmkmMjoICz5SPhZk1pyC91v80Kk/Qa90iHhnFaCfHM8nC+gW2crh2VxyvI4KFE5Iai7XKFMU5VMa+nbjQBEf6t0A2waNA0849oSpXyU1gb/o0n4tAr3d373dWjiSAsZrbpI2LLY3sE7o5DjO74eBgbu9lnZNDzfTGyKYltTdNEDE0gO7fyFmogyTsr2KZIs2kHHZoyXhBQLVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=e6yjR8vcqi2B66KyzonZaBG/I4B2tWmR9QejQR3yLf8=;
 b=wcrZVcGndF8g2yyAxIXNAEiGtJZGkIAW6Klj+Z5U7HvTlmTJxXD2UsT1YeNrVfML/CoCxz5xYdJdSsP0Y7WsQ09QXDg97CQOosLEEyMYwSUtuUO37ni92XaZ+P5zJMo1jyb/UkQqVZ/HkxSTnZO1oW44tqDqrGRr6hcefHk+Mtbyoy+N01oLBg+/a9Sr7mKhKPR0pPdoQaGnYaKQgWoQR5OQE7hMCugv7xFJjSIYD+bX+O4vDwG+5dFQYHtAF//JzUrfUeCVvu1xjX3JJYKqxRNQckBbY8jRGcNq+88Ge5NgQph4FEP3QrBViTzxSAPcB7cNwgtI3pI+5XYoFMURWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=johndeere.com; dmarc=pass action=none
 header.from=johndeere.com; dkim=pass header.d=johndeere.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=deere.onmicrosoft.com;
 s=selector1-deere-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e6yjR8vcqi2B66KyzonZaBG/I4B2tWmR9QejQR3yLf8=;
 b=OIZYaqCOLP/DVWzuI26gJDAFFGfmMt/PCo1U7f2xJucJRAaOh2BhDrI1Nn1BhBiCnTkvmX2xf7scjOTJvKpsanaFgzCyqA04XCysct7dIkQ6fDyPiq0DXj22dlcOyPwIXL02wCxenIh67gJ+AcQ9OB7XaiXh974gsPT/TSG5obk=
Received: from BY3PR05MB8260.namprd05.prod.outlook.com (2603:10b6:a03:3b7::5)
 by LVWPR05MB998875.namprd05.prod.outlook.com (2603:10b6:408:3c0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.15; Sat, 17 Oct
 2026 04:32:38 +0000
Received: from BY3PR05MB8260.namprd05.prod.outlook.com
 ([fe80::ed38:9dcf:7ed4:13f9]) by BY3PR05MB8260.namprd05.prod.outlook.com
 ([fe80::ed38:9dcf:7ed4:13f9%3]) with mapi id 15.21.0522.013; Sat, 17 Oct 2026
 04:32:37 +0000
From: Alexis Bouzigues <BouziguesAlexis@JohnDeere.com>
To: Michal Hocko <mhocko@suse.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "Liam R. Howlett"
	<liam@infradead.org>,
        Lorenzo Stoakes <ljs@kernel.org>,
        "linux-mm@kvack.org"
	<linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: nommu: set MMF_OOM_SKIP in exit_mmap()
Thread-Topic: [PATCH] mm: nommu: set MMF_OOM_SKIP in exit_mmap()
Thread-Index: AQHdW7DJydgmGYtttU6KWwNLmih5sLb9lhN5gACZPICAASWrD4AAaiUAgAFpPU4=
Date: Sat, 17 Oct 2026 04:32:37 +0000
Message-ID:
 <BY3PR05MB8260C9F9055EB094183544A9A09A2@BY3PR05MB8260.namprd05.prod.outlook.com>
References:
 <20261013-fix-nommu-exit-mmap-oom-skip-v1-1-cb957cdbfcc3@JohnDeere.com>
 <as80Rpm-VHhP14aK@tiehlicka>
 <BY3PR05MB82607AF910C023253C48CD26A09D2@BY3PR05MB8260.namprd05.prod.outlook.com>
 <atB63fzpLyfWpzPn@tiehlicka>
 <BY3PR05MB826006B6F1E2D97E247104BFA09B2@BY3PR05MB8260.namprd05.prod.outlook.com>
 <atHKQFi0ckwxLa-P@tiehlicka>
In-Reply-To: <atHKQFi0ckwxLa-P@tiehlicka>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_029374dd-2437-4816-8d63-bf9cc1b578e5_Enabled=True;MSIP_Label_029374dd-2437-4816-8d63-bf9cc1b578e5_SiteId=39b03722-b836-496a-85ec-850f0957ca6b;MSIP_Label_029374dd-2437-4816-8d63-bf9cc1b578e5_SetDate=2026-10-17T04:32:36.923Z;MSIP_Label_029374dd-2437-4816-8d63-bf9cc1b578e5_Name=Public;MSIP_Label_029374dd-2437-4816-8d63-bf9cc1b578e5_ContentBits=1;MSIP_Label_029374dd-2437-4816-8d63-bf9cc1b578e5_Method=Privileged;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY3PR05MB8260:EE_|LVWPR05MB998875:EE_
x-ms-office365-filtering-correlation-id: 85bfab61-1e2b-48a5-9f6f-08df2c07ac3f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|1800799024|23010399003|18002099003|10067099003|22082099003|4143699003|11063799006|261009223027099003|56012099006|38070700021;
x-microsoft-antispam-message-info:
 MQFxi8Ksxev9WZWMOYtZ1V9OD4+M9cRbAfWwd7ApmVMyebJ8arRtjxz/QEz7NSFkrn8pqciTEkHB/mH03Wh1v7fS5XPDiJLPKMm6FJxpFYHbAlwuMBEIbGmyPqe4hOJjSVmdqI2v43TMfNOT8ddjz7Pk5iKiq9og8i/QbyjJAlfL5sewwOiAR/KJzn1kE7hiGvozvX9/eUCTbVPEKwS8ukXT2gL5UPTy2mdsS8Cq6csQdRxiJVtkppSjmVvewmPwF/fQzV0mpfl/9f3XHYsSBKUeMiZqRFar37k/8FLkXuylsbwgU2QadIZ3kjjsHAs+pUr39207o4JBMKTA0HVo+yaOaUojNjnNu9YsrI7Lx+fCiefuhLL6KKtAdOzALsQZ+FVLjOkWB5H9pyC1WnEjsgksMMn4Shr7iDZL5ZoSTR+Amaw84Ym36P9kztSRA58ebNAbic4WxLySjHAX8DicqN8Dk+G3jz0Rvl8r44Qe6V0zj5GlDvPjWcvJEe8rPtV6jUL/pw4DaX5dqdFs/Hu7DrpUrOriKIM6RtoDhR3OUApcJ5OP3H8MIUcKtxvRVSjLAWoOb93oQWLWy/e02U9sIzLvTg7R0wWZH0nA82aM9wY++5kgD9J6k/h9AIHawPR2r8vzDR3GkqNvX+VgkEKVKNAOY41yQjfApEOBQbXSt6nvUlckSzNmxKG3CxRiH7L1d2fOV2uksLzy3NOVGFSPVn93quFZKwAkWdWCTnz4QZ8=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR05MB8260.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(23010399003)(18002099003)(10067099003)(22082099003)(4143699003)(11063799006)(261009223027099003)(56012099006)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?K9C34zfkRK3dCB3+g9VHqiJOxC5Qfe6PL9MFOzRtM+UFCyukyCIIF8Fahy?=
 =?iso-8859-1?Q?gPyIkehfLa52+a5eDeqPMq5KmF8WE/2n72pzvkGysAcN0WicVJHVhsFjP7?=
 =?iso-8859-1?Q?6pX4zOiV73Pd1FyI3j6/NH03ZKQQwv2QzpE/02dtoL8JLVdMHyAYp0e7XJ?=
 =?iso-8859-1?Q?2Jh8szNPpn3ME38D1IZKXJQSgLkz0LYPESe/8POT4NjiClzJkcJZYONziy?=
 =?iso-8859-1?Q?yXkMgeUccJEHUo/OLh39wLfP/zzOMVQIkRjbbGanMZyXDsxYnD5vOwP+N4?=
 =?iso-8859-1?Q?zczYW7pMsLiyGu6di+OZajVOZ4LlT+vU19cx2Ki0zIkUufX1Oa9/MsjJP4?=
 =?iso-8859-1?Q?QgVoXC2rVmLo70owj0TX0vatgJwtSmd+uSpmZwnhHmP1o04rk3ux12rpxO?=
 =?iso-8859-1?Q?RUXOSj4Tp93xpMAdA6hpp3K29oH/smajK+enkeZJnFukOcGEzzpvKbJVnW?=
 =?iso-8859-1?Q?WZkELPcORExqtIubLpAY1Eha9hDK2IOc5gWnVhJfTPq7WM46HTm1ut62Pp?=
 =?iso-8859-1?Q?O2Np3Hed5fh+YOxiJwZ0QLQi+b4ZG1VWSCgEfAZdNPNRNSjc8QZq73boRC?=
 =?iso-8859-1?Q?Py9FVPzi/Mti9VCigRgTeBgZAsydCQi9/V66BzEJ32aVC2Z6oASMxO/nTh?=
 =?iso-8859-1?Q?Q35oWk915fscRQF/81K20vamnQeF0FusQXAo2hdDD/lTEuwu5iPWThDzuY?=
 =?iso-8859-1?Q?oSvrKHhHUxzMjPwAU++Luw/1gkUbtwot30hUU6pzg0MCKkWPv/Gv8fRJqb?=
 =?iso-8859-1?Q?yihCBzU2X/qYESZEKY/KFov/3LyTNLaa4w7yiO3B7mwLVWrY1iwmjemPhI?=
 =?iso-8859-1?Q?OmmKFUwYp4mKw6LsM2KCoknOAzSrNfe5C0vTGasKqic6HdoW7lXqLJ3zOc?=
 =?iso-8859-1?Q?Or/EDlvcKf/V8gi0s28OCWBWTUDWuswoSjgpjuNdSTLGMV6t6fq89/qxUR?=
 =?iso-8859-1?Q?6/MLxFr/asYLANSRAXNwOiFht5XYM8w6DyVEPN0XZdKO68EEGZcpQY03VB?=
 =?iso-8859-1?Q?H4grZ02mrL1SedFoZ1FeDMYM1Ba/gLF46IPAjiAiGuwyw6+phwvBVk3BEd?=
 =?iso-8859-1?Q?6yaY4nLt7xPytet0uKBXfdyEGQcv+VmULT30SesxNGQw/EMkDBhWx4qI7v?=
 =?iso-8859-1?Q?K5SYNKA8v8RFb5II1YgoaVr9+6FF8SuS0SBY7gGoMSuXLunIXnTDAuIIp+?=
 =?iso-8859-1?Q?nUi7Tc5Nkg6Z58tBkWxV4FxziSPbjg4Lop8yh/9F5sOdMqSTcgs/YM6pip?=
 =?iso-8859-1?Q?hyZqoAuzq6f73y2kzfHzqG+MAAP9H0Xfs9sb+WXY+7k/yTkAkWtWhvsfE1?=
 =?iso-8859-1?Q?l8JLypvCw8u08h0x3UUudgep/AHBX6AUW5+8gr1tBEyTlHfE9q/T5L43Ql?=
 =?iso-8859-1?Q?vfF7iUa6yTOt1v6abgU1oNBKfyZABCOjnFW4xk+zT8eJId143vGGONPF6t?=
 =?iso-8859-1?Q?GZYrHoPUb9l5N+dJfaN63NnRMFYPjmVLjQH7IOI8BMeuoQ6uNdz/B0ZtkG?=
 =?iso-8859-1?Q?8zdztEaty95fJXoeG/9GVMDtkRiqDPr1s99ITTvCzRDzcFAnSrdG1BPSX9?=
 =?iso-8859-1?Q?6rpbFanlukFc5Mw1tOCrJgComV1QPFzBHC9ZytGhZBKOcRKQvtLiXKcC4V?=
 =?iso-8859-1?Q?qtK0I1JxhLY3eH4uotWd2pKqTtLx9JtHemIy2xqsug74Me5QkkBCtVMwzi?=
 =?iso-8859-1?Q?72W0xKZbvJtID4bI12iGYNbCyPAcRRtv1RMGkK1oW9j+jl2zhJMhWik35X?=
 =?iso-8859-1?Q?8LfjXXANN+Df+UHEvYN/I0rrUDmEndqJP2pfL3STUiFbO5LFVmCeIqfJx1?=
 =?iso-8859-1?Q?ycEoOFty8w=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	fZ0Ow1pqKmBSL5oUeWo8BbNR1Po1bLOaYkJDawpAGgnvV0XMYuapa2hoi/WdPKsN1VwRfsX4ri57X4BL//vP0IzsoebPE8yY74i+wZTj9M0+c1RiKQeaoSVckeEDjy3alSWok4Y72XyW1xUd4YR+M1HunrWNxl1EreXgM5g+2JndR++wV26dMFaD/wkQ/buw4IhHCCxWFfT1oX7sl5GmXI+BV/nrF5jRhOTFnVpisYLp2OAZc2tUYoSYIWwEwO0V2O50vYed6C9W1kuBWr68rgpPXBzEwrkVWSOwjb8Mt1BenrzheyOXydM6WVnQtpkyAsb9v12PNkNyI8It7HfkLA==
X-OriginatorOrg: johndeere.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY3PR05MB8260.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85bfab61-1e2b-48a5-9f6f-08df2c07ac3f
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Oct 2026 04:32:37.6074
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 39b03722-b836-496a-85ec-850f0957ca6b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vg/wH11rsJkPV/31S7mHJaYUeDSDXYHqziOOXxNYp+Wm8BuYA+cfpeqJB0iFDP95FBwTYqcz9ohUOK/yi17JcFasESnbYu4dwPsZvmcqg3s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LVWPR05MB998875
X-Proofpoint-ORIG-GUID: ETLAtiH3vKPSBC6s6vPxfE8CjZr8bC8q
X-Authority-Analysis: v=2.4 cv=L9OI0OT8 c=1 sm=1 tr=0 ts=6ad2fa69 cx=c_pps
 a=6F35cL4xT6GZaKJ9H0o0MQ==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=8nJEP1OIZ-IA:10
 a=660iZSQnnn4A:10 a=1NsiIDWdgNUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=EwEtIDNmD2uUauncVptr:22 a=yEPhWz5-7KGSXms4byli:22 a=_dcv9_zGgSeMFi8MxJwA:9
 a=wPNLvfGTeEIA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE3MDAxNyBTYWx0ZWRfXwkbUZ5O5oeTH
 RNhYm3ruw1DfH364Q2SbrBCvIZqwmc5Jg82Mlt47rEJ/YZUXvfLs1SV5w6k5ykmK7gO3yF44BHY
 LVFRj12J3+O0X442IYNK/LTtboGIbj7icO1l5jsPIYdbva9sNizQ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE3MDAxNyBTYWx0ZWRfX5C8YevA9Nuil
 eXJ0HwNGAWGEelRlfPL8NZHuhoLP6xfO5X/VjwzKQEMnfVzS11XqlcHLYGEmaXId2/l+m8YENwx
 KJAtOYozG0kyMT8fG8yMJWSaUg1x2c9dIog04j14iTw4e534J/538G/ZxNLTAeillK3lMOs+ya3
 qFqriasTvGsOrfEwCwYNarpil9Be3G0s+kfaVVs38kWQP1QbD/F7IWT0VwLHXIigm9fJTkiJXkU
 ylSApu2lnzUlrEQ47YEBnEUSi/KBAFe+t7b6Hhf+qLXgwtqgS7LnXxkjhDvb8x2ZpIimFF9QO/p
 skXVdGeEUn7sKlI8tBkCJla+u/CkfG1fDatmVUM27eVnAPgsnu/62gL0gDzrIJDwjiYvrOcWBHe
 Q2W3WyjrxjxA83i0F2Q5KGFcyo5GtnNnBjkoyWmtm0UQqO86xHwiXrpcLYWHYsV6CHCR0it0kvU
 AfGpC/6kNRGr0hb/nCA==
X-Proofpoint-GUID: ETLAtiH3vKPSBC6s6vPxfE8CjZr8bC8q
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-17_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 lowpriorityscore=0 adultscore=0 impostorscore=0 phishscore=0 malwarescore=0
 spamscore=0 priorityscore=1501 bulkscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610170017
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 534D3180003
X-Stat-Signature: ynbjiukdm9r88drbnn4nqnw41xsybjbo
X-Rspam-User: 
X-HE-Tag: 1792211585-774311
X-HE-Meta: U2FsdGVkX1+CB8/GHUdawmLU/VgSEaHBnfwrXqtSxLET9NRJzvNsA1FgqTP7fl2DNBKdefMlHq87RoXQVSleMMaGHDasjj2L5yT8cArsYOfQ/fQs31dsry/6Y/fcDYV65EYNlyz6CQV/1sYapmk3Hn5OsEe68TR6ukk7KSY6Q9AzKGVRVKIBmI9WGrSoXMC2iHuv93LAzMCxeC9EIxNO8vdRLPFiaZs8eC4O3UbLFhSqegADCMRPt4HKm6mo8/wr11nu53s2UpJfy+5B2+oN4YhQd6FgN/lj81lwrZfDThexOi9kM/TtlGvJFsWv8Xo3lMwGkho7JhlJvkKkpfsQcyKiJnAxcljeDr/ke2iv9HJc9K97erP6Ga1CvRLQFUQ/23OWBo8syTK7KDpIpl3NJktXKszcnCAxXu5iJAogE02J1mpc7MatqPfQxNx4MQWKywjX7VdQmJoWv/9O7EFdjE799293ddyA2HN484NTXiZmwh+db/XBXk+M0gJYm0KSnr2m3tO7wJcv3eqwVeEebPdK6SzTlzfqODLmjqpO64T422eMGtROmczNIAdiMCkav3KmrYVLYENV3w/D4MWVZ3MWZTanPlDeIlG/gYSbCYs3mBDSfJAlLm46N6ywohIG7ggLnIaDmynMo/6r1+SqG6KVG9q9lu1Kx2UUnzgAVsZClDM1KimTre8LUH5f0p7I71VUhF+aXyVoyNI88w3/ulepTHSgV2MyVUX6eKhgBI4B/5Up/MNi3GcqyT2XnwgdVBOEtgVmIDJCFzflhCkBMiNREircooaUEIysqqcquVvDc03ZY0UYZ3fSP4iqw82MHnhLJItEk5BrgyGYmdKaYhSMu+U9mA1ywIF5BDwF8Z/tI6OABVyBPSRrJyjjtWC0z5A5APXhN8zIZdCaLe54Lfsw6Vn+hb3eiVAOVVUdTA/5jLv5AkF3JpANG8iYpWURfrO44YT5N5uFjUp/XYI
 AbAANBYS
 Ef/m0buma6KDbb+a3DUZ7ejb4WCQM1+K8zFQhzd8pd+2b44RS83c9lyVmASDkPGBkyoaAcA2ixOE1S5mLjlJ7Lf35pnir2xBpe229sCb+xQAk6ECoy4CiJF5sxNsVVnvoq5k+jI2whOoVd9FgloSmcAR+NnWwGhdF6oScihcAYvaeOyT8TyV7Kzxon38RvcPWmAj+6ZRXBunDXvAdXsj95XkZW/vuofr3ndHH173q1ZL9BPzNMSeVaa0He6bBL1k1TtTM/xyRxXdXk7J4RmhPxNc51EmbXHsvrkAvf72gygPQThfrkOT1is3GKIDQOPBxp1uSf5/bgSBbcSpDw1gZg5z2s2arlT0/TGTyZycF8wXt5Xf9y32qbv3a1I7xiLpK3IflK8W+f0boxYpWwtEZYswaoie6v4Vo8uZ8cDt6HMAE3E8LUgI4vtaR9hQs6o7hNU59DTjvokktgYVhWM7xjTB02YD3xkFMzSbeTst8fwlsfzOX7/SYX4daF90cnwRF4FYUquS02jAwz6D292+G4LQ3DRcTcn6H7WmuNo7AtXrbj9CSEV5QD36lr1iaVKqau3qsCOp/ig99Knz//DkoKcJlKykQBnD/yNxTrSROGeOtAzaXOVDxeMULO3gcd1yEQiw35Ei50Ei1ui/tXJ4FEO5tGsGsrSTVYRZo/TCkqGYOPpqN7eX6ShKUmWFzmqKODKgZIPy4/2mqir160wg8Z9UOmNXfdOGc521BDQru94x7sVEdSO/Da2aYjbbvkWaUjS6amAtObJEPdAOVgtui2aMuQuOzVLXBzqBLe/KFoOsp1JG1wAnoBT2eiT/YXiCNW1mikwRYbtxGVeOZDo+YX7ZWbWqj6Iub//2KRnMPc5/E+e8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 16, 2026 at 08:54:56AM +0200, Michal Hocko wrote:=0A=
> Correct. The question is why killing the child, which has passed=0A=
> exit_mmap stage sucessfully didn't help.=0A=
=0A=
There needs to be ongoing memory pressure otherwise the=0A=
parent's allocation succeeds and does not hit oom_kill.c or a livelock.=0A=
=0A=
If there is memory pressure, then the allocation hits out_of_memory() and=
=0A=
then blocked in the __alloc_pages_slowpath/oom_evaluate_task retry loop.=0A=
=0A=
> a) a corner case of a valid nommu application or this is=0A=
>    a theoretical problem=0A=
=0A=
I think it is mainly a correctness fix (see below). I have only hit it=0A=
with benchmarks, including the /init provided earlier from which I obtained=
=0A=
the backtrace. I encountered this bug initially while running a=0A=
benchmark to test memory reductions.=0A=
=0A=
> b) why this doesn't break otherwise very fragile nommu oom=0A=
>    handling=0A=
=0A=
It does not break nommu oom handling because it places the flag only in=0A=
exit_mmap() right after the process has called the last delete_vma,=0A=
guaranteeing it has freed all of its private memory.=0A=
=0A=
This flag is used similarly on mmu (mmap.c) and in previous versions of=0A=
nommu, until the Fixes tag 212925802454 ("mm: oom: let oom_reap_task=0A=
and exit_mmap run concurrently"). It took it away from the shared=0A=
__mmput() and only kept it in the mmu-only path (exit_mmap of=0A=
mm/mmap.c).=0A=
=0A=
  void exit_mmap(struct mm_struct *mm)=0A=
  {=0A=
          ...=0A=
          unmap_vmas(&tlb, &unmap);=0A=
          mmap_read_unlock(mm);=0A=
=0A=
          /*=0A=
           * Set MMF_OOM_SKIP to hide this task from the oom killer/reaper=
=0A=
           * because the memory has been already freed.=0A=
           */=0A=
          mm_flags_set(MMF_OOM_SKIP, mm);=0A=
          ...=0A=
=0A=
This change places it in the same exit_mmap() of nommu.c.=0A=
=0A=
The MMF_OOM_SKIP mm flag comes from your commit a while ago=0A=
862e3073b3ee ("mm, oom: get rid of signal_struct::oom_victims") and had=0A=
the same rationale for nommu to mark the pid's mm to hide the process from=
=0A=
oom killer:=0A=
=0A=
    After "oom: keep mm of the killed task available" we can safely detect=
=0A=
    an oom victim by checking task->signal->oom_mm so we do not need the=0A=
    signal_struct counter anymore so let's get rid of it.=0A=
=0A=
    This alone wouldn't be sufficient for nommu archs because=0A=
    exit_oom_victim doesn't hide the process from the oom killer anymore.=
=0A=
    We can, however, mark the mm with a MMF flag in __mmput.  We can reuse=
=0A=
    MMF_OOM_REAPED and rename it to a more generic MMF_OOM_SKIP.=0A=
=0A=
Let me know if this answers your questions!=

