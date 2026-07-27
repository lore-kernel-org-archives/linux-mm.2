Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18D0AC531F9
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 03:25:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCC236B007B; Sun, 26 Jul 2026 23:25:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7CA46B0088; Sun, 26 Jul 2026 23:25:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B92866B008A; Sun, 26 Jul 2026 23:25:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8EFF06B007B
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 23:25:26 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0957F1605A9
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 03:25:26 +0000 (UTC)
X-FDA: 85033116252.09.771913E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3C468180005
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 03:25:24 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=2SMuE6+j;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785122724;
	b=22TxPJcOoQDXnJc8nd4kUhp6AQs/ED42peEP54IDk9Gl9jtQzlCDnxCdA7emzW+ReCEFGK
	aXFXMs/wjI9jktMr5vmJ8aeWEK1xdgVat1Pq6Dx8ZJwfK8mtrQywrFPiNHCooEAF2bYycD
	NXLWzsVT3/9haxdQs1BI9XdU3kB9Keo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=2SMuE6+j;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785122724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XsGyYiFyMYFI9L2NS0y/ZZKusZC2V7j9ria54DgCTvg=;
	b=eIDEsRGMjAqqC+UsUJjXNfAm68yCH1XXHyqPzJgJIspD32GLghxnjlqqKQoGpr+c8kLA0P
	7lYsCk0Q1pePTDwbZYvy2x18yJBnkE4K9Xu+Rw/uT+mXtRLxUpEtpgDG1bDRsZCeO37t04
	WEwvBeTEMyUH7SCMTl578fpuA3TaFs0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3DC81600D8;
	Mon, 27 Jul 2026 03:25:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86B351F000E9;
	Mon, 27 Jul 2026 03:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785122723;
	bh=XsGyYiFyMYFI9L2NS0y/ZZKusZC2V7j9ria54DgCTvg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=2SMuE6+jtlUJGMjNlIL7V1BctnQiR7Uo9OTYyybI7QMnQbecBSJlenZWs/HudWknX
	 nGJuIjw6r2E3LHvdtZ0HVHUPAYLGiYj3dCcIJyav42g+1NKbHv5U5bFEeiZ569iI+1
	 LExXWNGYvAQViTisqtpUy8ZXghtC+sm1zRp6aiPU=
Date: Sun, 26 Jul 2026 20:25:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>, David Hildenbrand
 <david@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, Alexander
 Graf <graf@amazon.com>, Muchun Song <muchun.song@linux.dev>, Oscar Salvador
 <osalvador@suse.de>, Jason Miu <jasonmiu@google.com>, Jork Loeser
 <jloeser@linux.microsoft.com>, kexec@lists.infradead.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, Muchun Song
 <songmuchun@bytedance.com>
Subject: Re: [PATCH v4 16/21] mm/mm_init: simplify deferred_free_pages()
 migratetype init
Message-Id: <20260726202522.e55861cc87fc3e0c6d030e1f@linux-foundation.org>
In-Reply-To: <amXelr2DcRRyZDY4@kernel.org>
References: <20260725172133.4018491-1-pratyush@kernel.org>
	<20260725172133.4018491-17-pratyush@kernel.org>
	<amXelr2DcRRyZDY4@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3C468180005
X-Stat-Signature: 3ebq9iwo71a1aahe469gbso5aqwx76ha
X-Rspam-User: 
X-HE-Tag: 1785122724-811279
X-HE-Meta: U2FsdGVkX1/AANqOd5tf9tgmvzZKDhWT4Nf1HjgtaGAnUFT6T6kPToOhXv5X8310MQhtGkVl4ACQ8JDB70qvF+fzQYqgP9CSaNnFNlBPR7iDVtvKSU51gqkyKD9tEw10ir+JvOX875TTbZMYbPoZKYQRReJJSCIceZjAQbyiHMpXKqk7OgFK8fDU2/1BkmsbtgTsoj9gy6KeUjir1ZDEfBjVbIlVA0q/7+BRaSaH52loAtODu3V6yVaX7E0F4ePD6Xn4PUocs2zG5y7TLyZlQ4IyNK3DAff/0tVeSCLICg2+PQC/uzuHiUKz+ap+V4Q/BqlBrdk86IbNAMVzFJqR3pamKXVEi0QFYdYZ4P9gnQMPhKANNmmxlgfjQHaCJ6yjATuVX8si/eHAW1pkirOfgwtdwFIMaabRnBKMFOi6ux0I/EwH4Un1itBldnyCkxEAkZ4G5mCVRXRr4e1wrlfiGDuomZ+0k0ZP36ySFN7Qxtzi1X6hbJu+RqKSEiXJRDNHSTN1hrHT25ZgGznnmgREHz2WmASvn6RAGoPIZttqOrvWxK05yvq0uvmJYysCyDth9x1wepTUQpBnlZsp9HT4oGnqz3zfCXzzqVp1TgJjqM25Cu3cCl1sNpbOd+5n/dv3Wydwlx6VelEHvVRS0ZlFT9OqCCxwjk4VnXw92APr4JiUrgT/Ea4ea2FRkN4WSWZF3i0FUzDoLAY3VyAjCKKnlAzCPq13O+lPM8cyU4AiQUuJlY1MrIOpHKeirRDvZoQQ7BK1FKk+oIl6qh3dBPyXL7FZTRCdPtXbCb0K4qHCGwbO9Zldg/oI9QV2MolHpi2KyMOnePOCmR2nxQKolHWOJxks3qwyv3dQTT5xZdRF7PgqnWWCW7lDIOmMrBLXy5yMNSyDXWoL5nViIor6za7oNqh6FVjKg6f2yPWpp4Nky33a1OOUSO5aAYqiW+MrtjrM4BIiVWxTefPb+CJkQGL
 p4yl1TSS
 TSaGvLVsAValQBHj5kaC2INxFNqEK3IyHmsj+L5wz3urgr9ymCAywBMcuiLj85lXR7s22AEmUiPh370N9GMmyCwRY0onxUA2pQMd5MRxQaQI0ud/zYuHKPRM/ATIf33vzlB4SWZlCLctgLXXvk/1kl4gV/UMmAT9J1c362bOZFYATmV4bqPbJ5qHebAIH8ABniYGNNp7Hfv5Ie6j8Tcs62Qlasmgj1hqyAEqA92cSE0UghWY/5w78fhQdF6F4rAkgelOIubfxAQHAshohQTLtS3LsRGDUuHwZw+S0oYBu/ZParehPEHavubS9wwjWigf5n3MRDU3QGrLhHDDLYN6u04JD0A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 26 Jul 2026 13:16:54 +0300 Mike Rapoport <rppt@kernel.org> wrote:

> On Sat, Jul 25, 2026 at 07:21:16PM +0200, Pratyush Yadav wrote:
> > From: Muchun Song <songmuchun@bytedance.com>
> > 
> > deferred_free_pages() open-codes two loops to initialize the pageblock
> > migratetype for a range of pages.
> > 
> > Replace them with pageblock_migratetype_init_range() to remove the
> > duplication and make the code clearer (Note that deferred_free_pages() may
> > be called from atomic context).
> > 
> > Link: https://lore.kernel.org/20260612035903.2468601-6-songmuchun@bytedance.com
> > Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> > Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > Acked-by: Oscar Salvador <osalvador@suse.de>
> > Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
> > ---
> > 
> > Notes:
> >     This patch is taken from Muchun's series [0]. The patch as of today is
> >     in mm-unstable.
> 
> @Andrew,
> 
> It looks like it'll take some time for this patch to get into mm-stable so
> we can't base this work on a branch in the mm tree :(

I didn't know anyone was using mm-stable :(

Series is adequately reviewed and is near head-of-queue so I can move
it into mm-stable a few days hence if that helps?

> I'd like to expose the KHO scratch extension to linux-next ASAP so I'm
> inclined to take this patch as a part of this series and live for a while
> with a duplicated commit in linux-next. Once this patch would be in
> mm-stable we can rebase kho-scratch work on top of mm-stable and hopefully
> there will be enough time for it to live in linux-next so that Linus won't
> get angry at us :) 
> 
> How does that sound to you?

That's fine - let me know what you choose to do and I'll adapt to it.

An unknown (to me) is whether Muchun's series "mm: Refactor bootmem
gigantic hugepage allocation, v4" still works with this patch removed.  Everything
applies OK for what that's worth.

