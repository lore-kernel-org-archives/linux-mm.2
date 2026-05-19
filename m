Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F053CD4F3C
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 18:07:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DFC36B0088; Tue, 19 May 2026 14:07:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 169D66B008A; Tue, 19 May 2026 14:07:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0582E6B008C; Tue, 19 May 2026 14:07:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EAB6E6B0088
	for <linux-mm@kvack.org>; Tue, 19 May 2026 14:07:47 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 98295A0839
	for <linux-mm@kvack.org>; Tue, 19 May 2026 18:07:47 +0000 (UTC)
X-FDA: 84784952574.19.E2BC99A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id B8A5E1C0015
	for <linux-mm@kvack.org>; Tue, 19 May 2026 18:07:45 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=keoon7bO;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779214065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=olAZ3G5gXjb9k1A80b7WuJ8mWI7er/4Qy6X5OqPTTcA=;
	b=PBvCFVvghganM/tU0WMbmHRq7IHPJo6DvX9M8ua2dMp7RUctgrKjk7wd1xzeppzNF9qGwH
	p8bo2oTfzjND8EoGQlVC1pRPHawFKWpSQrNxmdJD1QNeDttnZ1WUnHq39/9opSc7BsyNuo
	IA3YFGLFyOh5giYI47hUb3k1VFdXBnQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=keoon7bO;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779214065; a=rsa-sha256;
	cv=none;
	b=Wgb/3w4O+LZdt370i1TQYzWRaf8y2IPN4fvon6Qt7myZINkgqjGRZuF4vCh4XeF86rqFUh
	z/x1yaYeS+vCkbIIltWQXrNHxw/soBjH2BXjnVFRwBx33m+bXo7tQziNKZ95KZk5nYnunU
	8EfHijENVJu6V75GhxLVwJBEFMWmo0Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C899D4351E;
	Tue, 19 May 2026 18:07:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70111C2BCB3;
	Tue, 19 May 2026 18:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779214064;
	bh=EBprb7fC4YSNArhVgEXUAFgMkedqEY6Zn3KOO5qDwbw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=keoon7bOOxG650zZmpx+H9v26eE/9e33VPOWkhWhW3M5nhWxOrtigoc06jth7DDB9
	 1Tfyo/Ed5OZUQ/RdXZLup8rxcQLncrJuCbTWWi+RMbFC5JrDvGThSvLpbBC4QFig8K
	 KRnPJXpuEfVRYd4kyldLEGASMqZVX1krsu/pqSzg=
Date: Tue, 19 May 2026 11:07:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: shivamkalra98@zohomail.in
Cc: Shivam Kalra via B4 Relay
 <devnull+shivamkalra98.zohomail.in@kernel.org>, Uladzislau Rezki
 <urezki@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Alice
 Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>
Subject: Re: [PATCH v14 0/5] mm/vmalloc: free unused pages on vrealloc()
 shrink
Message-Id: <20260519110743.50a2ccd2489a05be6e056703@linux-foundation.org>
In-Reply-To: <20260519-vmalloc-shrink-v14-0-70b96ee3e9c9@zohomail.in>
References: <20260519-vmalloc-shrink-v14-0-70b96ee3e9c9@zohomail.in>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B8A5E1C0015
X-Rspam-User: 
X-Stat-Signature: 7tkfjbgprcqc5j7ypx5j1n5o677jdjzc
X-HE-Tag: 1779214065-478892
X-HE-Meta: U2FsdGVkX1+AzRYVeaXt5oO5B9ZWi8xRt9G3h4J/owmZ+ygBOw4/ntUQJ7veP1Ri/v3cz8vmiFzKWEwwUkxhR2OmBs/WrkDM8BdJNcq64uxHD/5a/Wktzz2Nln575UeItqodswB5llxXmRzc9mRTaq16XDhejlhppAp6WjbQUbjr5/5YQ0FYQjtdjNfOObEVaxgJfFCetlhMNlGoFhhI3iR1E+j4Uz+a99dm3YfJ7g9eu/ZGDtVjvADyFBO/P0Xqqq2neOWQmbg1aO3XDT1yy0ENDkcQb+IlXVRYLQ5py3u7Q/DiWc3lCrqAOVaekr5yDgAEoRaLA/2OvOi/GxGH5vVhrNg5WPBQ+/9RGyIEtlY8kjNtp4kpcJ80Zr5k5vKfv9222Ns9a0r9xHmct80VR+q1kCxOQfsfEjq4CY2PKFlWg74cc18dD9q+UvKdcDsDWt6Mrjaa6BNmYmJZQzA8StHJquCqHR7xxBHAyKBZu32HfAk3K4YxhFhpJxtruzW4UK/UMoRZNf4MRFcGb2NEhY3Re+vAxHnVzyjQQ95N92ARqSvmwMOGqvpnbbcpUU1Eb2JGDc1ejaXTP2p3k9xgYyjdUuDa1Lr8qQ6zVMkeAWHy4u4Xvlq9qluXYsUH34p+3H3F4qIGQ5JMYNkcDyl9Kw5rkfWjzfKh+oIA4waslYquhxAPnUU6KB55NMecu5cWCwx7r7y6NotKI5QqsMsVNKPbW8vDWFMzk3puXVFsmzBhX2ZRaSKBSZf0NR9WzJz0DTPg3oPEMa6Mjie4c1JW2qK0tu6fRiTgaki0XoL68nKBatqtX/TJ1BjCnddmFqRXOhcWkvx9qmuzRCN/uqDEI4Duzyopnftd3247xykOkc2dQAAachItolBJ3RjiGSLursLu+jEeAbrtpv+QSOOMsFIaIajQ4fulDJZEJ+FbzFxevvruuJSx5HBpdhlaafv+t2WVC0l8TXPPrQTGC3J
 weZ6aDzk
 /qRlg0o9XadspuLuAHNHMgYQoLhTiN1dlR5RlRSY8uUIdzuGf+I+F6aVBhgXkrUBQRhRE7UOYe15Am6LmuEdXKeFHTKxigwfpKG5LhtXZz89BBmnyp7+JvRda+uOi703w5h7SYi8erlgw7SFpfvxUceHSV999oSLXC7grFfSYghYuhbzVGVtjCpj5/KskICzAUWJQuHQNorJUKC4Jnve+CNXFyLADYn+yc3kTtEc9D73tNFwMNcmGiQD3FMkD7wgEXuUzxswvzwQdLF22lKI1RLSdBMckHt7RiuCOJiBNPlpQaiSH+GS1ZR8eKR0q3bGr4TLEfH06hoNn3bfsGsmFJXHULxyP3kNXwGndtnNYR81GokYvPMeEe8k301gl95kxTDDMfLVPm9IYP0ndV+k8D+n7UEto1QbC/rd/LpJqHLyUzexz9AB1b3XNYg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 19 May 2026 17:42:13 +0530 Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org> wrote:

> This series implements the TODO in vrealloc() to unmap and free unused
> pages when shrinking across a page boundary.

Thanks, I'll add this to mm.git's mm-new branch for testing.  A few
days hence I'll hopefully move it into the mm-unstable branch for
linux-next exposure.

Sashiko is still saying things.  Please double-check that it's all been
dealt with and there's nothing new in there?

	https://sashiko.dev/#/patchset/20260519-vmalloc-shrink-v14-0-70b96ee3e9c9@zohomail.in

