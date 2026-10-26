Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31D2E6072CEC
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 13:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=MN6mgPWu;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=05B7c4jh;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=MN6mgPWu;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=05B7c4jh
Received: by kanga.kvack.org (Postfix)
	id 51EBF6B05BC; Mon, 26 Oct 2026 09:37:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F71D6B05BD; Mon, 26 Oct 2026 09:37:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40D186B05BE; Mon, 26 Oct 2026 09:37:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1AAFB6B05BC
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:37:42 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9DF79A7809
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:37:41 +0000 (UTC)
X-FDA: 85364879922.05.5FC8104
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf11.hostedemail.com (Postfix) with ESMTP id 47C1A40009
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:37:39 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=MN6mgPWu;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=05B7c4jh;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=MN6mgPWu;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=05B7c4jh;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793021859;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TxJaVovbBuzNcz8Fy84RB6HU15y4oYzEhr8Gynqfeyo=;
	b=MBqle3BIwKz6LfUEFNAqUJSHrTvVVymtBbnmjWbjf7uLwFH3qN41mTMrUjee5+sF9VmjsK
	v4ucyGLYMlJxXctuAdypLkBNKGZuQa56IeLE66hDoy6Udj5uI1fiaHpeWNl4dyF+DfwAIv
	sUsMMZ3QMu2eH1OK2XJ6buxHRigIWXM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=MN6mgPWu;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=05B7c4jh;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=MN6mgPWu;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=05B7c4jh;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793021859;
	b=Nxjs4xwde/t1ubhxyYqRHkPDXaCWxlxVlis+mrugbx9tmDHn/MRuOdhJ15h2TJB0YQ0Gji
	oHSsiF4jrtlsDeQ+DLxhF94qgBUdngMPNj3t4o64kguc2H7sFoBU3Q5IhBbIeVJzyjLcRD
	RPNc9L2Cm1QS5aHoR7O06lFAKvbuetU=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id F1CE51F43B;
	Mon, 26 Oct 2026 13:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793021858; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TxJaVovbBuzNcz8Fy84RB6HU15y4oYzEhr8Gynqfeyo=;
	b=MN6mgPWuP1dMIU3f6uNvt8/Zwy+Ji5bunevTMshqSLbx/zh7eOuT5DUVnLPIA5R8lA96xG
	obX9p/vOG6s2PCw2eLLOS/m91dwZCMm/coZmYjeUFVtlFNuYP0NpKdMocUAQ0cZuuepKxF
	/WUC6xGuccVuIWM+eBYLAzrnsWfDaNI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793021858;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TxJaVovbBuzNcz8Fy84RB6HU15y4oYzEhr8Gynqfeyo=;
	b=05B7c4jhEIx+f0zNUnBKAC8V0BIWFbQHS1oOY3GwthoQn9LNvy9JCMPjHuZKtN16WgIctE
	3h0TmcLgdHqKQwBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793021858; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TxJaVovbBuzNcz8Fy84RB6HU15y4oYzEhr8Gynqfeyo=;
	b=MN6mgPWuP1dMIU3f6uNvt8/Zwy+Ji5bunevTMshqSLbx/zh7eOuT5DUVnLPIA5R8lA96xG
	obX9p/vOG6s2PCw2eLLOS/m91dwZCMm/coZmYjeUFVtlFNuYP0NpKdMocUAQ0cZuuepKxF
	/WUC6xGuccVuIWM+eBYLAzrnsWfDaNI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793021858;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TxJaVovbBuzNcz8Fy84RB6HU15y4oYzEhr8Gynqfeyo=;
	b=05B7c4jhEIx+f0zNUnBKAC8V0BIWFbQHS1oOY3GwthoQn9LNvy9JCMPjHuZKtN16WgIctE
	3h0TmcLgdHqKQwBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C196C13408;
	Mon, 26 Oct 2026 13:37:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id aWmlJqFX32rQfwAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 26 Oct 2026 13:37:37 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 4E306A1419; Mon, 26 Oct 2026 14:37:33 +0100 (CET)
Date: Mon, 26 Oct 2026 14:37:33 +0100
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
Subject: Re: [PATCH 03/16] tmpfs: preserve explicitly disabled quota limits
Message-ID: <ohklmfrgb2zpi3xm5nmlqmtum2wwoo33zd6cyjy7vq2t5r5rbl@qdhtgbfr67yt>
References: <20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org>
 <20261026-fixes_shmem-v1-3-703206d5fa0c@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261026-fixes_shmem-v1-3-703206d5fa0c@kernel.org>
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spam-Score: -11.51
X-Rspamd-Queue-Id: 47C1A40009
X-Rspam-User: 
X-Stat-Signature: nefq7j1jb1m7nx7pmufurhzw3ctoo1u6
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793021859-499474
X-HE-Meta: U2FsdGVkX18YD7SfwFWVfMBbqY4ow4SmH7d0pajEV2Z0jFomH8oJZPtUqVzbBFrS1xuH+HBd7kNX3nJ9kdI51UsK5wRcFvhM3jGXTHKDR3FZN8ituJDVAosslDaoc4nANsUvfmVnjCbmPuO80gjH1QxOVFg7xmq5kjcobrJrFQcnH1fd/dMAoRCdVDyQNUO9g0tFEAfmtw1UAooOQjuE2tEHosDgSzkKwOUG7TJqa5lLwYLxwtu/CRa7slNJgoZXbpizVnxGCDucAoETCCuZSp4TYlzEttajU6voUSydtcbDjucpAYrL6JkCLIGIszHMKueu7wpUCoywpMetACMvG+qfUoaN/bvOV/fSYNSeANweVAjs9B28qKoko6wVZveafQQNAizMfKxaFAvq7CHreex3V5e3bI9+kcyND7m7Gx67BnPqQi5b7D0imn5q1PF45/NaokAh0GFn6P5I8ER4aypNGRh0n2wiQXtlreiDPQFHkURc9eky+SC7PBu1+7k8UkzCWGPAgNx/FrndJu6TnZHkIKvYzx4NqIl5M1Nb1jg+lGE4ieAwlpvTJv/YHMrgLXvQYS+1OZLDPIeO5KshHMBly9vYTypO/QuOTv63v2Qu48dJbRw4z3zHyzdqroiQsQpK2PkhVR2gO8l4b+/EktDARznb/71O6jO5MMhq6c+ifBFYzKj9HI2PvyEBOEijUrE3cK4wGk5U3x3c4JvQFTREzlDVhUjSQZ7GMYIvXur7xayGTKN0o/0Q8+51FJhpSzNta1KkuyvTm/HT93GlRozfYHVfG6vGmwJOhHbl8YvyMGNDTmlG8rqpH5dmBa4LVVge4uClkKWjJdNRaC7CvaHd57M/haskRC17ndPcbwOw+hmYIAJtRzEfc98gJ0SqpA3HolqaGMYsG7l7+7O4bd1/FSz8nSav5LMlY4fdJ99XN2zEmUs+fqRHYpAj5a8W8nGHE9/Qa+bphHugryp
 efj41fco
 4z0qQk72g7TyBSkNuKY4YPpitOeDcDxEECXQ3cc/JqP6TOeiIylfgPWiZT1TSEsEgZB5hDehlc/tcnLtF8RPMiOY2Ee+p23LOjeiFgVbPvLoYNO67bJOSLFxaTpBSNb47xaH177beNXStaSGwVAmuYZdJe5miNWVMKzZmyzhLVmNfvhoEyFNA3sMSECKD25/LEa8m3KXX+hS4nGHH3EBw1fSbXXqK91zFtnF0Nit5QUoui48EzrlKX4p4OFzwOMP5WvS0mw290nDygJsYsAQAvjUeta50nsArZ0A+RSTKVJs7fYfZFpBvQTc0Fr5XohnpLRr+vpbEVoVSeXscxHdxagv5HBKmVpkQUY68RXX/5cix9NVRY/cQccxpB0ZTeyAdICLe3fDdXT9oAYZn8ON7ZEQhc+/7vyDQf/9TR7E/MLeDcbJjXLTdCWOiOkUwHzIGe3E8o2dIDf34PHqF0400xE2jhUWUJCu1yCYhUmBHQHwRkxoeSP4Bg2LHiPuCdEaylLve6AtnqOUAf8FEm1mC3/8waw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon 26-10-26 10:40:36, David Hildenbrand (Arm) wrote:
> From: Josef Bacik <josef@toxicpanda.com>
> 
> An administrator’s decision to disable a user’s or group’s quota
> limits can be silently lost when tmpfs restores the mount defaults
> after releasing and reacquiring the quota record. This can cause
> later file creation or writes to fail with EDQUOT, even though the
> administrator has explicitly disabled quota limits for the user or
> group.
> 
> do_set_dqblk() sets DQ_FAKE_B when all block and inode limits are zero.
> This means quota enforcement is disabled for that user or group.
> shmem_is_empty_dquot() treats the flag as a reason to discard the entry
> from the mount's quota tree. The next shmem_acquire_dquot() finds no
> saved entry and recreates it with the mount's default hard limits.
> 
> If the cached dquot is reused, DQ_FAKE_B remains set: Q_GETQUOTA reports
> the restored defaults, but enforcement is still disabled. Once that
> dquot has been reclaimed, a new dquot enforces the restored defaults.
> 
> Remove the DQ_FAKE_B test. Only discard entries with zero usage, zero
> soft limits and hard limits equal to the mount defaults. Explicitly
> disabled limits are then preserved whenever the mount defaults are
> nonzero.
> 
> Explicitly disabled limits now retain a quota-tree entry, just like other
> limits that differ from the mount defaults.
> 
> Rename shmem_is_empty_dquot() to shmem_is_default_dquot() to describe
> the check for default values.
> 
> Fix generated by an LLM and sent by Josef Bacik in private.
> 
> Fixes: de4c0e7ca8b5 ("shmem: Add default quota limit mount options")
> Cc: stable@vger.kernel.org
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> [ david: code cleanups; rewrite description ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Good catch. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  mm/shmem_quota.c | 30 +++++++++++++++---------------
>  1 file changed, 15 insertions(+), 15 deletions(-)
> 
> diff --git a/mm/shmem_quota.c b/mm/shmem_quota.c
> index 43d3b4fd6cb1b..d191ebda3f00e 100644
> --- a/mm/shmem_quota.c
> +++ b/mm/shmem_quota.c
> @@ -239,7 +239,7 @@ static int shmem_acquire_dquot(struct dquot *dquot)
>  	return ret;
>  }
>  
> -static bool shmem_is_empty_dquot(struct dquot *dquot)
> +static bool shmem_is_default_dquot(struct dquot *dquot)
>  {
>  	struct shmem_sb_info *sbinfo = dquot->dq_sb->s_fs_info;
>  	qsize_t bhardlimit;
> @@ -253,21 +253,21 @@ static bool shmem_is_empty_dquot(struct dquot *dquot)
>  		ihardlimit = sbinfo->qlimits.grpquota_ihardlimit;
>  	}
>  
> -	if (test_bit(DQ_FAKE_B, &dquot->dq_flags) ||
> -		(dquot->dq_dqb.dqb_curspace == 0 &&
> -		 dquot->dq_dqb.dqb_curinodes == 0 &&
> -		 dquot->dq_dqb.dqb_bsoftlimit == 0 &&
> -		 dquot->dq_dqb.dqb_isoftlimit == 0 &&
> -		 dquot->dq_dqb.dqb_bhardlimit == bhardlimit &&
> -		 dquot->dq_dqb.dqb_ihardlimit == ihardlimit))
> -		return true;
> -
> -	return false;
> +	/*
> +	 * Defaults are zero usage and soft limits, and the mount's hard limits.
> +	 * DQ_FAKE_B only means that *all* limits are zero, which need not match
> +	 * the mount defaults.
> +	 */
> +	return dquot->dq_dqb.dqb_curspace == 0 &&
> +	       dquot->dq_dqb.dqb_curinodes == 0 &&
> +	       dquot->dq_dqb.dqb_bsoftlimit == 0 &&
> +	       dquot->dq_dqb.dqb_isoftlimit == 0 &&
> +	       dquot->dq_dqb.dqb_bhardlimit == bhardlimit &&
> +	       dquot->dq_dqb.dqb_ihardlimit == ihardlimit;
>  }
>  /*
> - * Store limits from dquot in the tree unless it's fake. If it is fake
> - * remove the id from the tree since there is no useful information in
> - * there.
> + * Remove the ID from the tree if it has no usage and its limits match
> + * the mount defaults. Otherwise, save its limits for the next acquire.
>   */
>  static int shmem_release_dquot(struct dquot *dquot)
>  {
> @@ -302,7 +302,7 @@ static int shmem_release_dquot(struct dquot *dquot)
>  	return -ENOENT;
>  
>  found:
> -	if (shmem_is_empty_dquot(dquot)) {
> +	if (shmem_is_default_dquot(dquot)) {
>  		/* Remove entry from the tree */
>  		rb_erase(&entry->node, info->dqi_priv);
>  		kfree(entry);
> 
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

