Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A815CD6E57
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 18:54:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67C046B00A2; Wed,  3 Jun 2026 14:54:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6533F6B00B1; Wed,  3 Jun 2026 14:54:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58FEF6B00B5; Wed,  3 Jun 2026 14:54:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4B0D86B00A2
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 14:54:49 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D69C4A056E
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 18:54:48 +0000 (UTC)
X-FDA: 84839503056.24.BD533B0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id E19B240009
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 18:54:46 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jE2ejJpZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780512887;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZFQ4Bd12+v7JeyJgIXsYlF/gFBeRBKKRjCH/poAPJdk=;
	b=T09gNoR5LRlNjdgAaBsOqx3No5QtHWfHZeDLefNzcWYVmXYpAYE0auwNZFQ/ixRr5eYJWk
	o/8o+kvAWThw/jmdeKaahfCfclISRUPs5DxncaLRgrAwIwBXGPQ/yyp0ASX/f6heqNR17L
	sRV/SkkH6r4jD6PPOdZqfPLZMmO7wYo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jE2ejJpZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780512887;
	b=rww/SJsQ7kq3fqc8m4k4tw1fFMJ1yDLLglKAL4HJcvZRTWXwkW1PHY5H9bGR1BRXqE3leN
	Pvu9JVDWUsziZIDkztReHyEq1vXn60jLZbI8fZCSFE3EwYw1Oe4oG+592v6im7Bb0Y9Q32
	Ub2LmSZZ3eXSVM1Ej/rxipWNAr7Xx8Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BC905418A5
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 18:54:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A00A21F00893
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 18:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780512885;
	bh=ZFQ4Bd12+v7JeyJgIXsYlF/gFBeRBKKRjCH/poAPJdk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=jE2ejJpZq++jtEtDSruv760lUQrefF2Z/UKZAkSHeQttl9hDEmCIXXUlakRX8Bfvp
	 COMQj+dCumWiiTMy1sKrQUTc2OuS9cxWvCN7GJC1i6Dp5MdoZObOUv7MZkAYxxbQpO
	 igfC4iBnnt3+42ycHPjlsUVskJIEcx30umf71Z4ORH+DE6C+TNtvOpzeRokA0axedo
	 Z6Zs3qJO5ta7tNsPZvnvy7vTfRPeGzFUK0hMeKvCirNGhLAuebDYQfhQ6/pyzqLYvO
	 MnAGq1zykStkfQnFcVUee5L0/1zTkXIbMdDImNp64lgv+2EN2ssk5k09sWvrBNfJ5D
	 HQq1o8TgDIt+Q==
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-68d234218bcso1326497a12.2
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 11:54:45 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8yoZDZGWmMadijBj6zNHf/UWJ1ln7oc+LxI1vyn7qWI3eX3xCasYRZLoVROaCn/pcllcOqZzA5bw==@kvack.org
X-Gm-Message-State: AOJu0Yz+Cwk/SGDekusqytnzWv4Vi/idMrsmdzo5LJnnDZdJGDoIbYLe
	xRvy1xE2fkEFPOpWxCy0DsmSvp/3K4rOypfhIwkwcWWFNTFsfoKaYRT5AssdSYhbOzLMqWMde6f
	1FoTfrgci1DkYnrv3PTRnTTQO/cBJt6Q=
X-Received: by 2002:a17:907:3f07:b0:bd3:32ce:8902 with SMTP id
 a640c23a62f3a-bf0af2039b9mr289938366b.39.1780512884672; Wed, 03 Jun 2026
 11:54:44 -0700 (PDT)
MIME-Version: 1.0
References: <20260526114601.67041-1-jiahao.kernel@gmail.com>
 <20260526114601.67041-3-jiahao.kernel@gmail.com> <aho-Z6wshceTAYd9@google.com>
 <ea2c1323-1440-e927-f14a-0eac54a245bf@gmail.com> <CAKEwX=PoBZ4ci30tKHQXs1o9=NDpPrtbe7RxxZTbnzVJf74ZYQ@mail.gmail.com>
 <CAO9r8zMBUMXy_bkeT8z+M=dXayU=6VGEw+-HmfDWR2fyJy=z+A@mail.gmail.com>
 <CAKEwX=NQUqqrM9vdYE2KhWEZx-YwPc7YPhfz7xaBrGVDf824bA@mail.gmail.com>
 <CAO9r8zO0GjTeY2+j_AjfTQ8qYOmHezZAV44f=aPgrjJcdtO9rQ@mail.gmail.com> <CAKEwX=OeFsFPdazWFf0tsKTOi3DneX3fCcreEkzwb=BOR_37hA@mail.gmail.com>
In-Reply-To: <CAKEwX=OeFsFPdazWFf0tsKTOi3DneX3fCcreEkzwb=BOR_37hA@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Wed, 3 Jun 2026 11:54:32 -0700
X-Gmail-Original-Message-ID: <CAO9r8zNMMa6-z3dxX8uktFA2Hb2EXTxCkeSFG=uosyVS6Vnbtg@mail.gmail.com>
X-Gm-Features: AVHnY4JNisz5_3nlmLGBOhejCJYEaBo7BSD-V-P6mrBpcDy2zK6Jtf82sPe44Ug
Message-ID: <CAO9r8zNMMa6-z3dxX8uktFA2Hb2EXTxCkeSFG=uosyVS6Vnbtg@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] mm/zswap: Implement proactive writeback
To: Nhat Pham <nphamcs@gmail.com>
Cc: Hao Jia <jiahao.kernel@gmail.com>, akpm@linux-foundation.org, tj@kernel.org, 
	hannes@cmpxchg.org, shakeel.butt@linux.dev, mhocko@kernel.org, 
	mkoutny@suse.com, chengming.zhou@linux.dev, muchun.song@linux.dev, 
	roman.gushchin@linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	Hao Jia <jiahao1@lixiang.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: E19B240009
X-Rspam-User: 
X-Stat-Signature: eterd568rqrb1z71msxyi6hyhbnohmqe
X-Rspamd-Server: rspam09
X-HE-Tag: 1780512886-404728
X-HE-Meta: U2FsdGVkX19tQ26XurLo6+FCHzlVVGmSqPSudaHmk4Iibl36s5zKEObu1paXJLUdbJMTeu8WPvKSHIO2t8f870J4IKGY15dUVtOrkXub26RQQG9Vv5B5aQfPxnkzYnrh+4ujXXc1rcNsRCb7kEh3Gj5lOS2UPvUuKQDac2B57WGT6Nn8tIGnOKRjbOU5TqH/73j9fL1Ro8vtlWfB7qxO2KRjXgNxzeYdk2tqPOSAb6EZWrSjfTEkKex2CidjtFZv6+3P9I9R12LHkqraWaQr8PALSJhT30NmggrIU91jeipoMh8fuZw3wI1tIdh+nxsgP/nhpbTiuQmCnawsLY4ezrwMsdkpyNaqov8jYbsFd5EVQ5QuSFl7Ootn6/VmZ4BEYveXFU9EFro0jONqfCdqfzTAQnyq8PgWy61qe0dBlSU1rvJnUDmGKUuqO7OFJb5jH2+oendAMx7g/m23vF1f337ObhZdJChUfdtgfjpb/tE9HDQ6isIM3h2QuSWUvPGqFgk4uhEiW6GZn8JssFDMdh5lF3MR1aqEPMg6N++eq48VvPHLviWg38KGlASboPFvtkvPRSxg+MZuNo+AMUknqj8v7nQ/W1hN5t2rj5yE84v4GCk8qKYpTLjOTt3Qp+5AR7p6JTKqnZ4EEeXZ5fwL0zs5lwIaMQXSzrr4EX0hCpEu30WUuXZSfVtCd0FQAcuRfoTWncISxHOxjthfU0GaSv8WJFQyMDtoQauexoMak9fnvJtYbhISUJRiu+8NoteiiVG8ju4RqemCvs2jsQ5GTZdD+LowPIR3FkrTyGE2MzoXJofK5M1p0ql0QH5V/bJqXuirV0LGd5NHlzbFGzvWeu+hZcZdUkfNeEbTsndiZoqQ32vxKNCu406Ohg5RZXZZf2+k7el11NgRpsgsFSVaaSA5cauy2w+WeKS2n2TYEzjbupJrz9k1G3LIl7E3Gw+6A8CWWrwlG8OJUbttNhe
 iAhvTPRh
 7KIfOi/QLIPU8Akq6i34URN6xErxN8y9qV7Tmzq4jmpS/Xq37EvB3ESF4fOrHJxnYSbJwPYFlCxapCiqeLlztBbIDGK+FNsVMM0/bZjwD1E9EyEf5mmkZeCqoM3dqhOcc+Lq+GySLxTQR303bH61319rCm5QeGSGml0+0nOSUIEkIAJC+A+B7FOHx18A3DV7tfrMgYoZtMZUx3xyZ5o2Br7Uc025aP5ltOR01cCGe0WFBeCBwiuI1bZpU/D3jFIyWqjSltjHbzt5oXwRiCohpfctawVPGf2I/s/uxHzNfKOu3qNBuvJhs9g/F6Kte3sJfRYxyO0u51pl9J2ALy7jKJyNYiaUUmpeEZszXzDmpdeGwPIw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > > I suspect not a lot of people invokes the shrink_memcg() synchronous
> > > path in zswap store though. Setting zswap.max is hard (as it involves
> > > guessing compression ratio ahead of time) and induces quite a bit of
> > > overhead (obj_cgroup_may_zswap() does a force flush for every store if
> > > you set zswap.max to a value other than 0 and max).
> >
> > Yeah I agree, but I just wanna make sure we don't completely kill
> > performance in case anyone is actually doing that.
> >
> > Regarding the force flush, it's unfortunate that we need to rely on a
> > stat for internal limit checking. It might make sense to use page
> > counters here, which already support hierarchical charging and
> > whatnot. We'll need something similar to the objcg approach to charge
> > sub-pages (or maybe just reuse that somehow?).
>
> Conceptually, I've moved towards not capping zswap.max, and using it
> only as a binary knob for enablement/disablement  :)
>
> It's consuming the same resources it saves, so if we cap memory.max
> (and swap.max until we have vswap), then we already have isolation.
> The split between uncompressed/compressed should then be dynamically
> determined by workload characteristics (working set size, access
> pattern, compressibility) and service's SLO, and reclaimers
> (preferably proactive reclaimers) will drive us towards the optimal
> split/equilibrium.

Yeah I guess we can wait until someone actually has a use case for a
non-binary zswap.max and complains about performance.

