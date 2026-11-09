Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 813D4606A326
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 11:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=jDF6rM+I
Received: by kanga.kvack.org (Postfix)
	id A16BA6B05B3; Mon,  9 Nov 2026 06:48:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C6A66B05B4; Mon,  9 Nov 2026 06:48:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88FBB6B05B5; Mon,  9 Nov 2026 06:48:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 68B1E6B05B3
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 06:48:37 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EDAF41A066D
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 11:48:36 +0000 (UTC)
X-FDA: 85415408232.08.8212CD1
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	by imf31.hostedemail.com (Postfix) with ESMTP id 2C5C820002
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 11:48:35 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=jDF6rM+I;
	spf=pass (imf31.hostedemail.com: domain of urezki@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794224915;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TPfBvZrjONjB9W4HpOM7QG77dFyuYdOPlOcbjIM8DkE=;
	b=KzVPRjakHJFRVxyZSnmlonxghFg1inWpQj48zDQCt4/wW7C6Q7SEaCYuCNi3SbZaK4t6ZA
	vAC0WUKCG5zhxDYTn5Ym7GjCmjPwsq6S7O15zgn0oCd2dw5dMAN8++agq3uy3vJUWXo/6V
	q4HZNaTQGgpUxmbPBbjlK3atEL+jaao=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794224915;
	b=Y36kSg5FuoVnAqSOpjttSH+7xqSLDAietYZV4iWqBWz/tCGLHesU/jiPEG06/GCcsdnz16
	xGFedtSrfTiuqpUw4yHIC9P1eojWLOU9UftToZjTuJfxA6ktoQ1JTH00gzBUA4Ix6P03lr
	0eAv42zIuFmP3Z6pX5+94tKu3wh1dmk=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=jDF6rM+I;
	spf=pass (imf31.hostedemail.com: domain of urezki@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c3fd91337baso134570966b.3
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 03:48:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794224914; x=1794829714; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=TPfBvZrjONjB9W4HpOM7QG77dFyuYdOPlOcbjIM8DkE=;
        b=jDF6rM+IA/UofR0M+OLppOoaLl26Qyuig5B1ThLHxZ7kNC/u5mF3z2Dbh9Uh7pF20l
         FzK/tFU9AISyu/P6649UQ1hDGV23udUujI1v67P7UzBiOw/n+Zn3illJ4nNX1TJbLgnd
         f0o8kPZPQFgwe6dKRmefVbvgUey6r/cda+oNtTD6eOxaoAG6D7BMY/hqfG7lHOQCiL7N
         eux9tOcTQeFuWHtQS5Qj3P+ZYWbrvRyo+WdYd5IbPzQ67wfC/I20DFw7zL6wHhbZ70Rl
         ssH7qDSzzO1p6UdnhBLZGzo4pv3lMEinXb2qVXczQPLgJIR6ftdjosEp/jsOAQNFGCzQ
         aqqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794224914; x=1794829714;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TPfBvZrjONjB9W4HpOM7QG77dFyuYdOPlOcbjIM8DkE=;
        b=tMvMVG+sQISBN6sHX+GuThNBbWAGmnLcPROhwFS866LTmIlmWYZIy60Cu60uZ5+Any
         2y2ta9D8+jqi7ECOuzEdM2jZba1xCv3tzyUxTDbQTelTRiiqVnHd3+AihCJUVf4A9D9k
         l0Oo//t/n4S5vlsif84petNB2i0Vw4sms0sLLR+JZgk45pKD2JGQ3dyBCgIxUitEAtB5
         VisTMHINp5lKOhLLocLffZLoF8bxk5ZNZczCgxwiUhNQ1jmWGKEH04dea9+FDO4RxRQg
         G6+D6NLViSa/G1tpOWJMBvj8UpM5TTlSeIhrEOfYSVIVcH5er3RzUwAf2GBHkqw+owNC
         PFHw==
X-Forwarded-Encrypted: i=1; AL+hErEBssec6PYpi44cCFTX0PuJ11FlBw/tf6VGMQ5M6Cyz8Zesfhx0Arvn4keye/Th4Ncwzze0/3F/SQ==@kvack.org
X-Gm-Message-State: APuU4Z89UAbmdd5TXlSIPigdNIN4929R6HXWWhdZ7NakLhgc+tg8hkTf
	JE9AMgLeg2IoOwx2zs1VyxrfvculpI7COodQAYHwtrQ1FIONZXH++IfT
X-Gm-Gg: AYBFou1KsDzv7U5dPbxjHh8+ZJ5wV9OTlLyb3596P6yyenqt7TmNwDucHLXaSqeU/5H
	+rCRAyU+zr/3QCkSMe+8koU8cuxbEKtTQgDXqLVs/Yt8rb88W8DwBJputLC+7ho0G8SZrrFu5p1
	rfwhFQSnUzaX9DW01aorM6fOuS9X356e9TOMpXalZX6jQ9pHEyxEue+Iswtg+mh3M/jQkzxO5wA
	XPPzOHLJslTpOBwiLUqwwbx/QN1eTT8XmEqDF1Ev3evlzW5RRjTy+I/Ny2ccmruU4Yb8RteK9j/
	lwe1oq1Xp4RY86eQvU+0cMvFXYySEBMUg77m+G071ZcpRtiDoMf3NFDOixCuHqvS3rKQ/qBLshN
	kHioAx6APk4+S+d7eBoeXb1Dj/+OmnBNpDi7NLo7T8lTJs37TH9Ho9YB8cgbhz/iJ+Y4IxzS8dw
	JIF/0qa5DUqlHD/Ge3nQCih2iX08D69ZDUnpHawsDmsmbBpZBRJyY47GAx66AhV2gr22WdPXBgR
	/r2/NbrZPHRPeI1ltSz9OBT5LvHb6B/cvxFN408AWN35EvYpdptBuE8bH1ottgMO1SZ
X-Received: by 2002:a17:907:849:b0:c1c:4a80:30c4 with SMTP id a640c23a62f3a-c4d6d4a2bbcmr263270966b.11.1794224913500;
        Mon, 09 Nov 2026 03:48:33 -0800 (PST)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c4d6a4ae2f7sm155608066b.51.2026.11.09.03.48.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 03:48:33 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Mon, 9 Nov 2026 12:48:31 +0100
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
Message-ID: <avGzD8CAgg9Hif__@milan>
References: <20261028134647.3176080-1-zhanxusheng1024@gmail.com>
 <20261028134647.3176080-2-zhanxusheng1024@gmail.com>
 <au2fUYzBLv3uvj_2@milan>
 <au3ELzm_s9vhs7UO@thinkstation>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <au3ELzm_s9vhs7UO@thinkstation>
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: dnssrbih35qpz8qm7swbync7p7j5gigj
X-Rspamd-Queue-Id: 2C5C820002
X-Rspam-User: 
X-HE-Tag: 1794224915-764358
X-HE-Meta: U2FsdGVkX1/qrR0m2aA1IMZ0t4Nes1/xKROv9LrgEjxXSVJeDYS2pDXDjvIgMHinjMTbJu++IeDbA80qNkzmn4ddY22da0cOVafJoXMijGU+CvnCOPkAGzT402AloDosi67aIfD6mMM+unF/R37xwBHIKL14jGDvoke63/nGwuxLo4aMH4GrE0IN8oHNT0DBYowCCPLkIeiAGkZBj8VqbG0gkFdBqL1dFzJys0+cobQ4Ljy0X090e7PWerneK0D8Ll0c0qvg4nAsB/7jPcsVDHb9F1dHqdXOix5WaORYZLp03VeRhDmFyRBTiu3j1rQ34/sVFEo4vITmHDTJKoM87IYNcwZmpF41ejE0K6o6c49CBldslc0bfNqvghq0wKHw7QWiUqvFc9YgdzjYUbm0ZSJLen++ke/ounuHGB0Dc6RG5YP9eNTwEJbybQc3Xd435m0RgC4NuZPu3NwPfhvOLs1NhFZvGxCP+S8yteNZ7GVgQOwj05sLzsaCtjQS04ILfvGi6fwXDnt5KjQVaEJJw7rgPLsvY8Jdl2kttKklnJnxyoYKT661e4jq9uPKX2ouuya+0Soqt/hTka3o2HVRoi2pX3mK8z2Vk82v1ajMApsSdG8zpMDnIqvaN3ZiuPZfHZvq7T7FbFnDS2pEgFB5XP+4KYsIg+zQgrlSn2HRWXikpTRVEO3xGQdqw5aIpDq1kziUQSckPFzB+8aYAHKlHdoGvkj7qmzfWJzmZwA0cxanHVUYuN8kNDG06qXo6mWbmHQnsfDg1Y29FmOZCQOkgos9sdjKY24fJ6FP3ps8+WQZo2uEkrFU+8WK0vrvlT4d4OJjBPbGtFGGIOeGZIEF/VozqKZ9Lgn4voY1qkwzjKHcktz4UpW0KaWY2TUL5FO5Uy73tRQHBDhIZpARvlv1loI5SXraA2GGfqY4uB0DFfavJrO8SlyxrK5loIoHgZBJfHxssj29xbtRhzOq+uL
 HB0MQGr7
 HsBup214A/gZRLW3MBi6eFjnaLI5QoapXT1K5cOcg5SSloPInRfkedVayWW4ggIKZIvod+zBMvVIHBzMqzMMzS7P5990+Q3H5PPa7rIthrWQMyZ7HQL6v5Kst5msPyZU62aM3BHVw4EXfutZ2hqmVTxgUIqZl7SvAXFqSOqpYeJid3/K/8mjHluTQNY+ay20We8xUHJZVjmRRGyum0/3/8md2jSAjAn+CgsPZCh2t+S+Ummu7BiPWenJFkGd6/PmLklfOg42xbSXLUvC3dSEq74Wtvotp5/nwd3C68oqxq0vKUAfvqbDzbIMoQD3Yo9opiJqcalWu3iH7dXrzSTRzNBX2dg94GXVW/em+043LJsjeBye7evhMsS3wQ62qdb5RaAN05Xee58nDa1DxffGDvvmEwNVEHq2SDbDdXhJjObhqQfEL7M3yW6RBsFPTr5AstUohKz63D+5xxtveqwi2b3wirI53zJM6i4wvpicGe6rMKubDJpoREclisw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 06, 2026 at 12:21:28PM +0000, Harry Yoo wrote:
> On Fri, Nov 06, 2026 at 10:35:13AM +0100, Uladzislau Rezki wrote:
> > On Wed, Oct 28, 2026 at 09:46:47PM +0800, Zhan Xusheng wrote:
> > > From: Zhan Xusheng <zhanxusheng@xiaomi.com>
> > > 
> > > run_page_cache_worker() runs under krcp->lock, from kvfree_call_rcu()
> > > callers that may hold more, such as set_cpus_allowed_force() under
> > > pi_lock, so it kicks the refill work from an hrtimer.  Under memory
> > > pressure it instead queues the work with a delay of
> > > rcutree.rcu_delay_page_cache_fill_msec, which may be 0, and a zero delay
> > > queues it at once, taking pool->lock under krcp->lock.
> > > 
> > > With the delay set to 0, calling kvfree_rcu() on vmalloc memory under
> > > pi_lock after a drop_caches makes lockdep report:
> > > 
> > >   Chain exists of:
> > >     &pool->lock --> &p->pi_lock --> krc.lock
> > > 
> > > Use the hrtimer when the delay is 0.
> > > 
> > > Fixes: d0bfa8b3c411 ("kvfree_rcu: Release a page cache under memory pressure")
> > > Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
> > > ---
> > >  mm/slab_common.c | 8 +++++++-
> > >  1 file changed, 7 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/mm/slab_common.c b/mm/slab_common.c
> > > index 3729aa7a6156..ef5ff0a20249 100644
> > > --- a/mm/slab_common.c
> > > +++ b/mm/slab_common.c
> > > @@ -1987,7 +1987,13 @@ run_page_cache_worker(struct kfree_rcu_cpu *krcp)
> > >  
> > >  	if (rcu_scheduler_active == RCU_SCHEDULER_RUNNING &&
> > >  			!atomic_xchg(&krcp->work_in_progress, 1)) {
> > > -		if (atomic_read(&krcp->backoff_page_cache_fill)) {
> > > +		/*
> > > +		 * A zero delay would queue the work right here, under
> > > +		 * krcp->lock and possibly the caller's pi_lock, so let the
> > > +		 * hrtimer do it.
> > > +		 */
> > > +		if (atomic_read(&krcp->backoff_page_cache_fill) &&
> > > +		    rcu_delay_page_cache_fill_msec) {
> > >  			queue_delayed_work(rcu_reclaim_wq,
> > >  				&krcp->page_cache_work,
> > >  					msecs_to_jiffies(rcu_delay_page_cache_fill_msec));
> > > -- 
> > > 2.43.0
> > > 
> > > 
> > Can we just clamp this to 1 - 100 seconds interval?
> 
> You mean clamp to [1:100,000] milliseconds interval?
> 
Yes. It is now in milliseconds.

So starting with 1 - means that it can be configured at least from 1 msec
whereas 0 is forbidden. Also we can drop the extra "if condition" proposed
in the patch as it never can be zero.

--
Uladzislau Rezki

