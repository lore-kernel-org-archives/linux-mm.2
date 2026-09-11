Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56FCBC88E50
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 15:24:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1ED4F6B008A; Fri, 11 Sep 2026 11:24:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C5176B008C; Fri, 11 Sep 2026 11:24:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DD936B0092; Fri, 11 Sep 2026 11:24:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D16756B008A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:24:55 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6E2181A027C
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 15:24:55 +0000 (UTC)
X-FDA: 85201854150.26.D970B26
Received: from fout-a5-smtp.messagingengine.com (fout-a5-smtp.messagingengine.com [103.168.172.148])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6F04720007
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 15:24:53 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="X rTwOd0";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=UtGeVKxj;
	spf=pass (imf13.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.148 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789140293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HAUzE7enydkaOLoMLY2SEAq0TLztLqE8++ymmdkXwxM=;
	b=ZbN+6rishmpKZY1DczCWQH0TfS4yHyI8uWWhj6f7lDTfpqnG740b5R5qCi3k48Sx2aCXtb
	hO60F2vRjT/IAx7K8jZXP7836+oS0RpMIvePaz+i9LiuEGKEJtFoJEszB4YxSZuqjVkGaZ
	M807WYBOL1o7wg7XK9OzHnoTtSjsOvo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789140293;
	b=B2TvNYQHgvwQzKgQnXc9VcNXy0i2kuk8qq/06t+hnRty/y933iXpG5bPJeRUVkQaIedjrf
	wwvN7xWDTOWgC92YZ0GzKeIlf7cRNx6keriKd/Jsmuoot8dJGwPN8++Fpxd/XgMDMImLwl
	41+w1nwbghrgjE1RBVBxeSe76vsNUZY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="X rTwOd0";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=UtGeVKxj;
	spf=pass (imf13.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.148 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfout.phl.internal (Postfix) with ESMTP id E211FEC03A9;
	Fri, 11 Sep 2026 11:24:52 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Fri, 11 Sep 2026 11:24:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1789140292; x=
	1789226692; bh=HAUzE7enydkaOLoMLY2SEAq0TLztLqE8++ymmdkXwxM=; b=X
	rTwOd06S3cmlFUR/8CmFPLqHYPzH0GAdJErMbx1qtnsFZtyZwmaZ16fH449B98mD
	15P8/eGL7KJuMRrMR/bfsY/CKslGVhFsJaE4wZdEYyIEYtiWiP0BsuIxQOMgay3G
	TrTukiUaYJUmFsWxbb2JdPFYXKybguv9FVyRiNZhkFIO9Cg7hFkuYIrmQbz8FXAz
	8l4a7PN2ufOdCSHOA1A68egPhhNGIqVdJmWAz+K2ePao1Ghv5FgM+q0mqgSR6ZwZ
	T0igMD4zBgBzYJa3Ek5EEqtkTfjQ1wyGiT6qKcjdFAFLxB88rrC5lXDFFfshWGZC
	KxsHhDVhNCUQrSarRAb0A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1789140292; x=1789226692; bh=HAUzE7enydkaOLoMLY2SEAq0TLztLqE8++y
	mmdkXwxM=; b=UtGeVKxjsRWuhHiGsqL83O/bWnqXFZiookqn+h/qr5sn6yIfCIq
	mFnKsd/Mw5djcncr1LgNIKUVN0uaFk4Arrz42H2ukunshCMtUY/x6xHk5epirdGM
	RWFhBIlQFnU1ihIQY+xReR+FEbjkzkytJsX8nsmpMFq8T0oajgCT/XTc8n+1/Nm+
	LZIWuvf2lr6Uz+HoQn78C0UvOMjDcgtTq//Oemxk5ipvrhvH/M6e2JpRA29kkAvZ
	SmHK04KNSERPWwEXgzHIhP8WOpDVJkIxR1F5dZ2rAnuywhNudUYwOgPIatIgorBz
	27miCYqsdbmOvXDAbLsM2qov+2IQtUvP3LA==
X-ME-Sender: <xms:RB2kaixKMa73AXpse3t7nmu2tt5n2E63NMdjvV3AS2EIwrOIe0O8oA>
    <xme:RB2kapGuaMscCcaFKT2A-_lTqJU0iWJ8UvEW2HsnVofP_XfPO7wgRV5SBHq8JzNH2
    2M8r8hXPI2_bTL8iK-slAseWK__p3uQU-DRcM4nzA_tCP6zcrYZVKU>
X-ME-Received: <xmr:RB2kailmPCbBApO5xFPpYCgKFSEVBv90ncf2nwDIxH7lxbI5i9yvza-u8LQ>
X-ME-Proxy-Cause: dmFkZTF8LFgWtizom6IF8DNYZLn93DBEGoF0JIc/0HbvOUgORNJd3EKvjslq44ktpk5VHO
    qvTYPuoI9Sp6S9b04PH5PhJ1ShvFJJtaNvccolXPixjRd04BXGXL0IIJizgNYjbLTxoYr0
    XxiqsO9yNkn64vwtU07xFyJvRJWmK8gFguw3GYn3svneYKfYoiIgO1u79ummMhROnx0aJ/
    atJuv5FfKd6tapVpJTslwSTllXPEEyxNVeA1n/VouCcU0dekT7GnAj421eUGIOIXKtrTIb
    Q/0X6ZNM9xWzCNNzW4/ZsAUo6rM7fa7W4hlv1gfYqoztY4KnlggWKVQSrVr+XgJ+8NwdUY
    wh5u8rx1ouHoafEoKZ6okSNIJHZDqk5REg4D1Tx9Odwzo/nD6ASa5uyPhd/1qlrFUEntr1
    Jqka62hZnyauxqOwWN/hq2+GPhtZtpCgnhCGR0mECEDPwnVZkevKWH9vLQEgRqUHakSc2q
    7jdTZcrySlgCYbjKwL4ZLqtKFXfe+t2BETcIOJJEUP4GXAgWuqctpaNnp6s7EikcN6S3R2
    EHim1sNf+3XWHxE0X94uIGQQFxOfV+R6Dbsuu0hLzQgN2y4dmSIBlxKt3zDS/Qrj8wddLX
    bgpsj+O8qiVbF1kb6ZHU+M1JGBMtmr2VOVs6MDJxr6DqjJJlfXYPQ2+FZdjw
X-ME-Proxy: <xmx:RB2kaoENNFEFighu9SMs6OGDMyb8hLsiVyKfjMGR80nxbH-YIRgLEw>
    <xmx:RB2katwmx4tTo8TeZuf527MqE4GaWcyORcOzpqULTfdNm7oVNxEwfA>
    <xmx:RB2kapZ-Yxbnai99g1j_nbv1FIR9jlhmTSFz4YAPvCYfh9C-qs00Og>
    <xmx:RB2kagnGtG9mZ24eM8f-vTzbVzfoTedCRoW3O62um8T5DcPhGbvL_w>
    <xmx:RB2kavLBC_UqyhrL0wwWLxU0MNqZXIQt_nUXQwTvlmv2roNc2J4J7Hc1>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 11 Sep 2026 11:24:51 -0400 (EDT)
Date: Fri, 11 Sep 2026 16:24:51 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com, "Liam R . Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>
Subject: Re: [PATCH v2 09/12] mm/collapse: open-code collapse_single_pmd() in
 its two callers
Message-ID: <aqQaxyxQYD_1KHju@thinkstation>
References: <20260910120238.2529819-1-kirill@shutemov.name>
 <20260910120238.2529819-10-kirill@shutemov.name>
 <DLCKQ4T6VJZA.3KVN87GD21IBI@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DLCKQ4T6VJZA.3KVN87GD21IBI@nvidia.com>
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: p9xnyrobu7pg11tfauy5bbzgo5xaw9uw
X-Rspamd-Queue-Id: 6F04720007
X-HE-Tag: 1789140293-298577
X-HE-Meta: U2FsdGVkX19CjtcoA+L9hdfqpLTDBxIQjqd7kazu6MfgX9bnvDwbDJRjRWdAqGgt8Wn0ewNww/CAx3/QDOnK1vi96hNoYmqG2K2jb4noRUMEymShuts4G7Fb+TlvBxOCQwIJjnRqF8gGnwGNsZVJvpmOx1YiWEQcDmzvARzaP0L1nLpT7qMmM/pjs6hW0bFrHkwGuwPC0FxUT6IGHL2zSSmigqXc0ii+XCUKroRSPHWUPb8eoX5khTbiZ+dIFH3mssoJzQtCnQAwOfx5HxJGuCQMhNLS0/qr4fmjdR6sm7DB4vkHaiDPoXL75kc7zHps59Wx5Q/TDpkEH0XFpEakSzqSdLVq7x9irk9xO/FuT9ic0L+xCGW14yEE7XFS97Sh7oYuSMUb0ywWxi0sEFjOsQAaaQqMmp5NglRLdI+Kfo4b+jS1jP0wg0ZDc0ngp9hOSCn63Ny3g4MOE7RF33nM0D0OXcFDUKjtJTwyvy5DrNu0BHW9tYKEgki6PsfqwYVC1LUUpb9WFg2PUlwbAfHPCpfxldoYdzWtLVHd7x0NcJNNzNkOOFqCjjToVxGQ9hhVEj1FZ5vrgOMZ2sU0LTjse0566TSZx85/ov+DQCgP1xJFtiLwSvTCGswp/KCjDY1HDh9aPp3PnJBNZhcnkXiLPv2Qt8nXsWUTPZ3wErs9NexumsAkrELuzgRB+xyLzr/MdJ1ZZ0zZAp4N8L7bTi4E/DeCzMk66bqT2I8dWDEV7eV40DboZVgUKnv5nqT4XzM8TdBu1h8jLIh1IUjNatFKyR1o00s1MrHJghD9rWhwApTUGufHzB2KKol7nhnA3CwqH7YH4uJ6b7ENVpUDIQFvhlodnplguzztc+SHTGn4G54nkrLovrfllHjAkQrwzXgiqfJLXWYz99kXNNaVLRq2CreuiHkiulq5sthftqmOPrRsrLKj5eNs8jX65yRUz4SCfxNMqA3I5cI+vPxtIt9
 02+7V6CE
 mPXmx6X06MQrBIbE0vVpsFblEsvH5Z4t/4X3cR1HU4svhHkZXjAnoaAIC4oQ4OKg3zoKMfUDnVkPEZj+fN5iOQz4MO1Rm75f6EnFebT+aMvcyFMx4+Fh/td+sVydFChFfu6Rm/tPRWyGvQnnSSoipYxS2vN9dIBA2+3CvChNTI8PqwjNJOrztTraS88CSDdHXhI59SCfM+xfXn2QdAghshPPUdkY6wKZAnSFnlI2rDHbrMsp2WAACkwGKhV0q5ybt2uVjRjkC+3mRKxc4TTsID8AViL4Xplp79jGt3HHrRfkSq3X98zM7eYhKZTmMNxkMPCpq5DEuQP/PslbLt0/ARbLwJRrdFp+2JbCm5QzFpJ7BPOzf1WCTAZFBvBUu3In48b0fEnwem5lVvlTBGTHygaUqwyrAV+OHsG4u3IGUuxiGidaDAcSZkEsL318EU4v7pV0PjU4vy+VBJOQ5pz9d/VbokdviRfx1DphUm32PH11w4Kc4TLgjkI+S77EGGpK39BT21cejsR6Td7TwrOl17ZfDCTCoX2GsVOeO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 11, 2026 at 10:57:46AM -0400, Zi Yan wrote:
> On Thu Sep 10, 2026 at 8:02 AM EDT, Kiryl Shutsemau wrote:
> > From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> >
> > collapse_scan_pmd() and collapse_run_pmd() each have a clear locking
> > contract.  The scan is called with mmap_lock held for reading and returns
> > with it still held.  The collapse is called without it.
> >
> > collapse_single_pmd() kept that boundary inside itself.  It dropped the
> > lock on some paths and not others, and reported which by way of a bool its
> > callers had to carry along and then act on.
> >
> > Open-code it in the two callers.  Each scans under the lock it already
> > holds and, on SCAN_SUCCEED, gives the lock up before running the collapse.
> > khugepaged's lock_dropped and madvise_collapse()'s mmap_unlocked both go:
> > the code dropping the lock is now the code that wanted to know.
> >
> > khugepaged's walk carries on to the next table while the scan keeps
> > refusing, and ends once a collapse has taken the lock from under it.
> > madvise_collapse() re-finds its VMA after a collapse, which it did before,
> > and now uses a NULL vma to say that it has to.  It still reports the drop
> > to its own caller, from the line that does it.
> >
> > The lock is given up and taken again at the same points as before.  No
> > functional change.
> >
> > Assisted-by: LLM
> > Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> > ---
> >  mm/khugepaged.c | 102 +++++++++++++++++++++++-------------------------
> >  1 file changed, 49 insertions(+), 53 deletions(-)
> >
> 
> LGTM. Thanks.
> 
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> 
> One question:
> 
> What prevents us from doing:
> while () {
>     1. mmap_lock
>     2. scan_pmd
>     3. mmap_unlock, bail out if needed
>     4. run_pmd
> }
> 
> for both cases? It improves readability. What is the downside of
> dropping the lock during multiple scans?

The scan/run ratio.

Once memory is mostly huge nearly every scan refuses, and a refused
table is cheap: one pmd read for SCAN_PMD_MAPPED, one PTE walk under the
PTL otherwise.

In your version of the collapse loop, mmap lock/unlock plus VMA
revalidation would dominate the cost. It is not productive.

Note that scan in khugepaged is bounded by pages_to_scan so we would not
hog the lock.

> for madvise_collapse(), I see mmap_read_lock is held when it is called,
> so it can be dropped at the entry and the code makes sure it is held at
> the exit.

That makes every MADV_COLLAPSE report lock_dropped, including one on a
range that is already huge, which today never lets the lock go. The same
performance consideration as above.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

