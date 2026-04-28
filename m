Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4545FFF8868
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 09:48:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1E2E6B0093; Tue, 28 Apr 2026 05:48:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACE636B0095; Tue, 28 Apr 2026 05:48:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BE186B0096; Tue, 28 Apr 2026 05:48:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 804876B0093
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 05:48:52 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4DE474055F
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 09:48:52 +0000 (UTC)
X-FDA: 84707490504.05.7C8A6BB
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf10.hostedemail.com (Postfix) with ESMTP id F36D0C000D
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 09:48:49 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=qfiV26mE;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=x1fe0l70;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=qfiV26mE;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=x1fe0l70;
	spf=pass (imf10.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777369730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2+1aaYj2CnEX1a5PD5J7TGxUpvG8RyAVHxtUULGmhmg=;
	b=xV5zF4oZV20k/y40sn+aQfLoGMYWA3NXFSiy9SsUWRU6dBLHg1hWdmObKgVzH5L3JY+637
	eR2DATLBvceYHmlU55H6EXOM8zQzb3HvCS5+6vI94bu2smtgGd/Dl2iIJlINUtUI0Ebhri
	L0zjOnf6BWmUMdKP3uKI6ASL4efJAng=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777369730; a=rsa-sha256;
	cv=none;
	b=46VVwQrGHXdTNq8JQbFaX3oxaOydQjdgHQtxeYpQLEatQPbWbJ6ehZnbPeH88MBxMkz7AP
	p3dBGT5iMKklB0KzcdU07/934b3O/dZwCenOLO9aWgudvfCKxqRyImn4MFBVASG9qz39xG
	Lkt7drs1984h5IW5VaId+Wmd0FWGaDQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=qfiV26mE;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=x1fe0l70;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=qfiV26mE;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=x1fe0l70;
	spf=pass (imf10.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4B3F96A7E7;
	Tue, 28 Apr 2026 09:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777369728; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2+1aaYj2CnEX1a5PD5J7TGxUpvG8RyAVHxtUULGmhmg=;
	b=qfiV26mEo8+AaV3WzZ8MuUk5+NlcpxR4kg8NOhl+01B1MXLHgCd0Lq1KyDe8Ujoe7/c9hu
	63tKz1T/8Pv/TN5ZHczkbIfXN3kvPk0aFmk+xfFHEdflZh0NWxceKwPE/PcfxLj1vZZvBo
	WrUiYz7U1L0HP9p/q/YISKTVHzU/w3Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777369728;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2+1aaYj2CnEX1a5PD5J7TGxUpvG8RyAVHxtUULGmhmg=;
	b=x1fe0l70pe5lxEzmvOIQKopMXKCDZf0Gk15Z+OI5ucLG2YRy8UBZlHDJH9KwquwWhVnzR/
	XuZzqoxVKOWwPdDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777369728; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2+1aaYj2CnEX1a5PD5J7TGxUpvG8RyAVHxtUULGmhmg=;
	b=qfiV26mEo8+AaV3WzZ8MuUk5+NlcpxR4kg8NOhl+01B1MXLHgCd0Lq1KyDe8Ujoe7/c9hu
	63tKz1T/8Pv/TN5ZHczkbIfXN3kvPk0aFmk+xfFHEdflZh0NWxceKwPE/PcfxLj1vZZvBo
	WrUiYz7U1L0HP9p/q/YISKTVHzU/w3Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777369728;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2+1aaYj2CnEX1a5PD5J7TGxUpvG8RyAVHxtUULGmhmg=;
	b=x1fe0l70pe5lxEzmvOIQKopMXKCDZf0Gk15Z+OI5ucLG2YRy8UBZlHDJH9KwquwWhVnzR/
	XuZzqoxVKOWwPdDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 43C3F593B0;
	Tue, 28 Apr 2026 09:48:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id j2+JEICC8GlICAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 28 Apr 2026 09:48:48 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 0C532A0B62; Tue, 28 Apr 2026 11:48:48 +0200 (CEST)
Date: Tue, 28 Apr 2026 11:48:48 +0200
From: Jan Kara <jack@suse.cz>
To: fujunjie <fujunjie1@qq.com>
Cc: Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Roman Gushchin <roman.gushchin@linux.dev>, 
	Haoran Zhu <zhr1502@sjtu.edu.cn>
Subject: Re: [PATCH v3 2/2] mm/filemap: do not count FAULT_FLAG_TRIED retries
 as mmap hits
Message-ID: <lxmyrpudachmomrrfltlvwxtddqakuudeq3wau2izgunakpvpz@3mbztm6x57nr>
References: <tencent_AA501E9A238337BD167E5C2ACF948A1AF308@qq.com>
 <tencent_22E6B8849EC1141FE7773C64467E6F1E2C09@qq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_22E6B8849EC1141FE7773C64467E6F1E2C09@qq.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: F36D0C000D
X-Stat-Signature: ik5ys48b3cgs53opiwbn4wkgcw54i4pg
X-Rspam-User: 
X-HE-Tag: 1777369729-981436
X-HE-Meta: U2FsdGVkX19tUPnaCmGM9rlAds/WLmuM/st/UAPxg04HvDBb352qNk9X9fn3pipzJ4NcnSZdZlLXy1NmjTGzRjn/XKuHzSQjXGkB5eXA8gzJm8pM2B9salFbuN8L6TebNo8RT/PCv2rxdO+d//vrMwc0ofRbj4dnmqLp5b5g2nLmG1VX39dZAgFp7hHIjmqpObAWXKHpFqJnJDeBw2O0ddCn4Wb+8HIjHwcQDMzFB/l/4KLGHigRjQ2FOWrI9BIXeYuBiX8nnR8C0eB/KVjCqKe/usFsEUljRsf/l55WW1RH4j311G0Dd5snc7lcHnEsu9fkIfcWUqavWQuVgAwRQ9R1bOGFF4eV1tHoq3mLoKkSjEEYqXj1zsMEewgDuknaRATFVt9eUknm6h+/Un85UGJm21olxZsHuJStylzFNbZk3+nzNLppVKynFJP/8B1huQTgiWrLVIqIuzSY6tGIRVPxIwheW3Egx6i4Lz/Epyx39sMmryo+uWgjhQ3cYqJcNl7hRcu1dJ3fUuD4TO+UZ2AXTgP3gbaXeqF8ECa2ub6k9FVOU1Yb9/YNyGbZMj3NFSihf7/lg38ZflVsK4su2Zrpp8iflV9itIgzFehk5PWvuYMkRoO2lQUMcAgz3kDhl0km412LQShXJ2e1XVVE00Jf8J7BAZ/Ia9cusMpfftFV+rhRwl3cy4AV93gsTD6DSWv56kwyeDFGP+DQINSF/ecJo6j+xKmadgMLrE0IMM9ZJcxUY3xingE0mrr+oODnjgeax/edAODmCjwUPo7fjf1PVlLLhMNwF4L4VPvxz8odp7Kk405p+/bxPLrhayLyA6OdIVw9+vT9thjDbEIhXuvLBaCHTCAs4DWs1XrCmRRE3uxJ6xg6nNmg0E9GwZflnAHenur4A5v9rVprEpBzWy/FrnJVP7RxPyrSV9CCzGPwOvquDbBU+SsIxuZqpCwFjcm9GM0St07xpkVDM+y
 YGgLlhnM
 xinoXMjEj/7U9pgQ4Gif9tQrfcj9SiWwsaoq6UeJsFSWYozNOsbWlo7eQGimIkWQukWNvTN7RC2QOCec2IAD8/GhYnGBjr4DNGuWRhTBSsNPNQ9Z+nv2R8yBhBNyqFKvV10t8aZSwbDRflmjsFduZ4YM3Nuytxv2FLFoDUNkkUZx/B2C9VKTFRLUeWFMwlLw2mfq27MX6gWRYAr5f/ge+QByfjtf6h03FepueE68Mg7BaIq93aBlPC/HzpXM/hnFVPfTzh+FiHGhzEWK43vnEyVzEWy8LxAgKCDS0dKLxDYXQEeVB79h5oX+ykH5IcavG4GoKPOB91220gwDZTBA4lJ1USsMM9HxB2fCZslKR6p6KeuTumwU8ngsWVJ4AeYV5GneYNiEx/SlTPVMTfmU7mwe1oA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 28-04-26 01:59:44, fujunjie wrote:
> A fault that starts synchronous mmap readahead can return VM_FAULT_RETRY
> after dropping mmap_lock.  The retry may then map the folio brought in
> by that same miss.
> 
> Do not let this retry decrement mmap_miss.  The retry still maps the
> folio from the page cache; it just does not count as a useful mmap
> readahead hit.
> 
> Signed-off-by: fujunjie <fujunjie1@qq.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  mm/filemap.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 543e51c32397..86a46a61eac8 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -3933,6 +3933,7 @@ vm_fault_t filemap_map_pages(struct vm_fault *vmf,
>  		 * we can stop read-ahead.
>  		 */
>  		if ((map_ret & VM_FAULT_NOPAGE) &&
> +		    !(vmf->flags & FAULT_FLAG_TRIED) &&
>  		    !folio_test_workingset(folio)) {
>  			unsigned short mmap_miss;
>  
> -- 
> 2.34.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

