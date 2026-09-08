Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AAF0C79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 16:45:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE3D36B0092; Tue,  8 Sep 2026 12:45:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBBCB6B0093; Tue,  8 Sep 2026 12:45:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD1C06B0095; Tue,  8 Sep 2026 12:45:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A6B2F6B0092
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:45:45 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2A473A0743
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 16:45:45 +0000 (UTC)
X-FDA: 85191171450.21.BF5A86F
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2F0DF20009
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 16:45:43 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jZFrlEt4;
	spf=pass (imf03.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788885943;
	b=qBOcoEKS6nRDPq/M134UtK9wW4aGcLJhSt3Czzwd/u2Cn0mSGeRzozCGsng16g6pi6Zf3F
	7W9TUhbU/aDbs787Eep/4f+N6YkNbI0WONMLt84jxHwDYz9mOCmHHCxkPCYaf4Tutbgd61
	6czKFFvRwHI5X5DMDDHSTpxjaTZaJwY=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jZFrlEt4;
	spf=pass (imf03.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788885943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Emh4r7YyMhyoPJO25yHzs0ZWlSLxOb8NX5/sVQuWrzk=;
	b=OKDSJ4zNxvXrrbQyRM1KuxRoIfimla2QwtgxM+qOUhaBbRdS72NNjn8eDW25+1UR4F3d3b
	33OHag+Ey26XE0+My+pyxtDYuIYI6aTvTZqXiBOV7q33bdyOcQwMEFLu1qyvoounirlnit
	IEMD0MJtWbqjUtODYeZcVKNa70neN+8=
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-482dd6ee390so5556931f8f.3
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 09:45:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788885942; cv=none;
        d=google.com; s=arc-20260327;
        b=jYJn2aYZ2YT9PmVxY/RVE1l1/5TU/879rD41vh9fy2RjI4zqxg7MICH+g1X4iOaCLU
         sZzXa6MX1A311Q5BVrgtTmEiZF0xMRn/3i5GcVvzUhyYK6HJZIGBC7HCZwtLpV/Wx/IG
         RymWqzxkHynOaMI2L8+qkdN2RXhCtLD6DuE4nmYnGb4jr9lgWj+XakfOsBFwTWnS3tZy
         CtjhUkvPNiziqjJNj8q2Cq714zsJ1E8X8gq/lyPDUaDLA+j4RFM5iTss8McGyCi5JiVe
         7bo8EZ4PXqQECuxKlA0VMV0OrlDAfJERR440zuZajBEEX4cwYt/Df95yRGl509g6WhOH
         fkTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Emh4r7YyMhyoPJO25yHzs0ZWlSLxOb8NX5/sVQuWrzk=;
        fh=lKUbWIcn9EUN7LJq1LRmHs4t74PwEATCaU7nZy8OvkU=;
        b=p/22LUOuEauEJns88r6NkC2XjszRAh6tA2fFm1ku+m2QnoUj05LdtGpQIL5rE/DDHt
         JGKo82OFf7U6eVJ6KxobbEXHJhGP722kh8DCzm8P39Kg5cvqRH72ggXApVkiGTIQ1K9V
         EmDdRYFXapxXm0CrbCy1TOQSpbUEcJusWokpdbyv/k0D9kVubBLxXHFQmyPevLRbl+r3
         RSceshcjL3pFXRT8UbC/AK8xN1jQKDafFKV4ovO+MyCWJ1RpZBcMU2g77r9iJldzOAH4
         AJGoZ98H1G91M91wqRfKtVi+e23OPIBArJEBFxIvvazhdQQWSFtzjAFXQ7ViXJibrSKn
         L/Ow==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788885942; x=1789490742; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Emh4r7YyMhyoPJO25yHzs0ZWlSLxOb8NX5/sVQuWrzk=;
        b=jZFrlEt4j1EU3oG3pR0IfHwAhDIpsh39R+HWglVDi77MwoMOCF+eyUTKRAG+kPPO7n
         /dVa8/kaincNnaToi4FfZNtQ4R+Zhh06qZ78dcvE2n8j397f6y73fUoaUW0yy2RZZzNl
         vjnz3ygJcQi3r+3Xhd8VM2WvyafWFeNsz4nTNnevvUAWa/cUPqsHyZEy7szAGxVwaHA2
         PjvuxxDf4dNYG4XkeftIxZenQsP2e+01STrzi/NeYQUOKk4pJ5S6WKl2PuyC0W6RfN2u
         X0oq9Od5LkguwUHQUUD4aT0TqakuppvZ7HL0tvA+0gRkqJL0PhD3U1542fFwGhAtane9
         fnOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788885942; x=1789490742;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Emh4r7YyMhyoPJO25yHzs0ZWlSLxOb8NX5/sVQuWrzk=;
        b=S+G9E+lHq4QE9ESHLI7k30G94X36rNnt5soTf0bi/HZoNrqxB1Z7WcgIHxQYCp+6up
         dYIjr+uFtiUBXc7fhW/l94HQ14tv4JSIcvkgKprdLiJYoCBOJHyOZ/0tr8VWFXphcaaj
         3AeRDr+IwvVyRcH/mPHJg2okpPJQom1/bsbKKm/hRlLz0wrJlxTQUDztGkZN239uFUdl
         L2KixmeNpfUAtPZysnIZkBl2r9rN64vsd2aLTgqIA4vI5lELFpdH2/waqaZxIRfhhS6C
         WuWn/3hSVrP8EBbtclFbAecPhmqpU+QUfuAtDJBO0iTJMuPNnpJ/mxUP540eGCAQdi8t
         8O4A==
X-Forwarded-Encrypted: i=1; AKwUvBxOLwuexfz65iOzc046elO6jRsXK168Lk239BvrISUaax6SgzzAAruYf5yvdOjiJedEVDBTSkOTGw==@kvack.org
X-Gm-Message-State: AFuF++mxCYf7C3FqQ+OEOglxw4vL1Jyw9jnKDZmny7i3dau36G2CxAi+
	3GWCh5u7jZf3C3zDXXe2ctT//UFPAWpSnr3HfQNF00ekwDrhZ7MPib0UzcdU2dLQ+Fay7MY2DtF
	PRFVz/bKVl5Q5hAXKpyHsr8GuhXEHiY0=
X-Gm-Gg: AYBFou2S5BQUXhg7MX77TbolnOOzTz183iJ9R+oJL29vu4wtUH9833KghrKcm53BqXe
	hrLB65lE3EiZIiEk1gFOScrNEomWzCq3ZgviMSKV8fMMdzgXBiLiV9S4i9wBVenxcuGVU+VGoLh
	1Gm54y7eGhLqs76iwoGYeV89e4pRg6+5cDulhLxDP8ZYc/X93Wb3h0TOa/RGglw/LyffLaIZask
	kxDaW+Ss221eV79ZXyeLwORyB4P8J+We2+JVj+5fo0pOVlhx4zSKvZ3If43Jx2qPputqQsOWmYN
	RA3zOGuqNDLvbO0aFzMbXBL/QahL3bY8vRP4okdHp0Jj1KS+IAkRFuJl06WxVzvWvQTtIX4OZIe
	y
X-Received: by 2002:a05:6000:288e:b0:485:8c16:a33f with SMTP id
 ffacd0b85a97d-4858c16a5d0mr27884309f8f.52.1788885941502; Tue, 08 Sep 2026
 09:45:41 -0700 (PDT)
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <5fdb3777-95a2-48f9-bb38-aa4ba3c96a81@kernel.org>
In-Reply-To: <5fdb3777-95a2-48f9-bb38-aa4ba3c96a81@kernel.org>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 8 Sep 2026 09:45:29 -0700
X-Gm-Features: AcwNN1VKHJXv7OJIvb-6r4VRgrNUVYMe2NFk6RQyVFERhDXV76DkbFan7U8qPdI
Message-ID: <CAKEwX=MuW6q354nB3tyFTM8d3ox7LRaqcSfUxeATR=Sop5mZPw@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Kairui Song <kasong@tencent.com>, Chris Li <chrisl@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Yosry Ahmed <yosry@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, YoungJun Park <youngjun.park@lge.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Rik van Riel <riel@surriel.com>, 
	Gregory Price <gourry@gourry.net>, Wenchao Hao <haowenchao22@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Kairui Song <ryncsn@gmail.com>, Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2F0DF20009
X-Stat-Signature: 8xhn3bp5warxk3msxg4qzd4ybmbz6dfe
X-HE-Tag: 1788885943-558202
X-HE-Meta: U2FsdGVkX1+1DfCPO/LQqFBQZ3pFOKEpTQ4kmDzU0HBkd69CyVKGi8dvC3x/SUNMsMsqGH6v87e1Tr8kCcUiCmmFigV8b2oYFc6pzrdpyN0kxsihfBd8tZi2R9yIfQr6iTuP6SiLEzGtj/DK/FazPuyolC/7OiMOEYrWf8TqLN3PGUfP5coY/WqdagXS+KkeofPXpw+hyEn3UhYbfiqJ2JwzsVjs4DxwoQ58+dP1JLBDsEzUUj3l6ZhnZQ9AiW63cRLMU85tXdL1HV1YHSQLMlw0ta0gUfdfHnBMcTEML4bUAcj7neq0ArNdVeC79j3KJGORGjSmZRQorjr5QK1mSXyJiQcGU2ku0Tmbv6LQrlgMBSg5qyvsUhIPpvaX1k134fiG96YfFYmJR0kygMVvoTFA4PJxmuXOyGeBUJzvtTeaQTx3K2tLqMuGHVDEEa3HIKeo3aIN2mhDr6wMtgb35/Y7ZcFbI48S2mOPUfs+s1kpvR5L/ykDfs7o2FXdPTK5pD9P8czmSJ9YeuAFBHPGw2ePdwL31tIMAp8Yhncyxe802cGu2IWHJxa29VUJdul3AROuUJsVXo4mBbq5MDr2K+TZn3s/fJ4idA3U9WAX+x5RdyaY6oi9noLKQ3TD8Lvas1rTzEB8cZOq5mRqMTkb83gH90qwvnXgj02zQ2gOeFpyPeSt/6eb8O8An1T1TKR3VPh+OnAXxCvnHJEJNmXKU4dNoBUIGw54FCMg8zCYAUR7Ud2/C2RMfgm8enV/vhHuF5mb9R2fa1V3XLcETfsPzL+T/+IoKtPSkAH5vYSgaTXsoSg6/P4qOndVcJ/SKZ+aE10Uqj8dL7vEWaqlqQz73Z+ub2sNLKt1xDJOTxUJSe3hhHRMY5eKjN4ZjFNteqf/L5u1zMFbXDLsBb96NuxBMHd8c3+nD/CC0A28lVkTo7L83G4Nr8Te1cUM1w+E88ycbrJavNFKyJQV/t8u+gj
 FC34pGtK
 Ef3Os31PdpvoOqo1AHzHvWdYoxU2yEG0wC8XpJ1elOPx7WQ8HbUr3494o6U1BJdPD+3RjpAg7sAIrGchU9KfA5ymnpMYPKFxbObScAD2Gn2Wq0Ku3T6OLsPLIBlR929+qIx+/RKIOWe5E0o8GFLK60PIKn4js4ebvka6a0mw5ACusOx+9Bje96RfOV/pWqR8fdiIgwhWWV9ElFbkO8gq9Sxt+jnHefWGRQrnqfu5P3DzDSzqEMzo8Ld3E4MRCPEq1vZ08zurG9pabi36PDfJ0kpSH/P3ZyA26dvImhYIuSkincaGtVltH2JNZe62KbEOzWwGACOlpCltAdhQu9FMjFv7F38lrZQuwkNoOZZecH2AE+c33vyR4g0Gbj180KoOJ45ilRYQexTgOEDpyRg7FSYaR62YE3CwQ6YqTGbfFBQRgJ+0qUSqGf4ezbv6vuPu7VbnyS5dO0Nz4Qyf2hOKRpchETmQvOa6e/ZUu3n7cT5aObD+vcu92N/LjGckJcJpsi2xvcvaUtHM6hP+eIEFkIQtEh90uNlUZNaVF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 7, 2026 at 4:30=E2=80=AFAM David Hildenbrand (Arm) <david@kerne=
l.org> wrote:
>
> On 9/4/26 23:14, Nhat Pham wrote:
>
> Hi,
>
> > To Kairui, Johannes, Yosry, Chris, David, Andrew, and other (z)swap fol=
ks -
> > I need some help here.
>
> I'll mostly ignore swap-related stuff because (a) -EBUSY and (b) we have =
quite
> some swap experts around :)
>
> Reading below, I do wonder if the swap subsystem needs some more coordina=
tion
> and collaboration?
>
> For example, maybe having bi-weekly/monthly meetings to get everybody ali=
gned
> and uptodate could be something reasonable?
>
> This approach has proven fairly helpful in areas where (1) multiple compa=
nies
> are involved (2) many concurrent development is happening, and (3) people=
 have
> different priorities and requirements.
>
> Is there already something like that to organize development? Should we g=
et
> started with that?

Hi David!

Thank you for your suggestions :) More collaboration and communication
is definitely needed here. Conference is a good place for this, but
it's not something we can do very frequently, and many folks could not
attend (visa issues, etc.).

A bi-weekly/monthly series of meetings sound very appealing. Swap
contributors are very spread out (China, NorAm, Europe, etc.), so
coordination will be tricky, but let us figure out something.

