Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5687AC5DF87
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 22:56:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 606606B009F; Thu, 20 Aug 2026 18:56:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B7BB6B00A0; Thu, 20 Aug 2026 18:56:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A6786B00A1; Thu, 20 Aug 2026 18:56:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 283AF6B009F
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 18:56:00 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A8650A02D3
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 22:55:59 +0000 (UTC)
X-FDA: 85123157238.20.DA8C5AE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 0090AC0006
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 22:55:57 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=KagyFWw9;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787266558;
	b=6QRCZPajPScHjBs4Bpba/xQ19Bx8npBmux2aAq3V8ZJ3mZqyb6LcYykgdxX0GAQu+ATBYX
	SYgUy0OLN2M/62gI8zARYpK/u9mVoCcs2IY15IicPua7mO04uQdii0AuDfShcDLy1lRmI7
	ohx20IVIJiVR/Ib/nOZKTdnQvYuXCxg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=KagyFWw9;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787266558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kZunpZo4Ob7dnPPiEiET46yjsPwCJrXBRNVqc/tVrdQ=;
	b=kf9iJPJnDZDT7T4RTa/gbzVjB1h0YS9LR8H3yQbWa41yoVlxXA4tve5vGpGrfytlKaZh2J
	K2lUMNvM4zZySWY+zElg5GgiDKp9tryVputcDz5YtKrzjvilB5Nntm7opCL+ok2S4tI8PL
	zSXvkphX9o8zJu0GLkcEf04a7OkZLOQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7645060A58;
	Thu, 20 Aug 2026 22:55:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C30651F000E9;
	Thu, 20 Aug 2026 22:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787266557;
	bh=kZunpZo4Ob7dnPPiEiET46yjsPwCJrXBRNVqc/tVrdQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=KagyFWw9ORjX2tEGt6I0GhwPXz7Faeh+XtuJ2G6+yrCkLoiI8DD7BLwGrFSunUGRI
	 0/gv1sXhQgT/wnF8PVsfDocPpDMvsS67TGwyZmGiB0tGJpu9czF9bTTguU9uyV5Lc/
	 /eAbqtVGTdJs0lc/dSCbyLDtxGZJ8zov53EVfH2w=
Date: Thu, 20 Aug 2026 15:55:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, David Finkel
 <davidf@vimeo.com>, Tejun Heo <tj@kernel.org>,
 "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)"
 <cgroups@vger.kernel.org>,
 "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)"
 <linux-mm@kvack.org>, linux-kernel@vger.kernel.org, Tao Cui
 <cuitao@kylinos.cn>, Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [PATCH v4 0/2] mm, memcg: fix memory.peak reset clobbering
 other fds' watermark
Message-Id: <20260820155556.8e95067fe0402cd83ed48dab@linux-foundation.org>
In-Reply-To: <ee4cd3ab-0708-4c37-b597-703a7d7547e2@linux.dev>
References: <20260814033005.2481920-1-ridong.chen@linux.dev>
	<ee4cd3ab-0708-4c37-b597-703a7d7547e2@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 0090AC0006
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: ri91ujx19788jwpsjzeau8mqdp797th3
X-HE-Tag: 1787266557-619812
X-HE-Meta: U2FsdGVkX19o12MWKYnEGeflk2Nu5eEpcOrEKqbyHBIlxD8ENnhcgkJep1flmf5wOJ2ElXAyIbJiQTgEhP+/ZWNQMOc/+0bwxxgh4CIDx4Ya4gnqSXbRgiEzwKXDQ5kCgJzta58yAV9ax5b8xCVEW3cLN3qhQiFBpvOZmXmaNw/JFA0hSeHwcQvECyGebYjvPObi9qQOdzpZnMv36Vg8Vyaw7e/aDiu5tcAHrx9k25VHHDsz+r1dMz/r8u8vo92zgn6Y4D8Kbn+noSVAhotScVPfBe68YH6yZ4cAS1vw25J9SX8AmlT8wNwGDFyz9HhcmsmGzMQFwbhL7xaQ3C2sIjdSudG48GvsvmaL3cMYsznXuk2UxjQqj2EUxDzPikEYy27YfqqgsFoSfMfRG8ii4wmc/oMg+NCGUtHTfXDTJKk56UrhOMeCTUI68MpgbTe0adA3WqikiHWwjOM3ThgeIfICIHQx3VyqF0CTakFit0Bqvs6Yi6j2f7/qp2RMmJ6uq6Ur17oCVL/ziixPTfX341XdV3JLJbZ8WqfYW01NQRiqmaphVWSGYiYYTT7NnWP/gFWKdxnmsZfEdL+0jOxm7uFb5ytbvIlgBOnWHzZuPyAQtYTa7+eME9L4BWQpkWaRpBXMQU5so8XFcuNwBBTs0b3svjL3zsyFrRJs51JYL8ogjMfOR6Sd3kj//9y9UeBI4O4eYSyRKNc1c8iurj0D3si20bNWg5em5vN8601CWucJ3dY0FYvrMAJ265kYoYsMY8cX6RNARufGHe0lb3PvpsyMeQXVtHwXzzELDAWY0a5nn12HaVitqVZO3Tk4EDwsOzuFLDpY/jp8/gk8ytQPdc20OJ3KTXiGHO0Uloex0MnPavnykYGyy2xLcRwQSUzDkrStxiukvDNlXzg7hQRBzws7q92dvCY9/G3bgttJL83mHApnOKyXteF30WTSPie9feTA0M7Sz8zPBtSms2m
 4Hqe6rAI
 QAbleQS3tsEEB822wX4NLrshb8AzX/nxKkdfQpaHwcbUeqn203WqmumhQg27tQ7Ftl68PxKqzG+DD2x2nn1VjY6C5Gr3D1iCW+i9143TtpoVxq5jSlH3/RRnT260g5YR4ktMj67p22DhcTp569tDVeNN9T+s+VwCxIneHZqUwfbcEnQaablNIxlcPb1mdU5H7eITR4yv8HmF6Img42mas66NGT53PNiMh+XiC8jwxX1tC58/qgwqhNpNqNNTqaiWPvsHo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 20 Aug 2026 16:43:23 +0800 Ridong Chen <ridong.chen@linux.dev> wrote:

> 
> 
> > 
> > Ridong Chen (2):
> >    memcg: acquire peaks_lock when reading memory.peak
> >    mm, memcg: fix memory.peak reset clobbering other fds' watermark
> > 
> >   mm/memcontrol.c | 9 ++++++---
> >   1 file changed, 6 insertions(+), 3 deletions(-)
> > 
> 
> Hi all,
> 
> Just a quick reminder on this series, could it be applied?
> Sending this note in case it got buried.

New material doesn't get a lot of attention during late -rc and during
the merge window.  I've set this series aside for consideration late in the
merge window, but a resend at that time (or shortly after -rc1) would
be helpful.


