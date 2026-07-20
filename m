Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AFB2C44527
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 10:42:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 137256B00B3; Mon, 20 Jul 2026 06:42:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E9A56B00B6; Mon, 20 Jul 2026 06:42:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F19376B00B7; Mon, 20 Jul 2026 06:42:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BFAF96B00B3
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 06:42:28 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4DFB6A004F
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 10:42:28 +0000 (UTC)
X-FDA: 85008815976.12.2E0D719
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf06.hostedemail.com (Postfix) with ESMTP id C5DE4180002
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 10:42:25 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jtQaI1T4;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=irzBSGxy;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jtQaI1T4;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=irzBSGxy;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of dsterba@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=dsterba@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784544146;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aqap3wdPva9/l6VNETK9i+qMdkB62Ft/1ZxEFof7ChI=;
	b=EV1B7e+RA3pQa9sMXBGhE6M8itqx99B/zypJogb5Du4/wFKWYduwriYJdiDR3rMEPzNG4T
	K2FH4mblY/Tnx/wAv2fxzUm2x7KQSbJDfoiAhh/O336FKMVxVTzYxeV7J4gyC17HLKmmn1
	g23zNtxNP/4yjt2oTk3TF1AIedUAy/Y=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jtQaI1T4;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=irzBSGxy;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jtQaI1T4;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=irzBSGxy;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of dsterba@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=dsterba@suse.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784544146;
	b=F4P3Ko/ffj4tDUS9378bTIPXlwaLhBBgG84KSTRJC6yGGZ1dewv/wb8RR38zq7YsIGSjGx
	7iulqqWf3ah3Efap6hlN0YJDnOu0ftqvVxpfcr3HprlibfLL1xcYJlkOUyM/VacZgHe7ey
	ufTWvvgSBPR5FcSebum5mgzwdaIjruE=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id F262379EDE;
	Mon, 20 Jul 2026 10:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1784544144;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aqap3wdPva9/l6VNETK9i+qMdkB62Ft/1ZxEFof7ChI=;
	b=jtQaI1T4n6R0UUo1+22JWN66cg+JsX33EFSvQxdLO+z/ukidOKrUlWsTFzLw9u5w/xmN7u
	aSiw/Myip7rXPbbzRJqEzLCQBIVfCRaX2m2ngdrcNgchkQkb/O8G6UoE5xmLda+8131RL5
	jjoEzaoaUb+60K2F4tE2sqoirMvlOuY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1784544144;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aqap3wdPva9/l6VNETK9i+qMdkB62Ft/1ZxEFof7ChI=;
	b=irzBSGxyGWq64BLmlkqnrOdIxhHPNmLP4WuHGPapcQNxqfvwaxdiQ5tfj5WotMOvjC7wiK
	O+2cBrYo+fGynHDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1784544144;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aqap3wdPva9/l6VNETK9i+qMdkB62Ft/1ZxEFof7ChI=;
	b=jtQaI1T4n6R0UUo1+22JWN66cg+JsX33EFSvQxdLO+z/ukidOKrUlWsTFzLw9u5w/xmN7u
	aSiw/Myip7rXPbbzRJqEzLCQBIVfCRaX2m2ngdrcNgchkQkb/O8G6UoE5xmLda+8131RL5
	jjoEzaoaUb+60K2F4tE2sqoirMvlOuY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1784544144;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aqap3wdPva9/l6VNETK9i+qMdkB62Ft/1ZxEFof7ChI=;
	b=irzBSGxyGWq64BLmlkqnrOdIxhHPNmLP4WuHGPapcQNxqfvwaxdiQ5tfj5WotMOvjC7wiK
	O+2cBrYo+fGynHDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C5CD7779AA;
	Mon, 20 Jul 2026 10:42:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qhMYMI/7XWpybAAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Mon, 20 Jul 2026 10:42:23 +0000
Date: Mon, 20 Jul 2026 12:42:18 +0200
From: David Sterba <dsterba@suse.cz>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@fromorbit.com,
	dgc@kernel.org, qi.zheng@linux.dev, baolin.wang@linux.alibaba.com,
	brauner@kernel.org, cgroups@vger.kernel.org, clm@fb.com,
	dsterba@suse.com, hannes@cmpxchg.org, hughd@google.com,
	jack@suse.cz, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, mhocko@kernel.org, muchun.song@linux.dev,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>, kernel-team@meta.com
Subject: Re: [PATCH v2] fs: push nr_cached_objects memcg gating into
 individual filesystems
Message-ID: <20260720104218.GA10684@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20260715103516.2410175-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260715103516.2410175-1-usama.arif@linux.dev>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Rspamd-Action: no action
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C5DE4180002
X-Rspam-User: 
X-Stat-Signature: gauadea7fmgkkyaoh566xnnsk5i7nuwk
X-HE-Tag: 1784544145-586331
X-HE-Meta: U2FsdGVkX1/wGhSexvXmVwC2xb0LDFIFVox1YWxV5geb37HVGelYACnktNER+W2rb9umGsE67N1XnCWWR1gJIIEsP3mPsOC68p27D0It80JAalQoFdEuush5q8V4/RrwRsjlONE1m6tmoYaNXAobVuUkN3uzbHT5erfxT6Es0mhWXXzMDQVt1No0g/PXUE8KsQuOXf7+oT2auJizzzbIoufbfLbeKn35EPNejTvAjM7ttLZNNmRfgulDbCf70YbVGNoeZAapnBIbywWKhiWyvvX371rgluHMKyqRjIWUOqDeyypq2WB5bptrUb1btraoGrt7DiuHjkMWZstH3kz8pUZBBxViadCCLkksrJJQZCu4AsWxOgIVkMJv3CdBxBpWT4vbnmL0h/D9ICaiCUXr7/YU/ji8g2GijFR3FxKEQK9SN7PUBotDyIvwdEYTAquvp1uyWuXbuBDya6P1t3E9NmqlDt2k14lxL1v6LHPchWmP9QBq4d79v2SAzg5X0bd/7anN9ITO6hGqFraV+0+1S4YmUj/1nyz5TGM94MlgEQBhAWT3n1nktKFP6Sap3gTldwp0Lxf1neJrvoKED1Yxnb6ARMZsXZ8I89uz2V76UFyQ6MDsQ4qlNiHw3rAKd/tUDhWEsULvPknVc+US6+SOK3liQdkIq7+fYYP9wxDgIisp3gJjZzMc470H0BSfCZl7BskzdLp1lb76jNzcCFdXR9sEikz+39p9RWdO978Phc1kwtroCXGt2Qbtd/eOfZy4Ml3qLhMyef5NW9i7zEss5C0eN/MR4TLd6Wjkm7WjhDplABoeZwTintq5jowTLo0/xJTExckV2xqv6gfSlbY4oE9QcC09hdASdZOyLYXZUWy0ytkgYQWPrYDpuoKYGqnguXGN+BJ5ZHbg9C+Tyl4GAbnkuJjhRoTTQ/OP8Vmt9DDTmVTLxdSSZ3NYJGVz+INThBTewiI0Teu4o7cBXSK
 +ywvfScN
 Sq/HOpU1okpIv5lp3VKxBR8cnreT2O9VJ/chwfDktTsj1ge2xq6RDNM7gLvt4YI9tnSx+ibx/5FTdRVx+ApqV1vWs3I3TWcDuAR7iP0j2hLLRzpdrTHvk+AMmzNljEtILbFVcKEBdGl+wsq/QCRswSMz8tc4GsN3Pg30+QiYvA+wippnXHmSuWjGFJpavsgZt0TAmiRFv4t1/E5m3VXwSUh0X2++ZDKbLnoBH/8jutFWw6wjjPGbj3gqTi8vaya+0RWhi4SUKkWMsSr1GmfdsQRTCoct02Un76q0Qznufh0C3IDIVp0rhrx2S3ecQgro8n01zPFvD6L3Qs+BrQLKEtc+F5OXFjKCqmtj5M2il8ON9ZxTcZIvC/TOh5TpbOsLp53ST+MgIJPmNsxSSFLJR3lKl4Pmn5c07kgm6pUlt5hY8qUVICJwl8O+NisJjohcDEeNgTSTYhZTJzmptO5hbPoOAJYxrUmrbVF05O9zzmo/Lt/k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 15, 2026 at 03:35:16AM -0700, Usama Arif wrote:
> Commit 0baad6f9b997 ("fs/super: skip non-memcg-aware nr_cached_objects
> in memcg slab shrink") added a check in fs/super.c that skipped every
> ->nr_cached_objects() hook whenever the shrinker was invoked for a
> non-root memcg, on the assumption that none of them honour sc->memcg.
> 
> That assumption is wrong for XFS, whose inode-reclaim hook is
> intentionally driven from per-memcg contexts to free memcg-charged
> slab. Encoding a blanket "never memcg-aware" policy in fs/super.c
> short-circuits that path.
> 
> Push the check down into the callbacks whose counters really are
> irrelevant to per-memcg reclaim - btrfs_nr_cached_objects() and
> shmem_unused_huge_count() - and drop the fs/super.c gate. Each
> filesystem can now lift the restriction independently if its counter
> later grows memcg awareness, without touching fs/super.c.
> 
> Introduce mem_cgroup_shrink_is_root() in <linux/memcontrol.h> so the
> callbacks don't open-code "sc->memcg is NULL or root".
> 
> Fixes: 0baad6f9b997 ("fs/super: skip non-memcg-aware nr_cached_objects in memcg slab shrink")
> Acked-by: Qi Zheng <qi.zheng@linux.dev>
> Reviewed-by: Jan Kara <jack@suse.cz>
> Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---
> v1 -> v2:
> - Do not gate xfs_fs_nr_cached_objects(); XFS's inode reclaim is
>   intentionally driven from per-memcg contexts to free memcg-charged
>   slab (Dave Chinner).
> - Add mem_cgroup_shrink_is_root() helper in <linux/memcontrol.h> so the
>   filesystem callbacks don't open-code "sc->memcg is NULL or root".
>   (Dave Chinner)
> - Add fixes tag (Dave Chinner)
> ---

For

>  fs/btrfs/super.c           | 10 ++++++++++

Acked-by: David Sterba <dsterba@suse.com>

Thanks.

