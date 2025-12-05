Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B913D2E02E
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 07:58:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D09A06B0133; Fri,  5 Dec 2025 02:58:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB9B56B0134; Fri,  5 Dec 2025 02:58:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF6DF6B0136; Fri,  5 Dec 2025 02:58:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AFD4C6B0133
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 02:58:03 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 47C8659025
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 07:58:03 +0000 (UTC)
X-FDA: 84184664046.04.A06F978
Received: from mail-244122.protonmail.ch (mail-244122.protonmail.ch [109.224.244.122])
	by imf16.hostedemail.com (Postfix) with ESMTP id 6A18C180008
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 07:58:01 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=aEo6vSWz;
	spf=pass (imf16.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.122 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764921481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1h9/RRI9HDS7ow72CX1vsz7ZQ6MiMrPzsBwSmu9lD7E=;
	b=FqsnNM2Y11ULwMJ8vOm30WOtnkKdzrfoDn47fr6BZLaeUqurR/16sKtusxDm8vl5Xsksi9
	EeteRMV59Ye/thDm8imIYF9nFvC9clSKEchsFhAgFPmbcRx37d2MCpqM10S7UbpexFVdJB
	qgV79vSpTm6LqPOFjhac7pdjimLUFks=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=aEo6vSWz;
	spf=pass (imf16.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.122 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764921481; a=rsa-sha256;
	cv=none;
	b=gX2yBTg1r6eeorj6Z0EnbLB3QDsNNnzi1SadYyuF2Wm+9vm0X8X2ThJFzFOtQHMACbfuSf
	RQBXQKZ/6RPID8lOm4R/FbLg4IEL9ju0bwCXlAm+CZelnLWkULkfRp4iqmSUUoUEECDYFJ
	SgsAVBl2nwDUOxtw/JMmxo+bGyjbNYw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1764921479; x=1765180679;
	bh=1h9/RRI9HDS7ow72CX1vsz7ZQ6MiMrPzsBwSmu9lD7E=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=aEo6vSWzKZDOQYAZh576xbLMKvECgXoyCf7zi2yIRTmxcrhf580+ipQBSj5pq5VJW
	 2QGCS0MChgFCG2i6TMhnOY8yyMpivB4uEEbha3uenldQ0aBjfYYuF6chgWyPzmQ8OQ
	 DuiU5edfQGjukc13x4AhnbTfBj6W9nOgPWQlz6aALk9JduMwrGIaIYSK9zPgZxinE4
	 BUjzy+Hj0QTwLZP1HC02NJY6fy7nGOSqrKsnevJasLiKlHcyDXOA+8PHBsOLTgDFTo
	 ChXcHgKYqpobdoGQKHG2+mdAMRY8MBTyiojeWXYhuXC4oVwmxjCGp8RRDWBEyWfRSO
	 eqs8SXLffcZpQ==
Date: Fri, 05 Dec 2025 07:57:55 +0000
To: Andrew Morton <akpm@linux-foundation.org>
From: =?utf-8?Q?Maciej_Wiecz=C3=B3r-Retman?= <m.wieczorretman@pm.me>
Cc: urezki@gmail.com, dakr@kernel.org, vincenzo.frascino@arm.com, ryabinin.a.a@gmail.com, andreyknvl@gmail.com, kees@kernel.org, elver@google.com, glider@google.com, dvyukov@google.com, jiayuan.chen@linux.dev, kasan-dev@googlegroups.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/3] kasan: vmalloc: Fixes for the percpu allocator and vrealloc
Message-ID: <t7bhzp4gidfqb7bnlvxio2tifyvifhqirumuugbb7opodxwwra@5iytacnkfwm3>
In-Reply-To: <20251204142112.fc11c55e46bd0017c41b49e1@linux-foundation.org>
References: <cover.1764874575.git.m.wieczorretman@pm.me> <20251204142112.fc11c55e46bd0017c41b49e1@linux-foundation.org>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: 5aaf1a947d9e648b1e999cdd04f2d6f929387ec1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 6A18C180008
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: qpu945cd6d88gmsj5q8ag1cnr84jpzns
X-HE-Tag: 1764921481-412960
X-HE-Meta: U2FsdGVkX19ndQf2yCcOVuyp4AldAJixxrbAVPM3kwKwHd8CJllvENEEYeW9NvrlzcPDpr5kGv8XekWm5gTmLT6boTEBsqY9xtbv8aOh0xI5FxLbreql3kHRKa3rEYx5LgaPRu3Kl/fxivURkHXuClJDfOYeRPd96B0W2i5uGqZCy3LTOz3cMca3ldeEQ9sBn1Qd/qE1qnUdXCmEN8+SA9+19TH2X3N9gP1pdGhGlbSHb0fL77jMZRCZz4uW3HvF4oO6f/jubyPnR2HU1H4XJoUjnPbK24EToQfieCLMdI1qkYSBi5jmTgxJanzDy16TNFZdqBTRWhlHwJx0pnh1al8DyVhYAYFb0rtLuwWi+BNAAFTAdvevBfLoTvhWvJ3gtBkfv56KbjFoZ1ABUxQS1XMJlp8Yd5bS/8HakcxL0LBdU138OwYBOIPzRcj5aNPCOHK5GWCHQSVRpcotBPjNosK2wNFAB4nMxrRyk5IOPfoB9qUcOun7vpLbeaKw+/d7Dx4YSxh811fHKRjcIlavUbYRYdw2uQs9mQKu2qEyAk+RN+/lUfzNEdPkAgUnHb+rz6jGIAP+ZuXo/cbwYe3BLWtebVeHfXqOQgHqMV33MAgO2/I+x8RSycBZpEz3VIwdpS8WixJsMQs9V65pJivCWFPVB8vn4wm0xFoT9mHmuaRZ0xqXUkwvLTAohu8DGp8AWoOJUPkO2sBzsKZL5SqSptGNh4+7bIZ6DV14q1frvoayJmGrYU7WCU6EXIxKphiP4wwKU7eN0sjAISG3IdpL9V1VM6lzQ/f9wlgvtDYt8OQ1Mg+4OngRkLbj/FGQMgqNYGJ0s4hL1NJpuYNrHUX57B1vEJmOK457JDgtspX5rGAQYuJ0AnlE8ICaF/hJynyFtY0AB3buHi8U94EsB8BDhNsJLfLSsHCR165L8B+WZDwxwu+khn4ccSSVtZTgC78pkrxcqwg+e0DcXVGxuj2
 vpQe7qf/
 iH1v0kz52TTVAvfLNyr1r89ecYcEIjvKF3QHst0Xdzlhbf3cXjk9qZ3hpGYnbkjeRffCWyhtTuyPlH+aoV+iAR803CnzJ6XCfHWFiZYlxZAdUEiJuNegiHRNtMBMLtjNZcL1hXfr9hEoj9VrPPBLE/TYJztN4eSdfT0M+N2ntCYhQTI3kYQ6JEEFC0wGVMdoTZW60vFcFDW7KD8LC4EmHbwiJvWZM80a33x4o4n2WgvUqeA15UtxzMc7ZGa1UOHZ6251i8qE+aHJRNQga4qmY67WucNFS27uszgNKofTi2guA3/ATgNYWVeLq8A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-12-04 at 14:21:12 -0800, Andrew Morton wrote:
>On Thu, 04 Dec 2025 18:57:44 +0000 Maciej Wieczor-Retman <m.wieczorretman@=
pm.me> wrote:
>
>> Patches fix two issues related to KASAN and vmalloc.
>>
>> The first one, a KASAN tag mismatch, possibly resulting in a kernel
>> panic, can be observed on systems with a tag-based KASAN enabled and
>> with multiple NUMA nodes. Initially it was only noticed on x86 [1] but
>> later a similar issue was also reported on arm64 [2].
>>
>> ...
>>
>
>I added cc:stable to [1/3], unless its omission was intentional?

Thank you for adding it, I forgot it was missing

--=20
Kind regards
Maciej Wiecz=C3=B3r-Retman


