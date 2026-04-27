Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DEFCFF885E
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 10:43:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AA976B0088; Mon, 27 Apr 2026 06:43:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 633C16B008A; Mon, 27 Apr 2026 06:43:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FB2F6B008C; Mon, 27 Apr 2026 06:43:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3A2116B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 06:43:57 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E97921B6CE0
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 10:43:56 +0000 (UTC)
X-FDA: 84704000472.06.3FF2F8B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id EBBE81C0004
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 10:43:54 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=cBxhYKn2;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777286635;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yHc8GQfAvQM9wZtiRmGzTQ9yD7ywvB6nLxZK7qWXTNA=;
	b=x7l3MoUqAdm2IIvTM0OM7/gz0nkaAwjDBSWkWjq8TntdZv/R61urjKRmSkqh5OT62zwiQZ
	F+7EkgQfxpZOyJGDQgDKH+nQmcWwPpqMieUnyHCILJcOpnC4ZZCJH5aO7zGX0fFQxeyCz1
	y1thS5J/ZBvQUc1sUMwfFxNZMkNeTVs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777286635; a=rsa-sha256;
	cv=none;
	b=a+w5R+MNt3eR0mZwtCU/XW7zTxhnK4j6aPyYco1VwuZYIXKx5ZiDSMYHKhMbrcYE4bRsjz
	1xB50kzIo3FfUTOMBRaQqSHB/qQAXeOJjasQTSUjK1nvWzMGjanDl5x+bzoBd5FfnvbXDs
	SAofCbxvvqghTtu67FYA4okzqnO+5Go=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=cBxhYKn2;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D711D403BD;
	Mon, 27 Apr 2026 10:43:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FAAFC2BCB4;
	Mon, 27 Apr 2026 10:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777286633;
	bh=Kh7VcPD0UebwKcjRW9kxX/xxEb3tquDORcfCNx73BBY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=cBxhYKn24E4Wff8v3kXMyY9v06fkDcfNPYR13C38R/VJGwODif4B3dVKpG80pUgxo
	 GXfocFV0PN11rCXvgqvSsSJYTfaUPVJDqCSecYbITJRuoDlepAjKMo1zuywuCdIObE
	 IftviacLyiYyKDbEl8ibEIa0chNKayx/bs8Ge6qs=
Date: Mon, 27 Apr 2026 03:43:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: shakeel.butt@linux.dev, syzbot
 <syzbot+7d60b33a8a546263da7c@syzkaller.appspotmail.com>,
 Liam.Howlett@oracle.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 ljs@kernel.org, surenb@google.com, syzkaller-bugs@googlegroups.com,
 vbabka@kernel.org, Muchun Song <songmuchun@bytedance.com>
Subject: Re: [syzbot] [mm?] WARNING: bad unlock balance in do_wp_page
Message-Id: <20260427034352.6ca48156d613319aac415290@linux-foundation.org>
In-Reply-To: <3591c663-a4a9-4c22-97cf-b58b2e7d8a41@linux.dev>
References: <69edca15.170a0220.38e3f1.0000.GAE@google.com>
	<20260426034938.db29d74982a8eb8463f8cf3a@linux-foundation.org>
	<e7187a21-7114-4f42-bf8b-90d6e6b54fa2@linux.dev>
	<20260426105532.43768b24a42744f1b52fdff2@linux-foundation.org>
	<3591c663-a4a9-4c22-97cf-b58b2e7d8a41@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: EBBE81C0004
X-Rspamd-Server: rspam04
X-Stat-Signature: jqadaxsm8mq58hdcpbbmde66dwmgeinb
X-HE-Tag: 1777286634-460959
X-HE-Meta: U2FsdGVkX19M4jc5frv9rUdBvuJoPOkpU3e3Tku+JqjEr/7EdIStM+STMulUJOmJkmXrvoFesXRq0Zl42C1BNXRrFX09Yd6AHtYOE5ppZp0QRCrzy7WDFfJTVkDFXkBKSAln9N3Aozoj+I0kuouk0xcBh2pmospzoscnuQaEpgQSyWUqs/1+r5Aa3jR4wLwBJiRiL2qP6QsWvsS00JWmb5hTU9hxXJ8q0sMswvVZ/wz44Q98vJ7IDB2iQ/hEK+nn+vKqIln6YDgyYO0Lj8K19Ov5vgs0ZNJGL1ZBdef7Y0zWz9sIqsekWOgr5bJ8VmwcJ+WK4H5DRXXqTeJ6+yFst+VF2oeex65xUSZwpMq24S9maWbs6Q5pJKKzB53IPsq12a0x/4TpLOn/CKTiVQzDEMaHm3C11ku3oiSb2T//CUTI9b9jl+y01KNymfZmp8SlYd3/yGW2JRMUZlUq6VE9aGR+A848JvkH9LB/KH6920ubsccqSQ8S4TRWZvGaYE7x0o5lHFQpTJajHtZEoVEXle6+ex+YpSWiX0NwmXUXCy5n4B/2CF/05uT7zQ1QTvmFHfId6SG1E9VBZRwYDHAx/Wau0/FJoSoEbt2IvSa3hz5P24W95VdeW88kKRLkkknmSLPnJADEKLCa/sFLuVtEGb6URW/ebKCGCyl0w//tMm5ORrcTk8391KGAcUCQtkO3PAf2dPIhDt/W1yuTq9Tpr4Z2rLWUjVl+inUrlog7T/hEBkBkscChZ3glJUmrm3gNJLx8s8tLebg07zFeoyvRcoZYCo1e/PacQa8z4gOTEvkC0hFaLmEj8jVsbu8Y1IA0Pl3NcrjAlsqbdThwtL2x+WzhMyoF+TKDF+MJKwdYZanWno2eE/FC85Mtq4D0Fx9Aixqs4a1Vmry+z6ShGbcPORGvQZf79mOFc/BA+KXrxtdsssKb4KC6bPNaR/a7Go801auASUUjp86AdTEmWwc
 PSDSTnCG
 azDTqdD0Lpq+1awiaCCp/WnXnIbUr3mdoTRchwEotYubTJZHkRR3lwa04nDJaJeHKDXP8UukspfWqmuI2yO5cc/yQBJABzXEDmjjmnqHsi7C/zLprhi7UzhVSqJJyrfD3/totpIsFTXMDrdUn93F4E7lV2uhr7TMvIV17RD6XFdF9uUENh+7YpOS5mA1V7hOBdZSaQe1tPXS5HGgGoE1cUqzfG75AGF5DJe34qSsrkpg/TxGOnKFLsWtUlefCqdjpXsCH8mgQ3WAK88dgqQ5/ToX7JGJYz/9PwVgB9+D/vmtPeHnIfLb7BKrnSUwSWiFf/dWIRNiBIvyd47htnJyrGhdZKwutiatEU/Ri46nsOXma+dNPYjyR9z32o/TIe0P6+ewGI6MgulQhr9oQbR4rFI0W/fP0AOp7S1fm/IeI3UMU6iG5bcaahhp3miLNg8ubTLDd7W69KeCW1nTQ1s/3vtrxLlAlhbSG5ngX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 27 Apr 2026 15:24:10 +0800 Qi Zheng <qi.zheng@linux.dev> wrote:

> 
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -805,10 +805,15 @@ static long memcg_state_val_in_pages(int idx, long 
> val)
>    * Used in mod_memcg_state() and mod_memcg_lruvec_state() to avoid 
> race with
>    * reparenting of non-hierarchical state_locals.
>    */
> -static inline struct mem_cgroup *get_non_dying_memcg_start(struct 
> mem_cgroup *memcg)
> +static inline struct mem_cgroup *get_non_dying_memcg_start(struct 
> mem_cgroup *memcg,
> +							   bool *locked)

Sometimes this is called "locked", sometimes "rcu_locked".  Let's be
consistent please.

>   {
> -	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
> +	if (cgroup_subsys_on_dfl(memory_cgrp_subsys)) {
> +		*locked = false;
>   		return memcg;
> +	}

I was thinking we could use a single bit in the task_struct for this:

--- a/mm/memcontrol.c~a
+++ a/mm/memcontrol.c
@@ -810,6 +810,8 @@ static inline struct mem_cgroup *get_non
 	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		return memcg;
 
+	current->foo = 1;
+
 	rcu_read_lock();
 
 	while (memcg_is_dying(memcg))
@@ -820,9 +822,11 @@ static inline struct mem_cgroup *get_non
 
 static inline void get_non_dying_memcg_end(void)
 {
-	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
+	if (current->foo == 0)
 		return;
 
+	current->foo = 0;
+
 	rcu_read_unlock();
 }
 #else
_

That doesn't work if get_non_dying_memcg_start/get_non_dying_memcg_end
calls can nest?  If they can nest then we'd need a counter in the
task_struct.


