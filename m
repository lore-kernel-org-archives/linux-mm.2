Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9ABE0C44501
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 09:45:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD0976B0005; Wed, 21 Jan 2026 04:45:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7E0F6B0088; Wed, 21 Jan 2026 04:45:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5FF36B0089; Wed, 21 Jan 2026 04:45:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A44B16B0005
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 04:45:27 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5686014098C
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 09:45:27 +0000 (UTC)
X-FDA: 84355488294.07.7EC26A4
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf08.hostedemail.com (Postfix) with ESMTP id A9F91160008
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 09:45:25 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=4dqUQgto;
	spf=pass (imf08.hostedemail.com: domain of 3M6BwaQgKCIgvmowymzns00sxq.o0yxuz69-yyw7mow.03s@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3M6BwaQgKCIgvmowymzns00sxq.o0yxuz69-yyw7mow.03s@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768988725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gghs4HmZuAZUYe8i+9UuXL2fYyVqn4MLWTMMYop8B0U=;
	b=ggfo+hV2NEoOwaXPgadN8gR0+kbWcNh64bB/sbOAjGQzs9DWbQlYUSzLeNcB8/fI+2bhWK
	XXPhWSbPxj6P/6mcPf0PARDQeA4voxw055u1OBnf3XMPjCohGMWQLPnyTNVfwDg8gPnJfw
	MvYbyUt3OYp7A7toVKKqIeIwG8htI4w=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=4dqUQgto;
	spf=pass (imf08.hostedemail.com: domain of 3M6BwaQgKCIgvmowymzns00sxq.o0yxuz69-yyw7mow.03s@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3M6BwaQgKCIgvmowymzns00sxq.o0yxuz69-yyw7mow.03s@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768988725; a=rsa-sha256;
	cv=none;
	b=f9NrE/impDR6gtvVSt4WPJyrxlXgKAfOfcFhUn2bj4y/rw0YVsTZP6APo36y6zPD/5t/U4
	XPKYNXJAJaWcLbKLsJwSO4yaBj6+Q0Cx4kbzJxYP1SWTqBnPeqYOzi8e0ip0SXUQCSkUif
	2IujERzUexo875xQZZ4WmnFyJkbQRIw=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4803b4e3b9eso21462995e9.3
        for <linux-mm@kvack.org>; Wed, 21 Jan 2026 01:45:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768988724; x=1769593524; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Gghs4HmZuAZUYe8i+9UuXL2fYyVqn4MLWTMMYop8B0U=;
        b=4dqUQgtorD5ODsShgpZMOAiqkni7wRSyrUTE4UvV7n8emK25zb0xV2BED5NfHd1YMx
         TJ6YciiZBqSVV8eSNrjYCvz1GjjfVMHKWywZNK2DDZ/Pqok5VOAxqeN3kWXJiMko2Noo
         v17E12hW7YvmqvYMYRvlzQ6BkR5PZptlQH4ttQgW7CAetRP6ZevWIf/Et2gMs2Y36rCJ
         rRF5w1p2MCGfzGqr1RtNddS7P6gU/jSonO1mDfy3IEHkbUxkFyMxnMqcrvhBf/P5SRHs
         DKcJWLdP1/pj3hv5DR+j6xHyrX6/RXuv+AwdpMsHMWK4ts9RtRipFfHd7vAiU1eGeZTq
         9WbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768988724; x=1769593524;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Gghs4HmZuAZUYe8i+9UuXL2fYyVqn4MLWTMMYop8B0U=;
        b=v2MN3ETBL4bnPMUdTsaUK1QyfNbS7fFUK6/J477IiykeXjo+UX7vWw7CYQk4YCovrd
         KEdlpuf+scykiccERv4zhG/nLnyFkPlUfcXDyb5WjGrb9pusi/s2mLsGKQ9eJw32b5Xn
         9YBOzd+ezAi6RVmMV0k52DLFDO8cjv7TaneTvUl0gltocNyeq48kj+dWNcCYnCd3vwH1
         6OYfHhSS8HUIoenMzFTo7QPUUwJJzHjTGoZKYfBNbacs4pP7EGt5Qur/ozxczOyjBAF2
         djjcNKA516gN2g2y3ofvqsy3MarfhVTt632HMJ4VdEa6y0qcT/WgAxrZ7SHTKLPYbQNt
         t0cg==
X-Forwarded-Encrypted: i=1; AJvYcCWvpCptvN79ZGx5kEMQPEMBfSugwEhNvbPtG7ocVXqPiorY2jlziHdaq2jm3+WDfnO5pmpIauKF6w==@kvack.org
X-Gm-Message-State: AOJu0YxQCbnQhv3CrLoIKmqHkV1F9omw7Iq1gUtlX9MipvYZxXTF0umE
	jvKr5gXkkeiut51lM7Bo42MSgeSuxKn9WZImgU5NPe6ncnV4kXbMdcU1jAQQzqhdR8Axq+KguV9
	r5UdkCvlRlGCWJQ==
X-Received: from wmpq42.prod.google.com ([2002:a05:600c:332a:b0:480:43b6:1171])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4e92:b0:475:de14:db1e with SMTP id 5b1f17b1804b1-4801eb0426fmr243434915e9.24.1768988723921;
 Wed, 21 Jan 2026 01:45:23 -0800 (PST)
Date: Wed, 21 Jan 2026 09:45:22 +0000
In-Reply-To: <20260120163728.GDaW-vSLGY1P_E0DqS@fat_crate.local>
Mime-Version: 1.0
References: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
 <20250924-b4-asi-page-alloc-v1-5-2d861768041f@google.com> <08338619-6aa1-4905-bdf8-bf1a90857307@intel.com>
 <DD7WQ97R8OG6.1CA5E2FU5ISMZ@google.com> <19e5012a-3c58-4696-9e4e-39e2b7d2b5af@intel.com>
 <DD80374YZEWM.1L31D2VUKK80C@google.com> <20260120163728.GDaW-vSLGY1P_E0DqS@fat_crate.local>
X-Mailer: aerc 0.21.0
Message-ID: <DFU660CYC3H5.3L7IVBXG8AIY1@google.com>
Subject: Re: [PATCH 05/21] x86/mm/pat: mirror direct map changes to ASI
From: Brendan Jackman <jackmanb@google.com>
To: Borislav Petkov <bp@alien8.de>, Brendan Jackman <jackmanb@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>, Andy Lutomirski <luto@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, <peterz@infradead.org>, 
	<dave.hansen@linux.intel.com>, <mingo@redhat.com>, <tglx@linutronix.de>, 
	<akpm@linux-foundation.org>, <david@redhat.com>, <derkling@google.com>, 
	<junaids@google.com>, <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	<reijiw@google.com>, <rientjes@google.com>, <rppt@kernel.org>, 
	<vbabka@suse.cz>, <x86@kernel.org>, Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A9F91160008
X-Stat-Signature: zy7usda1kp4cfdf86fzpfx1k5kxngiw9
X-Rspam-User: 
X-HE-Tag: 1768988725-225616
X-HE-Meta: U2FsdGVkX1/gMCKXCW7S31dRlci58OoyCvL4m5lDS8G/BNrrDbmTRIqsIRdiaOy7N77EShPV6senKULucFM8tQaHe+5n+7rhC5y2ox/8YZuPxVTduDPiSSSi5JJF23l8lDaoaD+9JDbbm11vqRtllhdDsaPcdpMrNm+PsbVF6H0ZoMOd1fBxyLL8W2V1npGSbBtjr+3jND7JloSf/YSQcXW2EZsdRTVXpHLLLuGsqtws5p373p90jZgv4m1el9D/6cYPisbsIIeykUW5XjBcB3XKiI5TIwCRuD4/IBwDHnf+usQ2b3lxEcwHTdHRPqeXKik+JEsejr42EtyjKw4TSCp4QCURmnxB2Gv07TAXyCzsXoRTswT9J1JXWqic+rL2WhSqqvZr9r5atra/5ed2tLYfa85GJESui7r1ULygE7CSDNc9P1Bz/RYFVNcdySsVdyXyBkAzC0GbYkBE1mW2nmSsK/xFcQJO5sjCiAEA8YzCZ8zxS86fhdvSIC0bqXD+0zAFE8BhvcGOE9APp+JVee9+YkcFI2iC5jSCzepMTxq2fyXvFPa2hN1fHROz7mBKpApBw8PJ8jKcHjbv32VVJAuafEv7s7CmF5v2dFRWYCuU0HLn3nszWiigYdZpdYrJAQ41NXTmRoHzlrSRA+LoIPjk6MVukK5vc1vaBVyLdniM/aPBoSH9XCKai2RQIMZ34pm2j9p6DpJpW1pY9jnWGnHmeKDOjwM1P4EfiRTHT94dgqqoL0zsWQ/WttgxcJ1XnXZ04lGU17aTXHD7HjHrbRfCr8wpJpGJyMYkkC39Lt6Az456OH6sYpfW6eY3/HRcwAeISzD1qp9EJnF47PjfgXBGFhjUsFDA6rf/ZON6L8U4ZIf8+aKs9wMafnsLO5O+8yJyQibftNqmjpD8x2fvTwEgJk6FrrbVPbVt/eJyTBtOxe4nZIy3921GwtNxyE6Zeplw72Ak4Wo/oK63Oga
 s/rf0mgD
 VCeHlu1DEKyUX4xb2f/LmS1L+cf/JXH1Wbpf1gROiWhSBX5u2kZx0il4hdKZ6FkwfBeoXPRwAy5sM2sUByqgec7ulpTyoL8zWaET++dT9rvgsMRlFcR5DvM7cxtFHh5Dwcvw6087XEtHk1p74bKgrsr/o1nm64v/R/uitkiOkCOmYr5b8DiFipGh7AMnDSvLL/fIlDLNBtpBXOPU5zafUHDNTFVwpdoO/IGuEvMpJhxAKwTpKY5EkvSuBS7XvaODlKE7fpXqxKObgZ35TczyRdM2tfQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Jan 20, 2026 at 4:37 PM UTC, Borislav Petkov wrote:
> On Thu, Oct 02, 2025 at 05:08:59PM +0000, Brendan Jackman wrote:
>> OK, then it probably just sounds wrong to me because I'm steeped in the
>> current jargon. For v2 I'll try just dropping "[un]restricted".
>
> So AFAIU, we have two address spaces - the full one - which has *everything*
> mapped in and the limited one, with things removed from it. Right?
>
> So calling the unrestricted "the full address space" makes sense to me. I.e.,
> it has *everything* in it.
>
> And then there's the subset of the full address space which has holes in it.
> Looking at Merriam Webster, it suggests those antonyms to "complete":
>
> partial, incomplete, reduced, abbreviated, diminished.
>
> Yahaa, they all make sense.
>
> "partial address space" sounds good to me. "Reduced" even better. So having
> the full and the reduced address space would make the nomenclature very easy,
> IMO. 
>
> Thoughts?

Full/partial sounds like good naming for the address spaces, but that
doesn't help with the issue that we have two related concepts that we
need jargon for:

1. Address spaces (current patch's terminology: restricted/unrestricted)

2. The property of some memory being mapped or unmapped in the
   "restricted"/"partial"/"sensitive" address space (current patch's
   terminology: sensitive/nonsensitive).

IIUC Dave's complaint wasn't that the word choices don't work for their
respective concepts. His issue was that we have separte jargon for 1 and
2 even though they are closely entangled concepts. Since I'm now
convinced that "sensitive/nonsensitive" makes sense for both, I think we
should stick to that.

