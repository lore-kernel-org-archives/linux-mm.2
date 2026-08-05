Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98548C55838
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 01:57:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B3AD6B007B; Tue,  4 Aug 2026 21:57:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 564F26B0088; Tue,  4 Aug 2026 21:57:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47BCA6B008A; Tue,  4 Aug 2026 21:57:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0C3C26B007B
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 21:57:33 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6E97512034A
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 01:57:32 +0000 (UTC)
X-FDA: 85065553944.17.FB6DD8D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id A1E9980002
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 01:57:30 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D3sdPpss;
	spf=pass (imf02.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785895050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vhpo8WAb4qS8HAtx6Ol60QMw0aUMNT0+Bwtejd7/JX0=;
	b=u8NtGLeIbZKSVrV116flmFTIRpBBH6DKdhZ1npUVLLQVN5szMjPGRyeHggphuggPgYPe48
	hOyqAZwlA1p4d8SJATKMcIIhoOu/Ayn8TfMOzL9NO89KBZiYoNuwH8hoPxt+IWw/GrgUCu
	8kctbAo2EHqo6NhMGgMcDuRDegGc7Dw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785895050;
	b=JG/HoM+I+WxvzDGBK5xJTouDqGN6/3LnFE1RTcUZ24EuOXRr3R/IQGMGis+d/8UU6LcVG2
	Jgew9tAmqMXinrv+Ftry7MoehBLGvOqygQLXV6sGfhu/hep5BehErWOD/WXACbSLeP77YT
	v7RlHX0sNbKCdc/RWWzw2xmIwep39lk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D3sdPpss;
	spf=pass (imf02.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E06EC600B1
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 01:57:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98B731F000E9
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 01:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785895049;
	bh=vhpo8WAb4qS8HAtx6Ol60QMw0aUMNT0+Bwtejd7/JX0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=D3sdPpssKigphxuMAp7Ms+SR32J6IDyGFLXudSt7PiRM2VGz6+PCMmt/Y7Tuo4fms
	 G9MZW9JzCe50FoR76siD1E0csarDzAZ9dzvTmfKLHUy8LS5at8xOmCxCbz3TnULeL7
	 vh6TB+I8EtfmQzrkcr3WQPbkARAOTw9F7YruvTckVfL+ZgYOET5Px3Pu0pSpSTWWcY
	 GGKpXqpUaRvOYHARxXuJUvfNEO2nMIlra0qOkz0w5JMgUAMDcCdR6dvdgMarTqpD4A
	 5lUyeigzzH0CZ9v6OpBvzO3+q21jkrN4pDgBYtJwAAUStzPknjsK6qJyugmnKa+fgK
	 lgCg+IyHr5NYQ==
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-934a3d14924so48985485a.2
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 18:57:29 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RowQrrZNi9ZBMxpZwxkrPl4QgzlOdkdKDi64POsBGZYiWAKwbBGzycx0NXI8BxNmf59yuXu4hFnYg==@kvack.org
X-Gm-Message-State: AOJu0YyHXv/Gfw8tVaUPiMK+OKb35+t3zsUd/lZ7TwPctUgEuvASHlzR
	y4m8IQlGYNTNzBw5mQFbUkSDNqytnfJm85II88rdUklDiy4S7WALlwRj490jnIazh+G+QEFnd0B
	qV4hRJo3GkpjY/4ogxxjyKOVukUk9x4k=
X-Received: by 2002:a05:620a:a01b:b0:930:9fdd:bb5e with SMTP id
 af79cd13be357-936492d8a89mr237103685a.46.1785895049037; Tue, 04 Aug 2026
 18:57:29 -0700 (PDT)
MIME-Version: 1.0
References: <20260805005545.66112-1-baohua@kernel.org> <anKQ_qZ1-Q6FchZ9@google.com>
In-Reply-To: <anKQ_qZ1-Q6FchZ9@google.com>
From: Barry Song <baohua@kernel.org>
Date: Wed, 5 Aug 2026 09:57:17 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wD+KNL0yMkuS4GijbHaiyPxgTmqKzkr0DErC0XH30w4A@mail.gmail.com>
X-Gm-Features: AUfX_mwe4XzlWwxtlA_67GqLYJwoND_XGHQJkYoV-tu0AElFJ2FY3XpCGlmgP1E
Message-ID: <CAGsJ_4wD+KNL0yMkuS4GijbHaiyPxgTmqKzkr0DErC0XH30w4A@mail.gmail.com>
Subject: Re: [RFC PATCH] zram: avoid preemption with CPU-based compression backends
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: akpm@linux-foundation.org, bigeasy@linutronix.de, hdanton@sina.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, minchan@kernel.org, 
	ryncsn@gmail.com, yosry.ahmed@linux.dev, surenb@google.com, 
	Dongdong Zhang <zhangdongdong5@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A1E9980002
X-Stat-Signature: cb6qbe1d4ezur35fdqszhzpgwxi4ig8e
X-Rspam-User: 
X-HE-Tag: 1785895050-514734
X-HE-Meta: U2FsdGVkX1/CnIm2DWDl5Eyf8G8AQ9Zb8inkA69WE2HfNInZ6pAmYgkhqZ9dthT0HVWZleN4AwbktdnydTPwHiIXrcmGhVOI2nP+5Gg1b9Cm7GgwSCMwFcYjEf8+xyWFrBXfxMiltduZ8BGrxBlnR6fVULWB+D1A+/Chahx1g8Hpce9/qykPTJnsh92sDpfGxR5C+8FU+TnLN0EFtmJUEQVWu319BQzvLQ0U9s2sO4wEG0ZXu88dyn8ylmIKTfcujtMzUMigH4EmYGie2mbAusJ0B2fMQSACh0x1FDhtlAWt9eFH3Jq2obXqJ4VYhZN245+6z7gRX6kRR9PRzx+SK7WgBkoQBZZDuQhyulKt45Qd9DFasK6xll1hcvDhY4KABEACeMsRnZMgKBq/n1L+/3u9+k14q8a2fOgTUIL9AWWgUPlrwEZNRpv6mRJcNRwvsIyOau3iPuP8CCcmcR6OsLkPNlqIsTttzTB4lbDNS1GCd690AyAFxAPoT5xYHEBbhXJawSeFF7o4EhNGC7wXmt56x4TJ2Kxuz/28ssabYdG3ffgtoz8//w8thpZYGI4YZUe3aShTiLTGaI6LG6dKIwfcROYEXiG8yeI91hyY1eusJq8IzNXM/wuIAejzopY1muJkd3JyckiHdmZ/tE8vqAIbEVV1FHxqyzbfNQ/3Rspu/IAGRWjtFdN6yOVXp4vbeoJ17qGA8pRJBqbGGwjlJaPy/kgoYQED0l14QI7Ya6NCea/haezvhTfKAKJilMPH9UIDPl3Yz1pMzXng0lBQVT0+qO0xs17r+CqcwvYJNIsos/2VkpACDYdYkFnGxfqmdw69lhdfAtGYCwA/gkSRUkL+pPZ1GnqauEVVv7AaO7w2P1ISQzgOUj6c0K6mz4BSG6aO176RQgVLxvBz/Ykq4wcJcADlVI4Igd+tlsHYk8Cd8hc4K6UTSi06Ycu6LITDgXYFnaNqOSA194GJH71
 s09ljvCB
 K2mvrv1V/ZvtvehX9tX1a1SmtmRW94mF5oQ38UkTmwitOyLeo8a2GaG4I3nxF8gw6ho8hMWzQIFx7/R+PW4lELvfHQ9QU84nEDo9R1KiHS6ad8vORk5IhSq6FdWxu4APkvf1y2Qm+HSDGm56N3iYX58ubYVG3W5z/WrHT7o1JpZQMsyI0cGK6bHIH9it1Xj5Jxm+J1F+pPV4Gb2FkIYTy5hamT389Ad30QycifAGVfaKhuvfwAN1++se5It+IHXCI/ZwzDhL9i4nlLzaJEZOiRDoIezac4eFZ9o+SAVQ9vI3420F2cQNnYMDF0Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 5, 2026 at 9:27=E2=80=AFAM Sergey Senozhatsky
<senozhatsky@chromium.org> wrote:
>
> On (26/08/05 08:55), Barry Song (Xiaomi) wrote:
> > Since commit 2efa9e9eb4db ("zram: permit preemption with active
> > compression stream"), a major Android regression has been reported.
> >
> > The reason is that compression/decompression is now sleepable and
> > preemptible. This means a stream may be migrated to another CPU or
> > be preempted while holding the stream mutex. As a result, high
> > priority UI threads may get stuck waiting for the mutex during swap-in.
> [..]
> > We add an async flag (currently false for almost all backends) to
> > indicate whether a backend is asynchronous. For synchronous
> > backends, we use preempt_disable() in the !PREEMPT_RT case. A
>
> I wonder what does that report say.  Is that what I think it is
> (we discussed something RT related privately recently)?

This report shows that the zram mutex has become the top lock
contributing to UI frame drops, even surpassing mmap_lock, which we
are also addressing in multiple threads. :-)

Locally, we have reverted the patch, but for upstream we still need
to find a proper solution.

