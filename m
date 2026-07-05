Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06D1CC43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 22:27:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C16276B00AE; Sun,  5 Jul 2026 18:27:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA04E6B00B1; Sun,  5 Jul 2026 18:27:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8EF16B00B2; Sun,  5 Jul 2026 18:27:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 824E46B00AE
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 18:27:14 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 74B911678A5
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 22:27:12 +0000 (UTC)
X-FDA: 84956159904.30.0D8F199
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id A2FC440005
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 22:27:10 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=vWd9PH4+;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783290430;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jv2xcJUD95C+Cm3j0a8p9yFOX4F6reCnN2sLjCktK30=;
	b=Ue7JZwO+uRNZ844hs+o1EtjlsAr+s5mn9AVAZFLtdBJoCepCRyT4wdLQqN+knbWOzPL0rZ
	4NHl6rAcw6+1SUYsdqXZxWo/aedpVqgIkZMyA9IzicZLsujhfmSAyelD+0PrZpz9wbQKvG
	+rwdkO6KJuxiOt+ZvE4dJPftY3ICwZk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=vWd9PH4+;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783290430;
	b=VD7ZVro2Z7l0uyHsa0Mm6jJrdRgdZsp0WNfKLUJzeAKlGPdaDZiGtUFRXSAs9J6TUZS4cp
	Y9ENePuL0secKZl8HvVJBqa925ts2tvRlh+pMHtrigu/pIiBdrIq0pP1YJCP7QhR+Dijl3
	r167Fxaz2sCoEsSJtfzgZ/j73jzdPd8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7C2C142DB1;
	Sun,  5 Jul 2026 22:27:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CE231F000E9;
	Sun,  5 Jul 2026 22:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783290429;
	bh=Jv2xcJUD95C+Cm3j0a8p9yFOX4F6reCnN2sLjCktK30=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=vWd9PH4+zF/ek7rkQK7nPfLAYMQVfP5lqY+NM+kCTLWqo+X38fwCxKAyy0FnFyG1P
	 MiUegVKczEMU5b8yTm6ic0qG+vKHG1auoyMcR+HkEBJOqDBamYBDAP6k7kPNednXR2
	 obkSLcLVKAuZAsYFODXUXZM6LIA732tk25e5j3Lg=
Date: Sun, 5 Jul 2026 15:27:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hajime Tazaki <thehajime@gmail.com>
Cc: liam@infradead.org, ljs@kernel.org, vbabka@kernel.org, jannh@google.com,
 pfalcato@suse.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: nommu: point to the write iterator upon split_vma
Message-Id: <20260705152708.582fd8d87561f600da23c0a7@linux-foundation.org>
In-Reply-To: <20260702012546.665383-1-thehajime@gmail.com>
References: <20260702012546.665383-1-thehajime@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A2FC440005
X-Stat-Signature: tj6apg7hudu4c5yqdtqp6x4aodyfio1r
X-HE-Tag: 1783290430-30260
X-HE-Meta: U2FsdGVkX18e2VW2bbEdieFIeuId8/KS3TsqHqyvPnkuoGsoEXZ2E3hyxxQMPFm2Yrfm3vZQWX9nxHfnFgfGRs36c3EQ7whEUTfckWUO1RVtwYHKxjHbAGvushPDXGF1ArNC7vO5CBIT1V5BGOyIfASApVQs8TRwNr/ro5COoyhdtDlwSLC8f+p/l5WMAmvhL4+wUO6SHU1oM0LUVhLKPGaHwii36kJ+gQ6AxjfamlIHla1TfVeQRmtyblmuinXWc21HMwNYU+F5kqMsHJh2hkWDb4c2LI9VHwckCPgIpQnD4YkQ2Z9zFJrqjRDO2o9ITNjEONSU1Obluu0EZWTC6iZTrXTirEERPE0nUl7CVWaO8aHHCEaOKzNRdyRFM9/cZ26gNWoMGn6kgNAooN/zmvUIV/DsC+jUupC4ehRVMKLtG4Z7S5JsHiKODEOsWUMqbRtpv7zYA9lyXJl0fJEHxS3YxIzb7LuXk3QnP0M7shq6Dq7KvSV1G+euLEipLpNm2izhWEc+1WGlxxEoA+nMKYbDpfE3Kv+37xz8V0Gi7B8JEEgC7ICuo3QsW4T8e9AWhgtlUNejUciLaaj0XGMZnu3wM+PI6MBOt6twFQSp0Ze6GBZs4x/Q9cFPq5FB+SPJwOPrabWu7aosTXwjSdYtk283jgvZvVGU7wxhOfq7a0UZYs22UZwmcWuVsiOL56z9ggpl6l0Dial3g9xjiogtsOUUYaDnXMbXGKfYccIXnLUsITN1pPwUhaypR9+g+VwWKfZOYi8bO63lL27ptGwhr1LxJMYFEieYxMOb1uXFGI/0OvK29Zk34MLaTUJIRiAjRFc3MAFvcMBOdfK2UB3k3kxwpE0X9nRMNHs6/VNlB4SfhTn940L54JVx0Bm8oc87Zb0E0EJJQCdMT0OaFvuy2Wupl0DhWzlixB9RrepTND+2hmRqu2QjOAQ8hsP8l25mSZmeLpX+8vzI8X54irC
 5/iQz55v
 s8/+77x4D+0KQiF40JppgKRzoarD+pgIl5pQu2AUez1f/Nc3VRo/1aATIJqL8wARbiaSbYRH/Kxj2qgo2pGU5q2/ZWMjJK3xIrbTZMjS8kQ5ryE6mS/PviCVtU9nyQapbfc/sIYuGmdyBa027pTg+TGJrhRTz/S2e/+sn2sj5acEmrfHRYan40vXQ17u4cZfY9DujMaZEwWp0Cc9askn8npU3hnve/Ak9NS5jFaWnq/Nj9ffTF6sPnOUTcz0DKRw7bHtg+oBJ1Nu9fIruRaxLFwCZqul9Lxc5L0kewcOkOMcCvgMJuGl75RezEKshBD0wsSB3LlPDh7hw8il7c1jLiJ1N0iDtRlHqHABBezCPMgUx7HmIPaskRGkhGj8LPPa/spfP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  2 Jul 2026 10:25:46 +0900 Hajime Tazaki <thehajime@gmail.com> wrote:

> When users munmap(2) the partial region allocated by mmap, it might
> split the original region if necessary and shrink to the right size.
> At the begining of vmi_shrink_vma(), it clears the unused part but
> generates assetion when the shrink happenes after split_vma().
> 
> This commit fixes this issue by configuring the right pointer to the
> iterator at the end of split_vma().
> 
> This was detected with a LTP (Linux Test Project) test, which linked
> below, on the nommu UML environment (out-of-tree extension to UML).
> 
> Here is a minimal reproducible chunk of code for this issue:
> 
> 	void *addr;
> 	size_t pagesize = getpagesize();
> 
> 	addr = mmap(NULL, pagesize * 4, PROT_READ | PROT_WRITE,
> 		    MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
> 	munmap(addr + pagesize * 1, pagesize);
> 
> This is the console output with CONFIG_DEBUG_MAPLE_TREE=y.
> 
> nommu: WARN at __mas_set_range:791 (1)
> MAS: tree=0000000091c23b08 enode=0000000065057663
> (ma_active)
> Store Type:
> node_store
> [9/9] index=70af8000 last=ffffffffffffffff
>      min=0 max=ffffffffffffffff sheaf=0000000000000000, request 0
> depth=0, flags=0
> maple_tree(0000000091c23b08) flags 307, height 1 root 0000000083394c06
> 0-ffffffffffffffff: node 0000000010c90bd6 depth 0 type 1 parent
> 0000000050e1ddf8 contents: 0000000000000000 707A
> 7FFF 00000000eb0ac2b5 707AFFFF 0000000000000000 7093FFFF
> 0000000045ead616 7095FFFF 0000000000000000 7096CFFF 000
> 00000681c7151 7096FFFF 0000000000000000 70AF3FFF 000000006c78b9e9
> 70AF4FFF 000000001914ab0b 70AF7FFF 00000000000
> 00000 FFFFFFFFFFFFFFFF 0000000000000000 0 0000000000000000 0
> 0000000000000000 0 0000000000000000 0 0000000000000
> 000 0 00000000bca8be4f
>   0-707a7fff: 0000000000000000
>   707a8000-707affff: 00000000eb0ac2b5
>   707b0000-7093ffff: 0000000000000000
>   70940000-7095ffff: 0000000045ead616
>   70960000-7096cfff: 0000000000000000
>   7096d000-7096ffff: 00000000681c7151
>   70970000-70af3fff: 0000000000000000
>   70af4000-70af4fff: 000000006c78b9e9
>   70af5000-70af7fff: 000000001914ab0b
>   70af8000-ffffffffffffffff: 0000000000000000
> nommu: Pass: 796 Run:797

Thanks.  Unfortunately we aren't very diligent about the nommu code
(are we?).   Perhaps appropriately - clearly this code doesn't get used a
lot.

It appears that AI review has found another issue in there:
	https://sashiko.dev/#/patchset/20260702012546.665383-1-thehajime@gmail.com

> --- a/mm/nommu.c
> +++ b/mm/nommu.c
> @@ -1367,6 +1367,10 @@ static int split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
>  	setup_vma_to_mm(vma, mm);
>  	setup_vma_to_mm(new, mm);
>  	vma_iter_store_new(vmi, new);
> +
> +	/* vmi should point lower address */
> +	if (new_below)
> +		vma_next(vmi);
>  	mm->map_count++;
>  	return 0;

Lorenzo, others: do you have the time?  Thanks.

