Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4E52CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 16:09:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23DCF6B0029; Wed, 27 Aug 2025 12:09:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E7716B002A; Wed, 27 Aug 2025 12:09:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D64B6B002B; Wed, 27 Aug 2025 12:09:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ED4B56B0029
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 12:09:14 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8E30B59813
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 16:09:14 +0000 (UTC)
X-FDA: 83823021828.16.EB6D942
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id 362661C000F
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 16:09:12 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf21.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756310952;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2FIZ5aJCiTKj3kPm7g09Z5KJppD3cqCl82AjidiHnlo=;
	b=7ISLa0Xnl5WHxc7riTrigknVPe5fwsoC9WyO0PPpdFIn8O2fs8IL2XaUh+KmUSxfHUoPAO
	jbqRAYSrN/bpqM7nTf0x9vzWs81de5DCrkXrFfb4scBL7b/8JEqooFnit2teowgyfuGOjn
	OVTJ8v9wAwDJjb8p8K29jPxF4e5J6oA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf21.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756310952; a=rsa-sha256;
	cv=none;
	b=zKhOFD7v8UvISngsWH7j+bioaVZ8D7EhPjYObk09ZnDYjDfg16CXNRfn8V3f9Dw2tqcy5N
	qFDpx4cHu6YAg6L6J/C1m4xbANxAhELXApYwBKEDJHLE8LjRH5WgMCw1YFzKLO8bIPwhZK
	uzjkXbsI02MPGeg/ZnKE2bQMnvMVVuM=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C752B2720;
	Wed, 27 Aug 2025 09:09:02 -0700 (PDT)
Received: from [172.31.18.237] (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9CF663F738;
	Wed, 27 Aug 2025 09:09:05 -0700 (PDT)
Message-ID: <b9212134-0efa-422d-8cbf-4761e39ce8d6@arm.com>
Date: Wed, 27 Aug 2025 18:09:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v5 00/18] pkeys-based page table hardening
To: Yang Shi <yang@os.amperecomputing.com>, linux-hardening@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Andy Lutomirski <luto@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>, Dave Hansen <dave.hansen@linux.intel.com>,
 David Hildenbrand <david@redhat.com>, Ira Weiny <ira.weiny@intel.com>,
 Jann Horn <jannh@google.com>, Jeff Xu <jeffxu@chromium.org>,
 Joey Gouly <joey.gouly@arm.com>, Kees Cook <kees@kernel.org>,
 Linus Walleij <linus.walleij@linaro.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Marc Zyngier <maz@kernel.org>,
 Mark Brown <broonie@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Maxwell Bland <mbland@motorola.com>, "Mike Rapoport (IBM)"
 <rppt@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Pierre Langlois <pierre.langlois@arm.com>,
 Quentin Perret <qperret@google.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Thomas Gleixner <tglx@linutronix.de>,
 Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, x86@kernel.org
References: <20250815085512.2182322-1-kevin.brodsky@arm.com>
 <98c9689f-157b-4fbb-b1b4-15e5a68e2d32@os.amperecomputing.com>
 <8e4e5648-9b70-4257-92c5-14c60928e240@arm.com>
 <939ac25a-096f-46b3-90c1-d8cd6a9e445e@os.amperecomputing.com>
Content-Language: en-GB
From: Kevin Brodsky <kevin.brodsky@arm.com>
In-Reply-To: <939ac25a-096f-46b3-90c1-d8cd6a9e445e@os.amperecomputing.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: emsd1nsmk7rgcntjebb4ipqh9ptiiu87
X-Rspam-User: 
X-Rspamd-Queue-Id: 362661C000F
X-Rspamd-Server: rspam05
X-HE-Tag: 1756310952-498062
X-HE-Meta: U2FsdGVkX1+JkPQfhZZXITHOY1GzKb6pqO2mEy/IeOrHDIRb7Y+Fv9MOX+XQ6QPgCKz6H5UPPYup1ohjnuHo5LCqX+YM9V+t81e3rdiW1iPLYCzkccls9vNw3UPOBLtKljnp1T7KzrA0CHcCFRR5m4LOjnIdPjVKc2/5O63+DGr6fSchVIX3kE04hKQjNdIn+M0dkjAMBV89UCMfyNWjGjvvNgv6qww3WWYXnfm637PkRQN0+8nmaxCQS97XkW0K8n/XXBdn4UqDInK4oStfTspzo4nAh01TiDp17l7UkeSXff+kuGTMEmX+lPkoeZ/xf5yWBHXZidZGqmoT0pjjMfTej9yFeUTTetRwr2isTSoyvmxj4L0Ir/XgEpnxSo2XOSxj9xI9WXpCu+YJSBhESfAw4hWC1kp756MNupsrC8TJTWKa1p1jWjB3PFwZstq/xO5dCRPfOPZORPWaWqLT4psfVmEyuZFEYNFuhwjG7Dn6dW1ovZIffH8CudKBNc65IJ/fmqMVamLZkLyqO8Gk9jxJTvXdRGF3+ODd7CAh1Koc5GETGNE7w+bI7MXfRaSEqUy31NX6X68vY1h5LrDstyarYOyX1olVEIdBApWITpTfyl3E8uSXF3rmrftHF7VojVSVBgWgL9Qp6YBX2yHYT5Unmvpg2t2IheoFHlrOYWU6LWA+O14GDEEKcJFuLLMN7nl5B9ckMQ8I6viOUcW7VYHrl+dKfn5lD5lgYv00EmNFr4cTvJwYnTG1z2WSQXUbpor7FdJQez8UqUsCWGDcexzGn2PGa3kQkUR9AMWCA0G6oLYmep847JedQtWXGfu9oxIny1boZ9pNnLjcTiDzJEjUBy+Fdl/1EYNaUAALf7/8kt9AFH6j5dxaLtLXkZL/cG5WDQXngAbKVRVck/WtgxREX2vzeKAUqSSbLQe/PMeaYdrTeIKnszbcJPgo6TD8vhf33LN3lbKQRIs/eic
 dF+dGp1Y
 gry+M973vNyIj7243H8tEAamv4DLT8flqpd1zPiSyRflfNI/p/ztzLPEWfLz5JXN3IBx8HLfrDX+Tf/1z51NJqyrKLSj1QgKNqvaDi14TrvwIkaFytMEf/OAEns3CEBH44yNnRVLYengUEYAnfrQMa1SUhQn3ezh5l+Cy03jJUDyzfXY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/08/2025 21:18, Yang Shi wrote:
>>
>>>> from a contiguous cache of pages could help minimise the overhead, as
>>>> proposed for x86 in [1].
>>> I'm a little bit confused about how this can work. The contiguous
>>> cache of pages should be some large page, for example, 2M. But the
>>> page table pages allocated from the cache may have different
>>> permissions if I understand correctly. The default permission is RO,
>>> but some of them may become R/W at sometime, for example, when calling
>>> set_pte_at(). You still need to split the linear mapping, right?
>> When such a helper is called, *all* PTPs become writeable - there is no
>> per-PTP permission switching.
>
> OK, so all PTPs in the same contiguous cache will become writeable
> even though the helper (i.e. set_pte_at()) is just called on one of
> the PTPs.  But doesn't it compromise the page table hardening somehow?
> The PTPs from the same cache may belong to different processes. 

First just a note that this is true regardless of how the PTPs are
allocated (i.e. this is already the case in this version of the series).

Either way, yes you are right, this approach does not introduce any
isolation *between* page tables - pgtable helpers are able to write to
all page tables. In principle it should be possible to use a different
pkey for kernel and user page tables, but that would make the kpkeys
level switching in helpers quite a bit more complicated. Isolating
further is impractical as we have so few pkeys (just 8 on arm64).

That said, what kpkeys really tries to protect against is the direct
corruption of critical data by arbitrary (unprivileged) code. If the
attacker is able to manipulate calls to set_pte() and the likes, kpkeys
cannot provide much protection - even if we restricted the writes to a
specific set of page tables, the attacker would still be able to insert
a translation to any arbitrary physical page.

- Kevin

