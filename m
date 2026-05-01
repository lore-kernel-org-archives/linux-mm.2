Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5994FF8864
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 07:08:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A5B46B0088; Fri,  1 May 2026 03:08:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82F7D6B008A; Fri,  1 May 2026 03:08:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D0056B008C; Fri,  1 May 2026 03:08:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 56E666B0088
	for <linux-mm@kvack.org>; Fri,  1 May 2026 03:08:03 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 65E2B8BF9C
	for <linux-mm@kvack.org>; Fri,  1 May 2026 07:08:02 +0000 (UTC)
X-FDA: 84717971604.04.5B3F996
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 85BE140012
	for <linux-mm@kvack.org>; Fri,  1 May 2026 07:08:00 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ORtiKrhy;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777619280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cemJpSXDWd9iDjOku+pCdIEFOXTEKGaSTE76UGZlihk=;
	b=5pgYBSaw5i/o1cXtj5QGp+C0ddhfY8Rz37QVqZTa30BKuL9vCjiy//1CdmwA1ElVUwr/5c
	X7fnbfDA3Fb0JuzRcl/v+e8qveVtks+kyMWrgoXpXmuYwhJUKv/GRvpS2ro+E0aJyAkCD1
	zfWZK1KOnPIXdZXal7MOmbuGqGit6Bc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ORtiKrhy;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777619280; a=rsa-sha256;
	cv=none;
	b=S8XBswSGldPxSlZZUSZ5/TzgPBRA0EMwGYz1u3JgS2drDfhDFr+fzoaM8IBL7CrS2D7gcK
	L0nyH8UWua5NyCVxTioQFo7szlS6wppZDHZE/h5BOjpQLjsXcv11ETEsBf5DiJpKlHfQ8z
	/6fsTVfVlS0UaTiqnbCsCNGwgaZ4ZTU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C293860142;
	Fri,  1 May 2026 07:07:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02066C2BCB7;
	Fri,  1 May 2026 07:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777619279;
	bh=epgThRWo7zS+qWmwPbDJ5PG4Q9G1rxWn4n0y5BifbUg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ORtiKrhy9dQ7aJ6eNDoOyGh/r29yIWz8o4UuwJqiwXIdGOvGO+6U72J2GUMD3ec91
	 V6m7B/tDiTW7v12gJFf0MTXVDSU8OJS21pstXmrIdFDVjKM4YNqok2BKnca0UdC83f
	 XrNglRxq8nVD3uDqHnAbM2zhIn6ta+qnoBVuQCiQalWSTU7E9Gw3Bo2VGk0jaqmanQ
	 XgXYmdx+/lIXs3TA8PzHjKr0NlLNkV0P29tkqgdaSmYmdoAec/BRZhj3f5RDfTBluZ
	 JZcoI5Eg71bzQjkmZ2TO90k8tgsG4S+bYf1VtvkhfwPQKfq3jriHCIVrrZRKyk9EPv
	 ogGVMMcEAP2gQ==
Message-ID: <b5379cd3-f7bf-47f9-8a60-c7300b4415a2@kernel.org>
Date: Fri, 1 May 2026 09:07:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/5] mm: Support selecting doing direct COW for anonymous
 pmd entry
To: Luka Bai <lukafocus@icloud.com>, linux-mm@kvack.org
Cc: Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jann Horn <jannh@google.com>, Arnd Bergmann <arnd@arndb.de>,
 Kairui Song <kasong@tencent.com>, linux-kernel@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
 Luka Bai <lukabai@tencent.com>
References: <20260501-thp_cow-v1-0-005377483738@tencent.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260501-thp_cow-v1-0-005377483738@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 85BE140012
X-Rspam-User: 
X-Stat-Signature: nihc1gqaiys6irjnk1i94p5awwgdoxqy
X-HE-Tag: 1777619280-275825
X-HE-Meta: U2FsdGVkX18HtfuIRCBCHopDy2nvr6eZu4DDYkQ8OZhrlqgGRdbIU+wHreAXjvUfzKvHgnWD1JolwDln89PuISUSJ9BCr+3luyIKBrNZgI+dh0UpCh7emxMdYofGgoqZklG8/Dn7DCwmNwV5RFOY84Zagd752eXgsFxDoqjQqUlQx4M0NzspVLoMTxnd9UYA7G6LgCOD0wUVYv8NnGEPeMzPgprXxrplcP1eVSsJN94oNaq4RGjp2Z+ALV8j22eYVBVaVSae7MPdiQntjDOUYwbN9YJG3kMyhB4DDid7OQwYtV5bEnWPk0qAsEbZn0By92QhJsfzi71sCtX4bBQcNTAynwhZ9rPWfDmDWhp8oe7EBVMZvGUhaOvPiGFSF4Co5cMY38ZFQjgn6Vt5ZIxBZZJV45N1dm1Kl/fcPXaE4n1C53AEFST8tlIG3HWGYxNnzrV9gWSyu+1NTKRyZ670QYgrZlR81gHJOkIfu8w3JN3TlzBsRYuNFTinvN+7Qja+kOkefK4fUBq/96xSJ+hOC824/f4oWdJk9D7ybaxqcrZY9WqJAIqu3k3rk+9I3jhaWF2DGAz6y5jz+D7H/90Mj7zZc8VZ20QxuhKwwdra9tIGfanWe1yTRQLPknNWT8wft7xLXLx8abC0vYknsXHw07eLOeajjJ4oguimhDQ1B1PY2AuD0vwk81676yqYBNto6Mc9HEN0ESaDsYHPHV8NjY81TjQHrHPTwNnlYuOP/fSwMwmmPEbKayGJFs7TM+hn/PcO39FOu3uAsqqxlVCGxufeiv3mN0kvncQ2n2ifvytpEx20HO+2VUyWrPWV/L5syA1+LxHbDWDT1RFKnP6I+g4p2mHWObuQIVo0bE5/g77r3CTP80w1MAfm3oLsRqSB3jyaELDFi6sN/aGvTHUnwCtLYPHoLww9UNDhUQBDg3hcycyLfLpIvrlP6ZFUBH8NPYYPhu3TXgYJzJO2lkj
 r3r8Dm1l
 4fvSG5odXS3I5U9k5HxUq0KWs/zo2tLcJnIwYZVIZaiM31VKP/Qw8P+Mto1JuCI9dxFCbxHmNm+li6/llXa3JcLDUyab8WZD7D5lfJZiyKAJ2SiSptcgNQCUvE9K8Zx6jOcjo86xlR6q0nVqoZo8VH1SRsKW5yn4gy5USUrrxKWXVzC9IHcTsnynD9zJbUnP7yuQkgJwgtutawB6d8Vpo73gUIUrZXSrdZ3J5dG2PtAVIVeveCNwJcZ4WZyCIzI7eEJLs6arQUf/tE53e+xNsBjD6zR8CXT3SHI8t+ryqNcBZEZlrGLjDesFDyw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/1/26 07:55, Luka Bai wrote:

Hi,

> Copy on write support for anonymous pmd level THP is simple right now:
> firstly we'll check whether the folio can be exclusively used by the
> faulting process, if we can (when the ref of the folio is only 1 after
> trying to free swapcache or the page flag AnonExclusive is setup) we'll
> directly use it with few further handling. If we cannot, then we'll
> split the pmd into 512 4K ptes, and do copy on write only for the
> specific 4K page that we faulted on.
> 
> This logic is truly memory efficient since for most workloads we don't
> want to allocate 2M new memory simply on a small write. However, it also
> makes the original 2M page for the process suddenly splitted on a
> write which will generate some performance thrashing. For example, if
> process A and process B share an anonymous 2M pmd, if process B chooses
> to do a writing, then its page table mapping will be changed from 1
> pmd entry into 512 4K pte entries at once, so the tlb benifit will
> suddenly just "vanish" for process B, which sometimes may cause a
> observable performance degeneration. After that, we can only wait for
> khugepaged to do the collapse for this area and merge the pmd back, which
> is not easy to happen.

You probably know that, historically, we did exactly what you describe in this
patch set. It was rather bad regarding memory waste and COW latency, so we
switched to the current model.

Note that there was a recent related discussion for executable, which was rejected:

https://lore.kernel.org/r/20251226100337.4171191-1-zhangqilong3@huawei.com

> 
> In addition to the problem above, this logic can also generate some
> deficiency for THP itself. Currently THP is just a "best-effort" choice
> with no "certainty". THP is easily splitted into multiple small pages
> on common calling path like reclaiming, COW. A transparent splitting
> can cause throughput fluctuation for some workloads. For these workloads,
> we may want to give THP some "certainty" just like hugetlbfs,

There are no such guarantees, though. And We wouldn't want to commit to any such
guarantees today. For example, simple page migration can split the folio.
Allocation failures will fallback to small pages etc.

If you need guarantees, use hugetlb for now.

> The effect
> we want is: after some customized setup, if only the system has usable
> folio, and the virtual memory alignment permits (or we setup to), we can
> make sure we always use THP for it, the system will never split it except
> the user wants to do so.
> 
> This patchset is about both two things above, firstly we add pmd level
> THP COW support by revising the code in do_huge_pmd_wp_page, we added
> switch for it because different workloads may need different resources,

The switch is bad, and we won't accept any toggle like that. A system-wide
setting does not make sense for such behavior.

A per-VMA flag? Maybe, but I expect pushback as well, as it is way too specific.
So we'd have to find some concept that abstracts these semantics. But I expect
pushback as well.

We messed up enough with toggles in THP space, unfortunately.

Also, anything that only works for PMD-sized THPs is a warning sign in 2026 :)

You don't really raise any concrete use cases or performance numbers for these
use cases. Some details about applications that use fork() and rely on such
behavior would be helpful.

Note that an application that does fork() could use MADV_COLLAPSE after fork()
to make sure that it immediately gets THPs back.

There is also the option to just use MADV_DONTFORK to not even share ranges with
a child process in the first place, avoiding page copies entirely.

-- 
Cheers,

David

