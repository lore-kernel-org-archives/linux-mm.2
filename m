Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3771606A320
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 10:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=ed400UsX;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=tUucHde+;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=xocIytMU;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=R0i6ft9d
Received: by kanga.kvack.org (Postfix)
	id 9B6806B05B1; Mon, 26 Oct 2026 06:53:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93FC46B05B3; Mon, 26 Oct 2026 06:53:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E0306B05B4; Mon, 26 Oct 2026 06:53:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 533356B05B1
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 06:53:26 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D214BA0743
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 10:53:25 +0000 (UTC)
X-FDA: 85364465970.24.C3B11BE
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf05.hostedemail.com (Postfix) with ESMTP id A96CE100007
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 10:53:23 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ed400UsX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=tUucHde+;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xocIytMU;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=R0i6ft9d;
	spf=pass (imf05.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793012003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k1RCdtni69C+1UVdBc+qzFQLzm/+KaRJzjIw3dpE2tY=;
	b=WT0/4ikd52D80nGGEm8141LJhjh/sRLxadoh2QSLVxrGVNEJoItnumg7eG41c1gwPHf13W
	uMJvmiCrYS0u/+h3KHMg5OS9EW8U9fiABdKVy5XQon4WJylBpa4Fpnr1sTSjOx3n6U2Ww1
	LGvzbM0N4PZtDnJMHIIo+jF+X4y+snU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ed400UsX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=tUucHde+;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xocIytMU;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=R0i6ft9d;
	spf=pass (imf05.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793012003;
	b=53Q0gPyo50vuQ+dunHkw1FpOu1egzrsJoqnkZ+caJw9Ab78wxftFtA2pApJkuVXAItOxdr
	P/qrcgLbLwj1lecNOBABt/eN898f2tu8BQEZWCK8Y1WoQdydazwtTi1I3MHf9Nzs0NCQgZ
	DIJ69P2Z5Cch09FP2wf8KgdiMuxdzDY=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id F209F1F7A2;
	Mon, 26 Oct 2026 10:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793012002; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=k1RCdtni69C+1UVdBc+qzFQLzm/+KaRJzjIw3dpE2tY=;
	b=ed400UsXAso6BW/wyEwJvJapoCoBHUou2hngO1gewoN3xPEXQBFrmiDVkL5L9vV0hNdJO4
	zeXA3NNR3k2aIgAiO2LZ4X8dgNzLEjgl8WTdN0n2U+C3Tj1fMTkp8RoqBkF6Y1XUKYr1WK
	3d1qE4nXnV/hHS4JnYJHBVx+1MiFZXs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793012002;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=k1RCdtni69C+1UVdBc+qzFQLzm/+KaRJzjIw3dpE2tY=;
	b=tUucHde+OA6NCb1T6GlA879m8xaqWIEj/4+VfyPKchB/+zoYdBTlyeexGxuWt9ogJEG2B+
	N956QSRYNZyJ+FDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793012001; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=k1RCdtni69C+1UVdBc+qzFQLzm/+KaRJzjIw3dpE2tY=;
	b=xocIytMU6LwOXdZ5xAK0bkBCMoUz3UzVF0YWS9/4b6maSmG0c0LPItFSD0Wn9D3oDfad54
	tRjiVhPPqZV/BHYdddy8x783SR3E0d6WM3s1SHC+VpcyA91fMHhHciYMWRExrSsI/RyOHG
	tyuybgitcFAM2Pd6MGBhFL1Pdbyo9gw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793012001;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=k1RCdtni69C+1UVdBc+qzFQLzm/+KaRJzjIw3dpE2tY=;
	b=R0i6ft9dQL6XEhF6tpyEHkZcy6UN5r5YkOJP7d9NHmq8nzpuUXu311xWts6ehAGuN8XnXJ
	0geX/Ic2Me0chfBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C777B13319;
	Mon, 26 Oct 2026 10:53:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Ehm0KCAx32q/UAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 26 Oct 2026 10:53:20 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 4DD5DA1419; Mon, 26 Oct 2026 11:53:20 +0100 (CET)
Date: Mon, 26 Oct 2026 11:53:20 +0100
From: Jan Kara <jack@suse.cz>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Gregory Price <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, 
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Lukas Czerner <lczerner@redhat.com>, 
	Carlos Maiolino <cmaiolino@redhat.com>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Daniel Verkamp <dverkamp@chromium.org>, Jeff Xu <jeffxu@google.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Stevens <stevensd@chromium.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, William Kucharski <william.kucharski@oracle.com>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org
Subject: Re: [PATCH 02/16] tmpfs: keep the quota soft limits of an unused id
Message-ID: <xre5aqctyk464ao7gdrg4fzbamccmo2w5jnqxzultltfhm43gm@xtab77j3yetz>
References: <20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org>
 <20261026-fixes_shmem-v1-2-703206d5fa0c@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261026-fixes_shmem-v1-2-703206d5fa0c@kernel.org>
X-Spam-Level: 
X-Spam-Score: -11.30
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A96CE100007
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 6dyceyqdstmaobk4gs4o6tdugoh8ws79
X-HE-Tag: 1793012003-789101
X-HE-Meta: U2FsdGVkX18QlSizfYE7xHt1sPxlQAXAqyv/oo55zxlQ69Wc4dUa0Bt/WGgbBQbsreVzcRE/DzqxOFUm8TN/dz7YOPQiM0Rym5uGayfWntpGmDhAkygBAOGage4DiArVk+lGJAG6dyWk0TJZdEmLzF6HxWdBAQAW2nK0ygydN6mdMn8v/ULLZhliteuXvwIheRPzLpPT9H+e6dICNjgPrtN4tkmeDOxCC+McnXRpfoi+qOWHZLGUT8Wez0SKsroQmGIWeNFPFrB8A2Rb3rlsFFVviKgVixx2avbJQPQqcJmuClhvvs2ATTIv7vvV3po7JMHAUo2hHxKcNjXQpBLYk1y+Yy+rMrRTE/a+XrTAUVHfCsJq1mzDuLNynleBsTh6RkNVuHPWiiP87qs39daZR9lNQs8qBErRmdzyDveZxOQV6u+gP9+n7JIX//uzQukLsgpWwMEZwydY9kApYuzI3RztL/McirM7WjCUI+L7epXG1I4lnVjpyyD4cMuSd+Z6D3ZGI7XD6pbGGJmtTLSvloUHyKf7UYjhQpbBfCp6Rv2XkMnGAjvESQijIR1M2yG1JNeulWiC0DEaDuxBIjji5wvvWQerMD8gAyaJK53b/Awj5V6+gq+Bm+9qSaJ32SLpAThUV/FhJKjpreGsOsYK2YfEvX2BPjJr5UIhBfceLYIAORQSeY1tcsb1BzBh8xEYHA9c7QgjTQwx1v9dqjdloI6kmAJvy9M1Ggr6D5Zr7K1FBBY781ATfiR0RCinOQwbyIlj1y41BUhTeKcTfGODGL1XsUVuG2SmKkndkN+3G6Ifehq2xGnRM1g6vg7Jvroy73rLnsKq15wBH4cyUqicGAVyBdDA785mDOqwdsXnVJsww7SUbM3jxFSHOh7TVXc2UBj+dxFQ6ebX1TXYuij2i2/zkQxiFcxp9NFWs2WvD/DRB3FH5sF6IHL7SqrHrpMkkpfO5zXJcHK3tlVGe2j
 FqFVnuB0
 m3ejys3YQ0HvrA1xH+LBwsI8v1Cyju5bM985we5zVAFWD2MY2FnZn0Z5Ry0pxtoddzkptivyVYnikf8no/0mIwJAkky1Zd6CLObsaajntyJi1IIxd16Knsoe3CYWTlX+7tqyjiC89eqYhJy+jSyZS/rCRr8Otnp415k5oPvhjs48IqHYHMQskQyRwK6g4lHiILB6qyJgXImXC87QXa4ilBe4ko906uH9Fa+U0veS0kdbOl3d18IGQ1LowNJkc4Vjgetr53wQqVw+UfQCsgxdCnvEgan0dIdBc+0mWL0McEqeKxu/viWKwnyg2iDX3XY/69DYfTShY8lyq/Bden9sU8WoirVHcaKE6ud74KQgYWF9ylYy9rETL9e0Yfzks5PQfu458vYPQxnNfhDGKKrgtyVTguK6iPpnF9eSMDCe3ZRIkbBtbwEmHVzuQns1YzLSvPzz1nS9EQyJ+vqE96tSo/npAlp6RGW2d5uUuqEQ7nNkge+kRFWx216+C1S45ZK9SJ7ueucnaO+ade3aARR6Mgvovsg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon 26-10-26 10:40:35, David Hildenbrand (Arm) wrote:
> From: Josef Bacik <josef@toxicpanda.com>
> 
> When the last reference to a dquot goes away, shmem_release_dquot()
> stores its limits in the rb tree of the mount, unless
> shmem_is_empty_dquot() says that there is nothing worth storing. That
> function looks at the usage and at the two hard limits only.
> 
> So if the administrator sets nothing but soft limits for an id that owns
> no file yet, the entry is thrown away as soon as the dquot that
> Q_SETQUOTA used is released, and the id never gets to see a limit.
> 
> To fix it, compare the soft limits as well: an entry can be empty only if
> both soft limits are zero as well, which is exactly what
> shmem_acquire_dquot() sets for a new entry.
> 
> Fix generated by an LLM and sent by Josef Bacik in private.
> 
> Fixes: de4c0e7ca8b5 ("shmem: Add default quota limit mount options")
> Cc: stable@vger.kernel.org
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> [ david: slightly adjusted description ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Good spotting although I consider this pretty minor (unlikely setup proven
by the fact nobody complained so far). Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  mm/shmem_quota.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/mm/shmem_quota.c b/mm/shmem_quota.c
> index a3fa4bd93e753..43d3b4fd6cb1b 100644
> --- a/mm/shmem_quota.c
> +++ b/mm/shmem_quota.c
> @@ -256,6 +256,8 @@ static bool shmem_is_empty_dquot(struct dquot *dquot)
>  	if (test_bit(DQ_FAKE_B, &dquot->dq_flags) ||
>  		(dquot->dq_dqb.dqb_curspace == 0 &&
>  		 dquot->dq_dqb.dqb_curinodes == 0 &&
> +		 dquot->dq_dqb.dqb_bsoftlimit == 0 &&
> +		 dquot->dq_dqb.dqb_isoftlimit == 0 &&
>  		 dquot->dq_dqb.dqb_bhardlimit == bhardlimit &&
>  		 dquot->dq_dqb.dqb_ihardlimit == ihardlimit))
>  		return true;
> 
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

