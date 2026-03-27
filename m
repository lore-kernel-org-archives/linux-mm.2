Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BA4810AB83B
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 01:34:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B10656B008C; Thu, 26 Mar 2026 21:34:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC2686B0092; Thu, 26 Mar 2026 21:34:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D7496B0093; Thu, 26 Mar 2026 21:34:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8D0506B008C
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 21:34:24 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2A41C1A0D49
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 01:34:24 +0000 (UTC)
X-FDA: 84590122848.29.40DF4E1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 68FAB80004
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 01:34:22 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=2l9LWYsM;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774575262; a=rsa-sha256;
	cv=none;
	b=YQRWZo+UurgeOhUqzKvYEbkG8JA1CpiXcqefXhQU7y9rKZZW7j7l+2qQcb1MGH/94qP1qd
	ekmzdUGYmgh7Vp8iYmMRO5CAul8iSgljuoHBEl3UCWnD6IaFsCaFjLPKkwkNfxCKltxbBA
	eeFhGZLfw1PQwnwoq/hVYQm8Ne9ikeQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=2l9LWYsM;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774575262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qd1RJvMXKdQnVJeoSA04xmkcXF9lx0pKI6T4MequMGM=;
	b=LmOO59Oo6t7WpAKsdYTAYokehVuSFYDXRTYUhHCxvIKBheuOKi+w5lF5Ffk6DGswC1C5OV
	Gan5deOvmPRcIWkQx5gn4CnAWpkt/6l0UoHGJMC97wbU+1T/yfElcDZ4x8Loo0zveDm1pc
	LDCU9Yuztbj+dLEsZEd88804QJO7RAc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4334B43A80;
	Fri, 27 Mar 2026 01:34:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDBACC116C6;
	Fri, 27 Mar 2026 01:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774575261;
	bh=cprlYlXK7DOYpOoG+qevi/asVd+0Zmd1lgFmMSDCY1Q=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=2l9LWYsMPhAkmIGVHfzX32IavfM6yyhhM7uNUO9HmHZbTAz9z9kWdJU0N7G88Rlgw
	 XYcTnUUrIgmmbdvko6C+oRgaSsKsqmjRJqwmnBkeiXmDU0dsEp+nqaKw8wM/sRgJmu
	 gEdyppNL0n7mq2OPJqejZzcrGvsCGeBZGyy5a+PI=
Date: Thu, 26 Mar 2026 18:34:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Hao Ge <hao.ge@linux.dev>, Kent Overstreet <kent.overstreet@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/alloc_tag: clear codetag for pages allocated
 before page_ext initialization
Message-Id: <20260326183420.bbcbef02b8d2f3dedc4c4980@linux-foundation.org>
In-Reply-To: <CAJuCfpHddCffwF6uid_nW8sMAMpJcOiB62BCeGEtoiDYY6rP4g@mail.gmail.com>
References: <20260326140554.191996-1-hao.ge@linux.dev>
	<20260326181145.35b559956a45b0efdc9c0450@linux-foundation.org>
	<CAJuCfpHddCffwF6uid_nW8sMAMpJcOiB62BCeGEtoiDYY6rP4g@mail.gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: mamwtyabu3xqe45y83xgxoo3z8wzjt6d
X-Rspamd-Queue-Id: 68FAB80004
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774575262-264808
X-HE-Meta: U2FsdGVkX194FO2WD4t9NXHDDbK/F5hkLcQ86BJ6fCfOiQWi9i6P5GXkaAubKjjl3G7vkYxidoWpxg8G0mQTDJ57Dw4pB/Q6DqMHSurFxqBXW4pJqFJymUNLe2DWeFF9y5h2PIz1POnwY+MtDzHMLiknBO1KRPyhB2R2DW9ZFruDxKF9Im/xbx8RlCGqfz8zDZ0FOIH3nZpP5GOXk4/xa9GbB6M5Y/FxBHoEr3QfgZ0pswaji85qSHfhg5Mb4DqtzHazK7vz/U1XBYeM9M55I1AO17CiBg6DNEDTY35HaibKr4q1In/od/LpEFPBylBtMqfmPY7LzDHQPt+7HkYIIZgz4ieUQ7haesDY/c7tBOpGlzWMccaP6arlPj3YUcb8KpV4965L+H57jFeMk3s4cgYKK20j76D+axr8NmAnIoFIfVL11LpG1WzsfQ23Vq9dikrBEhdw6RZdSyOTh09O1JaxDcHqksHUp2mnZaYVHs+6K1rnNVtfMRWBjtGL64EFMJLPNrlU9CHjWQLk1sS9f0CmocKvEafL6kP+xlCeay9IvXkBzpeLVxpdgWCdXmCpVftmegusFvu856W5j9i5LVZLln/LbyjY0Ap0DqwBUWNR3kVApHe7vVxdvT9u9ZhYL1x+yfLpKWrFX/sNsXJZMK8qmmCkEE5DCwcW+5ndPV7mME3ii6bvI4edt1T8nnr5MkzOIMQh7HSnNHvYCfzOMxBgkFhsH+R3vzqCvrXg1kbLZNAS1eh+TDzEwhbxvVzFNmJ6KzemIajZhwxUJaHYs+iwhRXCHnTyGt3EEg9C0OPyAh9+gI3nNw/ctfMFBekIO42sSN8h67zVz+ePEgP9OdG/kS6RBcjWsYbQgxUJCHgrevi9+GP1Zjv7+Iut8LrPzOn8TWwSDRX9fjHFayqVU7ZJOi+zu7yYriv7I73gfYNZY9mD6zlzxv40rpzF9uH7b/nN2XKOGNsxs83N5fp
 ly2pwvWX
 b3DhQdn7pdEIcHrS7KniBnkB/crqKHDDbEuJjsmlgpwSy6oYw3A0zXDxYrJAayweWVlIJ+ZnhF1z0wR/mlEczO5zobnbxJx4R0HklJ2gtAG+y2IqsA+Mq3R8FBQhHc7snubydV4ZUPgwmH/XzNyOa+xPF+/d9le/hhzCNE4sjy6cLfiVgT/Q0flKzhNUxLdZtOVN11u4cpGUjYN+0aBMExadGE9PKUhyjSc+ZZvrZOlwdKGtUJGyR6jnQ9apwhqB1klF3b3SyJiJ1dsZinvNrXxpQW9JjxUTkS3IBPRIuDO5A2cmZINzKo4uHXjuBM6L/VMhgq8Hpo+nGAlNSWI9w3k7eVfzPCiPKmzNaxz3LpaFE7vNKO7+R0fKbEO/LgLYjv0dI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 26 Mar 2026 18:19:56 -0700 Suren Baghdasaryan <surenb@google.com> wrote:

> >
> > Do people use CONFIG_MEM_ALLOC_PROFILING_DEBUG much?  Is a backport
> > really needed?
> 
> IMO backport would be good.

OK, thanks, I'll slap a cc:stable on it and keep it in the 7.1.rc1 queue.

I added

"This bug occurs when CONFIG_MEM_ALLOC_PROFILING_DEBUG=y."

somewhere in the changelog but that's pretty lame and could be expanded
upon in a respin.

> >
> > Either way, it seems that this isn't a very urgent issue so I'm
> > inclined to add it to the 7.1-rc1 pile, perhaps with a cc:stable.
> >
> > Please all share your thoughts with me, thanks.
> 
> I'm reviewing and testing the patch and there is a race and a couple
> of smaller issues. I'll post a reply later today.

Cool.  I was going to keep it in there for mm-new testing (which is
light).  But I guess there isn't much value in this so I'll drop v2.

Sashiko had a bunch of nags, but I think you're checking that routinely?
https://sashiko.dev/#/patchset/20260326140554.191996-1-hao.ge%40linux.dev

