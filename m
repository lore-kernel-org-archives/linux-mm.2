Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EC92CD4F3C
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 11:53:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D3BD6B0005; Wed, 20 May 2026 07:53:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 784016B0088; Wed, 20 May 2026 07:53:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 698756B008A; Wed, 20 May 2026 07:53:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5A7706B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 07:53:35 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E5751A02A6
	for <linux-mm@kvack.org>; Wed, 20 May 2026 11:53:34 +0000 (UTC)
X-FDA: 84787638348.16.EFB9270
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 16DD5100008
	for <linux-mm@kvack.org>; Wed, 20 May 2026 11:53:32 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S3qna9hO;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779278013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j9XOX2F++5Jy6GzgJFgn3hfr14wEnUQqIZdtQ1XgXtY=;
	b=R7n0rWTPiSdi80UniBhUKKxqFyY3+qBvJ+XYCOLrg7Di1uTfqY3b2QLe73nRJbMQIUf6Sh
	tZTBz6mNs6QQ8kpoCbmk4hn1DIWF2/+G3A0nEtVRrGe1xOA6xVym9plGMnurZyLdfTJq/o
	dftdGQyeZgW2E4VYy5zmh1bXkYiRQbo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S3qna9hO;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779278013; a=rsa-sha256;
	cv=none;
	b=eD5fasyeXneI3eGXpYSWb71r98tvUB9HE2Hz/aI8RfIR/8a8fVzhFOEzhHFcHOyieWi7Md
	DyRiyWs+mILnI+aPVvjXH9+4V6F3e3nV2Hlk6MbG5Jko61vtM6tyeAZNwofGPWUt0QwG7k
	cC3/uH+QTViIGsndY5fM3gZH+KpACzY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 45E7940E12;
	Wed, 20 May 2026 11:53:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 798391F000E9;
	Wed, 20 May 2026 11:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779278012;
	bh=j9XOX2F++5Jy6GzgJFgn3hfr14wEnUQqIZdtQ1XgXtY=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=S3qna9hOPwZdjH4QtJO2kgB1qbUJ4wj1oeonxPxui8dl3Fx9in7i0o1YfNDywTuPQ
	 kfidCEzlcl8wW+NLjEc3FzA6YNREIXrfJLl5qopM8yE7UQ0kVCkWdGZmax8/pFpCb9
	 t42z4SqwJPmEw1bnUWn0eahENt0X5q2P3opBiJyvvuKeSM0fn86fOLfQya62aW3FgC
	 MedAp+RnfnvN/inXhpODfFzCbhdZAPG1+GVAJplqW+quv7lWuii65ck3a2/u6aaH3S
	 IlrS6PlXOyuR4nKlOnDUVQ0GfUGl+nvVRFrgjfT+2bzeV0sUXTAxcvWAEW2BpsoHHB
	 4zTGISwQhpgfg==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 4/7] mm/vmalloc: Extend page table walk to support
 larger page_shift sizes and eliminate page table rewalk
From: Mike Rapoport <rppt@kernel.org>
To: Wen Jiang <jiangwenxiaomi@gmail.com>
Cc: linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org, 
 catalin.marinas@arm.com, will@kernel.org, akpm@linux-foundation.org, 
 urezki@gmail.com, baohua@kernel.org, Xueyuan.chen21@gmail.com, 
 dev.jain@arm.com, rppt@kernel.org, david@kernel.org, ryan.roberts@arm.com, 
 anshuman.khandual@arm.com, ajd@linux.ibm.com, linux-kernel@vger.kernel.org, 
 Wen Jiang <jiangwen6@xiaomi.com>
In-Reply-To: <20260514094108.2016201-5-jiangwen6@xiaomi.com>
References: <20260514094108.2016201-1-jiangwen6@xiaomi.com>
 <20260514094108.2016201-5-jiangwen6@xiaomi.com>
Date: Wed, 20 May 2026 14:53:16 +0300
Message-Id: <177927799624.3551615.1232032128494296554.b4-review@b4>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1373; i=rppt@kernel.org;
 h=from:subject:message-id; bh=bCtY3KU6h249ANRsmgcaVTs6KjwNWS62y3TRFsQSYpI=;
 b=owGbwMvMwMVoydymdprv70TG02pJDFm8CzbuT6zdfuz7T7nMN6UzLVpXdu/99mXvTSHNnT0pu
 yb8tTh8tZPRmIWBkYtBVkyRpeJpROjSmfrzSy6ufwkziJUJZAoDF6cATOTjQQ6G7l/GBmWGC9Nk
 rrsvqM2R+7X4scUHboapzkcuM2X0d2ueOFdz041piaGC0fz5u3YuOlx9+uOciDOn+//5ZZ8KZNz
 dw/Dtdb+u/J/iDk5hxrXfbbcllt46/cbXy5epb+3+R9vPr6+K4ZmtmvhfmKHcJWdql92aJ7sFOX
 4oRJdYb35cI6drvCmikKMqhrHtOu9xxkC/GCVX2R1cwayR541NJir6/mXNi71zLOOybJ07R/W+j
 pzeVBMhxTkSYYtF6ra3Pi+6/SHUztxE0ymZZ/k8W0c98ZPRG5Yb/M84qPrt3/5T1Ts489QbfeNy
 y+USrMJcTv/hk/b+HG3M+TN+vXrol13eArnFiW1d52N7AA==
X-Developer-Key: i=rppt@kernel.org; a=openpgp;
 fpr=B8E96E880C4A40C3C1255AA8C532392DE6DA7CE9
X-Rspam-User: 
X-Rspamd-Queue-Id: 16DD5100008
X-Rspamd-Server: rspam06
X-Stat-Signature: whisxse8uhb1pdcrzjgyfhihz9ojp4h8
X-HE-Tag: 1779278012-598937
X-HE-Meta: U2FsdGVkX1/WgglbPg14L4Qp9V8dHrmo+VzHv5momPiYZBZOvKaJ3hLyPV4rRJNhUTEQ/KqAngoN7GDLIMun34ilf+GGyitD01tqCIX0hHIai4akESHSOVyDr6DgZ4riIxJKRE/esbi26pPbFC4LPPbmtDIMkH6kAE32DYyWYCTie3PRFEcVJmICO8qco8KKk1/6bkzaVOgdiUvP32jVMhRtclWHZPmuarKUes0gt/8pMOQWlsYMDVdVsG7tQg817x5sAtOGNzrpvMJQHLFa2IQldLgxyReRzt7OfjbTk/RPmsmKbcsDV5k4PFTyQzlWVHh8MQeBz8kulV4vx4XxmD9yflElEBlFi/iOmsN0jU6YBxItXdkqMx8XMNEZvWP8kYIvX4klVlhJAViYd0jVG4OO2RyZpRtOHXLD3Ic3l1hiNYg6NYPx4xaPWnmjDMuHNPA3NMMEoz/KOsRG5p2GpImSei498xuYlc4etJfohbJw4w2dKrmvDaofb1lqAuBmxhY6av6vxdm0P8OzNbi9DF0yT30i+s/vO8BBq3ckFHra52YSIiqwvynRmCdfTkxXVd5d0Q/u5B/u/Hj7cWrq9RP5lacxs26aB1vXC2ke+vSk9QqF7uNR8O+d1J/p0uiPVWcivieTSdYCIGc9fnm1Yppt8ToCDtn38gEwRVvXupKtIC4QhK5hqBoDGpp3b2rX1S0r6JAKSUyseu7EOszAMve+FJc/T4Mtl28g6JpaQQnmzCWoq3LN6XFUJdIHYf2BV8PjDEWRyOs1nrpq8Lu67nLq2KeGRb9R7hTKwxDMmRo9mUqSMZBDd/APJS72nUeH4w/EcrqqFMOtl5IazO49gTW+mfLBj6Ba8qNmSSGmAUl833f6/hfB2Q5qyGDhBuwB2PoTyDD5qbgoLIrBEw7QkAMv2KWdkDOS4SFsCMbrzXJBRyYU5hCEWDkJKFa34i3cLG5jmEW1Cnn5Qho2BTO
 2RnN4m89
 BlYi6SLMfa+vejQdwfWGWUW6F/Q1tRiJBjWeczAPwtflqNgQqnoY4psDB2Og5U/GlwC7+gIolqI9alph4o/aG08ZpGbHFA3gBx2yPWQAgmN0HXumy5SQYJm0rmp4dXV36lssnSMdhB1vzHn/rCgnirm/eK52eDA2czRDu2xRif8iSWREWOyHJgtkFPHOtS+qo2k4k7U4TzuMqYwkFuJ+QZNe6YMsjG7JteoFMXkkVhjn/RS22SHz6+oyMJ85GTjy9tvZogy5tmoZjVLAI0reh+myfb1fAITdufyEiQ32BdAy4oaz0z9eLIpX54idjus+TPgRcisncXr5odWh1dBAgZ7P2IMDNrqrsNfDMVStsdn95+iz81uBBnvTh5c9tnRQLl9CbSVAeVcrUunE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 14 May 2026 17:41:05 +0800, Wen Jiang <jiangwenxiaomi@gmail.com> wrote:

Hi,

> vmap_pages_range_noflush_walk() (formerly vmap_small_pages_range_noflush())
> provides a clean interface by taking struct page **pages and mapping them
> via direct PTE iteration. This avoids the page table rewalk seen when
> using vmap_range_noflush() for page_shift values other than PAGE_SHIFT.
> 
> Extend it to support larger page_shift values, and add PMD- and
> contiguous-PTE mappings as well. Rename it to vmap_pages_range_noflush_walk()
> since it now handles more than just small pages.
> 
> For vmalloc() allocations with VM_ALLOW_HUGE_VMAP, we no longer need to
> iterate over pages one by one via vmap_range_noflush(), which would
> otherwise lead to page table rewalk. The code is now unified with the
> PAGE_SHIFT case by simply calling vmap_pages_range_noflush_walk().

After this patch we have two very simalar page table walkers:
vmap_pages_range_noflush_walk() and vmap_range_noflush().

The subtly differ at what levels they try huge mappings, how they
account page table modifucations and, at last vmap_range_noflush() is
left without support for contiguous mappings.

Is there a fundamental reason to have two page walkers?
Is there a reason not to support contiguous mappings in
vmap_range_noflush()?

-- 
Sincerely yours,
Mike.


