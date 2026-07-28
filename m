Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4426C53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 12:18:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8205A6B007B; Tue, 28 Jul 2026 08:18:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D1DE6B008A; Tue, 28 Jul 2026 08:18:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E77D6B008C; Tue, 28 Jul 2026 08:18:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4BC626B007B
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 08:18:39 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B86FF1603BF
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 12:18:38 +0000 (UTC)
X-FDA: 85038088716.28.47D52BA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id BEB3D40008
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 12:18:36 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MCEfB9go;
	spf=pass (imf12.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785241116;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VTeUvvl4jFiVIWOQYJAGoz6KHvz/RpEPjf64mZpki1k=;
	b=zUv7B9xuDX79CT8xn1o8tMss3dM1iq/FOUR9jKzsqI8NWefi/jCyUAl842gCXG39CNFVFw
	Ea0TR2hQANtMYI9oe82jknwXEilXrEeBW973ZSavOt+iADC74as5b/UAPHvXqxq5qKmaFt
	oyayN8m7BNQPVwaVCn8DDIjVr4B2DVg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785241116;
	b=nHTp3HrWep8GOJpX6LLdjY+0nfHf3U9kUGh5vTyPSJ+CGzNdTbRKOxY44Qr6p12HCEEHXw
	OXIpoh3nk3Q9UJg8VWFIUt6ke5geCdz9JU4I91Em9wjpIM+bkMVSVwlPxUQgSO4tQeEBR0
	DVhw65bo3xiiaX7TL6Hbr4Pf2sQEW10=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MCEfB9go;
	spf=pass (imf12.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DD44343F2F
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 12:18:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4E121F0155A
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 12:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785241115;
	bh=VTeUvvl4jFiVIWOQYJAGoz6KHvz/RpEPjf64mZpki1k=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=MCEfB9gogdQ9+MJe4EVsuThg29+KtEJemIZq096OX3rb3aRapP0mU/lmmOULOGoQl
	 km9P9ToO7YF1BDfxJGztdw6wrvavcrqytNy1cAKkgc8a25uGFgJESlkBgzYLQkHxSg
	 6w/vb8nOolWOmAZcz9BAAz4nzL11kuGjwWMdo64ppit+63MmK4G/FFDUnlfzhSqOs+
	 dEN2TNtHpVtX9I9oszXATAxtF227wYT7JUCgugH+U4yxi0Rgp6ymgiMb3L0XKg7Cho
	 kuLdcc8BanT4dDTkurOlWxNVEWZBxGLBm3f6RCbUbyZ/gUGpvZQR3xPQaoAhqKNOSD
	 vS27TRIBDYmxg==
Received: by mail-vk1-f169.google.com with SMTP id 71dfb90a1353d-5c2c0e261aeso873545e0c.0
        for <linux-mm@kvack.org>; Tue, 28 Jul 2026 05:18:35 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrBdT4xiuc1eidWUwUhrdRd5gO0kGhuI4WvkHl+Ue4x2N3Z5SRLz75+akFN5OZVkl1v39PRuRCSpQ==@kvack.org
X-Gm-Message-State: AOJu0YzUO2rwxmeHhyM/WKnAwAiWd8GlNvkkEQqj+7PKBOdocEME4vD0
	97YmHgoAaVj2k3uGnGWGCG7BrVa495GvquAkT9TpbFxYWx020lX2v/phtifLVsnoPFJkLJ4ZqaE
	3pgRqyI7PLsQRr411sHG3tilhfJzZbKI=
X-Received: by 2002:a05:6122:328f:b0:5c2:d4a4:6f3 with SMTP id
 71dfb90a1353d-5c33fa8d4dfmr827696e0c.14.1785241115084; Tue, 28 Jul 2026
 05:18:35 -0700 (PDT)
MIME-Version: 1.0
References: <20260724033435.2573323-1-ridong.chen@linux.dev>
 <20260724033435.2573323-2-ridong.chen@linux.dev> <amdC_-OvG1ZUjmot@tiehlicka>
 <CAGsJ_4w1AFkKOSCZYwRsZYOBxCq_7CQA43jQOiDUyLrjVUmA-w@mail.gmail.com>
 <amhXvAdmDxX71uxd@tiehlicka> <CAGsJ_4xLPpf82CoS=ZNNP6nZoU+k=69oJFL3-YT9zibop78TnA@mail.gmail.com>
 <amiYRZLAMwMjb0fy@tiehlicka>
In-Reply-To: <amiYRZLAMwMjb0fy@tiehlicka>
From: Barry Song <baohua@kernel.org>
Date: Tue, 28 Jul 2026 20:18:22 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4z6sc-iAYSyr9O=WQrO7CX7pXorHai1OfXrySCTeKKeWg@mail.gmail.com>
X-Gm-Features: AUfX_mxQ1uydSiJvPl0pBtnnXS-TxTLq8ZM4Df-FQvhdi4Jf1lXANU8_NBYm7XE
Message-ID: <CAGsJ_4z6sc-iAYSyr9O=WQrO7CX7pXorHai1OfXrySCTeKKeWg@mail.gmail.com>
Subject: Re: [PATCH -v4 1/4] mm/vmscan: fix anon-only reclaim evicting file
 pages when swappiness=max
To: Michal Hocko <mhocko@suse.com>
Cc: Ridong <ridong.chen@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Zhongkun He <hezhongkun.hzk@bytedance.com>, Muchun Song <muchun.song@linux.dev>, 
	Davidlohr Bueso <dave@stgolabs.net>, Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: BEB3D40008
X-Stat-Signature: ky76nw5ups8q4gs7k98srggdadx3o4p6
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785241116-595143
X-HE-Meta: U2FsdGVkX19hFLkd9C7x+F9CISSAXeqKLFse4Kx27iNblkrFG304e9QjXUG6eOg3Ib88Fx4YS5BXDkclHEpDtkpJdsjnoKpOuAV3oiqJ+E7XZctlQEhpNYdrdVwEGqTYKdvSYAR84h+z+yjPWHzawvr25Wd74+c8eibTe+ZgKxjLoVZaZ7Ul4JjNSmbwnYXVzqtJc/LUq5/LyPIid2a4FlZ53kXsZUaa9EF4jq62BrQoAu7uV1bBEavfpvuLBGYtuk8rR+TtKEjEEr2ZU7Igpczhep2gdnadzoCwSLHCKbmpiZiGxpYD8qJgC9Cuj2aKbWrTsaiGI2sw9x0Lt+2zSSNjqdEXFeU+Zl84xoo01YlkOEZqaf8bML01ITEokkRlMyLFRZ/sHioXQ73fHKWHmnHFCfAf5NhgO/euEexLvYD1IUTEyeWTIgC5YuhYAz4stW+AzMjgF2F/EarJJhWErT6gOIbH4LE3/vLkWQ4XcVMNjI1xzPqwDVelkt51+LhZn7JESglZt9MR9kTuoD1WRaI1XFXUKTjMngRfJPmPFIwHvGATNq3pCyT5Z/jQS5YIZcOLQPcG/ZfqVS8qlaovvwiN9Szx0uskw5i24Q+XS7lPJcrCTRHt9hWuYKvnZaCvlbZgshpfODD7yJdzDWg2eiRlBlZvP3ZV4AwKAWAyKGpH6AVXrxk1QRlno+f15bWujsp0UMYYyPa2GtPUVe1Pr2ogjlc7MCbtaj6UTmj44ny0G81z0hKtBV+xpDr8HByeLzk/bumCNHl0QQjdWa8VBR8F/aaqaA0YUSTnZ7eF7wJviF9NwW9/aPvxmpTixyEHJA9z6DW0vknIERD/0sVp2vzMCJzm5FSRspzL18r1FDo8s5SPWrC19iM0sZi9R5oSMessaSbme2vrZESCb6PcF2MaeIkMwteaRPROrBMBMkKEtPfw7numVaZCnS2jP799lF671mbnISZYgQyZugi
 Eux+kdiJ
 MOR+suIpFAw516Icmjvhl+YoLIwGLj2R387ttzTdAY81OST5HrvscNaxU7PEnTdlmpPrzPc4wFjlzkGrmntrt00At/V+sUAufg3jQwNwnmPByx3zbSub+MsIzq6XlJRxrQivDxpPBdQDloldu77gcMayejB8AHwuiL4W9YBBsFjsNX1tgsc6DeGHa4AfqHadHyspelCMZDgI2r1MFbLRYV/WYmT8yTH0e+8osdisLx4I3+S+n4gxOk6HGsjqb23HfzQi5pMWbNX4M9RBPvf1bE2MEyZs1gAjTiHGiNolN2fFO0xDUQZGuJxF7Hu3zbyE0u8ire+GCbU3t5Ee93t+AS7R2pPe/2zBvD3KmQbcf0s0pmhJCYA5gLz5amg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 7:53=E2=80=AFPM Michal Hocko <mhocko@suse.com> wrot=
e:
>
> On Tue 28-07-26 18:03:24, Barry Song wrote:
> [...]
> > I understand your point. I just find
> >
> >     if (swappiness =3D=3D SWAPPINESS_ANON_ONLY && sc->proactive)
> >
> > a bit odd, since `swappiness =3D=3D SWAPPINESS_ANON_ONLY`
> > already implies `sc->proactive`.
>
> It does so very implicitely and you need to look around to learn about
> that. That is my biggest concen here. WARN on is just a very poor
> annotation to remind us about that assumption.
>
> I would much rather have get_scan_count more self explanatory as it is
> quite heavy already.

OK. The only thing that surprises me is that this seems to
leave open the possibility that
`swappiness =3D=3D SWAPPINESS_ANON_ONLY && !sc->proactive`
is legal. Otherwise, I am fine with it.

If we decide to make this change, it seems we need to do the
same thing in patch 4 as well:

https://lore.kernel.org/linux-mm/20260724033435.2573323-5-ridong.chen@linux=
.dev/

Best Regards
Barry

