Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A60DAF47CB7
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 19:07:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AC536B0089; Thu,  5 Mar 2026 14:07:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0936A6B008A; Thu,  5 Mar 2026 14:07:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E30EE6B008C; Thu,  5 Mar 2026 14:07:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CD0B36B0089
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 14:07:56 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8C926160232
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 19:07:56 +0000 (UTC)
X-FDA: 84512944152.24.FC18A5B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id A43A7140018
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 19:07:53 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Dj+S9NqJ;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772737673;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TPptAqQRbsvtF5CPju5gas6bGn5iTFeGYsXCc/CnCs4=;
	b=gtwifuvu6Hjauxql+5Ho8YEYAOO8u0VpkhTuJ4AgiQVyXkqQC+Q+SHfPNuK4jJb3K1ae+8
	87isYHlp1oKWwFKp2nKmk9XkCMqmbHsz8aRDQJRE5maQbG/3Dt3GSNKzmtw/CDqmmRqCt4
	+fnMu4+wplOQl+XYS0uUftWxTbcp6RQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Dj+S9NqJ;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772737673; a=rsa-sha256;
	cv=none;
	b=FLP/xKKTVZFngb3CsalTfwSfZeT/kZjSTpzEqCwDq2LENQ/VQY+Sx+zE/JL+Q7yEElLsy1
	PUPtwXc7yPF+4mHsMSGb5MumoOCtoz7/ucNycgimZXJqRnJXKqfQpuKjLtFdBr3exUlNwK
	U9KhOhalMiwCB7Dhe2aFPsG3it4U4gU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5D78D40713;
	Thu,  5 Mar 2026 19:07:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DEB6C116C6;
	Thu,  5 Mar 2026 19:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772737672;
	bh=5pMLMYsqUq30caMaqSsCRxg/LUKm2ZwH02Nogw/kZgk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Dj+S9NqJtdWz6RBKFzR5acMgUZFQJ3W9fnbktBvz0MaAXoouPnMmfQ67JZmI9sVaH
	 XQQn6nGUQIhWbu93psky7lo+eqRxXjl34agykwtcFCvJvewXz2H9sBqggtK338M1DH
	 xMqK0z98I7O58rU2ZExHxgDfn0muFBjv+va4ZBeTvQF1Iwu5bpIwVn7xVrLxpkhupp
	 DOdrZ4sFZpJOpYA2rNekO31hBtA1G0t1/f5tBT933AusAvejWixb3X2YXLYp78nijl
	 5WoPlj74YRUASEEXS5XuY65yzkQQnpYLuAnUfI3m9ww+joTZUYCqAu4oOizyBIoyL/
	 rUJ6jp5aQodrA==
Message-ID: <ebb4beec-13dc-4b94-a1f8-756e7a8ef5af@kernel.org>
Date: Thu, 5 Mar 2026 20:07:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 04/15] mm/gup: drop local variable in
 gup_fast_folio_allowed
To: "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
 "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
 "kernel@xen0n.name" <kernel@xen0n.name>,
 "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
 "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
 "loongarch@lists.linux.dev" <loongarch@lists.linux.dev>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "corbet@lwn.net" <corbet@lwn.net>, "maz@kernel.org" <maz@kernel.org>,
 "oupton@kernel.org" <oupton@kernel.org>,
 "joey.gouly@arm.com" <joey.gouly@arm.com>,
 "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
 "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
 "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
 "will@kernel.org" <will@kernel.org>, "seanjc@google.com"
 <seanjc@google.com>, "tglx@kernel.org" <tglx@kernel.org>,
 "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
 "luto@kernel.org" <luto@kernel.org>,
 "peterz@infradead.org" <peterz@infradead.org>,
 "willy@infradead.org" <willy@infradead.org>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
 "vbabka@suse.cz" <vbabka@suse.cz>, "rppt@kernel.org" <rppt@kernel.org>,
 "surenb@google.com" <surenb@google.com>, "mhocko@suse.com"
 <mhocko@suse.com>, "ast@kernel.org" <ast@kernel.org>,
 "daniel@iogearbox.net" <daniel@iogearbox.net>,
 "andrii@kernel.org" <andrii@kernel.org>,
 "martin.lau@linux.dev" <martin.lau@linux.dev>,
 "eddyz87@gmail.com" <eddyz87@gmail.com>, "song@kernel.org"
 <song@kernel.org>, "yonghong.song@linux.dev" <yonghong.song@linux.dev>,
 "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
 "kpsingh@kernel.org" <kpsingh@kernel.org>, "sdf@fomichev.me"
 <sdf@fomichev.me>, "haoluo@google.com" <haoluo@google.com>,
 "jolsa@kernel.org" <jolsa@kernel.org>, "jgg@ziepe.ca" <jgg@ziepe.ca>,
 "jhubbard@nvidia.com" <jhubbard@nvidia.com>,
 "peterx@redhat.com" <peterx@redhat.com>, "jannh@google.com"
 <jannh@google.com>, "pfalcato@suse.de" <pfalcato@suse.de>,
 "shuah@kernel.org" <shuah@kernel.org>, "riel@surriel.com"
 <riel@surriel.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
 "jgross@suse.com" <jgross@suse.com>,
 "yu-cheng.yu@intel.com" <yu-cheng.yu@intel.com>,
 "kas@kernel.org" <kas@kernel.org>, "coxu@redhat.com" <coxu@redhat.com>,
 "kevin.brodsky@arm.com" <kevin.brodsky@arm.com>,
 "ackerleytng@google.com" <ackerleytng@google.com>,
 "maobibo@loongson.cn" <maobibo@loongson.cn>,
 "prsampat@amd.com" <prsampat@amd.com>,
 "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
 "jmattson@google.com" <jmattson@google.com>,
 "jthoughton@google.com" <jthoughton@google.com>,
 "agordeev@linux.ibm.com" <agordeev@linux.ibm.com>,
 "alex@ghiti.fr" <alex@ghiti.fr>,
 "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>,
 "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
 "chenhuacai@kernel.org" <chenhuacai@kernel.org>,
 "dev.jain@arm.com" <dev.jain@arm.com>, "gor@linux.ibm.com"
 <gor@linux.ibm.com>, "hca@linux.ibm.com" <hca@linux.ibm.com>,
 "palmer@dabbelt.com" <palmer@dabbelt.com>, "pjw@kernel.org"
 <pjw@kernel.org>,
 "shijie@os.amperecomputing.com" <shijie@os.amperecomputing.com>,
 "svens@linux.ibm.com" <svens@linux.ibm.com>,
 "thuth@redhat.com" <thuth@redhat.com>, "wyihan@google.com"
 <wyihan@google.com>,
 "yang@os.amperecomputing.com" <yang@os.amperecomputing.com>,
 "Jonathan.Cameron@huawei.com" <Jonathan.Cameron@huawei.com>,
 "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>,
 "urezki@gmail.com" <urezki@gmail.com>,
 "zhengqi.arch@bytedance.com" <zhengqi.arch@bytedance.com>,
 "gerald.schaefer@linux.ibm.com" <gerald.schaefer@linux.ibm.com>,
 "jiayuan.chen@shopee.com" <jiayuan.chen@shopee.com>,
 "lenb@kernel.org" <lenb@kernel.org>, "osalvador@suse.de"
 <osalvador@suse.de>, "pavel@kernel.org" <pavel@kernel.org>,
 "rafael@kernel.org" <rafael@kernel.org>,
 "vannapurve@google.com" <vannapurve@google.com>,
 "jackmanb@google.com" <jackmanb@google.com>,
 "aneesh.kumar@kernel.org" <aneesh.kumar@kernel.org>,
 "patrick.roy@linux.dev" <patrick.roy@linux.dev>,
 "Thomson, Jack" <jackabt@amazon.co.uk>,
 "Itazuri, Takahiro" <itazur@amazon.co.uk>,
 "Manwaring, Derek" <derekmn@amazon.com>, "Cali, Marco"
 <xmarcalx@amazon.co.uk>
References: <20260126164445.11867-1-kalyazin@amazon.com>
 <20260126164445.11867-5-kalyazin@amazon.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260126164445.11867-5-kalyazin@amazon.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A43A7140018
X-Rspamd-Server: rspam07
X-Stat-Signature: pywo4t7bc7z3jr3dna9fykffoesey814
X-Rspam-User: 
X-HE-Tag: 1772737673-308560
X-HE-Meta: U2FsdGVkX1+iKq4pwBNxB6GFJXhQOo3MFZeZ3R9kEw1HM0ixHoEW3sPIgUYIWt22icyZ2sktwablwwb1lLhvyEdb9ZjeuEI3LvO+1OWpAO+YW+G95kHHCgTHWVMUF+viEADwCpqkJPG6C20NbKqmovcgv1os6+09hw3xKO/gcxLdtaFG1NuiVcImNSrBOifjraS/JDI8e/0V4iDpppqXTW+Ln9vzBR9zf5b8AEIUICIEp6QIxKM2Zn3WNxTBc1qu7azwf/lscj2y/wRlmy8YJzCaDwTAsJbXCBaH2SzM3dTokAPJyEBDvIkEpCWOYlUHhae06mAqoHhBkY7oVqc5DnXheHjjv8tr3X3msulPD8190m782PoVSKFu1HlgG6s+JFxAMnAAYVVhemLF94qMNBSyYYl7VB0pk3g1cTs0+ICpc5QeaXUaUzLYq+DPye2dZv3ikPJpZJfBD2aKuEAu+L9qH1FuwtQ18B/rk2c03LUSet8iXOmIY3NEuKs5fr7BwfcKK/qssjIo+gWe5Z3e53MgyZ164wPYsulvyWexkMH6McLiGDRyk4oKlPlJprS1T1SEn6NQTGCIo3KXSRjK9SjJtIqEmHWRtELcij3UI7ziSZr4ghRo4va7r2vhxN608TG/tJSDO5asojAuqxREBge+E5te/N/2YYdwDmg9OPN8BBpJls/9Wyg/91Dg5vqqhhnvvoALTkhSNxfMiAiLIePei50u7JWkkw8zc56BR5KKAkZElWVxhb/gr1dupqLFVLWDZ52jk8qO7KOn1HxCZjPukcqvy+2B9PdMhEWsw+DcDMDxPyZbs54ZN8F+KVOl0JyIpA99P4S1BJMYHOp9lAmKnxsVr+k+V/si9+a6rjsnvLOQrHFtKKzqVKqHgDd4oXnPyI83d5jY1YTTbi98Nj2XhmVtD3z5xHwBewe8FpHjRkAHni2ftHzbTpVcRruEsmFBAZsN9ttQFqp8HkI
 xD4/qGRm
 XlfCFMHPknd84yuXQuXg2fSDB+DO+yTW2v9EaC/tDKH95e9Ey5CmpMDCX4mMSj380xmJT1ucP3Jwd2YQsw97hOPLbGCMu4qvFHOuVSaiNovYK+XIaw1KLub+QWJDUJtIxM3IYQLR34QfYFgSrHUHiFF5jyMUV/xJ+b336FDPY4WUVU/3y0jM9+ZBbVSIR8xz80UMG6lZDQnLj5g2kH23DVlR8C4Wv+iTBRi0VA7mXFaokv1enOy5I+NqkKNoX7dsQq21j0otxBmdq989UqorSZbWPqixoj6VM+cV0YmcfVxW94Z8P3KdHQ7eT3F5AF8UGnQ2552fFyNmmOp0Il60USH3cl42DqckkWcXsq6ZcGRuqhoU79IQdNVdSyMpm+scNdn+Ps1OjfcGy3cX456GzKrvmZwbhvEBpK7WsjbfnXKJ8n1208FXWtM3H7XmZvxyDKhVb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/26/26 17:47, Kalyazin, Nikita wrote:
> From: Nikita Kalyazin <kalyazin@amazon.com>
> 
> Move the check for pinning closer to where the result is used.
> No functional changes.
> 
> Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>
> ---
>  mm/gup.c | 19 ++++++++-----------
>  1 file changed, 8 insertions(+), 11 deletions(-)
> 
> diff --git a/mm/gup.c b/mm/gup.c
> index 9cad53acbc99..e72dacce3e34 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -2737,18 +2737,9 @@ EXPORT_SYMBOL(get_user_pages_unlocked);
>   */
>  static bool gup_fast_folio_allowed(struct folio *folio, unsigned int flags)
>  {
> -	bool reject_file_backed = false;
>  	struct address_space *mapping;
>  	unsigned long mapping_flags;
>  
> -	/*
> -	 * If we aren't pinning then no problematic write can occur. A long term
> -	 * pin is the most egregious case so this is the one we disallow.
> -	 */
> -	if ((flags & (FOLL_PIN | FOLL_LONGTERM | FOLL_WRITE)) ==
> -	    (FOLL_PIN | FOLL_LONGTERM | FOLL_WRITE))
> -		reject_file_backed = true;
> -
>  	/* We hold a folio reference, so we can safely access folio fields. */
>  	if (WARN_ON_ONCE(folio_test_slab(folio)))
>  		return false;
> @@ -2793,8 +2784,14 @@ static bool gup_fast_folio_allowed(struct folio *folio, unsigned int flags)
>  	 */
>  	if (secretmem_mapping(mapping))
>  		return false;
> -	/* The only remaining allowed file system is shmem. */
> -	return !reject_file_backed || shmem_mapping(mapping);
> +
> +	/*
> +	 * If we aren't pinning then no problematic write can occur. A long term
> +	 * pin is the most egregious case so this is the one we disallow.
> +	 * Also check the only remaining allowed file system - shmem.
> +	 */
> +	return (flags & (FOLL_PIN | FOLL_LONGTERM | FOLL_WRITE)) !=
> +	    (FOLL_PIN | FOLL_LONGTERM | FOLL_WRITE) || shmem_mapping(mapping);

Best to keep this split and a bit more readable.

/*
 * If we aren't pinning then no problematic write can occur. A writable
 * long term pin is the most egregious case, so this is the one we
 * allow only for ...
 */
if ((flags & (FOLL_PIN | FOLL_LONGTERM | FOLL_WRITE)) !=
    (FOLL_PIN | FOLL_LONGTERM | FOLL_WRITE)
	return true;
/* ... hugetlb (which we allowed above already) and shared memory. */
return shmem_mapping(mapping);

>  }
>  
>  static void __maybe_unused gup_fast_undo_dev_pagemap(int *nr, int nr_start,


-- 
Cheers,

David

