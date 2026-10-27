Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D59860A261B
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 14:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QZ9H78KO
Received: by kanga.kvack.org (Postfix)
	id 963E96B06EF; Tue, 27 Oct 2026 10:58:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93B5B6B06F4; Tue, 27 Oct 2026 10:58:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82AE26B06F8; Tue, 27 Oct 2026 10:58:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5FE666B06EF
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 10:58:01 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0163CA84FA
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 14:58:00 +0000 (UTC)
X-FDA: 85368711162.27.23BF554
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 54A9B1C0004
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 14:57:59 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QZ9H78KO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793113079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fOIiJ8JXePL2+4wv46vzGrkknmQD8qYWdV6yhTVlKzo=;
	b=B/1vL9QCxmdBkrmQZSBKQu0eajqIWgZsuNSkGX22NoXJx7FD5aoPpf88F6Rzuq2yXiyEbe
	TcSCBTn05cxrHCwR0td+gM6G/JpUGhZmlWk2amhIybD00xDVsLBi60qW3dXhkLHGv3z40J
	pDh55r/dj0sV/7unYZ3bPvzw7yr3rDg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QZ9H78KO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793113079;
	b=MH8N9Lrfw5UFkfR7E9tk+ppqhPUrwYdr+iw8e4Rpo+z/GwRqkgkBH3dqwSqtNxxvD4O4Wa
	rq1x7yHcurtICT1B3BGNbtMlHU4qboSACK42kV86lB7zB8qbYhOs7YTNodzeEOxktSrzlI
	b5uGYNj6RaTJSE8z3DGKqwobed/mMAg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2739F43EC5;
	Tue, 27 Oct 2026 14:57:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D2201F031E3;
	Tue, 27 Oct 2026 14:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793113078;
	bh=fOIiJ8JXePL2+4wv46vzGrkknmQD8qYWdV6yhTVlKzo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QZ9H78KOsUn8YOcMuud+QSkEbmgph/VCrT9Y7/Cimob1ZE6aLammd9fcdbmDg8brj
	 2tz7i996m40glew/smJOea3vYSaNhKUgsdAOM8H8XFfBJlOaXXrDeOl3uQ06CTUMVY
	 D0R6JboK4Q2hlkmkRgitdKH0D1Y7cHAZeOo1xAwykWRLbCGsrbXLCNWkUwCCBf7XU+
	 UUsnU4Y3QhbgjWXLY1Z1lQPeukFDnnm3y8Mz5/pSgzJAR25XJt7V3fsoyHE18JjGqx
	 ZTf5f0jQ+BX0BQWjpKGMAl4WH42bQ8HOw3hIaZKu9lRcNW8ydVYtGc9ePIHvTmdp+o
	 8Pcnd9DZwx3iw==
Date: Tue, 27 Oct 2026 14:57:49 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Chris Down <chris@chrisdown.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, Kees Cook <kees@kernel.org>, Jeff Xu <jeffxu@chromium.org>, 
	Andrey Vagin <avagin@gmail.com>, Alexander Mikhalitsyn <alexander@mihalicyn.com>, 
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	linux-mm@kvack.org, linux-hardening@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 2/3] mseal sysmap: Allow with CHECKPOINT_RESTORE, default
 off
Message-ID: <auC7SFhV_qj-agQp@gremlin>
References: <cover.1793094611.git.chris@chrisdown.name>
 <7ff59c2ab6c234ca4d799f862eb7c3f22d671f99.1793094611.git.chris@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7ff59c2ab6c234ca4d799f862eb7c3f22d671f99.1793094611.git.chris@chrisdown.name>
X-Rspamd-Queue-Id: 54A9B1C0004
X-Stat-Signature: tmj8x81ydatdtumf33k9wsrbghocw8ey
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793113079-232009
X-HE-Meta: U2FsdGVkX18rHPzgT3pFXdPmDvrXNrH9VI3yc3SOwqBG6qQfmLLQtXmHD5Nbj3BTn9LTLBENDgVysCMvfTFO7p/cYlQ6Sn4PaXRGy8xXhQMagYxaJDautHuepmjzdwDm33hBZ98RBRFJoSn2MSgwttk0Fdn0XMn15Hq/fuIMsJwEAcUGFdmSrRxrG6OQub04bwD33urt1E07KXW4sEUwJ+xqHI1rnun1GxhHwJWvLkIn80Fsazidsq3FOL2fet8iQn6JvhJaNRQ35Joa/p+vPJg1h5h0zA5D3k7MogaSgU58ENUwjRH0D43hg4T6OVZA607SrknpGPbEJ/725AxXVKMppL9CZCLEcPf7YWHA0p2HuR4QzW7ysPyWVH+QSu2HNG04H06EDJfvFwJkO52yPj6uXF6pluo9GDRPiUM36t/lg6jlknqHBgkD/pdNAbo46MPmgbpEg7tX2DKGYs1jQCxrc/YhFusShGPr0Z2CqcqNZxz9hf8X3lKXsVohJC/VIRLUCU0RQFnzsIafdAGlmJLkNImDpNew6dLPomt8Xr1USxpJdpUTVfv3oDn5Igv0Z9g/Hny5eTWeyDdtzJvip/gG3fPDr89EHi/q3cPjBIYRUK+GJv1o2bav8ChbOjEa7lJ22hDN+Dj0hrmXu768oxwC9urYbkKWAg3/Ot0JoNxgFQd0pLCyu9iwQmZ72+sX5ClmvBdhlOpztehvCRivx/HHL9ssWy9jRgEo4xhc2Xt8ErIXT2g7u/3pCUGdmi8K912UXPYt3R8k1/iZCgqCwghCGlc9SjjJlihsBl6flX+38UG2H/3u5Am6gkacChk61ABYHcB+s1TG7XQy5/aUSRsGO7fHBYXKNTH3qIWuvHJFzQhFfVFLY5Bm0I2M89oH6WB5niJ2qMPwPYWhpPyHjmWtyfbdhBqF5vAyUpO3aljpqfLs2JO0Z+Afk1aB+xj8z9vQ5+fgVkDGr52uMW6
 IGZg3GC1
 3eJwHJOWAwsjVOGgRtsCElk7W8qyz0rj0qfwt4Fsjyc70szAKhfM34asQggxo2Y81HJ6OwvquBxZcsaheUgaxmZwmXQ08NKpg83dCW9f4jz/DKkyPh32SOxJn8uOF4qmVCY4gYJYGhwDkC89sEm1rkANOWwAhWqoIxR4evWfKeTj8h9g58wwsSBmzyNPxfwF0vKCJVAoLlOQTbd2k74V7IyDVbNJSacUB30/UK9YU+dNpp92EsGMWXq2gPaCGs/TihTIUglzawedsbyxoWPCp/YMyItYQJTbPCf5dQQ70oa/s+4E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 07:43:17PM +0800, Chris Down wrote:
> MSEAL_SYSTEM_MAPPINGS depends on !CHECKPOINT_RESTORE because CRIU moves
> system mappings when restoring a process. Now that sealing can be chosen
> at boot we should instead use this to determine defaults.
>
> Let's add MSEAL_SYSTEM_MAPPINGS_DEFAULT_ON and move the dependency
> there. Existing configurations retain their behaviour. Kernels built
> with CHECKPOINT_RESTORE can build sealing in, but will only seal
> mappings when explicitly requested with mseal_system_mappings=1.
>
> Hosts can also share a kernel built with MSEAL_SYSTEM_MAPPINGS=y and
> MSEAL_SYSTEM_MAPPINGS_DEFAULT_ON=n, enabling sealing only where needed.
> This lets hosts which need sealing share the kernel image with hosts
> which need their system mappings to remain movable, which simplifies
> deployment.
>
> Signed-off-by: Chris Down <chris@chrisdown.name>

Sorry, NAK to this patch. It's adding far too much complexity.

The honest version of this is removing the CRIU dependency, and since it's well
documented that many things break if you use it, and the config option is
default-no, then it's kinda your own fault if you insist on doing the broken
thing.

So I don't think I'd mind that, and it'd make the change simpler, as you could
fold it into patch 1 also ;)

--
Cheers, Lorenzo

