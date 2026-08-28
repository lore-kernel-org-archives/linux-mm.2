Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DD60C61DBD
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 19:20:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CF7E6B0088; Fri, 28 Aug 2026 15:20:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 359536B008A; Fri, 28 Aug 2026 15:20:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2481B6B008C; Fri, 28 Aug 2026 15:20:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 037006B0088
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 15:20:22 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 97D95160495
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 19:20:22 +0000 (UTC)
X-FDA: 85151644284.20.90356EC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id EDF06100007
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 19:20:20 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=YccYuhnK;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787944821;
	b=TePnZ+4lVTfdjL8advxjtQ7gJ5EEwxDNzYzly/R9k1kyAwbt976jBqhEjHrKXB5hWifcqm
	alhMHY75KbIciuuZM7+xxGNDtsgB36+pS26IrWj9ix8UJehbSPjIFyNU5VWyrzpVzYlVgD
	Gk2lK6J2j7d4unKSlsa+7kgX4C9ufGU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=YccYuhnK;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787944821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DqswDGqiNUCPl5M5sQ08mk77pL/gqXDNGxwzzYiqye4=;
	b=s3q9jqy0YbqD4Tfpp2KaXu5a0rMS1W2skJs0ntriHOOmYYnuo+QtAGv13zQcb938xExYFX
	7PO1lfmHV68gUfoSnepH8pLzX02wtveRtGO6AiXUa96JhmQE7oHkV6/CYSnuD+0eGGcWKI
	LowQw2QZB0kyi6ckTz7FFpf/nuJfBmw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0F971601FE;
	Fri, 28 Aug 2026 19:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75C051F000E9;
	Fri, 28 Aug 2026 19:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787944818;
	bh=DqswDGqiNUCPl5M5sQ08mk77pL/gqXDNGxwzzYiqye4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=YccYuhnKN/IJ9Yinyg5VnK5LmyQFBhGAl0u028g3vTYAYyZYUB4UOenvskRreRIs5
	 XiXM3dXuSxkyV8+vlP63u25LymCgQPGRymqbdy+/G+qs0bx5B4Mt4rb+5TViOAGAH1
	 TlnoYCDuZ4PVWFaDr5YyTnO+C3pgxUDjnipDZlLE=
Date: Fri, 28 Aug 2026 12:20:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@surriel.com>
Cc: linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin
 <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, Muchun
 Song <muchun.song@linux.dev>, cgroups@vger.kernel.org, linux-mm@kvack.org,
 kernel-team@meta.com
Subject: Re: [PATCH v2] mm/memcontrol: fix stuck FLUSHING_CACHED_CHARGE bit
 on isolated cpus
Message-Id: <20260828122018.1a3b3be204212837fcda8e50@linux-foundation.org>
In-Reply-To: <20260828135036.7d44361f@fangorn>
References: <20260828135036.7d44361f@fangorn>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: fxdd5khkyuzbn5djq34i4kpfqg6g37qr
X-Rspamd-Queue-Id: EDF06100007
X-Rspamd-Server: rspam06
X-HE-Tag: 1787944820-641298
X-HE-Meta: U2FsdGVkX1+Mx2sI44+qnxdAKzjxLXPzBUZEwb06y3A5FscRAdV2FocLMBuakoZDYcU8/pgnOywR1RwHxgG8Xc3WBus3EWjPfKCQ2G3W3WBNB26NZaQwPAZVSH8fhG0jHDn8AQkpU5G5rbMI1GsKdRIeQpL0RX2Io4bdgj2c0DSjHNEZRAEc30sSpEBFTqsNnE8wv3QwmnthXDhU5Hdhcin8etcsAh1x5yL8R9VZ+tYOz0vvz1kRt9CNXjGbCQ0Q6TZhfylWfO0FQlQIKg97EE5d/O7Qu/Hm+WdLiQxoPifgCt4qqSP0uan2UOXn3Wq316oPGyOQ2Is2ZGbTwwfPfK2gufuUmUqZdC2qpAJEb9GJlh5R98QmfyoKdMzxr49s4v3WYmqyYq6Q2Aev8gFDKgRA4hvDeHBC0xeczenUwFD4eKp40bu0df0EJdqqixSPlKyiSMAHyc9mQzvLRYLdvrHfrHRDD8mg5H90qxmLvCnL4xTiGrMMmU02LyPIU8srwH1eOxTT3gOUd4N2g0waD+lJiOtT3juSBIUnJp+WYVBNsyeoROWPIeXOblfucqT6xKKwjBba/lhHX0zTYHtFxo4lkyKUEJdxTCsYdl0mc35AeLcuUHIC8dBgVoaVFIxVoof0E7i6lAPZH2jQBXE7+fRUBs9KX8ol2P3fAQxaTiaZNZNPxaXu60rdd8fPr6kpDA0xcHZTI7TjbxBd5sIW5LVi9pSSyyhIFFAn5E4exUPQ+RPzPa+UUxcF25laG9r1M7buXoQs7M1zEQJy7bWu5+pky5DvDgirinQnBwgXca6eM9MvKFIN2Xpmuqz6y9doj22xrSomt1AL59y7QGE4PcsJtp8lVyTnW5Ns/M/nkUuOYFzR3rz1Un6AmPMjN+8kLsZC75Zwbox6BDHGqCqUD8/mR2w0KBBTX4dMG33k+NOYu9q3lnuenBrS8Cmw7Gnnf/IHNHYZRds3XGO0IkL
 /zTyJpjM
 X+5xdir7HTE3/8KSMh87a890/Yfsea8MkthPBfUjE432XyaJU3u9kOdET7ILFGOKS16PVsdDt/5Gix4LYSFQvPAaYnQhitwBZ2F7HJiSclb/C3GKQlGyvmBFVIig4qDzKiLh7VLEA9sVzeEvGBSqiqmfgrnLMDjFJd0nPmqe5vnYNJV2TRG2SevF7XsuNvL2ZAldJd/iMskzc+gJu1RRMpa0epNlrj1ED/axWvMNe5O6Kirhvg406mY2GiBrW5lomTDDYZgJtwL+8r72ZmS7fIRkqAaetFRpieeGrUn4091TGbcwe+suVi5s9tuk7u5OpnjRCJHpWOFp3kFaFWbl+Ux3zuEMLxMZ+9dQtfK4EWT2gDLYLn1AhkGuE/4IECCFKj7oHtpelEYpfy3TjopmLy5/7CN9DoZiDYxyy7UUm+qIjUkaqgXgMJenjaw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 28 Aug 2026 13:50:36 -0400 Rik van Riel <riel@surriel.com> wrote:

> When drain_all_stock() sets FLUSHING_CACHED_CHARGE before checking
> isolation, schedule_drain_work() can drop the work in a separate RCU
> critical section, and housekeeping_update()'s synchronize_rcu() can race
> that second check, leaving the flag set.
> 
> drain_local_stock() only clears the bit for work that ran, so the flag
> remains set and the stock is never drained again.
> 
> Have schedule_drain_work() return whether the work was queued, and clear
> FLUSHING_CACHED_CHARGE in drain_all_stock() when the remote CPU is
> isolated, so future drains can retry.

Is there some Reported-by: or reproducer for this?

Given the complexity of the reproducers which Gemini developed for me, I'm
suspecting "nope".

> Fixes: 6a792697a53a ("memcg: do not drain charge pcp caches on remote isolated cpus")
> Cc: stable@vger.kernel.org

Why is a backport being proposed?  How does that benefit those we
serve?

Sashiko suggests that we ain't done yet:
	https://sashiko.dev/#/patchset/20260828135036.7d44361f@fangorn



