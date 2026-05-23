Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55863CD4F54
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 06:22:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 192B36B0092; Sat, 23 May 2026 02:22:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 144756B0095; Sat, 23 May 2026 02:22:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 032546B0096; Sat, 23 May 2026 02:22:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DED226B0092
	for <linux-mm@kvack.org>; Sat, 23 May 2026 02:22:14 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 764CA1C0977
	for <linux-mm@kvack.org>; Sat, 23 May 2026 06:22:14 +0000 (UTC)
X-FDA: 84797689788.02.87BA680
Received: from mail-yx1-f47.google.com (mail-yx1-f47.google.com [74.125.224.47])
	by imf30.hostedemail.com (Postfix) with ESMTP id BB05B80005
	for <linux-mm@kvack.org>; Sat, 23 May 2026 06:22:10 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=PmcclxZk;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf30.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.224.47 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779517332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=93cXnKxQtAWAU0c35mxqnBLaD/K6nObA/5QvwUOXuOk=;
	b=wJK65voSnBvnGKNGSBjRp6PBxxItWcVKDvs71g5pupAIkZbX28Hozlb3LQzD8Fqjvls4wR
	G2yjaCV+u6TDbj1kgrRZz9T9gcuD6mSv2y09tsPHwOoz4m3+4pYRf58SPYM4v6E1oZ5jIa
	yjuGMCefmmvyXbJvVvxT8ySYnBXVobQ=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=PmcclxZk;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf30.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.224.47 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779517332; a=rsa-sha256;
	cv=pass;
	b=RsO8/6C7u/IqH0NWGvP4NwOaEJlrlC36Wbeqw7npR0yH0fsO0lqgq+cMpjWlJPgIN+HzQv
	KQiMm1EimWOTMAt23Kdp/D91YZqKyrxrjCguN1LZlM0ZHLs7COB9E/8aEkSxIyx0HTf7J7
	aMH5x1ZZDKtGgDDpQrQ1dtBLGMt9rFk=
Received: by mail-yx1-f47.google.com with SMTP id 956f58d0204a3-651c366f7efso8334929d50.1
        for <linux-mm@kvack.org>; Fri, 22 May 2026 23:22:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779517330; cv=none;
        d=google.com; s=arc-20240605;
        b=KuJfob79FlAVEcREo0+B+sL+ytDj5pdKjZ0SK8aqoGlpPjM1R5Fzx28gWc9+kKoFvH
         J6ZKXOXOb1CXCDyDF3Xy7cb5pG6n/6OvHc2CTV0kfaHosTVCVqwQXxtlQmeiTmO/M0rs
         mHPBpEzghJ4tr6TO7TosIpuN5MI/WQo5JM/L3Lu5w19CZ20HlhUZ+Ac/e6ogDWiRkcS4
         KGp9dCERqp6HgvSDOFJNMP3LwLeaFy0JvIWiZVM7y7/codhG/9BVU1MkvCpBlPMjL/lz
         SEcm8GBLpVFa0s7DQUKRRhgO9W1ITFB4f7NM6ab5AMWV9yyyXvtdnIxNqRHAoH0T77Hk
         k5Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=93cXnKxQtAWAU0c35mxqnBLaD/K6nObA/5QvwUOXuOk=;
        fh=Aw+IMVJNN3kOyof0QVTLvapQJFvdvOZs5XmWhLVzWzs=;
        b=UqNIdnWwcluOuXb/S6G2dJKSCWLqZtp+jtIplzwgMpFDeui/UqqGOENG4ZZnTFRhHM
         NcMxLIe99a9Iyb/CGCRLP+NYdCqkZ8wUY/QU0ctx57wER2k1mTerYSKsDxiuXxbDMnI3
         VBXtGw2gl3q5lp42LX1QG57VZLYnf1zagXk8DzRosOFO/P529UFSYbIik20ARwTrZbeS
         3k/KNnH/KgnkQZkIBj8p6RZpO6EmvIAIGvW4BRVIVpNl0JUqQtu9oqYqb6tgSpW1LGSE
         Awy+gAOxFFW18isntrXu8AzN8iZSrST09LacFL7jOhNyrKSJHCC8pGEwanEXRJUW9meg
         T2DA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1779517330; x=1780122130; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=93cXnKxQtAWAU0c35mxqnBLaD/K6nObA/5QvwUOXuOk=;
        b=PmcclxZkp5MKwJptjrVVfOsdLzzHd5rBSpZ3sHtlCr9huAy0DCP5iy9KvLpJ4OtSB+
         eM1BC7gxbo8M4rTnE4lKdLdXOMGAyd4Ee7drWe+QiIrLylTOxC/wNpd8aLuAuz19Va7F
         cyhXybOJRHqoo3HEePqxJWC/40dNBpyWUzMBRzVUw0/FDSJq1GG0vJisWtg9jVUdEYVw
         Iffr+ppXpWDdLSnh5daEAkUXgjzgWP0XkbyZ/yeQD/R2GePdLfkkGbeXAvW94MJth5U/
         cDZfTIPFFl1OLqeXbVTwHSzlvR2JEWZ3rwu6mbdlCI+2BS0t4+MQOuHnaUtIUuJTXAMl
         Dpkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779517330; x=1780122130;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=93cXnKxQtAWAU0c35mxqnBLaD/K6nObA/5QvwUOXuOk=;
        b=e2yLHPkR+CPJuMf5QBRhyuyp7Gj1z9DFmhPsO++VDsKchKYbyhuVmGISkFa6teke1V
         UbwLzCLa99mf9UzTnaBpu9yxkgiBvg4X2fKkSKQZquu7irdro8dAroLLq/lDgDGUPG4Y
         2R51oenrhgrNnE+URSoBRqQ6+3KJs3v4VtyhNjWTBfgIWIS5XRKz7hY0ybeetDPQB3tf
         3cxpVyEZw0QImX+9180Fpsc/jpE+4HHiFwxIghzhFNi0RiaHMYKpY+Y/8wdwJJ8kCoog
         CMmtBQipEHlydWe0/J4aA2ncoTjbhEVmzcbjq09CIyJgAwieqwvJR7KfsT67McOoAMdN
         ywuQ==
X-Forwarded-Encrypted: i=1; AFNElJ8AhWCkFFth4o9zVe0a0VU8bDvCt3X3QOP78sOnV25x8xc8hzX79CJsZCadDbQgkUErRg/Rl0cAyg==@kvack.org
X-Gm-Message-State: AOJu0YxNMs0ST1IjsQYxWDEANwmIdr3TGNCxaOte3vUTKmGXw6f8cmbW
	acuEmvCYHh5O1UkiewPHqYBD93ABmK37iyEHpsY4tb09bImTv/JKDjpDcMyNk8/bJ8zU3XX3K9n
	ngbuJtOCcxSkuNXc2f77/Mf3v02EWYrDn4C12MSwJmQ==
X-Gm-Gg: Acq92OG4MVOWQCOLARe4cOnviB40By8MoJEfGJAgG3ADuzqpop7kciA9ik9RPkqi60H
	qgsHn4ESaWfxwQrHyzIMrosiBmY56UltImS0NLAln1rii9SjvSM+z94LItQMSUE0R+8ByTsnXya
	MwHZeMjZco2KAkrtD047noBhMWtbkh7nlmk8HaVdWomV+Le8etmd5+Cq9udWwroumaTfDta3aQR
	zJn2UL3FyjrwpHOGFZRx5O/th2RHP7hvSNk2IrGpg3klNhMdt6jGEjWCi0EMR/LFRci4XfIL/R0
	WrivFVWwYA==
X-Received: by 2002:a05:690e:4286:10b0:653:f72:f482 with SMTP id
 956f58d0204a3-65ec97963a1mr5291791d50.22.1779517329556; Fri, 22 May 2026
 23:22:09 -0700 (PDT)
MIME-Version: 1.0
References: <20260522131434.78532-1-kaitao.cheng@linux.dev>
 <CAMZfGtWO7=UfnVB9oR6sS6eGSBv0-pKciFqpoB60aq66fYTSow@mail.gmail.com> <20260522194910.9395371c3d3d1bfb87cd1211@linux-foundation.org>
In-Reply-To: <20260522194910.9395371c3d3d1bfb87cd1211@linux-foundation.org>
From: Muchun Song <songmuchun@bytedance.com>
Date: Sat, 23 May 2026 14:21:33 +0800
X-Gm-Features: AVHnY4KmQqqrqBIG12v5idDi1ReWaE-Ung-AvJNBjQmY7Rmu37DtG0_5_sje-5Q
Message-ID: <CAMZfGtX3qXudLNTOdc2scfOkH_ycaOmV5L3YYDCJU8oix8-7qQ@mail.gmail.com>
Subject: Re: Re: [PATCH] mm/cma_sysfs: Skip inactive CMA areas in sysfs
To: Andrew Morton <akpm@linux-foundation.org>, Kaitao Cheng <kaitao.cheng@linux.dev>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Minchan Kim <minchan@kernel.org>, 
	digetx@gmail.com, John Hubbard <jhubbard@nvidia.com>, 
	Greg KH <gregkh@linuxfoundation.org>, 
	Linux Memory Management List <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, 
	Kaitao Cheng <chengkaitao@kylinos.cn>, Muchun Song <muchun.song@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: gwznuy4tz3hq6ng6nu3dn7u8u7fo58ea
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BB05B80005
X-Rspam-User: 
X-HE-Tag: 1779517330-653526
X-HE-Meta: U2FsdGVkX1/8bmBFEh7JBWQP6KVnIZtSKKkBY7pIq3HPm5xeQcyTR0bjoevyJhgTTsRdzYiWA6Ob4l0JsrlKtlPX4+E4JCcM/UvWjg7a9hBvQXI+g77JJCkiZsFomjgMBrM/XCpDVFKhdnqBzobAGjo466YKjnzUK7MafEaDi3+dOeCu21gjV/XCUwv3M3gyvZtYRqIqbhvZG6Mc+mwCUm53crIrO+rQPEMptdIL38i1M5ZSA5rSeYHneqTo15ckyVxdVNpIVaGCk1TUywO7+BPdaFFwV6q825izrdBUL8EFxQFaolSBd1jDgklD6+uFlMwAbCH6jJLYH+9R1pnKjxdyhsLE4nfoDZwYyf4PjV4dFQD860ddOrQYvrV+Dak6k0HF4N80k5fkkDz0cPQcVCOFqrUXy5vJpSV5ICkuDVEXOKG935dvgYLashYG69nDXGhDr/pecFc0KKPaTyrmM9gzFxYpox+rLdeDImLLLEF3iXBSQ3k5cT1FJtW532ZXiCtGRpwLtgeiTpq7U4TDeSGBoHWQd2aRsA8amTXIKgm6+vkB2uSiJChU35f4f1KkErsC86IT5bj00VOfMQc3WSnLwu1K+PZp06z1bIkqkjjXXy+axNpZ6H+fbrI5cX6mCc/Uanv8TIuCTXvlyRJ8nLBfQUYXJSRIl8621jMoEfE36FrfF2Qgps4sNxDiCtMK0s6glFJPKNi2NM9iin1acOATcTNQzHZPr2BpQXwUMI6FSTlcb8XdnzeyGOFSQ21X6J4bm1z8XXCh6nghoNDq580QfwsT90EzP4Qh53mcPE7G/lYR37dsKu4F4mBcyWLrF5JKurckj2GEE2h/lVQW3TvtzjSoniBDuo24gB3Mz9x9ZNjkrGHVhEmInMi0ZneebjZXFSoVKDExEmNNEQnHcg230PLR/ZCRY9ztHiOqsDDBjb1YfgwDsxi7lczD0ZjiRugjXUNoyFScLtkWhmH
 UROIiE7p
 87ob/85/JwSvEn2TmY2P2K3iZqejjb6JoUNxRGXH93KR0nDSHr314beEgcRQuXmyCdm7D5vIZwwYDoQPHebgnPM4VmQ5Px5uuJCwEwADczs5jraQw8dVdrn6Q3XFUf9IVlYCh584H8waSDHE3ckqXtrFT942PQL+l2ESxJnSpMqeIP4/i+UzsQZbNS9q1iw99V9+aj/Ey2F6USIn0enRsmwIvLTulGzWgOi7ehfJUHHJjTZlUOUlAyaq3WRr/ZJ0sfs/xv4OVPr0KA5ZsVbCrOT/WfuerU1HlhBnxKagzc+feqAI3r5lHGoVxGNxnD94Q0Q6iz+3qjPsCKSRJwNxbTxQ5QH6MAIgXzCcCuxSTgtlPC6B6KQzrg1TKv0Rr/1AIZVoO9/vcZL95AtKtB5AAuI1mdQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, May 23, 2026 at 10:49=E2=80=AFAM Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> On Fri, 22 May 2026 21:26:59 +0800 Muchun Song <songmuchun@bytedance.com>=
 wrote:
>
> > On Fri, May 22, 2026 at 9:15=E2=80=AFPM Kaitao Cheng <kaitao.cheng@linu=
x.dev> wrote:
> > >
> > > From: Kaitao Cheng <chengkaitao@kylinos.cn>
> > >
> > > cma_activate_area() can fail after a CMA area has already been added =
to
> > > cma_areas[].  In that case the area is left in the global array, but =
it
> > > does not reach the point where CMA_ACTIVATED is set.
> > >
> > > cma_sysfs_init() currently walks all cma_area_count entries and creat=
es
> > > sysfs files for every area, including ones that failed activation.  T=
hese
> > > areas are not usable CMA areas and should not be exposed to userspace=
 as
> > > valid CMA regions.
> > >
> > > Skip CMA areas that did not reach CMA_ACTIVATED when creating the sys=
fs
> > > objects.  Since inactive entries can now be skipped, make the error
> > > unwind tolerate entries that never had cma_kobj initialized.
> > >
> > > Fixes: 43ca106fa8ec ("mm: cma: support sysfs")
> >
> > Actually, this is not a fix since there is no serious issue when access=
ing those
> > sysfs files. I think it is an improvement.
>
> I find it hard to say because the changelog doesn't have a clear
> description of the userspace-visible impact of the bug.
>
> > > Reported-by: David Hildenbrand (Arm) <david@kernel.org>
> > > Reported-by: Muchun Song <songmuchun@bytedance.com>
> > > Closes: https://lore.kernel.org/linux-mm/55481a8b-dcfc-4bef-ba59-aa0b=
43dca88b@kernel.org/
>
> That says "Reading the bitmap file can make debugfs walk a freed range
> bitmap and trigger an invalid memory access".   Maybe it oopses?

I think the Closes tag should not be added here since the commit in
the link actually fixes
a bug when accessing debugfs files. But this commit tried to hide
inactive CMA from sysfs
files. It is a suggestion from David in the linked commit.

>
> So Kaitao, can you please send us a clear and complete description of
> how this bug affects downstream users?

It will be clearer if Kaitao could resend a new version with a clear
commit message.

Muchun,
Thanks.

