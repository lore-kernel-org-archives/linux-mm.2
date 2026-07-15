Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39EA3C44507
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 19:58:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 382806B0093; Wed, 15 Jul 2026 15:58:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35A036B0095; Wed, 15 Jul 2026 15:58:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24C816B0096; Wed, 15 Jul 2026 15:58:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DBFC86B0093
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 15:58:29 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6FCB0802AF
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 19:58:29 +0000 (UTC)
X-FDA: 84992073138.24.2243E14
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf30.hostedemail.com (Postfix) with ESMTP id 523E580002
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 19:58:27 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="U1Q5/qZ4";
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf30.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784145507;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i7g5eqdlgx0iQFnR80osVPUiBhoOkK3DmjgOgLSkYmw=;
	b=KpmC7WnuRzbXj3JNfSV2uQQMAxrL7JSYfowzaC/IQh0hsXfuj4yH0N/7JMkeIglx1AmQPp
	kNBXkF2qwa3zu2IAur3sr1JhEEfId4L4i44URdToEC20dJM02xsMamnwLA+3A2UPkjNhFv
	5Uc77hOJG6FVeE3bCVUN7THyht50luI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="U1Q5/qZ4";
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf30.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784145507;
	b=xXJ6tuL6YXMulcrbeM/c+sJX9V9rqT2jXJyHAjz0UyRTyemRX7a9NlWscacR8Sg6/NCTWI
	nWDUaC4J+3SWP0Iny/tEyvUEE/IvcVfjOB0bpaxjBqbnc18qGkfYqGJpD0sAO1/VM4LsIU
	ce0FFXZwg10tkkxa1BFT3AeR2yeWd+8=
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-493f0ae9572so24182955e9.3
        for <linux-mm@kvack.org>; Wed, 15 Jul 2026 12:58:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1784145506; x=1784750306; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=i7g5eqdlgx0iQFnR80osVPUiBhoOkK3DmjgOgLSkYmw=;
        b=U1Q5/qZ4bF1tKOhEBz9ET2G9ahAocHb1bY0ou+LuqkJ0B3OGDaKAapK5qncMku8o9R
         nRjOBUxh6SdockHz6cCAw3DAflY6wwbd0WHZZb66BmQ/20o1XUaurestuOVC5NpZOjZG
         O9zVDI5gCBg0/Vbf7X7WEt6+VYnAcjU/xz5v8IF+AM3CDzJEbTwAIfmzaycYiAzSODRF
         IHLEm/9eTYR3w9rdQG7PGAnz91/J5yYCLW1sh9M/JcaMShspVWV/cSmKWHNM3x8EjzVH
         LoMLC413Pxtg/ZoyC0AJMU6DFC/mE8ubcCFEmdzFHvx/Yhmm2J1yAyH+fR5h+ar8fcLl
         R8wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784145506; x=1784750306;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=i7g5eqdlgx0iQFnR80osVPUiBhoOkK3DmjgOgLSkYmw=;
        b=VMCtrYjboxKuJ2BNgilxRMXdKRTxZzFzpQ0tAvzn4yuY2H56MRCcVrdlCrbpXFnB2B
         PLROvZZy8CYE+3H3rWNwdUei/MvDbRSJJ8FdJ/bQiPbEd3AAcU77b527xOOpIiBd8Jr9
         rON0uSUn0eLfRUAtmiU2LWrVpEGPAKt7n0iV3ba7zZhVEKGAKjqi/LdldB9ki0rkk26E
         1aEx/SSim0ORSmcVf617lsRUTHAqzNWDNfWXZQBxfVQgdrnec2Xh1nRdMfptE5iTWAIu
         jtLg2h5VD3tk4goL92GuTjhipiUkniju1KtD+fbgs8vffio+N1vmFXzhGB2aDDPn0Mtp
         UgtQ==
X-Forwarded-Encrypted: i=1; AHgh+Roveev7/p7EqY0KiwrnzoB/8dOK+UQxnuplfAdm53AvFVpm9xrkFZmidNJXBh4zzmaZHxlSGer62Q==@kvack.org
X-Gm-Message-State: AOJu0YxxmZmyMQ2BiCMKqRIIkXj+djX3Y6CEKf3Tti+YpVhGd7Lrdb7l
	v49m1HC60PPl/LmF0/3MBdseFeiga+2hEICaccxaNkfQFFWoVotGChxZfI50xJDjy7w=
X-Gm-Gg: AfdE7ckm3LH41jekWAWo6JPmxMfJgbkuvXL2IV48aGTAGk94/psJnMMCYaC4NwoXM6v
	x+Fapawqm7+nNcZopVRxN5HFiYnKcgkoBKCfh7dqDKhJczjg6OF37piKFfivfNXNTcUiKZ55ba1
	TH3t710LqM7MiPLdmLAXSSU5U7Tv3pDv68W/1y2gRX9JJoGF54LpMXuxsI/zoP5aSNiuL+MMOMY
	6c6mYpuzcp5BpZS0B7vA8kcRdToIfZkfrkWfgUAtyKhdV1DbqPr9Vh4aDX0cF3S81uTbgqYQ/rZ
	EeYboGCYxrtXuH1LaQ7tQhkayPDP4+1iEEc942Pf+C4k2XbtH/yL3q/XvNJ4buJMQ4oMVb5MDmB
	Tw+LRNj2mqFYsuzUbssx/QqNIaud9OCNBxjjbHaepxpZzu4tfyOdcRKRcX8ZU4zzqw8FRFWroHA
	vfM4ywOy8eNfTOEo8MEy/D20oFnQ==
X-Received: by 2002:a05:600c:6285:b0:493:c42c:7e87 with SMTP id 5b1f17b1804b1-4953c2800b3mr44437405e9.33.1784145505792;
        Wed, 15 Jul 2026 12:58:25 -0700 (PDT)
Received: from localhost (109-81-95-153.rct.o2.cz. [109.81.95.153])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49541e7d21fsm6718995e9.2.2026.07.15.12.58.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 12:58:25 -0700 (PDT)
Date: Wed, 15 Jul 2026 21:58:24 +0200
From: Michal Hocko <mhocko@suse.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Richard Chang <richardycc@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"T . J . Mercier" <tjmercier@google.com>,
	Martin Liu <liumartin@google.com>, Minchan Kim <minchan@kernel.org>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm: vmscan: abort proactive reclaim early when
 freezing for suspend
Message-ID: <alfmYBUxZOhFY30r@tiehlicka>
References: <20260709072231.3163082-1-richardycc@google.com>
 <ak-OyACkE8lLaRRS@tiehlicka>
 <CALC_0q8O1uw18aWM8w8be60TxW02Os90AKSOLFoqubYAbLjkrA@mail.gmail.com>
 <alCQ28gBclWOFF4_@tiehlicka>
 <CALC_0q93iheF=Y36SSTg-XCoKgHrhxk88LqcQkDd-O3ymMVmxw@mail.gmail.com>
 <alYqVPEyZ2ySrdAm@tiehlicka>
 <alYuKYnHgAaOFz-z@tiehlicka>
 <CALC_0q_9DamACOEyXeevWvq-6D9dQZ6NNt=iBN7gkOQRM9xqfw@mail.gmail.com>
 <aldJnz0u1YyoCyGr@tiehlicka>
 <alfHuSTW8sPAl9l3@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alfHuSTW8sPAl9l3@redhat.com>
X-Stat-Signature: suwgs9req6rb4jzzp1ieyetbue7ktpjq
X-Rspamd-Queue-Id: 523E580002
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784145507-801451
X-HE-Meta: U2FsdGVkX19RSTy8RiyixRbvENM7E6LKaN3uVGaRv/BuanFhdyjclCN+Y2jSzy2PfhmC07cvzPan+0Pqqb7fOCrbMSDNwMq1Gh1gsxLkCzk4zpnHjZs4jKSMBNXJjjR9xVMr8qQdFB5uR7d6sVkhCaZQO1uTofTyLYu7D9KOmmyS4Ac6Kmh1DTAxDhAJ0KCaT3/eeOFuznN6JwPZwRWTZ5ZdHo06JBN6p4GKjMZfyDxgndD/x6eLqiLOS6dN/gs9y9e24FIt8eofMxDwKGc1S6dBw3OFf6Q2mlJMZLz92phtfyaJgTV5xJPEoAwisJQMXg3tSLuw73GVQFARrDhOMFJLMRlhKZym3a5ZJIt9LEd3HRw8qoztrsryPa55+ddCIX4gkxjZe0f71+/flbgVjQdOLzdjnWmzdDMrU7AK3jr65hFkEufGgsu3Y2udQ/GHJw5wnhOXfjz7RJZco5PVrqx0+p5hq+wdtgLNJdF/kSI25XppKuQ1ZadYjsZ0tQ4Gk/iFophyRXWIMKcfa+cYbqOfM2jxgEm03LvOPEkJEwen93YJMyXM8OH+wC268eFTs7GzrePM9skygi3nDeZ6tIhyQL6AJsKh06Ju752yQTNuSAqvTlIiqTHGPRFPfRD0Xs1//yJf4a6bTPrhFfd58ZxZLBKwfrMfCFnfeacrSnLtOP1oBL7Bt6M7sI/YJk1BacTeCV1LIkEzAiOz1mUSHU6lX2K8iSYSYm+MjZmwbO8+zrcPIoEa5cctd/YsI0r399Vms+8G0GmkuZDpWSaApkNn2bv2MYL1X+2pVVBzqm6iEO3YX7/DuL/PNr9lb8xnNAm34PWSCIQKwRFr4L1CZKdSUvfmx0XvuS3DgPUytl91AyH1k2t7mPkPK99Zr+vRk9H1xq2GUn/eIntTKPnuNFrLKuv+TiFtaP9kAfSBt3QpS94OhiFB0Wf9S9Ijy4fiNxsO9nBjnj10TQ5WvO8
 AVG68wRe
 VfqQsKFY0/4xVVdDUnuYAmmwtLR21cWGBKUHXjkpi1Jq3WNmrwY4PPp0jUzFuc3X7VhkNU4A/rFtUiN1Alx+8rmz6yClldpR9ElC2P5rYI7j/EyA4Cc0BW9FEiLJhv9UUJneqLkAQsmXn51UnMzHtEiiVYxSfh6GOLZIOP++lkQD7+qrY9ovUaPFHkWrrINkdmNULKA9/ZREgpAQpyU6/br8nlpKfeDcg43fkG9eCjxqfkGjBxrpsgip3f45bNaUM5WqKTn6fUNofTflZjaKse7NfRH587xRirNlZJ1wJ1l9GdPcpwN3WsnseNA/LsLfBrv0T2i7obrlsh2MbSzd3i8ci0PW/S54UEKXcScYQo332QzU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 15-07-26 19:47:37, Oleg Nesterov wrote:
> Hi Michal,
> 
> On 07/15, Michal Hocko wrote:
> >
> > Oleg you haven't been CCed from the top of the thread but TL;DR is that
> > we need to freeze a user task performing pro-active memory reclaim that
> > might take long.  Currently we are calling signal_pending to bail out
> > but that leaks EINTR which is bad as freezing task has a side effect of
> > terminating it.
> 
> Sorry, I guess I don't understand the problem...

the problem is that `echo $AMOUNT > $CGROUP/memory.reclaim' can take
quite some time and therefore block freezer. Appart from Richard's fix
to bail out on pending_signal deep in the MGLRU reclaim we have this
signal_pending in user_proactive_reclaim which would leak EINTR if the
source of the signal was freezer. This is IMHO undesirable. The proposed
change below tries to address that problem.

Makes more sense now?

> 
> Yes, unlike EINTR, ERESTARTSYS should not leak to the caller (just in case,
> debugger can see this error code).

Yes, I guess this is a general constrain to any signal_pending() caller.

> But I am sure you know this. And the patch looks fine to me.
> 
> Oleg.

Thanks!
> 
> > 
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 35c3bb15ae96..336af76d2a28 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -7909,8 +7909,13 @@ int user_proactive_reclaim(char *buf,
> >  		unsigned long batch_size = (nr_to_reclaim - nr_reclaimed) / 4;
> >  		unsigned long reclaimed;
> >  
> > +		/*
> > +		 * Make sure that we enter freezer without delaying much and
> > +		 * leaking EINTR when that happens but also take care of 
> > +		 * fatal signals to terminate.
> > +		 */
> >  		if (signal_pending(current))
> > -			return -EINTR;
> > +			return -ERESTARTSYS;
> >  
> >  		/*
> >  		 * This is the final attempt, drain percpu lru caches in the
> > -- 
> > Michal Hocko
> > SUSE Labs
> > 

-- 
Michal Hocko
SUSE Labs

