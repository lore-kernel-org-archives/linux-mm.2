Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B2D7606A32A
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 10:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mgEUf9NT
Received: by kanga.kvack.org (Postfix)
	id 9A8B86B0606; Thu, 19 Nov 2026 05:35:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 959FD6B0607; Thu, 19 Nov 2026 05:35:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86FCD6B0608; Thu, 19 Nov 2026 05:35:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 663FA6B0606
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 05:35:26 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 031341409D4
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 10:35:25 +0000 (UTC)
X-FDA: 85451511852.17.6E66131
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 71A93C0003
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 10:35:24 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mgEUf9NT;
	spf=pass (imf22.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795084524;
	b=WdmdXUCJetRsx9zz1fiPlXtilTOF2U80ecf/e2wzPtlwWYHNYBsCqpQn6FO4aaOJwJCG1Z
	Nv/Bd/rF7oSVO7Ee882njSEQKa66NwIoIKgMvLH8CV7wmvcOvlAtJ9q5kTqhKLzOSM4MEH
	JBUdzHz3KGEIevOmEYRwvFooxR69jYk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795084524;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JsGJnh1Us1nFR2tI0H992ADBy4V/O/OzAtsn6t0WKfI=;
	b=HQ3Te6fCRn0es10rpkfucOPjp5QnsYdY1hhA0onZb07NO/EOy93h0BgyR1hMyk0GLiBmh9
	SG1HxONLmTS8R3xUNHShVi0I9SoLjQjzp1ZnRqNiWDqMXNn8wlMX+FmTIKF/PacNf0KjU8
	OY3erAnOrhAXcFarB5LlmNv+5fF/OGg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mgEUf9NT;
	spf=pass (imf22.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1250262399;
	Thu, 19 Nov 2026 10:35:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F4471F000C4;
	Thu, 19 Nov 2026 10:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795084522;
	bh=JsGJnh1Us1nFR2tI0H992ADBy4V/O/OzAtsn6t0WKfI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mgEUf9NTEDNqcpkcQdxykTbsz66R8+TlS0h9eX29pv5i80HtUv3mM09IXMHQXiiHW
	 SZwP+7AuP1LJCa5Ndk8ozkx/2Dnro0kFhdJfw9BZxJ4IQdPbM8MuqOU07y9lXQOMcJ
	 nQmU44n5aDMW6nNJyIxE8O2aBXJhhUyiDNxRGP0gtp9fUple2SCXltXcZfUdubVyPb
	 Au3pRJre86FqFpllT2zTPaVMoq/hIbnrhLpcovtZy2268TLN+j3C4gmxfGmHyZrepk
	 CPwGN+1V+iIFj6KAv5MzsYqQ1tlsXFkgvA1HA+CTv5PNDudoxWMSoL3LZUwu+rKgjq
	 BgbeLY+DTwvKg==
Message-ID: <sashiko-outbox-222962@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH mm-unstable v2 1/1] fs/proc/task_mmu: avoid spurious
 seq_file warning on interrupted VMA lookup
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?QWRyaWFuIEh1YW5nIChMZW5vdm8p?= <adrianhuang0701@gmail.com>, "Suren
 Baghdasaryan" <surenb@google.com>, "Lorenzo Stoakes" <ljs@kernel.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Liam R . Howlett" <liam@infradead.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Jann Horn" <jannh@google.com>, "Pedro Falcato" <pfalcato@suse.de>, linux-mm@kvack.org, ahuang12@lenovo.com
In-Reply-To: <20261118103421.776-1-adrianhuang0701@gmail.com>
References: <20261118103421.776-1-adrianhuang0701@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 19 Nov 2026 10:35:21 +0000
X-Stat-Signature: apkfnt36zn66toprrz5n8cam9q8qx3oo
X-Rspamd-Queue-Id: 71A93C0003
X-Rspamd-Server: rspam12
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795084524-919856
X-HE-Meta: U2FsdGVkX1+EfR1se/0rjw6nzDYEI09b7nksMw6HKWxennZLlqntmoDK20jtyo63pGKegWb4AbuTv9AF62S4nnyjjCEAXFhebnbfX3qH2b+9uVtxKLuUyyOijBljg2o3ooU4E/tDEbWcGx4GB4cIIUiYmCofX1NBAzg6Afl7Ueknd+xPygFhghAIgKzFW4fV8+P9ISF4nd84x7/42EmFXWpnYx65+IF/GECnNARCEMvDIHMUSY0FR5qDdtL7vtBqbmVGWiUP4UP8xwyyqzBY7p0VKrvW8D9qEIWibCbavgU+XtmF5xOwK8A7VI1voBbQSAMYD+aXAa5+Vet+KyqQ+fx+05XBGucFezX0+WRghrWstbAJKa9JoQEV6UPWD7QEPyrbe7MEhrgdnM2C3pIjjOI786OHymotIxPodXNF3+kvVbuoB56Y/jb7vTuS5X7X8iZTnZgOs0BAocxMjykMbIxUHJMy+2SgktEWQE57c+O5vd+rhp0heXHwLJ7lTBJp8jQwL+cD5y66ZH9kpqnTYXYn1JwulX4HjDqFyZcfuNlfR3M02W5+JbBseWJjf/CkjORLDHUXwNy1O1Y8tMDJWRxjxVQllH9FCRpdvsRBntxIF8TokYKhDSfelufhKJuKWURVaiCAD6Gp/w64YRM6EuLC/M/yfzH2OfmDg4zvk89f5pQz10paE+MjqMiXpvenji7gBd9cABAUCQjwzR2Ej/Vs53maSnJYxN6WnvDO5rJbGyHA24WR9kW/xQcQ2PNtEETEeCS2fWuawhxWc+K9fpfTHEaYiLnIfWuMlQ8HjpicVMgjRct7JucbvB9ClvagdQe9uifsB9lWINLRT0opYbqUQTVDIsAYBY39n148uH5Zr4oNeON9dNMBvurlEPuKQN/TW/OBdtXKqaWRnBlrjRev56kNvQvnMkvc8Li2Z0urCmmw7prB4tGDx6agn+4YNWoRhv9vguRrorqwDIO
 sm3UGE8g
 i3J1YtCZB6mjPkOgeRJfK3u/2+woDQHrwffBCmgtedUM0HqCYX/JDyifFRs3n+DboJ/TAzM+9K3fF4mypfsYPAVZ3egw2kaxU/ZPww64pCTPKUY0i+HgDinuLAmkqlXfrDgck7pkF27LoT3TcCMmcupeQkApH9lcSK0ChO0tQnLzdNIYCaBVzqj7qXI4AIpAyvctLgk8WigrPOMjCYh+ZCViplRN7xJVngbyd0bpkzsqAsF+WXiDfKT5zSf+HNOVI8v0OFB7/+an4SGQPNwdsGIL/MzrpLQlfa6Xg7sOarWX5BxBMnVbS9IyeNC45i6NPPehSmKq66ZaWgI56IBGKG4qfnQZibfKfN79EIh0jMBOl6XeseZiIRj5aTgnIESSHGdICNrgctsxafxRxJ7C2Y8B44v4mAF41p1dIMW5BcD13MwkJCkMb8NHDvvdfk5iH2eMgu2QxaCC1pPTQenZ8K6ru0vEGBsSySe3xsGzHyoVxsPZyIiU0Dgrt8X81tCjLBRF25AaszmQdjNAbGaFtMfBeGpVhPEsOOshjgB7FD48ZyT4mgGjMpTYjYLhufslgbNFpj+g8S398gxTn5kRaZDL1r865RAfeU4OmJnGk3RPyB2nwb/kKKylG1nqmOl4ChLbjh8rHXGRBeP0y337wSCwN/kAMWhK3/24nAGaWbqSamYj9zIhwmR1VIrHXgz1z2dIZ0SbJ6prQ38obuCv/Qh+5hOR8oT0415m6S7cEzG5uiOpVoCbOTJc5S2qPpFCmfqNdLgM/XN0CLzihQt8goq8V88Jvm73b/LcGvT8DkEG2/gXVOg+Azkeh7BidI3rBlsyJH0zr/c9/8onyXITxXsm5kE1DmH80ILoj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] fs/proc/task_mmu: missing Fixes trailer for commit 5631da56c9a8
--

commit ea1e2d22fcfe8a8b373cfb53c201e13a9ff8f69b
Author: Adrian Huang (Lenovo) <adrianhuang0701@gmail.com>

> fs/proc/task_mmu: avoid spurious seq_file warning on interrupted VMA look=
up
>
> Commit 5631da56c9a8 ("fs/proc/task_mmu: read proc/pid/maps under
> per-vma lock") introduced the possibility of returning -EINTR from
> proc_get_vma() when a fatal signal interrupts mmap_read_lock_killable().
>
> The issue can be reproduced using stress-ng's VMA stressor, which reads
> /proc/self/maps while concurrently modifying VMAs and periodically
> terminates child processes with SIGKILL. The reproduced command is:
>
>   # stress-ng --vma 0 -t 60
>
> When the VMA lookup is interrupted, proc_get_vma() returns an error
> pointer without advancing the position index. Consequently,
> seq_read_iter() emits the following rate-limited informational message:
>
>   seq_file: buggy .next function m_next did not update position index
>
> Save the current position in priv->last_pos before checking the VMA
> lookup result, allowing it to be reused by both successful and error
> paths. Advance the position index when returning an error to avoid
> the spurious warning, while preserving the original error handling.
>
> Suggested-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Signed-off-by: Adrian Huang (Lenovo) <adrianhuang0701@gmail.com>

[Severity: Low]
Should this commit include a Fixes tag for the commit it identifies?

  Fixes: 5631da56c9a8 ("fs/proc/task_mmu: read proc/pid/maps under per-vma =
lock")

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261118103421.776-=
1-adrianhuang0701@gmail.com?part=3D1

