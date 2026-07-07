Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97A9DC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 21:25:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A29B6B009D; Tue,  7 Jul 2026 17:25:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3532E6B009E; Tue,  7 Jul 2026 17:25:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 242D36B009F; Tue,  7 Jul 2026 17:25:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E1B0E6B009D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 17:25:44 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 555811205AF
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 21:25:44 +0000 (UTC)
X-FDA: 84963262608.04.68494E6
Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	by imf30.hostedemail.com (Postfix) with ESMTP id 770E980007
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 21:25:42 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mIKhXAr0;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf30.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.208.170 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783459542;
	b=aPdCR8z2F7TikFEob/d5ly0M8DzFN0KZQbN+aekXVOSCnVbbWWDXlmopmAx4QhOhRGggvI
	uroMGByUS7iw1fj5kpFkKljpSIp5pIG0yNlUz/vDANoDgpmI8JCfL4jd/OnoFFW6hino+e
	CBa6zkVa+AqCqpFWUMUgDjgqG+arXcw=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mIKhXAr0;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf30.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.208.170 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783459542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MVG83Yg/WR15c0IzeR/gjd9WQx0PwVPcmwJbfXK0tLM=;
	b=kcxTj31FHXBHgtJFrSXjbC7Te1j0sWbdfUUw3xZIohWQqQzvl5Vf0iTtuhruBDBltC+waZ
	9oyEg1Lg2yJxmzgXGErqSGeJbbRo5bW84FPMOib1wvMXXG5ie0iKdTCeFtV7k6YwupQRxd
	7KoUPvEBws+H0qK2PY0SeT6GjFl8BIo=
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-39b2be45e8cso108111fa.1
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 14:25:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783459541; cv=none;
        d=google.com; s=arc-20260327;
        b=jeRvArzP4SPAWWBd+lKOq0fk7ivMUAOklGJoCsXAbRdVjo3YdaBHH2rtuhpVDud8Zc
         SBbE7Uq3cDOI6YMlY3/4fxmyxhPyVtIJ9uQCUD4vAAD5Xby7I1VnF8Ja37YVTASQYrvr
         iHtGqFGoeMrZeG+IZTnmxcQidPz08rb1XziFuE27jkKnmpyk95dJFPFyAg3FfYUeF+7z
         DYtKMms5B3ZlpvB9+0WdjqNGYCjw1D0VavJLgsqZnSxEHy3TJZNDPCTpjvYlru6tWC4q
         l8edTYir4JGvg7PoEpv6QpclJy/8TsNTQg5YEjoZ42jBRye6Dzoac6gYgUaF14Zolav3
         U41w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=MVG83Yg/WR15c0IzeR/gjd9WQx0PwVPcmwJbfXK0tLM=;
        fh=vaecG6QtO6r12GzAj38pAxqRjsWQrAnjzLyMhvd9eFw=;
        b=Pn+bd//eB0TTyEPY2kJf3vCn4fkOiCy4/CBUTz/oq8pyvodVx7R0ONzZwBP73Yd7p0
         ckaFW9aIZFu1B0NY2A883K+Bcb4h6zRi9kiPyPdSOGdZd8y5rUDyr2vG3QzuuDfVLymv
         A9ahdK+BwynB43C+IDv5iLvIjCmYlHHoVUFY9EgvKRsIQ+eHtmjpZAYGdczrNWCxaXOG
         00EczLjU0tzx44yOz017ddjnfzoSBkkxANVqQ39VMOl0mOvX/WkT90c05ZVKSJQcU+KZ
         GV71eZRPGXvm1H9eh2XyOQcJ0Cm68jPyNH5laDDlXnM9OHM89SuxQXXmoUaL/Bmx9594
         ZhgQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783459541; x=1784064341; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MVG83Yg/WR15c0IzeR/gjd9WQx0PwVPcmwJbfXK0tLM=;
        b=mIKhXAr0F+WtHlciWohNgkT2J80nCYqZ/v+2a22Vb7VIaQ7uH1/wwXAyUrvPlaIwwY
         TTeGDNsIZWylxnlVaSAWxMXznDf16y8eASWCgB4mxnwTfp3bygoeG+boKSqV5jl7XEuQ
         w093YIXQXM834N0cM39PymUkBh8QWDAv/Qf0dzjHZpxAnmXl1kHSh4qx0iRTYfEHzuNy
         +f26279J1lHFMYB0ywH4vqSQ+Oc/LpFKDjyztbvfGGN8i3xoHkl4oARN9VhwF+n2a/gy
         cEIvbyJzZchOyR5avB/4o9NWaFVGCWVchIiy4tM6appa6mA4k2ZqJT6kLSwl9zwEgqRD
         0YNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783459541; x=1784064341;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MVG83Yg/WR15c0IzeR/gjd9WQx0PwVPcmwJbfXK0tLM=;
        b=CjsB0K9uKrYTPQC0kzQJGSmfA/U3fhVuTLEsNWiz5PDLcK3A9xLb6ad7QxnqvBI71T
         Bnoh9gVnyI4fS9J/+O99T8Zt9Nz+BL6AQthGyE/7NE2dwPqUdNrVTBesN2tyJqz/No7P
         BhNRtj+F/PO6l+SqEBtOUtuH5I0hzQ+besxzEXM5NJx7PygXEpd3Nf/lu1kwGUicuBGV
         OfPIdxR2YkLj4eanL8GpdDPKTEW64RUwYmHSyYLM64/uHhkBiAXJUFRVJrDVJciHgcsh
         WqZYw4cTz6td67F9u5jEE5t/SNKoPLK1NZSzHJCQ8EjXPiEqzHnQ/wfEB29HwCIA4xLw
         /3/g==
X-Gm-Message-State: AOJu0YyBctlxW/zcEIc6oVwVmjrTC/Dtq2WfGcQjdXEqZL/tFCCy0ryD
	El+6iwxrvYKcf5pLR7cJ3ISDBmFhsfQg+SbVe+Q2s6CGBnQr2QGt9KLvlzyF5C6mbDh9o9HOlB8
	M04oQBoWA8bYg/zgkCASGI4KHGqDjIEY=
X-Gm-Gg: AfdE7ckoVNCd7Jx5ip/vW9kDAmILHAvBAAVSRlQlwagA8oxxVfEsp37iC1H9jKegIbu
	xBy4u/RFlchfGKXcWJrq+siGyNLe0ss0uMq4NT0iOzDikrmMlSEzy+U5RyVDKQIJL4o/GQIWc9n
	i5LtBiFth0phvGzy2EdfEK2XchVu1pl2OU36u5HG9JNZ4A6ZrQdckWP62Bb8Sa7fqsl+QovnUK5
	LoQkS1zxr/ZFut81MnEiYELWrivXjzUQL8VwxKExMJIL9s+H+1krzedSZM7H4PF1VFKlbTO5zxH
	kbr1Kzfdkx7/dLryt/JHEZefXVhr
X-Received: by 2002:a2e:a106:0:b0:39c:6e2c:23c3 with SMTP id
 38308e7fff4ca-39c6e2c2709mr8695601fa.5.1783459540765; Tue, 07 Jul 2026
 14:25:40 -0700 (PDT)
MIME-Version: 1.0
References: <20260707082614.95030-1-baoquan.he@linux.dev> <CAKEwX=P50av2rfocpsqZoDQowZ=EEhQ-5vj5tBykbNz8vtKTzA@mail.gmail.com>
In-Reply-To: <CAKEwX=P50av2rfocpsqZoDQowZ=EEhQ-5vj5tBykbNz8vtKTzA@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 7 Jul 2026 14:25:28 -0700
X-Gm-Features: AVVi8CcXjv7p7ZCbUVLsHwIpf2zCyu9QN1t4YYJpvdS9LUSp_0UUsce5Ho5rzRI
Message-ID: <CAKEwX=NjQd=_PUx1jrHk6tEabiU3WTL7-cGiGdYQpkUahtZ74w@mail.gmail.com>
Subject: Re: [RFC PATCH 00/10] mm/swap: ghost swapfile with backend switching
 via Redirect entries
To: Baoquan He <baoquan.he@linux.dev>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org, 
	kasong@tencent.com, shikemeng@huaweicloud.com, baohua@kernel.org, 
	youngjun.park@lge.com, hannes@cmpxchg.org, yosry@kernel.org, 
	chengming.zhou@linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 770E980007
X-Rspam-User: 
X-Stat-Signature: 4ixn857k91xr4q9sftn6pu33oozyhsxt
X-Rspamd-Server: rspam03
X-HE-Tag: 1783459542-690715
X-HE-Meta: U2FsdGVkX1+FTHmyzFBk+RCrh7FXpEzCN4Lp+hVWoWcdTIhOpczaGs7BdI1z7Xmz0dVCaJEbBSNvqalC04TaM63Rc0Whw1yl4qvHZ1UsLQeRDGCL+VF75oIWixeJtv2VsN59qtwA8xsltP5Sb4ljMF0P+62xxE6ukTxPTr6RX7FfVe/UuJezHV/SmZ9GoQRBlDb+nDGLik6EI69Osn1YgeA5kv681RfJur053tvzv3TpT1m56F4zmV104ONagNQSlXIprMAeR4s+kV18LfNGNtb1yYOhxhslkUaML2yuolUlgFc20uWxQHaRWWKTlJFTfO3RgMaLSBV/t3CtwtLIehpKnAl/iNC1SYgYFohdLRc0tciKO32ymIXRpES35lui23OjRiZzHekwRivStfMkufBfmQCk9m/PbbxUxZKhbXw+UcAykiCfKFlmAJ9k2YwP2/tg9M5t19xxzPN1t/1iouC4omFlfH+AtRo5gAUkaIZg6OobzLRsgIwDDZFmywdC/77O6N8FcEKmz0bw2vDAiUJkTcLU98AQZ0kAVZhDYC+vQRE5ycBHBaI/JZfaZ8B5YUMRnHRMMczUPnbsbV72BAJ3u58vLtAA+BcOPPYTocE1Q+Asq5a20cSL4x/4vW+lGnK3iOTNI1A61qxzyF7tmK4Dl/jOs53+qLHSyiT4Tgev3l8Cik2AtmIdsqjeMG7lfumrHoxUxnhokAxYkDw6oU2TseIwV8r9+d+4kY1pzxk1NGW8tCD3KYuHdQdoR7xGNrWC5WxabflfNg29Pnhb59Im6hG5CEqZ3IPGrao58TAeUJ5Hr6DDUsZpI0v/1OeZtkY/xpxcxRrAq2ky4OIW2mpE9bnZXzthMVwV7Ex6JIvCU5Ei3dZKzEEawJSBMay9IJnkj4KV9Hb99gmBZrnoTgPek975aElbIC+DAyYdfkk6bKCDyyRggEvd3XHuD+80pOBXdWBIS/euSraAag+
 bIKaYV0D
 Qf1LJtFy5ZyCd1uSTZqYjEmpjjJ/kqs9S/Ee2aJ+jR0UnSjeW6I3XEN+1lqJuP+kj2vlbHzg7tJvbp6F2mUuEseODtIdrdIlNoH3zFbT7ALXow1OdmiQjRYve74f5WK/KbYPgRT79FnInuDl/xHZcJB9lr2tc62/y+3e5OAmknwIpjRG+LsPTbpzuy4QZR+e2b+2tpnaDpgotry+OWxiS3O5Usm61vQQRaN/ul46xVKnp8lRmZgLUZbHBEognARdMGnQAGCTatfF9t48HabrT419J7LJ4UTmgim0XWopw9fciUDV0Wl92CunPmTzYV2Lbx/bhGJbOpZ0xTBKh6cCJCJqCsSFbD1SrAQL8trEMRe4Dlcq8XU6kgchvb69fNaZtB/D2AZIq+QjI9yxpa18V5MxZK7ubkFqiEzQ7DDuUfztbXJg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 7, 2026 at 2:23=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> wrote:
>
> On Tue, Jul 7, 2026 at 1:26=E2=80=AFAM Baoquan He <baoquan.he@linux.dev> =
wrote:
>
> So it's more complicated, and achieve less - this is specific to
> zswap, whereas what I provide is something generic to swap
> infrastructure, which can be extended for future backends. I would
> understand if it resulted in less overhead (which was the argument for
> my pre-swap-table vswap design), but this seems like it's just virtual
> swap, with similar space overhead (technically a bit worse since you
> added redirect_xa xarray to physical swap cluster too), and with more
> complications?

Actually no - I just realized redirect_xa is global per-swapfile :)
It's not even cluster-partitioned.

