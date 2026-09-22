Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8650C982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 21:03:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48D5B6B0088; Tue, 22 Sep 2026 17:03:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 464C56B008A; Tue, 22 Sep 2026 17:03:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 355366B008C; Tue, 22 Sep 2026 17:03:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0259F6B0088
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 17:03:24 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 84903160652
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 21:03:24 +0000 (UTC)
X-FDA: 85242623928.26.2DE5948
Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	by imf19.hostedemail.com (Postfix) with ESMTP id 928021A0003
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 21:03:22 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=V7lCQ2Xu;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf19.hostedemail.com: domain of devnexen@gmail.com designates 209.85.167.173 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790111002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LcKMyE1/7kAEM6RrLqfWaO/Qpmd5bxvlGWaVkcDKx5Q=;
	b=Mdw3mg3FKE0e8pVq7N9Xghk09pOBVPrMMLGfqGx/OFVcRmDuWSV0zNZLh1sRpP2facTsYo
	H3zv7Xc6bPqGRfNiDLLdbCNJPR9vUQyUrI0aVGMONdb5AiF6vOm4ICsKNLY0fJ+31cpOem
	jNMUHiMxXF8qcgVguZO9Nw3eBlbRGKg=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=V7lCQ2Xu;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf19.hostedemail.com: domain of devnexen@gmail.com designates 209.85.167.173 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790111002;
	b=6N163rCZhy0TJ3qsa4MdLjp6yHhGTE0jjnrYnzhWR6Nd0OuDVDYZUYLh+oPaM6iJuZqGyK
	i3Q5TpvbALtQYrMuE4mduyjOMY2xfVJ7dOs0l/XadYNitV8wTq13lLyJ4yA8dsxhp3VfcW
	+r21LiwO43yYq4ayZN8vbXgiayRuXR8=
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-4be07e7c54dso240650b6e.1
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 14:03:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790111001; cv=none;
        d=google.com; s=arc-20260327;
        b=LT6k+LbD9WMCMNMPWs6gCTjUi0FNcfFuf3yRrrBVkcb8ejrQP1PNQ1JK3zB1eZBiMe
         YgUqXsa/EOjcvi57qGy4964DjlWQXDT7ogxeWIziYGPhvz6raLsOQQmECjthvYy8myyA
         RD+QEVLudY2/3A88JoWSNDZZDtBQk32QpJuyV5PFFHjxqZe+/ecow44pvuCc0qUdzxhP
         cC7ZxC4slcG2Zh3SpcKbub9IUPAtzc377cT6LeovB1QrB1dyPzelXQVDHsdJz3lSHae0
         2RI9ZZtkk3ZLv5l6XktYWeyNUXwTtdOYaHN7ZiEWQKTRYceI/SSbOs0xdz34MAW+qTvA
         MZdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=LcKMyE1/7kAEM6RrLqfWaO/Qpmd5bxvlGWaVkcDKx5Q=;
        fh=LZHv3PCjh/w9DcpezvxQpz/Sj4CEZgMyPG+tToCrtng=;
        b=kh/+kqnHj8YVE6xXh1oRgxwovdXhXmr6kt3XZRl3LVEt6GJo6t8prTatWUg4SYRXtc
         NOrRwrsLjAXuYKYE9qKW/3jZ2KjxiabKIQE97m2YqttOpexLX46j8Kqy+hID4i5Y7sVy
         Visv8yaSMv4UEBpuKVFJjEwHQxX6QwWanV/PQNuiWmtmunPe6dQwMYsa6R6c43ikgKsM
         gTSe3j065YpT4skDUUDziACfcKWmMvq0aHFhSZZxepylMafMFpF9BY0ek+Hx8Rw/lT3w
         bypHpHG8gj66XWuVd0fN9nDoT0rCCaZAeAcwLeBmWUeopu8f4iEyuACzmhMESogiFcTQ
         mVew==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790111001; x=1790715801; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LcKMyE1/7kAEM6RrLqfWaO/Qpmd5bxvlGWaVkcDKx5Q=;
        b=V7lCQ2XufIkzB+XyCP6gVjo9pFIbRGiGUV7EezKuMGhQgBz5wqA4GluGY9dh000rDi
         GXvC+0F+xQJBDiYALP9Bsu/gwlOBjBbNZnq4NyIlwdHDE0LyLAaj8jVyYuNHr3cw2IaF
         VjTRqPnOPA9JXpcLnxJRSpdlgpOg6uJfoYGSduJKtyThZYlZF8Y4RXPCZ5a9J9eYG3AD
         PJ2g7AeF2n1WI47vHKsBf94gGg62wBRBIAiLT5GQsPkJFkGAAglXvALr3utZsPBfa6zf
         hP8J8trMG6JIDftCLCCg+wjfBXQ5AzToFBVHhcqthXA+3EwSNk3S2wy0o0J650Fo82uz
         ZXaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790111001; x=1790715801;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=LcKMyE1/7kAEM6RrLqfWaO/Qpmd5bxvlGWaVkcDKx5Q=;
        b=S0Bj2ZGpTERSpFGfWQgEZC/hH6NgrYzvQdadUUPzIpksxYD5mS9K2ofo6wOo930shH
         NPLCvFDrN9ScJUyJV9FLNqh2JpGMZslMvTgrPkQQe16QtBBklHTlcRtUK4XezIVAdswa
         b087osDBWWZC1cuxzFMdP7S0NH26vw7A1yM1lXdGS7lkPU8ikeMDlZyHsN0ftGtZYHo3
         48xtKKqobcgqtsw+lwY8Y803xD/sPGiQ2OaUUwyFtMUnooRmdm0uuZk0y5v9oBpA+nGj
         q62dW5GGmSc4EoqE8nTPXOkAiAeUJeeDhAu1xYJ2AsqEhZE2ceY8HrmTkq+GZAeyz0DT
         wjnA==
X-Gm-Message-State: AFuF++k3fDva7DAK6myAYGPbEXMh6FB4eeJ/dOr3u9ndRlhp8b0YZu6+
	1Ge2kp8Cpy7MF/GikOrjqYGMEp/e0hXP4ls0twYPA9BCt9MFIZGsVq8QhG41nnSROTsjRs+fODr
	han8sE1s6MBAZrHg/HRsK9Sy+HThE244=
X-Gm-Gg: AYBFou27dYos4uzFiLQOiQF/487YVX5xCMpRCsThCl2tKHR/5STKw//vAPI78u2uHvJ
	1Dq3oQPmSIxgy3eZZpUm2bw2HH/JyAELMg7QFWtwDO9DIAB9mHPE58xLryhCPiUqyN3052gTe1s
	IWPJbecdG+jB4jk/ReFEOyyl7rfntg+4MyHCK1afyMyypufhngkkMUg4tB7qpvGzgvHTFTpsMpV
	qjfLC1u7XPBo/HOSO5+tj7q909/CvqrLgPtP2As2dIlT6rrHWFiDMnwl2rBOSa/Xg1W72JTUiZd
	U+Jaix1U6U2p9eWyDD1AjXHH/HrlqBubf/2PkBVR1JgU9dbWnSQL8Nvq4icscJiPDFguPvwMxng
	GIxsJ9j7TgA==
X-Received: by 2002:a05:6808:c106:b0:4ca:9850:4dd8 with SMTP id
 5614622812f47-4d436d8e804mr3181835b6e.10.1790111001332; Tue, 22 Sep 2026
 14:03:21 -0700 (PDT)
MIME-Version: 1.0
References: <20260920155002.1030454-1-devnexen@gmail.com> <fe49c311-582b-4ee2-8d17-42a758351570@linux.alibaba.com>
In-Reply-To: <fe49c311-582b-4ee2-8d17-42a758351570@linux.alibaba.com>
From: David CARLIER <devnexen@gmail.com>
Date: Tue, 22 Sep 2026 22:03:10 +0100
X-Gm-Features: AcwNN1XIGHxWY5dID-_5rqbKWq1Z-2duakHAem6OMx1JH4ihQ024QoNlPXf6f4w
Message-ID: <CA+XhMqy_0UPL5HfPYhPHeJ-ZngG4DRzme_a32sLSYd2VGSjo3g@mail.gmail.com>
Subject: Re: [PATCH] mm/shmem: don't release a swapin-error marker as a swap entry
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com, 
	kasong@tencent.com, bhe@redhat.com, chrisl@kernel.org, baohua@kernel.org, 
	nphamcs@gmail.com, shikemeng@huaweicloud.com, hughd@google.com, 
	syzbot+23b25ba3c6bf971f9c57@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 928021A0003
X-Stat-Signature: idsq9nkfxw4fawp95rjeaa6rd83qrw3a
X-HE-Tag: 1790111002-490367
X-HE-Meta: U2FsdGVkX1+prjk/8hAo+tlqjtbvHiVxji9W3zxAskMiEZoTx4mCV4/D2WjawLaw0TTArBo9IBsfix3M+EXKFW+MlOM/XpB3G1XNqO7w8IN6bWo2Le//3mvDui6ifxQNp1/CuJJ3D5TjIHyudGTe6z9TTu844ji9Sq7kMF3ht56pvTg16OTlA+eB7d7mFIcmlxJ787OVdMhmHjd7juRP3XxhTGuTiuvnndArFAsxxnuGk6tJAAgUGOTQOQuad/++jHVAog7fwedZ3ojY32TzGqEyHf8dRp0upUzDeSz4rduldh1mAyrwF0hMDF0dBHpbaMN48IlKU9LzOjPGVKykpTNV4ocIzXnxGYjwWGnOQOT2wmLyqgueKXpc9JiLM/h7JyxP1kn0Mpi2IECkCbecAtAUeWcbWyJNXfP3vQ9gYBR/Ja03Q9DraYKB/jmkLlxUjWgkKhzmzHSDUaQ4nM2r3uz36ycPuqxS/lrzOAK+aGUTsylH5UAd/Zh8hCLf5NaAEJLFuPXYvk5dSlIlY43jD9H99q/oEsiGNwkPHzWQbR/Odcx9Fvz2iHoT9vRN/LPTtK4xi0w2S/rhCn4+7BzZjDoLMwRs5JBkPCBOQd2QH22dxfvmxV2Wc5+a1fA6c8HAygvO6fMErKDv3PB1Fmbex39vevmLVTPWwgzqvnKgnRCU2lKvNRsVdHswze3xL0noQaLIPBBcNW+ZJ2MG0vz/SqdLbK/Ivs95pPEH3OOYZiKYz2nEtiLK0E6QDy3LT4YVO7oscKcOOQ/a3C4Dl6WUF56Np6uwhgzdcprrgaB1RIBzP6pHv8XdvgM06+9PJ8fyTjS+cYwHweOI15VYD+J3/ZWsPmGqled4gNnOZnUrTX3nphOcJVoJzYUjqsCtP7azY+HhvTX4jDHUUhoV3nNsJ6nYuOlDd+Fr8xpB3uChaPCKxMe7tJ8VQkBu9MvgWUy1J3nkuyGJVI4oh0+YuBS
 6JqK6Dy5
 b20OuLxqj4jpgRo909/UEzhm6eCSPFiZipT/NzhnMyTe3HITntujhK9Y8DVuLMKd/GEva4e5nztEm++El0fGRyrEFopvjgQtLnutUwb109VWIowiR4GTz26JGY1R5sxXX7Bl65VoeLpR7i3sbyhvht6PSveIhyUHdLuW28e0jtMKKdx05znChH35cZmdKe9y41zvHO5UEU6Ye1r8f30wjwmdZh9oZLFhDj15aNifYk07AwZ/vAcVrBKc9i2ma5HH2fgWGXW4JxaQLb1Ocm6/5NI7zYsFKcL1g7CwD8jwr1yNArgRK7n6GXzE/cNDazC/K6n5ZKh4W/kRF+AtzvTeeuycBoqpbolHsupQmHOHg2gcDQgYKz9vG8w00j7Bx/YW/DEZnYgS2XhjcI1QzMRx0qW74JfeTl76YyFJFVAUuv62ObBQzD1+Keie3INQtdg/IB1GH7zXG6+DgYkb/TtGsVXsbXrFGS6VSU8/dgpA9My6I9SKferhS3A/DMMGevGdlsaNc6hwotxZcHnCFm6XcuR4qXb3KXJljdca5ZJFkE6e9WwXtCwmoqVqCi9LGHxCL/OaHwhM8L8w2tYb/qDQNSSWwe0gEsy1dhBgGyp87rmC3K3E9rWZ2BWrdskhZri4iNEbi7vqwmnMI1qAWDcpt7wkLL3Ny1YvS2etH9XJ/rmboZUWADg7CpvWNKmtK6R7Odhnw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 21 Sept 2026 at 03:45, Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
>
>
>
> On 9/20/26 11:50 PM, David Carlier wrote:
> > A failed shmem swapin frees the swap slot and leaves a PTE_MARKER_POISONED
> > entry in the page cache. On truncate or eviction shmem_free_swap() passes
> > that marker to swap_put_entries_direct(), which warns because it is not a
> > swap entry. There is nothing left to release either way.
> >
> > Skip the release for non-swap entries, as every other caller already does.
> >
> > Reported-by: syzbot+23b25ba3c6bf971f9c57@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=23b25ba3c6bf971f9c57
> > Fixes: ac2d3268284b ("mm/swapfile.c: remove the unneeded checking")
> > Signed-off-by: David Carlier <devnexen@gmail.com>
> > ---
> >   mm/shmem.c | 6 ++++--
> >   1 file changed, 4 insertions(+), 2 deletions(-)
> >
> > diff --git a/mm/shmem.c b/mm/shmem.c
> > index b572c60f2af8..94f2c59c8cfc 100644
> > --- a/mm/shmem.c
> > +++ b/mm/shmem.c
> > @@ -1184,6 +1184,7 @@ static long shmem_free_swap(struct address_space *mapping,
> >                           pgoff_t index, pgoff_t end, void *radswap)
> >   {
> >       XA_STATE(xas, &mapping->i_pages, index);
> > +     const softleaf_t swp = radix_to_swp_entry(radswap);
> >       unsigned int nr_pages = 0;
> >       pgoff_t base;
> >       void *entry;
> > @@ -1200,8 +1201,9 @@ static long shmem_free_swap(struct address_space *mapping,
> >       }
> >       xas_unlock_irq(&xas);
> >
> > -     if (nr_pages)
> > -             swap_put_entries_direct(radix_to_swp_entry(radswap), nr_pages);
> > +     /* A swapin-error marker holds no swap slot, so just drop it. */
> > +     if (nr_pages && softleaf_is_swap(swp))
> > +             swap_put_entries_direct(swp, nr_pages);
> >
> >       return nr_pages;
> >   }
>
> Makes sense to me.
>
> But another issue caught my eye. Since we already call
> shmem_recalc_inode() to decrement 'info->swapped' when handling poisoned
> entries in shmem_set_folio_swapin_error(), shmem_free_swap() still
> returning 'nr_pages' for poisoned entries would cause a second call to
> shmem_recalc_inode(inode, 0, -nr_swaps_freed), thus triggerring
> WARN_ON(i_blocks) in shmem_evict_inode().
>
> I'm not sure if you've observed this warning. IIUC, shmem_free_swap()
> should return 0 for poisoned entries.

Hi Baolin,

Thanks for the review.

I think returning nr_pages is needed. shmem_set_folio_swapin_error()
decrements both alloced and swapped, so shmem_recalc_inode() sees
nothing freed and the block stays accounted. The second decrement in
shmem_undo_range() is what finally releases it. Returning 0 there
would leave i_blocks non-zero at evict time.

Cheers

