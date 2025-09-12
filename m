Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 458C1CA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 17:15:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A200C6B0028; Fri, 12 Sep 2025 13:15:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F69C6B0029; Fri, 12 Sep 2025 13:15:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9338B8E0002; Fri, 12 Sep 2025 13:15:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 825716B0028
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 13:15:46 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4039DBBD13
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 17:15:46 +0000 (UTC)
X-FDA: 83881250292.03.743CBFD
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf23.hostedemail.com (Postfix) with ESMTP id 711E0140011
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 17:15:44 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ab4aAj5U;
	spf=pass (imf23.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757697344;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1M/JA9EobQm4/fkyUEBy+aOR9iJr1+HAKxCAevq03Q4=;
	b=DD9VZ8+E0mTNTOWIfwNsl8ejK1TINkFcbgsLUS/mBy+9la6LpwrD9MO6ul4ArUA4ACMbj9
	DIvZiB0MZiXizG7TW9OQNu4Cm3+0IFvnrri5iQV+INqdO97mKu6XYJtKivZyWACSRjMDA+
	3kexQAenicZ1ghUcVazAD6jDV96rdzY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757697344; a=rsa-sha256;
	cv=none;
	b=lqhsGcnYH9O+hgFv7E+ip3t6LgpUeXvDEQ+mdJ8il/6zpybJveGoRr42QmLueyjOX644IC
	DmApVStPDxnZQegEaUg1iFOrF3KmZAqCIRv8irEVh44KbP5Hhjvn8OgEM9lvaG/N1VJDGD
	VdaSq48crqKgaJC+nhGDgg1jLHC+ThE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ab4aAj5U;
	spf=pass (imf23.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Fri, 12 Sep 2025 10:15:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757697342;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1M/JA9EobQm4/fkyUEBy+aOR9iJr1+HAKxCAevq03Q4=;
	b=ab4aAj5UQT1aRuMiHELZYBT3/QUnYjH/YvaEGGZmD/CTKCK1JlzwiEdBhxl3MIG6C5KkDv
	Ao36h36MedRy8Wc8oXI33K3HGCowK6jg9QZzuAJPQBKsynkkIaqgdEtTIZoluxYsSRyvP4
	Gk5wqp3Ae/pnbDotXSPvUd5Jux9oe2o=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: bpf@vger.kernel.org, linux-mm@kvack.org, vbabka@suse.cz, 
	harry.yoo@oracle.com, mhocko@suse.com, bigeasy@linutronix.de, andrii@kernel.org, 
	memxor@gmail.com, akpm@linux-foundation.org, peterz@infradead.org, 
	rostedt@goodmis.org, hannes@cmpxchg.org
Subject: Re: [PATCH slab v5 3/6] mm: Introduce alloc_frozen_pages_nolock()
Message-ID: <33sckm5763xkrbctkjbyzmphopo2nry4s5cpyvcajmfhmc2plh@qspdcqd7h36k>
References: <20250909010007.1660-1-alexei.starovoitov@gmail.com>
 <20250909010007.1660-4-alexei.starovoitov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250909010007.1660-4-alexei.starovoitov@gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 711E0140011
X-Stat-Signature: 9stz3jkktbph3amm6sqg9yqhsxz3icin
X-Rspam-User: 
X-HE-Tag: 1757697344-326218
X-HE-Meta: U2FsdGVkX1+JkEMDGccYgfjGvOZSiVi9ZmHxxAC6aKfgaPAgAZvVzZ0lP2AABjJsu/PWvog+Kr0QNSvuA+VrnwouFuccnmoz0+Uwou/Lx2OeOmoIgS9BsNmZlzeHLdWe6Jg2pHMetySUeCcTY+MeD3Vq+Tf0bcS1BTPTvvhnDzve1zeAHOg5XPjlzC+0nhFWQxLXAYJ57D0q5Ga2qeCGd6qvgt1o7eRKL6TBsO+S1cwH1rgoNGz9UmawDMpmoMh9CLtLXkgeyZLQ/tFbIwXFNjA2FAwiLOu/3C6TeuAaZwgw+/uu7T7KbpMyV6zPQAo4vDMnOU8jKcWoeW9+n3hxnzCAxoPf9Yk9dNNMMXLwt2E/cSXFX/O4XADAcW1jDcNYVdEdYdAvbUZ8eyUmZnmr5mZCHJRG0C2whobD2CogQWK+qwV5gJR14BNPotgBoHEfAEoHK0rsPEuLlh/vc9y5Zb7x856BhcbPqc8+VozpGp6TKhv7TUD+LzWdLcbEzfIqudu7xSnDcm7lRqO6nus4xhmFy88vsSmtXVseRqbVYeV1pUmOXSUaqP853O4YOhjgskkdqVUfWY17OJYCSZNG3mWdc1PaVDt8qzUAYMYve9S4xyS5K7+xeSXoTLqYIQ7uKm64MAYo7Z5lI825Pju61kSawSdC8dyu/GhcGUrjNJL42bPMCeq6w9Bp43KE/ckyUB2D9olkqu3SHRDXUAB/Ev2p83pJxM+U/bSDv/q6TBjfdKH4ZmRGBJcPIwdoc1dn+/SASyC0CLOSA7moLi7+uVU4utXGMlga6UOxQm9CgIhpqWx1vR49xfAwSB62hD7wwmbUMB/oeEMddDk2djrqi31pMM9oT3OuX71Ho0Z+LtB1b8Lrcq0ESgXUVoOsumqVpSFO1Ozrh0QR3Sq/3+zftv/5FbwLzm/L8l3qO9AW3hoZcno8CxXVnBg8LE8NuLSWFJN51b5o0vPFyXoBbZy
 nxoLjxcU
 yY/40O4lBrzyelSzRKsJP1XHiHoGgWfhiiLCEObBmeJx03t7Nko8ag5XTonLxSpn9iR4MHEOZGjmIZXd8essyiYTGXJyhWK7TEXo+Um6gHlNtpDU8zmvOBc+NUOSNxtIXawJgvFn5JlP+zB+X6dYf22icUIE9QfDQQsVpdWN0j7+upyNDd7v8xMBNY1++8+xoI6S944HwIYKKGBQpu7+zGY+1Sjp/jxsd4XCsMgDZnyTU2p3LTTucb2evt5l91Kd1ginFQwenngd4XXZcwWkKG+20Mxabw16k8V5bg8B1UuFTFTLngRGAMxFu1j57OFTZhYWhpBcxnW5QPkyMMUU6A1fM9GJ2pI84NzqL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 08, 2025 at 06:00:04PM -0700, Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> Split alloc_pages_nolock() and introduce alloc_frozen_pages_nolock()
> to be used by alloc_slab_page().
> 
> Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>

