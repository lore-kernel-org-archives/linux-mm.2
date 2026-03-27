Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CAF110BA45E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 09:22:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1E876B00B2; Fri, 27 Mar 2026 05:22:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCE8C6B00B3; Fri, 27 Mar 2026 05:22:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBD7C6B00B4; Fri, 27 Mar 2026 05:22:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B99E96B00B2
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 05:22:37 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 606DBB62B6
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 09:22:37 +0000 (UTC)
X-FDA: 84591302754.20.E518E53
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf01.hostedemail.com (Postfix) with ESMTP id 378D840007
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 09:22:34 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ShipSKBm;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=YKqR9eHG;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ShipSKBm;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=YKqR9eHG;
	spf=pass (imf01.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774603355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ygC73CNH/CmmzewfyfacproPElG15wSQnaobdyquY2w=;
	b=UGPFyopAYOgQLbCqkU3iZSMo8k2sDjSqkv8S7+IsNyz/2vRF8xVmeJz23sBQ+Jczlenrj6
	so1NM27wx0Pkh5ZsAFGE99BxPyTuDxbOt2OgfsBD6AqPQYBbtwpXDi6zyLb63KeWr0rh5Z
	CLwMc7+7Q7kCb7whPv3aoDR3zS0uyv4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ShipSKBm;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=YKqR9eHG;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ShipSKBm;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=YKqR9eHG;
	spf=pass (imf01.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774603355; a=rsa-sha256;
	cv=none;
	b=yBvH+Fk+zfbjXdv/4Vpd91HijGV6MYoMiQ4QAVEqwD9zQbeuhXQK9N8q3gx4JyILXwHkXT
	jBgvcMpHWz9cPa5Ktr0n6iQfYVAJVwwXEO4gNASnT6t+o0LVerAWp3XAVdpJfsdYrDPSGf
	VMlsMt5lOFuKOHPdj+DtsOzAxwc/Ga4=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B09684D1C7;
	Fri, 27 Mar 2026 09:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774603353; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ygC73CNH/CmmzewfyfacproPElG15wSQnaobdyquY2w=;
	b=ShipSKBmtXEHT0h3k+lvUF39jBsEEmEH01pddgt+250FVSiJpZwYhHoiJUaJ+ZjMk/m+fM
	pWyptCFlDOJFaw4BqHVTrcPA1Bu65MFaH3LoOkQPW3pWEGwxQVjz7G3UroPkKXA8zLIYWX
	oB8m6aNaNnZlXuV/OsIYsHf7uaiFiZ8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774603353;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ygC73CNH/CmmzewfyfacproPElG15wSQnaobdyquY2w=;
	b=YKqR9eHGoyemf7oCkPL4jPwUYfQo+rwYXwLblHlIeShIoMgY/o8bGQ/Nm5fpiA2aZPGaj0
	kUDlmDRYuYvc18DQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774603353; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ygC73CNH/CmmzewfyfacproPElG15wSQnaobdyquY2w=;
	b=ShipSKBmtXEHT0h3k+lvUF39jBsEEmEH01pddgt+250FVSiJpZwYhHoiJUaJ+ZjMk/m+fM
	pWyptCFlDOJFaw4BqHVTrcPA1Bu65MFaH3LoOkQPW3pWEGwxQVjz7G3UroPkKXA8zLIYWX
	oB8m6aNaNnZlXuV/OsIYsHf7uaiFiZ8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774603353;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ygC73CNH/CmmzewfyfacproPElG15wSQnaobdyquY2w=;
	b=YKqR9eHGoyemf7oCkPL4jPwUYfQo+rwYXwLblHlIeShIoMgY/o8bGQ/Nm5fpiA2aZPGaj0
	kUDlmDRYuYvc18DQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E13E84A0A2;
	Fri, 27 Mar 2026 09:22:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id RwW2M1hMxmlgGAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 27 Mar 2026 09:22:32 +0000
Date: Fri, 27 Mar 2026 09:22:31 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Jianzhou Zhao <luckd0g@163.com>, 
	Oscar Salvador <osalvador@suse.de>
Subject: Re: [PATCH 3/3] mm/mremap: check map count under mmap write lock and
 abstract
Message-ID: <fsifgilp2ra7cagtlp3x4jmm32plow7wgwfytmvtw7kq5veocp@xvcqplpyw3ia>
References: <cover.1773249037.git.ljs@kernel.org>
 <18be0b48eaa8e8804eb745974ee729c3ade0c687.1773249037.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18be0b48eaa8e8804eb745974ee729c3ade0c687.1773249037.git.ljs@kernel.org>
X-Rspamd-Queue-Id: 378D840007
X-Stat-Signature: 5mfx7xqcp1s6z1wnf7rb6jud1e6jcxeq
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774603354-277173
X-HE-Meta: U2FsdGVkX19vefpBncO22TK0MJiM392rIjID6DkK69/h/WQ/Jj3mLsNqqOQH5TDxQdzhF3980vGLCdY6yP8bYm2LfGpxGshBgYG4AsvCbSKR/pQa0AHPk6AMl8Xkxfb2qK7+HBooLvhe+7T6sgm83ua0npq8a255lZBGLL1NiAYdrArmO3PAs1tDqXhOwKO6bXJn6s3yW5exayCladB8I37TG3NRAqSe31AnYbZVV2TwRBJLuElAWswixIKvyUI0K4jdEBsGzJClnu0v1VKYS8IAEaKMnVcC5jXnpzymlf5e0YfubKgpo4ZR30rMvd4og7FsozS6mntWr4w2dNV2Vm7hfm9k6fsGOeiyPh715FFC7E2RV4icqKovvXyFTddbgABAtiNL1ieDXbkChBEbpbzB6LmfG7bxtmL37xBStnHuWkUy9G61yz7LVVSliVuF6sxjp0Bn+MZbhcef6UhToVbeJiHvzihOjOT1chMpibw5iF4ePRCUCLMqDJjau7yVg+8XSiLj9brteq61AK3/8Jp6MoZqlr0w3M5kiyLgY5VD+hXAYnDaSnMHsEXaPrRPtI3F72RSB9P/Q6yVNv8ODGWbvmJKjOsrtkEnhnqHltH5P8XDqDL9T2+2Lw2D3k9Q2tMZ1O3t0gzli3/7ig6QwK0PvrT7WyCnShz4XlPXGhnAZJDPLxVSpcAyrT4edVNyEf8uD16nAovmYMcaFWbHFiP898xJNVDrGt/6TsvOYuXY8wJpoAA/Cpd2xgeLnvjL4FSzdgCU2Ng0LqyRSSC8oaJbTLnf91dwI0iWZ1cLsNiECJKcxl8W2H38227hutCQDlRpxdXLcYOgtpbAhdmNSU6yeIbTbK/z9l5DoNJpZrgoG/FMM/jSmQpSTgXyNIP7qWP/OPrp+WnhewbqgfvQ6/L2wkhiCikOt+lyqdljaN1hfVNYMlU19JnMGuSyTZ48+rNdxiX6xgJo8jf77d6
 OANOESUj
 PjtQKuweJ1XC9GU7THc4BUUoaUk/LJN5HbFrVDCmSyXh9WbJoYNCrX2OGGgLqpMbMFrApy41pVFvancaywkKGrxDDksjeU0TmrEJk85QRFvc2yL6pECPWOJHG9G7HBQak9yOmMRFQwRjFyIudO8RcLUSfM9jn/FFeigZ5acwNAvL8QLNt0H+vwAo5EmesRK2aJUn1IGvH0vrJKV7K1brV+7TQVbKYREtnhQwZGip6fZwovXnvGzD6ot5QIE0qcTeEuIharRT0nh+erRP+qCO5TjS0AwuKJAovC8EvS+elF8bNAkN3tTJfsNVh24JmnVmuzaxXRWC4kpXR44H8uxDE5Miyx9t+xxkJ57kZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 11, 2026 at 05:24:38PM +0000, Lorenzo Stoakes (Oracle) wrote:
> We are checking the mmap count in check_mremap_params(), prior to obtaining
> an mmap write lock, which means that accesses to current->mm->map_count
> might race with this field being updated.
> 
> Resolve this by only checking this field after the mmap write lock is held.
> 
> Additionally, abstract this check into a helper function with extensive
> ASCII documentation of what's going on.
> 
> Reported-by: Jianzhou Zhao <luckd0g@163.com>
> Closes: https://lore.kernel.org/all/1a7d4c26.6b46.19cdbe7eaf0.Coremail.luckd0g@163.com/
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

Shouldn't this have a Fixes: and go to stable?

> ---
>  mm/mremap.c | 88 +++++++++++++++++++++++++++++++++++++++++++++--------
>  1 file changed, 75 insertions(+), 13 deletions(-)
> 
> diff --git a/mm/mremap.c b/mm/mremap.c
> index ba6c690f6c1b..ee46bbb031e6 100644
> --- a/mm/mremap.c
> +++ b/mm/mremap.c
> @@ -1028,6 +1028,75 @@ static void vrm_stat_account(struct vma_remap_struct *vrm,
>  		mm->locked_vm += pages;
>  }
>  
> +static bool __check_map_count_against_split(struct mm_struct *mm,
> +					    bool before_unmaps)
> +{
> +	const int sys_map_count = get_sysctl_max_map_count();
> +	int map_count = mm->map_count;
> +
> +	mmap_assert_write_locked(mm);
> +
> +	/*
> +	 * At the point of shrinking the VMA, if new_len < old_len, we unmap
> +	 * thusly in the worst case:
> +	 *
> +	 *              old_addr+old_len                    old_addr+old_len
> +	 * |---------------.----.---------|    |---------------|    |---------|
> +	 * |               .    .         | -> |      +1       | -1 |   +1    |
> +	 * |---------------.----.---------|    |---------------|    |---------|
> +	 *        old_addr+new_len                     old_addr+new_len
> +	 *
> +	 * At the point of removing the portion of an existing VMA to make space
> +	 * for the moved VMA if MREMAP_FIXED, we unmap thusly in the worst case:
> +	 *
> +	 *   new_addr   new_addr+new_len         new_addr   new_addr+new_len
> +	 * |----.---------------.---------|    |----|               |---------|
> +	 * |    .               .         | -> | +1 |      -1       |   +1    |
> +	 * |----.---------------.---------|    |----|               |---------|
> +	 *
> +	 * Therefore, before we consider the move anything, we have to account
> +	 * for 2 additional VMAs possibly being created upon these unmappings.
> +	 */
> +	if (before_unmaps)
> +		map_count += 2;

oooh, shiny shiny diagrams.

-- 
Pedro

