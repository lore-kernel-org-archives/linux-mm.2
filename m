Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02F36C5CFDB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 22:08:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC7706B05DA; Thu, 13 Aug 2026 18:08:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5E826B05DB; Thu, 13 Aug 2026 18:08:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 941D86B05DC; Thu, 13 Aug 2026 18:08:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 57B626B05DA
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 18:08:53 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D2033A02E5
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 22:08:52 +0000 (UTC)
X-FDA: 85097636904.27.CE83217
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by imf28.hostedemail.com (Postfix) with ESMTP id 331BDC0006
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 22:08:51 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=S21QVYtX;
	spf=pass (imf28.hostedemail.com: domain of 3cUB-agYKCEY0mivrkowwotm.kwutqv25-uus3iks.wzo@flex--seanjc.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3cUB-agYKCEY0mivrkowwotm.kwutqv25-uus3iks.wzo@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786658931;
	b=F/Dpe1iztu8VbkHQUswFKVKNdlyL5KiVk3Zsd3WgsiYR14SsygWRaDDeDUrVmL0XaWoXws
	bXIfms+jsGjWCzMrP2uK746VJf8xlkAEpAhlbAvKYlGi8c/suSXMK131AHsQkgXzi1M/fR
	65YDHRCJ+9K4II+mayOccMA0/4uqO5s=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=S21QVYtX;
	spf=pass (imf28.hostedemail.com: domain of 3cUB-agYKCEY0mivrkowwotm.kwutqv25-uus3iks.wzo@flex--seanjc.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3cUB-agYKCEY0mivrkowwotm.kwutqv25-uus3iks.wzo@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786658931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N/3XZWjnKAuEX+EJn/U2x2ZdOkAMPrJlBbo8McfTGik=;
	b=HdAv/9j/Nqe5fSdpaA8Gv4o8br7sc2J3uH4I2ho2egnxUnDUP2uteTzKwwh2Ahb2aWwoL6
	VfGZnrtA60oLkkoRrOn7ZPCJkV5KqHIzBWdzoJ92sOJsg4pLkSltoZtJ9ZUiUjn550ZKiL
	PRPAZ4zllbHTCUCzw6QUs4QsMr9TjoY=
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cbedb8673ceso230808a12.0
        for <linux-mm@kvack.org>; Thu, 13 Aug 2026 15:08:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786658930; x=1787263730; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=N/3XZWjnKAuEX+EJn/U2x2ZdOkAMPrJlBbo8McfTGik=;
        b=S21QVYtXjFA2Q5tcCfZpBSvYGVXUANCcZchaIbsQjsqa3Y/F/ZiRhvNAZN+fAQYN+V
         oV2QBxpxUkGhiYh+o6WyOIY9bEhoGPZtfGmcnkH9myJ9J1RF7TXh5oz30wnu3CCrqOaj
         qRK1nXjrADikW5chYZCX0k6Xzl4MM7HX1LGbG3C1ozdv1tIxLgG2NocMnxz0NRTARCXU
         aA4rp+/Bnt/ju2G6E/yoy9xx9KgOWtPQdE0nX04WNnad5m0ajREJEbCZyPk5Bu9J5K8U
         ZrDkRJ64CSHz+4r62a/7pnogpaIRncOsX66wuzllFmLu4l2bhvMYsre+blCQJuirbGZY
         uqjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786658930; x=1787263730;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=N/3XZWjnKAuEX+EJn/U2x2ZdOkAMPrJlBbo8McfTGik=;
        b=ZWnSpcna/uvTIx6PjpZs5OMyfRL64AWMij5eBenINNuK5C0HTCn7eC7nxZskcIhjTg
         O5yzlKX6ZO6f1rR7MSalm3/nmARum/HdfbMqhXzU8Dyt+5HGDBOoq0+U5d1jO1O0Abdl
         Z47OevVNhD84SJc1bkmg3VnGSFk4QQTFy1VAPfzk8wVCxuckqaBzf2ISasLQMj3duDoW
         HsUglYYnHGNrKQlBhrl9TimDDKhJaL1b8c065t2/T0/ghaHu4zohX1N6ohXjYw4DvAI1
         5AsgzqojvgZ19WkcBEF+T+S/tlNB5w2L9omdXTx0xzjGtQcsgU+dR1D0uwXogE/25gQC
         cPjQ==
X-Forwarded-Encrypted: i=1; AHgh+RrPk7aQDHu1eq79UUlYutD3kOwkr6JAO1jR0rUa6JzBU8xWctL06MPkasc/kWzWeB3plvk15JGApA==@kvack.org
X-Gm-Message-State: AOJu0YwPNfFMoSOAPoPLJRB74o7iw+UVIKcqiLLFQtWWJ9E+tI5u5pIL
	z+ZdUtYuMXumKwE4x9hd6uMhoCrcL2+koxz7qIbNG7sA8djQCxNgLbPTsf1NG539F5KnshqxkX6
	0BRnLlg==
X-Received: from pgcd20.prod.google.com ([2002:a05:6a02:4c54:b0:c9e:41e5:2eec])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:6a21:b0:3b5:489c:7bb5
 with SMTP id adf61e73a8af0-3cc71d1e1c7mr839682637.28.1786658929498; Thu, 13
 Aug 2026 15:08:49 -0700 (PDT)
Date: Thu, 13 Aug 2026 15:08:48 -0700
In-Reply-To: <CAEvNRgGpCVCGVjc9jCt9Yr+XypF=71h6eBahkXNkrXhfrtGY+g@mail.gmail.com>
Mime-Version: 1.0
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
 <20260807-gmem-inplace-conversion-v10-12-2fc18ee6d3ba@google.com>
 <1ec08cd8-3072-4753-ad5e-cd34956647f8@linux.intel.com> <an3o4h-E8mj6CUaM@google.com>
 <CAEvNRgGpCVCGVjc9jCt9Yr+XypF=71h6eBahkXNkrXhfrtGY+g@mail.gmail.com>
Message-ID: <an5AcEG9mqDgnBYk@google.com>
Subject: Re: [PATCH v10 12/41] KVM: guest_memfd: Call arch make_shared
 callback for to-shared conversion
From: Sean Christopherson <seanjc@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: Binbin Wu <binbin.wu@linux.intel.com>, aik@amd.com, andrew.jones@linux.dev, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
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
	linux-coco@lists.linux.dev, Fuad Tabba <fuad.tabba@linux.dev>
Content-Type: text/plain; charset="us-ascii"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 331BDC0006
X-Stat-Signature: m1yhgwo77t5ydumg3ntrb1e8stwpamr7
X-HE-Tag: 1786658931-352803
X-HE-Meta: U2FsdGVkX19ty4OnCMTILPtVKip24yT/UfJSw5jEZAhKoottMY2DClA01Dh0+RwPboPiS5OpHg4LIKFslQ4FvvnYk10D3bGzDfBeIr+atQeGM5kew41ktTsBHcERDZwL+5BX3eG7lEviZe2qL+fzHqyCf/DEybQbJff9O9RaEO+nwmKJrU+VSfomP0akA68Und3w8tjkHiOL69FT7c3uJTzf5XbbRd2ZNyPr6nh+8xoDVGyCTRDSNKouSlcuV487brvexOksY8Wd8XEAw9qs15rjsdXqqeEYLWwgp1/1T+hKEQKWBDTR8akImUOtxhfK4ap3E2dmOtpVHKCgvWsrM+KPqHb+rcw9BdXzcjnqxGeuaNmRuN5F1b7mK+DtWkpZq6U8Dm/FIVWL4vBcK4BN7ZutQrbq3cx/vZiaYtW+1RnBooGr+w4VGa0NioW+nw/DAkJ+ogk+CMokSQE3/axPprGQOuxqp5vcxB+YLwUf78diUuFE+ieJyKTWzqkVZSjBVABOfbW+B/w9c8UULbWgIFgL11g0qsedBUv4xZOrGl9GmxaxGtLA9osxBv4tQxoR0cJrwCmPiRzd6L4Y8zOEKyb4pujituzz41D1iz7Us2btQeEtTbpLC3/png5ETpx0sytuFMuiALcePBa1trNSxDzd4+Xco1Mlsce3VTr8p4Duv24M3DaGbTFEDQPIto/DjqL/yL4Mo5+NVEjkIzdrbdAPW/e1lwMQSbyeEiaK8naNVQefqwj/PIjl54SqlsagbknD5MW6JekdAPDdmJ5P+7uk0gNVmxko/6IzJYKY+2z77ahVWpyvsgkojPj02Oxkn5pht8IyA7lnxG7IrvqlAPtcFmD3sCghpXhX63z5Blb7LNlT6f3HWqQMMwhLCa61fq/S/IdR2ppgQtguA3n7K8W/lkle0+iXmSqst2t2Bko2YgQ6sPmlT/7atxwGNnBLdxTNYL8r+XEKicLrP0k
 +PvqQ119
 79WDO8LT63sFf7StShy0y/DumVEa8TcVxAUfMrEHDibEZ7PFM19kF5RbAkfytYRdcWwqcUZxxQT+9s58sA2DBV1dF/znXujhZtjIU46aLw8Klgr8BMJl3YPE1wKrn64gxg90bJ8FH/D89zFTBDQZR6VqPgl2JRqOrvGAgQuzy2czy6jfSPEF+kia5k6zVmldMFDz3EK2LH71fKXoLXZgQzW196OcFQ0/JxpQCg34t9PvAJLmskP+n4j+3HqKJTNeUm8rP+cyT4GtmVkFHljY/cK1bho8vBrS5iKO/yXOFfi/eDksZsyiM2pDzkWGQL8NXSYDepRlE9wowOtY+BG0Hj2ZHMI9Q6AMWhjylLRsljSLMe1iK0g8ui2qz55SCZqlV51zGzbaboYcf5IZ191GbGhldbLTIUEbu43oopAClhAtEQ6WP43F12/RZ2IlPuQxf3ioPgQMlRt1hWqcD8P3K/D1l5SuXueuARK5sUrpXu3+Z/8+GbKPy3CVa3/sj4jn6OlbRUwCF8gKreUq8T19quQWwREMouCaMuiZw6eSpzTqM6eFbV1chxlUFSfTliG5jM4ZR0S/CiNlcB78Kz+qPIbkYjulC8NvLtN7liJy+Mmt9TIz0HZvxC4JovCR8Z+zoywoKBWTAKGf/mEX49N9ud5fyvTPpRm717zZR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 13, 2026, Ackerley Tng wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > On Thu, Aug 13, 2026, Binbin Wu wrote:
> >> On 8/8/2026 5:52 AM, Ackerley Tng via B4 Relay wrote:
> >> > +#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT
> >> > +static void kvm_gmem_make_shared(struct inode *inode, pgoff_t start, pgoff_t end)
> >> > +{
> >> > +	struct folio_batch fbatch;
> >> > +	pgoff_t next = start;
> >> > +	int i;
> >> > +
> >> > +	folio_batch_init(&fbatch);
> >> > +	while (filemap_get_folios(inode->i_mapping, &next, end - 1, &fbatch)) {
> >> > +		for (i = 0; i < folio_batch_count(&fbatch); ++i) {
> >> > +			struct folio *folio = fbatch.folios[i];
> >> > +			pgoff_t start_index, end_index;
> >> > +			kvm_pfn_t start_pfn;
> >> > +			kvm_pfn_t nr_pages;
> >> > +
> >> > +			start_index = max(start, folio->index);
> >> > +			end_index = min(end, folio_next_index(folio));
> >> > +			/*
> >> > +			 * end_index is either in folio or points to
> >> > +			 * the first page of the next folio. Hence,
> >> > +			 * all pages in range [start_index, end_index)
> >> > +			 * are contiguous.
> >> > +			 */
> >> > +			start_pfn = folio_file_pfn(folio, start_index);
> >> > +			nr_pages = end_index - start_index;
> >> > +
> >> > +			kvm_arch_gmem_make_shared(start_pfn, nr_pages);
> >> > +		}
> >> > +
> >> > +		folio_batch_release(&fbatch);
> >> > +		cond_resched();
> >> > +	}
> >> > +}
> >> > +#else
> >> > +static void kvm_gmem_make_shared(struct inode *inode, pgoff_t start, pgoff_t end) {}
> >> > +#endif
> >> > +
> >> >  static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
> >> >  				     size_t nr_pages, uint64_t attrs,
> >> >  				     pgoff_t *err_index)
> >> > @@ -599,7 +636,12 @@ static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
> >> >
> >> >  	filter = to_private ? KVM_FILTER_SHARED : KVM_FILTER_PRIVATE;
> >> >  	kvm_gmem_invalidate_start(inode, start, end, filter);
> >> > +
> >> > +	if (!to_private)
> 
> Should I make this condition
> 
> 	if (!to_private && kvm_x86_ops.gmem_make_shared)
> 
> instead?
> 
> Will that help?

No, because that's bleeding x86 details into common code, which defeats the purpose
of arch hooks.  That's why I think it's worth analyzing the cost: if it's in the
noise, leave it alone.  If it's meaningful, figure out a not-too-gross way to skip
the entire thing if kvm_arch_gmem_make_shared() is a glorified nop in the end.

