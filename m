Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F265CD4F3C
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 14:29:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BA166B008A; Wed, 20 May 2026 10:29:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86AB16B008C; Wed, 20 May 2026 10:29:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 759956B0092; Wed, 20 May 2026 10:29:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 63B276B008A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 10:29:01 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 09FBA160A2C
	for <linux-mm@kvack.org>; Wed, 20 May 2026 14:29:01 +0000 (UTC)
X-FDA: 84788030082.08.F232526
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf23.hostedemail.com (Postfix) with ESMTP id 05DB0140011
	for <linux-mm@kvack.org>; Wed, 20 May 2026 14:28:58 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=hEyxWGju;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf23.hostedemail.com: domain of tabba@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=tabba@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779287339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SDMj41/pkYi0SiyY6zKgWY/JIbItQ876cBH7lhvdwcU=;
	b=blcKEniHXm69D8bCB10X9/pszBQpgd1+WjTOgcZ8hQbNiY2C9LHnhIthvpUs/gVK+yWpJn
	IygFl9KmA/adcwEegkT5KFGbjJEUgRKQXgQmaWhanZokRErvOYVImRmfnL7yLwtuwuhHn3
	20AQm5dCWIwh60SKXFmivVyGs7yhuMc=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779287339; a=rsa-sha256;
	cv=pass;
	b=g4TeEbT82ktX9d5yAom3nr0L71Hzve/k6zkxEQkWXkptJoo4CgwxnThyqyVIAdolQ5656s
	7IaOLZkWrurSD2GfN6WAq7LHeF6W0XXfLBtcUqGKGvXWv3G7KeZCjGw7PAkLl4BiLuw9wa
	i1GcvcHOwmZ+QHVmcCsuOnSpEwVn40A=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=hEyxWGju;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf23.hostedemail.com: domain of tabba@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=tabba@google.com
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-50d864c23bdso12641cf.1
        for <linux-mm@kvack.org>; Wed, 20 May 2026 07:28:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779287338; cv=none;
        d=google.com; s=arc-20240605;
        b=Zst8VUbvaBUUxX1Oh2z4cAp4EiOn3AP1+CO3GGAB1UyWPf14ARyscKN7+PVu1n4MVh
         SA9B0VOMb/aCLrbdwRMhYgZCE1o6+gQq4YOmjknJPB0ppW1xPzhO6M79PazI15KED2SJ
         OIpDL68BfjNXW0Zn2RVsp0TLIxpgj4YeeKh44Lof8BJgR/v1NcE1MR5Uv7xWZBAgAXJm
         BeJTOrYci8Ey9mJVfi0cgExi1LIoK3jk840n0UpZFzSIRbb/Tu+PK7++iOOMZSnsghOd
         w68iIjunNFZXY+1fz7V0afOmxlNqzavL1CrEgh/WqZfHjtOYzaeIrloANgEPkjaEowAy
         Z6+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=SDMj41/pkYi0SiyY6zKgWY/JIbItQ876cBH7lhvdwcU=;
        fh=AIG2Lk/beTh96eslxb888Jowwkbq29Qia15KsDPSDyc=;
        b=QqKO/AGTMJZB3vJCUDO++ExTsp82HmPfL7wiNxjLaIGLdKbYfg697xkX0OqQm+1ABc
         3EgoSpGGUyEbPbyZe4QyRXqi1rcCjjJx1qW0baWHitp4WE+mDg0mfqPM4tYdyZ+Fvg/i
         04TdqW0NrqBBHb9SkkyXPVNgyypBx2NfgWpBpNnqa94L9a0OfiJY0XRqmffsR7sqskdm
         lDXGesaNQRTKYR9PCyuROrrFo9JE0u/KONJS/E1Nk90sN2D4zd1MK9ddlaEXcGxpS15d
         3iiAYeE954eomRsFZVnAV8huJghnRNQEjnhthWhhZC5KxdApqYVkxCwPUgBJBYnanZcg
         7EiQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779287338; x=1779892138; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=SDMj41/pkYi0SiyY6zKgWY/JIbItQ876cBH7lhvdwcU=;
        b=hEyxWGjut+MUYn4D9WhPlpM132sCDS5p+2M6Z2rm1u4Y/WVKwoAASnYFlkPN30OF1u
         uhVWB0FbfAZGeyGveokfJ/wpSD5z/c0DCPIUBznEQ/1FkN4LQF5s/Q6MR2RwUlRUSECV
         tfHzvcVXtMz0ivn9R6Y3jcgphBfTc2f64otO5+kgWO3ERu8gy9xRZ4jto/G2lPAIbKBJ
         1xQlWbKj82So0yvnElEzVhjAijOKYYZ0hm3eRTzlhBs4In/aMi5dvuLf5LOtfYc1OCgY
         eAfG2cfe1j9DvbRmsumHslcDoUls3P8E4LduWx2bnujWQTKricutXaBcGpy+IshspaG0
         mCKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779287338; x=1779892138;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SDMj41/pkYi0SiyY6zKgWY/JIbItQ876cBH7lhvdwcU=;
        b=cqZdfbbzhmJEIt1712txCmXQ3p5hXil+18si1LQREpRVv0XEu3yW+MfAqAyRLP6oZF
         RxuezvprHNWWlq+9kMujGk/2u/KWTeONqadmCHabwzTcppKFrkADnoYdfhjVpp3NESw6
         sU/5CL8muw5ijCnK2L6pH17oq71u16N9Meu350sAANAz7KMdWFsfs+uCL3mhtAQ7tDrk
         IiOudsVl6xupAYd3+GcgJ2aar6o3oLphY44Oi69TUZEdP+OuBmrAXTZHjhji58htiRWh
         Jw8L2HoOViO4rgYUEJY662sUoVPKBaE+fzljHk/xXCaHLQvOzbwiQUpTC+xPX5qHA0Gh
         mc1A==
X-Forwarded-Encrypted: i=1; AFNElJ8pi0/LU6ALgE/uMfTsZZrLONzCvA2tVXS+O5FKt+8PZopOUVFqc4Lejf3cyWWQaXmQlYcDUAy9Ng==@kvack.org
X-Gm-Message-State: AOJu0YzMXT6JiS9O6EC/8adZOCckuTwL8jsGJUJGjFrfLWHS3yhfDRCB
	t+r+pkbcJgIWcpf8kjdo4ppK+Os8gSmSSye6zRvyH6chodgqTtwfXjvcrHG6K0zB9onOMhRhEkG
	YqkLODy7tmFD4SejhjhSRkemiFb8eITIRTOMELIjn
X-Gm-Gg: Acq92OGP1b401HsUZXlvgUfEaRgBlYBI+bliYTJWXNgyOUKt741JTywxscU6H8MdHIT
	4iJmx5HZAhMgZIP0lB2uYY2g5f+j1/zDyN1K9AG7FIe2pKazDTc+tdLXNNq3VnwjzFcYsjhWOQt
	Iw3uwUA5U7cbSgO+RPQjU/oIAOsiAL30YP3KMRo3PjtTSGYQ2YihXTJXrze6l9rEaH1+lZZtfR5
	1y86Ft60ysKkz2SPwH/9mQa28XzF2Va2c28GXHJONOVkRgRtJ0hTlAQwRdS14BgORXShjwFk+m0
	zWZ4OSK9wnpCCpttlVY=
X-Received: by 2002:a05:622a:1802:b0:501:4eae:dbfc with SMTP id
 d75a77b69052e-5167b676239mr20862401cf.5.1779287337177; Wed, 20 May 2026
 07:28:57 -0700 (PDT)
MIME-Version: 1.0
References: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com> <20260507-gmem-inplace-conversion-v6-11-91ab5a8b19a4@google.com>
In-Reply-To: <20260507-gmem-inplace-conversion-v6-11-91ab5a8b19a4@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 20 May 2026 15:28:19 +0100
X-Gm-Features: AVHnY4L9O3OTsfOAqqdov--6MJhNDxaLQ7PquyLIvNtXq2pe4PNa20rghwvuehE
Message-ID: <CA+EHjTyyah4B6RZRhp=awJ7psp-wSwSSFGyDQF0wt+J9J7aDdQ@mail.gmail.com>
Subject: Re: [PATCH v6 11/43] KVM: guest_memfd: Ensure pages are not in use
 before conversion
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
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 05DB0140011
X-Stat-Signature: dau147tjjrt717gy44r6noa8ceiac6k7
X-Rspam-User: 
X-HE-Tag: 1779287338-265262
X-HE-Meta: U2FsdGVkX19UfSVl2/ZtIFBasGfKSiiFHKP7C/Xvwzekklj934KmWNyV/0gzzvjk5fR6Mib8YwtD8P/TvrENd5dOF4AeKKHOf+G+/t0vozwXxLBC33aBMHs05DNepGj7TPZK2mpYJkpiUKP3L+1a3uykuBjL1lbuX0pfsB0jB4Bjpjl9SGVA7UJ8q3Ou/ba4h9SChdhlPmeKG/IiOEA6WlzLPuOm6gc7fUeQA0LbbjZibHk1gjylcZaw57djq5yTNFox9CLD9139gwUeKROLUHQs2LciaybtzlxVOWR4G7du2KqXZKoMZ0DNMZMlEsqkghdje1zkto4SxiHBHytHXh1A9Dg4T9cr14wtT5jPtcjOWrTksVTh8oXibZhdlXNu7YCrS4WELigMuRosswyU9h//yiaGPfcaPyUF0QrGevJ4n25aKBjg3cS6rNDTwmutvFJpTU8xY/KqDsS8sjWTr+o/vnMuEUFAcPEB/APQa4UoBDdzSnFEkj6saSwCHx4amsTvlSFm1g9gv+h+SFpySgDLr+OBt6lfPS+ENTdOf56JUyIlFozT0Rmy9X0fojFJQZj+JAKEeHEoIOy7tLrggAQ5Q/Ray6uuQErHB19mEkTJuOC9lvNHWversqmpli7GQLM3ty0whZXrbYi6ytQGuG00En3w0BD5o5o6fqfJ9DJGBI0tbOFZEv7Wj8naY6Cxv1VFFZFnik/KmxVbtLdhotwoMNZQvM24l1/U/ufGMR6DSxUhkmVwBfrl4OE2SIy6wp4G8cSxSNPogoqkvbAl9uLoNcSV2/eIQBC84ffPTeQbKIyQuQU0BzrI+JzGa6vdgFo3abtL3di4/6/luo1Dr2jQjVc3uIB+B2WovZSvGDNuYrClbh0w6AYzJzEjYEzS562eZMa7U6Z5VQqtwJ8H9SepoG5b3kbSiAHk4sB7CMtrpv/tarcys2YghbAQYM9NlHLFWwV73GW3avT+jKA
 nKijR95c
 hHapyTFIQ+Wm4V9VYQk1uKi2eyOAhPvdY7H6OpwFc3pla2FmXoDqkh2pA6rN2PMXCcm50QCcKDy1DT5VbzV1+2DyD9cyGXgz38xxr1YxsB+t2tENiFY2LLCHavhatGAioP9YWf0hmXin5s/+XccC3dQ2XJIZ/2Mu0PbWkRIMt5xEzqcsrqhgAHkg4FmE8D1D42iL0WGd4A2Iob0N3AzEpTTs2QnHY5lHl1GwFEVRrGgsOzBNUZkv/FV/OO6Azdi2xJrSJCjZRciZ9m7ALz2VtBy4W8pU7GkQ5BmhADeGqFB7fzZLX/xKZa9SgTxeg5t1GGZH7IujTrZDXqPE=
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
> When converting memory to private in guest_memfd, it is necessary to ensure
> that the pages are not currently being accessed by any other part of the
> kernel or userspace to avoid any current user writing to guest private
> memory.
>
> guest_memfd checks for unexpected refcounts to determine whether a page is
> still in use. The only expected refcounts after unmapping the range
> requested for conversion are those that are held by guest_memfd itself.
>
> Update the kvm_memory_attributes2 structure to include an error_offset
> field. This allows KVM to report the exact offset where a conversion
> failed to userspace. If the safety check fails, return -EAGAIN and copy
> the error_offset back to userspace so that it can potentially retry the
> operation or handle the failure gracefully.
>
> Suggested-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Co-developed-by: Vishal Annapurve <vannapurve@google.com>
> Signed-off-by: Vishal Annapurve <vannapurve@google.com>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad
> ---
>  include/uapi/linux/kvm.h |  3 ++-
>  virt/kvm/guest_memfd.c   | 65 ++++++++++++++++++++++++++++++++++++++++++++----
>  2 files changed, 62 insertions(+), 6 deletions(-)
>
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index e6bbf68a83813..0b55258573d3d 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1658,7 +1658,8 @@ struct kvm_memory_attributes2 {
>         __u64 size;
>         __u64 attributes;
>         __u64 flags;
> -       __u64 reserved[12];
> +       __u64 error_offset;
> +       __u64 reserved[11];
>  };
>
>  #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 91e89b188f583..9d82642a025e9 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -572,9 +572,42 @@ static int kvm_gmem_mas_preallocate(struct ma_state *mas, u64 attributes,
>         return mas_preallocate(mas, xa_mk_value(attributes), GFP_KERNEL);
>  }
>
> +static bool kvm_gmem_is_safe_for_conversion(struct inode *inode, pgoff_t start,
> +                                           size_t nr_pages, pgoff_t *err_index)
> +{
> +       struct address_space *mapping = inode->i_mapping;
> +       const int filemap_get_folios_refcount = 1;
> +       pgoff_t last = start + nr_pages - 1;
> +       struct folio_batch fbatch;
> +       bool safe = true;
> +       int i;
> +
> +       folio_batch_init(&fbatch);
> +       while (safe && filemap_get_folios(mapping, &start, last, &fbatch)) {
> +
> +               for (i = 0; i < folio_batch_count(&fbatch); ++i) {
> +                       struct folio *folio = fbatch.folios[i];
> +
> +                       if (folio_ref_count(folio) !=
> +                           folio_nr_pages(folio) + filemap_get_folios_refcount) {
> +                               safe = false;
> +                               *err_index = folio->index;
> +                               break;
> +                       }
> +               }
> +
> +               folio_batch_release(&fbatch);
> +               cond_resched();
> +       }
> +
> +       return safe;
> +}
> +
>  static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
> -                                    size_t nr_pages, uint64_t attrs)
> +                                    size_t nr_pages, uint64_t attrs,
> +                                    pgoff_t *err_index)
>  {
> +       bool to_private = attrs & KVM_MEMORY_ATTRIBUTE_PRIVATE;
>         struct address_space *mapping = inode->i_mapping;
>         struct gmem_inode *gi = GMEM_I(inode);
>         pgoff_t end = start + nr_pages;
> @@ -588,8 +621,21 @@ static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
>
>         mas_init(&mas, mt, start);
>         r = kvm_gmem_mas_preallocate(&mas, attrs, start, nr_pages);
> -       if (r)
> +       if (r) {
> +               *err_index = start;
>                 goto out;
> +       }
> +
> +       if (to_private) {
> +               unmap_mapping_pages(mapping, start, nr_pages, false);
> +
> +               if (!kvm_gmem_is_safe_for_conversion(inode, start, nr_pages,
> +                                                    err_index)) {
> +                       mas_destroy(&mas);
> +                       r = -EAGAIN;
> +                       goto out;
> +               }
> +       }
>
>         /*
>          * From this point on guest_memfd has performed necessary
> @@ -609,9 +655,10 @@ static long kvm_gmem_set_attributes(struct file *file, void __user *argp)
>         struct gmem_file *f = file->private_data;
>         struct inode *inode = file_inode(file);
>         struct kvm_memory_attributes2 attrs;
> +       pgoff_t err_index;
>         size_t nr_pages;
>         pgoff_t index;
> -       int i;
> +       int i, r;
>
>         if (copy_from_user(&attrs, argp, sizeof(attrs)))
>                 return -EFAULT;
> @@ -635,8 +682,16 @@ static long kvm_gmem_set_attributes(struct file *file, void __user *argp)
>
>         nr_pages = attrs.size >> PAGE_SHIFT;
>         index = attrs.offset >> PAGE_SHIFT;
> -       return __kvm_gmem_set_attributes(inode, index, nr_pages,
> -                                        attrs.attributes);
> +       r = __kvm_gmem_set_attributes(inode, index, nr_pages, attrs.attributes,
> +                                     &err_index);
> +       if (r) {
> +               attrs.error_offset = ((uint64_t)err_index) << PAGE_SHIFT;
> +
> +               if (copy_to_user(argp, &attrs, sizeof(attrs)))
> +                       return -EFAULT;
> +       }
> +
> +       return r;
>  }
>
>  static long kvm_gmem_ioctl(struct file *file, unsigned int ioctl,
>
> --
> 2.54.0.563.g4f69b47b94-goog
>
>

