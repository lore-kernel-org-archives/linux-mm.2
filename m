Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF6D9FF8867
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 14:44:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51F386B0098; Wed, 29 Apr 2026 10:44:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F6C06B00A6; Wed, 29 Apr 2026 10:44:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 434296B0098; Wed, 29 Apr 2026 10:44:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 33B276B0088
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 10:44:22 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F3FDB8AF46
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 14:44:21 +0000 (UTC)
X-FDA: 84711863964.16.49092FE
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf09.hostedemail.com (Postfix) with ESMTP id A300E140005
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 14:44:19 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=dlzO5Jd7;
	spf=pass (imf09.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777473860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kVcBlrxrwvuMTzkd8qfu+aZVhxmu04I8GEJ4kfvWPFc=;
	b=tt4f+TkCwAp+cRlUFqVaV3btQLTXEOq42WEwj3CijianpoXAgkSkV/kHgWcxcvPBm6tumm
	BGdL9UM0fkELpOzFxe+W0eQflxDnuQyOUlSZ1y7pwSm0KO0CbJVDPjcVAgR6ErdY83D4xz
	58Ds389qdJlufo9gUZQNIrP35C4skaQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=dlzO5Jd7;
	spf=pass (imf09.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777473860; a=rsa-sha256;
	cv=none;
	b=NUAZ3DdNXNg3U7dzjImSSKT6Pn34VSdcyqjQI3T4lf+5ftMc432rwYa/pXmLtHljwtlzB0
	3B6wbUskaeebuoMrCAOIi7wpkX3RKqmBI4uDfTn0owi8TbHhCfgofIWvqsL24ZRpxwQ3m1
	54fJiVvXQYFQdrShs1nT8frDcCLJT/4=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4891c00e7aeso98587715e9.2
        for <linux-mm@kvack.org>; Wed, 29 Apr 2026 07:44:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777473858; x=1778078658; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kVcBlrxrwvuMTzkd8qfu+aZVhxmu04I8GEJ4kfvWPFc=;
        b=dlzO5Jd7FzUt/eR5UNOEb5O2LccNIYdMInT+/vsoM7dfG+XkvpyryM3xBie+JW/WQp
         6xhaLRF6vbNalCdJoISwF21V4SVFA1jhp8Q5gofyscNg9fkXP4u4yE4SvUXqFMaqmc2B
         uW8SN0yPOrBQSD/y6P42SSwsXt+/fDalxU5c3cQ0q2z30rBcX64/4AByetUPWUe47FTT
         LcKH73UsYBbBRvsY/9h2ZJWrDwpH3FJmc/Lh9Qe10QMbCRUB/8IDXAStfbc8qnpvEI/K
         1QcDjChlTnu2vRLiyPf22g2MKFUkFyfT47WkN/ZM9LOhGeLXbUa/zZ8d1AZ83r4FzlBX
         kS8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777473858; x=1778078658;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kVcBlrxrwvuMTzkd8qfu+aZVhxmu04I8GEJ4kfvWPFc=;
        b=k3ASCVrFocTsozJntgJd7q/JPsZKwW7cpWSbUIz/O3bVd0dlnX5kxlJrKM1dlKUQA1
         KVq+lIJSpuBZmNpx4v3dWKTX21q51kw22VDZTgQVfW0gVpt5AmLLd5OkxNqd35pKtlPt
         MdYYMe0YqEWf7TJU6ZPfpinCUkxeO3PAWdMX4n5DDONndO553zfkkKp6McpeNmi8IgtA
         DUx1lrtA8SdWfpMpsxx2fbWh/KaBxy6xA3tKurgDLGlpPIbk6rlhKxOGLr1Kd1OSSrp6
         /xAW3CbKAe02ptxhwewm5mN0u1hwjrn5XO70lRnWdgHKmFK7L05oigQwpYYkwapSnh8/
         XKPA==
X-Forwarded-Encrypted: i=1; AFNElJ/A2ddUu8jHETHAWgUcyG61LWZYv2Bx8NKV2OAorM6AKyG6Fay4PZMGFnvOh2GjIJnAo7FvIE/K4g==@kvack.org
X-Gm-Message-State: AOJu0YyBzxftJxkQDqnJS82I3FvpQDNTKzISWW9+mOYl76sJjMwg5ZfX
	JypGbofsLirhn7SCSyycoVBggddgEHoKNMH4X1rxlAS6Zc6annA2VvKUsA3fBUH4vkCqWCYHZq/
	QqUeF+S0=
X-Gm-Gg: AeBDievyWCm4NzTNv5g3QKqn2iusNGGOCmIPMEsQr0qF0dOM842C9ZG1nIqPc/+gtIM
	Em5VUmZ7qIHdnDBpzlRe7O7EqOqdt+UA7SPb7nFMaelNIGqnhFIubX4uvWkkgn8xanz8HXeoJQm
	HEZiM4LFF4VtBIwjaaZQgWtr2T9mevbRwsNwrhNN3brecBdRKTi2VMUvj/t0lxQNPcihLlSP726
	qPvCF95HkRAnX0vll597CSLRRwu0YsfZp5lJlpROL5vCkfDRTkqUM3eQwv9pt8WiIKHkYyGLLHs
	W9AVvITWkQaGY/Qc7Moc0v/00aDWPvfYg1qcmkqA+0X2LR7w9rH06HHhtPThltwqVkFY2EDoTvL
	mv0htDU/flSEXOREq4AI7LiEXNd/a6OuRyDTOxJANMF9LhFkdQuQT8TaQc03gmn/DR2Oc63tvge
	RA6Qt1ALfM3EYkjPHoLsE6RQ+XUTRju8ZrrvQG4w07CLBapRE=
X-Received: by 2002:a05:600d:b:b0:489:149a:f9e6 with SMTP id 5b1f17b1804b1-48a77b2a5bcmr96586255e9.28.1777473857818;
        Wed, 29 Apr 2026 07:44:17 -0700 (PDT)
Received: from localhost (109-81-86-177.rct.o2.cz. [109.81.86.177])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a7c1d0228sm83315235e9.2.2026.04.29.07.44.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2026 07:44:17 -0700 (PDT)
Date: Wed, 29 Apr 2026 16:44:16 +0200
From: Michal Hocko <mhocko@suse.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org,
	hca@linux.ibm.com, linux-s390@vger.kernel.org, brauner@kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	timmurray@google.com, "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: Re: [PATCH v1 2/3] mm: process_mrelease: skip LRU movement for
 exclusive file folios
Message-ID: <afIZQOtaBabeHtCc@tiehlicka>
References: <ae8NT0tLt7eBmH6j@tiehlicka>
 <CAJuCfpHQdA7C50V2WjNrdYcp7feV5ukgxJf+vMNEcp0P1SGEow@mail.gmail.com>
 <ae-Zu-VAzAA7SdLa@tiehlicka>
 <ae_roPR64e6sY_fN@google.com>
 <afBaJLLFigkdszov@tiehlicka>
 <afFco71vwmpQy3pk@google.com>
 <afG-4hq7Hr62Uu6J@tiehlicka>
 <7f98f461-62a7-455d-a7a8-cb8928465946@kernel.org>
 <afHeXY-yeTwmURWh@tiehlicka>
 <4a612d63-2838-40f5-ab67-79bf35dd3a56@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4a612d63-2838-40f5-ab67-79bf35dd3a56@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A300E140005
X-Stat-Signature: 14hn9m1u9bdrbbizuu668c8adai53jbs
X-HE-Tag: 1777473859-136778
X-HE-Meta: U2FsdGVkX187HWj234gU86sgT1JEkDwCzkPOpyvOujkBHaQkK/dYO1YEDav4OPt9LxyTYbxEE01Z+r1t+wDJ4j9EASnVpjCvIRnI0KaU9GJVQeoHwJpeJRvdyqtGcXicDvanR4UjL6FzWDckKrITSp39ldRu9KFhQmeyGozEvbEmTYMW+LoldR6JjuzDuPCeJPU+U4jHeizsDvzjCtUhR3SJ1VzybkIne5DYWIEUPTbVnXTd4DpRPxyTK1/6T+zwyy2qM8MVIMFC9glAxNEvO3m9qx5nQtrBuNM7acS3axp55tlTktLethV50Iu7y2tpgfDHuWJnI1COUiAZI5wHQYcEnt8CYh/hejyIvRDMG8TyF0TXYnJwehaFjnL0Fgyix8kA/AhhMG/XeoZ/33H0gITH2eOE/4DbNMbqm+ORtdcEPlHjdqJn4lmLxqxWvPXq7SV052F09RC5bZ497jPl9BB7e4Z5REddmXn6grJin4EHsZS++b1UQHMdQ9aNAWJVaJs0jmVq7nQQ8hyLD8XGaT7pyxzvlMPtT4Fuo5G3B/kr0rQwoakdr3CCvyOUZa7dPxQ6rv6i5nuELAQVTtonc0I8bNfDTrEGion2ENAaPGjdEvOQSN20J2MBrefhZSmyTAhxXy1O5bl+fW9hy+LNTgzOj+8ijiVcPJBvs5Lfofbmld7EyYFhcSDHnvy8lVMbfdjk7txzS9U0zsuIwdoMttOQcsVxFHCLH/Hh4Sg6vUNui44Cr/dGrOP8nR66BSgz3K/bZAKesJJApS2gNpI5IG1SPVyB0RYBFhs6SMW7/LEIJgF8xM/K3L7eekrUSHPPlJsfOZOifLvnc35oh+b3kcxIjO8RyFaUxx9iP/wi/dKT6M/M2KCDYBO1euaP8UCsDKGa174GLNqLpfZjzCu3k+DNjqGCQOTTNOxTnw0FjMLm/7sgZ4ivwWP7BcfJosKfh6+JJdV/0OkkwP+Dd9N
 53iP6y5H
 xBD5LDT216rfulYEIhvWJ6p0Rfg3ZeOMwJqx5IVlQudPvU4Qbiyr6o5lQ2UBzIJZRsvdj53KC2741dfPVChzcsphEE5e5WKz4y+pjJPZKSOMFzlIviAKGRiUQgsb4pwMiiEhtEnRe/D7KmX6hbKNNYEtyms+9FjTlSeFeBPj1tiB9tgsKS8xzHS8GcSp94YPPkQrKKLLW/Ns5+7VNx/2Ud5IS+3uVFIY2/aCyd2Q3ZLda8IRX2MMrwiEnCADdqMM62bjUFhbBKU+F3Geuz8FmoW26+DZBPYBnddJrt7C/xc0UIHcLvc0JoWSFkaIdiUHtOEcblxR87gVIbMpX5WCScBRxIZl7xJfXFKsQbyinQl+Yl46ecQile5EtHmFfh7VvYvBw2RQMZ2Ne/2/tPcfvd4AEJtQWRbkKf2OCaRfzzEy5fNJKI6QZ8vpEsiKmL+FXEGqnebF+Q9dgBTnGP3pCrVyfCD9c0pGF1PQxtys+4aPQFW4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 29-04-26 15:07:04, David Hildenbrand wrote:
> On 4/29/26 12:33, Michal Hocko wrote:
> > On Wed 29-04-26 11:09:55, David Hildenbrand wrote:
> >> Unrelated stupid question: would things be clearer if we could rename
> >> MMF_UNSTABLE to MMF_OOM_REAPING once figure out whether aborting fork() still
> >> really needs it?
> > 
> > While the oom is the only current kernel user of MMF_UNSTABLE (in a
> > sense it sets the flag) the flag should denote that any page faults are
> > reliable because it might fault in a fresh memory and user would lose
> > the previous content without knowing that. Not sure MMF_OOM_REAPING
> > would reflect that reality better.
> 
> We use it for failed fork() as well, but that's slightly different semantics (no
> real page faults ever made sense).

The bottom line is the same. Make sure PF fails rather than silently
provide potentially corrupted data.

> Looking at the original patch here, using MMF_OOM_REAPING to modify zapping
> behavior would be clearer than MMF_UNSTABLE, I guess.

Ohh, you mean to add a new flag, right?
-- 
Michal Hocko
SUSE Labs

