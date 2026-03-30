Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 418B11061B13
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 16:19:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F3DD6B008C; Mon, 30 Mar 2026 12:19:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A4396B0095; Mon, 30 Mar 2026 12:19:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86C1B6B0096; Mon, 30 Mar 2026 12:19:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6F1986B008C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 12:19:58 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 830301407F1
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 16:19:57 +0000 (UTC)
X-FDA: 84603240834.24.F1F08B5
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf09.hostedemail.com (Postfix) with ESMTP id 93994140011
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 16:19:54 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ZdozrY14;
	spf=none (imf09.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774887595;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z7YLDVYxqF/+f1DCCJKbVAIzX4V8YvHeDqe3ffDzeSI=;
	b=NICK3KJPOKOXhjUtMC85kIANED0/eZrEiVYeFsJWllYu7dY1VUnbk3tFJKQ/cjTA4eznxD
	s9SlzRW8XI9UISF/zntw7ML9OujJpskAc/92RP0xeozlRbjs6YlJrB9zGbHSfjSH7T4U2B
	wt/p4gkOBasQZMFLstapr+8Gm7za8r0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ZdozrY14;
	spf=none (imf09.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774887595; a=rsa-sha256;
	cv=none;
	b=twvPaUEnvdL+4pJDpM3dNZs6Cm0lROgJfwQKCmdClWC82+eJZ+pYiMSxEeCalCkBLxW5Hm
	h+ml8rrKRNnEM5NB4dhwVIZUZktXftab0hNp5McEM8YV1SXNWgPsmFLVY8NWWyKa9o4KxS
	i/QjuCnH3sEm7IeY7VkWiP+1RbA4kbg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=z7YLDVYxqF/+f1DCCJKbVAIzX4V8YvHeDqe3ffDzeSI=; b=ZdozrY14XCATmDIlNwlFmzEBwf
	z/K5h87go5Bk2q/blH/hdo9V+pBArg3wPGmyDuHmF8uq/waJkppzeNH8Y45JHHAXDq0IWkHhCCggz
	B8ACncOFhZP6rHi13nM5D3Y/NzwKbDJfwHj/oGAeLxXUv4FoslIrDe+ALSS28fL9hYULE9MgJeJRk
	nd8T/a3GN0RzipUyfwxLfhvmzhSVaKkgq7Gvj8OnQRLkzr9k7V4tKomyIhhKCCiuglHJ5TvrctwId
	CBfpXfmewANcXuQPzuQCftfN+xcZs4YrrvuPelV03TocJrCjQNLc5fnVbP+KbgNcADUZCWra+hNVe
	wm7GzVZw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w7FL4-00000006wOx-3GNU;
	Mon, 30 Mar 2026 16:19:42 +0000
Date: Mon, 30 Mar 2026 17:19:42 +0100
From: Matthew Wilcox <willy@infradead.org>
To: WANG Rui <r@hev.cc>
Cc: ziy@nvidia.com, ljs@kernel.org, Liam.Howlett@oracle.com,
	akpm@linux-foundation.org, baohua@kernel.org,
	baolin.wang@linux.alibaba.com, brauner@kernel.org, clm@fb.com,
	david@kernel.org, dev.jain@arm.com, dsterba@suse.com, jack@suse.cz,
	lance.yang@linux.dev, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	mhocko@suse.com, npache@redhat.com, rppt@kernel.org,
	ryan.roberts@arm.com, shuah@kernel.org, songliubraving@fb.com,
	surenb@google.com, vbabka@kernel.org, viro@zeniv.linux.org.uk
Subject: Re: [PATCH v1 05/10] mm/huge_memory: remove READ_ONLY_THP_FOR_FS
 from file_thp_enabled()
Message-ID: <acqinu8H5jo3Zw7b@casper.infradead.org>
References: <DDFEC0C1-3ECF-41CC-9630-A4A742F2B842@nvidia.com>
 <20260330160942.173324-1-r@hev.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260330160942.173324-1-r@hev.cc>
X-Rspam-User: 
X-Stat-Signature: 5dhew1ejxasipwsyz5p7r1zry1qui9g7
X-Rspamd-Queue-Id: 93994140011
X-Rspamd-Server: rspam09
X-HE-Tag: 1774887594-513833
X-HE-Meta: U2FsdGVkX1/2yGhJ1ruMXt3eh2OvDenvyFT3tLmynVy9JvLfUvlyBICHEy1aPu+UPI4LYE/UwiyQib0De59ewWl+Zoc4dO9A0vkAfrmMEoayv6+vOAEvChTUb3deOfbuwa90TwJjHNxEbyq5VE1LWJPACFfnZ6znTylWynJssUx8fkcgarBseV7IXwm2DOo/hZ+rFoOsrOdVG6w7c4l5g+tB8GSyYQU/g4hv5V+JsIKCf/2ex+QQVxwCuN0A9wDz/Cj1WS57Lno9B3z6XV65mXWU17McpqAx5itLEAV9FY99tec5aNYS9TDWBT0jH+5aPU5dOsf0WhsLJZIg7qBC5T/S7WR3ZuwPB5pN7K7I3gYnXVKk2bk3xXJLoXydea8Ih2ND1arhyenrGTOcIDqOsRvxqNyw37M1OH2McWkyZzfwlyDjxo45aN5ekplRI9vTX+BhQDjQmNGYc6Ye84+6z8XMow5zNCgugtM2vfZRVm/BwM5QaBxq9ZX5j5mQVWquyRSjmNxhJHgK9nKzP5t96JvqFI8GYx1F1I0YuoGKrau9NWGoxxprLOfy7elQkK8rlPw1pbCzFFU76xZaictuNpDB1hUSBjeejk5KbQHHbZPuoteOlxP/h7rXUaATgBM3jmcx+e8xnSPJ64qaKU9b9JwlLKjlUrg9Xj3mSLmAVHzYPpUJefgDAl4KH3TawQSWpMdEWMEWInwDa3uI4ai/SJjXMvUXTy3i554a05KO3PKbJQC2oSmyen6ea2N3P58qCRbYPOKODAufxkGv6B9VfZsT7OHq8PnIhZSOG1AKniGU0KqVCyfsNKjdeEw244z4/KAvnewQc3k3i4phYP0NsoIIexOlcL1yMVFGZ/7XWCLf4xKrvG808Fzxdf/fsxfvtgWkPxhtoLB5X47CrdKDuucMcKzwF/apUl1RAU94s7aYP/qvtHIOUQgr6Cb021Rz1+luMZPT7hsVlEDVR9j
 biYb0vZq
 qHojpujpy5V7i5EA0HOktTIRMqeBDmF2YQXk8D04J/M/y9ASCXndRXBVEEEHi8cIhPAEQVd1nBgK6HcJMGtZK61dcOgKsNQo4CqQ5KjhF15xR4aHu+qraMpmS+sT754fPKfLhquPjwKChlfnfCwvvplV2gH4GXxAhVIBP49W3+/K4uB1SFM/6G+MeYNhRT3sPsWIJbffrBMr6fuX11QcaR+NTjEnBZT9pZhYuEAl5v5GrHCt05fVBH/ug4vTHod7Q4F87iuuqjR3MSI0RwoQ2j3sxiWQSi0TBTEr9QzX6j3nNv1ktou161vjyrPr5Vg9ZgMwQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 31, 2026 at 12:09:42AM +0800, WANG Rui wrote:
> Given the diversity of filesystems in use, each one requires dedicated
> engineering effort to implement and validate large folio support, and
> that assumes both sufficient resources and prioritization on the
> filesystem side. Even after support lands, coverage across different
> base page sizes and configurations may take additional time to mature.
> 
> What I am really concerned about is the transition period: if filesystem
> support is not yet broadly ready, while we have already removed the
> fallback path, we may end up in a situation where PMD-sized mappings
> become effectively unavailable on many systems for some time.
> 
> This is not about the long-term direction, but about the timing and
> practical readiness.

If we leave this fallback in place, we'll never get filesystems to move
forward.  It's time to rip off this bandaid; they've got eight months
before the next stable kernel.  I've talked to them about it for years

LSFMM 2022: https://lwn.net/Articles/893512/
LSFMM 2023: https://lwn.net/Articles/931794/
LSFMM 2024: https://lwn.net/Articles/973565/
LSFMM 2025: https://lwn.net/Articles/1015320/

(and earlier, but I think I've made my point)

