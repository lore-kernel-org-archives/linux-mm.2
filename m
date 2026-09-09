Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDC5EC79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 15:40:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D75D16B0099; Wed,  9 Sep 2026 11:40:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1F266B009B; Wed,  9 Sep 2026 11:40:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0DAA6B009D; Wed,  9 Sep 2026 11:40:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8E7296B0099
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 11:40:24 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2946CA01B3
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 15:40:24 +0000 (UTC)
X-FDA: 85194635568.08.4EE02A9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 50037140010
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 15:40:22 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b67FWDHV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b67FWDHV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788968422;
	b=WFQWTL5fC4OLDMSv45/ozX37YkVwCsRPAw7w4M6mM/CCRl80Jc2q/kRJH/KrM68KDC+Hkn
	4qX19yxUVWfXyCwHzPog2ZQuioiOPCkHa6qkALqV4eH74lAkEOU2hvVRjgGTtKHmIQkqHM
	EPPlpWUIIik2O86BhHUhVBV2Bqa7CEA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788968422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AXYYQlIGAZBrAHu4CUr6VQDiXrusLKFHKO4tw/xbR/o=;
	b=jyI4cFVQWrh3mbZuEr/UgadUElD5ktVEtIyhVzT2fqdm9S+24F6GN+3ko3rQO2JKINp6tQ
	nYfAQjg5zjwsCvLVsOrUC14QKngYXe8GSJ964oe2VO5e5T/kblagm/9kQ9CX2JMnGCFhbf
	TxEP+5QoBDcR4c8bH1oEvdzTLtmaxTE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 60D8341443;
	Wed,  9 Sep 2026 15:40:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE5D41F00A3A;
	Wed,  9 Sep 2026 15:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788968421;
	bh=AXYYQlIGAZBrAHu4CUr6VQDiXrusLKFHKO4tw/xbR/o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=b67FWDHVrvKlADudVooPhLmJOQAbQa4r/JfwC9gUSiN2XwdjDzXh8PDhLIbwBJ2Bl
	 N6Vzk3XSxn9iwept0h4EbsT1QjEwa1ArTZoWsrAUs3sRxTkLtG3u6Tqn48pqVF4w42
	 Hbr0VynPh2dln0S6/KgjarMmfPtDZf/8puPSLa3d6dAowUIbor3F3E8wZW4gfkHAy7
	 ioBnUGH/HGUgh73jIHLXiP9er2c5LG71oVhLkOGVgFSr+kjgVMlPqHXLGlxCQA7ZS5
	 LcMe5V5KBReJ3ihsKdA8eubDNI8HqYBjN9XKnu0HuBHiiD05yVhAVNYtvLFO27T70K
	 2JOkNN9/OsV+Q==
Message-ID: <26f620c7-043a-4cb3-a74b-29069bded0dd@kernel.org>
Date: Wed, 9 Sep 2026 17:40:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 12/45] KVM: guest_memfd: Always fault from guest_memfd
 if in-place conversion is enabled
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
 <20260830-gmem-inplace-conversion-v12-12-85e5fd25252a@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260830-gmem-inplace-conversion-v12-12-85e5fd25252a@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 50037140010
X-Stat-Signature: 3mur5rxy14xz1wuhf63i9ynyrtafzoz5
X-Rspamd-Server: rspam01
X-HE-Tag: 1788968422-310504
X-HE-Meta: U2FsdGVkX18uweuV4lzO98MY9yctZCedLPjmmoBqEvI8XS7tDRPPxM0Mp1UnGZh7jifjeICACqRJkjgvU0rc8U3GlghB6NkWSWgVTT5Qb/kRMHz7S633jhhu3wxvGkYhOcqw8uUY/j5KPCoztEZzoJr3eeUBObg5C+v+8SWiKeqNYBkz6ecldOlsgcROlByTjYMMZjShCwvU6tqbdBve/TD5N6+ZsTtiEEUxqjWz3FBFRXCO1YuUBHtsuBTHSy8unz83gZ8XpdVDpq2S2BXur3aVuLv9Lu7upjQmmFnlzvCoLxB0FHJ+SA6lmMRY+GuOo22ziFZNp6KTtlC4iU4EW1SLbujmftC1wRKtxJnYCcnsWlwWd8gEItqHjVYgrAegWc6lg23z4/lTTVViLMhVRujH00nAQSQh5BVbMUsSL6EsCfFl7VFuY3O83ckRm8sYcgYWs+BJ0emEktOwV5AbS+gXWg26FGg74g3jbwE+Sd8X0gg7FNln78mY591/Ft3kQsOUX2XiQ72InaBKfRSBtqfunjmYmFbABa4l90WTSEsCkOog6t6d5r5+SXaiF2pYynTFz7n8P5RT5730wCUQAjfzLlmfYrPTNYEoFuMsalN8eMslKn9Ds0mdKADUVBZ19cUBpLOqqShTERtwQVIyvyyaoDW5aGmTzg2F85fu7ijm9xJKRFELE6/f6cuCAFpPq/4bQYTogf3PoC+Db7rSPw0UKF2/7Rt2OSFqdZ8qay3OHwARBZlvWly0Jl2+WZs1aMBZbjXJFjai/QeNpSvC0AxYy3NOo+wqd2uR0b76uOwWVnX/xHgkdmbwrz2Fa5GXkH3X9H7SqoCSxhGkCOBO+wy2Eqqzd0Bixak+VtLLgcxSCEZ34w72aj7OMVI18cUJUXY6CArQob3xz5O6XGQk5VkczgNcCq7Y5YgD3eWlz9ghT4mMqZQDg42LP1pZEL8g0crVz7xgVrGTWxsv5CD
 Um8G77nA
 eOnH4V/Z+doX2bz8CB5+eBgTeDdTE/OjRpsPmybVh9XNJPpHhZjxBjUumxSuIX6A4SPj97alYGQZKr7xUsD1j5uXZ+BNYcTbEnx656fs1jELKqDHFLDIEkYw11ZyMOBlA3jLt3Pwr8LmmqUoz53zL6E/Smff2XTj4Bi6I8cl+OQJC0OtVUTEcq28cP3CTf7r2lYWBp/nE3CgCoM5vv/izCWg9i0ePTRYPZxPRlliv5eqHU6d71wrO3vEk0gpGA5MRqtI9bk2kHrsm5JLi+cDRtJlfWKjFMGwMNUotHREEuOxOaitIMeAT8d07yKrmCVRZjBnQA394vXIdm/rAt6Nf2SLIsgrzAGhvfnWT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/31/26 02:25, Ackerley Tng via B4 Relay wrote:
> From: Ackerley Tng <ackerleytng@google.com>
> 
> If a guest_memfd memslot is created but the guest_memfd does not have the
> GUEST_MEMFD_FLAG_MMAP set, KVM still fulfils guest faults by looking up the
> memslot's userspace_addr.
> 
> Set KVM_MEMSLOT_GMEM_ONLY if in-place conversion is enabled so that the
> guest_memfd's memory will be used for both shared and private memory. With
> in-place conversion, guest_memfd will be the only backing memory for the
> memslot.
> 
> No validation is performed to require userspace_addr to be a mapping from
> the associated guest_memfd because even after validation, userspace is free
> to remap something else at the provided userspace_addr.
> 
> userspace_addr will still be used by functions like kvm_read_guest(), and
> if userspace_addr does not match up with the corresponding memory in the
> memslot's guest_memfd (whether userspace_addr points to the wrong offset or
> some non-guest_memfd memory, etc), that is a user error.
> 
> Requiring both shared and private memory to come from the only associated
> guest_memfd simplifies invalidation in stage 2 page tables. On a PUNCH_HOLE
> operation on a guest_memfd, the invalidation is now guaranteed to be
> invalidating only memory mapped from the given guest_memfd.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> ---

Yeah, that matches what we discussed in the call

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

