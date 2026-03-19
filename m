Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E0FF1075260
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 06:29:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D31736B03FB; Thu, 19 Mar 2026 02:29:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE1A26B03FC; Thu, 19 Mar 2026 02:29:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD09C6B03FD; Thu, 19 Mar 2026 02:29:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A79746B03FB
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 02:29:21 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1FAE9B8EB1
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 06:29:21 +0000 (UTC)
X-FDA: 84561835722.05.EA3EF99
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8CFB74000E
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 06:29:19 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Lsdtv1wN;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773901759;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kPYf4uxtoH6BBi1Vu2Iyc7v2EsgJC9iDN4L1g9XyNsk=;
	b=Pfwsng+ptkbQi+NuyM0JEAzTsWaHNtkJDr0wzpSWCYmoOKYjaanqALXWq80f5Uy2gQPYJn
	3VzCJVE2eKbYdC0qSOyX4r9SFUDXKDbqSEv4BuTc1z92PS8Qrm9E0ft5bWu8JsFbT4kGvb
	0cwa2CKvhyYFaglgOE+S6D8nON7xqn8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Lsdtv1wN;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773901759; a=rsa-sha256;
	cv=none;
	b=sErs5+TrM2N9on03y0aCMBW5Fe9N2L+ErTBADHoAYm7TwcwH42Yi432Rdc9OjF8a+3acau
	Xt0ZYRTiDCGHEj/Y4d/niq6YEBm7umPESDwDgRC4QzFn1clpn4SBh58/2pPLNV2WIrorfD
	1cwcGbLLKz7E+aiwJnr4QKs6vtNTEWU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CBCA16011F;
	Thu, 19 Mar 2026 06:29:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6978BC19425;
	Thu, 19 Mar 2026 06:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773901758;
	bh=f8KRoUgEZ6BfqFTgvZjmWr9krDqWtElmbj+tt3G8zZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lsdtv1wNjXhyKRk5gYZ/88+Ukqgyuq3m6W3FNTVwgHS1dyfIaKNZf98lFTfkwaxLK
	 6csCbEEXLVDO0PWcsLXZPY9JhOTNI/bh5snNTbKxDpaGhzG08DzQno6rU36EEDpV5q
	 +hNeRxypDsuUzzYfdsaJnqk93JYOIWLJASMnEYR9j8yO/s+2S7w7l7p4lcU5+pYORK
	 mFdhqpa7vabmZ2FeCayGdmEjhVMPrXKunisL/hnJHr//tAMoh6vQom5IEdbH/nwVIZ
	 dfRDNHBTd1j+qRrwkAfGbIChHDZYmDQ1TIuBi1nn98ilbFLxeddh0ymyoTJ55jjrXr
	 6HKB+scj9PZHg==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH v2 01/10] mm/damon/core: introduce damon_ctx->paused
Date: Wed, 18 Mar 2026 23:29:10 -0700
Message-ID: <20260319062911.77252-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260319052157.99433-2-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8CFB74000E
X-Stat-Signature: hpogg8qqh9bjar7zytywqb6szghi4y1h
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773901759-800685
X-HE-Meta: U2FsdGVkX1/lpW6+bhjl/hqJVdCqfjLN6miqpVNzZmbEnW8iaX4oAbAgFWK8/ZhqNGGtTZBAaNSp4iVMUvsYPIO5zU95g83zWhj5gycY0q9FdWMbIGa0DSedvFEzysL3GqrR4vKS0U2COWUzM/RZXLBaxDBvB0+Tv55orts2OjM4SLS9wnLfP9HWO7ESCxqaw7SyJmsVOMyA3lk5ndOcqI1qxEWf284MJ+1XWmHakOzSas+HyQzubcCfSvyfU1HCdOiQFotjdB0aWKAtNs5YD2PMLBHOb8LJxexHuuTc1KzClW+wv3/Lb6RwulrORbPWIvzdC+Sa4dBMbno/csc8pdU8mV4bwGz6v5khj/RDNcTWKpaTambRlicIL0bJneoIXQoj7EPJbQqQi17ysFxFgjdXUDErmkpMsQuuBBjaA/4uil7g0lssljUiRlUd1hT6u5kBgu0xghClB84seR7zQy99jyuAdLmsSoFtoyVUECqXz1+z6zZrIowLSBcXxLjGW4whDL69nNy6NOyemP6MpCJN0exxTYxVtOU+FT/Th822xBEaIjfMLwpeiIQz3yyI42IkiTB9ZvpnDRR9YtOYEuTAJEJg0mTY4rjKspivxvVb15hIXRkmkjizzVkoCIvoyHH/HNJNLYBSqAMOs3VDyJXDIvvHJwE/JQxVBH2mnpyi7XRTdwkG8EyhB3XXJTG75ksAKTmk4vUlb0cZEeyAQhgJZS1rhjvwtm5oBBQ9ZnP66RZDFenmTsmpmjdg8aCwZzlYwvDwL51pTtAh/pjDMx+aa8MyLk3hCiw7HaO5KmMoUqQ1r+M6115wntABYLuDM4AVj1i1XoVt4D44l43zsahlNEFY1+8Ym1fFsuK/1U1vHxHBs51dQ15ELvH8BHFtOgA2hQxiq7RYE8musg10U2fLg9zW9TBzJcoiZJKmAKfFw6qLITwrLL6XLHKhL+PH5IXrKgHkrSeZEYJVAIR
 0HVMFBJo
 HhgSIAeyrlSDNn+CqQqqtZ98yC0+cb9J6bxdteGiT++S/L+2cQNxz79Y61S4Xm1xre2k1wwK431ay5O1z+4k3HrQ8DoaSEPl80Ijzesh412mILo2F1Twqeoh1gLig6Lf9WgiuFq+s9pXLrKo762a8pIBlSvKcDnQIdU/b7YNpHBFuobtk7iANU+4vpnMcIxFeSpWGq1fZR8vCtcBPJbmdLs/fhdafRuOfpi+aeI6ucSVecroNCLPMo4dz2spq0jdoaVVhxkbFcVLbSrNntWhGUHQXlg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 18 Mar 2026 22:21:44 -0700 SeongJae Park <sj@kernel.org> wrote:

> DAMON supports only start and stop of the execution.  When it is
> stopped, its internal data that it self-trained goes away.  It will be
> useful if the execution can be paused and resumed with the previous
> self-trained data.
> 
> Introduce per-context API parameter, 'paused', for the purpose.  The
> parameter can be set and unset while DAMON is running and paused, using
> the online parameters commit helper functions (damon_commit_ctx() and
> damon_call()).  Once 'paused' is set, the kdamond_fn() main loop does
> only limited works with sampling interval sleep during the works.  The
> limited works include the handling of the online parameters update, so
> that users can unset the 'pause' and resume the execution when they
> want.  It also keep checking DAMON stop conditions and handling of it,
> so that DAMON can be stopped while paused if needed.
> 
> Signed-off-by: SeongJae Park <sj@kernel.org>
> ---
>  include/linux/damon.h | 2 ++
>  mm/damon/core.c       | 9 +++++++++
>  2 files changed, 11 insertions(+)
> 
> diff --git a/include/linux/damon.h b/include/linux/damon.h
> index 3a441fbca170d..421e51eff3bd2 100644
> --- a/include/linux/damon.h
> +++ b/include/linux/damon.h
> @@ -811,6 +811,8 @@ struct damon_ctx {
>  	 * intervals tuning
>  	 */
>  	unsigned long next_intervals_tune_sis;
> +	/* pause kdamond main loop */
> +	bool pause;

This field will be directly set by an API caller.  But this diff is defining
this field in the private fields section.  I will change this to be defined in
the public fields section, and add the kernel-doc comment, in the next version.


Thanks,
SJ

[...]

