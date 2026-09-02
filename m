Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B17CC624D0
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 02:21:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3F4A6B008C; Tue,  1 Sep 2026 22:21:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF1366B0092; Tue,  1 Sep 2026 22:21:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96BA16B0095; Tue,  1 Sep 2026 22:21:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 60FE86B008C
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 22:21:27 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AA388C0692
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 02:21:26 +0000 (UTC)
X-FDA: 85167220572.03.0789F42
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	by imf14.hostedemail.com (Postfix) with ESMTP id D3AC0100004
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 02:21:24 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=gYBcjymV;
	spf=pass (imf14.hostedemail.com: domain of hughd@google.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788315684;
	b=eO1TcUJKCFyiVlWg9lXo3cRRHniY6j5O5JOJ5sBEhlGlQRYKXhIl7jQplP1d+gDldDDHtk
	prf3XnrdlxLwiwD/Ipiyf8qKoWfnHomNqGW7TSFpGyip7EIpyrcQ2TLDnxNNU1Usgi5F/+
	7Y0V9tNir9LROusP+Z2gRCs90ykCpI8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=gYBcjymV;
	spf=pass (imf14.hostedemail.com: domain of hughd@google.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788315684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GP2nihoXTh44eq0onDqBGjACptMCLq276d/ZwwaKLtA=;
	b=z7Pzqmj7HZ9bqNpBWYFmqQuUNsVLuSRWymSG0vQBxUosR6l3nLMZggu2l1R/uP0gAl4I/3
	PwPY11LfZi84pKW8DQ3oY3KGh/1/T8zfrVnbCcwWm4KvT+3QM4t3N+nawd0Q5+OutX7HAJ
	/dOvnZ9V5Siw7Sb47yBUc8K3PWAXGtI=
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-865bdc6ed72so10618817b3.2
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 19:21:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788315684; x=1788920484; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GP2nihoXTh44eq0onDqBGjACptMCLq276d/ZwwaKLtA=;
        b=gYBcjymVHGJO0fDkYzoWLKc3pQXyVd+Jwxadm3O1QXPifSCqRNUYl09BZ2bf9e+U9L
         cCEXC2hGVNhTUoJlILeQdlA//JUbqTk7TpJ49CcpoJStB7BM6FGNHnoyZi0Ng+xDX/a7
         uLvkBSOKFyeO+hbKVY53PRmICEutzAR54HuTTDvOaVz4CaV9I7lqHTQgExu+/W9kqaK3
         /SBnfxp+cPUvJYN6GOkTN3wurdwDbSO93TOBnKNxxtQZhPTR0r7w6rDNMy1/CrLEPDN9
         0oqxDxXZ9xlY8nnRXk0sGRegwIuf3qROjYx36ni3oGLhvitA6opHFkuYL0O4s6IqfWOm
         3naA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788315684; x=1788920484;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GP2nihoXTh44eq0onDqBGjACptMCLq276d/ZwwaKLtA=;
        b=riBA6Xt9q75X3jAjkUh7A4S7gjtlBcUVHR+bXIPeCbGrzvsX4CZns3ua1FQZYDRNXf
         MxZMQlsfK1Bbyd82lvMJxesRzKHSR1YK/crD9fI2XxaWaetsBJVnt6w0XJMwyrUqc+ta
         uMdRzbes2VgJ/JaWMyL9inQu+qPXtPrnhCJNJml5nCKBIkYjf8KWr63QSJLy3Qe28/ql
         m67Yuko9/Gkj+vufs2SgY2Hz5xj7KBnn2KFLl5iZycD/ovQQ/0ArZX0xL7e0VJ5XCJy9
         SndTb4sJR9cTm48dTm2lcaAA0njtAnbkdebsxUTqbyHLXcM+5W87WL/trDDFS11oY+su
         jfzw==
X-Forwarded-Encrypted: i=1; AKwUvBxuvTIbG9Sm5MTszuqMZVgAUflsK03n2hdJA3anBK4U99ybRoY6XoeL14oWkBGd6oYO6IdVHPyrWQ==@kvack.org
X-Gm-Message-State: AFuF++mWBOsth0QF0AYAM/b36iPPDdO23iqoCzZ8+oLo/bvJ7S0qMOuw
	cb0e6b7hXvoBGk4s42tiLDgvl+gs/TJQQa7jDfDFR7kA5ivubaxXiBkUwRnlNcF1+w==
X-Gm-Gg: AYBFou2WD1OjKutNhXjDL2puCcInGJSNiYP8QjF84KtgJclFM3EXfYMl52ztHOJaSZp
	IzEuk/ryqxCpQg6Px3hNxMi/0T/yjksrXGw78mnojxyZX1r4KtyLqoSnLAv2hsCiqRiUMQtX83k
	s9+PxBON2cQOTszjIAs0t+kuxYYWyDDU1b9wZuDGl0g4tRJMv0+xmnvQsfVfMzFtgbkpLfFsUX8
	HvtSc8F8gNAWE+PphqzFXFpQqe9p8wKFCGWUoyORu/HpeLQJN65GpmAHmfKL9585K0wc/UPNOfi
	OkVpBYft4eFxZTlYo9lO4/hTgfT/BiZq+KnedfsNga7ZHZnWX2bXfH1sLOqrpL+hZOmHwArdT1i
	oRFop0GRcOh6MWfYWKeQEEBICHFnDS7jWrItpeKYCnpAXX4YJJjjaCtl2dGvSFld9bSFl7NX3tp
	YqsH3DD/gX+W7I/FbTIdPfnLr4cgYtup2GH3MPaLJGrU435T0rY5iwLVqB/biIPZa3MeWB2hrvj
	go9EOn5nLTXBKzLkZUW1+DT6Qrj0Zark+lTbzUHGj9uYMyF
X-Received: by 2002:a05:690e:4419:b0:66f:7d51:b5ef with SMTP id 956f58d0204a3-66f9b90a9d6mr365005d50.3.1788315681539;
        Tue, 01 Sep 2026 19:21:21 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-66f986b612esm893663d50.21.2026.09.01.19.21.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 19:21:20 -0700 (PDT)
Date: Tue, 1 Sep 2026 19:21:05 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Ackerley Tng <ackerleytng@google.com>, 
    Andrew Morton <akpm@linux-foundation.org>
cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
    brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
    jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
    oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
    rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
    steven.price@arm.com, willy@infradead.org, wyihan@google.com, 
    yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org, 
    suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org, 
    Paolo Bonzini <pbonzini@redhat.com>, 
    Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, 
    Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
    Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
    "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
    Masami Hiramatsu <mhiramat@kernel.org>, 
    Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
    Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
    Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
    Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
    Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
    Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
    Axel Rasmussen <axelrasmussen@google.com>, 
    Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
    Youngjun Park <youngjun.park@lge.com>, Qi Zheng <qi.zheng@linux.dev>, 
    Shakeel Butt <shakeel.butt@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
    Baoquan He <baoquan.he@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>, 
    John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
    tarunsahu@google.com, Randy Dunlap <rdunlap@infradead.org>, 
    Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
    Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
    Michal Hocko <mhocko@suse.com>, Fuad Tabba <fuad.tabba@linux.dev>, 
    kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
    linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
    linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
    linux-coco@lists.linux.dev
Subject: Re: [PATCH v12 18/45] KVM: guest_memfd: Handle lru_add fbatch
 refcounts during conversion safety check
In-Reply-To: <20260830-gmem-inplace-conversion-v12-18-85e5fd25252a@google.com>
Message-ID: <bd6c9c74-e374-a9d3-ba1f-8b6f430894fc@google.com>
References: <20260830-gmem-inplace-conversion-v12-0-85e5fd25252a@google.com> <20260830-gmem-inplace-conversion-v12-18-85e5fd25252a@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D3AC0100004
X-Stat-Signature: bq6hfz31qup98no9ctj9or5iio9x81tn
X-Rspam-User: 
X-HE-Tag: 1788315684-411445
X-HE-Meta: U2FsdGVkX18bzwxLjxWZwqYH+WQJREXJpJY4t2Zu84pgsF0FLTU4AGYVFJLlTrmkhbXr3zRzbBd+GCJDM6HfLKP59OLIoXWzGkiddvvJMe14qqnxSbEKeN50DG841AgRmNTzJ5UHpXI2LcJzlC1c05GBexfyPxg2k9l8NTFlRShZ/NrAgs+rVpPpTKht51dCM//t7h68Jh9xMM+lyTSmS7wcQge1+KBMyEglR08foZ7f2kGo0Rpf29mhxvWJ3BqFJQdJjyuMXyj22MOxfxYz81EMq/dX87f65eXLbs3mYpM9ijLgxVqIxA/KR63u59Bfjmp1YkTwdkhd/UkGFdzPTVaSv84wyrKw1tmPWMI7+TYAH/fOJmovGCl2YwyWu/fiEmDfGjSw/39MH1jfrYRH9mPfKakWiYE4ek05y+yVLQxa4Nrbr0l8LxNpzzmJwOtr3N5VbAl3QFnSIWvL80bzck+UZzAjnTa6YEOiefur5WLpNUJqhfLJyuxwiC6xpNi8YAHyl5za1ZIQelNwPvDrgs2AvTubYTTgWODawKynAzboiP2Xh1YPoTnnUg/HYPEDsR01n895d43TTAdTbvpxMpZVE6Ylxvmq5Q1n4gEKAM1QU1gIZLfh4BcuL+IteAikiXc7P7ihUls/TjaSqRamm7Gj98GWW4Jm8p/akF11TXWGiJCV3NH7W7AegQ/7Vf1FQxobhBdv8itPGBtEBFGV1Fouj+z5ljZUfJJOAxyC7xhVpnB3QpZJ3pSOqFCBcZofZZUmA3dsacnRg04iGNxRyyE/z2vr8FAaOXeimiaqIpBfJX6cZJBG2+xojnQX1gjPe5q4/VFIAad8bsrjkXlUVcug3vbJGiqE7tNdn36gYrqyUOOSpkY0pcjghc9OxpNAY4dBQJUfL/bzCS2G4CoWaswCR9V/JyjxJvxhkl8Wf/XO0o8MR/8ILV4X5LVhoeVpBeSlIOgdUrTOc0QuENM
 yhyUXPes
 Spk4kKaZxOYXuPBqilJrYDQ2OFb28ioGgJ1F6/tiQxedEj4YE8f+0/Ug3/JpGlxHIzxUHLotpVyZD1gEGNkQChFpPfQN/5pxasTVXN/kmlLc2mj/qg1YKRw9Ptsk8uVPqrtM9Ab4XDgJi3gnCLvJymO0irJVCRH22kXsMhCd7Ynvs96FHWBHvr76GQtvAS2FOatJoUK/qUGXDceOduG1Cdwv4jGFOGTUUCqB0MOZo8Vq8hBIno3GHrb9B8499owt3qIBSmMZVnLr2gvvYOkxNO3sLIaqJjelrb6/KjBlpFh5yQKHYt3upKzSBgKSfIAGszln2QdYySnPEc7CeqjWXc/cuFv7HxxiuBMFv8AzDxQuMd713i+0rBGqNSXK//KE4EafKb6EzKxVbNdfaYeDwQjoUB3IaU0sg0c1R25DLPuv13ReulfuZ6f2WHrc4/7JuRAO1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 30 Aug 2026, Ackerley Tng via B4 Relay wrote:

> From: Ackerley Tng <ackerleytng@google.com>
> 
> A guest_memfd folio has no outstanding references if guest_memfd holds the
> only references on it. Any other references on the folio may indicate
> another user, and guest_memfd cannot convert it to private if there may be
> an existing host user.
> 
> A folio will have outstanding references if it is present in a per-CPU
> lru_add fbatch. guest_memfd does not actually participate in LRU, but
> freshly-allocated folios are still added to the lru_add fbatch for batch
> LRU statistics processing.
> 
> A folio may also have extra refcounts if it is on the mlock fbatch.
> 
> These two known "usages" of the folio are handled by calling
> lru_cache_drain_for_folio, which drains both the lru_add and mlock
> fbatches. After draining, if the refcount is still elevated, then there are
> truly outstanding references.
> 
> If the page may be dma pinned, DMA is using it and hence there are
> outstanding references. folio_maybe_dma_pinned() can have false positives,
> but that's only with a significant number of refcounts, at which point
> draining LRU is not going to move the needle - it can still be concluded
> that the folio has outstanding references.
> 
> If the page is still mapped after guest_memfd tried to unmap it earlier in
> the conversion process, it also has outstanding references.
> 
> Return true and exit early to avoid unnecessary draining in these 2 cases.
> 
> Provide a drain status to only drain once ever while processing a batch of
> folios.
> 
> Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> Suggested-by: David Hildenbrand <david@kernel.org>
> Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
> Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> ---
>  mm/folio.c             |  2 ++
>  virt/kvm/guest_memfd.c | 30 ++++++++++++++++++++++--------
>  2 files changed, 24 insertions(+), 8 deletions(-)
> 
> diff --git a/mm/folio.c b/mm/folio.c
> index c02dcea9c03c2..50a6dbe55998e 100644
> --- a/mm/folio.c
> +++ b/mm/folio.c
> @@ -33,6 +33,7 @@
>  #include <linux/page_idle.h>
>  #include <linux/local_lock.h>
>  #include <linux/buffer_head.h>
> +#include <linux/kvm_types.h>
>  
>  #include "internal.h"
>  #include "page_alloc.h"
> @@ -926,6 +927,7 @@ void lru_cache_drain_for_folio(const struct folio *folio,
>  			*drained = LRU_CACHE_DRAINED_ALL;
>  	}
>  }
> +EXPORT_SYMBOL_FOR_KVM(lru_cache_drain_for_folio);
>  
>  atomic_t lru_disable_count = ATOMIC_INIT(0);
>  

I don't mind about the virt/kvm/guest_memfd.c part of it, but I'm finding
a KVM patchset modifying mm/folio.c there hard to deal with: and notice
Sean also suggesting to separate this part out.

As you know, I've worked up a patchset "mm/fbatch: drain lru_add_drain()
and _all()" which finally removes the problem lru_cache_drain_for_folio()
works around. In the initial version posted a week ago, there was no
lru_cache_drain_for_folio() in the tree. Now 7.3-rc1 has it, so I
intended a replacement 13/25 in my series, giving you just an empty
inline lru_cache_drain_for_folio() stub (and enum lru_cache_drained)
in linux/swap.h.

But that won't work for you, if you're adding an EXPORT_SYMBOL_FOR_KVM()
in mm/folio.c, and of course conflicts with my removals (in context both
above and below your EXPORT line). It's easy for me to remove what's in
mm/gup.c and mm/folio.c, but I cannot remove what is not yet there.

I've wasted hours on this, hoping not to trouble either of you; but
seeing now that I shall have to rebase anyway (an unrelated mlock fix),
I'm electing to take the only clean way out: I'm going to submit this
mm/folio.c part of your patch to Andrew tonight (with a shorter Cc list!),
in the hope that it can be accelerated into 7.3-rc2 (or at least get an
mm-stable stable base-commit id) which we can both work off independently.

Whether that's acceptable to Ackerley and to Andrew, I don't know
(just as we don't know when either of our patchsets will go further),
but let me try.

Thanks,
Hugh

