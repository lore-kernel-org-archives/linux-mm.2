Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93138C88E4D
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 19:03:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CA3F6B008C; Fri, 11 Sep 2026 15:03:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A04C6B0092; Fri, 11 Sep 2026 15:03:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A7646B0093; Fri, 11 Sep 2026 15:03:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4974F6B008C
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 15:03:10 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 97B2D80344
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 19:03:09 +0000 (UTC)
X-FDA: 85202404098.17.9B40A7A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id C2F04160017
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 19:03:07 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IhUCYUY3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789153387;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=li/6nS3gbGM5DIuxPpiXbPoHE4FH05B5UjM3kgULeK8=;
	b=iz1M6LLOXDXw1/8k7L7h6vBsId19pTgX05olGVXu/TJUx+sKAiuj5GMN39SsxSBTs3gh+t
	KxrUScpxnSJv3s9tAOvSo3EW11v8ofJ0q4YUYXNp7UM3a1yVt8AZ9XewoRh9cowFoaMJWA
	CAHnY+SsV8aTuz74++FC8w0hr85BTk8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789153387;
	b=ueLx033LOLfHjtQJI/Y5eiqbzS0SWB8+uN7xIR269fVAbISrKfZd2DSkfsaKRJLwJZAoA2
	roy0fYdRFEcKdDb2agBbzWjEQjDftRCgkyyh0pICIkhNLF5UYLGGu87+gwKqPLw2mvaF0K
	Ty71KguvWklQ7Kk/w0QFdkSc5+l47pc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IhUCYUY3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1F4B843507;
	Fri, 11 Sep 2026 19:03:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCE641F000FF;
	Fri, 11 Sep 2026 19:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789153386;
	bh=li/6nS3gbGM5DIuxPpiXbPoHE4FH05B5UjM3kgULeK8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IhUCYUY30J8Exyx9w/d0UNOfjomlG50EDn07gvcqRDTwSvFJnY2gF+bowzT8FxMEF
	 5cPILEaSujtn/AV3/SVhu98XX1YSQQVY7VlUku+xoBRFFnZwDrYrotgfuUpizi+KAQ
	 I9mD4wTN3v3aiMrZOf6yhOSJhu0pE1ZtACsC1OaQX6YLrCiHMMqRyvc4sT6nnb1PDt
	 fy65LGPzykioDTDOzSSrkjjnBOyaE56dXLR+RTwxxImiQrQ0VE+NenXqkHuBxx4NcQ
	 AWRjI1I4zzW0mdkIz+XV5xeFptSAP35ASzhsBiVAIb7s/J1LQb6NhUwceAU5F2qq8L
	 lKQ8fAukXOL+A==
Date: Fri, 11 Sep 2026 20:03:00 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, liam@infradead.org, vbabka@kernel.org, 
	david@redhat.com, willy@infradead.org, jannh@google.com, paulmck@kernel.org, 
	pfalcato@suse.de, xueyuan.chen21@gmail.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v3 5/7] proc/task_mmu: change proc_get_vma() to stop
 returning gate VMA at the end
Message-ID: <aqRPeZH4yeYXfWgS@gremlin>
References: <20260910234737.1340642-1-surenb@google.com>
 <20260910234737.1340642-6-surenb@google.com>
 <aqRF4YB7Ijk9PmRM@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqRF4YB7Ijk9PmRM@gremlin>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C2F04160017
X-Stat-Signature: 3xnmkc8t5cdg1qfi3ktzsr5us4h363ii
X-HE-Tag: 1789153387-182681
X-HE-Meta: U2FsdGVkX1/CvYMpekelwseMpOsy5nNhrAVqSXKZ37qXP8v23SxoeVZX3DxSVl+zrxoPR+lBuz2oYw+I4c9lyG6i613/NpAuYLa3695fjn1TBnnpjilnRbnfODqesFlgohC/MsPf2hILzBhsQwYwRyRnQizCpe4uRydeQE77B6GGW6pqF75X9uV+CvimK10AZEwiP9VnAnMmhkm8QU2b4Z1KNmahaErAIWEoV+LluZs15UIhYZHAcT8FY5dGGnEk64a/m4fmu03bzdVGATsMw0zLbm/VF+LczU5jT67E0w5qktJOQBiSQMCOIobOTM5SNW1X8mYyjY7ek1Vicqnu/j1FMUxR42gsKRu4cMG/bswMN1/0BYBk/dI9GdziBfR+OduMG0wkFhsPeGeAQFPQLvs3kc3haON6eH4T53QDkuS4lENKQqMuV/G5Wl2s0STCgq0cCCPgdkIit+6ZYDmlsYqlREymnDDH8Q0SAiZlqprZWQRDBhsuRhdG3+rNAIpXcnZ9X78AbG8U5qg/7RJ8GByLQoMDVi8EqJ9CZ8STDIfM79jzwQsWk+0/H+RkdTKFD6mJ1UiIFIicQi8d9iWMXYZ299dr1o9XU4MBawNEJwmYlFbGKH+OatxWha7JGiLGg6S0MCVJKrC8l+xVH5eGuxM8DmfmYnNwsyOxrfl60j2FgFyDj/RwgAUfD+pIKAYkCwx4HWu9HMXZ59tDQOGdiLjWmQtyljJBUIFQ84vZ0wlfSTlUk/KNoAruo4nvDW+X83EWe3dboIJAbrmCY57hTC5W9ESnMT9ImUSRiG1wXocYADAGd97K7GjjytAYVyZj2yofMY1DI49LjdQYS8kSRQ8YNRSuFsDm0jP4RzYQuwpv6HDkVVgsisAbf/z0IoSoWDYQlwItgfJeIgEVeoZ/ou7itFbgMGC+izv+Ast/sBzCIG9zWtgqNMi9d4KqNnR0MwpTHbSvw7HLBA5nVm0
 f/YElEhO
 huFIeeocaB8k8OwQkKkjrzS8V8sR3jkj2DfpP8NX3i5oG0Pl5ozEN3z6Mz3ok2GrAT3s0SDrWMKOKV9HmrVb18lOsriZ5OmLFzkj+LjFPiL46QEvzt7mJQaRCtrmCAYDD3QAwCrWdjR/sTISS60w2WNQLbbgu1lIUxF/WW0pNadyADu+iJTKraIo0cSvfzzaypootOBHfujO5ivtF8unLKN7h5gt/eKC+2oa6IfTePM77zTkDE/AbN+YjNrP3A6sMqt1HZxUqS4Ip7eG0m+GqArWj/qsKTqUBzWuX3TGBS3W7ax7DjiDEGvtZ7kxEWfDgI6atugD2ka4GlmnasoqrcpjySYtAPRCnk9/yjiwfyO+D/XaLK32QZ0SyCYvgMP8rnF4O4rUBRX+dc2ooGOHWlwucl6k7dlxRk9ruL6jzcphBWvw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 11, 2026 at 07:26:49PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Thu, Sep 10, 2026 at 04:47:35PM -0700, Suren Baghdasaryan wrote:
> > proc_get_vma() returning gate VMA at the end is desirable for the its
> > current m_start/m_next callers, as they need to report a gate VMA at the
> > end of the address space. This behavior is very specific to these callers
> > and makes proc_get_vma() hard to use for other purposes.
> >
> > Move this usage-specific behavior into the callers themselves so that
> > proc_get_vma() returns either a valid VMA, an error or a NULL when no
> > more VMAs are available. This makes it more generic, simpler and usable
> > in the later patches.
> >
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
>
> Yes, very good change, thanks!
>
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>
> > ---
> >  fs/proc/task_mmu.c | 23 ++++++++++++++++++-----
> >  1 file changed, 18 insertions(+), 5 deletions(-)
> >
> > diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> > index ecce7ce116cb..9a3c996c1d61 100644
> > --- a/fs/proc/task_mmu.c
> > +++ b/fs/proc/task_mmu.c
> > @@ -236,9 +236,6 @@ static struct vm_area_struct *proc_get_vma(struct seq_file *m, loff_t *ppos)
> >  		 * found the extended vma with the same vm_start.
> >  		 */
> >  		*ppos = vma->vm_end;
> > -	} else {
> > -		*ppos = SENTINEL_VMA_GATE;
> > -		vma = get_gate_vma(priv->lock_ctx.mm);
>
> Yeah this is just so confusing as-was.
>
> >  	}
> >
> >  	return vma;
> > @@ -248,6 +245,7 @@ static void *m_start(struct seq_file *m, loff_t *ppos)
> >  {
> >  	struct proc_maps_private *priv = m->private;
> >  	struct proc_maps_locking_ctx *lock_ctx;
> > +	struct vm_area_struct *vma;
> >  	loff_t last_addr = *ppos;
> >  	struct mm_struct *mm;
> >
> > @@ -280,16 +278,31 @@ static void *m_start(struct seq_file *m, loff_t *ppos)
> >  	if (last_addr == SENTINEL_VMA_GATE)
> >  		return get_gate_vma(mm);
> >
> > -	return proc_get_vma(m, ppos);
> > +	vma = proc_get_vma(m, ppos);
> > +	if (vma)
> > +		return vma;
> > +
> > +	/* Return gate VMA at the end */
> > +	*ppos = SENTINEL_VMA_GATE;
> > +	return get_gate_vma(mm);
> >  }
> >
> >  static void *m_next(struct seq_file *m, void *v, loff_t *ppos)
> >  {
> > +	struct proc_maps_private *priv = m->private;
> > +	struct vm_area_struct *vma;
> > +
> >  	if (*ppos == SENTINEL_VMA_GATE) {
> >  		*ppos = SENTINEL_VMA_END;
> >  		return NULL;
> >  	}
> > -	return proc_get_vma(m, ppos);
> > +	vma = proc_get_vma(m, ppos);
> > +	if (vma)
> > +		return vma;
>
> OK so I guess the logic is, iterate through every VMA, then once you run out,
> report the gate VMA. Makes sense.

Hmm one thing on this though - m_start() still has:

	if (last_addr == SENTINEL_VMA_GATE)
		return get_gate_vma(mm);

As well as:

	vma = proc_get_vma(m, ppos);
	if (vma)
		return vma;

	/* Return gate VMA at the end */
	*ppos = SENTINEL_VMA_GATE;
	return get_gate_vma(mm);

Now at the end.

Is this correct? Is it maybe duplicated now?

>
> > +
> > +	/* Return gate VMA at the end */
> > +	*ppos = SENTINEL_VMA_GATE;
> > +	return get_gate_vma(priv->lock_ctx.mm);
> >  }
> >
> >  static void m_stop(struct seq_file *m, void *v)
> > --
> > 2.55.0.1007.g17ff1f9808-goog
> >
>
> --
> Cheers, Lorenzo

--
Cheers, Lorenzo

