Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AD80F532C0
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 01:06:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47EC06B0005; Mon, 23 Mar 2026 21:06:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 430096B0099; Mon, 23 Mar 2026 21:06:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31F166B009B; Mon, 23 Mar 2026 21:06:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 213576B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 21:06:58 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C063BBE67D
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 01:06:57 +0000 (UTC)
X-FDA: 84579167274.18.E173FE7
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf09.hostedemail.com (Postfix) with ESMTP id F20FA140002
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 01:06:55 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=GEZGOR0+;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of rientjes@google.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=rientjes@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774314416; a=rsa-sha256;
	cv=none;
	b=7o5nl17usAAr67HMB9+g0/TwWnSUXGFc+xs+UcrqJpcYyHL5IdtTF2V+8ptaDX03WYfoA4
	W0KaNuTWOM7/3k6RwB/DUaJw5H0cQ24Uf+WbrnGoFrGNtcVM4OSL5JjziwfdjjsyAQGZav
	qtTNO9+W2jA3JawzKMHvxh4wVSRokLc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=GEZGOR0+;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of rientjes@google.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=rientjes@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774314416;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ek0OOmYJXz2DUEhUOUCfjBLElBgWO+47553Bp8YdGh0=;
	b=uA0ChYes/jZPVZjZlmDH5jv8zKYx6H2Sln3fZCrGv/YggkmOP2sVegYGmgAzU2Kg/Qt2Dh
	hQem1eVnhrznNcDb/JCmegMDgAPlFoFzJqRHlCZfJA2MK36Bh4BlAkGiwyR/L4jLTyX28n
	TM0wSvGRbv4fegDSFhLlCTrfZoT7WiU=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2aeab6ff148so27005ad.1
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 18:06:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774314415; x=1774919215; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ek0OOmYJXz2DUEhUOUCfjBLElBgWO+47553Bp8YdGh0=;
        b=GEZGOR0+PpKR+5rI8rpNIK/nQcOKJ/D04T554GCxF9pmzXR4sTktDgsddth+AW1DtW
         iSrCIQOjFmbKkOvTosY/PVntd344yPgEQNIDZQzSrVaeBXuw+vnyXypmBtJ01XkVPix5
         tsIvcf79rwd7nP2hbD4pnfeCr9IwF+xBFZn8PyXjiD9aJIwXjBvSW4Yf91pG7tgpgTXR
         /lmlWfJsWLzF4CMGR/GntgOAT/O8nMdEL4S20DLFdWm788pY7jiK+DNKCGHcost5pQ1G
         tSYcbh9A4WQUkRppzwcpCWmuCoiYbtaJ98B17f5JXgRVwhpbXg8XPpaJI7bOcveCsQwO
         6AMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774314415; x=1774919215;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ek0OOmYJXz2DUEhUOUCfjBLElBgWO+47553Bp8YdGh0=;
        b=C0MISatzon00kTy6kG+WhyADL08ygbEg6vvlNqdSsBKTJFYY2e8nEprPc88X+IavtS
         fZ2DUHdZA6RllwJNL3Z2RZB9LJl2WVtR9dGfxcb3e1cJso8XYhNvF0z9WTFkDLzM0ybA
         WoPdsBy31KlxpCDCYo8FgJ8/ZJO4IZis9yhDa5XsKubUOT0t8n0dv7codjt2y+bBQyK9
         IPiganiACUOa84ZyR8FKLkNSxn5rIY3DGJpL9oZG0L+qe0RAU6OcASE6RoFk1/gYfOBT
         /8Y7vExrJmm5KGBWZtaX/Qo2JTizB0tFSRy0OknF3rGb71FI3r2h4ALT9i7BcI6qXynD
         pA5Q==
X-Forwarded-Encrypted: i=1; AJvYcCVAudIBJ5reLZ4dHg+nCYfC3UGNi5MAvtwJ6K3mc+ITu0wkcvaOpSw/1cARAouczDt8XuMtbvrm7w==@kvack.org
X-Gm-Message-State: AOJu0YxKXX8PhXVjxzIccF0l4XI20BWGGD/WvzzteTT6HsMWW2OFtMxD
	LRiBbALzmJ43mbQgwiFQQiApDkrC3ewODMp4GPrFy0+uTJflIXUE3vCEnT96j4l0yQ==
X-Gm-Gg: ATEYQzzf+RC+jIpsj0vWqi+LzN6rIPgAL5ON29eUnadkOaPHpdKn9Gs65EmzpwkCEry
	QfDxg5AEUYensvkdBEaHBP9HcpzU1E0XWTyVCloLLmt4xJY38FQz1tWIz3A8z6otlMjhEZtKJFW
	43qKv2yyxk2liwK0l9KW2C2qj8Du6txfglWy4chNIBVuXSzYJaMdG+qNOfm8h/9ldm0GDEnxjbF
	hs0QTqW3QH9Sct/Waqu9zRVqIXl8jhz12BOntlA942UgiwjlvTJL+46FogqohleEIpxVEkKaGam
	Ykd2MP55irY66DVn4I0iHRlUK7GTh8rVvIyYsUmS5mR04yjwepOjU8GZAY3aRH/qXVmpT/nvfXV
	HlWItTlRUNSZEQwTn8soGCKB/IIeaOPJTLIjEWOtzTjkx0kfXVe+fqybdbJk/qfquo+9WeF/z6N
	6H7x8CrQmsuO8pThQMADOcg1rpfIrTXgmf+8/chYRhwtofIYkP/nWFf4HxyZ8JwopEnz712M7UF
	G4UFVb3LUhNt7ezy2/6RaceuyO8gHsQHFANcWXuoK9DdUdbG8Cq+A==
X-Received: by 2002:a17:902:cf42:b0:2b0:7a9b:82f3 with SMTP id d9443c01a7336-2b0a53e6fc7mr1544185ad.8.1774314414282;
        Mon, 23 Mar 2026 18:06:54 -0700 (PDT)
Received: from [2a00:79e0:2eb0:8:36e5:9ffd:34bc:bb90] ([2a00:79e0:2eb0:8:36e5:9ffd:34bc:bb90])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b083655474sm158353015ad.48.2026.03.23.18.06.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 18:06:53 -0700 (PDT)
Date: Mon, 23 Mar 2026 18:06:52 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>, 
    Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
    Brendan Jackman <jackmanb@google.com>, 
    Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
    linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] mm, page_alloc: reintroduce page allocation stall
 warning
In-Reply-To: <c635acc2-d41b-4f7d-8244-75a117721da3@kernel.org>
Message-ID: <cc53ff01-50b5-dcee-ec2d-29ca0e9baa05@google.com>
References: <30945cc3-9c4d-94bb-e7e7-dde71483800c@google.com> <c635acc2-d41b-4f7d-8244-75a117721da3@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: 755557pxe8kcfc89c31tpz4tck19y6in
X-Rspamd-Queue-Id: F20FA140002
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774314415-928333
X-HE-Meta: U2FsdGVkX1+pqgSifAYrZj/UL/1McccV1b3PGc+QGhFQqpWriIp6TqL5OCTtKKTZRDyKop7j+QyI44nKvbirQUfKn90rDKljkqaeXKP5kPcsvwSvYVvf5oxxfTPmjDwTzl3wXSFp1cqkgcJAH4E2ttGghs8Kz8r7OsFgIftd5izjMVQl/+8Su0ebbtONLlo5GL5SG4TpXqUmWb4WuqNYfi+ZrGwe6EkS+RFVakZV3E4oM0VeqnFAeqSDc6CO2YLKlpXF2NrT0+yWkuzbktpR2/2dYJDYLpwKsbJ6jxsRbTzgb3cHzD2XvgPDO+56nPeRBWhXIOfSD+Fzf7aYTVu3Ft3bO+lAQ82vDy19j2d8oBCApEpDx9t/ai5wK979kGx0nCMN7vgJipz9H1zQZ4JPgx0OnPx5aMx5C9YlInb2wtqH+wzgqbPKTaPzLXeDdZ4v+pxT1FD7d+7ZitpxaQZOsCucKQhLsbKglpTDFBUcDL4Gq3EVK9SckLX//xBxAZxjK0/41Zwq/qBnWxFXazcvubeHqw91wP09pb8+ILNn3lfYqT+hco+PeOpnLo7ccCF/x7LAahvvfln1Yym+LVIwDwF9ZM3pDcJOEhZxhXU8YRNpKS/tbCMyL/ez2iKmQ7ONoyntPCXY3kh4obFQjUi1DQWFWfRCaQ5+ghw2lus++U/8A9eGcDt1aCzWdrFAWPJM/hp/gmma1X8CsvhomM2YiVYCadbegGePJxDuacjAvb3Ku+w9sS1YRoLqRr5NQcUtDfA6gCpgJ3YHHtUpWT4g7QcrN5kEdfBsNHc65bZX1B/2MamoPOjlezszwog2pbEpxKYJJhsoFX+7XjRtwD/rlqB+5cHFNJylvX0syq26SExMWkHd0FqJwR8sCLH0UBpdm4Wl3hShycUJeqEU7J04IaHdNnei07YCkEU09h9OdbvSOknH0oyhl0t5ZFqTi4pS4IGr0BYu1ZebqaUT/kz
 LJmH0onX
 dOIGYr6CyyGr/ej+hAcsYh42NHhjgneFTFjJmdyuodgn6keqefxhDtLHs1qi+tZMbL5rN6IWAK2KuPY8Jr9BMmI8LN/4XTE/svksOFsjvZAI5fkkS9woSETP0GqF0kP5reQc+TqG1uzGVoWNccFXEWV3bAANfcZtGASft8iTGDRY6NEX5mYcSeE3cVKExeDtYMacmbZLTO7SFmW9nA2DlMAJn67BoOjeiWF1pK6EQY9lGAT/zTI4cAFpA7bMjhkei2QWI2zK6B/Bw+Gf3MwCJ3/y7aPkygrk4uTdBWn6SjeJJ2PiJECEsuYws2V+oeTdyj5oLLKHG8K7eRKbvN8SSZf6Y/7pxVRgCSuMTdAjYkt3L/vVdxM6lTIxDkl5yHkNRcMx2JQMtE6DW4gKh72FKrqbn6Vh/vURvhjJBizXjQ+/PX5i9jrALSQWwtA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 23 Mar 2026, Vlastimil Babka (SUSE) wrote:

> On 3/22/26 4:03 AM, David Rientjes wrote:
> > Previously, we had warnings when a single page allocation took longer
> > than reasonably expected.  This was introduced in commit 63f53dea0c98
> > ("mm: warn about allocations which stall for too long").
> > 
> > The warning was subsequently reverted in commit 400e22499dd9 ("mm: don't
> > warn about allocations which stall for too long") but for reasons
> > unrelated to the warning itself.
> > 
> > Page allocation stalls in excess of 10 seconds are always useful to debug
> > because they can result in severe userspace unresponsiveness.  Adding
> > this artifact can be used to correlate with userspace going out to lunch
> > and to understand the state of memory at the time.
> > 
> > There should be a reasonable expectation that this warning will never
> > trigger given it is very passive, it starts with a 10 second floor to
> > begin with.  If it does trigger, this reveals an issue that should be
> > fixed: a single page allocation should never loop for more than 10
> > seconds without oom killing to make memory available.
> > 
> > Unlike the original implementation, this implementation only reports
> > stalls that are at least a second longer than the longest stall reported
> > thus far.
> > 
> > Signed-off-by: David Rientjes <rientjes@google.com>
> 
> I think, why not, if it's useful and we can reintroduce it without the
> issues it had.
> Maybe instead of requiring the stall time to increase by a second, we
> could just limit the stall reports to once per 10 second. If there are
> multiple ones in progress, one of them will win that report slot
> randomly. This would also cover a stall that's so long it reports itself
> multiple times (as in the original commit).
> 

I like that a lot, thanks.  Since part of the motivation is to correlate 
userspace unresponsiveness with page allocation stalls in the kernel, we 
increasingly lack that visiblity if a single long page allocation took 60 
seconds a month ago, for example, and we have to reach that threshold to 
report again.

The original patch ended up at line 4839 here:

4833)            }
4834)    }
4835) 
4836)    /* Caller is not willing to reclaim, we can't balance anything */
4837)    if (!can_direct_reclaim)
4838)            goto nopage;
4839) 							<===== HERE
4840)    /* Avoid recursion of direct reclaim */
4841)    if (current->flags & PF_MEMALLOC)
4842)            goto nopage;
4843) 
4844)    /* Try direct reclaim and then allocating */

Which looks like the right place to put it, but probably after the 
PF_MEMALLOC check.

If we set a minimum reporting threshold of 10 seconds and only report 
system wide every 10 seconds, I think this will work very well.  And, as 
you mention, this also reports stalls for allocations that never actually 
return.

I'll implement this and send out a formal patch for it.

