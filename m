Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FA3AC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 18:27:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B6AB6B008A; Fri, 10 Jul 2026 14:27:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 067DB6B008C; Fri, 10 Jul 2026 14:27:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBFDF6B0092; Fri, 10 Jul 2026 14:27:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C2CDE6B008A
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:27:48 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2234A1693E9
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 18:27:48 +0000 (UTC)
X-FDA: 84973700616.24.5129732
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2FA3C1C0003
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 18:27:46 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hDTYsRjO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783708066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G635h4I2V+p0m/wOyd47wylSurhPep4Y3n9f3ufifdc=;
	b=dwc4dbdMe0KQ898MMIIJReGweYVBpxByaxgmXUrOM8/8q8FLWUdZaHLHlQp6yLl4eg0TaH
	FIgBu5g7JmgCkV93jbDlCiVxsqiXwJ2YHcp9ZjO/DraALU8ZfXGYEEGUZTsejAG7TqUZE2
	GDmZ9FC/ntKuUgx5d0h1se0s3Dj4e44=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hDTYsRjO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783708066;
	b=AK4UmhkL71A3QJyuvLWiS98KCEwGn2/ff7+MoX/GR3I8RNa/6eZN+aRvZpjQXJLibWxyI+
	G63t4nxOHcx3kEmabjxKgJYNs2X2Wzc3q70c11bkujNDf1F0B0AqFFJ0Q/J1OjDllaIryU
	fXNVD9+CxiepNmiraZhf4D0ejVEBBU0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5677943ABF
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 18:27:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AB211F00A3E
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 18:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783708065;
	bh=G635h4I2V+p0m/wOyd47wylSurhPep4Y3n9f3ufifdc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=hDTYsRjO/KVM94IvNwqR3H6ZiNZ6AoTEOjpiOn9t6alNZ5yJDE5ZA5+Gt9AHg73QU
	 a4Rx3XfQiy0Wzs7rx59vtTI9x99MT9uzYSpDsqkVGjlQbGyd1O+7sZ/I3zV1LLSRMa
	 37SWIWUESDk2OsgiJZ0xalFXgOqPU/0zfHOlAiXdYySoQI0hWQ6Pm6gCpIp8oBRTLY
	 8xDIrR+ZxPCrpQ6yM0V7urXr/xYqhwXKHX7Wv8hRDOY/PQceSWPujj+KTpiJITuA0w
	 WzNu7oM5zMyslQ2uU3Ue0JVo49b7z7dyC/2vL7s4SddvVuWHM+UcnvWsuoaNTETRaM
	 d1Q2eGUlJ6ZyA==
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-698b6c87884so2028314a12.2
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 11:27:45 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RoVR5JxenUg3tT8ymMWV0/PcI1sJtKFtI0cW+bppqJJr+D0N0+92mchgqmK/yR2ZqDXXpJmR/0ZHQ==@kvack.org
X-Gm-Message-State: AOJu0YxCQg72624FZk1GRIftB6Hv6ixOFuRkZ3aAXk5sqeDISR+GULJO
	W0bNpQ6aUil3HwjeqUjwNgeYn9TOlwwWfhNvtsVUI4I15tzlx8muDUg61U6LERN831f5eVZPje9
	nE3eTWgyK/mzzpxYFLpOvnbkUI/Fz/R4=
X-Received: by 2002:a17:906:9910:b0:c12:5013:4b7e with SMTP id
 a640c23a62f3a-c15cdff24b9mr411744266b.18.1783708064108; Fri, 10 Jul 2026
 11:27:44 -0700 (PDT)
MIME-Version: 1.0
References: <20260702180908.150136-1-yunzhao@cloudflare.com>
 <akbHBZP9HxOJMtQB@cmpxchg.org> <CAO9r8zOiwgG80EjqdZFgWQvODUe1RzecLemxcB7xXNm_f3XfbA@mail.gmail.com>
 <6ecf5579-0b3b-4e8c-a625-bbf0a4a48f94@kernel.org> <CAO9r8zP6JrZcBnzb8A3A9V8so4gJMWLvrJQ7VwPyyU417GikQg@mail.gmail.com>
 <CAAnvDSyNbV5xSH0hrX9Tgw_wXU7Neo-XSJ1enebxJXvjOheHWQ@mail.gmail.com>
 <CAO9r8zODSyYTipACxdEzoheMrNKzfFt_tjBzrB+2tSCHA82WWQ@mail.gmail.com>
 <CAAnvDSziZM9TOExkFrF9vNi4VN=7T6yofS-=4rmFqc3jXncveQ@mail.gmail.com>
 <CAO9r8zPuX0j_fZsgRsaNQFyJqY4rZxERLya69TcCF83HrpHy-A@mail.gmail.com> <CAAnvDSyDYU4MvRo1rNwxQcnmwHe2_UW43-hZEU-Zf76B2euYQQ@mail.gmail.com>
In-Reply-To: <CAAnvDSyDYU4MvRo1rNwxQcnmwHe2_UW43-hZEU-Zf76B2euYQQ@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Fri, 10 Jul 2026 11:27:31 -0700
X-Gmail-Original-Message-ID: <CAO9r8zOPMNDQWZ8z+RsApbA0cddE1au5hTHdRT0NYe-EjmP4aw@mail.gmail.com>
X-Gm-Features: AVVi8CcVOx6gSgVFTNf9QKzASWbrpQLjBYiC-eU1ewwXhWd-d2vT8BIBwlW8u-w
Message-ID: <CAO9r8zOPMNDQWZ8z+RsApbA0cddE1au5hTHdRT0NYe-EjmP4aw@mail.gmail.com>
Subject: Re: [PATCH] mm/zswap: use ratelimited stats flush in zswap_shrinker_count()
To: Yunzhao Li <yunzhao@cloudflare.com>
Cc: Jesper Dangaard Brouer <hawk@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org, 
	nphamcs@gmail.com, yosryahmed@google.com, shakeel.butt@linux.dev, 
	akpm@linux-foundation.org, zhouchengming@bytedance.com, 
	James Houghton <jthoughton@google.com>, kernel-team <kernel-team@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: mspd1afxfoe46cad3t3qrnoto7wtkmyo
X-Rspamd-Queue-Id: 2FA3C1C0003
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783708066-177120
X-HE-Meta: U2FsdGVkX19NfkFN0ZEDZ93yegEMr0HSX4AIfhVDnYxKWtLGWTr5VkB69pmm6OpqoBxcIgs8fiLZQeWLsFw9+fz14S7SZtHmVV95gzyComM3vOfXy7cg91nsgD7LZmfH2Aq0NwUPLthzy7+g6f8O4/RkgNc1+SuZPIujBXTvt7bJ4DLIuLsAteNRyE6WeKtAYVi942C1yYVEyWSrvSaDD2RpsUy4A9dt2vq3WEsnK8oB11hJPmRZaJytIJcYUVofOts5oTuaAthamwlUgqu7y7VOZzYJvBUS74P++ngbBUyF2+QY6ODHAgNHKmqylP6i3Clr5J/fJIg5LpSdjSNQ1IR0mXGM849dVECrclOWpvT8oOcvGvl0OZqoO4V04zIfRyPqGdCZDtOGzNnnl9JSlZlPqJOtI601rcp7ZtoHD1tTOBZ4fpuisPaLdRWtdcrsbXkPyKSb4HJZ2uGyJIGS48juh+NtieXr4udnSewB4g7WR0Vk29zCDOcDtpboh8MZAdckuLbKxEv+G2Z+ehOoLOIsSrx9wYKB6EXpwo8PhYrtpqFYbtihOGg7j+F/sCEvFDExJ0/OwpBYC9NEtG4lN7k1h3ygNOEqaND9yY7oSHf1AdwmzxWJyy+o0PRVMnF7EIzRDNipn+y4oth1OY6BBuEBdad0qfpyyNZ5BdnQdHZyPNnWtlGJOkkbWHNUbHZ6RM1WHxXK8VllkQxwZ+6eJFvbsFewJOVJw35VtPjyPm2iQSjmHV2BzdRbTcq7WVW7QMmjO4mWhuBw5ItUlM0zEHFfsUPKcuJBW75EglO1pyD+BjGmE2ako8vsa4DqWsNGFvH+lo1wKPsJ22KITZNU0WtTXyRaEitg8NRJG4DylZRcSr5+WkEFYVF95is12h6W55AnkXpwg+Xv4wUXR5wwrv9n3HQpRDY9YkvHnc3OW8qxWm9kIAc5qWcd2hOXFsB3yee2vBtEjcfTvv61pOJ
 3LqHk9QH
 bR3ZhO6USxD3wHjaXGDsOSIVv19TmWrxx5WoDNT0XsZaNpD6nzdG6Jy+fOu2+MXa6EU9s8CI8dnAqVNqwCPq7DkOFjiqK84ZRK4ZiZbRjkLH/lQwunrYILRMSdgQ4BJHCZvFJ5fqV2E/UexnnS3kE3tB/o4yfqyBSIZ4cj5PpnoHIw0pyyP9NhCbbYQSmqqNJJb4fG5lkrrb02zllnPQQUOdJxJvwyLv+KKYIxWZtIM54MlHH//T6g8oQblGmynwFGrzaNR9f++OEyWG925l+Pb9Bc2gzsXgZ2TyjYpPwLb2q+s8IEsAjl2tHQT/jJaaZsy4Rju13CyD2zz3Xp27W4McB23wvgqR5zEz7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 9:36=E2=80=AFAM Yunzhao Li <yunzhao@cloudflare.com>=
 wrote:
>
> > Yeah the per-fault latency is exactly what I was looking for. Seems
> > like most of the faults are not faulting in the pages written back to
> > disk, nice.
>
> Yeah, at least for our workloads the cold entries seem to
> stay cold.
>
>
> > Would you be able to take a stab at eliminating the flushes as I
> > suggested above as an alternative?
>
> memcg internals are a bit out of my depth to be honest. I can
> definitely test a patch on our fleet though and get it verified
> if someone picks it up.

I can try to come up with a patch if you can help with testing, but it
won't be for a week or two. How long would it generally take to verify
such a patch?

> The ratelimited fix in mm-new is working well for us in the
> meantime, so it'd be great to keep that moving forward.

Hmm we can keep it in the pipeline for now and perhaps drop it if we
can get a proper fix before the next merge window. Does this sound
good to you?

