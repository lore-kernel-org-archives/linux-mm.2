Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B718C5516F
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 18:18:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 721676B0096; Thu, 30 Jul 2026 14:18:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D2A76B0098; Thu, 30 Jul 2026 14:18:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C1026B0099; Thu, 30 Jul 2026 14:18:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 293D96B0096
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 14:18:50 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B64ECA0234
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 18:18:49 +0000 (UTC)
X-FDA: 85046253978.26.DE048CC
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	by imf24.hostedemail.com (Postfix) with ESMTP id C47B2180004
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 18:18:47 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TOvLJu4V;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf24.hostedemail.com: domain of ackerleytng@google.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=ackerleytng@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785435527;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BcSk1/y4fhEYP1oDWtEyRtQmE44YyXI71BVE0scYBk4=;
	b=cNofVAWVEjxaliaDr0Nmsum/sv24lNwWVMFponX5oswv5WYYZ37hiU9bLTPWR9Ntl8FrlQ
	+auOE8xYbR8YsXHUF1TTl/WuLxyP9ek8c442Cyo25P51AuAb8VxlWFYKxttII4QeQ+Ff1k
	7Qn5pf8O5HznOb6GcURcjXKhMal0YY8=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TOvLJu4V;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf24.hostedemail.com: domain of ackerleytng@google.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=ackerleytng@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785435527;
	b=3dFbTZH+6YPFlWwSEIYOaJm4e36nFxSsw6dcpMNgPJ7wKHAy1cNKKBZ/iEEqBTdKQWgfvZ
	gHcFw5kc4zSYe3JLwQDxJ9ZSgqbrlUn4d4cQgyJa+h/YhyZ75P976HSQtf6jC7fRY8xosv
	aDR9sSYSfpEnYXATP3kRU3Fi43V+5jA=
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-38d489b6b71so247829a91.0
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 11:18:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785435527; cv=none;
        d=google.com; s=arc-20260327;
        b=pWqfyS72SvsO6WwCw3VzXqrjr8N/1LnpiASvhY39kZoFqGL4+HOjlCoqRcYhd6BTBy
         4ULVJ1f9tZWyAB9QU8Kq4RVw6v+zXy33JYQ2ke/zVjiG+DuTZtVieWz5MC5rg+n3B/Ev
         andGeS+Bdw1pzlGFMnsgshS4oS1hydlvi6q/X/dx//KL+qT1Uskqte8SJS2EG8l5LQrF
         AbN3oLMgDP8j+3DXOmK4xl7qJL/a07c9DoMMUDKvJrdJetRLB0KpruxE+AvuEibtQo/p
         2ig5Vi9aXMKS08ujAfSuqZjSPEW4VE2jZixDzEpC7WkXdChVm/F0yvm25D2wV8RMj6Xe
         QQiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=BcSk1/y4fhEYP1oDWtEyRtQmE44YyXI71BVE0scYBk4=;
        fh=fSCn5+jXC6oxbE+sA3XOnRLstIxv4LfTXVDlDEyhHYs=;
        b=SGvmsweTjDadYKbZ+BybSpYdrBjd0LVGQsQy8aVsUhsRo0APbCYzuiednvhnRyEKjK
         HMrarEVYH0Pv+jUslSmRJGPGDNGuLCNFbpq9gV95uU9t+JY5GSfl54SMQakSkH8OOscn
         oS4uQ9avf6ITug9CkDirKWMGt29jfqpOKRRgmXY1SA2CRbALtVjKjSTCSXFMT3zoIbd+
         fWPhIwp5MSpXBs/cX6n8LgVUGu7N4X0vFCAX6zFmoFoenr3xy/Ftn60DqqUr1Eja2MP9
         qeKeYTw50zidPYs8cldt3h54y6x3ds/vCzvqDPeNAXjJpNJYPiT3Csi8/KfiypIjhCYq
         djVg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785435527; x=1786040327; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BcSk1/y4fhEYP1oDWtEyRtQmE44YyXI71BVE0scYBk4=;
        b=TOvLJu4VKP0NTpXk9PjheiqEs7iiEBuHDpIkQnaPfB+wtszYnWJ1dALvu8hftp5Nds
         76y+mqD8uAdVylOAKBD/WhRgezCz7X+jvH09PnzVuXkwlXTBQqi9T8Z9E+hsguEjKQM+
         1VxAWz36BAGWg/nnrmYw12+sGsbhf2D0H5uTm6+q6UgrGO8FXBNHR8s5+yCVBSFRDJ2y
         IN+FDIMOqlrshO6Nz7eEiRh2f2dPG3nYumSVrM4ClXn/R+vVS+bvYRp7R1N6lE2rYjeU
         9zhY22+j/kA2gWTkMRYwwGzy+5EfswWJY61ks/5fCU/K8mJTNYqkSHrWIMreociISuYc
         vPUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785435527; x=1786040327;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BcSk1/y4fhEYP1oDWtEyRtQmE44YyXI71BVE0scYBk4=;
        b=Z4i/Jy7jkHjnidW046ubpYk5c9IPShQJD83ZR2dSE9QolBNRVFaScGdOGH3GxLzYzK
         pFuCPhk6vSNm7nT4wxuZHNC6lS87RKOpWuu4YpLABLijpp7VfrClQvOG2tclWe+VegND
         gq6TXaB2hmPV41NZRMgju7uVy2FBEqKYnX+dxmxrkNs5Z7mf2dgaJIvO50Ug0Txe5dt0
         3WRi3ZzsmHxzyDTAQyOZS8MqH6NxYiQtA1YTcg8f+j4TKN6wZ0DVzSfpKKQvxqMZhWru
         9oIfuTUwNTF2yP/2WAL+n1RfYTBGRZchaecW312cCEPOGRSQ+ihOPWeUvbq8FbF7h4nu
         LpFg==
X-Forwarded-Encrypted: i=1; AHgh+RoaskEGQOWDNIkWXAY2mjTWnxoa1c89h/MzefUjT4fgLa3pF9nE42Tjl6hJ/cMq0SyZV+qFgVbiaA==@kvack.org
X-Gm-Message-State: AOJu0Yzs9ikFyseA7fWUkKg6OMWmTbOSw8BS10qCBYZc3imsmZTVgDM/
	qRIlp4zyNC9FpsboqxVT0/YNtO0OY7qwcziKphuBbzxS9lcc34yc6IESBY7TAONYIg4FZnFWAHX
	toJ4lJirTQ82R7aBj0spyJH2ARzqhpIHUSyKIjZEX
X-Gm-Gg: AR+sD13CXTbpEyw8NL/PzRfVGdXMlJk5AqVtyjzx67wHCLiRs6RN8v5YhK82pcjkmga
	XjInlM372tNeNdiNz5taRMi5U1157Ks2hQLMu/BSIAJn/9aCMtx63/ntw+5S9yIlE7vPf3B2kKp
	n4VA35q/hPW2A+z9VfPnkCKLFELl5ElA13KXnS15Ey6MRgUN4vgK891ML8wdmiVNp3hjnTRXmCH
	W0FUcxcamTxuUadarHS+iAv64ncr8v+7ZUI4tlQyI34CWDqoBZpd9vLi54AzBiXWmK0ZxsnU+K3
	pJKA3RvVpMFzbp5e0c1H99o/SnF0bR7E1Uo3SFRxQq5Wa9bdZ3lyIY4IUcC2T7K/B1BRIoswl8J
	acah+GSAsoNg4bNIPQuECcqFJL1UJLCovaA==
X-Received: by 2002:a17:90a:d007:b0:37c:6130:7a5b with SMTP id
 98e67ed59e1d1-38fa7dcb036mr912482a91.8.1785435525974; Thu, 30 Jul 2026
 11:18:45 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 30 Jul 2026 11:18:45 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 30 Jul 2026 11:18:44 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260728121138.1103610-12-tarunsahu@google.com>
References: <20260728121138.1103610-1-tarunsahu@google.com> <20260728121138.1103610-12-tarunsahu@google.com>
MIME-Version: 1.0
Date: Thu, 30 Jul 2026 11:18:44 -0700
X-Gm-Features: AUfX_mzurojFzFl7kQ4jInKyqzMda986c-EWBvJn_4YyREdNQpyHfl__fqR3AfU
Message-ID: <CAEvNRgEbS06snhyHznPSqxnUrdudVEKUuOpPwnU+AJATWFBRBA@mail.gmail.com>
Subject: Re: [PATCH v4 11/11] KVM: selftests: Add guest_memfd_preservation_test
To: Tarun Sahu <tarunsahu@google.com>, fuad.tabba@linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, seanjc@google.com, dmatlack@google.com, 
	Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, david@redhat.com, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, sagis@google.com, 
	Paolo Bonzini <pbonzini@redhat.com>, Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>
Cc: linux-kselftest@vger.kernel.org, andre.przywara@arm.com, 
	michael.roth@amd.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	will@kernel.org, vannapurve@google.com, maz@kernel.org, fvdl@google.com, 
	kvm@vger.kernel.org, oliver.upton@linux.dev, kvmarm@lists.linux.dev, 
	alexandru.elisei@arm.com, skhawaja@google.com, aneesh.kumar@kernel.org, 
	linux-doc@vger.kernel.org, David Hildenbrand <david@kernel.org>, yan.y.zhao@intel.com, 
	kexec@lists.infradead.org, suzuki.poulose@arm.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C47B2180004
X-Rspam-User: 
X-Stat-Signature: b9y8i6p8y6ed6c53ircca6yg7a9h3pq8
X-HE-Tag: 1785435527-912642
X-HE-Meta: U2FsdGVkX1/hmXLQMhUNMp7KhVNf4+0ZK6h/wTxOwR1rZKM7ERGibfmpwG68yChsfcy7Kz5LvYAA/7rxcsE3RWDUwLHkMcB8rMywmkZUroxFrRHpJ7RmBiuevv6RidSTUgu+xgoke6imXSoWJSiPd2dgDpUKaS+7w4g4Rdyt0sTweH8f6lmh1zy2UgOjp+jBjGAut7xV7wJ2IfCOhJOLiM4Pwbg/muFh/TSFCssVXNv3atvughJ+8RSJzfgo4K/g/Bd7+HZY5yTdWyKrXqq/geKYCWTNzxg7de8+Lc9c9DNX5QZkgVnldxZrBZPbV9vtvDcl5FR31YPlR0FqVw4GlmkJ4n2taoQZmiVBP+WuGZNAYQkXSgyRND/GDKfwpvv0R7p3brdm84lJfyBie3RU0X8vj2Xcb2hEQrMSpntITiCgsitPX5B064kxvAOoKgRzo8vTbzUXecXaQ0TVxurFMjR2f1FHL4TGNgUjAEs8JgaR70zPaJ+5DTp7TYjGZI/W4QMt7eo+goT/9RUKvFiv8xUsAZhDkVOhg1gBmGlnqJSiYf0LX6DaaAjc7Lotrvsxl/Q/1vnpLJeTFkFh9ART5ngcB8Wg5g03cTAWNxxvFQragEXSxy84tSvfY221kvyAzNFhWCGv+15I2nIsR+xF1Zbu/NAPfriRzdJ9rautPJ/SCqpFodW1UvXLgYuKfIBiBJXuH32w6xw4cPBGx2VtWHzhT7rMGiHNlwIi0XlOlPLgIxeaDtqzlVsdnt2mIeQUnhZuf1Q08RieSzKMLHMMxbWRvRSWsfDICrcr0vgN6qB1sniO5dcIT9SN7kvnRayto017AaP/4iMFbP/WQ/FKl8v0GTJGbXUYwaZpvC4kFK90tVnRpUABt0E6HvYoxRsfXFgvGQgY2RtbL91tvtw2rWCHgIpnlQxI4n/3sRWxKfxijnPcEeojbl3gJ2PS36dpUQvoPGBcCq8MiAcg8c/
 Y+Frnbmh
 zdEPm8AGa32iNP/NA/u1Zfk3wzkw3k+9OzJvyUUrh0hM+LI0uqjqY1bpSJcDXgXSfHgsk0X2PV+bBy/4B8zNVgakCcvu3iNJpTu76npvnDJO5a9w3D/BPb+F+DGOFHssw9Zqm0u4yN61zzZYvg14qDiMbWOyZouJI9aO9wMRIFqTJWYKC4PwA4pIq0xT095RXPCTNa2asToId+REbiL9wWJI1Jq6/ZLAdmztW+v2bYjsdZr89L/X8xY88/wDqDBZAoB3mXfT1y3JZGiYnccpBQqozqt9OyzSi6rlm5zsio6bqbjMvEGC9gOqinjAfKR983kVjZCaoxW+CeKa42c49QbCMR+D4MwFVR3QKvBVSfmDdygaTTO6x+wDI+2vrZb345hSOwkZTMdGkUeyViBaJj8syxg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Tarun Sahu <tarunsahu@google.com> writes:

> Add guest_memfd_preservation_test to verify that KVM VM state and guest
> memory backed by guest_memfd are preserved across a kexec reboot via Live
> Update Orchestrator (LUO).
>
> This test includes multiple tests
> - (A) Test to preserve non-guest_memfd, non-memfd which must fail (/dev/null)
> - (B) Test to preserve guest_memfd with no INIT_SHARED flag which must fail
> - (C) Test to allocate the guest_memfd memory after preservation because
>   preservation makes the guest_memfd frozen. Which must fail as well.
> - (D) Test to verify guest_memfd with INIT_SHARED flag preservation across
>   kexec: Below is the details of stages in this test.
>

I think we should split this into multiple patches, where each patch
introduces 1 test.

>
> [...snip...]
>
> +++ b/tools/testing/selftests/kvm/guest_memfd_preservation_test.c
> @@ -0,0 +1,357 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2026, Google LLC.
> + *
> + * Author: Tarun Sahu <tarunsahu@google.com>
> + *
> + * Test for VM and guest_memfd preservation across kexec (Live Update) via LUO.
> + *
> + * NOTE: This is a MANUAL test and is excluded from automated CI/testing
> + * frameworks because Stage 1 daemonizes into the background to pin resources
> + * and requires a human operator to manually trigger kexec before Stage 2
> + * is executed. Running Stage 1 automatically would leak the background daemon
> + * and cause CI runners to falsely interpret it as a passed test.
> + *

Usually there aren't many printfs in tests, but since this is a MANUAL
test, maybe that's ok?

Would like to know what Sean thinks of this, and printfs in general.

>
> [...snip...]
>

