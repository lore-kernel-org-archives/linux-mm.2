Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E533C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 06:10:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73F156B0088; Tue, 14 Jul 2026 02:10:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F0596B008A; Tue, 14 Jul 2026 02:10:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DF446B008C; Tue, 14 Jul 2026 02:10:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2D2216B0088
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 02:10:41 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A82701A0294
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 06:10:40 +0000 (UTC)
X-FDA: 84986358240.21.CC0C130
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf07.hostedemail.com (Postfix) with ESMTP id C274340008
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 06:10:38 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=W5dWxMJo;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf07.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784009438;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/39pAIw3xbpK7+U4L+xZrNR+VURZcoyTnPopnGzZ1Ao=;
	b=ktrAHWXLQKqE0pVvI+qYdWwFKleEG98wB3xep2Vv5CiqK/wOxygMK2RvHKuMKYKdesDEpJ
	wVQqzKWofitajRqedAv3jX5WTWyLkDIbctBNwLapTDbTBtI6FYQeQWcRuRrWOWiT6dGmhC
	2TZTpqalyA7rj0xG3XZ2j5HZi7PRUn8=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=W5dWxMJo;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf07.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784009438;
	b=eAXWcXY8udDoyaVDlI2ad81DUjewMcQsyDN9eA29fuI5eG3s5mN737m1WV/oh/j4d/imO3
	d4qS6WNXdI6MjLISR1bUyzz7Zc3WKW0oAs2ksc8nShP60SgP0HL37nPU9hPFMUM16ZfJ+b
	o3xZpLsIoiZMRDEU1PKhiiFAz7fqArM=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-493ec555a26so25090265e9.0
        for <linux-mm@kvack.org>; Mon, 13 Jul 2026 23:10:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784009437; cv=none;
        d=google.com; s=arc-20260327;
        b=oAQU4wLI2xGisCiVMwzlmlOZAoKeeoKJEeses/EJ438r08K6enJnrzcORr35VOBcmU
         3ZRsvIeQFoBu3UecrbpRuVnR1fiTBOT08cijhvgS3TOlHAb0TZEc6uUvriTCibfy/cjb
         DnXoKPlx7VKURCBB7r/83jhq6Rck9ycboDzTucF5l1uwosC1Rc9gGRnTZNakxeCzWWbi
         +KusEVgbmFUPBvOAwB0oCgjUEkYem6xDqwT1f2Mu52DQlsXa0jEq6PWqpCfMhtDsfPfK
         gLaSVBlICachW3viMTCih8Ipu+XUAtmXOtjpqoenYRatzsZ8Z0mLa8WB6+ncqehTwpCs
         MQIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=/39pAIw3xbpK7+U4L+xZrNR+VURZcoyTnPopnGzZ1Ao=;
        fh=cUrf6M/5e+2fWZ8nkxk6WmRd/eZLnecFNnr2YxBs6QE=;
        b=S1BqXxxZda4DzE/QlMsfujIHfsI9ULgj5Ty0YGq7kaNTiyUgBBgqwvjJ/pTeD/SKBw
         3NPGdJd+UG+LtZPHvHh5oLJtOhonMuaI0oWpQxDozK0C9Kbk/9jZkCNg3n3C29q4sg3z
         RLM9kE7rmq4eBV6NCCjRSRHv7BDCdO7cNiYmQVZpe38/mJWbu+VZKHgTtFSUI6XckgJw
         UD5bcgDVr6ixeMy6d/EmNhBPZi9cxfSbbsX7l1G7BZSYeoB8gxXQm2fHtuLtvaQ81ir/
         XWDnFdvRsyQ2G9gK2HeRpHSpSL04Uk4L03vSA8tOOTZclblMoIp2HpPYLmE7ZbDKVrnH
         6EVA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784009437; x=1784614237; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/39pAIw3xbpK7+U4L+xZrNR+VURZcoyTnPopnGzZ1Ao=;
        b=W5dWxMJoqmvPlCMRnTlFSizETpOwEVzIQqgfZiZbx5aECAvwLsYNZt1fINLEwBpm7R
         Ogdu0CUonVVfqhmYiCaCWfFMmeNlQ8FgZ83h7f7e84wM+bY4D9Cf1hPbT5xUzYX7L3vi
         qH2jsZuw8IrpxjeMQTYrsrXLJQjX8ggzoShKxX29OlAMtYyTsHnZpATOVeOpIKWjhTq3
         eMut/gNiAquf5DkE/lllUhDrwLBGyJQGwlkhCy3Fq97mMwColFA0dVp/mNtb6i4ccQCx
         zupqBGbHobnLU/deRB7qhBt7mqA37XCVBg1glJ2im6WndE350mYSCt/oxCPnlTVyzbDt
         WaOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784009437; x=1784614237;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=/39pAIw3xbpK7+U4L+xZrNR+VURZcoyTnPopnGzZ1Ao=;
        b=is6JNuGRJ3H2/oF7i97VMNyCEIAGNzoOZZSgpsiP+W+LpCenwM5epqcNTlp+4LVbKw
         SkTLkJn44X2T+PjTH6fdidjcFspJfiyyRP6OhMUDyAg20bLJU0Ueu1J6rAiAkccA19SQ
         sexZzpCpTBdQNPL+c6Fc31h5krxuvvdVCYKR3CQxNwpWk92Ty8aHPqkboPCku2HXnYyw
         vh41V66qdZuYWqcPCPdmxgOUpTh9YhwkFmjkQqaeK8QCpcUkn0mpeRwlOAbc3e6ktL2p
         nSL7iZNAcbq50QTHYhBA/RxnoVvorEcOmPwLyioFI0USz4BROeuBRn60IyNKooriARWd
         4WWQ==
X-Forwarded-Encrypted: i=1; AHgh+RoJkPZ47nTixmwb75mOqDcfLfAzyXCPat9KBcQuLjjv6nCwUZkBenAUU1CpPk5i6H1bYW2Y9HCreg==@kvack.org
X-Gm-Message-State: AOJu0YyM9c96ATM/Nlcv4ZrgkM24gNhA/EYWNz7uan6HwHkHHyb9oPxH
	xuXSKQAGrbWCswCFpii6bgnhvs4hD+hAbBGwSLtlEZTObLLhy8r4s+30W7I5WqgyhSJevH9tyuU
	s98sI7oL99LdgN+U5tPqXA/hfpl580u0=
X-Gm-Gg: AfdE7cnZ9/iYI5SklR63z3ppBXHkFCBvWMG6phQ1D/3gKklKS1y9RvJc5G5zPe645cw
	iZa8Z9+2K0vmsWx63vlp7Zi2h3N1EUloQd0OsQ0xvxNbdgLdjgIWqKp95IDXIO/x8Iq3a4AJLiC
	7iDjhkx7Cm3CqTj0MoOpaPGZfphiCQFxmayFLgJyvsan/JfG6RtBO+lPoOCs+HIS0CsZpWMKbJQ
	APhJiVoRqRgx8sQ1Y8nK8r51TjD2HWJH7l8mu5TgqbTqWaY/3x8K6Rplp6JTrJWEiglTi2ZSw==
X-Received: by 2002:a05:600c:5392:b0:490:b00c:8e6a with SMTP id
 5b1f17b1804b1-493f8826bbfmr118663245e9.28.1784009437267; Mon, 13 Jul 2026
 23:10:37 -0700 (PDT)
MIME-Version: 1.0
References: <20260709073823.6643-1-jiangwen6@xiaomi.com> <20260709073823.6643-5-jiangwen6@xiaomi.com>
 <85a3a79a-2a78-47ed-bd93-48e8f1967551@arm.com>
In-Reply-To: <85a3a79a-2a78-47ed-bd93-48e8f1967551@arm.com>
From: Wen Jiang <jiangwenxiaomi@gmail.com>
Date: Tue, 14 Jul 2026 14:10:25 +0800
X-Gm-Features: AUfX_mzEw4BXfhOZBlRoqj1kqHJs057Yw2Bpm2f01kvdPVQVUYHHnqLAY8wPhow
Message-ID: <CAHKocdH0KYPaqkTOEE7n8vX4BFdgPvVbRsh3Vtb6MtvmCTn4XQ@mail.gmail.com>
Subject: Re: [PATCH v6 4/6] mm/vmalloc: Extend page table walk to support
 larger page_shift sizes and eliminate page table rewalk
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, catalin.marinas@arm.com, linux-mm@kvack.org, 
	urezki@gmail.com, will@kernel.org, Xueyuan.chen21@gmail.com, 
	ajd@linux.ibm.com, anshuman.khandual@arm.com, david@kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	rppt@kernel.org, ryan.roberts@arm.com, 
	"Barry Song (Xiaomi)" <baohua@kernel.org>, Wen Jiang <jiangwen6@xiaomi.com>, Leo Yan <leo.yan@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: eq16tictedss8hftrf87z4enngrtj5ko
X-Rspamd-Queue-Id: C274340008
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784009438-203930
X-HE-Meta: U2FsdGVkX18epsW//txjVGI5ztlhJZeqM3X+4G1tayfHvO7T4r9c4jPzvCD2YjHy3vOok9SgogXXIA+ASXuMGZFmohLxWLilknYNBp7tVLebhWdkz3b5CoG6TuM12qSKdhELlyez7BagVQ0d98HawRAOAf3jHLCxvb4pHrN2sfuNq1eHOMve7hcN3i+9c36HhI3RPG/RD88b92tmanXZ6qCY3xOCSjTKCHIJ7WS8UQ1zyvrmMXudM59Es4pwxWsADNb+cE5n/dvFU4Gi905X/Gtlj8eHlUE8/Z02yhJUyuSlK4VCoNVNQI/yQmRv4HEqezvqDopObRxYjps37v5FNHYpPXB0Cc/E1dnqCGEkWlA7Q9S/dXgkjFWxSaXbFJlEk0yaueSBh1g8a2EyC8bvmrNIH832hFws2+tIX1HRznzPE0F3FBdjCgPbI/oGHN49syCp698MmZh53IZIbiFCHIKCezLfH1+N2t5UfUxTCzFJmorZchEQHXLZQUfL35bhPHcCPBM+bcUU7IUK/1ADhyhdvbq23o40hyfN4cRKUeazT94oyGuPaXGbHyyrOpoV95FmwdkBryn+KFoF2trr0ikvn31UxgaAUvWgdetzk3ci4ad0UdBTixQB2w3gnR203oH9i7NtHbAyWk011pIMc4ijI+TToKIealAQ5B/difSPuAyjXl2DTn+gdqOKY2k+nHobavmHeHOL5epFf416QvazPZZ1zxj2tiqesZBB4/22YT8HehnaEFzJP/EscPhU+JhiCiKIzhO8/YpWi2maB8l2GNLVwEnW0IDjx3/lLo1emzzHNg9dTjS0o/2bWMtNdkHVCHhvI3mh/WGEUNFiAaaph1rOEGsDLJ2rLSYgwvMWeBs/4ypbVxl9W515e+HlgYZY3Rtl3MUsRufVZv4uOVs93Bla7Q+/sU2DkR8uE8CLDs7n9sLvxsJOwcX7KRL5l7VoYYmAeUTtJL16SCh
 IJJW5YAd
 5diSifwNUjLMIrhr9HscBPrewL76QykHfgsVQmV1jlCymd+wOF+hT4Sm8CAsLPvahVqSLub4cRTU/BrfICtdjI0fpFhseysZOWCavjfTdbJuW+02VJy1t0XGLzck/4grITNEyckmEIxhzCSTF+7pf6o0pCVTeCQy9xVtNLdjcoEXTD0G5EI0r5jRD3c5IzBVJHMZ3FQtTi951fsVM8rKietidkOhJbaLSDRxPDnai1GsL7RckesfFtLy7SV7OYs30BjT7hNlpv9L/tCFVTcH/7vhznL/TbLMA+tqAmFGWDMfb04Tw+rtPZ4Xou3XYlDhOLxNPTxrAJJ23SlKf02KmwdsyEeDpyfFJdWhBrcohxkLJ3OH4JzLeRV1OmCewd2Ga/+ZRZlVOqEOgWGMiIycFm82lEgmG+PnMPwcxlapo8CIo7REJP7p1nEeDqjCSF/n2toIwJkmKHO2nmWJqTcy9z0SR4bf1SZGPJZUSWVb7DU0fapGi2CwevYqr/Bt1JYeN7ziBgUuXzLF+P6EujyYCxvrhALttw6v3bUT9EK1A6C7aJXttnwAt4C5QjO8JLs5BYYeEE7Y9CNZcGNeEgQze0hKqDu/XHhvXNPOvIeL13LRaMmR0fk00W+nCsTTZkqW9dAXzRbjiAAp4mZLzQ4U7oVCKSw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 13 Jul 2026 at 21:49, Dev Jain <dev.jain@arm.com> wrote:
>
>
>
> On 09/07/26 1:08 pm, Wen Jiang wrote:
> > From: "Barry Song (Xiaomi)" <baohua@kernel.org>
> >
> > vmap_pages_range_noflush_walk() (formerly vmap_small_pages_range_noflush())
> > provides a clean interface by taking struct page **pages and mapping them
> > via direct PTE iteration. This avoids the page table rewalk seen when
> > using vmap_range_noflush() for page_shift values other than PAGE_SHIFT.
> >
> > Extend it to support larger page_shift values, and add PMD- and
> > contiguous-PTE mappings as well. Rename it to vmap_pages_range_noflush_walk()
> > since it now handles more than just small pages.
> >
> > For vmalloc() allocations with VM_ALLOW_HUGE_VMAP, we no longer need to
> > iterate over pages one by one via vmap_range_noflush(), which would
> > otherwise lead to page table rewalk. The code is now unified with the
> > PAGE_SHIFT case by simply calling vmap_pages_range_noflush_walk().
> >
> > Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> > Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
> > Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> > Tested-by: Leo Yan <leo.yan@arm.com>
> > Reviewed-by: Dev Jain <dev.jain@arm.com>
> > ---
> >  mm/vmalloc.c | 81 ++++++++++++++++++++++++++++++----------------------
> >  1 file changed, 47 insertions(+), 34 deletions(-)
> >
> > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > index d7fef85b241c4..d2a4d649af549 100644
> > --- a/mm/vmalloc.c
> > +++ b/mm/vmalloc.c
> > @@ -125,7 +125,8 @@ static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
> >       pte_t *pte;
> >       u64 pfn;
> >       struct page *page;
> > -     unsigned long size = PAGE_SIZE;
> > +     unsigned long size;
> > +     unsigned int steps;
> >
> >       if (WARN_ON_ONCE(!PAGE_ALIGNED(end - addr)))
> >               return -EINVAL;
> > @@ -147,8 +148,8 @@ static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
> >               }
> >
> >               size = vmap_set_ptes(pte, addr, end, pfn, prot, max_page_shift);
> > -             pfn += PFN_DOWN(size);
> > -     } while (pte += PFN_DOWN(size), addr += size, addr != end);
> > +             steps = PFN_DOWN(size);
> > +     } while (pte += steps, pfn += steps, addr += size, addr != end);
>
> I think I had also recommended to put these vmap_pte_range() changes
> into the previous patch.
>

Hi Dev

I put this change in patch 4 following Uladzislau's earlier suggestion:

https://lore.kernel.org/linux-mm/ah3Cn3YnefIVJDo2@milan/

Uladzislau, do you have a preference on where this hunk should go?

Thanks,
Wen

