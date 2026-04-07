Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 396ABFEEF29
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 12:34:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 902736B00A8; Tue,  7 Apr 2026 08:34:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B3786B00A9; Tue,  7 Apr 2026 08:34:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A26B6B00AA; Tue,  7 Apr 2026 08:34:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6B1B36B00A8
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 08:34:00 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 343E4C27C6
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 12:34:00 +0000 (UTC)
X-FDA: 84631701840.25.84B6DE3
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	by imf18.hostedemail.com (Postfix) with ESMTP id 33C311C000E
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 12:33:57 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="cjSMbF/S";
	spf=pass (imf18.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775565238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AZHsJ8d7UeNxDVKyDSMqMJlOMAtv9o44F8YV8qS5530=;
	b=pHn5zpA464nD0UCxmYkFOxT5bu70S/QT+YTkti4esvea+7lefIvKAJ0knVWqZ+SX0ck0nb
	sigrCReuIsS4RT/z39Vsuz9YfXF3RAngpX+hNXlP//gE7N0kzHa6KlpS5nKDHyz4wZVgli
	B+YeIgp2bLggfDzSovg9RvlTZ/yIe5I=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="cjSMbF/S";
	spf=pass (imf18.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775565238; a=rsa-sha256;
	cv=pass;
	b=GknzIDqfn1G1wNL5ak92MipzPfYnxGb2mBNoz+/om3WAbNPpf5xSyBXTmwdsLH70/S9IDm
	foezqAy6C11zOCcHueHMQE0ACsjvNhmaS4gZ8mWkYa0VI0Sq2CJzV/nMLO+LQGjWKwcDbK
	iKV3EyMiJ/qQYRGER82zUKb38p8pea0=
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5a2967e5de4so6747498e87.3
        for <linux-mm@kvack.org>; Tue, 07 Apr 2026 05:33:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775565236; cv=none;
        d=google.com; s=arc-20240605;
        b=dEwvWK3B9ZytVcEkoIEXaZ2Er9psy5m6xv+Ejbr9l4+De2ypvpUbi5vhEXQdPttS/a
         iBrqBpVRxRvdk27M61vGB/jmIsf40Ek+epdF2lpJGH2wqmQ+3IKPqxCGwxdKHEo4jJZh
         kbTpFENkyVLdtM+Zom9Z+/Fp0VH+e0D9xecduxKH30fK/QqbFa8eRsZJnv2Z4i+BzKCv
         dEB7zh+wjJLGZYwX4MWsOLwP9SMgoPl6rpreIitkfdEoZpiPK9gyCPlIsOmeYJdxlBLM
         feP8aZ4Sp5O6BNfn7vUeA+6A0o5hGIn8h5ies/zdCXyAOOVaa1bATnBIkSOCKZZKBfpv
         oCuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=AZHsJ8d7UeNxDVKyDSMqMJlOMAtv9o44F8YV8qS5530=;
        fh=1vckipBj+3MY/aNVjUy12ybEcFje2u4HSxU1i57A0g8=;
        b=EtzjEguTp8dp3sDeu/qcct4m6w0SeUoTk2+guubx+fK1Jakce6/+8ikbKMCWjocTxq
         Z3BcEMyTiJEIYlQ9fXr65NtRlKT1MZFk/6Lu88gTVhVd7xgcejAZfiq35qQrD0n25PJn
         lWGmTzS4AoRiY8b8cWA6XI7XU5ckAVAqrik3TstDwHwF4eWkmugPCIS+DvvpQ7l+HKXu
         gV0do6J+fN9aECT1w+pgrT0dNVoJfQeOkQFlSYGKbwjQkKPJ9btqGWul9l/bpwyMC2p/
         pNeyYhBGkz64KOwCygFF6RY+t8L2R1sreFzZGzBMgId/e5AtGe1myeXd7uKVZ1BcjaH7
         p9Uw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775565236; x=1776170036; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AZHsJ8d7UeNxDVKyDSMqMJlOMAtv9o44F8YV8qS5530=;
        b=cjSMbF/SOJ56OxIdYqvSyZLgojNiOQMBn5ZilRwVAi6My5iGaWN54wrLrZvRfyu1Zv
         LGQRU5HKovYUdPB2DuGYIbb+iPl5y0v1pc3m/RRZhz4ZtDK4/ACn7puqWqsCzpEvBbQ8
         vUiBGC2WZmkgxGFhkVWOWubjlBH2bZ6mTi2LaEpdtmxSMut8fbiswTKpgJcIm07zokDC
         vuUHN6I/D7HhCs58KH7hf34c8XxaHy+DOIpDCY5RnqwNJ6bs75XSEAVUkhwjZyC9lZB4
         HwrWlbOPu1UzzyH1nOhXDjqa+3KOLfB+CEqRgd63uyqqv4gzChRO8GvfwcKJ6H/4Bikh
         mAAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775565236; x=1776170036;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AZHsJ8d7UeNxDVKyDSMqMJlOMAtv9o44F8YV8qS5530=;
        b=c8DwDPq/oYTb9cviqdDmieyQ5+kg6BrkfXGEzy+1XzhD8i2Zu7qewovwHzWYxZ/pUT
         W0sljZjTNCNUzDK9Ya0w80QW4A37Ze7f3xViA8o1M6zyYbKYqE9FhtgdvjxFy6RhnA+U
         aqPhgRoYY7Z2QhAnvvpt6cYDSHulztm7tWmnvGSiv6/BhzRU2+hDiN0YWEG9ow8gSFVH
         dzGD0OJfw0Ukfo++A01wg4xlMA4YZYhdgoiIYkTSbhEY+1r3+EAG2YaaGh9Z+r9uIlIU
         JpPcfnb7UcBZ10ps9QPZsNbCQq/lvq9ktsWbLY8Eh3CGmoWoReQqv3I6Tzleq8Hegrb/
         BaUg==
X-Gm-Message-State: AOJu0YxI5l95YRlVQfgbOO+1MolU5YB3F7doqPRbjKUMfSAjDfzVddK6
	XKoua7f28bquJBA7YZF7BzkQuhUwtN09h5uHOMVIoo/IhS+GGEpcRA7xYasCYK8yWZBNP5Zv0Wn
	eCjGGkOouN0wDCrvvn0NHKgDv7buHyYI=
X-Gm-Gg: AeBDietd8EOkKPn7M6ACTYw+0F2s+PQCrJbQgnle5HZ/vmJKb5fNCF7tumllxjpGuVS
	1Dp91MSE6y2Lw3IOvNGePkBK6FIA+eK0QcLkL9z3Gs7XAnApwtbkRsimsKyY8hgM3UIHoh2MstK
	VuSE1iWd+CydlCidKZiogmZP/LFzQ+7DwBWuuhKUDobc4Yp6DJUDP2mFDddN7SYOX0R+DXHBdUZ
	x7HSD/3WrzIa1gHLTh8qPtB4KMpEdQBo4a7x9/I5f+5ku9KtkjfFIa3pVlqc+DIuVssi8SKe7M2
	zgtO
X-Received: by 2002:a05:6512:3b86:b0:5a2:b156:8496 with SMTP id
 2adb3069b0e04-5a33757c307mr4780277e87.20.1775565236122; Tue, 07 Apr 2026
 05:33:56 -0700 (PDT)
MIME-Version: 1.0
References: <20260407110002.204755-1-wujianyue000@gmail.com> <83bca4c7-ab12-4788-ac91-5ae1736b031e@kernel.org>
In-Reply-To: <83bca4c7-ab12-4788-ac91-5ae1736b031e@kernel.org>
From: Jianyue Wu <wujianyue000@gmail.com>
Date: Tue, 7 Apr 2026 20:33:46 +0800
X-Gm-Features: AQROBzCbhO753qRjubFDt6hd3DX7-zNPR7qVOrMNkuIDyw6tMI8ChuQMmCsZxvQ
Message-ID: <CAJxJ_jjrFWrgJVAwx-K6p85WKkGi9tWvcHpdnVnMksjSg1aB5Q@mail.gmail.com>
Subject: Re: [PATCH] mm: move folio LRU helpers out of swap
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, hannes@cmpxchg.org, 
	mhocko@suse.com, zhengqi.arch@bytedance.com, shakeel.butt@linux.dev, 
	lorenzo.stoakes@oracle.com, chrisl@kernel.org, kasong@tencent.com, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baohua@kernel.org, 
	bhe@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 33C311C000E
X-Stat-Signature: mq8z4kn6t36kqcqttjsdwkxhhidmotiq
X-Rspam-User: 
X-HE-Tag: 1775565237-43591
X-HE-Meta: U2FsdGVkX19LKLszSlj+an7M0g4aOc9l8pI7CcWuHGKeJ5wfcYnclBJtm4DenzBREykfxyD0fb9XsdyiHCp7aLiUpLs9+pbl07LbrkZ5BXBqi5MF9SZ1Zu91hVVvB2ydJfa4T5wx+5MH8UENpRfIrnGdro5H/K7VZ6UyLQPpwegEUP8TCn6HOAn06CTid8d2iGitEXHH1ulAf1MSAKEo70Jr5Jby6LDdU+fHqjUi9vGJWo7PV9SsPFr2g/qETtFSPch2j6glNuTE6r6dUKwEAH119ATrRMYTBxnw/PptiWfdSU8oWXH4hOZinxkrElH7M6XuS0DgTbxy5crRsOqIUWbEUTR5XW1lfbos1axyuk2mbobePnhtgiS+J7rzgV+9kZzPCOnbNrCrHBH9wzSWkp7U36x5oZF5V61syMIkjVNG+QhkA19XlgPkoHCuJ3QwIm3KS99Z4DFpjh65FXCvRxmu/R8YPasLAyi/7h0zpM4udyG8LmJf2N7sTpqK/pkJ2q3cUvlDoq85x9ITlV3+8bOx10IysewGW+lK9Sjfo70K/n6UYyX5grkBuRAayp1E+EWpKySuK/AOK8wVlGUxk82wSVbQ5ms1zRdqqiX/R0nb3BjYBjE3Dr2HOvfpSoSeQ1kQYVV3dE6NYAm2OxHzEknppaPpzQ1HTTT7sKv+Wl4/ghxvtN8T1atkKCpAWplRNOlzcKnclDCSvP1HnscTxs603qReUqup+iRu0WaGUpXGwpx2TLG7JIh4P3cay6F08QR6v4pq1cOttKS3M7bD8w29YHDFv0X4HdnjtkOPfNcw2/k4feJtR5f/VTnKGKi13MVhPd27gASo8tradtzXRhWVYjzGIPH6t7svT0UIWqTyTkHuF/G/KMAfVy/GK+7+IYv/tbsyvmzzqO42xCNi/gApTLbgmUWtc4PrVFtOhkEgixJbb9H9+yBcI35ASgkEYMXLZNwA3V970iVXnrt
 wEWsVgMn
 GuBsrfWynxv3yEE7Sq+iZ1d54kHrL2wJskyH/zLEIZWl3Qg8vPRq5AeZL26s04vN92RK5SFt/+XRsfcnRLfepaxRX/5ZEUheOcLaqQ5nTMZS/Y6ucP3Cnt4JmjzFyoKMnENHwqKsMIvz87Teop5ab0G5F6WrNT127y/4y4c2Ex3wLMg0+eaHKnL6x0UaJTPgkF2sefgeA0K5VnThGJYNGpHm+5g6bXnvmTTpnUYrhV3GUTOgKMfX9IA3ERqv9UKiiSOdqmaDY+wN7l0AIBxr23/YCFAfPn8JDxHwbClj5S05/HuNi7qOHzE63kpxir0zpkOZKg3VnXnL+LMi91Rz7r2yQfuja4ulNGvcD4DTMjNK/zgNlESUkRe80edkcgtpk6DDdcrFyl/MmfKVJz2CqcDAiiboreSyCw/EdX9//Rw4zzYpMrJaWCINemArgBZrRKuZW7OxC/bLJrrrBZwWdJK+SDLVMh11wj9yIqZjozaxysGCVAx13x0VfhJbaZwlimFrP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/7/2026 7:42 PM, David Hildenbrand (Arm) wrote:
>
> A note that shmem also uses swap.
>
Hi David,

Thanks for the hint. I agree shmem participates in the same
anonymous/swap-side paths. I'll fix the commit message in the next
revision to say that clearly.

Best regards,
Jianyue Wu
On 4/7/2026 7:20 PM, Michal Hocko wrote:
>
> All that big churn is really worth it? Are there any other reasons than
> "not so appropriate"?
>
> Really if this is not a part of a much bigger plan then NAK.

Hi Michal,

The intent here is to keep generic LRU/reclaim helpers separate from
swap-specific code paths.

The LRU helpers are shared by both file and anonymous memory, whereas
swap.c is meant to host logic tied to swap devices and swap entries.
Placing LRU code there would blur the boundary between general reclaim
and swap, and make the code harder to follow.

Separately, I=E2=80=99ve been looking at routing zram=E2=80=99s swap-slot h=
andling
through swap-owned hooks (e.g., swap_ops / swapon probing), which
would involve swapfile.c and swap.h. That=E2=80=99s likely orthogonal to th=
is
LRU move, but it=E2=80=99s driven by the same goal of clarifying the swap
boundary.

Best regards,
Jianyue Wu

