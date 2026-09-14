Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1940C88E64
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 00:06:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B7456B0088; Sun, 13 Sep 2026 20:06:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68F966B008C; Sun, 13 Sep 2026 20:06:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A55D6B0092; Sun, 13 Sep 2026 20:06:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2F5E16B0088
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 20:06:21 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C68DA40CD4
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 00:06:19 +0000 (UTC)
X-FDA: 85210425678.13.6E104AE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0252F20002
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 00:06:17 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=2YxWVSJX;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789344378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Su0hEBl/tTccQuFuMZxbSxyFv5/u7rTwJgD0ngyxkSg=;
	b=filawPGClQQrWj1Pep2XI7IcC1vMWY5s6znfaLWKU3UXhJOvWcJ+JGuKVBjseimJIBi8M4
	vLjKGoKqYjKWMcNdy31OURpbBM0Lr7y8o61RXA/F14IUrku5aDCco3U8/a8MkhzDvHq+IH
	OMQbtR9kgxgZdYQqvN1+yaK4XRWF2Js=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789344378;
	b=NiSKQjLccFzo8fo6QfFoe092sn6brWFaGoq/7J9N52AGBKU0vFQsJfycVYuC/bhQP94hBv
	CDVUlbbu3evH5D/woPbcI89E6/Q8co8/H9sSfYx1r8xvDiMAijmDnLTRzSmZmm27F67WPq
	HZ3ztJ4ZPkVGUpoPdIZUO3jxZU8+qzU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=2YxWVSJX;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D131740C4E;
	Mon, 14 Sep 2026 00:06:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC8031F00893;
	Mon, 14 Sep 2026 00:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789344376;
	bh=Su0hEBl/tTccQuFuMZxbSxyFv5/u7rTwJgD0ngyxkSg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=2YxWVSJX8NhuiWELeDbfOUuu5obbl4dKht9GLFyCSfUz9F04D/TFWsa3zSQhLwzYF
	 IKoCvasLZA0NTdRJtQmuVJApSy+iH6JvpjS04cV2wNFs2axYNzJUcepA/qYKZTjF+C
	 tmQEx77XilPD0GPVcJ9krLROV0RJADLo2RuUOK1A=
Date: Sun, 13 Sep 2026 17:06:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ilya Gladyshev <ilya.gladyshev@linux.dev>
Cc: andrew+netdev@lunn.ch, apopple@nvidia.com, artem.kuzin@huawei.com,
 baolin.wang@linux.alibaba.com, david@kernel.org, Liam.Howlett@oracle.com,
 edumazet@google.com, harry.yoo@oracle.com, hramamurthy@google.com,
 ivgorbunov@me.com, joshwash@google.com, kirill@shutemov.name,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, mhocko@suse.com, muchun.song@linux.dev,
 pfalcato@suse.de, rppt@kernel.org, surenb@google.com,
 torvalds@linuxfoundation.org, vbabka@suse.cz, willy@infradead.org,
 yuzhao@google.com, ziy@nvidia.com
Subject: Re: [PATCH v6 0/3] mm: improve folio refcount scalability
Message-Id: <20260913170615.cd43348e579d8dde5d556fb8@linux-foundation.org>
In-Reply-To: <cover.1789239015.git.ilya.gladyshev@linux.dev>
References: <cover.1789239015.git.ilya.gladyshev@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0252F20002
X-Stat-Signature: 8w8d99krtcyw8jef8eb9fxc5a3ozb85b
X-Rspam-User: 
X-HE-Tag: 1789344377-88088
X-HE-Meta: U2FsdGVkX1+cyPH8N+5tmrf4rO3YEefhI4sar58baGXBfYWdn2dmg/acuiBahpgezqyuk1B2uL1MRo92+0hCOg/S86sarjU9dfkdP8rw2IZ0QHB9T+1jmhPLJvMHY60weX4c7yBWNM/lBKbUbVuUjX9ynM3Ceta7BPfgsSYwRQv4EK8f1PiMtMs73QGGYMJ7QWVtWKbK3FJWEnZ8BuDDD3WEuQhSmJeRbEVzCys++hsivy8xqI/ToQ2fV+4s8KJf72iMxMy8cpY1vXjysIwLoc0xq1Bn3pZJa+TdmAuCKWCJEUASLGdmT0G+N/57hS0qlwWeO4fnnCyx69UMqQHw2cBqFzXFSLZZwCiuVsCmwNwflKZibs+n2NtW/f1rF5tlpuTzmC+odakfmnuceq+F1eki9Dth4QDvLk50MiHrGiQht8wgsovJ1almw2bnCsylU9UpPeFoYoaFOY4Zxw3giFYCMLECzLcho3GxM1Dd2YlvstdBAs2YIliTbbQOydN3VzHjvSlPdVEgtwUnL75QhT/0l+oMxgCr4ZskWR0ddoqwuDrmAxlIKcDX02smumeymz8XEFvkTCGfbWvm1XTQJWdl7TpAyyZQD2pVdPR1e6c2zorftTj2E/1rdanIY2+Ylx5tYvpm6OMCM+DGvkK6Ge/KHzOn2ykUt9+miwNNXslKLHnrKdeWUUuIkqcmHIp0UN/Ud5iqXIORfNI6ztZJ+mf1TfO9Srxl7QcDYSvQFf2Q1ct0Q2iKpe4LM79/+pkr83rKRAa8Db0jI43C0Smxyu3PsC2prijw5o0rlbHgUwh3QLArgmqjx6QQUCZUH18Rh+rk24/lZeAdETH3p4coupDIkqBboSVYj51n+VYK2iDlv5RKddh6tYC3QI3m/BrsPw4xLwiE8XI6VCtltTANl2UV9UhwiDh9/7eSxFCGWBqGgHG7UkF/4GrmvRev6fQ3srcvbHoUlDombaytyx3
 a0gxGDMD
 m+1ijFnti583ZgNnarFYPjGpIt7eMNBw/Ew/tG0kvD0dmu5WbCxAgMUyuBT/u8tqD7FOUXFn0NTbMysLHQcstCk1nVXTCOkmAPYGODzuZekP//22qDmRDOCqVMDWiuFYFTmI/9vG3KTxX2ZrkCtR9Am3ELsRznCFY0TEALWXIP0TwP3ZHsLrhp93cebaemg5cH1i8qJ6+Uyog18LGFkC//kkM1DEiVmTdnif6Ts0WyGwdbcNL7LYiB9GF5T87j1F8rGseIhxLqfFf70Zmx8T1c4qhrmERhQ9LDXUe33u6awM23LkSm5LvtMiDT8tuvV8uSqVGKKXBAM1GpkfLf5GCpQzp+BRDdKsIM9cREK3I9100AqKMrOcTe/XTdrlaAMhfBct6C4FkPvCAOy/JIRtk2bafxOfHs9Gief29
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 12 Sep 2026 22:50:07 +0300 Ilya Gladyshev <ilya.gladyshev@linux.dev> wrote:

> From: Gladyshev Ilya <ilya.gladyshev@linux.dev>
> 
> Recap
> -----
> 
> This patchset addresses a scalability issue of a folio's add_unless() operation,
> noticeable during contended IO reads from the same page [folio_try_get()]. The
> main idea is to replace CAS loop with optimistic increment (and deal with
> failure later). This requires splitting refcount into counter and separate
> "dead/frozen" bit.
> 
> To allow for such modification, this patchset also slightly refactors page_ref
> API, consolidating all implementation logic inside mm headers. For more
> information, check individual commit messages. The original performance issue
> and previous attempts by other people can be found in [1][2].
> 
> Performance
> -----------
> 
> To my regret, I don't have any access to high-core CPUs that I can
> benchmark on, and a 12 vcpu laptop isn't really a scalability test. So,
> here I can only paste my previous measurements on Linux 6.15. To be fair,
> none of the related code paths really changed, so I don't expect any changes in the
> numbers here.

From a quick eyeballing, this patchset seems to provide performance
gains which are similar to Kiryl's ill-fated "mm/filemap: Implement
fast short reads" [2].  Is that accurate?

> [1]: https://lore.kernel.org/linux-mm/CAHk-=wj00-nGmXEkxY=-=Z_qP6kiGUziSFvxHJ9N-cLWry5zpA@mail.gmail.com/
> [2]: https://lore.kernel.org/linux-mm/20251017141536.577466-1-kirill@shutemov.name/
> [3]: https://lore.kernel.org/all/aqAIFV4nOGPbWiDS@thinkstation/


