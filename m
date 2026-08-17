Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73768C5DF66
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 10:14:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7219C6B00AC; Mon, 17 Aug 2026 06:14:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F9476B00AF; Mon, 17 Aug 2026 06:14:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 635996B00B0; Mon, 17 Aug 2026 06:14:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 446CF6B00AC
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 06:14:51 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BA3EF80303
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 10:14:50 +0000 (UTC)
X-FDA: 85110352740.13.69EBA0E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id D354E1A0003
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 10:14:48 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=noiXC5aU;
	spf=pass (imf19.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786961688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JWCANof1P+UvaR9iuGp5besX9Z6ZpPN+9kwXpf4LhQQ=;
	b=CCA8OUk1EVyLFa3UYIAEGwBTvAIYaVqmsUsnhjRzCcMYm630t52cISGFmicQNBmow5qIuJ
	/Km4g7W0riQnXbAO94FEgn3mZel4nIRStNfbGdEbPUpTZzAHZhlqRlVrPIzhSNvM3ZSjkb
	ROQVxxItPGWIb1eE/MIIDwQrEY91P+w=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=noiXC5aU;
	spf=pass (imf19.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786961688;
	b=2YrzYF4nFsclX8HrtslKhmj/lg4Q5yl3DRf2od9P770q+yjbkqBHepEgWBLdAPM0R3HKhT
	YEtIXZiX5i6o/hrsoP270cap+CTxbVKR4D/BpyFDd71obzQCz9Igx/2VsNyPT30A7ayZ7P
	rm5ZM2tfpiywgjPbazXFMdeduG0ZDaA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 54CC54400A
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 10:14:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3781A1F000E9
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 10:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786961687;
	bh=JWCANof1P+UvaR9iuGp5besX9Z6ZpPN+9kwXpf4LhQQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=noiXC5aUb95SiisvxSdQhRlKaY1+zBewTUfOHzSu10HchyriYOasR1tbVVnpYnxI/
	 GVDn5XpZGFCSGMARILEbloN0tEHpBUodpXHlE39XrIGpX5hl9UA4bD+oSex628uwtb
	 Z3Q6FM1WH/imbQzTNKrfBuSSfAU3rzfL1Ett213oTTV6Qimkw0T/RgNhbtoWxMnpoL
	 emeNWvVGYneppCmOUhFhTXSY3QwaG5dA4OtGkw0md8nQvIgWXlnOx1ntvU1Cp/c4xE
	 e4j/5uNuXsOSRG+F5UORTQkmNH76flFStuynbkywP3sed+23vndUlPxEHuGvVp+kAi
	 T5E1g+GEY1PIA==
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-9349ad9c857so326719985a.1
        for <linux-mm@kvack.org>; Mon, 17 Aug 2026 03:14:47 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrPLkSn0fK1iZ4x5fZDAt5kVymKCJzqjjoBGQlj66QolFtZ3X9/uU5cA6AMBUhHX/BMRdQvTHgaUg==@kvack.org
X-Gm-Message-State: AOJu0YzJFl6BwXJAv2sFYvVQ04w1hWK5BDBiadcz/cK4tyJEvPiB7ZJ0
	zcXxkUmCBp+uUMFJwsUPPBSVjn6RI9DhaKh/TVRTkHGoqQ7+qEWDGiFrAlMm6SxovJzFetl2MIK
	p6HPRd3moGFi6kqzNm48yulYsTB5+hEM=
X-Received: by 2002:a05:620a:2950:b0:936:d833:6a35 with SMTP id
 af79cd13be357-936d8336dbcmr1808390085a.0.1786961686511; Mon, 17 Aug 2026
 03:14:46 -0700 (PDT)
MIME-Version: 1.0
References: <20260813-swap-v2-0-4a625ccabdae@debian.org> <20260813-swap-v2-1-4a625ccabdae@debian.org>
In-Reply-To: <20260813-swap-v2-1-4a625ccabdae@debian.org>
From: Barry Song <baohua@kernel.org>
Date: Mon, 17 Aug 2026 18:14:34 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yxsE9G4Fb7E0PtOUkFnPo9TDuRRFyzuq5EnBW-Vr=tUQ@mail.gmail.com>
X-Gm-Features: AcwNN1U7xnls4LZF6YjhhAgsKwiAj7RKuULE3VUd9AZUZa1kjuY0vPPj5I81_9k
Message-ID: <CAGsJ_4yxsE9G4Fb7E0PtOUkFnPo9TDuRRFyzuq5EnBW-Vr=tUQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] mm, swap: ratelimit bad swap entry reports
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Youngjun Park <youngjun.park@lge.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Peter Xu <peterx@redhat.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 3szt3bos5gwswgt6om7s3p7t4pn9ku5o
X-Rspamd-Queue-Id: D354E1A0003
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786961688-134254
X-HE-Meta: U2FsdGVkX1848SjckUl8cIeSU5tuQ4KIFWGVoqBf/1iNbXpUhuwMrsp2KHMurnukS33IIkLgUVu5I6Td6TVHFpat2AWj2fSIcgBejynOVTO59B2Q2lafGrsj5ZQFbllv8yT74wLys7c3vNBl3LusBZcxRPoVpM2V9CpqAK4aPlIzV+JxlzKSddROG+zWOsttjuotTc8rcplx5j5hpD669042lTIPv9kubqY3wpxEqAJJl67mgOQWEBhMJ7dvHYZ5+df6HCToRntVxXA2Vcz62aIqu+FW3zRPTw6xrSgHl7yXUo9UlvFJdDySgov/c7a6hXp17J9AUeOPe9C7UgpiK6gZlWtYUO+qf1WUBtIksBShPf20ZWdP5t6kIpa7gEQI4LXTwluZaRET+dJU3ZlYvaC4KF1S5qA9A9w4X7DbkKqf11xosroeY5AeBEu3JztOcJRijZitjMKzyjogOBh613YXOs2k14ndb8Jplk/MaoNkAQnJbQRfWBOmH39Z+BDUx7rXBd6oaFi75hspAXyxHGicXqu7G/CTnHBYnGNZdlc2mYQQZysbod4aLIh5kFfxJby5REa1Gp0TnSrnlmZAGN6oQrx7iuVexSdYJcd0vvUdIuSFJcZbQbg26+6BJ4a/y3zCcXvkDb99Z85l6oS4oDRegWWHuGZHyx3Y3Nc4vmTL4XxAkagjQ12eNBFMw2To6DWNvbIdMrxPfsG8iKIoz0R/r23wQU6eZtNb3Mk8Hp+ssHTKdA8FVr0PtJUjGLtaUeIYA3ZIQq+fbCWK4IvLEUEdKjMK1RtmHjFRjv0rF+L5/e1PJZYRu7QouwwjFszRN2iHsaoNiry3XlGxTeMZ19vFeFA5whXmIztq9Uk9A+DMPk5QLcbJCmAFUshmuthHVAwjNWm+Zj1Sr7jR3WuWJnO/80V7GfZ1vM2VoDyi6g3gRYcUW0CzZTXikAJ/Jmg5A8h9Fay5bg7NHdqjs+k
 ALMcpjs+
 nWHPMm8+eqCeCAPJdCWbkgIp+AZLTgb+EmTpEOFC0WGrLXSCJbBZvbvn5j/y/w7CmVs63I+Qtc/WtGuV8LXvTsKdkSHK8HoiytBaqn+cUOwn8NAhbFh4+rXjcme/lsfz7HmTaWg2GsQw3n32UfPTSICxCnGJ56HWj2mmwRquM5fx5kxGEDk71IEqvp4sgsgccqfKaU1IrGMOJ/boUI7B0LJCKWGKg66FhlG5M5+oQM0/p7cS/IouglerXRYLtJK3eXdtHFKpLC26rm8azi1qI+efvyfE7Ab62XDxlXRN9O72d5JG+JTo+SN84B+CecdOlmBbViG7Jrn199k+tbYrVGFORb7FwpYDmkc1JXP1xHeWwa+VXonbUHQsyl/VhaHYUR6iU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 13, 2026 at 6:02=E2=80=AFPM Breno Leitao <leitao@debian.org> wr=
ote:
>
> A corrupt page table hands the same bogus entry to get_swap_device() on
> every access to the mapping, and every rejection is logged. One machine
> logged 6185620 copies of the same line in a few hours.
>
> swap_dup_entry_direct() prints the same message from the fork path, once
> per call: the WARN_ON_ONCE() guarding it warns once, the pr_err() inside
> does not.
>
> Rate limit all three prints.
>
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---

Reviewed-by: Barry Song <baohua@kernel.org>

