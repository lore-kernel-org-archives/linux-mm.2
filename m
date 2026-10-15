Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 172E6CC6B34
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 14:46:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3434A6B009F; Thu, 15 Oct 2026 10:46:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 319C16B00A0; Thu, 15 Oct 2026 10:46:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 209A96B00A1; Thu, 15 Oct 2026 10:46:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 050506B009F
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 10:46:13 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9A08340A27
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 14:46:13 +0000 (UTC)
X-FDA: 85325135826.27.2567F5D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id E61F3160005
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 14:46:11 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gQHjGx37;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792075572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oaBE09sot4Sjh/GN4h0+OoAYOe1dKUMnd6MgbTjvFrI=;
	b=X/6FHbDo5E1qip4CsO/ShUbZb8d6NMVwT4FE3OvVv3TEPFhH+Fsr2taSKvJTqsERloPzBO
	KohaQ3OVdEssEq0mC6ZEMCWocV5Aqb6rdmArZ/DBKIOgm9GbU8g+Mv5sLhovFuDh3Oq05c
	xW84JY4xJhnWNlM80zPLRaSfTX6ck9U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792075572;
	b=8etm1GPm1Kd/hUiFRcjQB8F7yk5Tptt5hI243NxUA24OS9+mOslGESs7QzBM1GoTF9Dlb4
	eNy4qhsNiI9NK0DyTkwtaI59APty1APQ89ADIOgfV0Er9YGWaliXiIX3scbrW+UsmjTT1W
	QziNAwmCJzS39GIpEceeEWSHIj65rXk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gQHjGx37;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 080A24373A;
	Thu, 15 Oct 2026 14:46:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53A611F000C4;
	Thu, 15 Oct 2026 14:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792075570;
	bh=oaBE09sot4Sjh/GN4h0+OoAYOe1dKUMnd6MgbTjvFrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gQHjGx372xUzwScy7l7ebTZIc2K/J6GCYQ55IL7orWB2Mmp/8Qj4LX4olQu2gF57n
	 V0B/AGqzV7zlzMAc+TKUiabzbVHrJ/uHS4AIUaoCWLdCI8PPR8T9i56gCwmYrv2EJA
	 gcs/v/zOLjQfFUEJlYZABNpn2kspZGm+9Fne+xAr0oWErPoI0rb5CGsQ/GYGtp6vbI
	 zEC4Qe9rVceXVtR8DUxd31M5VzsYQlvoHzWqTFd/wUsvtW9M3nlNo7s6vbXIqBmEn3
	 IiKqMPqODnv2iyQfPLPGS8E5kO557TMgQUmBP2izZf9rtcQg8n/qsiNXUtfVOwwIjx
	 liN3DwGDn4x9w==
From: SJ Park <sj@kernel.org>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: SJ Park <sj@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	linux-mm@kvack.org,
	ackerleytng@google.com,
	akpm@linux-foundation.org,
	chriscli@google.com,
	hannes@cmpxchg.org,
	jack@suse.cz,
	liam@infradead.org,
	muchun.song@linux.dev,
	shakeelb@meta.com,
	ziy@nvidia.com,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Matthew Wilcox <willy@infradead.org>
Subject: Re: Sashiko change proposal
Date: Thu, 15 Oct 2026 07:46:02 -0700
Message-ID: <20261015144603.106449-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <9139A421-50DE-45E1-99D5-4EFBD4225A98@linux.dev>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E61F3160005
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: c1cy4gkxapyed9dfrzn8fdfkmxefkbf5
X-HE-Tag: 1792075571-639857
X-HE-Meta: U2FsdGVkX18+/Z5/9ndvh2MckXiLrfKZLBX/SmRa7ZXxGCNkWtDuoWI33U5a087n7HSwAXLj55JJN2SeJzPkEz2R91ktVUODkeq5qR85bLbsE6kdRHIIZxQmbx2SgggGAe18tuU1WmeqzsIiPDPIRBJnTdgnnvPFct//0c6Mq2gja+vZOzyTPK5Pxf/GzzGnRmosbE86w/Gbp92j+Syqs89Eff+ohJxFL5ENRIXQVokFjkewe3gGbhhvvIdLyiV419JETM+bW/60NX5YSQ5k40O8Qr2nxDGbIcLu0vSSeKrfbgXAWM5tuZ/CtXi7peEQJWvZsR3HL/BvisstKiziWv7S+mA3iZvNoyh/cS55pRN5NxlEE1bn9ZtvEpyRif2UKS25GU3xVEk9fFVsVFjGxU0KqFZ0yTBaoc/4S3rOe6ACXtr79NJ/gsIKGW+gBkWtq4R8uMwoieMGVFEKbl5HiNmqPI6z6+SuLi0AfP2WEP+ho9qf0LqKovNcdwuIMnIbX41LutplkJtsWrMqjG4e3tTXdpL1eaY1Hjb1wow58LQaz0Vv83zxEEp5z+/306GTqII2o8V4cuBhUsCWrdSaORTDZDF1B5BZofoYALrMmbEpGkV+6xnqCjkuaoCwbPUVanedwv+MgsYn24ordLl075++TXAhWIaz08+VYsAGw2hQVFhF1yibv6BgK5Tke0YGhq5ES5ujZeLko75pJb9omI9a+vqT6MV9pIT+WwXlRD5Kuhk3P1gmRrkJkMjGupjC3wq8dcAwFeoooNPpKTCbk0cK3PFLml/834NWiS6xthsesviT7H5JZ3BKIv+h5VsF2JQt/xBw5DR3X0n+jsZ1VFz+LRd5JI5OiwQBPNfy0UcqaGI9RfA3+9yBv+J144/LdldmG+0kwgWGdQ9Qn0cUukGNHv7t8R1Ww517B2Mayz6ZOdyWTvOyKHSO2HdooNAHvgskKksTaWNqT881arX
 qbbIqRvE
 gemsR2Dg3zYhi770uKhdbZ3+ka/zr6Rqc3d4uQMT9j6+yXU3kfo9dO7nNR3wEzf76BiWa7bMe5cJAgBUqc2n4nb1dLyMay4UpUfc65J77QI1z/Z1nso+bvgUGlb/1DPEmr3DKx6HWxhZeFRtDpj04cBkBOu95yYRilLeNX4QQZCdgXWmt/4iPZ41vLGQmrttykdbt7418xD4+nBQEMLFMPuEY9xmgbFrPh1QiuEfeN7wNmg4xTUl0RHLtGvPX6gLPFQCjbnLqJPDSCqzXxC2ET6zdMttoZXq5SkCe81ruF8fbuEPb5o/qumhNfQ6ElANwZCt1WvrXfzBEHXQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 15 Oct 2026 05:15:05 -0700 Roman Gushchin <roman.gushchin@linux.dev> wrote:

> > On Oct 15, 2026, at 5:08 AM, Harry Yoo <harry@kernel.org> wrote:
[...]
> > Quick question: when are maintainers supposed to lift embargo?
> 
> They don’t have to: it will be lifted automatically after 24h (or whatever is configured).
> But if you as a maintainer has an immediate comment to Sashiko’s review or you’re ready to pick the change, you can lift it immediately.
> And of course maintainers can see review results immediately.

The maintainer feature sounds cool.  I was wondering how I could do this in
detail.  This "What's New in Sashiko" [1] is kindly explaining it.

: Maintainer embargo access & early embargo release
: Signed-in maintainers can view embargoed reviews immediately without waiting
: for the timer, and use the new "Release Embargo" button on a patchset page to
: publish results early.

By the way the "What's New in Sashiko" is very helpful new feature.  I will
visit Sashiko web ui more frequently.  Thank you Roman and Sashiko team for the
great works!

[1] https://github.com/sashiko-dev/sashiko/blob/main/static/index.html#L1894


Thanks,
SJ

[...]

