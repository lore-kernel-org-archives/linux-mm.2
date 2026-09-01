Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E01CC61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 11:53:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BD966B0156; Tue,  1 Sep 2026 07:53:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4960E6B0157; Tue,  1 Sep 2026 07:53:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AB206B0158; Tue,  1 Sep 2026 07:53:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1E4DC6B0156
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 07:53:10 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 911B61C1D8A
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 11:53:09 +0000 (UTC)
X-FDA: 85165032498.25.1241E97
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	by imf08.hostedemail.com (Postfix) with ESMTP id C3B2C16000B
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 11:53:07 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nuyzCgRR;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of trintaeoitogc@gmail.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=trintaeoitogc@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788263587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y4X1mGuNPSVf6TjCEy4kMmDg1z3j++AZIq9q1EIuqzU=;
	b=nYdZFKMEtaz8tvEn2D3KQesrzMfVJE1YFMdOsI0Lty8BqNLmgjlXZuF/V9tpLvOnJlKGAn
	8SKPc/38GcveFKMz7fXDDcCM3hpB7YSQPK4uyvcp10YadmJ5zQmp5hRxx+8A1tzFWctY3L
	QeiHjr7W/4MJ5q/UcAym4LEOD/j1HKo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nuyzCgRR;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of trintaeoitogc@gmail.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=trintaeoitogc@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788263587;
	b=GVZGZggI2U55DhDzP4nS53bCxWc9PXYVCrSlxMORcVSZ4jOS+uKFi+IZoeGC5TCAN7FaIE
	P5P6JttI67I/z8zg3kgrTiyBg1Sf7UfL1GROQXfKolbd27kRDK30nqgxEjMnb1+M6d14sn
	hPzb47mrvmOVOWwutsh+SPnEFnFmq/8=
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-867a943b149so23697657b3.1
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 04:53:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788263587; x=1788868387; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Y4X1mGuNPSVf6TjCEy4kMmDg1z3j++AZIq9q1EIuqzU=;
        b=nuyzCgRR43EgZQb+x7DQBQuFqKfkyN85lIWD+iAHwUkbdLi6CzYgn3EoA+eWZUbyyr
         74oDyUsXb+VqR0SbcSFXFbhutbAmL6jKmCGd8kW+s1Uq3i1joBbA5JAsqXW+H3z/6pob
         RxpiUWz5hki2JCKDdx2kgqvy/Wnm8KfI/dJNVY8ipOf/F7uPhztY42YwtoNBEPSb82LJ
         UsS6Ue7teeaUmIc5mz6m0h/u+MZwbSYSDh7FHs/cO83c7/+f2agtK87dRjOqqxcq4UKe
         QuuAqc6CC8SpQhlBZeVE7lY0pOu3H3oNpXwO4wXzayH0qHNdYnqK8SQNr69pMHRwN+VG
         RPqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788263587; x=1788868387;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Y4X1mGuNPSVf6TjCEy4kMmDg1z3j++AZIq9q1EIuqzU=;
        b=JSC10Fsi4s3w85jpJs+mKQTgFhk2IUvzvceL957KQnQhZ9W1hBv15HUWIhR+CbqAmb
         NyGiC76XbH0dP75DkSUM1x8DWlOR722acf0Hy//tNhAGVIaqoDjG1CLRjP3bV+Y/N8Fm
         FH055VgLogvr8xEOm3mKp7vkciSuaetdovSf7snDQNPvavHJz/YU2q10sHgtRjpQKquZ
         X6KFcoXS5ZDZgThfu8Aewx7fqSIbC7c6vUI9BdhdUTfuymjPd/55McCIa09R3/EsSgB1
         itc8aZ3QJ8PJKcbxuJWrs3jcKyHihvrWQwMQqA1eYEMMzwtkwyUhnn7Htv+5BfF76uDB
         fPvQ==
X-Forwarded-Encrypted: i=1; AKwUvBwNZzrL8MaC6Cn8C1q91f5xsXK+StW6CGiObRH+YjJTDrf1+5qwdhvrzY2cB2Bs6e0YtoR9Lj+6cw==@kvack.org
X-Gm-Message-State: AFuF++nrpR7ZkpUtPb7jnbf/6d6bITtSn8vL9JzEbPCROTz/GdFeigA7
	IVtpU4ibWF14LsGXKFNfhmkl1yPfhF0s26o8bZIJyfNAASJ3c3k5J6nY
X-Gm-Gg: AYBFou1FBWspaixLQKUVIMDGmWm9d+vSr2lIfdpMRBHynaQqbsaJaErDByxNDjGq4PO
	Ay+JUaD0YgocmKmNPrPY2YW9mlPm5Nruvi4TV+bVwoBSydaUl2HWU3X6QIAJtxAgjOLynCDWdRI
	weWF30kB1AI5As5ISCMnEYvCLHMCXnl4T2kc3jA3DWKnFVXcMIvITOKlOgdw6mwAubafV4NdYAw
	AT00r6j+0oAhRaosX41Ly2hqdtXNstwGGFgEQ6ZgcmZNfO1CUa8OYXpRr21v+W9YmVTsKYkqdYj
	4XN8wKW/fm+Q6VI2e+jiJkGYSo6BbzNXDQysY1Bgnrqrm6YzExxwwlR94M99zaxH2kiigWnYnKv
	IdmO9o383L/HdKBT+yQ1hJk11wZ6/Cna3Pz162WyrV3BcE30Sx8LGUBl55F30Z5+VsvcGfN3GcX
	yDsByoKI4kdRhS94ttmSszOATS1Yt+28cJW1Ox8Wq3GqeKRdHlzg6ziXwUXAQyr5VYrlP9eFQn7
	m7L+i6xeTanOkNFejOqC1tyTjEMs9p7HCcVI/UClTUl
X-Received: by 2002:a05:690c:ec7:b0:820:1281:8deb with SMTP id 00721157ae682-8686f14074amr34301557b3.8.1788263586787;
        Tue, 01 Sep 2026 04:53:06 -0700 (PDT)
Received: from fedora ([177.21.143.191])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8650aacd1c7sm43991587b3.35.2026.09.01.04.52.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 04:53:03 -0700 (PDT)
From: Guilherme Giacomo Simoes <trintaeoitogc@gmail.com>
To: ljs@kernel.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	mhocko@suse.com,
	pfalcato@suse.de,
	riel@surriel.com,
	rppt@kernel.org,
	surenb@google.com,
	syzbot+395b7abe9696862fc188@syzkaller.appspotmail.com,
	trintaeoitogc@gmail.com,
	vbabka@kernel.org,
	willy@infradead.org
Subject: Re: [PATCH] mm: fix the race on huge alloc failed
Date: Tue,  1 Sep 2026 08:52:48 -0300
Message-ID: <20260901115248.26650-1-trintaeoitogc@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <apVDMw0d0Y8OZYl0@gremlin>
References: <apVDMw0d0Y8OZYl0@gremlin>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C3B2C16000B
X-Stat-Signature: as84uim79gy69gaqd9ufktg3a5e3c6zn
X-Rspam-User: 
X-HE-Tag: 1788263587-612197
X-HE-Meta: U2FsdGVkX1+FGRkmzo0s/GHoFEux1ZgHPJriKUo4XR/s6iNOF5GWIhzJ0SYn0MCcDZ/ymU+X8DdXCrFiM8vD7MhcHTf1RXQ22JE+EL933bedqiqxRNdphuY0sjkGXh+ZAdLAIK/l42C6pDoym/7rHroXqPYm9aQX//o/8j/JOwGDuLMZwY+lukN+U1bRUJtjyInqFMr8OXyqc46qvhofVgSn43ROEF2t9cYaquOIEJfOC+c93i+J/8e8/677rLDQaQp/oiHx0mHS+lDtkygMhu0njVHMRgwY5LG0rJxS2Ruq8stMCV7hKkTSGqMfGrpLdAirXhI3QTC0X6RniDX3NjBJLv5YGiBvf5AvnxBaoNZ2wxMQ7tghOMb27deaxgahqtIcKr/8SBLnH7OzeorjShbfPrmzf7UkZByqMtTrE8zm/ALb2ExcgmUGandhZ6kBzWos8zjPx3s6AD4C/Iti6qg84ff2MLlcebPMrXXuoxhv6kBXgu5OmRGivuD151Hc1MT9lY0b3O56zYy0RIikN3K3WFzG/nYMTYTal2n/iqzLMNIQqo7aluS2cP085HGNsScomKGY807AEYJz0oqFjckA8MSz9JPtNZtYaBXQLilsxtRShDklXyVnspwgZwt3qEA4o7cYyU0nyl6aa6bQ735YMeCogl1+PzcGP7ASBI6CCqjjdyGGJktRS9SXE7ib6NcxGvr31dIyOZOOEmKyrnNuMKBCuZhmb6Rhr218MxJ9fhKsUGPxhJdEIxlfbC4oQ5SFkepzJHKc711HiLJe7BXXqpICXhO6F66zCWrUqGJhL6LAN6zhkNgvZkl0T5tkoNMHik9IOmdPWjMUWjLSUBE89T3m1K4euRHUFVECWhDvjtyhcdQsltMtSuhZMe/VVgLJVAXrwk5oQ+akgOUgT+EDhtGEAYYRLlVUUKe2b5bc9zzf7vSx+yKofAd5Oh6rTlYsbQ8JsRrPXV3z5FS
 CwCDxQcR
 uODMrDSS7ifIXVCe+y0Wng/2LJJOrhqFJk7nkY+KcCoH5MysF2QOnzUdMquYq5Z6ay7oPzwAuqowCcjhxXFlHKvH5RoMTIhfwQ3NqzaPTggAp4MQFayhN4JZuq1s0lmBYYGqxCAZa5x0vn48m2VmUsxFEntdPN47nP1p94kEB8vgKCByNs7GtcWWQvo8IMQtgVVITsDz7XgjPW9zYY0YBjSbeMkltLhE2fBSe62C70+pwk1HTVCF2Zm++lKcRRZU7GWn9CfapH4V6zLOWKBf6ajHyrszH70Q0LMGiQtwdznSPyeHLmYli5sBM0d1GjsiJ8J6vt5wkpoOhhrOASpuu9eNWpIohzKqj2v0DAdG1NtZfDxo9p22U1pcw9b7pyCpNNvQHBeGBGUpH07NXjsHV2kED9+zyRr13wIRL3BDQ5WSVaye+EN4vpEkxL8AFxbg2qlkTLFUiBHE4bl2fbESGIM8mqFOv4nkFkWqF4wC+y2Asp2msJjSHvVHWWWLNkzXu0Ek4ZC1Y4ZbwPxjqLI+7ZLWUso3KzBz7tIOc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

First, thanks Lorenzo to help me with this...

"Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:
> > > > I don't think it's enough to just add a data_race() to this one read of
> > > > vma->anon_vma.  I think it's quite prevalent.  There's probably other
> > > > syzbot reports that mention it.
> >
> > It sounds to me like the most cromulent solution is simply adding a
> >
> > /* maybe vma_has_anon? */
> > static inline bool vma_has_anon_vma(const struct vm_area_struct *vma)
> > {
> > 	return data_race(vma->anon_vma);
> > }
> >
> > and churn everything to use it.
> 
> I'd prefer vma_is_faulted(). That'll align better with my scalable CoW work
> also.
> 
> Anyway I agree with Pedro that a data_race() resolution is appropriate here
> rather than an unnecessary READ_ONCE()/WRITE_ONCE() pair.

Okay, if only a data_race(...) is enough to silently KCSAN, I can send a new
PATCH or send a v2 of this PATCH with this new implementation and with a fix of
commit message

