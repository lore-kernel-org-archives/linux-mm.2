Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E51C7CCF9F8
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 20:07:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1404F8E0061; Mon,  3 Nov 2025 15:07:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F14C8E0058; Mon,  3 Nov 2025 15:07:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F21DD8E0061; Mon,  3 Nov 2025 15:07:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DCFDA8E0058
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 15:07:07 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5836D4A113
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 20:07:07 +0000 (UTC)
X-FDA: 84070379694.22.8A75CDA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 262C9160013
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 20:07:04 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Qddpn12w;
	spf=pass (imf08.hostedemail.com: domain of bfoster@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762200425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DBB1oEzfIzM5CmZJ0vPo8xnsoF0bh91Ad4C6gnseqAw=;
	b=etcAN2sZDGbJPsoHPYhOFcGIXI7RY4EPnN2P1N2QH7R38Ff22j34I4QctRYZVFISD7k986
	rJp3WDz0VoeatQruEsja7GpEdDODUDksqa1LDsxIrqPgQnfObp6mOXL8T1hcn2G4qPZfBc
	1Cm5QrGyl4R+D/OaR4gfS07mHzXPevo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Qddpn12w;
	spf=pass (imf08.hostedemail.com: domain of bfoster@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762200425; a=rsa-sha256;
	cv=none;
	b=loot45TNvd7ULtXhpU8wfBY2ixaNC/yrE6jvdwle0HPNXDl2ymyQ3q3xHfgSe/ue/migFD
	xnb1Wfreq9wgPjULuBInhlPyQki2gTg29DSbtsGR0RLK/xjb2+sbUFonxVTBvBF8qBOFVk
	tZi+V7zs490KED0WXhf8ttAv+Rl4IvQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762200424;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DBB1oEzfIzM5CmZJ0vPo8xnsoF0bh91Ad4C6gnseqAw=;
	b=Qddpn12wF26prEMLDsewCEngnwc3GCy4BL3FmL7t9XHYksosXgWwtpLhVG5PYHLGkjAEoT
	DG62i4n7rGRYM0rQf75yXwmGfkeciJpafTmOOTZvqyELpZ5JQZbkrw3jwOMRzYOu5Ycvpe
	ekVeX02P7mSX4HyRrl+Z+c4Eci2vpuw=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-292-zPD7iUxuPyeXh82Ii1a0Tw-1; Mon,
 03 Nov 2025 15:07:01 -0500
X-MC-Unique: zPD7iUxuPyeXh82Ii1a0Tw-1
X-Mimecast-MFC-AGG-ID: zPD7iUxuPyeXh82Ii1a0Tw_1762200420
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 17290195605C;
	Mon,  3 Nov 2025 20:06:59 +0000 (UTC)
Received: from bfoster (unknown [10.22.88.135])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0392B180045B;
	Mon,  3 Nov 2025 20:06:56 +0000 (UTC)
Date: Mon, 3 Nov 2025 15:11:26 -0500
From: Brian Foster <bfoster@redhat.com>
To: linux-mm@kvack.org
Cc: Hugh Dickins <hughd@google.com>, Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	William Kucharski <william.kucharski@oracle.com>
Subject: Re: [PATCH RFC] shmem: don't trim whole folio loop boundaries on
 partial truncate
Message-ID: <aQkMbsqh_9cYGsvV@bfoster>
References: <20251030165121.1131002-1-bfoster@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20251030165121.1131002-1-bfoster@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Bv0TCA-L7p8CjSyemCAl2DwGvZHO37BUeNhD2gbQQFI_1762200420
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 262C9160013
X-Stat-Signature: d58w1o4u14h199zefdj46zpseuh5ccxr
X-Rspam-User: 
X-HE-Tag: 1762200424-115953
X-HE-Meta: U2FsdGVkX19UqSeemM+MHvlVRgEpenOTecGh6gtPUUyrMqijTXFDoXuTa0H59lxiCkjKgJTqJ1f+tc8X2Os658bYZx/OkMwh5HP8+4ESHOqEdr7pF3m1VkSqNuZLMJlJj3QkbfqZFElW1NypgKN2Gd95m0HVV2E2Ezt28s7opx17oNIcKPJzmKyoQTmGF8GzLguUCW72/xWOKQ3OxzpTSQuaZwkATCf/mrp0NByH4/oVfN2XYf0N0A1/eY1QoU+rBw4k0CXjAtEJwnEtJiEHVU0OM2I8/sCkzVTTGq2YStCxIFPwNGNHPUOfKutUbMURohdjC91WO8Sg9SK9TgpM0d1DkWVGWS3PaVmwQS/oBY9bbaNbdlZvEBeK51jjA8tR4zMRu8xeXKNOCJhXqYx3N4klzbGyUZo8cTdXtvaa11lzCnAwlkNi397BTZL5tkSHZcDvvgfo/b6KUiqxH5NpUFZIkNi9iFe2uO++IvNlly4og9TLZjR8i06eU5nc+K9Azv/GQjxVcje/Gvim5TVKQ60AHomk/yM9Pmg1vjsc1LciHClGbH/uenrzyLlhkM5RsMDQeW81IzlQX2bM/35sNkJNst+mUyjCVHV2ucXs1yhuT3w9WTKARTUlHtY6Gn1GJbxtmLvnOq6mh4dwK8KxfpHxEBVEasBmQqxbYDuBuUrVxwMFy1n9TOYqpaACF2f3SrM94h+FJnlCYyo3V9WTOiRMR8pq3CVmE0lzGMhXHdz4Ruqo2zCaAvDXCRFmazyJBSiNxWBBOUj85G8WaTRaIEqOmFTTmyWrH42hXHMP8e7RnLYVY0UbXruVeBoKd7dJj5r9IfSd6u54K2LSaMMW941WKFGzbTZQ1fK4Ev5NXKcPauwYp7FfCC3dWlTjpQNwrqnd2FetQOFcVqAwZz42tVtjHnG5DEvmV59YzXx4ioFrSoHnOrQDFwiP2AjomH/oJlyLy6sajHglggsuQCW
 oxt4jI1B
 0cpez7HhveYA6Gh4rTJi2xUNNU3GTbP0+FZoIThFM6Kn2SUxAIg0KX6UHcG92g29Q91S2GdGVaNNQcpdyVtuyP3RrUvuC2n4ku/DBMUXh/u8MYMNcli4TH7s9pSiyKsIIwhMm0BbH/7DiE/5ejVzJzcy5EQVoQpkoid7/kSz/QALQnoUAtBXgrxw1ETO9Be/ROxkfYpfkfLkJKp0W/35eWtKRQJFgH9TrfWSKAjiB8sOAfjoSs9rcNAtsgVGksUIQkxmQXR4rRKSMXC0//sRT9DE8qwWXkBqGRaPHYXb2565BlHQO4g/+og0vymx7/17Mlsw+oJbAfUJOw6qxPhoJJqyOy8mddOx7nHcVTGAsvBlMqHcGInRJX+XeIAdXJk6wfc6kV2tTgkHw9RFAYOY9atMtRonHxCQ83Sd0gaQWxc6pC5eciLRruXTBPmlpicJvfr7ma1Z4LAwcoqrzJtD3Oje/WQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 30, 2025 at 12:51:21PM -0400, Brian Foster wrote:
> An fstests fsx test run in a low memory cgroup environment on a
> huge=always tmpfs mount occasionally reproduces a livelock in
> shmem_undo_range() (via a truncate operation). The process ends up
> spinning indefinitely in the whole_folios loop.
> 
> The root cause of this appears to be that earlier in the function, a
> large folio is handled at the start boundary of the truncate. The
> truncate_inode_partial_folio() splits the large folio such that the
> currently referenced folio now ends before the range of whole folios
> to truncate in the second loop. The start index is pushed back and
> the second loop finds/splits some folios in this range.
> 
> Ultimately what appears to happen is that we settle in a sequence
> where a large and dirty folio sits at the updated start index, the
> truncate returns false and doesn't actually toss the folio because
> it's not fully within the logical offset boundaries, and hence the
> loop restarts indefinitely because the index had moved forward since
> the previous batch lookup.
> 
> To avoid this problem and simplify the code, remove the start/end
> boundary updates in the partial folio handling at range boundaries.
> My understanding is that there is potentially some overlap and
> duplicate work here, but that this is relatively harmless and safer
> than the alternative. Also since the folio size can change as a
> result of the partial truncate, update the same_folio value based on
> the post-truncate folio.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
> 
> Hi all,
> 
> So I've been (finally) getting back to my tmpfs zeroing fixes and
> running some testing and hit this issue. The test is fsx running in a
> 10MB memory.max cgroup against a 4MB file on a tmpfs mount with
> huge=always. Note that I first tried to bisect this since I don't recall
> hitting it before and that landed on 69e0a3b49003 ("mm: shmem: fix the
> strategy for the tmpfs 'huge=' options"). I take this as a behavior
> change to something that precedes my initial testing and not a root
> cause, so I moved away from that in favor of throwing in some tracing to
> characterize behavior.
> 
> I'm sending this as an RFC because even though it seems to resolve the
> issue in my (limited so far) testing, I'm not familiar enough with all
> the complexities around large folio management and whatnot to be totally
> sure it's the right fix. For example, I'm not quite sure if the test
> constraints here are circumstantial or something more. FWIW, I started
> with a more simple fix to just prevent start from moving backwards. That
> prevents the issue as well, but this seemed a little more explicit on
> further thought.
> 

Self-NAK. After further testing I think I've reproduced a case where the
undo range races with swapout such that this change causes the
whole_folios loop to toss a full swap entry that extends outside the
range (where the existing code would have trimmed the range start),
which is wrong. I'll fall back to testing out the incremental fix
mentioned above and follow up when I have something more generally
sorted out...

Brian

> I notice the same boundary tweaking logic in
> truncate_inode_pages_range() (via the same commit [1]), though it looks
> like that path is not susceptible to a livelock as it will just toss
> folios. Again, I'm not totally sure if there are outside circumstances
> that make this less relevant there than for tmpfs, so this is at worst a
> starting point for discussion.. Thanks.
> 
> Brian
> 
> [1] b9a8a4195c7d ("truncate,shmem: Handle truncates that split large folios")
> 
>  mm/shmem.c | 11 +++--------
>  1 file changed, 3 insertions(+), 8 deletions(-)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index b9081b817d28..133a7d8213c5 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1133,13 +1133,9 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, loff_t lend,
>  	same_folio = (lstart >> PAGE_SHIFT) == (lend >> PAGE_SHIFT);
>  	folio = shmem_get_partial_folio(inode, lstart >> PAGE_SHIFT);
>  	if (folio) {
> -		same_folio = lend < folio_pos(folio) + folio_size(folio);
>  		folio_mark_dirty(folio);
> -		if (!truncate_inode_partial_folio(folio, lstart, lend)) {
> -			start = folio_next_index(folio);
> -			if (same_folio)
> -				end = folio->index;
> -		}
> +		truncate_inode_partial_folio(folio, lstart, lend);
> +		same_folio = lend < folio_pos(folio) + folio_size(folio);
>  		folio_unlock(folio);
>  		folio_put(folio);
>  		folio = NULL;
> @@ -1149,8 +1145,7 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, loff_t lend,
>  		folio = shmem_get_partial_folio(inode, lend >> PAGE_SHIFT);
>  	if (folio) {
>  		folio_mark_dirty(folio);
> -		if (!truncate_inode_partial_folio(folio, lstart, lend))
> -			end = folio->index;
> +		truncate_inode_partial_folio(folio, lstart, lend);
>  		folio_unlock(folio);
>  		folio_put(folio);
>  	}
> -- 
> 2.51.0
> 
> 


