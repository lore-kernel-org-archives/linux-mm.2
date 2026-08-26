Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F029C61DBD
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 13:53:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAFA66B008C; Wed, 26 Aug 2026 09:53:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A397A6B0092; Wed, 26 Aug 2026 09:53:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B3496B0095; Wed, 26 Aug 2026 09:53:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5F7C06B008C
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:53:14 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E5D1512010C
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 13:53:13 +0000 (UTC)
X-FDA: 85143562266.25.FF9DD2D
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3E97A10000B
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 13:53:12 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=lEpwe53u;
	spf=pass (imf05.hostedemail.com: domain of 3xO-OagYKCDspbXkgZdlldib.Zljifkru-jjhsXZh.lod@flex--seanjc.bounces.google.com designates 209.85.214.200 as permitted sender) smtp.mailfrom=3xO-OagYKCDspbXkgZdlldib.Zljifkru-jjhsXZh.lod@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787752392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=njsQrhr1Rw86G3MMqhXpdm0dYelYnqk43kJ0tkWzOHc=;
	b=iKpKdnhN/n4eTob4v5bRD3zh8k54XHqlE5dUctnecoH8FiIPQHL3KSTzW7Bg1WgoeQmqa2
	ZfpyFUuP9jOkRlaJdZ8I7KCFyaLEJ2Vn+y3Pkq+sao1hiEBS1XwAMtoweBWhiBQWo+5qmJ
	EcUAxdggHS1Q/3Cg7UJGJib7zFQoIYs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787752392;
	b=FDOlnGh21fxdaph1fiYp3IDqVefK/DXhEsFponE46OOGequeoyAITYrR/dIStWcea5LcYu
	kGUfykM4wYV8zABytwvtsNv3LFs2RfSTv/TuO2Dngk9KE6iSiwHi+DnTfo0ieCvXHQyRKB
	6QAWjmEZB1onObL8fHxgZ3kfMQlDc6w=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=lEpwe53u;
	spf=pass (imf05.hostedemail.com: domain of 3xO-OagYKCDspbXkgZdlldib.Zljifkru-jjhsXZh.lod@flex--seanjc.bounces.google.com designates 209.85.214.200 as permitted sender) smtp.mailfrom=3xO-OagYKCDspbXkgZdlldib.Zljifkru-jjhsXZh.lod@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2d6f80c76e6so14145185ad.3
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 06:53:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787752391; x=1788357191; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=njsQrhr1Rw86G3MMqhXpdm0dYelYnqk43kJ0tkWzOHc=;
        b=lEpwe53uzh7WoeVtlr+HQBxGVmvZ15S84vCvoF6Qd+zO+k8W1Pdinn66Z3bV3zqi50
         Pibg11iP8xNOokqJW0P5ZmrQdc8Sc3+OSfabz1kkGzag175+Gz6UjYJFqLTJ6hQp+gPQ
         MYCmc+2WSBbkl9emSlOrhIHgkt790zxLF2Mx/yup4Dl+4xbh294Y85I/Jen4bB6RrMDO
         iwVN55C6cxfLRkqEwiUCw2+yG3xWYXk7gX7s/bP1uqAyr8O7DzYGMs90fBKGbr1ZGTCq
         iduHrd+DTfIFfR8ZMi8bjqjTl5dM5ZXIYIPK4wgcUupDvp78XBK6sl22elzHPpc1fMzd
         +Txg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787752391; x=1788357191;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=njsQrhr1Rw86G3MMqhXpdm0dYelYnqk43kJ0tkWzOHc=;
        b=J2O38RTVNrbuS6ypLsSiOpud9mkGoufGjFAcAwNdTA+FWItPOBoUu0CHlMIpBJ+DiG
         eiGzO3neYRQlDiWYDod1Zz6rFyh2QRtVGFIBG6bxbG+ReXy5A7yDA7TddGCMh90RpUaP
         YrkOk0ow6RwAXDO7iabzz2nm4rxEguRiFjRc9bmA2krNYdlFGF7pRMteg0xMb86UxcwW
         UIfi6DrYAyb4x0IZLl58kdEKz5UdjM+Af67GdqVGHYLfJpczUzssrVihz1us6BxFh+f6
         6bWQ3QmE0eXuMjtxKMhIO04kwH4kxLwgYj4R9WWh2CJIiab0bMBRtdNidldsMCi2vJx9
         CFiw==
X-Forwarded-Encrypted: i=1; AHgh+RrMBIsSlBG0gKWVEnd37lGNZcyEreN/yioHcv9QNzf1QVlS7CWCaUiJclx59VA8xUHUFMEpd+c3CQ==@kvack.org
X-Gm-Message-State: AFuF++m4vO3CQVsYmzLmTiRh6Gih1/6S5tK46Tt61KhVXuHgsZy1t9/8
	R3UrCNMeQFNyuS1T17CZWDFCLSXm0UF2Bt+7uol8hL7EYyVob5lVIFrjdTyMCLDN+eWGejNhQ2s
	IX/bG1g==
X-Received: from plnn1.prod.google.com ([2002:a17:902:d0c1:b0:2c8:1ded:d061])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:c40a:b0:2d7:1bfd:b240
 with SMTP id d9443c01a7336-2d71bfdb766mr27401015ad.4.1787752388141; Wed, 26
 Aug 2026 06:53:08 -0700 (PDT)
Date: Wed, 26 Aug 2026 06:53:07 -0700
In-Reply-To: <CAEvNRgFXJbV78ktsg=b4srFp1OFjtQWQGuNPjr_MmWD-wOvjgw@mail.gmail.com>
Mime-Version: 1.0
References: <20260807-gmem-inplace-conversion-v10-9-2fc18ee6d3ba@google.com>
 <13ca60c6-e154-4397-8092-09f861e90fe0@kernel.org> <cbf5f7ca-a960-4fb8-a760-2d2794eb6864@arm.com>
 <CAEvNRgGOyQHnF_b8dk8E0d7_=CcwXtYUdU3ko7Qbep+_O7UC0Q@mail.gmail.com>
 <aoZZMQ3Uc8yQWPNA@google.com> <7eba513d-cdae-4832-abac-038dcdd88517@intel.com>
 <meww2a2uf3yeevsfpicyrlg3hch2x4bsdqv2lsv3vfjxg4qzes@co5eogmhkxrk>
 <ao3lOu8-wpGTs2wd@google.com> <ba8d0441-b52f-4357-b2e7-1e352aa385a2@intel.com>
 <CAEvNRgFXJbV78ktsg=b4srFp1OFjtQWQGuNPjr_MmWD-wOvjgw@mail.gmail.com>
Message-ID: <ao7vwx3nMqCjCHZU@google.com>
Subject: Re: [PATCH v10 09/41] KVM: guest_memfd: Filter both shared and
 private when invalidating
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, Michael Roth <michael.roth@amd.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, "David Hildenbrand (Arm)" <david@kernel.org>, aik@amd.com, 
	andrew.jones@linux.dev, binbin.wu@linux.intel.com, brauner@kernel.org, 
	chao.p.peng@linux.intel.com, jmattson@google.com, jthoughton@google.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, tabba@google.com, willy@infradead.org, 
	wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
	pratyush@kernel.org, aneesh.kumar@kernel.org, liam@infradead.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
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
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3E97A10000B
X-Stat-Signature: 3xodzfk3xsr1nuswdy1ogw8dbnunsrpx
X-HE-Tag: 1787752392-452058
X-HE-Meta: U2FsdGVkX1+16PHy+iYdYaa36UIL+IeBTUtL8ETR3rzSiqAH55cItgSfDdG3csVgyU6BWj88yfaM51iLouH6wbwJZG8wnS65X1KWGnc/DRI+eifz6Xmkm8HLvepSIZ7IXWSKF2RxXHlsUFns4i33I3bRop92M+wusQDL1iA/L9CYq+pqy91U/y0mrZf6MrlONpockfUJRBzxWiYjIY1cr82JMP/y8NmKMD3SkjS7zqG+3+hRooMTOWfbP4Wb480J/voK9t0NNHOGy2i6tJ3Qml5SOHxwUVCXi9iIts8LQ6vn+TayobNcOwneNUB1rkPOPM3dMd7QPHortMHtR3iE4k17+w4to75auatpCIMI5FEPDO1oOUWaC8Xlsm4R0IQf5QsSXsumVC6q6lv/0+xUoyoFGEYY60ZRLgKWnRKJZkPmRVG4+zaidHesy5xm3ZDJtp3PP8pgSeecv4sjRWdPkRmW+PWuRlKkXdIMyDRwSgUWuDbmpm/JFnFvDsKZw3lvA/FxwNofXb9E6mbnD3aJGef3rNIm89GRY4GcDLsRHzaPrNIBsU8msdkjL4ZrmABreVloOyDmEBkRm0LsTddAw2516gKmDZgB/FqDcKCl3qFbYCL5229QL6e75g0mKk67d6oEszuEbzxMBpWVfqolirv2Hw0jwtBlE9z5W1XJBhW4ZpDu8OxZpGZPmsqXVmuj0O4UkaMLVdZH5Ms19ZvOVMUi/WNy8orgD0/BPaW3DPFo3Y2JIGsY2AefrEkrixbabeYWOBNL4Nu1bwLG0RAhALzMLYzk8w0RAgcKyrbdmnr9ShiJbm/xAW8tAMq4fYLmJ671NgOicDD22ppvvTCmWBxuuYkbHL1XB6h3zeHymJtODpzGBVVm/cXqegneY3ldfKk/nYyHTayN/5IZx/r0yqsmv4NC7Pxrih6O8aZ2FzO9F99CG894go817sjIks3WesLoMtvzLHZB920oyEz
 fYKmWchH
 KFh9T8/w0OaFyRWJBem9hM0gURuse3dJ+NkxHes5zT0dLAgv15GPa14sh1vQFb6aR+XjuwWwAnitw5xbAthDn30BUxDjh5tOboxkAde0gnJClK/pK9oExocI3/s7XMSntSZUP7h/p91kWwRuDa7nFLJjglYIGgS+0XbzWrXwJlFgTDgsBx7Ujvh++3ec26SuxKIux03LLt6E+4dZU6aYXwXYejeatVZUeWIIyz9difSSNrap3PLFXzFmxrn0ZJryE2CG/M4tgS2d7C+q8AouTMOgK0L17fksZzGY5fz9i+7SOMOwggmn4LKXlzZo1C4wuPRWJBijPkV7T1bRCpgzeb2F2yEKI8VIfub6OQ2Ed8vnobBc6ck4Syn5vty6xKItO6hm0EfEhtcCRqGhOx9MhAQ0p+W1iK0sPkJTKbSt47PjJsogCXg6MyPyB6ZjbHV36jSfbZ7CI0F3ORz7e7TxxTbhOFMmz/X979IkPNqIxpU1vnd2ApEg87luf87lNfLueeEHe8JI+K1E6gsf0LYGTZDokzKNoBIA2yFQtEVvH4ZmLcZoi8oRZJsAd4OI/cda3D2vF+f2kqCQnAzcbunI+QbkbjRStEjTREUEDx2OSxh83SdloQKgtgdbvnDMEHBHIHmBEOZ06s11Ayx58zPpqBCujpV8PnSLsiGhKiUblG6MXHElTgH0Kr9J30AmniEq3hBCu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 26, 2026, Ackerley Tng wrote:
> Xiaoyao Li <xiaoyao.li@intel.com> writes:
> 
> > On 8/26/2026 2:55 AM, Sean Christopherson wrote:
> >> On Tue, Aug 25, 2026, Michael Roth wrote:
> >>> On Wed, Aug 26, 2026 at 12:13:47AM +0800, Xiaoyao Li wrote:
> >>>> On 8/20/2026 9:32 AM, Sean Christopherson wrote:
> >>>>> And vice versa, a PUNCH_HOLE on a SHARED gmem (if userspace is
> >>>>> using an INIT_SHARED gmem for the shared branch of a memslot) could invalidate the
> >>>>> PRIVATE mappings (of a different gmem instance).
> >>>>
> >>>> I'm wondering now how this could happen.
> >>>>
> >>>> the requirement for PUNCH_HOLE on gmem to trigger mapping invalidation is
> >>>> the gmem is bound with the memslot. But how can a memslot bound with two
> >>>> gmem instances?
> >>>
> >>> I think this is for when userspace uses an mmap'able guest_memfd instance
> >>> to handle shared memory, and a 'normal' guest_memfd instance for private
> >>> memory. Each instance is bound to the same memslot/GPA range, and
> >>> KVM_SET_MEMORY_ATTRIBUTES handles switching between the 2.
> >
> > What I didn't figure out is exactly how the two gmem instances are bound
> > to the same memslot.
> >
> > The case I can imagine is
> >
> > 1. create gmem1 with GUEST_MEMFD_FLAG_MMAP and
> > GUEST_MEMFD_FLAG_INIT_SHARED, and get fd1. mmap the returned fd1 to get
> > a hva.
> >
> > 2. create gmem2 to get a fd2.
> >
> > 3. call KVM_SET_USER_MEMORY_REGION2 with KVM_MEM_GUEST_MEMFD flag. Pass
> > the @hva from 1) to 'userspace_addr' field and pass the gmem fd2 to
> > 'guest_memfd' field.
> >
> > However, with this case, only gmem2 is bound to the memslot while gmem1
> > is not. Following PUNCH_HOLE on gmem1 doesn't invalidate any mappings
> > because the f->bindings of it is empty.
> >
> > Do I miss anything?

Oh, I misread your question.  You were specifically asking about a PUNCH_HOLE in
a SHARED gmem instance over-invalidating PRIVATE mappings.  You're right, that
wouldn't happen because the invalidations would come in via mmu_notifiers, not
from KVM.

> I think Xiaoyao is right about this, the "vice versa" part is wrong,

Ya.

> Is this just a case of user error? That with gmem_in_place_conversion,
> userspace should not use userspace_addr from something other than the
> gmem for the same memslot?

Yes.  It's not just invalidations that will go sideways, KVM accesses to guest
memory won't hit the same physical page as actual guest accesses.

Huh.  But that isn't strictly guaranteed, because userspace could bind to a
memslot that isn't configured with GUEST_MEMFD_FLAG_MMAP, in which case SHARED
faults will go through the VMA, not kvm_mmu_faultin_pfn_gmem().  It's a bit early
in the morning, but off the top of my head, I can't think of any reason we need
to support such a setup.  If userspace really, really wants to use a separate
mapping, they could DELETE+CREATE an equivalent memslot without the guest_memfd
file descriptor.

So I think we should do this?

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 9c2d52bdf25e..86f53e53a136 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -1013,7 +1013,7 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
 	 */
 	WRITE_ONCE(slot->gmem.file, file);
 	slot->gmem.pgoff = start;
-	if (kvm_gmem_supports_mmap(inode))
+	if (gmem_in_place_conversion || kvm_gmem_supports_mmap(inode))
 		slot->flags |= KVM_MEMSLOT_GMEM_ONLY;
 
 	xa_store_range(&f->bindings, start, end - 1, slot, GFP_KERNEL);

Regardless, the key aspect of all this is that in-place conversion is brand new
functionality, so we don't have to ensure backwards compatibility.

