Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBBE7606A321
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 11:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GqzS3vcn
Received: by kanga.kvack.org (Postfix)
	id 0963A6B05D2; Wed, 11 Nov 2026 06:19:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01F526B05D3; Wed, 11 Nov 2026 06:19:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E77AD6B05D4; Wed, 11 Nov 2026 06:19:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B30D76B05D2
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:19:06 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 46AAD1C2DE0
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:19:06 +0000 (UTC)
X-FDA: 85422591492.30.B77B9F4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8C5DF2000A
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:19:04 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GqzS3vcn;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794395944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qYip/S6YR8HP6EPMfD+DO9PeevjFwxYNpr2ap+wiblQ=;
	b=FBFPxmMdYLS2QS7sgyhXFTCoopKWszRJ5tyhY6TkXPTB2492IvUZXWyXPOrDvQWxgJN5Wt
	2R3Hr1GECvHp6JOh1bDk9eamuKdLisXK074k+IwUoe4UUC4hkMO3+TIW9mmXUvHhKUxvAx
	FSGD+Rs809KRfLX6vDWZYNS96BA479I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794395944;
	b=D7s0OHcmlLrCSVgchMJeelbUZ8bUt/6xwIntEY+W5PDaFwKzmqOiZ0Y2GO2yqfd6jKsdXj
	LtKUSB1QfdxbJnL/1w2dwSUGjfpRacANH0Fp7ULyZbX9ElSsYBnKeHOAD6D1ev5IzlLiSZ
	JPlrg5m6YMXpNg0rTEybgEZNGIYeUHM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GqzS3vcn;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D9F18438B3;
	Wed, 11 Nov 2026 11:19:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 333081F00A06;
	Wed, 11 Nov 2026 11:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794395943;
	bh=qYip/S6YR8HP6EPMfD+DO9PeevjFwxYNpr2ap+wiblQ=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=GqzS3vcnCAk7RcM9m0TvajMcoWIE5tsCDTZDcdpms/zdOpMd0QJB+8k35zijIKLZ/
	 9zMZaltBrIBk/p9iRKmL+q19QJxxJSkV3ewQwBIpTKZBwK9WP2DepzICMR5JH/Rfgb
	 cxRWRVFpuNsMg1wugipdX3i36sBiYPJU+Km+w1Sh3SlIyRUAbg1+kNi0/VRpuax7jn
	 kap/zpwjdpfDyIKPvnNqMuePwSyKJVfA2mFNJO6kaLwq8EuveY34RPGKhFDGjI5eJX
	 fjk3pYjwjTrr8JpqdZaWbLH3WZnmoPAcxQUEL9vzgasoinjwD/Iy2Z5AlIfhdD6xt4
	 GAckGa/L7Ow1w==
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v5 5/6] liveupdate: Add LIVEUPDATE_SESSION_FREEZE ioctl
 to freeze sessions early
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-kselftest@vger.kernel.org, rppt@kernel.org, shuah@kernel.org, 
 linux-mm@kvack.org, skhan@linuxfoundation.org, linux-doc@vger.kernel.org, 
 vipinsh@google.com, linux-kernel@vger.kernel.org, corbet@lwn.net, 
 dmatlack@google.com, kexec@lists.infradead.org, pratyush@kernel.org, 
 rdunlap@infradead.org, graf@amazon.com
In-Reply-To: <20261105050053.3063001-6-pasha.tatashin@soleen.com>
References: <20261105050053.3063001-1-pasha.tatashin@soleen.com>
 <20261105050053.3063001-6-pasha.tatashin@soleen.com>
Date: Wed, 11 Nov 2026 13:18:40 +0200
Message-Id: <179439592041.425130.6098227055493441109.b4-review@b4>
X-Mailer: b4 0.16.1-dev
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8C5DF2000A
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: ae3391wj6ufbcub9jd67ynqn43b41cn4
X-Rspam-User: 
X-HE-Tag: 1794395944-833196
X-HE-Meta: U2FsdGVkX186j+m67yd/h4BHM7x/jG9/FDcdwINPJKNiYVK4gsA1PgaKl7YohRziJUCiVRFeEevUOdnBlJTL4k8jkFUHGS30r/p7kgS/e5Cbe8Wm8MdbOIhgpliVWmKsDEONRVk7YUGDow9Iv1wYOUztdkpcmIgwO39nIdJ4dkITRTwLg4/0JP0J6R0Ip99Vv9trBCuA/mcE8kszOkarKQjhHzgKumqim/rXvkmKfbDTKpFBQWXwXW39Odm939Nf/w3XoWbDWttdU1F4ZWJMMPWVP5vv/yoSd4DEV8uGCKBhUiAHZCAo8zbv7llsbNQF4TtUJdD0GTa9mntqVc8VaheSZvAPb+EDlqdlSR+XqKRpzSyhpCIhC2/Rlgcju6RVmTmE/40ma+4WdczBPLRjXY82x2Z2rN8vtX9m0It4f7S7tSMrySVg6uQ93at03IHVElWh8X7qRNP/G4YxzxJV0U1VYcnf/GRUQLtEnh5DHT6SKCX1E5oSrJdCcCWHMJYNYPfCbYiD/VXHhQd6RPOf0HdyINMsbQxtoQeryuGttPOaDVQw4qOLgBY+KUqkIRMKZuKxA1tI81tuDK/o81Uawstt24wSOZkAELAKLRqJ+tx+Mop5nc54aKs+YAlfTbZNhi+8j6SCOkN8RgZm+eDECNEbLbKkbj0HNn4dLJ2CCJG0lLMQc8ULcduK63Udx+VX0w/6Bcs8oPBK+Wi1/3wOP9OI7Up9ejyTAsBN5yQ4/wEbh4MeXl+/etYVxFq9/dh8nYx31dLEJjNAjm5WCyGvprFbtXSJAoVt5EBDmZN05E7k5jXeHd2CtzHRlmJ4BeAT7Snmdsxe/uvu3fVwE+IPdg4bHY9l5KMF4gaP53vW/PgUUVTpymUl0gD2kqh8R2QYePB/XV41SslwdQ/pOnVlrKHYEWsLpviONbSABzY2g6VlyyqJVtdCwD4492ZNZFIxD1Lh0TZcf4HZMrY+LQs
 aAdai6ph
 HEOxE7edFkUq70B2q/JQt8I+w5fYfKw1XITwG0Iez5C4MprI/52Ni8qT0KaNOElsJ0JiYpma3fkrjIkUS/MJl0OtyS54CO5LK/Pii+4/OmFE/14wzZ4V/ucZcLhEuJcgiwZqI5MiO2XN3VfuvnvgeX6bCS2Tm/vpncxGah8FWFJ4qXXIWDk9hDS4r0hsahQU+oslZmXHvEzRP8oeTpDJz3eVFRt42ZpZpo7z1ZJiFhUgBS4whkKmqwrdAagofdh3OLITHv7Lvd2tLl+Pneqam9SC7bmI4+gr3+bq/3sQ7MC6lKOQwnU23Os6RD0sgszh3iCKX7xjVAaapk4M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,

> Currently, LUO sessions are frozen automatically only inside the
> reboot(LINUX_REBOOT_CMD_KEXEC) pathway, where luo_session_serialize()
> iterates through all outgoing sessions under global write locks and
> freezes them serially during shutdown. On hosts running multiple
> workloads that quiesce one by one ahead of kexec, userspace needs an
> explicit per-session freeze point so each session can capture final file
> state under its per-session mutex as soon as its workload pauses.
> 
> Introduce LIVEUPDATE_SESSION_FREEZE on session FDs to freeze an outgoing
> session early. The ioctl runs .freeze() across all preserved files in
> the session and serializes their metadata. Once frozen, no additional
> files can be added to the session, and subsequent freeze calls return
> -EBUSY. Freeze is only valid on outgoing sessions and returns -EINVAL on
> incoming ones.
> 
> By default (flags == 0), session lifetime remains bound to the session
> FD: the session stays frozen while the FD remains open, and closing the
> session FD before reboot (for example, to abort the session or on
> process exit/crash) unfreezes it via .unfreeze(), unpreserves its files,
> and reclaims all resources. During kexec, already-frozen sessions skip
> the late auto-freeze and are published into the outgoing KHO subtree.
> 
> With LIVEUPDATE_SESSION_FREEZE_COMMIT set in
> struct liveupdate_session_freeze.flags, the frozen session is committed:
> it and its FLB dependencies are immediately inserted into the outgoing
> KHO subtree via luo_session_publish_one(), and the session survives
> close() with full ownership retained by LUO until reboot. Once
> committed, closing the session FD (or another session failing to freeze
> during reboot) never unfreezes or unpreserves the session, allowing
> processes to hand off preserved state and exit prior to kexec.
> 
> Update the uAPI and core LUO documentation to describe session freeze
> and commit semantics.

Please teach your LLM to use shorter paragraphs, focus on why and don't
list every implementation detail, but only important ones.

> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> ---
>  Documentation/userspace-api/liveupdate.rst | 30 +++++++++
>  include/linux/liveupdate.h                 |  3 +-
>  include/uapi/linux/liveupdate.h            | 46 +++++++++++++
>  kernel/liveupdate/luo_file.c               | 54 +++++++--------
>  kernel/liveupdate/luo_internal.h           |  7 ++
>  kernel/liveupdate/luo_session.c            | 77 ++++++++++++++++++++--
>  6 files changed, 184 insertions(+), 33 deletions(-)
>
> diff --git a/Documentation/userspace-api/liveupdate.rst b/Documentation/userspace-api/liveupdate.rst
> index cdd74627ab75b..d36537c556ccb 100644
> --- a/Documentation/userspace-api/liveupdate.rst
> +++ b/Documentation/userspace-api/liveupdate.rst
> @@ -22,6 +22,36 @@ change, so compatibility is not guaranteed when kexec rebooting between
>  different kernel versions. This is expected to change and stabilize in a future
>  version.
>  
> +Session Freeze and Commit
> +=========================
> +
> +By default, LUO freezes active sessions automatically inside the
> +``reboot(LINUX_REBOOT_CMD_KEXEC)`` syscall path, and an outgoing session's
> +lifetime is bound to its open session FD: closing the FD before reboot aborts
> +preservation and returns all resources.
> +
> +Userspace may also freeze an outgoing session explicitly ahead of reboot via
> +``ioctl(session_fd, LIVEUPDATE_SESSION_FREEZE, &arg)`` once it has finished
> +preserving and modifying the session's files:
> +
> +- **Freeze** (``flags == 0``): Executes ``.freeze()`` on all preserved files in
> +  the session under the per-session lock (allowing multiple sessions to freeze
> +  concurrently), while keeping session lifetime tied to ``session_fd``. When
> +  ``session_fd`` is closed before reboot (for example, to abort the session or
> +  on process exit/crash), LUO runs ``.unfreeze()`` and ``.unpreserve()`` on all
> +  files in the session and reclaims all resources. As long as ``session_fd``
> +  remains open, the session stays frozen across any failed ``reboot()`` attempt;
> +  at kexec time, already-frozen sessions skip the late auto-freeze step and are
> +  published into the outgoing KHO subtree.
> +- **Freeze and commit** (``LIVEUPDATE_SESSION_FREEZE_COMMIT``): Freezes the
> +  session's files, immediately inserts the session and its FLB dependencies
> +  into the outgoing KHO subtree, and commits the session so that it survives
> +  closing ``session_fd`` with ownership retained by LUO until reboot. Once
> +  committed, closing ``session_fd`` (or another session failing to freeze
> +  during ``reboot()``) will neither unfreeze nor unpreserve the session,
> +  allowing processes to hand off preserved state to LUO and exit prior to
> +  kexec.

Too wall-of-text'y, too much markup.

I'm stopping here until v6.

-- 
Sincerely yours,
Mike.


