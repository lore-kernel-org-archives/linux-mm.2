Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 883E4C88E75
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 03:21:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E65E6B008C; Thu, 17 Sep 2026 23:21:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BE3F6B0095; Thu, 17 Sep 2026 23:21:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AE386B0096; Thu, 17 Sep 2026 23:21:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3B5D56B008C
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 23:21:47 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B687840568
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 03:21:46 +0000 (UTC)
X-FDA: 85225433412.14.14B708B
Received: from mail-qv2-f12.google.com (mail-qv2-f12.google.com [74.125.230.140])
	by imf26.hostedemail.com (Postfix) with ESMTP id B7AC714000C
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 03:21:44 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=eb644IEf;
	spf=pass (imf26.hostedemail.com: domain of ackerleytng@google.com designates 74.125.230.140 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789701704;
	b=N4vMF1W4o4rqvL39mGQc1oZyjjLEUFg0pKpxhCUl2+q0TwoQkgj6SiAIlXrKiv+cM5Si1E
	frnRaDYtFADiRFbb+y2MB6pTqusanVZ7vBCuoSY6PxNmAb4MKWp7Jm98q7garwk8PToQPx
	pkc02+KYWgLLOp+yfVX6zQcbjYxMWu4=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=eb644IEf;
	spf=pass (imf26.hostedemail.com: domain of ackerleytng@google.com designates 74.125.230.140 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789701704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AKLDi2InWGreAxz5T4V5Lg4sL/lYAuzfpcW1EZWy0TQ=;
	b=ROkWU/6pRZZjUAPr5IlYhQCwUL3mKWpG3Vv70V1PYABw40UtRKC9s7EAwIfQebMWP1mdcv
	Lvuk3HwtiVGA/LtTIo1mJ4MJUTrJTmNUnMksWg8TWRD6VhsilnR/x6Xdsyfya5WhGfd5ZR
	jSEkkzDcMVgdpD7nnYOyc3r0DNqoxQk=
Received: by mail-qv2-f12.google.com with SMTP id 6a1803df08f44-90cdfc9b6e4so3553686d6.3
        for <linux-mm@kvack.org>; Thu, 17 Sep 2026 20:21:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789701704; cv=none;
        d=google.com; s=arc-20260327;
        b=hWHtxJjSbt0Pr1p+v19yu32zaoFZ7RyWe/s10PptZxuvmlltzRb6jPkg0dgDhugaJb
         B9aTuCgrXv6tJbCpGKnAnQYc/x8eUkGdzNlbsbEsmyKXPQyuJxQqGOvFqiKwX1ciu1P+
         kLM0ewHwpAry+oycIWco6fLwB91zhbRmg9VKtcr2OH442eSsdt44wUx3sE3LpNeOMYS0
         N6L2qo+tDT5H0hHIxaYtJHsgEPPFC76NExZk4C00ekMWv6HOpVdIpkRMXM7hKuqssyn2
         xQ+jxqtimLeqmrqdI8JEd5w0/d8fok1IICWAbotJ9U0Ap0Ki5POtA7978PLEVJ6V3tZ1
         csZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=AKLDi2InWGreAxz5T4V5Lg4sL/lYAuzfpcW1EZWy0TQ=;
        fh=5QpWJ15Sy/TVSe4gKdrlULcIkZeh86+BGQm9OiqO9kM=;
        b=CSf/se8DdO2EWXZgH+ii1DkuSMOW4UGekrtzzmkfwP96xlAmLCd8Bh8zjdlhyGE6sR
         Bt+S6ZYNcPK/xvQu9ss/eqV57Rm06bO2YJ/eQmf2gV8OZryssOElW1+/9eJpiyo7Gwq8
         Uu9O3deupdhuVmHgBUWjBbVInFrCoXJ5QQNtuJi2DGVnelc5fAQhMEw86rc88iiyNOgN
         XZrTQB2Bddhrt0JZE8vLbuI3Q404v8+NCAMApRDMer03hBNsr3G4IJ+XWl7c7/tQi9w4
         OzfMBFbl9II2cYShku8o28NoC+oP5NQqK8VfZCDR9nNYvCGO+PqMx7uWWuhzW+SYjR1V
         H6pQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789701704; x=1790306504; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AKLDi2InWGreAxz5T4V5Lg4sL/lYAuzfpcW1EZWy0TQ=;
        b=eb644IEfmEGXB4t/3ZIgN0oc2Y8py1mb8uIUbgogpPelLwCc1CajE3vvkhf8mfRYH7
         rU5UXpjvG3OiCEKktwUkcPdiPdI7vS+H5A4M0JLnP2d6tfSKYIFth7z3iv6HCrR9btWK
         wbtN4AgDmM1PQYcWxdcNBJ5djCY8QoK8RgENtBSXVfwLf/QoTQspGcD83jbvXTsRwUul
         TT5n5vHMClvv/5BQ6NEraiF+pqSlO0YyyfyU2Ps+qKV3WW+W/bmxFQpa+LyXd/suHy7m
         aei6fBFy1/aMJgSxF98+ORFgz+ZmuW5NRu9zPjyVZFd0OSsJ1IDyOPbrAMn9uxmEY2CQ
         QDBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789701704; x=1790306504;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AKLDi2InWGreAxz5T4V5Lg4sL/lYAuzfpcW1EZWy0TQ=;
        b=WdB0iPKUhrD9suLc+G/bRd2YqscOxHHhwARNDMJNYxjwGvdbEN949EjsHXtCGqmI6u
         Ndg4wcbdFmP1GBiIDObu7MKG+/i5qitDqCafg1jCtIATUliETcwcgqMcTuL8xDiQR8Iu
         lXwqpT6D+f6Cf/xWwf5FOoc1kio+21oZejMmJklmMecoOuNmWdY8o9F+uhSjeDrzC/5g
         HK2R01VouSHqOCZvX8VVCGc+pg0h28bRF/bj52R+YwU8LqZIriuiX99zKVy6NzPzgVW/
         iIn8qTjQy13H2wC9NEnc/YwmAbabHEANg/KyxDLIrJR2ZTUgWzG2w8MApt2YBir9B6p0
         flsg==
X-Forwarded-Encrypted: i=1; AKwUvByl4z8BvHMXTbO5taY+MkXkAH5IO9zsq7yro5UnFQWh4mY/2QeXggFTcegs/cxQHKyyP8aiaegLow==@kvack.org
X-Gm-Message-State: AFuF++nA7W4WeHN7EMeqfzy29Qgy0hJ5eDJF0uI5NJu27Ag85rjpl8ET
	KDaBebi6luz1X1yqem+6xze+F9Sp6u+dWh8s2G9liiEpHfHShsiA/YEMPWD2C5wlBS5YI752RoH
	NkQKz8Zn0v1BSyjnkIp4ebC9Lr0c28dP3HQqaYiLW
X-Gm-Gg: AYBFou3uNXLskUZbizjeJIe/pl7CvLx7woQSbySQWI1EoqvSJ6vSu+OC/QEZS7RVt/j
	AexQXA+d5HbpG8sh0n6HAUvugD6S+OG0gVGY0uSBhs2bcplfCXdCzd9jc6qjtOl80+dzM/lE6y+
	WYg3aFnJN0xiMFlkQAntAN6pBO5F3t/qsgTO21xOgtvL51X+mtCQtcV9+/lVdQYWIdyo/p5eU7n
	SM6dhf5qt/CE+OS1zpKpZu4PPQmQ3aIaOVsKY1VAe1kY07nQ13XnM02p9gRR/yVMKRcmsT/BR9J
	Mer/qrN/hG8mBWKqMtbgBYvkO72dV2vUBI6tHM0p34k1vOggpvmoRFXMVHMcublaOopw4lSiCxc
	74m8NmKVbiFQ=
X-Received: by 2002:a05:6214:2f03:b0:8f0:d59d:78d2 with SMTP id
 6a1803df08f44-91254b085edmr20535346d6.5.1789701703240; Thu, 17 Sep 2026
 20:21:43 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 17 Sep 2026 20:21:42 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 17 Sep 2026 20:21:42 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260916201307.5618114cbac4af52d98aecfa@linux-foundation.org>
References: <20260916-hugetlb-subpool-always-track-used-v3-0-38aae9b5ccdd@google.com>
 <20260916201307.5618114cbac4af52d98aecfa@linux-foundation.org>
MIME-Version: 1.0
Date: Thu, 17 Sep 2026 20:21:42 -0700
X-Gm-Features: AcwNN1UmZTajHstBlVwK_8w-qiRF_BNJfwUwN_LNEwXV7xnF5kJXV5qm-KLh0ag
Message-ID: <CAEvNRgGDOG03=faAE_ZA1aHQ7Za8gShUUd=h+J0xZ2f2FaWF0Q@mail.gmail.com>
Subject: Re: [PATCH v3 0/4] Fix HugeTLB subpool used_hpages tracking
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>, Alex Shi <alexs@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Dongliang Mu <dzm91@hust.edu.cn>, 
	Hongxiang Lou <louhongxiang@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Jonathan Corbet <corbet@lwn.net>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Michal Hocko <mhocko@kernel.org>, Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Nhat Pham <nphamcs@gmail.com>, Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>, 
	Randy Dunlap <rdunlap@infradead.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Shuah Khan <skhan@linuxfoundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Wupeng Ma <mawupeng1@huawei.com>, 
	Yanteng Si <si.yanteng@linux.dev>, Naoya Horiguchi <nao.horiguchi@gmail.com>, fvdl@google.com, 
	jthoughton@google.com, rientjes@google.com, vannapurve@google.com, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B7AC714000C
X-Rspam-User: 
X-Stat-Signature: 3z9ihgqccqowpdqrotwuim97futpa8op
X-HE-Tag: 1789701704-620351
X-HE-Meta: U2FsdGVkX19eJZOlvyOwlproE2D1OKF+3IA9yZNWYy2CTVJPDB8Bv1G8lLTpUMnY5EaJqBfRvQILATTgqNYfooxocieLFEUmZT3Ii2tnHi2oEbmrvuv1kGDMG4tn3snykbotrATYUUi7LxR8N+iS4MMniPWoZ5pobO5RVhT4m51h/jmI8YP5hLaFRR2/k9psqsKS9b3iLC0j54tWlR2NpRG9cw9x7tW0xPUsJbwH+aP8/DVk6xil6jmtQhdJXbJgmqglmdXW8aU9Sf6Jfye1fkBfcj2kIGKiuplo/rTxVgOzhZHz8VCECFEHPS86uLFUYJyyaPDeaB2yOR6HT7RwKe5K/nQgCaAleYT0zd6+nhoTqpn5yISlIq/4l2Kmnk6/2a+9J+W87cxromrY8+cdXyRqow8WB4kHu81+tUxAX1K6Re1U1bJyYOcKALZaZ8M3q1c6EG8LzI12KRJwopFFgqIqKfwXuelUG2Eqsm58Ma5fdBkXHdCXEmIhEgsauz/qrZeaYlNicIiQT/7PRm5JXUs2sdzjWo4EFmn1sfdXR+kPGnD06dFJfGnTDKwc+/oHEjdeGn1xNzDsceYbh4JYx8wPpaTXe2OhJAFr24fVKEHHdTucYO4pbUCEhfnTmnE7yR+Qc3JP5dgs/id+bxLeMTKvAL/lldEzAFZsKG1daL3rSLdacOrEIXV7uYAJ2oNAI3uUZUPyjj7+ItnEqjjfTuwfWGKnQpg4p8pjjFfCAg5Ao0/042Zd6hTYZvrPSYOjcN0G+oBaMR/jv1t7S0J3DfhmPZtkLH9eGXwPqfQdbnpshDe7qcZVHdpAnLwKgUH2+tZIEW9q2hVxe4nC1sb3Wl5LK8/k2GUpT/4pAil5KLdLpKsrn7rB3s3FUt6C8mDIt9+2X0CqclJLwM9x39bTCTfi3NZjJRMVOK5V+0SOVhmK+fsJvmXwflRvTPqDeJ4mbcZehKzvqZ0ZilrYw/M
 cZS4PYv7
 xGuj0DDeRJXJdI2UiVICIpbbt/40Fd8RDMvMvlDR2ssH0yEcW72UHwEdqP/UkF92sm/B7AG1+DnvuGa+K/ws5Pkyw50XKZUiV6hxZe8QURhA6dFOaG/1KgRaz5QEk99lkdOgYEx/hT41YAMBwWuOMF62nAHLXuXK8ZF9BApBqrJX0swi5OjK3/+9CR1UIByqiUqpFl9czq7C3kdJ/a4mj7xppeSxCfZPfe4KiroJzrb7uQQsArapVqBsKbv7eKRk25ZsS5RX3c8GUJ5Wj4mmCe4ldosVkfFKAtwMdlxaAreuO5jLvEFoQbx59evlI2pXQSThipdV6I1EhxLWnyEHxDvvZp6EpehVWxzPpF87vZ2Thxp6qpwqEQkETPV/FMT+hkXeaHN1OMgqRFhw5suWKHuRf84tzlfmukizKiWcDzVvV/a6jFxAWuofnriKZwJ5g1+dZ/MnYqab4K91YC4Zke1GnUcC4gfWJmDqvV/Z8MVIMzXIWPnsSwI6AGP79r3dEse70m6pYzp1NGtNt9nBKBg/9GOqUL6nZFFiKeeaVxiLmPSLIFVjKwgPSnmpK5vQyT0ya
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Andrew Morton <akpm@linux-foundation.org> writes:

>
> [...snip...]
>

Missed out replying to this!

> So if downstream people (-stable maintainers, others) follow our
> recommendations, some kernels will get two of these patches, other
> kernel versions will get three and some lucky kernels might get all
> four.  Are you confident that the patches can be split apart in this
> fashion and still produce a good result?

Would it be better to add Fixes tags such that if one patch is applied,
all 4 are applied? How do I set that up?

Patch 1 is kind of a fundamental fix in subpool accounting, which allows
other fixes/simplifications in different places.

> After all, we're sending
> downstream some patch combinations which we didn't test.
>

I think patches 2, 3, 4 would kind of depend on 1. Without 1, the others
would probably do the wrong thing.

Or would it be better to just squash all into 1 patch?

Each patch does fix a different part, and also I didn't want too big a
patch, which would make it hard to review.

In terms of bisecting, even with patch 1, the bugs fixed in patches 2, 3
and 4 would still be buggy.

>
> [...snip...]
>

