Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EE29CD98F2
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 13:05:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2E026B008C; Fri, 19 Jun 2026 09:05:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B053C6B0092; Fri, 19 Jun 2026 09:05:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F4076B0093; Fri, 19 Jun 2026 09:05:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 774526B008C
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 09:05:07 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 05895120416
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 13:05:07 +0000 (UTC)
X-FDA: 84896682654.21.EF3C31D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 30525C0005
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 13:05:05 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YBqxtIa4;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781874305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3RGkspmwaGp3x8HFZ9d4EjIJxsg4jEtvWO+pm6iV5sM=;
	b=q7FyaMgRueS5m8sZL2zBKrb1AGOh91S/+8U2i4jHPipsNWKW6asdKcfUR0VFUvhQixW3a1
	qq8SMh/UP6xXuTm84JxM72ip1AawyXEsVOgRVNVVqzSqnkfv/Z1kQwEIAuZzaITKy7Bp2Z
	0af6fsbk03Fk2TwPmKyiwnEInYCwWU4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YBqxtIa4;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781874305;
	b=vdlWdHiYWA9nrZkf7JbHvrw8YFkHGQbzDS6aNkXPZDaiQMvj5a1iKNujNgv8sqWTB1XKV+
	4uzHPGFf2ShbrjsIAEwex/avZXYxyHiOfm/2MxH8oFEv21ShA8wFKPvsv661Czy+s+8EDf
	3oNYJ8Rze5zu56QFsj4TSIf0j512sdU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7F054601F0;
	Fri, 19 Jun 2026 13:05:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A8CC1F00A3D;
	Fri, 19 Jun 2026 13:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781874304;
	bh=3RGkspmwaGp3x8HFZ9d4EjIJxsg4jEtvWO+pm6iV5sM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=YBqxtIa4PzQLu+UoxiWO0hu+n/hC29Jhxa7XPAfBYa2hbM7INhduGBBi7GzjLh4XG
	 W9SWf3NEo2kBE0nXZ5IuHQ0jUoiekl0fInQE+Eo4WHQ3fkqB8+p1/sLqTvG/bV49dS
	 0qmXHr4zWG9s7t8fu2vZWpFx1NNIBNFIQKwyFE89ZyCT0Srymexo3K+/ndwkUDTXFz
	 6QNUNCvlUwvUF2BhP9YuJdv9XPD1m0bnK1rswPg2lTaYdV0jJobn4/Z1EIBMsK7ZTP
	 12d/iheQ9vp6EFymch5+5iwIvfI29j+HCiuRQZKdagtUgQiZ16IiFojKQKKiWRo3jE
	 AKadqPpFf/U/A==
Message-ID: <c56f8fe6-9e06-4a65-9470-1fcd12189ed1@kernel.org>
Date: Fri, 19 Jun 2026 15:04:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] mm: __access_remote_vm with per-VMA lock
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Rik van Riel <riel@surriel.com>,
 linux-kernel@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Dmitry Ilvokhin <d@ilvokhin.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>
References: <20260616190300.1509639-1-riel@surriel.com>
 <CAJuCfpEKgiQDGXgCKrqnn7Wk5YrT8nr4-H88PVeEruSKjtY_CQ@mail.gmail.com>
 <dd66797a-6fc5-4c31-ac43-d767560f3029@kernel.org>
 <CAJuCfpEqz9t-x8abYD6idtHmi9t8p4YfDmnbkJ-ix4i=RMS4wg@mail.gmail.com>
 <603e002e-77f4-492e-9ad4-75572e18fc0b@kernel.org> <ajU3q1e6mpWsJ6Xa@lucifer>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ajU3q1e6mpWsJ6Xa@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 30525C0005
X-Rspam-User: 
X-Stat-Signature: m4rxxpnnzk7px55dtekqhrjpebih3p8u
X-HE-Tag: 1781874305-367647
X-HE-Meta: U2FsdGVkX199lBeFF+vPJCpg38r65MLGIOXSsdafaWRbbIUgU9d18QoYsVBSAesI28NwhSUNBbG9VA6TU/u1zgTcsTe63RaZYqdO/OUagBpxOTv/zqsygcjza/BHUpb5HtTcq08y2Q7dLyaGc1PUI8IdPJ4rJ176DHpFV/+dfsVYYWFA9gX72+m3DWXof6SSZN7TBT+fRxMui/OXlOX3u4wbd/c/ZYuqdhVQrf6gpEospw+xjQgUdukEL7vXH0/lM9/1oY8iMYwDB659JRiqpQYcQswT/A5irRfwqf3chA6w3eQHLXadbIV9jW51hSseF8f5JqDRn4Jsr+kzn+ydu2GVvyLt13DY4xpjogOvrFx1AisrDMmM2+ITwNjrUuWfEO0EMc1frHVTa18WpR8pOrq+wUq7i//Z9ACnPUlP5RJHB4aYsmS4sWC/MfjQYO2E0+Bi5y+udwIPqoRx+OfYlvNXs7Mu31ICMdGgHDd7r7zXn7wHbxKExvaNeKbYkO4Zk6B0e+mKIuc+vSV/8Ko6X4p94W9y1ZFuqpS+96Df7OcH3sHs1mbus0dJG7n0fvufkayHjmaRWl/hBmlV9ivIa8tCDm+OeRMJNHM+ToogkCPqs8BYB/UWsebWOMyZnExtK5cvGj2U9rJ5aku5oM0W0n/+qLVtUpezXq8KLY8FWyzfMZXZE5vCo6ZUuEcTwwarOGit1Z0UqrQUmtUasv7BAjnqPylxd5q/8RLKbxTAAG1MMoErkBr2fn2U+kRNRoW7V6eGXARxZnk6k0e8OAUY6lz272PQGXFwkeFEKYG79uUvE8tLWf5U5C06uc+apCCIIDQbBCTvAIR73yf/CJKZEYpd1wuLp4OS4owm92dZJz4pkMm/5IL1fFjsAwM0WzzEjbidSOsrpeDI+DN3BzJMAa4sPbZyIZcrhRUaylAhBAgHXaZ5hgvms524fgD9PnWTqLtZTReIp/bsgMDA6I0
 +lpuH7cM
 zbnRAx4TonRmlstzX+4jtEaxwY5f3XytEbT3Bl3XImUm5vpP+3rKVouv06FnUpiF6o60tHaJB9N+ztt0+RwJu6VRaA/LRwjh6WzNH6R4MTGrMq4Nb+VQ8f2RWgwlts1jSNZIgzyBTSnJTlhBqmI59aTzv9kgJg40dFgjH17PXuZSOQyd//aat6WeCDCS3c/vOuE+mRRa1JU7NpPYCWNtvf+H27mNp2HFGTTGU4q1wtm+0+YakduaTcJgCXE2v0E+/XVuisXGN8H/v60ng7G0K3IAVkfU2CPvvWF/sSEgNlbbLtQG/Z1iL/jqiJA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> All GUP does is walk page tables and call fault handlers. userfaultfd is nasty,
>> but existing page faults must also deal with that having to fallback to the MM
>> lock, so it sounds like a solvable problem with some churn?
> 
> Well I think a critical problem here, as pointed out by Suren, is that holding a
> VMA lock means that the VMAs around you can change and in ways that are quite
> problematic.
> 
> E.g. The moment you drop the VMA lock that VMA might get freed and then merged
> with something else, and the next VMA you consume is the same one you just
> partially walked, for instance.
> 
> Now perhaps you could reason your way around this, but I'm pretty sure there are
> cases where you might actually miss VMAs due to races (Suren knows best).
> 
> And also without an mmap lock people can unmap and map new VMAs in the range as
> you go through which might cause weirdness as well.
> 
> Really, unless you are dealing with a single VMA in the range, I suspect GUP
> needs to stabilise that whole range.

Well, depends, really. It's not like a all GUP operation that target many pages
runs exclusively under the mmap lock that would prevent any VMA changes.

With userfaultfd, for example, we drop the lock in between, to lookup the VMA
again later. There are various paths where __get_user_pages_locked() is
instructed to grab the mmap lock itself, to even temporarily drop it if the mmap
lock was dropped.

gup_fast_fallback() grabs some pages to then take the mmap lock. And continue
from the next address.


So it really depends on the use case. I would actually be surprised if there a
lot of use cases that strictly must block concurrent mremap operations etc.

The important part is that you process each virtual page address requested
exactly once. If the VMA was merged in the meantime, you continue from that
address in the previously-processed VMA.


Some use cases might indeed want to stabilize the whole range. But I wouldn't
expect them to opt-in to using per-VMA locks.

Just like with any other page table walker, we cannot just convert all in one
shot to use per-VMA locks.

> 
> If we could find a way to have GUP fast-path the single VMA case sensibly, then
> that's probably workable?

Right, that's what I said: start with a single-VMA interface that supports
getting called with the per-vma lock or the mmap lock.

If we have to fallback to the mmap lock (userfaultd? indicated back by the
caller), handle it in the caller of that interface for now.

> 
> And I agree special-casing only one place but not others sucks.

Yeah, we're not doing that unless inevitable.

> 
> Perhaps we could find a way to get this improvement without it being quite so
> 'tacked on' but without needing significant rework of GUP, but in either case I
> broadly agree we need to improve the codebase as part of the changes.

We shouldn't fear extending GUP in a reasonable way that makes everyone out
there profit ion the long run :)

-- 
Cheers,

David

