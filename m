Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E19DF606A329
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 18:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=gq6koHUB
Received: by kanga.kvack.org (Postfix)
	id 0161C6B00EF; Sun, 15 Nov 2026 13:59:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE1206B05B0; Sun, 15 Nov 2026 13:58:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAA0C6B05B1; Sun, 15 Nov 2026 13:58:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AF3806B00EF
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 13:58:59 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 36AA7C078A
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 18:58:59 +0000 (UTC)
X-FDA: 85438265598.05.DF1F35E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 683AD80005
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 18:58:57 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=gq6koHUB;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794769137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wUK9ySDibXwePzBB19zRNnvpbyBOvugzqKcXHyk3Hmo=;
	b=72WOWiyY0X++ztUoHUR7FXV2lyfw81xMseTPiLSih8codZtjvyIxHgUlmv5neWKWWIKe8p
	gLg1z0u+qfRvjWNOcBBQz39sy1Ypg0vDgFuTojOfnTqC8/Zd9rZGdKISRFwlGDypDyhAYz
	sb60HPxEYqtnoFU+FVkd0ZbCjiZrldk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794769137;
	b=VAsUfyUa5yE3xOluIvg7glqgoiujOg+tHYR7/LCKu8BVzzRmsjviRaQ5oWAgWXeO39PtBW
	lldcJy5W0+21ub8t9xvMGWs2JcYqxLbLlNzgmzNkCPFT5HO6xdNic6STnLkKdQ2x6JDVri
	sefalzwrwf/e6XtILesL5vAoNh9qH5s=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=gq6koHUB;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EC9AF60AA6;
	Sun, 15 Nov 2026 18:58:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CFF71F000C5;
	Sun, 15 Nov 2026 18:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794769136;
	bh=wUK9ySDibXwePzBB19zRNnvpbyBOvugzqKcXHyk3Hmo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=gq6koHUB3IjLxGRlZBiG/fn6vGTyAfGjFy8aawtV89CsSJr8XYsAigtbd8yNxIVhS
	 nk60mmIbdkSQGeqmhNAUM2ZzphtZX7spfvPQxZsnWW/YpSnV68Hxl+ZuV23+IKnDcF
	 d+oTZTkTbb9K4bHq6Bj1TrXN9Pjv9+NJwXpxovq8=
Date: Sun, 15 Nov 2026 10:58:55 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, Frank van der Linden
 <fvdl@google.com>, Ivy Lopez <skunkolee@gmail.com>, Lorenzo Stoakes
 <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Oscar Salvador <osalvador@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] mm/cma: simplify cma_declare_contiguous_multi()
Message-Id: <20261115105855.551620784977f951f37e729f@linux-foundation.org>
In-Reply-To: <20261115-cma-multi-v4-1-d159631171d5@kernel.org>
References: <20261115-cma-multi-v4-1-d159631171d5@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: kcsbm5rh35px9mfzme136ng1ym1cc59j
X-Rspam-User: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 683AD80005
X-HE-Tag: 1794769137-332550
X-HE-Meta: U2FsdGVkX1/Cjc8Ih4JzjxQ7xnjFp3RLpmO2OYBrNDZsGQf3Ac+wUgMwYGuM1A37TlRyu39QW+dY4NQ0kKr0OoyMNw1mZstOx/Ynlh0krql72T3xynA5VTwcDe9IAXK35WMdeQvrYmT/cPgoFPEDOIay8ODoep6ymKftjHbaS+3TjNWcJSfKRWlLIqXI02ty6/z75uVdgu4ywS20RnUzsIZAlpXeSYbGXcnlxRpUm20uxKEboTclm2CP8LJDeGA64L5BdCNmLO89XZO0TOTycAo9TaFPC0yUbTOBcRzmttXfZ9SvMGi2UA3zdBPGFFfDpvc8nX5K0GAKKi3VuME0ZRPnLill4jqr08w59KmlO+7tTW08ljbtvr8xDman4QY/AhwVZPcGWt99K0KrP4B696WcokdGtdoDvINsFIp7Ih4r+MjoWN4A0V1Uyb5MUxXAFgNn6nVleF1WEAt26UmNndab0cbIzxkFTOsUXMkYfllXypNXZuk+uS3T1ny3QgUwjmctD8pdrGq/Vso8ffB7CIepLbiYyxVOrna/e5v0vMmJtFHQ+KdRSjOTuroY3baTXBlohKzwXQNWiiHNaJAtzJiNsDD14L8svebtmP9PSKb9YuCVEk3+sn9iszAWoaDHaKiCAz1nuWGvrVZT6BHkIukcjj+qroD3LJVgPaPqMeY9QE8VweSFRKfmlp5gPAFojMu4XPfqueq1sX60OmyKiYyAszPR9aH+l6l9hL42CvbyxXgEfhUwju84hWrq/4v1iugiK6BKEJFDDnHaHmspBYBItv0XkOc5nM8cLB070gxXdawH340j6e1brwpfiKCctuSm7JXGheBSNitj2qzLOBfPoF1WkKwtNDI/Wvzy78C1QFcjLU08/syuNbzMf8zfNAecXivTtoXUTELELa/S5+wKmFuYkihy6F/NY/xddT1k59DUIHf/2lRRC1V/N41+2h+4YBA1Gyhn+Pe4nIQ
 Rn6xI5q/
 DkkIIMBbHqNeN8fd+WlajV8CyxKVLU/2w1pnGMWgMj9MZ5bqenLi7V0dF15vY70QpBXHdXtxFBGFBh1wI/na5yn8Uf5+VYB9q1wWRbCXqXvmaxSuR8WVoChhhXiWaNdiQF+jmNaxapvqT5KVTFM/a8u7IjGhyeDgSI45Q//TXfh7f87IXulqtSTfhfwQG7XnLJ/UBSataBbwwyBVNbWD40Cb5rc58QJSI2iIvsVm7V8D681h2YGw5HoicGEqxamDILmbFnZDitHLbCMzwIriuGLS9RguUVtCN0R7A0kW5ukjZsTSsglZDXIdVAGIVb8+wNNqm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, 15 Nov 2026 08:27:03 +0200 "Mike Rapoport (Microsoft)" <rppt@kernel.org> wrote:

> When cma_declare_contiguous_multi() cannot allocate a CMA area as a
> single range, it falls back to collecting a list of up to CMA_MAX_RANGES
> largest free ranges above 4G, reserves them in memblock and adds them to
> cma->ranges.
> 
> The list and subsequently cma->ranges are supposed to be sorted in the
> order of base addresses of the "allocated" ranges.
> 
> This implementation has two bugs:
> 
> * The allocation may fail even when there is enough free memory because
>   list_insert_sorted() sorts the list in the wrong order.
> 
>   When the list is full, the largest range is evicted rather than the
>   smallest, the final list is not sorted by address, and the smallest
>   ranges are used first.
> 
> * the function may report success while it reserved less memory than
>   requested because sizesum accounts for ranges that were skipped.
> 
> And overall it is a lot of list management and open coded range
> selection for no real gain.
> 
> Replace the current code with a loop that finds the largest free range
> above 4G, reserves as much of it as needed and repeats until the entire
> area is reserved or CMA_MAX_RANGES ranges are used.
> 
> After successful alocation sort the cma->ranges by their base address.
> 
> The new code scans free memory once for every range rather than once
> for all ranges, so it is slightly slower, but it is way simpler and more
> robust.

Updated, thanks.

> - silence smatch warning about SZ_4G on 32 bits
> - fix a type in a comment

delta:

--- a/mm/cma.c~mm-cma-simplify-cma_declare_contiguous_multi-v4
+++ a/mm/cma.c
@@ -485,12 +485,12 @@ static phys_addr_t __init cma_find_free_
 	phys_addr_t max = 0;
 	u64 i;
 
-	/* no point searching if the system can't addres above 4G */
+	/* no point searching if the system can't address above 4G */
 	if (!IS_ENABLED(CONFIG_PHYS_ADDR_T_64BIT))
 		return 0;
 
 	for_each_free_mem_range(i, nid, MEMBLOCK_NONE, &start, &end, NULL) {
-		if (start < SZ_4G)
+		if (!upper_32_bits(start))
 			continue;
 
 		start = ALIGN(start, align);
_


