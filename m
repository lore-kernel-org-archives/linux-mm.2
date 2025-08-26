Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4BDDCA0EFA
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 12:07:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25D0E6B01FA; Tue, 26 Aug 2025 08:07:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20D816B01FC; Tue, 26 Aug 2025 08:07:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 123706B01FE; Tue, 26 Aug 2025 08:07:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0100D6B01FA
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 08:07:28 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7582F140783
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 12:07:28 +0000 (UTC)
X-FDA: 83818783776.15.57B8471
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9526140011
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 12:07:26 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ARpWcrs8;
	spf=pass (imf27.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.48 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756210046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jxc6shgrlQUVKkH8+ZjtV/WRz8nJSbsiLyiErGrHdIc=;
	b=ffr855EBvPKrfDA7l9Ga7zwS4/hqZGx6cMo/DuLH2AzAk3T15ngJf008Tq7Ib/3SPokGLX
	GMFojTh8mWfRFwniDKAoftQOA7rN3vPSAlXI5HkcP0/+ZwLv0nF5HtKkCUsk2BuYs9oK3g
	LNW9UlYnChr1VGbo7wDM1MPW9Ca2uxY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756210046; a=rsa-sha256;
	cv=none;
	b=6pHsoQN+JsxYvaQZ7rljzC+EXAY+TNLZevhhLQkN+VkZG7F6OWAgu+PNWmwUoOdvG8SGhX
	5aYJekuTOiyvB86rioSzIvnwXdaOxxjc2aF3v6xpmu24uT+qd2wswd/CC7+yAIWxqhZaPL
	oo/4TImGz0kSiceWGwvaiVm8tPwLwmk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ARpWcrs8;
	spf=pass (imf27.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.48 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-70dc12da5f6so10883616d6.3
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 05:07:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756210046; x=1756814846; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jxc6shgrlQUVKkH8+ZjtV/WRz8nJSbsiLyiErGrHdIc=;
        b=ARpWcrs8G54l0CgLvFGBrZaGgoKki8AAtZafweYe7HXHHCVNADqNbvKLDYBqYpmMYg
         1p6pbBr17TKiyZrXunUstCKk0IpO8FY86LrY3XqZB6pwi/JMsocZkUxut+rpAZsJlYUs
         5DElmBIeGjPvn6C6fOjRpvhuNI4t1DUF2odAlRnmL9cfYJmdknqOuyqglKXSf5GpejKi
         OMFuQcEm+0Iuy61dSKB9wfkxR99EEtHiQWXfAhdmKiVCG5GKVWJ7JhVOlEXNpcGFbzii
         +la6hUdaNUBv2wHsNijWrXuz4HMfpoJb4rnz+Mue9cNeWvKBXmr/4jvok3WSxcELvfjJ
         TswQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756210046; x=1756814846;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jxc6shgrlQUVKkH8+ZjtV/WRz8nJSbsiLyiErGrHdIc=;
        b=fWs5SVItTvOntoZonXDUB2ebtSYrJUFB8YNRhbqSVmu+3h76+owTHWWlCal8uVe9hG
         fzJwghMPfTK1463PkoXSuWPwxg3e2nt3ZCBHKCpZDoG+CNssu32WzsUzX4vmPuJFUgqS
         lpzzrodcH53KBn3bpOqrgQvXZzR/IE56gYdXd6CfuoOtqn6sv38JhDg/jQqjwTEKwGYG
         UYuroaRqRs9JSoi18ZtoFUOaAXcGy8kSvQ1w/ujN36ypQ4ZXctOln5x1PxiWqjl3ebNG
         yV8T7j/g+faisCowfy7FleJDoNMpTHoX5SG6YzgupaWhK1woSrLgrRdVv25XKGgcJ53R
         LfPA==
X-Forwarded-Encrypted: i=1; AJvYcCW5QaYWAwpVpLGgbr61N9Ibug+zVEtXPLiYOjpBFaEdFaCmvyuHLANmcoTfrqZ8NUBvDSUJl3Xkwg==@kvack.org
X-Gm-Message-State: AOJu0YzN4P6m2KYIQeZicqmD8eeNO9mkZD9Yjx55/xU4Fx4k7/7vvgUk
	0S8voKzrM5O1RbUkggOxdTGr4jSm62fztuIFf8iRKSw9ATFYKuEZMt6MNTquCiPoBdGbsCLigKf
	mz/Mb1IRHViw+jMeo08eUX+k1zjzEU1c=
X-Gm-Gg: ASbGnctJz8DBP60LBZS/X+Vh3ryRhC/sg2PONN5d7tXgDZwKSu8nDlN+onEd/owEpiD
	DoraG9wrX1kZvt/SNG4cyTnbcmtieDxmFEVNlMQ5pcPWb8RSz++HdbG/bTE9iYIoaQjTQMYUj9p
	sgusnfpASjSrnmHYE6WTQuwr4j52cUDpIqCDHKfk/LQ/XAxTND4SuIq4CKEpYWPb2+lLlmeyJX9
	G9M0CPSmozRWazKdKF1c6yxxb49w1aDIIM9ZVhN
X-Google-Smtp-Source: AGHT+IEIM2EgMj1lrnPfc/QLZaI/SIuaTUMHPn65O0erOt+9ClYGQVe1+p6+wCBP890WHjKTvNzMiK21AyXb7Ep4gFQ=
X-Received: by 2002:ad4:5cad:0:b0:70d:6df3:9a88 with SMTP id
 6a1803df08f44-70d973f45e1mr137706786d6.56.1756210045540; Tue, 26 Aug 2025
 05:07:25 -0700 (PDT)
MIME-Version: 1.0
References: <20250826071948.2618-1-laoar.shao@gmail.com> <d8f723c4-4cb0-431d-9df2-ba4ec74c7b43@redhat.com>
 <0398bfc4-49f5-4a7c-abba-90151002ff82@lucifer.local>
In-Reply-To: <0398bfc4-49f5-4a7c-abba-90151002ff82@lucifer.local>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Tue, 26 Aug 2025 20:06:49 +0800
X-Gm-Features: Ac12FXw1g5xEZf3xxD5gs1s1dLXr_RGo94IW44IbmphAAO8l9ciefTUsmal1AOk
Message-ID: <CALOAHbD+qoqHSGCRRy5082x0z1SbhZt5XqsPYoL7GsrDDoto-w@mail.gmail.com>
Subject: Re: [PATCH v6 mm-new 00/10] mm, bpf: BPF based THP order selection
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@redhat.com>, akpm@linux-foundation.org, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, hannes@cmpxchg.org, 
	usamaarif642@gmail.com, gutierrez.asier@huawei-partners.com, 
	willy@infradead.org, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, 
	ameryhung@gmail.com, rientjes@google.com, corbet@lwn.net, bpf@vger.kernel.org, 
	linux-mm@kvack.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9526140011
X-Stat-Signature: fnqqctne1wmgzx8u5i5jdxy1f9xi5ejp
X-HE-Tag: 1756210046-397503
X-HE-Meta: U2FsdGVkX1+oHIAS6163ikH26ZTL9i7R0VktXbAuGxVyZ6rkH2HBy+CAxY3UQ7q+8MXS+1Oajb1pKBsuIpiFovld6shG6HKMua6FL/EJssKKs3rhZDXpwjB5pqQprzIukfTl9FPbRlJMtfK0lFj+/cwwgyDfEXbfVnXtkm4jw+UAf69x7QapQ5HyQO8nCUV4gKNaraHkpC6t6lkJzCP0lBS6T+tpBO3m6OpAvOO8bHEsj/9pA6UME4IuD2OPpIAghYFf/FbNzcek6UAsR/ke5h+YMkJFPuJ7SDJ/SZkedDroOXiLkb4G1H8Dhg+D+r4xSoHxWQ9xBsHWdKFjtjA0y3JcXguanRdmoaIyh4frJzm/q/ZQqr+twUYlW1REt75q5KxJ+Kzk2mg90fJALX+U4fjKcFtrk+vECgNMw4wy4Pfu84GbYuvB6zkNoB1CoevX7JVCTeYtySmTL3TFh2Ehq2VGvC0ywCwKw07llJ/+hK466BRl3Lttsf5XPDguIXTViIjj3VbRHb+6c9W2VWmQ7B0f7/8hvd0AMXcTf4ZmNjj3uUUgLe3Z+dE+jJHtu+A1ZbYlO8lN3L0DmxPNiwip4aN/9siX+wkSGHVPrYRrRxR0IpQTOsaWgu7JNy2c3t6GE5MzE/dlWize2d/LXL0uAzLy1jDn85HQy0697ge7smpF7uKf8S/40z63Goc/pSRpf8hmvTKdLU0I+7T39AXQGPlnFQQAZBlzWdoK0pAVsVNxJikKcCfonbfD5psgHmrMZf+HYFM5t7aH0OtKrgFZQEJzX0vHNBJljlQXCeve6gp0vKYELyjCcKnOx6+JzHC/Ntn2+aHIJmp/S6MgR5TRpyToJqo96U39MpT7a72d7m7/7atCN9NrYYPGqIBVdAT52Ns+aEKQGWHaPkK4FMWJ6xv5aYr6qwnNW/7lQYBMlqgcV2oNlI05tI86t/+ftFbMk4WJTKu6O4ZQo9Zy4X6
 0sneLYub
 2S5B0dVE2Bb5lF3RkrPjemXocLFjGzh3bNZHdgYTjX+lV3VvLyzc6hCXANT/XMH4+0+aPoHCydx2tgYqDU0Tb+jYicSB4+1eESrpc300JVA+TsaCQA/6RD1Nb/mtDQEIM6UTidEGuPX9G51Ds7DudqxCsxyXYl+ckwIgOpBPs+DNVM4hiWyys3slvXs/bn8COj8NS/SO/xPk/Wzhsv0mfM6pUaqdipaPefP8HrEq7v5K32rdSR+YpmJ9xId+CZFPZqGb5xSYH7geqDNsA5+K1NaHnSvWUoTp3SmT3FCdDTgJe4fMXJxL65NP+D6HGz6vXrE8E/RUriNpB0VVlGTp/iZ0CepsR1YtBwq64jcmEkLM1OPM4nKzP8OKU0HjGqCeiTCsL7gU/R4xhcl0RrsvQm6Oks0zFYS9wcAYn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 26, 2025 at 4:33=E2=80=AFPM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Tue, Aug 26, 2025 at 09:42:30AM +0200, David Hildenbrand wrote:
> > On 26.08.25 09:19, Yafang Shao wrote:
> > > Background
> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > >
> > > Our production servers consistently configure THP to "never" due to
> > > historical incidents caused by its behavior. Key issues include:
> > > - Increased Memory Consumption
> > >    THP significantly raises overall memory usage, reducing available =
memory
> > >    for workloads.
> > >
> > > - Latency Spikes
> > >    Random latency spikes occur due to frequent memory compaction trig=
gered
> > >    by THP.
> > >
> > > - Lack of Fine-Grained Control
> > >    THP tuning is globally configured, making it unsuitable for contai=
nerized
> > >    environments. When multiple workloads share a host, enabling THP w=
ithout
> > >    per-workload control leads to unpredictable behavior.
> > >
> > > Due to these issues, administrators avoid switching to madvise or alw=
ays
> > > modes=E2=80=94unless per-workload THP control is implemented.
> > >
> > > To address this, we propose BPF-based THP policy for flexible adjustm=
ent.
> > > Additionally, as David mentioned [0], this mechanism can also serve a=
s a
> > > policy prototyping tool (test policies via BPF before upstreaming the=
m).
> >
> > There is a lot going on and most reviewers (including me) are fairly bu=
sy
> > right now, so getting more detailed review could take a while.
> >
> > This topic sounds like a good candidate for the bi-weekly MM alignment
> > session.
> >
> > Would you be interested in presenting the current bpf interface, how to=
 use
> > it,  drawbacks, todos, ... in that forum?
> >
> > David Rientjes, who organizes this meeting, is already on Cc.
>
> If we do this, would like an invite to it also!
>
> Have been meaning to take a look into this in detail while in RFC but mor=
e so
> now obviously :) as discussed in THP cabal, I am broadly in favour of thi=
s as
> long we get the interface right.
>
> Anyway let me have a look through...!

Thanks in advance.

--=20
Regards
Yafang

