Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29CB8606A320
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 18:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0A9I5PP4
Received: by kanga.kvack.org (Postfix)
	id 32DD16B05C1; Sun, 22 Nov 2026 13:03:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DEDF6B05C2; Sun, 22 Nov 2026 13:03:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CDCF6B05C3; Sun, 22 Nov 2026 13:03:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EBD206B05C1
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 13:03:39 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 29FE6140729
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 18:03:39 +0000 (UTC)
X-FDA: 85463527758.21.CF8B6C4
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4347012000E
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 18:03:37 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=0A9I5PP4;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795370617;
	b=A9lLb5PDTv1W/8bW6diLo0pfdzSua4fhMRGG2fcwdOx7aRBe1wO79oBSBWNV/P/H6CMZ4R
	9vsGbSvL+Bl/EKnvZ6vdhp53tBydHd5y3Tv6ucn7Vr7BHzWBT/6X3JktZ1cLRrGzQewYI3
	ZJxHLF7a4DSHCWLAdsfAkWw0/zr56d8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795370617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M0QRN+WI/2+N3ORC3EQqEz3+dHsIUQPpKZYtHfKeUv4=;
	b=p3+WrIPgSszlDcYL9/z3OVp8NQ//XG0p6xeSgL3rABty7bttsWA04Aq/Ero7NnFkUBpv53
	RAs/3VqMgMIllphlw9XOhlAaGPgL96GpM56y0YKOOp+cTV+P83QU/wSILRliRyzb3yoq/k
	z9N/kmUVY+Z8nB/7HdBIzSP5fLPnbw0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=0A9I5PP4;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=azpijr@gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4a9a8d6cea8so30791875e9.1
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 10:03:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795370616; x=1795975416; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=M0QRN+WI/2+N3ORC3EQqEz3+dHsIUQPpKZYtHfKeUv4=;
        b=0A9I5PP4N4vj1PDanXZjOtRVRn8jF/qYQjSqIE2mS/t1/L4cJEBJJpQC30Rk+NaBOi
         TQI5Q2M24tlgwwJGMxGP5UzMQr1O1fS/nTjsv3EtuWkv4k7MIQq4/VbkTHxkr1oenQ/f
         z9+EjJVKyRF0HcEm0BgQuUpq9MDBX65pmEjcYBbFo987Laa9+ZeK0WkKE1I3v9ISmJXM
         V+Gg/70o3Av1abgrKteTX0uLRLGpindS5mfC9X37uKkwvcCmhUjSy9Dw6iM73qVqqZn+
         c04Ii9fxCmQLj4P4/I5QqGGzCsxYo0YdEY72DIznTfu8xZTJFUVyhomVjHK+PrArdmPV
         E7hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795370616; x=1795975416;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=M0QRN+WI/2+N3ORC3EQqEz3+dHsIUQPpKZYtHfKeUv4=;
        b=FM2WHMXhjhxWh/aflP2mbRIp8URJvUkxnhizmRagohooifFZ6BdaEvXLpKm/YGEjgs
         1jI9IndMP0A/Rndp/ZPAaX8R+A/PGjv6IVrOyhJtTSFzbNKsP1b+0RISIViqYDJA5Wxw
         X8NKxwq742zCu+upsfLtjlk3JnZV88ewzDhp89S1inWWv61MHuM5QaHDePm3hVs1OUiT
         kmrk0Joe26Om78rrj/uJLqZv5DRQ0xIkiefwXL/toHn6pEX7uvIssp0UIG6h30PHv1vI
         0Gt6HK1J4PNwkuZqnnXHjgsEsB6qUdaTb6ttM+VYmAZk4DXO08bwnqz0YeviZyHN6vAE
         LwWg==
X-Gm-Message-State: APuU4Z/RGUWG2e4YK7WvZ5guo90yhbbUXmSFbM3p4XshdjlkA83PRxnN
	ltuZEcAEbH7Rn5W8BTTk0iu2nhs+rxf43qaVosoEqiq+wbfyqfl2NvP5
X-Gm-Gg: AZFdTZcx/lngkV74EdK/YTW9Zd/vhOJetbSlj8xqn38EeHDwm3gl+gUVyI78fqhjmeX
	TCjum1kJYI/4NjroHRosyRu9kRX2je0DYxmb76V69qLunVp2QqesmZEUOU2RVNm25qj4YyYkVyb
	ivj+XtMfe/bst3RdqWvePlCMdmh2jz8pssvK5FfUu+8yKik56omRfkwm5hX7AHfU0oi+MEi8s40
	4Tbt5cklJJawxk+zLdMbafk/btq1IJad4OvK8RRVQBAj6EdFO7CP/dgvErIMFoT+d/gD0/ZhM0c
	zSeOcJYk/0cQ7YqXpKaYO5JInqmqG10VzQcLGdCMj/4D62kQx5OUPaK9y+F7xzirZRhqf2g49Lz
	MzAogKBVXwJy+H/qch/LL5mZKTzeE5SkFoq8FWSa2Jv9G2Nf07Rgz3L0AZFcegbynHhcrLkJuIs
	mw0/lxH5U/x7fUH53xYGlQn8aPFXggPLD6WhqCuUN6t8FcRvQdvujRl2+7LoS0oN7rnpr7NtY5z
	NIqXT3jEqx1Sn8m4m1QbUiViNb3CA8/kN6HmwzwtysLzknjYVMzSgwxz4h5nv2zM1VoMTOvZ2xF
	8EC4xTxa/JMltWl/JS9uOcZV
X-Received: by 2002:a05:600c:154c:b0:4bb:6a78:7c42 with SMTP id 5b1f17b1804b1-4bb887c3428mr203152325e9.1.1795370615902;
        Sun, 22 Nov 2026 10:03:35 -0800 (PST)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb90660cb4sm194315535e9.2.2026.11.22.10.03.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Nov 2026 10:03:35 -0800 (PST)
Message-ID: <43a1524c-a0d7-48e4-8bfb-3912b97fd197@gmail.com>
Date: Sun, 22 Nov 2026 19:03:33 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/7] mm/mremap: respect guard gaps on in-place expansion
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, Pedro Falcato <pfalcato@suse.de>,
 David Hildenbrand <david@kernel.org>, Jann Horn <jannh@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Kees Cook
 <kees@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
 Ollie Wild <aaw@google.com>, Adrian Bunk <bunk@stusta.de>,
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>,
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Hugh Dickins <hughd@google.com>, Joey Gouly <joey.gouly@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-mm@kvack.org, Chris Mason <mason@kernel.org>,
 Josef Bacik <josef@toxicpanda.com>
References: <20261121-some-more-ai-fixes-v1-0-236e925d9b64@kernel.org>
 <20261121-some-more-ai-fixes-v1-6-236e925d9b64@kernel.org>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <20261121-some-more-ai-fixes-v1-6-236e925d9b64@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4347012000E
X-Rspam-User:
X-Stat-Signature: r4i99yxywaaqwqfg5oopaqepdk9nbj1o
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795370617-385844
X-HE-Meta: U2FsdGVkX1+/0C1KcCkCeuv1GmzRb93Vi9lVccYmKRPzttCCb73owmIIbm128uyt1MChVyK3jDKZtDG/Pu9pQWUXSuLMDvB2uxnx8DfOcHWeEpmfwYcypQ2/BlWmb6uj0BANZop+CTsmyemLwuEirDRetX1EhU6dB8Pf5cg7oC/Tu/0k1p0yOyObFMlFslOYfeLdM2YfeN+KgR4CG5gn/Zn+daojS5NRHkkeZdpSUdrWtkoK/aqFndG2bKrt+seVPSm816HjzBN2G2skbM/QSkwdR2pyz/9ZL7dyRziOx/l1b1KcZZxuikEmLYWYpZMWeAqjQGlULfAUwoEyK2P6z9QEQ8+uicDO5T62kdpqyhpO+8HmO8G7+jB7thUoDjYEsmcyRo0qq8qAMOHobGk4QYAbjBE8d14HKB/ZqVBZset1Hpcfi30NTMWTjbn+3O86rvWo2NihnXW9DtpZtdSqUcE+aNIgiY2gc33ODSxoLtsB6HdyaiBX/DtRKKSLb0aDhEqFXORe2dauUvtGADGu6OiZRKogJcG8RxK3ie71z6r4fdRAoH7x5d1mwLjP9J5+fQuBJJaxGoW+V8BORWNlWRrcPh52cIMopGlcJNTY214y9ZkOt/DtC0z90Vtytj2SrRZw6E4e5yqvVecPsVsgB7wG0gRndxKAxQ3CR16p5WdoSEdo/Mpy/EqE+pzvwVDVX9oa3vawg6O0oyxMnCObo+jOIUJGQXNWTZDvPFYLUkRB/sVycLtI7eVhDxUUYmFOd2sfItsz8bMMrl9wAJOMyeF2GsjIxy/DqN6efmvuIa6Y1wVR0dphDZAH5sEEeppqU/7JPmFSloUxSq/SZdW1kTY0+/diseZP41q8Dx85JtpyYUq39z+rdBPFWv0DiwOCo35q7yyQVusDHAKYzkwRBWwkJuKDIjzk9vAq1beEcIyYcA3sW20vyMo67w63EkfMphcgEhBgcGSWWuT6PvV
 B+NOLxk8
 e+WPbPXsjBepXwai+L6YGmZGyOEwj8fh2A5q2sZRdyat6hFD77vvRHg1kLg9O40nzHgRktV4UXbQaEXDb+3vl363s0o8T3sC0Br7gZjtRRlbMkfq6IRMrZIlX1LWmFhIRoPlX+e6Qc33pCqPpxQm5GZdz5Q9t+ChjtVVaX38bBIEwKB8YfNt8aJSkOEufeVC6QsJm8ziSRcS+QS5qvkzybfs9+v2W6v7ymZgEQJbHRNDXWhIxCchUiMFUl7EWDk+MwIbTMuLKj9wE09ieaM/lzKVPQzvRgPHqVVoaHOtWbv3gc37p0GbrlLm4L9XyL+JTAsV/83Aa/QGYztO0ZpLiadXiL7ZulpkkSAIwXi0Ps7ohkRRhEZfYGcoBG4Z2+74Y0ZMTtlJYDPPHW0gf685XfrxmPt8hY+Zp1Nax2OIMEGEqC+k7kLslhbigLYLX4u/L7JSXQffF4xKx9xnySbuH6xKgwQCAJi+mcZpI10MZAHNSt7TJqJof/ZJU7UYi82pG5de5veb191H6GzFwWsmdWvOr5CIJDzBGOIKNFhsRKc5MZNkivio2bwa+oWFyH2AgR1E7nkXgGHyqq2ekK8gUJ6BAMOyXPIz/Jy1PZxFbXD2zWg/zkTTCbSjpxCvku5eM8NtcdYSc4sEjGYqO8Wk0Ao2gbXkG18xzp7SLAhr4asNQWb73lhBYm9esWCZcKGohm6R1QbNx1hVZ+S0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/21/26 5:02 PM, Lorenzo Stoakes (ARM) wrote:
> From: Chris Mason <mason@kernel.org>
> 
> Growing a mapping in place can let it use up the guard gap below a
> stack, so that the stack can't grow any further, or overflows into the
> mapping instead of faulting.
> 
> A mapping has to stay out of the gap of the next VMA unless the caller
> fixed its address. But vma_expandable() only checks that the new range
> doesn't intersect the next VMA, and it passes MAP_FIXED to
> get_unmapped_area(), which skips the gap check there.
> 
> Fix the issue by stopping in-place growth at the start of the gap.
> 
> Growing a mapping into or within the gap of a stack or shadow stack now
> fails with ENOMEM without MREMAP_MAYMOVE, or if the mapping can't be
> moved.
> 
> Fixes: 1be7107fbe18 ("mm: larger stack guard gap, between vmas")
> Signed-off-by: Chris Mason <mason@kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

LGTM:

Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

-- 
cheers,
jose a. p-a

