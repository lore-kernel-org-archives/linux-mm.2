Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC1CCC624D3
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 14:51:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 156216B00E3; Wed,  2 Sep 2026 10:51:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12F3E6B00E4; Wed,  2 Sep 2026 10:51:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 045EB6B00E5; Wed,  2 Sep 2026 10:51:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D553D6B00E3
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 10:51:15 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 63E5EA0244
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 14:51:15 +0000 (UTC)
X-FDA: 85169110110.30.6A0D46C
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8835D18000F
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 14:51:13 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cenemIIa;
	spf=pass (imf06.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788360673;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wrGfg5gVzYagKEx9/qjy3DYn/Yjk8uTufMk6R5YaiDc=;
	b=V0DxPHoKKDayXhmInZxYKo3Cd9x7oduJ+znfUocCDe5i0JnAb6IS5dQYplHUdp6+2wYWQt
	GwUgoBJBZbH8X5iunUZnZpYSgDD66cPop/TKXi40GbTeRqtHi3LjbOypQGrFXON3PjwjMj
	IbwsZ2/t9pIYF/DbktrcjIsfSt8zcBk=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788360673;
	b=G828T0QEjgtWQHti5sS4civy3IV/80FErHCZ/We0dsQjeFXuqbUXTrXmaB7F96nFJAYtUt
	RRMXkgUh+QysBljbK5DGf7c2gwtOXmYmLDVNYiicSvve3g6upq+W6duJZUTPOOYz9daiB6
	gEEUyRGoGLofAdJbavA28+OvJfruXkA=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cenemIIa;
	spf=pass (imf06.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-4843e9c5960so1189014f8f.0
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 07:51:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788360672; cv=none;
        d=google.com; s=arc-20260327;
        b=PdDabG5clC52YMOEvStb4KG0TzJFTqt2GS9WY/haXGf+djAOGwiwguKjoJKsESkr9S
         cP9zLnZu+gHh2zbwDqkqUyt1ocLeyNO2PMr3T+lNEO5Vmx2m8ljjCioElxSJns2JtzNM
         eYgtBHHQm+RRiQg+xtv7DyhI6IWagkMLvoAir0wupBS0bQw8zXLfW0xifCWbhVia0VCV
         Lwq1O8C91y0LZi/B12IAkX0SL8ItSFLsqEt6weDNPwgsdwgw1bRj5elFQ3uydGVvpCXo
         b6rTGlNTzG/OsslytvJFsHVwV4AAkQqT8Y5ODMor/5qg5nAqs/0FHd7TIlDG6cdw9EPg
         Qt/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=wrGfg5gVzYagKEx9/qjy3DYn/Yjk8uTufMk6R5YaiDc=;
        fh=KewnQt8I1RGzkGmgAsxpY598ouhBlUDawARPe163as8=;
        b=LiRdNFiOwEDXjjXwuoTFvDKlE5YR/bkE2bXxunzEbiqOE1aMTQIFtzbkP8As9qNkmM
         gqgC6MC5sw9h7ei15b1hxu5owAd8KL3cRrCWCIbWkPviwOE6jPYOLVQbVXvI1pAvJh6K
         JlswHxfRYyyCOlJyuM8B1U5EVo8pZ2WqtK0HayCnLoM7NiUpSjYwZA9joeFRWRx9FekW
         bDBUKqZgYK2LJVF3aQcpClAp57QernsmmcExjT19Q+DBSQ+tOt/3cl1qGSa1DitHpCXP
         gsh+zzoAs66mgBypAtjam/OcI43QCUadqPL33ZxnUESHTkYeKAulDY0DTqd2pfBiUwVE
         FrqA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788360672; x=1788965472; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wrGfg5gVzYagKEx9/qjy3DYn/Yjk8uTufMk6R5YaiDc=;
        b=cenemIIaMfcmiiO+4I0RmtRjkxRzER4QBx+z0DIRS/LzYQduTgXDjdZ7ZMQMps/5gX
         AvbTydTz5U+TnkRabHXo5LuIJM73tXl8PnieLwM7eriQ8Gtg7LJoa9IHCM2BJSddVcuv
         V/bQQpl6LAXhaVYeQpUPpr5jsqeMMBrwapOujGtPUUI8G58DahdjIYoBw6WwCPEl2MIH
         y4CLAQY+KVKobhz7ubMY2i2prXRkTLlUoI72uQ96jgAJYJ7Ua5GuybsxAy/WyrE3mmIx
         xDCGAvkkCime7L0YRko3GTocJfmWBFHhrvd68egk+mK8lk+vKwL64MBvFJwNJOYpa/cz
         /nwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788360672; x=1788965472;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wrGfg5gVzYagKEx9/qjy3DYn/Yjk8uTufMk6R5YaiDc=;
        b=plYrvdGtzvS2rwHrrboT2gqd6pd1KLb8IMPmOfGcIuYJOTC9TRDcBKgjrRWHcGPI9S
         W16Pg8m85b/C/6xH/jEC0Um2+wy/aSCAE7uJ18QBGWKmaUkW1dnSTzEwMt30Y3QMg8VZ
         5/TiR8VVIbr6YPfPZbTqydsXoFJOVg8KJfa4p/4GhNKa85yj05NjwVNCDuxiW7vf4ewq
         HusDIeaUFwCpxNOEzuN9diN2J8t2SDsC8PMZ4ADdZHKxgXtnrTSvDhTFjcrsFlpvEnsu
         pQQmeH5VUk52ptEr0sx+EVqXB+33/epLTLQn8JxYCYarcJLXbiaYSAMuQ9mN5VaPuLBe
         KkHw==
X-Gm-Message-State: AFuF++kWGO4hx4JAAc2lQeQ5YJ+Q3PykJPYryhpBPAMJf9YgvIpzjojK
	DUE3tILP3V+76ev8wt0779HRTI7pQCcwM4cDcBwMBA4xQH+iWMWf62DYkyXgGlD3M2i/L/H7ubS
	Q5+2Tl0fFdigRly0bwmp6R/1TmxblOJw=
X-Gm-Gg: AYBFou0VCrz6nb/o83n9sOt1D5UPHXk0dMflGs0OZuTCkgokaV9A6pxR/zHRzSNVTSR
	3LJYOG+PgUlR/ESOT50VIeZSJvXYfAy49uPki0VgQz9e2X28fl0dgzF3tOpsMFNGt/oYdDp9/IS
	/CQBO3BHTQbqtAWXHl/nXnp64CwnU1Sb6mAmbGd22rI+dFWrBrZd2W3tKpCEC46E+65oIXzVx5a
	I6eyh3IPPrH2U/5VumIhyyThTmzF+H+Sk34H5z/KskJOf5oxipCuqneAsRqk3rgcWODVqrbZVA+
	rdmRmoQP2SVxJ1xje4E9DqSMg7NtiCJ3NQ6xIrMxGIoY6/plweBeTgxHGBteti8wuM6DcBkJzaw
	nkA==
X-Received: by 2002:a05:6000:2f8a:b0:484:3310:9aae with SMTP id
 ffacd0b85a97d-484914cce11mr8130407f8f.23.1788360669245; Wed, 02 Sep 2026
 07:51:09 -0700 (PDT)
MIME-Version: 1.0
References: <20260827094509.1016740-1-hebaoquan@kylinos.cn> <20260827094509.1016740-14-hebaoquan@kylinos.cn>
In-Reply-To: <20260827094509.1016740-14-hebaoquan@kylinos.cn>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 2 Sep 2026 10:50:57 -0400
X-Gm-Features: AcwNN1UNmKBz5l2WM6rEkQT00DDxxmkQydUSy43DL8N09BO7fbVmSQJrbh7gX5E
Message-ID: <CAKEwX=Ovm9DTLE_8E-dQ_47SVrOQBY0hLbF7vS9MpDy2bUThCA@mail.gmail.com>
Subject: Re: [PATCH 13/16] mm, swap: defer xswap shrink to workqueue to avoid
 lock recursion
To: Baoquan He <hebaoquan@kylinos.cn>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org, 
	kasong@tencent.com, baohua@kernel.org, youngjun.park@lge.com, 
	hannes@cmpxchg.org, yosry@kernel.org, shikemeng@huaweicloud.com, 
	chengming.zhou@linux.dev, baoquan.he@linux.dev, david@kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 51hx55q44zd1548gfff8j9e5j1r631c3
X-Rspamd-Queue-Id: 8835D18000F
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788360673-812247
X-HE-Meta: U2FsdGVkX1/C/9ha3n4ebAjau7+0rhyjczyg6eoHPrb6+gmHe8Qv+J+GfEtPNCxyMF6KVuLP/6kpCYV7Jy3zWqc9Rzlee/EK7SLHgRCSH6IyfMjreSEJhBD8VVA+/dXreRG1PqxdVoPVQOfmwNwBv4sJUGLx6kegbUvzPxn8ylyvRtEVfK3+aPmsC+aMN644JdUpUeLCEBd7DdQ+5vfQ71ISlGEBeUN3VqYYMfUips8t0P6oiUYFdPQ+Uchnmyo/n0exsMgmF7QZh61B7Mo6kbnw4PJqh0cmbg6Mzzy96o1E06S2NRE9nNjk2zoWCGty5MfBzwf+V22uDXDj78THuj9xAA7Riz3cH9377e0j3Eq5NvGpn4ftyfwpfq1ywfYXrzdq4kVfDst9kW86Vf9otwJH+FgXjVpqzcH649zPwvxXtVOk3s09Ahx3waPirXa2EechnH7XEjYlgbq877tTVlKpZQSGV4xEh72hhlVW6HtbpiUCZdtyzuBv6JUWCITCw7wR32hFc4SDbOc3fvE6h1Vr4S2xFmAMomXW4rAxKxuhc5nZVhKP8hQT14vAfYcE879wnr+qVLnhIfW0LgebNBuw9ZqJ632S8r+yBw/E18G1wAeDwKfwm8eV7OVKZgaJL8zqjKMqsar+0oATRp1O8nWagnjPg6BrR0Jiep8sC78nJL2vgdZ0mXl0wtTXEN7bM6W3ue3E1fwUaNQK3ZykW5Sct8Lj1Aby/0oQebEGCbhXO7f14peCPkvmdPSh4tYTF/qcHg+qd5XcERwgDEmfDEktzBF29YvWpHaxPgDltN5iEc2XuVh+ZNhualOk5BVC+KzWDIGLrZe+dNDiei3idT66jcTjVVSi0ExKCePr5ZyYfn54Kro6IPTbBN2BPfn/MaKfIIo/PzwNhbOAV8472OIBMpwgcjrLyAkSV3pt97vKNUa8Ljv0UkiIWMWvQb87R/lzLrdWzr3nP+fIYuI
 zuDEsSrx
 JUzZZs354cZRvL3hbLPPxQJGeBM6LLR5mgu5/lg8mcMyLCO/MFjH0//mt0afJYdQQ6Px4nltvebWw96dqMMKYui5/RBbSy9OdabC8sC/alhr8SlsI2ZUa7WR7ywYqAkS2d/QApbXgQNrBSH3ceC7HAgvjgFMwg9vqPTH8gUcIEIn+3bJkV6p1xQ/5FFx9N/m8rgVm4KOQ/2pBJ1mQqis9lj4kaUx+g7/moiKltXRIr4wSmL87nTWmGLsvLvJFDxNYozbKt1zE/n2ZnQ3pf+9gw0WeoyFGh65icL5H+wu7zELvkOnF9PcEl++cuSE8y0F8HR80p4PJqRQLemEb8/MRVMRXKa99CsN51TpdchKPY1aerT2kk4nxB9OytFPPoRdzCU93gqDJwoJqinKpD2q8EmsBXg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 5:57=E2=80=AFAM Baoquan He <hebaoquan@kylinos.cn> w=
rote:
>
> xswap_try_shrink() was called directly from __free_cluster() while
> holding ci->lock.  The shrink path calls xswap_unmap_clusters()
> which unmaps vmalloc pages backing cluster_info, and on return
> swap_cache_del_folio() tries swap_cluster_unlock(ci) on the now-
> unmapped address - crashing on a not-present page.

This reads like a bug. It would be a bisectability problem to not
squash this to an earlier patch, no?

