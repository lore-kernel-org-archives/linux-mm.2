Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82F29C43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 17:09:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55C976B010C; Fri, 26 Jun 2026 13:09:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50DB16B010E; Fri, 26 Jun 2026 13:09:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44BA66B010F; Fri, 26 Jun 2026 13:09:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 154C86B010C
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 13:09:44 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9CC2D8ED2B
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 17:09:43 +0000 (UTC)
X-FDA: 84922700646.21.8094FEF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id BCAA918000B
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 17:09:41 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UEqtGlIn;
	spf=pass (imf16.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782493781;
	b=wRjYhdNWyLpuCrHhmIbfnZthZ5QKR8BZRRu9ZQQpv3BcWL8fS1XZKLQJjodFw9wPcm2ylc
	UingQHhsCIAgu0QD6t6iHr7/uyBfwAlllufQYIUdiomxtPbj+2FR1KA0NpODCtsYKaeATT
	BiPhwZiVQ4KfyyjJ1oqqKJunr72ewW4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782493781;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yHkZooWF8Ur28rAu1FbBgAaf/eWl4Mro8CPDk/C5t70=;
	b=YifrJNFQ0TboaU7+P1gNjwoQIoYBjU6jxB9CaCZpewVf4fa9dRjj2/86v3yWpMtyqFg/UA
	t5kI51e/d4SrTKLtGcSjxQxxSyy20a2HbccPMbU1YWV8RiSxw7tKm9Abk8BW0Gc/rzlERt
	X1sZHuX3Ll+7zYK/hStortJC4A5U/2M=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UEqtGlIn;
	spf=pass (imf16.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 400FF600E1
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 17:09:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB5211F00ACA
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 17:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782493781;
	bh=yHkZooWF8Ur28rAu1FbBgAaf/eWl4Mro8CPDk/C5t70=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=UEqtGlInS/nNXROmRFoFqBWzjp/Utzbrjc+IMajKfak8UQw1c5V3mQdBgEE5rr9wa
	 fgOo5QypchemewqU1PTnzTv1iuc1Z4Ue39X6hPnTAQOY5PzKEZf2zka2V9gKGxv/i0
	 Jfb8xCs7t9oClbUbACgTbpw/RbTh/Wd5GWaUBQ+kGzAnJlLAVk8bUwnLxLs+BY2yjw
	 MgeWCI1+8d21MtxRXnI65AepWQwx0yHlMD5wzW37Dx6Xv05l9vbDyARlcI2ayKx2pC
	 AEBOIYcl+mKFH48ip3fVm5RpG1IhHLcIvRHJIUZFeVKN7PdfVJYAjerwtd99mwnViw
	 qUxY3DXj0SBbA==
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-697763eeafcso2015769a12.3
        for <linux-mm@kvack.org>; Fri, 26 Jun 2026 10:09:40 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrqDtHOIBH5zePTnanPGN8824DDKXN4UjUQNpNCeaUSp7T8LqOxNdbvtJy+qkeQXB4O3GqJsiHtNA==@kvack.org
X-Gm-Message-State: AOJu0YztjaILb3DwciR5wyRr8y62qB3BIz0N7t0kBvA1ecsmSLsMEQW8
	HGJZgSiVaeNUgUokIRutTU6ti+PdH9x0sj+u/cbi45sTaPQKexMsCnSTpE1hZcmxDQQYFhUAQF/
	7qmj/LZM6B0APGEBIq2ulC+87QPTsvkU=
X-Received: by 2002:a17:907:c48b:b0:c12:34f0:f7c3 with SMTP id
 a640c23a62f3a-c1234f0fa0amr79606766b.54.1782493779839; Fri, 26 Jun 2026
 10:09:39 -0700 (PDT)
MIME-Version: 1.0
References: <20260618044857.69439-1-jiahao.kernel@gmail.com>
 <20260618044857.69439-3-jiahao.kernel@gmail.com> <ajnGTt8tkbAWX8Oc@google.com>
 <0916e673-861f-b472-7417-afbffbcc98ad@gmail.com> <CAO9r8zPSZLaqLXw87V3q4tZa8WD7xCympKqfLMLB+o-++GksJQ@mail.gmail.com>
 <91297bc0-268c-e9c2-57ae-6066eee5df2f@gmail.com> <CAO9r8zOYgjbuG5i+LrCcMK764nVpOS+muo-5Q45ZFdiVus-dTA@mail.gmail.com>
 <f1cd1ec9-48b0-1b03-0514-6c9958f3c77f@gmail.com>
In-Reply-To: <f1cd1ec9-48b0-1b03-0514-6c9958f3c77f@gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Fri, 26 Jun 2026 10:09:28 -0700
X-Gmail-Original-Message-ID: <CAO9r8zPVzMKFbCixxD-qgtRrkFxWVrHiZZeLc=eyTPKPVQgX4g@mail.gmail.com>
X-Gm-Features: AVVi8Ce7xUNuZRw0D1P7C4xZVj0W7f5nf0PB5oHQs8hdjJ7b2fS6Xj-vyiTnFw8
Message-ID: <CAO9r8zPVzMKFbCixxD-qgtRrkFxWVrHiZZeLc=eyTPKPVQgX4g@mail.gmail.com>
Subject: Re: [PATCH v4 2/5] mm/zswap: Factor writeback loop out of shrink_worker()
To: Hao Jia <jiahao.kernel@gmail.com>
Cc: nphamcs@gmail.com, akpm@linux-foundation.org, tj@kernel.org, 
	hannes@cmpxchg.org, shakeel.butt@linux.dev, mhocko@kernel.org, 
	mkoutny@suse.com, chengming.zhou@linux.dev, muchun.song@linux.dev, 
	roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BCAA918000B
X-Stat-Signature: mszg7tf5t3onja86t7sej649hnbr9w7a
X-HE-Tag: 1782493781-78910
X-HE-Meta: U2FsdGVkX18ucIeLWhSkJSoq8F8LeZho/vp1aCRAg0HWDmBtRWrr2T0YgsUpamsu4WLoFwB9Z1Vi0fh+8+dsnLfNe7ECwCRkwJ07uDOhg1KDxTBY+5BDhyFuu2Kl6FiUdPxWRiza2T9CI7QA2OkH4TLc59BXLTkmkdWwFVq4xpfcodCCp9s17+0HdbReU0ENvGQpw5ko9oP1x6cORhcwgU3Muf+A7If6vZR5KfuYqAL8wWJeUcZ4awWTOOfuHJ4wedu88S/e5meQgHqGOwWErqM7k+fJukeqgM4Y6dfgh4ZJxf0KWZSbCgPAym3Ve1K3LJelfJbT20nLcnpc38P/uWxvdmeE8lwJffHphHb1rNJPBuaOe2Xx5PZSHD/S0XDIgw4u8vsh2SpLATFBn1hr110ZlTA95ZUil/56DMNU1O0PMVUsYvPXrFyENVdyRuG1fR3c8bSCdE8TPn3hMtAneLQo3a+XHeZR63+UD77ef8ZMdliUudA+exm4EnvjCs2RBfkJnzgLuNvnniDOc8TUqUkauxGmJlA+hUtRNN8O0cTgh8vG8lquWJm/J8RuMjD3Nt5Ju/ES/SqxSWC8q0UIRmNArqaAWZqCXNaWPmtlujMjbrH5gp/Yk7UXiZgUEfk8mOCpA3WezDW4KVvA2cJmv5sry6UFrJm6nVu6iq/mQu5uAGZvVQFVIlr3qjtMlSKjLkiOrQXAaKzXUKF00aN3D5rQMF4kv/EY5Wo7FtaRFwtn4+5JYRlQhBfjbRB6bI+1mbWOQD0T4jylMddDtWLEEEcDC7/B8dOUjmKM/JDdCj5PTk9l4bUAAEZaokpW1vA5fr5jlE3uJyNVXQuSk/C/biEV2oV66Lw1H5YWGV5BSupJ4FKTgLVapQpJ4RiWkMTW75k0INNzArsUy0W4GhaNvMKnaLfbQP/j5oHqNfCicZoMySYQj+P5vYZKz+1qyxRGhB4GgSlqpxUDFkdBN0p
 JICgcEpy
 invwrDZEXnQ6mBk7NseV3a89AzhEwVbJyYOVZL3KzXY+W83+S3ftN8ja5YQ+9eMZaNKlXQgsCvsB7bvxpoHOb6/01y1AgOakAbIBFCQbk7eTLfxSRFkbnybhomy4gY9IqaEJdL1F7n6dip6aax4+sf+IiwjDUGxfUaymts/kncOFgwkMm0qqAoeCqcb/Vp183bijdnIpY+HFExc2HD/EQ5952luvxuSm13zl06fEfqD9n5tSvAQeiTcqIt/ZuFTIZZqegCPWAj3Nu0SDbk0r/pYNjhvDGhCviG0Y67cMRx7HkFGm2Po5C4FlujT+5GXy2C301/ss43NvvQX9FXdZ909Yl874TT16mpN5FAYNiLnZXs6+MzBrQajdI4yFaPwzDRwWz8Xr4m4W2JZ3fBVm3+iWgzA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> >> /*
> >>    * Take one step of a memcg-tree writeback walk driven by the caller's
> >>    * iterator, and fold the result into @s, the retry bookkeeping shared
> >>    * across steps. @memcg is the iterator's current memcg, or NULL once
> >>    * it has wrapped around after a full pass over the tree.
> >>    *
> >>    * The function returns -EAGAIN to signal the caller to abort the walk
> >>    * after encountering the following conditions MAX_RECLAIM_RETRIES times:
> >>    * - No writeback-candidate memcgs were found in a memcg tree walk.
> >>    * - Shrinking a writeback-candidate memcg failed.
> >
> > Orthogonal to this patch, but I wonder if this can be simplified. I
> > wonder if these two conditions can be replaced with "shrinking a memcg
> > that has zswap entries failed". The "no writeback-candidate memcgs in
> > the tree" case seems like we should abort right away instead of
> > retrying?
> >
> > Nhat, WDYT?
> >
>
> Perhaps something like the following is what you had in mind? I've
> drafted the implementation below to make it easier for Nhat to compare
> with the previous behavior.

Hmm I think if we pursue this it should be in a separate patch or even
outside of this series, ideally with numbers/proof that it's not
introducing regressions to the scenario that lead to its introduction.

>
>
> >>    *
> >>    * Return: The number of compressed bytes written back (>= 0), or -EAGAIN
> >>    * once the retry budget is exhausted and the caller should abort the walk.
> >>    */
> >> static long zswap_shrink_one(struct mem_cgroup *memcg,
> >
> > Nit: zswap_shrink_one_memcg()
> >
> > BTW, the existing writeback logic has been broken for a while now when
> > memcg is disabled. I think we constantly hit the !memcg case and run
> > out of retries. Not sure if your patch changes this in any way, or if
> > you want to fix that while you're at it :)
>
> Yes, I'd be happy to do that. However, would it be better to submit a
> separate fix patch or combine it with this one?

A separate patch. Feel free to send it with this series to avoid
conflicts, but probably as patch 1 as we'll want to CC stable on it.

[..]

> /* Track progress of a memcg-tree writeback walk. */
> struct zswap_shrink_state {
>      int scans;
>      int failures;
> };
>
> /*
>   * Take one step of a memcg-tree writeback walk driven by the caller's
>   * iterator, and fold the result into @s, the retry bookkeeping shared
>   * across steps. @memcg is the iterator's current memcg, or NULL once
>   * it has wrapped around after a full pass over the tree.
>   *
>   * The function returns -EBUSY to signal the caller to abort the walk when
>   * either of the following occurs:
>   * - A full pass over the tree found no writeback-candidate memcg.
>   * - Shrinking a writeback-candidate memcg failed MAX_RECLAIM_RETRIES
> times.
>   *
>   * When memory cgroup is disabled, the iterator always yields NULL. All
>   * zswap entries then live on the root list_lru, so NULL is treated as the
>   * root memcg and shrunk directly rather than as a completed tree pass.

I think this chunk should be moved above the code returning -EBUSY
when mem_cgroup_disabled() is true, and probably made more succinct as
it should be obvious.

>   *
>   * Return: The number of compressed bytes written back (>= 0), or -EBUSY
>   * when the caller should abort the walk.
>   */
> static long zswap_shrink_one_memcg(struct mem_cgroup *memcg,
>                     struct zswap_shrink_state *s)
> {
>      bool disabled = mem_cgroup_disabled();

No need to store this in a variable AFAICT, it's a static branch and
it's clearer to just call it directly in both call sites imo.

>      long shrunk;
>
>      /*
>       * If the iterator has completed a full pass, update the shrink state
>       * and check whether we should keep going.
>       * With memcg disabled the iterator always yields NULL, so fall through
>       * and shrink the root memcg directly instead.
>       */
>      if (!memcg && !disabled) {
>          /*
>           * Abort if no writeback-candidate memcgs in the last tree walk.
>           * Otherwise reset the scans count and continue.
>           */
>          if (!s->scans)
>              return -EBUSY;
>          s->scans = 0;
>          return 0;
>      }
>
>      shrunk = shrink_memcg(memcg, NR_ZSWAP_WB_BATCH);
>
>      /*
>       * There are no writeback-candidate pages in the memcg. With memcg
>       * enabled this is not an issue as long as we can find another memcg
>       * with pages in zswap, so skip without counting it as a candidate.
>       * With memcg disabled the root LRU is the only target, so we should
>       * abort if it has no writeback-candidate pages.
>       */
>      if (shrunk == -ENOENT)
>          return disabled ? -EBUSY : 0;
>      s->scans++;
>
>      if (shrunk <= 0 && ++s->failures == MAX_RECLAIM_RETRIES)
>          return -EBUSY;
>
>      return shrunk;
> }
>
> static void shrink_worker(struct work_struct *w)
> {
>      struct zswap_shrink_state s = {};
>      unsigned long thr;
>
>      /* Reclaim down to the accept threshold */
>      thr = zswap_accept_thr_pages();
>
>      /*
>       * Global reclaim will select cgroup in a round-robin fashion from all
>       * online memcgs, but memcgs that have no pages in zswap and
>       * writeback-disabled memcgs (memory.zswap.writeback=0) are not
>       * candidates for shrinking.
>       *
>       * We save iteration cursor memcg into zswap_next_shrink,
>       * which can be modified by the offline memcg cleaner
>       * zswap_memcg_offline_cleanup().
>       *
>       * Since the offline cleaner is called only once, we cannot leave an
>       * offline memcg reference in zswap_next_shrink.
>       * We can rely on the cleaner only if we get online memcg under lock.
>       *
>       * If we get an offline memcg, we cannot determine if the cleaner has
>       * already been called or will be called later. We must put back the
>       * reference before returning from this function. Otherwise, the
>       * offline memcg left in zswap_next_shrink will hold the reference
>       * until the next run of shrink_worker().
>       */
>      while (zswap_total_pages() > thr) {
>          struct mem_cgroup *memcg;
>          long ret;
>
>          cond_resched();
>          /*
>           * Start shrinking from the next memcg after zswap_next_shrink.
>           * When the offline cleaner has already advanced the cursor,
>           * advancing the cursor here overlooks one memcg, but this
>           * should be negligibly rare.
>           *
>           * If we get an online memcg, keep the extra reference in case
>           * the original one obtained by mem_cgroup_iter() is dropped by
>           * zswap_memcg_offline_cleanup() while we are shrinking the
>           * memcg.
>           */
>          spin_lock(&zswap_shrink_lock);
>          do {
>              memcg = mem_cgroup_iter(NULL, zswap_next_shrink, NULL);
>              zswap_next_shrink = memcg;
>          } while (memcg && !mem_cgroup_tryget_online(memcg));
>          spin_unlock(&zswap_shrink_lock);
>
>          ret = zswap_shrink_one_memcg(memcg, &s);
>          /* drop the extra reference taken above */
>          mem_cgroup_put(memcg);
>          if (ret == -EBUSY)
>              break;
>      }
> }
>
>
> Thanks,
> Hao

