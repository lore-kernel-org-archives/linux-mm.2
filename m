Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73E94C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 17:22:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43C476B008A; Mon, 29 Jun 2026 13:22:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41A756B0093; Mon, 29 Jun 2026 13:22:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32B5F6B0096; Mon, 29 Jun 2026 13:22:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0B3D66B008A
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:22:20 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9D57E1A01F4
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 17:22:19 +0000 (UTC)
X-FDA: 84933618798.21.7341D5E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8FF661C000E
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 17:22:17 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=uTo5qVX1;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782753738;
	b=P65Pv5feaJI8I5lBK/lp9YwsjgLAeiXgd3QvlKXMBZXwmhCt+zDTfu1+KretgoTa5o2lWd
	pzda9m5aitfgbatx8pSgZ2kmC4WraJl3QpoMchB2S/ihaaO6Jkp4v3lxjUdgYkLJLP5raJ
	taYikfTSZCYQ9NV/9mSQ8liZ3/pJJOs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782753738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=juWgsiwKrfmDYFjWzFD07h7xasT5wM0m/CbZLCSQTVE=;
	b=f2fuhzq5C2bk8apJVnEfZiZf9pnIEfcm0v7iJn2cfsT3dBfp/UZfzNFwhyWZViLkQq8eKQ
	l95s/sAQr9mu4lCMzNwSJ9GK2D12yzajjDSWfcmF8eXtsn2ddXJIYjjrBHEyLk4dUClgt9
	0qmudlL9uwQgpAXqlURAM1UaldL8Whs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=uTo5qVX1;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E18CF601EB;
	Mon, 29 Jun 2026 17:22:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2699C1F000E9;
	Mon, 29 Jun 2026 17:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782753736;
	bh=juWgsiwKrfmDYFjWzFD07h7xasT5wM0m/CbZLCSQTVE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=uTo5qVX1WCofU7ArQgIge3U5uPhkOafXY7LAqEvLoUorCsTnMWFkxpUZNTf8CHCZr
	 AeASxor7XbYPpI6VrMzqtE0MppRB7PPFVbH5MjKJ2vTBtq/2HgmS2d0vYeRlCftWN8
	 M4yhQnX7V544cg53/WuFnz9XZQ23NxJnaDdSzFfA=
Date: Mon, 29 Jun 2026 10:22:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>, Andreas Larsson
 <andreas@gaisler.com>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Jann Horn <jannh@google.com>, Peter Zijlstra
 <peterz@infradead.org>, "Oscar Salvador (SUSE)" <osalvador@kernel.org>,
 sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Subject: Re: [PATCH v2 2/3] mm: drop pte_clear_not_present_full()
Message-Id: <20260629102215.09605f0e9ef66c5f58fe0932@linux-foundation.org>
In-Reply-To: <20260629-clear_not_present_full_ptes-v2-2-96089871a1e7@kernel.org>
References: <20260629-clear_not_present_full_ptes-v2-0-96089871a1e7@kernel.org>
	<20260629-clear_not_present_full_ptes-v2-2-96089871a1e7@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: d3teaazaa3gjk93je5ddzst56umtd34z
X-Rspam-User: 
X-Rspamd-Queue-Id: 8FF661C000E
X-Rspamd-Server: rspam02
X-HE-Tag: 1782753737-849525
X-HE-Meta: U2FsdGVkX1/rTqTtoOULSPAryeIARpcRHoStpI4TO4X6s5mTdnWrIuyBYhJ1xw3QmGwqY2/qQc9DXy6wTVRSYIgIslvO15S5k6grH3R02wbcuXKU7D/hn2HKvUzcaoYoH2S9LRdVxy5WoiOKRjgcTl+FNVKfdhSFNtxKWc396w/tWS6Q6j4/cHfEaxMx20besuE/yOY1i2RDXrOEWK8OycMlamrrXFm9GCnvz5aclFAc7rM0YcFAIMpSQLT8NYilgiWPNqQtFq97pezo2JzJCrg+13IXFQ20cQ0pVIzwUMYQ8BTemKdnWTjJaruWEIrpVrdHerUkwdDJ9mZ1qqPY0VmTsJ2+4u5izt4rAEIWrSx1iX9snmyHaohxuZ4OGu61en1+s4WjmCiXxNE7VDhbNi9xIXJJ49nFv/kujrY78IBs6oP7P7JoMqGPk/BDmqi7bnZKekof292UmAQ9HAzcB+DKN+sKJ6af3ymHDleU6MuWqxLUGHW9oS+WpMcFpJ5JF66N4r76f3PtZ/WcwuwRany/COC3xdmW5cDg7SOpSO0j5SkxyMepJmCoBxMzClSroiDCCrpUjzmcAzQqvM3pk7DMWx9SJt8CHO6nePKEuXnHhcMTwgRRFyuuEk1ZHy4FcvYg1glyj7rQ/Xs6uh/j6sOQM4rppf3QFjHDICHFr1T38Sx7ZbKKzJhXKwwlLr7Ss5dtg+7UV6zexfMZ298ABNtBv3bX5TORMQ7c4n16Zw9h/1zw3AaE1X2NgOkhHk4R+vkCN9dJ2lD9RfrZqG9i57dZw1pLcwGDXfbKb0lWMvs0pNi/bBNtuoQJjmShnMxEzoN8XbkMZQ306SEhnzoUvBVKvh+96bfJn7XH5i+PT10B/7y33i4R3FYaVO+B+iw3xnwhGX91JukIgsnbmLfegG7IyZnCVcqicNPBhbQ/35GwwgBvFu73NmoNGrkCnTnQux7dILLeuoYwySTp3eB
 WpXSHiqa
 qkiwBzDQ5nNb3wC6wXOPrw0hXxTMmQKCOv7xzM4SVy7lnYLy9O1W/YiKWgfUeWdvp4hkMzJtfokB5dEbFKPQ9Br8DVcDGT027GA/Y0ushf6WbvybTa3wyI3Y1zcmD+ciM/iWDgE2zv/euU1d3AVM9hjmn7Lna/Pi3Mwi+Vh1OFDg/riR/sHTpsrZczYpce4Kvw1KeH41peVZ1QwlMdaG66ya/7D2t8uzWWVB8rAXxGLaZL7WHPREQJyThIGNbDzEaFAjAFlanKQdkFuX9OUfDeaXB6yRC67I+S+HSgwccJeQUuwHslFAdqY1uTmzqG/HFJgFC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 29 Jun 2026 15:49:48 +0200 "David Hildenbrand (Arm)" <david@kernel.org> wrote:

> In general, there is no good reason to do anything special when clearing
> non-present PTEs.
> 
> In theory, HW that does have to invalidate TLBs for non-present PTEs could
> benefit from a "full" parameter, but fortunately
> pte_clear_not_present_full() is not wired up anymore ... and there would
> have to be something very convincing for us to care about that to re-add
> it.
> 
> So, let's just use pte_clear() directly now. To avoid the compiler
> complaining on some configs about unused "addr" parameter, silence that
> here.

Wait, which configs do that?

> @@ -1022,8 +1007,10 @@ static inline void pte_clear_not_present_full(struct mm_struct *mm,
>  static inline void clear_not_present_full_ptes(struct mm_struct *mm,
>  		unsigned long addr, pte_t *ptep, unsigned int nr, int full)
>  {
> +	(void)addr;
> +

We heavily rely on this warning not happening.

eg, one of thousands:

static inline bool page_range_contiguous(const struct page *page,
		unsigned long nr_pages)
{
	return true;
}

So... what's happening here?

