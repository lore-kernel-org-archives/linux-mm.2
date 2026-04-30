Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5674BFF8873
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 12:35:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D9476B008A; Thu, 30 Apr 2026 08:35:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 889456B008C; Thu, 30 Apr 2026 08:35:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79EEB6B0092; Thu, 30 Apr 2026 08:35:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 695406B008A
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 08:35:47 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F1D3AA01D3
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 12:35:46 +0000 (UTC)
X-FDA: 84715168692.01.4E1D7BD
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9D04BC000E
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 12:35:44 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=iAUflMNT;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf22.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777552545;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z+Z3DKsnSFmL8ihuU1z6jpmoa/PGowkZGNbOeWbnqGA=;
	b=yqvU4OoHxdAetl7iCoAfPD7rTICPQIEdT88k2irFKQHdBNVnPnCqHNo0+CMqsqVW/GsVI6
	DAg/it+5PlnfXpO9KdviA0TJZlRZ4M0siSMaMx9toBk+QnUVx2mPfyAcrdB9ZVD1AyVksI
	qU+CzXTeLd//sB7nEoNozDRnHGw46kE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777552545; a=rsa-sha256;
	cv=none;
	b=hlhPmfnOKz2zbOXTL4bvEbaZZMbW7OFfizMy2dQK7nVkPraevb9j3CTx+4u7tmTW571zJu
	V6LZ467qFaGmLEKJ9DoJPQZ9xMax5+0jX1d4yhE83qh5PemKUVPl+y0cTRipeBLD9n00Cw
	XbZ7hFwF2vtqwHkPkoG9oeLm1Z3oD9M=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=iAUflMNT;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf22.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Z+Z3DKsnSFmL8ihuU1z6jpmoa/PGowkZGNbOeWbnqGA=; b=iAUflMNTY8s90bOygRPipE/x2+
	2rqGdbTRLii/gKwyDrwP3nkrR0VatKKYld/V/816iJ1P+tXhX+d+idNR+EHjQMboflVsiybW8W+j8
	eYWs7JCkiHvjY2IB2zf7TqoA45+x4aQ6qJmQlmCWvqYPr8NfFayhBn2Yo/Fe4ZPpdXhwYsAJOnz9D
	fjrOixede6cq1gwHChteZEiQiJMRusCYSEQAeQfmUhSpF81serK2xu7B77/VvMp8ZkRnZOjTGarSl
	f2YwbxhX7fGYNMGzMT5rb3gdo1ooWSq/7jwDHw+A2onKlKlIcG5HcwM0Ymw87xAmNi9iGAAb7Q4sY
	9LSfVJFQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wIQc7-00000007Dpy-0PSw;
	Thu, 30 Apr 2026 12:35:31 +0000
Date: Thu, 30 Apr 2026 13:35:30 +0100
From: Matthew Wilcox <willy@infradead.org>
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, david@kernel.org,
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, jack@suse.cz,
	pfalcato@suse.de, wanglian@kylinos.cn, chentao@kylinos.cn,
	lianux.mm@gmail.com, kunwu.chan@gmail.com, liyangouwen1@oppo.com,
	chrisl@kernel.org, kasong@tencent.com, shikemeng@huaweicloud.com,
	nphamcs@gmail.com, bhe@redhat.com, youngjun.park@lge.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev, linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v2 4/5] mm: Don't retry page fault if folio is uptodate
 during swap-in
Message-ID: <afNMkqwxC00OT134@casper.infradead.org>
References: <20260430040427.4672-1-baohua@kernel.org>
 <20260430040427.4672-5-baohua@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260430040427.4672-5-baohua@kernel.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9D04BC000E
X-Stat-Signature: 1yfgyfm6jjfywb8ok7c9p9fq5ccwypy9
X-Rspam-User: 
X-HE-Tag: 1777552544-411663
X-HE-Meta: U2FsdGVkX1+9Zkg9VZRi4Y1mnI9b+3VNVDVCwjx11AJQXCAouGYmtis+4fPG7vmtTfCJZ0qdjnIY3GO80EBMcbNC2quVShle/Z4dKrPFKIh8Cw9U6W0U5qwQ3UkBdald42PObs+Q8q3/fuTSJLguOAz6JeasHv5XVuq6KgDn9Pwg+dRtobfcUVLbCzO/Y2fZDPRlei7x3oNTTf5evfXjqrxeb+nmGgenuJuJgPNM7wdSUmmdebzs+/wBiwaQVl8t7TRRcXuFL0BgUMDf5SWkvJ5PHepQ+F0FVlbCPbfdQQvfOV5mTlgqqTSGnyQ/P/kbYQth8MFdlOTIkcUFr0f0vE0UCjwUHYtPkCpO7cwQqMgGKtzlsoiZfugfFW55M15EUiWQrNM4sZTiGuCa7l6YDtt5Dm9FxoUwBtXKW2PAHZfH3XEYaKwrQQFsNPzuI9VqdgpaPzcRBS22dU6ohNCjKyihQmgNVAXRrYLdVgCFEMmnKnjeZ3sdFO2mJI1cl2n3v80El/RsOK+zSpR+zMyGYiXfz8C2oSYalcylvaOHFWArSLMoWxIqiKmZCdqPkbSwkSYyA6jmdOmFhK87iOtmGxT99TreKJBkmj+lU9Dga57JIHI0PGIZDG91TyUr/vzOPjMmX+MkYRX+1NCPD+ilJOFXIDmgUbeaistSOBRUEbx04LOTjGsb77AV44Zb9JzpjccwvtyFHV//fKw0l8gYAIzGd0/ZKq+VFARk+WjYTUdgBWSVPB7VqQcRj8JDqXpexAtrl/8AlbBoEw5jOdbDkeoLHlMqB/cGuiKKaTYPDaEYAQLCq5AYkVyhe3ZJhL8iXaXB98FvG9cKJldv7dmajXchx6l4cG7PxoFzO4iipVP7JC2X3gz+kQ68IcQVWzwUmYydbz5GMpmyc7WmiD+r5RJ2lf+9oXaYnfCZeluzVTx94stGuUREhIXK4Vweys8y/wjjWmfcDVU0GIEXSYg
 00ftp8jE
 3Rl/N7pp/vwCw9VSw0aHEL9Gk0yPNNuzUMRoNnv86/PBDWET89CWGdx6/79f9l8IXQXQDa6XBDEae20rjjWv0TE++fw1/+mcbf0qQQq5Y1tbToSdIGmg9kVaikzMJpA7Pd/qJkMnPe/1diBEWPb3liXQRjlQjsZCcpxDF+KNQHxSyYX6MAFWe2xaDKjSufXtUUimES68h5PNbyBO2+ergLiAOI2U0K83MTUw1PYex1pvPX9lGXdoz7pI2VhSAwpbCy1HNi5I1lVrs7bEHMBsLSiyeVa+5avYPVosIxZt+Tb0sNcctyTL7PcoCRGgqan+GaSZgLYHNNoDQKEDmqVCyv0euxhbbstvPvh6G3OI4TmivXMnipRtu6pDYTg/dlsK0AD6v
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 30, 2026 at 12:04:26PM +0800, Barry Song (Xiaomi) wrote:
> If we are waiting for long I/O to complete, it makes sense to
> avoid holding locks for too long. However, if the folio is
> uptodate, we are likely only waiting for a concurrent PTE
> update to finish. Retrying the entire page fault seems
> excessive.

I think the idea is good, but the implementation is misplaced.
The check for folio_uptodate() should be inside folio_lock_or_retry()
rather than tampering with FAULT_FLAG_ALLOW_RETRY in its caller.

Similarly for your next patch.

> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---
>  mm/memory.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 0c740ca363cc..a2e4f2d87ec8 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4949,6 +4949,13 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>  	}
>  
>  	swapcache = folio;
> +	/*
> +	 * If the folio is uptodate, we are likely only waiting for
> +	 * another concurrent PTE mapping to complete, which should
> +	 * be brief. No need to drop the lock and retry the fault.
> +	 */
> +	if (folio_test_uptodate(folio))
> +		vmf->flags &= ~FAULT_FLAG_ALLOW_RETRY;
>  	ret |= folio_lock_or_retry(folio, vmf);
>  	if (ret & VM_FAULT_RETRY) {
>  		if (fault_flag_allow_retry_first(vmf->flags) &&
> -- 
> 2.39.3 (Apple Git-146)
> 
> 

