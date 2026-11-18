Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04A2E606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 14:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DAROiEXl
Received: by kanga.kvack.org (Postfix)
	id 203556B05BA; Wed, 18 Nov 2026 09:56:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DADE6B05BD; Wed, 18 Nov 2026 09:56:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F0D46B05BF; Wed, 18 Nov 2026 09:56:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E13B06B05BD
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:56:29 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 845A6A07AD
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:56:29 +0000 (UTC)
X-FDA: 85448540898.12.E8873D6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id DB813180006
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:56:27 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DAROiEXl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795013788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AfmHFHPccB7lfpPsxP2zwN+ffoQn2aS0RlA9LBjrJMM=;
	b=s2bs/FJQ+JJyoja6MCsy+NMBTBTJrfzzGWYRGWAgdPLopAHyHrJ6lF4DP0E1yInOvee8p7
	sNCAWHp+keHfkCT/5Pv6knAJdAaeG1HNxbWPRzthAEFRBVUpJUjbqR/IitpOrkDBcBa5Yw
	RQBCUWwzPJxHm9zYQxCAwF69yEsGu3M=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DAROiEXl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795013788;
	b=2cMCwRqxCD3cU7vv7k9IzVQuP8DVtkjR1Ua215lffa+uS992leUDcBc2fBZlmwgTV5ntJ/
	vEFjlYNi0967iy3z9dVLT3pBQdn5wmjSEHJKLO/mY/0Zm89FeeWdkeGPRlbF+MGBOVUOqt
	dTfYPH2kWyZRzOGe2Y/Lc3PVLsl8OWs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8301C622B3;
	Wed, 18 Nov 2026 14:56:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B3561F000C4;
	Wed, 18 Nov 2026 14:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795013787;
	bh=AfmHFHPccB7lfpPsxP2zwN+ffoQn2aS0RlA9LBjrJMM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=DAROiEXl/uBEjFrbVmJW1e/aAc9Qw3sYEQhfet8uq2R7VAv9EWfteSAsL96KEdtwq
	 don0DD0FM8uwX3AIRJHra0yYM3r7AOC55Z2n5caoOAQrgcJzB0shseGNOQyWwTAZh0
	 5+9KTQFc5p9AWagn8fbjPNFUuh5m/W/ciqOdTqrP4GyPZpvVcpqwHmSYJMa/rpaDvi
	 2XwZOFGbE1AdcZrdFSz5UIqn3oG25NeSaCUh6cU6cp8EJ5gP0vjqo25eQsJQmxYsmP
	 i7hJdnolkk9NcnMUKWI3B6laPesoat/dfAIZWRT9v7gkgwzOqDSWWV3zAEm7byKfzJ
	 kwea6dZ0nlEaQ==
From: David Hildenbrand <david@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Jingyi Sun <1045704958@qq.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Matthew Wilcox <willy@infradead.org>, Michal Hocko <mhocko@suse.com>, 
 Muhammad Usama Anjum <usama.anjum@arm.com>, Peter Xu <peterx@redhat.com>, 
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, nvdimm@lists.linux.dev
In-Reply-To: <20261117-uffd-dax-async-wp-fix-v1-0-c9a30f27f452@kernel.org>
References: <20261117-uffd-dax-async-wp-fix-v1-0-c9a30f27f452@kernel.org>
Subject: Re: (subset) [PATCH 0/3] mm/memory: fix handling of PTE markers in
 insert_page_into_pte_locked()
Message-Id: <179501378200.5042.13914562022654307180.b4-ty@b4>
Date: Wed, 18 Nov 2026 15:56:22 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Rspamd-Queue-Id: DB813180006
X-Rspam-User: 
X-Stat-Signature: rykc7h7hyzarmguxzhypku6ij1xwqikh
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1795013787-165032
X-HE-Meta: U2FsdGVkX1+CSGrrLny6dTwTNih+agx2s3Nx5G5F/LQ007vLryImmvy4sYU4cRBzyhx/Am+06YSPHP2ITuhMEWu80nwCqTP2ZAVFG5lJrxiCvn9F+FlLCde4gMxfE0Zt6LNr2hrNVUuHpN9hIqK52OzNhDs2y5Ag1pNIS/7h/n4DEn+ordTJCI4oLNuEoAeNsV6mj6LjCYh67NiMLnFr5Gt/hG/YMFNMBwZba0UFs8ABECA034Qsr8a91KwZj9DxExlriQHSi5oCWmHVMmiyxUfOAT99X355JD9kaaAoXW515pl4gNEcLMuWuLjOgJwHSvmzPqonfCmhenbNArCGHUJfLrPZStxT24O6C22Ig3fFnqxctaOpIOhMInQvErs+JoZmvB/kwR74eDweukavQ4vo+vBIPQTyEskyzCsdxb8nEXm9ngjzt9sWYb86BwZjKEY6lQapBC3OrWUXpGKbDswRpntX4x0DUX1RpORE1LSanhXIQ++wT+49Gnqfl5TQHerR2tNQpS7bD5dOb74rSIe1lI86BoKcfp4X0qS7FsWCwbU3a52aBkU36NCrriuecrF8yNC5Nr7WDxp9tHhHzGU6/DafIGfK9l0mnarGV4TJ5BtZux/54z8h5SVpNU3ArymyE7whZSUJutJeebz21R1Cp4kcAEdqKlUCOvagjGGEmwa6vijcUp+BWAnnPAP7+ez3zNe8n5kmRYSyVItGQa4FdnvSY5nc7bPOnA8yZLJqhbDT1eHdnsjXe/Ti7SdA3zsZGptWJ5QZQ9u0IDc42cR+qBrAylesE8WIfwO7YlL+7AEi/T86jF8xOFYFgINYTsz1iPMn1VoPDJebk4pD6qn5Ku+FwZ/zNI6xVGe5vj65W8JBj7BuyLSrmi5/0k6NELKAGe83lzQl8k8IJ3jYx89G7sijaIpC9hXmFpSmtB1BfCyI7MMTKv0MikKB3TTPifwndFMHSPP4USXNsvC
 5I0F5WOU
 xH+N9KrU05spU6dzAk+xN9ZTmQLyI2L2/AiG090FzG5/ef1Ud74x397Ajgtiwc0u8DXoUH7qSCegPQjiG4ziiPfvFcbc6xJViE6FdKqr9SDUEMN4nR5ymKm8tZg3cnMyVAaU+LyZtjNKyt2J4uwSggFWsP7gngdwn0/WsgNXfpqGU+OP80HTP4+ivR1v0TRxQ6t0sRLH75q+AvEqiydpCUT+qj6xKWgVuanIG6+/cvD1FAg78/i7i6VyCeJaTONFTCxhaMMoEGQWNkP25KEzTnfOHerrcFDBl+qs3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 17 Nov 2026 17:58:31 +0200, Mike Rapoport (Microsoft) wrote:
> Jingyi reported that a uffd-wp marker in a DAX mapping causes endless
> refaults on reads and SIGBUS on writes [1].
> 
> The root cause is that insert_page_into_pte_locked() treats every PTE that
> is not none as a present mapping. Besides uffd-wp markers, this also
> affects guard markers that MADV_GUARD_INSTALL can put into a DAX mapping
> concurrently with a write fault.
> 
> [...]

Applied, thanks!

tree: mm/core.git
branch: core-7.5.misc

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[3/3] mm/memory: don't upgrade non-present PTEs in insert_page_into_pte_locked()
      https://git.kernel.org/mm/core/c/3fa9917a

-- 
Cheers,

David


