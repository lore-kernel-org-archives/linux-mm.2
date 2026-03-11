Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EF54103E2E6
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 21:19:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9C9B6B0092; Wed, 11 Mar 2026 17:19:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E43C16B0095; Wed, 11 Mar 2026 17:19:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA42B6B0096; Wed, 11 Mar 2026 17:19:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C759D6B0092
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 17:19:32 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7D6591A042F
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 21:19:32 +0000 (UTC)
X-FDA: 84535048584.26.DBA3677
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id BA6B01C0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 21:19:30 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=IGPtexWy;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773263970;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IAmbtID+620820LXcQy4ka2soJ4U+nuKAqtku7J0NO4=;
	b=7MADaK08vZJlQeL0gBi+DTGU0+NW+oL8NKB7/xmr3dvs2PXoY9XVnB4rgy2s65G409KHEv
	TungE06APXzRJGhUpT5Kavp+4CoPoHkLsQzfSkIg+VChxHo5973vBXo5oqIQL+M7pWcMdH
	4ICcjxxi6p3izIOWVPxwmHvJPuodNV0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=IGPtexWy;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773263970; a=rsa-sha256;
	cv=none;
	b=CMion1cf5F0tCMe/sVQn7ySKZgoEls0N6g/QD17oeYNjKPX8rUETGCM/UIaNu/FUrnvTQ+
	Sf7qviE3HW9Gi4x8pqMNLmrRNCzGm6KWKMfEipRfDiHEfmap8elsB/IhuFPwzwa9TvDvJf
	hOhFDsZmInbaAj6ZuyRVu1AlTfvShe4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B2C4643D59;
	Wed, 11 Mar 2026 21:19:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAB64C19425;
	Wed, 11 Mar 2026 21:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773263969;
	bh=IAmbtID+620820LXcQy4ka2soJ4U+nuKAqtku7J0NO4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=IGPtexWyH1Y2qVEVSjpKmNAYYvioVGoDGq6ak5/IOBSmODrhYEMDcacHe7pJu3NWa
	 Jqq9s4165S09SOXGFeLOpIap21R/bTsTvkmt4nx6yhZC74l/PCNJn9ZPjP9dD5oXAj
	 FMnWYMuLT1gKAmpsm0LHQbm8h+h0Vljn1NMw0EWk=
Date: Wed, 11 Mar 2026 14:19:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Haifeng Xu <haifeng.xu@shopee.com>
Cc: david@fromorbit.com, roman.gushchin@linux.dev, hannes@cmpxchg.org,
 mhocko@kernel.org, shakeel.butt@linux.dev, zhengqi.arch@bytedance.com,
 muchun.song@linux.dev, usama.arif@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 3/4] mm: shrinker: optimize the allocation of
 shrinker_info when setting cgroup_memory_nokmem
Message-Id: <20260311141928.b4291eae43f99a2f6912cd2d@linux-foundation.org>
In-Reply-To: <20260311030235.240953-4-haifeng.xu@shopee.com>
References: <20260311030235.240953-1-haifeng.xu@shopee.com>
	<20260311030235.240953-4-haifeng.xu@shopee.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BA6B01C0005
X-Stat-Signature: ex4ydrpj7gk1a6wuazogafxnii3nkgoy
X-Rspam-User: 
X-HE-Tag: 1773263970-574667
X-HE-Meta: U2FsdGVkX19UiKX+xIK6VMdNHusxDflw0wB7A11Mj7Y0ufTZBu3C1XAl9kZ7H7lvjFG7UqD6Mrm8qmzb2JFYvoKaWkAC2ac2gRcxIuc0TzGeBKiDke9jmrwJzb5SVh2LFzomRqWTvRVLok0oAh0F4UmCociEIwgpwGLBnv33oYp6sQWoVkF/78B7p0n/yHbblhlis2xISQGgJJUmpyRfCQ5nt/FZwR4imAbaGNZAzV2EGUs3E12cygFFtaCgaM1J9GMX6Tg9A4nMZCadH0Ygw5h896OyO6Jyje9uWtx6QTf7HaeXEm18K3GwkXtMF7uvXoKdvUhlbcGd+Pab2kP6TeCLc17T3u3HSshcsIdrMe6q6km+7ayp0raIDe7lLMEYaOWZW93L2ysetu6G/Au/5dfWn7ZTayChkpIaF3aZjImz+mvlFUXch6IFPsmx8opZiAL22qU103gHWNBSl3jFJQwOFqTsvoMR4aVbKsvBVYY6a/h7sZXn8ucW1b9ItLuutX9LQnSmKZwpxJldi9OqYhcj0CM9ViZglwa09TiRvOqJLGZ9/NxfFlEUSb9s1PAWHTTDt4Jp+Ps9ZsIywteRSwuPbXDHhjt9YYJwFKNLTHoe62eSnJNW6RwnrB8fmxO8xh3WwhhiCsV7F+KZGb/XsLlgW42w0NL//o7OTnhgMmcUt/g90tAulVtpBXxT+Ly3XWDUwlMj4NQcQPphZImkhV2Ll+54gDEn6wRBdH31LVxzBsjaEUR3D30TiacPksiWBwKv+wnNvMFOE+iMsS5HxhYZKrmMGgOrGNz1aDKXIDEDv70AuVeuo9h3aZ6zW6DKPtz1E5bMW6mu3vxGswnPc4sAphJB7fmturTcbxFViy25eu99b74zkgR1Cr4YZZkCg/xJF0rX/VEpxqOJb1kFrbbjmPwGpbCgpDne3/haToNbfiEy52AN1S+ewEN+fc8WL7Dc70owB6Tdfgg42r3
 z33OckJA
 rXKOPjVN5gsidFvVEP1HzBjradiWXIvbP0u12ImBhAMLikJZqW4UboojPbiP5keO5EuenhqiE0qW1NmeF/qkTX6EahBEAl6wcDHyy4hMrF4Zc3xbL5t6fGjQHXaWZK4/3UqsCga0oTQ7RwMtEJzOdjulQYeXGss18W/UlCGR+f1OheN6bbnb7h+8dT/PoWypaxeIiVLIcqOZ6rC9aGN2Cr5EHRn8KnbpOn2isHoxmsw71KONjkofq60Gkron8XOssrVF8xc+TLGGdfptI6EFt4vutfAUsVtjNJmR1bHagmBwRtgOJ+6hta+PD/JkfBLPSUak57tKsU1XbfSyqpy8IZQAfwbZwKRcahFgsAG/xf5lnm2Celk1KAl7Yqy1hrKDtJSlu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 11 Mar 2026 11:02:34 +0800 Haifeng Xu <haifeng.xu@shopee.com> wrote:

> When kmem is disabled, memcg slab shrink only call non-slab shrinkers,
> so just allocates shrinker info for non-slab shrinkers to non-root memcgs.

What happens if memcg kmem is enabled later on?

