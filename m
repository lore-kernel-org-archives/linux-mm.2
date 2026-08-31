Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C254FC61DE2
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 11:33:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 904D16B008A; Mon, 31 Aug 2026 07:33:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DCD76B008C; Mon, 31 Aug 2026 07:33:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F2216B0099; Mon, 31 Aug 2026 07:33:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5BE0A6B008A
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 07:33:01 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4737E80465
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 11:33:00 +0000 (UTC)
X-FDA: 85161352920.21.3488726
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id A4C2B12000A
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 11:32:58 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AZJyrgmM;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788175978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WH9GLRjSzyUmXP73YbT8GymaYDLOXQlGnVZRz7SJVBA=;
	b=vIrlAcnmrnwNsgzRr4jQs96Rf1DnaPGro3xVzvAFi7nG9yjM5FriJbWYREY2XYdFOQyR32
	eY3Bxl6MpXc64Tqe6SZXkqjpOd36tOR5P+t0yt2gtWRuggUBVPUQgQNNiEkNmyY95R1o3H
	PuKyIZ4+lXq2CUlmD3p1ygYWRQ8kAUs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788175978;
	b=Soadhk0HnBg9O6k2vaYprVHPySKRQdG8c4v+VwpjnAbPVNFNjRIYsSBpimwchpYkXrgITV
	UuCCI6+uZbOWDxIqTca75vK7XFYLt6IW56RMPK6IEZEiNVTDo2ZWyxd9X20Z82RXxrGWvw
	dS3XF8a7kWTMnT7IVqX0/PZlvBLaIEU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AZJyrgmM;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3E41D60213;
	Mon, 31 Aug 2026 11:32:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93E191F000E9;
	Mon, 31 Aug 2026 11:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788175978;
	bh=WH9GLRjSzyUmXP73YbT8GymaYDLOXQlGnVZRz7SJVBA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AZJyrgmM8QADM/tQ3djTAeARnE0tu71LsYAnpmqOKEj9/Wtt3nwHniVayVY8E0Toa
	 yOc5jOJtEmC3bTWpfpt3zQGdo1fQ9ZleHcWHBaMU8ssVlG+Ke0eEyvGXlXmRFCnQaj
	 24DWfOWiKUIVTcMRoDf8GLwWworUIMllAjQPrMak3Uhn+2l8psqWw7Z70Ac7fmF9Mj
	 s5xWmHPx0ttQkWplwpmg38jECJ3umgKKp4Q9iMYLezRSHDeetagS7TrEN9nDaw0PxY
	 MWZfkVXytlJKkgMMAQ1j+jROPE42uPqSohV8GVbsUZvr6h+q88wozzSnTj8/xy/yXH
	 LgAp5GZKJQY0w==
Date: Mon, 31 Aug 2026 14:32:49 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Eli Billauer <eli.billauer@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Brad Warrum <bwarrum@linux.ibm.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Michal Simek <michal.simek@amd.com>,
	Ritu Agarwal <rituagar@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 2/4] char: xillybus: replace __get_free_pages() with
 kmalloc()
Message-ID: <apVmYXlqsVr_p4Oc@kernel.org>
References: <20260830-char-misc-v1-0-05e2ce44f291@kernel.org>
 <20260830-char-misc-v1-2-05e2ce44f291@kernel.org>
 <f6001085-9234-4025-ff34-6cc4a66c293a@outbound.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f6001085-9234-4025-ff34-6cc4a66c293a@outbound.gmail.com>
X-Stat-Signature: 4nt6o9qi53cnhat49wg186ys3sbi9eyx
X-Rspamd-Queue-Id: A4C2B12000A
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788175978-234447
X-HE-Meta: U2FsdGVkX1/cu+8hGN6OLkqlSNNYF2EGm20hyq73AhwFE5lS6zgBFdOrSE9i4eH1Z6x/PZ8FlegVeB8nmiltVwwTO1P58Nd1sERQxjTcmzPPMiWUVeiO6NWMDEehh5K377nQU9McON7RaDRtQR80FI7tOwmslkDb4rd5JPAziwpR8KjJZUWfo1atZBwIiYEOEiDclAhna8sbeN/pNfkHyDMXW7rYOgfVkyhvrBM8V5ql+qNBdb9iu5XeqSfs/jU+XWVUpozZTi8/L055kF9bTUz8t4cPc3biP1bnANa1R9WT8sUrVDTr/fxMl/OCUHcCeRwr3lP88cFr8kPX4mesbi+rCqGQJkT7o6Q1c7EuKHgFZBJ/YGjQwcZwCt8DY77dymR4M7A5Jwh+HKJF/5F28ID006KnFyqZpr9x27W2Yq68PDnHhpQA4rf1LfEmTLZPh2bXwoWmies2Zp9F0ixhu0w/tw8BaEifVzBmDTrSzfEY2dizz9j/VSsOeWrlVKX27e2ykzoCQ5TZMcEvnj9mHxeBWcT39DQPndYy9R8OAyQPa2WZobHL50pzRkF3DAuQa4H1f+XAIcCQrnt/NEwLEvnw9cUAeCmKDWbcvzPpIaVT0tRmNN1YMylYVcvihaEZcZ/DYaIlTXvGXxpFQfeM5er2GZ8x3nMy5EGDhXhcGcDvu1LV2bq7w/tE2nBmyyRuQfjTco07U/gcySxqL16DOG4ve583DpiN6jG0gPB6c4dEwtIcDJDyHqjEnYyOnBLaJ4fjGu3kNuaoR5tEv5ftO6A8Hdr/tlib/Qme0CHFN04TBfcQO48tzrKi2kNk5RvrmbrJ/aZnGjZvLlbpgtHYRLbRT7dEubdRx6pQUDivgDkxlu/cSJhzzhmk3dL3mdrKDqeP296/v5ja/OZQ07HuVl44slEsUVow6tbahUGavfVwGEV4mWL+uzXBP6puEs59lRprAcJjrHXPMrY3key
 7nKfROci
 kizbZRbDv5EIXHUES4TjL2inYsk6nHaVg9I+1trrevhDXzoKlpMZPvonH3qDooWuodujepEYEsWbidChOuPGOEPFiSJuJnXVnIPlTcBNdXH+LAp+J4tDiy0eH5aqvsYJNqiVKHubpKzp+83uqfKRjd85M+5Yj2TYrrqTr7vk2SPQqPgDzrKP/tHrDR1LGA7o4j23ICT6i3KxWe32FC1R+vVIhM7SYDwGuj/OQz6gFIyw2IrbHrjwXdCBRckBEUWg5edT9Ozzqme8TL2x5GMXdFYY6zqUphNpj5s7hc+quJU2bbATBqF6jWLEJ8AvtuoPrrHRaJ0QtwWpGkoJXez30e1wdrL5zmOrtP/XQBXbkBmUGR/JLGxtSSWJqfsUK9J/sAbq+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 31, 2026 at 12:13:08PM +0200, Eli Billauer wrote:
> On 30/08/2026 9:47, Mike Rapoport (Microsoft) wrote:
> > fifo_init() allocates the buffers backing the software FIFO and
> > endpoint_alloc() allocates the transfer buffers of a USB endpoint.
> > 
> > These buffers can be allocated with kmalloc() as there's nothing special
> > about them to go directly to the page allocator.
> 
> Except that they are a bit large.
> 
> fifo_init() may be requested to allocate up to 256 MB of buffer memory. This
> memory resource is split into an array of buffers (fifo->mem[i]), each 64
> kiB (or less, if there's trouble obtaining segments of this size).
> 
> Citing Documentation/core-api/memory-allocation.rst:
> 
> "The maximal size of a chunk that can be allocated with `kmalloc` is
> limited. The actual limit depends on the hardware and the kernel
> configuration, but it is a good practice to use `kmalloc` for objects
> smaller than page size."

For large sizes kmalloc falls back to page allocator anyway.

And the doc is out of date unfortunately.
 
> Regards,
>    Eli

-- 
Sincerely yours,
Mike.

