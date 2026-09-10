Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FBB3C79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 09:59:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D1406B009F; Thu, 10 Sep 2026 05:59:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A8AC6B00A0; Thu, 10 Sep 2026 05:59:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BE6F6B00A1; Thu, 10 Sep 2026 05:59:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 487206B009F
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 05:59:12 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 917361A04B3
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 09:59:11 +0000 (UTC)
X-FDA: 85197404502.30.58ACB17
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id BD8ED1C0004
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 09:59:09 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Btbp/DdQ";
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789034349;
	b=i0GLX0YCBGrzJlYO/lqYsAAaW7bsKxO+QaF+lsfkxxUAq9NiQRXc9AuVZMzq0BLvKhZXQV
	GFM3+dMtnq3Wp26ZRpw6BwwUH/aWwRw6GhOzGCbWqscfsVVrEV7KXlZqa79kkuLiiDTIBD
	q8HpwZirPYPNZ8pJ1xDz+3YYsBs/4Xo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Btbp/DdQ";
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789034349;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7E7qL9hnMJksX9Fno6BkugSVMdHcPZ0KaVrs7NYY16s=;
	b=vOcHv0oYMGT5CKCkYfrgd5MzB5Qxu05015DpcUR3lMx4/VCIeC3NEfVuzsooYw9ufohH+O
	cDwPkmf9wKZArfTYuXf/+464Y168/y5O9JbkpfZLXLBWK5O8jHDaas1bQNJhA/Cv+iOXUv
	HxSDeX89k1By+6m5uyJb4OmVN9HoD08=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4F0D1600C8;
	Thu, 10 Sep 2026 09:59:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D81C1F000FF;
	Thu, 10 Sep 2026 09:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789034349;
	bh=7E7qL9hnMJksX9Fno6BkugSVMdHcPZ0KaVrs7NYY16s=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Btbp/DdQDkYguPGE72KqFMmtU62PXLGOhJ0BVA4TjekaMJ7fvAebinZO9+OCzfBGl
	 bVNJxH1goP4pUSAi8DwHCvmb7/XxSnj55za6Aw4mxJxj0Qxf8WdK06Nvlk8ir/G2PG
	 nv3oFP9VVn680YlbepBhluTI4FNqlR2RIac40sfu4z83Dfn7Gs5AnVNYH1AERlO8g/
	 O/uuq4aKITSnB3CCUCm5KnAiMgGtfX8KByqU3ga68/mWbWbRsGCbQ43yYIMZvxVY8P
	 6uYoKpLcmcjvXsLJkv8mBTwkXPQJo2m+p2ofMj5WVjmvyVYMna8FhMIvfDN8Tf+KW0
	 17DPj/qdtxCfA==
Message-ID: <dedad87b-909d-4d14-b914-ff2e28c414ce@kernel.org>
Date: Thu, 10 Sep 2026 11:58:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/9] KVM: guest_memfd: take the invalidate lock when
 unbinding a dying file
To: Shivank Garg <shivankg@amd.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Shuah Khan <shuah@kernel.org>, Chao Peng <chao.p.peng@linux.intel.com>,
 Nikunj A Dadhania <nikunj@amd.com>, Michael Roth <michael.roth@amd.com>,
 Pankaj Gupta <pankaj.gupta@amd.com>, Ackerley Tng <ackerleytng@google.com>,
 Sean Christopherson <seanjc@google.com>,
 Vishal Annapurve <vannapurve@google.com>,
 Nikita Kalyazin <nikita.kalyazin@linux.dev>,
 Patrick Roy <patrick.roy@linux.dev>, Pratik Sampat <prsampat@amd.com>,
 Ashish Kalra <Ashish.Kalra@amd.com>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Peter Shier <pshier@google.com>,
 Jim Mattson <jmattson@google.com>, Ricardo Koller <ricarkol@google.com>,
 Ira Weiny <iweiny@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>
Cc: linux-fsdevel@vger.kernel.org, linux-coco@lists.linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
 Sashiko <sashiko-bot@kernel.org>
References: <20260805-shivank-gmem-migrate-v3-0-00d8bdec4e1d@amd.com>
 <20260805-shivank-gmem-migrate-v3-1-00d8bdec4e1d@amd.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260805-shivank-gmem-migrate-v3-1-00d8bdec4e1d@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BD8ED1C0004
X-Stat-Signature: 77cz5i61qx3uu1o8xh5i3jobqs13d445
X-HE-Tag: 1789034349-454321
X-HE-Meta: U2FsdGVkX1+0XqwXFK9jqpi/GmybZD8Z8s97z90xrhXxPMpOprQOm3k+jlm3+tMWOUWyR+cq6UUYJL3QtU8q501pq1fH72HAfQxXquC88E/zw50EJd6DdaQRvio75m47FmwMUof5qT1M9mrfc9KUpqEHY7P5euYFvR+Luu/TcjiHikSefRuupDiNtQEVuYWTV2ZcaM4qnPz4RQOynzyqV5TNszGLyPaOdrJDQK7FUVrESiyj18mL9P81rsxqZMyCoOLpSZFXrcnWUPIca72GbABpVbc58Zej0v8AXnEeDYMjmA4C4NXHLGQrUIUCUJKwnVOQMwT2r8n5hVsaQKvHzOOy97/Tx3tTYJsTUJsEmgI6/LvAoZ98C87JxpTgfWFBdTcgBwJDdRAY8rnQNAd3G2U5WxkdPLqyAMRwE0azG2lLrJP/5EyWKHLLpowIPb+cNLo6kjvwIvvBWblXd/WWGY4ZrIvaU9RFC+xua4x/XKZwxqFyDfkZ6uhVqNukzu4aXKmLOWxZJrzmQyHdBviUPkjPQ9Aw6ooJ6yl+SAOGcEuApDW8+q0fSfImE9X+E5MJxNFS0aTkYu7dpVdjwH7bWzBPgMUOJ2DHaOiQzbCes8ivQv7ZcTfS81gLXibGDQMkQO6YUAUYuvSujnGiDh4sxNaIk0gm7XBK+8YXBLxYxQlv4JHzhCeV/wsdR+pYof1NhPXblp77Ft3aAL/Xl6eI8cOYTZXunAG5DVmwbOJaYggtRrtionJDNzAf77DYCVDmB7glf8AO3ZAB8Y+1h0+hTjhRdW2SIyqmdabsYiHe2o8mMnFZw3L9WjQFhE5rfXOpe8Tvou3hTmupWTAIB5Tg5KGNP35uTzyjJXy/xRy49WiYMy+0esbbr4HVOFOHjN0f4hdiC6v8Vg/oC2TkJwNqCNlRFMTk6ov6WdvYu24kz+2QvDUarL/HIeg5RKA+SZG51vzakkwN3C5iEzNlkQU
 GlaVH8d4
 5P/Ly80oWdbGk2a3FYrzj7IJELdfWtoVMFFiPVx+vy6BLTyZomyxNnpGwEx8qexylEsfkpFPhLd0hlM27wnijSO99rAR3dmDm+0diot1n+mAib0QywABsAo0GIUBcgm+GVrgaaOiF4M2O2CfbFFms92Aj1wVOuILFZFKnJ1eLvMzy6/BgmRUqxivg5LaNrUg1+gaiz91r3ZlM0w55H02fmDxSyxjzICoAJAvYdnU9Pkc3ZjFE3sV+Mg5KufrzpzwV3Ti9WiVFB0K78FD/m4zGeMdqt5bGESsz8YFphU5mYbZOHvbBHDPeBJXBqGemlMFAS3ShHTDy3i30ZKCK+VGsY8eoR32stb61HRbO3k3ivkTPUC13EMsHzZUcSO9oyZOE1Ki7diSUl2pMkc2E0HWT+T/xeliy8DfeZf5lgTVsLVBqulM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/5/26 08:40, Shivank Garg wrote:
> kvm_gmem_unbind() skips mapping->invalidate_lock when the guest_memfd
> file is already dying. All other paths that modify f->bindings hold
> that lock.
> 
> kvm_gmem_invalidate_{start,end}() checks f->bindings independently to
> decide whether to begin or end KVM MMU invalidations. So, the bindings
> must remain stable between the two calls. If a binding is removed in that
> window, start increments mmu_invalidate_in_progress but end does not
> decrement it. Example, unbind race with memory failure:
> 
>   CPU 0: memory failure               CPU 1: memslot delete
>   ----------------------------------  ---------------------------
>                                       (guest_memfd file is dying)
>   kvm_gmem_error_folio()
>     kvm_gmem_invalidate_start()
>       finds binding
>       mmu_invalidate_in_progress++
>                                       kvm_gmem_unbind()
>                                         get_file_active() fails
>                                         store NULL in bindings
>     kvm_gmem_invalidate_end()
>       no binding found
>       counter stays elevated
> 
> mmu_invalidate_retry() then returns 1 forever, so guest page faults
> retry without ever installing a mapping and the guest hangs.
> 
> Take the invalidate lock in the dying-file path too. This prevents unbind
> from removing a binding and leaking mmu_invalidate_in_progress. This is
> safe because any caller that reaches this path holds slots_lock, so
> kvm_gmem_release() cannot nullify the slots->gmem.file, until
> kvm_gmem_unbind() finishes.
> 
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://lore.kernel.org/all/20260728092027.225CF1F000E9@smtp.kernel.org
> Fixes: ae431059e75d ("KVM: guest_memfd: Remove bindings on memslot deletion when gmem is dying")
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> ---

This was sent independently in the meantime, correct? (or was it included in
this series, IOW what's the expected patch flow)

-- 
Cheers,

David

