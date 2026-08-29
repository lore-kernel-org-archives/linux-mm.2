Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2578CC61DBE
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 06:05:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC1266B008C; Sat, 29 Aug 2026 02:05:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D72C76B0092; Sat, 29 Aug 2026 02:05:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C89596B0095; Sat, 29 Aug 2026 02:05:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A95786B008C
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 02:05:41 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D47F480668
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 06:05:38 +0000 (UTC)
X-FDA: 85153270356.07.83C9584
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 0FCA1C0004
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 06:05:36 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=njSa9ZdW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787983537;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U/TNpxXOdrQL61OvXDHMNpk6Uq9BDXbfNNEI4cvHvkE=;
	b=CfFsYYvzcM/noqoWki5ACz5C+S24r2AO22iFkB3Kf5I2uNXaBOdhaSyj3ZTCq8Hg562Cyy
	xODuPUk/ic+R1ZBs69aAEYv4O1ng7F3EuFV32566CMV5I0ttCxYhlKXGGPFr5uHmh3KvpQ
	jTYqPf4Ml2FZ3dhgz41wMvqGm9mDhrg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=njSa9ZdW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787983537;
	b=7NMoEQNM+fNt7cOWRgzDNktNWzap7MlZUXIkyJXEyS3eXsbURGrfn9otzehLOvrMT+1kjq
	HZfo1NENiwgvWHXN4HzCpnacpWGJVcfFWzgoG0P2oJFruH+n4hj68ghYSdvMfkzpYtxTIv
	C/CXJ2OX2BlH71xgkhy/UrVFcIJkfKs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D574960DB3
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 06:05:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88F131F00AC4
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 06:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787983535;
	bh=U/TNpxXOdrQL61OvXDHMNpk6Uq9BDXbfNNEI4cvHvkE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=njSa9ZdW51F7u9sNbBbSeSniECyxKh0bQnizh3VPdRvUwiVeZcRUX8L4WK0vKmpek
	 s0OJspytUqxUMuWackfDsNRyOxUSECh3L0nbybetugS02R9OHuIEXtrGX2QrscqR1r
	 AeRCSWr+DPpKQrT7fgY5r62SpEPj1dMOhsbfJGDwfETLAo8wfVDI/xPPqj1f11AFr9
	 WlnEI2pVlvq4RGIgbmiec1BEtIaeo5IKsqawN1XuVzsvflPv53D2LX9rXki4fUUXN+
	 hw53DOWeyuCAZHUuEDw6QI6iXDlhrq8nzX04GRXJiyEdMydLBBvb7N1YPJLfKT1wUi
	 6PZfQO2yiedCA==
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-9390dd46b45so81941485a.0
        for <linux-mm@kvack.org>; Fri, 28 Aug 2026 23:05:35 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpnWErELf+2yAYzj0PTTm02oR4H6pqntG796RhH937HDTEv5ejOmsM5RPgfe6hI/hH1MLfhv+Uuyg==@kvack.org
X-Gm-Message-State: AFuF++ko4J0ZHPBWLG0NHV/7g9uduH05s6XC+jBLyrNjQ4zO1/Zfj2sx
	X9FF0orEjcrItGCrdrOjm1TT5kdWXhD7w/+XviONoVyyjBA+Oc8HmR717ah0kbo2RQT4pJFSys9
	lz0qTy8yij2YI6VLaUbMP3WIr88u+qxs=
X-Received: by 2002:a05:620a:28c7:b0:92e:7c7e:9c9a with SMTP id
 af79cd13be357-9391392cde0mr1366007085a.31.1787983534861; Fri, 28 Aug 2026
 23:05:34 -0700 (PDT)
MIME-Version: 1.0
References: <20260820045603.68809-1-baohua@kernel.org> <7e897a4e-2075-485a-8cc5-5bb928fba437@linux.alibaba.com>
 <CAMgjq7DFpKU=QdT4QNAREL8oLg-OAxM6zMcYkCECBVg=U5ECsg@mail.gmail.com>
 <56b8e283-f849-4fd7-9c2a-64b604176a82@linux.alibaba.com> <CAMgjq7Aemn51JRVx1_zxG=Z3ZhTBUW01erEpgHfDWT=BPGBLMw@mail.gmail.com>
 <CAGsJ_4xyurha07UNXB91jP5De+syHuVi4EyAXfMpMWZvr4n1kw@mail.gmail.com>
 <70133332-966f-4bd2-99da-cfc5ad5fb6b6@linux.alibaba.com> <CAMgjq7DudvXYMLD_1hnbK3ivPY0j6jUiO9b0JWdRg24B8vA7VA@mail.gmail.com>
In-Reply-To: <CAMgjq7DudvXYMLD_1hnbK3ivPY0j6jUiO9b0JWdRg24B8vA7VA@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Sat, 29 Aug 2026 14:05:23 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4y-7-hgz2TvMs8=RoACQ0ZWyJFqugaMxjbQqCTym8zSmQ@mail.gmail.com>
X-Gm-Features: AcwNN1VwCOvfnTCjzcZkqOm-T-J65w6YYJr1de_FRQVVIFGp6yGiSJJxNIRacKM
Message-ID: <CAGsJ_4y-7-hgz2TvMs8=RoACQ0ZWyJFqugaMxjbQqCTym8zSmQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] mm/mglru: clean up isolate_folios and scan_folios for
 readability and clarity
To: Kairui Song <ryncsn@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org, 
	linux-mm <linux-mm@kvack.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Ridong Chen <chenridong@xiaomi.com>, 
	David Hildenbrand <david@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Lian Wang <lianux.mm@gmail.com>, 
	LKML <linux-kernel@vger.kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, lyugaofei@xiaomi.com, 
	Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Stevens <stevensd@chromium.org>, 
	wangzicheng <wangzicheng@honor.com>, Wei Xu <weixugc@google.com>, 
	Yuanchu Xie <yuanchu@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: rz8dmdftmo9sqe3gf4txeg9yejp1cncj
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0FCA1C0004
X-Rspam-User: 
X-HE-Tag: 1787983536-763460
X-HE-Meta: U2FsdGVkX18XJj+P/8Xx6Ule+9RYymzRkzyy+tkVk/j9AfwYVvaPOXf8c7fvWAAmZU1muEIBieYUF8O1P3yaf2aBNDDWfXsdk6az359GeB0kkLNtRrD+GCWViJbE2/NxFJvTuK/BqjYksEhVdIlA8EoYSoK4DMhU0W3dKS4XfQFY6Y1ji6s/DQGiGgkPw/ae76df0iLNF7Bwzx2WcAQ5UmjAwkW+WdPNhAmA68hwcZIF0idUgDwphGogMhXpP33iY7oZBcXoKRWvdNiuI+ZL4m3NKgrcpba24AEeKWb45NFd6g0417FhFj8pvqmwohFmV5Ay0PARWH3iafi1u7hGXjJ8gxMExBSZAM1e0LQaw4d3jkx4mgtuBlBWK1ju1guZrrFEeZywja9StcbGQ7yCx0GA+5z7ZwIoPAFHJPoNQ4EAXHKXA3OGLo62mKGkliCQeCahofhUu1ghmZ8npBl6CrEjvG4uAWhHF1jmbnm9ewfh52UfXgzmM9tHN1XyYJdBR9tFSMOBof9LNyedFMVbb/boRu6YTiUB27s2N01HG6xlIxgJAeluSdHNBYCkyMxNkeDV276PIL2KKW6ouUq5Ij1dlfoseyTrgiko8rOY1/WNGm4L0rj228ug05+eEyJlijWhjBmEOmRGKFBbiYmL17leiQ2CsGNqmxzfakF/5qbUl7SmLwsQHftBM7byYzBdBjwJZxKZfHlsuJmHV5b6+ydj3Ek8xWHvxqqBekXP9HeGBVwI39v8fFXeOabjeWbs5ZFBUn9AsEshrAyprqFkBNmE7oYlIMw0dgapl8nupABLqn0ZsTxrUH+30syKTqHRcr6XbOtmGs9TeDoQh0PIp9t4JMXJMFlmtyMcKaUrvbngAHG9anA5uSKg59apWkP/rrnxyqbmVmig/jkpDJlKqnlq72Z8uS05XBju2Us2kC5Ib4r/oRixYLJ8ymBRvL3lQtjhbdaTsJqf2HC86lV
 KL5mt0tK
 BMen3tDKZwPgTwz2kkRa7yi65c2mp2A5ZoJ1NWFMn6ZHtAzSHpEz3cK7Dl0nOwJDxHf0ds/Gy0ZIJBn33tdvviwtnjTYMM+l8mG3K2fJxwfmHRZJvHzCculUI9M6XdI7ZI6JHQmKmu3qyaojADKMMBS6zvWV1ZIeHtNQ4n8ws3Amlbmvzktw2lVbh43cCBfbk5Do8ejdI8biCfawbX076njHSg7bJW8LkmV/5zTrs+v/XYyZk2kG6hw4DmFXaz/f0ICdwQTeSEHH5USK+03biq6PqOLd11bNtAaemra7x4zQUMjSZjWhukrFuAZOpBiTvM7fnb4EWTmPiALsMN1GMr+zCuXDb36L63lV8n3z2WSMewGvMGsLwt1qc5F/zeig8AVP6eA2+s7/x4pxH5SIOMlt2beA6sPhlzF8hfQgCn0esl54=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 3:25=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrot=
e:
[...]
> > Anyway, personally I'd prefer to keep the original code until more
> > impact investigation is done.
> >
> > Just my 2 cents.
>
> No problem, I'm OK with this change for now.

Thanks, Baolin and Kairui.

If the effect of the exhaustion check is unclear =E2=80=94 it improves the
zram case but might slightly regress the SSD/NVMe case =E2=80=94 we could
simply drop patch 2 and keep patches 1 and 3 in v2. That would make
the patchset focused entirely on readability.

Best Regards
Barry

