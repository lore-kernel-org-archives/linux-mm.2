Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56923C88E53
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 21:21:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 570FF6B0088; Fri, 11 Sep 2026 17:21:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5004C6B008C; Fri, 11 Sep 2026 17:21:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E81E6B0092; Fri, 11 Sep 2026 17:21:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 157AE6B0088
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 17:21:02 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9E4691A0365
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 21:21:01 +0000 (UTC)
X-FDA: 85202751522.20.77B0AB7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id B354140009
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 21:20:59 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dtNc2rHQ;
	spf=pass (imf01.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789161659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bYi+BLcDxpGEvH8TRFhgsxjlizIH3+JRxRD7LLGvT8g=;
	b=33riamcKBNDfYXEecL0B+pyqHB7KN9/Z8MbL7ggioBlUdjcsby+sQ7yhXYhasqV8Yo6DrX
	oPkgZw3/He9Pd85JKeJBhru9LOpQzvqDg1VzBwJayMCcBTvui++n8kwRxJJ94hdmBkERXe
	sCsqGeOmmegl5t8m96/Pzl+Ey564VV4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789161659;
	b=1Ops7Zw50MNax74tPAqkGqHqVPUJT4nwShDi/lH5HuWhGfcaY8O9/C+4rD2vwUDlKpGXw+
	qTIj8rry2o5BQ+WFjlo9nNdE5r5rbo61KdduZGU4P+C2PhmK6mxHSpDm5DMdMOQDEpN7Cp
	8WozSWf5QWsAnQDr/6eIvG5b4+szPw4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dtNc2rHQ;
	spf=pass (imf01.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E7ACB43F1F
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 21:20:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF66B1F00898
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 21:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789161657;
	bh=bYi+BLcDxpGEvH8TRFhgsxjlizIH3+JRxRD7LLGvT8g=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=dtNc2rHQtWIObd/DI/ApVeqzSQNXUd5s6VPhj4i/TV6agec3+bbNqYhrNOPh4K8fg
	 BIrklNUVaLk+sAVnauNPFcw6npJGzDGiJ76UfZKi4DyEBNOIowrc0b92AcJaMiAPlc
	 gQwo9UXhkKIasdqcLaN0toFekM0+KsTDfKc2ReccbxNBUYkyEBbmcsfGmvH5NgzSn9
	 n09EToGNkcYL6LN0XwQbFi1UzKAvcos3XzAmjlfom6VQJmLz3bMyhT4+ftDXM3AQ9t
	 b297P9sNrDqqJDHY14KoInNCQxoGn3vRu8i/YJ/FzI+ODxI737ZWMsixwY7+acirZW
	 5GiB2PhdWFaVg==
Received: by mail-qk2-f12.google.com with SMTP id af79cd13be357-93910c3e6b1so11499485a.0
        for <linux-mm@kvack.org>; Fri, 11 Sep 2026 14:20:57 -0700 (PDT)
X-Gm-Message-State: AFuF++mZSjIy5MXfShLJNSK2Nuoet5WtpVUmX04F5NtOmoQGkOGPlSaF
	72SOmAJu9wPwY5UBQH4PDIP4lmhM6G3hPPIBcQG72d2RAtzZPi/LPQ60pzv4uC+H3ZiU1SCJv5Y
	BjvkBUlJCmVFMirlCTfwTxnp8Ndg9UIA=
X-Received: by 2002:a05:620a:880c:b0:939:83c1:d8c6 with SMTP id
 af79cd13be357-939e8b079e4mr730453685a.8.1789161656904; Fri, 11 Sep 2026
 14:20:56 -0700 (PDT)
MIME-Version: 1.0
References: <20260818225904.55236-1-baohua@kernel.org> <08f63301a58f0e0c38480553295ad9af95928da6.camel@amd.com>
In-Reply-To: <08f63301a58f0e0c38480553295ad9af95928da6.camel@amd.com>
From: Barry Song <baohua@kernel.org>
Date: Sat, 12 Sep 2026 05:20:45 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yjHqSFtmHrRKgE1JrJpQKw5oBs1cuX1_mQ_r0wKdMdYw@mail.gmail.com>
X-Gm-Features: AcwNN1Wj6o7DDMeN04SnJ_ORbzq-MZuYZLrVkODVnbcFIGbkDcBF9Yh9yxqPI28
Message-ID: <CAGsJ_4yjHqSFtmHrRKgE1JrJpQKw5oBs1cuX1_mQ_r0wKdMdYw@mail.gmail.com>
Subject: Re: [RFC PATCH v3 0/4] mm: enable lru cache for smaller large folios
To: "Garg, Shivank" <shivankg@amd.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "hughd@google.com" <hughd@google.com>, 
	"npache@redhat.com" <npache@redhat.com>, "rppt@kernel.org" <rppt@kernel.org>, 
	"vbabka@kernel.org" <vbabka@kernel.org>, "david@kernel.org" <david@kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dev.jain@arm.com" <dev.jain@arm.com>, 
	"surenb@google.com" <surenb@google.com>, "ackerleytng@google.com" <ackerleytng@google.com>, 
	"usama.arif@linux.dev" <usama.arif@linux.dev>, "ziy@nvidia.com" <ziy@nvidia.com>, 
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>, 
	"baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>, "liam@infradead.org" <liam@infradead.org>, 
	"joannelkoong@gmail.com" <joannelkoong@gmail.com>, "mhocko@suse.com" <mhocko@suse.com>, 
	"ljs@kernel.org" <ljs@kernel.org>, "lance.yang@linux.dev" <lance.yang@linux.dev>, 
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: xrosxqqtpnbbgqyku87m76orta4wcnni
X-Rspamd-Queue-Id: B354140009
X-HE-Tag: 1789161659-838101
X-HE-Meta: U2FsdGVkX1+SItWmWcjVHmjiFGE5nUKeX17WhZEWN3UBqck9gWUPRp6ALHwFwU8U1WptSeixd0M559wmuif9bor9oEc8RNhPaPkJkdPPlcXb8bGOowOLCdOtrStnpre3JTzVpR6P4fOIrRXaz/AkedUDBQbgx+lclaTePY6M1KHZO17/KcZBnrNApuGWVl0cWUMsjc3jPPzvxRSxPgjcOVB5EleDaQunS6ry9nEL+NBEkvRL8i1asD5rCSxRJ4H0yj4lXdShVvRRArF9yaRgEMBdVYI+UeX9DwlSe0P4XaT2K7icShzc+FxYkcMgykvaFpmiD1tmfQmEHkv6j651k2uK68tWur2lTwUdb6jSt6b5dpY5OFQJ6oFd12hST0u/C5/cQCcXKqC6yo1cqeEt6Zp+33AtC/Rw3nrPY1LWq9zX5OpE4kYoGy4OMwNx17zpEX6zLgTsLn9eiY8xcj2e+oaNr+30VN5qUwAKOb7kINKZoxE31Ss7PBV+bMUxZPx/4qQ7TNqBCJDnAskY7Tu7g7/HFhoWBPUt+dhXMc4dnfhMhunATCKafepWcgiwXO0NWEI73udFebjmnwDPxxlpkk+TmFvVPTaWBY9K4xCuikmYDwdP4EoTeOVZ/jruuCP81vhsrZizg9ioyYPTfSg17w/MYe8OruJKGiRRC6xDpMTwO7dTeVow8L8Pr76lQpTgLCw6Os2B1TwuHDY2aJzhJ/MTnSk+U7eBqMwq5gTW8sMczc1wJktd2+hqARbGzRXQnPnv14w0GNLZfY6oByZkr+HS6P/zn+Pzzid+ynqmGCmmVP7T8lDCwgSL/xnsQlqBSQGCv6optHQIGMOh5HDSkyInz5XrRmMxzPHP+Sk8cPly1hFhewp7PFD2uNi4OjVkn9VEHPVFo22zD5U70N60H/KAz6W3eRe9Nxabd0BM5v7huXEVhWJwAwOxryOhZVGWgl079ks+1mAO51cDein
 xlgiMeds
 67lDwqQ4PTVuVM/FV0O+OqIOYLPPw6e6t5spCYKZcIW0ayHDTAp0z630nV4HV+c0mKi+9Pe6HWOxEic6U4Ktz9ZGgaN4P4dyDH9mDC+5xDx/BUVZL9PQjISn7CAwIhbNctZlWBizsFL6P+OZjnnKrPypdqpm2238/STNPBCrj8DnjxkboRngs1WzQdUXqFXhcKGZ+Hkx+rJQGkXmYVRA0epLZNIDjX6PdFzoziNWQXSnSIWFLGfi6YNcOuLwUSvBMc4mI6h8KL+qM5n2/LVuQ6jyUHip2k+55K2u5CacAq37JILu4qCoWI/XV9qfWoLolL3d0Gjs2KN9gLXpyFQTN6TtplfL8zGAoqaQrUrWwArhKfCYrRuz+KFQEizzGuz2iZg0AvDNWg5MgV3U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 11, 2026 at 11:39=E2=80=AFPM Garg, Shivank <shivankg@amd.com> w=
rote:
[...]
>
> Thanks for this series.
> I tested this against a Graph500 regression with 16K mTHP.
> The series removes the regression and reduces folio_lruvec_lock_irqsave c=
ontention to approximately the 4K rate.
>
>
> Tested-by: Shivank Garg <shivankg@amd.com>
>

Thanks very much, Shivank. I=E2=80=99m very happy to see that
mTHP LRUCACHE not only resolves your regression but also
improves the performance of your case.

As discussed with David, this series will be respun after Hugh=E2=80=99s
work[1] is merged.

In the meantime, I=E2=80=99d really appreciate it if you could test an
updated version that I haven=E2=80=99t sent out before:

https://git.kernel.org/pub/scm/linux/kernel/git/baohua/linux.git/log/?h=3Dm=
thp_lrucache

It includes some modifications based on Sashiko=E2=80=99s review comments
on the version you tested. I=E2=80=99d like to know whether it still provid=
es
the same performance gains you saw with that version.

[1] https://lore.kernel.org/linux-mm/e28f9a94-4339-f8ac-8301-6be3c9b5b7ce@g=
oogle.com/

>
> System and Workload
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> AMD EPYC Zen 5 System, 2 sockets, 160 cores/socket,
> SMT on -> 320 cores / 640 threads
> 2 NUMA nodes, ~512 GB/node
> node 0 CPUs: 0-159,320-479
>
> Base: v7.3-rc2+ (50d05c7c76c9)
> Runtime: performance governor, preempt=3Dfull (lazy)
>
> Workload: Graph500, Scale 27, edgefactor 16
> Metric: median_time in ms (lower is better)
>
> Bind to node 0 with numactl -C 0-159,320-479 -m 0
>
>
> Performance
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>                   Base       Patched    delta
> 4K                109.60     109.11     -0.4%
> mTHP-16K          144.10      99.00    -31.3%
> mTHP-64K          104.75     104.25     -0.5%
>
> mTHP-16K was ~31% slower than THP-never, due to lock contentions.
> With your series, mTHP-16 performs ~9% faster than THP-never.
>
>
> The dominant folio_lruvec_lock_irqsave entries were:
>
>                    Base                  Patched
>                contended  wait         contended  wait
> 4K               834603   2.41 m         844193   2.61 m
> mTHP-16K        7008834   28.88 m        840695   4.87 m
> mTHP-64K         188144   752 ms         40874    93.46 ms
>
>

Best Regards
Barry

