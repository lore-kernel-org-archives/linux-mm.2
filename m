Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47807CA5FE6
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 21:53:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38CFE6B008C; Fri,  2 Oct 2026 17:53:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33DA26B0092; Fri,  2 Oct 2026 17:53:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22D1D6B0096; Fri,  2 Oct 2026 17:53:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F1F546B008C
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 17:53:15 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8BD571C00A8
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 21:53:15 +0000 (UTC)
X-FDA: 85279037550.02.4FA49D8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 94F7318000D
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 21:53:13 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aYuKrJHa;
	spf=pass (imf06.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790977993;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tvMgeaa3mLhwDw+Sr6yMKLB4FG0e9FIsh294Gs8VTs0=;
	b=nStPrFk0goqtOQ+HRlzuhmPWCgqU0TotD1Lj6dS4CAp90AmpSqsZOKv1JQK7r7zfhwMExg
	imNwVY1KVK8ULvbRo+G4dwfQbuDoANtQlWB79cQkOq2iH4Q8TBVYW14fhkchmmBmMjbhVj
	WgtZZW7KLze1cYh6MZH/kE09hF4wfH4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aYuKrJHa;
	spf=pass (imf06.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790977993;
	b=FIgXTsUXX/4+b84GCHZBhb0gFHbqM+g3SNlSnZZEPN2Aq959se0xy2ZNoj5/D551fysde9
	OC+YQGBOcIqLzOpExqgECj9Yh65mDatNkzgYoy3NdQLAG1Tw0+mHOKWVY9XVsHh5V3Nt3P
	qDEYfN5PiNHFie3barqesFi+0b8YLOs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1C0DC43FB5
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 21:53:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E70441F008A0
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 21:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790977991;
	bh=tvMgeaa3mLhwDw+Sr6yMKLB4FG0e9FIsh294Gs8VTs0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=aYuKrJHan8/ubzf2K03ZfQXmKjgjEDKn1yJ52gq42iRXsT2wS3Mfv7lgiYIDG/syC
	 mnn1/sd4jINyrrtgedMWELNUr+7xv+fNVZww1NQY3TpV1VzvKQAifN/OKp3ziLyylZ
	 5r2xpmywjkHnZkU5ujV5MT8cgISd+rYJPrwobEhdvQmhtIbD5MKkyrBh91K54Uwg1B
	 ThIzJgJtvJOzD7H6QGvlG6k67btQwg3eH4FW0mLznZhySAhB5lLYEQkdJmWsk6D+8o
	 35fOzPyb4QFoF/sCxhw38X6TIhvJZi28C/csqskWh8FW2JQantIj2u8NB/x7AF4Awf
	 M3d85zs3u5LCg==
Received: by mail-ed2-f32.google.com with SMTP id 4fb4d7f45d1cf-6af7d702c76so543523a12.1
        for <linux-mm@kvack.org>; Fri, 02 Oct 2026 14:53:11 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBw3o9W/lkHvqcUzs+gZFXW5FmJV+wrIo43mt1kblP27plujMh1DtdHT0kdKJpDFRLFi+JDuUOoRSA==@kvack.org
X-Gm-Message-State: AFq9FYINYkGdR+UpskwiJPXzl36CROz2Qt2cu8DGA4Z+uJkqfgPXRRLc
	+UO+8cHuL/BI5os3zeVYNQeL8nJF8RNu5RekiGNdP6bWbOSqo3kV5+ocaAGh2bTjmWRpnFrdF4U
	IzWTIAs1IywalzqR5FhFcnYl+wU+kJFtsbY9VudCwHQ==
X-Received: by 2002:a05:6402:321f:b0:6af:9d70:6d5c with SMTP id
 4fb4d7f45d1cf-6af9e2ed876mr2784209a12.23.1790977990724; Fri, 02 Oct 2026
 14:53:10 -0700 (PDT)
MIME-Version: 1.0
References: <20260916101929.149106-1-hebaoquan@kylinos.cn> <aqrHjfHwyEtRIr5S@cmpxchg.org>
 <aquWKJoP5JLP8Ci7@fedora> <20260917131712.GA1344@cmpxchg.org> <7bd2b824-4c91-4378-a817-d5ce475ea84d@kernel.org>
In-Reply-To: <7bd2b824-4c91-4378-a817-d5ce475ea84d@kernel.org>
From: Chris Li <chrisl@kernel.org>
Date: Fri, 2 Oct 2026 11:52:59 -1000
X-Gmail-Original-Message-ID: <CACePvbUS3a+2GRMxF3yZniS_r_N_REp7PNNRt2_HvWH1MP42-w@mail.gmail.com>
X-Gm-Features: AclHuK868gG9XDOLnFOp0JUyU4V8lbtIcL-DPjMKorPF04-UXDX2NmmFoAiPgCE
Message-ID: <CACePvbUS3a+2GRMxF3yZniS_r_N_REp7PNNRt2_HvWH1MP42-w@mail.gmail.com>
Subject: Re: [PATCH v3 00/14] mm, swap: extendable swap devices (xswap)
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Baoquan He <baoquan.he@linux.dev>, 
	Baoquan He <hebaoquan@kylinos.cn>, linux-mm@kvack.org, akpm@linux-foundation.org, 
	kasong@tencent.com, nphamcs@gmail.com, baohua@kernel.org, 
	youngjun.park@lge.com, yosry@kernel.org, shikemeng@huaweicloud.com, 
	chengming.zhou@linux.dev, linux-kernel@vger.kernel.org, kunwu.chan@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 94F7318000D
X-Stat-Signature: 457wwux7583ibejud7r95945y8f87sgt
X-Rspam-User: 
X-HE-Tag: 1790977993-703022
X-HE-Meta: U2FsdGVkX1+KP6F5M1h2sKpR+vIYWcKqQYdUL/RG7ZYrpfr46K8A9Y2QONezP4NwH9N61L3vCJ9xfbl8V7o1Ik7V6uN6oa8PhI/Iwdbif3DeeWSNqn28saTSQErpyUZ01alFS3SWWcXzwmr1HrNJs60Sxp0PTq3DQnKcyOl/LjgshkvOnoafKiAU8rdQNIxlKtB+irY7ZGuP8K/Y7Ut5Y6RmMGjpASZPA3r21Szab30LybpuPTxuGt3r3RzPRm0oN1M+KtX6dyVoZj5ddw6tmnybWN0cWajSg5ikhV8vVgjrkn4idSQ4Hu5hM7cjn8g+HCvxm8PjKZxWk2R2cZHMEPU1Iqw9Z0ZCLkVjKqG8kFbkcXVbf3qIs906abRbNEx8HdU4ia7EQjdkWOhGEkeySns9+MpWlGUNq1e9O9cU1kuKj592CUVKejNAJCov9NgraEUltF0ARpSdnun8ZnYSCdZBH53LnXCK5dWEwKmNEtYLEMWB/pZVIQHQfTifsRH14g7rrGtL9YuqwFLFxxcwMQ4GOQhrbd3+LsMlJflakk1nsDl4WCccUiOoI2R7LDRAusWrMg+7kS9SEa17hQmJwNd3LJsVovt6x1MsqzPrHpsEI7ne5GnkcLoooLUa329oZaSR+fqbOx3WZiOFISTORky4/vDWXDdKJ3InLC9oWS5S+pXx+Fske2onvJHYpgA9GYsvNzBpHy/mS5HKHsysVsT5k66gYwyQldmddeExzo4LLkzLIKwMZ9ueUe9h8r4pXI6hlRUHlrOloj3KLYWHNvVd6NyM0X87W5zKEBKKCWvitB372ySdHe/1b0UGCRwxIfRbEVE+QWwmNTWrsMHkHlMUzZVPhZFnsv584hZxLKLQx2l7PwGylnkd2a0Kj/qBBmHOZZL0FodlXyyUYO/jwR8ed9S+RNayKPxfM1r1sgoPDQJUDJhYvdZP3K0mcpeu0gZzIqIpbP+9T7wTIaK
 maCo3hG/
 lPKozY3iU18y7UqR9iveSMtHJH7hMxMpQ4Fl2mGIAL+A4Oqck8TxeXUUY+t2C7McBKelfxw3bVcGq9NvXOjg+kT2CWr1xlD3E7QFq3HOVkQ/37LThHgVsfUXGRUHaWLgY9KhHslnfev182tU8W3tsi7pVbPTUMZMCL0F4yXxkaAg9EhrE0EQ/jz4WJxfdsqeAXidS+NVPn5hPko1SKvBYs/zvrYI+vwWlJodBoZuLhj36tbdmXlLHMIvctnbkZ+zHxvaPfOnc9TDNT/SR3hASsOZKsDy6bPRYhWkuCNPk62CZbDOA/PyQY0wudOl/K+qAq8YDepBSydaHz0rACxF4kdCd1/WBqf8s6dwCO+KtdIg4/kfaZ3BrtMX+07sjq/9UMrBGkCdcy1RVOBr8ZYpnGAgz59kmFDcdkGDaMhNUC2Gw5INaRrl6bEOW2mI7B1OfQhiq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 2, 2026 at 10:22=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 9/17/26 15:17, Johannes Weiner wrote:
> >> And the limit is only an optional knob. If the admin does not set it,
> >> the device grows to the full address space, so there is no space limit
> >> to hit at all. It already behaves the way you want by default. The kno=
b
> >> is only for admins who want a ceiling, they can use it or not. I hope
> >> this would not be a problem for your use case.
> >
> > No, I've laid this out already as well.
> >
> > This isn't about "my" usecase. It's about designing a coherent
> > interface that works well with a large number of usecases, and other
> > pieces of kernel infrastructure commonly used in conjunction.
>
> Johannes, I read this as a NAK for now to the current approach from the m=
emcg
> side, is that correct?

I will let Johannes comment on his take. Here is the TL;DR: from my
point of view:

Johannes does not want to allocate the vswap/xswap entry charge to memory.s=
wap.
So he made two requests for xswap to move forward:
1) Must not charge to memory.swap
2) Make the xswap initial size large enough

Regarding the first point (the charging problem), Johannes later wrote
up the two different use cases very nicely here:

[1] https://lore.kernel.org/all/araWKyJ5MENBwXCL@cmpxchg.org/

So I am not sure he is still going to NACK on it. I wish he had
outlined a path for usage case 1) in that email.

Zswap currently charges to memory.swap when allocating an entry for
zswap. So I consider it a user-visible behavior change; we should not
silently change the behavior. (Others disagree because current zswap
shares swap entries with disk as well).
I am hoping that we can find some way out for the charging usage case
1) in the emali [1] e.g. have a config option to let the user select
which charging behavior they want.

Otherwise, we will need to find an escalation path to resolve the
different opinion on this.

>
> I've tried to follow the discussion on the other thread, but it just expl=
oded
> and some of the things I read there made me rather upset late on a Friday=
 evening.

If you want to have peace of mind, that's the wrong thread to read
late on a Friday evening :-)

Chris

