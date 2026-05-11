Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3022CD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 15:20:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67AD76B00D0; Mon, 11 May 2026 11:20:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62BD66B00FC; Mon, 11 May 2026 11:20:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5684F6B00FE; Mon, 11 May 2026 11:20:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4995E6B00D0
	for <linux-mm@kvack.org>; Mon, 11 May 2026 11:20:32 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EF1731C0070
	for <linux-mm@kvack.org>; Mon, 11 May 2026 15:20:31 +0000 (UTC)
X-FDA: 84755500662.19.A27AB27
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf13.hostedemail.com (Postfix) with ESMTP id EB37D2000D
	for <linux-mm@kvack.org>; Mon, 11 May 2026 15:20:29 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=STQy2nNL;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of jannh@google.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=jannh@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778512830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X2dG1kfOBx0HJptuC6o6ArS4LPW49PGnYr8UK3AxYy8=;
	b=tXbWZlpR7BHQMx1C/Ap5zN4wc3CkSzTdOeb2VOSulG1JOMRiwkdFjLgAlReAtxUiD6aS2P
	0wNc0ZKq/TSQDtH9I3uGM85diAk8PqOslZCvmbZs5EJtHughn2DR8dbplVGp87ig35/2YW
	FF801FpZxuAzTecsSOpdDZsVvPk6dMo=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778512830; a=rsa-sha256;
	cv=pass;
	b=XlBkPPZKQeDSbAukeUVSu3+xpwRs7btG+CLlATz3QxtM1g4sW+QhAgLElVkPiMwL+6Ppr5
	mB0w8h62C+E3FkUFoTuR2pUyDtih6w+S/inkrGDy2rv34TJQfktCHZElr/nkGpfckWvYWf
	853zmOlA1PA+IPRjGYD+Wk6siUFO2TM=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=STQy2nNL;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of jannh@google.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=jannh@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-67c1eea6b4dso351a12.1
        for <linux-mm@kvack.org>; Mon, 11 May 2026 08:20:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778512828; cv=none;
        d=google.com; s=arc-20240605;
        b=Ac//H2/U70wrmmJdRx4AnekU0R50NH4qmb+iR63LrCkofLxlYZP5i429TAU6CrTmG1
         HHaKqKbSCkExPSjzE8i2Y89L+3sjFcFrlCXGVBpBJSCqzfdKCMYjpXCIob+i+0KYq0Sf
         8d7c2c/0DYoEWnywnSHLljOZsF3i6dSgb6Yaxb4vnLi5vz3FURCSVbX/Ubq1i/YddSzp
         xXRk9DoH3EV3JflVv4Q0DavueQWKFuc2OGeqvHt0btrdmSvNAdKh1p0SpkxL5Lh9CnVH
         6guFkbK0s3wJoMgFv/DeOXS9LJkU3t1uQiD4WN1MyHZjLsZJoak8cbotdYIRzWE2Eco2
         sO4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=X2dG1kfOBx0HJptuC6o6ArS4LPW49PGnYr8UK3AxYy8=;
        fh=fd5TjbSds3onLoVSfPIE4rsQR92e6kJpkoN5T0wtrCU=;
        b=R6zJSwKci02cJ85Il8494hE6aw1CQBDX5ZsRIjH3/AYsrsDn4dx9ykWHJ5jTQUHjRT
         2jSmWBodCYimVmxl0ULQxnb3fgSQG6pDlseU6p5GDhGLPRWbrTx72SN7sm8qZYysPdkO
         RAkOijniWwK68nU53AGgHqgM3EHQ3goR+WGIAL8QyWikL4FDFx7r0xJCaL5B/jWnl8+g
         5uwiVfIxNXHVGab+P0kxgaPjPNlzS8TldqSjLdq5+yGZfS1NGPriiumcuszMY0xKttcB
         coqzeqDNv04Bwr8VSwii+c0znPiIFjht5aachEykYOZsTwFQitMrl8pOaWNQlx9jzrlP
         UuUw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778512828; x=1779117628; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X2dG1kfOBx0HJptuC6o6ArS4LPW49PGnYr8UK3AxYy8=;
        b=STQy2nNL10rphu5cArrLrpcz+xAfFT/68hsUTm53keJhGV/jkuVIbNaqSuyB4dkHWQ
         +cLL1YG+alV678tuBz4uhlOFFnxrCSwQ2eHsg+F7MZBfGcMFmGi9oqtCC+HByo/+Cm0H
         gJWTh0hsMyOx8DlqzV7xbl6YE/lI7WhpZIIlBqTmt9m64o5yCXE0zRyMu7bM1VXiVtkL
         GtkHEVDvXdsxPiSfOvwvtTd4S63jMky6N2OanLcDSiWLh6MK+YEZwS6bhqnc2xCsJjju
         e7cvK2k9q9zM7FrwTjLbOwwY5bGh6iOxwG6a+7ufHdzRuWtNgRb/qv67DY1eVKT30Gpv
         gPrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778512828; x=1779117628;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=X2dG1kfOBx0HJptuC6o6ArS4LPW49PGnYr8UK3AxYy8=;
        b=bAB7XemnupSp354sx9IrA3aigU4xD5jt35e3YAQOUmHL94S2RnhKFd7eW8cnuvh2iW
         hj61dRqTCRJ6fDSr+uy9kZ+/kkjRLp8MMDJJRWj25jq+GMjn82ALlaEtLsR6o8y4exFy
         4LLP+f4FEa8t/nl5NM5p/SkMy411R2gqYTNfvYdgzCzAy6qMmBalLS+aGifTYRs5LrNF
         be31fytcpZMnMba4tKDu8PqQkFJpvW8jnLqRJ/wPIxmSv6BgS3bEinG1Iama8+SBCx7Q
         dfz29hLby0g+VavZmoxARa881cuipYJztIvFCqaue5oFct4OX2Zzpk18ZY9PYGADbk44
         70aA==
X-Forwarded-Encrypted: i=1; AFNElJ8cCVj1CkMQ5r7xvIFbBjRVUpbbkbhRJnD5rtL9DPTtOik7w+fqE5vX/ElRkY/ghJZitUtka+aJNg==@kvack.org
X-Gm-Message-State: AOJu0YyHmOqPL9GEF1LtWwYMRF1UfREDXwmEFXNHhvKJ/HErFTbz8/SZ
	SzYYbdnitIWsGJdhueubg0k9OBADXHzeCfjHPsz5bJ/S7g6SXIadD6dhTSrTXSgmL5DdYLdKFiG
	DOGgXJuALH78v9/3hWsZzjib9Z5/HVLwIeIJzyrsY
X-Gm-Gg: Acq92OGey1ss4yeNIo6p8wfqLYdDso2A4WM/Zp9pV5L+EpI081ufeZi9ojX5D/Me5eU
	FmGvSKVb69OKV2rSJQPMcY0o5fx1QtIGhKYBTMUhQZaq86iE/DPNwts4HU/WgLLOQUkBoUUaW+l
	whziEzxxzflBBD81VzrBc4+uhxRB2iaYXwoFnysyXqWX3V6Lw9ouVy1NhrgFiXKCboo2MV+wuXm
	KScnNgq8+1webExPwg44z1Z2dgCMgljNNmBvEYG2HIjH5SKe7TRGl3ZKVMT9NuXKQsZBtK+O+fv
	3GdpQvi9QLzxlYqUSOL+Fw0Zk2th9+ljP+eUpiiQ8UYxqA9/
X-Received: by 2002:aa7:d44d:0:b0:670:9e9f:1a5e with SMTP id
 4fb4d7f45d1cf-67f5998f71dmr103041a12.2.1778512827673; Mon, 11 May 2026
 08:20:27 -0700 (PDT)
MIME-Version: 1.0
References: <tencent_863C8A01F3C81EBA238F375B16065CBACF08@qq.com> <agHmO4i4YUhs3cSG@lucifer>
In-Reply-To: <agHmO4i4YUhs3cSG@lucifer>
From: Jann Horn <jannh@google.com>
Date: Mon, 11 May 2026 17:19:50 +0200
X-Gm-Features: AVHnY4InzSL2AhuukjCngXl0RYuPKjoMy6hvuirqqPJQVud7h9Nv7GrmkhXycBU
Message-ID: <CAG48ez1sLtSKVQLHbLO5usBgMgjyOGhbX29pKEfku4Ht05HffA@mail.gmail.com>
Subject: Re: [PATCH] mm/mremap: unmap full fixed target for multi-VMA moves
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: fujunjie <fujunjie1@qq.com>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EB37D2000D
X-Stat-Signature: areqfacuawzte7ttxaufu3439dgf8i3k
X-Rspam-User: 
X-HE-Tag: 1778512829-219943
X-HE-Meta: U2FsdGVkX18a+BkiX9ME7OjFrtyT4h4BeVbK1M/A1OWW8vu0Slu2PYlATke9m319KylWUadOXshr83cC1pfaGOF9+Ah+Cu3840313RZBLQu8mfGWzC0OHIoFH7fQwllzWU4JBqfsDXZHqUL0cD9VHqm8PPV3uv+9QO8p3X67Un8JAVxsigGZV9ZLA+Ayc0UzajrVM45B1S9cxOvTh71blIy2QJp12oZ7xr2hwy0vPajsR05H8osj1c62+ve+Z1cQEYGBTkBWgDB+SEzyEcIBEm1M/IglA7J2yllEZvLPF6wa3M0zQU9TpjQqM83ssHJd+JgcYup25AN1xTyBqde4iWDIwX+J/MUAnjxC76F9xPa31pYk8wHU0S4+Rpc/rnN0nD+ilCAXUPsICfyqJhnE1GFXBlLutclnBxBjdW4OqwdL6NrkmRwFnhgmQxcBMvouc6D5hvt9wTjA5M/Er8mMgGwGq8W44DBqRBu9iN1ERNQBmWAUeBOOqq21T9DGnHY/wHbZe0Q0RvuBp/peIXIqLa3otHW0bfJoEljGrkVKlH+K4g/+aZQ1qGzdlo0qCKGZ5MP4p8D8onVCtwipPW4yZeGj7CWEJe7Ar+CPLw4ljTKOcL3pMqu//h4PdwGGUqho2R5Bv1CiGl5orTXBHr9+lJrWAzAOLeRRq1YQbeb9/WiX3VeeN4dWPafBjCCeKHn73nOx6VRggGZwKTGd7ScaT8EnSnidFyK6K+BenD4kG04s1Tth/y+/yAPQD7OwhyF/0uGQHv8nBzmYUiviC73AyNnVLagmsmK2r4UsUAE64grRoabNZ7EugRYFgAolRjmhyl8Ir2L3jk6k8kiSotL4L4hgEaExtn+LRw1o1grU66ZYPOquax+r7x5u+Iq/d+9gUUpu2J09MfIUoxb9CC9ez8phwhw5Hg4dpX8GvoWuR9q6jyyG1xT1vttdOv9DHv7ix/FQNHKf6JxW7D9kTld
 dSgSVuog
 pD8brTUnVLXXuG61wqMElGjwoFRFstRuxwtlhUQF8TJCNr9auWrCir4GVes/TMOZ/GNosWyUx4zGZgIHI3JT5gtI6d6bmkJaB/EI6dZStHYwQ8tg27G+GgiZUDuiPJmryuE0uFCFvKQkAX+oBTcbPSYQAQHrX/1+EqOoJLOV9qSR5MU/wAP15lT8UYYJXNhi3r9O4aNrpVn1Puq/hx6vBFCKFvdGmMMBnoc5eRG9ij7Hx6QkhilmKzM3rXqSLeQl0yWwi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 5:05=E2=80=AFPM Lorenzo Stoakes <ljs@kernel.org> wr=
ote:
> On Thu, May 07, 2026 at 06:24:45PM +0000, fujunjie wrote:
> > When MREMAP_FIXED moves a range spanning multiple VMAs, remap_move()
> > iterates over the source VMAs and skips source holes.  For each source
> > VMA segment it narrows vrm->new_len to that segment length before calli=
ng
> > mremap_to(), so the MREMAP_FIXED destination unmap is also limited to t=
he
> > current segment.
> >
> > If the source range contains holes and the destination range is already
> > mapped, the destination subranges corresponding to those source holes c=
an
> > therefore survive the move.  That violates MREMAP_FIXED semantics, wher=
e
> > the destination range is supposed to be unmapped before the move, and i=
t
> > also means that preserved source gaps do not necessarily become gaps in
> > the destination.  Userspace can then observe mappings at destination
> > addresses that should have become holes.
>
> Hmmm I think it's a bit debateable honestly. The ability to handle there =
being
> gaps is a _new thing_, so there are no semantics to speak of. Prevoiusly
> mremap() simply required that you only span across a single VMA.

FWIW, I think mremap() on a source region with gaps is such a
hazardous operation that nearly no userspace code should be doing it -
gaps are areas in which any mmap() call without a fixed address could
place unrelated mappings (unless stack VMAs are involved, which would
also be a weird scenario), so to use it safely, you have to, among
other things, make sure not to use libc malloc() at a time when that
could place an allocation in the gap (which means you also can't use
printf(), and so on, unless you have swapped out the memory
allocator), and make sure that you have no other threads that could be
doing that, and so on. There are rare circumstances under which it
could be safe, but I think it is almost always better to have a
PROT_NONE anonymous VMA or such as a placeholder.

I think the right documentation for this is "do not use this on a
source region with gaps, it is technically possible but extremely
hazardous".

