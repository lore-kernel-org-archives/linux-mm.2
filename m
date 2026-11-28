Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A074606A324
	for <linux-mm@archiver.kernel.org>; Sat, 28 Nov 2026 00:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=dlnm6EXO
Received: by kanga.kvack.org (Postfix)
	id BA2026B05B4; Fri, 27 Nov 2026 19:57:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B78BD6B05B5; Fri, 27 Nov 2026 19:57:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8F6B6B05B6; Fri, 27 Nov 2026 19:57:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 62CCE6B05B4
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 19:57:24 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 20BD380582
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 00:57:22 +0000 (UTC)
X-FDA: 85482714324.17.A1C1EF3
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	by imf04.hostedemail.com (Postfix) with ESMTP id 457B540006
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 00:57:20 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=dlnm6EXO;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf04.hostedemail.com: domain of chris@chrisdown.name designates 209.85.128.169 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795827440;
	b=VNW4YFCQcIHM6+57sO4nBSN3XlV9F2F067Zutd7TTz4T7rWbLq8RXbMao2LIYi5Ph/oDtQ
	OTh1Ge/Gc3RXBrIP5CH20CPH3jAKI2+wue9ICItcg4W9WswCbby9JEExV5qzWu1gqF6kSX
	A7IziR2MdznJCdSZB6+udNwDtG/O4Y4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795827440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OkwyOiCRAz5EAkzPE2HGFHWSVBJwZ9Gjp6yJVpEfm8Q=;
	b=xKz5t/x7zxq+bAY6WgV7IprAJVYby5Cg/cO3gyxIhBb9mjmDcwdcB90Bnm8FIRKhOnobmj
	uMLgGRcii69UpybA0pFu0VaFVWvkExM3frQP8L6YCj4DfjqTpejNPquNXuZbm/2v7VhG3u
	681sPcRT70Pt1G0hD38tYvz8qcFi4fo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=dlnm6EXO;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf04.hostedemail.com: domain of chris@chrisdown.name designates 209.85.128.169 as permitted sender) smtp.mailfrom=chris@chrisdown.name
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-8b3402105b9so61260077b3.0
        for <linux-mm@kvack.org>; Fri, 27 Nov 2026 16:57:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1795827439; x=1796432239; darn=kvack.org;
        h=user-agent:content-disposition:content-type:mime-version:message-id
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=OkwyOiCRAz5EAkzPE2HGFHWSVBJwZ9Gjp6yJVpEfm8Q=;
        b=dlnm6EXOrdrZ6AovFJwTNmaTG/gf5bcqgCPcyCqclyFlqSW7UmC5XZQotyUZ27cd6H
         hznadLVgOdDowg8PSi0N+Q+PCJND5LkuloDY8BpmuE1jIgX5Dz1aCpU63BFUNKZUcbGs
         zB4v3AtaXcd5CapyFXpYHVmsljBELNiQe2R70=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795827439; x=1796432239;
        h=user-agent:content-disposition:content-type:mime-version:message-id
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OkwyOiCRAz5EAkzPE2HGFHWSVBJwZ9Gjp6yJVpEfm8Q=;
        b=goR0lIzJ5Bs6qpGryQdUB4R6QNxhFGKOy5Mu5c5gJlUeis1lusvhbW8DAXV9Icc+H0
         mTLnpMxAuaCGqK3haOoJLyL2JGinVnjQkedy9CoAKi9noEkvy+1CCvWjtWvaHfbl3gi9
         ZIR+YYV7Y+tm+7BEqzBBqo1slWa2MbG1mXnQWs5JxbW9ewzOvWESgY1pllE+xtQgShPG
         quviPA4nwsXSvFUjawqgg6ZIQ+KQRJcdcv3xFVA09McPDo2QBaizOEhK2DwNTWqDWE6W
         C+Tn5bV1+9UhqkD9lzYQauK0qrgcYTRi+0YLfwxPioZTVgNIKwV6CjJDtvD8TDkteEG5
         5LuQ==
X-Forwarded-Encrypted: i=1; AL+hErETlu+toWeOZDCQ/l2LL8zPZ/NdZxd6e8QnDpZEe+dMCMkJW7llaKVHFAtTTaIo2oMYi2WhdG1Zng==@kvack.org
X-Gm-Message-State: APuU4Z+BI3cotybetnKeEm5az26VXog9kSf1k5VyxPR83phNHpXAKHme
	wGjDzvHvswjaCZELfeYpMpP6ptK4hQD/WXNbpmjxlHKMI+aNt3FM4Y/5V1htzvsevx0=
X-Gm-Gg: AZFdTZdMUcyVQOsQBkALTBlFJZGGdhkb9OJbf4aq1ugYjEaF2bg4PRnYDhTumEREm3f
	KrZUeCg4It3tGoP9haxhvn0msIf9gMC+u3vCjJP1o0MFd786Y8aOsEF8KA91UgI+HRvdcl0kAq5
	TFPnIZMCaCrmARquqteJFn2Jp02RIejGM/D5j7a6fud6Ohk+DdN7sudOq3JfNKUyMtOneYJSeKi
	2nYSHbmBi7soTWxzQX+lHajfVNbRJkdM93B2/2evA0BNPh1v+tL665T+UEM7sGZ95iZlQ16H9gI
	iUaDZPh2QWnYWT9Eo8BTj+udPFjOe1j7gwCHOaptFIDDbWOcyHoy1IqC/M0tyJbdKsAU59ZZy9R
	hQfozhEG7yuGV9dD/JIsJ220uKq4CqpgSix66UdXmSvVKBZOInNl6FFed/Zf4CaGlRSQc6AwGlB
	26D1HQeGnioez8Kg63TkaSE6HC++DEo5jH1GTKDhnZmM1XjgM9mFe9nmIdvBI4S1KMOxpBOnUvY
	9XYuFiiQtDTwcbXT+kzHGqZOQ+TzU17RiEVjplKdaIvaRf5TuxzITY4U4FDsBr8GpPWgd4O/N2m
	dFg5G9FkdxvIAfDv4Vk+Jz47t0NJGV7jUza9j/fUuu0Xm25jhoQZViNThBuOnWUd6GQnZsOfbqe
	IRPyp0hrlA8iY3IfvKDP9HP8d922l+t8yX0qf9eoXuSHHICrXXSQ8r4dMyGOXm4WSrTFr8N6ePb
	LPYpV3uZgVPTK3j5kiGJ4+DyI88fu9ojs1Yw+xJ1xm3AMV5BfeKrmLhkVyiluPaFLcv9KLTO6pR
	tYrepTza3vqvB07BNj8sOQ=
X-Received: by 2002:a05:690c:9b11:b0:8b0:f116:1200 with SMTP id 00721157ae682-8b5204efae0mr102371357b3.85.1795827439428;
        Fri, 27 Nov 2026 16:57:19 -0800 (PST)
Received: from [172.20.0.2] (c-73-207-185-9.hsd1.ga.comcast.net. [73.207.185.9])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b52028bfa2sm100757467b3.14.2026.11.27.16.57.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 16:57:18 -0800 (PST)
Date: Fri, 27 Nov 2026 16:57:16 -0800
From: Chris Down <chris@chrisdown.name>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, David Hildenbrand <david@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>, Greg Thelen <gthelen@google.com>,
	Greg KH <greg@kroah.com>, Ming Lei <tom.leiming@gmail.com>,
	linux-mm@kvack.org, cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] mm/vmscan: Fix legacy memcg reclaim deadlock
	against filesystem freeze
In-Reply-To: <20261126180228.9b672a945d480e3d3f301985@linux-foundation.org>
References: <17d0d1395c0237d201a1abb2473d51f5@kernel.org>
	<f188775aea9580f9ab2b477788503434@kernel.org>
	<20261126180228.9b672a945d480e3d3f301985@linux-foundation.org>
Message-ID: <awom7B9Evkdhq1EY@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)
X-Rspam-User:
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 457B540006
X-Stat-Signature: de7xwnkw545gmqnn87jxo31bmsscg9jr
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795827440-215170
X-HE-Meta: U2FsdGVkX19Z/8hUIAt+gc/1gxkUnMzR9E2UUhyYQKhcdEwrj0zlCfSnVufbb9BjuxIbF0F8PWSmD1G6hfxsUm35qNICOEvoV2yqi7Kz82RxUIYgDBuvcRxFjV3JtJ5J2aiNryOcQ4LufwkiFFhfXOEd7AAFFcSR334wot5cldqN61GKs8b2zwL4iXBJgdRqQuCP8ARqrPJr6SqceNrW36F42wVYGfuwOxNuBdmAGIKprR/IO6g4oU8FLCR20z3TvGlOAkkhMll05FawllzA4Ipk+eVgDvHQWAHaNnQSM/PZ++PDtttuCLrrtfOgRd9YoVsj3BzVquY2qHlJZYoR74C4cmbT/AEHixLpyC3fIyGQVMhLwqsqzI70U4yxhdbxZvHgC4v8LoBGTlnjaoo8lPbvG7nrwWmdmh8lq9/EAgipm6Ce+VP3RIMHvqO8jRFVaz/3Dcfd6ietX5EuXTi8tdACtUkH+5RZwpKyS6yBrw9FW4pSzZxmhI9ZynwXtsF6YiCWD64XNV5RnJG9XihMzBYMHV0eZIMtVw5C7eP6UiE4hD/64uET7z+hWCq7NQDBklqgGtUXE+1DgDHuU6E4nPi+twxz+4QZwOMiHMownvVUESJkjKQkNGjg6XapgcLtmLhueKJH2x6EkPpGUTXB6XXEUiVlqwJpWv2T2V08pjvobz9HApdfl20sYzf3fy7rm2e+Q58m8WTVRqlN4nTMvDzj5Wu0xRV9oTwA6Iuc9Y55c8nQ9k/u/2Ksu8WHodWDjBc4dNIObdVsFMcyKyTilEplDlZmuZVhX9TwkD7kkp+aMiuZ3Yb85D2IYbg6RvKrxml4PhtGHlPRvE1wyVG5t9ztgTt5kCBj7oNFLFAMEYaFSjCgCEHRK/2yst2oNNWFT81QBEkxodANTZaB5yphzUqhPyARpbUe3ZzlCfhRlU+wDcLqWeNnAYGlQDoitpdoVWtKheaSmDU2mXcJgWk
 ozXyapIZ
 2HqgcoJoAfA65dgxg2PurKdMM8TqIsXvvLgAF2mxhJDqc5IobxOh17htKzF04yJXLvjyFaNZ3T4OJNu9KXIypSzl0RQJlYN+2zoR2si+aWwdn7CwUEeYc/AoPvTN0gR8z4qGq1obTyc62NctzMy9vIokN1sNTnGw00zM850oT6REnB9uLP4DqsMOufXduAguTnohG0313xFfRFP4QuteWtpEhxz6QVqnz+Oypel1y+nHYCtnrJ2duaHn0OdJkQBtOSDSXRl4g06cZDBY0a2BPjZ+E+3iXFibSreW9viAGK0R+ZoVEr23srne9lb9s4+eqYCYrti3JaxTBcrr2voNHqmDaDRGOijiViJys+Z/T/+aSATDOqq6GnTBXggFaGyjB/1KRtcUi0PCymKfnxFBgxb452MR0dbTtJKrXaZRtL2URVrUIYTwXDE0E6obJMAjwlHGUGge6dpaZkvnz7zsIXhkk2cC5asX/wwxgUf2J1PAyRAo+wY/LDUB5iwvfXD6UMu5RjgAnMnXJ3xXKtcT1EXVbeMnOfuhij0c4wgqMsq/sIFrT0DRwZFYRK0QJ7KwXCxRete3zVDVF+F1L2qPDKfzN73FV494NuPiCkOfOyChKeCREVOKuLFfKcYE4byG7woUmvoaEx1hFlAYCztga1cJcx3ySkwXKZJPmKmVv8RvZlP/n69fbvPzXPX9Y0LOagIFHNSs5nk+yW+MZy0CJoB/Q/w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Andrew,

Andrew Morton writes:
>Can people please take a look and suggest whether it should be a
>standalone patch, or just fold it into this patch, "mm/vmscan: Fix
>legacy memcg reclaim deadlock against filesystem freeze"?

Yes, I think we should fold it in so that stable doesn't get the fix
without the scoping. With the other patch on top, the reproducer I used
for Tejun's patch doesn't deadlock either.

>(That's mem_cgroup's fifth bool - maybe scrunch them all into an
>atomic_t and do atomic bitops on it?)

Hmm, oom_group and zswap_writeback are in the read-mostly group on
purpose. I also think packing them into one word with runtime-written
flags like this one is likely to result in cache line thrashing, though
I haven't tested that. It wouldn't save space either, at least in the
x86_64 config I built (given each bool sits in what would otherwise be
padding).

>(I am told that moving wb_wait_skip to just after oom_group would avoid
>increasing sizeof(mem_cgroup), but that puts wb_wait_skip into the
>read-mostly section. wdyt?)

On x86_64 it doesn't increase the size from the previous situation I don't
think, since peaks_lock is followed by a 4 byte hole, and then wb_wait_skip
just dutifully slots into it. In that config, pahole gives 2240 bytes for
struct mem_cgroup both with and without the other patch. So I'd keep it in
memcg_cold, since the read-mostly group is for fields that are set when the
memcg is created and only read after that.

It does need an entry in memcg_struct_check(), though. Every other field
in the groups is asserted there, and without one nothing checks that
wb_wait_skip stays in memcg_cold:

    CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_cold,
                                  wb_wait_skip);

With that added:

Reviewed-by: Chris Down <chris@chrisdown.name>

Chris

