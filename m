Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57840C4452D
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 05:26:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0ED476B00DA; Wed, 22 Jul 2026 01:26:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09FE46B00DB; Wed, 22 Jul 2026 01:26:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAA516B00DC; Wed, 22 Jul 2026 01:26:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A94346B00DA
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 01:26:06 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 04D5340384
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 05:26:05 +0000 (UTC)
X-FDA: 85015276332.19.6185727
Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013062.outbound.protection.outlook.com [52.101.72.62])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1DE231C0007
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 05:26:02 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=JTvM97aw;
	dkim=pass header.d=arm.com header.s=selector1 header.b=JTvM97aw;
	spf=pass (imf20.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.72.62 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784697962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HrS8Wt16VQiyA3o40tGCbY0vBUUhhbbq7pFGrDj1SHw=;
	b=RgWvQOdOpTB2tg3YA8g2X+H6T9oPB3peQwjYftJGGirt1rEXklQlEGDpaHwlat0mUfSQfn
	m0JRjafF3YMWglMArLbzslfj1WnN3GEN7Xu3I48dmGI6SVIC7pqiLc5Pi4KIMdgh8hzIEH
	dS3YxvTpz54QX3s0B8R5W8Uq6yPA7ds=
ARC-Seal: i=3; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784697962;
	b=urtoqB2NpOZUVWZ7J9PCRUsSFq65pptpy01okXB5OigSPtTUnM1PIScoowDXCnGEHXMYFi
	8GwewbgxsxP+AcggHXLLBAH5kgovapHou/6EizjpyK6hT0tmNA+3BBi+P5UpvEQBQcKr05
	lLbyKTprmS7oBRTgXXzZaDIrnE9z8+o=
ARC-Authentication-Results: i=3;
	imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=JTvM97aw;
	dkim=pass header.d=arm.com header.s=selector1 header.b=JTvM97aw;
	spf=pass (imf20.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.72.62 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=Jnux0w7nVU07bqtDjq4P82DAbraKBSBrMiD8opv1eJktwGUG7ZzF1rnr+3nLcR+4gsuP+ZxBnZZq1ZpUAn0+YZ1SFNfb9CjDEG3UnV7E5eLZ9T324QVa1TUu9EsCapqQ2KiRde/MEzszdbWSOvS1A0D7H0xOl+any8YmW0vUK39Y/uaEH04sqBl5+lQz6/coQa4Z+oKP+c3TDKaDtA/5s6TMS8veMdhJGS7ZFRbAUr8rwKBg2/ARqn1kRmhgn8q2taW9kh/fM7sJoKsilXF9AOmLS0Vz8+xBiNZ84TJpzfSnkKI+/BLuckE9n/nleMx9cndQ/P29YG8/SNL3Ntf6bQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HrS8Wt16VQiyA3o40tGCbY0vBUUhhbbq7pFGrDj1SHw=;
 b=KA1kOiZvOg5ODnnWJz/sEhvVataKTzeyKSg1FJ5bWW4klX+NyDhxaPt/Tit7CR6YcJxk/7yEGj41c/RMMcUtEsGZYgfTWXgrg06uKbZDNjmDddakC6YobIeMPetGODN6U2o+ReYHhTU1D0KOBA4Rxysigetwe7W6lz3Juk4AHqMv2oY0zZ1zM0lL6NZjH8uHhmVpdqc9l9z59UrLI5Y9RwcE9li0s5PDfQ+xVJ1irMN+vcTywdXt3BcCjpTFQfSB9hkR8XQxUnw6ZtcJS7n3dYaOia57toQwexTEKp/Tj+udCLuX2DLz/Utfqz1Ap49X3u329qj1Sj7khqAPMi0pFQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HrS8Wt16VQiyA3o40tGCbY0vBUUhhbbq7pFGrDj1SHw=;
 b=JTvM97awcA37ObDL36ya82abCKCrXvHQpUsdVEz/0M7ambTwSvdScli0Qie69VGBx9YzGmabwlsTW6PHHxT54/AZAPg7ubEN72ngrVTUQ5C+sax0f+ICkrH9XZKdB6wFe8mbnk7/NgDrvW/lQGUGJNz/bI0Ynm1AGU1L8xyDNGo=
Received: from DUZPR01CA0102.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4bb::9) by AMBPR08MB11590.eurprd08.prod.outlook.com
 (2603:10a6:20b:6ef::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Wed, 22 Jul
 2026 05:25:57 +0000
Received: from DU2PEPF00028D09.eurprd03.prod.outlook.com
 (2603:10a6:10:4bb:cafe::48) by DUZPR01CA0102.outlook.office365.com
 (2603:10a6:10:4bb::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.10 via Frontend Transport; Wed,
 22 Jul 2026 05:25:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D09.mail.protection.outlook.com (10.167.242.169) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.5
 via Frontend Transport; Wed, 22 Jul 2026 05:25:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lzdW9PCoyd/ZpvCtVgAIu5yDjjb2h0U+MC82nrnl2dRUuBH4+jqWxtKu7bFm2tH6wftDhO/Zg49GhmZvL/NS+LvvGE+1HaD2lQVeREL4R4cCJ9QBSugj6DBrM+FhIXp9eADAqUPVdmFfndRHiTYvawFZ6j5tYxztTb50CVHeAo5w43pKkO5nm/y/nlzi18pmAPas8CQRO5mRLTC8jUdCyxM35rlSOVDPI0BD9XiRkiPIieho6DewHVKGmm4vnZxop5SavirqRWuP0n5ImuZLCfdpYe1vEe6wJycPZDc+gmDafkrub3YF2MlrzOWfTqgVEWzOKdxlm7vh3dcrzYyQhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HrS8Wt16VQiyA3o40tGCbY0vBUUhhbbq7pFGrDj1SHw=;
 b=RAs9LFkyOVsqp+t/zrfChoj2kLlmM9rNgakvomgdfAuxDyngO0sFl0ayo81jvAAe/Ams6TTlCdPsUMe5VtZajbn75ZM36hSpu2PQo2uPnQvaQmKEtYJzlwdUM9wmsoe+8x8HlwMmeQ71DAEoU2xab2STWyNu/KFiCl4AkNaOpe8G/Qq772jclIZCN7unuwlLepugrFee2YReMZvKWJZ8hM36emp7Cs/A+TkEu1fijDP0qJeetgOOd/U4pvy8PsjMM1ob+ycLjuqGFhwK6gJvUcNprjATGEr5i/Zq83P2wgNhbwGmr/syr6VBFp5nAzE1Y9W9sVdcGJHlLyiMs7ot+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HrS8Wt16VQiyA3o40tGCbY0vBUUhhbbq7pFGrDj1SHw=;
 b=JTvM97awcA37ObDL36ya82abCKCrXvHQpUsdVEz/0M7ambTwSvdScli0Qie69VGBx9YzGmabwlsTW6PHHxT54/AZAPg7ubEN72ngrVTUQ5C+sax0f+ICkrH9XZKdB6wFe8mbnk7/NgDrvW/lQGUGJNz/bI0Ynm1AGU1L8xyDNGo=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com (2603:10a6:10:417::12)
 by PAXPR08MB6734.eurprd08.prod.outlook.com (2603:10a6:102:13c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.18; Wed, 22 Jul
 2026 05:24:49 +0000
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047]) by DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047%6]) with mapi id 15.21.0245.009; Wed, 22 Jul 2026
 05:24:49 +0000
Message-ID: <cd539861-5f98-4906-8e36-f2a5a70687a5@arm.com>
Date: Wed, 22 Jul 2026 10:54:40 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/5] selftests/mm: make file helpers return errors
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Mark Brown <broonie@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Leon Romanovsky <leon@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Jonathan Corbet <corbet@lwn.net>,
 Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260716123226.197736-1-sarthak.sharma@arm.com>
 <20260716123226.197736-2-sarthak.sharma@arm.com>
 <b66c233a-7956-461a-a3d8-3421c76c937a@kernel.org>
 <004e11f5-ab21-479d-80a3-64ab89465b85@sirena.org.uk>
 <cefe62b7-0167-46c1-9fe3-fe7efee90a7e@kernel.org>
From: Sarthak Sharma <sarthak.sharma@arm.com>
Content-Language: en-US
In-Reply-To: <cefe62b7-0167-46c1-9fe3-fe7efee90a7e@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5PR01CA0189.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:1ac::17) To DU0PR08MB9203.eurprd08.prod.outlook.com
 (2603:10a6:10:417::12)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU0PR08MB9203:EE_|PAXPR08MB6734:EE_|DU2PEPF00028D09:EE_|AMBPR08MB11590:EE_
X-MS-Office365-Filtering-Correlation-Id: 5fd5740e-baff-49e9-f968-08dee7b1b514
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|7416014|366016|23010399003|11063799006|56012099006|10067099003|4143699003|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 xS3Zlfgd5Gm1XeH8/zFqLRJGOsjbwZgBgxqrXFsojj6lVGizb4ZShXarp0kB02/625AsVqQPTMkQEA2FGCyRhQiefScvAdxWEad7VFWtKhh2bY/0fTVELBwzggZD1zput5NGXRhP1ol1MVRESk3yQHFktQnZHjZb19iZtYzWBjOts9zJP2uRIvQdUkOYvBEDXD+tqzXKykdhbZ2ApplH0JiHPBHnkjwR0QxURvmZ2DopaXr+Tq17fI1grCizAdzQ4et8KaFJFDmnreGL4iTF8x3pPcRYhhDfdFZ9JHTdZaoljb1RF3edh2cWi8y3oXJkFXKrfxzsrfqOrYwZ98WRdUDb3djJuK/5Cz+NlA0c2jxmU842L0fST6dvWOcxcDRRpWbYCV5pal5UGOglH7DOKBD51XqgiZIWcerI4fmhiaaJdMF856vwU7YqH+9DMHzr131q7aUWM/SM1+paNM5Ntw1e7xWcfbXRN2eInqKvjit6qCUm13ZLdqiodKTVg40saw6dH40k7D513QSv0gRCKhTyvZkqLP5ZdEjYMAvrO0zXZFdUZEk0z3Y1dRgUEeUbl+JxrdSl33wJMfJ6TADWdSigJbA6iGnX9HGfR9oyg43o3iGSltKham90ZUjZhLNUd8llq+qyTsNXzENx5Ql9hRIvAiOZRsLStlAUkZjitWA=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9203.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(23010399003)(11063799006)(56012099006)(10067099003)(4143699003)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 OX37UoNK5hVywZh68TC4qube886sMBltMCamo0o2hDy5RsojRoj1rPzBM+E8JtGhnqkRoKCFUY+HuOmKwcKLNq98rk9sb06ZTwgR9fcZPu2g7rQE3ctLgvclZPyMZ9uAnO9o8JhVafq87TVNrlbUt1QmwYtQjBysZK+Tn2xcf0QMvPeZOdK3ssTvFYOTRgaGiJvJM0BTXn18IZzXUwy5Tu6dldC2lTWAHDNwLn9Je/WFeyAmZ0D4uuSofDFTTFQKlpC5zsIg1mllYa2NKyu3irX7FgbEyK/8nIg+bHMWSQ1Fa8C9EZzbqqjpgcNuZq8rM6Wis6gqElGVn9CTpoR3Cg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR08MB6734
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028D09.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	7e15cb80-4db8-4639-f852-08dee7b18cdd
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|36860700016|35042699022|1800799024|82310400026|14060799003|6133799003|11063799006|10067099003|4143699003|56012099006|13003099007|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	wqiiDG4ncNWAmq9pHHS4NWhIUR3Qcvm8ckEW1bojWZEKh8qYjyncY0PzTiVL15iSkpnctZCwyLnXSPH4IXnmxEXT01IK9+4ZYcAcGFreXLAbX38WyzGrgDaaMV4sRos9tqtAxTW/ei1JpXVMHzjFCCmbKO+R6CAW5dJBOCwRn7/n8buHo9KunYSRRHATo/DB1PIChSXAaZI3uBfIYlKLm07bEt4EL8fKlnuHTZbwR3eIwQhp7b6J1roKiW6lTePigwIvhx4/y4pyvDGWWdcKqVgu2IcjFCnn7+dxLBVXV15JIBRlciIRQur8s3qd44bSrwack7+u5fDYcoGGTYPanuVOEqo78XQA46ACRa5YBVLPG5wX9qQSHq4QMhhNVPf24k9ot/0cucV37IXqpQMK4nAACjeBsm48zJx9W7kEztGHzZ65zH6qCZZH67cixgUAatWt85xAej3l79e1kl8f96KgPT5cMCju/vSOgE9fF69a9/2pR09mAr/ECfHOEddwFl0qaNEr2Kgyd+BbieqGwm2tgs0D0ZXSiy25voSPwJ3pHDiF//TcfXMpNyQ8NThVkN1wuMbBrwAoS9v42wTl6rLVUw+g51XkYjGqiNnwDmzRTOyUQcK4cpnrs1J+Gw8A5NzHow+kPmq7GviS891Z8XKf9bQbvv7FutLQi8taXzy/FQpMrgz7SCGpf9U7E1WnwyI0kO3YtMHo3MDR7j9RGg==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(36860700016)(35042699022)(1800799024)(82310400026)(14060799003)(6133799003)(11063799006)(10067099003)(4143699003)(56012099006)(13003099007)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	sq40I8f7pfxAYrPlsEEjt5g8Qzb/7zfTQZVVcdRxm0Ydg+x0sFNzo7TiamDXgiGZQkV4fAYMmv4ytKLzIBsp9xqDSdCNbD2r5aV2OATKUgUmQJLu7ySQWM6e/Dw7O+VRU0Iof1ksHFPWGEG4IJaprntZ8WfdCckb8/u06+/20YtFlGUzX3oDyvA9pjvh3Qumub4L7cUxoWGXNMc5NGO6kkWkHVRBJgcQgTWDDbfFhqqnvLAo3qQB9HHfFNvge/LvRjytxC4eMdrNdzz2DZVOI8IhPg9LbBhzIdwrZrNTVxJX7akSAOWu1CA/4Zp7RR+TcI7v7ZGWpoW+85ZjNA0bEMPjCTe0qyLg/fPOVqy5szsx7UTCcsKwkXfyJLfHmfPMqpBHawe9MPEmrVsxMn0C0K1kJE4XSs8LyAut60BMH0DljwajAfryOIuSaHbeBMQS
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2026 05:25:56.5483
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fd5740e-baff-49e9-f968-08dee7b1b514
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D09.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AMBPR08MB11590
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1DE231C0007
X-Stat-Signature: 75oa67nendy7azbw6gsdy18axs6x7mrp
X-HE-Tag: 1784697962-925726
X-HE-Meta: U2FsdGVkX1+bQI28Fq/dQ/ramwjs1QvezfHTr80Z3tfxLpp9ZtKOFRG/maIzV3LFS6LrGxpkM4YaQnSlIObTJR813uJmIveB7/22N0ZPrIh7/j4dd0tvI0WUVGaUU6QgciYuN5r/tcpDjmZHOE9nv8s6TRx5Pu9pqR6yrObVF9QF50RuvszX8gqlJffIHydBEs47bCR7au+MPxWfiZMOjWgG8YtVnOHrlbYUO61b7Tfc1mLVgaZ3NwdbIqRueAwTJ90jRgTJ/N2mcX9bXKnLMUT1ipqXLa7wgEe70hWiXUeEo2UIb6eiGyZcVX4YRMEea7oNcQGcgjT2P60J1pp9Awc0Xs6t8XGwURxC+E+y1UsnBggbKmYU1s56kEf/PkwIa/MzE/tQbczLaZp1NJcZj3zdbjZBI163CdDpCsD2Xz41Ksteli6c2oKJwYxK7e0r1fNAZKSfxFg0epMIIFPzsIc7vZIQ3iGQaw8pG/lozOy1J6UUPTOPdAuy8PM2us025On6rCfqCrhK18/BUX3iSbvT4GoVVf55olV61s+ov+jlvTEK1JmwBGZ6BvR8vh+12jWhHwmL1mKDOcWU/LMlo1bkEy9cMECnBRMpowijZBjXBXXIkuoS/xeJGi5PKFQl0uJCw9CPWqd7iymDLihm4jNSuZFL5qC++guXjJsN/BZphU/+7nlm6pgbUsyIJJTOO42pt7AF744Ne5WX2bnwSbB9xcwi0SWDjEMF1Mifq8Q8z23tPuV5+2J/sDpf7mPI57WBtuzqdxv3MUPe5TsLyG6OUgjCwZggvPx1mRveEMD9RXZ26zG1yoDx7yOK6stvPVXethNSe0+9OXWCLzbAwrM1DEqbbAt2+CBoYw04mh0Hq3j9OOa4DO4XZBNMtMgCl53lQkOBb7fN7F01F7PunPfFK48qYN4Cj/aaVWjOwCVH/4w7pzwNq5SWZquoDMIj/d8Z6iPrdX/lD/2RpdJ
 I0gta5dY
 /DtMfyrWHyG776ZfdiAEOGggcJvG6pc6lma05upsPl6IHDjDpgnAyXuTtFLARzvjFPe/NrXhbjfvLEhVFfRO3zsaIBvxjdc5zgk685MlDj8sO2ehKFzrgXKu4g+x3H4B+AMrAPRjG+B3DSBvGDicvQ0cP9oS8QvHmW9y5U3HfVIfOOqBbRiisDOWI1sw9xXrMTkbIbCXv7I+mhjfH/VjtrdB70jVMTpDR+vjpJK/gESjZIaho7mCT3A/qM4SHka1O/DqlghN46NT3Zk7SSUCuGrwe17Fk9w3fqcXR3jYO7u0M/lmaNI0D7J0ZbW6wzBJFBUXyxdmwalABR/mreHNrOkjM4U4hvIH4Nqc3uH5lMpS2QwOZyTKprip5RBiBLM1UCkWcJbwvmpCtV7/sTJ3Is4zDA1K8FRCzeUp8S9jdsHva5rO8lpNt4k0ChKfqFEng1wlHsD1RdY3lhGcmxYg4wHVJhu2Av1HMvGn0EFypr3yZ3ChReFEqi2LI0Av5C6Q4E902207z16KryxSOsODy56vQmuabAKA4MzEU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David and Mark!

On 7/21/26 8:24 PM, David Hildenbrand (Arm) wrote:
> On 7/21/26 15:48, Mark Brown wrote:
>> On Tue, Jul 21, 2026 at 03:39:09PM +0200, David Hildenbrand (Arm) wrote:
>>> On 7/16/26 14:32, Sarthak Sharma wrote:
>>
>>>>  	fd = open(path, O_RDONLY);
>>>> -	if (fd == -1)
>>>> -		return 0;
>>>> +	if (fd == -1) {
>>>> +		int err = errno;
>>>> +
>>>> +		printf("# %s: %s (%d)\n", path, strerror(err), err);
>>
>>> Shouldn't we be using
>>
>>> ksft_print_msg()
>>
>>> That does the magic "# " for us.
>>
>> Or ksft_perror().
> 
> 
> Right, and if we want to move this to tools/lib/mm later, maybe we can just not
> print anything and instead only return expressive errnos.
> 

Yes, we are not using ksft_* prints here because these functions move to
tools/lib/mm later in the series.

Printing errors from the helpers was suggested by Mike [1]. I also think
this is useful since the diagnostic handling stays at one place, instead
of duplicating it in every caller.

If we want helpers to be silent, I can change them to return errors and
let the callers handle the diagnostics. Please let me know how I should
proceed here.

[1]
https://lore.kernel.org/all/178048086818.472368.16811711474077698399.b4-review@b4/

