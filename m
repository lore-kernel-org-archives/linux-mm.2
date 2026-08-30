Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C1ECC61DD9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 17:30:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D4F86B0088; Sun, 30 Aug 2026 13:30:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 586826B008A; Sun, 30 Aug 2026 13:30:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44E076B008C; Sun, 30 Aug 2026 13:30:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 07C166B0088
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 13:30:02 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4858C140292
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 17:30:02 +0000 (UTC)
X-FDA: 85158623844.08.4CA9686
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7B18B40003
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 17:30:00 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=nF0QxrzG;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of hughd@google.com designates 209.85.128.169 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788111000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r9bIKH9EdEupiOsvi/7uUfU5zw2gR56vprnADjG67WE=;
	b=VrYOh01OuagJm12CzBUO+hUg9YXeQpkNi8lWUQE61ojUIWK1AK046Kac60XWLtfAKYYsVK
	fMXtMkXZzDo02RIEuzHYdYDSgLI4rWXYpFywPBwhzUXGvYMqYHEWjgxGCDmH8MUZPo/y2R
	iBjULO/RLm140hZpJoN76Q+2x4qxdmw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=nF0QxrzG;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of hughd@google.com designates 209.85.128.169 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788111000;
	b=PWeNhu8uI7fcxpKDZU7gHG2UD08l2oaJByTQq1xRCpuMQV01K6L+vsJi9Cd5mudqegggkl
	g14LPjOp+TInTTF7lEefcfT1A6OKBSQ2aun+ZHlejqXUREme35uNfGQT0/Kkhb7LK9x5bG
	7Xk3zXX3GC2AY0FZaE8/YmMQq8GA53E=
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-81f3b227a4aso35664407b3.1
        for <linux-mm@kvack.org>; Sun, 30 Aug 2026 10:30:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788110999; x=1788715799; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=r9bIKH9EdEupiOsvi/7uUfU5zw2gR56vprnADjG67WE=;
        b=nF0QxrzGZx4/cbFLWnxtdSriDzUgMQzGEa5rGLzI/rQUFZ0/Pk06HMq+15PilUtR54
         spLcC0gCZJtimWehVLn9Qj10z4ZHFD37Wtim08bpui43p7YK3wLlUuKLnd3hAKf8dhD9
         O6lk+9uIR0HXNExxYVwkfbaI9qWYIsn3QZzrGuWLWChgfsSq0v+9mf8ob+jrpGWuwYej
         CyEqSmTmQe94K2t+3+hTpwYwHULzZdmuOLrT5zEDxtdtKoG6jgS0cGRzZ050xTI2ym2y
         xAQVnldbcBlT04MKM9sPO3ezvV0A/Ho6z7s5BS0uOlX314FZLA1SuOii54PsuosvUY0N
         LRJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788110999; x=1788715799;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=r9bIKH9EdEupiOsvi/7uUfU5zw2gR56vprnADjG67WE=;
        b=akeJRKfXTH3zuDECFMnjjPSWILxmlruicdj//Cwkom2VewlXnb0PMMANo8Udj9uV52
         DW8Ew6YxRJfRBibj8p19a8XqvDNR8XMp8v3yjyUO4kPIBs38FqqZnXLL+0m3tpaFWifa
         +nkGypx7UOjIcSiMtv+s7B130esTW0U7o2nd/qsoOetCu/4j2tjsCMML4/ShBvgjEROP
         NhRBXF87D5E/kMrwlUCaIXxtfOykXi5IKZpG3rAH64fYuYJmlpNcCQ3DOCOqHb5GNHu5
         DL3OJUn3SWtLAjsvtAEPbYuZtTU3yFdCgsNsDF6tOBNex02H/BMjXKSQ0tmAxzP0krU6
         /+VQ==
X-Forwarded-Encrypted: i=1; AKwUvBzawuoUbMvO6l5p6uDLbHeOv0svYAEY/rvCsxIxgeQQJqmBV5Ba5FrTM86HyLgl6zOStFF2qEyqfg==@kvack.org
X-Gm-Message-State: AFuF++lN4vjHIZfB13L6OO5mJaeHsiyHWS52B2Z2u9rearI7fTcm0wKC
	jltVn1lR5yrMBoMo1LKPvsKIogjQSuQwYy23IWBn5aeb9qJ4GthwDKTg1qNWDjrREQ==
X-Gm-Gg: AYBFou3db2NCPt+sZ8gi9vLwkYwrPRs4+aOmy/kaemwSWD5v47XWmNntwxhxjEjo2Fz
	FzvlemUuS4DYvwyhjekQnWINQzTViVYodeBVJLorL0vFWpDnEST/onnBTGEz0+k54PT3St4ISgv
	84XK8O0GFoCzasUYBxAlNH8lLFUf9xRkgmJROI7cm2KLIs4XM5qXnI1ivwXk4clYFjMiswD3M+9
	FGP5YFRsutLG5xdxBb9gHYJxZWnHpvu1+8Sq69Uvn19vsS5hgp0JQUGfZ+zCYm6fegJJHvgqx0w
	xMMT/ZluITnc1hKDIlG/YOzZCqfmXNq99Gka6ONR4CJSeuZLHOL6oaEPniuh7OBnH1RH25Vs1Cu
	YEtth0mgRRzg+bW5gMx6p3HYF7kfxIH5qMqGnfwSCFgDjHimiB0UeQxv8IMNNKlfrK/0XwmsYBj
	hPg2H9ah0RmXUsXm+zYj9+tAvzEhCcT6M89qW06aUiPFD9XB+NK17+kDlQ7eCQIjl+Sqk2/13AJ
	GokBlQhhlSpDHL7hxrSaQ41EZdVS/SfDgtp4gl9NdI=
X-Received: by 2002:a05:690c:c384:b0:85b:7fb9:22fa with SMTP id 00721157ae682-85d69e01880mr75661847b3.10.1788110999083;
        Sun, 30 Aug 2026 10:29:59 -0700 (PDT)
Received: from [192.168.1.137] (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-863fa116fdesm8698117b3.31.2026.08.30.10.29.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Aug 2026 10:29:57 -0700 (PDT)
Date: Sun, 30 Aug 2026 10:29:46 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
cc: Hugh Dickins <hughd@google.com>, 
    Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
    syzbot <syzbot+cd2073ee6d958a8d0fcd@syzkaller.appspotmail.com>, 
    linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
    syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [mm?] WARNING in __mod_zone_page_state
In-Reply-To: <apO7GDwIgyhdn3t7@linux.dev>
Message-ID: <4793259a-00da-ea31-8cbd-a6cb5bf48692@google.com>
References: <6a931c5a.08e933ee.dbf97.0093.GAE@google.com> <apNjw0HRyr1Oj7q4@linux.dev> <apOAF5CPFWUUH9du@linux.dev> <a2288e73-5001-2104-1e7a-2b383e7edd61@google.com> <apO7GDwIgyhdn3t7@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: df4qqhwgatgx7gpabzys8aj8okdc1x4e
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7B18B40003
X-Rspam-User: 
X-HE-Tag: 1788111000-263583
X-HE-Meta: U2FsdGVkX182eWXDJqHPPNQOam+5qatWQSaM2nxLeEZwdAPP3imCLJUB1cljNFqZbo1iIgbuUl5geP2bXdTBiJVGCT8Y+gPRv58S3fgh5T4hMl2iNhaAQJdMYbAH/leEtZMr/0nKDLHjojbNRPiDqBZly/2qqWggBvooHM4fNzScxxhVeCCDsrVS0yv/nTeJRO/69ZzfDMXflm9CKmlAUt35aOa87heBucrUKqvd4LT+Sz3eyAx+hBGTcXTidcKnNTaQsKm3ay876+MjwFHh8NiG7pBbP74ABoGgzkEfcLTW93P14UWg4u0CQ1Yif2iS1Cif13l3mdelWGn0D6Q4U2/gsEjSPsmoo6/zw3cWLFfdtZ4HcIPwRfBZxtIY63Id+jZ7zC8LM1ifq+3OmfyqtUr7FFb2V7pafS0rxRgYMNN9sRGMIDSuT3Tp59byvTf2uHPTgaOevPeXoBovU1HTyXPcHhFzMLoEfKW8nrcLnoy8Zsu3PsQg/8zxIykDe8EDyBz+nb9ZY5cQMLGihCK5ymqM6UC7TyLQxjn/P/6R5HyJ2zJDYgktW92fJTFJbJ1j/Gr7THZVpyGBymqODrT6q/9eEmwbnTUGIa6zXZowCliP0lt5rku1BBK+RVTJTS7mSyIOHfju01pUsl8VdYWq8CQX46Twg3y6utheUpzRS5m4aH9/2/NY3p4oBVGQfzfpusSpxiAUI82b2CfH5LJ8rAfhcNpyb74lAiZB0ISobJcY68hAGuI15X6DbQ6HTRgH0D5/CahMJAswANXuJWaRn3ByBjLNzlkESixThusoWZsTQSnQ0SI4EeLILJtMd29T0lBEeWGuIMjec1B5OrVRFkMJAR592NQx6NWu3ct+lwi9OHGkzpnL1BP/90Her4xeHxyZKytOgD68WgQvxbu8gOaI9KQjRLIt5qsKSwgeMulVKBCNdKkKsqAQ9GawX4J3dVotl4Hvu3A62Fr+1jQ
 1MmI5Rai
 S6tsUH/xC7ACyl4W0HwiQwBQaYG8anq/OmNaWzt6RWyZOnzQDzJt2NRJnNYhICb6qusCUEJ7HsYzVJQrd/1vRF8NPKRwrkf/RPCPv7ZlxkAoi28daSEZooapDYuEextOVMtD196cmrC8bHtFl6uT1l1SEg6rgkrj5K40XOj7hyT0VCMifqx/62ykWiRXGASp2QS0CBbq9I0Y2nwXYC7u7TdoGxLPe9ZGp8w9b1sqN2VpJAG4U46oaAQ+yVevdrSlTAQc9KKy3usf4GEGWPt3t1R1pGzkPo+nMRPG55yuPJlpQxM/LLgqFUehHX5gAP0VvHU6tnEtwlgOX/nD+ln9N+gVluabXXYNhJt8cLCakG+kEsRO0s4FqUzExnXQ0lkI864PfATBietemw/nq3H7xVsfhrbb9jfNr0t4gVYMJxTTXDoq0kaVb3btF5jvVuSBJGveKNfzcKiDw4KTEzd174Ww8rf7WcU1s1VF4yGLaW+LyPpfcGlkPDyNxnLTl/ghsajJUmoHEu0wbjUCwVeGSPzBcnHYdRPjBf4EJZzO6DVudnylS6QHYn37b1+k1KAKdlRYS4HGiZuBD7N4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 29 Aug 2026, Shakeel Butt wrote:
> On Sat, Aug 29, 2026 at 08:26:02PM -0700, Hugh Dickins wrote:
...
> > 
> > Thanks for looking into this, Shakeel, but I don't think complicating
> > __munlock_folio() is at all the right fix. This is peculiar to the use
> > by mlock_drain_remote(), isn't it? Which is not taking the usual local_lock
> > because the CPU is going offline. I would say, just take the local_lock in
> > mlock_drain_remote(), but (I haven't read the history) for all I know,
> > there may be PREEMPT_RT reasons why that would be completely wrong.
> > 
> > Hugh
> 
> Thanks Hugh, I will explore the local_lock approach.

Please do. But we may need input from Sebastian. So far as I can see,
page_alloc_cpu_dead()'s neighbouring use of lru_add_drain_cpu(cpu)
would suffer from the exact same issue, there are __counts there too.
Maybe syzbot has not discovered that yet, or maybe I'm confused.

(But you'll understand that I don't particularly welcome a reorg of
the local_locking around the lru_add_drains at the moment; and there's
at least one among them which takes advantage of the fbatch local_lock
to lock something else too.)

Oh for the good old days when we were allowed to say preempt_disable()!

> BTW I simplified the
> fix to the following. is this still making things more complicated?

That is less distracting than your first one, but it's still not the
right fix: the right fix is to have the function called under the
proper conditions in all cases.

> 
> diff --git a/mm/mlock.c b/mm/mlock.c
> index efa6716e4dfb..fa30ffed76ab 100644
> --- a/mm/mlock.c
> +++ b/mm/mlock.c
> @@ -141,11 +141,16 @@ static struct lruvec *__munlock_folio(struct folio *folio, struct lruvec *lruvec
>  
>  munlock:
>  	if (folio_test_clear_mlocked(folio)) {
> -		__zone_stat_mod_folio(folio, NR_MLOCK, -nr_pages);
> +		/*
> +		 * This runs both with and without the lruvec lock held, and
> +		 * mlock_drain_remote() reaches it fully preemptible, so use
> +		 * the accessors that serialize themselves.

I'm very far from being a good advisor on PREEMPT_RT,
but I think that comment about lruvec lock would be wrong there.

Hugh

> +		 */
> +		zone_stat_mod_folio(folio, NR_MLOCK, -nr_pages);
>  		if (isolated || !folio_test_unevictable(folio))
> -			__count_vm_events(UNEVICTABLE_PGMUNLOCKED, nr_pages);
> +			count_vm_events(UNEVICTABLE_PGMUNLOCKED, nr_pages);
>  		else
> -			__count_vm_events(UNEVICTABLE_PGSTRANDED, nr_pages);
> +			count_vm_events(UNEVICTABLE_PGSTRANDED, nr_pages);
>  	}
>  
>  	/* folio_evictable() has to be checked *after* clearing Mlocked */
> -- 

