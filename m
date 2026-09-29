Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09656CA5FAD
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 01:06:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13CF46B0098; Mon, 28 Sep 2026 21:06:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EE586B0099; Mon, 28 Sep 2026 21:06:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1E046B009B; Mon, 28 Sep 2026 21:06:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B938B6B0098
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 21:06:01 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 47C3012036D
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 01:06:01 +0000 (UTC)
X-FDA: 85265008122.07.7C6B4D9
Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8AEDAC0002
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 01:05:59 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=e2j5CzUk;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of thehajime@gmail.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=thehajime@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790643959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WSPn2rseK6a4IufNo372qRJbii4TFE3JGpArxCTS3Ec=;
	b=PTSfYzfIMRsKvI94E+xWKhRukQQmgZwPVP38CSrFXW37Uf6b2cAQUavWMBqoQ90cZEaPIS
	6hI9g0j+7mSAoWVZ0yXDD/bqkXpXep4F2ktpp1V5l1hwqJICCLMdIYm+QAc68o78bhYu4N
	PWi3SU4z+Ll6on1evfO4QkpyLt+4WaQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=e2j5CzUk;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of thehajime@gmail.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=thehajime@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790643959;
	b=I4Trfv952iz5AXYGAnNIpMPB8Sr+mf97tNz19urXa5grnqGawykv46KXO18L7GVU5z6j0F
	jAaLFqGAOPOU6oauPoTAHVCAm85K3G1En2vMMYA1HQAkxenG07QjckRU4MYzwBWmCGlx94
	UbOU5K4V0O1vgYYKVmBIKE9KtgvBxvw=
Received: by mail-pj2-f12.google.com with SMTP id 98e67ed59e1d1-39b2ad83dc6so2442392a91.0
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 18:05:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790643958; x=1791248758; darn=kvack.org;
        h=content-type:mime-version:user-agent:references:in-reply-to:subject
         :cc:to:from:message-id:date:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=WSPn2rseK6a4IufNo372qRJbii4TFE3JGpArxCTS3Ec=;
        b=e2j5CzUkSYMWznfKn969flbibitwn31uGJE2VIhfZJFmDm5cqUUpbNUwuXrPuxTMO9
         GwkTpk3kQ+0KXpcQI2Y3bgmnqnS3AFQT93iFUUeefx/oB4qS8AjAj0pWI7ZvjQIQgpdE
         Q7eWWj1DbeAeEvqaI8QvN6harf0JBWrIaPKk5X/X7/uESqX3RMLQ2fOmg6pTUjojRfrS
         +Ww9ULjXg3fTaICPMlCcm6ZIGaf3LUSCcl0sZJ48wtiINbKncQ7PCNbaB4crn5DNnHkr
         SSqv08tgK1rvBKdNZZpcCEHNAfGcn9ktCN1RpkMaC8Wwxri8WceK1Tsz6f2d0HDSNtt/
         BUOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790643958; x=1791248758;
        h=content-type:mime-version:user-agent:references:in-reply-to:subject
         :cc:to:from:message-id:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=WSPn2rseK6a4IufNo372qRJbii4TFE3JGpArxCTS3Ec=;
        b=XxhrmhBYKUI8m1KWuAQ2jBe6IYgigmJ+9Hvc2X7eWGMTpcAqjvJmWQ7sHK7IclhVb5
         Yvwaj58jXcibf930EJjX8B3cTOKUl5Fz/Iuvdkoh9Cuz32QkXDgcvH5uRFz72q2orK1y
         s4wQ8L2+giJeQdIvSBCeCXRnQe4c/aHxqVM/jsOzGuo3+M1KD5zth/xP3LkzblzUAp1u
         pJEkswIW4dOeAcg67m1daGLJsQh5PVF1UtiwBfWn1Lk04z3gTqgrPJlQbbq81RShy9UT
         255qkg6FvlszZohmZEk5rQeSdhfj11z+VyoOiL3s1mc5yf2wwg5iu2jQ41kzcyG+A3XL
         /Gcg==
X-Gm-Message-State: AFq9FYLZoBpXoXBHV7CI/Nqvv4Q8yNGgu1lBbvJkEsGjC1jKJr+4K7oQ
	JtlIcYhoy7afAn/ObE9UTvKQ5RTMfrXUokZ7agLc2FjpUIclb6dipxcz
X-Gm-Gg: AYBFou14IQNoY/0QdAoZ1qj97CVqVD2pokApBWkov5JQwAfIprwcjU/DU3UpRSTukQh
	e2eg0XQn63iv9W2A5AspsvNBtfLhGxP8lXvD+I9w+8b0GOjRrwUVS48bkimgXA9ixkjOJeJHjVs
	xeLumYZkg+RUOKD4M7W1jKmMISpd21zmygipcFfEJjDAsUdmHZmSiwsJ1i+E7clhsvaKC1DrE4J
	IrtWoaFNkNI+4uw+1/U3bVrGr8P0v+GRu+Mys5FmzGosA4vKX5dPOl4b6HgwYa9/ipwLfNNJyeF
	UvEHari5+Z3UUk0+1GwwT2gQ/kMpbEbRMx7/BdinkKLUCxYG+2272hOFZBo+OBxjWVM1IqXsBFo
	6GEpCNu8bF/4GJRn8NByws5Xco7Jdrg1OV9ubryuJ5dH1859kX3FK3dt+Vy2Of8hqx1iVf8Jzv8
	zAsseN05X3uAKB1kkP7ZRYLD9bRFOvpAyKSu2da5MUtBKpKiy+XHifWH7ewJXlxSctZEpGGlk2X
	323Qps1y54eIy8qoIQ7YpNUCvGnqDG8YkXiSTxtJ2APbVm8b7SjRnvNu8SPQnXTRwwjj7GNInXC
	SvTNvPDWgIF/9B9bPoldvOSfuD2cIN1FSicm/UQnIQE61paH+gNM/cyqglj+N2zDozpNCir+Ll+
	i
X-Received: by 2002:a17:90b:50cc:b0:3a4:9b6e:2996 with SMTP id 98e67ed59e1d1-3a49b6e3900mr809185a91.36.1790643958360;
        Mon, 28 Sep 2026 18:05:58 -0700 (PDT)
Received: from mars.local.gmail.com (221x241x217x81.ap221.ftth.ucom.ne.jp. [221.241.217.81])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a497edd76dsm2135265a91.7.2026.09.28.18.05.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 18:05:57 -0700 (PDT)
Date: Tue, 29 Sep 2026 10:05:53 +0900
Message-ID: <m2y0ck3lzi.wl-thehajime@gmail.com>
From: Hajime Tazaki <thehajime@gmail.com>
To: pfalcato@suse.de
Cc: linux-mm@kvack.org,
	liam@infradead.org,
	rbm@suse.com,
	akpm@linux-foundation.org,
	luto@amacapital.net,
	brendan.jackman@linux.dev,
	david@kernel.org,
	liuhangbin@gmail.com,
	corbet@lwn.net,
	kees@kernel.org,
	ljs@kernel.org,
	broonie@kernel.org,
	mhocko@suse.com,
	rppt@kernel.org,
	shuah@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	wad@chromium.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-um@lists.infradead.org,
	geert@linux-m68k.org,
	daniel@thingy.jp
Subject: Re: [PATCH v3 1/3] selftests: kselftest: avoid cd - in runner
In-Reply-To: <arqu1zdvMBXDziRX@pedro-suse.tail5790ac.ts.net>
References: <20260926010819.604346-1-thehajime@gmail.com>
	<20260926010819.604346-2-thehajime@gmail.com>
	<arqi6iwLDDBlk6Tm@pedro-suse.tail5790ac.ts.net>
	<arqu1zdvMBXDziRX@pedro-suse.tail5790ac.ts.net>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) Emacs/27.2 Mule/6.0
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Stat-Signature: geap6h3ruu35i7pi1xafjuyy9zsfdhkc
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8AEDAC0002
X-HE-Tag: 1790643959-330142
X-HE-Meta: U2FsdGVkX1+ykdWPTAyy8M3PCGc18k244IrZb/ibWNBzTI36D6D52x7plCydDZNRDMPOx5qtqlxLSkIh6EdZlgeVv/fqpxtmTRs3xICcQVtuSAgC2QqjQFofi7MbV64Im6CeEpkaIRhHSFB6uJ+dieVaxq5URnzHIgn/YkK4xW8f0WhTxVi2w8tYfwCjEACOkhBhJi7posyv/Wez5MFBkex6ZR/tvaAoIixfhcencf90tO4reekcI03wT8QDG6mzBECF/CVAPE4p/qd70aBzcHQ53DXLVYo/aLQf9tDtAyMYGlXw1tVX4hz7LYj8A1XeMqskE5DI6IyFTnQDEmp389jvK5foFFaA3Ts5jC661XlCYzPi6hayHFVXB8EXsWjyUtgqri8vh4lx1tSgc59BYQ09rvxkxraKh8WpU8yvaGQ34qqRi8N49JtCI56az8EC2cLhmc5P+HqpPEQcC4X7W9XeJmq5sdQ/m/DS0RpbTWyiNMOeujHpxAEf/szcVLKCarjwKo5+pn/9vMYsGeZe85xQHZcJUm6JUGEUgVFUtFAUIWz9SKzC1qRwdX/7egFp4tgaGCjjPcmyHm414C4kN1IfH3DZz2RmjVB0oh+JbjFYDQziLAWhkfv/2dGzb6bCd6tMaj7IkMnonwiOaZTMBK3xh1iDFhk30IcY5KhBE13c/umSl+/emfV4NpPgJM4lIzwHWEgkZxL+wlCgnpvHN6WbwgDFXSo9xBcStKwmD0i41DPD2hDQU+HacRLugdpQLjctTsBIxuAbyXpz2AAUmyrUbsGLvPEv1f6wO1ejktC1gBofS3V+78VRhs5DvIoW+Kpi31XWpNtTnlGy/VmXJGwf85ceT4Ng8NmPBCd7gN1gPw5rqEc/K2O7brwQ1flhVurqLFNl7GIvIsr8SG5AfsB9lJv7dFTcCOtHzWvtU3KJ5AiHbgOLx3PxbR5r876Si9bi1/oTO5ZhD3VGfnq
 xj0EDkn9
 i/Kp/0JHIQpQmqCHr/RqPqVGxA7VRSwYsOV05pIkxW7ih3lg+1XrcFtX+6nJRRP1HRl5BxDMB/30mQNWEPf0tJdlaX0GZwQHoICSTt9HXyfQyXTVoZpRFuUPL7MhsBeHaazKCi6hWkNyZ8g4RmY6nHvLJ11Gax7lFW5xV2eVfTSessdGiwuswiWPbVMtcr0QP1jy3uHonl9QW5MycYNu1gXi2zhbx22BxxfTkCxnFNZK5k2/f+tUhcEl7bAr9iAVu2KO2fHC3IXZqGJ5IAiRUznPQmGKZ9GXJ5hGB7zb+SL2b8nBqfGm4lfOhC2LtxZt0F4CYUTrMNrKsIMJQ51vK75znTaslSGc6D/EOa3kGNGXIc088+GucigF4sc1okWPthUrHLWpVqQyJWEXz6sv6DocRQcqasSZqMmjzhiyq4xix8QcW4dF7sV+pMYNNeLWmf9EArxOIZkccUzZ+yfQwK1DjpGfAIobp9dWrx+1GHOn+3bsa9j/HihkEcik5WMtKOIBwafvVXw1raWKrlO+ANLhsmZp/abKBh0mMN84U/HexovRHaisN6lnCXPckCLSO8i6xKbaAFQxpnzqVUU/6rejb9MBqLMS/KmuxgCGsAjpZt+BEVyuIw4otuKzjKM8URQXbSsmv/d1FKFMb8esGizwyFnvFjE+UhNiShjES0LRhk+KpXtjV662tcahF2o5MXMkgN6E2eAjmhG5pQuCQsN7NNoE+10220UjU6dlFTnPm10hAXJahsDQYbA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, 29 Sep 2026 03:16:48 +0900,
Pedro Falcato wrote:
> 
> On Mon, Sep 28, 2026 at 06:27:42PM +0100, Pedro Falcato wrote:
> > On Sat, Sep 26, 2026 at 10:08:17AM +0900, Hajime Tazaki wrote:
> > > The kselftest runner currently uses `cd -` to restore its working
> > > directory after running a test.
> > > 
> > > This is not supported by the minimal BusyBox hush shell used by some
> > > NOMMU targets. Store the original directory explicitly and restore it
> > > with a quoted path instead.
> > > 
> > > This also avoids printing the directory change performed by `cd -` and
> > > handles paths containing whitespace correctly.
> > > 
> > > Cc: Shuah Khan <shuah@kernel.org>
> > > Cc: Kees Cook <kees@kernel.org>
> > > Cc: Andy Lutomirski <luto@amacapital.net>
> > > Cc: Will Drewry <wad@chromium.org>
> > > Cc: Mark Brown <broonie@kernel.org>
> > > Cc: Brendan Jackman <brendan.jackman@linux.dev>
> > > Cc: Hangbin Liu <liuhangbin@gmail.com>
> > > Cc: "Ricardo B. Marliere" <rbm@suse.com>
> > > Cc: linux-kselftest@vger.kernel.org
> > > Cc: linux-um@lists.infradead.org
> > > Cc: linux-mm@kvack.org
> > > Signed-off-by: Hajime Tazaki <thehajime@gmail.com>
> > 
> > NACK.
> > 
> > https://pubs.opengroup.org/onlinepubs/009695099/utilities/cd.html
> > 
> > -
> > When a hyphen is used as the operand, this shall be equivalent to the command:
> > cd "$OLDPWD" && pwd
> > 
> > which changes to the previous working directory and then writes its name.
> > 
> > 
> > If you're running selftests on !POSIX compliant shells, that's a
> > you-issue. Fix the shell, or use something decent.
> 
> ... I realize I was a bit too aggressive but seriously, lets not support
> broken software, please?

thanks for the comments.

no, your comment makes 100% sense to me.
under fork-less environment, we have less options but I agree that
this should be addressed in a shell implementation.

I will try to fix a busybox shell and drop this patch from next spin.

-- Hajime


