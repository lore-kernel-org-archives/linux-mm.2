Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0225DCD3427
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 16:03:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E0F06B00A6; Tue,  5 May 2026 12:03:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 191B26B00A7; Tue,  5 May 2026 12:03:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A78B6B00A8; Tue,  5 May 2026 12:03:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EE9AA6B00A6
	for <linux-mm@kvack.org>; Tue,  5 May 2026 12:03:09 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9F5811A0002
	for <linux-mm@kvack.org>; Tue,  5 May 2026 16:03:09 +0000 (UTC)
X-FDA: 84733835298.09.5F104EA
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9FAEE180010
	for <linux-mm@kvack.org>; Tue,  5 May 2026 16:03:07 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=SHgTVvz6;
	spf=pass (imf24.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777996987;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I5a0fHBP8h2hhTJGmZHgpaYcDEY9WIm8IJ7LEnVJOtY=;
	b=YZsihZtXL4rc7RZdStEJTuo2gzeqh3N4Jp7mTmBmOI8xFRyebBmi9Jj276LmIRuWnrt9d9
	xwVFl3Hf4cNjLYcPPS0HdkKbHT2ortJ6GZprT6vdkuUGq9j9S7R73sWEdVbE17nLdSTbNo
	SXO411ULfMxp0CSOVlYwb37D2PCuufA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=SHgTVvz6;
	spf=pass (imf24.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777996987; a=rsa-sha256;
	cv=none;
	b=wngcpehtapx71nkoPucENR4/gA6+zVkwlQWgiGy1CcyxydMitd4lnEPzZAXwbLs9GQ5LAw
	7eV/lf4GutQPQLxPDNdeWl/GJiUJ3O+8vcfIRAlKsoKfVUJBDgKo77kZAE+oPtLorqitbr
	iwByZO3WffQpEU4UG31Sz0Wuwcgkib8=
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4852a9c6309so44118685e9.0
        for <linux-mm@kvack.org>; Tue, 05 May 2026 09:03:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777996986; x=1778601786; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=I5a0fHBP8h2hhTJGmZHgpaYcDEY9WIm8IJ7LEnVJOtY=;
        b=SHgTVvz6XNIZKlNpiNXWBYBqZQM29/6t1otvZLpGHy3tCovKKrWeVmS0IEjhS8Du+z
         3m0a4zqw20OXpmfzy4pNdQXScUxWnjdZVFWZn0CpMkBvHT5YlQebLRb1JWHFTaPmDqaD
         ygv1dSeM3+m2PL73lF4bsigwFQknxvFdoWqen1pdh2lacl6knaSOAm5ILsvRWKdtiDAp
         62RCzL4jRMEQ6DVdEcr7JjFI/hX7a5/jXReckU+9phsye3RHQOVVtXNE54t4fegP5EqT
         ITY7af+mEMgFoMbG6PhAMYkw7jS3kLOZaPzxIIodniZbbUwAhAnVtB3J9Yt3ixhgIcSN
         joyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777996986; x=1778601786;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I5a0fHBP8h2hhTJGmZHgpaYcDEY9WIm8IJ7LEnVJOtY=;
        b=BwS+HLrSHpjE0H2MNasClm+VCfoDybpxozMmZRaqo1NNm6ty5Y4ozsLT4aDzYmHjAv
         isTuHVtMRUgIQxCpbUxzLR62uWd/A9kgONTUYIXW9YcS8O+/cFBFNlhWm7aewG76iL7d
         qAfboCoUPp1C93SYaIoJKmcgoqP3KZ+N64Tzt/N54kYpYr4KTfOk6KkSIaS50ApbSKw0
         TnyDYO055a5G1MYB+ORmYA0fdZ2tmKhOvqvwP+b+h+s16Uz0eH2j7oZ45XcxPKUtj4pf
         oD3KP+rMq/MAI6dR3n+NtfsYsDminXq+N0IdaErzjEgbVDc2AT67JRGoQrsICVAmQtRB
         kpKA==
X-Forwarded-Encrypted: i=1; AFNElJ9y/nQUym3fTd8fqmFm0srx2sVj5sSc85JEEO/HT9PCBJf7GrUNitzgW7x861p+IsSKf9gB+DnuyQ==@kvack.org
X-Gm-Message-State: AOJu0YyZGX2PPlddZ/6KMH2GPuuRxLwSg2mNex4s/qaV4p2FRE2eN6CT
	hKPBKqMHfkwqgSKbOmsum50KxFx8llbvLEhLMLtqPBT+nfADl21vhDa/UqKMBZt8ZV8=
X-Gm-Gg: AeBDietSOxB5TnHJm62ELWYgZ49BkrBqv00Y8w8vE52NsK1xUG574ueb//TkLVZ5NJb
	Xt6KhHJXqVYGKZzRwf3bhqfb060LId6yhTZlMSgFIN1tIsBEc/02EutHgH4Sv1WQTxrKb4eJHy0
	oBe0712dEohX2WxvVoFNDKIXRtL8GPiS5fJ6QJM69EEa9Wyc1LioxaW/pNuUEZhEGs8C79oFs4p
	KPK02CUNyi/l2L2wI7NQzLsMj5bmFKVV7bz3aY+lO9i1+RYi3KtLTsUeBwiBATRZjoMV0Wf98P6
	ASKTzC6yE1vu8SXmyfNRvZq5XVDDXL8GOox8/RnF7BLHCAH6BSl0wfDZl6FGkp9WjPTFCp9EsAw
	aL+CeIyQPQu7FtpXxPF86cwHJiK3CD1vOLiAOsPUGRfTSqpcT2D7Pi13hWJ6kLre+C2ITEqmrF7
	tXhgAmi5PaHVMgY9k0M+1ZPZ1qGC6LyeRWPWhITcMdO3Y+QQ4=
X-Received: by 2002:a05:600c:8719:b0:485:3abe:ab86 with SMTP id 5b1f17b1804b1-48d186dc7f5mr65697625e9.4.1777996985939;
        Tue, 05 May 2026 09:03:05 -0700 (PDT)
Received: from localhost (109-81-19-134.rct.o2.cz. [109.81.19.134])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48d17708195sm33216595e9.3.2026.05.05.09.03.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2026 09:03:05 -0700 (PDT)
Date: Tue, 5 May 2026 18:03:03 +0200
From: Michal Hocko <mhocko@suse.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>, akpm@linux-foundation.org,
	hca@linux.ibm.com, linux-s390@vger.kernel.org, david@kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, surenb@google.com,
	timmurray@google.com
Subject: Re: [PATCH v2] mm: process_mrelease: introduce
 PROCESS_MRELEASE_REAP_KILL flag
Message-ID: <afoUt3te1k2TNao-@tiehlicka>
References: <20260429211359.3829683-1-minchan@kernel.org>
 <afMnKrYT0xG_a-b3@tiehlicka>
 <afUYfpwWsUQoB9hz@google.com>
 <afhQB0CWEcflXpOi@tiehlicka>
 <20260505-wegbleiben-deshalb-f929089dbdab@brauner>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260505-wegbleiben-deshalb-f929089dbdab@brauner>
X-Stat-Signature: da4mtittfbse5gr39nfywxbo31ngap7g
X-Rspamd-Queue-Id: 9FAEE180010
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777996987-713210
X-HE-Meta: U2FsdGVkX1/wbq3wZUq0M538bAvqj4qG/TrWk5JUSvu/8Xr1q7/tYoKIUKjRZBc2AKxZXnQdTUiYq0NNJm0rKU9ElsLbFEKl2exy4zY1zHU4FtIOEX2f2Yh6EyzKMG3Vx8Sla159lPqSExPNZH2ZcUJQWYgGQ6yRVjcI7TBCsSNsqUARiHOOLEhGF4FfztwIi6+7KEeTZO7zabiLxqh9VPDcU79UgQlaLsoSVfo8Pz6JYxGbWuR4mVWS3h76u4PZEhL5NNDs6SpBvvwjityQcGnlqraVgeoY0z6qnUK0Rq5r7Ewvu9xvoQmwg9pPVVBTGbm/mJlPTkc+xKTAfMPzSvBFfV6fiwS5q4wFl/j8SgEKycV9vRKCbuhKYP5ghZjEQmFc+2CUV/7YlcCDzI+5zx1Szd0yFx2FYb2DkX0hFpFwGOZ3dC85qfJwvMiE45gStaZZ/eVyv9ANa3wRlUdyoqa1ARdCI6iPpNGGHfQqn6tRY8RnY9Zx1kT7kXZPpaB9zkLQtI9VtMhdgczSTy9DOWaWGxwQUpbtu+kUd4NXIGaS4ShcLfTGjqL1Pp1XCwELinNxvAWog1HQMT+sCGydHRTYlxyYpjLhPIrTu82ikKIRJswPMaoQH5Um8x9AW2JXzcpVPPQmerpIiheUc4OEkaP+TOBIC4LGYwgMN7ejknfwRWisI38fBTm9A58mFjE5rU+eq3rxhxjBplLuUBvU5tCcQAaMOm9Qolm02LNSskTSnD8BHEMBzvgNQwe0D/cp2dItESlDUPriUA8nIotuNL/CXain6AbeTijTdG15N5DtievdCOagFegkjT/AGq6o3JebpcQn2Ai6ZuWvvM9sv2um0Sm/6JSX9FY1VozJT1ah163z+kEkTv0ly4n1AwpsXTFvaj/Bnz0iIfa0fjkbb0K329Pmyeb8EcnUgTMUyx/2MZr7elOrO/YD8ZwzT/WxLuwBHWLCdFZezSMpzA0
 n5CveLyZ
 non2H2Xas72cTgDKhlZPJroeMeDNMT5TlCPQnA5nT4LT0R5ruWdAQ6VuK86XnxCMSq3RnTpCjuG8tzzjA1+xrnmOty3FAz0QfRLZYh9q69YcuVdg0nJC1FmGlDLQZQXERvhRiWWSikNgQuzdgJlTRlfpWhKGoYYft9M05mtM2IFVeU7sY6bqNkOi/5bAbTgPgCeSjwOuYu+3P+Kk3c+4redVxBbQZtSvY9twZx0Yy/BJYUUjoXijij5pc/mzs5M7HmbvWPzV1hRYAjWV7T7FV0hbQRJKkkAjt0e+GWOss9VzI7Ns1ytZh/7/x1a0ZsEJ4kqjsGaDZ3i83OvTj0VJeuZg0DEAH6MOxGmKKTH76b78EAzNnhpTbr1x997lGY7yHUoM3+ZqbrZfc9gKR4N8Xm50Z6Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 05-05-26 11:30:22, Christian Brauner wrote:
> IIUC, then the OOM kill if invoked from the kernel just takes down
> without permission checking what it wants to take down. That makes a lot
> of sense and is mostly safe - after all it is the kernel that initiates
> the kill.
> 
> However, when userspace initiates the kill we need at least the
> semantics you proposed, Michal. You can only kill processes that you
> have the necessary privileges over otherwise you end up allowing to
> SIGKILL setuid binaries over which you hold no privileged possibly
> generating information leaks or worse.

Agreed!

> The other thing to keep in mind is that currently pidfds explicitly do
> not to allow to signal taks that are outside of their pid namespace
> hierarchy - see pidfd_send_signal()'s permission checking. I don't want
> to break these semantics - it's just very bad api design if signaling
> suddenly behaves differently and pidfd suddenly convey the ability to
> do a very wide signal scope.

Agreed!

> The other thing is that pidfds are handles that can be sent around using
> SCM_RIGHTS which means they could be forwarded to a container or another
> privileged user that then initiates kill semantics.
> 
> The other thing is that the type of pidfd selects the scope of the
> signaling operation:
> 
> * If the pidfd was created via PIDFD_THREAD then the scope of the signal
>   is by default the individual thread - unless the signal itself is
>   thread-group oriented ofc.
> 
> * If the pidfd was created wihout PIDFD_THREAD then the scope of the
>   signal is by default the thread-group.
> 
> * pidfd_send_signal() provides explicitly scope overrides:
> 
>   (1) PIDFD_SIGNAL_THREAD
>   (2) PIDFD_SIGNAL_THREAD_GROUP
>   (3) PIDFD_SIGNAL_PROCESS_GROUP
> 
>   The flags should be mostly self-explanatory.
> 
>   So I really dislike the idea of now letting the pidfd passed to
>   process_mrelease() to have an implicit scope suddenly. The problem is
>   that this is very opaque to userspace and introduces another way to
>   signal a group of processes.

I do see your point. Unfortunately the whole concept of mm shared
across thread (signal) groups is not fitting well into the overall
model. For the most usecases this is not a big problem. But oom handlers
do care. If you do not kill all owners of the mm you are not releasing
any memory.

> IOW, I still dislike the fact that process_mrelease() is suddenly turned
> into a signal sending syscall and I really dislike the fact that it
> implies a "kill everything with that mm and cross other thread-groups".
> 
> I wonder if you couldn't just add PIDFD_SIGNAL_MM_GROUP or something to
> pidfd_send_signal() instead.

That would be a clean interface for sure. The thing we are struggling
here is not just the killing side of things but also grabbing the mm
before it disappears which is the primary reason why process_mrelease is
turning into signal sending syscall (which you seem to be not in favor
of).

So I can see these options on the table
1) keep process_mrelease as is and live with the race. This sucks
because it makes userspace low memory (oom) killers harder to predict.
2) we add the proposed option to kill&release into process_mrelease that
is not aware of shared mm case. This sucks because it creates an easy
way to evade from the said oom killer
3) same as 2 but add PIDFD_SIGNAL_MM_GROUP that would do the right thing
on the signal handling side. You seem to like the idea from the
pidfd_send_signal POV but I am not sure you are OK with that being
implanted into process_mrelease.
-- 
Michal Hocko
SUSE Labs

