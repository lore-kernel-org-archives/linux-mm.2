Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40ED0C5DF70
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 01:29:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 323DE6B0874; Mon, 17 Aug 2026 21:29:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D4666B0876; Mon, 17 Aug 2026 21:29:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EA506B087C; Mon, 17 Aug 2026 21:29:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E7A556B0874
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 21:29:51 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 55BA1A0A20
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 01:29:51 +0000 (UTC)
X-FDA: 85112658582.26.D343ABE
Received: from mail-pj2-f9.google.com (mail-pj2-f9.google.com [74.125.227.137])
	by imf18.hostedemail.com (Postfix) with ESMTP id 890761C0009
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 01:29:49 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kcFvItY+;
	spf=pass (imf18.hostedemail.com: domain of foxieflakey@gmail.com designates 74.125.227.137 as permitted sender) smtp.mailfrom=foxieflakey@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787016589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wI+nXVhWBXmpzGybiKLQBExqkPKRniEJEvn4VEGH2nY=;
	b=lxfpXzuwrQxP2QJgFXsKS8ZBzWRXW5xbXIOtgoY0wnWdlbA9yK/FUUINq3kSU3tIp3eEB1
	oyo24eXlUpxtDiKlONX83HuetgIUEDBGRKsq97Yb3//n87aInvj3Bs0HNTT3sTTA2stNNU
	I55WdgLez61Z8fUmeT7G5HRbu6MDwr8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kcFvItY+;
	spf=pass (imf18.hostedemail.com: domain of foxieflakey@gmail.com designates 74.125.227.137 as permitted sender) smtp.mailfrom=foxieflakey@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787016589;
	b=X0q2uw/0tZNin0wpFAluPnqW7F7fsS4c1MxSr7ubhwjIqfDmg1qulwkZYf8PCY0wUgIHiY
	DN9aNBqYV8vzYevKcuoa1vtnC8VVE60a9tZRs0c3IJPGtCmXgAmNUvsPKq6Vno+uvb3nDm
	ZWcS4AGgYzL0MyDhDnU36gBNlzCMBxU=
Received: by mail-pj2-f9.google.com with SMTP id 98e67ed59e1d1-38ed4d37526so2587557a91.1
        for <linux-mm@kvack.org>; Mon, 17 Aug 2026 18:29:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787016588; x=1787621388; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:date:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wI+nXVhWBXmpzGybiKLQBExqkPKRniEJEvn4VEGH2nY=;
        b=kcFvItY+soCrPEFTCymaZb/v4cV6S6cLBiRSovU9lL/C0qHg80sycdPKdJxbEFyccs
         23LFnOgwVlYxB71xA+89K6FkcSj1UoOOPTI7mk6j0Z7RmRDHGRKGTvc+h0riYCxaL352
         Ta72sHuV29/uY468wWfQUegvnNVvMCslBNv9fUXao+PafqFISXiaJWZCTldYMLkjwMVa
         071rLuHvxCoQQpB0Prg7d2mEcvGaiI3WbundW5KEqDQ2jY6mwUuzO52FHIdWdbiUEAiO
         Zut3E1Z/IOvfOlcXeGfPRRJbY1JY1hDDgQMjhkQM/mHiHkCDnNl/cXdNEhZkjrZxwLrB
         tyBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787016588; x=1787621388;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wI+nXVhWBXmpzGybiKLQBExqkPKRniEJEvn4VEGH2nY=;
        b=dtqFWkj3+bSx6VD8x/hB15w+9dDstTxPkanQ5x93pEaDd5ECHbkx0HlZQfRVMqHhbx
         kMOEZeWQwOJF5tWDwD3lLahXrZ3hlU9uU+3Gt96KcJ6EK3sIpjt7AwetiuEI41tslMbb
         IaqgISp2xmfJjwdCISdIM5d9eHBel3VyeS9pS9khy4zG3b50ZPW1yYNv8S5YdJEVSedY
         ufVHpTiYJfW35Kij0k741OqOSQeWvJoQVwVYU168RkERKSnqnM0fTsrnTO5gvuzRVUg6
         80eAEXx8SLrvXKPjwz7vLtISLr/6jD1dJ0ysafqH6ENrS+s2sYA3YiyKyhbybOhMWtiI
         LBbw==
X-Forwarded-Encrypted: i=1; AHgh+Rp1FB/QSPrD58QYajgdWTAiZmtPDxBUImoadfX2IH8UuzLOpBEmY4/4y029XWUNrfls1OfbmOZ4AQ==@kvack.org
X-Gm-Message-State: AOJu0YyxPTs7fkPfzhZfxiE8etHDjM8G6vKm2zhQNWb4KiyAke822zAT
	2B0OWDBgAo02hlbGdf4z3Z27A/UgeMJ38AjmGtCszIWVFGwW8lc3ijD5
X-Gm-Gg: AR+sD12YhBVhvrlJd7bxXdMK2fTTT8OdNnX+KjREW1hkR6lgvTK2bX/txvoy/Cvv1oQ
	6FeNiIar9bSvHr2x98wGy4oVN1esKgTUJRqJU9bge1BIBFmA24Fl8APOD8qnOLCRu+HL+H3d6vI
	YdNiZ4FK1XSfIw4dSvZsWMG6qLdBfPDRBj3jgijQFk760lnGm/12JElGY+oY0Vv91KJueVa/Eqx
	Zkt68xMxMLru3KCbKamV+0wMNTCX2xfyyqWzFI+Zsjh9CG6y0ef2lwvTEPXDgfXwVs+TvOPLoGe
	1cfClyRFXWgNannOzzuEiaPlw4glN7TuZpVx9G4OXjxd67aOdfwLh4Dh0F86njQqvaw2tkE+TCg
	6GGptFP73JdW4ySjQoz8japEp/OyTrNYBY0HmJJN4AZZDfU1hWuSgIEryKh2bf++sAl8U2lsjD0
	1gkhwOEAjl+mcSEK5i0cAENNYLUrUvyG4I45SdVNrGDt2rNVUQA+hupEZd
X-Received: by 2002:a17:90b:184b:b0:37f:eafd:3505 with SMTP id 98e67ed59e1d1-3933b74d94dmr34374872a91.6.1787016588143;
        Mon, 17 Aug 2026 18:29:48 -0700 (PDT)
Received: from 192.168.1.6 ([140.213.202.182])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-141530442c1sm9748744c88.2.2026.08.17.18.29.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 18:29:47 -0700 (PDT)
From: Foxie Flakey <foxieflakey@gmail.com>
X-Google-Original-From: Foxie Flakey <foxie@gmail.com>
Date: Tue, 18 Aug 2026 08:29:43 +0700 (WIB)
To: Andrew Morton <akpm@linux-foundation.org>
cc: Foxie Flakey <foxieflakey@gmail.com>, rppt@kernel.org, peterx@redhat.com, 
    linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] userfaultfd: reset err to be 0 when move_pages_ptes
 succeeded
In-Reply-To: <20260817153501.ee2ee77976e1cd5b1e1c813b@linux-foundation.org>
Message-ID: <05cd197e-da6b-1c90-fc26-315f273e6663@gmail.com>
References: <9c936a9f-ed27-e510-872f-5b3b8c680975@gmail.com> <20260817152605.5d2bee3fbf1a2bace4c0eff1@linux-foundation.org> <20260817153501.ee2ee77976e1cd5b1e1c813b@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: i4eit1ihuhboctee53ej1w5f6dyswzrc
X-Rspamd-Queue-Id: 890761C0009
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787016589-741708
X-HE-Meta: U2FsdGVkX19vePK1xjkEdhYYWX6KdFsgYIu20YSTctZX0XYlMIjlhZcy5R1Iz83uhaJc5MiUtEhfNaP3NkMF0/cBL6bRd6yF58gTvx3UjF7EH0eZ/d3JJNiAwLiFJmrQSAxEu/cgr0KpcebgVB+tL5R8x8zNhFsmDu7kSHv+hGvLSM/L2fWu8VWhJnw2syg+o7xGNbXhgSwdKk2/hhGgEMhhWKrZilLvIQF3be9GLjr4nibL6omfp93lfeEoDXxuvnQCPIOTQmpAl7Nv3EE0y8H2Pf5c5fipix8xF7nxio3FxcKsaMM9MBseNWDRqqsUqYyCwmuzj14bpeAIDQuTvvp/u9lL1O6WBNHUNGp5XIQigxvhOyxtuQlXV8xPqK9FVfTrUN9OuCJptghI79nbVNxynjRG5njWBR73kGvJSAunrtWhuddA2HZVk0xzl9oO2zV8rR65UWVmlu2bV0w7dFxRAk7rdSc+SDMGjnNILLpz2QEfSTr5ROjph/etnnXH7ZbhUVRcvR5OcNHEG1c3Ku9QpXo9JR9sPcejOseFd5lRTNMGS0kc3IScFN6F3RqIiv//2K4u9glRjIYV/8FVD1sa0EuV8tieg+98sjFPqKU6YlmJO5juIBllgKWTnmvdwesLqgAx9XZvuEtXcOKUvu7LgE7fHyQhzFNfxwpVY+9EhXlqh3Jvbsq7cfeR1xrFnAJpojCHtg49lVxw7+I077u+EoL2QKzdkgVxgFYQbXutSmBfA3XuDULSh3tzBC6IavkclL0m0XTxhOhtKifzHP/KruspZ0xHtofnwEIzpvSQs2UbsdlRhH6JJ43xBxsXfpnrlBMSc8AHjuk2nAweXJqvY2PZzurVeIF9lXfWt9zt7V3x/Mv0WZ3AhYWYPro9VtIAJvqdYDh78JcAm67XEnYfU7+6xEJ9VO7K/cySGaJ1i02mpV/hP3lMAWIazzfPLJm2zLqk3whSR03R1LN
 37ltiVP8
 hP+T4Xodp5hAt+FfXevlAKZqjazOvSnDRqHcjPaxNxyL9bsjgf+1F4DCCPy4wzVvI8QXkcH98v5MUkB0asv7pL3HMcwfRzIYCYpf/07dGuimmzRqDMGIqdsyaFUlJdbW5cZOJb/SomW5w/ag18kbjoK6pt6TpRw06ETXJr9idgivFzuGGma6HKg4AJe6RvD3UwTJMg5V+aZBs44mNP9uBg+fquvK1eJdK3CebPV7rTbgVCyaCg68Ku1wpO52Shsw5zef8RTt8YXAlzoHWgnWXQu9mHgl9VkDaZ2c579sID1vNd2T6q/6vBH5eiHhI0EOLjSgH/b4MYQN5W6HDGaYIgiXTM2KMByF36afGfqgid76BrsDL5tpoeIPRXY0jF0398RkQvDqulc0+RJ5KD4iIONHmuM7Yyh2Q97T9frCTXqCQ/4P1hF2F0lkLMEI708SZTz/FUIUlRnUC0SShwWtA/5o6XBzN7qqkaljbengZuYWtGgBDMp3PSd9V0fDla3CoSEzpriIirfrF1LbXz4agAApxLq+u8bS4WdWWBmsna7qj7QSNuCR76GNedANNMu5qn7L8YmNgyEWoYRMB6bE/MADq727rDwpt6AyRxNNGvQR1+NjIrp+ZTdbxyzzKTYKWZuDWk2nSIo+0/dYL3UhVoSTWjw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 17 Aug 2026, Andrew Morton wrote:

> On Mon, 17 Aug 2026 15:26:05 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
>
> > > That behaviour manifested into this at userspace
> > >
> > > Source:      [ .. unmapped  .. ][ .. mapped    ..]
> > > Destination: [ .. mapped    .. ][ .. unmapped  ..]
> > >                           ^     ^
> > >                           \     Kernel moved this far in actuality
> > >                            What is reported to userspace on struct
> > >                            uffdio_move's move field
> > >
> > > When the previous behaviour is
> > > Source:      [ .. unmapped  .. ][ .. mapped    ..]
> > > Destination: [ .. mapped    .. ][ .. unmapped  ..]
> > >                                 ^
> > >                                 Reported to user space via uffdio_move's
> > >                                 move field
>
> Also...
>
> I assume the above illuminates lack of coverage in the uffd selftests.
> Is it hard to add a case to detect this?
>

Yes, I do have self contained reproduer test but there an issue.

The issues I have is:

1. Its only appear when system is under memory pressure and is swapping.
To create enough pressure what work atleast under my test environment, is
to run many reproduer till the test system overloaded with memory (No, its
not just  "dd if=/dev/zero of=/tmp/garbage.bin", that doesn't work reliably
from what I have tried).
2. It cannot detect if the problem is fixed, because it ran forever.

What I have thought is somehow rig function move_pages() called that
performs the actual move (which are move_pages_ptes() and I think
move_splits_huge_pmd() too) to fail with -EAGAIN on first call and succeds
after that.

About memory pressure, I figure it has to be related with memory pressure
as VM that is not actively swapping, I cannot reproduce the issue at all no
matter how long I ran it. My hypothesis more less (from my limited
experience in Linux internals + personal osdev), swapping likely causes
move_pages_ptes() to fail temporarily due some pages are evicted to swap
till they moved back to be resident in memory.

For information my test VM configuration is:
Distro: Ubuntu Server 24.04
CPU: 2 cores of AMD Ryzen 3 4300U
RAM: 2 GiB (the lower the best)
Storage: 8 GiB

Kernels tested:
Linux 6.8.0-137-generic -> Unreproduceable (the stock kernel came with
Ubuntu 24.04 which is reason why I used this particular version)

These kernel came from https://kernel.ubuntu.com/mainline/
Linux 6.16.0-061600-generic -> Unreproduceable
Linux 6.17.0-061700-generic -> Unreproduceable
Linux 6.19.0-061900-generic -> Reproducable
Linux 7.1.0-070100-generic -> Reproducable
Linux 7.2.0-070200rc5-generic -> Reproduceable

