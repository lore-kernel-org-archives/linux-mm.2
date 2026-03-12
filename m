Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5150C106ACEE
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 21:09:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0C726B00BF; Thu, 12 Mar 2026 17:09:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB6C26B00C1; Thu, 12 Mar 2026 17:09:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E37F6B00C2; Thu, 12 Mar 2026 17:09:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 90AD56B00BF
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 17:09:46 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 679E31C3B7
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 21:09:46 +0000 (UTC)
X-FDA: 84538652772.15.3B18903
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 852FE4000E
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 21:09:44 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ePwUi5U/";
	spf=pass (imf04.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773349784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5BZG/lOoPxijsQyAR1VNis3jzuhD7eY+vw2pm73Y4tQ=;
	b=7Xz/whAu7bFLRCH2d3EIaGOVxxvkX3mz7Yk8WxVia84jSgAvq1oGLWzHWyGi5pirRXDEAv
	rKWuZkSmNlr81zAPTFEYeSrTbLFALlPFSUSQv7vpen/zAXjLjBjwtRgQbHuBB5RAs44vKr
	+76Ki9dM2iFIxlLckx5Z6y+INLZ9lmQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ePwUi5U/";
	spf=pass (imf04.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773349784; a=rsa-sha256;
	cv=none;
	b=GyBB/Wh3wrBWDfOAc0+5RkEc5PerjR5Pb13Tc+iQ8TD+GdHDY9zJzxE+R67m3+Nfxp2UHH
	Za8UW1UEMg44a7ZmtA0vkSmuOZXoDkDSrEtyyvJy8QFXrqFvgxzNfIiMHabAoFVB+BcWy2
	CuiNfjf4cOJ2z43evjtKh5SJHqXdBu8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B474643EBB
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 21:09:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83DA8C4AF0D
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 21:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773349783;
	bh=Nan4354/w2AKj06fXE4TsNtEJsUA5rTTezTgjUEvs+U=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=ePwUi5U/kAn16q7Gt/5NMasYNAQczY7ZMZflPM8b4atI4UJDIvGL7kGI4r3yIsAGT
	 51AJe1ZV12dtSvQf57t7pqpuFlh/FTiMqk7K6Bigg7MgH+ApromBpSXrBzsDuQvnOR
	 9p86l6n6twCIdtlOU4O5HRn5amVUqQqDIfO9Zy8c/rzbY1+VCZ47z/Y3jyR+YhU85P
	 9gb0Iu+a9Op37FKsTUzg9eR91wJR9G/L9XOYiBuwgGSgX89iTp9MXp+/CAil439D9i
	 6ZcO+CQbtirV8WgIq5nhSiTO7BN39oKMj+/tQN9V3S31AFL5tC9BzrTyUUUlIJBcUU
	 U4TniQpnnSa/w==
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b96da7b2e2eso223455066b.2
        for <linux-mm@kvack.org>; Thu, 12 Mar 2026 14:09:43 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVucjMs0IunniFggmrUnI/y9NEENx9aTCu2nLUCrsKn8gf7riPGC2kswe3dwPCXCEbDRvSY+5z0+Q==@kvack.org
X-Gm-Message-State: AOJu0YxcXVd2FoebyvpZoxMAChTLSLcpnjaucv4c8m1G1VQLmIYgdkli
	Ex+7YM+ro8Th53xz1WQsYtNhQijXkIwRQ3WY7e4R0gUOfOjm5vlfKhQtH5VvpFq0QyKC7Ox0mSo
	uhVS0yTebgzIUO+z/wiWTSWWEF9n5wUY=
X-Received: by 2002:a17:906:817:b0:b90:3593:654c with SMTP id
 a640c23a62f3a-b9765028beamr40772866b.21.1773349782192; Thu, 12 Mar 2026
 14:09:42 -0700 (PDT)
MIME-Version: 1.0
References: <20260312040627.55257-1-liwang@redhat.com> <CAKEwX=MqyGQSMuVCSWmhKfHju5uHBe3ySQEgK9XuKwCvpL4x8w@mail.gmail.com>
In-Reply-To: <CAKEwX=MqyGQSMuVCSWmhKfHju5uHBe3ySQEgK9XuKwCvpL4x8w@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Thu, 12 Mar 2026 14:09:30 -0700
X-Gmail-Original-Message-ID: <CAO9r8zPmV8v0tiQvn2xFqX8F2oU23mfbVK67nxMO3QKt49kJeg@mail.gmail.com>
X-Gm-Features: AaiRm506sQlNtTd5yCay-yVuxaOgovvr4LCr2fiyeyxDv_MRp7ui-D0aS7YoY0o
Message-ID: <CAO9r8zPmV8v0tiQvn2xFqX8F2oU23mfbVK67nxMO3QKt49kJeg@mail.gmail.com>
Subject: Re: [PATCH v2 1/7] selftests/cgroup: skip test_zswap if zswap is
 globally disabled
To: Nhat Pham <nphamcs@gmail.com>
Cc: Li Wang <liwang@redhat.com>, mkoutny@suse.com, yosryahmed@google.com, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 852FE4000E
X-Rspamd-Server: rspam08
X-Stat-Signature: 9g181szdwapj95hr3qfhp9pygudqc3e9
X-HE-Tag: 1773349784-76575
X-HE-Meta: U2FsdGVkX18csxjCDHbJjT6Zr0HIORz4bM+NGrp73eWdT+ZSamL0VaIQwM4eaaNP1ILr1P0FwYP6sWFW4jDs/zQaAl29I4SNjjzcuO5kL+vS6/G4fLKXDE85Okrhx0lcsVx+/hwBIzuTK55JuhfAYchk54WS8MgJPO5uMb0kf4RlEtnB701rwKAxLapUbXBgGAFtLsd5NEcn+quJh4IutH2MLATrYU6GHUO3yP57BlE+zDhxRKoHoP0ikAOM6Y+RoetihdI/ucfJPIKtONUc7mvX9ZP+VXBx6U+Tyv6PAkpQ5wm6Mq6euMB0WIjJBV9rLeCnihtlYB9lodHV+/H7lI6xmwzZYA08gzH2kVg5tuEW2XVrXGJ/SW8fCLMYdwr+7J9ZnGQCu/C27GSDOmzXy6KLn/rTBDN2yEbKgLNcXVsebFJUDrjAr6nb5Hd5dBxbz4jWHQRoAV926pHxjPxvZQ/UYsXIk4T3SK66QA1W2ospfXs3TGxnwCrQ7p9JaPMR0irSFIkeoa5qZgLn5RrHRB+pkZjdbuCmQeAXADuuMMiqxH4Kw1rgVu357eUU3Ltx2dqtEnn5NFBDEsd9YzZrRdVVSVxg8WXIK6fmBCiErq2vInF5IIzVQvJWEHycSpvizab2x9cq9rwyidmUtOGk8KCr2AJHb5W4tgPjg+xOnjYTT8bFy+EUlfGVWLr4XnPJBO1H1cOwpclQCzka2xjrOhjG8rb/o2moV1fQqUNeKLbFRp2IZBoABpAIqWaLejNMgaPfGZ0a2PFvw39ZTMNdOyT5fN50zmG76O035joDyK3KbVjFZEsN2Os7+ykjyJIDXxmRL5C0dTit6uD3Gga/vvIaMRSA+lojXCDIq7+SsKw/T/oFn2Phrp4JuT75CMj2bsU2TOcpusEhCdskFNLNp7nMW781aJigRdlE3GrM5VEMeWUBTHM7f/fUuQuyHjysJoOLD21bdrPRP2VHDaJ
 Q3mVgHRu
 YYEkrTtqiVPxZ4IlzEVNcR97MTbQr4LRxWow63oSPP9ApVMGfbmNGCDLPoLREkLZj3pvCoi9I5j1kYYr6Jn06qwyofsDoB7e3xdf9/zhhDHdUFs/QZtBxT7aTBi2Xrx82vqRLvA7Gr0mYWIvq0VX4m/nSNVLuiZo+qqaiDcNkgPObA327hwLV4Y4GjCGZiRMLGnm2X4KIiDthiXLJH14bPCPjedMnuhgHzn1MpMFtYlzjHBt+9dip+zPD+UkaEWKfaDaqUfboE7giIcZj2/D80IAibdrRClwabFQu4lOfybcSKVc0CWM6h8KiladeOKUacO51oYQnFFjsR9M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
> > index 64ebc3f3f203..ec64daaa2f5a 100644
> > --- a/tools/testing/selftests/cgroup/test_zswap.c
> > +++ b/tools/testing/selftests/cgroup/test_zswap.c
> > @@ -589,23 +589,41 @@ struct zswap_test {
> >  };
> >  #undef T
> >
> > -static bool zswap_configured(void)
> > +static int zswap_enabled(void)
> >  {
> > -       return access("/sys/module/zswap", F_OK) == 0;
> > +       char buf[16];
> > +       ssize_t n;
> > +
> > +       if (access("/sys/module/zswap", F_OK))
> > +               ksft_exit_skip("zswap isn't configured\n");
> > +
> > +       n = read_text("/sys/module/zswap/parameters/enabled", buf, sizeof(buf));
> > +       if (n <= 0)
> > +               return -1;
> > +
> > +       if (buf[0] == 'Y')
> > +               return 1;
> > +       else if (buf[0] == 'N')
> > +               return 0;
> > +
> > +       return -1;
> >  }
> >
> >  int main(int argc, char **argv)
> >  {
> >         char root[PATH_MAX];
> > -       int i;
> > +       int i, state;
> >
> >         ksft_print_header();
> >         ksft_set_plan(ARRAY_SIZE(tests));
> >         if (cg_find_unified_root(root, sizeof(root), NULL))
> >                 ksft_exit_skip("cgroup v2 isn't mounted\n");
> >
> > -       if (!zswap_configured())
> > -               ksft_exit_skip("zswap isn't configured\n");
> > +       state = zswap_enabled();
> > +       if (state == 0)
> > +               ksft_exit_skip("zswap is disabled (hint: echo 1 > /sys/module/zswap/parameters/enabled)\n");
> > +       else if (state < 0)
> > +               ksft_exit_fail_msg("Failed to read zswap state\n");
> >
> >         /*
> >          * Check that memory controller is available:
> > --
> > 2.53.0
> >
>
> Seems a bit convoluted. You ksft_exit_skip() for one case in
> zswap_enabled(), but return some value in other cases. This value is
> checked in the caller (main()) and then used to decide whether to skip
> or fail as well?
>
> Why don't you just consolidate them in one place. If zswap_enabled()
> has no other callers, let's just open code it, yeah?

Hmm I actually like having the helper. What if we move all the
ksft_exit_skip() and ksft_exit_fail_msg() calls inside and rename it
to check_zswap_enabled()? We can also just read one character:

static void check_zswap_enabled(void)
{
       char value;

       if (access("/sys/module/zswap", F_OK))
               ksft_exit_skip("zswap isn't configured\n");

       if (read_text("/sys/module/zswap/parameters/enabled", value,
sizeof(value)) <= 0)
               ksft_exit_fail_msg("Failed to read
/sys/module/zswap/parameters/enabled\n");

       if (value == 'N')
               ksft_exit_skip("zswap is disabled (hint: echo 1 >
/sys/module/zswap/parameters/enabled)\n");
}

