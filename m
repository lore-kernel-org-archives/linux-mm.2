Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07B3CD58CB0
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 00:51:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 152636B0005; Sun, 22 Mar 2026 20:51:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 102F16B0088; Sun, 22 Mar 2026 20:51:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F33706B0089; Sun, 22 Mar 2026 20:51:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E22D76B0005
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 20:51:43 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 78142140944
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 00:51:43 +0000 (UTC)
X-FDA: 84575500086.19.F9BE5E3
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf05.hostedemail.com (Postfix) with ESMTP id 746B2100012
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 00:51:41 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PjNYi4jk;
	spf=pass (imf05.hostedemail.com: domain of leobras.c@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=leobras.c@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774227101;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ESxewFgBZK9Bi/7rvM96reuYPehT0FaQvK288Q9oKH8=;
	b=2svHXzK6QFgCOC4rNUBCl1x77OOoycVkRgRgTt0VRIAnxx+kF4eEuhhK2s3HvSB9T1KyDg
	x0OWZMSA603TlB7XO1FH+wakE/vgOMup/IdHJBB130mC0VYbTKjNDy2Ft+ySD2Y45iOpLl
	bqIe6kxSvo+/K01qtux33nBk4iNNnVg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774227101; a=rsa-sha256;
	cv=none;
	b=3wq+PvjgS06IA5XP4EC9fq//D4R1Ay3208n0VfpQjddsDXTpyZx2/ji57l6JJXXuZzKNXC
	HkzcXMIJV7OrCeIegiLddXMRKMZIF3yWluk6YDrbgvnB81u3lxq9aMUGdY/LEfoytaOa/p
	hagyFyT2goh4RISmPFNnyDtxFoDxtuI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PjNYi4jk;
	spf=pass (imf05.hostedemail.com: domain of leobras.c@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=leobras.c@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-48702d51cd0so21221325e9.2
        for <linux-mm@kvack.org>; Sun, 22 Mar 2026 17:51:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774227100; x=1774831900; darn=kvack.org;
        h=content-transfer-encoding:content-disposition:mime-version
         :references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ESxewFgBZK9Bi/7rvM96reuYPehT0FaQvK288Q9oKH8=;
        b=PjNYi4jkE9Ghu+pxOv2GxS5+0IgcbXZeHYm8Z27RvMwnbnVcMAle8dVqSy9H2P99b9
         9Gyd6SW7TYkNfDnfYo9Jc5HlZaKfnOtO+4JyaxIV7HKZb2a3MxA9FEBgUfcmNNmQTk5c
         r618Zux+KWtUCmJ3Pzm1OsEkdFRSgAFjBJ/z5vJEDCDdhJnuLLPfhuLeXbOCdTKJn4Hn
         +YGjlNVGTimTdv8waAazJE82v1NZHGS2/j3i+LR7+k6q8vdZtZMozykfaN3b0LBToGd6
         wUEymAkedy3jvUq65L1MzSnnqmPvPBlx5Wn964uNXFxJrmHYLsXC6m/bIfqGkJwfEbSu
         F8sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774227100; x=1774831900;
        h=content-transfer-encoding:content-disposition:mime-version
         :references:in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ESxewFgBZK9Bi/7rvM96reuYPehT0FaQvK288Q9oKH8=;
        b=KJqSUFWvt2C5pFNaB88UiXoOWtH9U+bJNozUWucQpT6XTwpj1FiUif5wICXrcr+Dla
         ySIoVOvjcFxM+rWIL5wXPGPRVd3oKoi/GmJy6Wf0uW40vFcBWXQ+d4rODrQ35xR+0v2q
         LEvtgjKQ1R+YriipDvbyWafax7obwuTYGKi1V4a6aHE+cvqkhFqyWg0IyW+Ig615d4p/
         YWBGtKIx84gQl4oaUb9VpUo7VsmBywFNkYRSYMKgRtxClmKI2clUmyjv8HZa01sSHcAx
         BS6MHgRsA6OIa7rUzEptEhik6cCd1TFeJkhz0ohwxWLnt5m/Y1ov8g4dmJYHDtdJr3e2
         qP9A==
X-Forwarded-Encrypted: i=1; AJvYcCVqUv4bCnej793ttEXUyG8LY3+3d0w9uPAkgLbgZyUiNqK1s15OLtlbU7v1n2nnwKYVH7hx6o6FUA==@kvack.org
X-Gm-Message-State: AOJu0YzSsXPk1Wl/wfN1ez+Udig70V3eJJjMHCWHi5sXS8iTt+N8lRyc
	SL8yxPSWEi/jHj48GX6HjCLPGZorsdpiw8EU9hPLvA0LzvqleMg0VYiv
X-Gm-Gg: ATEYQzwSmPe87gh+w5CPo4JH00sc2+mzXhHd7bcsAgZSY6dYLmma+fRhnrUqgBu55QQ
	KfKTR0J8led/7kyDCfhFf5SpGe72qhc17YBjROtkCWwKTQLct5fs4e4qDm+QPrMrYE2zmVyDjrN
	j0IabGW33pMZqIJpbAffg2j2Yu7ScMn5k6b6gYaL2zAzqO6TnGxDSyLLpjbEKVu15rZ3nkIQOea
	C3Ho6xXB9SIBe9u1KGP1dq+J5dofCCAnWvv5fLhyfQtrHH7Ueo5LxIk3oWOTynxsgI8CKyReHpv
	KgM5nMQ0091hNlUEs+vJUnM54SuEtxaWJ5VQzdEyU9ILDMtq+WboTNa91HnFubyR88P0K9yFMKk
	fA6pa64its8TmrhhPgx2518UHxv64B06YBNizMBIgk0Tt2wb+xfpYf7RBu4g1M31r9Xh+76vyCl
	B/qiuX0ehn8KaAynlGvzSF9unEh5dZewAXe2I=
X-Received: by 2002:a05:600c:c168:b0:485:40c6:f507 with SMTP id 5b1f17b1804b1-486ff04b4e9mr141252745e9.30.1774227099659;
        Sun, 22 Mar 2026 17:51:39 -0700 (PDT)
Received: from WindFlash.powerhub ([2a0a:ef40:1b2a:fa01:9944:6a8c:dc37:eba5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-486ff19d393sm71543635e9.16.2026.03.22.17.51.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Mar 2026 17:51:38 -0700 (PDT)
From: Leonardo Bras <leobras.c@gmail.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Leonardo Bras <leobras.c@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@linux.com>,
	Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Waiman Long <longman@redhat.com>,
	Boqun Feun <boqun.feng@gmail.com>,
	Frederic Weisbecker <frederic@kernel.org>
Subject: Re: [PATCH v2 2/5] Introducing qpw_lock() and per-cpu queue & flush work
Date: Sun, 22 Mar 2026 21:51:30 -0300
Message-ID: <acCOkgEQWW4qkX9M@WindFlash>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <2d3ff0fc-17a2-4425-b949-b5100251f98e@kernel.org>
References: <20260302154945.143996316@redhat.com> <20260302155105.214878062@redhat.com> <26662caf-de09-4f13-b374-dc7f879b7829@kernel.org> <abbuWGMv4D_1ToKl@WindFlash> <2d3ff0fc-17a2-4425-b949-b5100251f98e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 746B2100012
X-Stat-Signature: aps3enbjgi93hq9xjs66azzi1rty35iu
X-Rspam-User: 
X-HE-Tag: 1774227101-302276
X-HE-Meta: U2FsdGVkX1+WwinUuwuGVinUbfBxoObRq95Ys0sY6PgmcxJZrICXrXPSH/Jk5g+/Cs4OXAtZ3ZmpCZX2jftTh0pXOC8NDWMQGndcWlGn+jW4Siw2V3z0yjUDAtwVm6/QXgqAtxUv2ltVcUrPjTquMz+F44bdkLvKAAR8oUKRSJNfaA0QcE8nlze8ztBqewahJsA129wyensPM3TCCPhRC0900k73zhd6JLyiMAJmjlg5GRBQ7yB8UKj5RedvtBBkdnL5090uvfVPum0Qj0Yzp5BgkcjbOnSvLTrv5hZS9cYdLEoFRNbWaNkGBZ74eMqQx48Nx1+Jc0DTCpI5uD/w0GegcVUMl22Hg5zXbdVVbx3kcRRJW1CTORpN/8hBOkPP4hOJ7/HNCEfWlgJDqJqzBlvIz2TmsQhBXGFODt9XW56X0tGqN4MpXFqFiUxK5wRXIhl6djRG87Cp8Pvy3/Kk/0IEU3XXGDyvkpWziLKAlOnd2R7mFmN+XeCLGwBgklCH7N1P3hkftOazmA2Qe4+n9wurUMDoly9LCwRAYUxgCpCPF9EspRhOp3D9Y0p5TmjnzKvLDK0ioJvtdRUoHcXSf9kBH0BafI0UjIZEFmpS/geq2+6q0RMKiYZC/m8eYb6gQZ3k9e77PW3qkMeKTb96YeW/y+CrNuJx1LkAJoPjfbrvys7ygIUVS8p8yAVuYHbC8eacio5NfQWffPQr7eDbnWcLAaM61QB4Nijf9g7Hka50HWWT7753CO5Z19xamUkvsgwvrqy/KZIZgNZxjgbMFTRrOm+hObkcKSXZJ/GUvkiY8xtbfcQZCrKPSyRTtTlc5jBVuNo3PpcI6oYM/3OC3Dsbx81gCpdpaAXMlaWEwaxYL3pBwhRlCtIuYGzWSFLecGMOV754Zy6WCXGjV/vEFW1XWo7Fj+QLqOWe5PZ+P+DcYSS1WgZXq3xNyBg2Pe0tmRSaQGtU2xhK9nit1OU
 9SmqP7PL
 aAeBMtbbaoEHIHZwuiBfBTWWImUFIYzzay6Q5viYb2vlN2F2SYinXkWktpASa5llZ2JhBXumeFDVeRjlSqnz69ggInKtZsKelgP2/BaqB3P1HHQTdoHF5JDdv8Iu4CyAsqNB8kMKrmjd4YbXrGaZLIweiLJCmgxjXFczIhzZy+Forfq2jtxKCXwzXr7ltEV+UQKrPSuC/e/o/NMCZP14zzOEkMbFJpRcRqmgLa1oFZTwSOpgFvapejXjl4UtWyaq6HrwuTRgnPcAiiqVjUkNIOgsRD8v5gXnlcaOQ0zFHzIjN/lODG+VElRWxSmLr1VgYX1uhndlSop3wggp1GhyEGOhShHQYp2kYhmOcGPBGRhtwoqZDX7cO55W89++UVl2/LiO4LKzcyQe1oLyfMvDErqCHpnldwDDVsP129i3TJaBACVoc12tFRngE5Wkp/tmsj8Tr8tUWZbiuUlq3Kx2zYx4MjmdMLY/wjKRS88Cp5dSzlJaW/DEKUe9VmO87TtE9DOf7yM8K6onnw/W8xAiLoiyRb/E4W1ojJmi7m6jL6NYajhmkD0W3BcKD/X7sJZJeAT4DHtkqsLlSjVP5aUqUG0kADD9YNdlQxrwReUDCnk2DL9g+8B9yS77B1uPdtQd4oCSP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 16, 2026 at 11:55:46AM +0100, Vlastimil Babka (SUSE) wrote:
> On 3/15/26 18:37, Leonardo Bras wrote:
> > On Wed, Mar 11, 2026 at 08:58:05AM +0100, Vlastimil Babka (SUSE) wrote:
> >> On 3/2/26 16:49, Marcelo Tosatti wrote:
> >> > Index: linux/Documentation/admin-guide/kernel-parameters.txt
> >> > ===================================================================
> >> > --- linux.orig/Documentation/admin-guide/kernel-parameters.txt
> >> > +++ linux/Documentation/admin-guide/kernel-parameters.txt
> >> > @@ -2840,6 +2840,16 @@ Kernel parameters
> >> >  
> >> >  			The format of <cpu-list> is described above.
> >> >  
> >> > +	qpw=		[KNL,SMP] Select a behavior on per-CPU resource sharing
> >> > +			and remote interference mechanism on a kernel built with
> >> > +			CONFIG_QPW.
> >> > +			Format: { "0" | "1" }
> >> > +			0 - local_lock() + queue_work_on(remote_cpu)
> >> > +			1 - spin_lock() for both local and remote operations
> >> > +
> >> > +			Selecting 1 may be interesting for systems that want
> >> > +			to avoid interruption & context switches from IPIs.
> >> Requiring a new boot option is always a nuissance. The cpu isolation is
> >> AFAIK difficult enough to setup already. Could the default be that qpw will
> >> auto-enable if there are isolated cpus configured? The option could still be
> >> useful for overriding that automatic decision to both 0 and 1 for testing
> >> etc, but not requried for the expected usecase?
> > 
> > 
> > I think it's okay, as something like this?
> > (should work for nohz_full and isolcpus)
> > 
> > ######
> > diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
> > index 81bc8b329ef17..6c9052c28e3e4 100644
> > --- a/kernel/sched/isolation.c
> > +++ b/kernel/sched/isolation.c
> > @@ -170,20 +170,23 @@ static int __init housekeeping_setup(char *str, unsigned long flags)
> >                 for_each_set_bit(type, &iter_flags, HK_TYPE_MAX)
> >                         housekeeping_setup_type(type, housekeeping_staging);
> >         }
> >  
> >         if ((flags & HK_FLAG_KERNEL_NOISE) && !(housekeeping.flags & HK_FLAG_KERNEL_NOISE))
> >                 tick_nohz_full_setup(non_housekeeping_mask);
> >  
> >         housekeeping.flags |= flags;
> >         err = 1;
> >  
> > +       if (IS_ENABLED(CONFIG_QPW_DEFAULT))
> > +               qpw_setup("1");
> > +
> >  free_housekeeping_staging:
> >         free_bootmem_cpumask_var(housekeeping_staging);
> >  free_non_housekeeping_mask:
> >         free_bootmem_cpumask_var(non_housekeeping_mask);
> >  
> >         return err;
> >  }
> > ######
> > 
> > We would only have to be sure that this runs before cmdline parses qpw=?, 
> 
> I'm not sure it's possible to achieve this ordering with __setup calls,
> unless one of them is early, and then it might be too early to do the
> necessary action.
> 
> > so user could disable qpw if wanted.
> > 
> > Would that work?
> 
> The pattern I'm familiar with is collecting all related params via
> early_param() setting some variables, and then an init call (not tied to any
> of the param) looks at those variables and does whatever is necessary.
> 
> > Thanks!
> > Leo
> > 
> > 
> > 
> 

Makes sense, will take a look on that approach.

Thanks!
Leo

