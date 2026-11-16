Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 706A0606A331
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 14:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=THh/Ff3T
Received: by kanga.kvack.org (Postfix)
	id 831D26B05B3; Mon, 16 Nov 2026 09:14:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 809C16B05B4; Mon, 16 Nov 2026 09:14:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 720FC6B05B5; Mon, 16 Nov 2026 09:14:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 45D796B05B3
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:14:02 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C1C0314090D
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 14:14:01 +0000 (UTC)
X-FDA: 85441176282.30.08F5D77
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	by imf14.hostedemail.com (Postfix) with ESMTP id C6FB0100010
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 14:13:59 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="THh/Ff3T";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf14.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794838439;
	b=oX3hq+E72KHRY0y4Js48M3rF5+30ACW099uMd9l4OzIVNQFY2Y0ZDloFNKcfMcGEm0Y+Mq
	SvH5kNW+mXjMojzGYUKSI8uQWw5lX53rw4v+DzJ072nb2Tg3VjvDUo/+O3EC+BPJctpUze
	BPjK5XMnbeKcRcW4EmLL0xdfCoYNtak=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794838439;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mE4PFLCBDD7N+5kMo0525pvsFFzxkaRFBGntpezo6s0=;
	b=fA4iR1fqUuTaDAr8+VOgV1I/df5Tcg9ZZkpln6u91sB5OosIcXQZBKLLI1PVpG/GdntyWV
	sI7lbA3OvYUvXPr+LyKldDtCVwnHbO4ZNTEoyfEPUCk2azGcDvKkWOPKv65ta11W7c8IrN
	Uk0MvflTwXZYc5bbzAB8XJfLPVoMgWk=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="THh/Ff3T";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf14.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-49412eb1474so1727044f8f.3
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:13:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794838438; cv=none;
        d=google.com; s=arc-20260327;
        b=o8gIzrhKSLSi6+LnsD4fw5tcVVk4MYNkg6HHyYt9Qanra38Z1RwNfHbZnJ7+0afvtG
         hP48sGCAlj3mPVZrRBpy5VIjX4Qa3D5Ryz4cGZdKrHTEIvQvnaqSyCxV+UYX6BPdTbrw
         e2ErzV8avc1ayFDds2EGVFNl6Gs8DhpXnZPrTFE3Qip5DjBUrN+RdhgiNRE6zJN+99Cq
         wK51SzSOWtz481cLXk4aTc+9aP/Qhpt1xpwU51ZfyVUYixAgL2wSeP06mumyJOJmhmiN
         2yOGs/CCnbJZ2ncLU6Q+wgWpFdvT48f+anJT199b71tc1a703eYpaD6GodNm4fRsPY3n
         HkDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mE4PFLCBDD7N+5kMo0525pvsFFzxkaRFBGntpezo6s0=;
        fh=l9UWqLnnpFNE8J7zv+bmA3OPAUvY4olRaU3vwmy6P3U=;
        b=pffwdEw+KCfm51FMWHDsjqoJv9i7jOIjjGKE7tMtB8Ha2zn9DQBu1i+nAgVexEMDv1
         fZR7+ovtfCTbe6bRM6hU0l616Oz4Li+CT/o3JbqXbe2O+x2ng9DanfDNOfOzKkcnCyzS
         GPazjP36bFZDSJQj6d6aJqim/s+SpkKv+aRvdL9uLUlixzlJrF9a2P1nokNzZKwzlPkl
         n9PvT8KsZQTuzUJ9/rd2EOnR105AxywT6xU/aueRkPf2IEOWuKqHb2ZBm5YR3UsR494Q
         4pE/qTfYT3qxCm8tkJhtGaMvdP0HIlrZvQhwU4rcII7K9xzt4jLSQaEEEFcpAWBAjamo
         pGrg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794838438; x=1795443238; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mE4PFLCBDD7N+5kMo0525pvsFFzxkaRFBGntpezo6s0=;
        b=THh/Ff3TPgyCjPMV7tt2Vt54MZgY4HZjztMHkhoWsUj4HwwwC8VzJFuNWOZM79gUzQ
         YAcMIG2sraT/p94Oyz0UGckw8tsghHHSBsJv3zbMD4XEX2S9FhoLnYAjdfZoocWg9sQp
         8TY8FiZfwBX6qCJA+3IlC3OHOOXTCfpFYLnO8wdQsvyI1J6abugCKKSGzF7Dd1/FnqRU
         7FNOibVNPrjOOzCQ/O4O6CyC7oAJ20DoSKlOqaQ+neNVn8qtNgEEBt/lqvMfMBkHDNj+
         Yc8AmpIit630E1g5QWq0mCSfpGBJ/HtLz24l4d7UVWNtrpzf7gmA8zppow8Df9tvITme
         J8oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794838438; x=1795443238;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mE4PFLCBDD7N+5kMo0525pvsFFzxkaRFBGntpezo6s0=;
        b=Q0UqLIMMrVFm0n3unjO7iPEwMVg8TlITbLrJsYuecuE0vhSb4L9adLU1AqqezjXm8U
         vsuLnpHBdrG1CMtwE2CkKPjc5/CqWvdluLA3GDNN3rTqti94nru0CVHrM90RrJziUnbK
         We0MV/U3H3sgA+1PLBtd3Tl3dOa7JdCspha5DUL9GqedzgLO06qsc4hLK5vIscK+i9lF
         Zv5Cf6WUB9qG5R8NWbOGFM7+Ik+HbI351/dL2v0kzE9JYfyEdIadRKPghTD9s99fKtO7
         vvWiRY7UXAcsR3PeBOHhY5Uc1wHHPL62oRbofAq/6R902SW4fiF9IbLeCqb/w0IlRDVc
         dUKg==
X-Gm-Message-State: APuU4Z9f3j7Bb7TAXtstAgsiyrP4KwSDoaC+AYHTBiGK3EC7vXPbHaO1
	zC+vqVPlmQiv61E6BsSu49/PDb9F2hMS1fIm+VqXdE5bwIDaP2K/am9pden+/xwlQTjkMtl5H+H
	eAHo+FIxf6Yj1xzW8iDTsnzXTu4ZY9X0=
X-Gm-Gg: AZFdTZfDDP85oeWhzwAScF50Unz6AGUP9H904yqkQk06lPEKTpo+Weh0AuePzAJU2ga
	7qDh8iKKNR5KKzjc5aHfvMSbz99U2HrCoNQQUPY3S5VbtgtIN3dbilurNOBLBPQkzEtvcIrxqA0
	nRTZ1PiT4g7ohgUYf7R5ebrkkb6ZC66cvMk0W52teECLF8w7tQio5JQsE+qMmENykx6sXam5Eqs
	arhJ9kr5/z1YzIpc3lYXXY6uywt++ScMu9gTFg5p2J3+QZmTYbfE/TV3/eCJNzgWGbCYFXOeLDx
	N/AvfHp9osH3FD15N8HL7qKve1dTzeTXxX7NFjdmMlksFqs33o4Rjko4X3AvgnoDQyrQ4H80dvY
	nHVGhjCSZwXJvQY3Grp99xCPPB6ne39+CMkkPjn5P0FWH761v3mcQJIQlb9iPvNaE2hOjrkqrjK
	G35ss7Afukhr938vDMEfMpRsJ+dJFny630y9ZHnrrtQ0cV60fws5rnwMs=
X-Received: by 2002:a05:6000:29d6:b0:48e:d7c:4bc8 with SMTP id
 ffacd0b85a97d-49dad032b01mr11487696f8f.7.1794838437977; Mon, 16 Nov 2026
 06:13:57 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261116110122.309748-1-nakixii@gmail.com>
In-Reply-To: <20261116110122.309748-1-nakixii@gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 16 Nov 2026 06:13:46 -0800
X-Gm-Features: Aa3M54omNEMN1jWto9qZ-fJE2BPU-EGOtdYeDpXDgUWMj8prRt7WmPFciW1q0iM
Message-ID: <CAKEwX=M64ZmMLBRiAQ6FiiP8f=jkA4m=HM8rgQo-cir2SENPnw@mail.gmail.com>
Subject: Re: [RFC PATCH 00/16] mm: add in-memory compression of reclaimed pages
To: nakixii <nakixii@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Yosry Ahmed <yosry@kernel.org>, Minchan Kim <minchan@kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Barry Song <baohua@kernel.org>, 
	Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Mike Rapoport <rppt@kernel.org>, Peter Xu <peterx@redhat.com>, 
	Suren Baghdasaryan <surenb@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: C6FB0100010
X-Stat-Signature: h9rw1psk4qypzn5giyfb3b1sut4arg3a
X-Rspam-User:
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam12
X-HE-Tag: 1794838439-906677
X-HE-Meta: U2FsdGVkX1+66a8LFsB7oC/Go5MCgsOV0jI6v2whmO1QA72rbZt7WvHusDTCVCiOhsuN+blWczubrxJFa7QNeS74jUNZqZL5Uubb6DmCkS1YK/BXhJLvB7QzQXdredJGMrPeNgovWm+h12qz7nfvnK3V1YVbqP0/2aiSjAJfZ58cz5Xf5G42pO6/tDceJNwANDCqQYH2+GbPvYq9Ho3j2UmdPA7rX2tiw5xSSUYuO63aF7hXianmViX2YmVq96R/qqlnY1O5dRkXru/ofwV8pK9oCl1AUHxyuLW8RjhV9wDR4NMrrXiC09oSBIy+3UAg+MAsyScQfnMjhWDoZ1M98INXPs0yncY+uOv+2uvVbK7/twCW2lcsPwEBbCzHEi5lsJse113qWNY5wqMF6Ec+LVzViw45TnfKS6/OiQbFZwsGSk0jqo26n604VBmwD/cWZuETbGjqLn3eD54ziTAuHh0VptrrFe3ABFYQnPgvxPuXrFAc2xVmbpcIfbNIuD2q/DdjbS2LcT7WVnhZ+Un3PFqUPJJgjZvF/mnuPxyRIvIYmZDBKKH/rkrGuWmhMjTqKfXhS6X+cGJHyIq1nzmV/dayEpbtrJNCSb7KWl2MNgaJksiMGA+3+tbbLmYkgaJnUIsNjKaJDrbTyvY2BjOOzRuRCRP2OpKj3+OR3q1D+oWwHaPVXjLnDpoKO3YeYMOjVmRuDeBOXWRD4+lkMLSckVWbZIHDuGHn9QUnN3tPnj9BrolLL4yiyhYqgDhUbQdOr/aB6asabC1h61t7qrj+4NJLFFEjmln2yexSvd/qzp+8Q7TEjSO3A+tml+KkszPBCC9JaC0ngT15Wr4YcQ7cnXt34jqxI/PYsooi1SsmixvC4u0RX1ZVfGMkLs5tLzbeCAuB/nGDqNfQdj0bU0dF66GRKqaXhrfKb4la53reX4OQlITU77Ls9ahrdfbm1Rp2E5FacZRMAZq+rJH7TLC
 vSXIL6pV
 mlgc6WdKfj27RqnXk6hZ/48W8z9ocH1g741NLJv65IMLT1EMh8POGXCzN5og5Af8Czp91ErRxKM7Mz/Ws39+rAZkWG986e1WuBEDf316k+Pc04OKL9UvYbpw7ZsxtAWMDJ3+bZvhWhvMhHJqN9xYqiNeRRbUQTmUCfFFb2igesLItxD4TvQhKNXDzI/MsE3nuai6ZjEgq1GZLQJyNq8BO5h2l7K3l36fnDxmygMQWZ1mhQOp7K8Tx6XRObsthvXe3YLJ1+LsZRmgyz7cjv1G2A04esUVktv81rb/jv2TOYNTBlB5cafcRcxnDgFZhqv/q8R7wvydg7I1JObMsAE4H6X2VxLqyfUhzXo+pWjxgjjA8TjzvzQW4cuLzNnPLc2kkkIyItu8ysqJCJMhfC+oNtKcWeFEo6DC9fX32mVyUe2MY4vr23mVWWX3MtMFU23OxDn6I3p8qeTjm7Zd9FAWmvW70qv85Bs5OHq3j2QhX7Tf5oxrqqOw4rh2c6KOcr4oZRj5FhBOJ5sS4hPPThtYU0aldn3xXWa1cuJMm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 3:03=E2=80=AFAM nakixii <nakixii@gmail.com> wrote:
>
> This is a proof of concept, posted to ask whether the approach is worth
> pursuing. It is not meant for merging. The series is based on Linux
> 6.12.23, not on mm-unstable, and has not been ported to the swap-table
> and zpool changes that have landed since. If there is interest, the
> next version will be rebased onto mm-unstable.
>
> memcomp stores reclaimed anonymous and shmem pages in compressed form
> in memory, using the kernel's compressors and zsmalloc unchanged.
> Reclaim replaces the PTE, or the shmem page-cache entry, with a
> swap-like token that names a 16-byte slot. A fault on the token
> decompresses the page and maps it again. No block device is needed. If
> swap is configured, cold entries can be written back to it. The sysfs
> interface is under /sys/kernel/mm/memcomp.
>
> The implementation uses 16-byte slots, a separate owner domain for zero
> pages, per-key storage and bounded metadata aging. Memory-cgroup
> accounting, cold-page writeback, asynchronous compression, precise
> residency reporting and mincore support are separate patches.
>
> Refaults follow stock workingset accounting. The first reader claims
> and clears the shadow under the slot lock. Feedback runs after
> charging, outside the PTL and slot locks, before the page is read and
> installed. Consumed feedback is not restored if the read or the
> installation fails. An mTHP uses the shadow of its first base page and
> clears the shadows of all its pages. Swapoff returns payloads to the
> pool without building user pages.
>

What's the motivation of this line of work?

