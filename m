Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F34EFCD4F21
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 20:13:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AA4A6B0005; Tue, 12 May 2026 16:13:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35C146B008A; Tue, 12 May 2026 16:13:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2715E6B008C; Tue, 12 May 2026 16:13:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 15B076B0005
	for <linux-mm@kvack.org>; Tue, 12 May 2026 16:13:07 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BB062A043D
	for <linux-mm@kvack.org>; Tue, 12 May 2026 20:13:06 +0000 (UTC)
X-FDA: 84759866772.20.72157B9
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf16.hostedemail.com (Postfix) with ESMTP id BE70F180010
	for <linux-mm@kvack.org>; Tue, 12 May 2026 20:13:04 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=hACbKZpn;
	spf=pass (imf16.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778616784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DIIRS0CpXrVK8EEE9qFLP9/pCIOhI1EfpJW18IQe0rY=;
	b=bpmfRZ7+rGkfZvaTaXGOacAYpMJhHAm32D5aTXP2l794nZs5ycrY1FJ0cX2VPkBr4yFATv
	+JfQVBcmg6g8z9539ke0052PYm/Kjk41dH1P34zqf4cnF516hrzUdYISL0khgsY3LDnAma
	NA0f/Z126AiDjH/Vw3NM63Ge1erj9bI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778616784; a=rsa-sha256;
	cv=none;
	b=HA6roH6haqtLdvxslhCu2KNZ2dJpw8XrnsKkbosSnv6+njjgBx9Pk171YvxxDPdv5YbeaZ
	hDWExRLvAtIFno0tlJbgVBQDdQdP+EEKMKnz6uRobS7c3i1RkKKJ5aqIYLYIsKHkO5Re36
	CtN2ATHkMhWnchrDmj94i+dudzPtWHc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=hACbKZpn;
	spf=pass (imf16.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-50fb18c55beso61148611cf.2
        for <linux-mm@kvack.org>; Tue, 12 May 2026 13:13:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1778616784; x=1779221584; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DIIRS0CpXrVK8EEE9qFLP9/pCIOhI1EfpJW18IQe0rY=;
        b=hACbKZpnQH9PjYYbWaDWTY3NXg+OviEg5CWnl5WreB8asJ2yNAj5K6dFqCvbmqnRId
         t75syNfd+1TLqcOr6a8d/tpxySTNc6j5rNbpqDhMO/v9sOJ5VQYFEiSVQ5mRJm9rWEFs
         T7nQfHHFzOmKEC2srV+5KEpcfenabZD6dQbPqEiCIRGMhj55X7NkNn7rhRfKNrvjsoM5
         ns75iemCtbHPmhq96zwBQq6ADo2tAC6rFnVmlDNc63S+ksktjFQOICNwwh/D8Vn/RyEq
         Q/FbLPU8orB/RGj99a8UqCt0q70H4Ea81wwmN9lw2QZQpVQjEyU+LIh9mmPmDeegNroW
         gaQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778616784; x=1779221584;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DIIRS0CpXrVK8EEE9qFLP9/pCIOhI1EfpJW18IQe0rY=;
        b=MADLkM3Ya+eSfXJ+JRldt8hVZLYdStq3/pOOewWosBnTfvZGRZ2drRxDcrCTjbprPR
         6dbDRhhjP5tF+TMcL97Lq+ucRTXhvw/SI0JzNJHlcGBz95SgD/MrraiIm2AgOdZXL40B
         qwwSRQJIw26RGDh33lp228j0b7hbTY1EJ+A9yqc3V67nxH/fnvWoy6jdT/D9Ca9fSqxl
         v/RqGqbtAoh0hAepoutQ7NOGpnQ7XSwaLLbwMtWZYsSZ8whZoMRohP/QBYAOWr2jc6ee
         0mO0Pe3VVuoV1CEEK+yF179wp/08mG9lk0nsRNoKiqeq5yCKeLhxvFtzkd6DThRrc/q5
         g0ZQ==
X-Forwarded-Encrypted: i=1; AFNElJ8PMBHshBXA0tW8kRjxKey+4sw544OmAKyOUN8iq8/A4UcoEEA0/i0glPSiHDirCaQmKZIcLrvbPQ==@kvack.org
X-Gm-Message-State: AOJu0Yw4Kd8LJshDo3mDePplR3QdeGf6UOi2804mCw4R7GuZrr6te0qU
	idLQN9Rn1vGwWrmxoAL2phYbwRUojgRlclSOU1KkBZXoIBL7Y/+B8ZHIkb5bMrOwHto=
X-Gm-Gg: Acq92OG/1w/+FRNK4Qbnf1TMStHaS22uTotkiX0A1xScEEi5h1HX652YlCN3ajS8oGE
	2RXdY+nvbNpYUvwOsfl5FWyHc2jS3OUv5+emuSQ08/H4Ac6ifIcExbAXXnWTunvEGp0p5NPjST0
	431BcVMJqpfkm5KvH8a6g3JIQy3T1txQXh1VsYrhIM3w1ACX1CL5umQtUh3JmXjl/JACSSWnViW
	MOO1tQzy2DVZ2glm1qT0a7uc9Y82v/j9psEK8z/yI0jWzzVXR5ZCpptstWL4E8A6p8TgDaYxaBD
	wYLppa8sznAcpDTTNroyKQo8eaA566/0b87ogyo1EKGA/Ocq14sYv50jHuLS7bNYu/VvNQtQbwA
	Ib/T7dBqVmKhu7VaVDFSTK1FdC4lUkZfEMeZ3vfvLgzUg1E04OKEPxKdlX5uhZDTpRzjiuIn5az
	C0t1WXs0+EZsBD79VQ7YJjG85HSMubBivdJCZbj5y4ilcVV4qvMu0=
X-Received: by 2002:a05:622a:92:b0:514:9ece:a15a with SMTP id d75a77b69052e-5162f5fedb6mr2218391cf.45.1778616783708;
        Tue, 12 May 2026 13:13:03 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5148e675b9csm125582881cf.11.2026.05.12.13.13.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 13:13:03 -0700 (PDT)
Date: Tue, 12 May 2026 20:13:02 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, 
	linux-kselftest@vger.kernel.org, rppt@kernel.org, shuah@kernel.org, akpm@linux-foundation.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, dmatlack@google.com, 
	kexec@lists.infradead.org, skhawaja@google.com, graf@amazon.com
Subject: Re: [PATCH 3/5] selftests/liveupdate: Test session and file limit
 removal
Message-ID: <agOJui6EOiJR3cgn@plex>
References: <20260414200237.444170-1-pasha.tatashin@soleen.com>
 <20260414200237.444170-4-pasha.tatashin@soleen.com>
 <2vxzse7wafmo.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2vxzse7wafmo.fsf@kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BE70F180010
X-Stat-Signature: xwybmhkju9tjf989dbx14p43dfwyzioi
X-Rspam-User: 
X-HE-Tag: 1778616784-297441
X-HE-Meta: U2FsdGVkX1+wtwmrnWRHmCKtDVf0CeIK4GZewVtjh0wlOMz2ZdXZ5HpYq5DNHWM6mPrfDXy0vl9RxuKrj9bsRpxV9F4o/qwpzklxpFMQ3ciex3IwgWXYLwv7uSVm3uQXm/JPFcJ3HUkMdLiLc/SJ3aPP5Je9DvN9rG8MIZUff1vMqspdksFCXz0kAr+88H7qoyb51XbAyph8VfSiieQ0QO4XoX454wbkUZ5/FxXULNmRD96XRPObVMmq8aTuj5WdohijtO2VxHtQ4Renu40UcySeiYHfPUzXqQlDXyFTseNk/1XkCoxf1xQ321S9UibR7qETPyPQ2oa3GebQg/ZQ9Qkc4fagbzkIyGkw3+/QnKgjXALWXs2Kt6+lJQe+UBfxZ2HlEQfxkVMagLoQmFFeZxKkhw5IB+TU+cBi/o1FqAwu+JjjChWND8d8aGLifFx05wwp/40Ui+R++YNwg6Agd7T7DoodjXpaZ0c13iPpcLPesjZ6oVlF2KVq2IL1PKhLVzy2dNg8MuAyuao7UUOMv8NP7+Mp9Onp4M3eVVXrTys/alxf1h6DkrxsosZMXcB2qK/J9y6jbamvLoaLXQU+Zia8fGQ/iIgi06I00RBqL6bEYlUR4QznS8A7/RT5I/RTo96j9/OBKhKoVgCCtwIRV1IKxUzH4HeHd96pgrKJNYfgXi6bsU4u6vYADsmdVd4Chu0NSRefVGAJQ/ZcvTs/Xj44avR6KW6P1QTPcKaLtnPl/712fDAIMw7Qsv19+Ks2QZt0q3+nf9jtPyncq7iYRiV0GMb+pTCiCS1gQGqXVXPHShfwXrtJiW3rUOnSWJjOISkNy9xXh128mc8fMvagHzM7kmAuJAEpoPuyqwgK+ZIx1OaH1Rw/HQFeKsvLPGBc9co0W3HW43ttT/KjV0GqYKrqT/tGlY9UE34431iW6z1S7ImfHXIsjXcBLQm8fUKd0WNjUtVhY29N7dFKV9j
 FlApri2H
 5iucHaqX4TwfWtjBF2CAs6ItcXRtzWiPat77jzBe+5Wqw2tN62Bh25GaDUQvKJhmN5b19BSo2/LQzXyGDiJu6sRhsoIdMTyoQyAaqH3Dwqqc7JHv+fvFGH484Kj5jixqXtoanw452w/I26paDLJ6pIrs2OsZJXhhcj6NEMlcZ0RTMppAfXOc19knmJCAmtcp1cgrRZKuKmTOp4oHvy0C+FFucuIKBhG5j5KhkYkeEh3o3rFmgkuGDDCKNwealtehGuzDegZuEQnosBEB/g97/PUhSrqDcwZLi5LJDjtMRi9mpTe63iQhRG0AIEj0fphI+AxDo6qQ3g13wIJe56J0tpGUsziq/vcfhG12UVbfRrHPY8EU/bB8dJ2A5lA2xLnziZXw3g7ofuuGwwe0Q9UaCGGWIbA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05-12 16:04, Pratyush Yadav wrote:
> On Tue, Apr 14 2026, Pasha Tatashin wrote:
> 
> > With the removal of static limits on the number of sessions and files per
> > session, the orchestrator now uses dynamic allocation.
> >
> > Add new test cases to verify that the system can handle a large number of
> > sessions and files. These tests ensure that the dynamic block allocation
> > and reuse logic for session metadata and outgoing files work correctly
> > beyond the previous static limits.
> >
> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > ---
> >  .../testing/selftests/liveupdate/liveupdate.c | 99 +++++++++++++++++++
> >  1 file changed, 99 insertions(+)
> >
> > diff --git a/tools/testing/selftests/liveupdate/liveupdate.c b/tools/testing/selftests/liveupdate/liveupdate.c
> > index 37c808fbe1e9..0eaf97b19267 100644
> > --- a/tools/testing/selftests/liveupdate/liveupdate.c
> > +++ b/tools/testing/selftests/liveupdate/liveupdate.c
> > @@ -22,6 +22,7 @@
> >  #include <fcntl.h>
> >  #include <string.h>
> >  #include <sys/ioctl.h>
> > +#include <sys/resource.h>
> >  #include <unistd.h>
> >  
> >  #include <linux/liveupdate.h>
> > @@ -386,4 +387,102 @@ TEST_F(liveupdate_device, prevent_double_preservation)
> >  	ASSERT_EQ(close(session_fd2), 0);
> >  }
> >  
> > +static void ensure_nofile_limit(struct __test_metadata *_metadata,
> > +				long min_limit)
> > +{
> > +	struct rlimit hl;
> > +
> > +	if (getrlimit(RLIMIT_NOFILE, &hl) < 0)
> > +		ksft_exit_fail_msg("getrlimit failed: %s\n", strerror(errno));
> > +
> > +	if (hl.rlim_cur >= min_limit)
> > +		return;
> > +
> > +	hl.rlim_cur = min_limit;
> > +	if (hl.rlim_cur > hl.rlim_max)
> > +		hl.rlim_max = hl.rlim_cur;
> > +
> > +	if (setrlimit(RLIMIT_NOFILE, &hl) < 0) {
> > +		if (errno == EPERM) {
> > +			SKIP(return, "Insufficient privileges to set RLIMIT_NOFILE to %ld",
> > +			     hl.rlim_cur);
> > +		}
> > +		ksft_exit_fail_msg("setrlimit to %ld failed: %s\n",
> > +				   hl.rlim_cur, strerror(errno));
> > +	}
> > +}
> > +
> > +/*
> > + * Test Case: Manage Many Sessions
> > + *
> > + * Verifies that a large number of sessions can be created and then
> > + * destroyed during normal system operation. This specifically tests the
> > + * dynamic block allocation and reuse logic for session metadata management
> > + * without preserving any files.
> > + */
> > +TEST_F(liveupdate_device, preserve_many_sessions)
> > +{
> > +#define MANY_SESSIONS 2000
> > +	int session_fds[MANY_SESSIONS];
> > +	int i;
> > +
> > +	self->fd1 = open(LIVEUPDATE_DEV, O_RDWR);
> > +	if (self->fd1 < 0 && errno == ENOENT)
> > +		SKIP(return, "%s does not exist", LIVEUPDATE_DEV);
> > +	ASSERT_GE(self->fd1, 0);
> > +
> > +	ensure_nofile_limit(_metadata, MANY_SESSIONS + 10);
> > +	if (_metadata->exit_code == KSFT_SKIP)
> > +		return;
> 
> Nit: This is strange. Why not just return errno in ensure_nofile_limit()
> and handle the skipping here? Same below.
> 
> LGTM otherwise.

Good suggestion. Done.


