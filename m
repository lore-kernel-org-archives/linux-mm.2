Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FABFCAC5B8
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 11:05:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 771DD8E0007; Thu,  2 Oct 2025 07:05:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 722898E0002; Thu,  2 Oct 2025 07:05:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 611058E0007; Thu,  2 Oct 2025 07:05:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 48A328E0002
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 07:05:25 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E94F9B9807
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 11:05:24 +0000 (UTC)
X-FDA: 83952892968.18.CD2418A
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf22.hostedemail.com (Postfix) with ESMTP id 24E51C000A
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 11:05:22 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=AJr+AJaH;
	spf=pass (imf22.hostedemail.com: domain of 3cVzeaAgKCPAbSUceSfTYggYdW.Ugedafmp-eecnSUc.gjY@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3cVzeaAgKCPAbSUceSfTYggYdW.Ugedafmp-eecnSUc.gjY@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759403123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IL2uchrrlVJI0To0OGIK6OnERKr5SS8vcf+vwilHx8o=;
	b=i9f8cAy4O51PZhp0heXjc+l/1iuei67OW/yD35k4MRiAiqzT67MjICaBJXFv8Y9sTFgkL2
	45vsVqVFE59fgt+FP20pnnizQ2/U5kz+qcN1k/+kzaEyuMCTTPeLtQMAFVffMuOTA9gzwd
	ZtRg5246tuq8lqMKdZb2g1dOZzIasLk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759403123; a=rsa-sha256;
	cv=none;
	b=Ldd22WSIYxpuvvLo8J8jFtdILk8i6pXVpCa7E7HC1kny4aC+Vr+F5dOUQWPsBcTRumvBSp
	tUjG+DmedZB+EZd3i6AjHJjKIHbNMhQzqcFMq9iRmI2sgdznnAFsob55euE/0lwKJzfZTU
	JrsqeNq0AWURIYTd7x+1NuJ8Oqbvo/M=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=AJr+AJaH;
	spf=pass (imf22.hostedemail.com: domain of 3cVzeaAgKCPAbSUceSfTYggYdW.Ugedafmp-eecnSUc.gjY@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3cVzeaAgKCPAbSUceSfTYggYdW.Ugedafmp-eecnSUc.gjY@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-46e47d14dceso3182495e9.2
        for <linux-mm@kvack.org>; Thu, 02 Oct 2025 04:05:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759403121; x=1760007921; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IL2uchrrlVJI0To0OGIK6OnERKr5SS8vcf+vwilHx8o=;
        b=AJr+AJaHiVPbDPsqB4kGqiK06TtsoSWXz1vuPbcJalCsH78KpbxB02VcPBLCE7YcKF
         IQrkU0YEpWpkL1MySQj1vDMIDuwOrDy9Licu9YvcB1bZzShjegBVBouXOujxSUeh/D3d
         ak9M42pl41H1YVK6FWqll+6IdxT7oOFTdE+3GIZLpGQdk8AzQAIw16zmoPA5lE0MU6PH
         zko47UFWeCtZr2OSvfQSeXVcTGAlrwqUXAfN2SXhjxWEAHtSpZFxekmYkSOLqamUCxCh
         bYG4EolaTynfvxDmq3xTFVQ+66i3TgIvTZm2QeZCLxXv6kjN5g5CCEcMLXT+i/QqfWcX
         6l8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759403121; x=1760007921;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IL2uchrrlVJI0To0OGIK6OnERKr5SS8vcf+vwilHx8o=;
        b=Vi65TZD50C0drC+PyL2fUAY0kww4pdwA2aGb98PFdIpz37wFy8FLD2ytXpqhDxLMsl
         0EBsmme6D8FjyqSCmBfYKxfeQ413zKXwzCxG5ejB1eFu7GwkwqGfZB9cQ8iAYcfCKgr+
         8HbdjH4Sr4BL9zuAJuHr/Q7JWCyT5wvXzA8mFYfFY4ojlX/2ahYAdwNaylhHP5kqjL+8
         xOO+0evPkzyPP36vyw4GSlOIbawMZh9M7RJ5i3hJSKGYHiEVuFbTG5cWGrbUzojt1Mrx
         XVWIJ0WhSqvPv3RQnBUOTf8PhKEfyi50ZsYbneS3GKP3Jr7fgM8fIRh6axKLmAr+bYea
         o7+w==
X-Forwarded-Encrypted: i=1; AJvYcCXavjLJng82mLuKR+hRUyKd7Fkaux2uLStKLOkMcjjXMT1qbC39x54OODB9neTIXz7CxmNTWMHpDQ==@kvack.org
X-Gm-Message-State: AOJu0Yz7ApWhcCH/KYe/weqdFswKCJGn6sJRaeqYj0nRT7Px+OFMW9G9
	6NVPQ5NXSUzjPWSGZVkEJOoQXQib8TDaMSMuyQvDQNMI6HTbN+3/5LjdNicLdB/TySb/L11bDOw
	E51CQWdrxXVcysQ==
X-Google-Smtp-Source: AGHT+IGw6rncY8Zxg7i+a3sTyj/cTgYVjAJmgkG70hNLSfNqxn0MIvjZU+YGtE0bN/lyYtFOJUyzYiuJGMMOBg==
X-Received: from wmhf25.prod.google.com ([2002:a7b:cc19:0:b0:46d:ab31:6ece])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1c95:b0:46e:6af4:ed83 with SMTP id 5b1f17b1804b1-46e6af4efffmr14013925e9.23.1759403121371;
 Thu, 02 Oct 2025 04:05:21 -0700 (PDT)
Date: Thu, 02 Oct 2025 11:05:20 +0000
In-Reply-To: <7dd29a1e-cea8-4889-bff1-462ad00e25fb@intel.com>
Mime-Version: 1.0
References: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
 <726d6a45-d732-4c23-a7b7-766d6a62122e@intel.com> <eajnyirurulezkgpqaonfqmh5ydi7ujzztgok2ab3fsumcmtwi@34ios2bpwxk5>
 <7dd29a1e-cea8-4889-bff1-462ad00e25fb@intel.com>
X-Mailer: aerc 0.21.0
Message-ID: <DD7SCRK2OJI9.1EJ9GSEH9FHW2@google.com>
Subject: Re: [PATCH 00/21] mm: ASI direct map management
From: Brendan Jackman <jackmanb@google.com>
To: Dave Hansen <dave.hansen@intel.com>, Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Brendan Jackman <jackmanb@google.com>, Andy Lutomirski <luto@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, <peterz@infradead.org>, <bp@alien8.de>, 
	<dave.hansen@linux.intel.com>, <mingo@redhat.com>, <tglx@linutronix.de>, 
	<akpm@linux-foundation.org>, <david@redhat.com>, <derkling@google.com>, 
	<junaids@google.com>, <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	<reijiw@google.com>, <rientjes@google.com>, <rppt@kernel.org>, 
	<vbabka@suse.cz>, <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 24E51C000A
X-Stat-Signature: 5ghfar7wtjdg3pu51tpgnahfwyb5gwh7
X-Rspam-User: 
X-HE-Tag: 1759403122-832787
X-HE-Meta: U2FsdGVkX182Okp1AG8EwsSb+Z5+pA1t0b3TiSCBsgO8Sd85YIScRUpmeMScHo2wYQ4fzz/gBbUWZYZUP2QazZXb90VS+/4sbPZSe467qlU/1F/U7/uc2KT1KXbg2tV2bfE8CbSp+qBfj32RHQ3HsLz1BVCTXlHGdh+mlxXf1NKJGWOQhIn/FaZNPQttiGGjR21sCRdTt1Mk5L8QQexaN/h/0BhwJwvfa92bEsUCQ7t6dIaEgYNvvOUXO5UdmUBmX5lXS/5cmPY3OQ9l4Uz5OnspWMeR7MX62/KADCEl+pHSiciemkeuC+EL/XwAMTVi7WLXcTZ1HekFdMyaHJRQGPpk3jubmA+4US4vyfsG+T5zZirVea+x6L/dKOTf5inrz1DW/rna1B/PdtuyKjcRcbgBYCxqDkcI97Wha6Fr4Mc0Xc3h8g+FLd/JW2hcY3XrjcPhlX/XHA7iPJzWa9z41C2MZkM8DKduCNqOkTCpIghXP2Bbl8l5Ql/b40TysRhmaEJe2yZ1Tjpa2ypyzwJ62FWhlnOpeVUDMawq0qrspp0L9/XoI6Pi+/uTqJjXaLXKR4IzX8GNeTFIdiMefI1PKHkpDDV32ccvvG+KTn5OgLnuyrTN4IeFgESuYMazphIHB6xlJZIglS5FgUBLeg1V8jJD+zfxkzt2bGOOKwqR6JX14OdeEFcgxNi3shlOpBcL7V/PGbQkXuoZ0E3ytbp9P4/CEzQofoI1d3NL3OPMhZnX5P6MKLYb7qxRVBoS0OUxf6xpVMGzpuA8Z7+XeH6ZPT7+WMX9Jnom0UNmtJKnLdUsONIkNVTlivu39vUa/6D6A9iH3p6lcXDnE6ShSrlCNgWy7DtzUigU1J8xlOoQ4U5KZssD0uA3RNUPKZmf8bkxgsxRWvCKuMGaN6G3xUzsDJYYIMzAq0Nm4jU2WrXmYh7ZZtDxwz4JJlVo/UhXLhqHxJOTnuKOfiGhsCQVFIp
 p51Eq45V
 tqgiPj2QudA9ioTXASUXNi0u8mExFjyDor1gtIzJNbckRC9SV9wtXFKXIVVpaiQoeDvxPaMAF8/Jc+1J8raWcYD8G3yM5vU7z/5uWyptPEIvyXBYDAehxc16i28aPzJQTMTJkWgFIFU6/EUQcNc7oIuUI5O2hwD9yTsZInJbyTbffGvmvuNb/QoPpQib+eJKqtb8DuosaoVVe1dKcWrsV8X06CArmtdN3Wh5N3S2yfypmZCB+QFr6sWYhhOKRbPRYx3YwIiHz5lYtReLHFK3g5WgNYg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed Oct 1, 2025 at 8:30 PM UTC, Dave Hansen wrote:
> On 10/1/25 13:22, Yosry Ahmed wrote:
>> On Wed, Oct 01, 2025 at 12:54:42PM -0700, Dave Hansen wrote:
>>> On 9/24/25 07:59, Brendan Jackman wrote:
>>>> As per [0] I think ASI is ready to start merging. This is the first
>>>> step. The scope of this series is: everything needed to set up the
>>>> direct map in the restricted address spaces.
>>> Brendan!
>>>
>>> Generally, we ask that patches get review tags before we consider them
>>> for being merged. Is there a reason this series doesn't need reviews
>>> before it gets merged?
>> I think Brendan just meant that this is not an RFC aimed at prompting
>> discussion anymore, these are fully functional patches aimed at being
>> merged after they are reviewed and iterated on accordingly.
>
> Just setting expectations ... I think Brendan has probably rewritten
> this two or three times. I suggest he's about halfway done; only two or
> three rewrites left. ;)

Yeah, I'd love to say "... and we have become exceedingly efficient at
it" [0], but no, debugging my idiotic freelist and pagetable corruptions
was just as hard this time as the first and second times...

[0] https://www.youtube.com/watch?v=r51EomcIqA0

> But, seriously, this _is_ a big deal. It's not going to be something
> that gets a few tags slapped on it and gets merged. At least that's not
> how I expect it to go.

Yeah, sorry if this was poorly worded, I'm DEFINITELY not asking anyone
to merge this without the requisite acks - "ready for merge" just means
"please review this as real grown-up code, I no longer consider this a
PoC". And I'm not expecting this to get merged in v2 either :)

Maybe worth noting here: there are two broad parties of important
reviewers - mm folks and x86 folks. I think we're at risk of a
chicken-and-egg problem where party A is thinking "no point in reviewing
this too carefully, it's not yet clear that party B is ever gonna accept
ASI even in theory". Meanwhile party B says "yeah ASI seems desirable,
but I'll keep my nose out until party A has ironed out the details on
their side".

So, if you can do anything to help develop a consensus on whether we
actually want this thing, that would help a lot. Maybe the best way to
do that is just to dig into the details anyway, I'm not sure.

