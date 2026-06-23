Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4080DCDB470
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 10:25:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E48186B008A; Tue, 23 Jun 2026 06:25:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1F886B008C; Tue, 23 Jun 2026 06:25:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0E616B0092; Tue, 23 Jun 2026 06:25:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A96686B008A
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 06:25:12 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2E94AC1D9B
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 10:25:12 +0000 (UTC)
X-FDA: 84910794864.30.7A8636B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8C51A40004
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 10:25:10 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E4KivSwy;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782210310;
	b=elszbqy/fFTy1gH2YOj9mLqjpqBjjb9W+kd/BZxZUPaf7fXDUcJq472WSbNpkAwXpF5FLI
	5dCRV7lIyivJGvDygMRvuF0OqgrG0wI7NQGxVyhMUEN0W6O/0S7Kch2hhQKhQr/wrcL0Rl
	MF75bYGEzWWRcVn8SL+QB4jWaIFRWDI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782210310;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QuwqPl/DdRExnnCu9OGScQ5Xmc6WliItT49dCHtwxdw=;
	b=MBstWD/9F76YwbPwFQwLVEbSB2R1FmfyY3T1L4wmzX38BxzQUILxAO1y7CrleV7PH4b9p6
	ahx12/VWjaJxS77qlCK19eDkQz7lvt1cM5g69St1RhBSv4fWP5lQvOf5Hc7KUKxfSv9J21
	bdkg8C1ghg3Hnxyd8TgSjCYZC8yEM/k=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E4KivSwy;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EFF3B60207;
	Tue, 23 Jun 2026 10:25:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AAE21F000E9;
	Tue, 23 Jun 2026 10:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782210309;
	bh=QuwqPl/DdRExnnCu9OGScQ5Xmc6WliItT49dCHtwxdw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=E4KivSwyGZFxXffDk/Vt3Px8vA1CbyhPHDP47lNNJ7szT26VvcSc7qGCtrBR90H/k
	 rKJn+oEhr43yZ92MkI6SLFEI7zny0/e4YijR25E1lI/JuBgEKP99aBDpCOALVN+iXx
	 c+bPYmiBSofBu9XN/II1kzckbdcDV3Hg7OsDNw/xJ3ra54hJ9QVWhoJntkXyoFNPt0
	 bD8plIrLTi/QiYw9bTycvJDyNnFdcIXHuedBb1+aTsqsCL/D39Jv62cYU9pj1ARwoj
	 2KvD/zpvrHSMriP88SRSH7NefbWyChEQUZHOALvxF6jf83DGmejAt9chUxhNWHXYpz
	 izbpybBP14RFw==
Date: Tue, 23 Jun 2026 11:25:02 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Hui Zhu <hui.zhu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Hui Zhu <zhuhui@kylinos.cn>
Subject: Re: [PATCH] mm: avoid KCSAN false positive in page_to_nid()
Message-ID: <ajpehMzABvNh1wN_@lucifer>
References: <20260623074157.578113-1-hui.zhu@linux.dev>
 <97f2c4ad-c302-424d-a7c8-fdfa0fc0d811@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <97f2c4ad-c302-424d-a7c8-fdfa0fc0d811@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8C51A40004
X-Stat-Signature: b88z9gwqjicjwrhcq97f3nijtkzyn58m
X-HE-Tag: 1782210310-554922
X-HE-Meta: U2FsdGVkX1+ZCOxJewqUA8cLie8fbK7oiqfk0uL0M/m511WfoFPhiL2V58If8G5RUHTEunKV8rjxSa8EdfBjUBbQZ6RLAfylK2nuO1FatqzZR9Y8ho8a0KpyAguffL2caM8Zac2l7k/fq/Xg0PtLLyU85suuX8asUfF4Jvl3FH+D83an5vEXlerJgvyWL/RTSzLz5lfOMdtmEjYuYileEDfDln0DanfeUcPuwRcrBgbtILQ44eVJ+EZKNXbyFwvsZSlGrAzUdFWOJ8Lsx8ft5fj0t+Men7htxvH1ctmC7r/NhWxCdN0ipExY4rfQWUzlKaZr7RgMlqGSVrEsXIEPuH4Jph/xkR/4OuoiUCcPL6mEqyHvi3vB7UZd+HJw2JYu9mw4gZPK235i9gHN6SsOGAL3uIWqVDD2K4Vda7vDd1C3dCFZMSNzsgYum6t4zzuDWpSVOfpUqxTgnW9mPW3kp9wm84DV7M6Xyfcwfh+RCKr2V/VFBAAdnxEk1mQvxFZixoCDvdFWxR2tBQVNkUQpqLD4lcr0O9ZCi9dV+F7GqXhQTTAGvP5l5Jm2FPkbCpsCpb3DhpWgkhcpPy0UhH3xwxA7eQcJuNRkBuzzoPNz5yWzyTWc/j4RlCL5Wc4r0yJoQ/EFyJpKNgxcPkg+fiz8BJ2vMhYlimQJzLBjORSEXzwm2TCvY0+78qM/kK3T09roZwheaQMC8Je7Zg0xA3bfQHq/h6qTcvGFrnzjjCHiXKWEUJSAUHzMQOCYHx7zx6ujVIprQEyfI8LINWBLRwC6zPNwOYDe3ccrnC9vXUKhtLw/7gtt5dZHF63Y/tkMewx8UkubUnsaJwISmPMkWgbY2Yfv7g6Epu8AoUreuh/Dlm5SWVMPBh42Y+7jF5hKzdJsNg1J91054cPyhkamY31T7zGfWlwd7csiCmkgyzJ8sR9Cd/GkVehB1D0saHxzs7IrtrxaRlMFZOLom1GHdvN
 wWmPmkV+
 us6Q+Ve6z9z2mIP9AoQ2KOyL3lrLPFzrctFuwB731Kih+DZRBcyylvpbKrk9/nINT6h4qRbhgODmWCsboaMWnP8ykI+AHp088VrhTjElcxHfpP/ZzzNyD1hhhaiXN6d2BwiCKZeQXECtJkaluan3M4MZ6AB9TfJA9sQi+3mstFpP3f4YmQiiR7XIRMUibnGUSeEeaRe0+EV4dvG550QLbcDAbbGAMU5eDUhktY3Ibnt5qOjdpnO7JPDOewFwPbT77VfTqMHySys56vQm/VuOHDgbGesrPQipXFzx3h6Xz7xCx3nGIL+n+ewkIS++L/n4Y9E8qkFh7ND7xFMVMwXtWvNyefgp/Vndi8pXU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 23, 2026 at 09:59:45AM +0200, David Hildenbrand (Arm) wrote:
> On 6/23/26 09:41, Hui Zhu wrote:
> > From: Hui Zhu <zhuhui@kylinos.cn>
> >
> > KCSAN reports a data race between page_to_nid() reading page->flags
> > and folio_trylock()/folio_lock() doing test_and_set_bit_lock(PG_locked,
> > ...) on the same word from another CPU, e.g.:
> >
> >   BUG: KCSAN: data-race in __lruvec_stat_mod_folio / shmem_get_folio_gfp
> >
> > The node id occupies a fixed, high bit-range of page->flags that is
> > set once when the page is initialized and never modified afterwards,
> > so it can never overlap with the low PG_locked/PG_waiters bits touched
> > by the folio lock path. The race is therefore harmless: page_to_nid()
> > always returns a consistent value regardless of how the read
> > interleaves with the lock bit ops.
> >
> > Wrap the flags read with data_race() to tell KCSAN this race is
> > intentional and benign, consistent with how page->page_type is
> > already annotated for similar packed-field accesses.
> >
> > Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>

How did you discover this?

A syzbot report? If so please include Reported-by, Closes tags.

> > ---
> >  include/linux/mm.h | 9 ++++++++-
> >  1 file changed, 8 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index 485df9c2dbdd..122d3b39369f 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -2296,7 +2296,14 @@ static inline int memdesc_nid(memdesc_flags_t mdf)
> >
> >  static inline int page_to_nid(const struct page *page)
> >  {
> > -	return memdesc_nid(PF_POISONED_CHECK(page)->flags);
> > +	/*
> > +	 * The node id occupies a fixed high bit-range of page->flags
> > +	 * that is set once at page init and never changed afterwards.
> > +	 * It cannot overlap with the low PG_locked/PG_waiters bits
> > +	 * that folio_lock()/folio_unlock() concurrently update, so
> > +	 * this data race is benign.
> > +	 */
>
> Do we really need this excessive comment?

Agreed, just delete it. For a trivial benign data race it's a bit much, and the
commit message can cover it off for those who are curious.

>
> > +	return memdesc_nid(data_race(PF_POISONED_CHECK(page)->flags));
>
> In memdesc_zonenum() we use ASSERT_EXCLUSIVE_BITS.
>
> Can we do the same here inside memdesc_nid?

Also agreed

>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 69daeeab7fe8f..76d3bb54be844 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2290,6 +2290,7 @@ int memdesc_nid(memdesc_flags_t mdf);
>  #else
>  static inline int memdesc_nid(memdesc_flags_t mdf)
>  {
> +       ASSERT_EXCLUSIVE_BITS(mdf.f, NODES_MASK << NODES_PGSHIFT);
>         return (mdf.f >> NODES_PGSHIFT) & NODES_MASK;
>  }
>  #endif
>
>
> --
> Cheers,
>
> David

Thanks, Lorenzo

