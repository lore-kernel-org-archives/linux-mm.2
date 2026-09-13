Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FA1AC88E56
	for <linux-mm@archiver.kernel.org>; Sun, 13 Sep 2026 07:51:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97D1A6B00A7; Sun, 13 Sep 2026 03:51:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92E806B00A9; Sun, 13 Sep 2026 03:51:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86D936B00AA; Sun, 13 Sep 2026 03:51:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 65ECA6B00A7
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 03:51:53 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5B5FA120603
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 07:51:52 +0000 (UTC)
X-FDA: 85207970064.03.CEA4FA5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9AED01C0004
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 07:51:50 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=uxwBBs63;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789285910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aOrXo3SB588cxrCHrTPRWSuBXcYnG2yUhEN0rKu7bVE=;
	b=43EdXLRaJ78zcXraKxE18BEeUE4tRqOBwRpRnGxQ1x00JkzZcSHr2pGlUoM5oyLbjQBK9+
	jAK0gOwGuX638NTpbhnKyqKJ9YEwvPCFulx+W2EhbazpTE7bb8ES9Mc3sValTxCdN4TK1p
	I8wF/S81ddAz4qO0Oi9K4IfCGp9lSCU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789285910;
	b=MbX/fZTJaNODDFmOS+WdAELK3gtNrlfbAQ6BzwkFup8srAygGP/FPLm83ICqQ5b9MWdPo8
	9DdFNBFzBsNtWhkQv80a0qq2olThoZxP9sDktEiX2N2arunEtzcALQPiR31PA57SS+f3D1
	s6bKVw7wYqjW1W2flakIChmOR9upwdg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=uxwBBs63;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2EB0E60D90;
	Sun, 13 Sep 2026 07:51:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CFB31F000FF;
	Sun, 13 Sep 2026 07:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789285909;
	bh=aOrXo3SB588cxrCHrTPRWSuBXcYnG2yUhEN0rKu7bVE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=uxwBBs63QYfX9q9Q+laXRdgI9HZDS7j1HcLVOBEDfGQk4vNQLhDbHP6jblsOFwMM3
	 l6zndEnCSF9c7pi2CQyxGstu8rhJHSbE8omXSak+0g3+ndGIolZL4lWbHMG/AugVc7
	 PK/Ro6cYPxWBAuffimQzFsx5e5GqKVdp0U38Dq3o=
Date: Sun, 13 Sep 2026 00:51:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Baoquan He <hebaoquan@kylinos.cn>
Cc: hannes@cmpxchg.org, yosry@kernel.org, nphamcs@gmail.com,
 chengming.zhou@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 kasong@tencent.com, chrisl@kernel.org
Subject: Re: [PATCH] mm: zswap: return -ENOENT when the swap device is gone
Message-Id: <20260913005149.a28c21aaca165fa0255f8475@linux-foundation.org>
In-Reply-To: <20260913063031.1689420-1-hebaoquan@kylinos.cn>
References: <20260913063031.1689420-1-hebaoquan@kylinos.cn>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: j4wprgdc1awh61nui9t6msw33o3fx9jz
X-Rspam-User: 
X-Rspamd-Queue-Id: 9AED01C0004
X-Rspamd-Server: rspam03
X-HE-Tag: 1789285910-676681
X-HE-Meta: U2FsdGVkX1/dCWbCLMSYnI0Yt0F2ztwWyb7xvmQkRfw4txM+1ZnDBdnRlWJcRrEJ0s1FvtjcQnEjTvhk/c1FbbAOV4ngIyb7voAAH5XUGTe8lhpomu84hs0GC9U1EYXV0srHut8P09Ttbcj3DvUTmnSEo0hWV2J09KRNb/2r6LDh+lVvWThJguLBbvkmU+7P8nIUE9Qj6hQNZ1bAGayFXWIMLKOC2ARPkfItDOMrm4+DJrEldw4+ZDjzPtxUxAHSCO9aSPXJbBeiKmzOMqxdfRxsXxk28wPYQfGNazerKYnxY+hA5qWcEhgJQ/3FVxp49gEt5ERdNaXd2JlD+icmQYepJkupuWR+WbJA8egZj/CNX8M3z56Kah4Pn5dvnw/wh1ChpLfSgnUbI2gTWZuVFDweX/GH3KSikwfhNosrYTOWl1rQOl50PABlNj1oX31bhVxU7AIsh/JjsahEAHFF5FmYtyV8Q1YXoW/QB6JCbkiF+viRDR12kMhN/HEHWL44gHFEBmFIErpWBLlhR8cOre+I7vaxzKMuHBBrjYeEdT6wWlUA/LcZEYPyjCSu2SWK21WDF8PyS58CLcJXM6Ifv7U8oTAXNPkkP0/Wx6VuRUU2JQTP9c9WhRrgUmxeUVovO8H5oAJJUruWXx4FOzHwhOclI8u5bts80OXBbssPJNnuQe6iS3PrQFU7a4u48r8AWaERNVaZmBo3FfWNbQi/neIAMCM3XnUKDfn8Spiz1ZdmCz3/205K/hko5iRTgFsqu0BL3qxT2c2Sqw/bSLYOuGjRmUUMEVNccTXiWrM9WQiXaimeKtDtG43YslOYrSaLwPfLJch5OPKhe5lMksA/nCJ2KV4edIWEXcH0M+VNMCwkOLze0jBarmxMNbRQdznFEkYXUjIVZaFrpYZm+S8t5Tedz/gGyerpQcXFw5aNf+Qg3nHhY2gqRld2hj3Av9k2xzxZnSNqYNpdDwtI7GN
 dJ7CapVG
 i0bPgPZxI5TLWe0P3qwRhLgrzvfG5yQyygaMvYrLPUfDNqExBs3YiW8MfOmBMT4EpgUI8/hhT073XSWQlJCqljAwvPkTlcV1IHNpsCsvsSNFpDdK3+ybTIKIMAf11YppxpXDUhXgaCZ2it30vxDnWFbtggGxvzjwPqqlL6XKui6uUeJldeA4A3P2xOFOAcsL9FJEhVDXUJiEPNrqqX0jwgDATiU5EmkMAHWLQ6vdvTf7h3jw6SEGYTrKFoA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 13 Sep 2026 14:30:31 +0800 Baoquan He <hebaoquan@kylinos.cn> wrote:

> zswap_writeback_entry() returns -EEXIST when get_swap_device() finds no
> device.  -EEXIST is the shrinker's "page already in swap cache" signal,
> which makes zswap_shrinker_scan() stop shrinking entirely.  A NULL
> get_swap_device() instead means the device is being swapped off, so the
> entry is simply stale.
> 
> Return -ENOENT so the shrinker skips the stale entry and keeps scanning.
> Independent of xswap; affects all swap devices.
> 
> ...
>
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -998,7 +998,7 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
>  	/* try to allocate swap cache folio */

Comment was always lame ("say why, not what").  It now seems flat out wrong?

>  	si = get_swap_device(swpentry);
>  	if (!si)
> -		return -EEXIST;
> +		return -ENOENT;

mm-new has changed.  I made this


	/* try to allocate swap cache folio */
	si = get_swap_device(swpentry);
	if (IS_ERR_OR_NULL(si))
		return -ENOENT;


