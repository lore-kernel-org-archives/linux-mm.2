Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE69ECAC5B0
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 11:23:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10CD48E0007; Thu,  2 Oct 2025 07:23:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E55C8E0002; Thu,  2 Oct 2025 07:23:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0214C8E0007; Thu,  2 Oct 2025 07:23:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E3FB08E0002
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 07:23:28 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 91E4B590C7
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 11:23:28 +0000 (UTC)
X-FDA: 83952938496.03.2259F55
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf08.hostedemail.com (Postfix) with ESMTP id A8F3B16000C
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 11:23:26 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=JmWkhctU;
	spf=pass (imf08.hostedemail.com: domain of 3rWDeaAgKCDYbSUceSfTYggYdW.Ugedafmp-eecnSUc.gjY@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3rWDeaAgKCDYbSUceSfTYggYdW.Ugedafmp-eecnSUc.gjY@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759404206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=StwXEML9DUJ/mYJQmtqU+M+tGtJwCRVezsEJIIsHWHo=;
	b=Xt0O8MaSziWvf9WvoXJ3Ve/qFXHBuyteYUYE+EuEqtE+dfr+Wg5j7O9navfjyDP+0TU1MJ
	rgUXPalUvOeCPdGzfPpuYYarldJeigHIoQPsYtM1XWDLl9GHSETEYmpifhc6fakQXjBWg+
	0+AZv5iI1vEtW9AX8WSC1HFM1WO1N9Q=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=JmWkhctU;
	spf=pass (imf08.hostedemail.com: domain of 3rWDeaAgKCDYbSUceSfTYggYdW.Ugedafmp-eecnSUc.gjY@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3rWDeaAgKCDYbSUceSfTYggYdW.Ugedafmp-eecnSUc.gjY@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759404206; a=rsa-sha256;
	cv=none;
	b=IVaCCvIkNekypM2JB/5d7aArsThxoxz6zaMV8O2xuN4DN5mLbuhosqyYqthHuEeb7aRkzg
	cW7cDjOGN107rOpO7BaaVhgoJz1YFbh4lHn6/9E36ZucZz2GJcO+E/GB3p55OKEJgD7ZaD
	udh7xvohTK3vOA2nMvb72Izu4X7z6So=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-46e35baddc1so6276325e9.2
        for <linux-mm@kvack.org>; Thu, 02 Oct 2025 04:23:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759404205; x=1760009005; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=StwXEML9DUJ/mYJQmtqU+M+tGtJwCRVezsEJIIsHWHo=;
        b=JmWkhctUAR/+6NFWp0L8i56dgRzR4j83kVfIerB5XhJwAilMSCKoHML84hUqtX5+5L
         cXkEE+AJOl0ANCNdiwJ/xrm9jJQEeZj7BsE8iJ1KciqyZXH0w1c4dj4tFG8r2BZTWoWa
         1BmP5Y1Qxy7VsYGjkFRhfbcmKQXg+tBgggIGpRFHlIQ2N2VLyM4c49tw90Lk3c+YIXfw
         Kcm89uDNQeJJoSR6AgTtKNrdP19r+lr9d6TOxBmYEZ6qOyKO8oo3yPPfanBiNcrbRuzC
         G1/lc9+qfa2B5ZJ08mPpdj5FW6Xov9L4mdjpoe1G8CpR2cogwJxVqGAhK3XCqxrNheJG
         4klQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759404205; x=1760009005;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=StwXEML9DUJ/mYJQmtqU+M+tGtJwCRVezsEJIIsHWHo=;
        b=js/ZO6qk6UhXdgkJUNfKLDppDrwwCq9+fSAZhJ/MzSmvEMdSWu5XBliQUiDYcUHC86
         /ZpzGs5nVtLt1KvZ3diWT4dOBg8dz3JuPqDvqxmot8e3neVStSyfBzY8VvPw/STFBh+T
         m3GWuISqvxUk13vfIPgw0FESy6hybtdTDubuY7CsMUnE9xLqDXaDoKYWqxZEh2iA63kr
         v+buErlsau0r1Qdy90p1qUdSbnwen13d2HTYt/QTwLws8Um6zsAqSlxh3DmDUEvvv+Cz
         d/2cLkrTSOmjlmAJYwoqVJkBdUnRhiSYUEKFK9ZzgbSijwuHIpyR9OMslCRZHGOb3+Fm
         KsPA==
X-Forwarded-Encrypted: i=1; AJvYcCXEDxV7VNm8ZFxhoIEKV3shiEmnqRv2PwaceTAV5wZVpSqftTspsIRQBWto0LWWnglIvukZyUE3hA==@kvack.org
X-Gm-Message-State: AOJu0Yxd7rdGwDI+m/YBGMZjEaZ6iK13NKIQGqjLWpjsqdn8WtzEqjVz
	6+oflD/jkWfLsmPeYMm6PCPF/gtkLixVDL1i5kQgkA0f93B2L5o/N8xkFiPwV50W2tjOIqs/iTy
	imM+kSIA4bE+b3Q==
X-Google-Smtp-Source: AGHT+IGWDUkaG6p5pIygtGCDP/CQv3zB4el8v6qelCaY1TuvOduqSN++5HdFowlfxZPTYWDWDdFsU0TbBAaraA==
X-Received: from wrnk2.prod.google.com ([2002:adf:e8c2:0:b0:3ee:fb15:5340])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a5d:5f55:0:b0:424:2275:63c2 with SMTP id ffacd0b85a97d-42557816e2fmr4729772f8f.33.1759404205042;
 Thu, 02 Oct 2025 04:23:25 -0700 (PDT)
Date: Thu, 02 Oct 2025 11:23:24 +0000
In-Reply-To: <00e7ff5e-fe6c-4edc-9bf8-2352321f74dc@intel.com>
Mime-Version: 1.0
References: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com> <00e7ff5e-fe6c-4edc-9bf8-2352321f74dc@intel.com>
X-Mailer: aerc 0.21.0
Message-ID: <DD7SQLDVNSRL.XJ8PUCH6GYR1@google.com>
Subject: Re: [PATCH 00/21] mm: ASI direct map management
From: Brendan Jackman <jackmanb@google.com>
To: Dave Hansen <dave.hansen@intel.com>, Brendan Jackman <jackmanb@google.com>, 
	Andy Lutomirski <luto@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>
Cc: <peterz@infradead.org>, <bp@alien8.de>, <dave.hansen@linux.intel.com>, 
	<mingo@redhat.com>, <tglx@linutronix.de>, <akpm@linux-foundation.org>, 
	<david@redhat.com>, <derkling@google.com>, <junaids@google.com>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <reijiw@google.com>, 
	<rientjes@google.com>, <rppt@kernel.org>, <vbabka@suse.cz>, <x86@kernel.org>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A8F3B16000C
X-Stat-Signature: z9hf6xydnmsrcb16cgjy83mw1e16psjo
X-HE-Tag: 1759404206-680284
X-HE-Meta: U2FsdGVkX1/NrBC7mtF7e5XZxBGjRrNG7XYxRvGFhSxfpl2AdDsIUAjXpeLrfRAim18M1V19nxqsr4ff4QB7Mn0YMEiBUu8EWT4cm0rFKZ4yKpI/YBc7BnQwxrWHqhlxfs6FpJlYkCsWMYL0rE5C75u5n23RasWGSxHYzt2cHuQ8Xy1DYWECFgDHJo0BDRx2sw4V1Q9wylTMugCbbzJuFq8gtaoEyYln7uKUGkBRr7H3BQWb+Q8o5h94dEr/XP7xY/uJclCDOjurbfwmB69M8KfnTn1eOUY09leWobBMsFm3PcnVeZ8sucVNnChSbQXYSpy2Pi3Feel/FAnn+ODxCB0XU0VqjGDQZOBwZkYmNeciHaH7P4kja7p4nGNelXkqliq6gNsIBlVjxsKBaT4fwhooSZAMPkozaNF6jyuz0sYc9f3h6Zqc4OmpGR5lINIDDHuQoMK+yklE2DLRS1k2kw7n8JvySGn5UJxQcl044FlyERlIauvsC0MRlBmBZVSWwVk/Mdfp2ukf5uDmdvMN+evws7Jrcix6bdT//i77TqHcE01sPB07L6D9ZUEY1TG+3kIgSLIx5uCu8shIWvfjHxDE43UX7ysgdlJ5h8HA6gDYW6/3ed224BjBRZKkZUvFK+Ez+CND3Op/3XpLLNoW89d0Yma/zP+8dgXQb9p/rFOz1VX9GhaICEl6d4lRABFEPPBIJPbIygi8jLw/ojS6Lp2EK9j54XA94nqfMajbVfOXVHko+wSd/agTgvke5143Th9UU68sB57VG5oHO54ZNga3nZK94OAvg503kaosROKZzCOqM7IMINe9sW8WXIwIaEQQs6dIZLBLk/KR+GHT5Sl4YfiQPONvLu1dPvgIcHjNyCHI2zX/g8IemHzdpnuQbzk5o9gPXehYR7s7vWWd1m0GQjGgOsg/vh+4ryNP6gWKcrMG6UlvnH9kZGXupPXD9ZxO4ln19FGnVj4ohn5
 bdcXZHuA
 xIMVcHJdtO3Nij6VqgjAK6R6rH2+4T2vLRx0DVJ8HCpZR8C6EC+wKQzFH06nKdb4hmbiJJs7kbWxyW2Ye1U7wKu+IqoHIYfDvpyt+AQSM1ywf0yq9xKbsApd22ZVvDNlWLPdbJ2pJw3cvyxlJ4Rd0bqG37WGhMrWpL37RHKSjtxfjxHMm8Yf64RqIr7xkNipOGpFQQ7CbeBid9H68BaXhZWhmYgJGbBQ0NnxOso09Z2DN8LWU5rkuHVkn0i7m0Z5+qedZ7ewbQ/WxEa4w/MAIVJ+W8htvqzD3V3TtYQIo5mUbt5r/lPi3v2DqhFMbN1eUr5ndabHlAsWcoma07aNVnJCVSXCvY5i1mOcaGchANsnfY0AhbUA2xCLiDf++yOP2b+WQnoMpBHhFJlFstk85sUpSnk/OiPATI0b0DCtkN8DTgVau+YpwZDnG6GS9Tc0T2zQkoGlbVlPcqx0lQ1vvm18IE8eiyd2LksFL75Ah8wCVk8F1CpGULPVIQVdQhQkLUdABZBzdpelNeh/utyZSwnaEY6IY1hmye8vmX9xz1W/MTom5GdqLbDo7mgv3D1aRHKzMWBIG73YqHmk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed Oct 1, 2025 at 8:59 PM UTC, Dave Hansen wrote:
> On 9/24/25 07:59, Brendan Jackman wrote:
>> Why is this the scope of the first series? The objective here is to
>> reach a MVP of ASI that people can actually run, as soon as possible.
>
> I had to ask ChatGPT what you meant by MVP. Minimum Viable Product?

Yeah exactly, sorry I am leaking corporate jargon.

> So this series just creates a new address space and then ensures that
> sensitive data is not mapped there? To me, that's a proof-of-concept,
> not a bit of valuable functionality that can be merged upstream.
>
> I'm curious how far the first bit of functionality that would be useful
> to end users is from the end of this series.

I think this series is about half way there. With 2 main series:

1. The bit to get the pagetables set up (this series)

2. The bit to switch in and out of the address space

We already have something that delivers security value. It would only
perform well for a certain set of usecases, but there are users for whom
its still a win - it's already strictly cheaper than IBPB-on-VMExit.

[Well, I'm assuming there that we include the actual security flushes in
series 2, maybe that would be more like "2b"...]

To get to the more interesting cases where it's faster than the current
default, I think is not that far away for KVM usecases. I think the
branch I posted in my [Discuss] thread[0] gets competitive with existing
KVM usecases well before it devolves into the really hacky prototype
stuff.

To get to the actual goal, where ASI can become the global default (i.e.
it's still fast when you sandbox native tasks as well as KVM guests), is
further since we need to figure out the details on something like what I
called the "ephmap" in [0].

There are competing tensions here - we would prefer not to merge code
that "doesn't do anything", but on the other hand I don't think anyone
wants to find themselves receiving [PATCH v34 19/40] next July... so
I've tried to strike a balance here. Something like:

1. Develop a consensus that "we probably want ASI and it's worth trying"

2. Start working towards it in-tree, by breaking it down into smaller
   chunks.

Do you think it would help if I started also maintaining an asi-next
branch with the next few things all queued up and benchmarked, so we can
get a look at the "goal state" while also keeping an eye on the here and
now? Or do you have other suggestions for the strategy here?

[0] https://lore.kernel.org/all/20250812173109.295750-1-jackmanb@google.com/

