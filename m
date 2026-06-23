Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CEB3CDB46F
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 09:48:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9AEE6B0088; Tue, 23 Jun 2026 05:48:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E729E6B008A; Tue, 23 Jun 2026 05:48:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8BA26B0093; Tue, 23 Jun 2026 05:48:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9B9336B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 05:48:44 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EE05540456
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 09:48:43 +0000 (UTC)
X-FDA: 84910702926.30.40311FF
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4086C20006
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 09:48:40 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ME1VcZpF;
	spf=pass (imf13.hostedemail.com: domain of binbin.wu@linux.intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=binbin.wu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782208120;
	b=ZvXUBnh2/XUddL8n0tQXkqKtUn8FvuQqmdomk8GznP7oLH0yxKlzv8YBrDC1ofPpQOAp9B
	vhcAmCiUEs3e45w7xsKyXqXlcLx9JF69FKNV4C7xPN3Mbru8z6Us6qEMaT+6PEj4Aspv3g
	w2G7SiL7ue+jra8FWHfF7iRz900S2Uo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782208120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=seNyv2iZP6EgmXdShTEBw1lleNTf/6BaodayxEKQLYM=;
	b=8puEj7t/F/c4n1eINT1XHzIrBrQUdOKlv19jzgatPWTTACGtQqfpR+OqVYGcdVcbfDl0Ma
	d2nMGAfWsyeo79OMxJjb+C+sa5KZxByezaRYwx5N+lhlAWk2GWGdhfm6zSg0Z25axQrfmH
	g9CQDMps35bCHBV5+CgUMnTiIAjfBX4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ME1VcZpF;
	spf=pass (imf13.hostedemail.com: domain of binbin.wu@linux.intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=binbin.wu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782208120; x=1813744120;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=5923JLJcSnP+ammi926uhmSL7dT/T35P5AbtWqZVok4=;
  b=ME1VcZpFzF2OCbL72i0cVwa6Ngw32RzHDS6NyvVLYcJpXpBG9vy5NtAW
   RTuKzXJgD/bBYRWL9InJa4DcBcgO6imcjv8NLmxRodDholSCkNs+BEsoS
   dcUo9g27r+B4CMgz/+jEUQGs0EhAPoDW/PaGVQq8diE2S5nJSt5ijIF0K
   liklGk4Gkz3tTGUi/54ubhU/JetzbJkLnpS0tRfll3ixr4dQMbsFf+hym
   Zna8OTEvtSVXV6xLq4aDmg6xUaAJCLIKshS/4OjQ5H7IifiWLUxbvQxMj
   hxlKnYjSjdrwGalvLonzfonbByDGP54PjgEVLH1kLQlb14w3cCZKKJAzw
   A==;
X-CSE-ConnectionGUID: EgiVLujVRPWnxH84+jQfUg==
X-CSE-MsgGUID: xvxhl18EShesZmw7Ix1CCw==
X-IronPort-AV: E=McAfee;i="6800,10657,11825"; a="82988608"
X-IronPort-AV: E=Sophos;i="6.24,220,1774335600"; 
   d="scan'208";a="82988608"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2026 02:48:38 -0700
X-CSE-ConnectionGUID: MXLmCZy4SperyKCaH8GJSA==
X-CSE-MsgGUID: DGnOq6mSRvK9V69SMz9Zcg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,220,1774335600"; 
   d="scan'208";a="254572830"
Received: from unknown (HELO [10.238.2.81]) ([10.238.2.81])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2026 02:48:26 -0700
Message-ID: <6fc7f450-6d0a-494d-b295-297e4703148d@linux.intel.com>
Date: Tue, 23 Jun 2026 17:48:24 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 18/46] KVM: guest_memfd: Handle lru_add fbatch
 refcounts during conversion safety check
To: ackerleytng@google.com
Cc: aik@amd.com, andrew.jones@linux.dev, brauner@kernel.org,
 chao.p.peng@linux.intel.com, david@kernel.org, jmattson@google.com,
 jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org,
 pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com,
 rientjes@google.com, shivankg@amd.com, steven.price@arm.com,
 tabba@google.com, willy@infradead.org, wyihan@google.com,
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
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-coco@lists.linux.dev
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
 <20260618-gmem-inplace-conversion-v8-18-9d2959357853@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-18-9d2959357853@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: wmfjqqga7mykehnzxi1deptorx4brjqs
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4086C20006
X-HE-Tag: 1782208120-533268
X-HE-Meta: U2FsdGVkX1+UEeG61e0CS1iO9b4ydWNXAmMRN3vtInQVZkKRLN4uPldMTDY1lgWky7jww5Mrmw6LIYt+MGxMXv75J4SbYoyFIy6ivv1T65cRQXHUgXwhKLwp7tsEvUxAKkEa2rQvY5lT/o5ZEnGJbQzoPvssrxMFPZJDeQGgTqIJHhTJRkMHO/aoZ1LF4GSxhHqTufeVFWQbxvXrqQUxPIURt7m9oUqFr1BY6tJ0C4vcuvdM4f5fSbUnf+QW7HhK+7kYMK3XhHqylEIPTKj+Jgv4KkkibvWOMtrK6UMwIGe4q/1RDlrjAM+1JtSD0OZGi915W/GQWsSkT777afOI31J4HHQN34ApwnOuGp8WXtTv/6ltVGkoPtqfS468Y9sShQNxBfsncrAHcJX23PYRcuE/nwtJ3sS5Z6L+Z8Wvn8WMPryRkkiXg/19DZe8Es5vFDW8hfY41VJXDUKwJQt1CQnE7oQq9GASZnwX4DndJY1RSYVU0mET6MuupeNcKvHqFfhSZd5eQihBYzi0CxAfDg3T6clKP3h0YTluhmH1i0D77sVO1RL8rJxGT2Y22o/o0kJ3A72B8NoPAkYH30otxoSXcv1CkpBrCXiMd5gcD5jxRcl9fHdQdhnLOBcIoWYfKGE31tXTxAGyS5eiUALDZgIfpZfM+1cSq1GuL/F0nnocf4evWiZjn0u7RheZgl6aW9cccO81+E2wonWjuOFNLCOu4RW6CoaK8qz1srIAEevLB69pWo59UhAN+CYxxAAHYrji95oHpHl5V9+o2hy3aPm+0SjY5DNbSxhgdfRHPjG7L4HVW+uWl8MtEexDQD9vpQnpK/oRnIzI+oDTW0kYadatqydZXaIoO8ZSk6F2ecvr+ro3IzFUK3g5v2PnSR3hNyTuPzFTnvId6ulf8MyKcWqcNMI5V16XZa2cBFD6dGBmCokuZKV0QE7jYvcQAYIpcyjjpujh19JlyVCR5sH
 70/RIjvc
 vZlFshzl4ZWTqj80ragjLp98Vhug5dQhbwwoTUD0kip9Hq1jo4KaFA20HQYD6AnCcVL825kXLlvJUo+RdHN1mlvTkufMtrlOs6wO8h56SVCU5x85rgDlXiFwqZ8PGt8HV9MdIkrPqc8YbgM3wcfWSN94KeTaQOX0N8kq1aWXfk96MCzythSYdyTQV6GnLLvUi5r9S6unANqov/Ce/5eNRV0/a4loBznK1W0EjAAOo07QQihDOSNl/qpO96+6/kEEO6gDjQMclveksrUzkDI+JbILXPxWUN4hzlG8JBzcJqZ/3j/I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/19/2026 8:31 AM, Ackerley Tng via B4 Relay wrote:
> @@ -606,12 +608,20 @@ static bool kvm_gmem_is_safe_for_conversion(struct inode *inode, pgoff_t start,
>  	next = start;
>  	while (safe && filemap_get_folios(mapping, &next, last, &fbatch)) {
>  
> -		for (i = 0; i < folio_batch_count(&fbatch); ++i) {
> +		for (i = 0; i < folio_batch_count(&fbatch);) {
>  			struct folio *folio = fbatch.folios[i];
>  
> -			if (folio_ref_count(folio) !=
> -			    folio_nr_pages(folio) + filemap_get_folios_refcount) {
> -				safe = false;
> +			safe = (folio_ref_count(folio) ==
> +				folio_nr_pages(folio) +
> +				filemap_get_folios_refcount);
> +
> +			if (safe) {
> +				++i;
> +			} else if (folio_may_be_lru_cached(folio) &&
> +				   !lru_drained) {
> +				lru_add_drain_all();

It seems unprivileged userspace is able to trigger lru_add_drain_all() repeatedly
by invoking KVM_SET_MEMORY_ATTRIBUTES2 in a loop, which could lead to DoS risk?

> +				lru_drained = true;
> +			} else {
>  				*err_index = max(start, folio->index);
>  				break;
>  			}
> 


