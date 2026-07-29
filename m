Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFB1CC53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 16:45:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA2816B0088; Wed, 29 Jul 2026 12:45:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4CAC6B008A; Wed, 29 Jul 2026 12:45:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93BFD6B008C; Wed, 29 Jul 2026 12:45:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6E1E56B0088
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 12:45:37 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0518EC0715
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 16:45:36 +0000 (UTC)
X-FDA: 85042390314.13.E99DFA7
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	by imf15.hostedemail.com (Postfix) with ESMTP id 2931BA000F
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 16:45:34 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=H3zmvAkT;
	spf=pass (imf15.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.53 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785343535;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3ZiDYlOZHMR29bIdu7HPNBG+9FYDGI/12tsRJlqZmQI=;
	b=aeJ5ZQBXGFndgip3WjGZRv9uZKsG3btJoA1LM9LBXNSNOW4jOaEeYGQIGbUjf81C57n1Pn
	ShjFHSp9Urnz44C0d8+R20uYH+svdRaP/+dB2IVXlXCwC7ehZCw76fF+FoXTSN/ac1dhmr
	NeqBOYVX6kR3v3zfVElL+cyuPUS7pWo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=H3zmvAkT;
	spf=pass (imf15.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.53 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785343535;
	b=zmyWdrb6xoXVymbv82ekqx3b83cNkB5EocEAVgGec1RD1E5k4aRxcKZ1fHEkIWZhMlCHeO
	JswLflDlgKlApnzw9lVHkrFBefMlyKSQsqEJAKazTjzQxQGeCcfn914xfCPaQF8hLa+nSE
	NiHclVP9qlPrc80phws95GletDoRhZY=
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-8efec2c28f8so7884056d6.2
        for <linux-mm@kvack.org>; Wed, 29 Jul 2026 09:45:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1785343534; x=1785948334; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3ZiDYlOZHMR29bIdu7HPNBG+9FYDGI/12tsRJlqZmQI=;
        b=H3zmvAkTr5Cb+aOlcNwzH9Gapd6T2EzGrGwdKpi2/2JMvXfXJHeLp6+nYdyMwjDeIG
         x0d1OqsGx5TgFm2+ICmKLt1b0utZ+B2IZ0LBb6fMWr1wBEObRPhLuazMBca0e5flflkj
         cgz2N8zOM4rQl7MjhKUGw/nPSQC2AP6273YOc8PMjqTiwkYBpK9knOZnHJNzPCTjffmm
         6aprniQT/SeerHW/12A+Z7kO5e4qvD9cnL8RTPDP/R5jI7oXhkFfYSPi0um5j2IIuV8p
         SsCgw8M60Nxskm/1ZpFQ3PCTlVxjZ0hC6bHV/eWfsAU+a0L6G5YkPnkg01RTLycQGHbf
         2TTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785343534; x=1785948334;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3ZiDYlOZHMR29bIdu7HPNBG+9FYDGI/12tsRJlqZmQI=;
        b=P1jNpDGoKBMi7BiVVTkbt3BaLUDZquk2mJ8kmsA9HwQUwjZl1OphAWF5FaxcbcCu8W
         RTDpFOw6Z3gZu6fm5Y1kuqDlWAhQvx5NoB+SQO1eI8Bk1OLSMjDW8TEGH06I5HcXhuOR
         s8YzFoPrSmFjWKZKn5pyso2G89EKtdC5v2DRLFk1n5PTBZoCXv7OGkWW4WBM7OsaehU5
         E/+coKXqp0fBlnGPv2QkZcW1+d9Di/aIuxYXRZDIGks3/WiNyxlz+5ycZQjyD74AzHBn
         BouufDhC22/sdcFNq+X2GNzAE5OQhwpN5r7/9XnUpxlZ1/sZxwEVxjhBqqH/5A3+D0EV
         Dg5w==
X-Forwarded-Encrypted: i=1; AHgh+RpAeSEf2j+4I8i76a9TRyXK2HZsmkpPoKp7ZS9zj59kvyGFZXT2njh+yujwRuzSmfC+qoHF/BRDYQ==@kvack.org
X-Gm-Message-State: AOJu0YxAxKDnJpoUBB1LlFOf5bv+QL60ZMN1ZomNdRzGujnrHTi5NkCg
	bmDiWcbWgRp5x5elKy+JLt8KXQcb6tPz884nOpcUGYMHG+2NixJKInIzerwGFXb6leA=
X-Gm-Gg: AR+sD110Zfnu9pgZ+ovwuwNEmBLgiH4DCOVQ5LITeOU5ZIlAQOn49GbhrbXNiGQJPBX
	ujfzRXDgbMJNs+Y9RuSPtJzlq0FBBbU1b2TC37e8wKS1jXObIutDTi8jx5DbqtE4oSnT4IIHVeQ
	YTGt31RDxtAps48lT23yO6bSHI4/QgpFGfk/7Bcgh/OCHUYxBInwiDp8MstH5+PkzOqz8rXT0ya
	4OGkq0F43kz8jHkwzreYmOvGRALskHhEUliqa1lFCfRM1x+nh9qXRdMtzPjOomdkH9bbdquVJaj
	LPNCyhWPXEi3eiRAMgOd2k9xObXx8mQmUtqXMK8RFurXRtfxLzHE8TVEhCU1ZTkvwZo354PbUyJ
	gyzCe2ex47HaGju01xZN/7zYmFXzEPsbfcWUoJ96JnsQJ/bmAJOsTBe9ltPx+XmOYLtm0I0iOy+
	E5DiayLmGl114/CspoVnVws1CJyh0yfriuYXAhLaAVZR8F6E3Ok2QQ5Av/PKt5mGlJzfVe6UHe9
	WXgGb5JATYpOx4P2KBUd0qVPcc888FEJ63SrxDnHVRi
X-Received: by 2002:a05:6214:3213:b0:904:4275:e165 with SMTP id 6a1803df08f44-90816f81939mr87398986d6.19.1785343534135;
        Wed, 29 Jul 2026 09:45:34 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9081f77f713sm24503226d6.17.2026.07.29.09.45.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 09:45:32 -0700 (PDT)
Date: Wed, 29 Jul 2026 12:45:30 -0400
From: Gregory Price <gourry@gourry.net>
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	Christian Brauner <christian@brauner.io>, Jiaqi Yan <jiaqiyan@google.com>
Subject: Re: [PATCH v7 06/13] hugetlb: Use the has_hwpoisoned flag
Message-ID: <amot-Zo0qsspKvKK@gourry-fedora-PF4VCD3F>
References: <20260728204409.3396238-1-willy@infradead.org>
 <20260728204409.3396238-7-willy@infradead.org>
 <amlQYkGgLmxmwX9_@gourry-fedora-PF4VCD3F>
 <amlrjtaFSEQLYbEO@casper.infradead.org>
 <amoWqtYhXm9_Bxhf@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amoWqtYhXm9_Bxhf@casper.infradead.org>
X-Rspamd-Queue-Id: 2931BA000F
X-Rspam-User: 
X-Stat-Signature: mqw3rxg3f8hapqc1pjfiitb3mtsxy7xq
X-Rspamd-Server: rspam04
X-HE-Tag: 1785343534-342180
X-HE-Meta: U2FsdGVkX1+8h4Itq/8Bal4ukQ7IqIAtiU6AwAgr4Kp+dTLTkBw4vohcNE4E1gHmMuKnhg90MqQjX8njFUXGaje2bFmcDyFs7o69M+Cusyxh+lL2lnOo36S0ps6+RT7kSNxflxITW9eLo05dIufcp0PDC4YBewPI03bfnhtikTcvV45VH50oABTTdKJelsAACH1d/mPrI5mXQZts+DhanufhzsibwaEbqyrJuZP6zV3ZoJamMLXdnuvarFFcfbaz0QwId9WpG6ISpAEbwsZdssRPpkUm6OHkdj52CSC0lq0ZF/2Q5H839Xq3cupfFWCk0nseST+rcggU4XxUK8BXfXhcOGJtZQ1wXuTrr/TJqleG1DzwUCpuQqKi2dPCi+6Ut1bGwrsdKUno71C8FIc5oqRh8pEMRJw26dSrkH6F7K3seXZiqoGrhAMWkOOK/xDs4HQSLio88kX7Zb8GWTy0VYTwq1VtQ6H+kIiIjMDWjL5E2nUZtWTdRV0HJGFTEunEWlw8iTv5KGQw+yGQoTedz5y0lO0GWALNv6AMFEVyfbieTi2yvBqdZbI980FqaqqCjZd4PumoIAnfTruRH0FuhANmFPeV7efdCPYUe9yX3j5fFCrvmk7Nh4nR/bqsp34ASHV7KlklZ++dBFB7BZMiTNU32c16//yzLqFsYQpLxOqGqpjwPjYRlCLeofC3XIpMJWybdY/8Uyvm1dKcnWULfiSIB7GU9iab8lbShTnwjc4x4HtAkGTKwVeIhJdYN+VaXhYz6dcrtE1+2nAfdxm0OGJUG0H2Oh7qsNlYeG+XUK2vm1MtYuBnnmmA9+ywnRn0B34IT9T2JFP/UWJ/j5DpGWCTV1JW88TX6WiohiajuEqn2EM+JDOCqIKkc6n6BvPozft6fYhCtUGCyE50T5/gXPkv1O1hXy0GWfd+O7C20PAe6Ge5sREL6qGRpHobZ7+i0uia36ZzrhwLIaM8TXH
 fFrxJhC3
 zN8OozOxL4LSUxZ0xf11WiKRm5qjGZt0bP7yV6UmT3s3vdAqILXb90Iw0ziw4QcwwVVbJ9LTwY1nxLLlKs/Lnh7qHD9dfJdjpRU+A+BYX33UVA0oHAuyQYlcCYr4axIMQN1ngQMviz35x5HC+Nf+BZW2VN6b4qBqEoQC6KNV1cOy8d4Ehqg/4MhY9gkaIpXWAZ5HSUERvAaok+oOtuumBfGSPe7Nz1JeG7xotVpwyIH2MfzAUaXzBCK2l1J647lAGuFxzOuTRmgEowBzaV1DhjTAhQiYjXoA+FAWyKR9bqIc1KlmKu9WP78rUdX57nE2tZUfDc+m5ubLjvWcH8r51qOhxv2p7m5g848weGhP7Bww90zHtE4myqL4thTkJCFty2UtmGou14bBbo3VbiZ1O9wl1hMQ2r/1N40Wy3S5q770WVSAQVd2Qs6Nv+GaudTvv4RYBj/E1gQ/buw7kB0NE/McrLXX7ZJrbg131FSiVaeiibsmOfM+gEmRLZMg/+4VvuGvNJvKk6lTovylDXM6+/dPeUT5haTpGXmAzlJeJBRnB+KF4YBvZik++rcrzyTzhZLTe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 29, 2026 at 04:05:14PM +0100, Matthew Wilcox wrote:
> On Wed, Jul 29, 2026 at 03:55:10AM +0100, Matthew Wilcox wrote:
> > > > @@ -2725,13 +2748,19 @@ int unpoison_memory(unsigned long pfn)
> > > >  
> > > Adding new synchronization here without noting why - it's not
> > > immediately clear what this synchronizes.
> > > 
> > > Is this just fixing an unrelated bug / should it be a separate patch?
> > 
> > This prevents a hugetlb folio (which in this arm we don't have a
> > reference on) from being freed.  I think it ended up in this patch
> > because Sashiko pointed out the race during review of this patch.
> > It could probably go in its own patch 
> 
> OK, split out into its own patch.  The 0day bot chewed on it a bit and
> came up with a config that enabled MEMORY_FAILURE and disabled HUGETLB
> which showed a missing hugetlb_lock symbol.  Here's the new patch:
> 
> commit 9df49152f5de
> Author: Matthew Wilcox (Oracle) <willy@infradead.org>
> Date:   Wed Jul 29 08:41:50 2026 -0400
> 
>     memory-failure: Prevent hugetlb freeing during unpoisoning
>     
>     If we fail to get a reference on the hugetlb folio, then it might be
>     freed as we operate on it.  Prevent the freeing and the attendant races
>     around manipulation of the raw_hwp list by holding the hugetlb_lock,
>     which is also held by the hugetlb code when freeing hugetlb folios.
>     
>     Fixes: ac5fcde0a96a ("mm, hwpoison: make unpoison aware of raw error info in hwpoisoned hugepage")
>     Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> 

nice - if/when you respin or submit this separately:

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>


