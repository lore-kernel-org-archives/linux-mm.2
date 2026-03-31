Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A402109B48B
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 15:10:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C36A46B0095; Tue, 31 Mar 2026 11:10:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE7326B0098; Tue, 31 Mar 2026 11:10:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAF1B6B0099; Tue, 31 Mar 2026 11:10:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 921396B0095
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 11:10:34 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 434541401FF
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 15:10:34 +0000 (UTC)
X-FDA: 84606694788.29.A842E42
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011039.outbound.protection.outlook.com [52.101.70.39])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4C8E880016
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 15:10:30 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=VOeNwbe4;
	dkim=pass header.d=arm.com header.s=selector1 header.b=VOeNwbe4;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf02.hostedemail.com: domain of Usama.Anjum@arm.com designates 52.101.70.39 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774969830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0SerzFjBC9DhwxwhWrJeyY/JNvdW9RS+zY438Xc1Af8=;
	b=jKvRtcLvNOH1eLDZ9F6Fcof0M8Ctm8FWLNlw0JeTNInqxsYabDJvV1h3FdxhK8DkiWiJgX
	3ZN4MCLpC+eUAYTRSpwuf+lJsigtGE4jAGU3HDLbuSbjyxgsN+1LAZkgK0QL/MB6fL4CiA
	/88jvrXJ1eWaIkaDg5ui1/T5YO044sA=
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1774969830; a=rsa-sha256;
	cv=pass;
	b=aHvCImmeV1qHNlurrL01YMAmCjA0iMfx5aYfmlVdRxWCWMmGg4/Uoile1ozNqeEHj6V8XD
	pWgcWSTMcyqe1bXX+rrBOzVY7vEQzAQXyDnWk9gsahv9k4KfuzUplVQaSB75rbigEOQHuh
	kv1O7T84NW0fOV+0R3VBxv1o6MD6vic=
ARC-Authentication-Results: i=3;
	imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=VOeNwbe4;
	dkim=pass header.d=arm.com header.s=selector1 header.b=VOeNwbe4;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf02.hostedemail.com: domain of Usama.Anjum@arm.com designates 52.101.70.39 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=ubry0BpyLqIJKDc/oGLxaSBYK9IxdqTnH8coppNVF731TkfzHs3mcYdAjOur54t6vyhDzZNl+FkfkBczEEKSf3uRbpJw78TjFti1wb1S4ehlrB4W/wwNH15hg4Wy4REQ3npRBxKedclQhQfvEQrDN+O2cCKdP5vdlh6DarTfwNebaNasHv32dmrMntKkupPppuqxFVgOxeAxk52fELYMKr5SUkCKhGJ/Y5xohqGeK8tKJ0i+hNFRj0gypRC0ZjCI8nTOs7cIItzXwKg/a4KCgirW2vwv6X8S3f8EeWqEv7FGE9NqBsE6oyuZog+p4JH28eBUr/bxbTk4YiGuhqX0Xw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0SerzFjBC9DhwxwhWrJeyY/JNvdW9RS+zY438Xc1Af8=;
 b=C12oVUZPaHiDpT/6sMTJvbry1v9johXRKNDZ93ynmpbPdW1UCkST+G24lboc2SBvPg1n2rvw0dT+x5Ca7wN9Cbk85YHs9lNdRulF3+Stbqhth4OOandl4TnChxkntEjhovz65Svj0loXPLUOILw+wj+R3fSe/YI65e6LwiFf3muKsPYy4LdKbdS6iVvfJ1hS1YEN/bh/qDxREIckClJN+fXXiHFKiwpA00W8xDzj3H461uA+0df1rTz5blA3xA34o7JoR6jAj+841ycWk78rGWFtX+jpDi6n7iSBOxutFWjdXmArcltV8fmFbWkxgLJznpcEOqTpeuqtvPtAap9IsQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0SerzFjBC9DhwxwhWrJeyY/JNvdW9RS+zY438Xc1Af8=;
 b=VOeNwbe4iABiANf+jxMCMmbZdu40PrzC2G7dDibQTzVY1QiTPOW1ontOQqGb4lnQHgtaE9iyAPw/f61NVha9J9fIgmk1FU65BazTZk8hrnJvXuJhpEJkzXAm+qJ49dI/tsBxtKfGLcbPgwsSkAKOxlG1Qb2s8Lb1fjKVGdaRYkc=
Received: from CWLP123CA0041.GBRP123.PROD.OUTLOOK.COM (2603:10a6:401:58::29)
 by DU2PR08MB9964.eurprd08.prod.outlook.com (2603:10a6:10:499::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.15; Tue, 31 Mar
 2026 15:10:24 +0000
Received: from AM2PEPF0001C717.eurprd05.prod.outlook.com
 (2603:10a6:401:58:cafe::7) by CWLP123CA0041.outlook.office365.com
 (2603:10a6:401:58::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9745.28 via Frontend Transport; Tue,
 31 Mar 2026 15:10:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM2PEPF0001C717.mail.protection.outlook.com (10.167.16.187) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9745.21
 via Frontend Transport; Tue, 31 Mar 2026 15:10:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xOH/20mezBgbnbUWnhoKjPMFYwl+XbP1wyf4qobAtCrylkZgxcL3z3SsMlfkdcNK787WPy4idN3XZFPIBpQip7M8RJAYkaV1LC1jFTHvORhgPe+tuIoWi3h6DYqcc/Vc6MWkABeif024fIWtWCYGjRoZOt7qdzUeuCTzjVxUUby2fwg8hdXKGwZxDrCDIcQw+h7OSREGHU4s+D8tgrKFrYKaaff2T2QK4Bf0B32w3nun3eFYbVsR1SwY9Yyfj/3kU7rE84KR6jQvOFJuIDZYkjInssNyEmXJxtBJ0lJZtjoSWL4bCWJTqV73LDUEP8Tc/4MbKYGyhY9HLsYKDizSrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0SerzFjBC9DhwxwhWrJeyY/JNvdW9RS+zY438Xc1Af8=;
 b=bXfhVbQ1Z9wT7riyNJAjKkVc5fklWBSQcipIy00qWNWUqEvciQy3jWE0sWaXa2C9oGigXuAgwgrPKjnUd7Q6iNzRGrgIn7LZOcDsr/K7aEbWRl7ZRDbUTffLJIOlPLeNe8n97tNhi7qRaVl+ll+VQyf7GR09MChyUXYnAo3O3YG+yMYjWeKnQhQ0Mvz/w9IDRiIG9CLoECVfaAi0VrktE0RfXMvpwfpLTuKi0Hdpw1FmV8IhsJOW7wQmkm7qLvsYaOc/1Hh1mns0Ooa5FVH2WUGD510kKwHvCKSUvah4BgSMKKYMB+W5uF8qis78FltMek5GEvf+UMSl3pphBqHKMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0SerzFjBC9DhwxwhWrJeyY/JNvdW9RS+zY438Xc1Af8=;
 b=VOeNwbe4iABiANf+jxMCMmbZdu40PrzC2G7dDibQTzVY1QiTPOW1ontOQqGb4lnQHgtaE9iyAPw/f61NVha9J9fIgmk1FU65BazTZk8hrnJvXuJhpEJkzXAm+qJ49dI/tsBxtKfGLcbPgwsSkAKOxlG1Qb2s8Lb1fjKVGdaRYkc=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com (2603:10a6:803:80::16)
 by GV1PR08MB10402.eurprd08.prod.outlook.com (2603:10a6:150:15d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.28; Tue, 31 Mar
 2026 15:09:20 +0000
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4]) by VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4%4]) with mapi id 15.20.9745.019; Tue, 31 Mar 2026
 15:09:20 +0000
Message-ID: <e02d66ae-24c8-428a-af23-91314e5dd22d@arm.com>
Date: Tue, 31 Mar 2026 16:09:18 +0100
User-Agent: Mozilla Thunderbird
Cc: usama.anjum@arm.com
Subject: Re: [PATCH v4 2/3] vmalloc: Optimize vfree
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Uladzislau Rezki <urezki@gmail.com>, Nick Terrell <terrelln@fb.com>,
 David Sterba <dsterba@suse.com>, Vishal Moola <vishal.moola@gmail.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
 Ryan.Roberts@arm.com, david.hildenbrand@arm.com
References: <20260327125720.2270651-1-usama.anjum@arm.com>
 <20260327125720.2270651-3-usama.anjum@arm.com>
 <0039fdb2-b23d-4ada-8d83-595e7816521a@kernel.org>
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Content-Language: en-US
In-Reply-To: <0039fdb2-b23d-4ada-8d83-595e7816521a@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PA7P264CA0217.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:374::18) To VI1PR08MB3421.eurprd08.prod.outlook.com
 (2603:10a6:803:80::16)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	VI1PR08MB3421:EE_|GV1PR08MB10402:EE_|AM2PEPF0001C717:EE_|DU2PR08MB9964:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e20b60c-460a-4fff-2f7f-08de8f37a292
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|7416014|366016|1800799024|56012099003|18002099003|22082099003|921020;
X-Microsoft-Antispam-Message-Info-Original:
 8H/8C/ddCICoEgId6xozFUh0Vj3L4JkEvXSI1SdQjkX5aRJB3QjF0bLLbjKHCDUb8fIuXdcl6NlxkwxbygayvoXn6ZHMiiNB+SytNqsfTrIxzvNYaY5pO/BBX9+DsWJxdmEOd0fCghTQXFen+veXOevAXSkYJOl1FHPEfUmfnkoEN0LUq3FaansLVWLi1vBTX4DEm8beeRJODFYLT29Yi1VMCrmTX3RJbaD30mNvVpeU5IQO1w407k7KWCJiwEaxqg5giCJMHoWDgFnMbHHHuuzkh/3qm1iWS+6wrmxxSlH/otRJE0OJwFaNK84rDZi3TLUv1MsudGY2HgJHXsFYkH+dUcEf4ymlyzzLy1N7ZqVNMPrraZ0OjskG/sWimjwtwyKm9zEyTtvF6Dd1nGa1cqMEgRU37NCuTpMnaQqYqIzSiTHalnXvsJi/O+QJrZ9nemg8Cm+/pq7c341shXLk0xFhUZW5ux06qY+JlXbyZWhiJy69v/Z4PYhS9UcCxwps4BhhLAhp3FfHbbL+fbuODXjP62j8y3ZTHqiVrx2FASnk2w/1jibl2lFIfVh4vHH7G/BXRTYuUJ6JRRAFNgZrZacwoSoghrqZtRZqOwJRiXuThhnz3lj5C1diCsmGW5+pyiE8iLPHRXquwNVCXbA74pZ6yIFk38+bkyAbQmFthGKUV4sgR3dP1A3oy+pcwWLQjFX/aqvkjG2ER2KQRsNcS8T9StjRCj3HDuDImhJe3QI=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(56012099003)(18002099003)(22082099003)(921020);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 QLMrZgrjBPvACwLil6wXXNCbvx65cFYHFRisWsr4Cugl7c3FkKpcMFO0u/JSYQsgsExaWdMrlqwaljCNtvYEvArKgiX4FO6oSCgoRKvdk9yf95PPojaQ1bHkNu2Vjj4wLFwijmVwNyxlv0dbmUdhEVuV/phHquJvy15gSoU+RYhfwLom+N77kMBPXv4w3I3BXvUY9+DMFgSlJB7z1DTW7rtVoya51q328WnosQkp+SyMWzig8U6qlgla0C8uzs1GQPEc008wcQ6lubi00eBcfWxqK0vr9ALeOUXZn42YmkMB5ViEWBjFXVTelLob1Vg/z/OnFbxFCnRDvX0WjpB6zA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB10402
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM2PEPF0001C717.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	28d14534-c752-4dd6-6981-08de8f377be9
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|14060799003|7416014|35042699022|82310400026|1800799024|18002099003|56012099003|22082099003|921020;
X-Microsoft-Antispam-Message-Info:
	PpEMhwwE0kD2Owpm5Ee9whrml9czJFDSA5uc+z8jFnPda0fkGBdvKfwannm9qMXISIuSp+YwROTjKLmc/LfCj2MoMJGnt76PVI9dq5aBIvp42tGO0ViHbevqrmPxX/Gt5BN6UMcrLWuF535czuRBCSFdX0tDa5Gj/hGMhG+F14FbWBlsP1XwaDHkS8cOwoEznZ9bjmCiOcxRPF6s97dNskJ3M/HXKCyCr8+TpWx5a2sAnnKBp7fKxf/lYfpz2riW7i4uYRhPszYPfN5cVKKn9Q4B5eC12dkUwhgjG4rEfw12SilL+2eplsHlJv1eNKZdN9PRgcnm+HbHCuakwrreSl6/SPt/PGmMHiw6ZsG3i4d/p/lKB4ieZtRev7gLSm09aqRQqihnQ7MphdLm3LvuNa17c1CZwLIN+hwChDUf6yyEk3qO8vrJik+FDCcOrvV283Q4YYJFnH4bjMuCocwHIHVaZSQByQvro+By52EfVSs9EpV+Pf4RFGHEnChmrZj3GP9NCfWgtjLd5Ucuir4bWV7xPXyoocPy3CklRkno8pYpDR9psb4+JfcLgpgR5wrQdlaQEPliRJft6NAf2P78LVze56AAgXN92caZSswlZHqgBXHWQREWZA7Cmzlt6KXtab15wRWRaQtEKKkhXDLTJShjt/XSy1BmsMZmbn/wCfKnkWG1CtUzVoyaqeMOGmqBeH5a0b84XJHQ1Hr5I4DLsaxe+61Iwq/4UBRFbITjyT2C2y+XzRP8QE6ar9Iw0yoTOfCgb5VuEm3o8WciXAA3lg==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(376014)(14060799003)(7416014)(35042699022)(82310400026)(1800799024)(18002099003)(56012099003)(22082099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	BWk9L5cXqQL5zNwxvfNhvGH1dq+ApIlICeEtV/tuk4qcU1DeUs0hei87aoHTUY3wIKlAqR+jmMRx7z1fRNOPv5xrQ8h0aMaDYvC6+KQFozltQxwetj1FYyxny4wI0X6II+7nhE7pX4EQhUyayFHPqD3r+bf2CiptmT3UXDGaioZPFqDBQLJhUQprzTzbw7Px/dhRekUpkPk5aAFyxnLRbdgcJGs/jHsVRd12GDyt0r3KtjGedy6X16mC/PMM5YKqePlAsn9JSPaIj7Ubi1RI7ciVK72odIOOi9Q46ErIrU+brZdbcNz8ZL4e01kOWJRP2iYZXFOgYHU5MbE3a8ee2l04G1//Mkc6D7g1LOWE21M4N944QHjAKK/gGtS4ZSB+5vUT6gXonwGsd62oX8prOBqysMyMccRMdPmZPuWae7a4DBqDMBOjMh8UIvpp4fW/
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2026 15:10:24.5548
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e20b60c-460a-4fff-2f7f-08de8f37a292
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM2PEPF0001C717.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR08MB9964
X-Rspamd-Queue-Id: 4C8E880016
X-Stat-Signature: 644obqbgy7fazrgpc8fcprqqr685yzwz
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774969830-942980
X-HE-Meta: U2FsdGVkX19/CC+SSgbRr5fWXA7UFEUpZgVSzM7yJjVoNs+m5XaO4NCZDC1z2FoROhXpxgmP5Gekf2daihV+A5l/cqleeOf/k2n6AzlDPEZwvkBO7ffvvUj/Ms9YtH81cucB4VSuZ9LISS9hMxAVqB3d+CbZcz8IUtXwEw0R+XjKDB+WBHynu4T1bQCxmqYjj+SPiGEBjPkdV3Ns7gO2s2/Pa3sCQY6cS4oFTrzZ/AHPAtpkzV1FHfghNRlWkuhRtZCkGTHFN8uyG9DLD6A1BX17aDJTJxqh57yzrCHQn+wSFECRHV90cM5SFYiEJ9vi2Zh5TLR7zjcJdwXUBVKjzdJtj5yTsvLOyXGdJVPOMN/0RzMZ+AGesISu+kFJn61NWnQABd9XAMrjPN0D6mpE7kPIuYT+Y21OeUixDyLuqOf/DFeP4L3/9DRU2jwvIUN79SOUFMCqBGbvMJekApmThpLPwp0oDYBC6q8Xbqcg86hzvjeWku9BH+sVrhCgm3JuePXdcjUl9ZuMTZFi+NlYzK62kqX5tpyNYdY+a0Omxj++6LucCB3GMEbJxaUowfaSfC7KieW8zVpE21NLBa0MnuUyEtIr+I/GFNtxAtWinzRyTUMaYAFafvxtnqfQC+Gdaru9J5ZK/DTIb0/layJDAYIoDAPWPr6X+DsSw61j1K9l77rI10W6m8Wzmwu7t5mnguc+ZzUij3YUq82BOv+TDIAy6VSLfo/BKJ28pmIBVQQiy6DSqImKG6DIbjOInJoM3Gdpf5Yn4Mem5rp+2qoy0UxORq2Vvs6zk0o2K37xll5oogg2F3RhiwvKEmDtd2JgHeL4ne2E1f9h4wMOcVVNTeWAeXXJHjft8+fFepM+3slQjPWvVl6hgBDtxSYXCE7Jva5JZ+MqjA280aUWCoom8IrHapEGXMUhED71DICrpV+T1OoMrWVb1SiDpIW4d7v09yZf1GF74ftJatD5rvI
 9gCVYVfd
 VPoONQ5fxmnXC6TUzgQqmeDu+/oKDsJAKV/CRXzcftfDHbXZLIHlidx+b1J5f9HwsuBjbawgFCCEBpR+a0XAODLagQDnmqdjerVrNv2B3C/evX9qXwQDLUcp4y6IRxs7QejJwfqNHNjRsd7CjnAuNbOXCgu/BCVpisQeFHeQwOuv/gsUwoTJceHFmNXc1LhnCqmyjcR0KiVBPczBzRrlBIUyTp3lzokyfDVyjEEoahNO7qgkfxzA10bJtkh81HymR58MOter7rVNyyPugq130lu2RG7nY/e6T/JKdX2COiycX2uunh/+qCgt57vJgv/96rUSYgX8JP32ExpDjdcDVUUlaWMSXYZAHpfaxAK9+GrrMYhIiSxBxbwuYqiyuw/h7ENJjKO8Um3oMpHz99aL4QhK2uN0/SqObmhxm7jiPaRL9RqPLqMYi6gkdpNCa/BGlkwv55WFgqfhIXOaDCfsjPDGwNephLzMS9DhC3I+9Mp3U0uiv32S5w+6G+CtToKfxHRq6WeXy+tZoco1mSsfpJJKew+xmPCP3l1PTay6kxbgeNifvvvc9TdMitbNXf+3YM+FvksL4ynBhQ4YBTNseBPE12wpC/8/fRTZK7vXqTyAI0KY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 30/03/2026 3:35 pm, Vlastimil Babka (SUSE) wrote:
> On 3/27/26 13:57, Muhammad Usama Anjum wrote:
>> From: Ryan Roberts <ryan.roberts@arm.com>
>>
>> Whenever vmalloc allocates high order pages (e.g. for a huge mapping) it
>> must immediately split_page() to order-0 so that it remains compatible
>> with users that want to access the underlying struct page.
>> Commit a06157804399 ("mm/vmalloc: request large order pages from buddy
>> allocator") recently made it much more likely for vmalloc to allocate
>> high order pages which are subsequently split to order-0.
>>
>> Unfortunately this had the side effect of causing performance
>> regressions for tight vmalloc/vfree loops (e.g. test_vmalloc.ko
>> benchmarks). See Closes: tag. This happens because the high order pages
>> must be gotten from the buddy but then because they are split to
>> order-0, when they are freed they are freed to the order-0 pcp.
>> Previously allocation was for order-0 pages so they were recycled from
>> the pcp.
>>
>> It would be preferable if when vmalloc allocates an (e.g.) order-3 page
>> that it also frees that order-3 page to the order-3 pcp, then the
>> regression could be removed.
>>
>> So let's do exactly that; update stats separately first as coalescing is
>> hard to do correctly without complexity. Use free_pages_bulk() which uses
>> the new __free_contig_range() API to batch-free contiguous ranges of pfns.
>> This not only removes the regression, but significantly improves
>> performance of vfree beyond the baseline.
>>
>> A selection of test_vmalloc benchmarks running on arm64 server class
>> system. mm-new is the baseline. Commit a06157804399 ("mm/vmalloc: request
>> large order pages from buddy allocator") was added in v6.19-rc1 where we
>> see regressions. Then with this change performance is much better. (>0
>> is faster, <0 is slower, (R)/(I) = statistically significant
>> Regression/Improvement):
>>
>> +-----------------+----------------------------------------------------------+-------------------+--------------------+
>> | Benchmark       | Result Class                                             |   mm-new          |  this series       |
>> +=================+==========================================================+===================+====================+
>> | micromm/vmalloc | fix_align_alloc_test: p:1, h:0, l:500000 (usec)          |        1331843.33 |         (I) 67.17% |
>> |                 | fix_size_alloc_test: p:1, h:0, l:500000 (usec)           |         415907.33 |             -5.14% |
>> |                 | fix_size_alloc_test: p:4, h:0, l:500000 (usec)           |         755448.00 |         (I) 53.55% |
>> |                 | fix_size_alloc_test: p:16, h:0, l:500000 (usec)          |        1591331.33 |         (I) 57.26% |
>> |                 | fix_size_alloc_test: p:16, h:1, l:500000 (usec)          |        1594345.67 |         (I) 68.46% |
>> |                 | fix_size_alloc_test: p:64, h:0, l:100000 (usec)          |        1071826.00 |         (I) 79.27% |
>> |                 | fix_size_alloc_test: p:64, h:1, l:100000 (usec)          |        1018385.00 |         (I) 84.17% |
>> |                 | fix_size_alloc_test: p:256, h:0, l:100000 (usec)         |        3970899.67 |         (I) 77.01% |
>> |                 | fix_size_alloc_test: p:256, h:1, l:100000 (usec)         |        3821788.67 |         (I) 89.44% |
>> |                 | fix_size_alloc_test: p:512, h:0, l:100000 (usec)         |        7795968.00 |         (I) 82.67% |
>> |                 | fix_size_alloc_test: p:512, h:1, l:100000 (usec)         |        6530169.67 |        (I) 118.09% |
>> |                 | full_fit_alloc_test: p:1, h:0, l:500000 (usec)           |         626808.33 |             -0.98% |
>> |                 | kvfree_rcu_1_arg_vmalloc_test: p:1, h:0, l:500000 (usec) |         532145.67 |             -1.68% |
>> |                 | kvfree_rcu_2_arg_vmalloc_test: p:1, h:0, l:500000 (usec) |         537032.67 |             -0.96% |
>> |                 | long_busy_list_alloc_test: p:1, h:0, l:500000 (usec)     |        8805069.00 |         (I) 74.58% |
>> |                 | pcpu_alloc_test: p:1, h:0, l:500000 (usec)               |         500824.67 |              4.35% |
>> |                 | random_size_align_alloc_test: p:1, h:0, l:500000 (usec)  |        1637554.67 |         (I) 76.99% |
>> |                 | random_size_alloc_test: p:1, h:0, l:500000 (usec)        |        4556288.67 |         (I) 72.23% |
>> |                 | vm_map_ram_test: p:1, h:0, l:500000 (usec)               |         107371.00 |             -0.70% |
>> +-----------------+----------------------------------------------------------+-------------------+--------------------+
>>
>> Fixes: a06157804399 ("mm/vmalloc: request large order pages from buddy allocator")
>> Closes: https://lore.kernel.org/all/66919a28-bc81-49c9-b68f-dd7c73395a0d@arm.com/
>> Acked-by: Zi Yan <ziy@nvidia.com>
>> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
>> Co-developed-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> 
> Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Thank you. But as the implementation of free_pages_bulk() has
changed to using num_pages_contiguous(), I cannot take this tag.
Please review the next version again.

> 
> 

-- 
---
Thanks,
Usama


