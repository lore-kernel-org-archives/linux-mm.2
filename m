Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A1BCC5DF71
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 08:58:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C416B6B03DE; Tue,  2 Jun 2026 04:58:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C18D96B03E2; Tue,  2 Jun 2026 04:58:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2EBD6B03E6; Tue,  2 Jun 2026 04:58:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A537B6B03DE
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 04:58:08 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6559E1408A4
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 08:58:08 +0000 (UTC)
X-FDA: 84834370656.06.E19F945
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6DA3614000F
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 08:58:06 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QmgtSSFM;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf26.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780390686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S1oIF7XavksgqfJwObOatvwzU0WAoielu1phntwFc58=;
	b=a/F+wi3L+AXFMFrsoQrnXSFNCKkHnc86ZUE3HnxJZQkl9gCtYRVwdj4jtbnfhCKQrsphh5
	6YS9mypNv1xGpI9Lih/e6Ji+us5VjSZfmUuOK1zoannJvJYR4yWRbrIlhPujPFCXC1ugBX
	1YibZldYtmjbgA0fvQmGsFx8XF246os=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QmgtSSFM;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf26.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780390686;
	b=4TZFqZM8E4xCxN33TkHfQn9DmTX/uecSVTtIYU5qKcKvuaucVQBgdn4TcL1xnRYID/OG9T
	mcLX+cYoAUKnpyuS2SaeLtLyy0Yds0y44OOcGenqah71Z7oDSxmom2SqCHt/cxQBCYkbnR
	+4Hj2FK7l2foLLNZtv9GpeM9DPxTETk=
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-45eea68dd6fso2609636f8f.2
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 01:58:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780390685; cv=none;
        d=google.com; s=arc-20240605;
        b=WuYRr+g59V4mRdGGghZjXNj+451Yx0EVe2nc2n9erYxz0faeptaen8DjPQliEwBrRy
         r+ZI6MMWza1TO2MyIuMshE1ilidyTfSjPf4Vb1D52FkqEshtTT1VnoftxE0ZqWFWYLlU
         XADE8bbuqZw2Rj98+BO24O8cVfF1dKHdFjfud8SALAgtKQzxoY+xHgX3aaYDRJLiGKxz
         Hpf4zzm5k/zDTdEQ+9MKyNXT9KnkvemBQyJVjuAfgzVOaPGR9Z60QL2vyTU2+hNtAtej
         w+q5D8g3hGgCxNdmqnr1DMRYJ1WK8n0ULr+VFns9TQp5cyWisBMZfCGIr3ZicLthnP7R
         6maA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=S1oIF7XavksgqfJwObOatvwzU0WAoielu1phntwFc58=;
        fh=C8b6lZPtrB2LD7MBO+6F3n+PqcmJOfb95NDq1lhAU2o=;
        b=Xj518vZZlteztrE1cGYEVybYsY5SlI4bttH/wBGY1v+4uhw+4+5dAZVwuJvxAiiw5R
         3rsWNziyHfc7eUMSFrMjAF43puml5no5qsgeupqLyaHYwvjE8fnlLdf5tsKuELhDFlfz
         7z9Rr3YTqin8sbO/TmKFVhLvJJz8L/eNQG9jOG8ymyJ6rNU/wzBDMlrSsj7wKEF1SyFd
         uGSaZWMWe4FpcArWrAK4iGX3xrFxpHZ+xe53MpC1xRnCsr5L5HuuDOZ0F61YSt6oPlvP
         343+cILeSHjv/6swaRCnolVWqH+iT/p6HOkEBTNo5PiYQ9E2Njw19eXpCFzKICpf563/
         yyIw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780390685; x=1780995485; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=S1oIF7XavksgqfJwObOatvwzU0WAoielu1phntwFc58=;
        b=QmgtSSFMyL6aDyGfN6EfsH8VIhMh3tbklSXglkTBscgAJothviE7EwJpOcP5an9Ele
         GFDhWnTeXskpy8fNVyQXH2VIBB2DogTQEw2wbuderfYpSY4/2MVQMIgy4FxJEMySVIBp
         vhKZ89ta6Ot0Tq5yiSAX/g5s2G21g9ISW+Zbry7/v2RvZB1LVjedGiBHVEInSGGPLuSw
         Ea4wydJ1sNtKBXzXpWo0bSZcQJ2pQF7sV8jbjWbGkRAh32F5Djw/Y76ycxNbvD6BmyUG
         Y+TEu2+Z93lLSZbiwAnMl0BU/WaHU40wIeNWVoRRg1w02hL8l6y6dGYP+TSQclL6wm2L
         H36Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780390685; x=1780995485;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S1oIF7XavksgqfJwObOatvwzU0WAoielu1phntwFc58=;
        b=TeFuDNAESrMmCH9xI9ApTejn6g1GDoNhXFuT9gOWuygXviTmiRfC43jqn6qArwi7G3
         zxKYIx5fu861lmNB7jFYCkSEcoyAh4l0MBOfJaW5XMzep3hRhUZybv3GtJTu0Tve03p+
         THjr6HSUk+6W8oyoN+6HZuUccyMXea18LHJqH2bUoom16CNpJzBZcMOVLA1t8aihf7IB
         qoFsM+jeOZ4eh9CroEvfzTdsbQhV0SQdGl96To/FPDbiiVv4n6KUDzAimqqamBFIQDeZ
         Ttc9LHMC9brcJNc5Wcyq7QJor7tn0RlueMoIlSJKdvgohQj6QsHELrmEBjFcS7pzC+jw
         TXwg==
X-Gm-Message-State: AOJu0Yy1OOXSiBgB3wsbCZUk8/9K72oRPXvdG2kX0tRX+aSXdPhgVdHx
	Y3088gLT0Bio3mbAZKZSrrQz5D+jlKjhsKwDFN3pQ3rwLJ2dVkZe3WOVUYQwDdXZwRodF/z5p2V
	gjYgSuGPpUAcbyMl/J9cnvdB6AhmNtAPJ8ypt
X-Gm-Gg: Acq92OHzlgBHdVbjcV2FtdjU8/AENIfqKXwRgAaku86UwM/mdoxAEcI5Q0960we8/KL
	zph+2j1bc1EIZ/wEzthICkVUdTltO5YPZWtrto+thmr3fNcvyWvxqXwuSOugxj0aN4Zl+FIev4v
	A2SyDG4x/jf/TIfiJj+HXB4YW7S0QNl1GQIj4zkR/pUdnXSdceJOb2v+ojXGiCjJl1CpDRlOI3v
	y7sDr8xytwzJlQFQ4lvq2mai+FIsBBg09mDhlpTYfqq3dniBks07C/JSQlT280v/G0IQ8QqiUEx
	Q2NAuZwc9QJi/nwXY5M=
X-Received: by 2002:a05:6000:4b19:b0:45f:f142:d55a with SMTP id
 ffacd0b85a97d-45ff142d6bamr20280733f8f.14.1780390684617; Tue, 02 Jun 2026
 01:58:04 -0700 (PDT)
MIME-Version: 1.0
References: <20260522053146.83209-1-jiangwenxiaomi@gmail.com>
 <20260522053146.83209-7-jiangwenxiaomi@gmail.com> <3f55655c-b50b-45fa-9314-23e35d04ae7e@arm.com>
In-Reply-To: <3f55655c-b50b-45fa-9314-23e35d04ae7e@arm.com>
From: Wen Jiang <jiangwenxiaomi@gmail.com>
Date: Tue, 2 Jun 2026 16:57:52 +0800
X-Gm-Features: AVHnY4IW685izywGKg4IIg8w_aDLTDby4_6g3UPUknnDrjCf3XAzk_RAN4y6TTI
Message-ID: <CAHKocdH-CgkFTbcowvs0gEgWrzu_9=928yFJH-dQWQxny2au7w@mail.gmail.com>
Subject: Re: [PATCH v3 6/6] mm/vmalloc: align vm_area so vmap() can batch mappings
To: Dev Jain <dev.jain@arm.com>
Cc: linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org, 
	catalin.marinas@arm.com, will@kernel.org, akpm@linux-foundation.org, 
	urezki@gmail.com, baohua@kernel.org, Xueyuan.chen21@gmail.com, 
	rppt@kernel.org, david@kernel.org, ryan.roberts@arm.com, 
	anshuman.khandual@arm.com, ajd@linux.ibm.com, linux-kernel@vger.kernel.org, 
	jiangwen6@xiaomi.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 6DA3614000F
X-Stat-Signature: h1nqz9n5ywxy49js8zgaxy9ttykac7an
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780390686-613126
X-HE-Meta: U2FsdGVkX18PyuImWusVDgOfYW1UmstCdS/+mHvh6MtcRuO1VkF3G6aYsCOqltLd0ibqPQRHGDtdoJe2lFKNoJe4g8bqb0tAieNG1VjVS56zL9AAwiSJx9dubaPE7xS+P6Eb8qae073FV87Q1rO5I3R4sWRKz322CKpxHadetCXl+o7Ehs/hyTJ7FvqybcVmGGEb823mffKXbg2m98JubqeIKTL8rZ0f4RzVUuW2DlcqvZ+mLDRviLX4ILh0/VdoF9zLODvxD7a+pufxJh2SUrzRYnNxKXc0Xl6iC+2a/j7CCGoVXBGaNd/9txAiZPY3kLXiz1uc0Tk70EQgZaJQnkQf0FcGiSZfcT9gg+HsNJxYCOtxojMUk6I2FydhgBXZCy5oB/FaoX79qArV/6YZQMojSDsPaEHZ9dhfHa79QRw1SLSriMmAWzsE41nzx+99YjCdY8TIvDiPHXG3vLURQk+N9Vv0L0bUtqBzWjj34WuIM2wrjcoIr8W1EzvkCIPmXlEg0sf4qok3wRiElS51BjBBTU+GLGgwNwPB2LS3zw5J/aZoVw3QtYUBzKk532bLuLElaSyYmGiGE2ZtximlMxrG1DwJ43yoJxkbAFCMqasYiW8GyHipySuEgpgXmoDiEJY8/5sRX5Hiy1VW7jq54WbbPUIyHbqJHgWnS0xGmVlL5RZK9aO3ni38d7FQz0QXxpTAyicymeQsueO5htcohUCIRcpNpl7JX+soSDL0vB01pGbafjr8vdOQlRdU1qnzcIkB/zr38us/dF0NDUr/uaz2bjaEG0ojyq+ZvC2Usa98hKxEy8LdSEquAu4ogFrtzB1WA4NuvOL/sPZOQDot1tGxZCoOzDgh0LuV16HTHkK/s0xbWhf3hTX+MsO9u34Cl6yj/H+UBTYGkqKYvQyUMZKDxszTbZgjk/JvMa7DgJJraKxAhSFTAjO6LvCQPx9MtvH4Ds0TQYqY3CFaySn
 lVhZUVr2
 lJzBnr1hsKbPPaqdpjQ2LLYScYX+QnVKU48z9CMWNmQQNfG/OpaxBLSjiL4lWjHSXL31mZLKtOOXPIz6yzgaCbDAmAzRb4Z1vEI5wfLFURvO4dAKVwmNGEpk9oNLlaY6v5N6CzSl/GZIM77oUjM98JkFtBGUYMzJQJP1SZWSIYL4xJizd38VJyQrBsgFIsgLHOD+hqp4d3iMkP0YMrKUa9aAURItSc3dmHGRQpMl1ZfW6/rsL5ZpvFhQ7yoC/NpCQILSRnzGSi+Sab56cdw8RGi7W3aOgOM4cGwisAh8ZKfJxQSR4cXYb0jM88p5JyRsFEBGicQvjEUmC8cA5RT9EyLs32qFZme82lwSD1ksmvHw4eO+LIb3RWcxguCMHijU8YBnB49FNkMBxsoZ1CWjfajStLae1bb/BGNP2aGv9Uoif4fssRWkAnMVaITtmX4WLE5aGZ+E9PWkx0/84OX2TlFO/Llpxcy7kFtcrUMizXuS0Hp2f/TCTTEqjI60REYaK56oeqkhAUGnqXFLfqsi1XZvMHhX9/4Ze3tGk1KFjmHTSI6+X39PhWKqWBgA5s90rTK5vru/UpaEufSqEIwmPgu4bwbr95u7rDAzvvH4vUBuo3shBLVvsop2DYEzGTekXwGTxZTFRic+l9u4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 27 May 2026 at 14:25, Dev Jain <dev.jain@arm.com> wrote:
>
>
>
> On 22/05/26 11:01 am, Wen Jiang wrote:
> > From: "Barry Song (Xiaomi)" <baohua@kernel.org>
> >
> > Try to align the vmap virtual address to PMD_SHIFT or a
> > larger PTE mapping size hinted by the architecture, so
> > contiguous pages can be batch-mapped when setting PMD or
> > PTE entries.
> >
> > Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> > Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
> > Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
>
>
> Hmm okay I would have preferred to squash this in the previous, but
> the correctness of previous patch does not rely on this, so it's fine.
>
> > ---
> >  mm/vmalloc.c | 33 ++++++++++++++++++++++++++++++++-
> >  1 file changed, 32 insertions(+), 1 deletion(-)
> >
> > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > index 50642246f4d40..040d400928aab 100644
> > --- a/mm/vmalloc.c
> > +++ b/mm/vmalloc.c
> > @@ -3620,6 +3620,37 @@ static int vmap_batched(unsigned long addr, unsigned long end,
> >       return err;
> >  }
> >
>
> This is screaming for a helper :)
>
> > +static struct vm_struct *get_aligned_vm_area(unsigned long size,
> > +             unsigned long flags, const void *caller)
>
>
> Call this vmap_get_aligned_vm_area, then ...
>
>

Will rename  get_aligned_vm_area to vmap_get_aligned_vm_area.

> > +{
> > +     struct vm_struct *vm_area;
> > +     unsigned int shift;
> > +
> > +     /* Try PMD alignment for large sizes */
> > +     if (size >= PMD_SIZE) {
> > +             vm_area = __get_vm_area_node(size, PMD_SIZE, PAGE_SHIFT, flags,
> > +                             VMALLOC_START, VMALLOC_END,
> > +                             NUMA_NO_NODE, GFP_KERNEL, caller);
>
> Add a wrapper over this called __get_vm_area_node_aligned_caller, which can
> call __get_vm_area_node() with all other arguments fixed, except "align".
>

Will add a __get_vm_area_node_aligned_caller. Will send in v4.

Thanks,
Wen
> > +             if (vm_area)
> > +                     return vm_area;
> > +     }
> > +
> > +     /* Try CONT_PTE alignment */
> > +     shift = arch_vmap_pte_supported_shift(size);
> > +     if (shift > PAGE_SHIFT) {
> > +             vm_area = __get_vm_area_node(size, 1UL << shift, PAGE_SHIFT, flags,
> > +                             VMALLOC_START, VMALLOC_END,
> > +                             NUMA_NO_NODE, GFP_KERNEL, caller);
> > +             if (vm_area)
> > +                     return vm_area;
> > +     }
> > +
> > +     /* Fall back to page alignment */
> > +     return __get_vm_area_node(size, PAGE_SIZE, PAGE_SHIFT, flags,
> > +                     VMALLOC_START, VMALLOC_END,
> > +                     NUMA_NO_NODE, GFP_KERNEL, caller);
> > +}
> > +
> >  /**
> >   * vmap - map an array of pages into virtually contiguous space
> >   * @pages: array of page pointers
> > @@ -3658,7 +3689,7 @@ void *vmap(struct page **pages, unsigned int count,
> >               return NULL;
> >
> >       size = (unsigned long)count << PAGE_SHIFT;
> > -     area = get_vm_area_caller(size, flags, __builtin_return_address(0));
> > +     area = get_aligned_vm_area(size, flags, __builtin_return_address(0));
> >       if (!area)
> >               return NULL;
> >
>

