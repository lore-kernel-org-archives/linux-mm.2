Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1F91606A88D
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 16:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kWP9t9GW
Received: by kanga.kvack.org (Postfix)
	id CBAD86B05B0; Mon, 16 Nov 2026 11:55:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6B566B05B1; Mon, 16 Nov 2026 11:55:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0AF06B05B2; Mon, 16 Nov 2026 11:55:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7AD536B05B0
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:55:24 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0415280161
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 16:55:23 +0000 (UTC)
X-FDA: 85441582968.13.F08440C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3B87C4000F
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 16:55:22 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kWP9t9GW;
	spf=pass (imf17.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794848122;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8rZOm9cyO9/o+jh32Sv8L1QuooKEur+vb0oVWZZU+ZU=;
	b=gvzUAsfZvngXeZ3YCDd7Gv6875tu6yQYYn96hcxdjNWNM2tepBo4d9kDuQJdrMh8+IARbw
	XvwV1pV/G4XI5QcgPtck72njD7iLNelngFbg5369SjI5eN7WDjL6UdoiykbWfAkSuhsoRA
	nUSbjb8JCDzPoc2f1mHyGXtfnjFfvvk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kWP9t9GW;
	spf=pass (imf17.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794848122;
	b=1orimsr1Z/ui+wD1roZrzzees3HWOihj4pVAlduMs/j0ZFmDPZtjLTZnKjIZ5GKs+36uCW
	ZrjxtchpZLz5WNrol0yBgPjjVbcziwx4xZVAymqA1clACzWoOIz3TtXmsQgMc57oJaM4wB
	74aysVuwrxlN2NZc2y7PbY41VDYKqUU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C3F176296E;
	Mon, 16 Nov 2026 16:55:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81DCA1F000C9;
	Mon, 16 Nov 2026 16:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794848121;
	bh=8rZOm9cyO9/o+jh32Sv8L1QuooKEur+vb0oVWZZU+ZU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=kWP9t9GWCos5WxA/8KiAvu/sE8CPjNex6w0Ru8Q8v8Ip7RAYzqA2897SZQeZ5QGLD
	 xYdYlmsIDi2gxlN/OAma8mu0rKgphAhZm1zFqBVEAZn4xcCKt4gv9y/VuMMFe2Pqqp
	 UzWr8iiBZ66BO8r5pCgm9Fd871j/xXaH+EhAQ9Xs25ia7p2cjSd+rECkZYEOqD2mWm
	 Fsun+U99Gt90g5ktgNz7zD54HwS0QRrhM1qlEfd75tBHYL0PQkX2mvcNROMBu9Hhg7
	 PoAOHIR9iSfIYVNhLslCbaUgRGeOh2A5L4Iz4gKewxF9b9NfcXiYwwkydsh1hgdfxd
	 SzMeDGQjP/evw==
Message-ID: <8b6e489a-eb73-4b2a-ac65-dfadc8c73bfc@kernel.org>
Date: Mon, 16 Nov 2026 17:55:16 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/6] mm/slab: Support selecting slab hardening features
 at boot
Content-Language: en-US
To: Chris Down <chris@chrisdown.name>, Harry Yoo <harry@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Kees Cook <kees@kernel.org>,
 Marco Elver <elver@google.com>, GONG Ruiqi <gongruiqi@huaweicloud.com>,
 Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org,
 linux-hardening@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <cover.1794506262.git.chris@chrisdown.name>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <cover.1794506262.git.chris@chrisdown.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3B87C4000F
X-Rspam-User: 
X-Stat-Signature: ywbufgywsiwr6e8e7xuxqmhemab5phzh
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794848122-649126
X-HE-Meta: U2FsdGVkX18kKi03ReDuQxQy7jfr7acOGlVuzV7qOfzR2eGrAUFSHUq6OwC+PxA4Z0L2Yxr0RKEGKAAf0FkVOkyKOQEInkRqkm2PW8hAMEJX2kpaeZWp5dGXF82zaWbo8Z88+FkBW7iFQp9cwtkyCmnLd19b3GG6LHUO+I73peQatIQaEmZ9vuNev92IiH4fMUMW5Wle66QbhPpJyIIHXaNzQdHJYOe5Bpwf1jUa7Q7lE1v0lxjx0VrGgYSHuTg+nnMf0sOMty2Vpe0Gn71Gu+AlOVE18h+YdPyLHlAnl87bInOMgCNBe7yskud5zHVgcX+P2dtU8xsNMnsJZ+MWdhhqy4jy5bHDe3w5m7i7TQcxpQ/POGjhcR7dNUliDVSDzf7K/DA5PKeaSJRFKEvESW2eMndpX6qlwWf380iLAmURlTZYXlJCD1mwVrvWPmApi1xIK5ySU1AhgYJJ3ob0fq0AclYphpoFd35uNjHIEVziJ/my4Z83WDjKjxZQ+vW1Q/FLt7ztpAyvWPV2uEh/1X6oLl9ZKFAdf65nWQPcnJ5s3VqmeO/aS07KxjwZzg6rOJUZr7mIytyOZ8HIY1dp7nU7XFVYFf8BG52m0wMFp5Pyxj9KQvaigxQ0BliGXi/Rh+Z0IKRDkAmBwKvKccDS9Re4jsjMGHvGTSE+Rqw+a9L9vZS16eaYV4kwWEeC+MPdy2W2x1HjEanHc8GvdLM0ncT4ylh/7UrIPKK8E3lCsaNTAG4TiWgr6Bn0eDVCfTfmcQ88m/X7ZPF0odFHKnM4mVBXTRG+0UZbpBZzZucGW7ZjeXdW9nfOJbXGdKa813Ij3910IvyT+azJ/2e9EPRIt3PI1R0Hh3nVna5SqQwi+vOIYSDcouYyDKAP4qdO3GOatilD2+fsIl9ZepCwwkxrXH3jF/REdCipbjPaFBUe+QFPEWrWF4tRnCl0U8BzyGOnLIXROdAACExpmx5ORzL
 HNP9naG7
 ehM6xHE37WuOTs5RLhkNjEjmXGWAuklfIadbmDfdaszQgOatYP2jcF+FhR37xRHPpHJBO3dfNqp6Mg/UbP3/5JeN3mgevkNDwX8Rp5R5B73qdXZkNW25qStPyvwWqav0LFIylBqO/T1KgX7lhfTSp0Rfgyh9DZ+g44XJzvYOf+SUEHLvXE4OIRK0pJfoHbtbVqVN+v88zHTfWciS2pR5XYm45v6hp4+w2j25xnCQKiIkCrHbYsMtxS+TCF7xgaNHe4YUln3KAy49KSF2muyMg5vZ0X0BmX4kG5alg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/13/26 09:51, Chris Down wrote:
> Slab hardening settings are currently all build time choices. This means
> that, unfortunately, hosts with different requirements end up needing
> separate kernel images. At Meta, for example, some hosts are built with
> these options and the rest of the fleet isn't, and that's one of the
> things that keeps those kernels apart.
> 
> This series does two things:
> 
> - SLAB_FREELIST_HARDENED and SLAB_FREELIST_RANDOM are cheap enough with
>   sheaves that it makes more sense to just enable them by default than
>   to make them switchable. With both on, system level benchmarks didn't
>   change measurably, only slowpath heavy microbenchmarks did [1].
> 
> - SLAB_BUCKETS and KMALLOC_PARTITION_CACHES cost memory (Harry measured
>   about 1 MiB and 18 MiB respectively after boot on a 64 CPU VM [2]), so
>   they get slab_buckets= and kmalloc_partition= boot parameters, which
>   default to on when the option is built in.

I'm not thrilled about the "default to on". We usually do these features
opt-in. Now our distro kernel would likely need to have these "disable this"
options in the default command line, with documentation to remove it for a
hardened setup.

But yeah doing it opt-in, the hardened setups would now have to start
passing the extra params to enable this, even if until now enabling the
config option was enough. Also not great, but we can argue they are still
the minority?

Of course there's always the possibility of adding another _DEFAUT_ON
configs. Not great either. Sigh.

> Whether those two should be folded into a single slab_hardening= is
> still open [3].
> 
> v3:
> 
> - Rebase onto slab/for-next.
> - Always build the slab_buckets and kmalloc_partition tests and skip them
>   at runtime when the option isn't built in, instead of leaving them out
>   with #ifdef (Kees).
> - Declare slab_buckets_enabled and kmalloc_partition_enabled in
>   mm/slab.h without any #if (Kees).
> - Drop the remaining #ifdefs around slab_buckets= and
>   kmalloc_partition=. Both are now always registered and ignored when
>   the option isn't built in (Kees).
> - Keep both flags as plain __ro_after_init bools rather than static
>   keys, since they're only read when caches are created and not on the
>   allocation path.
> 
> v2:
> 
> - Make SLAB_FREELIST_HARDENED and SLAB_FREELIST_RANDOM default y instead
>   of adding boot parameters for them (Vlastimil).
> - Skip the memdup_user() part of the slab_buckets test on !MMU
>   (Sashiko).
> - Keep slab_buckets= and kmalloc_partition= separate for now. We can
>   discuss whether to merge them into slab_hardening= or similar, as
>   Harry suggested.
> 
> v2: https://lore.kernel.org/r/cover.1793253633.git.chris@chrisdown.name
> v1: https://lore.kernel.org/r/cover.1793086056.git.chris@chrisdown.name
> 
> [1] https://lore.kernel.org/r/auITixAJMfLtfa7i@chrisdown.name
> [2] https://lore.kernel.org/r/179312451613.474906.1475329637924619088@kernel.org
> [3] https://lore.kernel.org/r/aud4gPOUzvHtLYnJ@thinkstation
> 
> Chris Down (6):
>   mm/slab: Enable SLAB_FREELIST_HARDENED by default
>   mm/slab: Enable SLAB_FREELIST_RANDOM by default
>   mm/slab: Support disabling SLAB_BUCKETS at boot
>   slub_kunit: Add a test for the slab_buckets boot parameter
>   mm/slab: Support disabling KMALLOC_PARTITION_CACHES at boot
>   slub_kunit: Add a test for the kmalloc_partition boot parameter
> 
>  .../admin-guide/kernel-parameters.txt         | 15 ++++
>  lib/tests/slub_kunit.c                        | 85 +++++++++++++++++++
>  mm/Kconfig                                    | 11 +++
>  mm/slab.h                                     |  3 +
>  mm/slab_common.c                              | 52 ++++++++++--
>  5 files changed, 157 insertions(+), 9 deletions(-)
> 
> 
> base-commit: ce6518e61e3b4bf4f97f7ac6204049b9eba7eb75


