Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D217FCD4F24
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 15:46:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 159AD6B00A2; Tue, 12 May 2026 11:46:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 130256B00A3; Tue, 12 May 2026 11:46:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06DEA6B00A5; Tue, 12 May 2026 11:46:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E94606B00A2
	for <linux-mm@kvack.org>; Tue, 12 May 2026 11:46:22 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7B5984057D
	for <linux-mm@kvack.org>; Tue, 12 May 2026 15:46:22 +0000 (UTC)
X-FDA: 84759194604.16.D813CF2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id D3B5240012
	for <linux-mm@kvack.org>; Tue, 12 May 2026 15:46:20 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="I/TpK4bl";
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778600780;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VQU7hTeSiUfC7ghMXm3FBPK2HAHhXmEgC9FUPGQNEhY=;
	b=AuNuy5Yn7AmwLiIUWFf97eoPKoHHYqdE+8rphFhY4GZYQsrpu782ONZeuoLLuE5WMu7IMn
	f/YHkAjLcvhACeBPhSyLTQqTNTVIhztp2804lLtxwZnvS8ZLZIVZpYiqOT9oA7gIa9Aq7O
	uDHSR9clYxtqneOMtzUnvQaQOjaVGzg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="I/TpK4bl";
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778600780; a=rsa-sha256;
	cv=none;
	b=Bj5RXQSCO508sXPCFAIbn+NC5iSJw4OK12V9fu7r1effbve9hKBHoJYQ7BD8TG/rWU+WAl
	BCfrqyFuBZPMTJJ6pRnlJT/m5aphHVfaLloyLb3SYp1eTZe/rfuf9WfGr2394x9gWc5+Ak
	OuIMGiihlHQCQiZ8w9VmiLpFRln94KI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 265EF62C09;
	Tue, 12 May 2026 15:46:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53D7BC2BCB0;
	Tue, 12 May 2026 15:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778600779;
	bh=W32sOgDSkfkFndIpYZ/iTaOl8RCJh+fj5EEJpUKDOnU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=I/TpK4bl98aV/sTC1haCa4Cuuak2SE+h1ZI1AB4DfIJfpaF8O8dA2+dHUGYJ9HC+R
	 S2sendxfqPps6CZQDi12lE3ER1ez+BSXCqZWvDJjKM4P2e3dQbDYF8BU1bj1LGON6O
	 99JffUSLFzaYX4pZV5Sl60+GbL2D1+TFKWcYu/2nAx01TN58NA7mVrXcXby4n3NNwR
	 iPJN64ZmkW8Jae5bYGXdouEfnhIYJWxZ8KQRXK+A0afpQ0QAILJ1WYY+qzlVy4wEaj
	 N4644hTWHCqS/F2bLPu6CvDW8c5A0YSznOaRGm0dhKKENzI2njlBQ2KitJyQDUrsD4
	 CVd5dBamh0fLg==
Date: Tue, 12 May 2026 16:46:14 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Minu Jin <s9430939@naver.com>
Cc: akpm@linux-foundation.org, david@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: fix misleading comment for remap_pfn_range()
Message-ID: <agNK2O6G2DHtczS6@lucifer>
References: <20260512143543.258399-1-s9430939@naver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260512143543.258399-1-s9430939@naver.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: D3B5240012
X-Rspamd-Server: rspam06
X-Stat-Signature: qtfsjrh6pn37szpe7u7s5woyqdap1c6r
X-HE-Tag: 1778600780-883222
X-HE-Meta: U2FsdGVkX1/RY8QQJKV2gsu0uC32AZsRcAZCIF/ZKRt+vQYYyMdq+JJaqDlqY9cFZbeZNsRokDPbQ1yFem8fMGwolpxob62/YfbUzLjVTSuk/cCpmz5kf2HaGkI7yvlj324858vl1mWf/IrDj16D0FSfU1QqdUrJ6qWOTeGEPIQH+WIpK9xzwB9lRT/jDZIwqWAUYgRnrCVqz+T7I5wH3MDG9Twtvuqodz3CCTn/RuBqP0pOWwh1I5RT4b7LxAP7zCSrvr/5DfRxdpzHaYB2zLGnD8uPPlS+ld0Xe15QE5d1AuZZZc8b96HMYMcopQ10PCYQn/ISPKD7IkUtoF8DnQQPgQWJydLlAze3S4k48eaeAVQh4heB1fbH1LOek/3CFclazvGkhg1C4G4Ofi3VdDZhscYNRABSKJSZmdMmogZRMIEtGmqu4C//EqTfe8/y80c2kzHvXudPjudLBgD1axzvlwaYZkIXemZDESF+jPHVJ+dKgFh72bMn5geikIb3hnCzkzTcMI+gUhPpySc1L6xIFhshH7aCK/hnJHx6Bje6S2y9NYkAe8Ye9zOremYvPUw/TMmV3aIWOyToQvPBPZDz9n2MaqdfVmkYgyHFT8ALK6GF7ZYW5OHmF4gxLBTF6cQ5PGML2KUk4qRhHzlxGlObxiMmS0KcuYRZOSzn2AuLU4hXyFreg14iqgYhdxuaN1HKMc9W/cT5UAq4KM9afdeikLmlmDMJpbX7pynldlS29QClF5ztcHIjqv7K+Y4YwHjAqxQyjpvJ+9ejlWcrCOmG6Qj98vXLbosAp0VRKvAmF9DrMi4l0RGhDtkcEK/7VSadgIYW+X0nMNyMBBoS80oaPAIozBslxT+7cnyAdYkVaD1Lcm0fB71rRreYH0UypPCcsciaoTsIJnqudm0Fvw4lQ9hl+8Xl1XTVDtCfU1XtoWNL3pL2W+2kwAUINX7taWvvi39oyeRaGQ1TzCB
 YH6y0vgW
 5Y0MfgLsR0Xi3CaTathtp3jEJDHCmGrMfk6LnLfL7xL0Kq2r4CnicIhiszBU6zviwytjwGCDHCOH5Aa9TjGxgrqiEZnYLcUaI3VEZmA5mYNtvLPy/iLrShJoKzYUA70//huQ54td5SKg1tTMNGVFAbBp/RAVLuOMARUC9zANuC5OOI2ex/aK8eaEAvjwG//lmMvQSl2qXETxXrc4x8wvrneaNwPpYfpXt7omq8S2an1w6QRV1hZ7by7+2S8eGzcXZkXAiKAgP4DKF6H1t2KUuCU+f6MKctPkYYPghGkSkrozgRhfbGAwTiCK1/vGPbhjZ85lP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 11:35:43PM +0900, Minu Jin wrote:
> The function summary describes this as remapping "kernel memory",
> but remap_pfn_range() operates on arbitrary PFNs, including
> device MMIO regions that are not kernel memory at all.
>
> Replace with "physical address range".
> It describes accurately what the function maps.
>
> Signed-off-by: Minu Jin <s9430939@naver.com>

Hm, arguably those are 'kernel' memory in some sense. And 'physical address
range' is a little confusing vs. PFN's as PFN's != physical addresses.

Also remap_pfn_range() is, in effect, a deprecated function as we move drivers
to using mmap_prepare equivalents (implemented in remap_pfn_range_prepare()) so
I'm not sure it's really worth updating?

> ---
>  mm/memory.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/memory.c b/mm/memory.c
> index ea6568571131..4e07e03a76a4 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -3172,7 +3172,7 @@ static int remap_pfn_range_prepare_vma(struct vm_area_struct *vma,
>  }
>
>  /**
> - * remap_pfn_range - remap kernel memory to userspace
> + * remap_pfn_range - remap physical address range to user space
>   * @vma: user vma to map to
>   * @addr: target page aligned user address to start at
>   * @pfn: page frame number of kernel physical memory address
> --
> 2.43.0
>

Cheers, Lorenzo

