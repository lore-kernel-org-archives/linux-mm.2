Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37DC7107639C
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 19:52:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 054826B0088; Wed,  1 Apr 2026 15:52:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 005626B0089; Wed,  1 Apr 2026 15:52:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5D376B008A; Wed,  1 Apr 2026 15:52:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D1B786B0088
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 15:52:17 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 185A916018D
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 19:52:17 +0000 (UTC)
X-FDA: 84611033514.10.3844E7D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9D89318000D
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 19:52:15 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iegSTeTG;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775073135;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WgWd1vXoxl2EUV3d1vVjeNG4k45Arz2el5P//CNWG6c=;
	b=4XqTnRaHOTJhv7Ew+PqpBIYyiTvhk8NiMmt1IBHseiw445QInonlOtlDnmcgH5zZyC2qe2
	s+MS8Xmx5JMhm9tu2BVXzB8awrq6pzZ6d2isak3cWiYl+hmICf2PUlXG0Ntw1jTAKJMZ6D
	Puik2Bsj1Z1q2rCxdHHQCdva+kAiAG0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iegSTeTG;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775073135; a=rsa-sha256;
	cv=none;
	b=KIqYANwzTZ8f8gXofQEtZvowL6BP6lKBo/i7mW5RDy/Pk2WNDIhONjB4JyGyfzKAgmGivC
	tebFeyc45bzobWeMN61PBPj8ctHJX6t/zhvg7yxKU60rIXjlSAdM7rrd7nHSV57UJAx0Ig
	HRZveKX/a61GxmgdkEqPfkRGX9l8+8w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id ED8AA600CB;
	Wed,  1 Apr 2026 19:52:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78DE2C4CEF7;
	Wed,  1 Apr 2026 19:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775073134;
	bh=8td1vtx3iaV4CtFL9W4NINSFT/pfU0MJKyD0q1yzYto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iegSTeTGSkpbx6uOdKbaa8PHajPSmamUqAiudCJYUsPCcuLVNjTo1tvyvUvrkCqR3
	 9PacvUB70x9rntJXq5Z9ygVn9H9cXaigsf7s1ZgTiMMksEM5a8MzCMydoLY6eUbGhK
	 fS2nDbywhQpw9F4x1B5c3+7wddNV9cJfHP2pe/EVgQF6gsmW29AXa3vnG5chEdzJnZ
	 UoensbbOEhn8P9X55bLGfG2z96MR9575K2exh8ZmzSznjfCT/BCiGXePnJUhVLS1HP
	 eB1M3M98fPym2kwn1QaARVC8+Nzt0uokKWzse5O+y4GMtr5TFy3pJJ5InJ+dLJWfJN
	 7GVqLRLZdRUXA==
From: SeongJae Park <sj@kernel.org>
To: Vishal Moola <vishal.moola@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] MAINTAINERS: add sashiko as the first DAMON reviewer
Date: Wed,  1 Apr 2026 12:52:12 -0700
Message-ID: <20260401195213.68900-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <ac1fOrrURjCfQyJY@fedora>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 18ibizpirsdj4nxikpnuk7qy5ax13m4c
X-Rspamd-Queue-Id: 9D89318000D
X-Rspamd-Server: rspam09
X-HE-Tag: 1775073135-577215
X-HE-Meta: U2FsdGVkX1+S3L0zB/kU3UR0qDJDNnPqh/BdWQHYZxBgChaEMi8n+uCp6Bu+5lcDfS/wqPQqiLIerZFC6jxDS/c6ZFJLDweO1HqG4n/7w0OVkB+UtvMdLzYiTz+LbbZvD5Abqol2tvGVA9cmC73lutZ/6nkWMkW9s2wfumlwqcgcwUvAdXT0oubfT3zYpP1NvODhSY+oYYhedY0qbExbWGCO7iDZGAYwM4cCzMi2TA98tTAv17k7MLVsYIjCVfQ72K+C3xf1QGDboLBypRdtrg27XMI0qMh+7zwR1X+APvkP9MwEkZ8INBS4lUEecg4MoBtZBrMr6J9xZzoDU3bgB9/xy1Y/R0LDoDZpYKv2SBkQKrZKFO9BgY+LEHG3J/PPkQ7i3Td2Jn0FQGIUxhrqROGC0V6iOPI/c63apA7AkDdRrEUhqzwgKT8J906/NKJMT5jhmNac3anexxgxP9aFv0yW0Fv/hoPXZTDtjSQyKZ2SSdf5QsMOPduOOhoYU/HdWpPtqpaGIzNL2T+8HQLa6fk4IKQ0a3CxkCZd6GOpozD46zgpMlZuSKvedzz0MMHvO6RGDiRJsXxj7tDEA98Gf9Rsfli63ZkvslrWLEDxsZFTgPP0FGrDkpvdVbVyXFlinGYyQzSAOMGCxAnox7NGojcRY4XMXaULtT14e0O8iqaWb0WFEmBmeH8PeuED/xzRWy8ing4mwBJveOFg8mcjPVOhjoenxj2z39LJxPTzm/dMac9fCZFADW54L7/NvfOW163OP/hFeugyelmWq/bGbMzGrvWwLQ8jo8IHaay6XdkkApZunz3ke3fjGB6J9DPqypLFP2ZhKJFfyk3MMY9sXeNWWwhWg/3G5pHCboxvE3A0xQsrUaKCox70iXZL6n75vk2CNN86JPqEbs6qZI7yvdNR9fXJwjaE1ZeOW6/n0DDJukuttn6SsMzyQAZanNEZ0jp35mzyJdR7yvNISO2
 TMeQs6tg
 SYw6Hjo2dpH8m+q4s2B4h0q+rhg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 1 Apr 2026 11:08:58 -0700 Vishal Moola <vishal.moola@gmail.com> wrote:

> On Wed, Apr 01, 2026 at 09:26:36AM -0700, SeongJae Park wrote:
> > sashiko did arguably good jobs at reviewing DAMON patches, for multiple
> > cases.  "Today" is the greatest day to give sashiko a credit and the
> > responsibility.  Add sashiko to MAINTAINERS file as a DAMON reviewer.
> 
> This is a great idea! Andrew should add it to the MM one too :P

Why not 'THE REST'? ;)

> 
> > ---
> >  MAINTAINERS | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 16874c32e288..42aeaa858531 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -7041,6 +7041,7 @@ F:	drivers/platform/x86/dasharo-acpi.c
> >  
> >  DAMON
> >  M:	SeongJae Park <sj@kernel.org>
> > +R:	sashiko.dev
> 
> Maybe we should give it a kernel.org address while we're at it. It would
> look more in place.

Oh, so that it could use kernel.org infra, right?  Good idea, but asking
kernel.org address might take too much time.  I will move fast and break things
by sharing my GPG key with sashiko!


Thanks,
sj

