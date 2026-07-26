Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B120C531CC
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 10:17:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8AB56B007B; Sun, 26 Jul 2026 06:17:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3C0C6B0088; Sun, 26 Jul 2026 06:17:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2D0B6B008A; Sun, 26 Jul 2026 06:17:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B16E96B007B
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 06:17:05 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4377F1404AE
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 10:17:05 +0000 (UTC)
X-FDA: 85030524810.22.F1EA3F1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id B5C8F20006
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 10:17:03 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="dD/Bqvr0";
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785061023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fDOZqeNkjdo8vMXioiDYc0luD1S039f5+FXxpDb5Kvw=;
	b=T/gAcAg3M6p8GrANHr4PUzfAhSh6MHuiiXRY+MO1M4BY+jXzLjTA+8mu+IRWWZzlMbOT5M
	fDR0uqRERtOcC7cLhwNrpMqqRnd8Rme1itdJKDZktiaUwCIcBhZQ1YtQaDfWNYcRqFdDo7
	Ov1PQCK0Q1oZk29Mie8N8DOOc2i+ehE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="dD/Bqvr0";
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785061023;
	b=H6UcXbzCmAQdSxmQZ2ft0sWDb3yKTrtUJejs2G+PfGsoEx8pix5KuEQTbtlc1Im0bdUVVc
	nmVBbXNQkArpjp7a2u3rjlx9UtrJSxyhLyWZD29om6iquRxeRBJbz6aiyCy7c19uCOPH5i
	V0FAEMQ4DuvlLiTwbg1kUUgGZpyy6vE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1807D60008;
	Sun, 26 Jul 2026 10:17:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A2021F000E9;
	Sun, 26 Jul 2026 10:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785061022;
	bh=fDOZqeNkjdo8vMXioiDYc0luD1S039f5+FXxpDb5Kvw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dD/Bqvr0rOFvGdTmwOnN0Ba4hfE/9xY+Vx68zJZG+goUce76b2AtfJplLuD4ANVTB
	 l53gHeJbKkexYtCpJ7KXg+EU/Y6Ugu3N2wqeofwkp/JWJbQXMo1/dwOvYjQXMo79yZ
	 CuvRYHaZ2DW24R7jpNNn0dicF3QlBpRkc9jgQoLQRXI/+M4Js2ZPVDRdtEygN1+LDo
	 eNBh5lU21E+LC5PCdYTicTNkDL5K+ARoo9DkLeWPVahC8ldzw0bzvkmuq2Y71XoB4C
	 vDKKcp572kgzzODVlqYz7gYPoXpvwkGPA8grfevTZ+reVV8DQYI4T8wOkuPzFC3uRT
	 glCZUmU4Kr8rw==
Date: Sun, 26 Jul 2026 13:16:54 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Alexander Graf <graf@amazon.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>, Jason Miu <jasonmiu@google.com>,
	Jork Loeser <jloeser@linux.microsoft.com>,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: Re: [PATCH v4 16/21] mm/mm_init: simplify deferred_free_pages()
 migratetype init
Message-ID: <amXelr2DcRRyZDY4@kernel.org>
References: <20260725172133.4018491-1-pratyush@kernel.org>
 <20260725172133.4018491-17-pratyush@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260725172133.4018491-17-pratyush@kernel.org>
X-Rspamd-Queue-Id: B5C8F20006
X-Rspam-User: 
X-Stat-Signature: danywktewhmu4stjgk7hf8ekpmes5i5m
X-Rspamd-Server: rspam04
X-HE-Tag: 1785061023-995879
X-HE-Meta: U2FsdGVkX18LA5DfknBpItsobNHoB0X1y2gUcRwHuNFZ2bv+tWXF9826nB2RRUKhbDRBgMZhDlZZCfB1zlQZ/DE/Ln7c6HBB1uSs8kT/K4PX9Pv8EehHCSSfRrn1vyXCmKggoXWRHVr/k3MmyC6nLJFpacP0tZo2rfTxB+N4nWJNcs0h5/WhUYJwuizRlEp676MItZF28AED0VoyTwpujxCnj52Ur2WY2a+BlIumq6xP1a6v+CpLLIHQm9g3OmaKStZExL2QVCVWfdp0qiLx3f9oq3WupW99UDq5jp8YfXDA3R3jdxvq9Z0+ZqzHHIUuXE6zT5ElltKYbW6pm7uoPQsrkZVmW979i01SoHr+wtY24DbL5N7955X2M/F2/csQq+dsZthtXVAslMQdyASD6E004dNruuRhtcuQuYNSB28NQa+k13ilUcCbx7sWy7zRZzLE5eKcJ/zRXXzUP/qH28PJ4jjtd7nCTdbWynBntnzf/z+bsjqkGMYuNRetE03dxGDpiK5RHgY14kwfX9T2LxFyHJ0pjrtD9JAKOyktKdaLWLNVOOvKK6LOGrGGo3t9m5ICs3mDfULBpEMHCKrzsvg+M9pRRwbWe8DaK4L1T/P08Z9sPp4YMOCEOYiljBHHtMPvD/9Rp2PUAY1u8MGtzZma8vfAqdazVTjl+uz3M5tLPvI7UDln0pq2ziqT8/Gd0tYXxyGXicJ+1Inqr8px5kIR3et0DFAOFzsMepCSRSTMpAT6ePxKP6RmwKInHqXJhTWrVh1DrA6PSmX8NiQc/9rhd0p56yThDQ01L72Gj7aZT0Sm+Anu2N42d/rG6N/BARRuUgc/kmZhIm35IX68HDJAHjNVr9H7vXFjZwPEuN5afp7gVh6SPpTOm7ZLCRiMYlztXVu5B4uiyQv4ZxvcDXI3iVk+60rU/JOIlU6RNy1JLfFU8jaRV2Suk61SqkPOmpieB2MLLQ0FTI7J1i/
 cNJaGBgg
 JMIQy3QcX1S8JR852S0ASITstiwZLcJyq9LLIKZyyI6IdYGOL9zzD+rqZvQ3MejbzBQ/xcqadCc2ZdfBgCygvxnodrZDAZL4XRrKKip9Gtcr29C6VavGCCvJr0UPArtLPFgSRlffyPFhWFxp46rXYwaRAtOzxE+Z89J+PuGMl4+PVOj9KZSNZ3NeFx6Ke+0rI/RHk2HTDEIAFWWv05h4EyklFV2KZZfispHlp8b7WsYZ7j4gDt5VJ0InIqf9DgUDfjOyPAcGWSVOzREas310XE639VOsFnHxibRUSEolJdHATirHffU9U92zdcM4xP7rk34deR8h71HApgxFeQar6l0gqUwojWiMHyCDo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jul 25, 2026 at 07:21:16PM +0200, Pratyush Yadav wrote:
> From: Muchun Song <songmuchun@bytedance.com>
> 
> deferred_free_pages() open-codes two loops to initialize the pageblock
> migratetype for a range of pages.
> 
> Replace them with pageblock_migratetype_init_range() to remove the
> duplication and make the code clearer (Note that deferred_free_pages() may
> be called from atomic context).
> 
> Link: https://lore.kernel.org/20260612035903.2468601-6-songmuchun@bytedance.com
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Acked-by: Oscar Salvador <osalvador@suse.de>
> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
> ---
> 
> Notes:
>     This patch is taken from Muchun's series [0]. The patch as of today is
>     in mm-unstable.

@Andrew,

It looks like it'll take some time for this patch to get into mm-stable so
we can't base this work on a branch in the mm tree :(

I'd like to expose the KHO scratch extension to linux-next ASAP so I'm
inclined to take this patch as a part of this series and live for a while
with a duplicated commit in linux-next. Once this patch would be in
mm-stable we can rebase kho-scratch work on top of mm-stable and hopefully
there will be enough time for it to live in linux-next so that Linus won't
get angry at us :) 

How does that sound to you?
     
>     [0] https://lore.kernel.org/linux-mm/20260612035903.2468601-6-songmuchun@bytedance.com/
> 
>  mm/mm_init.c | 19 ++++++++-----------
>  1 file changed, 8 insertions(+), 11 deletions(-)

-- 
Sincerely yours,
Mike.

