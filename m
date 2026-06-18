Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73C1FCD98ED
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 08:19:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 646046B0096; Thu, 18 Jun 2026 04:19:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61E086B0098; Thu, 18 Jun 2026 04:19:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50D936B0099; Thu, 18 Jun 2026 04:19:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1D86F6B0096
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 04:19:25 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9AAB7120687
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:19:24 +0000 (UTC)
X-FDA: 84892333848.10.0579AB8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id C3F151C0009
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:19:22 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="HoKv/x5q";
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781770762;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gqhDjzcGQdhdiLmBswp+dNP5/7Fhe1q9r4L1hH6XVBs=;
	b=4OpF5q6Rm1UkY/za4Mmq2B/jBV5cp+p8TXaPcK+ypxSR+7346adrAfocKjigsRnFcxHn8z
	+/PIh418I7zsGf+RWTh2U/UHeDkcrywrxDg/EecKCHdQMHDh+8S14Fwt25lT+0pH24lhQJ
	rD63UtIbOGJ8qlTBQiO+m2qePoQE6f0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="HoKv/x5q";
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781770762;
	b=p7xedgqXixpGiXAy7Xchi5P1vR7NmXKIf9+bYnyIkR928I6oU3muyMF2r89ao9IkQ6SRnL
	8tEV/77qcRwNbSh46kcrq3Q9zTc5CElTd2IqyXVVHJV2fCh5NRffTnVXH+Ww0u9W2IaSlF
	n9fnQGvmkL3FuZ07SOINw9oPIaomyOk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E4CAC405A4;
	Thu, 18 Jun 2026 08:19:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A6BF1F00A3A;
	Thu, 18 Jun 2026 08:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781770761;
	bh=gqhDjzcGQdhdiLmBswp+dNP5/7Fhe1q9r4L1hH6XVBs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=HoKv/x5qawc4vbnWhIlfsU7cwH1p9bEM3g1xxvwHyOcekWMM/TBDs2xjtjxO99qiI
	 9XBRk3tp2HG7UyUOpbx1jiUYhdqJA7RYrTFlJ09mHzzKR/Ag6odb2C0uy663SPNkT3
	 +qZOXaLc3qAyKz8fi5DDoWnODwDu/8usmSOuxx/F3P2knL07OdHDVGtt1GPxaoctyZ
	 1O16iHdbqq3s+37Vb9e6xTiKVRQ6pg7YYqD4l7tKV6nc1n+f3+NK3lT9MCW1xTtNLK
	 FmmK95zIZHxwJ5oZpHVWiJSsxUNqRcy0wGGuGFRrVjKN2n1XBLR6nMsL4tt6muqDT4
	 pbwv1MmHKoQtg==
Message-ID: <5a993689-f730-406d-8515-8bb6025cc851@kernel.org>
Date: Thu, 18 Jun 2026 10:19:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] userfaultfd: prevent registration of special VMAs
To: Mike Rapoport <rppt@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linuxfoundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Oleg Nesterov <oleg@redhat.com>, Peter Xu <peterx@redhat.com>,
 vova tokarev <vladimirelitokarev@gmail.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, stable@vger.kernel.org
References: <20260617194059.2529406-1-rppt@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260617194059.2529406-1-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C3F151C0009
X-Stat-Signature: db1xt9grkjy56sw9q3rjygg6otduat7p
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781770762-745911
X-HE-Meta: U2FsdGVkX19mbZl9Zq9FLRtQLOR9jCrOAxbKWRCDCrqasCwU77cLK+zaqoS5t21q0pvaJJu7THYyyFyG5s6S7dSASRSeGARPukfuECTVy8LvkDGbvJmICY4dZwkWzkcaJ0602Ita6Dm7pd46Ye9siGnjN6oMgErmDBfo3nx2/ncF3z1IFjrQo1ixertwZSmWgf1jS5WMI970BcbpxT/mo4O/BORZsl0ht4tjpGWsmZldt8RGxQv+ygnnT+aNPdB27olRBWYUJ5B+VHD0FRmaYH/59OjERWEniJ0KdgCdy1sJMNdXqdn+6ZLvJ44LH2lFI+TEtcMJ3CDUsiDjq6kwhdbeDHSVE1/bctiA3Ha4dCEDNwS8qz8VRTkpdz2Wi8xDP5zabKGxc+Y3SsTGZW03Sgh/x9+xRxzFQzkuazUlL6DozzlpqDN5KfY0g/iM4cDCO71jLbEQtNG025/PWDSWAjJ2cbgq21j7tb/1CC6m01jQjHhItJeGshhiFcVSNdhNgk/qzjVxcGD/4TaYT4pSJ1e0vVwKHw0Dw+SoiZuWJuZOl/hAUmny71TqSsbasWTEsFGTwTYwQgJghK1pq/c31XZ4J8f+DazF2SxR0rWFauz/j8yTecj6nW1seRfYeUjfWsupkXBHj37BOWpKGr5OfVYaXw/19A84/0qqqFjSNNI8THQCpqHSnPcPKvC5YBkwGPEjXv7CdRdM76gvuC9YZiRfail3LDDPMjji4rLpUpNXi5drfsSMueTglVnD3WvbheEyycZc40g0PanBK48kh4xKAOZzbnAPVZQZVeAfIoeWMOu/g/L/lOq7ryQRFzDqW7ZzUxV9dAEDr2GQDr/ik0KDpt0Jbil+BZOazqwcUiame7xV8TVNBucLzb92fqkixjYOdZCRDDczbX6BZFUADqyekpan2b8vdUKQ5jaSa07K1shm1h09xgsKj5tdfjMZ+rVkYQuOMREIofYQwVz
 kiBaG1Vp
 WAwQ/ZvyKsp7l/ST7DEUOeO8OoX8mLvlV3tWRcKzKooI6uiUT0qHpo/rpAw8PUv3GJ6UDUn+IkTciXxInoW30hVuGGFCebjx3PrwVdZEcAylqbE1BuX1tDTZXA2+utLfqvz3jOhpaWp4FFMknxmWWYqsndbTRQgfsb+eMJzB+xHZQWRtJqrlWW02hfpPdyg86mhey2IjvBAbrC17YSXyrlAecQuPBiqeRMS17ds3+pLAUQ7lVon+mCliDZBWB6mG3d/sn9JGVbzW0oixcFEXHnXTjhb3wkGvsNz+h1gSsykQRDndbyGBLF5sQFw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/17/26 21:40, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Vova Tokarev says:
> 
>   userfaultfd allows registration on shadow stack VMAs.  With userfaultfd
>   access, you can register on the shadow stack, discard a page ... and
>   inject a page with chosen return addresses via UFFDIO_COPY.
> 
> Update vma_can_userfault() to reject VM_SHADOW_STACK.
> 
> While on it, also reject VM_IO, VM_MIXEDMAP and VM_PFNMAP so that if a
> driver would implement vm_uffd_ops, it wouldn't be possible to register
> special VMAs with userfaultfd.
> 
> Reported-by: vova tokarev <vladimirelitokarev@gmail.com>
> Fixes: 54007f818206 ("mm: Introduce VM_SHADOW_STACK for shadow stack memory")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  mm/userfaultfd.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index 246af12bf801..b8d2d87ce8d7 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -2111,7 +2111,8 @@ static bool vma_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags,
>  {
>  	const struct vm_uffd_ops *ops = vma_uffd_ops(vma);
>  
> -	if (vma->vm_flags & VM_DROPPABLE)
> +	if (vma->vm_flags & (VM_DROPPABLE | VM_IO | VM_MIXEDMAP | VM_PFNMAP |
> +			     VM_SHADOW_STACK))

I'm sure you considered VM_SPECIAL, which additionally includes VM_DONTEXPAND.

Would that be better, or what was the reason to allow VM_DONTEXPAND?

-- 
Cheers,

David

