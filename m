Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1047E10A3D80
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 12:06:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45B736B0005; Thu, 26 Mar 2026 08:06:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40C226B0089; Thu, 26 Mar 2026 08:06:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FAB36B0092; Thu, 26 Mar 2026 08:06:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1B0A66B0005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:06:54 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8E995160D16
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 12:06:53 +0000 (UTC)
X-FDA: 84588087906.22.27DA58A
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8EB511C000B
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 12:06:51 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sPmDsN4B;
	spf=pass (imf20.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774526811;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UCPMWIti4WpvFBx+uoiLacb08LQC6AbfsXQqCnT6+V4=;
	b=34zLFPYoW+939HQdDFZiByol4I957gUHJKW6rTJvv6EIOV57fRaMymQuFDP2efpdtiT1RC
	zHrxOxxZOrGw6Qf3cA6ZvuhTZiB/80uer+zBwmS15aOmk88iZFFYKNJSxYbQvCZwoQQso2
	yPGebaEwqAYYbAUUwlAhY7Z+IE5eabY=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sPmDsN4B;
	spf=pass (imf20.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774526811; a=rsa-sha256;
	cv=pass;
	b=j0PWMui9POmSDxktYqsUvJEabBRT3ZPtUaZ31S1wr07vCDw+T4p1KUT1tLJ6XnNI52PJWb
	ixoogI66iooaNo+lQS/bKj0JrlPa0869DJoZ9EypDF7PKTm39WzYGeBUMmJJeS81d416fl
	wkoXwmhic25AME9MOXV8b34z/n8wcEE=
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-66970715adbso1722117a12.3
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 05:06:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774526810; cv=none;
        d=google.com; s=arc-20240605;
        b=GVvb1PNYutxhzWnvAGIvoPk2dNayNW4n0fachINMme05pB94kq43WxKX8kYgg8z6UR
         26kxcdXu/QxhA5rhxNtF4MHpXIqXseTItAU12EbPl2hOZekkoiUNPYXPgSK5yNYAtXB6
         O8FEH7SGbi9nal9zjB/2VBItpPz9ZWQod/sdsNO0Ivjcrjnr1lmiIftOqBckxbpEptSe
         oOi1o7JGrW3tp/jngFVwQ4rRmQYqgJ6i2IEQeeq16VU95W3n8emcNvr6spXMtDBQmViV
         OJ/dOOYCwoEaOPPlfIgCv06Xk8UHS4cfq9LQAKeqSm4NM3uxcuY37O6ec9P7Ogqt13Ia
         q15g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=UCPMWIti4WpvFBx+uoiLacb08LQC6AbfsXQqCnT6+V4=;
        fh=8W9K4V1ibD8QHntMYBsiJ6a5VjLn73KS/JnwMcKkYQ4=;
        b=gzquLtE4JVvUnlPHgu5vrK2QJ0K0N3MqBm9sVAdr9FIt4h1fATSl4Wd9VzX9HrTqNY
         pqFFUKN4QSRrvt7hUIx+SbDQYG90sax4Iuy3V1y7BaivLk2/VuYpl9vLyIvg9BMtBShW
         7dnDL1dHz2dtclI4B05qKFouCC7EFbCbE/AnnpbfbAhXXtBuWXBfdx1jueOxD4S9fhqZ
         8X0VeoND0GlKHZHyspcT2vumQuxvrAFwtCzdgZTxOoILhvwvlS0gXa6YN3O+oayVeicV
         A37TPpe23ZbTH5dNtu/FztfjtZotO0ZAf4EKnlTSNElp+AKrqFbvTJOnkNdGPCx1rto3
         NkkQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774526810; x=1775131610; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UCPMWIti4WpvFBx+uoiLacb08LQC6AbfsXQqCnT6+V4=;
        b=sPmDsN4BICzz29X+l2CG26BxuFAjyiz5IGJwMBrzbLAwoHNCJ3rXqWOtRErLWiwhjo
         +N+wSgxibtnyU6iRGTdwYs9wTxDgA1pnvy8R/a3F5/6d/TOpydgrCszcVGX6CaN9l4tB
         xKoIrEURW1EFYAetlb9zoVJ7ApSjz8CZE0Fw54f7hLQ97MzH51oLbp6Z6GEbQy9AMQ1i
         FeVWWxVAf819TbyqO3TVxBPjevSM/WfxokUrQ74jmoOPnpkp03PiAtij7/H8VkQNBpnS
         1z/UxYH/kVJy/JaYGPx5RAbDQw1cGFeZ65A6cqDWUncuNngrCDBB8M2sWeOWwGJFqCQI
         rRRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774526810; x=1775131610;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UCPMWIti4WpvFBx+uoiLacb08LQC6AbfsXQqCnT6+V4=;
        b=hdcGg5C3l08PhjuEZ4ZSMq9WYOQCpHKxEUAkIQPHdotfznucnquYfgIAvXWrXLpgqc
         U8WoxSvGFLZuxnCYfnG/aTk1mNKMKJQDLDS9UfbfraTxocMxmihqGOhGe+VmwDKNQTzO
         +lcQc6l1BuyTVBWIE7PR3axplLxx7M8263M24DVlL0DhnnrzrJEK3xJGGEzfh0CfUVx6
         BGnIDNnKJEdcoiYly61TzkEQw8nIBbV7WarGnHlS+GAUo09MjnGlUR6RMW2A+PQ7dlIj
         /8hfFn9BsNsNLX6mkU7ui/9hRXaynj40AIf4RlCkfxdaJ1i6lH8gcQ+7RW+G0TCpJqCJ
         +0WA==
X-Forwarded-Encrypted: i=1; AJvYcCXWVdJXNDz/ZAk5kjvz/slSkia97B3BX7+ZWPdIUA42yAo39s2Ukny45jcmQfbZi2CP62MApPzG6g==@kvack.org
X-Gm-Message-State: AOJu0YxRnHVhELnCFcHUvztuS6Qg3C5CN1OtbNyqr3ogDatNvtsrGFaI
	Gcscm3cZIg4z54jnfTNsorLwGzp6sE434QfhmMSmqvtvOn8lNMcDnW3LOlyO4Se0IuJmbf19lI8
	gFgkCX9eCpCvtUPHf6txI2ek85H09TnQ=
X-Gm-Gg: ATEYQzyG0OWdJxZPVQElkOc64WDpKJPXE+xRQTuEgcKIqqDgFI2K/vmbUGWZqoS1fyb
	XV/2odXMOGlqcU/Nv/qncSUZhXhMQmH7XbwbAk8UX2UAkF1J7kiUZw54djGkHKy973sSJdRQCmf
	+ET3Ya7POUMeayPFPPAdZhK6JrQ/2JVBcqhoUEuF75nnMErHeclw+4YtjwPtUmqFTvBr9hwpzZh
	4ZwJJZPchsz3xJdQ7vZ0sAkRP8o1WAcN5YciRXExT1LMsfnj5y9oGK4pek1FI2y3bMcR9dogLtP
	NJjVolY1/ca/KCLgltaNhj4rpMNfmtaa0h8JEdGO
X-Received: by 2002:a05:6402:400f:b0:665:33eb:22fe with SMTP id
 4fb4d7f45d1cf-66a82622bc2mr5320318a12.9.1774526809603; Thu, 26 Mar 2026
 05:06:49 -0700 (PDT)
MIME-Version: 1.0
References: <20260325210637.3704220-1-shakeel.butt@linux.dev> <20260325190547.abb7309fb63473b57b7a90a0@linux-foundation.org>
In-Reply-To: <20260325190547.abb7309fb63473b57b7a90a0@linux-foundation.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Thu, 26 Mar 2026 20:06:13 +0800
X-Gm-Features: AQROBzCNij5ZIZYiccbOybvn12nUAvCYLf33aTbpussW3sa2ckcJHvGDC3YLdQo
Message-ID: <CAMgjq7A01C+wyHxytZfVFVvaJ+gUNqkKvYN61_Peo911YaBHOw@mail.gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] Towards Unified and Extensible Memory Reclaim (reclaim_ext)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, lsf-pc@lists.linux-foundation.org, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	Chen Ridong <chenridong@huaweicloud.com>, Emil Tsalapatis <emil@etsalapatis.com>, 
	Alexei Starovoitov <ast@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Matthew Wilcox <willy@infradead.org>, Nhat Pham <nphamcs@gmail.com>, 
	Gregory Price <gourry@gourry.net>, Barry Song <21cnbao@gmail.com>, 
	David Stevens <stevensd@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
	David Rientjes <rientjes@google.com>, Kalesh Singh <kaleshsingh@google.com>, 
	wangzicheng <wangzicheng@honor.com>, "T . J . Mercier" <tjmercier@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Suren Baghdasaryan <surenb@google.com>, 
	Meta kernel team <kernel-team@meta.com>, bpf@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8EB511C000B
X-Stat-Signature: 65asrwo5pie8dhjw4jfkpnkoepfbgyeo
X-Rspam-User: 
X-HE-Tag: 1774526811-768694
X-HE-Meta: U2FsdGVkX1+T3Cam7/XT7zK9AFQ5PGf530s3ePHQWs+4iTcp2sVkoSN9DiwdAVkgaMgn+OUcdqOn9ne47OUl6OFNsxrgoNRN4F3xEva+8gvyprzvK3gCvJ0+w9k1fVhPKSdFYzlITg0akdCl2jGnttC/pDGrpXhuG179s8Y4gXmhpqGOdOQ2Al/FSrLW2bwRcn00m+LD/IwsNP/O4yhxfVQtOAg8tQ4pLvqTx6hhXnXUOvrhQ8LuEKXqvtVX8OlG35ij76iXX25e0nqL/yweh0X6wqytzrr37JvBeVf+R1YIjC3PnG6LO1xhsdvCa4EUCQLiH4FECN6Mp9CLKbaKGSO2PQ0LQktccNgQOHIACB0+XPXcT5hzHtUmgz0ErffaAN67GtEarJQO3DJNwQEq611RzN7aJJrf/0njqbKwgYrfq56iq+/Mo5Ac0BiqKrKH9Gdo/fxS8ZJRGgWeW+0bt8/lQZGfU83hiSS+W+EaeR8BJRSDDDEq8qHtxSbFGkNop5B2D1TXNWsek7aqyAqzvMg1pUrw4J3B89QBrbZndHtGgFqkskrzxeyTnsuxxn04gqa5xJjRVUaLbilTcsNdSJQyqM+Eb8Q36XW5kJ1X7CG/H5OEkAJj3OeUj4BaDP9QK1SeUbc2c1I5jCwN56x6qCNDlMu5Pnpwi2aR+O5Rb3q0ahXT0YXweocS53vAdJB8gAdoi/0UtVhMjHGbgKlyUP6sg9O6xCrVC0LI5kCYiFrKRZcqNvGzRVYwTKnVbmMUVaHQirTGlFcQpiKby9i7pJJ2MmK4soNoG1oKMmaBGJkbPHpif61bNgfG/jCiJEqYJ9lFNd3b5JIEIBBdE1z0umnozVssu2O2YCVn+VKSfrjtMIuJC06CXiMfUzBN93Le4w0HvJ+x3gtlupiTvLmuyBWSEHrq+sB9AO/XetQfKI5/AwR703p34M3/URPa1ika5ow3ZPyoy+px9iQaYsA
 Cq95Up0v
 wDIwg8IXdk1I9R9PCPNm8JM7jE1pdaJZE+tzSdm0K26TMLHWVn0tN4xkeyrOtnZvBXjHUlS2pGBwDgq5SKGRhM+1fmcgzlrF9Wy5Zd+KEAjcE4P/KrOl6u5jSQ5UIxcNfYGVBzJAQ9B3ImZ2MmH6vlNx9V1f049GrlGHj+Gdx8xMxaq0LrOdzyAyZYrkahP5ubVtYMsm3TMWkR5SHJRWUJgq6ktWChw18l63asbuX61JQqRInaCEgGD8SStLaDyHCxVtw6XPQmcoFLhW5GWK9gFoVzjyQJU64kBidk/DxBPeiDQQhqdH5XjtcXcVhXrO/cSnJCPX4/HJAxR6v7Abldcmfcez5XSUcDmV8QkJqgvE7bt/CCxMFwJrcMEdDbv/OIUMHrH6wb78GpLrJ+aIkz9fyGUpyKKozB2QGfktbaRzkv0MFBTAPlIqj1NETfQlu0gn43hMZrLhy65e4H7tnaR4hHP3VaLQ7n16FSpdzIiXba6BulrK3FJwq9GTTLELPCkz/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 10:05=E2=80=AFAM Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> On Wed, 25 Mar 2026 14:06:37 -0700 Shakeel Butt <shakeel.butt@linux.dev> =
wrote:
>
> > We should unify both algorithms into a single code path.
>
> I'm here to ask the questions which others fear will sound dumb.
>
> Is it indeed the plan to maintain both implementations?  I thought the
> long-term ambition was to knock MGLRU into shape and to drop the legacy L=
RU?

I personally also agree on that, so far I'm not aware of any major
issues with MGLRU except some corner cases that are not hard to fix.
Once these are done, I don't see the need for more complexity.


> And that Linus has expressed such a desire, but my googling fails me.

