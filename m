Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 421C0C88E53
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 17:56:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5506E6B0098; Fri, 11 Sep 2026 13:56:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 501756B0099; Fri, 11 Sep 2026 13:56:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 416FB6B009B; Fri, 11 Sep 2026 13:56:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1B78D6B0098
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 13:56:32 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B055D1C1E16
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 17:56:31 +0000 (UTC)
X-FDA: 85202236182.29.48DA741
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id E21FA40002
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 17:56:29 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I3Q9tEOV;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789149390;
	b=sEhtbyYbB4yg5Qe9K3fiDdpzezToW64fU35y8EOmQPsa5pAPV+r2hRwRG63uUzaarNdcX3
	h8qw4No1k1UZ5MIEbpBYmxsWFNK3GZtTTtykaCqacq18XgsvsVhZEo/eq55Q6q3VRVAhHb
	StZIp7OUJYVkyWS0lJnwFvbINoXobrI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I3Q9tEOV;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789149390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O7i4wFJzTZyCCl1oe/KqJK+22QuW1UsUuNg+sPszn9U=;
	b=yt5LkflVNUdROMqP3DZeWhDuUQ+c2AUwqCiOmmjNTnQjxiPHJlT2ZOc8K/vpuLQy8fUzge
	ppVvht9KvyD1V88Fk6D8FQhxMJtdt5VgwaeAx7NcxaxMoGsMiANOMZzJ5E19jHxkUA+2pw
	Z7uzgaP5LyLnkxveHqLBTLCGK4+NIrg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 47F4844501;
	Fri, 11 Sep 2026 17:56:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D965D1F00893;
	Fri, 11 Sep 2026 17:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789149388;
	bh=O7i4wFJzTZyCCl1oe/KqJK+22QuW1UsUuNg+sPszn9U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=I3Q9tEOVl8fd7MndOkpxilz+TNqofFh3zVFY79jYW0vSNXkJU5fDsKwzkl9AtnJcE
	 gVB6USq/PgqGOhMRc+WrV089nIscoKhC211kROVObR2aWddqyjKCw3BT4TcQ4gUZGL
	 Pg8XbQ/d4fJ8rYgFFYxcUPMhSzBYNW3lXNe9G97vo4PDhTIeMjmPV9YPeJWWd3wl5O
	 tEpjvRJ111UUjcIpcZPEVn0sZAy0ySMpK5WED+KmpLafn414pimMuz+tHTSjj77LLF
	 p4PqmW34CMPs7L33XVGSVTN1eboGXo/mYfrIXY79FIzi++GIp4BgWuxYOodIS2tCFz
	 ZRU6yBO8coIog==
Date: Fri, 11 Sep 2026 18:56:22 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, liam@infradead.org, vbabka@kernel.org, 
	david@redhat.com, willy@infradead.org, jannh@google.com, paulmck@kernel.org, 
	pfalcato@suse.de, xueyuan.chen21@gmail.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v3 3/7] proc/task_mmu: clarify shmem mapping walk
 conditions in smap_gather_stats()
Message-ID: <aqQ_cPerswqY9ZPL@gremlin>
References: <20260910234737.1340642-1-surenb@google.com>
 <20260910234737.1340642-4-surenb@google.com>
 <aqQoPTTUC9M5HkYb@gremlin>
 <CAJuCfpEHeFSMamNhf=FLvFjh9D8DBwZtbKwL0zi=x-2g8B+ENw@mail.gmail.com>
 <aqQzk2AT05r6rOyT@gremlin>
 <CAJuCfpEMd=hVtwe_9Rp1kqigYJwqEUGCD+ViQmoacAZONCR6DA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpEMd=hVtwe_9Rp1kqigYJwqEUGCD+ViQmoacAZONCR6DA@mail.gmail.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E21FA40002
X-Stat-Signature: 9rpaspxmada5ryknfukfkauz5csuubz6
X-Rspam-User: 
X-HE-Tag: 1789149389-4665
X-HE-Meta: U2FsdGVkX190xlG6OvRv4h8DH3DYMOWhG8Vw3paVoQOc6iG2eZtlhf8d33x0meXq1XxRT5lF11VWaKGw6HZ6H7Ik0Ft1dRqfrDM1yHzuEdubyK28CzUXLiW4Oo9hqvRREPY//LK43h9HVrun1NpmVd1wqy5qAT3ReC3YzH9J1lM1d4p3yZYV26diAPe9M3IcLRGAoEITfDGED0YuV4Mo/W94m2ucrsxEw+baBEYcE+Er+QHnTUzh+A7/FD5XEWY1CFkNiinOsuxIiynuaq+epD1ITL7g0dFe3dueF5uGbFrT2WHg4Y8lnzmNDRRTOXKy7x80APCv2k6vsXH/VyOfH4QV1JHDix7odr+/CkURCuCRbjaT5+wkPhcGStXEOz3FDh7lWBBct/BxmibgTAOj37WpGn9s+/aLf8vp96cloHP8ZJRgEDlnld1WfyuNyn4cJS10VrSKJGD/mlDh+1LOZHbhvdwlqSABi33hgt/aCk3iO+RrWRUXGD82Wq9gIiM5YaRu+buJY4DTo/DtUfo249QNYwlt+WtjFi9GBg8sYN+irn1XjfOA6yJJJBLcgBZep4Iu+w300njXQZMEltgE7wQ7AhMOkJEPVQMvE6GnTafeiokCFjOiOqP4baqtyJdHSdvET1LnUOeUNenrB4Pv+G3ztByqxVvUhyVRcFKX6E+BuBhHzm28F2TGJbwn32pX/HC9qUW8+Z/ieD2CcWMjAW29Ja9IX4+7c4OfrwPtUnXhUjWaksAV1nZpoxW1Rj1ZOlPSI3INsQdD57JoCw9deqL1NBVVZA1qgRDXnLGt/edkm1HkmrccwesDssy2m3AjJCdVKLVlYSqfhdCeF4aMUwIvWsGp5Rmo+EGjC+y9Lv+v+6p6h0XQ9BXdbh7in/lkaRGU7V1VrTWWB+B8E8LkaG93gPd1NMUpeb8vD1SkzYogguzRFUqUPyY1VS4hRk+Kuc7eFVBG4bN+0xRYz8a
 KyohE4u9
 v4TkgoR7427WN6eB03u8ojjy+nvjKHiIMUGFo0lDSRoILf4fJlZONNytflBf8n8rnenSY9Wf3qi+h6JFMSEkU7aueXH8FXyJhCL9bopwSPklZ7JP8mMAaxcTMYTRNzNJtf+ND7YRXeDd/+7FjTKKOfJp7Q3Ze7Yyh0cX7nmh78Lj48Qi1AKFp5r20Y9Q4r77ippcdVWKc7YdK9DaolILzxhydF1TrCvRXhFJ9dCTDqQv/vvh+L1qTe/PuYcNQHfC9eut8TqcfVfTUkfE+GQO0BcDl96nT0g5xLOENHFhls7+0MRD2F7wSz+sfukzbB3uRrQRpUO36/hbq6qL9b85wJ4G8x5r4RP7ecB4i/7BaVAXd3b59blPgQAPVIJuQUJ04RFSOtSeg2UPg3GGaSfOSMm9P8yKRzLdz4wcPzX0R8PBcWQCAOFa31GWcapZPqy9r2uzc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 11, 2026 at 10:39:01AM -0700, Suren Baghdasaryan wrote:
> On Fri, Sep 11, 2026 at 10:10 AM Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
> >
> > On Fri, Sep 11, 2026 at 04:58:40PM +0000, Suren Baghdasaryan wrote:
> > > On Fri, Sep 11, 2026 at 4:28 PM Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
> > > >
> > > > On Thu, Sep 10, 2026 at 04:47:33PM -0700, Suren Baghdasaryan wrote:
> > > > > smap_gather_stats() optimizes stats gathering by skipping the walk for
> > > > > shmem mappings in certain conditions. Update the comment to clarify
> > > > > these conditions and use vma_is_cow_mapping() for COW identification
> > > > > instead of open-coding it.
> > > > > Instead of using (start != 0) condition to identify partial walks, use
> > > > > more semantically correct (start > vma->vm_start) check.
> > > >
> > > > I don't agree what you're doing is semantically correct, it's a hack really.
> > > >
> > > > Callers are passing start=0 to indicate that the entire VMA should be
> > > > processed and that happens to fulfil your criteria but in a surprising way.
> > > >
> > > > And the start in these cases is corrupted.
> > >
> > > Well, the "other" Lorenzo does not agree with you and suggested this
> > > approach in [1]. Specifically, see the comment:
> > > ```
> > > I also don't love that 0 is taken to be 'start from vma->vm_start' and I
> > > also don't love that the code in smap_gather_stats() actually special cases
> > > this...
> >
> > I'm not sure what part of this is disagreement?
> >
> > It's saying passing 0 is a hack, which is one that is still in place and which
> > this patch makes worse, because instead of explicitly calling out the invalid
> > value, you're treating it as if it were valid.
> >
> > >
> > > How about passing last_vma_end and making smap_gather_stats() more sane? In
> > > the other invocation of smap_gather_stats() we could pass vma->vm_start
> > > here.
> >
> > Yup, well me of 3 months ago should have suggested what I suggested re: wrapper
> > (I think you cut that suggestion out of my reply).
> >
> > > ```
> > >
> > > [1] https://lore.kernel.org/all/aifO_rCurVhFRTcl@lucifer/
> >
> > >
> > > >
> > > > >
> > > > > No functional change intended.
> > > > >
> > > > > Suggested by: David Hildenbrand (Arm) <david@kernel.org>
> > > > > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > > > > ---
> > > > >  fs/proc/task_mmu.c | 24 ++++++++++--------------
> > > > >  1 file changed, 10 insertions(+), 14 deletions(-)
> > > > >
> > > > > diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> > > > > index cfc7af1b551d..3c40c9cbb9c9 100644
> > > > > --- a/fs/proc/task_mmu.c
> > > > > +++ b/fs/proc/task_mmu.c
> > > > > @@ -1257,6 +1257,7 @@ static void smap_gather_stats(struct proc_maps_private *priv,
> > > > >                             struct mem_size_stats *mss, unsigned long start)
> > > > >  {
> > > > >       const struct mm_walk_ops *ops = get_smaps_walk_ops(priv);
> > > > > +     const bool is_partial = start > vma->vm_start;
> > > >
> > > > Yeah not in love with this, without changing how it's called.
> > >
> > > See [1]. This is exactly how you wrote it at the end of that reply.
> >
> > Assuming you passed vma->vm_start, not 0? Passing 0 makes it really strange.
>
> Ah! Now I see the problem you are pointing out. Ok, in v2 [2] this was
> done correctly and that's the way you want it!
> Okay, I agree this split was incorrect. I think I'll move is_partial
> conversion completely into the next patch and this one will only
> update the comment and use vma_is_cow_mapping() instead of open-coding
> it.

OK, it probably makes sense to have the CoW change separate.

I replied on 4/7 about how I think that should look re: wrapper functions.

>
> [2] https://lore.kernel.org/all/20260907063918.3432401-4-surenb@google.com/

--
Cheers, Lorenzo

