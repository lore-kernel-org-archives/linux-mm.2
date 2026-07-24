Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A57F9C531D0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 00:15:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DC386B008A; Thu, 23 Jul 2026 20:15:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58CBF6B008C; Thu, 23 Jul 2026 20:15:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C9F66B0092; Thu, 23 Jul 2026 20:15:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1A8CA6B008A
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 20:15:22 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 27F1080248
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 00:15:20 +0000 (UTC)
X-FDA: 85021750800.13.07DFC5D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id EB76E180005
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 00:15:17 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=QZDSnRYo;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784852118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y5aYK3g7NYOnUMQLXgxW5eDWWXLVLMQ0qcKu8Hb6xp0=;
	b=ahJ5xjJm9qBoXbyoyUL6rqX7yuvt9a8Ha/2pE42UoJUvgH2KKxw6CfBfjIMLfkUAGvCcEE
	TaAvP9IZxOdV6sq89peIXOwJDe4Ot1Z4TJxRjqYz2Ig2XBHzbXS89e3i7Ps9R82SuW6Nzo
	ljg6jw2bQ3EUkifMd1FN4DWD0NLEJ4Q=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=QZDSnRYo;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784852118;
	b=8DVhA6VvE86w7CHsKN6G8qHKHqSib2cGYXRXpEuXBvSYWh/BR586lTFxIWLKpcnv/a8hY/
	S3Bky8W/wCqbcMurZ2hQJCTCLNFM4pzHVC8EqWablNaZ5bizSPZw1W+oR25XszFOSD9Ekk
	KqRXeslZukyNXI5K3t27H/3Vd/T0yOM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1650B4329A;
	Fri, 24 Jul 2026 00:15:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F9171F000E9;
	Fri, 24 Jul 2026 00:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784852117;
	bh=Y5aYK3g7NYOnUMQLXgxW5eDWWXLVLMQ0qcKu8Hb6xp0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=QZDSnRYopXKAJMRYUmq5QTkslx6Kh9jmh3HWibjIAp+ME/RfgEQBlX9t25t75zs0k
	 0F2rSaC1mFzk4YlMjOSHAJ6mC1v/YxZ6J6YUTP/SNlMo7E9J/gWzbDhDwoeoSzEkn8
	 xwxRkzO1dZQfsB92x8fYnXHh6cOrQ8glU21g9Z+4=
Date: Thu, 23 Jul 2026 17:15:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Sean Christopherson <seanjc@google.com>, Yan Zhao
 <yan.y.zhao@intel.com>, pbonzini@redhat.com, David Hildenbrand
 <david@kernel.org>, Zi Yan <ziy@nvidia.com>, Matthew Brost
 <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim
 <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, Gregory Price
 <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, Alistair
 Popple <apopple@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Neha Gholkar <nehagholkar@gmail.com>,
 kvm@vger.kernel.org, rick.p.edgecombe@intel.com, vishal.l.verma@intel.com
Subject: Re: [PATCH] mm: mempolicy: fix automatic numa balancing for shmem
Message-Id: <20260723171515.b5ddbc59c5c36ad01ef8f7fb@linux-foundation.org>
In-Reply-To: <amIrDncrL4K-JRBO@cmpxchg.org>
References: <20260629163337.1264881-1-hannes@cmpxchg.org>
	<amGpEEqxoLq/Y7ZO@yzhao56-desk.sh.intel.com>
	<amIcXrS7nGX-adpG@google.com>
	<amIrDncrL4K-JRBO@cmpxchg.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EB76E180005
X-Rspam-User: 
X-Stat-Signature: f4mqqrzxyj7xism1inixka1c341yfpau
X-HE-Tag: 1784852117-237890
X-HE-Meta: U2FsdGVkX18GFCDVjxEdUqynP/5PNvgyqvHUKpt6ilcOOfugO9i+jDjeknT0OPtxNNQ6KWXQKVFcqL5q0vwMXIhX6kF9yjIW/BPiPPIDpDx5x8JDcPZX9Q8S0SnqgW3X81wBPRFwObFwGClce64Ox1lGMrA1r8ArQ2CTQiG9HhpVx3zVe1+OhPJpeWTDKkmLy0zXpx752S36Iw2O5CbNqaoFsi7EDGuuzHVGUNQO1MpuBgY0guCk7uvm6Xdkslw01b6LI1XzYv2I44usxDpg51qcWe+1yifdlWPRhvjW2S7n8fvlt1WGMZSX9fiaGck/799A3S6CD7GBjZHXFbmB1ss6cPqOi+iDMYphSPVvwraEfngxFvuHUtoSAxowQ54wmr20emM6bZLm23fXi/J+i5d6zVDBt+k1+i+ic8MaLnIhBVoWZaLegav2vzIcE1T9jSIsogP1+z/+jxDnecNayGb6h3ur2tune9nGAT6CYiJ6WErgoD6xuUSg2flxwuYA/Jva89jQS7j4h94rhrHjQXHDfD0sNSfS1nIafbZXAH7Xa7833waC041u0DadYBMxUBK9AksgvuAAFO5HDvIvqwRPTWCpvGtPYGe2IljvX6oXIQQsGV3KPYabTIK189YgkUH39y++UOLmdLY4QjZo3Ci+/Ig6wGd4Gd8ShvSP3oeC39FOPv/ukiDr1vbqTs1WkdJq9aE0VJOVBjw+TxJZ9yCVcHlfFgOSALV4Buil4tnaHeIBjEmX5qGOm+8wAKuhN/HEzsxx5XfQBJXKoqzx51Uh50YEKPAhzfctlbkAk3oh9q/D4hfLh1SOWP9SV5ruDlNKq4jeklB2YJS5tA/rPfMNwewRZO5JJlWfPbGpCTKxv1sj0cKidjQACY1aDknV42N9JcUo8q+bRyy4BTPocUcHQVB8SwgBGMnyMqtIDtkCt9Rtczag3VVrZ31pZkqZcZMgg+kLXvHZm1u6s4A
 V8LNBocp
 +FigZguToOPdx7qypKYgDEc4adWWcnaDoexmTbZm9TkLEK0A71RDg8cjSVpRzNXA/Kt0+C3VD5zb1rEVf2w7sEsnEydKi4puI1d/dFjQQY2QkmZm/QU/hKgXxidL9FauYDplZVm6GnFVCY8WJGeCIlZuiLUqzifXwoFEqcFi23/3f7Im2NuqUSC+qdSvzfwUvanec1yIYE/5Ft6mnCvFyQymK0cg7dUdfh6D4CpLQYRdC33ocgdetR5/mFJK8S8vNsbYYfMrqi0kYiKvM76PWlptDXvQ//1/h++F1DSDpM7Ymq/V67jokiTRidfKR9hkO7AhpxzDZ42hHdMx+IKnuPfrH6paPtMAUNKY74Md/8A2cSJxxZJKTo9AEDAU+srL9d0pQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 23 Jul 2026 10:54:06 -0400 Johannes Weiner <hannes@cmpxchg.org> wrote:

> > But in this case, IIUC, this change will "silently" enable NUMA balancing for
> > shmem-based KVM setups where it was previously disabled (albeit unintentionally).
> > 
> > I'm not fundamentally opposed to the change, but I do worry that downstream KVM
> > users could be in for a nasty surprise.

It is a bit concerning.

> This should be very visible in early kernel validation after an
> upgrade. VM hosts tend to not do much else, with VM memory dominating
> the host. You'd expect a significant uptick in numa_pte_updates,
> numa_hint_faults, and a change in per-node nr_shmem stats. And the
> patch subject makes it trivial to find in a commit delta scan.

Is there anything we can do to make this process less painful? 
Documentation of course, but what about detecting the situation and
emitting a once-off warning?

