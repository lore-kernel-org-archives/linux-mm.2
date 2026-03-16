Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D9F7F013C5
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 08:05:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 785426B0159; Mon, 16 Mar 2026 04:05:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 708AB6B015A; Mon, 16 Mar 2026 04:05:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DD326B015B; Mon, 16 Mar 2026 04:05:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4A8B06B0159
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 04:05:53 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1BE6E1B9096
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 08:05:53 +0000 (UTC)
X-FDA: 84551192586.06.9EEA88D
Received: from mail-yx1-f43.google.com (mail-yx1-f43.google.com [74.125.224.43])
	by imf17.hostedemail.com (Postfix) with ESMTP id 206C54000D
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 08:05:50 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Ff/Lfpo/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of kartikey406@gmail.com designates 74.125.224.43 as permitted sender) smtp.mailfrom=kartikey406@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773648351;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ntlsUflN+hnqA9YBuYkxoTPzbyNwVTClPHMLwCnFBWc=;
	b=yKlSuq3sWc6QvodQCKy/cCe/K5rrdorI2+iIpZAkb+tqZZTWDFQ9qB7C5SxLNgJ8Cw+lr3
	3gYKgHJ46c2K0CiemWpfOqeLQFKGT3t+bCdiixkmImy80by3vskgM1HfYnhjzB4htWZ0Vc
	/2FFEz7xYQemH/RhbNp4Et2NSd9uYKE=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773648351; a=rsa-sha256;
	cv=pass;
	b=Oo0R1Pe92B5caqJacyUO7V+QVkqZ8xLqQP5CdMQK9tICmvAgtzF62jwV7rIsd0Hv4Ns6MS
	1KK1HIBV2FfyT7G0Z+mQItIEmCbq5aV7CJJqekELyVzaSU00NHLs+UQdZCoVKBwmTVUNAA
	KZSZUPoCTNQzTnmVyO4UBALpsQ0/n7E=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Ff/Lfpo/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of kartikey406@gmail.com designates 74.125.224.43 as permitted sender) smtp.mailfrom=kartikey406@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-yx1-f43.google.com with SMTP id 956f58d0204a3-64ae222d87dso3851097d50.2
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 01:05:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773648350; cv=none;
        d=google.com; s=arc-20240605;
        b=UxmvmGcjXJkuoq54PpWZewPZyDxXY0MQcv4E+UZomLL4t9LkqQsUbCR8R2ADPpV2or
         nO92OoUm40nMwigj6eug2/siJoNi/61sAOASxCA+/7XUCxMaKCq95LUgnccYkChN2wNm
         l80evZHv4fi07b+gUTPjYdROt60CvWY1OZmmzZEOX5/OOahbNJXmpfFc+CXlqPaPIpmb
         Y52jkSHbdYobRyKb4b4g3EvRvgW6ckU2buZs4otKtBXJwLRoY3GHqtXdYvE8GQKRtqln
         12lX7vf4dATIssSipeXD63rya7D9Jmf8X6xfcacYewSI5EMMNZ70H3bLbBvoWd64agy+
         qD/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ntlsUflN+hnqA9YBuYkxoTPzbyNwVTClPHMLwCnFBWc=;
        fh=eMZvzIr2HPSUNAeuUoKumXZ/gLH9WRRviUN4DVRZ/Yw=;
        b=Jc5ZgVSvFHdwWdB7aHxgOkFSnx1N7v7fOOg1puJQfbfWXLmFHn5eTgKipnXmBp6ex4
         F1Doe85UXbqyfbhdqQc4zwzAw5BWZ/ywZM+lvQAlXh2cstb2fwINlJG22hnBMiVmqq7k
         BDaorMiJ+LRUVgEAZzWjNHqav2zKfsHNWL/d1xeb4htRC4Dz7WnXEELENrr/BH16D8XM
         TDEStXUXqt0K3WsFfSAfvzqI1Hp80Wf4F14wg4ZRUMuf6mlImlFufYlWLuawpkD9Cmp/
         79iOTODYOiSPYOAGYkjwZN+WPIiyj+pPjMhbPYxoHw+lzmGY47gDM1gyak5dN7L7pFF/
         Gd3Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773648350; x=1774253150; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ntlsUflN+hnqA9YBuYkxoTPzbyNwVTClPHMLwCnFBWc=;
        b=Ff/Lfpo/HKeXaDwhjHMXE9Y4ecCI0uxn90hTkxbiPISo7pK3JjU5VXAElphiFjqNwN
         i1k4SgVF1i5R/OTC7mtkNA9NLYpkKNmp9JoBN2RT5fECbTLUaUNMY4DAoi+dVFv4mWJK
         hYCTp1d/CHN6L6W3w6S3ErNStZdt2z/zvP4aRlU9ZYbqqz7j51fXuiWzvSqMeTE6PVMM
         V5vjr/PYc06glTE6LtpCSzR4r+ACNcKd/cR0lvq1cSkoRul+Wee9nhILj40Q0a5stuSW
         NvumfwG0YUDV3kb6mxAnk40ZKgdz7UzLIGgvz1iXbU2NyvOQj6jpzQ911LWsgC8RmiCe
         bmnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773648350; x=1774253150;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ntlsUflN+hnqA9YBuYkxoTPzbyNwVTClPHMLwCnFBWc=;
        b=GdDyoujDx4QKK4n3s5vwE+pny7DQMCJfesiPHbMGljMdSn98Mo9uzE1DDJS+cwDUO8
         Wx2yPYGUJmjthHzET1uDhsMicE6K4Idcn3fJOA2bFJXoIePc+nyJOTyWw2XLfjnFXCQP
         cIkZEZDuP7Gq1UoBMsqspsQ+/EBBMJh40vve0AH9DfrWwSJMAl52rPTtywP3+Pu4EttZ
         E06RtoyA1qUuMUJIgCoayo/DZrRbOx+oIFqudeQXshLcR5QytKXouucVVPsQVHrk5Ewj
         duZukGkVsc8YjxLAyeeYQ3BJQLTmh1EM5mg59eR0JQDxCvSwOSXVc6FmXQHmfwEgUQlc
         ARpg==
X-Forwarded-Encrypted: i=1; AJvYcCV8xi5tARA51dHFxWZqNpN78td/eJbvhsgv8oKlTtHor2lSDtkuy8Fz2HXCU9eMCiTknpHg5ShrLA==@kvack.org
X-Gm-Message-State: AOJu0Ywh4pCtJeMq6fhDPKFg30swdot/YkTUe/uCr/tqfc+VG1P3n0rs
	YsdJoBshKjrLtIk6Ysf59ELt8oPEdIidUxSI2JQc56gvM+qXRx0Hnu5Z1OPfAcld7nAyX/vhW0p
	GGk/YsmJqvp4s2IZXobzc7wPWMqX3Mzw=
X-Gm-Gg: ATEYQzwSbRat59rU6SLRfo1Z2d1+U1uK+RM51/UDDdiVCdBmoTECYGXmMH9U6SMwQUq
	lPLX/m/tKzf+B0Pi1+cXV+DYjVVC3WKWWHFrS53+RFDyBknDSekFqeoRsl1dAjDBu94Qfv8Twr5
	VcsL3oTqOhn4W3i/LCfaNqnWh8yffGrPYEi7/49Iod0DiA3OBTnC2SuwCrJOuc1hwywXLT0fQYs
	cd+mx7MpSx6OWtkkl6kKIcMUgiocWgXMbOydr3F7ojzjirSzmx+QuchklxBQPkpAtlovNMKYHHG
	dk0BEz0dWMjoJpmvNjfmlA41rpAPBQIHFw3zJuvtwgIlMHmsEqpSzFaNHsTggHWhBGsLtFdH
X-Received: by 2002:a05:690c:c50f:b0:79a:3cea:9153 with SMTP id
 00721157ae682-79a3cea9472mr55394387b3.13.1773648350077; Mon, 16 Mar 2026
 01:05:50 -0700 (PDT)
MIME-Version: 1.0
References: <20260306171815.3160826-5-rppt@kernel.org> <abe1FHyYinvfLYnw@hyeyoo>
 <abe15T7cA1B9lG4F@hyeyoo>
In-Reply-To: <abe15T7cA1B9lG4F@hyeyoo>
From: Deepanshu Kartikey <kartikey406@gmail.com>
Date: Mon, 16 Mar 2026 13:35:38 +0530
X-Gm-Features: AaiRm53AvxoTI5kbBO9SnbBGaJXcRPFivylwR41z7fGjYuzu7XmFh4zaFD0j-wk
Message-ID: <CADhLXY5ydBZL5gUQZCJnSTgc=8U0Xhaj_BtvgdBtPSmWh3NTEA@mail.gmail.com>
Subject: Re: [PATCH v2 4/15] userfaultfd: introduce mfill_get_vma() and mfill_put_vma()
To: Harry Yoo <harry.yoo@oracle.com>
Cc: "Mike Rapoport (Microsoft)" <rppt@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	David Hildenbrand <david@kernel.org>, Hugh Dickins <hughd@google.com>, 
	James Houghton <jthoughton@google.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Michal Hocko <mhocko@suse.com>, 
	Muchun Song <muchun.song@linux.dev>, Nikita Kalyazin <kalyazin@amazon.com>, 
	Oscar Salvador <osalvador@suse.de>, Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>, Edward Adam Davis <eadavis@qq.com>, 
	kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 206C54000D
X-Stat-Signature: e1sbchzxsrgfjfot51awae55zs5odk3j
X-Rspam-User: 
X-HE-Tag: 1773648350-323305
X-HE-Meta: U2FsdGVkX1+By/s9vXnZW/PFQj+FsUT9lFqRevy/P/ajbqav0Xq4ZrVDX+sdqqffsbfp6v8mnK/rrdOzSHeAWUBWLq9oAU+K8ce86wytKa5e/kiO/BhSkG61AkHMBW8IewRlPogcPdh3pP5o8+U3Pf8meP/VUdHxTyBMCCZ3HUPABW62XCvdto2EOHfetHEVPvHeCpNOT0WNSe5jCisZfDvkUh/2zygIRgcmqOISXHIKzeBWaIHA27kSpMoJl9Qz/UeARHRulifut6qpFa4wEDVmwG4A3rOr6gmvzt2+46G36x5OJNx7yZISWt+Y9/kgfbNkW/02wLkY1NpeB/kRNhUtoDi9OhPw3hujpfm6O/PEUuLl5xH4MuKJ5AelcuqTIdg9cxMs4YPm/v2Evaiwj/EvwyBjaHpvnO3RL5zvU2oD0VmfOjVocD1kO/6biRqMI6m4FQ4wcS97bUWxjRxNVHgaYIumIqdrEjrjIfCZLWoQLpL6YD1aaXvO9xC922PewOCp6oDAJ6fX8Ot+vPf5eNksJN4D5wDEmSlSxSVH83+nbs9sv73HoiBOHBZJGlTlSx9ii03KViUMkTShlvcid2pFXgzDdROVE33eyVBHCGIn3nniAIXT6MlN+QzKcqrAgkjvjFXJrJ4hVjkL7Dc/SOeHXJD9WeboI3jJCCIgs9VyLIHFDfhdwixucLC49JqVqkfBVPhX2eAHx3kwJdle24kbMlIaeTfS0H6ipKmSM3wgYnwJWXgPS/7Wg6UH2F1nsSwmR58r2ZSsuZPAWozvMbBxHfV9m0pWJTMXT/YWVm0vG5oBkl9rYwPtvC1tUiLPkB1efoLM4B1P8S8KOaqZXHvA2LlX/LfnXx5BHIJkxZ6H2W3s5nw1rgLFRlozVER/HbSSMJ0JpPJyEwfsdHSHvNwwuZht1tRQp1GBDctiOiN+nwzwiemHEF4c287Hqccc2Pr+KOXY84yWq+Q7cmL
 ix+VpII2
 8Sz9HPzmooa6Y6xvgk16cXvmID52lQGRli+4tNzaUk2x540vy/I7G0oAkJOkzZuTuQLHrOdsGSartu8MKca26S34QOZaFAIV/hMkKVtXUwfRuEvPc6g7gnsmfYcRIIVI9zgIQbSlrSuKS8M34YPwdEMsBOHC/sjJE5uACA+AbGE8vzs16S3vd0PB6kq5FJqPCunsW2a2ONg4yU6ZuwiMNT/BKLSfmmZffl1KfhJ49ocU3T68oDP5VFYwi2HsiEpZsA9xMT++o4Nt1YIwjg1zNp7zmpH0TRpzYIMU/rXetf53PzphQvzoVtjueMMsx8KgOhv425Rg9sK/DjMXFODSyRwfjZhnjoVm+mbyLWjOop22ZTuwbur9v9BcBZM22P+Xa9Th9IZnptS8eghvsjd5oz1qULBhKStfJMJeTxEXubcRS3YhxFKXDxbRk3wJdCHUtbj/Z/XUNK3l0bmajqCIn86LTZfHiC9S4+DgnP28Mjkrw8zZvHjK1ZPTbl7L7whkN/lM/3xAQEydw33WOl8SyqzqzfVAh0c8K90DQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 16, 2026 at 1:19=E2=80=AFPM Harry Yoo <harry.yoo@oracle.com> wr=
ote:
>
> > It seems there's another attempt to fix the syzbot report from
> > Deepanshu Kartikey [2], which I didn't take a deeper look.
> >
> > At first look [2] looks a bit wrong way to fix to me though,
> > because it allows operating only on a single VMA nothing should really =
split
> > or shrink the VMA if somebody is holding the VMA lock in read mode
> > (and the validation of the range is done while holding the lock).
> >
> > [2] https://lore.kernel.org/linux-mm/20260316070039.549506-1-kartikey40=
6@gmail.com
> >

Harry,

You are correct that once vm_refcnt > 0, nobody can split the VMA.
However the split can happen in the race window BEFORE vm_refcnt++
in vma_start_read(), and CHECK 2 can miss this if mmap_write_unlock()
completes before CHECK 2 runs.

Here is the exact race:

vma_start_read():

    /* CHECK 1 */
    if (READ_ONCE(vma->vm_lock_seq) =3D=3D READ_ONCE(mm->mm_lock_seq.sequen=
ce))
        goto err;

    /*
     * RACE WINDOW: vm_refcnt is still 0 here!
     * UFFDIO_UNREGISTER can run:
     *
     *   mmap_write_lock()    -> mm_lock_seq =3D 11
     *   vma_start_write(vma) -> vm_lock_seq =3D 11
     *   __split_vma()        -> vma->vm_end =3D 0x4ca000
     *   mmap_write_unlock()  -> mm_lock_seq =3D 12
     *
     * writer completes entirely before vm_refcnt++!
     */

    __refcount_inc_not_zero_limited_acquire(&vma->vm_refcnt, ...);
    /* vm_refcnt =3D 1 now, but vma->vm_end already modified! */

    /* CHECK 2 */
    if (unlikely(vma->vm_lock_seq =3D=3D raw_read_seqcount(&mm->mm_lock_seq=
)))
    /*
     * vm_lock_seq(11) =3D=3D mm_lock_seq(12)?
     * NO! writer already finished and unlocked!
     * mm_lock_seq incremented to 12 (even=3Dunlocked)
     * CHECK 2 MISSES the race!
     */

    return vma;
    /*
     * returns split vma with vm_end=3D0x4ca000
     * but vm_refcnt=3D1 (lock held)
     */

Now mfill_atomic loop runs with split vma:

    while (state.src_addr < src_start + len) {

        /* iteration 1 to N: dst_addr =3D 0x1b1000 to 0x4c9000
         * all within vma->vm_end(0x4ca000)
         */

        /* iteration N+1: dst_addr =3D 0x4ca000 */
        err =3D mfill_atomic_pte(&state);
            mfill_atomic_install_pte(state->vma, dst_addr=3D0x4ca000)
                folio_add_new_anon_rmap(vma, 0x4ca000)
                    VM_WARN_ON_ONCE(address < vma->vm_start ||
                        address + (nr << 12) > vma->vm_end);
                    /* 0x4ca000 >=3D vma->vm_end(0x4ca000) -> WARN! */
    }

Without my fix:
    CRASH at folio_add_new_anon_rmap

With my fix:
    if (state.dst_addr < state.vma->vm_start ||
        state.dst_addr >=3D state.vma->vm_end) {
            mfill_put_vma(&state);
            state.dst_start =3D state.dst_addr;
            state.len =3D dst_start + len - state.dst_addr;
            err =3D mfill_get_vma(&state);
            if (err)
                break;
    }
    /* catches split, re-lookups correct VMA safely */

So both fixes are needed:

Harry's fix (state.len):
    fixes state.len uninitialized
    mfill_get_vma validates correct range
    in the first call before loop

My fix (bounds check):
    catches split VMA that slipped
    through CHECK 2 during loop
    because writer finished before
    CHECK 2 ran

