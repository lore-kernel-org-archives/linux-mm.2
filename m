Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D807CD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 09:17:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDEFA6B009E; Fri, 26 Jun 2026 05:17:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D905F6B00CB; Fri, 26 Jun 2026 05:17:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C319F6B00CC; Fri, 26 Jun 2026 05:17:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A14726B009E
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 05:17:45 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2DCE01C6224
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 09:17:45 +0000 (UTC)
X-FDA: 84921511290.02.11534F4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 90E17A0003
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 09:17:43 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MiWkV2sF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782465463;
	b=MjMvORrI/XnUjZ1rrV88Oh7mCG8YO7MXmF/C0TyDwt5oPSztpEPK4UP66ZY82m6mKdrUfg
	pCU0gqJlpkJbphTUUHnH1yj/FMogZgcgy8aR2j7POzaIwtL3O3o5KUjjEiT/3iuBUa1Ppu
	UdJ6LFBkq8wTpfEtO8UIZfvrN02o17k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782465463;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C8DBmie+up+NarWH2+WBlhhAJ5fRPgc96B/h7YBw/pU=;
	b=N4+32YRVFOduQ6QcMsO0ZGWjWf4R30mcJc1EezrwW2nVO+xnLMAcTo0sL2TCIrYFhVlIyh
	6CfYlpVXOqeF75yd15pS8RZbQ1gMckp1KjwzOhfkpEWNA+12aecqSLWwNuNPMIxDI91q0L
	0iVaZkFqnNxywUQx/RC7HZ4rFlBhf40=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MiWkV2sF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0761760098;
	Fri, 26 Jun 2026 09:17:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 304AC1F000E9;
	Fri, 26 Jun 2026 09:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782465462;
	bh=C8DBmie+up+NarWH2+WBlhhAJ5fRPgc96B/h7YBw/pU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MiWkV2sF9J8NEiwlkaGQQX2NqEUwdX1+BoAi08RxGVDLVidjDUkzK4au2Sky0PMZ8
	 Va0MY6680ph/Th+nTKDoXCMKrLgEQD05FPF21PCNQKyjl4/QOuCTNxWu44cQ3Cz6Cz
	 cS+snYlkcv64dbdrmKOMoUlbiQ5AeFx53hDw0gQxuIjkxVqY2nZvHWEXjKr1hhAlGG
	 8M5CAFdzqbvMVE3wi1z3/G9KbtrcOElXdGgCjBGfCsszAvIPMEXUn/czRn3pSi1Cv0
	 mnfFepg06CAzYsE8OGAXpZAq7Wsk4zwlJc6kParbF+og3Wp53cB+x8B3QnG8I2RQum
	 w477IzmlRnGGQ==
Date: Fri, 26 Jun 2026 12:17:35 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, kent.overstreet@linux.dev, david@kernel.org,
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
	hao.ge@linux.dev, jackmanb@google.com, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 2/2] mm: move alloc tag to mm
Message-ID: <aj5Dr99W4we3BSLS@kernel.org>
References: <20260625184857.2193482-1-surenb@google.com>
 <20260625184857.2193482-3-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260625184857.2193482-3-surenb@google.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 90E17A0003
X-Rspam-User: 
X-Stat-Signature: rnbnw934n8e6tkzin9u6eeqsfmye9en5
X-HE-Tag: 1782465463-993092
X-HE-Meta: U2FsdGVkX1/UYcabX+OiDs35TmeKIwWi2UPldRecM5LCtalaZVqynWosRRM8rAPx+X0c3yMyEWpn0ngMbhsZhlJlPAFGNyMhvwibx6O39t3f6gpRgamOuWhVdH3pIJe2bqiXZxv5LTWKSRtSb+1MEmjg4CSMaprZR6hKajHsTE4EqP1q4Iju4MYOItZuIHU4b4HMi+pNWwnQOQLr3FPFUw/EIRigf540e5qymZtDIUQkenHD+RGL1EpCDwApJPgcCEr4rITGcb+KBrf7qnpMAo3tKySOWWidfvjnGVu+UcP8XKfH+m2PxEkphFRtujvJzJ50olyQZa4CNUY74gAPtFbke2HsWpZMNMtKiepOjAkWQEtmZhuzjRj+jZpYHc8C4YA8Sf+C1fW3AIcVKoDdTlFr4dCeDkKLVjF1+4+lBuhnTgWbtEeM2dpLYXTq4K40xcjeKITAN5+/jDj2e7T7PDoqr8xnLoaLm4+sUO1Wn1nia6KHWVOJHxViCgarliZs3bvDTjRn17F0M82f3Velk5TE+XzRl7M6QiDaxoKBzSvlGeRmvSPMLQPp/1amIGw2FaBi7h8f9/sYPebml1z0TNivAMZfqgznDq9v3tPmwrW2rlzy3lmxZX0YuiYKu7EH4ZGpweJn++BSco2sPrNaOAc3aOMkfRTHxymwE4oQx6AiFxhVXb3yVrQTzWP6rLtu1JzcmZr78obRc1Cc8RfQZ1hiUG4P9Op4O4xNIHgih0lVyKdSy2NwAgVKuMmhinJA+MsK75O9u3N6zErpHwd+FkldaPjQepUvzaK6s/NmxYSKH6Uwo2LBpho2v6cdnIIzzFVOOfL44CVBelu/Q3PVmtvsuSogu836A3GuySIbXHWGNaXBYy42rSYmyriVhvmVLJYSbhD//Mtvpwo6pHpI8RDfk8aI5lU8/fPanfHlI/l2NQrsbACt8uR3P3h2j+maOPNx+XGXudMEJqdMbMi
 K/QNZp4b
 GZ0EwjfsSJooWlkqhbY4W+YFvdLpGyhyvsdsJLC0jnWm2ucOIyt+1hpp0TpUVg9pBeKyRooHntAv5EwUVFNsrPKLfRDv2bnBCkrFxb5pkLCDOGDRU+J49fhjVr4GEdDLQVl7GsyRaDzl3yz6zL/WuF/0Ca53fOqlyKTsl5kWdj1XShgk/3edn5PJvBGcijr0jJ/xXjXA+fDkqM+7lk8gpjT1b9rvpSmspFODXgSwIkAfFNtmewErtD9c6dCDTEfh0/PcUrc7S+rRGAfZBy+NErZPfCnoOcLC1J7XMKDr+RGozPgQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 25, 2026 at 11:48:57AM -0700, Suren Baghdasaryan wrote:
> From: Lorenzo Stoakes <ljs@kernel.org>
> 
> The alloc tagging work is really mm-specific, so move alloc_tag.c to mm/
> and additionally update the MAINTAINERS entry to place it within memory
> management and port over the Kconfig and Makefile code to mm.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  MAINTAINERS             | 20 ++++++++++----------
>  lib/Kconfig.debug       | 28 ----------------------------
>  lib/Makefile            |  1 -
>  mm/Kconfig.debug        | 28 ++++++++++++++++++++++++++++
>  mm/Makefile             |  1 +
>  {lib => mm}/alloc_tag.c |  0
>  6 files changed, 39 insertions(+), 39 deletions(-)
>  rename {lib => mm}/alloc_tag.c (100%)

-- 
Sincerely yours,
Mike.

