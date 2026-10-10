Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2ACB4CA9EC5
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 23:12:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9DFE6B0088; Sat, 10 Oct 2026 19:12:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4F126B008A; Sat, 10 Oct 2026 19:12:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3DD06B008C; Sat, 10 Oct 2026 19:12:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A7CFD6B0088
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 19:12:13 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 41FA216059B
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 23:12:13 +0000 (UTC)
X-FDA: 85308266946.17.FD1C7CE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 628B020004
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 23:12:11 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=zcqw9uEA;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791673931;
	b=2RROcJvNvA2PBD+IvYYfwSYWx1ky1gMCo0eOW50pcfeLZR2MH75g0bwLidwQlz9hkn0ojL
	byYfUiI2hXacyg7UndxUKJ4UEyS+wY3lWVH/ILyO0JpjnTzz96yqB8FJzRYJHhJBLcuL7N
	Pzc88VKC5mZdpZTdbJhEO5YMeFjXym4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=zcqw9uEA;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791673931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QxX0uL7E6cENEk/lCmgjLZU49inEjO28XJafyT3VAs0=;
	b=awaMx+h9nmtVcgC692IpEhw8b2n4Wto7gW7RLDM/X6P5AjtoZYURASIQl2Af6RsmedgFrj
	TT9lSo95PegI8Sl+T4kbkqr5OZSMlFSeYxl4+sOkOFpUiJgQw/HT6BKMK9FnvGDTtQbEBG
	Yfzto5+I++urUk6ssU0Dkaz1a+Eeg18=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2C2BD4143C;
	Sat, 10 Oct 2026 23:12:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B00B21F000FF;
	Sat, 10 Oct 2026 23:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791673930;
	bh=QxX0uL7E6cENEk/lCmgjLZU49inEjO28XJafyT3VAs0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=zcqw9uEA6nQigJgyrAdSz0qlDIkQEuoABR1ELlELzzXwL/X2WGZVrzULpe4niUTE9
	 WowmIHsejc6rOKkAyTX6elKvM9O0uCxqH3jIvk+4OhriKvZ+GcheaI3iBUuIotOnxz
	 zntiVdEngKjLv4kkpUxHjkEOjUCm7mqa2g95RRbA=
Date: Sat, 10 Oct 2026 16:12:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <yi1.lai@intel.com>
Cc: Yury Norov <ynorov@nvidia.com>, oe-lkp@lists.linux.dev, lkp@intel.com,
 "Liam R. Howlett" <liam@infradead.org>, Alice Ryhl <aliceryhl@google.com>,
 Andrew Ballance <andrewjballance@gmail.com>, Matthew Wilcox
 <willy@infradead.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, "Qi Zheng"
 <zhengqi.arch@bytedance.com>
Subject: Re: [linux-next:master] [lib]  6b23a67486:
 WARNING:possible_circular_locking_dependency_detected
Message-Id: <20261010161209.a2c3dab9cb05dd0d4b9b18a0@linux-foundation.org>
In-Reply-To: <202610101009.240d59d9-lkp@intel.com>
References: <202610101009.240d59d9-lkp@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: tudxngfmptzma171fkjwgj95z6o1urz6
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 628B020004
X-HE-Tag: 1791673931-909809
X-HE-Meta: U2FsdGVkX19XisPc5tlu51Snv04aDgNaFiO+Jtu7B6VM0NYxdBg8TD1z/Q/CIuOhx7n1HRYdWsKDgYNy32A5nWcJnCqIgOvstHYeMCU6B8JC/tWDbZvXTfAKnAOW0b2EjlqnRqajlCFGoHc3kb6zjqGi+jA4D7hMgf8ur9E4whaCU/cO2xdjrJcJ819xfQrFYhFnwzz0UOpOXfInL6AjHIlx+/bOVriTRy6iZr96vfUamiEkoWPUjYVcVupHTeduYq+KsTHDf6fGgPlvaBkCcOblx2p6X2dUa8EOX5XObxfiyHaWhJFYlgf6TJ0MibP2WWIWee/MyMi0qCl3lZLCxDqOae1arwYBUfRBBt/gzxR/Dg7PW/YkZ1EojOYHYj/tgzn2O5vm1sH3fWXnbMckXjhwSfpXDnxx419XDXLjrQvO2HPA6mESPVMuZJmLPyYOQ4FJ878s4vlf1KYvpQNgsM75kyl0rgTpXGtBCUmFxmBW4u+6phcQ2SsX0b/LlgoziTkbJsHxiEU6rz6c2vshzWoMyVOaGq3nlBg9tPkRdfZo1ptcnSrSYGPBbXitYsfdCwwddqctUVsPdm575Rgr9oeAIrO98n8I9X+/2gW+sVJKpkrjX4ZxDkIBf9zKzk/tJXLd0rd4VsCEW/EOTA1meB4GEM0kgbdlmc7hyeK3M95B0bc5C4zqINICzZjALcR2KwSMnJ2PNqbmwTdzn/4kht6yKQxHABr1+374K1TkBShG3TKzzejc8muj7k/ezqAOBYxXAzIGiy7Vhxzt0LUVPZnvk8YFKaHAB6fPGnmUKijnA6VWt5Cza+CB8xzN21AiovGD2PCREL22bhBrTghQe0XrP0bliAAqKAaNsV1k6+sN8H0FfLNSny1EbrFIkqL8/GXJOzMdb+DpOFhCZQK7nGSOexDcQTeVKwXcabmK/XAxCr1v6IK+A4zfJyXe5xF947ddC/Ii9mnNmQkJn5R
 rZRgFYiD
 dtPLcuXHGHZ4Q7OsNx97/Ao/CBeYboeMYGc8I/Bju5WtyJt40CDC8aDRNat9Ir+np0yd7nQXr1xOEJQwpGoMwXNLIHFnMZkniRnoFQ2aIDRjCTDmzY5WUNRnoC8IM3rstDjSnJ2zpvBHZRlrjqiVg4DMPtBdBt6pS4V41dnoqnO5TjeF+5OSJuwlAFW1Cw1qWFG6MI/KNf+61u6ICY50P1FxJqRWvUi7ppvnqup/U9/Qv0NQ4SFIPPEgA9E4JC1vMjB4cD8jH5YcqAzXYgfa+QGOf9rsio2+lWpAVOS4eGucziNTW50a0cvklBtpz45dpJvVCIfWR8YvtLpudAsOZkuYBbw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 10 Oct 2026 16:56:22 +0800 kernel test robot <yi1.lai@intel.com> wrote:

> Hello,
> 
> kernel test robot noticed "WARNING:possible_circular_locking_dependency_detected" on:
> 
> commit: 6b23a6748698a7cbda7d18a3a28e59be63254571 ("lib: fix lock initialization in region allocation benchmark") https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master
> 
> [test failed on linux-next/master aac26bee2287c88af5be5a5ff96d783b19a28790]

#syz dupe:  [linux-next:master] [mm]  b9b1861d4f: WARNING:possible_circular_locking_dependency_detected


