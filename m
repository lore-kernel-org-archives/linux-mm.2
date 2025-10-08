Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47606CAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 04:25:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DF728E0010; Wed,  8 Oct 2025 00:25:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B7758E0002; Wed,  8 Oct 2025 00:25:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CCE98E0010; Wed,  8 Oct 2025 00:25:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3A4FA8E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 00:25:58 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DFC811A035A
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 04:25:57 +0000 (UTC)
X-FDA: 83973659154.07.0DD25F3
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0D2C440008
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 04:25:55 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Mqm5mHHg;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.46 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759897556;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZQ9dTtq2r031HzJ132CMq6x9QAKtupQ430h8sMV5noY=;
	b=u6H+/jWCXS16U/zNj59ZWnDi3P26Q9bthBKsvdCnA5aGqqDielU3IDUVvEt0pmrlvm3Yb8
	PjP3knE9RYukOqxLbmDuZvTR7o4fzMJWA4BZUFSj3VGO7v63116t8k7g1CW/nbQTWySjVJ
	KIWrQ0+b9rO85kUNMgtAO14akIE4gvQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Mqm5mHHg;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.46 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759897556; a=rsa-sha256;
	cv=none;
	b=LNgs3mgEYR7aGMNgSmV7ZLrMcWpt733HChUbjkelkaOUrNi8mZwjrXqNn5IT7bnXmG/4oH
	Ni5Ej+//ZVQzcQ4K7EaBAuLdu6M1CjmmWKT4ZFAYN6vTtfn01lmiGCNrJ1mELUzdxP5X1a
	b6n2T7gj4bTDlNNOnHdjzhmncsuRJ5A=
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-78febbe521cso76287006d6.2
        for <linux-mm@kvack.org>; Tue, 07 Oct 2025 21:25:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759897555; x=1760502355; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZQ9dTtq2r031HzJ132CMq6x9QAKtupQ430h8sMV5noY=;
        b=Mqm5mHHgjXA/4jD6bB2bXzQjkoU+RvDYZ0mbuAd+cYQCksKSWbWE+60Th1VtWBxBpW
         VYpA6W0QbW+uyaGxDnYTgnNpmoxgLpQ79RI3oEQ2o7gYybNriyFAV54L3HJff0jB74Ep
         +A1D1pY3KpuoNlZPEais+akC6TH6ldHB6LEefbKrxHYXdcg1Xgwd0mQaWiTAf/J9/1LC
         P0Yhm/AKKmKXLkBa4tdsRtf8p217tOi+ci2WckoVB1vo3UCgs6Z3zDGwz246qCstkfxA
         HneD3Nuou/y4uzznIhBMIIF24Vmhj8qUpkEivK5vPRiOwF5lWbwQy2Ve8AqmLkakMG82
         /6Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759897555; x=1760502355;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZQ9dTtq2r031HzJ132CMq6x9QAKtupQ430h8sMV5noY=;
        b=iLzQgFlwQcOzznJtYtXW1oOATV7w8o/Dha703LfSIHs2IAgEJWJabKaAA76AwUJ1FW
         p1yta01SKJTAwqVPjm4XGTQcqfOIxyXQA5O/AFVKumjixulSNQOmFiBbIhaRb0YRxBcC
         2W6nUy1qIaDaiYdc43ifJvOl4h+uxFRbuUAa3UYGTcJtlQRm7IkFxDIQ/G/ZvAtFUqEj
         Hfui9k9WB/vhBGVd4HldtgP1Uk03RN9SdzkPyW2E6ky7dv5AqKiztOEPjWWWbhwsgxxU
         tQ6lQ4/GSjcJ1FpIg1tXGa2Mcq5ouih4GCVayfzZ9ynvrCkfKHy8A4bFg69z7P4nVZ/5
         Ln3Q==
X-Forwarded-Encrypted: i=1; AJvYcCUaBvLmk25IqTQTeETWL65C2htEQLS9L23hlIO64HHDTratCGxkcZC/UMuNiiZ1GSELaBUuA6Jfyg==@kvack.org
X-Gm-Message-State: AOJu0YzFntvn/pwjCvOBtE9a2Kb+nbCTYcBP7azNMHhoE9zce2tHIqhy
	21dMMU1TOe6dckgfhTi4JGxe6JvN4DEDI7s74o8yuNu1TVZe1Kc0Nd2CtBXNdpDSiwp7kszLVYe
	adSu6kNqExc7svYy3hH766rSngVmfjes=
X-Gm-Gg: ASbGnctulMX5uNnkQegyTOY6edLgwLH5PRpBexwtLvYsuwErd+kifjiYBG+oHtnbE6u
	VOru70DWkI2nlIP2vmZ8vsn6PSBKKAqVKgsCanlbZQgfdmdQCByFwXd/Dy6ixEThM+dd+JN2Cbs
	/OYVK9TeIAjZEDuvhGtTru9iKRlwm5hnxPdVXVZu65vIJJWEx/HY0tCyDJW5abWDiOEVBCDYhQb
	D0Xzsz4k/Jn7uB6JP8Kqj6CzfblJ/PVnTNUjt5VkWry0gEt/OKY1QBsjHu5TKob
X-Google-Smtp-Source: AGHT+IGCzC/VmZmzeTX400uWDZErCSGt3UANlTSe4ykGek43SJ+F9tUSaXyAxxMkUOYFF2TqLUurlhwf+xhIS36qFZk=
X-Received: by 2002:a05:6214:62c:b0:77e:c29b:679b with SMTP id
 6a1803df08f44-87b2ef7fc5amr24134816d6.65.1759897554997; Tue, 07 Oct 2025
 21:25:54 -0700 (PDT)
MIME-Version: 1.0
References: <20250930055826.9810-1-laoar.shao@gmail.com> <20250930055826.9810-4-laoar.shao@gmail.com>
 <CAADnVQJtrJZOCWZKH498GBA8M0mYVztApk54mOEejs8Wr3nSiw@mail.gmail.com>
 <CALOAHbATDURsi265PGQ7022vC9QsKUxxyiDUL9wLKGgVpaxJUw@mail.gmail.com>
 <CAADnVQ+S590wKn0rdaDAHk=txQenXn6KyfhSZ3ks6vJA3nKrNg@mail.gmail.com>
 <CALOAHbBcU1m=2siwZn10MWYyNt15Y=3HwSGi7+t-YPWf0n=VRg@mail.gmail.com> <CAADnVQKzW0wuN3NfgCSqQKVqAVRdKVEYMyJg+SpH0ENKH6fnMA@mail.gmail.com>
In-Reply-To: <CAADnVQKzW0wuN3NfgCSqQKVqAVRdKVEYMyJg+SpH0ENKH6fnMA@mail.gmail.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Wed, 8 Oct 2025 12:25:18 +0800
X-Gm-Features: AS18NWBI41AxLcXzli8BL1gzQnleRiXmQ_JGmwEiCOIcXhbDR3K7nn2-xDL2UY0
Message-ID: <CALOAHbBzS2RunZzEk8-rkU60M8jKEJ8FwiPgZqNeoXDy++L5hA@mail.gmail.com>
Subject: Re: [PATCH v9 mm-new 03/11] mm: thp: add support for BPF based THP
 order selection
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Liam Howlett <Liam.Howlett@oracle.com>, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, Johannes Weiner <hannes@cmpxchg.org>, usamaarif642@gmail.com, 
	gutierrez.asier@huawei-partners.com, Matthew Wilcox <willy@infradead.org>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Amery Hung <ameryhung@gmail.com>, 
	David Rientjes <rientjes@google.com>, Jonathan Corbet <corbet@lwn.net>, 21cnbao@gmail.com, 
	Shakeel Butt <shakeel.butt@linux.dev>, Tejun Heo <tj@kernel.org>, lance.yang@linux.dev, 
	Randy Dunlap <rdunlap@infradead.org>, bpf <bpf@vger.kernel.org>, 
	linux-mm <linux-mm@kvack.org>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, 
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 0D2C440008
X-Rspamd-Server: rspam03
X-Stat-Signature: gxhubjgqium47dgworon6qriucjy5cws
X-HE-Tag: 1759897555-6692
X-HE-Meta: U2FsdGVkX19LzP9ZcSBS37cV2tBksmYo/mGeBG0peKQdOOK5YE2KOFwYtR6+Y2mBIqw8CIqEvlwBMkEUX+RnGOGXh95pL6iKEJ/qnhDvNWAzdrgmBxd/95TBBuSWBFfwHKFKVei9qbLq9l8HpRLbLoOsYG08ySXOsiKnto7N0f3rBvy8yd+TBsjAAsTrmSTvVUvwhY2hKfLVCPNX4ZEqCcDTj+xaFgmQe4CrFZYW9o/EB1uW3elL81n+88Pc8o/YbbAdCrElUWxXRD/fMFEb8p+qHG24qpxr0cfkOviGUXIkGGlrnjSNQ8sCjuZsa7dPKqaGdOTjLXecaFmo00CTPEUSlXdQAEvw5Ho+N5V9jJdSZwVbBsc7JGSvVeUYFE1j8EdsX/Gs+HmNSr9ynX52O0jpsfNYqvLrKhtY0miLKV+H2f+koxWabfKWKfcq88gkbD/awNlmJ++xs+r2xoZYWp3ejVed3Pkxty3clIwxbHO/xqJ/9OrBWXvQNXNOM2gV2ewlj/SnP/+k18bK6ODzDNNdq0Vt86MzzCOZxLvO6YrEhmdIkz1yojLiZoAV5GdqW4PPNo14fh2J+XbHm+WoeHuFMqs3XQ8YLNAMgGovXDvj1M6R82xX0GRqC379U7ccGu00rwt+ybvY2K82nPU4uNTnO1Jl0ZP9Z2epPulEIbWkViF/0MvkgFj5JLLoDG4VM4tfREhiQTtdQFpXBV+c4r7LbLnRxDac9jMvPIXPGXrMFMJR6PSzutrxzvuFbozg2d9sZ1JoZacE44rWD+2EX7SETkXLMx7I7794BAfGjx56VrGJ4nKqNA0mdFfF5oZDqO+fnaP2nOUr0gMnJXD24BewWkGlu7efO8KN5xOg1NjR4JSw2J378P54dxQbw03V/WrNq3CTE4AhUDsAQhFoXijf8bB3Ig/gDVFL0f/ZGUxBYBO87Nxqt1eZDn1sOWRy8TcE/crhZpAQ10s4BnS
 /QYOheKR
 HHIL8OTT1Td5lRLVQxp7Oe42cneSQBs2VQPKN8ijyxnDZaYegRg7OPklLRu6DOi0en8P+5SHtMfC6zYLQEREg/gZu1ZsIp/lEOTmooXGPAadJAJNJPLFSC0S6FJgPpoxRcPs10usT6TgOYPx0Fr8sm9aUwb7eoUQFOz0ha/4b9jdBCpb9wYLgwurgAHMIsfAhPMzTQ6qwZCzKOjKWCXiJCa64Qa/YcckkmdcWpd5Eq/QMJnG6ceelyn3AJkW2Vwx0/NupaKnlwrxdqNAMIWk2zTeQFhjS0A1Dhmh1gOH5rCMwZOSSKuwGIGBsbqu/GsdiLXxzu42r18sYCvDbjvBDHcrT5aGWocEK0hffMMS+LYj4RqzFsPfj0DmDva7WZFL1tgk5qn40jTX6eKfkr/YlsXL7q1SLYL/aTfaHSI6vTVAYLfeZlgjWkwzQqZhePeQHWQfL/0l7jCTJKIX8mUcdmVM2NA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 8, 2025 at 12:10=E2=80=AFPM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Oct 7, 2025 at 8:51=E2=80=AFPM Yafang Shao <laoar.shao@gmail.com>=
 wrote:
> >
> > On Wed, Oct 8, 2025 at 11:25=E2=80=AFAM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Tue, Oct 7, 2025 at 1:47=E2=80=AFAM Yafang Shao <laoar.shao@gmail.=
com> wrote:
> > > > has shown that multiple attachments often introduce conflicts. This=
 is
> > > > precisely why system administrators prefer to manage BPF programs w=
ith
> > > > a single manager=E2=80=94to avoid undefined behaviors from competin=
g programs.
> > >
> > > I don't believe this a single bit.
> >
> > You should spend some time seeing how users are actually applying BPF
> > in practice. Some information for you :
> >
> > https://github.com/bpfman/bpfman
> > https://github.com/DataDog/ebpf-manager
> > https://github.com/ccfos/huatuo
>
> By seeing the above you learned the wrong lesson.
> These orchestrators and many others were created because
> we made mistakes in the kernel by not scoping the progs enough.
> XDP is a prime example. It allows one program per netdev.
> This was a massive mistake which we're still trying to fix.

Since we don't use XDP in production, I can't comment on it. However,
for our multi-attachable cgroup BPF programs, a key issue arises: if a
program has permission to attach to one cgroup, it can attach to any
cgroup. While scoping enables attachment to individual cgroups, it
does not enforce isolation. This means we must still check for
conflicts between programs, which begs the question: what is the
functional purpose of this scoping mechanism?

>
> > > hid-bpf initially went with fmod_ret approach, deleted the whole thin=
g
> > > and redesigned it with _scoped_ struct-ops.
> >
> > I see little value in embedding a bpf_thp_struct_ops into the
> > task_struct. The benefits don't appear to justify the added
> > complexity.
>
> huh? where did I say that struct-ops should be embedded in task_struct ?

Given that, what would you propose?
My position is that the only valid scope for bpf-thp is at the level
of specific THP modes like madvise and always. This patch correctly
implements that precise design.

--
Regards
Yafang

