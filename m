Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1532AC79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 08:46:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8CBA6B008A; Thu, 10 Sep 2026 04:46:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E65246B008C; Thu, 10 Sep 2026 04:46:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D79BB6B0093; Thu, 10 Sep 2026 04:46:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A4FD26B008A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 04:46:52 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8F906140407
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 08:46:51 +0000 (UTC)
X-FDA: 85197222222.13.8DB54FD
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5B57B160002
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 08:46:49 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=OPeZe2mB;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=oUoJCIsW;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=TlFhXNxv;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=iSMWN7e7;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=OPeZe2mB;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=oUoJCIsW;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=TlFhXNxv;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=iSMWN7e7;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789030009;
	b=5OpDzWCHawDVjqleuGNaQtqmb67YdgNiIuFU+puwv04O9ccrOL/NhIobV70tXfjVaJQM9Q
	OPSU+TdExI6lhBwJvTkRLHx/PlkKLMQ5waosYtYQUaT3HsLyNHziHRDRu7t+Y1rbbmv5Yj
	2xrrX8mRoy3DojeCe5Ig9d6TQ7SieDE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789030009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hKFZgmV1DYh46za7nm6vYesF12VXdFrdx++kuKz7oSA=;
	b=reon0re+QURKjExKUlFEp/kg5vgLIFjh+p6C9rPpV0wDB76a8LGGZZL45blSofi6z3jPWU
	8hqWHNV4BV9DaqIeluyHdnmA4QYs1ENeZAQNPK3Gt9n2JOKg6oHrLhYPCWtX2s9t2YotQj
	ZPPdW9tADo4MUA4bWCdTFqA5Ah39CAw=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8C1EE1FD87;
	Thu, 10 Sep 2026 08:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789030003; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hKFZgmV1DYh46za7nm6vYesF12VXdFrdx++kuKz7oSA=;
	b=OPeZe2mBCNSZG9faUGgW76QSzjbES5lqawHvTyLRKgx3eWE3s/Z+w5p57o6nswvvEI4xPf
	L1EqrGy8H7Ze4u0VMdtCOpD/O/YtiKx59L7biyAJuQJSrh9l30pjIoxPDNxTdDGT+mby2q
	N5dEbPyBHlKHVY5QEJM/0+xOR5PVF7A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789030003;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hKFZgmV1DYh46za7nm6vYesF12VXdFrdx++kuKz7oSA=;
	b=oUoJCIsW/C800JcyNgaMTmZug869+ht/UC+RrRtfbMMXoo7o5RLWZnkyfm6P+4vB7BMSl1
	SMYzAmlb2pqh6nDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789029999; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hKFZgmV1DYh46za7nm6vYesF12VXdFrdx++kuKz7oSA=;
	b=TlFhXNxvk2ouWz3CBQCsAZH9hYkYbMu+7YKoQ68PEOkHWkgFLC1S9RcvzR010Rfk3zWdmE
	yUNSFotVPVC5LB6SpwtKPCct11BzLGnqH75n97I0Fer0vPb+kWkJC0tL7CkX9dzVdUKdJ/
	HqlPiLyHnjTfvG1gyiik3JkxPfuoURY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789029999;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hKFZgmV1DYh46za7nm6vYesF12VXdFrdx++kuKz7oSA=;
	b=iSMWN7e7+A/nJcB8ZGPd4+BYJR/w3drhvcON0l19ExQzzERsUwhnoRqgy2f04mkxMeWctS
	Hm0NKo3qHVp/9PCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 60A2A137FD;
	Thu, 10 Sep 2026 08:46:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id rZORF29uomolZwAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 10 Sep 2026 08:46:39 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id E0D9EA12EA; Thu, 10 Sep 2026 10:46:30 +0200 (CEST)
Date: Thu, 10 Sep 2026 10:46:30 +0200
From: Jan Kara <jack@suse.cz>
To: Josef Bacik <josef@toxicpanda.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>, Tejun Heo <tj@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Dennis Zhou <dennis@kernel.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	bpf@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] writeback: report a Tasks-RCU quiescent state per cgwb
 drain pass
Message-ID: <q6euw7q6hdfdzhadrwyc47j2lbev6kutm3vix7fi5v7aset2hq@kbv4uy55whd6>
References: <20260909-cgwb-tasks-rcu-qs-v1-1-967a7754771f@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260909-cgwb-tasks-rcu-qs-v1-1-967a7754771f@toxicpanda.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 5B57B160002
X-Stat-Signature: de5tsdfr893ekdztzx1d71owf5tpjs83
X-Rspamd-Server: rspam01
X-HE-Tag: 1789030009-72345
X-HE-Meta: U2FsdGVkX1/sgHGGsHKKTNNZlu2J3hSqBBr5ByYsmMGVeGgi9ScMnayA9tfZfwKrZAKWyZZ8wjcm4kQvwhwzJRAtF4zd55N6rRn/DN8HY99c56xd+4lvr0ASx8fHZbaGJ9lFDegpq+iEK7D3HQnphOvEnEAC5cO4giy6G0Hdr3/YynSZaboDcAwi/4vIh06wcuiosaavL7vD83bB3p1c8e8snh4120hjsaeD+P6w8Hb5uUuLGfp6hhVRk1eyDWl5OeuOidtRBIPaN9fejgFQw2RqehkzxcYyUj0hTxammJQ+aMcEJKTDHiAaaZwrtJVGcQA9IOqU94DrFikmNCdPxU7BXkfKL+NwIdZQavHnPfasqO1LsI9HGQW78W9juFaevWk3R13YTu+49O9O+IH/WCUbm9oMf/ipCyaglp+iIrtPqDfxrdomyuLOe8iFlZ7IVbjKnOKEF+UqDaC9Iu0T+tSEArfzXiAPwO996oRaUuPYv5mpN+79D+VL+T+Mvr9LDw9k0TgxJu+5FvYTlBBNCS/zsfcRybQLOjxcBlhMlG5vC1mzDPDwgwcsm8c12ko4eJqsbjRzvI05rfGfJiUMDupRfGjcarUvjo9oPOsHsoB2jMH2xybzMdLSn+4jb6DApV4cU1jiar9KIcK6ifk4OshhnTwGK5J5QDO5av/kB5AtM6lXjM+zupPDoIVng9zLRknQtHB//oy8s9DM0RbXNzy67oorYaIDWl4SQVvFKRjRZgA8UQdiuLq8IAeRCtE3BNCLR/N1cWlNLxCnrEV0DS+fWOWYYpohcsShgRMQuF/eri4GUxeWplcCZCQ/G7sRT4/giRjD/JewV6HWm7Hr6hikCqgodYou7QPiAU5UkyOC0pzQ9RBmtR1pxz5wy45FZc71JET09l3rMf2UBMmv/l9U2B8AGYO5gwisATi8m31lkE5xs9Shg5SvsflcgKz1U6kfiHQC0yr4VmsZCVb
 0kKmzwS4
 daqD/z2H3Ww5DkeYoaSRxBhjemB2RjBtbNT0+d4Ix6cR9YCSnd7o2MXsxaiK1P8Pq2kf6r4FmvsoEzC+1foPZfxrkB0Xu/WZ0iLbIKBpN3xGZg9cpN2AnKN5psGrvmVPAu19EooBgJ3wXy5rqu7gjhYLTK+2UcUIA90e2C4x/JmOw5emsPkbb0+xZu1aRbdU8agzYqj6llQ/zT65N/X7hULAYnJOzDHEU/mMjeILvnGJQTmZKrqvw44qgluanFn/jumGcup2oxJcmJ+e+BlAD6CppWnvrw+zisT8htiEo4mk+u21XDBda7hmQI22mM8lrQT9TJ0balFHOlv4bf3Pdj/Iq+TEdrGM7TifaVw7WlLmIT9YaE8Tm+dcvKOpTft3byG5Thz7zghPolRqH45JVyVWiZJhu5N4YfWj6XNuDkR2hz8Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 09-09-26 18:01:07, Josef Bacik wrote:
> cleanup_offline_cgwbs_workfn() drains a dying cgwb by calling
> cleanup_offline_cgwb() until it returns false, with a cond_resched()
> between passes.  On a CONFIG_PREEMPTION kernel that cond_resched() does
> nothing: _cond_resched() is a plain "return 0", and under
> PREEMPT_DYNAMIC the full and lazy modes disable it.  Since commit
> 7dadeaa6e851 ("sched: Further restrict the preemption modes") those are
> the only two models on the architectures with PREEMPT_LAZY support,
> arm64 and x86 among them, so the drain loop never reports a Tasks-RCU
> quiescent state.
> 
> A worker draining a cgwb with millions of attached inodes runs for
> minutes.  On a 6.18 arm64 host in lazy mode the cgwb worker drained one
> dying cgroup's writeback domain for over 11 minutes.  A BPF program
> unlink (bpf_trampoline_unlink_prog -> bpf_trampoline_update ->
> unregister_ftrace_direct -> ftrace_shutdown -> synchronize_rcu_tasks())
> waited on that grace period while holding the trampoline mutex, 42
> tasks queued behind it in D state, and the hung task detector fired at
> 614 s and panicked the host.  Any BPF or ftrace detach during a long
> drain inherits the drain's length.
> 
> Fix this by calling cond_resched_tasks_rcu_qs() so we do not stall out
> anybody who calls sycnrhonize_rcu_tasks().  We put this in a do { } while
> loop because if we have many small cgroups cleanup_offline_cgwb() will
> return false and we will never call cond_resched_tasks_rcu_qs(), creating
> the same problem.
> 
> Fixes: c22d70a162d3 ("writeback, cgroup: release dying cgwbs by switching attached inodes")
> Cc: stable@vger.kernel.org
> Link: https://lore.kernel.org/bpf/9d444098-7c03-4163-af12-bd0a79a51443@paulmck-laptop/
> Assisted-by: LLM
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Makes sense to me. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

And I fully agree about the fragility. It looks as an oversight that
cond_resched() doesn't imply RCU quiescent period after the recent
preemption overhaul.

								Honza

> ---
>  mm/backing-dev.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/backing-dev.c b/mm/backing-dev.c
> index cecbcf9060a6..18e999053bae 100644
> --- a/mm/backing-dev.c
> +++ b/mm/backing-dev.c
> @@ -910,8 +910,9 @@ static void cleanup_offline_cgwbs_workfn(struct work_struct *work)
>  			continue;
>  
>  		spin_unlock_irq(&cgwb_lock);
> -		while (cleanup_offline_cgwb(wb))
> -			cond_resched();
> +		do {
> +			cond_resched_tasks_rcu_qs();
> +		} while (cleanup_offline_cgwb(wb));
>  		spin_lock_irq(&cgwb_lock);
>  
>  		wb_put(wb);
> 
> ---
> base-commit: 893e11787f78e43b534e252249ac3fff4d1333f8
> change-id: 20260909-cgwb-tasks-rcu-qs-42341609f3e1
> 
> Best regards,
> --  
> Josef Bacik <josef@toxicpanda.com>
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

