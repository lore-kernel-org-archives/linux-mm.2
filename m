Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E5F4C5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 19:08:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25AA56B008A; Tue, 11 Aug 2026 15:08:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E5436B0092; Tue, 11 Aug 2026 15:08:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 087B06B0093; Tue, 11 Aug 2026 15:08:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CF8F66B008A
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 15:08:13 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AE919C01E3
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 19:07:57 +0000 (UTC)
X-FDA: 85089923394.03.08D6720
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf29.hostedemail.com (Postfix) with ESMTP id BF961120010
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 19:07:55 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=JFNN5nKJ;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf29.hostedemail.com: domain of jannh@google.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786475275;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C1hreM4FHEoohH+eGJumQkjd/LtpSUCRmMU2uj8Ja0M=;
	b=wYHf6FE69NlV1uKRZkt+FpIkAWPv8LNtOQuN9CM0a+eI3EcIrXIi8QBuX/6LyQQpu51bvx
	9W92pq/1WjTkDrcEy8DOKyVU5HbXgBv5oCYY8i/GHGRH3JlNDJa52MgCCOyg17YuqVkse6
	zMg9P9HF4+mgJwiuhkyWPkK9aEALJ6I=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=JFNN5nKJ;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf29.hostedemail.com: domain of jannh@google.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786475275;
	b=qe5BrgPcAi8GDWileI4mqoM4z5eNJORNM9Cvsh7wpl1rmHY3Bb/gYbCAv2KeXaOMXcGn6M
	QOgqHfhnmYblbNBQar6P9i2NJB8AVjt93EDR5UBfNRpXn4kxqYXsD6nztOHNnJCFT/9PZS
	hVYoJgJIiLDd2No+u4lMw15F5T+vJaw=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2cacef7d299so22795ad.1
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 12:07:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786475274; cv=none;
        d=google.com; s=arc-20260327;
        b=pWX037JaORziF/nBDNN9QwO46XACu7/rggZYVEWMP5WYqbFHldsRl63eSoe9hu54EY
         LjQgYgcnGWGjfUVcHKCoifiIHn1vMBqZ4dB2TXtaLW0IjDUifK+j+hiNbISuSW9WKeXo
         2gQWfO04W+ULS9lyr4qVnyX9pOzlmtTHjr9YZyONUTt9ZOMwaXUc6kSTzIfHBRSespaw
         dUGtIZVCGl/oTLg7QBAEzYxxefqKiI94f24vOwMzA13HVBJVwKiJyVIsBtmvjHiON4e2
         2c9CRilghZqysdDjpFgaSIorAMYYymGtET0Qxp9rYkRlkTlA5rN8S+vynbM5rnuyXpAC
         XqUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=C1hreM4FHEoohH+eGJumQkjd/LtpSUCRmMU2uj8Ja0M=;
        fh=ELZxw+L9UGMFJ2E4a29oowl/s3D0dsyeCLKYxiZzuSU=;
        b=Xb+xoQZQLfrvPQYx0hWIVZGeeIYWvLgubkxcCcioLJODrt54Z8DUFrq8sPUcnpjtM1
         nK3WGXArqZgx04WWs7bd+BkLNDdQU+bjeuW0oCLJegh0cx8mg8qntQJsrFrcQdMRpCoK
         NEkAJM2+i1onQ4SVS9DB22ZWClM2pNvYTxOsHSgQIsGbPHtEjooojJw0fJvSfdhL5L6j
         98igOs+UYB/R2FdupkDVZEb2692q4cUJCNQEGoZYLtd7r3arr25yd7KJXVyXuhgrrWjN
         QKGbs41iVoiximHgIhA8EcereEf5JE4GS/dXImFRudJqALRu1Y4cEGoNh4CPK63B6Q52
         4zdA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786475274; x=1787080074; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=C1hreM4FHEoohH+eGJumQkjd/LtpSUCRmMU2uj8Ja0M=;
        b=JFNN5nKJ/gqfkgl0trdDQbh20LmubyF95QWHin4gUSb6V2d6DT1JeQmMNbhs/xczav
         Su1tnMz9xXwWK7jrtIg30/BiOL2oog5O3DX0sZ7JHieKYBP8ybN82mFxoUYVwXkRsqV0
         t054SX3x5xt/wwRwooebQbz1CgynFs76U5IZB07Sbq+Ts7EAHozWwqoaqixd7AeK+suZ
         QczHNIct0dx/Bi+eDZBXT+2Yw4whjWqxuN7HAbXEB5E9j9z7+qkLAcTYTO/7Yt1ZD5VP
         YmvkPLLksUYduJr4Fk6aY6AP1hMIIXLh/y8qF42Pf8gboDggZHB6DBl5BxWsyoUra5Jg
         gQiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786475274; x=1787080074;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=C1hreM4FHEoohH+eGJumQkjd/LtpSUCRmMU2uj8Ja0M=;
        b=Z+Ov8aQi47ZXbCYAbLKET/vcXpXN2iyedVHsQ7BOGD7CA104b+k13mltYNUD+zftsI
         wVzFqmM26uVRJTiWnKiDvSwegBXuyH49SM9DS2IPZLSRh/0wxgnDRhLS44am4z1KPr4y
         SsQWs53mLcK60TF+J+qWKW8+ddlYG7e2L5R0p1BJwJu12ohzXn1430/nLWQhN2JaTdJ0
         AInEUzlOjzuEtzGde9D9Yh51rpCYZJ4fvZjr8XmPO8ggF9LgDl1+cFpQoUYl1yPW0VnA
         oBAexL38ljaQabbNqC3JI0E5s4bm2dwrEG/iD30gaD/x/lXWeChYzLy14kawcv2VPMol
         6k3g==
X-Forwarded-Encrypted: i=1; AHgh+Rox/96w/T8ZUXMQNajKoLkZTsS5OKUNRrX5WgZhgdiccD8Zy2GaSBNZ9XTVkn/S1WlcTS7iF9TQCg==@kvack.org
X-Gm-Message-State: AOJu0Yxfmobyg9F4OBSKFz3CYNOgxpiSx+7YvxBzwjcM8YO+vd8S+1yL
	lRFrdlU/9QpyMFdGtWVJkXCzJxJyqIWqMKY+yu9nf/aL0sCSTxtSo8ykzfB2zYZ77E/OzPFVERS
	VoMJ6+xio2dYnZR9mA87X3oA3YUTkcF+ZEgWEvBfi
X-Gm-Gg: AR+sD136ttUHgBoVVSq6AiM7bVZ2QucIJyQPQjR7elg7Beeaj2TjH06DYDfSwNHKPz6
	VLR3Tgw/hjCRFnQtHAnJiPvH2W/a5sAPbQgqqxVCJZIxPOdC/ydMj8yAkS/5+xQv8L7h60UyHvw
	s8F5zUEGdnZpC/txeaP31qq7rgeV4m7upLiazCxZWyWi+0JOFJQQWnIrBFSA6DObMJcROI24b21
	4i5M3bQNf7h5KISM8otJpRdssZmFG2CTmGAyz7IugRaHXG1yGt9y7EiEXzBN/FwdpYRN1UB6y0A
	asYQhQ7zCp4xVSGZde4J3fNe2TdjTJ64T+mbQwsA5cZJIIPvPIL/6nQI9YcmeTnUULjZfgJWiOx
	7i55n/xyQ7fYZpbkeLb4Myqpf3G3jnoM=
X-Received: by 2002:a17:903:1843:b0:2bf:3579:cdaa with SMTP id
 d9443c01a7336-2d33a99905amr481575ad.10.1786475273937; Tue, 11 Aug 2026
 12:07:53 -0700 (PDT)
MIME-Version: 1.0
References: <20260811-work-coredump-sparse-v1-0-cd3e8b1e356d@kernel.org>
In-Reply-To: <20260811-work-coredump-sparse-v1-0-cd3e8b1e356d@kernel.org>
From: Jann Horn <jannh@google.com>
Date: Tue, 11 Aug 2026 21:07:16 +0200
X-Gm-Features: AUfX_mwl8D17qLmpn2j9POaLRIWa5xMeaCP1oLEBxMsBs01SgCKLca4ifFR7LFM
Message-ID: <CAG48ez3QwUopEyfB0tEc84A57g3GZdnptazJW+htiTi2e0Gc=A@mail.gmail.com>
Subject: Re: [PATCH 00/11] coredump: allow to create sparse coredumps on the
 coredump socket
To: Christian Brauner <brauner@kernel.org>
Cc: Jacob Lalonde <jalalonde@meta.com>, Josef Bacik <josef@toxicpanda.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Omar Sandoval <osandov@osandov.com>, Jacob Lalonde <jalalonde@fb.com>, Shuah Khan <shuah@kernel.org>, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BF961120010
X-Stat-Signature: z8po91sp8cinozqj6qgxwx4dpg968ha5
X-Rspam-User: 
X-HE-Tag: 1786475275-235605
X-HE-Meta: U2FsdGVkX18i7qJlSqOEw71O5xnF25Eu6oE8QtqxddSKaDORBkie8lgdDdPPY5u1m3T+tkepWsugTdAJjBUXWZ4eThpk2yvTzAYExal2YJVNkyz6lXAAGBuWc1uc5SnMwXPE6ma/Vh7DCR+H5z7AiBAc4PwH1rrOYjzL8vwqGnmKY6eDv0p23hoVGobTEq7u/jOvmDgZZugPZAHxORvAo/u5CVJsDC0dA7t4NMG5ChvgD8xTZb457fPBT//C87OA7KLg3G+qFDlThn9NnKyEjFujyHBuDRKlAG5ZbPcIoct7RYZJNGVkE4i4zPWtjSXvVouMrNmB4CHAHo/r7SvqdwrP4sNMdpcqpI3S5VKl1hQQkp+La+CPvNqcmvTYK703hk2u12av6sldFI6FSg/nheyKRhRZiDhKklhLfhdIaXy4KBpNWkd1YtZArwH77Xudw7BQA12aBCe6mgq+zZeJ8i0VT5aqUXbnLZKcHpfGH6lxuyfnQJUB+cWDjky2L2eZEqOtfTLaDtByl2aVshCYy2vQwMLes5tzHPK8YnA4POhB8+BXGzJUIvShbWxeuKl5HWnOK3vj/nMGRJecjPypTs+B4ab01gBiY7Lqc6eUDR1f4EaA9Njx6roaiR3ihvJ/GnSnYW24KWJ7jGIqxLZmJb+fEUdykeDio1WvVhdR7VrXdoYKXKPlU6aIesjlRMsUjp+i+JBFQmkqCA6vW67/jUx2ctoNp/Fz7l33FC6B+ht733eAKkbkhKlVDpT48VXTyIoPuBn455pcGn2TNre1KvbgYYZs2cLCAlAu6dpryomn74l81pFiKnvPzQbIKNapSu54iDG0Ql6r2Jc/MgP059D7H4D27ilWwfkyJg2nEyhhO3e/FhlfjXLycuTjqzZngVcHanb2pv9R28BiHfhXir9oxvMQMumn/qqJnA19gpsu8sJNc9PRU0dzBCElDOMQHxc06KTEYajKJIoD6Tm
 29e2MbER
 zsC04zj/0QTF1dhCg5pKO7AQscyfKKqryW1cNGI7HWxiuFlVttX8BQrqW13CstAsjErOoUQfJ8O65wsvY/yS+FrtAupbFUnUGmx80x4lgSnSNuBM3vcy0G+sELMwzb7ZqwxxXPp2bERFxjm20aRQZDQF5fNhEfKej6H4cIHYkxvdkPDIxshRfa5Me5F8LnTsbojFNgX3diKeetYdPhUDHjZuOK+bNog9+hdfOWePN3v5Nioz/7xxoActtckM7Okyr96bxth4kH238YJc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 5:27=E2=80=AFPM Christian Brauner <brauner@kernel.o=
rg> wrote:
> A server that raises COREDUMP_HEADER in coredump_ack->mask doesn't get
> the coredump as a plain byte stream but as a sequence of frames. Each
> one a struct coredump_frame_header followed by what it describes. A data
> frame carries its bytes. If a server also raises COREDUMP_SPARSE, zero
> frames are sent for unpopulated mappings. They only indicate how many
> zero bytes need to be written and to not include data. Reassembling the
> frames gives back the same coredump. A debugger and everything else
> still see an ordinary core file and nothing outside the coredump server
> has to learn anything.

Hmm...

I think what you're doing is probably the easiest way to do this in
practice. I guess some design alternatives would be:

1. (overengineered, not generically useful enough): If the transport
was a pipe (which already has the concept of different types of pipe
buffers) instead of a unix domain socket, we could introduce a special
representation for zero-filled pipe buffers and some API for receiving
zeroed holes through lseek(pipefd, 0, SEEK_DATA), but that's probably
not sufficiently useful for stuff other than core dumping to be worth
the effort.
2. (somewhat overengineered) With some refactoring, we could maybe do
something like /proc/kcore and create a seekable virtual coredump file
that we send over the socket via SCM_RIGHTS?
3. We could leave the userspace memory dump out of the core dump data,
and let userspace take care of filling out the memory contents using
/proc/$pid/pagemap and /proc/$pid/mem? That would also avoid task
switches and SKB allocations, and probably reduce the number of data
copies involved in this by 1.

