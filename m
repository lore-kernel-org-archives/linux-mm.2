Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDBAAC5DF86
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 12:10:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4C026B0092; Wed, 19 Aug 2026 08:10:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFC5E6B0093; Wed, 19 Aug 2026 08:10:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC4A96B0095; Wed, 19 Aug 2026 08:10:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7FB666B0092
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 08:10:45 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 165B71C00F8
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 12:10:45 +0000 (UTC)
X-FDA: 85117902450.01.B898503
Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013066.outbound.protection.outlook.com [40.107.162.66])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0539620006
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 12:10:40 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=rlJ6zR93;
	dkim=pass header.d=arm.com header.s=selector1 header.b=rlJ6zR93;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf03.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 40.107.162.66 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=3; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787141441;
	b=QWGpRRAyvaAbxYFshsPlemLf+1NCoZGSinp5T67VDqgq9CoFeYATT4R8oxLPfVpauw8WAE
	Scyvcwr3VasFSAvpoGrTuWkfVIbk2tt4ivF4kOYF5DTYUYMbv34CFp3acx0NOoGzTmesBr
	cIsujE9ygByAHFTPBdWssqHqsxoE+NM=
ARC-Authentication-Results: i=3;
	imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=rlJ6zR93;
	dkim=pass header.d=arm.com header.s=selector1 header.b=rlJ6zR93;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf03.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 40.107.162.66 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787141441;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VSv4cfE821Ulrt8Jyud+ED5K7qfNm/pB1A6YfZEY+44=;
	b=PSEr+0ff6sU2sOGXWLI9kpExq0yxpoM3rKVAKWZ7hbvpgFpynhGULNHWKTaHI3p/5ORyNm
	LpCstxTih1hPs0Ft2cWfpsWj+EY7/RhoDfnFJqHTPMvqMILd/pk85ARgyX5YSUHzXtw/ja
	4F1+y1TFqd2xpM6EOBkPg8Fq+9A/0Z0=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=sxpjmbOtNk7PYmYQlMBtiEvehRSKNib4wGGsHMcogLmM01HGeoq4mnbtFTARMAiSFk1l/J1K7iNkQoTNk6jdcsNq9Mn4e3mXraJNN2qwnz9aDFOmum6SSabcjFto+meBFN7WeJqu2j1BsbmY2mY5S/oW11aVZ9EWT/5DHBvzBWpbdMt6hKcbtxRRLnzx3QzcDzQOYx6B+Arsdj5SKZwQEiqzb/kTne4ot9GdPprgSVpWnlN8Jcqe+EPUMyG1UGGjfTdf1PNHgFuuwUN/etCmQleytco30tPu686Hc/bErRlAUwmYMXo442qnVx/vsE1xvZH5HfVgDvIFTgi1SByRpw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VSv4cfE821Ulrt8Jyud+ED5K7qfNm/pB1A6YfZEY+44=;
 b=PCbz+1GAeBp8WSbkGqWTEM8qX+o+Jbm9NZaAftPbdf+Ar90mo/NUw/6RQm7fGhmdi2lKqLWJDwAPAmWk7HXfA3meMT0yRERXtLQxhvNA5iyLQ2o9KS1B9rIlhsyBlImvKdGb4soDGv9VAAQGtgH9d7Xf9aby27Rxat7dcux6j8Odu1Lb8XXVFu79eQFEiZoH9dFPXZkoDLq7yzlQk1bQAqR2CSMnqVCxdqYLJA0nfa3tF+hJovYlUgRCW8ZbOWoSx3MzXyOIzrJSo18whVgXUbOt3o98DwVXjO5ZmUyvgRfe56B0EpstyuB0THxAEeKbCAHfHx/xiG9alraz7G2mRA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=gmail.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VSv4cfE821Ulrt8Jyud+ED5K7qfNm/pB1A6YfZEY+44=;
 b=rlJ6zR934Au3s9yTsPSC1rxvae6yKOuTUMYNnkrvCKMQNK+VC7KdlJTovnz2gEiFJWLhWr8h+EEW+kxQXCVoamzfBxmzDGat978ApHfFWy76KORePXatZ1U6h2CphgbY7F6Do1l6wU1aYoRjgc+DWLEnKP91D0R66UF6ludHeos=
Received: from AS4P195CA0052.EURP195.PROD.OUTLOOK.COM (2603:10a6:20b:65a::12)
 by PA4PR08MB7572.eurprd08.prod.outlook.com (2603:10a6:102:271::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.8; Wed, 19 Aug
 2026 12:10:34 +0000
Received: from AMS0EPF000001A6.eurprd05.prod.outlook.com
 (2603:10a6:20b:65a:cafe::f) by AS4P195CA0052.outlook.office365.com
 (2603:10a6:20b:65a::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.339.8 via Frontend Transport; Wed, 19
 Aug 2026 12:10:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF000001A6.mail.protection.outlook.com (10.167.16.233) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.339.3
 via Frontend Transport; Wed, 19 Aug 2026 12:10:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pjdtQx11ITtTjeSwTxDfMRZF2EYv6xgtCWT7nQ/K2v6RGBIByxv4q7qkXIXP2aPYQ0Q/yM3wmSswSGGoGxprBduvGdTCOmhpA5JhsWxDmth+KxXAwWPFAvSaWBtekD1U+jOEkkoZwt3Cr2OqIi913CK6F8WX6CRvZi3wckoDpADxdvT/CkogYivSPuUiik5OCFS7LUKcn0BUsUbtclXDpUD/a4oEcG2ahIV/ifHOfdsInH9JyW364BdAXQMmcANY4Sp1iQUw2L3qjprB/BAR3R1k7stDA4gygHjqxCbtjDGJ6op2q5+64Xy0EaM+CtsKBudlqqVDq0J3WzKyvYLJIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VSv4cfE821Ulrt8Jyud+ED5K7qfNm/pB1A6YfZEY+44=;
 b=N4mVZKXr8iUlFUYLAgIY5K9E4UdozLaQjwein1n0pxUFcXFh/2JWM35SmMX28g/fCx2+gIgXIcAgTNBm/wzOX2aqNZqKcBJlRNmDOkABmFZXh9nQXiui3vkdYZf1QkT1NNZPDEYMILPyBW3LiAVo/FbdneBlXNunFsd3LvlyFOLb1UfiNdFnlZeH4V64dtud19x7PDnbNOqnOEmj0DzwdNdouLHY4B6yE9V0y+ZZdJ1xcUGKCXeWOlNXcuZcB7JcIGvqGhkLfQNdpOhHLdrxyFYxRfakrE7yE+XyngNPe+E1DYJxOysKrldT4YdiWX2dzIbbBJT6dHmjaOSV3t5ghQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VSv4cfE821Ulrt8Jyud+ED5K7qfNm/pB1A6YfZEY+44=;
 b=rlJ6zR934Au3s9yTsPSC1rxvae6yKOuTUMYNnkrvCKMQNK+VC7KdlJTovnz2gEiFJWLhWr8h+EEW+kxQXCVoamzfBxmzDGat978ApHfFWy76KORePXatZ1U6h2CphgbY7F6Do1l6wU1aYoRjgc+DWLEnKP91D0R66UF6ludHeos=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com (2603:10a6:10:417::12)
 by VI1PR08MB5456.eurprd08.prod.outlook.com (2603:10a6:803:12d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.8; Wed, 19 Aug
 2026 12:10:01 +0000
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047]) by DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047%6]) with mapi id 15.21.0339.007; Wed, 19 Aug 2026
 12:10:00 +0000
Message-ID: <3d3a0b45-c59e-4f73-846f-fe741ec8f65d@arm.com>
Date: Wed, 19 Aug 2026 17:39:54 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/cgroup: set the test plan after the setup
 checks
To: Hemanth Selam <hemanth.selam@gmail.com>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Koutny <mkoutny@suse.com>,
 Shuah Khan <shuah@kernel.org>
Cc: Guopeng Zhang <zhangguopeng@kylinos.cn>,
 Sebastian Chlad <sebastian.chlad@suse.com>, Waiman Long
 <longman@redhat.com>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>,
 Nhat Pham <nphamcs@gmail.com>, cgroups@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20260819083600.1351711-1-hemanth.selam@gmail.com>
Content-Language: en-US
From: Sarthak Sharma <sarthak.sharma@arm.com>
In-Reply-To: <20260819083600.1351711-1-hemanth.selam@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5P287CA0024.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:179::14) To DU0PR08MB9203.eurprd08.prod.outlook.com
 (2603:10a6:10:417::12)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU0PR08MB9203:EE_|VI1PR08MB5456:EE_|AMS0EPF000001A6:EE_|PA4PR08MB7572:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a3cd623-4878-41c8-558d-08defdeadf18
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|23010399003|376014|366016|7416014|6133799003|22082099003|18002099003|3023799007|56012099006|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info-Original:
 mf8FDtE7zF5VtL8TB6KqBzUfZthY3XY+DmD2B6RXAAkfkUYc75Wx8EI/IzUaWkoMO/7jSAgQ5IWPO7UkUgKnFA6X9Fqxg30OJUyrwn9FYH9pOFkjeUuysdlzIL4tyBuJqsuqJdBiT3aSP8oabWmoAcOFSbpw7zMGjSynMsWNZ5Rkhc2B+ky+jvXyyy1fStfbYNqReW1NITmeGQJpQbw/3rnVbPRXwgrBHj3XDnDOzxVs6ybMbdv1SxooNyhjUqXoAP/f9J/ob2WI+Emh0UZUakzJaEAZQCWwnmMEbEimnzKm7GXJfHPbwBotghom4TXbHpBheh9Oj3x+CldecGEogaiJT+zI8XbO+VDA6GHFBRKW0B8vC5hhVCcDiVVXMZBr+YAffzdVLogP/ZJ7G0Iu9bZ0awlsWiVr9mh1XpEHxNMx/+XrT6f01QvzgRlq6FbTzRh9Xe1FYeXguft7z/F3/lc+XsDCLiR+Cv/185Cr6WQOVTDjhBxoqKPHe39mNpwKyo+ituGQQ16fmMpIO/L/Uyk5x93+TcZ8qMmU6YN78KlVa5dihfWkv3/VdX9QnJ3farC1MwNUPfcXY0r2Ul/Nbn5v6Y9X2+JHwMeNCphbF3Yxpeb5s0ww15ZwPV3Nlfq2p0fkISXgHmIbRzNG/dioF8K/49RGq/Z7TIo+RN//fZU=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9203.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(366016)(7416014)(6133799003)(22082099003)(18002099003)(3023799007)(56012099006)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 JO+QVCSTTNpmEy/uLNROh8/DHREnjMALPqRAYLNRR61CJhL6BPd/NlMdi9ecCSAJV8+9eSz2aMKV1q/86fdE/utfY2ORwby1cwwJXRVy8qrmns0DfZFmk00iJn5ZYExZL4hfFdROQozEykT8unr6KW8OY5EJ1ThXWnC1o0ahZSFmLt1zPnBTVWqW0v2ahoFbCXVGJ9QD6GNpIjikpdzxxXjTaPTyWXY/81uAch5fxiZOtbJx+KgBxl9fIDDmf0xZZVDvLzcC+X72wam5AVakhorypsjJdPgoBptGi74jQ1xZiv08XMlrv9mbV2Pl8K6mADiJIxUDYy55CiEtJEcJTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB5456
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF000001A6.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	aedf5e57-4283-4676-4905-08defdeacb38
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|7416014|376014|23010399003|1800799024|35042699022|14060799003|6133799003|3023799007|56012099006|10067099003|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	hYGUtAyCJfY9qLTU6Wx135sBcrrrLDtnbMsHc0t+7+CVsz5aP13bRNebZr17exhKSkU8TEA065lHMZC10OYb0EbLpRJtKPyfmPCobfPVGblKJAm8YWJDrYrOIlhpgEozlvUsydP25fYKw2GibDqlrGOcllzsP6Uj6hKNpFked35LGAbRTtsdXFxw2BQn1xA/Z8v2G+Herg30yL5HrpMJEauRoqRPAfTFDdF9w9PL4q206HvXZOQNFpagSPtYr60PWtQOET6Y4lytY4q/M8Ade0enBOkcSDlA09cFqCHBQax6X6fmgX782cLbZcbRiYfA8V0ZygIp9vpXaDHL+wkjkmeJP062iPC51um7ltSdyFNam4TZkK9fL4DJ81MDAxV5DMcoZlRsHwf+bWwfH2toSNucx+jtRIAM+07bhPcLv95S9DRBACTglmZyqgLnGovHr3fdxu4z+71Ky9YrSBCQgH2AH8tfwV265BppQ+Q8OvQfUa9CwmnSuVWuoaBlh5mDrH5EDyo5ezoKf9Rvv9q9wGK0i+rWEAzsG6RudnQExRXpzjNe5V1bHy/owPUcwxBPPLpWxYn3Qq9Zt9EcNS+Z/uIJe6mYqXm2RRfX6eIzX5VelI6RtPBrSHIP5JxDFy53ndEb0K7YMzmCbilvmRCqAoBeIM3MEVtGcWbsln6fEkcd6lzFGNnKhsWMkiFTcqZBM6CaAVXGy7VsumRctCNnxA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(7416014)(376014)(23010399003)(1800799024)(35042699022)(14060799003)(6133799003)(3023799007)(56012099006)(10067099003)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	VyGpl/tkO/9ZuM7i5CB7fhVAFDBhBG2Uo3RoxKIjubpVS78YlSBamI9a9FZrXD5nQjY+Oj6uNZ1Cs6QtZVx0tZ72/vGSxIeETjf9liBB2ZW5zZWYyQsm+dQPPjbxSjZgWErgEZNUG+FEF+BktfJS329RhArt6NuU9qye41upEcqozV5g5kUeHoOJziPZUF87DcPNtHswzmI1USb3zzpHoc4CwhOW6ixpMyMKeZGBuWrzYGwd9vNUQH1ZZKEBiF8hT8xT89wd0Q1CoIiif+XS9/U/ukDL8zkaB0PKA7azND3TA4xQWPwsLmMeNKp245zTP7dvlhJ8wfhQph5XvgXw4uuQbJj5nMcL+gx55XAnzjCdXA6Htp+cRYzqjg1uB/nTTYR7T7idtgMFLHLh424aXc1EUSf/qzF0eS8O5ZU5xB5Q9oea2d83hnHagt4MK9tj
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2026 12:10:33.9385
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a3cd623-4878-41c8-558d-08defdeadf18
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001A6.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR08MB7572
X-Rspamd-Queue-Id: 0539620006
X-Rspam-User: 
X-Stat-Signature: 7sbsfb5yidqdcfbybwb1giq65f8uoj1x
X-Rspamd-Server: rspam06
X-HE-Tag: 1787141440-57067
X-HE-Meta: U2FsdGVkX1/p3qiCeXqK+GIQqCTypJDm9QbnCP+LQDwjy73PY1EcvQVvG8rU4kYWKmiBuAghkfR8WxDIIu3qPIZ9V0VxF0TNNanR/jC1EyNi1gh1QFc1XefO3NCZeZ+1D0AJVyGeIY3Qn9pSuRYOeMyA+1tTeIBYlnCDApzPOwvfEZFi5QcqXVf2urnz1CqW5pmyu0VlZhnOp/yoqIJE8L9ZpJEZx7MdQ83deySx1q85bGKRb/jHcOTfsIMb9C4lDNIAzIg3zTubSfJJLFQkhtE8WVfI+ANm4wNudGJ5EKsGDWWfLPjNbxKI/NynDEuLSkHzj/jx5r7BUGIQOX4m81r6BV7kJY/YTsF5c7WE0kZV6UnvH3Ja4Hu5LDt6QNH9rFT/yb/BDM5dJWwTFcUZ/uCvze2JltdDIsUSV/z/wzH7Xpk0i3wSJPsj7xe9shmkHIgSeQ080EMsUwEFKj4sY9/xD2V4GQQXD2UNM/3bOasAI+qTaiQ3VqcWCb3AjTvR4xcNnVmgF8nkVsFdjnzmo5qV+dxrR4ns8vxTYaVKjReArgOPqHbTb9UyVUcDKDRcGasjSmt9i8md1NdO3K/MPJenrbcvcaMyCxVLm5/DTaDkdMS9htiftov9ZDGAhW0BO/X4CcBKMFwqHRh/uV5OtkD9b3DQuGnzKgHMs50wfayBu+fyvV5eu1EimZAkuIJWdhRyiZs4mJnx8kXdWFdpGZ4pubGLguZWJQwmx7DR4MCKXIHvE2+qaGtb5VraZ8JdhsebMqUoYSHQUW+tNbX/XwEyVoEqDqmGehNOgnCTVFeUrVpzUgAJYIbrnrF6sV9Mg1e6QcMvqmE0KdbMATi8IlllZwujaHm2s1YWSnkJS9fF+TRlYCrJMnpVpEoaFPqXZvzMdaYnii7ZzRjLyNzYnbw1f8lnHr8nqBuCqgkK7r6ktOwuaKv99FUqYvUUUg4uCByWp6rCQqaegKTYKTH
 hK55uUea
 kpAS3EL9ZJWNkr2hayoEXiNiS+h/DgrtF3cM1uQ+ID7A0BAun6DkLj4GdiLcC2e/E3ZQFHLBqZ31GmDlnydN0LLlYR+7dSptey756XCuST7a/pRNFPcXDMO1T8PXqvj+hLN6BW5jXDyN0w2Ck5kdXqq9AH8ETazXKrBgvSDfpErqCbNimHQgzBVBvdqitc/yWcyIHUiAzd30XEI8ScOtZNxGmKY/O3IzRu0OO34OPROY08RokRAIZRytNKQXTC6LASlT+m9BrOc3LJmY5KTPSooo1/9dAQPfc7Ss9Lq4uXRM2pjH2hCnSA6oaOyLbMJaQJwbr5cAuJMvL2dswPBU671w4YuP3EP5i3ZX519NY9zVcAsAJ4xCmMfN5evRFyRZxny+FyuhdiySw/RYA7cGS67mcrKIBE1kL0iZgwA2elfe0LRY2/4otzoD/kT/5v3We01rb/9DlbWm647iG8+RBN6ilcypf+tAC61ssDyPutXUNNwJrBSMTI9G66w8jV8K4MB+CsK9zATpX+0JajzYdoqSmWFjwuP4X0RjCT7PkeFz09DY009Gy/RT6UwbJd9JCrIlADw1NBx0FepI7TgiC0uD3DS9IG1ODTPsy5+WiD5xI1QW5qcljdM9nFOsbcBQ8ydIr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/19/26 2:06 PM, Hemanth Selam wrote:
> The cgroup tests announce their plan before checking whether cgroup v2 is
> available, so on a host without it they promise a number of results and
> then skip out after the first one:
> 
> 	TAP version 13
> 	1..3
> 	ok 1 # SKIP cgroup v2 isn't mounted
> 	# Planned tests != run tests (3 != 1)
> 	# Totals: pass:0 fail:0 xfail:0 xpass:0 skip:1 error:0
> 
> ksft_exit_skip() can only emit a well formed "1..0 # SKIP" line while no
> plan has been printed, as the comment above it in kselftest.h points out.
> 
> Move ksft_set_plan() below the setup checks that can skip, so that a
> skipped run reports:
> 
> 	TAP version 13
> 	1..0 # SKIP cgroup v2 isn't mounted
> 
> Several of the tests skip more than once while setting up, for a missing
> or unwritable controller as well, so the plan goes after the last of
> them.  test_core joins its two setup paths at the post_v2_setup label and
> sets the plan there.
> 
> Reporting each planned test as skipped instead would keep the plan where
> it is, but the setup failures here mean the whole test cannot run rather
> than its individual cases being skipped, which is what "1..0 # SKIP" is
> for.
> 
> Fixes: 1dc830ee4c15 ("selftests/cgroup: conform test to KTAP format output")
> Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
> ---
LGTM, so:

Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>

