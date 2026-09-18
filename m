Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59E5AC982D8
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 21:28:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC1876B0098; Fri, 18 Sep 2026 17:28:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C72006B0099; Fri, 18 Sep 2026 17:28:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B88CD6B009B; Fri, 18 Sep 2026 17:28:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8B7EA6B0098
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 17:28:17 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E2A281407C4
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 21:28:16 +0000 (UTC)
X-FDA: 85228171392.17.C080FFB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2A0CB40004
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 21:28:15 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=iJ7aqB7O;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789766895;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xUD1CoilTyY9WAB6kCA8b05x+K7MhrdQmU4wDQmtJ2I=;
	b=LncLWBGrhi26vPdxsUgG74nIb1Zhh48+yD8J8Y4zRiIiSWiQwgMgqjPPS9nw53zcYWOupC
	b4zRpV5q4/JV6Fn5XyhUQ2+WVAoKWo4lOWPeOFxyy+yMijKHBTenBp6cIrsfqRpb4Z5iUF
	6MJFODZhOvkiJHVifRvOw4Lsrb06Wf4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=iJ7aqB7O;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789766895;
	b=IdSxXGDjeTSuE9mTxQg4vmXLdff/e7gPw/jLKtYX4b+ucZz7kfHVjXjxEkq8CIiugGmzP5
	B0mf6lHkbBMuTKX5DjBQRZlnKxhpq/3LJtaPgLa9aGdUEJI+sB3DUcqCTujCpQ3Jt2xz1F
	eytj/gWbJdF5yi4l9+ldu3NEqrTnpvo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5570042A62;
	Fri, 18 Sep 2026 21:28:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 773F81F000FF;
	Fri, 18 Sep 2026 21:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789766894;
	bh=xUD1CoilTyY9WAB6kCA8b05x+K7MhrdQmU4wDQmtJ2I=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=iJ7aqB7OZFQufH+CMobT4fEU9lGENwdZXjnprTZlRkPkAZjOY8zO/DYATxCWw2+f9
	 B7dsDZXjshgnoX7GZBLntgEF5CkhdvqGE7fPfnfeUctY+PbXPrhY14O0OIqwgmxVJd
	 +ABbeyqCB/iab+QoBwueJHhnADDXb9/kp93upYaM=
Date: Fri, 18 Sep 2026 14:28:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Matt Fleming
 <matt@readmodwrite.com>, Salvatore Dipietro <dipiets@amazon.it>,
 abuehaze@amazon.com, alisaidi@amazon.com, blakgeof@amazon.com,
 brauner@kernel.org, brendan.jackman@linux.dev, david@redhat.com,
 dgc@kernel.org, dipietro.salvatore@gmail.com, djwong@kernel.org,
 hch@infradead.org, hch@lst.de, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-xfs@vger.kernel.org, mhocko@suse.com, ritesh.list@gmail.com,
 rvvandan@amazon.com, stable@vger.kernel.org, surenb@google.com,
 willy@infradead.org, ziy@nvidia.com
Subject: Re: [PATCH v4] mm/page_alloc: avoid direct compaction for costly
 __GFP_NORETRY allocations
Message-Id: <20260918142813.6ea628dfcc32baf57ba70220@linux-foundation.org>
In-Reply-To: <9f415dc7-adad-4161-b20d-7c3173f50ff3@kernel.org>
References: <20260905174239.99e31515fabe220aa7d8e6fa@linux-foundation.org>
	<20260910114602.926944-1-dipiets@amazon.it>
	<aqQlUr-1h07G8JWM@cmpxchg.org>
	<8d6a8a63-4adc-458a-b548-a47bf5ff8eb7@kernel.org>
	<aqq8pWI0u1IZNWHT@cmpxchg.org>
	<9f415dc7-adad-4161-b20d-7c3173f50ff3@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2A0CB40004
X-Stat-Signature: 3hcdrtcgo1qji88noen8sx56yexxz73k
X-Rspam-User: 
X-HE-Tag: 1789766894-881069
X-HE-Meta: U2FsdGVkX193hxmFysAuLOosAOsqV8iZzY43o8lczZvbikYw9U+z0z2axOVV8zciA1VMs0CAX+BJJg1bll0XlEdGv04MedFJhERGA1ydZHdd+SjNMyGz4cjCUYoMJloKrjjKzDHf6nGdECS4MIzjjODJ3MHVITCS+SJHGLqbWHIpBbKXeeHKq8pyCnIZunBfu564u7w6hc21dgz2Uuiae7bQpI0WL6iloW9HGmy3dFnrBW2DGWBF5XZACrEMhwiqk43o5xHlb06UHuvDtBsfx7XhvwIA7//++rVQPORz9ugoN6fQ4mQXUwGf9nakQnCAVL7jovZ3hFf/ntoeAd8Bar/nucjDhhxjBmdz5KSudw2UaUMEueKr1OqPEUqIdxWpLcjEe6RKh3W/OX4DeDpydsfBiM+REwj9z4rRxvYx7allGRPvcuDugYW9NIvOW3WMWjHU98F39hBRjfB17YhM1J4wcE/pHUDU04XoUIRHLVup3k37wfFYARqJ5bwapwxyELJKF310OrXp3L6eJKBO2mJClht11Qhx9Is16VShzPGpCGRRoqyu07nOQV0UKLG59f4WnDmBsbyYhU6nUaMOx9KRfjV/SEPyhzwxbpZ4jEo4/7TKD2UGj+TTdck5s//IYpnXX6zWHzxADVjsZ4hVhQdg1a1Y3LikQGPUwOS/7tlW5NGZEdvCpOgA7tNI1bpWHIOh8EPf3naBL+SZVh76jTcqQqutWXn5Rd8CiepjKJjZV5oPCh0/VRDX7cyMrHpiSRKdgMaAMukiFQrC3+Je1D+CPYYdZDOUr5lS69e3p4GeI0r/Mx9eoDoaxL4O9juithS50r4yIh3LdhCoY+dCn50JwaiyfUUk+VnKMUPu83W9vgdFvocSdyqoVxGXUE/o2rQkymz+T96hO1R6SxH3fVgMhMWtCIondWYyrruJ5r+EXeBIaWNU5v7BekVfILiUfo49SHJwxeqq/M1XaL1
 kiIvaGXl
 Av8QZSxvcahg3024F4/j/0ER0l5TkrI/tVsUUISihEZwPfida20y5JF9koQKvrxDCjpsaPUpi0iaYOimBKSWIS5o/6UXR7fSBR27abWkXUh8gkUi74B7b4Ua17ZcILcWiAMAda2pfXO+qAnpshKdAkJa5NRAk8bRHlfAKF1uWqvPKE+9ypach50pM1vUjQOyhjMObA18ry4f9U2ROlmLux5YX/jjSurud++I4jm9cfkELhvP/K+A1Qo8P35P1OxQJIyJ69KjoaD1qCnueseol36AaD0Z/gwJwdp+GogI4SzT+OISJu4paU1lRSGI7QtABVbtAsFuYyf4nznI3OK5sVG3FFGW3kzO35wth0hVTgXBTXqdTwPlDhvgKAVVEnp6rBqa2Sd6g4pFdmTDDXioVRrM3EIjgU+Ln6JhETVSzS3Q9wMU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 18 Sep 2026 09:05:40 +0200 "Vlastimil Babka (SUSE)" <vbabka@kernel.org> wrote:

> >> Unless I'm mistaken about that MIGRATE_HIGHATOMIC part, it seems all sashiko
> >> concerns can be dismissed and then indeed v4 is the better version.
> > 
> > It looks like a real issue to me, but one that already exists
> > independent of Salvatore's change.
> 
> But Salvatore's change (v4, not v5 IIUC) will make it worse because
> __GFP_DIRECT_RECLAIM + __GFP_NORETRY costly order opportunistic attempts
> with fallback will start eating the highatomic reserves too?
> 
> In that case the fix for this should probably be part of the same PR to
> Linus and be also stable with Fixes: 281dd25c1a01

Oh.  I thought this was settled.

I've removed "mm/page_alloc: avoid direct compaction for costly
__GFP_NORETRY allocations" v4 from mm-hotfixes-stable and re-added it
to mm-hotfixes-unstable and I'll await developments.

