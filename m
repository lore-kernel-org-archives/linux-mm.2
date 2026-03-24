Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91101FEC10C
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 20:28:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04FD06B0005; Tue, 24 Mar 2026 16:28:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 017EE6B0088; Tue, 24 Mar 2026 16:28:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7FA26B008A; Tue, 24 Mar 2026 16:28:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DA6C46B0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 16:28:28 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7B1031B7DD4
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 20:28:28 +0000 (UTC)
X-FDA: 84582094296.07.773BC25
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 74EC5180013
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 20:28:26 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qEQ6Bvve;
	spf=pass (imf16.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774384106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EaoaOeUX8AqjvVbZNt08iXK3Dxhpy3xpIWd3E46BrOc=;
	b=vb3O0u82JFp38Z6xC7R5mN7+L049OkptlRI8goNbb/BIw9nbinlRwj/58cRIMBi6dYqLfv
	RIRQKsmtF2udngfdTiQovnu3JStSWAuLqUnpYv1SFqoGzhzpHZUf5OC+BBEEgHLq+gGUm0
	wAfrIt5bn7kzrBLhX5q7uZqaaloQlYU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qEQ6Bvve;
	spf=pass (imf16.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774384106; a=rsa-sha256;
	cv=none;
	b=TuhhjaP/WLCMXLts1oN3ZOdhPA1sl6WxSjJ5KNZFI/7B8DX81tWRyW3vhcbeWiIOu/HHAf
	qXDxoDbmDhrSnOatpaMrkPm6VXSlfm7WsIRfyWWz0YJgpEk1HsnwhCv39yxe4e85TlODP8
	1jsBkDVgAasblbNjsv14QfFgr9Wx8Lw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4DBC34453B
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 20:28:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 159E9C2BCC6
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 20:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774384105;
	bh=EaoaOeUX8AqjvVbZNt08iXK3Dxhpy3xpIWd3E46BrOc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=qEQ6Bvve7z1gj+IXfBVW9W2pdNfFAzOP8m4dc529uvDttkYLc6j2V1KA2Yt+3TjnF
	 gmJXLXquo/GmHQdHo+/Yml3XJL/PWoNot3APu221nm0exgxGvdfNXJaVj7zCQSF0Z9
	 TbOqvKHYGPh5+jYG8vsKRGT0Ujnl0j5233cL/sSJDOXxbkX1TJe/TnqDOHhPEAPlsk
	 EEb8tUCMCgR0XIFxzFh+E17Wo0E0hH2MQTJlVUp9j4wcJgJArVBhv/MmWPcr86B81p
	 I5OIm6DMeezSf2c1MM0E+dmS8tzzJHBzLGRAtJsOuy+HJGKSx6N+j+4T8GmrrHVdj3
	 PAFz+CNP8DnsA==
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b97ed4ad579so671073566b.3
        for <linux-mm@kvack.org>; Tue, 24 Mar 2026 13:28:25 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXDoQV1RmfpcFvJfI5PuiIE86FyjF/W8Pw2kJakVCHWKq/ZIj/uu8OCiaS3guo3v9VAMzGDZTOREA==@kvack.org
X-Gm-Message-State: AOJu0YzMs+UUtNDRXl0OIpliqhA0tC6UGy0wnRO6zz9FJ54032fkzS+p
	sRJBw8J+79UGubcOEJzf35jE0H1foVYFlB4/VXoQe+ibn6TjCOeMO/cFP2GDDlherh71GxJbKc/
	Dqm+4RZyE+KlmmSLg2MKeV1TmNOJ19yo=
X-Received: by 2002:a17:907:2da1:b0:b9a:7d8b:cda8 with SMTP id
 a640c23a62f3a-b9a7d8bd67amr54892466b.42.1774384103812; Tue, 24 Mar 2026
 13:28:23 -0700 (PDT)
MIME-Version: 1.0
References: <20260322061038.156146-1-liwang@redhat.com> <20260322091851.e965d3a2f0d6af5bd985407f@linux-foundation.org>
 <acCyPNCBoTGAJjfs@redhat.com> <CAO9r8zPxUv5V+VKEBuyacJUsc-UWh7hGc06yNQntY2GcUJLBPw@mail.gmail.com>
 <acKAr0TYzuYPxH4A@redhat.com>
In-Reply-To: <acKAr0TYzuYPxH4A@redhat.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 24 Mar 2026 13:28:12 -0700
X-Gmail-Original-Message-ID: <CAO9r8zOCGWSX1+t8-5qe+04UZ6i4mChPJ8hkpiS5Z8pAPZ0sZg@mail.gmail.com>
X-Gm-Features: AaiRm53OGDgI98_zONp3zzOg_O6qapPTbqUwmQVzXx4u18gME0Yx7R3j1RulnCA
Message-ID: <CAO9r8zOCGWSX1+t8-5qe+04UZ6i4mChPJ8hkpiS5Z8pAPZ0sZg@mail.gmail.com>
Subject: Re: [PATCH v4 0/7] selftests/cgroup: improve zswap tests robustness
 and support large page sizes
To: Li Wang <liwang@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, longman@redhat.com, yosryahmed@google.com, 
	nphamcs@gmail.com, hannes@cmpxchg.org, mhocko@kernel.org, mkoutny@suse.com, 
	muchun.song@linux.dev, tj@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: zf6zwprbjcj11c6qr5jrrrfsupjx8xau
X-Rspamd-Queue-Id: 74EC5180013
X-Rspamd-Server: rspam09
X-HE-Tag: 1774384106-160518
X-HE-Meta: U2FsdGVkX184hccldkmKkiUVqJ/ABuyi5sJwFenggdhkTDJyQHnLubc4wNbQWcMi3x8uMn/1ktSjXwMOW43ejTlorTh1IN+gY/ygPcTxyUTcvJ7Wuc6SnxaURLsNpp8eMFSMPkP0XV5ao+nq4ERy8U2F0jZCTrnowxZQ0awcpRbtDt6npkZUdftJnvXI3O2ydF8OyAOSD2cArrRBT+3HfcIZbejqKDBBjO+Z+smSxcvR+B+y7n0WATOmJyQ84ldfbC/nIf+mLT7fP6r3rq5kmym65StBlbbxOFSdTf9jr0TlQeKKvZvv6JABSwYnUwLfwFkybnxOjVz7lTN3XLC7IjKyp0pu78RSCCroYW+961FHrmSRRzPijkjDZ3fPX8mM/XXx019+oX0iOphwDIZqOQWHQhINgC+fiOCwHP7J8RIvt1kE/i/UPTAJ1F532KhoPc/ZvHJdISyl4kQgNo9awKjrcR5Vcdg6zvPf//OYLEeuSm9TreYFw5eqSzoHSIhvw1W+2UbGCAkJhKKxSDUJ8rNmgQQ+pGVu9tWskLBJDCVyVcnDb4aUT0gbpfQITZTsbUox27rHQ4JF9/nls1hjoNw1cyGOdDRE97Om1TZQFqzq1evkQBS/iMZQfFZLilr29uKbgGq3N1ACnEKQujnn2FHcNYhlUukSQ4EmZbC8043HZ1k/Q+zKgL48eUSAINbwHjb0foEP7SiJqrJMhb9I6nZE/Hv+78H8NAiPfmzl4fo5FNj+3qYRitwTQuIAYB7jyxbZ+hA59ZIxfWzTOM3Z32BlcuhDiMDXYP7tBFF1Y6VBYpZdTWU88AiHZo9JjQreultFmYFFV3HPS6kjYPGz8xPw4dgzBH0NS+agEmtoqwQUQcdvQc7mn/CD/+yTIwwV43J5/7hqNLOPTgTC/LukS4fekLalf+SbbMtj7ebm322fvFg+q3P/2yYLLCZUe1SodS6hQL85W6kqSaGexRW
 g+zwzoqz
 HEy1Z14isI5sQF8T9vnaDIxU8xldFidGAlwQ035oXcuUDVkv1ABERhjx90irVi7XA1+VVanL0Uhs4cOX2INkyokkkK+/3I6HBNi10nYN4LjZbwwugEfgpGBNdM1VSAYf0ajU/TtzXTd4WYZSSsdtUoVF0cpPwIIgxJn36IBqYSu02E6BQEsveXtEPde6mPaQhXH6ndW8H4M7OWrkRLrqKWTSbUdHHc8BJuFreKrsO8SCXJOaJZNV5Gi/COK5qyfIwU3xOLBDve75/HkED1Vc3AgMhJtPqRBV5e2/Z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > Sashiko claims that 512 pages will end up consuming 11K to 15K in
> > zswap with this setup, do you know what the actual number is?
>
> Not very sure, I guess each 64K page contains 1 byte of 'a' and 65535 byt=
es
> of zero. A single page like that compresses down to roughly 20=E2=80=9330=
 bytes
> (a short literal plus a very long zero run, plus frame/header overhead).
> So the estimate is roughly 512 =C3=97 25 bytes =E2=89=88 12.8 KB, which i=
s where the
> "11 to 15 kilobytes" ballpark comes from.
>
> > Especially with different compressors? If it's close to 64K, this
> > might be a problem.
>
> Yes, good point, when I swith to use 'zstd' compressor, it doesn't work.
>
> > Maybe we can fill half of each page with increasing values? It should
> > still be compressible but not too compressible.
>
> I tried, this method works on Lzo algorithm but not Zstd.
> Anyway, I am still investigating.

Do you mean the compressibility is still very high on zstd? I vaguely
remember filling a page with repeating patterns (e.g. alphabet
letters) seemed to produce a decent compression ratio, but I don't
remember the specifics.

I am pretty sure an LLM could figure out what values will work for
different compression algorithms :)

