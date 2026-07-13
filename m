Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DE3BC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 11:37:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 996D56B008A; Mon, 13 Jul 2026 07:37:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96EB86B008C; Mon, 13 Jul 2026 07:37:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AB976B0092; Mon, 13 Jul 2026 07:37:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 62A796B008A
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 07:37:56 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DE986140116
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 11:37:55 +0000 (UTC)
X-FDA: 84983554110.07.F64C11B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 565FCC0009
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 11:37:54 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lwsqz1Ru;
	spf=pass (imf28.hostedemail.com: domain of will@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783942674;
	b=yfGiL9U9AZ3mMA4k1ipC75OcJr/h0ddPv97Hwn0c0p43qgK+MDkzwlmMkU3HG0OduipWVL
	s+EqHLHoK34EeAZZjERv+RCbOqMJq6D7ffK2F/17QbhryLmTuVAYQM6Pkv/GJjtBOy6Bk9
	tp/okjsVlJTRH8WDUDfe512Ggm3/GCg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lwsqz1Ru;
	spf=pass (imf28.hostedemail.com: domain of will@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783942674;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/BjtT2J2J6zXKuxGY/oNhYmRT76YRdnfRvP+EVhF3Q0=;
	b=XagUM409tXywagGrVMiinbPaKTIdoFhZwdE3/ASr/vIH56kVICAg2qvLsZ3Ayn42IBlUpB
	IIC3H82e8lQx/6aaDPdgvZGUF74QSJgftSEUj+Q+wymmT64J1pPLnYKPugf7hks0O/BC1h
	OWop3eqQ/3fI5H/e9F2hSSk8PB4qfgU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D70666004E;
	Mon, 13 Jul 2026 11:37:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 126A51F000E9;
	Mon, 13 Jul 2026 11:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783942673;
	bh=/BjtT2J2J6zXKuxGY/oNhYmRT76YRdnfRvP+EVhF3Q0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lwsqz1RuU3/1+c0OVzE60Yb3p9ZEdRyv87rOvJQj2jHlLDEJ9FJh3edRHAabzd8wG
	 camah820QByAwHgAARZVVejvD11aO+S9Ik8ny9LouWcULNkE1aQXCemywImUs6WKfe
	 GDEVgH7ZgoNJI7HcE1g7bcNYXDtt8CrQ/eWnGg2fEWMwktPX7Fww8DmwHln3sdp12T
	 D3uAw0aHU9doRMgRKZY8ITJ7+5ZQAQtLaK2rBS+h//zPXpg/FDXOpqa8jixTrT3CLp
	 7T5xptgnEXNSjzGBE9uqCjgtRrEMT7yXfCEDCtOh+IFFSelv4KHvpqcfasikBCvYr5
	 LvZXZRZnbq1mQ==
Date: Mon, 13 Jul 2026 12:37:46 +0100
From: Will Deacon <will@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>, Andrew Morton <akpm@linux-foundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Toshi Kani <toshi.kani@hpe.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	David Carlier <devnexen@gmail.com>,
	Ryan Roberts <ryan.roberts@arm.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	stable@vger.kernel.org,
	syzbot+fd95a72470f5a44e464c@syzkaller.appspotmail.com
Subject: Re: [PATCH 0/2] mm: fix UAF caused by race between ptdump and vmap
 pgtable freeing
Message-ID: <alTOCtzQh9RMfWbc@willie-the-truck>
References: <20260710-series-vmap-race-fix-v1-0-5b3794c113fe@kernel.org>
 <8e320b30-9658-4e9f-ac4c-f99dcf855944@arm.com>
 <alNQccqtx5-QApup@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alNQccqtx5-QApup@lucifer>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 565FCC0009
X-Stat-Signature: qhdycwwi1pjpp4byk8ygfr5ptim4usfk
X-HE-Tag: 1783942674-558085
X-HE-Meta: U2FsdGVkX18sWItWc4PFjaJzuSklWv0iF1hopifORBLeXuZkMUu0iePm0LNVcdcJG0okjb8Bu7ED8KDj74HBRrTJuKwV9OtvjhSb/KfNVBVGkRsolAyHZPwY8yCDfbUrqaWhLtn+5wcY2w0+JywoKkcqLkPTbeO7q6eBxwTXKfcL+fFygP8330aRI3XrEIsHs7UjfYF8RlgyzmqxbIHc0mWlehGQXrb3QfKhR91MtihUzVKE8dWbDE+tk95rwgPEnA2HHuV3WXf2yEIexv00Emzmzh9gdeOr0gY5pOI83+oLAaveolF0/xnvP7Xro1JXipCjhROp6MTyhZ/hcPdgHPNFz/tJ32eASfcSl5pqRr1U2LivhRjj90/QRPcbFCIY9fELpiYRZkmqu+lGrQL+i6lDy0tdLeZZvAllGBDlvEnRgc0oZqyHO03G+JzVykm4p6q34Bt+NxL6UZKhLmL/JtKs42B/CFlijPBn1xauUc4YoVjwS/P5TFdwNU0vBCNp8t9oXr/D+0W6f3e1W16rod5v+vmcDMcS53FMJN1XAIln43eNVlBgjBjpo0Tpf94v5Irf5GFUWfY6WgX9mkqBMJun4rirSrXo0FOjiVYLm0aQiPlgZDUz6zoSO6AMcSyIk2Az7imyob+r/Ng3yQuWK1HurSWK8+g8zPxJVkb6BNVZr5Pib+8IWzijDPD+hNsA9HPmHJ972y/ThRxEY206lr6n1BVrSoR5nosUqvMXX0J1k39jClb2xblsw6J/TE+hohjSjeJSRHGNIqre2MXRtEC+ZJPQsPlGulazuU5X8S871Li9kPpApF/jlxYBTw8LsmXSt81fZHVl9o9P4Yl79sQ3fA/1+UIIAkYIfwCh3wtyIlBVi+4VKdaahqxjywLdNjMl9bmVDuLXE45cSnZ2irCKOlcUuVfAZkF6lO6firh4gINK4rNS6R8OVMXI02RVnypUJpnN6K1lB3OcHIy
 psLb3tKo
 YO9u2GHpfZvN8vZy934ctkPb+iKQLa5s56SRTdQ+kR9My50jcQZy6/jgkVOA/sroBwFt3bUi1syR1wcnPN+u+kYuKvQXZxK9VQzsB/5GzMULTN6HuvdIZ2CBxLS4F60VCb7ArIipaT3dm+bhrjL+QvVLiXQCxNrlJCe2xFGss17sr8WxLsT4+8YAEk4NoX2ncUD0p6QoQjZ6XeIExMY5B8GauBlmKwJsOiP9b9bTRPKOXwX5kVTIyVyqp6OARNZEryW8IX1K1lHQ210E43GSvyLHaRirr4O7zqzxE9fzZ0ZEduPKXWsk5kU8teIvAteRr7wqomNJVH7ZDvIEABAnBZPqJcgu5ZwTFaBNmP3e2q4Payven+KqZU1yp5lMZJUexM6nrFtZnQQooLqc8jsoefi561DmxuYRBL4lXqXFPWtzyrAIjzds3em1g0KhdfOt+vMyC+lZlhwk7NPTjiBO3Bw6lfQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jul 12, 2026 at 09:46:46AM +0100, Lorenzo Stoakes wrote:
> On Sun, Jul 12, 2026 at 12:50:08PM +0530, Dev Jain wrote:
> > Will Deacon had pushed back on a similar approach:
> > https://lore.kernel.org/all/20250530123527.GA30463@willie-the-truck/
> >
> > Although now when I read back that thread, it feels more so like my
> > incompetency to convince :) because:
> 
> No haha not so, I think more like this stuff is fiddly.

Yup, not disputing that this is hard to get right.

Conceptually, adding locking purely to deal with a vanishingly rare,
debug reader does turn my head but I'm _far_ less concerned about it if
it's done in the core code, as is the case here. x86 needs it and we're
recently running into related locking issues with the set_memory_*()
APIs if we want to collapse the page-table on arm64 [1]. If the overhead
is flagged as an issue, we can see if it's worth generalising the static
key trick that the second patch reverts but I definitely wouldn't start
from that position.

Will

[1] https://lore.kernel.org/linux-arm-kernel/799181c3-a1a1-4de7-bc6a-576d3282efb0@arm.com/

