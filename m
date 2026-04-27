Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4CFDFF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 15:17:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DA406B008A; Mon, 27 Apr 2026 11:17:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58AD76B0093; Mon, 27 Apr 2026 11:17:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C8246B0096; Mon, 27 Apr 2026 11:17:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3EB296B008A
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:17:28 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D33071B9C0E
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:15:51 +0000 (UTC)
X-FDA: 84704685702.19.59199D6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 281CE40017
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:15:49 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=R526EK8v;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777302950;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E44w0BxQtxG1hjRcNB3Pj+uL0NuFQbo1HT5D2vj6zFE=;
	b=p1AvoCdvJhwcIC3hXZVSY9TRtyV48SqqydaZP7mKMZatiXBz90kIOfTfxuAiib6ZdcMzdo
	ewm2ftedpcor+lbGzCf0Rr9K3Q+MG7ou8f2TwtUsQUkYr1ObITBCmZdDjwEsPtCEBCqoyw
	Ru4DhKug3hCa8cTVGWcfoqLhtmmF8HI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777302950; a=rsa-sha256;
	cv=none;
	b=3tWprpfsqwciIUpP4R1FQB22K1cBX+o9VHp4xjWpstnaM7l7QaSMxbNHB2lhrx3jHIi0Il
	GzwmURCxJA9K0S+DU/4zB81frQRNVarz+tlxTrj92QpUvrH9OYCFnbvCMEQayDXcQeyl5n
	NheqT2E80Og/670OJ5uTvEyaJYYUAnY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=R526EK8v;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1DAFC441E5;
	Mon, 27 Apr 2026 15:15:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14B37C2BCB9;
	Mon, 27 Apr 2026 15:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777302949;
	bh=2g2Ht+R7i6Ddhhl26w383Z9dWKZP676lbBJ41SKulBc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=R526EK8vILjVTNN7jaw1ZW3M5wmU3lWJIWC2UAqZGdzcGbCXVqzY8BPvWTyJFDcuT
	 /uHug+eKdsFXFaHsGa9xQkEz9IOx1++n6CcBN3gt5oEMVnkiugAHx0KYMnDu0xO7B1
	 oR9tpmEpHiWy3sL8rKUS+kaZbyTo6TbmLbXF8r44=
Date: Mon, 27 Apr 2026 08:15:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Yoshinori Sato
 <ysato@users.sourceforge.jp>, Rich Felker <dalias@libc.org>, John Paul
 Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, Alexei Starovoitov
 <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko
 <andrii@kernel.org>, Martin KaFai Lau <martin.lau@linux.dev>, Eduard
 Zingerman <eddyz87@gmail.com>, Kumar Kartikeya Dwivedi <memxor@gmail.com>,
 Song Liu <song@kernel.org>, Yonghong Song <yonghong.song@linux.dev>, Jiri
 Olsa <jolsa@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Rik van Riel
 <riel@surriel.com>, Harry Yoo <harry@kernel.org>, Jann Horn
 <jannh@google.com>, Matthew Wilcox <willy@infradead.org>, "Liam R. Howlett"
 <liam@infradead.org>, linux-sh@vger.kernel.org, LKML
 <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>, linux-mm
 <linux-mm@kvack.org>
Subject: Re: [PATCH 2/3] bpf: arena: use page_ref_count() instead of
 page_mapped() in arena_free_pages()
Message-Id: <20260427081547.4cdbb9a5cade734f143902f0@linux-foundation.org>
In-Reply-To: <CAADnVQJ9JXrtAnFgE8UFK=W1GDeT6T6Wi5zB7g0AfRjU8M4=bQ@mail.gmail.com>
References: <20260427-page_mapped-v1-0-e89c3592c74c@kernel.org>
	<20260427-page_mapped-v1-2-e89c3592c74c@kernel.org>
	<20260427051758.e1b714a4b567917971920eaa@linux-foundation.org>
	<CAADnVQJ9JXrtAnFgE8UFK=W1GDeT6T6Wi5zB7g0AfRjU8M4=bQ@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 281CE40017
X-Stat-Signature: 4meg8od4c5j4nmpamczcg3fassune3bq
X-Rspam-User: 
X-HE-Tag: 1777302949-894877
X-HE-Meta: U2FsdGVkX18BhjZmwhv9qpOlTzihiKX9a6vlFDqGjdxcyt9nChNN7+hOIjJzVQqs/EwjPtxU+6yY7YYxo2T41NPwMMu9lhWHFGRej3k3N+zrgrfxinyMBcyp/NIJdHxKwW0ikol8MLT++n4IYJUcj167JZQ7c7C+Sz6tsXCZkiJsP858b1WykbvuUW8YfKHX2sS0UVhPZIq6gvi+fT6dEYc7fnKL4gq26Z3q/LMzrTEHv4P5QbMqOqo3CpBJbs2yc+fnyVq7Y5Ph8O8furQmj72GUOrftWfcxowPiQD7wmmEdJPS1shBhJoabL/ZsL8DlE5R28xYEKP6FR0+Qnb5Zb+8k3jXdRujbJ9xrrUEoUytO2cZ+Z8A2dTTBgs564WOig9dQfEQzn4hYd2ZKNYlR6ciOpdBvcQ+nt7yGCbylKEP4P7mjmzaLbFYZ5lKzEhifVmed72lmKAQ/aESggl3eOkb61ROKeP73OcPllSZ7XhXw4A12KBQqynDZc0GWWRtSLDQavDLJHUCkpFR2OQshgkssaowZF9F8tdEX9qwZCTPxhp97uq/vQrxB722mB2CFik6JL5arTHFtFjEUppPYpmZgqHAOvOF5Jhqprjg3gWEeIEY/vSypvOt5Bs0Jcu2PS7Oh/YYg82C30x8t4WQF3LfHGn46nZMfswoIz1SfmzvQj8tXAlo8/3QMU/2Wp86CjCTZKh7BNHsAFX/CMXDSjTbLLTO0almp7nIT+xeuGKxqqS3eqPIfljqUtqWsssOwtP54udeQj5Fuh8ZDj9UVrGu4Wlg4pVcr9X2dj30ibXTEiiq65dQF0bQpeks+osOnWiQr0wQ3OzeRFI6CxExzecbC3Kjy8RvB6OCsAgz13AC8u1+c8uRx+DYEyEi51vd4vqoNapofmnqID7gUbBBeO04mj1Dv/n0zVqOq197RK9bn2vAfQl8V2lWgMzcPamg3D/Op+HoyWniT6mgdRK
 d+BAT/bI
 PNObNb8bxdYuAKP/6YhKBaYqJglb/FO81zN7z/lCF0dupsoTdmabR2eQnl8QzmWbzREJmgiq9HrwGF7Gc2LMDHXiYtH+SzNLo3tjnU/uFluubYZYBy/CIVQSZNiAX0CLjf6HyHu6kA75zS6QlUtVgmOHE67ArakOcK9ciVVaZnXDuLmx493NxQBlE+aOR8phmmjhib5ViwA9tPesv+25vjLeZRAVqAO4i+knp6cJ45/PBOdu+2oJDkXyi7vhJaCV8H/Yyb6qaFlpr2z0zxCGgRenvkXLyydBAI1Ri1Nbl/zrbwsPnd6OASwLpOkrGlnk1MVIiy/WscUbp4/73Ejqv6Q/YTjTp+a/c8mieE/xYUiDIDlBfmBU1UdWFxCajPx8e2dNiaSFy8npfmZMN9nNKI+dN2EBeLg0B6Imt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 27 Apr 2026 16:00:59 +0100 Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:

> > >
> > > Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> > > ---
> > >  kernel/bpf/arena.c | 2 +-
> >
> > BPF maintainers will probably want to carry this in the BPF tree.
> > That's fine - please go ahead and add it.  I'll carry a duplicate in
> > mm.git so it compiles.
> 
> We cannot carry the same patch in 2 trees.

Git is fine with that.

> Sooner or later it will create problems for linux-next
> and issues during merge window if more changes
> are done in the same area.
> The only way to share a patch between trees is to
> create a stable branch and pull it into 2 trees
> then sha will be the same,

For a single one-line patch?


