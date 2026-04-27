Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5CDEFF8868
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 15:09:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2235C6B009D; Mon, 27 Apr 2026 11:09:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D40E6B009E; Mon, 27 Apr 2026 11:09:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C3576B009F; Mon, 27 Apr 2026 11:09:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EC55D6B009D
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:08:59 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9FE0C1A1684
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:01:20 +0000 (UTC)
X-FDA: 84704649162.25.4C3A157
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf15.hostedemail.com (Postfix) with ESMTP id CC3FBA004C
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:01:12 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dpfoRKwT;
	spf=pass (imf15.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777302072;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IsMoDiMZP2yl8KNjLXtX/OQcgCLqcJjLZJHfEPoEHys=;
	b=FR1uY7tuNqxrLQ1X1zs1Trt2SBtE4+uz1cvTR16E8/GOuoc83hek40KtW8yxVe0BHleLzF
	QhDFBGahL8lMA5qXuwkZbOTln8qg9sbGCl25FSYBZZaZ10QIvQ4Z0M7MPnI1k12vnGpPcr
	oWdY+6bu7VsRMaUjWQAs6O58vqsGFuw=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dpfoRKwT;
	spf=pass (imf15.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777302072; a=rsa-sha256;
	cv=pass;
	b=xuhez2d0waQTkUp/JddlGxIaTQpMT083GbgzicN4Xn8r9NSplMkVpH323jBN4TmN01IpSD
	VC5AYssveqZsqFW4LoTdEbU6VH+ZNhnWT4Qu7oWbch6pRokWV/0RH1Yuw7GRcI7W8Sx9/I
	OYiN3GQcZSfRn9Hohy7X5UxtjuxTiQc=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4896c22fcbaso76511295e9.0
        for <linux-mm@kvack.org>; Mon, 27 Apr 2026 08:01:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777302071; cv=none;
        d=google.com; s=arc-20240605;
        b=T5Z9/jW8eW638qRpTDDpFKhcIl6VfgXnvJbX7iC059sCo1D8gAwB1h9EBdFlMH/vTu
         E3iXbxQNlS5uldufP/twrxdxDsom9tUzNyvl8AmqkFfy9dXfid6/eLvuvdfAeRIUbF6G
         QQ+rWq80dJ9yClNFUqTmCE5rnLyhE3F9h8dT4lLUZjZbTqyE3gMXBSfNAavQVyeNgRtL
         LhM/HFAJ5nxJfYMdXP1ZtlTr6+L/gB9lk2l4pQQwAqt6zr8zmq5IpT5iXDMeOad0UsPi
         7lG3m/dqR0M7IFUC/QZpSyhGCh0tOqKia7hPPi4yaa8shvukuhbRNbpalcblAbiMbxMW
         zDzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=IsMoDiMZP2yl8KNjLXtX/OQcgCLqcJjLZJHfEPoEHys=;
        fh=mQ5sfqKlyL1ExHN4Q4KXbyIwafdZEpKgYqLkgfQEvPg=;
        b=C3Ws1PA2qQE9wJPt0EycK1n7kKEIrey8qB/nxCg6ki7MVv3Hm4pC02KK+U5BOOmvNu
         QcVpQLvHjFd0sOSmPYe1i/t1PH9IdaDCPq11C+TCSioAR7Q+ffT8ZFwIjAsOlkyhTBCG
         oqd2UbBgCs0SfFQs1GSdxU56WBMiLD9I3QFTnn5vnId+dXmX5FowdVON+pypiy6etpN6
         ic2Ff0+NksymtuGAflwLjyN4vP0zYmPgTX7HEhduG4xl0A+DPPx/IuBPZdm1qIHLM4gT
         BUTZQ5aB9Rb9yO6laYrGedC3ese1Gyn02MPgabzkUdT3UMcTNDWlYPGOfuq+pDF9A80q
         kepQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777302071; x=1777906871; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IsMoDiMZP2yl8KNjLXtX/OQcgCLqcJjLZJHfEPoEHys=;
        b=dpfoRKwTnNDB0rU3d/f0J6dZx4M9ih/ox3VE53qDmn4suDmXiJg4cnXKbIXFAKzMKK
         rH2GwmwDno+pEbJWRPYEosbMIyssuI5F3yZyAZJyUjfdkdee11h8hnjeyT4s+hYI6uJY
         GT8XSGgPacc5MZwadWtjPMR8FStTxPACTW1YfCzsB5qBf2hCCX7B8gOr/dBCnAhRBOsK
         tC0Ma+3R4944eRP58GAHQlya0JnSKQ21Pp1E6rP0w/YX+pZmmSkELD4+Jxav86ApCQbS
         yVJ6qeD7LDQMRo04zqTCUJk/E3+APhd56wLUTO1N2trsQX4ERUmtV01bpcsqMiendRJ7
         JcBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777302071; x=1777906871;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IsMoDiMZP2yl8KNjLXtX/OQcgCLqcJjLZJHfEPoEHys=;
        b=nHlTjghittiz1eSS6d316Jc7maNk+QSz228mdIcaLcgIm8ORSvTqB0L/0hlMDZRK19
         FM3c0qmi20HWKQimC6eBiIG53p1O0x2SzsqpKc5x37ro14nZtfqKGDippciRn7i9Wbqs
         Q2Zun0hpN5sxKMnsL5zURQxe1wRxpjHtZUDZwIT7fnCAYzwc3ePZl2t6584WxeWUsK8c
         uv3wBVt8j8yJo1DSXtc3dSvCGz9w80Cl5J7MPeqDw9caloub5ci4iTzQK9cgmkTByDqm
         P216B7xbizouygzrb2KTN3m/cOZefFc2yCbYcJgz5K/gwNz7gBmx5mtOIhgCpqtOUd8O
         cq5A==
X-Forwarded-Encrypted: i=1; AFNElJ9ziZZfFPZm95t/A+/LCvMv/vQB/mt2qJOTNUzxHNqLKMnFapLPhe3tHb4MH0ro9YeyABBF4Z5KkQ==@kvack.org
X-Gm-Message-State: AOJu0Yyfqv8lo22+Yw6hpI3HzcBgU5RKlaxW+WtzUqqjJaXBQMewrHwN
	4TujB/tIZk4q/RPvW//GLUzfvTI+yUJ+RAgAV5wVDML0FS20RuR7tDiqqpEIDskL7CfYLoSJhVt
	hizr/XV2aOPE8SM6N4D+vqMXdVZm/mKM=
X-Gm-Gg: AeBDieu5vR6pJ57h/BefnO1+1/RLEdSO4/b3X8mmgBnNQdznNHSVLZO25VcGL/TfL3M
	xVNHbw1Z+zsdwIAgFIkPhzJKC3qKGjprNxrze7MDBqvjrsY06Xtc1GnOpsgQGgz1d22rqjh86s8
	t0+eQWfTHch4o29b8I8dWhwCDCYNKnCRod4ooAIGc0sfeJ2we0qWTEeGG4Y4p6QVE9gJWiJo1Iw
	xMJ4PWxtXwiT7743GDWhoFEd+WLTo3nn5fYGBNqV6C7z3t2Au8rMU8x71cqgV/6fxLmkIqKM3/P
	axSAm6OFnN5Xk+Pu303ebTCOXuFTT36m6cFTw3mrlvWrB1IhI1NBv0Lj2ic6uSaimGzb1U5O4cP
	Nh2M=
X-Received: by 2002:a05:600c:4e4c:b0:48a:58ae:9938 with SMTP id
 5b1f17b1804b1-48a58ae9f69mr423287055e9.19.1777302070487; Mon, 27 Apr 2026
 08:01:10 -0700 (PDT)
MIME-Version: 1.0
References: <20260427-page_mapped-v1-0-e89c3592c74c@kernel.org>
 <20260427-page_mapped-v1-2-e89c3592c74c@kernel.org> <20260427051758.e1b714a4b567917971920eaa@linux-foundation.org>
In-Reply-To: <20260427051758.e1b714a4b567917971920eaa@linux-foundation.org>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Mon, 27 Apr 2026 16:00:59 +0100
X-Gm-Features: AVHnY4IasoXaoqIWZAdmFU7XS_Idge0ITPUKZpISd1rL0jATf9af3D4zNm_fFNY
Message-ID: <CAADnVQJ9JXrtAnFgE8UFK=W1GDeT6T6Wi5zB7g0AfRjU8M4=bQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] bpf: arena: use page_ref_count() instead of
 page_mapped() in arena_free_pages()
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Yoshinori Sato <ysato@users.sourceforge.jp>, 
	Rich Felker <dalias@libc.org>, John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <martin.lau@linux.dev>, 
	Eduard Zingerman <eddyz87@gmail.com>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, Song Liu <song@kernel.org>, 
	Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, 
	Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>, 
	Matthew Wilcox <willy@infradead.org>, "Liam R. Howlett" <liam@infradead.org>, linux-sh@vger.kernel.org, 
	LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>, 
	linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CC3FBA004C
X-Stat-Signature: fh6b5o1siygjorrrf3yp5kpgo4se31io
X-HE-Tag: 1777302072-932882
X-HE-Meta: U2FsdGVkX18E25bhUXqqXBoXQl773mmYkgEAsFMYTD1LTpwOd8s+YN1QQbmZtd2R+WchkkPP79qc+dIYE/ZDwvJNksHG+xXP9vmld+W6VYylno9xvxMEgQO7HBOzLUJwTe47T2vVvEl9kxegFj8gb/SRD4ud0cDMWmdZQkSlHdng5ZKIKjz4owMe2PEOovb6ZD1RsX8uGulIsdmYpOMBBonT96TY4QrUej9aG9OQFjWEmfjr8PCfaaX2Kv5SNKSAVmMwXREEdJlgJEzGfhkgIABz/SZqe4ONrutPT1Gc/aK1cUvHHTc3kz7M2seU8zHcUmOXO/mmsfqsVjWvxx+rK4epD0UCXFVz6wV287szfEsMsnn2p5tuQfSb3TkoFEbJdQ/UXOm0GLky9AWNcjVVLnXs1YkLJIHGJyROXweZufztqw9RFswfAl690PztljLGCc11RBIEXvCDzdXgvqtC+DLUEW03PDy7NXfJl9R1q3W/fTi8k6o8YosE6PbskxTx4KwItmQ4rNNsZQ5/DNAsoUPUFtpymnSvpFSMYlVLfTbQ4JE3/7AO/X0yYVqd8wtkO+sMmiDYoksq67efgDUHv1TWEBhbWwm3UHc9U6GyNApdc41+DxCacJMqBrDXGc+RmhSOwRHJYID0fTfuAoF3POzOd7vxMO7QKUhFAmpUWXHFFiA/Dtem8Ph+4g8ulhGGH6FuOGaoixX0vBiBkVWmKXPSDbyzmPG2I27Nddqp6/g4WQp0onoBAeneN/m101NeM38Z4ShEXPLTj0jMavyI1qxbVxZ9He9yhq5ilOp5rzz5O7AC8+tw5YEMq3XdR6E9nIB8dYXCpthoY/6sKt7v2iwpJBzAi6uvrye7TkJp3LUzjfBdIslNFkdL67rjnFOu7+IFgQgmWELLU3QRdt1KxqXcy70JEWYvcwroz5c6K/5YpAe6uZcfQZVAM+FvUZpbqPZdD5RYt4BHDShfgOx
 +C5HJV2L
 BsKohMn6yuy/lg4i83uZuD5nFO0KNnkm8PCvW07ZQJg66W8z5Ici4LSji8ldRf23F4K/jZvFzkChmYHs1mknfyHMmsg/Oov+XlHAlRoJAUB6pjlvcwpNF1k+0M7fMIwFot1bKjiQS1Z+ifRW30VzpP/Kam8ypUGdnR43Xz+myuGdSXXRVMzAgoiNWL3qLiHYtr71kol+a52OHS9cy9VbZwyOpx8+fgsUUpGPg+Q5SGTIazijWGTJ8q+nkAc3vppOxh4nDhFes7DyzaSFqNAU9zoag6u+D4IEP0Mm5dSSR8B984bjQ/rlJk3oKBnLXS7QBNwr21O7egRuuOdyAEucERLKxD4lO+ia5IIzK/3SuqLbL/W9vGjJ48g8f7Sfdf/9YBubtbcZuJ7h9y8XcJ8dE+0u/9lcwXFwx3jzF2eT2mJ0ZTaAokzw32TfOVeQlbso3ZnieSIqKwh293rnk/61YTxgVgao8mA4b2CeBfMulonOa331SyXwIKfF+IeI+UwuPwW1Yrz4rWLksh30Gl75pI9Ll+O9Wx1gQPpEXJ8/wjGt2xi/bs6k6c79zx/npMnFbvDRZgsmSkqHoxkYeLCrnNygh4Wut05UG0p3q2qglZf856fKcV1DRGJ0YNXUQvpsRFwprh+xkHvPzyKg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 27, 2026 at 1:18=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Mon, 27 Apr 2026 13:43:15 +0200 "David Hildenbrand (Arm)" <david@kerne=
l.org> wrote:
>
> > Pages that BPF arena code maps are allocated through
> > bpf_map_alloc_pages(), which does not allocate folios but pages.
> >
> > In the future, pages will not have a mapcount, only folios will.
> > Converting the code to use folios and rely on folio_mapped() sounds lik=
e
> > the wrong approach.
> >
> > Should BPF arena code allocate folios and use folio_mapped() here?

no

> But
> > likely we would not want to use folios here longterm, as we don't reall=
y
> > need folio information.

exactly

> > Hard to tell. But in the meantime, we can simply use the page refcount
> > instead, as a heuristic whether the page might be mapped to user space
> > and we would want to try zapping it, so we can get rid of page_mapped()=
.
> >
> > Page allocation will give us a page with a refcount of 1. Any user spac=
e
> > mapping adds a page reference. While there can be references from other
> > subsystems (e.g., GUP), in the common case for this test here relying o=
n
> > the page count is good enough.

makes sense to me.

> >
> > Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> > ---
> >  kernel/bpf/arena.c | 2 +-
>
> BPF maintainers will probably want to carry this in the BPF tree.
> That's fine - please go ahead and add it.  I'll carry a duplicate in
> mm.git so it compiles.

We cannot carry the same patch in 2 trees.
Sooner or later it will create problems for linux-next
and issues during merge window if more changes
are done in the same area.
The only way to share a patch between trees is to
create a stable branch and pull it into 2 trees
then sha will be the same,
but mm tree has its own way of doing things,
so this patch needs to stay in mm only and if no one
should be touching adjacent lines :(

