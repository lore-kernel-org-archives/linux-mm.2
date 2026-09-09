Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CA9CC79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 15:35:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 241E26B0098; Wed,  9 Sep 2026 11:35:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 219256B0099; Wed,  9 Sep 2026 11:35:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1084F6B009B; Wed,  9 Sep 2026 11:35:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DCF726B0098
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 11:35:35 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F0B291C1B3E
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 15:35:34 +0000 (UTC)
X-FDA: 85194623388.17.A7249D2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4600E100004
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 15:35:33 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B8tXXPP0;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788968133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uh93x1YF/dEaPyXWzFbI73dZS8rpJkADyL58fkB1FYU=;
	b=IAxrHdJp/hPuxU7LxtYUWJf/UICqDONFzRFNddwPjoyM7f+4g1+f8IQHXKNQ2EWeZlqJh8
	Ze/cmDTMoHKxQUYQyop1Up6GQjIf9rI+ceO6fbNGSmraii/u6M8BhmkuZQnJNeSO+4gBH/
	jkOYHcOAwGC1eCj3VMtOdfkEQmj0pdQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B8tXXPP0;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788968133;
	b=0eez6dUeKgfup9Cu+e6hNmuwYc+ZV0fYheRYj5DFnVWv1e05lyjkRye16oCsF4gUSpgCnt
	WdBftSTmPR9nPDN5ydnhgL/wClgdsm8X9rs7LwQsf1A6gfdxIrmuNXL53HvuOXlSJqT1XZ
	kS/Q12iO+H8+CekVO+5Ul+akIgd2U28=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9273E60202;
	Wed,  9 Sep 2026 15:35:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 870621F00A3A;
	Wed,  9 Sep 2026 15:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788968132;
	bh=uh93x1YF/dEaPyXWzFbI73dZS8rpJkADyL58fkB1FYU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=B8tXXPP0BpNZCnZ6D6dQeWWfG9eCaCcLp1iGPfB7DFfT+ATRDi8hxrzJjm0UIJWID
	 6OOcroK7SZ5KAWqwBjOU7ychXay7xhZCjUJWqnvA2HLCB8qdRLU7SoQ8IEIgTwWed7
	 Bw2SKj1yugxKiwOlo5T55L2Us/XLRZNiRFUpRp/tDkHI+7loZUpfPCuiuV1P40bYzX
	 gemsILP/z4wH2hbB+0Cs/bsJMiEIehCS2IE9dZ/8+RenT1ybJ+fSgCgkaTjGsCyUBz
	 xj3gs4FgpTBFUEnQQGFnaF3zZyLCInbnln1VTOdXEaGH1E5lrK00ebKwI28JeiJ9bP
	 XyQzu4+v48ZJQ==
Message-ID: <10b49972-dab0-4563-a3a4-c3549d9f553d@kernel.org>
Date: Wed, 9 Sep 2026 17:35:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 02/45] KVM: guest_memfd: Use kvm_mem_is_private() when
 populating guest_memfd memory
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
 <20260830-gmem-inplace-conversion-v12-2-85e5fd25252a@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260830-gmem-inplace-conversion-v12-2-85e5fd25252a@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: ds56uzqd6rc893eo7gf89c11sdh7b1b6
X-Rspamd-Queue-Id: 4600E100004
X-Rspamd-Server: rspam07
X-HE-Tag: 1788968133-449360
X-HE-Meta: U2FsdGVkX1++3CtWLDbcN8/4drEJtclfA3AqQsE08WSmscl+N8UAI17yeglUmrR0Mg6AJuJJc1ft1KJ3oJ84QbxHYVDHrk5eoeIUlh2gKXl3DgqKk3Y5NUm9kKIENGdYIA8LCr0R+VqvrHrdu4Jx0FAnwPP48xWJQS79mIUFad+NsVX0KqmVLYCbiloDziKBieoP+pFPwGXCM94jZP5WGkQQFMSi5VWklPu9xcwNYjwAgJ8CX0dwfgQWjh37bzhE166b+OBjcVdZwjscuOL9qlvfsaSYJJ0deZXRlPgRbXAMAUoGCzXygdEHSxbGWdlHD59WtTfdfWv+O0aLN0IOk1Hr70bTrYFBtsc5F4Yw8cKqgyE0qX81pWR+2Z8xwN8ou5Png0wko+OmyxYNnxBaCXiAGlH8KMr6wK3KYrKMcybmmF1FfyVavZPSl48ug78/VFRSglATYxVx+MeA8ku8gg9xye58llQOsdB/nwWNeum6CW/PA1xcdBIK3np9YgA01AHUEAmml/JTce1A/M+BoCEBySvKklcnhFCIaputIi3UsSJRHEkUhZaBGjy6jz13tdiUQ/AMD30B6PbhxdVMj8fx8MPrDeOFxxFeM2UrkOVTmJPt2bhz9giBD6sJ2QDHxJkc4bWr7fB+/HWzHT5bUhMfC1cCdtRc2CWQ4VujctRr6mS1+yDnTvVMWitHAifs4CufkJ8Mity+V9J23ceAiMH2NizaZNwpQDKloBL1u1kab2FuDBmWeOz4ewiYKO/4I63o0FJ7bwkc/yfpb+fqFeEno+eNuraij5nRIKoxtnq+IhMgFpp4wJLSmUNoV0j/iBkhVMAk5ERjFHWQASqxrG4OhYPRjYCxxFUe2kGFKEsZH5LfQMiAD0LXVVPX9O9c9lV6S5chC9aqGac+t8NQb4Z7IjCRB92V6Azy6rdt7F9OwDQ8by/QlmxQeyt//nnT8E+XitOwrPdKakPC475
 lJxqNNXz
 Wnykp9Sgf4NWcmd2DNLhSGhc/dhYdFJQQujvnyWbwlN8OSJS7of64D3QavKNIMvBYitwxpTFtb+ON3VO4VKHrlYH1ThFCZ/TSN8ECTP+Vtihxz12lwhPcYS4wT2s2fEdmPdprU8OlNwy5HdsIC/YESXCq1JSY/qMwHY1l+psq1ZR1797xW7SDqH9aAwCvjdED1P23LSXne7z438IfD80O+lmmmZnt1f0pR8YWOesiS5RMS+Tau1QIwCDLj821L20qok33ZoYutBLU8xjjOXkbK00GUITZHGZNV7wbCWLfPx/JG8bKNKuatYxG8fKVrBEbpScYccCh7lc8O8rqRuZN2PcF8hpIdnqbzjEyt7ch/prtQMtRSCE0Jt2GQw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/31/26 02:25, Ackerley Tng via B4 Relay wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> Use kvm_mem_is_private() when populating guest_memfd instead of using an
> open coded equivalent.  In addition to simplifying the populate code *now*,
> this avoids the need to provide a range-based gmem lookup API in the future
> as well.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Suggested-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
> Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> ---

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

