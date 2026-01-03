Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E298DFC617E
	for <linux-mm@archiver.kernel.org>; Sat,  3 Jan 2026 17:21:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41EF96B008A; Sat,  3 Jan 2026 12:21:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CCAA6B008C; Sat,  3 Jan 2026 12:21:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D9616B0092; Sat,  3 Jan 2026 12:21:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1A0086B008A
	for <linux-mm@kvack.org>; Sat,  3 Jan 2026 12:21:39 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9F59413B0D2
	for <linux-mm@kvack.org>; Sat,  3 Jan 2026 17:21:38 +0000 (UTC)
X-FDA: 84291319476.30.FEF5105
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 04F80A0009
	for <linux-mm@kvack.org>; Sat,  3 Jan 2026 17:21:36 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=rKn0f2nv;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767460897; a=rsa-sha256;
	cv=none;
	b=y/oOkTp4iq5xVOlHJVjDoRYHU/jm5AnwO3TmYJswPDllx08iavqAKSCkUELUoJTYv+SDC6
	jrM4mizN12nxVMSC9kWAp2wluMJMvhFjNbeK6OfY6xlb4qBDpmAyaG8o91I+DYQGbeiBZ4
	+GCWzgZbmusHQExZlj+nDfWewkPaf1A=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=rKn0f2nv;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767460897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oBbf/8RHR8wN4yWo7Xr2i9OEuGv9tU9NLIsibmTMu4M=;
	b=yIB8xRlW4s1CFJpZUdY2bshxL0zCoZALNn65/6Ux5Wc4v7oBOAqFMZWmMOkLpwjDy9wpy1
	59lFGOvVY7g1WGdIHqgdmuEcxXlcGFC+6GJxrHKJ9f2WTjdQaZPjDZHPst8qvpXP8x+ne2
	B8FoZbOUZac8hM1DaxwmnP+5qoQH29A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3780760017;
	Sat,  3 Jan 2026 17:21:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACE4BC113D0;
	Sat,  3 Jan 2026 17:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767460895;
	bh=8g2Dw6uIOtsfBv1nVx2Z8gU4bkanGwDnGDrdnU55rzw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=rKn0f2nv/4eptbWKIhMpbZZH0epCG2kCFONoX4QJ6cafcoutg/m81j36MFfouCBvt
	 PJQW9M4kZWdgj7v6OUvVONOZKXpFTi5MebCmzPSnNwnmOAyCLBJi89PsEq1WPAZ2eG
	 oBnpFl7qdqq+9OF41dzv/hWg/MwHafUfn7douioQ=
Date: Sat, 3 Jan 2026 09:21:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: SeongJae Park <sj@kernel.org>
Cc: "# 5 . 18 . x" <stable@vger.kernel.org>, Jiapeng Chong
 <jiapeng.chong@linux.alibaba.com>, damon@lists.linux.dev,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 0/4] mm/damon/sysfs: free setup failures generated
 zombie sub-sub dirs
Message-Id: <20260103092135.103f1c29166ccb801133e6b0@linux-foundation.org>
In-Reply-To: <20260103002139.66559-1-sj@kernel.org>
References: <20251225023043.18579-1-sj@kernel.org>
	<20260103002139.66559-1-sj@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 04F80A0009
X-Stat-Signature: 5476sx9gm1tcznkeipj4yakfnygmf1jy
X-Rspam-User: 
X-HE-Tag: 1767460896-673333
X-HE-Meta: U2FsdGVkX18qiwQqzVtY28QdPmfzp/7XNFq01Qpdi7JBMJsajeF2tPn8HdKg5A3Gp9iMX+DAXDgesxHr9XF9gGn2A1kSW7yRI1d49AjsdquWBFzWnwFYw4DgqjI4IEl2k4X/te6XYiH2UFi2JuBiuRWLkDnTiRlNokm127rD/AlY5LfcVhiqqcE7Tnys05o3S72mQEeZLZmlBYkQbZ7L7DGSh25fjf5OVhDTEOzHPcUXN9hI9bD0xnj0XVDH+OZCk3L1OQ+QLULP53eMa0VOxFK1c3XO9eV7MflwResvDtxwA6myZta+YPYOJLsqWYY4w9KZ9fqs1HUNIqxmIAmI7JsCjDKdvhIAbubcVrJs524H7aucxjzfV+j2zp/3w2NIsCwMZ1q++SB1nZz4ryrq2POCiCL3CrvpMBEqMILsP7o/hM8ACvImHssY09/fdcWB8QURuL0PuZGVvEjUJegSZb+5LRVBMnnKkoBytyKWf68vviRDSlJDbOVkVgSDRl5PKs5ZiX9jwLuXrBV4I6dTfxlitrI0oCmSWDyCa7askuNhGvZRy1YyqlFZjpxVX/h0fMXKOM6iiFOKTg8IP6EM2Yqn5fBAYTejovHB1tw+Ywucf8lK/tp+ggTsLlLlESZMDbnbyrxTyWqgW4Vzh3lbMK+pPGt89SN3mYaO51DjOICAJq2HSux8RnBY/aViYRxCtI6KEM4dbnM0PZ0pKa5n+HLWnRwrdQoPCT7IkJ06GsZ5E1r76nlrFaZYwA5NkvwLhnNfStqZOe2Taw8uK2Haw7JTbq32pVthR1eQgFSpjauX3mnpDxkl0VYcz5R8GOW9lKkMckn4CMA++E8opEi68/y/kBq39jGukMaMvkw3tZbIoD7sBVr2Qh+jw8zkF94ZbhGowA8OxryQIZMjnHJgKI5HSDznjvsCG+Iif5NL08+ONnJQE2n8x4Qjt90LsNaaqaRZb+xP6dC2JhR52Y1
 f0rQtw7B
 Rkob10ib7aNq5O+jNMd3z+RYKYOiA3wHfbKOo93iZd4IdK95t/uqZVEP4GtMzt1Yh2eoCPl+qx2KjAxrWwa49YigiEvBiu0woslYayLS+SyehrpTi3BDCvcp3P8/6R4SMDSGzZ84OjrWM2RozSK/ify5K+g+6ZsRj3OMp5Gm+/1jQWroUI1HIblcH5g3B9MIR7oNY5fjeLkO1cYDsvkwblAqb0oNM9kaCdN+/h7AW2WjLJMk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  2 Jan 2026 16:21:37 -0800 SeongJae Park <sj@kernel.org> wrote:

> > Also, the setup operations are quite simple.  The certain failures would
> > hence only rarely happen, and are difficult to artificially trigger.
> 
> The user impact of the bugs is limited as explained above, but the bugs exist
> in the code for real world usages.  I therefore expected this series would be
> added to mm-hotfixes-unstable.
> 
> Do you have any concern at treating this series as hotfixes?  If not, could you
> please move this series into mm-hotfixes-unstable?

Sure, I have made that change.

