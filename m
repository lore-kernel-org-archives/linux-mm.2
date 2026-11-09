Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADA2C606A321
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 13:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ULTNpLnu
Received: by kanga.kvack.org (Postfix)
	id 91AD46B05C2; Mon,  9 Nov 2026 08:47:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F1E06B05C3; Mon,  9 Nov 2026 08:47:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BA9D6B05C4; Mon,  9 Nov 2026 08:47:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4DF836B05C2
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 08:47:21 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CD3951A0699
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 13:47:20 +0000 (UTC)
X-FDA: 85415707440.01.75294F5
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf06.hostedemail.com (Postfix) with ESMTP id E36BC180005
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 13:47:18 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ULTNpLnu;
	spf=pass (imf06.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794232039;
	b=fNMzDrKm3bqo5LjxbsyzFcuDedZLCw7NmcK91MTsW3mMof3UZuUMIo6n7Lu9OeOGUgbbMa
	3jzdBkEJzNdII/Niqa2rlAUF/6f8rjDzT6fAW1x9d5ha70q34C64ypWX9SmKGFvxh97+dp
	hlCEFCVbw/VALrjVZE2lFsLX+Ab4NCw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ULTNpLnu;
	spf=pass (imf06.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794232039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gb/McRGatQGrBV1WsdACGQfyLm2d4GS+1O2sMOZ+oYM=;
	b=YC5Iy5Z0PdEBmbK2B9JIdV6z6zHe328SmpIy0b/mzyqZCrHA9V06sOWOOzF4f91tJzfUSh
	jeOocKyxOy2H0VFlQd/gdKGVZDL4SOIqukkl8iZdcqRW6Jv3BtQcOo3Xy/fqXwg+GOR2dL
	GJY5PlEmKByqoW54H4LGqgpWxayhq7M=
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6b587591414so1000511a12.0
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 05:47:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794232037; x=1794836837; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gb/McRGatQGrBV1WsdACGQfyLm2d4GS+1O2sMOZ+oYM=;
        b=ULTNpLnuYGpqa8WhTaOyQ6ggRYcu2ygIyuk5Tu4q8E7Uw4iGRk6leTvhJh5qNSU7w6
         pXPWFR7EKgzEhZ4UK4NG605S2AqU+5lWuPmtFGbH8OARyklMM7tvjxJlv8ncYxw6hLTZ
         gB/bHLZbe7yGyq2MZFKd/AZgOOd0m4WcQUGPgGAkJweGkCQq4m0HWSRC4/jqL9+Y/G0v
         BV/V5IDJY+FUHzPO55xZstCRYMfwNhtH1xGr/FSuKwxzGghATnFlE05nc0kHC3INoJ/l
         T0suGOD1YTQQOE/QoOyjuqgu44qaBghpZZqn/S8/ru8/ZimSl9N3F7+W9xa68lo88Gty
         sDCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794232037; x=1794836837;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gb/McRGatQGrBV1WsdACGQfyLm2d4GS+1O2sMOZ+oYM=;
        b=dG56iMhhPAMMaiBX/YX9tdMViZbIwuSx+ztylbkangSeV69RTnNJVYxdcL7uAKDcO+
         jT8Ph97JoyXSZ0XSZoZ6qvsDOhxEjCbEOEGnSzz82SMN/ocJ+QAQoZccaQWPSD8/M562
         ym33wyAg2xAyYG8rO1S8mOwaY4cRkBrE/HZKRfywSoWUobiEELZBLVoFziqmlTAEKNGX
         8lxgi/fZj/vP9Gr446B83dPRGsPsfXjLKzOF63LTeD58HXe3/ISn3Mh1PIZIOUn2qDsa
         wM1gZiqg3FIJ2FU8pccfohl3SoR3uIrXomDoomcSnvyGMs6BcQ7XfuXWD4n/3bUkOOPk
         UpQw==
X-Forwarded-Encrypted: i=1; AL+hErFag8269jyiiWhBVRaxKMPh7bh3t88xG5im5stsyIdHBM6qoyJ6pvyyo/P9XsEmDdhxLGc3u42wlQ==@kvack.org
X-Gm-Message-State: APuU4Z/ydj8kh5sgUrGfULjX7aVlj2ANb5s9NchbRMJh+Q5fOuv/oYul
	nCr4Uk5irQAKuC4AQ4R/5+JV7CC7m93/Zt1liZetVJukhAhMT0jsVl8k
X-Gm-Gg: AYBFou2TrkP5THYjVPdh/Fw2BmJADqkvVLQ+QINFoRenr1A0hjgFPw+wpq7bbo0o54k
	RmMgl3hyFYTH66/f+8wnOHtCdtY/FTFWZjw+oD3NhoEv+7tZcI3zHOfCWbVeXSh6Xj/ZVxO3gkN
	tKFgsU6zCaMg/TvPmqxccVmopp1+GE6knzNZeVAP/ONXhEe36OR95NcRRBzFcvdo/cAXnJhxlwK
	OfA8gMdNYsSb7eEMH3EyvB2j5ezfovst4v9XOSe6kS3m/b/H1/iZqrac53xvOe4FHipZj0UuVYH
	T++nDvkqAYh0CP7ciOxbnBtNGbeP+wxdURlJ0WQsEDA3aimR5pYibYrRNB47lE3ZjMOfaD7DxZb
	1Gxy06ypqmaKQkqgOSrvCU3mMaRctluhQqLU0Q0owpY+WklNK2ii8NPvNfnUr2istvYt+nEHwxU
	wVSTDD1xnpe5RWzUP/YdgQCzszIwXTfH9pDO3lO9T1QwwTxX++hLT0kYokys9poTmX3EZaqhjvb
	DaPrxmhrDjVrWJqdPEkmMIslv/H5PjMyJMgxRqhGEADgNtPtXbav2NjaVutkKqmK6UyBevqQj+E
	89HYIpMiz8oUBg==
X-Received: by 2002:a05:6402:1d4e:b0:6b7:6c8:70d7 with SMTP id 4fb4d7f45d1cf-6b7223c22e5mr2357975a12.1.1794232037247;
        Mon, 09 Nov 2026 05:47:17 -0800 (PST)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b721eedd40sm1643775a12.32.2026.11.09.05.47.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 05:47:16 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Mon, 9 Nov 2026 14:47:14 +0100
To: Harry Yoo <harry@kernel.org>
Cc: Uladzislau Rezki <urezki@gmail.com>,
	Zhan Xusheng <zhanxusheng1024@gmail.com>, vbabka@kernel.org,
	paulmck@kernel.org, qiang.zhang@linux.dev,
	akpm@linux-foundation.org, hao.li@linux.dev, cl@gentwo.org,
	rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org,
	rcu@vger.kernel.org, linux-kernel@vger.kernel.org,
	zhanxusheng@xiaomi.com
Subject: Re: [PATCH 2/2] mm/slab: don't queue the page cache work under
 krcp->lock
Message-ID: <avHO4rQ-gKrxW2Nf@milan>
References: <20261028134647.3176080-1-zhanxusheng1024@gmail.com>
 <20261028134647.3176080-2-zhanxusheng1024@gmail.com>
 <au2fUYzBLv3uvj_2@milan>
 <au3ELzm_s9vhs7UO@thinkstation>
 <avGzD8CAgg9Hif__@milan>
 <avG1Yr9sjswFoJ9E@thinkstation>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <avG1Yr9sjswFoJ9E@thinkstation>
X-Stat-Signature: sibp59ihxm8od8jdekpswf1z9irradjz
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E36BC180005
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794232038-690299
X-HE-Meta: U2FsdGVkX18++lGjoQGPS4MFpj3P+jJ8LDh5qGRvmRi1HiQl6ikOh+oEuZsRBCjLRWRG4SDDBnsOK4MQQZ69YMwsegemyL2DkgRKn/dKzP2qnAUJEJ0Nc98esrwZWJ4xtKpgWwHDMWFIcz1QUSeMgWICoxkK6S7E4VwTOLMcEr3mgs7X7Zjqr7UWiIxmAn12IlYWW2f7qBRg9qtNR27XrIDgLkXCLnoRKv0gghDTjlcjpo4w7376RkDwLYWQc1R8Hvjl8MErDdIcKOcAGrLduCVxmi/dmr6SnibbQeOAVysdRkHLWOuU5QgcmC5hIkDue/anUOmbPUJ+7GjvMNbiLltodw5nUYJ+4xsI4zQqYZDEVh/T806PLoUtDZ8JgYWmwmcc6HrGcp5NWqPeSpFyd1R0A1dwi9Zc40/oKuGl9Ytq1O//8W4sAcautK8zB52PH2A5nX41sdHdtih05EHMWVE39Ew7RGrHXEYZSI0FdmqCiVwmkRYLDYGT2OWbBQ+TnmpTNc2+rbsxTqWPeHd4cmjYdSP4LZV/XJ3nI/ibtYg3ckUFHCj7lNZZA5Gpsn6MPDtz7itz5j/m9RyWjv1XKsuVd3Y+h5+inS/p7hNuIxhfDxcCcNfliAw/MzP+jrs/2RCqFBEqGuskVRlsnozijb8Sc70LDOxMiXBYDA3+lSnhnh50FPgM4GMR2o2b8JtWbHa2daXT/5x+yEvvsWEnUTtF9sk20PtLY7AaANhSFgFGxx6N3dx7jV19mzDa8gEMMs+ZO2Dl7NN+RpzMt5FQmkzdpcxf4JZUEh6B81n9DXrUzWZ2xKnnPDL8FQVo/VfrqcIC0dTcoJs1TG4c59A39qG8tA/JtBVtvrbIwpZBgjPNmclccaLUwzHbF6WxaZDja2l3njxaHHUfqz/cTNDS7z9JhNZGaZUgMF/toljbXMqPHU3Tqbeha7uB6SBPToOx1Uaqu9RYAfd5We3JqwZ
 Fa7xY2I1
 z6Y6kL4fjAX1qaTim98tZVmQhblNkVB2nY+sBrJnGBBxr0rrQXPUGKSLZFn9tCzNnkTZ0gyrxOLwqSKJUZusGqeqQaFTyiqJBg5i15U9YpZp/jkO4KORykOtZNzfHvJMVmQpB7jnNAoerQ9C8aTvUsJ0n3xH0SdZraecku3nATEtljPwSMrKKkOvaggXiXlHwqfvyCXqwGytIq5gkRoymC3B66SjMsfbwdjgBFaRkO7R7xwiw0HjP4nsIXOx5w+vOq8Vqdmhw9Jcx7+lWqJysSsYSnI21QNr20+UAFaOcWZDaIwpsXmDAS8HkluLWtcs5SGBaQJKKxx3xVyWVIpbjIx1Vi3IzjqzOotX5rt5DjQQWdwFX4k0mK7uLqARUWa3fCw2b7ihPAlprgTo/leAGHMzIXwWj1WExLNxzQWsAPBaSfNSn3m0WcE/M73v3CTyhmD7Y1T5eqFBluDp72B/1nr4TWTYkfKAEpg60MCQpDEYRpLJW1VlHpD4WQg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 09, 2026 at 01:13:46PM +0000, Harry Yoo wrote:
> On Mon, Nov 09, 2026 at 12:48:31PM +0100, Uladzislau Rezki wrote:
> > On Fri, Nov 06, 2026 at 12:21:28PM +0000, Harry Yoo wrote:
> > > On Fri, Nov 06, 2026 at 10:35:13AM +0100, Uladzislau Rezki wrote:
> > > > On Wed, Oct 28, 2026 at 09:46:47PM +0800, Zhan Xusheng wrote:
> > > > > From: Zhan Xusheng <zhanxusheng@xiaomi.com>
> > > > > 
> > > > > run_page_cache_worker() runs under krcp->lock, from kvfree_call_rcu()
> > > > > callers that may hold more, such as set_cpus_allowed_force() under
> > > > > pi_lock, so it kicks the refill work from an hrtimer.  Under memory
> > > > > pressure it instead queues the work with a delay of
> > > > > rcutree.rcu_delay_page_cache_fill_msec, which may be 0, and a zero delay
> > > > > queues it at once, taking pool->lock under krcp->lock.
> > > > > 
> > > > > With the delay set to 0, calling kvfree_rcu() on vmalloc memory under
> > > > > pi_lock after a drop_caches makes lockdep report:
> > > > > 
> > > > >   Chain exists of:
> > > > >     &pool->lock --> &p->pi_lock --> krc.lock
> > > > > 
> > > > > Use the hrtimer when the delay is 0.
> > > > > 
> > > > > Fixes: d0bfa8b3c411 ("kvfree_rcu: Release a page cache under memory pressure")
> > > > > Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
> > > > > ---
> > > > >  mm/slab_common.c | 8 +++++++-
> > > > >  1 file changed, 7 insertions(+), 1 deletion(-)
> > > > > 
> > > > > diff --git a/mm/slab_common.c b/mm/slab_common.c
> > > > > index 3729aa7a6156..ef5ff0a20249 100644
> > > > > --- a/mm/slab_common.c
> > > > > +++ b/mm/slab_common.c
> > > > > @@ -1987,7 +1987,13 @@ run_page_cache_worker(struct kfree_rcu_cpu *krcp)
> > > > >  
> > > > >  	if (rcu_scheduler_active == RCU_SCHEDULER_RUNNING &&
> > > > >  			!atomic_xchg(&krcp->work_in_progress, 1)) {
> > > > > -		if (atomic_read(&krcp->backoff_page_cache_fill)) {
> > > > > +		/*
> > > > > +		 * A zero delay would queue the work right here, under
> > > > > +		 * krcp->lock and possibly the caller's pi_lock, so let the
> > > > > +		 * hrtimer do it.
> > > > > +		 */
> > > > > +		if (atomic_read(&krcp->backoff_page_cache_fill) &&
> > > > > +		    rcu_delay_page_cache_fill_msec) {
> > > > >  			queue_delayed_work(rcu_reclaim_wq,
> > > > >  				&krcp->page_cache_work,
> > > > >  					msecs_to_jiffies(rcu_delay_page_cache_fill_msec));
> > > > > -- 
> > > > > 2.43.0
> > > > > 
> > > > > 
> > > > Can we just clamp this to 1 - 100 seconds interval?
> > > 
> > > You mean clamp to [1:100,000] milliseconds interval?
> > > 
> > Yes. It is now in milliseconds.
> 
> Thanks for clarifying.
> 
> > So starting with 1 - means that it can be configured at least from 1 msec
> > whereas 0 is forbidden. Also we can drop the extra "if condition" proposed
> > in the patch as it never can be zero.
> 
> But can we explain why forbiding 0 msec can be justified (when there's
> an alternative approach to fix it?)
> 
I mean it is better to fix the threshold instead of adding checks.

--
Uladzislau Rezki

