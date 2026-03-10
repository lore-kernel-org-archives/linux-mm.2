Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28C83FD4F2E
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 19:30:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34FE46B0088; Tue, 10 Mar 2026 15:30:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 327836B0089; Tue, 10 Mar 2026 15:30:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 229DB6B008A; Tue, 10 Mar 2026 15:30:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F1E9B6B0088
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 15:30:46 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 98C36B8024
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 19:30:46 +0000 (UTC)
X-FDA: 84531145692.17.6B26681
Received: from mail-244123.protonmail.ch (mail-244123.protonmail.ch [109.224.244.123])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8ABBE20014
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 19:30:44 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=NNYtUTuf;
	spf=pass (imf13.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.123 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773171044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DebX/uKrd8E1cdubk7gVqD5mFHMWz0EBsTGvClcjjLU=;
	b=KZHzIFsbDXv+vYxkSiqz91PnrmiAnQbYnGMR4Wcf1+OMypNraeZQwYr16U731g3a17KCCs
	8UcCsxJ1hzbFDdjUiN3hxJ5M/6q+/PfXf0skFcz5+S868uFyco4+HMUCHo5Rtmy2l52lTo
	K2Ks8zq1nju6jB6m5dlDvo5sn37yAjM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773171044; a=rsa-sha256;
	cv=none;
	b=dJrHWGiJ9VaEmshUqbyQNp2yxfa1uDeaG74AdZgPlUTrf89pR+tbAW72ih76sF5+Xxc4Ha
	jZKS4TJwXLfBK8sAk80EU/lHIL1HOj3K0ydJ05h14SF4/lUkq8fnd8G3jfQUZRqv/YNOVC
	cDfCD9vKeOqITpZegXbPY+APPN+NMC4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=NNYtUTuf;
	spf=pass (imf13.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.123 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1773171042; x=1773430242;
	bh=DebX/uKrd8E1cdubk7gVqD5mFHMWz0EBsTGvClcjjLU=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=NNYtUTufT6cuK2gc3E3sBQG2y4/1aMcxGYI/3+6ltvtRORBVHg0PdzDYXP8h0g/s4
	 4gikZ/igoaKXzSdiysh94bjtGM/3re9YTzZ7wmKv0lDLKJxpWkqTRgtFXddPz0ED4v
	 ERO+26f0E9y2rIwdKL4WodXyL/Hsw0E+F+oGyCJxysGm5Lodv8BIyYVrHx66zMx/cq
	 d676Pvcr12yESXAuomDZyFPLuDRgX332ei0JVZqSxiLFB0FHH1aId+YikcqE3ozcV0
	 CAaKYUkFstB2d73FF+hgRfcJRAF85qA3g/qFKLTTFpk2djX8mWzmrtwBTUKKs/bmxI
	 Y/2pcg890uG3A==
Date: Tue, 10 Mar 2026 19:30:36 +0000
To: Peter Zijlstra <peterz@infradead.org>
From: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: urezki@gmail.com, ryan.roberts@arm.com, kevin.brodsky@arm.com, samuel.holland@sifive.com, dave.hansen@linux.intel.com, jeremy.linton@arm.com, weixugc@google.com, ljs@kernel.org, ryabinin.a.a@gmail.com, rppt@kernel.org, bp@alien8.de, luto@kernel.org, jan.kiszka@siemens.com, mingo@redhat.com, david@kernel.org, mhocko@suse.com, akpm@linux-foundation.org, andreas@gaisler.com, kas@kernel.org, Liam.Howlett@oracle.com, morbo@google.com, thuth@redhat.com, catalin.marinas@arm.com, ankur.a.arora@oracle.com, kbingham@kernel.org, nick.desaulniers+lkml@gmail.com, andreyknvl@gmail.com, dvyukov@google.com, corbet@lwn.net, leitao@debian.org, hpa@zytor.com, tglx@kernel.org, yuanchu@google.com, ardb@kernel.org, vincenzo.frascino@arm.com, tabba@google.com, joey.gouly@arm.com, nsc@kernel.org, will@kernel.org, yeoreum.yun@arm.com, nathan@kernel.org, maciej.wieczor-retman@intel.com, skhan@linuxfoundation.org, axelrasmussen@google.com, osandov@fb.com, surenb@google.com, justinstitt@google.com,
	kees@kernel.org, vbabka@kernel.org, hsj0512@snu.ac.kr, trintaeoitogc@gmail.com, jackmanb@google.com, maz@kernel.org, glider@google.com, linux-doc@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, workflows@vger.kernel.org, llvm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v11 00/15] kasan: x86: arm64: KASAN tag-based mode for x86
Message-ID: <abBu-M5esEYWScDf@wieczorr-mobl1.localdomain>
In-Reply-To: <20260310190022.GI606826@noisy.programming.kicks-ass.net>
References: <cover.1773164688.git.m.wieczorretman@pm.me> <20260310190022.GI606826@noisy.programming.kicks-ass.net>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: deeac2913fe3968b47380487a2b3c2c800a00e30
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8ABBE20014
X-Stat-Signature: 9crduhhkzwq6oo6mpt49mjseep8ibaua
X-HE-Tag: 1773171044-847951
X-HE-Meta: U2FsdGVkX1/4CW6Xjc9inq3IbdRQTx78j+fcCpw6rU4FHvWjRqDMVxE0IczKp2XEdKu3ZWtN7h3Z3SS0BAHR56LZuWNdd3v/P084Y1SbtnEmUThg89laozaMkPBBatjz0UiFe9SmD7eFmT5fIlWVUnwSnZKaWS7miTMyWGGxJLf/povMZe0Ip2c2Px3npIOJYm8NDoJc6LbFFZzyaL0rbwnm2/S3h56iE9Xx0e1hNLbnxoXvk181E0z96NFeUjr5CsuVD15oNpLAOr4eZ74sT9LfsOcCLJx9+Mt50q9bTRgZZrVxOxAwUC1qMqLkpnYK8Ag3DTMCBnO0pHXq3TX42YaQqSvPSjChbOwuFkT8LssdkKPM6rATCjS/AunADFzj0pYeNWZjYL1Es5L/xmJEtSUSll+H3K8NL70ACG0J55WjCu/zLhrZK+M1dfAffCuGGM/lUDhsAoVA6Hl8XC8CUlySzPJ5m/Ib6jdrEZPUIrFWSD/jZUR4SjDoTAx3cGPdKjQNsw6tobMLRhhXJUI1co2LecW+Tu744aWmU2QchfH0nkaiUBm/I4X3v3zIFokG7Veq5cikhiopuCU+5HgeQ1ChI6uKhIzoeIHy3qgsU69k83l9qZWXbMzjtQa1GGbIUMDLihcfLiuXD1XAvLghgRBhylRbUUtMxMnnIx0P19064kvt+zqK11j3bOjs6fZzHb351Bp0GFZxvjA80G5Be2T41hpsz19mCc4DwvEuJtHYYek0PQBd9Uluz4CZbInwQxhUrod1wjYei1HKY9IjkvZ2wi+0mHo3pLSrcUTs8RsXYflh0KHi3R44LrP3SHPJl8vjjKVGRA+/BMqwrODgM8IELZ5X7RibtxN5bBQEP4gWppWZNdFVdEgD52Z6KlIz89yECLUIJIKK3tsKAve8l019phpTFFIT+WyP6mDEPbDJo5qgGmmcU38UZKDgZzxJ+uZ9VuQbPbXyub6rp6R
 uQO4+T74
 wCfBezBkpqv4aEepU99dSf+g4p3gS0z5BNQ8j509HOKvXrDlXYKKyQrhiTf7e2Nk4qaBft29ydFGk2f4TKHEY0mQOc8YUcJfiPUuyyMbvRcgBBjaUsBrhqaxylrIsSQHdMJCAR4xVreu6we92DTM6fQEPOXf0VCP2Xvn5Q1DYmykZyS8izFZRPXpYDnqn0s27/Qjiax1ICzVbFS8d1O3Qyven3wH7OA7rvCrukF+aaeNavFFE3GZWuyMYJg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-03-10 at 20:00:22 +0100, Peter Zijlstra wrote:
>On Tue, Mar 10, 2026 at 05:51:19PM +0000, Maciej Wieczor-Retman wrote:
>
>> =3D=3D=3D=3D=3D=3D=3D Compilation
>> Clang was used to compile the series (make LLVM=3D1) since gcc doesn't
>> seem to have support for KASAN tag-based compiler instrumentation on
>> x86. Patchset does seem to compile with gcc without an issue but doesn't
>> boot afterwards.
>
>Can you put all that under a specific CONFIG and make that depend on
>CC_IS_CLANG?

I made HAVE_ARCH_KASAN_SW_TAGS depend on CC_IS_CLANG, and that controls all=
 the
software tags stuff, like ARCH_DISABLE_KASAN_INLINE through KASAN_SW_TAGS.
And ARCH_NEEDS_DEFER_KASAN is for if KASAN is compiled but LAM is not avail=
able,
so that it gets disabled in runtime.

But sure, I suppose I can add a separate CONFIG with CC_IS_CLANG to these t=
hree
so the clang connection is more transparent.

--=20
Kind regards
Maciej Wiecz=C3=B3r-Retman


