Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5ADF0CD98D2
	for <linux-mm@archiver.kernel.org>; Sat, 13 Jun 2026 06:07:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83D8F6B0005; Sat, 13 Jun 2026 02:07:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EED16B008A; Sat, 13 Jun 2026 02:07:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 705006B008C; Sat, 13 Jun 2026 02:07:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 634A66B0005
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 02:07:03 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D3067120357
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 06:07:02 +0000 (UTC)
X-FDA: 84873856284.06.FB18F6D
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf05.hostedemail.com (Postfix) with ESMTP id ED8A3100003
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 06:07:00 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=M880zC7u;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781330821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Syw7ULXdB5dW8ZcIfM7qGgtXBrTWdNGVXAYsbJq7l1s=;
	b=eixVALSKuuwKLJZGZOkCE77T1ZOPZEo4SDq/tYpdkhuNwzkOKGi595EvRMtueM07+q4xJm
	nUB/6aRwtw+sv3kJblcXDoh9ECde7T7mWPeTHYy5f2zl5h3S6iQ2E51v0HNSgATzlpw9NE
	Qc7xAZrsxtfsrjyoRRGRBsgNcAX8VOg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=M880zC7u;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781330821;
	b=033bpHq49R+ZeAnkHuZCXtgd/BxJ5IuRoMlrh2TS02bbeWt/vq0vYfqRhQG4HHPdUtqzfx
	7BxvOYn9KxGNaDJINCbt1lHHeZnMN454GcuUv/fsgGKMcmxR7mUV3vf+e0K5SfDfZ2w2IG
	OgB+Ux1IFPIxg8eRblIvBiK+iBKXmyg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781330818;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Syw7ULXdB5dW8ZcIfM7qGgtXBrTWdNGVXAYsbJq7l1s=;
	b=M880zC7u2byTFN+N4Gq3ygEGJV6uJ/y323l98Uq2VwiDsDKwwbe3KSZIsE6fswnZXAIDQM
	ncME5PeWmLbP9V5sIdSHUE8XEIhJI9+8OEhIAu5FhcUJagvyZNVQOVT5s3ZSRIrP6Q0Swr
	Ebk61m5Zsus12EN++gCjPlzL6R/lrYY=
From: Lance Yang <lance.yang@linux.dev>
To: dev.jain@arm.com
Cc: ryabinin.a.a@gmail.com,
	akpm@linux-foundation.org,
	corbet@lwn.net,
	glider@google.com,
	andreyknvl@gmail.com,
	dvyukov@google.com,
	vincenzo.frascino@arm.com,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	skhan@linuxfoundation.org,
	workflows@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com,
	kaleshsingh@google.com,
	21cnbao@gmail.com,
	david@kernel.org,
	will@kernel.org,
	catalin.marinas@arm.com,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [RFC PATCH 0/2] kasan: hw_tags: Add option to tag only at allocation time
Date: Sat, 13 Jun 2026 14:06:37 +0800
Message-Id: <20260613060637.40039-1-lance.yang@linux.dev>
In-Reply-To: <20260612044425.763060-1-dev.jain@arm.com>
References: <20260612044425.763060-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 9t17cgahnbjc9dooghjkt8ihir3496qt
X-Rspamd-Queue-Id: ED8A3100003
X-HE-Tag: 1781330820-380841
X-HE-Meta: U2FsdGVkX19btdr+S8bYhRekdUH+OB3OG3o3rpH0SHYvCvgK2Tif9cHj1lj2CC/gZ7egMykKWzrIdTtKmehcCm1CGAcaqgeWTgFI8uMWsFsRfc9ytF5ZdZEA8HcYxVZ5OY63D4AdZgwiiZLZlX3PoeKfqjnrixTVa5Lt9qPzZaJbodsJoSfDFAL401qmM/h4zBXF0JiBXiOpI4BLF7CHkvQibSH0ZReox0DlEuTLUhjKc/QtclrQssV9UU618M/cEKJbqoJktn+Xxav0YH4AN1HUaN2/xKzPSOpyS+MIpcIKlwewHwfwnMU5PUXZkeBXeD6XmfB1Nr7pQH7qQhfRsRFHpVVNatad+/Tx5qJhoYo4v/1wc1qYZiltvCjfUnzsO9DX5oI1RI+wLFM0Vyf3kEg+at79OMDJwMRbS1PsGdR+0823agP8bIw+35TMfnXnZoErLkDD7W3IA70uC8af5VEGgWDe1xDf5tMlU3T4X/7sCEjR0EkyCAAzWnb0erEMV3Feb+zSsvBgLTf4RPDzrLoeW3ZVyA7PhogU9+91x3Oc/QKXKw7tXBgB3tDVYUf0OMgpPb4r7ZUW15Z8Yef/trG3OlzReNeUo3kytcM8eoXoDhGy7cvL4H3O4/3MKzSJQY4mc/LVNXRILGBjcRGA0IsPx4jNha5JoR5JAQSbbztmHlVO+f1UW2UBNL6turM8nweNVLNTUivLmQfLr65tPGn/g9VGOCZ45wxnmxB8ZtXfmPsEUyFXNsX8UECLFQvuPz3Lel4a2EdBAf1xw4yb/mkeh4ZJLKbT2zSho+9xuiHOaHdSpodu/67h9zUsJj1ywaTvfglWQ6nuO29QJS6VJkZMjMjl+5YmJwb8cIwkDE+Ewjcht2mnESOnySHCFiTA5t8hg//H3q+3dHklV6S2fdgiIi1kStmHB05eU7u8OcWnZcjYSG+1IlKtnT0Uy5WN2AE/LCXh214ZcjtDg4L
 flVjkTUA
 KmsPTrh8ObLbFJKNjdv0AZRNIXR1cD3r5Y2EByErghHKPPwG5tgZvTzVlRMp0U46wKc3ZZm56iixAs6IDsD2DK5Ox4i0tAVcxunRs8U+Ufh3U2NX2XeLZiGhOCexhdPh+UAAXSOePbIH+bNvQm2za0SKeKkNz0B5ZNf/ikgbUOhqouKAffraSvjX2jY4RBA7W8eG02R34GudHzRZGQWJWB816h4kU62fgoDs3wkpjAxfYMFyqf9xE91/ZiBad6/aZDSIM1qTQhbpMlWRCXRFMcPl91ECPq76FfzH5Ushnn2wBDp5aDysVne1AOIpenCcplf1eBlGrPPVgdZs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Fri, Jun 12, 2026 at 04:44:22AM +0000, Dev Jain wrote:
>Introduce a boot option to tag only at allocation time of the objects. This
>reduces KASAN MTE overhead, the tradeoff being reduced ability of
>catching bugs.
>
>Now, when a memory object will be freed, it will retain the random tag it
>had at allocation time. This compromises on catching UAF bugs, till the
>time the object is not reallocated, at which point it will have a new
>random tag.
>
>Hence, not catching "use-after-free-before-reallocation" and not catching
>"double-free" will be the compromise for reduced KASAN overhead.

Hmm ... do we also need to teach the KASAN KUnit tests about this mode?

With kasan.tag_only_on_alloc=on, free-time poisoning is skipped, so
some UAF and double-free reports are skipped on purpose, but the tests
still expect them :)

Cheers, Lance

