Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28064606A69E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 15:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=V075qPJp
Received: by kanga.kvack.org (Postfix)
	id 531136B078F; Tue, 24 Nov 2026 10:51:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5082F6B0791; Tue, 24 Nov 2026 10:51:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F7986B0792; Tue, 24 Nov 2026 10:51:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1BD256B078F
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 10:51:58 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A9389140C12
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:51:57 +0000 (UTC)
X-FDA: 85470453474.05.F2CF7F9
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf21.hostedemail.com (Postfix) with ESMTP id AEA4D1C0002
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:51:55 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=V075qPJp;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795535515;
	b=yjJVYxqdo+xCaRs+Uby1gSANNqr+fy7POEmw062rUkVqAMLB/fbwoTg87iFT4WQRXGgwIR
	+Ab7ZxWQryajvXk2dDqmheZfQrxEHNpzzVqyd5UCIA8TF1/ybjswxTEMN67wAd6l3MN/eX
	h869e4ypAlIaRjxbU4dOm1Djbpx5B9E=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795535515;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7151zgqNmppt1FWLTyRdRTu2s96pKFEly/RuS9gjWeY=;
	b=4AYcS/CqY9J7S6D+77G78P1ey1HJPm3iWevKZABzBbfi6XmdRz//EtkYqppE2rKoPvmm6X
	pzzy+MMxDgcGfybQOem295QpDJjusg7M94I4HCkW+Dst4pjpYexLETuVE1oTT9eCxhSxZw
	6YYS1xZ3iVUzfb7owx0MJ79foyaHztU=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=V075qPJp;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-55c7445cf85so844491cf.1
        for <linux-mm@kvack.org>; Tue, 24 Nov 2026 07:51:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795535515; cv=none;
        d=google.com; s=arc-20260327;
        b=SClqopECLK4/x/eZKe+gL+RUVfakSMKsIirwTwGbMC38y/y7UMvtxsggjokkCd7fG8
         q9+83mAezUL8I4YtY4sB6BOZQENH3jWrTS72H0JbRY3trMATyilp5VqO15v/alrmXxqX
         O/9nuw4VsVAD5I/2CIiZRAAGA1H101JY3UCgqYWYVZpomJSfLR2mIFaamw6ztOW4v6I6
         YA7/1SMlFHsR1EnXlzXihva6+dTRIPTHrRMnlpx2mAOGeZV9SnuCp80nH7vjblL48tMo
         YUtMckNqBU5OilwrBHmldRA21KK5fdFfhqeCNDFphTcN97aW6TPyU7Ak2yCLqGwV2RET
         chyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7151zgqNmppt1FWLTyRdRTu2s96pKFEly/RuS9gjWeY=;
        fh=U0wXPmtrkLfWBtmrb5klj/7rztludWURGayVzLBBcxA=;
        b=i6TH1ZpRvZeHPHQ3e4M6W0upBGOxdHVMim2XgSUW6PMbHCBHSuR6LxEiZP1MrduxCE
         F8nNthNN6GplXCkgWEsrsmU5cUa63qrnfvDLMD66HeQ33wZoeWiVzRb3y7ZEMkqXnOAh
         iEXaLR5HTvU9SghN/t3HvSSj9qOTMytwbkKNE/iNhbHE+oITnnJnvJkcL8r5cgr/kAHQ
         PmNqZ3B+DPceMAOScmo1ElXEUoDj+jfRbDsOO/IM9yfKbG+odt1FmRb5knBwtXZQeEOC
         zrQb2VWwOca48gIbaczfLtu/cqXhxrUISmPa/ZyBm2Y/xzg3cjAgsvqj87jqTRs9gDmg
         8VCg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795535515; x=1796140315; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=7151zgqNmppt1FWLTyRdRTu2s96pKFEly/RuS9gjWeY=;
        b=V075qPJpC1bNS1Sjb3DZdEyhMNokYtuFuhlM6Bt83PqVs9WKKrVjLxt/ZQkzrVyUys
         JddO+LFfTri4Vc6buePw+dH9oafRa1Bm1AWxUuYZj1eQcahMEqWNE2oo0POWUJgY9Q+q
         RXDsvZZEF0jVZKVAVtTHU3QT/9lStXsnGTQ8KIzyGL0hqmhoq7b3e/IAc3RW7HI6hSp5
         nGKcLQUVaBzadJhwK4SxQbMk1/DKpyhTY8X5l4u3Aam+tv6GCDTQnCe6geYx9eL/czAH
         Jn4/W34TlQ3ZW27JloMtLTkf5BBwXqGav9/EvuotsX+CSi4aMUpHrmEdO25ODSyQWh9q
         itmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795535515; x=1796140315;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7151zgqNmppt1FWLTyRdRTu2s96pKFEly/RuS9gjWeY=;
        b=ZRWPR4jaUxvThuYEaTIrm/r+rOHiEsQ1ZHnigdS1n3iGEA0YCenOumI34H49GSBGx+
         H3S7MdnyUHYZtHLsrnfGFpE3wmyWC/ZCgRMqpkXNsDyo6+DXyjhdr/zto8EjxC6ZCHpu
         Q0s4SyoR+dlgFvgdSsKFVUGXLGbUJc+EYX5CBpvj1BAcIRzhI0yEsJN9VfJ7OpsX9CA8
         dSftww7BmAD7evk5/7BCTWMcGCK1kV9nvIhPtVmJ6VqgtXx+FfJ0Ww2hhkXXveO2gwst
         o94cRguYuR/OMyzX/vj3+mDvv+qL0ZgbmV9cE5WS2hJt7mXxnSHmZbRnc2XzC6tinhY/
         EAzQ==
X-Forwarded-Encrypted: i=1; AL+hErFZPyfUSTqQrETYRzFmZ2pV44z/VHN+8B1lIlXHdlEBW8E+t7xm8JTdtIk27D983zNP9ynFJ0WGkA==@kvack.org
X-Gm-Message-State: APuU4Z+p9p7HT2Jl5gwXUS6XemENZvOpt0KHAuIwrRlT/M/ORM35dWej
	5c/UcpUguywTNTusZxB8wW9A+vMLZJcV8cmSwt5cJ/w2ggsmV6J4hkYw5rqO7iEsGBLsJ4jrL8h
	fk0twrH6F6ExBVuD0WEkl2hpJoCfS0stXghK81tIh
X-Gm-Gg: AZFdTZfCTcWSVAw+FGc6h6izUQTaaYhEaKOtLaUtc0Vi7ZwNV0CNd4+OP7v5YhjsPvG
	x0mKDNG8BA61DbnGldTw4ndJRNquq+ThgvsrLgTaeEwM2f8/Ca9oMTn60AZfnaRRxXvt/k/lW++
	vJLcPyG6l7poI36DjJ0j0U+d5WPkt+PH33ueZit12L+Jyy0Nq+2yPScnXEXk4C5CLHYJDu/53NM
	VZVshLbzSGejIr/WCksfDPlzFHb0YZulUvaWDEyfhiU5pAIfeiS3n2xemgp6fOga82VK+XnJJJa
	NvTLZoOy3dNs9353ex0YxL0QIN7DtU00ck1ce62NMoI/w7lW/Gdr+O6h9ZlQJkIJFEoiyGsk10l
	yanCBuSCsVyKpJRaWW1e84yPyxL48SCMXY9PGAQbqJDvjY+SS938Y801z/8Cxk0Y3FhnBpf3QeD
	8sP3uVTPtj5O9Gdc6El1KF6YjY7eE=
X-Received: by 2002:a05:622a:4819:b0:54b:648d:9ab5 with SMTP id
 d75a77b69052e-55d8903863bmr55786151cf.11.1795535514050; Tue, 24 Nov 2026
 07:51:54 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261124-vma-read-lock-mmdrop-async-v1-1-257f99f551de@kernel.org>
 <awWLCZ-jBjSD7V3M@pedro-suse.tail5790ac.ts.net> <CAJuCfpGk6eYK43Unxo+O4ML5=GM_siZ9owp6oa9fO0ipZXVg-g@mail.gmail.com>
In-Reply-To: <CAJuCfpGk6eYK43Unxo+O4ML5=GM_siZ9owp6oa9fO0ipZXVg-g@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 24 Nov 2026 07:51:42 -0800
X-Gm-Features: Aa3M54qQPEWg8Xv6M1FeAv2Yk0G2ClZoOWgLEIXc3iRWC6ZsNwo9TmRawceulIU
Message-ID: <CAJuCfpEd1rz3P7fB7W_mHkyzbpq9TscRE+QNwvHdYME=WJj6cw@mail.gmail.com>
Subject: Re: [PATCH] mm/vma: drop mm asynchronously in vma_start_read()
To: Pedro Falcato <pfalcato@suse.de>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, 
	Kees Cook <kees@kernel.org>, David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>, 
	Puranjay Mohan <puranjay@kernel.org>, Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
	Chris Mason <mason@kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: wp49ohxbrnuikabehyf4sq5ygfnmygt7
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AEA4D1C0002
X-Rspam-User:
X-HE-Tag: 1795535515-93955
X-HE-Meta: U2FsdGVkX18XAcFbT1z5sItGQibQ7S2Lu/UDQwa7YhSuN18GhAkD4VsCwnU/wjDuTCHudTlZ+/NCLX/8lirKxR2c93+nIDujYQKCdc/6fCZJ0wC403Dvk3gZg/wgUzHYhT5tvkwoflRGn6L7zgGftfediBiBOXQ6gxUwvHN1hRNmvVx+V37JU12kZuz42RH7kmq6lRLE4iHIMjZp/TUvp0n2wHgc/CWcicRrdK2s0TvLNgIXhX2KvVCWuNknN57v5VH5KH52BUz4msV8s9Z6jUZdTxLETiW05tQGdn+IT6IpGnZkJlZ5FksD/S8wCrR8piBMtmKAsMr4esKzw7Owt2cNBgKYz+qeSiuikt0skEoWxlzk0sOFbui8F2r71n8wBpVrbVGPYz8GAQvgQ8CyHPysEUOkng/KsvI8sBd08C8rVgVMH0KkR0j+Mp1my66HoiJEHUhzUhQ74bJywPjAzA0w9OnPkhkaMgTX5iK8dlFhCzBpE2h7+pLOIw7wsr/+j13JIQh3/PEYUPfNs0tnuS1v1jNDOYa5P+SIE/s8dY0CeL1cxV5d4+bfKfmc36IQraPuB/vENdQagKQk9zLhoiw2waBeu4vjgW1Zaa3R8MhibCOdOd3eJSw1pFwJNxmW5rx3bMOyOjst06agleiXCvzqHhbgvhRCp7qTKQxiCg3AFrk5paaT9pQQteFoYSbwLYwjmBTzfRBZAbsoHzf5G2IzMff2mqvY33SP848ITAGeExhL22XSs8yjlvqBTCuFnAKLO5LRrCGsMCRcnJmTU5vSSTVw4hsb++IAwMpbqiTMtjoneTv5KYaKcev2t/Rt3Ib9Ch5sv0mEE8ds6xCTUC5AXk05TpOPFAjXWbJYqkIVktgHPupM7VAoBDwwtZmWGsSgDEwOyK6994QJhghlmvjiCo7XFyvdyRFkazDw1nPu8nFRoQyjyzK59XOAWASsy1Z6mPSLyn6ZXJYAjyT
 qUmY5MYu
 LRKG5DY3wRP83UFt8yUBDn3iLIzHbg3CxK4fIXGBRLfR8WdQyP4uC6lxbdHaonL1XnuCK6nSflY8LxqC8dMktwvUA3b3SqaORI76eKDQplYZ0naxhpnjJk65CRsySGJn/zgz7aMX1alCryUp3dxUfK81WLwoYZupVtCsmtjWZkvrCcR3ExCFXpqmt5vvQWSGufGHdgQ1WPhH9EVRzKUyb5MamdbtTk0ovgAAOVfqlxasoH/2LYPz0jS5JzHlvdu1tttDEFyDjTiP6qTlf2rAgAxzkS6/sdlPl0wHwYop7XC0q4nViWLOBdyVJshL46cpYVCV5S3FKbq9XNXdkZx4DWlW0YMILk3nfm1/I6LsNrwubBulnGGp9aWsjHxTg2fx2+ay1JzLzAdvRzxAw2N1i1szxSP5joSMlLDHgTnSLqialy2AkQTpYFUSGJbr4WjrftHUrHs9bqLeb74O+gwAqH+xqaVZJteM6gGjstEKUNKFJYYR7FCF9xPk4jDi3UtopZmz5ijccNObPRr4Xs3ZjfitpOYYjv/7pHUiZnEE7QoOING6UhWPyEFIP9aFiy2VH9Be64jRGAzhEaG0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 24, 2026 at 7:46=E2=80=AFAM Suren Baghdasaryan <surenb@google.c=
om> wrote:
>
> On Tue, Nov 24, 2026 at 5:04=E2=80=AFAM Pedro Falcato <pfalcato@suse.de> =
wrote:
> >
> > On Tue, Nov 24, 2026 at 12:26:19PM +0000, Lorenzo Stoakes (ARM) wrote:
> > > Commit bee9ef4a40a2 ("bpf: switch task_vma iterator from mmap_lock to
> > > per-VMA locks") open-codes a lock_next_vma() implementation that does
> > > roughly the same thing in bpf_iter_task_vma_find_next(), only without
> > > fallback to an mmap_lock.
> > >
> > > This is because bpf_iter_task_vma_find_next() can be called from
> > > non-sleepable contexts.
> > >
> > > However, lock_vma_under_rcu() gave no guarantee as to which contexts =
it is
> > > safe to be called from, and indeed it turns out this assumption is un=
safe.
> > >
> > > Since commit 9bbffee67ffd ("mm: fix a UAF when vma->mm is freed after
> > > vma->vm_refcnt got dropped"), this call chain is possible on x86:
> > >
> > > lock_vma_under_rcu()
> > >   -> vma_start_read()
> > >     -> mmdrop()
> > >       -> __mmdrop()
> > >         -> mm_free_pgd()
> > >           -> pgd_free()
> > >             -> pgd_dtor()
> > >               -> spin_lock(&pgd_lock)
> > >
> > > Thus, a plain spin_lock() can occur when lock_vma_under_rcu() is
> > > called. Since bpf_iter_task_vma_find_next() can be called in softirq
> > > context, this can deadlock, for example:
> > >
> > > pgd_alloc()
> > >   -> spin_lock(&pgd_lock)
> > >     <softirq>
> > >     bpf_iter_task_vma_next()
> > >       -> lock_vma_under_rcu()
> > >         ...
> > >         -> spin_lock(&pgd_lock) [ DEADLOCK ]
> > >
> > > Alexei Starovoitov also pointed out that a BPF program attached to
> > > trace_contention_end() can similarly cause a deadlock:
> > >
> > >   pgd_alloc()
> > >     spin_lock(&pgd_lock)
> > >       queued_spin_lock_slowpath()
> > >         trace_contention_end()          <- pgd_lock is held
> > >           tp_btf/contention_end prog
> > >             bpf_iter_task_vma_next()
> > >               lock_vma_under_rcu()
> > >                 vma_start_read()
> > >                   mmdrop(other_mm)      <- last put takes pgd_lock ag=
ain
> > >
> > > Resolve the issue by having vma_start_read() use mmdrop_async() inste=
ad of
> > > mmdrop() so the work is deferred to a work queue.
> > >
> > > Make mmdrop_async() an internal mm function, defined in mm/internal.h=
, to
> > > avoid abuse elsewhere (kernel/fork.c includes this header, so still r=
etains
> > > access).
> > >
> > > Commit 0b16f8bed19c ("mm: change vma_start_read() to drop RCU lock on
> > > failure") accounted for the fact that the RCU lock had to be dropped =
for
> > > this operation, which is no longer applicable.
> > >
> > > For the sake of a backported fix, retain this behaviour, however drop=
 the
> > > RCU lock last and remove the now irrelevant comment.
> >
> > Is there any particular reason for unlocking the RCU comment last? afte=
r the mmdrop_async().
>
> Yeah, I think moving the RCU unlocking was unnecessary (unlock as soon
> as possible is in general advisable) and we could just remove the
> comment. Both versions however seem correct to me.

Actually, VMAs are allocated from a SLAB_TYPESAFE_BY_RCU slub. With
that RCU unlocking move you don't need other_mm copy and the comment
that comes with it. VMA won't be freed until RCU lock is dropped.

>
> >
> > >
> > > Reported-by: Chris Mason <mason@kernel.org>
> > > Fixes: bee9ef4a40a2 ("bpf: switch task_vma iterator from mmap_lock to=
 per-VMA locks")
> > > Cc: stable@vger.kernel.org
> > > Link: https://lore.kernel.org/all/DN267JUKDRNS.2VMV07CQ58R4X@gmail.co=
m/
> > > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> >
> > Acked-by: Pedro Falcato <pfalcato@suse.de>
>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
>
> >
> > --
> > Pedro

