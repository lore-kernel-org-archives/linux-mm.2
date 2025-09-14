Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90034CA0EE8
	for <linux-mm@archiver.kernel.org>; Sun, 14 Sep 2025 23:53:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F6B68E0002; Sun, 14 Sep 2025 19:53:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A76B8E0001; Sun, 14 Sep 2025 19:53:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BD3B8E0002; Sun, 14 Sep 2025 19:53:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 115528E0001
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 19:53:31 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 78F0F160377
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 23:53:30 +0000 (UTC)
X-FDA: 83889510180.29.7C409D9
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf01.hostedemail.com (Postfix) with ESMTP id 11F8F40008
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 23:53:27 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=AtRLT+ee
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757894008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tRf2yBTFB7K+YiWiR9r+uDpoUGy8yq8gE022o+wsars=;
	b=JFarRLFAwUha1Z+n+6kTVrg3Sw/v491lgc2Eq8Tt4C2qzlQhaGYbWDYhpMnkWmDtrT4Xxh
	9/+fT0gTXW73/RLM2y1+7qDHaHMMrsCvQA9x+FOZa6mwx/bvuARnXTjPoUJrKEeoO+OiWD
	3vknL+Xi37+0D2BaVRTMCYIAkhKTvTY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757894008; a=rsa-sha256;
	cv=none;
	b=Pg3fksYWqeD9UL1CMHV0RJPB+ZYr+UZkaxyVCgkyscQbFJNsUbGVYnzGenAAo/s41mZLFu
	fvRaZiyGbYhYgmS1sQm9zj3QbMWZDOkLvEwsalnClqsXp1mqPlyTF4mVIrhkH00QLWMEpe
	ne7KzguqBoqAWxG5NDU7n9AGLO782nQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=AtRLT+ee;
	spf=none (imf01.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=tRf2yBTFB7K+YiWiR9r+uDpoUGy8yq8gE022o+wsars=; b=AtRLT+eeKAnNWEJ1w8CDHYx1fJ
	r73RqXQ6HWPSiqvmK0TnPGyNtp2yUMV6/NmINqsQJqRCTFYp6AucduMheBjmk91cXKGXgaw97LeIe
	ultmQMah4pSZdxmAljomGoCLsJuIv47zCX50sWlEZtaIbTVs3wTxVx0pKlHpGXwc9DF0Zy88lrC6R
	E/KjYld41LYNM0ryxyGQkcgqU7+r9iudbhFtURFMmdjsTTOn4x97Xtu4ThyQjX+mcM7dJNe00Tda7
	Xo72BRO+F6T5gsxpnoyX2TSkBzAmI/7UTyFodrYDSh/+ewpuK9KlkKGXRr0kG49se01QUpURDPygt
	RNopwmVg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uxwX2-00000003BMz-0ufd;
	Sun, 14 Sep 2025 23:53:20 +0000
Date: Mon, 15 Sep 2025 00:53:20 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Barry Song <21cnbao@gmail.com>
Cc: Nicolas Geoffray <ngeoffray@google.com>,
	Lokesh Gidra <lokeshgidra@google.com>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Rik van Riel <riel@surriel.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
	Linux-MM <linux-mm@kvack.org>,
	Kalesh Singh <kaleshsingh@google.com>,
	SeongJae Park <sj@kernel.org>, Barry Song <v-songbaohua@oppo.com>,
	Peter Xu <peterx@redhat.com>
Subject: Re: [DISCUSSION] anon_vma root lock contention and per anon_vma lock
Message-ID: <aMdVcH7KCXBvLtFP@casper.infradead.org>
References: <CAGsJ_4x=YsQR=nNcHA-q=0vg0b7ok=81C_qQqKmoJ+BZ+HVduQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4x=YsQR=nNcHA-q=0vg0b7ok=81C_qQqKmoJ+BZ+HVduQ@mail.gmail.com>
X-Stat-Signature: iesq891uzkmzgj1twdaqt9m5z4wxp19h
X-Rspamd-Queue-Id: 11F8F40008
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757894007-384234
X-HE-Meta: U2FsdGVkX19FeGe7T7PlyoB4UQSUOCsJsV7PWibJQKloLxDnlHqfNkgakybpfCt4m5WRkE3/yEW6VR5dBz+y5y4TIVBh2yiZRzWHP0q2PHmpOKZS/IqOKAkxvOfCacWZH9Ct3qHUoXW0j7aAgQHl0CWIxUCK4EQN1jqacOxRvjqon0re7L6/31ZjaIbUm5TGsUo3wI6HqO54YA3XNMWVjbpdrMB0QQdQDyzv/v8D4ZLr6f56vKKzYWyfaBDCo7p7m3F0KqIQWbsVJ2hjoUXUakC+8EEZf1p7Fr3j7WeNTk3pL/5mXLIUcG7RCetwb0Vofq+e32zJ3el9VQUe0Rc7RFu926k8H0zexnS3cJ6jFczEbuAMLPT6Q5EZ46WsJ771+QORGCrRLFl9euBulXGiqK/e67Rx7Wzxlv3KrsYEwAXK/zRCZBz8txcxz5+S9vPpYYLeolyvpVKN7gnfKdvfDW9MWTisUbNBB7Nn1poMV8bcdwg0or6ZqBqV0FsV7oghjx5nN9tH2p5BZRPNsOdE3JnTHkewHDC1GJH2u6LRhMURjbCgKUj/OYTDXBlhlfaZcJb+tMCCh7ReRkpHFPS3y5FquDn1RsCvYpJ/xxqwSO0/acaUsg0q8Dt4bcWAEhhIkSyaIcsIHYIbx82UugxZazavW1+bOi97Z9d989HsPvrAdn3/H5xIvFMzqK2VT2+ip4y9n4UVk5gGw6W2AQlRZtLjLCR18GFubyjV2O78m02VUihylGl4s3PKvJtnk44cDUiR0iBzi0awKn+Vcz/LYGNp44T2FfY+A1n1EXP9dAtEQi3P1aHdXEaL3/0LZTLshxdO2szp6P1wKFvNQb8PoapMvBofdHydYRH9kx0zGw1uNYV7MGMb25vv2UMxcUT+stMQWk3kIMdBNXYSC0EcEIg3C7HUGmzsJdjgF+B3YkESGihTERF1WGEG1q1mibXdr7tt2oHaBCsOonFOvge
 myKyQXew
 zQuWlS9hfoPQcftapIyypGPLDtAqUDFK2h4bJRHyzwL41l2OwyRuQcOoV50A/v/GbF/B2hotjBjIyY/xjpozaUfVLA0SHJ7JAxg8MpfVQPaHnnuA9euLWFjEh/da6zh77FiwtyCRndHsxr3HJ3YQ6tDiV78p8D/mDiZ5/QIET/PTKqMbbbWGwtYwK4q1AkhR9uY/jbf/DtA5BIrlBufDP1eeL9w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 11, 2025 at 07:17:01PM +1200, Barry Song wrote:
> In the process tree, many processes may share anon_vma->root, even if
> they don’t share the anon_vma itself. This causes serious lock contention
> between memory reclamation (which calls folio_referenced and try_to_unmap)
> and other processes calling fork(), exit(), mprotect(), etc.
> 
> On Android, this issue becomes more severe since many processes are
> descendants of zygote.

I'm not nearly as familiar with anon_vma as, well, the rest of you
are.  As I understand this situation, usually after fork(), a process
calls exec() and the VMAs evaporate.  Android is different in that after
the zygotecalls fork(), there is no exec() and so the VMAs stay COW.

I wonder if we could fix this by adding a new syscall:

	mremap(addr, size, size, MREMAP_COW_NOW);

That would create a new VMA that contains the COWed pages from the
old VMA, but crucially no longer attached to the anon_vma root of
the zygote.  You wouldn't want to call this for every VMA, of course.
Just the ones which are likely to be fully COWed.

Maybe this isn't practical, but I thought it worth suggesting.

