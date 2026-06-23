Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57752CD98F0
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 05:37:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 174296B008A; Tue, 23 Jun 2026 01:37:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1257B6B008C; Tue, 23 Jun 2026 01:37:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F31AE6B0092; Tue, 23 Jun 2026 01:37:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CA4726B008A
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 01:37:55 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4D67E165E5F
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 05:37:55 +0000 (UTC)
X-FDA: 84910070910.13.1599CDF
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4B05A140006
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 05:37:53 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jmJANQl6;
	spf=pass (imf09.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.49 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782193073;
	b=ob1rSrJrygRlm7WBAo/PfPRGj5EuRCQ/U2XNDR3OIlrUM2TnrIOaZcCphqYuZqXCXMCZXS
	6x/Mbrlkc+VOYlmv+HTDgo7vgyAWyznUFc0cJiQK4wYml595EDSKgyQrc/LKkRiHOBxld7
	ATONvgNe6H4WcXnlcVnPCgWo7sGizbo=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782193073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ywNBea8BQuxu74yc5i61r82RhKSf7Jc1vvLhpM75f3E=;
	b=Bs4lSmUr3kx93n8uaZPVCkavRhjQaac+My75e64zOwQ4YbfTQTEJPTwGPfE0xDIqwMClx3
	wLxHwfLDUAM9Q6fVjJ5UONF1nP2b3PS4HL1Wz6jmWwLwG0FZFTT/WPC8L6EpkCP68xaUL0
	0OtlvzKw8qLjqFbeQP+z4UIyJROzkOo=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jmJANQl6;
	spf=pass (imf09.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.49 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-8e066990fb4so33795776d6.0
        for <linux-mm@kvack.org>; Mon, 22 Jun 2026 22:37:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782193072; cv=none;
        d=google.com; s=arc-20240605;
        b=jCnaoJaOjCz8PzIHn68sB2uzzj4s/Leox+MjGo+LDXLQk1pXplhbIVkJlkCshTd3R/
         51mBXj3cNYV5meJgvlvupgQbk/RfYYc5Oo5WwwBi+ED2DUG/UOsLBdSz7v3v4R051ntA
         YQEwlVEYFkV3Ab/CnOvx1kIkIkk/imi6AytYJYFKNV0Eli/E1rjpVdYtQavND7GdjiUk
         +CMzX0BfjMCN4X5eWmsOPsUkXGm/zitaxzlumi+FbZyg1fabm11VMivvX6IUm11s6Eog
         WjRNHCTqfdv/v0SDYsfjy3NXEtFtjlLwsIKdmjTKWEdfGrlTfHeCasw9M7SKEMvdbSvL
         72jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ywNBea8BQuxu74yc5i61r82RhKSf7Jc1vvLhpM75f3E=;
        fh=Rr1RS6JFMxbvPwE4Z+ff0M1o2bNTHXoj8dcBEbBwEI0=;
        b=heaLGJYpllU55On/1ozvVFSA0hxVp9pRSzcb/uke+ayYPPlvaoYIf6K3NS+v8mLmVF
         eGDBkqSDUUortWARjis6SVeLPrJ9F7mv3ciUpOeIgu285s7LO7bThTi9G4UlO18JGCSh
         rA7JJdi/vbuINugXjhts7mH2kwA8E/4/E8mpJTe3JVjI0JPtzjQeoNiPnZlpBy35/x/y
         pA6rBp+KpPWL4SO/j3rXP6Yz0GjjnmnNKMsU9Hc8B1hWnxQvLqoI4m8vpdmFzJE6Uipt
         huZjj5t04S8luq8GmZxO/51wHFGBoIQ15hMXu5tVM+yBy2K1DtTBza32ZlO78C5Vrhsl
         /2Xw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782193072; x=1782797872; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ywNBea8BQuxu74yc5i61r82RhKSf7Jc1vvLhpM75f3E=;
        b=jmJANQl6uZ67QxIzDZp+KxYI6To3NSKF4RKa8EJ4PNFVmZ0xZtHPlHemmoY+6iKySD
         WXjT2kEq8Anr/XKbUnrMV3YZ3XOqZF2pEs5+7c4v5FINhpKd3gQVyVZ0wSSeKVoWr98z
         G8H4TmHiedG+xKEF7h7Z5Y8nB/lYipxkrdVl+ekkbYjxVn5Kz+LGUST9JaRTW67f8bm2
         E6cFqCsIB0uq8gkqHePgvONPPsIZsh55L4lHPMtyADa/KahWmQs9RzWaQjnqxU3uk02X
         engrYC2f0IB2gQfwqPI7CBLXuUcwFdvGS4rYhJG8luvW/USGZUFf9GLIFYpB+iB3FHkS
         O/xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782193072; x=1782797872;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ywNBea8BQuxu74yc5i61r82RhKSf7Jc1vvLhpM75f3E=;
        b=d+fTQMcdpvJhb6PYbdrkkrQ7C9KqLvkaMizCs6lfDF1Ye9Pq5gCY3a2S/zZDjLc5RQ
         fFXY3BzEfO83dJsiRPZ1S//ie8l2TzABCUVNM+qyojoZuDRmZHMjTjWYG8aAcghSNKBa
         w4XVyF+Y4bIUruahBs7YHw7fjv09aLdeYf9JJW5CiTxkq5FxmJQS7Fk0ErvKLlzS4Qo2
         Hck14z3dl4MDWgFCnZRyDEg6B2Yf4lduIATx1rZnDzhx2c0LaUEDVsl9AmZPUliHk+in
         YQwPNiisR7XGyejYJM3+VIEDp5ZXbtHk5niuc5xJ7yKAKL5BJW50tV3DvF7pfRYxd9HB
         AvWg==
X-Forwarded-Encrypted: i=1; AHgh+RrsEMbwzwBb48yPtjFGX+0nz+A089UbS+d5f5fpPP+Mxn8CeoQaYH3DCxnixFP9dZtYGPy/awjHTQ==@kvack.org
X-Gm-Message-State: AOJu0YxViXWhbeCrkqnOVbXus0sogoLhRjdqtArp+gBwuXd5J7Muvqra
	dwg8AUgAYcdkdBqLtwHoNNShewdbXHvz5ei7LaroE2kxYLDzLQ8aThUU1aHzJe9KjbK+JiojQrY
	PlqTvQOqJKkq0tRD9kGDqQV3Wk1FK5/0=
X-Gm-Gg: AfdE7ckzEvX0QydHlQL6e0Lyk+pSHk+j5LZWOFzCEOU5YQgD9D7235rKxEA/zRD7Yej
	WGDv9o/k7B7pnAS6VcIG6sxDxZfiqAcFu2FWPPRYNTNZCmh95kopneMPkswKT+OCiT6zAf37Koe
	bFGO9byzXRtv9ZZR7j7SUW6yd0K1etZ2FJSWZQP1JdJHD01bwUbFySUPPZj+CZR3ZpfbxzxUcTb
	tQ2rC57SxttbAmmi5nV1RT39sRdn/Y3fIsvrDHpQWGYRS7A55o7x2jAdadYJUWtWAslVD0E2P31
	2LlQvXdKG5D55BUH/uk82c2nWIo=
X-Received: by 2002:a05:6214:21c8:b0:8dc:1f0:9f2f with SMTP id
 6a1803df08f44-8e4011f2c8fmr28063596d6.17.1782193072066; Mon, 22 Jun 2026
 22:37:52 -0700 (PDT)
MIME-Version: 1.0
References: <20260622155913.280355-1-ljs@kernel.org>
In-Reply-To: <20260622155913.280355-1-ljs@kernel.org>
From: Barry Song <21cnbao@gmail.com>
Date: Tue, 23 Jun 2026 13:37:40 +0800
X-Gm-Features: AVVi8CcgF9eHqRaft5f0EHrabGR8pXO99BpZ8N2vR9VSb1RjXbuDaE4N-8Ux-ug
Message-ID: <CAGsJ_4xvukFpJdT6V335pgS70SrmmbAJ6H81rVpKXaLdPMizkA@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: Add Lance as an rmap reviewer
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Lance Yang <lance.yang@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>, 
	"Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
	Jann Horn <jannh@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4B05A140006
X-Stat-Signature: s7h9f5kwftzr3m1okjoxdfiffbmat438
X-HE-Tag: 1782193073-2603
X-HE-Meta: U2FsdGVkX18jJ4wkZJJ22oAx4tc9Ug1ssRJkBQBI0GinvdmOffSCfOxYU684Fm8LSDgDT73RqN0UzJCGZvf6kxPPejclO0WoG7/zkt/TrhOJEBXQ/rCyikocCdYZceNCaBIY4u/bRDN1Q5ERCez4IKrcBhoAFoofc7T8MbeVNoPy6T55qzhjrpIHlQJO/2ibbX742sMVMsGZdLAyFm37r6l5zEYi5mAu3gh7xGEhbrJD/io5kc4UJgtb+9EFnts8tj9dKQ6e/twFxwB9laVG4+iRlUO4fiaJ4LfZGF+KRjpKWMsPMEx/NCzsLBq8oI1RiWOpqkRWXE1IV/E/QpwhaJJT0SXfWJQmvI9PrKMAColGLc9q5D4VSaA1RurXaoG3ZQT03SkxUB1RmT/lFYqUK4t/e12TykOfWwYeaJVhcTQeYm3NhzDtG/Ba3CSkuas/GIhz6DywNQRV3zN+9vrlQRJK8u87ZEmf1ZOH4aYiuuo4TPyaMYsAGVrewseZFKEdMXNObOmibX9EdoZzkUGaMV8LR6R7aNUvlh0hf4VMEDij9+I27MUugnhA7spP22Uu6htIj5BRzYMzfY/ftr9i25W4eN1fzEsi+edvIjaGBaXUtw0ZuVSKOhcRZGXkglQ+KCz1LGuQ/iDB0hyTwzlAnlLk9X7tD81uB5G+0/CXUS3EKzwxCPEMu19YBA/0Jm9BlsbPPeipel3bNR0QdGP8zufMK9D/VrkYhnQuMHdC1thxZ7D5KxRPcGxhQMIGzhNlL8NN0gztiCJ/sbKnmwv0JhGGqYnjsOJ9kMBUqAwcDvzRuGuji0xPhY7y7WjxQCR4bqmYYV2jWzHS0eGHqilBVYYlQc4ClfQA4CqJgcNKczbSko2RlB9hmvjfWsiUOlmWZWmm+iiAD2tbm1lkrD6p4wWEkRro+8Z/UC0SNEdY1hKo/L1hCu0DwJoeXwjoD9vix7ZWvgBF6h2BRdAOnY6
 5G7W3Kyy
 0wvjfCmGNsqH9RZ04VMrRXqYSz+8EdOm7YMRki06ZG4dct6yei4BQTh9mlyN96DV2IGxAirLNS1pHgbr/NZWqtrpWBoqVFUahq13vHs/eZdm0NQbjSa3AeuGsiazuGuj6AwxvG1n/FUSUG+Z+LKdolPqnbwO2ilOYkC1xzHvfr+m29YwjQniR+gOcI4JwwvcYl/J0O3CwzkYDJVyMY0QZVJOmWWrryt+EAMne0KFtOpP/g2wg7Hz8Q7AHdJaMbBtmCe+qJlDHQXpKmdeI3RZte2UnbbtFpLn4zvuiAnfAsIRpKPOP1FcvJEAOiz396N0F00Y6nC9HAWAYLcEF3xVXYLAWD71j8sq2njJUIWR0lJEVfPwCfYGC+JPaR6Vfc1l2624rJa0eI0p4eHZ0EqMumHC733J9oS3A7DjUYWjXf8bfnPo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 23, 2026 at 12:01=E2=80=AFAM Lorenzo Stoakes <ljs@kernel.org> w=
rote:
>
> Lance has been doing excellent work reviewing rmap series and has proven
> himself to be a great member of the community in general, so add him as a=
n
> rmap reviewer.
>
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Acked-by: Barry Song <baohua@kernel.org>

Best Regards
Barry

