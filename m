Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C8BB606A324
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 03:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=PK8YzDc5
Received: by kanga.kvack.org (Postfix)
	id 7178C6B0327; Thu, 22 Oct 2026 23:19:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F87A6B0328; Thu, 22 Oct 2026 23:19:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B6C66B032A; Thu, 22 Oct 2026 23:19:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2F6806B0327
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:19:09 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B077B160112
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 03:19:08 +0000 (UTC)
X-FDA: 85352434776.18.69A311A
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazolkn19010021.outbound.protection.outlook.com [52.103.20.21])
	by imf26.hostedemail.com (Postfix) with ESMTP id E9138140003
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 03:19:05 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=outlook.com header.s=selector1 header.b=PK8YzDc5;
	dmarc=pass (policy=none) header.from=outlook.com;
	spf=pass (imf26.hostedemail.com: domain of x-professor@outlook.com designates 52.103.20.21 as permitted sender) smtp.mailfrom=x-professor@outlook.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792725545;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XTmDXo/pjdJNtEU2WmGt3GIKQRIQihw5jlwO8wFNaCQ=;
	b=UqRhM4APM24e5DMHegaEiigj0OvRuiIPf8PklmodPY6625k7MRw2eVKSBFurc6VBX6vZE6
	ddkCR74TZhQS6wIZdXp5BSC2J2NagciHwNxJxQDxTyLqzK4/hHc7QXYYZMpGcsSgUZv1fH
	pUWofqodGxo9xXF1Y1rnqjT5snWjLzM=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=outlook.com header.s=selector1 header.b=PK8YzDc5;
	dmarc=pass (policy=none) header.from=outlook.com;
	spf=pass (imf26.hostedemail.com: domain of x-professor@outlook.com designates 52.103.20.21 as permitted sender) smtp.mailfrom=x-professor@outlook.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792725545;
	b=J3dsWjNDpiw3Xv1r8vuGGWF6Tm1VqQf2/c/JsXLejHmLjR3TNeZvBL7RzAQlRRKrNQ4NFF
	qV5K7PfoFGauSK3Jf/t8leGSr4IxMQvxAybZDVyzNrxn+2p0RBFpwaIgR210+5RZhS6lSP
	nM2q036KiVEmtKAQg/Wr3/EqnA73Bx0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FF989drmrPWT8nbFnTF2aocyRW5UHqeHbq4OAutR6CqafGc/F3cUJXMaqKBNn9GHWTLlyjwcXN4gJ5jVbLoK9pT0AAd/ReVNioFqsMp6GUKqIxXozNAN6I+tw5ukpZhTNcP4dYNy/3xdHX2CVyAwymxq98Y2z0hUPVUu7LhKyjSs5rYt1Dh0pVSSNkV3HPOJWyX6j3ZRu9m6/jJRrn68NrAndiQGtTgae9co5wp4g9ucJHaP0jEXcPu+SrwXX35ABYCu64kPsC6ogX2F75YAaCAjosFq2HHvOOI8VfQ6HhIdbegHrF5reanFhebp4+7qlUnoxwDGq62GMjQHCimzEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=XTmDXo/pjdJNtEU2WmGt3GIKQRIQihw5jlwO8wFNaCQ=;
 b=WN8crcFHdu8/a2/uSJfqZrOc7oBT/EIaBJHHoW2e5ixC/alrxw9LR3omXmbRaQCr64CIYRT9h7/sXcpw668lcUDOfwLmmMIY7kgO+wM+mODkOj7j7Qxzc6VFn0DhOpLKlde8sR17hhxlNlC4yEdzgd7CxurULn05d0xETC4dRVhZcgJK5d0MzBxc/01NM3nGnOgXf5Ul2CbelaRSSSlX6YjC6nwGFj8jTwGA3Xo2FtAWPOudQUKBzmTRI0Ec9a7BE7dhjPCfzQcPA1KlPunaBoxX5cBJagNcVnCQIK05bUWrCtxwrJfih2c4IgtNttMQ873cnrYXwsglRzIqNBgPaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XTmDXo/pjdJNtEU2WmGt3GIKQRIQihw5jlwO8wFNaCQ=;
 b=PK8YzDc51UNtItfZcQubEhbTzPK4Go8pmOt64dgJqM6rB5KaDFE7QKSI+r0lGoAUSbkTcGKbDvFEualnTql+SO9LYYoD/VKVOV1TyOYjpvZD8CSYs8CfQVLrZFJf+FGD8xADtkRSTHj2exY+t3Rf//yJw1Hcb/V0OyS4OMNkcFNxoFf18z7Dc5kyNwHL0eYO6zRsepnsyLtRu/75a5gzojdS4n84Xlf/D+OLE1Vn08YKU8Tgzl43ZvvI3fwiYw2VxlP4IiPctwGM/R8uFJg64o6fAVx4C5TVY3Y+TnVCdQfrR1t2xOVMeuTDjNgVIWYtBjuyqAuXhSQ09GIF/aszdA==
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 (2603:10b6:806:39d::17) by DS1PR05MB10613.namprd05.prod.outlook.com
 (2603:10b6:8:218::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.18; Fri, 23 Oct
 2026 03:19:02 +0000
Received: from SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d]) by SA3PR05MB10385.namprd05.prod.outlook.com
 ([fe80::e22f:a0f5:fcb0:9b0d%6]) with mapi id 15.21.0546.012; Fri, 23 Oct 2026
 03:19:01 +0000
From: Yingjie Wang <x-professor@outlook.com>
To: Andrew Morton <akpm@linux-foundation.org>, Manfred Spraul
	<manfred@colorfullife.com>, Alexey Gladkov <legion@kernel.org>, "Eric W .
 Biederman" <ebiederm@xmission.com>
CC: Yingjie Wang <x-professor@outlook.com>, Vasily Averin
	<vasily.averin@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt
	<shakeel.butt@linux.dev>, =?iso-8859-1?Q?Michal_Koutn=FD?=
	<mkoutny@suse.com>, Michal Hocko <mhocko@suse.com>, Alejandro Colomar
	<alx@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
	"linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
	"linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [PATCH v2 1/3] ipc/sem: account enlarged sops arrays to memcg
Thread-Topic: [PATCH v2 1/3] ipc/sem: account enlarged sops arrays to memcg
Thread-Index: AQHdYp0/OtN6TF50S0i1VjdA6dr/Lw==
Date: Fri, 23 Oct 2026 03:18:59 +0000
Message-ID:
 <0ab8e85a569df7b9250f89e3f99da44b34996997.1792724953.git.x-professor@outlook.com>
References: <cover.1792724953.git.x-professor@outlook.com>
In-Reply-To: <cover.1792724953.git.x-professor@outlook.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA3PR05MB10385:EE_|DS1PR05MB10613:EE_
x-ms-office365-filtering-correlation-id: dae72721-f138-49d1-e624-08df30b462c7
x-microsoft-antispam:
 BCL:0;ARA:14566002|39105399006|22091999003|24121999003|12121999013|15080799012|38102599003|11091999009|31061999003|21061999006|22141099003|24021099003|41001999006|4140399003|19110799012|8062599012|8060799015|25010399006|1602099012|10035399007|41105399003|40105399003|26121999007|102099032|440099028|4302099013|3412199025|1710799026;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?6IDM2z+vyWy/kyltmQmm6G4ZiB8hYzfU+eWVBczh+xvI7jqmKXfmXAP4ZY?=
 =?iso-8859-1?Q?JRft5IYvf0XGrGRfYx0Z3qxhtY3jSPuq6KAdiMI/D8+XMkIWha+Ssrer2n?=
 =?iso-8859-1?Q?U0t9L6P3Nu9W6BiL0vINExCJEJjW8GIsxSYyEstolYGZfCZ3/3Hrv7yy3s?=
 =?iso-8859-1?Q?AQ19p9tnXpyXJVJTnzLKw5z3oaHMXYzzRbXtCayDX3aSUs4yMhdd//k46M?=
 =?iso-8859-1?Q?tFe0Mi1Gm3xquL7XaeXuUYJQew78ZqD3i3znf8LF47EfwS6twCKnk/TEDj?=
 =?iso-8859-1?Q?6Rx4HHfWezLCmyoUptw/afXWoinTJ8b2jZIYvi7qUeHeO1Y8sNy3hE73nD?=
 =?iso-8859-1?Q?KovM4ldXqKYQg7wqnXlXWd0pMBlj/QuokpdN7TJ55cD+eUDR5qEImEr2o1?=
 =?iso-8859-1?Q?MxNVnXTEnJsELsZdj1qj2Wfl7VN0OXK4dFkUqMxTJ1oUNGI3N+CWUwigXW?=
 =?iso-8859-1?Q?59POOO6I+7USCsvLwoZllPJe0vpAmQSd2uf4CjjR/xsRIkHrFeAnh58h3t?=
 =?iso-8859-1?Q?qHvoM9dbMK4BJFktigKv3s5YmOqZL6DFq8BcCurHaqzSh89tzfSeceD3Ci?=
 =?iso-8859-1?Q?MzUAw7r0uJnwUCLnsmAJqPNkdOLNLTHprDjX8GkLzWvXdoFEZIIoj72vta?=
 =?iso-8859-1?Q?IE5LByafhMy1JdijqkV+M/SzJlFxCPNhw5sBF0HcDfZIhM3il2CGQDvusa?=
 =?iso-8859-1?Q?arTQm8rldnvSdOs3+35UWT2Fd1dpzeb7m0gAQgs2NdttntPhF8s95knHbv?=
 =?iso-8859-1?Q?5R1LoTpuXCM9fn4kMnkhP4yVZXnrx/Zmghx4NuyLAtGx4pi1KcuFu1oGg9?=
 =?iso-8859-1?Q?xrNTHD7XJObrlqiWO5rJ83iFwvARxfpACrWuc0wAELFJUvoToib18BbCNC?=
 =?iso-8859-1?Q?RYywXQMZiEXx8PCLl5hs2O3dwEz4gdF8iNFQgiG6sY+IHzgsbYFFZcWCcW?=
 =?iso-8859-1?Q?LcAB8pKtKgYEjNdWKkc5Dyt6yrOjQD9DB5c1qm7DsVKPIu+M1oOxfaJaTm?=
 =?iso-8859-1?Q?k2BpybS8yii50GG0lb+fz/NuW/wtaBWucfskNtrES932lPmXb1OHJG5CD9?=
 =?iso-8859-1?Q?oZT8ps4bZ6I6QryzEu1ET2FRY50cJHdpdeuIHJiVvErFPxzovd3MvKTdDI?=
 =?iso-8859-1?Q?AvnYt6Wja7IC5RFvFhTk9Jb/gHXvd9yL53ggJQ1LW7jcwDS1j1W1WO0Y4N?=
 =?iso-8859-1?Q?dP834MhdNoxltA+NdZB/rjrEa+KmVwG/Mhf/yGJz1TYBYaTP10EHc7p2Tm?=
 =?iso-8859-1?Q?jBURhODzdb2hOUiBf6HeIdsRrCK3M0vd6BOOw+KG5vAYckqcmdeU49cREj?=
 =?iso-8859-1?Q?LD4tz9E3etepWI4/tmAFG0m3GiCdEpHHSnrWMl9jCgkSbWdNDVh5UAjMf3?=
 =?iso-8859-1?Q?saPZvRDP5K?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?M/EFMwJVQvFkvrUyEw9K6m0xIJubCG7HN7xXg19k91xkxb+CgSdYbuRD9O?=
 =?iso-8859-1?Q?bX8wv6I7ZBVY/IFIq7L6V/aBeG1XlD9+iMNHLwLJXmlF+G3Mds6izPeP6t?=
 =?iso-8859-1?Q?qIDO0bcQhMHX3Qf1ZnENBIAF015IfQWBuxbiImIWPHfxSPNPdiSKx43BUd?=
 =?iso-8859-1?Q?Zba8R3QKVgenLlP/qAt/9fCfC8+20jpsVO3PJdAI6lR/vt1cGAXZxX3+OK?=
 =?iso-8859-1?Q?Nlt4eBNb6y8/d/tPvDFXxoyyN721MpDFKv9wMLq2Gi69AkWj9TqSpP8c+D?=
 =?iso-8859-1?Q?mX0AkIwRTLZpXsbfK8X5L6nBDmphUteDCRHujyM/aavZkuA5W0ynPyPnDF?=
 =?iso-8859-1?Q?wDocJVo/DfvHU1fU887Udou8ev3fowlNrX7mM/xEZLVmq8ZhfPXzQW+hgV?=
 =?iso-8859-1?Q?TqaZIYnfH0t/bn28PRQQNNUQDZDq2rqnuFTJJ/GZoSUP3nG7FcfyN5Oo/e?=
 =?iso-8859-1?Q?UPrlGZgrnOAdn0KP3gdVLQhkhdmy9AfePxkoBSqU4Qt7MSd3Gr4sx/ohvB?=
 =?iso-8859-1?Q?xnmPCGFKaVkDY48a4S/LjJLZ+JCnnZQdJFM4agAiybK63nspJIoe3u4d1c?=
 =?iso-8859-1?Q?V4/zqGMWv9ND99KWVTs02UgB2UYu4E0uzSQTXoPsvHCOqm5xbbmocYbmAr?=
 =?iso-8859-1?Q?fOqF1+HZLPsxW5vOcf0XXLd5z4FpqNxrxjhJb9MHtw9+Ieum2WD5I8selK?=
 =?iso-8859-1?Q?FCyU7Db8lzutWLK/t8Wd42KcNhBaAHvqOgou6Y33k/SFg4/v4nzH/1lvdh?=
 =?iso-8859-1?Q?Tol1EhGGBXgxE76l+ioWHSgjvjYkZ/UNncpQfzf7t/podmOzFPqabotdr8?=
 =?iso-8859-1?Q?n6DmSO1TtpsmHm1nzemE5SxZ6wYHSpoZdJGY5QwqaAmOBS/4Tdn2dSO+hi?=
 =?iso-8859-1?Q?VZUCW5h/4FFJN9gyF7a2l0SHds7hjds0A0i4DXOwd6Qf+ztzUfg/RQBNKl?=
 =?iso-8859-1?Q?uhr36UL/dkGS73Gi5j03nX4CZw0mpz+2BTijQnQi4pgro1cS4qbSpUuQZD?=
 =?iso-8859-1?Q?QwGvOSo6ixzdFaHu9Zst8f8/UyS/6m/D3EQxhSFhgP44XFBgL7C6hDZGZk?=
 =?iso-8859-1?Q?2TtQSnm0OyspyPr7RkOB9eYflmGmqS+zrQk8PT+HGgm7YLHr/QA5bFROS3?=
 =?iso-8859-1?Q?Qf+/iMrkfyacUDe7ujHLCh4ntvMXIMIxWHRrWneldwAaLbfLspyY07hoa7?=
 =?iso-8859-1?Q?7Tz9YI0HbRYKttYo+pIVzKg1iU7cOWDI2ZECpu1N9SlWKSLuex8GiTzin1?=
 =?iso-8859-1?Q?yU/rIOnrujCsTCn7jFApAi3JUhA/m9s4YbhxR77q2JT+MRUp+lDtVgAv6Q?=
 =?iso-8859-1?Q?Bwjdbk4qwFPCbHPFFmGiAJDoFRQ6lGnclGkOs1+Q4VvDi6txA9PbmN4JUZ?=
 =?iso-8859-1?Q?4+wshHQXtT+1Pbu+2i8lrSjaGYjxV3ymFxQ74z040uZqBr7RYPJbinFwkk?=
 =?iso-8859-1?Q?eOgJwY5Q516rAvGn?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA3PR05MB10385.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: dae72721-f138-49d1-e624-08df30b462c7
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Oct 2026 03:18:59.9483
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS1PR05MB10613
X-Rspamd-Queue-Id: E9138140003
X-Stat-Signature: qq8kg338qgqpg6iic3wcd5rf1a8znap4
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792725545-161858
X-HE-Meta: U2FsdGVkX1+UMg45fZuSOlwKlFBp2EMJU2vSqldwfE5dQ8YdrEYImxtU2oK8KShqsnBgQdV9qo484yHYXIP1rvX7sDlKwaPKvV9dueHQL+x7NBoKKzqBTU8PGKWLX9VpJmrTFl1UD1i0XOhUnVDFObQiohXhENJ9lF51XqQWYBoARoYc62iRNY2VgLljJtROkOQALcAoIcA+ti3wlyVjDWubr7AeeakQtVekZxZsFvT3UM+5QteJ/yJ9XWEiOYaSKQDgk3BMbdrOzd//NwJW3dbhkmRy9NFwLsEg1Y+do3nbfGCFv6UrkElTCAcmSqNA2NGEjz4P4ER33piVxZ+cC6jJl6X2c70H/8p2pedVnu5ihMJcJ1ThtbbApWQzSzBjx7uJg4dTDeB1snSiwd2yWyxvyKZMhCuOWLARnGjAMM5nIRxddIYIttKtQ+KQr9Ti3LnBghX6TCsNDETWqXW1AuRCjBwJUgNwLgpueRZ3pbaoT1qp03NOsm23yVw2vEG9zLwgjn17T2z7of0+hB0eR4zAglwK6yRGuM0CAlXevHI5GyRxdDbNS68TYkQ31+4Y1hDS+aERY4+XFJujfO84A2SFGR02SyDdrdnjGGibo0S4Sfv+2FU/3YIOcHeG9GY7cjWSE6xK9D0zaEfsCKhZ2yFo5rZ6d/uj7zaklSBujf4boiYseZr7IfCBMZahEjYDlBeNNJT8toQ+z27d1Mq/QhulabUNxD5BbQEFBCjlNeIu6uoQI3/vhJkiFWovolRGzxQHuZZ/dzBcigGCXjnM6EJ0jAKxU+NmTL/QUuxOEjCv1pWcEKrU06lNzznBxBk9HqWIYsvCXU7Omq9eaXQws7ZufRI3E1og2F12OcPBPvO/8q4ekjJQ5rlUQ9sDSF9mn6azbj22CLslnMwtnKjT9pfs3VQi7hEGYsK3nxfxARUxPNz8oiimiP/KR1a/BrDrrfd2N6N7dPsb7id6Xgr
 VnFW0kX7
 fL+4qs4WTex10TZC/6iSVF0fOZQJPqNDfgt23HjsVFU4UXztfNVk4lPwK6NC6Np685I/tzJe9rbRMmJRCRZQec6gfFi3SCp7pjgcG2NuZ5Tmdq8UnT7QdE2NAicaOmYR0khdlau65w9m0fHtIIXQl15uAq2oF5C3qY6Na5d7niUqPdgIKRt7FLtAV22W6Oe64G8qRi6j4v45Vacd2Sr+A1+or6Iiw8Yy6IWJ1miPI4hld2qzjdNJijxm+gGG7RNzcLzfbeFS1sOeRA2H/Eb7/4MUO2BJ/HDPWhcpi9CI42pCyenYy1iYarRMK4p7qEAmKWt5BD/q+MMw/j/9wdOJfi8y9FRhEVX0KMKWG8pUTOmwpZAmXcdXn6umxg3dWOW4nIpnXiaV6MmjPrBBZrxp4yeF69ZNg0Z79qc/63L4MJFjGTQWH3t9bZB+pKk6++CXop9U2OQ8gymtHPBHqRwsyYq7gO3hMKzYl55z/YcNw/ADbEfQMcu3JEgCsICKJqrTo5IXAc+j3dBUjkVJUmqGCNiAEdw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Commit 6a4746ba0619 ("ipc: remove memcg accounting for sops objects in=0A=
do_semtimedop()") removed accounting based on the assumption that sops=0A=
arrays would remain small, describing a maximum cost of two pages.=0A=
=0A=
SEMOPM was already tunable. Commit 50ec499b9a43 ("sysctl: allow change=0A=
system v ipc sysctls inside ipc namespace") later made that tuning=0A=
available to IPC namespace owners without capabilities in the initial=0A=
user namespace. A blocking semop() retains its operation array, so=0A=
raising SEMOPM permits enlarged arrays to consume user-controlled kernel=0A=
memory outside the calling task's memory cgroup.=0A=
=0A=
Use GFP_KERNEL_ACCOUNT when the actual nsops exceeds the compiled-in=0A=
SEMOPM default. This preserves the existing allocation behavior for=0A=
requests within the default limit while accounting the enlarged arrays.=0A=
=0A=
Link: https://lore.kernel.org/r/20261016152609.2528805-1-x-professor@outloo=
k.com=0A=
Fixes: 6a4746ba0619 ("ipc: remove memcg accounting for sops objects in do_s=
emtimedop()")=0A=
Cc: stable@vger.kernel.org=0A=
Signed-off-by: Yingjie Wang <x-professor@outlook.com>=0A=
---=0A=
 ipc/sem.c | 4 +++-=0A=
 1 file changed, 3 insertions(+), 1 deletion(-)=0A=
=0A=
diff --git a/ipc/sem.c b/ipc/sem.c=0A=
index 5ec41de7e85b2..8c9edecc16076 100644=0A=
--- a/ipc/sem.c=0A=
+++ b/ipc/sem.c=0A=
@@ -2234,7 +2234,9 @@ static long do_semtimedop(int semid, struct sembuf __=
user *tsops,=0A=
 		return -EINVAL;=0A=
 =0A=
 	if (nsops > SEMOPM_FAST) {=0A=
-		sops =3D kvmalloc_objs(*sops, nsops);=0A=
+		gfp_t gfp =3D nsops > SEMOPM ? GFP_KERNEL_ACCOUNT : GFP_KERNEL;=0A=
+=0A=
+		sops =3D kvmalloc_objs(*sops, nsops, gfp);=0A=
 		if (sops =3D=3D NULL)=0A=
 			return -ENOMEM;=0A=
 	}=0A=
-- =0A=
2.43.0=0A=
=0A=

