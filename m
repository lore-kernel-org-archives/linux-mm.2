Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05E35CD5BAC
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 12:59:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C54E6B0088; Thu, 21 May 2026 08:59:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04F4E6B008A; Thu, 21 May 2026 08:59:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E80096B008C; Thu, 21 May 2026 08:59:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D7D606B0088
	for <linux-mm@kvack.org>; Thu, 21 May 2026 08:59:11 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 80A7F405E0
	for <linux-mm@kvack.org>; Thu, 21 May 2026 12:59:11 +0000 (UTC)
X-FDA: 84791432502.04.97D6C9F
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf29.hostedemail.com (Postfix) with ESMTP id B4367120008
	for <linux-mm@kvack.org>; Thu, 21 May 2026 12:59:09 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=VeJk2wFA;
	spf=pass (imf29.hostedemail.com: domain of 3mwEPagYKCDIgSObXQUccUZS.QcaZWbil-aaYjOQY.cfU@flex--seanjc.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3mwEPagYKCDIgSObXQUccUZS.QcaZWbil-aaYjOQY.cfU@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779368349;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6A/WkImBLvFQtcCerZuF0HISLRf2xh2w4ZLFxLCX4+s=;
	b=7HXCIhfNVZEJ9SG3joNXvJ3oQDQ/EEOuvUaMLR2Z9x0oNt1ZS3qT8hrDGNeRgQwVRI5TkA
	leNDKZIL41XWBjHmFmQhupeRg6nPSPPfKEN1jrtQ3aygDs5GLpQ3b7vjDoRfVJFQE/1dAp
	36Gkg7hLmwDqBBt0G0ASUdfnPknk/Jk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779368349; a=rsa-sha256;
	cv=none;
	b=WbOuDNm1UuX06i/r1HIIFnOPxCNG5k0IbCAsMMAXOL/EXskdH9NN2SwSAYGz2QRs1FDwpf
	Krv0rus+Pzxe0VLfJottGqySrDUnBg615hiJxC/aFWm+eIGqLKLKjqOZG97jAWhaXh3r8e
	uKbiJPy2aCaV+3ridkAHUY/VYdMJi+U=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=VeJk2wFA;
	spf=pass (imf29.hostedemail.com: domain of 3mwEPagYKCDIgSObXQUccUZS.QcaZWbil-aaYjOQY.cfU@flex--seanjc.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3mwEPagYKCDIgSObXQUccUZS.QcaZWbil-aaYjOQY.cfU@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3662990c03fso5123339a91.0
        for <linux-mm@kvack.org>; Thu, 21 May 2026 05:59:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779368348; x=1779973148; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6A/WkImBLvFQtcCerZuF0HISLRf2xh2w4ZLFxLCX4+s=;
        b=VeJk2wFApv0M31qBOMLkYNiINbDHaGZ92eKCu5Y+b4LokQYZlMELTjVBgDQGDuwKM8
         9rb95K4drE+EmrZ9zQPneikwKOKo3f8HZz9fQpbggnG0+teHBl8cCeO9xeFabw+LuicL
         2PtDRRIsURvx791KMziPgVl1VbZo8g5Q7kyspFesfGpqcDnQd4fGbzE22rHNOSQuUq1q
         6tLupK3+nPj0HTOmewAGfQ08qhAozkGLGZWoNLl5X77EJnUruZY/DGmCSh2p3c0D4oNA
         lculqrny6in8s8fbl+kYZjpxD+QnQRiEcXtBZ353beMpdRCqAJYvlBjSU9jtmCH9f6Xx
         tg2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779368348; x=1779973148;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6A/WkImBLvFQtcCerZuF0HISLRf2xh2w4ZLFxLCX4+s=;
        b=l6fZKr7kH68Zgt4cbtMen47GHB1siD5JDH5aCy6YwRElt7jYo4h7NdsFTnHFz1b4j3
         x9xwU4aLQnCyw4DpnT1e7yMffC7huNqehNUhDAfr18TymAi5LsbwQaMlItYMjy8BrQfi
         sEB0Hh66Hyhy4yRXLdrR70oUTG/s8v1jHM7tN80Fcv0APUYaTI7vtrYXdcD2Fd4APzt9
         /IiPP9LpPW1v2tWV3KQmoI2Khg4JM0aF5zTtUYnd1zrvnf/Yemx3czTb8VMUasp42QU3
         GQ0h28/rTE4bkCnYeF03CJBAF5Hi7jwUWdQXi1AmNXPK0q/NBI9hON8YriyDaoxmr4T3
         3dOw==
X-Forwarded-Encrypted: i=1; AFNElJ/uViuXLLKpPDS5b7RP2oMS+UM3KdCeWXlQJWmpHdT1aTmt7+XyBUEtlP2RXJzbXqHITv8PgCGfPA==@kvack.org
X-Gm-Message-State: AOJu0YwsMl2Z9tltWtib0TOwAtRV82KPQTyxLC9Y3ChFJJpcZPOzxkyR
	iJVvTvK6PKWd2mveSQkTW/1qClknu+JddEqtgudPYXqF4DSBErnZ+HHwIkncHtO7vO575wUJDjE
	V2vmQKw==
X-Received: from plbl6.prod.google.com ([2002:a17:902:eb06:b0:2bd:7dc:3354])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e74f:b0:2b0:4f16:22f7
 with SMTP id d9443c01a7336-2bea229c3e5mr27900055ad.16.1779368347626; Thu, 21
 May 2026 05:59:07 -0700 (PDT)
Date: Thu, 21 May 2026 05:59:06 -0700
In-Reply-To: <CA+EHjTxcadguOfOo7RpJVtAzcY5JAFZTbrAT_wcN6akMi8gCUg@mail.gmail.com>
Mime-Version: 1.0
References: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com>
 <20260507-gmem-inplace-conversion-v6-16-91ab5a8b19a4@google.com> <CA+EHjTxcadguOfOo7RpJVtAzcY5JAFZTbrAT_wcN6akMi8gCUg@mail.gmail.com>
Message-ID: <ag8BmtzxTlcuA_zy@google.com>
Subject: Re: [PATCH v6 16/43] KVM: guest_memfd: Use actual size for
 invalidation in kvm_gmem_release()
From: Sean Christopherson <seanjc@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: ackerleytng@google.com, aik@amd.com, andrew.jones@linux.dev, 
	binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com, 
	david@kernel.org, ira.weiny@intel.com, jmattson@google.com, 
	jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org, 
	pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com, 
	rientjes@google.com, shivankg@amd.com, steven.price@arm.com, 
	willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
	forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
	aneesh.kumar@kernel.org, liam@infradead.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-coco@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B4367120008
X-Rspam-User: 
X-Stat-Signature: z1gotddpo51u5md179foon81oxn6fzqq
X-HE-Tag: 1779368349-454049
X-HE-Meta: U2FsdGVkX19zYCxvEPz2LPa5Ew5BiTEM5WWmSWj2dJFA07kgSbQ0iAKnUVUY3iDzeuAXuA+/BoAOPcHVSw2QiaiAHB7EhePgxUZ9rGHtWxo5KhQ9GS/tjJJdKFxQl1hvnAzx+V59TLcWLn6/PolrO7//fVgcpEOeWL8KnbSJRtIoDYpeZGta/GE9ouLKwzSR8EG68joaWa0L1Kqwx6YJALq/cnu1oD6tx80FCs7e4++zyVvHO6YPo+hHRjwFO7f+C0BXoDEFmLmXTgh51hCN8mhfB3xHTCKIhmz8HUNlUXeMRo7UNMg2JRNRw3RTCG12jdSrm9ueJ7ldFfUZ3NrZ2bYl4Kca/z54RS6mYHabwFtdg0rsBSHPjKKmmBKnYJz9mnslPniw4TrplJKQlfViVU8tw8BAKzvrTsKhULIpJ2qgva8PR1RzJotPdD1GUXdMvOg25xYumdlFEJZUeyoOZ/uFBAOA8nPucjOyWwkYc6ehTgjHVJZTHCgGXYEqfSpET8Y6HdnNEgqftU3PS8VFmzrwPH+Yz7Qr8GI3tNdI75lMuBleX09pVvg6yX09RBXyPFKHdrIcde4D8AvvoNt/jQ5xA4qKUGW7q+OnS+XDPpSMLm99BfMdsC+XW8k0RXoryrbOWCMqIz21XgLd/4ORXtVIwtkWnD5aNLaYTI+H0Gtfvc1GZ8sHizOIKdDZJL65WbeGnIa79bcsiKQsha+uFnS9Y10ucPoAUsPDRezOyYNJT46DC4kwBVAB2hUKe4KdY9Y1AaXJYWhp38cUrlBKKe7UBcZvC8r/zLrCVDbXAPLNd3fhpbxtIPpJDDp/DxvpSrSmh3eQm4/iYGlLYaiUChAC4wJ3C2/73uzKihzb5JwN+GUcs4/2qPfmh1EWTpQaunM8AAa6wPewFaorPUzMqyjKZnw4kOVmPWwHipcNAgYLisiakNEhpG/qmBlXLcT83MiUCxVqyFU82Eohu+R
 1sJ+aM7s
 NUYqkK5KuIhbZZ1/AYPAa7thDgejug1WYlaKDUy9eAOskvMmObWfzwqwenrk01ESgjEcm9g4Hgcjb03DyEOvW5yZc8VRHIEgxXSBGezrZcrxb67Jx9TUVJPTFR/l+egRRxATZwb0v+fSTWL2/oS4wyz1qjqVy5W6kCEgMmKHpzt5LE/HhiWy74Kgb/7csS67PxOpysoUBnFD1Wku+ni5fsLQZ2zutYXW0ULZwQyk3bFM++qZKQwBsH+seCyEsbbx4HmRKAXhnentBuAva0PvOlNzk+cIYHwDPp1t43ixMTTuQb8g+RZOQOBWpMEKxiLfXGChax31/bPkM6aDUBUeF4PjhRc+Bxsr3B/GJmT43fs2NlKo1abkjH6z78WRNCG+PotTZsUtfc/2MzMcrY7Bv+MKyAQoy+ILlPvSvw5F7v43MjW7xArlTG/NsQSCK76wsyKR3dBvewoxWACUjLF3xuu9UzJyG16dhEBeQr2j1lWjqwmtlj1n+dNMgvVz8ZcvtQowYXZHXZbvZoX52L8wuC5VzhQs/68W5EDAksRg96yI1ae44hmPhXu8agXQTVknRkxNn8sazAfdLMw3XIeTy6l4MupEcP2gWOMhs/3i8ooQ1WAkGwrMqH+WPbi9nWqVJJRzCtvKWMElEAy0Gp9YaMimcgdN/0mDOAxSdhy5woo710QcB9w8KXXJOeenwf2HLC2SBD992OVNvNThE6qrb9PjwWZOSlwqi0uJ4ll9T+bVIy1TPCNqiWdQWyLKIIFLdL4nB+1ol2S0zvNHhm7oB89X/TW/aO78JLNNf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 21, 2026, Fuad Tabba wrote:
> Hi Ackerley,
> 
> On Thu, 7 May 2026 at 21:22, Ackerley Tng via B4 Relay
> <devnull+ackerleytng.google.com@kernel.org> wrote:
> >
> > From: Ackerley Tng <ackerleytng@google.com>
> >
> > __kvm_gmem_invalidate_begin() and __kvm_gmem_invalidate_end() actually do
> > not specially handle -1ul. -1ul is used as a huge number, which legal
> > indices do not exceed, and hence the invalidation works as expected.
> >
> > Since a later patch is going to make use of the exact range, calculate the
> > size of the guest_memfd inode and use it as the end range for invalidating
> > SPTEs.
> >
> > Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> 
> Want to look at what Sashiko has to say? Seems to be a real issue:
> 
> https://sashiko.dev/#/patchset/20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4%40google.com?part=16
> 
> If I understand correctly, the fix should simple: use
> check_add_overflow() to validate the offset and size parameters in
> kvm_gmem_bind()
> 
>    int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
>              unsigned int fd, loff_t offset)
>    {
>        loff_t size = slot->npages << PAGE_SHIFT;
>    +    loff_t end;
>        unsigned long start, end_index;
>        struct gmem_file *f;
> ...
>    -    if (offset < 0 || !PAGE_ALIGNED(offset) ||
>    -        offset + size > i_size_read(inode))
>    +    if (offset < 0 || !PAGE_ALIGNED(offset) ||
>    +        check_add_overflow(offset, size, &end) ||

Eww, TIL I'm not a fan of check_add_overflow().  Burying an out-param in an
if-statement is nasty.

>    +        end > i_size_read(inode))

This is all rather silly.  @offset and and @slot->npages are fundamentally
unsigned values.   I don't see any reason to convert them to signed values, only
to convert them *back* to unsigned values (when stored in start/end, because xarrays
operate on "unsigned long" indices).

i_size_read() obviously has to return a positive value, so can't we just do this?

diff --git virt/kvm/guest_memfd.c virt/kvm/guest_memfd.c
index a35a55571a2d..9c6dbb54e800 100644
--- virt/kvm/guest_memfd.c
+++ virt/kvm/guest_memfd.c
@@ -640,9 +640,9 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
 }
 
 int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
-                 unsigned int fd, loff_t offset)
+                 unsigned int fd, u64 offset)
 {
-       loff_t size = slot->npages << PAGE_SHIFT;
+       u64 size = slot->npages << PAGE_SHIFT;
        unsigned long start, end;
        struct gmem_file *f;
        struct inode *inode;
@@ -664,8 +664,7 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
 
        inode = file_inode(file);
 
-       if (offset < 0 || !PAGE_ALIGNED(offset) ||
-           offset + size > i_size_read(inode))
+       if (!PAGE_ALIGNED(offset) || offset + size > i_size_read(inode))
                goto err;
 
        filemap_invalidate_lock(inode->i_mapping);
diff --git virt/kvm/kvm_mm.h virt/kvm/kvm_mm.h
index 9fcc5d5b7f8d..3cb5ef86d0d9 100644
--- virt/kvm/kvm_mm.h
+++ virt/kvm/kvm_mm.h
@@ -72,7 +72,7 @@ int kvm_gmem_init(struct module *module);
 void kvm_gmem_exit(void);
 int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args);
 int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
-                 unsigned int fd, loff_t offset);
+                 unsigned int fd, u64 offset);
 void kvm_gmem_unbind(struct kvm_memory_slot *slot);
 #else
 static inline int kvm_gmem_init(struct module *module)
@@ -80,9 +80,8 @@ static inline int kvm_gmem_init(struct module *module)
        return 0;
 }
 static inline void kvm_gmem_exit(void) {};
-static inline int kvm_gmem_bind(struct kvm *kvm,
-                                        struct kvm_memory_slot *slot,
-                                        unsigned int fd, loff_t offset)
+static inline int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
+                               unsigned int fd, u64 offset)
 {
        WARN_ON_ONCE(1);
        return -EIO;


