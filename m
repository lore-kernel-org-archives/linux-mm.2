Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE962C55ABA
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 14:13:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D83B86B0095; Wed,  5 Aug 2026 10:13:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D34C26B0096; Wed,  5 Aug 2026 10:13:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFC2F6B0098; Wed,  5 Aug 2026 10:13:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 96BBF6B0095
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 10:13:13 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2314BA04A8
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 14:13:13 +0000 (UTC)
X-FDA: 85067407866.06.4295B70
Received: from mail-pj2-f0.google.com (mail-pj2-f0.google.com [74.125.227.128])
	by imf29.hostedemail.com (Postfix) with ESMTP id 36268120011
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 14:13:11 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oINO8htl;
	spf=pass (imf29.hostedemail.com: domain of zhanghongru06@gmail.com designates 74.125.227.128 as permitted sender) smtp.mailfrom=zhanghongru06@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785939191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W70SCmzsN9YFfAjH+JFb3f3C2KAabHV0qBUjLRKkWh4=;
	b=Yxd8sS5SND4QxsHarZmyjU/Rsz8J3Ud4FaoL1kkjsCJyVblhiaD+oGFjrD9pVOC85LR3B1
	SJvybp9XY0qLDq9F7IPOmd4dxo3P4lXAeS/Gck+pwgzWltHNO9zvg9dgbe9oApkaSjDmII
	1nj85BG7HF5FuBWa88Cl6Lpm53yX0SI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oINO8htl;
	spf=pass (imf29.hostedemail.com: domain of zhanghongru06@gmail.com designates 74.125.227.128 as permitted sender) smtp.mailfrom=zhanghongru06@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785939191;
	b=TJDRhVT87OYYI6fJP9/szQgP2dV/Fp0cUKtrEvW4+b9doNbqUHgZ/kJaiW299I0j124Gp0
	/DuqU+Aj3X9INGXjfHiUTUld8PZy6SyL/Wst865syCXLKleVn04Et1Or/UWGsMUjkGiCQO
	z3MTwYuLVPCojzcT/mG+AbFDo2zmr20=
Received: by mail-pj2-f0.google.com with SMTP id d9443c01a7336-2cc2c6e0688so9041765ad.0
        for <linux-mm@kvack.org>; Wed, 05 Aug 2026 07:13:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785939190; x=1786543990; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=W70SCmzsN9YFfAjH+JFb3f3C2KAabHV0qBUjLRKkWh4=;
        b=oINO8htlpgDsov2ygSYTDZRdRis01d1Mpi6sRYS3le4JrQ6j/EDVHR6hauvuhV8cp+
         EEFs6e6hKB9DJneJdn0Piqhu2C+hUoaZS5I67QXOehS5b82qKC9AcBypENca9hFO5Nvs
         X9LZm/zqHnU0YXwzR75UJZrvfkeNwQdqQ/g5+CJZRGYXgK5cBQ5hJWFHs4Uam3J5T5aA
         GtCLqz2sk3KAfR2NGB/bSnXQUmpv9fQKMCiC48dprMsNnIbF0ahvOycD7M0xeN0veWfz
         Id63SdXXJUCeJQCNzzaHcwzHevnAae8VctyqmdcgiIEpJryDlF7w6/jUArITdMUucqQJ
         TjYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785939190; x=1786543990;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=W70SCmzsN9YFfAjH+JFb3f3C2KAabHV0qBUjLRKkWh4=;
        b=rG6cnUZ0lROcPG/+526kwvoCvvGgIoE1WIVj27neTEZ30e658Va68uBZiniMhBDg0v
         T33nhTL/g0MvGHCzPmijoT8OwjGUEhL6j+fS23gOYa9Lzmdg397ymlCB9m9WuAxEdQcf
         JfanHqEEmdJ2ncHeVxB/cSUSnJspRCke61pkSn3rh9KRXSFr22IATKDlZq2tz1Gt2ldB
         Ve9XAjXF/QZ1rGGofJ3gVI0EiGTLZh12V4LMZ8q9ojHw0oh56MgiCVhzyyB9wl++SBz6
         b2g0NntunCRP6k4LjQ2j2+J6+PdpdU44ALJBj5hhiOzXL/PxP7RJbYyOuUOrl8rxSinD
         JXDw==
X-Forwarded-Encrypted: i=1; AHgh+RrPTrDJfWLxc59h9HwRxWUpNZjhqn7m038cuh9NP0wx1JQlUKWPpvbZVVLl+stcte2QuqgPQ9KfsA==@kvack.org
X-Gm-Message-State: AOJu0YwoCcDA5P/DQnEEcvPmQGIBBWsilkvQ3njyXdOWYOzZ8mLdSyOy
	EMllTneUZnzqBBdj0k1h28ZfYnWx0ppu/HrVOAZkIikO5bxJLr2apdR0
X-Gm-Gg: AR+sD110PHibmoLZ1D5mNgg0dd+4emmxRQEFVbbZQiKyfieOU3GXgU1DO573dGKbq3N
	WLMx6i6xvsDwxPSMFji8ZPsaL9ftgYqwiboAubbG0LQhzREzMilrFEfV94oS+UwBVQXYMzyLbjz
	6G5AxsVA3c1UgUFnHPvUWUomofoyCMSg6mQJ+qlRpvHZNjAp4QZbpOxzzL7t65U/E0Wny1vuzWE
	qeCXq63U8OkdcOcrJutu0qC9+WEPrtu2JwbctQguVR9Ddf1q4/yu+4wsxF8+zPkZL6DmBwpcsn2
	7QsjraqvqiQSPIbkJ8WpDTuJm9WZtzk0aerkq80bHW1LzS1CRjXlUmmCsem/8FaUSw2T29imwJl
	EOV+64f8B4xGB9HcmcQq8WMAhiNcLL9oTt64AvIniELPJjiF13e11Ox/iEyi62kX23XDGNP4wzP
	vpONvkNZrY36E5kzrHSP66jC8Vk+rRLQPIsVSIZjwKLSqiPJe/qA+mY+HddI7YJjJtpWNKmaiLq
	8DG/3l+QeSyjs18
X-Received: by 2002:a17:902:f788:b0:2c9:d55d:2d3 with SMTP id d9443c01a7336-2d0ca7834d4mr91041745ad.15.1785939189809;
        Wed, 05 Aug 2026 07:13:09 -0700 (PDT)
Received: from zhr-ThinkStation-K.mioffice.cn ([2408:8607:1b00:8:3188:63db:7459:ded4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d0aa4b6c66sm17465465ad.55.2026.08.05.07.12.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2026 07:13:09 -0700 (PDT)
From: Hongru Zhang <zhanghongru06@gmail.com>
X-Google-Original-From: Hongru Zhang <zhanghongru@xiaomi.com>
To: ljs@kernel.org
Cc: akpm@linux-foundation.org,
	baohua@kernel.org,
	david@kernel.org,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	mhocko@suse.com,
	rppt@kernel.org,
	shakeel.butt@linux.dev,
	surenb@google.com,
	vbabka@kernel.org,
	willy@infradead.org,
	zhanghongru06@gmail.com,
	zhanghongru@xiaomi.com
Subject: Re: [RFC PATCH v4 1/3] mm: allow page faults to request VMA-lock
Date: Wed,  5 Aug 2026 22:12:34 +0800
Message-ID: <20260805141234.1337068-1-zhanghongru@xiaomi.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <anHMe4jFT9EIQe5q@lucifer>
References: <anHMe4jFT9EIQe5q@lucifer>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 36268120011
X-Stat-Signature: q11uz6jjh84buswjhqm3ox9o3k6caknu
X-HE-Tag: 1785939191-281132
X-HE-Meta: U2FsdGVkX1+0qailohQFSvDXEo2zp8Ro1L9hzFtqJc3aN3UsTr/8akSksQu0GPSOQlD2GA82HMln9+/ds4NJuylPE8FtHHHvB27os5oqqG2pmpcPELjKro5W9qOKBWIbfRFes6UnWJ4KEyfeFSkzc7jdBwLMryH24vsq5f8hT9OvP76xGTx4rOE+3Bx90m770025Gx6Nx0jEsUG8IIXtZv20+Ay8vPt/ATaenQ8a3nQ62BxQrHfGCbzTN4OSD4f5F4cnaQt8W2CLYJKlLSeyjs2nlui1DiCD7dbufDYmPSqdYV7JF/Q9vMUeaVvZIW4Hn7RaPt4aOSObwyoQkinHPhKrZkrBtDkSLxl89Z0DtrUwZ7PyI+kevc3prGq/sICFQr1Dew4xgV0rW+qZ1yir7X1XyaBjr5FdYbqHY72eixJelHjukwuzu7rbecbo73YppE4X7/F/Jrg1lv8wUXJqLfuhy6uwP31WaFFjOvHY/x/DbHGNK74h3exlki+mZIoRwxS+2jWvbMIK+hHP/zgQaatxrm9jFQAwRKdcRMEDVaSoVqvoVS+quuGErxtteE6GTzjLPD3U6hVosGZY1i0Pv8DLL9CeWMf3Jp9wRQs8jT1jCAYoV2x9Iszte4F0YDH6+LW0H3IQCOAebALGZZcAzsCPb3YHwGdzJv3s+r1CW8eAnePIdEXl4tci8df2TLJ/ltVf5pVr2ss5fDOkGoyzYmF4TKtAQiiCbUP1ewjd7TjQr1IbzlrdLzftr91+aRu9rG+5PcRefbIRXPDTHnMZBnQdDOZ7G84kWMtfWYDtP+D691XUgAzbzwXywwrHOR24toXzuhpAIJzuymSBW3daNxXbO06qmTAvCk231O2IJOE6fwXr68uiW3uZHGSfPRvRNtL9/tbROv+A/OrRPzLDEECwQiLj0ChvYLQz+MqoOx8cRE/tR5mpIcAruHBtTRZmKNGFDc0x66hvdDtqnbX
 U/Yuy81A
 ZtPFmzt+vFu62OMHD4kSMH3Klsd/xOBB+NCtDlEXo+b4Omi2B/kUF9Qif/MFzhMPVtqhPTUVRsRv4gpbuIyLgWEKumyK5N29w8cyATXQ2cWb8gQG17/qsVS5CIfF9hktQFXsa1Aer6t6sdTLP5oUmLQUUahEQ6dXSJ9cDEGFV6Y42+uoabqLEAjuO2Foix3DUOV+jWJeJ9FGbwI6Eq+O+PTEPuDCLfsXMSSm9qfZgBFt77iqihW/f8iUSXs21FXclEjN5en0QquKElr4D2eRjAvOGJDFJSBz+o5w5cVdr9sLfmE+WZynvBcdwkvrQiNzCZG7tPblQ+/t2RmfuHDhxgr3PSJueGOU0v4CDjnSIPpeO3Rkf8kIdRVa/Qw8Bw78DciW8Gl3+HYRtI6am8/Wz3cDj/9LFSzEVpT77Z/yuov/01nQBHPxkKWatjG5NYQ25utWR0kDjF+MibYEFxRtoN7MPOw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> On Tue, Aug 04, 2026 at 05:52:19PM +0800, Hongru Zhang wrote:
> > From: Hongru Zhang <zhanghongru@xiaomi.com>
> >
> > Page faults handled under the per-VMA lock currently fall back to the
> > mmap_lock path whenever handle_mm_fault() returns VM_FAULT_RETRY. This
> > means that lower-level fault handlers have no way to tell the
> > architecture fault handler that the retry can safely continue under the
> > per-VMA lock.
> >
> > Add VM_FAULT_MAY_USE_VMA_LOCK as an advisory bit that can be returned
>
> I don't love that name or that faulting retry behaviour is _modified_ by a
> value that indicates fault resolution state... ugh.
>
> It's kinda confusing things 'VM_FAULT_RETRY' is 'you have to retry this
> fault'.
>
> 'VM_FAULT_MAY_...' is starting to bring in effectively configuration
> options into it and that's kinda horrible.
>
> I mean is there any reason we shouldn't ALWAYS do this if a VMA lock was
> used?
>
> It's not too expensive to do a single retry with the VMA lock before
> falling back to the mmap lock.

vm_fault_t do_swap_page(struct vm_fault *vmf)
{
	...
	entry = softleaf_from_pte(vmf->orig_pte);
	if (unlikely(!softleaf_is_swap(entry))) {
		...
		} else if (softleaf_is_device_private(entry)) {
			if (vmf->flags & FAULT_FLAG_VMA_LOCK) {
				/*
				 * migrate_to_ram is not yet ready to operate
				 * under VMA lock.
				 */
				vma_end_read(vma);
				ret = VM_FAULT_RETRY;
				goto out;
			}
	...
}

This is one example why I made the v4 retry opt-in. Device-private entries
currently use VM_FAULT_RETRY to force a fallback from the VMA-lock path to
the mmap_lock path, because migrate_to_ram() is not VMA-lock-ready yet. An
unconditional VMA-lock retry would not make this path progress under the VMA
lock; it would only add one bounded extra VMA-lock attempt before falling
back to mmap_lock.

>
> So maybe simplify like that?
>
> And like that this series becomes a single patch right?
>

Agreed. I'll try the "always retry once under VMA lock" approach and report
performance results in a later email.

> Though it seems the reticence is that you might end up waiting with the VMA
> lock held.
>
> If that's really critical then I'd drop this whole thing of referencing the
> VMA flag in the name altogether, it's confusing and you're left wondering
> why it's needed when the fault is already specified as allowing a VMA lock
> via FAULT_FLAG_VMA_LOCK.
>
> It's not at all clear it's _only_ for the arch-fault-handlers.
>
> I'm curious anyway as to where this waiting is actually happening? Is the
> waiting not _already_ happening with the VMA lock held on first attempt? Or
> if not there then where? [ the fault code is such a mess don't really have
> time to figure it out myself ].
>
> Anyway if we _have_ to have this flag, then something that actually matches
> the semantics here is better like:
>
> 	VM_FAULT_RETRY_WONT_BLOCK
>
> Which is informational, doesn't add any confusion about the VMA flag, and
> makes things a lot more self-documenting about what's going on here.
>
> > together with VM_FAULT_RETRY. Architecture fault handlers use this bit
> > to allow at most one retry under the per-VMA lock.
> >
> > This preserves the existing mmap_lock fallback behaviour for fault
> > handlers that continue to return VM_FAULT_RETRY without
> > VM_FAULT_MAY_USE_VMA_LOCK: major retries still enter the mmap_lock path
> > with FAULT_FLAG_TRIED set, while minor retries still enter it as a fresh
> > first attempt.
>
> Yup this was a concern I think I raised in a previous version that you'd
> get infinite VMA lock retries.
>
> >
> > The difference is limited to fault handlers that return VM_FAULT_RETRY
> > with VM_FAULT_MAY_USE_VMA_LOCK. For them, both major and minor retries
> > enter the VMA-lock retry with FAULT_FLAG_TRIED set. For major faults
> > this follows the existing mmap_lock retry handling, but the retried
> > fault runs under the VMA lock rather than the mmap_lock. For minor
> > faults this replaces the fresh mmap_lock retry with a VMA-lock retry
> > that has FAULT_FLAG_TRIED set. This can avoid an extra retry round for
> > short waits. The cost is that a retried fault that blocks for an extended
> > period may wait while holding the VMA lock. Fault handlers should return
>
> Where does it wait?

For filemap, the main wait I had in mind is in lock_folio_maybe_drop_mmap().
On the first attempt, maybe_unlock_mmap_for_io() can drop the fault lock
before waiting. On the VMA-lock retry, FAULT_FLAG_TRIED is already set, so
maybe_unlock_mmap_for_io() can no longer drop it. If folio_trylock() fails,
__folio_lock()/__folio_lock_killable() may then wait while the VMA lock is
still held.

There is also a less frequent not-uptodate path: after
maybe_unlock_mmap_for_io() keeps the fault lock on a FAULT_FLAG_TRIED
retry, filemap_read_folio() can wait for the synchronous read to complete.

I instrumented both places locally. The folio-lock wait path was common in
the shared-file sequential workload; the read_folio path also happened,
but much less frequently and mainly in the shared-file random cases.

>
> > VM_FAULT_RETRY with VM_FAULT_MAY_USE_VMA_LOCK when that tradeoff is
> > preferable to falling back to mmap_lock immediately.
>
> This sentence is completely unreadable :) Too. Many. Words.
>
> It's really hard to follow too. Was this AI-generated? Totally understand
> if it's to help with prose in general but what we end up with really does
> have to be clear.
>
> Something like:
>
> 	Minor faults are retried indefinitely with the mmap lock held,
> 	which guarantees some forward progress, however this isn't the case
> 	with VMA locks, so set FAULT_FLAG_TRIED for minor faults if the VMA
> 	lock is used.
> 
> 	< discussions of tradeoff, where the waiting actually happens >
> 
> Maybe?
>
> >
> > No current code sets VM_FAULT_MAY_USE_VMA_LOCK yet; this patch only
> > prepares the retry plumbing for later users.
> >
> > No functional change is intended.
> >
> > Signed-off-by: Hongru Zhang <zhanghongru@xiaomi.com>
> > Suggested-by: Barry Song <baohua@kernel.org>
> > Suggested-by: Suren Baghdasaryan <surenb@google.com>
> > ---
> >  arch/arm/mm/fault.c       |  6 ++++--
> >  arch/arm64/mm/fault.c     |  7 +++++--
> >  arch/loongarch/mm/fault.c |  6 ++++--
> >  arch/powerpc/mm/fault.c   |  6 ++++--
> >  arch/riscv/mm/fault.c     |  6 ++++--
> >  arch/s390/mm/fault.c      |  5 +++--
> >  arch/x86/mm/fault.c       |  6 ++++--
>
> Really badly need that code to separate out fault handling code. Matthew?
> :) Or perhaps he's waiting on this to land first...
>
> It does seem that these are the arches that use VMA locks though.
>
> Suren - is there any reason we shouldn't just enable VMA locks for every
> CONFIG_MMU arch now it's headed for being default-enabled?
>
>
> >  include/linux/mm.h        | 28 ++++++++++++++++++++++++++++
> >  include/linux/mm_types.h  |  4 ++++
> >  9 files changed, 60 insertions(+), 14 deletions(-)
> >
> > diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
> > index e62cc4be5adf..158923b70901 100644
> > --- a/arch/arm/mm/fault.c
> > +++ b/arch/arm/mm/fault.c
> > @@ -391,6 +391,7 @@ do_page_fault(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
> >  	if (!(flags & FAULT_FLAG_USER))
> >  		goto lock_mmap;
> >
> > +retry_vma:
> >  	vma = lock_vma_under_rcu(mm, addr);
> >  	if (!vma)
> >  		goto lock_mmap;
> > @@ -411,8 +412,6 @@ do_page_fault(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
> >  		goto done;
> >  	}
> >  	count_vm_vma_lock_event(VMA_LOCK_RETRY);
> > -	if (fault & VM_FAULT_MAJOR)
> > -		flags |= FAULT_FLAG_TRIED;
> >
> >  	/* Quick path to respond to signals */
> >  	if (fault_signal_pending(fault, regs)) {
> > @@ -420,6 +419,9 @@ do_page_fault(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
> >  			goto no_context;
> >  		return 0;
> >  	}
> > +
> > +	if (fault_should_retry_under_vma_lock(fault, &flags))
> > +		goto retry_vma;
> >  lock_mmap:
> >
> >  retry:
> > diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
> > index 0b52557652be..b17986b40ac3 100644
> > --- a/arch/arm64/mm/fault.c
> > +++ b/arch/arm64/mm/fault.c
> > @@ -678,6 +678,7 @@ static int __kprobes do_page_fault(unsigned long far, unsigned long esr,
> >  	if (!(mm_flags & FAULT_FLAG_USER))
> >  		goto lock_mmap;
> >
> > +retry_vma:
> >  	vma = lock_vma_under_rcu(mm, addr);
> >  	if (!vma)
> >  		goto lock_mmap;
> > @@ -715,8 +716,6 @@ static int __kprobes do_page_fault(unsigned long far, unsigned long esr,
> >  		goto done;
> >  	}
> >  	count_vm_vma_lock_event(VMA_LOCK_RETRY);
> > -	if (fault & VM_FAULT_MAJOR)
> > -		mm_flags |= FAULT_FLAG_TRIED;
> >
> >  	/* Quick path to respond to signals */
> >  	if (fault_signal_pending(fault, regs)) {
> > @@ -724,6 +723,10 @@ static int __kprobes do_page_fault(unsigned long far, unsigned long esr,
> >  			goto no_context;
> >  		return 0;
> >  	}
> > +
> > +	if (fault_should_retry_under_vma_lock(fault, &mm_flags))
> > +		goto retry_vma;
> > +
> >  lock_mmap:
> >
> >  retry:
> > diff --git a/arch/loongarch/mm/fault.c b/arch/loongarch/mm/fault.c
> > index 2c93d33356e5..6a946838b54b 100644
> > --- a/arch/loongarch/mm/fault.c
> > +++ b/arch/loongarch/mm/fault.c
> > @@ -219,6 +219,7 @@ static void __kprobes __do_page_fault(struct pt_regs *regs,
> >  	if (!(flags & FAULT_FLAG_USER))
> >  		goto lock_mmap;
> >
> > +retry_vma:
> >  	vma = lock_vma_under_rcu(mm, address);
> >  	if (!vma)
> >  		goto lock_mmap;
> > @@ -256,8 +257,6 @@ static void __kprobes __do_page_fault(struct pt_regs *regs,
> >  	}
> >
> >  	count_vm_vma_lock_event(VMA_LOCK_RETRY);
> > -	if (fault & VM_FAULT_MAJOR)
> > -		flags |= FAULT_FLAG_TRIED;
> >
> >  	/* Quick path to respond to signals */
> >  	if (fault_signal_pending(fault, regs)) {
> > @@ -265,6 +264,9 @@ static void __kprobes __do_page_fault(struct pt_regs *regs,
> >  			no_context(regs, write, address);
> >  		return;
> >  	}
> > +
> > +	if (fault_should_retry_under_vma_lock(fault, &flags))
> > +		goto retry_vma;
> >  lock_mmap:
> >
> >  retry:
> > diff --git a/arch/powerpc/mm/fault.c b/arch/powerpc/mm/fault.c
> > index 806c74e0d5ab..e2a128fba408 100644
> > --- a/arch/powerpc/mm/fault.c
> > +++ b/arch/powerpc/mm/fault.c
> > @@ -487,6 +487,7 @@ static int ___do_page_fault(struct pt_regs *regs, unsigned long address,
> >  	if (!(flags & FAULT_FLAG_USER))
> >  		goto lock_mmap;
> >
> > +retry_vma:
> >  	vma = lock_vma_under_rcu(mm, address);
> >  	if (!vma)
> >  		goto lock_mmap;
> > @@ -511,12 +512,13 @@ static int ___do_page_fault(struct pt_regs *regs, unsigned long address,
> >  		goto done;
> >  	}
> >  	count_vm_vma_lock_event(VMA_LOCK_RETRY);
> > -	if (fault & VM_FAULT_MAJOR)
> > -		flags |= FAULT_FLAG_TRIED;
> >
> >  	if (fault_signal_pending(fault, regs))
> >  		return user_mode(regs) ? 0 : SIGBUS;
> >
> > +	if (fault_should_retry_under_vma_lock(fault, &flags))
> > +		goto retry_vma;
> > +
> >  lock_mmap:
> >
> >  	/* When running in the kernel we expect faults to occur only to
> > diff --git a/arch/riscv/mm/fault.c b/arch/riscv/mm/fault.c
> > index 04ed6f8acae4..87b061feba51 100644
> > --- a/arch/riscv/mm/fault.c
> > +++ b/arch/riscv/mm/fault.c
> > @@ -347,6 +347,7 @@ void handle_page_fault(struct pt_regs *regs)
> >  	if (!(flags & FAULT_FLAG_USER))
> >  		goto lock_mmap;
> >
> > +retry_vma:
> >  	vma = lock_vma_under_rcu(mm, addr);
> >  	if (!vma)
> >  		goto lock_mmap;
> > @@ -368,14 +369,15 @@ void handle_page_fault(struct pt_regs *regs)
> >  		goto done;
> >  	}
> >  	count_vm_vma_lock_event(VMA_LOCK_RETRY);
> > -	if (fault & VM_FAULT_MAJOR)
> > -		flags |= FAULT_FLAG_TRIED;
> >
> >  	if (fault_signal_pending(fault, regs)) {
> >  		if (!user_mode(regs))
> >  			no_context(regs, addr);
> >  		return;
> >  	}
> > +
> > +	if (fault_should_retry_under_vma_lock(fault, &flags))
> > +		goto retry_vma;
> >  lock_mmap:
> >
> >  retry:
> > diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
> > index 028aeb9c48d6..8e90e522436b 100644
> > --- a/arch/s390/mm/fault.c
> > +++ b/arch/s390/mm/fault.c
> > @@ -294,6 +294,7 @@ static void do_exception(struct pt_regs *regs, int access)
> >  		flags |= FAULT_FLAG_WRITE;
> >  	if (!(flags & FAULT_FLAG_USER))
> >  		goto lock_mmap;
> > +retry_vma:
> >  	vma = lock_vma_under_rcu(mm, address);
> >  	if (!vma)
> >  		goto lock_mmap;
> > @@ -310,14 +311,14 @@ static void do_exception(struct pt_regs *regs, int access)
> >  		goto done;
> >  	}
> >  	count_vm_vma_lock_event(VMA_LOCK_RETRY);
> > -	if (fault & VM_FAULT_MAJOR)
> > -		flags |= FAULT_FLAG_TRIED;
> >  	/* Quick path to respond to signals */
> >  	if (fault_signal_pending(fault, regs)) {
> >  		if (!user_mode(regs))
> >  			handle_fault_error_nolock(regs, 0);
> >  		return;
> >  	}
> > +	if (fault_should_retry_under_vma_lock(fault, &flags))
> > +		goto retry_vma;
> >  lock_mmap:
> >  retry:
> >  	vma = lock_mm_and_find_vma(mm, address, regs);
> > diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> > index 45b99c3b1442..53c8f003fe53 100644
> > --- a/arch/x86/mm/fault.c
> > +++ b/arch/x86/mm/fault.c
> > @@ -1331,6 +1331,7 @@ void do_user_addr_fault(struct pt_regs *regs,
> >  	if (!(flags & FAULT_FLAG_USER))
> >  		goto lock_mmap;
> >
> > +retry_vma:
> >  	vma = lock_vma_under_rcu(mm, address);
> >  	if (!vma)
> >  		goto lock_mmap;
> > @@ -1349,8 +1350,6 @@ void do_user_addr_fault(struct pt_regs *regs,
> >  		goto done;
> >  	}
> >  	count_vm_vma_lock_event(VMA_LOCK_RETRY);
> > -	if (fault & VM_FAULT_MAJOR)
> > -		flags |= FAULT_FLAG_TRIED;
> >
> >  	/* Quick path to respond to signals */
> >  	if (fault_signal_pending(fault, regs)) {
> > @@ -1360,6 +1359,9 @@ void do_user_addr_fault(struct pt_regs *regs,
> >  						 ARCH_DEFAULT_PKEY);
> >  		return;
> >  	}
> > +
> > +	if (fault_should_retry_under_vma_lock(fault, &flags))
> > +		goto retry_vma;
> >  lock_mmap:
> >
> >  retry:
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index 7fabe6c66b4b..27ec6673acfe 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -727,6 +727,34 @@ static inline bool fault_flag_allow_retry_first(enum fault_flag flags)
> >  	    (!(flags & FAULT_FLAG_TRIED));
> >  }
> >
> > +/**
> > + * fault_should_retry_under_vma_lock - decide whether to retry with VMA lock
> > + * @fault: fault result from handle_mm_fault() under FAULT_FLAG_VMA_LOCK
> > + * @flags: fault flags for the current fault, updated on retry
> > + *
> > + * Architecture page fault handlers call this after a VMA-lock fault returns
> > + * VM_FAULT_RETRY. If the fault result also has VM_FAULT_MAY_USE_VMA_LOCK,
> > + * allow one bounded retry under the VMA lock and set FAULT_FLAG_TRIED.
> > + *
> > + * When the fault must fall back to the mmap_lock path, preserve the existing
> > + * VM_FAULT_MAJOR behavior by marking FAULT_FLAG_TRIED before the retry.
> > + *
> > + * Return: true if the caller should retry under the VMA lock, false if it
>
> Oh good half of the kdoc comments in mm.h have Return and the other half have
> Returns: :)) OK I guess Return is fine here.
>
> > + * should fall back to the mmap_lock fault path.
> > + */
> > +static inline bool fault_should_retry_under_vma_lock(vm_fault_t fault, unsigned int *flags)
> > +{
> > +	if ((fault & VM_FAULT_MAY_USE_VMA_LOCK) && !(*flags & FAULT_FLAG_TRIED)) {
> > +		*flags |= FAULT_FLAG_TRIED;
> > +		return true;
> > +	}
> > +
> > +	if (fault & VM_FAULT_MAJOR)
> > +		*flags |= FAULT_FLAG_TRIED;
> > +
> > +	return false;
> > +}
>
> I really hate this function. It's not doing what it says it is (it's
> modifying fault behaviour too via the flags parameter AND setting state for
> major faults), it's combining VMA fault path handling AND mmap major fault
> handling it's doing ugly horrors with an output parameter.
>
> I think it's better just as a straight-up predicate. Yes there'll be
> duplication on setting FAULT_FLAG_TRIED. It sucks, but you're _already_
> duplicating every single invocation and goto anyway.
>
> The fix for that is finally de-duplicating the arch fault code properly.
>
> So it'd be like:
>
> 	< kdoc etc. >
> 	static inline bool should_retry_fault_under_vma_lock(vm_fault fault_type,
> 			unsigned int flags)
> 	{
> 		/* Don't wait holding the VMA lock. */
> 		if (!(fault_type & VM_FAULT_RETRY_WONT_BLOCK))
> 			return false;
> 		/* Already retried the fault under the VMA lock. */
> 		if (flags & FAULT_FLAG_TRIED)
> 			return false;
> 		return true;
> 	}
>
>
> -	if (fault_should_retry_under_vma_lock(fault, &flags))
> -		goto retry_vma;
> +	if (should_retry_fault_under_vma_lock(fault, flags)) {
> +		flags |= FAULT_FLAG_TRIED;
> +		goto retry_vma;
> +	}
> +
> +	if (fault & VM_FAULT_MAJOR)
> +		flags |= FAULT_FLAG_TRIED;
>
> This way also you explicitly see where FAULT_FLAG_TRIED is set.
>
> > +
> >  #define FAULT_FLAG_TRACE \
> >  	{ FAULT_FLAG_WRITE,		"WRITE" }, \
> >  	{ FAULT_FLAG_MKWRITE,		"MKWRITE" }, \
> > diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> > index b5d4cd3b067b..46a832757109 100644
> > --- a/include/linux/mm_types.h
> > +++ b/include/linux/mm_types.h
> > @@ -1684,6 +1684,8 @@ typedef __bitwise unsigned int vm_fault_t;
> >   * @VM_FAULT_NOPAGE:		->fault installed the pte, not return page
> >   * @VM_FAULT_LOCKED:		->fault locked the returned page
> >   * @VM_FAULT_RETRY:		->fault blocked, must retry
> > + * @VM_FAULT_MAY_USE_VMA_LOCK:	->fault blocked, retry may be handled under
> > + *				the VMA lock
> >   * @VM_FAULT_FALLBACK:		huge page fault failed, fall back to small
> >   * @VM_FAULT_DONE_COW:		->fault has fully handled COW
> >   * @VM_FAULT_NEEDDSYNC:		->fault did not modify page tables and needs
> > @@ -1707,6 +1709,7 @@ enum vm_fault_reason {
> >  	VM_FAULT_DONE_COW       = (__force vm_fault_t)0x001000,
> >  	VM_FAULT_NEEDDSYNC      = (__force vm_fault_t)0x002000,
> >  	VM_FAULT_COMPLETED      = (__force vm_fault_t)0x004000,
> > +	VM_FAULT_MAY_USE_VMA_LOCK = (__force vm_fault_t)0x008000,
> >  	VM_FAULT_HINDEX_MASK    = (__force vm_fault_t)0x0f0000,
> >  };
> >
> > @@ -1731,6 +1734,7 @@ enum vm_fault_reason {
> >  	{ VM_FAULT_FALLBACK,            "FALLBACK" },	\
> >  	{ VM_FAULT_DONE_COW,            "DONE_COW" },	\
> >  	{ VM_FAULT_NEEDDSYNC,           "NEEDDSYNC" },	\
> > +	{ VM_FAULT_MAY_USE_VMA_LOCK,    "MAY_USE_VMA_LOCK" },	\
>
> This makes the naming confusion even worse - because now we have
> FAULT_FLAG_VMA_LOCK and this which 'specifies' may use VMA lock whereas
> really it means 'may use once on retry'...
>
> So again, as per above, I think it's better to actually have this
> communicate the _reason_ why it seems OK to use the VMA lock on retry
> rather than actually specifying that the caller should.
>

Will address in the next revision if we keep this approach.

> >  	{ VM_FAULT_COMPLETED,           "COMPLETED" }
> >
> >  struct vm_special_mapping {
> > --
> > 2.43.0
> >
>
> BTW in sanitize_fault_flags() there's:
>
> 	/*
> 	 * Per-VMA locks can't be used with FAULT_FLAG_RETRY_NOWAIT because of
> 	 * the assumption that lock is dropped on VM_FAULT_RETRY.
> 	 */
> 	if (WARN_ON_ONCE((*flags &
> 			(FAULT_FLAG_VMA_LOCK | FAULT_FLAG_RETRY_NOWAIT)) ==
> 			(FAULT_FLAG_VMA_LOCK | FAULT_FLAG_RETRY_NOWAIT)))
> 		return VM_FAULT_SIGSEGV;
>
> Except now VM_FAULT_RETRY doesn't drop the lock :) I think the comment
> needs to be updated to say 'dropped on VM_FAULT_RETRY after one attempt'.

The patch doesn't change VM_FAULT_RETRY semantics: returning VM_FAULT_RETRY
still means the lock has been dropped, whether it's the mmap lock or the VMA
lock. The retry path re-acquires the VMA lock before the second attempt. So
I think the existing comment is still accurate?

> Also I think there's an issue with major/minor fault counting as a result
> of this, in mm_account_fault():
>
> 	/*
> 	 * We define the fault as a major fault when the final successful fault
> 	 * is VM_FAULT_MAJOR, or if it retried (which implies that we couldn't
> 	 * handle it immediately previously).
> 	 */
> 	major = (ret & VM_FAULT_MAJOR) || (flags & FAULT_FLAG_TRIED);
>
> 	if (major)
> 		current->maj_flt++;
> 	else
> 		current->min_flt++;
>
> Now you're getting minor faults being counted as major ones?
>
> If intended, that's a user-visible change that should be documented and
> defended in the commit msg.
>
> If not, you could do some REALLY gross checks making things _even more
> complicated_ here.
>
> But maybe something like:
>
> 	< kdoc comment etc. >
> 	static bool is_major_fault(vm_fault_t fault_type, unsigned int fault_flags)
> 	{
> 		/* Explicitly marked as major. */
> 		if (fault_type & VM_FAULT_MAJOR)
> 			return true;
> 		/* If no retry occurred, minor. */
> 		if (!(fault_flags & FAULT_FLAG_TRIED))
> 			return false;
> 		/* Quickly retrying fault under the VMA lock implies minor. */
> 		return !(fault_flags & FAULT_FLAG_VMA_LOCK);
> 	}
>
> 	Then the code above becomes:
>
> 	if (is_major_fault(ret, flags))
> 		current->maj_flt++;
> 	else
> 		current->min_flt++;
>
> --
> Cheers, Lorenzo

With FAULT_FLAG_TRIED set, the retry attempt behaves identically regardless
of whether it's under the mmap lock or the VMA lock. Is a change still
needed here?

Thanks,
Hongru

