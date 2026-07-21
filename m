Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 319D6C44529
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 07:47:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F4176B0095; Tue, 21 Jul 2026 03:47:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A4D66B0096; Tue, 21 Jul 2026 03:47:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06CAD6B0098; Tue, 21 Jul 2026 03:47:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CEDF66B0095
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 03:47:47 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4C3401A041A
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 07:47:47 +0000 (UTC)
X-FDA: 85012004574.21.9F4335D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 682BD20008
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 07:47:45 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZDwtoGYX;
	spf=pass (imf31.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784620065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TN06rChsOa/L9VX/1iY+N7duxjCZaTEQDTCJFt551wg=;
	b=lBhhDrLKZltZMIl/pcSWj/QYl4j7YwYxP1kwyv8xZwgdsnCT/ZZL0ekV8Pl3tFu1upzHzR
	hoWvykCXfXoRouMBXAVj1bnR4HqDpHQC0bL3InYdAc5hnSxA3d5BvE2EbSv9uMpDo0wXM2
	8Z1XaD4RmJeia+D9sIDB3I62QF2t5Z8=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZDwtoGYX;
	spf=pass (imf31.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784620065;
	b=EnqyLumKeWIB2XPHejeu0SnWnIi8avKMID48HFIHMfQriituu8f5ROxQiHtKwfvbrRpL3W
	nzPeBhAJXoZ3mg9LqQk5B1JZiZPam4IIk1gNAFtTZnb1HBFWrVACq8jcbZEz9NtBmOF9aF
	suroVQN3UaFCqLXu+/LnFmXRiA9wPJQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 877DC4406A
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 07:47:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EF331F01561
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 07:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784620064;
	bh=TN06rChsOa/L9VX/1iY+N7duxjCZaTEQDTCJFt551wg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=ZDwtoGYXo6Pinu7Y1sKq2OIYMHH3lIuqyYNxy7ZL0WmmFwmVgQgjMw6z/ZN112+ny
	 rXhUv3EZCNw4wyiYxLeZfY1S5LEgkR9YB/vdeTcKFb3O0YqCCyJX1KloQ6wz342v5H
	 wRut4P4ktmSpf4gU5Hjvp8mwI4w0C483VVPfBH/zNC8Z8aZNqxspflCBvXBbh79hU6
	 afsmYum7dTfRfPP8hgXTZkju7WPLMRVnoGSduGxMY911d8U2M0Y7PzZpReEl3OCN2S
	 gmIMEM+IbmXrduxD3wQeuv4ipaqc8vdyEkbGtUQxCM9aM7fSvAdMC+UE1VG6tBRiHJ
	 mggGVLaehljPg==
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-92f03daaa97so864025485a.2
        for <linux-mm@kvack.org>; Tue, 21 Jul 2026 00:47:44 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqQwhJomNUMjRlOo4u3pTYMyVZzWjaKTwe+Y0ZdxP6BtX84ajvLhps3E6G/Aem4CIwJfX4YoyDOQw==@kvack.org
X-Gm-Message-State: AOJu0Yx7kohfHD9Y2Ji1amEWXEw5DLmoIsfgiIhY/ErwZ705rSt8ZOFh
	ZchNe6o6/ea71e1VXKVeoCR9L8+cUYJH86C2IvtmyeH7CuAwRcKypSkT50zm+9Dv7xGhYG/Cnxp
	kBK9M1BGzAuAfOOPexSIUoosQLMfFe1M=
X-Received: by 2002:a05:620a:4514:b0:915:a953:4b9c with SMTP id
 af79cd13be357-930b3e9c3d7mr1643314885a.3.1784620063705; Tue, 21 Jul 2026
 00:47:43 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1784509721.git.baolin.wang@linux.alibaba.com> <2ee74f9f98ac45a2f0db0ceb018e086bdb671d17.1784509721.git.baolin.wang@linux.alibaba.com>
In-Reply-To: <2ee74f9f98ac45a2f0db0ceb018e086bdb671d17.1784509721.git.baolin.wang@linux.alibaba.com>
From: Barry Song <baohua@kernel.org>
Date: Tue, 21 Jul 2026 15:47:31 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yTVG8CyLAE7RD90_YadeZ7q7m3Ep-yDPGO3=ej5_=Zfw@mail.gmail.com>
X-Gm-Features: AUfX_mzOyZyoVkRqdqk9Kc-1tPnONueNF-russ_3EdlR8gdPQwjJ4tu6TAZdWl4
Message-ID: <CAGsJ_4yTVG8CyLAE7RD90_YadeZ7q7m3Ep-yDPGO3=ej5_=Zfw@mail.gmail.com>
Subject: Re: [PATCH v4 2/3] mm: vmscan: add a helper to identify file-backed
 executable folios
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	hannes@cmpxchg.org, riel@surriel.com, liam@infradead.org, vbabka@kernel.org, 
	harry@kernel.org, jannh@google.com, lance.yang@linux.dev, kasong@tencent.com, 
	qi.zheng@linux.dev, shakeel.butt@linux.dev, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, mhocko@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 682BD20008
X-Rspamd-Server: rspam01
X-Stat-Signature: hjnnez7cizfbxrc6e5i3iyqsogucm7c3
X-HE-Tag: 1784620065-802784
X-HE-Meta: U2FsdGVkX18xJ6TXAGLIk4590ULEEGCqBjy9ItJdjrW14P6RFyalHmUbjOpGdVYiA1XCguz5difTDrJVfQa01p7ryyII0057fJ7Qu4SzH4fIXWCIirYEiWx8M7Rh8ciywS4D4lvmkBtQjXzZUuYT5J1IT2xNkps+4ACoU1lp54KksxM6fkbDVaNyjrPJ2sltc5o+AKTINvTZc8W34d1aK8ahZo8lpZExlC33ERbSR5MfkoSI8XIWkCermsYIxzBBIumB/BYXWcSp+It2VP+JJAGV0qrRy5bS5YcjjyBywqQjeJmtfbBgSImUQBFcCt6/q8Q3Rd5MBduP8txM/iOZHBmiBSrL4mikzn0kC9CeAfo1Ro2ib8Jnf1H2orKIp8f3lRPwOt9v2rlYN/Q2xYGj+vt1kjyuy0W7YkV14vE8lWdzFovS7IzJdNhmIVM1Vi+9QpodA9M4IBosox3iYsKgQNYdUGbw5nqsWFSr1pI1FZ6NIYGVGbwsf0mZxSqv+ps5XA7DR7rCh9wN5Iqh/sCpPvsHmLTlcDwzF6UiFurBxETOzCFE3Snet0j5EZxJQ8c0ZdQGAe858kzKPijDjWnRc0V97BLs30CxbX/NNjWibg485nP793Z4RYmOPl1OXpzITWg+R+Z+O9F4OVleF4nhz4g0eNR1dSyeGlUGazD8HLcQBe/vNrkKrAsfuHY2hijpXqqjqOVNXZUmgZeT/ds3r/RklzMkViFPiUYSJY5tA23Fo9+yYmbohZMtKXZLc9nl3N2gvwBvPCZi54lZwrYwzu9cWclbHzrQIvuBzmANFGRHd1sXVqEynajBdBAKRIvVf8Qsn5FJ8fKm9/Nbtd6qJ3+6GNJLr0L28mahQESoxyXwoZAwBHGHMOGjSDq9jE5UMpMdgdQy0IhtKOwpQnxMZLbHDWSmwlBxvhANwKyliu7sBAi5BoVguRN9bF8qKpG8c/iDR7cWB6DFSP/RpHA
 G6MGNmCA
 zgfQ2tQyUO/DCinolIGXe2XjGPaEevChe06jgDLgxJLlQ+7qTcQllbL3wak6DI3tUVQ5kU7OpB+dSevKy+vD5Dqg6U2KTtZybtLnreK3oGlNPD4A9o53xx3o+gvG0kD3RURq8hwD9cexLXDC0DUmQqXIpQKnSnQP2SOLNxyaG0v5YExpiPjWto12jzH5cDBMbe3lT7TV5KiiQaJfx4fxZZEFZVii6S3ayG7qyzyPQUIkb+jKQJqKGMiEo9QUbEP7jFrQ1awno7LUL4lUn+r/gvkjB6ZxqebjUbRwczft34N8gmO+DZP6KkpFI39rVGj1VJLUOaHR7XxTv/odt/s+5lv+l93IS8ZzLr3ZX29qB86x6Ce83ylDlCE0yWKzx/iotRy16Xht0d9flpLPu/ioVWSghp60svriZwFMK0nIyudyPmKoEhIXGxVqUow==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 20, 2026 at 7:12=E2=80=AFPM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
>
> Add a helper to identify file-backed executable folios to avoid
> duplicate code.
>
> No functional changes.
>
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
> ---

Reviewed-by: Barry Song <baohua@kernel.org>

