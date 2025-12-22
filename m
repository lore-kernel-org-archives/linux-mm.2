Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87354E674B5
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 15:21:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9C746B0005; Mon, 22 Dec 2025 10:21:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E49AF6B0089; Mon, 22 Dec 2025 10:21:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D770A6B008A; Mon, 22 Dec 2025 10:21:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C2FF46B0005
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 10:21:57 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 56106139911
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 15:21:57 +0000 (UTC)
X-FDA: 84247472274.07.AB9B5C3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id BD55980013
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 15:21:55 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OpuhZYnD;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766416915;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZXzYiTcJNpvEqcK3xLIXTMMk9jnymOhtNiM9uwN4gms=;
	b=ZuPaUy3t7evPt3aY+FqO5XhyZHbWzhT1pv5akYHmpfX1Tp8tyG7PeyOKP0VGKNl/YPg+Ub
	hRNdt+EyKXg/M7+MdFvYO+88rSkR7wvhClrWa/Lj3695WHpRxsr7teNFPIJSk1G2LLUlpT
	8x7sO8OUDL6gVRiDBu84fuipE/m5JcI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OpuhZYnD;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766416915; a=rsa-sha256;
	cv=none;
	b=defaLe+xijKk32fprGKa3s/XonZDTJti/yiNL2MCzZ255kBPjeMkVhKlSKInGzPCKblPBU
	vJ42Gzd4IvHehvgtzHg/feKOmzlm8uf1xZjAd9dWPqkhBra9BNUeJy4h45PYg1nEntNd8u
	Dje9q8DBrGRhjN7GRzzaKJxaf71DiQQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id ABFC943C12;
	Mon, 22 Dec 2025 15:21:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70806C4CEF1;
	Mon, 22 Dec 2025 15:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766416914;
	bh=p/o1StfdPmpdCYRBTasptwpEFdmjcQVICrxmpQdm+aE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OpuhZYnDquRSj38GLzsReaiVJaQU5IHBeW1iG+A8TOdjqph8Dwu9NvK1fQ5pnI3oe
	 OSOZ/p97KA2vAR7qrL5+C08f4vq0gHhPT2LkeR5ESbsu+u8KsSH0k9nkMnLmyUTGmT
	 vqGnS5TzSXdX7RueTaoOzvh1Maoeh2YF5xsKym3Bqnzfw+lgN+GKrHhtF9HQO+DuMO
	 FQzIVom4s/arxMqXwGaTGw96EnhKPsrm/CgTSkbQnJC4x1GQsnAomBLU+eN9JLDkLK
	 hvcSCu5WuFEeZsPh60Y2qI3N8INFJ+4tGDMaAqAYIkW5urkyEK77zs//M9x+VapWBt
	 8dQImec/7NKSw==
From: SeongJae Park <sj@kernel.org>
To: Enze Li <lienze@kylinos.cn>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	enze.li@gmx.com
Subject: Re: [PATCH 0/2] mm/damon: export symbols and introduce prdm module
Date: Mon, 22 Dec 2025 07:21:45 -0800
Message-ID: <20251222152147.87398-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <638d4c03-f7c1-4ba9-801f-18c860960eeb@kylinos.cn>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: knnowxxkq9eiycab4mc5dwnh9597t864
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BD55980013
X-HE-Tag: 1766416915-345666
X-HE-Meta: U2FsdGVkX1/cChUoAral1zJklKu2/KGJhSs3C7p82BbWmmeQkFMfbEbp5QReA65AiZIQkAigeIIuKqRNcQ4btQdSqWN3g5ZjI3JsrxGZn1Flr9V1C0silQTj7WTw9Dxr6S0C6HMkn8XQvvAU41HWKcgOqiMf3cj7u7XI6mL9buRx1YN6qOTJgnvofKXmsrkI+jsX8FB8qpIux/AwzqUvdvwyT8NX2DuBbL1ppjMi9s5Hs2VEhc4tQzS0eNJPQPXmz3lK8wP2YBwaHHloJ4d+nxzecHkSKGllnMw/QyHlC1KczMyWFfAjlY2zfgwPyKc925e7GAGLpqMdeBeUnzxiS2sNst8WyEV22un5PgUqJ+n52FlqRmV4M58hE8d/BLhBf5NHwliV+UADZ5vElzzZbOhGg6FCEbgLxzL32E5hZRoZ3vGMueCo1Mdf2lCVpYN5I8mXsNqojiYj2jWL/IlquFk6GPw3oOMuhl3/9tld6dSRz09gCcrSiIvJvonL+q/rg87QJpNXN8/YOUVsf+a7xYMOob4KhPQc/A7x+2/NqzzasIOoQhaZAbasOrz96veYVG1Ul4QtOP+l4TpmAfDeZC8M3sCSoPbDdZAmii5PjGUSLpDSbklerI9vPx3CytL26ptfIeC6YZGi3Ic/5JrRFtus1I36lu08NkBzP4LMgGUa1D+eJwLQaootnSbsKdgO6nzjjB9tKeoNsaFoHLlzHJRjPyUJqmKXW8c2MT2oaZGEHv9V+KhgGGHf9XwtO3IBYmHHirDXIz5qSdiLCcxmx3lYusJBt0tvv/M8qxlW5SZKDBUCMft2k0vKC7nFnGiyOM094AFNHtt+O8BfmapEeBijHdIoXAStVa+B3gOlIzPf2o8Kvlp5rDsLEiApKWkKX/CCN80pls8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 22 Dec 2025 15:08:01 +0800 Enze Li <lienze@kylinos.cn> wrote:

> Hi SJ,
> 
> I appreciate you taking the time to provide such a detailed reply.  I
> have a few more questions.  Please see below.
> 
> On 12/19/25 7:46 PM, SeongJae Park wrote:
> > On Thu, 18 Dec 2025 21:46:37 +0800 Enze Li <lienze@kylinos.cn> wrote:
> > 
> >> On 2025/12/16 07:16, SeongJae Park wrote:
> >>> Hello Enze,
> >>>
> >>> On Mon, 15 Dec 2025 22:20:55 +0800 Enze Li <lienze@kylinos.cn> wrote:
> >>>
> >>>> This patchset makes DAMON's advanced memory management accessible to a
> >>>> broader range of users through two complementary enhancements.  First,
> >>>> it exports the necessary DAMON core symbols to enable building loadable
> >>>> kernel modules.  Building on this foundation, it then introduces the
> >>>> 'prdm' module, which extends the concept from the DAMON sample code
> >>>> (prcl.c) into a production-ready, user-friendly tool.
> >>>>
> >>>> The key strength of this module is its out-of-the-box simplicity: by
> >>>> simply specifying the PIDs of target processes and enabling the module,
> >>>> users can concurrently monitor memory access patterns across multiple
> >>>> processes and trigger proactive reclamation automatically.  This
> >>>> significantly lowers the barrier to using DAMON, allowing system
> >>>> administrators and regular users without deep kernel expertise to easily
> >>>> apply sophisticated memory optimization.
> >>>
> 
> <...>
> 
> >>
> >> Before developing prdm, I had considered implementing the same
> >> functionality based on DAMON_RECLAIM.  However, I gradually realized
> >> this would make DAMON_RECLAIM overly complex and less
> >> user-friendly—especially given its existing module-specific exported
> >> interfaces, which could confuse users.  This approach would create
> >> significant barriers to promoting wider DAMON adoption.  Consequently,
> >> building upon the prcl sample became the preferred choice.
> > 
> > I agree DAMON_RECLAIM already have no small number of parameters, and adding
> > more may make it look even more complex.  But, users may use only parameters
> > that really need to be set for their real use case.
> > 
> > For example, if we implement virtual address spaces mode in DAMON_RECLAIM, I
> > think we can simply add target_pid parameter that works very same to that of
> > prdm.  If it is unset, DAMON_RECLAIM works in the physical address mode.  If it
> > is set, it works in the virtual address mode.  Adding just one more parameter
> > that doesn't break old usage doesn't seem that complex change to me, at least
> > in terms of the user experience.
> 
> This should be viable, though it will take a moderate amount of extra
> time to develop.
> 
> > 
> > As I mentioned above, yet another example would be using
> > DAMOS_FILTER_TYPE_MEMCG.  For this, we may be able to add a parameter for
> > describing the memcg of critical processes.  Again, adding just one more
> > parameter that doesn't affect old usages doesn't seem too complex changes to
> > me, at least in terms of the user experience.
> > 
> > Meanwhile, I agree adding a new simpler module could make it easy for new
> > users.  But, I concern if having two modules for DAMON-based reclamation will
> > make users get difficulty at finding the correct one for their usage, since
> > they may now need to compare two modules.
> 
> Indeed, you're right.  From an architectural perspective, having two
> modules forces users to spend time distinguishing between them, which
> can cause confusion.
> 
> <...>
> 
> >>>
> >>> And, even more importantly, why it should be a loadable module rather than a
> >>> static module?  Do you have a specific use case that requires it to be a
> >>> loadable module?
> >>
> >> Yes, loadability is crucial for operational flexibility in practical
> >> production environments.  Beyond some obvious advantages, I would like
> >> to highlight a key scenario: system administrators can load the prdm
> >> module upon detecting memory pressure and unload it immediately after
> >> reclamation is complete, thereby eliminating any overhead during normal
> >> operation.
> > 
> > I agree always having prdm in kernel is an overhead.  But, I think the
> > overhead is not meaningfully big.  Also, as I mentioned above, my intended use
> > cases of DAMON modules is for cases that willing to simply always use the
> > modules.  If runtime controls are essential, I think using DAMON sysfs
> > interface or DAMON user-space tool is a better choice.
> 
> The prdm was developed based on samples/damon/prcl.c.  Would it be an
> acceptable modification to port the multi-process support feature to
> prcl?  Does that make sense to you?

Yes, that makes sense.

Please note that the purpose of sample modules is not to be used in the real
world products, but just explaining people how DAMON API can be used.  In this
case, I think multi-process support feature can let people better understand
how they can use DAMON for multiple processes, so I think that's good to add.

> 
> > 
> > Someone might argue DAMON sysfs interface is unnecessarily big compared to
> > prdm.  But, I have to ask again in the case.  Does the overhead really
> > meaningfully big for a real world use case?
> > 
> >> Furthermore, it supports zero-downtime updates, meaning that
> >> improvements targeting prdm can be deployed via a simple module reload,
> >> avoiding costly system reboots.
> > 
> > So I'm not really convinced at needs of prdm module at the moment.  But I agree
> > your above point is a good example advantage of loadable modules.  Also there
> > were private requests to support loadable DAMON modules.  No one among those
> > were for real production use case, and I understand you are also doing this
> > work for imaginable use cases, not your real products.  Please correct me if
> > I'm wrong.  But as the request is repeated, if you willing to convert existing
> > DAMON modules to support loadable modules build and expose required DAMON
> > functions for that, at least I wouldn't oppose.
> 
> Thank you for your feedback.  I would like to try it out.

Looking forward!

Please note that there could be objection from others, though.  In the case,
unless you have real world usage of loadable DAMON modules, I may have to agree
to the others' concerns, like I had to do so [1] last time.

[1] https://lore.kernel.org/damon/20231205172307.2310-1-sj@kernel.org/


Thanks,
SJ

[...]

