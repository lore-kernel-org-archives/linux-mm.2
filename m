Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A276FC72C4
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 16:20:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0034C6B00AA; Sun, 22 Mar 2026 12:20:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF6126B00B1; Sun, 22 Mar 2026 12:20:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E339D6B00B3; Sun, 22 Mar 2026 12:20:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D16816B00AA
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 12:20:46 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9D4DE5B205
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 16:20:46 +0000 (UTC)
X-FDA: 84574212492.06.6F78EC5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 06B23A0012
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 16:20:44 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=x4Beti0b;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774196445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X7fgBcY62y2+z0ntENHSQX8cKlryLPgzGLc2SlGZrro=;
	b=00Xyj5TTChwjkFnmHJwQ0jQMmnYIR/bNxJyXphUltFHNoDh/vDFrgMv6R+Frc1h6TUQAFx
	4RtaADOnKGCdvNKGbgkrY8JvtLtBvUOWiO8XTn7HhxLI7F1d2p55PJ3QDdwByZLkP/XuJ8
	oJkaiwH0XU14zaCUnuEux7+u0XTp1Mc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=x4Beti0b;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774196445; a=rsa-sha256;
	cv=none;
	b=Trpz3l5cxAmyZScdlxFK+//fotIawhhub/jTFw6P+5/rx9NCkjl3POfQ7urVzEsLhp8xdA
	wUyZ/GR6LEK+8siiru55WnVJDjBpVYEmf6mawB5iWA+eM6+ERXh7gRo2EsqtxnVJVqkR2h
	Rb8gV2WlUkCSrksiNt48FB03iwR2kNA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 703DD600C4;
	Sun, 22 Mar 2026 16:20:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C42C1C19424;
	Sun, 22 Mar 2026 16:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774196444;
	bh=dU2o8wRx1HOs7mgfEPnSerwmS4CS6CKsYEE58CKSmrM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=x4Beti0bAIFXJZCsIQLIajgVFAzEa0qdtKEWq9THzOedt0ZqKENKQ5iMKA3gbvAEm
	 RJZA3LZIGvQz2IJTEJIH0cWxdzCRELUFVSKoW0dQbQO0FeEODCuGQ5yWRN6RruagQi
	 RshVPIalu5SMQMFk/KlrdoeSCAEzf7Olx3lWiqEk=
Date: Sun, 22 Mar 2026 09:20:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Carlier <devnexen@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, Qi Zheng
 <zhengqi.arch@bytedance.com>, linux-mm@kvack.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/memcontrol: fix obj_cgroup leak in
 mem_cgroup_css_online() error path
Message-Id: <20260322092043.2c411821c2b883ba86c7cbd9@linux-foundation.org>
In-Reply-To: <20260322080142.5834-1-devnexen@gmail.com>
References: <20260322080142.5834-1-devnexen@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 06B23A0012
X-Rspamd-Server: rspam08
X-Stat-Signature: kihztd7er9ryxijy5ydjktinciey79gt
X-HE-Tag: 1774196444-389293
X-HE-Meta: U2FsdGVkX1/6EhoZsdIOTrmZjXffAeNBSotCNtmyaLloQXu+57lKbUgBvMnruvzuaVJZmUp26k01bJcH8Yn0JGUCsXh0285+nfvYaVY6EJMbp+JPdwHBp5dRrypROagTuXScBvdYqpcgbWxIjR9rbDUpUAS2laC3cLVn++0yjQKo8Y/INoqyxTA70zVwn5iZN2E7GghgBeMG/HDCbFiL/ZeDsU2kUgijXhETbawW2Z4JuIDfBzb2qXmDPco4a604B1VPvHhCXRm9PmNJX/0cZzLz0GkFnNmje4zgKjNVU6VrIfPq16dhXi4C19YpSuUMho3hHm8dlRSs4KRmtGj7x8haEhICRn0ksndAk2fIHKxNoJd8gLuo2VYW/lrNyIwRrrmY6cRGS9jEOPL2VK/+NQwI4ESDDg/ucXwEMEcGpz2wp7K36CuIioJ3kAan+GIpOAU1eqLIHVgRICm9CC/5iwefc/M/R94xxz1v66xuFITalj3dWZb8KCYtsr0Z24YXu3V1v2Hu9aO8eycBEO1zLST/Z1RCaK/Cy0n9YerYdS2g2AjtNF0sJvEOSVl6IZnOlu7GhSb1JcoF22SPGDhw+hqbGJb8bNeeBzNpBL7Bm0rMdB6Np/NozIqtZqzoqY1I5/ZqAMiQroQZBpkyDHcYZYvh/vs5PjWg1FuNGHtUCWGOVt08CId4eVVhL6kDEcDHgrux7tLZQAm9H5BvW7ZzR/MhThdHboWr5826+73WxgF+BY4m8dJP9NXDX7iwXFvRgJBUyDc3oytw1cZ9rFBnp+qrBYPZaZgO9ka/0oHmjhUMgfulDQkZltIsnRMnz7TTNR5j5n4f085F38UVBdqW6OqrgOohDJHvF25by38trVnR1zadam3SxDyJFbQBZdpgjiKQ13b5IkAcfAUYgEHrVsELwo2hiqnvM5Y14aqOhDFDd5vrkBot8QdTvCQZSC5pb8OozGNJk3T5yJM6pr0
 pw6MWpVv
 SKUK7gc3bImhtfH3gie5/3ajwP3OymOty+Zs15OyE+MLp9or5y3gEZnUcVg/TaJ2MTxhvFFlUapZg6uzmY5bfNyCetn+NkKlFccFpMJvBQg/jp9gIPvZtI7VHgvHgGm2g71wmeC1PMetAGNAgClSyz3DEtj2QO2ym3cWpwjsa4OftCdMqkVzh0wKBbtNnETTLHGulwDxSh2r9WoSWWlCvrcJdJNpjSr7PyAQgrQbce5IoRmxvDbzLbzb+MlLXKfkJW94HSIeB1BlfxbLaBykNG7jfKQ8lFigkc2EyHW/vscM4Qq97E+Qv1v/z7YPhlNzJHTSuZj73ucJARKHonANc51PCH6rorEEojv6FuBnUMhyjz9HDyvC/ZLHSWe33wzcrvTn1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 22 Mar 2026 08:01:42 +0000 David Carlier <devnexen@gmail.com> wrote:

> When obj_cgroup_alloc() fails partway through the NUMA node loop in
> mem_cgroup_css_online(), the free_objcg error path drops the extra
> reference held by pn->orig_objcg but never kills the initial percpu_ref
> from obj_cgroup_alloc() stored in pn->objcg.
> 
> Since css_offline is never called when css_online fails,
> memcg_reparent_objcgs() never runs, so the percpu_ref_kill() that
> normally drops this initial reference never executes. The obj_cgroup and
> its per-cpu ref allocations are leaked.
> 
> Add the missing percpu_ref_kill() in the error path, matching the normal
> teardown sequence in memcg_reparent_objcgs().
> 

Thanks.  Some questions from the AI reviewbot:
	https://sashiko.dev/#/patchset/20260322080142.5834-1-devnexen@gmail.com

