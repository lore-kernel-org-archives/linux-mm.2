Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08C40FCA17B
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 20:14:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 638206B0005; Mon,  9 Mar 2026 16:14:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 610126B0089; Mon,  9 Mar 2026 16:14:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 547546B008A; Mon,  9 Mar 2026 16:14:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3FC936B0005
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 16:14:52 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D9184C17BC
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 20:14:51 +0000 (UTC)
X-FDA: 84527627982.17.FA175F7
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1FABD140005
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 20:14:49 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=XT2DG5o8;
	spf=pass (imf09.hostedemail.com: domain of 3OCqvaQYKCJ0PB7KG9DLLDIB.9LJIFKRU-JJHS79H.LOD@flex--seanjc.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3OCqvaQYKCJ0PB7KG9DLLDIB.9LJIFKRU-JJHS79H.LOD@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773087290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vcDGw75J1CjJnpglqCPC5b33UOnC1+NDU+DgqlhrL+E=;
	b=omfPUG0kRm2k8LySnypfK+Mi4HrqLi+49wbAwZZ1NeTiYskMcXQ6QVQU8BZeDm3LYkBNnE
	J0yelLnKIz8FEB+xlfFiOW3yg+i0qDudO5YQIDNke7zYhn+jVKE0753OKya31knnpIP2RM
	wbjeMD+bcJqeioX3zEE4hwk8Dg+lQ5M=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=XT2DG5o8;
	spf=pass (imf09.hostedemail.com: domain of 3OCqvaQYKCJ0PB7KG9DLLDIB.9LJIFKRU-JJHS79H.LOD@flex--seanjc.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3OCqvaQYKCJ0PB7KG9DLLDIB.9LJIFKRU-JJHS79H.LOD@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773087290; a=rsa-sha256;
	cv=none;
	b=s6xj5U/OdqnYRj7YlDCq20cs5SKs7yf1Fk4VrTR/YtA32FLdd4l4OcZ21wTAqcq5humTPC
	RjxhtoWq0EAjkWgJjudSL4AyJuyyhN19wm8hgiaH8ZFNCByLJ6aSVfKNUHQM68Vu1OJVvE
	HQax/9t4+cfWxfStA29wrCoDlTyEgUo=
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-8299499d587so1823173b3a.0
        for <linux-mm@kvack.org>; Mon, 09 Mar 2026 13:14:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773087289; x=1773692089; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vcDGw75J1CjJnpglqCPC5b33UOnC1+NDU+DgqlhrL+E=;
        b=XT2DG5o8FmjU4mJQv6W90WkKxbZmg5tifZH+o/VZ3kXQS7sOqUgVopRfuruCtIav46
         DWk/zGDjF5yqJtnTW4jF9dB/WrOioNUKFOWnE3PqrT0kzdwPF1gBxA6WIeXb6+1l+Ah9
         fjLZiOpFIrqMU/XLcIMFL750/WkdD0CYq3yQKz6/HjEFHBD134Tt3nNhLiSQMQkgUEkf
         PcRHSkCGt+T87qqsuK4DWg7kcYND1YJgZH6kdy3kDvhhgwU0MsxBU0FkXDhO0YEBPSRP
         Pq156J6w3QuRgE6zHDujcybofdtGDTHeiXIMnXmZGpcsxjBktoXGa7fUzMzApTzg5ov0
         xiFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773087289; x=1773692089;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vcDGw75J1CjJnpglqCPC5b33UOnC1+NDU+DgqlhrL+E=;
        b=ujnayBU8m8P2BwcImCudvQUZgpcLo9l/+ONxYyp7U8/JOqJzUF/ubtnzTpuMzK+VMc
         WRrutGNqmnxtP0DbB/ON1QcWpEgmOr+CY6YdwP18TcryopBcm9++VMYGTrqLTqLPrkg5
         x0ro/Qolu7BKEisPa2KOAgmi2T2l29dncaeSqv4iyMpWXywY9IhK4s+8eX6xIc/vmg5K
         Y7niQGDshZkKXO3Pqn3ZSVdxpBOTawg57ucpYtf0/vkQJtCxenoXtZjqBFMuOxhdvyfA
         Q8RLRv3YLsB3lcd31AAK9Ry6efRDjcTAhWieWCFGCX68icKePp+J9xb4ItqKdO2oNsBn
         E2gw==
X-Forwarded-Encrypted: i=1; AJvYcCUlDj0+XcE9tzyU4tJZFi10UblVu1OVcW2k4/AR1KTuGExUrfn4OCfwjBLQSmkSe9K61y2yAM1/0g==@kvack.org
X-Gm-Message-State: AOJu0YwD+xRiHmiumSi/bNJZBRRb0Ukd6QYCtzSA0/f1wkUzTi7B6QqP
	8DLaifXx6MDXjTrm6WDj7szc2E9xGIqIAkH1p2nr4XqshXi3sfm0w3t1Z2Lr1N25Tk4m5vlvEoP
	JM9MbSg==
X-Received: from pfqz27.prod.google.com ([2002:aa7:9e5b:0:b0:821:82a1:fe7d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:4519:b0:821:8ea4:480e
 with SMTP id d2e1a72fcca58-829a2d88f61mr11174600b3a.10.1773087288647; Mon, 09
 Mar 2026 13:14:48 -0700 (PDT)
Date: Mon, 9 Mar 2026 13:14:47 -0700
In-Reply-To: <CAEvNRgHhFoyh__shK_YefhUOTP4RaG-sivUH=4Gj-2iy1HX+tw@mail.gmail.com>
Mime-Version: 1.0
References: <20260309-gmem-st-blocks-v3-0-815f03d9653e@google.com>
 <20260309-gmem-st-blocks-v3-1-815f03d9653e@google.com> <577c4725-7eda-4693-a55a-413572541161@kernel.org>
 <CAEvNRgHhFoyh__shK_YefhUOTP4RaG-sivUH=4Gj-2iy1HX+tw@mail.gmail.com>
Message-ID: <aa8qNz_52Qe6x1Kv@google.com>
Subject: Re: [PATCH RFC v3 1/4] KVM: guest_memfd: Track amount of memory
 allocated on inode
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	rientjes@google.com, rick.p.edgecombe@intel.com, yan.y.zhao@intel.com, 
	fvdl@google.com, jthoughton@google.com, vannapurve@google.com, 
	shivankg@amd.com, michael.roth@amd.com, pratyush@kernel.org, 
	pasha.tatashin@soleen.com, kalyazin@amazon.com, tabba@google.com, 
	Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Rspam-User: 
X-Rspamd-Queue-Id: 1FABD140005
X-Rspamd-Server: rspam08
X-Stat-Signature: n9d8s484fh1yxbp15j5s61i4udq15qjt
X-HE-Tag: 1773087289-795128
X-HE-Meta: U2FsdGVkX1/64OJGetrfpmMA1j9Y93n7mOqMkW2I/G1k/mJ25V3rpZuvrbv/hYQGCvKoQh5mG1GiEY+6A50R0bJsWokfbxAKUd/y4431AJxCQnhToCuiZYIRcbannVP+6LB70Tq7ulvSS/nWKyX0zgKjbJIFI/54m+NmMG5w/VCNptO0UmmlpZ5V6BO2VCJJIkTFK84K4zjA6jvzL3kIZjCHuFC5uN1NDhRiNhZ2BypAI+H60Pj6mEunKMVuG+BbAWFDSwtz6rXlUVGzxp5M4UR/IJqbjhjvmons5XtpJGCA5ul/vQvHr4L0Q4aNXAqr4SQsE0OpRfNl8VaGuh0t2EcRWmCAXA5ypyTPwW5zuXUyOq3TlmXkirp3TrUMH5uLshu5rX6DxpPBFM6eUZHEgRIt7YjwycdY3uDQTq9+mMc7nGRrUmxmx7txo3Quq09uAfVj+ohYO2NQtWHJxJqd5R0lfrAb9bvbRV52qYuCB95p9/lH5SIN32mQJaLnrw8arhn7DxXu9FOl81em9fiCW9pb1bsmzW2OCwQL5QbB40qfj1hO8YsSNXRu80MWNvEAjdBS3IuDDmvPpsmxn7ZvRJxfbfNVJU35g7K1dgMQ3xHGmviHHUO5sL7vzQuvPvFsgr5lFItKn7d0yrDCG8mtoVPYZ8mMPS2CWxEEgThKjNCbgO5z8Sw9BC4iRY5RYPkaF94zpPcyzl6l0eMAtlBRp2AeFNwcd9yQooi817wbCdh7S0xTam5pbulW9k5XS7PPIGrj2VdbyHFle0geo/4X+ixb2DPNC3lMIDO10v2TpOxfRrMjwp4ImxbYNHzQRfVW6oft/s7WkH2Sz3kL8/ZLrBfgLt0n2nw43l6rNivcnWsIYpWziznYuUyvCMv+Q3f2v9H9G4LTw44hfRk4K6x2GeFKWBNf+9CeZKX9U2fbNq/2LETB/KtOgy+hOq5GG9LHvfqQ8p3HM2JzKYT++gz
 Lb8wSRGg
 xmV1FKrwD82nlJ64g8I07aa3YLQDy8YySadP5TbRGtV+q5XMR0aUiFYtkLEhlIIJadX8BsYPBzzXBu5DTuHeKq5AnxhGkTaNXi9p2xrQNpGOjPDnmeuUTnv2uygDZQiOwVg1kMkGqrZvBHE1SWSCJq5TT/FSl4ukPRXHFmPquQKhViQZeGb1PL7WDvp2DFZzuEO+8LnZpSqerhjZ5qEOqj6KyEgIRo6i9bomUb5a+NTBNCh9YnP+NvY+sv7ACBBC7N+os2xeckEBplaLN0hMwHk7UJl2yNeR1W33tVWrLPo3JBAkpSMyTB2L/pc8AXr1zEYs9EFFOV5zlt3YAWUilCsDVj1hjiUzmPW8Acs2i8pnKegd/wCKK0iaTD/ehdMKAUIM7aYO3sQzI26v6a17+hT4VOfjtMIaUyY18rp2KuC07erMw38qlvx4aVpDX0tydN81QP0QNA7bK8NgdK1+0bPzpdGovFgIt9Sf9Y7bbwNaSAR4Ym2g7TJxSmPZQdKQ4EyJxWoKFXPb4CdKIhu2rpr/EaI4MA3lKgb/+W8vbEqDVYFCJjMgetSTDudMT7eGVrSYJTqXM3hr++lb9R4ZKDOdqkP5B2xbCO8LDI2zacjpAiRgErcyrDGeRXIWVPIxfAIndnZSQQLmYbC6aZoEIe0pdm1+kUHQhbrX8CspsgBosUz+rG081wGhbXesE8t7/DO87D/uiCgjAs0Wl8w6uM5c4Vewkhix5Anl6wNCvKikUCgo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 09, 2026, Ackerley Tng wrote:
> "David Hildenbrand (Arm)" <david@kernel.org> writes:
> 
> > On 3/9/26 10:53, Ackerley Tng wrote:
> >> The guest memfd currently does not update the inode's i_blocks and i_bytes
> >> count when memory is allocated or freed. Hence, st_blocks returned from
> >> fstat() is always 0.
> >>
> >> Introduce byte accounting for guest memfd inodes.  When a new folio is
> >> added to the filemap, add the folio's size.  Use the .invalidate_folio()
> >> callback to subtract the folio's size from inode fields when folios are
> >> truncated and removed from the filemap.
> >>
> >> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> >> ---
> >>  virt/kvm/guest_memfd.c | 14 ++++++++++++++
> >>  1 file changed, 14 insertions(+)
> >>
> >> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> >> index 462c5c5cb602a..77219551056a7 100644
> >> --- a/virt/kvm/guest_memfd.c
> >> +++ b/virt/kvm/guest_memfd.c
> >> @@ -136,6 +136,9 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
> >>  					 mapping_gfp_mask(inode->i_mapping), policy);
> >>  	mpol_cond_put(policy);
> >>
> >> +	if (!IS_ERR(folio))
> >> +		inode_add_bytes(inode, folio_size(folio));
> >> +
> >
> > Can't we have two concurrent calls to __filemap_get_folio_mpol(), and we
> > don't really know whether our call allocated the folio or simply found
> > one (the other caller allocated) in the pagecache?
> >
> 
> Ah that is true. Two threads can get past filemap_lock_folio(), then get
> to __filemap_get_folio_mpol(), and then thread 1 will return from
> __filemap_get_folio_mpol() with an allocated folio while thread 2
> returns with the folio allocated by thread 1. Both threads would end up
> incrementing the number of bytes in the inode.
> 
> Sean, Vlastimil, is this a good argument for open coding, like in RFC v2
> [1]? So that guest_memfd can do inode_add_bytes() specifically when the
> folio is added to the filemap.

Heh, I assumed that was going to be _the_ argument, i.e. I was expecting the answer
to my implicit question of "if this greatly simplifies accounting" was going to be
"trying to do the right thing while using __filemap_get_folio_mpol() is insane".

> An alternative I can think of is to add a callback that is called from
> within __filemap_add_folio(). Would that be preferred?

Probably not.  Poking around, it definitely seems like guest_memfd is the oddball.
E.g. as David pointed out, even shmem participates in disk quota stuff, and HugeTLB
is its own beast.  In other words, I doubt any "real" filesystem will want to hook
__filemap_add_folio() in this way.

So as I said before, "if this greatly simplifies accounting, then I'm ok with it".
And it sounds like the answer is an emphatic "yes".  And again as I said before,
all I ask at this point is that the refactoring changelog focuses on that point.

P.S. In future versions, please explain _why_ you want to add fstat() support,
i.e. why you want to account allocated bytes/folios.  For folks like me that do
very little userspace programming, and even less filesystems work, fstat() not
working means nothing.  Even if the answer is "because literally every other FS
in Linux works".

