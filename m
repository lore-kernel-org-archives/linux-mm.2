Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C44AFF8875
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 08:47:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8BD36B008A; Thu, 30 Apr 2026 04:47:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C62936B008C; Thu, 30 Apr 2026 04:47:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9FCF6B0092; Thu, 30 Apr 2026 04:47:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A9F286B008A
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 04:47:35 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 50048899ED
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 08:47:35 +0000 (UTC)
X-FDA: 84714593670.23.7F7A953
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 90241C000B
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 08:47:33 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GjXmME6C;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777538853;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BtW79/oyJePD7o37rgfXua7AmFk5Svkqar0YqqMFot0=;
	b=qrT0vbCge5lr2Wa7JNf5wju0O2JwLeE0kynYpbern74Ua94YFwsl1FPyydgprEHn1LJvLL
	RYlqH3WujAIVXX6E3lUEZUIfNHH1+QqoZBCJJUQYBiq5OIAekb/YupcKBsx+9Srt9fixML
	8gdx7uj71nzQYrm4Kz12X2El9851gco=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777538853; a=rsa-sha256;
	cv=none;
	b=HtRneB4h2717i876PqHIcyX3c7Rscl9y3HP3ujW7SVfwABrhrgTdFyvdmakh/744tk07KN
	1auFYbm5b0Y5yHYM8ulCBmV3tOiD0N4nis1w6DowG7NwLwdZ3OdyR+4KMbqcIqnSb9f3P8
	ukGdHt4Xtx2agqgV+X1OdWLlsQpwmZ8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GjXmME6C;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9CDB1402D7;
	Thu, 30 Apr 2026 08:47:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FE63C2BCB3;
	Thu, 30 Apr 2026 08:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777538852;
	bh=+mdvcOSWF5gSX8/SS4jOHv0gR5kynm/CnG64nFpYBcw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GjXmME6CSIRgacBuMMN5r5nVYWSPCwKcWiphP+FpjemD4RBqeQwwsZC6L6SnM54zF
	 o2fhKCb5XcgY+ijTjohxhmw/NlyNcA+2K4+fzgsqE6D2XxaWHLp7KFA5iHc/NrEArj
	 9CUAq/zxx4ADmEhcReZtjDc/ojG9YM/f3b/ZRNC47cz2jQPehakrMOIax+oZduU7Hz
	 d2rs+0W4J95Gj0fcEAA0c0UFvdnY2G/j3CU/X67yi6+PvyZ7wqkTUG9z9DGFvYmUPl
	 qFhgZ+p8oNP892BtLtyb1I3TPESFrPXFAo0PciY0PBEXrgjp/gxcuQLfdIqvBmqPxY
	 t4gfOvKiRvBiw==
Date: Thu, 30 Apr 2026 17:47:30 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: hu.shengming@zte.com.cn
Cc: vbabka@kernel.org, akpm@linux-foundation.org, hao.li@linux.dev, 
	cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, zhang.run@zte.com.cn, 
	yang.tao172@zte.com.cn
Subject: Re: [PATCH] mm/slub: initialize allocated object's freepointer
 before debug check
Message-ID: <2f454sp2hre6ozeqkxm4qrwtu675ivroaxbaikt7wb2gnqslz7@3cfb7jte6bnp>
References: <20260430163504368ZueB-81tYNin-vhramBnm@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260430163504368ZueB-81tYNin-vhramBnm@zte.com.cn>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 90241C000B
X-Stat-Signature: ssddu4p53oekmhq81zxc4byxs6bgc5i6
X-Rspam-User: 
X-HE-Tag: 1777538853-903045
X-HE-Meta: U2FsdGVkX1/bAjh3eynun3QAvYgKCP5O2PK5TyJibZjwrKZwjGa6D9UArHHeEu7IwCEoXkOKSv88/PLQ6VmyRut6uRjaQ0ufP3iuRSFRk7LO6o57SMKvTgZq6UcswbRG/1V3sECiRxNf9ox3pyRx0UASw3MqNIW/0jtGR6gaPrz++eTnDMxyXx3i8qCksbPT9y1N390yt19KvwCri9ezDv5rKOqFNjIv+iJ5rbuvPPTbArWTefmt2zEwrzVPz4o1ueS38bs4txgrhwehAPEUy4ioou+SfCT6vzY4hkO7L5/LQQTHNyxj9VmA4N8kBdUjLFJ8WST+Ny7sGZ6SPOW9dEoC7IZr8E6D2Ifq1Z1Mo1rHUI6c1OUXY1X0PpiGTBrFUQt/qqd70gXDnztDtibsZ1mt5pzxeDomS0CaTJDe6YGNM9paq+o+dOHuvefFLdWiwGQ0NKwJEQs8+k9ST5K3Dl8LANKmSEjgdy2Nz9UHRYMgvZVqiwC3I4fGrWcX+a/mh1jwcp8xMo1yCrVIlob+bcHP4THpGDemUTF9a8JM4qZXwBMxIsl+28qMMudf7EMj52LeGEwXA+NlbqSScPZlkcZ8KstdVLac6xRJ3z5vW//ORrf3WxLLNlYnAJX65jGbuX4EKxbOn0CUvuxQYh3Z29/6Pf5gWqBH8GLHJgEon5HxK/uxbCAVTyfHbXxRvACvJBGhjeP+gvep4J7N4zVZyqg1lF5/BHWwbTsPAAXmbsjT9kmO1+t5GcwFVif1X5B53KR0PyztCd0pb5Q4miPU5YyjsMk4BnCszWlE9pS265DoiCtzZ515RZLNVSXDt4q2wJPERaR1M03ldch8S9r7IQy7wmQnXy9EJ3rn9bP7qA7ygCKJQLp2LAmu/O/fu1vOS0Vplf7rWAG4w5dhKaExkC0geyy8TSnUozzboh98lpN3HphSlT/9Di4pakGohR5t89kq9VtFZgDrfZXMRjO
 XHUKw3uK
 Nt03Zo2jdVKuQnHb1QxxDv0rBTjjrZjcR5rFJJSqqEZwTNcEq/uysmm5Quv4vtJqccnBxLcLo0IwOnN0XcjFiIqREw/fHGl3fL5Q8ySftVuQeVSVEeatXMMhZ27lD3QhR8JckAD4Kr2UJ2a06Zs4BYXJ04d4UoGGQ9o2oCO7KGnteRYM2yOWoRNdmpig/EnbC1ud0nZkCg7CV/2pR9AJKjwYwFtoomO1NJINKQn4DfS6bZTnCf2eGO081yhHolDQAyOhp3mhRYsQ6EGOgGHXli680R01FulKNTe56WChV75OQM98MrGgRV9KvQCT+lJJ+DEWTFM+hoUBMoDWZqburOXjHfNpgOAVU+Y1sr+a73RnsOGA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 30, 2026 at 04:35:04PM +0800, hu.shengming@zte.com.cn wrote:
> From: Shengming Hu <hu.shengming@zte.com.cn>
> 
> The deferred-freelist path allocates the first object from a fresh slab
> before building the freelist for the remaining objects.  Unlike the old
> path, the selected object is no longer the head of a pre-built freelist,
> so its freepointer remains uninitialized.
> 
> alloc_debug_processing() still checks its freepointer. As a result,
> boot can report:
> 
>   BUG kmem_cache (Tainted: G    B   W       T  ): Freepointer corrupt
> 
> Restore the old invariant by storing a valid freepointer in the selected
> object before alloc_debug_processing() runs.  The pointer is the head of
> the leftover freelist, matching what the old pre-built freelist path
> would have left in the allocated object.
> 
> Fixes: 895272864130 ("mm/slub: defer freelist construction until after bulk allocation from a new slab")
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Closes: https://lore.kernel.org/oe-lkp/202604301428.e2b8d3dd-lkp@intel.com
> Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>
> ---

When the patch did not land the mainline yet (torvalds/linux), we don't
create a separate fix patch because commiting a broken patch and then
adding a fix for that creates unnecessary history. We can avoid that
as it did not land yet.

Could you please send a v8 of the original patch?

In that case no need for Reported-by: Fixes: Closes: tag.
(But a Link: to the thread would be still nice to add)

>  mm/slub.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index f96bac36229c..af942753d495 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -3690,6 +3690,15 @@ static void *alloc_single_from_new_slab(struct kmem_cache *s, struct slab *slab,
>  	needs_add_partial = (slab->objects > 1);
>  	build_slab_freelist(s, slab, &iter);
> 
> +	/*
> +	 * alloc_debug_processing() still checks @object as a free object
> +	 * before returning it to the caller. Since @object was emitted
> +	 * directly from a fresh slab and skipped by build_slab_freelist(), give
> +	 * it the same next pointer it would have had in the old prebuilt
> +	 * freelist path.
> +	 */

This is probably too long ;)

I think one line (something like e.g.,
"/* alloc_debug_processing() always expects a valid free pointer */")
should be enough (and some detail can be included in the changelog
instead)

I was thinking the FP would be NULL but either way looks fine to me.

Thanks for addressing it!

> +	set_freepointer(s, object, slab->freelist);
> +
>  	if (!alloc_debug_processing(s, slab, object, orig_size)) {
>  		/*
>  		 * It's not really expected that this would fail on a
> -- 
> 2.25.1

-- 
Cheers,
Harry / Hyeonggon

