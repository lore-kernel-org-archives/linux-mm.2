Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2CECEF5856
	for <linux-mm@archiver.kernel.org>; Sat, 14 Feb 2026 21:32:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE8E96B0005; Sat, 14 Feb 2026 16:32:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C96D96B0088; Sat, 14 Feb 2026 16:32:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B990A6B008A; Sat, 14 Feb 2026 16:32:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A73EE6B0005
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 16:32:49 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2B5571CB62
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 21:32:49 +0000 (UTC)
X-FDA: 84444362058.21.EDA78BE
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3C36B180009
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 21:32:47 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=U05S7WVy;
	spf=pass (imf06.hostedemail.com: domain of leobras.c@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=leobras.c@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771104767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rz00tC8xFfhwICo16BoBKz05b7In7aurUZExr5lcT2s=;
	b=KG8v1uwVJ6W9Y8PEC7mR4UuhmZZoRRjr1jCPgOuj+NF4BKopYzpmyxvHSUNswZbx/6Y5KY
	7O+CCedcWp1v1v6NTDVPBvQb5h11fFaVdvl6uMTdtCqz/KIFACwzGml2n46SSFU//umR52
	r5NdIVrIpJvxq3j3r6xPhbZ+cmXUFVE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=U05S7WVy;
	spf=pass (imf06.hostedemail.com: domain of leobras.c@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=leobras.c@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771104767; a=rsa-sha256;
	cv=none;
	b=xZvKp2XHy14uLURq14sE0LScD5k64JQfS0uD0dTaIz1/mEEsqBqcOFl34UD2LDuZJJTApu
	WniTePy9S1g3ZbsnDklkZs1xJ8lankWIABA0Jp1JhrPPVc84Rv86u386z7J0902leWNkmT
	35T3HymV+CfYg8gpP+sTQusE22M2Nik=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4806f3fc50bso23831475e9.0
        for <linux-mm@kvack.org>; Sat, 14 Feb 2026 13:32:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771104766; x=1771709566; darn=kvack.org;
        h=content-transfer-encoding:content-disposition:mime-version
         :references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=rz00tC8xFfhwICo16BoBKz05b7In7aurUZExr5lcT2s=;
        b=U05S7WVy/JFYqU6l4oTOmYDRciXE0gFLsjGwYa3vLWkmf/PLrA/Mjvbzj3TLoWOw10
         oS7nP3Ps9wJFmLvEaaCKKI2gHXGpQVcsVRouSVFuCq9AIkVrKv/z6mlY6uti8mV40QWq
         wC5bSENQ/MLwTk3n1byqRfxn5kmlwAbSpYLNaa0T+5pxspGS9YLXgXx2XDxIYuiROL8A
         abMdPmIHkUojTYS3v4zKLrx6Lyw11TvqOge1ZosAH889EeqRj9hv5EX0MODn44iftdzX
         5M1QUeUTOv1JogyBQuGDs2bXbCALYdrzj8Og6bqJtJ0oJ4VJnjeART/x/f9xzIFiEoIL
         v+8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771104766; x=1771709566;
        h=content-transfer-encoding:content-disposition:mime-version
         :references:in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rz00tC8xFfhwICo16BoBKz05b7In7aurUZExr5lcT2s=;
        b=VbvLaQCQj8YjMbjZLrXr607L5iB3KK66B3RaiOV8Sn0U5bw+wfjM+aXpbhJEthdetB
         /cuLcgzY5PGBKDvyT6N12PgZkknt4AEV8IqywruDmbR8aQfP/pVUpWg2JPzlfdNPtZ77
         O+O3VRs5K3KsoBp4IX74GZhshwkWcLSBeBnhUHBK3SzKdfLA0dPwz4gE09zoAC6iSYJN
         aB73KXGcoxW+pW2Zvppf70iYo7pUlvNSDifBhETjFrpdUXbA2QxmPcE+GTbqI7cB1OQO
         C9Z+nvMcKWXZI83SZgNcPzgPjRg+D0dhWG624ALh3MsarxoTZt6Tin8J1KxLwozauEy+
         /GOQ==
X-Forwarded-Encrypted: i=1; AJvYcCWqJe0QWf+4HEpocjXjH1xcoit9gHbUGsbLU3UYHl7o19W0KJZuTomDAUmhHVaXbG7lxxaNp5Z6Eg==@kvack.org
X-Gm-Message-State: AOJu0YyGNEO9TSVkTPcy7979FmJmoJKRLnH3Lss4rN9O6DbAdCfnhmXv
	fC6iIvBD2A7UDb3dLBauHPbv7J3+Yl68kCNhXDB85cAAplxl3pBUJCSJ
X-Gm-Gg: AZuq6aKqaPZGYZxXni7pDm8PjkjZ06/DipuhemhcdRr85QRjARNx4SOY32nEBnM0cqt
	EWtlDnKiejG7xbJOB/piDDRM6Cqk1RQh6Z2rKFcKTPVH/g5/4Xp1hJLjM+9p9tXF81Pvh5UEggI
	+j+ITEXp+PSdeIKYwnX3dkCB2frPbQ91mnCH0HGzYdk7/LWaF04sratQ55IP9Gr8Ic2SRydBJTZ
	ycEVquY2d+8/9bB3QlNq/PR02XwtSWBWb6Ed13e37DhiWnewxRVdyHt4ef1Oc0Y6yI+heXSz7NB
	5OYJaZdLo6lZV+zlu+SGh28uuLRsFEHFoFzoS1Bp5MHwU/eJbe4nYGYmHoOSSKCREyxzenY9bt6
	zeh6J/4P4sNckGsWmGunJf5NAWXxw8ts8w9bDvKh8QVvZ75JRBLjpYi8dlZbksLysOv5f7P/Do0
	ybW9V8tNi7AIxpgoT4csQILV3y4X5h6END93yzltiOHA8qCA==
X-Received: by 2002:a05:600c:1d0b:b0:475:dde5:d91b with SMTP id 5b1f17b1804b1-48379be820fmr59932915e9.17.1771104765392;
        Sat, 14 Feb 2026 13:32:45 -0800 (PST)
Received: from WindFlash.powerhub ([2a0a:ef40:1b2a:fa01:9944:6a8c:dc37:eba5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4835d994670sm238736745e9.4.2026.02.14.13.32.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Feb 2026 13:32:44 -0800 (PST)
From: Leonardo Bras <leobras.c@gmail.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Leonardo Bras <leobras.c@gmail.com>,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
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
	Vlastimil Babka <vbabka@suse.cz>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Leonardo Bras <leobras@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Waiman Long <longman@redhat.com>,
	Boqun Feng <boqun.feng@gmail.com>
Subject: Re: [PATCH 1/4] Introducing qpw_lock() and per-cpu queue & flush work
Date: Sat, 14 Feb 2026 18:32:30 -0300
Message-ID: <aZDp7thqWGHfs116@WindFlash>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <aYxxXrG1UVvHUGHP@tpad>
References: <20260206143430.021026873@redhat.com> <20260206143741.525190180@redhat.com> <aYaEZGImn7qayP12@WindFlash> <aYxxXrG1UVvHUGHP@tpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3C36B180009
X-Stat-Signature: 8tw1mm9naqhe6w8boiz8bwwg4e47fbn4
X-Rspam-User: 
X-HE-Tag: 1771104767-141501
X-HE-Meta: U2FsdGVkX19+Hg4MeTowchN5ROzV8fC8rPxRa9sH976XTg7V1C0rAPIlDII74pc+M7WFAuTLTjoK2npUp4u+kOQL102nkIdcAZEMqyoORPZ5PSEWzbf1GVm+VorAKBYfVgNQe4bAGviuOfGFqY8KnQpERgxe04IlMbo5pFQCKY7nWCmvIVZTtOQLq2C/GP1gH7v2sFmgIZQJP7zCBemu1uocEZIyVCbz9Ad/uSpQufkCoZksetqUcyvo9zOEtjnTS89fbO4bGVI6D1ObU675GeA/XaW++IcIrYgRu1sdJBhr1rl7H1zhqiW1zfwQsmOrJMStGwsJPDMh2hfjAWt010DEcX8E9pe4JX3mgUYI5eLfSXGx5jE6t3y4aI6NGa/VChXalpGH05xqQrDf+G6lb9mM0OiE/OgaDConEtI65g+Sgd7fSdsyOTFGMTsrrMeiX9rbhH5gMM8mjMYRvbZOvlzcjD+ajUxkBIkC5/Qb9MnLnsntqF+Z2zPirPTuEccSUEdZlnQqdKHG66c6pXgnlavQ9QJDGfdkKZfH/IKOHGt38RV7zzxe9TSREMUYoGi3JphchhJgGSz75FggdShIxx6QLCRW9e0TAhONAH49wx60LeYhQ9/g3EWiwJRffN8rumZCVMIgeI+XuhxSlKQK+ZwC0WiqCDp7i+RBRNdOk0oCsOgqgADEfjFfkMuRkjo+VvfJqIAgyzQE7uqTwtrwQzdCrjyxZNOLlHUAlg1k0ehNHCytxaqFDDR5lZCM6PMl1ZmvC7474qtGic7xauRcmxXhgTfCc+PxQ6rDQO++XlQ3MIPwhtaTszCBOeg5Sz5G5uunkh7SyYUxzUio+g//7pm/54vgb3BbQFFg4yMnG96qzD6vZ7H4kl3iOa8oquXcsuTJustcvUrae85Tf791zGTp32AbUEF2JOcwc78w8HftoVTrrelpUlO4dYHYJl2n6CxaFOiGFbCnwul05cc
 kcjUNix6
 OUsgbSaMkYlwO1as3xHD5EAf07uUZTNwycQrpGONqoBPglAhAd7xVDNLf4BXZuZgfZoBqp3KKbY7fwfQeGfVOMtfFlNbbimxmFJE2c6aDlTH2vrwRfgxq/ss7td3yt4dSvLJPhryWYWSWuupHp0OXNYjyct+B2CJ74WBQgEvUIQ/IqJdGBCUSP/WP1dZtd29DaAJ1KqjtI4zFNxGDsjbiQCgTxFHrv66Bum14lVDwSi83No+m0dSod9fvJycmIv1n2pAAP/qE27pCsla9MzrAZZ1hDvi1DKiFGXPe0/bFpd/8lPVDVUnt6GW/MXMmEvFDNe2SUexjEHIi9cZsG0ItK6f1IibrEWjj8wtAT8gl04mKJTVfxMPKPqrQd900bKTYRbG7igPRGThTT5nfbb/DvEirPJ6ucRs8Lvlz/RpOnnChqDvKm0w0pjsh8+KJZc4YGw8j37fkW7j/rsG38hyKDHu/nYfHufg1yYavquqD9MOma1E7GrJCmZEBhI76WSJzAoj2C8Pp7Q+cgEzlwXu6Qa+uPtu6WGS5SLdrEAkp09mGuC+rIKeuq2jZmbD/4RXqFVmn95ohuAbeiuwWBn2HkmRlOZl7myZQm30xxmb8t/fhpKN0rgiXdRZTMDkJnHMLvNOroByG+3Fcth4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 11, 2026 at 09:09:02AM -0300, Marcelo Tosatti wrote:
> Hi Leonardo,
> 
> On Fri, Feb 06, 2026 at 09:16:36PM -0300, Leonardo Bras wrote:
> > > ===================================================================
> > > --- slab.orig/MAINTAINERS
> > > +++ slab/MAINTAINERS
> > > @@ -21291,6 +21291,12 @@ F:	Documentation/networking/device_drive
> > >  F:	drivers/bus/fsl-mc/
> > >  F:	include/uapi/linux/fsl_mc.h
> > >  
> > > +QPW
> > > +M:	Leonardo Bras <leobras@redhat.com>
> > 
> > Thanks for keeping that up :)
> > Could you please change this line to 
> > 
> > +M:	Leonardo Bras <leobras.c@gmail.com>
> > 
> > As I don't have access to Red Hat's mail anymore.
> > The signoffs on each commit should be fine to keep :)
> 
> Done.
> 
> > 
> > > +S:	Supported
> > > +F:	include/linux/qpw.h
> > > +F:	kernel/qpw.c
> > > +
> > 
> > Should we also add the Documentation file as well?
> > 
> > +F:	Documentation/locking/qpwlocks.rst
> 
> Done.
> 
> > > +The queue work related functions (analogous to queue_work_on and flush_work) are:
> > > +queue_percpu_work_on and flush_percpu_work.
> > > +
> > > +The behaviour of the QPW functions is as follows:
> > > +
> > > +* !CONFIG_PREEMPT_RT and !CONFIG_QPW (or CONFIG_QPW and qpw=off kernel
> > 
> > I don't think PREEMPT_RT is needed here (maybe it was copied from the 
> > previous QPW version which was dependent on PREEMPT_RT?)
> 
> Ah, OK, my bad. Well, shouldnt CONFIG_PREEMPT_RT select CONFIG_QPW and
> CONFIG_QPW_DEFAULT=y ?

Oh, I sure think it should, even if not doing so at the current patchset.

But my point in above comment is that even if it did, there was no need to 
mention !RT and !QPW, as RT would select QPW, so you only need to mention 
QPW :)

Before QPW having it's own CONFIG_ I was using RT to compile this in, so 
maybe that's why the previous version of the cover letter mentioned it. :\

Thanks!
Leo

