Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21074C55ABA
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 10:52:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C4846B0092; Wed,  5 Aug 2026 06:52:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 193D46B0093; Wed,  5 Aug 2026 06:52:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D0A96B0095; Wed,  5 Aug 2026 06:52:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E2C5A6B0092
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 06:52:09 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8F48F80414
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 10:52:09 +0000 (UTC)
X-FDA: 85066901178.03.28ACD94
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id 790B480002
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 10:52:07 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=MccCTMFj;
	spf=pass (imf02.hostedemail.com: domain of suzuki.poulose@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=suzuki.poulose@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785927127;
	b=YnidNvJduKkIciWCpXVWWwli8+o+kqLRvD58YEYRz34UNkAgVUPljPlRaVQegiC/xQGLqu
	rD3jtpqovDgX4NQiIUL6ZJRQbAHZb6MslrsK3tXoFtBXIXALxVUKx/UDRuJckCFy6MIQji
	uAadPYeymF6bFTgsPKmyArdaipIUU9s=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=MccCTMFj;
	spf=pass (imf02.hostedemail.com: domain of suzuki.poulose@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=suzuki.poulose@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785927127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mvlQKIhSa8gOqDPqoG6za229Ak8znZtWGgBhOteYeRI=;
	b=FE1Jd01+VAA6nfO75l8bjsbM20KR7K7FwihhJ3Mm0Wlo/lkTjWEjhx5j/5bm0mP5ebk3T6
	XMzZklFQivzRnIgV2G1pJFA4RrwAUfwbjCLM38Zqele0in8td1qN6a0hlnpMq/fLrthP10
	Ccskui+p7LOrbhvsedKvfFEHFVIUifY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5AB1216F2;
	Wed,  5 Aug 2026 03:52:02 -0700 (PDT)
Received: from [10.57.44.180] (unknown [10.57.44.180])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 743203F632;
	Wed,  5 Aug 2026 03:51:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785927126; bh=osqcgEZrB4tIRuddtFyChcekiAZrXeFH6SN6KLCXUeQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=MccCTMFj2hIMMjW795szcS5FxXktDxGWArGGS9xJv4VDpKX5Fq4pBTHZ+Dqo3dGwn
	 I3za+Zt5GbrL3mgj2p5MRpqTGbT/okZGd5AlVXHozUBVFgINdiUcI9YZ5TtSpFFehy
	 9K99FQyL3HUPo3MkG8rpZnXuHfDYEsMZGyYwsLhU=
Message-ID: <d2584ac3-51c7-4eac-8f37-ae29d899169c@arm.com>
Date: Wed, 5 Aug 2026 11:51:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 09/41] KVM: guest_memfd: Filter both shared and private
 when invalidating
Content-Language: en-GB
To: ackerleytng@google.com, aik@amd.com, andrew.jones@linux.dev,
 binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com,
 david@kernel.org, jmattson@google.com, jthoughton@google.com,
 michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com,
 qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com,
 shivankg@amd.com, steven.price@arm.com, tabba@google.com,
 willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com,
 forkloop@google.com, pratyush@kernel.org, aneesh.kumar@kernel.org,
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
 Peter Xu <peterx@redhat.com>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-coco@lists.linux.dev
References: <20260728-gmem-inplace-conversion-v9-0-35f9aec2aed2@google.com>
 <20260728-gmem-inplace-conversion-v9-9-35f9aec2aed2@google.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20260728-gmem-inplace-conversion-v9-9-35f9aec2aed2@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 790B480002
X-Stat-Signature: 73fe6oizhfwjoh1dzbkhotm1y9e4kma6
X-Rspam-User: 
X-HE-Tag: 1785927127-788048
X-HE-Meta: U2FsdGVkX1+BL6QVDo5V201kR3f+9R5Oi6kBkYzJlsSaAUtn7uOlneamftqyDjp4PwH/Tbb9H7GXpCe772bIdgRHJ2bvjshOGdf0W3HlX7lBykpwbQ2WywX8HIUKmEiMrb13rf3hD8wyta4Ctd8rLAt06b2N5EJTtD8R0mXwINOso7pvpGAnSZa1qSt8DNbDjdEiiYy/Tho/UwAK+CUBlVfSX1osKAFRNmIEG4A2H5Q1EtvjPf1IUi8YjjF+GG+MyORoume9Gi94dyxZos4adQ7evHSo5ZQpMPKaCtKkiAc3/q2osESS2PmkEj190JKwSaJLtgk0KInwBDb9G8u81jT2tjmzs0dgX87ynkYY/LEz2i/ZTbiuANhMRVNQHk/vueY4Xkf6wo/v+0LVFJFRM1WKe0abuYZ7J9VE70TOlnlgju2AdMw9PUDA/lsRqDPY3AJxEB5Xme9lS+mcISs6w2dCh4k9vrFOUGLL6DuQDseW++C3HhIoj+F1s1Nn7d3nni8FnXU/96SGKJkXajKJKCmZ3fhVmomVYEi4zGvHm3QL/Sw4XlPD7hcRzF29Q2nRW+PWOzkA1WchHaeltzaAdbVnYqPsxfMsVqDBKb2hmt8aF3eHwqg+f5PtRPa2IlU5uCu7HuEkxagV4yo3Q0J/AgHdbBQP10XDQbMssSGvMBCHhsSLVZOds2v66fnMUcRCLs1s9btgXd0PYBg7uNBNkjicrQypg1rSon2dbxaKXfJtQDpgmhobuoWNuYFiV0L3Cc3tDqNGg9FAdwsVHgmTwl1Q7uci1ppbXu9NhvH0VH9rSOYouWPdX0oPiZJNbF+/feeSDmU9wcy4gp2HwPj0dfhRfFjuJJsX3WdHcmP9bHtdlwA0RHBhwi1AGr8fNy2p5Efep8gXWJYJhn6T/C3q/3dyoFfv+JjfB/9kWEVemWQ7d7kC3k5VRprq1GwB8VIwLjfOa87TojAgxRUv6s9
 Wk9CVRNL
 SHe0djJFnQR6Cehnis00BbGz+dMLrr0qO5ERJOaXiOxx4YZe36tIz/7uYElqAMwccSCzykfragtvjHshAbIXpgObt1TQ2tQJU53IgZfAWM6YeQnh9NYc9LonfDmWtB4Hr0UMDKDkhfWEeZUAglIU57JtYDEWqTvYX6loa84BfbRi+COwbKbOteMEsdSC0VyJ06bjilr3uKbcEx6qEqQEm/6KffydMDt287s7J054aEjKWydfLO+pLkCHDbzruTXZyfEF8DRDZhLFhtGTIQvXx7R2jO/fxjPj6n8ansN5im2vNWcE8l9LqP1yCqFHEo6HNEEFy6ZHyH/AxxnQBl1zGPU2zaYZg1XO4DgCkXJDnUg0QZdI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29/07/2026 01:35, Ackerley Tng via B4 Relay wrote:
> From: Ackerley Tng <ackerleytng@google.com>
> 
> Before conversion, a guest_memfd could be either all shared, or all
> private, configured at creation time using the INIT_SHARED flag. Hence,
> when zapping pages from stage 2 page tables, guest_memfd can filter which
> to zap based on the initial shared/private state.
> 
> With conversion, guest_memfd tracks shared/private state on a per-page
> level, so a range can contain both private and shared pages. Zap both
> private and shared pages for simplicity.
> 
> An alternative would be to iterate guest_memfd attributes and only zap both
> if shared and private pages exist within the range. Setting both the shared
> and private filters lets the zapping logic do that iteration instead.
> 
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>


