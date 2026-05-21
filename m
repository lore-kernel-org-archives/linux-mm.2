Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE16FCD4F3C
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 07:10:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 372146B009E; Thu, 21 May 2026 03:10:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3232F6B00A0; Thu, 21 May 2026 03:10:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 211176B00A1; Thu, 21 May 2026 03:10:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0FA766B009E
	for <linux-mm@kvack.org>; Thu, 21 May 2026 03:10:04 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B00CC4053D
	for <linux-mm@kvack.org>; Thu, 21 May 2026 07:10:03 +0000 (UTC)
X-FDA: 84790552686.08.9D9016A
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf22.hostedemail.com (Postfix) with ESMTP id A406AC0010
	for <linux-mm@kvack.org>; Thu, 21 May 2026 07:10:01 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=q4bmRUvY;
	spf=pass (imf22.hostedemail.com: domain of tabba@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779347401;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o1vjKKtiXH21d0SoJcdzf44kDnBJugtM1iizS2M6tEM=;
	b=OtMheYJbJz5gOts+WuPvkrsz3IAGcF7f0/ix8WQ/Rjz0UPc74y4g6rvUj2hdJshRsC+agH
	/R//2wTRkIqwV7/aZuT3wJjc49uSD2CHRyhjii6wmmXq9ABwqjsC8F91NBqEiH9mMVd863
	gaE9KUbGTI7uvUCh6/n7f3qKrRMpeMY=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=q4bmRUvY;
	spf=pass (imf22.hostedemail.com: domain of tabba@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=tabba@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779347401; a=rsa-sha256;
	cv=pass;
	b=ZmXwcKYqQbg2D1qJxTT/JCjZBkvMRufMS8+dzByzM9it7dbCMLqUwxPo9yUobjBhWAT2d0
	/7NTzmMahgUUjHjfIGoitCjKLOQ2HlU3VER8Wjdl7Upnx9ZwrTEX930sO+7N08/Q/jZCq9
	YH4RYI2lAvIOuxAcsDj8LZ6CiXl0wfA=
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-50e61648f10so12571cf.1
        for <linux-mm@kvack.org>; Thu, 21 May 2026 00:10:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779347401; cv=none;
        d=google.com; s=arc-20240605;
        b=fK2mrxWEfXuBg/wZDYeLAxje4SZpkYZQSqIgjKHWMFKUlwabAtHshMoUG8xCZ13zOD
         wX0P/yUTLbPnHzwf7hBh1sbxoZS629zSv8BRWGZ6d+O1Z1FHngmuwYQa3ODtok2cCcUt
         Y10YNcD1WAMIQjvbWUNa5LaGG9zKpxak20lLsBEryXWNkarcSHSi5aSaez/8IvNVFbUq
         DXgWw9aRPnmMBJ4ShGLueEnw7bdnCAiDwJFgYNplESqUCqg9CQwBmVJVlYgJmx7+0Qlw
         nP8svK1JFK80mogLwcWEzCoFWZRo+Pok6NwDXEjHkHvO6R6rr251LhEabnbW6Q3MgH+O
         k8AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=o1vjKKtiXH21d0SoJcdzf44kDnBJugtM1iizS2M6tEM=;
        fh=lOn4CFUIzxQ/Knyn5zFcyYMmwSxsTBrGpnruYRMRHPc=;
        b=PSZiiJhUSK0anqTFQMp1y5AonDCsBzSFyX2AX2b5xSbF+oZZGryx5a2IlJSkFZTW62
         ogZgnFrFGL1UK6bZSQ4U8VCsvGU0+BzrXZJ1x6kWds0niLfSnQLP+FZUwiWOpS/TXpzD
         RvCqjh73xZk1jcoUOCwpEGqcNATXnypuVf2TygAGNGP9kX/AM2JKX+RXaNd3TW/42Aoc
         x0sxYzFVLz6fXiUmCUeqtq3y0RRcLYWHaDt33N8G3ka7/bw6X/ZyGeZiDRTV9eOUGAQA
         ijWqZ54vNoWrL1rAQV9mNIsUXoYodhtZgX5R4gySaC8Jo3p0MStt5gqp1HhXTzNyc4Gy
         YQkw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779347401; x=1779952201; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=o1vjKKtiXH21d0SoJcdzf44kDnBJugtM1iizS2M6tEM=;
        b=q4bmRUvYu7IvJ8YnXRCqiyE1NZ8j6W9HQ9EYOJs+8SNM6Ys8Q5sQEk3OhjT4/RBP1N
         aU4Nw/r1DcpmzahgbfKlCPemtaxQggwd3UBK/A19rSBc3y2a+y9c81cpqbmRJBQC4hyP
         PYY/J+BOjW11zTRshQkscIN9lGBJ/jmZdZ2xUrD7v/ylD85xxBEbTouRxlXj7kQYjlhC
         EtLWKFYYNa35HR7Yffqk/6gwYX4m6lrqE1/FAZ16qDD6pflhmS/B6b6cNSxdg+QMYKP3
         CTAERqLKq5zSLyxSLMk59VkkdQgKUiJFX6qso5Md+uVcpLG9Gj7Obj2MyY5UJug38v20
         82tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779347401; x=1779952201;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o1vjKKtiXH21d0SoJcdzf44kDnBJugtM1iizS2M6tEM=;
        b=f7+7IEK6g8XEHATT5Ziar/1E3uVOpW5R9ACkg5VW7zQIFL04pFMtpl8Cl/WOweH8QW
         xEVCg1SLlpDSbXhFgGyBAMrJB1PBduduQrNtHqaq6A+RBpM4DlKi8z9ct95n3ko3bG+u
         0o93Bqf/8JMNiR7g7I0C8zBWy/faq2cxDNF9hZVL8TmTeipQbewuVjFQebv4bke2Qka5
         IXllvM+ijWJFeEXCI9HwdRCm2s44aqAa+0t/qznNk1gEkGyLDEX5OcD2RN5ls1TXxkgc
         Eb4DSI9N8h/2dCChTGMOd+u1/z4rgHywkKN1DmZpK8n79mJHzgt/kXCsUjjyNPdSWp6A
         26SA==
X-Forwarded-Encrypted: i=1; AFNElJ9L2tu7OiquBLrn1OREvZqgyUzvBeKSMwqlTKaisfkhbvncKeU8WR+UHH9KV2d4GGIVGKEZG7XnuA==@kvack.org
X-Gm-Message-State: AOJu0YzSaqaCtWOIcRs1qUwdAtZTsLvo0dRIsxtfz+GzoNkiuK73LYy/
	GP8kDMPo1w6u0WONF3066OINFGL2rH8aCo0JsUfpxaabxolPtk9ifN0Z4tVNsf8N5kUEudaXkbO
	0intSXXHVoQT/nwtGzG2v6sE3NUDIaMBhPl2rDVnu
X-Gm-Gg: Acq92OHIcTVLGrFLMuWTU4e77/+wGlvQdGHglfQkJJ1PfiuJecZDbpzK8GwxESI/p9W
	2oW0+4tr1n1beNc+bc7pH98L3kW9uxz2RCxtONscHbnuh/711v/MK0rESjtILcsQCtjogQjDhzE
	Q8btecBnVqTxDHNoixsmHRO/BhE70zOAo5+bEPFN+13sTQlLf5oD4UT0timUjxIObPAEuLUHe2s
	ViMCgMmeQdqwmg+1D/FXGjWdZ/T5tLwK0sj8yb42Jy0iL0egGlITY5Ve+vHbLH50xtkRRWmpMTo
	RGODzrZIXchnj+O4cvY=
X-Received: by 2002:a05:622a:a958:20b0:509:174d:3224 with SMTP id
 d75a77b69052e-516c5467214mr4802261cf.11.1779347400098; Thu, 21 May 2026
 00:10:00 -0700 (PDT)
MIME-Version: 1.0
References: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com> <20260507-gmem-inplace-conversion-v6-11-91ab5a8b19a4@google.com>
In-Reply-To: <20260507-gmem-inplace-conversion-v6-11-91ab5a8b19a4@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 21 May 2026 08:09:23 +0100
X-Gm-Features: AVHnY4Ifhzz--3mXwexBkSyvm4SNx47gRJC3IarQKhzHQwMt2T3d9YqYZRiO-jY
Message-ID: <CA+EHjTyaBpTYsJRRyP09YggoHbi6s-ZgDoWoFgDRxO5k_BkoBw@mail.gmail.com>
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
X-Rspamd-Queue-Id: A406AC0010
X-Stat-Signature: bwnj5pao6sgnhegg9rfs4d6xtkgqjau5
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779347401-667279
X-HE-Meta: U2FsdGVkX18XfgeBY9/1Q9x0I5iEwGNqDxyEtSidNVbOAPx+s5S44fsGCv2nCddpPQM5Fnk1o8vkHgT0AtzyH5DO0PRGDaZJ9u5RaChVF/ud4+xGUPPXCgo48IjPSDePCJpd2grcj9GXz4DHB08O6uvt8zLnWXJdflZgqpjGN1ZnmSCV8pWLJrKRYe7GIvw9VHV13ITv4E22OAeF/cfMX1DiEtNjoy4VSxYkUTBKd5WfJtKACER1rdhpu7wfSsaqXJhLiWjt+Wfm5GOWk8zUNQgC2Us/FItZXhuop8bjpxNjLgr0NWlTEuqTN4Vg7wdUtPyGqGMAyoMWA6VUaa6nYfXtJpq3jr6Ib0ijO/3ycF9XnSt1AGy3Tsy11/RWT1/rHkW1TqwMyPZW03oN2EpsDcYGqywSlllbNsnkpxPyHhtjjnDEI6MSW6qx9GlB4tyUsCGUG9LtQ35tswF4XwyGuB+UX/DI8Vsf73j3nlWGjJPabWofV58HUaRKEB9oxqcElstMLDFafyvka/FI4J9aS0Mc+GtbDXieuqYwCNgI604cDKoPE7o3HoMB7m7+VoqyvQq1InP/mGy+49izzwstU6OB0Hw14B2IK+kzg08UEskE6ctTQ1bVBhvyVi+nhEiGV0MqpiTwaiDeTHR7ppFOKazNpZB8HefoJhbd6067hLdlfwrTRAOkUc84CrYvaIp2uXWCIdnCTjbPiBjS2PygANe7pG23O1ERp4PdVFCIM+lydq6gRw01A2AoQ9tlLur+m94r6eIA1+VpSzMYNe1i2AAiFpuj7ZsEhkS1InCts+CQHU9YbEPR9Q/R8OuzT+2uXivBysOpe/rRYmKXukvjVpZ81QfK4lIPwVDsBISUORe/RMeCWuNQUzwmEP7o2q4Xg8nSKgnGYDl2X6OTVk9T7ZvKezM5HTx4l/U13fHHebpmL768CTkZvuAM/PcC7YXsycZOCSn8Kt46SJxyzEK
 wOju7d0k
 T3U/yl5We/UFBvnqw7MYJsyulQ6QntGMXQi3FvCdkQl0CrXP+Olc2fMYtvd8fL4g9RFD07iYED4TDLGr81FVkNfZtfUdoDIdKV8Rn9BKcfhp+CMbd1T7Hhtrs6t7Wxnn4nNQrzKeghNbnZpi/QSuTEy+zbK0tbcDfU/2mbiXomuCW7r67dUFe0tuDC9csAYzsRB9XlF1nGf1mqyYw+zR4z305jEraoAZamRfH9pkzwjIYsu9Z6g8HOyLCz77kHBOpxBuAU99kuMh0j1o/8hCuWKKeZtfuV+RYj/LDbOYnaS02X6wxYfCbkvFIxOmSrZXcxqwMmolmJH7ezdrftCON7mrzRoskicCigzMSFbGTYxbnfpdAkUrjJB1ybsMw/xjK+SJpIXZryHc8Hmg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Ackerley,

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

https://sashiko.dev/#/patchset/20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4%40google.com?part=11

Sashiko raised a few issues here, but I think this one might be
genuine. Can you look into it please?

If that's right, when huge page support lands, if start falls in the
middle of a large folio, returning folio->index as the err_index will
return an offset strictly less than the requested start. A naive
userspace retry loop resuming from error_offset would step backwards
and corrupt attributes on memory it didn't intend to convert.
err_index should be clamped to max(start, folio->index).

Cheers,
/fuad

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

