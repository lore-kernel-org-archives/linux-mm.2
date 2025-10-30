Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62761CCF9F6
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 05:31:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C35C68E012B; Thu, 30 Oct 2025 01:31:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0D288E0112; Thu, 30 Oct 2025 01:31:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B49A18E012B; Thu, 30 Oct 2025 01:31:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A38B28E0112
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 01:31:36 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 56650140A2B
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 05:31:36 +0000 (UTC)
X-FDA: 84053658192.30.8F45BFA
Received: from mail-4322.protonmail.ch (mail-4322.protonmail.ch [185.70.43.22])
	by imf09.hostedemail.com (Postfix) with ESMTP id 5AF14140003
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 05:31:34 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=Dmkbwjuj;
	spf=pass (imf09.hostedemail.com: domain of m.wieczorretman@pm.me designates 185.70.43.22 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761802294; a=rsa-sha256;
	cv=none;
	b=vIDANmwEzHXFXm0W+JX31ve4r8E8ic35GgRy9CX5OMoANoCJDGsa4s726SPXMQtEO4lonm
	pyhjw8kbH5jH4NfphQ9feREKFNIgEpVZfgcpvXc4B5k2v4mv9PgvCrGw9Q1DKGD4np6xzA
	MMESOlCT1xF2Gir3J1xO3/fmd8RfsOM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=Dmkbwjuj;
	spf=pass (imf09.hostedemail.com: domain of m.wieczorretman@pm.me designates 185.70.43.22 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761802294;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SqB029SpVmJqfLswaEolkge/L1HE0Gdq54LxorgJlpY=;
	b=iFeq8PXT51ZXq98ZGgvD7+32NTURiWbkxrtVnDhU3rRuVSNcDyRqy7D26bRmt31n8qE26M
	hItC0IEeMXnawFlDJ5Ok6sayAX/7ZeWgtXx07fcy40ZhjOiia9S1m49Ciz1lVEtjXy5+C5
	yxe0bc7BCBkqK/ZBDgdc2YyFskkWeW8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1761802290; x=1762061490;
	bh=SqB029SpVmJqfLswaEolkge/L1HE0Gdq54LxorgJlpY=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=DmkbwjujvK+EMhhVlhE633gtvTYp7stPsK2BPbKyUdMoaxnIplgzHAexjILc1xVuH
	 gLXrpW1HyJwWmsjmp/lmf4wpRSDyWnYtEMKML6wW8rgghV+GnHSCpMrfmQbgODjtub
	 tGyuGNNdhb/LVgZmJXqsvlvCEbLjmO+I8ggYJKeqgf3/xZCnBJg2qmYKYktt/n3rp4
	 fpr+OFnZKCJlPrSvs9lPwCnKwXx5Pf/+vCoIGRyfV6DxVWk6i5QRjssG2k73Nt40UY
	 eOQ6qpOuIco0pPKWj+Ilc/4BN3PBQx8nKwI+YZfggQVUW38eqxOLLul3nZsVeP7f6K
	 Q7ALpWrEdqhMA==
Date: Thu, 30 Oct 2025 05:31:22 +0000
To: Andrew Morton <akpm@linux-foundation.org>
From: =?utf-8?Q?Maciej_Wiecz=C3=B3r-Retman?= <m.wieczorretman@pm.me>
Cc: xin@zytor.com, peterz@infradead.org, kaleshsingh@google.com, kbingham@kernel.org, nathan@kernel.org, ryabinin.a.a@gmail.com, dave.hansen@linux.intel.com, bp@alien8.de, morbo@google.com, jeremy.linton@arm.com, smostafa@google.com, kees@kernel.org, baohua@kernel.org, vbabka@suse.cz, justinstitt@google.com, wangkefeng.wang@huawei.com, leitao@debian.org, jan.kiszka@siemens.com, fujita.tomonori@gmail.com, hpa@zytor.com, urezki@gmail.com, ubizjak@gmail.com, ada.coupriediaz@arm.com, nick.desaulniers+lkml@gmail.com, ojeda@kernel.org, brgerst@gmail.com, elver@google.com, pankaj.gupta@amd.com, glider@google.com, mark.rutland@arm.com, trintaeoitogc@gmail.com, jpoimboe@kernel.org, thuth@redhat.com, pasha.tatashin@soleen.com, dvyukov@google.com, jhubbard@nvidia.com, catalin.marinas@arm.com, yeoreum.yun@arm.com, mhocko@suse.com, lorenzo.stoakes@oracle.com, samuel.holland@sifive.com, vincenzo.frascino@arm.com, bigeasy@linutronix.de, surenb@google.com, ardb@kernel.org, Liam.Howlett@oracl
 e.com,
	nicolas.schier@linux.dev, ziy@nvidia.com, kas@kernel.org, tglx@linutronix.de, mingo@redhat.com, broonie@kernel.org, corbet@lwn.net, andreyknvl@gmail.com, maciej.wieczor-retman@intel.com, david@redhat.com, maz@kernel.org, rppt@kernel.org, will@kernel.org, luto@kernel.org, kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, x86@kernel.org, linux-kbuild@vger.kernel.org, linux-mm@kvack.org, llvm@lists.linux.dev, linux-doc@vger.kernel.org
Subject: Re: [PATCH v6 00/18] kasan: x86: arm64: KASAN tag-based mode for x86
Message-ID: <ngwfbor66uhrgfe2g4nvziwqp3gtsbndlpnhnov7ew7535dysv@ieypsfjfmnlo>
In-Reply-To: <20251029150806.e001a669d9dad6ff9167c1f0@linux-foundation.org>
References: <cover.1761763681.git.m.wieczorretman@pm.me> <20251029150806.e001a669d9dad6ff9167c1f0@linux-foundation.org>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: 22e7e1e747884a326f20da03a155c805b55537aa
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: 79ukdfjwshifg96sj9hta3dqmpesi46z
X-Rspamd-Queue-Id: 5AF14140003
X-Rspamd-Server: rspam09
X-HE-Tag: 1761802294-995608
X-HE-Meta: U2FsdGVkX19nEtsmv8eXY/KGHkSNkW0JOktoI3h7lcGTt2kLsEA9yDdI9SFkJfZODEe9MhVewRvZn2IZ2IZU0nsyzH3ZRQ1Q9T4ds29hQvFbeNI81f5Klg5tXOcFZSBhEEddANKiBpCSLYlHiNikcl2pj9tIhKV3t4zgyw+7YR/1X+m00Gn6l+2OOB6PNdKF9i/PkegH+GRd2EBYxJa2KE9KUQkZqKD1aanl/wrdQ+c2Y3DzbNmTBeHp6GT7PEXtW83DLFYdwa47fa/qhvEW2ILg5vIGvBWewatNnP3VYn1GNYpwgOzZukJExgmwjs4+VsbrBMrRZbGXKCqHjOrr/+DT5o969EzBoQdNDIKWxL5dYjdnPdyH7MJGYssBwW71JqPpSRq8rs4ojC0WhJi4TAy1YGbOeSQLikEC0DSCgD8qQ3/We6rHkoeEf9KXCfjA/5itzEeG84yfeTSOrYdncp22W6xcaTLq+GlgCDX+Hn6lUiTUNfLz8cVqKQQcoaV7ubnUW5P2LfoUOlp8aqtL00Zr3dg5gJxr4cf2hAdsK358/w4G/p9YLBXSZKgO4PG3zMvcQxLA3Z9F2dYTxg+g3pibhJwGSpppYRlIaiNU0tSmem5BgIb5I/h0iWLurQm1fii4P6KGQi4u6LXhH2KAzDpK0TD2WgojCTHBF03qXlPZ6Qcu5KtW9yjsuf55MrxBsY2qhZZTqk1u8a6cPQO5ESWoA8W2iDkzVQSa8HPNZ0qU+1GHiKQcnmrabY9znFzvyjNOwuEv22TqMZf7Ed3z5tbkUTIIuAh34gap3l1zywYAPc3c40nx5Mm/J3fVHMM+wZFzIoSN1EzlomGxkc2VJL3oIBFm4Q58ivoMf7YVgRDPgCdI5ItIltRrjqjMbVDeYsHr72mS1+ev/HkHdlHNvICPUnrAhwjr6IHvuAccrp65uAP2TyVJ1hdH/xHMqikMuooYdA2Nkm+uLwcGC4d
 2Qre3b2H
 Cl1Ewt5oKC70Lyj5i4+sb/p/k0+8x5cNiRGOo2CA795Pkj2waw/vkbMjvN4pzBt5bcorKf2Iq51kpELP4uDxAeMiuk+PWH4NgX1BbxQqLKhnxG/9XA0HzhZ6fisi4ijjvxD5IdyspZcZ1B3HhlOYbggRWdqD3YxTJr04/xvRyrYzB+UKMmKT+UcfJf+RRsJgXZGc+MylDXmVIIcCPVy6TadGlGFLCyWCh28PiTZW3O7vr1gO9EpQOSxD9+6YZ89ru5w+hFkMayAE9asgmeBXKmJVkueEcHCryk42nUNljWyM2/3sJjlz/aGQd0g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks for taking a look at the series!

On 2025-10-29 at 15:08:06 -0700, Andrew Morton wrote:
>On Wed, 29 Oct 2025 19:05:27 +0000 Maciej Wieczor-Retman <m.wieczorretman@=
pm.me> wrote:
>
>> The patchset aims to add a KASAN tag-based mode for the x86 architecture
>> with the help of the new CPU feature called Linear Address Masking
>> (LAM). Main improvement introduced by the series is 2x lower memory
>> usage compared to KASAN's generic mode, the only currently available
>> mode on x86. The tag based mode may also find errors that the generic
>> mode couldn't because of differences in how these modes operate.
>
>Thanks.  Quite a lot of these patches aren't showing signs of review at
>this time, so I'll skip v6 for now.
>
>However patches 1&2 are fixes that have cc:stable.  It's best to
>separate these out from the overall add-a-feature series please - their
>path-to-mainline will be quite different.

Okay, I'll send them separately

>I grabbed just those two patches for some testing, however their
>changelogging isn't fully appropriate.  Can I ask that you resend these
>as a two-patch series after updating the changelogs to clearly describe
>the userspace-visible effects of the flaws which the patches fix?
>
>This is to help -stable maintainers understand why we're proposing the
>backports and it is to help people to predict whether these fixes might
>address an issue which they or their customers are experiencing.

Sure, I'll also fixup that undefined symbol error that you mentioned in
the second email.

kind regards
Maciej Wiecz=C3=B3r-Retman


