Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C7BFCA5FAD
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 17:59:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9A656B008A; Tue, 29 Sep 2026 13:59:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6FC46B008C; Tue, 29 Sep 2026 13:59:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D85546B0092; Tue, 29 Sep 2026 13:59:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B03D66B008A
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 13:59:00 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 189D21C346E
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 17:59:00 +0000 (UTC)
X-FDA: 85267560840.16.573500B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8637A1C0008
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 17:58:58 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UWIEExcf;
	spf=pass (imf18.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790704738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D8IsblU8nmE28Btv5b/ZkJyD4K5wSxbscAgK5JZqxKw=;
	b=fPb4B2Jr8ERjkc7ebfm5rGhMns2yoOfT2t3WTgTGTZSi2JQNGHN5AARKAZUfRI5T/KDwfH
	35qprTIa1PsVIIc2GmdudjTrx3gYU1RmSf41yUG9gIEPtObrPe2xMbf66U4xibhv88wSdO
	dairyrgiw5iMSdVhiQWchcPDVLbWx4U=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UWIEExcf;
	spf=pass (imf18.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790704738;
	b=pQyx8o0c0CO6M3dUN/hdIy9d2iCoknxl04GcpDkTs3KbN/llMbWeD6QpAPk2feJxQOoOmZ
	tnS95lX86F6M1+BJGHKDAWuvfIt9/f8+fjeuq67MB74qBEg5zkbS/a2wciOHOx3rqFbEWb
	zGB+ZntRfipQyquKNcUUdF5l9l4ogDY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DCFEC60239;
	Tue, 29 Sep 2026 17:58:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69E7B1F000FF;
	Tue, 29 Sep 2026 17:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790704737;
	bh=D8IsblU8nmE28Btv5b/ZkJyD4K5wSxbscAgK5JZqxKw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=UWIEExcfN6jUovdJmatCAMu5OMD6YHLVKZLm4cwex0sANOgJ6vPEjlkalfQRzeyk1
	 HIAuV12wZ9IO9kr8cpQEcoScoW432HEkDlXR4y5ZpNlxQaXm/jw05ouD1qd1CsVN9m
	 3Gt001PNnIvK6A0HEBpRnJ5EDl9PT4w/lSUe+3be5PkkjdYNbwA4nUkHZ3J7G6mZls
	 CUuSPXxVNpzgnTJkJyx6pcWtIwMHe0a7gvAeVwu2ddCGSxiFyMqDXJvS8qYjYDgJt9
	 1HW3sDhHDfkJPJqJ4beFmeBW+7KVeMURYf+f7sveglgtD2EZmYctQc2ubNmGnhu3D2
	 TGhaDjjZy1qTw==
Date: Tue, 29 Sep 2026 07:58:56 -1000
Message-ID: <d594ecb783f0f6838a52099fdba3de8e@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Liz Fong-Jones <lizf@honeycomb.io>
Cc: Christian Brauner <brauner@kernel.org>,
 Jan Kara <jack@suse.cz>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Jens Axboe <axboe@kernel.dk>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Xin Yin <yinxin.x@bytedance.com>,
 linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org,
 cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 ian@honeycomb.io
Subject: Re: [PATCH v3 1/2] writeback: let foreign flushes reach dying cgwbs
In-Reply-To: <20260928-wb-dying-cgwb-flush-v3-1-e35374884667@honeycomb.io>
References: <20260928-wb-dying-cgwb-flush-v3-0-e35374884667@honeycomb.io>
 <20260928-wb-dying-cgwb-flush-v3-1-e35374884667@honeycomb.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8637A1C0008
X-Rspam-User: 
X-Stat-Signature: xk3uandequifnsmfrow9ruj77ay71iim
X-HE-Tag: 1790704738-759801
X-HE-Meta: U2FsdGVkX1+M1fe17nQe1j6RNuRTZhr+KqCKFlxd6uv/xsBzieefet9KJqiD5pYj9/JveJQV/DYsSlSDeQFcPCFk0ILyHHU12obNdoxqk5TWwYWcuBdpnTYNqYjwiMxc5gy2ZugB5Ap+iqFi9H0UhBlAbHsVeko2+u0VyFYLv60fri63vRppfbteAP3c5+YITPrZGY+G+hiWdKJlslp4Ak8pw02THHiyNOs8K6E9hM3Em6QdCKR07ucG2Y9lqljnMLQwAPXEhFbSAT4bT1uevIRY33Gt2eC25zKsWQhYMfLLWvacV2uWQceBYfdj1ykq5SOK7Mqs+0h28FjVvlA/vCfocr5efvmMhann7Mn8XHY5mszzjPP+steCKmkYwvqeNkGUSgbVnOOG3XzOJGvSvwPkvbnIRZHNVd3+1D0Jea7+VC+mYkfrOPWfmNKqRbdztwhh1KXc2j2RKIVBDZbUlhrsDfWzji7v0QglMY2zSr16a1SgpOLN8EMuzkFpMOjlxZQZHWmJYQTXoNLA4T9VqBDWgbyvdjJiNAiperY4zuDk8Tr1ZnSayTJNbgAlzc24XDEwYPM/XrppTwrbtzr+z15Q4KroSbZUCCYG/c9Va0P2WLkhk+IYcUc3/GXGZhogJ+MZDubw5BK3B3/DCYcznRCvDmXtW6UgzpGMNHFQuNbWGqlw+ObdGj7eEeTttZakTFlW1D9QGShUsmw7rBVYNQDs1a933O0b/hbtqvXW42s15fald1tMuzlSbjAJK8lZZxniWSaYR5RIRce8Asa4hSEvejKMwSUVOSw2C2T9X4Q2PWf9VDm4YTijTITdfd5Pdq5zVKRi9hSpmlo4vIhmZeIjy3AswF2bpMkrJJ541N07muI7iDnJum2aXsmPgezND2FYNeKJgu/GJHMCsXDW1SUPq4AeXvdkqL442OW3oHW6Gt0ZAFfPVlyci/iJEjPnJ9TVL7HzGHNM+T9IyAU
 Iv1VCTTC
 ESa9sSl25tR0/vEPQc+O0MOQ86KRzUxdhlvIzStrHVCAqALB/sxfViHorxq479W1m6LLmHiDwJs9Wn4vkPgMP1zKim/jzLCxqtdiYjn15JIcsELSfJ2McOSg72u1jrSlE+IypOBOrDYxBdzZ40K69sAVnuAgPyvXEpGqmlFId6Utl2qqV2w3EJ9HJP2dad8ZNjHQ7cYssvL5WP94rlck8f8NTna587ex6wc1mZRQjUqdbVeDaHiUEij6DZJ0VB8UqeO30
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello, Liz.

On Tue, Sep 29, 2026 at 01:40:49AM +0000, Liz Fong-Jones wrote:
>  	if (test_bit(WB_registered, &bdi->wb.state) &&
>  	    blkcg_cgwb_list->next && memcg_cgwb_list->next) {
> -		/* we might have raced another instance of this function */
> -		ret = radix_tree_insert(&bdi->cgwb_tree, memcg_css->id, wb);
> +		/*
> +		 * We might have raced another instance of this function.  A
> +		 * dying wb keeps its slot until released; take it over.
> +		 */
> +		slot = radix_tree_lookup_slot(&bdi->cgwb_tree, memcg_css->id);
> +		if (!slot) {
> +			ret = radix_tree_insert(&bdi->cgwb_tree, memcg_css->id, wb);
> +		} else {
> +			old_wb = radix_tree_deref_slot_protected(slot, &cgwb_lock);
> +			if (wb_dying(old_wb)) {
> +				radix_tree_replace_slot(&bdi->cgwb_tree, slot, wb);

This can also replace the wb of a removed memcg:

1. A cgroup with io enabled is removed. Killing its io css makes
   cgroup_get_e_css() return the parent's right away, but
   memcg_cgwb_list->next stays set until wb_memcg_offline().

2. In between, wb_get_create() for the memcg, e.g. from
   __inode_attach_wb() or inode_switch_wbs(), kills the dirty wb on
   blkcg mismatch and a new wb takes over its slot.

3. wb_memcg_offline() kills the new wb. Foreign flushes for the memcg
   now find the new wb while the dirty inodes stay on the old one, as
   css_is_dying() keeps wbc_attach_and_unlock_inode() from switching
   them, so the stall comes back.

Can you also fail the link when the memcg is dying?

	if (test_bit(WB_registered, &bdi->wb.state) &&
	    blkcg_cgwb_list->next && memcg_cgwb_list->next &&
	    !css_is_dying(memcg_css)) {

CSS_DYING is set before the io css is killed. Testing it here, after
the blkcg lookup and under cgwb_lock, catches every removal that could
have made the old wb replaceable.

Thanks.

--
tejun

