Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FB02E6B26B
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 02:11:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5FA76B0088; Mon, 22 Dec 2025 21:11:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE31F6B0089; Mon, 22 Dec 2025 21:11:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EF8B6B008A; Mon, 22 Dec 2025 21:11:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8FFF76B0088
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 21:11:34 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 41B65140464
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 02:11:34 +0000 (UTC)
X-FDA: 84249109308.04.1ECBC8D
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	by imf12.hostedemail.com (Postfix) with ESMTP id 539BB40005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 02:11:32 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Le/J8Wcs";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766455892; a=rsa-sha256;
	cv=none;
	b=ENdilYpDkZPWLiCw8Vg51ldPrwdBpUgLL7n4utRBznAwXcoyg8lBswFFDuMrhvHp6fZBeV
	fAgK1eFUBJHXHWTyb33Lk0nQ8a5V0njb3rH1gdt3HHmD7awiRoNMmmO/IfEgerndkjxUe4
	6xNp/Awe4lrQKposPXKX1TcliSFN8Qk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Le/J8Wcs";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766455892;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h6XfH/unjs2YY5vH7P9rUbisIadizeaMLvKYvXY7Qxc=;
	b=xrFsQK7Gs0PLxKWH29dCqz7X23i1sCsI4J1lfFfeQWz07b4tTMphpY1mZmEPTm1TYYYbgh
	5xF/qau/SSu2VLyCmiRKHwc/WPSynzy0z2ZEoOadYEnOUbLq1kkjlRM7UDbeCBae3vaXL+
	+Fjc+9OKhtesqmHNi6QMEYLAkuqDS34=
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-42fed090e5fso2127796f8f.1
        for <linux-mm@kvack.org>; Mon, 22 Dec 2025 18:11:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766455891; x=1767060691; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h6XfH/unjs2YY5vH7P9rUbisIadizeaMLvKYvXY7Qxc=;
        b=Le/J8Wcsz8oE6I7sYplqLIrhwPA5z0++Wmt/R4PdSj8D9Zk5EmipNIatzX0ekpu2P6
         I89deBNAkRoGJ8Kujk3z0OKy1tMiUIAuzqbFoR7tnr4A5wx7vsZLyRDIAI9JjOfjWew9
         V/L6OWVKHOheDcUedcKr8QqOKh8ho2M4UUH0gOAZymLgg2wqy/4k/FPaDpkDl/9rG2re
         YmWkNC9u4C71jFjGWXpa4BmJZiRMyceTC4qMcJcN/yC5L+brBOBW6FEarbWypjCQtfb8
         vBXblenl+kZzbW4K3qS5Jl86xM38S2isCcdFOeHOoaJtGxnEHVc1PdJaHNBTgDyFmBJF
         dC8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766455891; x=1767060691;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=h6XfH/unjs2YY5vH7P9rUbisIadizeaMLvKYvXY7Qxc=;
        b=gY9alROyl4W7862KJHEspPIOJRGjzbabWPzBH9M6Dy9MEcJbCLSh8DSTfJASIDvnLE
         U67nfeziToqogMfhzmow32dEfwRnSESDurVO9FMycifV8I33MXHnK47b9XcK0tAdIRyb
         EU5mZoJLs0Uvi8z/kHvvQXuqHh8fDLDlJGSiZ42SI7c6WcJnnEoY+q1GcGipFJ/XTQTl
         sx+chZgA6SV251KlPIRv5I4k2cFvcff5tFz/jTzexW/0+bC/nplae/sqcP+IoGD3LTre
         0fKM6tqphd2AOTlIKvABASKg6qRQ1OkE7rpq1WoV/E8nB+sj9LcHwExmTxNLE4VfbeKU
         38Qg==
X-Forwarded-Encrypted: i=1; AJvYcCUrvRfMRl4cXNFhhKSgj3KWeQtI8kZ8oY8kKZZS5Zdgmij4S4r5bIIaTkBRWAE4cEbokXpociJEyw==@kvack.org
X-Gm-Message-State: AOJu0YyF4Wz0sETGDAorNF54lmIX8NTMtiFOGLRlyfsSoEeDDRrQopIo
	dwPgFPXVaCpwrbIUYIiV6lL2nvVWmR36duGQ3WfhI37cz/0tDdNErDQhQABX/QxkJeSVSyjFJyW
	WPYyb2PqbAVwKgNxt4kiJAEm0sR5/zCg=
X-Gm-Gg: AY/fxX7e6wFnrxqMiDhwCexjvlCvCUxvRukeNvjNBQmmAoRB4qgI7M1ya767oyH+w4s
	RXdvf+TeU/w1SLtkhhHcfKkMiTjxW88iqC7ePLy+p+s1E5ojh/2Rat0CKreHp4yWGQ5YGUXb4X4
	wMZeIGaQ7+6Hs/Wai/TS5zrJVUGILAEkfLblWL4rvXa6F/TK3SbAurxwSYjFXOg6LuQAt2MhfBw
	Ty79le8aESMlVBuChLQ2bbke4oZ/Wtw1151739Ulnlo1H0MF4wgjDkL2S+ZRrFjO2VYoJmP
X-Google-Smtp-Source: AGHT+IF8BfcA5cvU+pxFPwDxmKTdBV/w13ESm1DnzKFgnWkd7KrlYrVdHx+Jn0QifxMjszHNpoYKpr1/f0zvUzcoB7w=
X-Received: by 2002:a5d:588c:0:b0:430:ff81:295d with SMTP id
 ffacd0b85a97d-4324e4f9350mr14068995f8f.41.1766455890563; Mon, 22 Dec 2025
 18:11:30 -0800 (PST)
MIME-Version: 1.0
References: <20251222221754.186191-1-roman.gushchin@linux.dev> <20251222221754.186191-5-roman.gushchin@linux.dev>
In-Reply-To: <20251222221754.186191-5-roman.gushchin@linux.dev>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Mon, 22 Dec 2025 16:11:19 -1000
X-Gm-Features: AQt7F2oG8qKh_LrIImutrfPDVfsQ-CzA11AhccPedSQPp8mFoIFiyOb3CeObrO4
Message-ID: <CAADnVQJ_WLMRXYV5p4Lk2+nxdC01iAaKQhYecMjx4rXdBeXjNw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 4/6] mm: introduce BPF kfuncs to access memcg
 statistics and events
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: bpf <bpf@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, 
	LKML <linux-kernel@vger.kernel.org>, JP Kobryn <inwardvessel@gmail.com>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 539BB40005
X-Stat-Signature: woy8zxr1r3xudxijwfuoj9c9orr6ewjh
X-Rspam-User: 
X-HE-Tag: 1766455892-914414
X-HE-Meta: U2FsdGVkX1/WMD4fThebqj7nqziPmCod7ZZiFOuDXnTZRPp2E1sXzJQv4aokvIs8+FnwTjAIN0PQf+npdyiVW862mPLqwnC+nDt8xveV7SFehLeZ9WVAjnNHcwSMduVEQpuRZ5Jf5Hs+IakWbojAfWqWOf8+C4cmfigbjXlVUsNBSKG7yQhrzuOgjggVUKyI0x9bj+uUV8C+HrZBo1u1scm/NFJ5beOrfq2fEbPRUn+CSm/1vGE40i4yyDodqDoWWMsnoKIGAlUCM+k6wNZQQy6rWLH+Avln6FT/Oozx9g5rHFVFJmn9afr+kcID/0ZwbcK/ealePf//qlWin46dStn5E45EGdHiEANi5dk4VH0z4Q/FC1ayDfi6FNgb6fA8EN4QxG3Sc0UWflLcOijtmrvm20sxkQJAJy/lEMc61Av2N1+TgazchYo7Vr8/aaZk7r+syUIkj7Igrovyq4T8CpFsjSVtpt+2Tiq1NijwvGUfsupv9IdnVSb0AZDai+GKOEDnIm3OGOsocAR4ooG7xr3FXDCh1PDVi0zA/E3SOxwLiEB95CAgIu6FktZ857614uIkQR7dc/g2RFIGhEl5t71mkv7ulANmcjfxfyCh9jtPz3WpEmkWaZFbg7/QAVFTW9Ce9LIIDC5gtjJuhsGZ3vD+AlFOTFxegtmjC0ExMoqdG01bkz7IgoDGEtx9zbKXbPwj5cRHlf5bKu/rpW+N9qQttRRa0K3ovuRCyL9JKlWMj6HROmV0wa32nmwsJnByxDFC8Pqx0+AuAclCMEXg9Uv3jWcEsLZV/dV57PVAp17NSoNtjotvjDkSCYUwebZItXr/JoGP1tFE5UeCLZZa7aB+SSjgzo1XoGudZY5ctHGGyR8XzHvrBW6nkqs2Y/PhA9V+utTN6OoZNj34cD6qPMgRJAQMwFgwITGAr09p5+MBEZemK8nTjDPYM0C0FbVZvGtrfIvYHlc08fPiLz3
 t02fdtjl
 KiEbQHkgfY00aF52SddM9suySq5EdDX3kstBFQCxeuME00X9gGe6zBH7XG8QyUiHDLNUzgBGtJSHbIpMtTvT7giA/WeLvmXWUhOqVxwi51twd0maFcyLStGVtINSh4KoHjdRedMWsG539aawnu4suX8ydg+BL19IiolpZt1RpV/siYf4prTfDoWi/hHwmFbHEDr1NdPW6HOF6sljiOc7EkuRNq36iVeiFwntXTOeLBiy2lDKzFjaTmK3mEDhOi64gog96t3N+wsr7MyuwCRbplEiZWt1IqLnwBcuCSn4WrTQhDsLAWoQyKApVWHjMEca9sE/U83R7yISyR/AAFrZCU6T3x1Lz5LJ+g4JuBeV3utTAWkc8tAAZQOLNpBKGZIG0o8lUwBE8AqWTcnyIa5DpMC3YQFvS/4HAW5PY5oE7OObeXK4eGvZCqoSTYQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 22, 2025 at 12:18=E2=80=AFPM Roman Gushchin
<roman.gushchin@linux.dev> wrote:
>
> +       if (idx < 0 || idx >=3D MEMCG_NR_STAT || !memcg_stat_item_valid(i=
dx))
> +               return (unsigned long)-1;

memcg_stat_item_valid() and memcg_stat_item_valid()
helpers introduced specifically to be used in these kfuncs,
so I feel it's cleaner to do all idx checking within them
instead of splitting the checks like this.
Then it will be easier to see that
memcg_stat_item_valid(idx) access is in bounds when idx < MEMCG_NR_STAT

Also I'd do one check like (u32)idx >=3D MEMCG_NR_STAT
and drop idx < 0 part. Compiler is probably smart enough to
optimize this way itself, but I'd still do one check.

