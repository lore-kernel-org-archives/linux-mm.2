Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B029C79FB5
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 02:54:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38EC46B008A; Tue,  8 Sep 2026 22:54:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3672D6B008C; Tue,  8 Sep 2026 22:54:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27BF96B0092; Tue,  8 Sep 2026 22:54:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B99E96B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 22:54:22 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3DC211C2AA0
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 02:54:22 +0000 (UTC)
X-FDA: 85192705164.07.D73253B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 82FD720002
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 02:54:20 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=AwGlbLg2;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788922460;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L77adGrO+YLnIDMLbqVq3WjXkrZq6e7pkRIlmk3uZ/g=;
	b=d6P1IM0niItwVbSecJbBO75+tZiMJvqHC0AzEd/khFnuVlepRL4YHFGNatorNROQ26kc6B
	CBhRsc3SC3ZrIG5hv2lBN7HxkekpWXtkP3cvWRzgjUPwPAp68Qy48JtylpXWFaIqauzNcL
	r9t0wWBopCsTP4YUuiOIgm1eHtkkgQ8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=AwGlbLg2;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788922460;
	b=EqLmfXfOTllt7G+AlSewRqTWkyOuLEJ7WPMh4iPxBWLga6J7bJceGBdlW7qzVQpOIoykNa
	ikH9NL0WKOc88JkbHAvZskn7ADmw2xcSH1sJPPt6jtZzOVokYLaH5btKWr+TWNSTuHPNs5
	mOS8qII3v7SZRlk+HZOVwOLNzh0Nzbs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D60F7601FD;
	Wed,  9 Sep 2026 02:54:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46F181F00A3A;
	Wed,  9 Sep 2026 02:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788922459;
	bh=L77adGrO+YLnIDMLbqVq3WjXkrZq6e7pkRIlmk3uZ/g=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=AwGlbLg2cKsA86/YUdIRMXJZCaG67B++2lBKT0134dY4vyEt7LUemrP/hPQppBzy5
	 ME5FIXbl9rLktZSBWDe83M7akRVNmmjHhzN7Y37bu2/NiEnkd7E9P/Yjt76n6Jo9g2
	 3IWvJMbr0wTRxmdmA1p0gSTRA7lXmQ7tl5QjmMV8=
Date: Tue, 8 Sep 2026 19:54:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hongfu Li <hongfu.li@linux.dev>
Cc: hughd@google.com, baolin.wang@linux.alibaba.com,
 vivek.kasireddy@intel.com, muchun.song@linux.dev, osalvador@suse.de,
 david@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Hongfu
 Li <lihongfu@kylinos.cn>
Subject: Re: [PATCH v2] mm/memfd: fix hugetlb reservation accounting in
 error paths
Message-Id: <20260908195418.c5ef0f3fbc2b3bec405cd652@linux-foundation.org>
In-Reply-To: <638ae9ae-2cbc-47a4-85fd-52b67b74e351@linux.dev>
References: <20260903030134.7407-1-hongfu.li@linux.dev>
	<20260903132158.a2d6f965477220838d884bae@linux-foundation.org>
	<638ae9ae-2cbc-47a4-85fd-52b67b74e351@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: yu4jzhb9xf11nknh4yf8gn4gky5nadwm
X-Rspamd-Queue-Id: 82FD720002
X-Rspamd-Server: rspam07
X-HE-Tag: 1788922460-465927
X-HE-Meta: U2FsdGVkX19EZICCzCNGqp3HZTPCRH4HS+sZ+2wJ3nD89YithF0YRVLkFpzuHhhg4E1/sETQivNuUlQbt54AKoxrOPSR9EAgPnrhXVCN9sAUm4VFIMdMtOImLqR2Rz+DhOyH00Wyu0K+NFNn2UXTnbAsL7N7AAnHXIYIKs46b7LM9eJY8nEgg5e6VEzKZUsNfmX5O/F0T+bg49yzOHHiZeDzX7QULsneHSys/f7DG2wdBT/9YlCEvVAp0Mbucy24zrhVCl8DMgu2G678GYp+S6REWpH65qtE/sv6XjbJ9XSU+J22WjC4BJi6XNzUwJGsfv8FKf5lvhFqdCJTUzjVNcs11GBehPR9nekkwbLrwFT8vltA7+L1pnrc46JOhaP5k+BLXSiXss2pUBC2AZNwIieSFtpahKHEr4TePOZEHzi3oec5UgxNvzJOl5X8wNEeAFVt/wR6CYmjvL881q4i58VkHaNtQuUpzTIIvUov10VmmXuMvFeGU9TtM67uZr0qk6LLMvf1eQ74+QKOrSC5XkOfmJyeVs7jxem5Mpq2h89DqTfNdhavMo6SaXydqvgo64NTDa1ULuMI1o1UD2uR1VONcFX2wBQD4+q0RwZaIGLi5n2Djv3rpu5qpQ8CReQOd8AgWWNRfUUxSB6udbh/hou6xwjgMk46wnkJJUECx1hN+Nd6RNq7FDG5nv0Nt6lmTX0RnkyNxrDX7pUDWE2btlf6sLVg8aJyh3/ysU34J3LFVKToUxiii5guHEwR6S1y2t62NnHw5CxXw+0LcnrQcm7ny2m7xZNQdINyDjvm+jYMW2ynMn3pmGS5WCt+eSM2svNn4jYBQEDEoiTUuLtKggVlXUchKKBsq70OU8y2lQ4SnmPlFPnmWXrBrC4qytRVWRfOo2cYX/HhtqYoUHI3+FVZ75ste2//eSUq0py/nlb96EqOmtvZtwv8lb9cc9dBf1xsrfuEI9lO31L7Yb1
 tM3B4MUS
 ypox0Vi+byxQ3glbxKpR21UrcAu7jVBWHrIxAk7BoD+vTFpPR5oBb111fClBVzQopB8g2/E5w592NzT+TiT03B3ujGzgKNbNmcHv5YVVrO63uXN9aV04m9yJJXuc2Z57RWqTfo00cBYNdjvOis6fC+N+F/OOnO10raGmed7rdJHAocx5UIIKME7xqBWURZJ3XrDQVPXuUcl68b+lKRZmmt1s1CBukICV9Q5Sr1Pi3Y4beYZUK0aMsqB5pMw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 8 Sep 2026 09:35:23 +0800 Hongfu Li <hongfu.li@linux.dev> wrote:

> > To help people understand why we propose a backport and to help others
> > understand the impact the fix will have upon their system, I'll paste
> > the above into the changelog.  Please send any necessary corrections.
> >
> >
> > Please also update your prompts (if using them) to ensure that the
> > changelogging includes this info in the future.
> >
> >
> > I'll queue it for testing and shall await maintainer review.
> 
> 
> Thanks for the detailed explanation.
> 
> I've updated the changelog to include the userspace-visible effects
> and long-term impact as suggested.
> 
> Would you prefer that I send a v2 now, or should I wait for maintainer
> feedback first?

Well, it's been five days.  There have been 200,000 patches since then,
so this series is at the far right end of the asymptote.  Resend when
convenient, please.


