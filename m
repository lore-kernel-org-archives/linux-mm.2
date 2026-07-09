Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 760F1C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 19:32:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 518446B0088; Thu,  9 Jul 2026 15:32:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F01F6B008A; Thu,  9 Jul 2026 15:32:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42E6B6B008C; Thu,  9 Jul 2026 15:32:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 210756B0088
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 15:32:33 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A17B5168F9B
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 19:32:32 +0000 (UTC)
X-FDA: 84970234944.25.2621F0F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id BF6B240007
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 19:32:30 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NEqk7ojV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783625550;
	b=tUcekqagyDgBVJhIZNLA7KTjXsAuWtlARVseMPExUiARkT2ivL5MPTxzpzF+1BiM06ReVV
	3nvC9jPRxtph+VbdN8ZcvFg+XWUfpc/NLOpnb5QkX8RMryPOtKbEcblMivySLrwxiNgk8v
	wgPEH8WFi1q6jndSXCyWhlpyiWAjnlo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NEqk7ojV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783625550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=npXyDmufoqDAPaNNUVO/9ceYtcSWui2jgNerLmFDHKc=;
	b=cVpYsgOCD4jFO954bmGv4qUIsXmRT7ijv/qEj49tdJw6O22XQ9drWLvFfdkN4PzbiDnDYI
	znn8Fktkx9CAZFzeHAaobTTN2tyt3uR1CaaE3zd2mTqLgjPpiowKBeuQOtVH++eO5m59xE
	W++I4OTRPvlufdUxCVOeKX/0F7z/iCI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1A029600C3
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 19:32:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7D2F1F00A3A
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 19:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783625549;
	bh=npXyDmufoqDAPaNNUVO/9ceYtcSWui2jgNerLmFDHKc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=NEqk7ojVAD8jS8s0G0J1BYhZ+wXTK8ICpYsDhJQAeRFJ/oBWJoMhQOYhbsBu9qKVz
	 uZ5LM6RONQ+5BbPuYebxemJ6t+6ZJ25qHQRz+ldxl+AXQdmO09YOuQeAw/vlXMS8XR
	 JqqW70nATiZkuT5YqGAq82VcVfLt8AY/T+49yNbHTppbn0V7zXGYLQTbgO9Q0oOrWN
	 D0yRBylfd8eg7vtJG69CONbJ4xiwEzRvDEURJHQYyvbiq0dzBM694qt2bcXNaOXD0d
	 Ag8oZk9TMU7hClYbSB5MWWq7+8gPmowRyWewezUvguYkdDgvMdCDxCUgiV/ukV7pKo
	 xVl06N8Yiab4Q==
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-69a5ecbbfb2so273532a12.2
        for <linux-mm@kvack.org>; Thu, 09 Jul 2026 12:32:29 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqfgUIDU9iRVuqtsyZm/wzYREvn60knlAss8jrDoON8hRYbuk/S1MKQ5TrkewBkNaYD2l2qW6Nmrg==@kvack.org
X-Gm-Message-State: AOJu0YxvPRJO1z480CqIyUU1U+y+Rm4j2p9LbPvTtGqhm3oqy3Y/QNry
	c5JwmpfaLv8pGeG/QiZoyISm2sJCgdPTGYsV+D50rFNBeZWEJ8w2oX+2OmvRqCsvyvbY6DTv6OP
	QBjrGHIVlWp3MmrySpKbySL6UxKCDPnU=
X-Received: by 2002:a17:906:7311:b0:c12:a425:cbca with SMTP id
 a640c23a62f3a-c15ce120431mr373065566b.54.1783625548779; Thu, 09 Jul 2026
 12:32:28 -0700 (PDT)
MIME-Version: 1.0
References: <20260702180908.150136-1-yunzhao@cloudflare.com>
 <akbHBZP9HxOJMtQB@cmpxchg.org> <CAO9r8zOiwgG80EjqdZFgWQvODUe1RzecLemxcB7xXNm_f3XfbA@mail.gmail.com>
 <6ecf5579-0b3b-4e8c-a625-bbf0a4a48f94@kernel.org> <CAO9r8zP6JrZcBnzb8A3A9V8so4gJMWLvrJQ7VwPyyU417GikQg@mail.gmail.com>
 <CAAnvDSyNbV5xSH0hrX9Tgw_wXU7Neo-XSJ1enebxJXvjOheHWQ@mail.gmail.com>
 <CAO9r8zODSyYTipACxdEzoheMrNKzfFt_tjBzrB+2tSCHA82WWQ@mail.gmail.com> <CAAnvDSziZM9TOExkFrF9vNi4VN=7T6yofS-=4rmFqc3jXncveQ@mail.gmail.com>
In-Reply-To: <CAAnvDSziZM9TOExkFrF9vNi4VN=7T6yofS-=4rmFqc3jXncveQ@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Thu, 9 Jul 2026 12:32:17 -0700
X-Gmail-Original-Message-ID: <CAO9r8zPuX0j_fZsgRsaNQFyJqY4rZxERLya69TcCF83HrpHy-A@mail.gmail.com>
X-Gm-Features: AVVi8Cf8-M4xZZExnpUIJTjNgq3ZpVD4qlYoeRddcr1y_lwYwKDDOovuyHJniEo
Message-ID: <CAO9r8zPuX0j_fZsgRsaNQFyJqY4rZxERLya69TcCF83HrpHy-A@mail.gmail.com>
Subject: Re: [PATCH] mm/zswap: use ratelimited stats flush in zswap_shrinker_count()
To: Yunzhao Li <yunzhao@cloudflare.com>
Cc: Jesper Dangaard Brouer <hawk@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org, 
	nphamcs@gmail.com, yosryahmed@google.com, shakeel.butt@linux.dev, 
	akpm@linux-foundation.org, zhouchengming@bytedance.com, 
	James Houghton <jthoughton@google.com>, kernel-team <kernel-team@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: BF6B240007
X-Rspam-User: 
X-Stat-Signature: u15izycgwdi76kftkzw8rttzcfnk1hub
X-Rspamd-Server: rspam03
X-HE-Tag: 1783625550-125211
X-HE-Meta: U2FsdGVkX19jJCNR0q0Gq+/T3eB43CVysnBD8H8DkbW64iOMwCwRfUjnW3a+W45C4KgLMDaMiuXTxywKgUumy2kRWMpGnjTM4EBmy50TYM4Zt7LoMxHJDHlja3yTbBKFh5F+uA7U+F+RZnoRpyXzczcm1Ti2rn43Zn58AFuVKLjULAUJp7l2cqQ8C4fky3wkqVvO6FPn51vSkcxYwxX4IdsNx0enwhtlV9OKua6pJVVBxF7ElJc4jThGf1fxd8ntKHSqe/W8395u8IuokqAmRbkKlb2E2m84j4ErUunPd59WMBOMZAPWI+v/7XYqaD5ZJFmxwxwa2ZQZy2/fr9ZT0KUwbwtgIU4MyuGG3KHVjLTNdeSXQ8oMGS17ml7hxx9Tylto7BACFmSccQ2AGMT1PccGvT7rUdKl69MKbnp9MoanIWoCNT1cls0VB8D4lhWrorNJ1nUECujtR0IiOiaODjnAomRx8a27if6TmNKTdjln6jT2d3CPny1SSZVm8XWQoe9nuOiux7SSxYN5bLtjmxePIYkoHbUOJ/X5tz7KRxpWyCEjwRY0/rtg8LlexCl1cCBtYWEtsVCX1WWXtUUlGIt5a4F2HQdY4O8DJ+MSkornVd/MZKF+FGg5LSrlEjPTTH8izKcAVRMhg6hLZrwm3SsAFrvBE+alYRNg/kL0IqnXEYGG50xxC9r+/RUrDFVUVJAu9JTG5GqD8xKiDuviPz/s7o6sO4QAPwL+JE/jlmiTvgxeHHOHTTyLSefxQk0XB3Py/gNlUTrZpWk5EmF43ifqkJ2I/Z2gMhO5vaEesqDwYjg7vZQZdPw9iwsq6Y/spnbg/99Ag45nixOWyLqIVbb8zQjzi/ZDhssAz+DKxW47ulfypmYu4O3I/9xsw2hfb13Ur0zVT6i25Srs6ls64VTX51lrTdwmz5vfp7XWzbz4t2UDjtyayh7RAX73rfNI4R8/F4hLE8Rjqbb+oc1
 ye8L985m
 VXmFpKWri0CPCvHRGci+bUvSzl/PIz8FbG/Ar4B4ejxiV0/cno+uoW8kFVqbITaVlQ3ACpKjnlG8Hs3WcZaqTK3HPkVcotkSZQ4nN42YYMRvjbll/95THQzT4aIhkXpLEznnO9XHZNxnw1djRNzQyHciowtSEoEwKAwzUn2IpRMaNuHIEMlQjzEU9eXlIgiI54uYV+X5trg1Fj3XqhGHvte0Q6XTL4yagsEpw+KrfXgiXa9HA0/HQr5PFy7DJy3PAVZ5NiKPrRvZkDIQddjSpAVu2gSS7Ce31/fiB2WSpdkyamRAiUpf95QeRk7yANiYKSAQ138XekeI1R/pONTYORgbT7QzhWSf9M5QBySUnT07NaeC43xswnSttWLRaWiF96DC7wUD1StYFJZB6w/gUPDtwLg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 9, 2026 at 9:34=E2=80=AFAM Yunzhao Li <yunzhao@cloudflare.com> =
wrote:
>
> > Are you observing any performance impact when enabling it
> > (e.g. higher fault latencies)?
>
> Actually the opposite with this patch. Swap performance is better with th=
e
> shrinker enabled:
>
>   shrinker=3DY: sync swap overhead 10.3 ms, swap rate ~800/s
>   shrinker=3DN: sync swap overhead 22.5 ms, swap rate ~1.7K/s
>
> Per-swap latency is about the same (~30 =C2=B5s P99 both ways), but
> with shrinker=3DN there's roughly 2x more swap activity. I think
> the extra 16 GiB of free RAM from the shrinker just means less
> memory pressure overall, so fewer pages need to be swapped in.
> The shrinker seems to do a good job picking entries that don't
> get faulted back in under our Prod environment.

Yeah the per-fault latency is exactly what I was looking for. Seems
like most of the faults are not faulting in the pages written back to
disk, nice.

Would you be able to take a stab at eliminating the flushes as I
suggested above as an alternative?

(Also in general, please avoid top-posting and respond inline:
https://subspace.kernel.org/etiquette.html#do-not-top-post-when-replying)

