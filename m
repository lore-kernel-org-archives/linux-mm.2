Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C946EEF300
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 05:42:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B2666B008C; Thu,  5 Mar 2026 00:42:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07DB26B009D; Thu,  5 Mar 2026 00:42:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDF7F6B009E; Thu,  5 Mar 2026 00:42:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DAD476B008C
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 00:42:00 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8604059F6B
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 05:42:00 +0000 (UTC)
X-FDA: 84510913200.15.8421A3D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id C72FD120006
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 05:41:57 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sKE2+GFz;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772689317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3GuG6gsEK5RLnWM+ZFAkIiyCZi2bHsqo0ZKcjT7dz8Q=;
	b=g+040mxW6JM5UbYDoesqLdI2Vxvhs7zLZ5vQ3VkX4QewdmTMEfcIsbVSIJvqDb33PuP37W
	k2UBV63Wfg8LTSDiSPjjTGkKi6wmV+S1eLJP5f0Mv4wAIQzlg88iUd10Z7O3oyUmVMtX0v
	SSctoSuWdcy7etZzVH5A56xycliqnTo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sKE2+GFz;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772689317; a=rsa-sha256;
	cv=none;
	b=WeJ4K9H2bGDcYPyKwrxNxnxs2FAJjtkiUuv3ompvWH0RGZPDnUl27BtWdMP6Ig1Jtaa1ES
	sP9FVimVAGcYTzugOMmCCWbJs8ZTohDZ0YIk+Wpl3xQQ/aiLqCJXg8fQzIbxoGQtEP8gvr
	1vm4p2rH1saOnDyEsyqaPYfpCKuu52s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D79FB40768;
	Thu,  5 Mar 2026 05:41:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91A3DC116C6;
	Thu,  5 Mar 2026 05:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772689316;
	bh=DgFlkEpd+Giz7azYI3aH8In1nj1m0hihXdXV1v5sNvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sKE2+GFzGngud+gQkocJpXpqBvNwgVq1jzEcGVFdqB1KZH9SrWmb37OCM8LYPv6Wi
	 548W+kyO43sr5fx2RCqHXIbYJ3LfW3JbdrlaEQjJyfCDGG0VAqwcsz16kFk0DvSq7a
	 oLT/SfVr3oxItuJ+Wx25WZkVoL3Jd9pyp8o4KS8NoQ6n/1mJ2XPsVyrCzJ5ImzXYSh
	 MSMjPsJoyrDuhA0P6OnsknQr1FtElium5b+DZX1JYhB3/t13jSkR9cqFyFagVmTah1
	 /oE406NMM5+ulhq9Jt/OQE7Qj4OIHbEq1d9T+X4V+Tdn0amF/Tga8HznPpVC8tWVxg
	 iph12gwOfa+vg==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Quanmin Yan <yanquanmin1@huawei.com>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	enze.li@gmx.com,
	sunnanyong@huawei.com,
	Enze Li <lienze@kylinos.cn>
Subject: Re: [PATCH] mm/damon: unify address range representation with damon_addr_range
Date: Wed,  4 Mar 2026 21:41:46 -0800
Message-ID: <20260305054148.83837-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260131015643.79158-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C72FD120006
X-Rspamd-Server: rspam08
X-Stat-Signature: 69a7rgfd3o3jqcpx6py74eyjh4yozmt4
X-HE-Tag: 1772689317-828917
X-HE-Meta: U2FsdGVkX18ghWjg5CAWkkNt7nQCBgvV30t/gOHfQLfebOLGOhbSPderkRgsD+xknrKCtVDzHDEHc8ZdGSXWQMrxl+3UzllTCnHOKV5xCDMmgDczrLHuJ4XDZINKWbTBrhZqb3YWEX3xrS/UYNCLKHJ1RqCUiiF3Py7T2mlQUOD6NaYq7XSb3kw8XZiH8V1Oo7HW8bA7rag78Llu1J7pjoI8tkHWVQi2XDJITbObGAie6a9jfGQJwfrQZLYO5lMppF62WGHR0Nu3K0abTB69fbajOO/rCosof0VY9/l5vhqaJ4Hx8T0ZFY9LCHCi0YrUfcl1N6VoIZqySISyeEOGN1ni4Ne5OZhoYfCYzL2Ql35BBHwISD5fyxj/0xhlFaIUrGZUvTjdwIh15jkbVnBz1SUUHfX82joXcQmCM3eR/By1+R10HyypFQ5AS/6TqFyBxJNvcT07jMSewhT28qypR65tIU+Iba7v1/NLDR8Iq866tp+U2vDue9IZKg9T7jtVxugxaGfF5Jxn3lX/C8b5l6mYXPQMaAzPs81fK/P3gWixEwgr5K2G7cvsPCAk4kliYUhv3sXp4DwE5WVRh2G6RXA+o9eDhZlp+/WRETbVt3f0z6E1HYgjZhEh+hbjEuws04NRc20UMTvAMbbQa6DGh/A0ZdPtQ7h+ApiyMIKn9XAa8a/sYAGw/qgn4tVhm4D55BZMetIu+OCx5MfWSjRUU4Uab3qldSs6CyGHsMOyO2+6k9+jRICJjRohd5KJf3FinkNXCoqBreyfQ85dHADFAAkYIxjF3cSwySyVBmqliRisIYuHtEqAn/wlszas2alt71Fl+e3HK/Qzo8xr3NPmDxM+2bH1vHpDPFl2az0Fg8qO0Kqcc7+D61g4uAen3Ji5mpWjjxo9KVUVRu+0GFC8nyE18kjRjyoe42jaNLd003dReZdnRiFqDv50sBlZBZhNcPwLOmCWT7sS4k0yTxa
 sQOMKXxb
 gN09aiWsdwIqi2FFYNn38Dd5P51/9Q0fviYagyM4HtnucWJXlzy521MF7v2u1HWNRb5XUYD/w8eYbVkazr3KCzl754SgSrDHhfBAqVz1Fra5erQeMNRPdeiE5qIthr/KEkkIQdUcmyAl9CZcm8TITNcJgHa8alJSRnaUJUGHtAzSqroPJ8E9c1a78KEW6U70iWZX3ZhFEzKM5UgqYYUgA7RDfTS/q6km6xbdXJHZYcZUDdbuUnfOk5cgExcrNVxHyjAP+dt8QGMtzOK6r6aFCAoWRQ/0vrHvzSpF/ly+P2YqUm/+8RkbLMXzhfCLX5KQiS29hlLZmniam/IEzgTlEQgMskA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 30 Jan 2026 17:56:41 -0800 SeongJae Park <sj@kernel.org> wrote:

> On Thu, 29 Jan 2026 19:38:45 -0800 SeongJae Park <sj@kernel.org> wrote:
> 
> > Hello Quanmin,
> > 
> > On Fri, 30 Jan 2026 11:07:08 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:
> [...]
> > > Actually, DAMON only actively searches for the biggest System RAM
> > > address when the user does not set a monitoring region. In this case,
> > > we always reset addr_unit to 1, which essentially restricts DAMON’s
> > > monitorable address range to 0–UL. Therefore, the described situation
> > > does not occur. For details, please refer to commit [1].
> > 
> > Again, you are correct.  There is no user scenario that can trigger the
> > problematic situation in the real world.  Nevertheless, assigning
> > 'resource_size_t' value to 'unsigned long' storage makes no sense, so I'm
> > calling such things a bug.  Not impacting user world, but still a bug is a bug.
> 
> I was arguing it as a bug even though ABI users cannot trigger the overflow,
> since damon_set_region_biggest_system_ram_default() is exposed to DAMON API
> callers, and I was thinking a future caller of the function could trigger the
> problem.  But I now realize the API function is safe from any call, since
> damon_find_biggest_system_ram() is avoiding the case, by setting 'end'
> parameter of walk_system_ram_res() as 'ULONG_MAX'.  Maybe it is not really
> appropriate to call it a bug.
> 
> That said, I now think this as a room to improve for the readability of the
> code.

So, I sent an RFC patch for this:
https://lore.kernel.org/20260305053918.83786-1-sj@kernel.org


Thanks,
SJ

[...]

