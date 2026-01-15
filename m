Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76218D3CC92
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 00:41:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9392B6B0005; Wed, 14 Jan 2026 19:41:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BC426B0089; Wed, 14 Jan 2026 19:41:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79EA66B008A; Wed, 14 Jan 2026 19:41:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 689AE6B0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 19:41:00 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1BEDC160168
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 00:41:00 +0000 (UTC)
X-FDA: 84332343480.20.DD12456
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	by imf05.hostedemail.com (Postfix) with ESMTP id 43A1E100004
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 00:40:58 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NlOivHl3;
	spf=pass (imf05.hostedemail.com: domain of akinobu.mita@gmail.com designates 209.85.219.46 as permitted sender) smtp.mailfrom=akinobu.mita@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768437658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8kwQTxZEOGNZ+MI9z8E7dyWDZVVqYLa/Ly/GOaJt7Wk=;
	b=XM8y3kGD+kI8cr2FM9+5EWg69LYSGZqJzlj/hq8TB5NUqn8TQDACKaaZYneLK3ecHoeWP7
	ix5MATB4x0H+buKk8S1T1CVbahorbbRogKeY0xQRq9DLZyBNq1PUGDRoVhiGaOuNqJnFzD
	2JYPMD9aSg1PP6H0oABJxkLaRA8xtlk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NlOivHl3;
	spf=pass (imf05.hostedemail.com: domain of akinobu.mita@gmail.com designates 209.85.219.46 as permitted sender) smtp.mailfrom=akinobu.mita@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768437658; a=rsa-sha256;
	cv=none;
	b=793pIF5hu/f4C/jrcjYttAClKJL103srH7LLtz4Nmqz6PLiWAN/flM2YWwMvKdMYa1zDLa
	Ap+fY7kOY2XyIYwFANKGYHZjkQKLxCNhHa0YwH/Piq/zaXkIijUTbiQ9tI4Eiglx9UI8QX
	qZKkFDQoF591mzZN3r66yqLKjBEjId0=
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-888bd3bd639so3365466d6.1
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 16:40:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768437657; x=1769042457; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8kwQTxZEOGNZ+MI9z8E7dyWDZVVqYLa/Ly/GOaJt7Wk=;
        b=NlOivHl3hL8DLPB0LOaUoqcdn3g5vvs7dbQSddIEEvUNqX6eMnTf5cGRjiYkDXvd+R
         7GPNTDMa6dY/toD+jHTbV6DHoArt4X6i46DnDQ0svmWrdFt+rS8tILFWECKwVWuQkHhR
         70feN2PRucZbc6HVsbOhDk721F+u72PfWqcobT5Sxp+OTu2tYRIbF01YFoiF4o3LNCGP
         7iV7K9lNFH9Je9AzKkfuNtn2uPb/gesfTw+n/5KmbP//cpZXFspkiMCgKe7buxsOaxZL
         z1yHsTHBwuOjqpWy9Yg/nwI2cRxqmEIVG0gB2AdtKvaHYXK0KBVBFvx/aJ9bmBU8KPwY
         YlYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768437657; x=1769042457;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8kwQTxZEOGNZ+MI9z8E7dyWDZVVqYLa/Ly/GOaJt7Wk=;
        b=dbIWI0oRYj9A9Qbwk56Pr0W4V/YFFaQuPnHkwqFVQvyLwhcvl8hjfRv1OtqO/WNhOW
         D4CiIiR/2wy7Z56wxVB6Edt6AiflQKow74bpfUetkxGmu4m7OOF08ANnb8EY0XsvDsQG
         cnWj36R7GYQiN2UP7oqXfh5j1Hcktm/jrY8ji5wX4ituwBmSf0GnJpKFFJ3hEcXPXfpO
         r1qPWSBR8apS/Oqv9+98sEe+X8zgVyMqMU0pMP3xCxAKXvBMb17Ed2fdJlCGJx0WSgZV
         LrWNI0Kls0MpW65Nqp0Fr9mBSFV98mi+mWVvQFEM0An+6PfXh9VJRjFq4e2crI5s9TNn
         WQWA==
X-Forwarded-Encrypted: i=1; AJvYcCVKwlXwpmDnFCv4qZj7aAhje7WppPxPpOHybP1ilhgE/ui2QIV9SXjuqPK/BaYxahPxtAowqCZPSw==@kvack.org
X-Gm-Message-State: AOJu0YzwlSW1dR8efrHNOG0b1w3ZgcCbGQutWMH0X2AOVuUt4Z+VtiLB
	uRbfMfahws66TPcqqpfHSJ0MbUSDRtVhrFEHg+HpQgzfZW2dRCvV+yjbBvdwSqRhyzM2uCX5OYb
	/0aoTqmX93hID/gjTG7RX7WNFmh76tno=
X-Gm-Gg: AY/fxX6DPdJ/cKKzEYYLEQIKN8zBXlpPOLBavZz6OaScQUx2ZjfKWohvbvtG7q0w8Ru
	VEiYYAjo2KMLGs3oHh31Vt/cN5j83uvtV4qwSAQc0DQlAzDY3QqXFRBg8A9If4Jf+tx1Z15uEGl
	F188f5ood9egEEBOQM+dXbYjqselSn17f1BVU64oaUg57fxlmEaVJ8pOKICeATLe1nFjNkxGQ0x
	3yTgXeupgGuuMcQ5SLG7faHXdBrn+1pjMH2ATpixfqYXJD941dZo7A4FsLyvF95uIBrE55loTBY
	zEsmb0X2AWHiWuxUf1HKzrY=
X-Received: by 2002:a05:6214:19e9:b0:880:88cf:59ff with SMTP id
 6a1803df08f44-8939813b73dmr21430456d6.22.1768437657315; Wed, 14 Jan 2026
 16:40:57 -0800 (PST)
MIME-Version: 1.0
References: <20260113081453.8293-1-akinobu.mita@gmail.com> <20260113081453.8293-4-akinobu.mita@gmail.com>
 <aWZLZzo5Hb1aFZ0j@tiehlicka> <CAC5umyib=XmPkTvRT6eAsMx+WDx0NkSP9djh4xkhLJgwk_v8Mw@mail.gmail.com>
 <aWfXHKDzoQBsHxAp@gourry-fedora-PF4VCD3F>
In-Reply-To: <aWfXHKDzoQBsHxAp@gourry-fedora-PF4VCD3F>
From: Akinobu Mita <akinobu.mita@gmail.com>
Date: Thu, 15 Jan 2026 09:40:46 +0900
X-Gm-Features: AZwV_Qgg18kLLSG8crf76_eOaHbqkvkT03IVgWC4bh_s308ae0riyhU-hM237pI
Message-ID: <CAC5umyg+wubKoQSfpDQvNh3K5Y7+iOEYn6_BuKFd53kHDVE7aw@mail.gmail.com>
Subject: Re: [PATCH v4 3/3] mm/vmscan: don't demote if there is not enough
 free memory in the lower memory tier
To: Gregory Price <gourry@gourry.net>
Cc: Michal Hocko <mhocko@suse.com>, linux-cxl@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	hannes@cmpxchg.org, david@kernel.org, zhengqi.arch@bytedance.com, 
	shakeel.butt@linux.dev, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, 
	vbabka@suse.cz, rppt@kernel.org, surenb@google.com, ziy@nvidia.com, 
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, 
	byungchul@sk.com, ying.huang@linux.alibaba.com, apopple@nvidia.com, 
	bingjiao@google.com, jonathan.cameron@huawei.com, 
	pratyush.brahma@oss.qualcomm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 43A1E100004
X-Stat-Signature: iog96xmxcpjk4k6dhezuc1mmdfw83qqg
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768437658-151211
X-HE-Meta: U2FsdGVkX1+JmOAtr0up5gDCOfId1zC7kRKamX1WdhzKXa28H5Blig4gSnizG230VjuEmv2AAY+8smUhzXXJvUZBZlN/upCD8rwF3wpOkrrgX3Bh2k9tfFAf33LXV2cd2/P5tX58tEQWdF4uL6P/hboD0Mk8qi8sJi18jj1DeesGcGRvjFiwkgjuGKkNJk/w5jSRZLshYsyw8C7I0HVNr0lZzdSFsJaQqZL1t7p2dslYesqaQAEq8FUr/I0sb28q2vvLecEfRA/qV0GgpqsZg2ZTU23CXuhbPaOS1y3tyrHElO1HUVJF0bqpKCNReXfeTE7fthIFewik+Xu5QQ0fdn1y8edgnbioh/bl62b8GfAakDC7r2FrK9cngSiCy3GuIx0IR0fYiInCx3HiEY9ycGg7XfsuPPQx66PmZPXbeD9xis58gbfR76MZVmKUoBEIEFuOOt35ruhXEOTLk6gDg3ieOmTl3Eki7ipQ0QoOP0Kme0v9RIqRgX5rj/zdiupiX6MF+aQzsI/k3CvrC/SFU1kOWr+Z51pNMJ80E+7LJrZUPjVFGSXeh7H3fypCeX/xJZ19cASwRsliaMBX9cMCsBvg2h8o8TwYA/2a/hYalmqZ035cT4rge2VppJBcy8KWaAEqhxUhXdl4Zf+pAUFj1uBWnO8xY8IuF0yPbAgK8WnN0CFitAia4UT9VYeTmC4T3jaBgpEFnAHvUJ4DLmDNWGbDz6e9awP5tg3/u5LjqA3pgggoVarnDYvDyDSW2L3qBnov2RY+bgovlIDQV+W52t1hs8fHBo7UL4i3Q9BXv+LI0YgWYSFTpKRPMrkGsHpqQJXNQdfLE3Q95fXFKCsxJQn7B9Ii+FT2HrkUoZqNkQjUi96p9GQWC//xmQLKcPIN6OovMaTEBPoN3VTIWvfHs5qx34ApqZFRKKKX1wfuxaM7nKh+K+/duDoCCA0TuRgi6hss7nKbk1woN3d7kQV
 4lkGHTjB
 hcPaUMqmyXczRFAi7bdAjAIp0CvgQYE6L2pj9tKFyhxqIBVApr6EfUUAuYfy7MOP/e9BsUyi0ojpnmFhv19wO0REbojXzeOpsrd3K+dy+pYsIBekEughq3bJBf2f2RsWUZTHL/KQuxGvcdimP2KBpY5UwHeY5i7Rp6tf7oJCHe2UObJvHZEMyIyTw9rdZaV1a5cQB4+Bpk2niPBJfJ7UduutpJDbNjkzxp9gABUzYxnn6HnWpIJlB3j3zIvb4Aio3Qsnf0UWTeLOY/5AwECUH250v16l/EdYkDrF5n9tk+3Cmsshjht36kpWnby98Uq0Mf5SiwfWF+W/ZQCC5FvXn85LsgSNM6ZqBROA0KFDjqpOOUZvJbURoKsErulSFjym6pwWscOSBmOx1G4ylmpsdUN6oyRqklcNtEG3LRD8Hfun4nD3ZMl7OiDOaUUgMFypdvHDvj8d1yJOaOE+N6kxzHV7P5W5Kck3fPIXdyLvxbjphGbCIB4doy/BJQ7kA/E1RNWgQcxTC504M9KcYtfOaLuuoAV8ljKsfxJBe/+MRRsse2wU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

2026=E5=B9=B41=E6=9C=8815=E6=97=A5(=E6=9C=A8) 2:49 Gregory Price <gourry@go=
urry.net>:
>
> On Wed, Jan 14, 2026 at 09:51:28PM +0900, Akinobu Mita wrote:
> > can_demote() is called from four places.
> > I tried modifying the patch to change the behavior only when can_demote=
()
> > is called from shrink_folio_list(), but the problem was not fixed
> > (oom did not occur).
> >
> > Similarly, changing the behavior of can_demote() when called from
> > can_reclaim_anon_pages(), shrink_folio_list(), and can_age_anon_pages()=
,
> > but not when called from get_swappiness(), did not fix the problem eith=
er
> > (oom did not occur).
> >
> > Conversely, changing the behavior only when called from get_swappiness(=
),
> > but not changing the behavior of can_reclaim_anon_pages(),
> > shrink_folio_list(), and can_age_anon_pages(), fixed the problem
> > (oom did occur).
> >
> > Therefore, it appears that the behavior of get_swappiness() is importan=
t
> > in this issue.
>
> "It appears that..." and the process of twiddling bits and observing
> behavior does not strike confidence in this solution.
>
> Can you take another go at trying to define the bad interaction more
> explicitly? I worry that we're modifying vmscan.c behavior to induce an
> OOM for a corner case - but it will also cause another regression.

I agree.
It surprised me that the behavior of get_swappiness() had an impact on the
issue, so I'll clarify its relationship to this issue.

