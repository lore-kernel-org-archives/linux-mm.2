Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7290FD4606
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 02:04:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F2C26B0089; Wed, 25 Feb 2026 21:04:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A0E96B008A; Wed, 25 Feb 2026 21:04:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1788F6B008C; Wed, 25 Feb 2026 21:04:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 06E896B0089
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 21:04:28 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CF3761C3B7
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 02:04:27 +0000 (UTC)
X-FDA: 84484963374.09.3CA5C2F
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf02.hostedemail.com (Postfix) with ESMTP id CEE1C80011
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 02:04:25 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=X4FSL047;
	spf=pass (imf02.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=kaleshsingh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772071465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rtv1yESDymTqJfi3W9Ca2qCOijziJCfHjmnM43FsUmc=;
	b=bREqJsEYGzra7cAwU2k+GXlwY/6To1dosJLKuBn6ZkEAHz7awfmvxivb7zQ4xqOOTe7DTk
	hZiVgKg2kfXhVDnrUHO4HRhIZlMpYOipuk0PuksPo5vrYANiYJ7I/0YpZf/7pAhPhouTwU
	fXAnPBdcWfKMT4Qb7TbRgXix7pFTQrg=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=X4FSL047;
	spf=pass (imf02.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=kaleshsingh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772071465; a=rsa-sha256;
	cv=pass;
	b=HVGoyCiWswN3CCa3xmqjyv28+01xK9pN3weu2iWuTw8yYvC5UgLjUZwwVHg03EMYRZPzL1
	bmE0PJjghVgm6DGHEvzVGaL3JVCdzl2eKXmRyXjHOx5fmkEJ60KqGDJaaejU9SEMUsjmsx
	8IqlzXff/mxEDOFgUvJSrcE2y5+GNhA=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2aad8123335so30825ad.1
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 18:04:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772071464; cv=none;
        d=google.com; s=arc-20240605;
        b=MisQDa2ROEfVuYi/CQJyDV1jTXGrfvDVmZIl4EsAZDa+skCf4Qrztvq2k3155FWnGP
         G8cO0oJ6ZYBIbQ/iX281faPz2SwWr1QH+ESVoa3/o4jiFcb9T7EccW5gSqyA/Qao/2H8
         wavD+SHzFwy1CjlafFfoNrVhxUHAjvEOOcQAr6RJIxJI+VfUBrI5MhVNObN5B9jMsuQo
         7S3F9UkHTm88UOzL6x3Eo8SUoQEGelKKGw3iX+E8SqnEB5OhK5r87ZkbPIecGqWqeP3p
         2TUtoDf63UZuHFAkIwTZYxnnaFV+qXYL/SG5Yf9coFNpu4DLxw7EnaPodxZGK28Fu9sZ
         OAhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rtv1yESDymTqJfi3W9Ca2qCOijziJCfHjmnM43FsUmc=;
        fh=vcrG23vZr8OBhAop9KpHhGhjZuKudxvc/YnWUpcBl20=;
        b=VRd+1jCl0DSjf3AKCKuqr46xOzJzLJDUL1N3bqcsude6+lrZdskLuadjHpwjKFFYsh
         OMLM6twK0hOERvWuv0v/RsrqNiUMp3alAqmAaNf8WxDuEDyf9KVlIvcFyKrLgQoqro05
         bok4bHElnCTbGi/FqYcNhhFkhzX9pacQPolR4AFGculziI69/nqkHFYvShvojMgfcOYc
         +1sa+f1C/18uAwOqd7axp2GWmiquXnj5+KL4s+M6zi6SiIpVZEUHT/D3hX4sw1qp0TD6
         NvzdkZd0er3qPEwL9vUpadPpV5icwVbO66XwAf3mhETCOV3y64FFNwx61Nj3CFGm+fBW
         Tglw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772071464; x=1772676264; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rtv1yESDymTqJfi3W9Ca2qCOijziJCfHjmnM43FsUmc=;
        b=X4FSL047sFXXx7AmD12y7Fp52tNNqZl85Zt6bylvaak3CLvLwIT+8UsGIhGGjW+ExW
         DnnFLussoKpo0OvKMS83vt6Kzz89/oeDIc9oZHZZKVECYohxfTTpCkYLCOOZ8c7IPa0a
         fSc6NIOjl/S4ZnyA+lyYXNOBUa0xGMXSP9Pbye9Qtxa/a3ljkxzCdMjiIh5OFH84tJKe
         k3jDATkETL79OJAtwGTcqJrRlqRmnTSfhXhgLdPCiitFnLJjNK3Q2O7D4CWP2ORdeZHL
         6+vrSh7bIkE8530tBgnW3VLrO/i3U6Ajz/SEDXOPi1k+IQrfw3bcJJOAiGu12E5rdDru
         2Z7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772071464; x=1772676264;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rtv1yESDymTqJfi3W9Ca2qCOijziJCfHjmnM43FsUmc=;
        b=G8QD5PRFU9u7ZHXoKopZgRat7/qmW6i4EmMw3EsWeoCNr5wyF+yYHfxxS0AoukmTMh
         iKf3WGWB5eQU/2EoAgr0Ab+yiI9GOV+yc9B7SpMJsTJGgE7Q9EvtjKImXi6ozWgdUbXx
         zh2cwKq/NfWqzRXQFYbx+70ZF3OETXu9O32Gw4Gp0bW4IYtKoR+07J40HjRX2C7Ivsf5
         cnMWQHDF5ky3Agl//arBuKNahd09jJM6QxHvmTCvbYOJUu19A0NLDsITbW9WnjnbNoeo
         4Ejl776rU3DoqNtoHlAVKabjI0Y6XeBDLMctK/0892lcyLaxl76lHa8mTrwqXk2GqxoG
         wWyQ==
X-Forwarded-Encrypted: i=1; AJvYcCXOf1UCKpn+bSw73pERS12edSfVorxAHleVkhIk/S1GpfA4e45erMIezFhmgToeXRF0rVUlPs4Ljg==@kvack.org
X-Gm-Message-State: AOJu0YzsJDTy9FEvo7zm++668SjK/EZ9DZT2Cg4keVd7Lh0qhmb1qGt/
	dbbOVG1xLG1mH6HTbA6wPTUorX1pDB/hl3lD29q8CIiu+qep0TZYsVpY5gnUKwUR7Gl7Av8oMug
	1ExlKHdYuy8Bps/mC5FtTJvRX41mEUXiyacTb5t2w
X-Gm-Gg: ATEYQzyhft0nzmih8pCe5tN8RyXkGq1uy8ad87e2EmkwyP0CSVSQkaqdK0876bsgceL
	keMBP/Y9eMFO0JUeAPWq/6iKhgllUVGqQPFrEvnEFLiHjcPpyRufcYiS6RqJzyVFmFomLqLwgah
	mJmwYSohOf0n2JCffisRwVxUXIM1SrEoADawMqOvpwybrYPuEFQgxOagSAJrX6ZTATWVk+BAoRs
	bxMw3wkH/8mcExn4b50dT4kbUjkg+vdQW/jQm45/wRIWVKO8NAA48mxV1qlDhKZvi0X0177yK6i
	O0lWKjKrfed7fJ5o6shjHRxBClM3iXoGRDJB
X-Received: by 2002:a17:903:4b08:b0:271:9873:80d9 with SMTP id
 d9443c01a7336-2adff509edemr771215ad.7.1772071463809; Wed, 25 Feb 2026
 18:04:23 -0800 (PST)
MIME-Version: 1.0
References: <e5c8b5b9e7574dce8e4d4744595123e2@honor.com> <CAJuCfpHzTdwcGh8wXetEcAy-93-WqPmoyDnbC8UhzGttpcm_Cw@mail.gmail.com>
 <e3734e2cfac3403da02213b64af8c5b4@honor.com>
In-Reply-To: <e3734e2cfac3403da02213b64af8c5b4@honor.com>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Wed, 25 Feb 2026 18:04:11 -0800
X-Gm-Features: AaiRm50uKPtQk1mGKsHf-oC4scyOKmAzK705t5nrVF8nuLOgIeZc8QyxEwBbG8s
Message-ID: <CAC_TJveNB_beemBUdJ02tYpTj5c2Po6zQAMRzdFQD5WJKfTacQ@mail.gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] MGLRU on Android: Real-World Problems and Challenges
To: wangzicheng <wangzicheng@honor.com>
Cc: Suren Baghdasaryan <surenb@google.com>, 
	"lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>, wangxin 00023513 <wangxin23@honor.com>, gao xu <gaoxu2@honor.com>, 
	wangtao <tao.wangtao@honor.com>, liulu 00013167 <liulu.liu@honor.com>, 
	zhouxiaolong <zhouxiaolong9@honor.com>, linkunli <linkunli@honor.com>, 
	"kasong@tencent.com" <kasong@tencent.com>, "21cnbao@gmail.com" <21cnbao@gmail.com>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"axelrasmussen@google.com" <axelrasmussen@google.com>, "yuanchu@google.com" <yuanchu@google.com>, 
	"weixugc@google.com" <weixugc@google.com>, Randy Dunlap <rdunlap@infradead.org>, 
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "willy@infradead.org" <willy@infradead.org>, 
	yangxuzhe 00017436 <yangxuzhe@honor.com>, "T.J. Mercier" <tjmercier@google.com>, 
	android-mm <android-mm@google.com>, ryncsn@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: CEE1C80011
X-Rspamd-Server: rspam02
X-Stat-Signature: 4dtn8u6bnhoj865yp6jn8d91tp6b95m7
X-HE-Tag: 1772071465-567122
X-HE-Meta: U2FsdGVkX1/aY1A01KVDqLFfm/RAEVHqJoKKBjDOs3E5nWRu66gj/6jlVSIejKf9NCcTCv0a23Atg8Sge/0XkYdr8vXA68d6pj4LR0jj4S8mmpI9s2u8VQdTC5ixdC16jRqdv8LdlQP8LyevT4DiecbYrkduLSV9Jq/1e0WqrL3yeIsV3fCawJGmG7hQd2lh0+ZqlCjbc9M8QCZy5SNXCwjNVIAEa8hDq+CXSMoTtAV3YVSPT+j6BwYU6dG+GbFamtLP05SI1gNYPKWtU3LC+Mxeu5SSczwe1yjlf3p6/7heu2KMHK7Q69zF4Koq8apgYFsx/5dNjNaV2aFF3BG/Ax3yPsdS/ODOyMwZuT7dSKjkGjDARVzSYYeizW1SqzkkrYz3T1L2TSihj+Bmq+QyuIzdgpA+FhqasdBM4FkZW7gS/Dq1qDrDdEzVnXuIP4Pr2BQtiEQdSJWEc5QT9vP0oznU5CG3ErLfGLaoqS5LstWiPYXvEw8l67RxPjjr83KYWh75cvAAMvOt6adN54Ruv5IRmIY4r8Tc6a5LOr7nCre3wP3nZa3PZ5bVjk0yTiwQpJxpSgEC/hOqu6YQwAXrj1MId9V0n5Lbjd/WHu4SuQrAohNUytBUF8tVKJnSIlLBXYA9Hv0qZ9kMJga+Le4DBdKhITvEfsNYBLRHWrm/ODH9F4MkGXDTOZoKr5rSbHc5qR43ozeXbMwogV8N958hc/6ne2fjy7+p8z+vqiiqk5tkz0O5mcr6wQU+NkFE6Eo7ayVt4XVF2+5YBwYgOCcDvFbtxAzNWpPXkB2YZSkIjPjfpAgruom0AQTOFKvYYgjXsTMnG205GYlwJhNK245IEttq85/pMPlTZZkPQLAk8ApNUOEhFILCJj5cJXWJc/oMeUTLuqRidLTY0wkNjy3w4rEVNaXlaDb17QY7P4CHt8fC+yf96YC6z/NmtZfZXJrx6gjn0x8NbpPVLjlgdfB
 YnMZ5K+e
 MoMuvj5SA6hVDNvSfJqqO4ee29l+yOEJhPL6vSbnC8YVlH1c5uBuSaQnWL9Jm9vkzQAhSmmlTeXzqgYqOTiWmiisqoQYraLI8YSrhSnsGwCvKBml9iGntuSkh3gM3PJ8A+yM9chbS8wzLwKzW+i+DeeUdYCllBnSz7mGhduZUw2SXCAsyabhdOty9m9u1XDQ8vSytrBgP78KxsZ4iDzdkVx/ylLq7npyXGbTkH9lpCpDyxOmBGUWcCYG0qA8YpOI6IvCD7Y4V9FvWliJ5ugDAJZWi5wywkHrG6uCUN8/vXAWNznP3CwuEaekoSARTMPUuD638eIRLXoS+k1fZwIoBqUag63biI93cdPek41n/TeSElh2HPwNlJDM5v4EDdNs8bfsL1HvxIwkzN/NWMUKkV5rfjJtoi0e7M7v0gUCJtzwzBEdlUEwxOTiZIBpAMBAWUmcs0X7lulVSBqvnj7Ebz3te3Zithmi9o+mTZ91U5brA2R5dpwxxeLnfKZujlOVS3G9b
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 25, 2026 at 2:46=E2=80=AFAM wangzicheng <wangzicheng@honor.com>=
 wrote:
>
> > >
> > > We are happy to share more detailed data and experiments and to help
> > > with PoCs and large-scale validation if there is interest in
> > > pursuing these directions.

Hi Zicheng,

I would be very interested in joining this discussion at LSF/MM as well.

I actually just replied to Kairui's MGLRU thread noting some similar
observations we've made while evaluating MGLRU [1]. I think your
findings in Q3 regarding high reclaim costs and tasks waiting in
uninterruptible sleep corroborate the increased direct reclaim tail
latencies we have been investigating on our end.

It will be valuable to discuss your large-scale field data and see how
the workarounds you've implemented might inform the upstream
discussions alongside Kairui's proposals.

[1] https://lore.kernel.org/all/CAC_TJvfi_5n2crGHbRVO0R8jdYcSCmgzUJPzhtSvWe=
CN6fCbQg@mail.gmail.com/#t

Thanks,
Kalesh

> >
> > For obvious reasons I'm interested in this discussion. We also notice
> > some shortcomings of MGLRU and would like to collaborate on resolving
> > them.
> > Thanks,
> > Suren.
> >
> Hi Suren,
>
> thanks, we=E2=80=99d be very happy to work together on this.
>
> > >
> > > Reference
> > > [1] https://lore.kernel.org/linux-mm/20251128025315.3520689-1-
> > wangzicheng@honor.com/
> > > [2] https://android-
> > review.googlesource.com/c/kernel/common/+/3866554
> > > [3] https://android-
> > review.googlesource.com/c/kernel/common/+/3870920
> > > [4] https://lwn.net/Articles/1051882/
> > >
> > > --
> > > Best regards, and wishing you a prosperous Year of the Horse,
> > > Zicheng Wang

