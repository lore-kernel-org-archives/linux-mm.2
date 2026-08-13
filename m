Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29D4CC5CFEB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 13:59:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44BC26B04FB; Thu, 13 Aug 2026 09:59:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 423226B04FD; Thu, 13 Aug 2026 09:59:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33B726B04FE; Thu, 13 Aug 2026 09:59:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 00BCA6B04FB
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 09:59:41 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7ACF2A11D6
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 13:59:40 +0000 (UTC)
X-FDA: 85096404120.27.8331AC3
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by imf17.hostedemail.com (Postfix) with ESMTP id A53414000C
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 13:59:38 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=LFjR4Wzg;
	spf=pass (imf17.hostedemail.com: domain of 3yc19agYKCLYoaWjfYckkcha.Ykihejqt-iigrWYg.knc@flex--seanjc.bounces.google.com designates 209.85.215.198 as permitted sender) smtp.mailfrom=3yc19agYKCLYoaWjfYckkcha.Ykihejqt-iigrWYg.knc@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786629578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yp2r6l/p49Xe2R6+sIrvq42A9Bi9ttiTK9kJ5Xxsr58=;
	b=v0dh9Ew8q/mTE+5ZK6aH4rEU6Uz8MyRUAkDOe4LCu59KoP3QcpN7KPGBtCFk9jcoFA+m0i
	MhLtW9ublzBWzaldiH47y2ej0LMqqtf7Bcw8vZCvwO+sDhscAuvGuRzegf5B+HNdD8xFWp
	B5KFppUfPVke6LxxJ6D5UGzsXltfyTM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=LFjR4Wzg;
	spf=pass (imf17.hostedemail.com: domain of 3yc19agYKCLYoaWjfYckkcha.Ykihejqt-iigrWYg.knc@flex--seanjc.bounces.google.com designates 209.85.215.198 as permitted sender) smtp.mailfrom=3yc19agYKCLYoaWjfYckkcha.Ykihejqt-iigrWYg.knc@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786629578;
	b=2TpNMstqOxFioGRSZmtMglg1epozO8EUXLWs1JBs4m+8aMZHMaZnRlcz3cW4oj/57KEzdV
	FZJ3W8OR/0s91bSaqYhw5c7EivInG5rDMoiLTim88zm59SaQEoCfrN2M81f01A2SZX7LAf
	BawolPdu/PuiIlbjeAaZPkEThqd1Cyo=
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-c9fe4c5eb39so556668a12.1
        for <linux-mm@kvack.org>; Thu, 13 Aug 2026 06:59:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786629577; x=1787234377; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Yp2r6l/p49Xe2R6+sIrvq42A9Bi9ttiTK9kJ5Xxsr58=;
        b=LFjR4WzgAddh5IbMaPQP3+Nnj21Qyc8raxTvU9Z1Gb9VAPXD+JgNakjRtnztEbTLWP
         fX4FnAQm/9vbmpGTcgBX0wPqS8NNpzX44rlWPxIn8lIA4e5mMKcJPRj2IXlLNZx/0MLj
         x4rvfUGuiuHR36JOgsCH7ZrAOqrr3mtpVpOr+7Hfe0PP1uQR/+MVi3rW7a+qx8GIWjvA
         V65eBNKLoFyOcbozG0AR3z5k7+Fklqk/4wh3vXE4XWWOErApN70jNjg9SRl/AZK0PaMC
         PgIXU7ADxXH8jTiIoR7EeL1QsUTkYS0iYozO6OoKwElcfrW1TafnmYbPBs7i3A9nkGjE
         9Gfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786629577; x=1787234377;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Yp2r6l/p49Xe2R6+sIrvq42A9Bi9ttiTK9kJ5Xxsr58=;
        b=bJtDPDGafLOOGD7M85CW1L/SIEWV8/QrsV80s6T/19zPEa/NtDlQGUF2XMB3zBqLBN
         IV60PZg5xgS1iixeDajyTDP8BxjJYBmPznKVFCdt5zvXZ+L7Xk8gVYw2+xpQxIVE/xOD
         mtlCq2SiLxGpItVkPkaTNATG04joU4TrwhjI464JlsFlB2kKwGzjwhK71CL0oO/Y1PHG
         PkgLrUIKTkRT67eJyIXRE0GC3ouVMI0wCKCzyTiDt5TcXyiTMHjIJ5yfqeyNRjdc7Lxn
         e+PxevwILfaJC2HTORXPSRHDX9gGSJBAW+vmDVm+ZkRa+37+I8shXqsEfWd5/syYuffS
         55og==
X-Forwarded-Encrypted: i=1; AHgh+Ro18DBxjK9BUSvp6qUNkx808zkHEDmAJqb91cX0/4fUHZkNKYbFdEFa906KYjB95xWpPCLM/SqE3g==@kvack.org
X-Gm-Message-State: AOJu0YxkGNHGRC+KLjWKVw9oQBz+6ONLPQ13SkVww/AOYrgpfNydgFXg
	IPq97uv29M4l160XCYZX56o0AItig1S/9aFnz+VhI7FB2P35NUgpNA07SiY4CesJMayUrApAl32
	ecBspqQ==
X-Received: from pgl8.prod.google.com ([2002:a63:b08:0:b0:c86:61a1:3390])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:6017:b0:3c9:1c1f:f516
 with SMTP id adf61e73a8af0-3cc552c3825mr7736253637.19.1786629577230; Thu, 13
 Aug 2026 06:59:37 -0700 (PDT)
Date: Thu, 13 Aug 2026 06:59:36 -0700
In-Reply-To: <8ba4860fec45afeaa305bcb011d732ef0da302d6.camel@infradead.org>
Mime-Version: 1.0
References: <37b83b429b9f14ea6ad4ca1c13cc8e565ec09033.camel@infradead.org>
 <anwraNIKJV8zwrNT@tiehlicka> <44c51ace9b0dc44b795f6f48c91cda440eed910b.camel@infradead.org>
 <20260812122759.GA662699@ziepe.ca> <c41c52f02f033ea980d4b5f9b8239d5e9411a03c.camel@infradead.org>
 <20260812134934.GC662699@ziepe.ca> <a48e6e7063122b22a8083bb0792984a204f316e6.camel@infradead.org>
 <20260812142659.GD662699@ziepe.ca> <9e65be44430e7d013fedf9a1626caba020ad6d94.camel@infradead.org>
 <8ba4860fec45afeaa305bcb011d732ef0da302d6.camel@infradead.org>
Message-ID: <an3NyIYrdN3li0ag@google.com>
Subject: Re: [PATCH] mm/mmu_notifier: Remove non_block_start/end() from
 notifier invocation
From: Sean Christopherson <seanjc@google.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Michal Hocko <mhocko@suse.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, 
	Simona Vetter <simona.vetter@ffwll.ch>, 
	"=?utf-8?B?SsOpcsO0bWU=?= Glisse" <jglisse@redhat.com>, 
	"Christian =?utf-8?B?S8O2bmln?=" <christian.koenig@amd.com>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-mm@kvack.org, kvm@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A53414000C
X-Stat-Signature: jzdzi9i43kmpmdthxjftqw4jqck34u57
X-Rspam-User: 
X-HE-Tag: 1786629578-228474
X-HE-Meta: U2FsdGVkX1+azbnuDrBqos0OOIbOkRTV6i0AXuDO8XREwTV7RLpSjW7Zf4OjGMgnvLMLFjbm+0EuwIS/3hijduci4ay352RXBzZV93/4vROA+fpqYZVyJwOtA6Es4NwPO8qfmh66ZumiUbeAvF22xOgoSnDdtDn4Yu5/uheWYdhwVURCDpmXSCo5DdoX+9fig7jJYBRKqL9hkfY5oLCdt0cv+WwVRrzrhqIkeQoLom+I3mVzdgwbGZ7mNqRnRq6pqEstC+DVRdwNe3VmuRIaybwbfndbzT7AuA+Xzisl/Zevuq8IF8TgiWSQPhMDiF/v6co1UaYYT2tAtErn7JifuA4Kj6eM4kuPmgXPIN9k0Xa57qwPVHurrp13G09VY+T+8Rtx/RoxZy4UBz+chz0UGtWbwu82PO21Fd6EyNwukI3yoT+8chLxa5PDN7LejXC8ua7MP7oSSR93lhHvvwWnERULpVAJcfaJCtjsnMbGiE5ZzhiEtFKP3HCuiIYZCnog1ABY4jvsKXcI/FQ4eRWP1EXwyvep/j7BTD+OACguqZYgjKCYGxtwb/Bp7PLNufZH4AaF5aUlDTG7r/SZ+ABl7miILeNaL5sX1R+BcPCLeJ7X/uFpQIiDphBLYTXYxj2krIHe0WkLx9thpTOVDAc772dSix7UW8OsKUNhenXztQ2+wNDD0QJwtWb5esIy1HM4fqp8lETTrHB1LeKKRiDcyBG504sGR5h3PrvMs3IUNHfWlyUW5JBLisgFNy+/W46pA7yTgQ8tNLy5flHsUp6iuyDBi9ec4r1irIPRqcFDVLWcBYi5Jtd36j96JAX2ZCfDJPSXrM+rfM7RwiEmwffPwo7wPmCpBMG/fMA+VCZBsIdR0tgvXVgrbX42cyLGgb3QvLc60/Rtj4UrRYW5DE91kYWZh+3Rh3jc5zzehd9igLrpJU6aL2UpaG2HF0/AxWc1DtcH6NsAFoZ8/P/9xId
 02Gh3I5/
 Yf9Dm/uFZnlcU7Gt7ljsc4byVPdnpUeXokRnVyhK3jguimVnQsNo8diL2c+sFdi85k8jU2zNoWhFh9NXxkG1LZf0l+qQV4I+9/6sf0iD0sxmGZJ9XlugW8+bM8NvJwnsHSKXY+jUOrwN5xuR2ZTJrnI3fBvhr2ILtZwpXrZcMhH+GGqFhk6+lSuFYQh90ZKAIy0382YfC8S6yszTykpLNfYJmlRi4vFe+fdbj2ua60C725gg4HmXm4FRpuFB1gB1fUcmzzjbXRGF5bVTbeW8fU9h8KVT0wV08oC4oKwaeoAeq/lvDOh3YXIFkDoedQ9yHuFBLiKC/aUVsMHdbZNs2e/vKgU5p+bKRm7x2HNA1EzYcd58axE3u/U5icVwOqTIbCJCMCQX9Y7p/uVByflflOaQ5dEnkU/HbhFqqEVki1lAgREj8xFBRIzaOA74QvjtVbDgjd4+4yT3GlsjwsLdJTDe6vQgzRkQG59+hSMzNn8oSnv7syG7oyt1b7Ne56CzL4PZG413kTg+IBaggqgzrcEJ0a5DarNkVpv+zL3U8h4FffG+b1nnsCEucHdO2aX2AdtuudCPUbI3zqzvwycBZc+ZyWFhnpx9T+2lDRS5CNFVt1Mfj2qEhCrKFImPzEhE/rDLLFj017HNLv0ZGDWXlRayOOb21FDcTDOiq+yYS5el9BEixJm0g+2hqbU/SA599ZfqRHJL7IHApXCRdK4olW4fxcPkhWiO9An8XA6TLS8SaelU9zO1v5RTsmlgSLpVgKIQC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 13, 2026, David Woodhouse wrote:
> On Wed, 2026-08-12 at 15:38 +0100, David Woodhouse wrote:
> > On Wed, 2026-08-12 at 11:26 -0300, Jason Gunthorpe wrote:
> > > On Wed, Aug 12, 2026 at 03:05:43PM +0100, David Woodhouse wrote:
> > > > the non_block_{start,end} guards around the MMU notifiers, which ar=
e
> > > > basically never being called anyway and don't actually seem to prot=
ect
> > > > against any real bugs.
> > >=20
> > > If you think this blocked stuff is dead code then lets remove it, but
> > > I'm pretty sure it is called and I remember seeing bug reports about
> > > it being triggered in the wild. Vetter certainly added it because
> > > their tests were actually triggering and they had bugs in their DRM
> > > stack directly connected to this.
> > >=20
> > > It might not trigger for your hypervisor case but we aren't here just
> > > to make only kvm work now are we?
> >=20
> > I'm sure there can be real-world use cases where it can trigger, but
> > when I was *trying* to exercise the code path, to validate my belief
> > (from source inspection) that even the plain spinlock would trigger the
> > splat, I ended up having to hack the kernel to do so:
> >=20
> > https://lore.kernel.org/all/787aa26cf62dfd361eea8ed19f384fc517892501.ca=
mel@infradead.org/
> >=20
> > Perhaps in the past it was easier to trigger 'naturally'?
>=20
> I did a bit more digging. On the one hand, I was wrong to claim that it
> never triggers =E2=80=94 there *are* a handful of reports; of my searches=
 this
> was probably the most fruitful:
> https://lore.kernel.org/all/?q=3D%22non_block%3A+1%22
>=20
> On the other hand, they are basically *all* false positives from the
> point of view of what the check was actually trying to do. And in KVM.

FWIW, all of the KVM false positives are due to PREEMPT_RT turning mmu_lock=
 into
a sleepable lock on x86.  So killing off the restriction for PREEMPT_RT wou=
ld
"fix" the KVM issues.

> It's causing more issues than it fixes. Including some bizarre MM
> gymnastics: https://lore.kernel.org/all/amMZFqs1smKmMuj5@lucifer/
>=20
> At this point I don't think I even *care* whether we manage to do the
> atomic SRCU thing; I think this check should die *anyway*.

