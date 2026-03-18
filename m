Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0F981077605
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 18:33:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AACE16B02D3; Wed, 18 Mar 2026 14:33:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5DE66B02D4; Wed, 18 Mar 2026 14:33:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 973A76B02D5; Wed, 18 Mar 2026 14:33:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 86BC56B02D3
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 14:33:27 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 16A091A010B
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 18:33:27 +0000 (UTC)
X-FDA: 84560031654.20.C67DA3A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 81C2620002
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 18:33:25 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=chyubJ3X;
	spf=pass (imf03.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773858805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QM8gX9Knlp5PbehyuvdpvO6uUuoMNurrwqrjrnHeSks=;
	b=ZV6+rsFfVYtob+Lheevw80ZtO+fjLRYOF7XC5EzQ5Xyrmqp1kB947G5ASO6dbORk5eVRdL
	lj2ScyLfMVDGVyYoGgeOitA3jZ2U31XMP8PZk9Dhtk2k8n+Loyj2XhnJldb+5iY00hOHq1
	DMXmO7gNRQ4vlEuVqVPbyVi2oZzrRZ8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773858805; a=rsa-sha256;
	cv=none;
	b=vig2A5i5C1srY3hmak2gXqobwbJASXgJ2/ybwvXdPGr5kp0Goe94KBzoaKFFxkF+hBJCrS
	86XnwinqwqJqZWXngdElsQ1XuVl+1lmxz7inJM+KmqSbbQbYZ0Sy/NfIxE8p2rwaUyCYLy
	1raMzm1IhKluFq6QI6YPrGghi47i3rU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=chyubJ3X;
	spf=pass (imf03.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1B32B43AC6;
	Wed, 18 Mar 2026 18:33:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9929C19421;
	Wed, 18 Mar 2026 18:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773858804;
	bh=Q/uh4QAy4IU2itVKlERvGMXidyUsuGdulupJTD5xwYY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=chyubJ3X1/firrp76bLjG/+vNfJqNnB90aYEk6Zcih2c9oabwEvoGLloeOaNTiLY6
	 hqfkJjRL78NKkqbcVGtfZNCEqcNKCoe/PFcPdNbgXg0uXPCD7vW8Yp5avtdW0kKFp1
	 D7IbJ82yq6DqzJMjeVXAJ/qH152XodTiC3pihX1Ykbh202ePhb2bcbuHvCsQQOLcNQ
	 6qRpSFVvr0fwGlnPtaX/Rx1Npsvi8EP6hC8eHaFByCvd62g0GK15dVuaZz98LVdDIb
	 QGgz1CYNBDLxRBxcb9W7EoReKrwoAHzO4pm2annaPka3Sul+V3ascK5FgWfVDEgrGt
	 9b7D0aoZqSRiQ==
Date: Wed, 18 Mar 2026 11:33:23 -0700
From: Kees Cook <kees@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Eric Biederman <ebiederm@xmission.com>,
	Justin Stitt <justinstitt@google.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH 1/2] exec: Add KUnit test for bprm_stack_limits()
Message-ID: <202603181132.507C829A9@keescook>
References: <20240520021337.work.198-kees@kernel.org>
 <20240520021615.741800-1-keescook@chromium.org>
 <a3e9b1c2-40c1-45df-9fa2-14ee6a7b3fe2@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a3e9b1c2-40c1-45df-9fa2-14ee6a7b3fe2@roeck-us.net>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 81C2620002
X-Stat-Signature: oqdibhtnkdxfex1cjmb6qbf7w6rgrztz
X-Rspam-User: 
X-HE-Tag: 1773858805-671706
X-HE-Meta: U2FsdGVkX1+oCJpoYRJXdivUlNR5t6fsNvhwWBooXQuCXAD1jQo4bogY1w3S/HMRoF5wfqDc45t1KC8dBDO1c7jHtG68ykJDs1LQvVlCHr50hzJycoPdJNfr+9oa6a+3/Z/v8giobI/RKRcU5YQIzuIcYQDySA+eLl9IgK35OE2Wxdi3zTLxyxfxK5RoLxgxDdg28pDfD0WQlji9eThZhz5AGCQA4qGqLS6oUIo21Qf7mXQa8eLVaVfktMWgMic7TDFa2ZZpuISg7Kxs2gok9ejTNVePrvx24JFOKAUYKS08t1acX0k4iIc84L9OsTPVavTcYnNRkVRlsf0Z4Va6amFILuSHOAJZWaJGS2xks5o3TXRMnGcqDmDaKRg0i/otQgv/RdEkFRYhaV74dJyiyyu5soBE0BkuykTKvZG8LKPWY+fdYL25qMF5FeFYTe0HuOZWdneDtBggxdYUN20Nm+3pkbNyJteqq4/CfzZGcrLkIlkhepK6yTV/GKcYr9KjJBs3Ei72+96QNQ4xxo8jn5Gw1bmGikhjYe6XSQMa1wQhBQaJgDn5814wnuyILxHYa1nGA2j8KayzRZ0BXhHceMrdi+tEwC16JoYEj/8A2BhDbbN0AoRfxffYx6gG/jw3AvXwt9nJiM6phfp4Ti+WN8WtGfs/z2UDfuUhchaETLEUaSfdhvSMiIZMVHuvQ94M04GRLIohFGjc98PWfLSfixGqrvhLdl0gYXgZhxpu81WELSOpH6Eb3kfHf/9OJyfA1gyfhTKdo5XzA7ZOO3idhZAJACXLHhkMywzfnouF9a7IASWrZPGfYFbgqK3mkt2Bsi1C7/Mrnm72Y/HLsHRyNWRZERA5tUW9Mp/3r21u/5uNYi0Guf9heudblC/5djOytrh2ECAu2dpYIWe/9vzQSG0Xr/8MqF+l5OigMkGdVr9ZT2RkUIJ1Zk2d3bhxrAz5kAoMWHNgv4hJt7bfJqP
 ixIKg6jg
 4cbaF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 16, 2026 at 12:16:58PM -0700, Guenter Roeck wrote:
> Hi,
> 
> On Sun, May 19, 2024 at 07:16:11PM -0700, Kees Cook wrote:
> > Since bprm_stack_limits() operates with very limited side-effects, add
> > it as the first exec.c KUnit test. Add to Kconfig and adjust MAINTAINERS
> > file to include it.
> > 
> > Tested on 64-bit UML:
> > $ tools/testing/kunit/kunit.py run exec
> > 
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> > ---
> > Cc: Eric Biederman <ebiederm@xmission.com>
> > Cc: Justin Stitt <justinstitt@google.com>
> > Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> > Cc: Christian Brauner <brauner@kernel.org>
> > Cc: Jan Kara <jack@suse.cz>
> > Cc: linux-fsdevel@vger.kernel.org
> > Cc: linux-mm@kvack.org
> > ---
> ...
> > +++ b/fs/exec.c
> ...
> > +	  .expected_argmin = ULONG_MAX - (_STK_LIM / 4 * 3) + sizeof(void *) },
> > +	{ { .p = ULONG_MAX, .rlim_stack.rlim_cur = 4 * (_STK_LIM / 4 *  + sizeof(void *)),
>                                                                    ^^^^^^
> 
> Google's experimental AI review agent tagged the above change as syntactically wrong.
> How does this even compile ?

Wow. I have no idea how this ever built either. I will get it fixed.

-- 
Kees Cook

