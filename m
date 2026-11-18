Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50F26606A33F
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 23:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0pl1I6QK
Received: by kanga.kvack.org (Postfix)
	id 3AA5D6B0652; Wed, 18 Nov 2026 18:45:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35B036B0653; Wed, 18 Nov 2026 18:45:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24A096B0654; Wed, 18 Nov 2026 18:45:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DF8586B0652
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 18:45:55 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 61E3A80917
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 23:45:55 +0000 (UTC)
X-FDA: 85449875070.22.D100700
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf31.hostedemail.com (Postfix) with ESMTP id 76C7F20008
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 23:45:53 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=0pl1I6QK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795045553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0Mlcn6Z7k5JuV2YJbcakE860i/4laekzSJhBTVmexSI=;
	b=TgkIfItK8LnBd1QF9Fpl/DHCMeL3JQ2UvmaK4fXYP6lTjvLMof4/NrWfSdDQELGOwf3L7L
	YKk3dIdTHZyDSi64mZ8Gk40XtK8EYgn4OGcpdoJw1t0TZOEvsMWgITH+ZrMudTGXoqmTOc
	YDASWW8apXn54HQOwQhfq2owThn4bqY=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=0pl1I6QK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795045553;
	b=prZyKfYk6e+PFWM0ansuChYz8103gHyptLS1yAYBKBsx/ctriu3OFNwao3IUiSjoS9JMLv
	zblN3FYKnrUdBBqjkPS8tUtix8AQajvjUbAJn+iUCqh4Z8tpOmx/JXfcvOqVeXBltzNNi7
	s7rky/cP9KTyx90c64a6gYIMhxwI4Ps=
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-497614c95f0so992532f8f.1
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:45:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795045552; x=1795650352; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0Mlcn6Z7k5JuV2YJbcakE860i/4laekzSJhBTVmexSI=;
        b=0pl1I6QKGwlAdGIGaBi+rwGykVsuAXTans1pp9X5RyD8hTvxtRvQ4n7XCkLPQ1A2Dy
         4uRc6mXhs8lVOzuHv6Kwxz8agLa+s8seERKQAC1u1uC3UVVALU5TnWTP02rYzNMsS3EI
         6WuckhSFTYA24FXj9YyX4Nxa+j5BvOJi0gHEr5uChHGV96zmQZm+f60JZb4/iedZlmGC
         CpouTtEwjDHmOvnPdgt0ZIxH2pe+uQtOXtdCtDfKK1LDgSIeAVMd2MrznM+gU9r7hSnc
         ZzjiAtMaea7l+mYURKmehw5Eg8HKB8ymnLYR1VEj+2yydEGLCZ6mQ+hKBSvICcimlBSP
         l0Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795045552; x=1795650352;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0Mlcn6Z7k5JuV2YJbcakE860i/4laekzSJhBTVmexSI=;
        b=kf4yHPN4gDjqa1O0s5Mu6U9fTsH1+kD6gbnAfuOc3eUNPnqQsW8Hf0RuGcgb9f9xVZ
         DowqqARDE0EyMLMjVjL3Xba5CxPoF0NDCmzYO38DIntpqytmJDWxEQpnJ4zhpV1ONTrd
         vk1zAhL0l/7EwZLacya03mGGRh+GYNYwn6sKWlk74sig5by/B/NSxATpoJHLpWxsgXgG
         GbuOe4C4FpwHquUDI91F4P9Iqo5oY+XpsMvgu0myFt0zNmzXHFO0TwXaZusTqf+73QPP
         A5XrBf3/bxrZ1mSWaB1kASAQJi9QsjnER81Y7YIqkLyOxrUp+YVoWe7hdAOzU7Fc1FKr
         tFDA==
X-Forwarded-Encrypted: i=1; AL+hErETSKDhumnMyBFnNIDSr8Dn0AK+rJV6glyUTgZKGb4qlDLLbEcQ9WhRs8YAcZBRW+ajKzJflFrn4w==@kvack.org
X-Gm-Message-State: APuU4Z+vLVWP1iw1L+eXVH2EA5Sr9/loBEuSg46PWhTCQNbOs+fzgxZS
	7gl7xN7CP1LGtopFXTm9vN93tKY+QG7Mf+hhn8V3pXhMb8bnCKzaKhRk
X-Gm-Gg: AYBFou39IAd7Nm0G9V4/eaKUb8/xMjhljumGFgcatI3530hZqaeLqWsWFv9GajYoF+j
	xZCDZGWq08UuCUqC4hbf4TAfu0PP6CI8ygYRhLXhGiGD+7dOag67cJtE/HnKXO81ArHjJN5Y9Ar
	AELmZsGTQELI0yVFaJ9D7nOTuvD0cdhKFCccTsMpBaDfqHMiJ9NfB6PvkO8B6dWfBKehEze3u7e
	AyglaFM7Dwjc+xzgW5+tsax6RY1ZIrPV8V09Wu4LwawiwwMbpC936RPhW8cYti6M2Mdq9nkb0Z/
	BJpYE/t3QiefHOwZ8CPcFv0YYCDy8Bx0ylvpsKcirY07TQtBF+FDHfckuAlTQaRgJ0DFdRRN7Jy
	gNS16Z1olUxWFIOWX1lT/8EEd+0Ad8MiLvxUrWCX7BQ+yqe+RZ1d4DI9jBeonWkVBhzeIlAB4Lu
	VV9maRfE13mCArD3b+zlMLkuzQZfgNUH1p0PsLHrTQDSKdQ29QCWEkUU1y69xWTs+rf+zkSXsOe
	AJEbNulOxeVmbx9VoYprSJAILT4BJyDH4SipN9s+nogpw7NdZcZf05HSf+eTGirgkKTxKd33KDC
	ePM1MIndl/U/5N6bznRwE/I6VBhcFuAEqM6J7ZCV/lkfqQ==
X-Received: by 2002:a05:600d:82c5:b0:4bb:693e:4c8e with SMTP id 5b1f17b1804b1-4bb7da270bamr99102465e9.21.1795045551572;
        Wed, 18 Nov 2026 15:45:51 -0800 (PST)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4a6573baaaasm7674415f8f.58.2026.11.18.15.45.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2026 15:45:50 -0800 (PST)
Message-ID: <20a03718-bd72-4df3-9563-1ade7747ae21@gmail.com>
Date: Thu, 19 Nov 2026 00:45:48 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/userfaultfd: check exclusivity of the page being
 moved
To: Eric Li <nakixii@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Rapoport <rppt@kernel.org>, Peter Xu <peterx@redhat.com>,
 David Hildenbrand <david@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Lokesh Gidra <lokeshgidra@google.com>,
 Kairui Song <kasong@tencent.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20261117212400.1890820-1-nakixii@gmail.com>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <20261117212400.1890820-1-nakixii@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 76C7F20008
X-Stat-Signature: ea9q5z1q9sowpakkbaxf15eqn7gfsym9
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795045553-873364
X-HE-Meta: U2FsdGVkX1+1/4bM6sSJrM8KLYx1fdAr4P7rQldCwTffiZxqTvkoQX/Kwny1ONMrIwxG4usqUKk+S/ocVf8vtfBJ33aKM4LwPyQe9cDoyHv+0igbVxvA+wfLegmiN1X+0HpwbKog/0g0gn9v0+Cr1G1JLf3gKBlHeKrg1OaS3rUGL2mEkTv1u9d4fy7wjdjyd0l/tNMHXD3OombqPXWgbPG7VL4d+X+2hSFJT840aDUFOmQfgf8SEj+KEYe8imhCmMlcztx8QUOM1UMZUsQFSdniBIiWCJpUfJAhRES4/dwzp4Ao5Fi79J2GhZ66C7aH9fd5q1Xar5cbuwXkFOwstWLGOiRuUxZTzgIt1dnOyc2pRprbOyguTtZU5RqFrDYxitJzdOgtv0NeVCZ+LStr9VaV2cifI0+hzAZX4D2/aIabgFIPxm1jvrUVqBYS1cPwcixdkTlex5MfFieu28wCz7Eq1jY1vHJcEv8Hk7bFGj5pbO2bpBdBvDSjEh+/vaVe2SdCR3VqbM6xHP8zitPWKJSHuwqENx0f9z+Uq1TmywfsEPnyCLer5/D1kE56EaV+H5MZMZsoLFV4JT6kR2Q/qG8pr4b02YnYL6HspxhlSnxxNh3EzjmSbVmxzbmvOrMJ7XrDSCQ8aflUY3wGFF1sYK5clZEGNg/pgujvfwcAeiY9KhLOTikG7Yn4OVbAM804b9N1dE3cNBYJ5DJyPsMNNoX19SH5L0NEF9HGcXFUNxb7Z3Dl5pRIj1YQrw3Msw6XUY697X2r52vd1Cc6r7e028Uwn1l5fUNAnTtpOiUsVzV1dkcjbGVHJN+iEAg0YosnXQTkmZw47u3I7iYoRZxODjtOc471yhroCXoLLhjEgwH9ZuwSDb/yLlZ3WxfTp6IBI1R9DxPPGXu4KRKI+HyRlk+sLvaoqycZTkvMP/1nSlqer7LxCmWtdE1z9/wfL2a+Gt/oVk3AxUecmAGBHVg
 gmGmEaMJ
 d7FhQa6A/8ZWPG/W3/M4OQJNC2MJFspzJsutMGbQJNaPqKgiB/zpv9664nH5OQT/M2UK3WUOHHyAN7MY65o0z+Ee5qkJXFp072ejdZwB5PBL2n3Agd/VPmip44cryhSr9ZUHY8oCe/xiXUrDsSitf5b6GIyNu0b73iSdE+9L2PBWWNqrqamy+a25V/CDrXe5NxMT6XfsWd1XduuIycjwy5KdpIWiDvua3CJO9Kg7j8+ORbNI2VOe0+h3k/GnkWvAij7+oBwZgHhuO7Z1B/KKq2z048uit/+4+EVGz/wt0aDtL4adjsFqxAPKGeOWkrXmkKRmKGyWP6n0KzLtRFr4WiB6AdvXnuCUa0YMVZ1vJT/KXcggZm+FD0rmpL5ALlQWBDu+F+pXaoJd7eHNgT+Nnc4cktVCinpz+yhRt9jrT5sYGHdjGUvjzSQCnkdIY+ohgvpGsOWSrXI5/09vCfybTR6sg6i0IPAXQVQTfadHZhwPwxDY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/17/26 10:24 PM, Eric Li wrote:
> move_pages_ptes() gets the folio of a present source PTE and then checks
> PageAnonExclusive() on the first page of that folio.  PG_anon_exclusive
> is per page, so for a PTE-mapped large folio this can give the wrong
> answer for the page that is actually being moved.
> 
> This happens after fork().  fork() clears the flag on every page of the
> folio.  Once the child exits, a write fault in the parent can reuse the
> large folio, and do_wp_page() sets the flag again only on the faulting
> page.  This case only exists since commit 1da190f4d0a6 ("mm:
> Copy-on-Write (COW) reuse support for PTE-mapped THP").  Before that,
> the same state could already come from fork() after MADV_DONTFORK on
> part of the folio, or from reclaim when try_to_unmap() replaces the
> earlier pages with swap entries and then fails on a later one.
> 
> Moving that page with UFFDIO_MOVE then fails with -EBUSY, even though
> the folio could be split and the page moved.  Callers that fall back to
> UFFDIO_COPY on -EBUSY end up copying instead.  It also goes wrong the
> other way: if the first page is exclusive and the page being moved is
> not, the folio is split for nothing before the retry sees the shared
> page and returns -EBUSY.
> 
> Check the flag on the page mapped by the source PTE and get the folio
> from that page.  Locking, refcounting and the split-and-retry path stay
> the same.  The batched path only handles small folios and the PMD path
> already checks the page the PMD maps, so they don't need this.
> 
> Tested in an x86_64 KVM guest on mm-unstable with only 64K anonymous
> mTHP enabled: map a 64K-aligned region backed by one large folio, fork,
> let the child exit, write to the sixth page and move it.  Without this
> patch all 20 moves failed with -EBUSY.  With it all 20 worked and the
> data was correct.  Moving the first page right after fork() still fails
> with -EBUSY, as it should.  Writing to the first page instead and moving
> the sixth fails with -EBUSY either way, but without this patch the folio
> was also split all 20 times.  The move tests in uffd-unit-tests pass
> with and without the patch (the two swap tests were skipped, there is
> no swap in the guest).  I didn't reproduce the MADV_DONTFORK or reclaim
> cases and didn't test arm64.
> 
> I found this with Claude Code while debugging an out-of-tree swap
> backend, and it wrote the first version of the fix.  This version, the
> changelog and the reproducer were also done with AI help.  I've reviewed
> all of it.
> 
> Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
> Link: https://lore.kernel.org/all/20261116110122.309748-1-nakixii@gmail.com/
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Signed-off-by: Eric Li <nakixii@gmail.com>

LGTM:

Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

-- 
cheers,
jose a. p-a

