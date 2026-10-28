Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0B81606A31F
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 14:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JjrDrAWL
Received: by kanga.kvack.org (Postfix)
	id CBBE26B05B0; Wed, 28 Oct 2026 10:08:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C93DD6B05B1; Wed, 28 Oct 2026 10:08:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAA676B05B3; Wed, 28 Oct 2026 10:08:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9B12C6B05B0
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 10:08:16 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3A4471A03D0
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 14:08:16 +0000 (UTC)
X-FDA: 85372214592.19.5118EB4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 64915180008
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 14:08:14 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JjrDrAWL;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793196494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qRZx+uCzjDXnaggv9NA2GtraDXmEHwAiGFLHgafIj5E=;
	b=YajEkH7QYq06V+gvlJ+bbRihybchrrQmZnC8x8fGPxXXgw/BPM2LCGz/wl9mANcfosc1Gy
	mJLzuFCVPu/EnnYfcxb5sLsV8A2ClpjkPr3URDU86pEH6AHKdrnaSL4iksoOzlYH1Lonjl
	/F3mX6umxWZEZjbVE9wjjLpFcLizk+s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793196494;
	b=EYWtWG+pr3eTaLfBBN47NHYTajXvicfxHXJIOvUaDea29Y5euhbP/mag7SW9Brm2Va+Cq2
	G2dUITfl7RW8/DfDyT/gfwJFMRZ1hSeZ2dEDt4jdj2pX5skoT7oMBPsigkOTRuqFUfji9d
	4myijK0GilgZ599R6XAoGP/2CNu+9WQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JjrDrAWL;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D0EBC43890;
	Wed, 28 Oct 2026 14:08:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E72C1F01825;
	Wed, 28 Oct 2026 14:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793196492;
	bh=qRZx+uCzjDXnaggv9NA2GtraDXmEHwAiGFLHgafIj5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JjrDrAWLTDPsAUrZN+XPbqZ7cfing5M98T3onac6DKid6Qut5cw1320CJkeX4nD0u
	 Ukbu5Ugwyx1bjDn0dOwA1Ev/LBOIW4TE6G48P/ZRhfHcx47w9Wg8NhhyQdAtClTw1/
	 dXiquSva30A28GxPycrfHJoY9YBvSHy4ObLysaizJdTgYa5VRICt83OZF9bIxisNkU
	 LH2lkfoFucpK6GUtB+0kkk+JB0T/e9v04zuEgNt9JxcDAfPQrFxQkpads/0BNR3fQx
	 K5HcZ+O0PfwyAkuRuGn3VgoaRWCZK1cqd0h3/Dq9zDyvaCYYchTRFqcUxdFr/EkL3I
	 2ysaDSNlGZltw==
From: SJ Park <sj@kernel.org>
To: Jinjie Ruan <ruanjinjie@huawei.com>
Cc: SJ Park <sj@kernel.org>,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	rdunlap@infradead.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Docs/admin-guide/mm/damon/reclaim: document how to disable watermarks
Date: Wed, 28 Oct 2026 07:08:03 -0700
Message-ID: <20261028140805.159912-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <b0fb80cc-4a0d-4612-beef-bf2fc398f06e@huawei.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 64915180008
X-Stat-Signature: wjpuwn8d14o7a3estyjn7misq3e69a4w
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793196494-40160
X-HE-Meta: U2FsdGVkX197j5zOzWSAqmfGx84OKsxlvYETgof/kqCfPQf3vTJN85o+2tDzwqMQAjl3quPvltzwA65Lp4emir8DdOaXz/8T3nd37Jv95RmPzw7c9OWJrIwoyrwcD50SYizBfda+gUQ/BsnsF7AmQJOMbtISuLs2olAO1Y75NjOEJw45dJFto7IE175lSAQIYcE+lFbO+bGkGtoH6ziVMJVgOS9hSpxvwW9ni3T1Zs7I0HaVxlMJLX86MaHagogosmUAtsFltaMiEmxMRrYYmHtSsG3hKuDScqbovv0WgTo0TZbOXZdaYY4PvxJwBrLJd1sAe9XtOrX7d35Qv4lz0bH4Mwq8kUIK+7tN68u3yf8gjlsfKC/XEvd6miLtqK5kugQUwn4/sBauDhbZ45ljKYTsdOyOOHHw/Zi86wROSOxlRAodb4k/Iea+6JJr8zuLe7PVn7OtQbtlDSUZbXe8UH+tmrwz54FJDNN0r5V/uQK88b37HLFExO5j60CUa601o66UUizW/wecivvqZ0UlHltlgcrwGlSChIa8BLEuPfBYs4eFlcz8bVNPX/TFVQiMumwl7+lREZ4LAYJOCchxkhVeJJhZvYSnSWcds1TsphdCkUV3ie/txKai+TO6ZQFG91wfEmWkMecclEM5SjeJ6/Vx5Pk4+IvHaFO7Gm45tOkP6MOzpA6huEZ5wZWp8Dkyjb8IHS/idEn/4dqcWQfvvr/m7Vhlv6qTR/NOP61X+CNfichkfziZs9GDRbyoHwwZdzxY2Xr2qqCBfI/asssO/lofJX65nzZjvGJkW7T5yxio/1GLZbUCsiqzeBC5gB0rY8DiQuVvPzue8MA8UbC7n0n4fzlx/EChOlYgapUFTmxhv9MV9DbQ9KD/dPW0ed30pGCJKmjqLhG1Sx3CE4k/O8/Muq1/uc0ylPxr1EC7mwc3qIrcXu4SZPDemhAQbtm6YL7eHYwy9+jqLBl1iCJ
 CZ6Y34Sq
 0DgrqOcuZhPjNfzGwGXr8Y0JD3Y3uIr/O8UzpAjMGW56VaX5Zc5hik/lI1+Qrczw11YmWYJRrOjAAc4pz2ZazQ2TdyeT3RS4vhgJ9SpVU2daO0rSMTNtCXpcbCTyg4UVJqSGDH0aRuaP1vzoiCDzvH6qnWj/HUlvknxnXwqUzvRmdY+cKGdrDZ9GaNDxYPINHVUFscr054w6yougHhSTJDmFATWWsJomHV6mnZnZRmf/EGjYuTlwSyCDFf4ZGrv/VbXhV6Sz9+kTAMA1Cj36QLOMKJ/CO3+5fc4nuQT2Wy39t36BR8ryGuLaj1apLqWAE9XnD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 28 Oct 2026 14:09:39 +0800 Jinjie Ruan <ruanjinjie@huawei.com> wrote:

> 
> 
> 在 2026/10/28 13:35, SJ Park 写道:
> > On Tue, 27 Oct 2026 22:24:24 -0700 SJ Park <sj@kernel.org> wrote:
> > 
> >> Hello Jinjie,
> >>
> >> On Wed, 28 Oct 2026 10:36:28 +0800 Jinjie Ruan <ruanjinjie@huawei.com> wrote:
> >>
> >>> DAMON_RECLAIM runs its scheme only while the free memory rate is
> >>> between `wmarks_low` and `wmarks_mid`.
> >>>
> >>> But some users want to reclaim cold pages even while the system has
> >>> plenty of free memory, and it is not obvious that the existing
> >>> watermarks parameters can already do that. So Document the setup.
> >>
> >> Thank you for this patch!
> >>
> >>>
> >>> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>

Reviewed-by: SJ Park <sj@kernel.org>

> >>> ---
> >>>  Documentation/admin-guide/mm/damon/reclaim.rst | 7 +++++++
> >>>  1 file changed, 7 insertions(+)
> >>>
> >>> diff --git a/Documentation/admin-guide/mm/damon/reclaim.rst b/Documentation/admin-guide/mm/damon/reclaim.rst
> >>> index ec7e3e32b4ac..23fede7d1cdb 100644
> >>> --- a/Documentation/admin-guide/mm/damon/reclaim.rst
> >>> +++ b/Documentation/admin-guide/mm/damon/reclaim.rst
> >>> @@ -193,6 +193,13 @@ DAMON_RECLAIM becomes inactive, so it does nothing but periodically checks the
> >>>  watermarks.  In the case, the system falls back to the LRU-list based page
> >>>  granularity reclamation logic.
> >>>  
> >>> +To keep DAMON_RECLAIM always active regardless of the free memory rate, set
> >>> +``wmarks_high``, ``wmarks_mid`` and ``wmarks_low`` to ``1000``, ``1000`` and
> >>> +``0``, respectively.  Then the reclamation is limited only by ``min_age`` and
> >>> +the quotas.  This is useful for reclaiming cold pages even while the system
> >>> +has plenty of free memory, e.g., right after an idle virtual machine is
> >>> +paused.
> >>> +
> >>
> >> I feel like above might be too detailed.  Particularly, the second sentence
> >> looks too detailed.  In a sense, it is not technically correct because of
> >> 'skip_anon' parameter.  We might later need to add more such controls, and I
> >> concern if this kind of detailed documentation will limit such extensions.
> >>
> >> What about keeping only the first sentence and dropping later two sentences?
> > 
> > If you don't mind, I could add this patch to damon/next after dropping the last
> > two sentences on my own.
> 
> Hi SJ,
> 
> It is fine with me, thanks. Please go ahead.

Thank you for accepting my suggestion.

I applied this patch to damon/next [1] with my suggested change.  I will repost
it for mm.git merge next week.  So, no action from your side is needed for now.
If it seems I also forgot doing that or you cannot wait for my action, please
feel free to ping me or Andrew.

[1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees


Thanks,
SJ

[...]

