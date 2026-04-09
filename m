Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C2F2E98FA9
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 03:49:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 321D66B0005; Wed,  8 Apr 2026 23:49:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D2A06B0088; Wed,  8 Apr 2026 23:49:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C1C36B008A; Wed,  8 Apr 2026 23:49:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0A50D6B0005
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 23:49:23 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A7265140399
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 03:49:22 +0000 (UTC)
X-FDA: 84637637364.05.60CCAB6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9A5ACA000C
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 03:49:20 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PgL6J1yH;
	spf=pass (imf15.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775706560;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fU05U0/lI4g2ijCidHZ3j2rU1iPgL0L8RB1CJ+rRE2o=;
	b=ylrawlRMZ3PUhu/YEmLBlcJLbHNGm6nUK/pJCqDR5mAbxgZu+8Le+bY+0pX2/intr1nOkq
	XwKoCE+Slw15BGqfMf6kbdF0NalrLoEg6TX3WbmTDeZI7xQYYadM+6u63KLU7e6GIMKcK0
	+BznBW7GXBF5FQlCsfE9ZERHJ49NicA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775706560; a=rsa-sha256;
	cv=none;
	b=NFOuGB0aDo7elx6BCi5Zi8B9xG7985QiaQ+4AfR/NxNmx5X69BDVFCWJcwtLGdV12vy+1P
	aTcNYJY+ylrfdq03Pd+SGee5nT1vTdl/NVaqmdxOAmYECX1WaPhpgEPVsKCcWfjWzbWlvg
	HN+7hBCyN5x3OYuInIyLvSvSJUxxnP0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PgL6J1yH;
	spf=pass (imf15.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 63882444FB
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 03:49:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 430C7C2BCB1
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 03:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775706559;
	bh=5DNUciIRiFPhT3GitLgn8L2T3DcdPnaFe3B+BD+7kkg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=PgL6J1yHTM59k/6lvC/kLrCsx6PNmjuY33+m1LTDDD3Di6dj4LWcpl/N+ab0G92Er
	 gzpZnsTPWezZr8wdCNMbhEvgCqk8D0frdwbMCbr3X5V2ZylJWszc3YTeqVV4V4+WBC
	 7hha9iAHlQoCnCvrTpYy6f2zu/+yCYcWGg3JN/QPKZ5HhHf+QsU2kInZ/fjCOJ/ott
	 DbrJOKLcfxn7lkezyW1h64c67FFvmU+Z6Y9ZPmbjN0sytvc4y8qrF4XPT74hGNRo2S
	 uk7IoM23Pei9yfVZmYcmDC3GNQOTiNoRYAIDKKkFaEezOpQ3IOqptkK6w3+YeVF5Fr
	 gSrhdMVhz1tpQ==
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-8a151012558so5395526d6.3
        for <linux-mm@kvack.org>; Wed, 08 Apr 2026 20:49:19 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWLdIUlPS0SToXtd0HtcVF1CAhjDPFhdf+eeVTM4vVR3aqzZ7Q8EarwM5GnrINX2EHd5FketyqxjQ==@kvack.org
X-Gm-Message-State: AOJu0Yx1nXMDykr9ryD0du+qKbmC4HjVmLmO2iAxI5JBoTJax0m8dZDq
	I0jjzFBS41WSsIKXYEnwz/NAuNl4MTgg+xLdI3F09GowIpZ6XEJ194qjcEURCYRDOXvvUEiEsPO
	27KUthR2ZsAlmw6+jvUP2HcCIuZHlj58=
X-Received: by 2002:a05:6214:19ed:b0:89a:f10:9980 with SMTP id
 6a1803df08f44-8ac7413fbbbmr38698396d6.22.1775706558553; Wed, 08 Apr 2026
 20:49:18 -0700 (PDT)
MIME-Version: 1.0
References: <7829b070df1b405dbc97dd6a028d8c8a@honor.com> <4451bdc432864aebb54f401eee51ea53@honor.com>
 <adUM54W3WYwEFj3J@KASONG-MC4> <CAGsJ_4yZHjSq=d1g7dJC9szwRVLuHqLpWt0Cphi7npzrQz6p3g@mail.gmail.com>
 <adW_O1-QAQadQ68-@KASONG-MC4>
In-Reply-To: <adW_O1-QAQadQ68-@KASONG-MC4>
From: Barry Song <baohua@kernel.org>
Date: Thu, 9 Apr 2026 11:49:07 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wcQTrp-zQ=pj2v5Pa3z_SLs56p+t2OmG6myz7GJdqb2A@mail.gmail.com>
X-Gm-Features: AQROBzCi0WktBv3fB90ur7-Wo3B5z99NIxTu9PhVrMAEXZNR94S6ZSHAsAFuS5M
Message-ID: <CAGsJ_4wcQTrp-zQ=pj2v5Pa3z_SLs56p+t2OmG6myz7GJdqb2A@mail.gmail.com>
Subject: Re: [PATCH RFC] mm/vmscan:Fix the hot/cold inversion when swappiness
 = 0 or 201
To: Kairui Song <ryncsn@gmail.com>
Cc: wangzhen <wangzhen5@honor.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Lorenzo Stoakes <ljs@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	"kasong@tencent.com" <kasong@tencent.com>, 
	"baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 9A5ACA000C
X-Stat-Signature: 3cc7jfbppt9gxqesadpnyzcwkcppugiu
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775706560-464776
X-HE-Meta: U2FsdGVkX19Apz0/X60pE+4jfAm8UM4Zrx2+If7LnIUkuACXvGAGiPyfQ1+Yg6hujI0Umb9GwiDp06/zLTDAyeikegncvCeEJj2ip+ZN1hZQgRiTIKpxeVaPHmhG6/EyIyY4PfiIEmcr+He281K71Orn4x3LE3BxhQrnqaQcCvF+NQdq8ODoUEiWxqxTgMkuEgwECj4JNVCEdcFkx4PkCSSfRVYj6NVf3HfmcLrOH3+gn2u7IPbR9JEjfKkRo0V9uK57KhrCqkZKqU+yYQMuDAwkoBRzKDLMVAu5L1fn+I7d+RSw6Hr4bJpgKTJ2VywHaXdH7iUsvCj7nNI3qTG16yO3YDSPVP6jDiM+R6o8QXUDcXLVa32T4TQfQ0LYEzw3NOOtVjPgwwlGxQfaug0Pybxf8AEIeRbDIDAOmOxPgT4Tu8fRRYdoBKoiy9xaHAdEB8qHJt1kqty+OtWGLjrCSqd2cOk8bqDzbukGOdZ6xErjwlfT6tKtAZ90RKopNatxDzKbQ1gBgoInubOHmR0qdsyWe5mbKvaUV2VzcXSAbu6jfelyVWeUUd5iNH3UoySlja8uRrCal4UIpgivqCWfPLxILGYaFK5L68rqOg9l9Ay8Cm94dtwnSNsiXxBvqzeI+fSR9dNtQeaczlOldCTigKM6TeBNlrKYBIfXaOys3itnCpjfSqNULMRdbfePDnBFPWd2aJ9nHYdrMMzPGiW8xEeWpz77CTuWmlkcM5yEuXX2j3hc/OKM+kAFWOP2Cr9lt/fFWcJkSduZ0tUt5F/DxXqH+6rFvcy2d0LcXh43eX/bnBKpGBKElhy279sq/izqV6uIQmsUs0jDzIUyEZ8SAshKmEzQdO8PTOvtbKxXC1VrnKPzr7Dc8FcOdsE2Kt2DetVRdZsg8KQI7Hdwe9ku0eLMGWRzkv+DLt8hlAiPei8lSotWFi/6OyNUpamkU+7E2InVhucSA1cIQiXv1bx
 /aBB7YvG
 b70kP7KWNX8zm8sNOa68mO1PtZiYiodZcL+vnHUlZ5K6zC5ercC4vIh95YdswlpjMXFHAGii67wcP8rzrUsemukNkk/sQDSN5OLbsUkH5gHNQmK/VL+ODaANm4082f4fM9QlgS/3aIkMCCvgeHcihz/UuBGJ8drUjSttFMGeZlBFzAP9k+qal0XGM1YlUi1k6TZ9U0Yl8uZr+3e0ztQwGxeFJfjamLwr5aYnCmAKSpE3sPXRDuCNL0gOAF+gKRhHPP9u3VGrPqPQHU/qPRLt6tR6jED4wAM0N8T+S07AFpP/c2ehjylRa/Cxu6z2ZvL43VEO49d6R3C/2PEkyURQRQ509NhO+VqwRvaZWetq7Uq7QTDa62YoQyePZcY0r9twoZ4bVBjP0b+OHSfL7c0vS6lAwPw7MHoU8Cn6ylpknGep4ddtWfRnw7gOoHSjYtU2SjzVqmSE3suwgcUU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[...]
> > > Hi, thanks for the patch.
> > >
> > > We have a very similar patch internally, and the result is kind of ba=
d.
> > >
> > > Currently MGLRU forbid the gen distance between file and anon go larg=
er
> > > than 2, which mean with this patch, when under great pressure, you ma=
y
> > > have to keep rotating a long list of the opposite type of folios to
> > > reclaim another type.
> > >
> > > For example, when you have only 2 gens of file folios, swap disabled,
> > > and there are 3 gens of anon folios. Anon folios are unevictable beca=
use
> > > there is no SWAP. And file is also unevcitable due to force protectio=
n
> > > of gen. Consider anon folios are mostly cold (at least a portion of t=
hem
> > > are), now the oldest gen of anon folios will be very long (e.g. 12G,
> > > 3145728 folios).
> > >
> > > Now, to reclaim any file folios, you have to age first. Before this
> > > patch that is usually fast. But after this, it will have to rotate
> > > all 3145728 folios to second oldest anon gen, will could take a
> > > very long time.
> > >
> > > During that period any concurrent reclaimer will get rejected
> > > due to force protection, result in very ugly long tailing or
> > > unexpected OOM.
> > >
> > > So I agree this is a good idea in general, I agree we should do
> > > this. But better defer this until we patch up MGLRU to remove
> > > the force protection first.
> >
> > I suspect that once we can age file and anonymous pages
> > separately, this issue will resolve itself. David already has
> > some code for this [1].
> >
> > Not sure when he will have time to push it upstream, but I
> > may carve out some time to take care of it this month.
> >
> > [1] https://lore.kernel.org/linux-mm/aam5nOyXs1sNdjTe@google.com/
>
> Hi, thanks for sharing the idea.
>
> Right, a few weeks ago I also got info from CachyOS that they are using
> following patch for MGLRU:
>
> https://github.com/firelzrd/re-swappiness
>
> The idea is also split the seq number for anon / file so swappiness
> works again.
>
> However, I really not sure if this is the right approach. It changes
> the model of MGLRU and things like TTL may no longer work as expected.
> And TTL does solve real problems too (also from CachyOS):
>
> https://github.com/firelzrd/le9uo
>
> TTL replaced the le9 patch above in a cleaner way for thrashing
> prevention.
>
> Right now we do page table walk (and it walks both anon / folio)
> while generating one unified new gen, meaning the folios in that
> gen have the same (or at least all older than a specific) access
> time, which is used as the metric for TTL.
>
> Besides, having unified gens also help implementing things like
> workingset reporting where each gen is like a bin for histogram:
>
> https://lwn.net/Articles/976985/
>
> Aging triggering could be a bit more problematic too.
> I think the right way is to just do the aging asynchronously, Yu
> even left a TODO comment in vmscan.c:
>
> /*
>  * For future optimizations:
>  * 1. Defer try_to_inc_max_seq() to workqueues to reduce latency for memc=
g
>  *    reclaim.
>  */

Aging asynchronously could be a separate topic, as we can
do many things in an async manner=E2=80=94similar to proposals for
asynchronous compression. These async approaches may improve
performance, but they also add complexity=E2=80=94for example, managing
CPU utilization of reclamation threads to prevent devices from
overheating.

>
> Then, we start the aging when ever there is less than 4 gens, and
> allow reclaim to always go on even if there is only 2 gens left.

I don=E2=80=99t think allowing reclamation with two generations left
will resolve the problem. The fundamental issue with sharing the
same generations for file and anon is that one type must catch
up with the other=E2=80=94either through reclamation or via what this
patch is (admittedly) doing as a workaround. If we have to go
through reclamation, that effectively makes swappiness invalid
again.

Allowing reclamation with two generations may let one type move
ahead briefly, but over a smoothed time window there is no real
difference, as the other type still has to catch up with the one
that has fewer generations left.

>
> The performance would be better since the is no more blocking
> on aging, no change to existing model, and the change should
> be smaller and easier to review IIUC.
>
> One concerning part is doing reclaim while only having 2 gens left.
> I think it seems OK. It should be rare as 3 gens act as a buffer
> already, having only 2 gens left means the async aging can't catch
> up and system is under extreme pressure so it's unlikely the folios
> will get access enough times to get meaningful heat info, and
> refault will be more meaningful help to sorting out the workingset:
>
> https://lwn.net/Articles/945266/
>
> Cgroup reclaim can do some throttling on that too, and kswapd can
> still do aging synchronically.
>
> Just some ideas, we may need to do some test and benchmark
> to figure out which is the best solution. Discussion
> is welcomed! :D

Maybe we can still find a way to address the concerns you raised
above, as well as TTL=E2=80=94for example, by using separate timestamps
for anon and file pages.

Thanks
Barry

