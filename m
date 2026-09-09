Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A42D4C79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 15:52:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AED7D6B008A; Wed,  9 Sep 2026 11:52:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A777C6B0093; Wed,  9 Sep 2026 11:52:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 917436B0095; Wed,  9 Sep 2026 11:52:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 566D66B008A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 11:52:34 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8E7EDA425B
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 15:52:33 +0000 (UTC)
X-FDA: 85194666186.04.61C7C61
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id AE8C94000E
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 15:52:31 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FQBsMdka;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788969151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u91uFesTnFbGp/0SROsL3Fce0KUie7u3CWxoraS7oAQ=;
	b=jsFMcFzANBjy6Ho0876zbP6QMyxuMbdn7Z/rquCQITdFgDjaq83QVXo1oXEJErwzpBucOv
	wAArRGkCGuwdKC1M0dv9DB+Eaf3A2lxTn3bJU3wlEclcG3npW62VSJq4m71v+XT3hCgH+k
	ypkHImshqMFXhb1J7/v86fwhWBY3vMI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788969151;
	b=mI2H9rKHgBhgGpj7sj6tbwyRtWx56Qqr5y1870bDvCk87qAf4NB4TnBeEL8bCWJXpY02it
	6cKcHU3SuVUekHRchi05niHXiJoS9N4W/R7f6lsc14/7UtAux1Bf4kSzDD84kPhrtb1vB3
	kTyE77kM9nWuZ0mEPa6/XCSGWL4Yrb4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FQBsMdka;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C50C643CD0;
	Wed,  9 Sep 2026 15:52:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9D481F00A3A;
	Wed,  9 Sep 2026 15:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788969150;
	bh=u91uFesTnFbGp/0SROsL3Fce0KUie7u3CWxoraS7oAQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=FQBsMdka6q3yJt4PU5XM/w8brLU7gUN6lqri9XYHBVnNyH62B5rbtWvnsDcuDDstR
	 yUYGausmecFcZ01xcp9jcXh6Ho5wsTQC/KHLYEhhxTdAcpoZL5xbh02s+2mdoJKJ3H
	 Cp0MTYHR4h+lAxicsGveorC67zzpo0UPgSBxoxYCK68UEpTQW1y77SCx6ZwpV/csrz
	 raXx29Z1Se41gtjEI1U2vIhXIn7MET8plb8HrdSDx/6+Iyyu8xI3OQ7cdLk6+LSork
	 xm7TREyRSVsrnCKckGjwZONbqeCoEzk9VmOK+gkVKpkdILm+SY4p/AoaYniCXdOkqG
	 ruQAOmRiKrwxg==
Message-ID: <13f2c56c-b55b-4245-8190-7038f4eab98f@kernel.org>
Date: Wed, 9 Sep 2026 17:52:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 18/45] KVM: guest_memfd: Handle lru_add fbatch
 refcounts during conversion safety check
To: ackerleytng@google.com, aik@amd.com, andrew.jones@linux.dev,
 binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com,
 jmattson@google.com, jthoughton@google.com, michael.roth@amd.com,
 oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com,
 rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com,
 steven.price@arm.com, willy@infradead.org, wyihan@google.com,
 yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org,
 suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org,
 Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
 <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>,
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
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, tarunsahu@google.com,
 Randy Dunlap <rdunlap@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Fuad Tabba <fuad.tabba@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-coco@lists.linux.dev
References: <20260830-gmem-inplace-conversion-v12-0-85e5fd25252a@google.com>
 <20260830-gmem-inplace-conversion-v12-18-85e5fd25252a@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260830-gmem-inplace-conversion-v12-18-85e5fd25252a@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: AE8C94000E
X-Stat-Signature: eoopz7cwo3ux4mt6p5oy9z864yn531e3
X-HE-Tag: 1788969151-462800
X-HE-Meta: U2FsdGVkX19FlH/7BD7FVHZfauSyHs9c8ytNBYXGrJ4rb0SUnDRuix65ZKg6rPPsrfR+NXKkbxUKKX19jmIAyegGcp8unsmA9He1LxQmgOhl9wDo1AP3577AXBZPSnkECb8TJCa3QcbgwOA5up8eSmzBcHvD4QIh1jnxeAvd7VRVG9+oIUFcETBekK5W2xdP9sl63DMwyVzcmQnucAkHzBR6FOH81avdZZFZzLJ25peMJUxJt1MaX2QZMbrpzYMcIEqjdZ9KZwnIqwGgq/W3r6CzwILZs0Xg/AEG/J99qMY4AHSbBQPjw+KHqk5/TtH7QjVlS6Ve5VhzcP5qZ6e6/nCrOVmuGLZEs72FYvX0owre9cbDevSaS7Mt/h2YShlbpoxpy2OJY0c6lQPln487OD2febonC3/FCGKhikFAtjsvFncMLpnrnpuGYEGuzppcl7ehc77b7krnZt4+geUueByOaYEqPNsLUAD56mIeewP9PHTOrskroMr2etMgafaAtUdzK2OUWV/TjhGJoXnV/Mq3ZvzDtEsA9fW9Fb3diNFz5d0eyM5gOhX7NFRGJ3i8prdVNAckvXn1/lfdmBmqJPVY17vwY/t+T5XAdGBxSIMWW0pTO0IWOQVKIhXK0h1jvKOFVJkk6vQQzwq5NIWswt10nfDlqxr6bhT282nNoKY4NqzsmGjmr3s/BktK8tVhstdOtaC5BkMY9hLflhgK6FITpL0YCkVVqNdqV17NARvpgtxcMR9JA0V/stpQcQoJ8zCK8dfwKKkqWS7dJMzChfc7GMrja8rnm6FPv8l/mJepUKMbE5bJhmbvImsJTsCL8fCNbZ4duDTbX+IkAEGeh8mq1KXvGCG+6T1z3ommmApYUh8dkW0UFEDSLYxyl+UGZWTzvZQun0vvKH/b1hqGh7PBmTLx0QB41TQvHBSkn7+N6tNukuImpFc/VZ3dwTMo+i6/tr+dDFhnxLADK7v
 BDl0CWMv
 VA+zKW846ygyxNzYflLY8TnqUf0uRe7t9QmhsV+U4tSolcj+Ldl0SB+Z6W5RvXIeaGUUuWypcBLMjz4fU7+ugL0/pjjZq8oc/GYTI+t7lHgprXgRK5sAYSxnJ8pdZIDY78CsaCd/PGASeAKXwSTK7/A44U8R7HHcF7J3LE9lYti89+kmT7CIjqsnwpjD/hGNcB/q+XzqlpejEyelRjKsqWto3FFVk00avVsYl2q8Twwxr6VunOkMU49IjwFqTXW4JxwZ3gyyes8Pkkg9ja5G72pAmBqA8xaArkT/TAXi5gejnDi5dmrxpvpQswmibtUB6wr/gRhCzSvvo778=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> +
>  static bool kvm_gmem_has_outstanding_references(struct inode *inode,
>  						pgoff_t start, size_t nr_pages,
>  						pgoff_t *err_index)
>  {
> +	enum lru_cache_drained drained = LRU_CACHE_NOT_DRAINED;
>  	struct address_space *mapping = inode->i_mapping;
>  	pgoff_t last = start + nr_pages - 1;
>  	bool has_outstanding = false;
> @@ -570,17 +589,12 @@ static bool kvm_gmem_has_outstanding_references(struct inode *inode,
>  	folio_batch_init(&fbatch);
>  
>  	next = start;
> -	while (has_outstanding && filemap_get_folios(mapping, &next, last, &fbatch)) {
> +	while (!has_outstanding && filemap_get_folios(mapping, &next, last, &fbatch)) {
>  		for (i = 0; i < folio_batch_count(&fbatch); ++i) {
>  			struct folio *folio = fbatch.folios[i];
>  
> -			/*
> -			 * Outstanding references are anything other than those
> -			 * from the page cache, plus 1 temporary reference held
> -			 * by filemap_get_folios() in the folio batch.
> -			 */
> -			if (folio_ref_count(folio) != folio_nr_pages(folio) + 1) {
> -				has_outstanding = true;
> +			has_outstanding = __folio_has_outstanding_references(folio, &drained);
> +			if (has_outstanding) {
>  				*err_index = max(start, folio->index);
>  				break;
>  			}
> 

Having the folio.c bits go upstream early is certainly cleaner; without Hugh's
series an ack from MM maintainers would have been sufficient, though.

In any case, on the revised patch with only guest_memfd changes:

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

