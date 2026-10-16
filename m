Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25BBFCCA464
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 12:12:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 284F46B0095; Fri, 16 Oct 2026 08:12:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 226C26B0096; Fri, 16 Oct 2026 08:12:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B0886B0098; Fri, 16 Oct 2026 08:12:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C9E6F6B0095
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 08:12:12 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5CFCB1C3A3D
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 12:12:12 +0000 (UTC)
X-FDA: 85328376504.04.55EA720
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf05.hostedemail.com (Postfix) with ESMTP id 64565100002
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 12:12:10 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VirRytr2;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf05.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792152730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6t2J8EE3L3nlE7G0BZMfNQxPefv2h/6dn0nY1OvRibM=;
	b=kt5X2GSo1r0LWK1FpmTipahRF7KG8a1e5hXZiJUj6w5ZlIrJ2fRiJ9Di1jj7WMIDG9DVbY
	l/O6LZ5Sdm1nQ3y4qci2RD3zaWr7UUfJc7mqTjLx6CvdU5OY8IAvjkIGVe9Jzkz2Qqes/U
	04kgwo3AgrQe/yDaiYF4kCCDNLo+7Lc=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VirRytr2;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf05.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792152730;
	b=LU+mlBQyb4cBO8U/ulnk2UA2L/FShu0MKwXT5744ANFTLEuy9ibliXWWYq2npR6NgotNHY
	0aBBLox8/2HhGH+HbibiVJw4242wLe1MB7xNq8q87/AnNHZRiSe05zirIoV1mgSSafHkvb
	VZ8Q6Zxl5HSfto+zH9Axw3AgWynifno=
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c2e69aa07c3so472716766b.1
        for <linux-mm@kvack.org>; Fri, 16 Oct 2026 05:12:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792152729; cv=none;
        d=google.com; s=arc-20260327;
        b=klNw6B+8FZtXgDLEJTK4us2nhsSLMj5AyfnFPnlbeZaMXI7gjEeGSuA35iE998z0yl
         uKUvnZOquKSnNLNq6zfS1CAKrIqIVvvwgd1vIw5+4FevC7FytGQ7TmEy+VO9gO3UG+Uq
         yL746X+5VonTg124AvNLbcBjIls3nagikJ5Ct1Xp7fl1ZZ05YD/RfHsoO2hmOPa83C5f
         gVDIdLzc8zVLbd379kPndTG0w+o9oIDHVNZY2umTApsSIvyt1JTaNUG97FFEoV0ZZdVE
         AE4JFQdOWo6NqkTLc8fOwgHVh5GalzYlTk377gx8KiR4SNpnRk7HmcBmmxNCvb/raiDZ
         ci5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6t2J8EE3L3nlE7G0BZMfNQxPefv2h/6dn0nY1OvRibM=;
        fh=PgNtgxP/SX5VjCwudyYGoax+86hhuBdUIf/IRhtEjlk=;
        b=eVugnaBml5PH8C2LgArvHnnquoml/8SWgy4YCg5gcjx6lJbYBJA1BctYXjY5bvGJLt
         bMoPMCZviQ1YhJL771fS7CEtAa0AJWgKPIRxbyZz2p+GKkX/vUUHCtlh9NQlifi4MXlC
         yibwB/5WMxeR3tgfq9tgamzhoLlNWhv+PnBOYjh6j2qh6QFd3duKr7hCJv00HNWiHbI4
         41uviyuYjQcij8YHCZF41JHPOz/fJrto2ozo1AH82OMeXDKnmr0hTA5/oWUdM/XuHR0V
         n/D94RhSaYCcyZgcmPZvAyfWSFBLBN6/XVTzecg0MVwDBsz+kkT+glVwbCwOGyhwwdM1
         hbLg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792152729; x=1792757529; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6t2J8EE3L3nlE7G0BZMfNQxPefv2h/6dn0nY1OvRibM=;
        b=VirRytr2rM0WLH2+XORvxFo4hDxqelVvNSTahYaCXedW6nbf687S63v+P3owPuoRpT
         NE8iSM2lZoKyWZCKX0uSsAstJOJaOrum8Bv5QhPchfGnIWQQblCXoAwNAWJFLYi1fbWp
         eF+27RHznw0nlOldMYAz1HWiM0i6NdCV/WDsAsNcVvSR/956WloljR/j2hbenUQXSHPP
         xVcpZQRpOTv3+tVY3jFelz1vdEPZMi3gFKymuLzNX77hLYxFq/2dbCAnL2AYc+VzEvYG
         GYXQMPfq0rj2zuG2SA2QE02odclj26vXYFZzskxlGkfGiB3KhOazAfcVswWPrQDQEch8
         ROeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792152729; x=1792757529;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6t2J8EE3L3nlE7G0BZMfNQxPefv2h/6dn0nY1OvRibM=;
        b=BpAx/4gURaAK5IrGNB0vVkwZpD90f6CibMVyGbrwZ7QXPDi6oZNWGJpQMgaGQHIFta
         d4CPxItAIUPxwwJ1YcBqf8tw+8kI0tFFzTu8DGdOmJQUZRE5aWRRKeHkfY3sWWpL3FhK
         CuBD+rRPHSdFdet/b2vZxYksH0CEvM+wQ0hED5h2l19u3wdqmQlI6HGfsohvdgij4ohQ
         aZxYsaBH658bkfUVcvYuFoASXqjPQ9kMhvdsejkBl7eykLBXlAXg8flwGgV8G03wzgJw
         bXZwXcnJIruG94YoUvrLN7+LliGcaQH9+gJ2nHX6oVsLreu64TCAWWekP6AMWKNhtNGh
         zbgA==
X-Forwarded-Encrypted: i=1; AKwUvByfC+WVjfDg8rmkcZY/PQF2iNVoFlYyLJwsY33K1Frsbvdm8g0/NUYn9gS3C1R2azhDftbMsc7Dkw==@kvack.org
X-Gm-Message-State: AFq9FYLo2b/s1F5GxDNHVkEE2/8QNPTrJOxXYZSQLn0G0iJg4DGN1BJR
	/7h3G+Adqr/sKRIFYIZWqRe2UZtsRw+hLFg4iZxIV+uffvLb0bstppJ0u0nhEE9LIJydP1Y9C4x
	F1lN4fYnkqAO06TeNbuiSTcRMUr/5Yiw=
X-Gm-Gg: AYBFou1STYDM0onc5IXVX9QB6RFNjIhVmgGU/WmIgwDOkCaqd9yRXXnm/xxc7cejxRV
	jnsIw0WM40eTZVs02N7WhN/ERuY8cwf6Xjg1BHHPdFEGKyHBqFvm4u0Iky3qibShbrrqMqu85m+
	N8kt7MuoK8KOaRNSQGxcpmFd23KgH2d/m64sryFbTwBZxHYiBad4rTI0pUyS+VICfk2Fzb185dk
	4tHEKnlV2vR+pqShFFX3Tn9J0UTtT2T1sqD4+TUjP4FgbhTyLvLQFNrzz2gVRAzqrETYgP9AMH9
	0LFnjSyKwsT1URMu8k8PU6ke2A6RLFT4llo/1qwCpZNiXAQBKauc1Ds5R+KnrusmWJeWkAyUtsx
	1M9TxwaczCJpZ
X-Received: by 2002:a17:906:ba90:b0:c41:1e13:4ba9 with SMTP id
 a640c23a62f3a-c411e1365e0mr83342566b.6.1792152728681; Fri, 16 Oct 2026
 05:12:08 -0700 (PDT)
MIME-Version: 1.0
References: <20261016-mglru-fg-v4-0-2106750c0bfa@tencent.com>
 <20261016084256.12955-1-baohua@kernel.org> <CAMgjq7AtuK22FsuqvGRLVZ2eWrp-N4qQ_MHoXsXDkVBprekdDA@mail.gmail.com>
In-Reply-To: <CAMgjq7AtuK22FsuqvGRLVZ2eWrp-N4qQ_MHoXsXDkVBprekdDA@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 16 Oct 2026 20:11:32 +0800
X-Gm-Features: AclHuK-z6qzMGmKAbzLQtij7nv772LAigQWhuT7JqlQxVqOPHcB0PjAQdUtEGDA
Message-ID: <CAMgjq7Ao-1q5r7KtwV-UyvuP3hSazkfr3BbmKL+fv=dSDaU2Cg@mail.gmail.com>
Subject: Re: [PATCH v4 00/17] mm/mglru: frequency guided promotion (MGLRU-FG)
 and flag cleanup
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: devnull+kasong.tencent.com@kernel.org, akpm@linux-foundation.org, 
	axelrasmussen@google.com, baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, 
	cgroups@vger.kernel.org, chenridong@xiaomi.com, chrisl@kernel.org, 
	damon@lists.linux.dev, david@kernel.org, dev.jain@arm.com, 
	ehab.ababneh@intel.com, gourry@gourry.net, hannes@cmpxchg.org, 
	hughd@google.com, kunwu.chan@gmail.com, lance.yang@linux.dev, 
	liam@infradead.org, lianux.mm@gmail.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, liuxiang.277@bytedance.com, ljs@kernel.org, 
	mhocko@kernel.org, muchun.song@linux.dev, nico.pache@linux.dev, 
	nphamcs@gmail.com, qi.zheng@linux.dev, rientjes@google.com, 
	roman.gushchin@linux.dev, ryan.roberts@arm.com, shakeel.butt@linux.dev, 
	shikemeng@huaweicloud.com, sj@kernel.org, surenb@google.com, 
	tz2294@columbia.edu, usama.arif@linux.dev, vbabka@kernel.org, 
	vernon2gm@gmail.com, wangzicheng@honor.com, weixugc@google.com, 
	willy@infradead.org, ying.huang@linux.alibaba.com, youngjun.park@lge.com, 
	yuanchu@google.com, yuzhao@google.com, zhaozhengzhuo@uniontech.com, 
	ziy@nvidia.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 1595wh34fufeyewcozxumpqna544r5gq
X-Rspam-User: 
X-Rspamd-Queue-Id: 64565100002
X-Rspamd-Server: rspam08
X-HE-Tag: 1792152730-791206
X-HE-Meta: U2FsdGVkX1+U+6M0jBnCbTgLQMX47oaH0R4MWc1XiUZOmPhok4wyoUvQ5REi3LRW0HYduClWmJLAnEdx/EQRJpqXOFtF6G0NjMdiwyKUtVFfDOKruU4V1ZMlQJMaGLu/AdqFzP6woWCPVkedo1c15+dob8tFTgKhGu78LznHEwZ7dF509ENTuzygIbZYFQYfSmJjhK/H2iX9cF+eJumcCwdCAi0yVJXOXikKOSMUZLMx+ATz1C7Zimu4EnJb8rVsLDKNNsNw9aENIZ9r2yqTTcF+HS+/XapqImTnsaeBHJCbp8eA4zVA4AbXcLBZeQ0c3MmK725YPFMS0PnmenoGRQF+faLrkspj8j9NlSXCRqjUmjLzvIOVSZeN8HnYBEswg4Xnsi7DmPTIicT668afs9vOp1XPNGEUrj5LcOTpD7PCz/1zEzP3S8teFeh6+Iu/dm+3QnbLUP6IbuOgq+9rQXZ+lLhm4ZPn0Dwb7asQVHa8yPpNK8Rtd9VxiX4SWGTjey1miSxYuOpZJQCNOAyJe4GcBqZK64snDuXn7LWMmoKakEiR5wFXZNyPKJPIxMcaLwb2i8BunFO2jN2rj7M+673aJEbDY/3W9zYg0eUohI1qGDVtJmzHqzOfvZ0iZ+G9ohGcV1MLQffezPJbtu5lvrAw7CXa1X5Fo9GEkrMmu8wPDLua7C1rQN7O+xrq3uzi0c2BUBRrv7v9L/G1OsejMm9zVOQufpjmVbNwG3NIFBFFFGVsPgwtPz5DIuN8WTGVLP2Xx5o1yhF+kt69+otLsO5/J496x7W0IJZKcimuxzkjD/LmlwM94WaOkjKHWkUdTqQds9WzVdqvEBP79fAKTxS9c092Xqxw1kbvjgSoE272wlI92JTk1fQB2FnJJAGSRyQbqDEisZnzyNbgJMDY8qB/JD+WRQu/hPzgMk1vlyRW5A+0u+kK37/9QGka/8TSbNYLGd/2ixtl/CG32vN
 1aZ2YgRr
 5LrVkWGvMpH9fKKxparKNGPMSKHkDGWqWibCgSNxxidwUxfzrQW7L+oNAM34L01XXr5EMihR+3sfNI74OBsA6wd73Zt0oASWhmiOLPw5A6Y+VG4bdwVevpTCM3DOOASOzz88E4nbYc/88l8E3Lu643qecoLBa8vWkp+/euqSelsGp3GRlIZVCCvljnym6t7gVEx0vk1Vq0N9P6hxX93jj7lUazYmvV5twTbf7dkIqUYdN7QzrU7vM/uS82dbkfErMjuiN8mqy0zQ4jPnwEoFV7jT7ItN9UW+fuM1Rog88DZGT6C7pvN5qvpFnNEsC9vvaO/f2zatonZN4DGDDwiahP/VTKRJz0+lZz+0mZp7rrjvZsqCMcwZBfx9Tv12RcyNOKQ5ALgmQfnf8Zl6PSm+nR99sSfINX3K/54OBCD1pBeQcC1n47w9rNkOBJpbM7cqfz1BvJxh4UliDQSsrohQ1sn31vjPfxcdVbh2c/kcSEjXT3uLuiLs+nwyP1SVPXlw4tbi/Cy3EYFphfRNOXfGOsKNJT9SuBflNsGvhpyYE4KyQAw2rQXeVOW0dE4RbQ7ENEGk1LYwww0mff1ejlVIH4NOQW6UFiAYziXrwhLxbnbPkVCX+EkU3lsmNVA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 16, 2026 at 7:43=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Fri, Oct 16, 2026 at 4:43=E2=80=AFPM Barry Song (Xiaomi) <baohua@kerne=
l.org> wrote:
> >
> > On Fri, Oct 16, 2026 at 2:15=E2=80=AFAM Kairui Song via B4 Relay <devnu=
ll+kasong.tencent.com@kernel.org> wrote:
> > [...]
> > >
> > > LevelDB Scan/Get
> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > I also retested the LevelDB benchmark from the cache_ext paper [5].
> > > Interestingly, mainline MGLRU already beats CLRU on this one after a
> > > recent change in lru_gen_folio_seq that bumps new folios with refs =
=3D=3D 1
> > > to the second-oldest generation as discussed. That change accidentall=
y
> > > gave random reads a higher hotness level while making sequential read=
s
> > > much colder as described before [14]. However it's unreliable and
> > > incorrect because it depends on LRU drain timing, and hurts some work=
loads
> > > as reported, or where the sequential part is actually hotter (any wor=
kload
> > > involving hotter large file and many small cold files will be affecte=
d)
> > > which is reproduced below.
> > >
> > > This series improves it while covering ordinary workloads too and sho=
uld
> > > fix regressions:
> > >
> > > LevelDB Scan / Get, Throughput Total:
> > > CLRU:         4708.3 ops/s
> > > MGLRU:        5026.9 ops/s (faster than CLRU, but hurts other workloa=
ds)
> > > MGLRU After:  5179.2 ops/s (even better in all cases, and no regressi=
on)
> > >
> > > The hot-sequential and cold-random workload can be easily reproduced =
with
> > > SQLite and grep. SQLite continuously scans and looks up a small hot
> > > portion of a DB file, while grep iterates over a set of small files m=
uch
> > > larger than RAM [6]:
> > >
> > >          SQLite scan & lookup time:       Grep iterate time:
> > > CLRU:                       14.51ms               13281.37ms
> > > MGLRU mainline:            567.05ms               13694.47ms
> > > MGLRU After this series:    10.58ms               12930.43ms
> > >
> >
> > Thanks, Kairui. I'll do a thorough review of the whole patchset over
> > the next two weeks.
> >
> > BTW, do you think we need a quick fix patch like the one below
> > for the above problem before this patchset, so that it can be
> > backported to stable? I assume your patchset is too large to
> > backport?
>
> Hi Barry,
>
> Good question, I think we can patch it first.
>
> > From f9683205d2ab6e3b185022d7d5af3496dfe5f35f Mon Sep 17 00:00:00 2001
> > From: "Barry Song (Xiaomi)" <baohua@kernel.org>
> > Date: Fri, 16 Oct 2026 11:48:06 +0800
> > Subject: [PATCH] mm/mglru: fix using folio_mark_accessed to replace
> >  folio_set_active
> >
> > Commit 6cbdd9726fb5 ("mm/mglru: use folio_mark_accessed to
> > replace folio_set_active") tried to avoid over-protecting
> > fault-around read-ahead file folios by placing them in the
> > second-oldest generation instead of the youngest generations.
> >
> > However, it abuses `PG_referenced` on read-ahead file folios
> > for this purpose, potentially coupling their handling with
> > normal syscall-based file accesses that also use
> > `PG_referenced`.
> >
> > This could regress some workloads, as reported by Kairui Song[1]
> > and Ehab Ababneh[2]. Many thanks to both for reporting these
> > issues!
> >
> > The long-term fix is Kairui's MGLRU-FG, but in the meantime,
> > we also need a quick fix that can be backported to stable.
> >
> > This patch reverts all of the original commit's behavior that
> > abuses `PG_referenced`, while preserving the semantics of
> > avoiding over-protection of fault-around read-ahead file
> > folios by adjusting only `lru_gen_folio_seq()`.
> > Specifically, fault-around read-ahead file folios with
> > `PG_active` set but `PG_workingset` clear are placed in the
> > second-oldest generation.
> > Activated file folios and refaulted workingset file folios
> > are still placed in the youngest generations.
> >
> > Build kernel cases in a memcg shows it not only perserve
> > the benefit of original patch, but also even improve
> > performance further.
> >
> > w/o fix:
> >
> > real    1m49.094s
> > user    25m31.484s
> > sys     3m40.959s
> > pswpin: 662112
> > pswpout: 2504415
> > pgpgin: 4424336
> > pgpgout: 10355273
> > refault_file: 359626
> > refault_anon: 670724
> >
> > w/ fix:
> >
> > real    1m48.913s
> > user    25m31.639s
> > sys     3m30.875s
> > pswpin: 689815
> > pswpout: 2689894
> > pgpgin: 4422659
> > pgpgout: 11043464
> > refault_file: 326566
> > refault_anon: 697138
> >
> > Revert original patch:
> >
> > real    1m50.044s
> > user    25m37.137s
> > sys     4m4.493s
> > pswpin: 1349087
> > pswpout: 4317933
> > pgpgin: 7083597
> > pgpgout: 17602735
> > refault_file: 337676
> > refault_anon: 1368542
> >
> > [1] https://lore.kernel.org/linux-mm/20261003-mglru-fg-v3-0-cbd4546a5bd=
9@tencent.com/
> > [2] https://lore.kernel.org/linux-mm/20260901180704.168106-1-ehab.ababn=
eh@intel.com/
> > Fixes: 6cbdd9726fb5 ("mm/mglru: use folio_mark_accessed to replace foli=
o_set_active")
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> > ---
> >  include/linux/mm_inline.h |  8 +++++---
> >  mm/folio.c                | 16 +++-------------
> >  mm/vmscan.c               |  9 ++-------
> >  mm/workingset.c           | 10 ++++------
> >  4 files changed, 14 insertions(+), 29 deletions(-)
> >
> > diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> > index ab69b9930893..7aaff4e06e80 100644
> > --- a/include/linux/mm_inline.h
> > +++ b/include/linux/mm_inline.h
> > @@ -311,7 +311,8 @@ static inline unsigned long lru_gen_folio_seq(const=
 struct lruvec *lruvec,
> >          * | Accessed through page tables and  | Accessed through file =
descriptors |
> >          * | promoted by folio_update_gen()    | and protected by folio=
_inc_gen()  |
> >          * +-----------------------------------+-----------------------=
------------+
> > -        * | PG_active (set while isolated)    |                       =
            |
> > +        * | PG_active (set while isolated)    | PG_active (files|     =
            |
> > +        * |                                   | fault-readahead)|     =
            |
>
> This comment is not correct I think, faulting file folios are not
> access through fd, we may just better leave it uncommented.
>
> >          * +-----------------+-----------------+-----------------+-----=
------------+
> >          * |  PG_workingset  |  PG_referenced  |  PG_workingset  |  LRU=
_REFS_FLAGS |
> >          * +-----------------------------------+-----------------------=
------------+
> > @@ -319,7 +320,8 @@ static inline unsigned long lru_gen_folio_seq(const=
 struct lruvec *lruvec,
> >          * |<---------------------------- MAX_NR_GENS -----------------=
----------->|
> >          */
> >         if (folio_test_active(folio))
> > -               gen =3D MIN_NR_GENS - folio_test_workingset(folio);
> > +               gen =3D MIN_NR_GENS - folio_test_workingset(folio) +
> > +                     (type ? !folio_test_workingset(folio) : 0);
>
> This looks a bit hard to follow. Does it mean that for active but
> non-workingset files, they are put into the third newest generation?
> It creates more divergence of file / anon but if it work for now, I'm
> fine with it.
>
> >         else if (reclaiming)
> >                 gen =3D MAX_NR_GENS;
> >         else if ((!folio_is_file_lru(folio) && !folio_test_swapcache(fo=
lio)) ||
> > @@ -327,7 +329,7 @@ static inline unsigned long lru_gen_folio_seq(const=
 struct lruvec *lruvec,
> >                   (folio_test_dirty(folio) || folio_test_writeback(foli=
o))))
> >                 gen =3D MIN_NR_GENS;
> >         else
> > -               gen =3D MAX_NR_GENS - (folio_test_workingset(folio) || =
folio_test_referenced(folio));
> > +               gen =3D MAX_NR_GENS - folio_test_workingset(folio);
>
> This is a nice change, but meanwhile the LevelDB and cerain workload
> gain are gone too, we will again have a ~40% regression for similiar
> workloads, I just double checked it. But that's fine, though, it was
> never meant to be optimized that way, and the long-term fix can be
> done later.

Here I mean the "optimization" of 6cbdd9726fb5 is more like a side
effect, and not reliable, that is simply not the goal of 6cbdd9726fb5.
So I think it stands well as a fixes for 6cbdd9726fb5.

