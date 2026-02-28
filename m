Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FAEDFD0045
	for <linux-mm@archiver.kernel.org>; Sat, 28 Feb 2026 23:01:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 444B66B0005; Sat, 28 Feb 2026 18:01:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F2996B0089; Sat, 28 Feb 2026 18:01:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FE0D6B008A; Sat, 28 Feb 2026 18:01:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1FBEA6B0005
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 18:01:38 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9D8D0B1FCD
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 23:01:37 +0000 (UTC)
X-FDA: 84495389034.17.5AB31CB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id D89041A000B
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 23:01:35 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="Y9QqY/Um";
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772319696;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7gEfINnQGpWWCx/1jsEPKr4S/hzw8CPyggHI9yEcaLM=;
	b=sEOoNP1h6sM8/Dx8PaHNKTCSB41nIGOAUOUzvcoxwEvExiT7KkusbWP04ykGW9IawZ3oAK
	5/BQsGHWI2xs9NRmYO9nqhhdYcw1IQwxnDOnOqzMUWxm/+qHHEsVcAhriv2zrniQ5SNDPS
	B+Cg9KlsartB+0s4uR7dNtmW4WEEX8k=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="Y9QqY/Um";
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772319696; a=rsa-sha256;
	cv=none;
	b=VZ/dLWfTmbrhIM0pnFdJSsyOxcEPWoNY5o1JByoT6gWQKL3UD4aPLDl/nDYBK8Ql5KMf0B
	vnzjG/Vsoe/o4KiDnLUq11hdYbydqzPWhknkOW3sJ719TfyVzt16FRqI0lxG2+QiRn7Pn8
	yRfTJwDFSRJUkuU83xYZGjUUjEeRuaQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A3E0A44252;
	Sat, 28 Feb 2026 23:01:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3AF2C116D0;
	Sat, 28 Feb 2026 23:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772319694;
	bh=O9uOBnZ/lKOtmWpG8ozM2E0DAaC9mNV1xzrSoLZmrkY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Y9QqY/Umx9XtOjZ16O164ix2TSzEP3hGmrykgRAgox/0ibPBIvA9ydXrC9Yy2qv4z
	 fKFd8R6RWFSRWyHuDm3dSHPW9dpgJWbVvCl1frTIjiVjTxSPr+Bzy1R5C17i0zZJOw
	 iv1lhi9GBCZuxsNYUaFFulSdDc+61t9gjdWA+NuA=
Date: Sat, 28 Feb 2026 15:01:33 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>, Gladyshev Ilya
 <gladyshev.ilya1@h-partners.com>
Cc: Muchun Song <muchun.song@linux.dev>, David Hildenbrand
 <david@kernel.org>, Matthew Wilcox <willy@infradead.org>, Usama Arif
 <usamaarif642@gmail.com>, Frank van der Linden <fvdl@google.com>, Oscar
 Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>, Vlastimil
 Babka <vbabka@suse.cz>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi
 Yan <ziy@nvidia.com>, Baoquan He <bhe@redhat.com>, Michal Hocko
 <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet
 <corbet@lwn.net>, Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui
 <kernel@xen0n.name>, Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley
 <paul.walmsley@sifive.com>, Albert Ou <aou@eecs.berkeley.edu>, Alexandre
 Ghiti <alex@ghiti.fr>, kernel-team@meta.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org
Subject: Re: [PATCHv7 RESEND 00/17] mm: Eliminate fake head pages from
 vmemmap optimization
Message-Id: <20260228150133.67fd58ef1ae9e50ea3f32476@linux-foundation.org>
In-Reply-To: <20260227194302.274384-1-kas@kernel.org>
References: <20260227194302.274384-1-kas@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: D89041A000B
X-Rspamd-Server: rspam08
X-Stat-Signature: ks5ujx51kfcjpmdcqjugzyw7owib8nor
X-HE-Tag: 1772319695-858342
X-HE-Meta: U2FsdGVkX18gCk/85PtnBkwThqwT9zxVWA/dgBPZobhUEnWIZhp7YhCZ+zxU/Sc6rwbZDwYupyKWG+HGiAGCoaAR0EpO9ZP22pZqmQLoYnMvGIbDK9zzR/Jx/U83Q5PYotMkGqaPDkSJWQrsxjoQ0+QCbd214nWw8xrXWLYu+tvMD9MLyt568ih80cOmhCi8KGTgkqeac9L1tZFjWXrwUL8fJ08TI376S6iI0K+qDap7Gil1NgB3R1bfcvau0PlEdYAAKf2IPGAyX0H0xkKiSwmYWz6Iex6eb9VF6dYa/oPqO08pO1lDaJ4divL/nsuI66hHr+qNsZBGe4D4w1goWEI1GtLHgdUGnMNROkzd6F9PwnMQp/idVr/irs0Ngj59BlIrBt0Owep0Lu19unQ0y1h5IZJtOGLElNes0g1otuZYFxCmuDCOP7D3WyVZ5UNNMaO44wFOSyJ41vM2PKoadOspW5N7510vAnNOT67XmZwLYAf5n74raNWkp2JTSKYLXbfrkPkQpKvTooNIl2G44Kqvc1DOAzbkDEPlXM2ONOzUJGe99ySILgNupxuqpTJ09YYhrJQI8M3yAR2j6Bhn+6ThlVKcmOOnGLEsN9SeCIRsNil6zdzhaiM74R5DGQWp5BInJbRh0310K8aUEIDMx//vtin7Bc0p/THqPtLGdI4iCf9fkfQw+xmxlTcd5y2C97j+q7zpux0A9FWBc1CYd1M/T8RTdXwu536d20H7Ob8wQDygJjb8cvgn3rlq9LwT45Kr3IF+Y1mEHYC7XNZWkUqML+Q5mjInSY/6duWX9NHdI0SupFGGKkWV0m+eTUUaGIhM6Qv9O4lo02g1NakoSA53h8bLvsteScBMZxs5kec4GBs/F8EPJFTffuy+s9f6JyuaZtopOu8e/zuHXteDQPofn19vhHW71GbNU3AKfXJIkc548LgYe1LWHLiBdSyUMdDJHCJiP7FkRZsCHRf
 HHbOIa+1
 d3cu69VdAbtuA3OoPy0XL3H+ibSJQ5375vdxOty3w2RpCddwH9tYwK9cau7RX9GKj+aZvRIyJCH79Lxti2f5z9/mt3o1mRzT0OGkj0w0pyNiyLJgxkazvnQwwxCAWuNTwp4C9PMGWrO6O3rTuM14yPLJ0kcpNIRR/CkGWjOO6f+F/bInAEET5IE6IRXFXuPWSeOcG2PRW+R/kqPI9llmIFUB+v0ppNVQXxAWoBYPOEsFkZqLm2tStmTC+0tK8syNVxhCfJAS5289OYTZe6YsphaJ+VWprMvVvlpjzHoLW0mf5cRov8bgTbkJqZrY2N3RXM04Vir/Yu4oO1do=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 27 Feb 2026 19:42:38 +0000 "Kiryl Shutsemau (Meta)" <kas@kernel.org> wrote:

> This series removes "fake head pages" from the HugeTLB vmemmap
> optimization (HVO) by changing how tail pages encode their relationship
> to the head page.
> 
> It simplifies compound_head() and page_ref_add_unless(). Both are in the
> hot path.

This series is unaware of (and incompatible with) Gladyshev's "mm: make
ref_unless functions unless_zero only" cleanup
(https://lkml.kernel.org/r/20260206133328.426921-1-gladyshev.ilya1@h-partners.com).

Gladyshev, I'll drop that patch.  If you believe that similar changes
after Kiryl's series are desirable, please send them along, thanks.


