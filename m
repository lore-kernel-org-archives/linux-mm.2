Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C3A0C5AC82
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 09:22:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 053306B008C; Mon, 10 Aug 2026 05:22:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 004696B0092; Mon, 10 Aug 2026 05:22:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E353B6B0093; Mon, 10 Aug 2026 05:22:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7F7196B008C
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 05:22:28 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1FD98406B6
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 09:22:28 +0000 (UTC)
X-FDA: 85084819176.10.09F57F2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 49AA88000C
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 09:22:26 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gcoznZ5A;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786353746;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6wQr3PYTUoSXpaDl5k0IG1zQOBI7tNXiUqLf3cd1RKg=;
	b=KCJ0itxi0XuN6aj06j9Hq1yiWkzg2gpFpLpSYLyZtwkkkU/bLumhbJW1T0C+sxwHQHNamd
	/sxA6KA/yeTi2hY/aoqGa6F89b1aDd16QxMgLcSyjeaZK9KpdpMc4AXjyMCn5ZrB4jqlYQ
	QS1T7Xwzc5Ib3KOpBqd1J6ehZP0Bdb4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786353746;
	b=qRqC8WoxUL1RRuCE1HJXFwyqbLPb+Kl2TOKXftACxtdUF6OT6C88etx+Gb16Nw3MRZ8UvK
	zLpTDflaRpBcoyHMkkO7gojCtlOLt+C3hkjI4NWb+ef2mZvfkLmYyeGreDSNX5G6tUyeK/
	ZiEsQ+6tbKT52bqfe7tI6a2DPbzaNjE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gcoznZ5A;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 67488434B6;
	Mon, 10 Aug 2026 09:22:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 459751F000E9;
	Mon, 10 Aug 2026 09:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786353745;
	bh=6wQr3PYTUoSXpaDl5k0IG1zQOBI7tNXiUqLf3cd1RKg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=gcoznZ5AtoqypeuzFMUFCV0SMZb31NgwLMyAOZz/m430M40GrLBfXae1BEO+LjcA4
	 XuKCG/K1eNaSIhwwyrXHHUUiAagMRg08hWANytGDAoToeNFKX4wR71XEYFGkFbUWjk
	 xqs2uRpDOpUmvayAD1TsECcSybfbFE7IbwuCUQxc4kE3FZ6eF4eAJEg/qTFVk5suAe
	 FstVMR84DcIukqC/PhHwIPZj3vMsyQyBIi/Yiy32UcvUROna5tfQH/+wkTGaeZLDOi
	 d0eblAzJLiLUDuD98q1S66cpzfD+9zFh8IrH7rGPro3csMwEaReIYEyXaXQjHV5Z0Y
	 tgGH+JPNFocaw==
Message-ID: <a30391cf-cca5-4e6c-a3cd-a71c5b88d1f5@kernel.org>
Date: Mon, 10 Aug 2026 11:22:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 14/41] mm/gup: factor out LRU cache draining for folio
 into lru_cache_drain_for_folio()
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
 <20260807-gmem-inplace-conversion-v10-14-2fc18ee6d3ba@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260807-gmem-inplace-conversion-v10-14-2fc18ee6d3ba@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 49AA88000C
X-Stat-Signature: e3tbwn7kuq5prr3doee1xteonpo8wf1i
X-HE-Tag: 1786353746-732061
X-HE-Meta: U2FsdGVkX19uMMgnDTVGw1Vg8VImk9tOVKDBsTfWXO9UHfOtgNZGiAxUFIwwgrS7qM4Fz/CZ5fmhpmniLF9Hu8SsIjHucvgiHIclQ9z0oYxhExb1deOYY/k4tzwBitaXC8yW9Vr7bI6h3xah9CtP/jGMGeoP6d2XKxVMDxfWGZ6Zjw3mJNBynQlkm5bU4W5i5bc5dY/+DoVxHFSzL0naVpzjYUNjOPtkb+KcDN8q89mPRrn8rzm26qFZ2fjd+pA2BCtGHNsUkKYvcB2zp/Q9c5ueTYKpvKTRlSzpvgJLaqswEyKD3Msi0FEBkBq8yqB25ru8mXEVcFjDC1iBewRbheB3wvGAeL7cxhpEUKXN7HCdJI6u9kXyQVG+88xxFiPW0wvGejIhkf8VYTmQvfQ3SvsdYgPOj+Cu7dhUJt3u5RDBJl7mIC+LLf12F5Cl2zztDj3clTaPfrlYLuUXNoojQkPKbUYPleMVwjJXpFnUs+d077wtQq/5thJJ/vXWkInxHIXQWRBF8ezjCKO5tx7C3Gf6jovDWtjFYv9LH51zoEN0aFS8sys/9N/uAt4rJ7K1RzIimJKkNf9pfEYJow7+9pyg0EE0BePZxhvTGvbahucX6i+CEIgHu/y2dcyEdVPsRQS1OBByXRCqvctIeJ1OVsTzkgDzZOHczVSUgF6TVgLOZQFT2PspLMcc2RQKvQwElmvWsVJqR1Qe4fRvZKVBbgMwnzrpmaDtVOQ6sd9ht2wunznvbMcR6KshhU6z0kmyImombdmIqvc8ApcFyhB5buLgxQQCsroepIbCnrAFMvJHfKjEH0pmq3J/3YV3eIaar6EPfxT6pLVyo0zqxmjBNyeeSe3NO+DHsUE/d1SleXjkQwLdi0criFXP/N8oObzYj9rB4tcKWGiRaWKbSltJ6VRAo3XOEK7VZgROITOhYqKvW5vP1vJAHva2My31xwWa2eAP+LeOtX/zd/7LLZ5
 SLR80U80
 YDkUpZXWsYfvRrRbEuTF2/0kb0gXQWCr84LifzgLnilZBzNgCdytBDNehJEA4ey3MrNeDlOTYEx2zGUJu9rsz+cFYhM4zyV+24VVEiBAodMeGTJIqgBgRZU2MpkmZMdyKYWlbJrgSNSyb+EmbvHACZAwBMRt/NZMPLs2INr+63svUW/Oijo6xMwZ4jW0+PCvW5jKi1Z7Wop2BGMUdhIo3W7m6J3wurxEUF+xceiJ+zf7ZFJGjd+Fz5I3u1eSM2SBX50HsrwwZrRLSl5+D00ww6/G3Uwfzp8Fg0C6rArkDXQx37dXcBX8DXFyXBbaBwidN4TqW5mtjLUqMNJOiFv1nfuACkmwfYOnRZhcr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/7/26 23:52, Ackerley Tng via B4 Relay wrote:
> From: "David Hildenbrand (Arm)" <david@kernel.org>
> 
> KVM with guest_memfd wants to remove any folio references due to LRU
> caches, as it really must only allow to convert folios from shared to
> private when there are no unexpected folio references (e.g., from GUP
> references).
> 
> So, to drive the refcount down, it needs a way to flush the LRU caches.
> Let's factor out what we have in lru_cache_drain_for_folio(). Document
> it, and also mention that concurrent folio (un)mapping might, in theory,
> miss detecting LRU cache references. Keep obtaining the expected refcount
> twice to minimize the possibility. For the current and future user that
> should work, and we don't really have a better alternative: we could
> detect if the mapcount changed, but it would still be racy and add more
> complexity with questionable benefit.
> 
> Maybe there is a chance to avoid the draining entirely in the future,
> by avoiding extra references from the LRU cache: Hugh thinks there might
> be a way. But for the time being, this handling is unfortunately
> required.
> 
> Make folio_may_be_lru_cached() accept a const pointer so
> lru_cache_drain_for_folio() can accept a const pointer as well.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> ---

If all goes well, this patch should go into 7.3-rc1. So once you rebase, you'd
get it for free :)

-- 
Cheers,

David

