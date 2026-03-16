Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A89DBF46445
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 11:02:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DC6B6B01A7; Mon, 16 Mar 2026 07:02:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15CC06B01A8; Mon, 16 Mar 2026 07:02:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 089916B01A9; Mon, 16 Mar 2026 07:02:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ED0B46B01A7
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 07:02:07 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9AD041B6EE8
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 11:02:07 +0000 (UTC)
X-FDA: 84551636694.21.E195DC1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 03C5AA0014
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 11:02:05 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Nfxuw0vY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773658926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b4IoLFkt+skuWqZBhxHzmoNyJcQ6C7VaPFZWWwRWlVQ=;
	b=Fkz5U5KMs085bkqH1gCwd2IlVAv+fZ5vVC2GBazJxlUvhUxXrfuNXjhbAJodT1z3s70yK8
	kV2hThGDT3xJsfGUaqXxgCPNBFfIGsmz6Q5INjlAAcrUZu02KyEtgjxFl+47CLwvU2+Ggq
	bFAN8vTFjtOoGBoRQEOjCWTV+UbgEM8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773658926; a=rsa-sha256;
	cv=none;
	b=bfx5ytK0GCBMbbGSfdOpRAtKhs8j+9o2vhiXoXbOohFZZAMlIJ4LaapyuimN0uriakRzk9
	TkUc9a8LvHmztYQndtpT89anuEEmtniGC53QJ+9mhBPVs3hhwnQHghQltOKnzMFDmLK8Vh
	ozIHkJfJpfrG6QRCA2IOnqiSaDgZM58=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Nfxuw0vY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4A14260008;
	Mon, 16 Mar 2026 11:02:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE1CDC19421;
	Mon, 16 Mar 2026 11:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773658925;
	bh=+vXY/uUfxIgAWWoJ8k86RgfB7xYXWE+ipd2r0nuy4v4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Nfxuw0vY9s+sFIWP+LQnSSrqDH5Pm3bXu8ejDhVm5ZXg7Sm1FSyMtO8HkBt/jkg7K
	 uBvIC+EhzFaUOHRB3F5/hves2byS/3UesJ2IEZjvpe+07Pc5xmoV/z/vhxy6M4zMy+
	 krbjxepCx2eWn8J3IdHNR9Bz+gkySZjPC3lD45vuB12I5p0MLnb0509eOTnHl+ZSva
	 T4XyhhgNvztRLwP6tH5TcHXoaqWQwG2+xsNxwHolmwEQ0vV0B/1+79TyFKIv5jNG+N
	 B0ERorGxTzYBtZgMroP6B7q4O/KumzZEt/E1Di5WOKpJBZC1pExyu1b1jUVql1UhOj
	 v9zv1sqnD0LUg==
Date: Mon, 16 Mar 2026 13:01:57 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: syzbot <syzbot+e24a2e34fad0efbac047@syzkaller.appspotmail.com>,
	Liam.Howlett@oracle.com, akpm@linux-foundation.org,
	david@kernel.org, jannh@google.com, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, ljs@kernel.org, riel@surriel.com,
	syzkaller-bugs@googlegroups.com, vbabka@kernel.org,
	peterx@redhat.com
Subject: Re: [syzbot] [mm?] WARNING in folio_add_new_anon_rmap
Message-ID: <abfjJYAWOLpsQuq5@kernel.org>
References: <69b703e6.050a0220.248e02.0101.GAE@google.com>
 <abehBY7QakYF9bK4@hyeyoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abehBY7QakYF9bK4@hyeyoo>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 03C5AA0014
X-Stat-Signature: fj5wd89m8j81ap7snfixons4anct7spk
X-Rspam-User: 
X-HE-Tag: 1773658925-448912
X-HE-Meta: U2FsdGVkX19Az5gRWMEeZxRXtF9pYHP9miLFlIY7PZZp/XqjJU9TCSFtDy6hoTVhToQfqmiZbpkGU3Ds/WuLrRvSHXR0A8Fgti+tXoNqMU38SmMchI6D+VRt/y7ANTP4FTsSuql+S0wFoe6Vb0cD900ppKMUDd7JYCLA7cZaP0ZYvTpRnAO8s68G8VFGx81hb3xqPp8cBjyxDoK12sb2W6fVfrqVKyBxCaBHUN0RPKO0irCDk50mugTrO9wXstwM3KNmY5DD7fWJXf/oUrA4W5m898fT2U5tVvgnlDMbc4eHe1tTMNXhLy10CzK75zygmba6a6YnfOi2XzT4wM/FnRj6kV1xRBIyeqZ0EPj+ueDKq86sOskFjMEtpf09jrC2LavTque3y4gLYxyT1PF2Oz0ixSCrUxLYRaZt66lUUiKWLw7HnBCAM/u1hApUWn6bgTgcePSS7wDMJ8sUAbWTY3YInjOSMMVhVWQQKuD+t20GOVGBDE+Mddpg7N72spt0QzCHH31X/Qn+KPFe+/fc8vREJhMv0fET7H796POiae+967vR3CZqiXVBPwrJXRZXSQncwX2BbvHgrG5NuJatpqxJW5bjdPyjG/5Z33StJn4BGLWmUo0g2p+edvvrO6cI6xT/E4uevqX9+ITlXzXaYe7GHn9anr8ZhcKLeG+jYoA2FEXrLj3FgZpEUL1wruyrVxvKyT2H4nn5ZBNrFjq7bmizzFogCWvLfVFFw9OePgY57TIyDS95+Yh5D1kBSVMNn90DWy8A9VMGgK3OZEX1o4+EEjZyiXC/70uiUI3QFp507cymKW4U/u5lKc2C+PFcJa5iIW+IKZEFoYXQHDQU1FQeVvgbt4ZwbpklDL0JWhnLr4McVLjxFL8qPfTsZUBaeP66L9g3FqC/J0kwsfDOjLXdonp6jQ2eOQ3XAawNKZlJG225K+DV+ZFNcU7Mewk/VOuzEznpbMoC0Xqufpu
 UEIMSzoN
 qzFm+8z4gGLFdgXZJ4hcLeMQftghzrYSjVZG1PYls4BfRtGIxLv0wx3GaNu0SSKVegeba6rlOzcS11/GQa2Nzrd1S1jbC3tMQNzJYaEQvMY9u4H+yQCMgDq0eq4Ze0vSckCh08GA/2/vPBsIRIsnTKA8wTG8JgBznkqi4bDio3JFaOBAYgWM4Gy0uy1c8a1hct+3UPIVHd4ZJsHylw9nXLNfd/8oG0VCuqEHbR8t+ZePwNn5HQ4AbiB0gxZK5dSBGt+6fOFV/hHTyUjPxyhXblwB0qjeq6HVIp+rYaYPJy3o7Fy4o1/PLP1wHtceq7xPTHvdeutFH2F5d0fPo3fI8fFHk/kOZf1BaWFBfTEfDing+ZpItrxXMA4MJBtDC5er9ALIP2+f/Z8Ob54s3h7R0hsV3+7PmxgZJkJbVZg3U9k1x4OR/1oQY2pLbomO1VgRqfwDe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Harry,

Thanks for the fix :)

@Andrew, can you please fold it into
"userfaultfd: introduce struct mfill_state"

On Mon, Mar 16, 2026 at 03:19:49PM +0900, Harry Yoo wrote:
> #syz test
> 
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index 510c6dcb9824..73adf9ffcac2 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -880,7 +880,7 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
>  		.dst_start = dst_start,
>  		.src_start = src_start,
>  		.flags = flags,
> -
> +		.len = len,
>  		.src_addr = src_start,
>  		.dst_addr = dst_start,
>  	};
> 

-- 
Sincerely yours,
Mike.

