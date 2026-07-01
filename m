Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05086C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 13:18:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 032006B00A6; Wed,  1 Jul 2026 09:18:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F25B26B00A8; Wed,  1 Jul 2026 09:18:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E15ED6B00A9; Wed,  1 Jul 2026 09:18:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9D0B86B00A6
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 09:18:57 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F21BE168251
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 13:18:56 +0000 (UTC)
X-FDA: 84940263072.18.2797B86
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf02.hostedemail.com (Postfix) with ESMTP id EEC4380017
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 13:18:54 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DyxEwzBz;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf02.hostedemail.com: domain of glider@google.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=glider@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782911934;
	b=g0NXUDRDr+KKS1WFqetsaU9ptnSgpo43PtsNqG9MqZHXovnVf6z2Qo+QwvNh92WNbIEEvM
	wbtVkEKEOoRis5iBCFS2CQ5A4F+5KO0iwjf/xFjh5fxXxECxlrfCyKkO5vHjFkSh3tEwqn
	YiXyDKuGokzLTj0dmrnZIvt+H0r49OA=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782911934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XXVVWGSHO5OhBUPNJsRgu+ydLv5yZynk2j7cpgZvDzI=;
	b=rE/fyi5vz6vDMmkYK9YF73wgRYCnLEZiajvMT2PE/CO+JvcbPQMXMPrvfzW6oRGrRc36ho
	gJinH00x/UipJM6z2NMxJFbwpMjiZBVjkxRY6W+GgOL7sXR4RY74O1IMHPz/Gmm0TLXcEh
	9UzgMV/j0e6X97SPZSHVtXJVHciuZLE=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DyxEwzBz;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf02.hostedemail.com: domain of glider@google.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=glider@google.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6983f5c1c52so1303615a12.1
        for <linux-mm@kvack.org>; Wed, 01 Jul 2026 06:18:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782911933; cv=none;
        d=google.com; s=arc-20260327;
        b=fYFxfqbICG7zgtW0OHJJ02fHVhiiHN206MnSBY3ZpTBwJPoaFa/iBpUjCVQf2CQZWg
         gdnU3xxJAqGKl22pjIxitoR31hU5z4ZQ4mEhYhd3wa9hpYrK0nh4oZoY/r9oWz9GhiXS
         dzsy2CsbugrGppbO7mCtoRfL4GDargLljalNvwqxdOWIKTYZ+l3iCNW1vv7S1hNIAPbE
         d2jj8Rx5mjDpb/ZOpHmrIG0R8uHm/paRTZv0bZwSXApEMQzFF+0M+lEWY40QcL49dCyb
         5hAlqcVYLctzHI5cT8D21CjXggWEZyoXsD+y3M6z+OKpnT3/A8/GT42RY5q4QTivYK0n
         VPqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=XXVVWGSHO5OhBUPNJsRgu+ydLv5yZynk2j7cpgZvDzI=;
        fh=Wb4sCWBzpi6MyD0PMWFjtgLD0A5dUbCXOHj7yrhtLtc=;
        b=n+VQIbbNazx049aEzyzHyoNpENk9BqPrdEIRAUYPp4jdMbjUQtKlrrVoP3tm6wpBdg
         B5s56B9FZPglIt49+5wNUyUT+ELaYc07Azneydn1wCuAGfyE+s2VQDiyph4bQKKnATkx
         lqwB3w+iPI9/o7hqe2KR7QcJsUoCYnfGzgu8HdStS9ipsYsekrMFOr+9UbD+gtXgWBYy
         lb1YESY1rtWZ2szEREF5UbbNyFJGNA6WfEeXRHFN2FXdupC5mEZgj9Q4jTYVcKsZeSZy
         6x2KoCfIGvaoF4vvY7nxOqK6Y1wSWcRET1mekKvvbg142YMV1wN3hyCCZlSqH6M4jeQ+
         Z9sQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782911933; x=1783516733; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=XXVVWGSHO5OhBUPNJsRgu+ydLv5yZynk2j7cpgZvDzI=;
        b=DyxEwzBzR5Wme0Nv5qnluj3obFkmqlgu/rwCqk4HC18412RsRdkko/HAQpZLVwW/e4
         SvoqRHxyUFjYMYcOYgsC7xsRe7RgU7u18gxIHXUfU7JhzcevShwRCah3UWdffELCDJnm
         HUf13hvGTwzmJMAcwlxNZwpTID2Yy5mpryzhfYuOBypMSQCkTR122uKMO5Dre/qVjkTC
         OBuhFwBCu18sA/VKUnumkzmw4PmESZfAOIY5HxzjfrAd+KMzGGsXfe208GlBZGAVeHBQ
         mbFT0SmmBDhxN+n+iVWTB67IhKZqh5KWVsHAmMpPGpiqoPg5tcOG0ecUbG0EanZ25lVo
         AT0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782911933; x=1783516733;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XXVVWGSHO5OhBUPNJsRgu+ydLv5yZynk2j7cpgZvDzI=;
        b=TD5G4MS043w0Snzji3DaksIFfJjyqonEnjYHE3vJMuEwT5IQNe6bRJVquw52sySgwQ
         fP4Cmsgkk6fr53iSRjD52CcJZ30U8gzzhm7g9OGp3Y3LUyjzc6W+QnQFIYbO9+2hU8KK
         nAkauG5fpRjVnsv6PQQCtnVWUXkK6TfD+259pkdyHwpRCdEEDee5wSg+RNylkXSRfqI7
         WZKeJrY+wN45No9WtYfa5OgqN5ZYsa6w5OrV4b4zAwDwVWqTt7tSqf4KXG29rPo8MwSq
         cPNXUgTu4zQoyNaKg2fTtU+UZbfbibH/9HMB4aGvsRMiomjDO/ykfwAJz2AtHbyO0zUy
         fcPw==
X-Forwarded-Encrypted: i=1; AHgh+Rqc35wBNevJNLvAT3mdY5v54zzdH6eBfFswcT4nQXY56lir7AVT+kkFiC5aVHx8VhwSIs3NVs0ifQ==@kvack.org
X-Gm-Message-State: AOJu0Yy5KjB0bwguMRrikpansEwF7DMP136jlRiyCkUhv3yCe/vhm1+n
	ueYmrZeCx+OnecxT8Ez+8drRntNn7UqkZmwZxxHMgPOOOl2TQ0L9oJc5G04lDVfdgQySc2pQKUx
	IaQdtq9dGGE2twD7TV8+vLYz3k0AJ9i/8SRU/hbip
X-Gm-Gg: AfdE7ckaIA/AFG965J+AdQKb1QFxvn7w2M14aIqWvs+HYOOPBVt782F0hU1i1jGmQcw
	s73n0yPWajvlMAn1nZ35g+0UliQq8OCQmSOdR/PYOQmsGrvCGdije9AAiYbYe/OCeOIuwJ/pS68
	GxecnkPf5brbl16aOJleUf/vte2A9lWBIjeLd+Wz5AdQvn55/f1U7b62M30sE6uzZOFqI5rokLt
	+tPOv4LVZnM/5qS8RoQAx7CCCCQQ7u8Ik2qZkH9fqt8jph7eTYzkzm0uvxfxq/TOPjGviPuLBHH
	KpOpImqtxRmFTBdPJIgd++T7bw==
X-Received: by 2002:a05:6402:5249:b0:698:3db4:c1c9 with SMTP id
 4fb4d7f45d1cf-698a2c6016fmr294670a12.2.1782911932721; Wed, 01 Jul 2026
 06:18:52 -0700 (PDT)
MIME-Version: 1.0
References: <20260701125151.352632-1-voytikd@gmail.com>
In-Reply-To: <20260701125151.352632-1-voytikd@gmail.com>
From: Alexander Potapenko <glider@google.com>
Date: Wed, 1 Jul 2026 15:18:14 +0200
X-Gm-Features: AVVi8Cci07_Hc_RXn7ep4JAklNT_D0hDLIzqq9nbNmQVRqW_kyBosTemfoXw2dk
Message-ID: <CAG_fn=Wor0586c077D+0D+NYh+bkhqPhVVzoAANsaLGxbjLpTQ@mail.gmail.com>
Subject: Re: [PATCH] x86/mm: fix objtool failure with KMSAN enabled
To: Dmitry Voytik <voytikd@gmail.com>, Thomas Gleixner <tglx@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Dmitry Vyukov <dvyukov@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Ankur Arora <ankur.a.arora@oracle.com>, "H . Peter Anvin" <hpa@zytor.com>, 
	Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
	Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
	Marco Elver <elver@google.com>, x86@kernel.org, linux-kernel@vger.kernel.org, 
	kasan-dev@googlegroups.com, linux-mm@kvack.org, llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EEC4380017
X-Stat-Signature: rgkiyhprahwwgg8wtydi39ikqjom9rap
X-HE-Tag: 1782911934-471359
X-HE-Meta: U2FsdGVkX196oyYrrK3WosSxk6mvXKOvWuLrxhIxZvfP0HM+03lFh0SRpyDZYKgwMt7i/aqbMXKXr5iIKRgWMqQTuxMelqcCl7bZmGI/PhY8TyTkWCc3Txwu1FhJF9pPJTfLrNT/8/VQg4UhODTlcnbyy15rXGsjh5YMXTQbGVrufXdeqdqM049jflpYxxbKsWCeUWMrGR/bahBxkKzG+9kp/DEY9z047dc3OAEeSsc7aUgXhqi6UwgN2PGWdxfqDNc3R0Hz0Qi7TIRqDN49cDTe2Jsz2OYKzdxV2WJtUFZ0D48JUdTpf01CPWBk58Rkgq6MalPCcne/PNNFB8KhInqAeqn5Rr0AJHXASASv06zT8zYK7f6TVWbD5utip97rTKNShCNPAVv3hZFVF4HeSb1QWopCN5+Aal/UwyciZmdWTn1mpx8UCnrQ3XZnoC0MUjDd53eO1bapy3evR34TdiTYYBpmnni17x8oW+FcSKDpF2GqUtedmPdzsMi3n76YIxPRbDzREGsspL2roG633TEXe7zbnGp+sFLnswK6gfSLOtuwapm7mOhdNKk0gaTula0TGqiXrZET8Je4ezAoE/KQo+caCaJxXDH8s1IP8ZcymisaU+jpqfQ0DizwDzmeHozxHSPCOUW4dNYWMT+r5FqtN7W6kXNYzW1cQC1syF02zQRFg/e/dtNlT0WPjB8i4B8f7Nwm6S/rHM0GNXgWq8ICXwApk83JXpOiLNr1IcsBO+jG67nOXMg6IJ00TfTu2ik5OlfX2YvR/pcorlizsC4PRjkhJJVVw4uobK39VmRODIeBdtq6eRAlXlDFO1i+fuSsCn6gM35aelQWXxjMkLC1avOVe1nLNuHFvYgW7H1JmnBL+HUfaCvksifXNoZOgbLmczQlDxqmnLfRni24OwUcCo0BmgSr7Uj7Khomdfps1Gbo7xaPQut1im0ROa7tNqXQwC1liTlMWMCKYQn
 QHGjGHfi
 jxYmMxK+qoXKBEYbdpBqTpsM8nOb33tKTlXHeJctciSFWYs6zIuBqU9mLojCzq+GUOSIOhyDnmRiuMCtYU/SlhN8HNSZuqCAkQrfEfiJdB9RdEV11jH7uQh14iRuI8MRGl3KzByFWUcLlxnr/PBkCPBJ1ixenzJdhFjO4wPlygyXNZl7DPOGEmaK/kfCtFH8J5iSzhKPbcSMEQP5QkVAPBFfof7x1ucKfIVRBMRWPRVsrnleShTiDGfLVv5i24WxadLDZ3c7TixCZzeUij8zSvoUfXLnVpC6RjBe85Ovke4J/iaDT14rBu7twaHj6dnx8Sqtxp0GsZrygZOeI7TA1FkPTYQbX6kHqnEvQomPBay9itPsupxJVyjl3WLLok5UCKiKHiBbmABO1m0A3WHVf33Ow69/GR59nr3D8cwCuvMrGjrZP9KivRf6sj5B2pojSw17B+3232z8NRkU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 1, 2026 at 2:51=E2=80=AFPM Dmitry Voytik <voytikd@gmail.com> wr=
ote:
>
> This patch fixes broken builds with defconfig + CONFIG_KMSAN +
> CONFIG_DEBUG_INFO_*.
>
> To reproduce the issue before the fix:
>   make mrproper
>   make LLVM=3D1 defconfig
>   ./scripts/config -e CONFIG_KMSAN \
>     -e CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT
>   make LLVM=3D1 olddefconfig
>   make LLVM=3D1 -j(nproc) vmlinux
>   ...
>     LD      vmlinux.o
>   vmlinux.o: warning: objtool: folio_zero_user+0x801: undefined stack sta=
te
>   vmlinux.o: error: objtool: folio_zero_user+0x801: unknown CFA base reg =
-1
>   make[2]: *** [scripts/Makefile.vmlinux_o:76: vmlinux.o] Error 255
>
> objtool in verbose mode shows how the frame pointer is omitted:
>   make LLVM=3D1 OBJTOOL_VERBOSE=3D1 -j(nproc) vmlinux
>   ...
>   b15a2c:  folio_zero_user+0x7fc      xor    %eax,%eax
>   b15a2e:  folio_zero_user+0x7fe      mov    %rcx,%rsp
>   b15a31:  folio_zero_user+0x801      mov    %r14,%rdi
>   b15a34:  folio_zero_user+0x804      mov    %rbx,%rcx
>   b15a37:  folio_zero_user+0x807      call   0xb15a3c <__clear_pages_unro=
l
>
> After the fix, the frame pointer is back:
>   b15a37: 31 c0                       xor    %eax,%eax
>   b15a39: 48 89 ec                    mov    %rbp,%rsp
>   b15a3c: 4c 89 f7                    mov    %r14,%rdi
>   b15a3f: 48 89 d9                    mov    %rbx,%rcx
>   b15a42: e8 00 00 00 00              call   b15a47 <folio_zero_user+0x81=
7>
>
> It seems the issue was introduced by
> commit 54a6b89a3db2 ("x86/mm: simplify clear_page_*")
>
> The actual fix is to revert the change how ASM_CALL_CONSTRAINT is
> positioned.
> Additionally, reintroduce asm_inline to prevent potential compiler
> rejection of inlining.
>
> Link: https://lore.kernel.org/CAAX90H2_RPnZL_dFYN7cQF6yt-wAweKKSx2=3D6e2a=
Z0kv+Pm+NQ@mail.gmail.com
> Signed-off-by: Dmitry Voytik <voytikd@gmail.com>
Have you tried running KMSAN with this fix?

I tried running with the config that Thomas posted at
https://lore.kernel.org/all/87tsqjq3i3.ffs@fw13/
(https://tglx.de/~tglx/config.fail), and it still hangs for me.

