Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6158CEACF9
	for <linux-mm@archiver.kernel.org>; Sat, 15 Nov 2025 00:47:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 264168E001A; Fri, 14 Nov 2025 19:47:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 213BD8E0005; Fri, 14 Nov 2025 19:47:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1033A8E001A; Fri, 14 Nov 2025 19:47:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EF2DF8E0005
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 19:47:00 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9543D896F6
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 00:47:00 +0000 (UTC)
X-FDA: 84111001800.27.A4139DA
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf22.hostedemail.com (Postfix) with ESMTP id D7B40C000A
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 00:46:58 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=lnGdJA6T;
	spf=pass (imf22.hostedemail.com: domain of 3gc0XaQsKCMoqs0u71uE93ww44w1u.s421y3AD-220Bqs0.47w@flex--ackerleytng.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3gc0XaQsKCMoqs0u71uE93ww44w1u.s421y3AD-220Bqs0.47w@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763167618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mr/52DwIA8Vew8AuO0L8R6bm0vR8dQ+5A9WA+WG6t/s=;
	b=MzKhbl0GJgb2tKpswU5+fCQ2DOCQleTR9+tpmCn+j5tjIic4iwyXTCz3WM4t9YlXH4HdZw
	TuFmKNRiyPJKB8ht1bumvXPxSK2faB3B6u1UA3kW9SeQ3wpEPJh6wpNrFbQyDkfT/XAazO
	WwV1SNM2hij5u5RM5vRuWwD3KtAwiCQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763167619; a=rsa-sha256;
	cv=none;
	b=lBudM9AXwRBpvVpQbrfG4bg+GXZw4ybw1hddd61FpjVhSzsqbUnc6eCOHeSBivWLW7PQ8o
	FVb20izLyNgY11ccL1MkySmeCNN2isghon6Cy7gr/wqk4b18MiiLR+IVXPYdch6UIlHYMh
	X2ewwXClEezWxbbpfRe5nwI8DnBfXtw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=lnGdJA6T;
	spf=pass (imf22.hostedemail.com: domain of 3gc0XaQsKCMoqs0u71uE93ww44w1u.s421y3AD-220Bqs0.47w@flex--ackerleytng.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3gc0XaQsKCMoqs0u71uE93ww44w1u.s421y3AD-220Bqs0.47w@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-340bb1bf12aso6171740a91.1
        for <linux-mm@kvack.org>; Fri, 14 Nov 2025 16:46:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763167617; x=1763772417; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Mr/52DwIA8Vew8AuO0L8R6bm0vR8dQ+5A9WA+WG6t/s=;
        b=lnGdJA6TU8eKSKoGa+N80kcWIsNXtzsCB844jEh3HYbic+3LkuOC3TJWYMTMMnA+xN
         Wn/rdwnMGDG5OQt5+SlCqFlqMly8vJqVXNQ2QmTQSUG0hD/rlKjevBTePJ4aeDQpRbyj
         j65v1CH5QgdcPDFsPy6+6Jv97zFNPrh7pmmCb8RsaDg95BYCVH8LHGKgChA/YKjeBdeh
         iAJIX0wZQygkasQ4fsGxtgIWuGuvjFNA53CW1MfiUuErrKnUVdLYbHUemAkdoXdwfEpc
         QXjaEM25MYgL1MMuTL+CT1Y7/ELQG/8W+XoJM7BmdmdMM/hIpDPmDODHl0yz+nGjW70R
         Clcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763167617; x=1763772417;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Mr/52DwIA8Vew8AuO0L8R6bm0vR8dQ+5A9WA+WG6t/s=;
        b=UTZVqr7Dh5Y48D3GFiwj5SCCvX2u6WXRutE+67e0q6wu++rTT5Am0RDH/1OyMMFk/r
         /7tSXyNk22DjKJ+tARZv1cgB9tG52xCIhiIAsb61BO8GyiNx9p/FQKZlbtW5sNKc47QV
         2oPskhdyzDkQYlhpAo/kSTmThO0ITBNMNIT7V617R979bATZWPnqjoFD+rB5qk6Gwfee
         cgGR8XJqlrqXVc3r0gWkFUfavavHuAmz6QjFd1w/dBKoIML+XMFJL9jBCBxue+aavAXg
         oJMOBuDYpzOo2BtXifsBZ/FX7E8oUhbgfyWKU0aqM9JRzXgISEXuAR/Hz9beULivL3Xk
         95bw==
X-Forwarded-Encrypted: i=1; AJvYcCVDLFKXymu3T4CS4ttISiSFSUflOUEgUsz8LBNW+ph8diHQ4bJGuA7nBEl4SkMvgp0//sFuwDulMg==@kvack.org
X-Gm-Message-State: AOJu0YwlK3ISeggYDFt3nkGUQMaJq/wYulxA0rACzot2QII/HEI48Hvg
	8VjJcnWO8TJ9iOesrXb8DrGIpC7eYg9zOZ1BKnMH8d7MLAuNW/NlNuQazST7x26C5OTong9GzZv
	O2ylJnsgYfAloJW9zeY2AnPHGPQ==
X-Google-Smtp-Source: AGHT+IHPDsoGUhVWbmh0UerKKIaGr6kr4KuHT3qBmIvhj2MnXtnNCORQphwRQGqEcjJQnhvfFDaRm0g88w6S7pk3mw==
X-Received: from pjbdb8.prod.google.com ([2002:a17:90a:d648:b0:343:5c2:dd74])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:1dc9:b0:340:29a1:1b0c with SMTP id 98e67ed59e1d1-343f9e93781mr5917746a91.7.1763167617416;
 Fri, 14 Nov 2025 16:46:57 -0800 (PST)
Date: Fri, 14 Nov 2025 16:46:56 -0800
In-Reply-To: <aQnGJ5agTohMijj8@yzhao56-desk.sh.intel.com>
Mime-Version: 1.0
References: <cover.1760731772.git.ackerleytng@google.com> <5a4dfc265a46959953e6c24730d22584972b1179.1760731772.git.ackerleytng@google.com>
 <aQnGJ5agTohMijj8@yzhao56-desk.sh.intel.com>
Message-ID: <diqz346gcebj.fsf@google.com>
Subject: Re: [RFC PATCH v1 11/37] KVM: guest_memfd: Add support for KVM_SET_MEMORY_ATTRIBUTES
From: Ackerley Tng <ackerleytng@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: cgroups@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, x86@kernel.org, akpm@linux-foundation.org, 
	binbin.wu@linux.intel.com, bp@alien8.de, brauner@kernel.org, 
	chao.p.peng@intel.com, chenhuacai@kernel.org, corbet@lwn.net, 
	dave.hansen@intel.com, dave.hansen@linux.intel.com, david@redhat.com, 
	dmatlack@google.com, erdemaktas@google.com, fan.du@intel.com, fvdl@google.com, 
	haibo1.xu@intel.com, hannes@cmpxchg.org, hch@infradead.org, hpa@zytor.com, 
	hughd@google.com, ira.weiny@intel.com, isaku.yamahata@intel.com, jack@suse.cz, 
	james.morse@arm.com, jarkko@kernel.org, jgg@ziepe.ca, jgowans@amazon.com, 
	jhubbard@nvidia.com, jroedel@suse.de, jthoughton@google.com, 
	jun.miao@intel.com, kai.huang@intel.com, keirf@google.com, 
	kent.overstreet@linux.dev, liam.merwick@oracle.com, 
	maciej.wieczor-retman@intel.com, mail@maciej.szmigiero.name, 
	maobibo@loongson.cn, mathieu.desnoyers@efficios.com, maz@kernel.org, 
	mhiramat@kernel.org, mhocko@kernel.org, mic@digikod.net, michael.roth@amd.com, 
	mingo@redhat.com, mlevitsk@redhat.com, mpe@ellerman.id.au, 
	muchun.song@linux.dev, nikunj@amd.com, nsaenz@amazon.es, 
	oliver.upton@linux.dev, palmer@dabbelt.com, pankaj.gupta@amd.com, 
	paul.walmsley@sifive.com, pbonzini@redhat.com, peterx@redhat.com, 
	pgonda@google.com, prsampat@amd.com, pvorel@suse.cz, qperret@google.com, 
	richard.weiyang@gmail.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	rostedt@goodmis.org, roypat@amazon.co.uk, rppt@kernel.org, seanjc@google.com, 
	shakeel.butt@linux.dev, shuah@kernel.org, steven.price@arm.com, 
	steven.sistare@oracle.com, suzuki.poulose@arm.com, tabba@google.com, 
	tglx@linutronix.de, thomas.lendacky@amd.com, vannapurve@google.com, 
	vbabka@suse.cz, viro@zeniv.linux.org.uk, vkuznets@redhat.com, 
	wei.w.wang@intel.com, will@kernel.org, willy@infradead.org, wyihan@google.com, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, yuzenghui@huawei.com, 
	zhiquan1.li@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: mrjn4uutt5wyefqt5utgk7uwibhxadup
X-Rspam-User: 
X-Rspamd-Queue-Id: D7B40C000A
X-Rspamd-Server: rspam01
X-HE-Tag: 1763167618-165821
X-HE-Meta: U2FsdGVkX1+KvTx3TiOyG5K+kCJ0YeIYWXAYOIcidvU7Tqs/GqgysnMEiNy9N6/AO6OU/trX0WtALV1wZ+x+FR1qlR1fPSIlTNZJ+powY6Bs0Gs3CYPHy9KZRly8Itgc5SrXJ5mfCVwKlajbz6JkLpLrpyYaQ1eFuWmGO9ZfrZVbRt/R3o11LnuXvuYucaWK15K95ddMBi1u8tdAgkOq1nlYuF2Qjq4RhGAq0jtlsUt/UOo+sEicvSxGuzcCZMqPA4LFTJ1Cl5w04eH0IrmGGvR5aDRIlGioLWb27laaynyDzTi5g9dglRSPB0ASSYC6inkDH/mELmdEm9wexUcQj2SPuX0PNb5g09PFLbIkAxhRHC/JgaKNk0SbQLZchz11163rnT1Yfcsow5TOxctT9a4KmLzb695MrIuSHcUPaIcKxJHaKNQqsvt1WH3yGSJxI8OxPcN4FuGp+tp6r01xyBDJ0b9AfkIwtWqlQvJTtddkklv68jeljEEVQ17EjyyjY469xRUzfR+JzQHXjEKgH3xHdgm9x7huIKUeWvgv3Jk4sAHO7NqFt7XrpAKzunEBwdDVQRfvTrgFxxpSnDsyrk1eZnM4KjKWtTnrqjDhIfTTmSCXDmGfbqgMiEH0HiwiTfcOwC2Rjcfcx6Ie3eHbSSZLiLHnC7aLfQSOJm8eVyxOGFHbaxsb+JgTxyoVc+VZUUq8sK8JAvA0q5NL8gCDP/AjMOiQ4ZOJpk2ioIBFHVMvQdTWmJbTGltp5tUsYRwuoGByoWdy3dl+9MS6WmbTtsofwV5HngCIGoc7YjOK/VbIx5ZNfdft5vwAStjE3OHFK4IDz+uADAJU/9dyEu6bZ0dwcZOqv1x9LZ2dEnlMMlz+DTZPSOh/3EjMg0y7zQAtN2BF6O7FcqlhH+oh/g93qiAuMs6lMJVqit1rqjnNnNXt2xfNBlNkqjI9Eo6SObOTFTrhFebDnK7E6xkbgXk
 VmH+LfyP
 I4k6CE6Qrngqgewz5KHaPzv3iUfHCTKCwa463yNpqLLCWaqHqLEe/yXqHNbOeD+/KmCmtlMl2T6YE8fZVwXVe0FmmRCJGmc8OvD2y/GPtITjGwjFEbYrLqEukwvIjC7ao4ODyJO6fSaRM+Q+DFoAHaU96k5YCrPH8rhnpjqj3q1gtpLnm3L1yoefjTbN43z3zrMTikB3iBEbLPyUQTpFci0WNTf5DZQWB9FoGhzQz1Swnv9Vj3IhKA96xBde9bcASyNGVKd0h4CGzrSJn/eup13CaYPPynxZAFZgZVhlUbrMlULc5IISJSRTgRuITSo1YVSsvbQyIK9sk6F/RZ63LjEs84lC1iowFsd20XxdTodXAvgNRiVQByC2ppQ1jtpWHJNCSbPfaj4rfr5O+PipwrfT82v86V/ixFRBUSENtblKo9soKUwivIFrXSJ33a05BaeUUqKpMCG75sDm9JZJjb5ScNRcRAg4f1shzQ7zIez7KQHx6IgrS4cm0tFfZDrPBNi4oALNPCcyKdoRDWGoFek9CemmqHaSfth4tBbP99096hy+aCj1NZ1/yjuy5z5TqG1nUDmjgvGA/YLN7mAKmGqzUGum9Pg28z5iul2BXuEwg7GDN/JGiUFmL46Wn1X/uZyCR5awmAumf/OIHpmQ3xRJu9d9wh1GSocMpEoqQT3++XWGDpEsiZ7WcSFi6oXAj0WcCzm85F1wNOyJgv/OUH2WyvP96DOQt2S8BdKlXu/5aTgbTHloE9OSfS3c+Izej9R6EvjvJ4IgGJKw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Yan Zhao <yan.y.zhao@intel.com> writes:

> On Fri, Oct 17, 2025 at 01:11:52PM -0700, Ackerley Tng wrote:
>> For shared to private conversions, if refcounts on any of the folios
>> within the range are elevated, fail the conversion with -EAGAIN.
>> 
>> At the point of shared to private conversion, all folios in range are
>> also unmapped. The filemap_invalidate_lock() is held, so no faulting
>> can occur. Hence, from that point on, only transient refcounts can be
>> taken on the folios associated with that guest_memfd.
>> 
>> Hence, it is safe to do the conversion from shared to private.
>> 
>> After conversion is complete, refcounts may become elevated, but that
>> is fine since users of transient refcounts don't actually access
>> memory.
>> 
>> For private to shared conversions, there are no refcount checks. any
>> transient refcounts are expected to drop their refcounts soon. The
>> conversion process will spin waiting for these transient refcounts to
>> go away.
> Where's the code to spin?
>

Thanks, I will fix the commit message for the next revision.

>> +/*
>> + * Preallocate memory for attributes to be stored on a maple tree, pointed to
>> + * by mas.  Adjacent ranges with attributes identical to the new attributes
>> + * will be merged.  Also sets mas's bounds up for storing attributes.
>> + *
>> + * This maintains the invariant that ranges with the same attributes will
>> + * always be merged.
>> + */
>> +static int kvm_gmem_mas_preallocate(struct ma_state *mas, u64 attributes,
>> +				    pgoff_t start, size_t nr_pages)
>> +{
>> +	pgoff_t end = start + nr_pages;
>> +	pgoff_t last = end - 1;
>> +	void *entry;
>> +
>> +	/* Try extending range. entry is NULL on overflow/wrap-around. */
>> +	mas_set_range(mas, end, end);
>> +	entry = mas_find(mas, end);
>> +	if (entry && xa_to_value(entry) == attributes)
>> +		last = mas->last;
>> +
>> +	mas_set_range(mas, start - 1, start - 1);
> Check start == 0 ?
>

Thanks!

>> +	entry = mas_find(mas, start - 1);
>> +	if (entry && xa_to_value(entry) == attributes)
>> +		start = mas->index;
>> +
>> +	mas_set_range(mas, start, last);
>> +	return mas_preallocate(mas, xa_mk_value(attributes), GFP_KERNEL);
>> +}
> ...
>
>> +static long kvm_gmem_set_attributes(struct file *file, void __user *argp)
>> +{
>> +	struct gmem_file *f = file->private_data;
>> +	struct inode *inode = file_inode(file);
>> +	struct kvm_memory_attributes2 attrs;
>> +	pgoff_t err_index;
>> +	size_t nr_pages;
>> +	pgoff_t index;
>> +	int r;
>> +
>> +	if (copy_from_user(&attrs, argp, sizeof(attrs)))
>> +		return -EFAULT;
>> +
>> +	if (attrs.flags)
>> +		return -EINVAL;
>> +	if (attrs.attributes & ~kvm_supported_mem_attributes(f->kvm))
>> +		return -EINVAL;
>> +	if (attrs.size == 0 || attrs.offset + attrs.size < attrs.offset)
>> +		return -EINVAL;
>> +	if (!PAGE_ALIGNED(attrs.offset) || !PAGE_ALIGNED(attrs.offset))
> Should be
> if (!PAGE_ALIGNED(attrs.offset) || !PAGE_ALIGNED(attrs.size))
> ?
>

Thanks!

>> +		return -EINVAL;
>> +
>> +	if (attrs.offset > inode->i_size ||
> Should be
> if (attrs.offset >= inode->i_size ||
> ?

Thanks!
>> +	    attrs.offset + attrs.size > inode->i_size)
>> +		return -EINVAL;
>> +
>> +	nr_pages = attrs.size >> PAGE_SHIFT;
>> +	index = attrs.offset >> PAGE_SHIFT;
>> +	r = __kvm_gmem_set_attributes(inode, index, nr_pages, attrs.attributes,
>> +				      &err_index);
>> +	if (r) {
>> +		attrs.error_offset = err_index << PAGE_SHIFT;
>> +
>> +		if (copy_to_user(argp, &attrs, sizeof(attrs)))
>> +			return -EFAULT;
>> +	}
>> +
>> +	return r;
>> +}

