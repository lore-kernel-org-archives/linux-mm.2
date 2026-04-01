Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07D691076387
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 17:37:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DF506B0005; Wed,  1 Apr 2026 13:37:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B6B06B0088; Wed,  1 Apr 2026 13:37:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F37A6B0089; Wed,  1 Apr 2026 13:37:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4EC276B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 13:37:22 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DFB07160171
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 17:37:21 +0000 (UTC)
X-FDA: 84610693482.17.327FF25
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 2266DA0018
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 17:37:19 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=mwIDp6FB;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775065040; a=rsa-sha256;
	cv=none;
	b=k6rfZdCl33UCRMXw2+rkVLgOmYoldyLV1QJYB33wJyHyKbFouBoIn/ZjWtFufHaS7Prjma
	PkkAfSH9WDep23O+cg8bUgHlXKyP3DAdUHrGU1FV1S1kZERnh24buf6w5pnUE6ikUqvU5m
	KcnemfQkuxV7Yn6qz+cril/ZXtG6HGI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775065040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hs5XmjWcPgfI8oSr7q2s1k+glpvRnoAAD7l4setQEAw=;
	b=JLZaIH1RBrwZMQrmw6aKxRCSw0T8o1BfSKaauWcWKjm5L8RQeRdJniDJYZExBEO7+6Hb/T
	7DK9ILZDRiZPS6fPc0/461fDIO4WoAcD0ek6HcJvkuHSwMpc+pF/QfJmTspAPt4Ojh/Oah
	ymJgkMsdtmkkC4m+Ng78UbC91n1LtCo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=mwIDp6FB;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 653FC6013A;
	Wed,  1 Apr 2026 17:37:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F657C4CEF7;
	Wed,  1 Apr 2026 17:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775065039;
	bh=QmcnS3tunksGoYi+iCesvBhUK2kH7XFD5ftcMv/BXsQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=mwIDp6FByrI4mxsw47udOkD5cNG1MxeD1cHCBXZY1mgNVQC8np/HoYpcQ8mz4shaf
	 fRI/wvkzpdKYrIa6qQfjJdLevmo5IzBMNee9Q4H4YzcWhb3D/LKSjw7w0dfEJNCDSV
	 xH1xXd+gw3c+bBphnXqjNNoPmOMD++IpR0ThjHfo=
Date: Wed, 1 Apr 2026 10:37:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, Andrea Arcangeli
 <aarcange@redhat.com>, Andrei Vagin <avagin@google.com>, Axel Rasmussen
 <axelrasmussen@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 David Hildenbrand <david@kernel.org>, Hugh Dickins <hughd@google.com>,
 James Houghton <jthoughton@google.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Michal Hocko
 <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>, Nikita Kalyazin
 <kalyazin@amazon.com>, Oscar Salvador <osalvador@suse.de>, Paolo Bonzini
 <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>, Sean Christopherson
 <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>, kvm@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 02/15] userfaultfd: introduce struct mfill_state
Message-Id: <20260401103717.b236b271a2856d536a48663b@linux-foundation.org>
In-Reply-To: <aczK4-vrULRiTvyh@kernel.org>
References: <20260330101116.1117699-1-rppt@kernel.org>
	<20260330101116.1117699-3-rppt@kernel.org>
	<actxscYZGFiyvUcs@hyeyoo>
	<acva_NKf7T5rbIC8@kernel.org>
	<acvnEd3-s6XI26vb@hyeyoo>
	<aczK4-vrULRiTvyh@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2266DA0018
X-Stat-Signature: k9nftdha68d6zkahf8fgsnai7a1bqych
X-HE-Tag: 1775065039-207713
X-HE-Meta: U2FsdGVkX1+UTrdAMjZyH9YeJFv/xYTV6eIUFWdymS3gijd5G8pG7Yp4kDk+K/aLXLh6hBojA0rYFF8k1Ky2n60k43hhhupZ+znVkiQDgLTIbNos8/2l6bwfFF+43oE1dzL1LnKwUvx5zM/R6zb7Ya60cyRF3I1NIo+4+12fdEbWoX5TwDoYBww+DpQxtiTdPZ8Hg+wfRytumkjjiV2Ntz/z7ehw6+6yLDt+76Vnb8zQ0cJKZNUYJ364HcV6/CHfWVmk9HHWMt7kRP2ehHXXHAUSu6WI0GfWLi2AB5lZhPUmKs6GbliDG6/+csvB4x0N2jkvjy67BDpskMTAEplI+4GHANnk8JDDqD3mb26jHfbWKmXA04xeKwz8SsTPYA1IwCt8/zyK/Pf8NgcwlCAwWCAuzb21vGUHvO2T9cKEkS2oSW6GjFZytB8TYJOsO6t4oG+YQnX0k8oucd5w6Hrjvh0FtJNsi7mCLZ6+HzI4pTR5tyQAto2D64UfwtjvWEQX8U2XdGGMcIf5s6afsV+voo8c04EKtWMNCwIHKPk4kUwh7o09kfmRNeN064NJtxyxVzi9h+8mPKwcbOiqVYDSlEcVMWsdCKOTdfKqE86RUAhDkEAERT37g9wS8VSNzPbR/qrY95GyBpWqnweCD0NOY5dsAzM+z70RISCWSgpgqntWEKSqMfSmfWOoME+DFjAMRaWZAfCU418+Pa6tlpBnM4VIwHJifoUMIac53yqI4j4jkwM28RFyQVPHZT2GeYwk0rvMvID+o6Tna4/8JPI4T8KeBVh9IPg16LeZmb/zGr0gnvPdKqmaNk/uENe7GGUHBgZJNu/VWCQhz+lGjHsmFnTyH/DR4niMMkGvtESv1mh1++52mTvtMDpwR03vofWag40ddlIA8e/FGe+BSI+kEq+R+93xgh5RU6Ku3S9lo3GxbIXL01+mf2jj5QWgaHxP9tBJDqOLQ8JotEg5yoz
 IL9r9s7H
 t0fM7/kPRCEuMOeoFTyDJwMK1RVkhz/5EJvyFA0rZ70YAxPsV6LBjf5yWPIeepCqyVOXOaF1dJExXzlJHIeOkzQ9Uro+FAmXBpkiCIVomOjKlaYY/z1Tsy8EoQTsrpIyZpLQf5g/1BOeEDxI4mvgy5NrRKFbgiZgK6QD5GCv+OYrXZhxOOHn+8gvQtRBJfE5LqPKxjniFsQR2+kKakc5oa6zPX3IUI2PFCWlGFu3wavSpQtONsDkto9HqALgWzAUqcZOERXESZ2IdRc+eVbHvcNIhQInAHHtNeOzyvs5lulbIcOY8vvfytefKbAF/GDuKuYHI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 1 Apr 2026 10:36:03 +0300 Mike Rapoport <rppt@kernel.org> wrote:

> Here's a fixup (it causes a conflict in patch 4 though).
> Andrew, I can send v4 if you prefer.

Looks pretty simple.  "userfaultfd: introduce mfill_get_vma() and
mfill_put_vma()" now leaves things like this:

retry:
	err = mfill_get_vma(&state);
	if (err)
		goto out;
	state.vma = dst_vma;

	/*
	 * If this is a HUGETLB vma, pass off to appropriate routine
	 */
	if (is_vm_hugetlb_page(state.vma))
		return mfill_atomic_hugetlb(ctx, state.vma, dst_start,
					    src_start, len, flags);

	while (state.src_addr < src_start + len) {
		VM_WARN_ON_ONCE(state.dst_addr >= dst_start + len);

		err = mfill_establish_pmd(&state);
		if (err)
			break;

		/*
		 * For shmem mappings, khugepaged is allowed to remove page
		 * tables under us; pte_offset_map_lock() will deal with that.
		 */

		err = mfill_atomic_pte(&state);
		cond_resched();

		if (unlikely(err == -ENOENT)) {
			void *kaddr;

			mfill_put_vma(&state);
			VM_WARN_ON_ONCE(!state.folio);

			kaddr = kmap_local_folio(state.folio, 0);
			err = copy_from_user(kaddr,
					     (const void __user *)state.src_addr,
					     PAGE_SIZE);
			kunmap_local(kaddr);
			if (unlikely(err)) {
				err = -EFAULT;
				goto out;
			}
			flush_dcache_folio(state.folio);
			goto retry;
		} else
			VM_WARN_ON_ONCE(state.folio);

		if (!err) {
			state.dst_addr += PAGE_SIZE;
			state.src_addr += PAGE_SIZE;
			copied += PAGE_SIZE;

			if (fatal_signal_pending(current))
				err = -EINTR;
		}
		if (err)
			break;
	}


