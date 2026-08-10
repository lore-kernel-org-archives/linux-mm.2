Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1E87C5AD7B
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 22:26:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71B1A6B007B; Mon, 10 Aug 2026 18:26:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CBFB6B008A; Mon, 10 Aug 2026 18:26:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5933C6B008C; Mon, 10 Aug 2026 18:26:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0CAD16B007B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 18:26:53 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D7D16A02FC
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 22:26:50 +0000 (UTC)
X-FDA: 85086795780.01.7ACC620
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2A5BB80002
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 22:26:49 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=dCxqnYNr;
	spf=pass (imf02.hostedemail.com: domain of 3J1B6agYKCAw4qmzvos00sxq.o0yxuz69-yyw7mow.03s@flex--seanjc.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=3J1B6agYKCAw4qmzvos00sxq.o0yxuz69-yyw7mow.03s@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786400809;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eCvqvKq7txaLhgLohGrMSKSRSQETuQwS11gkekNEjOI=;
	b=ZACWXNJmhFtjCy2sPZ/iYwa5g1MemMzx5h6k10+9J8qKfrS72mUk/n+DZcqJiXQ7MgMgdN
	3aatmdP+D2BAhMVcrj40JiLd4umlmSfElYuhsJ/UxuYuhnR2/VJ/wmH4NmTc0tQeY//W+o
	6wZfFpctLgQkAa8Jn+x38/7p/Kkqlwk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786400809;
	b=2viPlUJWNiRFF4SjkkKqjipF1ngH4DkjUMPJCP4KleHSv4GHfq0WSEZNOd0HmZ4d7GBRFF
	px1bJL9TVim04azVEcd8hoCDv7E9pFf+bl45cJek24zu0GGWSv79cmafoOkCbM9KEjHQaI
	/vp5dphRzeZO5kxCmH2FeKEi464p2/A=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=dCxqnYNr;
	spf=pass (imf02.hostedemail.com: domain of 3J1B6agYKCAw4qmzvos00sxq.o0yxuz69-yyw7mow.03s@flex--seanjc.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=3J1B6agYKCAw4qmzvos00sxq.o0yxuz69-yyw7mow.03s@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-38dc085b0a7so3622102a91.2
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 15:26:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786400808; x=1787005608; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eCvqvKq7txaLhgLohGrMSKSRSQETuQwS11gkekNEjOI=;
        b=dCxqnYNrkZSnkOo9V7gzhY1OI81EDu6QyA1TG0rmOdU7Blde6PiH9XGyBBkz/DiK22
         M3i8VxgmlERlOdhllpwzVSnwsQzFriJBOnrLgRPJcxsMYjeGSmPIXdNlPdBnzp+MMlw0
         vrAgVUQFsg/2Z05GxehFBXsRpzU5xyjg9TPIDv4mM75XZvmxm/yARPnLCvqfhBoDXlU5
         0sE0j6efsogUgEw743G3SDcEYDGdOjNqaJBjhO8ldRAvIGJZzTlOZCiu2c1y83dyIdyI
         a2y8gh2Bn1i7ntIevMGasqbO4R/SpqOFXwnz1ryyfD5hwPhugy0FqkBhu4K7VW+YKaF2
         EwcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786400808; x=1787005608;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eCvqvKq7txaLhgLohGrMSKSRSQETuQwS11gkekNEjOI=;
        b=M1B6TMJPgoKLYzUd31Gw9H1p3j2sKFjyOT7+wHuI2+etckcf94t2fwQNseEp5f4pjt
         dDFfYehWbT2COEwpYdaQQsDPmKhnFYBvKBKG7y/A2NLi3FCdgJT4WuEaChhGTIVTEXze
         E0LKjS+8KW05XdAbOwCO/BBg2zajFBAFs38kKPyDAU5kzPEXhMNEwG2LchqqmmvBneAH
         9CZx4PwKFj8kWjhZvwRFb0+UOXHZ40ncbtcd+d7CwT2lFB9iKf3p3G2s3SgBrn29idFR
         Y4XWkZgqCDjQsYBijoDOoIfOc0ma5CuKRVbYuUviCNWhOzSFABdP8ZotmSOh0k2l++Yh
         83pw==
X-Forwarded-Encrypted: i=1; AHgh+RquhbFxb3L8BfEhV8xkmj8QakjW4os893NbXpnJM/BkYseHNu9KzMfXeDZF1G8N4mDXAwAagaOJyA==@kvack.org
X-Gm-Message-State: AOJu0Yyd92ZlKTmExWmJDIXprOAiC9NaE2GOFXEz0Zn3inweMFg0Uy/3
	E9kbfDjDnzoN8E8UCOfmbTf/danFYatdRwoy/e5Ajssu9TzHkGJWA3eI+gQyzKzqMYzZ8SVHRYV
	s+Sfn5g==
X-Received: from pgv28.prod.google.com ([2002:a63:155c:0:b0:cbe:3002:6608])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:a121:b0:3c3:8651:b317
 with SMTP id adf61e73a8af0-3cc1a13d4d0mr5100843637.10.1786400807414; Mon, 10
 Aug 2026 15:26:47 -0700 (PDT)
Date: Mon, 10 Aug 2026 15:26:46 -0700
In-Reply-To: <CAEvNRgHyRdt7rp=5e5FMbTT=fXNfB=np7VWd_GdmJcPOQgps4g@mail.gmail.com>
Mime-Version: 1.0
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
 <20260807-gmem-inplace-conversion-v10-11-2fc18ee6d3ba@google.com>
 <eb1b5763-37bc-4cb3-890c-1e619e5a8ae4@kernel.org> <CAEvNRgHyRdt7rp=5e5FMbTT=fXNfB=np7VWd_GdmJcPOQgps4g@mail.gmail.com>
Message-ID: <anpQJvFw9s-XP3pW@google.com>
Subject: Re: [PATCH v10 11/41] KVM: guest_memfd: Ensure pages are not in use
 before conversion
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, aik@amd.com, andrew.jones@linux.dev, 
	binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com, 
	jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, tabba@google.com, willy@infradead.org, 
	wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
	pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
	liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
	Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: womws4qu9g4hfn638z5ajscrfr6r1uoq
X-Rspamd-Queue-Id: 2A5BB80002
X-HE-Tag: 1786400809-697077
X-HE-Meta: U2FsdGVkX1+QPQZ1U8PWG0+QuZjKPgkJuuf1IuMma/goH9B5UnFVqhvcLZIm0nxQRWcbcgR59WMvm51bI6Mo+nq0MI+AOc8h4o1A9xu7zmYXTrO+f50Q7qEin3lzbB+JCxlm1fBP6xMa50TDNXOa8iuC6IF8Dci1myPcrZpAsdcyOJehj1mK2bpXVd+eFNGW3mi1qfDYyfFPGeIaUgMKX+SFVVn2T+CoCb7sHMSOY51NKbbRFyH+1vjOgYaTrfEThqcfWji1V9o0siiufMWEFrQ3lXBNU5e9a1S3hAg1/4gtT+Yyo47mwh/GsuQF595TdIbbj1QhkAOoeKhIzZwBRKfPU31GvBtxqVC2WQ2umqTyFXSkxdezEZhGM81ThIDC1EdufxurWQhLImeBZcvp8mVvfhNN/unb2vROHPJPVbFfDt2DPf71PABiTnUKY7ApiIYHMvIJpogU7ufgBYjGfkHpVaUjlcWwx/TyfdSawZYPFhpzF5ZdOGE8xv5YNduis53nuKJ/prSPKNApDlufDvXKCmkULxFBOi3Siw71s8E5nbrMiegVDqaY2uszrRI/4+mXTSXSUm9Yd6mxlLOscWLTGJxK5QCOe/iLNkkk/PPdX7z8aLfKCMnJcrEviMBj1TGGCnKbFTPA4fbbF1Ow+QQcKPBio2k6nIT4SlpmDYtt0NgP2YbggxII4P8Hi6ZF2BxFTVfkmhmfQ5UCBAmJhwzKWQG1ScnPnatrMTjV0dc62/1i1WiTD53q1crT59tLWWBrkUWTw0f80f0G/XQ/Dmj00NSsYJAVYRmli91g5pgX6L7BONH2qxyrGkB2sAPCfWHIVcPS1clwu50XSpPxhlZjw68P4tGs0iel+bqRVONH9wntfXwxOSh9TofsceMv6JrroJF5zDwV7/62l1Xq5ANAvyut2lDQP0v5IfLQvujJDHtWJABtRjgVPKVXeDfn7oLTWZ3kKNRkf1R+EWZ
 e2Oq1F2V
 ejh25XZeUC6IN9751nr3TWCSD51Y9bFIQKEq68um1/eL/xOh1PGxv2Tc5gPjTaPXDokkMN5ryFEPrA+/QcrAm3ryddL2GPATXhTU0rOCIfRfPJmhsI716lW5WSry8rKnRVNEuG66O+xouGVhvFbT3ECuMEXBJriQ1PHJjnJLi87/3XIBp6aENcJS99afuE9zWZx9hJFVvtM+YmBLL6D+7XjyGY7Ud6MzQCz3/2Fn5MHMQVL/P3PeKS39a6hyrLBYbpsFFao+FjbpZaBanBGk5xVUgyO7YRDBvREvcrFxUmDocH98x+Ll1G4KaqGxgA7yFcRdzX5sxIlOy++a7kuQMBL8SZ8F52dSBp7VHhHNNpOEWTLU7usVLI73GKBczgmNrZL4uykf2r/sS14j7okJAsyIdPh/nbeuWbVa2LvS/MearxgWIWIOW5H4Q4FO1GThbRcHXhXTMB4HLLV3q3TMD62MgbTU1KjCc4l4vtlPyGJD7nY3BLcM507bTtVJ1Fx+D/QlstlXVvwKgFOVy8mTZWuVSewPDDdX9aUWiIzy/mgzsWbbs2oHvTawyzdQfq5AXB7Kz0Wrx9pz3ajjaSS7kV+hoHN5MbV/LOX9sCvPWTih0foVvgI5qD6U389l8o7BrmbLE4ZvW1zI1Ryg9NnpeXMX7KnTeJfBhck7kfUY7ZgZgjnpWa7AbbcmKXentHBS66SN0dDiG1C1yXkQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 10, 2026, Ackerley Tng wrote:
> "David Hildenbrand (Arm)" <david@kernel.org> writes:
> 
> > On 8/7/26 23:52, Ackerley Tng via B4 Relay wrote:
> >> From: Ackerley Tng <ackerleytng@google.com>
> >>
> >> When converting memory to private in guest_memfd, it is necessary to ensure
> >> that the pages are not currently being accessed by any other part of the
> >> kernel or userspace to avoid any current user writing to guest private
> >> memory.
> >>
> >> guest_memfd checks for unexpected refcounts to determine whether a page is
> >> still in use. The only expected refcounts after unmapping the range
> >> requested for conversion are those that are held by guest_memfd itself.
> >>
> >> Update the kvm_memory_attributes2 structure to include an error_offset
> >> field. This allows KVM to report the exact offset where a conversion
> >> failed to userspace. If the safety check fails, return -EAGAIN and copy
> >> the error_offset back to userspace so that it can potentially retry the
> >> operation or handle the failure gracefully.
> >>
> >> Update documentation to document the error_offset field and the possible
> >> -EAGAIN error.
> >>
> >> Suggested-by: David Hildenbrand <david@kernel.org>
> >> Co-developed-by: Vishal Annapurve <vannapurve@google.com>
> >> Signed-off-by: Vishal Annapurve <vannapurve@google.com>
> >> Reviewed-by: Fuad Tabba <tabba@google.com>
> >> Tested-by: Shivank Garg <shivankg@amd.com>
> >> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> >> ---
> >
> > [...]
> >
> >>  #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
> >> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> >> index 3783e63476569..13c3989136f67 100644
> >> --- a/virt/kvm/guest_memfd.c
> >> +++ b/virt/kvm/guest_memfd.c
> >> @@ -524,8 +524,42 @@ static int kvm_gmem_mas_preallocate(struct ma_state *mas, u64 attributes,
> >>  	return mas_preallocate(mas, xa_mk_value(attributes), GFP_KERNEL);
> >>  }
> >>
> >> +static bool kvm_gmem_is_safe_for_conversion(struct inode *inode, pgoff_t start,
> >> +					    size_t nr_pages, pgoff_t *err_index)
> >
> > I would focus on the "to_private" aspect or abstract it to
> > "kvm_gmem_mem_has_unexpected_refs" or sth like that.

+1.  Maybe "kvm_gmem_page_has_outstanding_references"?

> Do you mean something like kvm_gmem_is_safe_for_to_private_conversion,
> as in that you want to emphasise that "safe" here refers to a to_private
> and not a to_shared conversion?

I'm obviously not David, but for me, the problem with names like
kvm_gmem_is_safe_for_conversion() is that (a) it conflates what the function is
literally doing with how the function is being used, which often makes the code
harder to understand as it obfuscates things, and (b) can become stale or even
outright broken far too easily.  E.g. if KVM adds more checks on whether
or not a conversion is "safe", then the name of the function is a lie because it
doesn't actually check that the target data is safe for conversion, only that
its "safe" for a specific aspect of conversion.

And there is real risk to hiding what a function does.  E.g. looking at this code
without diving into the details:

        if (to_private) {
                unmap_mapping_pages(mapping, start, nr_pages, false);

                if (!kvm_gmem_is_safe_for_conversion(inode, start, nr_pages,
                                                     err_index)) {
                        mas_destroy(&mas);
                        r = -EAGAIN;
                        goto out;
                }
        }

and one might thing that it's perfectly find to check for "safety" before
unmapping pages.   In fact, looking at the code without a priori knowledge of
the rules, and the above flat out looks wrong.  E.g. I could definitely see
someone "fixing" the code to:

        if (to_private) {
                if (!kvm_gmem_is_safe_for_conversion(inode, start, nr_pages,
                                                     err_index)) {
                        mas_destroy(&mas);
                        r = -EAGAIN;
                        goto out;
                }

                unmap_mapping_pages(mapping, start, nr_pages, false);
	}

Whereas this:

        if (to_private) {
                unmap_mapping_pages(mapping, start, nr_pages, false);

                if (kvm_gmem_has_outstanding_references(inode, start, nr_pages,
							err_index)) {
                        mas_destroy(&mas);
                        r = -EAGAIN;
                        goto out;
                }
        }

helps the reader understand what's being checked without having to look at the
details, and also helps communicate the ordering dependency without needing a
comment.

There are definitely times where the usage of a function bleeds into its name,
but usually that's because the name and the usage are on and the same.  E.g.
get_user() describes both the usage and the "what".  And it's easy/possible to
go too far in the opposite direction, e.g. by giving a play-by-play of what a
function is doing, but that's why we have bikshedding sessions :-)

> Perhaps a little ahead of its time,

Ya.

> but later with restructuring for huge pages, we also need no additional
> refcounts other than gmem's own so that restructuring is safe, hence this
> function name was meant to extend there as well.

Given that I've read that at least five times and still don't understand the
nuance, I think it's safe (ha!) to say we'll need to revisit and review those
changes no matter what. :-)

 
> In this case "unexpected" (especially since the next patch adds checks
> for maybe dma pinned and unmapping), begs the question "unexpected in
> what way"?

Ya, that's why I like "outstanding", it succinctly captures that one or more
references have been "loaned" but not yet "repaid".

> >> +	struct address_space *mapping = inode->i_mapping;
> >> +	const int filemap_get_folios_refcount = 1;
> >> +	pgoff_t last = start + nr_pages - 1;
> >> +	struct folio_batch fbatch;
> >> +	bool safe = true;
> >> +	pgoff_t next;
> >> +	int i;
> >> +
> >> +	folio_batch_init(&fbatch);
> >> +
> >> +	next = start;
> >> +	while (safe && filemap_get_folios(mapping, &next, last, &fbatch)) {
> >> +		for (i = 0; i < folio_batch_count(&fbatch); ++i) {
> >> +			struct folio *folio = fbatch.folios[i];
> >> +
> >> +			if (folio_ref_count(folio) !=
> >> +			    folio_nr_pages(folio) + filemap_get_folios_refcount) {
> >
> > I'd rather add a comment than have this filemap_get_folios_refcount.

+1, the local variable just made me scratch my head.

> >
> > /*
> >  * We expect one reference per folio-page in the pagecache and one
> >  * reference from filemap_get_folios().

Nit, please no pronouns in KVM code.

> >  */
> > if (folio_ref_count(folio) != folio_nr_pages(folio) + 1)
> >
> 
> This comment explains what's "unexpected". I can do this and switch it
> to kvm_gmem_mem_has_unexpected_refs() unless people have other
> suggestions.
> 
> I wish there was a folio_pagecache_refs(folio) that
> folio_expected_ref_count() can share with this, and also
> folio_swapcache_refs(), to solidify the definition of refcounts taken by
> the pagecache.

...

> >> @@ -542,8 +576,21 @@ static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
> >>
> >>  	mas_init(&mas, mt, start);
> >>  	r = kvm_gmem_mas_preallocate(&mas, attrs, start, nr_pages);
> >> -	if (r)
> >> +	if (r) {
> >> +		*err_index = start;
> >>  		goto out;
> >> +	}
> >> +
> >> +	if (to_private) {
> >
> > I'd add a comment here for the "why are we unmapping".
> >
> 
> Does this sound right:
> 
> Unmap here to ensure that userspace page tables have no mappings, which
> also ensures refcounts from those mappings are dropped.

How about:

		/*
		 * Forcefully unmap the pages from all userspace page tables,
		 * and then verify there are no outstanding references, e.g.
		 * acquired via GUP or similar.  Tell userspace to try again if
		 * there are oustanding references and hope that whatever has
		 * pinned the page will put its reference "soon".
		 */
		unmap_mapping_pages(mapping, start, nr_pages, false);

                if (!kvm_gmem_is_safe_for_conversion(inode, start, nr_pages,
                                                     err_index)) {
                        mas_destroy(&mas);
                        r = -EAGAIN;
                        goto out;
                }


> 
> > --
> > Cheers,
> >
> > David

