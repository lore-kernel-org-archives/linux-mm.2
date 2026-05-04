Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7F02FF885A
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 13:35:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16F1D6B0005; Mon,  4 May 2026 09:35:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 146986B008A; Mon,  4 May 2026 09:35:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05CA66B008C; Mon,  4 May 2026 09:35:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E9C406B0005
	for <linux-mm@kvack.org>; Mon,  4 May 2026 09:35:54 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 993801A01BD
	for <linux-mm@kvack.org>; Mon,  4 May 2026 13:35:54 +0000 (UTC)
X-FDA: 84729835428.26.38E02FE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id B9422A0002
	for <linux-mm@kvack.org>; Mon,  4 May 2026 13:35:52 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lm8czak3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777901752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=anAXTn2WVNJfQBijdvlVjx89L+KjLxZQUrMBMBAvn58=;
	b=GOd5dcgyKUHoYutG131IYin1YwFWj3XDkfkUOl5Bgyvw/uRRksskyN8FsRas9sUNBlgRty
	iZg9HwYi7B3CUhVGDfhh9K+MNSRKCE/MA1h3fWO8+2pW8dTC1Q0LG1epemb2w3kFJXCbux
	R4eYBW8H29sLlR8WSQ6cIeuXX7SPKkg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777901752; a=rsa-sha256;
	cv=none;
	b=XJyWtEMenTBPLRQTxYQd/v/SfG0Esq6pSWcFYkZnMXh3kWDUlGWVRR3Zi2v6HrHo0+ugXk
	LvW7XZs1OGQSAzT33nXuNgngz/wI83v3a4dTDAyRCI7txv/SbC8Qhl0ePo6nw8lCiW4RCv
	AgoR8bur3hTn8O6Cxaesa9jPCxo15sI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lm8czak3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2256360125
	for <linux-mm@kvack.org>; Mon,  4 May 2026 13:35:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCF87C2BCB8
	for <linux-mm@kvack.org>; Mon,  4 May 2026 13:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777901751;
	bh=anAXTn2WVNJfQBijdvlVjx89L+KjLxZQUrMBMBAvn58=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=lm8czak3ojKL/iSeFyCXKqI7NTDydVsOyB2+Hmt8nIK2EusB+d4Z4frGvii94dCYM
	 jWu0DSEVVN+bGYmtnqjUZ613RrBl279QTX5Q4GXGY/7uhrANxd69oXqVhg4v9RhlDr
	 j0Bf6ACKU0YROCTpFS5awmkcjdKqVuM+Cdbkq4OknL3HDQb1DpvjyXBC7KufyhvzqD
	 7zI8a4XUxzPdXMbnVIlJrXSGL14ML23Gg2KG7zpTnsaZSKWHibluTUhcKe4kIIwY+6
	 YESTlho5Ct6TbII6iOg1nmDm+rg+TnF6JT9MWtZidEiRLMooEyQHzB5HaaV3YK9SH9
	 zy3fy169eVGyw==
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-8b8e98fd885so8862506d6.0
        for <linux-mm@kvack.org>; Mon, 04 May 2026 06:35:51 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8jdWkp4CUi44PXNHspIZ6anXVBwY1cQl60B7GXhsA+qbi1qFoptjwMFOkRNm+tvTwCeW7XrAm2PQ==@kvack.org
X-Gm-Message-State: AOJu0YzHtjEh7J+Jqkkt1/huc8mipQI3yNY0semBrL7DeHaV6TsVjgVh
	/MGfebeiyJRBdhioxcbuZW8r4F371q0J+iZ9QzfhzTZ5h390USEDj9xFh2OElIfibkyvaKzN1nR
	KHpgNF3S0HSqtENZkkY8UiX0qfjsyEFM=
X-Received: by 2002:a05:6214:260a:b0:8ac:4fd1:2d4a with SMTP id
 6a1803df08f44-8b668a259e6mr167277966d6.33.1777901750649; Mon, 04 May 2026
 06:35:50 -0700 (PDT)
MIME-Version: 1.0
References: <20260430040427.4672-1-baohua@kernel.org> <afNM-gIqxpyJ6ro7@casper.infradead.org>
 <CAGsJ_4w0qcYmukHqsyRd0jomoyYkJjOt8b-Cgp53BgP-8QQghw@mail.gmail.com>
 <afS_L-5XeWIldTXA@casper.infradead.org> <CAGsJ_4wk=SDtgin+84Ev2TamU-JFfmrg_SUay=-tcYmnFvK6Nw@mail.gmail.com>
 <afTpoL3FklpQZNMM@casper.infradead.org> <yezmezj26xntushmylductlmytfgvwsnbnzlhffkfwugfxkt6m@gleq22spziyk>
 <CAGsJ_4y8JtCxEy9hVxVd8eaf8D9WC8BcRQp9afUVu=FJA1-awA@mail.gmail.com> <n5vsmp6ingbhfztl6wzcwmrz56gkkfbpzardk43scr7rcgqsw5@evtnov34c5bt>
In-Reply-To: <n5vsmp6ingbhfztl6wzcwmrz56gkkfbpzardk43scr7rcgqsw5@evtnov34c5bt>
From: Barry Song <baohua@kernel.org>
Date: Mon, 4 May 2026 21:35:38 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zBiRTttf1nR0Ni9BRT3Cv5XFZhyYP8oipFodpS7saGwQ@mail.gmail.com>
X-Gm-Features: AVHnY4I0u-Qbkg0vrggpRHSUVs_cQpUa3gydJwrEbvTBOzz3MxeuFlaWucVZXHg
Message-ID: <CAGsJ_4zBiRTttf1nR0Ni9BRT3Cv5XFZhyYP8oipFodpS7saGwQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] mm: reduce mmap_lock contention and improve page
 fault performance
To: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>, akpm@linux-foundation.org, linux-mm@kvack.org, 
	david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, pfalcato@suse.de, 
	wanglian@kylinos.cn, chentao@kylinos.cn, lianux.mm@gmail.com, 
	kunwu.chan@gmail.com, liyangouwen1@oppo.com, chrisl@kernel.org, 
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com, 
	bhe@redhat.com, youngjun.park@lge.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, loongarch@lists.linux.dev, 
	linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B9422A0002
X-Stat-Signature: y476dn8hg5moi774dugnqh8tuur5k9kq
X-Rspam-User: 
X-HE-Tag: 1777901752-218759
X-HE-Meta: U2FsdGVkX19Ey7OUrKkSMJtqrwkqGMU8fqGnblxDotdGQ1TPx2WwT/WN/MmFvT5f88OOc4Chj3I6fE39l/8zhyKJE4eJC2R2Wd8BPrg5PRuhOm0YdleTteXJ3wdhAaUqTuAUKt3S8c1K9wsxMOD8wCB9/tUHNdghkbGbUgADg/RaXckBEk0ekdtcQfs9QDqKOvRWa1JjnVseq6wrTdIUvkqbRpQREKj44prE6xVSLSLGkkQWh5VlE4olz6wLrwHUzZnBYdjhgsOt2lih25KD0iTFJ6BXGi/P3iendfglhxtQ3JXRJbLQAjMWIA6ouIor8EhZTGiOoT4imTW0e/FDX/JJmCGg0hACdvAbWJnXWyO211vjI5tnZgoPcAIeg/THQ+LqpY+ivu+7ntqkMCqPZ9nI6CoKQmoWqaY4hSXWLQkk9FfFEfshRONui/zfc6JF6EnQNsRly38eHV/YuXmoO6OgSBU1PsbeNTb3PPbMWCoQLd1hs+kDLuM1h7lysdAnWeZLwxsVRF30Y9GyQwwWULAfvY2uOKlGRsUOrIOVTW2/XpRB4147cJ0EmMO0AF2KomLQA4AGhqoAZzKB4EDFT2rmKbqOpQc/hFypovbcXUKRB6OftDPV0gTCiU1GPZ66dsS+WInmE90Ey5znx+zVbl6Kt2WBCB0Z1RzjAS5pf4DS2+DjdKs+doda7dUoKS4sTFd1PPTfbtollIt8XOsi7WjMnC04F/a+JRrMGlgVymVpTo7AzZd3INmoPstSQh/QZKanu8A6SNC1qJInDyijD62NB+9vG8u371/NbEK4nFT2zNHYdZZ7POXOVDDdOB+mMsrI3BKooSH5PAZaZxxYt42sdanBNEBdXfaD+9cGrLCZj+BGmQL9thGsm25UZBR3QWbblAU3N58sFgriYN4c3yk0UxwtdG7Skz1Lolun4UaKOzTH/1fE3w0j4gjZbWtk9EveEo6GrWgtG7YpP3C
 zUdnb1M0
 auy6j2QY42sDAfvrCxJKimaLPsbH4FpNXx1RRyoOBqPuH1eNz7xMjJjbNFCeXifiaLOUUhYCnECvkOhBlpHhgILBddxgpmeylrQ38B1a+8ZLMMdI9Lgzqo0bV/lQxClnJY4TfKwavd09xk2tyBrqzgCLfx+ZwRGsjNgI4O75QXE5I6EbDRxpcUTcsMwshfDVXWFlqAOBwuSFjuvPeZugezcVy3jNkRst/0Ou9zX+ll+VLtw9eN2pya/xQhDOXdtXI5ljSkBuqWo3RS+i2Tem8hgFjShVsorLAaIha8P3vFg7CK5sN34YK71fZZW/LcG+Srp0tvZcxmWETk3oqcfvZagMEOlc3md1loN5v9vK/MdOzq74EAqBhmetGMlc5QI6zI0lA/t0j4INpEAxTyES0gKCk3w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 4, 2026 at 9:04=E2=80=AFPM Jan Kara <jack@suse.cz> wrote:
[...]
>
> > > BTW I'm not sure I quite understand Barry's priority inversion proble=
m
> > > since I'd expect all threads of a task to generally be treated with t=
he
> > > same priority...
> >
> > Exactly not. Maybe these slides[2] and this project[3] can give
> > you a hint=E2=80=94they aim to standardize things on Linux by
> > learning from Apple OS. Basically, tasks are classified
> > into five types:
> >
> > USER_INTERACTIVE: Requires immediate response.
> > USER_INITIATED: Tolerates a short delay, but must respond quickly still=
.
> > UTILITY: Tolerates long delays, but not prolonged ones.
> > BACKGROUND: Doesn=E2=80=99t mind prolonged delays.
> > DEFAULT: System default behavior.
>
> Again, this is a clasification of tasks but not really of threads in a ta=
sk
> so at least for VMA lock there's no inversion so have?

I=E2=80=99m specifically referring to a task (i.e., a thread) when
discussing scheduler context. It may be clearer to use the
terms process and thread explicitly.

In a typical process sharing an mm_struct, each thread can
have a different priority.

In an Android app, some threads handle the UI and require
higher priority, such as the main thread and RenderThread;
otherwise, frame drops may occur.

The Linux scheduler can control scheduling policy and
priority for each thread.

Thanks
Barry

