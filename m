Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C3F5CD98E1
	for <linux-mm@archiver.kernel.org>; Tue, 16 Jun 2026 20:53:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E7A76B00BC; Tue, 16 Jun 2026 16:53:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09A126B00BE; Tue, 16 Jun 2026 16:53:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF2306B00BF; Tue, 16 Jun 2026 16:53:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BAB4D6B00BC
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 16:53:20 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4962C8BF6B
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 20:53:20 +0000 (UTC)
X-FDA: 84886976160.14.FE12B69
Received: from mail-dy1-f181.google.com (mail-dy1-f181.google.com [74.125.82.181])
	by imf15.hostedemail.com (Postfix) with ESMTP id 55FC2A0005
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 20:53:18 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=IdFKPS3T;
	spf=pass (imf15.hostedemail.com: domain of gourry@gourry.net designates 74.125.82.181 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781643198;
	b=8L7pPPqWhaDfzn/VTABevbzWaWX5bPLsNSC9Eju3lvuVsl8TDQ+oHmysYVPEcPy6cRwRVO
	mJEhgDx6zEe6V/T0EFlUy4B8TJumM/SvLKhUiH1Ysg/f+TTwvK/VbtogjxoQ5yULQSWSaw
	f4UX3e6juevkngOSmFhA3WhOsnSbZns=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=IdFKPS3T;
	spf=pass (imf15.hostedemail.com: domain of gourry@gourry.net designates 74.125.82.181 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781643198;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2FuiWMyjXh68tYMurmD9NRNYivd+DBtBW0Gd/vXz02s=;
	b=S4P7tMKWGF+XqcSghFwbMTaiXGVHR7cKVIopTvtQuUJc8QF6zl2p/KeuzCxBqFbmTBt1Rz
	60Z7/yyrzmdgyKRJrUoqq+dFPW4abxAtcSXBYPN9Mi57FE+E8/DE3v6FPtegej42nLH1+i
	0AeaDHdfrfXn3zxFxq/3JLzhap/NlfI=
Received: by mail-dy1-f181.google.com with SMTP id 5a478bee46e88-30bbb1bc064so2052775eec.1
        for <linux-mm@kvack.org>; Tue, 16 Jun 2026 13:53:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1781643197; x=1782247997; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2FuiWMyjXh68tYMurmD9NRNYivd+DBtBW0Gd/vXz02s=;
        b=IdFKPS3TNzgK3XWSVK+kf2RfbAD+jfKw60v/CinIks2A7G+gLQdTzryP5f+19V4FZv
         dzSnsr1koFA9EU/M1NSRboIpcAYsi/8sym/gN0EfCdPphZBTteQ2iYOBMAzu2j+R52xB
         YsAcKYKbHkv58BTm+396flVEHeqRM733FUUhLF5EmobInHz9e8Zlm8dlKRjJ4HSY3rr5
         HJl8BWOaK5ZWfcWRFqZcpuW8u5/nRcGv+JjOo2BrwUoYcAC2T+OYr6MBxpWRH+WL5Wxf
         s2VvZmbRG3FXsSHgHaWZge3CM1E1oCvtQhtl5N8VQVRFndyBPNPVmjsUGxuoKyQayaeb
         V1kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781643197; x=1782247997;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2FuiWMyjXh68tYMurmD9NRNYivd+DBtBW0Gd/vXz02s=;
        b=Wuh5JXSjapp7mpIFAm8y0SnxVrmu/GRQCDoRAjjcjtDRkiyfWfD0og7CapSISXnppT
         LP/HlZgQI61tPGlTmgXumeb/BEmfgLG/Sm0FT/7zYziIlTXELijsIojxaPicj38d2wyK
         r1FDc9SN5sjxb1jkQTB3QVd4SpDRZ/207lTQfvNKebX4n7qdiolz37tTpN/B9YHOsjm8
         x3Q3aXfMhhLg+W+yJEm1VkJFu+lf+Ss91AhGWmpeksoKF8P2aV2iSwlZEh2yEntKrzyI
         LK2UZsXGfEtKXsGQHwkpKNV1pgXi+1RUKg/wAs8TYVd3p3EU99z+zHRJGUzCDdMXwJDY
         pmLg==
X-Forwarded-Encrypted: i=1; AFNElJ8MT30uKfaltK9IJDWh4kL6Nh16fH18+w4bDWxHImESa+0LF9un/gBsfpkNlnLjL3rVhqgPS/llIQ==@kvack.org
X-Gm-Message-State: AOJu0YxgOuHC/lkuIF4II6/7BBrV+LgPj3kuF6TvNqKcqIQ9Yyc3I+nV
	hJaQbA3nKjtA7TKp05fcXJdFMfO129SPD6XvFY4hrMXva3HP4hjO0LzhoEkXTw7OQUDTZAYyAnJ
	vK3LL
X-Gm-Gg: Acq92OHzEqLnmQ1oshGkTtYxxYlMLZ5j39pljf3mifNgXiEeLQ12Z1i3rgjXq4ncIdT
	21QUmypsGjm0VUYpTJ4TsuVnAULCULuZik2IL1jN4kTDqvF+IsoUpn3sB5uKcewj4XuileR+iMW
	t5tCfrJzMrscnr1NZuH8bF00Tc0BaNNZ5DW5d0f1C4xI1Vg6MeU4F9Dm0GDHvjUdR6/0zzuUJyZ
	w2bg+HVHwUxcL0w8RwlnroDYjTjyIXQh24SuYo0Vf8I+Kj/UpDFLmwwdy4efGfVhAUZyqF8PZoB
	3okoN9rDaZIWezQfJ8D7hYHMGAC3WKmRGlBFoJ8KHDjU+K6KQj2Yct+XeN5ssXGFFwvG6FoIUbT
	7MJgcRdZf0zS+2G5MLcqvbz6jrXX9D7wMptbQRg0XRig4M2UkbtdI1w+Eok7bPMVyXmdjrGqokc
	2eSyT/upvUweTyHLQM6spKpL+IbTsgbHw=
X-Received: by 2002:ad4:5d6f:0:b0:8cb:e63e:2a45 with SMTP id 6a1803df08f44-8da1f0168f7mr50299196d6.18.1781617496409;
        Tue, 16 Jun 2026 06:44:56 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F ([2620:10d:c091:500::3:437e])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8d9f4ff2206sm32423616d6.37.2026.06.16.06.44.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2026 06:44:55 -0700 (PDT)
Date: Tue, 16 Jun 2026 09:44:53 -0400
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Waiman Long <longman@redhat.com>,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Farhad Alemi <falemi@asu.edu>, Yury Norov <ynorov@nvidia.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] cgroup/cpuset: rebind mm mempolicy to effective_mems,
 not mems_allowed
Message-ID: <ajFTVaMBeu-ViGIC@gourry-fedora-PF4VCD3F>
References: <CA+0ovCg05rUk1-3k2ysdxmbcER8aG-wVh9SSTrrbp6LPWpPHYA@mail.gmail.com>
 <CA+0ovCgfHJHv5d1mzapWWvF-LhjppzDX8NPPLvCPZxPKg8RiYw@mail.gmail.com>
 <8d3b4561-92cd-4ebc-8462-5fb0fd659e8a@kernel.org>
 <ai_IHvyptWPcTD0y@gourry-fedora-PF4VCD3F>
 <70f486ce-5ef6-4d72-8cc3-7086f4eea930@redhat.com>
 <c1495b1b-9dee-4cd5-ac8e-eeb7a2d968ed@redhat.com>
 <51eafe6c-6622-479b-b391-6d3ff9350e75@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51eafe6c-6622-479b-b391-6d3ff9350e75@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 55FC2A0005
X-Rspam-User: 
X-Stat-Signature: bdduhk4diu3p8omxskmckwh3dy3wq1j5
X-HE-Tag: 1781643198-155197
X-HE-Meta: U2FsdGVkX1+5MKeIlEGwTPE7iuPBUokdnjbSghrmyEudbXJk38ytTTNJFAHNlx5s1TX9uLKgkPAbmUX8yviQZ2xTwAwvCQC8eu5k0j0ZI6ArTQYU+1v5+5DvG+9xg1yZeX+BVauPHcDbMfzcf2kYMGYy2kuLLf56bhZSThtelmtQOD/t0oXY/r9j4TGQcpb3Ds8ezz06JlDmINp0NNbcIh7pK2E6XdWXT1KqvTQvowut5RogOYiRG7ZO9MgohsvVS7cxrlZJFGtCSFDemOBlaaPcQdBFCi78XadRf3wKRGWyNiIi/hOi/QShVbZApbQiAVBRaR7MDs3/NhDb3bKxf1ku5yB4AM66k4oYa2r84DpCfTJyUz/KlBlSuU5dIb59jeuJIQFmGGQefwJC4miLYxKxcSewxIEmNmywFnTSlwCIazxnlC8DAHjTlkLcrxDpFYHUT/84qfDflUKN1lTK7nM0j7tdra4s/PYr/UgiImOgZe4dJO6Kb+NIqBsoZbTZebNo+GgzdZtnatuhFim6MDehj5vD5ax7vIia/DckXKQK7r5dVM/mplDYKSb73pgPWh2RmrrsVXctvk/NMk2jGbCKJLxNzHS07cumON6mjkdjNfVFCyzrp8PQEcX4oujGVaFd3jyQdwkUzUZa0zqN2hIoWz0gD44txPYv6TKnsR72OfdCbrEoYf4lGe+xKB6L9naABa9kRejU22HwALFxZ2d2ztdFQ6E/Js3GQjwoikVWcP2699/C5SadOs225wfXePp7n2eI+/3SQrYFLdbIJu2pJKcD06fMDpOakEu7XXSwR6B4zMYgie6x4CE0sJb5e0L8YlRuFACOK0LfDvBQD6QCloyhH87CcOn2pQPcmztO9DHQ/o+SUhF5pV3XUaSaKDbVwBlYIsFAn+jvDsnpO+k65wI28siNxejp69L8yAK3t5uECmxhxkSp6A133/MzLuyBvBV0e8MswxW0UQW
 vxBl9Vc8
 /nwQQqo4rnhlkrA8g6j+7poeb/K6apsfrAJ7UfJGRshcwjneE5vLqvUp37a+0TIiQDsLlV49mQaK+w5r3Pmk/kloDHYmdXV2M706bn4E/i+MRxYVzUty6n1h1pdry2dmfLod4mTOkQ+eOFGujpaIqNBA3JoADVTfwy8hLkEHQyieGitbA6vlOx1Q2l69ZUPfZ+NAOMTDT6Ev7EsOk04sbZOw2UNJmOhTb85iIMxviywMYjyLAV+uddMH6GV93UgSGMm9XszbROHQsNq6dBCpKJtFJZZw7tCChhxPC1KKF9x96up1AW1ofZPXszc09MSB3m6tkb2buSD7BifSaxmICvY3jQwa6sDA4XIrdPz7z3CRm8mGEDuqTaR8KEyt/Yv6w5APYt2NSi96o/X5cbGx6YPrWUVfEhroXsQcCrjgakrwIF+l10D1c4E6CsG6uKKQM6nzqCEW5+ZEdKuxfwmfs3pIh2dx9u6/SY3MDKhFsXI4lKhvKBUeYBiLHgKzJbdDt0SmOPOku/mwHyb0e0eJYXsZzxN78KA4D/EEgbYg4LzBZl8zofEfh+oue8rYnc1Sn//l/GCbE47EuTs4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 16, 2026 at 08:59:07AM +0200, David Hildenbrand (Arm) wrote:
> On 6/16/26 05:43, Waiman Long wrote:
> > On 6/15/26 10:26 PM, Waiman Long wrote:
> >>
> >>
> >> The reason why I am suggesting to use cs->effective_mems to keep the old
> >> cgroup v1 behavior. If the consensus is to use the output of
> >> guarantee_online_mems() for mpol_rebind_mm(), I will not be against that but
> >> it will be a slight change in user-visible behavior.

I'm not grok'ing what is user-visible here.

The two values should effectively be equivalent because we're
using this value to constrain mpol's during a hotplug event.

If the values differed, you would be saying there's a race condition
that could affect correctness of the rebind (which can't happen,
because this whole thing is done under the hotplug lock btw).

Can you help me understand?

~Gregory

