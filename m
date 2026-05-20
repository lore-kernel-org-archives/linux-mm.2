Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12454CD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 14:31:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 627116B0005; Wed, 20 May 2026 10:31:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FE306B0088; Wed, 20 May 2026 10:31:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5140E6B008C; Wed, 20 May 2026 10:31:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4192B6B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 10:31:33 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E4B358CF2F
	for <linux-mm@kvack.org>; Wed, 20 May 2026 14:31:32 +0000 (UTC)
X-FDA: 84788036424.19.E8D4FFC
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf11.hostedemail.com (Postfix) with ESMTP id E20BB40003
	for <linux-mm@kvack.org>; Wed, 20 May 2026 14:31:30 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ZpQgtXyo;
	spf=pass (imf11.hostedemail.com: domain of tabba@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=tabba@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779287491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7N5NasgJypbMdlNYb/j7e6t6w9YfyUO25pmJjvirfi4=;
	b=fggp1FE09MNbhn5qKxLsQHW1dfOiEQFfJtTMooaIaspMAkzbf3RdtL2OZOpVKypp1688IO
	WgJetV6pDGN9ZAmXq952Zqze4nXX1PqmZMda8pTy8m90XJjA/h9+/3Zt6Qy+oVy/cemEmN
	42+WEjE4SNvAnoM9KDGiOvVmbxfaexo=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779287491; a=rsa-sha256;
	cv=pass;
	b=4YVpRuauKTZSbbxlcUKaLzH1Ya8D6bd1Bg2y/xxTvL6a14jGbnkLGmveg2w4Ec1hEHqdE1
	s+ecKvt5ynYbpqN1cAnjWAZ4Go9zCjCcQzHAO1usl6VuGILJIfHyM5OMoA0xSLu61OlxE5
	HVX8cgQR+ReK+SsJ33f2cUhIwvgxOEI=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ZpQgtXyo;
	spf=pass (imf11.hostedemail.com: domain of tabba@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=tabba@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-50d6b393d60so9561cf.0
        for <linux-mm@kvack.org>; Wed, 20 May 2026 07:31:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779287490; cv=none;
        d=google.com; s=arc-20240605;
        b=VlTVK3azblntoCvWM5Ex7zLuQXhC3YP4xhkdyQOZTse4BqFN3sNL8owgVGMCa4SrPX
         T7Jn0gC4lo7gG1eiO2QriBVOqj0alVx+yeUqZUsoQZA3S7UvTFj3fi5Ufaju1Z0HYt7s
         XJ+m5efNN2deLUpYe7LKzV8XBLuzTcgN7Yi6hZDwOuosmXRLyUmV3W6XJC2mEwj14ngE
         e5fJ8SNoSrcF6A+Ul2TWN8k1Y+wM38q7offuBlt/xWOIUTJhI6Ydl847Bg5hUzSwR21l
         xzWT3IMKNlb7O2wPcM1enCdVg8d0CVt382hhcLtygG8rCxL0pJt787SN1sBqqbh0XT6F
         Hcmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=7N5NasgJypbMdlNYb/j7e6t6w9YfyUO25pmJjvirfi4=;
        fh=PbnxCGyO7wFBIthkC5p+G/6ZWHfLY4W/wvwU+BLZM4w=;
        b=jTfpa5kFrxva8Pt0jRxcau/Zw22B3p+oVKzwVVOHdMhrdWMyT8lr/ZdMABhFX1CECk
         hcD/ZEy/Bh63eMLu0Aakdp7tKw71wD9zjyfGnHtCOitELe0dAqaTvJ1m/op8B3v7vw9E
         vNGUZtTvKHS4wst0AVgkyHJegKSDAzc+PNgDIDFzt806o4k8ddVQqVpfqrgUOzKQmJ8q
         aoJI95YOfGGN0ytreMIFxEVjDOx+89Col6csSZRnOx7jQOilRhtvusdhu+GbzV4sxxov
         jNTEK2MSWrOWpx6JZZg9lDXOIJkNK0FzmYoIIdOE9qGx6RbvLd2slSHQTHnLe3DYzzoi
         srXg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779287490; x=1779892290; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7N5NasgJypbMdlNYb/j7e6t6w9YfyUO25pmJjvirfi4=;
        b=ZpQgtXyoOZPn51ebx6BHawl7HdCibqDS2jh7uAHEh1Ary8ekvwO/1rKmxwig9ge/u5
         W+uouCw40gdk2WN1NoWje1ovuMWAto1A96ZiaM9cRosj+Chc7dQODqcsFjp9vzUHJenF
         v55w3wWSBkcDFvqM+ZSRluutGSWCScVK0KSD/Ta2bWq89oAxVQwXHb8KBCmZ4WfLP3Up
         HxiPkEv74jv3fMAtWX/y5g8ipTN6hjnKEXKf4+nOMMalQ/P7z6tUK48JjBGCmxLtCKdI
         A+DbMBqf9fsxUsiSEgYA5Gzn7PZPbL26I9h4O0L73DWFsimAsGOEG6BHSPqSqi3XQd5X
         jxDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779287490; x=1779892290;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7N5NasgJypbMdlNYb/j7e6t6w9YfyUO25pmJjvirfi4=;
        b=pao1gWy1embjvCvU8mK8xAuhsrwQ77+KXJDyeZhmNVF4aqkgmLoPrrD8zBKBQFAfjl
         m8Axqd4b6MxMrLCg/v/oxdsn13hWz0WUwtN0Ahf53l2GUyYClLDGvzXHzXD1pVMJ2GTC
         71qAlp6TbZ9B5vGPf1JicQzjF4IaMuekh/9dX7jzDLuNqmR7WcSK4R8svUwNPbjUEx/J
         KUFdpYol2J8j5FrY0X4yqYcbTs1h4mSRkhWjINGJpZ9p4xLK2f0WiCYDIidqXmzauN/0
         +g008uWC4OPEyR13cGF093dPeV0ekNwerVDFMA//B3uMBOgsUZOHYE6Kd8fFGwuGVZkH
         cgSQ==
X-Forwarded-Encrypted: i=1; AFNElJ/LrLRHFawkfqmIAYYJgl15a7kH2+4yjUrUKXWlYTU1zuv9saxMrsUdVBePIkDe8rPQ237hvM84YQ==@kvack.org
X-Gm-Message-State: AOJu0YzuLciYiyA+D814fldXf7Lj3aG7QK9mQc2pUVzIEchNeh+vD7Ag
	Q8TJpcA3lJZvKn1VrVB7q6+NlUMJtOBjcirJrEFHey7aPY4s5uqT331iMq58gX3L0xk/mHYxybV
	oc6N5wTD4URMNwj/TrUgrcqAmscZeYQbmcunlgsAw
X-Gm-Gg: Acq92OEn+51Ze7/JI7xPQRLIydkAnZyu1EepNtNsqGjCNyocga8nCFcC7HD9+DrzpOA
	+1nipzt3Rhx/Ussh/JaEvgdz3VfHlAEjuCPEMFG3qNO84NfX9nWv+WIz0r3WgL2av7JvWJtZ4pf
	rQK0Yfjyr3rGo5IAfRjeT6StR4Frtb307vhM6cxpYzGgHn948NwMpB/OAxi7iFN/2v8tlXoUsKm
	Xn8qPnBoMyn2db/izl9bkkRKJ6NFrKekWByGv4RkIuTgNlvSzIs6XPPkx6oWyVRfy+EyD+SYMrw
	6E6KbFLx11e9nCMHy/s=
X-Received: by 2002:a05:622a:989:b0:50e:6360:96e with SMTP id
 d75a77b69052e-516791fe73cmr46959761cf.0.1779287488674; Wed, 20 May 2026
 07:31:28 -0700 (PDT)
MIME-Version: 1.0
References: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com> <20260507-gmem-inplace-conversion-v6-12-91ab5a8b19a4@google.com>
In-Reply-To: <20260507-gmem-inplace-conversion-v6-12-91ab5a8b19a4@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 20 May 2026 15:30:51 +0100
X-Gm-Features: AVHnY4Lo4l5leoGwp4MOUhUOXd-ZR6_GPypj6bN4fnpU5Ptxtsw2Fzt5rIYMAIk
Message-ID: <CA+EHjTwOfJ=nCRoX3m5uDt=CcF_zrqGsZVBBmo4MscmPqrBxOA@mail.gmail.com>
Subject: Re: [PATCH v6 12/43] KVM: guest_memfd: Call arch invalidate hooks on conversion
To: ackerleytng@google.com
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	ira.weiny@intel.com, jmattson@google.com, jthoughton@google.com, 
	michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	shivankg@amd.com, steven.price@arm.com, willy@infradead.org, 
	wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
	pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
	liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
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
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E20BB40003
X-Rspam-User: 
X-Stat-Signature: 5ucpcr8bsr4yc5qkzb7r8huxpftmgr83
X-HE-Tag: 1779287490-570291
X-HE-Meta: U2FsdGVkX1+uLJOlMekW7agajinfO7VRoCprlBobXKrIJ7xmKFdP/gRHvUwEvzPL70s+dvuz6VSTqbP2A+af48Wqxi4C+KoPT1b7Jp8WR1v9Ph4mdy3XNVlFR2QcYwY3ptRXBO4d3t/KZvWlyRE57OZFXGzB497Se4pLmxo/zxU+63lX8xQVLM4MfmFfinhxX1ODpwz5mTsskQcSDG9x4BvO+/KlcUafJ5ySuCAXq9YpmvzUD0XokMWSOWL6TM3MYCnrF/UfG/yIc6WPvcmsH0P8MlRjfQ0nP9aesJmEDj2TZ+tF9uq1xAAcOfu8cFuiNOdk6bIp6aamW84h/GMnzQ+uVk1t88lC7J4KVKjyu/nFGBmEp/AFmsD7KjBr+GHp5I4wVPx+8c7Vu6ibDtkmyOWXGvrJTQ8w5Ba/rQ1YVtDiuT82W9OakIfkXcgk5CVDOQMYRhOVOBkakd+njdEV7Fdn/MYg7hWp/NKbbwpoeLswtdJRE3wmf0k0HYFz+GpkC7SR1e92hcc6sA5fwVGoBEPts0mznOj8aYmyhCXq/kLNYbiQsFmTGU48Le77BwkRp3nQQE0aGoTeqp4ADJyx/JfdGcTJD1UxhYu8xubeR0zRPAKCaG9lNv/IUnFUTyoh3xq6sqHBULjbCbbMDVEj1WNLXXYhy7cU2J/4GWQJ7coCDLsBBgdAPxkhqdkQwzP/5w8UcXy3jMydEmn7N+l3WD6dvd+2E08dupINSmIU89KcCjZsoIGc34ZUMgKTFdKtxH3vrMVN5qhqlMgcP8656J0SnoxRxs2IYOIp+Z54PmQdmapnj5BVyEv1nDDUG9bD0QFSIZONp2sKA4R/b9a+m2QRPFsyUo5dDIJXTPGOivAqAjRo/haluWHlPBsAZ+KkwU8OtoTBrfkzHmQR2ZFIZVWf/4razJ8HlJoxJE/Tt0DS6iWlNS4Csl/2f2Jr4hsu/gXXjTQSCvoGrpAEpYt
 KeTi59Qc
 BYAxquSkvCyo9og/j5tW+HlPK8db2YD6V5vatIHQhTbmmenuZnjDuLnuWN9j+3SRAgBEbdlVjdhMZTv4qvYE32JGG5zgBt2toOAJjD7+56ITZkniFQ7rIzA1WjR0REuF/BJd6UD7Pg+Ww+EFxXbPTIDhVYBx1vyBOO0ygjf/Y1zKWQtIz3fZx/z6mzvp4lp/1XS1NXvPTfe/n+KLQeo+9oi/7V1cNfgJNUXlmCgxiagMOsrJGdeMVWOKIM1ODEKkUQLreydjppEekjPXFgXOoBMCGbEgKtaWP5O3+kWm90GejJwwLsu4yaGdmPNAj4DwMn6QyVaeAapzUSJ4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 7 May 2026 at 21:22, Ackerley Tng via B4 Relay
<devnull+ackerleytng.google.com@kernel.org> wrote:
>
> From: Ackerley Tng <ackerleytng@google.com>
>
> When memory in guest_memfd is converted from private to shared, the
> platform-specific state associated with the guest-private pages must be
> invalidated or cleaned up.
>
> Iterate over the folios in the affected range and call the
> kvm_arch_gmem_invalidate() hook for each PFN range. This allows
> architectures to perform necessary teardown, such as updating hardware
> metadata or encryption states, before the pages are transitioned to the
> shared state.
>
> Invoke this helper after indicating to KVM's mmu code that an invalidation
> is in progress to stop in-flight page faults from succeeding.
>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

Minor nit below, but lgtm.

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

> ---
>  virt/kvm/guest_memfd.c | 41 +++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 41 insertions(+)
>
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 9d82642a025e9..baf4b88dead1f 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -603,6 +603,42 @@ static bool kvm_gmem_is_safe_for_conversion(struct inode *inode, pgoff_t start,
>         return safe;
>  }
>
> +#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_INVALIDATE
> +static void kvm_gmem_invalidate(struct inode *inode, pgoff_t start, pgoff_t end)
> +{
> +       struct folio_batch fbatch;
> +       pgoff_t next = start;
> +       int i;
> +
> +       folio_batch_init(&fbatch);
> +       while (filemap_get_folios(inode->i_mapping, &next, end - 1, &fbatch)) {
> +               for (i = 0; i < folio_batch_count(&fbatch); ++i) {
> +                       struct folio *folio = fbatch.folios[i];
> +                       pgoff_t start_index, end_index;
> +                       kvm_pfn_t start_pfn, end_pfn;
> +
> +                       start_index = max(start, folio->index);
> +                       end_index = min(end, folio_next_index(folio));
> +                       /*
> +                        * end_index is either in folio or points to
> +                        * the first page of the next folio. Hence,
> +                        * all pages in range [start_index, end_index)
> +                        * are contiguous.
> +                        */
> +                       start_pfn = folio_file_pfn(folio, start_index);
> +                       end_pfn = start_pfn + end_index - start_index;
> +
> +                       kvm_arch_gmem_invalidate(start_pfn, end_pfn);
> +               }
> +
> +               folio_batch_release(&fbatch);
> +               cond_resched();
> +       }
> +}
> +#else
> +static void kvm_gmem_invalidate(struct inode *inode, pgoff_t start, pgoff_t end) {}
> +#endif
> +
>  static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
>                                      size_t nr_pages, uint64_t attrs,
>                                      pgoff_t *err_index)
> @@ -643,7 +679,12 @@ static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
>          */
>
>         kvm_gmem_invalidate_begin(inode, start, end);
> +
> +       if (!to_private)
> +               kvm_gmem_invalidate(inode, start, end);
> +
>         mas_store_prealloc(&mas, xa_mk_value(attrs));
> +

Why the unrelated extra space?

>         kvm_gmem_invalidate_end(inode, start, end);
>  out:
>         filemap_invalidate_unlock(mapping);
>
> --
> 2.54.0.563.g4f69b47b94-goog
>
>

