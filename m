Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06682FF8850
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 21:21:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 384646B009E; Sun, 26 Apr 2026 17:21:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3351F6B009F; Sun, 26 Apr 2026 17:21:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 224816B00A1; Sun, 26 Apr 2026 17:21:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0DC326B009E
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 17:21:00 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A33F71605B0
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 21:20:59 +0000 (UTC)
X-FDA: 84701977038.09.004B74F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id D2EE1180008
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 21:20:57 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ek/IbZsW";
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777238458;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dGxHaxX/heGhBQAqn2D/vPf9VuPFcdVw3v9kaSW9Jzc=;
	b=iLHbtnP8UqAK190ohDZ3qadUfK1tzqFq4HWax9cvoGO17oHHyKTIUs5gGIu7yKxr3m0BKc
	Mm9bpfXYhmjH2R3Bzpkzj5OK3M7vuMDgQgiV6egcO43sK9b3W6a+zFpI8Yomd3KTQkKRUK
	ny5E2/hQpFcgC4SitgBXWnlsXT/ub58=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ek/IbZsW";
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777238458; a=rsa-sha256;
	cv=none;
	b=vIyjiqQp9NJ8J2m2MlLKtu74CWc9hAYKB5DI49eluASWyg4N56iyhkI/c1u1wmOvy//keX
	ujFiTyQGhNRCumfWYfdPLUKdyAlBOPm5z42FwyV1cJ0hof03ggE9wH8cBZZxbp+WONdhVd
	Rx412OMpbrMX2DRVJ9Eanyr1WkGrkOI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B518E40B1C;
	Sun, 26 Apr 2026 21:20:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 646C4C2BCAF;
	Sun, 26 Apr 2026 21:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777238456;
	bh=Wz5ssFeDipE2282eBjMZgUbsO+8T8am3ncG6haNgKQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ek/IbZsWHpMkkbz2xUXuGrJKeeaqhkrx80Jz1sHt9i++pjqXaNW8UXQ8r48EfwpWn
	 hZT5bKjdRmARcao+LCkpEjHLY2s20TEt+D3jOxFfZY6hz5CcFwJKAA+ZMl4/vEUnfn
	 P8Dqlgnb4RlTqWI4gD95XaJX7CjcPnAXQGkxJI+dqF0j4H1ZoiN+whzSjw4kmDu+mX
	 /M7P0JiwbLDKsR23kvpeEz5qB6fNtWX/kYzZTXW8hy3mW7ynNwv7Ki5AyXYxhcIZP7
	 4YzFmaRdqvIy6MIqzaTuH47KLUioKaMfXk7H9EkNIu9X9StGjXrsgmsL7A15yYtcZs
	 ws1i7KeGAjiRA==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: lsf-pc@lists.linux-foundation.org,
	linux-mm@kvack.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [LSF/MM/BPF TOPIC] DAMON Updates: Tiering, Pagel Level Monitoring and DAMON-X
Date: Sun, 26 Apr 2026 14:20:45 -0700
Message-ID: <20260426212048.94069-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260307210250.204245-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xfeg5o19jqkr13y1wq4ettpzz3krjo8j
X-Rspamd-Queue-Id: D2EE1180008
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777238457-861633
X-HE-Meta: U2FsdGVkX19FGk2cj+tMdj0lwPwgpWioanoLYhJx134Pw5VnkgjXher9X5SARWIMtkLHpOLYNSLT3O8Bi2TvC/HQfcyPgERI8ujMemFeUn2WAG6e9eWjIS21RVrr5YyBlRWfHnfhXwFArQLHEyrERK4NV9jVdmKC4/mjMCBHQNlC/qNM++923ZheagfeQjb6mhNzuYNc0J5fuEJVzoQyLcTLfa6NOHjNf6VFFTzzNsVe2ju/MLLU88EMEGFG7bb9RD9E7CA2n4zZ9RNMWB5vNMZHTOSYtqrNg9UUuZ/l29bZzKK4l8iuhC6/lyKvdy4TAD0flzVTThnYbdraiQ1AOS3v3JHRBjmupkeFw27Sz270O1VQmAnA6M282oQob7weFbrpG9aprN93dsqeRvcAu5+dsRLBh1r+VHlldnsXxVJHpQZ9iD+dRw8hKfA1uwN7OeB6DIXPIF/OaJGJJjNGtamRn+d1wWqpab1d8t8KCY+bIDtAXM3ole7ySXD/qjP39V3mOQmuYZVMZ5Zf1htqa46PjL+PjqUPIncMIR3Ap+3P3QYWq2I05YpaJ1hY09+6s54Nb3sAJ3m7DW97U7/ij7Gc17kyDU3AjnYBmyWuKx7DFdQP0pn1+/501wHarKCXV7syB8UFlmHbqPqLYsPztsyACGVgqFPUaDzSwNi1937LBgZ6/pFMB2i+jPR2AjJD0WoyJPqG2ay4Mxc+8t2a1CMxHuv1dLg7IaiENW/XLbi30GMHiT8akAMvC3Zk8qvC9BupoJfrZJR7Fl+ACUpxr9SRuN47NWTygu976XftZq2LuNGyhEFYe1xIXZHZl8OHMqrGbkx+hIPP5o6rg7+Eg9aTVvCiRbURJvlTo1H50PAihrUxem7w3z2lx2X4Ni+qu3Cv3ID2Ir1QgL4yfjNJzwxTB25yD7T3x4tYZwyYIh5B/c+xz53ZnDHOQ0UJgQ4UKTv0wEuDxiuAcRsQxdX
 1lIWp82W
 KGODtGgTjfdTmOuvxbkjmopM+VYdpHbDXAB4ZMYKuTXtH/XnTFkdOpo/lTkJQIK/CdvVsnOnrwmmur4pQd6x0RIDYdH/Xj+p92y7iEpTrWsIUM+Bex423jiW+NBz9DglwL8xkCbrmwMP5CnsQifERhNIvA++/0+zPZd7dsXUDO1ueNWxvE40aVOg2Ph+3qvL2dj8Qnvs83tCn6G+elEcJiIlMk23iMTbA2+YC/nOxQ6cHcPTJP7IsOC42WzoOAlDWH613QNOx0RheFH28sGzdyf7o/WXaUxuyD1FkwcABaVt4zPs+6XPJ4VeUYwcNZNoifCSwSvBMa7fVHksvesWIeryZKtH0ItiIvPi1cdfGbMdZfybNGd+5TQhnVhSpnZnHuWIOkcTAbLb9f/P9yg1mxJp5bzV2mUGMnOtnsDMS2ysLs/cJ4W2KmjHrtAFy+oDdfx/fS8dvP22XIss=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat,  7 Mar 2026 13:02:48 -0800 SeongJae Park <sj@kernel.org> wrote:

> Hello,
> 
> 
> In the last year LSF/MM/BPF, I shared [1] updates of the status and future
> plans on DAMON development.  Feedbacks were very helpful.  I'd like to share
> new updates and gather more feedback on LSF/MM/BPF 2026.

As this topic is scheduled [1] for the conference (kudos to the conference
committes!) and the day is approaching, I'm sharing a few updtes.

> 
> Major topics to discuss in the session include but not limited to below three
> topics.  Of course, some changes could be made.
> 
> Followups on work items that we discussed on last LSF/MM/BPF
> ------------------------------------------------------------
> 
> DAMOS auto-tuning based memory tiering.  I worked on a more flexible evaluation
> setup for it.  I also upstreamed another DAMON extension that makes memory
> cgroup-aware memory tiering available.  An unnamed user confirmed positive test
> results of the auto-tuning based tiering.  Meanwhile other users including
> people from SK hynix and Micron are continuing development of their own memory
> tiering approaches and showing good achievements.  Because basic evaluation of
> my approach is done, I'm not actively working on this now, but working in a
> support mode for this.  I will share more details about this and discuss if
> something need to be revisited or if there are anything that DAMON can help for
> memory tiering.

Ravi from Micron is continuing their work [2], and now it is nearly ready to be
landed.  This is only a part of the topics I want to discuss on the session,
though.

> 
> Page level monitoring.  The feature, which accounts the number of pages in each
> DAMON region of user-interested type (e.g., hugepage, LRU list-position,
> belonging cgroup) has successfully upstreamed after the LSF/MM/BPF 2025.
> Because it imposes high overhead on large systems, a lightweight version of it
> was shared as a future work.  Unfortunately not much visible progress for it
> has been made so far.  Some progress on the design is made, though.  Briefly
> speaking, the idea is sampling the types of pages in each DAMON region.
> Implementation wise, users will be able to set the types of their interests,
> and DAMON will provide the counts of the samples of the interested types, in
> addition to the access frequency counter (nr_accesses). I'd like to share the
> design and get feedback.  Hopefully RFC ideas or patch series will be shared
> before the conference to help discussions.

I was able to make some progress and just posted [2] the RFC patch series.
Conference driven development works! :)

> 
> FYI, in future, the counters of interests could be extended to do the DAMON
> region merge/split based on not only access frequency but one of the
> user-defined interests.  Then DAMON might pivot from Data Access MONitor to
> Data Associativity MONitor.  It’s just somewhat possible and sounds funny for
> now.  I find no real use case of that.

I now think this is the right way to go.  This can also make page faults and
PMU events based mointoring like access check primitives addition easier to do.
I added more details about this on the 'Future Works: Long Term' section of the
cover letter of the RFC patch series [1].

> 
> New Project
> -----------
> 
> DAMON-X.  In Crusoe, which is a neocloud company that I’m now working for, we
> want to utilize DAMON for both memory efficiency and observability.  More
> specifically, we want to show the memory idle time percentiles, and run memory
> PSI-driven proactive memory reclamation.  The straightforward way would be
> doing that via DAMON sysfs interface, or DAMON user-space tool.  It requires
> some user-space programming, though.  I want the kernel to just work.  A way
> for that would be running DAMON modules that were developed for the purposes,
> namely DAMON_STAT and DASMON_RECLAIM.  But DAMON modules run in an exclusive
> manner, so we cannot run those in parallel.  The exclusiveness is required to
> avoid interference between DAMON worker threads (kdamond) for different
> modules.
> 
> I plan to let DAMON modules share kdamonds to let them run in parallel without
> interference.  The shared kdamond would be able to run on the system from the
> beginning or on demand, and directly attach/detach DAMON applications like
> DAMON_STAT, DAMON_RECLAIM, and future ones for NUMA-aware page migrations etc.
> It will work with a very minimum number of knobs in nearly automated way, but I
> plan to also extend the DAMON sysfs interface for more flexible and manual
> control of it for experiments and investigations.  With my humble naming sense,
> I’m currently calling it "DAMON Enabled Computer System", or DAMON-X in short.
> Actually this is a followup of what I shared in LPC 2024 kernel mm
> micro-conference, as a long-term DAMON project for the kernel that just works.
> I want to share Crusoe's desired use case, problems, and design of the
> currently planned solution during the session and get feedback.  Hopefully RFC
> ideas or patch series will be shared before the conference to help discussions.

I was unable to make much progress on this.  As we still have one week, I will
try to share a detailed RFC idea at least, before the conference.

> 
> More Topics Out of This Session
> -------------------------------
> 
> There are two more DAMON-related development works that are ongoing, that I
> want to discuss in LSF/MM/BPF.  Because I think those cannot be discussed in
> single session with the above three topics due to the limit of the time, I
> proposed separate sessions for them.

The two topics are also scheduled [1] for the conference.  We will have one
hour session for all three topics.  Appreciate the conference committees for
their works!

> The two topics are "production level
> access-aware THP [3]"

Asier from Huawei made DAMOS_COLLAPSE [4].  I will repost it after 7.1-rc1, and
hopefully it will be merged into mm-new by the conference.  This is only a part
of the topics I want to discuss on the session, though.

> and "per-CPUs/threads/reads/writes data access monitoring
> [4]".

The page level monitoring RFC patch series [3] is now also considered to be the
foundation for the interface of this work.

Akinobu continued thier PMU based mointoring work [5] and I now think that
could be a viable option for some of users including Crusoe, if page fault
based monitoring is rejected or delayed too long.

> 
> 
> 
> [1] https://lore.kernel.org/all/20250102222317.48760-1-sj@kernel.org/
> [2] https://lpc.events/event/18/contributions/1768/
> [3] https://lore.kernel.org/20260211050729.69719-1-sj@kernel.org
> [4] https://lore.kernel.org/20260218054320.4570-1-sj@kernel.org

[1] https://docs.google.com/spreadsheets/d/1mGEdDrWskp7Ua91jGXzquQGinorcD58DAVXhOiRp2Gg/edit?gid=1852749899#gid=1852749899
[2] https://lore.kernel.org/20260426003245.2687-1-ravis.opensrc@gmail.com
[3] https://lore.kernel.org/20260426205222.93895-1-sj@kernel.org
[4] https://lore.kernel.org/20260409150128.1566835-1-gutierrez.asier@huawei-partners.com
[5] https://lore.kernel.org/20260423004211.7037-1-akinobu.mita@gmail.com


Thanks,
SJ

[...]

