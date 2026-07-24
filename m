Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34D07C531FA
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 11:17:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04FAF6B008A; Fri, 24 Jul 2026 07:17:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 026BD6B0092; Fri, 24 Jul 2026 07:17:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E579E6B0096; Fri, 24 Jul 2026 07:17:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B1D5C6B008A
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 07:17:32 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3AD57A10CE
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 11:17:32 +0000 (UTC)
X-FDA: 85023419544.12.DE24BE9
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011002.outbound.protection.outlook.com [40.107.130.2])
	by imf15.hostedemail.com (Postfix) with ESMTP id 2DE42A0003
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 11:17:28 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=Q04Gx3+e;
	dkim=pass header.d=arm.com header.s=selector1 header.b=Q04Gx3+e;
	spf=pass (imf15.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 40.107.130.2 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784891848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IuNwIghXJXw3l1s4UmLbWYMiggtHCxyDY+Rg06IbXUU=;
	b=yhZjXehaUrOh2jS3n8iir1zBw0D2M0FdX+nj+piNJSPIGpFBxpGhinCVpiTW3x9YWn312P
	BTwN4QXp4qjDRGEfHE3VuhiPpXS4hEZ0VLeddrXLlq/JgzXBQHFh3O/pi91dKItLHm9Qi5
	I4tRgHJ7OMbFGhciVh7ndY/4QDURYkg=
ARC-Seal: i=3; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784891848;
	b=7+F59COE1Ya+2Go2GXiljZM5ZfUpKo6NmmPSET8BGguCnnRbCCuARXlE6FekdmDj4J9Wh9
	XoSXRTkqwN9hvEtl6sE4GTx4u6KiEfathU/jvvUpKTdXf6UrblRAhYnUBaRgKT30E7Od8h
	aA+niOfrZ3IfQ/IjOPWG9AjtmwnNWn8=
ARC-Authentication-Results: i=3;
	imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=Q04Gx3+e;
	dkim=pass header.d=arm.com header.s=selector1 header.b=Q04Gx3+e;
	spf=pass (imf15.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 40.107.130.2 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=ea/2A5gHtjSRUkadQR63v2R28xohEcuPSoP5CFmF5WVHla3yH7PRNuwg/5RksxlJliuerE0sRi4UEWGYYgZFxl7VcjdXz2ZMqJul02LIuErFOcpW1UA1BVVGkYUatuylnKN+k+VgJzQ1kZyDghhH0WYZLyIlkiuz0IKreuEeU/Xgmge2DMKDDfu6650tZFDrYp5ngD+sLGxyj63XQdN888wg4wzxP5Yx3/5Uw+gkdK8UX0p/SLax92KRw2AldDaOxY0DyAAhRocnbvLwPLs2JVMaOHfYkgIaxHikAyrsl9OdBD4EQTY3ISFzuWDXvSjdcL3ju2YqaJZRThu1WFjbww==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IuNwIghXJXw3l1s4UmLbWYMiggtHCxyDY+Rg06IbXUU=;
 b=v1Gphlv/f7sSnAEj8aCa7wHPwBjkl/QDp6Y+/VthzB4Mchc5UMjMIpfHJs4NL1EstFzbcD8kPLqEpVLawJiB2G6z3eEQOCxFnJ4wE3kx3yAQZ5VfRRj1C3IrepgQe1iasLMkW+8d54QYDslPTv92UJrPU4u5vORqrEQI+8+tm6SyCIQKz6ZqLzl2vM4TWZR+db7m6HQq7iGLMqUVXmFhU0n3b+pmyjwLGMFsaqvYJpM4hOxlVCVR5mL5YuBrl/CV4uVIwd+hjxKTGOPPCM2ttUbWvNH44f+Yg8U4Gi3wWGxZG3u4VFNrYHOc+fIiH1mDnod5KSDj5wlaayz08YNl9w==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IuNwIghXJXw3l1s4UmLbWYMiggtHCxyDY+Rg06IbXUU=;
 b=Q04Gx3+ekNswhcXBGAaimvhakxsk2jkjTUcR1BMqZfSHNIKJiz8FexkuipoXabuzx33hwWXNWHBJb00w6uI+ZVxqTQFkr/kOkQ/kR7dJ9yJCHaobgfXyXfknYcP/jf+UIZFFCQPCrA0d0xJ8vQGpRcqz1n8jOtl0EXipNFGHaoI=
Received: from AM8P190CA0018.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:219::23)
 by GV4PR08MB11274.eurprd08.prod.outlook.com (2603:10a6:150:2ee::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Fri, 24 Jul
 2026 11:17:22 +0000
Received: from AM3PEPF0000A799.eurprd04.prod.outlook.com
 (2603:10a6:20b:219:cafe::9d) by AM8P190CA0018.outlook.office365.com
 (2603:10a6:20b:219::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.11 via Frontend Transport; Fri,
 24 Jul 2026 11:17:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF0000A799.mail.protection.outlook.com (10.167.16.104) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.5
 via Frontend Transport; Fri, 24 Jul 2026 11:17:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XpCA3x7/rtQtauSJRIcrlCk5ZAleQqrzOf49We19YG2N8/dSk1XPqFJ56JFp9LELCuro37hVB4nf4Z6iQ06VVgUHhkDs3WrAk7NMfMB4UIQ9IACPjgCZYp0Vv+b9ffTt9xTBimUyHhbAY+3W5EE80ugwVz3kfLv72h05p19L9vPXt7l0MfSqXDBy9ew2kzIKDFzfROGS6m4nZyC7bsJpQn53vrxgfFhLK8wy3NJ9SBKa0xPuOdE8MNb9YkqZy4FPL1RGzwT+6t+tPrB/3dbIinGZMAIB+EdVGlzAcU0g14e3dAD5PYWz92DVE9xyzj8zrnl0XyM6c7eN/h65J1jPLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IuNwIghXJXw3l1s4UmLbWYMiggtHCxyDY+Rg06IbXUU=;
 b=wf0igQwcZp6XVMJuWYQi+PXsW7kDbr+Lb8uO1TuXRmXLF1DV7HGVfdk4ohVqLEJSv0NBCsQluSOrthkIOpLU3+BOIC3xZ5JMOhAf4bF0tV2WyOsmLGnejem1EKBycsSpKppxTMPWP+vK5Zs4TeCEyGjXzK63r6fgWFaqv6yGslg7Swaix2hPhy2nVzhxkkSZu7V8EqzBai5RkQYPa6/akKeoEljleKUlXqBvpqbgMMe/hmQb50yIAi16qinIPhDFnJ4m1KruzTldrAXABd2U0H6bY92ZbsIIfZ0emMDg97xmRqzo0sg+bcOpr0PcUON7twem9QnhYbGQqfeTU7Mj2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IuNwIghXJXw3l1s4UmLbWYMiggtHCxyDY+Rg06IbXUU=;
 b=Q04Gx3+ekNswhcXBGAaimvhakxsk2jkjTUcR1BMqZfSHNIKJiz8FexkuipoXabuzx33hwWXNWHBJb00w6uI+ZVxqTQFkr/kOkQ/kR7dJ9yJCHaobgfXyXfknYcP/jf+UIZFFCQPCrA0d0xJ8vQGpRcqz1n8jOtl0EXipNFGHaoI=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com (2603:10a6:10:417::12)
 by AS2PR08MB9812.eurprd08.prod.outlook.com (2603:10a6:20b:603::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 11:16:19 +0000
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047]) by DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047%6]) with mapi id 15.21.0245.010; Fri, 24 Jul 2026
 11:16:19 +0000
Message-ID: <908a28d7-e62a-4bdd-bee9-be3f3053007f@arm.com>
Date: Fri, 24 Jul 2026 16:46:10 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/5] selftests/mm: skip khugepaged swap tests without
 swap
To: Muhammad Usama Anjum <usama.anjum@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260724102431.1199519-1-usama.anjum@arm.com>
 <20260724102431.1199519-4-usama.anjum@arm.com>
From: Sarthak Sharma <sarthak.sharma@arm.com>
Content-Language: en-US
In-Reply-To: <20260724102431.1199519-4-usama.anjum@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5P287CA0212.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:1ab::9) To DU0PR08MB9203.eurprd08.prod.outlook.com
 (2603:10a6:10:417::12)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU0PR08MB9203:EE_|AS2PR08MB9812:EE_|AM3PEPF0000A799:EE_|GV4PR08MB11274:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ebdb0ad-21fa-4bc2-4014-08dee97521af
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|7416014|23010399003|366016|1800799024|921020|6133799003|56012099006|11063799006|4143699003|10067099003|3023799007|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 Olpaq5xrk84sIjljE9YAnO4Daztuv+zoUUkl7MTGJGKNRixHpbMn/67smRLiPFHnOUXHGqD+31s4I8s+3hrp3PW7wylOGUnGLfDwBR9jrQUKwZFLaSBcUMrVDtLqRYNtJAwEMcE5Yv92zzh1z7dC9dPFP20RJYnkRyu+S6yuDjgOxKAdGcw96o7btHKk/0gqZEwiS+37+Ih+3HVP1KDOJCQOemimYc9dPXwDp/4dv5QVQn117tIKyERFnNoFAnMCeLaTX0ahpD5AN1S1heBSf6iwn24pFWys5so2QALYfwL2LnmdWI9nvoVKm1Fn3PG2vdOLvKaLMi2CNThncOsfz68y90SSo+l7IYnsIoPJJJHCjzNl5d2lHet7oIEFfGZZQCA0/kvGJcoNvtJo2XVTxgcHTf6fkj6BFVzxBXXSIHQPlX5V/hzC9+5wiqixj6R9qtQqZoGUKNv5tjMVypMZokg6XKF8WJ2HvSDWXMJf6gJECjasUHBVBljZH7tOr0V+MTcB9Y0gXCJLzoCLINodbvZfoH+Qlpi6eOXa4lKKew00jk8AGulV9DQ9fXPflyDfHIxGbPzSR7ssZE1vzhoBtONxtyrpMLfW7GGjpWq3rnYVYW+RDMs5XxNUDu723odNFC+4NMyTXJTLauVuFMtj+zKDtguWDYyMP9IsyissuBm9desq0LAS1M0plYirO1OD5C6wajonGl4VbycemqNBOg==
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9203.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(366016)(1800799024)(921020)(6133799003)(56012099006)(11063799006)(4143699003)(10067099003)(3023799007)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 KgsdTR2LNIGEM/LL9wTkGMvQ0RQbAl4/jDVHEtu9ERWq7dSCEOSUsVqplj/sDFfcm+BlvxZs2M3YNR2wift7zC6DffgI7dT2RQ8zopZMT+xFWW7VJbp5BfHI9Qri09fZb3Y0rh63D/WHcMfpnf4ECqAkaheJuwLe+vc2ZIeZnvWotFQNDLU+rMVB7Mv8gk3XsYjxIhYdxpTI3WYD2hDxxLoXnBXwJAr6RL+79uudOnniCVujRtzHlznnbtFyroK130VTyPMnmvbY9PoaNVE9Vp2WG2UiMR/Yxw07AOOFGYBCLSrt/rSS0KPYTaKiDuyQbW87L8eA4RcZRndUud730g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9812
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF0000A799.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	081b2be6-7723-4574-5589-08dee974fc35
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|82310400026|35042699022|36860700016|23010399003|7416014|376014|1800799024|921020|6133799003|18002099003|22082099003|3023799007|4143699003|56012099006|10067099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	N58bWzGls6K9+cCofrV4hSt+7FRmgcnvXXHBrO6/duOBAqNBw/HPdsLo/OyAXvDZC8TkUuQt614S1pHtu25JYRRlmXY15eWKK8eA7MkN/55gpzrWaDMqKDSyvNjYpSY2WcAwKQBZH+SCkVRe7z0dSULOjloTeEnu7GB7UdWqGsRim3z7gXY7a8YsVLJlDfogk0GEzD3MLdUyl6KZ7QZUq1y9yvO9iAvE1ma7G9Ses935Ha3Rrm9OFxVRIFcgc5V/eQvQ1zCxSU6fWpkXMSNLNDlqbvhthcl3L/31OUIuvUg53nPrE/tfxugOBdkyZawTzka/mjAARA9Y3r1EHnSecy9rUvqKSo8tAzbGfoYAAo0btWXNW3mg17T0q1borCeXkd7NZJsS/Ifya3kuyiINpOLDnTnqGMmIiy5DNMW3PCIlfPzA2y0OTsfUbGwwmKg1O+tYm2Ag9WpEvdqYznMbdNXflbHhCXv770HkECGkeAv/nTVzGWpHabrlGhRwF5Bk2NLJilmHPJ9vVdf/y33oj+MdwgQwik5APjUkZs1R7ZBEHEF1qru1mPdpGeG7kSnG3+OP0LyVCaKkVM4JTwfu26W/3mxIuQLMv9fuuEpMHd1D8ii4SZf2H20uBoWoGStMdUk9MDT5DSzI8RWHyWZ+VzrdeqX4gw+CFXD8FQxElufPkto8bqhIlo8g0bvrzOkFjchyt3Xa/A92hda14xMmfJkkwPCaS2jPdWHqCdpIs4VahoNWr2a1FV7Z/BEvn9hr
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(82310400026)(35042699022)(36860700016)(23010399003)(7416014)(376014)(1800799024)(921020)(6133799003)(18002099003)(22082099003)(3023799007)(4143699003)(56012099006)(10067099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	fo3h84iEJAmbT4ylzY8V2b6r0dw0Icj/bzbnAzCma6cVG1JV6COC0iqYVovz8hA4yGJik8u+BGTBxDXY02OI+MEEKsTQzjJiLhDcVFkKQGwjalUYWOofWMYI9CXeBZ4rkNgDUMWGKOG4NKgUGesVoOcHRXF6PQAwjuBTe1fky9pPfzQf3mjru6xqBJppO9igS2XkNJIYwcYhkzYiWOchW8maA4Ejj1iUoSQL3K7wi1p7vcdMsStxUzNTWvwR8IWfSfjNZNhbsUKWrDodHHeGdKTeszO6fV4QZGb8qTj2B7M+BKD/Nlh7tx7ncG5GRzm+9r3glz1ZOQrHuHUJMyZ1gbO0EaDsK+dHpQnnJBYXbe1vqo1D9XPB6AkycdiB8V9sVOVY3nSMQvr/VEaWhreERWjHn9ddMlcGuWyFvw99uemny6Bh595Tznjrn6VUkd5N
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2026 11:17:21.7872
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ebdb0ad-21fa-4bc2-4014-08dee97521af
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF0000A799.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV4PR08MB11274
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 2DE42A0003
X-Stat-Signature: p4x44omdgbsh7gyrmfdsob36ih5xohb1
X-Rspam-User: 
X-HE-Tag: 1784891848-549297
X-HE-Meta: U2FsdGVkX197rLVvcUl1EwDM6ICvbatdOldEXhIrGPEqZd9t/SR7LwU51VFaTWQU/pzaiYL32s4EOvmf1AD39FXa8lOuMvzApFWwi2/tBR+XymtlDCH/tk4hw7AaGXr5raHlftHYHjwazb0lxol5AMdjfsla7FkxLpYnP7wCNv8m9ThpmjExazkol3QSbmERIHzsdIaD0qEsQI5M7dw/sSovQst/BUZzlY/d6AKCYHoqy0qr/dRD52cPqpwAUjgVOQfb4FMvMjbPARqFq9ynqP+4ert73iBhkChInwLW/yEgkdCWnwK/XmJDoJeoUZe43ukIAJR9ZCeqBJfjOGcgISvmhpXx1MSasNgu1kJvCwTHih6lUU7PXfky3pmEfQGQ32jgg+H9MXNLeDAFzlwnph/J7Lwx62Omj8mUDxyE0AoniuKPT4rbLyBI50lvTCULlm6b1IH77LpQ6FLIS4yhz9h9Ozr7yq4m1bx/gSFipISlBWLToHAHVMSmRWGf9ukHIGCQds+mbeVx+TA5BYWvT/EyERx9MTPOIwog5QMix+YwA1ywmFK7BJHt/Nk0cghbnCXz4ve1IuU53vg681DKkbSFPJJI9Tfd+0PNrNqEwLmzN6oOnJaLXSUhtwitbLrqwwUw2HT+T1l9vTNFA+uglzrhByuKOzOwwAsANWcZYZnTV74KZoNO4g+mcqOEHU5LGnk2R+sdZdhH2AbWLK34S2taVvWe0kttdEZGGC6N385rn80Uav41KN/L5n0V1kFstPQWUgL8RqoM4IyrpXzIN0k/JuJ0l12VknQgbq9U/IC9BtbOukQisqgbJN4/bmfyekH8QUxmUb7ZyGk1baB+zO8LE5MTK/8VYohsVvK6NQLI6Oi5kORGa6kPNYmoU7SicT7D15KQfw6KerlqB23NOp8zN7QB1z/QTNbSiBn34+smx3ftWZUnqRP/jbsq7nwCnbS83LMX3b9Ppe9Njyn
 GkDiQsZA
 6FKL3eMrivw+h6MDdkTJJP9Es6FCgJlG7ELyNtWbjb7Y1drn5SUIt9ptMIkxZzdRZnmYY69mABnwIHXrWZ8RLzGNyx8kTtONXAMkS1iclxvqmzaIQhE5h+loHOfQBOIdu0Vd1UCp7Iis9sEHPWcLnPyTC3WwdVEi5I9l1Fy/7ntE9wvNRaWBHZHNjrf8fx5fwTvhzZs0TxjmYQUZI8Qitp2qlY3hxxBAsXalUdn32KPhaxxT4m/54eyXKtdvWj5G+GaAwp6AcaJmVttDxc61ynl2gQImu8d1XtkmVFkjQJQPDRrfBK+yRcPk+wYxXKC4Wbd33ERbnIUPzef1Sf24uBl5tny6BgeTtS8vIo26K3xZrUUVi8ynA/ZKCfp1ngAdgiyG7lMOvG+46m7j89aUUKLFpUDwwT7b8P6eiJls2oN+pgIUC7Ov9feJ/JObgQ+ExI1QsWpyVoSgl+p2q185b3IzzYrMylprFd0oNQoJCh7EOsgkNE+XkM2W66VqP9MD6pYXaZCoBY6QNPrKcARQcP6UBVKkEMTLs2WZtg0tgm7evHPzleN42NQD093m8bWGZ7W/5ea6hXOZVXYHT32z0w/Jc2PEaB9pihmMVpU4+tXhGqhU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Usama!

On 7/24/26 3:54 PM, Muhammad Usama Anjum wrote:
> collapse_swapin_single_pte and collapse_max_ptes_swap require
> MADV_PAGEOUT to replace anonymous pages with swap entries. On swapless
> systems there is no backing store with which to create those entries,
> so check_swap() reports missing setup rather than broken khugepaged
> behavior.
> 
> Swapless configurations are common on Android and other constrained
> test devices. Failing these cases obscures actionable results from the
> rest of the khugepaged suite.
> 
> Check /proc/swaps before either swap-dependent case and skip when no
> active swap area exists. With swap present, retain the existing
> MADV_PAGEOUT and swap-entry assertions unchanged.
> 
> Print each existing swapout diagnostic before the prerequisite check
> so skip() completes a KTAP diagnostic line instead of emitting an
> unprefixed message.
> 
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> ---
> Changes since v1:
> - Print swapout diagnostics before reporting no-swap skips.

Thank you for the changes. The test output is now KTAP formatted as:

# Run test: collapse_swapin_single_pte (khugepaged:anon)
# Swapout one page... No active swap
ok 16 # SKIP collapse_swapin_single_pte
#
# Run test: collapse_swapin_single_pte (madvise:anon)
# Swapout one page... No active swap
ok 17 # SKIP collapse_swapin_single_pte
#
# Run test: collapse_max_ptes_swap (khugepaged:anon)
# Swapout 65 of 512 pages... No active swap
ok 18 # SKIP collapse_max_ptes_swap
#
# Run test: collapse_max_ptes_swap (madvise:anon)
# Swapout 65 of 512 pages... No active swap
ok 19 # SKIP collapse_max_ptes_swap

Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>

