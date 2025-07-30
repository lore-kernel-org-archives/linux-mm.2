Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55B54C87FC9
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 02:38:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3B846B0095; Tue, 29 Jul 2025 22:38:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEC686B0096; Tue, 29 Jul 2025 22:38:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D29756B0098; Tue, 29 Jul 2025 22:38:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C643A6B0095
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 22:38:47 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4A92C80357
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 02:38:47 +0000 (UTC)
X-FDA: 83719373094.29.EC0285B
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	by imf10.hostedemail.com (Postfix) with ESMTP id 68F7AC0010
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 02:38:45 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OhGLth4i;
	spf=pass (imf10.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.44 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753843125; a=rsa-sha256;
	cv=none;
	b=DJDz4fG3WUdBClQtjVqXHD8oXnyJORd9UWlCCG15VP76eXHs0AXbCtogRR6zoAXG4/1GVW
	dL7nZKHUFYXzovBLfIKjoUbpA6SP3+LpwgKWBiE6VCxiH/0+4EY5ZpnUMvYXSgNYQjM5K7
	3OiZlByDY8jn1s+Ke8JAexu7tvQd6Hk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OhGLth4i;
	spf=pass (imf10.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.44 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753843125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NIlSES37pL41WLJ1KE1AbPZe09fHZmPo8PDptY7TNIE=;
	b=ZqDZm6EZo+m2heTtOS4C3V+J7YqZLLwpByHQGwemUkfkb3/eZJNZ7pSoDANMWNZt2Y6i6i
	yJeyB+nFm52kuZRBNWVAHGBKLmpHue2rk5yEwU4H6ijRv6aVHLj3CyTsBZ9PQIYDsF/pci
	tGr51af159MYG+hxrNvvcidwe26mmA8=
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-70748a0e13dso22817416d6.1
        for <linux-mm@kvack.org>; Tue, 29 Jul 2025 19:38:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753843124; x=1754447924; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NIlSES37pL41WLJ1KE1AbPZe09fHZmPo8PDptY7TNIE=;
        b=OhGLth4iCjo5yz1wQQbapbZ0CrGuDdOcz/2gwl2K16jL9K4hpGE1zqIUb9VRBvLRnS
         f0owGbDg0U8X3cA7fMa6U9QGlJ1Y8DOl3Ibp8uxdxDhX3/K1XPog0CoBjk6fe/WSP9TQ
         K2TTBR+/FsIwwVtl7Hc+9KTha3xdC2CAHFyoaPipeZvehuREO8UGlxPgV2mMhz5D5ogS
         PLSSqmOpCT9LbEqcBm0fqRCybRwhYs23i3y6SlgrSlFIuQc8C6r+zcseZyrP4Gz4dYSP
         rBFubNvqx/V5o0HJgMoJAtu0Csi/GPzlJQCTBCLzJ/k8SZndv86NhhA/gm0ig7HP/qpX
         sNhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753843124; x=1754447924;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NIlSES37pL41WLJ1KE1AbPZe09fHZmPo8PDptY7TNIE=;
        b=lTSYNIMlLXuvs3c4dGYbDl/MpiYx9pN34rIP8WoHlgBV9WP0gy29zv/uLkznw6Vb/2
         S6J+FqyJnpmjlupDJzb6zihLglHet+myA6X2j9roZLxQCoDR0/z9PFUOKNOpJZLorzVs
         UdiZMHvw57ZwSIHTSu1Czr5YKoaO6rFOe47j2PGi0Jq0oDsT9qWA3U2pT9rOD4ExC90k
         H7U1ot7SOYMCv7iS40KNlMC10+s4H9qtfTGibcHm8QsVm/hWiQLn9e/VLi2zcO+jQ7rx
         KdtaH4XPfPJ/EZosHrkLhYFMSfEh8o0C3zVBk0TuKcrgPVg7GfAL5T4FonKxA54m93m5
         Iumw==
X-Forwarded-Encrypted: i=1; AJvYcCXOYuSDSR8IXCPYbF8m5iaeFq9eId2F/lxNpLbFbGV7O6+nlhdfIK7R1WzCYSG/9J09cCc9cJdAOw==@kvack.org
X-Gm-Message-State: AOJu0YwUnvY19NTsmmEDKbwSAQiAv8lqLzJCfd7ilaus2XgKhHwa3ZKc
	1sr9X1OsOf2QKqUOE85lkXSXzgtSJRTNhU3/Rlef0bali9gzUze9DNt+OFBB6UzrGJ64W+hERFR
	jtr6uBd86rWze3F38k/B+gLAyfUiLgeI=
X-Gm-Gg: ASbGncswYhHvSynguwzyi5NlOYJFoBWTD9htQW5RcPTJBEXRSyYWvromClor85apcdj
	NkSsJT4erKJfFgNQvcwtDVzJPfajbgAj6fbe4hPbDARXqrMzSgJdZAZa0nhDdlAdPa1l7cVuOS2
	Lb0NpATcZX4rJbKlDbW/GmaihPm4+PywQkpvvRQes7nhkbo68phWtRKyQwwShsqsfhv2JVXi4bQ
	scVs7s=
X-Google-Smtp-Source: AGHT+IHb0vDCcUCJ3tbbdgj1p2HAcP6JMItn9XaNpPNiXoKeDe13xPYPEyV1EjdV+JOfFKVUgeTsnWo7msgg5nFOa4Y=
X-Received: by 2002:a0c:f40e:0:b0:707:6d96:6dd with SMTP id
 6a1803df08f44-7076d96112emr1896606d6.35.1753843124361; Tue, 29 Jul 2025
 19:38:44 -0700 (PDT)
MIME-Version: 1.0
References: <20250729091807.84310-1-laoar.shao@gmail.com> <20250729091807.84310-5-laoar.shao@gmail.com>
 <BADFCED9-4C30-4ED6-88F3-D8CB7054CC56@nvidia.com>
In-Reply-To: <BADFCED9-4C30-4ED6-88F3-D8CB7054CC56@nvidia.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Wed, 30 Jul 2025 10:38:08 +0800
X-Gm-Features: Ac12FXwifuB0zFicKqHjHTHUkwrtxpGWtTsdaSZRCVin1fI3n3SARNs3T4SezGw
Message-ID: <CALOAHbDWqAR=dDoLcGjge-hWTNqEG5yRV+eAoa2rss7WTOD6ig@mail.gmail.com>
Subject: Re: [RFC PATCH v4 4/4] selftest/bpf: add selftest for BPF based THP
 order seletection
To: Zi Yan <ziy@nvidia.com>
Cc: akpm@linux-foundation.org, david@redhat.com, baolin.wang@linux.alibaba.com, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, hannes@cmpxchg.org, 
	usamaarif642@gmail.com, gutierrez.asier@huawei-partners.com, 
	willy@infradead.org, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, 
	ameryhung@gmail.com, bpf@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 68F7AC0010
X-Stat-Signature: x8gunck7wszpjpbg4sds9yt1yqm4k513
X-HE-Tag: 1753843125-663521
X-HE-Meta: U2FsdGVkX18nmxf8kWaStQovMQpjZqqs4MzfetUogo7V13KqzNZmCuk14ZfqrwX/t6CGAIe/J6d1RKBEQeNHVyZ9lkQNaEUhYdicXsFfp7+FsjY1jixqApxdBEwE9Rl5+wNFfUYdlKg4S157/htmAB9zp/XjjMhFpFSpjbKdQRIt7yUQarpoqgz4Iyu52Y4yI/1jTQuarX9kuYGr6aYWk+uSI/IaCiRGOTbPFJGJfY2UzFadCIf2mjBiKPAhYtot4udPk2ouSqrTTKw4TfomYyutDDRrYS6yKLTDD6eflRVL3wYjdIdSs6h9JHKekdTad2I/2i3bzMjJPXs/bx6pdUsXUFWoO01SntyYqIc+Tj406sb+ZiwkVIavyPNhlrNfgsYnNBY5D0FsEw1JxcpvfkIAbD/6xnwTuAGLzLePfcs/AXzde9aZeFlKWaYU2ftHLA8M32MBOaDkPoxlznbcj/nsTNBcuIhp8Bu6BodRQn5FosGwa3YAeGaK4GYXO6Yk8I12ZXvz2eHIdyYXffBzraRfLW90H0he73eNmxCe/6cbWiITBo2nFZoAfApHurWns6IFGaEciE7Pcj6YZHRlW51TAIpS5BH5CpD8v27Y2Kk9ea+rsUJOl8SaMI3Z+YsrnccSl/69v8QVW763gD3D3TbAHBTbwjh9FvKknfYH7bWaBVMZG6A6OspxcDWGU0p2jtzGRDhmRuMUPydmSuUCtunEW+czCPfHG9CCodNYJWoq7qXyV4A+3RRUKSG8MhdHhRwA8mQOY48xTV0W4TjLPZQmmzYXRJiYnQ6c53GRSlQ+G/rrRzDUGLkZp/rMze5rYU4rxOVyqDQcW2erK/wHOpiA2Zlzu8ictYpEeig0VTSKvdszZh+yBz5FXc/u/z6LaO9n8SSbhN5KOPu/hGwgyvA6jbcL1leVDcAqviyQw2Dbp6lFtH//D7lAhoyR+gqWvTeya6jQ06YX8R0E1rm
 Fuv0mC41
 y7nkIqjJbctkpMQ8utnY6HsJWXAg+8LWbmICwc2v4yntpjLITJKi3EFOf2ItpYx2654pfFPz9NlzmrGKMCertFD794NyJPDWBm0xh0g4FkchigQS867A9iRPnfd8Vm1Mt3iGxoodUxFoPAJzIXgmlZewzuC6h+rRsjlW1PDoOw9NFB2oYiYqgXYQI7j7FVcf8dMXNloEpTk9bhXZIE4XXBy9viS9cp+UzFK4QKIDcal1ycThgmtS28xqweCaVtZOb8F+jZ/LLsovg17gxdscYkmPFVrf3EjpkfwmNy/vbq90d9dDPKZrYrlYwxqsMaMq8E6uPNdYDl3I1qRFr++TXO9tYgUs2kn3xM4fsF5tulNnDx5iUNXyvOMsn701mcWM8kcBUn1QM5XJ4n6KDTPHoD3tbSq6gBeY4VBWu35plA7ORQSr7N8yc09NsuQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 29, 2025 at 11:36=E2=80=AFPM Zi Yan <ziy@nvidia.com> wrote:
>
> On 29 Jul 2025, at 5:18, Yafang Shao wrote:
>
> > This self-test verifies that PMD-mapped THP allocation is restricted in
> > page faults for tasks within a specific cgroup, while still permitting
> > THP allocation via khugepaged.
> >
> > Since THP allocation depends on various factors (e.g., system memory
> > pressure), using the actual allocated THP size for validation is
> > unreliable. Instead, we check the return value of get_suggested_order()=
,
> > which indicates whether the system intends to allocate a THP, regardles=
s of
> > whether the allocation ultimately succeeds.
> >
> > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > ---
> >  tools/testing/selftests/bpf/config            |   2 +
> >  .../selftests/bpf/prog_tests/thp_adjust.c     | 183 ++++++++++++++++++
> >  .../selftests/bpf/progs/test_thp_adjust.c     |  69 +++++++
> >  .../bpf/progs/test_thp_adjust_failure.c       |  24 +++
> >  4 files changed, 278 insertions(+)
> >  create mode 100644 tools/testing/selftests/bpf/prog_tests/thp_adjust.c
> >  create mode 100644 tools/testing/selftests/bpf/progs/test_thp_adjust.c
> >  create mode 100644 tools/testing/selftests/bpf/progs/test_thp_adjust_f=
ailure.c
> >
>
> The program below will only work on architectures with 4KB base page
> and PMD order is 9. It is better to read base page size and PMD page size
> from the system.

Thanks for the suggestion. I=E2=80=99ll change it.

--=20
Regards
Yafang

