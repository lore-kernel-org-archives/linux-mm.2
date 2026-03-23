Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F281CD58CAB
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 03:25:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1E206B008A; Sun, 22 Mar 2026 23:25:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCE916B008C; Sun, 22 Mar 2026 23:25:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE4846B0092; Sun, 22 Mar 2026 23:25:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BA1266B008A
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 23:25:16 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 677B78BC0C
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 03:25:16 +0000 (UTC)
X-FDA: 84575887032.16.5D51777
Received: from mail-dl1-f53.google.com (mail-dl1-f53.google.com [74.125.82.53])
	by imf08.hostedemail.com (Postfix) with ESMTP id 57E78160004
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 03:25:14 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=H4THIIc5;
	spf=pass (imf08.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.53 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774236314;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6L7OuggG1xx/psBeZawamh6lKLmj+yBN2DAvG0qZTM4=;
	b=lzXwPIv9Edw1nwl4VjRZPk8XILL/qF+8mBg8ZS2EM+t7zOlZ0tTCHFGPuX9eKATpFI8+Pq
	YuZv7xrnVD9Fnk8WlQdmkqKRxLempxUGftf82K1Sz0edivyub1S/zj243BdbU/i49yOE1/
	K0nONGCscvMa+vFJzXpjGFq/ljLDxlE=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=H4THIIc5;
	spf=pass (imf08.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.53 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774236314; a=rsa-sha256;
	cv=pass;
	b=wobQ7UxpuoSFZASqPjWeDvoS+xcqTHeU7cyDmZJiGAK1y6BpbWXMJG0DpoPoePVwYPgTOk
	ogL7J1oO88tgxZ/X1GiI3gNy7lRY0ufzUbx2/uIB0UtJ3RtuCpJ2P104eSe3d0blbGVKEE
	suAaDx8Ms4Q42gEMzWmncqvIantDPkE=
Received: by mail-dl1-f53.google.com with SMTP id a92af1059eb24-12a6b260693so195811c88.2
        for <linux-mm@kvack.org>; Sun, 22 Mar 2026 20:25:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774236313; cv=none;
        d=google.com; s=arc-20240605;
        b=Bq07izwf62Gd7aAEHyxXQ/ZYZDMTqKuOVpsagNPJY0XOAtSD7TYOVni+vVKT9Uk0mz
         S1mqrT+aEtzvuGxCeFX7XMvD0Gbo2CzAUQAAwx/rIKi7MlYWb2P+/pR07JzTcrqKwAzf
         P9SdOyi+aGXcSE2vIm03RNgpz4MUL71dTUZWUGrqmxC3xif1NfbcRffD1bxoAklCi5TV
         6d2+ZSUfl1UgVyskpXETBPLcEH42IFMBURGxXty8lvPDDc9AIXEU1ifHllzuR2zlwQJT
         XmH29FTh0QM9v0dEgkDkIHsiNZe28wHByeOcBN/9ZurCHoRWMmSqBwkteV/avLtOB7EG
         excQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6L7OuggG1xx/psBeZawamh6lKLmj+yBN2DAvG0qZTM4=;
        fh=3pyr7QWreBjeFH6gbtGM5MdPaNs4z3RG3I/Uyx/knYE=;
        b=J7IgPrZTbGsF9f8e4M8Lz18Aivbp+D4gINalq8sj3cXu9qugp2gMR8fFg8YxS+7lqH
         wlYugSMUMwQjjkoQg/hqzeyPebt2RVZ8Dgok8s+VdUUCBskI/xOz5WpSBtpmPvLqYSnc
         higLXpwE/5pe5t4AZalxiSFvMFPY3DuKqq0JICR2aVnDKCs2Db9Ioi11nzT6Y7obxlNl
         DmJ37tzHwR3rvdVMCGV0botPHK7cxh2shYgczeq9iXl7i6kHMyxuwFZ9IMt2pMMgmXUv
         JNbRmzQh3TlIJicLAUz57Z44a1k/EXbqu5JXdv6FU1HJnSKLtx7xs2g5X9bOVkKN4Htv
         a71A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774236313; x=1774841113; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6L7OuggG1xx/psBeZawamh6lKLmj+yBN2DAvG0qZTM4=;
        b=H4THIIc5p6OL1RXclL064tQMyJL3MC9jJJ1wnbo7sIfp91Cw9kgqECnK7KNBdCJ9hv
         hBXDO/sQRBBm0iaE9DdeoOZJI5iHLzBFKWYBgs2QoG9kf0W+VEw1ouVoWOseMoEe7mKg
         AXij1T5kMxVHkd5tdjxXnZxqKK7kTEo6GYsUPo7kg0/A0c3LiD7t8uVtYDsH1UyYmS/J
         nGOKVr8SKN2hri5n111u+UJzDCWDM6HXc2Vwd/y87w01NzKCnjigsUcUCtFDBX3VEp5H
         NmmNjc9T2PYgABiPMf5NJrEBQU/9OUzpn8m8emuqlX0T6yDnBlFN90cS8fuBYil0xFD+
         zXzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774236313; x=1774841113;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6L7OuggG1xx/psBeZawamh6lKLmj+yBN2DAvG0qZTM4=;
        b=l3t1/nYzgsKb9tVqwUUjlPEe+xPGxvNOMSys/UCZHk0RtSfqKkYUufEX4BDKEyE5SP
         4Ti89c1HCYM1KiZqi9nUwmIUwKVtjWQO8Mv2ZMIgLHrVTZUmhNMvOaO8FDgZeVv/lxqi
         aqq8LaMWj1LDyzTIA/Aq2mMvtl37NBFtyQ1pLoG1Y+1EgwRIeFGSDIvOEv5Um+B9kmHq
         cJZY3E2ZS8KAsO64xra6tStTIuUhTSEFesQgFmRGnvprsOmfIUQybdK3EsxybbrjZLDV
         rqqzR/HF1aR+1ahV9j6DrKnnkkM0oaiVtmrg/g7PYfRmJ/L6w8D60GPwcYlwB/wLcacZ
         IJhw==
X-Forwarded-Encrypted: i=1; AJvYcCUli6Qv/KPA/V+pWdRR/w3GTbA2o8ce4JGS6MVCqHdrXksMNhblYVCaY7kUhDG1DA9dNzgELJRGzA==@kvack.org
X-Gm-Message-State: AOJu0YweIhJskLTkxCFX2eCQWoqIrBMVmFrA8VgF9WFNl8qzcydbZXAl
	Etlc1sfiiGvk5lENhldwXL3/m0Abi8bIqSRy+2Y5aatcMhlEcmZsF6HEYaaLJFWEbzj4+FQ31C7
	ioOelSJEFaT2mJI/NH3nPwMvJlRP96wI=
X-Gm-Gg: ATEYQzzv1NBXUU3i/UTYwFwOx6BT+umt12Y99eIcGspszzMfH4zNAXHjq/cJ92dzAxz
	7Z1d+9c1vQpTLP4thdpX+55Yt5El4QAdiWjzDcffHKR0fXmdQIoN4b7mFaosK4JTh+XfDUt7YH5
	45uslRodFOAOPWzdeCBMczxUnhreS4s0kFhyxTjgt2/V9deFW2dJPxJd7CiWcby/TDRAR2NKG8C
	hvK+wWaA4v3IQSu9TA+BeOJ7Y3LXgH7VFmYVruzbOOvLKExlIp+/06P9M+EV283gKTII4KcDHEK
	35QUf4c+9/2APXkJFzzh+4m+IjGYO1Q74Pb2TWWQ2PZTk/YFQWUf9o+RR4BEDWXflSrpTdN3Fh/
	WvGT1dkK4QqFVKALLnsNac9k=
X-Received: by 2002:a05:7301:100d:b0:2be:1946:858b with SMTP id
 5a478bee46e88-2c10970d302mr2034525eec.3.1774236312928; Sun, 22 Mar 2026
 20:25:12 -0700 (PDT)
MIME-Version: 1.0
References: <20260322192159.88138-1-ojeda@kernel.org> <20260323000327.111235-1-ojeda@kernel.org>
 <96287f3a-d245-47cf-b7cb-f821451493d3@lunn.ch>
In-Reply-To: <96287f3a-d245-47cf-b7cb-f821451493d3@lunn.ch>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 23 Mar 2026 04:24:59 +0100
X-Gm-Features: AQROBzAuhFHkGwwSKh-Ea07cCRjtb6eZEQluwHGIFmDfJPfdFW0BK0DaJf2FJhk
Message-ID: <CANiq72nwSWVDRqm0Vap5j5X5k+Q-wq8okQ9d3KUgZt6M4CpW9g@mail.gmail.com>
Subject: Re: Re: [PATCH v2 0/3] Inline helpers into Rust without full LTO
To: Andrew Lunn <andrew@lunn.ch>
Cc: Miguel Ojeda <ojeda@kernel.org>, a.hindborg@kernel.org, acourbot@nvidia.com, 
	akpm@linux-foundation.org, aliceryhl@google.com, 
	anton.ivanov@cambridgegreys.com, bjorn3_gh@protonmail.com, 
	boqun.feng@gmail.com, dakr@kernel.org, david@davidgow.net, gary@garyguo.net, 
	johannes@sipsolutions.net, justinstitt@google.com, 
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-um@lists.infradead.org, linux@armlinux.org.uk, llvm@lists.linux.dev, 
	lossin@kernel.org, mark.rutland@arm.com, mmaurer@google.com, morbo@google.com, 
	nathan@kernel.org, nick.desaulniers+lkml@gmail.com, nicolas.schier@linux.dev, 
	nsc@kernel.org, peterz@infradead.org, richard@nod.at, 
	rust-for-linux@vger.kernel.org, tmgross@umich.edu, urezki@gmail.com, 
	will@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 57E78160004
X-Stat-Signature: tz46kpwrric1x4q3dcpeab93yerzuqx5
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1774236314-762317
X-HE-Meta: U2FsdGVkX1+ahdzcQWcAP27uPt1vE7WXzKBPxDeELaTOegLogRVMg0Z93Y6Dq1+UXFoN+0kDviOTmgpGeO+NDt1FTFUFELEU2NNnDGSfbU291flZK6nNzuX4BrHg5pStNl732pQilibVLdO7yZ/mKXB8wy9hrsnVzyMRZFMqQQAcnmdB0Ufd8jQYo3qreXgm/W46kGqSClCbiIxCamp05IrxVFytRqFr2czCqE3EYdme9zOTg5BqIMrZ8hFUV+QsEY6Bi68QcTQI0zeG3NJAXUJFse0ZMH47aCqb83G6gFGOc9/Uk1C2R+XFSewkZ5Tx8c2DaKOBh9+0xe99KzO46yQGMud21tmUod4I0wycEk5i1TprjsmgDEHxQW6yieH946HSQGusv1g/MLWryru1ekLdjI26bGMhXRr02cdDoOvkVlSVvmXCJsxuBnbPMEL1XnUfSdBNYkymDypxFZD0M/KwZDhWsVkmibC3kUd6JTZC54jaGQU39HjdMm0F2VY+DkZ59DaD6HI6+JgZzuobpVy7TugcLygRu3MigW073PD+jbGbuR3dg9XcLpnvlMFXb/lIdYB3+oZMEynG3Zg6JOo6oNZOZ1/jzncp3YHv8gDWSP72cpveCKN5UitloXQJRWZE5V7eIYWVbY2hN3BHsDhkJ2YufipgtHTxhajE5Z/URWunDcek94Mz9MSA237815yfU9eyQYHi9AS/9LWAgeWVaMixv4KAuEaXhUGucykvV93VxfMoWTHY0JkNWpUhxUb8tzmLmLt14/cCrZM/B9a2sdHXK/U0L2n5em+tcj/sG8ZbeGinIiq1ToorbY3U95DaLZY2DQN30pioW4Xbx4rYK1/HkYrWppPIneyNSuoLHqybYaxAWMrERbV4PCzOfgOodBsJ3q8wTMn25R1XNzqTFlulUx0rVdBs8Uvpi1GEo8NYkHmcVq0NLmj+18gOLtDfo3y8G7XJxLYyW3s
 0cMHcRqe
 OzRX4zHwIGvfN36fpj2/EasSZEMJIcQO6A7qPNWABmMNmQsKXOc+B7PdWqc5hS7UGaa1yAe1YJ8D01c6eyJu4JTbUSu21wVe9BMl3AWgvj1mTW1TeuJx8C0Q5FFVuOJRRVGzBM+c6aWC0//uthzGR1Tem4D4VQ+n0n2keAw1ZgUdnnmIEusRRxGusaJWa+43GFjdcdCa2yNdkQ3oYrjXgC3LzYG62yKBX77UEFUzT8XD5wE/yIJt3N5HfRo2wyaXUM3BJBAX00emfAXChXYmpkS1ohKDiZsFACHvFJR4RxYVaEzwjzOOkHJMX3+RB4/XEq4jZTH6nIyEkJkfWzy7/hDsvqOgg+wdTk1i3tgNhiUmSnjnLoxy4ITL0TQ82UamqxlUSBhT9V4nZf+Vxdr/CcNVuzsd6QELWRYV5YODJu/Q/m0Jg02U3uMzvWMfEXtZrLXct5jIzVW62TUqOCUUGOclDyg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 23, 2026 at 4:04=E2=80=AFAM Andrew Lunn <andrew@lunn.ch> wrote:
>
> Rust is already fragmented, because it does not support all
> architectures. Do we really want to make it even more fragmented by
> having some bindings only work on a subset of the subset of
> architectures?

That is not the case. The `depends on` is not about putting them on
abstractions, but on this experimental build feature, which is gated
on `EXPERT` to begin with, because it uses a fairly exotic approach
involving LLVM bitcode, which carries potential pitfalls, like the
mismatches on the target string like one of the commit messages
mentions, and possibly others.

Cheers,
Miguel

