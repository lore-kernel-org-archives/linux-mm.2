Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D60D2EE020B
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 15:30:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 060776B0088; Tue, 30 Dec 2025 10:30:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00DCD6B0089; Tue, 30 Dec 2025 10:30:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E52BD6B008A; Tue, 30 Dec 2025 10:30:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D59F36B0088
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 10:30:16 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8BF2E57343
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 15:30:16 +0000 (UTC)
X-FDA: 84276523632.03.A7F48DA
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf23.hostedemail.com (Postfix) with ESMTP id 992B4140017
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 15:30:14 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XrsZvELC;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767108614; a=rsa-sha256;
	cv=none;
	b=LvqFyV1tl3Hh0CBENeQ0dMfPE5w/t2IwGj/+eQpcIvcn1GX1m7EU0YZ6v3/+2OpkBjDJFO
	NgX/4ExzQBqUcrD7OWchltb6XlL0T6FwcdlSdNGUoB2SEGQ2Xhh1XNqEliqU9xBntk9a9c
	whcoMomAVgrYL29SpwAm3sA0gYQbp0A=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XrsZvELC;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767108614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n8Waek7m5OPDxNGPkUlVwnne3lwalLyO9Fw6TFHyHJg=;
	b=PVeV/0NIOTgK098CRwi1vLTP2lJWpMGmY0TkOQPlmBhWPLLLmYyfyvSIDB7qvuPB04jxo8
	vH3YVXfHiJLaJEDH2uQ4/HAIVVWh3b6pOtX/A7+lwgwflneUfQ6KWg7l1MgtTrfMbxHfwl
	DdLjPxEmLKarzhs64LFwxKduOGz8Rr0=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2a0b4320665so153649525ad.1
        for <linux-mm@kvack.org>; Tue, 30 Dec 2025 07:30:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767108613; x=1767713413; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=n8Waek7m5OPDxNGPkUlVwnne3lwalLyO9Fw6TFHyHJg=;
        b=XrsZvELCj0CURmtt1NLFJDy97OdQxKmti7XLra1rBVenHek8rU7kAI3ozm263ZLlWc
         LO0LuNgz7/QO521GEc4P7wHIPZ8HNjqJF9ZDGrd9YvWy+7ZUy0jKCUjVTibKLC+jHIvA
         NdZLeYZQmCiC8g825W5vz9VV3VmqMaYqpn04giSnfCNFreVjTDm9FZXKazeJ19hRvQkc
         wssk8HmvGrjJ8Slx4RFjJfi/xigz3bwLD1d+uazUQtQWp0Zbkr51xFP5HR9KIocb4HAW
         /8gT7ZcNtl15CuM0OO67wE/O3qo8IPCZL+4HZ3GCxgb1h/4QIVhRstmY3ZV5CTVCxcLc
         wruA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767108613; x=1767713413;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=n8Waek7m5OPDxNGPkUlVwnne3lwalLyO9Fw6TFHyHJg=;
        b=i+Y0hUGsAT3B/xJWLbfKF64shPfyRhZ0A1UhPVWRQstsqHrywd0ULYv4tuPJJaRgrX
         ymFc9fQF6Er2CA2dL2dFBrP7yKukMzfK32dzgoNP6ToqkpWw/2Ymg7OAEOv9aPO9YywE
         Dns8RrY9XHULiSIISAeiIcTiwcvcLYudAxKnQ4imKDca0iI7zUofzrXB2ieEZsnQ/U6f
         KVw+LA4o5u32l5+51KD41XoqPFTup8ZZaag+qP09vmyI0gjgeNGGFqnVoWq18kRBMnsy
         rcQteunctFX9Iw+bHu2obf1XR9P4P2DrkSOMvRw6yVsfGs3dZntW2v6HWBHGnb8t9+V0
         Lw9w==
X-Forwarded-Encrypted: i=1; AJvYcCUI83+EQUXosMlMT42JX+4av0kBrOOUwcvPUIWYbBnYsUe9dAK8yDBLYROF/NJ7tUHpfL0wXEv3rg==@kvack.org
X-Gm-Message-State: AOJu0Ywj/xH00E5gSNbdNlbGdCbDG10uXdY6RRg7AR6J3r80F4ZAVbnV
	CKfSxQjxkzBXNkxARSzELepRmcvgICrhOZNIChnh+1arifFAGLB+Mqc1
X-Gm-Gg: AY/fxX6yjQSgfCJP/l/2OATBmvkxHCnP3V2eYVQaDL15nMs3wPzLqLJ7dV31X8JQRrj
	6JeAKQ5Dj9QC3i2OnOZI0g5+pZOloLU0S3qc+K5xGNhzOLdWlJ0biMUQj2ZOhq2WNzRmQtrFqRt
	vfEnNc71MUSzBkI8Tl/kLNayZsDrRKXGFmPIceSiIKDpMNOqhjqQMX0hvjQbb5QNYUq4U9ssYZs
	z7YvUH+Dpkd0ansl96mYWlfH4eadjsoyObFFB3LuIQXoO8cOCeu3B6bfho2fMhdIxkPZlsCI+Iw
	73u/zMWImk2F0orw3xvN9LSEqixoV8lKLEljpaf0Mru0lGzVH0G6zf4aFqhxJ3SZyPaauiSn38l
	+pY9yk4S8dEyvWGt1NOnOB1gcj2xsC27J6IFsOUvFQEcjA3NL/FIJtRE8E/7ppscNCxYvJMENcg
	p38P+6G68sN4u6oAowOFktx2s=
X-Google-Smtp-Source: AGHT+IF2yfGAQaMoIdAwWSh3x/5KCIntoGPDVnTc/GiZCDdlJGOBbZUTGrpwldsS37RDV3/o0Zok4A==
X-Received: by 2002:a17:903:2a8b:b0:2a0:d403:a2e3 with SMTP id d9443c01a7336-2a2f2a3584cmr336697875ad.37.1767108613198;
        Tue, 30 Dec 2025 07:30:13 -0800 (PST)
Received: from localhost.localdomain ([121.232.80.251])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3d76ce3sm307298585ad.90.2025.12.30.07.30.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Dec 2025 07:30:12 -0800 (PST)
Date: Tue, 30 Dec 2025 23:30:06 +0800
From: Vernon Yang <vernon2gm@gmail.com>
To: Barry Song <21cnbao@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, dev.jain@arm.com, lance.yang@linux.dev, 
	richard.weiyang@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: Re: [PATCH v2 3/4] mm: khugepaged: set VM_NOHUGEPAGE flag when
 MADV_COLD/MADV_FREE
Message-ID: <fbb6uaquaxfu2cfycsamfwvxw2h64bn5tbqbqe33jqikmxpdcg@oqgaejcsvyuj>
References: <20251229055151.54887-1-yanglincheng@kylinos.cn>
 <20251229055151.54887-4-yanglincheng@kylinos.cn>
 <CAGsJ_4yLocY3c0oi022b=2Eq2CoxttQMn-XeWuSrjbKPmt5QPA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4yLocY3c0oi022b=2Eq2CoxttQMn-XeWuSrjbKPmt5QPA@mail.gmail.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 992B4140017
X-Stat-Signature: h87buejm7yk5k6yxw5gt6cizu17stex3
X-Rspam-User: 
X-HE-Tag: 1767108614-47528
X-HE-Meta: U2FsdGVkX1+RKvJkc4Kuo3NkldAxX2q2ONTkvlqSuEITjjxdWv0FtoDpsvqOphv88zDHbP4F+cGjKjJ8BE0wm6lWPOGhSzj1Qorndfp8KKV/Tu3ap1q1eVdB0GRFRSovQphln5T0k+0P0Ypcb/48fL1uFCff3JnRKl9DwR59llYQb+uDb4OEAznmmv0nrs4z7uTNmVyAxX9l+t6Llqcnisg7BjmgZDasOLGoZftYqCTz+ASCtk5JZlIp5JvyindJUuQcvkgKTrNvOaa9sOAyGkECTs5xisGCF2lB+Ehzrhblc9Y4BBNXBhx/1puFE/QBfn8Raj6z8bRTkzXlNTAkOrIExn76Yw33woXx40cl+Rbalf/EbEAHUo3GUC1fOHvWOUub9XbPPoPpZJnHXrddTJZACy5WVVLH55EIiqAwHtcL3ABaCKpI9DqzmtlZsiHBusaByz4BY1KITpV+wJJYwTOMQFpWPjWg+rCeB9HLUIr0YzJVTQxe8Zl5LOg2fwJ98plWhevHazM1DBWe6fGcB+3rRTYyqHQV58rvWb89/MWaG6VtD8FpiJxCjRLM8XBijIntmU2N0gByiKxt3UlIPbBVo9llwWtuug4u3YQnrWdB4oN/60JjIEIy6yVH9cbuvpPDCIbwweB83rYAJo5IiP2Zg9AhW4BUyOojeA59iNDW7kdUzUvZIdnHU8MMp+SMntx+iyCConsRzpvK4uvuS/eZLSPZColD8EztQJcT6F4rjg149ykIFCrwHP5t4hvwigKbQoRgyae2qbWiQIylkpylpg43DGgGYTS/IICrEenIyvaqb1NHyNeFW2E4wj2BoVXUA5sMDMq9ZV/12MzD3smumLAcjoI9ynTmJaJh7j9rGpIpXgIQ+efImXwcL/zn9khQcUMQ5g8Hd7v3gnIhc7r9GB5z14xctPYjQSSKzsFxJPleNU38knasHROKqVJoNWkBMQKL2D3wA3gxd7u
 MGNhZSzM
 NsQY4SKIDOtJZDHKtnoIIMD4oMu4bB1ylY8A0txWZduwq4lAJesNXGkSjwz8ssy7SJW7DRXZ+tw4FnWxjk9/IL0aDjTi7HWS6By0tBK5s8pRCkXpo1Mgqy7xyo1L3+WZjWhgD0lTK5S9w7jNdaz3m+IhnyF0NfOhwQDFdn/PD7UIPIpN3kdAmGw4Y8de6739bs0WJMfKVz9+rSpG8IuhFHXogMowIwudmHbqIZgMwyEWIvOXj8GqgqEsUV4Cf5zBGDqK4ftHMK4os/XTEmiUJGGX7zuxxgPCI+Wey0DufWjRMxqzXTal+OjNWWJmTd3xYOUec6ybvQ9DRaJXDZHcOlSZKrXBxjLoNgVPO3ZUg6phwQ83InqGhDSHHzmrCcZ66LzsHVrr4cjWcuA0GAc4i16lOXExK/fexL4DHGlFdoO52GCMQHNTkehJpxQV1j8HPOKwIvMbu/BR+JklmybsDRlAdO1HdiLu/fZ4hJ1c7d8Ma1BuzFAOKknlcWZVBz8Q66Idg7cXwGxsqFl3sXkwHcSwJ2c8VPsNDS7U9gaJ3z+ThUa9XMkkInfLepi3xRCgDj2o04Oz85ugLkfOy4kqJ4O3Zgg1mdvBDYdbavM63HkdfmtMSkkCaXZ+lVMvJnl5dnbRm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 29, 2025 at 09:20:12PM +1300, Barry Song wrote:
> On Mon, Dec 29, 2025 at 6:52 PM Vernon Yang <vernon2gm@gmail.com> wrote:
> >
> > For example, create three task: hot1 -> cold -> hot2. After all three
> > task are created, each allocate memory 128MB. the hot1/hot2 task
> > continuously access 128 MB memory, while the cold task only accesses
> > its memory briefly andthen call madvise(MADV_COLD). However, khugepaged
> > still prioritizes scanning the cold task and only scans the hot2 task
> > after completing the scan of the cold task.
> >
> > So if the user has explicitly informed us via MADV_COLD/FREE that this
> > memory is cold or will be freed, it is appropriate for khugepaged to
> > skip it only, thereby avoiding unnecessary scan and collapse operations
> > to reducing CPU wastage.
> >
> > Here are the performance test results:
> > (Throughput bigger is better, other smaller is better)
> >
> > Testing on x86_64 machine:
> >
> > | task hot2           | without patch | with patch    |  delta  |
> > |---------------------|---------------|---------------|---------|
> > | total accesses time |  3.14 sec     |  2.93 sec     | -6.69%  |
> > | cycles per access   |  4.96         |  2.21         | -55.44% |
> > | Throughput          |  104.38 M/sec |  111.89 M/sec | +7.19%  |
> > | dTLB-load-misses    |  284814532    |  69597236     | -75.56% |
> >
> > Testing on qemu-system-x86_64 -enable-kvm:
> >
> > | task hot2           | without patch | with patch    |  delta  |
> > |---------------------|---------------|---------------|---------|
> > | total accesses time |  3.35 sec     |  2.96 sec     | -11.64% |
> > | cycles per access   |  7.29         |  2.07         | -71.60% |
> > | Throughput          |  97.67 M/sec  |  110.77 M/sec | +13.41% |
> > | dTLB-load-misses    |  241600871    |  3216108      | -98.67% |
> >
> > Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> > ---
> >  mm/madvise.c | 17 ++++++++++++-----
> >  1 file changed, 12 insertions(+), 5 deletions(-)
> >
> > diff --git a/mm/madvise.c b/mm/madvise.c
> > index b617b1be0f53..3a48d725a3fc 100644
> > --- a/mm/madvise.c
> > +++ b/mm/madvise.c
> > @@ -1360,11 +1360,8 @@ static int madvise_vma_behavior(struct madvise_behavior *madv_behavior)
> >                 return madvise_remove(madv_behavior);
> >         case MADV_WILLNEED:
> >                 return madvise_willneed(madv_behavior);
> > -       case MADV_COLD:
> > -               return madvise_cold(madv_behavior);
> >         case MADV_PAGEOUT:
> >                 return madvise_pageout(madv_behavior);
> > -       case MADV_FREE:
> >         case MADV_DONTNEED:
> >         case MADV_DONTNEED_LOCKED:
> >                 return madvise_dontneed_free(madv_behavior);
> > @@ -1378,6 +1375,18 @@ static int madvise_vma_behavior(struct madvise_behavior *madv_behavior)
> >
> >         /* The below behaviours update VMAs via madvise_update_vma(). */
> >
> > +       case MADV_COLD:
> > +               error = madvise_cold(madv_behavior);
> > +               if (error)
> > +                       goto out;
> > +               new_flags = (new_flags & ~VM_HUGEPAGE) | VM_NOHUGEPAGE;
> > +               break;
> > +       case MADV_FREE:
> > +               error = madvise_dontneed_free(madv_behavior);
> > +               if (error)
> > +                       goto out;
> > +               new_flags = (new_flags & ~VM_HUGEPAGE) | VM_NOHUGEPAGE;
> > +               break;
>
> I am not convinced this is the right patch for MADV_FREE. Userspace
> heaps may call MADV_FREE on free(), which does not mean they no longer
> want huge pages; it only indicates that the old contents are no longer
> needed. New allocations may still occur in the same region.
>
> The same concern applies to MADV_COLD. MADV_COLD may only indicate
> that the VMA is cold at the moment and for the near future, but it
> can become hot again. For example, MADV_COLD may be issued when an
> app moves to the background, but the memory can become hot again
> once the app returns to the foreground.
>
> In short, MADV_FREE and MADV_COLD only indicate that the memory is cold
> or may be freed for a period of time; they are not permanent states.
> Changing the VMA flags implies that the VMA is permanently free or
> cold, which is not true in either case.
>
> Your patch also prevents potential per-VMA lock optimizations.

Thank you for review and explanation.

> However, if the intent is to treat folios hinted by MADV_FREE or
> MADV_COLD as candidates not to be collapsed, I agree that this makes sense.
>
> For MADV_FREE, could we simply skip the lazy-free folios instead?

It is nice that skiping lazy-free folios simply, it has the same
performance. Thanks for your suggestions, I will send it at the next
version.

> For MADV_COLD, I am not sure how we can determine which folios
> have actually been madvised as cold.

It is a tricky problem, I don't have a good solution for at the moment :(

Does anyone have any good ideas? please let me know, thanks!
If not, it might be removed in the next version.

--
Thanks,
Vernon

