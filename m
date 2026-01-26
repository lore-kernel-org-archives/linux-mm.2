Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4ACB6D1950F
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 19:05:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B8356B0005; Mon, 26 Jan 2026 14:05:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 765BC6B0089; Mon, 26 Jan 2026 14:05:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 647356B008A; Mon, 26 Jan 2026 14:05:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 54F516B0005
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 14:05:55 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0FA3FD3B57
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 19:05:55 +0000 (UTC)
X-FDA: 84375044670.30.A0E4271
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3DF371C0013
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 19:05:53 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=DnHvLCpS;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769454353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IrviM5JEv15u9h1WFEBLoI3Ys6ROAu3GtjcwsmuxKQ0=;
	b=CbFqqc1MQn6BNq2/5FFv+FJJAigcHqON8N8P/6l2lGSCquGFBI5wReuBoAs7/BdJYpaJim
	X4Tv2dVjQStwWK16iewE3OUxZBjFPoBcs+TjEUaXQAhnwAah84M7cycdUxpTNNXKOItsyL
	aK8VxPg1QBd28ExQIBR1m1SEVYNneuI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=DnHvLCpS;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769454353; a=rsa-sha256;
	cv=none;
	b=tcPEPJKHtemb7LECdl9GLyeKsp9VDUb6tQLsSzaZ4ntRMuoFJUdwfU0Z7LfIPg63bW6tbC
	kpIm0SDL2FlRI752Y4sMk9h1VqTyp/e0F5SRFNcydMnTi5fiHvPf7WGgX8TFJ/sG+D5K1M
	J+AR5F/eQUFf1hQO5WbGAEID2PEwjE8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0818042DE3;
	Mon, 26 Jan 2026 19:05:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D80EC116C6;
	Mon, 26 Jan 2026 19:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769454351;
	bh=Qh0o6frWdN7mJ02mqItx1PK4gLJtn94sv0Eb3M1IpVg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=DnHvLCpSUmJ1NeZ/lqAsck/JGOrOhc99RsJ8vee97FxOXDShBzBieIEHn9D/AHByJ
	 O5Pn7WgIrD4GVrsvG2b01PUBk7TQIeCksLVBVe9p+nAnyY7JyWLxPYAb3yPtOC6RD6
	 8R18iPoBEbQ9d0sQgTstl8BkrooE8OeWeQlyV2Vk=
Date: Mon, 26 Jan 2026 11:05:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ankur Arora <ankur.a.arora@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
 david@kernel.org, bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
 mingo@redhat.com, mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
 tglx@linutronix.de, willy@infradead.org, raghavendra.kt@amd.com,
 chleroy@kernel.org, ioworker0@gmail.com, lizhe.67@bytedance.com,
 boris.ostrovsky@oracle.com, konrad.wilk@oracle.com, kernel test robot
 <lkp@intel.com>
Subject: Re: [PATCH] mm: folio_zero_user: open code range computation in
 folio_zero_user()
Message-Id: <20260126110550.0df8f68ea232a745c187b2a6@linux-foundation.org>
In-Reply-To: <20260126183212.2366596-1-ankur.a.arora@oracle.com>
References: <20260107072009.1615991-9-ankur.a.arora@oracle.com>
	<20260126183212.2366596-1-ankur.a.arora@oracle.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3DF371C0013
X-Stat-Signature: eu7iqyi5uihubsqrm5ww8hqexme9eaig
X-Rspam-User: 
X-HE-Tag: 1769454353-506350
X-HE-Meta: U2FsdGVkX18kkgJ4PZ41W2gc8AaFXd6RsNgtOfa1rb3ggWO/QWZrAUI0KA1/JGFmWyHjig/+XyHICJ71FsDbwPy+zyPjw7LxYJDz742zsm5SGYozt1s2DrOuhRoo6gDbQLQFTPDdTf7P2QgWTdNFLtV54m8lisw0yv9xnMBhK/B0ry2DpAtT/Rv+/Xt3akGG+lN089BB2s9QeY3RVH+IZm8L+G758UJkkjfZ2AytkRkUDYArTKXjSEpsQuEfBRfOVMQzbmo9Ll1YAlSxV8OyQDNaA6wq/zEX1FM4f3YWEaBSiAr+CYn58S+vUMrDgGnrE6BqF+GmLtQaXV/JFh/yQg5CxH9SDtc0tXMzRPJlw0Rc2iW5HbgB0C9ADte6PC4Yp+7sTPcaQA8wFSZga9FLpAlknAbSeEzs5kMgjoMF/MQi+FGaFrqMAJAiDmkrWxFD/JG9YYYthbJKkzi6tSt0F1xU1n5n2j8HTgwDxmkb0eIB+hAf+HpvvCTsoiTCgp2AMA3H5pS3YwgKhN0zt8wNuCWnS060lYgEYtz6jCeZ2kN8YdPIhmKDEif1oe70qu6tSB2Xz/qkMRZjk+azIzaaPFe4uI7OZ/NKrioXjbd8hnB8I998OkwFSlYYHky3qo25tHvlT+0UFhfqKVN4CAXqLHtyMVR7lGlpF9pzwrsEp4AOpsF6qSUZYKuGWmg0CuVIOeJ8qYsgzDDEyAcd9+7QVReiDgjlb/1v5P8JK5YUNv6QHoVBH60uqkGjQitFe9JqxkDqsxfQoisGTB/RfGh/KqiWbIMdTX655014CUQCLX5qIA7CJRiRE0d5Iidi79i91Jj88BYSwoxZTqUZJYJ1AcSYHxbrfO2tjqKU3FfS1vNftoDY2Ay2afJ/kicIsCcqCj9DW/eU0Tu7ihaMxcGdqeZqIKDuxJbU3JCaV/M+MTdfyN1lkRmwWXVeJk3KuAUXq6ROeZJJzvkrBd+xNYM
 JpRAFPDv
 6LiKRvOax++Uy3ZzRfj5DTTml3U9mvt8tdpAEtwW7nk/oeP/Y5XBfZ5jIriUDEwzD6a94kHpEOLX8AvkiRMudLGX0HDDTghgqsDe9nMmGmaGpo2ucAlOU/9xBbNq38F5Fg+Uq3aP1H3+GvqRYFnc4tmAoRUNUupA7kGXZO30h9DTavQVooU7BDi3kQse/pN0LaJtu9JvAhgYPxWNra1YV4PUpyxE4tWTcwPws5X0uUrlrOeJ7WYiUTVyv21qmYHrtW3bzp0gf7pIub8QrKjkJv2uDSaQY45Fewr5YVaiFq8r36TI8UyLQMX6GoU95VkFgC/JN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 26 Jan 2026 10:32:12 -0800 Ankur Arora <ankur.a.arora@oracle.com> wrote:

> riscv64-gcc-linux-gnu (v8.5) reports a compile time assert in:
> 
>    r[2] = DEFINE_RANGE(clamp_t(s64, fault_idx - radius, pg.start, pg.end),
>  		       clamp_t(s64, fault_idx + radius, pg.start, pg.end));
> 
> where it decides that pg.start > pg.end in:
>   clamp_t(s64, fault_idx + radius, pg.start, pg.end));
> 
> where pg comes from:
>   const struct range pg = DEFINE_RANGE(0, folio_nr_pages(folio) - 1);
> 
> That does not seem like it could be true. Even for pg.start == pg.end,
> we would need folio_test_large() to evaluate to false at compile time:
> 
>   static inline unsigned long folio_nr_pages(const struct folio *folio)
>   {
> 	if (!folio_test_large(folio))
> 		return 1;
> 	return folio_large_nr_pages(folio);
>   }
> 
> Workaround by open coding the range computation. Also, simplify the type
> declarations for the relevant variables.

Thanks.  It's a shame.

gcc-8.50 is five years old.  Documentation/Changes says we support 8.1.

> I'm not certain about linux-next rebasing protocol, but I'm guessing
> this patch will be squashed in patch-8 ("mm: folio_zero_user: cache
> neighbouring pages").

If the base patch was in mm-unstable then I'd squash.  But it is now in
the allegedly non-rebasing mm-stable so I'll queue this into
mm-unstable->mm-stable as a separate thing, with

Fixes: 93552c9a3350 ("mm: folio_zero_user: cache neighbouring pages")

So there will be a bisection hole for riscv people who use an ancient
compiler, shrug.

>  mm/memory.c | 23 +++++++++++------------
>  1 file changed, 11 insertions(+), 12 deletions(-)

We could of course revert this when we're able to confirm that the
currently-supported gcc versions all handle it OK.


