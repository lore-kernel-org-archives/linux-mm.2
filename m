Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8F15C79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 15:43:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B78296B008A; Wed,  9 Sep 2026 11:43:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B50836B008C; Wed,  9 Sep 2026 11:43:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A65FF6B0093; Wed,  9 Sep 2026 11:43:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 689DD6B008A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 11:43:22 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D7B73120218
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 15:43:21 +0000 (UTC)
X-FDA: 85194643002.06.DAAFDB8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 0099120002
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 15:43:19 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S3xLF1ge;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788968600;
	b=WXL3/uiLearwkkjuQanLQIvYiGHnhgvXv3RIObe5bc7f2PJaOtCn9rZXOhekPc5xdn7qcY
	+XAfI0adY+sH/CpJ+H09dS52jy16jz8U66vM3jzjwin6/B7B0Ajc480zckueSPUrk3fZ9m
	EsrEsFcNI4XbVJ3klW5jhTumMr+UUT8=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S3xLF1ge;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788968600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QVOhNByUr6r71RUlJ+rEEyf00velzFdvLZ3C2AMRt2U=;
	b=pqW+Wt0wTM2WGEHMuCFhLaYaUm7SMS9gzbzvw4a/hzGib3pkgY3X5nWJh9hGhSHm6bw6ha
	d8/XljEMxIMfdRZ2R6yLz9XT4B6rgSuAoL0a6jcfQflYTwksvf0NK3vHOXK3mLh3Uch5X7
	3K8vEgM8DbYuITxiZK1xuUIRvFnH/zM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1286D41568;
	Wed,  9 Sep 2026 15:43:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FAC91F00A3D;
	Wed,  9 Sep 2026 15:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788968598;
	bh=QVOhNByUr6r71RUlJ+rEEyf00velzFdvLZ3C2AMRt2U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=S3xLF1ge328RJxZlMfKf+h+Rr0rHffvj//0Ye1Nj1Yt/3i0Hs+6FpVCIz2UjPtSzt
	 e+epimZH/KIvzoG2oeXzFOD0U50ZJvPBPStJncIs/6C0r3nsk6FGUgTY6zCR8HNv69
	 dq3an9Q5ssTHyCNCKLMAeLq0QO9QDq9cEFs4ekvkctLo8VZCdnqI2dF5ps8LSluE/x
	 nkB5iPG1HttRVac8M9rvpQgB23RrqYPtAKueLaetQFCJEUc5DTCb8R0Y9YBxrdPqbx
	 kRFiRPgn7mg+NcwDvqbVgyBb6fbw0LEzPcjJ/4xY+6CxdE+1Aeq7+9dVWL6aIZmrOb
	 U76GUSckln3BQ==
Message-ID: <cc6eb4bd-3c4d-42f4-ab48-d381f7b6a2f5@kernel.org>
Date: Wed, 9 Sep 2026 17:43:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 19/45] KVM: guest_memfd: Zero page while getting pfn
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
 linux-coco@lists.linux.dev, Xiaoyao Li <xiaoyao.li@intel.com>
References: <20260830-gmem-inplace-conversion-v12-0-85e5fd25252a@google.com>
 <20260830-gmem-inplace-conversion-v12-19-85e5fd25252a@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260830-gmem-inplace-conversion-v12-19-85e5fd25252a@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0099120002
X-Stat-Signature: zu7e4swweu8nidiqo1xkacwu8dsrrb3e
X-Rspam-User: 
X-HE-Tag: 1788968599-757260
X-HE-Meta: U2FsdGVkX18L36oDkTIhaaoJvX9H4rD0e/c6MBn3Z7Do5xEp1SA+92fWdxBWoYOVjqoA5l8FhpOwMfijqOratN2nACPpL2/1KfoIbdq26YGsIqSv+4Ma73Dy6bLin7OAHcjbD8vtCthXfZSKM+Nsv3vwlTU12uK13r5Vz9BmucUYk8ZYWQ6A0voofWxQVVQIwf4M3LofMnIt3bBFh5IFVGCvaE9YG3+wJZXZ5lSc4aKtstVsFfxe+bJ9Z3QfmcRBR0l0b2HI4Z1rhByC+oiC+CVtmjdo+1zSCGwbXSbUR/duG24y4n3mKdPa8pz4C8cuYTOVRegyo7L2M3lNIVjiUlRkw/9Q3WS8fM/4F2P4A+HbILjXux1Fn86wSgoEYV9ASTzzcbycJRAqzCUemW/AIpAT8I2MXjS7nokAvgBQvY589/POUEb4MARRIxluD187ggjnjWYG1sesi1LyWHRLZBSww/9FnjGhRpsln6vQXrshLiuL/VA/Lp92BVOin0MEvEIAfkMSFqCauIuDEXlZ4QxPw1FUXlZHNXarJfGK7BISLCuD8XBo3JDJ4b/v9XfWLtd111pY43FZcw05RgKDLsoD8l2O99UUQemD+yia1tmR80/TsbSgaQLHEjy6svv+3dYr2O6QF/UbUgZFOh7rdnTK8ysVsFuv6esPAaNOuPiomlZQkbSAOHMQ80nV1PfeHuJXmPAJqWPxXkkaO+EONiqq6AOggNbKZi7u7y41vCHlI/MPyO+m+jD4ON+RrdKRmcFDbgfyJLXZBm9bbILmiM5D5sWF2J0AKnHfgVGGtHl0Ar9kVymZmFXLr+2NhEe4w5+tuojY+h0bm7ac+5xHtYm/6paZNcj2HT8wlNS1qQ53RY0ia7Lril44+P4j00NJHj9vbaqZdJ6Awg0BZfozIt2VNLnyq9HFhmopYlLIz6IPggY2ws8aMiYzKTz69y6yMPyzmWCuvX0VAIhEuYC
 xxXMM5AH
 2y5FcNCFOhytf5lVQPE9ChquCyXwez9tX8eHv0sBM1yjDHd1cb4Fk2kL2pm1GtCHHXwnj11Pyb+wqFjcKkRmCib7Sih3HRCVg9D0F5AWTg+IiG8IYzCbziZmVXj9mqgaDid+E0XmohfBzid2oVQZcxqmzeruz0Ssy6uyBK6f6iEXLxpNFBfVwm+b1kCVDipJ3M6JZAr1zcBOESLsogYAg3ptmS9nN4800q8YLYhJABAa8E2fyD9xWjHp7XHTTJj10sMPO6YAOX0ngmPV8p9Uc0llQNVc9hsUSHod4Annrb+4FySWo7EOauDwwlQwmehWOMttCtj7T6MPf65idGiG6ZNSTcYsDHcJqjRtq/sq29lnug4OLLDZH8ul25hgPDnU0vJQziPAOB50FqZ1uehBF/Uoq4g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/31/26 02:25, Ackerley Tng via B4 Relay wrote:
> From: Ackerley Tng <ackerleytng@google.com>
> 
> Move the folio initialization logic from kvm_gmem_get_pfn() into
> __kvm_gmem_get_pfn() to also zero pages if the page is to be used in
> kvm_gmem_populate().
> 
> With in-place conversion, the existing data in a guest_memfd page can be
> populated into guest memory through platform-specific ioctls.
> 
> Without first zeroing the page obtained using __kvm_gmem_get_pfn(), it
> might contain uninitialized host memory, which would leak to the guest if
> the populate completes.
> 
> guest_memfd pages are zeroed at most once in the page's entire lifetime
> with guest_memfd, and that is tracked using the uptodate flag.
> 
> Zeroing the page in __kvm_gmem_get_pfn() is chosen over zeroing in
> kvm_gmem_get_folio() since other flows, such as a future write() syscall,
> can get a page, write to the page and then set page uptodate without
> zeroing.
> 
> There may be some performance penalty due to redundant zeroing, but this
> would pale in comparison to the cost of actually assigning the page to the
> VM.
> 
> This aligns with the concept of zeroing before first use - the other place
> where zeroing happens is in kvm_gmem_fault_user_mapping().
> 
> On populate failure, the page is not re-zeroed, since on SNP, if firmware
> rejects a CPUID page, the expected CPUID values provided by firmware are
> returned to userspace via page contents. More generally, page contents may
> be modified on populate failure.
> 
> Don't mark the page uptodate again after populating, since the page would
> already be marked uptodate before the post_populate() call.
> 
> Reviewed-by: Fuad Tabba <tabba@google.com>
> Tested-by: Shivank Garg <shivankg@amd.com>
> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> ---

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

