Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F101BC56207
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 14:59:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEF7A6B007B; Thu,  6 Aug 2026 10:59:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA0056B0088; Thu,  6 Aug 2026 10:59:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D91076B0095; Thu,  6 Aug 2026 10:59:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A7F9F6B007B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 10:59:29 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4CB151A071F
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 14:59:29 +0000 (UTC)
X-FDA: 85071153258.02.3AAF02E
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011044.outbound.protection.outlook.com [52.101.62.44])
	by imf29.hostedemail.com (Postfix) with ESMTP id 800A5120004
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 14:59:26 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=cS3z07B8;
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.44 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786028366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kyr9pLOyK4zXSkH7Qs7IyKYoKJBS3ZXpjfw7P/mPhjI=;
	b=fITfsEwbTysAMoVLLnoq1P1nm+f9xXA+zwgDgyfxICaIA5EMrSzM84uy07Ihgmh0Mm5hQE
	++3vm1A3kwO5XAlof+dWNs3HaAY54FlwxxRf6fBS0VrwJsxWotex6sNGsMFe5cqd9+oQqc
	b4RM4wfYp//4wHBnP5Pye7rwpIjSQ4I=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786028366;
	b=Igzzm3kFbPKV7BnN0WfyDZQglrJ856h949nHZ+Xt/jeZi+GKyOT/d+SoVzLSmzLi7j7BTn
	Fa/A+65/ZJHb9qVd1ncYzdiLUrgcNomuYzjkyrPCzPmGrrfmnY9GaODFxntgDtFZALQqdj
	grwM2b7a9ShKc08gAEWqafE8WsfoCJ8=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=cS3z07B8;
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.44 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w8SdX3QLxzqPA2PW/B3BwBjQ/SDVXgOgr+SwcJmjoHDKJ6n4wyDfrfHarj3y4lpotWi56FJPW31RaQ/wLZ5oNvhpAubcsRC2W0+7E5mTqtAa4oQMxrqTkpN5zV3mGj+h+Zr0T8gWvQXgld/DLSurM5aifTqTAdmjouIy+HlR91E7PoNf0PHlvvVL5HyyFuCZ6HEYtQ9VJGfdxR00Qyw14ITsdAkfeqOv3c9Nou6wZF/0BqcQ/oL/51SWW1SEz3V7BWa0hm3ZFYFe5J9doLiOhOo3Ag0YTPtE0CvGdQsY4euoFw29mnjovsOTCwXOkepnhSELByzGHim/iz+qrhSqrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kyr9pLOyK4zXSkH7Qs7IyKYoKJBS3ZXpjfw7P/mPhjI=;
 b=OOzY8jz8r4aPiv3tjp1U7Zl/aZIkQvqrFVBptk7ATWktwMw/xmCFK1xjZhd/cXzzcahr08WkDsXtcgWc/whCclaqsHRnNAmj9XCUCBm7MkaSEMB2+pNeVrETx6pfKAo2Gc8Y5FllKp4Ds/dmherY/EQeoPPcMDj06X6sW4Dx4iCPsIOsfx0Sw02xPrzdc50ZOwzIozhwHfBn9x6lJnDe33MdU+cFvGhorAhEyjG6J9UQPkpxgUhZHd53ygaPBZ4fprToqtpCoIGwpcfSrIw8xZqtNbOz6pf2OqmJUGZTIeeDehQiEQfNvwTGqGV7rs6+G+7I0WUFqrmJqGJicZGktA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kyr9pLOyK4zXSkH7Qs7IyKYoKJBS3ZXpjfw7P/mPhjI=;
 b=cS3z07B8hw4TXGf4I5y25Sw8YrhD+CDod1lkJ/87cDqFHKjFuBUPBYFlaqt5XeqhBIfjF4T+uSGTqaDD8oe1KZzfsn7OMXVcyhO5b8xnZmmyfxNMVSjmCkaDc6Z1+1C1cwhvPK1tEtMVtjWFAl1Nh3L7RR0m6QZovRSia9p1ExFhApuNmuqsYfM8SY18Z4mLItYgzBHuKAXHRJm7XF4KjCs+7JoYHsITLULuhpXz6UDKBQ/Ru+RHh4zsWFkziKrYVF6kWvZ6thaK7NHeuHxKBNbnjVP/HpJsCMDaVfzyXk+5Zjipl5tByNTZoonhSDadoNgXqerrBH42CagchUllog==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SA1PR12MB999084.namprd12.prod.outlook.com (2603:10b6:806:4a1::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.19; Thu, 6 Aug
 2026 14:59:22 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0292.018; Thu, 6 Aug 2026
 14:59:22 +0000
From: Zi Yan <ziy@nvidia.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, nico.pache@linux.dev, dev.jain@arm.com,
 ryan.roberts@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 usama.arif@linux.dev, kas@kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/4] selftests: mm: implement the mTHP-sized hugepage
 check helpers
Date: Thu, 06 Aug 2026 10:59:19 -0400
X-Mailer: MailMate (3.0r7024)
Message-ID: <495B82B6-C2F9-4C9D-84B1-B36DAC0587F7@nvidia.com>
In-Reply-To:
 <56b16691f605426b33b5cf47319233de6127a6b3.1785985999.git.baolin.wang@linux.alibaba.com>
References: <cover.1785985999.git.baolin.wang@linux.alibaba.com>
 <56b16691f605426b33b5cf47319233de6127a6b3.1785985999.git.baolin.wang@linux.alibaba.com>
Content-Type: text/plain
X-MS-Reactions: disallow
X-ClientProxiedBy: BN9PR03CA0140.namprd03.prod.outlook.com
 (2603:10b6:408:fe::25) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SA1PR12MB999084:EE_
X-MS-Office365-Filtering-Correlation-Id: cd82ea75-820f-4a77-061e-08def3cb4c73
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|6133799003|10067099003|11063799006|4143699003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	FK12yIA5bTJnfGJIWp/vHUXIQ6Krp40RfH4xV2URyV5e/dnSBNdrGSR/d8zByiFzlDlPhI+bhJTC+2cCZ01q1pa9xSyMaelktfBCMvPwHtvzo+jqySjxRER6WWSSwwLPdmFKRMnGhx2kbN7lIcLfQhYzZV8Ov13YyGUFBaFEh+UU/Kh9QLD0dBU+3ml2IWkYvwzc4q/EzBW9l720tQsF/s6ccIu5q2hkKsa67uTfh9zzG3enxgKiFZ6evvpOFLGk1IzJgWAJpGG+ku5DwZUK40VX8xD0PlZJeCMNW5GNP/V+PVBnqj4qV1BN7GWCnoag7YMZnogk1PmPJvbIB8QgC1S9So4ckcX0rHZm38ivt1vUHjzJlQtdRpquI/cVvfmEUEZPlssKIuL8hKhzQP4M+tWLKoWs7Of/xKpslsKudwX9aI+Dwtk+9e82gyIS5Poc4nb7UESs8Nok3CyfPuz/+WjgfIpno6sq7+5FGwvjqFKrT8djJN8+9X0xRaRGinZcWExo/ez+rvz5yORYkQ6t8ECfH2abt31v8UxNQWW1r728mvq4kSw+v/o6w5lh4mHR04W0r9kzAhJv/TqWsJvFqu+wBFtfeAKUwvfHRt+bVt4cOAxylawEsjEGpYZNHsN8w/AvdU7yfhWyQS0FfTfJn7dE2b9uUQJ5NJprPe+kq4k=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(6133799003)(10067099003)(11063799006)(4143699003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?w3SwiyOC9NR6RLaeVz//Hh6b6HK1pGl+KIRXJeWr6AXDI9zHal0zuY0kL2Dc?=
 =?us-ascii?Q?Lm3Y7xy5CHdBs+nIV/S70DClCC7UrYMfBB0RA+ahxdYZWrVKRyNZTvLmScCk?=
 =?us-ascii?Q?J4/XpfwSvmEbH5tEa/9oD2Nnb2q8xXCSKr0BGu0NkEu25gvmWChsVfdAQ+IZ?=
 =?us-ascii?Q?++3Ee81MEl+VVQ03z4dCrE6vEdYTMBHtA+0IFly6MajN+uYW1wXNC04Srret?=
 =?us-ascii?Q?rmRBkLGWSGPDOAtk8c7TLL+Vs3JL3wVqTHPDpzV2MIgY44ZNgBGho+UAhXfE?=
 =?us-ascii?Q?aGQqMiN+8O21MDcbhUZ7utbYN4dfO8el1Xf2srwH/Z9thIyvg6dsTELQ84DH?=
 =?us-ascii?Q?55ThJi8EaWQHkZdgz88Wl5RVA9UoR97Da83SLyYar2glRuI0Wz6EECz8zq5+?=
 =?us-ascii?Q?eHBWhGZWacEzWtjUdRSZ/l2u1SUcPnkcZecu6z7n53OlYaxaKNJgEneILa53?=
 =?us-ascii?Q?ESZPigHXL2afs4vyQMombskuivxwzHUN3mKTDB/YSNd/lU+2rvccYZLM2TSH?=
 =?us-ascii?Q?udUNENH+o988SGz6IWpm5n4D7NBYCdwixUUy9TwrZ7HQ+FZcfqxVWH32N7tH?=
 =?us-ascii?Q?JHhio9iwKG5/qKj5qk3kN6NKhvghvP9t2FyQ97YQG18Bw0X4i9gtJfAagmEU?=
 =?us-ascii?Q?1fKD9QvCl63RiTfS94oveRTpLuRr4vDR5SCV2VItjwKt3DNeHadM43CcMFI2?=
 =?us-ascii?Q?FJJPfaL7FXHK9p1YfjRdNHotLElR8dLfnm1mUoISA3aBOOesjcl/GG1lj0Ib?=
 =?us-ascii?Q?1dM8EMIxBcNTgLQ8e/bXlaLAKrmtubMeRaLLxTzA5M5XugOkY5UYpOITziJD?=
 =?us-ascii?Q?3N9cYqGpcgue168TzeBLqk/ZGXKMoIyIXPIAxJqLX8ZIJFWdSuL5xhtcXomR?=
 =?us-ascii?Q?sWGrbqsBKAJbQoRD6WUBggQRdJLph0d6NCIESpDU0zWZjNfeCiR62GFlAcKR?=
 =?us-ascii?Q?BGH7SSeyMIzC3tjf9VG801UgTK1o1KF1KmNzfJKwXKm/tmGUswk2zWiqiILI?=
 =?us-ascii?Q?4ULWhScvs6aH3GYntVtR+9ukbzEjC0IbxsCf+gqIBC4ossrdSBhf2KSmfD4h?=
 =?us-ascii?Q?uKperXJv57Zc3rTbYsY+NEkwn3r0NsEuZIROPPPdtPqJOUI6WPqUg0y14LTn?=
 =?us-ascii?Q?M2lHsZSMKezvwssWLJnQfw5dHQOpjgQiRP0gDFmtn/Jkp955IZ1WdAuAKzhZ?=
 =?us-ascii?Q?ndOF3YEDJr6N99t2+S81r1sdFn2a74Le9OFXMhOTsWx/N100Zd50nAvlmYVK?=
 =?us-ascii?Q?1ASfNpo9mAmGBchSpd+93ZqraRqslA2929xMBp0trTPfGLsTKpu3WdY3uxKl?=
 =?us-ascii?Q?obpsvjCGw1suzqFJYv3heo825dwibNLc8IoXbq78/Blr1kAHpSgPAzs5U15S?=
 =?us-ascii?Q?Ughn5MEFLG5V13cuZgn+INPHu9inkt7nV6eiA5mc9SVZNBZ6T9+ocbOUi6VH?=
 =?us-ascii?Q?zuIyIqx78yaguU+wmgbvBiccsdKs3KiJpgDtm5Z6LNojNB1EK6wfGrhXfMvk?=
 =?us-ascii?Q?GB1BA7RZP5J7yEB14VctZz2HzD61FJRgfE9EzLzPD1kJ8fUMFTZjzh4TG1on?=
 =?us-ascii?Q?HMrAmb2Uvlfr79CrbIOYjPwkKN91zOCoMfHjMtE8pnV7srcf3Vw0ibQq+gzT?=
 =?us-ascii?Q?7GaU+l3sHZkrOaXjkXpVXQMLjQWbMW3KpVbL13vO2JklXGiJUAwOd4YSk4Dk?=
 =?us-ascii?Q?fKha+j7B2hF2RXwhkcXDZogQKAEFXGogwGYyYywFwG2z9cgfjInQX9YNMRpP?=
 =?us-ascii?Q?AOblpQsU1w=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd82ea75-820f-4a77-061e-08def3cb4c73
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2026 14:59:22.0787
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hTWI0i2R3q/fZJKVFz1LMD0Ahm/zgUNybS8pzyL5h1oZrcV0NHAXW9TIbi0pcX7M
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB999084
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: y4siqhpxay7mo34gwupcarwqs799d367
X-Rspamd-Queue-Id: 800A5120004
X-HE-Tag: 1786028366-544368
X-HE-Meta: U2FsdGVkX185V1OjX26A9a1C7QAajhEL9/E3mjSHD5gHMmFh+r6/2sZ3gywb6AUAViSxtdqTZuqKuFsbOZnKenp/C+DjEiScGdpKo7W1FeW9XKdO625nFU3tfOuZ+ve5zEv9VZFvdDHqGp9EH26t4iY/JHSMonIXb8mImPBvgCniUzy0Wpv97zGkOGOML7CQ3Pvxm9fg7XG5s9JoP3zajkAwX6oHfn+aAMJa30OGxCoUTIZm+HwCM2VAtmRZ26q3iddbP5VedOf8KyJUxH8G53C1Nt3F8X23vnfhd2ruaJt7qW1tqfSJainiEVOmmnjZ7RBgnXFuVYS4NFCxyvrhfDt9hWMP4i/A1OooUT+grfs47R27faLZkQMTxAQqyPz0YzbMbjkZ/KLMxjclTXMEdAdtbEjChkO5THWkR59sAF9FIUKV2hJNyWjNIHkcd/1Xsst/lwplS88fVl6szz8oBIpmROTnwgeCKjpeKgLePpxMsgmmAT3a3CCSnOOipnW7cHD9EjYh7H5epy2Z4keolPIaPLZqQomiYNn/o+GtACuSbm67v9QMo8xFzryiw2ykTt0UCgwLCMjD7ahUY53mjjXDPDyc5YufqqF5yBE4HMA8uUA12ETXFV0JwdxFmLrU+zOPnlIMX678++eR5PirlPdEs1njlBIFh9C50KscuEzrHL0ZsnC1ZPoqna5zqBLLio9F/CFGmRZugU8QF3JG7GMMbDDIEgbQ2KHZNOpow0IqsEqpd+CW7oTjWki6pJkNf3LzSUfxZKsGNGWmOw+rc0iES+dJwxP9YbR0Za5d1yvufVOQEQK2efFjcqlrRR3sQATd1t5JLAr1AOxz01SZGxtzhetijxXRqfxrvOAnftuh/z1nYeyxikGeXWsvEj91ww6FwpOn+gfI2Hnqcfkn+GMLcZ1eLnUDWewS5JBAsQr3lelJuUOQ5DuNzPpi/E+f2teSAEwGn/fhLsngwT9
 i4XT/7JG
 K/phRahsa7AiZugOFseDEW/YJ5BPPvSXWKyJteiaeaVGVSsL5zHlAyspMpYLIQ4NP7lAZcwzGdwI2Kl6dOZ4z5lmYqZfC71iDIfABpDGywSmsa6eEZAdCAn9hpSbC/s91iUjmo7J/xwym4Nx6JQ0IdfMe/9s952pyVl4mmU3EGXZeXiom0w/sulkMRL15YWoPBBN71Yf9fzViLhkSPEEWTrSSdv5BS426nMFb14HMAv5aZ1czHxwBmeGDBQMR8va3OcAQyB6ZDyLfullNg25NFpcBb5Pkm2pR2IsQWNTs73r6lgG3pdjAqj1Ys2UIZWueLHsb+BDIB5XsRziBJBsD3TXUnMLjOA1V4M6bBgvGsAhMfLC/F+3h8UZsTzS3b8GskO1RZ0E1tP4FCAMg1ve6fCKPlXC7nwlMq1JwHhPVcYw9IjQqums16XW9yPDgThjCziLoptsDm9olSd8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5 Aug 2026, at 23:34, Baolin Wang wrote:

> Implement mTHP-sized hugepage checking helpers using gather_folio_orders().
> Also rename the existing PMD-sized huge page check function to
> __check_pmd_huge() for clarity.
>
> Reviewed-by: Nico Pache (Red Hat) <nico.pache@linux.dev>
> Tested-by: Nico Pache (Red Hat) <nico.pache@linux.dev>
> Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---
>  tools/testing/selftests/mm/vm_util.c | 76 ++++++++++++++++++++++++++--
>  1 file changed, 72 insertions(+), 4 deletions(-)
>
LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

