Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B6DCCD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 19:58:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F210B6B00CB; Mon, 11 May 2026 15:58:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF83C6B00CC; Mon, 11 May 2026 15:58:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E35AA6B00CD; Mon, 11 May 2026 15:58:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D59E86B00CB
	for <linux-mm@kvack.org>; Mon, 11 May 2026 15:58:12 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 99BDFC1255
	for <linux-mm@kvack.org>; Mon, 11 May 2026 19:58:12 +0000 (UTC)
X-FDA: 84756200424.07.DB24BE4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9C56D1C0003
	for <linux-mm@kvack.org>; Mon, 11 May 2026 19:58:10 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=I2u7SNV5;
	spf=pass (imf20.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778529490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ro69MQ9EqEnNINtduiTATSKngAU7AoF+/0O7Kz5FFSM=;
	b=o8IUicqqaEqhKo+B1GYNbYMUJo6OGsUn0UZgpNmPjgr3nBqnrQbdd9G9+rOgclwYyboilq
	jv8Qr6RK0sgLVa862zfN4CWuxlh8bXJAU5QW31rXWMs/+4DWE8goat6Fopb+IpNGVy+qzK
	3FaAyLB8qx6ipgnNVYlnV8tQhECrn4E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778529490; a=rsa-sha256;
	cv=none;
	b=omV5tB8sQoeZPh8tUj3dL/FkwbmhdkEQU0B48gR7Y0UNTb3YtLnrznCRL5ZDNj5ae0exTr
	ValcuOH+ryytWMSbajSKASWyWCgRzeqPXgZqsMqeUR9cyWHV1chd4gl6H9g49mvyJW6f27
	elvTkYgh2fwCHzhxP1Iieli+jPZ8+RI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=I2u7SNV5;
	spf=pass (imf20.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 85A8C444F9
	for <linux-mm@kvack.org>; Mon, 11 May 2026 19:58:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 682A0C2BCFA
	for <linux-mm@kvack.org>; Mon, 11 May 2026 19:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778529489;
	bh=Ro69MQ9EqEnNINtduiTATSKngAU7AoF+/0O7Kz5FFSM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=I2u7SNV5bs8OJ2W+gFAiVWIJPqIsMJnrUmeXEiOXiN+Awh/+AoZHWsawFt82eGQP1
	 iYvFkHu/cjhJwN6v1C9Zln9xKKrSAykZybOV6uAn1zckKzd3+wi6S+G0bpo0yge9T8
	 sHydtMPo/jgHIG33SEzoc4lv848LeRzUnkRJTHd/YTMjPeRsQS1HtNLbx31345j2VR
	 CMp1/J7A91nx2fZ376nBGthXZo1JpZ7xTpNwtu1nBA7nCpqm+UILkIIrvyXcnqpZXb
	 sDgndDgUZwi6rfZe4myIVrtoLQUsRh/KJeKbEUjaYGZKTr7T2Sg/nKDXrDYQ1AcsFX
	 H7LxvjP4NJ2nQ==
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-b9358bc9c50so747054766b.1
        for <linux-mm@kvack.org>; Mon, 11 May 2026 12:58:09 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/OR1l37uurcoaqYfuVHUMIekPq5VvsTlWKnyDQUXgtfSfij4qrR5pv13uWEJ2Udho8sf4ynkFniA==@kvack.org
X-Gm-Message-State: AOJu0Yz8TBFgjIx0ercovRmMD0K8r6bbYihUh5GcyanJbt7dvAUpmlai
	6Hfb5FiYKGVq8czuTOdgJsvwUnc2KffrbFYqiYCL8eTPzdpQ5Z3A1UWEJBG3r46ueajko6C2RMc
	oW2wM+26vWcZPxAi1Ws/SVtwUHRCdOI0=
X-Received: by 2002:a17:907:9412:b0:b97:1d24:c004 with SMTP id
 a640c23a62f3a-bc56de100damr1640546966b.21.1778529488205; Mon, 11 May 2026
 12:58:08 -0700 (PDT)
MIME-Version: 1.0
References: <20260511105149.75584-1-jiahao.kernel@gmail.com>
 <20260511105149.75584-3-jiahao.kernel@gmail.com> <CAKEwX=PLFRkfUvZyaYfwBv0QJ-8KAktvZvGA02Hod04H-RsS-Q@mail.gmail.com>
In-Reply-To: <CAKEwX=PLFRkfUvZyaYfwBv0QJ-8KAktvZvGA02Hod04H-RsS-Q@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 11 May 2026 12:57:56 -0700
X-Gmail-Original-Message-ID: <CAO9r8zNOPdpJuTmccvQ6ZAVS+tXxp-_ofA765DbnfaUZOPPO-g@mail.gmail.com>
X-Gm-Features: AVHnY4JggveioK6wHYDCMPwvJ0NzLIt9APWEOL57HCcrUJO5sRIVBp_Ljdyoras
Message-ID: <CAO9r8zNOPdpJuTmccvQ6ZAVS+tXxp-_ofA765DbnfaUZOPPO-g@mail.gmail.com>
Subject: Re: [PATCH 2/3] mm/zswap: Implement proactive writeback
To: Nhat Pham <nphamcs@gmail.com>
Cc: Hao Jia <jiahao.kernel@gmail.com>, akpm@linux-foundation.org, tj@kernel.org, 
	hannes@cmpxchg.org, shakeel.butt@linux.dev, mhocko@kernel.org, 
	mkoutny@suse.com, chengming.zhou@linux.dev, muchun.song@linux.dev, 
	roman.gushchin@linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	Hao Jia <jiahao1@lixiang.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9C56D1C0003
X-Rspam-User: 
X-Stat-Signature: 871wgkjdeyhoo1bswibox867yo88pwcy
X-HE-Tag: 1778529490-946723
X-HE-Meta: U2FsdGVkX19joHu5ThXVx97UH/qXE0wn8OgzqMLnhuGbV93OGX5ZPNxv7dVVB1RQTJLjuIt1vpeQLN8RWC5PoTUbyuCGpmzNT1eUjqGPA9u/kCMablkq4vvqGvwQr2RYfqj8EoPkIZCV3S3SL0oqaKEWuT5/GQGW+IR70wZdT3EoKiDSsdz7xm5ZSPagCz3aBVcaH03tshA6MFhV5/HAkipxUHg5N0XwoN6rjztHCwyY6dKK2WGFGPL/72kkygNUDpUOQEfBdqxbTZw+EDCTMZNWZsXWad0Hs865+GZcQupFGqM0VIl+PLOrZDDukiZ/TN1dUZHK/jPwBSIrtELKxzOl8wv80We43HMRFBDIdRevkpqm71sV7W0nju4/Pjrr08WPCYORdXZdrw9vsaG/xFUHMN0bc81KsB7gLSvJ3j+zfWqqt6Qs1iW4eXdDTgRKXloeKbN8WSPuUnzn4+fjSquB5nZSpSGpFjgxSw0G/9qLkmYQO37mlUY2y1YtjXOoXdIxnW9ocrFx262VK65N3MhZGxO0w5N4+jklCtS/vtUNu/HfPaBbiqmrCK8TqnYCLPwYkZnJZHKBa0Yx1WD2IoUWROsFL3jrzKThQE2Zf0vri68p31Nm7+uY3+U6HailaY3H/eeFvchRrbIxO3LK7nckCYZ73GxD1qrcfmiMGoqvw0rUGy5f9Havf/Xd9UsdP9pCa2MP0C8cPxLl2aE7BCmxiex10/MZQaUmNuckqvPTJvc4sPvUrmHs8AzMg1IYWpqEpvK9CYwDcqCOOO/XRLfUBGfY2og+zHfNX/e4fG389Dc9rUlVjWd2NPOWieDPPW9gfMhwURuprVxxnPsa1Z69fAKDrbTYHB5e36COrsKMe3s8I5XzgtnE7u9VLlbPPMRpMtxAnJi887r/CxnhQ7i2Nfgz6KPZFs1uZ49+T9Tq5XKl46algckHQOxgbyDlCbFKt94Ogjcgx9sCeEA
 //BTm3DI
 18GhpJGKaToVQL+hOiMeo2D071+8HYhKcHFx7PidG7mcvpAYKiWK+3IDOwSy1hXhD5vP1/ghOb7YiLgo6v6PgH4oic1upgiOUqnKyiGvRwF85OY+hK53RW+QGDS6NRgFf9/wGg1ttZ2lp1lL+4JZyvpd4e4mTmHs2wUZhBL5o+tDiWk4F7jUzNUrBHNHezkzQ6am2WLNYLVTmwtbjt6bMCQauA1cbLhNCF6M0qMB/ZO8bOXIYLMuWWrLl4rECk5FmUvqGSX+2JSJgyet7HjvqgzTdc/HM+ZIRrC2if/kBUwxWVanjORRoPCnIwR47gYjt93KmHEWFpusYLdM9AetZBA5Ndoy22r9Iop8k9t4ef+BGM1R5M6kw5eSQRCxq1z4v47EbMqUDnTrKCcyasF6OM/HA9Fl3MYuNmK00mciKc7EkcMWk6uXYvUADkA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 12:49=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> wrot=
e:
>
> On Mon, May 11, 2026 at 3:52=E2=80=AFAM Hao Jia <jiahao.kernel@gmail.com>=
 wrote:
> >
> > From: Hao Jia <jiahao1@lixiang.com>
> >
> > Zswap currently writes back pages to backing swap devices reactively,
> > triggered either by memory pressure via the shrinker or by the pool
> > reaching its size limit. This reactive approach offers no precise
> > control over when writeback happens, which can disturb latency-sensitiv=
e
> > workloads, and it cannot direct writeback at a specific memory cgroup.
> > However, there are scenarios where users might want to proactively
> > write back cold pages from zswap to the backing swap device, for
> > example, to free up memory for other applications or to prepare for
> > upcoming memory-intensive workloads.
> >
> > Therefore, implement a proactive writeback mechanism for zswap by
> > adding a new cgroup interface file memory.zswap.proactive_writeback
> > within the memory controller.
>
>
> We already have memory.reclaim, no? Would that not work to create
> headroom generally for your use case? Is there a reason why we are
> treating zswap memory as special here?

+1, why do we need to specifically proactively reclaim the compressed memor=
y?

Also, if we do need to minimize the compressed memory and force higher
writeback rates, we can do so with memory.zswap.max, right?

