Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98C9CCA1016
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 02:16:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B12E98E0002; Mon,  8 Sep 2025 22:16:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC3758E0001; Mon,  8 Sep 2025 22:16:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D9268E0002; Mon,  8 Sep 2025 22:16:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 887798E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 22:16:07 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 18766587DA
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 02:16:07 +0000 (UTC)
X-FDA: 83868096774.04.56383BB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 56334140007
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 02:16:05 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Ji+MvIMJ;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757384165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2TKV760fRnnRQ3DBjX3Iximd/yUD+u3aPBxTUgdAocc=;
	b=WsXtZqS4/wHd1Y6y7wxGYXdQMy3lxNNgvPurDYXZqbLDewaHV0V/1CWpwCqfc7IH/O7HqL
	D11k2Swn1DuvBlX4ZfuHtMA7CuaBtchZWx8fAEhE8j/bQSAwmyz2tQ97eip/hEsA6W6hMg
	h5ZT0bUZkJSwn2vQ4iA3IT0dI5wVLXg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757384165; a=rsa-sha256;
	cv=none;
	b=tQTuHMmtwBrdPBG4sD5R+B2YZsIj+l97nP73gsjJbKKDK6r7sZUJmjaIUB9WTGAikrD7H0
	PNUN7BkkqMCo1I99t/Uczz2h0TpTp+OFjsmxcBkAuNyo3XRLyA6/vZbjUAEVy13irEOUZo
	A/Rrhd7eCxD//IrE7vZTghLIh6lKsvs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Ji+MvIMJ;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 26F3543E29;
	Tue,  9 Sep 2025 02:16:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07D67C4CEF1;
	Tue,  9 Sep 2025 02:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757384164;
	bh=xKkpvDQWGBF1SNQMUrwQak6dbS7+Kaawp2n8VZWz+M4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Ji+MvIMJjnCzrm7JJouZjdcrryC08RI/Y6GwKlm7FmWFFjuLZhlIDnztPmdSccd+S
	 XVAieks/t16/1DrhnW8YjQQ5RGHB69prkFM4EIJDH7kM1ar3vtf0c34VBvQ5OpxJXk
	 jgytnzkbwbD6aEm0RBJgjRvCRYzqKtlr879Qt3uE=
Date: Mon, 8 Sep 2025 19:16:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, Alexander Gordeev
 <agordeev@linux.ibm.com>, Andreas Larsson <andreas@gaisler.com>, Boris
 Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov <bp@alien8.de>,
 Catalin Marinas <catalin.marinas@arm.com>, Christophe Leroy
 <christophe.leroy@csgroup.eu>, Dave Hansen <dave.hansen@linux.intel.com>,
 David Hildenbrand <david@redhat.com>, "David S. Miller"
 <davem@davemloft.net>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar
 <mingo@redhat.com>, Jann Horn <jannh@google.com>, Juergen Gross
 <jgross@suse.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo
 Stoakes <lorenzo.stoakes@oracle.com>, Madhavan Srinivasan
 <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko
 <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, Nicholas Piggin
 <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>, Ryan Roberts
 <ryan.roberts@arm.com>, Suren Baghdasaryan <surenb@google.com>, Thomas
 Gleixner <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>, Will
 Deacon <will@kernel.org>, Yeoreum Yun <yeoreum.yun@arm.com>,
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org
Subject: Re: [PATCH v2 0/7] Nesting support for lazy MMU mode
Message-Id: <20250908191602.61160a7990b9ea418de758c7@linux-foundation.org>
In-Reply-To: <20250908073931.4159362-1-kevin.brodsky@arm.com>
References: <20250908073931.4159362-1-kevin.brodsky@arm.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 56334140007
X-Stat-Signature: 5pnt14rde1zc1z6o3chkckzn6k9isfp5
X-Rspam-User: 
X-HE-Tag: 1757384165-210357
X-HE-Meta: U2FsdGVkX1+j8qNlgDJWap7hw1ALJ1QKFvO3XsD6go3tyJVZmiaN2YY7UWdAGyw63LVW8PMCkhY7oLPo3vNfBF/Sar7+y9Wy/DyTttLZVgqOjhIRu6rKdau60eZHjIwfvuk2wmcbPHLBfzjR18+j7fmUYBWC8J5aQqEXU71e/LHT4sANdb+EFlvdgebZTsIr/bnQMzMukqc5oZn4yrVDDMf1WPhkvoybTWHs+JUYK33gLl6xGcGW0mp7QHQAJyrUXSvjqeUn2dvtNdZdBRY97/e1oFKwvWCO704k3tWlLFGHemFtwKg7yhHKeeDisiouhoCd/s+lhaoL0DdE6Q2r4WBxnhc0kteDneQzj9mNC64DzBD1uTfGN4bdJMo43tV33+g7zFnsgWY0YRFcsm53wo0Zwm3v1dAsUEU7RTEgrP5cDa3BNv/w3plhWKzG6u4y1BVfsL2MfvJnOwSx71gRcb87c+q9xYZvp9J4VDb4PxXCDiRHMKFDh9f8NmwhCpCijX5L+2iac2qpUnFkft7lekB4miXeS6wb9OHVTtMAXGq7GMdmAmeCe6B1b1nAcTPsCGoPF4ZohzpL5dAndm/Oq/TRuzjRI3YxS54UXI3yv7xXJ4NUpTuYhHX7vIcOsgD0gZfVIkzk1RwWUacJR4yBTJdcZLya5VUxM6yqUqWa0QH+uVXH6fMLPmT5Rq9VFTWtHz1r1IaZ4KFHsHNQepX4NcJEavDHC7HF3yrvO3e91VJEo61RsmDBpj8a0wxUQt2lBQgs0rY4ah0O9iZJlj/VC1iQkOTV0CjInY8ZAbD5O08eqPgOvAiLAp0nO56t+Rm+flHP19ecDrGxK3tXEFAA/fcD4qrLFMgweVTRVg9PpDaotfNLPg3KUbhXUekiyH6Vws/Yrs6MUWJBtZIF+cAavKkSB7kQ+nmOQsDYnp3HuKtdf1EhSMcWE0g0i4UD1soRkiZh+3NIn71Jwas93Q2
 FsdaaW5Y
 7woWSKP4McYViKdfMY6uL6ToOm3FUY7GnB06IjhcbKaDX/tHvZ6glmxIzJDVesR6Yo6Isu4lXgYi0uyBq+flBsoq4wbAUNwpm/Dn35DJIMdS2Zqmqwh5vwLs2QpDgz3IG8aOyaGyEOPfRnSkN5w+WDio6E0dnFpqL98DiB1KKdKNsNupL53raSpo0Nxq/AFZhCgxS5WiJSdO5nPHBuI04yIfTrwIc1fhlB6cObHelLPF0uOXkPUhr7E/yME2hdpKDtgC/PkR5584Xp13EpRB9CsgB8y4+N6lruUvRfz55sv+2aaFOzHNncZTmUw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  8 Sep 2025 08:39:24 +0100 Kevin Brodsky <kevin.brodsky@arm.com> wrote:

> The main change enabling nesting is patch 2, following the approach
> suggested by Catalin Marinas [4]: have enter() return some state and
> the matching leave() take that state. 

This is so totally the correct way.  Thanks.

