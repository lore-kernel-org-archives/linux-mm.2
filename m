Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC0D8C5AC82
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 09:25:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 895B96B0092; Mon, 10 Aug 2026 05:25:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 846F66B0093; Mon, 10 Aug 2026 05:25:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 735B26B0095; Mon, 10 Aug 2026 05:25:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4D95B6B0092
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 05:25:43 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E5B281A06EE
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 09:25:42 +0000 (UTC)
X-FDA: 85084827324.03.19046C8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2B2AA1C0003
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 09:25:41 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Te0td2+v;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786353941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FW+DCdZf91aXSiXpZadYY/zYCPM3/NZ456W0+Qt8738=;
	b=BQ/hAHAUsvI+6v9bHlxdu3KLtvMOXuYzM2vZIozFfvvvapgpea9Yb8IfDxNUUQPaeqlI+u
	2JUiquUjsyG2aJTjtPHaaxQK+dLTynM4Hcl3s+74ezUwxv8J+7w4jnP0a+KcpIPq2LGMdm
	huNVr+kHlWos2Su9e2Dtpz0/YIHSR1s=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Te0td2+v;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786353941;
	b=FBJHWXUQuWhjTqiAroQR7VF3r1KoM5K6gkzW7K6LE1gwOfLyBmHifNZT3NtF4cSO4fQnSh
	b29z4ScXOkQq3EVMWcgcTLnq+xn+LfF0Dl+GVWknx2Wx7r0FuKQ/9ZFSfwg2m2vKPQ+9y8
	iHb2zOt6NjUIbCVKhRbEp8LQsHk/Fww=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A556C43BD6;
	Mon, 10 Aug 2026 09:25:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECC611F000E9;
	Mon, 10 Aug 2026 09:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786353939;
	bh=FW+DCdZf91aXSiXpZadYY/zYCPM3/NZ456W0+Qt8738=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Te0td2+vh2cJ4FxDisqxBKsHzQ0BeIztq2W3Tvbcb3gawhlzZCouFcbrDOMorkZIV
	 j8Ll0w/+J7RwUovuLhLslVQNeVNJC3ejLAjEE0xsIL16gKE89mX5kMjlvitp9EuICp
	 JOJ6gT70gWmQrKa+BQIfrGs8VAiHVYuN5Iy3JxuW+EsIzaWt4j/F6LA9v9XNay4tL1
	 fSpeY2w36ghn3Z2V+p6I5j7wJgeC2OeBEcspY+RDTfhXquw92tHyyED8EG2IlSRB2D
	 yselX3lmkFkZXy+nO/osfWCIPZPJmeQQ3I/RUIlbocwcj/+hE+5S0k8+TmGVdUq0kX
	 1WVQu2WyrSLxg==
Message-ID: <aa545680-2fee-468c-ba34-cc9beb16f4cf@kernel.org>
Date: Mon, 10 Aug 2026 11:25:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 15/41] KVM: guest_memfd: Handle lru_add fbatch
 refcounts during conversion safety check
To: ackerleytng@google.com, aik@amd.com, andrew.jones@linux.dev,
 binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com,
 jmattson@google.com, jthoughton@google.com, michael.roth@amd.com,
 oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com,
 rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com,
 steven.price@arm.com, tabba@google.com, willy@infradead.org,
 wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com,
 pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org,
 liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>,
 Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>,
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
 Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-coco@lists.linux.dev
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
 <20260807-gmem-inplace-conversion-v10-15-2fc18ee6d3ba@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260807-gmem-inplace-conversion-v10-15-2fc18ee6d3ba@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2B2AA1C0003
X-Stat-Signature: s6rm5nt4ii3tsp951gwjkxfha9pepb8y
X-Rspam-User: 
X-HE-Tag: 1786353941-464905
X-HE-Meta: U2FsdGVkX18wu7SEA8YjTICmJhJMFVA9vfLZBTMFUCnxpZwd22d+HeimFdLic0SfMyeIxMejLz/vN7oJCdGaUhjAYs3KGvslidGywexeQwYcm1W9Hg3OvRNzRLqlLGKpP4YXcqWjW8l3qgCdyMpxG/VLUQ+Hw+Cvkjg/xIdsWmnjYK6I6md9Wk7+zEx3EteP3teAfVeLX2CbznTrpAe/7zq5bw1RQMC4Emz6ISCrSievLfO7t8tw2aCTNaYDfr5eUILwUkfFLaU14o44B50Ky17xXbu50WP8jbr7KqaHqcKmh79aq3Y2GutZGvDeofuBVRZgcNBPl/u78e0KXGdbvB6w3zCWHA110hiBF99bQ+Cz9mqVn3m2VmQ48DdwtLYNBCsMdcPSOFTfLG7ZulVhzOxvSSZ7WxayeJ6Kcq3D2Pi/NZE4+C6aK7/NoG5P++k86f4BXjRuutJ9q6X1B9O4LdzDMtWRraiyIjCyPTBno5reeKVjpMtPyV6/kOaU0Kl4iV1pkPfmeFq787fn5yKdXYPv6IQ3obKeNJkiMRURkazjecxXnbiywEWrP6LFlKBlBiLIMR6qcmVGFpZuo/sl3m90iuGOiA5iUkNxPmSwX69T1xwKjeIz2Itb9FYuA72Fy7pP1cuRZ828YBHwz97XT7KTXOAf92CpjOvqd31C6tX9I8yWzmm6a9RM9YrghxzLvoK/w0Lvu2wiSiUYZTyCPt/18A0qkRZh7iria2HpKahKrNpeLAw1df5dYzNmvkjZE/yEdZfqjKb7BX6O6JuTIlLRj6TFQ7z7YFT+qn4FJbSXwo95+aq3H+XGA5Ouk+XuA8KBNyfhlEq0dl31ALog2vL+PEW22S6Y5y0l5GBa9VD/sac9r92L/uDWqEgBDe4MNxUT0ro63ulseAf5aMaL4r9g4xdHiztJKKkzEnoTqVtRbgqZ/9KmTSgZ+NhvlyIid9iXgRBThsXc1c0XGIL
 ucyXyPCR
 CmuU7XIPzNkZnTSZcCmMDEBZ+y+5R0JBheN+I9mH+xZnwD8a7NAgOI+fQLjiS1/fOl+lkRIKan2DU8JoQzBOVVMHIGgY2ErQBFvuHpqzlNH+aCRako6Y1a8NSfoZx6P7s3XmjhL49+TiLN0gscKgkREBntwBCk+Qf64ufEquLcl8+XZ7TpgbcgPa4f7SznNxKqvRdeol29kq2TngxfjQbGv+/bfX/wuCcwhGJMwUIF0ZjOQIZEVATpNAy8g1KyxSWLaoZd059UcuqhJCG5gtYeEV9IzwkfvsPlgwfKe83GKkgVe8uU8ghzJX8HHqmMrLOZs0euTmgqIs14hQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/7/26 23:52, Ackerley Tng via B4 Relay wrote:
> From: Ackerley Tng <ackerleytng@google.com>
> 
> A guest_memfd folio is safe for conversion if guest_memfd holds the last
> references on it. Any other references on the folio may indicate another
> user, and guest_memfd cannot convert it to private if there may be an
> existing host user.
> 
> A folio will have extra refcounts if it is present in a per-CPU lru_add
> fbatch. guest_memfd does not actually participate in LRU, but
> freshly-allocated folios are still added to the lru_add fbatch for batch
> LRU statistics processing.

As discussed, what would happen if we mlocked gmem folios? In that case, they
could also have been added to the mlock cache (which we treat like an LRU cache).

But that's just a comment regarding the text here.

[...]

-- 
Cheers,

David

