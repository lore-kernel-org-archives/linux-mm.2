Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 346F7CC6B3E
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 15:23:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97B686B008C; Thu,  2 Apr 2026 11:23:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 905436B0092; Thu,  2 Apr 2026 11:23:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F3C06B0093; Thu,  2 Apr 2026 11:23:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6AE306B008C
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 11:23:20 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 91ADE8B7B8
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 15:23:19 +0000 (UTC)
X-FDA: 84613984518.04.D696B10
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id C7BCE1C000C
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 15:23:17 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TeY7Uf2q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775143397; a=rsa-sha256;
	cv=none;
	b=f2+Hr4/MQPh7UWjDWgC9Df20Y1Pt5p9BIAmvLtuh7SJJrwhbLOUB/tKSSg/sYhjjvRneA6
	dnIm1rOWOchVJ3n6nDRcKfEJEf0j7r5JeriYVZ1V52ToiYC7megbKQilHHm+H51Sdwrba5
	kSmCnMV/P+SaG9WZlWeDcHHTKdSUL3M=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TeY7Uf2q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775143397;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rFvI9897lK1OL6qF0rcgzGrU64o2rw5W+lwi7wsdQUk=;
	b=6BxW96uQZm7TE6Nacd+19qTMdJMYyH0Hx2KhCI0hFtaX9NArMmiCDZdbVB+kTGz3FA7BUv
	GQMYU+hImIcz8j0KeUwhI6VPIw8vgS1/yURdFlocDjZlRDZWMiDbmHj1+Y45VFRY6nMu2Z
	2L6iQqEKjVj5PGhNJvES0IDhiGELnIw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B68E64358F;
	Thu,  2 Apr 2026 15:23:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 729BCC116C6;
	Thu,  2 Apr 2026 15:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775143396;
	bh=9oVYR4IRaxvDvL0h28oK6fCNi0c0M7sx6EhNv06jmrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TeY7Uf2qx87lhQUZWJD1cFm6cVZ0Ib0DKRAsgjQwIUnU82ILe5LlRQN6zj/SGbSTL
	 kOvMfMyIb5u8XnAq8BeVutIpbxMBRPoUzv+aMPpv6n8D0i1U43Oc0Uv01O3qSv8CWo
	 HrJfFo5I2DPalWNuqpGYWgigbw4iGRHQ5K5Uftk8rhxhnvl5BC7aa7+/KrjSZl173q
	 H3AQkVY80Cv08X7DuxmutmA1u1ly1VY1syoQU9SlhnR7j2+wp4qijNSXGMToxNUqRR
	 1pm0VcYUiL0Yf86qDtaHPEec1cUm4sAKz7ebvqPPsyFAXtVhwFnO8yKc4CcNVkLcLi
	 imiqijvjmHCwQ==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [PATCH v2] mm/damon/stat: deallocate damon_call() failure leaking damon_ctx
Date: Thu,  2 Apr 2026 08:23:14 -0700
Message-ID: <20260402152315.75009-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260402134418.74121-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C7BCE1C000C
X-Stat-Signature: p8k6chatcdycw43f1rwpqwggssacygyy
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775143397-618423
X-HE-Meta: U2FsdGVkX18cMbt1XssDnuvy+pzl39IKEqDOcLuKx8GpdyxzXsOBS7yWT6F0eD/VOVIR9BZldLchsD2EaH9CzeflI7YgeQXARY6G+F4BRGXghMpMXJA7mgvNfUhZBRGtyFZOykgNYmBIt/GDorA+FsIB0SZ99F49ZWmqY0WlqBCUHftsp7VP11+HBfDGhvHkWY7o6+VaZmZ97NIYOLuWjGk0oPNVa6qHjaVbUxQoSIzcsi9YQhxpjIQzM7UDhimK5ul9R7wDcv8CsKjVe+k3AeNw4dyro+A1yq6cTDUn6lVVGWCD6n8O2K8XRezIpPYENnsc/tdtpHpu/cVqgQaQOfqPaBDZhB2pu1zQbUFsIm+oepEn59W6Qg8/d0JSLarM5jnpkmGCsFd0nYEOS3ujr6WZvvx6I0Ia2s/FMeqsEvYMfzaw1J0YvHqVAhpfNV5/+6li0irqEDRDeb4qcK1sdmoFircwmS2g+B5CZNQleLGXpWCPr7ef7/gIBkoMx0J8MwqBDZYbSZdv3qThJvgvf+cps61dEe0oSFeY42bxl+Qenr5mZ7aXHCMBUwSeeTtvDJdhYJw6/mQuBJRn3d2a9jkLQZnXzjJA0CW5KLhDdfbphk9OB46Cs8Hs8NvObWwR1ZMaXKziWJf7qgbqQJhWlMXA6peUsxOjVr8v8/Oi4DHCLqSH2OK3QUnW4VR2R9OfEgN9myqmZ9t2mvMDfLt64N5NswMSxCPf5qezaMJ1RlpL4QLrwutI0sWaHYtz2v3HkmEeX6wh5oY4NdlTZiBpkIEE19IxuHL8Uuw6k12L47RaTyJQxx3Q3y55WIpP1GS8bmUTqqtO7TkDDiNLN2HsnQ+YR468lUQ8jXu35a/xGCspN+1ZWJ3unqma5a15Iu0IEZeVbrJPmKY0g2+D5IQMkYHcku/oPZ9HL4GLWH/iDAmvg1csAxZdCjmI7E0+r8GeHEyBDqd69SuVxwZS5OF
 JOYJRipe
 MdQQcIK1+VGudY/AfxrzLQLQRimJW5SQfHFJMdfLmd++m3X4t1RcLXlu/AvOyHIQ1dIvpowD8gD2+c8JZPzxDZOse7NY26u2f28H9bNRzgv+aWzdCCvk8exSJvqVMS2S1iXXOkEL/L0jNcD0tk2aImkqYP7c9MxSSadTroSAdW+LbyVj8rZtcL9OSMTmOPoRMBJsW1WnKqc4+kzc9bSfIH0AYJPmMI4RxlX1FeT7zB4dfqsYbRf9mOpqkyWAUiD9nyT+raevWFSO4fU3UIG750UgqOaySyQTD8SDIeNTa0LqG8bPHWe70Kd8BtJyPK/lJEDx9KoGD3Y9xMbM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

- stable@, as it seems this is not really need to be shared there.

TL; DR: sashiko didn't find any real issue.

Forwarding Sashiko review in a reply form with my inline comments, for doing
detailed discussions via mails if needed.

> # review url: https://sashiko.dev/#/patchset/20260402134418.74121-1-sj@kernel.org
> # start of sashiko.dev inline review
> commit f956e734cbf12d26893e0ce6fe09667b1ba0ca51
> Author: SeongJae Park <sj@kernel.org>
> 
> mm/damon/stat: deallocate damon_call() failure leaking damon_ctx
> 
> This commit attempts to fix a memory leak and avoid a use-after-free
> by deferring the deallocation of the damon_ctx object when damon_call()
> fails, cleaning it up on the next invocation instead.
> 
> Link: https://lore.kernel.org/20260401012428.86694-1-sj@kernel.org
> 
> > diff --git a/mm/damon/stat.c b/mm/damon/stat.c
> > index 30aeb2c207ec3..b1011a7a2f291 100644
> > --- a/mm/damon/stat.c
> > +++ b/mm/damon/stat.c
> > @@ -245,6 +245,12 @@ static int damon_stat_start(void)
> >  {
> >  	int err;
> >  
> > +	if (damon_stat_context) {
> > +		if (damon_is_running(damon_stat_context))
> > +			return -EAGAIN;
> > +		damon_destroy_ctx(damon_stat_context);
> > +	}
> > +
> >  	damon_stat_context = damon_stat_build_ctx();
> 
> [ ... ]
> 
> The commit message notes that deallocating damon_stat_context immediately 
> after a damon_call() failure leads to a use-after-free if kdamond is still 
> running. 
> 
> However, it appears the immediate deallocation in the error path was 
> left intact at the end of damon_stat_start():
> 
> 	err = damon_call(damon_stat_context, &call_control);
> 	if (err) {
> 		damon_destroy_ctx(damon_stat_context);
> 		damon_stat_context = NULL;
> 	}
> 	return err;
> 
> Since damon_stat_context is still immediately destroyed and set to NULL 
> when damon_call() fails, does this leave the use-after-free issue 
> unresolved?
> 
> Additionally, because it is set to NULL, the new deferred cleanup logic 
> added at the top of the function will evaluate to false on the next 
> invocation. Should the immediate deallocation block be removed to allow
> the new cleanup logic to handle it?

Seems sashiko is saying so because sashiko applied the patch on one of mm.git
trees that having the v1 of this patch.  I asked Andrew to drop the v1, so
sashiko's claim shouldn't be a real issue.

> 
> 
> # end of sashiko.dev inline review
> # review url: https://sashiko.dev/#/patchset/20260402134418.74121-1-sj@kernel.org


Thanks,
SJ

[...]

