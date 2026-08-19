Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1559EC5B572
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 07:00:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 288A86B009E; Wed, 19 Aug 2026 03:00:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 239556B00A2; Wed, 19 Aug 2026 03:00:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 129856B00A3; Wed, 19 Aug 2026 03:00:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DC0826B009E
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 03:00:42 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 74DFA1A036A
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 07:00:42 +0000 (UTC)
X-FDA: 85117121124.27.A3129CE
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6C1F140004
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 07:00:40 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=EzqnbiPh;
	spf=pass (imf12.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787122840;
	b=8hs6EUvk/2Wz8idOGVkKzEU/taHJUR5BXYdQwR15kn2arwtCtzCTCtwwUo12ZrA30n3VCE
	XXijdXT9ZzIWXinNfVne1hE0iwTEgJ1cl0rWhme4t4G+OrsTxwElXCh3SCYLktX++1+JcJ
	aFdE6+XehVtQGp3Em9jMYmoJ7NG1iAk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=EzqnbiPh;
	spf=pass (imf12.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787122840;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cwVITkOSrTqTzud3KhMHcX5dBYEfTruNyXr6qoqV70Q=;
	b=NaX15hfPsaBuKEd8voN8g7plA5hXBuzghUKTdDtb/psHCY2viPALSqBui7o54fHRFNQtDp
	iOzBAL0qqp0/a2JguHWIOjxJTOT94uz1PY4KzMhtVjquo2pNuxpfpd4VY0YPuMpTcgV93/
	BA3GbAXv8sAKYy+DnpZsAlOw1bkuNNQ=
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-47f703a9d05so418111f8f.0
        for <linux-mm@kvack.org>; Wed, 19 Aug 2026 00:00:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787122839; x=1787727639; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=cwVITkOSrTqTzud3KhMHcX5dBYEfTruNyXr6qoqV70Q=;
        b=EzqnbiPhnTOyB9xskDhcyuqQyERrhAJ0wzzM59StquwNFQpGgrNoAxsOXUBTJMhz7b
         ZEKpE2CDA9eS69qvmrt4bZmnGgZsei/TOIW7gHdI7sef5pSOeVmLXUj2EnbGpg5F1h9T
         2kZ2of0XmR4bW0/9lmDS98V8J0QhSzFblr8jBFI/rrmsyQbYIRI+/kWHHBOI3zoAD3HO
         A7X0BOPSBPLf0g9NX96bMbc8BYlOLrtJSakABsGoYrHQLlAOYGo9xYyikJCpjs/KQMI9
         +0qU0ub1uetCAogevZoz/aYhpqm0edHugRvG1Ntm1Wq7DkHUBANoA6bNxKm4p+hsPBBd
         VUHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787122839; x=1787727639;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=cwVITkOSrTqTzud3KhMHcX5dBYEfTruNyXr6qoqV70Q=;
        b=WZgM1KT+CC56V08pwYcKuXaES+PmzqOoxYoGfrTTJ0nzNxnWgap6aoTaTv3xSZv0QB
         FfnLQbbCKx8ym7bcE1WRTCBavKvw3DFHPfJo6B70yebHVTR92X1CrnTZ4wiBgwRV8djp
         rtOlAwiNh9/xm6hP1jOZ5aMHFiFjeikj3MfoNe5Qrczn1ALOF4nozrpR0Ttduzq20VCS
         iwuzs2+1PwhDFLCQqiC0JThYuBGKqPkEJNFw2vbrOgOQUpLdxUTUcXEI2uJSJTmRqQ6K
         Nb4tifUxzCN5KKNlnPpbRduq0tseJGYmd2wDttUi3sqhhe5ScKPb0PLQ+qLQF11/Nkrs
         6egw==
X-Forwarded-Encrypted: i=1; AHgh+RqxvB7PRAd8x7WH41ocyE6/wHgyiXNbXMVgdmwW+9JQs/+QOXGPdCVDDVOEIfFw8U5Io+fEEj5wtg==@kvack.org
X-Gm-Message-State: AOJu0Yx+vJcOVpXsgSFnhIjPmBaP+t04d3k/pNc/Hnixhh2EZkuTOors
	+rCduv0ifQyCs8jBMWmnKE/OAY6nOHbSZ07OieWYT4bS9qfjciRHilhDBjFfbWr+VT4=
X-Gm-Gg: AR+sD10eyM3JPCPQ5ZPpqWoycDIOuzvOBuDfBD8HCwKDqqSLbVuKJGiUiRybGEQMR5I
	KQQa+/o0fcpaD09Q+WcPurCQ+ZphKVPx00hAoeTA13ZJ9oSUBwz9xpRQwr3Nu8mU6+574xy4VUE
	yejcwsbsKm77/70lsSLHunQepnWepsYabY6pl28Bj5OQzYDponKrjD1SJJ2kS0spqJcu0xiSa9w
	ZW/c1vIiTnQc1YccHBp/x3WZBim0k+bRPMxJw2vA6DIA2mf38cwEAzOqL5K0HqMJxel/NdyVhNr
	ysOX6zAwxvCz7uLrIl/+Rb7ZQ6kx19sxEacTK/8DZm3gk0KPJljcegdo3eSORWcQ16eAXrHaAz5
	RbuT2kfuq/c5fc2VgFxYywwfv3CnXg+j+E8qU5i+4mg8EBtzEL5r71Dmg0rNn3DUIW4xsIiG8BS
	VaRcejowzsMnw/hV7mLKeS80gwbuk1kjcQHRSTC4PoDLr3BRdeqamfQlFT6bKsrIskdq4KiOS2n
	Q==
X-Received: by 2002:a05:6000:2c10:b0:47f:cb39:10c4 with SMTP id ffacd0b85a97d-482b1fd9f1emr3054734f8f.12.1787122838407;
        Wed, 19 Aug 2026 00:00:38 -0700 (PDT)
Received: from localhost (109-81-87-166.rct.o2.cz. [109.81.87.166])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482b14d9783sm3392406f8f.37.2026.08.19.00.00.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2026 00:00:37 -0700 (PDT)
Date: Wed, 19 Aug 2026 09:00:36 +0200
From: Michal Hocko <mhocko@suse.com>
To: Tao Cui <cui.tao@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, akpm@linux-foundation.org,
	linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, hannes@cmpxchg.org,
	roman.gushchin@linux.dev, muchun.song@linux.dev,
	Tao Cui <cuitao@kylinos.cn>
Subject: Re: [PATCH] mm: page_counter: reject empty string in
 page_counter_memparse()
Message-ID: <aoVUlFdZYLFn_gvJ@tiehlicka>
References: <20260817042652.74136-1-cui.tao@linux.dev>
 <aoMzchLCCz5hiFHp@linux.dev>
 <aoQNtIRvqXRh-x4u@tiehlicka>
 <aoRz72_zdMai_RNV@linux.dev>
 <aoSLxSBUPbEqimJq@tiehlicka>
 <9bd74181-2ce4-4d69-a353-614685559ceb@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9bd74181-2ce4-4d69-a353-614685559ceb@linux.dev>
X-Rspamd-Queue-Id: 6C1F140004
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: kreqwhkainc9fte5hgzha88whipqceiu
X-HE-Tag: 1787122840-841132
X-HE-Meta: U2FsdGVkX183Sp1jhLa3RwtuKwWe+tmhsVoRBfNivk55pA3yRoq1S6EKFx1Gnv+GyWrl0Vn/bWvCGjucpmG1J30jqXiibVT9ZZTSY+M7+2cKA8hJsNU+ScJM4lWXWeMA/tSWw7ir2DOaurNbJTfjQ+uHYIdo2zBgmPZ8sa3KFCPTiYkIbxNWnxN/PUmeFDcWjlYPQ2FAaDBhL/oQgibHlB2u8wHPC7HAeDzUg+tnq9s6RiHpDCfByE/z/xjVFAH/Y9azw/FAQKFu4jLVZ7TvWhKkR/EIQjT0GADmbU2chDRBy0+EinVJF75dzhEScScjVoPhDeIuI7k073ommUcMrQCjh7iqC5GhxqpPeJMvm2JKN1i29fEhVE1J7ta2oI2Yn3geFdCRRTdTdwm9h+NAg1galomP33WSpBRcs8CEhOs4DpD6r4QEzzUUC0A6enjN/CNiTxT9ItGfaLl22KrHRfKeRsUflxOposR/OUw1mMPfZQE1L9PuyNxgtMYj7dRCR/Xh4WRVF9xWxolVmRwYzewL2fq50ryYYDvqsovovqZ22Ee44Pv4pzsS5/ulgQNZvCE3+O0LZ3vIATekw9SCnYALXJE7YL+FyChlIUcHMHYXiVmu9Xm3urMZwCrbTuN3WIxIIDUFLg9AVap2GGYnbjizLXgeVs5me7jC0NEJaGo4M+DZ21+NKNj+mlS9Wk1MIO7X5Z8RXoIkgVUjwMWblZKH9V8J372VoFeZQORPsj1XnFjq4HP1yg7LplsOKfNnMeN1+7I1eMvcMRNNhG5xZlB0CvlFhQS5jfx2ydNtxZJ+wXV0icKsn3rseb38f4Iq3sbK7SHWJN6T42ZHsFki5f+aFDvfs3jjinfcgAhIPYUhAmcI7Wc4gqeF2SadmJQQz8Bh1jRPwFb8Zgw8CZTvzXlnWoVThHFCaH2M7ms2Y7sIH6SDc8LKf/v4xQLykm8ioKqBm4c7+Wgpcj27dUg
 xj7oluGc
 7zOLphSt902gA9DGz3sYoXL2DPCQEh8MDXAZ+ALwiXt7TVy+OefJR1ebfXNDzWwPuRjeQw+NJPdE8YUzpyPJg7SZcPuCpwO0T3zoxnbHbabVHWhwTrvnqGLg/qM0CQdDcwYD7pAkM6aGjdNGziSHs3fzk3pVpZnsxXWAm/2x8EXCmGv5DUL64mJ2bRQ0b74GE1/eUFFWme/UooJzEk7LMBJmmwKTcuP5yfZ0x3u/UrDyQQ2EjqI9I6OXqRy1Sx0bJo66mUvpN21ZSpKL5AokXWfePm8JnhF4oQ0alxIVngBlJ91zJgUPhroA4151S5hoKsUY83CmAeJZoOZCuw5Cj/8TvDiGXac3b49CEHe8hIVj2zp53dItwUzOOuNQ1swCdpnpnysTw0cJRIOdRNyYPRvMv59iVeXzNx7tp4+2GyT1OU5o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 19-08-26 11:00:09, Tao Cui wrote:
> Hi, Michal, Shakeel
> 
> 在 2026/8/19 00:43, Michal Hocko 写道:
> > On Tue 18-08-26 08:06:22, Shakeel Butt wrote:
> >> On Tue, Aug 18, 2026 at 09:45:56AM +0200, Michal Hocko wrote:
> >>> On Mon 17-08-26 09:16:40, Shakeel Butt wrote:
> >>>> On Mon, Aug 17, 2026 at 12:26:52PM +0800, Tao Cui wrote:
> >>>>> From: Tao Cui <cuitao@kylinos.cn>
> >>>>>
> >>>>> memparse() consumes no characters on an empty input and leaves the
> >>>>> end pointer at the terminating NUL.  The only validation in
> >>>>> page_counter_memparse() checks for trailing characters, so an empty
> >>>>> input slips through and the limit becomes 0.
> >>>>>
> >>>>> All limit write callbacks of the memory controller strstrip() the
> >>>>> input before calling this helper, so a script that writes an unset
> >>>>> variable hits this path:
> >>>>>
> >>>>>   LIMIT=
> >>>>>   echo "$LIMIT" > $CG/memory.max
> >>>>>   echo $?
> >>>>>   0
> >>>>>   cat $CG/memory.max
> >>>>>   0
> >>>>>
> >>>>> Nothing reports the mistake: the limit is now 0 and the OOM killer
> >>>>> goes after every task in the cgroup.  The same happens for
> >>>>> memory.min, memory.low, memory.high, memory.swap.high,
> >>>>> memory.swap.max and memory.zswap.max, where 0 silently removes the
> >>>>> protection or disables swap and zswap.
> >>>>>
> >>>>> Reject the input when no characters were consumed, which is the one
> >>>>> case the trailing-character check cannot catch.
> >>>>>
> >>>>> Fixes: 3e32cb2e0a12 ("mm: memcontrol: lockless page counters")
> >>>>> Signed-off-by: Tao Cui <cuitao@kylinos.cn>
> >>>>> ---
> >>>>>  mm/page_counter.c | 2 +-
> >>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>>>>
> >>>>> diff --git a/mm/page_counter.c b/mm/page_counter.c
> >>>>> index 661e0f2a5127..d14db705b04f 100644
> >>>>> --- a/mm/page_counter.c
> >>>>> +++ b/mm/page_counter.c
> >>>>> @@ -281,7 +281,7 @@ int page_counter_memparse(const char *buf, const char *max,
> >>>>>  	}
> >>>>>  
> >>>>>  	bytes = memparse(buf, &end);
> >>>>> -	if (*end != '\0')
> >>>>> +	if (*end != '\0' || end == buf)
> >>>>>  		return -EINVAL;
> >>>>
> >>>> I wonder if someone started depending on this behavior. In that case it is
> >>>> better to return error instead of silently ignore, so we will hear complains
> >>>> loudly. This looks good to me.
> >>>
> >>> This is backward incompatible change and I am wondering why should we
> >>> even risk regression.
> >>
> >> Mainly I was wondering if this is intentional or unintentional. If this us
> >> unintentional, can we fix it without anyone noticing?
> > 
> > My guess would be this was just omission. Those happen and over years we
> > have learned that userspace is quite creative at using those.
> > 
> >> However if we are ok with this then let's make is formal and make this a
> >> documented behavior. I don't have any strong opinion either way but I think you
> >> are saying it safer to just assume this is intentional. Fine with me.
> > 
> > My main question is why should we even bother to change this in the
> > first place? Is that reason stronger than a theoretical breakage of
> > userspace that we might learn much later?
> 
> Since you asked "why bother", here's how I ran into it.
> 
> The patch actually came from a production incident rather than a code
> audit.
> 
> A maintenance script on a cluster accidentally wrote an unset variable
> into memory.max of a workload cgroup. The write succeeded, and the
> workload in the cgroup was subsequently OOM-killed. There was no
> indication that the successful write had caused it, so it took quite
> some time to trace the OOMs back to that script.

Understood.

> When I checked the documentation, I noticed that the cpuset controller
> explicitly documents the semantics of empty writes ("An empty value
> indicates that the cgroup is using the same setting as the nearest
> cgroup ancestor..."), while the memory controller documentation says
> nothing about empty input.

yes, this is really unfortunate and mistakes like that happen.

> I reproduced the same behavior in isolation on a Kubernetes cluster
> (v1.29, cgroup v2, two-container pod, 384M pod limit):
> 
>   # LIMIT=
>   # echo "$LIMIT" > $CG/memory.max
>   # echo $?
>   0
> 
>   m6demo   0/2     OOMKilled   0
> 
>   oom-kill: constraint=CONSTRAINT_MEMCG,
>             oom_memcg=/kubepods.slice/.../kubepods-burstable-pod....slice
>   Memory cgroup out of memory: Killed process 339529 (sleep) ...
>             anon-rss:32kB, file-rss:452kB
> 
> The process selected by the OOM killer had less than 1 MB resident
> under a 384M pod limit, but the empty write was accepted as 0,
> immediately triggering a memcg OOM. From the caller's perspective, the
> write simply succeeded.
> 
> One caveat is that kubelet reconciles the pod-level memory.max within
> seconds, so the window is short there, although container-level files
> are not reconciled.
> 
> So the patch came out of that incident and the documentation gap it
> exposed. My thinking was that rejecting an empty input would make such
> mistakes fail immediately instead of silently changing the limit to 0.

Thanks for sharing the story. Next time I would recommend to make that a
part of the changelog.

> Whether that benefit outweighs the compatibility risk is not mine to
> decide.

And I am still not convinced. I do understand your frustration from the
debugging the issue. In any way, if other maintainers decide this change
is worth I will not stand in the way.

> If it doesn't, then documenting the current empty-write
> behavior, similar to cpuset, would also address the ambiguity that led
> me to investigate this in the first place.

Agreed!
-- 
Michal Hocko
SUSE Labs

