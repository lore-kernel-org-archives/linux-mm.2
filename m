Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 518F0F3D332
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 16:49:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E8DA6B0005; Thu,  5 Mar 2026 11:49:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C0596B0088; Thu,  5 Mar 2026 11:49:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F6F56B0089; Thu,  5 Mar 2026 11:49:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5AB936B0005
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:49:51 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F30C789BC1
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 16:49:50 +0000 (UTC)
X-FDA: 84512596140.23.111CB00
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf14.hostedemail.com (Postfix) with ESMTP id D703F10000F
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 16:49:48 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b="NGZqjg/l";
	spf=pass (imf14.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.52 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772729389;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eNHfHsjGinUs8vAecQM39SD2K85CJrqw6vaptjuUYBM=;
	b=KRdM/F5jjdGg5e4tjTS+OKNDCzadTnDw8MATnD7r9qMpcoTTWhJMpXmS2e/PxypzTUH7DZ
	Rd0o7lpIyY0+BIr3VBtp4w41tiP/bN231waG+9+cLawxQ9LPev24OklAUZfBbIqooFKZx6
	Ia48F0DhB3HKIxJ/oLRXr1icW5ABpNc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772729389; a=rsa-sha256;
	cv=none;
	b=w38KReAnY7sTeMiPuORLdLk5Tbt1tnFqjModcV1YRcgr478FIibzbbMn3rlFhjvl6XKWYt
	+Ey1qxkg88bxik4SmRIaFMo7rl+GREtOa6onVowfgryEI3aLziXb17pWN+Fy14DBQlqeug
	1YcfQxpwVlzXmC0ZLAc9FmPD89KvUEc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b="NGZqjg/l";
	spf=pass (imf14.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.52 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-660be63279bso4164287a12.1
        for <linux-mm@kvack.org>; Thu, 05 Mar 2026 08:49:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1772729387; x=1773334187; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=eNHfHsjGinUs8vAecQM39SD2K85CJrqw6vaptjuUYBM=;
        b=NGZqjg/l1DYFKkBeV0AAdNbZ39earngpm6CX8gKHSMBCiJQz2ZP4jJlmD/3xCo9/fP
         rN88zIwo5epUUevnga7IWMlDROcK6M2+1lFdeqYdeCQOjN/cwxO/UNaVi0uCZsQJ4+Eo
         anyFCQbXkTML3Hanjnv+hXwMstF3Z+PIaLmYQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772729387; x=1773334187;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eNHfHsjGinUs8vAecQM39SD2K85CJrqw6vaptjuUYBM=;
        b=EWgxe0D2be/M/MxrBLSLfysb2l9ENZcU15VC5ONwfH+qE6g+BHKW16xBEB9MFvP13w
         cWKkjnGRxfHZTUdxduGQIiCXeBBhX7gC35dMkt5RwtI74fcNNoEKylxpGhVtxCJI0LGf
         dcUfRooBgYLd+ox7rScDd9xh/H/uvbXF0gfjIk1yU7BmJokab8Pc70Dcxok9D0nl6Ml4
         XDY+oTc1FUdfeAxUx9ph757eac0AK/LbVnU+ueK6wBSTr96r/VgkWjeVB8964OGQ5gBz
         kneYg6e+O6YIBzKoPW0QQna088uWAxq67WTyGLPkTp3gvScj1v8GyxfJ7assHPAq3ilY
         hozg==
X-Forwarded-Encrypted: i=1; AJvYcCX9q32r69wzZoHg7fPEUv84xOo2UaKXuK1FTWUC4Y8t87EKkCy6LO1gfCpL1trfp0H/UQj+L0ggfA==@kvack.org
X-Gm-Message-State: AOJu0Yw74dbmPeNsv77kdHAPOCIuWXLKGjdJtzUEUR+c71St8CuTgtlE
	qvTUlgvdKnfUF/xbs3HZSYyxcfGO957SRl1Y/Il8saMmA3qsmBvZV0cn7r/PUXXZ7vAXrcKWozg
	J0XeYSkM=
X-Gm-Gg: ATEYQzwwGVuQXxwwHsRLipYvAZtanxteXLLwYzBP9jw5DLBIEJImXeoLxmAHIQ55LeG
	ppCn3Ih7xNWKB9N+Fpx5NQqsXDJgS7UIhdLpPfSP3QFX05RwqYua1jpeROO6B4n3+qB7wzKEV7H
	YUCNW7mru40++BiVbPO1R9efCta2QP/Am386LspmZCI0qpVtAs24M89MultW5YO9ZIX1QcUfVTF
	fXz1WGys5vZdM18j2sXjasLcG2Y1idTzo1pDimbOQ97VcwUhRmRkaxpG7B1F2a41cP5LZ3Z/QH4
	Ev4QY7owDOG/LvwX565cjHVzOAneT5jS1kuF+LemiXqezq6fYDS3MPZQ8KFE7tJyojzM7Ywq0tq
	q2YkjB8UJqsLigvxRdkti+pu1HT0o/SWoRCn5uApJhmq/ZrVEC9qlZ6fP8T8hmMQS0cbD6HXY2u
	63nkWTUU9NQYzbxbAUI6db1nK0uNI+PR3Xv4H7ll8X7bwNlBQ6BiJhDzIkr7ReZUwhV64D3imC
X-Received: by 2002:a17:907:25c8:b0:b88:3877:d922 with SMTP id a640c23a62f3a-b940890d5famr198957366b.10.1772729386873;
        Thu, 05 Mar 2026 08:49:46 -0800 (PST)
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com. [209.85.208.50])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b935ac704b0sm925409866b.22.2026.03.05.08.49.46
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Mar 2026 08:49:46 -0800 (PST)
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-660ea6ceb5aso3076899a12.0
        for <linux-mm@kvack.org>; Thu, 05 Mar 2026 08:49:46 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVhPFp8sKpycuToeapqwk6/sR4U6II3ZMLKgBKykGtFB2JswSz+4r1ubCkwzqxSgoKq4wrw4liDJw==@kvack.org
X-Received: by 2002:a17:907:e10d:b0:b94:82e:55e7 with SMTP id
 a640c23a62f3a-b9409e75c5dmr122626266b.25.1772729083811; Thu, 05 Mar 2026
 08:44:43 -0800 (PST)
MIME-Version: 1.0
References: <20260305103941.11f1b27d@gandalf.local.home>
In-Reply-To: <20260305103941.11f1b27d@gandalf.local.home>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 5 Mar 2026 08:44:27 -0800
X-Gmail-Original-Message-ID: <CAHk-=wggaToeRYv6B5L9ob=wBdVW9_gFudYxH_WJDTuhyX_Ueg@mail.gmail.com>
X-Gm-Features: AaiRm537Jv2IcupKWNVngREUNm8d0KvSSjwd0obOsEpercpOSBsTAHZ8PEtbhj4
Message-ID: <CAHk-=wggaToeRYv6B5L9ob=wBdVW9_gFudYxH_WJDTuhyX_Ueg@mail.gmail.com>
Subject: Re: [GIT PULL] tracing: Fixes for 7.0
To: Steven Rostedt <rostedt@goodmis.org>, David Hildenbrand <david@kernel.org>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Huiwen He <hehuiwen@kylinos.cn>, Jerome Marchand <jmarchan@redhat.com>, 
	Qing Wang <wangqing7171@gmail.com>, Shengming Hu <hu.shengming@zte.com.cn>, 
	Linux-MM <linux-mm@kvack.org>, linux-rdma <linux-rdma@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D703F10000F
X-Stat-Signature: a5hqdeqo4sywdmnxiejz51rrqez4h5xg
X-HE-Tag: 1772729388-972458
X-HE-Meta: U2FsdGVkX1/l9LX6KqKwkZaVRCuSzNQaFBlEEQuaw+EI4XQKiataV7TAuHRvtnpsIIZT7MNaoiM7t4KmU/jfj+Saw6NNXINy82pRgtxJ4KYqRkF4JlzyEbAnmUZTJs4vxOr/bsW3odVecLS8Xd5pqfhzYXmQkkD6YqzgZJgIawirdNWyC+c9QqHHoJlJ0w9HZecfhtK0DHFg0NcpVkHu8M56YpVFdSshg5m03vB3ZO+sCQ56s87wBRJEfPdXvvncTeba/y/9yJoC8gs6lpPPD/1vg1XCvmW2BmxjMtwJY7oEDiW/BthLz1EI7xuDo2dm071oxWscomsI+sYrbe+6GGFWF/0GQXlJEysBpxhSHIBYVS/bbHte9uj34R/x/O2aTVaMzGgRc2b44K4wGbkinoMDBzfaTe9fJ/hMbbhw8bfl+KXtPa7HrslLGSpfLbdYBfrvTSCfVzg4JWyLYOewkutJuEScLcOjzZsyhNLTfTOzuhl5sA4kFPMDMZJlmPtG0LGqYXRfE1WG7CzUyc4J+7Vn4Tdan0TR6QTrrmX/aG+X4OGZ8a086aKpJvXlxU7DOZiOuKcLa1Sn7E9aLKUVzUFMI17069wQheort9uovZKwnTNR4UpkMEAWnOIdSazU/hkmd8GxpQQjhAZ+/xeUHc4dj4s4JrCYZrprmaY+ae2j0+iApMWwfJcOjCRqdHwRYrx3eoA6O9+lxE3MKnOtfhddQFOT0hyOjhwzWokYsbYG3SIrtkPoH/RojRjnZlMcOhhb9ow+2Tok4Uf19uQzNsvjSNucrhMEqrWDBjAdDMeSNOEeQBuvF35Cx4HUEkJpMK5gZ7B4u5PNsiJMpRq+akm8C1ItQzc6R0NeZArvhqhjA+JfcsrBO8crH1TaV1DRW9xKD9XlZQmrUZCqIuA3+E4LxlzMsoGCPea68u806DSX9C/rvxsnjlzcLwUI61DJRH9W/uablzM+rzIF6Uz
 JgM2hsXY
 j9P98Nuf2CBZXQmZRaZYbCf6O7XJuERgsD88tedH/5c09jqAbeWvXYvnvcMbnTqVKRmxioxOLTt1cEhJMfZBt/dfgSMoTh0mCop7mLvljqprfHHjb96TU2BPnEkzjbvKHrZmMVWLJ2neM6FoYiB+V5Pwrm3uG1xiOISt7WqRt1H5b+LW1E0W9WipZD2Yb5tEUqPaVknmxkYQuzDOLKiO5uhaUSrNhDhi8pBYZBaqOyWn9DNQJUhaZ6Tyo250YUtG3INNMaMpRNUelVs/kHiPgxdjiSEKNTaKY4SysXrMr27KxBdUR8SyM4qZ7YijDrWnecaTR9Oyuo3aXSamRrfypDrWmHYOwFimz9rsHHQXBcmVn5FMvbkTV4g9C24aNw9UMY1Sgg2VV9VCnbzMXRPYijdOOO3YruOR2g5DxRGwHD/IioyrS5mwDCvZq2Tc8GS+saP17j2dzgkgkdKCO5uNp3K3n0XN0EUlLrE/SHcz5Dfn6q1vURaWlxCaDBDUO/Tewv/P9SsmqQ5E4ZfKZQ3hHEBKFrBxOlYtYJgIwI6CITRYq/CXMUPjgag4EZ+m4Y6HGZSaV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[ Adding linux-mm and the rdma people ]

On Thu, 5 Mar 2026 at 07:39, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> - Fix accounting of the memory mapped ring buffer on fork
>
>   Memory mapping the ftrace ring buffer sets the vm_flags to DONTCOPY. But
>   this does not prevent the application from calling madvise(MADVISE_DOFORK).

I wonder how many other things have this assumption.

Now, many (most?) of the VM_DONTCOPY users set VM_IO too, because the
most common reason they don't want to be copied is that it's a special
mapping.

And then madvise() does nothing.

But I also get the feeling that the whole *reason* for MADV_DOFORK
existing in the first place simply doesn't exist any more.

It was added two decades ago when as a hack for the rdma people who
wanted to mix fork (with COW) and concurrent DMA, which just didn't
work reliably because the COW would break either way.

See commit f822566165dd ("[PATCH] madvise MADV_DONTFORK/MADV_DOFORK").

And that should just not be an issue any more thanks to how it's now
done with page pinning rather than with the old GUP interfaces.

So while I've pulled the tracing fix, I get the feeling that people
should at least think about just making MADV_{DO,DONT}FORK go away.

Now, Debian code search does show some users (libfabric, libibverbs),
and maybe they actually want the forking behavior for other reasons
too.

But I get the feeling that maybe we should at least limit MADV_DOFORK
only to the case where the *source* of the DONTFORK was the user, not
some kernel mapping.

                  Linus

