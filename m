Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D002DCA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 02:49:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB5EB6B0137; Thu, 21 Aug 2025 22:49:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B66626B0138; Thu, 21 Aug 2025 22:49:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A55976B0139; Thu, 21 Aug 2025 22:49:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8F28F6B0137
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 22:49:39 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CF6AB117C8C
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 02:49:38 +0000 (UTC)
X-FDA: 83802862836.27.A53023F
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	by imf12.hostedemail.com (Postfix) with ESMTP id 06FEC40004
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 02:49:36 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=MdlP4KWh;
	spf=pass (imf12.hostedemail.com: domain of hughd@google.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755830977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eJgMemiOWP2L5ptavtO9iXqPmjWF2lP/8znZnsFWHb0=;
	b=m5ZLm1eJWIe338HGGwklybVl9z2+vw3FdhQSoV8oo7MVeHmGXAksc6yOdWMwC/R2FxR98N
	Ig4qI+SwTPHJNbSfG/uUKMwluU2wW5taUFSxuZMVtLMa4lHVQIUoPxHfNuOhzbxWlUH145
	kdePGAOJPHYU6nzcJjv6jcsZCv2GQUM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755830977; a=rsa-sha256;
	cv=none;
	b=M+voWLEJVnB5gzBv1y0ukbgzDUf1j/WbQ+MrhIKKPVReDBEGFv3gy+x5Zgp/VL82O5yLqo
	+avRo5v675PRCcdQTkSmb31d4QKdPuspCLLKgk3Teb4z3jLS8dlNdQonJ9sysLXrPgDpf+
	40EmesA/iqd4aJmSEL5eOyg23EpSMTM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=MdlP4KWh;
	spf=pass (imf12.hostedemail.com: domain of hughd@google.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-71d60150590so13871507b3.0
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 19:49:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755830976; x=1756435776; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eJgMemiOWP2L5ptavtO9iXqPmjWF2lP/8znZnsFWHb0=;
        b=MdlP4KWh888Sg47XnvXpSdZ2rt60sp8oMM+EjdNTf5Bx1/JxgJPrXCo/pB9MtFwg04
         2bujNH+VPe/hSKIXS80t1RcP+IMriGhQ0v8/F7CBuTt8dNOY7F/0aKi34GHdH96aLheo
         WPYvtz8rnP83nx6B66XCysED+nVFW250cpIEhjZr+aFYOUmuXK8BTQIYpJ1nvog7r1Dc
         mS2ILl9H9wORs65BoFUZiZ8cwcfr8o0UjBL1g40eIxK63xorWpbLa/jyvppJIM9SILyQ
         hl7N3/iNNXyigwMG0KF8TkU8/E+y+sp9/70ulYiNWphOuYY1vAb2njmGjRaig/rW13vd
         SMtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755830976; x=1756435776;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eJgMemiOWP2L5ptavtO9iXqPmjWF2lP/8znZnsFWHb0=;
        b=hoWRQ6egijJQvHjsAugzHifsC1rKw+YZtYH2q6vHs/o3uGvLHUelyagArSuqN3dadl
         vZbsSQ7eD8AuGiVt5v3aryUxOKrNoIsc0MVNXHDEq8WZ856TSv80FhdRsx0NU9FLLfYv
         r85vIQ/O/m4w4WZNg5vKSpD+24Ljjc5KFBD1aRQ565l2CXEZOGGX2Pwgc4qtJMF5em6I
         lqp3LC9LpcGBHa5Ma95RD0n41iNzVP3IOGsoi23j7XeqafX+MmHkAtc+Cgmqh29HGXHv
         zkcjVZDne7OFm+vgMu84/iw/VIrFoox77vyhExhLPr55RsWEK54M7dOZn9Fo+4V2nnuJ
         78Ng==
X-Forwarded-Encrypted: i=1; AJvYcCX8USf5IwNqEaqAjo5TrfLDER4Fat5mp8skR3F3cqEODWc7queMl7l8v0zGjWBi3o5eb6hshRfQoQ==@kvack.org
X-Gm-Message-State: AOJu0YxUIjn7nTPTkGnCXVTQ+v46iG5IH3XvPt//saHgVKik8oIJJlks
	G+VkqRUnrsY+Bk4WI58rmI0bY0zAN+a6QlKknAHOTPaWMihVkrJ7DbytxDZLBY9KZQ==
X-Gm-Gg: ASbGncsSKdxlwlUM/Xz6OQylZcwT8tiuQMGJw/0CgvrKQ0U4OibG/u1Zk0+iNvMmJv5
	6ftyYwrnljA9zXNd0WoBW22O3jWUTjy5Gqq2GNX+lMSY6w+3mnfTWnlXV6EDyc8OTpMOMJQhGek
	Y7c5/2twzrIMEc6bZXgr+cwwvex7N/DFxQilUUkCh1Qafgcb3sHDyqAxASpOuBqGdw+RCyZIpTl
	ommFrGRqoUJnlW6iRtxkSEPL9s9s6VLkglFeeRnPd/w5w9fFFWbTgVX0Z+LNwqEM5FjwTNhh7MP
	YuDwTNTvCNLPTtFXYe/rsEDdi1NUyUKJd3PdgK4VYkbJ4Ba61PCFO+P+qKwavrlTm5+9aOu04ys
	ddTlKuJXzZMGxau4JCNv9i+Ph0j8W2nLbIqoNlb2fWYd7dxVFFMwxR9GH2exT1KkGfvd2SG8GBG
	QClpKc7yUQIzBBtg==
X-Google-Smtp-Source: AGHT+IGBZ1EWD4PIYFLvPV8xxJfPnPb/H3KLSOuO3XXH9AV7TfrQ42b2K1Lv37wXn0rhaPYprrXvjw==
X-Received: by 2002:a05:690c:6c0a:b0:71a:17fa:bf07 with SMTP id 00721157ae682-71fdc423f88mr12035667b3.40.1755830975699;
        Thu, 21 Aug 2025 19:49:35 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-71e6e0a9a26sm48207697b3.55.2025.08.21.19.49.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Aug 2025 19:49:34 -0700 (PDT)
Date: Thu, 21 Aug 2025 19:49:00 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Baokun Li <libaokun1@huawei.com>
cc: Jeff Layton <jlayton@kernel.org>, libaokun@huaweicloud.com, 
    linux-mm@kvack.org, hughd@google.com, baolin.wang@linux.alibaba.com, 
    akpm@linux-foundation.org, linux-kernel@vger.kernel.org, 
    linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] tmpfs: preserve SB_I_VERSION on remount
In-Reply-To: <0a5c4b7deb443ac5f62d00b0bd0e1dd649bef8fe.camel@kernel.org>
Message-ID: <848440d1-72d9-e9ce-5da6-3e67490f0197@google.com>
References: <20250819061803.1496443-1-libaokun@huaweicloud.com> <0a5c4b7deb443ac5f62d00b0bd0e1dd649bef8fe.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 06FEC40004
X-Stat-Signature: 7jio9d54eg94toit9wmkamrdzw84x86h
X-Rspam-User: 
X-HE-Tag: 1755830976-119850
X-HE-Meta: U2FsdGVkX18e+Dn4C5zMb3GfT87WKPzWRhLV2aEixx3r9NR+QdModSVTsBYKKRQsi9vc9Mf45glnfoFkbSs7wzKpWMgWkp6eRptrkLqRn8KU5DGZnOzn4ilTOPr8VnE4b3Y2vNtVoBdDDRHseQ/UaYNMa2SZyTC1wpiWL2085r36KkvXvUOS/CgygEjYNKKLk/PwvhDIt6TpELm1S3FFUgOPGg5kex/ipLVStYlNvaXP9VJbciIYPLNHHlBel8IoM0eVDdJovStOMck/aC4//rh5pvvY5G4cRN4BHFs5rQe4D2QcWOs7xn9GeU0nHufMB2wBk7E+pMNmig0egD/sk3mvoLqqwgehbCuWZ+G5S/WLFrfDL041wKHOMZ1M20VlflVTQHCmDuPkAxLR8I3rDfvxSD8HsMEIgErt+mdE+fqsbbUVJtUlUbNq7YxCg1L3x1rFGCtb+ohVw2Dr6TE/sNYZTsYavcz+t5mD6KprEaRmvNq9rSJ77wvpiQ0bz1Ktik58PGq2lw8Ko1MDkcNlfvRbhfzRMMkgPdZm1Wq7Y9hm2wDXLh1j7NwiS3C2kM7fisPl2WsGh/Sz6xTk78zu8aoGuDcFOQCej/2ZoGmc1R9nr0whkNnJ6FpJwcVFIhyac+xJVx9D47VEcKHok3x/pOOARltYJR2aqckESyLj7cLNSfPz2aDM2rCNGsPqqQh3fhldU25fXvp6cmasEGaBp2hMZG20ZtsWNz5GCVOH1hQJ6iUI/U4PUFjfN3OHVvPoJcTzxwjP6vJlaOJ1iDKcH2hn8Q8r3BGj4yXGmJ8OXBhhZk0rn//XadZfLrWHBMJkSs/8QsPKwLKwaD7+W69acvrT7MjZcqOzE5VYvyqQ0JNSu15AwmcYB7gV94T6xHWju99Ppm4PLqhZdmaqkVjsrrfXwn9DYLgSgdGhmvWWlmu8kVvZ5sOklUtjNYQkKa6DR2S1KcO0MW85HXzg7FA
 4WsDtRTS
 3H2EZIXuXsJn4Y3YEyuilz3ryUzLVxex6nVN1k7GMgAP0UTdL5ZWspD+eL1fqN2w4Yr9PaUFzL7K9ICOOz5aRyVB1ZteOyRGmKrXuEU95yIC6jWLrnmR9NGgWQEC26VVzkhKyw4h5bEM1JVDUEP5L6lPAnNHF8h21Y7jwJh/wj+Y3T0UoKfE93xr6wZefaW2FrYtFJJRA+VEn9Ll5U4E2BctCFv7E/WYivoSzhyym/EQhPOjBT3WZauiDwhbcE46vpuzbRkJ9m6M7Peo3Qn89+9pz29THpLb9ozlG+2aA3ySqzBDSt9gLiW8q1SM7NEwpSa2ANG9NIgSLuLfK4xw+2L48VAdV2127BJx1Hmpj1w5sm+4HnYA08J2Vx0r1fQQ4gkW+MeZAayszBEAvATPtN7xp3jDz+H6gtL4liFkKFb4aRlAc+ANLgiRe0qo2UJoCbiNkcajhsmgXOr7FBEkziLlsWg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 19 Aug 2025, Jeff Layton wrote:
> On Tue, 2025-08-19 at 14:18 +0800, libaokun@huaweicloud.com wrote:
> > From: Baokun Li <libaokun1@huawei.com>
> > 
> > Now tmpfs enables i_version by default and tmpfs does not modify it. But
> > SB_I_VERSION can also be modified via sb_flags, and reconfigure_super()
> > always overwrites the existing flags with the latest ones. This means that
> > if tmpfs is remounted without specifying iversion, the default i_version
> > will be unexpectedly disabled.

Wow, what a surprise! Thank you so much for finding and fixing this.

> > 
> > To ensure iversion remains enabled, SB_I_VERSION is now always set for
> > fc->sb_flags in shmem_init_fs_context(), instead of for sb->s_flags in
> > shmem_fill_super().

I have to say that your patch looks to me like a hacky workaround. But 
after spending ages trying to work out how this came about, have concluded
that it's an artifact of "iversion" and/or "noiversion" being or having
been a mount option in some filesystems, with MS_I_VERSION in MS_RMT_MASK
getting propagated to sb_flags_mask, implying that the remounter is
changing the option when they have no such intention.  And any attempt
to fix this in a better way would be too likely to cause more trouble
than it's worth - unless other filesystems are also still surprised.

I had to worry, does the same weird disappearance-on-remount happen to
tmpfs's SB_POSIXACL too?  But it looks like not, because MS_POSIXACL is
not in MS_RMT_MASK - a relic of history why one in but not the other.

But I've added linux-fsdevel to the Ccs, mainly as a protest at this
unexpected interface (though no work for Christian to do: Andrew has
already taken the patch, thanks).

> > 
> > Fixes: 36f05cab0a2c ("tmpfs: add support for an i_version counter")
> > Signed-off-by: Baokun Li <libaokun1@huawei.com>
> > ---
> >  mm/shmem.c | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> > 
> > diff --git a/mm/shmem.c b/mm/shmem.c
> > index e2c76a30802b..eebe12ff5bc6 100644
> > --- a/mm/shmem.c
> > +++ b/mm/shmem.c
> > @@ -5081,7 +5081,7 @@ static int shmem_fill_super(struct super_block *sb, struct fs_context *fc)
> >  		sb->s_flags |= SB_NOUSER;
> >  	}
> >  	sb->s_export_op = &shmem_export_ops;
> > -	sb->s_flags |= SB_NOSEC | SB_I_VERSION;
> > +	sb->s_flags |= SB_NOSEC;
> >  
> >  #if IS_ENABLED(CONFIG_UNICODE)
> >  	if (!ctx->encoding && ctx->strict_encoding) {
> > @@ -5385,6 +5385,9 @@ int shmem_init_fs_context(struct fs_context *fc)
> >  
> >  	fc->fs_private = ctx;
> >  	fc->ops = &shmem_fs_context_ops;
> > +#ifdef CONFIG_TMPFS

Ah, you're being very punctilious with that #ifdef: yes, the original
code happened not to set it in the #ifndef CONFIG_TMPFS case (when the
i_version would be invisible anyway).  But I bet that if we had done it
this way originally, we would have preferred not to clutter the source
with #ifdef and #else here.  Oh well, perhaps they will vanish in the
night sometime, it's a nit not worth you resending.

> > +	fc->sb_flags |= SB_I_VERSION;
> > +#endif
> >  	return 0;
> >  }
> >  
> 
> Reviewed-by: Jeff Layton <jlayton@kernel.org>

Acked-by: Hugh Dickins <hughd@google.com>

