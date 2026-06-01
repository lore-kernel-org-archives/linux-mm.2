Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DD46CD6E61
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 17:24:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFCA56B0483; Mon,  1 Jun 2026 13:24:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BADB06B0485; Mon,  1 Jun 2026 13:24:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9CAD6B0486; Mon,  1 Jun 2026 13:24:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 938C36B0483
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 13:24:02 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 02F271204EA
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 17:24:01 +0000 (UTC)
X-FDA: 84832016724.17.8595F57
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	by imf11.hostedemail.com (Postfix) with ESMTP id BDC4640009
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 17:23:59 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=fhm8sFn5;
	spf=pass (imf11.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.167.53 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780334640;
	b=6j5buCW0+XLIpqldlaHB2d18hCh1p9NyBjwoBaG2R9Ca0cdUQPo2oKpoDzQkXZUoMIK2mO
	2S5/4JlyhPzQkMORAV5sRVpxkd14tr1cpaOQvNrqY58eqf29n+VmZUelVp4EY7xQBuuqJJ
	h3ljTmplIMh01d9VNQf1JrAC7PilIcI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=fhm8sFn5;
	spf=pass (imf11.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.167.53 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780334640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8glRJeBkbbvtPfYZZguJlBO/diWKKHW+QvqawLEed2k=;
	b=vQaeyxu84DvNg2kZGudpMgwbHp7LZnLm51ngvQ7IVdAOtYffxAhX7ObwhBZrWHldTpcuhx
	Ppu94ziY9tRUdI74IVRcjVRs8TVpgl9D6rQZDnEHYYnTtxcfRPu2UJy8KLEU0TxEcDquGQ
	jQSqerYyY5pYhLyN9SnoQBDE+ZuN7E8=
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5aa68d65d24so1552329e87.1
        for <linux-mm@kvack.org>; Mon, 01 Jun 2026 10:23:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1780334638; x=1780939438; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=8glRJeBkbbvtPfYZZguJlBO/diWKKHW+QvqawLEed2k=;
        b=fhm8sFn56BX+yk8lZgW4thiYw4ACDNABZ+nlfyZexEJOV+1b25eb/h2J6rd9xIeOpe
         pWqlAV8J5W2UpZ2iUix1Gw2hHQjm3v5iGOQPBVChw9DHa4ul5op+FT+4YQguWqZiBU+t
         w1OqjjndwuiBukx2NUFRLK0kjHnKFiFFbcPU8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780334638; x=1780939438;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8glRJeBkbbvtPfYZZguJlBO/diWKKHW+QvqawLEed2k=;
        b=WWQrX8isEnPKL/ui581enFFOdd5eAIPDK2TruTpvI6uUFHRspcf631lL34W09wzl8w
         LxLDCGCMsCYTVVlF2aGMPuy8yKW5KWhE/nJP0sLlLv22rYwcKRGWlORFiBzK4j27mu2S
         o+k1apfd0nNEr4x1EuTCsNPBvo+vH0EdROifHpV9GHs8lRnKfjur6sl/Wyen6DOaQezp
         x84A0o+WkjKgJw8GRUU3GuBJOpoy0PaJ2YztZl8IDK3dXfoBRS4Wlez9Mi+CQk35pyls
         kTIXRiT5ER/4l5Y33Gftmn+skceiR92Jau3qKXphI3cZBXGK/i/N14LkypNKlfAeuLlV
         X2zg==
X-Forwarded-Encrypted: i=1; AFNElJ/joppPoV/wQtCj9V878pi9fGhwEO5PxqxanHKqwnqGlGazUWTYCO7IQYjzcBectXtg7CiFbAcMiA==@kvack.org
X-Gm-Message-State: AOJu0Yx2ZE4ubU88AccFC2rwD2aIDKe+65KVqA5lSBHHwj++Tom0MVAu
	XvXTFBN6abUHFM3LF/N6Rj8H5beIM/bRNkvm8ZBjiLS+beB8G955rrIyhxmUK2eIcZvWIhwXCOh
	pXtCtz+co1w==
X-Gm-Gg: Acq92OHEgKAnVM0KMN6P5D7YP5e62jsNs1kRFK94DZ9aM39orr3IPpQdkbVzb3sbHv8
	dLsDXqTFhmVord29fsnzcHFQM6Kaaj9cJUAK7chBkQ2nhXWc/XfOpyEZTbDoFqDXKvSjGetfawg
	TONIWnOFFCDbKpVWlCwoT4EbDgMGukB8gDGoKtVE0DbzE1zHlNUJakgpfMvWfe/4GA5gloJRneM
	yv1sqHCYT9W2rowXLSEel8ZkiQUz1jaUUKhSar+o3aqimSgL4pUzE8O5sCvdOox5vyxJ8V6Czx2
	iinox8lqYX0lExhn+VPX/vhAOvSVyFFDJFacPIcQShABAn4s0Opkcty5kLWzQ5X1gnilj2HugHg
	NA3S253FDJyLgeg1WyP+qKmz9OjztDzz54SZj9ipthVjnVQltslfJnKPu2Gx6Qo9+qNSiqAerca
	qdAXK708sAZQpqoFjvWlEJTEmxXvz9j1oWx/R8GO8NcbdJaKOGxRqdXpdd9oxWAhMqXZW8ep1xn
	DTJG3Opi+ymEjU=
X-Received: by 2002:a05:6512:138a:b0:5aa:6aac:3f7f with SMTP id 2adb3069b0e04-5aa6aac4303mr1959888e87.22.1780334637624;
        Mon, 01 Jun 2026 10:23:57 -0700 (PDT)
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com. [209.85.208.182])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5aa5b78b3e6sm2221317e87.65.2026.06.01.10.23.57
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Jun 2026 10:23:57 -0700 (PDT)
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-3965eab14cfso23203691fa.0
        for <linux-mm@kvack.org>; Mon, 01 Jun 2026 10:23:57 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/VfK7Egun7rwqR1UB6Lnl/kApTw5lcq5x3YqQMWZMdjbiupCu0m/DHz3aWy4GAIDsfBwFXC8KfLw==@kvack.org
X-Received: by 2002:a17:906:4583:b0:bef:12f:347e with SMTP id
 a640c23a62f3a-bef012f3d6fmr16123966b.24.1780334260114; Mon, 01 Jun 2026
 10:17:40 -0700 (PDT)
MIME-Version: 1.0
References: <20260531010107.1953702-1-safinaskar@gmail.com> <20260601-enthusiasmus-canceln-anlehnen-0e62317a9784@brauner>
In-Reply-To: <20260601-enthusiasmus-canceln-anlehnen-0e62317a9784@brauner>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 1 Jun 2026 10:17:23 -0700
X-Gmail-Original-Message-ID: <CAHk-=wifX_rrDjRGnDnOqE-usptAukuXKrmuPuVDP5bOCBWzGQ@mail.gmail.com>
X-Gm-Features: AVHnY4KexWf0o1w3H7pefWBidQ5elZSrUhqo_ATAUmEnAO4iwBaX4DnfDRLKUYk
Message-ID: <CAHk-=wifX_rrDjRGnDnOqE-usptAukuXKrmuPuVDP5bOCBWzGQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
To: Christian Brauner <brauner@kernel.org>
Cc: Askar Safin <safinaskar@gmail.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-api@vger.kernel.org, netdev@vger.kernel.org, 
	Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>, 
	Christoph Hellwig <hch@infradead.org>, David Howells <dhowells@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Pedro Falcato <pfalcato@suse.de>, Miklos Szeredi <miklos@szeredi.hu>, patches@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Kara <jack@suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BDC4640009
X-Rspam-User: 
X-Stat-Signature: k4wif1ugfash78dim4ihxqw5uy9pxg1k
X-HE-Tag: 1780334639-976157
X-HE-Meta: U2FsdGVkX1/WbE8M6dbzoinas8vPgQL4vsnIYmZL36QsvcUIhF2CEy9t6qrm+EPgYV8tZdULGr/z4MD09NhfjCFb5NCY5n3IgDBpXLLJ2+tbH2907FA9PYy4UuJ9mG3UYNzQzbzlnzJ88fmi6s6SGX/tCLdMGke6rz3dJtZNndaA50/DJjHD3JQXuWzg8nL60a9HESpghyk3orpEdQ2kRT/BVPrnKvwWnLj+JSW5mzD+T1yuO6m+7R8nVVyeHEYgW8059q9ABYzdPLAWE+CznK+VfAg+sMfiQwTk6uoTRYzUyRyiqPf8+jXiP2owK3VPSVUv9njkf4EMhR7ccfLURNHieVvVqN3LRRd3zvI7r5msIm6Ystn1stQVUJKJb8gTBYprY8wFNYV86VK+uzyHGCMGGSY91dPc7zevUOzW1i8cMhhzp02QzPK0iUAzaFGaYpnoCtH9gUcfFDRIToG/aHP1yCqCVMxjBtGhcaXfEeJOEJIOHBDnmo0Dj60WNJtWoCyQtIDHed1vAmkaO95hilF8d6rwihXBzhmL7nrn30n/FCcq6oMaabIH5XSvfbeDqWYLx6VyV0lfhYEsjSYSc1ZiJU2zgc+U/JXjPFXF0TIc2mzzmTmjDZNcnTQRiQLppditAuoUaXFs5egzNiMufw6WBNNqBfjEF5GG15AYW/7Duay3y0RUZkL7/arEk6mzjwpa0bsOTzAoibVUgRPRv6pApXQzROw9zWHUDNH/jXVbILHaHidVqlHdt6FLxCk8PltadrS4Xj6NZyHJ39MUdkda85t5kNPjHlpWu8UONPsOpnHOhQ9WAzou+xJK+HfnkLByhC4f56yMOV9tj7l2rBrA/SQskbF/OSUUIymqeM8xjQhTZxdAeSiqDT3Cwslvwm92BzdMOoeDbAdZWTDzI+mFu7tstxDibl6mZxfzDwxWHrvvpGwVT015/ajwRFN/+vIdTVr8OQDJYby+T9D
 4OguGAji
 7dbnqSW2o477JjDFTrVjMyASq7A0+qT8IA/LjOceVyLgQnhos9HTZUjSLivctbqHzNxdN1rE2XWfZZ1RAKBmcReE+ssWMEVR8YPWcc50t2LbmQW/S11NuZAkAksZV0CqePTqqfoOO7wKN6zgMZhk+8jWmXY572lZQliuVJ5oW6ggtudbf2rdT2xwA2CtTSX/LTxpyWiYLNGxhwO633vGRpTSAbyCOEbxh2bqqTr2PNbxw7SJj835UULRRxZR90DgrGUyjthDs9+N+TCgZZcEZn149GOms5Tvsxzul43YRAFmtrU1yWEft8KSGFmK3zaQdnUC3p8YfnHY7cX+H+bFBxND0ZmPmK1m2bN3AZ9MYha9buYZg7bKe+zUs3jXhaJUIMspJk32b5ZIp70uLyYdQdEwL9jzl23zraBGrGz3Cci4gIxsQ7XHPSpMeAIH5//e4DIpsyMhp7spauVp50iQcvsACnxMTFOM7Dysv2Au0W1PsCTW+obgDnPV1tQi0yFxX6BwveAeWoyVBebJC9zw5+P4BxQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 1 Jun 2026 at 09:42, Christian Brauner <brauner@kernel.org> wrote:
>
> Applied to the vfs-7.2.vmsplice branch of the vfs/vfs.git tree.

Btw, if people want to work further on this - assuming we don't get
any huge screams of pain from having effectively gotten rid of
vmsplice() - I don't think it would hurt to look at limiting the
"regular" splice() too.

We already have the code to just turn it into a pure copy on the
"splice to pipe" case: copy_splice_read(). In many ways it would be
*lovely* to just always force that path.

We already do that explicitly for DAX and O_DIRECT, but we made a lot
of special files do it implicitly too, so quite a lot of the splice
reading cases already use that "just read() into a kernel space
buffer" model for splicing.

It would be interesting to hear who would even notice if we just
always used that copy case, and made "f_op->splice_read" never trigger
at all.

And it turns out that the only thing that ever uses
"f_op->splice_write" is splice_to_socket. Which was actually the
problematic buggy case.

Everybody else pretty much seems to just use iter_file_splice_write(),
which does the "emulate it with just a write from kernel buffers".

So *if* we get rid of f_op->splice_read, we do leave the case that
really caused problems, but nobody will ever care. Because once splice
only deals with private buffers that can't be shared with anything
else, a f_op->splice_write() that gets things wrong is pretty much a
non-event.

(We'd have to look at 'tee()' too: I don't think anybody really uses
it, but it does do the "no copy linking" by just incrementing
refcounts on the pipe buffers. So to really protect against
splice_write users messing up, that should do copies too, but as long
as it's all "private ephemeral buffers" that get their refcounts
updated, I don't think anybody *really* cares)

TLDR: maybe we could ghet rid of "f_op->splice_read". *That* would be
a big simplification.

                Linus

