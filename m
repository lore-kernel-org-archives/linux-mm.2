Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9196109C04A
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 17:23:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3C9E6B0005; Wed, 25 Mar 2026 13:23:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEDAE6B0089; Wed, 25 Mar 2026 13:23:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDCA46B008A; Wed, 25 Mar 2026 13:23:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B99D36B0005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 13:23:35 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 14B7413BF44
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 17:23:35 +0000 (UTC)
X-FDA: 84585257190.01.EF8021A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 03EC74000B
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 17:23:32 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mA5CVrGh;
	spf=pass (imf17.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774459413;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=viTmep3Z4Zu/FWlG2Lc5vRj9CNEZGaZUQ/o6168TUEs=;
	b=b/JdAgSHJZCIs5U/cedVMtT0x0loAGUnmwn+ZW1KRNuZ/McQBvwTXhDvm7lOSdm8Waglxc
	7Ou6OdX+s0cW/plz6+ghRfn2op5rU7IltMrzm9Ms8ackULjtemv/8IjTAygG3bDyHv3S4l
	UHDRYmNF89c+OFNBl/Af/ypVZ7do/lk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mA5CVrGh;
	spf=pass (imf17.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774459413; a=rsa-sha256;
	cv=none;
	b=Z7/yb6VvqRR/oo4CPiGDsp6oqRlw4kWaXYYwA0BQqS8BiMCB+sAPsGcvNcdWjZpChVPBc3
	U0BSb1Jdkm2Hycp0hj6yHnrDL8kSHF/rVEFj9bTMYK2RGtJs0ByYZZYQLK4RqvY97p0vvx
	+0A6BXeeLClXZpk2AjYw3Dk2tHtvbMw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 60E3C60123
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 17:23:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE20AC2BCB2
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 17:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774459411;
	bh=viTmep3Z4Zu/FWlG2Lc5vRj9CNEZGaZUQ/o6168TUEs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=mA5CVrGhDe93OQpR2h7epjyJnIZZc/FBNZ3ySFRVDimsYyr3MbqwRVHNCMzIIoqBF
	 VcDXPnhXIXo0sUk6wb9wmNiPnCCBecwqaq+NCxurzSlWcEk+hSCrLdEP5hcxjXx3+s
	 gKmlapIm5GzDo30ZCqqU0DUWp1sWotLmP3LVYYAgR8yMo+STfTfZA9xQoLLd3HJeQe
	 UF1jFPqenUAuCg9l7zUSNpv9Xrh3PFotCNfkqVZaM1vqXxGI9WHerHWbg8rlQndwGw
	 Ed6vLAA33dzo56TBo/S8kUMahOW9Ok9jQ8YQpeY6RaxPYe9kz4LnE2zA1kvNZHv3Y8
	 7SqKO7xNGyy6g==
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-666f646f5cfso1871937a12.1
        for <linux-mm@kvack.org>; Wed, 25 Mar 2026 10:23:31 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWsLmKAiqrQFT0ltJnufhlYqimx8DZl919TcOLDDSLoVxl2WIbBv6VOk23FN5f/3bhwblim9vSXDQ==@kvack.org
X-Gm-Message-State: AOJu0YzJXv2yG+UOprawv+N6qB3RlKNs1/gY9gkmDr/cAZu5vga0aLu1
	AJ7P5AvG0er+gtYJGQHNVm0nVF4T4PpojyytxtalZLvBLKAlYPoTCWE0NgvdTG3nq9+P68mucjq
	+RIyjziw3t4iV8ttn6HZ4IKv03MXqTQQ=
X-Received: by 2002:a17:907:3f8d:b0:b96:e1de:db04 with SMTP id
 a640c23a62f3a-b98864026d5mr506266866b.18.1774459410572; Wed, 25 Mar 2026
 10:23:30 -0700 (PDT)
MIME-Version: 1.0
References: <20260320204241.1613861-1-longman@redhat.com> <20260320204241.1613861-2-longman@redhat.com>
 <acE2MoIZ0pl7U7PX@redhat.com> <CAO9r8zOTYPgqc_7TVWjQ=adn=pH1TLLX2cBNfa1Y-x=TOFJT1Q@mail.gmail.com>
 <f7159388-c13f-408c-8cb5-02da8b474f57@redhat.com>
In-Reply-To: <f7159388-c13f-408c-8cb5-02da8b474f57@redhat.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Wed, 25 Mar 2026 10:23:18 -0700
X-Gmail-Original-Message-ID: <CAO9r8zNRQQDXcHHmgJEeKW=YUPmjaRy2pdYuuD-UOuZGyo29FQ@mail.gmail.com>
X-Gm-Features: AQROBzBGJJDJNzfPNA6teoPhE-ZDBmh1D34LINWdlYk_6fWkscYzld8oyyC0Ym8
Message-ID: <CAO9r8zNRQQDXcHHmgJEeKW=YUPmjaRy2pdYuuD-UOuZGyo29FQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/7] memcg: Scale up vmstats flush threshold with int_sqrt(nr_cpus+2)
To: Waiman Long <longman@redhat.com>
Cc: Li Wang <liwang@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <shuah@kernel.org>, Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, James Houghton <jthoughton@google.com>, 
	Sebastian Chlad <sebastianchlad@gmail.com>, Guopeng Zhang <zhangguopeng@kylinos.cn>, 
	Li Wang <liwan@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 03EC74000B
X-Stat-Signature: k4gg3fp4afxdiwwdpibmzb1jr911k56c
X-Rspam-User: 
X-HE-Tag: 1774459412-695973
X-HE-Meta: U2FsdGVkX1+B0AfgPC5O7RqeS1x6rUALOsQgb5GGghWzAecod1xr+qIhUjyli2RSpUehAVgzgW/1Gst48w2jLhJL1tKZDDnFvd8BtihRgieZJkymbps/q9Eso2jbd6AETQjlLFarCSeV/c+NnlrVkLujmmyDQJXNV4WvRExQUxMzrHERz2d/XPeSvYh4sAPfJqQcZPkHa1xVptECRN8III7+E+ga/y93mrVeHPY0RBZht/sIFZv83jbrRawIRZgPa3bx3P9hxitl0NMt0vpkKHJ6UJz78KPAAXfD/KgzNC1UA79tfX6mtqOBwjPCDB/f//YByXuP5XZtkiz/QS/cBzGod7OXGs9bD0XyusuuoW6l4W76qTbZUVoyNMt7lcxbDm3FCu2SWKfe15FmGp+IgQFzNXwevLL3Pfuhvtved7KzX6IKCZHgGIXDydxIowED0OJ7wVy4gT25VE3by1WW64oZfk/NrPKHtv4NHZUfq5JqBP8NC6kcvK7CCyaLtDJP8VshNIuTTjkNYf18OcLK3B/o1LM8GIdPb26qQBad21wf0uIudMxICAaCwiKsxlqOTB4XuPQhywuQyLGJCoICE8tqYpgMQcOOt8FYEpVMkC75WP5osN0LRzIpOV+tmUoYGtTFJ8cfm/j4yBIOdu4tfdYzn01b/bUaQtpINNLTdfwu2mo0d2jIb83tszTgPFBjaovAYbl6d/wJEuoI5cOOtAbldjc/ufKk3nRnHllUDKpRy9ki1jnssH7z+bwuOvMsOHIGs/kexVD/4GJ/TP7sxgbZE9BfpHl+1fKqQmMsmMGn/4blr7bQ1HF/+HgCzIMtsI7UzTAQEsc2fhn/c2ki9iRiRcd9rcjjQAQTzB6EoGXrynVLf9yMgjab5EsezBOsomlJ8pvaRvS/11PMkwFGHv6ML0o+taDMOfGisE68UzZWzyh833pJH9+NwpXiCnHumzhi0c60CUuU0LcEJY2
 T7kec6AP
 VLZ6unwWfdQ218zuz848nrIx97+wK7VR2glLBrdBV/fdCgIQ5gKUdSyhsXHetcv+sSqwNnkFAwhHW6JJBA5t4SOTYxlRPm/fFvgFemlROxweJC/B6q3fJuWwrwQtZrXulW2gKcnLDNhvwbBDZOWkNXEyFYQnh0j2vKGpdpD67xPqjovvyI6cYjCUbuKeHbcJWf8pdIn6KYXaYkFW3XBl+ChqdgR379lXUhmUIKaEUJ3hUgR+yttkibFZz7qiB0BEvF5tQ2wWpQtWuxKINSVoOIPgLJYZVoIt/VWbUY9SIFbkqbxxGQ8z8rXzWP9AaepPZ7ZGrtD4/0hY4I6n85QexFWERy7iQxYkSYZ7Ohm6LVgCmMc801s2p2KZVVA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 9:47=E2=80=AFAM Waiman Long <longman@redhat.com> wr=
ote:
>
> On 3/23/26 8:15 PM, Yosry Ahmed wrote:
> > On Mon, Mar 23, 2026 at 5:46=E2=80=AFAM Li Wang <liwang@redhat.com> wro=
te:
> >> On Fri, Mar 20, 2026 at 04:42:35PM -0400, Waiman Long wrote:
> >>> The vmstats flush threshold currently increases linearly with the
> >>> number of online CPUs. As the number of CPUs increases over time, it
> >>> will become increasingly difficult to meet the threshold and update t=
he
> >>> vmstats data in a timely manner. These days, systems with hundreds of
> >>> CPUs or even thousands of them are becoming more common.
> >>>
> >>> For example, the test_memcg_sock test of test_memcontrol always fails
> >>> when running on an arm64 system with 128 CPUs. It is because the
> >>> threshold is now 64*128 =3D 8192. With 4k page size, it needs changes=
 in
> >>> 32 MB of memory. It will be even worse with larger page size like 64k=
.
> >>>
> >>> To make the output of memory.stat more correct, it is better to scale
> >>> up the threshold slower than linearly with the number of CPUs. The
> >>> int_sqrt() function is a good compromise as suggested by Li Wang [1].
> >>> An extra 2 is added to make sure that we will double the threshold fo=
r
> >>> a 2-core system. The increase will be slower after that.
> >>>
> >>> With the int_sqrt() scale, we can use the possibly larger
> >>> num_possible_cpus() instead of num_online_cpus() which may change at
> >>> run time.
> >>>
> >>> Although there is supposed to be a periodic and asynchronous flush of
> >>> vmstats every 2 seconds, the actual time lag between succesive runs
> >>> can actually vary quite a bit. In fact, I have seen time lags of up
> >>> to 10s of seconds in some cases. So we couldn't too rely on the hope
> >>> that there will be an asynchronous vmstats flush every 2 seconds. Thi=
s
> >>> may be something we need to look into.
> >>>
> >>> [1] https://lore.kernel.org/lkml/ab0kAE7mJkEL9kWb@redhat.com/
> >>>
> >>> Suggested-by: Li Wang <liwang@redhat.com>
> >>> Signed-off-by: Waiman Long <longman@redhat.com>
> > What's the motivation for this fix? Is it purely to make tests more
> > reliable on systems with larger page sizes?
> >
> > We need some performance tests to make sure we're not flushing too
> > eagerly with the sqrt scale imo. We need to make sure that when we
> > have a lot of cgroups and a lot of flushers we don't end up performing
> > worse.
>
> I will include some performance data in the next version. Do you have
> any suggestion of which readily available tests that I can use for this
> performance testing purpose.

I am not sure what readily available tests can stress this. In the
past, I wrote a synthetic workload that spawns a lot of readers in
memory.stat in userspace as well as reclaimers to trigger flushing
from both the kernel and userspace, with a large number of cgroups. I
don't have that lying around unfortunately.

