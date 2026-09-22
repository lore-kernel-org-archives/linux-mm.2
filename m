Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1484C982F1
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 09:15:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD6FA6B00A0; Tue, 22 Sep 2026 05:14:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAD4F6B00A1; Tue, 22 Sep 2026 05:14:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEADA6B00A4; Tue, 22 Sep 2026 05:14:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9F13B6B00A0
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 05:14:59 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 250958041A
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 09:14:59 +0000 (UTC)
X-FDA: 85240838718.14.2F7D9CA
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7CB8580007
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 09:14:57 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=eUPTj9eA;
	spf=pass (imf02.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790068497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FH7I6UR6jBDl/t2avlBDN/FfwVeJE6mNz3ibf6d5W4E=;
	b=Yw18PfbVI7FtrFMmEX7BEndQEmzLV4WqniPjrdjMgCOfJuOe4VF0C0nyF2/QIsbg5Lvivj
	t19Whfzs0KxDegl4CcxMhwSjfXzZn5ChZXmuFwq0ffWIcdecLzftuQqwM+yznwxp7Rqltb
	u9d1Q6VqTDdaFcrrQfv+4ZsNojEEowE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=eUPTj9eA;
	spf=pass (imf02.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790068497;
	b=Mm/9jR4h0kVaqXxKnnkoe6+9XpNJ7wx3R4+PbM3iChAvfGoelCPfhvU47Wd5DRTW3A/4vb
	cNJHeHEH2eLgRHeCS2LqFP4KZQwVZlBCgEL2BEeb9khzUmQf9y2op+tJyHxPG+WiQLoF4j
	Csne5GQ1wiDlCVQ+JfX4+KaVAa8NFTU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=FH7I6UR6jBDl/t2avlBDN/FfwVeJE6mNz3ibf6d5W4E=; b=eUPTj9eAaXcbs4q80PbAeG7F41
	9081MjBXTkIMWK+8zT65gf+PM19anFfCRJOI6aZDApSOMevfYWb7efc71TgWLRLz8Exj/Nz6e3oNX
	mp/w6EYIlF0u9JFuQE14R4PxwI4XFehfbZAkhGeX6EqqO11Jmi9aD8og1r8c2WBbO+aoH++ZsQDTq
	5MI3ibU0iCpKRWkSKqMVcUfHWhXxDKZrlmTSKxjS4cR2YGJ5D5lcnutLJShjnAq+FsJHp6txXpr3P
	VyHyIM4Le5aXVewo0dNiv1C6zkiqmZda9lDVm/dor3vG7NOQtXJd4UBmw/Yn3VZTs1fK3FRW1640T
	s6m1xKKg==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1x8wa5-002sKz-0P;
	Tue, 22 Sep 2026 09:14:29 +0000
Date: Tue, 22 Sep 2026 02:14:20 -0700
From: Breno Leitao <leitao@debian.org>
To: Miaohe Lin <linmiaohe@huawei.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, rmikey@meta.com, riel@surriel.com, harry@kernel.org, 
	linux-cxl@vger.kernel.org, driver-core@lists.linux.dev, kernel-team@meta.com, 
	Ard Biesheuvel <ardb@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, kas@kernel.org, 
	kexec@lists.infradead.org, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Oscar Salvador <osalvador@suse.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, hannes@cmpxchg.or, 
	shakeel.butt@linux.dev
Subject: Re: [PATCH v5 0/9] mm/memory-failure: keep hardware-poisoned pages
 out of the next kexec
Message-ID: <arJBkNOgbR8NrgFP@gmail.com>
References: <20260915-hwpoison-kho-v5-0-3bc7a57bd503@debian.org>
 <d6e35901-f74d-bf81-75d3-bac4b26d9d72@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d6e35901-f74d-bf81-75d3-bac4b26d9d72@huawei.com>
X-Debian-User: leitao
X-Rspam-User: 
X-Stat-Signature: znbfiox5k6fjmhuutzpeezi8babdo9k1
X-Rspamd-Queue-Id: 7CB8580007
X-Rspamd-Server: rspam07
X-HE-Tag: 1790068497-262964
X-HE-Meta: U2FsdGVkX1+LmrHSa8ocdbgyGzJRjWh4CzVR3SkeLavQgbbaBFrfoni7Hq9SeWDoATlQh2Euzu7/Zbn9qj6XZ/+jlMQlmqxRP1O+6HAyP65NAyL388p6Qg+TW+xpCdAwCgMkIG2eL53eAIMPj1WNJsXnVzrDQONxHAXb8NjMoGjtrFrCVIdlHcVczL0TSy8iJFueJjW2DO9hF8n0vH0dyyQfmT+JuCclZBejt2PxqAlN6GZcmvwQJtzCR9ArAkDn9x9rRiTc3weoIPNquh/3cqLlac3++ZRZU15g6c1aavrQT1hTNo4gAGJo7Ic/i7nFjKnNKYAtTk8mHMo5HXfdruj8KgwaB0t6RiE1bm8gGwbZfgCZwhEnkMC9GHc+Zv2oGe4YeGYsl1d0e4QzXAPO4uwSnZPFtf0NkrAIgukJSwm7CXJuwhSGNvKYN0iSDzVTUy3HL6poNFI45DLeVlVfEefQ45KMbgLeOPTuczIa+ABAshqjzHnhimcRWbivNb3nLQWO/gqJGLctXlCbOFo1He5aUTsTs5ylWxg2jt9kp9TaYlaCYizJHPguAgoFKN7oin9Q/SNh6O71jAfp9OVkxdopcS8SqWXokYxAQbO9X2JFhDVO45PkSK7ilOFxWtOqG6Cma2cO6qQSAvXBxojuHf344o0BIV+/Zc1GtTCAW7ca10GPZ3FnGdjl1qcK+NUkGDV8n+vy37pD/k0GEJCwNASbXHS4g3URnLMD+/y7BbEHUWTbhqNB+Hbe6aCzUR5ULAd2nbmW6U52R1sJX0nEcX3weBy9zUEFDNaTF4Ja5C39m3g7fhMETUL/aUjqUYbx36g3Zq4MOGuBB6bwCN+h8coOedD84m/eI3GcaYbgFvAWroPrgZu2Ymb/KNoTCF81661nSAjml+i/NNUMGZJ6aFOV2fzWstE984RXENmn0JQPo4bJln7yhkCcSkYx9Kzr3Jr84V9MxgdHu5fLuOJ
 IbwjV9Js
 tOfRi2c/+uNts+LcJ7hsL/6PSw+hdfPIGzbCclTtEZGSPseYCvUSURxgVMmBeD4o+CCW3bw4hUq5y0oufL4KG3lSMn5uk1YJ7AzHrh/TAMw8NytgIaZtQNuRv2nWK2cZjmW5bpw/nCiV2PaWJRrPTKCi/qtBCvaaNsqk/r4AjZgrHq4LqEQb3WKtHh8LnBYnpcyXsKtcY1yOB3NBp9u9ptc+3Ee5uwatRiZjl1KikSnp95JzUuHXta+duxO3dAkNzLKh+qkGW3IVEnAiSrguL+gp2/K1K3N44AOw8dWzeQGxmJEXF0ljjPJtGvNdOvJVmpAuqphHBNU6DkT8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Miaohe,

On Tue, Sep 22, 2026 at 02:27:59PM +0800, Miaohe Lin wrote:
> > A bit is never cleared, which is a known limitation: it stands for a
> > whole unit, so an unpoison of one frame cannot tell whether the unit as a
> > whole is good again.
> 
> Thanks for your patches. I have a question about unpoison: If a bit is never
> cleared, after we do some memory-failure+unpoison tests, kexec will lose the
> tested memory without reboot?

Correct, A bit stands for a 2M unit, so every tested page that falls in
a distinct unit costs 2M in each kernel after the kexec.

Worth being precise about the state today: the unpoison itself works.
The frame goes back to the allocator and num_poisoned_pages drops. Only
the bit stays, so the next kernel poisons the frame again. Test loop
in, memory out, and nothing gives it back.

Important to say that nothing block us from unpoison the bitmap, and in
fact my initial patchset had it. I also _think_ we should unpoison the
bitmap once we unpoison the page. 

I have just kept it out of this patch in order to simplify the patchset and
get the basis correct, and then evolve on top of it.

That said, If you think this is a must have in first patchset, I am more
than happy to do it now, but just keep it in mind that it will grow the
patchset by about 2 extra functions.

Thanks the review,
--breno

