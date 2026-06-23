Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22456CDB46F
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 01:15:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8EAE6B0088; Mon, 22 Jun 2026 21:15:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3FB26B008A; Mon, 22 Jun 2026 21:15:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2FA66B008C; Mon, 22 Jun 2026 21:15:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 989396B0088
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 21:15:50 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1455D166C6C
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 01:15:50 +0000 (UTC)
X-FDA: 84909410460.03.EEDF8E5
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4DA4F80008
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 01:15:48 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=dDIOMCBP;
	spf=pass (imf02.hostedemail.com: domain of 3Qt45agYKCD8tfbokdhpphmf.dpnmjovy-nnlwbdl.psh@flex--seanjc.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3Qt45agYKCD8tfbokdhpphmf.dpnmjovy-nnlwbdl.psh@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782177348;
	b=JiHs93uFg/c41nfFo8f7dnjl3/3B5GP1Pw2zB8Wo+S34wDEc0XsWz8qQaCSx6mN7UVbwOB
	vMNyP1PG48o2WnVCrd6knaL1mKd247Sd2eXGkhhA2blulHf/35L1C2S2Rlbz67r2ku+CXo
	MbSp7vl+uppJajdyPdlcZ0BGlQH2E+0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782177348;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cIaeqJX/r6ONezV3RTMNlvuGHs6v4DCaJbK0FNFaqOE=;
	b=6zttUTRUfGsy/cVt7ij0HRZ0LW1FOfMbd3dY+LEc8p8+yPF5J5XrmRHERw+DDjPN/YEM29
	BhoUQ1wpiZcRfoD6Hab3dnmQNMdz0ShNa7m8v19n+UOtwig4Nvoc6UdFrT1kkXqs5RiS3y
	q8HT8gcn8RfjedcouCZFr9QuzC6PAkU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=dDIOMCBP;
	spf=pass (imf02.hostedemail.com: domain of 3Qt45agYKCD8tfbokdhpphmf.dpnmjovy-nnlwbdl.psh@flex--seanjc.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3Qt45agYKCD8tfbokdhpphmf.dpnmjovy-nnlwbdl.psh@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-8421f5d76aaso3454468b3a.2
        for <linux-mm@kvack.org>; Mon, 22 Jun 2026 18:15:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782177347; x=1782782147; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cIaeqJX/r6ONezV3RTMNlvuGHs6v4DCaJbK0FNFaqOE=;
        b=dDIOMCBPVGb/AViKnoNv/GJ9ZcEGUEN9Lg4g8oe+oRJqbUX29ZDLfpwyWumaxfMURb
         5FKup3yDPATvZ+wLQdOOt7/wZXH0SHMC1c1Yxf81CdwKrplDtpZg0qKM062+gSDOEVN1
         0ctO/IUxTJLazFVb6IIny7z6zUCkATdLMGmIlK8uF10CaCd72VXFt8EX8TIqux804pHe
         P6xeC4La427bQEMXR+xn1z38g3FTl6hwmsqPM2Shl8E/I4txmWmw7Qqhuz3JWWknvSaM
         XkBqrQCpexqzRWoJ1ajgFWmZqxgjKCbrNX12dQhRoGySvuZq4AITgOn0NoLfC9FJT6fJ
         6ayQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782177347; x=1782782147;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cIaeqJX/r6ONezV3RTMNlvuGHs6v4DCaJbK0FNFaqOE=;
        b=cUPDtD+dRC7ODGwN3bIDkZVGQMQ+JbT0V9b+9A53OXeEBEVT05wR/SMneP1Na9+jLu
         Itq8dsRMgGd26FgjvKYtZqwlYB4GOTXYV5UCCA+L6fGpMYBwKxbroNhTMzWeP+912Lsc
         eHQy+dGIMxbD5SCIn5UO1dHwIBxwG5jtSOP99jgy8FB/RonD5+Bt8mAX40CNEc3cGubP
         ZyvXyduqMy0+7KqoTeZvjUd5kZwyA27HOxrA9aZuQZqzLPIDgb/urEXbMyvq6+U09ry7
         ByEMrOXecU10iYRNPVNbHTGjS0mgqcNM7G7Atl/D6BFeM7gbPa+nYSukDr7ujytRqXU/
         MPfw==
X-Forwarded-Encrypted: i=1; AFNElJ/44CvlCFCIqREtJMlMqgiUJLZ5eyA2S2fBMCvoO76HrZa40q7uSQ+6jiWvoc3U5IGTAfwbLcXAiA==@kvack.org
X-Gm-Message-State: AOJu0YxM8toy/Nb/ZMpDn1m5Yf7lXz1RVxvqaGe2B6IGGQIahR8rO/0n
	uWa12qRkfwV4bMuIJ3PsusbB7NNDXw9s6z3VDsuANFRycTwqsNgAwYRKXv7B0CoIUDpQc8B09bj
	Z8nU+Ig==
X-Received: from pfbim3.prod.google.com ([2002:a05:6a00:8d83:b0:845:2f64:1f67])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:22c5:b0:82f:38df:681c
 with SMTP id d2e1a72fcca58-8459704a890mr377593b3a.6.1782177346471; Mon, 22
 Jun 2026 18:15:46 -0700 (PDT)
Date: Mon, 22 Jun 2026 18:15:45 -0700
In-Reply-To: <CA+EHjTx+3U++dnhGEkwh2SO82xMugAvvJ9ee1O__sxZCKL_X5A@mail.gmail.com>
Mime-Version: 1.0
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
 <20260618-gmem-inplace-conversion-v8-15-9d2959357853@google.com> <CA+EHjTx+3U++dnhGEkwh2SO82xMugAvvJ9ee1O__sxZCKL_X5A@mail.gmail.com>
Message-ID: <ajneQVLriUshjFIO@google.com>
Subject: Re: [PATCH v8 15/46] KVM: guest_memfd: Call arch invalidate hooks on conversion
From: Sean Christopherson <seanjc@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: ackerleytng@google.com, aik@amd.com, andrew.jones@linux.dev, 
	binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com, 
	david@kernel.org, jmattson@google.com, jthoughton@google.com, 
	michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	shivankg@amd.com, steven.price@arm.com, willy@infradead.org, 
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
	Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"
X-Stat-Signature: z4hbctz3fryt8ubfc4gc8iuz3aeom8ro
X-Rspamd-Queue-Id: 4DA4F80008
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782177348-409790
X-HE-Meta: U2FsdGVkX1/4h+6h7oFbcPn9k5gYrWr/WCwbDtpsJJGvMK+70wjOhYWQSZQb7Dfguh/APtftciP4uCKD5cNTLfsdP+hEVl1mysGUUlAqKqWgqDdR6LOaaoxDFhSmLjK/gZjm+QjHWcLdiNJmE0aXy4xhDRhVR/CqiBF6Gx7UCLrujkhGJKjeD30k1XJMFRFacArcQmxTAqjdz075S6NrDy7nQjoBqhI20xOYu1NMVw2hmH0iHEAR4wtaWKBIIb4Jzp7DwpS6du9RYQ1Y7RWX+gYoJ19LkO0lV+vxurDpgX6wINVDaFQHyYael+pwEgaEMQe+cgBB33H8Raz8Lmwfkw+7zrewzfNyYzMvVCY6lN4ud0ZaeFNUUjA4ZNuu9v22zBYgCd87DbG3s9qi+3ALD/enyApt/gnYcg6UTwg3ZFsf0qkmT3HZUhiWIOSSbh2taDZtVe3jAsosXDfQMofBoqSv3cgqJ+FhSaRsN9cExcp3NxBuSBlDiSeTlVXskMFsFJcx/AYYK2g1gAA17YlN+hKyDcO/cBES+Xz89fOrsrPZ1rv29XXrXOqfOpssCrrSXw3V2vFijJ9a8L4vKJWzZgo+4ZEB2lVfPa9TxNewH4mqCXLHJxRnO1L0SzOtlaY0dC6PRZk3PdJ0K9En9nlHKZXb99n/meNlnody2yb6LOL29AAzcspFfS9DD4TFlC6WPwxzdbr+hurXjq2EW1CiLQ33EG/5SZnUGuDN0E+aFzpMKP1bVojUjj8xN4o3cXelHvQAHD/I1YrirHjhL4tXT4cdEBjXOZmwhYtLAQEMA7jIHLpkywx38qaRELkj9o+tiLkfboaJp2ukiYdp42bL2qEKdpKXrFf8q2Mwfjf9HznXp4dvji3wRnBndZDlsh0k3yB/BtRlNWQZvGs54c4qiCEsDYzmkD+RkNNyJpcihBsGj3OoVHecOVzqYt3ofGnz6X5d75vGgo3jNNp/L9I
 qul4aeul
 KS5pii9j/xBA82TVvjnrwq1vdX1poDOdk/oZIYcP+POPPax9jh9IPF7qwotbN/WvyC8OWVPLiZRKIHvHbBTjXIh99MPtqVBa79XeaRZtavJWSKBRdGy5IxEKGgZcEsXWr1BUN+ewqc1oj36ZVgIrT/Pp5CC6EiTUSW0+ubHxqm2eqSxqIsp2AMvJmOM7LAXCxThIe5OHsVYCgHg9KplHD0Mi/O1G/YDkIczSwSFXDH52KtQ4bEuF5RbKNmGRHObHxbHw3zVwcc9W43+pmPQ5+iKqm4ymfl7NeMMXeGtUzCRcVz2co+UxetO0jMrgg4HOzunJPDepVOw0gQH/cojn5Ck8hv0yl1neAYerR4OBqG+IXv/Aeb0vAfv6Tt2x+lFrI5SvsXaKnfvCka5iaqjdhYyDj1oq9Oflk2plx6H8/GiqyPcawU5gNz20VA2nV1AJYDl2vnrL4U9cHhKDATdZsO7fVsKEfO+tqqp0urrBCqG2RyMxl6yKwzLcOxTJPg1cpPE4I+z6AveW3cU5eiq3N7oSAcY1Fr/v0WUgohAKkofcqBIOMB1OwilHktZ2ZYO6VMt7y9u+f31WW6mu6b6Iw8xC0u+JOFW5lKtp0RCT+sP28VOaKczSWYH8x1IIMhvZbJH5R99Nq8Mj+V9AXe6/mifHcEw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 19, 2026, Fuad Tabba wrote:
> On Fri, 19 Jun 2026 at 01:31, Ackerley Tng via B4 Relay
> <devnull+ackerleytng.google.com@kernel.org> wrote:
> >
> > From: Ackerley Tng <ackerleytng@google.com>
> >
> > When memory in guest_memfd is converted from private to shared, the
> > platform-specific state associated with the guest-private pages must be
> > invalidated or cleaned up.
> >
> > Iterate over the folios in the affected range and call the
> > kvm_arch_gmem_invalidate() hook for each PFN range. This allows
> > architectures to perform necessary teardown, such as updating hardware
> > metadata or encryption states, before the pages are transitioned to the
> > shared state.
> >
> > Invoke this helper after indicating to KVM's mmu code that an invalidation
> > is in progress to stop in-flight page faults from succeeding.
> >
> > Reviewed-by: Fuad Tabba <tabba@google.com>
> > Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> 
> Coming back to this after working through the arm64/pKVM side. My
> Reviewed-by here is from the previous round and the patch hasn't
> changed, but I missed an implication for arm64.
> 
> kvm_arch_gmem_invalidate() is now called from two paths with the same
> (start, end) signature: folio teardown (kvm_gmem_free_folio) and
> private->shared conversion (here). For SNP/TDX that's fine, conversion is
> destructive anyway. For pKVM the two need opposite content semantics:
> conversion must preserve the page in place (same physical page, the point
> of in-place conversion without encryption), while teardown must scrub it
> before returning it to the host.
>
> The hook gets only a pfn range with no indication of which caller it's
> serving, so arm64 can't give the two paths the behaviour they need. It
> would help to signal intent on the conversion path: a reason/flag, a
> separate hook, or not routing non-destructive conversion through the
> teardown hook.
> 
> arm64 isn't here yet, so this isn't urgent, but the hook is gaining a
> second caller now, and it's cheaper to leave room for the distinction
> than to change a generic contract other arches depend on later.

Crud.  It may not be urgent for arm64, but it's urgent for other reasons that
I "can't" describe in detail at the moment, and even if that weren't the case, I
think we should clean things up now.  More below.

> >  virt/kvm/guest_memfd.c | 41 +++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 41 insertions(+)
> >
> > diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> > index 433f79047b9d1..3c94442bc8131 100644
> > --- a/virt/kvm/guest_memfd.c
> > +++ b/virt/kvm/guest_memfd.c
> > @@ -607,6 +607,42 @@ static bool kvm_gmem_is_safe_for_conversion(struct inode *inode, pgoff_t start,
> >         return safe;
> >  }
> >
> > +#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_INVALIDATE
> > +static void kvm_gmem_invalidate(struct inode *inode, pgoff_t start, pgoff_t end)

Not your fault, but kvm_arch_gmem_invalidate() is badly misnamed.  It's not
"invalidating" anything, it's much more of a "free" callback, as SNP uses it to
put physical pages back into a shared state when a maybe-private folio is freed.

As Fuad points out, (ab)using that hook for the private=>shared conversion case
"works", but not broadly.  And it makes the bad name worse, because it's called
from code that _is_ doing true invalidations.  For pKVM, it may not even need to
do anything invalidation-like.

To avoid a conflict with patches that are going to have priority over this series,
to set the stage for arm64 support, and to avoid avoid bleeding vendor details
into guest_memfd, as if they are core guest_memfd behavior (only SNP needs the
"invalidation" on this specific transition), I think we should add an arch hook
to do conversions straightaway.

Unless there's a clever option I'm missing, it'll mean adding yet another
HAVE_KVM_ARCH_GMEM_XXX flag?  Hmm, especially because IIUC, arm64/pKVM doesn't
need a callback for this case, only the free_folio case.

> > +{
> > +       struct folio_batch fbatch;
> > +       pgoff_t next = start;
> > +       int i;
> > +
> > +       folio_batch_init(&fbatch);
> > +       while (filemap_get_folios(inode->i_mapping, &next, end - 1, &fbatch)) {
> > +               for (i = 0; i < folio_batch_count(&fbatch); ++i) {
> > +                       struct folio *folio = fbatch.folios[i];
> > +                       pgoff_t start_index, end_index;
> > +                       kvm_pfn_t start_pfn, end_pfn;
> > +
> > +                       start_index = max(start, folio->index);
> > +                       end_index = min(end, folio_next_index(folio));
> > +                       /*
> > +                        * end_index is either in folio or points to
> > +                        * the first page of the next folio. Hence,
> > +                        * all pages in range [start_index, end_index)
> > +                        * are contiguous.
> > +                        */
> > +                       start_pfn = folio_file_pfn(folio, start_index);
> > +                       end_pfn = start_pfn + end_index - start_index;
> > +
> > +                       kvm_arch_gmem_invalidate(start_pfn, end_pfn);
> > +               }
> > +
> > +               folio_batch_release(&fbatch);
> > +               cond_resched();
> > +       }
> > +}
> > +#else
> > +static void kvm_gmem_invalidate(struct inode *inode, pgoff_t start, pgoff_t end) {}
> > +#endif
> > +
> >  static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
> >                                      size_t nr_pages, uint64_t attrs,
> >                                      pgoff_t *err_index)
> > @@ -647,7 +683,12 @@ static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
> >          */
> >
> >         kvm_gmem_invalidate_start(inode, start, end);
> > +
> > +       if (!to_private)
> > +               kvm_gmem_invalidate(inode, start, end);

E.g. instead make this something like this?

	kvm_gmem_set_pfn_attributes(...)

Hrm, though that wastes folio lookups in the to_private case.  So maybe just this,
assuming pKVM doesn't need to take additional action on conversions?

	if (!to_private)
		kvm_gmem_make_shared(...)

Actually, if we do that, then we don't need a separate arch hook, just a separate
config.  It'll still bleed SNP details into guest_memfd, but it'll at least be
done in a way that's more explicitly arch specific (and it's no different than
what we already do for PREPARE...).

E.g. this?  There will still be a looming rename conflict, but that's easy enough
to handle.

diff --git virt/kvm/guest_memfd.c virt/kvm/guest_memfd.c
index 9ce5be7843f2..8aead0abd788 100644
--- virt/kvm/guest_memfd.c
+++ virt/kvm/guest_memfd.c
@@ -648,8 +648,8 @@ static bool kvm_gmem_is_safe_for_conversion(struct inode *inode, pgoff_t start,
        return safe;
 }
 
-#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_INVALIDATE
-static void kvm_gmem_invalidate(struct inode *inode, pgoff_t start, pgoff_t end)
+#ifdef CONFIG_KVM_ARCH_GMEM_FREE_ON_SHARED_CONVERSION
+static void kvm_gmem_make_shared(struct inode *inode, pgoff_t start, pgoff_t end)
 {
        struct folio_batch fbatch;
        pgoff_t next = start;
@@ -681,7 +681,7 @@ static void kvm_gmem_invalidate(struct inode *inode, pgoff_t start, pgoff_t end)
        }
 }
 #else
-static void kvm_gmem_invalidate(struct inode *inode, pgoff_t start, pgoff_t end) {}
+static void kvm_gmem_make_shared(struct inode *inode, pgoff_t start, pgoff_t end) { }
 #endif
 
 static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
@@ -729,7 +729,7 @@ static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
        kvm_gmem_invalidate_start(inode, start, end);
 
        if (!to_private)
-               kvm_gmem_invalidate(inode, start, end);
+               kvm_gmem_make_shared(inode, start, end);
 
        mas_store_prealloc(&mas, xa_mk_value(attrs));

