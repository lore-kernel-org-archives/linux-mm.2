Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D619CA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 06:07:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B6D16B0005; Mon,  1 Sep 2025 02:07:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5672C6B0007; Mon,  1 Sep 2025 02:07:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A4026B000C; Mon,  1 Sep 2025 02:07:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3A00F6B0005
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 02:07:06 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C88301DE8CF
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 06:07:05 +0000 (UTC)
X-FDA: 83839648410.01.1B1CB26
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9CD0D140003
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 06:07:03 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=bLZaT7ve;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf23.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756706823; a=rsa-sha256;
	cv=none;
	b=EhWwOfjObs2P3OzvneK9cYyby8YOlPouxN0NunS0ElnqBDxQ0abu8KwgpdxWk5URhtK4Hx
	SPHoYEqkuzRvQEglIs74Jc2s4IagAsqET4NiNkxDqjBZnCEb+9iGB7CFdjZzApPm6Rcswt
	FU7T9lV+oUVmvhlPXW3hPSv/8lc3f7A=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=bLZaT7ve;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf23.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756706823;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gnu1IXOMn4pWHCktYzkVxOKGOFnkM5LbN52VhyjC5rU=;
	b=pLU/sv5xfHXyUIUfZMtI0W2SosBXvght9JTv6m5dCS6XysfN7fys3LDiP2pJs2BRH1PlFP
	105aBjQqnet+8wuj3zu/4DYSNs540mcTJnaFJwQ+1RVlZTmrBQU/Cx9LqSAPjvMPrU/vM+
	6gyvBGzxRQihkODHSvgZI+vliKUZnTE=
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b042cc397dcso68045766b.1
        for <linux-mm@kvack.org>; Sun, 31 Aug 2025 23:07:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756706822; x=1757311622; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gnu1IXOMn4pWHCktYzkVxOKGOFnkM5LbN52VhyjC5rU=;
        b=bLZaT7veEqm0/+iT19G8aYiF8i7w18f0e0jZYltF4XWMmANJPTb0dNciUCOL1imfc3
         wTv2FeFrQl39KvLEwGkKF306QbvBz+FE9C5pS07JUzOoMPfWUFAEAjHYfIno/HEmYfOP
         VInF5VpmAb60+xMNT90L3WPFKlBMXcC5kpuPL3sRtkGaKOPzyzJg9cCH9TOhZVDclJyO
         St2L9s2ljNNNXgiUw8yOeuFqPH68WPBrsRAt1zsfBoS/QeHLzkdsntmu1fSB4muXJn+a
         HHZu4LsiwPjvDF9mD7S0ibBvxPL2QjqQJnDsMqNMIyJumDAoi12uRgOsuBx3u7MQT+VH
         YHiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756706822; x=1757311622;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gnu1IXOMn4pWHCktYzkVxOKGOFnkM5LbN52VhyjC5rU=;
        b=QPfv63KvaR05IaEozeWBN4Ylr+c9pOdrsbIsilvZxVblg8BXCkeAffi4S7PC4Ln4+U
         dKmyYX1erjA4VJRAwjh9UbKMyre7s6gtckjSn3jzZ7WtNALK5J3kXRcRMaP3UNrCrlyI
         w2K38kI26pUIGB9FvNMhwLEzMyKG1eRv2CFJ9f/rYR7gO2+y6R5W1puRV62yd7RLJFT9
         IgoxNH9ZKVx2MfLntAEX4zkMuAhJzWZmWl8nPojU3UvpNOWHp+mDI22dIaEQ5K/5Vvna
         VWo26hvgFCX2JU/bUTZaND6/gLJVRKHbUf+EEUa22OMqdcQZUysK5lCsfNKNDHHTgXGe
         M55g==
X-Forwarded-Encrypted: i=1; AJvYcCUPDuLSET6vfoB90bsaGK9/3VbU23uBmCv4FdVxzzTc2OGc1G4I4OT6nU+XDanGaVAGkDEVOioDNA==@kvack.org
X-Gm-Message-State: AOJu0YxHk+vw3/6P+ihInec2KciUjCk9L554EBPdx13dy4nqbJeQdmsK
	KgC0cYTNWEdapbuQc6ROa9CdtLHmoXViSRrxXu5NW4HyCBQ/l6obL9VZ7kPOs5+b3ePVep98/Gc
	ZmYjHagpZ9oVUWvIEfUg1RNBWdHRaqpa2ADbOkJUBRg==
X-Gm-Gg: ASbGncsQzJ1mLMOhRN8W57YL9KSFzN3JERkp0WyRlijl5qVHNrANo/7XBnBSf99Bxzl
	haquYQfii8uv0N3R0b1GTIMZ8R1Rw8ngVnjjam1rapoU2kazaQb3bBX9T3GDKmb+lGiwMElI6no
	OoIRr8yr0uEG1PyAg3bvvTK95/+UeddBtymj8pLrhXXVdfkr//HoMMACcwDwPKN6QOejStnuQgL
	BcKke3lTv1qwXyrBTDkppIs8FVruQrRlYnQ6BzfRsKcpg==
X-Google-Smtp-Source: AGHT+IEdaMOQbJHWE/iShULgOk2Ptal9fTqO2WN/JPiF7AgbveiCYUcgAekCFvIWZBDFL8NIRtadXqTLu8pJokZAlDc=
X-Received: by 2002:a17:907:2d21:b0:b04:1d85:7106 with SMTP id
 a640c23a62f3a-b041d857815mr341972266b.21.1756706821818; Sun, 31 Aug 2025
 23:07:01 -0700 (PDT)
MIME-Version: 1.0
References: <20250831093918.2815332-1-max.kellermann@ionos.com>
 <20250831093918.2815332-8-max.kellermann@ionos.com> <aLTrAwhfHne_iuVS@casper.infradead.org>
In-Reply-To: <aLTrAwhfHne_iuVS@casper.infradead.org>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Mon, 1 Sep 2025 08:06:50 +0200
X-Gm-Features: Ac12FXyWDxh49J8Y4EQOCnwU2qaQTP3uHc98CGH1GCTMePapt2fS2CVRLAqTcsI
Message-ID: <CAKPOu+-4N7Zywp+Hdr9CNdO40gm=tAwD4O9M38d4rSdo5tzNRA@mail.gmail.com>
Subject: Re: [PATCH v2 07/12] parisc/sys_parisc.c: add `const` to
 mmap_upper_limit() parameter
To: Matthew Wilcox <willy@infradead.org>
Cc: akpm@linux-foundation.org, david@redhat.com, axelrasmussen@google.com, 
	yuanchu@google.com, hughd@google.com, mhocko@suse.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	vishal.moola@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 9CD0D140003
X-Stat-Signature: f13g1oseo3q9exe1nfy4dbcmheqq1pro
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756706823-120457
X-HE-Meta: U2FsdGVkX1/cMSWQYaOiU0OhLJON01hiER4CLqeMPB1cgonfBmgH2rWtPH674XVBJ1H10afutF5GPeKodJ2Pppdzxzv2ysyFXqti4VRJkZA7wSejTH/6aAjx/Ly/NCa8Y+BprZmVb1naVrxmuuPMAzJjLbjiY3qHvyNA+702FWOiCUn/XCQ/gNmzsR4zE1bNzKHOZlDesiNdZSm8v67yKDG0G5EJ88XIUOqIm/ZlWX2WS8ofiXgdVnFOdtr4VtUiSntHYCRBZ7e680vd1lzxUBgl7rM+x5O/qKJot0grPAvmPiFI20q2J02t+qv6vTtnjroGMbbsyKoZ86YnnIfnPvrc8sb4tpZrybmzmSqjaMPyvKPN3FKABrwnHOAJVk0E2Ds+puuAMu2MnftG7+GY06u16+4MT5UlNz13mJ1Gy84ZrUPJdubgfjQHCPkYIDA++swN9IJTcCla9BMXY/KHgfs5ZtZVNyE4wb7G6PG86zR5n93Nyfq2ICNwMJkUhmgYLX1QUj1DtzHb+T6iNvgdo8fJAZNAEQ0aZ/sDqm2mWxbFGkAaZstL0EGAe1ug2vrvPZ+5jNAKHHtwgRx+8RBR8fl3vC/sSkzqNZB0AOBnmqJR5TaBOQrMbaJ33OA3z4wtizgyZhCXgpf+uEp05P1YuQfUbrux0Phgub1CQmBzG/sn8hXE6G6HO+9ApswOquqWOj3H7CD6a7B1re8AA5lyj9zL+oKKo6soljcWDbFKuB2IOaqx1InGyK/Op5i3Hf9U7JWQBvqGkg7VGGVbp9DKwlIQ/tm1YIwqZ2y5nayyHzOzaAy3ma+AACV5VvHh9fpBVSWku9V3lIyF0KxIGH8CT1MIBjmdtsaSUCACCiwKpqldXfbe0brpbNDL0DrfVsIYclves0GNoDwpxpxcfnbXR5ij+OMLZ79cYaxSzCi2oVvtuJfdZYFLd3o95vK8ngUf8rritAgzuz1OTUgrnPo
 UENjvkD+
 pptqa54K5Dromct7cZt/YzwhuxfRzkp+PtmIz3fJSyS+ObF2YRQtvy/2emkjb3y5RW+8Y3YCEa6ZEyCIsRBJSpfV+puPCvHlcP3FFIPW8HPv54em60YpKlQUE/+b/3XBPv51YO7OeKaQm4711UqMw27VOUwvb8UCOzoTKlj9jzZjIfhfAfYMa5Zgi5/6anj6FDXMgv40QhOkEh9jJ4M8yruA/Ca7H0+dmE28JG3N3D7LigjF18+kRCeymnD77s6dn2pHrbr1nvxiFV1oozb1TxqcYEMZx8e60SPW7gTkxpHZgy+NKEwP1eLgbZklxTveM+c7Q/SEyM30/7LI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 1, 2025 at 2:38=E2=80=AFAM Matthew Wilcox <willy@infradead.org>=
 wrote:
> Since you're going to respin this series anyway, your tags are a
> disaster.  Tags are not filenames.  They're just to indicate to people
> that they should pay attention because it touches their area of
> interest.  So this one should just be labelled "parisc:", not
> "parisc/sys_parisc.c:"

OK, "parisc:" is understood - but what tag shall I use for all the
other patches? They're all subsystem "mm". Are they supposed to all
have the same subject? My initial post had that - it was one single
patch that touched the "mm" subsystem".

(Also I'd appreciate a wording less strong than calling an aspect of
my work "a disaster". This is mostly just taste;
submitting-patches.rst is unspecific enough. And quite a few commits
contradict with your interpretation like 620943d7ee69
("include/linux/mmzone.h: clean up watermark accessors").)

