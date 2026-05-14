Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FAADCD4F39
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 21:43:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D98FA6B0005; Thu, 14 May 2026 17:43:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D22066B0088; Thu, 14 May 2026 17:43:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEA986B008A; Thu, 14 May 2026 17:43:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id ACD6C6B0005
	for <linux-mm@kvack.org>; Thu, 14 May 2026 17:43:54 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4AE27A06EF
	for <linux-mm@kvack.org>; Thu, 14 May 2026 21:43:54 +0000 (UTC)
X-FDA: 84767353188.08.12A67CE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id B6EF7160007
	for <linux-mm@kvack.org>; Thu, 14 May 2026 21:43:52 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JFC7SNiE;
	spf=pass (imf08.hostedemail.com: domain of minchan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=minchan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778795032;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z3GbrlLUBlmD6dJxLKOGpzlxo2esa8sAFdSeIXbgO2Y=;
	b=OSUC1kECVQCD+ZOzYp46ke0VhTQxf4L78efxtlyfHqCmiovginfSFZi1UYs1FO918pS3QR
	3B1WK7+/r6YV44Tj0KnDrnFGNao8CseoJbfDMOD4/c705bDdu6wISJTDQ9VeFOwdmfw5xH
	RVO91WDh7buZ6a3Cpo9kvD0fewWGxos=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JFC7SNiE;
	spf=pass (imf08.hostedemail.com: domain of minchan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=minchan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778795032; a=rsa-sha256;
	cv=none;
	b=sFRQoCdaxBx5TUzTnnQEnmDyUv7Bqc584RrpLAn6A+VuL4zu5ckmij/Z1KYI8t0OyMmZte
	ijRvcH5FRBYQsHrqP2gTYVyF9oIOQLmpjSwOkmWw4b9xlw/7W4fA5wch1V13LCgiigWZVm
	QMl84Fn6Xdd9NewD7rj76ctZzlNNACM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 035C460008;
	Thu, 14 May 2026 21:43:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DF56C2BCB3;
	Thu, 14 May 2026 21:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778795031;
	bh=205Dg9+b13DcjQTMV0rTW+w1f2xOl+JJOBtYTKjYa6A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JFC7SNiE8UhhRnsLS0Ce0FMQV24ymQdI8Gk1BQHRRbrozaDAVLrUNELRnFM2BWeix
	 gkD8A83rg3AXWBFpGAUJEKxYBwnKNUKHNfbDKI5VavH62uRdJPizbxGXO/FlNy5p8G
	 4vHda2u9el0P5PPAxyZCjSsP03mTK5mxQVHn3nwWzhpSRQArsKJnXHIRiDjPbCJy7J
	 Y8cSmyhy5lMfP6jhowY1TOr5Si/M+RhKyaGSngXjafGeAp8fUe9RHgcTW0D4dklO0R
	 F8zkmRJXjvvC46DkDAkfaKHIUP1DPqmB0ko6y8w4j6efDbyWJ/1gHLIdHbipc7aCXF
	 8qTUZW0sN98Tg==
Date: Thu, 14 May 2026 14:43:50 -0700
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel test robot <lkp@intel.com>, oe-kbuild-all@lists.linux.dev,
	David Hildenbrand <david@kernel.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	mm-commits@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>
Subject: Re: [akpm-mm:mm-new 301/315] mm/oom_kill.c:922:12: warning:
 'kill_all_shared_mm' defined but not used
Message-ID: <agZCFll-lFLqabbJ@google.com>
References: <202605131940.kEzvUaiR-lkp@intel.com>
 <20260513102711.323fed51b7dbb1dfe6217b44@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513102711.323fed51b7dbb1dfe6217b44@linux-foundation.org>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B6EF7160007
X-Stat-Signature: 7c3543enhdhi888d65zpttdkyuh7hb1j
X-HE-Tag: 1778795032-391126
X-HE-Meta: U2FsdGVkX18Mu/WAabbHxBxw3p70TLOggVs0TKkk1C2xxuBLDTBKpYuwKniP0dt6ZdB2XYad08orBi6tjW6d1NJYvp+iMUDOLxZkNssHo7QnR7dTZR4FsROdJjv437U+j9o0XhBVZyD+JtoUKr70DpI4Whe/APQe47SkIcIiB4lIyyBAgn53fNtofHV+VOyaGykeGSja8iZK0EYhZnd0Kz/PvGx+iVA93rFz1nBm4uNfi8K6dp5TlHtlsjKBD6Ggrd/DpMWZF0xVdmd0GD0epWBqgYUyFJXTb1qTQKfsKur1HrnVXZukpAcVnbLmO7sk2yHesrO55vkx2IP1r2z9ZiiwZFKH54XBTDmfNRQQbxhJAAEabVVTZhvhyzjerWxS26XixsIy2W2IpEfYsBNdAX/cubSDbncFpTGm9wY+AjJbc8I9vALqrYbpMKj0q5M9TvZxd7ECOx9CNpQzFWojMfZAffxif67qmACD3gGVSbMQZ8BH0BsUDPXA2xcUokxXH16koXJpMZSyVZxLKkKBhTfqvy8HoABzS4AXpLmLkn8Kt+y1AcwTEk4Jh/Qoj556Fb1sR6lVSZFFG36odogqTYwCzWZPbmVCtMxMTR20JFrTvktnOYI2MD3zkaashV0IDLi4i1dECoVyIRT3f1+Hap9SFtnMwFXcetlVQast6Px8lfVmQyAJy/NHz5rn/RHsJxyUZoo2QCpnz6N8C8Omm2Gsf7IT8WQ00k3bEx5thYk6CP8VHk3//V4//LZne5+cuqKr7hZqj+FgXjXltMsfggI+FYP4QhYcQ1zjPnRXOlCNC7V5C+q9Hb0iNJ2c80VjhLrTP/oXTYLOQupruMvH+itO5T6HY8oLM1V/6VyN70tOIGLd5tpekK7qedGtISCCF7O/bWe0/RZB5Tt7SrKjYxACMI8v38E5aQ9Cw3nEcRJBE02GU+2MLb/TADX+woJCA1w8McDOn2LuKIMSlYD
 5obOIc2X
 tI3K6hb57ZXvBM9Fd0/LTlEBacr2XiHUDCwnCoak98rJCRyRRUdszQh348gAn7otAqIWoKEGiXgL02v0rI7MxI6R+tTn6MhejBsvgQAhi9jv/cJkdjTFQLp8xjWx0N8cgjndr4qlS2aY75MktCVpOmlay46FYcwTyFPEHGErJgihwOq7oWgQKWCAW91LLT4/v3RnmQOx2840isjwtWIFJNv+oNONLkfKJNC1MSHnvdm08vVDbBOCsRSFtxcf1rBjH6c/IksjEQaSDNkGybVIdQJvkUAwDV36pnIzrc0SRsKDi37E9KG2JtIcShf/CFdBaYaEiXSBV7wM+Fst2b3/MHQGXe/D3z8yMlJGfF/WuovcgZJY4n1x/mPOXlWIIhZjhI67E7GF2MqM/E9M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 13, 2026 at 10:27:11AM -0700, Andrew Morton wrote:
> On Wed, 13 May 2026 19:48:25 +0800 kernel test robot <lkp@intel.com> wrote:
> 
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> > head:   2c3f468717231305523ddcd94d91c0d5e4a72419
> > commit: def36547cd98fa3f7ecac1bf860479f500bc6b1e [301/315] mm: process_mrelease: introduce PROCESS_MRELEASE_REAP_KILL flag
> > config: sh-allnoconfig (https://download.01.org/0day-ci/archive/20260513/202605131940.kEzvUaiR-lkp@intel.com/config)
> > compiler: sh4-linux-gcc (GCC) 15.2.0
> > reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260513/202605131940.kEzvUaiR-lkp@intel.com/reproduce)
> > 
> > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Closes: https://lore.kernel.org/oe-kbuild-all/202605131940.kEzvUaiR-lkp@intel.com/
> > 
> > All warnings (new ones prefixed by >>):
> > 
> > >> mm/oom_kill.c:922:12: warning: 'kill_all_shared_mm' defined but not used [-Wunused-function]
> >      922 | static int kill_all_shared_mm(struct task_struct *victim, struct mm_struct *mm)
> 
> Thanks. I  did this:

Thank you, Andrew.

