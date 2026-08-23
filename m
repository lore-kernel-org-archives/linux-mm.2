Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0229EC5DF8C
	for <linux-mm@archiver.kernel.org>; Sun, 23 Aug 2026 21:14:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B05C66B0095; Sun, 23 Aug 2026 17:14:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A67CB6B009B; Sun, 23 Aug 2026 17:14:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92FEC6B009D; Sun, 23 Aug 2026 17:14:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6507A6B0095
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 17:14:26 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7214A403B0
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 21:14:25 +0000 (UTC)
X-FDA: 85133787690.18.1CA3B12
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8E525140005
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 21:14:23 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Rhj8IXPa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787519663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5aIk5hjqNt5oNCOWt6NWdUPn77WlZIYMgpDkKjeT4gI=;
	b=0CbVssyAQ9PuBPqVlYp2XN3AZU0D+sCWNoxcOQIIsUZDaTweYlczjbvDQsoTSdfcT9QMgA
	W5lC/V/kYTVruuYvo9DcPf7Sd6kxfENSyGtyHQqCEjQGoggEXodFaWo1v4Pey61rWi/k5u
	7Pfz/MdIkzgs06cfHn6N1718OXjGqOo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Rhj8IXPa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787519663;
	b=q15wZmuYSdR8/Eu5gV68pFpPxIfqdVKnMfmu3EzV1l4bBVTxtgaYFy1GZNQx/kGhxuprSj
	K6uXjp3Ap1V9sJNneG2f3cI1815N9Z08Vu/qTidQhmGKtRE8HRulVoBNRIYNIYGGm78LLr
	xXwLbNOZv2iqr7jq1q6YCbCRYMoBlKE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EA6F6600AD
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 21:14:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 909C11F0155D
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 21:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787519662;
	bh=5aIk5hjqNt5oNCOWt6NWdUPn77WlZIYMgpDkKjeT4gI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Rhj8IXPa8+Foj6h4ON2DpulSKlWKVqUoCZ0tUxVdjkGMS6mDg62lftZBZsInlJdiY
	 9GpDcXsON4jAhZZ4UVxL0wFXACUuPm/gwI68BirTUDvAMlIkRrVZyk+5cvZRRbiXOj
	 mIMsP0r+NQ000h0QPDX0BlQLFJzRlaVf7DjRJcLayjputbhR+RqVLoXIA9cv3UeY6T
	 g+7X16+0DrTTjEBsO2HzSzyEX6cN5E+PoKo+V4ZVRro0mQTcU+LVyeyHH2bvHkAs89
	 6EyhV7sl/DZ/aqY81LkD1Rtdna0ZiI6SiNEZDZrVJ3Z/8iludEorqg9pW2Qb1bz9gR
	 MY6ogG7MytaIQ==
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-8eeb4508f29so17256026d6.0
        for <linux-mm@kvack.org>; Sun, 23 Aug 2026 14:14:22 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rqw6l2hiLezwKd8kmSN22Q8G+qmWdtIchjcMLZGvcX9W1unP/bD3igyeFEAgVC6ONeSHu4ftDIGYA==@kvack.org
X-Gm-Message-State: AFuF++nsn2d8Is7+5v8hzVrOyMvgBy8RZNr7GZVZ5uwhEPIiDD3MXCGz
	m/nbTmp+Dc8aSE1Lmfztm5igbzgZeGdxFX+DJtbiRk1flST6HZ5PX1mE7mrm0qrcleLL9H0rkgj
	EP7ltxzuPTIAimDk+pXPH9GVVjuBtte8=
X-Received: by 2002:a05:6214:318d:b0:90a:807d:3668 with SMTP id
 6a1803df08f44-90c8f941e02mr144419456d6.7.1787519661887; Sun, 23 Aug 2026
 14:14:21 -0700 (PDT)
MIME-Version: 1.0
References: <20260823-uffd-vm-flags-v1-v1-0-3086981b33cf@kernel.org> <20260823-uffd-vm-flags-v1-v1-3-3086981b33cf@kernel.org>
In-Reply-To: <20260823-uffd-vm-flags-v1-v1-3-3086981b33cf@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Mon, 24 Aug 2026 05:14:10 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4w643aN5OY5RqSwPy5V=ost8fGyaODGyGQj4c_Q+LYO+A@mail.gmail.com>
X-Gm-Features: AcwNN1VurWkGDFr7vGNUR0UHyLbUPFfOak-4q4LksN87tuQ5GQ8kLbP5vUnF-Ks
Message-ID: <CAGsJ_4w643aN5OY5RqSwPy5V=ost8fGyaODGyGQj4c_Q+LYO+A@mail.gmail.com>
Subject: Re: [PATCH 3/6] userfaultfd: use userfaultfd_*() helpers instead of
 open coded flag tests
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Dev Jain <dev.jain@arm.com>, 
	Hugh Dickins <hughd@google.com>, Jann Horn <jannh@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Jonathan Corbet <corbet@lwn.net>, Lance Yang <lance.yang@linux.dev>, 
	"Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Pedro Falcato <pfalcato@suse.de>, Peter Xu <peterx@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Shuah Khan <skhan@linuxfoundation.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Suren Baghdasaryan <surenb@google.com>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>, linux-doc@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 8E525140005
X-Stat-Signature: 6miqqx7w51bbw1z3bzkyx9qiohuzji83
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787519663-203994
X-HE-Meta: U2FsdGVkX19u48Ag1YC48L8D15wFZzMu3j/0oszSkjwyiNTQWKOLuBzwuWG6GcxDwXYAlVtlsFEK966w2UIiIBCZAOd5DF0d8U60SnA9pWL8AjxBvQmVog5WRNh/5XTwVjMctFE8uUw8+/Fs+bQNfFIiECNmR//DYWZHIw6WmiZ4OQaE0Zm/xNc6yq87ILLxXBU9rqXiJYX/7e+2KdoS6Ti8SbiBY0XckhnPcX7+5zfjRdiUJ+/tUSJNnFRC7HS6tqUb2zYq0upGqI2825oCqh27K2TSxEyRsgChuQiYQmIWsq3c9YLLbjLT5ILsqsY2aT87aiiIEeqqL37WzF+Tti/ZT8jrbJ7SPOnQYkQwpylomLyRC8KXxLbhix4Was7c8LcA/ER2GokdAOuAbYpNtknxyfKMK3O9tHMrwIcY00yL1ho95gP28aKO76txQXPkwXAESR25ePTlEg1WrtmtczP3nO9anbzR1kTdrPMuPqYREFHr9ogT9tVX7bdUKRqOelK2darfy7+gp99JKNRPFXPu0YmmQIZJ2y8FpEQPi9FHXxd4XfjAzbO1SfAJ9BvqjIsjGq7R/+WNv52+iqGEEipPtAOl2wCz6D12+argPW1jNFILRYOTqbgf15q7By06mVMzzwII9u/zJpHPTvs8HPk+TMYDFv4WZba/1O7WVu+YKvylB0zoQVfKpcKs7tOheTFEkWJHy+hrBmQlSbbgDF4MXu33FGvKAv4VWuIwrEiSZkJz2NfpEejYpKMHCM//sKMuw6v1FVJbWnuabWhHrDo35gT3L40USAEenBHRkdjS93c2hsXV/h72qz2wAMvxPN9/IBWVtHbURE9Ivt0pd2C62/3IVNZIXOI+Na6Is0q7fs8LJu4u6MGMTdCyH6KdL/E4KRivsNHyM3pW63XPkglB3BrwaIlQiqVKMKkF5xd8KIdbMrLTWTByoHTuGBp2WuNLXKlVaKC/Jx4IqEg
 ai7CgU8M
 qigsg8UiQ/dx5pPVljs+38pBsw2F8VkZrycu2ftSIYYgr3uW7cgYUsuBq/5b/KC/y/Bg8Uah8v64OfuS1ESgWZU6QmJAgegoSpsBa3QNJghoK8U7VxcAcnkO/WuPpHTGNBEa6/kFSoZ/W0R2cOgiuPTZtFNkSbOW3lK5EJVtoOBzPiqsNKkWRpC2raP3ZMi+ZYcdM7MrSEl8ZRaqzMgc58RZ0ywBvuEMAbOla0qZUFzGeeczSORweg5rwsSPeCMwS4QBZXJ5tB6LjGEBkpPEQRxkh3bxxzXBkeknIsaDubKjRkdPdEnju4N2EXQIv/by5NbrPHU5oT1YayqS4aMNa/Lq8OPt99kjHUO09
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 23, 2026 at 8:18=E2=80=AFPM Mike Rapoport (Microsoft)
<rppt@kernel.org> wrote:
>
> Move userfaultfd_{missing,wp,minor,rwp}() and userfaultfd_protected()
> ahead of uffd_disable_huge_pmd_share() and uffd_disable_fault_around()
> and make the latter two use the helpers rather than open coded VMA flag
> masks.
>
> Convert open coded VMA flag test in mfill_get_vma() to userfaultfd_wp()
> as well.
>
> With every user of the per-VMA uffd modes going through the helpers,
> their underlying representation can be changed in the next step.
>
> No functional change.
>
> Assisted-by: copilot:claude-opus-5
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

LGTM,

Reviewed-by: Barry Song <baohua@kernel.org>

