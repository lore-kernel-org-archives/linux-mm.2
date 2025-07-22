Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3127BC83F1A
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 00:35:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D8BE8E0002; Mon, 21 Jul 2025 20:35:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 589B38E0001; Mon, 21 Jul 2025 20:35:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49F8A8E0002; Mon, 21 Jul 2025 20:35:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 37ACA8E0001
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 20:35:25 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A06B31401F5
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 00:35:24 +0000 (UTC)
X-FDA: 83690031768.23.E88985D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id E459880004
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 00:35:22 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=INuAml7a;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753144523;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EsXWWPwR7DnfbUiy0T1Ep+dd0MnCyz+JTCzy2sAeeEk=;
	b=1FqIIiCh+F/tiL4Jr7YPhcX6Sbl0KV9bFtbA/RHIEPVf0O+LnlnCNisKnj0/bFJ7z4WYj7
	HsqR57Uo77QL4Kz3SMqwXzou4NYP4jBYa4vtsmRcG79n6egtkTO2Sz57RSyw3jvB9tOqUO
	Kf/C3qR2R+vH2xR8rVJ7vrR1+xI4hYU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753144523; a=rsa-sha256;
	cv=none;
	b=rmyvvQXy+8k7DMiM+R/inS6ZLEcxrczMvOsyv76ocDipKo0QQ/y8DA/aGfurFSGEuCO4De
	5pB3Bu5HcDnuE46cHhTccDDK+64pZrcL+vd6DVIiD8wdBTm9fZOB5SNMbqQmBIFnOvxcO8
	hdpLOr4F/wH6iw89z9Sy/5yYun+foFk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=INuAml7a;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8B10445E94;
	Tue, 22 Jul 2025 00:35:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7F17C4CEF6;
	Tue, 22 Jul 2025 00:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753144521;
	bh=AT7biWnsDCxaCvU7U+iSpw4vNS5TBQoe3SiDN0kL4kw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=INuAml7aaOfZKzIUxI4Jtp5dIRPXceDiGCMSn/BcpBEsTc1817QQF/mLnLo7zVGvC
	 tbq9rI4BZrhjCeeHWJKHB4TAfP28laWLUpmcWr4W9hiZ6ObpNJJQoYLudeaLJcdFFn
	 UTOfW5v0jeh5cKAcLjqgeLQM4saR33e63KErjkHU=
Date: Mon, 21 Jul 2025 17:35:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Sabyrzhan Tasbolatov <snovitoll@gmail.com>, hca@linux.ibm.com,
 christophe.leroy@csgroup.eu, andreyknvl@gmail.com, agordeev@linux.ibm.com,
 glider@google.com, dvyukov@google.com, kasan-dev@googlegroups.com,
 linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
 linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org, linux-um@lists.infradead.org,
 linux-mm@kvack.org
Subject: Re: [PATCH v3 01/12] lib/kasan: introduce CONFIG_ARCH_DEFER_KASAN
 option
Message-Id: <20250721173520.a24c29782de519dab1c59fec@linux-foundation.org>
In-Reply-To: <a1bc7a9d-817d-49cc-b7f1-79a900090136@gmail.com>
References: <20250717142732.292822-1-snovitoll@gmail.com>
	<20250717142732.292822-2-snovitoll@gmail.com>
	<20250717151048.bb6124bea54a31cd2b41faaf@linux-foundation.org>
	<a1bc7a9d-817d-49cc-b7f1-79a900090136@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E459880004
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: nccx9zexac79tucdshhyrwe7xat3xnkw
X-HE-Tag: 1753144522-212722
X-HE-Meta: U2FsdGVkX1/h7Pv0rWjFuKGQNm+Vj1oTfqmnTZvif4LRjv6O5+IFXbss9ZmxbG9XJTRNtNLWdSYnwQI8zc50ZnxbEyGgiIRRmguhzOK6sxfO7axuNwdASziX2r0wyBCdS0xTZvZE8sqzsWrNo2cZznrZyzv4diTWA2Zsbx8pUAQrXEYIZxcjta8GjQcUq4DZ3zeoxwJshdKAIQqZhuRnHzaK2DXMUd0ZtCtS1xMSvdB7utmopjE0m7VUK6f4eALep1kDJUHaWObcxS06jbzqOgDWjfnz2RbXmdHTQSxUVCmiNgRfb2ClZQI7V1E0gjn0JRPbrqHFntro1PmlGcGcsTkwRWmMyo5IF3RKHXGE7QBWGYi4UL7X5X2G4lVynFQ5aqKQZNRL7HgDVgIb/W4gaA9r2JfruqKeZkUF7bCatXd47ICcMh8ZeRW1aA7ouGAiLQJB1Kn3Ne18J70ulaXeRm6QzEYPlSOrJevd2JVZwGLRzDROhkoXJe61x/GLOVv3gjsEL91JTAwudHHVo9SHqucbiLcpDep3lPFhGIwuzozXdDr4fAcPDUmFXj/j8hqL1Jg6UhrduSwMfjVMlKSaHOmqjObwr6Um58ws59ci4F/FV8lIMBL66GoDj5ghkvgynOMjmllHpIc6Np8Kqbaw88HBRFSvzBcfLtYt7l1AuU0pgcqdF2BaX/DHDlA6HBiyZTXBVptrH9HUbFwW62I2Gs7bF6oKRIbG8fDRPmcqApS2OGFT5Q0Uva+S8XyiLCh8UuAM3UII/S60YRbBHpVhtRYb83txU6ORhGkurj6KbDE5IylLe/m6cpmmvb0yDjH8a1xQwyA/RT5LOnxvMytPkmSrinE7tmcCzkClSs0DjlGu4m7QHpq2uPohl7K/ry1e/y/zgNPCRPt5tam1ynm+wVwjqbX3cInAmzUMOD/VoENfcqtzixaDOkS9WZnYDqBZi0wRHE1UUyt+mduIuwm
 zbNBS9nU
 nVKGAnTQNImSoXrjlZ5xAbiGAa9+WZq9xth7SDA16bXrUUnjtwDn5CussXxC4I8r0EIclt0bDXV3AazLRB8yb/MbsWFj8dXnuJRj+HVQd6wiqUO7zZjiw+I51mg8GuPkKEI3g+/1udwHq1S5E5KQxMWpDNGzQEAGWvvIfwZI9MMcP8w2fKtWY4f9ttlZ4c8ETwmpVcjh/ANsROnf/mSDfzjpAkvXVre6CpC4v5HU4PPg9n+EcV+u5qbYUulmkFEziyVCQT6aVKsaWBRRgrjuU6JrZYCNb9D68Uhv1R+vMVYy1E3YmZA9KnP7B1oCaIOV4K46pQvxIrmmjXmQrbYYyE7RQH2lcy1HzORLBaHvrRC9dI38zWln6nIUusTte3+Axl0YECkA088LoqmY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 22 Jul 2025 01:18:52 +0200 Andrey Ryabinin <ryabinin.a.a@gmail.com> wrote:

> >> Architectures that need deferred KASAN should select this option.
> >> Architectures that can enable KASAN early will get compile-time
> >> optimizations instead of runtime checks.
> > 
> > Looks nice and appears quite mature.  I'm reluctant to add it to mm.git
> > during -rc6, especially given the lack of formal review and ack tags.
> > 
> > But but but, that's what the mm-new branch is for.  I guess I'll add it
> > to get some additional exposure, but whether I'll advance it into
> > mm-unstable/linux-next for this cycle is unclear.
> > 
> > What do you (and others) think?
> 
> After looking a bit, it breaks UM and probably LoongArch too.
> I'd say it needs more work and not ready even for mm-new.

OK, thanks.  I'll drop the v3 series.

