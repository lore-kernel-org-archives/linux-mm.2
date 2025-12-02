Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A374CFD376
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 11:01:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 647A56B0005; Tue,  2 Dec 2025 06:01:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61E736B008A; Tue,  2 Dec 2025 06:01:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 534B96B00A0; Tue,  2 Dec 2025 06:01:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 402256B0005
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 06:01:07 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EF12C1405D8
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 11:01:06 +0000 (UTC)
X-FDA: 84174238932.06.644CB97
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf15.hostedemail.com (Postfix) with ESMTP id AD130A002C
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 11:01:04 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=BsigXTSk;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+zyTFxGC;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=B8T1ZMee;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=O8KgmaIg;
	spf=pass (imf15.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764673265;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eL1k6OzgMQQLmwBTWiq3h/Cj6eUJKa3OgIBJUfzx080=;
	b=iT3nlraeBMzPKUCCPi35+xT5ruO/tlkOHqK49BU4fxzLMxH3rZPQCl2NsKlsjrhiEPwl9B
	K5UBbFjzMmCo7QcPlblxXpXrg/SvC+5KNsrpam0zgSmS6DqaSD3a3YYGY4L3K9Bl4/ccSW
	Bp+UuyFChJOtfJScpI/x0xgZStW463g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764673265; a=rsa-sha256;
	cv=none;
	b=zSjUH7Mb/bu59Ry1w5VeSyYKN8qsRm6nMFRhTgjZDSM4te5hg59lMNLTxzwRbEAE+baWSf
	m/IwMJQ6L7Ov2bCXoSzV9QUlPuKoR3OL37I5dRPDiQnO/Jg2Kx6DJtbo4op1Xs9IpWo4xM
	dthSM1BlOrbhEXlBi15rgL7guxc4aIY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=BsigXTSk;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+zyTFxGC;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=B8T1ZMee;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=O8KgmaIg;
	spf=pass (imf15.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 31FD833697;
	Tue,  2 Dec 2025 11:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1764673263; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eL1k6OzgMQQLmwBTWiq3h/Cj6eUJKa3OgIBJUfzx080=;
	b=BsigXTSkyjLR0gKtAt4fyLHlzOjstxNoyYTf9qOt7t8jYMUlD5f3AA9C50ef6QNH7GnO4n
	C29e1ZAgpFssl0Pwk0U3So4hXlJUvS74rugXM82OD5OyIuWUysVaur2jWthHFsgyj7JK0Z
	vd1+6EqDvEkcBcFHEJzsfeIt2wzmx+U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1764673263;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eL1k6OzgMQQLmwBTWiq3h/Cj6eUJKa3OgIBJUfzx080=;
	b=+zyTFxGC4sTS6pK9CS/xgX12/hNwUV0HXUhINHABNufIUDIt9n91RX3eZKrl7cBihrM7Y5
	E/eLl7L8WFQq22DQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1764673262; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eL1k6OzgMQQLmwBTWiq3h/Cj6eUJKa3OgIBJUfzx080=;
	b=B8T1ZMeeFRvDjIKkrUyEixQpuzn3Ad2NTLJAB8rLbXnyP/QYZrAwJOW1WP/l7/7sFaT0ny
	8hHiAYOxa8JcuERitU/RmwOAusnMnt2Hqr4QcUpvRA1swJiAauyhSKgMCE07jGp6v9kS1E
	SJgoneDvxCC8u5/uxfDP7R3/MR5rzDY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1764673262;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eL1k6OzgMQQLmwBTWiq3h/Cj6eUJKa3OgIBJUfzx080=;
	b=O8KgmaIgxsMJvHRl0os8BEtEhw09yUasQQWcI0d6EoQJjE348SkjAmwnckt55Cycqc+7dO
	RfYxbVsORyPRLOAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 22ECA3EA63;
	Tue,  2 Dec 2025 11:01:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CeZ/CO7GLmk5NwAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 02 Dec 2025 11:01:02 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id CEEFBA09DA; Tue,  2 Dec 2025 12:01:01 +0100 (CET)
Date: Tue, 2 Dec 2025 12:01:01 +0100
From: Jan Kara <jack@suse.cz>
To: Chen Ridong <chenridong@huaweicloud.com>
Cc: viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz, 
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, muchun.song@linux.dev, tj@kernel.org, mkoutny@suse.com, 
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com, jackmanb@google.com, 
	ziy@nvidia.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, lujialin4@huawei.com, chenridong@huawei.com
Subject: Re: [PATCH -next] cgroup: switch to css_is_online() helper
Message-ID: <dzp6jxmf5ggidkhmqabuttaotyrkxzf6ohiuzgcdn6oppkcmfc@vrjeeypoppwe>
References: <20251202025747.1658159-1-chenridong@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251202025747.1658159-1-chenridong@huaweicloud.com>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: AD130A002C
X-Stat-Signature: ytarnqnyrskhtzh538bxk1meco3dhfib
X-HE-Tag: 1764673264-984661
X-HE-Meta: U2FsdGVkX19YOKSa0NpiQNYUrx438OBNg4onXIP5uV+RniYXQ7RVwiz+UH8cLSPTX4kL4W0ORfqVrnaRXzQJHPuOm9A0/UqGdRvsdxv1X73ZucKWf6QxpSbM4onvwy07eNoUIUaOq9uHveVm+up4w62Pp2EJvdvwNtHZmBydLJrdMGsCBK1s1sfb1SmLlmFMFsbdpecj/hmHXGfxyzteE9M+cFvqK9tJMLq9P7x1EheZWRjD+u2psr9N+XTXoq22GZ2WgRHg2EGFleWurNyVHiqmoY9mUFMjyIi2ENCZhVd8LI5KJT2F2ULxPdHgr+3cDWlm+XDP1A2rXPP7luqQ4pfH2U+gFJ75tkfj9kCgDA5IuqKBXdZteFmOMLQPglBpZwPUCO1oztDW4yoRKrQscMt1r3wkS/IUxPdFutgvAm4KIRoEUMYcdJ6oNeCr0lPB4Yh5sVnSAmtfyQNB8tEH3JS2u8N+Jj2GKLQRnPABwrQGgPmWHNeRi2kv6HjNa0/wN4p9ko6ThMHSgzqQgQIcfm3z3d8KJ691ylUhgE2tfxR/Xcqx07AIvTw5mI80trKUlDkYFYVG1/I8B+0dTwlOOhSpBeuxAm5K69UqdjTI5DfKTBGSiglen3gXsCFYfjjtJXXAuu53aONlPr2p+fAsq1NAN4/V41lK/vLLp77Gyuc7JHQwTgBJ4p56AObyT4aU22Dr6GPfN7U5COhiHK8clSFFWAjwMq+k2PazQjAN4RybtlnTLZYL/P5XcYu4TAJlAtEwNyUMOJSNZBoJuqASAgNqpI2PrLwla47jRvLbp8SZu36bNrMWb/GgrzJzgSDkfwegmE3Rn3xXvzwdQZpzs0o5h9fRLg5N5avcDhYvp50QVxLzbilzap4TZiYse7D1MeNmHVBmmCTh8HVHktPn9Zwi67BDj8ZqguPSvmR6oqySGiSMfDzHOZucB5/St8TNlKh8fDIQNjJSEAD8CB8
 0vLhgiV1
 KbDRdbTri/wVx2dXzDzHKq+ubZGdjuw3SooIit1GejbX/V05p0KzMRL13Oimkg9WRf5PD0isf4xwYd2TVgB34wzBMhFD/aj+roxg2BMWuHtPFAzDk1frZY/agPXsK7HPSw3jDbfZnfl90z2gb7WZEkIqUU6QW4i3Sgt8RppoyF72E40FZ8keQwi+3HS3InRFtPXe/qkJMmgfgpj0q3vDSFXV0GyjYmABBjqVuveQOoLo4IwztlKRIeK0XPC9bwHL3ieiaT9d9DOGBAd1U+TBux9ik+oE/u5wDSBVE6fr9ueiJfXcE5RDy01RTQe9b0esfR/LBcYrlGuZYf4BVADXVHg39oyIrciPnYeGC4BhWPoGUMl8DynWEVUTs0B5IDEzMWAU+4dGq1CPVpjWwpgtewWFuk70bfFbDGxPKS+1HGrGJP/YnMfiKpOyEN1LhCLwkgeNH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 02-12-25 02:57:47, Chen Ridong wrote:
> From: Chen Ridong <chenridong@huawei.com>
> 
> Use the new css_is_online() helper that has been introduced to check css
> online state, instead of testing the CSS_ONLINE flag directly. This
> improves readability and centralizes the state check logic.
> 
> No functional changes intended.
> 
> Signed-off-by: Chen Ridong <chenridong@huawei.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/fs-writeback.c          | 2 +-
>  include/linux/memcontrol.h | 2 +-
>  kernel/cgroup/cgroup.c     | 4 ++--
>  mm/memcontrol.c            | 2 +-
>  mm/page_owner.c            | 2 +-
>  5 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 6800886c4d10..5dd6e89a6d29 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -981,7 +981,7 @@ void wbc_account_cgroup_owner(struct writeback_control *wbc, struct folio *folio
>  
>  	css = mem_cgroup_css_from_folio(folio);
>  	/* dead cgroups shouldn't contribute to inode ownership arbitration */
> -	if (!(css->flags & CSS_ONLINE))
> +	if (!css_is_online(css))
>  		return;
>  
>  	id = css->id;
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 0651865a4564..6a48398a1f4e 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -893,7 +893,7 @@ static inline bool mem_cgroup_online(struct mem_cgroup *memcg)
>  {
>  	if (mem_cgroup_disabled())
>  		return true;
> -	return !!(memcg->css.flags & CSS_ONLINE);
> +	return css_is_online(&memcg->css);
>  }
>  
>  void mem_cgroup_update_lru_size(struct lruvec *lruvec, enum lru_list lru,
> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> index 1e4033d05c29..ad0a35721dff 100644
> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c
> @@ -4939,7 +4939,7 @@ bool css_has_online_children(struct cgroup_subsys_state *css)
>  
>  	rcu_read_lock();
>  	css_for_each_child(child, css) {
> -		if (child->flags & CSS_ONLINE) {
> +		if (css_is_online(child)) {
>  			ret = true;
>  			break;
>  		}
> @@ -5744,7 +5744,7 @@ static void offline_css(struct cgroup_subsys_state *css)
>  
>  	lockdep_assert_held(&cgroup_mutex);
>  
> -	if (!(css->flags & CSS_ONLINE))
> +	if (!css_is_online(css))
>  		return;
>  
>  	if (ss->css_offline)
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index be810c1fbfc3..e2e49f4ec9e0 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -281,7 +281,7 @@ ino_t page_cgroup_ino(struct page *page)
>  	/* page_folio() is racy here, but the entire function is racy anyway */
>  	memcg = folio_memcg_check(page_folio(page));
>  
> -	while (memcg && !(memcg->css.flags & CSS_ONLINE))
> +	while (memcg && !css_is_online(&memcg->css))
>  		memcg = parent_mem_cgroup(memcg);
>  	if (memcg)
>  		ino = cgroup_ino(memcg->css.cgroup);
> diff --git a/mm/page_owner.c b/mm/page_owner.c
> index a70245684206..27d19f01009c 100644
> --- a/mm/page_owner.c
> +++ b/mm/page_owner.c
> @@ -530,7 +530,7 @@ static inline int print_page_owner_memcg(char *kbuf, size_t count, int ret,
>  	if (!memcg)
>  		goto out_unlock;
>  
> -	online = (memcg->css.flags & CSS_ONLINE);
> +	online = css_is_online(&memcg->css);
>  	cgroup_name(memcg->css.cgroup, name, sizeof(name));
>  	ret += scnprintf(kbuf + ret, count - ret,
>  			"Charged %sto %smemcg %s\n",
> -- 
> 2.34.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

