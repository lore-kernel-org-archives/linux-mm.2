Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 622FFC87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 16:41:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 086346B007B; Wed,  6 Aug 2025 12:41:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00FA48E0003; Wed,  6 Aug 2025 12:41:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E41388E000D; Wed,  6 Aug 2025 12:41:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D329B8E0003
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 12:41:12 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 848C4B9DF7
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 16:41:12 +0000 (UTC)
X-FDA: 83746897584.09.223823B
Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	by imf30.hostedemail.com (Postfix) with ESMTP id A006F80009
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 16:41:10 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GQf3uKkV;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.167.173 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754498470;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KKjnlbXnuZDOVwbZXpA57f2rMGHXfB9Dj3veqVS6tjI=;
	b=soJp6SyE5fP0peI1XqSsaIATbi5vKcmSJfoBrtX6FOq1VXhs/mCxPMxrAx4OjO5tcajjXO
	7ieURBZPphSv3/3lQUiz9Fb2H3/db2d7ZcwypvMPAajQWafIcfkT9vCTJCR5CORDOQxLds
	8KW2wLe1uayJb9YztLONVSLh4nbt7rA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754498470; a=rsa-sha256;
	cv=none;
	b=TumDQYwiQ0ZzNsvSU/SHFVDWJyMXUNzDRhUjuz4+Z5WVy+IAp9+pLC7vfu/5VoZC9CleAh
	S2vQQwITSW9tXXeeUdNoz4xVRS5DuuQ4qIDjIL+oWFFNWeuFZlY/uC2xkHNevbBUA0TpO0
	iiPkWnXjtep63/g/uDMU7vAA8QCvraI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GQf3uKkV;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.167.173 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-433f3bc84e0so85721b6e.3
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 09:41:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754498469; x=1755103269; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KKjnlbXnuZDOVwbZXpA57f2rMGHXfB9Dj3veqVS6tjI=;
        b=GQf3uKkVkjaNkbIZXwN8+TIK/MtxmgMAWMxTlRpTRZ8xUeEX2AyxSQlmDJ9HGCNDvp
         crmtnJSnHHXcFK9zMXx6FfaD8qEX6MqDWTjhcmUo4CxJPYINGPNrdVgPkSvYnWZn/tUc
         m4oCq8muJUM0fRqZjx658ZE2Dqg57h1OMUP2LnDtGrHYnTGa3UrzdYaGeIOAz7DTXPzW
         LiFYOVlF5JA2p9Ge+bhS0jlPZIC14sH33zPD7S3g3q2LlwadgMIJcEMCwkQoSVGbrGUA
         Kben74jgbY3XTpM0h/1+k17S+M/JZM3AveRMeuoJt3P4gPZOOtJgQ9+siA+EbFWeLXNY
         NXtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754498469; x=1755103269;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KKjnlbXnuZDOVwbZXpA57f2rMGHXfB9Dj3veqVS6tjI=;
        b=Wk95qJsP/NniCHW6bmcpciHtebvoxy+3XVneKHGbOHv+PYr4Yp65PD4D+6V/8z8k1t
         uUf1yUhJR7uppP4xwKj7rw5gPTj/UW66pSza577M7AVHaIqEj/tmUKKnIU3NVWhs7jW7
         MvYgriAO8D7Ob080r6PwEmiIzHK7QpSveVc8mbuo4nw2FWSgt3eflquEPGsEa/UkY0aR
         s3kBeigc98aO533FlLF3jO5nWcVTV0lPFHOuORDytkkBFg3OobrM+aeYI2qRC8/aE/i+
         IDRnDVhRjaOGiHYFCsfD+m1N8+tN3qoTrny65C6faNtZRTBSPVVOF39qKh3tLHzFYV9c
         J41Q==
X-Gm-Message-State: AOJu0Yy2OQHB5abs7S5azjczavDG/Jy3CTxkXlPQjKLeB4hfCfRMyJe+
	fdLnHxym7FEinl27gPeiNxIRNtIrAYZvfRZIOOM44Pv9aS+s4rGuh8wgey6gSo9vU3AEXqjhNZ+
	d1MeP3Z70L+SIX8hMzERbbtpxuqjTdcA=
X-Gm-Gg: ASbGncvJQgzz6Ty30DRzNuk7mbaYWfGNi5yJe/g919hWa+KHSL0cRHI+eJ5vyNuMOD5
	PJv82rR19f00rJZb51N4KBi5luOA182u7hjI8U26oZkskNOqUmqJ0hhHH7iWaYkogZqsmPFtjgt
	+LUjQqouLePmuFkisGA55b12sCQPyTZX27TUHOiAZeV8EK2gx4wCUbdPobd1Lv27b+K/a1mGSO4
	d20Q/k=
X-Google-Smtp-Source: AGHT+IHBrOu7yFP0WeByjmPefTQVEwMJNMXNbJH0N++jTBTymV1JO4pREkUjYBUyktFlTHy2+iLdO7/FhC+BPbomTRw=
X-Received: by 2002:a05:6808:4f54:b0:434:bef0:2f0 with SMTP id
 5614622812f47-4357c2d732bmr2028110b6e.6.1754498469571; Wed, 06 Aug 2025
 09:41:09 -0700 (PDT)
MIME-Version: 1.0
References: <20250806161748.76651-1-ryncsn@gmail.com> <20250806161748.76651-3-ryncsn@gmail.com>
In-Reply-To: <20250806161748.76651-3-ryncsn@gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 6 Aug 2025 09:40:57 -0700
X-Gm-Features: Ac12FXx6LKiBeTs1LYzlP5VfWgE4JIbB2kDZOxmdeXAg57zMCFN1ArHE8cj7vwk
Message-ID: <CAKEwX=N8sUdAfgGdHs+S3Sr62AJ94+6nbP62Smv_z0xxzz_t4g@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] mm, swap: remove fragment clusters counter
To: Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Chris Li <chrisl@kernel.org>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	"Huang, Ying" <ying.huang@linux.alibaba.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 7pj1jabrs14dgt1nu7hfd5qfkxipgi64
X-Rspamd-Queue-Id: A006F80009
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754498470-342767
X-HE-Meta: U2FsdGVkX1/9JuRul5JjxyYLIGQH8KoMnZgPH2hcR6rt9dBWCiy0/ktU1Uq+wUN49PqW3J3aT6SmH4zhBriAoO4uGwbfYRolF+BUXXKrxxGYD26IK+YlidW7URvfPbefFozg2B2A57KRXPnc1H+f5Mvhv85FzoFmb22izJcGLGLZppMhrwowO0AmJoUoZJeWllEIw31fbOKdgfe6o3wwLjsoSQ+LLvPDuSvwl8D0r5ni/GN2FN4j+GU9N2bJBeAwwtNzhbopaeMHSkYz2sgY68sGsEoLFqAN6Tk8+vioAz7nKRKrNx76zmxZUOPRyNbCLsswy05NlHNpiyMVgC88HM8bYmIbPl0aBcGSZCHzdqRGUKKFPh0q0+ekSFvwr5flcvfdpX0AChJjn7K6Ixj+rKw1xa2hUZ92L0Gv6DBxzJ/K6IBI4zfob/9fj/4tp1y7ZUdbzO864d1RTn9bjAYmkSoQAYSHv5CUD+yBgjkwlwQSj8INJQcnIoivTA8Qmut5QJr3KCvlBExRyscnWqCys3S2xJCSMJlT5L318fx4sCDpfpwrjJ0qdftPzoGxfV2L+SYddU6s63g1OeOTFpLtnu/JgJi/0pTVq5PMpRwA1a0AVoJOGgC7l1hJHG/KjpmwtvM0ihk07BjgU40SCZQdc5h+QplK5MWz48ilxmYRZi4OqC2ne22x60g+qrLE9yfmcyu51GxH0myNViJGHcK19VGMl7aUsCG7adkvCFRBYemOsj8fZqwTl/TRpfwzL/0Jq3EZF5xK5+xO7YYWeRPSZ+z//47erW3QM59vKzlaD/kvLxmIHon3S36cpt31n1bhC+fOx36yJXH4CBYxAs/81GJjT0AirO3MgdbQ8FYf531mnzSniL9i7zw1RBPCfLUJro08nIBQ9dF5ubVrDik9assOyvwTqJvVax+yU0JHAo7r5luXugLY4JaqYSGmLwikYQexKUCBPoWiC+N9+mI
 w5Gaoe7+
 ygDLkvcYQebl83kDhln2Wsu0t3mFTnx3yl2P/+l1Ovqjl3VZ2yhtXmcCcPxgw85dgvl3prIts22cTh3aY03uPQsOw2RKmonrOGiXqflXtQuiobMoNhafrQjOZ3FF1fenstqorRcjS4C8lQ/bUtVS/+qvttD2itA30s9qLRlsm0SuK82wfGSAYh/ZVM7gyfj1AC0ju0DZsFjZMHWpsfxeHcsLSXKq+vnbOpnftc9A9ew4M1g22XcA65mJZrR4qbhda22iHXMhzj0E0+clCTUrH0mvPmuR26jLytA3oo5uCDDdHlwfJJW4P3HZF6w3rmgYY4nWrYQ8VmyyqZBU00AqOurv+gnH1W0UUvyOQIOtK6gj8jnAZLUCKjmc0hI2yHxZNCgT4pqn6PmcyJvIZmtKvcP6jdg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 6, 2025 at 9:18=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrote=
:
>
> From: Kairui Song <kasong@tencent.com>
>
> It was used for calculating the iteration number when the swap allocator
> wants to scan the whole fragment list. Now the allocator only scans one
> fragment cluster at a time, so no one uses this counter anymore.
>
> Remove it as a cleanup; the performance change is marginal:
>
> Build linux kernel using 10G ZRAM, make -j96, defconfig with 2G cgroup
> memory limit, on top of tmpfs, 64kB mTHP enabled:
>
> Before:  sys time: 6278.45s
> After:   sys time: 6176.34s
>
> Change to 8G ZRAM:
>
> Before:  sys time: 5572.85s
> After:   sys time: 5531.49s
>
> Signed-off-by: Kairui Song <kasong@tencent.com>

Reviewed-by: Nhat Pham <nphamcs@gmail.com>

