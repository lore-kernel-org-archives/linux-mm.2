Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 343D9C98338
	for <linux-mm@archiver.kernel.org>; Sun, 27 Sep 2026 17:04:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E84AE6B008A; Sun, 27 Sep 2026 13:04:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E35806B008C; Sun, 27 Sep 2026 13:04:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D247C6B0092; Sun, 27 Sep 2026 13:04:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A6F686B008A
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 13:04:52 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 41AD8A70D0
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 17:04:52 +0000 (UTC)
X-FDA: 85260166824.06.ABC32D5
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7C3B9180006
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 17:04:50 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dsZg1jch;
	spf=pass (imf16.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790528690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XYOA6wzNnhspYLPBWaqZitj5w8g5poC+csBPNVU7geQ=;
	b=mLPd8FNL/CoKwDSKGsaACLasT9XeJkUepLCGz7Z+knzT6nwC2hR7k9V7QgVOd8k9iC/pZW
	3hsKP/te6sBC2tN3m1FL09FkmI4mk0Wr1WsWot88j/vkm3v7v1BAIF7fsx3hdR8RO+DRje
	j+bAQ42F+tqgJNHFic4BG4I8tKITOqM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790528690;
	b=Vz8rB4DSk+2Kpx0MHIWDDdevqD5Y9wkzxyJtAugQXTQX+aM+iQ4P1tDPvnaSRDfSSy9heq
	HUuHVUidKIiRSkvdmgRHrf+RHLkJCF+9mTHvxXGYXs/gmWjuRqmqirGUwLHkcAt94JBHvh
	PA/JLXqg8qjwpdiBZI/0bbCQxxdY8+s=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dsZg1jch;
	spf=pass (imf16.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49ffa15f67fso5802645e9.2
        for <linux-mm@kvack.org>; Sun, 27 Sep 2026 10:04:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790528689; x=1791133489; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XYOA6wzNnhspYLPBWaqZitj5w8g5poC+csBPNVU7geQ=;
        b=dsZg1jchqUHbSnjz76G6uJz+kFmQwZFSkX+y7ek0rbnvB++HnyK0EaAhiDTy4vX/bb
         oO85MA7V7monsbc9dbZs2w99Ph7LW6QMZYbVDXTg54FthBxalXvRdEnQijUu2EVoUCCH
         jg85KP8F/XvtGdY/BnYSyxI5fpvXsw0W3N1SKWGbyNTnC7kJykqBFRdPXtXVE/585bwd
         qoRxa5vdy1HZWYvT3MQLP3pI3CeOn6Bw5CGHxfqrM9I/r1Y4y8qtt4hf6zSR47SVEv1W
         6AA3YUWCRkct5VZ94chmmnsURitm/xZyI4gvBYCKEQjl9JPv6U2/TQ/TxxV/XseWNwy3
         dilA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790528689; x=1791133489;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=XYOA6wzNnhspYLPBWaqZitj5w8g5poC+csBPNVU7geQ=;
        b=Mk5EuyUZOMZq9gJKEgjgF+wPGhCX+1oTgQL+nv92T+9WkxAQ1CvjQJHM3ryo3RhH/b
         V33qGIu908u61Gfc3dty+fU/RZyT4OUTBHfJUsOUjugZ72EDCfl4in/pXTSwWEK8k2c6
         S4DTUnlOLzwXLmL7R5AX/rkEs43OSD4dlSuOZjUBfbSWphsWiPg9hOo59/TgMcr4AICv
         4vgiGbQ+bXM+1mt8BkdK7m8GSB/sJbiAFJDOpM6I4/5rYEoC6nk9ErfeRwRiVyKju6cl
         +esZ7z4Lzgxt3aKH3TRt1xYDJdTXrnUmLAOs0Jr++oEm5pO+RP/ewm01y1pUtA0fObn9
         Pb9Q==
X-Forwarded-Encrypted: i=1; AKwUvBz71hk9asiuqFEm8vvExyRDQEiNmIqQf1FtorkvRzt+ypusJfGjfUB98+Go7VRpqCW5OmCxP0WglQ==@kvack.org
X-Gm-Message-State: AFuF++ni/k2y0e7NCS8dH36mjRIhciuXAN64ZjUT924dYRWyNhFLDF5q
	GfXiw10k4zj57vlSNBlwkeIisFYoaOjvSW7dlXxBhX+JvehCJrj+XqrN
X-Gm-Gg: AYBFou2jPbscBexOmbKnZHv5zy5AHAqx0k1kZfLed0m0dSMclWasgVb386XzPf4nG9r
	nlCfNbgPVj7NkE9FokRtfbpHhTsaWgmKyUlICblPRNhPmfH0EfpYsfGLPXyzsdylEo943KSHHyT
	O732leSvjV0xd7CBpyN5fmO5QHAt8mC9yif9FAy8jAdpPfRXkO7RacWCA/oSrWMQOMZKiW7RSmn
	0dSnXr+YnFT/alXrjDYWJ0Z7+kP2S977g3oLZWsoBPgL6vcaU+clKu1QBxzEpRIZnZtNAnc1V8l
	/NlsFxrMcbzwZ0IILwBARZMDKliBEtmMYW6JiuAUMKO5u87vSlVSl/R5EJs+yTyU47FIw1wUa2s
	sFlbx6o71VmreCCOCDRgRfkKMUwZOH8/EhICc1G70xzB7kLDUWGEUPREqreY/yaxbz31dr4NuAt
	6xvk/Pz89rhGLUDRwsK/tVSQVmDPnzCZPpfvtKyFAfmnmsGDmpx8qw+GgyAKSqj4IgyQZj7ZugI
	yXQo+oxC75wihrEfh+yz4VS11MPtNEDhoBFZibW43obffeOMPCuYo8uCA0HB4dolul7U1V9xYb7
	OBDFo6gPhX1CdKcwIVzLn9/i8PsG8F++mphk9urR2VVuqQBgQbi21wW1c+PyXoONh7cmx2rJpOL
	l3sVkov1Hnv8=
X-Received: by 2002:a05:600c:3b98:b0:49f:ce78:3564 with SMTP id 5b1f17b1804b1-49fe66f187cmr214606745e9.21.1790528688718;
        Sun, 27 Sep 2026 10:04:48 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-b2e6-5301-2072-0420-f831-ed4e.310.pool.telefonica.de. [2a02:3100:b2e6:5301:2072:420:f831:ed4e])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fef5f876esm149241385e9.2.2026.09.27.10.04.47
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 27 Sep 2026 10:04:48 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Peter Xu <peterx@redhat.com>,
	Zhao Li <enderaoelyther@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v3 3/4] mm: hugetlb: Fix subpool usage leak on allocation failure
Date: Sun, 27 Sep 2026 19:04:26 +0200
Message-Id: <20260927170426.2467-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20260916-hugetlb-subpool-always-track-used-v3-3-38aae9b5ccdd@google.com>
References: <20260916-hugetlb-subpool-always-track-used-v3-0-38aae9b5ccdd@google.com> <20260916-hugetlb-subpool-always-track-used-v3-3-38aae9b5ccdd@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7C3B9180006
X-Stat-Signature: wtmhgzgqgo9k4o37me3ghz5bo3ktfzbf
X-Rspam-User: 
X-HE-Tag: 1790528690-294244
X-HE-Meta: U2FsdGVkX18udO5CyBBSbG/IaGY+VNtTh/PGzDdpfWdSVT5j+hnaqTQxQ1J7G7x8oEDtvIyH1Mu8CLvvsstJM8dvN9Au+epmz24j39H8zzvS4IgpsEau7P/q2DlSswpIJvb+Mt1Ck0SMkm5KhBUgisrCQRjwi+0R6T5fUWrEv6wlM7dqR+BOFCDWbzesLw7pD7uaDP368bAB7q7j2hMkxVZ4XZycNOAp9MzeeUxj+RlsYBKHcZVRQAvWNvk3a38qzr819v1Yu3wtuOAmjUaPu+50qFr5eNLwwq40bZcYmsnyTGnzlGLwFdIfwVpt1m1rjys1A1+9hK6gomvJpeqGVCh7BSI+i9YvVVVT834gDL0MxCwd5pwjQFy1gsl3/tAvGwMoJCfIUAPKBe7KZIQ+6OMvVLqoVH2IbzYuuV8ikIcqaR9ekdwXhHvt6wCDQfFXhM0+8rWeJouypJVnE5KM1QIcNQegRaAY+AhZbRncRwDijVZu88HUSd96zOa5hL/GLuc87Fd6EukYSteE9RWSNXogyRF+DbObObquHA4PpyLLEV9ABLPfJrT75B9mCDEFb1dwKvFMQqAU9WFri0bWZwrCBbgcJxNwsJuvaGODMBb+dB0wm9Y3dGJQJLJl1PBJrVLtdyUYKo8tSB+O63YYxaPoDoR9Bj2m8yoKDPPR65QzLgDUNoL4iJbzV1/BZaH5T9He7Q0QjJKAdxGvQftJOlKMDjPmcV0En2n389lGwaaxB4OLhRtXCTEkXwLhhPouU5u0ya+iehtxRFwo8dFR86rlIMXBeMBKkWuR5iy/UUdx90Xt767Sy7OhbnfthdUqY9SouV+0936+6xP7fSzimebTJPhnUdk9MuKRMlSXFIVxynpZw7Lx/iJrpPxs3QKwVVMwq65QoimrsVkI/loCzcwZt91mgpa6zp/2N6HNkfNfFHYl/IZuTeVtYQwe6Qw2p+4QXxofORw2ty1v8ge
 EGOHphFO
 MvT+L+AlxuO0A7GJWokDKZcYTLhSkWiHUvJdPw6GuubeuTuOP8mufX25yuH3SD91F8eFReJPCDQ5y4OApL6wVKHMQQ1+MyfW9iGnIZEsjxYXx/gHFuqWhzIMmaRitpnBryoO5aUowpdpxYDj9ahKisZcquzT2VvfdRL003AhJ+1m52OFKUjUPhcWxQjgXUUPscsd1xNAs7itBE4mMJqQ+lXWJIlMi5lhLxcZG4PpN1AArQ0uXrh7EJm9sT5FINK2CL7Wl8TElizQKSdhntugf5UE/OuF5UBsJ6E84Vi7IuZLjVxLJ5/DIfkPSL+YgHZUN8B03W5umnrzFDRsMu8QpJn5Sa5NFpPrWH+VvarNCCAqJji7AEnY+kk527/Mp9czcu7DHKLdbdJxyJQRl2PYrKXa3lsduHVL9WWqOJXQH46xBCIq7KjIPB56Qc4Q6sD/KaJrrfar7TCIcQPYi3BtiUyZIl58dG9Ih2bPlSGv8f8X27sfonqXcJ2siBDqwmAYsRHXh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 16 Sep 2026 16:39:03 -0700, Ackerley Tng wrote:
>  out_subpool_put:
> +	if (map_chg) {
> +		long gbl_resv_put = hugepage_subpool_put_pages(spool, 1);
> +
> +		hugetlb_acct_memory(h, gbl_resv_get - gbl_resv_put);
>  	}

I reproduced the same fallible-positive-adjustment problem in this
calculation.

The complete subpool put is locally correct, but it can expose capacity
which another operation consumes before this call tries to restore the
corresponding global reservation. A positive hugetlb_acct_memory() can
then fail with -ENOMEM, and its return value is ignored.

I tested the exact patch prefixes on v7.3-rc3 in x86-64 QEMU with 2 MiB
huge pages, at both one and four vCPUs. A default-off test hook enforced
this ordering:

1. A shared MAP_NORESERVE fault acquires one page from a four-page
   minimum subpool while the global pool has no spare capacity.
2. Folio allocation fails.
3. Before rollback, an existing reservation is released and a competing
   reservation consumes that newly available capacity.
4. The subpool put restores the local minimum state, but its required +1
   global correction fails with -ENOMEM.

Both CPU counts produced the same result:

  Source state  Cleanup result  After file removal / after unmount
  ------------  --------------  ---------------------------------
  v7.3-rc3      old cleanup     4 / 0
  patches 1-2   old local leak  3 / 3
  patches 1-3   +1, -ENOMEM     3 / ULONG_MAX
  patches 1-4   +1, -ENOMEM     3 / ULONG_MAX

The expected values are 4 after file removal and 0 after unmount. Patch 3
removes the local usage leak, but the failed positive correction replaces
it with globally unbacked subpool reservations and the unmount underflow.
Patch 4 does not cover this earlier allocation-failure path.

As in the reservation case, the base remains balanced in this controlled
interleaving. Patch 1 makes the path observable on the minimum-only mount,
and patch 3 changes the local leak into globally unbacked reservations.

As for 2/4, I think the subpool get must remain provisional until the
allocation commits or aborts.

A LLM agent helped me with the tests.

Thanks,
Karl

