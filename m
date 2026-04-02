Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE5E0D39423
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 13:33:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46A946B008C; Thu,  2 Apr 2026 09:33:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 441CE6B0092; Thu,  2 Apr 2026 09:33:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37EF66B0093; Thu,  2 Apr 2026 09:33:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2C1BC6B008C
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 09:33:32 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CA46EBA9E9
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 13:33:31 +0000 (UTC)
X-FDA: 84613707822.08.A6BE2A4
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf05.hostedemail.com (Postfix) with ESMTP id 27527100009
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 13:33:29 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b="iR6thK/Z"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775136810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mXyOffJoj0vx+EAUo0TPbuyn0MsrVCVYwm7k2LD6NB4=;
	b=yA/vg5nEXe1jotuQTvfGUiUDwWUssYwR8uzpxqSpbOx3tDFLi5IJGiXDsd10djZuGuuRc4
	fd9MybgJugEKhEKZ/It06s9/JhBc0tCW2ntafb/3O9dHx8rFlBOd4qpdGReMu7zdNjVm6H
	uDueeKp3eU+VjEOsWupQWqOvU940M8E=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b="iR6thK/Z";
	spf=none (imf05.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775136810; a=rsa-sha256;
	cv=none;
	b=uBGyjNgJ8v74VeCH2zLHtQVCgYye+eNYBa506ogotbozql8AsiVt0RqI+LgxlrPgiur4E4
	yXPwI+JLRDUZUIxJAooC0XpOzcgA1wiwhSQgTqPbuMb5Z5qvUote/DBPi80ea0/rMD7ee3
	mDPZ2zm91U/wymS9dl0qfWGzFidcQqk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=mXyOffJoj0vx+EAUo0TPbuyn0MsrVCVYwm7k2LD6NB4=; b=iR6thK/ZdwjgK0rBw2kjZfO7Cb
	Q8I5RMdOlfyerfFcG/qmotSlAa2KUkvL8qU/LQhRcbQWOo5mmVfQVcUoCMTnNUSNGb6qOwOpxDYZ5
	rYUqGFOoixppN4JTIJ+ypg01OZckpJHQXH18aZdekUJ/J8hMmQ979x0vNZ6WacqW+TvltAZzXGSja
	6s2k+QtWd+dPpo6mT92ptbvvOA6/O0Xqn7YfP2AOmqge3h/snaWu3RMKGxD4lbdOWYqqJNfeQX3rl
	LFxqXaALOBADek5BmQGfRbGsc/u4N/L4iLoLvcgC/ynKAQDKu2Sl2CbLV6b09UzUFHyq9yvJ6x0KC
	I5yy/BSQ==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1w8IAl-003nZv-1c;
	Thu, 02 Apr 2026 13:33:22 +0000
Date: Thu, 2 Apr 2026 06:33:17 -0700
From: Breno Leitao <leitao@debian.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kas@kernel.org, shakeel.butt@linux.dev, usama.arif@linux.dev, 
	kernel-team@meta.com
Subject: Re: [PATCH] mm/vmstat: spread vmstat_update requeue across the stat
 interval
Message-ID: <ac5urCFeEB9oyUiD@gmail.com>
References: <20260401-vmstat-v1-1-b68ce4a35055@debian.org>
 <fa089716-1bed-478b-96e3-a2ef5465b52f@kernel.org>
 <a55afddd-8c6b-4a7a-bfd9-5140013c764c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a55afddd-8c6b-4a7a-bfd9-5140013c764c@kernel.org>
X-Debian-User: leitao
X-Rspamd-Queue-Id: 27527100009
X-Stat-Signature: qbjsq9ggofw5zcy4oenoeyrihqzpdzd5
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775136809-851750
X-HE-Meta: U2FsdGVkX1/HGEM44ySEiBXlDr1WjzF9pZqEcQ0/MTkE4tv7fGAqPsjc5PpWO6qQ1qdurzwWkSLUcv5fVCEctTYrYafncO7ElIInX3FC36S3e6qOMJJw6ci49625EwDYBHTuN5wk9IiAQV9HwwsMhnMLWjlLZdbR57o9lb1xQ87uKBfj3Yx+Qnkaze1eSCqBLkWXLUFx2xjudS3BdFSla1WTRUrK5fS3imQeXR1eENR8GsF9FGYR6hAt6vlgaAV1j3gso59GtniYv3/i+H9ZbM/yhZRgH8A3EHx2iJlo4jJUpATX5ZtvbgQVFl8H+6UDassXJGv74thAgQMuc4JUXaW5BFwlkdTd1qmqinb0VNmB38Ytn7Tu0GJjDehe9WZ5xlEC/EXA1lKHZCv473qqNwG1Rf5/G+Tze+fvPn8s3bEZcVLiGWFePd1YFRevFrBNOFeZqW2hAioWWnnafcQjPGRKKJ9k+TQpf+n6GoW1fdBzzm5EacSnUY1C3ZJ0WjBanWuXyUDby6B3dDrHgQmO57+lvGG4NktuNg/8k5Pl+ngPfHU2fWVpShPE7FAQVFiuYFNATpWH6FHExhH5/bTBONm6AF+dhwqoAyWnx769ZRwknOGPBe3fxZOYrt5jxbhbbQQ9t/AScWzVZZwkhJ+XLHFvWXNUAooBuYbTn/Q/JDMJoaOsZMbBa4hE2XmG5abWwpX38IaErG0vWGVfhCfSVlGyhPlaVNW7Mvr+cgK/3Cj4q47NKTcc/HgjFu+20LZm0Y700AsAOi5f7H4AvkZEjfI28F4vY58/Ef4iuXnoB0wWJWWsLVftqY0jgICd1DllLyEDhGS6l6gAgVGXKJgPbxwtzlWMmL8X+CodGEIb+QkgWbWGPFI3pBuIgC42aUY3Tchy4ARdO08SS5Q4jeVF1iye9Si318pKT1SaUTTG4qJ5oCjN011qALsc71JmmZXqN1GHMN3M37ccMN6NZ2l
 cBBxy2P8
 R6CISrXBQoqvi5JexENXDUg/+fJPG70mbmXiZfu4OxbxUOCYxoYbNdNHhJrxt8vcZAWzBHKXSqfXlTudBbMPP2BRPGXkLNT4KbpSYwwVzLCtTpbCS8yjX5cWMIrPxxoyey96q4HA8DJAz0bs18+F0nKIui3uY9/j4YMg9f9qKoIji2A85svOCl7Cgag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > 
> > Cool!
> > 
> > I noticed __round_jiffies_relative() exists and the description looks like
> > it's meant for exactly this use case?
> 
> On closer look, using round_jiffies_relative() as before your patch
> means it's calling __round_jiffies_relative(j, raw_smp_processor_id())
> so that's already doing this spread internally. You're also relying
> smp_processor_id() so it's not about using a different cpu id.
> 
> But your patch has better results, why? I still think it's not doing
> what it intends - I think it makes every cpu have different interval
> length (up to twice the original length), not skew. Is it that, or that
> the 3 jiffies skew per cpu used in round_jiffies_common() is
> insufficient? Or it a bug in its skew implementation?
> 
> Ideally once that's clear, the findings could be used to improve
> round_jiffies_common() and hopefully there's nothing here that's vmstat
> specific.

Excellent observation. I believe there are two key differences:

1) The interval duration now varies per CPU. Specifically, vmstat_update()
   is scheduled at sysctl_stat_interval*2 for the highest CPU with my
   proposed change, rather than a uniform sysctl_stat_interval across
   all CPUs. (as you raised in the first email)

2) round_jiffies_relative() applies a 3-jiffies shift per CPU, whereas
   vmstat_spread_delay distributes all CPUs across the full second
   interval. (My tests were on HZ=1000)

I'll investigate this further to provide more concrete data.

Thanks for the review,
--breno
   

