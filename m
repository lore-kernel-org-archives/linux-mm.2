Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B89F0CD5BB4
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 02:49:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F0676B0092; Fri, 22 May 2026 22:49:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A0496B0095; Fri, 22 May 2026 22:49:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B7866B0096; Fri, 22 May 2026 22:49:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 712606B0092
	for <linux-mm@kvack.org>; Fri, 22 May 2026 22:49:14 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 22DE68F0A2
	for <linux-mm@kvack.org>; Sat, 23 May 2026 02:49:14 +0000 (UTC)
X-FDA: 84797153028.14.F0E4978
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8438B40006
	for <linux-mm@kvack.org>; Sat, 23 May 2026 02:49:12 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=pboJkTJs;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779504552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=78N+P7P8gqbkhUPA/78W3mwHDVrIp1fEwV8A+moHM+k=;
	b=zp7vp+xZVfiRtHErN+IAr8MRz3D1scetv5zDwqDyImXzOfkLVvf00JYypc8by+5iPengbM
	pvrhO0b7bV//v22pqhEszNKRXDtpD7thepMzZ43nR8QqXu4EIIOzzIj9fObbBepE5jIm7r
	c+ljr5OLDNQacfGRbxXdgDpoq23uOjw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=pboJkTJs;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779504552; a=rsa-sha256;
	cv=none;
	b=SshJDySveDBrUnbYbIifoBxMs9TXJh/+s7FEt4983QY9H9YxtJIt/pc5qc8qteavQDoUe+
	3QSv0Ad+h1cemdiJ5fanR05CdYJ0S/LJdZGaJMBxbJIGGB+tD6SkE8nmeTnbUXEWDIkNTl
	k/RXC6X1AvNTY/n2GW8960xjzLCi080=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D80F360213;
	Sat, 23 May 2026 02:49:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 108021F000E9;
	Sat, 23 May 2026 02:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779504551;
	bh=78N+P7P8gqbkhUPA/78W3mwHDVrIp1fEwV8A+moHM+k=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=pboJkTJsFft/vCcg33VX/hetYDvccIzh+1G8kjyipRbMXx8vprEWk+txxkF92ca64
	 XuWbtCSUSekl7QgehjujsU0o5o9PxP0I+PpyR3/NmaZXOoCud3k4aHuWPDMhM71PDZ
	 ZVd7wmPplvurq6a42aQjlqBi7B6gAKSPPLODT+eE=
Date: Fri, 22 May 2026 19:49:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Kaitao Cheng <kaitao.cheng@linux.dev>, David Hildenbrand
 <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Minchan Kim <minchan@kernel.org>, digetx@gmail.com, John
 Hubbard <jhubbard@nvidia.com>, Greg KH <gregkh@linuxfoundation.org>, Linux
 Memory Management List <linux-mm@kvack.org>, LKML
 <linux-kernel@vger.kernel.org>, Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: Re: [PATCH] mm/cma_sysfs: Skip inactive CMA areas in sysfs
Message-Id: <20260522194910.9395371c3d3d1bfb87cd1211@linux-foundation.org>
In-Reply-To: <CAMZfGtWO7=UfnVB9oR6sS6eGSBv0-pKciFqpoB60aq66fYTSow@mail.gmail.com>
References: <20260522131434.78532-1-kaitao.cheng@linux.dev>
	<CAMZfGtWO7=UfnVB9oR6sS6eGSBv0-pKciFqpoB60aq66fYTSow@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8438B40006
X-Stat-Signature: agrt4jenai8575riyoc6jfkftmooxhxm
X-Rspam-User: 
X-HE-Tag: 1779504552-52120
X-HE-Meta: U2FsdGVkX19ajqHqJbYa2nqBYZ5gEMQPPnvsNuaDF+3G9M/1iTUId8nEA4jCWxopNW3a/ZC3YpZI7WjlMkfOMTR5oWRALZfU/89nCvWnqYcSEO0V2ESmw1uxiUuMavCldzuywbEr8Pax6LtXOXuCzZLc8PWotH/RD2xMoh1AqpyyQBVCqft6XXN7zmOc7MAXlF7eMBPxJk6PB8MEHdM/gzpr6f9kOqYh+8dWzibxaG7YPMcHVr6t2wwLsBgJ741Vhdw77cbYjV9CZWjT4fUZgqm768vaB5CeaZmmm4PC9Q9X0V+q5xss7EYKHWIRc6nXN8ds2co90BTLUduOGLFtRUTv37spsFIwql291jgTLlSuvBbwBuO7Vbj8XoE/Bb3blhwKnj17EFSfZfVGTM0j6o5caRXJ/u+Bgl6PUCOhbEVrB77cU85WyoSFx4PEpItrSs3IUJ4Ocnwdg/K3bXy9McTO2BC91kA1dx/02E4FtNOghAV+sna7lj4lMQ+e85icSOyqPWrvgVl9kUbAjC7yoTvYkGyBengmjEJXwf5+9MQwLPPfyS3MtUMlknty6yCxX30QqQuD/oqSBxQb4GjIK5ca64yyjumZZD6ndHzVDW0ye3US8Pn3wLSRZV9yRxpitsvPUqLYhbZrVQrRBR2/Ew7aWyucNNoVABZNtDdFvfZBvdQ17WmFGSEE0ahofoSgrKig+eQYVm2N07I7Rc94TfbL7lnrINiI/7BwZrd13sSc7uSLn7TuFbvphTskKyDVmL5uz9XNN+cIgZAg5iU7wLvA/+35ICo5JJo6s20j1hjZSAowtHqRTc3NGobkUxI7V4khVANA4EZ9vRQSY8vJmpTEEMkIijwscQ29DZuYSzCoVPRD35Sp5kqh+ozfktWYe/QE0A6lVftkbb+duSCXS47QqwtFgqrmvmv9iosgXd+RJNJSxAsNkR2uNIK3kQWoh/go+VphxossrJ+MBIO
 WnwkTP6F
 fPQcQmmwRJvuAmpV1tDsjFUJC9gTL5t3SPIcsbZ4Yx6HO2F1H57fKNEprN3fzdMHIbDTgIxeB3UI/ggEsEKhPOGg79bjovY88NOgdnq46KOLUIz5XCmpHfkWSUllksKAZxFWCv53rIXhCXEpQ6jkI6SnHiWIUoc5iqeoF4mZKFi43/62g1R3OFF/Qu3Dc7eeOjeTaJ/8iR7Y0TJgdcBsFGpXGIqeSX86IdfI0MgrM6828RE5c44CKp5rIHFcGYSyZaI+exXFpiRbcgm2+D5qmeK/SXUERwKKUnhHls2R7pwwNWPVTug59dm7JdlpwEO+9a9ncXuboWZF+Cqc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 22 May 2026 21:26:59 +0800 Muchun Song <songmuchun@bytedance.com> wrote:

> On Fri, May 22, 2026 at 9:15 PM Kaitao Cheng <kaitao.cheng@linux.dev> wrote:
> >
> > From: Kaitao Cheng <chengkaitao@kylinos.cn>
> >
> > cma_activate_area() can fail after a CMA area has already been added to
> > cma_areas[].  In that case the area is left in the global array, but it
> > does not reach the point where CMA_ACTIVATED is set.
> >
> > cma_sysfs_init() currently walks all cma_area_count entries and creates
> > sysfs files for every area, including ones that failed activation.  These
> > areas are not usable CMA areas and should not be exposed to userspace as
> > valid CMA regions.
> >
> > Skip CMA areas that did not reach CMA_ACTIVATED when creating the sysfs
> > objects.  Since inactive entries can now be skipped, make the error
> > unwind tolerate entries that never had cma_kobj initialized.
> >
> > Fixes: 43ca106fa8ec ("mm: cma: support sysfs")
> 
> Actually, this is not a fix since there is no serious issue when accessing those
> sysfs files. I think it is an improvement.

I find it hard to say because the changelog doesn't have a clear
description of the userspace-visible impact of the bug.

> > Reported-by: David Hildenbrand (Arm) <david@kernel.org>
> > Reported-by: Muchun Song <songmuchun@bytedance.com>
> > Closes: https://lore.kernel.org/linux-mm/55481a8b-dcfc-4bef-ba59-aa0b43dca88b@kernel.org/

That says "Reading the bitmap file can make debugfs walk a freed range
bitmap and trigger an invalid memory access".   Maybe it oopses?

So Kaitao, can you please send us a clear and complete description of
how this bug affects downstream users?


