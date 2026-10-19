Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F7DB606A321
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 18:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=T4iL6t6Y
Received: by kanga.kvack.org (Postfix)
	id BC96D6B0336; Mon, 19 Oct 2026 14:21:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7A0B6B0338; Mon, 19 Oct 2026 14:21:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A42296B0339; Mon, 19 Oct 2026 14:21:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 766256B0336
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 14:21:42 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EF4F5160776
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 18:21:41 +0000 (UTC)
X-FDA: 85340194002.10.A26495A
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf03.hostedemail.com (Postfix) with ESMTP id ED1982000F
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 18:21:39 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=T4iL6t6Y;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf03.hostedemail.com: domain of abhishekbapat@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=abhishekbapat@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792434099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=At01zq40L8WYV+a1tGSZt7rlYbzh9kAo03/fegRRcAc=;
	b=6SpyIhIOMPvuBpLEozpsXJYNw+9UkTqq9Nrz0h0sihH1iBxcmm2BdCOHsBZvUfBEpzMLU2
	J68d7UcSknZUKwyPBdsafr1vk4Q0nwuhYzY9CCva+j/pvupKmnBWtSz82VOuakWcNcpt8p
	kAAXTvSBGipfhNlnHSvU7rAXOFtqygU=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=T4iL6t6Y;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf03.hostedemail.com: domain of abhishekbapat@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=abhishekbapat@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792434099;
	b=3krN5nH2rcjWEvv7sNMWb7fmDev0YFm/2wKOR3j8WoqwNSE9j3jFBDZuTMEFoyVadP7LjX
	8I94S5HBHsbmPO5Xjyg9HcQYrWlgyZehvbSXTY7ZhqZ8MKa98o0pGdexusXRM9lqMkttWv
	cQfbbXsGnUgQWfEBbaFkB9qipNi4XRI=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2e8d6fcbba0so6465ad.1
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 11:21:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792434099; cv=none;
        d=google.com; s=arc-20260327;
        b=XH3C6+UOVJW1V0YeuV0WynDKxJ3nDpUkYjsUQe6DvrX4Ou/Z4T/36kxcVIXVyZH1b2
         gBUuvP1rRR5mIgHIAoIIuZhFG1TU4sMqNrzT2PuEkpSDKxhjQZu//xb66KdQ+dy6M42y
         +ccj26v1RSNnqiN/L3k/ipeuxvnouuFYzY2tjQqonmqVPC028dt2Of+8WD4aUbhSeH2A
         JP8K9+ih3ifV+ikT52h5rs5CCnyXGk8lWnmm417hQHyQ7xSe+PixYURBkI6WieJpP/8I
         Ae/2UcnufdWZO7DEtVl5eG9YTp1hGO0jPwKFp4nE3Qb3bZzerSfXvWenvnRDbFVCS4M+
         ABhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=At01zq40L8WYV+a1tGSZt7rlYbzh9kAo03/fegRRcAc=;
        fh=6n6PnHEWxg6rrjoD6vGlyU100LJb4pKLy30O4M2PXck=;
        b=BiImUZyge/5fAkwF2UviLmzCI48CmgtBEsUGuBYbEI4gxGncR5VgDtxcNxEr/KMeWe
         7866au6i/F6rdJ3vSuPJd9S3GXiL4/MQEZmTuIm+/Mv5t3Dm/oaDpPuyqtl8JLZwT9if
         ZtMTVL754W0IL/0RLPmSvWpWtvs2RFPYphWmDU3F2eXixIIVe8yQ+WJhQZrzIQPvpWdc
         gpYR+oY4Pq4iX5ttlFq9mPbntWSpq7Pv8qEm6KVRI95S/7mEZd80jE2IQGaE/om7LAWg
         XBxRW1eVtCHfMLKayRqubz2SwktyuNQV8y8yh1LwX4NlgG4CXuZMTPBUryQ0/60HDhib
         Yfug==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792434099; x=1793038899; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=At01zq40L8WYV+a1tGSZt7rlYbzh9kAo03/fegRRcAc=;
        b=T4iL6t6YyxziBHLLBbzO4Lj3DV/hJzh3gBHu1LB9NMC3xIMmXwj0TS6vC5fEi8oJig
         NpFlzWFc/lnhHoqftVTHMFfwhslgMhv/70d0ajtKh0kI9km4c5cIFVLrGft98bjo7oe+
         /KosA1FDo+lq/9U4TLi/cD7+e1Vc47wHvdgxNhbNrGXYaRX08eQnjgUKZmbiBxSPG0T8
         Uhe4bTRYcj4jrVKqAlRRdOLP7V/lyHMYps9e0CJNsbQsAOX8RWIjOBeewXko4vPa1OSg
         CGgDDR5/p+v6R5I1yvO+nKks/Luons2puKZzEGAtOQRgpSQFvEH94kjoD8bNJiuPfQMp
         defQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792434099; x=1793038899;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=At01zq40L8WYV+a1tGSZt7rlYbzh9kAo03/fegRRcAc=;
        b=qMGxQcgpeNJocGwi6tpPoOVcfi7NEEOtuMUQzErnpm2VrrFMLxMnVrmjcv38d5BPBZ
         OsDmb/qufNkpnSihUjvnzlyjk4f2WfQgiGSvyWsjhMRox2+JhGhb2+y/Rm3SZwQZ7CoI
         THeCKtbMbnUmiypwINXAltuzRprl/8VVgYr2GE/S9nVCoav+P98MyrRviNar/fkOqkhl
         +Lq04k9WSGrb/CLuImwpDWpmnGWhXpSkDCLX4bkmTj07Oggv/efNe1Jn/394+6QhiVlk
         JC56FEAhrsbZPMDjHqiD/pErPzJu5LOfsxtHT0LfPF+TmV37p04UBzp9IIKYxJBbkm0C
         mHuw==
X-Forwarded-Encrypted: i=1; AKwUvByLiqXhPYBgFTZOReZ0xWpjmnmqkOcxTIztnzUc7xUoUrT49J3TOaWsSU5kt5oRXyNDTZbOMDTSZg==@kvack.org
X-Gm-Message-State: AFq9FYL2XJvyjEdLj91QJTLZwPuI2mTNQBd4NLczuYkRty0OXfVTnjV8
	jTH/1FfL/W8lQr58kNvB92BFSFmT7bzALv8eKVx5jKEIw99/QoPFmYSlwy3sCduFGQE3cQ+0Hqw
	Q4eAbwryeMzAUv0OlbFp+uSFXOwULtLZR/gPS42CM
X-Gm-Gg: AYBFou1RbJniabV81Cm/W5+BWEnDiwhx0G+m2lJqiJGLtFDlQzW/VT0Vz6nk8PDQB8l
	NOAo4gv+DsuffK6EnPuz6NbCMt86eUtwW5IK6+01S3NWyOuj7RdPQJsRLt3oIb/SJRcw8pRZzMi
	n9CWyxuDjvLwLMjPEQz5NATtp4b2CJXRkQh8IcD/w437N3s+W9t+Fv5m7syp6lUMrIDqwrxwJEu
	o6nSkMoVU+arfGWRIA8A30v+r9pUDUsahN5ky2BX//xWBKl+CWb7CNr0E23C6BVB74sr2LbmGx7
	Yc6aVHdoZ+ypeaiECfg2IMd3PZYacM15RhUBL4pLE21pGxQG8SopdvsXSC6XEZNxlZepoXB71dF
	sjvezNTsRxQ==
X-Received: by 2002:a17:902:ecd0:b0:2e5:4604:c37a with SMTP id
 d9443c01a7336-2e9b32caf76mr1609025ad.18.1792434097753; Mon, 19 Oct 2026
 11:21:37 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <cover.1791410885.git.abhishekbapat@google.com>
 <ba9bee624103492dde1c8bf57943b691b4f1596b.1791410886.git.abhishekbapat@google.com>
 <39c3cf3f-4b3c-4c80-9210-279e2bf2f5c0@linux.dev> <CAJuCfpEbt-_TBjDJTNKtFTGCvPRvnAf8qewo+ppxKywORWrOpQ@mail.gmail.com>
In-Reply-To: <CAJuCfpEbt-_TBjDJTNKtFTGCvPRvnAf8qewo+ppxKywORWrOpQ@mail.gmail.com>
From: Abhishek Bapat <abhishekbapat@google.com>
Date: Mon, 19 Oct 2026 11:21:25 -0700
X-Gm-Features: AclHuK8gpExDZCd6MCgvv5VbRdlzCknhl-7S3sJKkFAgZuKouO4DyWA0u0A9CVs
Message-ID: <CAL41Mv5GM2H3CCcPzJQaGEb436eN6J1OrVaf+F8hJ0XU2DBbvQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] alloc_tag: Add trace events for tracing allocations
To: Suren Baghdasaryan <surenb@google.com>
Cc: Hao Ge <hao.ge@linux.dev>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: ED1982000F
X-Stat-Signature: h6nkousz4sagtyqsashsicoogizeosey
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792434099-832201
X-HE-Meta: U2FsdGVkX18618O/PsWlNNZyEbkywIuzhWxgU0WBdWuPOySX3Mptj3tBllO/rzooHe9QPLZHq6aQvGFhc/nxp1xzCBdOlg/bkOrL+J+L13BC5T97w3UpoHo21kIGt23jRBb+2eT3gmUwBaf1Vvh1AYGV8VUMqYSkqGEGNouEXNh6HxPJfSuIQj5Rl7WmlLwExrFzKnP+yccsJ34wz+dfAljLpH4zLCMYSdrhcimrqDjsM2Me5ofapHysaFv/eGU2465SLzTFYo9sORHAs/9G4rOrG3oznuh2iCUXlwSOtXrWMBNmV479MPVka8FI6xwTciW0X0TaCeDAZf2trw3QCJGkiYld2OM5kv+Q5wlXbtTp614bUIyD9trp3LGFyxEQqz7kkyRuu4WsNvAjypY9kG08wI/ZIcAexz6Miv17NrBy+l+Y9JZASyRSY9irlDcp7GS3IFjVAd7wyaMSgC1xndo+VLV6rcOHwjZnwaVJA9cTv++3sZjuXYmfMqH1baAVfYVHrkaHYW6jt5EOsjVzhyyN9CelJDu2XYSnhD9u3tpa+35CxBP4bMJfwVhgSAaVmURkVo0SGgYaGQleZBSPniKD0fH+Jf+IbB493J0Vb7Fwc9OBigurntPqmbFs3AKjPR/QOoH8awNxXLjF0UKc77P/KW3p0RCI/AePg+RJ3qtldSfWuBCes5EMUwpqY+NI4eh26xBXexKRP1iUHaIUHUZbzye4WUJvlJsGG69vzJOD7L82AirGOMPhbKApZhwqQFU75zuzf3RIdlsv5NtEpVCQxZufHYHjwAHBuxyqLyNTF4RJWR1hz7OyObbasc0atz7MUo+GQL/pQFmePxG7S3ca1dpKP5/kv31Mqe75Yrl5w3IyQRM/8qWqceAWqE5JvbcOrm6ieJ8TnwLyffiwDpUdRwpJLCUixZthNiwYrhosj05DD0w0DiEygO+uUl0XVYDobT31RN+4bt2/Z6j
 LN65hf9a
 3f5kHVlYraq0s6mm6S+EN0meuOUDnJTKshxjyS4rg0JvfJe1UaqvKjuHKlDh1cYABZHmy1OIbzrKHwswNB5/YLnkHYTgWpaLZxf+zesD/rsvS8SMRrPl2A7t6GK1yH++mz+TMjmVpYx/9nJqfcZxLAWSD04LmL3lOImsrjDe71VHsDCjNct/sOexmwZmNkgkEFTduGYjThLujXzHlbhNMGcyseZnJ2ME/mvxt7hnovOlD2QNUCxR1hgZdivAy/FD4JLYIiGSsvIn0rtototPHAHkMIdn1BWOm87NbEvhVp9zC0ObZp0ZSa3HcQQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Oct 17, 2026 at 5:33=E2=80=AFAM Suren Baghdasaryan <surenb@google.c=
om> wrote:
>
> On Tue, Oct 13, 2026 at 10:12=E2=80=AFAM Hao Ge <hao.ge@linux.dev> wrote:
> >
> > Hi Abhishek
> >
> >
> >
> > On 2026/10/8 06:39, Abhishek Bapat wrote:
> > > The memory allocation profiling framework intercepts allocations acro=
ss
> > > the core subsystems, but currently lacks runtime tracing hooks for
> > > standard observability tools to dynamically track the context (stack
> > > traces and lifecycles of the individual memory chunks) of the
> > > allocations made.
> > >
> > > Introduce three standard trace events to allow this tracking:
> > >
> > > 1. `alloc_tag_hit`: Fired at the exact call site. This allows userspa=
ce
> > >    tools to trigger and capture a call stack.
> > > 2. `alloc_tag_mem_alloced`: Fired in alloc_tag_add upon successful
> > >    allocation. It records the allocated size, the tag, and the unique=
ly
> > >    generated `ptr` value which is `codetag_ref` for slab and percpu
> > >    allocators and the pointer to the head `struct page` for the page
> > >    allocator.
> > > 3. `alloc_tag_mem_freed`: Fired in alloc_tag_sub right before memory =
is
> > >    freed, yielding the same `ptr` value to allow tracing tools to fin=
d
> > >    the corresponding allocation.
> > >
> > > Because the introduced trace events occur at different stages in the
> > > call stack, userspace tracing tools must stitch them together to form=
 a
> > > complete picture of a buffer's lifetime. Here's an example of how
> > > userspace correlates these three events:
> > >
> > > 1. On `alloc_tag_hit`: The tool captures the stack trace and caches i=
t,
> > >    keyed by the combination of the current thread's PID and the `tag`=
.
> > > 2. On `alloc_tag_mem_alloced`: The tool extracts the PID and `tag` fr=
om
> > >    the event and looks up the stack trace cached in step 1. It create=
s a
> > >    new active allocation record, mapping the new provided `ptr` value
> > >    to this cached stack trace and the newly returned allocation size.
> > > 3. On `alloc_tag_mem_freed`: When the memory is freed, the event yiel=
ds
> > >    the same `ptr` value. The tool uses this reference to look up the
> > >    original allocation record, correlates the free, and safely retire=
s
> > >    the tracking entry.
> > >
> > > Modify `alloc_tag_add()` and `alloc_tag_sub()` with a `ptr` argument =
to
> > > map frees to allocations in the trace events. Slab and percpu pass th=
e
> > > address of the object's `codetag_ref`. The page allocator passes the
> > > head `struct page` because its `codetag_ref` is a temporary copy on t=
he
> > > stack.
> > >
> > > Also, introduce `alloc_tag_trace_key` static key to minimize the
> > > overhead when no tags are being traced (the usual case). Once tracing
> > > for any tag is requested, the key is set, opening the path to check
> > > whether tracing is enabled for the current tag.
> > > Note that the mechanism to enable tag tracing is implemented in the n=
ext
> > > patch, therefore for now, `alloc_tag_trace_key` stays always unset.
> > >
> > > Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
> >
> > Acked-by: Hao Ge <hao.ge@linux.dev>
>
> Acked-by: Suren Baghdasaryan <surenb@google.com>
>
> >
> > > ---
> > >  Documentation/mm/allocation-profiling.rst |  53 ++++++++++
> > >  MAINTAINERS                               |   1 +
> > >  include/linux/alloc_tag.h                 |  67 +++++++++---
> > >  include/trace/events/alloc_tag.h          | 122 ++++++++++++++++++++=
++
> > >  mm/alloc_tag.c                            |  28 +++++
> > >  mm/page_alloc.c                           |   4 +-
> > >  mm/percpu.c                               |  12 ++-
> > >  mm/slub.c                                 |   6 +-
> > >  8 files changed, 269 insertions(+), 24 deletions(-)
> > >  create mode 100644 include/trace/events/alloc_tag.h
> > >
> > > diff --git a/Documentation/mm/allocation-profiling.rst b/Documentatio=
n/mm/allocation-profiling.rst
> > > index b11ea77c0673..b241450394df 100644
> > > --- a/Documentation/mm/allocation-profiling.rst
> > > +++ b/Documentation/mm/allocation-profiling.rst
> > > @@ -129,6 +129,59 @@ To do so:
> > >  - Then, use the following form for your allocations:
> > >    alloc_hooks_tag(ht->your_saved_tag, kmalloc_noprof(...))
> > >
> > > +Tracing
> > > +=3D=3D=3D=3D=3D=3D=3D
> > > +
> > > +Three trace events are available under `/sys/kernel/tracing/events/a=
lloc_tag` to
> > > +expose the full call stack and the lifetime of individual allocation=
s:
> > > +
> > > +- `alloc_tag_hit`: Fired at the exact call site, before the allocati=
on happens.
> > > +  Can be used to capture the call stack of the caller.
> > > +
> > > +- `alloc_tag_mem_alloced`: Fired once the allocation succeeds. Carri=
es the `ptr`,
> > > +  `tag` and `bytes` for each allocation.
> > > +
> > > +- `alloc_tag_mem_freed`: Fired before memory is freed. Carries the s=
ame
> > > +  `ptr`, `tag` and `bytes` as the matching alloc event.
> > > +
> > > +`ptr` identifies the allocation, and its meaning depends on the allo=
cator:
> > > +
> > > +- slab and percpu: the address of the object's `codetag_ref`
> > > +- page allocator: the `struct page` pointer of the head page
> > > +
> > > +Correlating the events
> > > +----------------------
> > > +
> > > +`alloc_tag_hit` and `alloc_tag_mem_alloced` come from different poin=
ts in the
> > > +call stack, so they have to be stitched together by the user consumi=
ng the
> > > +events. Here's a typical flow:
> > > +
> > > +1. On `alloc_tag_hit`: Capture the stack trace and cache it keyed by=
 `(pid, tag)`.
> > > +
> > > +2. On `alloc_tag_mem_alloced`: Look up the cached stack trace by `(p=
id, tag)`,
> > > +   then create an active allocation record keyed by `ptr` that holds=
 the stack
> > > +   trace and `bytes`.
> > > +
> > > +3. On `alloc_tag_mem_freed`: Look up the record by `ptr` and retire =
it.
> > > +
> > > +Limitations
> > > +-----------
> > > +
> > > +- For the page allocator, events are generated for the original allo=
cation and
> > > +  the free only. If the tag reference is split or moved to another f=
olio in
> > > +  between, no event is generated for that. As a result:
> > > +
> > > +  - a free event may carry a `ptr` that never appeared in an alloc e=
vent;
> > > +  - `bytes` in a free event may be smaller than in the matching allo=
c event.
> > > +
> > > +  Tools should correlate on `ptr` but must not assume that freed byt=
es equal
> > > +  allocated bytes, or that every free has a matching alloc.
> > > +
> > > +- Freeing a non-compound high-order page with `__free_pages()` while=
 another CPU
> > > +  holds a reference frees the tail pages immediately and the head pa=
ge later when
> > > +  the reference is dropped. The free event is emitted at the second =
point and
> > > +  reports `PAGE_SIZE` rather than the full size.
> > > +
> > >  Notes
> > >  =3D=3D=3D=3D=3D
> > >
> > > diff --git a/MAINTAINERS b/MAINTAINERS
> > > index 5c38da7090db..751ce786a378 100644
> > > --- a/MAINTAINERS
> > > +++ b/MAINTAINERS
> > > @@ -17100,6 +17100,7 @@ S:    Maintained
> > >  F:   Documentation/mm/allocation-profiling.rst
> > >  F:   include/linux/alloc_tag.h
> > >  F:   include/linux/pgalloc_tag.h
> > > +F:   include/trace/events/alloc_tag.h
> > >  F:   include/uapi/linux/alloc_tag.h
> > >  F:   mm/alloc_tag.c
> > >  F:   tools/testing/selftests/alloc_tag/
> > > diff --git a/include/linux/alloc_tag.h b/include/linux/alloc_tag.h
> > > index 7f2d80a59792..49825177d8c8 100644
> > > --- a/include/linux/alloc_tag.h
> > > +++ b/include/linux/alloc_tag.h
> > > @@ -128,12 +128,33 @@ DECLARE_PER_CPU(struct alloc_tag_counters, _sha=
red_alloc_tag);
> > >  DECLARE_STATIC_KEY_MAYBE(CONFIG_MEM_ALLOC_PROFILING_ENABLED_BY_DEFAU=
LT,
> > >                       mem_alloc_profiling_key);
> > >
> > > +DECLARE_STATIC_KEY_FALSE(alloc_tag_trace_key);
> > > +
> > >  static inline bool mem_alloc_profiling_enabled(void)
> > >  {
> > >       return static_branch_maybe(CONFIG_MEM_ALLOC_PROFILING_ENABLED_B=
Y_DEFAULT,
> > >                                  &mem_alloc_profiling_key);
> > >  }
> > >
> > > +static inline bool alloc_tag_trace_enabled(void)
> > > +{
> > > +     return static_branch_unlikely(&alloc_tag_trace_key);
> > > +}
> > > +
> > > +void alloc_tag_trace_mem_alloc(const void *ptr, struct alloc_tag *ta=
g,
> > > +                            size_t bytes);
> > > +
> > > +void alloc_tag_trace_mem_free(const void *ptr, struct alloc_tag *tag=
,
> > > +                           size_t bytes);
> > > +
> > > +void __alloc_tag_trace_hit(struct alloc_tag *tag);
> > > +
> > > +static __always_inline void alloc_tag_trace_hit(struct alloc_tag *ta=
g)
> > > +{
> > > +     if (alloc_tag_trace_enabled())
> > > +             __alloc_tag_trace_hit(tag);
> > > +}
> > > +
> > >  bool mem_alloc_profiling_permanently_disabled(void);
> > >
> > >  static inline struct alloc_tag_counters alloc_tag_read(struct alloc_=
tag *tag)
> > > @@ -198,13 +219,19 @@ static inline bool alloc_tag_ref_set(union code=
tag_ref *ref, struct alloc_tag *t
> > >       return true;
> > >  }
> > >
> > > -static inline void alloc_tag_add(union codetag_ref *ref, struct allo=
c_tag *tag, size_t bytes)
> > > +static inline void alloc_tag_add(union codetag_ref *ref, struct allo=
c_tag *tag, size_t bytes,
> > > +                              const void *ptr)
> > >  {
> > > -     if (likely(alloc_tag_ref_set(ref, tag)))
> > > +     if (likely(alloc_tag_ref_set(ref, tag))) {
> > >               this_cpu_add(tag->counters->bytes, bytes);
> > > +
> > > +             if (alloc_tag_trace_enabled())
> > > +                     /* Trace successful allocs with their unique pt=
r */
> > > +                     alloc_tag_trace_mem_alloc(ptr, tag, bytes);
> > > +     }
> > >  }
> > >
> > > -static inline void alloc_tag_sub(union codetag_ref *ref, size_t byte=
s)
> > > +static inline void alloc_tag_sub(union codetag_ref *ref, size_t byte=
s, const void *ptr)
> > >  {
> > >       struct alloc_tag *tag;
> > >
> > > @@ -222,6 +249,10 @@ static inline void alloc_tag_sub(union codetag_r=
ef *ref, size_t bytes)
> > >       this_cpu_sub(tag->counters->bytes, bytes);
> > >       this_cpu_dec(tag->counters->calls);
> > >
> > > +     if (alloc_tag_trace_enabled())
> > > +             /* Trace frees with their unique ptr */
> > > +             alloc_tag_trace_mem_free(ptr, tag, bytes);
> > > +
> > >       ref->ct =3D NULL;
> > >  }
> > >
> > > @@ -243,25 +274,29 @@ static inline bool alloc_tag_is_inaccurate(stru=
ct alloc_tag *tag)
> > >  static inline bool mem_alloc_profiling_enabled(void) { return false;=
 }
> > >  static inline bool mem_alloc_profiling_permanently_disabled(void) { =
return true; }
> > >  static inline void alloc_tag_add(union codetag_ref *ref, struct allo=
c_tag *tag,
> > > -                              size_t bytes) {}
> > > -static inline void alloc_tag_sub(union codetag_ref *ref, size_t byte=
s) {}
> > > +                              size_t bytes, const void *ptr) {}
> > > +static inline void alloc_tag_sub(union codetag_ref *ref, size_t byte=
s,
> > > +                              const void *ptr) {}
> > >  static inline void alloc_tag_set_inaccurate(struct alloc_tag *tag) {=
}
> > >  static inline bool alloc_tag_is_inaccurate(struct alloc_tag *tag) { =
return false; }
> > > +#define alloc_tag_trace_hit(_tag)    /* NOOP */
> > >  #define alloc_tag_record(p)  do {} while (0)
> > >
> > >  #endif /* CONFIG_MEM_ALLOC_PROFILING */
> > >
> > > -#define alloc_hooks_tag(_tag, _do_alloc)                            =
 \
> > > -({                                                                  =
 \
> > > -     typeof(_do_alloc) _res;                                        =
 \
> > > -     if (mem_alloc_profiling_enabled()) {                           =
 \
> > > -             struct alloc_tag * __maybe_unused _old;                =
 \
> > > -             _old =3D alloc_tag_save(_tag);                         =
   \
> > > -             _res =3D _do_alloc;                                    =
   \
> > > -             alloc_tag_restore(_tag, _old);                         =
 \
> > > -     } else                                                         =
 \
> > > -             _res =3D _do_alloc;                                    =
   \
> > > -     _res;                                                          =
 \
> > > +#define alloc_hooks_tag(_tag, _do_alloc)                            =
         \
> > > +({                                                                  =
         \
> > > +     typeof(_do_alloc) _res;                                        =
         \
> > > +     if (mem_alloc_profiling_enabled()) {                           =
         \
> > > +             struct alloc_tag * __maybe_unused _old;                =
         \
> > > +             /* Fired here to cleanly capture the caller's stack tra=
ce */    \
> > > +             alloc_tag_trace_hit(_tag);                             =
         \
> > > +             _old =3D alloc_tag_save(_tag);                         =
           \
> > > +             _res =3D _do_alloc;                                    =
           \
> > > +             alloc_tag_restore(_tag, _old);                         =
         \
> > > +     } else                                                         =
         \
> > > +             _res =3D _do_alloc;                                    =
           \
> > > +     _res;                                                          =
         \
> > >  })
> > >
> > >  #define alloc_hooks(_do_alloc)                                      =
         \
> > > diff --git a/include/trace/events/alloc_tag.h b/include/trace/events/=
alloc_tag.h
> > > new file mode 100644
> > > index 000000000000..b79efb7dd25c
> > > --- /dev/null
> > > +++ b/include/trace/events/alloc_tag.h
> > > @@ -0,0 +1,122 @@
> > > +/* SPDX-License-Identifier: GPL-2.0 */
> > > +#undef TRACE_SYSTEM
> > > +#define TRACE_SYSTEM alloc_tag
> > > +
> > > +#if !defined(_TRACE_ALLOC_TAG_H) || defined(TRACE_HEADER_MULTI_READ)
> > > +#define _TRACE_ALLOC_TAG_H
> > > +
> > > +#include <linux/tracepoint.h>
> > > +
> > > +/*
> > > + * alloc_tag_hit is generated at the exact allocation call site and =
can be
> > > + * used to capture a clean stack trace.
> > > + *
> > > + * To link this stack trace to the actual allocated memory chunk, to=
ols must
> > > + * correlate this event with the resulting alloc_tag_mem_alloced eve=
nt. Since
> > > + * multiple threads can hit the same tag simultaneously, tools must =
match BOTH
> > > + * the `tag` field and the implicitly recorded PID provided by the c=
ore
> > > + * tracing subsystem.
> > > + */
> > > +TRACE_EVENT(alloc_tag_hit,
> > > +     TP_PROTO(struct alloc_tag *tag),
> > > +
> > > +     TP_ARGS(tag),
> > > +
> > > +     TP_STRUCT__entry(__field(struct alloc_tag *, tag)
> > > +                      __string(modname, tag->ct.modname ? tag->ct.mo=
dname : "NONE")
> > > +                      __string(filename, tag->ct.filename)
> > > +                      __string(function, tag->ct.function)
> > > +                      __field(unsigned int, lineno)
> > > +     ),
> > > +
> > > +     TP_fast_assign(__entry->tag =3D tag;
> > > +                    __assign_str(modname);
> > > +                    __assign_str(filename);
> > > +                    __assign_str(function);
> > > +                    __entry->lineno =3D tag->ct.lineno;
> > > +     ),
> > > +
> > > +     TP_printk("tag %p, module: %s, filename: %s, function %s, linen=
o %u",
> > > +               __entry->tag,
> > > +               __get_str(modname),
> > > +               __get_str(filename),
> > > +               __get_str(function),
> > > +               __entry->lineno
> > > +     )
> > > +);
> > > +
> > > +/*
> > > + * alloc_tag_mem_alloced is generated after memory is successfully a=
llocated.
> > > + * It captures the exact byte size.
> > > + *
> > > + * The `ptr` value identifies the memory chunk for tracking its life=
cycle
> > > + * (e.g., matching it with alloc_tag_mem_freed).
> > > + * - slab and percpu allocators: address of the object's codetag_ref
> > > + * - page allocator: the head struct page of the allocation
> > > + *
> > > + * Because the kernel isolates active allocations within the task st=
ruct
> > > + * (current->alloc_tag), this event will always share the same impli=
cit PID as
> > > + * its corresponding alloc_tag_hit event. Tools should use the combi=
nation
> > > + * PID + `tag` to correlate them.
> > > + */
> > > +TRACE_EVENT(alloc_tag_mem_alloced,
> > > +     TP_PROTO(const void *ptr, struct alloc_tag *tag, size_t bytes),
> > > +
> > > +     TP_ARGS(ptr, tag, bytes),
> > > +
> > > +     TP_STRUCT__entry(__field(const void *, ptr)
> > > +                      __field(struct alloc_tag *, tag)
> > > +                      __field(size_t, bytes)
> > > +     ),
> > > +
> > > +     TP_fast_assign(__entry->ptr =3D ptr;
> > > +                    __entry->tag =3D tag;
> > > +                    __entry->bytes =3D bytes;
> > > +     ),
> > > +
> > > +     TP_printk("ptr %p, tag %p, bytes %zu",
> > > +               __entry->ptr,
> > > +               __entry->tag,
> > > +               __entry->bytes
> > > +     )
> > > +);
> > > +
> > > +/*
> > > + * alloc_tag_mem_freed event is generated immediately before memory =
is
> > > + * freed. The `ptr` value matches the one emitted during allocation,
> > > + * allowing tools to match it to its corresponding allocation and
> > > + * call stack.
> > > + *
> > > + * Page allocator caveat: Pages can be split or moved to another fol=
io
> > > + * after the alloc event with no new events generated for that. As a
> > > + * result, a free event may carry a `ptr` that never appeared in an
> > > + * alloc event, and the `bytes` may be smaller than in the matching
> > > + * alloc event. Tools must not assume alloc bytes =3D=3D free bytes,=
 nor
> > > + * that every free has a matching alloc.
> > > + */
> > > +TRACE_EVENT(alloc_tag_mem_freed,
> > > +     TP_PROTO(const void *ptr, struct alloc_tag *tag, size_t bytes),
> > > +
> > > +     TP_ARGS(ptr, tag, bytes),
> > > +
> > > +     TP_STRUCT__entry(__field(const void *, ptr)
> > > +                      __field(struct alloc_tag *, tag)
> > > +                      __field(size_t, bytes)
> > > +     ),
> > > +
> > > +     TP_fast_assign(__entry->ptr =3D ptr;
> > > +                    __entry->tag =3D tag;
> > > +                    __entry->bytes =3D bytes;
> > > +     ),
> > > +
> > > +     TP_printk("ptr %p, tag %p, bytes %zu",
> > > +               __entry->ptr,
> > > +               __entry->tag,
> > > +               __entry->bytes
> > > +     )
> > > +);
> > > +
> > > +#endif /* _TRACE_ALLOC_TAG_H */
> > > +
> > > +/* This part must be outside protection */
> > > +#include <trace/define_trace.h>
> > > diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
> > > index 82e2c3448dcf..ca2412a67312 100644
> > > --- a/mm/alloc_tag.c
> > > +++ b/mm/alloc_tag.c
> > > @@ -18,6 +18,9 @@
> > >  #include <linux/kmemleak.h>
> > >  #include <uapi/linux/alloc_tag.h>
> > >
> > > +#define CREATE_TRACE_POINTS
> > > +#include <trace/events/alloc_tag.h>
> > > +
> > >  #include "internal.h"
> > >  #include "page_alloc.h"
> > >
> > > @@ -54,6 +57,9 @@ EXPORT_SYMBOL(mem_alloc_profiling_key);
> > >
> > >  DEFINE_STATIC_KEY_FALSE(mem_profiling_compressed);
> > >
> > > +DEFINE_STATIC_KEY_FALSE(alloc_tag_trace_key);
> > > +EXPORT_SYMBOL(alloc_tag_trace_key);
> > > +
> > >  struct alloc_tag_kernel_section kernel_tags =3D { NULL, 0 };
> > >  unsigned long alloc_tag_ref_mask;
> > >  int alloc_tag_ref_offs;
> > > @@ -484,6 +490,28 @@ static const struct proc_ops allocinfo_proc_ops =
=3D {
> > >  #endif
> > >  };
> > >
> > > +void __alloc_tag_trace_hit(struct alloc_tag *tag)
> > > +{
> > > +     if (unlikely(!tag))
>
> nit: Is there a case when we pass tag=3DNULL here?
>

Yes, sashiko brought this up during my local review before I sent the
patch. If MAP CONFIG option is enabled but the kernel is booted with
the sysctl set to 0, rhashtable_init() eventually calls
alloc_hooks_tag(). mem_alloc_profiling_enabled() returns false and
alloc_tag_save() is skipped leaving ht->alloc_tag to NULL. If the
sysctl value is later enabled, alloc_hooks_tag() will be called with
ht->alloc_tag set =3D NULL leading to a NULL pointer exception in
alloc_tag_trace_hit(). Which is why the NULL check is required.

> > > +             return;
> > > +     trace_alloc_tag_hit(tag);
> > > +}
> > > +EXPORT_SYMBOL(__alloc_tag_trace_hit);
> > > +
> > > +void alloc_tag_trace_mem_alloc(const void *ptr, struct alloc_tag *ta=
g,
> > > +                            size_t bytes)
> > > +{
> > > +     trace_alloc_tag_mem_alloced(ptr, tag, bytes);
> > > +}
> > > +EXPORT_SYMBOL(alloc_tag_trace_mem_alloc);
> > > +
> > > +void alloc_tag_trace_mem_free(const void *ptr, struct alloc_tag *tag=
,
> > > +                           size_t bytes)
> > > +{
> > > +     trace_alloc_tag_mem_freed(ptr, tag, bytes);
> > > +}
> > > +EXPORT_SYMBOL(alloc_tag_trace_mem_free);
> > > +
> > >  size_t alloc_tag_top_users(struct codetag_bytes *tags, size_t count,=
 bool can_sleep)
> > >  {
> > >       struct codetag_iterator iter;
> > > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > > index 7682aecc2c07..5e3e411d4ffe 100644
> > > --- a/mm/page_alloc.c
> > > +++ b/mm/page_alloc.c
> > > @@ -1239,7 +1239,7 @@ void __pgalloc_tag_add(struct page *page, struc=
t task_struct *task,
> > >       union codetag_ref ref;
> > >
> > >       if (likely(get_page_tag_ref(page, &ref, &handle))) {
> > > -             alloc_tag_add(&ref, task->alloc_tag, PAGE_SIZE * nr);
> > > +             alloc_tag_add(&ref, task->alloc_tag, PAGE_SIZE * nr, pa=
ge);
> > >               update_page_tag_ref(handle, &ref);
> > >               put_page_tag_ref(handle);
> > >       } else {
> > > @@ -1268,7 +1268,7 @@ void __pgalloc_tag_sub(struct page *page, unsig=
ned int nr)
> > >       union codetag_ref ref;
> > >
> > >       if (get_page_tag_ref(page, &ref, &handle)) {
> > > -             alloc_tag_sub(&ref, PAGE_SIZE * nr);
> > > +             alloc_tag_sub(&ref, PAGE_SIZE * nr, page);
> > >               update_page_tag_ref(handle, &ref);
> > >               put_page_tag_ref(handle);
> > >       }
> > > diff --git a/mm/percpu.c b/mm/percpu.c
> > > index 3eff382e565a..12b6c97d1596 100644
> > > --- a/mm/percpu.c
> > > +++ b/mm/percpu.c
> > > @@ -1695,15 +1695,19 @@ static void pcpu_alloc_tag_alloc_hook(struct =
pcpu_chunk *chunk, int off,
> > >                                     size_t size)
> > >  {
> > >       if (mem_alloc_profiling_enabled() && likely(chunk->obj_exts)) {
> > > -             alloc_tag_add(&chunk->obj_exts[off >> PCPU_MIN_ALLOC_SH=
IFT].tag,
> > > -                           current->alloc_tag, size);
> > > +             union codetag_ref *ref =3D &chunk->obj_exts[off >> PCPU=
_MIN_ALLOC_SHIFT].tag;
> > > +
> > > +             alloc_tag_add(ref, current->alloc_tag, size, ref);
> > >       }
> > >  }
> > >
> > >  static void pcpu_alloc_tag_free_hook(struct pcpu_chunk *chunk, int o=
ff, size_t size)
> > >  {
> > > -     if (mem_alloc_profiling_enabled() && likely(chunk->obj_exts))
> > > -             alloc_tag_sub(&chunk->obj_exts[off >> PCPU_MIN_ALLOC_SH=
IFT].tag, size);
> > > +     if (mem_alloc_profiling_enabled() && likely(chunk->obj_exts)) {
> > > +             union codetag_ref *ref =3D &chunk->obj_exts[off >> PCPU=
_MIN_ALLOC_SHIFT].tag;
> > > +
> > > +             alloc_tag_sub(ref, size, ref);
> > > +     }
> > >  }
> > >  #else
> > >  static void pcpu_alloc_tag_alloc_hook(struct pcpu_chunk *chunk, int =
off,
> > > diff --git a/mm/slub.c b/mm/slub.c
> > > index 544cff39762c..a866576ccb98 100644
> > > --- a/mm/slub.c
> > > +++ b/mm/slub.c
> > > @@ -2404,7 +2404,7 @@ __alloc_tagging_slab_alloc_hook(struct kmem_cac=
he *s, void *object, gfp_t flags,
> > >               obj_ext =3D slab_obj_ext(s, slab, obj_exts, object);
> > >               ref =3D slab_obj_ext_codetag_ref(slab, obj_ext);
> > >
> > > -             alloc_tag_add(ref, current->alloc_tag, s->size);
> > > +             alloc_tag_add(ref, current->alloc_tag, s->size, ref);
> > >
> > >               put_slab_obj_exts(obj_exts);
> > >       } else {
> > > @@ -2444,9 +2444,11 @@ __alloc_tagging_slab_free_hook(struct kmem_cac=
he *s, struct slab *slab, void **p
> > >       get_slab_obj_exts(obj_exts);
> > >       for (int i =3D 0; i < objects; i++) {
> > >               struct slabobj_ext *ext;
> > > +             union codetag_ref *ref;
> > >
> > >               ext =3D slab_obj_ext(s, slab, obj_exts, p[i]);
> > > -             alloc_tag_sub(slab_obj_ext_codetag_ref(slab, ext), s->s=
ize);
> > > +             ref =3D slab_obj_ext_codetag_ref(slab, ext);
> > > +             alloc_tag_sub(ref, s->size, ref);
> > >       }
> > >       put_slab_obj_exts(obj_exts);
> > >  }

