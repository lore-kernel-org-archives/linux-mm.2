Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A29FCD6E5D
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 03:10:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CE3B6B008C; Tue,  2 Jun 2026 23:10:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97E586B0092; Tue,  2 Jun 2026 23:10:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86D9B6B0093; Tue,  2 Jun 2026 23:10:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7748D6B008C
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 23:10:45 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3FDAC140136
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 03:10:45 +0000 (UTC)
X-FDA: 84837124050.30.CC73A0D
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5F129120003
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 03:10:43 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=THhrHXKW;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf29.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780456243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AkUPkSV1yVhPwfuKkUdfLaMgLJzqLtKdtBHH9XilSKA=;
	b=239QH6gnsZNiurUEAoGY4l95QA8p5boI5pWpFPLHy24TXo+7Yaa4CSs0PhFcq+aaTM7Xvn
	nre/wBW1bPL3q8AMB2E3SiQPRoOPpU8PYQq5bi9AkWtXGBcP0OT1hvUrhlFNue8fwbBBhL
	vL4KVn6bXxLOXVxkTwfUVVtIIwQyQf0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=THhrHXKW;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf29.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780456243;
	b=rVaGlyBN3NUy8TgL/UXikxWyux/VGU16LwLdXAkZhCVq7kJilzhQebVEGcpTy1Ijz33fBm
	bbNjwk9UVodt9QIQNoJNI9+qKVTh5UZFzV88Hd/tkZDlS3drO8IEmEt7dPrt9x7OXhktVm
	4/pog5x5D4d0POjGHcv63WI/PyMUPNU=
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-516d0db9372so106740771cf.2
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 20:10:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780456242; x=1781061042; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AkUPkSV1yVhPwfuKkUdfLaMgLJzqLtKdtBHH9XilSKA=;
        b=THhrHXKWWV5IVNVSZJCldtjmEgLbXHW71lu4yH831bOiqO2pIe7exp3cC2MDBUh8Hy
         YGhNgeKzV6YOvgA3Ob9wqFKkFVon2m405HTZCp99GnJUt4kr9P1cgFLVGDQyU0MI79EN
         fDwk40GzrOqhW0PWlndyw3BdrlBbNJFSb9IUL+aTAWz+xB2VsL6ztMeW6BJDlANU6pBQ
         rjCAmbwVW9DUlD5VqC+tC+8KNslHzaE2etxXDaZ5mWINBRg1VDws/qzgEFL5zSPXuGfr
         6OYG1fYjaWDr+2x1UW+qW5sKJgRFhmrKvwPDP+QyjOVKQjd2ZZRnI5mCS+i6MrXQs3oY
         dkgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780456242; x=1781061042;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AkUPkSV1yVhPwfuKkUdfLaMgLJzqLtKdtBHH9XilSKA=;
        b=QdnkNIKVOSTeRNcUWXf9ZaE9rGn76DbhYlBEo1eYEYpw8f5dWUXVTFsVpgRuk2Y/ot
         2eqFoIjMBPOUzBE8Lhv6IB3pVp2Aujqmb4S6mbPRTuomx5hbsfKEbq3yjJyRolI6vgEj
         31MoM064gqZvOR9k8hS+LDfu5iBj0ATyW+plWnpFAhZ2OkJDpWExzWJfimOMhqyWPgC8
         wEXa8gCnMIVjw4FayN1cTdomsdQMVvRp3SEp5T+NX5CroKWryCstxFJss0S/ZoFo/MkP
         qz7+JlHCYcyG6z5xDIc9uapbRPyeXs88vHvcB7ynRxuwhlSwJMatFJBCjjheQodJaAo+
         t86g==
X-Forwarded-Encrypted: i=1; AFNElJ9rKKXRI+dRv+dOXstl1B5PEZylR6eZf2b4+DXga5UGKOtcfOFLCWqjXoTCZVX3wLL6mPyI+m9gcA==@kvack.org
X-Gm-Message-State: AOJu0YwV353uteERjHuORaDnKCeaj6gbpvpG7npIu6jmmplwCgYGP7eG
	Q86MThKVjK8FwIIOEQ52SeIHyI8z1aIurRRXEVsxmzm3L4vLHiRlEv1oIbyUaW+dvj0=
X-Gm-Gg: Acq92OEC/ba5TlYs8e2mFMgoCT2jNgORajkQIwICoQEzZSUB+tf8OefIjlGegpMpGIW
	fNrqumWGwVgmw6M3+YcCPERbni+KK+I/o1ipxhLLKNXLcqSl4pFSKRCz3r2LyYh4Zdh/mQhDa7Y
	S4Z3MlrpTnxthvg817cLDurKIArALUfMHkKvq6BXe9ik+46C3nnSVsjoeQL6YxFOu8FlbhuVmnL
	jwn4yfxvj0TImduPQBJ1uh/1P5zbzyiNQimZ7kMZVnCjvC4KKo8kpId9ubkUkIizss4mCylneKN
	MjFpcXQwIcKZdemucP+dS7TL1LzQgOfidPC667/FHbJmtZ6gvqaGGvEK/Amcu3W87eDXohPfaoj
	723n052zEY0R1ohBBNhMgDU+lUNKJKEMplLiUipBY8LAxC5YffHS8BSNs/L231Y4EHLfthcScVs
	NexAX+KP6DJnb4d1cZVW2A9sF/b/XyUf4DY1k7QmXpZFVkyHTQyDGroXLBqBO3j5wbueR4yWtl
X-Received: by 2002:a05:622a:2487:b0:516:510f:2dd5 with SMTP id d75a77b69052e-517786c83c7mr29904991cf.28.1780456242538;
        Tue, 02 Jun 2026 20:10:42 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51775c07f0dsm14637641cf.3.2026.06.02.20.10.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2026 20:10:42 -0700 (PDT)
Date: Wed, 3 Jun 2026 03:10:40 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, 
	linux-kselftest@vger.kernel.org, shuah@kernel.org, akpm@linux-foundation.org, linux-mm@kvack.org, 
	skhan@linuxfoundation.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	corbet@lwn.net, dmatlack@google.com, kexec@lists.infradead.org, 
	pratyush@kernel.org, skhawaja@google.com, graf@amazon.com
Subject: Re: [PATCH v4 02/13] liveupdate: avoid mixing cleanup guards with
 goto in luo_session_retrieve_fd
Message-ID: <ah-YOeu5PYa4d8xe@plex>
References: <20260530221938.115978-1-pasha.tatashin@soleen.com>
 <20260530221938.115978-3-pasha.tatashin@soleen.com>
 <178038801485.119771.9514973100282773342.b4-review@b4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178038801485.119771.9514973100282773342.b4-review@b4>
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: da1yk9xg34j5baq1awsamza63mw3e9h8
X-Rspamd-Queue-Id: 5F129120003
X-HE-Tag: 1780456243-164796
X-HE-Meta: U2FsdGVkX18R+zSRP0at0NnDInqdwNQ4osCK/Fri2eiRC1xsrYowdpAaivsgfD+13KomdHKX35AoNFqOAbBZ2wAUUSy6Rzg42OXUkILzZe4zqif2C3V8AMFweEJxmyXFjvDaNLreTr8m8DDwuOy3O5Ofhsj7lLvtGq1/J/PS/j3YmQkoN3MGV2EqLM97+1mjYyzWa+X714+inLw5OoSiLEhC9KgsrxHeP9Y/O4hS8DNBtyTyWCCOEFdFbu7uYAcrBTdJfY1K1pAh5KfIroV6HIk+w2DRKaVjFNbpG8dpGBH+8Jec+b5Qr/oYoCZbHiIi2+E7ivbgB9N3P0W5cQ6sjRNpEx7ojPCCfN48LLvcX7mqd7a4AHurUyQkM/kmbNpQs8Rs3diyVO++TmZMMLKc4ZOtk9SFc39JNJMnnL3iBp0ISTthJOl23+FV/gFYi958LIfdd4VJ3g03ZjjjK1DOZeiihBRps5IkS7+umfeSGBL+DDSBuFj06pA39B2ySm8cv+EuoD6buT58LH14zGLLq4QjL34hL0Qv9SbRvpLlYyfAezBbJGpEEkiKbRFUUtYF8cwdHfrC0rGoLGrzDx2WnnjoQ+sqNCYTRkxaRTc8SdMy77LvJoUxH7LogyJl8Xap7LxU04VrY/wo9SDqcsTryEzuwuhRzgw2MvpSVHIfiuPT9ztcuDAMy2NYOpWbmF+CWogwpjyeIoMFZY2AV3QqOW2ihVWU9G3wwHnTgKeJRqCwtZ4xSoJ8xKWkQ3cuD9lrHed4CHo++hnGcvTKjCVPgFXgfnJD1obTOzbaY5QiU5B5MZ2anB4pmc56p0XrobQyRf/YUbE9moGEk8mHTAVTBlB9UBfXMRvJ4KldCzRVWaEHSjd7CsI/OVboZcYIIF9kveZcIbXP9BGW7Hx5H5igXHJW0vZg5wVJb7eV4/YaX7yUoY5pJW/uvwr0xZF1gADUorcmOpyvv1gfXzbptUH
 DwcBImX+
 VdlIuRzQxagyFRZNjnxKdygKAITcV4dpA97F1EqTcp1qJp14nJFZUpY9aJ2OEoazDU0XqO4JL7gUSwGCUjdtTId8AJAo4nEpvIl/Pzs3ozcDE31KOtusBmLwURv/WHl3xEVIvJbAo/6pwqfYd0phcSTRnvIXh23uCf08PWlELDrSkG65i9cD9RFA5eQDH9RqiZMjkldwcMfqyX3JPkwztpa2pvk0KZRqinahVFnHWyVI2cNQVIkhicjwDj1DauvFPyckWNoH8zpfsOr+1DpAzhkcb1gDc3a+8GZkZ95whgwCRQ9jTkgbAC5eqF0B+LBjjFCOX0nRrGoha4UZ207dYTUjPdsgwNHWGnhJXk0x1eVlW0XtjAOmJ9l0CGcSwbUIL50hNV64ygx0MNQfq/sGtCFY7wWwCLB+JSvyP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06-02 11:13, Mike Rapoport wrote:
> On Sat, 30 May 2026 22:19:27 +0000, Pasha Tatashin <pasha.tatashin@soleen.com> wrote:
> > diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
> > index 146414933977..8d9201c25412 100644
> > --- a/kernel/liveupdate/luo_session.c
> > +++ b/kernel/liveupdate/luo_session.c
> > @@ -291,25 +291,24 @@ static int luo_session_retrieve_fd(struct luo_session *session,
> >  	if (argp->fd < 0)
> >  		return argp->fd;
> >  
> > -	guard(mutex)(&session->mutex);
> > -	err = luo_retrieve_file(&session->file_set, argp->token, &file);
> > -	if (err < 0)
> > -		goto  err_put_fd;
> > +	scoped_guard(mutex, &session->mutex) {
> > +		err = luo_retrieve_file(&session->file_set, argp->token, &file);
> > +		if (err < 0) {
> > +			put_unused_fd(argp->fd);
> > +			return err;
> 
> I don't like piling up error handling inside if (err) statements.
> 
> As we only need the lock only for luo_retrieve_file() I think it's better
> drop the guard and use goto:
> 
> 
> 	mutex_lock(&session->mutex);
> 	err = luo_retrieve_file(&session->file_set, argp->token, &file);
> 	mutex_unlock(&session->mutex);
> 	if (err)
> 		...

ok, done.

> 
> -- 
> Sincerely yours,
> Mike.
> 

