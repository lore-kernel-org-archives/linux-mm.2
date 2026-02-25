Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F1F6FD45F1
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 22:52:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 641566B008A; Wed, 25 Feb 2026 17:52:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6188B6B008C; Wed, 25 Feb 2026 17:52:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53BE36B0092; Wed, 25 Feb 2026 17:52:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 40EF06B008A
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 17:52:48 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E148E1402CA
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 22:52:47 +0000 (UTC)
X-FDA: 84484480374.06.DA8E9AB
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	by imf30.hostedemail.com (Postfix) with ESMTP id C4AF78000A
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 22:52:45 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel-dk.20230601.gappssmtp.com header.s=20230601 header.b=gBnsFXyT;
	spf=pass (imf30.hostedemail.com: domain of axboe@kernel.dk designates 209.85.222.173 as permitted sender) smtp.mailfrom=axboe@kernel.dk;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772059966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lV5yfIvdQy795zXZiEFYEcuoFYVuQqyybCf8AopsVu4=;
	b=twivCAlPm9sR9KTr09JNuiLJdQjTt0JJRmz/OKe4hT+czkFZZ9Lc/CssuQK/jSQajERrlR
	pePT8ICW0dZTgK9LtvwkUPpEXcKSZGkjSpUx0KrLin4oNmDxVrpK30O3lYY5b8oMdzNx6V
	B4xd9/SHzLu/znfpHMlz5os+bdrq7b0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772059966; a=rsa-sha256;
	cv=none;
	b=hlf42IjwuKhfx+vImtYaXbWIHiTh4fkZtdaVaNFxqR1yOUTS4M4eOtQbXXyMopxUEWL9lm
	ir1cceOFYwBwOqd8FdPqgLf/lT3BHtseOKpEnijakj9xD//AiOF7wrARENnkswNOAIIfbW
	/FEgt3BiahZFY+Ly8A3WLdQc8AqjiiQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel-dk.20230601.gappssmtp.com header.s=20230601 header.b=gBnsFXyT;
	spf=pass (imf30.hostedemail.com: domain of axboe@kernel.dk designates 209.85.222.173 as permitted sender) smtp.mailfrom=axboe@kernel.dk;
	dmarc=none
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-8c70b5594f4so7225485a.1
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 14:52:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1772059965; x=1772664765; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lV5yfIvdQy795zXZiEFYEcuoFYVuQqyybCf8AopsVu4=;
        b=gBnsFXyT/yRzIkZX3+/eaWL/O7bRr+sDBcCYr75xbFU7nvHDp5AxwvG7wr32OzTETL
         AA117aqgH7+rV5zQEEt8G8sGUTPZ+AxlsDvTRECbI5HFZA9tBU7tPepLzXkOe115CaKp
         Yu0Je7UEouNEz1DctwRKEVx6jzroSVKBKPdlAgBAaTxBsdRtexGEBC4cB5BPZGggk/Wj
         /a0xpET8ouTHq2nMBf1frTQ/HfZw/fl/0OZ0RaCgfcnQejdUqWJeGyBhi5cfL0MPvU0v
         THtp5BPxpLCUYLoIwLgTmagPiBGhB5BxnTw79rYx7hefbAe0+oKBAQAX3dhoy0mIMItH
         nY/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772059965; x=1772664765;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lV5yfIvdQy795zXZiEFYEcuoFYVuQqyybCf8AopsVu4=;
        b=SPMG2mPe2Pup7ZznwADylw4wlz15BQ9MjFgxHQdPP0GK2/JLkkFcJY36JC+UbOEr/G
         PBiKot2O030/zZu5pZiM1a7ruxh3s/gl9LetaAmQRoW8CsWeHik+rF4pqtgMc+0wmCGi
         JGJcKzo1hI9zkoj5tXIuvPowh90hG5VPEfBKEMr9mI02fSXNeU/1r8596V0e4lio/YVq
         sQGoPfw5p4RobvDmyIeMlfgZwz85rzJpbRqh5BAX4bTTpXGmaaE6UFYKCq4eXXI06w8f
         7um9ikOyBvuP4V0Wxdn5Rahhr1UXhOYUc6wZRY9R3hW+oWdLkJXJxpqJz/MPsOtC6Ow2
         2neg==
X-Forwarded-Encrypted: i=1; AJvYcCWkOAZJz2opGKor0mSx4WldKciQOR7o2UZKsSI6jSnLf7mSxgQiQe/a8RxxRteCMJ8jnK4I8/huTw==@kvack.org
X-Gm-Message-State: AOJu0YzNGuMtpB6u4KvZdKC0X4eh3ewyw4tC0oiHCOdNwvHKnalrge+C
	drjdrJ/8swJjM3aIasnxvAsbK4vjMJZd7SHLF6+doGMotA6xyUa2/DWgR7wluwg51wc=
X-Gm-Gg: ATEYQzxnmJyeDMdwx4iJoSyeaemHVe0HbyUks3eoeCItdCWsJ4w9A1iqFCjSW2ya6GC
	s4Z32/+2HiYPtr0261ksbQahU1YAGOaF5sDDEIpl2JpNL3t4hz9T/Kpe47yyudKGK4Z3kR1j7Jg
	GYTukViQdUJdVfr1SE07bOPHqK66ws2eJ76ECLrmh31JK2WggYaeOPpe1exKEb+jUZ9Tg9VXMvX
	8vy2U2dlZP7ZizQE5Sm+xTIw05W4V/RLP8p1QOgO/6ckMi84800atR/THpCZFtb0diEQWJhcJd2
	OVjT0BLqJtCE/8v7hYXOlZ/7+SgmvHMXP5HaQdQr4xyu57LaD9CfoZE3kmC4RtoXQsasrmuJ/Vv
	ZIGKTQU3sTtabJUglkmbQHUprBsqfsCei+o9dvWPPU3u8ggynMze6D/+/7ps+0WQRMkIgEFZA7r
	t9Ne9dQSyQwJX40OXD2mHjm+kNCFEvMcTJssJCFVR07DamOJNLeQplxtuZw4A5AWYaQAKfPUoIL
	apEP5On
X-Received: by 2002:a05:620a:2807:b0:8cb:2b1f:99e4 with SMTP id af79cd13be357-8cbbf3cf398mr113515285a.34.1772059964616;
        Wed, 25 Feb 2026 14:52:44 -0800 (PST)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cbbf652bb6sm51863585a.4.2026.02.25.14.52.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Feb 2026 14:52:44 -0800 (PST)
Message-ID: <c8078a80-f801-4f8a-b3cd-e2ccbfca1def@kernel.dk>
Date: Wed, 25 Feb 2026 15:52:41 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 1/2] filemap: defer dropbehind invalidation from
 IRQ context
To: Tal Zussman <tz2294@columbia.edu>,
 "Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Namjae Jeon <linkinjeon@kernel.org>, Sungjong Seo <sj1557.seo@samsung.com>,
 Yuezhang Mo <yuezhang.mo@sony.com>, Dave Kleikamp <shaggy@kernel.org>,
 Ryusuke Konishi <konishi.ryusuke@gmail.com>,
 Viacheslav Dubeyko <slava@dubeyko.com>,
 Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
 Bob Copeland <me@bobcopeland.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org,
 ntfs3@lists.linux.dev, linux-karma-devel@lists.sourceforge.net,
 linux-mm@kvack.org
References: <20260225-blk-dontcache-v2-0-70e7ac4f7108@columbia.edu>
 <20260225-blk-dontcache-v2-1-70e7ac4f7108@columbia.edu>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260225-blk-dontcache-v2-1-70e7ac4f7108@columbia.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 8b1755bztqr74xtisdhzzk5i3sdkicoq
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C4AF78000A
X-HE-Tag: 1772059965-757566
X-HE-Meta: U2FsdGVkX1/vI3HG7TWMC3dgyIMUlkk2QtXDqU5Nv5M/p6caopaTJ1BTVrDj5d8k0ubPBrWLBdU4AzdSw8LBZxpfH6jjSTs7tH0hEk4QLihRKiKiJ1HYIB5muKNfiiWT5ypnr7G4M6ddalTC5ZBS6uHLQ+mL2v/qL3fgNHR0eZ/qW05lCHV1fE0ImiizNRTBhVKARemo3OS6Yi090UzDZrZ5ZFhblPGelY9B40ELFhAXwoHlkVfPxroloaSbXyKgxGFdDIx+s3gRa4yNOPDiLhD+XTafXWIQuhEx9W85CJEsNWZs+0z14qNtclJBZUNW9m5a1I9gujvU2jvBt4cEcARheJ9x1Tr7xhwp0yGrpy2d3MV0kMNCnSXdC4y8h0314h7YB1o8aQ2vrHviUPMVGXk+12SD+8wWsFNTKDpaR4nWmhc3opWqPGDVJHxSSAmfgxNW3M5UNZq2WI56NEAFp4FtZN98mb7bQ8TKJvKB/mTb71Ay46F9Dow3jwptnh/Obwn89D0CCo+UMzgK/rkFx1shdk19qg9SC2TNuMkwJ29s395AcVoyW8+LZpr+rEmH/wDs88hMxEQXKuT6mc7wHpsz+IRB84Xpw4MveHl0K1PwlPJSLyDI0BCAuNOoAANnA6FFmZCNSfGRDFxoCdVrPDRM+tmBdR5cA5D+fuba3EQxzFB6yELF5p+WZ76HTBuo38MDbIjRmiRvMtzUK/znIjcWTBSeMOK2TrouoNsOjTBLeLXvT/Tc/fIGmQQT+X7tybr3iMJ2i0Dy3v/H0vPx5BIkckr/Fkpciza2gebr4uOuyKkV3mNtaXWfUf30Vgzc8vDVYd6eMBlj0XtGuIcs90ToJneLUm4gWTr/8wKH3ny6WWjMmLZr18707ihFnMMkzjXxKITXBu73GGnbJrTcfudSCNMWvFsY4a+aVlIgzTZFltqDX5Z7ewpOD0ie1PX+JD0Dch7x/P0Yzhp5mFt
 Ga00U9DK
 2g3D4/ELwMPIltVegHTyt+hxtzL/TjhETUlzMUDgNkHm6Vmby9ZC2QJzcg3c2So+I0zfs+IP2af7PdReMHvw2O+IsBd0UJP0mH9DpXz9I6HSn6WqWWpn+DmwbVVx/XxzV18ZDK4ig9MeaOXZIJH1WIBrQao3bqdDqnUOInBLQ8mhJ1QrppjwYf614CXwz9g+RDPFyPtsLu4sB0q5iJrNEjdZZQvjy0sjR2LtorF0Vq+D9wMZe5q6PvmRN7hI0ODWfft3E9iwhvbS8X9uYkyGMMWYuaHSX3bwZcu3SU6m0zLgXbtyy2ubt8F4fuO4qa4My8rjjs/w9AvM285uGlFKFevKt7cRmZ+O1MeCncJoSVse3m2IOadhuzzrxAlhYjeEcuBlQlD2BKIt+5+nPZxRrRNIEKzurIhiI0lC5Om7aJNHO49jz5Fre/VdYf8k2yZ4LsdcKIR7QPxmJXFM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/25/26 3:40 PM, Tal Zussman wrote:
> folio_end_dropbehind() is called from folio_end_writeback(), which can
> run in IRQ context through buffer_head completion.
> 
> Previously, when folio_end_dropbehind() detected !in_task(), it skipped
> the invalidation entirely. This meant that folios marked for dropbehind
> via RWF_DONTCACHE would remain in the page cache after writeback when
> completed from IRQ context, defeating the purpose of using it.
> 
> Fix this by deferring the dropbehind invalidation to a work item.  When
> folio_end_dropbehind() is called from IRQ context, the folio is added to
> a global folio_batch and the work item is scheduled. The worker drains
> the batch, locking each folio and calling filemap_end_dropbehind(), and
> re-drains if new folios arrived while processing.
> 
> This unblocks enabling RWF_UNCACHED for block devices and other
> buffer_head-based I/O.
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> ---
>  mm/filemap.c | 84 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 79 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index ebd75684cb0a..6263f35c5d13 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -1085,6 +1085,8 @@ static const struct ctl_table filemap_sysctl_table[] = {
>  	}
>  };
>  
> +static void __init dropbehind_init(void);
> +
>  void __init pagecache_init(void)
>  {
>  	int i;
> @@ -1092,6 +1094,7 @@ void __init pagecache_init(void)
>  	for (i = 0; i < PAGE_WAIT_TABLE_SIZE; i++)
>  		init_waitqueue_head(&folio_wait_table[i]);
>  
> +	dropbehind_init();
>  	page_writeback_init();
>  	register_sysctl_init("vm", filemap_sysctl_table);
>  }
> @@ -1613,23 +1616,94 @@ static void filemap_end_dropbehind(struct folio *folio)
>   * If folio was marked as dropbehind, then pages should be dropped when writeback
>   * completes. Do that now. If we fail, it's likely because of a big folio -
>   * just reset dropbehind for that case and latter completions should invalidate.
> + *
> + * When called from IRQ context (e.g. buffer_head completion), we cannot lock
> + * the folio and invalidate. Defer to a workqueue so that callers like
> + * end_buffer_async_write() that complete in IRQ context still get their folios
> + * pruned.
>   */
> +static DEFINE_SPINLOCK(dropbehind_lock);
> +static struct folio_batch dropbehind_fbatch;
> +static struct work_struct dropbehind_work;
> +
> +static void dropbehind_work_fn(struct work_struct *w)
> +{
> +	struct folio_batch fbatch;
> +
> +again:
> +	spin_lock_irq(&dropbehind_lock);
> +	fbatch = dropbehind_fbatch;
> +	folio_batch_reinit(&dropbehind_fbatch);
> +	spin_unlock_irq(&dropbehind_lock);
> +
> +	for (int i = 0; i < folio_batch_count(&fbatch); i++) {
> +		struct folio *folio = fbatch.folios[i];
> +
> +		if (folio_trylock(folio)) {
> +			filemap_end_dropbehind(folio);
> +			folio_unlock(folio);
> +		}
> +		folio_put(folio);
> +	}
> +
> +	/* Drain folios that were added while we were processing. */
> +	spin_lock_irq(&dropbehind_lock);
> +	if (folio_batch_count(&dropbehind_fbatch)) {
> +		spin_unlock_irq(&dropbehind_lock);
> +		goto again;
> +	}
> +	spin_unlock_irq(&dropbehind_lock);
> +}
> +
> +static void __init dropbehind_init(void)
> +{
> +	folio_batch_init(&dropbehind_fbatch);
> +	INIT_WORK(&dropbehind_work, dropbehind_work_fn);
> +}
> +
> +static void folio_end_dropbehind_irq(struct folio *folio)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&dropbehind_lock, flags);
> +
> +	/* If there is no space in the folio_batch, skip the invalidation. */
> +	if (!folio_batch_space(&dropbehind_fbatch)) {
> +		spin_unlock_irqrestore(&dropbehind_lock, flags);
> +		return;
> +	}
> +
> +	folio_get(folio);
> +	folio_batch_add(&dropbehind_fbatch, folio);
> +	spin_unlock_irqrestore(&dropbehind_lock, flags);
> +
> +	schedule_work(&dropbehind_work);
> +}

How well does this scale? I did a patch basically the same as this, but
not using a folio batch though. But the main sticking point was
dropbehind_lock contention, to the point where I left it alone and
thought "ok maybe we just do this when we're done with the awful
buffer_head stuff". What happens if you have N threads doing IO at the
same time to N block devices? I suspect it'll look absolutely terrible,
as each thread will be banging on that dropbehind_lock.

One solution could potentially be to use per-cpu lists for this. If you
have N threads working on separate block devices, they will tend to be
sticky to their CPU anyway.

tldr - I don't believe the above will work well enough to scale
appropriately.

Let me know if you want me to test this on my big box, it's got a bunch
of drives and CPUs to match.

I did a patch exactly matching this, youc an probably find it 

>  void folio_end_dropbehind(struct folio *folio)
>  {
>  	if (!folio_test_dropbehind(folio))
>  		return;
>  
>  	/*
> -	 * Hitting !in_task() should not happen off RWF_DONTCACHE writeback,
> -	 * but can happen if normal writeback just happens to find dirty folios
> -	 * that were created as part of uncached writeback, and that writeback
> -	 * would otherwise not need non-IRQ handling. Just skip the
> -	 * invalidation in that case.
> +	 * Hitting !in_task() can happen for IO completed from IRQ contexts or
> +	 * if normal writeback just happens to find dirty folios that were
> +	 * created as part of uncached writeback, and that writeback would
> +	 * otherwise not need non-IRQ handling.
>  	 */
>  	if (in_task() && folio_trylock(folio)) {
>  		filemap_end_dropbehind(folio);
>  		folio_unlock(folio);
> +		return;
>  	}
> +
> +	/*
> +	 * In IRQ context we cannot lock the folio or call into the
> +	 * invalidation path. Defer to a workqueue. This happens for
> +	 * buffer_head-based writeback which runs from bio IRQ context.
> +	 */
> +	if (!in_task())
> +		folio_end_dropbehind_irq(folio);
>  }

Ideally we'd have the caller be responsible for this, rather than put it
inside folio_end_dropbehind().

-- 
Jens Axboe

