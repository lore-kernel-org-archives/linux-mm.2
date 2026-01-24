Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDC4FD715F8
	for <linux-mm@archiver.kernel.org>; Sat, 24 Jan 2026 23:22:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98EA16B0005; Sat, 24 Jan 2026 18:22:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93C0F6B0088; Sat, 24 Jan 2026 18:22:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81D346B0089; Sat, 24 Jan 2026 18:22:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 717636B0005
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 18:22:46 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 98D818B636
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 23:22:45 +0000 (UTC)
X-FDA: 84368434290.10.F0B9A06
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id C78291C0009
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 23:22:43 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=uVSmrjwo;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769296963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7BvpxvNr8ZnEUt8c9x3F7/olM1PCMJwYKqb7d3P1TMc=;
	b=ZSnlbmJbXuK+U3xVMUSHaEUq2HDB/X6LsYAgtl7LkNm1xo2YCGOWZHr+UchVqUHdK9rMPg
	JcQyAvyFOEENdcUtyavxqBAA5Vxw2Yuwf/qWwKhmt4qM14WS3pJIOTRMPKBCRdoE1HP0BF
	DJ7gjF3Hyq35TtnfWDKdtZPfHM0z6tg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=uVSmrjwo;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769296963; a=rsa-sha256;
	cv=none;
	b=eQp/T/MW3clV+J7IDDLokupp9cdMcHbKxyh2S++AYW1BqUcoyajaeEj9CLK/sDmRm/Wwd0
	y0LBftVuS756umhwhfJqt3NcRB7fo4kBCH5bLnM9MEsA16pbJVgRN5GsvhtbcXA9HqQYKU
	7/z7Q/88fQ/bkxxbOgHXSb5MxUg3rCk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E9D1760018;
	Sat, 24 Jan 2026 23:22:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FC42C116D0;
	Sat, 24 Jan 2026 23:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769296962;
	bh=E+qta5MzZKOrVv7h+RGiMPJteij1PKPCstlitf9VJMU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=uVSmrjwo34hh6Cp2RmvC1RqY9QlHv2S4pQy+uADQuG3ewRnvLup3M1JGwOj2gVbRf
	 J7Ogmrsq6yys/CMz2EjuRLL4kicfqIYsyJEteo87vsWWVw7IqJ6nQp5MRfKYw1QfTY
	 JH0kfjVp6rZdnyzEDz/eOy12wScG5c2k2qJJeJKs=
Date: Sat, 24 Jan 2026 15:22:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Marco Crivellari <marco.crivellari@suse.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, Tejun Heo
 <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>, Frederic
 Weisbecker <frederic@kernel.org>, Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v2 3/3] mm: add WQ_PERCPU to alloc_workqueue users
Message-Id: <20260124152241.d97b8b525c1d67ad2b0423f7@linux-foundation.org>
In-Reply-To: <20260124222135.XyGv6OqY@linutronix.de>
References: <20260113114630.152942-1-marco.crivellari@suse.com>
	<20260113114630.152942-4-marco.crivellari@suse.com>
	<20260124222135.XyGv6OqY@linutronix.de>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ikekh6b3s718ndwxqzap9gk8a65kbdz4
X-Rspamd-Queue-Id: C78291C0009
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769296963-192123
X-HE-Meta: U2FsdGVkX19dRg+kwuHj5al5D7+VS4qYCYQLze6PRCrjPqXhgBF+kTzMtsMc5/JVyavqVnegsyLPwDfTnx7F+cJXTJJoq1sXuTwBVxe8EzjZcfxEa4fQHsFzZgci7miuCYBZrpk9oopPBYuW3n7ObQjSNXkvGh+BYyX4FPC5Ov+wsZfBg3fmqG7P/96J6onFiKshtcKb0IXVk00xq+SFYaST4zw2Q2nohQZkT/eoIThXwz9eUof4juDFo/z56nZIU5GQnLIGMqAUv/bGlXUc0uj/s90fEIZF9bUzju8Hks51bC/XWozpYNW/LyKBy9rWrV0rO0/J3XFFNqSY5O6VrjTlXcqGx3VQwcFoF2pWBmqEUHAZ30o8bPRaL3k0B11EH5ahi0hdYbXrTAk5S7ndnaLGJ4bds+zMPPfUHMtd14d7unPcy4TkF8dI59sxsvkLeQ5+rGkryKdEPxnvbeZHv+KsJuQMW/zLxH+b56M4/Rx2Wt5A0WV6vKL0sd/WJlgxNBYOheLen0D2HSk2ORxeDEFajgN9/+Ibx9UF1hA0Ki5zjaCVUiLQqN3gvMai13azwcwqABWQRivY68HKn68xBPBpM1VE8qPtp4qBzcghJ9IDVRUAnCcStr2Kb7V9/xwkw2zSierOzPCcCeFKCEsdRNMH3vKshdtjux2Cs7xqdNydMNQ2hS98tFuB8AWiH1uaGiuQGxFNz9/D1Otxn9HcwjjpQbk8+O5bWGhmbROtxe5NT9SdaWHuUrQb9p2PSM9U/UcoqP50kExIl2u3kHj1w9xgWyxTbXJOPiH6cfIUaUJpixho4GgAvsYSILGNtF2eNBWcAUGJHcxVccYgKO2yIhC5RnJtPr/y8R/XjKOa/2xHzVHC8vMUn9ckiHLSrjEEZxd+mojv9a4hF26X0qgXilegUeGGKJWOxdH8BipLvDSd+pfHfTAiUoIalJysNSvMNuCDH0cspQwMyKiaDwF
 mwtu5m1W
 aeM7EA+8mP2FHeLrwIrUuHaTNjlL2c9rERmeIk0YhYJOSbhDzUfzm0J3bdmqijb2aQpKlkvPvQSSCK7F7O2BEqc/892E5RzlYZDJ1pa4ZD+N4h0+pTUtfZKO46lQQoHBzxaRZ8tZG/3XTnpjNooSxxU1teFs3ONbsoJb/DpKpCYTA6oju3keF3j4l64IVxEVY73gIMQHN0E0Dy5j1co4/MgIbxxyMnGeghresfVtKFJR8blnRl2M9K0OI0aTbFoYjsDMUv+gfxIisNnotu5CUAMrm6Cg5aJmKJHhl7SRsmrG94Wuo29f+MQoj4mmsb4pTGGZ30ivU4y4H760r8MmV6wF+yKLMmHwzAcZHbTOD32pZ73WAwA/5NHOwqT6HBeVmzDGpYKkwDCYp0PBCorInjcTz0imox4JDALZ4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 24 Jan 2026 23:21:35 +0100 Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:

> On 2026-01-13 12:46:30 [+0100], Marco Crivellari wrote:
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -8542,7 +8542,9 @@ void __init kmem_cache_init(void)
> >  
> >  void __init kmem_cache_init_late(void)
> >  {
> > -	flushwq = alloc_workqueue("slub_flushwq", WQ_MEM_RECLAIM, 0);
> > +#ifndef CONFIG_SLUB_TINY
> 
> This ifndef does not belong here.
> 
> > +	flushwq = alloc_workqueue("slub_flushwq", WQ_MEM_RECLAIM | WQ_PERCPU,
> > +				  0);
> >  	WARN_ON(!flushwq);
> >  }

Yup, thanks, mm.git is carrying a -fix patch, which is actually wrong.


From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-add-wq_percpu-to-alloc_workqueue-users-fix
Date: Tue Jan 13 05:59:13 PM PST 2026

fix mm/slub.c

Cc: Marco Crivellari <marco.crivellari@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/slub.c~mm-add-wq_percpu-to-alloc_workqueue-users-fix
+++ a/mm/slub.c
@@ -8546,6 +8546,7 @@ void __init kmem_cache_init_late(void)
 	flushwq = alloc_workqueue("slub_flushwq", WQ_MEM_RECLAIM | WQ_PERCPU,
 				  0);
 	WARN_ON(!flushwq);
+#endif
 }
 
 struct kmem_cache *



I'll add this:

--- a/mm/slub.c~mm-add-wq_percpu-to-alloc_workqueue-users-fix-fix
+++ a/mm/slub.c
@@ -8542,11 +8542,9 @@ void __init kmem_cache_init(void)
 
 void __init kmem_cache_init_late(void)
 {
-#ifndef CONFIG_SLUB_TINY
 	flushwq = alloc_workqueue("slub_flushwq", WQ_MEM_RECLAIM | WQ_PERCPU,
 				  0);
 	WARN_ON(!flushwq);
-#endif
 }
 
 struct kmem_cache *
_


