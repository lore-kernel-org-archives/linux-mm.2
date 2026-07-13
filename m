Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B011C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:26:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7211F6B0104; Mon, 13 Jul 2026 12:26:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 683386B0102; Mon, 13 Jul 2026 12:26:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 599B16B0103; Mon, 13 Jul 2026 12:26:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 29C156B00FF
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:26:24 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2DACA1C12E4
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 15:50:53 +0000 (UTC)
X-FDA: 84984191586.10.8B59D3F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5B0A614000F
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 15:50:51 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jGYvq+lC;
	spf=pass (imf23.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783957851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0nEqidDEll0lFKQJRsBXv+q0TtERg9N1HIHV1PMhX58=;
	b=DcnARUhQBX8KTNVegL4197DrUrF7SKt8S2s39ptYzOzwUwf9J2CXg7yP3ttc9gG6VLj/db
	QRFe291A2dkXu1KAN2Tt5XyeJRfWhtJnW0aNrJKK5v6o2b2Flll7Nm4ms5N60yKaVple4t
	+SUcjwpvRiOTyMQSKvurOebmDHt8QoE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jGYvq+lC;
	spf=pass (imf23.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783957851;
	b=lJESxW6TfHcrFVN98gNkJw8BGIKy1wZuQlGB1t54MhHnMrXJrEozCtul4+p7RkZ1BM91t2
	rLDFIlfxUgrsWputTVbN0QEG4D5qV7MVeahDfxh0aW53fYNyEuFRgiOCepX+xv9RwA4V+V
	ECNF9FJIGl9qXgzZ9M6rtNVThkbci4w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7DEA360120
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 15:50:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AC1A1F00ACF
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 15:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783957850;
	bh=0nEqidDEll0lFKQJRsBXv+q0TtERg9N1HIHV1PMhX58=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=jGYvq+lC6AlLm5YUKylCcrjuPR192nylqWrEF79DC0BQGB1d5CMzhkZfqOIn5rE4e
	 DdrSgNZQeQYrzGQYpUaOwiZlBq73sCQapbziXXMo+B8dfiZ3F1t4yfup0C/y/xebTA
	 akueadAxOnLGfJho/RENMon3ZUhXeZq7SLeuuAl6CPWe+ZqDmFUm8aI6sGk9dWIG/z
	 eCkEGVqL+U1RpuZ7KtoGDPXpFEDHBWb5ral03WxMz+IPDo6U1lgHCPbLdJ69nNHtN/
	 ljZdnDGUnxCOBdDDF2ekeNCeDKpQQC4Qbhf2iOgUXppVVlk0HKMXPs+XgLLMhX47Mb
	 FTvUArODxiFqg==
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-69c7ab350e9so2386329a12.0
        for <linux-mm@kvack.org>; Mon, 13 Jul 2026 08:50:50 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rqh7ZuV7nPwl1GHaIyNLLsCeUIDkjAfzbm6wkRcawf8GF6yK/1rMdHbXPQtZnCECfFcJ5hJjbkJuA==@kvack.org
X-Gm-Message-State: AOJu0YxQcRNkBfpHtFcgT4n+xyoFeI9BqQvA0gcbuL24z6cg9mnFWTJZ
	QwvdjUKhMGgxmf/ZGxhDI45eZ0qS7kW0YizA3QuDKKhMDBzERin1M/IUE9KbXrd7u7yxF/+Y9eu
	usDzekLY20IOO53Ai8aj67Ae62RX+deM=
X-Received: by 2002:a17:907:3f05:b0:c15:cfd7:fdcf with SMTP id
 a640c23a62f3a-c161e9d8a53mr349487966b.29.1783957849053; Mon, 13 Jul 2026
 08:50:49 -0700 (PDT)
MIME-Version: 1.0
References: <20260713025644.170839-1-youngjun.park@lge.com>
In-Reply-To: <20260713025644.170839-1-youngjun.park@lge.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 13 Jul 2026 08:50:36 -0700
X-Gmail-Original-Message-ID: <CAO9r8zNJfhirbzvJzDWRaBQOM7XZcf_Jk0Bz=Y4dB4QK4W-MwQ@mail.gmail.com>
X-Gm-Features: AVVi8Cdhp3gmWcPxNKGi9xzKpj1txCkZgTK1iUjawQjsfXysMd41K64C1ZX9ciw
Message-ID: <CAO9r8zNJfhirbzvJzDWRaBQOM7XZcf_Jk0Bz=Y4dB4QK4W-MwQ@mail.gmail.com>
Subject: Re: [PATCH v10 0/6] mm/swap, memcg: Introduce swap tiers for cgroup
 based swap control
To: Youngjun Park <youngjun.park@lge.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kasong@tencent.com, 
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, muchun.song@linux.dev, shikemeng@huaweicloud.com, 
	baoquan.he@linux.dev, baohua@kernel.org, joshua.hahnjy@gmail.com, 
	gunho.lee@lge.com, taejoon.song@lge.com, hyungjun.cho@lge.com, 
	baver.bae@lge.com, her0gyugyu@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5B0A614000F
X-Stat-Signature: xei4h4phy4psuashmz3rwhdi3hkfg7qk
X-HE-Tag: 1783957851-868402
X-HE-Meta: U2FsdGVkX1/FvQa0j57AEv493b1dKalEuMYCInpdk996BU2ZWFTbEsgqnNW3j1MYuOn+YIJ9dUxaGaD38xFs+zF9U7YyI1heJs/oyzmntLsfFMtx6dREvolbulLWNHijBuDlbNIrNdhKzYyUD9NurwP0EhvQlD3HM4qZ2c+okY9aStVvg+KI3cHWcMjyYhQFwBQhEXf1puYOHWBF+0XQHyThBrms0ZvAa/7VXL1/06Bgyfetm8MFkIfW8wl4Vm3CjK/s+6IKLL91/y+1QpJPttFDhOvyoO5VmvHOW0vDHNEJAItbPXn+dk3KJ6ELkjMtTJhx8DIjcE+PI5VDVFqP5xglNJFIMYx/IIxgGuowzr7WXkyP4rSU7zQMS9pTSkNypbyhMJuh+bEIEc0HwQFVULoCp2lFLlYjr+3ljYa6g1fMplkPbKj1FiNkDRdbT8v91eCzHikvIdl1bzkUXorV3P8B13vpSfbRpf8awb3m2PV2398eCcxzmSyg86SLvPTzsWPQhhD6gztLpQUH1juEcm6eOyhLymxQ16ypN5a1O+LAgjUGKKPl1TdBr8VK7/V43wByT2FP/Y+ocKyXfvKPkiYPxWiAGj4iHUiyea65P/VIUvlbqCQrLatyvfpL2/KwLufJ1qlgK8+NIODleL+o5yZ0oithEIaGfa9DxM0Yn7y1jq5tmKjY4ngQKrcmixc8z4k+gIzc6fKOze7U/T9Pobfr7gUBQFQXaouENHOwLeiL0Dst9Zc8k14aHjQqdTf/5X3NvVkCmztymicCig8uZpcjYmmRnLkAy6kcD/cE1Oe930Fdx4VPSRJeYw736EGVyXxhjDN9bxnrXrqOnRjqgSF3oU6lV5fh4I5JYZokn2AMVtIC2qYW8zB9aUSXLWE0kpKHG336UI1+rAmjGuKXSK6YKl5BLUPEn65OVzTi0UdYJ7lNgbQyk/iIQUdlrsAE3VQlJSsh5VhD1/Zsq/p
 69Xhf9Iz
 +JZ/8z+SSrPv54isSL+9vq9TKVqqv1xcyLk8quhygNAL4L31O5bOfl8aA292zXmi0e6oYQFKkarb+kIsd2onsvcLEx/VCWdB2AGEPth+I3j3WZi/PhJ1u/RPyZ4Da12xBip2vaeBjBO1LyCz4V6ztXWSPI0hIu0ITklL/0MoeEpWAex+IzypZ2aUlwcwbt/Gw9fZpWrkkeTmJv5bun0TMXD177MWNv8Z02MMBFVPJzcjKuMk9i4YOuiIT6s3V6nZKQCuM/4vBthXHi62xVef5MjhKPElK9j/9ksjVpI5hphv7B+nR/av6WnZzH+auU1DMo+/srgQrlt+bxC1Xvi0W93Kb65K323K0E798wRpOMKnrUsP91PKf6QXi8yNQGilaj2uU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jul 12, 2026 at 7:57=E2=80=AFPM Youngjun Park <youngjun.park@lge.co=
m> wrote:
>
> This is the v10 series of the swap tier patchset.
>
> v10 folds in the Sashiko review fixes for the selftests added in v9 and
> rebases onto the current mm-new. There are no functional changes to the
> core swap or memcg code since v9; see the changelog for details.
>
> For context, the bulk of the series is unchanged since v8, with great tha=
nks
> to Shakeel Butt and Yosry for the reviews and discussions [1] that shaped=
 it.
> The main change in v8 was the interface change to use memory.swap.tiers.m=
ax
> with '0' (disable) and 'max' (enable) values. This mechanism was suggeste=
d
> by Shakeel and Yosry.
>
> This change allows for future extensions to control swap between tiers an=
d
> aligns better with existing memcg interfaces. It is confined to patch #3'=
s
> user-facing interface; internally, patch #3 still uses the existing mask
> processing method, which is implementation-efficient.
>
> We also discussed tier extensions. Thanks to Yosry, Nhat and Shakeel for =
their
> valuable feedback.
>
> Here is a brief summary of our tentative conclusions. Please correct me
> if anything is misrepresented (details in references):
>
> * Zswap tiering [2]:
>   Zswap can itself be a tier (typically the fastest one). But, until vswa=
p lands,
>   zswap cannot be the only allowed tier,
>   since it still needs a physical device for allocation;
>   that restriction can be lifted once vswap is supported.

Does this series support zswap being a tier? I cannot find any mention
of zswap in the patches.

