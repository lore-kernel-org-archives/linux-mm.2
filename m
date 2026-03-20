Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C70CF1093190
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 08:54:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC3326B0367; Fri, 20 Mar 2026 04:54:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D74AD6B0369; Fri, 20 Mar 2026 04:54:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C62726B036B; Fri, 20 Mar 2026 04:54:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B6A536B0367
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 04:54:06 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 56F1E1A07CE
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 08:54:06 +0000 (UTC)
X-FDA: 84565829292.26.371360B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9896F18000E
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 08:54:04 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Kx7eLUMe;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773996844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ti6w3UGKRNZJIEubsdxOvS8+0znI3QDzivd0mDRn+kE=;
	b=HfB6s7KgNXk8Bqc0fw/men0hKJuUuokuAz0Zt/Fxk6k0E0xEljpDrIBiyxZVkXblD3mFJG
	2tPDCgvCF5ps166MtRdKgPHD8zbBpdajM/fZkuZ4sCjgQY07tsCKqoHN1IHTblajhvgjxF
	ZoGq6rIbDnVphndZvd37Pdxiql+bT4o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773996844; a=rsa-sha256;
	cv=none;
	b=DZCFzYC69aIYCMLdxVjQr069BlWDp4Cf/d2Kpxc7RSVSa+XVPU74YsydWPCjE+af7ITD6C
	4m5YL8PbBnTAUWQ9vMlBWX/Kd2lW46F2Gsfl0KSlpg60+VT5EDMY5ghYr/qpDApNPkvC6z
	p0F4UmhXJzU0xhvf9Yro2ld0/6Af8L8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Kx7eLUMe;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0179160127;
	Fri, 20 Mar 2026 08:54:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A459BC4CEF7;
	Fri, 20 Mar 2026 08:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773996843;
	bh=5mLUmodt5SMNzEDiEElPU8YWvKdgRnZ2+ssB/oc4/U0=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=Kx7eLUMey9gF3WXm9SZ7i3vb/q9mtGdACChDs6J8uPlH3PCtXhZxjl07Ie15PfFr5
	 BhhX+G2XlhyjNUGe96kYrFykp+jL/LwP2J1KZoZtTsD9T2xc8PmY84TbH+B9Ep9MMs
	 k+o/Ts5Wykt6zzTuT2ZZQCX/zACiEEVCCP+haDfWThndilA97kRD2d+TXIzG5j45iX
	 Vc4Z5HyUzePYRkX5EsjDiA/rFc12NciN/lDLniwIzsgPYganqwrzJRMK5OC+N9oga7
	 ttcUfazjmBS0ZzmBeybmu0r1CKLA8MjIXriTKvQL1oUkyfYXEUrLs4cCL1uT6D8ROZ
	 04ZXU+p5gHlaQ==
Message-ID: <1e71acc8-8dde-4fd5-8428-e76e8c86121b@kernel.org>
Date: Fri, 20 Mar 2026 09:53:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] KASAN: HW_TAGS: Disable tagging for stack and
 page-tables
To: Muhammad Usama Anjum <usama.anjum@arm.com>, Arnd Bergmann
 <arnd@arndb.de>, Ingo Molnar <mingo@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
 Kees Cook <kees@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Uladzislau Rezki <urezki@gmail.com>,
 linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, Andrey Konovalov <andreyknvl@gmail.com>,
 Marco Elver <elver@google.com>, Vincenzo Frascino
 <vincenzo.frascino@arm.com>, Peter Collingbourne <pcc@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ryan.Roberts@arm.com, david.hildenbrand@arm.com
References: <20260319114952.3241359-1-usama.anjum@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260319114952.3241359-1-usama.anjum@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: j44x4f7isjte51d6humnyc914jt1hkhk
X-Rspamd-Queue-Id: 9896F18000E
X-Rspamd-Server: rspam03
X-HE-Tag: 1773996844-808965
X-HE-Meta: U2FsdGVkX18uubES4fy7Zs0gAys0J8nuSQCNEr8IALExQJXvKD4Ws/vLWmxeGBqmfGDUKOkLqX3xbA1f44lm1RG92r0k0hNJfAmgsMY6zAXO3WLc+h31EnfrwrSPrtkTORZKKUljWDyp0hSdatsqv3anfsmul2/9i0acWduzgnizVyLt1YcKJOnHF08epQlga58W/EvL31Ej7fHWGrAYeGMYVAfMi0itcfRWK/68SPgt2Rv8ccK4D39Rc5sbh6rfbppNgeRZa0j5vlSHYpDGFbm0e6k8XjEwhfuIWpgFilvh9j2VYFxZcZQLQFbA54CK7jDMowSfvzHTo6NwDMy8FNg8p6WXmkvdjksF0t1+f3haAKTOaB6lOLuvmqiZXhmyMNZcbLps6tEFD5xQ/5cqgTvGqswWrmRY/RwaVW3Rkd1maY1UZswEHwzc66AJ0aLTt8lryjqQckdTpQOeh7v3f2O0TGAOKLOGuhvyYfbOH7UwtN2OrieOYz2fqfd/UQ2Mf8NzdjtSsmWnmbnSKFThdruoJnvanDazY/MZ1r/f5woULiLawsq8Clc3bQ5bGsa/9j7NyubwMsf8PnBQ9QUbxf4Nbh5OCgY7uFJZL/AzF3TCXRO0RDoJnmJAqFIn1OcbnRBnk9gGqpaPvyJfnxoXLaK4NuI7AvHVr9zayO5H6U7dgoQuN593CFsXaDcOezUlitHZGxx82RYOlE/5qsz5GSLv8PirpXaJD/MVTNvGBpkcqx8F4PqvAO/ktykfmh7TaqC/9Y4afLUnCZnMTF4dzh4Xx6ZxUDZgyrNQzuFJsOY4AVsVaUPZXQRrbn+we3M2Z5QezKH3Z2TCO/4Fw5zCzVvCvHAOwAQ7X06jUdmLUkoA+G2CPIFCviI1NIh/8eAQmgnmc6N9NX2noUf3nhOquAxYtivzf/h6MHUUHPDpOpTAzRzTrErPKnGGFzZLsNpziMme0TPmO/mAPP+Gh7M
 Fay7g6mL
 wP+Txj+cX/A8F/CUd+tY6uXpMc7VFcULiBgCzONhz5jWfZMMGchN77ycQK7jTsmWP6NRFBaE462MEMF8+CEKgkpHzvg5R7eJZUrp06yxOfPwEFigF8JFNr/+i0ZHgRJD+hIv5SMRGhSpc7cgUum86TfQ7fC1npNcJ8dmFqnCx5/h/aJFtJLjsFTcoUkOBclAzoXNAcvG9Qtz3WAQlftCqS9lYPcb97S2L908O6SeuCmYAmSqEXDZdJ095ZA0HUhI6BE7J8R8M1oaZVqSmLiKXknD8QLpHbgdGGKArf/LAaErvor1Bc3zoR8Sc17qtUBhJIvGlXJmp+nuH33M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/19/26 12:49, Muhammad Usama Anjum wrote:
> Stacks and page tables are always accessed with the match‑all tag,
> so assigning a new random tag every time at allocation and setting
> invalid tag at deallocation time, just adds overhead without improving
> the detection.
> 
> With __GFP_SKIP_KASAN the page keeps its poison tag and KASAN_TAG_KERNEL
> (match-all tag) is stored in the page flags while keeping the poison tag
> in the hardware. The benefit of it is that 256 tag setting instruction
> per 4 kB page aren't needed at allocation and deallocation time.
> 
> Thus match‑all pointers still work, while non‑match tags (other than
> poison tag) still fault.
> 
> __GFP_SKIP_KASAN only skips for KASAN_HW_TAGS mode, so coverage is
> unchanged.
> 
> Benchmark:
> The benchmark has two modes. In thread mode, the child process forks
> and creates N threads. In pgtable mode, the parent maps and faults a
> specified memory size and then forks repeatedly with children exiting
> immediately.
> 
> Thread benchmark:
> 2000 iterations, 2000 threads:	2.575 s → 2.229 s (~13.4% faster)
> 
> The pgtable samples:
> - 2048 MB, 2000 iters		19.08 s → 17.62 s (~7.6% faster)

As discussed offline, I think we should look into finding a better name
for __GFP_SKIP_KASAN now that we are using it more broadly. It's confusing.

The semantics are:
* Only applies to HW KASAN right now. Otherwise it's ignored. So it
  doesn't give any guarantees.
* Will currently leave memory tagged with some tag (poisoned), but
  tag checks will be disabled by using the match-all pointer.

After pondering about that for a while, I realized that today, all
memory is tagged by default, and __GFP_SKIP_KASAN is our mechanism to
request memory that will not be tag-checked (close to if it would be not
tagged).

Is there a real difference to getting untagged memory, if supported by
the architecture.

So I was wondering if

	__GFP_UNTAGGED: if possible, return memory that is either
			untagged or that is tagged but has tag checks
			disabled when accessed through page_address().
			Using this flag can speed up page allocation
			and freeing, and can reduce runtime overhead
			by not performing page checking. For now,
			only considered with HW-tag based KASAN.

Would be the right thing to do.

Assuming we could/would ever change the default from "all memory is
tagged" to "all memory is untagged", we could similarly introduce:

	__GFP_TAGGED:  if possible, return memory that is tagged and
		       and has tag checks enabled.

We could make it clearer that there are no guarantees. Like calling it
__GFP_PREF_UNTAGGED / __GFP_PREF_TAGGED.


(__GFP_TAGGED would obviously be something for the future)

-- 
Cheers,

David

