Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB5F5FD875A
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 12:32:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6AAF6B0005; Tue, 17 Mar 2026 08:32:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF4706B0088; Tue, 17 Mar 2026 08:32:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BBCD6B0089; Tue, 17 Mar 2026 08:32:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 82F9F6B0005
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 08:32:37 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2D153140116
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 12:32:37 +0000 (UTC)
X-FDA: 84555493554.27.18DAB49
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1035F140002
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 12:32:34 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NHUg8IOH;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of huangzhaoyang@gmail.com designates 209.85.208.171 as permitted sender) smtp.mailfrom=huangzhaoyang@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773750755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NicPt9jnJivy+w70YSKbxzwwREOsgRwHT8KPVkEKqFs=;
	b=xtKwXkbl9yjmqH6OCLkyi0dke2j8qp+GsLEFkkMEdXsBDJY2jdHDuK7+9/ah9pXFaSw+fr
	5OWO1fHyVIiMFt3vNczno9ehm048jdc/R4hGOfdLJfJybJ9lyQPaqiP/+VkZaXmlokEzFd
	TkmFH3XTZkzvZD3AFWfMdRTHJKBFLL8=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NHUg8IOH;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of huangzhaoyang@gmail.com designates 209.85.208.171 as permitted sender) smtp.mailfrom=huangzhaoyang@gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773750755; a=rsa-sha256;
	cv=pass;
	b=DuRdncfPVgiUOh6fDk0hS023Jl7wD2E9rGnQL93LlG/vXOQE9HuUfZyFHRWj+dSy2jHoYA
	LVIvJMXBKqymLoZJfR6ncZ9nE7OaGmiZ1Wg/kzBhKoyoELdyrxX9nLtGdTogQ5WLkZd0ch
	ePhkpFTsqugiuZcwiUS6OaAsOS/2nBI=
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-38a3c2261ffso3489141fa.1
        for <linux-mm@kvack.org>; Tue, 17 Mar 2026 05:32:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773750753; cv=none;
        d=google.com; s=arc-20240605;
        b=Fi40BtJl3YquykOsxu5kpfx7yKskYS7wLnq/2viqPbvalHcoCykyzoHdwukpWZ+ndn
         kce1cYn69aPFWzqsoW0W000GF4+h+nqHX7sgJnnXEZtpEb3eoFmNszZyXCFukoQyJLbk
         ZZ0RFD7iYGhLPkcXxMGSiHUbZQFkTQKqRPuvFeB+Wr6t/EXeXXJYo4SgN11qqALaBd4v
         g03SQ8sp9K8kn83aXnixbhjtibjS0aZ/dEWj0PzDIQJZX3JJokN+Dh6OquwhISz2OaB6
         JGBEralI/j8yweeUtTK67ogSysg++LSRRwri8qSsmT+M/zp5N5Vu5Umf3VW9EkWy28wy
         X4WA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=NicPt9jnJivy+w70YSKbxzwwREOsgRwHT8KPVkEKqFs=;
        fh=4G5CttG06pmRaIcF9+wLpAnxBAFNTcWW1j9bn+31imE=;
        b=Wf/9fuDG9l/lYMTgTNnAbhA9s0MgJ+pGUMzxRQQU6fMFgY+ZNFiExSfjK7ebr3LvLs
         5A3VdfV7YJcY0/05OjU+lxhIp1usItrScQJVP5kVSoL3YP3hxd5bAgeWcXmSSVj90yPQ
         mhLkrxAGueYdP2SQ87OS13bvWHTXofkdQuYPy1y644qtUmc1ASsE72Jon5LX6/Wky5cu
         MmSFEXGtjuT5HYvovFycUBdA0WoBaGSh9v/pKl99f5bm7JZ082Hh9j7ykJSt8OE0Dc9t
         HW7ChGOZSlZMnP3s7Liopu0pFnxCJ2QsKXqvUmB/OQqjFMzZslE6GNTMc09Nw9TI8EHf
         6xRg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773750753; x=1774355553; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NicPt9jnJivy+w70YSKbxzwwREOsgRwHT8KPVkEKqFs=;
        b=NHUg8IOHgokRKr+6lqqM/5tJ6qH9nv0D0tmrUT8j0uUghHDgU15nUVfDsgs7IwYm6Y
         Gys32G3QJjhymd5fi2cM1/4+JTta/K6udUrW9zFoxOAZAi79OeQxEfAJJxH/V/28O/wg
         U3BvZBYYRXH8rS5D18wR4ZbemDmMRsEwPJUffKOPAgiENoNd2sNijeSsuOEhG+sg1JQ9
         xTt504h/BJjEVplgYydOZEhbZ347+y53inLJAjAxWJMDYmGwM36YjHCwrhU+r7+SJ9Hc
         D10kmnuyxTuEu3wghAZPa9fkVglMg9M+K39xCV+jgP4zRJkp3pLx3pByNNkOiDMSBO+1
         jpHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773750753; x=1774355553;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NicPt9jnJivy+w70YSKbxzwwREOsgRwHT8KPVkEKqFs=;
        b=WypXAE8BCNek1Q/GfEo2YrF66VQi+VVzpbSMrRW/ohOs4fYezeuW1Zrq0tZZ7os0Ts
         jxpVIBjVKhbyKvzjHZhOmPfZV6/SpG22H403uAzfv1hGpUbe4yNE52z716DAS3EuHtcX
         C+tcrEy5tX9j8ZjELr/GG3dD0SsSBC2kxPaLMrqPYgNo9fCfmPosDBDqnIa0Or/LyGc5
         DpaL0pTFplNYEkHgo36G6j+Q1xkS1i9BE6U7gLDP7NIeUHK664oYRDDk0f6OJDP2Kv4d
         KJvojqLLSc0g0thcJo3HOIJPrTVo27nVGzSlSlLUGduXxuNSzGVN9DuH8t9sjDvnJNNM
         6tVQ==
X-Forwarded-Encrypted: i=1; AJvYcCVNIbtG/C9ziwpw6DsoqiJm/ZwnLnpEXvGX+5tJ+mFukmo6klIZQn5Nar4glYV++oZF/yYgBwkckQ==@kvack.org
X-Gm-Message-State: AOJu0YwDlKUdBdiiV1EWHDkr+E3t+RdVB9yZlde2wdpW3vS1707/lPmP
	2SlD39lG2vTAXtxzZEEQCS2fCqliE/2wRwFNJZs89M6cZK+2rr/UFWQ4Hl1tLhhjnOHRS9tKuq6
	Waov0OhETGJhdqVwChJaEfspEAcRqUfM=
X-Gm-Gg: ATEYQzwRHMfCsatM0oEScs558a5hLsF679zBgaBJG+CpTnFxAf2Y44DsisMl2caxp4e
	S02P/vYyMFgCzOumEG8zsVeDy4FJzwmp8tbTOCflRWrRS5cn4g4HTQOpK92btqY+YTIEFWss6Rt
	v9d8lygharjBrcJxBn0SEshqdHXqi0OMZW7zxX6pb6H9yLAVHXlSaCFSAzfL2/jPquPOqPqrj/I
	bW/ZZ8+tx0mP1ICX8hgJ/Ninqa0QBr+66ydGzQVKuGXbJ9ujspDZDJV7uVS+YAZc4a46rLnkt6z
	69ZoEhAG
X-Received: by 2002:a2e:be21:0:b0:38a:3473:526d with SMTP id
 38308e7fff4ca-38a898ad823mr29892171fa.7.1773750752675; Tue, 17 Mar 2026
 05:32:32 -0700 (PDT)
MIME-Version: 1.0
References: <20260212032111.408865-1-zhaoyang.huang@unisoc.com>
 <abhh3lKb6med1LSp@tiehlicka> <CABdmKX3NUZCq7kq5PGWOUs1Wmu+aT+EfeMpcRxD8PxiRe2si0w@mail.gmail.com>
 <abkII-1MZ0kTjV2-@tiehlicka>
In-Reply-To: <abkII-1MZ0kTjV2-@tiehlicka>
From: Zhaoyang Huang <huangzhaoyang@gmail.com>
Date: Tue, 17 Mar 2026 20:32:20 +0800
X-Gm-Features: AaiRm50aYlamLmgZf6QhMoNgiY7JxV_cXY-cw3Uw4ZQhOxpzBA0CwVRxboCZXUE
Message-ID: <CAGWkznH2gW+G=DJWXksnzbxcYWHAj8REoPtFtsdj2doevTPsQw@mail.gmail.com>
Subject: Re: [PATCH] mm: remove '!root_reclaim' checking in should_abort_scan()
To: Michal Hocko <mhocko@suse.com>
Cc: "T.J. Mercier" <tjmercier@google.com>, "zhaoyang.huang" <zhaoyang.huang@unisoc.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Yu Zhao <yuzhao@google.com>, 
	Rik van Riel <riel@surriel.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, steve.kang@unisoc.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1035F140002
X-Stat-Signature: jrzfctgnym1a4hp46cs9g9ebm1i4un7y
X-Rspam-User: 
X-HE-Tag: 1773750754-443080
X-HE-Meta: U2FsdGVkX19IXEJBoCzd0VtoVY6caFwZmEGsJyb7EiIAclsHngXe3hXhSfAPWroZda7BCwTFD/3+ni9nULiSFNmK5PxOqK9KnTkqvv+ewxKUoQn8orba0qOTmgz52I6PPOB9CdZtnBccsgNmmbwuF75T6uLCaTqiyDENVGX9vCUzxBZgBf5DvMYW+UDuKHjEr79R7622IokdAtDzdRtLJT2rxvwFvKdpe6NJbeomuHg0R+5bBeKfUR/AVZRfKqpf2Zhm1hHKfuiwQ3GKrIoJeOPSGu4vOJOxdVbpNNvjJnSmh5R56axHttHY/KICI9vk7CsKJFelKtXXLbYEm6FNhxaUXsGHg2myMOPozohRbJ7ItEj586mbZhWEt0EOTdJsELlDxpZ85t+xg3YgpLYNFOkgPwAVw3Rxt+HWJfzVg/xdCa1XPo/BOuSbqQc4hbBbPjhay8oom8ebdU2hLNOHqB3CPGyGhBh17woqfo5AVAM++0mjyI6GbwGg39hy5REmxac+R37k+W1spKfAFQtkgOz4NKE4zZR7Y81BPBCthS5/XppeHF1rvqGsBZHljgs/qtUGKKV+FyRvQaZl6vAcPTCdzM2c9sM7ScKFFVgIMuzVbNwq0ZlMsW+7+V/HVwQLZT8zOFVfogRTMBSFS86mbQF2nM80MM+z9V17K5i24ybYZ66LmTJuQv/sdcsdyFkJZkkuIQ6gN6og6CC116CUp0mX9uva+kHVxVr7vqkHRPrSwJgQaRACX7sPd7oL9kUshlkqSKD1rnLVzSiqk6Y/ZFPaE8GqPIkydyaauHAuf7TaB7zU83+rTN2k+uBLocIk4xNPmLV4aWJR/kFJGuu+oXYxNlb//egJDLaPLKoBaXrUxWZNlGBDtLkIEQHrBxQ4nLMSgo4ZJLFr9DkVNr4uwV1DXT6x4JCvHXIBGwS8/OQan8NcOYEY79FJATKyWEmZmmoWnkSOY3yNtagXqu2
 Id9VPvir
 2T9ZNCzSoielAnv5DzPpNVY7pTmlvqd7axGRu7YqZ48F4JCaaASQ6COmPcVLKykRD6MHATQMP1QndUfVxzJSrHHHcchZ/kgrCH9Pa21a8wrrEjNmmqqQmAJfRTTNI6T0XaDwcginpwWS09iyW02/YNCAjqOFehxTZVJcWgiMCsWpG/YAY5ZqwoQeWx47ilzG2XFzpaFAC5JkywnsUIh59btpNlQMeptPMZQTEJaI0MSSS/DkOF7DJ2h2YYYq2vHtvsHOeM70yVpt5k4XuyEmuj1dfMAiQFIMxtaSze8yrs3PAPxfhjES+2KQISYOeuYtc6BJIadSDJkhxPjbYBbsstYAl9an+RRj6rewxI9Ln8LvB8N78+hkkDu9JplXRNfzQiaSxQXu2G8M7f9F1wTzcpcLRUBHix5aycLJvYQtasH27sWUMXCN25BI0mMbz+JPiP3L00Q3YZDApUO03CMk+zTiqx6HqZkpGmUuZEmHIWRKrCtKbzMMOG6cmq6OsDwnAEExNSgjH3g3717bxGzdsn7LBW+qZgLVtbkJ16ln9YXna/KaIdstH7sMV3kF9Fjbgqq/hNWBkNnBCtj+G6MfCCrS3E6b6HCl76PlKaGgoFqqYE+jD1BkLB5X1dKmKMrgPlAII
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 17, 2026 at 3:52=E2=80=AFPM Michal Hocko <mhocko@suse.com> wrot=
e:
>
> On Mon 16-03-26 14:09:52, T.J. Mercier wrote:
> > On Mon, Mar 16, 2026 at 1:02=E2=80=AFPM Michal Hocko <mhocko@suse.com> =
wrote:
> > >
> > > On Thu 12-02-26 11:21:11, zhaoyang.huang wrote:
> > > > From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> > > >
> > > > Nowadays, ANDROID system replaces madivse with memory.reclaim to im=
plement
> > > > user space memory management which desires to reclaim a certain amo=
unt of
> > > > memcg's memory. However, oversized reclaiming and high latency are =
observed
> > > > as there is no limitation over nr_reclaimed inside try_to_shrink_lr=
uvec
> > > > when MGLRU enabled. Besides, this could also affect all none root_r=
eclaim
> > > > such as reclaim_high etc.
> > > > Since the commit 'b82b530740b9' ("mm: vmscan: restore incremental c=
group
> > > > iteration") introduces sc->memcg_full_walk to limit the walk range =
of
> > > > mem_cgroup_iter and keep the fairness among the descendants of one =
memcg.
> > > > This commit would like to make single memcg's scanning more precise=
d by
> > > > removing the criteria of 'if (!root_reclaim)' inside
> > > > should_abort_scan().
> > >
> > > This changelog, similar to its previous version is lacking details on
> > > what exactly is going on. How much over-reclaim are we talking about
> > > here? Is this MGLRU specific?
> >
> > Hi Michal,
> >
> > This came from https://lore.kernel.org/all/20260210054312.303129-1-zhao=
yang.huang@unisoc.com/
> >
> > Zhaoyang would have to provide numbers, but yes this is MGLRU specific.
> >
> > > Why doesn't our standard over-reclaim
> > > protection work?
> >
> > "there is no limitation over nr_reclaimed inside try_to_shrink_lruvec"
> > This means that for proactive reclaim the check for sc->nr_reclaimed
> > >=3D sc->nr_to_reclaim is skipped, because the !root_reclaim(sc)
> > condition is hit first. So we never abort based on the value of
> > sc->nr_reclaimed, which can lead to overreclaim.
> >
> > For try_to_free_mem_cgroup_pages -> shrink_node_memcgs ->
> > shrink_lruvec -> lru_gen_shrink_lruvec -> try_to_shrink_lruvec, the
> > !root_reclaim(sc) check was there for reclaim fairness, which was
> > necessary before commit 'b82b530740b9' ("mm: vmscan: restore
> > incremental cgroup iteration") because the fairness depended on
> > attempted proportional reclaim from every memcg under the target
> > memcg. However after commit 'b82b530740b9' there is no longer a need
> > to visit every memcg to ensure fairness, horray. The problem is for
> > large lruvecs, the lack of a check against sc->nr_to_reclaim inside
> > try_to_shrink_lruvec (caused by the continued presence of the
> > !root_reclaim(sc) check) can cause overreclaim. The non-MGLRU
> > implementation in shrink_lruvec already checks nr_reclaimed against
> > nr_to_reclaim.
>
> OK, this describes the underlying problem much better. It should go into
> the changelog. Including an explanation why MGLRU cannot follow the
> traditional reclaim bail out logic.
Patchv2 sent with commit message update. Thanks
>
> Thanks!
> --
> Michal Hocko
> SUSE Labs

