Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BB54CCA470
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 12:22:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95A798E0003; Wed,  1 Oct 2025 08:22:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90B418E0002; Wed,  1 Oct 2025 08:22:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 848438E0003; Wed,  1 Oct 2025 08:22:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 70F338E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 08:22:24 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 36F61BC815
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 12:22:24 +0000 (UTC)
X-FDA: 83949458208.07.54CE710
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id 155F5140009
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 12:22:21 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf09.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759321342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aeXq1FtEKMEGcd1X6F5pimnL4GuLi9B4eChqnBDj3p8=;
	b=S6QE5toXHp5J/P+ruqyJU2/Ky4FgA8nUrkvuS8fVPkG68Tvdot8ppf9fKkOGwk6AESEeMw
	qsi9rCvPrYEzO7GFBqGvWd157vAfStG9BBpQiOJ4m5ACJ8De4tWGTyOTqY29DcarUD5J15
	qf3HkiPRhJYNH6c93XdjuHNKqWX9TZc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf09.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759321342; a=rsa-sha256;
	cv=none;
	b=73jm9MvIDHnGe5St5n9x4uXJncrrTZWi8QzBodyd1n1pgoJhaTZrZMiJijTrOkbw8maHIj
	O6mHK7+fXHMGuwozZVfeAMJmjjmMn20YX4h/vMn4psDffJ3sfUHKX5jU0aZmxJD4qJyZjc
	Y2+bvNQJdONyR/b15tLxM7goa1o98Ko=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C67DA16F2;
	Wed,  1 Oct 2025 05:22:12 -0700 (PDT)
Received: from [10.57.66.40] (unknown [10.57.66.40])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1DC5B3F66E;
	Wed,  1 Oct 2025 05:22:14 -0700 (PDT)
Message-ID: <9e1b474e-b822-469a-990f-b27389a7f0e0@arm.com>
Date: Wed, 1 Oct 2025 14:22:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v5 00/18] pkeys-based page table hardening
To: Will Deacon <will@kernel.org>
Cc: Yang Shi <yang@os.amperecomputing.com>, linux-hardening@vger.kernel.org,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski
 <luto@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 David Hildenbrand <david@redhat.com>, Ira Weiny <ira.weiny@intel.com>,
 Jann Horn <jannh@google.com>, Jeff Xu <jeffxu@chromium.org>,
 Joey Gouly <joey.gouly@arm.com>, Kees Cook <kees@kernel.org>,
 Linus Walleij <linus.walleij@linaro.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Marc Zyngier <maz@kernel.org>,
 Mark Brown <broonie@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Maxwell Bland <mbland@motorola.com>, "Mike Rapoport (IBM)"
 <rppt@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Pierre Langlois <pierre.langlois@arm.com>,
 Quentin Perret <qperret@google.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Thomas Gleixner <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>,
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, x86@kernel.org
References: <20250815085512.2182322-1-kevin.brodsky@arm.com>
 <98c9689f-157b-4fbb-b1b4-15e5a68e2d32@os.amperecomputing.com>
 <8e4e5648-9b70-4257-92c5-14c60928e240@arm.com>
 <8f7b3f4e-bf56-4030-952f-962291e53ccc@arm.com>
 <aMwd7IJVECEy8mzf@willie-the-truck>
Content-Language: en-GB
From: Kevin Brodsky <kevin.brodsky@arm.com>
In-Reply-To: <aMwd7IJVECEy8mzf@willie-the-truck>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 155F5140009
X-Stat-Signature: ubbrgesks17g1eudsyiewfmi1a758dmw
X-HE-Tag: 1759321341-337674
X-HE-Meta: U2FsdGVkX18fTEHrvvJykdSIFS+zWMdxCvHNGvzMf94W1xhlZw7G/jyfuHGSK63spxUC7Lk8dBvxocGJ+q4SB+Bui2lotuSI5jzE4K5+q7hB21vtwuXXNl0hpvatgALMWNPOiI7+ZGteto80PGl4jXhy1jbkIW+frk8xAzpt+75w1S+MKcv9LSOJ3AqwXPfGLFbQ2hN7bdFjTXLwWT/sGSW5M0P89KzOiUrHzpnmrHVw+RCI+Fs4VLeWWcc9umu12eMjcc5hY0u+CUlrqg50DIy0uCHYlWTEONUh84k29lnZgoMhZjGVHiBSagazfAaTMYK+BgZhRR9THEcEao1kLh9I29AAf1m6topXbH7Ygbz7rO/o07kNgA0ChcC83DVFbagrHi4nPYe7cBxlCBT4zwqUvrdaJk0O85qw6mEOl/L26EkwF9LnzDjc77tzXsi76xTZm0lJbAQWPrIitO4432jUXsLGEvQMCVhpuECySG9XjhdaIkjy/83z+H9fw7U80vSjJsmk56h7O+x6HslOYkzx8g3n5UjhermR/agzxbhGM7bLNW7pPdFoeUSLkLY3akcmt6XvVh9hCoMuIlm5ThM9pbhgZEcGzbMbkLqfXfSLYEmzkXuTGvRDbRxUPDA733x2/wM3g80zxmkS0lmG+2uPyaP/s5d850XNAuNvBg9E2p0zk2PyBUOyp+l0ivHV68ecOO9AA8iXTYrIcHjy3pHAsQ0KBd2MIoLEIlytOMBHrnhVITe6tbNS0WvPyit+HnLc8/5LvWbfDfDRU2BUnFFty9vEhiAcxp0AUW3lj2T/gVvNbpNzF90BQfe6Spc7Py7/UDdOhVuw7VOmqF7A2gnLIm6de4ZN97+F6wPw4/ZR5cOijjH4yObTwE+QvRae0y2R2oqsxx332uKtlYX+O5bg3clt2GFC0NFDcHKIZQqn3czrf7QVh8kIqGZsjlJPdoQjIBrFjHZFTf4qup2
 pyKqWkcI
 Rvzph+BwIlF4NEfYQ1DiafI7OVkeMXXvUxyMxO53rMTygkMRfFLCxOB6cfXeX1aci4kpfh+soepzoijBuuiyuJjk1Zo5p5XAaqKE5Uz37ER0Ft7pN0fa26O5mizw8y8claduRcjSd9cVcWN4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18/09/2025 16:57, Will Deacon wrote:
> On Thu, Sep 18, 2025 at 04:15:52PM +0200, Kevin Brodsky wrote:
>> [...]
>>
>> For now, my plan is to stick to solution 3 from [2], i.e. force the
>> linear map to be PTE-mapped. This is easily done on arm64 as it is the
>> default, and is required for rodata=full, unless [1] is applied and the
>> system supports BBML2_NOABORT. See [1] for the potential performance
>> improvements we'd be missing out on (~5% ballpark). I'm not quite sure
>> what the picture looks like on x86 - it may well be more significant as
>> Rick suggested.
> Just as a data point, but forcing the linear map down to 4k would likely
> prevent us from being able to enable this on Android. We've measured a
> considerable (double digit %) increase in CPU power consumption for some
> real-life camera workloads when mapping the linear map at 4k granularity
> thanks to the additional memory traffic from the PTW.

Good to know!

> At some point, KFENCE required 4k granularity for the linear map, but we
> fixed it. rodata=full requires 4k granularity, but there are patches to
> fix that too. So I think we should avoid making the same mistake from
> the start for this series.

Understood, makes sense. I'll be looking into implementing the custom
PTP allocator I suggested above then.

- Kevin

