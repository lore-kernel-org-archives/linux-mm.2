Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87E6160A2606
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 17:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=BfQrv/oO
Received: by kanga.kvack.org (Postfix)
	id A5D5B6B0533; Tue, 20 Oct 2026 13:06:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0D4D6B0534; Tue, 20 Oct 2026 13:06:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D5506B0535; Tue, 20 Oct 2026 13:06:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 61D7F6B0533
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 13:06:02 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CC6401C31DD
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 17:06:01 +0000 (UTC)
X-FDA: 85343632122.02.74374FC
Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	by imf16.hostedemail.com (Postfix) with ESMTP id CAAF018000F
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 17:05:59 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="BfQrv/oO";
	spf=pass (imf16.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.128.171 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792515959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CawfSGUltcTxf3WieqiwxZVbLh4EPDpBCzdr6aE2BVo=;
	b=tMBOvVdcnyvm/6Aqh1jFQTAh7FhIiAW6x6RKPvcHap4MdQLSYqn4pfMcRG5D+EWrLRU7Ag
	YF9ELgK/o8lEMgtA9cusLJrKFp3cJAV0dR/E7wUcvW0jVuohfs7AAZRyoNC4kBSPuPN4EF
	woR2Ea8+qjjsJLxBocNKjE4gHFSvlkY=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792515959;
	b=FquDKmh640qWLyHFX2sal/jY7jyb850rhGy7HqQpi0Rra+/8YZcyNUluo52ftOU2bgL7kt
	qYC4n5y1eM4YBR1LoHL2WwzdgAQhCjux1uARF+gGJygLMJVIo8CJRpBpG+dnNP15mO7JTZ
	pD/7ukssWZxM6d2uimq00xy2f6BoL18=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="BfQrv/oO";
	spf=pass (imf16.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.128.171 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-8b0e1b91607so3881297b3.0
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 10:05:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792515959; cv=none;
        d=google.com; s=arc-20260327;
        b=iXLYuZznPZDowtBJsM02ZbDZA/rHiUQFvCPXnC2fQKLcnLCJkdDRKNQGY6CdnnxXn/
         E9GpTrSHs458Y+PPR2ugrk+eTlV7DFUvK9HZcHyeYTgfsHfoZWPWuJBuASGBMqSsQebt
         InLOWjNk+oEvhTNZO/qrvmrLcW+q1bM5oTYvP+9tgeCv2gbgg53SyL+FJNm/f1LUt1hG
         RWtMKBj4w2tZzvHgnoIDH0FQPKQPifU9ZXg77zv3P1VbMfOoiaI3804CqZkUdUbyhx/f
         IS8he7B4sY658JpAThgBnwjvRY6u0T+j1Z+X4HVzPM0ZpAi1tSY/WXyvS+PCwQQSZwNi
         kqvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=CawfSGUltcTxf3WieqiwxZVbLh4EPDpBCzdr6aE2BVo=;
        fh=eZxRn9Vu+Xp/NggctIYpau0BhRBiDFRB3db/p6ZzPww=;
        b=JwKXNmSCybd0Ms9cETnnCFjqmgnWoWqMnqVrfwMxMpiQYi0ad2FZyzYQhIBKl5iW5Y
         NGZQwo25OEZ81nPFCNFE4qMZ9K4CSzIt9nTzEnBHozd7OcWi+HrYZKzDC7HC0WMsa3+e
         Oe2+W1ZaZRdm4blhD91qn2axBxy0TwUBsOpX41opinLlZLvTtxR6iajHIoyOd/2Jee04
         vcemKDPdJKYkdNipucNfH+tpvlAfZ9AtJefI/GLSBZrzk2cRVOH6VNQQ55jNxEyboeqT
         k0Fc/P7p6gfzSVSL3eHBO//rBoiFDc/Bkl2gtX0F6WzNLNDpUnqXzl1dxUjqJLwuXM3U
         BXDg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792515959; x=1793120759; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CawfSGUltcTxf3WieqiwxZVbLh4EPDpBCzdr6aE2BVo=;
        b=BfQrv/oO14/vscSFTTAbZtEMaTev+7yNrjZ/JzTQud3Kk6wybxk3UJmkUXEByevsiy
         LLqkVVCNaUSpIzO4BJFNCc0+b82iBmaBMOLMGh/aHWct+RLZSZyPXNX7chMOJHdI4LRk
         zoTdKYCRiwoPOREiyYU+10f3/9GX9gIpoV2Sl9CKdTZfxRQ26YzraZpmknhYHQVDi87C
         39QrKbTUodhSWQsCl8UUsJLa0N3n2A7Ve8oKACdLezRqMoE+CLAhgl6QLtQUZlwslOo1
         KhmlDcPCpTyDVaa0MsjGBURGC1Kv1qI2m4lwzrARsmRd6Yzg4TWISRCy1t299h0ie5Za
         KbIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792515959; x=1793120759;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CawfSGUltcTxf3WieqiwxZVbLh4EPDpBCzdr6aE2BVo=;
        b=a0g2Y233czmkFWleUsdXnGzTP7/MEnK+0D5/LNeKqKjJHsba0E03BAIfglOlUy8SSi
         dul0K9F3EKU8EGTNly0+DlBpOgRu0Uqz7QVP8KwUGU1Vv1m7LEAoswRZkpIESe30iN8t
         gwbNORPVpbIjpmt0sXxhhmHrMZY7cv97N8a1e7eVArn6vmZJwgdWgZUzIxAFgZotAfF6
         W/btE4wfTKd2d6DkhDIzhyilpw1C2FMBvFXrj0dEZDLx2FxuluOtou9uRtlvHKMbDsc5
         FC1mOBNlx/wgtHUuqKjvirBJt4eiVM4cD8txOCabD/4bbAPOIAqe00j2qLSr/QExKA7X
         WOTg==
X-Forwarded-Encrypted: i=1; AKwUvBzG234Zhc1WxeYgzxY+HsmbRiBNjpuqQFw/ZjFVXhxosfRhPBgxkSk5UP0GnIAWBr/+uNqtkI/5dg==@kvack.org
X-Gm-Message-State: AFq9FYK2f+tlMMv2elWpJGLnfwlM+NgHSUukYbhwEo2YoKKn5zbX+mBt
	0KAYB0PUklSugpYJjBzFRbvI7pmtZyOGOdpuDCRfZ/vMs/LuGYWkCoqs6m4IE8b6u+W55wtERl7
	g+f3/5WVhg1OynI+MH1bp1yjbLptko7M=
X-Gm-Gg: AYBFou3ambvC6ZgGZRMUiF+4u3Qo9LMVI4mluJht+77VYr78tpzJcCR7YKiRQJvDAxr
	HoaOcoFHRZPqAVRMc33TivoLVLYOfIjbHS4nBtBt1brqNlLu1f1s1jtCIFUQMTtehyY4HLK/tmZ
	ZHiDufng4jK7qBtoVa7gbZ50Cc3FRZMu+rxK7IVRQT3OkSAalQytQkehtenWwstU3seOklsRQUo
	mbVeQprZMpWVr46ASUDn5jXDiIUrK510dpjhLVQYyptMsOXkMvo4mtwtMUYIIXPw8/dtuN9+f91
	yZ95Kvrc1DONDIUTanEU8G44qsOr/AIb+DbaernP82s2scQY1fcaNw==
X-Received: by 2002:a05:690c:6087:b0:8b0:da84:d1c1 with SMTP id
 00721157ae682-8b0f1f1a89fmr64960787b3.0.1792515958898; Tue, 20 Oct 2026
 10:05:58 -0700 (PDT)
Received: from 95991385052 named unknown by gmailapi.google.com with HTTPREST;
 Tue, 20 Oct 2026 13:05:58 -0400
Received: from 95991385052 named unknown by gmailapi.google.com with HTTPREST;
 Tue, 20 Oct 2026 13:05:57 -0400
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
In-Reply-To: <20261019-bug-word-at-a-time-zeropad-kasan-v1-2-f21a3ed6a477@gmail.com>
References: <20261019-bug-word-at-a-time-zeropad-kasan-v1-0-f21a3ed6a477@gmail.com>
 <20261019-bug-word-at-a-time-zeropad-kasan-v1-2-f21a3ed6a477@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Date: Tue, 20 Oct 2026 13:05:57 -0400
X-Gm-Features: AclHuK_DtrU2XCq8YwSMY07NqOt7wGt-hW6PGZPkgwrcRUr2dimhQIUPQ6PwL98
Message-ID: <CAPAsAGz89aKUHzm6U9PQZfkGq-GnWsm8AYHeo5+4u34LHk4uZQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] kasan/test: cover load_unaligned_zeropad()
To: Qiliang Yuan <odys.yuan@gmail.com>, Russell King <linux@armlinux.org.uk>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
	Shrikanth Hegde <sshegde@linux.ibm.com>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>, Marco Elver <elver@google.com>, 
	Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-arm-kernel@lists.infradead.org, Kees Cook <kees@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	kasan-dev@googlegroups.com, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CAAF018000F
X-Stat-Signature: h8y9iet5dngpxmg8xck7ny9okgng1cf8
X-Rspam-User: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1792515959-530081
X-HE-Meta: U2FsdGVkX18mdYBcVcCWAhsSevH0yyt4u9Tc2A/6iZhhGvO/LlZchvageQulaVwDmkPc6erMscMZw6Lz7tcNKxMfXx+rxA1gYSVHhO73vJtbpbMxzW2V9QQDocMi+p3jU97xNCmiFdtKmlZic2n5rGuGqesEO1QCueoHCZQzDKYPdPzlIY4S9q776ji11/TdWlmM9ww9L3FUsejvMSdxxPgumAb2sMWE7/lvAa21mJPDjOc18KLvytFr7tpo+PjnGFaK74NL/IKBGDnoMbVOqaLjYQvPk7MamUpyFis35YU1POfTgtn+k7aVn4T8v8onqxPf5HKXz7bDFGh0MswPuvoprWyAWl4KJ9Z1wnui7RalfBUmI9U5B8uXntImQRtA8XLoL4gjWzLZOF/OC6ypqf+lAgJFVSWQuEbt7xe8sRwo4yEzUJASYRmzOYwrLFui3tNI6zu02dRrNVqJPhAPgAHJy3zgRpZxvxORnjtb/sgVAfJvQD3DmlexUizHlWJ7hZyfDHISKw3gSA2N9MWOl+0sJ+sCkINEgG0GhEDsvdeShT94yNZv6OlNuDaQcAd65C4BG8X5Sjkt+ljTD/MsvU1fojmcl4+dxpjbsPMSLVnnZWm3BDKp00sMW/wrAg1xfo39mOW0iJM/yS3jqcpFZaUoRguU8CyeP446rTDRGHIql8HsnzFGUVYZ70V9h1AWe0jlIEYOTjr7aSiKd343gT5Lq2B7yuu0YhtfwT1oLmKbavucG9EDtYNR2o7+urcgWsuGnemc3XGY8hTYozXcRcrBHLKJeHdfkgTVPPOuRvSwO/iK5De1KbvdO9LmzkC3vcBFSVesPvSjmNc91cemENcnUVviiD3QtKHQYFwdn1EBcdNx96eUSwMUsljRtj/iDHixl4LBqep8v6hQYdYWo2sUMzDbAfThGgE4zTPKzeLiz1rYDPVk8GvV5izZBUoH/UL0wdj3dPAEZ/yd5ze
 NNuacr/H
 8Wk++qIVj+2s/OKyTSZZK5rUv/f3d04NlkhJuX5Uous1BlGUbRMBwA2W08Xe15DjJSqnFE196sfr1xrImL+DzNY/WkaVj1XqrlugafUEFN6gLb/41UQPihZimTpFIDoFL1ZpS/jDqaMrqwY23FtdBpgvYLKhd4cepbMNwxVoqDv43FYaJUKE33Qecy/ciMiojxqV9nEc9VYa+ki4NniLLV/2Qdl/yaud8QUBrriJAg9SIfJWGOyWSqlDjZPcVV+lQeBE91ZnFg0cCNmp27dXrE2cgN1uLD3qZz/R4oLU8hSofwCDmGf7g4u+HbAKp3gCtOHA0SYNjWZscgU0t9LY9k45KW9ivW8HNxoNbXtzfi/dSW08qw0lRq0yfP+R0eqkHi7rhR3iAqLgmVFdO70gjPn/uhlJ8j0sreHqxZOevOWd/fZLS3CYEFS2rmrlVvKmMwMEnpOiiDiOJyCzw/doElFdVEpCR2XvgVNuzoyr3XWyc2S4V42/5a4MwWtzgDnhvDLi+zbBdw0yj4MH7FXy4W1hdF1LzRui1/i9U+Mo1P/qqtT4vljYwQrwL5cLrgPL9f5RMAG4Fex8mu799GllBPdLIr7XspIX/f4Ed
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Qiliang Yuan <odys.yuan@gmail.com> writes:

> On architectures with CONFIG_DCACHE_WORD_ACCESS, load_unaligned_zeropad()
> does the word loads of the dcache name compare and of path name
> hashing.
>
> None of the KASAN test cases reads memory through it, so nothing
> noticed that KASAN did not check these loads at all.
>
> Add a case that reads a freed object through load_unaligned_zeropad()
> and expects a report. Skip it with hardware tag-based KASAN, since
> arm64 turns tag checking off for this load:
>
>   kasan_load_unaligned_zeropad, x86_64, generic KASAN
>   without "word-at-a-time: check the first byte in
>   load_unaligned_zeropad()"                                 FAILED
>   with it                                                   PASSED
>
> Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>

Reviewed-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>

