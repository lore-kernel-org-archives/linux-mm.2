Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19169F5580B
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 10:43:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E8196B00C7; Mon, 20 Apr 2026 06:43:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BED46B00C8; Mon, 20 Apr 2026 06:43:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D42D6B00C9; Mon, 20 Apr 2026 06:43:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5D9B96B00C7
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 06:43:46 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 11AD51609CF
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 10:43:46 +0000 (UTC)
X-FDA: 84678598452.16.D910883
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0FA504000D
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 10:43:43 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=F1QwoMPh;
	spf=pass (imf04.hostedemail.com: domain of sef1548@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=sef1548@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776681824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wdriMOYuqf1JuyNyCdurWt3dDtXG7MpE23d9jM/g5eI=;
	b=ZzP9XZP2iNgSMsHG6oO8vvmyuYbqp3MegZuC9BOFwoKIAuN2uvCGV7FtyoBCJ8H0wGC8YQ
	zzhyEYkUIMYf2vMcb3VJ4Y5W+K6mmq/H/qs+BhjmuW9tzoSvdpTHeP+bMLJjovahE5vYfC
	zR+dPDtBXi0ios5tfERBPo/zeOnWo2I=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=F1QwoMPh;
	spf=pass (imf04.hostedemail.com: domain of sef1548@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=sef1548@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776681824; a=rsa-sha256;
	cv=pass;
	b=4Kv6B2fM7qIIFDgs9O+MdIYd4nDkGwnI3VUal6IU/9Yfa6gyRz3cvjMoR2+qF0AEmIapjV
	gxXdeYudJ7StVQa+uh8gk4i2nkd6pn1rjxoy33mBlSwjC7zAjqVbAcoOWZgn9wfAL41YJs
	0ijn4dbnSExox04HBuOwwBJzAsb7gD8=
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-43fe8bda8e9so1362962f8f.1
        for <linux-mm@kvack.org>; Mon, 20 Apr 2026 03:43:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776681823; cv=none;
        d=google.com; s=arc-20240605;
        b=NaRerTkHlhsPvtBL9yTF+tF8ojFJNzJMQna1WPCbUJHLtsM2yMXIdtwXXrJJXRA/tc
         jLvji6mi+IG+jLZo/yN9sQOU4NeH3XO7NEbBPEm8KJTxs0eYxzPtjU+vxBBo+K7Hy7PZ
         AGzODF3K5qV1UdUI4dA0hzIXFFbi3+EXiCXobVrJWDX25mCd7TyOiAoDiFePeXpdvTrg
         e7S2zXGumBqEZU7/sHesN2jDoqZ8kMOL/k4cbs/GkCI1BlcgAAkoN77VXeq9LS61fjvU
         YpVQrt7aXvF4Jl08agxyBBa4+yPlT2Ic+Pmvz8wE+A0CP3foqAiNbx4bDf5vp8Dcii4b
         mG7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=wdriMOYuqf1JuyNyCdurWt3dDtXG7MpE23d9jM/g5eI=;
        fh=mR03cDHzLnr5ot/CBjPZEMZ8/00f0ObTr9/OK4hH8pU=;
        b=TjAsLSVhQPrbp+zO+PY0B+0gYkZCuWdqkcYW2O2KbO7u1Q98B6Ak6wQMZ6+aMqAdif
         GUIoBRH4hBcXnPrRw3VLBhTN3QBMsedS5ayTPTp9cShISCX9OUrJVVL0k+9kSh4WjMsC
         c5CLrWahuMa1+J1y9gyYZYzj86SKbGZ9NzR1LUXwxg5la/CKR7CgLGCBYGkr7lwK562R
         YCFIcDrnMTemNv84KICQr1bGLnSKvhpm710zrumS9rnpS/ZKUV+vNebX2V4dTK7AOV8G
         Fuu18elp7dt57yupRFSYk/OQm54AcuOVjS8MgpHxAfuQGGnAchPLTeyX6Bd0Lm1tTAnt
         bGcw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776681823; x=1777286623; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wdriMOYuqf1JuyNyCdurWt3dDtXG7MpE23d9jM/g5eI=;
        b=F1QwoMPhzsRCGDmVjybhbs9yWK8kdD53ANFqu0U5bKQIGDVh9GUsuS7PgOGN09vsjO
         g+YRg5j+cL7/3rWpMnu9ZPD4iICROQkf5KgIj3rfzPoKA84q+ZvVYUVTCCp7wXxY7waa
         S8lblKTJfebUhqvgXIzlt4dQEifnD3vVweaQllThel0lAJMueSJrV+tGIEw/Kd3NBieF
         /Hd7hgo2UexcFpFG/FrnWpCRVLhUpF7rP3L1Tgsrrjh/zzGD+EgQLE5fVhRxvSfkQYKT
         QadQop0Vt5mkBpIJrlEbOpo5LsdnyreKMqEO9EgInjA6bSbcMGspam24idodzwstQTqB
         bGZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776681823; x=1777286623;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wdriMOYuqf1JuyNyCdurWt3dDtXG7MpE23d9jM/g5eI=;
        b=iN3UjEvvkGWpT42zF1Hlz2OEfwz7pxI6RuW1+fvUzx9tK7Mb6rb0nD6D6kyFchFqWW
         OoIR2X+rDnJnAbOn6zK2bPZNb7neeomiKUlVQBpPHojSMp5wumsY/B8BgDOrjZvGnosQ
         aqEZdoRe93imDzNEdKQtklOK9UZUsA5F7EBESBmetmx2VDXrOaKUbbbd72WaTIuaDWVv
         ML2KLPN6gARXrLObzYTEroIJXOnmdcvFxjeztmmZ6ebFtGZee7LlODINOmfe3Nfh2OSz
         avJvpK/jSa5qxjrQk/wZh5ikcSg2pe+5OTkA+WxXy2zbPoN1h2awfzophA5XMP/RKoDK
         xEIA==
X-Forwarded-Encrypted: i=1; AFNElJ+hbTC0CE5ncM+sZw5pT1q3yeRAtQ6LdTWH6eAYTlwgyYABPEC+TS9/tXTBg9P5xpW+1/UkvnTufw==@kvack.org
X-Gm-Message-State: AOJu0YwBfCgYnYMLzxK/rV4KizHlk9taN7X9SZ6bBoV9k+qDRQvxpOBk
	jaa07rw1yIVtDbY5N+90VCcYwdI5BJ0ovjOIG0CAA88clkBiCDddUYRJjt2wGw1ti4DrCSE1cOp
	/2iP+WIiR/H+OQma1YmcMFYAl/mMmAiQ=
X-Gm-Gg: AeBDieuWPAJTYBeu8GoS5d9EkDsSrqrETwOthZxPi2YwQv7e1QHnpDOQJR2u9dct3P5
	ddE9rxQAWyJybLiSDnzrUtYIKx7hz+F5t3fvfQ0WuRI8yckrJfymV5gCj3I8A36O6139dJZKkSk
	G2R6ILi/Gy1cmkzE9TidiqMjXBiXHnpDu9n56OQBSo3z/utLXpG+zXThX2u5ek+Dh1VAtUR0RtY
	dzzXxcBN1uWhmlqXAcAaXB9qwTz+a8HEwXaEcZtx1lWhTVm1GiyJNUoh7yJyP6MJ1y90hJSz7cd
	LHdE1clOaHPJB8rf2wln1LM2KF8/q/KC0vpmqwFANiSCGsNSs8Njq6kC/7s3hBKIwSVux2+oc5v
	Ds8xW0+s=
X-Received: by 2002:a5d:4b81:0:b0:43f:e721:76ca with SMTP id
 ffacd0b85a97d-43fe7217864mr10702499f8f.45.1776681822491; Mon, 20 Apr 2026
 03:43:42 -0700 (PDT)
MIME-Version: 1.0
References: <20260418000635.17499-1-sef1548@gmail.com> <aeNGbNyPxJssnkbO@lucifer>
 <aeOuCH8ydw_yzdXZ@casper.infradead.org> <c113f667-f897-42cc-a0e5-b8a0bbd91be3@kernel.org>
 <aeTTw4gziJigaNbU@lucifer> <CABZAGRHXtjzGJrgR1NAmVHFMP9eL5zZr3DaTAtAvywv_1sOHdw@mail.gmail.com>
 <87jyu2w2rs.fsf@trenco.lwn.net>
In-Reply-To: <87jyu2w2rs.fsf@trenco.lwn.net>
From: Nick Huang <sef1548@gmail.com>
Date: Mon, 20 Apr 2026 18:43:31 +0800
X-Gm-Features: AQROBzBZHx8GRi3NzcgXlhRjqdOVlbvZpCVncN88SDSfN9NuGphI-_yYe0lxFoQ
Message-ID: <CABZAGRHKq8SUnbXu5jGEP28fXozMbp1CJi+8215Ytqq66FvJzw@mail.gmail.com>
Subject: Re: [PATCH] docs: Add overview and SLUB allocator sections to slab documentation
To: Jonathan Corbet <corbet@lwn.net>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "David Hildenbrand (Arm)" <david@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0FA504000D
X-Stat-Signature: 86sss4f5ggta6gzkfe8sd65unm1cho1r
X-Rspam-User: 
X-HE-Tag: 1776681823-905862
X-HE-Meta: U2FsdGVkX19c/90DAR5AkV3jYtDNTEdU79U0lix0iBK8662KIGUtkCyaRYCZd/6Pc9MgB29SeWu/sNnfdH6TNRcyJE1a2l/n5+ENhxe9+4P5iaJ4g6wlvvRVI+Ul6IgKLLxy9WXEHUdyow43K2OnyweLP5CbaHr0oKYYGJ5HFvRFaXRvpB74de6R0/K6Qn+RVIOfxUMflOOGmacMq+6IRN/a1oIM0ORNq2uqJkUBuBdOhJ73+Y7259jJYCiDD91u6esm83YOdYipYwd36qS/Il9AkhKIJfDlAOyV0dH+i3COmNChGHGQHnyTWelwpyEHDlEjQu/RWsR3Bh9BHk7X6MAzKuDg7R3jj8HiT/X8oPbNOQ7X0rSlgYNZ1hBE0uDBHFRNX8wcDnfNjvgdjFRZXHtJlcmE2usXXvci4GvMxRunyKvXfzteveJlNC5NfFHjiwvFOccaCwOoY8coKM8aDlNvihztuwi1QYh71hYHeRzQX7iYG3m1aCWdAy11QpYrKg6t9EF0dD+rbxveRCfmwj/U+K7TMYqeKhKMzv/6say+jrOYOPtfXxHy7TZlceVe9YEjdTNwzz3voTxmRocLnOtbfNjSLwZ3RU57jdBWnLCbjJ1CVRX3dmXPp4vA4RWvc0FXrzfsLTlB/phFDHs2nMoUniXjNBquRtPsznBPcQKdewKfjr4XcEtHjkgYb85UoQSVKffANShvhN2pbfOjn1isKdEPj6XbRMPo5rMs736vP7bjiCqYQol1phf5YT7KQOGK5R4rpwLBMwcnWE3ffZ8yn7BBD4HH8ZZ+u00yXKA2ZKrSz1IT5Tp1OqFJ+M5KFYs06aEaGLHF5lNwIKUFzWlQ4CobULUCSsnjwzaM8CyQN0bvxdqDonNuG7fzFavqtamsexxvC69Yd3smxfxZHPWHwHM8pYUGi4sQYNB0ofoNSaug4SmetW3FDUZjUaVamYWS2NiQogqUI1Jq01W
 RMwroOh4
 3qO+BObuQ2t12KPj9dE3M28JLI4Nrnpms9AKh5xlxxrGnlU2jAXUjf/BlKt8zCMDqWLVED52nZ046hb0ZEzH+yFJ8ZGLAMdHG8Pv8qaJmjAWNLZZoe+ELmBAY4UtKPq/992ZwZpsHNBU52MAbu3iB2xYYayLrnlC9QcPl8q5GU0e88WtFRtq3SeXFZ+2qg70amSnQPY1/N7hmvALaiOUZ5lH+IZFDFmdIgpIY94DUIiBQUw6qKbUVYIB1FkANmdVBvkydP7XxuJjBkaz5ojxnK3oLt6M6KFl7bZpa2rhMH6H7F1amycmB3KxTfcH1G9vxXRtxXapKvkD93nAXlRj2pNiaODf++IVGLuvz8ISdteaj3X3bQjH630z4pzV6zThoS1xhEKK6DH2GnRtTe/IAdbu2VDfOyrXV07qH23c5gyExP+7NYUMpQ2oCLF+PSRnC5Ek3wcQbGxD8PhpOqbsBgCJQwpmRDDaQedZUYLp2RpZytbs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Jonathan Corbet <corbet@lwn.net> =E6=96=BC 2026=E5=B9=B44=E6=9C=8820=E6=97=
=A5=E9=80=B1=E4=B8=80 =E4=B8=8B=E5=8D=882:43=E5=AF=AB=E9=81=93=EF=BC=9A
>
> Nick Huang <sef1548@gmail.com> writes:
>
> > I am really sorry for causing trouble for everyone. I would like to
> > ask which aspect of mine was disrespectful, so that I can be more
> > careful next time.
> >
> > If I want to make this kind of change, should I send an [RFC patch] to
> > ask for everyone's opinion?
>
> If you want to be respectful, start by reading what has been sent to
> you; the problems with your submission were well explained, more than
> once.
>
> To reiterate:
>
> - Do not send LLM-generated material without marking it as such as
>   described in our developer documentation.
>
> - Do not attempt to document systems that you do not, yourself,
>   understand; you have no hope of getting it right, and you will only
>   succeed in wasting the time of the people who have to review your
>   changes.
>
> The point of documentation is to be informative, accurate, and useful;
> simply filling in a bunch of words is not helpful to anybody.
>
> Thanks,
>
> jon

Thank you for your feedback.

--=20
Regards,
Nick Huang

