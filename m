Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A488C98328
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 03:38:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 436006B0088; Sun, 27 Sep 2026 23:38:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E6C36B008A; Sun, 27 Sep 2026 23:38:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 300706B008C; Sun, 27 Sep 2026 23:38:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 01BA06B0088
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 23:38:22 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 818EF40AEE
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 03:38:22 +0000 (UTC)
X-FDA: 85261763244.11.A106B03
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id BFAAB40002
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 03:38:20 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=M8jfexNR;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790566700;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rqd+kxmYgnmYy9//PxWDP0AuMpqwxlp40X1NB7XfM3U=;
	b=DySSRWNxdewi7VzhNqbgfuuXazb5KFyracMF5uakRWqGPB+HHaebd4ivrbvAYgFi5v+i+D
	1cJ6AwnMbZYT5MBXuX2MVynZkTfFHjWTgMgALnyY7Uv4NjVz8+SQIHhlGXa1gv3brvM4qF
	GwEfgh0CrCCiP3ovS+wHEAuWlhsa1uw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=M8jfexNR;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790566700;
	b=Rg5CphZWgDaxj3VB/JtpHJMVtR4sedwv8U0o6u1BTUY+R5IS/YirHNxbJtyNR2fLQlHXko
	6e7/JQC7lyx5CH8otQOF2b5UfPZ2Rnmg+/JT7mVMIsMUSXkitR5eE2q9ifJ4w+AS4ogxIp
	tUsKJ9yjlUnrrSaQkqC9RBh1w02Ikec=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B58FF406C1;
	Mon, 28 Sep 2026 03:38:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 388F51F000FF;
	Mon, 28 Sep 2026 03:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790566699;
	bh=Rqd+kxmYgnmYy9//PxWDP0AuMpqwxlp40X1NB7XfM3U=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=M8jfexNRiMmn5SqJpBK6o3SBKOT0HgRRk9cgWxXQbDn6pmXiFaiW2OMkxLHbUwS5d
	 AWY3tunpj+e3LTLNE6nOknZGSZu/zBOT4QQRUMfbIxV40WhmGPFoIfks2bG9gJwIco
	 iAgzaVlcT+BSLLgdxPzrtPNJcORV+bgYVOmdu5jY=
Date: Sun, 27 Sep 2026 20:38:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Martin Cracauer <cracauer@cons.org>
Cc: linux-mm@kvack.org, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, shuah@kernel.org, peterx@redhat.com,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: uffd-missing-wp: add GC related
 functionality test
Message-Id: <20260927203818.2f4b34b37f4a6e1685c3d142@linux-foundation.org>
In-Reply-To: <arneZ-KkRWUNI0Ho@cons.org>
References: <arneZ-KkRWUNI0Ho@cons.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BFAAB40002
X-Stat-Signature: kj89u6n8qs56kt6hfyheuhcntsjewwzb
X-HE-Tag: 1790566700-121054
X-HE-Meta: U2FsdGVkX18PYU29rhjZZ7MfU4zLTAkbelSvCd7Cq/adZHXUP4xb9cgDDak9PgAdRDp6fu4p97nBIey4GIw6Ts3Rs77wIeSSF8D95aOGfWrTlq8F6nnv0n/6SsBl/COeKdGsjDHARydj7VtYM5hRx8arDE1R3KDK1Jdi7X/pR6xmHI1WEW9tiQfZpKorrzdT5RjyyncaZ8/ggVycXtxChbHl2EAJyeB9ZJfmX+ZQFxNeU//pdSsCDN6/uh4Jv+uE4R0M/VsDrrWer03LeWcTJGWdnQgpK4D1ZJ1WoTWv0TYJyfFTiu4soWQpqqEgmDza6IAnjARJKk27zleJzl8co5OnCLz4Ge/jmu72EyvEwndoeDm+SdIJdtYYS655LS2vqCVXXu4few9PO+CX1PT/dz5HpKb7bJCdBdvbaHTSUKmSwHEB/3Y4wqbippao+hY/7NRzfJTEDyJSZ6IYVbqyRlGpckpr7vu2jNOyAI7EkcH93noUeDVCnYmx91Ax8TgGQ7WY0SOS9eJEmCwtMqzEwxLtmukuYMDe9KtUtAqYi1C7zo+sBy7AM1bXRCpMJNYASPUFhpdZ/XZRPXYiTPhGdqjwzxCcTnqrdRyourUELGqsY7V27AOeO2xZPiF/0guC3JJnXs5Cn1Sgi2UWpV4XdO9UZs4TOyPgGlA8s9642K0kA4h41NWebNqkZC+ORzQ5RoO+mjWFnYSnjFY/MdeAWdKzeDArCW6toZ0XJmj4L/vRbcR0n3ywPBRcwVyKPBUXcbGJYoxbZgTbuUpAQRCrrCdG7IkKX0kttroO4QJgA2AUDa1fZEW55bsuP7pmEM6Y3sRA3bsB0Wf2+nFrCnvSkg6AD0tqzLRbPZ5L23wWQB8cEt1pzasze/PndSDWLdj33eDWsJunigXyoPNIr5oaL03l8yTyeCOK7y0jzFNWSgipJaTT+OwsLMeqcG5CvJnAqS1L6RiDZUQShbBP/Mm
 c7AcQtxe
 fOsqQtyfagMEc9A1O0GeeJNb4fmWoCCa/EUXQijCAPJEgLaiLmjRp+VfNofKYhi83Tc0u1H4iMwTUYmqd5GGEwc2OH88TMH9aFaVIf2kRsikE5qCWtNa3PALBTwF7rQASZRc4/Ij1g/DNGcjD4T2/z/FOSSGXpGQ0VXB4dse61UVSxx+T6QEoK/UrEIPs0kYmE7RWlARuLpAiAf5c36TK6wd/Tmh7d2O0PfnNVTFl3aRgDlAMi1n4BBK6YcOZpJKSa5J6e/pyyux6xYjmc2nUjn2jasx+OQgRa7lGcap7EHdb4lGzf4z8tjwCUEMNTpqup8bt4I9wUf+4peGb4i5EmcipDcXZfHgnfjrVzG9D126phEn1gbohD5aMFF39EdQ9yWvhW1vIEtlcJGE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 27 Sep 2026 23:26:31 -0400 Martin Cracauer <cracauer@cons.org> wrote:

> Add a test that asserts that functionality needed for generational
> garbage collection works.  Namely to implement a write barrier using
> userfaultfd instead of using segmentation faults.  The planned target
> is the GC in SBCL.
> 
> The real GC will initially fill heap pages by using on-demand loading
> of pages from an image file, either via mmap(2) or using userfaultfd
> to decompress a page read from an image file made from individually
> compressed blocks.  This test doesn't do that so that it needs no disk
> I/O and no decompression library.  Instead, a fault will be filled by
> copying page content from prepared pages in the heap.

Thanks.  Sashiko asked a couple of things:
	https://sashiko.dev/#/patchset/arneZ-KkRWUNI0Ho@cons.org


