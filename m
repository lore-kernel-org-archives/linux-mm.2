Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7522B106ACEC
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 20:45:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 897216B00A8; Thu, 12 Mar 2026 16:45:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81A836B00AA; Thu, 12 Mar 2026 16:45:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 726576B00AC; Thu, 12 Mar 2026 16:45:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5C8556B00A8
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 16:45:35 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0F9F8C1B9B
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:45:35 +0000 (UTC)
X-FDA: 84538591830.01.3CB694E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 38A0520011
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:45:33 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=zRwSWLe2;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773348333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ulOjXktXsUiKpqi+U9+yHTriv0l5zlss8EEnF+YzgwM=;
	b=140UHmlAVoKs/qVOtzAIpLv/krnhlK2RbVtPCYZN8dMeCh6RbotvlbsBAa0iwD9SnWayG/
	nw8+CN0z2eetMkIAyoPvo7wMxlfBuQks2J/viyUolcT2a+6gLoVgqOULp0ZtiGbjL+TNNz
	r3tg6vLeCUex44SfV/JCtl8gkgX9LNw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=zRwSWLe2;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773348333; a=rsa-sha256;
	cv=none;
	b=sDgJG8o06p0Nl2MmfuGI9wtd21M5kiDQyqNoLqjCI72oep9Ya7nBAO5AlZJT5O9mYKJ4MG
	raQYv+u5QzfXQ/H2zabdnGKpbTqsiGiFgfxDVPVy66GgxQWVZX2tfyNCEoWtAL70nSmkNX
	o/eRHy5U3mCNrzMBrgeYghQbOC+NuIc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3D6CB404F7;
	Thu, 12 Mar 2026 20:45:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4671C4CEF7;
	Thu, 12 Mar 2026 20:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773348332;
	bh=umv05h/lV7uW20G8zu2OJsYgPUR2/AkzPCaK8nNLqMI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=zRwSWLe2T+UL0IDelWoEmMF9JySpjCCW2zqSCdEYf+3uQvZ/3+L1S/M0FafYlkw0C
	 CC7JiQVCt/Wzx+j4qG7EY+Xv/ntzuj9tVfgEAZzqziZeKcgXMpGiALfozDM9WO33My
	 k6vzUeH82w9WgrMC1TuVOVox7ovX5uLAgExbER+4=
Date: Thu, 12 Mar 2026 13:45:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Josh Law <hlcj1234567@gmail.com>
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>, Alice Ryhl
 <aliceryhl@google.com>, Andrew Ballance <andrewjballance@gmail.com>, Josh
 Law <objecting@objecting.org>, maple-tree@lists.infradead.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] lib/maple_tree: fix potential NULL dereference in
 mas_pop_node()
Message-Id: <20260312134531.49c1f9171b4b0bc8352e678d@linux-foundation.org>
In-Reply-To: <20260312184054.23481-1-objecting@objecting.org>
References: <20260312184054.23481-1-objecting@objecting.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 38A0520011
X-Stat-Signature: ckj59wg57ahxxunytq5ccijr8ik38e3g
X-Rspam-User: 
X-HE-Tag: 1773348333-739584
X-HE-Meta: U2FsdGVkX1+1IDC3Zpm09ZDITRej9eU+NsqB77TV+h2ri6IRLJrrYFDXEvPDjKKc+3lBxjfx0VqPjysYY8DvIj8yZtkbjAa+DDVRXfooipf8b/X2XvwlOUpj1oXCxby0xjsZBNpSLmJFLBsPDrE90IiSaSQnL3Y00r+aX1HGninEr9mJKFnAgUz9aIhmHIZoxjgoAlIhJRPt3P/jXxnxavphUTbCCnjSFq6Zs08njNVKnwDRyKxT/pC/DjBPINV+oRMMCB4iACBJt8F0djlFvTmUCKZL5/kqvTN9wvLN5tefffPNJ4fO3nx3akozUA0rOFowHzm2lHTffdAz0yY/In3ipGLHTbTwLVCo9TE4ImhYX9yoZ5lzr/+PhV+SOggdeqwx5ztWWGFduq56/NYNm05asPxK3/VWySVJVdUZP5jj9pRdxtgmbZGiBJWYNKZnDLWTTXMdKXIBY7nbASA7jL/SVKPsMrRu0iNEyD9jCskBkH6tHMu4LVLqYT6jekeG5KiGfDwEa1BUZCGFtQDVBwa4OoFYnwKHpaQv+q/mtm6CqXcvrRX52Qz/cnL0eqdjqfJdmie+GF7lc8uAm13HSBypoE5vECimVVcE/kKox6ff+jVgy0bGUC0N+VrzwGx/8LEwV/59h8CFo2hrrw2RoYEMAT699/qCbUwqfjCK3YyfAxE9TZv/JjT5N/M4U7PIiUNMDw2/PYYYs7lc4s200rWyddt8oFHkHi/lFmNPddWZSwNpZ0GuBtcQONjvBZbrS4A2HFXwivrOAP0RwLbQYjz2RVNWvXC5hseCN2DPisthoHtBfy+MHRX5BfM7ICfygt+p/B8JMu2vIk3LVFsXc1GeP99EpMxQTIPLEZkG9WuFi4aYdgDxh5KHD4bvZHRKExGUmGrNZZ4MpKBxNFNXjxIuTMapVTR3M0AHJp1aTrT9jJp3dtFpok07wKIdakH6lliO/z4Mfbb5pDT5MeB
 Eau9qnzj
 3TfPUaYEhtqW7zLRcqnsD91reP7FquY3HE9Nb0M+pYEHwLkv+al3tqpzE4ns6555LBEdECGmMqvh2gZVpPK7u7iBr42Y/mzqMvHRrzFH+BHD6b4Bh1GWhuPdcHHBGaJwUFpx+5uC71TsjGjIWer+pf6kdELfwGGFM2GOpigVpuO8PnQMonEbMYnIwpNAHhJi+dDuI0VUymh833wbbl+VoqkKrSXq1Hlkaz+gSGp4L1+SvhBgggPMA2S9SpUnfU5LYLfJRskANbZiITe/HLYu52VDfSHnpBWQ+pAtmvQRl6tyBECFiYI0Rzctvth4XxD+xsjAl3Lipe/bcRQjBvij0+t4kpsxTBETTOPVYqOJB2R7w4ygfbquzi3YKNGXI5Je931Pe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 12 Mar 2026 18:40:53 +0000 Josh Law <hlcj1234567@gmail.com> wrote:

> If kmem_cache_alloc_from_sheaf() returns NULL (possible under
> GFP_NOWAIT pressure), mas_pop_node() falls through to the out label
> and dereferences the NULL pointer in memset(ret, 0, sizeof(*ret)).

This is such a glaring bug that I wonder if we're missing something.

> Add a WARN_ON_ONCE NULL check after the sheaf allocation to bail out
> early, matching the existing pattern for the !mas->sheaf case above.
> 
> Signed-off-by: Josh Law <objecting@objecting.org>
> ---
>  lib/maple_tree.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/lib/maple_tree.c b/lib/maple_tree.c
> index 739918e859e5..87a2ba6468ca 100644
> --- a/lib/maple_tree.c
> +++ b/lib/maple_tree.c
> @@ -1063,6 +1063,8 @@ static __always_inline struct maple_node *mas_pop_node(struct ma_state *mas)
>  		return NULL;
>  
>  	ret = kmem_cache_alloc_from_sheaf(maple_node_cache, GFP_NOWAIT, mas->sheaf);
> +	if (WARN_ON_ONCE(!ret))
> +		return NULL;

If we're going to do this then we may as well restore !__GFP_NOWARN,
get more relevant information.

But a GFP_NOWAIT allocation attempt can fail relatively easily so
callers must be equipped to handle it - perhaps no need for any
warning.



