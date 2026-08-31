Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5428C61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 09:09:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAACF6B008A; Mon, 31 Aug 2026 05:09:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5A9A6B008C; Mon, 31 Aug 2026 05:09:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A97426B0092; Mon, 31 Aug 2026 05:09:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8A7CB6B008A
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 05:09:45 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1E0D080414
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:09:45 +0000 (UTC)
X-FDA: 85160991930.09.79EA3C8
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3FB0A140004
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:09:43 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=IKK5Ykil;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf09.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788167383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aoEjE8TELGQjXx5xs4Igsq3G0G5VVqVmGoWAazModw8=;
	b=XsibNJDo9UGJ8Q9zzoUgwsxI2Ax93q6Rb6pxeMxiss4FskqyZnMk4mF3ZqYrrySxlyxC0r
	b7/GggvJfM8GX8ep2oUfDTCDDsYINFvmz1pNJAQvqWlb7T/Je4eoFlICaSs0bNGef4x9Jp
	YdtKVnAdIzackXPb9DvRMkBPqKuYDsk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=IKK5Ykil;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf09.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788167383;
	b=ZtBPTcLfPZAhHOmre8x9omKYltpAlEz1/Rjuq+cGaxURXUXLyBSspb9xAiKbs1Qv6MYdx0
	V//Wz3qAPnO1aC2S3u+8PLxu/LDnQJg/kxbd8q3pP8uDcO8dNkux8txIq/HKAO+gtlmvsI
	ObdZ/+z9AZYpPYqFGMxequfUr8v/1kQ=
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-4843e9c5960so338459f8f.0
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 02:09:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788167382; x=1788772182; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=aoEjE8TELGQjXx5xs4Igsq3G0G5VVqVmGoWAazModw8=;
        b=IKK5YkilUSWp5Dh7K0vo5LW9pmDeEMRgc61b+GcfjataloHfyY+9Pu+LDEz1b9xVM3
         bhfX47nPmXn/vs3yTE/8HOoGEDiIM5iBJF2HjioIfTAgX1/i7G0Tu8ia3hjfhrzzY4xG
         ddrNTPMOH4UNLjRknxdchWKPYSs0SG0a2oAhY9CAhJlr2R+BiegbxUJLTGKZU7yx8EwZ
         Av/yIm9pYP6V05cs3jtYkpx4oo5WAQxkXoZKaedZBiwYOg6rHdwS4hoZwrfnweQOyoLd
         w5IvxK+6GgKUa0J/U7C0Daj0U5egQ7fZ5TQqI9+GfTR5mNBBJr4B7zcaq53/TtZR6epZ
         lHhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788167382; x=1788772182;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aoEjE8TELGQjXx5xs4Igsq3G0G5VVqVmGoWAazModw8=;
        b=r7r9Y0yTlT8UobBuELAN+SgnKTYyIQoLrxj3lZx86YLJHyijgqLIgP0CH7auxGW5QQ
         bWm6Z5J53xujNAEzP1N/l5dJExcgYHzQp8aCKs0Zryvb5XP7O9wC3MS0VCA+XAuH+Pmp
         Dnv4rJ5gHbs2z8TMWnkFKa2tawhiHkXEM7X0Yqty8FcB5U9eUn1G3B72S7jEdwUvmwwr
         mHCrJ/IN1CDRSTUydiVzq/xFoRvToMSHQmTyAm2rrGBNQutAwCVV+A/kagxgHKQNOF9f
         WV00VIxtTyoesS1bNb93y+R6zCBCIMY3eD8z2e8NaM8hu+JdhxbVDCWiqMi8nhZgc0Qv
         IcdA==
X-Forwarded-Encrypted: i=1; AKwUvByJpm7XRyKxb9R+Qgkr6hT+m90O5JCTIN6v9/JFVezK3p0NeF3zQAzn79amvlhJp5Guzw9eNiTqXw==@kvack.org
X-Gm-Message-State: AFuF++kvUGJozvM9bka7lOopUyKRk/WollMycYj9Wc5jMNYmxOlgv9Eq
	AZfz5MRXniaHiS3gx1892loVnlsenz+iheagqHR0QKsGv7+N0Arraofd5xTetXG/tA6u9hQXS2t
	Rq+6jqP8=
X-Gm-Gg: AYBFou2UimAilJHPjSm+4+Z3TnxAgjEfYnRYOQ/Qr4DfmO9IV1iN8SaDUtQ03jkhrdJ
	9AR499xbUrqVj/IrgAGCOlA87OWfaWJb4DlJg0izF9jismj7fd//ATwta6PiySkl4RBD1E7s75i
	+VrMpAJv/qgRDS4zq2iPua49S7uDiG4jI+ILeQSpML+TtIKD++vsd098QqnP80qlsySwP6MPJSW
	x0DY8dxIN+FbVwJJgAkjx8h+3Pw0isRWy3Fs7yRqToD/nkA9tTaIqUukQffBettAaH2WnrnYG5V
	1bufPdq9/dOijEh1KuM88GyFAqgdqL1W3cfcoYTMjl1z8SKsEIslep/v+7NHYMA26zNO7VfMTOn
	TJkF4PRnO+Yye1EwEikWCOGwI18k9STPTrQf/o8V2xkGRGUnODJeYybQ2MBwvoFmLUd/DbkgeZw
	cN4XzP0wEbZQ7P/A0geE4G2rmkiQ4nVXbY4yeDF5Q/tZ2hD2AF7VB7yuevWC09ZoxRbf4q5C28D
	rpgHA7Kslxa
X-Received: by 2002:a05:6000:288c:b0:484:3bb9:25ca with SMTP id ffacd0b85a97d-4843bb92758mr8741566f8f.12.1788167381881;
        Mon, 31 Aug 2026 02:09:41 -0700 (PDT)
Received: from localhost (109-81-17-247.rct.o2.cz. [109.81.17.247])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482fbb28492sm20835619f8f.31.2026.08.31.02.09.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2026 02:09:41 -0700 (PDT)
Date: Mon, 31 Aug 2026 11:09:40 +0200
From: Michal Hocko <mhocko@suse.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ye Liu <ye.liu@linux.dev>, Ye Liu <liuye@kylinos.cn>,
	David Rientjes <rientjes@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm/oom_kill, proc: replace magic number 1000 with
 OOM_SCORE_ADJ_MAX
Message-ID: <apVE1A1pI4Ad6Ts5@tiehlicka>
References: <20260811033609.3992348-1-ye.liu@linux.dev>
 <20260829201310.648ed330984b91b1c135d8a3@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260829201310.648ed330984b91b1c135d8a3@linux-foundation.org>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3FB0A140004
X-Stat-Signature: r8kddut9wgng7djrdreiomu7n44hnm3i
X-Rspam-User: 
X-HE-Tag: 1788167383-881690
X-HE-Meta: U2FsdGVkX19Xcr+gRJBNfNdqgXaH5JUiAIKPDQRCPSXqLjQ/K6PVNxfI4V678y2y6so5D7Ibugfxrii+mOb08HCg/EPlUIjY8g8HVC2JROKwd3nKhKZUbjTx9iumdE2Xbbc8GbDP8nlvHCWUO60/m9iRRGvTAPMvWICOuyhGafdm6D92m6C7Z2tnmATOPqYQjTcsUOGULepg3xGocZAjO9Wlym/8NByu7I10E8L6lXVbSCTwN0qtYC64m3SwF/7zBarG3u6bIyoKOjR/k1h0QxlG5ncrozOpHstJavEeL+MdNxRvjMWjlyUxHaC6zBXHQwQAmJwAsdCK42+zQReFapVOlJR58P1tp4kK/AoJBP12aBSPOz562kJ1+tfTvOdxykCxpwt8/u7mluDwp9XcHp+rr47u830q4CSm6ZmSoYAb6APUMmSp6fulqmil6GApb6L5fzupLdKKGIBDU97a6+5biIg0fshYlgprn7FwrzukkiRQW3Vd5MlNLx8Wf6VZnJp1quTAQ37HdlBJP+G/pDf91Ke/0pQR9JA/rKyz2jtT+HO4VQZixT6iBOFis42umCdKpabjdD0UWcUx0ArpmJjpIXf5o96Y/sKLrqD8MdxE3wOZKhH4XNP9soGlH3mAeKZsRm9945oOvmy8R/Fong3QYl2jQZ7JEdlUf+UYX4rW/hl4G6DtndENkSWc7NV4fjFp++Whv3GKiGhZjOsFDmKhbE/qY9ZsKia1i2PyJNGnIWVlk0RLEY8/Ao8ttMHOH7hVTOnIGIv+jdZSzfMci5J6OUKX1ZrXs1yh50C8fdVhJFiTtmj9tfYWCNFF+IVNWBaL64sWPUMpLJ36ct76yrpbQRERDR4vYKHXD6Jdhg2umKQLpzfesD0mVVSXE/u38iQn1XygNNlm45mU/S41T6Lfp3N9skc43PsAPPAWAeeXrDYFr0/TbYRCRqc1twtnWOZzrVA9lLqpR68eYnJ
 mWqrcNFK
 vi3bRKerjDeufpu4c2WNxEq2PxCCbibnAwy/GRErAGIAWGD1VKFd6tCSVEdZOWudIZ11U2dWLpcXV3E8vv1SGCpt8Hjfv/0rbRAKnWmJUIc7OiwJOU3pSXRBWuXEyJyOFBO8p04LP9IYa1kCVeJ3tU+Jc9qW4qcPIBeZ5F3L+F6HzSrI8v6yhtXD9JaqDE3vIakg9dMlHLfGHDWt2xhLmK+NnRcnV5HqDjMoiwRT2RInLeGU9G5s58NdkooDX0xVDTE8qy6NqpFrgOw5nuf9p/bBJZKK0sBwnRF6MnwwM4C92zDfAukpoiu1UH7Jj615gfy0+OZJaqdMmVorhLsaqh9npFWhpVrxFFHVylKn79GL+N1rSBLKd+bnI1tIo0iAPVOqUNyfSHoAd/0Bi/xNJV6SVR2TZTsXyvhpydiozgrQ02pEfhsRxgVZEH3uLaD4Jz3hVJRMJr0UV45I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat 29-08-26 20:13:10, Andrew Morton wrote:
> On Tue, 11 Aug 2026 11:36:08 +0800 Ye Liu <ye.liu@linux.dev> wrote:
> 
> > From: Ye Liu <liuye@kylinos.cn>
> > 
> > In oom_badness() and proc_oom_score(), the oom_score_adj normalization
> > uses a hardcoded 1000, which is the value of OOM_SCORE_ADJ_MAX defined
> > in include/uapi/linux/oom.h.  Other code in the kernel (e.g.
> > fs/proc/base.c oom_adj handling) already uses OOM_SCORE_ADJ_MAX for
> > the same purpose.
> > 
> > Replace the magic number with the macro for consistency and
> > readability.  No functional change.
> > 
> > ...
> >
> > --- a/fs/proc/base.c
> > +++ b/fs/proc/base.c
> > @@ -594,7 +594,8 @@ static int proc_oom_score(struct seq_file *m, struct pid_namespace *ns,
> >  	 * exporting for a long time so userspace might depend on it.
> >  	 */
> >  	if (badness != LONG_MIN)
> > -		points = (1000 + badness * 1000 / (long)totalpages) * 2 / 3;
> > +		points = (OOM_SCORE_ADJ_MAX +
> > +			  badness * OOM_SCORE_ADJ_MAX / (long)totalpages) * 2 / 3;
> >  
> >  	seq_printf(m, "%lu\n", points);
> >  
> > diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> > index 5f372f6e26fa..08bff7a55db8 100644
> > --- a/mm/oom_kill.c
> > +++ b/mm/oom_kill.c
> > @@ -230,7 +230,7 @@ long oom_badness(struct task_struct *p, unsigned long totalpages)
> >  	task_unlock(p);
> >  
> >  	/* Normalize to oom_score_adj units */
> > -	adj *= totalpages / 1000;
> > +	adj *= totalpages / OOM_SCORE_ADJ_MAX;
> >  	points += adj;
> >  
> >  	return points;
> 
> AI review suggests that this is a misinterpretation of "1000"?
> 
> 	https://sashiko.dev/#/patchset/20260811033609.3992348-1-ye.liu@linux.dev

Sashiko is trying to be clever and it is simply wrong here. The scaling
fact is indeed the same as the OOM_SCORE_ADJ_MAX.

-- 
Michal Hocko
SUSE Labs

