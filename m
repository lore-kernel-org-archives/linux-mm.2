Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF48FCD4851
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 10:36:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 392566B0088; Thu, 14 May 2026 06:36:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 343476B008A; Thu, 14 May 2026 06:36:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 259196B008C; Thu, 14 May 2026 06:36:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 189676B0088
	for <linux-mm@kvack.org>; Thu, 14 May 2026 06:36:06 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9122B8D0EF
	for <linux-mm@kvack.org>; Thu, 14 May 2026 10:36:05 +0000 (UTC)
X-FDA: 84765670290.11.ACFA228
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id D5D9D80002
	for <linux-mm@kvack.org>; Thu, 14 May 2026 10:36:03 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mHHxM8IY;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778754963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KNL7AYbzai/U1j7c77tXkkbxWsGmlul60oQNCMe8UQw=;
	b=6OVGRWwrMUf9Zt6WYhv2Cy0zfq2JqCXTT7Rnl+hDkXRs7OeXR4z0PZacwvn6qbA8uErOs0
	LP/4OVfdMoqW42w1qxbI2X304Q2f6IiHW0fcebJRX0mjM5BkcVlMvJVJUN8UkBBWfmbiYQ
	ccECpYStBPdcxqlqRofGwAmvzNSF1ho=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mHHxM8IY;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778754964; a=rsa-sha256;
	cv=none;
	b=k+nTwMKXoRFmh3QDcT7v6mGOtwOBPMow87Q82FoVMenWkJZcZHzrjSiORUS04bluFEaaLt
	ykeMIgK2EsYulUBcJw7cgX8wLashrLgrcRxhUh6QeUpi8E1/SXE10H/1iFXuJ6BtPMTMI0
	FipeH6TXMjc8LLBuHzGT00+S1NC0mKY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EAD26415F4;
	Thu, 14 May 2026 10:36:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BD45C2BCB3;
	Thu, 14 May 2026 10:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778754962;
	bh=sN1fs0XRPPPvWka4xXnCLpw2i+3MHA4unKQRnUFjsDA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mHHxM8IYqAb/7BirWI8nyT5oAZpCcoXWYgKE8jc2SuBxff88LJNCYiFUpcp+sdB/6
	 +fORw3zO6rwnX2XmZxKCAPWrN1ER7NwKnVoMOBiLOZ7B4qR9kvkEchzQKWPvGxlHzh
	 FI+3YleWQJ3N5+QSQmZCibkYNxf7pa2sKMh4+V1QD9Ok+lO5LJoxHdCvXCDmgyGHGu
	 AZM172y6FRl80rXeZc1Qcix4bOeDaPL2dp3DARnB6v6FURixMNjtmHPr7JPzl3cxuc
	 PY+pK2HMk9mHUQWxSzBsmVDXx73XPR3qzjJMIU0dsr0+Y2cazkw8oYyZzT9/gLmbWJ
	 e45reBZZn4OEw==
Date: Thu, 14 May 2026 11:35:57 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Takahiro Itazuri <itazur@amazon.com>
Subject: Re: [PATCH] mm/mmu_notifier: Fix a begin vs. start typo in the
 invalidate range comment
Message-ID: <agWlVTkDMHulegm-@lucifer>
References: <20260513163546.1176742-1-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513163546.1176742-1-seanjc@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D5D9D80002
X-Stat-Signature: 3h6nehdmw4hspd7u6tbdy8yss4xdmsi5
X-HE-Tag: 1778754963-111054
X-HE-Meta: U2FsdGVkX1+w6h9z4iGr8UVVWdeexo9aoVp/sXjmTVWzXKnFPzOypwneUQqeMwmMToWObkCdIk2TEmM98hWbk6rxmvQuIamC0hgwgv+KLN6djXNiMYI3iJ2yvdr9xOjO0tOfu1mWtpY2GJdZO05bZUDpFknFJOPGLaFq5HVduzwFM3VnEnmd29jWjmkgFL7GmW5r3LVBKt+TqfIew7ngaI1/IGfCEAWmrRR8ztkN/WD9rm50eDjRI7pdNTg7zSNjCuZOtecrFGULQPIR0WrpDxIjIw1RXC6Xd6ggn2kXW5Oti25hGvPtmkgA3iPppPg0IzQ6mh5RTHZuB4O8Xym/Lg94IKAN0ag56ksDRa+UXVQAeJddqnO93kFKB54+svcbLiaqW8365s9A/PsiWEa6uJxDyl1SVbH97hDYHv92cNPpblZyj0QQYKINNN9Chhdxf7KHEmqDucD1my3fAXtvT8OcPW7+0SczVc83wftXOZ0gIULAjX2mRZieIrLg0noCzlE5KbgqEFynytvim3Nr9++78hRLUZDhM7yueJ4+g2Ui2Zuo+kf3hvYeFkFEcG6ZQRf+ND6bf+okkTIuTOt6sOQUi6/MHQKI9rzmDjKLS3Pdh0MlZ7bK/0N7mYmCx9T9scJTEP2oWAWNfxfvEuwtkwFJ+PsGujlVOQ2UrtlV7jsTAxrHWRTKa2JHtjsHPTXf4MknTKHc96rdnoa9AL77vGI9klHZuEbaYEgGVZ7WS9bOIbA7bUcYlADEnXwiG52CEpMfKmU7Oid88HcZwPgktrYvkcdRCD897wxNSisT7bWTKaFhzIMN85KDEur3VDjvLtt/Hb4ROIwsXBo6D8Nr0694Mnp8vnRyWUXf24IovZqUh0hqMEh9hFO7WrL0WLgQg6/gYbxmIdiKElqTaD8hSYpQmnhalPNdKtu0Qh54jBUH1H+PRwhv8nV5WhDt/YGxYqU/x4LsSvVstj11vUL
 V7amJrlK
 CwvbZMBDLRNeCJsI9uqSSbFN0M810oS1B9Gv7DY4YJ8/jqluJSB+6+ASitQD5zUBbrSyewNkIEabjNQZ8pc0cahIBlIX4G1/QYSeQ6IQ0QOTHznpqkyB2qz3zkJnkIHSuF379W2dfcZ45HqxIiGvcRP8bqfZRxCkY+PzVku7e9WtSFB6G3iABvYa1S+EYgE8DIsqCIa/20+03g96H12vWIfh6u8440iFD6ZvsC4SF/p++loEReY77GD4c7nyoSB5NB7LJTcptEg3GNJvPOe/Cc9BXVCWBCHVC7tgupGmW55xgj5h7XMzKYHW13CgLX6RgRgNysLIOlMKqZ+f7MgF3ZRVeSyNMxwdgnMczHfxIcVTFuXAvDZbIX5NzaQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 13, 2026 at 09:35:46AM -0700, Sean Christopherson wrote:
> From: Takahiro Itazuri <itazur@amazon.com>
>
> Fix a goof in the block comment for invalidate_range_{start,end}() where
> start() is incorrectly referred to as begin().
>
> No functional change intended.
>
> Signed-off-by: Takahiro Itazuri <itazur@amazon.com>
> [sean: split to separate patch, write changelog]
> Signed-off-by: Sean Christopherson <seanjc@google.com>

LGTM, so:

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

> ---
>  include/linux/mmu_notifier.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
> index 69c304b467df..a11a44eef521 100644
> --- a/include/linux/mmu_notifier.h
> +++ b/include/linux/mmu_notifier.h
> @@ -134,8 +134,8 @@ struct mmu_notifier_ops {
>  	 * Invalidation of multiple concurrent ranges may be
>  	 * optionally permitted by the driver. Either way the
>  	 * establishment of sptes is forbidden in the range passed to
> -	 * invalidate_range_begin/end for the whole duration of the
> -	 * invalidate_range_begin/end critical section.
> +	 * invalidate_range_start/end for the whole duration of the
> +	 * invalidate_range_start/end critical section.
>  	 *
>  	 * invalidate_range_start() is called when all pages in the
>  	 * range are still mapped and have at least a refcount of one.
>
> base-commit: 5d6919055dec134de3c40167a490f33c74c12581
> --
> 2.54.0.563.g4f69b47b94-goog
>

